

# Stoplight Studio
https://stoplight.io/studio/

* OpenAPI のyamlファイルエディタ
* インストールして使うことも、オンラインで使うこともできる
* yamlをテキスト編集しなくて良くなる。Swagger Editorよりだいぶ使いやすい。(意味不明なエラーに悩まされずに済む)

# Start mock server (prism)
sh start_prism.sh

### mock server の結果を取得
curl -s -D /dev/stderr -X GET -H "Accept:application/json" http://localhost:4010/pet/0001 | json_pp


# OpenAPI Generator generators list
https://openapi-generator.tech/docs/generators

# Generate code
sh generate_*_code.sh


# Run kotlin server (ktor)
cd out/kotlin
./gradlew build run

(ブラウザでhttp:/localhost:8080/user/loginにアクセス)


# Run dredd (API server test)

### start prism for dredd (petstore.yamlだとdreddの検査が通らないので編集したpetstore_simple.yamlを使ってる)
sh start_prism_dynamic_simple.sh

### install dredd
npm install -g dredd

### run dredd
sh start_dredd.sh


# 参考

本当に使ってよかったOpenAPI (Swagger) ツール
https://future-architect.github.io/articles/20191008/

OpenAPI.Tools
https://openapi.tools/#sdk


