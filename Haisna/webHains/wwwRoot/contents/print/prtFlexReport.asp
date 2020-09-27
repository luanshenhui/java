<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		健康診断結果表 (Ver0.0.1)
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
Const COUNT_PERID = 2	'指定可能な個人ＩＤの数

Dim strMode				'印刷モード
Dim vntMessage			'通知メッセージ

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objOrganization	'団体情報アクセス用
Dim objOrgBsd		'事業部情報アクセス用
Dim objOrgRoom		'室部情報アクセス用
Dim objOrgPost		'所属情報アクセス用
Dim objPerson		'個人情報アクセス用
Dim objReport		'帳票情報アクセス用

'引数値
Dim lngStrCslYear		'開始受診年
Dim lngStrCslMonth		'開始受診月
Dim lngStrCslDay		'開始受診日
Dim lngEndCslYear		'終了受診年
Dim lngEndCslMonth		'終了受診月
Dim lngEndCslDay		'終了受診日
Dim strCsCd				'コースコード
Dim strSubCsCd			'サブコースコード
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgBsdCd			'事業部コード
Dim strOrgRoomCd		'室部コード
Dim strStrOrgPostCd		'開始所属コード
Dim strEndOrgPostCd		'終了所属コード
Dim strPerId			'個人ＩＤ
Dim strSortOrder		'出力順
Dim strInputKbn			'未入力チェック
Dim strReportOutput		'出力方法
Dim strHistoryPrint		'過去歴印刷
Dim strReportCd			'帳票コード

'所属情報
Dim strOrgName			'団体名称
Dim strOrgBsdName		'事業部名称
Dim strOrgRoomName		'室部名称
Dim strStrOrgPostName	'開始所属名称
Dim strEndOrgPostName	'終了所属名称

'個人情報
Dim strEmpNo		'従業員番号
Dim strLastName		'姓
Dim strFirstName	'名

'帳票情報
Dim strArrReportCd		'帳票コード
Dim strArrReportName	'帳票名
Dim strArrHistoryPrint	'過去歴印刷
Dim lngReportCount		'レコード数

Dim i					'インデックス

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
' 備考　　 : URLの引数値を取得する処理を記述して下さい
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

	'引数値の取得
	lngStrCslYear   = CLng("0" & Request("strCslYear"))
	lngStrCslMonth  = CLng("0" & Request("strCslMonth"))
	lngStrCslDay    = CLng("0" & Request("strCslDay"))
	lngEndCslYear   = CLng("0" & Request("endCslYear"))
	lngEndCslMonth  = CLng("0" & Request("endCslMonth"))
	lngEndCslDay    = CLng("0" & Request("endCslDay"))
	strCsCd         = Request("csCd")
	strSubCsCd      = Request("subCsCd")
	strOrgCd1       = Request("orgCd1")
	strOrgCd2       = Request("orgCd2")
	strOrgBsdCd     = Request("orgBsdCd")
	strOrgRoomCd    = Request("orgRoomCd")
	strStrOrgPostCd = Request("strOrgPostCd")
	strEndOrgPostCd = Request("endOrgPostCd")
	strPerId        = ConvIStringToArray(Request("perId"))
	strSortOrder    = Request("sortOrder")
	strInputKbn     = Request("inputKbn")
	strReportOutput = Request("reportOutput")
	strHistoryPrint = Request("historyPrint")
	strReportCd     = Request("reportcd")

	'受診開始・終了日のデフォルト値設定
	'(受診開始年が０になるケースは初期表示時以外にない)
	If lngStrCslYear = 0 Then
		lngStrCslYear  = Year(Date)
		lngStrCslMonth = Month(Date)
		lngStrCslDay   = Day(Date)
		lngEndCslYear  = lngStrCslYear
		lngEndCslMonth = lngStrCslMonth
		lngEndCslDay   = lngStrCslDay
	End If

	'個人ＩＤ未指定時は空枠を用意する
	If IsEmpty(strPerId) Then
		strPerId = Array()
		ReDim Preserve strPerId(COUNT_PERID - 1)
	End If

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

	Dim strStrCslDate	'開始受診日
	Dim strEndCslDate	'終了受診日
	Dim strMessage		'エラーメッセージの集合

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'開始受診日のチェック
	strStrCslDate = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay
	If Not IsDate(strStrCslDate) Then
		objCommon.appendArray strMessage, "開始受診日の入力形式が正しくありません。"
	End If

	'終了受診日のチェック
	strEndCslDate = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay
	If Not IsDate(strEndCslDate) Then
		objCommon.appendArray strMessage, "終了受診日の入力形式が正しくありません。"
	End If

	'出力様式のチェック
	If strReportCd = "" Then
		objCommon.appendArray strMessage, "出力様式を選択して下さい。"
	End If

	'戻り値の編集
	If IsArray(strMessage) Then
		CheckValue = strMessage
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

	Dim objFlexReport	'成績書出力用

	Dim dtmStrCslDate	'開始受診日
	Dim dtmEndCslDate	'終了受診日
	Dim Ret				'関数戻り値

	dtmStrCslDate = CDate(lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay)
	dtmEndCslDate = CDate(lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay)

	'オブジェクトのインスタンス作成
	Set objFlexReport = Server.CreateObject("HainsFlexReport.FlexReportControl")

	'成績書ドキュメントファイル作成処理
