docker run \
  -v $PWD:/app \
  -w /app \
  -u $UID:$GID \
  takitake/gradle-alpine \
  gradle wrapper
