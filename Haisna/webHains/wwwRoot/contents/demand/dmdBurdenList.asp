<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		請求書検索 (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<!-- #include virtual = "/webHains/includes/EditBillClassList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'引数値
Dim strAction				'処理状態（検索ボタン押下時:"search"）
Dim lngStrYear				'開始締め日(年)
Dim lngStrMonth				'開始締め日(月)
Dim lngStrDay				'開始締め日(日)
Dim lngEndYear				'終了締め日(年)
Dim lngEndMonth				'終了締め日(月)
Dim lngEndDay				'終了締め日(日)
Dim strOrgCd1				'団体コード１
Dim strOrgCd2				'団体コード２
Dim strBillNo				'請求書Ｎｏ
Dim lngStartPos				'表示開始位置
Dim strIsPrint				'請求書出力状態
'★2004/01/09 Shiramizu Modified Start
Dim strIsDispatch			'請求書発送状態
Dim strIsPayment			'入金状態
Dim strIsCancel				'取消伝票表示
Dim strSortName				'ソート列名
Dim strSortType				'ソート順（1:昇順、2：降順）
Dim strGetCount				'１ページ表示件数
Dim strCloseDate			'請求書番号検索条件から取得した締め日
Const LENGTH_BILLNO = 14
'★2004/01/09 Shiramizu Modified End
Dim strHideIsrData			'健保データ非表示

Dim strCslOrgCd1			'受診団体コード１
Dim strCslOrgCd2			'受診団体コード２
Dim strCslOrgName			'受診団体名

'COMオブジェクト
Dim objCommon				'共通関数アクセス用COMオブジェクト
Dim objDemand				'請求アクセス用COMオブジェクト
Dim objOrganization			'団体アクセス用COMオブジェクト

'請求書情報読み込み
Dim strStrDate				'開始締め日
Dim strEndDate				'終了締め日
Dim lngAllCount				'条件を満たす全レコード件数
Dim strPageMaxLine			'１ページ表示行数
Dim lngGetCount				'１ページ表示件数
Dim lngCount				'検索できた件数
Dim lngArrBillNo			'請求書Ｎｏ
Dim strArrCloseDate			'締め日（"yyyy/m/d"編集）
Dim strArrOrgCd1			'負担元団体コード1
Dim strArrOrgCd2			'負担元団体コード2
Dim strArrOrgName			'負担元団体名
Dim lngArrMethod			'作成方法
Dim lngArrSeq				'
Dim strArrCslOrgCd1			'受診団体コード1
Dim strArrCslOrgCd2			'受診団体コード2
Dim strArrCslOrgName		'受診団体名
Dim strArrCsCd				'コースコード
Dim strArrCsName			'コース名
Dim strArrWebColor			'コース名表示色
Dim strArrCsSubTotal		'金額
Dim strArrCsTax				'消費税
Dim strArrCsDiscount		'値引き
Dim strArrCsTotal			'合計
'★2004/01/09 Shiramizu Modified Start
Dim strArrOrgKName			'団体カナ名
Dim strArrBillSeq			'請求書Seq
Dim strArrBranchno			'請求書枝番
Dim strArrDispatchDate		'発送日付
Dim strArrPaymentDate		'入金日付
Dim lngArrPriceTotal		'小計
Dim lngArrTaxTotal			'税額
Dim lngArrBillTotal			'請求額
Dim lngArrPaymentPrice		'入金額
Dim lngArrSumPaymentPrice	'入金額合計
Dim strArrUpdUser			'更新者ID
Dim strArrUserName			'更新者
Dim strArrDelFlg			'取消伝票フラグ
'Dim lngArrSeq				'Seq
'★2004/01/09 Shiramizu Modified End
'### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
Dim strArrBillComment		'請求書コメント
'### 2004/11/11 Add End
'## 2004.06.02 ADD STR ORB)T.YAGUCHI ２次検査の合計金額追加追加
Dim strSumPrice				'金額合計
Dim strSumEditPrice			'調整金額合計
Dim strSumTaxPrice			'税額合計
Dim strSumEditTax			'調整税額合計
Dim strSumPriceTotal			'総合計
Dim lngSumRecord			'レコード数
'## 2004.06.02 ADD END

Dim strBillClassCd			'請求書分類コード

Dim strArrBillClassCd		'請求書分類コード
Dim strArrBillClassName		'請求書分類名
Dim strArrPrtDate			'請求書出力日
Dim strArrIsrSign			'健保記号
Dim strArrIsrOrgName		'健保記号からの対象団体名
Dim strArrCsSeq				'コースSEQ

'画面表示用編集領域
Dim strDispCloseDate		'編集用の締め日（"yyyy/m/d"編集）
Dim strDispBillNo			'請求書番号
Dim strDispOrgName			'編集用の負担元団体名
Dim strDispOrgKName

Dim strDispDiscount			'編集用の値引き
Dim strDispCsSubTotal
Dim strDispCsTax
Dim strDispCsTotal

Dim strDispCslOrgName		'編集用の受診団体名
Dim strDispBillClassName	'請求書分類名
Dim strDispCsMark			'コースマーク
Dim strDispCsMarkColor		'コースマークカラー
Dim strDispCsName			'コース名
Dim blnBreakMode			'TRUE:請求書単位の合計表示、FALSE:請求書単位の合計非表示

Dim strDispPriceTotal		'小計
Dim strDispTaxTotal			'消費税
Dim strDispBillTotal		'請求金額
Dim strDispPaymentPrice		'入金額
Dim strDispNoPaymentPrice	'未収額


'ブレイクキー用変数格納領域
Dim strKeyBillNo			'ブレイクキー保存用の請求書Ｎｏ
Dim strKeyCslOrgCd1			'ブレイクキー保存用の受診団体コード1
Dim strKeyCslOrgCd2			'ブレイクキー保存用の受診団体コード2

Dim lngBillSubTotal			'合計
Dim lngBillTax				'税額
Dim lngBillDiscount			'値引き
Dim lngBillTotal			'総合計

'団体読み込み
Dim strOrgName			'団体名称

'入力チェック
Dim strArrMessage		'エラーメッセージ

'インデックス
Dim i

Dim dtmDate				'受診日デフォルト値計算用の日付
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strAction      = Request("action") & ""
lngStrYear     = CLng("0" & Request("strYear"))
lngStrMonth    = CLng("0" & Request("strMonth"))
lngStrDay      = CLng("0" & Request("strDay"))
lngEndYear     = CLng("0" & Request("endYear"))
lngEndMonth    = CLng("0" & Request("endMonth"))
lngEndDay      = CLng("0" & Request("endDay"))
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCslOrgCd1   = Request("cslOrgCd1")
strCslOrgCd2   = Request("cslOrgCd2")

strBillNo      = Request("billNo")
lngStartPos    = CLng("0" & Request("startPos"))
lngStartPos    = IIf(lngStartPos = 0, 1, lngStartPos)
strBillCLassCd = Request("billCLassCd") & ""
strIsPrint     = Request("IsPrint")
'★2004/01/09 Shiramizu Modified Start
strIsDispatch  = Request("IsDispatch")
strIsPayment   = Request("IsPayment")
strIsCancel    = Request("IsCancel")
strSortName    = Request("SortName")
strSortType    = Request("SortType")
strGetCount    = Request("getCount")
'★2004/01/09 Shiramizu Modified End
strHideIsrData = Request("HideIsrData")

'### 2003.04.01 初期表示時のみ、請求書出力日は未出力のみとする。
'### 2003.04.08 さらに指定
'If lngStrYear  = 0 then
If (lngStrYear  = 0) AND (strIsPrint = "") then
	strIsPrint = "2"
End If

'未指定時は初期値セット
lngStrYear    = IIf(lngStrYear  = 0, Year(Now),    lngStrYear )
lngStrMonth   = IIf(lngStrMonth = 0, Month(Now),   lngStrMonth)
lngStrDay     = IIf(lngStrDay   = 0, Day(Now),     lngStrDay  )
lngEndYear    = IIf(lngEndYear  = 0, Year(Now()),  lngEndYear )
lngEndMonth   = IIf(lngEndMonth = 0, Month(Now()), lngEndMonth)
lngEndDay     = IIf(lngEndDay   = 0, Day(Now()),   lngEndDay  )

'初期設定
strArrMessage = Empty

'一覧表示行数の取得
Set objCommon = Server.CreateObject("HainsCommon.Common")
strPageMaxLine = objCommon.SelectDmdBurdenListPageMaxLine
If strGetCount = "" Then
	strGetCount = strPageMaxLine
Else
	If strGetCount = "*" Then
'		strGetCount = ""
	End If
End If

Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'団体名称の取得
If Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" Then
	objOrganization.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
End If

'受診団体名称の取得
If Trim(strCslOrgCd1) <> "" And Trim(strCslOrgCd2) <> "" Then
	objOrganization.SelectOrgName strCslOrgCd1, strCslOrgCd2, strCslOrgName
End If

Set objOrganization = Nothing

'請求アクセス用COMオブジェクトの割り当て
Set objDemand = Server.CreateObject("HainsDemand.Demand")
'検索ボタン押下時入力チェック（strStrDateとstrEndDateに、Date型で返される）
If strAction = "search" Then
	strArrMessage = objDemand.CheckValueDmdPaymentSearch(lngStrYear, lngStrMonth, lngStrDay, strStrDate, lngEndYear, lngEndMonth, lngEndDay, strEndDate, strBillNo)
	If Not IsNull(strBillNo) And strBillNo <> "" Then
		If Len(strBillNo) = LENGTH_BILLNO Then
			strCloseDate = Mid(strBillNo,1,4) & "/" & Mid(strBillNo,5,2) & "/" & Mid(strBillNo,7,2)
			If Not IsDate(strCloseDate) Then
				If IsArray(strArrMessage) = true Then
					Redim Preserve strArrMessage(UBound(strArrMessage)+1)
					strArrMessage(UBound(strArrMessage)) = "請求書番号の日付入力形式が正しくありません。"
				Else
					strArrMessage = Array("請求書番号の日付入力形式が正しくありません。")
				End If
			End If
		End If
	End If
End If



'-------------------------------------------------------------------------------
'
' 機能　　 : 検索条件の編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function getSortURL(strWkSortName)
	Dim strURL
	Dim strWkSortType

	If strWkSortName = strSortName Then
		If strSortType = "1" Then
			strWkSortType = "2"
		Else
			strWkSortType = "1"
		End If
	Else
		strWkSortType = "1"
	End If

	'URLの編集
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?action="        & strAction
	strURL = strURL & "&strYear="       & lngStrYear
	strURL = strURL & "&strMonth="      & lngStrMonth
	strURL = strURL & "&strDay="        & lngStrDay
	strURL = strURL & "&endYear="       & lngEndYear
	strURL = strURL & "&endMonth="      & lngEndMonth
	strURL = strURL & "&endDay="        & lngEndDay
	strURL = strURL & "&orgCd1="        & strOrgCd1
	strURL = strURL & "&orgCd2="        & strOrgCd2

	strURL = strURL & "&billNo="        & strBillNo
	strURL = strURL & "&IsDispatch="    & strIsDispatch
	strURL = strURL & "&IsPayment="     & strIsPayment
	strURL = strURL & "&IsCancel="      & strIsCancel
	strURL = strURL & "&SortName="      & strWkSortName
	strURL = strURL & "&SortType="      & strWkSortType
	strURL = strURL & "&GetCount="      & strGetCount

	getSortURL = strURL
End Function


'-------------------------------------------------------------------------------
'
' 機能　　 : 表示行数一覧ドロップダウンリストの編集
'
' 引数　　 : (In)     strName                 エレメント名
' 　　　　 : (In)     strSelectedPageMaxLine  リストにて選択すべき表示行数
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditDailyPageMaxLineList(strName, strSelectedPageMaxLine)

	Dim vntPageMaxLine	'表示行数
	Dim vntPageMaxName	'表示行数名称

	'表示行数情報の取得
	If objCommon.SelectDailyPageMaxLineList(vntPageMaxLine, vntPageMaxName) > 0 Then

		'ドロップダウンリストの編集
		EditDailyPageMaxLineList = EditDropDownListFromArray(strName, vntPageMaxLine, vntPageMaxName, strSelectedPageMaxLine, NON_SELECTED_DEL)

	End If

End Function

'ソート順指定時のセル背景色変更
Function getSelectedColor(strWkSortName)
	Dim strColor

	If strWksortName = strSortName Then
		strColor = "CLASS=""selectedcolor"""
	Else
		strColor = ""
	End If

	getSelectedColor = strColor
End Function


'取消伝票の行背景色変更
Function getCanceledColor(strDelFlg)
	Dim strColor

	If strDelFlg = "1" Then
		strColor = "CLASS=""canceled"""
	Else
		strDelFlg = ""
	End If

	getCanceledColor = strColor
End Function

'未収額の文字色変更
Function getNopaymentColor(strDispNoPaymentPrice)
	Dim strColor

	If IsNull(strDispNoPaymentPrice) Or strDispNoPaymentPrice = "" Then
		strColor="BLACK"
	Else
		If CLng(strDispNoPaymentPrice) = 0 Then
			strColor="BLACK"
		Else
			strColor="RED"
		End If
	End If
	getNopaymentColor = strColor
End Function

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>請求書検索</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var dmdOrgMasterBurden_CalledFunction;	// 請求書基本情報処理後呼び出し関数
var winOrgMasterBurden;					// 請求書基本情報ウィンドウハンドル
var dmdBurdenModify_CalledFunction;		// 請求基本情報処理後呼び出し関数
var winBurdenModify;					// 請求基本情報ウィンドウハンドル
var flgBurdenModify;					// 請求書基本情報呼び出しフラグ
var dmdPayment_CalledFunction;			// 入金処理後呼び出し関数
var winPayment;							// 入金処理ウィンドウハンドル
flgBurdenModify = false;
flgOrgMasterBurden = false;

// 団体検索ガイド呼び出し
function callOrgGuide( mode ) {

	var targetOrgCd1;
	var targetOrgCd2;
	var targetOrgName;

	if ( mode == 1 ) {
		targetOrgCd1  = document.entryCondition.orgCd1
		targetOrgCd2  = document.entryCondition.orgCd2
		orgGuide_showGuideOrg(targetOrgCd1, targetOrgCd2, 'orgName', '', '');

		targetOrgName = document.entryCondition.orgCdName
	} else {
		targetOrgCd1  = document.entryCondition.cslOrgCd1
		targetOrgCd2  = document.entryCondition.cslOrgCd2
		orgGuide_showGuideOrg(targetOrgCd1, targetOrgCd2, 'cslOrgName', '', '');
	}

}

// 団体コード・名称のクリア
function clearOrgInfo( mode ) {

	if ( mode == 1 ) {
		orgGuide_clearOrgInfo(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');
	} else {
		orgGuide_clearOrgInfo(document.entryCondition.cslOrgCd1, document.entryCondition.cslOrgCd2, 'cslOrgName');
	}

}


// 請求書新規作成呼び出し
function callDmdOrgMasterBurden() {

	var opened = false;
	flgOrgMasterBurden = true;

	dmdOrgMasterBurden_CalledFunction = loadBurdenList;

	// すでに請求書基本情報が開かれているかチェック
	if ( winOrgMasterBurden != null ) {
		if ( !winOrgMasterBurden.closed ) {
			opened = true;
		}
	}

	if ( opened ) {
		winOrgMasterBurden.location.replace("dmdOrgMasterBurden.asp");
		winOrgMasterBurden.focus();
	} else {
//		winOrgMasterBurden = window.open("dmdOrgMasterBurden.asp?billNo=" + billNo,"","toolbar=no,directories=no,menubar=no,resizable=yes,scrollbars=yes,width=650,height=400");
		winOrgMasterBurden = window.open("dmdOrgMasterBurden.asp");
	}
	
	return false;
}


// 請求書基本情報呼び出し
function callDmdBurdenModify( billNo) {

	var opened = false;
	flgBurdenModify = true;

	dmdBurdenModify_CalledFunction = loadBurdenList;

	// すでに請求情報修正が開かれているかチェック
	if ( winBurdenModify != null ) {
		if ( !winBurdenModify.closed ) {
			opened = true;
		}
	}

	if ( opened ) {
		winBurdenModify.location.replace("dmdBurdenModify.asp?billNo=" + billNo);
		winBurdenModify.focus();
	} else {
		winBurdenModify = window.open("dmdBurdenModify.asp?billNo=" + billNo);
	}
	
	return false;
}


// 入金処理呼び出し
function callDmdPayment(mode, billNo, seq) {

	var opened = false;

	dmdPayment_CalledFunction = loadBurdenList;

	// すでに請求情報修正が開かれているかチェック
	if ( winPayment != null ) {
		if ( !winPayment.closed ) {
			opened = true;
		}
	}

	if ( opened ) {
		winPayment.location.replace("dmdPayment.asp?mode=" + mode + "&billNo=" + billNo + "&seq=" + seq);
		winPayment.focus();
	} else {
		winPayment = window.open("dmdPayment.asp?mode=" + mode + "&billNo=" + billNo + "&seq=" + seq);
	}
	
	return false;
}

// 請求書基本情報・請求情報修正処理後、自画面更新
function loadBurdenList() {
	document.entryCondition.submit();
	return false;
}

// 請求書基本情報処理後、自画面更新
function focusBurdenList() {
	if(flgBurdenModify == true){
		if(winBurdenModify == null || winBurdenModify.closed){
			document.entryCondition.submit();
		}
	}

	if(flgOrgMasterBurden == true){
		if(winOrgMasterBurden == null || winOrgMasterBurden.closed){
			document.entryCondition.submit();
		}
	}
	return false;
}


// 検索ボタン押下時の処理
function submitSearch() {

	document.entryCondition.startPos.value = '1';
	document.entryCondition.submit();

	return false;
}

// アンロード時の処理
function closeDmdBurdenWindow() {

	// 請求情報修正を閉じる
	if ( winBurdenModify != null ) {
		if ( !winBurdenModify.closed ) {
			winBurdenModify.close();
		}
	}

	// 請求書基本情報を閉じる
	if ( winPayment != null ) {
		if ( !winPayment.closed ) {
			winPayment.close();
		}
	}

	// カレンダーガイドを閉じる
	if ( winGuideCalendar ) {
		if ( !winGuideCalendar.closed ) {
			winGuideCalendar.close();
		}
	}

	// 団体検索ガイドを閉じる
	orgGuide_closeGuideOrg();

	return false;
}
//-->
</SCRIPT>
<style>
	table.mainresult td { padding: 0 4px 0; }
	td.dmdtab  { background-color:#FFFFFF }
	div.maindiv { margin: 10px 10px 0 10px; }
</STYLE>
</HEAD>
<BODY onFocus="focusBurdenList();" onUnload="closeDmdBurdenWindow();">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<!--<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">-->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="return submitSearch()" METHOD="get">
<INPUT TYPE="hidden" NAME="action" VALUE="search">
<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= CStr(lngStartPos) %>">
<INPUT TYPE="hidden" NAME="SortName" VALUE="<%= strSortName%>">
<INPUT TYPE="hidden" NAME="SortType" VALUE="<%= strSortType%>">
<!--
★2004/01/09 Shiramizu Modified Start
画面名列幅変更
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
-->

<div class="maindiv">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">請求書検索</FONT></B></TD>
	</TR>
</TABLE>
<%
	'メッセージの編集
	Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
<TABLE WIDTH=80%>
<TR><TD>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD>締め日</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
					<TD>日</TD>
					<TD>～</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示"></A></TD>
					<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
					<TD>年</TD>
					<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
					<TD>月</TD>
					<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, False) %></TD>
					<TD>日</TD>
				</TR>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>請求先</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:callOrgGuide(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
					<TD><A HREF="javascript:clearOrgInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
					<TD WIDTH="5"></TD>
					<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
					<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
					<TD><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
<!--
	<TR>
		<TD>受診団体</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:callOrgGuide(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示"></A></TD>
					<TD><A HREF="javascript:clearOrgInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
					<TD WIDTH="5"></TD>
					<INPUT TYPE="hidden" NAME="cslOrgCd1" VALUE="<%= strCslOrgCd1 %>">
					<INPUT TYPE="hidden" NAME="cslOrgCd2" VALUE="<%= strCslOrgCd2 %>">
					<TD><SPAN ID="cslOrgName"><%= strCslOrgName %></SPAN></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
-->
<!--
★2004/01/09 Shiramizu Modified Start
　検索条件項目変更
	<TR>
		<TD>健保データ</TD>
		<TD>：</TD>
		<TD><INPUT TYPE="CHECKBOX" VALUE="1" NAME="hideIsrData" <%= IIf(strHideIsrData = "1", "CHECKED", "") %>>健康保険組合のデータは表示対象外
		</TD>
	</TR>
	<TR>
		<TD>請求書分類</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><%= Replace(EditBillClassList("billClassCd", strBillClassCd, NON_SELECTED_ADD), "NAME=""billClassCd""", "NAME=""billClassCd""" ) %></TD>
					<TD WIDTH="5"></TD>
					<TD NOWRAP>請求書番号</TD>
					<TD>：</TD>
					<TD><INPUT TYPE="text" NAME="billNo" SIZE="11" MAXLENGTH="9" VALUE="<%= strBillNo %>"></TD>
					<TD WIDTH="5"></TD>
					<TD NOWRAP>請求書</TD>
					<TD>：</TD>
					<TD>
						<SELECT NAME="IsPrint">
							<OPTION VALUE="2" <%= Iif(strIsPrint = "2", "SELECTED", "") %>>未出力のみ
							<OPTION VALUE="1" <%= Iif(strIsPrint = "1", "SELECTED", "") %>>出力済みのみ
<!-- 2003.04.08 Updated by Ishihara@FSIT 空白では個人請求金額からのJumpでこまる
							<OPTION VALUE=""  <%= Iif(strIsPrint = "",  "SELECTED", "") %>>全て
-->
<!--
							<OPTION VALUE="0"  <%= Iif(strIsPrint = "0",  "SELECTED", "") %>>全て
						</SELECT>
					</TD>
					<TD WIDTH="25"></TD>
					<TD ALIGN="right"><A HREF="javascript:function voi(){};voi()" ONCLICK="return submitSearch()"><IMG SRC="/webHains/images/b_search.gif" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></A></TD>
					<TD WIDTH="5"></TD>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return callDmdOrgMasterBurden('');"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新しく請求書を作成する"></A></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
-->
	<TR>
		<TD NOWRAP>請求書No.</TD>
		<TD>：</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TD><INPUT TYPE="text" NAME="billNo" SIZE="20" MAXLENGTH="14" VALUE="<%= strBillNo %>"></TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>請求書発送</TD>
				<TD>：</TD>
				<TD>
					<SELECT NAME="IsDispatch">
						<OPTION VALUE="0" <%= Iif(strIsDispatch = "0", "SELECTED", "") %>>
						<OPTION VALUE="2" <%= Iif(strIsDispatch = "2", "SELECTED", "") %>>未発送のみ
						<OPTION VALUE="1" <%= Iif(strIsDispatch = "1", "SELECTED", "") %>>発送済みのみ
					</SELECT>
				</TD>
				<TD WIDTH="10">
				</TD>
				<TD NOWRAP>未収</TD>
				<TD>：</TD>
				<TD>
					<SELECT NAME="IsPayment">
						<OPTION VALUE="0" <%= Iif(strIsPayment = "0", "SELECTED", "") %>>
						<OPTION VALUE="2" <%= Iif(strIsPayment = "2", "SELECTED", "") %>>未収のみ
						<OPTION VALUE="1" <%= Iif(strIsPayment = "1", "SELECTED", "") %>>入金済みのみ
					</SELECT>
				</TD>
				<TD WIDTH="25"></TD>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>取消伝票</TD>
		<TD>：</TD>
		<TD>
		<TABLE>
			<TR>
				<TD NOWRAP>
					<INPUT TYPE="CHECKBOX" NAME="IsCancel" <%= Iif(strIsCancel = "1","CHECKED","") %> VALUE="1">取消伝票も表示する
				</TD>
			</TR>
		</TABLE>
		</TD>
	</TR>
<!--
					<TD><INPUT TYPE="text" NAME="billNo" SIZE="11" MAXLENGTH="9" VALUE="<%= strBillNo %>"></TD>
					<TD WIDTH="5"></TD>
-->
<!--
★2004/01/09 Shiramizu Modified End
-->
</TABLE>
</TD>
<TD VALIGN="BOTTOM">
	<TABLE BORDER=0>
		<TD>
<%= EditDailyPageMaxLineList("getCount", strGetCount) %>
		</TD>
		<TD ALIGN="right"><A HREF="javascript:function voi(){};voi()" ONCLICK="return submitSearch()"><IMG SRC="/webHains/images/b_search.gif" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></A></TD>
		<TD WIDTH="5"></TD>
		
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
            <TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return callDmdOrgMasterBurden();"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新しく請求書を作成する"></A></TD>
        <%  end if  %>

		</TD>
	</TABLE>
</TD>
</TABLE>
<%
Do
	'検索ボタン押下時以外は何もしない
	If strAction <> "search" Then Exit Do

	'検索条件が誤っている場合は何もしない
	If Not IsEmpty(strArrMessage) Then Exit Do

	'検索条件を満たすレコード件数を取得
	lngAllCount = objDemand.SelectDmdBurdenList("CNT", strStrDate, strEndDate, strBillNo, strOrgCd1, strOrgCd2, strIsDispatch, strIsPayment, strIsCancel)

	'受診団体をパラメタ指定されている場合は、合計をブレイクをしない（っていうかできない）モード
	blnBreakMode = True
	If (strCslOrgCd1 <> "") And (strCslOrgCd2 <> "") Then
		blnBreakMode = false
	End If

	'レコード件数情報を編集
%>
<BR>
<!--ここは検索件数結果-->
<SPAN STYLE="font-size:9pt;">
「<FONT COLOR="#ff6600"><B><%= CStr(Year(strStrDate)) %>年<%= CStr(Month(strStrDate)) %>月<%= CStr(Day(strStrDate)) %>日<%= IIf(strStrDate = strEndDate, "", "～" & CStr(Year(strEndDate)) & "年" & CStr(Month(strEndDate)) & "月" & CStr(Day(strEndDate)) & "日") %></B></FONT>」の請求情報一覧を表示しています。<BR>
<FONT color="#ff6600"><B><%= CStr(lngAllCount) %></B></FONT>件の請求情報（<%= IIf( blnBreakMode = false, "取得データ件数単位", "請求書枚数単位") %>）があります。
</SPAN>
<BR><BR>
<%
	'検索結果が存在しない場合は何もしない
	If lngAllCount = 0 Then
		Exit Do
	End If

	'strStrDateとstrEndDateを、String型に変換
	strStrDate = CStr(Year(strStrDate)) & "/" & CStr(Month(strStrDate)) & "/" & CStr(Day(strStrDate))
	strEndDate = CStr(Year(strEndDate)) & "/" & CStr(Month(strEndDate)) & "/" & CStr(Day(strEndDate))

'### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加

	'検索条件を満たしかつ指定開始位置、件数分のレコードを取得
'	lngCount = objDemand.SelectDmdBurdenList("", strStrDate, strEndDate, strBillNo, strOrgCd1, strOrgCd2, strIsDispatch, strIsPayment, strIsCancel, lngStartPos, strGetCount, strSortName, strSortType, _
'	                                         lngArrBillNo, _
'	                                         strArrCloseDate, _
'	                                         strArrBillSeq, _
'	                                         strArrBranchno, _
'	                                         strArrOrgCd1, _
'	                                         strArrOrgCd2, _
'	                                         strArrOrgName, _
'	                                         strArrOrgKName, _
'	                                         lngArrMethod, _
'	                                         strArrPrtDate, _
'	                                         strArrDispatchDate, _
'	                                         strArrPaymentDate, _
'	                                         lngArrPriceTotal, _
'	                                         lngArrTaxTotal, _
'	                                         lngArrBillTotal, _
'	                                         lngArrPaymentPrice, _
'	                                         lngArrSumPaymentPrice, _
'	                                         strArrUpdUser, _
'	                                         strArrUserName, _
'	                                         lngArrSeq, _
'	                                         strArrDelFlg)

	lngCount = objDemand.SelectDmdBurdenList("", strStrDate, strEndDate, strBillNo, strOrgCd1, strOrgCd2, strIsDispatch, strIsPayment, strIsCancel, lngStartPos, strGetCount, strSortName, strSortType, _
	                                         lngArrBillNo, _
	                                         strArrCloseDate, _
	                                         strArrBillSeq, _
	                                         strArrBranchno, _
	                                         strArrOrgCd1, _
	                                         strArrOrgCd2, _
	                                         strArrOrgName, _
	                                         strArrOrgKName, _
	                                         lngArrMethod, _
	                                         strArrPrtDate, _
	                                         strArrDispatchDate, _
	                                         strArrPaymentDate, _
	                                         lngArrPriceTotal, _
	                                         lngArrTaxTotal, _
	                                         lngArrBillTotal, _
	                                         lngArrPaymentPrice, _
	                                         lngArrSumPaymentPrice, _
	                                         strArrUpdUser, _
	                                         strArrUserName, _
	                                         lngArrSeq, _
	                                         strArrDelFlg, _
											 strArrBillComment)
'### 2004/11/11 Add End

	'請求情報一覧の編集開始
%>
<!--
	<SPAN STYLE="color:#cc9999">●</SPAN>「<B>請求先名</B>」をクリックすると、請求書内容の修正画面が表示されます。<BR>
	<SPAN STYLE="color:#cc9999">●</SPAN>「<B>コース名</B>」をクリックすると、負担元別、団体別、コース別の請求明細修正画面が表示されます。<BR>
-->
	<SPAN STYLE="color:#cc9999;">●</SPAN>「<B>請求書番号</B>」をクリックすると、請求書内容の修正画面が表示されます。<BR>
	<TABLE class="mainresult" style="margin:10px 0 0 0;">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP <%= getSelectedColor("1")%>><A HREF="<%= getSortURL("1")%>">締め日</A></TD>
			<TD NOWRAP>請求書No.</TD>
			<TD NOWRAP <%= getSelectedColor("2")%>><A HREF="<%= getSortURL("2")%>">団体名</A></TD>
			<TD NOWRAP <%= getSelectedColor("3")%>><A HREF="<%= getSortURL("3")%>">団体カナ名</A></TD>
			<TD NOWRAP ALIGN="right">小計</TD>
			<TD NOWRAP ALIGN="right">消費税</TD>
			<TD NOWRAP ALIGN="right">請求金額</TD>
			<TD NOWRAP ALIGN="right">未収額</TD>
			<TD NOWRAP <%= getSelectedColor("4")%>><A HREF="<%= getSortURL("4")%>">入金日</A></TD>
			<TD NOWRAP ALIGN="right">入金額</TD>
			<TD NOWRAP>処理担当</TD>
			<TD NOWRAP>処理</TD>
			<TD NOWRAP>請求書発送日</TD>
<!-- ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加 -->
			<TD NOWRAP>請求書コメント</TD>
<!-- ### 2004/11/11 Add End -->
		</TR>
<%
	'明細の数だけループする
	For i = 0 To lngCount - 1
		'表示用に編集
		strDispCloseDate = strArrCloseDate(i)
		strDispBillNo = lngArrBillNo(i)
		strDispOrgName = strArrOrgName(i)
		strDispOrgKName = strArrOrgKName(i)

		'小計
		if lngArrPriceTotal(i) <> "" Then
			strDispPriceTotal = FormatCurrency(lngArrPriceTotal(i))
		Else
			strDispPriceTotal = ""
		End If

		'税額
		if lngArrTaxTotal(i) <> "" Then
			strDispTaxTotal = FormatCurrency(lngArrTaxTotal(i))
		Else
			strDispTaxTotal = ""
		End If

		'請求金額
		If lngArrBillTotal(i) <> "" Then
			strDispBillTotal = FormatCurrency(lngArrBillTotal(i))
		Else
			strDispBillTotal = ""
		End If

		'未収額
		If lngArrBillTotal(i) <> "" Then
			If lngArrSumPaymentPrice(i) <> "" Then
				strDispNoPaymentPrice = FormatCurrency(lngArrBillTotal(i) - lngArrSumPaymentPrice(i))
			Else
				strDispNoPaymentPrice = FormatCurrency(lngArrBillTotal(i))
			End If
		Else
			If lngArrSumPaymentPrice(i) <> "" Then
				strDispNoPaymentPrice = FormatCurrency(lngArrSumPaymentPrice(i) * -1)
			Else
				strDispNoPaymentPrice = ""
			End If
		End If

		If lngArrPaymentPrice(i) <> "" Then
			strDispPaymentPrice = FormatCurrency(lngArrPaymentPrice(i))
		Else
			strDispPaymentPrice = ""
		End If

'## 2004.06.02 ADD STR ORB)T.YAGUCHI ２次検査の合計金額追加追加
		lngSumRecord = objDemand.SelectSumDetailItems(strDispBillNo,, _
								strSumPrice, _
								strSumEditPrice, _
								strSumTaxPrice, _
								strSumEditTax, _
								strSumPriceTotal)
		'２次検査合計金額の追加
		If lngSumRecord > 0 Then
			strDispPriceTotal = CDbl(strDispPriceTotal) + strSumPrice(0) + strSumEditPrice(0)
			strDispTaxTotal = CDbl(strDispTaxTotal) + strSumTaxPrice(0) + strSumEditTax(0)
			strDispBillTotal = CDbl(strDispBillTotal) + strSumPriceTotal(0)
			strDispNoPaymentPrice = CDbl(strDispNoPaymentPrice) + strSumPriceTotal(0)
			strDispPriceTotal = FormatCurrency(strDispPriceTotal)
			strDispTaxTotal = FormatCurrency(strDispTaxTotal)
			strDispBillTotal = FormatCurrency(strDispBillTotal)
			strDispNoPaymentPrice = FormatCurrency(strDispNoPaymentPrice)
		End If
'## 2004.06.02 ADD END

		If i = 0 Then
%>
			<TR>
				<TD HEIGHT="1" COLSPAN="28" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>
			</TR>
			<TR><TD HEIGHT=5></TD></TR>
<%
		End If
%>
			<TR <%=getCanceledColor(strArrDelFlg(i))%>>
				<TD><%= strDispCloseDate%></TD>
				<TD><A HREF="" onClick="return callDmdBurdenModify('<%= strDispBillNo%>');"><%= strDispBillNo%></A></TD>
				<TD><%= strDispOrgName%></TD>
				<TD><%= strDispOrgKName%></TD>
				<TD NOWRAP ALIGN="right"><%= strDispPriceTotal%></TD>
				<TD NOWRAP ALIGN="right"><%= strDispTaxTotal%></TD>
				<TD NOWRAP ALIGN="right"><B><%= strDispBillTotal%></B></TD>
				<TD NOWRAP ALIGN="right"><FONT COLOR="<%=getNopaymentColor(strDispNoPaymentPrice)%>"><B><%= strDispNoPaymentPrice%></B></FONT></TD>
				<TD><%= strArrPaymentDate(i)%></TD>
				<TD NOWRAP ALIGN="right"><%= strDispPaymentPrice%></TD>
				<TD><%= strArrUserName(i)%></TD>
				<TD NOWRAP>
<!--					<A HREF="" onClick="return callDmdPayment('add','<%= lngArrBillNo(i)%>','');">追加</A>　-->
					<A HREF="" onClick="return callDmdPayment('update','<%= lngArrBillNo(i)%>','<%= lngArrSeq(i)%>');">入金</A>
				</TD>
				<TD><%= strArrDispatchDate(i)%></TD>
<!-- ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加 -->
				<TD NOWRAP><%= strArrBillComment(i)%></TD>
<!-- ### 2004/11/11 Add End -->
			</TR>

			<TR><TD HEIGHT=5></TD></TR>
			<TR>
				<TD HEIGHT="1" COLSPAN="28" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
			</TR>
			<TR><TD HEIGHT=5></TD></TR>
<%
			'ブレイク時のキーセット、及び編集集計領域の初期化
'			strKeyBillNo         = lngArrBillNo(i)
'			strDispCloseDate     = strArrCloseDate(i)
'			strDispOrgName       = strArrOrgName(i)
'			strDispBillClassName = strArrBillClassName(i)
'			strKeyCslOrgCd1 = ""
'			strKeyCslOrgCd2 = ""
'			lngBillSubTotal = 0
'			lngBillTax      = 0
'			lngBillDiscount = 0
'			lngBillTotal    = 0

'		End If

'		strDispCslOrgName = strArrCslOrgName(i)

		'ブレイクモードでないなら明細名称を全て表示する
		If blnBreakMode = false Then
			strDispCloseDate     = strArrCloseDate(i)
			strDispOrgName       = lngArrBillNo(i) & ":" & strArrOrgName(i)
			strDispBillClassName = strArrBillClassName(i)
		End If

		'前行と依頼団体が同じなら、依頼団体名称をクリア
'		If ( strKeyCslOrgCd1 = strArrCslOrgCd1(i) ) AND ( strKeyCslOrgCd2 = strArrCslOrgCd2(i)) and ( blnBreakMode = True ) Then
'			strDispCslOrgName = ""
'		Else
'			strKeyCslOrgCd1 = strArrCslOrgCd1(i)
'			strKeyCslOrgCd2 = strArrCslOrgCd2(i)
'		End If

		'NULL金額情報の編集
'		If strArrCsSubTotal(i) = "" Then strArrCsSubTotal(i) = 0
'		If strArrCsTax(i)      = "" Then strArrCsTax(i)      = 0
'		If strArrCsDiscount(i) = "" Then strArrCsDiscount(i) = 0
'		If strArrCsTotal(i)    = "" Then strArrCsTotal(i)    = 0

'		strDispCsSubTotal = ""
'		strDispCsTax = ""
'		strDispCsTotal = ""

'		If strArrCsSeq(i) <> "" Then
'			strDispCsSubTotal = FormatCurrency(strArrCsSubTotal(i))
'			strDispCsTax      = FormatCurrency(strArrCsTax(i))
'			strDispCsTotal    = FormatCurrency(strArrCsTotal(i))
'			strDispDiscount   = Iif(Clng(strArrCsDiscount(i)) = 0, "", FormatCurrency(strArrCsDiscount(i)))
'		End If

		'コース名称関連設定
'		strDispCsMark = "■"
'		strDispCsMarkColor = strArrWebColor(i)
'		strDispCsName = strArrCsName(i)
		
		'コースSEQがない場合、名称関連をクリア
'		If strArrCsSeq(i) = "" Then
'			strDispCsMark = ""
'			strDispCsMarkColor = "FFFFFF"
'			strDispCsName = ""
'		End If
		
		'コース未指定の場合、名称設定変更
'		If strArrCsSeq(i) <> "" And strDispCsName = "" Then
'			strDispCsMark = "□"
'			strDispCsMarkColor = "999999"
'			strDispCsName = "コース指定なし"
'		End If


		'合計金額用の編集
'		If blnBreakMode = True Then
'			lngBillSubTotal = lngBillSubTotal + strArrCsSubTotal(i)
'			lngBillTax      = lngBillTax      + strArrCsTax(i)
'			lngBillDiscount = lngBillDiscount + strArrCsDiscount(i)
'			lngBillTotal    = lngBillTotal    + strArrCsTotal(i)
'			strDispCloseDate     = ""
'			strDispOrgName       = ""
'			strDispBillClassName = ""
'		End If

	Next
%>
	</TABLE>
	<BR>
<%
		'ページングナビゲータの編集
		If IsNumeric(strGetCount) Then
			lngGetCount = CLng(strGetCount)
%>
			<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?action=search&strYear=" & CStr(lngStrYear) & "&strMonth=" & CStr(lngStrMonth) & "&strDay=" & CStr(lngStrDay) & "&endYear=" & CStr(lngEndYear) & "&endMonth=" & CStr(lngEndMonth) & "&endDay=" & CStr(lngEndDay) & "&orgCd1=" & Server.URLEncode(strOrgCd1) & "&orgCd2=" & Server.URLEncode(strOrgCd2) & "&billNo=" & strBillNo & "&IsDispatch=" & strIsDispatch & "&IsPayment=" & strIsPayment & "&IsCancel=" & strIsCancel & "&SortName=" & strSortName & "&SortType=" & strSortType, lngAllCount, lngStartPos, lngGetCount) %>
<%
		End If
		Exit Do
	Loop

	'請求アクセス用COMオブジェクトの解放
	Set objDemand = Nothing
	Set objCommon = Nothing

%>
</div>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
