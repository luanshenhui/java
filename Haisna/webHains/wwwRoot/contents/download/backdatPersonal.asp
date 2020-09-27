<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		個人情報の抽出 (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/download.inc" -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode				'処理モード(抽出実行:"edit")

'条件項目
Dim strCase				'抽出条件(指定期間の受診者:"csl"、郵便番号:"zip")
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
Dim strOrgSName			'団体略称
Dim strStrAge			'受診時(自)年齢
Dim strStrAgeY			'受診時(自)年齢(年)
Dim strStrAgeM			'受診時(自)年齢(月)
Dim strEndAge			'受診時(至)年齢
Dim strEndAgeY			'受診時(至)年齢(年)
Dim strEndAgeM			'受診時(至)年齢(月)
Dim lngGender			'性別
'郵便番号指定時の情報
Dim strZipCd1			'郵便番号１
Dim strZipCd2			'郵便番号２

'制御用
Dim objOrganization		'団体テーブルアクセス用COMオブジェクト
Dim objPerson			'個人情報アクセス用COMオブジェクト
Dim CsvobjPerson		'個人情報アクセス用COMオブジェクト

Dim strFileName			'出力CSVファイル名
Dim strDownloadFile		'ダウンロードファイルパス
Dim strArrMessage		'エラーメッセージ
Dim lngMessageStatus	'メッセージステータス(MessageType:NORMAL or WARNING)
Dim lngCount			'出力データ件数

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------

'CSVファイル格納パス設定
strDownloadFile = CSV_DATAPATH & CSV_PERSONAL		'ダウンロードファイル名セット
strFileName     = Server.MapPath(strDownloadFile)	'CSVファイル名セット

strMode         = Request("mode"   ) & ""			'処理モードの取得

'引数値の取得
If strMode = "" Then
	'初期表示
	strCase     = ""
	lngStrYear  = Year(Now())
	lngStrMonth = Month(Now())
	lngStrDay   = Day(Now())
	lngEndYear  = Year(Now())
	lngEndMonth = Month(Now())
	lngEndDay   = Day(Now())
	strCsCd     = ""
	strOrgCd1   = ""
	strOrgCd2   = ""
	strOrgSName = ""
	strStrAgeY  = "0"
	strStrAgeM  = ""
	strEndAgeY  = "150"
	strEndAgeM  = ""
	lngGender   = GENDER_BOTH
	strZipCd1   = ""
	strZipCd2   = ""
Else
	'再表示
	strCase     = Request("case"   ) & ""
	lngStrYear  = CLng("0" & Request("strYear" ))
	lngStrMonth = CLng("0" & Request("strMonth"))
	lngStrDay   = CLng("0" & Request("strDay"  ))
	lngEndYear  = CLng("0" & Request("endYear" ))
	lngEndMonth = CLng("0" & Request("endMonth"))
	lngEndDay   = CLng("0" & Request("endDay"  ))
	strCsCd     = Request("csCd"   ) & ""
	strOrgCd1   = Request("orgCd1" ) & ""
	strOrgCd2   = Request("orgCd2" ) & ""
	strStrAgeY  = Request("strAgeY") & ""
	strStrAgeM  = Request("strAgeM") & ""
	strEndAgeY  = Request("endAgeY") & ""
	strEndAgeM  = Request("endAgeM") & ""
	lngGender   = CLng("0" & Request("gender"  ))
	strZipCd1   = Request("zipCd1" ) & ""
	strZipCd2   = Request("zipCd2" ) & ""
End If

'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objPerson       = Server.CreateObject("HainsPerson.Person")
Set CsvobjPerson       = Server.CreateObject("HainsCsvPerson.CsvPerson")

'団体略称の再取得
If Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" Then
	Call objOrganization.SelectOrgSName(strOrgCd1, strOrgCd2, strOrgSName)
End If

'チェック・CSVファイル編集処理の制御
Do

	'「抽出処理を実行」押下時
	If strMode = "edit" Then

		'入力チェック
		strArrMessage = objPerson.CheckValueDatPerson(strCase, _
													  lngStrYear, lngStrMonth, lngStrDay, _
													  lngEndYear, lngEndMonth, lngEndDay, _
													  strStrAgeY, strStrAgeM, _
													  strEndAgeY, strEndAgeM, _
													  strZipCd1, _
													  strStrDate, strEndDate, _
													  strStrAge,  strEndAge _
													 )

		'チェックエラー時は処理を抜ける
		If Not IsEmpty(strArrMessage) Then
			lngMessageStatus = MESSAGETYPE_WARNING
			Exit Do
		End If

		'CSVファイルの編集
		lngCount = CsvobjPerson.EditCSVDatPerson(strFileName, _
											  strCase, strStrDate, strEndDate, _
											  strCsCd, strOrgCd1, strOrgCd2, _
											  strStrAge, strEndAge, lngGender, _
											  strZipCd1, strZipCd2 _
											 )

		'データがあればダウンロード、無ければメッセージをセット
		If lngCount > 0 Then
'			Response.Redirect strDownloadFile
			Response.ContentType = "application/x-download"
			Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
			Response.AddHeader "Content-Disposition","filename=" & CSV_PERSONAL
			Server.Execute strDownloadFile
			Response.End
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
<TITLE>個人情報の抽出</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/zipGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体ガイド呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');

}

