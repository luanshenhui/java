<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web�\����o�^(��f�t�����) (Ver1.0.0)
'      AUTHER  : 
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
Dim blnReadOnly     '�ǂݍ��ݐ�p

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
blnReadOnly = (Request("readOnly") <> "")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�\����ڍ�(��f�t�����)</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winPersonal;    // �E�B���h�E�n���h��

// ��f�t�����ڍ׉�ʌĂяo��
function callPersonalDetailWindow() {

    var detailForm = top.detail.document.paramForm;

    var opened = false;     // ��ʂ��J����Ă��邩
    var url;                // ��f�t�����ڍ׉�ʂ�URL

    // ���T�u��ʂ����
    top.closeWindow( 5 );

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winPersonal != null ) {
        if ( !winPersonal.closed ) {
            opened = true;
        }
    }

    // ��f�t�����ڍ׉�ʂ�URL�ҏW
    url = 'webOrgRsvPersonalDetail.asp';

    // �Љ�ҁA�O���f����ǉ�
    url = url + '?introductor=' + detailForm.introductor.value;
    url = url + '&lastCslDate=' + detailForm.lastCslDate.value;

    // ��{���ɂĒc�̂��w�肳��Ă���ꍇ�͒ǉ�
    if ( detailForm.orgCd1.value != '' && detailForm.orgCd2.value != '' ) {
        url = url + '&orgCd1=' + detailForm.orgCd1.value;
        url = url + '&orgCd2=' + detailForm.orgCd2.value;
    }

    // �ǂݍ��ݐ�p�t���O�̒ǉ�
    url = url + '&readOnly=' + '<%= IIf(blnReadOnly, "1", "") %>';

    // �J����Ă���ꍇ�͉�ʂ�FOCUS���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winPersonal.focus();
    } else {
        winPersonal = window.open( url, '', 'width=500,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

// ��f�t�����ڍ׉�ʂ����
function closePersonalDetailWindow() {

    if ( winPersonal != null ) {
        if ( !winPersonal.closed ) {
            winPersonal.close();
        }
    }

    winPersonal = null;
}

// ��������
function initialize() {

    // ��{���ł̕ێ��l��{��ʂɐݒ肷��
    top.getPersonalValue();
<%
    '�ǂݎ���p���͂��ׂĂ̓��͗v�f���g�p�s�\�ɂ���
    If blnReadOnly Then
%>
        top.disableElements( document.entryForm );
<%
    End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 8px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:initialize()" ONUNLOAD="javascript:closePersonalDetailWindow()">
<FORM NAME="entryForm" action="#">
    <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">��f�t�����</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD HEIGHT="5"></TD>
        <TR>
            <TD>�\���</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="rsvStatus">
                    <OPTION VALUE="0">�m��
                    <OPTION VALUE="1">�ۗ�
                    <!--#### 2007/04/04 �� �\��󋵋敪�ǉ� Start ####-->
                    <OPTION VALUE="2">���m��
                    <!--#### 2007/04/04 �� �\��󋵋敪�ǉ� End   ####-->
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        <TR>
        <TR>
            <TD>�ۑ������</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="0"></TD>
                        <TD NOWRAP>�Ȃ�</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="1"></TD>
                        <TD NOWRAP>�͂���</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="2"></TD>
                        <TD NOWRAP>���t�ē�</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD NOWRAP>����i�m�F�͂����j</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="cardAddrDiv">
                                <OPTION VALUE="1">�Z���i����j
                                <OPTION VALUE="2">�Z���i�Ζ���j
                                <OPTION VALUE="3">�Z���i���̑��j
                            </SELECT>
                        </TD>
                        <TD NOWRAP>�@�p���o��</TD>
                        <TD><INPUT TYPE="radio" NAME="cardOutEng" VALUE="1"></TD>
                        <TD>�L</TD>
                        <TD><INPUT TYPE="radio" NAME="cardOutEng" VALUE="0"></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD>����i�ꎮ�����j</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="formAddrDiv">
                                <OPTION VALUE="1">�Z���i����j
                                <OPTION VALUE="2">�Z���i�Ζ���j
                                <OPTION VALUE="3">�Z���i���̑��j
                            </SELECT>
                        </TD>
                        <TD NOWRAP>�@�p���o��</TD>
                        <TD><INPUT TYPE="radio" NAME="formOutEng" VALUE="1"></TD>
                        <TD>�L</TD>
                        <TD><INPUT TYPE="radio" NAME="formOutEng" VALUE="0"></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP>����i���ѕ\�j</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="reportAddrDiv">
                                <OPTION VALUE="1">�Z���i����j
                                <OPTION VALUE="2">�Z���i�Ζ���j
                                <OPTION VALUE="3">�Z���i���̑��j
                            </SELECT>
                        </TD>
                        <TD NOWRAP>�@�p���o��</TD>
                        <TD><INPUT TYPE="radio" NAME="reportOutEng" VALUE="1"></TD>
                        <TD>�L</TD>
                        <TD><INPUT TYPE="radio" NAME="reportOutEng" VALUE="0"></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>�f�@�����s</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="issueCslTicket">
                    <OPTION VALUE="">&nbsp;
                    <OPTION VALUE="1">�V�K
                    <OPTION VALUE="2">����
                    <OPTION VALUE="3">�Ĕ��s
                </SELECT>
            </TD>
        </TR>
    </TABLE>
</FORM>
<A HREF="javascript:callPersonalDetailWindow()">���̑��̕t������<%= IIf(blnReadOnly, "����", "����") %></A>
</BODY>
</HTML>
