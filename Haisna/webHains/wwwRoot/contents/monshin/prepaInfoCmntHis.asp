<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   健診前準備（問診）入力 前回総合コメントメイン  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'パラメータ
Dim lngRsvNo			'予約番号

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
lngRsvNo			= Request("rsvno")

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>前回総合コメント</TITLE>

<FRAMESET FRAMEBORDER="no" ROWS="52,*">
	<FRAME NAME="CmntHisHeader" NORESIZE SRC="prepaInfoCmntHisHeader.asp">
	<FRAME NAME="CmntHisBody" NORESIZE SRC="prepaInfoCmntHisBody.asp?rsvno=<%=lngRsvNo%>">
	<NOFRAMES></NOFRAMES>
</FRAMESET>