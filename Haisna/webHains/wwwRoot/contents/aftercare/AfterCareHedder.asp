<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ʐڏ��̓o�^(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCommon			'���ʃN���X
Dim objAfterCare		'�A�t�^�[�P�A���p
Dim objPerson			'�l���p
Dim objFree				'�ėp���p
Dim objHainsUser		'���[�U�[���p

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Const lngGuidanceDivCount	= 8		'�w�����e�\����
Const strDoctorFlg 			= 1		'����㌟���p�t���O
Const lngCircumMaxCount		= 400	'�ʐڏ󋵍ő啶����
Const lngCareComment		= 400	'���]�ő啶����

Const MESSAGE_SAVE_OK 		= "�ۑ����������܂����B"
Const MESSAGE_PERID_NG 		= "�l�h�c���ݒ肳��Ă��܂���B"
Const MESSAGE_CONTACTDATE_NG 		= "�ʐړ����ݒ肳��Ă��܂���B"
Const MESSAGE_SEQ_NG 		= "�V�[�P���X�m�n���ݒ肳��Ă��܂���B"
Const MESSAGE_DEL_NG 		= "�폜�����Ɏ��s���܂����B"

Dim strArrDisp
strArrDisp = Array("�i����Ǘ��w���j","�i�ی��w���j")

Dim strMode				'�������[�h
Dim strDisp				'�\�����[�h
Dim strPerId			'�l�h�c
Dim strContactDate		'�ʐړ�
Dim strContactYear		'�ʐڔN�x
Dim strUserId			'���[�U�[�h�c
Dim strRsvNo			'�\��ԍ�
Dim strActMode			'���샂�[�h

'�A�t�^�[�P�A�p
Dim strBloodPressure_H 	'�����i���j
Dim strBloodPressure_L	'�����i��j
Dim strCircumStances	'�ʐڏ�
Dim strCareComment		'�R�����g�i���]�j
Dim strJudClassCdEtc	'���蕪�ނ��̑�������
Dim strJudClassCd 		'���蕪�ރR�[�h
Dim strSeq				'�r�d�p�m�n
Dim strGuidanceDiv		'�w�����e�敪
Dim strContactStcCd		'��^�ʐڕ����R�[�h

'�l���
'Dim strPerId			'�l�h�c
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strGender			'����
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h2
Dim strOrgKName			'�c�̃J�i����
Dim strOrgName			'�c�̊�������
Dim strOrgSName			'�c�̗���
Dim strOrgBsdCd			'���Ə��R�[�h
Dim strOrgBsdKName		'���ƕ��J�i����
Dim strOrgBsdName		'���ƕ�����
Dim strOrgRoomCd		'�����R�[�h
Dim strOrgRoomName		'��������
Dim strOrgRoomKName		'�����J�i����
Dim strOrgPostCd		'���������R�[�h
Dim strOrgPostName		'��������
Dim strOrgPostKName		'�����J�i����
Dim strJobName			'�E��
Dim strEmpNo			'�]�ƈ��ԍ�

'�����
Dim strDoctorCd			'��t�R�[�h
Dim strDoctorName		'��t��

Dim strDispPerName		'�l���́i�����j
Dim strDispPerKName		'�l���́i�J�i�j
Dim strDispAge			'�N��i�\���p�j
Dim strDispBirth		'���N�����i�\���p�j
Dim strEditJudClassCd 	'�ҏW�p���蕪�ރR�[�h
Dim strEditGuidanceDiv 	'�w�����e�敪
Dim strEditContactStcCd '��^�ʐڕ��̓R�[�h
Dim strEditSeq			'SEQ

Dim lngAfterCare		'�A�t�^�[�P�A�X�V���ʎ擾�p
Dim strMessage			'�G���[���b�Z�[�W
Dim strArrMessage		'�G���[���b�Z�[�W�i�z��j
Dim strHTML				'HTML������
Dim strURL				'URL������
Dim i					'���[�v�J�E���g

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")
Set objAfterCare	= Server.CreateObject("HainsAfterCare.AfterCare")

strMode				= Request("mode")
strActMode          = Request("actMode")
strDisp				= Request("disp")
strPerId			= Request("perId")
strContactDate		= Request("contactDate")
strContactYear		= Request("contactYear")
strUserId			= Request("userId")
strRsvNo			= Request("rsvNo")
strJudClassCdEtc	= Trim(Request("judClassCdEtc"))
strBloodPressure_H  = Request("bloodPressure_h")
strBloodPressure_L	= Request("bloodPressure_l")
strCircumStances	= Request("circumStances")
strCareComment		= Request("careComment")
strJudClassCd		= Request("judClassCd")
strGuidanceDiv		= Request("guidanceDiv")
strContactStcCd		= Request("contactStcCd")
strJudClassCd		= IIf( strJudClassCd   = "", Empty, ConvIStringToArray(strJudClassCd)   )
strGuidanceDiv		= IIf( strGuidanceDiv  = "", Empty, ConvIStringToArray(strGuidanceDiv)  )
strContactStcCd		= IIf( strContactStcCd = "", Empty, ConvIStringToArray(strContactStcCd) )
strSeq				= IIf( strSeq          = "", Empty, ConvIStringToArray(strSeq)          )

If Not IsEmpty(strJudClassCd) Then
	strEditJudClassCd = Join(strJudClassCd, ",")
End If

If Not IsEmpty(strGuidanceDiv) Then
	strEditGuidanceDiv = Join(strGuidanceDiv, ",")
End If

If Not IsEmpty(strContactStcCd) Then
	strEditContactStcCd	= Join(strContactStcCd, ",")
End If

If Not IsEmpty(strSeq) Then
	strEditSeq = Join(strSeq, ",")
End If

Do

	Select Case strActMode

		'�}���E�X�V��
		Case "INS", "UPD"

			'�f�[�^�`�F�b�N

			'�l�h�c
			If( strPerId = "" ) Then
				objCommon.AppendArray strArrMessage, MESSAGE_PERID_NG
			End If
		
			'�ʐړ�
			If( strContactDate = "" ) Then
				objCommon.AppendArray strArrMessage, MESSAGE_CONTACTDATE_NG
			End If

			'����(��)
			Do
				If strBloodPressure_H = "" Then
					Exit Do
				End If
		
				'���l�łȂ���΃G���[
				If Not IsNumeric(strBloodPressure_H) Then
					objCommon.AppendArray strArrMessage, "����(��)�ɂ͐��l����͂��Ă��������B"
					Exit Do
				End If
		
				'���������R���𒴂���΃G���[
				If Len(CStr(Int(Abs(CDbl(strBloodPressure_H))))) > 3 Then
					objCommon.AppendArray strArrMessage, "����(��)�̌����Ɍ�肪����܂��B"
				End If
		
				Exit Do
			Loop

			'����(��)
			Do

				If strBloodPressure_L = "" Then
					Exit Do
				End If
		
				'���l�łȂ���΃G���[
				If Not IsNumeric(strBloodPressure_L) Then
					objCommon.AppendArray strArrMessage, "����(��)�ɂ͐��l����͂��Ă��������B"
					Exit Do
				End If
		
				'���������R���𒴂���΃G���[
				If Len(CStr(Int(Abs(CDbl(strBloodPressure_L))))) > 3 Then
					objCommon.AppendArray strArrMessage, "����(��)�̌����Ɍ�肪����܂��B"
				End If
		
				Exit Do
			Loop

			'���̑����蕪��
			objCommon.AppendArray strArrMessage, objCommon.CheckWideValue("���̑����͗�", Trim(strJudClassCdEtc), 20)

			'�ʐڏ�
			strMessage = objCommon.CheckWideValue("�ʐڏ�", Trim(strCircumStances), lngCircumMaxCount)
			If strMessage <> "" Then
				objCommon.AppendArray strArrMessage, strMessage & "�i���s�������܂݂܂��j"
			End If

			'���]
			strMessage = objCommon.CheckWideValue("���]", Trim(strCareComment), lngCareComment)
			If strMessage <> "" Then
				objCommon.AppendArray strArrMessage, strMessage & "�i���s�������܂݂܂��j"
			End If

			'�G���[���͏����𔲂���
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'�A�t�^�[�P�A���̓o�^
			lngAfterCare = objAfterCare.RegistAfterCare( _
											 strActMode, _
											 strPerId, _
											 strContactDate, _
											 strContactYear, _
											 strUserId, _
											 strRsvNo, _
											 strBloodPressure_H, _
											 strBloodPressure_L, _
											 strCircumStances, _
											 strCareComment, _
											 strJudClassCd, _
											 strGuidanceDiv, _
											 strContactStcCd, _
											 strJudClassCdEtc )

			'�ۑ��ł��Ȃ��ꍇ
			If lngAfterCare <> INSERT_NORMAL Then
				strArrMessage = Array("���̖ʐړ��̖ʐڏ�񂪂��łɑ��݂��܂��B")
				Exit Do
			End If

			'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
			strURL = "/webHains/contents/aftercare/AfterCareInterview.asp"
			strURL = strURL & "?mode="        & "REP"
			strURL = strURL & "&actMode="     & "saveend"
			strURL = strURL & "&disp="        & strDisp
			strURL = strURL & "&perId="       & strPerId
			strURL = strURL & "&contactDate=" & strContactDate
			strURL = strURL & "&userId="      & strUserId
			strURL = strURL & "&rsvNo="       & strRsvNo

			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( top.opener != null ) top.opener.location.reload(); top.location.replace('" & strURL & "');"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End

		'�폜��
		Case "DEL"

			'�A�t�^�[�P�A���̍폜
			lngAfterCare = objAfterCare.DeleteAfterData(strPerId, strContactDate)
			If lngAfterCare <> 1 Then
				strArrMessage = Array(MESSAGE_DEL_NG)
				Exit Do
			End If

			'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( top.opener != null ) top.opener.location.reload(); top.close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End

	End Select

	Exit Do
Loop

'�l���̌���

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objPerson = Server.CreateObject("HainsPerson.Person")

'�l���ǂݍ���
objPerson.SelectPerson strPerId,     strLastName,    strFirstName,    _
					   strLastKName, strFirstKName,  strBirth,        _
					   strGender,    strOrgCd1,      strOrgCd2,       _
					   strOrgKName,  strOrgName,     strOrgSName,     _
					   strOrgBsdCd,  strOrgBsdKName, strOrgBsdName,   _
					   strOrgRoomCd, strOrgRoomName, strOrgRoomKName, _
					   strOrgPostCd, strOrgPostName, strOrgPostKName, _
					   , strJobName, , , , , _
					   strEmpNo, Empty, Empty

'�\���p���̂̕ҏW
strDispPerName 	= Trim(strLastName & "�@" & strFirstName)
strDispPerKName = Trim(strLastKName & "�@" & strFirstKName)

'�N��̎Z�o
Set objFree = Server.CreateObject("HainsFree.Free")
strDispAge = objFree.CalcAge(strBirth, Date, "")
Set objFree = Nothing

'�a��ҏW
strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

'����
strGender = IIf(strGender = CStr(GENDER_MALE), "�j��", "����")

'�\�����e�̕ҏW
strDispBirth = strDispBirth & "���@" & strDispAge & "�΁@" & strGender

'�I�u�W�F�N�g�̃C���X�^���X�̊J��
Set objPerson = Nothing

'�����̌���
If strUserId <> "" Then

	Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
	objHainsUser.SelectHainsUser strUserId, strDoctorName
	Set objHainsUser = Nothing

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ʐڏ��̓o�^</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
<!-- #include virtual = "/webHains/includes/docGuide.inc" -->
// �����t���K�C�h�Ăяo��
function callDocGuide() {

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	docGuide_CalledFunction = setDocInfo;

	// �����t���K�C�h�\��
	showGuideDoc();
}

// ��t�R�[�h�E��t���̃Z�b�g
function setDocInfo() {

	var docNameElement;	// ��t����ҏW����G�������g�̖���
	var docName;		// ��t����ҏW����G�������g���g

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	document.entryForm.userId.value = docGuide_DoctorCd;
	document.entryForm.doctorName.value = docGuide_DoctorName;

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		docNameElement = 'docName';

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(docNameElement).innerHTML = docGuide_DoctorName;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = docGuide_DoctorName;
		}

		break;
	}

	return false;
}

