namespace ADO.NET_HelloWorld;
using InterSystems.Data.IRISClient;
using System.Data; // DataSetのため
#nullable disable warnings  //CS8600を無視するため
class Program
{
    static void Main(string[] args)
    {
        IRISConnection cn = new IRISConnection();
        cn.ConnectionString = "Server = 127.0.0.1; Port=51778; Namespace=USER; Password = SYS; User ID = SuperUser;";
        cn.Open();

        // ●●●　検索の例 ●●●
        Console.WriteLine();
        Console.WriteLine("○○○　DataReaderを使った検索文実行　○○○");
        Console.Write(">>>　患者さん名（前方一致）を条件に通院データを表示：（未指定の場合全件表示）>>>　");
        string input1;
        input1 = Console.ReadLine();
        Console.WriteLine();

        // IRISへクエリ実行を依頼するためDataReaderを使用する
        string query = "select v.VisitDate,v.Symptom,p.PID,p.Name from Training.Patient p ,Training.Visit v where (p.PID=v.Patient) and (p.Name %Startswith ?)";
        IRISCommand cmd = new IRISCommand(query, cn);
        IRISParameter p1 = new IRISParameter("Name", input1);
        cmd.Parameters.Add(p1);
        IRISDataReader reader = cmd.ExecuteReader();

        Console.WriteLine("通院日付 - 症状 - 患者番号 - 名前");

        while (reader.Read())
        {
            //Console.WriteLine( r[r.GetOrdinal("Name")] + ": " + r[r.GetOrdinal("Email")]);
            Console.WriteLine("{0},{1},{2},{3}",
             reader[reader.GetOrdinal("VisitDate")] , reader[reader.GetOrdinal("Symptom")] , 
             reader[reader.GetOrdinal("PID")] ,reader[reader.GetOrdinal("Name")]);
        }
        reader.Close();

        // ●●●　ストアドプロシージャの実行 ●●●
        Console.Write("○○○　続いて、ストアドプロシージャ(Training.ByVisitDate())を実行します。Enterを押してください＞＞○○○");
        input1 = Console.ReadLine();
        cmd = new IRISCommand("Training.ByVisitDateSaveToCSV",cn);
        cmd.CommandType=CommandType.StoredProcedure;
        int status=cmd.ExecuteNonQuery();

        //

        // ●●●　DataSetでの操作サンプル　●●●
        //DataSetの作成
        Console.Write("○○○　2012-12-30以降のTraining.VisitのレコードをDataSetを利用して操作します。Enterを押してください＞＞○○○");
        input1 = Console.ReadLine();
        query = "select Patient,Symptom,VisitDate from Training.Visit where VisitDate>?";
        cmd = new IRISCommand(query, cn);
        //引数：VisitDate（%Date）
        IRISParameter vd=new IRISParameter("VisitDate",IRISDbType.Date);
        vd.Value="2012-12-30";
        cmd.Parameters.Add(vd);
        IRISDataAdapter IRISAdapter=new IRISDataAdapter();
        IRISAdapter.TableMappings.Add("Table","Visit");
        IRISAdapter.SelectCommand=cmd;

        /*IRISDataAdapterオブジェクトでマッピングされたデータの変更を
        IRISCommandBuilderによって生成されたSQLで更新できるようにするためBuiderオブジェクトを作成*/
        IRISCommandBuilder builder=new IRISCommandBuilder(IRISAdapter);
        
        DataSet VisitDS = new DataSet();
        IRISAdapter.Fill(VisitDS);
        DataTable dt = VisitDS.Tables["Visit"];
        
        Console.WriteLine("○○○ DataSet内データを表示します　○○○");

        if (dt.Rows.Count > 0) {
            foreach (DataRow visitrow in dt.Rows) {
                Console.WriteLine(
                    visitrow["Patient"] + "\t"+
                    visitrow["VisitDate"]+ "\t"+
                    visitrow["Symptom"]+"\t"
                );
            }
        }

        //DataSetに1行追加します
        Console.WriteLine("○○○　DataSetに1行追加します。P0001の患者の通院日と症状を追加します＞＞○○○");
        Console.Write("通院日を指定してください（YYYY-MM-DD）＞＞");
        input1 = Console.ReadLine();
        DataRow dr=dt.NewRow();
        dr["VisitDate"]=input1;

        Console.Write("症状を指定してください（例：発熱）＞＞");
        input1 = Console.ReadLine();
        dr["Symptom"]=input1;

        dr["Patient"]="P0001";
        dt.Rows.Add(dr);

        IRISAdapter.Update(VisitDS);

        /*DataSetに更新されたか確認*/
        DataColumnCollection columns=dt.Columns;
        DataRowCollection rows=dt.Rows;

        for (int r = 0; r < rows.Count; r++)
        {
            for (int c = 0; c < columns.Count; c++)
            {
                Console.Write(rows[r][c] + "\t");
            }
            Console.WriteLine();
        }
        Console.WriteLine("○○○　DataSetで更新した行がIRIS側に反映されていることを管理ポータルなどで確認してください　○○○");
        Console.WriteLine("○○○　確認が終了したらEnterをクリックして終了してください　○○○");
        input1 = Console.ReadLine();

        cmd.Dispose(); cn.Close();
        Console.WriteLine("Done!");
    }
}
