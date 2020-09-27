<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\��g����(�\�񊮗�) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

'�����l
Dim dtmCslDate		'��f��
Dim lngStrRsvNo		'�J�n�\��ԍ�
Dim lngEndRsvNo		'�I���\��ԍ�
Dim strMode			'�������[�h
Dim strPerId		'�l�h�c
Dim strCompPerId	'�����Ҍl�h�c

'��f���
Dim strRsvNo		'�\��ԍ�
Dim strWebColor		'web�J���[
Dim strCsName		'�R�[�X��
Dim strArrPerId		'�l�h�c
Dim strLastName		'��
Dim strFirstName	'��
Dim strOrgSName		'�c�̗���
Dim strOptName		'�I�v�V������
Dim strRsvGrpName	'�\��Q����
Dim strArrCompPerId	'�����Ҍl�h�c
Dim strHasFriends	'���A��l���̗L��
Dim lngCount		'���R�[�h��

Dim strSameGrp1		'�ʐړ�����f�P
Dim strSameGrp2		'�ʐړ�����f�Q
Dim strSameGrp3		'�ʐړ�����f�R
Dim strName			'����
Dim strMessage		'���b�Z�[�W
Dim strURL			'URL������
Dim blnComp			'�����҃t���O
Dim blnHasFriends	'���A��l�t���O
Dim Ret				'�֐��߂�l
Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
dtmCslDate   = CDate(Request("cslDate"))
lngStrRsvNo  = CLng(Request("strRsvNo"))
lngEndRsvNo  = CLng(Request("endRsvNo"))
strMode      = Request("mode")
strPerId     = Request("perId")
strCompPerId = Request("compPerId")

Select Case strMode

	Case "delete"	'�폜��

		Set objConsult = Server.CreateObject("HainsConsult.Consult")

		'��f�����폜
'## 2004.01.03 Mod By T.Takagi@FSIT ���O�Ή�
'		objConsult.TruncateConsult lngStrRsvNo, lngEndRsvNo
		objConsult.TruncateConsult lngStrRsvNo, lngEndRsvNo, Session("USERID")
'## 2004.01.03 Mod End

		Set objConsult = Nothing

		'���펞�͊����ʒm��ʂ�
		Response.Redirect "fraRsvDeleted.asp"
		Response.End

	Case "comp"	'�����ғo�^��

		Set objPerson = Server.CreateObject("HainsPerson.Person")

		'�����Ҍl�h�c�X�V
		Ret = objPerson.UpdateCompPerId(strPerId, strCompPerId)

		Set objPerson = Nothing

		'�߂�l���Ƃ̏�������
		Select Case Ret

			Case 0	'�l��񂪑��݂��Ȃ�(���ꔭ�������ꍇ�A��f��񂷂瑶�݂��Ȃ����ƂɂȂ�)

				strMessage = "�����ҏ��̍X�V�ŃG���[���������܂����B"

			Case -1	'���łɕʂ̓����҂��o�^����Ă����ꍇ

				strMessage = "���łɑ��̓����Ҍl�h�c�ɂčX�V����Ă��܂��B"

			Case Else	'���펞

'### 2004.02.17 Added by Ishihara@FSIT �����ғo�^���͖ⓚ���p�ł��A��l�o�^

				Do
					Set objConsult = Server.CreateObject("HainsConsult.Consult")
		
					'�w��\��ԍ��͈͂̎�f�҈ꗗ(�\��ԍ�)���擾
					lngCount = objConsult.SelectConsultListForFraRsv(lngStrRsvNo, lngEndRsvNo, strRsvNo)
					If lngCount <= 0 Then
						strMessage = "��f��񂪑��݂��܂���B"
						Exit Do
					End If
		
					strSameGrp1 = Array()
					strSameGrp2 = Array()
					strSameGrp3 = Array()
					ReDim Preserve strSameGrp1(lngCount - 1)
					ReDim Preserve strSameGrp2(lngCount - 1)
					ReDim Preserve strSameGrp3(lngCount - 1)
					For i = 0 To UBound(strSameGrp1)
						strSameGrp1(i) = "1"
						strSameGrp2(i) = ""
						strSameGrp3(i) = ""
					Next
		
					'���A��l�o�^
					objConsult.UpdateFriends dtmCslDate, 0, strRsvNo, strSameGrp1, strSameGrp2, strSameGrp3, strMessage
					If Not IsEmpty(strMessage) Then
						strMessage = "���łɂ��A��l���o�^����Ă��܂��B"
						Exit Do
					End If
		
					Set objConsult = Nothing
					Exit Do
				Loop
