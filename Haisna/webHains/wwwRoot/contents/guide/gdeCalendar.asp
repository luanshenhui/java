<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		日付の選択 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<%
'セッションチェック
'Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objSchedule 	'スケジュール情報アクセス用

'引数値
Dim lngYear			'年
Dim lngMonth		'月
Dim strEntryDate	'入力された日付

'病院スケジュール情報
Dim dtmStrDate		'読み込み開始日付
Dim dtmEndDate		'読み込み終了日付
Dim vntCslDate		'受診日
Dim vntHoliday		'休診日
Dim lngCount		'レコード数

Dim strYear			'入力された日付(年)
Dim strMonth		'入力された日付(月)
Dim strDay			'入力された日付(日)
Dim lngCurYear		'現在編集中の年
Dim lngCurMonth		'現在編集中の月
Dim lngDateArray	'カレンダー日付配列
Dim dtmDate			'作業用の日付
Dim strHTML			'HTML文字列
Dim i, j, k			'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'引数の取得
lngYear      = CLng("0" & Request("year") )
lngMonth     = CLng("0" & Request("month"))
strEntryDate = Request("entryDate")

'省略時はシステム年月を使用
lngYear  = IIf(lngYear  = 0, Year(Now()),  lngYear )
lngMonth = IIf(lngMonth = 0, Month(Now()), lngMonth)

'前月の先頭日からのスケジュール情報を取得
dtmStrDate = DateAdd("m", -1, CDate(lngYear & "/" & lngMonth & "/1"))

'翌月の末日までのスケジュール情報を取得
dtmEndDate = DateAdd("d", -1, DateAdd("m", 3, dtmStrDate))

'病院スケジュール取得
lngCount = objSchedule.SelectSchedule_h(dtmStrDate, dtmEndDate, vntCslDate, vntHoliday)

'日付が入力された場合
If strEntryDate <> "" Then

	'年・月・日に分割
	strYear  = Mid(strEntryDate, 1, 4)
	strMonth = Mid(strEntryDate, 5, 2)
	strDay   = Mid(strEntryDate, 7, 2)

	'呼び元画面に年月日をセットして画面を閉じる
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
	strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.calGuide_setDate(" & strYear & ", " & strMonth & ", " & strDay & "); close()"">"
	strHTML = strHTML & "</BODY>"
	strHTML = strHTML & "</HTML>"
	Response.Write strHTML
	Response.End

End If

'-------------------------------------------------------------------------------
'
' 機能　　 : カレンダー用の日付配列作成
'
' 引数　　 : (In)     lngYear   年
' 　　　　   (In)     lngMonth  月
'
' 戻り値　 : 指定年月のカレンダー日付配列(6行×7列)
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CalendarArray(lngYear, lngMonth)

	Dim lngDateArray(5, 6)	'日付テーブル
	Dim dtmDate				'現在編集中の日付(ポインタ)
	Dim i, j				'インデックス

	For i = 0 To UBound(lngDateArray, 1)
		For j = 0 To UBound(lngDateArray, 2)
			lngDateArray(i, j) = 0
		Next
	Next

	'編集年月の先頭日を編集
	dtmDate = CDate(lngYear & "/" & lngMonth & "/1")

	'日付ポインタが週の先頭(日曜)になるまでポインタを戻す
	Do Until Weekday(dtmDate) = 1
		dtmDate = DateAdd("d", -1, dtmDate)
	Loop

	'配列を編集
	For i = 0 To UBound(lngDateArray, 1)
		For j = 0 To UBound(lngDateArray, 2)

			'日付ポインタの月が編集月と同一の場合のみ日を編集
			If Month(dtmDate) = lngMonth Then
				lngDateArray(i, j) = Day(dtmDate)
			End If

			'日付ポインタを進める
			dtmDate = DateAdd("d", 1, dtmDate)

		Next
	Next

	CalendarArray = lngDateArray

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 日付表示色の設定
'
' 引数　　 : (In)     lngYear   年
' 　　　　   (In)     lngMonth  月
' 　　　　   (In)     lngDay    日
'
' 戻り値　 : 表示色
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function DateColor(lngYear, lngMonth, lngDay)

	Dim dtmDate		'作業用の日付
	Dim lngWeekDay	'曜日(1:日曜～7:土曜)
	Dim strColor	'表示色
	Dim i			'インデックス

	'引数値の内容を日付型変数に編集
	dtmDate = CDate(lngYear & "/" & lngMonth & "/" & lngDay)

	Do
		'引数値がシステム日付と同値の場合
		If dtmDate = Date() Then
			strColor = "today"
			Exit Do
		End If

		'指定日の曜日を求める
		lngWeekDay = Weekday(dtmDate)

		'日曜の場合
		If lngWeekDay = 1 Then
			strColor = "holiday"
			Exit Do
		End If

		'土曜の場合
		If lngWeekDay = 7 Then
			strColor = "saturday"
			Exit Do
		End If

		'それ以外は病院スケジュール情報を検索
		For i = 0 To lngCount - 1

			If CDate(vntCslDate(i)) = dtmDate Then

				'祝日の場合
				If vntHoliday(i) = "2" Then
					strColor = "holiday"
					Exit Do
				End If

				'休診日の場合
				If vntHoliday(i) = "1" Then
					strColor = "kyusin"
					Exit Do
				End If

				Exit For
			End If

		Next

		'どの条件にも該当しない場合
		strColor = "weekday"

		Exit Do
	Loop

	DateColor = strColor

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 数値のSELECTタグ生成
'
' 引数　　 : (In)     strElementName    エレメント
' 　　　　   (In)     lngStartValue     開始値
' 　　　　   (In)     lngEndValue       終了値
' 　　　　   (In)     lngSelectedValue  デフォルトの選択値
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditNumberList(strElementName, lngStartValue, lngEndValue, lngSelectedValue)

	Dim strHTML	'HTML文字列
	Dim i		'インデックス
