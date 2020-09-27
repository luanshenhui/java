<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'   �c�̓����䒠 (Ver0.0.1)
'   AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"          -->
<!-- #include virtual = "/webHains/includes/common.inc"                -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"           -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"        -->
<!-- #include virtual = "/webHains/includes/print.inc"                 -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc"  -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseTable.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editReportList.inc"  -->
<%

'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode         '������[�h
Dim vntMessage      '�ʒm���b�Z�[�W
Dim strURL          'URL
Dim UID
'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon       '���ʃN���X
Dim objOrganization '�c�̏��A�N�Z�X�p
Dim objOrgBsd       '���ƕ����A�N�Z�X�p
Dim objOrgRoom      '�������A�N�Z�X�p
Dim objOrgPost      '�������A�N�Z�X�p
Dim objPerson       '�l���A�N�Z�X�p

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'�����l
Dim strSCslYear, strSCslMonth, strSCslDay       '���ߓ�(��)
Dim strECslYear, strECslMonth, strECslDay       '���ߓ�(��)
Dim strSCslYear2, strSCslMonth2, strSCslDay2    '������(��)
Dim strECslYear2, strECslMonth2, strECslDay2    '������(��)
Dim strOutPutCls                                '�敪�i�O�F�S�ā@�P�F�����@�Q�F�����j
'## 2011.08.31 MOD �� ���я��I���ł���悤�ɕύX�i�u��������������ʁ������ԍ��v�Ɓu��������������ʁ��c�̃J�i���́v���őI���j START
Dim strSortKind                                 '���я��i�P�F�����ԍ����@�Q�F�c�̖��̏��j
'## 2011.08.31 MOD �� ���я��I���ł���悤�ɕύX�i�u��������������ʁ������ԍ��v�Ɓu��������������ʁ��c�̃J�i���́v���őI���j END
'��������������������

'��Ɨp�ϐ�
Dim strOrgName      '�c�̖�
Dim strBsdName      '���ƕ���
Dim strRoomName     '������
Dim strSPostName    '�J�n������
Dim strEPostName    '�I��������
Dim strLastName     '��
Dim strFirstName    '��
Dim strPerName      '����
Dim strSCslDate     '���ߊJ�n��
Dim strECslDate     '���ߏI����
Dim strSCslDate2    '�����J�n��
Dim strECslDate2    '�����I����
Dim strArrCourse    '�R�[�X�R�[�h
Dim strArrSubCourse '�T�u�R�[�X�R�[�h
Dim i, j            '�J�E���^

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'���ʈ����l�̎擾
strMode = Request("mode")

'���[�o�͏�������
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : URL�����l�̎擾
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : URL�̈����l���擾���鏈�����L�q���ĉ�����
'
'-------------------------------------------------------------------------------
Sub GetQueryString()
'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
    '���ʓ��̕������HTML���ŋL�q�������ڂ̖��̂ƂȂ�܂�

'�� �J�n�N����
    If IsEmpty(Request("strCslYear")) Then
        strSCslYear   = Year(Now())             '�J�n�N
        strSCslMonth  = Month(Now())            '�J�n��
        strSCslDay    = Day(Now())              '�J�n��
    Else
        strSCslYear   = Request("strCslYear")   '�J�n�N
        strSCslMonth  = Request("strCslMonth")  '�J�n��
        strSCslDay    = Request("strCslDay")    '�J�n��
    End If
    strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
    If IsEmpty(Request("endCslYear")) Then
        strECslYear   = Year(Now())             '�I���N
        strECslMonth  = Month(Now())            '�J�n��
        strECslDay    = Day(Now())              '�J�n��
    Else
        strECslYear   = Request("endCslYear")   '�I���N
        strECslMonth  = Request("endCslMonth")  '�J�n��
        strECslDay    = Request("endCslDay")    '�J�n��
    End If
    strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'�� �J�n�N�����ƏI���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
    If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
       Right("00" & Trim(CStr(strSCslMonth)), 2) & _
       Right("00" & Trim(CStr(strSCslDay)), 2) _
     > Right("0000" & Trim(CStr(strECslYear)), 4) & _
       Right("00" & Trim(CStr(strECslMonth)), 2) & _
       Right("00" & Trim(CStr(strECslDay)), 2) Then
        strSCslYear   = strECslYear
        strSCslMonth  = strECslMonth
        strSCslDay    = strECslDay
        strSCslDate   = strECslDate
        strECslYear   = Request("strCslYear")   '�J�n�N
        strECslMonth  = Request("strCslMonth")  '�J�n��
        strECslDay    = Request("strCslDay")    '�J�n��
        strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
    End If
'�� �J�n�����N����
    If IsEmpty(Request("strCslYear2")) Then
    Else
        strSCslYear2   = Request("strCslYear2")     '�J�n�N
        strSCslMonth2  = Request("strCslMonth2")    '�J�n��
        strSCslDay2   = Request("strCslDay2")       '�J�n��
    End If
    strSCslDate2   = strSCslYear2 & "/" & strSCslMonth2 & "/" & strSCslDay2
'�� �I�������N����
    If IsEmpty(Request("endCslYear2")) Then
    Else
        strECslYear2   = Request("endCslYear2")     '�I���N
        strECslMonth2  = Request("endCslMonth2")    '�J�n��
        strECslDay2    = Request("endCslDay2")      '�J�n��
    End If
    strECslDate2    = strECslYear2 & "/" & strECslMonth2 & "/" & strECslDay2
'�� �敪
    strOutputCls    = Request("outputCls")

'## 2011.08.31 MOD �� ���я��I���ł���悤�ɕύX�i�u��������������ʁ������ԍ��v�Ɓu��������������ʁ��c�̃J�i���́v���őI���j START
'�� ���я�
    strSortKind    = Request("sortKind")
'## 2011.08.31 MOD �� ���я��I���ł���悤�ɕύX�i�u��������������ʁ������ԍ��v�Ɓu��������������ʁ��c�̃J�i���́v���őI���j END


UID = Session("USERID")

'��������������������
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
    '�����Ƀ`�F�b�N�������L�q
    With objCommon
'��)        .AppendArray vntArrMessage, �R�����g

'       If strMode <> "" Then
            If Not IsDate(strECslDate2) Then
                strECslDate2 = strSCslDate2
            End If
'�@�@�@�@�@ End If

    End With
'��������������������

    '�߂�l�̕ҏW
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���[�h�L�������g�t�@�C���쐬����
'
' �����@�@ :
'
' �߂�l�@ : ������O���̃V�[�P���X�l
'
' ���l�@�@ : ���[�h�L�������g�t�@�C���쐬���\�b�h���Ăяo���B���\�b�h���ł͎��̏������s����B
' �@�@�@�@   ?@������O���̍쐬
' �@�@�@�@   ?A���[�h�L�������g�t�@�C���̍쐬
' �@�@�@�@   ?B�����������͈�����O��񃌃R�[�h�̎�L�[�ł���v�����gSEQ��߂�l�Ƃ��ĕԂ��B
' �@�@�@�@   ����SEQ�l�����Ɉȍ~�̃n���h�����O���s���B
'
'-------------------------------------------------------------------------------
Function Print()

    Dim objPrintCls 'COM�R���|�[�l���g
    Dim Ret         '�֐��߂�l
'Dim objCommon
    If Not IsArray(CheckValue()) Then

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
'		Set objPrintCls = Server.CreateObject("HainsCameraList.CameraList")
'		'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
'		Ret = objPrintCls.PrintCameraList(Session("USERID"), , strSCslDate, strECslDate, strCsCd, strFilmNo)
'��������������������
'		Print = Ret
'Set objCommon = Server.CreateObject("HainsCommon.Common")
'strURL = "/webHains/contents/report_form/rd_31_prtNurseCheck.asp"
'strURL = strURL & "?p_Uid=" & UID
'strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
'Set objCommon = Nothing
'Response.Redirect strURL
'Response.End


        '�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
        Set objPrintCls = Server.CreateObject("HainsprtPaymentList.prtPaymentList")
        '�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j

'## 2011.08.31 MOD �� ���я��I���ł���悤�ɕύX�i�u��������������ʁ������ԍ��v�Ɓu��������������ʁ��c�̃J�i���́v���őI���j START
'        Ret = objPrintCls.Printout(UID, strSCslDate, strECslDate, strOutputCls, strSCslDate2, strECslDate2)
        Ret = objPrintCls.Printout(UID, strSCslDate, strECslDate, strOutputCls, strSCslDate2, strECslDate2, strSortKind)
'## 2011.08.31 MOD �� ���я��I���ł���悤�ɕύX�i�u��������������ʁ������ԍ��v�Ɓu��������������ʁ��c�̃J�i���́v���őI���j END

        print=Ret
'       print=strScslDate
'       print=strEcslDate

    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--- �� ��<Title>�̏C����Y��Ȃ��悤�� �� -->
<TITLE>�c�̓����䒠</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setElement() {
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
    <BLOCKQUOTE>

<!--- �^�C�g�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">���c�̓����䒠</SPAN></B></TD>
        </TR>
    </TABLE>
<%
    '�G���[���b�Z�[�W�\��
    Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
    <BR>

<!--- ���t -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD><FONT COLOR="#ff0000">��</FONT></TD>
            <TD WIDTH="90" NOWRAP>���ߓ�</TD>
            <TD> �F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
            <TD>��</TD>

            <TD>�`</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
            <TD>�N</TD>
            <TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
            <TD>��</TD>
            <TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
            <TD>��</TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <td><font color="#ff0000">��</font></td>
            <TD WIDTH="90" NOWRAP>�o�͋敪</TD>
            <TD>�F</TD>
            <TD><select name="outputCls" size="1">
                    <option selected value="0">�S��</option>
                    <option value="1">����</option>
                    <option value="2">�����ς�</option>
                </select></TD>
        </TR>
    </table>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <TD>��</TD>
            <TD WIDTH="90" NOWRAP>������</TD>
            <TD>�F</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear2', 'strCslMonth2', 'strCslDay2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditSelectNumberList("strCslYear2", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strSCslYear2)) %></TD>
            <TD>�N</TD>
            <TD><%= EditSelectNumberList("strCslMonth2", 1, 12, Clng("0" & strSCslMonth2)) %></TD>
            <TD>��</TD>
            <TD><%= EditSelectNumberList("strCslDay2",   1, 31, Clng("0" & strSCslDay2  )) %></TD>
            <TD>��</TD>
            <TD>�`</TD>
            <TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear2', 'endCslMonth2', 'endCslDay2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
            <TD><%= EditSelectNumberList("endCslYear2", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strECslYear2)) %></TD>
            <TD>�N</TD>
            <TD><%= EditSelectNumberList("endCslMonth2", 1, 12, Clng("0" & strECslMonth2)) %></TD>
            <TD>��</TD>
            <TD><%= EditSelectNumberList("endCslDay2",   1, 31, Clng("0" & strECslDay2  )) %></TD>
            <TD>��</TD>
        </TR>
    </TABLE>
    <font color="#a9a9a9">���o�͋敪�������ς݂̂Ƃ��������͈͂��L���ƂȂ�܂��B</font><br>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
        <TR>
            <td><font color="#ff0000">��</font></td>
            <TD WIDTH="90" NOWRAP>���я�</TD>
            <TD>�F</TD>
            <TD><select name="sortKind" size="1">
                    <option selected value="1">�����ԍ���</option>
                    <option value="2">�c�̖��̏�</option>
                </select>
            </TD>
        </TR>
    </table>

    <!--- ������[�h -->
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
<!--  2003/02/27  START  START  E.Yamamoto  -->
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/02/27  START  END    E.Yamamoto  -->
<!--  2003/02/27  DEL  START  E.Yamamoto  -->
<!--
            <TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
            <TD NOWRAP>�v���r���[</TD>

            <TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
            <TD NOWRAP>���ڏo��</TD>
        </TR>
-->
<!--  2003/02/27  DEL  END    E.Yamamoto  -->
        </TR>
    </TABLE>

    <BR><BR>

<!--- ����{�^�� -->
    <!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
        <INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">
    <%  End if  %>

    </BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>