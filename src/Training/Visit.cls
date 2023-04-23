Class Training.Visit Extends %Persistent
{

Property Patient As %String;

/// 症状
Property Symptom As %String;

/// 診察日
Property VisitDate As %Date;

ForeignKey PatientFK(Patient) References Training.Patient(PIDIndex);

/// SQLの結果をファイルへ出力するストアドプロシージャを作成
/// 診療日付別、症状別、来院数をCSVファイルへ出力
ClassMethod ByVisitDateSaveToCSV() [ SqlName = ByVisitDateSaveToCSV, SqlProc ]
{
	//　ストアドプロシージャとして呼ばれた時の結果格納用オブジェクト
	#dim %sqlcontext As %ProcedureContext	
	// 検索結果をファイル出力したいので、ファイル用オブジェクト作成
	set file=##class(%Stream.FileCharacter).%New()
	set file.Filename="c:\temp\output.txt"
	do file.WriteLine("診療日付,症状,来院数")
	#sqlcompile select =odbc
	&sql(declare C1 cursor for
	select VisitDate,Count(*),SympTom into :VisitDate,:Count,:Symptom
	from Training.Visit
	Group by VisitDate,Symptom
	Order by VisitDate Desc
	)
	&sql(open C1)
	for {
		&sql(fetch C1)
		if SQLCODE'=0 { quit }
		set record=""
		set $piece(record,",",1)=VisitDate
		set $piece(record,",",2)=Symptom
		set $piece(record,",",3)=Count
		do file.WriteLine(record)
	}
	set %sqlcontext.%SQLCODE=SQLCODE
	
	if SQLCODE<0 {
		set %sqlcontext.%Message=%msg
		&sql(Close C1)
		quit
	}
	&sql(Close C1)
	set st=file.%Save()
}

Storage Default
{
<Data name="VisitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Patient</Value>
</Value>
<Value name="3">
<Value>Symptom</Value>
</Value>
<Value name="4">
<Value>VisitDate</Value>
</Value>
</Data>
<DataLocation>^Training.VisitD</DataLocation>
<DefaultData>VisitDefaultData</DefaultData>
<ExtentSize>9</ExtentSize>
<IdLocation>^Training.VisitD</IdLocation>
<IndexLocation>^Training.VisitI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Patient">
<AverageFieldSize>7</AverageFieldSize>
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="Symptom">
<AverageFieldSize>12.67</AverageFieldSize>
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="VisitDate">
<AverageFieldSize>4</AverageFieldSize>
<Selectivity>14.2857%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^Training.VisitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
