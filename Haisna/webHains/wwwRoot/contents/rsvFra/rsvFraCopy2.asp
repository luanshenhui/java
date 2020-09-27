<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		予約枠コピー(コピー先条件の指定) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim objCourse			'コース情報アクセス用
Dim objSchedule			'スケジュール情報アクセス用

'引数値
Dim strCslYear			'コピー元受診年
Dim strCslMonth			'コピー元受診月
Dim strCslDay			'コピー元受診日
Dim strCsCd				'コースコード
Dim strRsvGrpCd			'予約群コード

Dim strStrCslYear		'コピー先開始受診年
Dim strStrCslMonth		'コピー先開始受診月
Dim strStrCslDay		'コピー先開始受診日
Dim strEndCslYear		'コピー先終了受診年
Dim strEndCslMonth		'コピー先終了受診月
Dim strEndCslDay		'コピー先終了受診日
Dim strWeekday			'曜日フラグ
Dim strUpdFlg			'上書きフラグ
Dim strCopy				'「コピー」ボタン押下の有無
Dim strCount			'レコード件数

'予約人数情報
Dim strArrCsName		'コース名
Dim strWebColor			'webカラー
Dim strArrRsvGrpName	'予約群名称
Dim strMaxCnt			'予約可能人数（共通）
Dim strMaxCnt_M			'予約可能人数（男）
Dim strMaxCnt_F			'予約可能人数（女）
Dim strOverCnt			'オーバ可能人数（共通）
Dim strOverCnt_M		'オーバ可能人数（男）
Dim strOverCnt_F		'オーバ可能人数（女）
Dim strRsvCnt_M			'予約済み人数（男）
Dim strRsvCnt_F			'予約済み人数（女）
Dim lngRsvFraCount		'予約人数情報レコード数

Dim strCsName			'コース名
Dim strRsvGrpName		'予約群名称
Dim dtmCslDate			'コピー元受診年月日
Dim dtmStrCslDate		'コピー先開始受診年月日
Dim dtmEndCslDate		'コピー先開始受診年月日
Dim strMessage			'エラーメッセージ
Dim lngMessageType		'メッセージ種類
Dim strURL				'ジャンプ先のURL
Dim Ret					'関数戻り値
Dim i					'インデックス
Dim strDmy(6)			'ダミー変数

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
ReDim strWeekday(6)

'引数値の取得
strCslYear     = Request("cslYear")
strCslMonth    = Request("cslMonth")
strCslDay      = Request("cslDay")
strCsCd        = Request("csCd")
strRsvGrpCd    = Request("rsvGrpCd")

strStrCslYear  = Request("strCslYear")
strStrCslMonth = Request("strCslMonth")
strStrCslDay   = Request("strCslDay")
strEndCslYear  = Request("endCslYear")
strEndCslMonth = Request("endCslMonth")
strEndCslDay   = Request("endCslDay")
strWeekDay(0)  = Request("mon")
strWeekDay(1)  = Request("tue")
strWeekDay(2)  = Request("wed")
strWeekDay(3)  = Request("thu")
strWeekDay(4)  = Request("fri")
strWeekDay(5)  = Request("sat")
strWeekDay(6)  = Request("sun")
strUpdFlg      = Request("upd")
strCopy        = Request("copy.x")
strCount       = Request("count")

'受診年月日のデフォルト設定
strStrCslYear  = IIf(strStrCslYear  <> "", strStrCslYear,  Year(Date))
strStrCslMonth = IIf(strStrCslMonth <> "", strStrCslMonth, Month(Date))
strStrCslDay   = IIf(strStrCslDay   <> "", strStrCslDay,   Day(Date))
strEndCslYear  = IIf(strEndCslYear  <> "", strEndCslYear,  Year(Date))
strEndCslMonth = IIf(strEndCslMonth <> "", strEndCslMonth, Month(Date))
strEndCslDay   = IIf(strEndCslDay   <> "", strEndCslDay,   Day(Date))

'コピー元受診日の編集
dtmCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)

