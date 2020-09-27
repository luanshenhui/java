<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		長期未受診者の削除 (Ver0.0.1)
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

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'COMオブジェクト
'Dim objCooperation		'連携・一括処理用
Dim objOrganization		'団体情報アクセス用

'引数値
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim lngStrCslYear		'開始受診年
Dim lngStrCslMonth		'開始受診月
Dim lngStrCslDay		'開始受診日
Dim lngEndCslYear		'終了受診年
Dim lngEndCslMonth		'終了受診月
Dim lngEndCslDay		'終了受診日
Dim strDelFlg			'使用中フラグ
Dim strCount			'削除件数

Dim strOrgName			'団体名称
Dim dtmStrCslDate		'開始受診年月日
Dim dtmEndCslDate		'終了受診年月日
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

'引数値の取得
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
lngStrCslYear  = CLng("0" & Request("strCslYear"))
lngStrCslMonth = CLng("0" & Request("strCslMonth"))
lngStrCslDay   = CLng("0" & Request("strCslDay"))
lngEndCslYear  = CLng("0" & Request("endCslYear"))
lngEndCslMonth = CLng("0" & Request("endCslMonth"))
lngEndCslDay   = CLng("0" & Request("endCslDay"))
strDelFlg      = Request("delFlg")
strCount       = Request("count")

'チェック・更新・読み込み処理の制御
Do

	'「確定」ボタン押下時以外は何もしない
	If IsEmpty(Request("delete.x")) Then
		Exit Do
	End If

	'入力チェック
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		Exit Do
	End If

	'受診年月日の編集
	dtmStrCslDate = CDate(lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay)
	dtmEndCslDate = CDate(lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay)

	'個人情報一括更新処理
'	Set objCooperation = Server.CreateObject("HainsCooperation.PersonAll")
'	Ret = objCooperation.UpdateStatus(strOrgCd1, strOrgCd2, dtmStrCslDate, dtmEndCslDate, strDelFlg)

	strCommand = "cscript " & Server.MapPath("/webHains/script") & "\UpdatePersonalStatus.vbs"
	strCommand = strCommand & " " & strOrgCd1
	strCommand = strCommand & " " & strOrgCd2
	strCommand = strCommand & " " & dtmStrCslDate
	strCommand = strCommand & " " & dtmEndCslDate
	strCommand = strCommand & " " & strDelFlg

	'スクリーニング処理起動
	Set objExec = Server.CreateObject("HainsCooperation.Exec")
	objExec.Run strCommand
	Ret = 0

	'自画面をリダイレクト
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?orgCd1="      & strOrgCd1
	strURL = strURL & "&orgCd2="      & strOrgCd2
	strURL = strURL & "&strCslYear="  & lngStrCslYear
	strURL = strURL & "&strCslMonth=" & lngStrCslMonth
	strURL = strURL & "&strCslDay="   & lngStrCslDay
	strURL = strURL & "&endCslYear="  & lngEndCslYear
	strURL = strURL & "&endCslMonth=" & lngEndCslMonth
	strURL = strURL & "&endCslDay="   & lngEndCslDay
	strURL = strURL & "&delFlg="      & strDelFlg
	strURL = strURL & "&count="       & Ret
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

	Dim objCommon	'共通クラス
	Dim strDate		'日付
	Dim strMessage	'エラーメッセージの集合

	'オブジェクトのインスタンス作成
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'開始受診日チェック
	Do

		'必須チェック
		If lngStrCslYear + lngStrCslMonth + lngStrCslDay = 0 Then
			objCommon.appendArray strMessage, "開始受診日を入力して下さい。"
			Exit Do
		End If

		'開始受診日の編集
		strDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
		If Not IsDate(strDate) Then
			objCommon.appendArray strMessage, "開始受診日の入力形式が正しくありません。"
		End If

		Exit Do
	Loop

	'終了受診日チェック
	Do

		'必須チェック
		If lngEndCslYear + lngEndCslMonth + lngEndCslDay = 0 Then
			objCommon.appendArray strMessage, "終了受診日を入力して下さい。"
			Exit Do
		End If

		'終了受診日の編集
		strDate = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay
		If Not IsDate(strDate) Then
			objCommon.appendArray strMessage, "終了受診日の入力形式が正しくありません。"
		End If

		Exit Do
	Loop

	'使用状態チェック
	If strDelFlg = "" Then
		objCommon.appendArray strMessage, "使用状態を選択して下さい。"
	End If

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
<TITLE>長期未受診者の削除</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<STYLE TYPE="text/css">
td.mnttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return confirm('この条件で長期未受診者の削除処理を行います。よろしいですか？')">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">長期未受診者の削除</FONT></B></TD>
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

		EditMessage "個人情報の更新処理を開始しました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL
		Exit Do

		'０件の場合
		If strCount = "0" Then
			EditMessage "更新対象となる個人情報はありませんでした。", MESSAGETYPE_NORMAL
			Exit Do
		End If

		'１件以上処理された場合
		EditMessage strCount & "件の個人情報が更新されました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL
		Exit Do
	Loop
%>
	<BR>
<%
	'団体名称の読み込み
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
		Err.Raise 1000, , "団体情報が存在しません。"
	End If
%>
	対象団体：<B><%= strOrgName %></B><BR><BR>
	<FONT COLOR="#cc9999">●</FONT>指定された受診期間において未受診である個人情報の使用状態を更新します。<BR><BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD NOWRAP>検索する受診期間</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCslYear, True) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("strCslMonth", 1, 12, lngStrCslMonth, True) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("strCslDay", 1, 31, lngStrCslDay, True) %></TD>
						<TD NOWRAP>日～</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCslYear, True) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("endCslMonth", 1, 12, lngEndCslMonth, True) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("endCslDay", 1, 31, lngEndCslDay, True) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>更新する使用状態</TD>
			<TD>：</TD>
			<TD>
				<SELECT NAME="delFlg">
					<OPTION VALUE="">&nbsp;
					<OPTION VALUE="0" <%= IIf(strDelFlg = "0", "SELECTED", "") %>>使用中
					<OPTION VALUE="1" <%= IIf(strDelFlg = "1", "SELECTED", "") %>>削除済（退職扱い）
					<OPTION VALUE="2" <%= IIf(strDelFlg = "2", "SELECTED", "") %>>休職中
				</SELECT>
			</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="../organization/mntOrganization.asp?mode=update&orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
	<INPUT TYPE="image" NAME="delete" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この条件で削除する">

	<BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGUPDSTA"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>