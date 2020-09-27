<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		オプション検査の一括更新 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
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
Dim objOrganization		'団体情報アクセス用

'引数値
Dim lngStrCslYear		'開始受診年
Dim lngStrCslMonth		'開始受診月
Dim lngStrCslDay		'開始受診日
Dim lngEndCslYear		'終了受診年
Dim lngEndCslMonth		'終了受診月
Dim lngEndCslDay		'終了受診日
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strCtrPtCd			'契約パターンコード
Dim strReCreatePrice	'金額を再作成するか
Dim strCount			'更新件数

'契約情報
Dim strCsCd				'コースコード
Dim strCsName			'コース名
Dim dtmStrDate			'契約開始日
Dim dtmEndDate			'契約終了日

Dim strUpdUser			'更新者

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
Set objCommon       = Server.CreateObject("HainsCommon.Common")
'Set objConsult      = Server.CreateObject("HainsCooperation.ConsultAll")
Set objContract     = Server.CreateObject("HainsContract.Contract")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'更新者の設定
strUpdUser = Session("USERID")

'引数値の取得
lngStrCslYear    = CLng("0" & Request("strCslYear"))
lngStrCslMonth   = CLng("0" & Request("strCslMonth"))
lngStrCslDay     = CLng("0" & Request("strCslDay"))
lngEndCslYear    = CLng("0" & Request("endCslYear"))
lngEndCslMonth   = CLng("0" & Request("endCslMonth"))
lngEndCslDay     = CLng("0" & Request("endCslDay"))
strOrgCd1        = Request.QueryString("orgCd1")
strOrgCd2        = Request.QueryString("orgCd2")
strCtrPtCd       = Request.QueryString("ctrPtCd")
strReCreatePrice = Request("reCreatePrice")
strCount         = Request("count")

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

	'受診年月日の編集
	dtmStrCslDate = CDate(lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay)
	dtmEndCslDate = CDate(lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay)

	'年齢・性別等にて決定する標準オプションに更新する
'	Ret = objConsult.UpdateOption(dtmStrCslDate, dtmEndCslDate, strOrgCd1, strOrgCd2, strCtrPtCd, strReCreatePrice)

	strCommand = "cscript " & Server.MapPath("/webHains/script") & "\UpdateOption.vbs"
	strCommand = strCommand & " " & dtmStrCslDate
	strCommand = strCommand & " " & dtmEndCslDate
	strCommand = strCommand & " " & strOrgCd1
	strCommand = strCommand & " " & strOrgCd2
	strCommand = strCommand & " " & strCtrPtCd
	strCommand = strCommand & " " & IIf(strReCreatePrice <> "", strReCreatePrice, """""")

	'取り込み処理起動
	Set objExec = Server.CreateObject("HainsCooperation.Exec")
	objExec.Run strCommand
	Ret = 0

	'自画面をリダイレクト
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?strCslYear="    & lngStrCslYear
	strURL = strURL & "&strCslMonth="   & lngStrCslMonth
	strURL = strURL & "&strCslDay="     & lngStrCslDay
	strURL = strURL & "&endCslYear="    & lngEndCslYear
	strURL = strURL & "&endCslMonth="   & lngEndCslMonth
	strURL = strURL & "&endCslDay="     & lngEndCslDay
	strURL = strURL & "&orgCd1="        & strOrgCd1
	strURL = strURL & "&orgCd2="        & strOrgCd2
	strURL = strURL & "&ctrPtCd="       & strCtrPtCd
	strURL = strURL & "&reCreatePrice=" & strReCreatePrice
	strURL = strURL & "&count="         & Ret
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

	Dim strDate		'日付
	Dim strMessage	'エラーメッセージの集合

	'開始受診日チェック
	Do

		'必須チェック
		If lngStrCslYear + lngStrCslMonth + lngStrCslDay = 0 Then
			objCommon.AppendArray strMessage, "開始受診日を入力して下さい。"
			Exit Do
		End If

		'開始受診日の編集
		strDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
		If Not IsDate(strDate) Then
			objCommon.AppendArray strMessage, "開始受診日の入力形式が正しくありません。"
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

	'団体コードのチェック
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.appendArray strMessage, "団体を指定して下さい。"
	End If

	'契約パターンコードのチェック
	If strCtrPtCd = "" Then
		objCommon.appendArray strMessage, "契約パターンを指定して下さい。"
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
<TITLE>オプション検査の一括更新</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/ptnGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体検索ガイド画面を表示
function showGuideOrg() {

	// 団体検索ガイド画面を表示
	with ( document.entryForm ) {
		ptnGuide_Val_OrgCd1 = orgCd1.value;
		ptnGuide_Val_OrgCd2 = orgCd2.value;
		orgGuide_showGuideOrg( orgCd1, orgCd2, 'orgName', null, null, checkClearSelectOrg, false, null, '0' );
	}

}