'### 2004.02.17 Added End

				'���g�����_�C���N�g
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?cslDate="  & dtmCslDate
				strURL = strURL & "&strRsvNo=" & lngStrRsvNo
				strURL = strURL & "&endRsvNo=" & lngEndRsvNo
				strURL = strURL & "&mode="     & "compEnd"
				Response.Redirect strURL
				Response.End

		End Select

	Case "friends"	'���A��l�o�^��

		Do

			Set objConsult = Server.CreateObject("HainsConsult.Consult")

			'�w��\��ԍ��͈͂̎�f�҈ꗗ(�\��ԍ�)���擾
			lngCount = objConsult.SelectConsultListForFraRsv(lngStrRsvNo, lngEndRsvNo, strRsvNo)
			If lngCount <= 0 Then
				strMessage = "��f��񂪑��݂��܂���B"
				Exit Do
			End If

			strSameGrp1 = Array()
			strSameGrp2 = Array()
			strSameGrp3 = Array()
			ReDim Preserve strSameGrp1(lngCount - 1)
			ReDim Preserve strSameGrp2(lngCount - 1)
			ReDim Preserve strSameGrp3(lngCount - 1)
			For i = 0 To UBound(strSameGrp1)
				strSameGrp1(i) = ""
				strSameGrp2(i) = ""
				strSameGrp3(i) = ""
			Next

			'���A��l�o�^
			objConsult.UpdateFriends dtmCslDate, 0, strRsvNo, strSameGrp1, strSameGrp2, strSameGrp3, strMessage
			If Not IsEmpty(strMessage) Then
				strMessage = "���łɂ��A��l���o�^����Ă��܂��B"
				Exit Do
			End If

			Set objConsult = Nothing

			'���g�����_�C���N�g
			strURL = Request.ServerVariables("SCRIPT_NAME")
			strURL = strURL & "?cslDate="  & dtmCslDate
			strURL = strURL & "&strRsvNo=" & lngStrRsvNo
			strURL = strURL & "&endRsvNo=" & lngEndRsvNo
			strURL = strURL & "&mode="     & "friendsEnd"
			Response.Redirect strURL
			Response.End

			Exit Do
		Loop

		Set objConsult = Nothing

End Select
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�\�񊮗�</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var url = '<%= Request.ServerVariables("SCRIPT_NAME") %>?cslDate=<%= dtmCslDate %>&strRsvNo=<%= lngStrRsvNo %>&endRsvNo=<%= lngEndRsvNo %>';

// �����ғo�^
function updateCompPerId( perId, compPerId ) {

	if ( !confirm('���̂Q�l�𓯔��҂Ƃ��ēo�^���܂����H') ) return;

	document.location.href = url + '&mode=comp&perId=' + perId + '&compPerId=' + compPerId;

}

// ���A��l�o�^
function registFriends() {

	if ( !confirm('�����̎�f�������A��l�Ƃ��ēo�^���܂����H') ) return;

	document.location.href = url + '&mode=friends';

}

