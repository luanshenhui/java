<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �K�w���R�����g  (Ver0.0.1)
'	   AUTHER  
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const DISPMODE_SPADVICE = 5     '�\�����ށF���茒�f
Const JUDCLASSCD_SPADVICE = 90  '���蕪�ރR�[�h�F���茒�f

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon             '���ʃN���X
Dim objSpecialInterview   '���茒�f�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode          '�E�B���h�E���[�h
Dim lngRsvNo            '�\��ԍ�
Dim strAct              '�������

'�K�w���R�����g
Dim vntSpecialCmtSeq    '�\����
Dim vntSpecialCmtCd     '�K�w���R�����g�R�[�h
Dim vntSpecialCmtStc    '�K�w���R�����g����
Dim vntSpecialClassCd   '���蕪�ރR�[�h
Dim lngSpecialCmtCnt    '�s��

'�X�V����R�����g���
Dim vntUpdCmtSeq        '�\����
Dim vntUpdSpecialCmtCd  '�K�w���R�����g�R�[�h
Dim lngUpdCount         '�X�V���ڐ�

'�ύX����p
Dim vntUpdSpecialCmtStc '�K�w���R�����g

Dim i, j                '�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objSpecialInterview	= Server.CreateObject("HainsSpecialInterview.SpecialInterview")

'�����l�̎擾
strAct              = Request("act")
strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")

'�X�V����R�����g���
lngSpecialCmtCnt   = Clng("0" & Request("SpecialCmtCnt"))
vntUpdSpecialCmtCd  = ConvIStringToArray(Request("SpecialCmtCd"))
'�ύX����p�ɒǉ�
vntUpdSpecialCmtStc= ConvIStringToArray(Request("SpecialCmtStc"))

Do
    '�ۑ�
    If strAct = "save" Then

        '�K�w���R�����g�̕ۑ�
        lngUpdCount = 0
        vntUpdCmtSeq = Array()
        ReDim vntUpdCmtSeq(-1)
        If lngSpecialCmtCnt > 0 Then
            For i = 0 To UBound(vntUpdSpecialCmtCd)
                ReDim Preserve vntUpdCmtSeq(lngUpdCount)
                vntUpdCmtSeq(lngUpdCount) = lngUpdCount + 1
                lngUpdCount = lngUpdCount + 1
            Next
        End If
        '�X�V����p�ɕ��͂ƃ��[�U�h�c�ǉ�
        objSpecialInterview.UpdateSpecialJudCmt _
                                lngRsvNo, _
                                DISPMODE_SPADVICE, _
                                vntUpdCmtSeq, _
                                vntUpdSpecialCmtCd, _
                                vntUpdSpecialCmtStc, _
                                Session.Contents("userId")

        strAct = "saveend"
    End If


    '�K�w���R�����g�擾
    lngSpecialCmtCnt = objSpecialInterview.SelectSpecialJudCmt( _
                                        lngRsvNo, _
                                        DISPMODE_SPADVICE, _
                                        vntSpecialCmtSeq, _
                                        vntSpecialCmtCd, _
                                        vntSpecialCmtstc, _
                                        vntSpecialClassCd _
                                        )

    Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���茒�f����R�����g</TITLE>
<!-- #include virtual = "/webHains/includes/commentGuide.inc"    -->
<SCRIPT TYPE="text/javascript">
<!--
var winJudComment;              // �E�B���h�E�n���h��
var jcmGuide_CmtType;           // �R�����g�^�C�v
var jcmGuide_CmtMode;           // �������[�h(�ǉ��A�}���A�C���A�폜)
var jcmGuide_SelectedIndex;     // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
// �ҏW�O
var varEditCmtCd;
var varEditCmtStc;
var varEditClassCd;
// �ҏW��
var varNewCmtCd;
var varNewCmtStc;
var varNewClassCd;

function selectComment( cmttype, cmtmode ) {
    var myForm = document.entryForm;
    var dispmode;
    var elemCmtCd;
    var elemCmtStc;
    var elemClassCd;
    var i;

    jcmGuide_CmtType = cmttype;
    jcmGuide_CmtMode = cmtmode;

    jcmGuide_SelectedIndex = myForm.selectSpecialList.value;
    cmtGuide_editcnt = myForm.SpecialCmtCnt.value;
    dispmode = <%= JUDCLASSCD_SPADVICE %>
    elemCmtCd = myForm.SpecialCmtCd;
    elemCmtStc = myForm.SpecialCmtStc;
    elemClassCd = myForm.SpecialClassCd;

    if ( jcmGuide_CmtMode == 'insert' || jcmGuide_CmtMode == 'edit' || jcmGuide_CmtMode == 'delete' ){
        if ( jcmGuide_SelectedIndex == 0 ){
            alert( "�ҏW����s���I������Ă��܂���B" );
            return;
        }
    }

    // �R�����g��ҏW�G���A�ɃZ�b�g
    cmtGuide_varEditCmtCd = new Array(0);
    varEditCmtCd = new Array(0);
    varEditCmtStc = new Array(0);
    varEditClassCd = new Array(0);
    for ( i = 0; i < cmtGuide_editcnt; i++ ){
        if ( isNaN(elemCmtCd.length) ){
            cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length ++] = elemCmtCd.value;
            varEditCmtCd[varEditCmtCd.length ++] = elemCmtCd.value;
            varEditCmtStc[varEditCmtStc.length ++] = elemCmtStc.value;
            varEditClassCd[varEditClassCd.length ++] = elemClassCd.value;
        } else {
            cmtGuide_varEditCmtCd[cmtGuide_varEditCmtCd.length ++] = elemCmtCd[i].value;
            varEditCmtCd[varEditCmtCd.length ++] = elemCmtCd[i].value;
            varEditCmtStc[varEditCmtStc.length ++] = elemCmtStc[i].value;
            varEditClassCd[varEditClassCd.length ++] = elemClassCd[i].value;
        }
    }

    if ( jcmGuide_CmtMode == 'delete' ) {
        // �폜�̂Ƃ��̓R�����g�K�C�h�K�v�Ȃ�
        setComment();
    } else {
        // �R�����g�K�C�h�̌ďo
        cmtGuide_showAdviceComment(dispmode, setComment);
    }
}

