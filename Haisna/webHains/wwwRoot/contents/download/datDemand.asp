<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求情報の抽出 (Ver0.0.1)
'		AUTHER  : ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/download.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode				'処理モード(抽出実行:"edit")

'制御用
Dim objDemand			'団体テーブルアクセス用COMオブジェクト
Dim strFileName			'出力CSVファイル名
Dim strDownloadFile		'ダウンロードファイル名
Dim strArrMessage		'エラーメッセージ(全体)
Dim lngMessageStatus	'メッセージステータス(MessageType:NORMAL or WARNING)
Dim lngCount			'出力データ件数

'期間指定時の情報
Dim strStrDate			'受診年月日(自)
Dim lngStrYear			'受診年(自)
Dim lngStrMonth			'受診月(自)
Dim lngStrDay			'受診日(自)
Dim strEndDate			'受診年月日(至)
Dim lngEndYear			'受診年(至)
Dim lngEndMonth			'受診月(至)
Dim lngEndDay			'受診日(至)
Dim strCsCd				'コースコード
Dim strOrgCd1			'団体コード１
Dim strOrgCd2			'団体コード２
Dim strOrgName			'団体名称
Dim strSelectMode		'データ抽出モード

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------

'CSVファイル格納パス設定
strDownloadFile   = CSV_DATAPATH & CSV_DEMAND			'ダウンロードファイル名セット
strFileName       = Server.MapPath(strDownloadFile)		'CSVファイル名セット

strMode           = Request("mode") & ""				'処理モードの取得

'引数値の取得
If strMode = "" Then
	'初期表示
	lngStrYear  = Year(Now())
	lngStrMonth = Month(Now())
	lngStrDay   = Day(Now())
	lngEndYear  = Year(Now())
	lngEndMonth = Month(Now())
	lngEndDay   = Day(Now())
	strCsCd     = ""
	strOrgCd1   = ""
	strOrgCd2   = ""
	strOrgName = ""
	strSelectMode = ""
Else
	'再表示
	lngStrYear  = CLng("0" & Request("strYear" ))
	lngStrMonth = CLng("0" & Request("strMonth"))
	lngStrDay   = CLng("0" & Request("strDay"  ))
	lngEndYear  = CLng("0" & Request("endYear" ))
	lngEndMonth = CLng("0" & Request("endMonth"))
	lngEndDay   = CLng("0" & Request("endDay"  ))
	strCsCd     = Request("csCd"   ) & ""
	strOrgCd1   = Request("orgCd1" ) & ""
	strOrgCd2   = Request("orgCd2" ) & ""
	strSelectMode = Request("SelectMode" ) & ""
End If

'オブジェクトのインスタンス作成
Set objDemand = Server.CreateObject("HainsDemand.Demand")

'CSVファイル編集処理の制御
Do

	'「抽出処理を実行」押下時
	If strMode = "edit" Then

		strStrDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
		strEndDate = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay

		If IsDate(strStrDate) = False Then
			ReDim strArrMessage(0)
			strArrMessage(0) = "正しい開始日付を指定してください。"
			lngMessageStatus = MESSAGETYPE_WARNING
			Exit Do
		End If

		If IsDate(strEndDate) = False Then
			strEndDate = strStrDate
		End If

		'CSVファイルの編集
		lngCount = objDemand.SelectDmdCSVList(strFileName, strStrDate, strEndDate , strCsCd, strOrgCd1, strOrgCd2, strSelectMode)

		'データがあればダウンロード、無ければメッセージをセット
		If lngCount > 0 Then
			Response.Redirect strDownloadFile
		Else
			ReDim strArrMessage(0)
			strArrMessage(0) = "指定のデータはありませんでした。"
			lngMessageStatus = MESSAGETYPE_NORMAL
		End If

	End If

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
<TITLE>請求情報の抽出</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 再表示
function redirectPage( actionmode ) {

	document.entryCondition.mode.value = actionmode;		/* 動作モード設定 */
	document.entryCondition.submit();						/* 自身へ送信 */

	return false;

}
<!--
// 団体検索ガイド呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg(document.entryCondition.orgcd1, document.entryCondition.orgcd2, 'orgname');

}

// 団体名削除
function callOrgChange() {

	orgGuide_clearOrgInfo(document.entryCondition.orgcd1, document.entryCondition.orgcd2, 'orgname');

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">■</SPAN><FONT COLOR="#000000">請求情報の抽出</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Call EditMessage(strArrMessage, lngMessageStatus)
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD></TD>
			<TD NOWRAP>受診日</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<%= EditSelectYearList(YEARS_SYSTEM, "strYear", lngStrYear) %>年
							<%= EditSelectNumberList("strMonth", 1, 12, lngStrMonth) %>月
							<%= EditSelectNumberList("strDay"  , 1, 31, lngStrDay  ) %>日～
							<%= EditSelectYearList(YEARS_SYSTEM, "endYear", lngEndYear) %>年
							<%= EditSelectNumberList("endMonth", 1, 12, lngEndMonth) %>月
							<%= EditSelectNumberList("endDay"  , 1, 31, lngEndDay  ) %>日
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>コース</TD>
			<TD>：</TD>
			<TD>
				<%= EditCourseList("csCd", strCsCd, SELECTED_ALL) %>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>受診団体コード</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
						<TD>
							<INPUT TYPE="text" ONCHANGE="callOrgChange()" NAME="orgcd1" SIZE="5" MAXLENGTH="5" VALUE="<%=strOrgCd1%>">-
							<INPUT TYPE="text" ONCHANGE="callOrgChange()" NAME="orgcd2" SIZE="5" MAXLENGTH="5" VALUE="<%=strOrgCd2%>">
						</TD>
						<TD WIDTH="5"></TD>
						<TD WIDTH="250"><SPAN ID="orgname"><%=strOrgName%></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD>出力対象</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="SelectMode" VALUE="0" <%= IIf(strSelectMode <> "1" And strSelectMode <> "2", "CHECKED", "") %>></TD>
						<TD>指定なし</TD>
						<TD><INPUT TYPE="radio" NAME="SelectMode" VALUE="1" <%= IIf(strSelectMode  = "1", "CHECKED", "") %>></TD>
						<TD>基本コースのみ</TD>
						<TD><INPUT TYPE="radio" NAME="SelectMode" VALUE="2" <%= IIf(strSelectMode  = "2", "CHECKED", "") %>></TD>
						<TD>オプション検査のみ</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>
	<A HREF="javascript:function voi(){};voi()" ONCLICK="return redirectPage('edit')"><IMG SRC="/webHains/images/DataSelect.gif"></A></B></TD>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
