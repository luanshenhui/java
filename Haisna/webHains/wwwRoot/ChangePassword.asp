<%@ LANGUAGE="VBScript" %>
<%
'========================================
'�Ǘ��ԍ��FSL-HS-Y0101-003
'�C����  �F2010.07.16
'�S����  �FFJTH)KOMURO
'�C�����e�F�A�g��T�[�o���̕ϊ�
'========================================

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkAgent.inc" -->
<!-- #### 2010.07.16 SL-HS-Y0101-003 ADD START   #### -->
<!-- #include virtual = "/webHains/includes/convertAddress.inc" -->
<!-- #### 2010.07.16 SL-HS-Y0101-003 ADD END     #### -->
<%
'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Dim strUserId           '���[�UID
Dim strPassWord         '���p�X���[�h
Dim strNewPassWord      '�V�p�X���[�h
Dim strTarget           '�^�[�Q�b�g���URL
Dim strMessage          '���b�Z�[�W
Dim objLogin            '���[�U�[�h�c�A�p�X���[�h�`�F�b�N�p�b�n�l�I�u�W�F�N�g
'#### 2005.09.09 �ǉ� �� ######################################################
Dim strSysKind          '���O�C����ʕ\���ׁ̈A��̃V�X�e���敪���擾

'���[�U�[�h�c�A�p�X���[�h�`�F�b�N
Dim lngErrNo            '�߂�l
Dim lngRet              '�߂�l
Dim strUserName         '���p�Ҋ�������
Dim lngAuthTblMnt       '�e�[�u�������e�i���X����
Dim lngAuthRsv          '�\��Ɩ�����
Dim lngAuthRsl          '���ʓ��͋Ɩ�����
Dim lngAuthJud          '������͋Ɩ�����
Dim lngAuthPrn          '����A�f�[�^���o�Ɩ�����
Dim lngAuthDmd          '�����Ɩ�����
Dim blnComplete         'TRUE:�p�X���[�h�ύX����I��

Dim strElementName      '�G�������g��

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�y�[�W�L���b�V���͍s��Ȃ�
Response.Expires = -1

'�����l�̎擾
strUserId           = Request.Form("userId")
strPassWord         = Request.Form("oldPassword")
strNewPassWord      = Request.Form("newPassword")
strTarget           = Request("target")
strSysKind          = Request("sysKind")

'�t�H�[�J�X���ڂ��G�������g���̏����ݒ�
strElementName      = "userId"

blnComplete         = False
Do
    '���[�UID�����݂��Ȃ��ꍇ�͉������Ȃ�
    If strUserId = "" Then
        strMessage  = "���[�U�h�c�ƃp�X���[�h����͂��ĉ������B"
        Exit Do
    End If

    '�p�X���[�h�`�F�b�N
    If strPassWord = "" Then
        strMessage      = "�p�X���[�h���󔒎w�肷�邱�Ƃ͂ł��܂���B"
        strElementName  = "oldPassword"
        Exit Do
    End If

    If strNewPassWord = "" Then
        strMessage      = "�p�X���[�h���󔒎w�肷�邱�Ƃ͂ł��܂���B"
        strElementName  = "newPassword"
        Exit Do
    End If

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objLogin = Server.CreateObject("HainsHainsUser.HainsUser")

    '���[�U�h�c�A�p�X���[�h�`�F�b�N
    lngErrNo = objLogin.CheckIDandPassword(strUserId, strPassWord, strUserName, lngAuthTblMnt, lngAuthRsv, lngAuthRsl, lngAuthJud, lngAuthPrn, lngAuthDmd)
    Select Case lngErrNo
        Case 0
        Case 1
            strMessage = "���͂��ꂽ���[�U�h�c�͑��݂��܂���B"
            Exit Do
        Case 2
            strMessage = "�p�X���[�h������������܂���B"

            '�p�X���[�h�s�����̂݃p�X���[�h�Ƀt�H�[�J�X���ڂ����邽�߂̏���
            strElementName = "oldPassword"

            Exit Do
        Case 3
            strMessage = "webHains���g�p���錠��������܂���B�Ǘ��҂ɘA�����Ă��������B"
            Exit Do
        Case 9
            strMessage = "���[�U�h�c�ƃp�X���[�h����͂��ĉ������B"
            Exit Do
    End Select

    '���[�U�h�c�A�p�X���[�h�`�F�b�N
    lngRet = objLogin.RegistHainsUser("PWD", strUserId, strUserName, strNewPassWord)
    If lngRet <> INSERT_NORMAL Then
        strMessage = "���͂��ꂽ���[�U�h�c�͑��݂��܂���B"
        Exit Do
    End If

    strMessage = "�p�X���[�h�͐���ɍX�V����܂����B"
    blnComplete = True

    Exit Do
Loop

'�Z�b�V�����ؒf��ԂƂ��ă��O�C����ʂ�\������
Session.Abandon
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
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
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
<%
    If blnComplete = False Then
%>
function CheckNewPassWord() {

    var myForm      = document.idandpass;    // ����ʂ̃t�H�[���G�������g
    var strAlpha    = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var strNumber   = '1234567890';
    var strChk      = '';
    var cntAlp      = '';
    var cntNum      = 77;

    if ( myForm.userId.value == '' ) {
        alert ('���[�U������͂��Ă��������B');
        myForm.userId.focus();
        return false;
    }

    if ( myForm.oldPassword.value == '' ) {
        alert ('���݂̃p�X���[�h����͂��Ă��������B');
        myForm.oldPassword.focus();
        return false;
    }

    if ( myForm.newPassword.value == '' ) {
        alert ('�V�����p�X���[�h����͂��Ă��������B');
        myForm.newPassword.focus();
        return false;
    }

    if ( myForm.newPassword2.value == '' ) {
        alert ('�V�����p�X���[�h�͂Q����͂��Ă��������B');
        myForm.newPassword2.focus();
        return false;
    }

    if ( myForm.newPassword.value != myForm.newPassword2.value ) {
        alert ('���͂��ꂽ�Q�̐V�����p�X���[�h���قȂ��Ă��܂��B');
        return false;
    }
    /************************************************************************************/
    /** 2006.06.17 �� �p�X���[�h�͂U���ȏ���͂��Ȃ��ƃ��O�C���ł��Ȃ��悤�ɕύX Start **/
    /************************************************************************************
    if ( myForm.newPassword.value.length < 4 ) {
        alert ('�p�X���[�h�� 4�����ȏ�Ɏw�肵�Ȃ���΂Ȃ�Ȃ��ł��B');
        myForm.newPassword.focus();
        return false;
    }
    *******************************************************************************/

    /************************************************************************************/
    /** 2014.06.30 �� �p�X���[�h�͂U�����p���Ɛ������܂ނW�����ȏ�ɕύX Start         **/
    /************************************************************************************
    if ( myForm.newPassword.value.length < 6 ) {
        alert ('�p�X���[�h�� �U�����ȏ�Ɏw�肵�Ȃ���΂Ȃ�Ȃ��ł��B');
        myForm.newPassword.focus();
        return false;
    }
    *******************************************************************************/

    cntAlpha    = 0;
    cntNum      = 0;

    if ( myForm.newPassword.value.length < 8 ) {

        alert ('�p�X���[�h�� �p���Ɛ������܂ނW�����ȏ�ɐݒ肵�Ă��������B');
        myForm.newPassword.focus();
        return false;

    } else {

        strChk = '';
        for (ki=0; ki < myForm.newPassword.value.length; ki++) {
            strChk = myForm.newPassword.value.charAt(ki);

            if (strAlpha.indexOf(strChk) != -1){
                cntAlpha = 1;
            }
            
            if(strNumber.indexOf(strChk) != -1){
                cntNum = 1;
            }
        }

        if (cntAlpha + cntNum < 2){
            alert ('�p�X���[�h�� �p���Ɛ������܂ނW�����ȏ�ɐݒ肵�Ă��������B');
            myForm.newPassword.focus();
            return false;
        }
    }
    /** 2014.06.30 �� �p�X���[�h�͂U�����p���Ɛ������܂ނW�����ȏ�ɕύX End           **/
    /************************************************************************************/

    /** 2006.06.17 �� �p�X���[�h�͂U���ȏ���͂��Ȃ��ƃ��O�C���ł��Ȃ��悤�ɕύX End   **/
    /************************************************************************************/


    /** 2005.09.09 �ǉ� �� :*******************************************************/
    if ( myForm.oldPassword.value == myForm.newPassword.value ) {
        alert ('�V�����p�X���[�h�����݃p�X���[�h�Ɠ����ł��B�V�����p�X���[�h����͂��Ă��������B');
        myForm.newPassword.focus();
        return false;
    }

    myForm.submit();
    return false;
}
<%
    End If
%>
-->
</SCRIPT>
</HEAD>
<%
    If blnComplete = True Then
%>
<BODY>
<%
    Else
%>
<BODY ONLOAD="JavaScript:document.idandpass.<%= strElementName %>.focus()">
<%
    End If
%>

<FORM NAME="idandpass" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="target" VALUE="<%= strTarget %>">
<INPUT TYPE="hidden" NAME="sysKind" VALUE="<%= strSysKind %>">
<DIV ALIGN="center">
<BR><BR><BR>
<BR><BR><%= strMessage %>
<BR><BR>
<%
    '#### 2005.09.09 �ǉ� �� ######################################################
    If blnComplete = True Then
        If strSysKind = "GUIDE" Then
%>
<!-- #### 2010.07.16 SL-HS-Y0101-003 MOD START #### -->
<%'    <A HREF="http://157.104.16.195/login.jsp">���O�C����ʂ�</A> %>
    <A HREF="http://<%= convertAddress("Guide") %>/login.jsp">���O�C����ʂ�</A>
<!-- #### 2010.07.16 SL-HS-Y0101-003 MOD END     #### -->
<%
        Else
%>
    <A HREF="/webHains/login.asp">���O�C����ʂ�</A>
<%
        End if
    Else
%>
<TABLE>
    <TR>
        <TD ALIGN="right">���[�U�h�c�F</TD>
        <TD><INPUT TYPE="text" SIZE="12" MAXLENGTH="20" NAME="userId" VALUE="<%= strUserId %>" CLASS="texttype"></TD>
    </TR>
    <TR>
        <TD ALIGN="right">���̃p�X���[�h�F</TD>
        <TD><INPUT TYPE="password" SIZE="12" MAXLENGTH="64" NAME="oldPassword" CLASS="texttype"></TD>
    </TR>
    <TR>
        <TD HEIGHT="20"></TD>
    </TR>

    <TR>
        <TD COLSPAN="3" ALIGN="center">�� �V�����p�X���[�h��<FONT COLOR="#ff6600"><B>�p���Ɛ������܂ނW�����ȏ�</B></FONT>�Őݒ肵�Ă��������B</TD>
    </TR>

    <TR>
        <TD HEIGHT="10"></TD>
    </TR>
    <TR>
        <TD ALIGN="right">�V�����p�X���[�h�F</TD>
        <TD><INPUT TYPE="password" SIZE="12" MAXLENGTH="64" NAME="newPassword" CLASS="texttype"></TD>
    </TR>
    <TR>
        <TD ALIGN="right">�V�����p�X���[�h�F</TD>
        <TD><INPUT TYPE="password" SIZE="12" MAXLENGTH="64" NAME="newPassword2" CLASS="texttype"></TD>
        <TD><FONT COLOR="#999999">�m�F�̂��߁A������x</FONT></TD>
    </TR>
    <TR>
        <TD HEIGHT="10"></TD>
    </TR>


    <TR>
        <TD></TD>
        <TD><INPUT TYPE="button" ONCLICK="JavaScript:return CheckNewPassWord()" VALUE="�ύX����">
        </TD>
    </TR>
</TABLE>
<%
    End If
%>
</DIV>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
