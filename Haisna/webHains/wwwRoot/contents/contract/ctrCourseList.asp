<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/editOrgHeader.inc"        -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const ACTMODE_BROWSE  = "browse"	'動作モード(参照)
Const ACTMODE_COPY    = "copy"		'動作モード(コピー)
Const ACTMODE_RELEASE = "release"	'動作モード(参照解除)

'データベースアクセス用オブジェクト
Dim objContract			'契約情報アクセス用
Dim objContractControl	'契約情報アクセス用

'引数値
Dim strActMode			'動作モード
Dim strOrgCd1			'団体コード1
Dim strOrgCd2			'団体コード2
Dim strCsCd				'コースコード
Dim lngStrYear			'契約開始年
Dim lngStrMonth			'契約開始月
Dim lngStrDay			'契約開始日
Dim lngEndYear			'契約終了年
Dim lngEndMonth			'契約終了月
Dim lngEndDay			'契約終了日
Dim strRefOrgCd1		'参照先団体コード1
Dim strRefOrgCd2		'参照先団体コード2
Dim strCtrPtCd			'契約パターンコード

'契約管理情報
Dim strWebColor			'webカラー
Dim strArrCsCd			'コースコード
Dim strCsName			'コース名
Dim strArrRefOrgCd1		'参照先団体コード1
Dim strArrRefOrgCd2		'参照先団体コード2
Dim strRefOrgName		'参照先団体漢字名称
Dim strArrCtrPtCd		'契約パターンコード
Dim strArrStrDate		'契約開始日
Dim strArrEndDate		'契約終了日
Dim strAgeCalc			'年齢起算日
Dim blnReferred			'他団体参照フラグ(他団体から参照されていればTrue)
Dim lngCount			'レコード数

Dim strStrDate			'契約開始年月日
Dim strEndDate			'契約終了年月日
Dim blnChecked			'日付チェックが正常か
Dim blnExistRefOrg		'参照先団体が存在する場合にTrue
Dim strMessage			'エラーメッセージ
Dim strURL				'ジャンプ先のURL
Dim Ret					'関数戻り値
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'引数値の取得
strActMode   = Request("actMode")
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strCsCd      = Request("csCd")
lngStrYear   = CLng("0" & Request("strYear"))
lngStrMonth  = CLng("0" & Request("strMonth"))
lngStrDay    = CLng("0" & Request("strDay"))
lngEndYear   = CLng("0" & Request("endYear"))
lngEndMonth  = CLng("0" & Request("endMonth"))
lngEndDay    = CLng("0" & Request("endDay"))
strRefOrgCd1 = Request("refOrgCd1")
strRefOrgCd2 = Request("refOrgCd2")
strCtrPtCd   = Request("ctrPtCd")

'契約開始・終了日のデフォルト値設定
'### 2003/11/26 Updated by Ishihara@FSIT デフォルト範囲を広げた
'lngStrYear  = IIf(lngStrYear  = 0, Year(Now()),  lngStrYear)
lngStrYear  = IIf(lngStrYear  = 0, Year(Now()) -1 ,  lngStrYear)

lngStrMonth = IIf(lngStrMonth = 0, Month(Now()), lngStrMonth)
lngStrDay   = IIf(lngStrDay   = 0, Day(Now()),   lngStrDay)

'### 2003/11/26 Updated by Ishihara@FSIT デフォルト範囲を広げた
'lngEndYear  = IIf(lngEndYear  = 0, Year(Now()),  lngEndYear)
lngEndYear  = IIf(lngEndYear  = 0, Year(Now()) + 1,  lngEndYear)

lngEndMonth = IIf(lngEndMonth = 0, Month(Now()), lngEndMonth)
lngEndDay   = IIf(lngEndDay   = 0, Day(Now()),   lngEndDay)

'### 日付設定エラーによって臨時対応 2008/02/29 張 Start
lngStrDay   = IIf(lngStrMonth = 2 and lngStrDay = 29, 28,   lngStrDay)
lngEndDay   = IIf(lngEndMonth = 2 and lngEndDay = 29, 28,   lngEndDay)
'### 日付設定エラーによって臨時対応 2008/02/29 張 End


