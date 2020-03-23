docker run -it -v $PWD:/api -w /api apiaryio/dredd dredd petstore_simple_v3.v1.yaml host.docker.internal:4010 -h "Accept:application/json"

# dredd petstore_simple_v3.v1.yaml localhost:4010 -h "Accept:application/json"

