<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       ���茒�f�ʐڐ�p��ʁ@(Ver0.0.1)
'       AUTHER  : ��
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<!-- #include virtual = "/webHains/includes/interviewResult.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_LEVEL = "X090"          '�ی��w�����x���O���[�v�R�[�h

'### 2009/03/30 �� ����ی��w���敪�o�^�L���`�F�b�N�̂��ߒǉ� Start ###
Const GUIDANCE_ITEMCD = "64074"     '����ی��w���@�������ڃR�[�h
Const GUIDANCE_SUFFIX = "00"        '����ی��w���@�T�t�B�b�N�X
'### 2009/03/30 �� ����ی��w���敪�o�^�L���`�F�b�N�̂��ߒǉ� End   ###

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon               '���ʃN���X
Dim objSpecialInterview     '���茒�f�ʐڏ��A�N�Z�X�p
Dim objResult               '�������ʏ��A�N�Z�X�p

'�p�����[�^
Dim strAct         '�������
Dim strWinMode     '�E�B���h�E���[�h
Dim lngRsvNo       '�\��ԍ��i���񕪁j

Dim vntGrpCd       '�O���[�v�R�[�h
Dim vntGrpName     '�O���[�v����
Dim vntItemCd      '�������ڃR�[�h
Dim vntSuffix      '�T�t�B�b�N�X
Dim vntItemName    '�������ږ���
Dim vntResult      '��������
Dim vntGrpSeq      '�\������
Dim vntStopFlg     '�������~�t���O
Dim vntRslCmtCd1   '���ʃR�����g1
Dim vntRslCmtCd2   '���ʃR�����g2
Dim vntHpoint      '�w���X�|�C���g
Dim vntStdLead     '�ی��w���Ώۊ�l
Dim vntStdCare     '��f�����Ώۊ�l
Dim vntGrpCount    '�O���[�v�R�[�h��

Dim vntRsvNo       '�\��ԍ�
Dim vntJudCmtCd    '����R�����g�R�[�h
Dim vntJudCmtStc   '����R�����g����

Dim vntItemCd2     '�������ڃR�[�h
Dim vntSuffix2     '�T�t�B�b�N�X
Dim vntItemName2   '�������ږ���
Dim vntResult2     '�������ʁi�R�[�h�j
Dim vntLongStc2    '�������ʁi���́j


Dim lngCount       '����
Dim lngCmtCount    '�R�����g����
Dim lngRslCount    '���ʌ���
Dim StrSaveGrp     '�������ڃO���[�v�R�[�h�`�F�b�N�p
Dim strColor       '���ʂ��ُ�l�̏ꍇ

Dim i              '���[�v�J�E���^
Dim j              '���[�v�J�E���^

'### 2009/03/30 �� ����ی��w���敪�o�^�`�F�b�N�̂��ߒǉ� Start ###
Dim lngFlgChk           '�t���O�`�F�b�N
Dim strResult           '����ی��w���敪�i���ʃe�[�u���Q�ƒl�FRSL�j
Dim strSentenceCd       '���̓R�[�h
Dim strSentenceName     '���͖���
Dim RetResult           '���ʌ������A�l
'### 2009/03/30 �� ����ی��w���敪�o�^�`�F�b�N�̂��ߒǉ� End   ###

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon               = Server.CreateObject("HainsCommon.Common")
Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")
'### 2009/03/30 �� ����ی��w���敪�o�^�L���`�F�b�N�̂��ߒǉ� ###
Set objResult               = Server.CreateObject("HainsResult.Result")

'�����l�̎擾
strAct          = Request("action")
strWinMode      = Request("winmode")
lngRsvNo        = Request("rsvno")

