<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�\����ڍ�(���̑��ǉ�����) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strRowCount		'�\���s��
Dim lngCancelFlg	'�L�����Z���t���O

Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Const ROWCOUNT = "5"	'�\���s���̃f�t�H���g�l

'�p�����[�^�l�̎擾
strRowCount  = Request("rowCount")
lngCancelFlg = CLng("0" & Request("cancelFlg"))

strRowCount = IIf(CLng("0" & strRowCount) = 0, ROWCOUNT, strRowCount)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�I�v�V��������</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!--
var cslDiv;		// ���ڋ敪
var cslCd;		// ���ڃR�[�h
var cslName;	// ���ږ���
var editFlg;	// �C���敪

// �\��ڍ׉�ʂɊi�[����Ă��邻�̑��ǉ����������i�[
cslDiv  = top.main.document.entryForm.cslDiv.value.split(',');
cslCd   = top.main.document.entryForm.cslCd.value.split(',');
cslName = top.main.document.entryForm.cslName.value.split(',');
editFlg = top.main.document.entryForm.editFlg.value.split(',');

// ���ڃK�C�h�Ăяo��
function callItemGuide() {

	itmGuide_mode     = 1;	// �˗��^���ʃ��[�h�@1:�˗��A2:����
	itmGuide_group    = 1;	// �O���[�v�\���L���@0:�\�����Ȃ��A1:�\������
	itmGuide_item     = 1;	// �������ڕ\���L���@0:�\�����Ȃ��A1:�\������
	itmGuide_question = 0;	// ��f���ڕ\���L���@0:�\�����Ȃ��A1:�\������

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	itmGuide_CalledFunction = setGrpItem;

	// ���ڃK�C�h�\��
	showGuideItm();
}

// ���X�g�̕ҏW
function setGrpItem() {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var cslNameElement;					// �G�������g��
	var i, j;							// �C���f�b�N�X

	// �K�C�h�ɂđI�����ꂽ���ڂ�����
	for ( i = 0; i < itmGuide_dataDiv.length; i++ ) {

		// ����ʂ̃G�������g������
		for ( j = 0; j < myForm.cslDiv.length; j++ ) {

			// ���łɑ��݂��鍀�ڂ��I������Ă���ꍇ�͌����I��
			if ( itmGuide_dataDiv[i] == myForm.cslDiv[j].value && itmGuide_itemCd[i] == myForm.cslCd[j].value ) {
				break;
			}

			// ���ږ��ҏW�s�����������ꍇ
			if ( myForm.cslDiv[j].value == '' && myForm.cslCd[j].value == '' ) {

				// ���ڕ��ށE�R�[�h�̕ҏW
				myForm.cslDiv[j].value = itmGuide_dataDiv[i];
				myForm.cslCd[j].value  = itmGuide_itemCd[i];

				// ���ږ��̕ҏW
				document.getElementById('cslName' + j).innerHTML = itmGuide_itemName[i];

				break;
			}

		}

	}

}

// �\���s���̕ύX
function changeRow() {

	// ���݂̓��͓��e���ڍ׉�ʂ̃G�������g�l�Ƃ��ĕҏW����
	top.setAddItemToMain();

	// �\���s����ύX���čĕ\��
	location.replace('<%= Request.ServerVariables("SCRIPT_NAME") %>?rowCount=' + document.entryForm.rowCount.value)
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideItm()">
<FORM NAME="entryForm" action="#">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
		<TR>
			<TD WIDTH="100%">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
					<TR>
						<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">���̑��ǉ�����</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
			'��L�����Z���҂̏ꍇ�̂݃K�C�h�\���\�Ƃ���
			If lngCancelFlg = CONSULT_USED Then
%>
				<TD ALIGN="center">&nbsp;<A HREF="JavaScript:callItemGuide()"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ڃK�C�h��\��"></A></TD>
<%
			End If
%>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR BGCOLOR="#eeeeee">
			<TD WIDTH="200">����</TD>
			<TD>�w��</TD>
		</TR>
<%
		For i = 0 To CLng(strRowCount) - 1
%>
			<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
				document.write('<INPUT TYPE="hidden" NAME="cslDiv" VALUE="' + (cslDiv[<%= i %>] == null ? '' : cslDiv[<%= i %>]) + '">');
				document.write('<INPUT TYPE="hidden" NAME="cslCd"  VALUE="' + (cslCd[<%= i %>]  == null ? '' : cslCd[<%= i %>] ) + '">');
			</SCRIPT>
			<TR>
				<TD>
					<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
						document.write('<SPAN ID="cslName<%= i %>" STYLE="position:relative">');
						document.write((cslName[<%= i %>] == null ? '' : cslName[<%= i %>] ));
						document.write('</SPAN>');
					</SCRIPT>
				</TD>
				<TD>
					<SELECT NAME="editFlg" <%= IIf(lngCancelFlg <> CONSULT_USED, "DISABLED", "") %>>
						<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
							switch ( editFlg[<%= i %>] ) {
								case '0':
									document.write('<OPTION VALUE="1">�ǉ�');
									document.write('<OPTION VALUE="2">�폜');
									document.write('<OPTION VALUE="0" SELECTED>���̎w����������');
									break;
								case '1':
									document.write('<OPTION VALUE="1" SELECTED>�ǉ�');
									document.write('<OPTION VALUE="2">�폜');
									document.write('<OPTION VALUE="0">���̎w����������');
									break;
								case '2':
									document.write('<OPTION VALUE="1">�ǉ�');
									document.write('<OPTION VALUE="2" SELECTED>�폜');
									document.write('<OPTION VALUE="0">���̎w����������');
									break;
								default:
									document.write('<OPTION VALUE="1">�ǉ�');
									document.write('<OPTION VALUE="2">�폜');
									document.write('<OPTION VALUE="0">���̎w����������');
							}
						</SCRIPT>
					</SELECT>
				</TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD COLSPAN="3" HEIGHT="1" BGCOLOR="#cccccc"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
		</TR>
		<TR>
			<TD ALIGN="right" COLSPAN="3">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD></TD>
						<TD NOWRAP>�ǉ��������ڂ�</TD>
						<TD>
							<SELECT NAME="rowCount" <%= IIf(lngCancelFlg <> CONSULT_USED, "DISABLED", "") %>>
<%
							For i = 5 To 50 Step 5
%>
								<OPTION VALUE="<%= i %>" <%= IIf(i = CLng(strRowCount), "SELECTED", "") %>><%= i %>��
<%
							Next
%>
							</SELECT>
						</TD>
<%
						'��L�����Z���҂̏ꍇ�̂ݕ\���{�^���ɃA���J�[��p�ӂ���
						If lngCancelFlg = CONSULT_USED Then
%>
							<TD><A HREF="JavaScript:changeRow()"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></A></TD>
<%
						Else
%>
							<TD><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></TD>
<%
						End If
%>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
