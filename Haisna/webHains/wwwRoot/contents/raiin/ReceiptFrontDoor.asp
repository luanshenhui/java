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
Dim strAction			'�������(�m��{�^��������:"check"��"checkend"��"save")
Dim strGuidanceNo		'���ē����m��
Dim strOcrNo			'�n�b�q�m��

'���@���p�ϐ�
Dim lngRsvNo			'�\��ԍ�
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

Dim blnRsvFlg			'�\��σt���O
Dim strEraBirth			'���N����(�a��)
Dim strRealAge			'���N��

Dim strArrMessage		'�G���[���b�Z�[�W
Dim strUpdUser			'�X�V��
Dim strURL				'URL������
Dim Ret					'�֐��߂�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
strAction		= Request("act")
strGuidanceNo	= Request("GuidanceNo")
strOcrNo		= Request("OcrNo")

lngRsvNo		= strGuidanceNo
strUpdUser		= Session("USERID")

Do
	'��t�m�F����
	If strAction = "check" Then
		blnRsvFlg = False

		'�l�̃`�F�b�N(���ē����m��)
		strArrMessage = objCommon.CheckNumeric("���ē����m��", lngRsvNo, LENGTH_CONSULT_RSVNO, CHECK_NECESSARY)
		If strArrMessage <> "" Then
			strAction = "checkerr"
			Exit Do
		End If
		'�l�̃`�F�b�N(OCR�ԍ�)
		strArrMessage = objCommon.CheckAlphabetAndNumeric("�n�b�q�m��", strOcrNo, 10, CHECK_NECESSARY)
		If strArrMessage <> "" Then
			strAction = "checkerr"
			Exit Do
		End If

		'���@��񌟍�
		Ret = objConsult.SelectWelComeInfo(lngRsvNo, _
											vntCancelFlg,		_
											vntCslDate,			_
											vntPerId,			_
											vntCsCd,			_
											vntOrgCd1,			_
											vntOrgCd2,			_
											vntRsvGrpCd,		_
											vntRsvDate,			_
											vntAge,				_
											vntCtrPtCd,			_
											vntIsrSign,			_
											vntIsrNo,			_
											vntReportAddrDiv,	_
											vntReportOurEng,	_
											vntCollectTicket,	_
											vntIssueCslTicket,	_
											vntBillPrint,		_
											vntVolunteer,		_
											vntVolunteerName,	_
											vntDayID,			_
											vntComeDate,		_
											vntComeUser,		_
											vntOcrNo,			_
											vntLockerKey,		_
											vntBirth,			_
											vntGender,			_
											vntLastName,		_
											vntFirstName,		_
											vntLastKName,		_
											vntFirstKName,		_
											vntRomeName,		_
											vntNationCd,		_
											vntNationName,		_
											vntCompPerId,		_
											vntCompPerName,		_
											vntCsName,			_
											vntCsSName,			_
											vntOrgKName,		_
											vntOrgName,			_
											vntOrgSName,		_
											vntTicket,			_
											vntInsBring,		_
											vntRsvGrpName,		_
											vntRsvGrpStrTime,	_
											vntRsvGrpEndTime	_
										)
		strAction = "checkend"
		blnRsvFlg = Ret
		If Ret = False Then
			strArrMessage = "�\�񂳂�Ă��܂���B"
			strAction = "checkerr"
		End If
		If strAction <> "checkerr" And _
		   vntDayID = "" Then
			strArrMessage = "��t����Ă��܂���B"
			strAction = "checkerr"
		End If
		If strAction <> "checkerr" And _
		   objCommon.FormatString(Date, "yyyy/mm/dd") <> objCommon.FormatString(CDate(vntCslDate), "yyyy/mm/dd") Then
			strArrMessage = "��f��(" & objCommon.FormatString(CDate(vntCslDate), "yyyy/mm/dd") & ")�͖{���ł͂���܂���B"
			strAction = "checkerr"
		End If
		If strAction <> "checkerr" And _
		   vntComeDate <> "" Then
			strArrMessage = "���łɗ��@�ς݂ł��B"
			strAction = "checkerr"
		End If
	End If

	'�X�V����
	If strAction = "save" Then
		'���@���(���@�AOCR�ԍ�)�̍X�V
		Ret = objConsult.UpdateWelComeInfo(lngRsvNo, _
											0, _
											strUpdUser, _
											, _
											1, _
											strOcrNo _
											)
		If Ret = True Then
			strAction = "saveend"
		End If
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objConsult = Nothing

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
<TITLE>��t����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winReserveMain;						// �\���ʂ̃E�B���h�E�n���h��
var winReceiptMain;						// ���@��ʂ̃E�B���h�E�n���h��

