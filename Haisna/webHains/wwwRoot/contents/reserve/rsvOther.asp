<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\����ڍ�(���̑����) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const FREECD_FREEDIV = "FREEDIV"	'�ėp�R�[�h(�t���[�敪)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�p
Dim objFree			'�ėp���A�N�Z�X�p

'�����l
Dim strRsvNo		'�\��ԍ�
Dim lngCancelFlg	'�L�����Z���t���O

Dim strTestTubeNo	'���̔ԍ�
Dim lngCount		'���̔ԍ��̐�

'����
Dim strFreeCd		'�ėp�R�[�h
Dim strFreeField1	'�ėp�t�B�[���h1
Dim lngFreeCount	'�ėp���R�[�h��

Dim strBuffer		'������ҏW�o�b�t�@
Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objFree    = Server.CreateObject("HainsFree.Free")

'�����l�̎擾
strRsvNo     = Request("rsvNo")
lngCancelFlg = CLng("0" & Request("cancelFlg"))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�\����ڍ�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winConsult;	// ���f���ꗗ���

// ���f���ꗗ��ʌĂяo��
function callConsultWindow() {

	var opened   = false;						// ��ʂ��J����Ă��邩
	var mainForm = top.main.document.entryForm;	// ���C����ʂ̃t�H�[���G�������g
	var url;									// ���f���ꗗ��ʂ�URL

	// ���̓`�F�b�N
	if ( !top.checkValue( 2 ) ) {
		return;
	}

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winConsult != null ) {
		if ( !winConsult.closed ) {
			opened = true;
		}
	}

	// ���f���ꗗ��ʂ�URL�ҏW
	url = 'rsvConsultList.asp';
	url = url + '?perId='    + mainForm.perId.value;
	url = url + '&cslYear='  + mainForm.cslYear.value;
	url = url + '&cslMonth=' + mainForm.cslMonth.value;
	url = url + '&cslDay='   + mainForm.cslDay.value;
	url = url + '&rsvNo='    + mainForm.rsvNo.value;

	// �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winConsult.focus();
		winConsult.location.replace( url );
	} else {
		winConsult = window.open( url, '', 'toolbar=no,directories=no,menubar=no,resizable=no,scrollbars=yes,width=300,height=400' );
	}

}

// �P�����f���̃N���A
function clearFirstCslInfo() {

	top.setFirstCslInfo( '', '', '' );

}

// ���f���ꗗ��ʂ����
function closeConsultWindow() {

	// ���f���ꗗ��ʂ����
	if ( winConsult != null ) {
		if ( !winConsult.closed ) {
			winConsult.close();
		}
	}

	winConsult = null;
}

