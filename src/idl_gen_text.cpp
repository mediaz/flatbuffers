/*
 * Copyright 2014 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// independent from idl_parser, since this code is not needed for most clients
#include "idl_gen_text.h"

#include <algorithm>

#include "flatbuffers/base.h"
#include "flatbuffers/code_generator.h"
#include "flatbuffers/flatbuffers.h"
#include "flatbuffers/flexbuffers.h"
#include "flatbuffers/idl.h"
#include "flatbuffers/util.h"

#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
#  include <../../stduuid/include/uuid.h>
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS

namespace flatbuffers {

struct PrintScalarTag {};
struct PrintPointerTag {};
template<typename T> struct PrintTag {
  typedef PrintScalarTag type;
};
template<> struct PrintTag<const void *> {
  typedef PrintPointerTag type;
};

struct JsonPrinter {
  // If indentation is less than 0, that indicates we don't want any newlines
  // either.
  void AddNewLine() {
    if (opts.indent_step >= 0) text += '\n';
  }

  void AddIndent(int ident) { text.append(ident, ' '); }

  int Indent() const { return std::max(opts.indent_step, 0); }

  // Output an identifier with or without quotes depending on strictness.
  void OutputIdentifier(const std::string &name) {
    if (opts.strict_json) text += '\"';
    text += name;
    if (opts.strict_json) text += '\"';
  }

  // Print (and its template specialization below for pointers) generate text
  // for a single FlatBuffer value into JSON format.
  // The general case for scalars:
  template<typename T>
  void PrintScalar(T val, const Type &type, int /*indent*/) {
    if (IsBool(type.base_type)) {
      text += val != 0 ? "true" : "false";
      return;  // done
    }

    if (opts.output_enum_identifiers && type.enum_def) {
      const auto &enum_def = *type.enum_def;
      if (auto ev = enum_def.ReverseLookup(static_cast<int64_t>(val))) {
        text += '\"';
        text += ev->name;
        text += '\"';
        return;  // done
      } else if (val && enum_def.attributes.Lookup("bit_flags")) {
        const auto entry_len = text.length();
        const auto u64 = static_cast<uint64_t>(val);
        uint64_t mask = 0;
        text += '\"';
        for (auto it = enum_def.Vals().begin(), e = enum_def.Vals().end();
             it != e; ++it) {
          auto f = (*it)->GetAsUInt64();
          if (f & u64) {
            mask |= f;
            text += (*it)->name;
            text += ' ';
          }
        }
        // Don't slice if (u64 != mask)
        if (mask && (u64 == mask)) {
          text[text.length() - 1] = '\"';
          return;  // done
        }
        text.resize(entry_len);  // restore
      }
      // print as numeric value
    }

    text += NumToString(val);
    return;
  }

  void AddComma() {
    if (!opts.protobuf_ascii_alike) text += ',';
  }

  // Print a vector or an array of JSON values, comma seperated, wrapped in
  // "[]".
  template<typename Container, typename SizeT = typename Container::size_type>
  const char *PrintContainer(PrintScalarTag, const Container &c, SizeT size,
                             const Type &type, int indent, const uint8_t *) {
    const auto elem_indent = indent + Indent();
    text += '[';
#  if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
// clang-format off
    if (!size)
    { // do not spare a line on empty arrays
      text += ']';
      return nullptr;
    }
// clang-format on
#  endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
    AddNewLine();
    for (SizeT i = 0; i < size; i++) {
      if (i) {
        AddComma();
        AddNewLine();
      }
      AddIndent(elem_indent);
      PrintScalar(c[i], type, elem_indent);
    }
    AddNewLine();
    AddIndent(indent);
    text += ']';
    return nullptr;
  }

  // Print a vector or an array of JSON values, comma seperated, wrapped in
  // "[]".
  template<typename Container, typename SizeT = typename Container::size_type>
  const char *PrintContainer(PrintPointerTag, const Container &c, SizeT size,
                             const Type &type, int indent,
                             const uint8_t *prev_val) {
    const auto is_struct = IsStruct(type);
    const auto elem_indent = indent + Indent();
    text += '[';
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
// clang-format off
    if (!size)
    { // do not spare a line on empty arrays
      text += ']';
      return nullptr;
    }
// clang-format on
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
    AddNewLine();
    for (SizeT i = 0; i < size; i++) {
      if (i) {
        AddComma();
        AddNewLine();
      }
      AddIndent(elem_indent);
      auto ptr = is_struct ? reinterpret_cast<const void *>(
                                 c.Data() + type.struct_def->bytesize * i)
                           : c[i];
      if (type.base_type == BASE_TYPE_UNION && type.enum_def &&
          !type.enum_def->is_union) {
        ptr = c.Data() + (flatbuffers::SizeOf(type.enum_def->underlying_type.base_type) * i);
      }
      auto err = PrintOffset(ptr, type, elem_indent, prev_val,
                             static_cast<soffset_t>(i));
      if (err) return err;
    }
    AddNewLine();
    AddIndent(indent);
    text += ']';
    return nullptr;
  }

  template<typename T, typename SizeT = uoffset_t>
  const char *PrintVector(const void *val, const Type &type, int indent,
                          const uint8_t *prev_val) {
    typedef Vector<T, SizeT> Container;
    typedef typename PrintTag<typename Container::return_type>::type tag;
    auto &vec = *reinterpret_cast<const Container *>(val);
    return PrintContainer<Container>(tag(), vec, vec.size(), type, indent,
                                     prev_val);
  }

  // Print an array a sequence of JSON values, comma separated, wrapped in "[]".
  template<typename T>
  const char *PrintArray(const void *val, uint16_t size, const Type &type,

                         int indent) {
    typedef Array<T, 0xFFFF> Container;
    typedef typename PrintTag<typename Container::return_type>::type tag;
    auto &arr = *reinterpret_cast<const Container *>(val);
    return PrintContainer<Container>(tag(), arr, size, type, indent, nullptr);
  }

  const char *PrintOffset(const void *val, const Type &type, int indent,
                          const uint8_t *prev_val, soffset_t vector_index) {
    switch (type.base_type) {
      case BASE_TYPE_UNION: {
      if (prev_val && type.enum_def->is_union) { // This is a union type
        auto union_type_byte = *prev_val;  // Always a uint8_t.
        if (vector_index >= 0) {
          auto type_vec = reinterpret_cast<const Vector<uint8_t> *>(
              prev_val + ReadScalar<uoffset_t>(prev_val));
          union_type_byte = type_vec->Get(static_cast<uoffset_t>(vector_index));
        }
        auto enum_val = type.enum_def->ReverseLookup(union_type_byte, true);
        if (enum_val) {
          return PrintOffset(val, enum_val->union_type, indent, nullptr, -1);
        } else {
          return "unknown enum value";
        }
      } else { // This is an enum type
        PrintScalar(ReadScalar<uoffset_t>(val),
                      type.enum_def->underlying_type, indent);
        return nullptr;
      }
      }
      case BASE_TYPE_STRUCT:
        return GenStruct(*type.struct_def, reinterpret_cast<const Table *>(val),
                         indent);
      case BASE_TYPE_STRING: {
        auto s = reinterpret_cast<const String *>(val);
        bool ok = EscapeString(s->c_str(), s->size(), &text,
                               opts.allow_non_utf8, opts.natural_utf8);
        return ok ? nullptr : "string contains non-utf8 bytes";
      }
      case BASE_TYPE_VECTOR: {
        const auto vec_type = type.VectorType();
        // Call PrintVector above specifically for each element type:
        // clang-format off
        switch (vec_type.base_type) {
        #define FLATBUFFERS_TD(ENUM, IDLTYPE, CTYPE, ...) \
          case BASE_TYPE_ ## ENUM: { \
            auto err = PrintVector<CTYPE>(val, vec_type, indent, prev_val); \
            if (err) return err; \
            break; }
          FLATBUFFERS_GEN_TYPES(FLATBUFFERS_TD)
        #undef FLATBUFFERS_TD
        }
        // clang-format on
        return nullptr;
      }
      case BASE_TYPE_ARRAY: {
        const auto vec_type = type.VectorType();
        // Call PrintArray above specifically for each element type:
        // clang-format off
        switch (vec_type.base_type) {
        #define FLATBUFFERS_TD(ENUM, IDLTYPE, CTYPE, ...) \
          case BASE_TYPE_ ## ENUM: { \
            auto err = PrintArray<CTYPE>(val, type.fixed_length, vec_type, indent); \
            if (err) return err; \
            break; }
            FLATBUFFERS_GEN_TYPES_SCALAR(FLATBUFFERS_TD)
              // Arrays of scalars or structs are only possible.
              FLATBUFFERS_GEN_TYPES_POINTER(FLATBUFFERS_TD)
        #undef FLATBUFFERS_TD
          case BASE_TYPE_ARRAY: FLATBUFFERS_ASSERT(0);
        }
        // clang-format on
        return nullptr;
      }
      default: FLATBUFFERS_ASSERT(0); return "unknown type";
    }
  }

  template<typename T> static T GetFieldDefault(const FieldDef &fd) {
    T val{};
    auto check = StringToNumber(fd.value.constant.c_str(), &val);
    (void)check;
    FLATBUFFERS_ASSERT(check);
    return val;
  }

  // Generate text for a scalar field.
  template<typename T>
  void GenField(const FieldDef &fd, const Table *table, bool fixed,
                int indent) {
    if (fixed) {
      PrintScalar(
          reinterpret_cast<const Struct *>(table)->GetField<T>(fd.value.offset),
          fd.value.type, indent);
    } else if (fd.IsOptional()) {
      auto opt = table->GetOptional<T, T>(fd.value.offset);
      if (opt) {
        PrintScalar(*opt, fd.value.type, indent);
      } else {
        text += "null";
      }
    } else {
      PrintScalar(table->GetField<T>(fd.value.offset, GetFieldDefault<T>(fd)),
                  fd.value.type, indent);
    }
  }

  // Generate text for non-scalar field.
  const char *GenFieldOffset(const FieldDef &fd, const Table *table, bool fixed,
                             int indent, const uint8_t *prev_val, const StructDef* struct_def) {
    const void *val = nullptr;
    if (fixed) {
      // The only non-scalar fields in structs are structs or arrays.
      FLATBUFFERS_ASSERT(IsStruct(fd.value.type) || IsArray(fd.value.type));
      val = reinterpret_cast<const Struct *>(table)->GetStruct<const void *>(
          fd.value.offset);
    } else if (fd.flexbuffer && opts.json_nested_flexbuffers) {
      // We could verify this FlexBuffer before access, but since this sits
      // inside a FlatBuffer that we don't know wether it has been verified or
      // not, there is little point making this part safer than the parent..
      // The caller should really be verifying the whole.
      // If the whole buffer is corrupt, we likely crash before we even get
      // here.
      auto vec = table->GetPointer<const Vector<uint8_t> *>(fd.value.offset);
      auto root = flexbuffers::GetRoot(vec->data(), vec->size());
      root.ToString(true, opts.strict_json, text);
      return nullptr;
    } else if (fd.nested_flatbuffer && opts.json_nested_flatbuffers) {
      auto vec = table->GetPointer<const Vector<uint8_t> *>(fd.value.offset);
      auto root = GetRoot<Table>(vec->data());
      return GenStruct(*fd.nested_flatbuffer, root, indent);
    } else {
      val = IsStruct(fd.value.type)
                ? table->GetStruct<const void *>(fd.value.offset)
                : table->GetPointer<const void *>(fd.value.offset);
    }
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format off
    Type type = fd.value.type;
    if (auto typeNameField = fd.attributes.Lookup("dynamic"))
    {
      auto typeNameFieldDef = struct_def->fields.Lookup(typeNameField->constant);
      if (!typeNameFieldDef)
      {
        return "type not found";
      }

      auto typeName = table->GetPointer<String*>(typeNameFieldDef->value.offset)->c_str();
      if (nosParser->ResolveDynamicType(typeName, &fd, type))
      {
        auto data = table->GetPointer<const Vector<uint8_t> *>(fd.value.offset);

        switch (type.base_type)
        {
        case BASE_TYPE_STRUCT:
          // empty vectors should be filtered out 
          // by ValidateDynamicFieldPresence()
          FLATBUFFERS_ASSERT(data->size());
          return GenStruct(*type.struct_def, IsStruct(type)
            ? reinterpret_cast<const Table*>(data->Data())
            : flatbuffers::GetRoot<Table>(data->Data()), indent);
        case BASE_TYPE_VECTOR:
        {
          return PrintOffset((data->Data()), type, indent, prev_val, -1);
          break;
        }
        case BASE_TYPE_STRING:
        {
          auto str = (const char*)data->Data();
          auto size = std::min(strlen(str), std::max<size_t>(0, data->size() - 1));
          bool ok = EscapeString(str, size, &text, opts.allow_non_utf8, opts.natural_utf8);
          return ok ? nullptr : "string contains non-utf8 bytes";
        }
        case BASE_TYPE_UNION:
        {
          switch (type.enum_def->underlying_type.base_type)
          {
#undef FLATBUFFERS_TD
#define FLATBUFFERS_TD(ENUM, IDLTYPE, CTYPE, ...) \
            case BASE_TYPE_ ## ENUM: \
              PrintScalar<CTYPE>(*((CTYPE*)(data->Data())), type, indent);  return nullptr;
            FLATBUFFERS_GEN_TYPES_SCALAR(FLATBUFFERS_TD)
#undef FLATBUFFERS_TD
          }
          return "Unsupported type";
        }
#undef FLATBUFFERS_TD
#define FLATBUFFERS_TD(ENUM, IDLTYPE, CTYPE, ...) \
            case BASE_TYPE_ ## ENUM: \
              PrintScalar<CTYPE>(*((CTYPE*)(data->Data())), type, indent);  return nullptr;
        FLATBUFFERS_GEN_TYPES_SCALAR(FLATBUFFERS_TD)
#undef FLATBUFFERS_TD
        default:
          return "Unsupported type";
        }

      }
      else
      {
        auto data = table->GetPointer<const Vector<uint8_t> *>(fd.value.offset);
        auto str = (const char*)data->Data();
        if (strnlen(str, data->size()) == data->size() - 1)
        {
          text += str;
          return nullptr;
        }
        else
        {
          return "unknown dynamic type with invalid json";
        }
      }
    }
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format on
    return PrintOffset(val, fd.value.type, indent, prev_val, -1);
  }

