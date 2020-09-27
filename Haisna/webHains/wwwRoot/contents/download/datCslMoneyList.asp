<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		個人受診金額一覧 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode			'印刷モード
Dim vntMessage		'通知メッセージ

'-------------------------------------------------------------------------------
' 固有宣言部
'-------------------------------------------------------------------------------
'引数値
Dim lngGetMode			'抽出モード(0:受診日指定、1:締め日指定)
Dim lngStrCslYear		'開始受診年
Dim lngStrCslMonth		'開始受診月
Dim lngStrCslDay		'開始受診日
Dim lngEndCslYear		'終了受診年
Dim lngEndCslMonth		'終了受診月
Dim lngEndCslDay		'終了受診日
Dim strCsCd				'コースコード
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgBsdCd		'事業部コード 
Dim strOrgRoomCd		'室部コード
Dim strStrOrgPostCd		'開始所属コード
Dim strEndOrgPostCd		'終了所属コード
Dim strAllowUnReceipt	'"1":未受付データを抽出しない
Dim lngStrCloseYear		'開始締め年
Dim lngStrCloseMonth	'開始締め月
Dim lngStrCloseDay		'開始締め日
Dim lngEndCloseYear		'終了締め年
Dim lngEndCloseMonth	'終了締め月
Dim lngEndCloseDay		'終了締め日
Dim strBdnOrgCd1		'負担元団体コード１
Dim strBdnOrgCd2		'負担元団体コード２
Dim strBillNo			'請求書番号

'作業用変数
Dim strOrgName			'団体名称
Dim strBsdName			'事業部名称
Dim strRoomName			'室部名称
Dim	strStrOrgPostName	'開始所属名称
Dim strEndOrgPostName	'終了所属名称
Dim strStrCslDate		'開始受診年月日
Dim strEndCslDate		'終了受診年月日
Dim strStrCloseDate		'開始締め年月日
Dim strEndCloseDate		'終了締め年月日
Dim strBdnOrgName		'負担元団体名称

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'共通引数値の取得
strMode = Request("mode")

'帳票出力処理制御
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' 機能　　 : URL引数値の取得
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

	Dim objOrganization	'団体情報アクセス用
	Dim objOrgBsd		'事業部情報アクセス用
	Dim objOrgRoom		'室部情報アクセス用
	Dim objOrgPost		'所属情報アクセス用

	'抽出モード
	lngGetMode = CLng("0" & Request("getMode"))

	'開始受診年月日
	lngStrCslYear  = CLng("0" & Request("strCslYear"))
	lngStrCslMonth = CLng("0" & Request("strCslMonth"))
	lngStrCslDay   = CLng("0" & Request("strCslDay"))
	lngStrCslYear  = IIf(lngStrCslYear  <> 0, lngStrCslYear,  Year(Date))
	lngStrCslMonth = IIf(lngStrCslMonth <> 0, lngStrCslMonth, Month(Date))
	lngStrCslDay   = IIf(lngStrCslDay   <> 0, lngStrCslDay,   Day(Date))
	strStrCslDate  = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay

	'終了受診年月日
	lngEndCslYear  = CLng("0" & Request("endCslYear"))
	lngEndCslMonth = CLng("0" & Request("endCslMonth"))
	lngEndCslDay   = CLng("0" & Request("endCslDay"))
	lngEndCslYear  = IIf(lngEndCslYear  <> 0, lngEndCslYear,  Year(Date))
	lngEndCslMonth = IIf(lngEndCslMonth <> 0, lngEndCslMonth, Month(Date))
	lngEndCslDay   = IIf(lngEndCslDay   <> 0, lngEndCslDay,   Day(Date))
	strEndCslDate  = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay

	'コースコード
	strCsCd = Request("csCd")

	'対象データ
	strAllowUnReceipt = IIf(strMode <> "", Request("allowUnReceipt"), "1")

	'開始締め年月日
	lngStrCloseYear  = CLng("0" & Request("strCloseYear"))
	lngStrCloseMonth = CLng("0" & Request("strCloseMonth"))
	lngStrCloseDay   = CLng("0" & Request("strCloseDay"))
	lngStrCloseYear  = IIf(lngStrCloseYear  <> 0, lngStrCloseYear,  Year(Date))
	lngStrCloseMonth = IIf(lngStrCloseMonth <> 0, lngStrCloseMonth, Month(Date))
	lngStrCloseDay   = IIf(lngStrCloseDay   <> 0, lngStrCloseDay,   Day(Date))
	strStrCloseDate  = lngStrCloseYear & "/" & lngStrCloseMonth & "/" & lngStrCloseDay

	'終了締め年月日
	lngEndCloseYear  = CLng("0" & Request("endCloseYear"))
	lngEndCloseMonth = CLng("0" & Request("endCloseMonth"))
	lngEndCloseDay   = CLng("0" & Request("endCloseDay"))
	lngEndCloseYear  = IIf(lngEndCloseYear  <> 0, lngEndCloseYear,  Year(Date))
	lngEndCloseMonth = IIf(lngEndCloseMonth <> 0, lngEndCloseMonth, Month(Date))
	lngEndCloseDay   = IIf(lngEndCloseDay   <> 0, lngEndCloseDay,   Day(Date))
	strEndCloseDate  = lngEndCloseYear & "/" & lngEndCloseMonth & "/" & lngEndCloseDay

	'請求書番号
	strBillNo = Request("billNo")

	'負担元団体
	strBdnOrgCd1 = Request("bdnOrgCd1")
	strBdnOrgCd2 = Request("bdnOrgCd2")

	'団体名称読み込み
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	If strBdnOrgCd1 <> "" And strBdnOrgCd2 <> "" Then
'## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応
'		objOrganization.SelectOrg strBdnOrgCd1, strBdnOrgCd2, , strBdnOrgName
		objOrganization.SelectOrgName strBdnOrgCd1, strBdnOrgCd2, strBdnOrgName