'契約開始・終了年月日の編集
strStrDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
strEndDate = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay
blnChecked = True

Do
	'動作モードごとの制御
	Select Case strActMode

		'契約パターンのコピー
		Case ACTMODE_COPY

			'コピー処理
			Ret = objContractControl.CopyReferredContract(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, strCtrPtCd)
			Select Case Ret
				Case 0
				Case 1
					strMessage = "契約団体自身が負担元として存在する契約情報のコピーはできません。"
					Exit Do
				Case Else
					Exit Do
			End Select

			'エラーがなければ自分自身をリダイレクト
			strURL = Request.ServerVariables("SCRIPT_NAME")
			strURL = strURL & "?orgCd1="    & strOrgCd1
			strURL = strURL & "&orgCd2="    & strOrgCd2
			strURL = strURL & "&csCd="      & strCsCd
			strURL = strURL & "&strYear="   & lngStrYear
			strURL = strURL & "&strMonth="  & lngStrMonth
			strURL = strURL & "&strDay="    & lngStrDay
			strURL = strURL & "&endYear="   & lngEndYear
			strURL = strURL & "&endMonth="  & lngEndMonth
			strURL = strURL & "&endDay="    & lngEndDay
			Response.Redirect strURL
			Response.End

		'契約情報の参照解除
		Case ACTMODE_RELEASE

			'参照解除処理
			Ret = objContractControl.Release(strOrgCd1, strOrgCd2, strCtrPtCd)
			Select Case Ret
				Case 0
				Case 1
					strMessage = "この契約情報を参照している受診情報が存在します。削除できません。"
					Exit Do
				Case Else
					Exit Do
			End Select

			'エラーがなければ自分自身をリダイレクト
			strURL = Request.ServerVariables("SCRIPT_NAME")
			strURL = strURL & "?orgCd1="    & strOrgCd1
			strURL = strURL & "&orgCd2="    & strOrgCd2
			strURL = strURL & "&csCd="      & strCsCd
			strURL = strURL & "&strYear="   & lngStrYear
			strURL = strURL & "&strMonth="  & lngStrMonth
			strURL = strURL & "&strDay="    & lngStrDay
			strURL = strURL & "&endYear="   & lngEndYear
			strURL = strURL & "&endMonth="  & lngEndMonth
			strURL = strURL & "&endDay="    & lngEndDay
			Response.Redirect strURL
			Response.End

	End Select

	'「表示」ボタン押下時以外は何もしない
	If IsEmpty(Request("display.x")) Then
		Exit Do
	End If

	'契約開始年月日の日付チェック
	If Not IsDate(strStrDate) Then
		strMessage = "受診開始日の入力形式が正しくありません。"
		blnChecked = False
		Exit Do
	End If

	'契約終了年月日の日付チェック
	If Not IsDate(strEndDate) Then
		strMessage = "受診終了日の入力形式が正しくありません。"
		blnChecked = False
		Exit Do
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
<TITLE>契約情報</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var style = 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no';

var winNewContract;	// 新規契約作成ウィンドウオブジェクト

// 新規契約作成ウィザードを表示
function showNewContractWizard() {

	var opened = false;	// 画面が開かれているか
	var url;			// 新規契約作成画面のURL

	var dialogWidth = 800, dialogHeight = 650;
	var dialogTop, dialogLeft;

	// すでにガイドが開かれているかチェック
	if ( winNewContract != null ) {
		if ( !winNewContract.closed ) {
			opened = true;
		}
	}

	// 新規契約作成画面のURL編集
	url = 'ctrSelectCourse.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>';

	// 画面を中央に表示するための計算
	dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
	dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winNewContract.focus();
	} else {
		winNewContract = window.open(url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style );
	}

}