// 団体コード・名称のクリア
function clearOrgCd() {

	orgGuide_clearOrgInfo(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');

}

// 郵便番号ガイド呼び出し
function callZipGuide() {

	var objForm = document.entryCondition;	// 自画面のフォームエレメント

	zipGuide_showGuideZip( '', objForm.zipCd1, objForm.zipCd2 );

}

// 郵便番号のクリア
function clearZipInfo() {

	var objForm = document.entryCondition;	// 自画面のフォームエレメント

	zipGuide_clearZipInfo( objForm.zipCd1, objForm.zipCd2 );

}

// 再表示
function redirectPage( actionmode ) {

	document.entryCondition.mode.value = actionmode;		/* 動作モード設定 */
	document.entryCondition.submit();						/* 自身へ送信 */

	return false;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg();zipGuide_closeGuideZip()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">■</SPAN><FONT COLOR="#000000">個人情報の抽出</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Call EditMessage(strArrMessage, lngMessageStatus)
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="case" VALUE="csl" <%= IIf(strCase = "csl", "CHECKED", "") %>></TD>
			<TD COLSPAN="3">指定期間の受診者で抽出</TD>
		</TR>
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
			<TD NOWRAP>団体</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return clearOrgCd()"  ><IMG SRC="../../images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"  ></A></TD>
						<TD WIDTH="5"></TD>
						<TD WIDTH="300">
							<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
							<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
							<SPAN ID="orgname"><%= strOrgSName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>受診時年齢</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><%= EditSelectNumberList("strAgeY", 0, 150, CLng(IIf(strStrAgeY = "", "-1", strStrAgeY))) %></TD>
						<TD>．</TD>
						<TD><%= EditSelectNumberList("strAgeM", 0,  11, CLng(IIf(strStrAgeM = "", "-1", strStrAgeM))) %></TD>
						<TD>歳以上</TD>
						<TD><%= EditSelectNumberList("endAgeY", 0, 150, CLng(IIf(strEndAgeY = "", "-1", strEndAgeY))) %></TD>
						<TD>．</TD>
						<TD><%= EditSelectNumberList("endAgeM", 0,  11, CLng(IIf(strEndAgeM = "", "-1", strEndAgeM))) %></TD>
						<TD>歳以下</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>性別</TD>
			<TD>：</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<%= EditGenderList("gender", CStr(lngGender), NON_SELECTED_DEL) %>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="case" VALUE="zip" <%= IIf(strCase = "zip", "CHECKED", "") %>></TD>
			<TD COLSPAN="3">郵便番号で抽出</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><A HREF="javascript:callZipGuide()">郵便番号</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="zipCd1" VALUE="<%= strZipCd1 %>" SIZE="3" MAXLENGTH="3">－<INPUT TYPE="text" NAME="zipCd2" VALUE="<%= strZipCd2 %>" SIZE="4" MAXLENGTH="4"></TD>
		</TR>
	</TABLE>

	<BR>

	<A HREF="javascript:function voi(){};voi()" ONCLICK="return redirectPage('edit')"><IMG SRC="/webHains/images/DataSelect.gif"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
