<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   フォローアップはがき印刷 (Ver0.0.1)
'	   AUTHER  : T.Yaguchi@ORB
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objConsult			'受診情報アクセス用
Dim objOrg			'団体情報アクセス用
Dim objPerson			'個人情報アクセス用
Dim objPrtFollowCard		'フォローアップはがきアクセス用

Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strMessage			'エラーメッセージ

Dim strKey              	'検索キー
Dim strArrKey              	'検索キー(空白で分割後のキー）
Dim strStrCslDate     		'検索条件受診年月日（開始）
Dim strStrCslYear     		'検索条件受診年（開始）
Dim strStrCslMonth     		'検索条件受診月（開始）
Dim strStrCslDay     		'検索条件受診日（開始）
Dim strEndCslDate     		'検索条件受診年月日（終了）
Dim strEndCslYear     		'検索条件受診年（終了）
Dim strEndCslMonth     		'検索条件受診月（終了）
Dim strEndCslDay     		'検索条件受診日（終了）
Dim strStrSecDate     		'検索条件二次年月日（開始）
Dim strStrSecYear     		'検索条件二次年（開始）
Dim strStrSecMonth     		'検索条件二次月（開始）
Dim strStrSecDay     		'検索条件二次日（開始）
Dim strEndSecDate     		'検索条件二次年月日（終了）
Dim strEndSecYear     		'検索条件二次年（終了）
Dim strEndSecMonth     		'検索条件二次月（終了）
Dim strEndSecDay     		'検索条件二次日（終了）
Dim strSecKbn     		'検索条件二次日フラグ(1:未予約)
Dim strOrgCd1		   	'検索条件団体コード１
Dim strOrgCd2		   	'検索条件団体コード２
Dim strOrgName		   	'検索条件団体名

Dim strOrgGrpCd			'団体グループコード
Dim strCsCd			'コースコード
Dim strPerId
Dim strPerName

'Dim strPerId		   	'検索条件個人ＩＤ
'Dim strPerName		   	'検索条件個人名
Dim strLastName         	'検索条件姓
Dim strFirstName        	'検索条件名

Dim vntRsvNo			'予約番号
Dim vntCslDate			'受診日
Dim vntDayId			'当日ID
Dim vntCsname			'コース名
Dim vntWebColor			'コースカラー
Dim vntPerId			'個人ID
Dim vntPerKName			'カナ氏名
Dim vntPerName			'氏名
Dim vntGender			'性別
Dim vntBirth			'生年月日
Dim vntOrgSName			'団体略称
Dim vntPosCardPrintDate		'出力日時
Dim vntUserName			'更新者名

Dim lngAllCount			'件数
Dim lngRsvAllCount		'重複予約なし件数
Dim lngGetCount			'件数
Dim i				'カウンタ
Dim j

Dim lngStartPos			'表示開始位置
Dim lngPageMaxLine		'１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()		'１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName()	'１ページ表示ＭＡＸ行名の配列

Dim lngArrMailMode()		'はがき印刷状態の配列
Dim strArrMailModeName()	'はがき印刷状態名の配列

Dim lngMailMode			'はがき印刷状態の現在値

Dim Ret				'関数戻り値
Dim strURL			'ジャンプ先のURL

'画面表示制御用検査項目
Dim strBeforeRsvNo		'前行の予約番号

Dim strWebCslDate		'受診日
Dim strWebDayId			'当日ID
Dim strWebCsInfo		'コース名
Dim strWebPerId			'個人ID
Dim strWebPerName		'カナ氏名・氏名
Dim strWebGender		'性別
Dim strWebBirth			'生年月日
Dim strWebOrgName		'団体略称
Dim strWebPosCardPrintDate	'出力日時
Dim strWebRsvNo			'予約番号
Dim strWebUserName		'更新者名

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon        = Server.CreateObject("HainsCommon.Common")
Set objConsult       = Server.CreateObject("HainsConsult.Consult")
Set objOrg           = Server.CreateObject("HainsOrganization.Organization")
Set objPerson        = Server.CreateObject("HainsPerson.Person")
Set objPrtFollowCard = Server.CreateObject("HainsprtFollowCard.prtFollowCard")

