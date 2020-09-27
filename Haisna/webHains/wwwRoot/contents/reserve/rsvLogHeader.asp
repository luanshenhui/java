<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   変更履歴（ヘッダ） (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' 先頭制御部
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
<TITLE>変更履歴</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->

// ユーザーガイド呼び出し
function callGuideUsr() {

	usrGuide_CalledFunction = SetUpdUser;

	// ユーザーガイド表示
	showGuideUsr( );

}

// ユーザーセット
function SetUpdUser() {

	document.entryForm.updUser.value = usrGuide_UserCd;
	document.getElementById('userName').innerHTML = usrGuide_UserName;

}

// ユーザー指定クリア
function clearUpdUser() {

	document.entryForm.updUser.value = '';
	document.getElementById('userName').innerHTML = '';

}

function windowClose() {

	// 日付ガイドウインドウを閉じる
	calGuide_closeGuideCalendar();

	// ユーザーガイドウインドウを閉じる
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
					<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">変更履歴</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<FORM NAME="entryForm" ACTION="rsvLogBody.asp" TARGET="body">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" ALT=""></TD>
			<TD>更新日</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示" border="0"></A></TD>
						<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Date), False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("strMonth", 1, 12, Month(Date), False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("strDay",   1, 31, Day(Date), False) %></TD>
						<TD>日～</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示" border="0"></A></TD>
						<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Date), False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("endMonth", 1, 12, Month(Date), False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("endDay",   1, 31, Day(Date), False) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>予約番号</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD><INPUT TYPE="text" NAME="rsvNo" SIZE="11" MAXLENGTH="9"></TD>
						<TD>&nbsp;</TD>
						<TD NOWRAP>更新ユーザ</TD>
						<TD>：</TD>
						<TD><A HREF="javascript:callGuideUsr()"><IMG SRC="/webHains/images/question.gif" ALT="ユーザガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
						<TD><A HREF="javascript:clearUpdUser()"><IMG SRC="/webHains/images/delicon.gif" ALT="ユーザ指定削除" HEIGHT="21" WIDTH="21"></A></TD>
						<TD NOWRAP><INPUT TYPE="hidden" NAME="updUser" VALUE=""><SPAN ID="userName"></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>表示</TD>
			<TD NOWRAP>：</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
					<TR>
						<TD>
							<SELECT NAME="orderByItem">
								<OPTION VALUE="0">更新日
								<OPTION VALUE="1">更新者
								<OPTION VALUE="2">予約番号
							</SELECT>
						</TD>
						<TD>の</TD>
						<TD>
							<SELECT NAME="orderByMode">
								<OPTION VALUE="0">昇順
								<OPTION VALUE="1">降順
							</SELECT>
						</TD>
						<TD>に</TD>
						<TD>
							<SELECT NAME="getCount">
								<OPTION VALUE="50">50行ずつ
								<OPTION VALUE="100">100行ずつ
								<OPTION VALUE="200">200行ずつ
								<OPTION VALUE="300">300行ずつ
								<OPTION VALUE="0">すべて
							</SELECT>
						</TD>
						<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" ALT="表示" HEIGHT="28" WIDTH="53"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
