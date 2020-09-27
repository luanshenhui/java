<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���@�m�F  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const RAIIN_OPTMAX = 3					'�I�v�V�������̂P�s������̕\���ő吔
Const BASEINFO_GRPCD = "X039"			'��{���@�������ڃO���[�v�R�[�h
Const IMGFILE_PATH = "../../images/"	'�C���[�W�t�@�C����PATH��

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f�N���X
Dim objFree				'�ėp���A�N�Z�X�p
Dim objPubNote			'�m�[�g�N���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p
Dim objPerResult		'�l�������ʏ��A�N�Z�X�p

'### 2014.04.08 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
Dim objOrganization     '�c�̏��A�N�Z�X�p
'### 2014.04.08 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###

'�p�����[�^
Dim lngRsvNo			'�\��ԍ�
Dim strReceiptFlg		'��t�t���O(��t���͉�ʂ���̋N��=1)

'���@���p�ϐ�
Dim vntCancelFlg		'�L�����Z���t���O
Dim vntCslDate			'��f��
Dim vntPerId			'�lID
Dim vntCsCd				'�R�[�X�R�[�h
Dim vntOrgCd1			'��f���c�̃R�[�h1
Dim vntOrgCd2			'��f���c�̃R�[�h2
Dim vntRsvGrpCd			'�\��Q�R�[�h
Dim vntRsvDate			'�\���
Dim vntAge				'��f���N��
Dim vntCtrPtCd			'�_��p�^�[���R�[�h
Dim vntIsrSign			'�ی��؋L��
Dim vntIsrNo			'�ی��ؔԍ�
Dim vntReportAddrDiv	'���я�����
Dim vntReportOurEng		'���я��p���o��
Dim vntCollectTicket	'���p�����
Dim vntIssueCslTicket	'�f�@�����s
Dim vntBillPrint		'�������o��
Dim vntVolunteer		'�{�����e�B�A
Dim vntVolunteerName	'�{�����e�B�A��
Dim vntDayID			'����ID
Dim vntComeDate			'���@����
Dim vntComeUser			'���@������
Dim vntOcrNo			'OCR�ԍ�
Dim vntLockerKey		'���b�J�[�L�[
Dim vntBirth			'���N����
Dim vntGender			'����
Dim vntLastName			'��
Dim vntFirstName		'��
Dim vntLastKName		'�J�i��
Dim vntFirstKName		'�J�i��
Dim vntRomeName			'���[�}����
Dim vntNationCd			'���ЃR�[�h
Dim vntNationName		'���Ж�
Dim vntCompPerId		'�����ҌlID
Dim vntCompPerName		'�����Ҍl��
Dim vntCsName			'�R�[�X��
Dim vntCsSName			'�R�[�X����
Dim vntOrgKName			'�c�̃J�i����
Dim vntOrgName			'�c�̊�������
Dim vntOrgSName			'�c�̗���
Dim vntTicket			'���p��
Dim vntInsBring			'�ی��ؓ������Q
Dim vntRsvGrpName		'�\��Q����
Dim vntRsvGrpStrTime	'�\��Q�J�n����
Dim vntRsvGrpEndTime	'�\��Q�I������

'��f�I�v�V�����Ǘ����
Dim vntOptCd			'�I�v�V�����R�[�h
Dim vntOptBranchNo		'�I�v�V�����}��
Dim vntOptSName			'�I�v�V��������
Dim vntSetColor			'�Z�b�g�J���[
Dim lngOptCnt			'��f�I�v�V�����Ǘ����̎擾����
Dim strArrOptInfo		'�I�v�V�������i�R�����܂�Ԃ����߁j
DIm lngOptRow			'�I�v�V�������̕\���s��

