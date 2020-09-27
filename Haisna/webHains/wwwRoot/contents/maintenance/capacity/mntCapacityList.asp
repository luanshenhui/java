<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		週間予約枠状況表示 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const CSCOUNT_PER_ROW = 7	'１行辺りの表示コース数
'## 2004.03.01 Add By T.Takagi@FSIT 予約人数≧最大人数にてグレー表示
Const CSCD_GI = "W001"		'ＧＩ枠管理コース
'## 2004.03.01 Add End

Dim objSchedule			'スケジュール情報アクセス用

'引数値
Dim lngCslYear			'受診年
Dim lngCslMonth			'受診月
Dim lngCslDay			'受診日
Dim strCsCd				'コースコード
Dim strGender			'性別
Dim strMode				'処理モード

'コース情報
Dim strSelCsCd			'コースコード
Dim strSelCsName		'コース名
Dim lngSelCsCount		'コース数

'予約人数情報
Dim strArrCslDate		'受診日
Dim strArrHoliday		'休診日
Dim strArrRsvGrpCd		'予約群コード
Dim strArrRsvGrpName	'予約群名称
Dim strArrStrTime		'開始時間
Dim strArrCsCd			'コースコード
Dim strArrCsName		'コース名
Dim strArrCsSName		'コース略称
Dim strArrWebColor		'webカラー
Dim strArrMngGender		'男女別枠管理
Dim strArrMaxCnt		'予約可能人数（共通）
Dim strArrMaxCnt_M		'予約可能人数（男）
Dim strArrMaxCnt_F		'予約可能人数（女）
Dim strArrOverCnt		'オーバ可能人数（共通）
Dim strArrOverCnt_M		'オーバ可能人数（男）
Dim strArrOverCnt_F		'オーバ可能人数（女）
Dim strArrRsvCnt_M		'予約済み人数（男）
Dim strArrRsvCnt_F		'予約済み人数（女）
Dim lngCount			'レコード数

Dim strChecked			'チェックの要否
Dim strCslDate			'受診日
Dim dtmStrCslDate		'開始受診日
Dim dtmEndCslDate		'終了受診日
Dim strPrevRsvGrpCd		'直前レコードの予約群コード
Dim lngRowSpan			'ROWSPAN値
Dim lngColSpan			'COLSPAN値
Dim lngCourseCount		'コース数
Dim lngRsvGrpCount		'予約群数
Dim lngWeekday			'曜日(Weekday関数の戻り値)
Dim lngRsvCount			'予約人数
Dim lngMaxCount			'(オーバ人数分含む)最大人数
Dim strClass			'曜日の色
Dim blnExists			'予約人数情報の有無
Dim strColor			'セル色
Dim strRsvCount			'編集用予約人数
Dim i, j, k				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
lngCslYear  = Request("cslYear")
lngCslMonth = Request("cslMonth")
lngCslDay   = Request("cslDay")
strCsCd     = ConvIStringToArray(Request("csCd"))
strGender   = Request("gender")
strMode     = Request("mode")

'デフォルト値設定
lngCslYear  = IIf(lngCslYear  = 0, Year(Date),  lngCslYear)
lngCslMonth = IIf(lngCslMonth = 0, Month(Date), lngCslMonth)
lngCslDay   = IIf(lngCslDay   = 0, Day(Date),   lngCslDay)

'受診日の編集
strCslDate = lngCslYear & "/" & lngCslMonth & "/" & lngCslDay

'モードごとの処理
Select Case UCase(strMode)

	'全コース
	Case UCase("all")

		'コース未指定時
		If Not IsArray(strCsCd) Then

			'コース情報を読み、全コースを対象とさせる
			Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")
			objSchedule.SelectCourseListRsvGrpManaged strCsCd
			Set objSchedule = Nothing

		End If

	'前週
	Case UCase("prev")
		strCslDate = CDate(strCslDate) - 7

	'翌週
	Case UCase("next")
		strCslDate = CDate(strCslDate) + 7

