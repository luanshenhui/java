<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      ���R�����g�i�R�����g�ꗗ�j  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
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
Const COMMENTLIST_SELINFO_CSL   = 1     '��f���
Const COMMENTLIST_SELINFO_PER   = 2     '�l
Const COMMENTLIST_SELINFO_ORG   = 3     '�c��
Const COMMENTLIST_SELINFO_CTR   = 4     '�_��
Const COMMENTLIST_SELINFO_ALL   = 0     '�l�{��f

Const COMMENTLIST_HISTFLG_NOW   = 0     '����
Const COMMENTLIST_HISTFLG_OLD   = 1     '�ߋ�
Const COMMENTLIST_HISTFLG_ALL   = 2     '�S��


'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon           '���ʃN���X
Dim objConsult          '��f�N���X
Dim objPubNote          '�m�[�g�N���X

'�p�����[�^
Dim lngRsvNo            '�\��ԍ�
Dim strPerId            '�lID
Dim strOrgCd1           '�c�̃R�[�h�P
Dim strOrgCd2           '�c�̃R�[�h�Q
Dim strCtrPtCd          '�_��p�^�[���R�[�h
Dim lngStrYear          '�\���J�n�N
Dim lngStrMonth         '�\���J�n��
Dim lngStrDay           '�\���J�n��
Dim lngEndYear          '�\���I���N
Dim lngEndMonth         '�\���I����
Dim lngEndDay           '�\���I����
Dim strPubNoteDivCd     '�m�[�g����
Dim strPubNoteDivCdCtr  '�m�[�g����(�_��p)
Dim strPubNoteDivCdOrg  '�m�[�g����(�c�̗p)
Dim lngDispKbn          '�\���Ώۋ敪
Dim lngDispMode         '�\�����[�h(0:�l�{�����f�{�ߋ���f, 1:�l�E��f�{�c�́{�_��,
                        '           2:�l�E��f, 3:�l, 4:�c��, 5:�_��)
Dim strType             '�\���^�C�v
'### 2004/3/24 Added by Ishihara@FSIT �폜�f�[�^�\���Ή�
Dim lngIncDelNote       '1:�폜�f�[�^���\��
'### 2004/3/24 Added End

'�m�[�g���
Dim vntSeq              'seq
Dim vntPubNoteDivCd     '��f���m�[�g���ރR�[�h
Dim vntPubNoteDivName   '��f���m�[�g���ޖ���
Dim vntDefaultDispKbn   '�\���Ώۋ敪�����l
Dim vntOnlyDispKbn      '�\���Ώۋ敪���΂�
Dim vntDispKbn          '�\���Ώۋ敪
Dim vntUpdDate          '�o�^����
Dim vntUpdUser          '�o�^��
Dim vntUserName         '�o�^�Җ�
Dim vntBoldFlg          '�����敪
Dim vntPubNote          '�m�[�g
Dim vntDispColor        '�\���F
Dim vntSelInfo          '�������
Dim vntRsvNo            '�\��ԍ�
Dim vntCslDate          '��f��
Dim vntCsName           '�R�[�X��
'### 2004/3/24 Added by Ishihara@FSIT �폜�f�[�^�\���Ή�
Dim vntDelFlg           '�폜�t���O
'### 2004/3/24 Added End

Dim lngSelInfo          '�������i1:��f���A2:�l�A3:�c�́A4:�_��A0:�l�{��f�j
Dim lngHistFlg          '0:����̂݁A1:�ߋ��̂݁A2:�S��
Dim strStrDate          '�\������(�J�n)
Dim strEndDate          '�\������(�I��)

Dim strUpdUser          '�X�V��

Dim lngCount            '�擾����
Dim Ret                 '���A�l
Dim i, j                '�J�E���^�[
Dim strTitle            '�^�C�g��
Dim strMarkColor        '�}�[�N�\���F
Dim strArrDataName      '�f�[�^����
Dim strHtml             'Html������
Dim strDispKbn          '�\���Ώۋ敪

