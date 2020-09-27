<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約枠検索(カレンダー検索) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/recentConsult.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const CALENDAR_HEIGHT = 23	'カレンダーの行当たりの高さ

Const STATUS_PAST        = "0"	'カレンダー日付状態(過去・強制予約可能)
Const STATUS_NORMAL      = "1"	'カレンダー日付状態(空きあり)
Const STATUS_OVER        = "2"	'カレンダー日付状態(オーバだが予約可能)
Const STATUS_FULL        = "3"	'カレンダー日付状態(空きなし・強制予約可能)
Const STATUS_NO_RSVFRA   = "4"	'カレンダー日付状態(枠なし・枠なし強制予約なら可能)
Const STATUS_NO_CONTRACT = "5"	'カレンダー日付状態(契約なし・予約不能)
Const STATUS_DIFFER_SET  = "6"	'カレンダー日付状態(セット差異あり・予約不能)

Const COLOR_NOTHING     = "#ffffff"	'カレンダー表示色(なし)
Const COLOR_NORMAL      = "#afeeee"	'カレンダー表示色(空きあり)
Const COLOR_OVER        = "#ff6347"	'カレンダー表示色(オーバだが予約可能)
Const COLOR_FULL        = "#ff6347"	'カレンダー表示色(空きなし)
Const COLOR_NO_RSVFRA   = "#ffcccc"	'カレンダー表示色(枠なし)
Const COLOR_NO_CONTRACT = "#cccccc"	'カレンダー表示色(契約なし)
Const COLOR_HOLIDAY     = "#90ee90"	'カレンダー表示色(休日)
Const COLOR_DIFFER_SET  = "#ffff99"	'カレンダー表示色(セット差異)

Const MARK_OVER = "★"	'オーバ時のマーク

Const IGNORE_EXCEPT_NO_RSVFRA = "1"	'予約枠無視権限(枠なしの日付を除く強制予約が可能)
Const IGNORE_ANY              = "2"	'予約枠無視権限(あらゆる強制予約が可能)

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用
Dim objConsultAll		'受診情報アクセス用
Dim objContract			'契約情報アクセス用
Dim objFree				'汎用情報アクセス用
Dim objOrganization		'団体情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objSchedule			'スケジュール情報アクセス用

'引数値
Dim strMode				'検索モード(MODE_NORMAL:通常、MODE_SAME_RSVGRP:同じ予約群セットグループで検索)
Dim lngCslYear			'受診年
Dim lngCslMonth			'受診月
Dim lngCslDay			'受診日
Dim lngIgnoreFlg		'予約枠無視フラグ

Dim strParaRsvNo		'予約番号
Dim strParaRsvGrpCd		'予約群コード

Dim strRsvNo			'予約番号
Dim strRsvGrpCd			'予約群コード

'オプション情報
Dim strArrOptCd			'オプションコード
Dim strArrOptBranchNo	'オプション枝番
Dim strArrOptSName		'オプション略称
Dim lngOptCount			'オプション数
Dim strDispOptName		'オプション名

'受診情報
Dim strPerId			'個人ＩＤ
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strCtrPtCd			'契約パターンコード
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim strCurCslDate		'現在の受診日

'個人情報
Dim strLastName			'姓
Dim strFirstName		'名
Dim strLastKName		'カナ姓
Dim strFirstKName		'カナ名
Dim strPerBirth			'生年月日
Dim strPerGender		'性別
Dim strPerAge			'受診時年齢

'編集用の個人情報
Dim strPerName			'氏名
Dim strPerBirthJpn		'生年月日
Dim strPerGenderJpn		'性別
Dim strDispManCnt		'他何名か

'団体情報
Dim strOrgName			'団体名称
Dim strOrgKName			'団体カナ名称

'カレンダー情報
Dim strCslDate			'受診日
Dim strHoliday			'休診日
Dim strStatus			'状態
Dim lngCount			'日数

'カレンダー編集用(７日×表示に要する最大週数６＝４２個の配列)
Dim strEditDay(41)		'日付
Dim strEditHoliday(41)	'休診日
Dim strEditStatus(41)	'休診日

