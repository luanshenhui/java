<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �ύX�����ڍ� (Ver0.0.1)
'	   AUTHER  : Tsutomy Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult	'��f���A�N�Z�X�p

'�p�����[�^�l
Dim lngRsvNo	'�\��ԍ�
Dim lngSeq		'SEQ

Dim strUpdDate	'�X�V��
Dim strUpdUser	'���[�U�h�c
Dim strUserName	'���[�U��
Dim strCslInfo	'�\��X�V���

Dim Ret			'�֐��߂�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
lngRsvNo = CLng("0" & Request("rsvNo"))
lngSeq   = CLng("0" & Request("seq"))

'��f��񃍃O�̓ǂݍ���
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Ret = objConsult.SelectConsultLog(lngRsvNo, lngSeq, strUpdDate, strUpdUser, strUserName, strCslInfo)
Set objConsult = Nothing

If Ret = False Then
	Err.Raise 1000, , "���O��񂪑��݂��܂���B"
End If

If InStr(strCslInfo, "<CONSULT>") > 0 Then

'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
Response.ContentType = "text/xml"
Response.Write "<?xml version=""1.0"" encoding=""Shift_JIS"" ?>"
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####
%>
<%
'#### 2013.3.1 SL-SN-Y0101-612 DEL START ####
'<?xml version="1.0" encoding="Shift_JIS" ?>
'#### 2013.3.1 SL-SN-Y0101-612 DEL END   ####
%>
<?xml-stylesheet type="text/xsl" href="rsvConsultLog.xsl" ?>
<%= strCslInfo %>
<%
'XML�łȂ��b��ŗp
Else
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�����Z�b�g���̔�r</TITLE>
</HEAD>
<BODY BGCOLOR="#ffffff">

<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�\��X�V���</FONT></B></TD>
	</TR>
</TABLE>
<BR>
���b�Z�[�W�F<%= strCslInfo %>
</BODY>
</HTML>
<%
End If
%>
