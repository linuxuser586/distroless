load("@io_bazel_rules_pkg//deb_packages:deb_packages.bzl", "deb_packages")
load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)
load(
    "@io_bazel_rules_docker//java:image.bzl",
    java_image_repositories = "repositories",
)
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def distroless_externals():
    container_repositories()
    java_image_repositories()
    container_pull(
        name = "base",
        digest = "sha256:e37cf3289c1332c5123cbf419a1657c8dad0811f2f8572433b668e13747718f8",
        registry = "gcr.io",
        repository = "distroless/base",
    )
    container_pull(
        name = "java_base",
        digest = "sha256:a13ac1ce516ec5e49ae9dfd3b8183e9e8328180a65757d454e594a9ce6d1e35d",
        registry = "gcr.io",
        repository = "distroless/java",
    )
    _destroless_debs()

def _destroless_debs():
    deb_packages(
        name = "debian_package",
        arch = "amd64",
        distro = "stretch",
        distro_type = "debian",
        mirrors = [
            "http://debian.gtisc.gatech.edu/debian/",
            "http://www.gtlib.gatech.edu/debian/",
            "http://mirror.math.princeton.edu/pub/debian/",
        ],
        packages = {
            "busybox": "pool/main/b/busybox/busybox_1.22.0-19+b3_amd64.deb",
            "dumb-init": "pool/main/d/dumb-init/dumb-init_1.2.0-1_amd64.deb",
            "libgcc1": "pool/main/g/gcc-6/libgcc1_6.3.0-18+deb9u1_amd64.deb",
            "libgomp1": "pool/main/g/gcc-6/libgomp1_6.3.0-18+deb9u1_amd64.deb",
            "libstdc++6": "pool/main/g/gcc-6/libstdc++6_6.3.0-18+deb9u1_amd64.deb",
            "libjemalloc1": "pool/main/j/jemalloc/libjemalloc1_3.6.0-9.1_amd64.deb",
        },
        packages_sha256 = {
            "busybox": "f0b28d621480e1954c72ddfa2a17a1d07be8da5825b8c5c8a8926fcb5ff2df4b",
            "dumb-init": "c2ea11d1e99cf3c7150d8901036d52bffc7419790f6746aaeebdba2f0ae06c4c",
            "libgcc1": "423a6541ee7ade69967c99492e267e724fd4675de53310861af5d1a1d249c4bf",
            "libgomp1": "31f7549160118004fda234a88dbaa60df6d9611110b9ab0f5fa2da0b45ddce78",
            "libstdc++6": "d05373fbbb0d2c538fa176dfe71d1fa7983c58d35a7a456263ca87e8e0d45030",
            "libjemalloc1": "347c6466ad851059381069ad96a03a2224b97167b45eea3520b1e83659c4be23",
        },
    )

    deb_packages(
        name = "cassandra_package",
        arch = "amd64",
        distro = "stretch",
        distro_type = "debian",
        mirrors = [
            "http://dl.bintray.com/apache/cassandra",
        ],
        packages = {
            "cassandra": "pool/main/c/cassandra/cassandra_3.11.5_all.deb",
        },
        packages_sha256 = {
            "cassandra": "7f65f18e21dc7e69b69bd09434e2afffb5f8d4fd2d64e1fb6d92819ca21e4d54",
        },
    )