#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format off
  void ValidateDynamicFieldPresence(FieldDef const& fd, Table const* table, bool& is_present, bool& output_anyway)
  {
    if (fd.attributes.Lookup("dynamic") && 
        fd.value.type.base_type == BASE_TYPE_VECTOR && 
        fd.value.type.element == BASE_TYPE_UCHAR && 
        table->CheckField(fd.value.offset) &&
        table->GetPointer<const Vector<uint8_t> *>(fd.value.offset)->size() == 0)
      is_present = output_anyway = false;
  }
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format on

  // Generate text for a struct or table, values separated by commas, indented,
  // and bracketed by "{}"
  const char *GenStruct(const StructDef &struct_def, const Table *table,
                        int indent) {
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format off
    if (NosIsId(&struct_def))
    {
      uint8_t *data = (uint8_t *)table;
      uuids::uuid id(data, data + 16);
      std::string s = uuids::to_string(id);
      bool ok = EscapeString(s.c_str(), s.size(), &text, opts.allow_non_utf8, opts.natural_utf8);
        return ok ? nullptr : "string contains non-utf8 bytes";
    }
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format on
    text += '{';
    int fieldout = 0;
    const uint8_t *prev_val = nullptr;
    const auto elem_indent = indent + Indent();
    for (auto it = struct_def.fields.vec.begin();
         it != struct_def.fields.vec.end(); ++it) {
      FieldDef &fd = **it;
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format off
      if(Exporting && fd.attributes.Lookup("transient"))
        continue;
#endif
      auto is_present = struct_def.fixed || table->CheckField(fd.value.offset);
      auto output_anyway = (opts.output_default_scalars_in_json || fd.key) &&
                           IsScalar(fd.value.type.base_type) && !fd.deprecated;
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format off
    ValidateDynamicFieldPresence(fd, table, is_present, output_anyway);
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format on
      if (is_present || output_anyway) {
        if (fieldout++) { AddComma(); }
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format off
        if (struct_def.fields.vec.size() > 4)
        {
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format on
        AddNewLine();
        AddIndent(elem_indent);
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format off
        }
        else
          AddIndent(1);
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format on
        OutputIdentifier(fd.name);
        if (!opts.protobuf_ascii_alike ||
            (fd.value.type.base_type != BASE_TYPE_STRUCT &&
             fd.value.type.base_type != BASE_TYPE_VECTOR))
          text += ':';
        text += ' ';
        // clang-format off
        switch (fd.value.type.base_type) {
        #define FLATBUFFERS_TD(ENUM, IDLTYPE, CTYPE, ...) \
          case BASE_TYPE_ ## ENUM: { \
            GenField<CTYPE>(fd, table, struct_def.fixed, elem_indent); \
            break; }
            FLATBUFFERS_GEN_TYPES_SCALAR(FLATBUFFERS_TD)
        #undef FLATBUFFERS_TD
        // Generate drop-thru case statements for all pointer types:
        #define FLATBUFFERS_TD(ENUM, ...) \
          case BASE_TYPE_ ## ENUM:
              FLATBUFFERS_GEN_TYPES_POINTER(FLATBUFFERS_TD)
              FLATBUFFERS_GEN_TYPE_ARRAY(FLATBUFFERS_TD)
        #undef FLATBUFFERS_TD
            {
              auto err = GenFieldOffset(fd, table, struct_def.fixed, elem_indent, prev_val, &struct_def);
              if (err) return err;
              break;
            }
        }
        // clang-format on
        // Track prev val for use with union types.
        if (struct_def.fixed) {
          prev_val = reinterpret_cast<const uint8_t *>(table) + fd.value.offset;
        } else {
          prev_val = table->GetAddressOf(fd.value.offset);
        }
      }
    }
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS  // clang-format off
        if (struct_def.fields.vec.size() > 4)
        {
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format on
    AddNewLine();
    AddIndent(indent);
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format off
        }
        else
          AddIndent(1);
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS // clang-format on
    text += '}';
    return nullptr;
  }