'�m�[�g���
Dim vntSeq				'seq
Dim vntPubNoteDivCd		'��f���m�[�g���ރR�[�h
Dim vntPubNoteDivName	'��f���m�[�g���ޖ���
Dim vntDefaultDispKbn	'�\���Ώۋ敪�����l
Dim vntOnlyDispKbn		'�\���Ώۋ敪���΂�
Dim vntDispKbn			'�\���Ώۋ敪
Dim vntUpdDate			'�o�^����
Dim vntUpdUser			'�o�^��
Dim vntUserName			'�o�^�Җ�
Dim vntBoldFlg			'�����敪
Dim vntPubNote			'�m�[�g
Dim vntDispColor		'�\���F
Dim lngPubNoteCount		'�R�����g��
'�m�[�g���(�c��)
Dim vntOrgSeq				'seq
Dim vntOrgPubNoteDivCd		'��f���m�[�g���ރR�[�h
Dim vntOrgPubNoteDivName	'��f���m�[�g���ޖ���
Dim vntOrgDefaultDispKbn	'�\���Ώۋ敪�����l
Dim vntOrgOnlyDispKbn		'�\���Ώۋ敪���΂�
Dim vntOrgDispKbn			'�\���Ώۋ敪
Dim vntOrgUpdDate			'�o�^����
Dim vntOrgUpdUser			'�o�^��
Dim vntOrgUserName			'�o�^�Җ�
Dim vntOrgBoldFlg			'�����敪
Dim vntOrgPubNote			'�m�[�g
Dim vntOrgDispColor			'�\���F
Dim lngOrgPubNoteCount		'�R�����g��
'�m�[�g���(�_��)
Dim vntCtrSeq				'seq
Dim vntCtrPubNoteDivCd		'��f���m�[�g���ރR�[�h
Dim vntCtrPubNoteDivName	'��f���m�[�g���ޖ���
Dim vntCtrDefaultDispKbn	'�\���Ώۋ敪�����l
Dim vntCtrOnlyDispKbn		'�\���Ώۋ敪���΂�
Dim vntCtrDispKbn			'�\���Ώۋ敪
Dim vntCtrUpdDate			'�o�^����
Dim vntCtrUpdUser			'�o�^��
Dim vntCtrUserName			'�o�^�Җ�
Dim vntCtrBoldFlg			'�����敪
Dim vntCtrPubNote			'�m�[�g
Dim vntCtrDispColor			'�\���F
Dim lngCtrPubNoteCount		'�R�����g��

'���A��l���
Dim strArrCslDate       '��f���̔z��
Dim strArrSeq           '���A��lSeq�̔z��
Dim strArrRsvNo         '�\��ԍ��̔z��
Dim strArrSameGrp1      '�ʐړ�����f�P�̔z��
Dim strArrSameGrp2      '�ʐړ�����f�Q�̔z��
Dim strArrSameGrp3      '�ʐړ�����f�R�̔z��
Dim strArrPerId         '�lID�̔z��
Dim strArrCsName        '�R�[�X���̔z��
Dim strArrOrgSName      '�c�̖��̂̔z��
Dim strArrLastName      '���̔z��
Dim strArrFirstName     '���̔z��
Dim strArrLastKName     '�J�i���̔z��
Dim strArrFirstKName    '�J�i���̔z��
Dim strArrName          '�����̔z��
Dim strArrKName         '�J�i�����̔z��
Dim strArrRsvGrpName    '�\��Q���̂̔z��
Dim lngFriendsCnt       '���A��l���̎擾����

'��f�����
Dim vntHisCslDate       '��f��
Dim vntHisCsCd          '�R�[�X�R�[�h
Dim vntHisCsName        '�R�[�X��
Dim vntHisCsSName       '�R�[�X����
Dim lngHisCount         '�\����

'�l�������ڏ��p�ϐ�
Dim vntItemCd           '�������ڃR�[�h
Dim vntSuffix           '�T�t�B�b�N�X
Dim vntItemName         '�������ږ�
Dim vntResult           '��������
Dim vntResultType       '���ʃ^�C�v
Dim vntItemType         '���ڃ^�C�v
Dim vntStcItemCd        '���͎Q�Ɨp���ڃR�[�h
Dim vntStcCd            '���̓R�[�h
Dim vntShortStc         '���͗���
Dim vntIspDate          '������
Dim vntImageFileName    '�C���[�W�t�@�C����
Dim lngPerRslCount      '�l�������ڏ��

Dim strUpdUser          '�X�V��

Dim strEraBirth         '���N����(�a��)
Dim strRealAge          '���N��

Dim Ret                 '�֐��߂�l
Dim lngCount            '�擾����
Dim strHtml             'HTML������
Dim i, j                '�J�E���^

