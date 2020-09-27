<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		面接日の入力(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objCommon			'共通クラス
Dim objPerson			'個人情報用
Dim objFree				'汎用情報用
Dim objAfterCare		'アフターケア用

'-----------------------------------------------------------------------------
' 変数宣言
'-----------------------------------------------------------------------------
Dim strPerId			'個人ＩＤ
Dim lngDataYear			'面接年
Dim lngDataMonth 		'面接月
Dim lngDataDay			'面接日

'個人情報
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strBirth			'生年月日
Dim strGender			'性別
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgKName			'団体カナ名称
Dim strOrgName			'団体漢字名称
Dim strOrgSName			'団体略称
Dim strOrgBsdCd			'事業所コード
Dim strOrgBsdKName		'事業部カナ名称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomCd		'室部コード
Dim strOrgRoomName		'室部名称
Dim strOrgRoomKName		'室部カナ名称
Dim strOrgPostCd		'所属部署コード
Dim strOrgPostName		'所属名称
Dim strOrgPostKName		'所属カナ名称
Dim strJobName			'職名
Dim strEmpNo			'従業員番号

Dim strArrContactDate	'面接日
Dim strArrRsvNo			'予約番号

Dim strDispPerName		'個人名称（漢字）
Dim strDispPerKName		'個人名称（カナ）
Dim strDispAge			'年齢（表示用）
Dim strDispBirth		'生年月日（表示用）
Dim strDate				'チェック用日付ワーク

Dim lngAfteCareCount	'アフターケア検索カウント

Dim strMessage			'メッセージ
Dim strURL				'URL文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")

strPerId     = Request("perId")
lngDataYear  = CLng("0" & Request("dataYear"))
lngDataMonth = CLng("0" & Request("dataMonth"))
lngDataDay   = CLng("0" & Request("dataDay"))

'デフォルト値の設定
lngDataYear  = IIf(lngDataYear  = 0, Year(Date),  lngDataYear )
lngDataMonth = IIf(lngDataMonth = 0, Month(Date), lngDataMonth)
lngDataDay   = IIf(lngDataDay   = 0, Day(Date),   lngDataDay  )

Do

	'「次へ」ボタンが押された場合以外は何もしない
	If Request("next.x") = "" Then
		Exit Do
	End If

	'面接年月日の編集
	strDate = lngDataYear & "/" & lngDataMonth & "/" & lngDataDay

	'面接年月日の日付チェック
	If Not IsDate(strDate) Then
		strMessage = "面接日の入力形式が正しくありません。"
		Exit Do
	End If

	'指定個人ＩＤ、面接日のアフターケア情報が存在するかをチェック
	strArrContactDate = strDate
	lngAfteCareCount = objAfterCare.SelectAfterCare(strPerId, strArrContactDate, , , strArrRsvNo)

	'面接情報の登録画面へ
	strURL = "/webHains/contents/aftercare/AfterCareInterview.asp"
	strURL = strURL & "?disp="        & "1"
	strURL = strURL & "&perId="       & strPerId
	strURL = strURL & "&contactDate=" & strDate
	Response.Redirect strURL
	Response.End

	Exit Do
Loop

'オブジェクトのインスタンス作成
Set objPerson = Server.CreateObject("HainsPerson.Person")
Set objFree   = Server.CreateObject("HainsFree.Free")

'個人情報読み込み
objPerson.SelectPerson strPerId,     strLastName,    strFirstName,    _
					   strLastKName, strFirstKName,  strBirth,        _
					   strGender,    strOrgCd1,      strOrgCd2,       _
					   strOrgKName,  strOrgName,     strOrgSName,     _
					   strOrgBsdCd,  strOrgBsdKName, strOrgBsdName,   _
					   strOrgRoomCd, strOrgRoomName, strOrgRoomKName, _
					   strOrgPostCd, strOrgPostName, strOrgPostKName, _
					   , strJobName, , , , , _
					   strEmpNo, Empty, Empty

'表示用名称の編集
strDispPerName 	= Trim(strLastName & "　" & strFirstName)
strDispPerKName = Trim(strLastKName & "　" & strFirstKName)

'年齢の算出
strDispAge = objFree.CalcAge(strBirth, Date, "")

'和暦編集
strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

'性別
strGender = IIf(strGender = CStr(GENDER_MALE), "男性", "女性")

'表示内容の編集
strDispBirth = strDispBirth & "生　" & strDispAge & "歳　" & strGender

'オブジェクトのインスタンスの開放
Set objPerson = Nothing
Set objFree = Nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>面接日の入力</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">面接日の入力</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP><%= strEmpNo %></TD>
			<TD NOWRAP><B><%= strDispPerName %></B> (<FONT SIZE="-1"><%= strDispPerKName %></FONT>)</TD>
		<TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= strDispBirth %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right" NOWRAP>団体：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP><%= strOrgName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;所属：</TD>
						<TD NOWRAP><%= strOrgPostName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;職種：</TD>
						<TD NOWRAP><%= strJobName %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR><FONT COLOR="#cc9999">●</FONT>&nbsp;面接日を入力して下さい。<BR><BR>

	<TABLE BORDER="0" CELLPADDING="" CELLSPACING="2">
		<TR>
			<TD NOWRAP>面接日：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('dataYear', 'dataMonth', 'dataDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("dataYear", YEARRANGE_MIN, YEARRANGE_MAX, lngDataYear , false) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("dataMonth", 1, 12, lngDataMonth, false) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("dataDay", 1, 31, lngDataDay, false) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<BR>

	<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
	<INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ">

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>