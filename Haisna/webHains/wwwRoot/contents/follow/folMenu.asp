<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'	   �t�H���[�A�b�v��ނ̑I�� (Ver0.0.1)
'	   AUTHER  : 
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)
'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>�t�H���[�A�b�v��ނ̑I��</TITLE>
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
        <TD COLSPAN="2"><FONT SIZE="+2"><B>�t�H���[�A�b�v</B></FONT></TD>
    </TR>
    <TR HEIGHT="2">
        <TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2"></TD>
    </TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="500">
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/follow/followInfoList.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/follow/followInfoList.asp">�t�H���[�A�b�v����</A></SPAN></TD>
    </TR>
    <TR>
        <TD COLSPAN="4" VALIGN="top">�t�H���[�A�b�v�ΏێҌ�����ʂ�\�����܂��B</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/follow/followExhortList.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/follow/followExhortList.asp">�����ΏێҌ���</A></SPAN></TD>
    </TR>
    <TR>
        <TD COLSPAN="4" VALIGN="top">�����ΏێҌ�����ʂ�\�����܂��B</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/follow/followReqSend.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/follow/followReqSend.asp">�˗��󔭑��m�F</A></SPAN></TD>
    </TR>
    <TR>
        <TD COLSPAN="4" VALIGN="top">�˗���̔����m�F���s���܂�</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="/webHains/contents/follow/followReqInfo.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/follow/followReqInfo.asp">�˗��󔭑��i���m�F</A></SPAN></TD>
    </TR>
    <TR>
        <TD COLSPAN="4" VALIGN="top">�˗��󔭑��̐i���m�F���s���܂��B</TD>
    </TR>

</TABLE>

</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>