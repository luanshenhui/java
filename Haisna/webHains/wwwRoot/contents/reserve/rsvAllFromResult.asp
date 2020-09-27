<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		健診結果からの２次一括予約 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon			'共通クラス
'Dim objConsult			'受診情報一括処理用
Dim objContract			'契約情報アクセス用
Dim objCourse			'コース情報アクセス用
Dim objOrganization		'団体情報アクセス用
Dim objOrgBsd			'事業部情報アクセス用
Dim objOrgPost			'所属情報アクセス用
Dim objOrgRoom			'室部情報アクセス用

'引数値
Dim lngStrCslYear		'開始受診年
Dim lngStrCslMonth		'開始受診月
Dim lngStrCslDay		'開始受診日
Dim lngEndCslYear		'終了受診年
Dim lngEndCslMonth		'終了受診月
Dim lngEndCslDay		'終了受診日
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strArrCsCd 			'コースコード
Dim strOrgBsdCd			'事業部コード
Dim strOrgRoomCd		'室部コード
Dim strStrOrgPostCd		'開始所属コード
Dim strEndOrgPostCd		'終了所属コード
Dim strCtrPtCd			'契約パターンコード
Dim lngSecStrCslYear	'割り当て開始年
Dim lngSecStrCslMonth	'割り当て開始月
Dim lngSecStrCslDay		'割り当て開始日
Dim lngSecEndCslYear	'割り当て終了年
Dim lngSecEndCslMonth	'割り当て終了月
Dim lngSecEndCslDay		'割り当て終了日
Dim strCount			'挿入件数

'所属情報
Dim strOrgName			'団体名称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomName		'室部名称
Dim strStrOrgPostName	'開始所属名称
Dim strEndOrgPostName	'終了所属名称

'契約情報
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日

'個人情報
Dim strPerId			'個人ＩＤ
Dim lngCount			'レコード数

Dim dtmDate				'作業用の日付
Dim dtmStrCslDate		'開始受診日
Dim dtmEndCslDate		'終了受診日
Dim dtmSecStrCslDate	'割り当て開始日
Dim dtmSecEndCslDate	'割り当て終了日
Dim strUpdUser			'更新者
Dim strMessage			'エラーメッセージ
Dim strURL				'ジャンプ先のURL
Dim Ret					'関数戻り値
Dim i					'インデックス

Dim objExec				'取り込み処理実行用
Dim strCommand			'コマンドライン文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
'Set objConsult      = Server.CreateObject("HainsCooperation.ConsultAll")
Set objContract     = Server.CreateObject("HainsContract.Contract")
Set objCourse       = Server.CreateObject("HainsCourse.Course")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")

'更新者の設定
strUpdUser = Session("USERID")

'引数値の取得
lngStrCslYear     = CLng("0" & Request("strCslYear"))
lngStrCslMonth    = CLng("0" & Request("strCslMonth"))
lngStrCslDay      = CLng("0" & Request("strCslDay"))
lngEndCslYear     = CLng("0" & Request("endCslYear"))
lngEndCslMonth    = CLng("0" & Request("endCslMonth"))
lngEndCslDay      = CLng("0" & Request("endCslDay"))
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strArrCsCd        = ConvIStringToArray(Request("csCd"))
strOrgBsdCd       = Request("orgBsdCd")
strOrgRoomCd      = Request("orgRoomCd")
strStrOrgPostCd   = Request("strOrgPostCd")
strEndOrgPostCd   = Request("endOrgPostCd")
strCtrPtCd        = Request("ctrPtCd")
lngSecStrCslYear  = CLng("0" & Request("secStrCslYear"))
lngSecStrCslMonth = CLng("0" & Request("secStrCslMonth"))
lngSecStrCslDay   = CLng("0" & Request("secStrCslDay"))
lngSecEndCslYear  = CLng("0" & Request("secEndCslYear"))
lngSecEndCslMonth = CLng("0" & Request("secEndCslMonth"))
lngSecEndCslDay   = CLng("0" & Request("secEndCslDay"))
strCount          = Request("count")

'受診開始・終了日のデフォルト値設定
'(受診開始年が０になるケースは初期表示時以外にない)
If lngStrCslYear = 0 Then

	'システム日付に対し、先週の月曜まで日付を戻す
	dtmDate = DateAdd("d", (Weekday(Date()) + 5) * -1, Date())

	lngStrCslYear  = Year(dtmDate)
	lngStrCslMonth = Month(dtmDate)
	lngStrCslDay   = Day(dtmDate)

	'先週の月曜から金曜まで日付を進める
	dtmDate = DateAdd("d", 4, dtmDate)

	lngEndCslYear  = Year(dtmDate)
	lngEndCslMonth = Month(dtmDate)
	lngEndCslDay   = Day(dtmDate)

