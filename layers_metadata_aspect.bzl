load("@io_bazel_rules_docker//container:pull.bzl","pull_tags_prefix")

LayersMetadata = provider(
    fields = {
        "base_layers_labels": "list of layers and their sha256 path",
        "base_image_registry": "registry of external base image",
        "base_image_repository": "repository of external base image",
        "base_image_digest": "digest of external base image",
    },
)

def _accumulate_base(accumulated, base):
    return depset(
        transitive = [base[LayersMetadata].base_layers_labels, accumulated],
    )

def _layers_metadata_aspect_impl(target, ctx):
    accumulated_base_files = depset([str(ctx.label)])
    if hasattr(ctx.rule.attr, "base"):
        base = getattr(ctx.rule.attr, "base")
        accumulated_base_files = _accumulate_base(accumulated_base_files, base)
        base_image_registry = base[LayersMetadata].base_image_registry
        base_image_repository = base[LayersMetadata].base_image_repository
        base_image_digest =  base[LayersMetadata].base_image_digest
    else:
        base_image_registry = None
        base_image_repository = None
        base_image_digest = None
        tags = getattr(ctx.rule.attr, "tags", [])
        for tag in tags:
            if tag.startswith(pull_tags_prefix.registry):
                base_image_registry = tag[len(pull_tags_prefix.registry):]
            elif tag.startswith(pull_tags_prefix.repository):
                base_image_repository = tag[len(pull_tags_prefix.repository):]
            elif tag.startswith(pull_tags_prefix.digest):
                base_image_digest = tag[len(pull_tags_prefix.digest):]
        base_image_target = ctx.build_file_path

    return [LayersMetadata(
        base_layers_labels = accumulated_base_files,
        base_image_registry = base_image_registry,
        base_image_repository = base_image_repository,
        base_image_digest = base_image_digest,
    )]

layers_metadata_aspect = aspect(
    implementation = _layers_metadata_aspect_impl,
    attr_aspects = ["base"],
)