// 団体選択時の契約パターンクリアのチェック
function checkClearSelectOrg() {

	// 先に退避した団体と現在の団体が同一な場合は何もしない
	if ( orgGuide_OrgCd1.value == ptnGuide_Val_OrgCd1 && orgGuide_OrgCd2.value == ptnGuide_Val_OrgCd2 ) {
		return;
	}

	// 契約パターンのクリア
	ptnGuide_clearPatternInfo( document.entryForm.ctrPtCd, 'csName', 'strDate', 'endDate' );

}

// 契約パターン検索ガイド画面を表示
function showGuidePattern() {

	// 契約パターン検索ガイド画面を表示
	with ( document.entryForm ) {
		orgGuide_OrgCd1  = orgCd1;
		orgGuide_OrgCd2  = orgCd2;
		orgGuide_OrgName = document.getElementById( 'orgName' );
		ptnGuide_showGuidePattern( ctrPtCd, 'csName', 'strDate', 'endDate', setOrgInfo, orgCd1, orgCd2, '1' );
	}

}

// 契約パターン選択時の処理
function setOrgInfo() {

	// 団体情報の編集
	orgGuide_setOrgInfo( ptnGuide_Val_OrgCd1, ptnGuide_Val_OrgCd2, ptnGuide_Val_OrgName );

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return confirm('この内容で一括更新処理を行います。よろしいですか？')">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">オプション検査の一括更新</FONT></B></TD>
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
'			EditMessage "更新対象となる受診情報はありませんでした。", MESSAGETYPE_NORMAL
'			Exit Do
'		End If
'
'		'１件以上処理された場合
'		EditMessage strCount & "件の受診情報が更新されました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL

		EditMessage "オプション検査の一括更新処理が開始されました。詳細はシステムログを参照して下さい。", MESSAGETYPE_NORMAL

		Exit Do
	Loop
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>受診日</TD>
			<TD>：</TD>
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

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
<%
	'団体名称の読み込み
	If strOrgCd1 <> "" And strOrgCd2 <> "" Then
		If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
			Err.Raise 1000, , "団体情報が存在しません。"
		End If
	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>団体</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">
<%
	'契約情報の読み込み
	If strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then
		If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
			Err.Raise 1000, ,"契約情報が存在しません。"
		End If
	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>契約パターン</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuidePattern()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="契約パターン検索ガイドを表示"></A></TD>
			<TD NOWRAP>
				<SPAN ID="csName"><%= strCsName %></SPAN>&nbsp;
				<SPAN ID="strDate"><%= IIf(Not IsEmpty(dtmStrDate), objCommon.FormatString(dtmStrDate, "yyyy年m月d日"), "") %></SPAN><SPAN ID="endDate"><%= IIf(Not IsEmpty(dtmEndDate), objCommon.FormatString(dtmEndDate, "～yyyy年m月d日"), "") %></SPAN>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>その他</TD>
			<TD>：</TD>
			<TD>
				<INPUT TYPE="hidden" NAME="reCreatePrice" VALUE="<%= strReCreatePrice %>">
				<INPUT TYPE="checkbox" <%= IIf(strReCreatePrice = "1", "CHECKED", "") %> ONCLICK="javascript:document.entryForm.reCreatePrice.value = this.checked ? '1' : ''">
			</TD>
			<TD NOWRAP>受診金額の再作成も同時に行う</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="rsvAllMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
	<INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この条件で更新する">

	<BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGUPDOPT"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>