'### 2004/3/24 Added by Ishihara@FSIT �폜�f�[�^�\���Ή�
Dim strTRColor          '�s���̃J���[
'### 2004/3/24 Added End

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objPubNote  = Server.CreateObject("HainsPubNote.PubNote")

'�����l�̎擾
lngRsvNo            = CLng("0" & Request("rsvno"))
strPerId            = Request("perid")
strOrgCd1           = Request("orgcd1")
strOrgCd2           = Request("orgcd2")
strCtrPtCd          = Request("ctrptcd")
lngStrYear          = CLng("0" & Request("StrYear"))
lngStrMonth         = CLng("0" & Request("StrMonth"))
lngStrDay           = CLng("0" & Request("StrDay"))
lngEndYear          = CLng("0" & Request("EndYear"))
lngEndMonth         = CLng("0" & Request("EndMonth"))
lngEndDay           = CLng("0" & Request("EndDay"))
strPubNoteDivCd     = Request("PubNoteDivCd")
strPubNoteDivCdCtr  = Request("PubNoteDivCdOrg")
strPubNoteDivCdOrg  = Request("PubNoteDivCdCtr")
lngDispKbn          = CLng("0" & Request("DispKbn"))
lngDispMode         = CLng("0" & Request("DispMode"))
strType             = Request("type")
'### 2004/3/24 Added by Ishihara@FSIT �폜�f�[�^�\���Ή�
lngIncDelNote       = Request("IncDelNote")
'### 2004/3/24 Added End

strUpdUser          = Session("USERID")

Do
    '�\���^�C�v���\��������e������
    Select Case strType
    Case "1"    '�l
        lngSelInfo = COMMENTLIST_SELINFO_PER
        lngHistFlg = COMMENTLIST_HISTFLG_NOW
        strMarkColor = "red"
        strTitle = "�l�ɑ΂���R�����g�ꗗ"
        strArrDataName = Array( "�R�����g���", _
                                "���e", _
                                "�I�y���[�^��", _
                                "�X�V����" )

    Case "2"    '�����f���
        lngSelInfo = COMMENTLIST_SELINFO_CSL
        lngHistFlg = COMMENTLIST_HISTFLG_NOW
        strMarkColor = "blue"
        strTitle = "�����f���ɑ΂���R�����g�ꗗ"
        strArrDataName = Array( "�R�����g���", _
                                "���e", _
                                "�I�y���[�^��", _
                                "�X�V����" )

    Case "3"    '�ߋ���f���
        lngSelInfo = COMMENTLIST_SELINFO_CSL
        lngHistFlg = COMMENTLIST_HISTFLG_OLD
        strMarkColor = "yellow"
        strTitle = "�ߋ���f���ɑ΂���R�����g�ꗗ"
'### 2009.10.24 �� �\�������ύX�˗��ɂ���ďC�� Start ###
'        strArrDataName = Array( "�R�����g���", _
'                                "���e", _
'                                "��f��", _
'                                "�R�[�X", _
'                                "�I�y���[�^��", _
'                                "�X�V����" )
        strArrDataName = Array( "�R�����g���", _
                                "��f��", _
                                "���e", _
                                "�R�[�X", _
                                "�I�y���[�^��", _
                                "�X�V����" )
'### 2009.10.24 �� �\�������ύX�˗��ɂ���ďC�� End   ###

    Case "4"    '�l�{��f���
        lngSelInfo = COMMENTLIST_SELINFO_ALL
        lngHistFlg = COMMENTLIST_HISTFLG_ALL
        strMarkColor = ""
        strTitle = ""
'### 2009.10.24 �� �\�������ύX�˗��ɂ���ďC�� Start ###
'        strArrDataName = Array( "�R�����g���", _
'                                "���e", _
'                                "��f��", _
'                                "�ΏۃR�����g", _
'                                "�I�y���[�^��", _
'                                "�X�V����" )
        strArrDataName = Array( "�R�����g���", _
                                "�ΏۃR�����g", _
                                "��f��", _
                                "���e", _
                                "�I�y���[�^��", _
                                "�X�V����" )
