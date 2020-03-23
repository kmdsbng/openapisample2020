docker run --rm \
  -v ${PWD}:/local \
  -it \
  -p 4010:4010 \
  stoplight/prism:3 mock -h 0.0.0.0 -d /local/petstore_simple.yaml

