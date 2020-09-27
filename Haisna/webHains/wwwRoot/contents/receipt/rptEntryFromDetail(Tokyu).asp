<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		受付処理 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_SAVE         = "save"	'処理モード(保存)
Const CALLED_FROMDETAIL = "detail"	'呼び元画面(予約詳細)
Const CALLED_FROMLIST   = "list"	'呼び元画面(受診者一覧)

'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objContract		'契約情報アクセス用
Dim objConsult		'受診情報アクセス用
Dim objCourse		'コース情報アクセス用
Dim objFree			'汎用情報アクセス用
Dim objPerson		'個人情報アクセス用

'引数値
Dim strCalledFrom	'呼び元画面("detail":予約詳細、"list":受診者一覧)
Dim strActMode		'「確定」ボタンが押下された場合"1"
Dim strRsvNo		'予約番号
Dim strPerId		'個人ＩＤ
Dim strCsCd			'コースコード
Dim strCslYear		'現在の受診年
Dim strCslMonth 	'現在の受診月
Dim strCslDay		'現在の受診日
Dim lngCtrPtCd  	'契約パターンコード
Dim strNewCslYear	'本画面で指定された受診年
Dim strNewCslMonth 	'本画面で指定された受診月
Dim strNewCslDay	'本画面で指定された受診日
Dim lngMode			'受付モード
Dim strUseEmptyId	'空き番号存在時にその番号で割り当てを行う場合"1"
Dim strDayId		'当日ＩＤ

'契約情報
Dim strStrDate		'契約開始日
Dim strEndDate		'契約終了日
Dim strAgeCalc		'年齢起算日

'個人情報
Dim strLastName		'姓
Dim strFirstName	'名
Dim strLastKName	'カナ姓
Dim strFirstKName	'カナ名
Dim dtmBirth		'生年月日
Dim strGender		'性別

Dim strUpdUser		'更新者
Dim strCurAge		'現在の受診日時点の年齢
Dim strNewAge		'本画面で指定された受診日時点の年齢
Dim lngReceiptMode	'受付処理モード
Dim lngDayId		'当日ＩＤ
Dim dtmCslDate		'受診日
Dim strCsName		'コース名
Dim strMessage		'エラーメッセージ
Dim strURL			'ジャンプ先のURL
Dim strHTML			'HTML文字列
Dim Ret				'関数戻り値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objContract = Server.CreateObject("HainsContract.Contract")
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objCourse   = Server.CreateObject("HainsCourse.Course")
Set objFree     = Server.CreateObject("HainsFree.Free")
Set objPerson   = Server.CreateObject("HainsPerson.Person")

'更新者の設定
strUpdUser = Session("USERID")

'引数値の取得
strCalledFrom  = Request("calledFrom")
strActMode     = Request("actMode")
strRsvNo       = Request("rsvNo")
strPerId       = Request("perId")
strCsCd        = Request("csCd")
strCslYear     = Request("cslYear")
strCslMonth    = Request("cslMonth")
strCslDay      = Request("cslDay")
lngCtrPtCd     = CLng("0" & Request("ctrPtCd"))
strNewCslYear  = Request("newCslYear")
strNewCslMonth = Request("newCslMonth")
strNewCslDay   = Request("newCslDay")
lngMode        = CLng("0" & Request("mode"))
strUseEmptyId  = Request("useEmptyId")
strDayId       = Request("dayId")

'本画面で指定する受診日のデフォルト値設定
'strNewCslYear  = IIf(strNewCslYear  = "", strCslYear,  strNewCslYear)
'strNewCslMonth = IIf(strNewCslMonth = "", strCslMonth, strNewCslMonth)
'strNewCslDay   = IIf(strNewCslDay   = "", strCslDay,   strNewCslDay)
strNewCslYear  = IIf(strNewCslYear  = "", CStr(Year(Date)),  strNewCslYear)
strNewCslMonth = IIf(strNewCslMonth = "", CStr(Month(Date)), strNewCslMonth)
strNewCslDay   = IIf(strNewCslDay   = "", CStr(Day(Date)),   strNewCslDay)

'個人情報読み込み
If objPerson.SelectPerson_Lukes(strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , dtmBirth, strGender) = False Then
	Err.Raise 1000, , "個人情報が存在しません。"
End If

'契約パターン情報読み込み
If objContract.SelectCtrPt(lngCtrPtCd, strStrDate, strEndDate, strAgeCalc) = False Then
	Err.Raise 1000, ,"契約情報が存在しません。"
End If

