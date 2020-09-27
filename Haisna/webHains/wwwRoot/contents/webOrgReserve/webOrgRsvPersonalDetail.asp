<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web�\����o�^(��f�t�����ڍ�) (Ver1.0.0)
'      AUTHER  : 
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objOrganization     '�c�̏��A�N�Z�X�p
Dim objPerson           '�l���A�N�Z�X�p

'�����l
Dim	strIntroductor      '�Љ��
Dim strLastCslDate      '�O���f��
Dim strOrgCd1           '�c�̃R�[�h1
Dim strOrgCd2           '�c�̃R�[�h2
Dim blnReadOnly         '�ǂݍ��ݐ�p

'�c�̏��
Dim strBillCslDiv       '�������{�l�Ƒ��敪�o��
Dim strReptCslDiv       '���я��{�l�Ƒ��敪�o��

'�l���
Dim strLastName     '��
Dim strFirstName    '��
Dim strName         '����

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strIntroductor = Request("introductor")
strLastCslDate = Request("lastCslDate")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
blnReadOnly    = (Request("readOnly") <> "")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��f�t�����</TITLE>
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �l�����K�C�h�Ăяo��
function callPersonGuide() {
    perGuide_showGuidePersonal( document.entryForm.introductor, 'introductorName' );
}

// �l���̃N���A
function clearPerInfo() {
    perGuide_clearPerInfo( document.entryForm.introductor, 'introductorName' );
}

// ���̓`�F�b�N
function checkValue() {

    var main   = opener.top;
    var myForm = document.entryForm;

    var message = new Array();
    var ret     = true;

    // �{�����e�B�A���̕����񒷃`�F�b�N
    if ( main.getByte( myForm.volunteerName.value ) > 50 ) {
        message[ message.length ] = '�{�����e�B�A���̓��͓��e���������܂��B';
    }

    // �ی��؋L���̕����񒷃`�F�b�N
    if ( main.getByte( myForm.isrSign.value ) > 16 ) {
        message[ message.length ] = '�ی��؋L���̓��͓��e���������܂��B';
    }

    // �ی��ؔԍ��̕����񒷃`�F�b�N
    if ( main.getByte( myForm.isrNo.value ) > 16 ) {
        message[ message.length ] = '�ی��ؔԍ��̓��͓��e���������܂��B';
    }

    // �ی��Ҕԍ��̕����񒷃`�F�b�N
    if ( main.getByte( myForm.isrManNo.value ) > 16 ) {
        message[ message.length ] = '�ی��Ҕԍ��̓��͓��e���������܂��B';
    }

    // �Ј��ԍ��̕����񒷃`�F�b�N
    if ( main.getByte( myForm.empNo.value ) > 12 ) {
        message[ message.length ] = '�Ј��ԍ��̓��͓��e���������܂��B';
    }

    // ���b�Z�[�W���ݎ��͕ҏW
    if ( message.length > 0 ) {
        main.editMessage( document.getElementById('errMsg'), message, true );
        ret = false;
    }

    return ret;
}

// ��{���A��f�t�����ł̕ێ��l��ݒ�
function getPersonalValue() {

    var index      = 0;
    var main       = opener.top;
    var detailForm = main.detail.paramForm;
    var myForm     = document.entryForm;
    var calledForm = opener.document.entryForm;

    // �\���
    myForm.rsvStatus.value = calledForm.rsvStatus.value;

    // �ۑ������
    main.setRadioValue( myForm.prtOnSave, main.getRadioValue( calledForm.prtOnSave ) );

    // ����
    myForm.cardAddrDiv.value   = calledForm.cardAddrDiv.value;
    myForm.formAddrDiv.value   = calledForm.formAddrDiv.value;
    myForm.reportAddrDiv.value = calledForm.reportAddrDiv.value;
    main.setRadioValue( myForm.cardOutEng,   main.getRadioValue( calledForm.cardOutEng )   );
    main.setRadioValue( myForm.formOutEng,   main.getRadioValue( calledForm.formOutEng )   );
    main.setRadioValue( myForm.reportOutEng, main.getRadioValue( calledForm.reportOutEng ) );

    // �f�@�����s
    myForm.issueCslTicket.value = calledForm.issueCslTicket.value;

    // �ȉ��͊�{����hidden�l���擾

    // �Z��
    for ( var i = 0; i < detailForm.zipCd.length; i++ ) {
        var zipCd1 = detailForm.zipCd[ i ].value.substring(0, 3);
        var zipCd2 = detailForm.zipCd[ i ].value.substring(3, 7);
        document.getElementById('zipCd' + i).innerHTML = zipCd1 + ( ( zipCd2 != '' ) ? '-' : '' ) + zipCd2;
        document.getElementById('address' + i).innerHTML = detailForm.prefName[ i ].value + detailForm.cityName[ i ].value + detailForm.address1[ i ].value + detailForm.address2[ i ].value;
    }

    // �{�����e�B�A�A�z�����e�B�A��
    myForm.volunteer.value     = detailForm.volunteer.value;
    myForm.volunteerName.value = detailForm.volunteerName.value;

    // ���p�����
    myForm.collectTicket.value = ( detailForm.collectTicket.value != '' ) ? detailForm.collectTicket.value : '0';

    // �������o��
    if ( myForm.billPrint ) {
        myForm.billPrint.value = ( detailForm.billPrint.value != '' ) ? detailForm.billPrint.value : '0';
    }

    // �ی��؋L���A�ی��ؔԍ��A�ی��Ҕԍ��A�Ј��ԍ�
    myForm.isrSign.value  = detailForm.isrSign.value;
    myForm.isrNo.value    = detailForm.isrNo.value;
    myForm.isrManNo.value = detailForm.isrManNo.value;
    myForm.empNo.value    = detailForm.empNo.value;

    // �{�����e�B�A
    for ( var i = 0; i < myForm.volunteer.length; i++ ) {
 //       alert(myForm.volunteer.options[ index ].value);
 //       alert(detailForm.volunteer.value);
        // �I�����ׂ��v�f�ł���ΑI����Ԃɂ���
        if ( myForm.volunteer.options[ index ].value == detailForm.volunteer.value ) {
            myForm.volunteer.options[ index ].selected = true;
        }
        index++;
    }


}

