<%@ LANGUAGE="VBScript" %>
<%
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkAgent.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Dim strUserId		'���[�UID
Dim strPassWord		'�p�X���[�h
Dim strTarget		'�^�[�Q�b�g���URL
Dim strMessage		'���b�Z�[�W

Dim objLogin 		'���[�U�[�h�c�A�p�X���[�h�`�F�b�N�p�b�n�l�I�u�W�F�N�g

'���[�U�[�h�c�A�p�X���[�h�`�F�b�N
Dim lngErrNo		'�߂�l
Dim strUserName		'���p�Ҋ�������
Dim lngAuthTblMnt	'�e�[�u�������e�i���X����
Dim lngAuthRsv		'�\��Ɩ�����
Dim lngAuthRsl		'���ʓ��͋Ɩ�����
Dim lngAuthJud		'������͋Ɩ�����
Dim lngAuthPrn		'����A�f�[�^���o�Ɩ�����
Dim lngAuthDmd		'�����Ɩ�����
Dim lngIgnoreFlg	'�\��g�����t���O
Dim strElementName	'�G�������g��

'2005.07.27 ADD By �� 
Dim objAuthority
Dim lngDeptCd           '
Dim lngUsrGrpCd         '
Dim strPwdInfo          '
Dim bolAlert
'2005.07.27 ADD End  

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�y�[�W�L���b�V���͍s��Ȃ�
Response.Expires = -1

'�����l�̎擾
strUserId   = Trim(Request.Form("userId"))
strPassWord = Request.Form("password")
strTarget   = Request("target")

'�t�H�[�J�X���ڂ��G�������g���̏����ݒ�
strElementName = "userId"

'## 2005.08.06 Add by ��
bolAlert = False
'## 2005.08.06 Add End


Do

	'���[�UID�����݂��Ȃ��ꍇ�͉������Ȃ�
	If strUserId = "" Then
        strMessage = "���[�U�h�c�ƃp�X���[�h����͂��ĉ������B"
		Exit Do
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objLogin = Server.CreateObject("HainsHainsUser.HainsUser")

	'���[�U�h�c�A�p�X���[�h�`�F�b�N
'	lngErrNo = objLogin.CheckIDandPassword(strUserId, strPassWord, strUserName, lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd, , lngIgnoreFlg)


'## 2005.07.26 Edit by ��  ####
	lngErrNo = objLogin.CheckIDandPassword(strUserId, strPassWord, strUserName, lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd, , lngIgnoreFlg, , lngDeptCd, lngUsrGrpCd)
'## 2005.07.26 Edit End.   ####

    Select Case lngErrNo
		Case 0

		'#### 2005.08.04 ADD By �� �F�p�X���[�h�̗L�����Ԃ��`�F�b�N����B################# 
			'If Session("USERID")  = "" then
				'�I�u�W�F�N�g�̃C���X�^���X�쐬
				Set objAuthority = Server.CreateObject("HainsAuthority.CheckAuthority")
				lngErrNo = objAuthority.CheckPwdDate(strUserId, strMessage)

				Select Case lngErrNo
					Case 0

					Case 1			'�yAlert�z�g�p�\���Ԋm�F 
                        			Session("EXPDATE")    = strMessage                
                    			Case 2
					'�p�X���[�h�̗L�����Ԃ�����
						Exit Do
				End Select
			'End If
		'#### 2005.08.04 ADD End   ####################################################


		Case 1
			strMessage = "���͂��ꂽ���[�U�h�c�͑��݂��܂���B"
			Exit Do

		Case 2
            strMessage = "�p�X���[�h������������܂���B"

			'�p�X���[�h�s�����̂݃p�X���[�h�Ƀt�H�[�J�X���ڂ����邽�߂̏���
			strElementName = "password"
			Exit Do

		Case 3
            strMessage = "webHains���g�p���錠��������܂���B�Ǘ��҂ɘA�����Ă��������B"
			Exit Do

		Case 9
            strMessage = "���[�U�h�c�ƃp�X���[�h����͂��ĉ������B"
			Exit Do
	End Select


	'Session�ϐ��Ƀ��[�U�����i�[����
	Session("USERID")      = UCase(strUserId)
	Session("USERNAME")    = strUserName
	Session("AUTH_TBLMNT") = lngAuthTblMnt
	Session("AUTH_RSV")    = lngAuthRsv
	Session("AUTH_RSL")    = lngAuthRsl
	Session("AUTH_JUD")    = lngAuthJud
	Session("AUTH_PRN")    = lngAuthPrn
	Session("AUTH_DMD")    = lngAuthDmd
	Session("IGNORE")      = lngIgnoreFlg
'2005.07.27 ADD By �� 
	Session("DEPTCD")      = lngDeptCd
	Session("USRGRPCD")    = lngUsrGrpCd
'2005.07.27 ADD End 

	'�^�[�Q�b�g��̕ҏW
	If strTarget = "" Then
		strTarget = Application("STARTPAGE")
	End If

	'�^�[�Q�b�g��̃y�[�W��
	Response.Redirect strTarget

	Exit Do
Loop


'�Z�b�V�����ؒf��ԂƂ��ă��O�C����ʂ�\������
Session.Abandon


%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css?v=20151114">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>webH@ins - ���O�C��</TITLE>
<style TYPE="text/css">
input.texttype {
	ime-mode: disabled;
	width: 80px;
	height: 20px;
}
input.loginbutton {
	width: 100px;
	height: 20px;
}
</style>

<SCRIPT TYPE="text/javascript" language="javascript">
<!-- 
    function pwdClear(){
        document.idandpass.password.value = "";
        return;
    }

    /** Enter�L�[�ɂ��A���̗��ɃJ�[�\���ړ� **/
    function handleEnter (field, event) {
        var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
        if (keyCode == 13) {
                var i;
                for (i = 0; i < field.form.elements.length; i++)
                        if (field == field.form.elements[i])
                                break;
                i = (i + 1) % field.form.elements.length;
                field.form.elements[i].focus();
                return false;
        }
        else
        return true;
    }

    function submitEnter (field, event) {
        var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
        if (keyCode == 13) {
            with(document.idandpass){
                if(password.value.length == 0){
                    alert("���[�U�h�c�ƃp�X���[�h����͂��ĉ������B");
                    return;
                /** 2006.06.17 �� �p�X���[�h�͂U���ȏ���͂��Ȃ��ƃ��O�C���ł��Ȃ��悤�ɕύX **/
                //} else if(password.value.length < 4){
                } else if(password.value.length < 6){
                    alert("�p�X���[�h�͂U���ȏ���͂��Ă��������B\n�U���ȏ�̃p�X���[�h�ɕύX���A������x���O�C�����Ă��������B");
                    return;
                }
                submit();
            }
        }
        else
        return;
    }

    function submitCheck(){
        with(document.idandpass){
            if(password.value.length == 0){
                alert("���[�U�h�c�ƃp�X���[�h����͂��ĉ������B");
                return;
            /** 2006.06.17 �� �p�X���[�h�͂U���ȏ���͂��Ȃ��ƃ��O�C���ł��Ȃ��悤�ɕύX **/
            //} else if(password.value.length < 4){
            //    alert("�p�X���[�h�͂S���ȏ���͂��Ă��������B");
            } else if(password.value.length < 6){
                alert("�p�X���[�h�͂U���ȏ���͂��Ă��������B\n�U���ȏ�̃p�X���[�h�ɕύX���A������x���O�C�����Ă��������B");
                return;
            }
            submit();
        }
    }

//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="JavaScript:document.idandpass.<%= strElementName %>.focus()">
<FORM NAME="idandpass" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="target" VALUE="<%= strTarget %>">
<DIV ALIGN="center">
<BR><BR><BR>
<IMG SRC="/webHains/images/login.gif" ALT="���O�C��">
<BR><BR><%= strMessage %>
<BR><BR>

<TABLE>
	<TR>
		<TD ALIGN="right">���[�U�h�c�F</TD>
		<TD><INPUT TYPE="text" SIZE="10" MAXLENGTH="20" NAME="userId" VALUE="<%= strUserId %>" onBlur="pwdClear();" onkeypress="return handleEnter(this, event)" class="texttype"></TD>
	</TR>
	<TR>
		<TD ALIGN="right">�p�X���[�h�F</TD>
		<TD><INPUT TYPE="password" SIZE="10" MAXLENGTH="64" NAME="password" onFocus="pwdClear();" onkeypress="submitEnter(this, event);" class="texttype"></TD>
	</TR>
</TABLE>
<BR>
<!--INPUT TYPE="submit" VALUE="���O�C��"-->
<INPUT TYPE="button" VALUE="���O�C��" onClick="javascript:submitCheck()" class="loginbutton">
<BR><BR><BR><BR>
<A HREF="/webHains/ChangePassword.asp">�p�X���[�h��ύX����</A>
<BR><BR><BR>
<IMG WIDTH="170" HEIGHT="45" SRC="/webHains/images/logobig.gif" ALT="webHains"><BR><BR>
</DIV>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