'	Ret = objFlexReport.PrintFlexReport(Session("USERID"), strReportCd, dtmStrCslDate, dtmEndCslDate, strCsCd, strSubCsCd, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strPerId, strInputKbn, strReportOutput, strHistoryPrint, , strSortOrder)
	Ret = objFlexReport.PrintFlexReport(Session("USERID"), strReportCd, dtmStrCslDate, dtmEndCslDate, strCsCd, strSubCsCd, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strPerId, strInputKbn, "0", strHistoryPrint, , strSortOrder)

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
<TITLE>健康診断結果表</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// エレメントの参照設定
function setElement() {

	with ( document.entryForm ) {

		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', strOrgPostCd, 'strOrgPostName', endOrgPostCd, 'endOrgPostName' );

		// 個人情報エレメントの参照設定
		for ( var i = 0; i < perId.length; i++ ) {
			orgPostGuide_getPerElement( perId[ i ], 'perName' + i, i );
		}

	}

}

// 個人検索ガイド画面表示
function showGuidePersonal( index ) {

	if ( index == 1 && document.entryForm.perId[ 0 ].value == '' ) {
		orgPostGuide_showGuidePersonal( 0 );
	} else {
		orgPostGuide_showGuidePersonal( index );
	}
}

// 個人のクリア
function clearPerInfo( index ) {

	if ( index == 0 ) {
		orgPostGuide_clearPerInfo();
	} else {
		orgPostGuide_clearPerInfo( index );
	}

}

// submit時の処理
function submitForm() {

	document.entryForm.submit();

}

function selectHistoryPrint( index ) {

	document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■</SPAN><FONT COLOR="#000000">健康診断結果表</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Call EditMessage(vntMessage, MESSAGETYPE_NORMAL)
%>
	<BR>
<%
	'モードはプレビュー固定
%>
	<INPUT TYPE="hidden" NAME="mode" VALUE="0">

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="strOrgPostCd" VALUE="<%= strStrOrgPostCd %>">
	<INPUT TYPE="hidden" NAME="endOrgPostCd" VALUE="<%= strEndOrgPostCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
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

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>コース</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>サブコース</TD>
			<TD>：</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "subCsCd", strSubCsCd, NON_SELECTED_ADD, False) %></TD>
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
		Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
		If objOrganization.SelectOrg(strOrgCd1, strOrgCd2, , strOrgName) = False Then
			Err.Raise 1000, , "団体情報が存在しません。"
		End If

		'事業部コード未指定時は何もしない
		If strOrgBsdCd = "" Then
			Exit Do
		End If

		'事業部名称の読み込み
		Set objOrgBsd = Server.CreateObject("HainsOrgBsd.OrgBsd")
		If objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName) = False Then
			Err.Raise 1000, , "事業部情報が存在しません。"
		End If

		'室部コード未指定時は何もしない
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'室部名称の読み込み
		Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
		If objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName) = False Then
			Err.Raise 1000, , "室部情報が存在しません。"
		End If

		Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

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
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
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

	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId(0) %>">
	<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId(1) %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>従業員指定</TD>
			<TD>：</TD>
<%
			Set objPerson = Server.CreateObject("HainsPerson.Person")

			'個人情報読み込み
			strLastName  = Empty
			strFirstName = Empty
			strEmpNo     = Empty
			If strPerId(0) <> "" Then
				objPerson.SelectPerson strPerId(0), strLastName, strFirstName, , , , , , , , , , , , , , , , , , , , , , , , ,strEmpNo
			End If
%>
			<TD><A HREF="javascript:showGuidePersonal(0)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearPerInfo(0)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="perName0"><%= IIf(strEmpNo <> "", strEmpNo & "：", "") & Trim(strLastName & "　" & strFirstName) %></SPAN></TD>
			<TD>～</TD>