'### 2009.10.24 �� �\�������ύX�˗��ɂ���ďC�� End   ###

    Case "5"    '�_��
        lngSelInfo = COMMENTLIST_SELINFO_CTR
'### 2004/4/24 Updated by Ishihata@FSIT �_��͒c�̃R�[�h�w��̏ꍇ�A�L���͈͂�����
'       lngHistFlg = COMMENTLIST_HISTFLG_NOW
        lngHistFlg = COMMENTLIST_HISTFLG_ALL
'### 2004/4/24 Updated End
        strMarkColor = "magenta"
        strTitle = "�_��ɑ΂���R�����g�ꗗ"
        strArrDataName = Array( "�R�����g���", _
                                "���e", _
                                "�I�y���[�^��", _
                                "�X�V����" )
        '�_��p�̃m�[�g���ނ��w�肳��Ă���
        If strPubNoteDivCdCtr <> "" Then
            strPubNoteDivCd = strPubNoteDivCdCtr
        End If

    Case "6"	'�c��
        lngSelInfo = COMMENTLIST_SELINFO_ORG
        lngHistFlg = COMMENTLIST_HISTFLG_NOW
        strMarkColor = "cyan"
        strTitle = "�c�̂ɑ΂���R�����g�ꗗ"
        strArrDataName = Array( "�R�����g���", _
                                "���e", _
                                "�I�y���[�^��", _
                                "�X�V����" )
        '�c�̗p�̃m�[�g���ނ��w�肳��Ă���
        If strPubNoteDivCdOrg <> "" Then
            strPubNoteDivCd = strPubNoteDivCdOrg
        End If

    Case Else
        Err.Raise 1000, , "�\���^�C�v���s���itype= " & strType & " )"
    End Select

    If lngStrYear <> 0 Or lngStrMonth <> 0 Or lngStrDay <> 0 Then
        strStrDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
    Else
        strStrDate = ""
    End If
    If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
        strEndDate = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay
    Else
        strEndDate = ""
    End If

    '�m�[�g���̎擾
    lngCount = objPubNote.SelectPubNote(lngSelInfo,           _
                                        lngHistFlg,          _
                                        strStrDate,          _
                                        strEndDate,          _
                                        lngRsvNo,            _
                                        strPerId,            _
                                        strOrgCd1,           _
                                        strOrgCd2,           _
                                        strCtrPtCd,          _
                                        0,                   _
                                        strPubNoteDivCd,     _
                                        lngDispKbn,          _
                                        strUpdUser,          _
                                        vntSeq,              _
                                        vntPubNoteDivCd,     _
                                        vntPubNoteDivName,   _
                                        vntDefaultDispKbn,   _
                                        vntOnlyDispKbn,      _
                                        vntDispKbn,          _
                                        vntUpdDate,          _
                                        vntUpdUser,          _
                                        vntUserName,         _
                                        vntBoldFlg,          _
                                        vntPubNote,          _
                                        vntDispColor,        _
                                        vntSelInfo,          _
                                        vntRsvNo,            _
                                        vntCslDate,          _
                                        vntCsName,           _
                                        lngIncDelNote,       _
                                        vntDelFlg )

    If lngCount < 0 Then
        Err.Raise 1000, , "�m�[�g��񂪑��݂��܂���B"
    End If

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�R�����g�ꗗ</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winCommentDetail;           // �R�����g���ڍ׃E�B���h�E�n���h��

