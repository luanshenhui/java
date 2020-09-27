<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		予約一括処理の選択 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>予約一括処理の選択</TITLE>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">予約一括処理の選択</FONT></B></TD>
	</TR>
</TABLE>

<BR>

<A HREF="rsvAllFromPerson.asp">個人情報を参照して１次健診の一括予約を行う</A><BR><BR>
<A HREF="rsvAllFromCsv.asp">CSVデータをもとに１次健診の一括予約を行う</A><BR><BR>
<A HREF="rsvAllFromResult.asp">健診結果を参照して２次健診の一括予約を行う</A><BR><BR>
<A HREF="rsvAllDelete.asp">予約の一括削除を行う</A><BR><BR>
<A HREF="rsvAllUpdateOption.asp">指定された受診情報のオプション検査を標準に戻す</A><BR><BR>
<A HREF="rsvAllUpdateBsd.asp">指定された受診情報の事業部～所属を最新個人データで更新</A><BR><BR>

</BLOCKQUOTE>
</BODY>
</HTML>