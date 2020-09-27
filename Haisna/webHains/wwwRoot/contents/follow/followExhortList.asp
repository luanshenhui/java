<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �t�H���[(�˗���) (Ver0.0.1)
'       AUTHER  :
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

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon               '���ʃN���X
'Dim objConsult              '��f���A�N�Z�X�p
'Dim objPerson               '�l���A�N�Z�X�p
Dim objFollow               '�t�H���[�A�b�v�A�N�Z�X�p
Dim objRequest              '�˗��󗚗��A�N�Z�X�p
Dim objHainsUser            '���[�U���A�N�Z�X�p

Dim strMessage              '�G���[���b�Z�[�W
Dim strMode                 '�������[�h
Dim strAct                  '�������
Dim strStartCslDate         '����������f�N�����i�J�n�j
Dim strStartYear            '����������f�N�i�J�n�j
Dim strStartMonth           '����������f���i�J�n�j
Dim strStartDay             '����������f���i�J�n�j
Dim strEndCslDate           '����������f�N�����i�I���j
Dim strEndYear              '����������f�N�i�I���j
Dim strEndMonth             '����������f���i�I���j
Dim strEndDay               '����������f���i�I���j

Dim dptEndDate              '
Dim dptStartDate

Dim vntRsvNo                '�\��ԍ�
Dim vntCslDate              '��f��
Dim vntDayId                '����ID
Dim vntPerId                '�lID
Dim vntPerKname             '�J�i����
Dim vntPerName              '����
Dim vntAge                  '�N��
Dim vntGender               '����
Dim vntBirth                '���N����
Dim vntCscd                 '�R�[�X�R�[�h
Dim vntJudClassCd           '���蕪�ރR�[�h
Dim vntJudClassName         '���蕪�ޖ�
Dim vntJudCd                '����R�[�h�i�t�H���[�o�^�����茋�ʁj
Dim vntRslJudCd             '����R�[�h�i���f���茋�ʁj
Dim vntResultDispMode       '�������ʕ\�����[�h
Dim vntEquipDiv             '�񎟌������{�敪
Dim vntAddUser              '�t�H�[���o�^��
Dim vntDocJud               '�����
Dim vntDocGf                '�㕔�����Ǔ�������
Dim vntDocCf                '�咰��������

Dim vntSecPlanDate          '�񎟌����\���
Dim vntReqCheckDate1        '��ꊩ����
Dim vntReqCheckDate2        '��񊩏���
Dim vntReqCheckSeq          '��������
Dim vntSecTestName          '�񎟌����\�荀�ږ�

Dim strItemCd               '����������������
Dim vntItemCd               '�t�H���[�Ώی������ڃR�[�h
Dim vntItemName             '�t�H���[�Ώی������ږ���
Dim lngItemCount            '�t�H���[�Ώی������ڐ�

Dim strUpdUser              '�����������[�U
Dim strUpdUsername          '���[�U��

Dim lngPastMonth            '��f������̌o�ߊ���
Dim lngArrPastMonth()       '��f������̌o�ߊ��Ԕz��
Dim strArrPastMonthName()   '��f������̌o�ߊ��Ԗ��z��

Dim strCheckDateStat          '���ʏ��F���("":���ׂāA"0":�������A"1":1�������ς݁A"2":2�������ς�)

Dim lngStartPos             '�\���J�n�ʒu
Dim lngPageMaxLine          '�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()     '�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName() '�P�y�[�W�\���l�`�w�s���̔z��
Dim strArrMessage           '�G���[���b�Z�[�W

Dim lngAllCount             '������
Dim lngAllRsvCount          '�����\��Ȃ�����
Dim lngPMonth            '��f������̌o�ߊ���

Dim strBeforeRsvNo          '�O�s�̗\��ԍ�

Dim strWebCslDate           '��f��
Dim strWebRsvNo             '�\��ԍ�
Dim strWebDayId             '����ID
Dim strWebPerId             '�lID
Dim strWebPerName           '�J�i�����E����
Dim strWebGender            '����
Dim strWebAge               '�N��
Dim strWebBirth             '���N����
Dim strWebJudClassName      '���蕪�ޖ�
Dim strWebJudCd             '����R�[�h�i�t�H���[�o�^�����茋�ʁj
Dim strWebRslJudCd          '����R�[�h�i�J�����g���茋�ʁj
Dim strWebEquipDiv          '�񎟌������{�敪
Dim strWebEquipDivName      '�񎟌������{�敪�i���́j
Dim strWebAddUser           '�t�H�[���o�^��
Dim strWebDocJud            '�����
Dim strWebDocGf             '�㕔�����Ǔ�������
Dim strWebDocCf             '�咰��������

Dim strWebSecPlanDate          '�񎟌����\���
Dim strWebReqCheckDate1        '��ꊩ����
Dim strWebReqCheckDate2        '��񊩏���
Dim strWebSecTestName          '�񎟌����\�荀�ږ�

Dim strCheckYear
Dim strCheckMonth
Dim strCheckDay

Dim i                       '�J�E���^
Dim strURL                  '�W�����v���URL

'-------------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
'Set objConsult      = Server.CreateObject("HainsConsult.Consult")
'Set objPerson       = Server.CreateObject("HainsPerson.Person")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")

'�����l�̎擾
strMode             = Request("mode")
strAct              = Request("action")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear          = Request("endYear")
strEndMonth         = Request("endMonth")
strEndDay           = Request("endDay")
strItemCd           = Request("itemCd")
strUpdUser          = Request("upduser")
strCheckDateStat    = Request("checkDateStat")

lngPastMonth        = Request("pastMonth")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

vntRsvNo            = ConvIStringToArray(Request("arrRsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("arrJudClassCd"))
vntJudCd            = ConvIStringToArray(Request("arrJudCd"))
vntRslJudCd         = ConvIStringToArray(Request("arrRslJudCd"))
vntEquipDiv         = ConvIStringToArray(Request("arrEquipDiv"))


'�����J�n���w��
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
    dptEndDate  = DateAdd("m", -3, Now-1)
    strEndYear    = CStr(Year(dptEndDate))
    strEndMonth   = CStr(Month(dptEndDate))
    strEndDay     = CStr(Day(dptEndDate))

    dptStartDate  = DateAdd("d", -7, dptEndDate)
    strStartYear    = CStr(Year(dptStartDate))
    strStartMonth   = CStr(Month(dptStartDate))
    strStartDay     = CStr(Day(dptStartDate))
End If


'�o�ߊ��Ԗ��w�莞�̃f�[�t�H���g��3�����o��
lngPastMonth = IIf(lngPastMonth = "", 0, lngPastMonth)
lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos )
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine)


'�������Ԏw��i�V�X�e�����t����R�����o�߂̓��t�j
If lngPastMonth <> 0 Then
    dptEndDate  = DateAdd("m", -lngPastMonth, Now-1)
    strEndYear    = CStr(Year(dptEndDate))
    strEndMonth   = CStr(Month(dptEndDate))
    strEndDay     = CStr(Day(dptEndDate))

    dptStartDate  = DateAdd("d", -7, dptEndDate)
    strStartYear    = CStr(Year(dptStartDate))
    strStartMonth   = CStr(Month(dptStartDate))
    strStartDay     = CStr(Day(dptStartDate))
End If

Call CreatePastMonthInfo()
Call CreatePageMaxLineInfo()
'�I�u�W�F�N�g�̃C���X�^���X�쐬


Do

    '�t�H���[�Ώی������ځi���蕪�ށj���擾
    lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName)

    '���[�U�[���擾
    If strUpdUser <> "" Then
        objHainsUser.SelectHainsUser strUpdUser, strUpdUserName
    End If

    '�����{�^���N���b�N
    If strAct <> "" Then

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
        If strEndCslDate - strStartCslDate > 182 Then
            strArrMessage = Array("��f���͈͂́A6�����ȓ����w�肵�ĉ������B")
            Exit Do
        End If

        '�S�����擾����
        lngAllCount = objFollow.SelectExhortList( strStartCslDate, strEndCslDate, _
                                                  strItemCd, strUpdUser, _
                                                  lngPastMonth, lngStartPos, _
                                                  lngPageMaxLine, _
                                                  strCheckDateStat, _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  , , _
                                                  False )

        If lngAllCount > 0 Then

            lngAllRsvCount =objFollow.SelectExhortList( strStartCslDate, strEndCslDate, _
                                                        strItemCd, strUpdUser, _
                                                        lngPastMonth, lngStartPos, _
                                                        lngPageMaxLine, _
                                                        strCheckDateStat, _
                                                        vntCsldate, _
                                                        vntRsvNo, vntPerId, _
                                                        vntDayId, vntPerKname, _
                                                        vntPerName, vntGender, _
                                                        vntAge, vntBirth, _
                                                        vntCscd, vntJudClassCd, _
                                                        vntJudClassName, vntJudCd, _
                                                        vntRslJudCd, vntResultDispMode, _
                                                        vntEquipDiv, vntAddUser, _
                                                        vntDocJud, vntDocGf, vntDocCf, _
                                                        True , _ 
                                                        vntSecPlanDate, _
                                                        vntReqCheckDate1, _
                                                        vntReqCheckDate2, _
                                                        vntSecTestName _
                                                        )
        End If

    End If
    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f������o�߂������Ԗ��̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreatePastMonthInfo()

    Redim Preserve lngArrPastMonth(1)
    Redim Preserve strArrPastMonthName(1)

    lngArrPastMonth(0) = 1:strArrPastMonthName(0) = "3�����o��"
    lngArrPastMonth(1) = 2:strArrPastMonthName(1) = "6�����o��"

