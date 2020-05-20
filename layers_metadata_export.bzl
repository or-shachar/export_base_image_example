load("@io_bazel_rules_docker//container:providers.bzl","ImageInfo")

load("//:layers_metadata_aspect.bzl","layers_metadata_aspect","LayersMetadata")

def _layers_metadata_export_impl(ctx):
    layers_metadata_file = "{"+"""
  "base_image_registry" : "{base_image_registry}",
  "base_image_repository" : "{base_image_repository}",
  "base_image_digest" : "{base_image_digest}",
  "layers_labels" : {layers_labels}
""".format(
        base_image_registry = ctx.attr.image[LayersMetadata].base_image_registry,
        base_image_repository = ctx.attr.image[LayersMetadata].base_image_repository,
        base_image_digest = ctx.attr.image[LayersMetadata].base_image_digest,
        layers_labels = ctx.attr.image[LayersMetadata].base_layers_labels.to_list(), 
        )+"}\n"
    ctx.actions.write(ctx.outputs.layers_metadata, layers_metadata_file)
    return [DefaultInfo(files = depset([ctx.outputs.layers_metadata]))]



_layers_metadata_export = rule(
    implementation = _layers_metadata_export_impl,
    attrs = {
        'image' : attr.label(providers = [ImageInfo], aspects=[layers_metadata_aspect], mandatory=True),
        'layers_metadata': attr.output(),
    }
)

def layers_metadata_export(name,**kwargs):
    _layers_metadata_export(
        name = name,
        layers_metadata = name+".json",
        **kwargs
    )
