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
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
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

Dim	strWinMode              '�E�B���h�E���[�h
Dim lngRsvNo                '�\��ԍ�
Dim strMotoRsvNo            '�����\���\��ԍ�

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
Dim strUpdUser          '�X�V��

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
Dim vntPrtSeq               '�˗�������
Dim vntFileName             '�˗���t�@�C����
Dim vntDocJud               '�����
Dim vntDocGf                '�㕔�����Ǔ�������
Dim vntDocCf                '�咰��������

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
Dim strWebPrtSeq            '�˗�������
Dim strWebFileName          '�˗���t�@�C����
Dim strWebDocJud            '�����
Dim strWebDocGf             '�㕔�����Ǔ�������
Dim strWebDocCf             '�咰��������
Dim strWebRsvNo             '�\��ԍ�

'�m�[�g��񌏐��l���p
Dim vntNoteSeq          'seq
Dim vntPubNoteDivCd     '��f���m�[�g���ރR�[�h
Dim vntPubNoteDivName   '��f���m�[�g���ޖ���
Dim vntDefaultDispKbn   '�\���Ώۋ敪�����l
Dim vntOnlyDispKbn      '�\���Ώۋ敪���΂�
Dim vntDispKbn          '�\���Ώۋ敪
Dim vntUpdDate          '�o�^����
Dim vntNoteUpdUser      '�o�^��
Dim vntUserName         '�o�^�Җ�
Dim vntBoldFlg          '�����敪
Dim vntPubNote          '�m�[�g
Dim vntDispColor        '�\���F
Dim lngChartCnt         '�`���[�g��񌏐�

'���X�g�w�i�F����p
Dim strBgColor

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
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
strUpdUser          = Session.Contents("userId")

vntRsvNo            = ConvIStringToArray(Request("rsvNo"))
vntJudClassCd       = ConvIStringToArray(Request("judClassCd"))
vntEquipDiv         = ConvIStringToArray(Request("equipDiv"))
vntJudCd            = ConvIStringToArray(Request("judCd"))


'�\��ԍ����w�肳��Ă���ꍇ
If lngRsvNo <> "" Then

    '��f���ǂݍ���
    Ret = objConsult.SelectConsult(lngRsvNo, , strCslDate, strPerId)

    '��x���\�����Ă��Ȃ��ꍇ�͗\��ԍ���ޔ�����
    If strMotoRsvNo = "" Then
        strMotoRsvNo = lngRsvNo
    End If
    '��f�����ǂݍ���
    lngCount = objFollow.SelectFollowHistory(strPerId, strMotoRsvNo, vntArrHistoryRsvno, vntArrHistoryCslDate)

    '��f�����Ȃ��ꍇ�͈����̗\��ԍ��A��f����\������
    If lngCount = 0 Then
        vntArrHistoryRsvno   = Array()
        vntArrHistoryCslDate = Array()
        Redim Preserve vntArrHistoryRsvno(0)
        Redim Preserve vntArrHistoryCslDate(0)
        vntArrHistoryRsvno(0)   = lngRsvNo
        vntArrHistoryCslDate(0) = strCslDate
    End If

    '�`���[�g���̌����擾
    lngChartCnt = objPubNote.SelectPubNote(PUBNOTE_SELINFO,  _
                                        0, "", "",           _
                                        lngRsvNo,            _
                                        "", "", "", "", 0,   _
                                        CHART_NOTEDIV,       _
                                        PUBNOTE_DISPKBN,     _
                                        strUpdUser,          _
                                        vntNoteSeq,          _
                                        vntPubNoteDivCd,     _
                                        vntPubNoteDivName,   _
                                        vntDefaultDispKbn,   _
                                        vntOnlyDispKbn,      _
                                        vntDispKbn,          _
                                        vntUpdDate,          _
                                        vntNoteUpdUser,      _
                                        vntUserName,         _
                                        vntBoldFlg,          _
                                        vntPubNote,          _
                                        vntDispColor )

End If


Do