'空き予約群検索情報
Dim strFindHoliday		'休診日
Dim strFindStatus		'状態
Dim strFindRsvGrpCd		'検索された予約群

Dim lngWeekDay			'曜日(1:日曜～7:土曜)
Dim lngPtr				'編集用配列のポインタ
Dim strHeight			'HEIGHTプロパティ用
Dim strClass			'CLASSプロパティ用
Dim strColor			'セル色
Dim strDay				'日付

Dim strStrRsvNo			'開始予約番号
Dim strEndRsvNo			'終了予約番号

Dim dtmCslDate			'受診日
Dim lngYear				'年
Dim lngMonth			'月
Dim blnAnchor			'アンカー要否
Dim strMessage			'メッセージ
Dim strHTML				'HTML文字列
Dim strURL				'URL文字列
Dim Ret					'関数戻り値
Dim i, j				'インデックス

Dim strArrCslDate		'受診日の配列
Dim strArrRsvNo			'予約番号の配列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strMode         = Request("mode")
lngCslYear      = CLng("0" & Request("cslYear"))
lngCslMonth     = CLng("0" & Request("cslMonth"))
lngCslDay       = CLng("0" & Request("cslDay"))
lngIgnoreFlg    = CLng("0" & Request("ignoreFlg"))
strParaRsvNo    = Request("rsvNo")
strParaRsvGrpCd = Request("rsvGrpCd")

'セパレータで分割し、配列化
strRsvNo    = Split(strParaRsvNo,    Chr(1))
strRsvGrpCd = Split(strParaRsvGrpCd, Chr(1))

'検索条件を単数指定した場合、値が存在しないと配列とならない。
'そこでここでは必ず存在する項目の１つである予約番号の配列数をもとに空の配列を作成する。
If UBound(strRsvNo) = 0 Then
	If UBound(strRsvGrpCd) < 0 Then
		ReDim Preserve strRsvGrpCd(0)
	End If
End If

'予約処理制御
Do

	'受診日未指定時は何もしない
	If lngCslDay = 0 Then
		Exit Do
	End If

	'受診年月日の設定
	dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

	'オブジェクトのインスタンス作成
	Set objConsultAll = Server.CreateObject("HainsConsult.ConsultAll")

	'一括受診日変更処理
	Ret = objConsultAll.ChangeDate(strMode, Session("USERID"), lngIgnoreFlg, dtmCslDate, strRsvNo, strRsvGrpCd, strMessage)

	Set objConsultAll = Nothing

	'受診情報の変更によってエラーが発生した場合はカレンダー検索自体ができなくなるため、この場合はRaise文によるエラーメッセージとする
	If Ret = -2 Then
		Err.Raise 1000, , strMessage
	End If

	'枠関連に関するエラーの場合は通常の処理に委ねる
	If Ret < 0 Then
		Exit Do
	End If

	'正常時はまず完了通知画面用のURLを作成する
	strURL = "fraRsvCslListChangedDate.asp?cslDate=" & dtmCslDate
	For i = 0 To UBound(strRsvNo)
		strURL = strURL & "&rsvNo=" & strRsvNo(i)
	Next

	'親画面(受診日一括変更画面)をリダイレクトする
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
	strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
	strHTML = strHTML & vbCrLf & "<!--"
	strHTML = strHTML & vbCrLf & "if ( opener ) {"
	strHTML = strHTML & vbCrLf & "    opener.location.href = '" & strURL & "';"
	strHTML = strHTML & vbCrLf & "}"
	strHTML = strHTML & vbCrLf & "//-->"
	strHTML = strHTML & vbCrLf & "</SCRIPT>"
	strHTML = strHTML & vbCrLf & "</HTML>"
	Response.Clear
	Response.Write strHTML
	Response.End

	Exit Do
Loop

'先頭の受診条件から各種情報を取得

Set objConsult = Server.CreateObject("HainsConsult.Consult")