#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
  Parser* nosParser;
  bool Exporting;
  JsonPrinter(const Parser &parser, std::string &dest, bool exporting)
      : nosParser(const_cast<Parser *>(&parser)), Exporting(exporting), opts(parser.opts), text(dest) {
    text.reserve(1024);  // Reduce amount of inevitable reallocs.
  }
#else
  JsonPrinter(const Parser &parser, std::string &dest)
      : opts(parser.opts), text(dest) {
    text.reserve(1024);  // Reduce amount of inevitable reallocs.
  }
#endif  // defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS

  const IDLOptions &opts;
  std::string &text;
};

static const char *GenerateTextImpl(const Parser &parser, const Table *table,
                                    const StructDef &struct_def,
                                    std::string *_text
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
                             , bool exporting
#endif
) {
  JsonPrinter printer(parser, *_text
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
                             , exporting
#endif
  );
  auto err = printer.GenStruct(struct_def, table, 0);
  if (err) return err;
  printer.AddNewLine();
  return nullptr;
}

// Generate a text representation of a flatbuffer in JSON format.
// Deprecated: please use `GenTextFromTable`
bool GenerateTextFromTable(const Parser &parser, const void *table,
                             const std::string &table_name,
                             std::string *_text) {
  return GenTextFromTable(parser, table, table_name, _text
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
                             , false
#endif
  ) != nullptr;
}

