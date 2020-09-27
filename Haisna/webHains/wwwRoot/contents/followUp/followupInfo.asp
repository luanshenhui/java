<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   フォローアップ照会 (Ver0.0.1)
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
Dim objFollowUp			'フォローアップアクセス用

Dim strMode			'処理モード(挿入:"insert"、更新:"update")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strMessage			'エラーメッセージ

Dim strKey              	'検索キー
Dim strArrKey              	'検索キー(空白で分割後のキー）
Dim strStartCslDate     	'検索条件受診年月日（開始）
Dim strStartYear     		'検索条件受診年（開始）
Dim strStartMonth     		'検索条件受診月（開始）
Dim strStartDay     		'検索条件受診日（開始）
Dim strEndCslDate     		'検索条件受診年月日（終了）
Dim strEndYear     		'検索条件受診年（終了）
Dim strEndMonth     		'検索条件受診月（終了）
Dim strEndDay     		'検索条件受診日（終了）
Dim strOrgCd1		   	'検索条件団体コード１
Dim strOrgCd2		   	'検索条件団体コード２
Dim strOrgName		   	'検索条件団体名

Dim strCsCd					'コースコード
Dim strPerId
Dim strPerName

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
Dim vntJudClassName		'判定分類名
Dim vntQuestionName		'アンケート名

Dim strLastName         	'検索条件姓
Dim strFirstName        	'検索条件名

Dim vntGFFlg				'後日GF受診フラグ
Dim vntCFFlg				'後日GF受診フラグ
Dim vntSeq					'SEQ

Dim lngAllCount				'総件数
Dim lngRsvAllCount			'重複予約なし件数
Dim lngGetCount				'件数
Dim i					'カウンタ
Dim j

Dim lngStartPos				'表示開始位置
Dim lngPageMaxLine			'１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()		'１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName()	'１ページ表示ＭＡＸ行名の配列

Dim lngArrSendMode()		'発送日確認状態の配列
Dim strArrSendModeName()	'発送日確認状態名の配列

Dim Ret						'関数戻り値
Dim strURL					'ジャンプ先のURL

Dim vntDelRsvNo				'
Dim vntDelSeq				'

'画面表示制御用検査項目
Dim strBeforeRsvNo			'前行の予約番号

Dim strWebCslDate			'受診日
Dim strWebDayId				'当日ID
Dim strWebCsInfo			'コース名
Dim strWebPerId				'個人ID
Dim strWebPerName			'カナ氏名・氏名
Dim strWebGender			'性別
Dim strWebBirth				'生年月日
Dim strWebOrgName			'団体略称
Dim strWebJudClassName			'判定分類名
Dim strWebQuestionName			'アンケート名
Dim strWebRsvNo				'予約番号

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objOrg          = Server.CreateObject("HainsOrganization.Organization")
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")

'引数値の取得
strMode           = Request("mode")
strAction         = Request("action")
strStartYear      = Request("startYear")
strStartMonth     = Request("startMonth")
strStartDay       = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strPerId          = Request("perId")
lngStartPos       = Request("startPos")
lngPageMaxLine    = Request("pageMaxLine")
strCsCd           = Request("csCd")

'デフォルトはシステム年月日を適用する
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(Now))
	strStartMonth = CStr(Month(Now))
	strStartDay   = CStr(Day(Now))
End If
If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
	strEndYear  = CStr(Year(Now))
	strEndMonth = CStr(Month(Now))
	strEndDay   = CStr(Day(Now))
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Call CreatePageMaxLineInfo()

Do

	'検索ボタンクリック
	If strAction = "search" Then

		'受診日(自)の日付チェック
		If strStartYear <> 0 Or strStartMonth <> 0 Or strStartDay <> 0 Then
			If Not IsDate(strStartYear & "/" & strStartMonth & "/" & strStartDay) Then
				strMessage = "受診日の指定に誤りがあります。"
				Exit Do
			End If
		End If

		'受診日(至)の日付チェック
		If strEndYear <> 0 Or strEndMonth <> 0 Or strEndDay <> 0 Then
			If Not IsDate(strEndYear & "/" & strEndMonth & "/" & strEndDay) Then
				strMessage = "受診日の指定に誤りがあります。"
				Exit Do
			End If
		End If

		'検索開始終了受診日の編集
		strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
		strEndCslDate   = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)

		''１年以内かチェック
		If strEndCslDate - strStartCslDate > 366 Then
			strMessage = "受診日は１年以内を指定して下さい。"
			Exit Do
		End If

		'全件を取得する
		lngAllCount = objFollowUp.SelectFromToFollow_I(strStartCslDate, strEndCslDate, _
			                                       strCsCd, strOrgCd1, strOrgCd2, _
			                                       lngPageMaxLine, lngStartPos, _
			                                       , , _
			                                       , , _
			                                       , , _
			                                       , , _
			                                       , , _
			                                       , , _
			                                       , False _
                					      )

		If lngAllCount > 0 Then

			lngRsvAllCount = objFollowUp.SelectFromToFollow_I(strStartCslDate, strEndCslDate, _
				                                          strCsCd, strOrgCd1, strOrgCd2, _
				                                          lngPageMaxLine, lngStartPos, _
				                                          vntRsvNo, vntCslDate, _
				                                          vntDayId, vntCsname, _
				                                          vntWebColor, vntPerId, _
				                                          vntPerKName, vntPerName, _
				                                          vntGender, vntBirth, _
				                                          vntOrgSName, vntJudClassName, _
				                                          vntQuestionName, True _
	                					         )


		End If

		'団体コードあり？
		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			ObjOrg.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , strOrgName 
		Else
			strOrgName = ""
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

	lngArrPageMaxLine(0) = 20:strArrPageMaxLineName(0) = "20行ずつ"
	lngArrPageMaxLine(1) = 50:strArrPageMaxLineName(1) = "50行ずつ"
	lngArrPageMaxLine(2) = 100:strArrPageMaxLineName(2) = "100行ずつ"
	lngArrPageMaxLine(3) = 999:strArrPageMaxLineName(3) = "すべて"

