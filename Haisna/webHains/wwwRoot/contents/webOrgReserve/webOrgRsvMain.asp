<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web�c�̗\����o�^ (Ver1.0.0)
'      AUTHER  : 
'-----------------------------------------------------------------------------
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.3.11
'�S����  �FT.Takagi@RD
'�C�����e�Fweb�\���f�I�v�V�����̎擾���@�ύX

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objWebOrgRsv        'web�\����A�N�Z�X�p

'�����l
Dim dtmCslDate          '��f�N����
Dim lngWebNo            'webNo.
Dim dtmStrCslDate       '�J�n��f�N����
Dim dtmEndCslDate       '�I����f�N����
Dim strKey              '�����L�[
Dim dtmStrOpDate        '�J�n�����N����
Dim dtmEndOpDate        '�I�������N����
Dim strOrgCd1           '�c�̃R�[�h1
Dim strOrgCd2           '�c�̃R�[�h2
Dim lngOpMode           '�������[�h(1:�\�����Ō����A2:�\�񏈗����Ō���)
Dim lngRegFlg           '�{�o�^�t���O(0:�w��Ȃ��A1:���o�^�ҁA2:�ҏW�ςݎ�f��)
Dim lngOrder            '�o�͏�(1:��f�����A2:�lID��)
'#### 2010.10.28 SL-UI-Y0101-108 ADD START ####'
Dim lngMosFlg		'�\���敪(0:�w��Ȃ��A1:�V�K�A2:�L�����Z��)
'#### 2010.10.28 SL-UI-Y0101-108 ADD END ####'
Dim blnSaved            '�ۑ������t���O

Dim strRegFlg           '�{�o�^�t���O

Dim strURL              '�W�����v���URL

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
dtmCslDate    = CDate(Request("cslDate"))
lngWebNo      = CLng("0" & Request("webNo"))
dtmStrCslDate = CDate(Request("strCslDate"))
dtmEndCslDate = CDate(Request("endCslDate"))
strKey        = Request("key")
dtmStrOpDate  = CDate("0" & Request("strOpDate"))
dtmEndOpDate  = CDate("0" & Request("endOpDate"))
strOrgCd1     = Request("orgCd1")
strOrgCd2     = Request("orgCd2")
lngOpMode     = CLng("0" & Request("opMode"))
lngRegFlg     = CLng("0" & Request("regFlg"))
lngOrder      = CLng("0" & Request("order"))
'#### 2010.10.28 SL-UI-Y0101-108 ADD START ####'
'�\���敪�̓��͂��Ȃ����1:�V�K���f�t�H���g��
lngMosFlg      = IIf(Request("mousi") = "", 1, CLng("0" & Request("mousi")))
'#### 2010.10.28 SL-UI-Y0101-108 ADD END ####'
blnSaved      = (Request("saved") <> "")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

'web�\�����ǂ݁A��Ԃ��擾
If objWebOrgRsv.SelectWebOrgRsv(dtmCslDate, lngWebNo, strRegFlg) = False Then
    Err.Raise 1000, , "web�\���񂪑��݂��܂���B"
End If

'�I�u�W�F�N�g�̉��
Set objWebOrgRsv = Nothing

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>web�c�̗\����o�^</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// ���̓`�F�b�N
function checkValue() {

    var detailForm = detail.document.paramForm;
    var optForm    = opt.document.entryForm;

    for ( var ret = false; ; ) {

        // ��f�c�̂̕K�{�`�F�b�N
        if ( detailForm.orgCd1.value == '' || detailForm.orgCd2.value == '' ) {
            alert( '��f�c�̂��w�肵�ĉ������B' );
            break;
        }

        // ��f�敪�̕K�{�`�F�b�N
        if ( detailForm.cslDivCd.value == '' ) {
            alert( '��f�敪���w�肵�ĉ������B' );
            break;
        }

        // �_��p�^�[���̑��݃`�F�b�N
        if ( optForm == null ) {
            alert('���̎�f�����ɍ��v����_����͑��݂��܂���B');
            break;
        }

        if ( optForm.ctrPtCd.value == '' ) {
            alert('���̎�f�����ɍ��v����_����͑��݂��܂���B');
            break;
        }

        ret = true;
        break;
    }

    return ret;
}

