<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		予約枠コピー(コピー元条件の指定) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim objSchedule			'スケジュール情報アクセス用

'引数値
Dim strCslYear			'受診年
Dim strCslMonth			'受診月
Dim strCslDay			'受診日
Dim strCsCd				'コースコード
Dim strRsvGrpCd			'予約群コード
Dim strNext				'「次へ」ボタン押下の有無
Dim strNoRec			'次画面においてレコードなしと判断された場合に値が格納される

Dim strArrCsCd			'コースコード
Dim strArrCsName		'コース名称
Dim lngCsCount			'コース数

Dim strArrRsvGrpCd		'予約群コード
Dim strArrRsvGrpName	'予約群名称
Dim lngRsvGrpCount		'予約群数

Dim strCslDate			'受診年月日
Dim strMessage			'エラーメッセージ
Dim strURL				'ジャンプ先のURL

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strCslYear  = Request("cslYear")
strCslMonth = Request("cslMonth")
strCslDay   = Request("cslDay")
strCsCd     = Request("csCd")
strRsvGrpCd = Request("rsvGrpCd")
strNext     = Request("next.x")
strNoRec    = Request("noRec")

'受診年月日のデフォルト設定
strCslYear  = IIf(strCslYear  <> "", strCslYear,  Year(Date))
strCslMonth = IIf(strCslMonth <> "", strCslMonth, Month(Date))
strCslDay   = IIf(strCslDay   <> "", strCslDay,   Day(Date))

'チェック・更新・読み込み処理の制御
Do

	'次画面においてレコードなしと判断された場合
	If strNoRec <> "" Then
		strMessage = "この条件を満たす予約人数情報は登録されていません。"
		Exit Do
	End If

	'「次へ」ボタン押下時以外は何もしない
	If strNext = "" Then
		Exit Do
	End If

	'受診日チェック
	strCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay
	If Not IsDate(strCslDate) Then
		strMessage = "コピー元受診日の入力形式が正しくありません。"
		Exit Do
	End If

	'次画面へリダイレクト
	strURL = "rsvFraCopy2.asp"
	strURL = strURL & "?cslYear="  & strCslYear
	strURL = strURL & "&cslMonth=" & strCslMonth
	strURL = strURL & "&cslDay="   & strCslDay
	strURL = strURL & "&csCd="     & strCsCd
	strURL = strURL & "&rsvGrpCd=" & strRsvGrpCd
	Response.Redirect strURL
	Response.End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>予約枠コピー</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY >

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" action="#">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">予約枠コピー</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="110" NOWRAP>コピー元受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear','cslMonth','cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, strCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("cslMonth", 1, 12, strCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("cslDay", 1, 31, strCslDay, False) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>
<%
	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

	'予約群管理コース情報の読み込み
	lngCsCount = objSchedule.SelectCourseListRsvGrpManaged(strArrCsCd, strArrCsName)
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="110" NOWRAP>コースコード</TD>
			<TD>：</TD>
			<TD><%= EditDropDownListFromArray("csCd", strArrCsCd, strArrCsName, strCsCd, NON_SELECTED_ADD) %></TD>
		</TR>
	</TABLE>
<%
	'予約群情報読み込み
	lngRsvGrpCount = objSchedule.SelectRsvGrpList(0, strArrRsvGrpCd, strArrRsvGrpName)

	Set objSchedule = Nothing
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="110" NOWRAP>予約群</TD>
			<TD>：</TD>
			<TD><%= EditDropDownListFromArray("rsvGrpCd", strArrRsvGrpCd, strArrRsvGrpName, strRsvGrpCd, NON_SELECTED_ADD) %></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<% If Session("PAGEGRANT") = "4" Then %>
        <INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ">
    <% End IF %>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>