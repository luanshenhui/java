# Hainsi

ここに様々な共通情報を書き溜めていきます。

## 内容

- アーキテクチャ
- 開発に使用するアプリケーションの一覧
- リポジトリの設置
- ディレクトリ構成
- デバッグ実行方法
- Gitリポジトリの運用ルール

## アーキテクチャ

- サーバサイド
  - サーバ：IIS + .NET Core V2.0（ターゲットフレームワークは .NET Framework 4.7）
  - 開発言語：C#
  - DBMS：Oracle 12c
  - 帳票出力：CoReports .NET
- クライアントサイド
  - 使用フレームワーク：React+Redux
  - 開発言語：JavaScript（ECMAScript2015）

## 開発に使用するアプリケーションの一覧

### Node.js

- <https://nodejs.org/ja/>
- 今回フロントエンドにReactを採用することから開発には欠かせない。
- 後述するVisual Studio Community 2017でも内蔵されているが、内臓されているバージョンが古いのと、Node自体頻繁にバージョンアップが行われるため、これとは独立してインストールする方針とする。

### Visual Studio Community 2017（以下VS2017）

- <https://www.visualstudio.com/ja/downloads/>
- ターゲットフレームワークは NET Framework 4.7
- プロジェクト管理やバックエンド部（C#）のコーディングで主に使用。
- 環境設定（「ツール」－「オプション」）
  - 「プロジェクトおよびソリューション」ー「Web Package Management」ー「外部Webツール」
    - 外部Webツールの場所で、Node.jsのインストールディレクトリが先頭にくるように修正
    - 通常はC:\Program Files\nodejs
  - 「テキストエディタ」ー「C#」ー「タブ」
    - タブ、インデントのサイズはともに4
    - 「空白の挿入」を選択

### Visual Studio Code（以下VSCode）

- <https://www.microsoft.com/ja-jp/dev/products/code-vs.aspx>
- フロントエンド部の開発についてはVS2017ではなくこちらを推奨
- VS2017でもできなくはないが、開発を効率化するための拡張機能が充実
- 拡張機能の設定
  - （ここにVSCodeのお薦め拡張機能を加筆していきます）

### CoReports for .NET

- 帳票開発用

### Git For Windows

- <https://git-scm.com/>
- バージョン管理

### SourceTree

- <https://ja.atlassian.com/software/sourcetree>
- Gitクライアントソフト
- Windowsで使えるGitクライアントの中では最も高性能
- インストール後、以下の設定を行う
  - 「ツール」－「オプション」－「Git」で「システムGitを使用」を選択（Git For Windowsが先にインストールされていることが前提）

### A5SQL

- <https://a5m2.mmatsubara.com/>
- SQL開発ツール
- データの閲覧やSQLの実行、解析まで万能にこなす
- 現行のVBソースからSQL部分を抽出し、整形までを行うコードストリッパー及びSQL整形機能が今回のマイグレーション作業と高い親和性を持つ

### SmoothCSV

- <http://smoothcsv.com/>
- CSV閲覧、編集ツール
- ExcelでCSVファイルを開く際の障壁となる「数値の先頭０がフォーマットされてしまう」現象を回避できる

## リポジトリの設置

- C:\Hainsi ディレクトリ配下に本リポジトリを設置
- 他のディレクトリでも動作はすると思われるがここでは本ディレクトリを推奨とする

## ディレクトリ構成

（工事中）

## デバッグ実行方法

（注：2018/1/19現在版。今後更なる効率化のために内容は改変される可能性があります。）

### VS2017での処理

- ソリューション（C:\Hainsi\hainsi.sln）を開く
- （初回のみ）C:\Hainsi\WebSite\Web.config のOracle接続情報部（以下のxxx部）を環境に応じて書き換える

    ```xml
    <dataSource alias="HAINSDB" descriptor="(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=xxx.xxx.xxx.xxx)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=HAINSDB))) " />
    ```
    ```xml
    <add name="OracleDbContext" providerName="Oracle.ManagedDataAccess.Client" connectionString="User Id=xxxxxxxx;Password=xxxxxxxx;Data Source=HAINSDB"/>
    ```

