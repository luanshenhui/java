<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		判定メニュー (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<META http-equiv="Content-Style-Type" content="text/css">
<TITLE>判定入力（条件指定）</TITLE>
<STYLE TYPE="text/css">
<!--
td.judtab { background-color:#FFFFFF }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
// 入力チェック
function checkData() {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var ret    = false;					// 関数戻り値
	
	// 受診日入力チェック
	for ( ; ; ) {

		if ( !isDate( myForm.cslYear.value, myForm.cslMonth.value, myForm.cslDay.value ) ) {
			alert('受診日の形式に誤りがあります。');
			break;
		}

		// 管理番号入力チェック
/*
		if ( myForm.cntlNo.value != '' ) {
			if ( !myForm.cntlNo.value.match('^[0-9]+$') ) {
				alert('管理番号には1～9999の値を入力して下さい。');
				break;
			}
		}
*/
		// 当日ID入力チェック
		if ( myForm.dayId.value != '' ) {
			if ( !myForm.dayId.value.match('^[0-9]+$') ) {
				alert('当日ＩＤには1～9999の値を入力して下さい。');
				break;
			}
		}

		// 当日IDの入力有無でACTION先を可変させる
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
			<TD COLSPAN="2"><FONT SIZE="+2"><B>判定支援</B></FONT></TD>
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
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder">判定を入力する</SPAN><BR><BR></TD>
		</TR>
		<TR>
			<TD>受診日</TD>
			<TD>：</TD>
			<TD COLSPAN="2">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Now()), False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("cslMonth", 1, 12, Month(Now()), False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("cslDay", 1, 31, Day(Now()), False) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>当日ＩＤ</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="dayId" SIZE="<%= TextLength(4) %>" MAXLENGTH="4" STYLE="text-align:left;ime-mode:disabled;"></TD>
			<TD><FONT COLOR="#999999">（※未入力時には受診者一覧を表示します）</FONT></TD>
		</TR>
		<TR>
			<TD COLSPAN="4">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>の個人一覧を</TD>
						<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定条件で表示"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="4"><INPUT TYPE="checkbox" NAME="badJud" VALUE="1">判定が悪い人のみ表示</TD>
		</TR>
		<TR>
			<TD COLSPAN="4"><INPUT TYPE="checkbox" NAME="unFinished" VALUE="1">判定未完了者のみ表示</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
-->
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/judgement/judAutoSet.asp"><IMG SRC="/webHains/images/keyenter2.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/judgement/judAutoSet.asp">判定支援</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">各検査項目の値を参照し、判定支援を行います。</TD>
		</TR>
<!--
		<TR>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="200" BORDER="0"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/report/reportSendCheck.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/report/reportSendCheck.asp">成績書発送確認</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">成績書の発送確認を行います。</TD>
		</TR>
		<TR>
			<TD HEIGHT="30"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="2"><A HREF="/webHains/contents/report/inqReportsInfo.asp"><IMG SRC="/webHains/images/barcode.jpg" WIDTH="80" HEIGHT="60"></A></TD>
			<TD ROWSPAN="2" WIDTH="15"></TD>
			<TD COLSPAN="4"><SPAN STYLE="font-size:16px;font-weight:bolder"><A HREF="/webHains/contents/report/inqReportsInfo.asp">成績書作成進捗確認</A></SPAN></TD>
		</TR>
		<TR>
			<TD COLSPAN="4" VALIGN="top">成績書作成の進捗確認を行います。</TD>
		</TR>
-->
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