// ��ʂ����
function closeWindow( exceptWindowCode ) {

    // �R�����g��ʂ����
    if ( exceptWindowCode != 1 ) {
        header.noteGuide_closeGuideNote();
    }

    // �l�����K�C�h��ʂ����
    if ( exceptWindowCode != 2 ) {
        detail.perGuide_closeGuidePersonal();
    }

    // �h�b�N�\�����݌l����ʂ����
    if ( exceptWindowCode != 3 ) {
        detail.closeEditPersonalWindow();
    }

    // �c�̌����K�C�h��ʂ����
    if ( exceptWindowCode != 4 ) {
        detail.orgGuide_closeGuideOrg();
    }

    // ��f�t�����ڍ׉�ʂ����
    if ( exceptWindowCode != 5 ) {
        personal.closePersonalDetailWindow();
    }

}

// �R�[�h�����̂̃N���X
function codeAndName( code, codeName ) {
    this.code     = code;
    this.codeName = codeName;
}

// �I�v�V�����R�[�h�̃J���}�`���ւ̕ϊ�
function convOptCd( objForm, arrOptCd, arrOptBranchNo ) {

    var selOptCd;   // �I�v�V�����R�[�h�E�}��
    var addFlg;     // �ǉ��t���O

    if ( !objForm ) return;
    if ( objForm.length == null ) return;

    // �S�G�������g������
    for ( var i = 0; i < objForm.length; i++ ) {

        // �^�C�v�𔻒f
        switch ( objForm.elements[ i ].type ) {

            case 'checkbox':    // �`�F�b�N�{�b�N�X�A���W�I�{�^���̏ꍇ
            case 'radio':

                // �I������Ă��Ȃ���Βǉ����Ȃ�
                if ( !objForm.elements[ i ].checked ) {
                    continue;
                }

                break;

            case 'hidden':      // �B���G�������g�̏ꍇ

                // �R�Ԗڂ̗v�f����f�v��
                selOptCd = objForm.elements[ i ].value.split(',');
                if ( selOptCd[ 2 ] != '1' ) {
                    continue;
                }

                break;

            default:
                continue;

        }

        // �ǉ����K�v�ł���΂���΃J���}�ŃR�[�h�Ǝ}�Ԃ𕪗����Ēǉ�
        selOptCd = objForm.elements[ i ].value.split(',');
        arrOptCd[ arrOptCd.length ] = selOptCd[ 0 ];
        arrOptBranchNo[ arrOptBranchNo.length ] = selOptCd[ 1 ];

    }

}

// �N��̕ҏW
function editAge( age, realAge ) {

    // �N��̕ҏW
    if ( age != null ) {
        detail.document.getElementById('perAge').innerHTML = ( age != '' ) ? '�i' + age.substring(0, age.indexOf('.')) + '�΁j' : '';
    }

    // ���N��̕ҏW
    if ( realAge != null ) {
        detail.document.getElementById('perRealAge').innerHTML = ( realAge != '' ) ? realAge + '��' : '';
    }

    // �N�����{����submit�p�����[�^�ێ��G�������g�ɕҏW
    if ( age != null ) {
        detail.document.paramForm.age.value = age;
    }

}

// ��f�敪�Z���N�V�����{�b�N�X�̕ҏW
function editCslDiv( cslDivInfo, selCslDivCd ) {

    // �Z���N�V�����{�b�N�X�̕ҏW
    editSelectionBox( detail.document.entryForm.cslDivCd, cslDivInfo, selCslDivCd );

    // hidden�l�̍X�V
    detail.document.paramForm.cslDivCd.value = detail.document.entryForm.cslDivCd.value;

}

