<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �_����(�_���{���̐ݒ�) (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_SAVE        = "save" '�������[�h�i�ۑ��j
Const AGECALC_CSLDATE  = 0      '�N��N�Z���@�i��f���w��j
Const AGECALC_DIRECT   = 1      '�N��N�Z���@�i�N�Z���w��j

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objContract         '�_��Ǘ����A�N�Z�X�p
Dim objContractControl  '�_����A�N�Z�X�p

'�����l
Dim strMode             '�������[�h
Dim strCtrPtCd          '�_��p�^�[���R�[�h
Dim strOrgCd1           '�c�̃R�[�h�P
Dim strOrgCd2           '�c�̃R�[�h�Q
Dim strCsCd             '�R�[�X�R�[�h
Dim strCtrCsName        '(�_��p�^�[������)�R�[�X��
Dim strCtrCsEName       '(�_��p�^�[������)�p��R�[�X��
Dim strCslMethod        '�\����@
Dim lngAgeCalc          '�N��N�Z���@
Dim lngAgeCalcYear      '�N��N�Z���i�N�j
Dim lngAgeCalcMonth     '�N��N�Z���i���j
Dim lngAgeCalcDay       '�N��N�Z���i���j

'�_��Ǘ����
Dim strOrgName          '�c�̖�
Dim strCsName           '�R�[�X��
Dim dtmStrDate          '�_��J�n��
Dim dtmEndDate          '�_��I����

Dim strAgeCalc          '�N��N�Z��
Dim strStrDate          '�ҏW�p�̌_��J�n��
Dim strEndDate          '�ҏW�p�̌_��I����
Dim strMessage          '�G���[���b�Z�[�W
Dim strHTML             'HTML������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'�����l�̎擾
strMode         = Request("mode")
strCtrPtCd      = Request("ctrPtCd")
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strCsCd         = Request("csCd")
strCtrCsName    = Request("csName")
strCtrCsEName   = Request("csEName")
strCslMethod    = Request("cslMethod")
lngAgeCalc      = CLng("0" & Request("ageCalc"))
lngAgeCalcYear  = CLng("0" & Request("ageCalcYear"))
lngAgeCalcMonth = CLng("0" & Request("ageCalcMonth"))
lngAgeCalcDay   = CLng("0" & Request("ageCalcDay"))

'�X�V���[�h���Ƃ̏�������
Do

    '�ۑ��{�^��������
    If strMode = MODE_SAVE Then

        '���̓`�F�b�N
        strMessage = CheckValue()
        If Not IsEmpty(strMessage) Then
            Exit Do
        End If

        '�N��N�Z���̕ҏW
        strAgeCalc = EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)

        '�_��p�^�[�����R�[�h�̍X�V
        objContract.UpdateCtrPt strCtrPtCd, , , , strAgeCalc, strCtrCsName, strCtrCsEName, strCslMethod

        '�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
        strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
        strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
        strHTML = strHTML & "</BODY>"
        strHTML = strHTML & "</HTML>"
        Response.Write strHTML
        Response.End

    End If

    '�_��p�^�[�����ǂݍ���
    objContract.SelectCtrPt strCtrPtCd, , , strAgeCalc, , strCtrCsName, strCtrCsEName, strCslMethod

    '�N��N�Z���̐ݒ�
    Select Case Len(strAgeCalc)
        Case 8
            lngAgeCalc      = AGECALC_DIRECT
            lngAgeCalcYear  = CLng("0" & Mid(strAgeCalc, 1, 4))
            lngAgeCalcMonth = CLng("0" & Mid(strAgeCalc, 5, 2))
            lngAgeCalcDay   = CLng("0" & Mid(strAgeCalc, 7, 2))
        Case 4
            lngAgeCalc      = AGECALC_DIRECT
            lngAgeCalcYear  = 0
            lngAgeCalcMonth = CLng("0" & Mid(strAgeCalc, 1, 2))
            lngAgeCalcDay   = CLng("0" & Mid(strAgeCalc, 3, 2))
        Case Else
            lngAgeCalc      = AGECALC_CSLDATE
            lngAgeCalcYear  = 0
            lngAgeCalcMonth = 0
            lngAgeCalcDay   = 0
    End Select

    Exit Do
Loop

'�_��Ǘ�����ǂ݁A�c�́E�R�[�X�̖��̋y�ь_����Ԃ��擾����
If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
    Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
End If

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �N��N�Z���̕ҏW
'
' �����@�@ : (In)     lngAgeCalc       �N��N�Z���@
' �@�@�@�@ : (In)     lngAgeCalcYear   �N��N�Z���i�N�j
' �@�@�@�@ : (In)     lngAgeCalcMonth  �N��N�Z���i���j
' �@�@�@�@ : (In)     lngAgeCalcDay    �N��N�Z���i���j
'
' �߂�l�@ : �N��N�Z��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)

    EditAgeCalc = IIf(lngAgeCalc = 1, IIf(lngAgeCalcYear <> 0, Right("0000" & lngAgeCalcYear, 4), "") & Right("00" & lngAgeCalcMonth, 2) & Right("00" & lngAgeCalcDay, 2), "")

End Function

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

    Dim objCommon   '���ʃN���X

    Dim strMessage  '�G���[���b�Z�[�W

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '�R�[�X���`�F�b�N
    objCommon.AppendArray strMessage, objCommon.CheckWideValue("�R�[�X��", strCtrCsName, 30, CHECK_NECESSARY)

    '�p��R�[�X���`�F�b�N
    objCommon.AppendArray strMessage, objCommon.CheckNarrowValue("�p��R�[�X��", strCtrCsEName, 30)

    '�N��N�Z���@���u�N�Z���𒼐ڎw��v�̏ꍇ�͔N��N�Z���`�F�b�N���s��
    Do
        '��f���ŋN�Z����ꍇ�͕s�v
        If lngAgeCalc = 0 Then
            Exit Do
        End If

        '�������w�肳��Ă��Ȃ��ꍇ�̓G���[
        If lngAgeCalcMonth + lngAgeCalcDay = 0 Then
            objCommon.AppendArray strMessage, "�N��N�Z���𒼐ڎw�肷��ꍇ�͌�������͂��ĉ������B"
            Exit Do
        End If

        '�N���w�肳��Ă��Ȃ��ꍇ�̌����`�F�b�N(�[�N�łȂ��C�ӂ̔N���g�p���ĔN�����`�F�b�N���s��)
        If lngAgeCalcYear = 0 Then
            If Not IsDate("2001/" & lngAgeCalcMonth & "/" & lngAgeCalcDay) Then
                objCommon.AppendArray strMessage, "�N��N�Z���̓��͌`��������������܂���B"
            End If

        '�N���w�肳��Ă���ꍇ�̌����`�F�b�N
        Else
            If Not IsDate(lngAgeCalcYear & "/" & lngAgeCalcMonth & "/" & lngAgeCalcDay) Then
                objCommon.AppendArray strMessage, "�N��N�Z���̓��͌`��������������܂���B"
            End If
        End If

        Exit Do
    Loop

    '�߂�l�̕ҏW
    CheckValue = strMessage

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�_���{���̐ݒ�</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function submitForm( mode ) {
    document.entryForm.mode.value = mode;
    document.entryForm.submit();
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="mode"     VALUE="">
    <INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd %>">
    <INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1  %>">
    <INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2  %>">
    <INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd    %>">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�_���{���̐ݒ�</FONT></B></TD>
        </TR>
    </TABLE>
<%
    '�G���[���b�Z�[�W�̕ҏW
    Call EditMessage(strMessage, MESSAGETYPE_WARNING)

    '�ҏW�p�̌_��J�n���ݒ�
    If Not IsEmpty(dtmStrDate) Then
        strStrDate = FormatDateTime(dtmStrDate, 1)
    End If

    '�ҏW�p�̌_��I�����ݒ�
    If Not IsEmpty(dtmEndDate) Then
        strEndDate = FormatDateTime(dtmEndDate, 1)
    End If
%>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD>�_��c��</TD>
            <TD>�F</TD>
            <TD><B><%= strOrgName %></B></TD>
        </TR>
        <TR>
            <TD HEIGHT="22" NOWRAP>�ΏۃR�[�X</TD>
            <TD>�F</TD>
            <TD><B><%= strCsName %></B></TD>
        </TR>
        <TR>
            <TD>�_�����</TD>
            <TD>�F</TD>
            <TD><B><%= strStrDate %>�`<%= strEndDate %></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
        </TR>
            <TD NOWRAP>�R�[�X��</TD>
            <TD>�F</TD>
            <TD><INPUT TYPE="text" NAME="csName" SIZE="52" MAXLENGTH="15" VALUE="<%= strCtrCsName %>" STYLE="ime-mode:active;"></TD>
            <TD NOWRAP><FONT COLOR="#999999">�����̌_��œK�p����R�[�X����ݒ肵�܂��B</FONT></TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD NOWRAP>�p��R�[�X��</TD>
            <TD>�F</TD>
            <TD COLSPAN="2"><INPUT TYPE="text" NAME="csEName" SIZE="52" MAXLENGTH="30" VALUE="<%= strCtrCsEName %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD NOWRAP>�\����@</TD>
            <TD>�F</TD>
            <TD COLSPAN="2">
                <SELECT NAME="cslMethod">
                    <OPTION VALUE="">&nbsp;
                    <OPTION VALUE="1"<%= IIf(strCslMethod = "1", " SELECTED", "") %>>�{�lTEL(�S��)
                    <OPTION VALUE="2"<%= IIf(strCslMethod = "2", " SELECTED", "") %>>�{�lTEL(FAX�L��)
                    <OPTION VALUE="3"<%= IIf(strCslMethod = "3", " SELECTED", "") %>>�{�lE-MAIL
                    <OPTION VALUE="4"<%= IIf(strCslMethod = "4", " SELECTED", "") %>>�S����TEL(�S��)
                    <OPTION VALUE="5"<%= IIf(strCslMethod = "5", " SELECTED", "") %>>�S���҉��g(FAX)
                    <%'### 2009.04.20 �� �\����@���ڒǉ��u8�F�S���҉��g(�X��)�v Start ###%>
                    <OPTION VALUE="8"<%= IIf(strCslMethod = "8", " SELECTED", "") %>>�S���҉��g(�X��)
                    <%'### 2009.04.20 �� �\����@���ڒǉ��u8�F�S���҉��g(�X��)�v End   ###%>
                    <OPTION VALUE="6"<%= IIf(strCslMethod = "6", " SELECTED", "") %>>�S���҃��X�g
                    <OPTION VALUE="7"<%= IIf(strCslMethod = "7", " SELECTED", "") %>>�S����E-MAIL
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>�N��N�Z��</TD>
            <TD>�F</TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="radio" NAME="ageCalc" VALUE="0" <%= IIf(lngAgeCalc = "0", "CHECKED", "") %>></TD>
                        <TD NOWRAP>��f���ŋN�Z����</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD></TD><TD></TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><INPUT TYPE="radio" NAME="ageCalc" VALUE="1"<%= IIf(lngAgeCalc = "1", " CHECKED", "") %>></TD>
                        <TD NOWRAP>�N�Z���𒼐ڎw��&nbsp;</TD>
                        <TD NOWRAP>�N�Z�N�F</TD>
                        <TD><%= EditSelectNumberList("ageCalcYear", YEARRANGE_MIN, YEARRANGE_MAX, lngAgeCalcYear) %></TD>
                        <TD NOWRAP>&nbsp;�N�Z�����F</TD>
                        <TD><%= EditSelectNumberList("ageCalcMonth", 1, 12, lngAgeCalcMonth) %></TD>
                        <TD>��</TD>
                        <TD><%= EditSelectNumberList("ageCalcDay", 1, 31, lngAgeCalcDay) %></TD>
                        <TD>��</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
    <A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
    <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="javascript:submitForm('<%= MODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
