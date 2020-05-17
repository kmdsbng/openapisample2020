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




contract base testing

- API specに合致してるかのテスト
- 限定的なテスト
- 低コスト

end to end testing

- UIから操作して機能が使えるかをテスト
- 完全なテスト
- 高コスト

e2eテストがテストするもの

- GUI testing on presentation layer
- API Testing on Business Layer
- Database testing

最もテストの焦点を当てるべきはBusiness Layerのテスト

APIテストは労力が少ない

戦略

- contract base testing に通ることをまず確認し、続いてe2e testing を通す。

API testingの手順 ([https://www.youtube.com/watch?v=5qSoeAomkLA](https://www.youtube.com/watch?v=5qSoeAomkLA))

1. API specification review (文書化)
2. Setting up test environment
3. Combining application data
4. Deciding what to test API for
5. Test execution & reporting

Types of API Tests ([https://www.youtube.com/watch?v=5qSoeAomkLA](https://www.youtube.com/watch?v=5qSoeAomkLA))

- Functionality Testing
    - To check the correctness of functionality
- Reliability Testing
    - To check test results are consistent (一貫性)
- Load testing
    - To check if API can handle load
- UI & UX testing
    - To check the UI end-to-end functionality
- Interoperability testing
    - To test SOAP apis
- Security testing
    - To check if API is safe against external threats
- Penetration testing
    - To detect vulnerabilities of an application
- Negative testing
    - To check API'S for plausible wrong inputs

Types of Bugs in API Testing ([https://www.youtube.com/watch?v=5qSoeAomkLA](https://www.youtube.com/watch?v=5qSoeAomkLA))

- Duplicate functionality
- Reliability Issues
- Improper messaging
- Incompatible error handling
- Security issues
- Performance issues
- Multi-threaded issues

Popular API Testing Tools

- Postman
- Katalon Studio
    - udemyコースがあるらしい
    - CI, CD support
    - テストケースやデータを格納できる
    - APIリクエストでき、その結果をもとにテストケースを作成できる
- SoapUI
- Jmeter
- Tricentis Tosca
- Parasoft
- Assertible

Benefits of API Testing

- Language Independent
- GUI Independent
- Improved Test Coverage
- Reduces Testing Costs
    - グラフィカルユーザーがテストする前に、小さなバグを見つけられる。
    小さなバグはGUIテスト中に大きくなるため、初期段階でこれらのバグを見つける
    ことは非常に良いプロセスであり、有益です。
- Faster Release
    - 回帰テストよりAPIテストのほうが5～10倍速い。
    - UIテストよりテストが安定している(壊れにくい)

Challenges of API Testing

- No GUI
    - UIテストに精通している場合、APIテストに飛び込むのが難しい場合がある
- Synchronous & Asynchronous Dependencies
    - 外部API に依存してるAPIのテストが難しい
- Difficult Test Data Management
- Request & Response
- No Documentation & Time Constraints

参考

[https://www.youtube.com/watch?v=5qSoeAomkLA](https://www.youtube.com/watch?v=5qSoeAomkLA)
Katalon StudioでサンプルREST APIをテストするデモ

[https://www.youtube.com/watch?v=BmLsefTC0tQ](https://www.youtube.com/watch?v=BmLsefTC0tQ)

What is API and API Testing (まだ見てない)

[https://www.sisense.com/ja/blog/rest-api-testing-strategy-what-exactly-should-you-test/](https://www.sisense.com/ja/blog/rest-api-testing-strategy-what-exactly-should-you-test/)
(API テストマトリックスのサンプルとかある)

API as a contract ? first, check the spec!
エンドポイントの名前が正しく付けられていること、
リソースとその型がオブジェクトモデルを正しく反映していること、
機能の欠落や重複がないこと、
リソース間の関係が API に正しく反映されていること。

So, what aspects of the API should we test?
API test actions
1. Verify correct HTTP status code.
2. Verify response payload. Check valid JSON body and correct field names, types, and values ? including in error responses.
3. Verify response headers. HTTP server headers have implications on both security and performance.
4. Verify correct application state. This is optional and applies mainly to manual testing, or when a UI or another interface can be easily inspected.
5. Verify basic performance sanity.

Test scenario categories
Basic positive tests (happy paths)
Extended positive testing with optional parameters
Negative testing with valid input
Negative testing with invalid input
Destructive testing
Security, authorization, and permission tests (which are out of the scope of this post)

Test flows
1. Testing requests in isolation
2. Multi-step workflow with several requests
3. Combined API and web UI tests

[https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html](https://testing.googleblog.com/2015/04/just-say-no-to-more-end-to-end-tests.html)

まず、Googleの10のリストの第1位は "ユーザーに焦点を当てれば、他のことはすべて後からついてくる "ということです。このように、実際のユーザーのシナリオに焦点を当てたエンドツーエンドのテストは、素晴らしいアイデアのように聞こえます。さらに、この戦略は広く多くの有権者にアピールしています。

- 開発者は、テストのすべてではないにしても、ほとんどの作業を他の人に任せることができるので、開発者には好まれています。
- 管理者や意思決定者は、実際のユーザーシナリオをシミュレートしたテストによって、テストに失敗した場合にユーザーにどのような影響があるかを簡単に判断できるため、このテストを好んでいます。
- バグを見逃したり、実世界の動作を検証しないテストを書いたりすることを心配することがよくあるので、テスターはこのようなテストを好む。

E2Eテストの問題

- チームは、コーディングのマイルストーンを1週間遅れで完成させました（そして、多くの残業をしました）。
- エンドツーエンドのテストが失敗した根本原因を見つけるのは苦痛であり、長い時間がかかることもあります。
- パートナーの失敗やラボの失敗が、複数日に渡ってテスト結果を台無しにした。
多くの小さなバグが大きなバグの裏に隠れていた。
- エンド・ツー・エンドのテストは時として不完全だった。
- 開発者は、修正がうまくいったかどうかを知るために、翌日まで待たなければならなかった。

一般的に、テストに失敗した時点でテスターの仕事は終了します。バグが報告され、そのバグを修正するのが開発者の仕事です。しかし、エンドツーエンドの戦略がどこで破綻しているのかを見極めるためには、この箱の外で考え、第一原理から問題にアプローチする必要があります。もし「ユーザーに焦点を当てる（他のすべてのことは後からついてくる）」のであれば、テストの失敗がユーザーにどのような利益をもたらすのかを自問自答しなければなりません。これがその答えです。

- テストに失敗したからといって、直接ユーザーの利益になるわけではありません。
この発言は最初は衝撃的に思えますが、事実です。製品が動作するならば、テストが動作すると言ってもしなくても動作します。製品が壊れている場合、テストが壊れていると言っているかどうかに関わらず、製品は壊れています。では、テストに失敗してもユーザーの利益にならないのであれば、何がユーザーの利益になるのでしょうか？

- バグ修正はユーザーに直接利益をもたらします。
ユーザーが喜ぶのは、その意図しない動作、つまりバグがなくなったときだけです。明らかに、バグを修正するには、そのバグが存在することを知らなければなりません。バグが存在することを知るためには、理想的にはバグをキャッチするテストが必要です (テストが行われない場合、ユーザはバグを見つけることになるからです)。しかし、テストの失敗からバグ修正までの全プロセスにおいて、価値が付加されるのは最後の段階になってからです。
- したがって、どのようなテスト戦略を評価するにしても、バグを発見する方法だけを評価することはできません。また、開発者がどのようにしてバグを修正することができるのか(さらにはバグを防ぐことができるのか)も評価しなければなりません。

正しいフィードバックループの構築

テストは、製品が動作しているかどうかを開発者に知らせるフィードバックループを作成します。理想的なフィードバックループにはいくつかの特性があります。

- 速いです。開発者は、変更がうまくいくかどうかを確認するために何時間も何日も待ちたいとは思いません。変更がうまくいかないこともあります - 誰もが完璧ではありません - そして、フィードバックループを何度も実行する必要があります。フィードバックループが高速であればあるほど、修正も高速になります。ループが十分に高速であれば、開発者は変更を確認する前にテストを実行することもできます。
- 信頼性があります。開発者は、テストのデバッグに何時間も費やして、それが不正なテストであることに気付きたいとは思いません。欠陥テストは開発者のテストに対する信頼を低下させ、その結果、欠陥テストが実際の製品の問題を発見したとしても、しばしば無視されてしまいます。
- 障害を隔離します。バグを修正するには、開発者はバグの原因となっている特定のコード行を見つける必要があります。製品に何百万行ものコードが含まれていて、バグがどこにでもある可能性がある場合、それは干し草の山の中から針を見つけようとしているようなものです。

ユニットテスト
ユニットテストでは、製品の一部を取り出して、その一部を分離してテストします。これは、理想的なフィードバックループを作る傾向があります。

- ユニットテストは速いです。テストするためには小さなユニットを構築するだけで済みますし、テストもかなり小さくなる傾向があります。実際、ユニットテストでは、10分の1秒が遅いと考えられています。
- ユニットテストは信頼性があります。一般的に、シンプルなシステムや小さなユニットは、フラキシーに悩まされることが少なくなる傾向があります。さらに、ユニットテストのベストプラクティス、特にハーメチックテストに関連するプラクティスは、フレークネスを完全に取り除くことができます。
- ユニットテストは障害を分離します。たとえ製品に何百万行ものコードが含まれていたとしても、ユニットテストが失敗した場合、バグを見つけるためには、テスト中の小さなユニットを検索する必要があります。

効果的な単体テストを書くには、依存関係管理、モッキング、ハーメティックテストなどの分野でのスキルが必要です。ここではこれらのスキルについては触れませんが、手始めに、新しい Googler (または Noogler) に提供される典型的な例として、Google がストップウォッチをどのように構築してテストしているかを紹介します。

Unit Tests vs. End-to-End Tests

エンドツーエンドのテストでは、まず製品全体が構築され、次にデプロイされ、最後にすべてのエンドツーエンドのテストが実行されるまで待たなければなりません。テストが実行されると、欠陥のあるテストは日常茶飯事になりがちです。また、テストでバグを見つけたとしても、そのバグは製品のどこにでもある可能性があります。
エンドツーエンドのテストは、実際のユーザーシナリオをシミュレートするのに適していますが、この利点は、エンドツーエンドのフィードバックループのすべての欠点に比べれば、すぐに打ち消されてしまいます。

Integration Tests

ユニットテストには、1つの大きな欠点があります。それは、ユニットが分離して動作していても、ユニットが一緒に動作しているかどうかがわからないということです。しかし、その場合でも、必ずしもエンドツーエンドのテストが必要なわけではありません。そのためには、統合テストを使うことができます。統合テストでは、小さなユニットのグループ、多くの場合は2つのユニットを取り上げ、全体としての動作をテストし、それらが首尾一貫して動作するかどうかを検証します。
2つのユニットが適切に統合されていない場合、同じバグを検出するために、より小さく、より焦点を絞った統合テストを書くことができるのに、なぜエンドツーエンドのテストを書くのでしょうか？もっと大きく考える必要はありますが、ユニットが連携して動作することを検証するためには、もう少し大きく考える必要があります。

Testing Pyramid

ユニットテストと統合テストの両方を使用しても、システム全体を検証するために、少数のエンドツーエンドのテストが必要になるでしょう。3つのテストタイプすべての間の適切なバランスを見つけるために、使用するための最良の視覚的支援は、テストピラミッドです。ここでは、2014年のGoogle Test Automation Conferenceのオープニング基調講演から、テストピラミッドの簡略化したバージョンを紹介します。

テストの大部分はピラミッドの一番下にあるユニットテストです。ピラミッドの上に行くほどテストは大きくなりますが、同時にテストの数(ピラミッドの幅)も小さくなります。
最初の目安として、Google はしばしば 70/20/10 の割合を提案しています: ユニットテストが 70%、統合テストが 20%、エンドツーエンドテストが 10% です。正確な比率はチームごとに異なるでしょうが、一般的には、ピラミッドの形を維持しているはずです。以下のような反パターンを避けるようにしてください。
逆ピラミッド/アイスクリームコーン。このチームは主にエンドツーエンドのテストに依存しており、統合テストはほとんど使わず、ユニットテストはさらに少ない。
砂時計。このチームは大量のユニットテストから始め、統合テストを使うべきところではエンドツーエンドのテストを使っています。砂時計は、下には多くのユニットテストがあり、上には多くのエンドツーエンドテストがありますが、真ん中には統合テストはほとんどありません。
通常のピラミッドが実生活で最も安定した構造である傾向があるように、テストピラミッドもまた、最も安定したテスト戦略である傾向があります。

[https://docs.pact.io/faq/convinceme](https://docs.pact.io/faq/convinceme)

チーム、上司、または自分自身に、コントラクトテストが良いアイデアであると納得させる方法

...でも私はSwagger/OpenAPIを使っているのですが？
OpenAPIとPactは異なる目的で設計されています。違いをまとめると以下のようになります。
OpenAPI仕様は、APIの記述と構造を標準化することを目的としています。OpenAPI仕様はAPIの記述と構造を標準化することを目的としています。どのようなAPIが利用可能か、どのようなフィールド/構造を期待しているかを伝えることができます。これは(それ自体では)テストフレームワークではありません。
一方、Pactは基本的には例示による仕様を使ったユニットテストフレームワークです。たまたまですが、APIのコンシューマ側とプロバイダ側でテストを実行するためには、その構造を伝えるための中間フォーマットを生成する必要があります - これが仕様です。
API を OAS で文書化して開発者チームと共有するだけでは、統合バグの発生を防ぐことはできません。実際、OpenAPI仕様の作者は、このようなユースケースを発表することで予測していました。

テストツールのような追加のユーティリティも、結果として得られるファイルを活用することができます。例えば、ベンダの拡張機能を使用して、仕様に取り込まれた余分なメタデータを文書化することができます。これは2つのプロジェクトが一緒になる1つの方法です。
OpenAPI は、デプロイする前に自動化された方法を持っていれば、Pact と同様の方法でコントラクトテストフレームワークとして使用することができます。
仕様が API の正確な表現であること（すべてのエラーレスポンスとポリモーフィックペイロードを含む）。
あなたの消費者は要求を行い、仕様に適合した応答を期待しています。
APIに対する既存の消費者の期待を壊さないようにします。
仕様変更は自動的に消費者に伝わります。
開発とデプロイを調整して、互換性のあるバージョンのアプリケーションのみを同じ環境にデプロイすることができます。
OpenAPIを使用している場合は、これらの世界を統一することを目的としたアトラシアンで開発されたプラグイン、Swagger Mock Validatorの使用を検討してください。
Pactと組み合わせて使用することで、APIが公開されている仕様（外部クライアント用）を満たしていることを確信でき、同時に既知のコンシューマ要件（内部）が満たされていることを確信することができます。
詳細は [https://github.com/pact-foundation/pact-specification/issues/28](https://github.com/pact-foundation/pact-specification/issues/28) を参照してください。
Pactを使用することで、Swaggerを単独で使用するよりも本当に有利になるのは、APIに変更を加える場合です。Pactを使用すると、APIに変更を加えた場合の影響を数分で確認でき、どのチームに相談し、何を議論すべきかの具体的なリストを提供してくれます。テストでは、新機能が各消費者に採用された時点で、古い機能が削除された時点で表示されます。一方、Swagger仕様の新バージョンをリリースして、すべてのコンシューマーチーム（その特定の機能を実際に使用しているかどうかは別として）がその変更に対応するのを待つ場合、数週間から数ヶ月かかる可能性があります。

...でも、すでにエンドツーエンド（E2E）の統合スイートを持っていますか？
エンドツーエンド (E2E) テストにはいくつかの重要な問題があります。
E2E テストでは、バグを見つける前にデプロイする必要があり、デプロイには時間がかかります。デプロイする前にバグを見つけた方が良いのではないでしょうか？
E2E テストは遅い - ビルド時間が遅いと、変更のバッチングが発生します。バッチングは継続的なデリバリには良くない
E2Eテストの調整が難しい すべてのソフトウェアコンポーネントの正確なバージョンが、あるべき姿で正確にあることを保証するにはどうすればいいのでしょうか？
E2Eの複雑さは非線形で、時間が経てば経つほど難しくなります。
なぜ他のシステムがどのように振る舞うかを気にする必要があるのでしょうか？
もしあなたが誰かの目をまっすぐ見て、E2E環境を維持するのに多くの時間を費やしていない、あるいはテストを管理するのに絶え間ない課題を抱えていると言うことができるならば、別のアプローチを取るべきです。もし、リリースプロセスの管理を専門にしている人が1人以上いるなら、それはあなたが間違った方向に向かっている良いサインかもしれません。
もしあなたが本当にこれらを維持したいのであれば、E2Eシナリオのサブセットを「スモークテスト」の一種として、顧客にリリースする前にいくつかの重要なシナリオだけを実行して、パイプラインのさらに下の方に押し出すことを検討してみてください。
注: 明らかに、ここでは、赤ちゃんを水と一緒に捨てたくないという要素があります。それに応じて考慮してください。

[https://medium.com/@you54f/protecting-your-api-development-workflows-with-swagger-openapi-pact-io-5ba8dca8b9cf](https://medium.com/@you54f/protecting-your-api-development-workflows-with-swagger-openapi-pact-io-5ba8dca8b9cf)

Protecting your API development workflows with Swagger/OpenAPI & [Pact.io](http://pact.io/)

ポイントを持ち帰る
API仕様をSwaggerで書く
バージョン管理に保存し、コラボレーションのためのプロバイダ/消費者へのアクセスを可能にします。
swagger-cliでスワガーの仕様が正しいことを確認する
Pact のさまざまな言語実装のうちの一つを使って、お好きなユニットテストフレームワークで pact のテストを書いてください。(ここでは、TypeScript で書かれた pact-js と Jest を使います)
CI中にテストを実行して契約書を生成する
CI中に、生成された契約書をスワガー仕様と照らし合わせて検証します。
通過した場合は、契約書を契約ブローカーに発行し、支店名をタグ付けする。
それが開発/ステージング/生産の一部である場合は、追加で識別子を付けます。
消費者は、統合/UI/e2eテストで使用するために、契約書からモックプロバイダーを生成することができます。
プロバイダはパクトブローカーから読み取って、消費者の期待に応えているかどうかをテストすることができ、パクトは契約書で指定されたクライアントの要求を模擬します。
すべての参加者はCI時にcan-i-deployツールを使用して、特定の環境で他の消費者/プロバイダと互換性があるかどうかをチェックすることができます。

[https://techlife.cookpad.com/entry/2016/06/28/164247](https://techlife.cookpad.com/entry/2016/06/28/164247)

実践 Pact:マイクロサービス時代のテストツール

pactの具体的な使い方が説明されてる。

[https://qiita.com/os1ma/items/9eadcfb91fa26af762be](https://qiita.com/os1ma/items/9eadcfb91fa26af762be)

REST API 自動テストツールまとめ



