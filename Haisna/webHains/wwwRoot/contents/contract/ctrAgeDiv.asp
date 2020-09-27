<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(年齢起算日・年齢区分の設定) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_NEXT        = "next"	'処理モード（次へ）
Const MODE_SAVE        = "save"	'処理モード（保存）
Const AGEDIV_ROWCOUNT  = 10		'年齢範囲・年齢区分の表示行数
Const AGECALC_CSLDATE  = 0		'年齢起算方法（受診日指定）
Const AGECALC_DIRECT   = 1		'年齢起算方法（起算日指定）

'データベースアクセス用オブジェクト
Dim objOrganization		'団体情報アクセス用
Dim objCourse			'コース情報アクセス用
Dim objContract			'契約管理情報アクセス用
Dim objContractControl	'契約情報アクセス用

'引数値
Dim strMode				'処理モード
Dim strCtrPtCd			'契約パターンコード
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strCsCd				'コースコード
Dim strStrYear			'契約開始年
Dim strStrMonth 		'契約開始月
Dim strStrDay			'契約開始日
Dim strEndYear			'契約終了年
Dim strEndMonth 		'契約終了月
Dim strEndDay			'契約終了日
Dim lngAgeCalc			'年齢起算方法
Dim lngAgeCalcYear		'年齢起算日（年）
Dim lngAgeCalcMonth		'年齢起算日（月）
Dim lngAgeCalcDay		'年齢起算日（日）
Dim strStrAge			'開始年齢
Dim strEndAge			'終了年齢
Dim strAgeDiv			'年齢区分

'契約管理情報
Dim strOrgName			'団体名
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日

Dim strAgeCalc			'年齢起算日
Dim strStrDate			'編集用の契約開始日
Dim strEndDate			'編集用の契約終了日
Dim strMessage			'エラーメッセージ
Dim strHTML				'HTML文字列
Dim strURL				'ジャンプ先のURL
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'引数値の取得
strMode         = Request("mode")
strCtrPtCd      = Request("ctrPtCd")
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strCsCd         = Request("csCd")
strStrYear      = Request("strYear")
strStrMonth     = Request("strMonth")
strStrDay       = Request("strDay")
strEndYear      = Request("endYear")
strEndMonth     = Request("endMonth")
strEndDay       = Request("endDay")
lngAgeCalc      = CLng("0" & Request("ageCalc"))
lngAgeCalcYear  = CLng("0" & Request("ageCalcYear"))
lngAgeCalcMonth = CLng("0" & Request("ageCalcMonth"))
lngAgeCalcDay   = CLng("0" & Request("ageCalcDay"))
strStrAge       = ConvIStringToArray(Request("strAge"))
strEndAge       = ConvIStringToArray(Request("endAge"))
strAgeDiv       = ConvIStringToArray(Request("ageDiv"))

'更新モードごとの処理制御
Select Case strMode

	'次へ
	Case MODE_NEXT

		'入力チェック
		strMessage = CheckValue()
		If IsEmpty(strMessage) Then

			'次画面URLの編集開始
			strURL = "ctrDemand.asp?"

			'QueryString値の編集
			strURL = strURL & "orgCd1="   & strOrgCd1   & "&"
			strURL = strURL & "orgCd2="   & strOrgCd2   & "&"
			strURL = strURL & "csCd="     & strCsCd     & "&"
			strURL = strURL & "strYear="  & strStrYear  & "&"
			strURL = strURL & "strMonth=" & strStrMonth & "&"
			strURL = strURL & "strDay="   & strStrDay   & "&"
			strURL = strURL & "endYear="  & strEndYear  & "&"
			strURL = strURL & "endMonth=" & strEndMonth & "&"
			strURL = strURL & "endDay="   & strEndDay   & "&"

			'年齢範囲・年齢区分の編集
			If IsArray(strStrAge) Then
				For i = 0 To UBound(strStrAge)
					strURL = strURL & "strAge="  & strStrAge(i) & "&"
					strURL = strURL & "endAge="  & strEndAge(i) & "&"
					strURL = strURL & "ageDiv="  & strAgeDiv(i) & "&"
				Next
			End If

			'年齢起算日の編集
			strAgeCalc = EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)
			strURL = strURL & "ageCalc="  & strAgeCalc

			'次画面へリダイレクト
			Response.Redirect strURL
			Response.End

		End If

	'保存
	Case MODE_SAVE

		'入力チェック
		strMessage = CheckValue()
		If IsEmpty(strMessage) Then

			'年齢起算日の編集
			strAgeCalc = EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)

			'年齢起算日・年齢区分の更新
			objContractControl.UpdateAgeDiv strOrgCd1, strOrgCd2, strCtrPtCd, strAgeCalc, strStrAge, strEndAge, strAgeDiv

			'エラーがなければ呼び元(契約情報)画面をリロードして自身を閉じる
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End

		End If

	Case Else

		'契約パターンコード指定時(即ち更新時)
		If strCtrPtCd <> "" Then

			'契約パターン情報読み込み
			objContract.SelectCtrPt strCtrPtCd, dtmStrDate, dtmEndDate, strAgeCalc

			'年齢起算日の設定
			Select Case Len(strAgeCalc)
				Case 8
					lngAgeCalc      = AGECALC_DIRECT
					lngAgeCalcYear  = CLng("0" & Mid(strAgeCalc, 1, 4))
					lngAgeCalcMonth = CLng("0" & Mid(strAgeCalc, 5, 2))
					lngAgeCalcDay   = CLng("0" & Mid(strAgeCalc, 7, 2))
				Case 4
					lngAgeCalc      = AGECALC_DIRECT
					lngAgeCalcYear  = 0
					lngAgeCalcMonth = CLng("0" & Mid(strAgeCalc, 1, 2))
					lngAgeCalcDay   = CLng("0" & Mid(strAgeCalc, 3, 2))
				Case Else
					lngAgeCalc      = AGECALC_CSLDATE
					lngAgeCalcYear  = 0
					lngAgeCalcMonth = 0
					lngAgeCalcDay   = 0
			End Select

			'契約パターン年齢区分情報読み込み
			objContract.SelectCtrPtAge strCtrPtCd, strStrAge, strEndAge, strAgeDiv

		End If

