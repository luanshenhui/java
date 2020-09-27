<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   変更履歴（ヘッダ） (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objHainsUser		'ユーザ情報アクセス用
Dim objInterView		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strAct				'処理状態
Dim lngRsvNo			'予約番号
Dim strFromDate			'更新日（開始）
Dim strFromYear			'更新日　年（開始）
Dim strFromMonth		'更新日　月（開始）
Dim strFromDay			'更新日　日（開始）
Dim strToDate			'更新日（開始）
Dim strToYear			'更新日　年（開始）
Dim strToMonth			'更新日　月（開始）
Dim strToDay			'更新日　日（開始）
Dim lngStartPos			'表示開始位置

Dim strClass			'分類
Dim strArrClass()		'分類コードの配列
Dim strArrClassName()	'分類名称の配列

Dim strUpdUser				'更新ユーザ
Dim strUpdUsername			'更新ユーザ名

Dim strOrderByItem			'並べ替え項目
Dim strArrOrderByItem() 	'並べ替え項目の配列
Dim strArrOrderByItemName()	'並べ替え項目名の配列

Dim strOrderBy				'並べ替え（0:昇順1:降順）
Dim strArrOrderBy()			'並べ替えの配列
Dim strArrOrderByName()		'並べ替え名の配列

Dim lngPageMaxLine			'１ページ表示ＭＡＸ行
Dim lngArrPageMaxLine()		'１ページ表示ＭＡＸ行の配列
Dim strArrPageMaxLineName()	'１ページ表示ＭＡＸ行名の配列


Dim lngCount				'ＭＡＸ件数

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo            = Request("rssvno")
strFromYear         = Request("fromyear")
strFromMonth        = Request("frommonth")
strFromDay          = Request("fromday")
strToYear           = Request("toyear")
strToMonth          = Request("tomonth")
strToDay            = Request("today")
strUpdUser          = Request("upduser")
strClass            = Request("updclass")
strOrderByItem      = Request("orderbyItem")
strOrderBy          = Request("orderbyMode")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

'日付未指定の場合、システム年月日を適用する
If strFromYear = "" Then
	strFromYear  = CStr(Year(Now))
	strFromMonth = CStr(Month(Now))
	strFromDay   = CStr(Day(Now))
End If
If strToYear = "" Then
	strToYear  = CStr(Year(Now))
	strToMonth = CStr(Month(Now))
	strToDay   = CStr(Day(Now))
End If

'分類未指定時はすべて
If strClass = "" Then
	strClass = 0
End If

'並べ替え項目未指定時は更新日
If strOrderByItem = "" Then
	strOrderByItem = "0"
End If

'並べ替え方法未指定時は昇順
If strOrderBy = "" Then
	strOrderBy = "0" 
End If

If strUpdUser <> "" Then
	objHainsUser.SelectHainsUser strUpdUser, strUpdUserName
End If


lngCount = CLng(IIf( lngCount="", 0, lngCount))


Call CreateClassInfo()

Call CreateOrderByItemInfo()

Call CreateOrderByInfo()

Call CreatePageMaxLineInfo()


Do	

Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : 分類名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateClassInfo()


	Redim Preserve strArrClass(4)
	Redim Preserve strArrClassName(4)

	strArrClass(0) = "0":strArrClassName(0) = "すべて"
	strArrClass(1) = "1":strArrClassName(1) = "健診結果"
	strArrClass(2) = "2":strArrClassName(2) = "判定"
	strArrClass(3) = "3":strArrClassName(3) = "コメント"
	strArrClass(4) = "4":strArrClassName(4) = "個人検査結果"

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 並び替え項目名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateOrderByItemInfo()


	Redim Preserve strArrOrderByItem(2)
	Redim Preserve strArrOrderByItemName(2)

	strArrOrderByItem(0) = "0":strArrOrderByItemName(0) = "更新日"
	strArrOrderByItem(1) = "1":strArrOrderByItemName(1) = "更新者"
	strArrOrderByItem(2) = "2":strArrOrderByItemName(2) = "分類、項目"

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 並び替え名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateOrderByInfo()


	Redim Preserve strArrOrderBy(1)
	Redim Preserve strArrOrderByName(1)

	strArrOrderBy(0) = "0":strArrOrderByName(0) = "昇順"
	strArrOrderBy(1) = "1":strArrOrderByName(1) = "降順"

End Sub

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


	Redim Preserve lngArrPageMaxLine(4)
	Redim Preserve strArrPageMaxLineName(4)

	lngArrPageMaxLine(0) = 50:strArrPageMaxLineName(0) = "50行ずつ"
	lngArrPageMaxLine(1) = 100:strArrPageMaxLineName(1) = "100行ずつ"
	lngArrPageMaxLine(2) = 200:strArrPageMaxLineName(2) = "200行ずつ"
	lngArrPageMaxLine(3) = 300:strArrPageMaxLineName(3) = "300行ずつ"
	lngArrPageMaxLine(4) = 0:strArrPageMaxLineName(4) = "すべて"
'	lngArrPageMaxLine(0) = 2:strArrPageMaxLineName(0) = "2行ずつ"
'	lngArrPageMaxLine(1) = 3:strArrPageMaxLineName(1) = "3行ずつ"
'	lngArrPageMaxLine(2) = 5:strArrPageMaxLineName(2) = "5行ずつ"
'	lngArrPageMaxLine(3) = 10:strArrPageMaxLineName(3) = "10行ずつ"
'	lngArrPageMaxLine(4) = 0:strArrPageMaxLineName(4) = "すべて"

End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<TITLE>変更履歴</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->
// usrGuid.inc　から呼び出されるgdeDoctor.asp　が使えないので変更 2004.01.13
// -- #include virtual = "/webHains/includes/usrGuide.inc" --
//表示
function callUpdateHistoryTop() {

	var myForm;


	myForm = document.entryForm;


	// Topに引数を指定してsubmit
	parent.params.fromDate    = myForm.fromyear.value + '/' + myForm.frommonth.value + '/' + myForm.fromday.value;
	parent.params.fromyear    = myForm.fromyear.value;
	parent.params.frommonth   = myForm.frommonth.value;
	parent.params.fromday     = myForm.fromday.value;
	parent.params.toDate      = myForm.toyear.value + '/' + myForm.tomonth.value + '/' + myForm.today.value;
	parent.params.toyear      = myForm.toyear.value;
	parent.params.tomonth     = myForm.tomonth.value;
	parent.params.today       = myForm.today.value;
	parent.params.upduser     = myForm.upduser.value;
	parent.params.updclass    = myForm.updclass.value;
	parent.params.orderbyItem = myForm.orderbyItem.value;
	parent.params.orderbyMode = myForm.orderbyMode.value;
	parent.params.startPos    = myForm.startPos.value;
	parent.params.pageMaxLine = myForm.pageMaxLine.value;
	parent.params.action      = "search";
    common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);

}