Do
    lngCount = objSpecialInterview.SelectSpecialRslView( _
                            lngRsvNo, _
                            vntGrpCd, _
                            vntGrpName ,_
                            vntItemCd, _
                            vntSuffix, _
                            vntItemName, _
                            vntResult, _
                            vntGrpSeq, _
                            vntStopFlg, _
                            vntRslCmtCd1, _
                            vntRslCmtCd2, _
                            vntHpoint, _
                            vntStdLead, _
                            vntStdCare, _
                            vntGrpCount _
                            )
    If lngCount < 1 Then
        Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & "�j"
    End If

    lngCmtCount = objSpecialInterview.SelectSpecialJudCmt( _
                            lngRsvNo, 5, ,_
                            vntJudCmtCd, _
                            vntJudCmtStc _
                            )
    
    If lngCount < 1 Then
        Err.Raise 1000, , "����R�����g���擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & "�j"
    End If

    '### 2009.03.24 �� �ی��w�����x���i�K�w�����ʁF�X�e�b�v�R�A�X�e�b�v�S�j�\���̂��ߒǉ� Start ###
    lngRslCount = objSpecialInterview.SelectSpecialResult( _
                            lngRsvNo,_
                            GRPCD_LEVEL,_
                            vntItemCd2, _
                            vntSuffix2, _
                            vntItemName2, _
                            vntResult2, _
                            vntLongStc2 _
                            )
    '### 2009.03.24 �� �ی��w�����x���i�K�w�����ʁF�X�e�b�v�R�A�X�e�b�v�S�j�\���̂��ߒǉ� End   ###

    '### 2009/03/30 �� ����ی��w���敪�o�^�L���`�F�b�N�̂��ߒǉ� Start ###
    lngFlgChk = 0
    strSentenceCd = ""
    strSentenceName = ""
    '����ی��w���敪���ʃf�[�^�擾
    RetResult = objResult.SelectRsl( lngRsvNo, GUIDANCE_ITEMCD, GUIDANCE_SUFFIX, strResult )
    If RetResult = True Then
        If strResult <> "" Then
            strSentenceCd   = strResult
            Select Case strResult
                '�ΏۊO
                Case "1"
                    strSentenceName = "�ΏۊO"
                '�Ώ�
                Case "2"
                    strSentenceName = "�Ώ�"
                Case Else
                    strSentenceName = ""
            End Select

            lngFlgChk = lngFlgChk + 1
        End If
    End If
    '### 2009/03/30 �� ����ی��w���敪�o�^�L���`�F�b�N�̂��ߒǉ� End   ###


    Exit Do
Loop

Set objResult               = Nothing
Set objspecialInterview     = nothing

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���茒�f��p�ʐ�</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
//���茒�f�R�����g���͉�ʌĂяo��

var winSpJudComment;
var winEntrySpecial;