End Select

'契約パターンコード指定時(即ち更新時)
If strCtrPtCd <> "" Then

	'契約管理情報を読み、団体・コースの名称及び契約期間を取得する
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If


'契約パターンコード未指定時(即ち新規登録時)
Else

	'団体名の読み込み
	If objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName) = False Then
		Err.Raise 1000, , "団体情報が存在しません。"
	End If

	'コース名の読み込み
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "コース情報が存在しません。"
	End If

	'契約開始年月日の取得
	dtmStrDate = CDate(strStrYear & "/" & strStrMonth & "/" & strStrDay)

	'契約終了年月日の取得
	If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then
		dtmEndDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)
	End If

End If

'年齢区分が存在しない場合（初期表示時）は空の配列を作成
If IsEmpty(strStrAge) Then
	strStrAge = Array()
	strEndAge = Array()
	strAgeDiv = Array()
End If

'表示行数分配列を拡張する
ReDim Preserve strStrAge(AGEDIV_ROWCOUNT - 1)
ReDim Preserve strEndAge(AGEDIV_ROWCOUNT - 1)
ReDim Preserve strAgeDiv(AGEDIV_ROWCOUNT - 1)

'-------------------------------------------------------------------------------
'
' 機能　　 : 年齢起算日の編集
'
' 引数　　 : (In)     lngAgeCalc       年齢起算方法
' 　　　　 : (In)     lngAgeCalcYear   年齢起算日（年）
' 　　　　 : (In)     lngAgeCalcMonth  年齢起算日（月）
' 　　　　 : (In)     lngAgeCalcDay    年齢起算日（日）
'
' 戻り値　 : 年齢起算日
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)

	EditAgeCalc = IIf(lngAgeCalc = 1, IIf(lngAgeCalcYear <> 0, Right("0000" & lngAgeCalcYear, 4), "") & Right("00" & lngAgeCalcMonth, 2) & Right("00" & lngAgeCalcDay, 2), "")

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 : データ正常時は年齢範囲・年齢区分の配列を再構成する
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'共通クラス

	Dim strArrStrAge()	'開始年齢の配列
	Dim strArrEndAge()	'終了年齢の配列
	Dim strArrAgeDiv()	'年齢区分の配列
	Dim lngCount		'配列の要素数

	Dim strWkStrAge		'開始年齢
	Dim strWkEndAge		'終了年齢
	Dim strWkAgeDiv		'年齢区分

	Dim strMessage		'エラーメッセージ
	Dim blnAdd			'追加フラグ
	Dim i, j			'インデックス

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'年齢起算方法が「起算日を直接指定」の場合は年齢起算日チェックを行う
	Do
		'受診日で起算する場合は不要
		If lngAgeCalc = 0 Then
			Exit Do
		End If

		'月日が指定されていない場合はエラー
		If lngAgeCalcMonth + lngAgeCalcDay = 0 Then
			objCommon.AppendArray strMessage, "年齢起算日を直接指定する場合は月日を入力して下さい。"
			Exit Do
		End If

		'年が指定されていない場合の月日チェック(閏年でない任意の年を使用して年月日チェックを行う)
		If lngAgeCalcYear = 0 Then
			If Not IsDate("2001/" & lngAgeCalcMonth & "/" & lngAgeCalcDay) Then
				objCommon.AppendArray strMessage, "年齢起算日の入力形式が正しくありません。"
			End If

		'年が指定されている場合の月日チェック
		Else
			If Not IsDate(lngAgeCalcYear & "/" & lngAgeCalcMonth & "/" & lngAgeCalcDay) Then
				objCommon.AppendArray strMessage, "年齢起算日の入力形式が正しくありません。"
			End If
		End If

		Exit Do
	Loop

	'配列の再構成
	For i = 0 To UBound(strStrAge)

		blnAdd = True

		'各行の再構成
		Do

			'何も入力されていない行はスキップ
			If strStrAge(i) = "" And strEndAge(i) = "" And strAgeDiv(i) = "" Then
				blnAdd = False
				Exit Do
			End If

			'年齢範囲が入力されていない行はとりあえず追加（後でエラーになるが）
			If strStrAge(i) = "" And strEndAge(i) = "" Then
				strWkStrAge = strStrAge(i)
				strWkEndAge = strEndAge(i)
				strWkAgeDiv = strAgeDiv(i)
				Exit Do
			End If

			'開始年齢が入力されていない行は最小年齢を適用して追加させる
			If strStrAge(i) = "" And strEndAge(i) <> "" Then
				strWkStrAge = CStr(AGE_MINVALUE)
				strWkEndAge = strEndAge(i)
				strWkAgeDiv = strAgeDiv(i)
				Exit Do
			End If

			'終了年齢が入力されていない行は最大年齢を適用して追加させる
			If strStrAge(i) <> "" And strEndAge(i) = "" Then
				strWkStrAge = strStrAge(i)
				strWkEndAge = CStr(AGE_MAXVALUE)
				strWkAgeDiv = strAgeDiv(i)
				Exit Do
			End If

			'開始年齢が終了年齢より大きい行は最大、最小を交換して追加させる
			If CLng(strStrAge(i)) > CLng(strEndAge(i)) Then
				strWkStrAge = strEndAge(i)
				strWkEndAge = strStrAge(i)
				strWkAgeDiv = strAgeDiv(i)
				Exit Do
			End If

			'上記以外はそのまま追加
			strWkStrAge = strStrAge(i)
			strWkEndAge = strEndAge(i)
			strWkAgeDiv = strAgeDiv(i)

			Exit Do
		Loop

		'配列の最大要素数をインクリメントし、要素を追加する
		If blnAdd Then
			ReDim Preserve strArrStrAge(lngCount)
			ReDim Preserve strArrEndAge(lngCount)
			ReDim Preserve strArrAgeDiv(lngCount)
			strArrStrAge(lngCount) = strWkStrAge
			strArrEndAge(lngCount) = strWkEndAge
			strArrAgeDiv(lngCount) = strWkAgeDiv
			lngCount = lngCount + 1
		End If

	Next

	'年齢範囲の入力チェック
	For i = 0 To lngCount - 1
		If strArrStrAge(i) = "" And strArrEndAge(i) = "" Then
			objCommon.AppendArray strMessage, "年齢範囲の入力されていない行があります。"
			Exit For
		End If
	Next

	'年齢区分の入力チェック
	For i = 0 To lngCount - 1
		If strArrAgeDiv(i) = "" Then
			objCommon.AppendArray strMessage, "年齢区分の入力されていない行があります。"
			Exit For
		End If
	Next

	'年齢範囲の重複チェック
	i = 0
	Do Until i >= lngCount

		'年齢範囲が入力されている場合
		If strArrStrAge(i) <> "" And strArrEndAge(i) <> "" Then

			'直前の要素までの年齢範囲との重複チェック
			For j = 0 To i - 1

				'年齢範囲が入力されている場合
				If strArrStrAge(j) <> "" And strArrEndAge(j) <> "" Then

					'年齢範囲が重複している場合はエラー
					If CLng(strArrStrAge(i)) <= CLng(strArrEndAge(j)) And CLng(strArrEndAge(i)) >= CLng(strArrStrAge(j)) Then
						objCommon.AppendArray strMessage, "年齢範囲が重複しています。"
						Exit Do
					End If

				End If

			Next

		End If

		i = i + 1
	Loop

	'エラーが存在しない場合
	If IsEmpty(strMessage) Then

		'要素が存在する場合は元の年齢範囲・年齢区分を再構成後のそれに置き換え、存在しなければEmpty値とする
		If lngCount > 0 Then
			strStrAge = strArrStrAge
			strEndAge = strArrEndAge
			strAgeDiv = strArrAgeDiv
		Else
			strStrAge = Empty
			strEndAge = Empty
			strAgeDiv = Empty
		End If

	End If

	'戻り値の編集
	CheckValue = strMessage

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>年齢起算日・年齢区分の設定</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// submit時の処理
function submitForm( mode ) {

	// 処理モードを指定してsubmit
	document.entryForm.mode.value = mode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"     VALUE="">
	<INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd  %>">
	<INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1   %>">
	<INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2   %>">
	<INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd     %>">
	<INPUT TYPE="hidden" NAME="strYear"  VALUE="<%= strStrYear  %>">
	<INPUT TYPE="hidden" NAME="strMonth" VALUE="<%= strStrMonth %>">
	<INPUT TYPE="hidden" NAME="strDay"   VALUE="<%= strStrDay   %>">
	<INPUT TYPE="hidden" NAME="endYear"  VALUE="<%= strEndYear  %>">
	<INPUT TYPE="hidden" NAME="endMonth" VALUE="<%= strEndMonth %>">
	<INPUT TYPE="hidden" NAME="endDay"   VALUE="<%= strEndDay   %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="80%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">年齢起算日・年齢区分の設定</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)

	'編集用の契約開始日設定
	If Not IsEmpty(dtmStrDate) Then
		strStrDate = FormatDateTime(dtmStrDate, 1)
	End If

	'編集用の契約終了日設定
	If Not IsEmpty(dtmEndDate) Then
		strEndDate = FormatDateTime(dtmEndDate, 1)
	End If
%>
	<BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>契約団体</TD>
			<TD>：</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>対象コース</TD>
			<TD>：</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>契約期間</TD>
			<TD>：</TD>
			<TD><B><%= strStrDate %>～<%= strEndDate %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">●</FONT>年齢の起算方法を指定して下さい。

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>年齢起算日</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="radio" NAME="ageCalc" VALUE="0" <%= IIf(lngAgeCalc = "0", "CHECKED", "") %>></TD>
			<TD NOWRAP>受診日で起算する</TD>
		</TR>
		<TR>
			<TD COLSPAN="2"></TD>
			<TD><INPUT TYPE="radio" NAME="ageCalc" VALUE="1" <%= IIf(lngAgeCalc = "1", "CHECKED", "") %>></TD>
			<TD NOWRAP>起算日を直接指定&nbsp;</TD>
			<TD NOWRAP>起算年：</TD>
			<TD><%= EditSelectNumberList("ageCalcYear", YEARRANGE_MIN, YEARRANGE_MAX, lngAgeCalcYear) %></TD>
			<TD NOWRAP>&nbsp;起算月日：</TD>
			<TD><%= EditSelectNumberList("ageCalcMonth", 1, 12, lngAgeCalcMonth) %></TD>
			<TD>月</TD>
			<TD><%= EditSelectNumberList("ageCalcDay", 1, 31, lngAgeCalcDay) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">●</FONT>契約団体が負担する健診基本料の単価計算用年齢区分を設定して下さい。

	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee">
			<TD ALIGN="center" COLSPAN="4" NOWRAP>年齢範囲</TD>
			<TD NOWRAP>年齢区分</TD>
		</TR>
<%
		'年齢範囲・年齢区分の編集
		For i = 0 To AGEDIV_ROWCOUNT - 1
%>
			<TR>
				<TD><%= EditSelectNumberList("strAge", 1, 150, CLng("0" & strStrAge(i))) %></TD>
				<TD>～</TD>
				<TD><%= EditSelectNumberList("endAge", 1, 150, CLng("0" & strEndAge(i))) %></TD>
				<TD>歳</TD>
				<TD ALIGN="center"><INPUT TYPE="text" NAME="ageDiv" SIZE="2" MAXLENGTH="2" VALUE="<%= strAgeDiv(i) %>"></TD>
			</TR>
<%
		Next
%>
	</TABLE>

	<BR><BR>
<%
	'更新時は「キャンセル」「保存」ボタンを、新規時は「戻る」「次へ」ボタンをそれぞれ用意する
	If strCtrPtCd <> "" Then
%>
		<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A>
		<A HREF="javascript:submitForm('<%= MODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="保存"></A>
<%
	Else
%>
		<A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
		<A HREF="javascript:submitForm('<%= MODE_NEXT %>')"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ"></A>
<%
	End If
%>
</FORM>
</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