'## 2004/06/28 MOD END
	End If

	'団体、事業部、室部、所属
	strOrgCd1       = Request("orgCd1")
	strOrgCd2       = Request("orgCd2")
'## 2004/06/28 DEL STR ORB)T.YAGUCHI 聖路加版対応
'	strOrgBsdCd     = Request("orgBsdCd")
'	strOrgRoomCd    = Request("orgRoomCd")
'	strStrOrgPostCd = Request("strOrgPostCd")
'	strEndOrgPostCd = Request("endOrgPostCd")
'## 2004/06/28 DEL END

	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		Exit Sub
	End If

	'団体名称読み込み
'## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応
'	objOrganization.SelectOrg strOrgCd1, strOrgCd2, , strOrgName
	objOrganization.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
'## 2004/06/28 MOD END

'## 2004/06/28 DEL STR ORB)T.YAGUCHI 聖路加版対応
'	If strOrgBsdCd = "" Then
'		Exit Sub
'	End If
'
'	'事業部名称読み込み
'	Set objOrgBsd = Server.CreateObject("HainsOrgBsd.OrgBsd")
'	objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, , strBsdName
'
'	If strOrgRoomCd = "" Then
'		Exit Sub
'	End If
'
'	'室部名称読み込み
'	Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
'	objOrgRoom.SelectOrgRoom strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strRoomName
'
'	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
'
'	'所属名称読み込み
'	If strStrOrgPostCd <> "" Then
'		objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strStrOrgPostName
'	End If
'
'	If strEndOrgPostCd <> "" Then
'		objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strEndOrgPostCd, strEndOrgPostName
'	End If
'## 2004/06/28 DEL END

End Sub
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

	Dim objCommon		'共通クラス
	Dim vntArrMessage	'エラーメッセージの集合

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	With objCommon

		'受診日指定の場合
		If lngGetMode = 0 Then

			If Not IsDate(strStrCslDate) Then
				.AppendArray vntArrMessage, "開始受診日の入力形式が正しくありません。"
			End If

			If Not IsDate(strEndCslDate) Then
				.AppendArray vntArrMessage, "終了受診日の入力形式が正しくありません。"
			End If

		'締め日指定の場合
		Else

			If Not IsDate(strStrCloseDate) Then
				.AppendArray vntArrMessage, "開始締め日の入力形式が正しくありません。"
			End If

			If Not IsDate(strEndCloseDate) Then
				.AppendArray vntArrMessage, "終了締め日の入力形式が正しくありません。"
			End If

'## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応
'			.AppendArray vntArrMessage, .CheckNumeric("請求書番号", strBillNo, 9)
			.AppendArray vntArrMessage, .CheckNumeric("請求書番号", strBillNo, 14)
'## 2004/06/28 MOD END

		End If

	End With

	'戻り値の編集
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 帳票ドキュメントファイル作成処理
'
' 引数　　 :
'
' 戻り値　 : 印刷ログ情報のシーケンス値
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objCslMoneyList	'個人受診金額一覧出力用COMコンポーネント

	Dim dtmStrCslDate	'開始受診日または締め日
	Dim dtmEndCslDate	'終了受診日または締め日
	Dim strParaOrgCd1	'団体コード１
	Dim strParaOrgCd2	'団体コード２
	Dim Ret				'関数戻り値

	'オブジェクトのインスタンス作成
	Set objCslMoneyList = Server.CreateObject("HainsCslMoneyList.CslMoneyList")

	'抽出モードごとの引数設定
	If lngGetMode = 0 Then
		dtmStrCslDate = CDate(strStrCslDate)
		dtmEndCslDate = CDate(strEndCslDate)
		strParaOrgCd1 = strOrgCd1
		strParaOrgCd2 = strOrgCd2
	Else
		dtmStrCslDate = CDate(strStrCloseDate)
		dtmEndCslDate = CDate(strEndCloseDate)
		strParaOrgCd1 = strBdnOrgCd1
		strParaOrgCd2 = strBdnOrgCd2
	End If

	'情報漏えい対策用ログ書き出し
	Call putPrivacyInfoLog("PH102", "データ抽出 個人受診金額一覧抽出よりファイル出力を行った")

'## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応
'	'個人受診金額一覧ドキュメントファイル作成処理
'	Ret = objCslMoneyList.PrintCslMoneyList(Session("USERID"), lngGetMode, dtmStrCslDate, dtmEndCslDate, strParaOrgCd1, strParaOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strCsCd, strBillNo, (strAllowUnReceipt <> "1"))
	'個人受診金額一覧ドキュメントファイル作成処理
	Ret = objCslMoneyList.PrintCslMoneyList(Session("USERID"), lngGetMode, dtmStrCslDate, dtmEndCslDate, strParaOrgCd1, strParaOrgCd2, strCsCd, strBillNo, (strAllowUnReceipt <> "1"))
'## 2004/06/28 MOD END

	Print = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>個人受診金額一覧</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
//'## 2004/06/28 DEL STR ORB)T.YAGUCHI 聖路加版対応
//// エレメントの参照設定
//function setElement() {
//
//	// 団体・所属情報エレメントの参照設定
//	with ( document.entryForm ) {
//		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', strOrgPostCd, 'strOrgPostName', endOrgPostCd, 'endOrgPostName' );
//	}
//
//}
//'## 2004/06/28 DEL END

// 団体検索ガイド表示
function showGuideOrg() {

//'## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応
//	setElement();
//	orgPostGuide_showGuideOrg();
	with ( document.entryForm ) {
		orgGuide_showGuideOrg( orgCd1, orgCd2, 'orgName' );
	}
//'## 2004/06/28 MOD END

}

// 団体以降のクリア
function clearOrgInfo() {

//'## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応
//	setElement();
//	orgPostGuide_clearOrgInfo();
	with ( document.entryForm ) {
		orgGuide_clearOrgInfo( orgCd1, orgCd2, 'orgName' );
	}
//'## 2004/06/28 MOD END

}

//'## 2004/06/28 DEL STR ORB)T.YAGUCHI 聖路加版対応
//// 事業部検索ガイド表示
//function showGuideOrgBsd() {
//
//	setElement();
//	orgPostGuide_showGuideOrgBsd();
//
//}
//
//// 事業部以降のクリア
//function clearOrgBsdInfo() {
//
//	setElement();
//	orgPostGuide_clearOrgBsdInfo();
//
//}
//
//// 室部検索ガイド表示
//function showGuideOrgRoom() {
//
//	setElement();
//	orgPostGuide_showGuideOrgRoom();
//
//}
//
//// 室部以降のクリア
//function clearOrgRoomInfo() {
//
//	setElement();
//	orgPostGuide_clearOrgRoomInfo();
//
//}
//
//// 所属検索ガイド表示
//function showGuideOrgPost( index ) {
//
//	setElement();
//	orgPostGuide_showGuideOrgPost( index );
//
//}
//
//// 所属のクリア
//function clearOrgPostInfo( index ) {
//
//	setElement();
//	orgPostGuide_clearOrgPostInfo( index );
//
//}
//'## 2004/06/28 DEL END

// 負担元団体検索ガイド表示
function showGuideBdnOrg() {

	with ( document.entryForm ) {
		orgGuide_showGuideOrg( bdnOrgCd1, bdnOrgCd2, 'bdnOrgName' );
	}

}

// 負担元団体のクリア
function clearBdnOrgInfo() {

	with ( document.entryForm ) {
		orgGuide_clearOrgInfo( bdnOrgCd1, bdnOrgCd2, 'bdnOrgName' );
	}

}

// submit時の処理
function submitForm() {

	document.entryForm.submit();

}

