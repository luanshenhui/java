<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      �t�H���[�A�b�v���� (Ver0.0.1)
'      AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon               '���ʃN���X
Dim objHainsUser            '���[�U���A�N�Z�X�p
Dim objConsult              '��f���A�N�Z�X�p
Dim objOrg                  '�c�̏��A�N�Z�X�p
Dim objPerson               '�l���A�N�Z�X�p
Dim objFollow               '�t�H���[�A�b�v�A�N�Z�X�p

Dim strMode                 '�������[�h(�����F"search"�A�}��:"insert"�A�X�V:"update")
Dim strAction               '�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strMessage              '�G���[���b�Z�[�W

Dim strKey                  '�����L�[
Dim strArrKey               '�����L�[(�󔒂ŕ�����̃L�[�j
Dim strStartCslDate         '����������f�N�����i�J�n�j
Dim strStartYear            '����������f�N�i�J�n�j
Dim strStartMonth           '����������f���i�J�n�j
Dim strStartDay             '����������f���i�J�n�j
Dim strEndCslDate           '����������f�N�����i�I���j
Dim strEndYear              '����������f�N�i�I���j
Dim strEndMonth             '����������f���i�I���j
Dim strEndDay               '����������f���i�I���j

Dim strPerId
Dim strPerName
Dim strLastName             '����������
Dim strFirstName            '����������
Dim strItemCd               '����������������

Dim strAddUser              '�o�^���[�U
Dim strAddUsername          '�o�^���[�U��

Dim vntItemCd               '�t�H���[�Ώی������ڃR�[�h
Dim vntItemName             '�t�H���[�Ώی������ږ���

'### 2016.09.13 �� �u2:�{�@�v���u2:�{�@�E���f�B���[�J�X�v�ɕύX #########################################################
Dim strEquipStat            '�񎟌����敪("":���ׂāA"0":�񎟌����ꏊ����A"1":���Z���^�[�A"2":�{�@�E���f�B���[�J�X�A"3":���@�A"9":�ΏۊO)
Dim strConfirmStat          '���ʏ��F���("":���ׂāA"0":�����F�A"1":���F�ς�)

Dim vntRsvNo                '�\��ԍ�
Dim vntCslDate              '��f��
Dim vntDayId                '����ID
Dim vntPerId                '�lID
Dim vntPerKName             '�J�i����
Dim vntPerName              '����
Dim vntAge                  '�N��
Dim vntGender               '����
Dim vntBirth                '���N����
Dim vntJudClassCd           '���蕪�ރR�[�h
Dim vntJudClassName         '���蕪�ޖ�
Dim vntJudCd                '����R�[�h�i�t�H���[�o�^�����茋�ʁj
Dim vntRslJudCd             '����R�[�h�i�J�����g���茋�ʁj
Dim vntResultDispMode       '�������ʕ\�����[�h
Dim vntCsCd                 '�R�[�X�R�[�h
Dim vntEquipDiv             '�񎟌������{�敪
Dim vntStatusCd             '�X�e�[�^�X
Dim vntReqConfirmDate       '���ʏ��F��
Dim vntReqConfirmUser       '���ʏ��F��
Dim vntPrtSeq               '�˗�������
Dim vntFileName             '�˗���t�@�C����
Dim vntDocJud               '�����
Dim vntDocGf                '�㕔�����Ǔ�������
Dim vntDocCf                '�咰��������
Dim vntPrtDate              '�˗���쐬����
Dim vntPrtUser              '�˗���쐬��
Dim vntAddUser              '�t�H���[�A�b�v�����o�^��

'### 2016.01.21 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ###
Dim vntDocGyne              '�w�l�Ȑf�@��
Dim vntDocGyneJud           '�w�l�Ȕ����
'### 2016.01.21 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ###

Dim vntGFFlg                '���GF��f�t���O
Dim vntCFFlg                '���GF��f�t���O
Dim vntSeq                  'SEQ

Dim lngItemCount            '�t�H���[�Ώی������ڐ�
Dim lngAllCount             '������
Dim lngRsvAllCount          '�d���\��Ȃ�����
Dim lngGetCount             '����
Dim i                       '�J�E���^
Dim j
Dim lngItemListCount        '�������ڃJ�E���^

Dim lngStartPos             '�\���J�n�ʒu
Dim lngPageMaxLine          '�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()     '�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName() '�P�y�[�W�\���l�`�w�s���̔z��
Dim strArrMessage           '�G���[���b�Z�[�W

Dim lngArrSendMode()        '�������m�F��Ԃ̔z��
Dim strArrSendModeName()    '�������m�F��Ԗ��̔z��

Dim Ret                     '�֐��߂�l
Dim strURL                  '�W�����v���URL

'��ʕ\������p��������
Dim strBeforeRsvNo          '�O�s�̗\��ԍ�

Dim strWebCslDate           '��f��
Dim strWebDayId             '����ID
Dim strWebPerId             '�lID
Dim strWebPerName           '�J�i�����E����
Dim strWebAge               '�N��
Dim strWebGender            '����
Dim strWebBirth             '���N����
Dim strWebJudClassName      '���蕪�ޖ�
Dim strWebJudCd             '����R�[�h�i�t�H���[�o�^�����茋�ʁj
Dim strWebRslJudCd          '����R�[�h�i�J�����g���茋�ʁj
Dim strWebEquipDiv          '�񎟌������{�敪
Dim strWebEquipDivName      '�񎟌������{�敪�i���́j
Dim strWebStatusCd          '�X�e�[�^�X
Dim strWebStatusName        '�X�e�[�^�X�i���́j
Dim strWebPrtSeq            '�˗�������
Dim strWebFileName          '�˗���t�@�C����
Dim strWebAddUser           '�o�^��
Dim strWebDocJud            '�����
Dim strWebDocGf             '�㕔�����Ǔ�������
Dim strWebDocCf             '�咰��������
Dim strWebPrtDate           '�˗���쐬����
Dim strWebPrtUser           '�˗���쐬��
Dim strWebRsvNo             '�\��ԍ�

'### 2016.01.21 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ###
Dim strWebDocGyne           '�w�l�Ȑf�@��
Dim strWebDocGyneJud        '�w�l�Ȕ����
'### 2016.01.21 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ###

'���X�g�w�i�F����p
Dim strBgColor

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPerson       = Server.CreateObject("HainsPerson.Person")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'�����l�̎擾
strMode             = Request("mode")
strAction           = Request("action")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear          = Request("endYear")
strEndMonth         = Request("endMonth")
strEndDay           = Request("endDay")
strPerId            = Request("perId")
strItemCd           = Request("itemCd")

strEquipStat        = Request("equipStat")
strConfirmStat      = Request("confirmStat")

strAddUser          = Request("adduser")

lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

vntRsvNo            = ConvIStringToArray(Request("arrRsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("arrJudClassCd"))
vntEquipDiv         = ConvIStringToArray(Request("arrEquipDiv"))
vntJudCd            = ConvIStringToArray(Request("arrJudCd"))
vntRslJudCd         = ConvIStringToArray(Request("arrRslJudCd"))


'�f�t�H���g�̓V�X�e���N������K�p����
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
    strStartYear    = CStr(Year(Now))
    strStartMonth   = CStr(Month(Now))
    strStartDay     = CStr(Day(Now))
End If

If strAddUser <> "" Then
    objHainsUser.SelectHainsUser strAddUser, strAddUserName
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos )
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine )

Call CreatePageMaxLineInfo()

Do
    '�ۑ��{�^���N���b�N��
    If strAction = "save"  Then
        
        '�t�H���[�̕ۑ�
        If strMessage = ""  Then
            '�X�V�Ώۃf�[�^�����݂���Ƃ��̂ݔ��茋�ʕۑ�
            Ret = objFollow.InsertFollow_Info(vntRsvNo, vntJudClassCd, vntEquipDiv, vntRslJudCd, _
                                              Session.Contents("userId"))
            If Ret = True Then
                strAction = "saveend"
                strArrMessage = Array("�ۑ����������܂����B")
            Else
                strArrMessage = Array("�ۑ��Ɏ��s���܂����B")
            End If
        End If
    End If
    
    '�t�H���[�Ώی������ځi���蕪�ށj���擾
    lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName )

    '�����{�^���N���b�N
    If strAction <> "" Then

        '��f��(��)�̓��t�`�F�b�N
        If strStartYear <> "" Or strStartMonth <> "" Or strStartDay <> "" Then
            If Not IsDate(strStartYear & "/" & strStartMonth & "/" & strStartDay) Then
                strArrMessage = Array("��f���̎w��Ɍ�肪����܂��B")
                Exit Do
            End If
        End If

        '��f��(��)�̓��t�`�F�b�N
        If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then
            If Not IsDate(strEndYear & "/" & strEndMonth & "/" & strEndDay) Then
                strArrMessage = Array("��f���̎w��Ɍ�肪����܂��B")
                Exit Do
            End If
            strEndCslDate   = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)
        Else
            strEndCslDate = strStartCslDate
        End If

        '�����J�n�I����f���̕ҏW
        strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)

        '��f���͈́i�P�N�ȓ��j�`�F�b�N
