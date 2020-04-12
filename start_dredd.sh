# docker run -it -v $PWD:/api -w /api apiaryio/dredd dredd reference/todo.v1.yaml host.docker.internal:8080 -h "Accept:application/json"
docker run -it -v $PWD:/api -w /api apiaryio/dredd dredd reference/todo.v1.yaml host.docker.internal:8080 --hookfiles=/api/dredd_hooks.js

# dredd petstore_simple.yaml localhost:4010 -h "Accept:application/json"