// Generate a text representation of a flatbuffer in JSON format.
const char *GenTextFromTable(const Parser &parser, const void *table,
                             const std::string &table_name, std::string *_text
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
                             , bool exporting
#endif
) {
  auto struct_def = parser.LookupStruct(table_name);
  if (struct_def == nullptr) { return "unknown struct"; }
  auto root = static_cast<const Table *>(table);
  return GenerateTextImpl(parser, root, *struct_def, _text
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
                             , exporting
#endif
  );
}

const char* GenTextFromVector(const Parser& parser, const void* data,
  const flatbuffers::Type& type, std::string* _text
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
                             ,bool exporting
#endif
) {

  JsonPrinter printer(parser, *_text
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
                             , exporting
#endif
);
  return printer.PrintOffset(data, type, 0, 0, -1);
}

// Deprecated: please use `GenText`
const char *GenerateText(const Parser &parser, const void *flatbuffer,
                         std::string *_text) {
  return GenText(parser, flatbuffer, _text);
}

// Generate a text representation of a flatbuffer in JSON format.
const char *GenText(const Parser &parser, const void *flatbuffer,
                    std::string *_text) {
  FLATBUFFERS_ASSERT(parser.root_struct_def_);  // call SetRootType()
  auto root = parser.opts.size_prefixed ? GetSizePrefixedRoot<Table>(flatbuffer)
                                        : GetRoot<Table>(flatbuffer);
  return GenerateTextImpl(parser, root, *parser.root_struct_def_, _text
#if defined(NOS_CUSTOM_FLATBUFFERS) && NOS_CUSTOM_FLATBUFFERS
                             , false
#endif
  );
}

