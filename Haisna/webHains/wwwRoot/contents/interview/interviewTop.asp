<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		面接支援メイン (Ver0.0.1)
'		AUTHER  : H.Kamata@ffcs.co.jp
'-----------------------------------------------------------------------------
'========================================
'管理番号：SL-SN-Y0101-305
'修正日  ：2011.07.01
'担当者  ：ORB)YAGUCHI
'修正内容：ヘッダー部のレイアウト微調整
'========================================
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト

'前画面から送信されるパラメータ値
Dim lngRsvNo		'予約番号
Dim lngIndex		'インデックス（画面選択コンボ）

Dim strURL			'URL文字列
Dim mainURL			'URL文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
lngRsvNo    = Request("rsvNo")
lngIndex    = Request("index")

'初期表示のURLセット
strURL = "totalJudView.asp?grpno=0"
strURL = strURL & "&rsvNo=" & lngRsvNo
strURL = strURL & "&winmode=0"

mainURL = IIf( Request("urlname") <> "", Request("urlname"), strURL)

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>面接支援</TITLE>
</HEAD>
<%'#### 2011.07.01 SL-SN-Y0101-305 ADD START ####%>
<!--<FRAMESET ROWS="125,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">-->
<FRAMESET ROWS="120,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%'#### 2011.07.01 SL-SN-Y0101-305 ADD END ####%>
<%
	strURL = "interviewHeader.asp"
	strURL = strURL & "?rsvNo=" & lngRsvNo
	strURL = strURL & "&Index=" & lngIndex
%>
	<FRAME SRC="<%= strURL %>" NAME="header" NORESIZE>
	<FRAME SRC="<%= mainURL %>" NAME="main" NORESIZE>
</FRAMESET>
</HTML>