function callSpJudComment() {
    var url;
    var opened = false;
    var i;

//    if ( winSpJudComment != null ) {
//        if ( !win)
    url = '/WebHains/contents/interview/SpecialJudComment.asp';
    url = url + '?winmode=' + '<%= strWinMode %>';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';

    winSpJudComment = window.open( url, 'SpJudComment', 'width=750,height=270,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    winSpJudComment.focus();

}

//����ی��w���敪�o�^�E�C���h�E�Ăяo��
function showSpecialWindow() {

    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩


    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winEntrySpecial != null ) {
        if ( !winEntrySpecial.closed ) {
            opened = true;
        }
    }
    url = '/WebHains/contents/interview/EntrySpecial.asp?rsvno=' + <%= lngRsvNo %>;

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winEntrySpecial.focus();
        winEntrySpecial.location.replace( url );
    } else {
        winEntrySpecial = window.open( url, '', 'width=500,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}


// �K�w���R�����g���͉�ʂ����
function closeSpJudComment() {

    if ( winSpJudComment != null ) {
        if ( !winSpJudComment.closed ) {
            winSpJudComment.close();
        }
    }
    if ( winEntrySpecial != null ) {
        if ( !winEntrySpecial.closed ) {
            winEntrySpecial.close();
        }
    }

    winSpJudComment = null;
    winEntrySpecial = null;

}

function refreshForm(){
        document.entryForm.submit();
}


//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeSpJudComment()">
<FORM NAME="entryForm" ACTION="" METHOD="post" STYLE="margin: 0px;">
    <!-- �����l -->
    <INPUT TYPE="hidden" NAME="action"    VALUE="<%= strAct %>">	
    <INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">

    <!-- �^�C�g���̕\�� -->
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" WIDTH="930" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">���茒�f��p�ʐ�</FONT></B></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
<!--## �J��Ԃ��J�n ##-->
<%
    strSaveGrp = ""
    For i = 0 To lngCount - 1

        If i = 0 Then
%>
        <TR>
            <TD VALIGN="TOP">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD WIDTH="100">��������</TD>
                        <TD WIDTH="130">����</TD>
                        <TD WIDTH="70">��������</TD>
                        <TD WIDTH="70">�ی��w��</TD>
                        <TD WIDTH="70">��f����</TD>
                    </TR>
<%
        End If
        '�����O���[�v�R�[�h�ύX�`�F�b�N
        '�����O���[�v�R�[�h���ς�������_�Ō����O���[�v���̂�\��
        If strSaveGrp <> vntGrpCd(i) Then
            If vntGrpCd(i) = "X079" Then '�����O���[�v�R�[�h���u�̋@�\�v�Ȃ̂����`�F�b�N
%>
                </TABLE>
            </TD>

            <TD WIDTH="5">&nbsp;</TD>

            <TD VALIGN="TOP">
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
                    <TR BGCOLOR="#cccccc" ALIGN="center">
                        <TD WIDTH="100">��������</TD>
                        <TD WIDTH="130">����</TD>
                        <TD WIDTH="70">��������</TD>
                        <TD WIDTH="70">�ی��w��</TD>
                        <TD WIDTH="70">��f����</TD>
                    </TR>
                    <TR>
                        <TD ROWSPAN="<%=vntGrpCount(i)%>" BGCOLOR="#cccccc" ALIGN="center"><%=vntGrpName(i)%></TD>
<%
            Else
%>
                    <TR>
                        <TD ROWSPAN="<%=vntGrpCount(i)%>" BGCOLOR="#cccccc" ALIGN="center"><%=vntGrpName(i)%></TD>
<%
            End If
            strSaveGrp = vntGrpCd(i)
        Else
%>
                    <TR>
<%
        End If

                    If vntHpoint(i) = 0 Then
                        strColor = "#eeeeee"
                    Else
                        strColor = "#ffc0cb"
                    End If
%>
                        <TD BGCOLOR="#eeeeee" HEIGHT="22" ALIGN="left"><%=iif(vntItemCd(i)="15022","���F�f��("&vntItemName(i)&")",vntItemName(i))%></TD>
                        <TD BGCOLOR="<%=strColor%>" HEIGHT="22" ALIGN="right"><B><%=vntResult(i)%></B></TD>
                        <TD BGCOLOR="#eeeeee" HEIGHT="22" ALIGN="center"><%=vntStdLead(i)%></TD>
                        <TD BGCOLOR="#eeeeee" HEIGHT="22" ALIGN="center"><%=vntStdCare(i)%></TD>
                    </TR>
<%
    Next
%>
                </TABLE>
            </TD>
        </TR>
<!--## �J��Ԃ��I�� ##-->
    </TABLE>
<%'### 2009/03/24 �� �ی��w�����x���K�w�����ʕ\���̂��ߒǉ� Start ### %>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR><TD>&nbsp;</TD></TR>
<%
    For i = 0 To lngRslCount - 1
%>
        <TR>
            <TD><%= vntItemName2(i) %>&nbsp;�F&nbsp;<b><%= vntLongStc2(i) %></b></TD>
        </TR>
<%
    Next
%>
<%'### 2009/03/24 �� �ی��w�����x���K�w�����ʕ\���̂��ߒǉ� End   ### %>
        <TR><TD>&nbsp;</TD></TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="760">
                    <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">�K�w���R�����g</FONT></B></TD>
                </TABLE>
            </TD>
            <TD ALIGN="right" BGCOLOR="ffffff"><A HREF="javascript:callSpJudComment()">
                <IMAGE SRC="/webHains/images/modifycomment.gif" ALT="���茒�f�R�����g����" BORDER="0"></A>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR><TD>&nbsp;</TD></TR>
<%
        For i = 0 To lngCmtCount - 1
%>
        <TR>
            <TD><%= vntJudCmtStc(i) %></TD>
        </TR>
<%
        Next
%>
    </TABLE>
    <BR><BR>

<%
    '### ���ʃe�[�u���iRSL�j�ɓ���ی��w���敪�������ځi64074-00�j�����݂����f�҂̂ݕ\�� ###
    If RetResult = True Then
%>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR>
            <TD>
                <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="760">
                    <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">����ی��w���敪</FONT></B></TD>
                </TABLE>
            </TD>
            <TD ALIGN="left" width="120" BGCOLOR="ffffff"><A HREF="javascript:showSpecialWindow()">
                <IMAGE SRC="/webHains/images/changeper.gif" ALT="����ی��w���敪����" BORDER="0"></A>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
        <TR><TD COLSPAN="4">&nbsp;</TD></TR>
        <TR>
    <%
        '### ����ی��w���敪���o�^����Ă��Ȃ������ꍇ�A���o�^���b�Z�[�W�\��
        If lngFlgChk = 0 Then
    %>
            <TD COLSPAN="4"><FONT COLOR="#ff6600"><B>���݁A����ی��w���敪���o�^����Ă��܂���B</B></FONT></TD>
    <% 
        Else
    %>
            <TD WIDTH="90">&nbsp;����ی��w��</TD>
            <TD WIDTH="10">&nbsp;�F&nbsp;</TD>
            <TD WIDTH="150">&nbsp;<B><%= strSentenceName %></B></TD>
            <TD>&nbsp;</TD>
    <% 
        End If
    %>
        <TR>
    </TABLE>
    <BR>
<%
    End If
%>
</FORM>
</BODY>
</HTML>