'引数値の取得
strMode           = Request("mode")
strAction         = Request("action")
strStrCslYear     = Request("strCslYear")
strStrCslMonth    = Request("strCslMonth")
strStrCslDay      = Request("strCslDay")
strEndCslYear     = Request("endCslYear")
strEndCslMonth    = Request("endCslMonth")
strEndCslDay      = Request("endCslDay")
strStrSecYear     = Request("strSecYear")
strStrSecMonth    = Request("strSecMonth")
strStrSecDay      = Request("strSecDay")
strEndSecYear     = Request("endSecYear")
strEndSecMonth    = Request("endSecMonth")
strEndSecDay      = Request("endSecDay")
strSecKbn         = IIf(Request("secKbn") = "", 0, Request("secKbn"))
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
'strKey            = Request("textKey")
strPerId          = Request("perId")
lngStartPos       = Request("startPos")
lngPageMaxLine    = Request("pageMaxLine")
lngMailMode       = IIf(Request("mailMode")="", 1, Request("mailMode"))
strCsCd           = Request("csCd")
strOrgGrpCd       = Request("OrgGrpCd")

'デフォルトはシステム年月日を適用する
If strStrCslYear = "" And strStrCslMonth = "" And strStrCslDay = "" Then
	strStrCslYear  = CStr(Year(Now))
	strStrCslMonth = CStr(Month(Now))
	strStrCslDay   = CStr(Day(Now))
End If
If strEndCslYear = "" And strEndCslMonth = "" And strEndCslDay = "" Then
	strEndCslYear  = strStrCslYear
	strEndCslMonth = strStrCslMonth
	strEndCslDay   = strStrCslDay
End If
If strAction <> "search" Then
	If strStrSecYear = "" And strStrSecMonth = "" And strStrSecDay = "" Then
		strStrSecYear  = CStr(Year(Now))
		strStrSecMonth = CStr(Month(Now))
		strStrSecDay   = CStr(Day(Now))
	End If
	If strEndSecYear = "" And strEndSecMonth = "" And strEndSecDay = "" Then
		strEndSecYear  = strStrSecYear
		strEndSecMonth = strStrSecMonth
		strEndSecDay   = strStrSecDay
	End If
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Call CreatePageMaxLineInfo()

Do

	'検索ボタンクリック
	If strAction = "search" Then

		'受診日(自)の日付チェック
		If strStrCslYear <> 0 Or strStrCslMonth <> 0 Or strStrCslDay <> 0 Then
			If Not IsDate(strStrCslYear & "/" & strStrCslMonth & "/" & strStrCslDay) Then
				strMessage = "受診日の指定に誤りがあります。"
				Exit Do
			End If
		End If

		'受診日(至)の日付チェック
		If strEndCslYear <> 0 Or strEndCslMonth <> 0 Or strEndCslDay <> 0 Then
			If Not IsDate(strEndCslYear & "/" & strEndCslMonth & "/" & strEndCslDay) Then
				strMessage = "受診日の指定に誤りがあります。"
				Exit Do
			End If
		End If

		'受診日(自)の日付チェック
		If strStrSecYear <> "" Or strStrSecMonth <> "" Or strStrSecDay <> "" Then
			If Not IsDate(strStrSecYear & "/" & strStrSecMonth & "/" & strStrSecDay) Then
				strMessage = "受診日の指定に誤りがあります。"
				Exit Do
			End If
		End If

		'受診日(至)の日付チェック
		If strEndSecYear <> "" Or strEndSecMonth <> "" Or strEndSecDay <> "" Then
			If Not IsDate(strEndSecYear & "/" & strEndSecMonth & "/" & strEndSecDay) Then
				strMessage = "受診日の指定に誤りがあります。"
				Exit Do
			End If
		End If

		'検索開始終了受診日の編集
		strStrCslDate = CDate(strStrCslYear & "/" & strStrCslMonth & "/" & strStrCslDay)
		strEndCslDate = CDate(strEndCslYear & "/" & strEndCslMonth & "/" & strEndCslDay)

		''１年以内かチェック
		If strEndCslDate - strStrCslDate > 366 Then
			strMessage = "受診日は１年以内を指定して下さい。"
			Exit Do
		End If

		If strStrSecYear <> "" And strStrSecMonth <> "" And strStrSecDay <> "" Then
			strStrSecDate = CDate(strStrSecYear & "/" & strStrSecMonth & "/" & strStrSecDay)
		Else
			strStrSecDate = 0
		End If
		If strEndSecYear <> "" And strEndSecMonth <> "" And strEndSecDay <> "" Then
			strEndSecDate = CDate(strEndSecYear & "/" & strEndSecMonth & "/" & strEndSecDay)
		Else
			strEndSecDate = 0
		End If

		'全件を取得する
		lngRsvAllCount = objPrtFollowCard.GetData(strStrCslDate, strEndCslDate, _
				                       strStrSecDate, strEndSecDate, _
				                       strSecKbn, strCsCd, _
				                       strOrgCd1, strOrgCd2, _
				                       strPerId, lngMailMode, _
				                       lngPageMaxLine, lngStartPos, _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       True _
                				      )

		If lngRsvAllCount > 0 Then

			lngAllCount = objPrtFollowCard.GetData(strStrCslDate, strEndCslDate, _
				                       		  strStrSecDate, strEndSecDate, _
				                       		  strSecKbn, strCsCd, _
					                          strOrgCd1, strOrgCd2, _
					                          strPerId, lngMailMode, _
					                          lngPageMaxLine, lngStartPos, _
					                          vntRsvNo, vntCslDate, _
					                          vntDayId, vntCsname, _
					                          vntWebColor, vntPerId, _
					                          vntPerKName, vntPerName, _
					                          vntGender, vntBirth, _
					                          vntOrgSName, vntPosCardPrintDate, _
					                          , , _
					                          , , _
					                          False, , _
							          vntUserName _
	                					 )


		End If

		'団体コードあり？
		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			ObjOrg.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , strOrgName 
		Else
			strOrgName = ""
		End If 

		'個人IDの指定がある場合、名称取得
		If strPerId <> "" Then
			ObjPerson.SelectPerson_lukes strPerId, strLastName, strFirstName 
			strPerName = strLastName & "　" & strFirstName
		Else
			strPerName = ""
		End If 

	End If

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : １ページ表示ＭＡＸ行の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()


	Redim Preserve lngArrPageMaxLine(3)
	Redim Preserve strArrPageMaxLineName(3)

	Redim Preserve lngArrMailMode(2)
	Redim Preserve strArrMailModeName(2)

	lngArrPageMaxLine(0) = 20:strArrPageMaxLineName(0) = "20行ずつ"
	lngArrPageMaxLine(1) = 50:strArrPageMaxLineName(1) = "50行ずつ"
	lngArrPageMaxLine(2) = 100:strArrPageMaxLineName(2) = "100行ずつ"
	lngArrPageMaxLine(3) = 999:strArrPageMaxLineName(3) = "すべて"

	lngArrMailMode(0)     = 0
	strArrMailModeName(0) = "全て"

	lngArrMailMode(1)     = 1
	strArrMailModeName(1) = "未出力のみ"

	lngArrMailMode(2)     = 2
	strArrMailModeName(2) = "出力済みのみ"