%>
	<SELECT NAME="<%= strElementName %>" ONCHANGE="javascript:changeDate(document.dateSelector.year.value, document.dateSelector.month.value)">
<%
	'OPTIONタグを編集
	For i = lngStartValue To lngEndValue
		strHTML = strHTML & "<OPTION VALUE=""" & i & """" & IIf(lngSelectedValue = i, " SELECTED", "") & ">" & i
	Next

	Response.Write strHTML
%>
	</SELECT>
<%
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>日付の選択</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/date.inc" -->
<!--
// 年月変更時の処理
function changeDate( year, month ) {

	document.entryForm.year.value  = year;
	document.entryForm.month.value = month;
	document.entryForm.submit();

}

// 日付チェック
function checkDate() {

	var myForm = document.dateSelector;	// 自画面のフォームエレメント
	var year, month, day;				// 年・月・日

	// 8桁入力時以外はsubmitしない
	if ( myForm.entryDate.value.length != 8 ) {
		return false;
	}

	// 日付チェック
	year  = myForm.entryDate.value.substring(0, 4);
	month = myForm.entryDate.value.substring(4, 6);
	day   = myForm.entryDate.value.substring(6, 8);
	return isDate( year, month, day );

}

// 年月日選択時の処理
function selectDate( year, month, day ) {

	var buffer;	// 年月日編集バッファ

	// 年を編集
	buffer = year;

	// 月を連結
	if ( month < 10 ) {
		buffer = buffer + '0';
	}
	buffer = buffer + '' + month;

	// 日を連結
	if ( day < 10 ) {
		buffer = buffer + '0';
	}
	buffer = buffer + '' + day;

	// submit
	document.entryForm.entryDate.value = buffer;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
</STYLE>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="document.dateSelector.entryDate.focus()">
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
<%
		'編集開始年月を前月に設定する
		dtmDate = DateAdd("m", -1, CDate(lngYear & "/" & lngMonth & "/1"))
		lngCurYear  = Year(dtmDate)
		lngCurMonth = Month(dtmDate)

		'指定年月の前月から3ヶ月分のカレンダーを編集
		For i = 1 To 3
%>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD HEIGHT="20" ALIGN="center" VALIGN="bottom" COLSPAN="7"><B><%= lngCurYear %></B>年<B><%= lngCurMonth %></B>月</TD>
					</TR>
					<TR ALIGN="center">
						<TD WIDTH="13" CLASS="holiday" ><B>日</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>月</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>火</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>水</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>木</B></TD>
						<TD WIDTH="13" CLASS="weekday" ><B>金</B></TD>
						<TD WIDTH="13" CLASS="saturday"><B>土</B></TD>
					</TR>
<%
					'カレンダー日付配列の取得
					lngDateArray = CalendarArray(lngCurYear, lngCurMonth)

					'対象年月のカレンダーを編集
					strHTML = ""
					For j = 0 To UBound(lngDateArray, 1)

						strHTML = strHTML & "<TR ALIGN=""right"" BGCOLOR=""#ffffff"">"

						For k = 0 To UBound(lngDateArray, 2)

							'日付が存在する場合のみ編集
							If lngDateArray(j, k) > 0 Then
								strHTML = strHTML & "<TD><A HREF=""javascript:selectDate(" & lngCurYear & ", " & lngCurMonth & ", " & lngDateArray(j, k) & ")"" CLASS=""" & DateColor(lngCurYear, lngCurMonth, lngDateArray(j, k)) & """>" & lngDateArray(j, k) & "</A></TD>"
							Else
								strHTML = strHTML & "<TD>&nbsp;</TD>"
							End If

						Next

						strHTML = strHTML & "</TR>"
					Next

					Response.Write strHTML
%>
				</TABLE>
			</TD>
<%
			If i <> 3 Then
%>
				<TD WIDTH="15"></TD>
<%
			End If

			'編集年月を次月に設定する
			dtmDate = DateAdd("m", 1, CDate(lngCurYear & "/" & lngCurMonth & "/1"))
			lngCurYear  = Year(dtmDate)
			lngCurMonth = Month(dtmDate)

		Next
%>
	</TR>
</TABLE>

<FORM NAME="dateSelector" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="javascript:return checkDate()">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" BGCOLOR="#cccccc" WIDTH="369">
		<TR>
			<TD>
				<TABLE WIDTH="100%" BORDER="0" CELLPADDING="2" CELLSPACING="0" BGCOLOR="#006699">
					<TR>
						<TD ALIGN="center" BGCOLOR="#ffffff">
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
								<TR>
<%
									'編集年月を3ヶ月前に設定する
									dtmDate = DateAdd("m", -3, CDate(lngYear & "/" & lngMonth & "/1"))
									lngCurYear  = Year(dtmDate)
									lngCurMonth = Month(dtmDate)
%>
									<TD><A HREF="javascript:changeDate(<%= lngCurYear %>, <%= lngCurMonth %>)"><IMG SRC="/webHains/images/review.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="前の３ヶ月を表示"></A></TD>
<%
									'編集年月を前月に設定する
									dtmDate = DateAdd("m", -1, CDate(lngYear & "/" & lngMonth & "/1"))
									lngCurYear  = Year(dtmDate)
									lngCurMonth = Month(dtmDate)
%>
									<TD><A HREF="javascript:changeDate(<%= lngCurYear %>, <%= lngCurMonth %>)"><IMG SRC="/webHains/images/replay.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="前月を表示"></A></TD>
									<TD><% Call EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear) %></TD>
									<TD>年</TD>
									<TD><% Call EditNumberList("month", 1, 12, lngMonth) %></TD>
									<TD>月</TD>
<%
									'編集年月を次月に設定する
									dtmDate = DateAdd("m", 1, CDate(lngYear & "/" & lngMonth & "/1"))
									lngCurYear  = Year(dtmDate)
									lngCurMonth = Month(dtmDate)
%>
									<TD><A HREF="javascript:changeDate(<%= lngCurYear %>, <%= lngCurMonth %>)"><IMG SRC="/webHains/images/play.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="次月を表示"></A></TD>
<%
									'編集年月を3ヶ月後に設定する
									dtmDate = DateAdd("m", 3, CDate(lngYear & "/" & lngMonth & "/1"))
									lngCurYear  = Year(dtmDate)
									lngCurMonth = Month(dtmDate)
%>
									<TD><A HREF="javascript:changeDate(<%= lngCurYear %>, <%= lngCurMonth %>)"><IMG SRC="/webHains/images/cue.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="次の３ヶ月を表示"></A></TD>
									<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="30" HEIGHT="1"></TD>
									<TD><INPUT TYPE="text" NAME="entryDate" SIZE="10" MAXLENGTH="8"></TD>
									<TD><INPUT TYPE="image" SRC="/webHains/images/go.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="日付を入力"></TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="year"      VALUE="">
	<INPUT TYPE="hidden" NAME="month"     VALUE="">
	<INPUT TYPE="hidden" NAME="entryDate" VALUE="">
</FORM>
</BODY>
</HTML>