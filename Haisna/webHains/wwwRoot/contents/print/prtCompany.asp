<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		カンパニープロファイル (Ver0.0.1)
'		AUTHER  : 
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode				'印刷モード
Dim vntMessage			'通知メッセージ

'-------------------------------------------------------------------------------
' 固有宣言部（各帳票に応じてこのセクションに変数を定義して下さい）
'-------------------------------------------------------------------------------
'COMオブジェクト
Dim objCommon								'共通クラス
Dim objOrganization							'団体情報アクセス用
Dim objOrgBsd								'事業部情報アクセス用
Dim objOrgRoom								'室部情報アクセス用
Dim objOrgPost								'所属情報アクセス用
Dim objPerson								'個人情報アクセス用
Dim objReport								'帳票情報アクセス用

'パラメータ値
Dim strSCslYear, strSCslMonth, strSCslDay	'開始年月日
Dim strECslYear, strECslMonth, strECslDay	'終了年月日
Dim strOrgCd01								'印字基準団体０１
Dim strOrgCd02								'印字基準団体０２
Dim strOrgGrpCd								'団体グループコード
Dim strOrgCd11								'団体コード１１
Dim strOrgCd12								'団体コード１２
Dim strOrgCd21								'団体コード２１
Dim strOrgCd22								'団体コード２２
Dim strOrgCd31								'団体コード３１
Dim strOrgCd32								'団体コード３２
Dim strOrgCd41								'団体コード４１
Dim strOrgCd42								'団体コード４２
Dim strOrgCd51								'団体コード５１
Dim strOrgCd52								'団体コード５２
Dim strOrgCd61								'団体コード６１
Dim strOrgCd62								'団体コード６２
Dim strOrgCd71								'団体コード７１
Dim strOrgCd72								'団体コード７２
Dim strOrgCd81								'団体コード８１
Dim strOrgCd82								'団体コード８２
Dim strOrgCd91								'団体コード９１
Dim strOrgCd92								'団体コード９２
Dim strOrgCd101								'団体コード１０１
Dim strOrgCd102								'団体コード１０２
Dim strOrgCd111								'団体コード１１１
Dim strOrgCd112								'団体コード１１２


'作業用変数
Dim strSCslDate								'開始日
Dim strECslDate								'終了日
Dim strOrgName0								'印字基準団体
Dim strOrgGrpName							'団体グループ名称
Dim strOrgName1								'団体１名称
Dim strOrgName2								'団体２名称
Dim strOrgName3								'団体３名称
Dim strOrgName4								'団体４名称
Dim strOrgName5								'団体５名称
Dim strOrgName6								'団体６名称
Dim strOrgName7								'団体７名称
Dim strOrgName8								'団体８名称
Dim strOrgName9								'団体９名称
Dim strOrgName10							'団体１０名称
Dim strOrgName11							'団体１１名称

'帳票情報
Dim strArrReportCd							'帳票コード
Dim strArrReportName						'帳票名
Dim strArrHistoryPrint						'過去歴印刷
Dim lngReportCount							'レコード数

Dim i					'ループインデックス
Dim j					'ループインデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

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

'◆ 開始年月日
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'開始年
		strSCslMonth  = Month(Now())			'開始月
		strSCslDay    = Day(Now())				'開始日
	Else
		strSCslYear   = Request("strCslYear")	'開始年
		strSCslMonth  = Request("strCslMonth")	'開始月
		strSCslDay    = Request("strCslDay")	'開始日
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'◆ 終了年月日
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = Year(Now())				'終了年
		strECslMonth  = Month(Now())			'開始月
		strECslDay    = Day(Now())				'開始日
	Else
		strECslYear   = Request("endCslYear")	'終了年
		strECslMonth  = Request("endCslMonth")	'開始月
		strECslDay    = Request("endCslDay")	'開始日
	End If
	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'◆ 開始年月日と終了年月日の大小判定と入替
'   （日付型に変換してチェックしないのは日付として誤った値であったときのエラー回避の為）
	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
	   Right("00" & Trim(CStr(strSCslDay)), 2) _
	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
	   Right("00" & Trim(CStr(strECslDay)), 2) Then
		strSCslYear   = strECslYear
		strSCslMonth  = strECslMonth
		strSCslDay    = strECslDay
		strSCslDate   = strECslDate
		strECslYear   = Request("strCslYear")	'開始年
		strECslMonth  = Request("strCslMonth")	'開始月
		strECslDay    = Request("strCslDay")	'開始日
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	End If

