load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# custom version
rules_docker_version = "c2bcc086548c49c22ec10002a2f50e6e53d2e86a"

http_archive(
  name = "io_bazel_rules_docker",
  strip_prefix= "rules_docker-%s" % rules_docker_version,
  urls = ["https://github.com/or-shachar/rules_docker/archive/%s.tar.gz" % rules_docker_version],
)



load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

# This is NOT needed when going through the language lang_image
# "repositories" function(s).
load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load("//:external_docker_images.bzl", "external_images")

external_images()
