<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���茒�f�K�w���R�����g�̑I�� (Ver0.0.1)
'		AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const STARTPOS = 1      '�J�n�ʒu�̃f�t�H���g�l
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objJudCmtStc        '����R�����g���A�N�Z�X�p
Dim objJudClass         '���蕪�ޏ��A�N�Z�X�p
Dim objCommon           '���ʊ֐��A�N�Z�X�p

Dim lngCmtCnt           '�R�����g����
Dim vntCmtCd            '�I������Ă���R�����g�R�[�h�Q
Dim vntArrCmtCd         '�I������Ă���R�����g�R�[�h�z��

Dim strJudClassCd       '�������蕪�ރR�[�h
Dim strJudClassName     '�������蕪�ޖ���
Dim lngStartPos         '�����J�n�ʒu
Dim lngGetCount         '�\������

'����R�����g���
Dim strArrJudCmtCd      '����R�����g�R�[�h
Dim strArrJudCmtStc     '����R�����g����
Dim strArrJudClassCd    '���蕪�ރR�[�h
Dim strArrJudClassName  '���蕪�ޖ���

Dim strDispJudCmtStc    '�ҏW�p�̔���R�����g����
Dim strDispJudCmtCd     '�ҏW�p�̔���R�����g�R�[�h

Dim strCheckJudCmt      '�`�F�b�N�{�b�N�X

Dim strAction           '
Dim strArrKey           '(�������)�����L�[�̏W��
Dim lngAllCount         '�����𖞂����S���R�[�h����
Dim lngCount            '���R�[�h����
Dim strURL              'URL������
Dim i, j                '�C���f�b�N�X

Dim strChecked          '�`�F�b�N�{�b�N�X�̃`�F�b�N���
Dim strBgColor          '�w�i�F
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objJudCmtStc = Server.CreateObject("HainsJudCmtStc.JudCmtStc")
Set objJudClass  = Server.CreateObject("HainsJudClass.JudClass")
Set objCommon    = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
strAction     = Request("act")
strJudClassCd = Request("judClassCd")
vntCmtCd      = Request("selCmtCd")
lngCmtcnt     = Request("selCmtCnt")
lngStartPos   = Request("startPos")
lngGetCount   = Request("getCount")

'�R�����g�R�[�h��z���
vntArrCmtCd = Array()
vntArrCmtCd = Split(vntCmtCd, "," )

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", objCommon.SelectJudCmtStcPageMaxLine, lngGetCount))

'���蕪�ޖ��擾
If Not IsEmpty(strJudClassCd) Then
    Call objJudClass.SelectJudClass(strJudClassCd, strJudClassName)
