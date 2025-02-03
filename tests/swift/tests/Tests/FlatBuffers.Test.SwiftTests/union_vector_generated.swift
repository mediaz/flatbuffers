// automatically generated by the FlatBuffers compiler, do not modify
// swiftlint:disable all
// swiftformat:disable all

import FlatBuffers

public enum Character: UInt8, UnionEnum {
  public typealias T = UInt8

  public init?(value: T) {
    self.init(rawValue: value)
  }

  public static var byteSize: Int { return MemoryLayout<UInt8>.size }
  public var value: UInt8 { return self.rawValue }
  case none_ = 0
  case mulan = 1
  case rapunzel = 2
  case belle = 3
  case bookfan = 4
  case other = 5
  case unused = 6

  public static var max: Character { return .unused }
  public static var min: Character { return .none_ }
}

extension Character: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .none_: try container.encode("NONE")
    case .mulan: try container.encode("MuLan")
    case .rapunzel: try container.encode("Rapunzel")
    case .belle: try container.encode("Belle")
    case .bookfan: try container.encode("BookFan")
    case .other: try container.encode("Other")
    case .unused: try container.encode("Unused")
    }
  }
}

public struct CharacterUnion {
  public var type: Character
  public var value: NativeObject?
  public init(_ v: NativeObject?, type: Character) {
    self.type = type
    self.value = v
  }
  public func pack(builder: inout FlatBufferBuilder) -> Offset {
    switch type {
    case .mulan:
      var __obj = value as? AttackerT
      return Attacker.pack(&builder, obj: &__obj)
    case .rapunzel:
      var __obj = value as? Rapunzel
      return Rapunzel_Mutable.pack(&builder, obj: &__obj)
    case .belle:
      var __obj = value as? BookReader
      return BookReader_Mutable.pack(&builder, obj: &__obj)
    case .bookfan:
      var __obj = value as? BookReader
      return BookReader_Mutable.pack(&builder, obj: &__obj)
    case .other:
      var __obj = value as? String
      return String.pack(&builder, obj: &__obj)
    case .unused:
      var __obj = value as? String
      return String.pack(&builder, obj: &__obj)
    default: return Offset()
    }
  }
}
public enum Gadget: UInt8, UnionEnum {
  public typealias T = UInt8

  public init?(value: T) {
    self.init(rawValue: value)
  }

  public static var byteSize: Int { return MemoryLayout<UInt8>.size }
  public var value: UInt8 { return self.rawValue }
  case none_ = 0
  case fallingtub = 1
  case handfan = 2

  public static var max: Gadget { return .handfan }
  public static var min: Gadget { return .none_ }
}

extension Gadget: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .none_: try container.encode("NONE")
    case .fallingtub: try container.encode("FallingTub")
    case .handfan: try container.encode("HandFan")
    }
  }
}

public struct GadgetUnion {
  public var type: Gadget
  public var value: NativeObject?
  public init(_ v: NativeObject?, type: Gadget) {
    self.type = type
    self.value = v
  }
  public func pack(builder: inout FlatBufferBuilder) -> Offset {
    switch type {
    case .fallingtub:
      var __obj = value as? FallingTub
      return FallingTub_Mutable.pack(&builder, obj: &__obj)
    case .handfan:
      var __obj = value as? HandFanT
      return HandFan.pack(&builder, obj: &__obj)
    default: return Offset()
    }
  }
}
public struct Rapunzel: NativeStruct, Verifiable, FlatbuffersInitializable, NativeObject {

  static func validateVersion() { FlatBuffersVersion_25_1_21() }

  private var _hairLength: Int32

  public init(_ bb: ByteBuffer, o: Int32) {
    let _accessor = Struct(bb: bb, position: o)
    _hairLength = _accessor.readBuffer(of: Int32.self, at: 0)
  }

  public init(hairLength: Int32) {
    _hairLength = hairLength
  }

  public init() {
    _hairLength = 0
  }

