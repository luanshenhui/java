<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		個人就労情報メンテナンス (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objPerson			'個人情報アクセス用
Dim objPerWorkInfo		'個人就労情報アクセス用

'引数部
Dim strPerId			'個人ＩＤ
Dim lngStrYear			'開始年
Dim lngStrMonth			'開始月
Dim lngEndYear			'終了年
Dim lngEndMonth			'終了月

'個人就労情報
Dim strDataDate			'データ年月
Dim strNightWorkCount	'夜業回数
Dim strOverTime			'時間外就労時間
Dim lngCount			'レコード数

'個人情報
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓	
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strAge				'年齢
Dim strGender			'性別
Dim strGenderName		'性別名称

Dim dtmStrDataDate		'開始データ年月
Dim dtmEndDataDate		'終了データ年月
Dim i					'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon      = Server.CreateObject("HainsCommon.Common")
Set objPerWorkInfo = Server.CreateObject("HainsPerWorkInfo.PerWorkInfo")

'引数値の取得
strPerId    = Request("perId")
lngStrYear  = CLng("0" & Request("strYear"))
lngStrMonth = CLng("0" & Request("strMonth"))
lngEndYear  = CLng("0" & Request("endYear"))
lngEndMonth = CLng("0" & Request("endMonth"))

'開始・終了年月のデフォルト値設定(直近１年分)
lngStrYear  = IIf(lngStrYear  = 0, Year(DateAdd("m",  -11, Date)),  lngStrYear)
lngStrMonth = IIf(lngStrMonth = 0, Month(DateAdd("m", -11, Date)), lngStrMonth)
lngEndYear  = IIf(lngEndYear  = 0, Year(Date),  lngEndYear)
lngEndMonth = IIf(lngEndMonth = 0, Month(Date), lngEndMonth)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>個人就労情報メンテナンス</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winPerWorkInfo;	// 個人就労情報登録画面のウィンドウハンドル

// 個人就労情報登録画面呼び出し
function callPerWorkInfoWindow( dataYear, dataMonth ) {

	var opened = false;					// 画面が開かれているか
	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var url;							// 団体・コース変更画面のURL

	// すでにガイドが開かれているかチェック
	if ( winPerWorkInfo != null ) {
		if ( !winPerWorkInfo.closed ) {
			opened = true;
		}
	}

	// 個人就労情報登録画面のURL編集
	url = 'mntPerWorkInfo.asp';
	if ( dataYear && dataMonth ) {
		url = url + '?mode='      + 'update';
		url = url + '&dataYear='  + dataYear;
		url = url + '&dataMonth=' + dataMonth;
	} else {
		url = url + '?mode='     + 'insert';
	}
	url = url + '&perId=' + myForm.perId.value;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winPerWorkInfo.focus();
		winPerWorkInfo.location.replace();
	} else {
		winPerWorkInfo = window.open( url, '', 'status=yes,toolbar=no,directories=no,menubar=no,resizable=yes,scrollbars=yes,width=600,height=330' );
	}

}

// 画面を閉じる
function closeWindow() {

	// 個人就労情報登録画面を閉じる
	if ( winPerWorkInfo ) {
		if ( !winPerWorkInfo.closed ) {
			winPerWorkInfo.close();
		}
	}

	winPerWorkInfo = null;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">個人就労情報メンテナンス</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'個人情報読み込み
	Set objPerson = Server.CreateObject("HainsPerson.Person")
	objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, strGenderName, strAge
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="650">
		<TR>
			<TD NOWRAP><%= strPerId %></TD>
			<TD WIDTH="100%" NOWRAP><B><%= Trim(strLastName & "　" & strFirstName) %></B> （<FONT SIZE="-1"><%= Trim(strLastKName & "　" & strFirstKName) %></FONT>）</TD>
			<TD ROWSPAN="2" VALIGN="top" ALIGN="right"><A HREF="mntPersonal.asp?mode=update&perId=<%= strPerId %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="個人情報メンテナンス画面に戻ります"></A></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD WIDTH="100%" NOWRAP><%= objCommon.FormatString(strBirth, "gee.mm.dd") %>生　<%= strAge %>歳　<%= strGenderName %></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">個人就労情報の一覧</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
			<TD NOWRAP>月～</TD>
			<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
			<TD NOWRAP>月の個人就労情報を</TD>
			<TD><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></TD>
			<TD WIDTH="100%" ALIGN="right"><A HREF="javascript:callPerWorkInfoWindow()"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新しい個人就労情報を登録します"></A></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
		</TR>
	</TABLE>
<%
	Do

		'データ年月の設定
		dtmStrDataDate = CDate(lngStrYear & "/" & lngStrMonth & "/1")
		dtmEndDataDate = CDate(lngEndYear & "/" & lngEndMonth & "/1")

		'個人就労情報読み込み
		lngCount = objPerWorkInfo.SelectPerWorkInfoList(strPerId, dtmStrDataDate, dtmEndDataDate, strDataDate, strNightWorkCount, strOverTime)
		If lngCount <= 0 Then
%>
			検索条件を満たす個人就労情報は存在しません。
<%
			Exit Do
		End If
%>
		<BR>

		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD NOWRAP>年月</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>夜業回数</TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>時間外就労時間</TD>
			</TR>
			<TR>
				<TD BGCOLOR="#999999" COLSPAN="5"></TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
					<TD NOWRAP><A HREF="javascript:callPerWorkInfoWindow('<%= Year(strDataDate(i)) %>','<%= Month(strDataDate(i)) %>')"><%= objCommon.FormatString(strDataDate(i), "yyyy年mm月") %></A></TD>
					<TD></TD>
					<TD ALIGN="right" NOWRAP><%= strNightWorkCount(i) %>回</TD>
					<TD></TD>
					<TD ALIGN="right"><%= objCommon.FormatString(strOverTime(i), "0.0") %>時間</TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