'◆ 印字基準団体
	strOrgCd01	= Request("OrgCd01")
	strOrgCd02	= Request("OrgCd02")
	strOrgName0 = Request("OrgName0")

'◆ 団体グループコード
	strOrgGrpCd = Request("OrgGrpCd")
	strOrgGrpName = Request("OrgGrpName")

'◆ 団体コード
	'団体１
	strOrgCd11	= Request("OrgCd11")
	strOrgCd12	= Request("OrgCd12")
	strOrgName1 = Request("OrgName1")

	'団体２
	strOrgCd21	= Request("OrgCd21")
	strOrgCd22	= Request("OrgCd22")
	strOrgName2 = Request("OrgName2")
	'団体３
	strOrgCd31	= Request("OrgCd31")
	strOrgCd32	= Request("OrgCd32")
	strOrgName3 = Request("OrgName3")
	'団体４
	strOrgCd41	= Request("OrgCd41")
	strOrgCd42	= Request("OrgCd42")
	strOrgName4 = Request("OrgName4")
	'団体５
	strOrgCd51	= Request("OrgCd51")
	strOrgCd52	= Request("OrgCd52")
	strOrgName5 = Request("OrgName5")
	'団体６
	strOrgCd61	= Request("OrgCd61")
	strOrgCd62	= Request("OrgCd62")
	strOrgName6 = Request("OrgName6")
	'団体７
	strOrgCd71	= Request("OrgCd71")
	strOrgCd72	= Request("OrgCd72")
	strOrgName7 = Request("OrgName7")
	'団体８
	strOrgCd81	= Request("OrgCd81")
	strOrgCd82	= Request("OrgCd82")
	strOrgName8 = Request("OrgName8")
	'団体９
	strOrgCd91	= Request("OrgCd91")
	strOrgCd92	= Request("OrgCd92")
	strOrgName9 = Request("OrgName9")
	'団体１０
	strOrgCd101	= Request("OrgCd101")
	strOrgCd102	= Request("OrgCd102")
	strOrgName10 = Request("OrgName10")
	'団体１１
	strOrgCd111	= Request("OrgCd111")
	strOrgCd112	= Request("OrgCd112")
	strOrgName11 = Request("OrgName11")


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

	Dim vntArrMessage	'エラーメッセージの集合
	Dim blnErrFlg
	Dim aryChkString
	Dim aryChkString2
	
	'ここにチェック処理を記述
	With objCommon
'例)		.AppendArray vntArrMessage, コメント
		If strMode <> "" Then
			'受診日チェック
			If Not IsDate(strSCslDate) Then
				.AppendArray vntArrMessage, "開始日付が正しくありません。"
			End If
			If Not IsDate(strECslDate) Then
				.AppendArray vntArrMessage, "終了日付が正しくありません。"
			End If

			If strOrgCd01 = vbNullString And strOrgCd02 = vbNullString Then
				.AppendArray vntArrMessage, "印字基準団体を選択してください。"			
			End If
			
			If strOrgGrpCd = vbNullString And _
				strOrgCd11 = vbNullString And strOrgCd12 = vbNullString And _
				strOrgCd21 = vbNullString And strOrgCd22 = vbNullString And _
				strOrgCd31 = vbNullString And strOrgCd32 = vbNullString And _
				strOrgCd41 = vbNullString And strOrgCd42 = vbNullString And _
				strOrgCd51 = vbNullString And strOrgCd52 = vbNullString And _
				strOrgCd61 = vbNullString And strOrgCd62 = vbNullString And _
				strOrgCd71 = vbNullString And strOrgCd72 = vbNullString And _
				strOrgCd81 = vbNullString And strOrgCd82 = vbNullString And _
				strOrgCd91 = vbNullString And strOrgCd92 = vbNullString And _
				strOrgCd101 = vbNullString And strOrgCd102 = vbNullString And _
				strOrgCd111 = vbNullString And strOrgCd112 = vbNullString Then
				
				.AppendArray vntArrMessage, "団体グループか団体コードを選択してください。"			
			End If

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

	Dim Ret				'関数戻り値
	Dim dtmStrCslDate	'開始受診日
	Dim dtmEndCslDate	'終了受診日
	Dim objFlexReport	'成績書出力用

	If Not IsArray(CheckValue()) Then
		dtmStrCslDate = CDate(strSCslDate)
		dtmEndCslDate = CDate(strECslDate)

		Set objFlexReport = Server.CreateObject("HainsCompany.Company")
		
		'成績書ドキュメントファイル作成処理
		Ret = objFlexReport.PrintCompany(Session("USERID"), _
						, _
						dtmStrCslDate, _
						dtmEndCslDate, _ 
						strOrgCd01, _
						strOrgCd02, _
						strOrgGrpCd, _
						strOrgCd11, _
						strOrgCd12, _
						strOrgCd21, _
						strOrgCd22, _
						strOrgCd31, _
						strOrgCd32, _
						strOrgCd41, _
						strOrgCd42, _
						strOrgCd51, _
						strOrgCd52, _
						strOrgCd61, _
						strOrgCd62, _
						strOrgCd71, _
						strOrgCd72, _
						strOrgCd81, _
						strOrgCd82, _
						strOrgCd91, _
						strOrgCd92, _
						strOrgCd101, _
						strOrgCd102, _
						strOrgCd111, _
						strOrgCd112  _
						)

		Print = Ret
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>カンパニープロファイル</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体画面表示
function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {

	// 団体情報エレメントの参照設定
	orgPostGuide_getElement( Cd1, Cd2, CtrlName );
	// 画面表示
	orgPostGuide_showGuideOrg();

}