// ���ʂ̕ҏW
function editGender( gender ) {

    // ���ʂ̕ҏW
    var genderName = '';
    switch ( gender ) {
        case '<%= GENDER_MALE %>':
            genderName = '�j��';
            break;
        case '<%= GENDER_FEMALE %>':
            genderName = '����';
        default:
    }

    return genderName;
}

// ���b�Z�[�W�̕ҏW
function editMessage( elem, message, isError ) {

    var html = '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">';
    html = html + '<TR>';
    html = html + '<TD HEIGHT="5"></TD>';
    html = html + '</TR>';

    // (�������W�b�N�ɂ��Ă�editMessage.inc�Ɠ��l)

    for ( var i = 0; i < message.length; i++ ) {

        html = html + '<TR>';

        if ( i == 0 ) {
            html = html + '<TD><IMG SRC="/webHains/images/' + ( isError ? 'ico_w' : 'ico_i' ) + '.gif" WIDTH="16" HEIGHT="16" ALT=""></TD>';
        } else {
            html = html + '<TD></TD>';
        }

        html = html + '<TD VALIGN="bottom"><SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:14px;">' + message[ i ] + '</SPAN></TD>';

        html = html + '</TR>';

    }

    html = html + '</TABLE>';

    elem.innerHTML = html;

}

// �����̕ҏW
function editName( lastName, firstName ) {

    // �����̌���
    var wkName = lastName;
    if ( firstName != '' ) {
        wkName = wkName + '�@' + firstName;
    }

    return wkName;

}

// �l���̕ҏW
function editPerson( perId, lastName, firstName, lastKName, firstKName, birth, age, realAge, gender ) {

    // �lID
    if ( perId != null ) {
        detail.document.getElementById('perPerId').innerHTML = ( perId != '' ) ? perId : '<%= PERID_FOR_NEW_PERSON %>';
    }

    // ����
    detail.document.getElementById('kanaName').innerHTML = editName( lastKName, firstKName );
    detail.document.getElementById('fullName').innerHTML = '<A HREF="javascript:callEditPersonWindow()">' + editName( lastName, firstName ) + '</A>';

    // ���N����
    if ( birth != null ) {
        detail.document.getElementById('perBirth').innerHTML = birth;
    }

    // ����
    if ( gender != null ) {
        detail.document.getElementById('perGender').innerHTML = editGender( gender );
    }

    // �N��̕ҏW
    editAge( age, realAge );

}

// �Z���N�V�����{�b�N�X�̕ҏW
function editSelectionBox( selectionElement, codeNameInfo, selectedCode, needEmptyRow ) {

    var index  = 0;
    var exists = false;

    // �R�[�h��񂪑��݂��Ȃ���ΏI��
    if ( !codeNameInfo ) {
        selectionElement.length = 0;
        return;
    }

    // �I�����ׂ��v�f�̑��݃`�F�b�N
    for ( var i = 0; i < codeNameInfo.length; i++ ) {
        if ( codeNameInfo[ i ].code == selectedCode ) {
            exists = true;
            break;
        }
    }

    // �v�f���̐ݒ�
    selectionElement.length = codeNameInfo.length + ( ( !exists || ( needEmptyRow != null ) ) ? 1 : 0 );

    // �܂��I�����ׂ��v�f�����݂��Ȃ��ꍇ�͋�s��ǉ�
    if ( !exists || ( needEmptyRow != null ) ) {
        selectionElement.options[ index ].value = '';
        selectionElement.options[ index ].text  = '';
        selectionElement.options[ index ].selected = true;
        index++;
    }

    // �v�f�̒ǉ��J�n
    for ( var i = 0; i < codeNameInfo.length; i++ ) {

        // �v�f�̒ǉ�
        selectionElement.options[ index ].value = codeNameInfo[ i ].code;
        selectionElement.options[ index ].text  = codeNameInfo[ i ].codeName;

        // �I�����ׂ��v�f�ł���ΑI����Ԃɂ���
        if ( codeNameInfo[ i ].code == selectedCode ) {
            selectionElement.options[ index ].selected = true;
        }

        index++;
    }

}

