<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���f�O�����i��f�j���� �w�b�_�[  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objRslOcr           'OCR���͌��ʃA�N�Z�X�p
'2004.11.08 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
Dim objFollowUp         '�t�H���[�A�b�v�A�N�Z�X�p
'2004.11.08 ADD END
Dim objFollow           '�t�H���[�A�b�v�A�N�Z�X�p

'�p�����[�^
Dim lngRsvNo            '�\��ԍ�

Dim vntEditOcrDate      'OCR���e�m�F�C������
Dim Ret                 '���A�l
'2004.11.21 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
Dim lngFolRsvNo         '�t�H���[�O��\��ԍ�
Dim dtmFolCslDate       '�t�H���[�O���f��
Dim strFolCsCd          '�t�H���[�O��R�[�X�R�[�h
Dim blnFollowFlg        '�t�H���[���݃t���O
'2004.11.21 ADD END

'#### 2009.10.03 �� �ǉ�
Dim blnFollowBefore     '�O��t�H���[���`�F�b�N�t���O

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objRslOcr   = Server.CreateObject("HainsRslOcr.OcrNyuryoku")
'2004.11.21 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")
'2004.11.21 ADD END
Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'�����l�̎擾
lngRsvNo            = Request("rsvno")

Do
    'OCR���e�m�F�C���������擾����
    Ret = objRslOcr.SelectEditOcrDate( _
                                        lngRsvNo, _
                                        vntEditOcrDate _
                                        )
    If Ret = False Then
        Err.Raise 1000, , "OCR���e�m�F�C���������擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
    End If

    '�I�u�W�F�N�g�̃C���X�^���X�폜
    Set objRslOcr = Nothing

'''2004.11.08 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
''    '�t�H���[�A�b�v�擾
''    blnFollowFlg = objFollowUp.SelectFollow_Before(lngRsvNo, lngFolRsvNo, dtmFolCslDate, strFolCsCd)
'''2004.11.08 ADD END

'#### 2009.10.03 �� �t�H���[�A�b�v�֘A���W�b�N�ǉ� Start ####

    '�O��t�H���[���o�^�L���`�F�b�N�y�уL�[�f�[�^�擾
    blnFollowBefore = objFollow.SelectFollow_Before(lngRsvNo, lngFolRsvNo, dtmFolCslDate, strFolCsCd)

'#### 2009.10.03 �� �t�H���[�A�b�v�֘A���W�b�N�ǉ� End   ####

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��f����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winEditCsvDat;          // �E�B���h�E�n���h��
//'2004.11.08 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
var winFollow;              // �t�H���[�A�b�v��ʃE�B���h�E�n���h��
//'2004.11.08 ADD END

// CSV�t�@�C���쐬��ʌĂяo��
function callEditCsvDatMonshin() {
    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩


    if( !confirm('�l�b�g�A�g�p�t�@�C�����쐬���܂��B��낵���ł����H') ) return;

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if (winEditCsvDat != null ) {
        if ( !winEditCsvDat.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/monshin/EditCsvDatMonshin.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winEditCsvDat.focus();
        winEditCsvDat.location.replace( url );
    } else {
        winEditCsvDat = window.open( url, '', 'width=400,height=400,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=no');
    }

}

// '2004.11.08 ADD STR ORB)T.Yaguchi 
//�t�H���[�A�b�v���͉�ʌĂяo��
function callfollowupNyuryoku( noteDiv ) {
    var url;            // URL������
    var opened = false; // ��ʂ����łɊJ����Ă��邩

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if (winFollow != null ) {
        if ( !winFollow.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/followup/followupTop.asp';
    url = url + '?winmode=' + '1';
    url = url + '&PubNoteDivCd=500';
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strFolCsCd %>';
    url = url + '&strYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&strMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&strDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&endYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&endMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&endDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&rsvno=' + '<%= lngFolRsvNo %>';

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winFollow.focus();
        winFollow.location.replace( url );
    } else {
        winFollow = window.open( url, '', 'width=950,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }


}
// '2004.11.08 ADD END

// 2009.10.03 �� �O��t�H���[�A�b�v����ʌĂяo��
function callfollowupBefore( noteDiv ) {
    var url;                // URL������
    var opened = false;     // ��ʂ����łɊJ����Ă��邩

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if (winFollow != null ) {
        if ( !winFollow.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/follow/followInfoTop.asp';
    url = url + '?winmode=' + '1';
    url = url + '&PubNoteDivCd=' + noteDiv;
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strFolCsCd %>';
    url = url + '&strYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&strMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&strDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&endYear=' + '<%= Year(dtmFolCslDate) %>';
    url = url + '&endMonth=' + '<%= Month(dtmFolCslDate) %>';
    url = url + '&endDay=' + '<%= Day(dtmFolCslDate) %>';
    url = url + '&rsvno=' + '<%= lngFolRsvNo %>';

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winFollow.focus();
        winFollow.location.replace( url );
    } else {
        winFollow = window.open( url, '', 'width=1000,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }

}


function windowClose() {

    //  CSV�t�@�C���쐬��ʂ����
    if ( winEditCsvDat != null ) {
        if ( !winEditCsvDat.closed ) {
            winEditCsvDat.close();
        }
    }

    winEditCsvDat = null;

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
</HEAD>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BODY  ONUNLOAD="javascript:windowClose()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="3"></TD>
            <TD WIDTH="100%">
                <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                    <TR>
                        <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��f����</FONT></B></TD>
                    </TR>
                </TABLE>
            </TD>
            <TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="8"></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
        <TR>
            <TD WIDTH="116"></TD>
        </TR>
        <TR>
            <TD NOWRAP><A HREF="ocrNyuryoku.asp?rsvno=<%= lngRsvNo %>" TARGET="_blank"><IMG SRC="../../images/b_ocrResult.gif" HEIGHT="24" WIDTH="110" ALT="OCR������͂��ꂽ���e��\�����܂��B"></A></TD>
<%
'2004.11.08 ADD STR ORB)T.Yaguchi �t�H���[�ǉ�
'### 2009.10.03 �� �O��t�H���[���`�F�b�N���l�ύX
    'If blnFollowFlg = True Then
    If blnFollowBefore = True Then
%>
            <!--TD NOWRAP><A HREF="JavaScript:callfollowupNyuryoku()"><IMG SRC="../../images/followup.gif" HEIGHT="24" WIDTH="110" ALT="�t�H���[�A�b�v��ʂ�\�����܂�"></A></TD-->
            <TD NOWRAP><A HREF="JavaScript:callfollowupBefore('500')"><IMG SRC="../../images/followup_before.gif" HEIGHT="24" WIDTH="110" ALT="�O��t�H���[�A�b�v����ʂ�\�����܂�"></A></TD>
<%
    End If
'2004.11.08 ADD END
%>
<%
    If vntEditOcrDate <> "" Then
%>
            <TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:callEditCsvDatMonshin()"><IMG SRC="../../images/mentalKick.gif" HEIGHT="24" WIDTH="110" ALT="�l�b�g�A�g�p�t�@�C���쐬���܂��B"></A></TD>
<%
    End If
%>
        </TR>
    </TABLE>
</FORM>
</BODY>
</HTML>