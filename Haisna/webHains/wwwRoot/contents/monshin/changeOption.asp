<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       ��f�Z�b�g�ύX (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objConsult          '��f���A�N�Z�X�p
Dim objResult           '���ʏ��A�N�Z�X�p

'### 2004.09.24 ADD By FSIT)Gouda ��f���̕\��(��f���A����ID�A�l���A�\��ԍ�)
Dim objCommon           '���ʃN���X
Dim objConsult2         '��f�N���X
'### 2004.09.24 ADD End 

'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
Dim objFree                 '�ėp���A�N�Z�X�p
'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� END ##############################################

'�����l
Dim lngRsvNo            '�\��ԍ�
Dim strCslDate          '��f��
Dim strPerId            '�l�h�c
Dim strCtrPtCd          '�_��p�^�[���R�[�h
Dim strCslDivCd         '��f�敪�R�[�h
Dim strOptCd            '�I�v�V�����R�[�h
Dim strOptBranchNo      '�I�v�V�����}��
Dim strConsults         '��f�v��
Dim strGrpCd            '�O���[�v�R�[�h
Dim strOrgRslCmtCd      '���̌��ʃR�����g�R�[�h
Dim strRslCmtCd         '���ʃR�����g�R�[�h

'### 2004.09.24 ADD By FSIT)Gouda ��f���̕\��(��f���A����ID�A�l���A�\��ԍ�) 
Dim strLastName         '��
Dim strFirstName        '��
Dim strLastKName        '�J�i��
Dim strFirstKName       '�J�i��
Dim strDayId            '����ID
'### 2004.09.24 ADD End 


'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� STR ##############################################
Dim strCsCd                 '�R�[�X�R�[�h
Dim strCsName               '�R�[�X��
Dim strBirth                '���N����
Dim strAge                  '�N��
Dim strGender               '����
Dim strGenderName           '���ʖ���
Dim strOrgName              '�c�̖���

Dim strEraBirth             '���N����(�a��)
Dim strRealAge              '���N��

Dim lngConsCount            '��f��
Dim lngCnt
'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� END ##############################################


Dim strUpdGrpCd()       '�O���[�v�R�[�h
Dim strUpdRslCmtCd()    '���ʃR�����g�R�[�h
Dim lngUpdCount         '�X�V���ڐ�

Dim strMessage          '�G���[���b�Z�[�W
Dim Ret                 '�֐��߂�l
Dim i                   '�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'### 2004.09.24 ADD By FSIT)Gouda ��f���̕\��(��f���A����ID�A�l���A�\��ԍ�) 
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objConsult2 = Server.CreateObject("HainsConsult.Consult")
'### 2004.09.24 ADD End 

'�����l�̎擾
lngRsvNo       = CLng("0" & Request("rsvNo"))
strCslDate     = Request("cslDate")
strPerId       = Request("perId")
strCtrPtCd     = Request("ctrPtCd")
strCslDivCd    = Request("cslDivCd")
strGrpCd       = ConvIStringToArray(Request("grpCd"))
strOrgRslCmtCd = ConvIStringToArray(Request("orgRslCmtCd"))
strRslCmtCd    = ConvIStringToArray(Request("rslCmtCd"))


'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� STR ##############################################

'### 2004.09.24 ADD By FSIT)Gouda ��f���̕\��(��f���A����ID�A�l���A�\��ԍ�)
'��f��񌟍�
'Ret = objConsult2.SelectConsult(lngRsvNo,       _
'                                , , , , , , , , , , , _
'                                , , , , , , , , , , , , _
'                                strDayId,       _
'                                , , , , , , , , , , , , , , , , , _
'                                strLastName,    _
'                                strFirstName,   _
'                                strLastKName,   _
'                                strFirstKName )
''### 2004.09.24 ADD End 

Ret = objConsult2.SelectConsult(lngRsvNo, _
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

'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� END ##############################################


'�ۑ��{�^��������
If Not IsEmpty(Request("save.x")) Then

    '�X�V���ׂ��O���[�v�𒊏o
    If IsArray(strGrpCd) Then

        '�ύX�̔����������݂̂̂��擾
        For i = 0 To UBound(strGrpCd)
            If strRslCmtCd(i) <> strOrgRslCmtCd(i) Then
                ReDim Preserve strUpdGrpCd(lngUpdCount)
                ReDim Preserve strUpdRslCmtCd(lngUpdCount)
                strUpdGrpCd(lngUpdCount)    = strGrpCd(i)
                strUpdRslCmtCd(lngUpdCount) = strRslCmtCd(i)
                lngUpdCount = lngUpdCount + 1
            End If
        Next

    End If

    '�ۑ����ׂ����ڂ������
    If lngUpdCount > 0 Then

        '�ۑ�����
        Set objResult = Server.CreateObject("HainsResult.Result")

        '�������~���̍X�V
        Ret = objResult.UpdateResultForChangeSet(lngRsvNo, Request.ServerVariables("REMOTE_ADDR"), Session("USERID"), strUpdGrpCd, strUpdRslCmtCd, strMessage)

        Set objResult = Nothing

    Else

        '���݂��Ȃ��ꍇ�͐���I���Ƃ��A���_�C���N�g������
        Ret = True

    End If

    '�ۑ��ɐ��������ꍇ�̓��_�C���N�g
    If Ret = True Then
        Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?rsvNo=" & lngRsvNo & "&act=saveend"
        Response.End
    End If

'�����\����
Else

    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '��f���ǂݍ���
    objConsult.SelectConsult lngRsvNo, 0, strCslDate, strPerId, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strCtrPtCd, , , , , , , , , , , , strCslDivCd

    '���݂̎�f�I�v�V���������ǂݍ���
    objConsult.SelectConsult_O lngRsvNo, strOptCd, strOptBranchNo

    Set objConsult = Nothing

    '��f���ׂ��I�v�V���������݂���ꍇ
    If IsArray(strOptCd) Then

        '�ǂݍ��񂾑S�ẴI�v�V�����̎�f�v�ۂ��u��f����v�ɐݒ�
        strConsults = Array()
        ReDim Preserve strConsults(UBound(strOptCd))
        For i = 0 To UBound(strConsults)
            strConsults(i) = "1"
        Next

    End If

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��f�Z�b�g�ύX</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/cmtGuide.inc" -->
<!--
var lngSelectedIndex;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X

// �ۑ��O�Ɍ��݂̑I����Ԃ����f�v�ۂ�ݒ肷��
function setConsults() {

    var objForm = document.entryForm;

    var arrOptCd;       // �I�v�V�����R�[�h
    var arrOptBranchNo; // �I�v�V�����}��
    var arrConsults;    // ��f�v��

    var selOptCd;       // �I�v�V�����R�[�h

    // �I�v�V���������̎�f��Ԃ��擾����
    arrOptCd       = new Array();
    arrOptBranchNo = new Array();
    arrConsults    = new Array();

    // �S�G�������g������
    for ( var i = 0; i < objForm.elements.length; i++ ) {

        // �`�F�b�N�{�b�N�X�A���W�I�{�^���ȊO�̓X�L�b�v
        if ( objForm.elements[ i ].type != 'checkbox' && objForm.elements[ i ].type != 'radio' ) {
            continue;
        }

        // �J���}�ŃR�[�h�Ǝ}�Ԃ𕪗����ăI�v�V�����R�[�h��ǉ�
        selOptCd = objForm.elements[ i ].value.split(',');
        arrOptCd[ arrOptCd.length ]             = selOptCd[ 0 ];
        arrOptBranchNo[ arrOptBranchNo.length ] = selOptCd[ 1 ];

        // �`�F�b�N��Ԃɂ���f�v�ۂ�ݒ�
        arrConsults[ arrConsults.length ] = objForm.elements[ i ].checked ? '1' : '0';

    }

    // submit�p�̍��ڂ֕ҏW
    objForm.optCd.value       = arrOptCd;
    objForm.optBranchNo.value = arrOptBranchNo;
    objForm.consults.value    = arrConsults;

}

// ���ʃR�����g�K�C�h�Ăяo��
function callCmtGuide( index ) {

    // �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���ʃR�����g�R�[�h�E���ʃR�����g���̃Z�b�g�p�֐��ɂĎg�p����)
    lngSelectedIndex = index;

    // �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
    cmtGuide_CalledFunction = setCmtInfo;

    // ���ʃR�����g�K�C�h�\��(���͊����R�����g�̂�)
    showGuideCmt( 1 );
}

// ���ʃR�����g�R�[�h�E���ʃR�����g���̃Z�b�g
function setCmtInfo() {

    var myForm = document.entryForm;

    var rslCmtNameElement;  // ���ʃR�����g����ҏW����G�������g�̖���
    var rslCmtName;         // ���ʃR�����g����ҏW����G�������g���g

    // �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
    if ( myForm.rslCmtCd.length != null ) {
        myForm.rslCmtCd[ lngSelectedIndex ].value = cmtGuide_RslCmtCd;
    } else {
        myForm.rslCmtCd.value = cmtGuide_RslCmtCd;
    }

    document.getElementById('rcNm' + lngSelectedIndex).innerHTML = cmtGuide_RslCmtName;

}

// ���ʃR�����g�̃N���A
function clearCmtInfo( index ) {

    var myForm = document.entryForm;

    if ( myForm.rslCmtCd.length != null ) {
        myForm.rslCmtCd[ index ].value = '';
    } else {
        myForm.rslCmtCd.value = '';
    }

    document.getElementById('rcNm' + index).innerHTML = '';

}
//-->
</SCRIPT>
<style type="text/css">
    body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeGuideCmt()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN>��f�Z�b�g�ύX</B></TD>
    </TR>
</TABLE>
<%
If Request("act") = "saveend" Then
    EditMessage "�ۑ����������܂����B", MESSAGETYPE_NORMAL
Else
'## 2004.01.14 Mod By T.Takagi@FSIT �G���[�͔z��ŕԂ�̂ŏ����C��
'   If strMessage <> "" Then
    If Not IsEmpty(strMessage) Then
'## 2004.01.14 Mod End
        EditMessage strMessage, MESSAGETYPE_WARNING
    End If
End If
%>
<BR>
<%'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� STR ############################################## %>
<!--## 2004.09.24 ADD By FSIT)Gouda ��f���̕\��(��f���A����ID�A�l���A�\��ԍ�)-->
<!--TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
    <TR>
        <TD VALIGN="top" NOWRAP>��f���F<FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
        <TD VALIGN="top" WIDTH="10"></TD>
        <TD VALIGN="top" NOWRAP>����ID�F<FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayId, "0000") %></B></FONT></TD>		
        <TD VALIGN="top" WIDTH="10"></TD>
        <TD VALIGN="top" NOWRAP>�l���F<B><%= strLastName %>�@<%= strFirstName %></B>�@(<FONT SIZE="2"><%= strLastKName %>�@<%= strFirstKName %>�j</FONT></TD>	
        <TD VALIGN="top" WIDTH="10"></TD>
        <TD VALIGN="top" NOWRAP>�\��ԍ��F<FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
    </TR>
</TABLE-->

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
<%'### 2016.01.27 �� �l���ǉ��ׁ̈A�C�� END ############################################## %>

<BR>
<!--## 2004.09.24 ADD End-->
    <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
    <INPUT TYPE="image" NAME="save" SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�ۑ�����">
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 �����Ǘ� Add by ���@--- END %>

    <BR><BR>

<FONT COLOR="#ffa500">��</FONT>�����Z�b�g�Ɍ��ʃR�����g���Z�b�g���邱�Ƃɂ��A���ʂ��󔒂ł������͂ɂȂ�܂���i���z�ɕύX�͂���܂���j�B<BR><BR>
<INPUT TYPE="hidden" NAME="rsvNo"    VALUE="<%= lngRsvNo    %>">
<INPUT TYPE="hidden" NAME="cslDate"  VALUE="<%= strCslDate  %>">
<INPUT TYPE="hidden" NAME="perId"    VALUE="<%= strPerId    %>">
<INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd  %>">
<INPUT TYPE="hidden" NAME="cslDivCd" VALUE="<%= strCslDivCd %>">
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD VALIGN="top"><% EditSet() %></TD>
        <TD><IMG SRC="/webhains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
        <TD VALIGN="top"><% EditComment() %></TD>
    </TR>
</TABLE>
</FORM>
</BODY>
</HTML>
<%
Sub EditSet()

    Dim objContract         '�_����A�N�Z�X�p

    '�I�v�V�����������
    Dim strArrOptCd         '�I�v�V�����R�[�h
    Dim strArrOptBranchNo   '�I�v�V�����}��
    Dim strOptName          '�I�v�V������
    Dim strOptSName         '�I�v�V������
    Dim strSetColor         '�Z�b�g�J���[
    Dim strConsult          '��f�v��
    Dim strBranchCount      '�I�v�V�����}�Ԑ�
    Dim strAddCondition     '�ǉ�����
    Dim strHideQuestion     '��f��ʔ�\��
    Dim lngCount            '�I�v�V����������

    Dim blnConsult          '��f�`�F�b�N�̗v��
    Dim strChecked          '�`�F�b�N�{�b�N�X�̃`�F�b�N���

    Dim strPrevOptCd        '���O���R�[�h�̃I�v�V�����R�[�h
    Dim lngOptGrpSeq        '�I�v�V�����O���[�v��SEQ�l
    Dim strElementType      '�I�v�V�����I��p�̃G�������g���
    Dim strElementName      '�I�v�V�����I��p�̃G�������g��
    Dim lngOptIndex         '�ҏW�����I�v�V�����̃C���f�b�N�X
    Dim i, j                '�C���f�b�N�X

    Set objContract = Server.CreateObject("HainsContract.Contract")

    '�w��_��p�^�[���̑S�I�v�V�����������擾
    lngCount = objContract.SelectCtrPtOptFromConsult(strCslDate, strCslDivCd, strCtrPtCd, strPerId, , , , True, False, strArrOptCd, strArrOptBranchNo, strOptName, strOptSName, strSetColor, , , , , strBranchCount, strAddCondition, , , , strHideQuestion)

    Set objContract = Nothing
%>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="3">
        <TR BGCOLOR="#e0e0e0" ALIGN="center">
            <TD COLSPAN="5" NOWRAP>�����Z�b�g��</TD>
        </TR>
<%
        '�ǂݍ��񂾃I�v�V�����������̌���
        For i = 0 To lngCount - 1

            '��f��ʕ\���Ώۂł����
            If strHideQuestion(i) = "" Then

                '���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ
                If strArrOptCd(i) <> strPrevOptCd Then

                    '�܂��ҏW����G�������g��ݒ肷��(�}�Ԑ����P�Ȃ�`�F�b�N�{�b�N�X�A�����Ȃ��΃��W�I�{�^���I��)
                    strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

                    '�I�v�V�����ҏW�p�̃G�������g�����`����
                    lngOptGrpSeq   = lngOptGrpSeq + 1
                    strElementName = "opt_" & CStr(lngOptGrpSeq)

                End If

                '��f�`�F�b�N�v�ۂ̔���J�n
                blnConsult = False

                '�����w�莞
                If IsArray(strOptCd) And IsArray(strOptBranchNo) Then

                    '�����w�肳�ꂽ�I�v�V�����ɑ΂��ă`�F�b�N������
                    For j = 0 To UBound(strOptCd)
                        If strOptCd(j) = strArrOptCd(i) And strOptBranchNo(j) = strArrOptBranchNo(i) And strConsults(j) = "1" Then
                            blnConsult = True
                            Exit For
                        End If
                    Next

                End If

                '���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ�̓Z�p���[�^��ҏW
                If strPrevOptCd <> "" And strArrOptCd(i) <> strPrevOptCd Then
%>
                    <TR><TD HEIGHT="3"></TD></TR>
<%
                End If

                strChecked = IIf(blnConsult, " CHECKED", "")
%>
                <TR>
                    <TD><%= IIf(blnConsult, "��", "&nbsp;") %></TD>
                    <TD NOWRAP><%= strArrOptCd(i) %></TD>
                    <TD NOWRAP><%= "-" & strArrOptBranchNo(i) %></TD>
                    <TD NOWRAP>�F</TD>
                    <TD NOWRAP><FONT COLOR="<%= strSetColor(i) %>">��</FONT><%= strOptName(i) %></TD>
                </TR>
<%
                lngOptIndex = lngOptIndex + 1

                '�����R�[�h�̃I�v�V�����R�[�h��ޔ�
                strPrevOptCd = strArrOptCd(i)

            End If

        Next
%>
    </TABLE>
<%
End Sub

Sub EditComment()

    Dim objRslCmt           '���ʃR�����g���A�N�Z�X�p

    Dim strArrGrpCd         '�O���[�v�R�[�h
    Dim strArrGrpName       '�O���[�v��
    Dim strArrConsults      '��f�t���O
    Dim strArrRslCmtCd      '���ʃR�����g�R�[�h
    Dim strArrRslCmtName    '���ʃR�����g��
    Dim lngCount            '�O���[�v��

    Dim i                   '�C���f�b�N�X

    Set objRslCmt = Server.CreateObject("HainsRslCmt.RslCmt")

    '���ʃR�����g���ǂݍ���
    lngCount = objRslCmt.SelectRslCmtListForChangeSet(lngRsvNo, "CHGSETGRP", strArrGrpCd, strArrGrpName, strArrConsults, strArrRslCmtCd, strArrRslCmtName)

    Set objRslCmt = Nothing
%>
    <TABLE BORDER="1" CELLSPACING="2" CELLPADDING="0">
        <TR BGCOLOR="#e0e0e0">
            <TD NOWRAP>�����Z�b�g��</TD>
            <TD WIDTH="300" NOWRAP>�����R�����g</TD>
        </TR>
<%
        For i = 0 To lngCount - 1
%>
            <TR>
<%
                '�˗�������ꍇ
                If strArrConsults(i) <> "" Then
%>
                    <TD NOWRAP><%= strArrGrpName(i) %></TD>
                    <TD><INPUT TYPE="hidden" NAME="grpCd" VALUE="<%= strArrGrpCd(i) %>"><INPUT TYPE="hidden" NAME="consults" VALUE="<%= strArrConsults(i) %>"><INPUT TYPE="hidden" NAME="orgRslCmtCd" VALUE="<%= strArrRslCmtCd(i) %>">
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                            <TR>
                                <TD><INPUT TYPE="hidden" NAME="rslCmtCd" VALUE="<%= strArrRslCmtCd(i) %>"><A HREF="javascript:callCmtGuide(<%= i %>)"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ʃR�����g�K�C�h�\��"></A></TD>
                                <TD><A HREF="javascript:clearCmtInfo(<%= i %>)"><IMG SRC="../../images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="���ʃR�����g���N���A"></A></TD>
                                <TD ID="rcNm<%= i %>" NOWRAP><%= IIf(strArrRslCmtName(i) <> "", Replace(strArrRslCmtName(i), Chr(1), "�A"), "&nbsp;") %></TD>
                            </TR>
                        </TABLE>
                    </TD>
<%
                Else
%>
                    <TD NOWRAP><FONT COLOR="#cccccc"><B><DEL><%= strArrGrpName(i) %></DEL></B></FONT></TD>
                    <TD><INPUT TYPE="hidden" NAME="grpCd" VALUE="<%= strArrGrpCd(i) %>"><INPUT TYPE="hidden" NAME="consults" VALUE="<%= strArrConsults(i) %>"><INPUT TYPE="hidden" NAME="orgRslCmtCd" VALUE="<%= strArrRslCmtCd(i) %>">
                        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                            <TR>
                                <TD><INPUT TYPE="hidden" NAME="rslCmtCd" VALUE="<%= strArrRslCmtCd(i) %>"><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></A></TD>
                            </TR>
                        </TABLE>
                    </TD>
<%
                End If
%>
            </TR>
<%
        Next
%>
    </TABLE>
<%
End Sub
%>
