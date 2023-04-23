/* データのロード（ディレクトリ変更要） 
    事前に環境変数 JAVA_HOMEにJAVAのインストールディレクトリを設定するか、
    外部言語サーバの%Java_Serverの「Javaホームディレクトリ」に設定が必要です
*/
LOAD DATA FROM FILE 'C:\WorkSpace\ADO.NET-HelloWorld\src\samples\Patientインポートデータ.txt'
 INTO Training.Patient (DOB,Name,PID)
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

select * from Training.Patient

LOAD DATA FROM FILE 'C:\WorkSpace\ADO.NET-HelloWorld\src\samples\Visitインポートデータ.txt'
 INTO Training.Visit
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

select * from Training.Visit