<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   変更履歴  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ
Dim	strWinMode			'ウィンドウモード

Dim strAct				'処理状態
Dim strUrlPara			'フレームへのパラメータ
Dim lngRsvNo			'予約番号

Dim strFromDate			'更新日（開始）
Dim strFromYear			'更新日　年（開始）
Dim strFromMonth		'更新日　月（開始）
Dim strFromDay			'更新日　日（開始）
Dim strToDate			'更新日（開始）
Dim strToYear			'更新日　年（開始）
Dim strToMonth			'更新日　月（開始）
Dim strToDay			'更新日　日（開始）
Dim strUpdUser			'更新者
Dim strClass			'更新分類
Dim lngOrderbyItem		'並べ替え項目(0:更新日,1:更新者,2:分類・項目）
Dim lngOrderbyMode      '並べ替え方法(0:昇順,1:降順)
Dim lngStartPos			'表示開始位置
Dim lngPageMaxLine		'１ページ表示ＭＡＸ行
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")
strFromDate         = Request("fromDate")
strFromYear         = Request("fromyear")
strFromMonth        = Request("frommonth")
strFromDay          = Request("fromday")
strToDate           = Request("toDate")
strToYear           = Request("toyear")
strToMonth          = Request("tomonth")
strToDay            = Request("today")
strUpdUser          = Request("upduser")
strClass            = Request("updclass")
lngOrderbyItem      = Request("orderbyItem")
lngOrderbyMode      = Request("orderbyMode")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")



'フレームへのパラメータ設定
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&action="      & strAct
strUrlPara = strUrlPara & "&rsvno="       & lngRsvNo
strUrlPara = strUrlPara & "&fromDate="    & strFromDate
strUrlPara = strUrlPara & "&fromyear="    & strFromYear
strUrlPara = strUrlPara & "&frommonth="   & strFromMonth
strUrlPara = strUrlPara & "&fromday="     & strFromDay
strUrlPara = strUrlPara & "&toDate="      & strToDate
strUrlPara = strUrlPara & "&toyear="      & strToYear
strUrlPara = strUrlPara & "&tomonth="     & strToMonth
strUrlPara = strUrlPara & "&today="       & strToDay
strUrlPara = strUrlPara & "&upduser="     & strUpdUser
strUrlPara = strUrlPara & "&updclass="    & strClass
strUrlPara = strUrlPara & "&orderbyItem=" & lngOrderbyItem
strUrlPara = strUrlPara & "&orderbyMode=" & lngOrderbyMode
strUrlPara = strUrlPara & "&startPos="    & lngStartPos
strUrlPara = strUrlPara & "&pageMaxLine=" & lngPageMaxLine
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>変更履歴</TITLE>
<script type="text/javascript">
var params = {
    action:      "<%= strAct %>",
    winmode:     "<%= strWinMode %>",
    rsvno:       "<%= lngRsvNo %>",
    fromDate:    "<%= strFromDate %>",
    fromyear:    "<%= strFromYear %>",
    frommonth:   "<%= strFromMonth %>",
    fromday:     "<%= strFromDay %>",
    toDate:      "<%= strToDate %>",
    toyear:      "<%= strToYear %>",
    tomonth:     "<%= strToMonth %>",
    today:       "<%= strToDay %>",
    upduser:     "<%= strUpdUser %>",
    updclass:    "<%= strClass %>",
    orderbyItem: "<%= lngOrderbyItem %>",
    orderbyMode: "<%= lngOrderbyMode %>",
    startPos:    "<%= lngStartPos %>",
    pageMaxLine: "<%= lngPageMaxLine %>"
};
</script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%=IIf(strWinMode=1,180,110)%>,*">
	<FRAME NAME="header" SRC="rslUpdateHistoryHeader.asp<%=strUrlPara%>">
	<FRAME NAME="bodyview"  SRC="rslUpdateHistoryBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