Else
    Err.Raise 1000, , "�w��̔��蕪�ރR�[�h�͑��݂��܂���BJudClassCd=" & strJudClassCd

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�R�����g�̑I��</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ����R�����g�R�[�h�E����R�����g���͂̃Z�b�g

function selectList( ) {

    var icnt;           //���[�v�J�E���g
    var jcnt;           //���[�v�J�E���g
    var kcnt;           //���[�v�J�E���g

    // �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
    if ( opener == null ) {
        return false;
    }

    // �e��ʂ̘A����ɑ΂��A����R�����g�R�[�h�E����R�����g���͂�ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

    jcnt = 0;
    opener.cmtGuide_varSelCmtCd.length = 0;
    opener.cmtGuide_varSelCmtStc.length = 0;
    opener.cmtGuide_varSelClassCd.length = 0;

    for ( icnt = 0; icnt < document.kensakulist.judCmtCd.length; icnt++ ){
        //���ɓo�^�ς̃R�����g�H
        for( kcnt = 0; kcnt < document.entryForm.selCmtCnt.value; kcnt++ ){
            if ( document.entryForm.selCmtCnt.value == 1 ){
                if ( document.kensakulist.judCmtCd[icnt].value == document.entryForm.selArrCmtCd.value ){
                    break;
                }
            } else {
                if ( document.kensakulist.judCmtCd[icnt].value == document.entryForm.selArrCmtCd[kcnt].value ){
                    break;
                }
            }
        }
        if (kcnt < document.entryForm.selCmtCnt.value){
            continue;
        }
        if ( document.kensakulist.judCmtCd[icnt].checked ) {
            opener.cmtGuide_varSelCmtCd.length ++;
            opener.cmtGuide_varSelCmtStc.length ++;
            opener.cmtGuide_varSelClassCd.length ++;
            opener.cmtGuide_varSelCmtCd[jcnt] = document.kensakulist.judCmtCd[icnt].value;
            opener.cmtGuide_varSelCmtStc[jcnt] = document.kensakulist.judCmtStc[icnt].value;
            opener.cmtGuide_varSelClassCd[jcnt] = document.kensakulist.judClassCd[icnt].value;
            jcnt++;
        }
    }

    // �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
    if ( opener.cmtGuide_CalledFunction != null ) {
        opener.cmtGuide_CalledFunction();
    }

    opener.winStepComment = null;
    close();

    return;
}

//�`�F�b�N�{�b�N�X�I������
//���ɓo�^�ς̃R�����g�̃`�F�b�N�͂͂����Ȃ�
function checkJudCmtAct( index ) {
    var icnt;           //���[�v�J�E���g
    var jcnt;           //���[�v�J�E���g

    //���ɓo�^�ς̃R�����g�H
    if( document.entryForm.selCmtCnt.value == 1 ) {
        if ( document.kensakulist.judCmtCd[index].value == document.entryForm.selArrCmtCd.value ){
                document.kensakulist.judCmtCd[index].checked = " CHECKED";
        }
    } else {
        for( icnt = 0; icnt < document.entryForm.selCmtCnt.value; icnt++ ){
            if ( document.kensakulist.judCmtCd[index].value == document.entryForm.selArrCmtCd[icnt].value ){
                 document.kensakulist.judCmtCd[index].checked = " CHECKED";
                break;
            }
        }
    }
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

    <INPUT TYPE="hidden" NAME="act" VALUE="select">
    <INPUT TYPE="hidden" NAME="selCmtCd" VALUE="<%= vntCmtCd %>">
    <INPUT TYPE="hidden" NAME="selCmtCnt" VALUE="<%= lngCmtCnt %>">
<%
    For i = 0 To lngCmtCnt-1
%>
        <INPUT TYPE="hidden" NAME="selArrCmtCd" VALUE="<%= vntArrCmtCd(i) %>">
<%
    Next
%>

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�R�����g�̑I��</FONT></B></TD>
        </TR>
    </TABLE>

    <BR>

    <TABLE BORDER="0" CELLPADDING="2" CELLPADDING="2" WIDTH="100%">
        <TR>
            <TD HEIGHT="30" NOWRAP><B><%= strJudClassName %>�R�����g</B></TD>
<!-- ### 2004/11/12 Add End --> 
            <TD WIDTH="100%" ALIGN="right"><A HREF="javascript:selectList()"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�m�肵�܂�"></A></TD>
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" ALT="�L�����Z�����܂�" HEIGHT="24" WIDTH="77"></A></TD>
        </TR>
    </TABLE>
</FORM>

<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<%
    Do

        strArrKey = Array()
        Redim strArrKey(0)

        '���������𖞂������R�[�h�������擾
        lngAllCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey, 1)

        '�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
        If lngAllCount = 0 Then
%>
            ���������𖞂�������R�����g���͑��݂��܂���B<BR>
            �L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
            Exit Do
        End If
        
        '���������𖞂��S�������̃��R�[�h���擾
        lngGetCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey, 1)

        lngCount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, _
                                                    strArrKey, _
                                                    lngStartPos, _
                                                    lngGetCount, _
                                                    strArrJudCmtCd, _
                                                    strArrJudCmtStc, _
                                                    strArrJudClassCd, _
                                                    strArrJudClassName, _
                                                    , , 1 )

        strCheckJudCmt = Array()
        Redim Preserve strCheckJudCmt(lngCount-1)
%>
        <TABLE BORDER="0" CELLSPACING="4" CELLPADDING="0">
<%
        For i = 0 to lngCount - 1

            '�\���p����R�����g���͂̕ҏW
            strDispJudCmtStc = strArrJudCmtStc(i)
            strDispJudCmtCd  = strArrJudCmtCd(i)
    
    
            '���ɑI���ς��`�F�b�N
            strChecked = ""
            strBgColor = ""
            For j = 0 to lngCmtCnt-1
                If strArrJudCmtCd(i) = vntArrCmtCd(j) Then
                    strChecked = " CHECKED"
                    strBgColor="#eeeeee" 
                    Exit For
                End If
            Next
    %>
    <%
            If i > 0 Then
    %>
                <TR>
                    <TD COLSPAN="3" HEIGHT="1" BGCOLOR="#999999"></TD>
                </TR>
    <%
            End If
    %>
            <TR>
                <TD>
                    <INPUT TYPE="hidden" NAME="judCmtStc" VALUE="<%= strArrJudCmtStc(i) %>">
                    <INPUT TYPE="hidden" NAME="judClassCd" VALUE="<%= strArrJudClassCd(i) %>">
                    <IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0">
                </TD>
                <TD BGCOLOR="<%= strBgColor %>" VALIGN="top"><INPUT TYPE="checkbox" NAME="judCmtCd" VALUE="<%= strArrJudCmtCd(i) %>" <%= strChecked %> ONCLICK="javascript:checkJudCmtAct( <%= i %> )" BORDER="0"></TD>
                <TD BGCOLOR="<%= strBgColor %>" WIDTH="100%"><%= strDispJudCmtStc %></TD>
                <TD NOWRAP>
                </TD>
            </TR>
<%
        Next
%>
        </TABLE>
<%
        Exit Do
    Loop
%>
</FORM>
</BODY>
</HTML>
