<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      �������`�F�b�N���X�g����  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_NAISHIKYOU  = "X024"                '�������`�F�b�N���X�g���̓O���[�v�R�[�h

'### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�ǉ� STR ####################################
Const GRPCD_NAISHIKYOU_NEW  = "X0241"           '�������`�F�b�N���X�g���̓O���[�v�R�[�h
Const CHANGE_CSLDATE        = "2016/06/13"      '�������`�F�b�N���X�g���͉�ʐؑ֎�f��
'### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�ǉ� END ####################################

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objInterView        '�ʐڏ��A�N�Z�X�p
Dim objResult           '�������ʃA�N�Z�X�pCOM�I�u�W�F�N�g
'### 2004/01/23 Start K.Kagawa �������`�F�b�N���X�g�̕ۑ��m�F��ǉ�
Dim objRslOcr           'OCR���͌��ʃA�N�Z�X�p
'### 2004/01/23 End

'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
Dim objConsult              '��f�N���X
Dim objFree                 '�ėp���A�N�Z�X�p
'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� END ##############################################


'�p�����[�^
Dim strWinMode          '�E�B���h�E���[�h
Dim lngRsvNo            '�\��ԍ��i���񕪁j
Dim strGrpNo            '�O���[�vNo
Dim strCsCd             '�R�[�X�R�[�h
Dim strAction           '�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")

'### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�ǉ� STR ####################################
Dim strRslGrpCd         '�������`�F�b�N���X�g���̓O���[�v�R�[�h�ݒ�
'### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�ǉ� END ####################################


'�������ʏ��
Dim vntPerId            '�lID
Dim vntCslDate          '�������ڃR�[�h
Dim vntHisNo            '����No.
Dim vntRsvNo            '�\��ԍ�
Dim vntItemCd           '�������ڃR�[�h
Dim vntSuffix           '�T�t�B�b�N�X
Dim vntResultType       '���ʃ^�C�v
Dim vntItemType         '���ڃ^�C�v
Dim vntItemName         '�������ږ���
Dim vntResult           '��������
Dim vntRslValue         '��������
Dim vntUnit             '�P��
Dim vntItemQName        '��f����
Dim vntGrpSeq           '�\������
Dim vntRslFlg           '�������ʑ��݃t���O
Dim lngRslCnt           '�������ʐ�

'�������ʍX�V���
Dim vntUpdItemCd        '�������ڃR�[�h
Dim vntUpdSuffix        '�T�t�B�b�N�X
Dim vntUpdResult        '��������
Dim strArrMessage       '�G���[���b�Z�[�W

Dim strMessage          '�G���[���b�Z�[�W

Dim strUpdUser          '�X�V��
Dim strIPAddress        'IP�A�h���X

Dim lngIndex            '�C���f�b�N�X
Dim Ret                 '���A�l
Dim Ret2                '���A�l
Dim strHTML             'HTML������
Dim i, j                '�J�E���^�[

'### 2004/01/23 Start K.Kagawa �������`�F�b�N���X�g�̕ۑ��m�F��ǉ�
Dim vntGFCheckList      '�������`�F�b�N���X�g�̏��
'### 2004/01/23 End


'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� STR ##############################################

Dim strPerId                '�lID
Dim strCslDate              '��f��
Dim strCsName               '�R�[�X��
Dim strLastName             '��
Dim strFirstName            '��
Dim strLastKName            '�J�i��
Dim strFirstKName           '�J�i��
Dim strBirth                '���N����
Dim strAge                  '�N��
Dim strGender               '����
Dim strGenderName           '���ʖ���
Dim strDayId                '����ID
Dim strOrgName              '�c�̖���

Dim strEraBirth             '���N����(�a��)
Dim strRealAge              '���N��

Dim lngConsCount            '��f��
Dim lngCnt

'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� END ##############################################


'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterView    = Server.CreateObject("HainsInterView.InterView")

'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
'### 2016.01.28 �� �l���ǉ��ׁ̈A�C�� END ##############################################

'�����l�̎擾
strWinMode          = Request("winmode")
strGrpNo            = Request("grpno")
lngRsvNo            = Request("rsvno")
strCsCd             = Request("cscd")
strAction           = Request("act")

'�������ʍX�V���
vntUpdItemCd        = ConvIStringToArray(Request("ItemCd"))
vntUpdSuffix        = ConvIStringToArray(Request("Suffix"))
vntUpdResult        = ConvIStringToArray(Request("ChgRsl"))

Do
    '�ۑ�
    If strAction = "save" Then
        If Not IsEmpty(vntUpdItemCd) Then
            '�X�V�҂̐ݒ�
            strUpdUser = Session("USERID")
            'IP�A�h���X�̎擾
            strIPAddress = Request.ServerVariables("REMOTE_ADDR")

            '�I�u�W�F�N�g�̃C���X�^���X�쐬
            Set objResult  = Server.CreateObject("HainsResult.Result")

            '�������ʍX�V
            Ret = objResult.UpdateResultNoCmt( lngRsvNo, strIPAddress, strUpdUser, vntUpdItemCd, vntUpdSuffix, vntUpdResult, strArrMessage )

            '�I�u�W�F�N�g�̃C���X�^���X�폜
            Set objResult = Nothing

            If Ret Then
                '�ۑ�����
                strAction = "saveend"

                '### 2016.12.16 �� �������`�F�b�N���X�g�o�^��͕K���U���o�H�ύX���s���悤�Ɏd�l�ǉ� STR ###
                '�I�u�W�F�N�g�̃C���X�^���X�쐬
                Set objResult  = Server.CreateObject("HainsResult.Result")
                '�������ʍX�V
                Ret2 = objResult.UpdateYudo( lngRsvNo, strUpdUser, strMessage )
                '�I�u�W�F�N�g�̃C���X�^���X�폜
                Set objResult = Nothing
                '### 2016.12.16 �� �������`�F�b�N���X�g�o�^��͕K���U���o�H�ύX���s���悤�Ɏd�l�ǉ� END ###

'### 2004/01/23 Start K.Kagawa �������`�F�b�N���X�g�̕ۑ��m�F��ǉ�
                '�������`�F�b�N���X�g�̏�Ԏ擾
                Set objRslOcr = Server.CreateObject("HainsRslOcr.OcrNyuryoku")
                Ret = objRslOcr.CheckGF( lngRsvNo, vntGFCheckList )
                Set objRslOcr = Nothing
                If Ret < 0 Then
                    Err.Raise 1000, , "�������`�F�b�N���X�g�̏�Ԃ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
                End If
'### 2004/01/23 End
            End If
        End If
    End If

'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , _
                                    strCslDate, _
                                    strPerId, _
                                    strCsCd, _
                                    strCsName, _
                                    , , _
                                    strOrgName, _
                                    , , _
                                    strAge, _
                                    , , , , , , , , , , , , _
                                    strDayId, _
                                    , , 0, , , , , , , , , , , , , , , _
                                    strLastName, _
                                    strFirstName, _
                                    strLastKName, _
                                    strFirstKName, _
                                    strBirth, _
                                    strGender, _
                                    , , , , , , lngConsCount )

    '### ��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ��� ###
    If Ret = False Then
        Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
    End If

    '���N����(����{�a��)�̕ҏW
    strEraBirth = objCommon.FormatString(CDate(strBirth), "ge�iyyyy�j.m.d")

    '���N��̌v�Z
    If strBirth <> "" Then
        Set objFree = Server.CreateObject("HainsFree.Free")
        strRealAge = objFree.CalcAge(strBirth)
        Set objFree = Nothing
    Else
        strRealAge = ""
    End If

    '�����_�ȉ��̐؂�̂�
    If IsNumeric(strRealAge) Then
        strRealAge = CStr(Int(strRealAge))
    End If

    Set objConsult = Nothing

'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� END ##############################################

    '�w��Ώێ�f�҂̌������ʂ��擾����

''### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�ǉ� STR ####################################
''    lngRslCnt = objInterView.SelectHistoryRslList( _
''                        lngRsvNo, _
''                        1, _
''                        GRPCD_NAISHIKYOU, _
''                        0, _
''                        "", _
''                        0, _
''                        0, _
''                        1, _
''                        vntPerId, _
''                        vntCslDate, _
''                        vntHisNo, _
''                        vntRsvNo, _
''                        vntItemCd, _
''                        vntSuffix, _
''                        vntResultType, _
''                        vntItemType, _
''                        vntItemName, _
''                        vntResult, _
''                        vntRslValue, _
''                        , , , , , _
''                        vntUnit, _
''                        , , , , , _
''                        vntItemQName, _
''                        vntGrpSeq, _
''                        vntRslFlg _
''                        )

    If CDate(strCslDate) >= CDate(CHANGE_CSLDATE) Then
        strRslGrpCd = GRPCD_NAISHIKYOU_NEW
    Else
        strRslGrpCd = GRPCD_NAISHIKYOU
    End If

''    lngRslCnt = objInterView.SelectHistoryRslList( _
''                        lngRsvNo, _
''                        1, _
''                        strRslGrpCd, _
''                        0, _
''                        "", _
''                        0, _
''                        0, _
''                        1, _
''                        vntPerId, _
''                        vntCslDate, _
''                        vntHisNo, _
''                        vntRsvNo, _
''                        vntItemCd, _
''                        vntSuffix, _
''                        vntResultType, _
''                        vntItemType, _
''                        vntItemName, _
''                        vntResult, _
''                        vntRslValue, _
''                        , , , , , _
''                        vntUnit, _
''                        , , , , , _
''                        vntItemQName, _
''                        vntGrpSeq, _
''                        vntRslFlg _
''                        )

    lngRslCnt = objInterView.SelectHistoryRslList( _
                        lngRsvNo, _
                        1, _
                        strRslGrpCd, _
                        1, _
                        strCsCd, _
                        0, _
                        0, _
                        1, _
                        vntPerId, _
                        vntCslDate, _
                        vntHisNo, _
                        vntRsvNo, _
                        vntItemCd, _
                        vntSuffix, _
                        vntResultType, _
                        vntItemType, _
                        vntItemName, _
                        vntResult, _
                        vntRslValue, _
                        , , , , , _
                        vntUnit, _
                        , , , , , _
                        vntItemQName, _
                        vntGrpSeq, _
                        vntRslFlg _
                        )

''### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�ǉ� END ####################################

    If lngRslCnt < 0 Then
        Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
    End If


    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �������ʂ̃^�O����
'
' �����@�@ : (In)     vntIndex          �擪�C���f�b�N�X
' �@�@�@�@   (In)     vntType           INPUT�̑���(TYPE)
' �@�@�@�@   (In)     vntName           INPUT�̑���(NAME)
' �@�@�@�@   (In)     vntSize           INPUT�̑���(SIZE)
' �@�@�@�@   (In)     vntOnValue        INPUT�̑���(VALUE) �����W�I�{�^���̂ݎg�p
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditRsl(vntIndex, vntType, vntName, vntSize, vntOnValue)
    Dim strFuncName

    EditRsl = ""
    strFuncName = "javascript:document.entryForm.ChgRsl[" & vntIndex & "].value = this.value"

    Select Case vntType
    Case "text"         '�e�L�X�g
        EditRsl = "<INPUT TYPE=""text"" NAME=""" & vntName & """ SIZE=""" & vntSize & """  MAXLENGTH=""8"" STYLE=""text-align:right"" VALUE=""" & vntRslValue(vntIndex) & """"
        EditRsl = EditRsl & " ONCHANGE=""" & strFuncName & """>"

    Case "checkbox"     '�`�F�b�N�{�b�N�X
        EditRsl = "<INPUT TYPE=""checkbox"" NAME=""" & vntName & """ VALUE=""" & vntOnValue & """" & IIf(vntRslValue(lngIndex)=vntOnValue, " CHECKED", "")
        EditRsl = EditRsl & " ONCLICK=""javascript:clickRsl( this, " & vntIndex & ")"">"

    Case "radio"        '���W�I�{�^��
        EditRsl = "<INPUT TYPE=""radio"" NAME=""" & vntName & """ VALUE=""" & vntOnValue & """" & IIf(vntRslValue(lngIndex)=vntOnValue, " CHECKED", "")
        EditRsl = EditRsl & " ONCLICK=""javascript:clickRsl( this, " & vntIndex & ")"">"

    End Select

End Function
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������`�F�b�N���X�g����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �������ʂ̑I��������
function clickRsl( Obj, Index ) {

    // �G�������g�^�C�v���Ƃ̏�������
    switch ( Obj.type ) {
        case 'checkbox':    // �`�F�b�N�{�b�N�X
            if( Obj.checked ) {
                document.entryForm.ChgRsl[Index].value = Obj.value
            } else {
                document.entryForm.ChgRsl[Index].value = '';
            }
            break;

        case 'radio':       // ���W�I�{�^��
            // �I���ς݂�������x�N���b�N����ƑI������
            if( document.entryForm.ChgRsl[Index].value == Obj.value ) {
                Obj.checked = false;
                document.entryForm.ChgRsl[Index].value = '';
            } else {
                Obj.checked = true;
                document.entryForm.ChgRsl[Index].value = Obj.value
            }
            break;

        default:
            break;
    }

}

//�ۑ�
function saveNaishikyou() {

    // ���[�h���w�肵��submit
    document.entryForm.act.value = 'save';
    document.entryForm.submit();

    return;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
    body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <!-- �����l -->
    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
    <INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAction %>">

    <INPUT TYPE="hidden" NAME="before_url"     VALUE="<%= Request.ServerVariables("HTTP_REFERER") %>">

    
<!-- ### 2004/01/23 Start K.Kagawa �������`�F�b�N���X�g�̕ۑ��m�F��ǉ� -->
<INPUT TYPE="hidden" NAME="GFCheckList"   VALUE="<%= vntGFCheckList %>">
<!-- ### 2004/01/23 End -->

    <!-- �^�C�g���̕\�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="">���������`�F�b�N���X�g����</SPAN></B></TD>
        </TR>
    </TABLE>
    <BR>
<%
    '���b�Z�[�W�̕ҏW
    If strAction <> "" Then

        '�ۑ��������́u�ۑ������v�̒ʒm
        If strAction = "saveend" Then
            Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

        '�����Ȃ��΃G���[���b�Z�[�W��ҏW
        Else
            Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
        End If

    End If
%>

<%
    '### 2016.02.01 �� �U����ʂ���̌ďo���ȊO�͎�f�Ҍl���\�� STR #######################
    If InStr(Request.ServerVariables("HTTP_REFERER"), ".jsp") = 0  Then
%>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR>
            <TD NOWRAP>��f���F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
            <TD NOWRAP>&nbsp;&nbsp;�R�[�X�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD NOWRAP>&nbsp;&nbsp;�����h�c�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayID, "0000") %></B></FONT></TD>
            <TD NOWRAP>&nbsp;&nbsp;�c�́F</TD>
            <TD NOWRAP><%= strOrgName %></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD NOWRAP><B><%= strPerId %></B>&nbsp;&nbsp;</TD>
            <TD NOWRAP><B><%= strLastName & " " & strFirstName %></B> �i<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>�j&nbsp;&nbsp;</TD>
            <TD NOWRAP><%= FormatDateTime(strBirth, 1) %>���@<%= strRealAge %>�΁i<%= Int(strAge) %>�΁j&nbsp;&nbsp;<%= IIf(strGender = "1", "�j��", "����") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP>&nbsp;&nbsp;��f�񐔁F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngConsCount %></B></FONT>&nbsp;&nbsp;</TD>
        </TR>
    </TABLE>
    <BR>
<%
    End If
    '### 2016.02.01 �� �U����ʂ���̌ďo���ȊO�͎�f�Ҍl���\�� END #######################
%>



    <!-- �������`�F�b�N���X�g�̕\�� -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
<%
    strHTML = ""
lngIndex = 0
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�Ԃ��^�]���Ă��܂������H</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_1", , "0") & "<FONT COLOR=""gray"">�͂�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_1", , "1") & "<FONT COLOR=""gray"">������</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 1
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�����g�D����</TD>" & vbLf
'	strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_2", , "0") & "<FONT COLOR=""gray"">�K�v����]����</FONT></TD>" & vbLf
'	strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_2", , "1") & "<FONT COLOR=""gray"">��]���Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_2", , "0") & "<FONT COLOR=""gray"">�K�v�����ӂ���</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_2", , "1") & "<FONT COLOR=""gray"">���ӂ��Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 2
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�㕔�����Ǔ����������̌o��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_3", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_3", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 3
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���Í܂̊�]</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_4", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_4", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_4", , "2") & "<FONT COLOR=""gray"">��t�Ƒ��k</FONT></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 4
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�L�V���J�C���A�����M�[</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_5", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_5", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
'### 2006/09/25 �� �򕨃A�����M�[�������ڍ폜�y�ђǉ��ɂ��ύX Start ###
'lngIndex = 5
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�򕨃A�����M�[</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 6
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�R�Ìō܂̎g�p</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "2") & "<FONT COLOR=""gray"">�x��</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'### 2006/10/19 �� ���Í܃A�����M�[�������ڍ폜�iDr.�F�q����̈˗��j Start ###
'lngIndex = 5
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���Í܃A�����M�[</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 5
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���[�h�A�����M�[</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_6", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 6
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�򕨃A�����M�[</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_7", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf

lngIndex = 7

'### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�C�� STR ####################################
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�R�Ìō܂̎g�p</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "2") & "<FONT COLOR=""gray"">�x��</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
    If CDate(strCslDate) >= CDate(CHANGE_CSLDATE) Then
        strHTML = strHTML & "<TR>" & vbLf
        strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�R�Ìō܂̎g�p</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    Else
        strHTML = strHTML & "<TR>" & vbLf
        strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�R�Ìō܂̎g�p</TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "0") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "1") & "<FONT COLOR=""gray"">�Ȃ�</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "radio", "opt_8", , "2") & "<FONT COLOR=""gray"">�x��</FONT></TD>" & vbLf
        strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
        strHTML = strHTML & "</TR>" & vbLf
    End If
'### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�C�� END ####################################

'### 2006/09/25 �� �򕨃A�����M�[�������ڍ폜�y�ђǉ��ɂ��ύX End   ###

    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP><IMG SRC=""../../images/spacer.gif"" WIDTH=""1"" HEIGHT=""21"" BORDER=""0""></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf


'### 2006/09/25 �� �R�Ìōܖ�i�\�����ԕύX�̂��ߏC�� Start ###
'lngIndex = 7
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�A���v���[�O</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_1", , "1") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 8
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�y���T���`��</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_2", , "2") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 9
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�v���^�[��</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_3", , "3") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 10
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���[�t�@����</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_4", , "4") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 11
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�o�t�@�����W�P</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_5", , "5") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 12
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�G�p�f�[��</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_6", , "6") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 13
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�p�i���W��</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_7", , "7") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 14
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�h���i�[�E�v���T�C����</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_8", , "8") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'lngIndex = 15
'    strHTML = strHTML & "<TR>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�I�p������</TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_9", , "9") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
'    strHTML = strHTML & "</TR>" & vbLf
'    Response.Write strHTML

'### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�C�� STR ####################################
'### �ؑ֓��t�ȑO�̎�f�҂̂ݕ\������
If CDate(strCslDate) < CDate(CHANGE_CSLDATE) Then

lngIndex = 8
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���[�t�@����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_4", , "4") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 9
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�o�t�@�����W�P</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_5", , "5") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 10
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�p�i���W��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_7", , "7") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 11
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�v���^�[��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_3", , "3") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 12
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�y���T���`��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_2", , "2") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 13
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�A���v���[�O</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_1", , "1") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 14
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�G�p�f�[��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_6", , "6") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 15
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�h���i�[�E�v���T�C����</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_8", , "8") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 16
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�I�p������</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_9", , "9") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
'### 2006/09/25 �� �R�Ìōܖ�i�\�����ԕύX�̂��ߏC�� End   ###


'### 2006/09/25 �� �R�Ìōܖ�i�ǉ��ɂ�鍀�ڒǉ� Start ###
lngIndex = 17
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">�R�����A��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_10", , "10") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
lngIndex = 18
    strHTML = strHTML & "<TR>" & vbLf
    strHTML = strHTML & "<TD NOWRAP BGCOLOR=""#eeeeee"">���R�i�[��</TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP>" & EditRsl(lngIndex, "checkbox", "chk_11", , "11") & "<FONT COLOR=""gray"">����</FONT></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "<TD NOWRAP></TD>" & vbLf
    strHTML = strHTML & "</TR>" & vbLf
'### 2006/09/25 �� �R�Ìōܖ�i�ǉ��ɂ�鍀�ڒǉ� End   ###

End If

    Response.Write strHTML

'### 2016.06.03 �� �g�p���Ă��Ȃ����ڍ폜�ׁ̈A�C�� END ####################################

%>
    </TABLE>
    <BR>
    <!--A HREF="JavaScript:saveNaishikyou()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�" BORDER="0"></A-->
    <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="JavaScript:saveNaishikyou()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�" BORDER="0"></A>
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
    
    <BR>
<%
    '�ۑ��p
    strHtml = ""
    For i=0 To lngRslCnt-1
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ItemCd"" VALUE=""" & vntItemCd(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""Suffix"" VALUE=""" & vntSuffix(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""OrgRsl"" VALUE=""" & vntRslValue(i) & """>"
        strHtml = strHtml & "<INPUT TYPE=""hidden"" NAME=""ChgRsl"" VALUE=""" & vntRslValue(i) & """>"
    Next
    Response.Write(strHtml)
%>
</FORM>
<%
'-----�ۑ���������----- 
%>
<SCRIPT TYPE="text/javascript">
<!--
//### 2004/01/23 Start K.Kagawa �������`�F�b�N���X�g�̕ۑ��m�F��ǉ�
    // �ۑ��������ɓ������`�F�b�N���X�g�̏�Ԃ��ďo�����ɔ��f����
    if( document.entryForm.act.value == 'saveend' ) {
        opener.document.entryForm.GFCheckList.value = document.entryForm.GFCheckList.value
    }
//### 2004/01/23 End
//-->
</SCRIPT>
</BODY>
</HTML>