End Sub

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
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����ΏۏƉ�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->
    var winGuideFollow;     //�t�H���[�A�b�v��ʃn���h��
    var winMenResult;       // �h�b�N���ʎQ�ƃE�B���h�E�n���h��
    var winRslFol;          // �t�H���[���ʓo�^�E�B���h�E�n���h��
    var winReqCheck;

    // �G�������g�Q�Ɨp�ϐ�
    var calCheck_Year;				// �N
    var calCheck_Month;				// ��
    var calCheck_Day;				// ��
    var calCheck_CalledFunction;	// ���t�I�����ɌĂяo�����֐��I�u�W�F�N�g
    var winGuideCalendar;			// �E�B���h�E�n���h��

    // ���[�U�[�K�C�h�Ăяo��
    function callGuideUsr() {

        usrGuide_CalledFunction = SetUpdUser;

        // ���[�U�[�K�C�h�\��
        showGuideUsr();

    }

    // ���[�U�[�Z�b�g
    function SetUpdUser() {

        document.entryForm.upduser.value = usrGuide_UserCd;
        document.entryForm.updusername.value = usrGuide_UserName;
        document.getElementById('username').innerHTML = usrGuide_UserName;
    }

    function setSearchDate(pMonth) {
        document.entryForm.pastMonth.value = pMonth;
        document.entryForm.action.value = "";
        document.entryForm.submit();
    }

    // ���[�U�[�w��N���A
    function clearUpdUser() {

        document.entryForm.upduser.value = '';
        document.entryForm.updusername.value = '';
        document.getElementById('username').innerHTML = '';

    }


    // ���t�K�C�h�Ăяo��
    function callCalGuide(year, month, day) {

        // ���t�K�C�h�\��
        calGuide_showGuideCalendar( year, month, day);

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

    function submitForm(act) {

        with ( document.entryForm) {
            if (act == "search" ) {
                startPos.value = 1 ;
                pastMonth.value = '';
            }
            action.value = act;
            submit();
        }
        return false;
    }

    // �K�C�h��ʂ�\��
    function follow_openWindow( url ) {

        var opened = false; // ��ʂ��J����Ă��邩

        var dialogWidth = 1000, dialogHeight = 600;
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





// ���ʃR�����g�̃N���A
function clearCheckDate(index) {
    //document.getElementById('cDate' + index).innerHTML = '';
    document.getElementsByName('cYear' + index)[0].value  = '';
    document.getElementsByName('cMonth' + index)[0].value  = '';
    document.getElementsByName('cDay' + index)[0].value  = '';

    //document.getElementsByName('cYear' + index)[0].innerHTML  = '';
    //document.getElementsByName('cMonth' + index)[0].innerHTML  = '';
    //document.getElementsByName('cDay' + index)[0].innerHTML  = '';
    
    //document.getElementById('ccYear' + index)[0].innerHTML  = '';
    //document.getElementById('ccMonth' + index)[0].innerHTML  = '';
    //document.getElementById('ccDay' + index)[0].innerHTML  = '';

}

// ���ʃR�����g�̃N���A
function callChkDateEdit(rsvNo, judClassCd, strCheckDate,mode) {
    
    var opened = false;     // ��ʂ��J����Ă��邩
    var url;                // URL������
    var dialogTop, dialogLeft;

    // ���łɉ�ʂ��J����Ă��邩�`�F�b�N
    if ( winReqCheck != null ) {
        if ( !winReqCheck.closed ) {
            opened = true;
        }
    }

    // �t�H���[���ʓo�^��ʌĂяo��
    url = 'followCheckDateEdit.asp?mode='+ mode+'&rsvno='+rsvNo+ '&judClassCd='+judClassCd+'&reqCheckDate='+ strCheckDate;

    // ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
    dialogTop  = ( screen.height - 380 ) / 2;
    dialogLeft = ( screen.width  - 485  ) / 2;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winReqCheck.focus();
        winReqCheck.location.replace(url);
    } else {
        winReqCheck = window.open(url, '', 'width=480,height=300, top=' + dialogTop + ',left=' + dialogLeft + ',' +  'status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}

function replaceForm() {
    submitForm('search');
}


//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
<!--
td.flwtab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
    <INPUT TYPE="hidden" NAME="action"      VALUE="">
    <INPUT TYPE="hidden" NAME="startPos"    VALUE="<%= lngStartPos %>">
    <INPUT TYPE="hidden" NAME="pastMonth"   VALUE="<%= lngPastMonth %>">

<%
    '���b�Z�[�W�̕ҏW
    Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>


<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
    <TR>
        <TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�����ΏۏƉ�</FONT></B></TD>
    </TR>
</TABLE>
<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="70">��f��</TD>
        <TD WIDTH="10">�F</TD>
        <TD>
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                <TR>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
                    <TD>&nbsp;�N&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
                    <TD>&nbsp;���`&nbsp;</TD>
                    <TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" BORDER="0" ALT="���t�K�C�h��\��"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" BORDER="0" ALT="�ݒ���t���N���A"></TD>
                    <TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
                    <TD>&nbsp;�N&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
                    <TD>&nbsp;��&nbsp;</TD>
                    <TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
                    <TD>&nbsp;��</TD>
                    <TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
                    <TD><INPUT TYPE="BUTTON" VALUE="3�����o��" STYLE="width:75px;height:26px" ALT="" ONCLICK="javascript:setSearchDate(3)"></TD>
                    <TD>&nbsp;</TD>
                    <TD><INPUT TYPE="BUTTON" VALUE="6�����o��" STYLE="width:75px;height:26px" ALT="" ONCLICK="javascript:setSearchDate(6)"></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="2">
    <TR>
        <TD WIDTH="70">��������</TD>
        <TD WIDTH="10">�F</TD>
        <TD><%= EditDropDownListFromArray("itemCd", vntItemCd, vntItemName, strItemCd, NON_SELECTED_ADD) %></TD>

        <TD WIDTH="60" NOWRAP>�����敪 </TD>
        <TD WIDTH="10">�F</TD>
        <TD WIDTH="110">
            <SELECT NAME="checkDateStat">
                <OPTION VALUE=""  <%= IIf(strCheckDateStat = "",  "SELECTED", "") %>>
                <OPTION VALUE="0" <%= IIf(strCheckDateStat = "0", "SELECTED", "") %>>������
                <OPTION VALUE="1" <%= IIf(strCheckDateStat = "1", "SELECTED", "") %>>1�������ς�
                <OPTION VALUE="2" <%= IIf(strCheckDateStat = "2", "SELECTED", "") %>>2�������ς�
            </SELECT>
        </TD>
    </TR>

    <TR>
        <TD WIDTH="70">�X�V���[�U</TD>
        <TD WIDTH="10">�F</TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <INPUT TYPE="hidden" NAME="upduser"     VALUE="<%= strUpdUser %>">
                <INPUT TYPE="hidden" NAME="updusername" VALUE="<%= strUpdUserName %>">
                <TR>
                    <TD NOWRAP><A HREF="javascript:callGuideUsr()"><IMG SRC="/webHains/images/question.gif" ALT="���[�U�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD NOWRAP><A HREF="javascript:clearUpdUser()"><IMG SRC="/webHains/images/delicon.gif" ALT="���[�U�w��폜" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD NOWRAP><SPAN ID="username"><%= strUpdUserName %></SPAN></TD>
                </TR>
            </TABLE>
        </TD>
        <TD WIDTH="10"></TD>
        <TD WIDTH="10"></TD>
        <TD align="right">
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <!--TD WIDTH="70">��f������</TD>
                    <TD WIDTH="10">�F</TD>
                    <TD WIDTH="100"><%= EditDropDownListFromArray("pastMonth", lngArrPastMonth, strArrPastMonthName, lngPastMonth, NON_SELECTED_DEL) %></TD-->
                    <TD WIDTH="100"><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %></TD>

                    <TD align="right">
                        <A HREF="javascript:submitForm('search')"><IMG SRC="../../images/b_search.gif" ALT="���̏����Ō���" HEIGHT="24" WIDTH="77" BORDER="0"></A>
                    </TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<%
    Do
    '���b�Z�[�W�̕ҏW
        If strAct <> "" Then
%>
            <BR>
            <TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0" >
                <TR>
                    <TD>
                        �u<FONT COLOR="#ff6600"><B><%= strStartYear %>�N<%= strStartMonth %>��<%= strStartDay %>��<%  If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then %>�`<%= strEndYear %>�N<%= strEndMonth %>��<%= strEndDay %>��<% End IF%></B></FONT>�v�̊����Ώێ҈ꗗ��\�����Ă��܂��B<BR>
                                �Ώێ�f�҂�&nbsp;<FONT COLOR="#ff6600"><B><%= lngAllRsvCount %></B></FONT>&nbsp;���ł��B&nbsp;�i��������&nbsp;�F&nbsp;<FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>&nbsp;���j
                    </TD>
                </TR>
            </TABLE>

            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��f��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�����h�c</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�l�h�c</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="70">��f�Җ�</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�N��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="100">��������<BR>�i���蕪�ށj</TD>
                    <TD ALIGN="center" NOWRAP COLSPAN="2">����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�����\�荀��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="120">�t�H���[</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="60">�o�^��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="60">�����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="75">�����\���</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" >1������</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" >2������</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="30">����</TD>
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
                strWebGender        = ""
                strWebAge           = ""
                strWebBirth         = ""
                strWebJudClassName  = vntJudClassName(i)
                strWebJudCd         = vntJudCd(i)
                strWebRslJudCd      = vntRslJudCd(i)
                strWebEquipDiv      = vntEquipDiv(i)
                strWebEquipDivName  = ""
                strWebRsvNo         = ""
                strWebAddUser       = vntAddUser(i)
                strWebDocJud        = ""
                strWebDocGf         = ""
                strWebDocCf         = ""
                strWebSecPlanDate   = ""
                strWebReqCheckDate1 = ""
                strWebReqCheckDate2 = ""
                strWebSecTestName   = ""
                strCheckYear        = ""
                strCheckMonth       = ""
                strCheckDay         = ""

                If strBeforeRsvNo <> vntRsvNo(i) Then
                    strWebCslDate   = vntCslDate(i)
                    strWebDayId     = objCommon.FormatString(vntDayId(i), "0000")
                    strWebPerId     = vntPerId(i)
                    strWebPerName   = "<SPAN STYLE=""font-size:9px;"">" & vntPerKname(i) & "</SPAN><BR>" & vntPerName(i)
                    strWebGender    = vntGender(i)
                    strWebAge       = vntAge(i) & "��"
                    strWebBirth     = vntBirth(i)
                    strWebRsvNo     = vntRsvNo(i)
                    strWebAddUser   = vntAddUser(i)
                    strWebDocJud    = vntDocJud(i)
                    strWebDocGf     = vntDocGf(i)
                    strWebDocCf     = vntDocCf(i)
                    
                    strWebSecPlanDate   = vntSecPlanDate(i)
                    strWebReqCheckDate1 = vntReqCheckDate1(i)
                    strWebReqCheckDate2 = vntReqCheckDate2(i)
                    strWebSecTestName   = vntSecTestName(i)

                    if strWebReqCheckDate1 <> "" Then
                        strCheckYear = Mid(strWebReqCheckDate1, 1, 4) 
                        strCheckMonth = Mid(strWebReqCheckDate1, 6, 2) 
                        strCheckDay = Mid(strWebReqCheckDate1, 9, 2) 
                    Else
                        strWebReqCheckDate1 = "������"
                    End If


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
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'"; onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate        %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebDayId          %></TD>
                    <TD NOWRAP><%= strWebPerId          %></TD>
                    <TD NOWRAP><A HREF="javascript:follow_openWindow('<%= strURL %>')" TARGET="_top"><%= strWebPerName %></A></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebGender         %></TD>
                    <TD NOWRAP ALIGN="center"><%= strWebAge            %></TD>

<%
                    strBeforeRsvNo = vntRsvno(i)
%>

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

                    <TD NOWRAP <% If vntSecTestName(i)   = "" Then %>ALIGN="center"<% End If %>><%= strWebSecTestName     %></TD>

                    <TD NOWRAP>
                    <%
                        If vntEquipDiv(i) <> ""  Then

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
                            End Select
                    %>
                        <%= strWebEquipDivName    %>
                    <%
                        End If
                    %>
                    </TD>
                    <TD NOWRAP <% If vntAddUser(i)  = ""  Then %>ALIGN="center"<% End If %>><%= strWebAddUser    %></TD>
                    <TD NOWRAP <% If vntDocJud(i)   = "-" Then %>ALIGN="center"<% End If %>><%= strWebDocJud     %></TD>
                    <TD NOWRAP <% If vntSecPlanDate(i) = "-" Then %>ALIGN="center"<% End If %>><%= strWebSecPlanDate  %></TD>
                    
                    <TD NOWRAP ALIGN="center" WIDTH="80"> <A HREF="javascript:callChkDateEdit(<%= vntRsvNo(i) %>,<%= vntJudClassCd(i) %>,'<%= vntReqCheckDate1(i) %>',1 )">  <%= IIf(vntReqCheckDate1(i) <> "", vntReqCheckDate1(i), "������") %> </A> 
                    </TD>
                    
                    <TD NOWRAP ALIGN="center" WIDTH="80"> <A HREF="javascript:callChkDateEdit(<%= vntRsvNo(i) %>,<%= vntJudClassCd(i) %>,'<%= vntReqCheckDate2(i) %>',2 )">  <%= IIf(vntReqCheckDate2(i) <> "", vntReqCheckDate2(i), "������") %> </A> 
                    </TD>

                    <%
                        If vntEquipDiv(i) <> "" Then
                    %>
                        <TD ALIGN="center"> 
                                <A HREF="javaScript:showFollowInfo('<%= vntRsvNo(i) %>', '<%= vntJudClassCd(i) %>') ">
                                <IMG SRC="/webHains/images/follow_result.gif" WIDTH="20" HEIGHT="20" ALT="���ʓ���">
                                </A>
                        </TD>
                    <%  Else    %>
                            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
                    <%  End If  %>

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
                strURL = strURL & "&itemCd="      & strItemCd
                strURL = strURL & "&upduser="     & strUpdUser
                strURL = strURL & "&pastMonth="   & lngPastMonth
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
        Exit Do
    Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
