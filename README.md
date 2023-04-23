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