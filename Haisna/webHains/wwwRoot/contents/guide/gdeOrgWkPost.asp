<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�J������K�C�h (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const STARTPOS  = 1			'�J�n�ʒu�̃f�t�H���g�l
Const GETCOUNT  = 20		'�\�������̃f�t�H���g�l

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objOrganization			'�c�̏��A�N�Z�X�p
Dim objOrgPost				'�������A�N�Z�X�p

'�����l
Dim strOrgCd1				'�c�̃R�[�h�P
Dim strOrgCd2				'�c�̃R�[�h�Q
Dim strKey					'�����L�[
Dim lngStartPos				'�����J�n�ʒu
Dim lngGetCount				'�\������

'�J��������
Dim strOrgWkPostCd			'�J������R�[�h
Dim strOrgWkPostName		'�J���������
Dim strOrgWkPostSeq			'�J������r�d�p

Dim strDispOrgWkPostCd		'�ҏW�p�̘J������R�[�h
Dim strDispOrgWkPostName	'�ҏW�p�̘J���������
Dim strOrgName				'�c�̖���
Dim strArrKey				'(�������)�����L�[�̏W��
Dim lngCount				'���R�[�h����
Dim strURL					'URL������
Dim strBuffer				'������o�b�t�@
Dim i, j					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strKey       = Request("key")
lngStartPos  = Request("startPos")
lngGetCount  = Request("getCount")

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�J������̌���</TITLE>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.key.focus()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�J������̌���</FONT></B></TD>
	</TR>
</TABLE>
<%
'�c�̖��̂̓ǂݍ���
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
objOrganization.SelectOrg strOrgCd1, strOrgCd2, , strOrgName
%>
<BR>&nbsp;�c�́F&nbsp;<FONT COLOR="#ff6600"><B><%= strOrgName %></B></FONT>

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">

	&nbsp;�J������R�[�h�������͘J��������̂���͂��ĉ������B

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></TD>
		</TR>
	</TABLE>

</FORM>
<%
Do

	'�����L�[���󔒂ŕ�������
	strArrKey = SplitByBlank(strKey)

	'���������𖞂������R�[�h�������擾
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	lngCount = objOrgPost.SelectOrgWkPostList(strOrgCd1, strOrgCd2, strArrKey, lngStartPos, lngGetCount, strOrgWkPostCd, strOrgWkPostName, strOrgWkPostSeq)

	'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
	If lngCount = 0 Then

		If strKey = "" Then
			Exit Do
		End If
%>
		���������𖞂����J��������͑��݂��܂���B<BR>
		�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
		Exit Do
	End If

	'���R�[�h��������ҏW
	If strKey <> "" Then
%>
		�u<FONT COLOR="#ff6600"><B><%= strKey %></B></FONT>�v��
<%
	End If
%>
	�������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>������܂����B<BR><BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>�R�[�h</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>�J���������</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD BGCOLOR="#999999" COLSPAN="3"></TD>
		</TR>
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
<%
		For i = 0 To UBound(strOrgWkPostCd)

			'�J��������̎擾
			strDispOrgWkPostCd   = strOrgWkPostCd(i)
			strDispOrgWkPostName = strOrgWkPostName(i)

			'�����L�[�ɍ��v���镔����<B>�^�O��t��
			If Not IsEmpty(strArrKey) Then
				For j = 0 To UBound(strArrKey)
					strDispOrgWkPostCd   = Replace(strDispOrgWkPostCd,   strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispOrgWkPostName = Replace(strDispOrgWkPostName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next
			End If

			'�J������I������URL��ҏW
			strURL = "gdeSelectOrgWkPost.asp"
			strURL = strURL & "?orgWkPostSeq=" & strOrgWkPostSeq(i)

			'�J��������̕ҏW
%>
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><%= strDispOrgWkPostCd %></TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><A HREF="<%= strURL %>"><%= strDispOrgWkPostName %></A></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'�y�[�W���O�i�r�Q�[�^�̕ҏW
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?orgCd1=" & strOrgCd1
	strURL = strURL & "&orgCd2=" & strOrgCd2
	strURL = strURL & "&key="    & Server.URLEncode(strKey)
%>
	<%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
	Exit Do
Loop
%>
</BODY>
</HTML>