End If

'割り当て期間のデフォルト値設定
'(割り当て期間が０になるケースは初期表示時以外にない)
If lngSecStrCslYear = 0 Then
	dtmDate = DateAdd("d", 1, Date())	'とりあえず明日
	lngSecStrCslYear  = Year(dtmDate)
	lngSecStrCslMonth = Month(dtmDate)
	lngSecStrCslDay   = Day(dtmDate)
	lngSecEndCslYear  = Year(dtmDate)
	lngSecEndCslMonth = Month(dtmDate)
	lngSecEndCslDay   = Day(dtmDate)
End If

'契約情報の読み込み(チェック時と表示時の両方で使用するため、ここで予め読み込む
If strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"契約情報が存在しません。"
	End If
End If

'チェック・更新・読み込み処理の制御
Do

	'「確定」ボタン押下時以外は何もしない
	If IsEmpty(Request("reserve.x")) Then
		Exit Do
	End If

	'入力チェック
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		Exit Do
	End If

	'受診日の編集
	dtmStrCslDate = CDate(lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay)
	dtmEndCslDate = CDate(lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay)
	dtmSecStrCslDate = CDate(lngSecStrCslYear & "/" & lngSecStrCslMonth & "/" & lngSecStrCslDay)
	dtmSecEndCslDate = CDate(lngSecEndCslYear & "/" & lngSecEndCslMonth & "/" & lngSecEndCslDay)

	'一括予約処理
