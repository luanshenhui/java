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
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const CHART_NOTEDIV   = "500"       '�`���[�g���m�[�g���ރR�[�h
Const PUBNOTE_DISPKBN = 1           '�\���敪�����
Const PUBNOTE_SELINFO = 0           '������񁁌l�{��f���

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon               '���ʃN���X
Dim objConsult              '��f���A�N�Z�X�p
Dim objPubNote              '�m�[�g�N���X
Dim objFollow               '�t�H���[�A�b�v�A�N�Z�X�p

Dim strWinMode              '�E�B���h�E���[�h
Dim lngRsvNo                '�\��ԍ�
Dim strMotoRsvNo            '�����\���\��ԍ�
Dim strJudFlg               '���茋�ʂ��o�^����Ă��Ȃ��������ڕ\���L��

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
Dim strUpdUser              '�X�V��

Dim vntItemName             '�t�H���[�Ώی�������

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
Dim vntAddUser              '�t�H���[�A�b�v�ŏ��o�^��
Dim vntUpdUser              '�X�V��

'### 2016.01.21 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ###
Dim vntDocGyne              '�w�l�Ȑf�@��
Dim vntDocGyneJud           '�w�l�Ȕ����
'### 2016.01.21 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ###

Dim strPerId                '�lID
Dim strCslDate              '��f��
Dim vntArrHistoryRsvno      '��f���̗\��ԍ��̔z��
Dim vntArrHistoryCslDate    '��f���̎�f���̔z��


Dim strLastName             '����������
Dim strFirstName            '����������

Dim vntGFFlg                '���GF��f�t���O
Dim vntCFFlg                '���GF��f�t���O
Dim vntSeq                  'SEQ

Dim lngItemCount            '�t�H���[�Ώی������ڐ�
Dim lngAllCount             '������
Dim lngRsvAllCount          '�d���\��Ȃ�����
Dim lngGetCount             '����
Dim lngCount

Dim i                       '�J�E���^
Dim j

Dim lngStartPos             '�\���J�n�ʒu
Dim lngPageMaxLine          '�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()     '�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName() '�P�y�[�W�\���l�`�w�s���̔z��

Dim lngArrSendMode()        '�������m�F��Ԃ̔z��
Dim strArrSendModeName()    '�������m�F��Ԗ��̔z��

Dim Ret                     '�֐��߂�l
Dim strURL                  '�W�����v���URL

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
Dim strWebDocJud            '�����
Dim strWebDocGf             '�㕔�����Ǔ�������
Dim strWebDocCf             '�咰��������
Dim strWebPrtDate           '�˗���쐬����
Dim strWebPrtUser           '�˗���쐬��
Dim strWebRsvNo             '�\��ԍ�
Dim strWebAddUser           '�t�H���[�A�b�v�ŏ��o�^��
Dim strWebUpdUser           '�X�V��

'### 2016.01.21 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ###
Dim strWebDocGyne           '�w�l�Ȑf�@��
Dim strWebDocGyneJud        '�w�l�Ȕ����
'### 2016.01.21 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ###

'���X�g�w�i�F����p
Dim strBgColor

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
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
lngPageMaxLine      = Request("pageMaxLine")

strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
strMotoRsvNo        = Request("motoRsvNo")
strJudFlg           = Request("judFlg")
strUpdUser          = Session.Contents("userId")

