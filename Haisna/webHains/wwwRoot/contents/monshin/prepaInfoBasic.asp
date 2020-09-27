<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       ��{��񁕌l�������X�V  (Ver0.0.1)
'       AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const BASEINFO_GRPCD = "X039"        '��{���@�������ڃO���[�v�R�[�h

Dim objCommon               '���ʃN���X
'Dim objInterview           '�ʐڃN���X
Dim objConsult              '��f�N���X
Dim objOrganization         '�c�̏��A�N�Z�X�p
Dim objPerResult            '�l�������ʏ��A�N�Z�X�p
'Dim objSentence            '���̓A�N�Z�X�p

'�p�����[�^
Dim strAction               '����
Dim lngRsvNo                '�\��ԍ�

'��f���p�ϐ�
Dim strPerId                '�lID
Dim strCslDate              '��f��
Dim strCsCd                 '�R�[�X�R�[�h
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
Dim strOrgCd1               '�c�̃R�[�h1
Dim strOrgCd2               '�c�̃R�[�h2
Dim strOrgName              '�c�̖���
Dim strOrgKName             '�c�̃J�i����

'�l�������ڏ��p�ϐ�
Dim vntItemCd               '�������ڃR�[�h
Dim vntSuffix               '�T�t�B�b�N�X
Dim vntItemName             '�������ږ�
Dim vntResult               '��������
Dim vntResultType           '���ʃ^�C�v
Dim vntItemType             '���ڃ^�C�v
Dim vntStcItemCd            '���͎Q�Ɨp���ڃR�[�h
Dim vntStcCd                '���̓R�[�h
Dim vntShortStc             '���͗���
Dim vntIspDate              '������

Dim vntEdtResult            '�������ʁi�ύX��j

'�ۑ��p�G���A
Dim vntUpdItemCd            '�������ڃR�[�h
Dim vntUpdSuffix            '�T�t�B�b�N�X
Dim vntUpdResult            '��������
Dim vntUpdIspDate           '������
Dim vntUpdUpdDiv            '�X�V�敪

'�폜�p�G���A
Dim vntDelItemCd            '�������ڃR�[�h
Dim vntDelSuffix            '�T�t�B�b�N�X

'�Ώی������ڃR�[�h�A�T�t�B�b�N�X
Dim strArrItemCd()
Dim strArrSuffix()

'�R���{�{�b�N�X�Œ�l�ݒ�G���A
Dim strArrStcCd1()
Dim strArrShortStc1()
Dim strArrStcCd2()
Dim strArrShortStc2()
Dim strArrStcCd3()
Dim strArrShortStc3()
Dim strArrStcCd4()
Dim strArrShortStc4()
Dim strArrStcCd5()
Dim strArrShortStc5()
Dim strArrStcCd6()
Dim strArrShortStc6()
Dim strArrStcCd7()
Dim strArrShortStc7()
Dim strArrStcCd8()
Dim strArrShortStc8()
Dim strArrStcCd9()
Dim strArrShortStc9()
Dim strArrStcCd10()
Dim strArrShortStc10()
Dim strArrStcCd11()
Dim strArrShortStc11()
Dim strArrStcCd12()
Dim strArrShortStc12()
Dim strArrStcCd13()
Dim strArrShortStc13()
'### 2009/03/23 �� �ی��w���ΏۗL���`�F�b�N���ڒǉ� ###
Dim strArrStcCd14()
Dim strArrShortStc14()

Dim strArrStcCd                '���̓R�[�h
Dim strArrShortStc            '���͗���

Dim Ret                        '���A�l
Dim lngConsCount            '��f��
Dim lngPerRslCount            '�l�������ڏ��
Dim lngStcCount                '���͐�
Dim i, j                    '�J�E���^�[
Dim lngUpdCount                '�o�^�f�[�^����
Dim lngDelCount                '�폜�f�[�^����

Dim strArrMessage            '�G���[���b�Z�[�W
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
'Set objInterview = Server.CreateObject("HainsInterview.Interview")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")
'Set objSentence = Server.CreateObject("HainsSentence.Sentence")

'�����l�̎擾
strAction            = Request("action")
lngRsvNo            = Request("rsvno")

vntItemCd            = ConvIStringToArray(Request("itemcd"))
vntSuffix            = ConvIStringToArray(Request("suffix"))
vntResult            = ConvIStringToArray(Request("orgresult"))
vntEdtResult        = ConvIStringToArray(Request("perrsl"))

Call SetDropDownList()

Do

    '��f��񌟍�
    Ret = objConsult.SelectConsult(lngRsvNo, _
                                    , _
                                    strCslDate,    _
                                    strPerId,      _
                                    strCsCd,       _
                                    strCsName,     _
                                    strOrgCd1, _
                                    strOrgCd2, _
                                    strOrgName,     _
                                    , , _
                                    strAge,        _
                                    , , , , , , , , , , , , , , , _
                                    0, , , , , , , , , , , , , , , _
                                    strLastName,   _
                                    strFirstName,  _
                                    strLastKName,  _
                                    strFirstKName, _
                                    strBirth,      _
                                    strGender, _
                                    , , , , , , lngConsCount )

    '��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
    If Ret = False Then
        Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
    End If


    '�c�̃e�[�u�����R�[�h�ǂݍ���
    Ret = objOrganization.SelectOrg_Lukes( strOrgCd1, strOrgCd2, , strOrgKName )
    If Ret = False Then
        Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B�i�c�̃R�[�h= " & strOrgCd1 & "-" & strOrgCd2 & " )"
    End If

    '�ۑ�
    If strAction = "save" Then
        strArrMessage = ""
        lngUpdCount = 0
        lngDelCount = 0
        For i = 0 To UBound(vntResult)
            '�ύX���ꂽ�H
            If ( vntResult(i) <> vntEdtResult(i) ) Then
                'null�ɕύX���ꂽ�H
                If vntEdtResult(i) = "" Then
                    If lngDelCount = 0 Then
                        vntDelItemCd = Array()
                        vntDelSuffix = Array()
                    End If
                    Redim Preserve vntDelItemCd(lngDelCount)
                    Redim Preserve vntDelSuffix(lngDelCount)
                    vntDelItemCd(lngDelCount)  = vntItemCd(i)
                    vntDelSuffix(lngDelCount)  = vntSuffix(i)
                    lngDelCount = lngDelCount + 1
                Else
                    If lngUpdCount = 0 Then
                        vntUpdItemCd = Array()
                        vntUpdSuffix = Array()
                        vntUpdResult = Array()
                        vntUpdIspDate = Array()
                        vntUpdUpdDiv = Array()
                    End If
                    Redim Preserve vntUpdItemCd(lngUpdCount)
                    Redim Preserve vntUpdSuffix(lngUpdCount)
                    Redim Preserve vntUpdResult(lngUpdCount)
                    Redim Preserve vntUpdIspDate(lngUpdCount)
                    Redim Preserve vntUpdUpdDiv(lngUpdCount)
                    vntUpdItemCd(lngUpdCount)  = vntItemCd(i)
                    vntUpdSuffix(lngUpdCount)  = vntSuffix(i)
                    vntUpdResult(lngUpdCount)  = vntEdtResult(i)
                    vntUpdIspDate(lngUpdCount) = now
                    vntUpdUpdDiv(lngUpdCount) = 0
                    lngUpdCount = lngUpdCount + 1
                End If
            End If 
        Next
        '�ύX���ڂ���H
        If lngUpdCount > 0 Then
            Ret = objPerResult.MergePerResult ( _
                                strPerId, vntUpdItemCd, vntUpdSuffix, vntUpdResult, vntUpdIspDate, vntUpdUpdDiv )
            If Ret = False Then
                strArrMessage = "�ۑ��Ɏ��s���܂����B"
            End If
        End If
        '�폜���ڂ���H
        If lngDelCount > 0 Then
            Ret = objPerResult.DeletePerResult ( _
                                strPerId, vntDelItemCd, vntDelSuffix )
            If Ret = False Then
                strArrMessage = "�ۑ��Ɏ��s���܂����B"
            End If
        End If
        
        If strArrMessage = "" Then
            strAction = "saveend"
        End If
    End If

    '�l�������ʏ��擾
    lngPerRslCount = objPerResult.SelectPerResultGrpList( strPerId, _
                                                        BASEINFO_GRPCD, _
                                                        0, 1, _
                                                        vntItemCd, _
                                                        vntSuffix, _
                                                        vntItemName, _
                                                        vntResult, _
                                                        vntResultType, _
                                                        vntItemType, _
                                                        vntStcItemCd, _
                                                        vntShortStc, _
                                                        vntIspDate _
                                                        )
    If lngPerRslCount < 0 Then
        Err.Raise 1000, , "�l�������ʏ�񂪑��݂��܂���B�i�lID= " & strPerId & " )"
    End If

    '�ۑ��p�G���A�ɑޔ�
    vntEdtResult = vntResult

    Exit Do
Loop

%>
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �eSELECT�^�O�̔z�񖼏̃Z�b�g
'
' �����@�@ : 
'
' �߂�l�@ : 
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function SetDropDownList()

'### 2009/03/23 �� �ی��w���ΏۗL���`�F�b�N���ڒǉ��̈׏C�� ###
'    Redim Preserve strArrItemCd(12)
'    Redim Preserve strArrSuffix(12)
    Redim Preserve strArrItemCd(13)
    Redim Preserve strArrSuffix(13)

    '�Տ��̌�
    strArrItemCd(0) = "80013":strArrSuffix(0) = "00"
    '�̌����w��
    strArrItemCd(1) = "80016":strArrSuffix(1) = "00"
    '�d�c�s�`
    strArrItemCd(2) = "80015":strArrSuffix(2) = "00"
    '������
    strArrItemCd(3) = "80017":strArrSuffix(3) = "00"
    '�
    strArrItemCd(4) = "80011":strArrSuffix(4) = "00"
    '����
    strArrItemCd(5) = "80012":strArrSuffix(5) = "00"
    '�y�[�X���[�J
    strArrItemCd(6) = "80010":strArrSuffix(6) = "00"
    '�`��
    strArrItemCd(7) = "80018":strArrSuffix(7) = "00"
    '���
    strArrItemCd(8) = "80021":strArrSuffix(8) = "00"
    '�A���R�[��
    strArrItemCd(9) = "80014":strArrSuffix(9) = "00"
    '��A�����M�[
    strArrItemCd(10) = "80019":strArrSuffix(10) = "00"
    '�ݒ���p
    strArrItemCd(11) = "80020":strArrSuffix(11) = "00"
    '�{�����e�B�A���
    strArrItemCd(12) = "80022":strArrSuffix(12) = "00"
'### 2009/03/23 �� �ی��w���ΏۗL���`�F�b�N���ڒǉ� Start ###
    '�ی��w��
    strArrItemCd(13) = "80023":strArrSuffix(13) = "00"
'### 2009/03/23 �� �ی��w���ΏۗL���`�F�b�N���ڒǉ� End   ###

    '�Տ��̌�
    Redim Preserve strArrStcCd1(2)
    Redim Preserve strArrShortStc1(2)
    strArrStcCd1(0) = "2":strArrShortStc1(0) = "�Տ��̌�"
    strArrStcCd1(1) = "3":strArrShortStc1(1) = "�̌�����"
    strArrStcCd1(2) = "4":strArrShortStc1(2) = "�̌���C���s��"

    '�̌����w��
    Redim Preserve strArrStcCd2(2)
    Redim Preserve strArrShortStc2(2)
    strArrStcCd2(0) = "2":strArrShortStc2(0) = "�̌��E�r"
    strArrStcCd2(1) = "3":strArrShortStc2(1) = "�̌����r"
    strArrStcCd2(2) = "4":strArrShortStc2(2) = "�̌���"

    '�d�c�s�`
    Redim Preserve strArrStcCd3(1)
    Redim Preserve strArrShortStc3(1)
    strArrStcCd3(0) = "2":strArrShortStc3(0) = "�d�c�s�`�ÏW"
    strArrStcCd3(1) = "3":strArrShortStc3(1) = "�d�c�s�`�ÏW����o"

    '������
'### 2016.07.18 �� �g�h�u�ǉ��̈׏C�� STR ################################
'    Redim Preserve strArrStcCd4(4)
'    Redim Preserve strArrShortStc4(4)
    Redim Preserve strArrStcCd4(5)
    Redim Preserve strArrShortStc4(5)
'### 2016.07.18 �� �g�h�u�ǉ��̈׏C�� END ################################
    strArrStcCd4(0) = "2":strArrShortStc4(0) = "�s��"
    strArrStcCd4(1) = "3":strArrShortStc4(1) = "�g�a��"
    strArrStcCd4(2) = "4":strArrShortStc4(2) = "�g�b�u"
    strArrStcCd4(3) = "5":strArrShortStc4(3) = "�u�c�q�k"
    strArrStcCd4(4) = "6":strArrShortStc4(4) = "�s�o�g�`"
'### 2016.07.18 �� �g�h�u�ǉ� STR ########################################
    strArrStcCd4(5) = "7":strArrShortStc4(5) = "�g�h�u"
'### 2016.07.18 �� �g�h�u�ǉ� END ########################################

    '�
    Redim Preserve strArrStcCd5(4)
    Redim Preserve strArrShortStc5(4)
    strArrStcCd5(0) = "2":strArrShortStc5(0) = "��"
    strArrStcCd5(1) = "3":strArrShortStc5(1) = "�E"
    strArrStcCd5(2) = "4":strArrShortStc5(2) = "����"
    strArrStcCd5(3) = "5":strArrShortStc5(3) = "�낤��"
    strArrStcCd5(4) = "6":strArrShortStc5(4) = "�⒮��"

    '����
    Redim Preserve strArrStcCd6(7)
    Redim Preserve strArrShortStc6(7)
    strArrStcCd6(0) = "2":strArrShortStc6(0) = "������"
    strArrStcCd6(1) = "3":strArrShortStc6(1) = "�����E"
    strArrStcCd6(2) = "4":strArrShortStc6(2) = "������"
    strArrStcCd6(3) = "5":strArrShortStc6(3) = "�㎋��"
    strArrStcCd6(4) = "6":strArrShortStc6(4) = "�㎋�E"
    strArrStcCd6(5) = "7":strArrShortStc6(5) = "�㎋����"
    strArrStcCd6(6) = "8":strArrShortStc6(6) = "�`�፶"
    strArrStcCd6(7) = "9":strArrShortStc6(7) = "�`��E"

    '�y�[�X���[�J
    Redim Preserve strArrStcCd7(0)
    Redim Preserve strArrShortStc7(0)
    strArrStcCd7(0) = "2":strArrShortStc7(0) = "����"

    '�`��
    Redim Preserve strArrStcCd8(1)
    Redim Preserve strArrShortStc8(1)
    strArrStcCd8(0) = "2":strArrShortStc8(0) = "�`������"
    strArrStcCd8(1) = "3":strArrShortStc8(1) = "�����"

    '���
    Redim Preserve strArrStcCd9(1)
    Redim Preserve strArrShortStc9(1)
    strArrStcCd9(0) = "2":strArrShortStc9(0) = "�v�E������"
    strArrStcCd9(1) = "3":strArrShortStc9(1) = "�Ԉ֎q"

    '�A���R�[��
    Redim Preserve strArrStcCd10(0)
    Redim Preserve strArrShortStc10(0)
    strArrStcCd10(0) = "2":strArrShortStc10(0) = "����"

    '��A�����M�[
    Redim Preserve strArrStcCd11(0)
    Redim Preserve strArrShortStc11(0)
    strArrStcCd11(0) = "2":strArrShortStc11(0) = "����"

    '�ݒ���p
    Redim Preserve strArrStcCd12(3)
    Redim Preserve strArrShortStc12(3)
    strArrStcCd12(0) = "2":strArrShortStc12(0) = "�ݑS�E"
    strArrStcCd12(1) = "3":strArrShortStc12(1) = "�݈��S�E"
    strArrStcCd12(2) = "4":strArrShortStc12(2) = "�X�g�[�}"
    strArrStcCd12(3) = "5":strArrShortStc12(3) = "�f�h��C���s��"

    '�{�����e�B�A���
    Redim Preserve strArrStcCd13(2)
    Redim Preserve strArrShortStc13(2)
    strArrStcCd13(0) = "2":strArrShortStc13(0) = "�ʖ�v"
    strArrStcCd13(1) = "3":strArrShortStc13(1) = "���p"
    strArrStcCd13(2) = "4":strArrShortStc13(2) = "�ʖ󁕉��v"

'### 2009/03/23 �� �ی��w���ΏۗL���`�F�b�N���ڒǉ� Start ###
    '�ی��w��
    Redim Preserve strArrStcCd14(0)
    Redim Preserve strArrShortStc14(0)
    strArrStcCd14(0) = "2":strArrShortStc14(0) = "�Ώ�"
'### 2009/03/23 �� �ی��w���ΏۗL���`�F�b�N���ڒǉ� End   ###

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �R�[�h�E���̔z�񂩂��SELECT�^�O�����i�I�����C�x���g��������j
'
' �����@�@ : (In)     strName             �G�������g��
' �@�@�@�@   (In)     strArrCode          �R�[�h�̔z��
' �@�@�@�@   (In)     strArrName          ���̂̔z��
' �@�@�@�@   (In)     strSelectedCode     �f�t�H���g�̑I���R�[�h�l
' �@�@�@�@   (In)     strNonSelDelFlg     ���I��p�󃊃X�g�폜�t���O(1:�폜)
' �@�@�@�@   (In)     strStyle            SELECT�^�O��STYLE�w��
'
' �߂�l�@ : SELECT�^�O
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditDropDownListFromArray3(strName, strArrCode, strArrName, strSelectedCode, strNonSelDelFlg, strStyle)

    Dim strHTML     'HTML������
    Dim i           '�C���f�b�N�X
    Dim objCommon    '

    Set objCommon = CreateObject("HainsCommon.Common")

    'SELECT�^�O�̊J�n
    strHTML = "<SELECT NAME=""" & strName & """ " & strStyle & ">"

    '���I��p�̋󃊃X�g���쐬
    If strNonSelDelFlg = NON_SELECTED_ADD Then
        strHTML = strHTML & vbLf & "<OPTION VALUE="""">&nbsp;"
    End If

    '�u���ׂāv�I��p�̃��X�g���쐬
    If strNonSelDelFlg = SELECTED_ALL Then
        strHTML = strHTML & vbLf & "<OPTION VALUE="""">���ׂ�"
    End If

    '�z��Y�������̃��X�g��ǉ�
    If Not IsEmpty(strArrCode) Then
        For i = 0 To UBound(strArrCode)
            strHTML = strHTML & "<OPTION VALUE=""" & strArrCode(i) & """" & IIf(CStr(strArrCode(i)) = CStr(strSelectedCode), " SELECTED", "") & ">" & strArrName(i)
        Next
    End If

    strHTML = strHTML & vbLf & "</SELECT>"

    EditDropDownListFromArray3 = strHTML

End Function
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��{���</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function savePerRsl() {

    if ( !confirm('�l��{����o�^���܂��B��낵���ł����H')){
        return;
    }

    document.baseInfo.action.value = "save";
    document.baseInfo.submit();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<style type="text/css">
    body { margin: 0 0 0 3px; }
</style>
</HEAD>
<BODY>
<FORM NAME="baseInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">��{���</FONT></B></TD>
        </TR>
    </TABLE>
    <!-- ��{���̕\�� -->
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" style="margin: 5px 0 0 0;">
        <TR>
            <TD VALIGN="top" NOWRAP>�l��</TD>
            <TD VALIGN="top">�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP><%=strPerId%></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP><%= strLastName %>�@<%= strFirstName %>�@<FONT COLOR="#999999">�i<%= strLastKName %>�@<%= strFirstKName %>�j</FONT></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP><%= objCommon.FormatString(strBirth, "gee.mm.dd") %>�� <%= Int(strAge) %>�� <%= IIf(strGender = "1", "�j��", "����") %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD VALIGN="top"  nowrap>�c�̖�</TD>
            <TD VALIGN="top">�F</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP><%= strOrgCd1 %>-<%= strOrgCd2 %></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP><%= strOrgName %>�@<FONT COLOR="#999999">�i<%= strOrgKName %>�j</FONT></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD nowrap>��f��</TD>
            <TD VALIGN="top">�F</TD>
            <TD><%= lngConsCount %></TD>
        </TR>
        <TR>
            <TD><IMG SRC="../../images/space.gif" ALT="" HEIGHT="5" WIDTH="1" BORDER="0"></TD>
        </TR>
        <TR>
            <TD NOWRAP colspan="3">
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <A HREF="JavaScript:savePerRsl()"><IMG SRC="../../images/save.gif" ALT="��{���̓o�^���s���܂�" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
            </TD>
        </TR>
    </TABLE>

<%
    '���b�Z�[�W�̕ҏW
    If strAction <> "" Then

        Select Case strAction

            '�ۑ��������́u�ۑ������v�̒ʒm
            Case "saveend"
                Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

            '�����Ȃ��΃G���[���b�Z�[�W��ҏW
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

    End If
%>
    <!-- �l������� -->
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
<%
lngPerRslCount = IIf(lngPerRslCount=0, -1, lngPerRslCount)
For i=0 To lngPerRslCount-1
    lngStcCount = 0
    Select Case CStr(Trim(vntItemCd(i)) & Trim(vntSuffix(i)))
        Case CStr(Trim(strArrItemCd(0)) & Trim(strArrSuffix(0)))
            strArrStcCd    = strArrStcCd1
            strArrShortStc = strArrShortStc1
            lngStcCount = UBound(strArrStcCd1) + 1
        Case CStr(Trim(strArrItemCd(1)) & Trim(strArrSuffix(1)))
            strArrStcCd    = strArrStcCd2
            strArrShortStc = strArrShortStc2
            lngStcCount = UBound(strArrStcCd2) + 1
        Case CStr(Trim(strArrItemCd(2)) & Trim(strArrSuffix(2)))
            strArrStcCd    = strArrStcCd3
            strArrShortStc = strArrShortStc3
            lngStcCount = UBound(strArrStcCd3) + 1
        Case CStr(Trim(strArrItemCd(3)) & Trim(strArrSuffix(3)))
            strArrStcCd    = strArrStcCd4
            strArrShortStc = strArrShortStc4
            lngStcCount = UBound(strArrStcCd4) + 1
        Case CStr(Trim(strArrItemCd(4)) & Trim(strArrSuffix(4)))
            strArrStcCd    = strArrStcCd5
            strArrShortStc = strArrShortStc5
            lngStcCount = UBound(strArrStcCd5) + 1
        Case CStr(Trim(strArrItemCd(5)) & Trim(strArrSuffix(5)))
            strArrStcCd    = strArrStcCd6
            strArrShortStc = strArrShortStc6
            lngStcCount = UBound(strArrStcCd6) + 1
        Case CStr(Trim(strArrItemCd(6)) & Trim(strArrSuffix(6)))
            strArrStcCd    = strArrStcCd7
            strArrShortStc = strArrShortStc7
            lngStcCount = UBound(strArrStcCd7) + 1
        Case CStr(Trim(strArrItemCd(7)) & Trim(strArrSuffix(7)))
            strArrStcCd    = strArrStcCd8
            strArrShortStc = strArrShortStc8
            lngStcCount = UBound(strArrStcCd8) + 1
        Case CStr(Trim(strArrItemCd(8)) & Trim(strArrSuffix(8)))
            strArrStcCd    = strArrStcCd9
            strArrShortStc = strArrShortStc9
            lngStcCount = UBound(strArrStcCd9) + 1
        Case CStr(Trim(strArrItemCd(9)) & Trim(strArrSuffix(9)))
            strArrStcCd    = strArrStcCd10
            strArrShortStc = strArrShortStc10
            lngStcCount = UBound(strArrStcCd10) + 1
        Case CStr(Trim(strArrItemCd(10)) & Trim(strArrSuffix(10)))
            strArrStcCd    = strArrStcCd11
            strArrShortStc = strArrShortStc11
            lngStcCount = UBound(strArrStcCd11) + 1
        Case CStr(Trim(strArrItemCd(11)) & Trim(strArrSuffix(11)))
            strArrStcCd    = strArrStcCd12
            strArrShortStc = strArrShortStc12
            lngStcCount = UBound(strArrStcCd12) + 1
        Case CStr(Trim(strArrItemCd(12)) & Trim(strArrSuffix(12)))
            strArrStcCd    = strArrStcCd13
            strArrShortStc = strArrShortStc13
            lngStcCount = UBound(strArrStcCd13) + 1

        '### 2009/03/23 �� �ی��w���ΏۗL���`�F�b�N���ڒǉ� Start ###
        Case CStr(Trim(strArrItemCd(13)) & Trim(strArrSuffix(13)))
            strArrStcCd    = strArrStcCd14
            strArrShortStc = strArrShortStc14
            lngStcCount = UBound(strArrStcCd14) + 1
        '### 2009/03/23 �� �ی��w���ΏۗL���`�F�b�N���ڒǉ� End   ###

        Case Else
            Exit For
    End Select

%>
        <TR>
            <INPUT TYPE="hidden" NAME="itemcd" VALUE="<%= vntItemCd(i) %>">
            <INPUT TYPE="hidden" NAME="suffix" VALUE="<%= vntSuffix(i) %>">
            <INPUT TYPE="hidden" NAME="orgresult" VALUE="<%= vntResult(i) %>">
            <TD NOWRAP><%= vntItemName(i) %></TD>
            <TD WIDTH="12">�F</TD>
<%
    If lngStcCount > 0 Then
%>
            <TD><%= EditDropDownListFromArray3("perrsl", strArrStcCd, strArrShortStc, vntEdtResult(i), NON_SELECTED_ADD, "STYLE=""width:130px""") %></TD>
<%
    End If
%>
        </TR>
<%
Next
%>
    </TABLE>
</FORM>
</BODY>
</HTML>
