<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'	   ���͌��ʎ�ނ̑I�� (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc"   -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"   -->
<!-- #include virtual = "/webHains/includes/editRslDailyList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X

Dim lngCntlNoFlg	'�Ǘ��ԍ�����t���O

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�Ǘ��ԍ��̐�����@���擾
lngCntlNoFlg = CLng("0" & objCommon.SelectCntlFlg)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>���͌��ʎ�ނ̑I��</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsltab  { background-color:#FFFFFF }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
// ���̓`�F�b�N
function checkData() {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var ret    = false;					// �֐��߂�l
	
	// ��f�����̓`�F�b�N
	for ( ; ; ) {

		if ( !isDate( myForm.cslYear.value, myForm.cslMonth.value, myForm.cslDay.value ) ) {
			alert('��f���̌`���Ɍ�肪����܂��B');
			break;
		}

		// �Ǘ��ԍ����̓`�F�b�N
		if ( myForm.cntlNo.value != '' ) {
			if ( !myForm.cntlNo.value.match('^[0-9]+$') ) {
				alert('�Ǘ��ԍ��ɂ�1�`9999�̒l����͂��ĉ������B');
				break;
			}
		}

		// ����ID���̓`�F�b�N
		if ( myForm.dayId.value != '' ) {
			if ( !myForm.dayId.value.match('^[0-9]+$') ) {
				alert('�����h�c�ɂ�1�`9999�̒l����͂��ĉ������B');
				break;
			}
		}

		// ����ID�w�莞�͑O����f�Ҕ�J�ڂŊJ������
		myForm.noPrevNext.value = ( myForm.dayId.value == '') ? '' : '1';

		ret = true;
		break;
	}

	return ret;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.dayId.focus();">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="rslMain.asp" ONSUBMIT="return checkData()">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="noPrevNext">

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
		<TR VALIGN="bottom">
			<TD COLSPAN="2"><FONT SIZE="+2"><B>���ʓ���</B></FONT></TD>
		</TR>
		<TR HEIGHT="2">
			<TD COLSPAN="2" BGCOLOR="#cccccc"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2"></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="500">
		<TR>
			<TD ROWSPAN="2" VALIGN="top"><IMG SRC="/webHains/images/keisoku.jpg" WIDTH="80" HEIGHT="60"></TD>
			<TD ROWSPAN="20" WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1"></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder">���ʓ���</SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">��f�Җ��̌������ʂ���͂��܂��B��f���ʓ��͂������炩��ǂ���</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD>��f��</TD>
						<TD>�F</TD>
						<TD>
							<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
								<TR>
									<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
									<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Now()), False) %></TD>
									<TD>�N</TD>
									<TD><%= EditNumberList("cslMonth", 1, 12, Month(Now()), False) %></TD>
									<TD>��</TD>
									<TD><%= EditNumberList("cslDay", 1, 31, Day(Now()), False) %></TD>
									<TD>��</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD>�R�[�X</TD>
						<TD>�F</TD>
						<TD><%= EditCourseList("csCd", "", SELECTED_ALL) %></TD>
					</TR>
					<TR>
						<TD>�\����</TD>
						<TD>�F</TD>
						<TD><%= EditSortKeyList("sortKey", "") %></TD>
					</TR>
<%
					'�Ǘ��ԍ����g�p����ꍇ�͓��̓e�L�X�g��\��
					If lngCntlNoFlg = CNTLNO_ENABLED Then
%>
						<TR>
							<TD NOWRAP>�Ǘ��ԍ�</TD>
							<TD>�F</TD>
							<TD><INPUT TYPE="text" NAME="cntlNo" SIZE="<%= TextLength(4) %>" MAXLENGTH="4"></TD>
						</TR>
<%
					End If
%>
					<TR>
						<TD NOWRAP>�����h�c</TD>
						<TD>�F</TD>
						<TD>
<%
					'�Ǘ��ԍ��𖢎g�p���̓_�~�[�Ǘ��ԍ�
					If lngCntlNoFlg <> CNTLNO_ENABLED Then
%>
						<INPUT TYPE="hidden" NAME="cntlNo" VALUE="">
<%
					End If
%>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR>
									<TD><INPUT TYPE="text" NAME="dayId" SIZE="4" MAXLENGTH="4" STYLE="text-align:left;ime-mode:disabled;"></TD>
									<TD NOWRAP><FONT COLOR="#999999">�i�������͎��ɂ͎�f�҈ꗗ��\�����܂��j</FONT></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
			<TD VALIGN="bottom" WIDTH="100%"><INPUT TYPE="image" NAME="next" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��"></TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/resultAllSet/rslAllSet.asp?step=1"><IMG SRC="/webHains/images/doctor2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/resultAllSet/rslAllSet.asp?step=1">�������ʂ��ꊇ���ē���</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">���픻��Ȃǂ̒�^�������ʂ𕡐���f�҂Ɉꊇ���ē��͂��܂��B</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/resultListSet/rslListSet.asp"><IMG SRC="/webHains/images/worksheet.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/resultListSet/rslListSet.asp">���[�N�V�[�g�`���̌��ʓ���</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">���͊킩��o�͂��ꂽ�������ʃ��X�g�A������N�f�f�Ȃǂ̂���͈͂̌������ʂ𕡐���f�҂ɑ΂��ē��͂���ꍇ�ɕ֗��ł��B</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/common/progress.asp"><IMG SRC="/webHains/images/signal.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/common/progress.asp">�i���󋵂̊m�F</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">���݂̌����i���󋵂�\�����܂��B</TD>
		</TR>
<!--	
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/aftercare/JigoList.asp"><IMG SRC="/webHains/images/aftercare.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/aftercare/JigoList.asp">����[�u�̓o�^</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">����[�u�A�ی��w���͂����炩��B</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/FilmNo/SltFilmkind.asp"><IMG SRC="/webHains/images/filmcan.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="2"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/FilmNo/SltFilmkind.asp">�t�B�����ԍ�����</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="2" VALIGN="top">�t�B�����ԍ����͂͂����炩��B</TD>
		</TR>
-->
<% '2004.04.28 ADD STR ORB)T.Yaguchi %>
    <% '#### 2009.12.03 �� �t�H���[�A�b�v�V�X�e���č\�z�ׁ̈A���j���[����폜 Start %>
		<!--TR>
			<TD HEIGHT="80"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/followup/followupInfo.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/followup/followupInfo.asp">�t�H���[�A�b�v�Ɖ�</A><SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">�t�H���[�A�b�v�Ɖ�̉�ʂ�\�����܂��B</TD>
		</TR>

		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/followup/followupMailInfo.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/followup/followupMailInfo.asp">�t�H���[�A�b�v�͂������</A><SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">�t�H���[�A�b�v�͂�������̉�ʂ�\�����܂��B</TD>
		</TR-->
    <% '#### 2009.12.03 �� �t�H���[�A�b�v�V�X�e���č\�z�ׁ̈A���j���[����폜 End   %>
<% '2004.04.28 ADD END%>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>