// �o�^����
function regist() {

    // ���̓`�F�b�N���s���A����Ȃ��
    if ( checkValue() ) {

        // ��{���A�t�����ł̕ێ��l���X�V
        setPersonalValue();

        // ��ʂ����
        closeWindow();

    }

}

// ��{���A��f�t�����ł̕ێ��l���X�V
function setPersonalValue() {

    var main       = opener.top;
    var detailForm = main.detail.paramForm;
    var myForm     = document.entryForm;
    var calledForm = opener.document.entryForm;

    // �\���
    calledForm.rsvStatus.value = myForm.rsvStatus.value;

    // �ۑ������
    main.setRadioValue( calledForm.prtOnSave, main.getRadioValue( myForm.prtOnSave ) );

    // ����
    calledForm.cardAddrDiv.value   = myForm.cardAddrDiv.value;
    calledForm.formAddrDiv.value   = myForm.formAddrDiv.value;
    calledForm.reportAddrDiv.value = myForm.reportAddrDiv.value;
    main.setRadioValue( calledForm.cardOutEng,   main.getRadioValue( myForm.cardOutEng )   );
    main.setRadioValue( calledForm.formOutEng,   main.getRadioValue( myForm.formOutEng )   );
    main.setRadioValue( calledForm.reportOutEng, main.getRadioValue( myForm.reportOutEng ) );

    // �f�@�����s
    calledForm.issueCslTicket.value = myForm.issueCslTicket.value;

    // �ȉ��͊�{����hidden�l���X�V

    // �{�����e�B�A�A�z�����e�B�A��
    detailForm.volunteer.value     = myForm.volunteer.value;
    detailForm.volunteerName.value = myForm.volunteerName.value;

    // ���p�����
    detailForm.collectTicket.value = ( myForm.collectTicket.value != '0' ) ? myForm.collectTicket.value : '';

    // �������o��
    if ( myForm.billPrint ) {
        detailForm.billPrint.value = ( myForm.billPrint.value != '0' ) ? myForm.billPrint.value : '';
    } else {
        detailForm.billPrint.value = '';
    }

    // �ی��؋L���A�ی��ؔԍ��A�ی��Ҕԍ��A�Ј��ԍ�
    detailForm.isrSign.value     = myForm.isrSign.value;
    detailForm.isrNo.value       = myForm.isrNo.value;
    detailForm.isrManNo.value    = myForm.isrManNo.value;
    detailForm.empNo.value       = myForm.empNo.value;
    detailForm.introductor.value = myForm.introductor.value;

}

// ��ʂ����
function closeWindow() {
    opener.closePersonalDetailWindow();
}