// ��������
function loadPage() {
	var myForm = document.entryForm;
	var opened = false;					// ��ʂ��J����Ă��邩
	var url;							// URL������
	var i;

	// �`�F�b�N�ŃG���[���Ȃ���΍X�V�������s��
	if ( myForm.act.value == 'checkend' ) {
		myForm.act.value = 'save';
		myForm.submit();
		return;
	}

	if ( myForm.act.value == 'saveend' ) {
		//
		// �\���ʂ��J��
		//
		// ���łɃK�C�h���J����Ă��邩�`�F�b�N
		if ( winReserveMain ) {
			if ( !winReserveMain.closed ) {
				opened = true;
			}
		}
		url = '/WebHains/contents/reserve/rsvMain.asp';
		url = url + '?rsvno=' + '<%= lngRsvNo %>';

		// �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
		if ( opened ) {
			winReserveMain.focus();
			winReserveMain.location.replace( url );
		} else {
			winReserveMain = window.open( url, '', 'width=' + window.screen.availWidth + ',height=' + window.screen.availHeight + ',status=no,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes,top=0,left=0' );
		}

		opened = false;
		//
		// ���@��ʂ��J��
		//
		// ���łɃK�C�h���J����Ă��邩�`�F�b�N
		if ( winReceiptMain ) {
			if ( !winReserveMain.closed ) {
				opened = true;
			}
		}
		url = '/WebHains/contents/raiin/ReceiptMain.asp';
		url = url + '?rsvno=' + '<%= lngRsvNo %>';
		url = url + '&receiptflg=1';

		// �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
		if ( opened ) {
			winReceiptMain.focus();
			winReceiptMain.location.replace( url );
		} else {
			winReceiptMain = window.open( url, '', 'width=670,height=700,status=no,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes,top=0,left=0' );
		}
		return;
	}

	// �t�H�[�J�X�ݒ�
	for( i=0; i < myForm.elements.length; i++ ) {
		if ( myForm.elements[i].type == 'text' ) {
			if ( myForm.elements[i].value == '' ) {
				myForm.elements[i].focus();
				return;
			}
		}
	}
}

// �m��{�^���������̏���
function OkReceipt() {
	var myForm = document.entryForm;

	for( i=0; i < myForm.elements.length; i++ ) {
		if ( myForm.elements[i].type == 'text' ) {
			if ( myForm.elements[i].value == '' ) {
				myForm.elements[i].focus();
				alert( '���ē����m���A�n�b�q�m���Ƃ����͂��Ă��������B' );
				return;
			}
		}
	}

	myForm.act.value = 'check';
	myForm.submit();
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

		// �m�菈�����s��
		OkReceipt();
	}
}

// �E�B���h�E�����
function windowClose() {

	// �\���ʂ����
	if ( winReserveMain != null ) {
		if ( !winReserveMain.closed ) {
			winReserveMain.close();
		}
	}

	// ���@��ʂ����
	if ( winReceiptMain != null ) {
		if ( !winReceiptMain.closed ) {
			winReceiptMain.close();
		}
	}

	winReserveMain = null;
	winReceiptMain = null;
}

