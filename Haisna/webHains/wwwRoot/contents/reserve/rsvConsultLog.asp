<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   変更履歴詳細 (Ver0.0.1)
'	   AUTHER  : Tsutomy Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objConsult	'受診情報アクセス用

'パラメータ値
Dim lngRsvNo	'予約番号
Dim lngSeq		'SEQ

Dim strUpdDate	'更新日
Dim strUpdUser	'ユーザＩＤ
Dim strUserName	'ユーザ名
Dim strCslInfo	'予約更新情報

Dim Ret			'関数戻り値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
lngRsvNo = CLng("0" & Request("rsvNo"))
lngSeq   = CLng("0" & Request("seq"))

'受診情報ログの読み込み
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Ret = objConsult.SelectConsultLog(lngRsvNo, lngSeq, strUpdDate, strUpdUser, strUserName, strCslInfo)
Set objConsult = Nothing

If Ret = False Then
	Err.Raise 1000, , "ログ情報が存在しません。"
End If

If InStr(strCslInfo, "<CONSULT>") > 0 Then

'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
Response.ContentType = "text/xml"
Response.Write "<?xml version=""1.0"" encoding=""Shift_JIS"" ?>"
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####
%>
<%
'#### 2013.3.1 SL-SN-Y0101-612 DEL START ####
'<?xml version="1.0" encoding="Shift_JIS" ?>
'#### 2013.3.1 SL-SN-Y0101-612 DEL END   ####
%>
<?xml-stylesheet type="text/xsl" href="rsvConsultLog.xsl" ?>
<%= strCslInfo %>
<%
'XMLでない暫定版用
Else
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>検査セット情報の比較</TITLE>
</HEAD>
<BODY BGCOLOR="#ffffff">

<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">予約更新情報</FONT></B></TD>
	</TR>
</TABLE>
<BR>
メッセージ：<%= strCslInfo %>
</BODY>
</HTML>
<%
End If
%>