// ������̃o�C�g�������߂�
function getByte( stream ) {

    var count = 0;

    // �P�������G���R�[�h���o�C�g�������߂�
    for ( var i = 0; i < stream.length; i++ ) {
        var token = escape( stream.charAt( i ) );
        if ( token.length < 4 ) {
            count++;
        } else {
            count += 2;
        }
    }

    return count;
}

// ��{���ł̕ێ��l��ݒ�
function getPersonalValue() {

    var objForm   = personal.document.entryForm;
    var paramForm = detail.document.paramForm;

    // �\���
    objForm.rsvStatus.value = paramForm.rsvStatus.value;

    // �ۑ������
    objForm.prtOnSave[ paramForm.prtOnSave.value ].checked = true;

    // ����
    objForm.cardAddrDiv.value   = paramForm.cardAddrDiv.value;
    objForm.formAddrDiv.value   = paramForm.formAddrDiv.value;
    objForm.reportAddrDiv.value = paramForm.reportAddrDiv.value;
    setRadioValue( objForm.cardOutEng,   paramForm.cardOutEng.value   );
    setRadioValue( objForm.formOutEng,   paramForm.formOutEng.value   );
    setRadioValue( objForm.reportOutEng, paramForm.reportOutEng.value );

    // �f�@�����s
    objForm.issueCslTicket.value = paramForm.issueCslTicket.value;

}

// �I�v�V����������ʓǂݍ���
function replaceOptionFrame( ctrPtCd, optCd, optBranchNo ) {

    var detailForm = detail.document.paramForm;
    var optForm    = opt.document.entryForm;

    // URL�ҏW
    var url = '/webHains/contents/webOrgReserve/webOrgRsvOption.asp';
    url = url + '?perId='    + detailForm.perId.value;
    url = url + '&gender='   + detailForm.gender.value;
    url = url + '&birth='    + detailForm.birth.value;
    url = url + '&orgCd1='   + detailForm.orgCd1.value;
    url = url + '&orgCd2='   + detailForm.orgCd2.value;
    url = url + '&csCd='     + detailForm.csCd.value;
    url = url + '&cslDate='  + detailForm.cslDate.value;
    url = url + '&cslDivCd=' + detailForm.cslDivCd.value;
    url = url + '&stomac='   + detailForm.stomac.value;
    url = url + '&breast='   + detailForm.breast.value;
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD START #### %>
	url = url + '&csloptions=' + detailForm.csloptions.value;
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD END   #### %>
<%
    '�o�^�ς݂̏ꍇ�A�펞�ǂݎ���p�t���O�𑗂�
    If strRegFlg = REGFLG_REGIST Then
%>
        url = url + '&readOnly=1';
<%
    End If
%>
    // �����Z�b�g��ʂɑS�Z�b�g�\���t���O�̃G�������g�����݂���ꍇ
    if ( optForm != null ) {
        url = url + '&showAll=' + ( optForm.showAll.checked ? optForm.showAll.value : '' );
    }

    // �_��p�^�[���R�[�h�w�莞
    if ( ctrPtCd != null ) {
        url = url + '&ctrPtCd=' + ctrPtCd;
    }

    // �I�v�V�����R�[�h�w�莞
    if ( optCd != null && optBranchNo != null ) {
        url = url + '&optCd='  + optCd;
        url = url + '&optBNo=' + optBranchNo;
    }

    // �I�v�V����������ʂ̓ǂݍ���
    opt.location.replace( url );

}