// 団体情報削除
function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {

	// 団体情報エレメントの参照設定
	orgPostGuide_getElement( Cd1, Cd2, CtrlName );

	// 削除
	orgPostGuide_clearOrgInfo();

}

// submit時の処理
function submitForm() {

	document.entryForm.submit();

}

//function selectHistoryPrint( index ) {

//	document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;

//}

// ブラウザ戻るボタンからの名称表示消える対策のため、ここではhiddenクリアとする
function checkRunStateForprtCompany() {
	if (document.entryForm.runstate.value == 'run') {
		document.entryForm.historyPrint.value
		document.entryForm.orgCd01.value=''
		document.entryForm.orgCd02.value = '';
		document.entryForm.OrgGrpName.value = '';
		document.entryForm.orgCd11.value = '';
		document.entryForm.orgCd12.value = '';
		document.entryForm.orgCd21.value = '';
		document.entryForm.orgCd22.value = '';
		document.entryForm.orgCd31.value = '';
		document.entryForm.orgCd32.value = '';
		document.entryForm.orgCd41.value = '';
		document.entryForm.orgCd42.value = '';
		document.entryForm.orgCd51.value = '';
		document.entryForm.orgCd52.value = '';
		document.entryForm.orgCd61.value = '';
		document.entryForm.orgCd62.value = '';
		document.entryForm.orgCd71.value = '';
		document.entryForm.orgCd72.value = '';
		document.entryForm.orgCd81.value = '';
		document.entryForm.orgCd82.value = '';
		document.entryForm.orgCd91.value = '';
		document.entryForm.orgCd92.value = '';
		document.entryForm.orgCd101.value = '';
		document.entryForm.orgCd102.value = '';
		document.entryForm.orgCd111.value = '';
		document.entryForm.orgCd112.value = '';
	}
}

//-->
</SCRIPT>
<script TYPE="text/javascript" src="/webHains/js/checkRunState.js?v=1.2"></script>
<STYLE TYPE="text/css">
<!--
td.prttab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:checkRunStateForprtCompany();">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" method="post" onsubmit="setRunState();">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">■カンパニープロファイル</SPAN></B></TD>
	</TR>
