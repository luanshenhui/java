<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���V�X�e���A�g���O�ꗗ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const LOGFILEPATH = "/webHains/log/cooperation"	'���O�t�@�C���̃p�X

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon	'���ʃN���X

Dim lngOpYear	'�����N
Dim lngOpMonth	'������
Dim lngOpDay	'������

Dim strFileName	'���O�t�@�C����
Dim lngCount	'���O�t�@�C����

Dim strOpDate	'�����N����
Dim strMessage	'�G���[���b�Z�[�W
Dim i			'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
lngOpYear  = CLng("0" & Request("opYear") )
lngOpMonth = CLng("0" & Request("opMonth"))
lngOpDay   = CLng("0" & Request("opDay")  )

'�������̃f�t�H���g�l�Ƃ��ăV�X�e�����t��ݒ�
lngOpYear  = IIf(lngOpYear  = 0, Year(Now()),  lngOpYear )
lngOpMonth = IIf(lngOpMonth = 0, Month(Now()), lngOpMonth)
lngOpDay   = IIf(lngOpDay   = 0, Day(Now()),   lngOpDay  )

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'�\���{�^���������ȊO�͉������Ȃ�
	If IsEmpty(Request("display.x")) Then
		Exit Do
	End If

	'�������̕ҏW
	strOpDate = lngOpYear & "/" & lngOpMonth & "/" & lngOpDay

	'�������̓��t�`�F�b�N
	If Not IsDate(strOpDate) Then
		strMessage = "�������̓��͌`��������������܂���B"
		Exit Do
	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���V�X�e���A�g���O�ꗗ</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">���V�X�e���A�g���O�ꗗ</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD>��������</TD>
			<TD><%= EditNumberList("opYear", YEARRANGE_MIN, YEARRANGE_MAX, lngOpYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("opMonth", 1, 12, lngOpMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("opDay", 1, 31, lngOpDay, False) %></TD>
			<TD>���ȍ~�̑��V�X�e���A�g���O��</TD>
			<TD><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></TD>
		</TR>
	</TABLE>
<%
	Do
		'�\���{�^���������ȊO�͉������Ȃ�
		If IsEmpty(Request("display.x")) Then
			Exit Do
		End If

		'�G���[���͉������Ȃ�
		If strMessage <> "" Then
			Exit Do
		End If

		'���O�t�@�C�����̎擾
		lngCount = objCommon.GetFileList(Server.MapPath(LOGFILEPATH), strOpDate, strFileName)
%>
		<BR>�u<FONT COLOR="#ff6600"><B><%= strOpDate %>�ȍ~�̑��V�X�e���A�g���O</B></FONT>�v�̌������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>������܂����B<BR><BR>
<%
		'�t�@�C���������݂��Ȃ��ꍇ�͏������I������
		If lngCount <= 0 Then
			Exit Do
		End If

		'���O�t�@�C�����̎擾
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
			For i = 0 To lngCount - 1
%>
				<TR>
					<TD><A HREF="<%= LOGFILEPATH %>/<%= strFileName(i) %>"><%= strFileName(i) %></A></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
