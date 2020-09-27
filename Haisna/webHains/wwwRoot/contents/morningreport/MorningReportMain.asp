<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   朝レポート照会  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス

'パラメータ
Dim lngCslYear			'受診日(年)
Dim lngCslMonth			'受診日(月)
Dim lngCslDay			'受診日(日)
Dim strCsCd				'コースコード
Dim blnNeedUnReceipt	'未受付者取得フラグ(True:当日ＩＤ未発番状態も取得)

Dim strUrlPara			'フレームへのパラメータ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")

'引数値の取得
'受診年月日が渡されていない場合、システム年月日を適用する
lngCslYear			= CLng(IIf(Request("cslYear" )="", Year(Now),  Request("cslYear" )))
lngCslMonth			= CLng(IIf(Request("cslMonth")="", Month(Now), Request("cslMonth")))
lngCslDay			= CLng(IIf(Request("cslDay"  )="", Day(Now),   Request("cslDay"  )))
strCsCd				= Request("csCd")
blnNeedUnReceipt	= Request("NeedUnReceipt")

'フレームへのパラメータ設定
strUrlPara = "cslYear=" & lngCslYear 
strUrlPara = strUrlPara & "&cslMonth=" & lngCslMonth
strUrlPara = strUrlPara & "&cslDay=" & lngCslDay
strUrlPara = strUrlPara & "&csCd=" & strCsCd
strUrlPara = strUrlPara & "&NeedUnReceipt=" & blnNeedUnReceipt

%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>朝レポート照会</TITLE>
</HEAD>
<FRAMESET BORDER="0" FRAMEBORDER="no" FRAMESPACING="5" ROWS="120,245,*">
	<FRAME NAME="header" NORESIZE SRC="MorningReportHeader.asp?<%= strUrlPara %>">
	<FRAMESET COLS="5,250,540,240,*" FRAMEBORDER="no">
		<FRAME NAME="blank" NORESIZE SRC="../common/blank.html">
		<FRAME NAME="Report1" NORESIZE SRC="RsvFraSummary.asp?<%= strUrlPara %>">
		<FRAME NAME="Report2" NORESIZE SRC="FriendSummary.asp?<%= strUrlPara %>">
		<FRAME NAME="Report3" NORESIZE SRC="SameName.asp?<%= strUrlPara %>">
		<FRAME NAME="blank" NORESIZE SRC="../common/blank.html">
	</FRAMESET>
	<FRAMESET COLS="5,250,*">
		<FRAME NAME="blank" NORESIZE SRC="../common/blank.html">
		<FRAME NAME="Report4" NORESIZE SRC="SetCountInfo.asp?<%= strUrlPara %>">
		<FRAMESET BORDER="10" FRAMEBORDER="no" FRAMESPACING="5" ROWS="100,*">
			<FRAME NAME="Report5" NORESIZE SRC="volunteerInfo.asp?<%= strUrlPara %>">
			<FRAME NAME="Report6" NORESIZE SRC="TroubleInfo.asp?<%= strUrlPara %>">
		</FRAMESET>
	</FRAMESET>
	<NOFRAMES>
		<BODY BGCOLOR="#ffffff">
			<P></P>
		</BODY>
	</NOFRAMES>
</FRAMESET>
</HTML>