// ���W�I�{�^���̒l�擾����
function getRadioValue( elem ) {

    var selectedValue = '';

    for ( var i = 0; i < elem.length; i++ ) {
        if ( elem[ i ].checked ) {
            selectedValue = elem[ i ].value;
            break;
        }
    }

    return selectedValue;
}

// �m�菈��
function regist( next ) {

    for ( ; ; ) {

        // �T�u��ʂ����
        closeWindow();

        // ���̓`�F�b�N
        if ( !checkValue() ) {
            break;
        }

        // �u���ցv�{�^���������͊m�F���b�Z�[�W�̕\��
        if ( next ) {
            if ( !confirm( '���̓��e��web�\�����o�^���܂��B��낵���ł����H') ) {
                break;
            }
        }

        // �����Z�b�g���̒l���X�V
        setOptionValue();

        // ��f�t�����̒l���X�V
        setPersonalValue();

        // �u�m��v�{�^���������́A�����ŕۑ���������Ԃ��������邽�߂�Cookie�l����������
        if ( !next ) {
            document.cookie = 'rsvDetailOnSaving=1';
        }

        // submit
        var detailForm = detail.document.paramForm;
        detailForm.save.value = '1';
        detailForm.next.value = ( next ? '1' : '' );
        detailForm.submit();

        break;
    }

}

// �����Z�b�g���̒l���X�V
function setOptionValue() {

    var detailForm = detail.document.paramForm;
    var objForm    = opt.document.entryForm;

    // �_��p�^�[���R�[�h
    detailForm.ctrPtCd.value = objForm.ctrPtCd.value;

    var arrOptCd       = new Array();   // �I�v�V�����R�[�h
    var arrOptBranchNo = new Array();   // �I�v�V�����}��

    // ���݂̑I���I�v�V�����l���擾
    convOptCd( opt.document.optList, arrOptCd, arrOptBranchNo );

    // �I�v�V�����R�[�h�E�}��
    detailForm.optCd.value  = arrOptCd;
    detailForm.optBNo.value = arrOptBranchNo;

}

// ��f�t�����̒l���X�V
function setPersonalValue() {

    var detailForm = detail.document.paramForm;
    var objForm    = personal.document.entryForm;

    // �\���
    detailForm.rsvStatus.value = objForm.rsvStatus.value;

    // �ۑ������
    detailForm.prtOnSave.value = getRadioValue( objForm.prtOnSave );

    // ����
    detailForm.cardAddrDiv.value   = objForm.cardAddrDiv.value;
    detailForm.formAddrDiv.value   = objForm.formAddrDiv.value;
    detailForm.reportAddrDiv.value = objForm.reportAddrDiv.value;
    detailForm.cardOutEng.value    = getRadioValue( objForm.cardOutEng   );
    detailForm.formOutEng.value    = getRadioValue( objForm.formOutEng   );
    detailForm.reportOutEng.value  = getRadioValue( objForm.reportOutEng );

    // �f�@�����s
    detailForm.issueCslTicket.value = objForm.issueCslTicket.value;

}

// ���W�I�{�^���̑I������
function setRadioValue( elem, selectedValue ) {
    for ( var i = 0; i < elem.length; i++ ) {
        if ( elem[ i ].value == selectedValue ) {
            elem[ i ].checked = true;
            break;
        }
    }
}

// ����
function showNext() {
    var detailForm = detail.document.paramForm;
    detailForm.save.value = '';
    detailForm.next.value = '1';
    detailForm.submit();
}

// �͂����������
function showPrintCardDialog( rsvNo, act, cardAddrDiv, cardOutEng ) {
    showPrintDialog( 0, act, rsvNo, cardAddrDiv, cardOutEng );
}

// ���t�ē��������
function showPrintFormDialog( rsvNo, act, formAddrDiv, formOutEng ) {
    showPrintDialog( 1, act, rsvNo, formAddrDiv, formOutEng );
}

