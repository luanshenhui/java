<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		検査依頼 (Ver0.0.1)
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

'タイムアウトを２０分に設定
'Server.ScriptTimeOut = 20 * 60

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const FREECD_REQFILE = "REQFILE"	'検査依頼ファイル情報

'COMオブジェクト
Dim objFree			'汎用情報アクセス用
Dim objPerson		'個人情報アクセス用
Dim objRequest		'検査依頼処理用
'Dim objResponse		'結果取り込み処理用

'引数値
Dim strMode			'処理モード
Dim lngCslYear		'受診年
Dim lngCslMonth		'受診月
Dim lngCslDay		'受診日
Dim strPerId		'個人ＩＤ
Dim strIncSentData	'送信済みデータを対象とするか("1":対象)
Dim strCount		'依頼件数
Dim strStat			'コピー処理の結果

'個人情報
Dim strEmpNo		'従業員番号
Dim strLastName		'姓
Dim strFirstName	'名

Dim strFilePath		'依頼情報ファイル格納パス
Dim strFileName		'依頼情報ファイル名
Dim strSharePath	'検査システムとの共有パス

Dim strCslDate		'受診年月日
Dim strMessage		'エラーメッセージ
Dim lngMessageType	'メッセージタイプ
Dim strURL			'ジャンプ先のURL
Dim Ret				'関数戻り値
Dim i				'インデックス

Dim objExec			'取り込み処理実行用

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFree     = Server.CreateObject("HainsFree.Free")
Set objPerson   = Server.CreateObject("HainsPerson.Person")
'Set objResponse = Server.CreateObject("HainsCooperation.Response")

'引数値の取得
strMode        = Request("mode")
lngCslYear     = CLng("0" & Request("cslYear"))
lngCslMonth    = CLng("0" & Request("cslMonth"))
lngCslDay      = CLng("0" & Request("cslDay"))
strPerId       = Request("perId")
strIncSentData = Request("incSentData")
strCount       = Request("count")
strStat        = Request("stat")

'処理モードのデフォルト値設定(デフォルトはメニューいちばん上の「コピー」)
strMode = IIf(strMode = "", "3", strMode)

'受診開始・終了日のデフォルト値設定
'(受診開始年が０になるケースは初期表示時以外にない)
If lngCslYear = 0 Then
	lngCslYear  = Year(Date())
	lngCslMonth = Month(Date())
	lngCslDay   = Day(Date())
End If

'チェック・更新・読み込み処理の制御
Do

	'「確定」ボタン押下時以外は何もしない
	If IsEmpty(Request("x")) Then
		Exit Do
	End If

	'処理モードごとの連携処理
	Select Case strMode

		Case "1"	'検査依頼時

			'受診年月日のチェック
			strCslDate = lngCslYear & "/" & lngCslMonth & "/" & lngCslDay
			If Not IsDate(strCslDate) Then
				strMessage = "受診日の入力形式が正しくありません。"
				Exit Do
			End If

'			'検査依頼処理
'			Ret = objRequest.CreateFile(strCslDate, strPerId, (strIncSentData <> ""))

			'取り込み処理起動
			Set objExec = Server.CreateObject("HainsCooperation.Exec")
			objExec.Run "cscript " & Server.MapPath("/webHains/script") & "\CreateRequestFile.vbs " & strCslDate & " " & IIf(strPerId <> "", strPerId, """""") & " " & (strIncSentData <> "")
			Ret = 0

		Case "2"	'結果取り込み時

