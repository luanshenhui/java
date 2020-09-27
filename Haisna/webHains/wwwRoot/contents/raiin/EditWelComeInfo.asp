<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���@���ݒ�  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f�N���X
Dim objFree				'�ėp���A�N�Z�X�p

'�p�����[�^
Dim lngRsvNo			'�\��ԍ�
Dim lngMode				'��ʃ��[�h(1:����ID, 2:���@, 3:OCR�ԍ�, 4:���b�J�[�L�[)
Dim strAction			'�������(�ۑ��{�^��������:"save")

'���@���p�ϐ�
Dim vntDayID			'����ID
Dim vntComeDate			'���@����
Dim vntComeUser			'���@������
Dim vntOcrNo			'OCR�ԍ�
Dim vntLockerKey		'���b�J�[�L�[

Dim strArrMessage		'�G���[���b�Z�[�W
Dim Ret					'�֐��߂�l
Dim strHtml				'HTML������
Dim strModeName			'��ʃ��[�h����
Dim strWelcome			'���@
Dim strUpdUser			'�X�V��

'## 2004.10.15 Add By T.Takagi@FSIT �U���L�����Z���@�\����
Dim strForce			'�������@����t���O
Dim lngVisitStatus		'���@���䏈���߂�l
Dim blnVisitError		'���@����G���[�t���O
'## 2004.10.15 Add End

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
lngRsvNo			= Request("rsvno")
lngMode				= Request("mode")
strAction			= Request("act")

vntDayID			= Request("DayId")
strWelcome			= Request("Welcome")
vntOcrNo			= Request("OcrNo")
vntLockerKey		= Request("LockerKey")

'## 2004.10.15 Add By T.Takagi@FSIT �U���L�����Z���@�\����
strForce = Request("force")
'## 2004.10.15 Add End

