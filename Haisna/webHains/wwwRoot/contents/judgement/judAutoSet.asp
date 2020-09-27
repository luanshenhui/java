<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �������� (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com 
'                 �X�N���[�j���O��ʂ�������iK.Fujii)
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objJudgement        '����p
Dim objNutritionCalc    '�h�{�v�Z�N���X

'���g�����_�C���N�g����ꍇ�̂ݑ��M�����p�����[�^�l
Dim strAction       '���s���[�h

Dim lngCslYear      '��f�N
Dim lngCslMonth     '��f��
Dim lngCslDay       '��f��
Dim strCslDate      '��f�N����

Dim strCsCd         '�R�[�X�R�[�h
Dim strJudClassCd   '���蕪�ރR�[�h
Dim lngEntryCheck   '�����̓`�F�b�N(0:���Ȃ��A1:����)
Dim lngReJudge      '�Ĕ���(0:���Ȃ��A1:����)

Dim strtodayId      '�����h�c�w����@

Dim lngStartId      '�����h�c�i�͈͎w��F�J�n�j
Dim lngEndId        '�����h�c�i�͈͎w��F�I���j
Dim strPluralId     '�����h�c�i�����w��j

Dim strAutoJud      '��������`�F�b�N
Dim strEiyokeisan   '�h�{�v�Z�`�F�b�N
Dim strActPattern   '�`�^�s���p�^�[���`�F�b�N
Dim strPointLost    '���_����`�F�b�N
Dim strStress       '�X�g���X�v�Z�`�F�b�N
'## 2012.09.11 Add by T.Takagi@RD �H�K���̎�������
Dim strShokushukan  '�H�K���`�F�b�N
'## 2012.09.11 Add End

'### 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɒǉ�
Dim strGyneComment  '���a���ɂ��w�l�ȃR�����g�o�^�`�F�b�N

'### 2008.03.04 �� ���茒�f�i�K�w���j���胍�W�b�N�ǉ�
Dim strSpecialLevel '���茒�f��l�Ɋ�Â��ĊK�w������

Dim vntCalcFlg()    '�v�Z�Ώۃt���O
Dim vntArrDayId     '�����h�c�i�����w��̏ꍇ�̌v�Z�����ւ̈����j
Dim strUpdUser      '�X�V��
Dim strIPAddress    'IP�A�h���X

Dim Ret             '�֐����A�l
Dim strArrMessage   '�G���[���b�Z�[�W�̔z��
Dim strMessage      '�G���[���b�Z�[�W
Dim blnError        '�G���[�t���O
Dim lngCount        '������{����
Dim i               '�J�E���^

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objJudgement = Server.CreateObject("HainsJudgement.JudgementControl")

'���g�����_�C���N�g����ꍇ�̂ݑ��M�����p�����[�^�l�̎擾
strAction       = Request("action")

lngCslYear      = CLng("0" & Request("cslYear"))
lngCslMonth     = CLng("0" & Request("cslMonth"))
lngCslDay       = CLng("0" & Request("cslDay"))
strCsCd         = Request("csCd")
strJudClassCd   = Request("judClassCd")

strAutoJud      = Request("checkAutoJud")
strEiyokeisan   = Request("checkEiyo")
strActPattern   = Request("checkActPattern")
strPointLost    = Request("checkPointLost")
strStress       = Request("checkStress")

'### 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɒǉ�
strGyneComment  = Request("checkGyneComment")
'### 2008.03.04 �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ�
strSpecialLevel = Request("checkSpecialLevel")

'## 2012.09.11 Add by T.Takagi@RD �H�K���̎�������
strShokushukan = Request("checkShokushukan")
'## 2012.09.11 Add End

lngStartId      = Request("startId")
lngEndId        = Request("endId")
strPluralId     = Request("pluralId")

strtodayId      = Request("chktodayId")
strtodayId      = IIf( strtodayId = "", 1, strtodayId )

lngEntryCheck   = Request("valEntryCheck")
lngReJudge      = Request("valReJudge")

lngEntryCheck   = IIf( lngEntryCheck = "", 1, lngEntryCheck )
lngReJudge      = IIf( lngReJudge = "", 0, lngReJudge )

'��f�N�������n����Ă��Ȃ��ꍇ�A�V�X�e���N������K�p����
lngCslYear      = IIf(lngCslYear  = 0, Year(Now),  lngCslYear)
lngCslMonth     = IIf(lngCslMonth = 0, Month(Now), lngCslMonth)
lngCslDay       = IIf(lngCslDay   = 0, Day(Now),   lngCslDay)

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

    '����������{�v���H
    If strAction = "auto" Then
        blnError = False

        '��f���`�F�b�N
        Do

            '�K�{�`�F�b�N
            If lngCslYear = 0 And lngCslMonth = 0 And lngCslDay = 0 Then
                objCommon.AppendArray strArrMessage, "��f������͂��ĉ������B"
                blnError = True
                Exit Do
            End If

            '��f�N�����̕ҏW
            strCslDate = lngCslYear & "/" & lngCslMonth & "/" & lngCslDay

            '��f�N�����̓��t�`�F�b�N
            If Not IsDate(strCslDate) Then
                objCommon.AppendArray strArrMessage, "��f���̓��͌`��������������܂���B"
                blnError = True
                Exit Do
            End If

            '�����w�莞����ID�̕ҏW
            If strtodayId = 2 Then
                vntArrDayId = split( strPluralId, "," )
            Else
                vntArrDayId = Array()
                Redim Preserve vntArrDayId(0)
            End If
            '����ID�̃`�F�b�N
            If strtodayId = 1 Then
                strMessage = objCommon.CheckNumeric("����ID", lngStartId, LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
                If strMessage <> "" Then
                    objCommon.AppendArray strArrMessage, strMessage
                    blnError = True
                    Exit Do
                End If

                strMessage = objCommon.CheckNumeric("����ID", lngEndId, LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
                If strMessage <> "" Then
                    objCommon.AppendArray strArrMessage, strMessage
                    blnError = True
                    Exit Do
                End If
            Else
                For i=0 To UBound(vntArrDayId)
                strMessage = objCommon.CheckNumeric("����ID", vntArrDayId(i), LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
                    If strMessage <> "" Then
                        objCommon.AppendArray strArrMessage, strMessage
                        blnError = True
                        Exit Do
                    End If
                Next
            End If

            Exit Do
        Loop


        '�G���[���ݎ��͏������I������
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        '### 2008.03.04 �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ��ɂ���ďC��
        'Redim Preserve vntCalcFlg(5)
'## 2012.09.11 Update by T.Takagi@RD �H�K���̎�������
        'Redim Preserve vntCalcFlg(6)
        Redim Preserve vntCalcFlg(7)
'## 2012.09.11 Update End
        If strActPattern = "1" Then
            vntCalcFlg(0) = 1
        Else
            vntCalcFlg(0) = 0
        End If
        If strPointLost = "1" Then
            vntCalcFlg(1) = 1
        Else
            vntCalcFlg(1) = 0
        End If
        If strEiyokeisan = "1" Then
            vntCalcFlg(2) = 1
        Else
            vntCalcFlg(2) = 0
        End If
        If strStress = "1" Then
            vntCalcFlg(3) = 1
        Else
            vntCalcFlg(3) = 0
        End If
        If strAutoJud = "1" Then
            vntCalcFlg(4) = 1
        Else
            vntCalcFlg(4) = 0
        End If

'### 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɒǉ� Start
        If strGyneComment = "1" Then
            vntCalcFlg(5) = 1
        Else
            vntCalcFlg(5) = 0
        End If
'### 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɒǉ� End

'### 2008.03.04 �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ� Start
        If strSpecialLevel = "1" Then
            vntCalcFlg(6) = 1
        Else
            vntCalcFlg(6) = 0
        End If
'### 2008.03.04 �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ� End

'## 2012.09.11 Add by T.Takagi@RD �H�K���̎�������
        If strShokushukan = "1" Then
            vntCalcFlg(7) = 1
        Else
            vntCalcFlg(7) = 0
        End If
'## 2012.09.11 Add End

        '�������肪�I������Ă���Ƃ��́u�`�^�s���p�^�[���A���_����A�X�g���X�_���v �����킹�Čv�Z����
        If vntCalcFlg(4) = 1 Then
            vntCalcFlg(0) = 1
            vntCalcFlg(1) = 1
            vntCalcFlg(3) = 1
        End If

        strUpdUser        = Session.Contents("userId")
        strIPAddress      = Request.ServerVariables("REMOTE_ADDR")

'        response.write "strUpdUser = " & strUpdUser & vbcrlf
'        response.write "strIPAddress = " & strIPAddress & vbcrlf
'        response.write "strCslDate = " & strCslDate & vbcrlf
'        response.write "strtodayId = " & strtodayId & vbcrlf
'        response.write lngStartId
'        response.write lngEndId
'        response.write "strCsCd = " & strCsCd & vbcrlf
'        response.write "strJudClassCd = " & strJudClassCd & vbcrlf
'        response.write "lngEntryCheck = " = lngEntryCheck & vbcrlf
'        response.write "lngReJudge = " = lngReJudge & vbcrlf
'        response.end

        '���胁�C���Ăяo��
        Ret = objJudgement.JudgeAutomaticallyMain (strUpdUser, _
                                                strIPAddress, _
                                                strCslDate, _
                                                vntCalcFlg, _
                                                strtodayId, _
                                                lngStartId, _
                                                lngEndId, _
                                                vntArrDayId, _
                                                "" & strCsCd, _
                                                "" & strJudClassCd, _
                                                lngEntryCheck, _
                                                lngReJudge)
'''     Ret = objJudgement.JudgeAutomatically (strCslDate, "" & strCsCd, "" & strJudClassCd, "" & strPerId, lngEntryCheck, lngReJudge)

        If Ret = True Then
            strAction = "autoend"
        Else
            objCommon.AppendArray strArrMessage, "�������肪�ُ�I�����܂����B�i�ڍׂ́H�j"
        End If

    End If


    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���蕪�ވꗗ�h���b�v�_�E�����X�g�̕ҏW
'
' �����@�@ : (In)     strName                �G�������g��
' �@�@�@�@   (In)     strSelectedJudClassCd  ���X�g�ɂđI�����ׂ����蕪�ރR�[�h
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : �˗����ڔ���O���[�v�ɑ��݂��锻�蕪�ރR�[�h�̂݁A���蕪�ރR�[�h��
'
'-------------------------------------------------------------------------------
Function EditJudClassList(strName, strSelectedJudClassCd)

    Dim objJudClass         '�˗����ڔ��蕪�ޏ��A�N�Z�X�p

    Dim strJudClassCd       '���蕪�ރR�[�h
    Dim strJudClassName     '���蕪�ޖ���
    Dim strAllJudFlg        '���v�p��������t���O
    Dim strCommentOnly      '�R�����g�\�����[�h

    Dim strJudClassCd2()    '���蕪�ރR�[�h
    Dim strJudClassName2()  '���蕪�ޖ���

    Dim i, j                '�C���f�b�N�X

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudClass = Server.CreateObject("HainsJudClass.JudClass")

    '���蕪�ޏ��̓ǂݍ���
    If objJudClass.SelectJudClassList(strJudClassCd, strJudClassName, strAllJudFlg,,, strCommentOnly) <= 0 Then
        Exit Function
    End If

    '��������p�̔��蕪�ވȊO�𒊏o
    '�R�����g�\���݂̂��ΏۊO
    j = 0
    For i = 0 To UBound(strJudClassCd)
        If strAllJudFlg(i) = "0"  And strCommentOnly(i) <> "1" Then
            ReDim Preserve strJudClassCd2(j)
            ReDim Preserve strJudClassName2(j)
            strJudClassCd2(j)   = strJudClassCd(i)
            strJudClassName2(j) = strJudClassName(i)
            j = j + 1
        End If
    Next

    '��������p�̔��蕪�ވȊO�����݂��Ȃ���Ή������Ȃ�
    If j = 0 Then
        Exit Function
    End If

    '�h���b�v�_�E�����X�g�̕ҏW
    EditJudClassList = EditDropDownListFromArray(strName, strJudClassCd2, strJudClassName2, strSelectedJudClassCd, SELECTED_ALL)

End Function

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<TITLE>��������</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

//�����h�c�`�F�b�N
function checktodayIdAct(index) {

    with ( document.entryForm ) {
        if (index == 0 ){
            todayId.value = (todayId[index].checked ? '1' : '');
        } else if (index == 1 ){
            todayId.value = (todayId[index].checked ? '2' : '');
        }
        chktodayId.value = todayId.value;
    }

}

//��������`�F�b�N
function checkAutoJudAct() {

    with ( document.entryForm ) {
        checkAutoJud.value = (checkAutoJud.checked ? '1' : '');
    }

}
//�h�{�v�Z�`�F�b�N
function checkEiyoAct() {

    with ( document.entryForm ) {
        checkEiyo.value = (checkEiyo.checked ? '1' : '');
    }

}
//�`�^�s���p�^�[���`�F�b�N
function checkActPatternAct() {

    with ( document.entryForm ) {
        checkActPattern.value = (checkActPattern.checked ? '1' : '');
    }

}
//���_����`�F�b�N
function checkLostPointAct() {

    with ( document.entryForm ) {
        checkPointLost.value = (checkPointLost.checked ? '1' : '');
    }

}
//�X�g���X�_���`�F�b�N
function checkStressAct() {

    with ( document.entryForm ) {
        checkStress.value = (checkStress.checked ? '1' : '');
    }

}

/** 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɒǉ� Start **/
//�w�l�ȃR�����g�`�F�b�N
function checkGyneCommentAct() {
    with ( document.entryForm ) {
        checkGyneComment.value = (checkGyneComment.checked ? '1' : '');
    }
}
/** 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɒǉ� End   **/

/** 2008.03.04 �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ� Start **/
//���茒�f�`�F�b�N
function checkSpecialLevelAct() {
    with ( document.entryForm ) {
        checkSpecialLevel.value = (checkSpecialLevel.checked ? '1' : '');
    }
}
/** 2008.03.04 �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ� End   **/
<% '## 2012.09.11 Add by T.Takagi@RD �H�K���̎������� %>
// �H�K���`�F�b�N
function checkShokushukanAct() {

    with ( document.entryForm ) {
        checkShokushukan.value = (checkShokushukan.checked ? '1' : '');
    }

}
<% '## 2012.09.11 Add End %>
// ����������s
function autoJudExe() {

    var myForm;

    myForm = document.entryForm;

    if ( myForm.todayId[0].checked ){
        if ( myForm.startId.value == '' ||
             myForm.endId.value == '' ){
            alert( "�����h�c���w�肳��Ă��܂���B");
            return;
        }
    }else if ( myForm.todayId[1].checked ){
        if ( myForm.pluralId.value == '' ){
            alert( "�����h�c���w�肳��Ă��܂���B");
            return;
        }
    }

/** 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɕύX Start **/
    /*
    if (myForm.checkAutoJud.value == '' &&
        myForm.checkEiyo.value == '' &&
        myForm.checkActPattern.value == '' &&
        myForm.checkPointLost.value == '' &&
        myForm.checkStress.value == '' ){
        alert( "�v�Z�Ώۂ��w�肳��Ă��܂���B" );
        return;
    }
    */
    /** 2008.03.04 �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ� Start **/
    /*
    if (myForm.checkAutoJud.value == '' &&
        myForm.checkEiyo.value == '' &&
        myForm.checkActPattern.value == '' &&
        myForm.checkPointLost.value == '' &&
        myForm.checkStress.value == '' &&
        myForm.checkGyneComment.value == '' ){
        alert( "�v�Z�Ώۂ��w�肳��Ă��܂���B" );
        return;
    }
    */
	/* ## 2012.09.11 Update by T.Takagi@RD �H�K���̎������� */
	/*
    if (myForm.checkAutoJud.value == '' &&
        myForm.checkEiyo.value == '' &&
        myForm.checkActPattern.value == '' &&
        myForm.checkPointLost.value == '' &&
        myForm.checkStress.value == '' &&
        myForm.checkGyneComment.value == '' &&
        myForm.checkSpecialLevel.value == '' ){
        alert( "�v�Z�Ώۂ��w�肳��Ă��܂���B" );
        return;
    }
	*/
    if (myForm.checkAutoJud.value == '' &&
        myForm.checkShokushukan.value == '' &&
        myForm.checkEiyo.value == '' &&
        myForm.checkActPattern.value == '' &&
        myForm.checkPointLost.value == '' &&
        myForm.checkStress.value == '' &&
        myForm.checkGyneComment.value == '' &&
        myForm.checkSpecialLevel.value == '' ){
        alert( "�v�Z�Ώۂ��w�肳��Ă��܂���B" );
        return;
    }
	/* ## 2012.09.11 Update End */
    /** 2008.03.04 �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ� End   **/
/** 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɕύX End   **/

    // ��������̂Ƃ�
    if (myForm.checkAutoJud.value != '' ) {
        if ( myForm.entryCheck[0].checked ){
            if( !confirm( '���ʂ������Ă��Ȃ���ԂŎ���������s���܂��B��낵���ł����H' )) {
                return;
            }
            myForm.valEntryCheck.value = 0;
        } else {
            myForm.valEntryCheck.value = 1;
        }

        if ( myForm.reJudge[1].checked ){
            if ( !confirm( '���ɔ���A�y�уR�����g���Z�b�g����Ă���ꍇ�A���̓��e��j�����čĎ���������s�Ȃ��܂��B��낵���ł����H' )) {
                return;
            }
            myForm.valReJudge.value = 1;
        } else {
            myForm.valReJudge.value = 0;
        }
    }

    myForm.action.value = 'auto';
    myForm.submit();

}

function closeWindow() {

    calGuide_closeGuideCalendar();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.judtab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" >
    <INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>">
    <BLOCKQUOTE>
    
    <!-- �\�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="judgement">��</SPAN><FONT COLOR="#000000">��������</FONT></B></TD>
        </TR>
    </TABLE>
<%
    '���b�Z�[�W�̕ҏW
    If strAction <> "" Then

        Select Case strAction

            '�ۑ��������́u����I���v�̒ʒm
            Case "autoend"
                Call EditMessage("�������肪����I�����܂����B", MESSAGETYPE_NORMAL)

            '�����Ȃ��΃G���[���b�Z�[�W��ҏW
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

    End If
%>
    <BR>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="100" NOWRAP>��f��</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
                        <TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
                        <TD>�N</TD>
                        <TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
                        <TD>��</TD>
                        <TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>��</TD>
            <TD WIDTH="100" NOWRAP>�R�[�X</TD>
            <TD>�F</TD>
            <TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, "���ׂẴR�[�X", False) %></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <INPUT TYPE="hidden" NAME="chktodayId" VALUE="<%= strtodayId %>" >
        <TR>
            <TD>��</TD>
            <TD WIDTH="100" NOWRAP>����ID</TD>
            <TD>�F</TD>
            <TD NOWRAP><INPUT TYPE="radio" NAME="todayId" VALUE="<%= strtodayId %>" <%= IIf(strtodayId = "1", " CHECKED", "") %> ONCLICK="javascript:checktodayIdAct(0)" BORDER="0">�͈͎w��<INPUT TYPE="text" NAME="startId" VALUE="<%= lngStartId %>" SIZE="6" BORDER="0" STYLE="ime-mode:disabled;">�`<INPUT TYPE="text" NAME="endId" VALUE="<%= lngEndId %>" SIZE="6" BORDER="0" STYLE="ime-mode:disabled;"></SPAN></TD>
        </TR>
        <TR>
            <TD></TD>
            <TD WIDTH="100" NOWRAP></TD>
            <TD></TD>
            <TD NOWRAP><INPUT TYPE="radio" NAME="todayId" VALUE="<%= strtodayId %>" <%= IIf(strtodayId = "2", " CHECKED", "") %> ONCLICK="javascript:checktodayIdAct(1)"  BORDER="0">�����w��<INPUT TYPE="text" NAME="pluralId" VALUE="<%= strPluralId %>" SIZE="35" BORDER="0" STYLE="ime-mode:disabled;"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>��</TD>
            <TD WIDTH="100" NOWRAP>�v�Z�Ώ�</TD>
            <TD>�F</TD>
            <TD><INPUT type="checkbox" name="checkAutoJud" value="<%= strAutoJud %>" <%= IIf(strAutoJud <> "", " CHECKED", "") %> ONCLICK="javascript:checkAutoJudAct()" border="0">��������</TD>
<% '## 2012.09.11 Add by T.Takagi@RD �H�K���̎������� %>
            <TD><INPUT type="checkbox" name="checkShokushukan" value="<%= strShokushukan %>" <%= IIf(strShokushukan <> "", " CHECKED", "") %> ONCLICK="javascript:checkShokushukanAct()" border="0">�H�K��</TD>
<% '## 2012.09.11 Add End %>
            <TD><INPUT type="checkbox" name="checkEiyo" value="<%= strEiyokeisan %>" <%= IIf(strEiyokeisan <> "", " CHECKED", "") %> ONCLICK="javascript:checkEiyoAct()" border="0">�h�{�v�Z</TD>
            <TD><INPUT type="checkbox" name="checkActPattern" value="<%= strActPattern %>" <%= IIf(strActPattern <> "", " CHECKED", "") %> ONCLICK="javascript:checkActPatternAct()" border="0">�`�^�s���p�^�[��</TD>
            <TD><INPUT type="checkbox" name="checkPointLost" value="<%= strPointLost %>" <%= IIf(strPointLost <> "", " CHECKED", "") %> ONCLICK="javascript:checkLostPointAct()" border="0">���_����</td>
            <TD><INPUT type="checkbox" name="checkStress" value="<%= strStress %>" <%= IIf(strStress <> "", " CHECKED", "") %> ONCLICK="javascript:checkStressAct()" border="0">�X�g���X�_��</td>
            <!--## 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɒǉ� Start ##-->
            <TD><INPUT type="checkbox" name="checkGyneComment" value="<%= strGyneComment %>" <%= IIf(strGyneComment <> "", " CHECKED", "") %> ONCLICK="javascript:checkGyneCommentAct()" border="0">�w�l�ȃR�����g</td>
            <!--## 2006.04.26 �� ���a���֘A�R�����g�o�^���W�b�N����w�l�Ȋ֘A�R�����g��ʓr�Ǘ����邽�߂ɒǉ� End   ##-->

            <!--## 2008.03.04 �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ� Start ##-->
            <TD><INPUT type="checkbox" name="checkSpecialLevel" value="<%= strSpecialLevel %>" <%= IIf(strSpecialLevel <> "", " CHECKED", "") %> ONCLICK="javascript:checkSpecialLevelAct()" border="0">���茒�f</td>
            <!--## 2008.03.04 �� �� ���茒�f�i�K�w���j�������胍�W�b�N�ǉ� End   ##-->
        </TR>
    </TABLE>
    
    <BR>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TD>�ȉ��͎�������݂̂ɓK�p</TD>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <TD>��</TD>
            <TD WIDTH="100" NOWRAP>���蕪��</TD>
            <TD>�F</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><%= EditJudClassList("judClassCd", strJudClassCd) %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
        <TR>
            <INPUT TYPE="hidden" NAME="valEntryCheck" VALUE="<%= lngEntryCheck %>">
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="100" NOWRAP>�����̓`�F�b�N</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="radio" NAME="entryCheck" VALUE="0" <%= IIf(lngEntryCheck = 0, "CHECKED", "") %>></TD>
            <TD>���Ȃ�</TD>
            <TD><INPUT TYPE="radio" NAME="entryCheck" VALUE="1" <%= IIf(lngEntryCheck = 1, "CHECKED", "") %>></TD>
            <TD>����</TD>
        </TR>
        <TR>
            <INPUT TYPE="hidden" NAME="valReJudge" VALUE="<%= lngReJudge %>">
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD>�Ĕ���</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="radio" NAME="reJudge" VALUE="0" <%= IIf(lngReJudge = 0, "CHECKED", "") %>></TD>
            <TD>���Ȃ�</TD>
            <TD><INPUT TYPE="radio" NAME="reJudge" VALUE="1" <%= IIf(lngReJudge = 1, "CHECKED", "") %>></TD>
            <TD>����</TD>
        </TR>
    </TABLE>

    <BR>

    <A HREF="judMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
    <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
    <A HREF="javascript:autoJudExe()"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="������������s"></A>
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
    <BR><BR>

<!--
    <A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGSCREENING"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���O���Q�Ƃ���"></A>
-->

    </BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
