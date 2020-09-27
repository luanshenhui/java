<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		特定健診面接支援メイン (Ver0.0.1)
'		AUTHER  : 
'-----------------------------------------------------------------------------
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
Dim lngRsvNo        '予約番号

Dim strURL          'URL文字列
Dim mainURL         'URL文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
lngRsvNo    = Request("rsvNo")

'初期表示のURLセット
mainURL = "specialJudView.asp?rsvNo=" & lngRsvNo
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>面接支援</TITLE>
</HEAD>
<FRAMESET ROWS="125,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
    strURL = "specialJudHeader.asp"
    strURL = strURL & "?rsvNo=" & lngRsvNo
%>
    <FRAME SRC="<%= strURL %>" NAME="header" NORESIZE>
    <FRAME SRC="<%= mainURL %>" NAME="main" NORESIZE>
</FRAMESET>
</HTML>
