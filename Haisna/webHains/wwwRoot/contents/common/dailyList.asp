<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		��f�҈ꗗ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'	��ԍ��Ɨ񖼂̊֌W�͎��̂Ƃ���B
'	 1	���Ԙg(���g�p)
'	 2	�����h�c
'	 3	�Ǘ��ԍ�(���g�p)
'	 4	�R�[�X
'	 5	����
'	 6	�J�i����
'	 7	����
'	 8	���N����
'	 9	��f���N��
'	10	�c�̗���
'	11	�\��ԍ�
'	12	��f��
'	13	�\���
'	14	�ǉ�����
'	15  ��t��(���g�p)
'	16	�l����(�J�i�����E�����̗���)
'	17	�l�h�c
'	18	��f����
'	19	���呗�M(���g�p)
'	20	��f������̑��Γ�(���g�p)
'	21	�]�ƈ��ԍ�(���g�p)
'	22	���ۋL��
'	23	���۔ԍ�
'	24	���ƕ�����(���g�p)
'	25	��������(���g�p)
'	26	��������(���g�p)
'	27	��f���m��t���O(���g�p)
'	28	�n�b�q�p��f��(���g�p)
'	29	���̔ԍ�(���g�p)
'	30	��f�[�o�͓�(���g�p)
'	31	�݃J������f��(���g�p)
'	32	�T�u�R�[�X
'	33	�l���̌��ۋL��(���g�p)
'	34	�l���̌��۔ԍ�(���g�p)
'	35	���ʓ��͏��

'	36  �\���
'	37  �m�F�͂����o�͓�
'	38  �ꎮ�����o�͓�
'	39  �\��Q����
'	40  ���A��l�L��
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editButtonCol.inc"  -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editFreeList.inc"   -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"   -->
<%
'�Z�b�V�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p
Dim objGrp				'�O���[�v���ڃA�N�Z�X�p
Dim objItem				'�������ڃA�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p

'�p�����[�^�l
Dim strKey				'�����L�[
Dim lngStrYear			'��f��(��)(�N)
Dim lngStrMonth			'��f��(��)(��)
Dim lngStrDay			'��f��(��)(��)
Dim lngEndYear			'��f��(��)(�N)
Dim lngEndMonth			'��f��(��)(��)
Dim lngEndDay			'��f��(��)(��)
Dim strCsCd				'�R�[�X�R�[�h
Dim strPrtField			'�o�͍��ڃR�[�h
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strItemCd			'�˗����ڃR�[�h
Dim strGrpCd			'�O���[�v�R�[�h
Dim strEntry			'���ʓ��͏��("":�w��Ȃ��A"1":�����͂̂ݕ\���A"2":���͍ς݂̂ݕ\��)
Dim lngSortKey			'�\�[�g�L�[
Dim lngSortType			'�\�[�g��(0:�����A1:�~��)
Dim lngStartPos			'�\���J�n�ʒu
Dim strGetCount			'�P�y�[�W�\���s��
Dim lngPrint			'������[�h(0:�ʏ�\�����[�h�A1:������[�h)
Dim strNavi				'�i�r�o�[�\��

Dim strRsvStat			'�\����("":���ׂāA"1":�L�����Z���A"2":�\��̂݁A"3":��t�ς݂̂�)
Dim strRptStat			'��f���("":���ׂāA"1":�����@�A"2":���@�ς�)

'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� START ################################################################
Dim strCslDivCd         '��f�敪�R�[�h
'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� END   ################################################################

'�o�͍��ڏ��
Dim lngArrPrtField		'�o�͍��ڂ̔z��
Dim strPrtFieldName		'�o�͍��ږ�

'��f���
Dim strArrRsvNo			'�\��ԍ��̔z��
Dim strArrCancelFlg		'�L�����Z���t���O�̔z��
Dim strArrCslDate		'��f���̔z��
Dim strArrPerId			'�lID�̔z��
Dim strArrOrgCd1		'�c�̃R�[�h1�̔z��
Dim strArrOrgCd2		'�c�̃R�[�h2�̔z��
Dim strArrRsvDate		'�\����̔z��
Dim strArrAge			'�N��̔z��
Dim strArrDayId			'����ID�̔z��
Dim strArrWebColor		'�R�[�X���\���F�̔z��
Dim strArrCsName		'�R�[�X���̔z��
Dim strArrName			'�����̔z��
Dim strArrKanaName		'�J�i�����̔z��
Dim strArrBirth			'���N�����̔z��
Dim strArrGender		'���ʂ̔z��
Dim strArrOrgSName		'�c�̗��̂̔z��
Dim strArrAddDiv		'�ǉ������敪�̔z��
Dim strArrAddName		'�ǉ��������̔z��
Dim strArrRequestName	'�������ږ��̔z��
Dim strArrIsrSign		'���ۋL���̔z��
Dim strArrIsrNo			'���۔ԍ��̔z��
Dim strArrSubCsWebColor	'�T�u�R�[�X��web�J���[�̔z��
Dim strArrSubCsName		'�T�u�R�[�X���̔z��
Dim strArrEntry			'���ʓ��͏�Ԃ̔z��
Dim strArrRsvStatus		'�\��󋵂̔z��
Dim strArrCardPrintDate	'�m�F�͂����o�͓��̔z��
Dim strArrFormPrintDate	'�ꎮ�����o�͓��̔z��
Dim strArrRsvGrpName	'�\��Q���̂̔z��
Dim strArrHasFriends	'���A��l�L���̔z��
Dim lngCount			'���R�[�h����
Dim lngNotCanceledCount	'��L�����Z���҂̃��R�[�h����

Dim lngGetCount			'�\������
Dim dtmStrDate			'��f��(��)
Dim dtmEndDate			'��f��(��)
Dim strDispDate			'�\���p�̎�f���t
Dim strOrgSName			'�c�̗���
Dim strItemName			'�˗����ځ^�O���[�v����
Dim dtmDate				'���t
Dim blnAnchor			'�A���J�[�̗v��
Dim strMessage			'�G���[���b�Z�[�W
Dim strBuffer			'������o�b�t�@
Dim strHTML				'HTML������
Dim strURL				'�W�����v���URL
Dim i, j				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
strKey      = Request("key")
lngStrYear  = CLng("0" & Request("strYear"))
lngStrMonth = CLng("0" & Request("strMonth"))
lngStrDay   = CLng("0" & Request("strDay"))
lngEndYear  = CLng("0" & Request("endYear"))
lngEndMonth = CLng("0" & Request("endMonth"))
lngEndDay   = CLng("0" & Request("endDay"))
strCsCd     = Request("csCd")
strPrtField = Request("prtField")
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
strItemCd   = Request("itemCd")
strGrpCd    = Request("grpCd")
strEntry    = Request("entry")
lngSortKey  = CLng("0" & Request("sortKey"))
lngSortType = CLng("0" & Request("sortType"))
lngStartPos = CLng("0" & Request("startPos"))
strGetCount = Request("getCount")
lngPrint    = CLng(Request("print"))
strNavi     = Request("navi")