vntRsvNo            = ConvIStringToArray(Request("arrRsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("arrJudClassCd"))
vntEquipDiv         = ConvIStringToArray(Request("arrEquipDiv"))
vntJudCd            = ConvIStringToArray(Request("arrJudCd"))
vntRslJudCd         = ConvIStringToArray(Request("arrRslJudCd"))

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
                strMessage = "����ɕۑ��ł��܂����B"
            Else
                strMessage = "�ۑ��Ɏ��s���܂���"
            End If
        End If
    End If


    '�����{�^���N���b�N
'    If strAction <> "" Then
       '�S�����擾����
'       lngAllCount = objFollow.SelectTargetFollow(lngRsvNo, _
'                                                  vntRsvNo, vntCsldate, _
'                                                  vntDayId, vntPerId, _
'                                                  vntPerKName, vntPerName, _
'                                                  vntAge, vntGender, _
'                                                  vntBirth, vntJudCd, _
'                                                  vntRslJudCd, vntJudClassName, _
'                                                  vntJudClassCd, vntResultDispMode, _
'                                                  vntCsCd, vntEquipDiv, vntStatusCd, _
'                                                  vntReqConfirmDate, vntReqConfirmUser, _
'                                                  vntPrtSeq, vntFileName, _
'                                                  vntPrtDate, vntPrtUser, _
'                                                  vntDocJud, vntDocGf, vntDocCf, (strJudFlg <> ""))

'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ######################################################
'       lngAllCount = objFollow.SelectTargetFollow(lngRsvNo, _
'                                                  vntRsvNo, vntCsldate, _
'                                                  vntDayId, vntPerId, _
'                                                  vntPerKName, vntPerName, _
'                                                  vntAge, vntGender, _
'                                                  vntBirth, vntJudCd, _
'                                                  vntRslJudCd, vntJudClassName, _
'                                                  vntJudClassCd, vntResultDispMode, _
'                                                  vntCsCd, vntEquipDiv, vntStatusCd, _
'                                                  vntReqConfirmDate, vntReqConfirmUser, _
'                                                  vntPrtSeq, vntFileName, _
'                                                  vntPrtDate, vntPrtUser, vntAddUser, _
'                                                  vntDocJud, vntDocGf, vntDocCf, (strJudFlg <> ""), vntUpdUser )

       lngAllCount = objFollow.SelectTargetFollow(lngRsvNo, _
                                                  vntRsvNo, vntCsldate, _
                                                  vntDayId, vntPerId, _
                                                  vntPerKName, vntPerName, _
                                                  vntAge, vntGender, _
                                                  vntBirth, vntJudCd, _
                                                  vntRslJudCd, vntJudClassName, _
                                                  vntJudClassCd, vntResultDispMode, _
                                                  vntCsCd, vntEquipDiv, vntStatusCd, _
                                                  vntReqConfirmDate, vntReqConfirmUser, _
                                                  vntPrtSeq, vntFileName, _
                                                  vntPrtDate, vntPrtUser, vntAddUser, _
                                                  vntDocJud, vntDocGf, vntDocCf, vntDocGyne, vntDocGyneJud, _
                                                  (strJudFlg <> ""), vntUpdUser )
'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ######################################################

'    End If

    Exit Do
Loop

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�t�H���[�A�b�v����</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
    var winGuideFollow;     //�t�H���[�A�b�v��ʃn���h��
    var winMenResult;       // �h�b�N���ʎQ�ƃE�B���h�E�n���h��
    var winRslFol;          // �t�H���[���ʓo�^�E�B���h�E�n���h��

    //�������ʉ�ʌĂяo��
    function callMenResult( inRsvNo, inGrpCd, inCsCd, classgrpno ) {
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
        url = url + '&rsvno=' + inRsvNo;
        url = url + '&grpcd=' + inGrpCd;
        url = url + '&cscd=' + inCsCd;

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
        url = 'followInfoEdit.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd;

        // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
        if ( opened ) {
            winRslFol.focus();
            winRslFol.location.replace(url);
        } else {
            winRslFol = window.open(url, '', 'width=1000,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
        }
    }


    // �`�F�b�N���ꂽ(���W�I�{�^��)�񎟌����{�݋敪�̒l����
    function setRadio(index, selObj) {

        var myForm = document.entryFollowInfo;

//        alert('selObj.value = '+selObj.value);
//        alert('index = '+index);
        if ( myForm.arrEquipDiv.length != null ) {
            myForm.arrEquipDiv[index].value = selObj.value;
        } else {
            myForm.arrEquipDiv.value = selObj.value;
        }

    }


    // �����{�^���N���b�N
    function submitForm(act) {

        with ( document.entryFollowInfo ) {
//            action.value = act;
            submit();
        }
        return false;

    }

    function replaceForm() {

        with ( document.entryFollowInfo ) {
            submit();
        }
        return false;

    }

    // �K�C�h��ʂ�\��
    function follow_openWindow( url ) {

        var opened = false; // ��ʂ��J����Ă��邩

        var dialogWidth = 1024, dialogHeight = 768;
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


    // �A�����[�h���̏���
    function closeGuideWindow() {

        //���t�K�C�h�����
        calGuide_closeGuideCalendar();

        if ( winGuideFollow != null ) {
            if ( !winGuideFollow.closed ) {
                winGuideFollow.close();
            }
        }
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

        winGuideFollow = null;
        winMenResult = null;
//        winRslFol = null;

        return false;
    }
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<FORM NAME="entryFollowInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="motoRsvNo"   VALUE="<%= strMotoRsvNo%>">
<INPUT TYPE="hidden" NAME="action"      VALUE=""> 
<INPUT TYPE="hidden" NAME="judFlg"      VALUE="<%= strJudFlg
%>">
<!--�����͌�����������-->
<%
    Do
        '���b�Z�[�W���������Ă���ꍇ�͕ҏW���ď����I��
        If strMessage <> "" Then
%>
            <BR>&nbsp;<%= strMessage %>
<%
        End If
%>
            <TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
                <TR>
                    <TD ALIGN="right" VALIGN="middle">
                    <%
                        '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�ʐڎx����ʎQ�Ƃł���悤�ɂ���
                        If strWinMode = 1 Then
                    %>
                        <IMG SRC="/webHains/images/jud.gif"     WIDTH="20" HEIGHT="20" ALT="�ʐڎx��">�F�ʐڎx��
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                    <%  End If %>
                        <IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="�˗�����">�F�˗�����
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                        <IMG SRC="/webHains/images/follow_result.gif"  WIDTH="20" HEIGHT="20" ALT="���ʓ���">�F���ʓ���
                    </TD>
                </TR>
            </TABLE>
            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��f��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="100">��������<BR>�i���蕪�ށj</TD>
                    <TD ALIGN="center" NOWRAP COLSPAN="2">����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="250">�t�H���[</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">�o�^��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">�X�V��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">�����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">��������<BR>(�㕔)</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">��������<BR>(����)</TD>
<%'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ### %>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�w�l�Ȑf�@��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�w�l�Ȕ����</TD>
<%'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ### %>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">����</TD>
                </TR>
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP>�t�H���[</TD>
                    <TD ALIGN="center" NOWRAP>���ݔ���</TD>
                </TR>
<%
        If lngAllCount > 0 Then

            For i = 0 To UBound(vntRsvNo)

                strWebCslDate   = vntCslDate(i)
                strWebDayId     = objCommon.FormatString(vntDayId(i), "0000")
                strWebPerId     = vntPerId(i)
                strWebPerName   = "<SPAN STYLE=""font-size:9px;"">" & vntPerKName(i) & "</SPAN><BR>" & vntPerName(i)
                strWebAge       = vntAge(i) & "��"
                strWebGender    = vntGender(i)
                strWebBirth     = vntBirth(i)

                strWebJudClassName  = vntJudClassName(i)
                strWebJudCd         = vntJudCd(i)
                strWebRslJudCd      = vntRslJudCd(i)
                strWebEquipDiv      = vntEquipDiv(i)
                strWebEquipDivName  = ""
                strWebStatusCd      = vntStatusCd(i)
                strWebStatusName    = ""
                strWebFileName      = vntFileName(i)
                strWebPrtSeq        = vntPrtSeq(i)
                strWebPrtDate       = vntPrtDate(i)
                strWebPrtUser       = vntPrtUser(i)
                strWebRsvNo         = vntRsvNo(i)
                strWebDocJud        = vntDocJud(i)
                strWebDocGf         = vntDocGf(i)
                strWebDocCf         = vntDocCf(i)
                strWebAddUser       = vntAddUser(i)
                strWebUpdUser       = vntUpdUser(i)
'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ###
                strWebDocGyne       = vntDocGyne(i)
                strWebDocGyneJud    = vntDocGyneJud(i)
'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ###
%>
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'"; onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate        %></TD>
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
                    <TD NOWRAP <% If vntUpdUser(i)  = ""  Then %>ALIGN="center"<% End If %>><%= strWebUpdUser    %></TD>
                    <TD NOWRAP <% If vntDocJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocJud     %></TD>
                    <TD NOWRAP <% If vntDocGf(i)    = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGf      %></TD>
                    <TD NOWRAP <% If vntDocCf(i)    = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocCf      %></TD>
<%'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� STR ### %>
                    <TD NOWRAP <% If vntDocGyne(i)      = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGyne       %></TD>
                    <TD NOWRAP <% If vntDocGyneJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocGyneJud    %></TD>
<%'### 2016.01.23 �� �w�l�Ȑf�@�t�H���[�A�b�v�ǉ��ɂ���Ēǉ� END ### %>

                    <TD NOWRAP>
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADING="1">
                            <TR>
                                <%
                                    '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�ʐڎx����ʎQ�Ƃł���悤�ɂ���
                                    If strWinMode = 1 Then
                                %>
                                        <TD><A HREF="/webHains/contents/interview/interviewTop.asp?rsvNo=<%= vntRsvno(i) %>" TARGET="_blank"><IMG SRC="/webHains/images/jud.gif" WIDTH="20" HEIGHT="20" ALT="�ʐڎx��"></A></TD>
                                <%  End If  %>
                                <%
                                    If vntEquipDiv(i) = "3" or vntEquipDiv(i) = "0" Then
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
                                    If vntEquipDiv(i) <> "" Then
                                %>
                                        <TD><A HREF="javaScript:showFollowRsl('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>', '<%= vntJudClassName(i) %>', '<%= vntJudCd(i) %>') "><IMG SRC="/webHains/images/follow_result.gif" WIDTH="20" HEIGHT="20" ALT="���ʓ���"></A></TD>

                                <%  Else    %>

                                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>

                                <%  End If  %>
                            </TR>
                        </TABLE>
                    </TD>


                </TR>
<%
            Next
        End If
%>
            </TABLE>
<%
        Exit do
    Loop
%>
<BR>

</FORM>
</BODY>
</HTML>