// ���̎�t���͂��s�����ߏ���������
function nextReceipt() {
	var myForm = document.entryForm;
	var i;

	for( i=0; i < myForm.elements.length; i++ ) {
		if ( myForm.elements[i].type == 'text' ) {
			myForm.elements[i].value = '';
		}
	}
	myForm.GuidanceNo.focus();

	myForm.act.value = '';

	// �E�B���h�E�����
	windowClose();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.rsvtab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:loadPage()" ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAction %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="20"></TD>
			<TD WIDTH="100%">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
					<TR>
						<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��t����</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="20"></TD>
		</TR>
	</TABLE>
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD ALIGN="center">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="30" ALT=""></TD>
					</TR>
					<TR VALIGN="center">
						<TD NOWRAP>���ē����m��</TD>
						<TD NOWRAP WIDTH="8">�F</TD>
						<TD NOWRAP><INPUT TYPE="text" NAME="GuidanceNo" SIZE="9" MAXLENGTH="9" BORDER="0" VALUE="<%= strGuidanceNo %>" STYLE="ime-mode:disabled" ONKEYPRESS="JavaScript:Key_Press()"></TD>
					</TR>
					<TR VALIGN="center">
						<TD NOWRAP>�n�b�q�m��</TD>
						<TD NOWRAP WIDTH="8">�F</TD>
						<TD NOWRAP><INPUT TYPE="text" NAME="OcrNo" SIZE="10" MAXLENGTH="10" BORDER="0" VALUE="<%= strOcrNo %>" STYLE="ime-mode:disabled" ONKEYPRESS="JavaScript:Key_Press()"></TD>
					</TR>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="30" ALT=""></TD>
					</TR>
					<TR>
						<TD NOWRAP COLSPAN="3" ALIGN="center">
						<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
				        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
							<A HREF="JavaScript:OkReceipt()"><IMG SRC="../../images/ok.gif" WIDTH="77" HEIGHT="23" ALT="���̓��e�Ŏ�t�m��" BORDER="0"></A>
						<%  else    %>
							 &nbsp;
						<%  end if  %>
						<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<%
	If strAction = "checkerr" Then
%>
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="30" ALT=""></TD>
		</TR>
		<TR>
			<TD ALIGN="center">
<%
		If Not IsEmpty(strArrMessage) Then
			'�G���[���b�Z�[�W��ҏW
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
		If blnRsvFlg = True Then
%>
			</TD>
		</TR>
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="30" ALT=""></TD>
		</TR>
		<TR>
			<TD ALIGN="center">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR VALIGN="middle">
									<TD NOWRAP>�\��ԍ��F</TD>
									<TD NOWRAP>
										<A HREF="/WebHains/contents/reserve/rsvMain.asp?rsvno=<%= lngRsvNo %>" TARGET="_blank">
											<B><%= lngRsvNo %></B>
										</A>
									</TD>
									<TD NOWRAP WIDTH="10"></TD>
									<TD NOWRAP>�����h�c�F</TD>
									<TD NOWRAP><FONT COLOR="#ff6600"><B><%= IIf(vntDayID="", "����t", objCommon.FormatString(vntDayID, "0000")) %></B></FONT></TD>
									<TD NOWRAP WIDTH="10"></TD>
									<TD NOWRAP>���@���F</TD>
									<TD NOWRAP><FONT COLOR="#ff6600"><B><%= IIf(vntComeDate="", "�����@", "���@�ς�") %></B></FONT></TD>
								</TR>
							</TABLE>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR>
									<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
								</TR>
								<TR VALIGN="middle">
									<TD NOWRAP>�R�[�X�F</TD>
									<TD NOWRAP><B><%= vntCsName %></B></TD>
									<TD NOWRAP WIDTH="10"></TD>
									<TD NOWRAP>��f���F</TD>
									<TD NOWRAP><B><%= vntCslDate %></B></TD>
									<TD NOWRAP WIDTH="10"></TD>
									<TD NOWRAP>�\��Q�F</TD>
									<TD NOWRAP><B><%= vntRsvGrpName %></B></TD>
								</TR>
							</TABLE>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR>
									<TD><IMG SRC="../../images/spacer.gif" WIDTH="1" HEIGHT="5" ALT=""></TD>
								</TR>
								<TR VALIGN="middle">
									<TD NOWRAP><%= vntPerId %></TD>
									<TD WIDTH="10"></TD>
									<TD NOWRAP>
										<B><%= vntLastName & "�@" & vntFirstName %></B>
										<FONT COLOR="#999999"> (</FONT><FONT SIZE="-1" COLOR="#999999"><%= vntLastKName & "�@" & vntFirstKName %></FONT><FONT COLOR="#999999">)</FONT>
									</TD>
									<TD NOWRAP WIDTH="10"></TD>
<%
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
%>
									<TD NOWRAP><%= strEraBirth %>���@<%= strRealAge %>�΁i<%= Int(vntAge) %>�΁j�@<%= IIf(vntGender = "1", "�j��", "����") %></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<%
		End If
	End If
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