  public init(_ _t: inout Rapunzel_Mutable) {
    _hairLength = _t.hairLength
  }

  public var hairLength: Int32 { _hairLength }

  public static func verify<T>(_ verifier: inout Verifier, at position: Int, of type: T.Type) throws where T: Verifiable {
    try verifier.inBuffer(position: position, of: Rapunzel.self)
  }
}

extension Rapunzel: Encodable {

  enum CodingKeys: String, CodingKey {
    case hairLength = "hair_length"
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if hairLength != 0 {
      try container.encodeIfPresent(hairLength, forKey: .hairLength)
    }
  }
}

public struct Rapunzel_Mutable: FlatBufferObject {

  static func validateVersion() { FlatBuffersVersion_25_1_21() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Struct

  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Struct(bb: bb, position: o) }

  public var hairLength: Int32 { return _accessor.readBuffer(of: Int32.self, at: 0) }
  @discardableResult public func mutate(hairLength: Int32) -> Bool { return _accessor.mutate(hairLength, index: 0) }
  

  public mutating func unpack() -> Rapunzel {
    return Rapunzel(&self)
  }
  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout Rapunzel?) -> Offset {
    guard var obj = obj else { return Offset() }
    return pack(&builder, obj: &obj)
  }

  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout Rapunzel) -> Offset {
    return builder.create(struct: obj)
  }
}

public struct BookReader: NativeStruct, Verifiable, FlatbuffersInitializable, NativeObject {

  static func validateVersion() { FlatBuffersVersion_25_1_21() }

  private var _booksRead: Int32

  public init(_ bb: ByteBuffer, o: Int32) {
    let _accessor = Struct(bb: bb, position: o)
    _booksRead = _accessor.readBuffer(of: Int32.self, at: 0)
  }

  public init(booksRead: Int32) {
    _booksRead = booksRead
  }

  public init() {
    _booksRead = 0
  }

  public init(_ _t: inout BookReader_Mutable) {
    _booksRead = _t.booksRead
  }

  public var booksRead: Int32 { _booksRead }

  public static func verify<T>(_ verifier: inout Verifier, at position: Int, of type: T.Type) throws where T: Verifiable {
    try verifier.inBuffer(position: position, of: BookReader.self)
  }
}

extension BookReader: Encodable {

  enum CodingKeys: String, CodingKey {
    case booksRead = "books_read"
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if booksRead != 0 {
      try container.encodeIfPresent(booksRead, forKey: .booksRead)
    }
  }
}

public struct BookReader_Mutable: FlatBufferObject {

  static func validateVersion() { FlatBuffersVersion_25_1_21() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Struct

  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Struct(bb: bb, position: o) }

  public var booksRead: Int32 { return _accessor.readBuffer(of: Int32.self, at: 0) }
  @discardableResult public func mutate(booksRead: Int32) -> Bool { return _accessor.mutate(booksRead, index: 0) }
  

  public mutating func unpack() -> BookReader {
    return BookReader(&self)
  }
  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout BookReader?) -> Offset {
    guard var obj = obj else { return Offset() }
    return pack(&builder, obj: &obj)
  }

  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout BookReader) -> Offset {
    return builder.create(struct: obj)
  }
}

public struct FallingTub: NativeStruct, Verifiable, FlatbuffersInitializable, NativeObject {

  static func validateVersion() { FlatBuffersVersion_25_1_21() }

  private var _weight: Int32

  public init(_ bb: ByteBuffer, o: Int32) {
    let _accessor = Struct(bb: bb, position: o)
    _weight = _accessor.readBuffer(of: Int32.self, at: 0)
  }

  public init(weight: Int32) {
    _weight = weight
  }

  public init() {
    _weight = 0
  }

  public init(_ _t: inout FallingTub_Mutable) {
    _weight = _t.weight
  }

  public var weight: Int32 { _weight }

