<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       �t�H���[�A�b�v�w�b�_�\�� (Ver0.0.1)
'       AUTHER  : T.Yaguchi@ORB
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_SAVE       = "save"      '�������[�h(�ۑ�)
Const MODE_CANCEL     = "cancel"    '�������[�h(��t������)
Const MODE_DELETE     = "delete"    '�������[�h(�폜)
Const CHART_NOTEDIV   = "500"       '�`���[�g���m�[�g���ރR�[�h
Const PUBNOTE_DISPKBN = 1           '�\���敪�����
Const PUBNOTE_SELINFO = 0           '������񁁌l�{��f���

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult          '��f���A�N�Z�X�p
Dim objPubNote          '�m�[�g�N���X
Dim objFollowUp         '�t�H���[�A�b�v�A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strWinMode          '�E�B���h�E���[�h
Dim lngRsvNo            '�\��ԍ�
Dim lngJudClassCd       '���蕪�ރR�[�h

Dim strUpdUser          '�X�V��
Dim strUpdUserName      '�X�V�Җ�

Dim lngCount            '
Dim lngAllCount         '

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objFollowUp = Server.CreateObject("HainsFollowUp.FollowUp")

'�����l�̎擾
strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
lngJudClassCd       = Request("judclasscd")
strUpdUser          = Session.Contents("userId")

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�ʐڎx���w�b�_</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    // �ۑ�����
    function saveFollow() {

        // �m�F���b�Z�[�W�̕\��
        if ( !confirm('���̓��e�ŕۑ����܂��B��낵���ł����H') ) return;

        // submit����
        parent.submitForm('<%= MODE_SAVE %>');
    }


    // �ĕ\������
    function preView() {

    }

    // �q�E�B���h�E�����
    function closeWindow() {

    }

//-->
</SCRIPT>
<style type="text/css">
	body { margin: <%= IIF(strWinMode = 1,"12","0") %>px 0 0 <%= IIF(strWinMode = 1,"20","5") %>px; }
</style>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<BODY ONUNLOAD="javascript:closeWindow()">
<%
    '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
    If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
        Call interviewHeader(lngRsvNo, 0)
    End If
%>

<FORM NAME="titleForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="judclasscd"  VALUE="<%= lngJudClassCd %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
<%
        '�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�̓X�y�[�X�͗v��Ȃ�
        If strWinMode <> 1 Then
%>
            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
        End If
%>
        <TD WIDTH="100%">
            <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                <TR>
                    <TD NOWRAP BGCOLOR="#ffffff" width="<%= IIF(strWinMode = 1,"65%","730")%>" HEIGHT="15"><B><SPAN CLASS="follow">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v���ʓo�^</FONT></B></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
                if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
                        <TD><A HREF="javascript:saveFollow()"><IMG SRC="/webHains/images/save.gif" WIDTH="80" HEIGHT="21" ALT="�ύX�������e��ۑ����܂�"></A></TD>
<%
                end if
%>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="80" HEIGHT="1"></TD>
            </TR>
        </TABLE>
    </TR>
</TABLE>


</FORM>
<SCRIPT TYPE="text/javascript">
<!--
    var myForm =    document.headerForm;
-->
</SCRIPT>
</BODY>
</HTML>