'        If strEndCslDate - strStartCslDate > 365 Then
'            strArrMessage = Array("��f���͈͂͂P�N�ȓ����w�肵�ĉ������B")
'            Exit Do
'        End If
        If strEndCslDate - strStartCslDate > 120 Then
            strArrMessage = Array("��f���͈͂�120���ȓ��Ŏw�肵�ĉ������B")
            Exit Do
        End If


        '�S�����擾����
'        lngAllCount = objFollow.SelectTargetFollowList( strStartCslDate, strEndCslDate, strPerId, _
'                                                        strItemCd, strEquipStat, strConfirmStat, _
'                                                        lngPageMaxLine, lngStartPos, _
'                                                        vntRsvNo, vntCsldate, _
'                                                        vntDayId, vntPerId, _
'                                                        vntPerKName, vntPerName, _
'                                                        vntAge, vntGender, _
'                                                        vntBirth, vntJudCd, _
'                                                        vntRslJudCd, vntJudClassName, _
'                                                        vntJudClassCd, vntResultDispMode, _
'                                                        vntCsCd, vntEquipDiv, vntStatusCd, _
'                                                        vntReqConfirmDate, vntReqConfirmUser, _
'                                                        vntPrtSeq, vntFileName, vntPrtDate, vntPrtUser, _
'                                                        vntDocJud, vntDocGf, _
'                                                        vntDocCf, False )

