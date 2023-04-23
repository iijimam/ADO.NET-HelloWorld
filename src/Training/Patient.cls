/// 患者用クラス
/// *******
Class Training.Patient Extends %Persistent
{

/// 患者番号
Property PID As %String [ Required ];

/// 患者名
Property Name As %String;

/// 誕生日
Property DOB As %Date(MAXVAL = "+$HOROLOG");

Index PIDIndex On PID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>DOB</Value>
</Value>
<Value name="5">
<Value>UpdateTimeStamp</Value>
</Value>
</Data>
<DataLocation>^Training.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<ExtentSize>0</ExtentSize>
<IdLocation>^Training.PatientD</IdLocation>
<IndexLocation>^Training.PatientI</IndexLocation>
<StreamLocation>^Training.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Property Age As %Integer [ Calculated, SqlComputeCode = {	if {DOB}="" {
		set {Age}=""
	}
	else {
		set {Age}=(+$Horolog-{DOB})\365.25
	}}, SqlComputed ];

Property UpdateTimeStamp As %TimeStamp [ SqlComputeCode = { set {*}=$ZDATETIME($SYSTEM.Util.UTCtoLocalWithZTIMEZONE($ZTIMESTAMP),3)}, SqlComputed, SqlComputeOnChange = %%UPDATE ];

}
