workspace(name = "com_github_google_flatbuffers")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "platforms",
    sha256 = "3a561c99e7bdbe9173aa653fd579fe849f1d8d67395780ab4770b1f381431d51",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/0.0.7/platforms-0.0.7.tar.gz",
        "https://github.com/bazelbuild/platforms/releases/download/0.0.7/platforms-0.0.7.tar.gz",
    ],
)

# Import our own version of skylib before other rule sets (e.g. rules_swift)
# has a chance to import an old version.
http_archive(
    name = "bazel_skylib",
    sha256 = "66ffd9315665bfaafc96b52278f57c7e2dd09f5ede279ea6d39b2be471e7e3aa",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.4.2/bazel-skylib-1.4.2.tar.gz",
    ],
)

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

http_archive(
    name = "build_bazel_rules_apple",
    sha256 = "34c41bfb59cdaea29ac2df5a2fa79e5add609c71bb303b2ebb10985f93fa20e7",
    url = "https://github.com/bazelbuild/rules_apple/releases/download/3.1.1/rules_apple.3.1.1.tar.gz",
)

load(
    "@build_bazel_rules_apple//apple:repositories.bzl",
    "apple_rules_dependencies",
)

apple_rules_dependencies()

http_archive(
    name = "build_bazel_rules_swift",
    sha256 = "a2fd565e527f83fb3f9eb07eb9737240e668c9242d3bc318712efa54a7deda97",
    url = "https://github.com/bazelbuild/rules_swift/releases/download/0.27.0/rules_swift.0.27.0.tar.gz",
)

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "278b7ff5a826f3dc10f04feaf0b70d48b68748ccd512d7f98bf442077f043fe3",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.41.0/rules_go-v0.41.0.zip",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.41.0/rules_go-v0.41.0.zip",
    ],
)

load("@io_bazel_rules_go//go:deps.bzl", "go_rules_dependencies")

go_rules_dependencies()

##### Protobuf
_PROTOBUF_VERSION = "3.15.2"

http_archive(
    name = "com_google_protobuf",
    strip_prefix = "protobuf-" + _PROTOBUF_VERSION,
    urls = [
        "https://github.com/protocolbuffers/protobuf/archive/v" + _PROTOBUF_VERSION + ".tar.gz",
    ],
)

#### Building boring ssl
# Fetching boringssl within the flatbuffers repository, to patch the issue
# of not being able to upgrade to Xcode 14.3 due to buildkite throwing errors
# which was patched in the following below.
# https://github.com/google/flatbuffers/commit/67eb95de9281087ccbba9aafd6e8ab1958d12045
# The patch was copied from the following comment on the same issue within tensorflow
# and fixed to adapt the already existing patch for boringssl.
# https://github.com/tensorflow/tensorflow/issues/60191#issuecomment-1496073147
http_archive(
    name = "boringssl",
    patch_args = ["-p1"],
    patches = ["//grpc:boringssl.patch"],
    # Use github mirror instead of https://boringssl.googlesource.com/boringssl
    # to obtain a boringssl archive with consistent sha256
    sha256 = "534fa658bd845fd974b50b10f444d392dfd0d93768c4a51b61263fd37d851c40",
    strip_prefix = "boringssl-b9232f9e27e5668bc0414879dcdedb2a59ea75f2",
    urls = [
        "https://storage.googleapis.com/grpc-bazel-mirror/github.com/google/boringssl/archive/b9232f9e27e5668bc0414879dcdedb2a59ea75f2.tar.gz",
        "https://github.com/google/boringssl/archive/b9232f9e27e5668bc0414879dcdedb2a59ea75f2.tar.gz",
    ],
)

##### GRPC
_GRPC_VERSION = "1.49.0"  # https://github.com/grpc/grpc/releases/tag/v1.48.0

http_archive(
    name = "com_github_grpc_grpc",
    patch_args = ["-p1"],
    patches = ["//grpc:build_grpc_with_cxx14.patch"],
    sha256 = "15715e1847cc9e42014f02c727dbcb48e39dbdb90f79ad3d66fe4361709ff935",
    strip_prefix = "grpc-" + _GRPC_VERSION,
    urls = ["https://github.com/grpc/grpc/archive/refs/tags/v" + _GRPC_VERSION + ".tar.gz"],
)

