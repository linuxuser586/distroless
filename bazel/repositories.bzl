load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def distroless_repositories():
    http_archive(
        name = "io_bazel_rules_docker",
        sha256 = "87fc6a2b128147a0a3039a2fd0b53cc1f2ed5adb8716f50756544a572999ae9a",
        strip_prefix = "rules_docker-0.8.1",
        urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.8.1.tar.gz"],
    )
    http_archive(
        name = "io_bazel_rules_pkg",
        sha256 = "515f1ab4e05305af91a6610cde6cd177afd127861e4d564ba3c2bfc2c4a6f10c",
        strip_prefix = "rules_pkg-b438d48ee1d392a6eec559147730b6ac8467a191",
        urls = ["https://github.com/bazelbuild/rules_pkg/archive/b438d48ee1d392a6eec559147730b6ac8467a191.zip"],
    )
    http_archive(
        name = "io_bazel_rules_go",
        urls = [
            "https://storage.googleapis.com/bazel-mirror/github.com/bazelbuild/rules_go/releases/download/0.18.6/rules_go-0.18.6.tar.gz",
            "https://github.com/bazelbuild/rules_go/releases/download/0.18.6/rules_go-0.18.6.tar.gz",
        ],
        sha256 = "f04d2373bcaf8aa09bccb08a98a57e721306c8f6043a2a0ee610fd6853dcde3d",
    )
    http_archive(
        name = "bazel_gazelle",
        sha256 = "c5faf839dd1da0065ed7d44ac248b01ab5ffcd0db46e7193439906df68867c39",
        strip_prefix = "bazel-gazelle-38bd65ead186af23549480d6189b89c7c53c023e",
        urls = ["https://github.com/bazelbuild/bazel-gazelle/archive/38bd65ead186af23549480d6189b89c7c53c023e.zip"],
    )
    http_archive(
        name = "bazel_skylib",
        sha256 = "d627f5b03ca279e097ea733b51570de68e9841ede6e599c0fb30f6c5023fe5d7",
        strip_prefix = "bazel-skylib-10851c2c5bd528a518af23b2a23f2efe4427f139",
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/10851c2c5bd528a518af23b2a23f2efe4427f139.zip"],
    )
