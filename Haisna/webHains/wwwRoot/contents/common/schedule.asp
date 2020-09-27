<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		��f�\��\(����) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objSchedule		'�X�P�W���[�����擾�p

Dim dtmCslDate		'��f��
Dim lngMode			'�\�����[�h

Dim strCsCd			'�R�[�X�R�[�h
Dim strCsName		'�R�[�X��
Dim strWebColor		'web�J���[
Dim strOrgCd1		'�c�̃R�[�h�P
Dim strOrgCd2		'�c�̃R�[�h�Q
Dim strOrgName		'�c�̖�
Dim strCslCount		'��f�Ґ�
Dim lngCount		'���R�[�h��

Dim strPrevCsCd		'���O���R�[�h�̃R�[�X�R�[�h
Dim strPrevOrgCd1	'���O���R�[�h�̒c�̃R�[�h1
Dim strPrevOrgCd2	'���O���R�[�h�̒c�̃R�[�h2
Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'�����l�̎擾
dtmCslDate = CDate(Request("cslDate"))
lngMode    = CLng("0" & Request("mode"))

lngMode = IIf(lngMode = 0, 2, lngMode)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��f�\��</TITLE>
<STYLE TYPE="text/css">
td.rsvtab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BLOCKQUOTE>

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��f�\��</FONT></B></TD>
	</TR>
</TABLE>

<BR>

��f���F<B><%= dtmCslDate %></B><BR>
<BR>
<%
If lngMode = 2 Then
%>
	<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?cslDate=<%= dtmCslDate%>&mode=3">�c�̕ʂɕ\��</A><BR>
<%
Else
%>
	<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?cslDate=<%= dtmCslDate%>&mode=2">�R�[�X�ʂɕ\��</A><BR>
<%
End If
%>
<BR>
<%
Do
	'��f�\���ǂݍ���
	lngCount = objSchedule.SelectConsultSchedule(lngMode, dtmCslDate, strCsCd, strCsName, strWebColor, strOrgCd1, strOrgCd2, strOrgName, strCslCount)
	If lngCount = 0 Then
		Exit Do
	End If

	If lngMode = 2 Then
%>
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR BGCOLOR="#cccccc">
				<TD WIDTH="150">�R�[�X��</TD>
				<TD WIDTH="250">��f�c��</TD>
				<TD>��f�l��</TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
<%
					If strCsCd(i) <> strPrevCsCd Then
%>
						<TD><FONT COLOR="<%= strWebColor(i) %>">��</FONT><%= strCsName(i) %></TD>
<%
					Else
%>
						<TD></TD>
<%
					End If
%>
					<TD><%= strOrgName(i) %></TD>
					<TD ALIGN="right"><%= strCslCount(i) %></TD>
				</TR>
<%
				strPrevCsCd = strCsCd(i)

			Next
%>
		</TABLE>
<%
		Exit Do
	End If

	If lngMode = 3 Then
%>
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR BGCOLOR="#cccccc">
				<TD WIDTH="250">��f�c��</TD>
				<TD WIDTH="150">�R�[�X��</TD>
				<TD>��f�l��</TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
<%
					If strOrgCd1(i) <> strPrevOrgCd1 Or strOrgCd2(i) <> strPrevOrgCd2 Then
%>
						<TD><%= strOrgName(i) %></TD>
<%
					Else
%>
						<TD></TD>
<%
					End If
%>
					<TD><FONT COLOR="<%= strWebColor(i) %>">��</FONT><%= strCsName(i) %></TD>
					<TD ALIGN="right"><%= strCslCount(i) %></TD>
				</TR>
<%
				strPrevOrgCd1 = strOrgCd1(i)
				strPrevOrgCd2 = strOrgCd2(i)

			Next
%>
		</TABLE>
<%
		Exit Do
	End If

	Exit Do
Loop
%>
</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
