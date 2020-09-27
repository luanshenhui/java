<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   健診前準備（問診）入力  (Ver0.0.1)
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
<TITLE>問診入力</TITLE>
</HEAD>
<FRAMESET BORDER="0" FRAMEBORDER="no" FRAMESPACING="0" ROWS="100,*">

	<FRAME NAME="naviBar" NORESIZE SRC="preparationInfoHeader.asp?rsvno=<%=lngRsvNo%>">
	<FRAMESET BORDER="0" COLS="300,*" FRAMEBORDER="no" FRAMESPACING="0">
		<FRAME NAME="prepaInfoBasic" NORESIZE SRC="prepaInfoBasic.asp?rsvno=<%=lngRsvNo%>">
		<FRAMESET BORDER="0" COLS="330,*" FRAMEBORDER="no" FRAMESPACING="0">
			<FRAMESET BORDER="0" FRAMEBORDER="no" FRAMESPACING="10" ROWS="250,*">
				<FRAME NAME="prepaInfoDisease" NORESIZE SRC="prepaInfoDisease.asp?rsvno=<%=lngRsvNo%>">
				<FRAME NAME="detail" NORESIZE SRC="prepaInfoReexamin.asp?rsvno=<%=lngRsvNo%>">
			</FRAMESET>
			<FRAMESET BORDER="10" FRAMEBORDER="no" FRAMESPACING="10" ROWS="250,*">
				<FRAME NAME="prepaInfoCmntHis" NORESIZE SRC="prepaInfoCmntHis.asp?rsvno=<%=lngRsvNo%>">
				<FRAME NAME="prepaInfoSecond" NORESIZE SRC="prepaInfoSecond.asp?rsvno=<%=lngRsvNo%>">
			</FRAMESET>
		</FRAMESET>
	</FRAMESET>
</FRAMESET>
</HTML>