// �C��
function calCommentDetail( index ) {
    var myForm = document.entryForm;
    var url;                    // URL������
    var opened = false;         // ��ʂ����łɊJ����Ă��邩
    var selinfo;

    url = '/WebHains/contents/comment/commentDetail2.asp';
    url = url + '?rsvno='   + myForm.rsvno.value;
    url = url + '&perid='   + myForm.perid.value;
    url = url + '&orgcd1='  + myForm.orgcd1.value;
    url = url + '&orgcd2='  + myForm.orgcd2.value;
    url = url + '&ctrptcd=' + myForm.ctrptcd.value;
    if ( myForm.selInfo.length != null ) {
        selinfo = document.entryForm.selInfo[index].value;
    } else {
        selinfo = document.entryForm.selInfo.value;
    }
    switch( selinfo ) {
    case '1':
        url = url + '&cmtMode=1,0,0,0';
        break;
    case '2':
        url = url + '&cmtMode=0,1,0,0';
        break;
    case '3':
        url = url + '&cmtMode=0,0,1,0';
        break;
    case '4':
        url = url + '&cmtMode=0,0,0,1';
        break;
    }
    if ( myForm.seq.length != null ) {
        url = url + '&seq=' + document.entryForm.seq[index].value;
    } else {
        url = url + '&seq=' + document.entryForm.seq.value;
    }

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winCommentDetail != null ) {
        if ( !winCommentDetail.closed ) {
            opened = true;
        }
    }

    // �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winCommentDetail.focus();
        winCommentDetail.location.replace( url );
    } else {
        winCommentDetail = window.open( url, '', 'width=650,height=500,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
    }
}

// �E�B���h�E�����
function windowClose() {

    // �R�����g���ڍׂ����
    if ( winCommentDetail != null ) {
        if ( !winCommentDetail.closed ) {
            winCommentDetail.close();
        }
    }

    winCommentDetail  = null;
}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 20px 0 0 <%= IIF(lngDispMode="2","20px","5px") %>; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <!-- �����l -->
    <INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="perid"   VALUE="<%= strPerId %>">
    <INPUT TYPE="hidden" NAME="orgcd1"  VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgcd2"  VALUE="<%= strOrgCd2 %>">
    <INPUT TYPE="hidden" NAME="ctrptcd" VALUE="<%= strCtrPtCd %>">

    <!-- �^�C�g���̕\�� -->
<%
    If strTitle <> "" Then
%>
    <TABLE WIDTH="600" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="hainsdef"><FONT COLOR="<%= strMarkColor %>">��</FONT></SPAN><FONT COLOR="#000000"><%= strTitle %></FONT></B></TD>
        </TR>
    </TABLE>
<%
    End If
%>
    <!-- �R�����g�ꗗ�̕\�� -->
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR BGCOLOR="#cccccc">
<%
    strHtml = ""
    For j=0 To UBound(strArrDataName)
        Select Case strArrDataName(j)
        Case "�R�����g���"
'### 2009.10.24 �� �f�t�H���g�\���T�C�Y�ύX Start ###
'            strHtml = strHtml & "<TD NOWRAP WIDTH=""150"">" & strArrDataName(j) & "</TD>"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""100"">" & strArrDataName(j) & "</TD>"
'### 2009.10.24 �� �f�t�H���g�\���T�C�Y�ύX End   ###

        Case "���e"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""360"">" & strArrDataName(j) & "</TD>"

        Case "�I�y���[�^��"
            'strHtml = strHtml & "<TD NOWRAP WIDTH=""150"">" & strArrDataName(j) & "</TD>"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""100"">" & strArrDataName(j) & "</TD>"

        Case "�X�V����"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""130"">" & strArrDataName(j) & "</TD>"

        Case "��f��"
            'strHtml = strHtml & "<TD NOWRAP WIDTH=""85"">" & strArrDataName(j) & "</TD>"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""75"">" & strArrDataName(j) & "</TD>"

        Case "�R�[�X"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""100"">" & strArrDataName(j) & "</TD>"

        Case "�ΏۃR�����g"
            'strHtml = strHtml & "<TD NOWRAP WIDTH=""80"">" & strArrDataName(j) & "</TD>"
            strHtml = strHtml & "<TD NOWRAP WIDTH=""70"">" & strArrDataName(j) & "</TD>"

        End Select
    Next
    Response.Write strHTML
