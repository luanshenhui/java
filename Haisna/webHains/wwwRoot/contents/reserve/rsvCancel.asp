<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�\��̃L�����Z�� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_CANCEL   = "cancel"	'�������[�h(��t������)

Const FREECD_CANCEL = "CANCEL"	'�ėp�R�[�h(�L�����Z�����R)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objFree			'�ėp���A�N�Z�X�p

'�L�����Z�����R
Dim strFreeCd		'�ėp�R�[�h
Dim strFreeField1	'�ėp�t�B�[���h1
Dim lngCount		'���R�[�h��

Dim strCancelFlg()	'�L�����Z�����R
Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFree = Server.CreateObject("HainsFree.Free")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�\��̃L�����Z��</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function cancel() {

    var myForm   = document.entryForm;					// ����ʂ̃t�H�[���G�������g
    var mainForm = opener.top.main.document.entryForm;	// ���C����ʂ̃t�H�[���G�������g

    // �L�����Z�����R�̕K�{�`�F�b�N
    if ( myForm.cancelFlg.value == '' ) {
        alert('�L�����Z�����R���w�肵�ĉ������B');
        return;
    }

    // �L�����Z�����R�y�ы����t���O���w��
    mainForm.cancelFlg.value   = myForm.cancelFlg.value;
    mainForm.cancelForce.value = myForm.notCancelForce.checked ? '' : '1';

    // �\����ڍ׉�ʂ�submit����
    opener.top.submitForm('<%= MODE_CANCEL %>');

    close();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ONSUBMIT="JavaScript:return false" action="#">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�\��̃L�����Z��</FONT></B></TD>
        </TR>
    </TABLE>

    <BR>
<%
    '�ėp�e�[�u������L�����Z�����R��ǂݍ���
'### 2007/02/08 �� �L�����Z�����R��\�����鎞�A�ėp�R�[�h�ł͂Ȃ��o�^���ꂽ����(FREEFIELD3)�ɂ���ĕ\������悤�ɕύX Start ###
    'lngCount = objFree.SelectFree(1, FREECD_CANCEL, strFreeCd, , ,strFreeField1)
    lngCount = objFree.SelectFree(3, FREECD_CANCEL, strFreeCd, , ,strFreeField1)
'### 2007/02/08 �� �L�����Z�����R��\�����鎞�A�ėp�R�[�h�ł͂Ȃ��o�^���ꂽ����(FREEFIELD3)�ɂ���ĕ\������悤�ɕύX End   ###

    If lngCount > 0 Then

        '�ėp�R�[�h����L�����Z�����R�p�̐ړ��q���폜����
        Redim Preserve strCancelFlg(lngCount - 1)
        For i = 0 To lngCount - 1
            strCancelFlg(i) = Right(strFreeCd(i), Len(strFreeCd(i)) - Len(FREECD_CANCEL))
        Next
%>
        ���̗\������L�����Z�����܂��B<BR><BR>

        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD>�L�����Z�����R�F</TD>
                <TD><%= EditDropDownListFromArray("cancelFlg", strCancelFlg, strFreeField1, Empty, Empty) %></TD>
            </TR>
        </TABLE>
<%
    Else
%>
        �L�����Z�����R���o�^����Ă��܂���B
<%
    End If
%>
    <BR>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD><INPUT TYPE="checkbox" NAME="notCancelForce" CHECKED></TD>
            <TD NOWRAP>��f�����͂���Ă���ꍇ�̓L�����Z�����s��Ȃ�</TD>
        </TR>
    </TABLE>

    <BR>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" ALIGN="right">
        <TR>
<%
            '�L�����Z�����R���o�^����Ă���ꍇ�̂݊m��{�^����ҏW����
            If lngCount > 0 Then
%>
                <TD><A HREF="JavaScript:cancel()"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̓��e�ŗ\��m��"></A></TD>
<%
            End If
%>
            <TD><A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
        </TR>
    </TABLE>

</FORM>
</BODY>
</HTML>
