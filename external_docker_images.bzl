load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
)

def external_images():
    container_pull(
        name = "java_base",
        registry = "gcr.io",
        repository = "distroless/java",
        # 'tag' is also supported, but digest is encouraged for reproducibility.
        tag = "8",
    )