'	Ret = objConsult.InsertConsultFromResult(strUpdUser, dtmStrCslDate, dtmEndCslDate, strArrCsCd, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strCtrPtCd, dtmSecStrCslDate, dtmSecEndCslDate)

	strCommand = "cscript " & Server.MapPath("/webHains/script") & "\InsertConsultFromResult.vbs"
	strCommand = strCommand & " " & strUpdUser
	strCommand = strCommand & " " & dtmStrCslDate
	strCommand = strCommand & " " & dtmEndCslDate
	strCommand = strCommand & " " & Join(strArrCsCd, ",")
	strCommand = strCommand & " " & strOrgCd1
	strCommand = strCommand & " " & strOrgCd2
	strCommand = strCommand & " " & IIf(strOrgBsdCd     <> "", strOrgBsdCd,     """""")
	strCommand = strCommand & " " & IIf(strOrgRoomCd    <> "", strOrgRoomCd,    """""")
	strCommand = strCommand & " " & IIf(strStrOrgPostCd <> "", strStrOrgPostCd, """""")
	strCommand = strCommand & " " & IIf(strEndOrgPostCd <> "", strEndOrgPostCd, """""")
	strCommand = strCommand & " " & strCtrPtCd
	strCommand = strCommand & " " & dtmSecStrCslDate
	strCommand = strCommand & " " & dtmSecEndCslDate

	'取り込み処理起動
	Set objExec = Server.CreateObject("HainsCooperation.Exec")
	objExec.Run strCommand
	Ret = 0

	'自画面をリダイレクト
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?strCslYear="  & lngStrCslYear
	strURL = strURL & "&strCslMonth=" & lngStrCslMonth
	strURL = strURL & "&strCslDay="   & lngStrCslDay
	strURL = strURL & "&endCslYear="  & lngEndCslYear
	strURL = strURL & "&endCslMonth=" & lngEndCslMonth
	strURL = strURL & "&endCslDay="   & lngEndCslDay

	For i = 0 To UBound(strArrCsCd)
		strURL = strURL & "&csCd=" & strArrCsCd(i)
	Next

	strURL = strURL & "&orgCd1="         & strOrgCd1
	strURL = strURL & "&orgCd2="         & strOrgCd2
	strURL = strURL & "&orgBsdCd="       & strOrgBsdCd
	strURL = strURL & "&orgRoomCd="      & strOrgRoomCd
	strURL = strURL & "&strOrgPostCd="   & strStrOrgPostCd
	strURL = strURL & "&endOrgPostCd="   & strEndOrgPostCd
	strURL = strURL & "&ctrPtCd="        & strCtrPtCd
	strURL = strURL & "&secStrCslYear="  & lngSecStrCslYear
	strURL = strURL & "&secStrCslMonth=" & lngSecStrCslMonth
	strURL = strURL & "&secStrCslDay="   & lngSecStrCslDay
	strURL = strURL & "&secEndCslYear="  & lngSecEndCslYear
	strURL = strURL & "&secEndCslMonth=" & lngSecEndCslMonth
	strURL = strURL & "&secEndCslDay="   & lngSecEndCslDay
	strURL = strURL & "&count="          & Ret
	Response.Redirect strURL
	Response.End

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 引数値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim strStrCslDate		'開始受診日
	Dim strEndCslDate		'終了受診日
	Dim strSecStrCslDate	'割り当て開始日
	Dim strSecEndCslDate	'割り当て終了日
	Dim strMessage			'エラーメッセージの集合
	Dim blnError			'エラーフラグ

	Dim strAllCsCd			'コースコード
	Dim strAllCsName		'コース名
	Dim strAllSecondFlg		'２次健診フラグ
	Dim lngCsCount			'コース数

	Dim blnIsSecond			'２次健診コースか
	Dim i, j				'インデックス

	blnError = False

	'開始受診日のチェック
	strStrCslDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
	If Not IsDate(strStrCslDate) Then
		objCommon.appendArray strMessage, "開始受診日の入力形式が正しくありません。"
		blnError = True
	End If

	'終了受診日のチェック
	strEndCslDate = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay
	If Not IsDate(strEndCslDate) Then
		objCommon.appendArray strMessage, "終了受診日の入力形式が正しくありません。"
		blnError = True
	End If

	'システム日付以上の日付範囲は指定できない
	If Not blnError Then
		If CDate(strStrCslDate) >= Date() Or CDate(strEndCslDate) >= Date() Then
			objCommon.appendArray strMessage, "本日以降（本日分含む）の受診情報は指定できません。"
		End If
	End If

	'団体コードのチェック
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.appendArray strMessage, "団体を指定して下さい。"
	End If

	'コースコードのチェック
	If IsEmpty(strArrCsCd) Then
		objCommon.appendArray strMessage, "コースを指定して下さい。"
	End If

	'契約パターンコードのチェック
	If strCtrPtCd = "" Then
		objCommon.appendArray strMessage, "契約パターンを指定して下さい。"
	End If

	'割り当て開始日のチェック
	strSecStrCslDate = lngSecStrCslYear & "/" & lngSecStrCslMonth & "/" & lngSecStrCslDay
	If Not IsDate(strSecStrCslDate) Then
		objCommon.appendArray strMessage, "割り当て開始日の入力形式が正しくありません。"
		blnError = True
	End If

	'割り当て終了日のチェック
	strSecEndCslDate = lngSecEndCslYear & "/" & lngSecEndCslMonth & "/" & lngSecEndCslDay
	If Not IsDate(strSecEndCslDate) Then
		objCommon.appendArray strMessage, "割り当て終了日の入力形式が正しくありません。"
		blnError = True
	End If

	'割り当て期間は１次受診日期間より未来でなければならない
	If Not blnError Then
		If CDate(strSecStrCslDate) <= CDate(strStrCslDate) Or CDate(strSecStrCslDate) <= CDate(strEndCslDate) Or _
		   CDate(strSecEndCslDate) <= CDate(strStrCslDate) Or CDate(strSecEndCslDate) <= CDate(strEndCslDate) Then
			objCommon.appendArray strMessage, "割り当て期間は１次受診日期間より未来の日付を指定してください。"
		End If
	End If

	'２次受診日は指定契約パターンの契約期間内に存在しなければならない
	If (Not blnError) And strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then
		If CDate(strSecStrCslDate) < dtmStrDate Or CDate(strSecStrCslDate) > dtmEndDate Or _
		   CDate(strSecEndCslDate) < dtmStrDate Or CDate(strSecEndCslDate) > dtmEndDate Then
			objCommon.appendArray strMessage, "割り当て期間は契約期間の範囲内で指定してください。"
		End If
	End If

	'契約コースと指定コースとの関連チェック
	Do

		'コース、契約パターンが指定されていない場合は何もしない
		If IsEmpty(strArrCsCd) Or strOrgCd1 = "" Or strOrgCd2 = "" Or strCtrPtCd = "" Then
			Exit Do
		End If

		'全ての主コースを取得
		lngCsCount = objCourse.SelectCourseList(strAllCsCd, strAllCsName, strAllSecondFlg, 1)

		'契約コースが２次健診のものかを調査
		blnIsSecond = False
		For i = 0 To lngCsCount - 1
			If strCsCd = strAllCsCd(i) And strAllSecondFlg(i) = "1" Then
				blnIsSecond = True
				Exit For
			End If
		Next

		'２次健診コースでなければ問題なし
		If Not blnIsSecond Then
			Exit Do
		End If

		'２次健診コースであれば指定コースは必ず１次健診でなければならない
		'(２次健診コースには必ず１次受診日を関連付けする必要があるため)
		For i = 0 To UBound(strArrCsCd)
			For j = 0 To lngCsCount - 1
				If strArrCsCd(i) = strAllCsCd(j) And strAllSecondFlg(j) <> "0" Then
					objCommon.appendArray strMessage, "２次健診の一括予約を行う場合、選択可能なコースは１次健診のみです。"
					Exit Do
				End If
			Next
		Next

		Exit Do
	Loop

	'戻り値の編集
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>健診結果からの２次一括予約</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', strOrgPostCd, 'strOrgPostName', endOrgPostCd, 'endOrgPostName' );
		orgPostGuide_getPatternElement( ctrPtCd, 'csName', 'strDate', 'endDate');
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return confirm('この内容で一括予約処理を行います。よろしいですか？')">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">健診結果からの２次一括予約</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Do

		'件数未指定時は通常のメッセージ編集
		If strCount = "" then
			EditMessage strMessage, MESSAGETYPE_WARNING
			Exit Do
		End If