// �����l�̕ҏW
function setDefaultValue() {

	var myForm   = document.entryForm;			// ����ʂ̃t�H�[���G�������g
	var mainForm = top.main.document.entryForm;	// ���C����ʂ̃t�H�[���G�������g

	// ����ʂ̊e���ڒl�����C����ʂ��擾����
	document.getElementById('rsvDate').innerHTML = mainForm.rsvDate.value;
	document.getElementById('quePrintDate').innerHTML = mainForm.quePrintDate.value;

	myForm.ocrCslYear.value  = mainForm.ocrCslYear.value;
	myForm.ocrCslMonth.value = mainForm.ocrCslMonth.value;
	myForm.ocrCslDay.value   = mainForm.ocrCslDay.value;

	myForm.cameraCslYear.value  = mainForm.cameraCslYear.value;
	myForm.cameraCslMonth.value = mainForm.cameraCslMonth.value;
	myForm.cameraCslDay.value   = mainForm.cameraCslDay.value;

	myForm.firstRsvNo.value  = mainForm.firstRsvNo.value;

	document.getElementById('firstCslDate').innerHTML = mainForm.firstCslDate.value;
	document.getElementById('firstCsName' ).innerHTML = mainForm.firstCsName.value;

	myForm.freeDiv.value     = mainForm.freeDiv.value;
	myForm.freeComment.value = mainForm.freeComment.value;
<%
	'�L�����Z����f���\�����̃C�l�[�u������
	If lngCancelFlg <> CONSULT_USED Then
%>
		myForm.ocrCslYear.disabled  = true;
		myForm.ocrCslMonth.disabled = true;
		myForm.ocrCslDay.disabled   = true;

		myForm.cameraCslYear.disabled  = true;
		myForm.cameraCslMonth.disabled = true;
		myForm.cameraCslDay.disabled   = true;

		myForm.freeDiv.disabled     = true;
		myForm.freeComment.disabled = true;
<%
	End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 8px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setDefaultValue()" ONUNLOAD="javascript:closeConsultWindow()">
<FORM NAME="entryForm" action="#">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">���̑�</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD>�\�����</TD>
			<TD>�F</TD>
			<TD NOWRAP><SPAN ID="rsvDate"></SPAN></TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD>��f�[�o�͓�</TD>
			<TD>�F</TD>
			<TD NOWRAP><SPAN ID="quePrintDate"></SPAN></TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD>�n�b�q�p��f��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
<%
						'�L�����Z����f���\�����̃C�l�[�u������
						If lngCancelFlg = CONSULT_USED Then
%>
							<TD><A HREF="javascript:calGuide_showGuideCalendar('ocrCslYear', 'ocrCslMonth', 'ocrCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
							<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></TD>
<%
						End If
%>
						<TD><%= EditNumberList("ocrCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Empty, (strRsvNo = "")) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("ocrCslMonth", 1, 12, Empty, (strRsvNo = "")) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("ocrCslDay",   1, 31, Empty, (strRsvNo = "")) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>�݃J������f��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
<%
						'�L�����Z����f���\�����̃C�l�[�u������
						If lngCancelFlg = CONSULT_USED Then
%>
							<TD><A HREF="javascript:calGuide_showGuideCalendar('cameraCslYear', 'cameraCslMonth', 'cameraCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
							<TD><A HREF="JavaScript:calGuide_clearDate('cameraCslYear', 'cameraCslMonth', 'cameraCslDay')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
<%
						End If
%>
						<TD><%= EditNumberList("cameraCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Empty, (strRsvNo = "")) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("cameraCslMonth", 1, 12, Empty, (strRsvNo = "")) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("cameraCslDay",   1, 31, Empty, (strRsvNo = "")) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�P�����f��f��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
<%
						'�L�����Z����f���\�����̃C�l�[�u������
						If lngCancelFlg = CONSULT_USED Then
%>
							<TD><A HREF="JavaScript:callConsultWindow()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���f���K�C�h��\��"></A></TD>
							<TD><A HREF="JavaScript:clearFirstCslInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
							<TD>&nbsp;</TD>
<%
						End If
%>
						<TD NOWRAP><INPUT TYPE="hidden" NAME="firstRsvNo" VALUE=""><SPAN ID="firstCslDate"></SPAN>&nbsp;<SPAN ID="firstCsName"></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>�ݎ�f����</TD>
			<TD>�F</TD>
<%
			'�ėp�e�[�u������t���[�敪��ǂݍ���
			lngFreeCount = objFree.SelectFree(1, FREECD_FREEDIV, strFreeCd, , ,strFreeField1)
%>
			<TD>
				<SELECT NAME="freeDiv">
					<OPTION VALUE="">&nbsp;
<%
					'�z��Y�������̃��X�g��ǉ�
					For i = 0 To lngFreeCount - 1
%>
						<OPTION VALUE="<%= strFreeCd(i) %>"><%= strFreeField1(i) %>
<%
					Next
%>
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TD VALIGN="top">����</TD>
			<TD VALIGN="top">�F</TD>
			<TD><TEXTAREA NAME="freeComment" COLS="29" ROWS="4"></TEXTAREA></TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
<%
		'���̔ԍ��Ǘ�����ǂݍ���
		If strRsvNo <> "" Then
			lngCount = objConsult.SelectTestTubeMng(strRsvNo, strTestTubeNo)
			For i = 0 To lngCount - 1
				strBuffer = strBuffer & IIf(i > 0, ", ", "") & strTestTubeNo(i)
			Next
		End If
%>
		<TR>
			<TD>���̔ԍ�</TD>
			<TD>�F</TD>
			<TD NOWRAP><%= strBuffer %></TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