// �������
function showPrintDialog( mode, act, rsvNo, addrDiv, outEng ) {

    // �������p�̉�ʂ��o��
    var url = '/webHains/contents/reserve/rsvPrintControl.asp';
    url = url + '?mode='    + mode;
    url = url + '&actMode=' + act;
    url = url + '&rsvNo='   + rsvNo;
    url = url + '&addrDiv=' + addrDiv;
    url = url + '&outEng='  + outEng;

// ��
    open( url );
}

// �w��t�H�[���̑S�G�������g���g�p�s��
function disableElements( objForm ) {

    if ( objForm ) {
        var elems = objForm.elements;
        for ( var i = 0; i < elems.length; i++ ) {
            elems[ i ].disabled = true;
        }
    }

}

//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="76,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
    '�i�r�o�[��ʂ�URL�ҏW
    strURL = "webOrgRsvNavi.asp"
    strURL = strURL & "?cslDate="    & dtmCslDate
    strURL = strURL & "&webNo="      & lngWebNo
    strURL = strURL & "&strCslDate=" & dtmStrCslDate
    strURL = strURL & "&endCslDate=" & dtmEndCslDate
    strURL = strURL & "&key="        & strKey
    strURL = strURL & "&strOpDate="  & IIf(dtmStrOpDate > 0, dtmStrOpDate, "")
    strURL = strURL & "&endOpDate="  & IIf(dtmEndOpDate > 0, dtmEndOpDate, "")
    strURL = strURL & "&orgcd1="     & strOrgCd1
    strURL = strURL & "&orgcd2="     & strOrgCd2
    strURL = strURL & "&opMode="     & lngOpMode
    strURL = strURL & "&regFlg="     & lngRegFlg
    strURL = strURL & "&order="      & lngOrder
    strURL = strURL & "&rsvRegFlg="  & strRegFlg
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
	strURL = strURL & "&mousi="     & lngMosFlg
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'
%>
    <FRAME SRC="<%= strURL %>" NAME="header">
    <FRAMESET COLS="500,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
        <FRAMESET ROWS="215,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
            '��{����ʂ�URL�ҏW
            strURL = "webOrgRsvDetail.asp"
            strURL = strURL & "?cslDate="    & dtmCslDate
            strURL = strURL & "&webNo="      & lngWebNo
            strURL = strURL & "&strCslDate=" & dtmStrCslDate
            strURL = strURL & "&endCslDate=" & dtmEndCslDate
            strURL = strURL & "&key="        & strKey
            strURL = strURL & "&strOpDate="  & IIf(dtmStrOpDate > 0, dtmStrOpDate, "")
            strURL = strURL & "&endOpDate="  & IIf(dtmEndOpDate > 0, dtmEndOpDate, "")
            strURL = strURL & "&orgcd1="     & strOrgCd1
            strURL = strURL & "&orgcd2="     & strOrgCd2
            strURL = strURL & "&opMode="     & lngOpMode
            strURL = strURL & "&regFlg="     & lngRegFlg
            strURL = strURL & "&order="      & lngOrder
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
			strURL = strURL & "&mousi="      & lngMosFlg
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

            If blnSaved Then
                strURL = strURL & "&saved=1"
            End If
%>
            <FRAME SRC="<%= strURL %>" NAME="detail">
            <FRAME SRC="" NAME="opt">
        </FRAMESET>
        <FRAMESET ROWS="215,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
            <FRAME SRC="" NAME="personal">
<%
            '�\�����ݏ���ʂ�URL�ҏW
            strURL = "webOrgRsvReservation.asp"
            strURL = strURL & "?cslDate=" & dtmCslDate
            strURL = strURL & "&webNo="   & lngWebNo
%>
            <FRAME SRC="<%= strURL %>" NAME="reservation">
        </FRAMESET>
    </FRAMESET>
</FRAMESET>
</HTML>
