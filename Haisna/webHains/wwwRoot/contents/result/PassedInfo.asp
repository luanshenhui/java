<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ʓ���(�[���ʉߏ��) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<!-- #include virtual = "/webHains/includes/editGrpList.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const DISPMODE_DELETE  = "delete"	'�\�����[�h(�[���ʉߏ��폜)
Const ACTMODE_DELETE   = "delete"	'���샂�[�h(�[���ʉߏ��폜)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objWorkStation		'�[���ʉߏ��A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strDispMode			'�\�����[�h
Dim strActMode			'���샂�[�h
Dim strKeyDayId			'����ID
Dim dtmCslDate			'��f��
Dim strIPAddress		'IPAddress
Dim strMessage			'����������̃��b�Z�[�W
Dim lngRet				'�I�u�W�F�N�g�̖߂�l
Dim blnAutoClose		'�E�C���h�E�����N���[�Y����

Dim dtmPassedDate		'�ʉߓ���

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objWorkStation        = Server.CreateObject("HainsWorkStation.WorkStation")

'�O��ʂ��瑗�M�����p�����[�^�l�̎擾
strDispMode    = Request("mode")
strActMode     = Request("actmode")
dtmCslDate     = Request("cslDate")
strKeyDayId    = Request("dayId")
strIPAddress   = Request.ServerVariables("REMOTE_ADDR")
blnAutoClose   = False
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�[���ʉߏ��</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF" MARGINHEIGHT="0" ONLOAD="javascript:CloseMySelf();">

<FORM NAME="PassedInfoForm" action="#">
<INPUT TYPE="hidden" NAME="dayId"       VALUE="<%= strKeyDayId    %>">
<INPUT TYPE="hidden" NAME="receiptDate" VALUE="<%= dtmCslDate     %>">

<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="90%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�[���ʉߏ��</FONT></B></TD>
	</TR>
</TABLE>
<%
Do
	'�폜���s���[�h�̏ꍇ
	If strActMode = ACTMODE_DELETE Then
		If objWorkStation.DeletePassedInfo(dtmCslDate, 0, cLng(strKeyDayId), strIPAddress) = True Then
			strMessage = "�ʉߏ����폜���܂���"
			blnAutoClose = True
		Else
			strMessage = "�ʉߏ��̍폜�Ɏ��s���܂����B"
		End If
		Exit Do
	End If

	'�폜�\�����[�h�̏ꍇ
	If strDispMode = DISPMODE_DELETE Then
		strMessage = "�[���ʉߏ����폜���܂����H"
		Exit Do
	End If

	'��f�����ݒ肳��Ă��Ȃ��ꍇ
	If dtmCslDate = "" Then
		strMessage = "��f�����Z�b�g����Ă��܂���B"
		Exit Do
	End If

	'����ID���ݒ肳��Ă��Ȃ��ꍇ
	If strKeyDayId = "" Then
		strMessage = "����ID�����Ԃ���Ă��܂���B<BR>��t�������s���Ă��炱�̏������s���Ă��������B"
		Exit Do
	End If

	'�[���ʉߏ��̍X�V
	lngRet = INSERT_ERROR
	lngRet = objWorkStation.UpdatePassedInfo(dtmCslDate, 0, cLng(strKeyDayId), strIPAddress)

	Select Case lngRet
		Case INSERT_NORMAL
			strMessage = "�[���ʉߏ����X�V���܂����B"
			blnAutoClose = True
		Case INSERT_NOPARENT
			strMessage = "�w�肳�ꂽ��f�҂͎�t����Ă��܂���B"
		Case INSERT_ERROR
			strMessage = "�G���[���������܂���"
	End Select

	Exit Do

Loop

// �폜���[�h�ȊO�ł������N���[�Y���͒ʉߓ������擾����
If strActMode <> ACTMODE_DELETE And blnAutoClose = True Then
	objWorkStation.SelectPassedInfo dtmCslDate, 0, CInt(strKeyDayId), strIPAddress, , dtmPassedDate
End If
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ����ɍX�V���ꂽ�ꍇ�̂�3�b��ɃE�C���h�E����܂�
function CloseMySelf() {
<%
If blnAutoClose = True Then
%>
	if ( opener != null ) {
		opener.updatePassedInfo('<%= dtmPassedDate %>');
	}

	setInterval('window.close()', 3000);
<%
End If
%>
	return false;
}
//-->
</SCRIPT>
<BR>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
	<TR>
		<TD ROWSPAN="5" WIDTH="30"><IMG SRC="/webHains/images/spacer.gif" WIDTH="30"></TD>
		<TD NOWRAP><B><FONT COLOR=<%= IIf(blnAutoClose  = False, "RED", "000000" ) %>><%= strMessage %></FONT></B></TD>
	</TR>
	<TR>
		<TD HEIGHT="15"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD NOWRAP>
<%= IIf(blnAutoClose  = True, "�i���̃y�[�W�͂R�b��Ɏ����I�ɕ��܂��j", "" ) %>
<%
	If strDispMode  = DISPMODE_DELETE Then
%>
		<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") & "?actmode=" & ACTMODE_DELETE & "&csldate=" & dtmCslDate & "&dayId=" & strKeyDayId%>"><IMG SRC="/webHains/images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�ʉߏ����폜����"></A>
<%
	End If
%>

</TD>
	</TR>
	<TR>
		<TD HEIGHT="30"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
	</TR>
	<TR>
		<TD ALIGN="RIGHT">
<%
	If blnAutoClose  = False Then
%>
		<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
<% 
	End IF
%>
		</TD>
	</TR>
</TABLE>
</BODY>
