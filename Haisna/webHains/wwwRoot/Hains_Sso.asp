<%@ LANGUAGE="VBScript" %>
<%
'########################################
'�Ǘ��ԍ��FSL-UI-Y0101-003
'�쐬��  �F2010.06.23
'�S����  �FFJTH)KOMURO
'�쐬���e�F�V���O���T�C���I���@�\��V�K�쐬
'########################################
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objLogin 		'���[�U�[�h�c�A�p�X���[�h�`�F�b�N�p�b�n�l�I�u�W�F�N�g

'�p�����[�^
Dim strCslDate		'��f��(yyyymmdd)
Dim strUserId		'���p��ID

'���[�U�[�h�c�A�p�X���[�h�`�F�b�N
Dim Ret     		'�߂�l
Dim strUserName		'���p�Ҋ�������
Dim lngAuthTblMnt	'�e�[�u�������e�i���X����
Dim lngAuthRsv		'�\��Ɩ�����
Dim lngAuthRsl		'���ʓ��͋Ɩ�����
Dim lngAuthJud		'������͋Ɩ�����
Dim lngAuthPrn		'����A�f�[�^���o�Ɩ�����
Dim lngAuthDmd		'�����Ɩ�����
Dim lngIgnoreFlg	'�\��g�����t���O
Dim lngDeptCd       '
Dim lngUsrGrpCd     '
Dim strDelFlg		'�폜�t���O

'���_�C���N�g�p
Dim strURL
Dim strCslYear
Dim strCslMonth
Dim strCslDay

'�`�F�b�N�p
Dim blnDateCheck	'�p�����^���t�̗L����
Dim strMessage		'���b�Z�[�W�ҏW�p

'�����l�̎擾
strCslDate		= "" & Trim(Request("csldate"))
strUserId		= "" & Trim(Request("userid"))

Do

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objLogin = Server.CreateObject("HainsHainsUser.HainsUser")

	'���p�ҏ��̌���	
	Ret = objLogin.SelectHainsUser(strUserId, strUserName, , , , , , , , _
		                           lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd, , , , , , , , , , _
								   lngIgnoreFlg, , , , , strDelFlg, , , , , lngDeptCd, lngUsrGrpCd)

	'���p�҂����݂���ꍇ
	If Ret = True And Trim(strDelFlg) = "" Then
	
		'�Z�b�V�����Ɋe������i�[
		Session("USERID")      = strUserId
		Session("USERNAME")    = strUserName
		Session("AUTH_TBLMNT") = lngAuthTblMnt
		Session("AUTH_RSV")    = lngAuthRsv
		Session("AUTH_RSL")    = lngAuthRsl
		Session("AUTH_JUD")    = lngAuthJud
		Session("AUTH_PRN")    = lngAuthPrn
		Session("AUTH_DMD")    = lngAuthDmd
		Session("IGNORE")      = lngIgnoreFlg
		Session("DEPTCD")      = lngDeptCd
		Session("USRGRPCD")    = lngUsrGrpCd
	
		'�\�����t��ݒ�
		If strCslDate <> "" And Len(strCslDate) = 10 Then
		
			strCslYear  = Left(strCslDate, 4)
			strCslMonth = Mid(strCslDate, 6, 2)
			strCslDay   = Right(strCslDate, 2)

			'���t���L�������`�F�b�N
			If IsDate(strCslYear & "/" & strCslMonth & "/" & strCslDay) = True Then
			
				blnDateCheck = True
			
			End If
		
		End If

		'���t���L���łȂ��ꍇ�A�V�X�e�����t��ݒ肷��
		If blnDateCheck <> True Then

			strCslYear = Right("00" & Year(Now()), 4)
			strCslMonth = Right("0" & Month(Now()), 2)
			strCslDay = Right("0" & Day(Now()), 2)

		End If

		'�^�[�Q�b�g�y�[�W���p�����^�̐ݒ�
		strURL = Application("STARTPAGE")
		strURL = strURL & "?cslYear="  & strCslYear
		strURL = strURL & "&cslMonth=" & strCslMonth
		strURL = strURL & "&cslDay="   & strCslDay

		'�^�[�Q�b�g��̃y�[�W��
		Response.Redirect strURL

	End If

	Exit Do

Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>���f�V�X�e���N��</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">���f�V�X�e���N��</FONT></B></TD>
		</TR>
	</TABLE>
<%
	If Ret <> True Then

		strMessage = "���p�ҏ�񂪌��f�V�X�e���ɓo�^����Ă��܂���B"

	ElseIf Trim(strDelFlg) <> "" Then

		strMessage = "���p�ҏ��͌��f�V�X�e���ł͗��p�s�ɂȂ��Ă��܂��B"

	End If

	If strMessage <> "" Then

		EditMessage strMessage, MESSAGETYPE_WARNING

	End If
%>
	<BR>
</FORM>
</BODY>
</HTML>