  public static func verify<T>(_ verifier: inout Verifier, at position: Int, of type: T.Type) throws where T: Verifiable {
    try verifier.inBuffer(position: position, of: FallingTub.self)
  }
}

extension FallingTub: Encodable {

  enum CodingKeys: String, CodingKey {
    case weight = "weight"
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if weight != 0 {
      try container.encodeIfPresent(weight, forKey: .weight)
    }
  }
}

public struct FallingTub_Mutable: FlatBufferObject {

  static func validateVersion() { FlatBuffersVersion_25_1_21() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Struct

  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Struct(bb: bb, position: o) }

  public var weight: Int32 { return _accessor.readBuffer(of: Int32.self, at: 0) }
  @discardableResult public func mutate(weight: Int32) -> Bool { return _accessor.mutate(weight, index: 0) }
  

  public mutating func unpack() -> FallingTub {
    return FallingTub(&self)
  }
  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout FallingTub?) -> Offset {
    guard var obj = obj else { return Offset() }
    return pack(&builder, obj: &obj)
  }

  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout FallingTub) -> Offset {
    return builder.create(struct: obj)
  }
}

public struct Attacker: FlatBufferObject, Verifiable, ObjectAPIPacker {

  static func validateVersion() { FlatBuffersVersion_25_1_21() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Table

  public static var id: String { "MOVI" } 
  public static func finish(_ fbb: inout FlatBufferBuilder, end: Offset, prefix: Bool = false) { fbb.finish(offset: end, fileId: Attacker.id, addPrefix: prefix) }
  private init(_ t: Table) { _accessor = t }
  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Table(bb: bb, position: o) }

  private enum VTOFFSET: VOffset {
    case swordAttackDamage = 4
    var v: Int32 { Int32(self.rawValue) }
    var p: VOffset { self.rawValue }
  }

  public var swordAttackDamage: Int32 { let o = _accessor.offset(VTOFFSET.swordAttackDamage.v); return o == 0 ? 0 : _accessor.readBuffer(of: Int32.self, at: o) }
  @discardableResult public func mutate(swordAttackDamage: Int32) -> Bool {let o = _accessor.offset(VTOFFSET.swordAttackDamage.v);  return _accessor.mutate(swordAttackDamage, index: o) }
  public static func startAttacker(_ fbb: inout FlatBufferBuilder) -> UOffset { fbb.startTable(with: 1) }
  public static func add(swordAttackDamage: Int32, _ fbb: inout FlatBufferBuilder) { fbb.add(element: swordAttackDamage, def: 0, at: VTOFFSET.swordAttackDamage.p) }
  public static func endAttacker(_ fbb: inout FlatBufferBuilder, start: UOffset) -> Offset { let end = Offset(offset: fbb.endTable(at: start)); return end }
  public static func createAttacker(
    _ fbb: inout FlatBufferBuilder,
    swordAttackDamage: Int32 = 0
  ) -> Offset {
    let __start = Attacker.startAttacker(&fbb)
    Attacker.add(swordAttackDamage: swordAttackDamage, &fbb)
    return Attacker.endAttacker(&fbb, start: __start)
  }
  

  public mutating func unpack() -> AttackerT {
    return AttackerT(&self)
  }
  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout AttackerT?) -> Offset {
    guard var obj = obj else { return Offset() }
    return pack(&builder, obj: &obj)
  }

  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout AttackerT) -> Offset {
    let __root = Attacker.startAttacker(&builder)
    Attacker.add(swordAttackDamage: obj.swordAttackDamage, &builder)
    return Attacker.endAttacker(&builder, start: __root)
  }

  public static func verify<T>(_ verifier: inout Verifier, at position: Int, of type: T.Type) throws where T: Verifiable {
    var _v = try verifier.visitTable(at: position)
    try _v.visit(field: VTOFFSET.swordAttackDamage.p, fieldName: "swordAttackDamage", required: false, type: Int32.self)
    _v.finish()
  }
}

extension Attacker: Encodable {

