<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		��f���̌��� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objConsult		'��f���A�N�Z�X�p
Dim objFree			'�ėp���A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

'�����l
Dim strPerId		'�l�h�c

'�l���
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strGender		'����
Dim strAge			'��f���N��

'��f���
Dim strRsvNo		'�\��ԍ�
Dim strCslDate		'��f��
Dim strCsName		'�R�[�X��
Dim strOrgSName		'�c�̗���
Dim strCslDivName	'��f�敪����
Dim lngCount		'��f��

Dim strURL			'URL������
Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objFree    = Server.CreateObject("HainsFree.Free")
Set objPerson  = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strPerId        = Request("perId")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��f���̌���</TITLE>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">��f���̌���</FONT></B></TD>
	</TR>
</TABLE>
<%
'�l���ǂݍ���
If objPerson.SelectPerson_Lukes(strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strBirth, strGender) = False Then
	Err.Raise 1000, , "�l��񂪑��݂��܂���B"
End If

'�N��v�Z
strAge = objFree.CalcAge(strBirth)
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD HEIGHT="3"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2" VALIGN="top" NOWRAP><%= strPerId %></TD>
		<TD NOWRAP><B><%= Trim(strLastName  & "�@" & strFirstName) %></B>�i<%= Trim(strLastKName & "�@" & strFirstKName) %>�j</TD>
	</TR>
	<TR>
		<TD NOWRAP><%= objCommon.FormatString(CDate(strBirth), "ge.m.d") %>���@<%= strAge %>�΁@<%= IIf(strGender = CStr(GENDER_MALE), "�j��", "����") %></TD>
	</TR>
</TABLE>
<BR>
<%
Do
	'��f���̌���
	lngCount = objConsult.SelectConsultHistory(strPerId, , , , , strRsvNo, strCslDate, , strCsName, , , , strOrgSName, strCslDivName)
	If lngCount <= 0 Then
%>
		��f���͂���܂���B<BR><BR>
<%
		Exit Do
	End If
%>
	�������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>������܂����B<BR><BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>��f��</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>�c��</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>�R�[�X</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>��f�敪</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD BGCOLOR="#999999" COLSPAN="7"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
		</TR>
<%
		'URL�̌��^��ҏW
		strURL = "gdeSelectPerson.asp"
		strURL = strURL & "?perId=" & strPerId
		strURL = strURL & "&rsvNo="

		'��f���̕ҏW
		For i = 0 To lngCount - 1
%>
			<TR>
				<TD HEIGHT="25"></TD>
				<TD NOWRAP><%= strCslDate(i) %></TD>
				<TD></TD>
				<TD NOWRAP><A HREF="<%= strURL & strRsvNo(i) %>"><%= strOrgSName(i) %></A></TD>
				<TD></TD>
				<TD NOWRAP><%= strCsName(i) %></TD>
				<TD></TD>
				<TD NOWRAP><%= strCslDivName(i) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	Exit Do
Loop
%>
<BR><A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
</BODY>
</HTML>
