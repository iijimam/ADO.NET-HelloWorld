# ADO.NETからIRISに接続するサンプルプログラム

ADO.NETからIRISに接続し、以下のクラスの利用例を記載しています。

- DataReader
- DataSet

## 実行環境の事前準備

VSCodeでC#.NETを実行するため、事前に以下のインストールを行います。

- [C#エクステンション](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)
- [.NET 6 SDK for windows](https://dotnet.microsoft.com/ja-jp/download/dotnet/6.0)

## アプリの作成
[コンソールアプリを作成する](https://learn.microsoft.com/ja-jp/dotnet/core/tutorials/with-visual-studio-code?pivots=dotnet-6-0) を参考にしています。


1. VSCodeを開き、ワークスペースに移動します。


2. ターミナルを開き、以下実行

    ```
    dotnet new console --framework net6.0 --use-program-main
    ```

3. プロジェクトファイルにIRIS用DLLの参照を追加します。

    [*.csproj](/HelloWorld.csproj)を開き、DLLのある場所を指定します。

    ```
    <ItemGroup>
    <Reference Include="InterSystems.Data.IRISClient">
        <HintPath>C:\InterSystems\IRISHealth\dev\dotnet\bin\net6.0\InterSystems.Data.IRISClient.dll</HintPath>
    </Reference>
    </ItemGroup>    
    ```
    IRISのDLLは、`インストールディレクトリ\dev\dotnet\bin\net6.0\InterSystems.Data.IRISClient.dll` を指定してください。

4. コードの記述が終わったら保存し、ターミナルで以下実行します。

    ```
    dotnet run
    ```
    IRISにテーブルやデータの準備がまだの場合は、以下の手順でテーブルとデータの登録を行って下さい。

    - 1) クラス定義のインポート
    
        IRISに接続します。
        
        [settings.json](.vscode/settings.json)の　11～12行目　のサーバ接続情報をアクセスする環境に合わせて変更します。

        `接続に必要な手続き詳細は、コミュニティの記事：[VSCode を使ってみよう！](https://jp.community.intersystems.com/node/482976)をご参照ください。
        
        接続が完了したら、[Training](/src/Training/)を右クリックし2つのクラス定義をインポートします。（フォルダを右クリックし、Import and Compile　でコンパイルを実施します）

    - 2) データのロード（VSCodeのSQLToolsを利用してロードする方法） 

        [load.sql](/src/samples/load.sql)に記述されている LOAD DATAコマンドを利用する場合は、Javaがインストールされている環境が必要です。
        
        >バージョンは8または、11をサポートしています。

        Javaのホームディレクトリを、以下管理ポータルで設定します。

        **管理ポータル > システム管理 > 構成 > 接続性 > 外部言語サーバ > %Java_Server**

        設定を保存したら、LOAD DATAを利用してデータをロードします。

        VSCodeからSQLを実行するには、SQLToolsを利用します。
        
        >必要な設定はコミュニティの記事：[VSCode：SQLTools で IRIS に接続する方法](https://jp.community.intersystems.com/node/489316)をご参照ください。

        実行するSQLを選択し、右クリック > Run Selected Query で実行します。

        **実行前にロードするファイルのフルパスが正しい位置を指定しているかご確認ください。**