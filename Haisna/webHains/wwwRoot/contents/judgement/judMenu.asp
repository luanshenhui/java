<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���胁�j���[ (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>������́i�����w��j</TITLE>
<STYLE TYPE="text/css">
<!--
td.judtab { background-color:#FFFFFF }
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
/*
		if ( myForm.cntlNo.value != '' ) {
			if ( !myForm.cntlNo.value.match('^[0-9]+$') ) {
				alert('�Ǘ��ԍ��ɂ�1�`9999�̒l����͂��ĉ������B');
				break;
			}
		}
*/
		// ����ID���̓`�F�b�N
		if ( myForm.dayId.value != '' ) {
			if ( !myForm.dayId.value.match('^[0-9]+$') ) {
				alert('�����h�c�ɂ�1�`9999�̒l����͂��ĉ������B');
				break;
			}
		}

		// ����ID�̓��͗L����ACTION����ς�����
		if ( myForm.dayId.value != '' ) {
			myForm.noPrevNext.value = '1';
			myForm.action = 'judMain.asp';
		} else {
			myForm.action = 'judgedaily.asp';
		}

		ret = true;
		break;
	}

	return ret;
}
//-->
</SCRIPT>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="" ONSUBMIT="return checkData()">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="noPrevNext">

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
		<TR VALIGN="bottom">
			<TD COLSPAN="2"><FONT SIZE="+2"><B>����x��</B></FONT></TD>
		</TR>
		<TR HEIGHT="2">
			<TD COLSPAN="2" BGCOLOR="#CCCCCC"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<!--
		<TR>
			<TD ROWSPAN="6" VALIGN="top"><IMG SRC="/webHains/images/judge.jpg" WIDTH="80" HEIGHT="60"></TD>
			<TD ROWSPAN="6" WIDTH="20"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder">�������͂���</SPAN><BR><BR></TD>
		</TR>
		<TR>
			<TD>��f��</TD>
			<TD>�F</TD>
			<TD COLSPAN="2">
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
			<TD>�����h�c</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="dayId" SIZE="<%= TextLength(4) %>" MAXLENGTH="4" STYLE="text-align:left;ime-mode:disabled;"></TD>
			<TD><FONT COLOR="#999999">�i�������͎��ɂ͎�f�҈ꗗ��\�����܂��j</FONT></TD>
		</TR>
		<TR>
			<TD COLSPAN="4">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>�̌l�ꗗ��</TD>
						<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="4"><INPUT TYPE="checkbox" NAME="badJud" VALUE="1">���肪�����l�̂ݕ\��</TD>
		</TR>
		<TR>
			<TD COLSPAN="4"><INPUT TYPE="checkbox" NAME="unFinished" VALUE="1">���薢�����҂̂ݕ\��</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
-->
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/judgement/judAutoSet.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/judgement/judAutoSet.asp">����x��</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">�e�������ڂ̒l���Q�Ƃ��A����x�����s���܂��B</TD>
		</TR>
<!--
		<TR>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="200" BORDER="0"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/report/reportSendCheck.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/report/reportSendCheck.asp">���я������m�F</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">���я��̔����m�F���s���܂��B</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/report/inqReportsInfo.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/report/inqReportsInfo.asp">���я��쐬�i���m�F</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">���я��쐬�̐i���m�F���s���܂��B</TD>
		</TR>
-->
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