static std::string TextFileName(const std::string &path,
                                const std::string &file_name) {
  return path + file_name + ".json";
}

// Deprecated: please use `GenTextFile`
const char *GenerateTextFile(const Parser &parser, const std::string &path,
                             const std::string &file_name) {
  return GenTextFile(parser, path, file_name);
}

const char *GenTextFile(const Parser &parser, const std::string &path,
                             const std::string &file_name) {
  if (parser.opts.use_flexbuffers) {
    std::string json;
    parser.flex_root_.ToString(true, parser.opts.strict_json, json);
    return flatbuffers::SaveFile(TextFileName(path, file_name).c_str(),
                                 json.c_str(), json.size(), true)
               ? nullptr
               : "SaveFile failed";
  }
  if (!parser.builder_.GetSize() || !parser.root_struct_def_) return nullptr;
  std::string text;
  auto err = GenText(parser, parser.builder_.GetBufferPointer(), &text);
  if (err) return err;
  return flatbuffers::SaveFile(TextFileName(path, file_name).c_str(), text,
                               false)
             ? nullptr
             : "SaveFile failed";
}

static std::string TextMakeRule(const Parser &parser, const std::string &path,
                                const std::string &file_name) {
  if (!parser.builder_.GetSize() || !parser.root_struct_def_) return "";
  std::string filebase =
      flatbuffers::StripPath(flatbuffers::StripExtension(file_name));
  std::string make_rule = TextFileName(path, filebase) + ": " + file_name;
  auto included_files =
      parser.GetIncludedFilesRecursive(parser.root_struct_def_->file);
  for (auto it = included_files.begin(); it != included_files.end(); ++it) {
    make_rule += " " + *it;
  }
  return make_rule;
}