// 新規契約作成ウィザードを閉じる
function closeWindow() {

	// 新規契約作成ウィザードを閉じる
	if ( winNewContract != null ) {
		if ( !winNewContract.closed ) {
			winNewContract.close();
		}
	}

	winNewContract = null;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">

	<!-- 表題 -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">契約情報</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'エラーメッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="85%">
		<TR>
			<TD HEIGHT="6"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="3" VALIGN="top">
<%
				'団体情報の編集
				Call EditOrgHeader(strOrgCd1, strOrgCd2)
%>
			</TD>
		</TR>
	</TABLE>


	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH="900">
		<TR>
			<TD ALIGN="RIGHT">
				<A HREF="ctrSearchOrg.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="団体検索画面へ戻ります。"></A>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="900">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">契約情報の一覧</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="900">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD VALIGN="top" ROWSPAN="2">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP>コース</TD>
						<TD>：</TD>
						<TD COLSPAN="15"><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %></TD>
					</TR>
					<TR>
						<TD NOWRAP>受診期間</TD>
						<TD>：</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
						<TD NOWRAP>日～</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
						<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
						<TD>年</TD>
						<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
						<TD>月</TD>
						<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, False) %></TD>
						<TD NOWRAP>日の契約情報を</TD>
						<TD><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="表示"></TD>
					</TR>
				</TABLE>
			</TD>
			
			<TD ALIGN="right">
			<% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javaScript:showNewContractWizard()"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新しい契約情報を作成します"></A>
			<%  else    %>
				 &nbsp;
			<%  end if  %>
			<% '2005.08.22 権限管理 Add by 李　--- END %>
			</TD>
		
		</TR>
		<TR>
			<TD ALIGN="right">
			<% '2005.08.22 権限管理 Add by 李　--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="ctrSelectCourse.asp?actMode=<%= ACTMODE_BROWSE %>&orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webHains/images/prevcopy.gif" WIDTH="77" HEIGHT="24" ALT="契約情報の参照または複写を行います"></A>
			<%  else    %>
				 &nbsp;
			<%  end if  %>
			<% '2005.08.22 権限管理 Add by 李　--- END %>
			</TD>
		</TR>
	
	</TABLE>

	<BR>
<%
	Do
		'日付チェック異常時は何もしない
		If Not blnChecked Then
			Exit Do
		End If

		'契約管理情報読み込み
		lngCount = objContract.SelectAllCtrMng(strOrgCd1,       strOrgCd2,     strCsCd, _
											   strStrDate,      strEndDate,    strWebColor, _
											   strArrCsCd,      strCsName, ,   strArrRefOrgCd1, _
											   strArrRefOrgCd2, strRefOrgName, strArrCtrPtCd, _
											   strArrStrDate,   strArrEndDate, strAgeCalc, _
											   blnReferred)
		If lngCount <= 0 Then
%>
			検索条件を満たす契約情報は存在しません。
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
			<TR BGCOLOR="#eeeeee">
				<TD WIDTH="200" NOWRAP>受診コース</TD>
				<TD ALIGN="center" COLSPAN="7" NOWRAP>契約期間</TD>
				<TD ALIGN="center" COLSPAN="6" NOWRAP>年齢起算日</TD>
				<TD NOWRAP>操作</TD>
				<TD NOWRAP>参照中の契約情報</TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
					<TD NOWRAP><FONT COLOR="#<%= strWebColor(i) %>">■</FONT><%= strCsName(i) %></TD>
					<TD NOWRAP><%= Year(strArrStrDate(i)) %>年</TD>
					<TD NOWRAP ALIGN="right"><%= Month(strArrStrDate(i)) %>月</TD>
					<TD NOWRAP ALIGN="right"><%= Day(strArrStrDate(i))   %>日</TD>
					<TD>～</TD>
					<TD NOWRAP><%= Year(strArrEndDate(i)) %>年</TD>
					<TD NOWRAP ALIGN="right"><%= Month(strArrEndDate(i)) %>月</TD>
					<TD NOWRAP ALIGN="right"><%= Day(strArrEndDate(i))   %>日</TD>
<%
					'年齢起算日による制御
					Select Case Len(strAgeCalc(i))
						Case 8
%>
							<TD NOWRAP ALIGN="right">&nbsp;<%= CLng(Left(strAgeCalc(i), 4)) %></TD>
							<TD>年</TD>
							<TD NOWRAP ALIGN="right"><%= CLng(Mid(strAgeCalc(i), 5, 2)) %></TD>
							<TD>月</TD>
							<TD NOWRAP ALIGN="right"><%= CLng(Right(strAgeCalc(i), 2)) %></TD>
							<TD>日</TD>