'### 2016.01.23 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ######################################################

'        lngAllCount = objFollow.SelectTargetFollowList( strStartCslDate, strEndCslDate, strPerId, _
'                                                        strItemCd, strEquipStat, strConfirmStat, strAddUser, _
'                                                        lngPageMaxLine, lngStartPos, _
'                                                        vntRsvNo, vntCsldate, _
'                                                        vntDayId, vntPerId, _
'                                                        vntPerKName, vntPerName, _
'                                                        vntAge, vntGender, _
'                                                        vntBirth, vntJudCd, _
'                                                        vntRslJudCd, vntJudClassName, _
'                                                        vntJudClassCd, vntResultDispMode, _
'                                                        vntCsCd, vntEquipDiv, vntStatusCd, _
'                                                        vntReqConfirmDate, vntReqConfirmUser, _
'                                                        vntPrtSeq, vntFileName, vntPrtDate, vntPrtUser, _
'                                                        vntAddUser, vntDocJud, vntDocGf, vntDocCf, _
'                                                        False )

        lngAllCount = objFollow.SelectTargetFollowList( strStartCslDate, strEndCslDate, strPerId, _
                                                        strItemCd, strEquipStat, strConfirmStat, strAddUser, _
                                                        lngPageMaxLine, lngStartPos, _
                                                        vntRsvNo, vntCsldate, _
                                                        vntDayId, vntPerId, _
                                                        vntPerKName, vntPerName, _
                                                        vntAge, vntGender, _
                                                        vntBirth, vntJudCd, _
                                                        vntRslJudCd, vntJudClassName, _
                                                        vntJudClassCd, vntResultDispMode, _
                                                        vntCsCd, vntEquipDiv, vntStatusCd, _
                                                        vntReqConfirmDate, vntReqConfirmUser, _
                                                        vntPrtSeq, vntFileName, vntPrtDate, vntPrtUser, _
                                                        vntAddUser, vntDocJud, vntDocGf, vntDocCf, _
                                                        vntDocGyne, vntDocGyneJud, _
                                                        False )