namespace {

class TextCodeGenerator : public CodeGenerator {
 public:
  Status GenerateCode(const Parser &parser, const std::string &path,
                      const std::string &filename) override {
    auto err = GenTextFile(parser, path, filename);
    if (err) {
      status_detail = " (" + std::string(err) + ")";
      return Status::ERROR;
    }
    return Status::OK;
  }

  // Generate code from the provided `buffer` of given `length`. The buffer is a
  // serialized reflection.fbs.
  Status GenerateCode(const uint8_t *, int64_t,
                      const CodeGenOptions &) override {
    return Status::NOT_IMPLEMENTED;
  }

  Status GenerateMakeRule(const Parser &parser, const std::string &path,
                          const std::string &filename,
                          std::string &output) override {
    output = TextMakeRule(parser, path, filename);
    return Status::OK;
  }

  Status GenerateGrpcCode(const Parser &parser, const std::string &path,
                          const std::string &filename) override {
    (void)parser;
    (void)path;
    (void)filename;
    return Status::NOT_IMPLEMENTED;
  }

  Status GenerateRootFile(const Parser &parser,
                          const std::string &path) override {
    (void)parser;
    (void)path;
    return Status::NOT_IMPLEMENTED;
  }

  bool IsSchemaOnly() const override { return false; }

  bool SupportsBfbsGeneration() const override { return false; }

  bool SupportsRootFileGeneration() const override { return false; }

  IDLOptions::Language Language() const override { return IDLOptions::kJson; }

  std::string LanguageName() const override { return "text"; }
};

}  // namespace

std::unique_ptr<CodeGenerator> NewTextCodeGenerator() {
  return std::unique_ptr<TextCodeGenerator>(new TextCodeGenerator());
}

}  // namespace flatbuffers