  enum CodingKeys: String, CodingKey {
    case swordAttackDamage = "sword_attack_damage"
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if swordAttackDamage != 0 {
      try container.encodeIfPresent(swordAttackDamage, forKey: .swordAttackDamage)
    }
  }
}

public class AttackerT: NativeObject {

  public var swordAttackDamage: Int32

  public init(_ _t: inout Attacker) {
    swordAttackDamage = _t.swordAttackDamage
  }

  public init() {
    swordAttackDamage = 0
  }

  public func serialize() -> ByteBuffer { return serialize(type: Attacker.self) }

}
public struct HandFan: FlatBufferObject, Verifiable, ObjectAPIPacker {

  static func validateVersion() { FlatBuffersVersion_25_1_21() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Table

  public static var id: String { "MOVI" } 
  public static func finish(_ fbb: inout FlatBufferBuilder, end: Offset, prefix: Bool = false) { fbb.finish(offset: end, fileId: HandFan.id, addPrefix: prefix) }
  private init(_ t: Table) { _accessor = t }
  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Table(bb: bb, position: o) }

  private enum VTOFFSET: VOffset {
    case length = 4
    var v: Int32 { Int32(self.rawValue) }
    var p: VOffset { self.rawValue }
  }

  public var length: Int32 { let o = _accessor.offset(VTOFFSET.length.v); return o == 0 ? 0 : _accessor.readBuffer(of: Int32.self, at: o) }
  @discardableResult public func mutate(length: Int32) -> Bool {let o = _accessor.offset(VTOFFSET.length.v);  return _accessor.mutate(length, index: o) }
  public static func startHandFan(_ fbb: inout FlatBufferBuilder) -> UOffset { fbb.startTable(with: 1) }
  public static func add(length: Int32, _ fbb: inout FlatBufferBuilder) { fbb.add(element: length, def: 0, at: VTOFFSET.length.p) }
  public static func endHandFan(_ fbb: inout FlatBufferBuilder, start: UOffset) -> Offset { let end = Offset(offset: fbb.endTable(at: start)); return end }
  public static func createHandFan(
    _ fbb: inout FlatBufferBuilder,
    length: Int32 = 0
  ) -> Offset {
    let __start = HandFan.startHandFan(&fbb)
    HandFan.add(length: length, &fbb)
    return HandFan.endHandFan(&fbb, start: __start)
  }
  

  public mutating func unpack() -> HandFanT {
    return HandFanT(&self)
  }
  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout HandFanT?) -> Offset {
    guard var obj = obj else { return Offset() }
    return pack(&builder, obj: &obj)
  }

  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout HandFanT) -> Offset {
    let __root = HandFan.startHandFan(&builder)
    HandFan.add(length: obj.length, &builder)
    return HandFan.endHandFan(&builder, start: __root)
  }

  public static func verify<T>(_ verifier: inout Verifier, at position: Int, of type: T.Type) throws where T: Verifiable {
    var _v = try verifier.visitTable(at: position)
    try _v.visit(field: VTOFFSET.length.p, fieldName: "length", required: false, type: Int32.self)
    _v.finish()
  }
}

extension HandFan: Encodable {

  enum CodingKeys: String, CodingKey {
    case length = "length"
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if length != 0 {
      try container.encodeIfPresent(length, forKey: .length)
    }
  }
}

public class HandFanT: NativeObject {

  public var length: Int32

  public init(_ _t: inout HandFan) {
    length = _t.length
  }

  public init() {
    length = 0
  }

  public func serialize() -> ByteBuffer { return serialize(type: HandFan.self) }

}
public struct Movie: FlatBufferObject, Verifiable, ObjectAPIPacker {

  static func validateVersion() { FlatBuffersVersion_25_1_21() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Table

  public static var id: String { "MOVI" } 
  public static func finish(_ fbb: inout FlatBufferBuilder, end: Offset, prefix: Bool = false) { fbb.finish(offset: end, fileId: Movie.id, addPrefix: prefix) }
  private init(_ t: Table) { _accessor = t }
  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Table(bb: bb, position: o) }