'受診情報読み込み
If objConsult.SelectConsult(strRsvNo(0), , , strPerId, , , strOrgCd1, strOrgCd2, , , , strPerAge, , , , , , , , , , , , , , , , , , , , , , , , , , , , , strCtrPtCd, , strLastName, strFirstName, strLastKName, strFirstKName, strPerBirth, strPerGender) = False Then
	Err.Raise 1000, , "受診情報が存在しません。"
End If

'オプション情報読み込み
lngOptCount = objConsult.SelectConsult_O(strRsvNo(0), strArrOptCd, strArrOptBranchNo, , , strArrOptSName)

'オプション名の編集
If lngOptCount > 0 Then
	strDispOptName = "　（" & Join(strArrOptSName, "、") & "）"
End If

Set objConsult = Nothing

'姓名の編集
strPerName = "<B>" & Trim(strLastName  & "　" & strFirstName) & "</B><FONT COLOR=""#999999"">（" & Trim(strLastKName & "　" & strFirstKName) & "）</FONT>"

'年齢の小数点以下を除去
strPerAge = CStr(CInt(strPerAge))

Set objCommon = Server.CreateObject("HainsCommon.Common")

'生年月日の編集
strPerBirthJpn = objCommon.FormatString(strPerBirth, "ge.m.d") & "生　"

Set objCommon = Nothing

'性別の編集
strPerGenderJpn = IIf(strPerGender = CStr(GENDER_MALE), "男性", "女性")

Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'団体情報読み込み
objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName

Set objOrganization = Nothing

Set objContract = Server.CreateObject("HainsContract.Contract")

'コース名の取得
objContract.SelectCtrPt strCtrPtCd, , , , , strCsName

Set objContract = Nothing

'受診人数の編集
If UBound(strRsvNo) > 0 Then
	strDispManCnt = "他" & UBound(strRsvNo) & "名"
End If

'オブジェクトのインスタンス作成
Set objSchedule = Server.CreateObject("HainsSchedule.Calendar")

'指定年月の予約空き状況取得
lngCount = objSchedule.GetEmptyCalendarFromRsvNo(strMode, lngCslYear, lngCslMonth, strRsvNo, strRsvGrpCd, strCslDate, strHoliday, strStatus)

Set objSchedule = Nothing

'先頭日の曜日を求める
lngWeekDay = WeekDay(strCslDate(0))

'先頭日に達するまでポインタを移動
lngPtr = lngWeekDay - 1

'編集用配列への格納
For i = 0 To lngCount - 1
	strEditDay(lngPtr)     = Day(strCslDate(i))
	strEditHoliday(lngPtr) = strHoliday(i)
	strEditStatus(lngPtr)  = strStatus(i)
	lngPtr = lngPtr + 1
Next

