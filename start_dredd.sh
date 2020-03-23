docker run -it -v $PWD:/api -w /api apiaryio/dredd dredd petstore_simple.yaml host.docker.internal:4010 -h "Accept:application/json"

# dredd petstore_simple.yaml localhost:4010 -h "Accept:application/json"