'### 2014.04.08 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
Dim strHighLight    ' �c�̖��̃n�C���C�g�\���敪
'### 2014.04.08 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")
Set objPerResult    = Server.CreateObject("HainsPerResult.PerResult")
'### 2014.04.08 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
'### 2014.04.08 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###


'�����l�̎擾
lngRsvNo            = Request("rsvno")
strReceiptFlg       = Request("receiptflg")

strUpdUser          = Session("USERID")

Do
    '���@��񌟍�
    Ret = objConsult.SelectWelComeInfo(lngRsvNo, _
                                        vntCancelFlg,       _
                                        vntCslDate,         _
                                        vntPerId,           _
                                        vntCsCd,            _
                                        vntOrgCd1,          _
                                        vntOrgCd2,          _
                                        vntRsvGrpCd,        _
                                        vntRsvDate,         _
                                        vntAge,             _
                                        vntCtrPtCd,         _
                                        vntIsrSign,         _
                                        vntIsrNo,           _
                                        vntReportAddrDiv,   _
                                        vntReportOurEng,    _
                                        vntCollectTicket,   _
                                        vntIssueCslTicket,  _
                                        vntBillPrint,       _
                                        vntVolunteer,       _
                                        vntVolunteerName,   _
                                        vntDayID,           _
                                        vntComeDate,        _
                                        vntComeUser,        _
                                        vntOcrNo,           _
                                        vntLockerKey,       _
                                        vntBirth,           _
                                        vntGender,          _
                                        vntLastName,        _
                                        vntFirstName,       _
                                        vntLastKName,       _
                                        vntFirstKName,      _
                                        vntRomeName,        _
                                        vntNationCd,        _
                                        vntNationName,      _
                                        vntCompPerId,       _
                                        vntCompPerName,     _
                                        vntCsName,          _
                                        vntCsSName,         _
                                        vntOrgKName,        _
                                        vntOrgName,         _
                                        vntOrgSName,        _
                                        vntTicket,          _
                                        vntInsBring,        _
                                        vntRsvGrpName,      _
                                        vntRsvGrpStrTime,   _
                                        vntRsvGrpEndTime    _
                                    )
    If Ret = False Then
        Err.Raise 1000, , "���@��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
    End If

    '��f�I�v�V�����Ǘ���񌟍�
    lngOptCnt = objConsult.SelectConsult_O(	lngRsvNo,		_
                                            vntOptCd,		_
                                            vntOptBranchNo,	_
                                            , ,				_
                                            vntOptSName,	_
                                            vntSetColor,	_
                                            3 _
                                            )
    If lngOptCnt < 0 Then
        Err.Raise 1000, , "��f�I�v�V�����Ǘ���񂪎擾�ł��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
    End If

    '�I�v�V�������̕\���s��
    lngOptRow = IIf(lngOptCnt=0,0,INT((lngOptCnt - 1) / RAIIN_OPTMAX))
    strArrOptInfo = Array()
    Redim strArrOptInfo(lngOptRow)

    For i=0 To lngOptRow
        strArrOptinfo(i) = ""
        For j=0 To RAIIN_OPTMAX - 1 
            If j > 0 Then
                strArrOptInfo(i) = strArrOptInfo(i) & "<TD NOWRAP>�@</TD>" & vbLf
            End If
            If ( i * RAIIN_OPTMAX + j ) < lngOptCnt Then
                strArrOptInfo(i) = strArrOptInfo(i) & "<TD NOWRAP><FONT COLOR=""" & vntSetColor(i * RAIIN_OPTMAX + j) & """>��</FONT>" & vntOptSName(i * RAIIN_OPTMAX + j) & "</TD>" & vbLf
            Else
                strArrOptInfo(i) = strArrOptInfo(i) & "<TD NOWRAP>�@</TD>" & vbLf
            End If
        Next
    Next

    '���A��l�����擾�i���A��l�����Ȃ��ꍇ���������g�̏��͕Ԃ��Ă���̂Œ��Ӂj
    lngFriendsCnt = objConsult.SelectFriends(	vntCslDate, _
                                                lngRsvNo, _
                                                strArrCslDate,    _
                                                strArrSeq,        _
                                                strArrRsvNo,      _
                                                strArrSameGrp1,   _
                                                strArrSameGrp2,   _
                                                strArrSameGrp3,   _
                                                strArrPerId,      _
                                                , _
                                                strArrCsName,     _
                                                , , , _
                                                strArrOrgSName,   _
                                                strArrLastName,   _
                                                strArrFirstName,  _
                                                strArrLastKName,  _
                                                strArrFirstKName, _
                                                , _
                                                strArrRsvGrpName  _
                                                )
    If lngFriendsCnt < 0 Then
        Err.Raise 1000, , "���A��l��񂪑��݂��܂���B�i��f��= " & vntCslDate & " �\��ԍ�= " & lngRsvNo & " )"
    End If


    '���N����(����{�a��)�̕ҏW
    strEraBirth = objCommon.FormatString(CDate(vntBirth), "ge�iyyyy�j.m.d")

    '���N��̌v�Z
    If vntBirth <> "" Then
        Set objFree = Server.CreateObject("HainsFree.Free")
        strRealAge = objFree.CalcAge(vntBirth)
        Set objFree = Nothing
    Else
        strRealAge = ""
    End If

    '�����_�ȉ��̐؂�̂�
    If IsNumeric(strRealAge) Then
        strRealAge = CStr(Int(strRealAge))
    End If


    '�m�[�g���̎擾
    lngPubNoteCount = objPubNote.SelectPubNote(	0, 0, _
                                                "", "", _
                                                lngRsvNo, _
                                                "", "", "", "",  _
                                                0, "", 0, _
                                                strUpdUser, _
                                                vntSeq, _
                                                vntPubNoteDivCd, _
                                                vntPubNoteDivName, _
                                                vntDefaultDispKbn, _
                                                vntOnlyDispKbn, _
                                                vntDispKbn, _
                                                vntUpdDate, _
                                                vntUpdUser, _
                                                vntUserName, _
                                                vntBoldFlg, _
                                                vntPubNote, _
                                                vntDispColor _
                                                )
    If lngPubNoteCount < 0 Then
        Err.Raise 1000, , "�m�[�g��񂪑��݂��܂���B"
    End If

    '�m�[�g���̎擾(�c��)
    lngOrgPubNoteCount = objPubNote.SelectPubNote(	3, 0, _
                                                "", "", _
                                                lngRsvNo, _
                                                "", "", "", "",  _
                                                0, "", 0, _
                                                strUpdUser, _
                                                vntOrgSeq, _
                                                vntOrgPubNoteDivCd, _
                                                vntOrgPubNoteDivName, _
                                                vntOrgDefaultDispKbn, _
                                                vntOrgOnlyDispKbn, _
                                                vntOrgDispKbn, _
                                                vntOrgUpdDate, _
                                                vntOrgUpdUser, _
                                                vntOrgUserName, _
                                                vntOrgBoldFlg, _
                                                vntOrgPubNote, _
                                                vntOrgDispColor _
                                                )
    If lngOrgPubNoteCount < 0 Then
        Err.Raise 1000, , "�m�[�g��񂪑��݂��܂���B"
    End If

    '�m�[�g���̎擾(�_��)
    lngCtrPubNoteCount = objPubNote.SelectPubNote(	4, 0, _
                                                "", "", _
                                                lngRsvNo, _
                                                "", "", "", "",  _
                                                0, "", 0, _
                                                strUpdUser, _
                                                vntCtrSeq, _
                                                vntCtrPubNoteDivCd, _
                                                vntCtrPubNoteDivName, _
                                                vntCtrDefaultDispKbn, _
                                                vntCtrOnlyDispKbn, _
                                                vntCtrDispKbn, _
                                                vntCtrUpdDate, _
                                                vntCtrUpdUser, _
                                                vntCtrUserName, _
                                                vntCtrBoldFlg, _
                                                vntCtrPubNote, _
                                                vntCtrDispColor _
                                                )
    If lngCtrPubNoteCount < 0 Then
        Err.Raise 1000, , "�m�[�g��񂪑��݂��܂���B"
    End If

    '�w�肳�ꂽ�\��ԍ��̎�f���ꗗ���擾����
    lngHisCount = objInterView.SelectConsultHistory( lngRsvNo, _
                                                    False, _
                                                    0, _
                                                    "", _
                                                    2, _
                                                    0, _
                                                    , _
                                                    , _
                                                    vntHisCslDate, _
                                                    vntHisCsCd, _
                                                    vntHisCsName, _
                                                    vntHisCsSName _
                                                    )
    If lngHisCount < 1 Then
        Err.Raise 1000, , "��f�����擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
    End If


    '�l�������ʏ��擾
    lngPerRslCount = objPerResult.SelectPerResultGrpList( vntPerId, _
                                                        BASEINFO_GRPCD, _
                                                        2, 0, _
                                                        vntItemCd, _
                                                        vntSuffix, _
                                                        vntItemName, _
                                                        vntResult, _
                                                        vntResultType, _
                                                        vntItemType, _
                                                        vntStcItemCd, _
                                                        vntShortStc, _
                                                        vntIspDate, _
                                                        vntImageFileName _
                                                        )
    If lngPerRslCount < 0 Then
        Err.Raise 1000, , "�l�������ʏ�񂪑��݂��܂���B�i�lID= " & vntPerId & " )"
    End If


    '### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
    objOrganization.SelectOrg_Lukes vntOrgCd1, vntOrgCd2,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,strHighLight
    '### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###


    '�I�u�W�F�N�g�̃C���X�^���X�폜
    Set objConsult = Nothing
    Set objPubNote = Nothing
    Set objInterView = Nothing
    Set objPerResult = Nothing

    Set objOrganization = Nothing

    Exit Do
Loop
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>���@�m�F���</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winWelComeInfo;

// �E�B���h�E���J��
function Guide_openWindow(guideNo) {

    var opened = false;	// ��ʂ��J����Ă��邩
    var url;

    // ����t�̂Ƃ��̓E�B���h�E��\�����Ȃ�
    if ( '<%= vntDayID %>' == '' ) {
        alert( '����t�̂Ƃ��͐ݒ�ł��܂���' );
        return;
    }

    // ���łɃK�C�h���J����Ă��邩�`�F�b�N
    if ( winWelComeInfo ) {
        if ( !winWelComeInfo.closed ) {
            opened = true;
        }
    }

    url = '/WebHains/contents/raiin/EditWelComeInfo.asp';
    url = url + '?rsvno=' + '<%= lngRsvNo %>';
    url = url + '&mode=' + guideNo;

    // �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
    if ( opened ) {
        winWelComeInfo.focus();
        winWelComeInfo.location.replace( url );
    } else {
// ## 2004.10.15 Mod By T.Takagi@FSIT �U���L�����Z���@�\����
//		winWelComeInfo = window.open( url, '', 'width=450,height=180,status=no,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
        winWelComeInfo = window.open( url, '', 'width=450,height=220,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
// ## 2004.10.15 Mod End
    }

}

// �E�B���h�E�����
function windowClose() {

    // ���@���ݒ��ʂ����
    if ( winWelComeInfo != null ) {
        if ( !winWelComeInfo.closed ) {
            winWelComeInfo.close();
        }
    }

    winWelComeInfo = null;
}

// �L�[�������̏���
function Key_Press(){

    // Space�L�[
    if ( event.keyCode == 32 ) {

        // ���b�J�[�L�[�ݒ�E�B���h�E���J��
        Guide_openWindow(4);

        event.keyCode = 0;
    }

    return;
}

// ���b�J�[�L�[��ݒ肵���Ƃ�
function setLockerKey() {

    // ��t���͉�ʂ���̋N�����̓E�B���h�E�����
    if( document.entryForm.receiptflg.value == '1' ) {
        if( opener != null) {
            opener.nextReceipt();
        }
    }
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>

<BODY BGCOLOR="#ffffff" ONUNLOAD="javascript:windowClose()" ONKEYPRESS="JavaScript:Key_Press()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
    <!-- �����l -->
    <INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="receiptflg" VALUE="<%= strReceiptFlg %>">

    <!-- �^�C�g���̕\�� -->
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">���@�m�F</FONT></B></TD>
        </TR>
    </TABLE>

    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
        </TR>
        <TR VALIGN="middle">
            <TD NOWRAP><A HREF="javascript:Guide_openWindow(1)"><IMG SRC="../../images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
            <TD NOWRAP>�����h�c</TD>
            <TD NOWRAP>�F</TD>
            <TD NOWRAP><FONT SIZE="7" COLOR="#ff6600"><B><%= IIf(vntDayID="", "����t", objCommon.FormatString(vntDayID, "0000")) %></B></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
        </TR>
        <TR VALIGN="middle">
            <TD NOWRAP>��f��</TD>
            <TD NOWRAP>�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntCslDate %></B></FONT></TD>
            <TD NOWRAP WIDTH="10"></TD>
            <TD NOWRAP>�\��ԍ�</TD>
            <TD NOWRAP>�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
            <TD NOWRAP WIDTH="10"></TD>
            <TD NOWRAP>�\��Q</TD>
            <TD NOWRAP>�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntRsvGrpName %></B></FONT></TD>
            <TD NOWRAP WIDTH="10"></TD>
            <TD NOWRAP>���@���</TD>
            <TD NOWRAP>�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= IIf(vntComeDate="", "�����@", "���@�ς�") %></B></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="600">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="100%" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR VALIGN="middle">
            <TD NOWRAP><%= vntPerId %></TD>
            <TD WIDTH="10"></TD>
            <TD NOWRAP>
                <A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= vntPerId %>" TARGET="_blank">
                    <B><%= vntLastName & "�@" & vntFirstName %></B>
                </A>
                <FONT COLOR="#999999"> (</FONT><FONT SIZE="-1" COLOR="#999999"><%= vntLastKName & "�@" & vntFirstKName %></FONT><FONT COLOR="#999999">)</FONT>
                <FONT COLOR="#999999">�@�@<%= vntRomeName %></FONT>
            </TD>
            <TD WIDTH="100%"><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR VALIGN="middle">
<%
    strHtml = ""
    Select Case vntIssueCslTicket
'### 2004/01/22 Updated by Ishihara@FSIT �R�[�h�ݒ肪�S�R�Ⴄ
'	Case "1"
'		strHtml = "����"
'	Case "2"
'		strHtml = "�Ĕ��s"
'	Case "3"
'		strHtml = "�V�K"
    Case "1"
        strHtml = "�V�K"
    Case "2"
        strHtml = "����"
    Case "3"
        strHtml = "�Ĕ��s"
'### 2004/01/22 Updated End
    End Select
%>
            <TD COLSPAN="2" NOWRAP>�f�@���F<FONT COLOR="green"><B><%= strHtml %></B></FONT></TD>
            <TD NOWRAP><%= strEraBirth %>���@<%= strRealAge %>�΁i<%= Int(vntAge) %>�΁j�@<%= IIf(vntGender = "1", "�j��", "����") %></TD>
        </TR>
        <TR HEIGHT="15">
            <TD COLSPAN="4" NOWRAP ALIGN="right">
                <TABLE WIDTH="80" BORDER="2" CELLSPACING="2" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP><A HREF="javascript:Guide_openWindow(4)">���b�J�[�L�[�����</A></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">��f�R�[�X</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><B><FONT COLOR="#ff6600"><%= vntCsName %></FONT></B></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�I�v�V����</TD>
            <TD NOWRAP></TD>
            <%= strArrOptInfo(0) %>
        </TR>
<%
    For i=1 To lngOptRow
%>
        <TR>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <%= strArrOptInfo(i) %>
        </TR>
<%
    Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP bgcolor="#eeeeee">�c�̖�</TD>
            <TD NOWRAP></TD>

<%      If strHighLight = "1" Then  %>
            <TD NOWRAP>
                <FONT style='font-weight:bold; background-color:#00FFFF;'><B><%= vntOrgName %></B></FONT>
                <FONT style='font-weight:bold; background-color:#00FFFF; color:#999999'>�i<%= vntOrgKName %>�j</FONT>
            </TD>
<%      Else                        %>
            <TD NOWRAP><%= vntOrgName %><FONT COLOR="#999999">�i<%= vntOrgKName %>�j</FONT></TD>
<%      End If                      %>

        </TR>
        </TR></TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">���p���L��</TD>
            <TD NOWRAP>�@</TD>
            <TD NOWRAP><%= IIf(vntTicket="1", "����", "�Ȃ�") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�ی��ؗL��</TD>
            <TD NOWRAP>�@</TD>
            <TD NOWRAP><%= IIf(vntInsBring="1", "����", "�Ȃ�") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�{�l/�Ƒ�</TD>
            <TD NOWRAP></TD>
<%
    strHtml = ""
    Select Case vntBillPrint
    Case "1"
        strHtml = "�{�l"
    Case "2"
        strHtml = "�Ƒ�"
    End Select
%>
            <TD NOWRAP><%= strHtml %></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">����ς�</TD>
            <TD NOWRAP>�@</TD>
            <TD NOWRAP><%= IIf(vntCollectTicket="", "�����", "�ς�") %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�ی��؋L��</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntIsrSign %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">���ѕ\����</TD>
            <TD NOWRAP></TD>
<%
    strHtml = ""
    Select Case vntReportAddrDiv
    Case "1"
        strHtml = "�Z���i����j"
    Case "2"
        strHtml = "�Z���i��Ёj"
    Case "3"
        strHtml = "�Z���i���̑��j"
    End Select
%>
            <TD NOWRAP><%= strHtml %></TD>
        </TR>
        <TR>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�ی��ؔԍ�</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntIsrNo %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">���ѕ\�p���o��</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP WIDTH="92"><%= IIf(vntReportOurEng="1", "����", "�Ȃ�") %></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR BGCOLOR="#eeeeee">
            <TD WIDTH="450">�c�̃R�����g</TD>
            <TD WIDTH="150">�I�y���[�^��</TD>
        </TR>
<%
    For i=0 To lngOrgPubNoteCount-1
%>
        <TR VALIGN="top" BGCOLOR="#ffffff">
            <TD NOWRAP>
                <%= IIf(vntOrgBoldFlg(i)=1, "<B>", "") %>
                <SPAN <%= IIf(vntOrgDispColor(i)="","","STYLE=""color: #" & vntOrgDispColor(i) & ";""") %>> <%= vntOrgPubNote(i) %></SPAN>
                <%= IIf(vntOrgBoldFlg(i)=1, "</B>", "") %>
            </TD>
            <TD NOWRAP><%= vntOrgUserName(i) %></TD>
        </TR>
