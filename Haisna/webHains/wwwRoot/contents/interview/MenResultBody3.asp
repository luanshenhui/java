<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   検査結果表示タイプ３～参照モード（ボディ）  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strGrpNo			'グループNo
Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード

Dim lngLastDspMode		'前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp			'前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
Dim vntPerId			'個人ＩＤ
Dim vntRsvNo			'予約番号
Dim vntCslDate			'受診日
Dim vntCsCd				'コースコード
Dim vntCsName			'コース名
Dim vntCsSName			'コース略称
Dim lngHisCount			'表示歴数

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strSelCsGrp			= IIf(strSelCsGrp="", "0", strSelCsGrp)
lngEntryMode		= Request("entrymode")
lngEntryMode		= IIf(lngEntryMode="", INTERVIEWRESULT_REFER, lngEntryMode)
lngHideFlg			= Request("hideflg")
lngHideFlg			= IIf(lngHideFlg="", "1", lngHideFlg)

'グループ情報取得
Call GetMenResultGrpInfo(strGrpNo)

Select Case strSelCsGrp
	'すべてのコース
	Case "0"
		lngLastDspMode = 0
		vntCsGrp = ""
	'同一コース
	Case "1"
		lngLastDspMode = 1
		vntCsGrp = strCsCd
	Case Else
		lngLastDspMode = 2
		vntCsGrp = strSelCsGrp
End Select

Do	
	'指定された個人ＩＤの受診歴一覧を取得する
	lngHisCount = objInterView.SelectConsultHistory( _
						lngRsvNo, _
						False, _
						lngLastDspMode, _
						vntCsGrp, _
						3, _
						0, _
						vntPerId, _
						vntRsvNo, _
						vntCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "受診歴が取得できません。（予約番号 = " & lngRsvNo & ")"
	End If

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>検査結果表示</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="entrymode" VALUE="<%= lngEntryMode %>">
	<INPUT TYPE="hidden" NAME="hideflg"   VALUE="<%= lngHideFlg %>">

	<!-- 検査結果の一覧表示 -->
<%
	Call EditMenResultTable3( lngHisCount, vntRsvNo, lngRsvNo, strMenResultGrpCd3, lngLastDspMode, vntCsGrp )
%>
</FORM>
</BODY>
</HTML>
