<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		カレンダー (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッションチェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim lngDspYear		'基準年
Dim lngDspMonth		'基準月
Dim i
Dim j
Dim k
Dim l
Dim strHtml

'カレンダー作成用
Dim strEditYear		'年
Dim strEditMonth	'月
Dim strEditDay		'日
Dim strEndDay		'月末日

'表示月変更ボタン作成用
Dim strNextYear		'翌月の年
Dim strNextMonth	'翌月の月
Dim strPrevYear		'前月の年
Dim strPrevMonth	'前月の月
Dim strNext3Year	'翌３ヶ月の年
Dim strNext3Month	'翌３ヶ月の月
Dim strPrev3Year	'前３ヶ月の年
Dim strPrev3Month	'前３ヶ月の月

'病院スケージュール用
Dim strStrDate		'読み込み開始日付
Dim strEndDate		'読み込み終了日付
Dim vntCslDate		'受診日
Dim vntHoliday		'休診日
Dim lngCount		'レコード数

'INIファイル
Dim vntLocate

Dim strClass

Dim objSchedule 	'ＣＯＭオブジェクト

Dim objCommon 	'ＣＯＭオブジェクト

Dim strHoliday		'休診日

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトインスタンス作成
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'オブジェクトインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'引数値の取得
lngDspYear   = Clng("0" & Request("selectYear"))
lngDspMonth  = Clng("0" & Request("selectMonth"))

vntLocate = objCommon.SelectCalenderLocate()

Do
	If Clng(lngDspYear) = 0 Then
		Select Case vntLocate
			Case 1
				lngDspYear = Year(Now)
			Case 2
				lngDspYear = Year(DateAdd("m",-1,Now))
		End Select
	End If

	If Clng(lngDspMonth) = 0 Then
		Select Case vntLocate
			Case 1
				lngDspMonth = Month(Now)
			Case 2
				lngDspMonth = Month(DateAdd("m",-1,Now))
		End Select
	End If

	strStrDate = lngDspYear & "/" & lngDspMonth & "/1"
	strEndDate = Year(DateAdd("m",3,lngDspYear & "/" & lngDspMonth & "/1")) & "/" & _
				Month(DateAdd("m",3,lngDspYear & "/" & lngDspMonth & "/1")) & "/" & _
				Day(DateAdd("d",-1,DateAdd("m",4,lngDspYear & "/" & lngDspMonth & "/1")))

	'病院スケジュール取得
	lngCount = objSchedule.SelectSchedule_h(strStrDate, strEndDate, vntCslDate, vntHoliday)

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>webHains カレンダー Locate=<%= vntLocate %></TITLE>
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
</STYLE>
<style type="text/css">
body { 
	margin: 3px 0 0 8px; 
	background-color: #eee;
}
</style>
</HEAD>
<BODY>
<!-- 見出し -->
<TABLE border=0 width=112 cellpadding=0 cellspacing=0>
	<TR HEIGHT="12">
		<TD HEIGHT="10"><IMG SRC="/webHains/images/spacer.gif" HEIGHT="10"></TD>
	</TR>
	<TR HEIGHT="12" BGCOLOR="#CCCCCC">
		<TD width="100%" ALIGN="CENTER" HEIGHT="12">
			<SPAN STYLE="font-size:12px;color:#ffffff"><B>Calendar</B></SPAN>
		</TD>
	</TR>
</TABLE>
<!-- カレンダ -->
<%
strHtml = ""
l = 0

For i = 0 To 2

	strEditYear		=	Year(DateAdd("m",i,lngDspYear & "/" & lngDspMonth & "/1"))
	strEditMonth	=	Month(DateAdd("m",i,lngDspYear & "/" & lngDspMonth & "/1"))

	strHtml = strHtml & "<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">"
	strHtml = strHtml & "<TR HEIGHT=""7"">"
	strHtml = strHtml & "<TD HEIGHT=""7""><IMG SRC=""/webHains/images/spacer.gif"" HEIGHT=""7""></TD>"
	strHtml = strHtml & "</TR>"
	strHtml = strHtml & "<TR>"
	strHtml = strHtml & "<TD HEIGHT=""20"" VALIGN=""BOTTOM"">"
	strHtml = strHtml & "<SPAN STYLE=""font-size:12px;""><B>" & strEditYear & "</B>年<B>" & strEditMonth & "</B>月</SPAN>"
	strHtml = strHtml & "</TD>"
	strHtml = strHtml & "</TR>"


	strHtml = strHtml & "<TR>"
	strHtml = strHtml & "<TD>"
	strHtml = strHtml & "<TABLE BORDER=""0"" CELLPADDING=""1"" CELLSPACING=""1"">"
	strHtml = strHtml & "<TR ALIGN=""right"" BGCOLOR=""#EEEEEE"" HEIGHT=""14"">"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""holiday""><SPAN STYLE=""font-size:12px""><B>日</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>月</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>火</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>水</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>木</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""weekday""><SPAN STYLE=""font-size:12px""><B>金</B></SPAN></TD>"
	strHtml = strHtml & "<TD WIDTH=""13"" CLASS=""saturday""><SPAN STYLE=""font-size:12px""><B>土</B></SPAN></TD>"
	strHtml = strHtml & "</TR>"

	'スタート日（先頭が何曜日かを取得）
	strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")
	'月末日
	strEndDay  = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))
	
	'カレンダー作成（最大６週あるので）
	For j = 1 to 6
		strHtml = strHtml & "				<TR ALIGN=""right"" BGCOLOR=""#ffffff"" HEIGHT=""14"">" & vbCrLf

		'週ごとに計算
		For k = 1 to 7

			strEditDay = strEditDay + 1

			If strEditDay >= 1 And strEditDay <= strEndDay Then

				strHtml = strHtml & "					<TD WIDTH=""13""><SPAN STYLE=""font-size:12px""><A HREF=""/webHains/contents/common/dailyList.asp?"
				strHtml = strHtml & "strYear=" & strEditYear & "&amp;strMonth=" & strEditMonth & "&amp;strDay=" & strEditDay & """"

				'日付の表示色設定
				Do
					strClass = ""

					'今日の色指定
					If strEditYear = Year(Now) And strEditMonth = Month(Now) And strEditDay = Day(Now) Then
						strClass = "today"
						Exit Do
					End If

					'祝日なのか休診日なのかを検索
					strHoliday = ""
					For l = 0 To lngCount - 1
						If DateValue(vntCslDate(l)) = DateValue(strEditYear & "/" & strEditMonth & "/" & strEditDay) Then
							strHoliday = vntHoliday(l)
							Exit For
						End If
					Next

					'祝日の色設定
					If strHoliday = "2" Then
						strClass = "holiday"
						Exit Do
					End If

					'土曜日の色指定
					If k = vbSaturday Then
						strClass = "saturday"
						Exit Do
					End If

					'日曜日の色指定
					If k = vbSunday Then
						strClass = "holiday"
						Exit Do
					End If

					'休診日の色指定
					If strHoliday = "1" Then
						strClass = "kyusin"
						Exit Do
					End If

					'平日の色指定
					strClass = "weekday"

					Exit Do
				Loop

				strHtml = strHtml & " CLASS=""" & strClass & """"

				strHtml = strHtml & "  TARGET=""Main"">" 
				If Len(strEditDay) = 1 Then
					strHtml = strHtml & "&nbsp;"
				End If
					strHtml = strHtml & strEditDay & "</A></SPAN></TD>" & vbCrLf
			Else
				strHtml = strHtml & "<TD WIDTH=""13""><SPAN STYLE=""font-size:12px"">&nbsp;</SPAN></TD>"
			End If
		Next 
	
		strHtml = strHtml & "				</TR>" & vbCrLf
	Next

	strHtml = strHtml & "			</TABLE>"
	strHtml = strHtml & "		</TD>"
	strHtml = strHtml & "	</TR>"
	strHtml = strHtml & "</TABLE>"

	Next

	Response.Write 	strHtml
%>

<FORM NAME="changedate" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR VALIGN="top" ALIGN="center">
			<TD HEIGHT="10"></TD>
		</TR>
		<TR VALIGN="top" ALIGN="center">
			<TD>
				<TABLE BORDER="0" WIDTH="112" CELLPADDING="1" CELLSPACING="0" BGCOLOR="#cccccc">
					<TR>
						<TD WIDTH="100%" ALIGN="center"><SPAN STYLE="font-size:12px;color:#ffffff;font-weight:bolder">表示月変更</SPAN></TD>
					</TR>
					<TR>
						<TD WIDTH="100%">
							<TABLE WIDTH="100%" BORDER="0" CELLPADDING="2" CELLSPACING="0" BGCOLOR="#006699">
								<TR>
									<TD BGCOLOR="#ffffff" VALIGN="bottom" ALIGN="center" width="100%">
<%
										strNextYear   = Year(DateAdd( "m",  1,lngDspYear & "/" & lngDspMonth & "/1"))
										strNextMonth  = Month(DateAdd("m",  1,lngDspYear & "/" & lngDspMonth & "/1"))
										strPrevYear   = Year(DateAdd( "m", -1,lngDspYear & "/" & lngDspMonth & "/1"))
										strPrevMonth  = Month(DateAdd("m", -1,lngDspYear & "/" & lngDspMonth & "/1"))
										strNext3Year  = Year(DateAdd( "m",  3,lngDspYear & "/" & lngDspMonth & "/1"))
										strNext3Month = Month(DateAdd("m",  3,lngDspYear & "/" & lngDspMonth & "/1"))
										strPrev3Year  = Year(DateAdd( "m", -3,lngDspYear & "/" & lngDspMonth & "/1"))
										strPrev3Month = Month(DateAdd("m", -3,lngDspYear & "/" & lngDspMonth & "/1"))
%>
										<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?selectYear=<%= strPrev3Year %>&amp;selectMonth=<%= strPrev3Month %>"><IMG SRC="/webHains/images/review.gif" WIDTH="21" HEIGHT="21" ALT="前の３ヶ月を表示"></A>
										<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?selectYear=<%= strPrevYear  %>&amp;selectMonth=<%= strPrevMonth  %>"><IMG SRC="/webHains/images/replay.gif" WIDTH="21" HEIGHT="21" ALT="前月を表示"></A>
										<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?selectYear=<%= strNextYear  %>&amp;selectMonth=<%= strNextMonth  %>"><IMG SRC="/webHains/images/play.gif"   WIDTH="21" HEIGHT="21" ALT="次月を表示"></A>
										<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>?selectYear=<%= strNext3Year %>&amp;selectMonth=<%= strNext3Month %>"><IMG SRC="/webHains/images/cue.gif"    WIDTH="21" HEIGHT="21" ALT="次の３ヶ月を表示"></A>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<script type="text/javascript">
document.onclick = function(event)
{
	if ( !event.target ) {
		return;
	}

	var target = event.target
	if ( !target.tagName ) {
		return;
	}

	if ( target.tagName.toLowerCase() != 'a' ) {
		return;
	}

	document.body.style.cursor = 'wait';

	if ( !target.target ) {
		return;
	}

	var targetFrame = top.frames[target.target];
	if ( targetFrame ) {
		targetFrame.document.body.style.cursor = 'wait';
	}
};
</script>
</BODY>
</HTML>
