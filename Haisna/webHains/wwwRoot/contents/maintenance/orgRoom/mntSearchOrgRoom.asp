<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		������񃁃��e�i���X(�����̌���) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'## 2003.03.31 Mod 2Lines By T.Takagi@FSIT �����`�F�b�N����������
'Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)
'## 2003.03.31 Mod End

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_BSD  = "1"	'�������[�h(���ƕ�)
Const MODE_ROOM = "2"	'�������[�h(����)
Const MODE_POST = "3"	'�������[�h(����)
Const STARTPOS  = 1		'�J�n�ʒu�̃f�t�H���g�l
Const GETCOUNT  = 20	'�\�������̃f�t�H���g�l

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objOrgBsd			'���ƕ����A�N�Z�X�p
Dim objOrgRoom			'�������A�N�Z�X�p

'�����l
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgBsdCd			'���ƕ��R�[�h
Dim strKey				'�����L�[
Dim lngStartPos			'�����J�n�ʒu
Dim lngGetCount			'�\������

'�������
Dim strArrOrgBsdCd		'���ƕ��R�[�h
Dim strArrOrgRoomCd		'�����R�[�h
Dim strArrOrgRoomName	'��������
Dim strArrOrgRoomKName	'�����J�i����
Dim strArrOrgBsdName	'���ƕ�����
Dim strArrOrgBsdKName	'���ƕ��J�i����

Dim strDispOrgRoomCd	'�ҏW�p�̎����R�[�h
Dim strDispOrgRoomName	'�ҏW�p�̎�������
Dim strOrgName			'�c�̖���
Dim strOrgBsdName		'���ƕ�����
Dim strArrKey			'(�������)�����L�[�̏W��
Dim lngAllCount			'�����𖞂����S���R�[�h����
Dim lngCount			'���R�[�h����
Dim strURL				'URL������
Dim i, j				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")

'�����l�̎擾
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
strOrgBsdCd = Request("orgBsdCd")
strKey      = Request("key")
lngStartPos = Request("startPos")
lngGetCount = Request("getCount")

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))

'�c�̂�������̏ꍇ�͒c�̌����K�C�h�֑J��
If strOrgCd1 = "" Or strOrgCd2 = "" Then
	strURL = "gdeOrganization.asp"
	strURL = strURL & "?orgDiv=" & "0"
	strURL = strURL & "&mode="   & MODE_ROOM
	Response.Redirect strURL
	Response.End
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����̌���</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.key.focus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�����̌���</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�c�̖��̂̓ǂݍ���
	If objOrganization.SelectOrg(strOrgCd1, strOrgCd2, , strOrgName) = False Then
		Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
	End If
%>
	<BR>&nbsp;�c�́F&nbsp;<FONT COLOR="#ff6600"><B><%= strOrgName %></B></FONT>
<%
	'���ƕ��R�[�h���w�肳��Ă���ꍇ
	If strOrgBsdCd <> "" Then
	
		'���ƕ����̂̓ǂݍ���
		If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName) = False Then
			Err.Raise 1000, , "���ƕ���񂪑��݂��܂���B"
		End If
%>
		&nbsp;���ƕ��F&nbsp;<FONT COLOR="#ff6600"><B><%= strOrgBsdName %></B></FONT>
<%
	End If
%>
	<INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1   %>">
	<INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2   %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd" VALUE="<%= strOrgBsdCd %>">

	<BR><BR>&nbsp;�����R�[�h�������͎������̂���͂��ĉ������B

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH="650">
		<TR>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></TD>
<%
			strURL = "/webHains/contents/maintenance/organization/mntOrganization.asp"
			strURL = strURL & "?mode="   & "update"
			strURL = strURL & "&orgCd1=" & strOrgCd1
			strURL = strURL & "&orgCd2=" & strOrgCd2
%>
			<TD WIDTH="100%" ALIGN="right"><A HREF="<%= strURL %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�c�̏�񃁃��e�i���X��ʂɖ߂�"></A></TD>
<%
			'�����I������URL��ҏW
			strURL = "mntOrgRoom.asp"
			strURL = strURL & "?mode="     & "insert"
			strURL = strURL & "&orgCd1="   & strOrgCd1
			strURL = strURL & "&orgCd2="   & strOrgCd2
			strURL = strURL & "&orgBsdCd=" & strOrgBsdCd
%>
			<TD><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/newrsv.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�V����������o�^���܂�"></A></TD>
		</TR>
	</TABLE>

	<BR>
<%
	Do
		'�����L�[���󔒂ŕ�������
		strArrKey = SplitByBlank(strKey)

		'���������𖞂������R�[�h�������擾
		lngAllCount = objOrgRoom.SelectOrgRoomListCount(strOrgCd1, strOrgCd2, strOrgBsdCd, strArrKey)

		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngAllCount = 0 Then
%>
			���������𖞂����������͑��݂��܂���B<BR>
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
		�������ʂ� <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>������܂����B<BR><BR>
<%
		'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
		lngCount = objOrgRoom.SelectOrgRoomList(strOrgCd1,         strOrgCd2,          _
												strOrgBsdCd,       strArrKey,          _
												lngStartPos,       lngGetCount,        _
												strArrOrgBsdCd,    strArrOrgRoomCd,    _
												strArrOrgRoomName, strArrOrgRoomKName, _
												strArrOrgBsdName,  strArrOrgBsdKName)

		'�����ꗗ�̕ҏW�J�n
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>�R�[�h</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>��������</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>���ƕ�</TD>
			</TR>
			<TR>
				<TD></TD>
				<TD BGCOLOR="#999999" COLSPAN="6"></TD>
			</TR>
			<TR>
				<TD HEIGHT="2"></TD>
			</TR>
<%
			For i = 0 To lngCount - 1

				'�������̎擾
				strDispOrgRoomCd   = strArrOrgRoomCd(i)
				strDispOrgRoomName = strArrOrgRoomName(i)

				'�����L�[�ɍ��v���镔����<B>�^�O��t��
				If Not IsEmpty(strArrKey) Then
					For j = 0 To UBound(strArrKey)
						strDispOrgRoomCd   = Replace(strDispOrgRoomCd,   strArrKey(j), "<B>" & strArrKey(j) & "</B>")
						strDispOrgRoomName = Replace(strDispOrgRoomName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					Next
				End If

				'�����I������URL��ҏW
				strURL = "mntOrgRoom.asp"
				strURL = strURL & "?mode="      & "update"
				strURL = strURL & "&orgCd1="    & strOrgCd1
				strURL = strURL & "&orgCd2="    & strOrgCd2
				strURL = strURL & "&orgBsdCd="  & strArrOrgBsdCd(i)
				strURL = strURL & "&orgRoomCd=" & strArrOrgRoomCd(i)

				'�������̕ҏW
%>
				<TR>
					<TD></TD>
					<TD NOWRAP><%= strDispOrgRoomCd %></TD>
					<TD></TD>
					<TD NOWRAP><A HREF="<%= strURL %>"><%= strDispOrgRoomName %></A></TD>
					<TD></TD>
					<TD NOWRAP><FONT COLOR="#aaaaaa"><%= strArrOrgBsdName(i) %></FONT></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		'�y�[�W���O�i�r�Q�[�^�̕ҏW
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?orgCd1="   & strOrgCd1
		strURL = strURL & "&orgCd2="   & strOrgCd2
		strURL = strURL & "&orgBsdCd=" & strOrgBsdCd
		strURL = strURL & "&key="      & Server.URLEncode(strKey)
%>
		<%= EditPageNavi(strURL, lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