'### 2016.01.23 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ######################################################

        '�lID�̎w�肪����ꍇ�A���̎擾
        If strPerId <> "" Then
            ObjPerson.SelectPerson_lukes strPerId, strLastName, strFirstName 
            strPerName = strLastName & "�@" & strFirstName
        Else
            strPerName = ""
        End If 

    End If

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �P�y�[�W�\���l�`�w�s�̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()


    Redim Preserve lngArrPageMaxLine(4)
    Redim Preserve strArrPageMaxLineName(4)

    Redim Preserve lngArrFollowMode(2)
    Redim Preserve strArrFollowModeName(2)

    lngArrPageMaxLine(0) = 10:strArrPageMaxLineName(0) = "10�s����"
    lngArrPageMaxLine(1) = 20:strArrPageMaxLineName(1) = "20�s����"
    lngArrPageMaxLine(2) = 50:strArrPageMaxLineName(2) = "50�s����"
    lngArrPageMaxLine(3) = 100:strArrPageMaxLineName(3) = "100�s����"
    lngArrPageMaxLine(4) = 999:strArrPageMaxLineName(4) = "���ׂ�"

End Sub



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�t�H���[�A�b�v����</TITLE>
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
    '### �ۑ�������e��ʂ��ŐV���ŕ\�����A�����̉�ʂ����
    If strAction = "saveend"  Then
%>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
    document.entryFollowInfo.action.value = ""
//-->
</SCRIPT>
<%
    End If
%>
<SCRIPT TYPE="text/javascript">
<!--
<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->
    var winGuideFollow;     //�t�H���[�A�b�v��ʃn���h��
    var winMenResult;       // �h�b�N���ʎQ�ƃE�B���h�E�n���h��
    var winRslFol;          // �t�H���[���ʓo�^�E�B���h�E�n���h��

    // ���[�U�[�K�C�h�Ăяo��
    function callGuideUsr() {

        usrGuide_CalledFunction = SetAddUser;

        // ���[�U�[�K�C�h�\��
        showGuideUsr( );

    }

    // ���[�U�[�Z�b�g
    function SetAddUser() {

        document.entryFollowInfo.adduser.value = usrGuide_UserCd;
        document.entryFollowInfo.addusername.value = usrGuide_UserName;
        document.getElementById('username').innerHTML = usrGuide_UserName;

    }

    // ���[�U�[�w��N���A
    function clearAddUser() {

        document.entryFollowInfo.adduser.value = '';
        document.entryFollowInfo.addusername.value = '';
        document.getElementById('username').innerHTML = '';

    }

    //�������ʉ�ʌĂяo��
    function callMenResult( lngRsvNo, strGrpCd, strCsCd, classgrpno ) {

        var url;            // URL������
        var opened = false; // ��ʂ����łɊJ����Ă��邩


        // ���łɃK�C�h���J����Ă��邩�`�F�b�N
        if ( winMenResult != null ) {
            if ( !winMenResult.closed ) {
                opened = true;
            }
        }

        url = '/WebHains/contents/interview/MenResult.asp?grpno=' + classgrpno;
        url = url + '&winmode=1';
        url = url + '&rsvno=' + lngRsvNo;
        url = url + '&grpcd=' + strGrpCd;
        url = url + '&cscd=' + strCsCd;

        // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winMenResult.focus();
            winMenResult.location.replace( url );
        } else {
            winMenResult = window.open( url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }

    }


    function showFollowRsl(rsvNo, judClassCd, judClassName, judCd) {

        var opened = false; // ��ʂ��J����Ă��邩
        var url;            // URL������
        var myForm = document.entryFollowInfo;

        // ���łɉ�ʂ��J����Ă��邩�`�F�b�N
        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                opened = true;
            }
        }

        // �t�H���[���ʓo�^��ʌĂяo��
        url = 'followRslEdit.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd;

        // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winRslFol.focus();
            winRslFol.location.replace(url);
        } else {
            winRslFol = window.open(url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }
    }

    /** �t�H���[�A�b�v���ҏW��ʌĂяo�� **/
    function showFollowInfo(rsvNo, judClassCd) {

        var opened = false; // ��ʂ��J����Ă��邩
        var url;            // URL������
        var myForm = document.entryFollowInfo;

        // ���łɉ�ʂ��J����Ă��邩�`�F�b�N
        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                opened = true;
            }
        }

        // �t�H���[���ʓo�^��ʌĂяo��
        url = 'followInfoEdit.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd;

        // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winRslFol.focus();
            winRslFol.location.replace(url);
        } else {
            winRslFol = window.open(url, '', 'width=1000,height=750,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }
    }


    function showRequestEdit(rsvNo, judClassCd) {

        var opened = false; // ��ʂ��J����Ă��邩
        var url;            // URL������
        var myForm = document.entryFollowInfo;

        // ���łɉ�ʂ��J����Ă��邩�`�F�b�N
        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                opened = true;
            }
        }

        // �t�H���[���ʓo�^��ʌĂяo��
        url = 'followReqEdit.asp?rsvno='+rsvNo+'&judClassCd=' + judClassCd;

        // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winRslFol.focus();
            winRslFol.location.replace(url);
        } else {
            winRslFol = window.open(url, '', 'width=1000,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }
    }

    // �`�F�b�N���ꂽ(���W�I�{�^��)�񎟌����{�݋敪�̒l����
    function setRadio(index, selObj) {

        var myForm = document.entryFollowInfo;

        if ( myForm.arrEquipDiv.length != null ) {
            myForm.arrEquipDiv[index].value = selObj.value;
        } else {
            myForm.arrEquipDiv.value = selObj.value;
        }

    }


    // �{�^���N���b�N
    function submitForm(act) {

        with ( document.entryFollowInfo ) {
            if (act == "search" ) {
                startPos.value = 1
            } else if (act == "save" ) {
                if ( !confirm('���̓��e�ŕۑ����܂��B��낵���ł����H') ) return;
            }
            action.value = act;
            submit();
        }
        return false;
    }

    // �{�^���N���b�N
    function replaceForm() {

        with ( document.entryFollowInfo ) {
            action.value = "search";
            submit();
        }
        return false;
    }


    // �K�C�h��ʂ�\��
    function follow_openWindow( url ) {

        var opened = false; // ��ʂ��J����Ă��邩

        //var dialogWidth = 1000, dialogHeight = 600;
        var dialogWidth = 1200, dialogHeight = 600;
        var dialogTop, dialogLeft;

        // ���łɃK�C�h���J����Ă��邩�`�F�b�N
        if ( winGuideFollow ) {
            if ( !winGuideFollow.closed ) {
                opened = true;
            }
        }

        // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
        dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
        dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

        // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winGuideFollow.focus();
            winGuideFollow.location.replace( url );
        } else {
            winGuideFollow = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
        }

    }

    // �A�����[�h���̏���
    function closeGuideWindow() {

        //���t�K�C�h�����
        calGuide_closeGuideCalendar();

//        if ( winGuideFollow != null ) {
//            if ( !winGuideFollow.closed ) {
//                winGuideFollow.close();
//            }
//        }
        if ( winMenResult != null ) {
            if ( !winMenResult.closed ) {
                winMenResult.close();
            }
        }
//        if ( winRslFol != null ) {
//            if ( !winRslFol.closed ) {
//                winRslFol.close();
//            }
//        }

//        winGuideFollow = null;
//        winMenResult = null;
        winRslFol = null;

        closeGuideDoc();
        winGuideUsr = null;

        return false;
    }