'-------------------------------------------------------------------------------
'
' 機能　　 : セル色の設定
'
' 引数　　 : (In)     strDay      日付
' 　　　　   (In)     strHoliday  休診日
' 　　　　   (In)     strStatus   状態
'
' 戻り値　 : セル色(詳細はConst定義を参照)
'
'-------------------------------------------------------------------------------
Function CellColor(strDay, strHoliday, strStatus)

    Dim strColor	'セル色

    'セル色(空き状態の色)の設定
    If strDay <> "" Then

        '日付存在時
        Select Case strStatus

            Case STATUS_PAST	'過去

                'strColor = IIf(strHoliday > 0, COLOR_HOLIDAY, COLOR_NOTHING)
                strColor = COLOR_NOTHING

            Case STATUS_NORMAL  '枠あり

                '## 2006.07.12 張 休日、祝日の場合、枠状況に関係なくすべて「枠なし」で表示するように変更
                'strColor = COLOR_NORMAL
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_NORMAL)

            Case STATUS_OVER    '枠オーバ

                '## 2006.07.12 張 休日、祝日の場合、枠状況に関係なくすべて「枠なし」で表示するように変更
                'strColor = COLOR_OVER
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_OVER)

            Case STATUS_FULL    '空きなし

                '## 2006.07.12 張 休日、祝日の場合、枠状況に関係なくすべて「枠なし」で表示するように変更
                'strColor = COLOR_FULL
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_FULL)

            Case STATUS_NO_RSVFRA   '枠なし

                'strColor = IIf(strHoliday > 0, COLOR_HOLIDAY, COLOR_NO_RSVFRA)
                strColor = COLOR_NO_RSVFRA

            Case STATUS_NO_CONTRACT '契約なし

                strColor = COLOR_NO_CONTRACT

            Case Else	'その他(一応)

                '## 2006.07.12 張 休日、祝日の場合、枠状況に関係なくすべて「枠なし」で表示するように変更
                'strColor = COLOR_NORMAL
                strColor = IIf(strHoliday <> "", COLOR_NO_RSVFRA, COLOR_NORMAL)

        End Select

    '日付がなければ設定しない
    Else
        strColor = COLOR_NOTHING
    End If

    CellColor = strColor

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 予約群未指定検索条件の存在をチェック
'
' 引数　　 :
'
' 戻り値　 : True   あり
' 　　　　   False  なし
'
'-------------------------------------------------------------------------------
Function ExistsNoRsvFra()

	Dim Ret	'関数戻り値
	Dim i	'インデックス

	'予約群未指定検索条件の存在をチェック
	Ret = False
	For i = 0 To UBound(strRsvGrpCd)
		If strRsvGrpCd(i) = "" Then
			Ret = True
			Exit For
		End If
	Next

	ExistsNoRsvFra = Ret

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : アンカー要否(予約可否)の判定
'
' 引数　　 : (In)     strStatus  状態
'
' 戻り値　 : True   必要
' 　　　　   False  不要
'
'-------------------------------------------------------------------------------
Function NeedAnchor(strStatus)

	Dim Ret	'関数戻り値

	Do

		Ret = True

		'契約なし、セット差異なら不要
		If strStatus = STATUS_NO_CONTRACT Or strStatus = STATUS_DIFFER_SET Then
			Ret = False
			Exit Do
		End If

		'予約群未指定検索条件が存在する場合、強制予約はできない(強制予約時に空きのある予約群を検索することが事実上不能)
		If ExistsNoRsvFra() Then
			Ret = (strStatus = STATUS_NORMAL Or strStatus = STATUS_OVER)
			Exit Do
		End If

		'予約群未指定検索条件が存在しなければ、権限による強制予約可否制御を行う
		Select Case Session("IGNORE")

			Case IGNORE_ANY	'あらゆる強制予約可能
				Exit Do

			Case IGNORE_EXCEPT_NO_RSVFRA	'枠なし以外の強制予約可能

				'枠なしなら不要
				If strStatus = STATUS_NO_RSVFRA Then
					Ret = False
					Exit Do
				End If

			Case Else	'通常

				'空きあり、オーバ以外なら不要
				If strStatus <> STATUS_NORMAL And strStatus <> STATUS_OVER Then
					Ret = False
					Exit Do
				End If

		End Select

		Exit Do
	Loop

	NeedAnchor = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>カレンダー検索</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 日付選択
function selDate( day, force ) {

	var entForm  = document.entryForm;
	var paraForm = document.paramForm;

	// 強制予約時は強制予約チェックが必要となる
	if ( force ) {
		if ( paraForm.ignoreFlg.value == '0' ) {
			alert('強制予約時は必ず「強制予約を行う」をチェック後、実施してください。');
			return;
		}
	}

	var year  = entForm.curCslYear.value;
	var month = entForm.curCslMonth.value;

	// メッセージの表示
	if ( !confirm( '受診日を' + year + '年' + month + '月' + day + '日に' + ( force ? '強制' : '' ) + '変更します。よろしいですか？' ) ) {
		return;
	}

	// 近い受診日で健診歴がある場合はワーニング表示を行う
	var msg = checkRecentConsult( year, month, day );
	if ( msg != '' ) {
		if ( !confirm( msg + '\n\n予約を行いますか？' ) ) {
			return;
		}
	}

	// submit処理
	paraForm.cslYear.value  = year;
	paraForm.cslMonth.value = month;
	paraForm.cslDay.value   = day;
	paraForm.submit();

}