// �폜����
function deleteConsult() {

	if ( !confirm('���̎�f�����폜���܂����H') ) return;

	document.location.href = url + '&mode=delete';

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�\�񊮗�</FONT></B></TD>
	</TR>
</TABLE>
<%
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'�w��\��ԍ��͈͂̎�f�҈ꗗ���擾
lngCount = objConsult.SelectConsultListForFraRsv(lngStrRsvNo, lngEndRsvNo, strRsvNo, , strWebColor, strCsName, strArrPerId, strLastName, strFirstName, , , , , , , , strOrgSName, strOptName, strRsvGrpName, strArrCompPerId, strHasFriends)

Set objConsult = Nothing
%>
<BR>�u<B><FONT COLOR="#ffa500"><%= Year(dtmCslDate) %>�N<%= Month(dtmCslDate) %>��<%= Day(dtmCslDate) %>��</FONT></B>�v �� <B><FONT COLOR="#ffa500"><%= lngCount %></FONT></B>���̗\������܂����B<BR>
<%
'���b�Z�[�W�̕ҏW
Select Case strMode
	Case "compEnd"
		Call EditMessage("�����҂Ƃ��ēo�^����܂����B", MESSAGETYPE_NORMAL)
	Case "friendsEnd"
		Call EditMessage("���A��l�Ƃ��ēo�^����܂����B", MESSAGETYPE_NORMAL)
	Case Else
		Call EditMessage(strMessage, MESSAGETYPE_WARNING)
End Select
%>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR BGCOLOR="#dcdcdc">
		<TD NOWRAP WIDTH="120">��f�R�[�X</TD>
		<TD NOWRAP WIDTH="120">�l����</TD>
		<TD NOWRAP WIDTH="150">�c�̖�</TD>
		<TD NOWRAP WIDTH="200">�����I�v�V����</TD>
		<TD NOWRAP>���Ԙg</TD>
	</TR>
<%
	'��f�҈ꗗ�̕ҏW
	For i = 0 To lngCount - 1

		strName = Trim(strLastName(i) & "�@" & strFirstName(i))
%>
		<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "e0ffff") %>">
			<TD NOWRAP><FONT COLOR="<%= strWebColor(i) %>">��</FONT><A HREF="/webHains/contents/reserve/rsvMain.asp?rsvNo=<%= strRsvNo(i) %>" TARGET="_blank"><%= strCsName(i) %></A></TD>
<% '## 2003.12.12 Mod By T.Takagi@FSIT ��������l�ւ͂Ƃ΂��Ȃ� %>
<!--
			<TD NOWRAP><A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= strArrPerId(i) %>" TARGET="_blank"><%= strName %></A></TD>
-->
			<TD NOWRAP><%= strName %></TD>
<% '## 2003.12.12 Mod End %>
			<TD NOWRAP><%= strOrgSName(i) %></TD>
			<TD NOWRAP><%= Replace(strOptName(i), ",", "�A") %></TD>
			<TD NOWRAP><%= strRsvGrpName(i) %></TD>
		</TR>
<%
		'���A��l���̗L���𔻒�
		If strHasFriends(i) <> "" Then
			blnHasFriends = True
		End If

	Next
%>
</TABLE>
<BR>
<%
'�����҂Q�l�A��ł��邩�𔻒f
Do
	blnComp = False

	'�Q���łȂ���ΏI��
	If lngCount <> 2 Then
		Exit Do
	End If

	'���ꂼ��̌l�h�c�A�����Ҍl�h�c���N���X��r���A�����҂ǂ����ł��邩�𔻒�B�^�Ȃ烁�b�Z�[�W�B
	If strArrPerId(0) = strArrCompPerId(1) And strArrPerId(0) = strArrCompPerId(1) Then
%>
		<FONT COLOR="#ff9900"><B>����2���͓����҂ł��B</B></FONT><BR><BR>
<%
		blnComp = True
		Exit Do
	End If

	'����Ƃ͈قȂ铯���҂����ꍇ�͂���ȏ㉽�����Ȃ�
	If (strArrCompPerId(0) <> "" And strArrCompPerId(0) <> strArrPerId(1)) Or (strArrCompPerId(1) <> "" And strArrCompPerId(1) <> strArrPerId(0)) Then
		Exit Do
	End If

	'��L�ȊO�ł���Γ����҂Ƃ��ēo�^�\�ȋ@�\��p�ӂ���
%>
	<A HREF="javascript:updateCompPerId('<%= strArrPerId(0) %>','<%= strArrPerId(1) %>')">����2���𓯔��҂Ƃ��ēo�^����</A><BR><BR>
<%
	Exit Do
Loop

'���A��l�o�^�v�ۂ̔��f
Do

	'���łɂ��A��l�Ƃ��ēo�^����Ă����񂪂���ΏI��
	If blnHasFriends Then
%>
		<FONT COLOR="#ff9900"><B>���A��l�Ƃ��ēo�^����Ă��܂��B</B></FONT><BR><BR>
<%
		Exit Do
	End If

	'�������łȂ��ΏI��
	If lngCount <= 1 Then
		Exit Do
	End If

	'���A��l�Ƃ��ēo�^�\�ȋ@�\��p�ӂ���
%>
	<A HREF="javascript:registFriends()">�����̎�f�������A��l�Ƃ��ēo�^����</A><BR>
<%
	Exit Do
Loop
%>
<BR>
<A HREF="javascript:deleteConsult()"><IMG SRC="/webHains/images/delete.gif" ALT="���̎�f�����폜����" HEIGHT="24" WIDTH="73"></A>
</BODY>
</HTML>
