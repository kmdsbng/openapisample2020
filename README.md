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

# workflow

```
API design
  when: 
  how: Stoplight Studio, dredd
  who: 複数人が設計するのが望ましい。
  delive: 
    * push to design branch
↓

API review
  when: 
  how: Stoplight Studio, (dredd)
  who: 
  delive:
    * merge to dev branch
    * delivery to production?
      * productionへの適用はまずいのではないか
        * API interface changeは全ての開発者に影響を与える。API interfaceが変わったことを
          周知しないといけない。
        * API を使って正しく処理を実装できることが検証できてない。なのでAPIはまだ変わる
          可能性が大きい。productionは安定してサービスを提供しつづけないといけないので、
          不安定な修正をデプロイすると安定したサービスを提供できない。
    * merge openapi.yaml to master
      * 本番にも影響が及ぶので、まずいかも
↓

code gen
  when: API review done
  how: OpenAPI generator (kotlin, typescript) via CI
  who: CI
  delive: generated backend and frontend code

↓

implement frontend
  when: after code gen
  how:
    * use prism.
    * use generated code.
    * 
  who: frontend programmer
  delive: 
    * push to dev branch

↓
implement backend
  when: after code gen
  how: dredd
  who: 
  delive: 
    * push to dev branch

↓
integration testing(automation)
  when: after implement backend and frontend
  how:
    * 
    * dredd via CI(github actions)
  who: CI
  delive:
    * merge to test branch
    * create artifact (docker image)

↓
integration testing
  when: after automation testing
  how: 
  who: tester, customer
  delive: 
    * merge to master branch
```

# 問い
* API定義変更したら、できるだけ早くデプロイする、ということができないか？
* dreddでのテストでは認証をどうするか？
* artifact作成手順、デプロイ手順を上田くん、篠原くんと相談


# 参考
本当に使ってよかったOpenAPI (Swagger) ツール
https://future-architect.github.io/articles/20191008/

OpenAPI.Tools
https://openapi.tools/#sdk

https://techbeacon.com/app-dev-testing/tool-your-api-integration-testing-openapi

https://techbeacon.com/app-dev-testing/end-end-vs-contract-based-testing-how-choose

What is API testing? | API Testing Using Katalon Studio | Software Certification Training | Edureka
https://www.youtube.com/watch?v=5qSoeAomkLA