// 年月の変更
function changeDate( year, month ) {

	var objForm  = document.paramForm;
	var objYear  = objForm.cslYear;
	var objMonth = objForm.cslMonth;

	// 年月の設定
	if ( year != null ) {
		objYear.value  = year;
		objMonth.value = month;
	} else {
		objYear.value  = document.entryForm.cslYear.value;
		objMonth.value = document.entryForm.cslMonth.value;
	}

	objForm.submit();

}

function onChangeDate()
{
    changeDate();
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
</STYLE>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">カレンダー検索</FONT></B></TD>
	</TR>
</TABLE>
<%
'エラーメッセージの編集
If strMessage <> "" Then
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
End If
%>
<BR>
<%
'検索条件が複数存在する場合のメッセージ
If UBound(strRsvNo) > 0 Then
%>
	<FONT COLOR="#cc9999">●</FONT>先頭の検索条件のみ表示しています。<BR><BR>
<%
End If

'先頭の検索条件を編集
%>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR>
		<TD WIDTH="60" NOWRAP>個人名</TD>
		<TD>：</TD>
		<TD NOWRAP><%= strPerId %></TD>
		<TD>&nbsp;</TD>
		<TD NOWRAP><%= strPerName %></TD>
		<TD NOWRAP><FONT COLOR="#ff8c00"><%= strDispManCnt %></FONT></TD>
	</TR>
	<TR>
		<TD COLSPAN="4"></TD>
		<TD NOWRAP><%= strPerBirthJpn %><%= strPerAge %>歳　<%= strPerGenderJpn %></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR>
		<TD WIDTH="60" NOWRAP>団体名</TD>
		<TD>：</TD>
		<TD NOWRAP><%= strOrgCd1 %>-<%= strOrgCd2 %></TD>
		<TD>&nbsp;</TD>
		<TD NOWRAP><B><%= strOrgName %></B><FONT COLOR="#999999">（<%= strOrgKName %>）</FONT></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR>
		<TD WIDTH="60" NOWRAP>コース</TD>
		<TD>：</TD>
		<TD NOWRAP><%= strCsName & strDispOptName %></TD>
	</TR>
</TABLE>
<BR>
<%
' ---------------------------------------- 凡例 ----------------------------------------
%>
<FONT COLOR="<%= COLOR_NORMAL %>">■</FONT>：空きあり、<FONT COLOR="<%= COLOR_FULL %>">■</FONT>：空きなし、<FONT COLOR="<%= COLOR_NO_RSVFRA %>">■</FONT>：予約枠なし・休診日・祝日、<FONT COLOR="<%= COLOR_NO_CONTRACT %>">■</FONT>：契約期間外、<FONT COLOR="<%= COLOR_DIFFER_SET %>">■</FONT>：セット変更の必要性あり<!--、<FONT COLOR="<%= COLOR_HOLIDAY %>">■</FONT>：休日--><BR><BR>
<FONT COLOR="#cc9999">●</FONT>オーバとなるが予約可能な日には<%= MARK_OVER %>を表示しています。
<%
' ---------------------------------------- 凡例 ----------------------------------------
%>
<FORM NAME="entryForm" ACTION="" STYLE="margin:0px;">
<INPUT TYPE="hidden" NAME="curCslYear"  VALUE="<%= lngCslYear  %>">
<INPUT TYPE="hidden" NAME="curCslMonth" VALUE="<%= lngCslMonth %>">
<%
'予約枠無視権限による制御
Do

	'強制予約権限がない場合は何もしない
	Select Case Session("IGNORE")
		Case IGNORE_ANY
		Case IGNORE_EXCEPT_NO_RSVFRA
		Case Else
			Response.Write "<BR>"
			Exit Do
	End Select

	'予約群未指定検索条件が存在する場合、強制予約はできない
	If ExistsNoRsvFra() Then
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
				<TD HEIGHT="35"><IMG SRC="/webHains/images/ico_w.gif" WIDTH="16" HEIGHT="16" ALIGN="left" ALT=""></TD>
				<TD NOWRAP><FONT COLOR="#ff9900"><B>予約群の指定されていない検索条件があります。強制予約はできません。</B></FONT></TD>
			</TR>
		</TABLE>
<%
		Exit Do
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD HEIGHT="35"><INPUT TYPE="checkbox"<%= IIf(lngIgnoreFlg > 0, " CHECKED", "") %> ONCLICK="javascript:document.paramForm.ignoreFlg.value = this.checked ? '<%= Session("IGNORE") %>' : '0'"></TD>
			<TD NOWRAP>強制予約を行う</TD>
		</TR>
	</TABLE>
<%
	Exit Do
Loop
%>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD>
			<TABLE BORDER="1" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD COLSPAN="7" ALIGN="center" VALIGN="bottom" HEIGHT="20"><B><%= lngCslYear %></B>年<B><%= lngCslMonth %></B>月</TD>
				</TR>
				<TR ALIGN="center">
					<TD CLASS="holiday"  WIDTH="35"><B>日</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>月</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>火</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>水</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>木</B></TD>
					<TD CLASS="weekday"  WIDTH="35"><B>金</B></TD>
					<TD CLASS="saturday" WIDTH="35"><B>土</B></TD>
				</TR>
<%
				'カレンダ編集開始
				i = 0
				Do Until i >= UBound(strEditDay)
%>
					<TR ALIGN="right">
<%
						'１列目のみHEIGHTプロパティの設定を行う
						strHeight = " HEIGHT=""" & CALENDAR_HEIGHT & """"

						Do

							'CLASSプロパティ(日付の色)の設定(index値で判断、weekday関数の値とは異なる)
							Select Case i Mod 7

								Case 0	'日曜

									strClass = "holiday"

								Case 6	'土曜

									strClass = "saturday"

									'祝日はそれを優先
'### 2004/09/06 Updated by Takagi@FSIT 高木の詫び
'									If strEditHoliday(i) = "2" Then
									If strEditHoliday(i) <> "" Then
'### 2004/09/06 Updated End
										strClass = "holiday"
									End If

								Case Else	'平日

									strClass = "weekday"

									'休診日、祝日はそれを優先
									If strEditHoliday(i) <> "" Then
										strClass = "holiday"
									End If

							End Select

							'セル色(空き状態の色)の設定
							strColor = CellColor(strEditDay(i), strEditHoliday(i), strEditStatus(i))


							'アンカー要否の設定
							'blnAnchor = NeedAnchor(strEditStatus(i))

                            '## 2006.07.12 張 休診日、祝日の場合、枠状況に関係なく選択できないように変更 Start
                            If strEditHoliday(i) <>"" Then
                                blnAnchor = False
                            Else
								'## 2006.07.12 張 過去の日付の場合、枠状況に関係なく選択できないように変更
								If strEditStatus(i) = STATUS_PAST Then
									blnAnchor = False
								Else
									blnAnchor = NeedAnchor(strEditStatus(i))
								End If        
                            End If
                            '## 2006.07.12 張 休診日、祝日の場合、枠状況に関係なく選択できないように変更 End



							'セル値の設定
							Do

								If strEditDay(i) = "" Then
									strDay = "&nbsp;"
									Exit Do
								End If

								'編集文字列自体の編集
								strDay = IIf(strEditStatus(i) = STATUS_OVER, MARK_OVER, "") & strEditDay(i)

								'アンカーを要する場合
								If blnAnchor Then

									'javascriptの編集(強制時は第２引数も編集)
									strDay = "<A CLASS=""" & strClass & """ HREF=""javascript:selDate(" & strEditDay(i) & IIf(strEditStatus(i) <> STATUS_NORMAL And strEditStatus(i) <> STATUS_OVER , ",true", "") & ")"">" & strDay &  "</A>"

									Exit Do
								End If

								'通常
								strDay = "<SPAN CLASS=""" & strClass & """>" & strDay & "</SPAN>"

								Exit Do
							Loop
%>
							<TD<%= strHeight %> BGCOLOR="<%= strColor %>"><%= strDay %></TD>
<%
							'HEIGHTプロパティのクリア
							strHeight = ""

							i = i + 1
						Loop Until i Mod 7 = 0
%>
					</TR>
<%
				Loop
%>
			</TABLE>
		</TD>
	</TR>
	<TR><TD HEIGHT="5"></TD></TR>
	<TR>
		<TD>
			<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0" WIDTH="100%" BGCOLOR="#666666">
				<TR>
					<TD BGCOLOR="#ffffff" ALIGN="center">
						<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
							<TR>
<%
								lngYear  = lngCslYear - IIf(lngCslMonth = 1, 1, 0)
								lngMonth = IIf(lngCslMonth = 1, 12, lngCslMonth - 1)
%>
								<TD><A HREF="javascript:changeDate(<%= lngYear %>, <%= lngMonth %>)"><IMG SRC="../../images/replay.gif" ALT="前月を表示" HEIGHT="21" WIDTH="21"></A></TD>
								<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
								<TD>年</TD>
								<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
								<TD>月</TD>
<%
								lngYear  = lngCslYear + IIf(lngCslMonth = 12, 1, 0)
								lngMonth = IIf(lngCslMonth = 12, 1, lngCslMonth + 1)
%>
								<TD><A HREF="javascript:changeDate(<%= lngYear %>, <%= lngMonth %>)"><IMG SRC="../../images/play.gif" ALT="次月を表示" HEIGHT="21" WIDTH="21"></A></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
</FORM>
<FORM NAME="paramForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="cslYear">
	<INPUT TYPE="hidden" NAME="cslMonth">
	<INPUT TYPE="hidden" NAME="cslDay">
	<INPUT TYPE="hidden" NAME="ignoreFlg" VALUE="<%= lngIgnoreFlg    %>">
	<INPUT TYPE="hidden" NAME="rsvNo"     VALUE="<%= strParaRsvNo    %>">
	<INPUT TYPE="hidden" NAME="rsvGrpCd"  VALUE="<%= strParaRsvGrpCd %>">
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
// イベントハンドラの設定
document.entryForm.cslYear.onchange  = onChangeDate;
document.entryForm.cslMonth.onchange = onChangeDate;

// 近範囲受診歴情報の配列
var recentConsults = new Array();

// 近範囲受診歴情報クラス
function recentConsult() {
	this.rsvNo      = '';
	this.curCslDate = '';
	this.perId      = '';
	this.perName    = '';
	this.csCd       = '';
	this.cslDate    = new Array();
	this.cslRsvNo   = new Array();
}
<%
'オブジェクトのインスタンス作成
Set objConsult = Server.CreateObject("HainsConsult.Consult")

For i = 0 To UBound(strRsvNo)

	'クラスのインスタンス作成
%>
	recentConsults[<%= i %>] = new recentConsult();
	recentConsults[<%= i %>].rsvNo = <%= strRsvNo(i) %>;
<%
	'受診情報読み込み
	objConsult.SelectConsult strRsvNo(i), , strCurCslDate, strPerId, strCsCd, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strLastName, strFirstName
%>
	recentConsults[<%= i %>].curCslDate = '<%= strCurCslDate %>';
	recentConsults[<%= i %>].perId      = '<%= strPerid      %>';
	recentConsults[<%= i %>].csCd       = '<%= strCsCd       %>';
	recentConsults[<%= i %>].perName    = '<%= Trim(strLastName  & "　" & strFirstName) %>';
<%
	'指定年月の受診情報、翌月以降で最古の受診情報、前月以前で最新の受診情報を取得
	Call RecentConsult_GetRecentConsultHistory(strPerId, lngCslYear, lngCslMonth, strRsvNo(i), strArrCslDate, strArrRsvNo)

	'受診日情報存在時
	If IsArray(strArrCslDate) Then

		'その内容を編集
		For j = 0 To UBound(strArrCslDate)
%>
			recentConsults[<%= i %>].cslDate[<%= j %>]  = '<%= strArrCslDate(j) %>';
			recentConsults[<%= i %>].cslRsvNo[<%= j %>] =  <%= strArrRsvNo(j)   %>;
<%
		Next
	End If

Next

Set objConsult = Nothing
%>
// 指定受診日にて保存する際、ワーニング対象となる受診情報が存在するかを判定
function checkRecentConsult( cslYear, cslMonth, cslDay ) {

	var warnCslDate;	// ワーニング対象となる受診日

	var wkDate;			// 日付ワーク
	var msg = '';		// メッセージ

	// 指定受診日をゼロ、スラッシュ付き日付文字列形式で編集
	var curCslDate = cslYear + '/' + ( '0' + parseInt( cslMonth, 10 ) ).slice( -2 ) + '/' + ( '0' + parseInt( cslDay, 10 ) ).slice( -2 );

	// 指定月数前の受診日、指定月数後の受診日を算出
	var minCslDate = monthAdd( cslYear, cslMonth, cslDay, <%= RECENTCONSULT_RANGE_OF_MONTH * -1 %> );
	var maxCslDate = monthAdd( cslYear, cslMonth, cslDay, <%= RECENTCONSULT_RANGE_OF_MONTH      %> );

	for ( var ret = true, i = 0; i < recentConsults.length; i++ ) {

		// ドック、定期健診を除くコースの場合はスキップ
		if ( recentConsults[ i ].csCd != '100' && recentConsults[ i ].csCd != '110' ) continue;

		// 現在の受診日と変更がない場合はスキップ
		if ( curCslDate == recentConsults[ i ].curCslDate ) continue;

		warnCslDate = new Array();

		// 受診日を検索
		for ( var j = recentConsults[ i ].cslDate.length - 1; j >= 0; j-- ) {

			// 現予約番号の受診情報はスキップ
			if ( recentConsults[ i ].cslRsvNo[ j ] == recentConsults[ i ].rsvNo ) continue;

			// 指定月数前の受診日、指定月数後の受診日の範囲外ならば対象外
			if ( recentConsults[ i ].cslDate[ j ] < minCslDate || recentConsults[ i ].cslDate[ j ] > maxCslDate ) continue;

			// 上記除外条件に該当しない場合はワーニング対象となる受診情報のため、スタック
			wkDate = recentConsults[ i ].cslDate[ j ].split( '/' );
			warnCslDate[ warnCslDate.length ] = parseInt( wkDate[ 0 ], 10 ) + '年' + parseInt( wkDate[ 1 ], 10 ) + '月' + parseInt( wkDate[ 2 ], 10 ) + '日';

		}

		// ワーニング対象となる受診日存在時はメッセージを編集
		if ( warnCslDate.length > 0 ) {
			msg = msg + ( msg != '' ? '\n' : '');
			msg = msg + recentConsults[ i ].perId   + '：';
			msg = msg + recentConsults[ i ].perName + '　';
			msg = msg + warnCslDate.join( '、' ) + 'にこの受診者の受診情報がすでに存在します。';
		}

	}

	return msg;

}

// 月の加算
function monthAdd( cslYear, cslMonth, cslDay, addMonth ) {

	var wkDate;	// 日付ワーク

	// 指定年月の先頭日に対してDateクラスを絡めた演算を行い、まず年・月を求める
	wkDate = new Date( parseInt( cslYear, 10 ), parseInt( cslMonth, 10 ) - 1 + addMonth, 1 );
	var calcYear  = wkDate.getFullYear();
	var calcMonth = wkDate.getMonth();

	var calcDay = parseInt( cslDay, 10 );

	for ( ; ; ) {

		// 求められた年・月に対して指定された日を付加してDateクラスを構成。
		wkDate = new Date( calcYear, calcMonth, calcDay );

		// この結果、(末日の関係上)月の値が変わる場合は日付をデクリメントし、再度構成。正しい末日を求める。
		if ( wkDate.getMonth() == calcMonth ) {
			break;
		}

		calcDay--;
	}

	// 月を1～12の形式に変換
	calcMonth++;

	// ゼロ、スラッシュ付き日付文字列形式で返す
	return calcYear + '/' + ('0' + calcMonth).slice( -2 ) + '/' + ('0' + calcDay).slice( -2 );

}
//-->
</SCRIPT>
</BODY>
</HTML>