  private enum VTOFFSET: VOffset {
    case mainCharacterType = 4
    case mainCharacter = 6
    case charactersType = 8
    case characters = 10
    var v: Int32 { Int32(self.rawValue) }
    var p: VOffset { self.rawValue }
  }

  public var mainCharacterType: Character { let o = _accessor.offset(VTOFFSET.mainCharacterType.v); return o == 0 ? .none_ : Character(rawValue: _accessor.readBuffer(of: UInt8.self, at: o)) ?? .none_ }
  public func mainCharacter<T: FlatbuffersInitializable>(type: T.Type) -> T? { let o = _accessor.offset(VTOFFSET.mainCharacter.v); return o == 0 ? nil : _accessor.union(o) }
  public var hasCharactersType: Bool { let o = _accessor.offset(VTOFFSET.charactersType.v); return o == 0 ? false : true }
  public var charactersTypeCount: Int32 { let o = _accessor.offset(VTOFFSET.charactersType.v); return o == 0 ? 0 : _accessor.vector(count: o) }
  public func charactersType(at index: Int32) -> Character? { let o = _accessor.offset(VTOFFSET.charactersType.v); return o == 0 ? Character.none_ : Character(rawValue: _accessor.directRead(of: UInt8.self, offset: _accessor.vector(at: o) + index * 1)) }
  public var hasCharacters: Bool { let o = _accessor.offset(VTOFFSET.characters.v); return o == 0 ? false : true }
  public var charactersCount: Int32 { let o = _accessor.offset(VTOFFSET.characters.v); return o == 0 ? 0 : _accessor.vector(count: o) }
  public func characters<T: FlatbuffersInitializable>(at index: Int32, type: T.Type) -> T? { let o = _accessor.offset(VTOFFSET.characters.v); return o == 0 ? nil : _accessor.directUnion(_accessor.vector(at: o) + index * 4) }
  public static func startMovie(_ fbb: inout FlatBufferBuilder) -> UOffset { fbb.startTable(with: 4) }
  public static func add(mainCharacterType: Character, _ fbb: inout FlatBufferBuilder) { fbb.add(element: mainCharacterType.rawValue, def: 0, at: VTOFFSET.mainCharacterType.p) }
  public static func add(mainCharacter: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: mainCharacter, at: VTOFFSET.mainCharacter.p) }
  public static func addVectorOf(charactersType: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: charactersType, at: VTOFFSET.charactersType.p) }
  public static func addVectorOf(characters: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: characters, at: VTOFFSET.characters.p) }
  public static func endMovie(_ fbb: inout FlatBufferBuilder, start: UOffset) -> Offset { let end = Offset(offset: fbb.endTable(at: start)); return end }
  public static func createMovie(
    _ fbb: inout FlatBufferBuilder,
    mainCharacterType: Character = .none_,
    mainCharacterOffset mainCharacter: Offset = Offset(),
    charactersTypeVectorOffset charactersType: Offset = Offset(),
    charactersVectorOffset characters: Offset = Offset()
  ) -> Offset {
    let __start = Movie.startMovie(&fbb)
    Movie.add(mainCharacterType: mainCharacterType, &fbb)
    Movie.add(mainCharacter: mainCharacter, &fbb)
    Movie.addVectorOf(charactersType: charactersType, &fbb)
    Movie.addVectorOf(characters: characters, &fbb)
    return Movie.endMovie(&fbb, start: __start)
  }
  

  public mutating func unpack() -> MovieT {
    return MovieT(&self)
  }
  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout MovieT?) -> Offset {
    guard var obj = obj else { return Offset() }
    return pack(&builder, obj: &obj)
  }

  public static func pack(_ builder: inout FlatBufferBuilder, obj: inout MovieT) -> Offset {
    let __mainCharacter = obj.mainCharacter?.pack(builder: &builder) ?? Offset()
    var __characters__: [Offset] = []
    for i in obj.characters {
      guard let off = i?.pack(builder: &builder) else { continue }
      __characters__.append(off)
    }
    let __characters = builder.createVector(ofOffsets: __characters__)
    let __charactersType = builder.createVector(obj.characters.compactMap { $0?.type })
    let __root = Movie.startMovie(&builder)
    if let o = obj.mainCharacter?.type {
      Movie.add(mainCharacterType: o, &builder)
      Movie.add(mainCharacter: __mainCharacter, &builder)
    }

    Movie.addVectorOf(charactersType: __charactersType, &builder)
    Movie.addVectorOf(characters: __characters, &builder)
    return Movie.endMovie(&builder, start: __root)
  }

  public static func verify<T>(_ verifier: inout Verifier, at position: Int, of type: T.Type) throws where T: Verifiable {
    var _v = try verifier.visitTable(at: position)
    try _v.visit(unionKey: VTOFFSET.mainCharacterType.p, unionField: VTOFFSET.mainCharacter.p, unionKeyName: "mainCharacterType", fieldName: "mainCharacter", required: false, completion: { (verifier, key: Character, pos) in
      switch key {
      case .none_:
        break // NOTE - SWIFT doesnt support none
      case .mulan:
        try ForwardOffset<Attacker>.verify(&verifier, at: pos, of: Attacker.self)
      case .rapunzel:
        try Rapunzel.verify(&verifier, at: pos, of: Rapunzel.self)
      case .belle:
        try BookReader.verify(&verifier, at: pos, of: BookReader.self)
      case .bookfan:
        try BookReader.verify(&verifier, at: pos, of: BookReader.self)
      case .other:
        try ForwardOffset<String>.verify(&verifier, at: pos, of: String.self)
      case .unused:
        try ForwardOffset<String>.verify(&verifier, at: pos, of: String.self)
      }
    })
    try _v.visitUnionVector(unionKey: VTOFFSET.charactersType.p, unionField: VTOFFSET.characters.p, unionKeyName: "charactersType", fieldName: "characters", required: false, completion: { (verifier, key: Character, pos) in
      switch key {
      case .none_:
        break // NOTE - SWIFT doesnt support none
      case .mulan:
        try ForwardOffset<Attacker>.verify(&verifier, at: pos, of: Attacker.self)
      case .rapunzel:
        try Rapunzel.verify(&verifier, at: pos, of: Rapunzel.self)
      case .belle:
        try BookReader.verify(&verifier, at: pos, of: BookReader.self)
      case .bookfan:
        try BookReader.verify(&verifier, at: pos, of: BookReader.self)
      case .other:
        try ForwardOffset<String>.verify(&verifier, at: pos, of: String.self)
      case .unused:
        try ForwardOffset<String>.verify(&verifier, at: pos, of: String.self)
      }
    })
    _v.finish()
  }
}

