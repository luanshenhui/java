<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ʎQ�Ɓ@�Ώێ� (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim objPerson		'�l���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objCommon		'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g

Dim strPerID		'�l�h�c

'�l���
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��	
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strGender		'����
Dim strGenderName	'���ʖ���

'��f��
Dim strRsvNo		'�\��ԍ�
Dim strCslDate		'��f��
Dim strCsName		'�R�[�X��
Dim strAge			'�N��
Dim strCsSName		'�R�[�X����
Dim strWebColor		'web�J���[

Dim lngCount		'���R�[�h����
Dim i				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strPerID = Request("PerID")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerson  = Server.CreateObject("HainsPerson.Person")

'�l���ǂݍ���
objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, strGenderName

'���N�����a��\��
strBirth = objCommon.FormatString(strBirth, "g ee.mm.dd")

'��f��ǂݍ���
lngCount = objConsult.SelectConsultHistory(strPerId, , , , ,strRsvNo, strCslDate, , strCsName, strAge, strCsSName, strWebColor)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�Ώێ�</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">


�u<FONT COLOR="#FF6600"><B><%= strLastKName %>�@<%= strFirstKName %></B></FONT>�v<BR>
�̎�f���� <FONT COLOR="#FF6600"><B><%= lngCount %></B></FONT>������܂����B<BR><BR>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#000000">�Ώێ�</FONT></B></TD>
	</TR>
</TABLE>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR><TD COLSPAN="2" HEIGHT="5"></TD></TR>
	<TR>
		<TD><%= strPerID %></TD>
		<TD><B><%= strLastName %>�@<%= strFirstName %></B><FONT SIZE="-1">�i<%= strLastKName %>�@<%= strFirstKName %>�j</FONT></TD>
	</TR>
	<TR>
		<TD></TD>
		<TD><%= strBirth %>���@<%= strGenderName %></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="122">
	<TR>
		<TD><A HREF="inqWiz.asp" TARGET="_top"><IMG SRC="/webHains/images/changeper.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�\�������f�҂�ύX���܂�"></A></TD>
		<TD><A HREF="/webHains/contents/inquiry/inqRslHistory.asp?mode=1&perId=<%= strPerId %>" TARGET="detail"><IMG SRC="/webHains/images/inqhistory.gif"></A></TD>
		<TD><A HREF="/webHains/contents/inquiry/inqGraph.asp?perId=<%= strPerId %>" TARGET="detail"><IMG SRC="/webHains/images/graph.gif"></A></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR ALIGN="center" BGCOLOR="#cccccc">
		<TD>��f��</TD>
		<TD>�R�[�X</TD>
		<TD>�N��</TD>
	</TR>
<%
	For i = 0 To lngCount - 1
%>
		<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>" ALIGN="center">
		<TD><A HREF="/webHains/contents/inquiry/inqReport.asp?rsvNo=<%= strRsvNo(i) %>" TARGET="detail"><%= strCslDate(i) %></A></TD>
		<TD WIDTH="120" ALIGN="left"><FONT COLOR="<%= strWebColor(i) %>">��</FONT><%= strCsSName(i) %></TD>
		<TD><%= strAge(i) %>��</TD>
	</TR>
<%
Next
%>
</TABLE>
</BODY>
</HTML>
