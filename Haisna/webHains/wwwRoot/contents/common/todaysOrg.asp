<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����̎�f�c�� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objOrganization	'�c�̏��A�N�Z�X�p

'�����̎�f�c�̖�
Dim strOrgCd1		'�c�̃R�[�h�P
Dim strOrgCd2		'�c�̃R�[�h�Q
Dim strOrgName		'�c�̖�
Dim strOrgCount		'�c�̐�
Dim lngOrgCount		'���R�[�h��

Dim i				'�C���f�b�N�X
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����̗\��</TITLE>
</HEAD>
<BODY>

<%
'�����̎�f�Ҏ擾�i�c�̕ʁj
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
lngOrgCount = objOrganization.SelectSelDateOrg(Date, strOrgCd1, strOrgCd2, strOrgName, strOrgCount)
Set objOrganization = Nothing

If lngOrgCount > 0 Then
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<%
		'�����̎�f�ҕ\���i�c�̕ʁj
		i = 0
		Do Until i >= lngOrgCount
%>
			<TR>
				<TD WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" BORDER="0"></TD>
				<TD NOWRAP><FONT COLOR="#9fcfcf">��</FONT><A HREF="/webHains/contents/common/dailyList.asp?strYear=<%= Year(Date) %>&strMonth=<%= Month(Date) %>&strDay=<%= Day(Date) %>&orgCd1=<%= strOrgCd1(i) %>&orgCd2=<%= strOrgCd2(i) %>" TARGET="_parent"><%= strOrgName(i) %></A></TD>
<%
				i = i + 1
				If i >= lngOrgCount Then
%>
					</TR>
<%
					Exit Do
				End If
%>
				<TD WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" BORDER="0"></TD>
				<TD NOWRAP><FONT COLOR="#9fcfcf">��</FONT><A HREF="/webHains/contents/common/dailyList.asp?strYear=<%= Year(Date) %>&strMonth=<%= Month(Date) %>&strDay=<%= Day(Date) %>&orgCd1=<%= strOrgCd1(i) %>&orgCd2=<%= strOrgCd2(i) %>" TARGET="_parent"><%= strOrgName(i) %></A></TD>
			</TR>
<%
			i = i + 1
		Loop
%>
	</TABLE>
<%
End If
%>
</BODY>
</HTML>