Do
	Select Case lngMode
	Case "1"
		strModeName = "����ID"
	Case "2"
		strModeName = "���@"
	Case "3"
		strModeName = "OCR�ԍ�"
	Case "4"
		strModeName = "���b�J�[�L�["
	Case Else
		strModeName = ""
	End Select

	If strAction = "save" Then
		'�l�̃`�F�b�N(����ID)
		If vntDayID <> "" Then
			strArrMessage = objCommon.CheckNumeric("�����h�c", vntDayID, LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
			If strArrMessage <> "" Then
				Exit Do
			End If
		End If
		'�l�̃`�F�b�N(OCR�ԍ�)
		If vntOcrNo <> "" Then
			strArrMessage = objCommon.CheckAlphabetAndNumeric("�n�b�q�ԍ�", vntOcrNo, 10, CHECK_NECESSARY)
			If strArrMessage <> "" Then
				Exit Do
			End If
		End If
		'�l�̃`�F�b�N(���b�J�[�L�[)
		If vntLockerKey <> "" Then
			strArrMessage = objCommon.CheckAlphabetAndNumeric("���b�J�[�L�[", vntLockerKey, 5, CHECK_NECESSARY)
			If strArrMessage <> "" Then
				Exit Do
			End If
		End If

		'�X�V�҂̐ݒ�
		strUpdUser = Session("USERID")

		'���@���̍X�V
'## 2004.10.15 Mod By T.Takagi@FSIT �U���L�����Z���@�\����
'		Ret = objConsult.UpdateWelComeInfo(lngRsvNo, _
'											lngMode, _
'											strUpdUser, _
'											vntDayID, _
'											strWelcome, _
'											vntOcrNo, _
'											vntLockerKey _
'											)
		Ret = objConsult.UpdateWelComeInfo(lngRsvNo, lngMode, strUpdUser, vntDayID, strWelcome, vntOcrNo, vntLockerKey, strForce, lngVisitStatus, strArrMessage)

		'�G���[��
		If Ret = False Then

			'���@����G���[���̓t���O����
			If lngMode = "2" And lngVisitStatus <= 0 Then
				blnVisitError = True
			End If

		End If
'## 2004.10.15 Mod End

		'�X�V�G���[���͏����𔲂���
		If Ret <> True Then
			Exit Do
		Else
			'���b�J�[�L�[������ɍX�V���ꂽ�Ƃ��i���b�J�[�L�[�̏���[=�l�Ȃ�]�͏����j
			If lngMode = "4" And vntLockerKey <> "" Then
				strHtml = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHtml = strHtml & vbCrLf & "<HTML lang=""ja"">"
				strHtml = strHtml & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.setLockerKey(); close()"">"
				strHtml = strHtml & "</BODY>"
				strHtml = strHtml & "</HTML>"
				Response.Write strHtml
				Response.End
				Exit Do
			End If

			'�G���[���Ȃ���ΌĂь���ʂ��ĕ\�����Ď��g�����
			strHtml = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHtml = strHtml & vbCrLf & "<HTML lang=""ja"">"
			strHtml = strHtml & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.parent.location.reload(); close()"">"
			strHtml = strHtml & "</BODY>"
			strHtml = strHtml & "</HTML>"
			Response.Write strHtml
			Response.End
			Exit Do
		End If
	End If

	'���@��񌟍�
	Ret = objConsult.SelectWelComeInfo(lngRsvNo, _
										, , , , , , , , , , , , , , , , , , , _
										vntDayID,		_
										vntComeDate,	_
										vntComeUser,	_
										vntOcrNo,		_
										vntLockerKey	_
										)
	If Ret = False Then
		Err.Raise 1000, , "���@��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
	End If

	'���@(0:������, 1:���@���, 2:�����@���)
	If lngMode = "2" Then
		strWelcome = IIf(vntComeDate<>"", "1", "2")
	Else
		strWelCome = "0"
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objConsult = Nothing

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE><%= strModeName %>�̐ݒ�</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// ��������
function loadPage() {
	var myForm = document.entryForm;
	var url;							// URL������
	var i;

	if( myForm.elements == null ) return;

	for( i=0; i < myForm.elements.length; i++ ) {
		if ( myForm.elements[i].type == 'text' ) {
			myForm.elements[i].focus();
			return;
		}
	}
}

//�ۑ�����
function saveWelComeInfo() {
	var myForm = document.entryForm;

	// ���@���𗈉@�������@�ɂ����Ƃ��͊m�F���b�Z�[�W��\��
	if( myForm.mode.value == '2' ) {
		if( myForm.orgWelcome.value == '1' && myForm.Welcome.value == '2' ) {
			if( !confirm('�����@�ɂ��܂��B��낵���ł����H') ) {
				return;
			}
		}
	}

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

	return;
}

// �L�[�������̏���
function Key_Press(){
	var myForm = document.entryForm;
	var i;

	// Enter�L�[
	if ( event.keyCode == 13 ) {
		if( myForm.elements == null ) return;

		for( i=0; i < myForm.elements.length; i++ ) {
			if ( myForm.elements[i].type == 'text' ) {
				if ( myForm.elements[i].value == '' ) {
					myForm.elements[i].focus();
					return;
				}
			}
		}

		// �ۑ��������s��
		saveWelComeInfo();
	}
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:loadPage()" ONKEYPRESS="JavaScript:Key_Press()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="mode"  VALUE="<%= lngMode %>">
	<INPUT TYPE="hidden" NAME="act"   VALUE="<%= strAction %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000"><%= strModeName %>�̐ݒ�</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
		If Not IsEmpty(strArrMessage) Then
			'�G���[���b�Z�[�W��ҏW
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="10"><%= strModeName %></TD>
			<TD>�F</TD>
<%
	Select Case lngMode
	Case "1"		'����ID
%>
			<TD>
				<INPUT TYPE="text" NAME="DayId" VALUE="<%= vntDayID %>" SIZE="4" MAXLENGTH="4" BORDER="0" STYLE="ime-mode:disabled" ONFOCUS="this.select()">
			</TD>
<%
	Case "2"		'���@���
%>
			<TD>
				<INPUT TYPE="radio" NAME="radio_Welcome" VALUE="1" <%= IIf(strWelcome="1", "CHECKED", "") %> STYLE="ime-mode:disabled" ONCHANGE="javascript:document.entryForm.Welcome.value = this.value">���@
				<INPUT TYPE="radio" NAME="radio_Welcome" VALUE="2" <%= IIf(strWelcome="2", "CHECKED", "") %> STYLE="ime-mode:disabled" ONCHANGE="javascript:document.entryForm.Welcome.value = this.value">�����@
				<INPUT TYPE="hidden" NAME="orgWelcome" VALUE="<%= strWelcome %>">
				<INPUT TYPE="hidden" NAME="Welcome" VALUE="<%= strWelcome %>">
			</TD>
<%
	Case "3"		'OCR�ԍ�
%>
			<TD>
				<INPUT TYPE="text" NAME="OcrNo" VALUE="<%= vntOcrNo %>" SIZE="10" MAXLENGTH="10" BORDER="0" STYLE="ime-mode:disabled" ONFOCUS="this.select()">
			</TD>
<%
	Case "4"		'���b�J�[�L�[
%>
			<TD>
				<INPUT TYPE="text" NAME="LockerKey" VALUE="<%= vntLockerKey %>" SIZE="5" MAXLENGTH="5" BORDER="0" STYLE="ime-mode:disabled" ONFOCUS="this.select()">
			</TD>
<%
	End Select
%>
		</TR>
<%
'## 2004.10.15 Add By T.Takagi@FSIT �U���L�����Z���@�\����
	'���@���������ɂăG���[�����������ꍇ�̂݋��������p�`�F�b�N�{�b�N�X��\������
	If lngMode = "2" And blnVisitError = True And lngVisitStatus = -1 Then
%>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD HEIGHT="40"><INPUT TYPE="checkbox" NAME="force" VALUE="1">�����I�ɖ����@�������s��</TD>
		</TR>
<%
	End If
'## 2004.10.15 Add End
%>
	</TABLE>
	<BR>
	<TABLE WIDTH="169" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR>
            <TD>
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
           	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>  
                <A HREF="javascript:saveWelComeInfo()"><IMG SRC="../../images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�" border="0"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
            </TD>
			
            
            <TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��" border="0"></A></TD>
		</TR>
	</TABLE>
	<BR>
</FORM>
</BODY>
</HTML>
