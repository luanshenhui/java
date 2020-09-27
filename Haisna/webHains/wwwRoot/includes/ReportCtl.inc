<% 
'-----------------------------------------------------------------------------
'		共通関数(帳票パラメータ管理テーブルアクセス) (Ver0.0.1)
'		AUTHER  : (NSC)birukawa
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票パラメータ管理テーブル　帳票コードに該当する受診日取得
'
' 引数　　 : (In)     strReportCd            レポートコード
'
' 戻り値　 : 受診日（YYYYMMDD）
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function GetCslDate(strReportCd)

	Dim objRepCtl		'帳票パラメータ管理テーブルアクセス用COMオブジェクト
	Dim strCslDate		'受診日
	Dim lngCount		'レコード件数

	'オブジェクトのインスタンス作成
	Set objRepCtl = Server.CreateObject("HainsReportCtl.ReportCtl")

	'受診日取得
	lngCount = objRepCtl.SelectReportCtl(strReportCd, strCslDate)

	GetCslDate = strCslDate

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票パラメータ管理テーブル更新
'
' 引数　　 : (In)     strReportCd            レポートコード
' 　　　　　 (In)     vntCslDate             受診日
' 　　　　　 (In)     vntUser                ユーザID
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub UpdateReportData(strReportCd, vntCslDate, vntUser)

	Dim objRepCtl		'帳票パラメータ管理テーブルアクセス用COMオブジェクト
	Dim lngRet

	'オブジェクトのインスタンス作成
	Set objRepCtl = Server.CreateObject("HainsReportCtl.ReportCtl")

	'受診日取得
	lngRet = objRepCtl.InsertReportCtl( strReportCd, vntCslDate, vntUser )

End Sub
%>