<%
						Case 4
%>
							<TD COLSPAN="2"></TD>
							<TD NOWRAP ALIGN="right"><%= CLng(Left(strAgeCalc(i), 2)) %></TD>
							<TD>月</TD>
							<TD NOWRAP ALIGN="right"><%= CLng(Right(strAgeCalc(i), 2)) %></TD>
							<TD>日</TD>
<%
						Case Else
%>
							<TD COLSPAN="6"></TD>
<%
					End Select

					'自団体と参照先団体が同一かをチェック
					If strArrRefOrgCd1(i) = strOrgCd1 And strArrRefOrgCd2(i) = strOrgCd2 Then

						'同一な場合、契約情報参照・登録用URLの編集
						strURL = "ctrDetail.asp"
						strURL = strURL & "?orgCd1="  & strOrgCd1
						strURL = strURL & "&orgCd2="  & strOrgCd2
						strURL = strURL & "&csCd="    & strArrCsCd(i)
						strURL = strURL & "&ctrPtCd=" & strArrCtrPtCd(i)
%>
						<TD ALIGN="center"><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/godetail.gif" WIDTH="21" HEIGHT="21" ALT="この契約の詳細を見る"></A></TD>
						<TD></TD>
<%
					'他団体の契約情報を参照している場合
					Else
%>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></TD>
						<TD NOWRAP>
<%
							'参照先団体の契約情報参照用URLの編集
							strURL = "ctrDetail.asp"
							strURL = strURL & "?orgCd1="  & strArrRefOrgCd1(i)
							strURL = strURL & "&orgCd2="  & strArrRefOrgCd2(i)
							strURL = strURL & "&csCd="    & strArrCsCd(i)
							strURL = strURL & "&ctrPtCd=" & strArrCtrPtCd(i)
%>
							<A HREF="<%= strURL %>"><%= strRefOrgName(i) %></A>&nbsp;→
<%
							'コピー処理用URLの編集
							strURL = Request.ServerVariables("SCRIPT_NAME")
							strURL = strURL & "?actMode="   & ACTMODE_COPY
							strURL = strURL & "&orgCd1="    & strOrgCd1
							strURL = strURL & "&orgCd2="    & strOrgCd2
							strURL = strURL & "&csCd="      & strCsCd
							strURL = strURL & "&strYear="   & lngStrYear
							strURL = strURL & "&strMonth="  & lngStrMonth
							strURL = strURL & "&strDay="    & lngStrDay
							strURL = strURL & "&endYear="   & lngEndYear
							strURL = strURL & "&endMonth="  & lngEndMonth
							strURL = strURL & "&endDay="    & lngEndDay
							strURL = strURL & "&refOrgCd1=" & strArrRefOrgCd1(i)
							strURL = strURL & "&refOrgCd2=" & strArrRefOrgCd2(i)
							strURL = strURL & "&ctrPtCd="   & strArrCtrPtCd(i)
%>
							<A HREF="<%= strURL %>" ONCLICK="javascript:return confirm('この契約情報をコピーします。よろしいですか？')">コピー</A>&nbsp;
<%
							'参照解除用URLの編集
							strURL = Request.ServerVariables("SCRIPT_NAME")
							strURL = strURL & "?actMode="  & ACTMODE_RELEASE
							strURL = strURL & "&orgCd1="   & strOrgCd1
							strURL = strURL & "&orgCd2="   & strOrgCd2
							strURL = strURL & "&strYear="  & lngStrYear
							strURL = strURL & "&strMonth=" & lngStrMonth
							strURL = strURL & "&strDay="   & lngStrDay
							strURL = strURL & "&endYear="  & lngEndYear
							strURL = strURL & "&endMonth=" & lngEndMonth
							strURL = strURL & "&endDay="   & lngEndDay
							strURL = strURL & "&ctrPtCd="  & strArrCtrPtCd(i)
%>
							<A HREF="<%= strURL %>" ONCLICK="JavaScript:return confirm('この契約情報の参照を解除します。よろしいですか？')">参照解除</A>
						</TD>
<%
					End If
%>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
