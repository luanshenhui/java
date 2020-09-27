<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'        �\��g����(��������) (Ver0.0.1)
'        AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const FREECD_FRARSVINIT = "FRARSVINIT"      '�ėp�R�[�h(�\��g���������ݒ�p)
Const CONDITION_COUNT   = 4                 '���͏�����

Const MODE_NORMAL       = "0"    '�\��l���ċA�������[�h(�I�[�o���󂫂Ȃ��Ƃ��Ĕ���)
Const MODE_SAME_RSVGRP  = "1"    '�\��l���ċA�������[�h(�I�[�o���󂫂���Ƃ��Ĕ���)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objFree             '�ėp���A�N�Z�X�p
'Dim obj  '

'�����ݒ�
Dim strDayAfter         '�V�X�e�����t����̃X���C�h����
Dim lngDayAfter         '�V�X�e�����t����̃X���C�h����
Dim strMaxCount         '��x�ɗ\��\�Ȏ�f���̏����
Dim lngMaxCount         '��x�ɗ\��\�Ȏ�f���̏����

'��f��
Dim dtmCslDate          '��f�N����
Dim strCslYear          '��f�N
Dim strCslMonth         '��f��
Dim strCslDay           '��f��

'�c��
Dim strOrgCd1           '�c�̃R�[�h�P
Dim strOrgCd2           '�c�̃R�[�h�Q

Dim strCsCd             '�R�[�X�R�[�h
Dim strCslDivCd         '��f�敪�R�[�h

Dim strBirthStart       '���N�����i�N�j�J�n
Dim strBirthDefault     '���N�����i�N�j�����l
Dim lngStartValue       '�J�n�N
Dim lngEndValue         '�I���N

Dim strArrYear          '����N�̔z��
Dim strArrEraCode       '����(�R�[�h�\�L)�̔z��
Dim strArrEraName       '����(���{��\�L)�̔z��
Dim i                   '�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objFree   = Server.CreateObject("HainsFree.Free")

'�����l�̐ݒ�

'�����ݒ����ėp�e�[�u������擾
objFree.SelectFree 0, FREECD_FRARSVINIT, , , , strDayAfter, strMaxCount

Set objFree = Nothing

'�X���C�h�����̐ݒ�
If IsNumeric(strDayAfter) Then
    If CLng(strDayAfter) >= 0 Then
        lngDayAfter = CLng(strDayAfter)
    End If
End If

'�o�^�\�ő�l���̐ݒ�
lngMaxCount = 0
If IsNumeric(strMaxCount) Then
    If CLng(strMaxCount) >= 0 Then
        lngMaxCount = CLng(strMaxCount)
    End If
End If

'�����\����f�����V�X�e���N��������������X���C�h
dtmCslDate = DateAdd("d", lngDayAfter, Date())
strCslYear  = CStr(Year(dtmCslDate))
strCslMonth = CStr(Month(dtmCslDate))
strCslDay   = CStr(Day(dtmCslDate))

'�l��f�p�̒c�̃R�[�h�擾
objCommon.GetOrgCd ORGCD_KEY_PERSON, strOrgCd1, strOrgCd2

'�R�[�X�R�[�h�̏����l�́u�P���l�ԃh�b�N�v
strCsCd = "100"

'���i�ėp�e�[�u�����j

'��f�敪�R�[�h�̏����l�́u�w��Ȃ��v
strCslDivCd = "CSLDIV000"

'�a��^�O�쐬�̂��߂̏����l���擾
objCommon.SelectYearsRangeBirth strBirthStart, strBirthDefault

'�J�n�N�͏����l���g�p����
lngStartValue = Clng("0" & strBirthStart)

'�I���N�͌��ݔN���g�p����
lngEndValue = Year(Date())

'����A�a��N�̏����擾
objCommon.GetEraYearArray lngStartValue, lngEndValue, strArrYear, strArrEraCode, strArrEraName

Set objCommon = Nothing

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �a���SELECT�^�O����
'
' �����@�@ : (In)     strElementName  �G�������g��
'
' �߂�l�@ : SELECT�^�O
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditEraYearList(strElementName)

    Dim strHtml    'HTML������
    Dim i        '�C���f�b�N�X

    'SELECT�^�O�ҏW�J�n
    strHtml = "<SELECT NAME=""" & strElementName & """>"

    'OPTION�^�O�̕ҏW
    For i = 0 To UBound(strArrYear)

        '�^�O��ǉ�
        strHtml = strHtml & "<OPTION VALUE=""" & strArrYear(i) & """>" & strArrEraName(i) & "�N�i" & strArrYear(i) & "�j"

        '���ҏW�N�����N�����̏����l�Ɠ������ꍇ�͋󔒍s���쐬����
        If strArrYear(i) = CLng(strBirthDefault) Then
            strHtml = strHtml & "<OPTION VALUE="""" SELECTED>"
        End If

    Next

    'SELECT�^�O�ҏW�I��
    strHtml = strHtml & "</SELECT>"

    EditEraYearList = strHtml

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�\��g����</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<!-- #include virtual = "/webHains/includes/setInfo.inc"  -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/date.inc"     -->
<!--
var winNote;
var curYear, curMonth, curDay;            // ���݂̓��t
var curPerId, selPerIndex;                // ���݂̌l�h�c�Ƃ��̃C���f�b�N�X
var curOrgCd1, curOrgCd2, selOrgIndex;    // ���݂̒c�̃R�[�h�Ƃ��̃C���f�b�N�X
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���t�K�C�h�Ăяo��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function callCalGuide() {
    calGuide_showGuideCalendar( 'cslYear', 'cslMonth', 'cslDay', checkDateChanged );
}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f���ύX�`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function checkDateChanged() {

    var objYear  = dateForm.cslYear;
    var objMonth = dateForm.cslMonth;
    var objDay   = dateForm.cslDay;

    // �ޔ����Ă������t�Ɠ���ȏꍇ�͉������Ȃ�
    if ( objYear.value == curYear && objMonth.value == curMonth && objDay.value == curDay ) return;

    for ( var ret = false; ; ) {

        // ���t�`�F�b�N
        if ( !isDate( objYear.value, objMonth.value, objDay.value ) ) {
            alert('��f���̒l������������܂���B');
            break;
        }

        // ��f�����ߋ������`�F�b�N
        var sysDate = new Date();
        var date1 = sysDate.getFullYear() * 10000 + ( sysDate.getMonth() + 1 ) * 100 + sysDate.getDate();
        var date2 = parseInt(objYear.value) * 10000 + parseInt(objMonth.value) * 100 + parseInt(objDay.value);
        if ( date2 < date1 ) {
            alert('�ߋ��̓��t�͎w��ł��܂���B');
            break;
        }

        ret = true;
        break;
    }

    // �G���[���͕ύX�O�̒l�ɖ߂�
    if ( !ret ) {
        objYear.value  = curYear;
        objMonth.value = curMonth;
        objDay.value   = curDay;
        return;
    }

    // ���݂̓��t��ޔ�
    curYear  = objYear.value;
    curMonth = objMonth.value;
    curDay   = objDay.value;

    // ���ׂĂ̌��������ɑ΂��铮�I����
    for ( var i = 0; i < document.entryForm.length; i++ ) {
        conditionControlChanged( i );
    }

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��������
'
' �����@�@ : (In)     mode   �������[�h
' �@�@�@�@   (In)     index  �w�肳�ꂽ���������̃C���f�b�N�X
'
' �߂�l�@ :
'
'-------------------------------------------------------------------------------
%>
function search( index ) {

    var mode;                // �������[�h
    var strIndex, endIndex;    // �����Ώۃt�H�[���̊J�n�E�I���C���f�b�N�X
    var i, j;                // �C���f�b�N�X
    var ret;                // �֐��߂�l

    // �������[�h�̌���
    if ( document.dateForm.nearly.checked ) {
        mode = '<%= MODE_SAME_RSVGRP %>';
    } else {
        mode = '<%= MODE_NORMAL %>';
    }

    // �S������������������ꍇ�A�w��C���f�b�N�X�݂̂���������ꍇ���ƂɃC���f�b�N�X�͈͂��`
    if ( index == null ) {
        strIndex = 0;
        endIndex = document.entryForm.length - 1;
    } else {
        strIndex = index;
        endIndex = index;
    }

    // ���������̏W�����擾
    var entries = new Array();
    if ( !getEntries( entries, strIndex, endIndex ) ) {
        return;
    }

    // ���������W���̊֘A�`�F�b�N
    if ( !checkEntries( mode, entries ) ) {
        return;
    }

    // �p�����[�^�ݒ�
    setParam( mode, entries );

    // �J�����_�[������ʌĂяo��
    callCalendar();

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���������̏W�����擾
'
' �����@�@ : (In)     entries   ���������̏W��
' �@�@�@�@   (In)     strIndex  �����Ώۃt�H�[���̊J�n�C���f�b�N�X
' �@�@�@�@   (In)     endIndex  �����Ώۃt�H�[���̏I���C���f�b�N�X
'
' �߂�l�@ : true   ����I��
' �@�@�@�@   false  �G���[����
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function getEntries( entries, strIndex, endIndex ) {

    var msg = '�����������m���ύX����Ă��Ȃ��B�ύX���e��L���ɂ���ɂ͊m��{�^�����N���b�N���ĉ������B';

    var entry;    // �����������N���X

// ## 2004.10.01 Add By T.Takagi@FSIT �Z�b�g���̂����݂��Ȃ��ꍇ�̓J�����_�[���������Ȃ�
    var existsNoSetCondition = false;    // �Z�b�g�Ȃ����������̗L��
// ## 2004.10.01 Add End

    // ���������t�H�[��������
    for ( var i = strIndex, ret = true; i <= endIndex; i++ ) {

        // �����������̎擾
        entry = new top.entryInfo( i );

        // �`�F�b�N
        switch ( checkEntry( i, entry ) ) {

            // ���݂̓��͓��e�ƈقȂ�ꍇ
            case -1:

                // �C���f�b�N�X�̎w���Ԃɂ�郁�b�Z�[�W����
                if ( strIndex != endIndex ) {
                    alert( ( i + 1 ) + '�Ԗڂ�' + msg );
                } else {
                    alert( msg );
                }

                ret = false;
                break;

            // ������������Ă��Ȃ��ꍇ
            case 0:
                break;

            // �����������Ă���Βǉ�
            default:
                entries[ entries.length ] = entry;

// ## 2004.10.01 Add By T.Takagi@FSIT �Z�b�g���̂����݂��Ȃ��ꍇ�̓J�����_�[���������Ȃ�
                var objForm = document.entryForm[ i ];
                var existsOption = false;

                // �S�G�������g����I�v�V�����̃G�������g�����݂��邩������
                for ( var j = 0; j < objForm.elements.length; j++ ) {
                    if ( objForm.elements[ j ].name.indexOf( 'opt' ) == 0 ) {
                        existsOption = true;
                        break;
                    }
                }

                // �I�v�V�����̃G�������g�����݂��Ȃ��ꍇ�̓t���O����
                if ( !existsOption ) {
                    existsNoSetCondition = true;
                }
// ## 2004.10.01 Add End
        }

    }

// ## 2004.10.01 Add By T.Takagi@FSIT �Z�b�g���̂����݂��Ȃ��ꍇ�̓J�����_�[���������Ȃ�
    if ( existsNoSetCondition ) {
        alert( '�Z�b�g�̑��݂��Ȃ���������������܂��B�J�����_�[�����͂ł��܂���B' );
        return false;
    }
// ## 2004.10.01 Add End

    // ���͓��e����ł��قȂ�Ό��������̏W���͕Ԃ��Ȃ�
    if ( !ret ) {

        entries.length = 0;

    } else {

        // �����\�ȏ��������݂��Ȃ��ꍇ
        if ( entries.length == 0 ) {
            alert('�����\�ȏ��������݂��܂���B');
            ret = false;
        }

    }

    return ret;

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���������̃`�F�b�N
'
' �����@�@ : (In)     index  ���������̃C���f�b�N�X
' �@�@�@�@   (In)     entry  �����������N���X
'
' �߂�l�@ : 1   �G���[�Ȃ�
' �@�@�@�@   0   ������������������Ă��Ȃ�
' �@�@�@�@   -1  �����������m���A�ύX����Ă���
'
'-------------------------------------------------------------------------------
%>
function checkEntry( index, entry ) {

    // �����������̌���
    for ( var ret = -1; ; ) {

        // ���������������Ă��Ȃ���ΏI��
        if ( !entry.conditionFilled() ) {
            ret = 0;
            break;
        }

        // �l�w��ł���΃`�F�b�N�I��
        if ( entry.perId != '' ) {
            ret = 1;
            break;
        }

        // �l�w��łȂ��ꍇ�A���݂̓��͓��e�Ɗm����e�Ƃ̔�r���s��

        // ���݂̓��͓��e���`�F�b�N���A�G���[�Ȃ���e���ύX����Ă���ɑ��Ȃ�Ȃ�
        if ( checkCondition( index ) <= 0 ) {
            break;
        }

        // ����ł���ΐl���E���ʁE���N�����E�N��̓��e��r���s��
        var objForm = document.entryForm[ index ];
        var manCnt  = parseInt(objForm.entManCnt.value, 10);
        var gender  = getGender( index );
        var birth   = formatDate( objForm.bYear.value, objForm.bMonth.value, objForm.bDay.value );
        var age     = parseInt(objForm.entAge.value, 10);

        // �l���E���ʁE���N�����̂����ꂩ���ύX����Ă���ΏI��
        if ( manCnt != entry.manCnt || gender != entry.gender || birth != entry.birth ) {
            break;
        }

        // �N��ڎw�莞�͔N����e���ύX����Ă���ΏI��
        if ( birth == '' ) {
            if ( age != entry.age ) {
                break;
            }
        }

        ret = 1;
        break;
    }

    return ret;
}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���������W���̊֘A�`�F�b�N
'
' �����@�@ : (In)     mode     �������[�h
' �@�@�@�@   (In)     entries  �����������̏W��
'
' �߂�l�@ : true   �G���[�Ȃ�
' �@�@�@�@   false  �G���[����
'
' ���l�@�@ : �����ł͌l�̏d���A�\��ő匏���A�����Q�Ō�������ꍇ�̌Q�w����`�F�b�N
'
'-------------------------------------------------------------------------------
%>
function checkEntries( mode, entries ) {

    var rsvGrpCount   = 0;
    var noRsvGrpCount = 0;
    var maxCount      = <%= lngMaxCount %>;
    var rsvCount      = 0;

    // ���������̏W��������
    for ( var i = 0, ret = true; i < entries.length; i++ ) {

        // �\��Q�w��A���w������ꂼ��J�E���g
        if ( entries[ i ].rsvGrpCd != '' ) {
            rsvGrpCount++;
        } else {
            noRsvGrpCount++;
        }

        // �l�h�c���w�莞�͗\��l���̃J�E���g�̂ݍs��
        if ( entries[ i ].perId == '' ) {
            rsvCount = rsvCount + parseInt(entries[ i ].manCnt, 10);
            continue;
        }

        // �ȉ��͌l�h�c�w�莞

        // �\��l���̃J�E���g
        rsvCount++;

        // �l�h�c�̏d���`�F�b�N
        for ( var j = 0; j < i; j++ ) {
            if ( entries[ j ].perId == entries[ i ].perId ) {
                alert('����l�������w�肳��Ă��܂��B�����ł��܂���B');
                ret = false;
            }
        }

        // �d���G���[���͌������I��
        if ( !ret ) break;

    }

    // �G���[���Ȃ����
    while ( ret ) {

        // �����Q�Ō�������ꍇ�A�\��Q�w��A���w��̍��݂͋����Ȃ�
        if ( mode == '<%= MODE_SAME_RSVGRP %>' ) {
            if ( rsvGrpCount > 0 && noRsvGrpCount > 0 ) {
                alert('���߂����Ԙg�Ō�������ꍇ�A�\��Q�͑S�Đݒ肷�邩�A�������͑S�Ė��w���ԂŌ������Ă��������B');
                ret = false;
                break;
            }
        }

        // ��������ݒ肳��Ă��Ȃ���΃`�F�b�N�I��
        if ( maxCount == 0 )  break;

        // ������`�F�b�N
        if ( rsvCount > maxCount ) {
            alert('���݂̏����ł͈�x�ɓo�^�\�ȗ\��̏�������I�[�o�[���܂��B�����ł��܂���B');
            ret = false;
        }

        break;
    }

    return ret;

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �p�����[�^�ݒ�
'
' �����@�@ : (In)     mode     �������[�h
' �@�@�@�@ : (In)     entries  ���������N���X�̏W��
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function setParam( mode, entries ) {

    var perId = '';
    var manCnt = '';
    var gender = '';
    var birth = '';
    var age = '';
    var romeName = '';
    var orgCd1 = '';
    var orgCd2 = '';
    var cslDivCd = '';
    var csCd = '';
    var rsvGrpCd = '';
    var ctrPtCd = '';
    var rsvNo = '';
    var optCd = '';
    var optBranchNo = '';

    var sep = '';

    // �z��ւ̕ҏW
    for ( var i = 0; i < entries.length; i++ ) {
        sep = ( i > 0 ) ? '\x01' : '';
        perId       = perId       + sep + entries[ i ].perId;
        manCnt      = manCnt      + sep + entries[ i ].manCnt;
        gender      = gender      + sep + entries[ i ].gender;
        birth       = birth       + sep + entries[ i ].birth;
        age         = age         + sep + entries[ i ].age;
        romeName    = romeName    + sep + entries[ i ].romeName;
        orgCd1      = orgCd1      + sep + entries[ i ].orgCd1;
        orgCd2      = orgCd2      + sep + entries[ i ].orgCd2;
        cslDivCd    = cslDivCd    + sep + entries[ i ].cslDivCd;
        csCd        = csCd        + sep + entries[ i ].csCd;
        rsvGrpCd    = rsvGrpCd    + sep + entries[ i ].rsvGrpCd;
        ctrPtCd     = ctrPtCd     + sep + entries[ i ].ctrPtCd;
        rsvNo       = rsvNo       + sep + entries[ i ].rsvNo;
        optCd       = optCd       + sep + entries[ i ].optCd;
        optBranchNo = optBranchNo + sep + entries[ i ].optBranchNo;
    }

    // �G�������g�ւ̕ҏW
    var paraForm = document.paramForm;
    paraForm.mode.value        = mode;
    paraForm.cslYear.value     = curYear;
    paraForm.cslMonth.value    = curMonth;
    paraForm.perId.value       = perId;
    paraForm.manCnt.value      = manCnt;
    paraForm.gender.value      = gender;
    paraForm.birth.value       = birth;
    paraForm.age.value         = age;
    paraForm.romeName.value    = romeName;
    paraForm.orgCd1.value      = orgCd1;
    paraForm.orgCd2.value      = orgCd2;
    paraForm.cslDivCd.value    = cslDivCd;
    paraForm.csCd.value        = csCd;
    paraForm.rsvGrpCd.value    = rsvGrpCd;
    paraForm.ctrPtCd.value     = ctrPtCd;
    paraForm.rsvNo.value       = rsvNo;
    paraForm.optCd.value       = optCd;
    paraForm.optBranchNo.value = optBranchNo;

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �J�����_�[������ʌĂяo��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function callCalendar() {

    var opened = false;    // ��ʂ��J����Ă��邩

    // ��΂ɏd�����Ȃ��E�B���h�E�������ݎ��Ԃ���쐬
    var d = new Date();
    var windowName = 'W' + d.getHours() + d.getMinutes() + d.getSeconds() + d.getMilliseconds()

    // ��̃E�B���h�E���J��
    open('', windowName, 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no,width=700,height=500');

    // �^�[�Q�b�g���w�肵��submit
    document.paramForm.target = windowName;
    document.paramForm.submit();

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l�����K�C�h�Ăяo��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function callPersonGuide( index ) {

    // ���݂̌l�h�c�Ƃ��̃C���f�b�N�X�Ƃ�ޔ�
    curPerId = document.entryForm[ index ].perId.value;
    selPerIndex = index;

    // �ҏW�p�̊֐���`
    perGuide_CalledFunction = checkPerChanged;

    // �K�C�h��ʂ�\��
    perGuide_openWindow( '/webHains/contents/guide/gdePersonal.asp?mode=1' );
//    perGuide_openWindow( '/webHains/contents/guide/gdePersonal.asp?mode=1&defPerId=' + curPerId );

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l�I�����̉�ʐ��䏈��
'
' �����@�@ : (In)     perInfo  �l���N���X
'
' �߂�l�@ :
'
' ���l�@�@ : �l���N���X�̏ڍׂ�gdeSelectPerson.asp���Q��
'
'-------------------------------------------------------------------------------
%>
function checkPerChanged( perInfo ) {
    conditionControlPerson( selPerIndex, perInfo );
}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l�N���A���̉�ʐ��䏈��
'
' �����@�@ : (In)     index  ���������̃C���f�b�N�X
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function clearPerson( index ) {

    // �l���w�肳��Ă���ꍇ�̂ݐ���
    if ( document.entryForm[ index ].perId.value != '' ) {
        conditionControlPerson( index );
    }

}

<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �l���̓K�p����ь��������̓��I����
'
' �����@�@ : (In)     index    ���������̃C���f�b�N�X
' �@�@�@�@   (In)     perInfo  �l���N���X
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function conditionControlPerson( index, perInfo ) {

    // ���݂̒c�́E�R�[�X�E��f�敪���擾
    var objForm = document.entryForm[ index ];
    var orgCd1   = objForm.orgCd1.value;
    var orgCd2   = objForm.orgCd2.value;
    var csCd     = objForm.csCd.value;
    var cslDivCd = objForm.cslDivCd.value;

    var rsvNo    = objForm.rsvNo;

    // ����v�ۂ̃`�F�b�N
    for ( ; ; ) {

        // �l��񂪃N���A���ꂽ�ꍇ�͗v����
        if ( perInfo == null ) break;

        // �l���ύX����Ă���ꍇ�͗v����
        if ( perInfo.perId != curPerId ) break;

        // �l���ύX����Ă��Ȃ��ꍇ

        // �c�́E�R�[�X�E��f�敪���w�肳��Ă��Ȃ��ꍇ�A���䏈���͍s��Ȃ�(�K���R�����Ɏw�肳���̂łP���ڂ̂݃`�F�b�N)
        if ( perInfo.lastOrgCd1 == null ) return;

        // �c�́E�R�[�X�E��f�敪�E�p�����ׂ��\��ԍ����ύX����Ă��Ȃ��ꍇ�A���䏈���͍s��Ȃ�
        if ( perInfo.lastOrgCd1 == orgCd1 && perInfo.lastOrgCd2 == orgCd2 && perInfo.csCd == csCd && perInfo.cslDivCd == cslDivCd && perInfo.rsvNo == rsvNo.value ) return;

        break;
    }

    // �l�w��̗D�搫�ɂ��A�m����Ƃ��Ă̐l���E���ʁE���N�����E�N��̓N���A
    objForm.manCnt.value = '';
    objForm.gender.value = '';
    objForm.birth.value  = '';
    objForm.age.value    = '';

    // �l�h�c�̐ݒ�
    var perId = '';
    if ( perInfo != null ) {
        perId = perInfo.perId;
    }

    // �l���I�����ꂽ�ꍇ
    if ( perInfo != null ) {

        // ��f�����I�����ꂽ�ꍇ
        if ( perInfo.lastOrgCd1 != null ) {

            // �c�́E�R�[�X�E��f�敪���w�肳��Ă���ꍇ�͂��̒l��K�p
            orgCd1   = perInfo.lastOrgCd1;
            orgCd2   = perInfo.lastOrgCd2;
            csCd     = perInfo.csCd;
            cslDivCd = perInfo.cslDivCd;

            // �p�����ׂ��\��ԍ���K�p
            rsvNo.value = perInfo.rsvNo;

        // ��f�𖢑I���̏ꍇ
        } else {

            // �p�����ׂ��\��ԍ��ɂ͉����Z�b�g���Ȃ�
            rsvNo.value = '';

        }

    // �l���N���A���ꂽ�ꍇ
    } else {

        // �p�����ׂ��\��ԍ����N���A
        rsvNo.value = '';

    }
    // ���������ɑ΂��铮�I����
    conditionControl( index, perId, orgCd1, orgCd2, csCd, cslDivCd, objForm.rsvGrpCd.value, objForm.ctrPtCd.value );

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f���ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function callDayliListWindow( perId ) {

    if ( perId != '' ) {
        open('/webHains/contents/common/dailyList.asp?navi=1&key=ID:' + perId + '&sortKey=12&sortType=1');
    }

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �v�w�ŃZ�b�g
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function compSetControl() {

    // �P�Ԗڂ̌l�h�c�ɑ΂��铯���Ҍl�h�c�œ��I����
    var perId =  document.entryForm[ 0 ].compPerId.value;

    var objForm = document.entryForm[ 1 ];

    // ���݂̌l�ƈقȂ�ꍇ�A�܂��͌p�����ׂ��\��ԍ����N���A����
    if ( perId != objForm.perId.value ) {
        objForm.rsvNo.value = '';
    }

    conditionControl( 1, perId, objForm.orgCd1.value, objForm.orgCd2.value, objForm.csCd.value, objForm.cslDivCd.value, objForm.rsvGrpCd.value, objForm.ctrPtCd.value );

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ʁA�N��ڎw�莞�̐���
'
' �����@�@ : (In)     index  ���������̃C���f�b�N�X
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function conditionControlApply( index ) {

    var objForm = document.entryForm[ index ];

    // ���łɌl�h�c�����肵�Ă���Ȃ炻�����D�悷�邽�߁A�������Ȃ�
    if ( objForm.perId.value != '' ) {
        return;
    }

    // ���������̃`�F�b�N
    switch ( checkCondition( index ) ) {
        case 0:
            alert('������������͂��ĉ������B');
            return;
        case -1:
            alert('�l������͂��ĉ������B');
            return;
        case -2:
            alert('�l���ɂ͂P�ȏ�̒l����͂��ĉ������B');
            return;
        case -3:
            alert('���ʂ�I�����ĉ������B');
            return;
        case -4:
            alert('���N�����������͔N�����͂��ĉ������B');
            return;
        case -5:
            alert('���N�����̒l������������܂���B');
            return;
        case -6:
            alert('�N�����͂��ĉ������B');
            return;
        case -7:
            alert('�N��̒l������������܂���B');
            return;
        case -8:
            alert('���[�}�����͔��p�œ��͂��ĉ������B');
            return;
        default:
    }

    // ����ł���ΐl���E���ʁE���N�����E�N����m����Ƃ��Ċi�[
    objForm.entManCnt.value = parseInt(objForm.entManCnt.value, 10);
    objForm.manCnt.value    = objForm.entManCnt.value;
    objForm.gender.value    = getGender( index );
    objForm.birth.value     = formatDate( objForm.bYear.value, objForm.bMonth.value, objForm.bDay.value );
    objForm.age.value       = objForm.birth.value == '' ? parseInt(objForm.entAge.value, 10) : '';

    // ���������ɑ΂��铮�I����
    conditionControl( index, '', objForm.orgCd1.value, objForm.orgCd2.value, objForm.csCd.value, objForm.cslDivCd.value, objForm.rsvGrpCd.value, objForm.ctrPtCd.value );

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��������(�l���E���ʁE���N�����E�N��)�̃`�F�b�N
'
' �����@�@ : (In)     index  ���������̃C���f�b�N�X
'
' �߂�l�@ : 1   �G���[�Ȃ�
' �@�@�@�@   0   �������͂���Ă��Ȃ�
' �@�@�@�@   -1  �l��������
' �@�@�@�@   -2  �l���̒l���s��
' �@�@�@�@   -3  ���ʖ��I��
' �@�@�@�@   -4  ���N�����E���ʂ��Ƃ��ɓ��͂���Ă��Ȃ�
' �@�@�@�@   -5  ���N�����̒l���s��
' �@�@�@�@   -6  �N�����
' �@�@�@�@   -7  �N��̒l���s��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function checkCondition( index ) {

    var objForm  = document.entryForm[ index ];
    var manCnt   = objForm.entManCnt.value;
    var gender   = getGender( index );
    var bYear    = objForm.bYear.value;
    var bMonth   = objForm.bMonth.value;
    var bDay     = objForm.bDay.value;
    var age      = objForm.entAge.value;
    var romeName = objForm.romeName.value;

    var birthEntried = ( bYear != '' || bMonth != '' || bDay != '' );
    var ret;

    for ( ; ; ) {

        // �������͂���Ă��Ȃ��ꍇ
        if ( manCnt == '' && gender == '' && ( !birthEntried ) && age == '' ) {
            ret = 0;
            break;
        }

        // �l���`�F�b�N

        // �K�{�`�F�b�N
        if ( manCnt == '' ) {
            ret = -1;
            break;
        }

        // ���l�`�F�b�N
        if ( !manCnt.match('^[0-9]+$') ) {
            ret = -2;
            break;
        }

        // ���l�`�F�b�N
        if ( parseInt(manCnt, 10) <= 0 ) {
            ret = -2;
            break;
        }

        // ���ʃ`�F�b�N
        if ( gender == '' ) {
            ret = -3;
            break;
        }

        // ���N�����E���ʂ̂���������͂���Ă��Ȃ��ꍇ
        if ( ( !birthEntried ) && age == '' ) {
            ret = -4;
            break;
        }

        // ���N�E���E���̂����ꂩ�����͂���Ă���ꍇ�͂������D��
        if ( birthEntried ) {

            // �K�{�`�F�b�N
            if ( bYear == '' || bMonth == '' || bDay == '' ) {
                ret = -5;
                break;
            }

            // ���t�`�F�b�N
            if ( !isDate( bYear, bMonth, bDay ) ) {
                ret = -5;
                break;
            }

            ret = 1;
            break;
        }

        // �N��`�F�b�N

        // �K�{�`�F�b�N
        if ( age == '' ) {
            ret = -6;
            break;
        }

        // ���l�`�F�b�N
        if ( !age.match('^[0-9]+$') ) {
            ret = -7;
            break;
        }

        for ( var ret2 = true, i = 0; i < romeName.length; i++ ) {
            if ( escape(romeName.charAt(i)).length >= 4 ) {
                ret2 = false;
                break;
            }
        }

        if ( !ret2 ) {
            ret = -8;
            break;
        }

        ret = 1;
        break;
    }

    return ret;
}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �c�̃K�C�h�Ăяo��
'
' �����@�@ : (In)     index  ���������̃C���f�b�N�X
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function callOrgGuide( index ) {

    var objForm = document.entryForm[ index ];

    // ���݂̒c�̃R�[�h�Ƃ��̃C���f�b�N�X�Ƃ�ޔ�
    curOrgCd1 = objForm.orgCd1.value;
    curOrgCd2 = objForm.orgCd2.value;
    selOrgIndex = index;

    // �c�̃K�C�h�Ăяo��
    orgGuide_showGuideOrg( objForm.orgCd1, objForm.orgCd2, null, null, null, checkOrgChanged );

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �c�̕ύX�`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function checkOrgChanged() {

    var objForm = document.entryForm[ selOrgIndex ];

    // �c�̂��ύX���ꂽ�ꍇ�͒c�̏���ҏW���A�����䏈����
    if ( objForm.orgCd1.value != curOrgCd1 || objForm.orgCd2.value != curOrgCd2 ) {
        conditionControlChanged( selOrgIndex );
    }

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �G�������g�l�ύX���̉�ʐ��䏈��
'
' �����@�@ : (In)     index  ���������̃C���f�b�N�X
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function conditionControlChanged( index ) {

    var objForm = document.entryForm[ index ];

    // ���������ɑ΂��铮�I����
    conditionControl( index, objForm.perId.value, objForm.orgCd1.value, objForm.orgCd2.value, objForm.csCd.value, objForm.cslDivCd.value, objForm.rsvGrpCd.value, objForm.ctrPtCd.value );

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���������̓��I���䏈��
'
' �����@�@ : (In)     index     ���������̃C���f�b�N�X
' �@�@�@�@ : (In)     perId     �l�h�c
' �@�@�@�@ : (In)     orgCd1    �c�̃R�[�h�P
' �@�@�@�@ : (In)     orgCd2    �c�̃R�[�h�Q
' �@�@�@�@ : (In)     csCd      �R�[�X�R�[�h
' �@�@�@�@ : (In)     cslDivCd  ��f�敪�R�[�h
' �@�@�@�@ : (In)     rsvGrpCd  �\��Q�R�[�h
' �@�@�@�@ : (In)     ctrPtCd   �_��p�^�[���R�[�h
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function conditionControl( index, perId, orgCd1, orgCd2, csCd, cslDivCd, rsvGrpCd, ctrPtCd ) {

    // ���������N���X�̃C���X�^���X�쐬
    var ent = new top.entryInfo( index );
    // URL�̕ҏW
    var url = '/webHains/contents/frameReserve/fraRsvControl.asp';
    url = url + '?cslDate='     + curYear + '/' + curMonth + '/' + curDay;
    url = url + '&condIndex='   + index;
    url = url + '&perId='       + perId;
    url = url + '&gender='      + ent.gender;
    url = url + '&birth='       + ent.birth;
    url = url + '&age='         + ent.age;
    url = url + '&orgCd1='      + orgCd1;
    url = url + '&orgCd2='      + orgCd2;
    url = url + '&csCd='        + csCd;
    url = url + '&cslDivCd='    + cslDivCd;
    url = url + '&rsvGrpCd='    + rsvGrpCd;
    url = url + '&ctrPtCd='     + ctrPtCd;
    url = url + '&optCd='       + ent.optCd;
    url = url + '&optBranchNo=' + ent.optBranchNo;

    // �t���[���̍X�V
    top.frames[ 'ctrl' + index ].location.replace( url );

}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ʒl�̎擾
'
' �����@�@ : (In)     index  ���������̃C���f�b�N�X
'
' �߂�l�@ : 1     �j��
' �@�@�@�@   2     ����
' �@�@�@�@   �Ȃ�  ���ʖ��I��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function getGender( index ) {

    var objGender = document.entryForm[ index ].elements('selGender');
    for ( var i = 0, ret = ''; i < objGender.length; i++ ) {
        if ( objGender[ i ].checked ) {
            ret = objGender[ i ].value;
            break;
        }
    }

    return ret;
}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\��l���ꗗ��ʂ��J��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function showCapacityList() {


    var url = '/webHains/contents/maintenance/capacity/mntCapacityList.asp';
    url = url + '?cslYear='  + document.dateForm.cslYear.value;
    url = url + '&cslMonth=' + document.dateForm.cslMonth.value;
    url = url + '&cslDay='   + document.dateForm.cslDay.value;
// ## 2004.02.14 Mod By H.Ishihara@FSIT
//    url = url + '&mode='     + 'all';
    url = url + '&mode='     + 'disp';
// ## 2004.02.14 Mod End
    open( url );

}

/** �R�����g��ʃ|�b�v�A�b�v�ŕ\�� **/
function showComment(index){

    var url = document.entryForm[ index ].hiddenUrl.value;
    var opened = false;    // ��ʂ��J����Ă��邩

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winNote != null ) {
        if ( !winNote.closed ) {
            opened = true;
        }
    }

    if ( opened ) {
        winNote.focus();
        winNote.location.replace( url );
    } else {
        winNote = window.open(url, '', 'width=800,height=660,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �e��K�C�h��ʂ����
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
%>
function closeWindow() {

    calGuide_closeGuideCalendar();
    perGuide_closeGuidePersonal();
    orgGuide_closeGuideOrg();
    closeSetInfoWindow();
   
    if ( winNote ) {
        if ( !winNote.closed ) {
            winNote.close();
        }
    }
}

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0px 0 0 25px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="dateForm" ACTION="" STYLE="margin: 0px;">
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR>
            <TD NOWRAP HEIGHT="40">��f���F</TD>
            <TD><A HREF="javascript:callCalGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\�����܂�"></A></TD>
            <TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, strCslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("cslMonth", 1, 12, strCslMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("cslDay", 1, 31, strCslDay, False) %></TD>
            <TD>��</TD>
            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD>
            <TD><A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONCLICK="javascript:return confirm('��ʂ��N���A���܂��B��낵���ł����H')"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�����\����������܂�"></A></TD>
            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD>
            <TD><A HREF="javascript:showCapacityList()"><IMG SRC="/webHains/images/rsvStat.gif" WIDTH="77" HEIGHT="24" ALT="�\��󋵂�\�����܂�"></A></TD>
<!--
            <TD><A HREF="javascript:search('<%= MODE_NORMAL %>')"><IMG SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
            <TD NOWRAP><A HREF="javascript:search('<%= MODE_SAME_RSVGRP %>')">�����Q�Ō���</A></TD>
-->
            <% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
                <TD><A HREF="javascript:search()"><IMG SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
                <TD><INPUT TYPE="checkbox" NAME="nearly" CHECKED></TD>
                <TD NOWRAP>���߂����Ԙg�Ō���</TD>
            <% End If %>
        </TR>
    </TABLE>
</FORM>
<%
'���͏��������̏������͗���ҏW
For i = 0 To CONDITION_COUNT - 1
%>
<FORM NAME="entryForm" ACTION="" STYLE="margin: 0px;">
    <HR>
    <INPUT TYPE="hidden" NAME="perId"     VALUE="">
    <INPUT TYPE="hidden" NAME="compPerId" VALUE="">
    <INPUT TYPE="hidden" NAME="manCnt"    VALUE="">
    <INPUT TYPE="hidden" NAME="gender"    VALUE="">
    <INPUT TYPE="hidden" NAME="birth"     VALUE="">
    <INPUT TYPE="hidden" NAME="age"       VALUE="">
    <INPUT TYPE="hidden" NAME="ctrPtCd"   VALUE="">
    <INPUT TYPE="hidden" NAME="orgCd1"    VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2"    VALUE="<%= strOrgCd2 %>">
    <INPUT TYPE="hidden" NAME="rsvNo"     VALUE="">
    <INPUT TYPE="hidden" NAME="hiddenUrl" VALUE="">
<%
    '�Q�Ԗڂ̏����̂݁u�v�w�ŃZ�b�g�v�@�\��L���ɂ�����
%>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1"<%= iif(i = 1, " WIDTH=""800""", "") %>>
        <TR>
            <TD WIDTH="70" NOWRAP>�l��</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:callPersonGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\�����܂�"></A></TD>
            <TD><A HREF="javascript:clearPerson(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD ID="perId<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP><B ID="perName<%= i %>"></B><FONT ID="perKName<%= i %>" COLOR="#999999"></FONT></TD>
            <TD>&nbsp;</TD>
            <TD ID="birth<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD ID="age<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD ID="gender<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD ID="showSet<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD ID="showComment<%= i %>" NOWRAP></TD>
<%
            '�Q�Ԗڂ̏����̂݁u�v�w�ŃZ�b�g�v�@�\��L���ɂ�����
            If i = 1 Then
%>
                <TD ID="compSet" WIDTH="100%" ALIGN="right" NOWRAP></TD>
<%
            End If
%>

        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR>
            <TD WIDTH="70"></TD>
            <TD><FONT COLOR="#ffffff">�F</FONT></TD>
            <TD BGCOLOR="#dcdcdc">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
                                <TR>
                                    <TD NOWRAP>�l���F</TD>
                                    <TD><INPUT TYPE="text" name="entManCnt" SIZE="3" MAXLENGTH="2" VALUE="" STYLE="ime-mode:disabled;"></TD>
                                    <TD>�l</TD>
                                    <TD WIDTH="100%" ALIGN="right" NOWRAP>����</TD>
                                </TR>
                            </TABLE>
                        </TD>
                        <TD>�F</TD>
                        <TD COLSPAN="8">
                            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                                <TR>
                                    <TD><INPUT TYPE="radio" NAME="selGender" VALUE="1"></TD>
                                    <TD>�j</TD>
                                    <TD><INPUT TYPE="radio" NAME="selGender" VALUE="2"></TD>
                                    <TD>��</TD>
                                </TR>
                            </TABLE>
                        </TD>
                        <TD WIDTH="300" ROWSPAN="3" ALIGN="right" VALIGN="bottom"><A HREF="javascript:conditionControlApply(<%= i %>)"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̓��͓��e�Ŋm�肷��"></A></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP>���N�����������͔N��</TD>
                        <TD>�F</TD>
                        <TD><%= EditEraYearList("bYear") %></TD>
                        <TD>�N</TD>
                        <TD><%= EditNumberList("bMonth", 1, 12, Empty, True) %></TD>
                        <TD>��</TD>
                        <TD><%= EditNumberList("bDay", 1, 31, Empty, True) %></TD>
                        <TD>��</TD>
                        <TD><INPUT TYPE="text" NAME="entAge" SIZE="4" MAXLENGTH="3" VALUE="" STYLE="ime-mode:disabled;"></TD>
                        <TD>��</TD>
                    </TR>
                    <TR>
                        <TD NOWRAP>���[�}����</TD>
                        <TD>�F</TD>
                        <TD COLSPAN="8"><INPUT TYPE="text" NAME="romeName" SIZE="36" MAXLENGTH="60" VALUE="" STYLE="ime-mode:disabled;"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR>
            <TD WIDTH="70" NOWRAP>�c�̖�</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:callOrgGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\�����܂�"></A></TD>
            <TD ID="dspOrgCd<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP><B ID="orgName<%= i %>"></B><FONT ID="orgKName<%= i %>" COLOR="#999999"></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR>
            <TD WIDTH="70" NOWRAP>��f�敪</TD>
            <TD>�F</TD>
            <TD>
                <SELECT NAME="cslDivCd" STYLE="width:80;" ONCHANGE="javascript:conditionControlChanged(<%= i %>)">
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD>�R�[�X</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                    <TR>
                        <TD>
                            <SELECT NAME="csCd" STYLE="width:170;" ONCHANGE="javascript:conditionControlChanged(<%= i %>)">
                            </SELECT>
                        </TD>
                        <TD NOWRAP>���Ԙg�F</TD>
                        <TD>
                            <%''## 2015.12.15 �� ����uOPCF�Ή��̈׏C��  ######################%>
                            <!--SELECT NAME="rsvGrpCd" STYLE="width:115;"-->
                            <SELECT NAME="rsvGrpCd" STYLE="width:160;">
                            </SELECT>
                        </TD>
                        <TD>&nbsp;</TD>
                        <TD ID="refCtr<%= i %>" NOWRAP></TD>
                        <TD>&nbsp;</TD>
                        <TD ID="search<%= i %>" NOWRAP></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD></TD><TD></TD>
            <TD ID="optTable<%= i %>"></TD>
        </TR>
    </TABLE>
</FORM>
<%
Next
%>
<FORM NAME="paramForm" ACTION="fraRsvCalendar.asp" METHOD="post">
    <INPUT TYPE="hidden" NAME="mode">
    <INPUT TYPE="hidden" NAME="cslYear">
    <INPUT TYPE="hidden" NAME="cslMonth">
    <INPUT TYPE="hidden" NAME="perId">
    <INPUT TYPE="hidden" NAME="manCnt">
    <INPUT TYPE="hidden" NAME="gender">
    <INPUT TYPE="hidden" NAME="birth">
    <INPUT TYPE="hidden" NAME="age">
    <INPUT TYPE="hidden" NAME="romeName">
    <INPUT TYPE="hidden" NAME="orgCd1">
    <INPUT TYPE="hidden" NAME="orgCd2">
    <INPUT TYPE="hidden" NAME="cslDivCd">
    <INPUT TYPE="hidden" NAME="csCd">
    <INPUT TYPE="hidden" NAME="rsvGrpCd">
    <INPUT TYPE="hidden" NAME="ctrPtCd">
    <INPUT TYPE="hidden" NAME="rsvNo">
    <INPUT TYPE="hidden" NAME="optCd">
    <INPUT TYPE="hidden" NAME="optBranchNo">
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
// ���݂̓��t��ޔ�
curYear  = document.dateForm.cslYear.value;
curMonth = document.dateForm.cslMonth.value;
curDay   = document.dateForm.cslDay.value;

// �C�x���g�n���h���̐ݒ�
document.dateForm.cslYear.onchange  = checkDateChanged;
document.dateForm.cslMonth.onchange = checkDateChanged;
document.dateForm.cslDay.onchange   = checkDateChanged;

// ���ׂĂ̌��������ɑ΂��铮�I����
for ( var i = 0; i < <%= CONDITION_COUNT %>; i++ ) {
    conditionControl( i, '', '<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strCsCd %>', '<%= strCslDivCd %>', '', '' );
}
//-->
</SCRIPT>
</BODY>
</HTML>