// ユーザーガイド呼び出し
function callGuideUsr() {

	usrGuide_CalledFunction = SetUpdUser;

	// ユーザーガイド表示
	showGuideUsr( );

}

// ユーザーセット
function SetUpdUser() {

	document.entryForm.upduser.value = usrGuide_UserCd;
	document.entryForm.updusername.value = usrGuide_UserName;

	document.getElementById('username').innerHTML = usrGuide_UserName;

}

// ユーザー指定クリア
function clearUpdUser() {

	document.entryForm.upduser.value = '';
	document.entryForm.updusername.value = '';

	document.getElementById('username').innerHTML = '';

}


var winGuideCalendar;			// ウィンドウハンドル
// 日付ガイド呼び出し
function callCalGuide(year, month, day) {


	// 日付ガイド表示
	calGuide_showGuideCalendar( year, month, day);

}

function windowClose() {

	// 日付ガイドウインドウを閉じる
	calGuide_closeGuideCalendar();

	// ユーザーガイドウインドウを閉じる
	closeGuideDoc();
	winGuideUsr = null;
}

//-->
</SCRIPT>
<script type="text/javascript" src="/webHains/js/common.js"></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="fromDate" VALUE="<%= strFromDate %>">
	<INPUT TYPE="hidden" NAME="toDate" VALUE="<%= strToDate %>">
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= lngStartPos %>">

	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">変更履歴</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD HEIGHT="5"></TD>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>更新日</TD>
			<TD NOWRAP>：</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
					<TR>
						<TD><A HREF="javascript:callCalGuide('fromyear', 'frommonth', 'fromday')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示" border="0"></A></TD>
						<TD><%= EditSelectNumberList("fromyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strFromYear)) %></TD>
						<TD>年</TD>
						<TD><%= EditSelectNumberList("frommonth", 1, 12, CLng("0" & strFromMonth)) %></TD>
						<TD>月</TD>
						<TD><%= EditSelectNumberList("fromday",   1, 31, CLng("0" & strFromDay  )) %></TD>
						<TD>日～</TD>
						<TD><A HREF="javascript:callCalGuide('toyear', 'tomonth', 'today')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示" border="0"></A></TD>
						<TD><%= EditSelectNumberList("toyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strToYear)) %></TD>
						<TD>年</TD>
						<TD><%= EditSelectNumberList("tomonth", 1, 12, CLng("0" & strToMonth)) %></TD>
						<TD>月</TD>
						<TD><%= EditSelectNumberList("today",   1, 31, CLng("0" & strToDay  )) %></TD>
						<TD>日</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>　分類</TD>
			<TD NOWRAP>：</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
					<INPUT TYPE="hidden" NAME="upduser" VALUE="<%= strUpdUser %>">
					<INPUT TYPE="hidden" NAME="updusername" VALUE="<%= strUpdUserName %>">
					<TR>
						<TD><%= EditDropDownListFromArray("updclass", strArrClass, strArrClassName, strClass, NON_SELECTED_DEL) %></TD>
						<TD NOWRAP><INPUT TYPE="image" SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="15"></TD>
						<TD NOWRAP>更新ユーザ：</TD>
						<TD NOWRAP><A HREF="javascript:callGuideUsr()"><IMG SRC="/webHains/images/question.gif" ALT="ユーザガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
						<TD NOWRAP><A HREF="javascript:clearUpdUser()"><IMG SRC="/webHains/images/delicon.gif" ALT="ユーザ指定削除" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
						<TD NOWRAP><SPAN ID="username"><%= strUpdUserName %></SPAN></TD>
						<TD NOWRAP>　表示：</TD>
						<TD><%= EditDropDownListFromArray("orderbyItem", strArrOrderByItem, strArrOrderByItemName, strOrderByItem, NON_SELECTED_DEL) %></TD>
						<TD>の</TD>
						<TD><%= EditDropDownListFromArray("orderbyMode", strArrOrderBy, strArrOrderByName, strOrderBy, NON_SELECTED_DEL) %></TD>
						<TD>に</TD>
						<TD><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %></TD>
						<TD><A HREF="JavaScript:callUpdateHistoryTop()"><IMG SRC="/webHains/images/b_prev.gif" ALT="表示" HEIGHT="28" WIDTH="53"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
</FORM>
</BODY>
</HTML>
