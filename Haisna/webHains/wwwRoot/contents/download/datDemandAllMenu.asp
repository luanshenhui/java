<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �������֘A�_�E�����[�h�̑I�� (Ver0.0.1)
'       AUTHER  : Hiroki Ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������֘A�_�E�����[�h�̑I��</TITLE>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">��</SPAN><FONT COLOR="#000000">�������CSV�̑I��</FONT></B></TD>
    </TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
    <TR>
        <TD ROWSPAN="2"><A HREF="datCslMoneyList.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datCslMoneyList.asp">�l���וʐ�����񒊏o</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">��f���Ԃ������͒��ߓ��Ȃǂ���A�ΏۂƂȂ�l�����ږ��̋��z���ׂ𒊏o���܂��B</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="datBillConsult.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datBillConsult.asp">��������f��񒊏o</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">���������쐬����Ă��Ȃ���f�҂̏����擾���܂��B�����ς݃f�[�^�����o�\�ł��B</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="datBillDetail.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datBillDetail.asp">���������׏�񒊏o</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�쐬�ςݐ��������̏ڍ׏��𒊏o���܂��B</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="datBill.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datBill.asp">��������񒊏o�i�b�n�l�o�`�m�x�A�g�p�j</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�o���V�X�e���i�b�n�l�o�`�m�x�j�A�g�p���������𒊏o���܂��B</TD>
    </TR>
    <TR>
        <TD HEIGHT="15"></TD>
    </TR>
    <TR>
        <TD ROWSPAN="2"><A HREF="datOrgBill.asp"><IMG SRC="/webHains/images/money.jpg" WIDTH="80" HEIGHT="60"></A></TD>
        <TD ROWSPAN="2" WIDTH="20"></TD>
        <TD><SPAN STYLE="font-size:16px"><B><A HREF="datOrgBill.asp">�������׏�񒊏o�i�O�䕨�Y���ۃt�H�[�}�b�g�j</A></B><SPAN></TD>
    </TR>
    <TR>
        <TD VALIGN="top">�O�䕨�Y���ۃt�H�[�}�b�g�̐������׏��𒊏o���܂��B</TD>
    </TR>
</TABLE>

</BLOCKQUOTE>
</BODY>
</HTML>