'チェック・更新・読み込み処理の制御
Do

	'レコード変数が渡されている場合はメッセージを編集
	If strCount <> "" Then
		If CLng(strCount) > 0 Then
			strMessage = strCount & "件の予約枠情報が作成／更新されました。"
		Else
			strMessage = "予約枠は作成されませんでした。"
		End If
		lngMessageType = MESSAGETYPE_NORMAL
		Exit Do
	End If

	'「コピー」ボタン押下時以外は何もしない
	If strCopy = "" Then
		Exit Do
	End If

	'入力チェック
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		lngMessageType = MESSAGETYPE_WARNING
		Exit Do
	End If

	'コピー先受診年月日の編集
	dtmStrCslDate = CDate(strStrCslYear & "/" & strStrCslMonth & "/" & strStrCslDay)
	dtmEndCslDate = CDate(strEndCslYear & "/" & strEndCslMonth & "/" & strEndCslDay)

	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

	'コピー
	Ret = objSchedule.CopyRsvFraMng(dtmCslDate, strCsCd, strRsvGrpCd, dtmStrCslDate, dtmEndCslDate, strWeekday, (strUpdFlg <> ""))

	Set objSchedule = Nothing

	'自画面をリダイレクト
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?cslYear="     & strCslYear
	strURL = strURL & "&cslMonth="    & strCslMonth
	strURL = strURL & "&cslDay="      & strCslDay
	strURL = strURL & "&csCd="        & strCsCd
	strURL = strURL & "&rsvGrpCd="    & strRsvGrpCd
	strURL = strURL & "&strCslYear="  & strStrCslYear
	strURL = strURL & "&strCslMonth=" & strStrCslMonth
	strURL = strURL & "&strCslDay="   & strStrCslDay
	strURL = strURL & "&endCslYear="  & strEndCslYear
	strURL = strURL & "&endCslMonth=" & strEndCslMonth
	strURL = strURL & "&endCslDay="   & strEndCslDay
	strURL = strURL & "&mon="         & strWeekday(0)
	strURL = strURL & "&tue="         & strWeekday(1)
	strURL = strURL & "&wed="         & strWeekday(2)
	strURL = strURL & "&thu="         & strWeekday(3)
	strURL = strURL & "&fri="         & strWeekday(4)
	strURL = strURL & "&sat="         & strWeekday(5)
	strURL = strURL & "&sun="         & strWeekday(6)
	strURL = strURL & "&upd="         & strUpdFlg
	strURL = strURL & "&count="       & Ret
	Response.Redirect strURL
	Response.End

	Exit Do
Loop

Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'予約人数管理レコード読み込み
lngRsvFraCount = objSchedule.SelectRsvFraMngList(dtmCslDate, dtmCslDate, strCsCd, strRsvGrpCd, , , strArrCsName, strWebColor, , strArrRsvGrpName, , strMaxCnt, strMaxCnt_M, strMaxCnt_F, strOverCnt, strOverCnt_M, strOverCnt_F, strRsvCnt_M, strRsvCnt_F)

Set objSchedule = Nothing

'コピー元となるべき予約人数情報が存在しない場合
If lngRsvFraCount <= 0 Then

	'前画面に戻る
	strURL = "rsvFraCopy1.asp"
	strURL = strURL & "?cslYear="  & strCslYear
	strURL = strURL & "&cslMonth=" & strCslMonth
	strURL = strURL & "&cslDay="   & strCslDay
	strURL = strURL & "&csCd="     & strCsCd
	strURL = strURL & "&rsvGrpCd=" & strRsvGrpCd
	strURL = strURL & "&noRec="    & "1"
	Response.Redirect strURL
	Response.End