strRsvStat  = Request("rsvStat")
strRptStat  = Request("rptStat")

'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� START ################################################################
strCslDivCd = Request("cslDivCd")
'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� END   ################################################################

'�����L�[���̔��p�J�i��S�p�J�i�ɕϊ�����
strKey = objCommon.StrConvKanaWide(strKey)

'�����L�[���̏�������啶���ɕϊ�����
strKey = UCase(strKey)

'�S�p�󔒂𔼊p�󔒂ɒu������
strKey = Replace(Trim(strKey), "�@", " ")

'2�o�C�g�ȏ�̔��p�󔒕��������݂��Ȃ��Ȃ�܂Œu�����J��Ԃ�
Do Until InStr(1, strKey, "  ") = 0
    strKey = Replace(strKey, "  ", " ")
Loop

'�o�͍��ڂ̃f�t�H���g�l�ݒ�
strPrtField = IIf(strPrtField = "", "RSVLIST1", strPrtField)

'�o�͊J�n�ʒu�̃f�t�H���g�l�Ƃ��ĂP��ݒ�
lngStartPos  = IIf(lngStartPos = 0, 1, lngStartPos)

'�P�y�[�W�\���s���̃f�t�H���g�l�ݒ�
strGetCount = IIf(strGetCount = "", objCommon.SelectDailyPageMaxLine, strGetCount)
If IsNumeric(strGetCount) Then
    lngGetCount = CLng(strGetCount)
End If

'�c�̖��̂̎擾
If strOrgCd1 <> "" And strOrgCd2 <> "" Then
    Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
    objOrganization.SelectOrgSName strOrgCd1, strOrgCd2, strOrgSName
    Set objOrganization = Nothing
End If

'�������ږ��̎擾
If strItemCd <> "" Then
    Set objItem = Server.CreateObject("HainsItem.Item")
    objItem.SelectItem_P strItemCd, strItemName
    Set objItem = Nothing
End If

'�O���[�v���̎擾
If strGrpCd <> "" Then
    Set objGrp = Server.CreateObject("HainsGrp.Grp")
    objGrp.SelectGrp_P strGrpCd, strItemName
    Set objGrp = Nothing
End If

Do

    '��f��(��)�̓��t�`�F�b�N
    If lngStrYear <> 0 Or lngStrMonth <> 0 Or lngStrDay <> 0 Then
        If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Then
            strMessage = "��f���̎w��Ɍ�肪����܂��B"
            Exit Do
        End If
    End If

    '��f��(��)�̓��t�`�F�b�N
    If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
        If Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
            strMessage = "��f���̎w��Ɍ�肪����܂��B"
            Exit Do
        End If
    End If

    '�\�����ڂ̎擾
    EditPrtFieldArray strPrtField, strPrtFieldName, lngArrPrtField
    If Not IsArray(lngArrPrtField) Then
        strMessage = "�\�����ׂ����ڂ��w�肳��Ă��܂���B"
        Exit Do
    End If

    '�\�[�g�L�[���w�莞�͕\�����ڂ̐擪���ڂ�K�p����
    If lngSortKey = 0 Then
        lngSortKey  = lngArrPrtField(0)
        lngSortType = 0
    End If

    '��f���̕ҏW
    If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
        dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
    End If

    If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
        dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
    End If

    Do

        '�I�������ݒ莞�͉������Ȃ�
        If dtmEndDate = 0 Then
            Exit Do
        End If

        '�J�n�����ݒ�A�܂��͊J�n�����I�������ߋ��ł����
        If dtmStrDate = 0 Or dtmStrDate > dtmEndDate Then

            '�l������
            dtmDate    = dtmStrDate
            dtmStrDate = dtmEndDate
            dtmEndDate = dtmDate

        End If

        '�X�ɓ��l�̏ꍇ�A�I�����̓N���A
        If dtmStrDate = dtmEndDate Then
            dtmEndDate = 0
        End If

        Exit Do
    Loop

    '��̏����̂��߂ɔN�������ĕҏW
    If dtmStrDate <> 0 Then
        lngStrYear  = Year(dtmStrDate)
        lngStrMonth = Month(dtmStrDate)
        lngStrDay   = Day(dtmStrDate)
    Else
        lngStrYear  = 0
        lngStrMonth = 0
        lngStrDay   = 0
    End If

    If dtmEndDate <> 0 Then
        lngEndYear  = Year(dtmEndDate)
        lngEndMonth = Month(dtmEndDate)
        lngEndDay   = Day(dtmEndDate)
    Else
        lngEndYear  = 0
        lngEndMonth = 0
        lngEndDay   = 0
    End If

    '�����L�[�A��f���̂����ꂩ���w�肳��Ă��Ȃ��ꍇ�͌������s��Ȃ�
    If dtmEndDate = 0 And dtmStrDate = 0 And strKey = "" Then
        strMessage = "���������𖞂�����f���͑��݂��܂���B"
        Exit Do
    End If

    '��f���̓ǂݍ���
    Set objConsult = Server.CreateObject("HainsConsult.Consult")

'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� START ################################################################
'    lngCount = objConsult.SelectDailyList( _
'                   strKey,              dtmStrDate,       dtmEndDate,                           _
'                   strCsCd,             strOrgCd1,        strOrgCd2,       strGrpCd,            _
'                   strItemCd,           strEntry,         lngArrPrtField,  lngSortKey,          _
'                   lngSortType,         lngStartPos,      lngGetCount,                          _
'                   strArrRsvNo,         strArrCancelFlg,  strArrCslDate,   strArrPerId,         _
'                   strArrOrgSName,      strArrRsvDate,    strArrAge,       strArrDayId,         _
'                   strArrWebColor,      strArrCsName,     strArrName,      strArrKanaName,      _
'                   strArrBirth,         strArrGender,     strArrAddDiv,    strArrAddName,       _
'                   strArrRequestName,   strArrIsrSign,    strArrIsrNo,     strArrSubCsWebColor, _
'                   strArrSubCsName,     strArrEntry,      strArrRsvStatus, strArrCardPrintDate, _
'                   strArrFormPrintDate, strArrRsvGrpName, strArrHasFriends,                     _
'                   strRsvStat,          strRptStat                                              _
'               )

    lngCount = objConsult.SelectDailyList( _
                   strKey,              dtmStrDate,       dtmEndDate,                           _
                   strCsCd,             strOrgCd1,        strOrgCd2,       strGrpCd,            _
                   strItemCd,           strEntry,         lngArrPrtField,  lngSortKey,          _
                   lngSortType,         lngStartPos,      lngGetCount,                          _
                   strArrRsvNo,         strArrCancelFlg,  strArrCslDate,   strArrPerId,         _
                   strArrOrgSName,      strArrRsvDate,    strArrAge,       strArrDayId,         _
                   strArrWebColor,      strArrCsName,     strArrName,      strArrKanaName,      _
                   strArrBirth,         strArrGender,     strArrAddDiv,    strArrAddName,       _
                   strArrRequestName,   strArrIsrSign,    strArrIsrNo,     strArrSubCsWebColor, _
                   strArrSubCsName,     strArrEntry,      strArrRsvStatus, strArrCardPrintDate, _
                   strArrFormPrintDate, strArrRsvGrpName, strArrHasFriends,                     _
                   strRsvStat,          strRptStat,     , strCslDivCd                           _
               )