<%
    Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR BGCOLOR="#eeeeee">
            <TD WIDTH="450">�_��R�����g</TD>
            <TD WIDTH="150">�I�y���[�^��</TD>
        </TR>
<%
    For i=0 To lngCtrPubNoteCount-1
%>
        <TR VALIGN="top" BGCOLOR="#ffffff">
            <TD NOWRAP>
                <%= IIf(vntCtrBoldFlg(i)=1, "<B>", "") %>
                <SPAN <%= IIf(vntCtrDispColor(i)="","","STYLE=""color: #" & vntCtrDispColor(i) & ";""") %>> <%= vntCtrPubNote(i) %></SPAN>
                <%= IIf(vntCtrBoldFlg(i)=1, "</B>", "") %>
            </TD>
            <TD NOWRAP><%= vntCtrUserName(i) %></TD>
        </TR>
<%
    Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR BGCOLOR="#eeeeee">
            <TD WIDTH="450">�l�R�����g</TD>
            <TD WIDTH="150">�I�y���[�^��</TD>
        </TR>
<%
    For i=0 To lngPubNoteCount-1
%>
        <TR VALIGN="top" BGCOLOR="#ffffff">
            <TD NOWRAP>
                <%= IIf(vntBoldFlg(i)=1, "<B>", "") %>
                <SPAN <%= IIf(vntDispColor(i)="","","STYLE=""color: #" & vntDispColor(i) & ";""") %>> <%= vntPubNote(i) %></SPAN>
                <%= IIf(vntBoldFlg(i)=1, "</B>", "") %>
            </TD>
            <TD NOWRAP><%= vntUserName(i) %></TD>
        </TR>
<%
    Next
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">�{�����e�B�A</TD>
            <TD NOWRAP></TD>
<%
    Select Case vntVolunteer
    Case "0"
        strHtml = "���p�Ȃ�"
    Case "1"
        strHtml = "�ʖ�v"
    Case "2"
        strHtml = "���v"
    Case "3"
        strHtml = "�ʖ󁕉��v"
    Case "4"
        strHtml = "�Ԉ֎q�v"
    Case Else
        strHtml = ""
    End Select
%>
            <TD NOWRAP><%= strHtml %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">���@�����S��</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntComeUser %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee" WIDTH="88">�n�b�q�ԍ�</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntOcrNo %></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">�{�����e�B�A��</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntVolunteerName %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">���@����</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntComeDate %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee" WIDTH="88">���b�J�[�L�[</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntLockerKey %></TD>
        </TR>
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee">����</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= vntNationName %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP BGCOLOR="#eeeeee">�ē����ԍ�</TD>
            <TD NOWRAP></TD>
            <TD NOWRAP><%= lngRsvNo %></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
            <TD NOWRAP></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR BGCOLOR="#eeeeee">
            <TD WIDTH="60"><IMG SRC="../../images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
            <TD NOWRAP>�l�h�c</TD>
            <TD WIDTH="170">����</TD>
            <TD NOWRAP>�\��ԍ�</TD>
            <TD WIDTH="150">��f�c��</TD>
            <TD WIDTH="100">��f�R�[�X</TD>
            <TD WIDTH="100">�\��Q</TD>
        </TR>
<%
    strHtml = ""
    'i=0�͎������g�Ȃ̂ŏ���
    For i = 1 To lngFriendsCnt - 1
        strHtml = strHtml & "<TR>"
        If strArrPerId(i) = vntCompPerId Then
            strHtml = strHtml & "<TD NOWRAP>������</TD>"
        Else
            strHtml = strHtml & "<TD NOWRAP>���A��l</TD>"
        End If
        strHtml = strHtml & "<TD NOWRAP>" & strArrPerId(i) & "</TD>"
        strHtml = strHtml & "<TD NOWRAP>" & strArrLastName(i) & "�@" & strArrFirstName(i) & "�i<SPAN STYLE=""font-size:9px;""><B>" & strArrLastKName(i) & "�@" & strArrFirstKName(i) & "</B></SPAN>�j</TD>"
        strHtml = strHtml & "<TD NOWRAP><A HREF=""../Reserve/rsvMain.asp?rsvNo=" & strArrRsvNo(i) & """ TARGET=""_blank"">" & strArrRsvNo(i) & "</A></TD>"
        strHtml = strHtml & "<TD NOWRAP>" & strArrOrgSName(i) & "</TD>"
        strHtml = strHtml & "<TD NOWRAP>" & strArrCsName(i) & "</TD>"
        strHtml = strHtml & "<TD NOWRAP>" & strArrRsvGrpName(i) & "</TD>"
        strHtml = strHtml & "</TR>"
    Next
    Response.Write strHtml
%>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
        </TR>
        <TR>
            <TD NOWRAP>�O���f��</TD>
            <TD NOWRAP>�F</TD>
<%
    If lngHisCount = 2 Then
%>
            <TD NOWRAP><%= vntHisCslDate(1) %>�@�@<%= vntHisCsName(1) %></TD>
<%
    Else
%>
            <TD NOWRAP>�@</TD>
<%
    End If
%>
        </TR>
        <TR>
            <TD NOWRAP>�g�̏��</TD>
            <TD NOWRAP>�F</TD>
            <TD NOWRAP>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
<%
    For i=0 To lngPerRslCount-1
        If vntImageFileName(i) <> "" Then
%>
                        <TD BGCOLOR="#eeeeee"><IMG SRC="<%= IMGFILE_PATH & vntImageFileName(i) %>" ALT="<%= vntItemName(i) %>" HEIGHT="22" WIDTH="22" BORDER="0"></TD>
<%
        End If
    Next
%>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE WIDTH="180" BORDER="1" CELLSPACING="2" CELLPADDING="3">
        <TR>
            <TD NOWRAP><A HREF="javascript:Guide_openWindow(2)">���@���C��</A></TD>
            <TD NOWRAP><A HREF="javascript:Guide_openWindow(3)">OCR�ԍ��C��</A></TD>
            <TD NOWRAP><A HREF="/webHains/contents/result/rslMain2.asp?rsvno=<%= lngRsvNo %>&code=X064&NoReceipt=1" TARGET="_blank">��]��t����</A></TD>
        </TR>
    </TABLE>
</FORM>
</BODY>
</HTML>
