<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ʐڏ��̓o�^(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objAfterCare		'�A�t�^�[�P�A�p

Dim strMode				'�������[�h
Dim strActMode			'���샂�[�h
Dim strDisp				'�\�����[�h
Dim strPerId			'�l�h�c
Dim strContactDate		'�ʐړ�
Dim strUserId			'���[�U�h�c
Dim strRsvNo			'�\��ԍ�

'�A�t�^�[�P�A���
Dim strArrContactDate	'�ʐړ�
Dim strArrUserId		'���[�U�h�c
Dim strArrRsvNo			'�\��ԍ�
Dim Ret					'�֐��߂�l

Dim strContactYear		'�N�x
Dim strURL				'URL������
Dim strHedderUrl		'�w�b�_��URL
Dim strCareUrl			'�Ǘ����ڂ�URL
Dim strDetail			'�ڍׂ�URL

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strMode        = Request("mode")
strActMode     = Request("actMode")
strDisp        = Request("disp")
strPerId       = Request("perId")
strContactDate = Request("contactDate")
strUserId      = Request("userId")
strRsvNo       = Request("rsvNo")

'�������[�h�w�莞
If strMode <> "" Then

	'�N�x�̎Z�o
	strContactYear = Year(strContactDate) - IIf(Month(strContactDate) < 4, 1, 0)

	'�w�b�_��URL�ҏW
	strHedderUrl = "/webHains/contents/aftercare/AfterCareHedder.asp"
	strHedderUrl = strHedderUrl & "?mode="        & strMode
	strHedderUrl = strHedderUrl & "&disp="        & strDisp
	strHedderUrl = strHedderUrl & "&perId="       & strPerId
	strHedderUrl = strHedderUrl & "&contactDate=" & strContactDate
	strHedderUrl = strHedderUrl & "&contactYear=" & strContactYear
	strHedderUrl = strHedderUrl & "&userId="      & strUserId
	strHedderUrl = strHedderUrl & "&rsvNo="       & strRsvNo

	If strActMode <> "" Then
		strHedderUrl = strHedderUrl & "&actMode=" & strActMode
	End If

End If

Select Case strMode

	'�V�K��
	Case "NEW"

		'�Ǘ����ځA�ڍׂ�URL�ҏW
		strCareUrl = "/webHains/contents/aftercare/CareItem.asp"
		strCareUrl = strCareUrl & "?rsvNo=" & strRsvNo

		strDetail = "/webHains/contents/aftercare/AfterCareDetails.asp"

	'�X�V��
	Case "REP"

		'�Ǘ����ځA�ڍׂ�URL�ҏW
		strCareUrl = "/webHains/contents/aftercare/CareItem.asp"
		strCareUrl = strCareUrl & "?perId=" & strPerId
		strCareUrl = strCareUrl & "&contactDate=" & strContactDate 

		strDetail = "/webHains/contents/aftercare/AfterCareDetails.asp"
		strDetail = strDetail & "?perId="       & strPerId
		strDetail = strDetail & "&contactDate=" & strContactDate

	'�������[�h���w�莞
	Case Else

		'�w��l�h�c�A�ʐړ��̃A�t�^�[�P�A��񂪑��݂��邩���`�F�b�N
		strArrContactDate = strContactDate
		Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")
		Ret = objAfterCare.SelectAfterCare(strPerId, strArrContactDate, , strArrUserId, strArrRsvNo)

		'URL�̕ҏW
		strURL = Request.ServerVariables("SCRIPT_NAME")
		If Ret <= 0 Then
			strURL = strURL & "?mode="        & "NEW"
			strURL = strURL & "&disp="        & strDisp
			strURL = strURL & "&perId="       & strPerId
			strURL = strURL & "&contactDate=" & strContactDate
			strURL = strURL & "&userId="      & Session("USERID")
			strURL = strURL & "&rsvNo="       & strRsvNo
		Else
			strURL = strURL & "?mode="        & "REP"
			strURL = strURL & "&disp="        & IIf(strArrRsvNo(0) = "", "1", "0")
			strURL = strURL & "&perId="       & strPerId
			strURL = strURL & "&contactDate=" & strContactDate
			strURL = strURL & "&userId="      & strArrUserId(0)
			strURL = strURL & "&rsvNo="       & strArrRsvNo(0)
		End If

		Response.Redirect strURL
		Response.End

End Select
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>�ʐڏ��̓o�^</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// submit����
function submitForm( mode ) {

	var headerForm = header.document.entryForm;				// ���C����ʂ̃t�H�[���G�������g
	var careForm   = CareItem.document.entryForm;			// �����̃t�H�[���G�������g
	var detailForm = AfterCareDetails.document.entryForm;	// ���̑��t�H�[���G�������g
	var i, j;												// �C���f�b�N�X

	arrJudClassCd   = new Array();
	arrGuidanceDiv  = new Array();
	arrContactStcCd = new Array();
	arrSeq   		= new Array();

	// ���샂�[�h��ݒ肷��
	headerForm.actMode.value = mode;

	//  �폜�̎��͏������̕ҏW���s��Ȃ�
	if ( mode != 'DEL' ) {

		// �����̃R�[�h�ҏW
		for ( i = 0; i < careForm.judClassCd.length; i++ ) {
			if ( careForm.judClassCd[ i ].checked == true ) {
				arrJudClassCd[ arrJudClassCd.length ]   = careForm.judClassCd[ i ].value;
			}
		}

		// �擾�����e��R�[�h�����G�������g�ɕҏW����
		// (����ŃJ���}�t���ŕҏW�����)
		headerForm.judClassCd.value  = arrJudClassCd;

		// �w�����e�敪,��^�ʐڕ����R�[�h�̕ҏW
		for ( i = 0 , j = 0; i < detailForm.guidanceDiv.length; i++ ) {
			if ( detailForm.guidanceDiv[ i ].value != '' ) {
				arrGuidanceDiv[ arrGuidanceDiv.length ]   = detailForm.guidanceDiv[ i ].value;
				arrContactStcCd[ arrContactStcCd.length ] = detailForm.contactStcCd[ i ].value;
				arrSeq[ arrSeq.length ] = j;
				j++;
			}
		}

		// �擾�����e��R�[�h�����G�������g�ɕҏW����
		// (����ŃJ���}�t���ŕҏW�����)
		headerForm.judClassCd.value  = arrJudClassCd;
		headerForm.guidanceDiv.value  = arrGuidanceDiv;
		headerForm.contactStcCd.value  = arrContactStcCd;
		headerForm.seq.value  = arrSeq;
		headerForm.judClassCdEtc.value  = careForm.judClassCdEtc.value

		headerForm.bloodPressure_h.value  = detailForm.bloodPressure_h.value
		headerForm.bloodPressure_l.value  = detailForm.bloodPressure_l.value
		headerForm.circumStances.value  = detailForm.circumStances.value
		headerForm.careComment.value  = detailForm.careComment.value

	}
	
	// ���C����ʂ�submit
	headerForm.submit();
}
//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="200,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="0">
	<FRAME SRC="<%= strHedderUrl %>" NAME="header" SCROLLING="auto">
	<FRAMESET COLS="170,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="NO">
		<FRAME SRC="<%= strCareUrl %>" NAME="CareItem"         SCROLLING="auto">
		<FRAME SRC="<%= strDetail %>"  NAME="AfterCareDetails" SCROLLING="auto">
	</FRAMESET>
</FRAMESET>
</HTML>