End If
'-------------------------------------------------------------------------------
'
' 機能　　 : 入力チェック
'
' 引数　　 :
'
' 戻り値　 : エラーメッセージの配列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'共通クラス

	Dim strStrCslDate	'開始受診年月日
	Dim strEndCslDate	'終了受診年月日
	Dim strArrMessage	'エラーメッセージの配列
	Dim strMessage		'エラーメッセージ
	Dim blnDateError	'日付にエラーがあるか
	Dim blnCheckWeekday	'曜日チェックの要否
	Dim blnChecked		'対象曜日がチェックされていればTrue
	Dim i				'インデックス

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'コピー先開始受診日チェック
	strStrCslDate = strStrCslYear & "/" & strStrCslMonth & "/" & strStrCslDay
	If Not IsDate(strStrCslDate) Then
		objCommon.AppendArray strArrMessage, "コピー元開始受診日の入力形式が正しくありません。"
		blnDateError = True
	End If

	'コピー先終了受診日チェック
	strEndCslDate = strEndCslYear & "/" & strEndCslMonth & "/" & strEndCslDay
	If Not IsDate(strEndCslDate) Then
		objCommon.AppendArray strArrMessage, "コピー元終了受診日の入力形式が正しくありません。"
		blnDateError = True
	End If

	'曜日チェック要否の判定

	'日付エラー時はチェック対象とし、日付正常時は日付が範囲で指定されている場合のみチェック対象とする
	If blnDateError Then
		blnCheckWeekday = True
	Else
		blnCheckWeekday = (strStrCslDate <> strEndCslDate)
	End If

	'曜日チェック
	If blnCheckWeekday Then

		'対象曜日が指定されているかをチェック
		blnChecked = False
		For i = 0 To UBound(strWeekday)
			If strWeekday(i) <> "" Then
				blnChecked = True
			End If
		Next

		'すべて未チェックの場合
		If Not blnChecked Then
			objCommon.AppendArray strArrMessage, "対象曜日を選択してください。"
		End If

	End If

	'チェック結果を返す
	CheckValue = strArrMessage

	Set objCommon = Nothing

End Function
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
</HEAD>
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
<BODY >
<BASEFONT SIZE="2">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ONSUBMIT="javascript:return confirm('この内容で予約枠のコピーを行います。よろしいですか？')" action="#">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="cslYear"  VALUE="<%= strCslYear  %>">
	<INPUT TYPE="hidden" NAME="cslMonth" VALUE="<%= strCslMonth %>">
	<INPUT TYPE="hidden" NAME="cslDay"   VALUE="<%= strCslDay   %>">
	<INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd     %>">
	<INPUT TYPE="hidden" NAME="rsvGrpCd" VALUE="<%= strRsvGrpCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="635">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">予約枠のコピー</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, lngMessageType)
