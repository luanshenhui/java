<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���f�O�����i��f�j�񎟌��f�E��f���E���@��  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim objCommon			'���ʃN���X
Dim objInterview		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim lngRsvNo			'�\��ԍ�


'�񎟌��f�E��f���E���@��
Dim vntCslDate			'��f��
Dim vntHistory			'���e

Dim lngCount			'�s��


Dim strColor			'�w�i�F

Dim Ret					'���A�l
Dim i, j				'�J�E���^�[

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")

'�����l�̎擾
lngRsvNo			= Request("rsvno")


Do

	'�񎟌��f�E��f���E���@���擾
	lngCount = 0

	Exit Do
Loop

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�񎟌��f�E��f���E���@��</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 15px; }
</style>
</HEAD>
<BODY>
<TABLE WIDTH="250" BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
For i = 0 To lngCount - 1
	If i mod 2 = 0 Then
		strColor = ""
	Else
		strColor = "#e0ffff"
	End If
%>
	<TR HEIGHT="17">
		<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="90" HEIGHT="17"><%= vntCslDate %></TD>
		<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="160" HEIGHT="17"><%= vntHistory(i) %></TD>
	</TR>
<%
Next
%>
</TABLE>
</BODY>
</HTML>