// ガイド画面を閉じる
function closeWindow() {

	calGuide_closeGuideCalendar();
	orgGuide_closeGuideOrg();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="0">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">個人受診金額一覧</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージ表示
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
<% '## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応 %>
<!--
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="strOrgPostCd" VALUE="<%= strStrOrgPostCd %>">
	<INPUT TYPE="hidden" NAME="endOrgPostCd" VALUE="<%= strEndOrgPostCd %>">
-->
<% '## 2004/06/28 MOD END %>

	<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2 %>">

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="getMode" VALUE="0" <%= IIf(lngGetMode = 0, "CHECKED", "") %>></TD>
			<TD NOWRAP>受診期間で抽出</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD><FONT COLOR="#ff0000">■</FONT></TD>
						<TD WIDTH="90" NOWRAP>受診日</TD>
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
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>□</TD>
						<TD WIDTH="90" NOWRAP>コース</TD>
						<TD>：</TD>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>□</TD>
						<TD WIDTH="90" NOWRAP>団体</TD>
						<TD>：</TD>
						<TD><A HREF="javascript:showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
						<TD><A HREF="javascript:clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD NOWRAP><SPAN ID="orgName"><% = strOrgName %></SPAN></TD>
					</TR>
				</TABLE>
<% '## 2004/06/28 DEL STR ORB)T.YAGUCHI 聖路加版対応 %>
<!--
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>□</TD>
						<TD WIDTH="90" NOWRAP>事業部</TD>
						<TD>：</TD>
						<TD><A HREF="javascript:showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="事業部検索ガイドを表示"></A></TD>
						<TD><A HREF="javascript:clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD NOWRAP><SPAN ID="orgBsdName"><% = strBsdName %></SPAN></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>□</TD>
						<TD WIDTH="90" NOWRAP>室部</TD>
						<TD>：</TD>
						<TD><A HREF="javascript:showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="室部検索ガイドを表示"></A></TD>
						<TD><A HREF="javascript:clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD NOWRAP><SPAN ID="orgRoomName"><% = strRoomName %></SPAN></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>□</TD>
						<TD WIDTH=90" NOWRAP>所属</TD>
						<TD>：</TD>
						<TD><A HREF="javascript:showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
						<TD><A HREF="javascript:clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD NOWRAP><SPAN ID="strOrgPostName"><% = strStrOrgPostName %></SPAN></TD>
						<TD>～</TD>
						<TD><A HREF="javascript:showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="所属検索ガイドを表示"></A></TD>
						<TD><A HREF="javascript:clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD NOWRAP><SPAN ID="endOrgPostName"><% = strEndOrgPostName %></SPAN></TD>
					</TR>
				</TABLE>
-->
<% '## 2004/06/28 DEL END %>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD><FONT COLOR="#ff0000">■</FONT></TD>
						<TD WIDTH="90" NOWRAP>対象データ</TD>
						<TD>：</TD>
						<TD><INPUT TYPE="checkbox" NAME="allowUnReceipt" VALUE="1" <%= IIf(strAllowUnReceipt <> "", "CHECKED", "") %>></TD>
<% '## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応 %>
<!--						<TD>未受付のデータは出力しない</TD>-->
						<TD>未来院のデータは出力しない</TD>
<% '## 2004/06/28 MOD END %>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="getMode" VALUE="1" <%= IIf(lngGetMode = 1, "CHECKED", "") %>></TD>
			<TD NOWRAP>締め日範囲で抽出</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD><FONT COLOR="#ff0000">■</FONT></TD>
						<TD WIDTH="90" NOWRAP>締め日</TD>
						<TD>：</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strCloseYear', 'strCloseMonth', 'strCloseDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("strCloseYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCloseYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("strCloseMonth", 1, 12, lngStrCloseMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("strCloseDay", 1, 31, lngStrCloseDay, False) %></TD>
						<TD>日</TD>
						<TD>～</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endCloseYear', 'endCloseMonth', 'endCloseDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("endCloseYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCloseYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("endCloseMonth", 1, 12, lngEndCloseMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("endCloseDay", 1, 31, lngEndCloseDay, False) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>□</TD>
						<TD WIDTH="90" NOWRAP>負担元団体</TD>
						<TD>：</TD>
						<TD><A HREF="javascript:showGuideBdnOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
						<TD><A HREF="javascript:clearBdnOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
						<TD NOWRAP><SPAN ID="bdnOrgName"><% = strBdnOrgName %></SPAN></TD>
					</TR>
				</TABLE>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD>□</TD>
						<TD WIDTH="90" NOWRAP>請求書番号</TD>
						<TD>：</TD>
<% '## 2004/06/28 MOD STR ORB)T.YAGUCHI 聖路加版対応 %>
<!--						<TD><INPUT TYPE="text" NAME="billNo" SIZE="12" MAXLENGTH="9" VALUE="<%= strBillNo %>"></TD>-->
						<TD><INPUT TYPE="text" NAME="billNo" SIZE="20" MAXLENGTH="14" VALUE="<%= strBillNo %>"></TD>
<% '## 2004/06/28 MOD END %>
						<TD><FONT COLOR="#999999">※請求書番号を指定した場合、締め日範囲、負担元は無視されます。</FONT></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/DataSelect.gif"></A>
    <%  end if  %>

	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>