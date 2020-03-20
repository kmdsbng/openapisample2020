docker run --rm \
  -v ${PWD}:/local openapitools/openapi-generator-cli generate \
  -i /local/petstore.yaml \
  -g typescript-fetch \
  -o /local/out/ts