// �R�����g���Z�b�g
function setComment() {
    var myForm = document.entryForm;
    var optList;
    var strHtml;
    var i;

    optList = myForm.selectSpecialList;

    // �R�����g�̕ҏW
    varNewCmtCd = new Array(0);
    varNewCmtStc = new Array(0);
    varNewClassCd = new Array(0);
        // �ǉ�
    if ( jcmGuide_CmtMode == 'add' ) {
        for ( i = 0; i < varEditCmtCd.length; i++ ){
            varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
            varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
            varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
        }
        for ( i = 0; i < cmtGuide_varSelCmtCd.length; i++ ){
            varNewCmtCd[varNewCmtCd.length ++] = cmtGuide_varSelCmtCd[i];
            varNewCmtStc[varNewCmtStc.length ++] = cmtGuide_varSelCmtStc[i];
            varNewClassCd[varNewClassCd.length ++] = cmtGuide_varSelClassCd[i];
        }
    } else
        // �}���A�C��
    if ( jcmGuide_CmtMode == 'insert' || jcmGuide_CmtMode == 'edit' ) {
        for ( i = 0; i < jcmGuide_SelectedIndex - 1; i++ ){
            varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
            varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
            varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
        }
        for ( i = 0; i < cmtGuide_varSelCmtCd.length; i++ ){
            varNewCmtCd[varNewCmtCd.length ++] = cmtGuide_varSelCmtCd[i];
            varNewCmtStc[varNewCmtStc.length ++] = cmtGuide_varSelCmtStc[i];
            varNewClassCd[varNewClassCd.length ++] = cmtGuide_varSelClassCd[i];
        }
        for ( i = jcmGuide_SelectedIndex - 1; i < varEditCmtCd.length; i++ ){
            // �C���̂Ƃ��I���s�͊O��
            if ( jcmGuide_CmtMode == 'edit' && i == jcmGuide_SelectedIndex - 1 ) continue;

            varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
            varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
            varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
        }
    } else
        // �폜
    if ( jcmGuide_CmtMode == 'delete' ) {
        for ( i = 0; i < varEditCmtCd.length; i++ ){
            // �폜�̂Ƃ��I���s�͊O��
            if ( i == jcmGuide_SelectedIndex - 1 ) continue;

            varNewCmtCd[varNewCmtCd.length ++] = varEditCmtCd[i];
            varNewCmtStc[varNewCmtStc.length ++] = varEditCmtStc[i];
            varNewClassCd[varNewClassCd.length ++] = varEditClassCd[i];
        }
    }

    // �R�����g�̍ĕ`��
    strHtml = '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'CmtCnt"  VALUE="' + varNewCmtCd.length + '">\n';
    for ( i = 0; i < varNewCmtCd.length; i++ ) {
        strHtml = strHtml + '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'CmtCd"   VALUE="' + varNewCmtCd[i] + '">\n';
        strHtml = strHtml + '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'CmtStc"  VALUE="' + varNewCmtStc[i] + '">\n';
        strHtml = strHtml + '<INPUT TYPE="hidden" NAME="' + jcmGuide_CmtType + 'ClassCd" VALUE="' + varNewClassCd[i] + '">\n';
    }
    document.getElementById(jcmGuide_CmtType + 'List').innerHTML = strHtml;

    // SELECT�I�u�W�F�N�g�̍ĕ`��
    while ( optList.length > 0 ) {
        optList.options[0] = null;
    }
    for ( i = 0; i < varNewCmtCd.length; i++ ){
        optList.options[optList.length] = new Option( varNewCmtStc[i], i+1 );
    }
}