<%
			'個人情報読み込み
			strLastName  = Empty
			strFirstName = Empty
			strEmpNo     = Empty
			If strPerId(1) <> "" Then
				objPerson.SelectPerson strPerId(1), strLastName, strFirstName, , , , , , , , , , , , , , , , , , , , , , , , ,strEmpNo
			End If
%>
			<TD><A HREF="javascript:showGuidePersonal(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearPerInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="perName1"><%= IIf(strEmpNo <> "", strEmpNo & "：", "") & Trim(strLastName & "　" & strFirstName) %></SPAN></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>出力順</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="radio" NAME="sortOrder" VALUE="1" <%= IIf(strSortOrder <> "0" And strSortOrder <> "2", "CHECKED", "") %>></TD>
			<TD NOWRAP>所属コード順</TD>
			<TD><INPUT TYPE="radio" NAME="sortOrder" VALUE="2" <%= IIf(strSortOrder  = "2", "CHECKED", "") %>></TD>
			<TD NOWRAP>受診日順</TD>
			<TD><INPUT TYPE="radio" NAME="sortOrder" VALUE="0" <%= IIf(strSortOrder  = "0", "CHECKED", "") %>></TD>
			<TD NOWRAP>従業員番号順</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>入力チェック</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="inputKbn" VALUE="0" <%= IIf(strInputKbn <> "1", "CHECKED", "") %>></TD>
						<TD>入力チェックは行わない</TD>
						<TD><INPUT TYPE="radio" NAME="inputKbn" VALUE="1" <%= IIf(strInputKbn  = "1", "CHECKED", "") %>></TD>
						<TD>すべての結果が入力されている受診情報のみ出力</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<!--
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>出力対象</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="reportOutput" VALUE="0" <%= IIf(strReportOutput <> "1" And strReportOutput <> "2", "CHECKED", "") %>></TD>
						<TD>指定なし</TD>
						<TD><INPUT TYPE="radio" NAME="reportOutput" VALUE="1" <%= IIf(strReportOutput  = "1", "CHECKED", "") %>></TD>
						<TD>報告済みデータのみ</TD>
						<TD><INPUT TYPE="radio" NAME="reportOutput" VALUE="2" <%= IIf(strReportOutput  = "2", "CHECKED", "") %>></TD>
						<TD>未報告データのみ</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
-->
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>過去歴の検索</TD>
			<TD>：</TD>
			<TD>
				<SELECT NAME="historyPrint">
					<OPTION VALUE="0" <%= IIf(strHistoryPrint = "" Or strHistoryPrint = "0", "SELECTED", "") %>>条件なし
					<OPTION VALUE="1" <%= IIf(strHistoryPrint = "1", "SELECTED", "") %>>２次検査・再検査を除く全てのコース
					<OPTION VALUE="2" <%= IIf(strHistoryPrint = "2", "SELECTED", "") %>>同一コースのみ
					<OPTION VALUE="3" <%= IIf(strHistoryPrint = "3", "SELECTED", "") %>>定期健診のみ
				</SELECT>
			</TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>出力様式</TD>
			<TD>：</TD>
			<TD>
				<SELECT NAME="reportCd" ONCHANGE="javascript:selectHistoryPrint(this.selectedIndex)">
					<OPTION VALUE="">&nbsp;
<%
					'帳票テーブル読み込み
					Set objReport = Server.CreateObject("HainsReport.Report")
					lngReportCount = objReport.SelectReportList(strArrReportCd, strArrReportName, "1", , , , strArrHistoryPrint)
					For i = 0 To lngReportCount - 1
%>
						<OPTION VALUE="<%= strArrReportCd(i) %>" <%= IIf(strArrReportCd(i) = strReportCd, "SELECTED", "") %>><%= strArrReportName(i) %>
<%
					Next
%>
				</SELECT>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/print.gif" WIDTH="76" HEIGHT="23" ALT="印刷する"></A>
	<%  End if  %>

	</BLOCKQUOTE>
</FORM>
<FORM NAME="historyPrintForm" action="#">
<%
	'過去歴検索方法をhiddenデータで保持
%>
	<INPUT TYPE="hidden" NAME="historyPrint" VALUE="">
<%
	For i = 0 To lngReportCount - 1
%>
		<INPUT TYPE="hidden" NAME="historyPrint" VALUE="<%= strArrHistoryPrint(i) %>">
<%
	Next
%>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>