<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �ύX�����i�w�b�_�j (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<TITLE>�ύX����</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->

// ���[�U�[�K�C�h�Ăяo��
function callGuideUsr() {

	usrGuide_CalledFunction = SetUpdUser;

	// ���[�U�[�K�C�h�\��
	showGuideUsr( );

}

// ���[�U�[�Z�b�g
function SetUpdUser() {

	document.entryForm.updUser.value = usrGuide_UserCd;
	document.getElementById('userName').innerHTML = usrGuide_UserName;

}

// ���[�U�[�w��N���A
function clearUpdUser() {

	document.entryForm.updUser.value = '';
	document.getElementById('userName').innerHTML = '';

}

function windowClose() {

	// ���t�K�C�h�E�C���h�E�����
	calGuide_closeGuideCalendar();

	// ���[�U�[�K�C�h�E�C���h�E�����
	closeGuideDoc();
	winGuideUsr = null;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BR>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
		<TD WIDTH="100%">
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
				<TR>
					<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�ύX����</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<FORM NAME="entryForm" ACTION="rsvLogBody.asp" TARGET="body">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
			<TD>�X�V��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��" border="0"></A></TD>
						<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Date), False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("strMonth", 1, 12, Month(Date), False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("strDay",   1, 31, Day(Date), False) %></TD>
						<TD>���`</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��" border="0"></A></TD>
						<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Date), False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("endMonth", 1, 12, Month(Date), False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("endDay",   1, 31, Day(Date), False) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>�\��ԍ�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD><INPUT TYPE="text" NAME="rsvNo" SIZE="11" MAXLENGTH="9"></TD>
						<TD>&nbsp;</TD>
						<TD NOWRAP>�X�V���[�U</TD>
						<TD>�F</TD>
						<TD><A HREF="javascript:callGuideUsr()"><IMG SRC="/webHains/images/question.gif" ALT="���[�U�K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
						<TD><A HREF="javascript:clearUpdUser()"><IMG SRC="/webHains/images/delicon.gif" ALT="���[�U�w��폜" HEIGHT="21" WIDTH="21"></A></TD>
						<TD NOWRAP><INPUT TYPE="hidden" NAME="updUser" VALUE=""><SPAN ID="userName"></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>�\��</TD>
			<TD NOWRAP>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
					<TR>
						<TD>
							<SELECT NAME="orderByItem">
								<OPTION VALUE="0">�X�V��
								<OPTION VALUE="1">�X�V��
								<OPTION VALUE="2">�\��ԍ�
							</SELECT>
						</TD>
						<TD>��</TD>
						<TD>
							<SELECT NAME="orderByMode">
								<OPTION VALUE="0">����
								<OPTION VALUE="1">�~��
							</SELECT>
						</TD>
						<TD>��</TD>
						<TD>
							<SELECT NAME="getCount">
								<OPTION VALUE="50">50�s����
								<OPTION VALUE="100">100�s����
								<OPTION VALUE="200">200�s����
								<OPTION VALUE="300">300�s����
								<OPTION VALUE="0">���ׂ�
							</SELECT>
						</TD>
						<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" ALT="�\��" HEIGHT="28" WIDTH="53"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