extension Movie: Encodable {

  enum CodingKeys: String, CodingKey {
    case mainCharacterType = "main_character_type"
    case mainCharacter = "main_character"
    case charactersType = "characters_type"
    case characters = "characters"
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if mainCharacterType != .none_ {
      try container.encodeIfPresent(mainCharacterType, forKey: .mainCharacterType)
    }
    switch mainCharacterType {
    case .mulan:
      let _v = mainCharacter(type: Attacker.self)
      try container.encodeIfPresent(_v, forKey: .mainCharacter)
    case .rapunzel:
      let _v = mainCharacter(type: Rapunzel.self)
      try container.encodeIfPresent(_v, forKey: .mainCharacter)
    case .belle:
      let _v = mainCharacter(type: BookReader.self)
      try container.encodeIfPresent(_v, forKey: .mainCharacter)
    case .bookfan:
      let _v = mainCharacter(type: BookReader.self)
      try container.encodeIfPresent(_v, forKey: .mainCharacter)
    case .other:
      let _v = mainCharacter(type: String.self)
      try container.encodeIfPresent(_v, forKey: .mainCharacter)
    case .unused:
      let _v = mainCharacter(type: String.self)
      try container.encodeIfPresent(_v, forKey: .mainCharacter)
    default: break;
    }
    if charactersCount > 0 {
      var enumsEncoder = container.nestedUnkeyedContainer(forKey: .charactersType)
      var contentEncoder = container.nestedUnkeyedContainer(forKey: .characters)
      for index in 0..<charactersCount {
        guard let type = charactersType(at: index) else { continue }
        try enumsEncoder.encode(type)
        switch type {
        case .mulan:
          let _v = characters(at: index, type: Attacker.self)
          try contentEncoder.encode(_v)
        case .rapunzel:
          let _v = characters(at: index, type: Rapunzel.self)
          try contentEncoder.encode(_v)
        case .belle:
          let _v = characters(at: index, type: BookReader.self)
          try contentEncoder.encode(_v)
        case .bookfan:
          let _v = characters(at: index, type: BookReader.self)
          try contentEncoder.encode(_v)
        case .other:
          let _v = characters(at: index, type: String.self)
          try contentEncoder.encode(_v)
        case .unused:
          let _v = characters(at: index, type: String.self)
          try contentEncoder.encode(_v)
        default: break;
        }
      }
    }
  }
}