</TABLE>
<%
	'エラーメッセージ表示
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'モードはプレビュー固定
%>
	<INPUT TYPE="hidden" NAME="mode" VALUE="0">

	<INPUT TYPE="hidden" NAME="orgCd01"       VALUE="<%= strOrgCd01       %>">
	<INPUT TYPE="hidden" NAME="orgCd02"       VALUE="<%= strOrgCd02       %>">
	<INPUT TYPE="hidden" NAME="OrgGrpName"      VALUE="<%= strOrgGrpName      %>">
	<INPUT TYPE="hidden" NAME="orgCd11"       VALUE="<%= strOrgCd11       %>">
	<INPUT TYPE="hidden" NAME="orgCd12"       VALUE="<%= strOrgCd12       %>">
	<INPUT TYPE="hidden" NAME="orgCd21"       VALUE="<%= strOrgCd21       %>">
	<INPUT TYPE="hidden" NAME="orgCd22"       VALUE="<%= strOrgCd22       %>">
	<INPUT TYPE="hidden" NAME="orgCd31"       VALUE="<%= strOrgCd31       %>">
	<INPUT TYPE="hidden" NAME="orgCd32"       VALUE="<%= strOrgCd32       %>">
	<INPUT TYPE="hidden" NAME="orgCd41"       VALUE="<%= strOrgCd41       %>">
	<INPUT TYPE="hidden" NAME="orgCd42"       VALUE="<%= strOrgCd42       %>">
	<INPUT TYPE="hidden" NAME="orgCd51"       VALUE="<%= strOrgCd51       %>">
	<INPUT TYPE="hidden" NAME="orgCd52"       VALUE="<%= strOrgCd52       %>">
	<INPUT TYPE="hidden" NAME="orgCd61"       VALUE="<%= strOrgCd61       %>">
	<INPUT TYPE="hidden" NAME="orgCd62"       VALUE="<%= strOrgCd62       %>">
	<INPUT TYPE="hidden" NAME="orgCd71"       VALUE="<%= strOrgCd71       %>">
	<INPUT TYPE="hidden" NAME="orgCd72"       VALUE="<%= strOrgCd72       %>">
	<INPUT TYPE="hidden" NAME="orgCd81"       VALUE="<%= strOrgCd81       %>">
	<INPUT TYPE="hidden" NAME="orgCd82"       VALUE="<%= strOrgCd82       %>">
	<INPUT TYPE="hidden" NAME="orgCd91"       VALUE="<%= strOrgCd91       %>">
	<INPUT TYPE="hidden" NAME="orgCd92"       VALUE="<%= strOrgCd92       %>">
	<INPUT TYPE="hidden" NAME="orgCd101"       VALUE="<%= strOrgCd101       %>">
	<INPUT TYPE="hidden" NAME="orgCd102"       VALUE="<%= strOrgCd102       %>">
	<INPUT TYPE="hidden" NAME="orgCd111"       VALUE="<%= strOrgCd111       %>">
	<INPUT TYPE="hidden" NAME="orgCd112"       VALUE="<%= strOrgCd112       %>">

	<!--- 日付 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="90" NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>日</TD>
			<TD>～</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
			<TD>年</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
			<TD>月</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
			<TD>日</TD>
		</TR>
	</TABLE>

	<!--印字基準団体-->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">■</FONT></TD>
			<TD WIDTH="120" NOWRAP>印字基準団体</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd01, document.entryForm.orgCd02, 'OrgName0')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd01, document.entryForm.orgCd02, 'OrgName0')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName0"><% = strOrgName0 %></SPAN></TD>
		</TR>
	</TABLE>


	<!-- 団体グループ-->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体グループ</TD>
			<TD>：</TD>
			<TD><%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体１</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'OrgName1')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName1"><% = strOrgName1 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体２</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd21, document.entryForm.orgCd22, 'OrgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName2"><% = strOrgName2 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体３</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd31, document.entryForm.orgCd32, 'OrgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName3"><% = strOrgName3 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体４</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd41, document.entryForm.orgCd42, 'OrgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName4"><% = strOrgName4 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体５</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd51, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd51, document.entryForm.orgCd52, 'OrgName5')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName5"><% = strOrgName5 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体６</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd61, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd61, document.entryForm.orgCd62, 'OrgName6')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName6"><% = strOrgName6 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体７</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd71, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd71, document.entryForm.orgCd72, 'OrgName7')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName7"><% = strOrgName7 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体８</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd81, document.entryForm.orgCd82, 'OrgName8')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd81, document.entryForm.orgCd82, 'OrgName8')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName8"><% = strOrgName8 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体９</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd91, document.entryForm.orgCd92, 'OrgName9')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd91, document.entryForm.orgCd92, 'OrgName9')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName9"><% = strOrgName9 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体１０</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd101, document.entryForm.orgCd102, 'OrgName10')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd101, document.entryForm.orgCd102, 'OrgName10')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName10"><% = strOrgName10 %></SPAN></TD>
		</TR>
		<TR>
			<TD>□</TD>
			<TD WIDTH="90" NOWRAP>団体１１</TD>
			<TD>：</TD>
			<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd111, document.entryForm.orgCd112, 'OrgName11')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
			<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd111, document.entryForm.orgCd112, 'OrgName11')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
			<TD NOWRAP><SPAN ID="OrgName11"><% = strOrgName11 %></SPAN></TD>
		</TR>
	</TABLE>

	<!---2006.07.04 権限管理 追加 by 李  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/print.gif" WIDTH="76" HEIGHT="23" ALT="印刷する"></A>
	<%  End if  %>

	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>