End Sub
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML LANG="ja">

<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>フォローアップ照会</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winGuideFollowUp;		//フォローアップ画面ハンドル
// 検索ボタンクリック
function searchClick() {

	with ( document.entryFollowInfo ) {
		startPos.value = 1;
		action.value = 'search';
		submit();
	}

	return false;

}

// ガイド画面を表示
function followUp_openWindow( url ) {

	var opened = false;	// 画面が開かれているか

	var dialogWidth = 1000, dialogHeight = 600;
	var dialogTop, dialogLeft;

	// すでにガイドが開かれているかチェック
	if ( winGuideFollowUp ) {
		if ( !winGuideFollowUp.closed ) {
			opened = true;
		}
	}

	// 画面を中央に表示するための計算
	dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
	dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

	// 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
	if ( opened ) {
		winGuideFollowUp.focus();
		winGuideFollowUp.location.replace( url );
	} else {
		winGuideFollowUp = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// アンロード時の処理
function closeGuideWindow() {

	// 団体検索ガイドを閉じる
	orgGuide_closeGuideOrg();

	//日付ガイドを閉じる
	calGuide_closeGuideCalendar();

	if ( winGuideFollowUp != null ) {
		if ( !winGuideFollowUp.closed ) {
			winGuideFollowUp.close();
		}
	}

	winGuideFollowUp = null;


	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryFollowInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="action" VALUE=""> 
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<% = lngStartPos %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">フォローアップ照会</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
	<TR>
		<TD>受診日</TD>
		<TD>：</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
					<TD>&nbsp;日～&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
					<TD>&nbsp;年&nbsp;</TD>
					<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
					<TD>&nbsp;月&nbsp;</TD>
					<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
					<TD>&nbsp;日</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</TD>
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
					<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryFollowInfo.orgCd1, document.entryFollowInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="団体検索ガイドを表示" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:orgGuide_clearOrgInfo(document.entryFollowInfo.orgCd1, document.entryFollowInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="設定した値をクリア" HEIGHT="21" WIDTH="21"></TD>
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
	</TR>
	<TR>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
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
						「<FONT COLOR="#ff6600"><B><%= strStartYear %>年<%= strStartMonth %>月<%= strStartDay %>日～<%= strEndYear %>年<%= strEndMonth %>月<%= strEndDay %>日</B></FONT>」のフォローアップ照会情報一覧を表示しています。<BR>
								検索結果は<FONT COLOR="#ff6600"><B><%= lngRsvAllCount %></B></FONT>名（フォローアップ照会枚数単位）です。 
						</SPAN>
					</TD>
				</TR>
			</TABLE>
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
					<TD ALIGN="left" NOWRAP>健診項目</TD>
					<TD ALIGN="left" NOWRAP>アンケート</TD>
					<TD ALIGN="left" NOWRAP>予約番号</TD>
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
				strWebJudClassName	= vntJudClassName(i)
				strWebQuestionName	= vntQuestionName(i)
				strWebRsvNo		= ""

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
					strURL = "/webHains/contents/followUp/followupTop.asp"
					strURL = strURL & "?rsvno="  & vntRsvNo(i)
					strURL = strURL & "&winmode="  & "1"

				End If
%>
				<TR HEIGHT="18" BGCOLOR="#eeeeee">
					<TD NOWRAP><%= strWebCslDate      %></TD>
					<TD NOWRAP><%= strWebDayId        %></TD>
					<TD NOWRAP><%= strWebCsInfo       %></TD>
					<TD NOWRAP><%= strWebPerId        %></TD>
					<TD NOWRAP><A HREF="javascript:followUp_openWindow('<%= strURL %>')" TARGET="_top"><%= strWebPerName %></A></TD>
					<TD NOWRAP><%= strWebGender       %></TD>
					<TD NOWRAP><%= strWebBirth        %></TD>
					<TD NOWRAP><%= strWebOrgName      %></TD>
					<TD NOWRAP><%= strWebJudClassName %></TD>
					<TD NOWRAP><%= strWebQuestionName %></TD>
					<TD NOWRAP><%= strWebRsvNo        %></TD>
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
				strURL = strURL & "&startYear="   & strStartYear
				strURL = strURL & "&startMonth="  & strStartMonth
				strURL = strURL & "&startDay="    & strStartDay
				strURL = strURL & "&endYear="     & strEndYear
				strURL = strURL & "&endMonth="    & strEndMonth
				strURL = strURL & "&endDay="      & strEndDay
				strURL = strURL & "&orgCd1="      & strOrgCd1
				strURL = strURL & "&orgCd2="      & strOrgCd2
				strURL = strURL & "&csCd="        & strCsCd
				strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
				'ページングナビゲータの編集
%>
				<%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
			End If
%>
			<BR>
<%
		End If
		Exit do
	Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>