// ��t�R�[�h�E��t���̃N���A
function delDoctor() {

	document.entryForm.userId.value = '';
	document.entryForm.doctorName.value = '';

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		docNameElement = 'docName';

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(docNameElement).innerHTML = '';
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = '';
		}

		break;
	}

}

// �ۑ�����
function SaveAfterCare() {

	var objForm = document.entryForm	// ����ʂ̃t�H�[���G�������g

	if ( !checkData() ) {
		return;
	}

	if ( objForm.mode.value == 'NEW' ){
		top.submitForm('INS');
	} else {
		top.submitForm('UPD');
	}

}

// �폜
function DeleteAfterCare() {

	var objForm = document.entryForm	// ����ʂ̃t�H�[���G�������g

	if ( !confirm( '���̖ʐڏ����폜���܂��B��낵���ł����H' ) ) {
		return;
	}

	top.submitForm('DEL');

}

function checkData(){

	var objHedder = document.entryForm							// Hedder��ʂ̃t�H�[���G�������g
	var objDetail = parent.AfterCareDetails.document.entryForm	// Detail��ʂ̃t�H�[���G�������g
	var lngGidCount = <%= lngGuidanceDivCount %>
	var circumMaxCount = <%= lngCircumMaxCount %>
	var careCommentMaxCount = <%= lngCareComment %>
	var i					//���[�v�J�E���g

	//  �w�����e����юw�������̃f�[�^�`�F�b�N
	for( i = 0 ; i < lngGidCount ; i++ ){
		if (objDetail.guidanceDiv[ i ].value == '' && objDetail.contactStcCd[ i ].value != '') {
			alert('�w���敪���ݒ肳��Ă��Ȃ��s�����݂��܂��B');
			return false;
		}
	}

	// �S���҂̃f�[�^�`�F�b�N
	if( objHedder.userId.value == '' ){
		alert('�S���҂��ݒ肳��Ă��܂���B');
		return false;
	}

    // �ʐڏ󋵕������`�F�b�N
/*
	if( objDetail.circumStances.value.length > circumMaxCount ){
		alert('�ʐڏ󋵂̕��������������܂��B');
		return false;
	}
*/
	// ���]�������`�F�b�N
/*
	if( objDetail.careComment.value.length > careCommentMaxCount ){
		alert('���]�̓��͕��������������܂��B');
		return false;
	}
*/
	return true;

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode"            VALUE="<%= strMode             %>">
	<INPUT TYPE="hidden" NAME="actMode"         VALUE="">
	<INPUT TYPE="hidden" NAME="disp"            VALUE="<%= strDisp             %>">
	<INPUT TYPE="hidden" NAME="perId"           VALUE="<%= strPerId            %>">
	<INPUT TYPE="hidden" NAME="contactDate"     VALUE="<%= strContactDate      %>">
	<INPUT TYPE="hidden" NAME="contactYear"     VALUE="<%= strContactYear      %>">
	<INPUT TYPE="hidden" NAME="userId"          VALUE="<%= strUserId           %>">
	<INPUT TYPE="hidden" NAME="rsvNo"           VALUE="<%= strRsvNo            %>">
	<INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= strEditJudClassCd   %>">
	<INPUT TYPE="hidden" NAME="judClassCdEtc"   VALUE="<%= strJudClassCdEtc    %>">
	<INPUT TYPE="hidden" NAME="guidanceDiv"     VALUE="<%= strEditGuidanceDiv  %>">
	<INPUT TYPE="hidden" NAME="seq"             VALUE="<%= strEditSeq          %>">
	<INPUT TYPE="hidden" NAME="contactStcCd"    VALUE="<%= strEditContactStcCd %>">
	<INPUT TYPE="hidden" NAME="bloodPressure_h" VALUE="<%= strBloodPressure_H  %>">
	<INPUT TYPE="hidden" NAME="bloodPressure_l" VALUE="<%= strBloodPressure_L  %>">
	<INPUT TYPE="hidden" NAME="circumStances"   VALUE="<%= strCircumStances    %>">
	<INPUT TYPE="hidden" NAME="careComment"     VALUE="<%= strCareComment      %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�ʐڏ��̓o�^<%= strArrDisp(CLng("0" & strDisp)) %></FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�ۑ��������͊����ʒm���s���A�����Ȃ��΃G���[���b�Z�[�W��ҏW����
	If strActMode = "saveend" Then
		Call EditMessage(MESSAGE_SAVE_OK, MESSAGETYPE_NORMAL)
	Else
		If Not IsEmpty(strArrMessage) Then
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="100%">
		<TR>
			<TD NOWRAP><%= strEmpNo %></TD>
			<TD NOWRAP><B><%= strDispPerName %></B> (<FONT SIZE="-1"><%= strDispPerKName %></FONT>)</TD>
			<TD ROWSPAN="3" ALIGN="right" VALIGN="top" WIDTH="100%">
			<A HREF="JavaScript:top.close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�ʐڏ��E�B���h�E����܂�"></A>&nbsp;
			<A HREF="JavaScript:SaveAfterCare()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���̖ʐڏ���o�^���܂�"></A>&nbsp;
<%
			If strMode = "REP" Then
%>
				<A HREF="JavaScript:DeleteAfterCare()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̖ʐڏ����폜���܂�"></TD>
<%
			End If
%>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= strDispBirth %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right" NOWRAP>�c�́F</TD>
			<TD COLSPAN="2">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP><%= strOrgName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;�����F</TD>
						<TD NOWRAP><%= strOrgPostName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;�E��F</TD>
						<TD NOWRAP><%= strJobName %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>�ʐړ�</TD>
			<TD>�F</TD>
			<TD NOWRAP><B><FONT COLOR="#ff6600"><%= strContactDate %></FONT></B></TD>
			<TD NOWRAP>&nbsp;�S����</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:callDocGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�S���҃K�C�h��\�����܎�"></A></TD>
<!--
						<TD><A HREF="javascript:delDoctor()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�S���҂��N���A"></A></TD>
-->
						<TD><SPAN ID="docName" STYLE="position:relative"><%= Iif(strDoctorName = "", Server.HTMLEncode(Session("USERNAME")), strDoctorName) %></SPAN></TD>
						<INPUT TYPE="hidden" NAME="doctorName" VALUE="<%= Iif(strDoctorName = "", Server.HTMLEncode(Session("USERNAME")), strDoctorName) %>">
					</TR>
				</TABLE>
			</TD>
			</TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>