'		'０件の場合
'		If strCount = "0" Then
'			EditMessage "受診情報は作成されませんでした。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL
'			Exit Do
'		End If
'
'		'１件以上処理された場合
'		EditMessage strCount & "件の受診情報が作成されました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL

		EditMessage "健診結果からの２次一括予約処理が開始されました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL
		Exit Do
	Loop
%>
	<BR>

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="strOrgPostCd" VALUE="<%= strStrOrgPostCd %>">
	<INPUT TYPE="hidden" NAME="endOrgPostCd" VALUE="<%= strEndOrgPostCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>１次受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, lngStrCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, lngStrCslDay, False) %></TD>
			<TD>日</TD>
			<TD>～</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, lngEndCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, lngEndCslDay, False) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR VALIGN="top">
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" ALT=""><BR><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" ALT=""><BR>コース</TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" ALT=""><BR>：</TD>
			<TD><% Tokyu_EditCourseTable 1, "csCd", strArrCsCd, 2 %></TD>
		</TR>
	</TABLE>
<%
	'各種名称の取得
	Do

		'団体コード未指定時は何もしない
		If strOrgCd1 = "" Or strOrgCd2 = "" Then
			Exit Do
		End If

		'団体名称の読み込み
		If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
			Err.Raise 1000, , "団体情報が存在しません。"
		End If

		'事業部コード未指定時は何もしない
		If strOrgBsdCd = "" Then
			Exit Do
		End If

		'事業部名称の読み込み
		If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName) = False Then
			Err.Raise 1000, , "事業部情報が存在しません。"
		End If

		'室部コード未指定時は何もしない
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'室部名称の読み込み
		If objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName) = False Then
			Err.Raise 1000, , "室部情報が存在しません。"
		End If

		'開始所属名称の読み込み
		If strStrOrgPostCd <> "" Then
			If objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strStrOrgPostName) = False Then
				Err.Raise 1000, , "所属情報が存在しません。"
			End If
		End If

		'終了所属名称の読み込み
		If strEndOrgPostCd <> "" Then
			If objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strEndOrgPostCd, strEndOrgPostName) = False Then
				Err.Raise 1000, , "所属情報が存在しません。"
			End If
		End If

		Exit Do
	Loop
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>団体</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
<!--
			<TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
-->
			<TD></TD>
			<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD NOWRAP>事業部</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD NOWRAP>室部</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
		</TR>
	</TABLE>
	
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH=90" NOWRAP>所属</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="strOrgPostName"><%= strStrOrgPostName %></SPAN></TD>
			<TD>～</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="endOrgPostName"><%= strEndOrgPostName %></SPAN></TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>契約パターン</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuidePattern()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="契約パターン検索ガイドを表示"></A></TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></TD>
			<TD NOWRAP>
				<SPAN ID="csName"><%= strCsName %></SPAN>&nbsp;
				<SPAN ID="strDate"><%= IIf(Not IsEmpty(dtmStrDate), objCommon.FormatString(dtmStrDate, "yyyy年m月d日"), "") %></SPAN><SPAN ID="endDate"><%= IIf(Not IsEmpty(dtmEndDate), objCommon.FormatString(dtmEndDate, "～yyyy年m月d日"), "") %></SPAN>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>割り当て期間</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('secStrCslYear', 'secStrCslMonth', 'secStrCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("secStrCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngSecStrCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("secStrCslMonth", 1, 12, lngSecStrCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("secStrCslDay", 1, 31, lngSecStrCslDay, False) %></TD>
			<TD>日</TD>
			<TD>～</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('secEndCslYear', 'secEndCslMonth', 'secEndCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("secEndCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngSecEndCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("secEndCslMonth", 1, 12, lngSecEndCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("secEndCslDay", 1, 31, lngSecEndCslDay, False) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="rsvAllMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
	<INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この条件で予約する">

	<BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGRSVCON"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>