// ��������
function initialize() {

    // ��{���A��f�t�����ł̕ێ��l��ݒ�
    getPersonalValue();
<%
    '�ǂݎ���p��
    If blnReadOnly Then

        '���ׂĂ̓��͗v�f���g�p�s�\�ɂ���
%>
        opener.top.disableElements( document.entryForm );

<%      '�{�^���̃N���A %>
        document.getElementById('saveButton').innerHTML  = '';
        document.getElementById('guideButton').innerHTML = '';
        document.getElementById('clearButton').innerHTML = '';
<%
    End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:initialize()">
<FORM NAME="entryForm" action="#">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��f�t�����</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3">
        <TR>
            <TD ID="saveButton"><A HREF="javascript:regist()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�"></A></TD>
            <TD><A HREF="javascript:closeWindow()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A></TD>
        </TR>
    </TABLE>
    <SPAN ID="errMsg"></SPAN>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
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
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR VALIGN="top">
            <TD>�Z���i����j</TD>
            <TD>�F</TD>
            <TD NOWRAP ID="zipCd0"></TD>
            <TD>&nbsp;&nbsp;</TD>
            <TD ID="address0"></TD>
        </TR>
        <TR VALIGN="top">
            <TD NOWRAP>�Z���i�Ζ���j</TD>
            <TD>�F</TD>
            <TD NOWRAP ID="zipCd1"></TD>
            <TD></TD>
            <TD ID="address1"></TD>
        </TR>
        <TR VALIGN="top">
            <TD NOWRAP>�Z���i���̑��j</TD>
            <TD>�F</TD>
            <TD NOWRAP ID="zipCd2"></TD>
            <TD></TD>
            <TD ID="address2"></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD>�{�����e�B�A</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="volunteer">
                    <OPTION VALUE="0">���p�Ȃ�
                    <OPTION VALUE="1">�ʖ�v
                    <OPTION VALUE="2">���v
                    <OPTION VALUE="3">�ʖ󁕉��v
                    <OPTION VALUE="4">�Ԉ֎q�v
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP>�{�����e�B�A��</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="volunteerName" SIZE="50" MAXLENGTH="25" VALUE=""></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>���p�����</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="collectTicket">
                    <OPTION VALUE="0">�����
                    <OPTION VALUE="1">�����
                </SELECT>
            </TD>
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
<%
        '�u�������o�́v�̕\������
        Do

            '�c�̃R�[�h���w�莞�͕\�����Ȃ�
            If strOrgCd1 = "" Or strOrgCd2 = "" Then
                Exit Do
            End If

            '�I�u�W�F�N�g�̃C���X�^���X�쐬
            Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

            '�c�̏���ǂ݁A�������A���я��{�l�Ƒ��敪���擾
            objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , , , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , , , , , , , , , , , , , , , , , , , strReptCslDiv

            '�I�u�W�F�N�g�̉��
            Set objOrganization = Nothing

            '����������w��Ȃ�Ε\�����Ȃ�
            If strBillCslDiv = "" And strReptCslDiv = "" Then
                Exit Do
            End If
%>
            <TR>
                <TD><FONT COLOR="red"><B>�������o��</B></FONT></TD>
                <TD>�F</TD>
                <TD>
                    <SELECT NAME="billPrint">
                        <OPTION VALUE="0">�w��Ȃ�
                        <OPTION VALUE="1">�{�l
                        <OPTION VALUE="2">�Ƒ�
                    </SELECT>
                    </SPAN>
                </TD>
            </TR>
<%
            Exit Do
        Loop
%>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>�ی��؋L��</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="isrSign" SIZE="28" MAXLENGTH="16" VALUE=""></TD>
        </TR>
        <TR>
            <TD>�ی��ؔԍ�</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="isrNo" SIZE="28" MAXLENGTH="16" VALUE=""></TD>
        </TR>
        <TR>
            <TD>�ی��Ҕԍ�</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="isrManNo" SIZE="28" MAXLENGTH="16" VALUE=""></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>�Ј��ԍ�</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="empNo" SIZE="20" MAXLENGTH="12" VALUE=""></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
<%
        '�Љ�Ҏw�莞
        If strIntroductor <> "" Then

            '�I�u�W�F�N�g�̃C���X�^���X�쐬
            Set objPerson = Server.CreateObject("HainsPerson.Person")

            '�l���ǂݍ���
            objPerson.SelectPerson_Lukes strIntroductor, strLastName, strFirstName

            '�I�u�W�F�N�g�̉��
            Set objPerson = Nothing

            '�����̌���
            strName = Trim(strLastName & "�@" & strFirstName)

        End If
%>
        <TR>
            <TD>�Љ�Җ�</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD ID="guideButton"><A HREF="javascript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" ALT="�l�����K�C�h��\�����܂�"></A></TD>
                        <TD ID="clearButton"><A HREF="javascript:clearPerInfo()"><IMG SRC="/webHains/images/delicon.gif" HEIGHT="21" WIDTH="21" ALT="�Љ�҂��N���A���܂�"></A></TD>
                        <TD NOWRAP><INPUT TYPE="hidden" NAME="introductor" VALUE="<%= strIntroductor %>"><SPAN ID="introductorName"><%= strName %></SPAN></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>�O���f��</TD>
            <TD>�F</TD>
<%
            '�O���f�������݂���ꍇ
            If strLastCslDate <> "" Then

                '�I�u�W�F�N�g�̃C���X�^���X�쐬
                Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
                <TD><%= objCommon.FormatString(CDate(strLastCslDate), "yyyy�Nm��d��") %></TD>
<%
                Set objCommon = Nothing

            End If
%>
        </TR>
    </TABLE>
</FORM>
</BODY>
</HTML>
