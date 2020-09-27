<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'	   フォローアップ種類の選択 (Ver0.0.1)
'	   AUTHER  : 
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>フォローアップ種類の選択</TITLE>
<STYLE TYPE="text/css">
<!--
td.flwtab  { background-color:#FFFFFF }
-->
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
    <TR VALIGN="bottom">
        <TD COLSPAN="2"><FONT SIZE="+2"><B>フォローアップ</B></FONT></TD>
    </TR>
    <TR HEIGHT="2">
        <TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2"></TD>
    </TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="500">
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/follow/followInfoList.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/follow/followInfoList.asp">フォローアップ検索</A></SPAN></TD>
    </TR>
    <TR>
        <TD COLSPAN="4" VALIGN="top">フォローアップ対象者検索画面を表示します。</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/follow/followExhortList.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/follow/followExhortList.asp">勧奨対象者検索</A></SPAN></TD>
    </TR>
    <TR>
        <TD COLSPAN="4" VALIGN="top">勧奨対象者検索画面を表示します。</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/follow/followReqSend.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/follow/followReqSend.asp">依頼状発送確認</A></SPAN></TD>
    </TR>
    <TR>
        <TD COLSPAN="4" VALIGN="top">依頼状の発送確認を行います</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/follow/followReqInfo.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/follow/followReqInfo.asp">依頼状発送進捗確認</A></SPAN></TD>
    </TR>
    <TR>
        <TD COLSPAN="4" VALIGN="top">依頼状発送の進捗確認を行います。</TD>
    </TR>

</TABLE>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>