- デバッグ実行（メニューから「デバッグ」－「デバッグの開始」）
- スタートアッププロジェクトであるWebSiteプロジェクトでは開始動作で「ページを開かずに外部アプリケーションからの要求を待つ」としているため、ブラウザは立ち上がらない
- ブレークポイントを指定しておけばフロントエンドからアクセスされた場合に停止させることができる

### VSCodeでの実行

- 「フォルダーを開く」で C:\Hainsi ディレクトリを開く
- 統合ターミナル（コマンドプロンプト）を開く
- C:\Hainsi\WebSite ディレクトリに移動する

    ```dos
    C:\Hainsi> cd \Hainsi\WebSite
    ```

- （初回のみ）npm installと入力してEnter。必要なパッケージがインストールされる。

    ```dos
    C:\Hainsi\webSite> npm install
    ```

- npm run startと入力してEnter

    ```dos
    C:\Hainsi\webSite> npm run start
    ```

- <http://localhost:8080/> というテストサイトが立ち上がり、フロントエンド部のデバッグが行える
- APIを呼び出すとバックエンド実装部が動作するため、バックエンド部のデバックも行える
- フロントエンドのコード変更を監視しているため、変更して保存するとブラウザが自動でリロードされる

### VSCode上でのステップデバッギング

- （工事中）

## Gitリポジトリの運用ルール

### ワークフロー

基本的に、GitHub Flowで採用されている考え方を採用します。

### 基本的な流れ

- 新しい何かに取り組む際は、説明的な名前のブランチをmasterから作成する
- ブランチ名は「会社名を示す任意の英数字」＋／（スラッシュ）＋「説明的名称」
  - （例）rounddegisn/creating_person_dao
- 作成したブランチにローカルでコミットし、サーバー上の同じ名前のブランチにも定期的に作業内容をpushする
- フィードバックや助言が欲しい場合、また、ブランチをマージしてもよいと思った場合はプルリクエストを作成する
- プルリクエストの結果、レビューによって承認が得られた場合はmasterへマージすることができる

### コミットメッセージの記述方法

- フォーマットは次のとおりとする
  - 1行目：コミット種別: 要約
  - 2行目：空行
  - 3行目以降：詳細内容
- コミット種別は以下から選択する
  - feat：新しい機能
  - fix：機能修正、バグフィックス
  - docs：ドキュメントのみ変更
  - style：コードの意味に影響を与えない変更（空白、フォーマット、セミコロンの欠落など）
  - refactor：バグを修正したり、機能を追加したりしないコード変更
  - perf：パフォーマンスを向上させるコード変更
  - test：既存のテストの欠落または修正の追加
  - chore：ビルドプロセスやドキュメント作成などの補助ツールやライブラリの変更

### コミットメッセージの記述例

```text
fix: ○○情報の登録時に削除フラグが更新されない不具合の修正

更新SQLの対象カラムに削除フラグが含まれていなかったため追加しました。
```

### コミット単位について

- コミットは出来る限り細かい機能単位で行うことを推奨します。
- 他のメンバーや、また自分自身にとっても、修正内容をさかのぼったりする場合の助けとなります。
- 例えば、複数のバグ修正をひとつにまとめてコミットするのはNGです。
- この場合、1つのバグ修正につき1つのコミットとするのが正しい方法です。

### 参考

- [【今日からできる】コミットメッセージに 「プレフィックス」 をつけるだけで、開発効率が上がった話](https://qiita.com/numanomanu/items/45dd285b286a1f7280ed)
- [GitHub Flow](https://gist.github.com/Gab-km/3705015)
- [Gitのコミットメッセージの書き方](https://qiita.com/itosho/items/9565c6ad2ffc24c09364)