'チェック・更新・読み込み処理の制御
Do

	'「確定」ボタン押下時以外は何もしない
	If strActMode = "" Then
		Exit Do
	End If

	'受診日の日付チェック
	If Not IsDate(strNewCslYear & "/" & strNewCslMonth & "/" & strNewCslDay) Then
		strMessage = "受診日の入力形式が正しくありません。"
		Exit Do
	End If

	'受診日を日付型として取得
	dtmCslDate = CDate(strNewCslYear & "/" & strNewCslMonth & "/" & strNewCslDay)

	'受診日が契約期間を外れる場合はエラー
	If dtmCslDate < CDate(strStrDate) Or dtmCslDate > CDate(strEndDate) Then
		strMessage = "現契約パターンの契約期間を外れる日付は指定できません。"
		Exit Do
	End If

	'当日ＩＤを直接指定する場合
	If lngMode = 1 Then

		'当日ＩＤ値のチェック
		strMessage = objCommon.CheckNumeric("当日ＩＤ", strDayId, LENGTH_RECEIPT_DAYID, CHECK_NECESSARY)
		If strMessage <> "" Then
			Exit Do
		End If

	End If

	'現受診日時点の年齢を計算
	strCurAge = objFree.CalcAge(dtmBirth, CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay), strAgeCalc)
	If Not IsNumeric(strCurAge) Then
		Err.Raise 1000, , "年齢計算処理にてエラーが発生しました。"
	End If

	'本画面で指定された受診日時点の年齢を計算
	strNewAge = objFree.CalcAge(dtmBirth, dtmCslDate, strAgeCalc)
	If Not IsNumeric(strNewAge) Then
		Err.Raise 1000, , "年齢計算処理にてエラーが発生しました。"
	End If

	'現在の年齢と指定された受診日時点での年齢とが異なる場合、受診すべきオプション検査の内容に矛盾が生じる可能性があるためはじく
	If Int(strNewAge) <> Int(strCurAge) Then
		strMessage = "現在の受診時年齢と指定された受診日時点の年齢が異なります。受付できません。"
		Exit Do
	End If

	'受付処理モード・受付番号の設定
	lngReceiptMode = IIf(lngMode =  0, IIf(strUseEmptyId <> "", 2, 1), 3)
	If lngMode = 1 Then
		lngDayId = CLng(strDayId)
	End If

	'予約詳細画面から呼ばれた場合
	If strCalledFrom = CALLED_FROMDETAIL Then

		'予約詳細画面へ引数を渡すためのリダイレクト処理
		strURL = "rptReceipt.asp"
		strURL = strURL & "?cslYear="     & strNewCslYear
		strURL = strURL & "&cslMonth="    & strNewCslMonth
		strURL = strURL & "&cslDay="      & strNewCslDay
		strURL = strURL & "&receiptMode=" & lngReceiptMode
		strURL = strURL & "&dayId="       & lngDayId
		Response.Redirect strURL
		Response.End
		Exit Do

	End If

	'受診者一覧から呼ばれた場合
	If strCalledFrom = CALLED_FROMLIST Then

		'受付処理
		Ret = objConsult.Receipt(strRsvNo, strNewCslYear, strNewCslMonth, strNewCslDay, strUpdUser, lngReceiptMode, 0, lngDayId, strMessage)
		If Ret <= 0 Then
			Exit Do
		End If

		'エラーがなければ受診者一覧画面をリロードして自身を閉じる
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

	End If

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
<TITLE>受付</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// submit時の処理
function submitForm() {

	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="JavaScript:return false">

	<INPUT TYPE="hidden" NAME="calledFrom" VALUE="<%= strCalledFrom %>">
	<INPUT TYPE="hidden" NAME="actMode"    VALUE="1">
	<INPUT TYPE="hidden" NAME="rsvNo"      VALUE="<%= strRsvNo    %>">
	<INPUT TYPE="hidden" NAME="perId"      VALUE="<%= strPerId    %>">
	<INPUT TYPE="hidden" NAME="csCd"       VALUE="<%= strCsCd     %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"    VALUE="<%= lngCtrPtCd  %>">
	<INPUT TYPE="hidden" NAME="cslYear"    VALUE="<%= strCslYear  %>">
	<INPUT TYPE="hidden" NAME="cslMonth"   VALUE="<%= strCslMonth %>">
	<INPUT TYPE="hidden" NAME="cslDay"     VALUE="<%= strCslDay   %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">受付</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	If strMessage <> "" Then

		EditMessage strMessage, MESSAGETYPE_WARNING
%>
		<BR>
<%
	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><%= strPerId %></TD>
			<TD NOWRAP><B><%= strLastName %>　<%= strFirstName %></B> （<FONT SIZE="-1"><%= strLastKName %>　<%= strFirstKName %></FONT>）</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(dtmBirth, "ge.m.d") %>生<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"><%= IIf(strGender = CStr(GENDER_MALE), "男性", "女性") %></TD>
		</TR>
	</TABLE>
<%
	'コース名の読み込み
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "コース情報が存在しません。"
	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>受診コース：</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#cc9999">●</FONT></TD>
			<TD NOWRAP>受診日を変更する場合はここで指定して下さい。</TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#cc9999">●</FONT></TD>
			<TD NOWRAP>現契約パターンの契約期間を外れる日付は指定できません。</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>（契約期間：<FONT COLOR="#ff6600"><B><%= strStrDate %></B></FONT>～<FONT COLOR="#ff6600"><B><%= strEndDate %></B></FONT>）</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('newCslYear', 'newCslMonth', 'newCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("newCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strNewCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("newCslMonth", 1, 12, strNewCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("newCslDay", 1, 31, strNewCslDay, False) %></TD>
			<TD>日</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>

	<FONT SIZE="+1"><FONT COLOR="#cc9999">●</FONT>&nbsp;当日ＩＤの割り当て方法を指定して下さい。</FONT>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(lngMode = 0, "CHECKED", "") %>></TD>
			<TD COLSPAN="2">当日ＩＤを自動で発番する</TD>
		</TR>
		<TR>
			<TD COLSPAN="2"></TD>
			<TD><INPUT TYPE="checkbox" NAME="useEmptyId" VALUE="1" <%= IIf(strUseEmptyId = "1", "CHECKED", "") %>></TD>
			<TD NOWRAP>空き番号が存在する場合、その番号で割り当てを行う</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(lngMode = 1, "CHECKED", "") %>></TD>
			<TD COLSPAN="2">当日ＩＤを直接指定する</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD NOWRAP>当日ＩＤ：</TD>
			<TD WIDTH="100%"><INPUT TYPE="text" NAME="dayId" SIZE="4" MAXLENGTH="4" VALUE="<%= strDayId %>"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" ALIGN="right">
		<TR>
			<TD><A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この内容で予約確定"></A></TD>
			<TD><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