'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� END   ################################################################

    Set objConsult = Nothing

    '�Ώۃf�[�^�����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
    If lngCount = 0 Then
        strMessage = "���������𖞂�����f���͑��݂��܂���B"
    End If

    Exit Do
Loop
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\���s���ꗗ�h���b�v�_�E�����X�g�̕ҏW
'
' �����@�@ : (In)     strName                 �G�������g��
' �@�@�@�@ : (In)     strSelectedPageMaxLine  ���X�g�ɂđI�����ׂ��\���s��
'
' �߂�l�@ : HTML������
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditDailyPageMaxLineList(strName, strSelectedPageMaxLine)

    Dim vntPageMaxLine	'�\���s��
    Dim vntPageMaxName	'�\���s������

    '�\���s�����̎擾
    If objCommon.SelectDailyPageMaxLineList(vntPageMaxLine, vntPageMaxName) > 0 Then

        '�h���b�v�_�E�����X�g�̕ҏW
        EditDailyPageMaxLineList = EditDropDownListFromArray(strName, vntPageMaxLine, vntPageMaxName, strSelectedPageMaxLine, NON_SELECTED_DEL)

    End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����������̓G�������g�̕ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditEntryCondition()

    '�ʏ�\�����[�h�ȊO�ł���ΕҏW���Ȃ�
    If lngPrint <> 0 Then
        Exit Sub
    End If
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="850">
        <TR>
            <TD WIDTH="74" NOWRAP>�����L�[�F</TD>
            <TD COLSPAN="8"><INPUT TYPE="text" NAME="key" SIZE="45" VALUE="<%= strKey %>"></TD>
            <TD COLSPAN="11"><% Call EditOperationMenu() %></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD NOWRAP>��f���F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:calGuide_clearDate('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, True) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, True) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("strDay", 1, 31, lngStrDay, True) %></TD>
            <TD>��</TD>
            <TD>�`</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, True) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, True) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("endDay", 1, 31, lngEndDay, True) %></TD>
            <TD>��</TD>
            <TD WIDTH="100%" ALIGN="right" NOWRAP>�R�[�X�F</TD>
            <TD><%= EditCourseList("csCd", strCsCd, "�S�ẴR�[�X") %></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD WIDTH="72" NOWRAP>��f�c�́F</TD>
            <TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
            <TD><A HREF="javascript:clearOrgCd()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"  ></A></TD>
            <TD WIDTH="169" NOWRAP><SPAN ID="orgname"><%= strOrgSName %></SPAN></TD>
            <TD ALIGN="right" NOWRAP>��f���ځF</TD>
            <TD><A HREF="javascript:callItmGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ڃK�C�h��\��"  ></A></TD>
            <TD><A HREF="javascript:clearItemCd()" ><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
            <TD NOWRAP><SPAN ID="itemname"><%= strItemName %></SPAN></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="850">
        <TR>
<!--
            <TD ALIGN="right" NOWRAP>���ʓ��͏�ԁF</TD>
            <TD>
                <SELECT NAME="entry">
                    <OPTION VALUE=""  <%= IIf(strEntry = "",  "SELECTED", "") %>>�w��Ȃ�
                    <OPTION VALUE="1" <%= IIf(strEntry = "1", "SELECTED", "") %>>�����͂̂ݕ\��
                    <OPTION VALUE="2" <%= IIf(strEntry = "2", "SELECTED", "") %>>���͍ς݂̂ݕ\��
                </SELECT>
            </TD>
-->
            <TD NOWRAP>�\���ԁF</TD>
            <TD>
                <SELECT NAME="rsvStat">
                    <OPTION VALUE=""  <%= IIf(strRsvStat = "",  "SELECTED", "") %>>���ׂ�
                    <OPTION VALUE="1" <%= IIf(strRsvStat = "1", "SELECTED", "") %>>�L�����Z��
                    <OPTION VALUE="2" <%= IIf(strRsvStat = "2", "SELECTED", "") %>>�\��̂�
                    <OPTION VALUE="3" <%= IIf(strRsvStat = "3", "SELECTED", "") %>>��t�ς�
                </SELECT>
            </TD>
            <TD NOWRAP>&nbsp;��f��ԁF</TD>
            <TD>
                <SELECT NAME="rptStat">
                    <OPTION VALUE=""  <%= IIf(strRptStat = "",  "SELECTED", "") %>>���ׂ�
                    <OPTION VALUE="1" <%= IIf(strRptStat = "1", "SELECTED", "") %>>�����@
                    <OPTION VALUE="2" <%= IIf(strRptStat = "2", "SELECTED", "") %>>���@�ς�
                </SELECT>
            </TD>

<%'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� START ################################################################ %>
            <TD NOWRAP>&nbsp;��f�敪�F</TD>
<%
            Dim objFree         '�ėp���A�N�Z�X�p

            '�ėp���
            Dim strFreeCd           '�ėp�R�[�h
            Dim strFreeDate         '�ėp���t
            Dim strFreeField1       '�t�B�[���h�P
            Dim strFreeField2       '�t�B�[���h�Q

            '�ėp�e�[�u�������f�敪��ǂݍ���
            Set objFree = Server.CreateObject("HainsFree.Free")
            objFree.SelectFree 1, "CSLDIV", strFreeCd, , , strFreeField1
            Set objFree = Nothing
%>
            <TD><%= EditDropDownListFromArray("cslDivCd", strFreeCd, strFreeField1, strCslDivCd, SELECTED_ALL) %></TD>

<%'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� END   ################################################################ %>

            <TD WIDTH="100%"></TD>
            <TD><%= EditRsvListList("prtField", strPrtField, NON_SELECTED_DEL) %></TD>
            <TD><%= EditDailyPageMaxLineList("getCount", strGetCount) %></TD>
            <TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��" id="testtest"></TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
    </TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���������̕ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditCondition()

    Dim objCourse	'�R�[�X���A�N�Z�X�p

    Dim strCsName	'�R�[�X��
    Dim strBuffer	'������o�b�t�@

    '����p�\�����[�h�ȊO�ł���ΕҏW���Ȃ�
    If lngPrint <> 1 Then
        Exit Sub
    End If
%>
    <SPAN STYLE="font-size: 9px;">
<%
    '�R�[�X���̎擾
    If strCsCd <> "" Then
        Set objCourse = Server.CreateObject("HainsCourse.Course")
        objCourse.SelectCourse strCsCd, strCsName
        Set objCourse = Nothing
    End If
%>
    �R�[�X�F<%= IIf(strCsName = "", "���ׂ�", strCsName) %>&nbsp;&nbsp;

    ��f�c�́F<%= IIf(strOrgSName = "", "�w��Ȃ�", strOrgSName) %>&nbsp;&nbsp;

    ��f���ځF<%= IIf(strItemName = "", "�w��Ȃ�", strItemName) %><BR>
<%
    Select Case strEntry
        Case "1"
            strBuffer = "�����͂̂ݕ\��"
        Case "2"
            strBuffer = "���͍ς݂̂ݕ\��"
        Case Else
            strBuffer = "�w��Ȃ�"
    End Select
%>
<!--
    ���ʓ��͏�ԁF<%= strBuffer %>&nbsp;&nbsp;
-->
    �\�����ځF<%= IIf(strPrtFieldName = "", "�f�t�H���g", strPrtFieldName) %>&nbsp;&nbsp;

    <%= IIf(strGetCount = "*", "�S�f�[�^", strGetCount & "������") %>�\��

    </SPAN>
<%
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �u���̓��̑���v�̕ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditOperationMenu()

    Dim blnAnchor	'�A���J�[�̗v��
    Dim strURL		'URL������

    '�ʏ�\�����[�h�ȊO�ł���ΕҏW���Ȃ�
    If lngPrint <> 0 Then
        Exit Sub
    End If

    '�J�n���̂ݐݒ肳��Ă���ꍇ�ȊO�͕ҏW���Ȃ�
    If Not (dtmStrDate <> 0 And dtmEndDate = 0) Then
        Exit Sub
    End If
%>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#cccccc" ALIGN="right">
        <TR>
            <TD ALIGN="center"><SPAN STYLE="font-size:12px;color:#ffffff;font-weight:bolder;">���̓��̑���</SPAN></TD>
            <TD BGCOLOR="#ffffff">
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                    <TR>
<%
                        '�\���ʂւ�URL�ҏW
                        strURL = "/webHains/contents/reserve/rsvMain.asp"
                        strURL = strURL & "?cyear="  & lngStrYear
                        strURL = strURL & "&cMonth=" & lngStrMonth
                        strURL = strURL & "&cDay="   & lngStrDay
%>
                        <TD><A HREF="<%= strURL %>" TARGET="_top"><IMG SRC="/webHains/images/rsv.gif" WIDTH="18" HEIGHT="18" ALT="�V�����\�񂷂�"></A></TD>
                        <TD NOWRAP><A HREF="<%= strURL %>" TARGET="_top">�V�����\�񂷂�</A></TD>
                        <TD><A HREF="javascript:showReceiptAll()"><IMG SRC="/webHains/images/receipt.gif" WIDTH="18" HEIGHT="18" ALT="�����h�c���ԏ���"></A></TD>
                        <TD NOWRAP><A HREF="javascript:showReceiptAll()">�����h�c����</A></TD>
<%
                        '�i����ʂւ�URL�ҏW
                        strURL = "/webHains/contents/common/progress.asp"
                        strURL = strURL & "?act="    & "select"
                        strURL = strURL & "&syear="  & lngStrYear
                        strURL = strURL & "&sMonth=" & lngStrMonth
                        strURL = strURL & "&sDay="   & lngStrDay
%>
                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="18" HEIGHT="18" ALT=""></A></TD>
                        <TD NOWRAP><A HREF="<%= strURL %>" TARGET="_top">�i��������</A></TD>
<%
                        '�A���J�[�̕ҏW
                        strURL = "/webHains/contents/maintenance/capacity/mntCapacityList.asp"
                        strURL = strURL & "?cslYear="  & lngStrYear
                        strURL = strURL & "&cslMonth=" & lngStrMonth
                        strURL = strURL & "&cslDay="   & lngStrDay
                        strURL = strURL & "&mode="     & "all"
%>
                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="18" HEIGHT="18" ALT=""></A></TD>
                        <TD NOWRAP><A HREF="<%= strURL %>" TARGET="_top">�\��g������</A></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �^�C�g���s�̕ҏW
'
' �����@�@ : (In)     strAddDiv   �ǉ������敪
' �@�@�@�@   (In)     strAddName  �ǉ�������
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditTitle()

    Dim strTitle	'�^�C�g��
    Dim blnAnchor	'�A���J�[�̗v��

    '�^�C�g�����̔z����쐬
    strTitle = Array( _
                   "", _
                   "���Ԙg",         "�����h�c",         "�Ǘ��ԍ�",       "�R�[�X",     "����",         _
                   "�J�i����",       "��",               "���N����",       "�N��",       "�c��",         _
                   "�\��ԍ�",       "��f��",           "�\���",         "��f�Z�b�g", "��t��",       _
                   "�l����",       "�l�h�c",         "��f����",       "���呗�M",   "����",         _
                   "�]�ƈ��ԍ�",     "��f�����ۋL��",   "��f�����۔ԍ�", "���ƕ�",     "����",         _
                   "����",           "��f���m��",       "�n�b�q�p��f��", "���̔ԍ�",   "��f�[�o�͓�", _
                   "�݃J������f��", "�T�u�R�[�X",       "���ۋL��",       "���۔ԍ�",   "���ʓ��͏��", _
                   "�\���",       "�m�F�͂����o�͓�", "�ꎮ�����o�͓�", "�\��Q",     "���A��l"      _
               )
%>
    <TR BGCOLOR="#cccccc">
<%
        For i = 0 To UBound(lngArrPrtField)

            '�A���J�[�\���̗v�ۂ����肷��
            Do
                blnAnchor = False

                '����p�\�����[�h�̏ꍇ�̓A���J�[�s�p
                If lngPrint = 1 Then
                    Exit Do
                End If

                Select Case lngArrPrtField(i)
                    '�ǉ������E��t���E��f���ځE���呗�M�E�����E���̔ԍ��E�T�u�R�[�X�A���̑����g�p���ڂ̏ꍇ�̓A���J�[�s�p
                    Case 1, 3, 14, 15, 18, 19, 20, 21, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 40
                        Exit Do
                End Select

                blnAnchor = True
                Exit Do
            Loop

            '�A���J�[���K�v�ȏꍇ
            If blnAnchor Then

                'URL�̕ҏW
                strURL = Request.ServerVariables("SCRIPT_NAME")
                strURL = strURL & "?key="           & strKey
                strURL = strURL & "&strYear="       & lngStrYear
                strURL = strURL & "&strMonth="      & lngStrMonth
                strURL = strURL & "&strDay="        & lngStrDay
                strURL = strURL & "&endYear="       & lngEndYear
                strURL = strURL & "&endMonth="      & lngEndMonth
                strURL = strURL & "&endDay="        & lngEndDay
                strURL = strURL & "&csCd="          & strCsCd
                strURL = strURL & "&orgCd1="        & strOrgCd1
                strURL = strURL & "&orgCd2="        & strOrgCd2
                strURL = strURL & "&itemCd="        & strItemCd
                strURL = strURL & "&grpCd="         & strGrpCd
                strURL = strURL & "&prtField="      & strPrtField
                strURL = strURL & "&sortKey="       & lngArrPrtField(i)
                strURL = strURL & "&getCount="      & strGetCount
                strURL = strURL & "&navi="          & strNavi
                strURL = strURL & "&entry="         & strEntry
                strURL = strURL & "&rsvStat="       & strRsvStat
                strURL = strURL & "&rptStat="       & strRptStat

                '�\�[�g���ɂ��ẮA���݂̕ҏW�񂪎w��\����Ɠ���ȏꍇ�͌��\�[�g���̔��]�w����s���A�����Ȃ��Ώ����Ƃ���
                strURL = strURL & "&sortType=" & IIf(lngArrPrtField(i) = lngSortKey, IIf(lngSortType = 0, 1, 0), 0)
%>
                <TD CLASS="<%= IIf(lngArrPrtField(i) = lngSortKey, "selectedcolor", "shadowcolor") %>" NOWRAP><A HREF="<%= strURL %>"><%= strTitle(lngArrPrtField(i)) %></A></TD>
<%
            '�A���J�[���s�p�ȏꍇ
            Else
%>
                <TD NOWRAP><%= strTitle(lngArrPrtField(i)) %></TD>
<%
            End If

        Next

        '�ʏ�\�����[�h�̏ꍇ�͑���p�̗��ҏW����
        If lngPrint = 0 Then
%>
            <TD ALIGN="center" NOWRAP>����</TD>
<%
        End If
%>
    </TR>
<%
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �ǉ������̕ҏW
'
' �����@�@ : (In)     strAddDiv   �ǉ������敪
' �@�@�@�@   (In)     strAddName  �ǉ�������
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditAddItem(strAddDiv, strAddName)

    Const COLS_PER_ROW = 3	'�P�s�ӂ�̗�

    Dim strWorkAddDiv		'�ǉ������敪
    Dim strWorkAddName		'�ǉ�������
    Dim lngCount			'�ǉ�������

    Dim strMark				'�ǉ������敪�������}�[�N
    Dim i, j				'�C���f�b�N�X

    '�ǉ����������݂��Ȃ��ꍇ�͏����I��
    If strAddDiv = "" Then
        Exit Sub
    End If

    '�J���}���Z�p���[�^�Ƃ��Ĕz��ɕϊ�
    strWorkAddDiv  = Split(strAddDiv,  ",")
    strWorkAddName = Split(strAddName, ",")
    lngCount = UBound(strWorkAddDiv) + 1

    'TABLE�ҏW��e�Ղɂ��邽�߁A�z��̗v�f�����P�s�ӂ�̍s���̔{���ɂȂ�悤�Ɋg������
    Do Until lngCount Mod COLS_PER_ROW = 0
        ReDim Preserve strWorkAddDiv(lngCount)
        ReDim Preserve strWorkAddName(lngCount)
        lngCount = lngCount + 1
    Loop
%>
    <TABLE BORDER="0" CELLPADING="1" CELLSPACING="0">
<%
        For i = 0 To lngCount / COLS_PER_ROW - 1
%>
            <TR>
<%
                For j = 0 To COLS_PER_ROW - 1

                    '�}�[�N�̕ҏW
                    Select Case strWorkAddDiv(i * COLS_PER_ROW + j)
                        Case "0"
                            strMark = "��"
                        Case "1"
                            strMark = "��"
                        Case "2"
                            strMark = "�~"
                        Case Else
                            strMark = ""
                    End Select
%>
                    <TD><%= strMark %></TD>
                    <TD WIDTH="100" NOWRAP><%= strWorkAddName(i * COLS_PER_ROW + j) %></TD>
<%
                Next
%>
            </TR>
<%
        Next
%>
    </TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f���ڂ̕ҏW
'
' �����@�@ : (In)     strRequestName  �������ږ�
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditConsultItem(strRequestName)

    Const COLS_PER_ROW = 4	'�P�s�ӂ�̗�

    Dim strWorkRequestName	'�������ږ�
    Dim lngCount			'��f���ڐ�

    Dim i, j				'�C���f�b�N�X

    '��f���ڂ����݂��Ȃ��ꍇ�͏����I��
    If strRequestName = "" Then
        Exit Sub
    End If

    '�J���}���Z�p���[�^�Ƃ��Ĕz��ɕϊ�
    strWorkRequestName = Split(strRequestName, ",")
    lngCount = UBound(strWorkRequestName) + 1

    'TABLE�ҏW��e�Ղɂ��邽�߁A�z��̗v�f�����P�s�ӂ�̍s���̔{���ɂȂ�悤�Ɋg������
    Do Until lngCount Mod COLS_PER_ROW = 0
        ReDim Preserve strWorkRequestName(lngCount)
        lngCount = lngCount + 1
    Loop
%>
    <TABLE BORDER="0" CELLPADING="1" CELLSPACING="0">
<%
        For i = 0 To lngCount / COLS_PER_ROW - 1
%>
            <TR>
<%
                For j = 0 To COLS_PER_ROW - 1
%>
                    <TD WIDTH="120" NOWRAP><%= strWorkRequestName(i * COLS_PER_ROW + j) %></TD>
<%
                Next
%>
            </TR>
<%
        Next
%>
    </TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �T�u�R�[�X�̕ҏW
'
' �����@�@ : (In)     strSubCsWebColor  web�J���[
' �@�@�@�@   (In)     strSubCsName      �T�u�R�[�X��
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditSubCourse(strSubCsWebColor, strSubCsName)

    Const COLS_PER_ROW = 3		'�P�s�ӂ�̗�

    Dim strWorkSubCsWebColor	'web�J���[
    Dim strWorkSubCsName		'�T�u�R�[�X��
    Dim lngCount				'�T�u�R�[�X��

    Dim strWebColor				'web�J���[
    Dim i, j					'�C���f�b�N�X

    '�T�u�R�[�X�����݂��Ȃ��ꍇ�͏����I��
    If strSubCsWebColor = "" Then
        Exit Sub
    End If

    '�J���}���Z�p���[�^�Ƃ��Ĕz��ɕϊ�
    strWorkSubCsWebColor = Split(strSubCsWebColor, ",")
    strWorkSubCsName     = Split(strSubCsName,     ",")
    lngCount = UBound(strWorkSubCsWebColor) + 1

    'TABLE�ҏW��e�Ղɂ��邽�߁A�z��̗v�f�����P�s�ӂ�̍s���̔{���ɂȂ�悤�Ɋg������
    Do Until lngCount Mod COLS_PER_ROW = 0
        ReDim Preserve strWorkSubCsWebColor(lngCount)
        ReDim Preserve strWorkSubCsName(lngCount)
        lngCount = lngCount + 1
    Loop
%>
    <TABLE BORDER="0" CELLPADING="1" CELLSPACING="0">
<%
        For i = 0 To lngCount / COLS_PER_ROW - 1
%>
            <TR>
<%
                For j = 0 To COLS_PER_ROW - 1

                    'web�J���[�̕ҏW
                    If strWorkSubCsWebColor(i * COLS_PER_ROW + j) <> "" Then
                        strWebColor = "<FONT COLOR=""" & strWorkSubCsWebColor(i * COLS_PER_ROW + j) & """>��</FONT>"
                    Else
                        strWebColor = ""
                    End If
%>
                    <TD><%= strWebColor %></TD>
                    <TD WIDTH="110" NOWRAP><%= strWorkSubCsName(i * COLS_PER_ROW + j) %></TD>
<%
                Next
%>
            </TR>
<%
        Next
%>
    </TABLE>
<%
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��f�҈ꗗ</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!--
var winReceiptAll;	// �ꊇ��t�E�B���h�E�I�u�W�F�N�g
var winReceipt;		// ��t�E�B���h�E�I�u�W�F�N�g

// �K�C�h��ʌĂяo��
function callOrgGuide() {

    orgGuide_showGuideOrg( document.dailysearch.orgCd1, document.dailysearch.orgCd2, null, 'orgname', null, null, null, null, '0' );

}

// �c�̃N���A
function clearOrgCd() {

    orgGuide_clearOrgInfo(document.dailysearch.orgCd1, document.dailysearch.orgCd2, 'orgname');

}

// ���ڃK�C�h�Ăяo��
function callItmGuide() {

    // �K�C�h�Ɉ����n���f�[�^�̃Z�b�g
    itmGuide_mode     = 1;	// �˗��^���ʃ��[�h�@1:�˗��A2:����
    itmGuide_group    = 0;	// �O���[�v�\���L���@0:�\�����Ȃ��A1:�\������
    itmGuide_item     = 1;	// �������ڕ\���L���@0:�\�����Ȃ��A1:�\������
    itmGuide_question = 1;	// ��f���ڕ\���L���@0:�\�����Ȃ��A1:�\������

    // �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
    itmGuide_CalledFunction = setItmInfo;

    // ���ڃK�C�h�\��
    showGuideItm();
}

// �������ڂ̃Z�b�g
function setItmInfo() {

    var itmNameElement;	// �������ږ���ҏW����G�������g�̖���
    var itmName;		// �������ږ���ҏW����G�������g���g

    // �\�ߑޔ������C���f�b�N�X��̌������ڏ��ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
    if ( itmGuide_dataDiv[0] == 'P' ) {
        document.dailysearch.itemCd.value = itmGuide_itemCd[0];
        document.dailysearch.grpCd.value  = '';
    } else {
        document.dailysearch.itemCd.value = '';
        document.dailysearch.grpCd.value  = itmGuide_itemCd[0];
    }

    // �u���E�U���Ƃ̌������ږ��ҏW�p�G�������g�̐ݒ菈��
    for ( ; ; ) {

        // �G�������g���̕ҏW
        itmNameElement = 'itemname';

        // IE�̏ꍇ
        if ( document.all ) {
            document.all(itmNameElement).innerHTML = itmGuide_itemName[0];
            break;
        }

        // Netscape6�̏ꍇ
        if ( document.getElementById ) {
            document.getElementById(itmNameElement).innerHTML = itmGuide_itemName[0];
        }

        break;
    }
    return false;
}

// �������ڃR�[�h�E���̂̃N���A
function clearItemCd() {

    var itmNameElement;			/* �������ږ���ҏW����G�������g�̖��� */
    var itmName;				/* �������ږ���ҏW����G�������g���g */

    // hidden���ڂ̍Đݒ�
    document.dailysearch.itemCd.value = '';
    document.dailysearch.grpCd.value  = '';

    // �u���E�U���Ƃ̌������ږ��ҏW�p�G�������g�̐ݒ菈��
    for ( ; ; ) {

        // �G�������g���̕ҏW
        itmNameElement = 'itemname';

        // IE�̏ꍇ
        if ( document.all ) {
            document.all(itmNameElement).innerHTML = '';
            break;
        }

        // Netscape6�̏ꍇ
        if ( document.getElementById ) {
            document.getElementById(itmNameElement).innerHTML = '';
        }

        break;
    }

}

// �ꊇ��t��ʂ�\��
function showReceiptAll() {

    var opened = false;	// ��ʂ��J����Ă��邩
    var url;			// �ꊇ��t��ʂ�URL

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winReceiptAll != null ) {
        if ( !winReceiptAll.closed ) {
            opened = true;
        }
    }

    // �ꊇ��t��ʂ�URL�ҏW
    url = '/webHains/contents/receipt/rptAllEntry.asp';
    url = url + '?cYear='  + '<%= lngStrYear  %>';
    url = url + '&cMonth=' + '<%= lngStrMonth %>';
    url = url + '&cDay='   + '<%= lngStrDay   %>';

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winReceiptAll.focus();
    } else {
        winReceiptAll = window.open(url, '', 'toolbar=no,directories=no,menubar=no,resizable=yes,status=yes,scrollbars=yes,width=500,height=400');
    }

}

// ��t��ʂ�\��
function showReceipt( rsvNo, cslYear, cslMonth, cslDay ) {

    var opened = false;	// ��ʂ��J����Ă��邩
    var url;			// ��t��ʂ�URL

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winReceipt != null ) {
        if ( !winReceipt.closed ) {
            opened = true;
        }
    }

    // ��t��ʂ�URL�ҏW
    url = '/webHains/contents/receipt/rptEntry.asp';
    url = url + '?rsvNo=' + rsvNo;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winReceipt.focus();
        winReceipt.location.replace( url );
    } else {
        winReceipt = open( url, '', 'width=500,height=385,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

// �q�E�B���h�E�����
function closeWindow() {

    // ���t�K�C�h�����
    calGuide_closeGuideCalendar();

    // �c�̌����K�C�h�����
    orgGuide_closeGuideOrg();

    // ���ڃK�C�h�����
    closeGuideItm();

    // �ꊇ��t��ʂ����
    if ( winReceiptAll != null ) {
        if ( !winReceiptAll.closed ) {
            winReceiptAll.close();
        }
    }

    // ��t��ʂ����
    if ( winReceipt != null ) {
        if ( !winReceipt.closed ) {
            winReceipt.close();
        }
    }

    winReceiptAll = null;
    winReceipt    = null;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
<% '������[�h�̏ꍇTABLE�^�O��FONTSIZE�����΂�
   If lngPrint = 1 Then
%>
	TABLE { font-size:9px; }
<% End If %>

<% If strNavi <> "" Then %>
<% Else %>
	body { margin: 12px 0 0 5px; }
<% End If %>
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<% If strNavi <> "" Then %>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<% End If %>
<FORM NAME="dailysearch" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<%
    If strNavi <> "" Then
        Response.Write "<BLOCKQUOTE>"
    End If
%>
    <INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
    <INPUT TYPE="hidden" NAME="itemCd" VALUE="<%= strItemCd %>">
    <INPUT TYPE="hidden" NAME="grpCd"  VALUE="<%= strGrpCd  %>">
    <INPUT TYPE="hidden" NAME="navi"   VALUE="<%= strNavi   %>">

    <!-- �\�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="850">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">��f�҈ꗗ</FONT></B></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD HEIGHT="8"></TD>
        </TR>
    </TABLE>

    <SPAN STYLE="font-size:<%= IIf(lngPrint = 0, "12", "9") %>px;">
<%
    '���������E�������̕ҏW

    '�����L�[�̕ҏW
    If strKey <> "" Then
%>
        �u<FONT COLOR="#ff6600"><B><%= strKey %></B></FONT>�v
<%
    End If

    '��f�������̕ҏW
    Do

        '�o���Ƃ����w��̏ꍇ�͕ҏW���Ȃ�
        If dtmStrDate = 0 And dtmEndDate = 0 Then
            Exit Do
        End If

        '��������w��̏ꍇ�͂�������̒l�̂ݕҏW����
        If dtmStrDate = 0 Or dtmEndDate = 0 Then
            strDispDate = objCommon.FormatString(dtmStrDate + dtmEndDate, "yyyy�Nm��d��")
            Exit Do
        End If

        '�o���̒l�����l�Ȃ�Έ���̒l�̂ݕҏW����
        If dtmStrDate = dtmEndDate Then
            strDispDate = objCommon.FormatString(dtmStrDate, "yyyy�Nm��d��")
            Exit Do
        End If

        '�o���̒l���قȂ�Ύ��͊��Ԍ`���ŕҏW
        strDispDate = objCommon.FormatString(dtmStrDate, "yyyy�Nm��d��") & "�`" & objCommon.FormatString(dtmEndDate, "yyyy�Nm��d��")
        Exit Do
    Loop

    If strDispDate <> "" Then
%>
        �u<FONT COLOR="#ff6600"><B><%= strDispDate %></B></FONT>�v
<%
    End If

    If strKey <> "" Or strDispDate <> "" Then
%>
        �̎�f�҈ꗗ��\�����Ă��܂��B�������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>���ł��B
<%
    End If
%>
    </SPAN>

    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD HEIGHT="8"></TD>
        </TR>
    </TABLE>
<%
    '�������̓G�������g�̕ҏW
    Call EditEntryCondition()

    '�����l�̕ҏW
    Call EditCondition()

    Do
        '���b�Z�[�W���������Ă���ꍇ�͕ҏW���ď����I��
        If strMessage <> "" Then
%>
            <BR>&nbsp;<%= strMessage %>
<%
            Exit Do
        End If

        '�ʏ�\�����[�h�̏ꍇ
        If lngPrint = 0 Then

            'URL�̕ҏW
            strURL = Request.ServerVariables("SCRIPT_NAME")
            strURL = strURL & "?key="           & strKey
            strURL = strURL & "&strYear="       & lngStrYear
            strURL = strURL & "&strMonth="      & lngStrMonth
            strURL = strURL & "&strDay="        & lngStrDay
            strURL = strURL & "&endYear="       & lngEndYear
            strURL = strURL & "&endMonth="      & lngEndMonth
            strURL = strURL & "&endDay="        & lngEndDay
            strURL = strURL & "&csCd="          & strCsCd
            strURL = strURL & "&orgCd1="        & strOrgCd1
            strURL = strURL & "&orgCd2="        & strOrgCd2
            strURL = strURL & "&itemCd="        & strItemCd
            strURL = strURL & "&grpCd="         & strGrpCd
            strURL = strURL & "&prtField="      & strPrtField
            strURL = strURL & "&sortKey="       & lngSortKey
            strURL = strURL & "&sortType="      & lngSortType
            strURL = strURL & "&print="         & "1"
            strURL = strURL & "&startPos="      & lngStartPos
            strURL = strURL & "&getCount="      & strGetCount
            strURL = strURL & "&entry="         & strEntry
            strURL = strURL & "&rsvStat="       & strRsvStat
            strURL = strURL & "&rptStat="       & strRptStat
%>
            &nbsp;<A HREF="<%= strURL %>" TARGET="_top">����p�ɕ\��</A>
<%
        End If
%>
        <TABLE BORDER="0" CELLSPACING="<%= IIf(lngPrint = 0, "2", "1") %>" CELLPADDING="1">
<%
            '�^�C�g���s�̕ҏW
            Call EditTitle()

            For i = 0 To UBound(strArrRsvNo)
%>
                <TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>" VALIGN="top">
<%
                    '�e�\���񂲂Ƃ̕ҏW
                    For j = 0 To UBound(lngArrPrtField)

                        '��f���N��̂݉E��
                        Response.Write "<TD NOWRAP" & IIf(lngArrPrtField(j) = 9, " ALIGN=""right""", "") & ">"

                        Select Case lngArrPrtField(j)

                            Case 1	'���Ԙg

                            Case 2	'�����h�c
                                Response.Write strArrDayId(i)

                            Case 3	'�Ǘ��ԍ�

                            Case 4	'�R�[�X
                                If strArrCsName(i) <> "" Then
                                    Response.Write "<FONT COLOR=""#" & strArrWebColor(i) & """>��</FONT>" & strArrCsName(i)
                                End If

                            Case 5	'����
                                Response.Write strArrName(i)

                            Case 6	'�J�i����
                                Response.Write "�i" & strArrKanaName(i) & "�j"

                            Case 7	'����
                                Response.Write IIf(strArrGender(i) = "1", "�j", "��")

                            Case 8	'���N����
                                Response.Write objCommon.FormatString(strArrBirth(i), "gee.mm.dd")

                            Case 9	'��f���N��
                                If strArrAge(i) <> "" Then
                                    Response.Write Int(strArrAge(i)) & "��"
                                End If

                            Case 10	'�c�̗���
                                Response.Write strArrOrgSName(i)

                            Case 11	'�\��ԍ�
                                Response.Write strArrRsvNo(i)

                            Case 12	'��f��
                                Response.Write strArrCslDate(i)

                            Case 13	'�\���
                                Response.Write strArrRsvDate(i)

                            Case 14	'�ǉ�����
                                Call EditAddItem(strArrAddDiv(i), strArrAddName(i))

                            Case 15	'��t��(���g�p)

                            Case 16	'�l����
                                Response.Write "<SPAN STYLE=""font-size:9px;"">" & strArrKanaName(i) & "<BR></SPAN>" & strArrName(i)

                            Case 17	'�l�h�c
                                Response.Write strArrPerId(i)

                            Case 18	'��f����
                                Call EditConsultItem(strArrRequestName(i))

                            Case 19	'���呗�M(���g�p)

                            Case 20	'��f������̑��Γ�(���g�p)

                            Case 21	'�]�ƈ��ԍ�

                            Case 22	'���ۋL��
                                Response.Write strArrIsrSign(i)

                            Case 23	'���۔ԍ�
                                Response.Write strArrIsrNo(i)

                            Case 24	'���ƕ�����

                            Case 25	'��������

                            Case 26	'��������

                            Case 27	'��f���m��t���O

                            Case 28	'�n�b�q�p��f��

                            Case 29	'���̔ԍ�

                            Case 30	'��f�[�o�͓�

                            Case 31	'�݃J������f��

                            Case 32	'�T�u�R�[�X
                                Call EditSubCourse(strArrSubCsWebColor(i), strArrSubCsName(i))

                            Case 33	'�l���̌��ۋL��

                            Case 34	'�l���̌��۔ԍ�

                            Case 35	'���ʓ��͏��
                                Response.Write IIf(strArrEntry(i) = "0", "�S�ē���", IIf(strArrEntry(i) = "1", "�����͂���", ""))

                            Case 36	'�\���
                                If strArrRsvStatus(i) <> "" Then
                                    '#### 2007/04/04 �� �\��󋵋敪�ǉ��ɂ���ďC�� Start ####
                                    'Response.Write IIf(strArrRsvStatus(i) = "0", "�m��", "�ۗ�")
                                    Response.Write IIf(strArrRsvStatus(i) = "0", "�m��", IIf(strArrRsvStatus(i) = "1", "�ۗ�","���m��"))
                                    '#### 2007/04/04 �� �\��󋵋敪�ǉ��ɂ���ďC�� End   ####
                                End If

                            Case 37	'�m�F�͂����o�͓�
                                Response.Write strArrCardPrintDate(i)

                            Case 38	'�ꎮ�����o�͓�
                                Response.Write strArrFormPrintDate(i)

                            Case 39	'�\��Q����
                                Response.Write strArrRsvGrpName(i)

                            Case 40	'���A��l�L��
                                Response.Write IIf(CLng(strArrHasFriends(i)) > 0, "����", "")

                        End Select

                    Next

                    '�ʏ�\�����[�h�̏ꍇ�͑���p�̗��ҏW����
                    If lngPrint = 0 Then

                        If strArrRsvNo(i) <> "" Then
%>
                            <TD VALIGN="middle"><% EditButtonCol CLng(strArrRsvNo(i)), CLng(strArrCancelFlg(i)), CDate(strArrCslDate(i)), strArrPerId(i), strArrDayId(i), CDate(strArrCslDate(i)) %></TD>
<%
                        Else
%>
                            <TD></TD>
<%
                        End If

                    End If
%>
                </TR>
<%
            Next
%>
        </TABLE>
<%
        '�ʏ�\�����[�h�̏ꍇ�͏����I��
        If lngPrint <> 0 Then
            Exit Do
        End If

        '�S���������̓y�[�W���O�i�r�Q�[�^�s�v
        If Not IsNumeric(strGetCount) Then
            Exit Do
        End If

        'URL�̕ҏW
        strURL = Request.ServerVariables("SCRIPT_NAME")
        strURL = strURL & "?key="      & strKey
        strURL = strURL & "&strYear="  & lngStrYear
        strURL = strURL & "&strMonth=" & lngStrMonth
        strURL = strURL & "&strDay="   & lngStrDay
        strURL = strURL & "&endYear="  & lngEndYear
        strURL = strURL & "&endMonth=" & lngEndMonth
        strURL = strURL & "&endDay="   & lngEndDay
        strURL = strURL & "&csCd="     & strCsCd
        strURL = strURL & "&orgCd1="   & strOrgCd1
        strURL = strURL & "&orgCd2="   & strOrgCd2
        strURL = strURL & "&itemCd="   & strItemCd
        strURL = strURL & "&grpCd="    & strGrpCd
        strURL = strURL & "&prtField=" & strPrtField
        strURL = strURL & "&sortKey="  & lngSortKey
        strURL = strURL & "&sortType=" & lngSortType
        strURL = strURL & "&navi="     & strNavi
        strURL = strURL & "&entry="    & strEntry
        strURL = strURL & "&rsvStat="  & strRsvStat
        strURL = strURL & "&rptStat="  & strRptStat

'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� START ################################################################
        strURL = strURL & "&cslDivCd="  & strCslDivCd
'## 2013/04/15 Add By �� ���������Ɂu��f�敪�v�ǉ� END   ################################################################

        '�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
        <%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
        Exit Do
    Loop

    If strNavi <> "" Then
        Response.Write "</BLOCKQUOTE>"
    End If
%>
</FORM>
<script type="text/javascript">
document.dailysearch.onsubmit = function()
{
	document.body.style.cursor = 'wait';
};

window.onload = function()
{
	document.body.style.cursor = 'auto';

	var targetFrame = top.frames['Calendar'];
	if ( targetFrame ) {
		targetFrame.document.body.style.cursor = 'auto';
	}
	
	
};
</script>
</BODY>
</HTML>
