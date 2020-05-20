## Example on how to retrive layers metadata

This repo contains a rule that given a container_* target. eg:
```python

layers_metadata_export(
    name = "app_layers_metadata",
    image = "app"
)

```
, would produce a json file with the following properties:
```js
{
  "base_image_registry" : "gcr.io",
  "base_image_repository" : "distroless/java",
  "base_image_digest" : "sha256:9d4092ba5e1c9dc4d1490fdead1dd7ea5c64e635b729fee11a6af55f51b337f8",
  "layers_labels" : ["@java_base//image:image", "//:layer0", "//:layer1", "//:app"]
}
```

This target can be very useful for external publishing tooling that needs to know the different layers + the full properties of the external base docker image (registry, repository, digest).

This repo needs some changes in rules_docker so that `container_pull` targets would add some tags to the generated `container_import` target.

