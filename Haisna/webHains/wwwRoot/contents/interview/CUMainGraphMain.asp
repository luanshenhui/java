<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ＣＵ経年変化 (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim lngRsvNo			'予約番号（今回分）
Dim strGrpNo			'グループNo
Dim strCsCd				'コースコード
Dim strArrItemCd		'検査項目コード
Dim strArrSuffix		'サフィックス

Dim strUrlPara			'フレームへのパラメータ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strArrItemCd		= Request("itemcd")
strArrSuffix		= Request("suffix")

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
strUrlPara = strUrlPara & "&grpno=" & strGrpNo
strUrlPara = strUrlPara & "&cscd=" & strCsCd
strUrlPara = strUrlPara & "&csgrp=" & strSelCsGrp
strUrlPara = strUrlPara & "&itemcd=" & strArrItemCd
strUrlPara = strUrlPara & "&suffix=" & strArrSuffix
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>ＣＵ経年変化</TITLE>
<script type="text/javascript">
var params = {
    winmode: "<%= strWinMode %>",
    grpno:   "<%= strGrpNo %>",
    rsvno:   "<%= lngRsvNo %>",
    cscd:    "<%= strCsCd %>",
    csgrp:   "<%= strSelCsGrp %>",
    itemcd:  "<%= strArrItemCd %>",
    suffix:  "<%= strArrSuffix %>"
};
</script>
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%=IIf(strWinMode=1,430,365)%>,*">
	<FRAME NAME="graph"  SRC="CUMainGraph.asp<%=strUrlPara%>">
	<FRAME NAME="result" SRC="CUResult.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