//-->
</SCRIPT>
<style type="text/css">
	td.flwtab { background-color:#ffffff }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryFollowInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
    <INPUT TYPE="hidden" NAME="action" VALUE=""> 
    <INPUT TYPE="hidden" NAME="startPos" VALUE="<% = lngStartPos %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v����</FONT></B></TD>
    </TR>
</TABLE>
<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="60">��f��</TD>
        <TD WIDTH="10">�F</TD>
        <TD>
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0" /></A></TD>
                    <TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
                    <TD>&nbsp;�N&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
                    <TD>&nbsp;���`&nbsp;</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" BORDER="0" ALT="���t�K�C�h��\��" /></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" BORDER="0" ALT="�ݒ���t���N���A"></A></TD>
                    <TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
                    <TD>&nbsp;�N&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
                    <TD>&nbsp;��</TD>
                    <TD></TD>
                </TR>
            </TABLE>
        </TD>
        <TD ALIGN="right">
            <%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %>
        </TD>
        <TD WIDTH="170" ALIGN="right">
            <A HREF="javascript:submitForm('search')"><IMG SRC="../../images/b_search.gif" ALT="���̏����Ō���" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <% '2010.01.12 �����Ǘ� �ǉ� by ��
                If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
            <A HREF="javascript:submitForm('save')"><IMG SRC="../../images/save.gif" ALT="�t�H���[�ۑ�" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <% End If %>
        </TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="60">��������</TD>
        <TD WIDTH="10">�F</TD>
        <TD WIDTH="140"><%= EditDropDownListFromArray("itemCd", vntItemCd, vntItemName, strItemCd, NON_SELECTED_ADD) %></TD>
        <TD WIDTH="110" NOWRAP>�񎟌����{�݋敪</TD>
        <TD WIDTH="10">�F</TD>
        <TD WIDTH="170">
            <SELECT NAME="equipStat">
                <OPTION VALUE=""  <%= IIf(strEquipStat = "",  "SELECTED", "") %>>
                <OPTION VALUE="0" <%= IIf(strEquipStat = "0", "SELECTED", "") %>>�񎟌����ꏊ����
                <OPTION VALUE="1" <%= IIf(strEquipStat = "1", "SELECTED", "") %>>���Z���^�[
                <%'### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###%>
                <OPTION VALUE="2" <%= IIf(strEquipStat = "2", "SELECTED", "") %>>�{�@�E���f�B���[�J�X
                <OPTION VALUE="3" <%= IIf(strEquipStat = "3", "SELECTED", "") %>>���@
                <OPTION VALUE="9" <%= IIf(strEquipStat = "9", "SELECTED", "") %>>�ΏۊO
                <OPTION VALUE="999" <%= IIf(strEquipStat = "999", "SELECTED", "") %>>���o�^
            </SELECT>
        </TD>
        <TD WIDTH="90" NOWRAP>���ʏ��F���</TD>
        <TD WIDTH="10">�F</TD>
        <TD WIDTH="*" ALIGN="LEFT">
            <SELECT NAME="confirmStat">
                <OPTION VALUE=""  <%= IIf(strConfirmStat = "",  "SELECTED", "") %>>
                <OPTION VALUE="0" <%= IIf(strConfirmStat = "0", "SELECTED", "") %>>�����F
                <OPTION VALUE="1" <%= IIf(strConfirmStat = "1", "SELECTED", "") %>>���F�ς�
            </SELECT>
        </TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD NOWRAP WIDTH="60">�o�^��</TD>
        <TD NOWRAP WIDTH="10">�F</TD>
        <TD NOWRAP WIDTH="*" ALIGN="LEFT">
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><A HREF="javascript:callGuideUsr()"><IMG SRC="/webHains/images/question.gif" ALT="���[�U�K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD><A HREF="javascript:clearAddUser()"><IMG SRC="/webHains/images/delicon.gif" ALT="���[�U�w��N���A" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD WIDTH="5"></TD>
                    <TD>
                        <INPUT TYPE="hidden" NAME="adduser"     VALUE="<%= strAddUser %>">
                        <INPUT TYPE="hidden" NAME="addusername" VALUE="<%= strAddUserName %>">
                        <SPAN ID="username"><%= strAddUserName %></SPAN>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD NOWRAP WIDTH="60">�lID</TD>
        <TD NOWRAP WIDTH="10">�F</TD>
        <TD NOWRAP WIDTH="*" ALIGN="LEFT">
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryFollowInfo.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD><A HREF="javascript:perGuide_clearPerInfo(document.entryFollowInfo.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></A></TD>
                    <TD WIDTH="5"></TD>
                    <TD>
                        <INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
                        <INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
                        <SPAN ID="perName"><%= strPerName %></SPAN>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<BR>

<p>
���t�H���[�Ώی�������:
<%
        '## �ėp�}�X�^�[�ɓo�^����Ă���t�H���[�Ώی��N���ځi���蕪�ށj�\��
        If lngItemCount > 0 Then

            For i = 0 To UBound(vntItemName)
                IF i = 0 Then
%>
                    <%= vntItemName(i)%>
<%
                Else
%>
                    �A<%= vntItemName(i)%>
<%
                End if
            Next
        Else
%>
        &nbsp;
<%
        End If
%>
</p>
<%
    Do
    '���b�Z�[�W�̕ҏW
        If strAction <> "" Then

            Select Case strAction

                '�ۑ��������́u�ۑ������v�̒ʒm
                Case "saveend"
                    Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)
                '�����Ȃ��΃G���[���b�Z�[�W��ҏW
                Case Else
                    Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

            End Select
%>
            <BR>
            <TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
                <TR>
                    <TD>
                        �u<FONT COLOR="#ff6600"><B><%= strStartYear %>�N<%= strStartMonth %>��<%= strStartDay %>��<%  If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then %>�`<%= strEndYear %>�N<%= strEndMonth %>��<%= strEndDay %>��<% End IF%></B></FONT>�v�̃t�H���[�A�b�v�Ώێ҈ꗗ��\�����Ă��܂��B<BR>
                                ����������&nbsp;<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>&nbsp;���ł��B
                    </TD>
                    <TD ALIGN="right" VALIGN="middle">
                        <IMG SRC="/webHains/images/jud.gif"     WIDTH="20" HEIGHT="20" ALT="�ʐڎx��">�F�ʐڎx��
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                        <IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="�˗�����">�F�˗���쐬
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                        <IMG SRC="/webHains/images/follow_result.gif"  WIDTH="20" HEIGHT="20" ALT="���ʓ���">�F���ʓ���
                    </TD>
                </TR>
            </TABLE>
            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��f��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�����h�c</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�l�h�c</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��f�Җ�</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�N��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">���N����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��������<BR>�i���蕪�ށj</TD>
                    <TD ALIGN="center" NOWRAP COLSPAN="2">����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="200">�t�H���[</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�o�^��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��������<BR>(�㕔)</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��������<BR>(����)</TD>
<%'### 2016.01.23 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ### %>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�w�l�Ȑf�@��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�w�l�Ȕ����</TD>
<%'### 2016.01.23 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ### %>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">����</TD>
                </TR>
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP>�t�H���[</TD>
                    <TD ALIGN="center" NOWRAP>���ݔ���</TD>
                </TR>
<%
        End If

        If lngAllCount > 0 Then
            strBeforeRsvNo = ""

            For i = 0 To UBound(vntRsvNo)

                strWebCslDate       = ""
                strWebDayId         = ""
                strWebPerId         = ""
                strWebPerName       = ""
                strWebAge           = ""
                strWebGender        = ""
                strWebBirth         = ""
                strWebJudClassName  = vntJudClassName(i)
                strWebJudCd         = vntJudCd(i)
                strWebRslJudCd      = vntRslJudCd(i)
                strWebEquipDiv      = vntEquipDiv(i)
                strWebEquipDivName  = ""
                strWebStatusCd      = vntStatusCd(i)
                strWebStatusName    = ""
                strWebPrtSeq        = vntPrtSeq(i)
                strWebFileName      = vntFileName(i)
                strWebPrtDate       = vntPrtDate(i)
                strWebPrtUser       = vntPrtUser(i)
                strWebRsvNo         = ""
                strWebAddUser       = vntAddUser(i)
                strWebDocJud        = ""
                strWebDocGf         = ""
                strWebDocCf         = ""

'### 2016.01.23 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ###
                strWebDocGyne       = ""
                strWebDocGyneJud    = ""
'### 2016.01.23 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ###

                If strBeforeRsvNo <> vntRsvNo(i) Then

                    strWebCslDate   = vntCslDate(i)
                    strWebDayId     = objCommon.FormatString(vntDayId(i), "0000")
                    strWebPerId     = vntPerId(i)
                    strWebPerName   = "<SPAN STYLE=""font-size:9px;"">" & vntPerKName(i) & "</SPAN><BR>" & vntPerName(i)
                    strWebAge       = vntAge(i) & "��"
                    strWebGender    = vntGender(i)
                    strWebBirth     = vntBirth(i)
                    strWebRsvNo     = vntRsvNo(i)
                    strWebDocJud    = vntDocJud(i)
                    strWebDocGf     = vntDocGf(i)
                    strWebDocCf     = vntDocCf(i)

'### 2016.01.23 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ###
                    strWebDocGyne   = vntDocGyne(i)
                    strWebDocGyneJud= vntDocGyneJud(i)
'### 2016.01.23 �� �q�{�򕔍זE�f�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ###

                    strURL = "/webHains/contents/follow/followInfoTop.asp"
                    strURL = strURL & "?rsvno="     & vntRsvNo(i)
                    strURL = strURL & "&winmode="   & "1"

                    strURL = strURL & "&strYear="   & Year(vntCslDate(i))
                    strURL = strURL & "&strMonth="  & Month(vntCslDate(i))
                    strURL = strURL & "&strDay="    & Day(vntCslDate(i))
                    strURL = strURL & "&endYear="   & Year(vntCslDate(i))
                    strURL = strURL & "&endMonth="  & Month(vntCslDate(i))
                    strURL = strURL & "&endDay="    & Day(vntCslDate(i))

                End If
%>
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC';" onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate        %></TD>
                    <TD NOWRAP><%= strWebDayId          %></TD>
                    <TD NOWRAP><%= strWebPerId          %></TD>
                    <TD NOWRAP><A HREF="javascript:follow_openWindow('<%= strURL %>')" TARGET="_top"><%= strWebPerName %></A></TD>
                    <TD NOWRAP><%= strWebGender         %></TD>
                    <TD NOWRAP><%= strWebAge            %></TD>
                    <TD NOWRAP><%= strWebBirth          %></TD>
                    <TD NOWRAP>
                        <A HREF="javascript:callMenResult(<%= vntRsvNo(i) %>,'',<%= vntCsCd(i) %>,<%= vntResultDispMode(i) %>)"><%= strWebJudClassName   %></A>
                        <INPUT TYPE="hidden"    NAME="arrRsvNo"         VALUE="<%= vntRsvNo(i) %>">
                        <INPUT TYPE="hidden"    NAME="arrJudClassCd"    VALUE="<%= vntJudClassCd(i) %>">
                        <INPUT TYPE="hidden"    NAME="arrJudCd"         VALUE="<%= vntJudCd(i) %>">
                        <INPUT TYPE="hidden"    NAME="arrRslJudCd"      VALUE="<%= vntRslJudCd(i) %>">
                        <INPUT TYPE="hidden"    NAME="arrEquipDiv">
                    </TD>
                    <TD ALIGN="center" NOWRAP  <% If vntJudCd(i) <> "" and vntJudCd(i) <> vntRslJudCd(i) Then %>BGCOLOR="#FFC0CB"<% End If %> >
                        <%= strWebJudCd          %>
                    </TD>
                    <TD ALIGN="center" NOWRAP  <% If vntJudCd(i) <> "" and vntJudCd(i) <> vntRslJudCd(i) Then %>BGCOLOR="#FFC0CB"<% End If %> >
                        <%= strWebRslJudCd       %>
                    </TD>
                    <TD NOWRAP>
                    <%
                        If vntEquipDiv(i) = ""  Then
                    %>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="9" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "9", " CHECKED", "") %>>�ΏۊO<BR>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="0" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "0", " CHECKED", "") %>>�񎟌����ꏊ����<BR>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="1" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "1", " CHECKED", "") %>>���Z���^�[
                        <%'### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###%>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="2" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "2", " CHECKED", "") %>>�{�@�E���f�B���[�J�X
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="3" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "3", " CHECKED", "") %>>���@
                    <%  Else
                            Select Case vntEquipDiv(i)
                               Case 0
                                    strWebEquipDivName = "�񎟌����ꏊ����"
                               Case 1
                                    strWebEquipDivName = "���Z���^�["
                               Case 2
                                    '### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###
                                    'strWebEquipDivName = "�{�@"
                                    strWebEquipDivName = "�{�@�E���f�B���[�J�X"
                               Case 3
                                    strWebEquipDivName = "���@"
                               Case 9
                                    strWebEquipDivName = "<FONT COLOR='#666666'>�ΏۊO</FONT>"
                            End Select
                    %><B><%= strWebEquipDivName    %></B>
                    <%      If vntStatusCd(i) <> "" Then  
'                                Select Case vntStatusCd(i)
'                                   Case 1
'                                        strWebStatusName = "�ُ�Ȃ�"
'                                   Case 2
'                                        strWebStatusName = "�ُ킠��F�t�H���[�Ȃ�"
'                                   Case 3
'                                        strWebStatusName = "�ُ킠��F�p���t�H���["
'                                   Case 4
'                                        strWebStatusName = "���̑��I���F�A���Ƃꂸ"
'                                End Select

                                Select Case vntStatusCd(i)
                                   Case 11
                                        strWebStatusName = "�f�f�m��F�ُ�Ȃ�"
                                   Case 12
                                        strWebStatusName = "�f�f�m��F�ُ킠��"
                                   Case 21
                                        strWebStatusName = "�f�f���m��(��f�{��)�F�Z���^�["
                                   Case 22
                                        '### 2016.09.13 �� �{�@���{�@�E���f�B���[�J�X�ɕύX ###
                                        'strWebStatusName = "�f�f���m��(��f�{��)�F�{�@"
                                        strWebStatusName = "�f�f���m��(��f�{��)�F�{�@�E���f�B���[�J�X"
                                   Case 23
                                        strWebStatusName = "�f�f���m��(��f�{��)�F���@"
                                   Case 29
                                        strWebStatusName = "�f�f���m��(��f�{��)�F���̑��i����E�s���j"
                                   Case 99
                                        strWebStatusName = "���̑�(�t�H���[�A�b�v�o�^�I��)"
                                End Select

                    %>(<%= strWebStatusName %>)
                    <%      End If  %>
                    <%      If vntPrtSeq(i) <> "" Then  %>
                                <BR><A HREF="/webHains/contents/follow/prtPreview.asp?documentFileName=<%= strWebFileName %>" TARGET="_blank">�˗���(<%=vntPrtSeq(i)%>��)�F<%= strWebPrtUser %>&nbsp;<%= strWebPrtDate %></A>
                    <%      End If  %>
                    <%      If vntReqConfirmDate(i) <> "" Then  %>
                                <BR>���ʏ��F��(<%=vntReqConfirmUser(i)%>)

                    <%      End If
                        End If
                    %>
                    </TD>
                    <TD NOWRAP <% If vntAddUser(i)  = ""  Then %>ALIGN="center"<% End If %>><%= strWebAddUser    %></TD>
                    <TD NOWRAP <% If vntDocJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocJud     %></TD>
                    <TD NOWRAP <% If vntDocGf(i)    = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGf      %></TD>
                    <TD NOWRAP <% If vntDocCf(i)    = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocCf      %></TD>
<%'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ### %>
                    <TD NOWRAP <% If vntDocGyne(i)      = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGyne       %></TD>
                    <TD NOWRAP <% If vntDocGyneJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGyneJud    %></TD>
<%'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ### %>

                    <TD NOWRAP>
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                            <TR>
                                <TD><A HREF="/webHains/contents/interview/interviewTop.asp?rsvNo=<%= vntRsvno(i) %>" TARGET="_blank"><IMG SRC="/webHains/images/jud.gif" WIDTH="20" HEIGHT="20" ALT="�ʐڎx��"></A></TD>
                                <%
'### 2016.02.02 �� �q�{�򕔍זE�f�̏ꍇ�A���ʓo�^��ʕ\�����Ȃ��i�b��j STR ###
'                                    If vntEquipDiv(i) = "3" or  vntEquipDiv(i) = "0"  Then
                                    If vntEquipDiv(i) = "3" or  vntEquipDiv(i) = "0" or (vntEquipDiv(i) = "2" and vntJudClassCd(i) = "31") Then
'### 2016.02.02 �� �q�{�򕔍זE�f�̏ꍇ�A���ʓo�^��ʕ\�����Ȃ��i�b��j END ###
                                %>
                                        <TD>
                                            <A HREF="javaScript:showRequestEdit('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>') ">
                                            <IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="�˗���쐬">
                                            </A>
                                        </TD>
                                <%  Else    %>
                                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
                                <%  End If  %>

                                <%
'### 2016.01.23 �� �q�{�򕔍זE�f�̏ꍇ�A���ʓo�^��ʕ\�����Ȃ��i�b��j STR ###
                                    If vntEquipDiv(i) <> "" Then
'                                    If vntEquipDiv(i) <> ""  and vntJudClassCd(i) <> 31 Then
'### 2016.01.23 �� �q�{�򕔍זE�f�̏ꍇ�A���ʓo�^��ʕ\�����Ȃ��i�b��j END ###
                                %>
                                        <TD>
                                            <!--A HREF="javaScript:showFollowRsl('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>', '<%= vntJudClassName(i) %>', '<%= vntJudCd(i) %>') "-->
                                            <A HREF="javaScript:showFollowInfo('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>') ">
                                            <IMG SRC="/webHains/images/follow_result.gif" WIDTH="20" HEIGHT="20" ALT="���ʓ���">
                                            </A>
                                        </TD>

                                <%  Else    %>

                                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>

                                <%  End If  %>
                            </TR>
                        </TABLE>
                    </TD>


                </TR>
<%
                strBeforeRsvNo = vntRsvno(i)
            Next
        End If
%>
        </TABLE>
<%
        If lngAllCount > 0 Then
            '�S���������̓y�[�W���O�i�r�Q�[�^�s�v
                If lngPageMaxLine <= 0 Then
            Else
                'URL�̕ҏW
                strURL = Request.ServerVariables("SCRIPT_NAME")
                strURL = strURL & "?mode="        & strMode
                strURL = strURL & "&action="      & "search"
                strURL = strURL & "&startYear="   & strStartYear
                strURL = strURL & "&startMonth="  & strStartMonth
                strURL = strURL & "&startDay="    & strStartDay
                strURL = strURL & "&endYear="     & strEndYear
                strURL = strURL & "&endMonth="    & strEndMonth
                strURL = strURL & "&endDay="      & strEndDay
                strURL = strURL & "&perId="       & strPerId
                strURL = strURL & "&itemCd="      & strItemCd
                strURL = strURL & "&equipStat="   & strEquipStat
                strURL = strURL & "&confirmStat=" & strConfirmStat
                strURL = strURL & "&adduser="     & strAddUser
                strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
                '�y�[�W���O�i�r�Q�[�^�̕ҏW

%>
                <%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
            End If
%>
            <BR>
<%
        End If
        Exit do
    Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>