%>
        </TR>
<%
    For i = 0 To lngCount - 1

        '�s���̕\���F�ύX
        If i mod 2 = 0 Then
            strTRColor = "#ffffff"
        Else
            strTRColor = "#eeeeee"
        End If

        '�폜�f�[�^�̕\���F�ύX
        If vntDelFlg(i) = "1" Then
            strTRColor = "#FFC0CB"
        End If

%>
        <TR VALIGN="top" BGCOLOR="<%= strTRColor %>">
<%
        strHtml = ""
        For j=0 To UBound(strArrDataName)
            Select Case strArrDataName(j)
            Case "�R�����g���"
                strHtml = strHtml & "<TD NOWRAP>" & vntPubNoteDivName(i) & "</TD>"

            Case "���e"
                '�\���Ώۋ敪���}�[�N�ŕ\��
                Select Case vntDispKbn(i)
                Case "1"    '���
                    strDispKbn = "<FONT COLOR=""#FF6666"">��</FONT>"
                Case "2"    '����
                    strDispKbn = "<FONT COLOR=""#6666FF"">��</FONT>"
                Case "3"    '����
                    strDispKbn = "<FONT COLOR=""#66FF66"">��</FONT>"
                End Select

'### 2009.10.24 �� ���e�̐܂�Ԃ��\�����ł���悤�ɕύX Start ###
'                strHtml = strHtml & "<TD NOWRAP>" & strDispKbn & IIf(vntBoldFlg(i)=1, "<B>", "")
                strHtml = strHtml & "<TD>" & strDispKbn & IIf(vntBoldFlg(i)=1, "<B>", "")
'### 2009.10.24 �� ���e�̐܂�Ԃ��\�����ł���悤�ɕύX End   ###
                If vntRsvNo(i) = "" Or vntRsvNo(i) = CStr(lngRsvNo) Then
                    strHtml = strHtml & "<A HREF=""JavaScript:calCommentDetail(" &  i & ")"">"
                    strHtml = strHtml & "<SPAN " & IIf(vntDispColor(i)="","","STYLE=""color: #" & vntDispColor(i) & ";""") & ">" & vntPubNote(i) & "</SPAN>"
                    strHtml = strHtml & "</A>"
                Else
                    '�ߋ���f���m�[�g�͏C���s��
                    strHtml = strHtml & "<SPAN " & IIf(vntDispColor(i)="","","STYLE=""color: #" & vntDispColor(i) & ";""") & ">" & vntPubNote(i) & "</SPAN>"
                End If
                strHtml = strHtml & IIf(vntBoldFlg(i)=1, "</B>", "") & "</TD>"

            Case "�I�y���[�^��"
                strHtml = strHtml & "<TD NOWRAP>" & vntUserName(i) & "</TD>"

            Case "�X�V����"
                strHtml = strHtml & "<TD NOWRAP>" & vntUpdDate(i) & "</TD>"

            Case "��f��"
                strHtml = strHtml & "<TD NOWRAP>" & vntCslDate(i) & "</TD>"

            Case "�R�[�X"
                strHtml = strHtml & "<TD NOWRAP>" & vntCsName(i) & "</TD>"

            Case "�ΏۃR�����g"
                strHtml = strHtml & "<TD NOWRAP>" & IIf(vntRsvNo(i)="","�l","��f��") & "</TD>"

            End Select
        Next
        Response.Write strHTML
%>
            <INPUT TYPE="hidden" NAME="selInfo" VALUE="<%= vntSelInfo(i) %>">
            <INPUT TYPE="hidden" NAME="seq" VALUE="<%= vntSeq(i) %>">
        </TR>
<%
    Next
%>
    </TABLE>
</FORM>
</BODY>
</HTML>