//�ۑ�
function saveSpecialComment() {

    // ���[�h���w�肵��submit
    document.entryForm.act.value = 'save';
    document.entryForm.submit();

}

function saveClose(){
    if(document.entryForm.act.value == 'saveend'){
        opener.refreshForm();
        window.close();
    }

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:saveClose();" ONUNLOAD="javascript:cmtGuide_closeAdviceComment();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
    <!-- �����l -->
    <INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAct %>">

    <!-- �^�C�g���̕\�� -->
    <TABLE WIDTH="686" BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD WIDTH="100%">
                <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">���茒�f�R�����g</FONT></B></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>

    <TABLE WIDTH="686" BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD HEIGHT="10">
            </TD>
        </TR>
        <TR>
            <TD WIDTH="100%" ALIGN="RIGHT">
            <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <A HREF="javascript:saveSpecialComment()"><IMG SRC="../../images/save.gif" ALT="���͓��e��ۑ����܂�" HEIGHT="24" WIDTH="77"></A>
            <%  else %>
                 &nbsp;
            <%  end if  %>	
            <BR>
            </TD>
        </TR>
    </TABLE>
    <!-- �K�w���R�����g�̕\�� -->
    <TABLE WIDTH="366" BORDER="0" CELLSPACING="2" CELLPADDING="0">
        <TR>
            <TD COLSPAN="2"><B><SPAN CLASS="result">��</SPAN></B>�K�w���R�����g</TD>
        </TR>
        <TR>
            <TD>
                <SELECT STYLE="width:600px" NAME="selectSpecialList" SIZE="7">

<%
    For i = 0 To lngSpecialCmtCnt - 1
%>
                    <OPTION VALUE="<%= vntSpecialCmtSeq(i) %>"><%= vntSpecialCmtStc(i) %></OPTION>
<%
    Next
%>
                </SELECT>
            </TD>
            <TD VALIGN="top">
                <TABLE WIDTH="64" BORDER="1" CELLSPACING="2" CELLPADDING="0">
                    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Special','add')">�ǉ�</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Special','insert')">�}��</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Special','edit')">�C��</A></TD>
                        </TR>
                        <TR>
                            <TD ALIGN="center"><A HREF="javascript:selectComment('Special','delete')">�폜</A></TD>
                        </TR>
                     <%  end if  %>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <SPAN ID="SpecialList">
        <INPUT TYPE="hidden" NAME="SpecialCmtCnt" VALUE="<%= lngSpecialCmtCnt %>">
<%
For i = 0 To lngSpecialCmtCnt - 1
%>
        <INPUT TYPE="hidden" NAME="SpecialCmtSeq"  VALUE="<%= vntSpecialCmtSeq(i) %>">
        <INPUT TYPE="hidden" NAME="SpecialCmtCd"   VALUE="<%= vntSpecialCmtCd(i) %>">
        <INPUT TYPE="hidden" NAME="SpecialCmtStc"  VALUE="<%= vntSpecialCmtStc(i) %>">
        <INPUT TYPE="hidden" NAME="SpecialClassCd" VALUE="<%= vntSpecialClassCd(i) %>">
<%
Next
%>
    </SPAN>
</FORM>
</BODY>
</HTML>