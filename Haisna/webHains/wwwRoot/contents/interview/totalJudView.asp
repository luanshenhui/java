<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   検査結果表示タイプ３～参照モード  (Ver0.0.1)
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
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim lngRsvNo			'予約番号（今回分）
Dim strGrpCd			'グループコード
Dim strCsCd				'コースコード

Dim strAct				'処理状態
Dim strUrlPara			'フレームへのパラメータ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")
strGrpCd			= Request("grpcd")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")

'### 2004/01/07 K.Kagawa コースしばりのデフォルト値を判断する
If strSelCsGrp = "" Then
	Dim objInterView	'面接情報アクセス用
	Dim lngCsGrpCnt		'コースグループ数
	Dim vntCsGrpCd		'コースグループコード

	'コースグループ取得
	Set objInterView = Server.CreateObject("HainsInterView.InterView")
	lngCsGrpCnt = objInterview.SelectCsGrp( lngRsvNo, vntCsGrpCd )
	If lngCsGrpCnt > 0 Then
		strSelCsGrp = vntCsGrpCd(0)
	Else
		strSelCsGrp = "0"
	End If
	Set objInterView = Nothing
End If

'フレームへのパラメータ設定
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
strUrlPara = strUrlPara & "&grpcd=" & strGrpCd
strUrlPara = strUrlPara & "&cscd=" & strCsCd
strUrlPara = strUrlPara & "&csgrp=" & strSelCsGrp
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>総合判定入力</TITLE>
<script type="text/javascript">
var params = {
    action:  "<%= strAct %>",
    rsvno:   "<%= lngRsvNo %>",
    cscd:    "<%= strCsCd %>",
    winmode: "<%= strWinMode %>",
    grpcd:   "<%= strGrpCd %>",
    csgrp:   "<%= strSelCsGrp %>"
};
</script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%=IIf(strWinMode=1,150,65)%>,*">
	<FRAME NAME="header" SRC="totalJudHeader.asp<%=strUrlPara%>">
	<FRAME NAME="bodyview"  SRC="totalJudViewBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