'    '�ۑ��{�^���N���b�N��
'    If strAction = "save"  Then
'        '�t�H���[�̕ۑ�
'        If strMessage = ""  Then
''           '�X�V�Ώۃf�[�^�����݂���Ƃ��̂ݔ��茋�ʕۑ�
'            Ret = objFollow.InsertFollow_Info(vntRsvNo, vntJudClassCd, vntEquipDiv, vntJudCd, _
'                                              Session.Contents("userId"))
'            If Ret = True Then
'                strAction = "saveend"
'                strMessage = "����ɕۑ��ł��܂����B"
'            Else
'                strMessage = "�ۑ��Ɏ��s���܂���"
'            End If
'        End If
'    End If
    
    '�t�H���[�Ώی������ځi���蕪�ށj���擾
    lngItemCount = objFollow.SelectFollowItem( vntItemName )

    '�����{�^���N���b�N
'    If strAction <> "" Then
       '�S�����擾����
       lngAllCount = objFollow.SelectTargetFollow(lngRsvNo, _
                                                  vntRsvNo, vntCsldate, _
                                                  vntDayId, vntPerId, _
                                                  vntPerKName, vntPerName, _
                                                  vntAge, vntGender, _
                                                  vntBirth, vntJudCd, _
                                                  vntRslJudCd, vntJudClassName, _
                                                  vntJudClassCd, vntResultDispMode, _
                                                  vntCsCd, vntEquipDiv, _
                                                  vntPrtSeq, vntFileName, _
                                                  vntDocJud, vntDocGf, vntDocCf)

'    End If

    Exit Do
Loop

'    Set objConsult = Nothing
'    Set objPubNote = Nothing
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<HEAD>
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
        url = 'followRslEdit.asp?winmode=1&rsvno='+rsvNo+'&judClassCd=' + judClassCd;

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
        if ( myForm.equipDiv.length != null ) {
            myForm.equipDiv[index].value = selObj.value;
        } else {
            myForm.equipDiv.value = selObj.value;
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

    //�R�����g�ꗗ�i�`���[�g���j�Ăяo��
    function callCommentList() {
        alert("�`���[�g���\�����");
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
        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                winRslFol.close();
            }
        }

        winGuideFollow = null;
        winMenResult = null;
        winRslFol = null;

        return false;
    }
//-->
</SCRIPT>
<style type="text/css">
	body { margin: <%= IIF(strWinMode = 1,"12","0") %>px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<%
    '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
    If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
        Call interviewHeader(lngRsvNo, 0)
    End If
%>
<FORM NAME="entryFollowInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="motoRsvNo"   VALUE="<%=strMotoRsvNo%>">
<INPUT TYPE="hidden" NAME="action"      VALUE=""> 
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD WIDTH="100%">
            <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                <TR>
                    <TD NOWRAP BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="15"><B><SPAN CLASS="follow">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v�Ɖ�</FONT></B></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>
strCslDate=<%= strCslDate%><BR>
strPerId=<%=strPerId%>



<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD NOWRAP WIDTH="150" ALIGN="left" VALIGN="top">��<FONT style="background-color:#CCCCCC;">�t�H���[�Ώی�������</FONT>&nbsp;�F&nbsp;</TD>
        <TD>
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
        </TD>
    </TR>
</TABLE>

<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
<%
    '�`���[�g��񂠂�H
    If lngChartCnt > 0 Then
%>
        <TD ALIGN="left" BGCOLOR="ffffff"><A HREF="javascript:callCommentList()"><FONT  SIZE="-1" COLOR="FF00FF">�`���[�g���</FONT></A></TD>
<%
    Else
%>
        <TD ALIGN="left" BGCOLOR="ffffff"><A HREF="javascript:callCommentList()"><IMAGE SRC="/webHains/images/chartinfo.gif" ALT="�`���[�g����\�����܂�" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
<%
    End If
%>
        <TD WIDTH="100" ALIGN="right">�\����f��</TD>
        <TD WIDTH="100" ALIGN="right"><%= EditDropDownListFromArray("rsvHistory", vntArrHistoryRsvno, vntArrHistoryCslDate, lngRsvNo, NON_SELECTED_DEL) %></TD>
        <TD WIDTH="170" ALIGN="right">
            <A HREF="javascript:submitForm('search')"><IMG SRC="../../images/b_search.gif" ALT="���̏����Ō���" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <A HREF="javascript:submitForm('save')"><IMG SRC="../../images/save.gif" ALT="�t�H���[�ۑ�" HEIGHT="24" WIDTH="77" BORDER="0"></A>
        </TD>

    </TR>
</TABLE>

<BR>
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
                        <IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="�˗�����">�F�˗�����
                        <IMG SRC="/webHains/images/spacer.gif"  WIDTH="20" HEIGHT="20">
                        <IMG SRC="/webHains/images/follow_result.gif"  WIDTH="20" HEIGHT="20" ALT="���ʓ���">�F���ʓ���
                    </TD>
                </TR>
            </TABLE>
            <BR>

            <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��f��</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��������<BR>�i���蕪�ށj</TD>
                    <TD ALIGN="center" NOWRAP COLSPAN="2">����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="200">�t�H���[</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">�����</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��������<BR>(�㕔)</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2">��������<BR>(����)</TD>
                    <TD ALIGN="center" NOWRAP ROWSPAN="2" WIDTH="80">����</TD>
                </TR>
                <TR BGCOLOR="silver">
                    <TD ALIGN="center" NOWRAP>�t�H���[</TD>
                    <TD ALIGN="center" NOWRAP>���ݔ���</TD>
                </TR>
<%
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
                strWebFileName      = vntFileName(i)
                strWebRsvNo         = ""
                strWebDocJud        = ""
                strWebDocGf         = ""
                strWebDocCf         = ""

                strBgColor          = "#FFFFFF"
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

                    strBgColor          = "#EEEEEE"
                End If
%>
                <TR HEIGHT="18" BGCOLOR="#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>" onMouseOver="this.style.backgroundColor='E8EEFC'"; onMouseOut="this.style.backgroundColor='#<%= IIf(i Mod 2 = 0, "FFFFFF", "EEEEEE") %>'">
                    <TD NOWRAP><%= strWebCslDate        %></TD>
                    <TD NOWRAP>
                        <A HREF="javascript:callMenResult(<%= vntRsvNo(i) %>,'',<%= vntCsCd(i) %>,<%= vntResultDispMode(i) %>)" TARGET="_top"><%= strWebJudClassName   %></A>
                        <INPUT TYPE="hidden"    NAME="rsvNo"        VALUE="<%= vntRsvNo(i) %>">
                        <INPUT TYPE="hidden"    NAME="judClassCd"   VALUE="<%= vntJudClassCd(i) %>">
                    </TD>
                    <TD ALIGN="center" NOWRAP  <% If vntJudCd(i) <> "" and vntJudCd(i) <> vntRslJudCd(i) Then %>BGCOLOR="#FFC0CB"<% End If %> >
                        <%= strWebJudCd          %>
                        <INPUT TYPE="hidden"    NAME="judCd"   VALUE="<%= vntJudCd(i) %>">
                    </TD>
                    <TD ALIGN="center" NOWRAP  <% If vntJudCd(i) <> "" and vntJudCd(i) <> vntRslJudCd(i) Then %>BGCOLOR="#FFC0CB"<% End If %> >
                        <%= strWebRslJudCd       %>
                        <INPUT TYPE="hidden"    NAME="rslJudCd"   VALUE="<%= vntRslJudCd(i) %>">
                    </TD>
                    <TD NOWRAP>
                    <%
                        If vntEquipDiv(i) = ""  Then
                    %>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="0" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "0", " CHECKED", "") %>>�񎟌����ꏊ����<BR>
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="1" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "1", " CHECKED", "") %>>���Z���^�[
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="2" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "2", " CHECKED", "") %>>�{�@
                        <INPUT TYPE="radio"  NAME="radioEquipDiv<%= i %>" VALUE="3" ONCLICK="javascript:setRadio(<%= i %>,this)" <%= IIf(vntEquipDiv(i) = "3", " CHECKED", "") %>>���@
                    <%  Else
                            Select Case vntEquipDiv(i)
                               Case 0
                                    strWebEquipDivName = "�񎟌����ꏊ����"
                               Case 1
                                    strWebEquipDivName = "���Z���^�["
                               Case 2
                                    strWebEquipDivName = "�{�@"
                               Case 3
                                    strWebEquipDivName = "���@"
                            End Select
                    %>
                              <%= strWebEquipDivName    %>
                    <%  End If  %>
                        <INPUT TYPE="hidden" NAME="equipDiv">
                    </TD>
                    <TD NOWRAP><%= strWebDocJud         %></TD>
                    <TD NOWRAP><%= strWebDocGf          %></TD>
                    <TD NOWRAP><%= strWebDocCf          %></TD>
                    <TD NOWRAP>
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADING="1">
                            <TR>
                                <%
                                    If vntEquipDiv(i) = "3" Then
                                %>
                                        <TD><IMG SRC="/webHains/images/follow_print.gif" WIDTH="20" HEIGHT="20" ALT="�˗���쐬"></TD>
                                <%  Else    %>
                                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="20"></TD>
                                <%  End If  %>

                                <%
                                    If vntEquipDiv(i) = "0" or vntEquipDiv(i) = "1" or vntEquipDiv(i) = "2" or (vntEquipDiv(i) = "2" and vntFileName(i) <> "") Then
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
                strBeforeRsvNo = vntRsvno(i)
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
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>