End Sub
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>フォローアップはがき印刷</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 検索ボタンクリック
function searchClick() {

	with ( document.entryFollowMailInfo ) {
		startPos.value = 1;
		action.value = 'search';
		submit();
	}

	return false;

}

// チェックボックスの値を代入
function checkClick(selObj) {

	var myForm = document.entryFollowMailInfo;	// 自画面のフォームエレメント

	if (selObj.checked) {
		selObj.value = '1'
	} else {
		selObj.value = '0'
	}

}

// フォローアップはがき印刷画面呼び出し
function followCardPrint() {
	var url;							// URL文字列
	var mainForm = document.entryFollowMailInfo;			// メイン画面のフォームエレメント

	url = '/WebHains/contents/print/prtFollowCard.asp?';
	url = url + 'mode=' + '0';
	url = url + '&strCslYear=' + mainForm.strCslYear.value;
	url = url + '&strCslMonth=' + mainForm.strCslMonth.value;
	url = url + '&strCslDay=' + mainForm.strCslDay.value;
	url = url + '&endCslYear=' + mainForm.endCslYear.value;
	url = url + '&endCslMonth=' + mainForm.endCslMonth.value;
	url = url + '&endCslDay=' + mainForm.endCslDay.value;
	url = url + '&strSecYear=' + mainForm.strSecYear.value;
	url = url + '&strSecMonth=' + mainForm.strSecMonth.value;
	url = url + '&strSecDay=' + mainForm.strSecDay.value;
	url = url + '&endSecYear=' + mainForm.endSecYear.value;
	url = url + '&endSecMonth=' + mainForm.endSecMonth.value;
	url = url + '&endSecDay=' + mainForm.endSecDay.value;
	url = url + '&secKbn=' + mainForm.secKbn.value;
	url = url + '&csCd=' + mainForm.csCd.value;
	url = url + '&orgCd1=' + mainForm.orgCd1.value;
	url = url + '&orgCd2=' + mainForm.orgCd2.value;
	url = url + '&perId=' + mainForm.perId.value;
	url = url + '&mailMode=' + mainForm.mailMode.value;

	parent.location.href(url);

}
// アンロード時の処理
function closeGuideWindow() {

	// 団体検索ガイドを閉じる
	orgGuide_closeGuideOrg();

	// 個人検索ガイドを閉じる
	perGuide_closeGuidePersonal();

	//日付ガイドを閉じる
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryFollowMailInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="action" VALUE=""> 
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<% = lngStartPos %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">フォローアップはがき印刷</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
	<TR>
		<TD>一次健診受診日</TD>
		<TD>：</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<!--<TD><A HREF="javascript:calGuide_clearDate('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>-->
					<TD><%= EditSelectNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStrCslYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("strCslMonth", 1, 12, Clng("0" & strStrCslMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("strCslDay",   1, 31, Clng("0" & strStrCslDay  )) %></TD>
					<TD>&nbsp;日～&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<!--<TD><A HREF="javascript:calGuide_clearDate('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>-->
					<TD><%= EditSelectNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndCslYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("endCslMonth", 1, 12, Clng("0" & strEndCslMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("endCslDay",   1, 31, Clng("0" & strEndCslDay  )) %></TD>
					<TD>&nbsp;日</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>二次検診受診日</TD>
		<TD>：</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strSecYear', 'strSecMonth', 'strSecDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><A HREF="javascript:calGuide_clearDate('strSecYear', 'strSecMonth', 'strSecDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
					<TD><%= EditSelectNumberList("strSecYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStrSecYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("strSecMonth", 1, 12, Clng("0" & strStrSecMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("strSecDay",   1, 31, Clng("0" & strStrSecDay  )) %></TD>
					<TD>&nbsp;日～&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endSecYear', 'endSecMonth', 'endSecDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><A HREF="javascript:calGuide_clearDate('endSecYear', 'endSecMonth', 'endSecDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
					<TD><%= EditSelectNumberList("endSecYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndSecYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("endSecMonth", 1, 12, Clng("0" & strEndSecMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("endSecDay",   1, 31, Clng("0" & strEndSecDay  )) %></TD>
					<TD>&nbsp;日</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>未予約者</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="checkbox" NAME="secKbn" VALUE="<%=strSecKbn%>" <%= IIf(strSecKbn = "1", " CHECKED","") %> ONCLICK="javascript:checkClick(this)">二次検診予約していない未受診者も対象とする。</TD>
	</TR>
	<TR>
		<TD NOWRAP>コース</TD>
		<TD>：</TD>
		<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
	</TR>
	<TR>
		<TD>団体</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryFollowMailInfo.orgCd1, document.entryFollowMailInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="団体検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryFollowMailInfo.orgCd1, document.entryFollowMailInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
						<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
						<INPUT TYPE="hidden" NAME="txtorgName" VALUE="<%= strOrgName %>">
						<SPAN ID="orgName"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
<!--
		<TD NOWRAP COLSPAN="2">団体グループ：<%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
-->
	</TR>
	<TR>
		<TD>個人ID</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryFollowMailInfo.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="個人検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryFollowMailInfo.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
						<INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
						<SPAN ID="perName"><%= strPerName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD>はがき</TD>
		<TD>：</TD>
		<TD><%= EditDropDownListFromArray("mailMode", lngArrMailMode, strArrMailModeName, lngMailMode, NON_SELECTED_DEL) %>　</TD>
		<TD><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %>　</TD>
		<TD><A HREF="javascript:searchClick()"><IMG SRC="../../images/b_search.gif" ALT="この条件で検索" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
	</TR>
</TABLE>
<BR>
<!--ここは検索件数結果-->
<%
	Do
		'メッセージが発生している場合は編集して処理終了
		If strMessage <> "" Then
%>
			<BR>&nbsp;<%= strMessage %>
<%
			Exit Do
		End If

		If strAction <> "" Then
%>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>
				<SPAN STYLE="font-size:9pt;">
				「<FONT COLOR="#ff6600"><B><%= strStrCslYear %>年<%= strStrCslMonth %>月<%= strStrCslDay %>日～<%= strEndCslYear %>年<%= strEndCslMonth %>月<%= strEndCslDay %>日</B></FONT>」のはがき印刷情報一覧を表示しています。<BR>
						検索結果は<FONT COLOR="#ff6600"><B><%= lngRsvAllCount %></B></FONT>名（はがき対象者単位）です。 
				</SPAN>
			</TD>
<%
		If lngRsvAllCount > 0 Then
%>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="1"></TD>
			<!--<TD><A HREF="javascript:setReportSendDateClr()"><IMG SRC="../../images/save.gif" ALT="発送確認日時をクリア" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>-->
			<TD><A HREF="javascript:followCardPrint()"><IMG SRC="../../images/print.gif" ALT="印刷します" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
<%
		End If
%>
		</TR>

	<BR><BR>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
		<TR BGCOLOR="silver">
			<TD ALIGN="left" NOWRAP>受診日</TD>
			<TD ALIGN="left" NOWRAP>当日ＩＤ</TD>
			<TD ALIGN="left" NOWRAP>コース</TD>
			<TD ALIGN="left" NOWRAP>個人ＩＤ</TD>
			<TD ALIGN="left" NOWRAP>受診者名</TD>
			<TD ALIGN="left" NOWRAP>性別</TD>
			<TD ALIGN="left" NOWRAP>生年月日</TD>
			<TD ALIGN="left" NOWRAP>団体名</TD>
			<TD ALIGN="left" NOWRAP>はがき出力日</TD>
			<TD ALIGN="left" NOWRAP>予約番号</TD>
			<TD ALIGN="left" NOWRAP>出力者</TD>
		</TR>
	<%
		End If

		If lngAllCount > 0 Then
			strBeforeRsvNo = ""

			For i = 0 To UBound(vntCslDate)

				strWebCslDate		= ""
				strWebDayId		= ""
				strWebCsInfo		= ""
				strWebPerId		= ""
				strWebPerName		= ""
				strWebGender		= ""
				strWebBirth		= ""
				strWebOrgName		= ""
				strWebPosCardPrintDate	= vntPosCardPrintDate(i)
				strWebRsvNo		= ""
				strWebUserName		= vntUserName(i)

				If strBeforeRsvNo <> vntRsvNo(i) Then

					strWebCslDate		= vntCslDate(i)
					strWebDayId		= objCommon.FormatString(vntDayId(i), "0000")
					strWebCsInfo		= "<FONT COLOR=""#" & vntwebColor(i) & """>■</FONT>" & vntCsName(i) 
					strWebPerId		= vntPerId(i)
					strWebPerName		= "<SPAN STYLE=""font-size:9px;"">" & vntPerKName(i) & "</SPAN><BR>" & vntPerName(i)
					strWebGender		= vntGender(i)
					strWebBirth		= vntBirth(i)
					strWebOrgName		= vntOrgSName(i)
					strWebRsvNo		= vntRsvNo(i)

				End If
%>
				<TR HEIGHT="18" BGCOLOR="#eeeeee">
					<TD NOWRAP><%= strWebCslDate          %></TD>
					<TD NOWRAP><%= strWebDayId            %></TD>
					<TD NOWRAP><%= strWebCsInfo           %></TD>
					<TD NOWRAP><%= strWebPerId            %></TD>
					<TD NOWRAP><%= strWebPerName          %></TD>
					<TD NOWRAP><%= strWebGender           %></TD>
					<TD NOWRAP><%= strWebBirth            %></TD>
					<TD NOWRAP><%= strWebOrgName          %></TD>
					<TD NOWRAP><%= strWebPosCardPrintDate %></TD>
					<TD NOWRAP><%= strWebRsvNo            %></TD>
					<TD NOWRAP><%= strWebUserName         %></TD>
				</TR>
<%
				strBeforeRsvNo = vntRsvno(i)
			Next
		End If
%>
	</TABLE>
<%
		If lngAllCount > 0 Then
			'全件検索時はページングナビゲータ不要
		     	If lngPageMaxLine <= 0 Then
			Else
				'URLの編集
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?mode="        & strMode
				strURL = strURL & "&action="      & "search"
				strURL = strURL & "&strCslYear="  & strStrCslYear
				strURL = strURL & "&strCslMonth=" & strStrCslMonth
				strURL = strURL & "&strCslDay="   & strStrCslDay
				strURL = strURL & "&endCslYear="  & strEndCslYear
				strURL = strURL & "&endCslMonth=" & strEndCslMonth
				strURL = strURL & "&endCslDay="   & strEndCslDay
				strURL = strURL & "&strSecYear="  & strStrSecYear
				strURL = strURL & "&strSecMonth=" & strStrSecMonth
				strURL = strURL & "&strSecDay="   & strStrSecDay
				strURL = strURL & "&endSecYear="  & strEndSecYear
				strURL = strURL & "&endSecMonth=" & strEndSecMonth
				strURL = strURL & "&endSecDay="   & strEndSecDay
				strURL = strURL & "&secKbn="      & strSecKbn
				strURL = strURL & "&orgCd1="      & strOrgCd1
				strURL = strURL & "&orgCd2="      & strOrgCd2
				strURL = strURL & "&perId="       & strPerId
				strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
				strURL = strURL & "&mailMode="    & lngMailMode
				strURL = strURL & "&csCd="        & strCsCd
				'ページングナビゲータの編集
%>
				<%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
			End If
%>
			<BR>
<%
		End If
		Exit Do
	Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>