<%
'-----------------------------------------------------------------------------
'		���ʈꊇ����(�O���[�v�I��) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�O���[�v�I��</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<STYLE TYPE="text/css">
td.rsltab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step1" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<%
	'�������g�̃X�e�b�v�ԍ���ێ����A����p��ASP�Ŏg�p����
%>
	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<BLOCKQUOTE>

	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">Step1�F���͑ΏۂƂȂ��f���ƌ��ʃO���[�v��I�����Ă��������B</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If Not IsEmpty(strArrMessage) Then

		'�G���[���b�Z�[�W�ҏW
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, mlngYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("month", 1, 12, mlngMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("day", 1, 31, mlngDay, False) %></TD>
			<TD>��</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", mstrCsCd, "�S�ẴR�[�X", False) %></TD>
			<TD>&nbsp;&nbsp;�����h�c</TD>
			<TD><INPUT TYPE="text" NAME="dayIdF" VALUE="<%= mstrDayIdF %>" SIZE="5" MAXLENGTH="4"></TD>
			<TD>�`</TD>
			<TD><INPUT TYPE="text" NAME="dayIdT" VALUE="<%= mstrDayIdT %>" SIZE="5" MAXLENGTH="4"></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD>���͌��ʃO���[�v�F</TD>
			<TD><%= EditGrpIList_GrpDiv("grpCd", mstrGrpCd, "", "", ADD_NONE) %></TD>
		</TR>
	</TABLE>

	<BR>

	<INPUT TYPE="image" NAME="step2" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
