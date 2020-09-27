<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   朝レポート照会  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス

'パラメータ
Dim lngCslYear			'受診日(年)
Dim lngCslMonth			'受診日(月)
Dim lngCslDay			'受診日(日)
Dim strCsCd				'コースコード
Dim blnNeedUnReceipt	'未受付者取得フラグ(True:当日ＩＤ未発番状態も取得)

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")

'引数値の取得
lngCslYear			= CLng("0" & Request("cslYear") )
lngCslMonth			= CLng("0" & Request("cslMonth"))
lngCslDay			= CLng("0" & Request("cslDay")  )
strCsCd				= Request("csCd")
blnNeedUnReceipt	= IIf(Request("NeedUnReceipt")="True", True, False)

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>朝レポート照会</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/Date.inc"     -->
<!--
// 表示
function callMorningReport() {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var url;							// URL文字列

	// 受診日入力チェック
	if ( !isDate( myForm.cslYear.value, myForm.cslMonth.value, myForm.cslDay.value ) ) {
		alert('受診日の形式に誤りがあります。');
		return;
	}

	url = '/WebHains/contents/morningreport/MorningReportMain.asp';
	url = url + '?cslYear=' + myForm.cslYear.value;
	url = url + '&cslMonth=' + myForm.cslMonth.value;
	url = url + '&cslDay=' + myForm.cslDay.value;
	url = url + '&csCd=' + myForm.csCd.value;
	if ( myForm.NeedUnReceipt.checked ) {
		url = url + '&NeedUnReceipt=True';
	} else {
		url = url + '&NeedUnReceipt=False';
	}

	parent.location.href(url);
}
//-->
</SCRIPT>
<style type="text/css">
	td.toujitsutab    { background-color:#ffffff }
	div.maindiv { margin: 10px 10px 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:calGuide_closeGuideCalendar()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<div class="maindiv">
	<!-- タイトルの表示 -->
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">朝レポート照会</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<!-- 指定受診日、コースの表示 -->
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR HEIGHT="25">
			<TD NOWRAP>受診日</TD>
			<TD NOWRAP WIDTH="15">：</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
					<TR>
						<TD><A HREF="JavaScript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR HEIGHT="25">
			<TD NOWRAP>コース</TD>
			<TD NOWRAP WIDTH="15">：</TD>
			<TD NOWRAP COLSPAN="8">
				<%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %>
				<INPUT TYPE="CHECKBOX" NAME="NeedUnReceipt" <%=IIF(blnNeedUnReceipt=True,"CHECKED","") %>>当日ＩＤ未発番状態のデータも表示対象とする
			</TD>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="30" BORDER="0"></TD>
			<TD NOWRAP><A HREF="JavaScript:callMorningReport()"><IMG SRC="../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></A></TD>
		</TR>
	</TABLE>

</div>
</FORM>
</BODY>
</HTML>
