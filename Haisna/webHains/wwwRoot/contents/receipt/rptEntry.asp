<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		受付処理 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用

'引数値
Dim strRsvNo		'予約番号

'受診情報
Dim strCancelFlg	'キャンセルフラグ
Dim strCslDate		'受診年月日
Dim strPerId		'個人ＩＤ
Dim strCsCd			'コースコード
Dim strDayId		'当日ＩＤ
Dim strCtrPtCd		'契約パターンコード

Dim strURL			'ジャンプ先のURL

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strRsvNo = Request("rsvNo")

'受診情報読み込み
If objConsult.SelectConsult(strRsvNo,     _
							strCancelFlg, _
							strCslDate,   _
							strPerId,     _
							strCsCd, , , , , , , , , , , , , , , , , , , , _
							strDayId, , , , , , , , , , , , , , , , _
							strCtrPtCd) = False Then
	Err.Raise 1000, , "受診情報が存在しません。"
End If

'キャンセル者は受付できない
If CLng("0" & strCancelFlg) <> CONSULT_USED Then
	Err.Raise 1000, , "この受診情報はキャンセルされています。"
End If

'未受付の場合
If strDayId = "" Then

	'受付処理画面を呼び出す
	strURL = "rptEntryFromDetail.asp"
	strURL = strURL & "?calledFrom=list"
	strURL = strURL & "&rsvNo="    & strRsvNo
	strURL = strURL & "&perId="    & strPerId
	strURL = strURL & "&csCd="     & strCsCd
	strURL = strURL & "&cslYear="  & Year(CDate(strCslDate))
	strURL = strURL & "&cslMonth=" & Month(CDate(strCslDate))
	strURL = strURL & "&cslDay="   & Day(CDate(strCslDate))
	strURL = strURL & "&ctrPtCd="  & strCtrPtCd

'受付済みの場合
Else

	'受付取り消し画面を呼び出す
	strURL = "rptCancel.asp"
	strURL = strURL & "?calledFrom=list"
	strURL = strURL & "&rsvNo=" & strRsvNo

End If

Response.Redirect strURL
%>