'			'結果取り込み処理
'			Ret = objResponse.ImportFile()

			'取り込み処理起動
			Set objExec = Server.CreateObject("HainsCooperation.Exec")
			objExec.Run "cscript " & Server.MapPath("/webHains/script") & "\ImportResultFile.vbs"
			Ret = 0

		Case "3"	'検査依頼ファイルのコピー

			'汎用テーブルから検査依頼ファイル情報を取得
			Ret = objFree.SelectFree(0, FREECD_REQFILE, , , , strFilePath, strFileName, strSharePath)
			If Ret = False Or strFilePath = "" Or strFileName = "" Or strSharePath = "" Then
				strMessage = "汎用テーブルにおける検査依頼情報の設定に誤りがあります。"
				Exit Do
			End If

			'検査依頼ファイルのコピー
			strFilePath  = strFilePath  & IIf(Right(strFilePath,  1) <> "\", "\", "")
			strSharePath = strSharePath & IIf(Right(strSharePath, 1) <> "\", "\", "")
			Set objRequest = Server.CreateObject("HainsCooperation.Request")
			Ret = objRequest.CopyFile(strFilePath & strFileName, strSharePath & strFileName)

		Case Else
			Exit Do

	End Select

	'自画面をリダイレクト
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?mode="        & strMode
	strURL = strURL & "&cslYear="     & lngCslYear
	strURL = strURL & "&cslMonth="    & lngCslMonth
	strURL = strURL & "&cslDay="      & lngCslDay
	strURL = strURL & "&perId="       & strPerId
	strURL = strURL & "&incSentData=" & strIncSentData
	If strMode = "1" Or strMode = "2" Then
		strURL = strURL & "&count="   & Ret
	Else
		strURL = strURL & "&stat="    & Ret
	End If
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
<TITLE>検査依頼</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 個人検索ガイド呼び出し
function callPersonGuide() {

	// 個人ガイド表示
	perGuide_showGuidePersonal( document.entryForm.perId, 'perName', null, setEmpNo );

}

// 従業員番号の編集
function setEmpNo( perInfo ) {

	document.getElementById('empNo').innerHTML = ( perInfo.empNo != '' ) ? perInfo.empNo + '：' : '';


}

// 個人情報のクリア
function clearPersonInfo() {

	with ( document ) {
		entryForm.perId.value               = '';
		getElementById('empNo').innerHTML   = '';
		getElementById('perName').innerHTML = '';
	}

}

// 確認メッセージの表示
function showConfirmMessage() {

	var msg;	// メッセージ

	if ( document.entryForm.mode[ 0 ].checked ) {
		msg = '検査依頼ファイルのコピー';
	}

	if ( document.entryForm.mode[ 1 ].checked ) {
		msg = '結果取り込み';
	}

	if ( document.entryForm.mode[ 2 ].checked ) {
		msg = 'この内容で検査依頼';
	}

	return confirm( msg  + 'を行います。よろしいですか？' );

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return showConfirmMessage()">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">検査依頼</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Do

		'コピー処理が行われた場合
		If strStat <> "" Then

			Select Case CLng(strStat)
				Case 0
					strMessage = "検査依頼ファイルのコピーが行われました。"
					lngMessageType = MESSAGETYPE_NORMAL
				Case -1
					strMessage = "検査依頼ファイルは存在しませんでした。"
					lngMessageType = MESSAGETYPE_NORMAL
				Case -2
					strMessage = "検査依頼ファイルは現在使用中です。"
					lngMessageType = MESSAGETYPE_WARNING
				Case -3
					strMessage = "コピー先のファイルは現在使用中です。"
					lngMessageType = MESSAGETYPE_WARNING
				Case Else
					strMessage = "コピー処理において書き込みエラーが発生しました。"
					lngMessageType = MESSAGETYPE_WARNING
			End Select

			EditMessage strMessage, lngMessageType
			Exit Do

		End If

		'件数未指定時は通常のメッセージ編集
		If strCount = "" then
			EditMessage strMessage, MESSAGETYPE_WARNING
			Exit Do
		End If

		'結果取り込みの場合
		If strMode = "2" Then
			strMessage = "検査結果の取り込み処理が開始されました。詳細はシステムログを参照して下さい。"
			EditMessage strMessage, MESSAGETYPE_NORMAL
			Exit Do
		End If

		EditMessage "検査依頼ファイルの作成処理が開始されました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL
		Exit Do

		'０件の場合
		If strCount = "0" Then
			strMessage = IIf(strMode = "1", "依頼情報は作成されませんでした。", "取り込み対象となるレコードは存在しませんでした。")
			EditMessage strMessage & "詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL
			Exit Do
		End If

		'１件以上処理された場合
		strMessage = strCount & "件の" & IIf(strMode = "1", "依頼情報が作成されました。", "レコードが取り込まれました。")
		EditMessage strMessage & "詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL
		Exit Do
	Loop
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="3" <%= IIf(strMode = "3", "CHECKED", "") %>></TD>
			<TD NOWRAP>検査依頼ファイルのコピーを行う</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="2" <%= IIf(strMode = "2", "CHECKED", "") %>></TD>
			<TD NOWRAP>検査結果の取り込みを行う</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD HEIGHT="35" VALIGN="bottom"><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGRESISP"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = "1", "CHECKED", "") %>></TD>
			<TD NOWRAP>検査依頼ファイルを作成する</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD WIDTH="20"></TD>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
<%
	'個人情報読み込み
	If strPerId <> "" Then
		objPerson.SelectPerson strPerId, strLastName, strFirstName, , , , , , , , , , , , , , , , , , , , , , , , ,strEmpNo
	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD WIDTH="20"></TD>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>従業員指定</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearPersonInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="empNo"><%= IIf(strEmpNo <> "", strEmpNo & "：", "") %></SPAN><SPAN ID="perName"><%= strLastName & "&nbsp;&nbsp;" & strFirstName %></SPAN></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD WIDTH="20"></TD>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>その他</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="checkbox" NAME="incSentData" VALUE="1" <%= IIf(strIncSentData = "1", "CHECKED", "") %>></TD>
			<TD>すでに送信されたデータも対象とする</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD WIDTH="20"></TD>
			<TD HEIGHT="35" VALIGN="bottom"><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGREQISP"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="/webHains/contents/reserve/rsvMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
	<INPUT TYPE="image" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この条件で確定する">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>