load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")

grpc_deps()

load("@com_github_grpc_grpc//bazel:grpc_extra_deps.bzl", "grpc_extra_deps")

grpc_extra_deps()

# rules_go from https://github.com/bazelbuild/rules_go/releases/tag/v0.34.0

http_archive(
    name = "aspect_rules_js",
    sha256 = "76a04ef2120ee00231d85d1ff012ede23963733339ad8db81f590791a031f643",
    strip_prefix = "rules_js-1.34.1",
    url = "https://github.com/aspect-build/rules_js/releases/download/v1.34.1/rules_js-v1.34.1.tar.gz",
)

load("@aspect_rules_js//js:repositories.bzl", "rules_js_dependencies")

rules_js_dependencies()

load("@aspect_rules_js//npm:npm_import.bzl", "pnpm_repository")

pnpm_repository(name = "pnpm")

http_archive(
    name = "aspect_rules_ts",
    sha256 = "4c3f34fff9f96ffc9c26635d8235a32a23a6797324486c7d23c1dfa477e8b451",
    strip_prefix = "rules_ts-1.4.5",
    url = "https://github.com/aspect-build/rules_ts/releases/download/v1.4.5/rules_ts-v1.4.5.tar.gz",
)

load("@aspect_rules_ts//ts:repositories.bzl", "rules_ts_dependencies")

rules_ts_dependencies(
    # Since rules_ts doesn't always have the newest integrity hashes, we
    # compute it manually here.
    #   $ curl --silent https://registry.npmjs.org/typescript/5.3.3 | jq ._integrity
    ts_integrity = "sha512-pXWcraxM0uxAS+tN0AG/BF2TyqmHO014Z070UsJ+pFvYuRSq8KH8DmWpnbXe0pEPDHXZV3FcAbJkijJ5oNEnWw==",
    ts_version_from = "//:package.json",
)

load("@rules_nodejs//nodejs:repositories.bzl", "DEFAULT_NODE_VERSION", "nodejs_register_toolchains")

nodejs_register_toolchains(
    name = "nodejs",
    node_version = DEFAULT_NODE_VERSION,
)

load("@com_github_google_flatbuffers//ts:repositories.bzl", "flatbuffers_npm")

flatbuffers_npm(
    name = "flatbuffers_npm",
)

load("@flatbuffers_npm//:repositories.bzl", "npm_repositories")

npm_repositories()

http_archive(
    name = "aspect_rules_esbuild",
    sha256 = "098e38e5ee868c14a6484ba263b79e57d48afacfc361ba30137c757a9c4716d6",
    strip_prefix = "rules_esbuild-0.15.0",
    url = "https://github.com/aspect-build/rules_esbuild/releases/download/v0.15.0/rules_esbuild-v0.15.0.tar.gz",
)

# Register a toolchain containing esbuild npm package and native bindings
load("@aspect_rules_esbuild//esbuild:repositories.bzl", "LATEST_ESBUILD_VERSION", "esbuild_register_toolchains")

esbuild_register_toolchains(
    name = "esbuild",
    esbuild_version = LATEST_ESBUILD_VERSION,
)

http_archive(
    name = "rules_bazel_integration_test",
    sha256 = "3e24bc0fba88177cd0ae87c1e37bf7de5d5af8e812f00817a58498b1a8368fca",
    urls = [
        "https://github.com/bazel-contrib/rules_bazel_integration_test/releases/download/v0.31.0/rules_bazel_integration_test.v0.31.0.tar.gz",
    ],
)

load("@rules_bazel_integration_test//bazel_integration_test:deps.bzl", "bazel_integration_test_rules_dependencies")

bazel_integration_test_rules_dependencies()

load("@cgrindel_bazel_starlib//:deps.bzl", "bazel_starlib_dependencies")

bazel_starlib_dependencies()

load("@rules_bazel_integration_test//bazel_integration_test:defs.bzl", "bazel_binaries")

bazel_binaries(versions = ["6.3.2"])