public class MovieT: NativeObject {

  public var mainCharacter: CharacterUnion?
  public var characters: [CharacterUnion?]

  public init(_ _t: inout Movie) {
    switch _t.mainCharacterType {
    case .mulan:
      var _v = _t.mainCharacter(type: Attacker.self)
      mainCharacter = CharacterUnion(_v?.unpack(), type: .mulan)
    case .rapunzel:
      var _v = _t.mainCharacter(type: Rapunzel_Mutable.self)
      mainCharacter = CharacterUnion(_v?.unpack(), type: .rapunzel)
    case .belle:
      var _v = _t.mainCharacter(type: BookReader_Mutable.self)
      mainCharacter = CharacterUnion(_v?.unpack(), type: .belle)
    case .bookfan:
      var _v = _t.mainCharacter(type: BookReader_Mutable.self)
      mainCharacter = CharacterUnion(_v?.unpack(), type: .bookfan)
    case .other:
      var _v = _t.mainCharacter(type: String.self)
      mainCharacter = CharacterUnion(_v?.unpack(), type: .other)
    case .unused:
      var _v = _t.mainCharacter(type: String.self)
      mainCharacter = CharacterUnion(_v?.unpack(), type: .unused)
    default: break
    }
    characters = []
    for index in 0..<_t.charactersCount {
        switch _t.charactersType(at: index) {
        case .mulan:
          var _v = _t.characters(at: index, type: Attacker.self)
          characters.append(CharacterUnion(_v?.unpack(), type: .mulan))
        case .rapunzel:
          var _v = _t.characters(at: index, type: Rapunzel_Mutable.self)
          characters.append(CharacterUnion(_v?.unpack(), type: .rapunzel))
        case .belle:
          var _v = _t.characters(at: index, type: BookReader_Mutable.self)
          characters.append(CharacterUnion(_v?.unpack(), type: .belle))
        case .bookfan:
          var _v = _t.characters(at: index, type: BookReader_Mutable.self)
          characters.append(CharacterUnion(_v?.unpack(), type: .bookfan))
        case .other:
          var _v = _t.characters(at: index, type: String.self)
          characters.append(CharacterUnion(_v?.unpack(), type: .other))
        case .unused:
          var _v = _t.characters(at: index, type: String.self)
          characters.append(CharacterUnion(_v?.unpack(), type: .unused))
        default: break
        }
    }
  }

  public init() {
    characters = []
  }

  public func serialize() -> ByteBuffer { return serialize(type: Movie.self) }

}