%>
	<BR>

	<FONT SIZE="+1"><FONT COLOR="#cc9999">●</FONT>コピー先情報を設定してください。</FONT><BR>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>コピー先範囲</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear','strCslMonth','strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strStrCslYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("strCslMonth", 1, 12, strStrCslMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("strCslDay", 1, 31, strStrCslDay, False) %></TD>
						<TD>日</TD>
						<TD>～</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear','endCslMonth','endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strEndCslYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("endCslMonth", 1, 12, strEndCslMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("endCslDay", 1, 31, strEndCslDay, False) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>対象曜日</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="mon" VALUE="1"<%= IIf(strWeekDay(0) <> "", " CHECKED", "") %>></TD><TD>月<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="tue" VALUE="1"<%= IIf(strWeekDay(1) <> "", " CHECKED", "") %>></TD><TD>火<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="wed" VALUE="1"<%= IIf(strWeekDay(2) <> "", " CHECKED", "") %>></TD><TD>水<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="thu" VALUE="1"<%= IIf(strWeekDay(3) <> "", " CHECKED", "") %>></TD><TD>木<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="fri" VALUE="1"<%= IIf(strWeekDay(4) <> "", " CHECKED", "") %>></TD><TD>金<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="sat" VALUE="1"<%= IIf(strWeekDay(5) <> "", " CHECKED", "") %>></TD><TD>土<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
						<TD><INPUT TYPE="checkbox" NAME="sun" VALUE="1"<%= IIf(strWeekDay(6) <> "", " CHECKED", "") %>></TD><TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD NOWRAP><FONT COLOR="#999999">（コピー先範囲が単一日の場合、この指定は無視されます。）</FONT></TD>
		</TR>
		<TR>
			<TD>処理モード</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="upd" VALUE="1"<%= IIf(strUpdFlg <> "", " CHECKED", "") %>></TD>
						<TD NOWRAP>既に枠情報が存在する場合、上書きする</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>
<%
	'前画面のURL編集
	strURL = "rsvFraCopy1.asp"
	strURL = strURL & "?cslYear="  & strCslYear
	strURL = strURL & "&cslMonth=" & strCslMonth
	strURL = strURL & "&cslDay="   & strCslDay
	strURL = strURL & "&csCd="     & strCsCd
	strURL = strURL & "&rsvGrpCd=" & strRsvGrpCd
%>
	<A HREF="<%= strURL %>"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="コピー元条件指定に戻る"></A>
	
    <% If Session("PAGEGRANT") = "4" Then %>
        <INPUT TYPE="image" NAME="copy" SRC="/webHains/images/copy.gif" WIDTH="77" HEIGHT="24" ALT="この内容で予約枠のコピーを行う">
    <% End IF %>

	</BLOCKQUOTE>
</FORM>

<BLOCKQUOTE>

<FONT SIZE="+1"><FONT COLOR="#cc9999">●</FONT>（コピー元情報）「<FONT COLOR="#ff6600"><B><%= strCslYear %>年<%= strCslMonth %>月<%= strCslDay %>日</B></FONT>」
<%
'コース指定時は名称を取得
If strCsCd <> "" Then

	Set objCourse = Server.CreateObject("HainsCourse.Course")
	objCourse.SelectCourse strCsCd, strCsName
	Set objCourse = Nothing
%>
	「<FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT>」
<%
End If

'予約群指定時は名称を取得
If strRsvGrpCd <> "" Then

	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")
	objSchedule.SelectRsvGrp strRsvGrpCd, strRsvGrpName, strDmy(0), strDmy(1), strDmy(2), strDmy(3), strDmy(4), strDmy(5), strDmy(6)	'ショック。Optional指定がなかったのです。
	Set objSchedule = Nothing
%>
	「<FONT COLOR="#ff6600"><B><%= strRsvGrpName %></B></FONT>」
<%
End If
%>
の予約枠一覧</FONT><BR><BR>

<FONT SIZE="+1"><FONT COLOR="#ff6600"><B><%= lngRsvFraCount %></B></FONT>件のレコードがあります。</FONT><BR><BR>

<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
	<TR BGCOLOR="#cccccc" ALIGN="center">
		<TD ROWSPAN="2" NOWRAP>受診日</TD>
		<TD ROWSPAN="2" NOWRAP>受診コース</TD>
		<TD ROWSPAN="2" NOWRAP>予約群</TD>
		<TD COLSPAN="3" NOWRAP>予約可能人数</TD>
		<TD COLSPAN="3" NOWRAP>オーバ可能人数</TD>
		<TD COLSPAN="2" NOWRAP>予約済み人数</TD>
	</TR>
	<TR BGCOLOR="cccccc" ALIGN="center">
		<TD WIDTH="50" NOWRAP>共通</TD>
		<TD WIDTH="50" NOWRAP>男</TD>
		<TD WIDTH="50" NOWRAP>女</TD>
		<TD WIDTH="50" NOWRAP>共通</TD>
		<TD WIDTH="50" NOWRAP>男</TD>
		<TD WIDTH="50" NOWRAP>女</TD>
		<TD WIDTH="50" NOWRAP>男</TD>
		<TD WIDTH="50" NOWRAP>女</TD>
	</TR>
<%
	For i = 0 To lngRsvFraCount - 1
%>
		<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>" ALIGN="right">
			<TD ALIGN="left" NOWRAP><%= dtmCslDate %></TD>
			<TD ALIGN="left" NOWRAP><FONT COLOR="#<%= strWebColor(i) %>">■</FONT><%= strArrCsName(i) %></TD>
			<TD ALIGN="left" NOWRAP><%= strArrRsvGrpName(i) %></TD>
			<TD NOWRAP><%= strMaxCnt(i)    %></TD> 
			<TD NOWRAP><%= strMaxCnt_M(i)  %></TD>
			<TD NOWRAP><%= strMaxCnt_F(i)  %></TD>
			<TD NOWRAP><%= strOverCnt(i)   %></TD>
			<TD NOWRAP><%= strOverCnt_M(i) %></TD>
			<TD NOWRAP><%= strOverCnt_F(i) %></TD>
			<TD NOWRAP><%= strRsvCnt_M(i)  %></TD>
			<TD NOWRAP><%= strRsvCnt_F(i)  %></TD>
		</TR>
<%
	Next
%>
</TABLE>

</BLOCKQUOTE>
</BODY>
</HTML>