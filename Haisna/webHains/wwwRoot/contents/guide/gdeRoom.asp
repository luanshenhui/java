<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���������K�C�h (Ver0.0.1)
'		AUTHER  : Eiichi Yamamoto K-MIX
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const STARTPOS = 1	'�J�n�ʒu�̃f�t�H���g�l
Const GETCOUNT = 20	'�\�������̃f�t�H���g�l

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objOrgRoom		'�������A�N�Z�X�p

'�������
Dim strOrgCd1		'�c�̃R�[�h1
Dim strOrgCd2		'�c�̃R�[�h2
Dim strOrgBsdCd		'���ƕ��R�[�h
Dim strOrgRoomCd	'�����R�[�h
Dim strOrgRoomName	'��������
Dim strOrgRoomKName	'�����J�i����
Dim strOrgKanaName	'�c�̃J�i����
Dim strOrgName		'�c�̖���
Dim strOrgSName		'����
Dim strOrgBsdKName	'���ƕ��J�i����
Dim strOrgBsdName	'���ƕ�����

Dim lngAllCount		'��������
Dim BlnCheckBsd		'URL������
Dim strURL			'URL������
Dim i, j			'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrgRoom 		= Server.CreateObject("HainsOrgRoom.OrgRoom")

'�����l�̎擾
strOrgRoomCd = Request("orgRoomCd")
strOrgBsdCd  = Request("orgBsdCd")
strOrgCd1	 = Request("orgCd1")
strOrgCd2    = Request("orgCd2")

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�����̌���</TITLE>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.orgRoomCd.focus()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�����̌���</FONT></B></TD>
	</TR>
</TABLE>

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD COLSPAN="3">�����R�[�h����͂��ĉ������B</TD>
		</TR>
		<TR>
		<TD WIDTH="1"><INPUT TYPE="text" NAME="orgRoomCd" SIZE="30" VALUE="<%= strOrgRoomCd %>"></TD>
		<TD WIDTH="1"><INPUT TYPE="hidden" NAME="orgCd1" SIZE="30" VALUE="<%= strOrgCd1 %>"></TD>
		<TD WIDTH="1"><INPUT TYPE="hidden" NAME="orgCd2" SIZE="30" VALUE="<%= strOrgCd2 %>"></TD>
		<TD WIDTH="1"><INPUT TYPE="hidden" NAME="orgBsdCd" SIZE="30" VALUE="<%= strOrgBsdCd %>"></TD>
		<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
		<TD WIDTH="77"><INPUT TYPE="image" NAME="search" SRC="/webHains/images/findrsv.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></TD>
		</TR>
	</TABLE>
</FORM>
<%
	Do
		'�������������݂��Ȃ��ꍇ�͉������Ȃ�
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'������񂩂猟�������𖞂����Ă���f�[�^���擾
		BlnCheckBsd = objOrgRoom.SelectOrgRoom( strOrgCd1, _
												strOrgCd2, _
												strOrgBsdCd, _
												strOrgRoomCd, _
												strOrgRoomName, _
												strOrgRoomKName, _
												strOrgKanaName, _
												strOrgName, _
												strOrgSName, _
												strOrgBsdKName, _
												strOrgBsdName _
											  )
		If( BlnCheckBsd ) Then
			lngAllCount = 1
		Else
			lngAllCount = 0
		End If
%>
		�u<FONT COLOR="#ff6600"><B><%= strOrgRoomCd %></B></FONT>�v�̌������ʂ� <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>������܂����B<BR><BR>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
<%
		If ( BlnCheckBsd = True ) Then
		'�����ꗗ�̕ҏW�J�n

			'�����I������URL��ҏW
			strURL = "/webHains/contents/guide/gdeSelectOrgRoom.asp?orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2 & "&orgBsdCd=" & strOrgBsdCd & "&orgRoomCd=" & strOrgRoomCd

			'�������̕ҏW
%>
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP><%= strOrgRoomCd %>�@<A HREF="<%= strURL %>"><%= strOrgRoomName %></A></TD>
			</TR>
		</TABLE>

<%
		End If
		Exit Do
	Loop
%>
</BODY>
</HTML>
