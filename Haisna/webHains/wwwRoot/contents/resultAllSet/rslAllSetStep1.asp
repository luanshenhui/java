<%
'-----------------------------------------------------------------------------
'		結果一括入力(グループ選択) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 先頭制御部
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
<TITLE>グループ選択</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<STYLE TYPE="text/css">
td.rsltab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step1" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<%
	'自分自身のステップ番号を保持し、制御用のASPで使用する
%>
	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<BLOCKQUOTE>

	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">Step1：入力対象となる受診日と結果グループを選択してください。</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	If Not IsEmpty(strArrMessage) Then

		'エラーメッセージ編集
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, mlngYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("month", 1, 12, mlngMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("day", 1, 31, mlngDay, False) %></TD>
			<TD>の</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", mstrCsCd, "全てのコース", False) %></TD>
			<TD>&nbsp;&nbsp;当日ＩＤ</TD>
			<TD><INPUT TYPE="text" NAME="dayIdF" VALUE="<%= mstrDayIdF %>" SIZE="5" MAXLENGTH="4"></TD>
			<TD>～</TD>
			<TD><INPUT TYPE="text" NAME="dayIdT" VALUE="<%= mstrDayIdT %>" SIZE="5" MAXLENGTH="4"></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD>入力結果グループ：</TD>
			<TD><%= EditGrpIList_GrpDiv("grpCd", mstrGrpCd, "", "", ADD_NONE) %></TD>
		</TR>
	</TABLE>

	<BR>

	<INPUT TYPE="image" NAME="step2" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