End Select

'引数値の再編集
lngCslYear  = Year(strCslDate)
lngCslMonth = Month(strCslDate)
lngCslDay   = Day(strCslDate)

'枠管理方法の取得
Function ManageGender(strParaMngGender, strParaMaxCnt, strParaMaxCnt_M, strParaMaxCnt_F)

	Dim Ret	'関数戻り値

	Do
		Ret = ""

		'枠管理方法指定時はその方法に従う
		If strParaMngGender <> "" Then
			Ret = strParaMngGender
			Exit Do
		End If

		'枠管理方法が存在しない場合(枠自体がないか、コース受診予約群がないが枠は存在する場合)

		'予約人数情報自体が存在しない場合は不明とする
		If strParaMaxCnt = "" Then
			Exit Do
		End If

		'予約人数情報自体は存在する場合

		'男女のいずれかに人数が格納されている場合、男女別枠管理とみなす
		If CLng(strArrMaxCnt_M(i)) <> 0 Or CLng(strArrMaxCnt_F(i)) <> 0 Then
			Ret = "1"
			Exit Do
		End If

		'さもなくば男女別枠管理はしないものとみなす
		Ret = "0"
		Exit Do
	Loop

	ManageGender = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>週間予約枠状況表示</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
function submitForm( mode ) {

	var year  = parseInt(document.entryForm.cslYear.value,  10);
	var month = parseInt(document.entryForm.cslMonth.value, 10);
	var day   = parseInt(document.entryForm.cslDay.value,   10);

	if ( !isDate( year, month, day ) ) {
		alert('受診日の形式が正しくありません。');
		return;
	}

	// モードを指定してsubmit
	document.entryForm.mode.value = mode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/mensetsutable.css">
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
	td.mnttab { background-color:#FFFFFF }
	div.maindiv { margin: 10px 10px 0 10px; }
	table.mensetsu-tb { margin: 10px 0; border-top: 1px solid #ccc;}
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<div class="maindiv">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN>週間予約枠状況表示</B></TD>
	</TR>
</TABLE>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" STYLE="margin:0px;">
	<INPUT TYPE="hidden" NAME="mode" VALUE="">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR><TD HEIGHT="5"></TD></TR>
		<TR>
			<TD><A HREF="javascript:submitForm('prev')"><IMG SRC="../../../images/replay.gif" WIDTH="21" HEIGHT="21" ALT="先週を表示"></A></TD>
			<TD NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear','cslMonth','cslDay')"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
						<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
						<TD NOWRAP>日から１週間&nbsp;</TD>
						<TD><A HREF="javascript:submitForm('next')"><IMG SRC="../../../images/play.gif" WIDTH="21" HEIGHT="21" ALT="翌週を表示"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR><TD HEIGHT="5"></TD></TR>
<%
		'オブジェクトのインスタンス作成
		Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

		'コース情報の読み込み
		lngSelCsCount = objSchedule.SelectCourseListRsvGrpManaged(strSelCsCd, , strSelCsName)

		'コース数が１行辺りの行数の倍数になるまで配列を拡張し、あとの表示処理を容易にする
		Do UNTIL lngSelCsCount Mod CSCOUNT_PER_ROW = 0
			ReDim Preserve strSelCsCd(lngSelCsCount)
			ReDim Preserve strSelCsName(lngSelCsCount)
			lngSelCsCount = lngSelCsCount + 1
		Loop
%>
		<TR>
			<TD></TD>
			<TD VALIGN="top" NOWRAP>コース</TD>
			<TD VALIGN="top">：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
					'枠管理コースのテーブル表示
					j = 0
					Do Until j >= lngSelCsCount
%>
						<TR>
<%
							For i = 1 To CSCOUNT_PER_ROW

								If strSelCsCd(j) <> "" Then

									'モード指定時は選択コースのみをチェック状態にする
									If strMode <> "" Then

										strChecked = ""
										If IsArray(strCsCd) Then
											For k = 0 To UBound(strCsCd)
												If strCsCd(k) = strSelCsCd(j) Then
													strChecked = " CHECKED"
													Exit For
												End If
											Next
										End If

									'モード未指定時はすべてのコースをチェック状態にする
									Else
										strChecked = " CHECKED"
									End If
%>
									<TD><INPUT TYPE="checkbox" NAME="csCd" VALUE="<%= strSelCsCd(j) %>"<%= strChecked %>></TD>
									<TD NOWRAP><%= strSelCsName(j) %></TD>
<%
								End If

								j = j + 1
							Next
%>
						</TR>
<%
					Loop
%>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>性別</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD><INPUT TYPE="radio" NAME="gender" VALUE=""<%= IIf(strGender <> "1" And strGender <> "2", " CHECKED", "") %>></TD>
						<TD NOWRAP>全て
						<TD><INPUT TYPE="radio" NAME="gender" VALUE="1"<%= IIf(strGender = "1", " CHECKED", "") %>></TD>
						<TD NOWRAP>男性のみ</TD>
						<TD><INPUT TYPE="radio" NAME="gender" VALUE="2"<%= IIf(strGender = "2", " CHECKED", "") %>></TD>
						<TD NOWRAP>女性のみ</TD>
						<TD><A HREF="javascript:submitForm('disp')"><IMG SRC="../../../images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定条件で表示"></A>&nbsp;</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<BR>
<%
'モード未指定時は以下の処理を行わない
If strMode = "" Then
	Response.End
End If

'日付チェック
If Not IsDate(strCslDate) Then
	Response.Write "受診日の形式が正しくありません。"
	Response.End
End If

If Not IsArray(strCsCd) Then
	Response.Write "コースを選択してください。"
	Response.End
End If

'開始・終了受診日の設定
dtmStrCslDate = CDate(strCslDate)
dtmEndCslDate = dtmStrCslDate + 6

'予約人数情報読み込み
lngCount = objSchedule.SelectRsvFraMngList_Capacity( _
               dtmStrCslDate,    _
               dtmEndCslDate,    _
               strCsCd, ,        _
               strArrCslDate,    _
               strArrHoliday,    _
               strArrRsvGrpCd,   _
               strArrRsvGrpName, _
               strArrStrTime,    _
               strArrCsCd,       _
               strArrCsName,     _
               strArrCsSName,    _
               strArrWebColor,   _
               strArrMngGender,  _
               strArrMaxCnt,     _
               strArrMaxCnt_M,   _
               strArrMaxCnt_F,   _
               strArrOverCnt,    _
               strArrOverCnt_M,  _
               strArrOverCnt_F,  _
               strArrRsvCnt_M,   _
               strArrRsvCnt_F    _
           )

Set objSchedule = Nothing

If lngCount <= 0 Then
	Response.Write "指定されたコースの予約人数情報は存在しません。"
	Response.End
End If
%>
（登録人数／最大人数）<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" class="mensetsu-tb">
<%
	'先頭行のROWSPAN値制御(性別指定時は１、さもなくば２)
	lngRowSpan = IIf(strGender = "1" Or strGender = "2", 1, 2)

	'先頭行のCOLSPAN値制御(性別指定時は１、さもなくば２)
	lngColSpan = IIf(strGender = "1" Or strGender = "2", 1, 2)
%>
	<TR ALIGN="center" BGCOLOR="#eeeeee">
		<TD ROWSPAN="<%= lngRowSpan %>" NOWRAP>日付</TD>
		<TD ROWSPAN="<%= lngRowSpan %>" NOWRAP>曜日</TD>
		<TD ROWSPAN="<%= lngRowSpan %>" NOWRAP>予約群</TD>
<%
		'最初の日付の最初の予約群のレコードのみを検索し、コース名を編集する
		i = 0
		Do
%>
			<TD COLSPAN="<%= lngColSpan %>"<%= IIf(lngColSpan = 1, " WIDTH=""80""", "") %> NOWRAP><%= strArrCsSName(i) %></TD>
<%
			'コース数をカウント(次行で用いる)
			lngCourseCount = lngCourseCount + 1

			'次のレコードを検索
			i = i + 1

			'レコードを最後まで検索すれば終了
			If i >= lngCount Then
				Exit Do
			End If

			'直前レコードと受診日または予約群が異なる場合は終了
			If strArrCslDate(i) <> strArrCslDate(i - 1) Or strArrRsvGrpCd(i) <> strArrRsvGrpCd(i - 1) Then
				Exit Do
			End If

		Loop
%>
	</TR>
<%
	'両方の性別を表示する場合
	If strGender <> "1" And strGender <> "2" Then

		'性別用の列を編集する
%>
		<TR ALIGN="center" BGCOLOR="#eeeeee">
<%
			'コース数分男女列を編集
			For i = 0 To lngCourseCount - 1
%>
				<TD WIDTH="55" NOWRAP>男</TD>
				<TD WIDTH="55" NOWRAP>女</TD>
<%
			Next
%>
		</TR>
<%
	End If

	'最初の日付のみを検索し、予約群数をカウント
	i = 0
	lngRsvGrpCount = 0
	strPrevRsvGrpCd = 0
	Do Until i >= lngCount

		'２レコード目以降の場合
		If i > 0 Then

			'直前レコードと受診日が異なる場合は終了
			If strArrCslDate(i) <> strArrCslDate(i - 1) Then
				Exit Do
			End If

			'直前レコードと予約群が異なる場合は予約群数をカウント
			If strArrRsvGrpCd(i) <> strArrRsvGrpCd(i - 1) Then
				lngRsvGrpCount = lngRsvGrpCount + 1
			End If

		'先頭レコードの場合
		Else

			'先頭レコードの場合はカウント
			lngRsvGrpCount = lngRsvGrpCount + 1

		End If

		i = i + 1
	Loop

	'予約人数情報の編集開始
	i = 0
	Do Until i >= lngCount

		'曜日を求める
		lngWeekday = Weekday(strArrCslDate(i))

		'CLASSプロパティ(曜日の色)の設定
		Select Case lngWeekDay

			Case 1	'日曜

				strClass = "holiday"

			Case 7	'土曜

				strClass = "saturday"

				'祝日はそれを優先
				If strArrHoliday(i) = "2" Then
					strClass = "holiday"
				End If

			Case Else	'平日

				strClass = "weekday"

				'休診日、祝日はそれを優先
				If strArrHoliday(i) <> "" Then
					strClass = "holiday"
				End If

		End Select

		'予約人数情報の有無を検索
		j = i
		blnExists = False
		Do

			'あれば検索終了
			If strArrMaxCnt(j) <> "" Then
				blnExists = True
				Exit Do
			End If

			'次のレコードを検索
			j = j + 1

			'レコードを最後まで検索すれば終了
			If j >= lngCount Then
				Exit Do
			End If

			'直前レコードと受診日が異なる場合は終了
			If strArrCslDate(j) <> strArrCslDate(j - 1) Then
				Exit Do
			End If

		Loop

		'予約人数情報が存在する場合
		If blnExists Then

			'各予約群ごとの編集
			For j = 1 To lngRsvGrpCount
%>
				<TR>
<%
					'先頭の場合のみ日付を編集
					If j = 1 Then
%>
						<TD ROWSPAN="<%= lngRsvGrpCount %>" VALIGN="top" NOWRAP><%= strArrCslDate(i) %></TD>
						<TD ROWSPAN="<%= lngRsvGrpCount %>" VALIGN="top" NOWRAP ALIGN="center" CLASS="<%= strClass %>"><B><%= Left(WeekdayName(lngWeekday), 1) %></B></TD>
<%
					End If
%>
					<TD NOWRAP><%= strArrRsvGrpName(i) %></TD>
<%
					'各コースごとの編集
					For k = 1 To lngCourseCount

						'枠管理方法ごとの処理分岐
						Select Case ManageGender(strArrMngGender(i), strArrMaxCnt(i), strArrMaxCnt_M(i), strArrMaxCnt_F(i))

							'男女別枠管理を行わない場合
							Case "0"

								'予約人数情報の編集(男女別の表示方法に依存しない)
								If strArrMaxCnt(i) <> "" Then

									'予約人数を計算
									lngRsvCount = CLng(strArrRsvCnt_M(i)) + CLng(strArrRsvCnt_F(i))

									'最大人数を計算
									lngMaxCount = CLng(strArrMaxCnt(i)) + CLng(strArrOverCnt(i))
'## 2004.03.01 Mod By T.Takagi@FSIT 予約人数≧最大人数にてグレー表示
'									lngMaxCount = CLng(strArrMaxCnt(i)) + CLng(strArrOverCnt(i))
									lngMaxCount = CLng(strArrMaxCnt(i)) + IIf(strArrCsCd(i) = CSCD_GI, 0, CLng(strArrOverCnt(i)))	'GI枠の場合、オーバ枠を無視
'## 2004.03.01 Mod End

									'予約人数と最大人数を比較し、セル色を設定
'## 2004.03.01 Mod By T.Takagi@FSIT 予約人数≧最大人数にてグレー表示
'									strColor = IIf(lngRsvCount > lngMaxCount, "cccccc", "ffffff")
									If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
										strColor = IIf(lngRsvCount >= lngMaxCount, "cccccc", "ffffff")
									Else
										strColor = "ffffff"
									End If
'## 2004.03.01 Mod End

									'編集用の予約人数編集
									If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
										strRsvCount = lngRsvCount & "/" & strArrMaxCnt(i)
										If CLng(strArrOverCnt(i)) <> 0 Then
											strRsvCount = strRsvCount & "(" & strArrOverCnt(i) & ")"
										End If
									Else
										strRsvCount = "&nbsp;"
									End If

								'予約人数情報が存在しない場合
								Else

									strColor    = "ffffff"
									strRsvCount = "&nbsp;"

								End If

								'COLSPAN値の制御
								lngColSpan = IIf(strGender <> "1" And strGender <> "2", 2, 1)
%>
								<TD COLSPAN="<%= lngColSpan %>" ALIGN="center" BGCOLOR="#<%= strColor %>"><%= strRsvCount %></TD>
<%
							'男女別枠管理を行う場合
							Case "1"

								'予約人数情報の編集
								If strArrMaxCnt(i) <> "" Then

									'女性の人数を表示しない場合
									If strGender <> "2" Then

										'予約人数を計算
										lngRsvCount = CLng(strArrRsvCnt_M(i))

										'最大人数を計算
'## 2004.03.01 Mod By T.Takagi@FSIT 予約人数≧最大人数にてグレー表示
'										lngMaxCount = CLng(strArrMaxCnt_M(i)) + CLng(strArrOverCnt_M(i))
										lngMaxCount = CLng(strArrMaxCnt_M(i)) + IIf(strArrCsCd(i) = CSCD_GI, 0, CLng(strArrOverCnt_M(i)))	'GI枠の場合、オーバ枠を無視
'## 2004.03.01 Mod End

										'予約人数と最大人数を比較し、セル色を設定
'## 2004.03.01 Mod By T.Takagi@FSIT 予約人数≧最大人数にてグレー表示
'										strColor = IIf(lngRsvCount > lngMaxCount, "cccccc", "ffffff")
										If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
											strColor = IIf(lngRsvCount >= lngMaxCount, "cccccc", "ffffff")
										Else
											strColor = "ffffff"
										End If
'## 2004.03.01 Mod End
										'編集用の予約人数編集
										If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
											strRsvCount = lngRsvCount & "/" & strArrMaxCnt_M(i)
											If CLng(strArrOverCnt_M(i)) <> 0 Then
												strRsvCount = strRsvCount & "(" & strArrOverCnt_M(i) & ")"
											End If
										Else
											strRsvCount = "&nbsp;"
										End If
%>
										<TD ALIGN="center" BGCOLOR="#<%= strColor %>" NOWRAP><%= strRsvCount %></TD>
<%
									End If

									'男性の人数を表示しない場合
									If strGender <> "1" Then

										'予約人数を計算
										lngRsvCount = CLng(strArrRsvCnt_F(i))

										'最大人数を計算
'## 2004.03.01 Mod By T.Takagi@FSIT 予約人数≧最大人数にてグレー表示
'										lngMaxCount = CLng(strArrMaxCnt_F(i)) + CLng(strArrOverCnt_F(i))
										lngMaxCount = CLng(strArrMaxCnt_F(i)) + IIf(strArrCsCd(i) = CSCD_GI, 0, CLng(strArrOverCnt_F(i)))	'GI枠の場合、オーバ枠を無視
'## 2004.03.01 Mod End
										'予約人数と最大人数を比較し、セル色を設定
'## 2004.03.01 Mod By T.Takagi@FSIT 予約人数≧最大人数にてグレー表示
'										strColor = IIf(lngRsvCount > lngMaxCount, "cccccc", "ffffff")
										If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
											strColor = IIf(lngRsvCount >= lngMaxCount, "cccccc", "ffffff")
										Else
											strColor = "ffffff"
										End If
'## 2004.03.01 Mod End
										'編集用の予約人数編集
										If lngRsvCount <> 0 Or lngMaxCount <> 0 Then
											strRsvCount = lngRsvCount & "/" & strArrMaxCnt_F(i)
											If CLng(strArrOverCnt_F(i)) <> 0 Then
												strRsvCount = strRsvCount & "(" & strArrOverCnt_F(i) & ")"
											End If
										Else
											strRsvCount = "&nbsp;"
										End If
%>
										<TD ALIGN="center" BGCOLOR="#<%= strColor %>" NOWRAP><%= strRsvCount %></TD>
<%
									End If

								'予約人数情報が存在しない場合
								Else

									If strGender <> "1" And strGender <> "2" Then
%>
										<TD BGCOLOR="#ffffff">&nbsp;</TD>
										<TD BGCOLOR="#ffffff">&nbsp;</TD>
<%
									Else
%>
										<TD BGCOLOR="#ffffff">&nbsp;</TD>
<%
									End If

								End If

							'男女別の枠管理方法識別ができない場合
							Case Else

								'COLSPAN値の制御
								lngColSpan = IIf(strGender <> "1" And strGender <> "2", 2, 1)
%>
								<TD COLSPAN="<%= lngColSpan %>" BGCOLOR="#ffffff">&nbsp;</TD>
<%
						End Select

						i = i + 1
					Next
%>
				</TR>
<%
			Next

		'予約人数情報が存在しない場合
		Else
%>
			<TR>
				<TD NOWRAP><%= strArrCslDate(i) %></TD>
				<TD NOWRAP ALIGN="center" CLASS="<%= strClass %>"><B><%= Left(WeekdayName(lngWeekday), 1) %></B></TD>
				<TD COLSPAN="<%= lngCourseCount * IIf(strGender <> "1" And strGender <> "2", 2, 1) + 1 %>">
<%
					Select Case strArrHoliday(i)
						Case "1"
							Response.Write "休日"
						Case "2"
							Response.Write "休日"
						Case Else
							Response.Write "予約枠なし"
					End Select
%>
				</TD>
			</TR>
<%
			'受診日が変わるかレコードを最後まで検索するまでインデックスを進める
			Do

				i = i + 1

				'レコードを最後まで検索すれば終了
				If i >= lngCount Then
					Exit Do
				End If

				'直前レコードと受診日が異なる場合は終了
				If strArrCslDate(i) <> strArrCslDate(i - 1) Then
					Exit Do
				End If

			Loop

		End If

	Loop
%>
</TABLE>
</div>
</BODY>
</HTML>
