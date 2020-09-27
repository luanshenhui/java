<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   予約枠の検索 (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objSchedule			'予約情報アクセス用
Dim objCourse			'コース情報アクセス用

Dim strMode				'処理モード(挿入:"insert"、更新:"update")
Dim strAction			'処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")


Dim strStartCslDate     	'検索条件受診年月日（開始）
Dim strStartYear     		'検索条件受診年（開始）
Dim strStartMonth     		'検索条件受診月（開始）
Dim strStartDay     		'検索条件受診日（開始）
Dim strEndCslDate     		'検索条件受診年月日（終了）
Dim strEndYear     			'検索条件受診年（終了）
Dim strEndMonth     		'検索条件受診月（終了）
Dim strEndDay     			'検索条件受診日（終了）
Dim strSearchCsCd	    	'検索条件コースコード
Dim lngSearchRsvGrpCd    	'検索条件予約群コード

Dim vntCslDate          	'受診日
Dim vntCsCd		          	'コースコード
Dim vntCsName           	'コース名
Dim vntWebColor           	'コース色
Dim vntRsvGrpCd         	'予約群コード
Dim vntRsvGrpName         	'予約群名称
Dim vntMngGender			'男女別枠管理
Dim vntMaxCnt				'予約可能人数（共通）
Dim vntMaxCnt_M	    	   	'予約可能人数（男）
Dim vntMaxCnt_F	       		'予約可能人数（女）
Dim vntOverCnt		       	'オーバ可能人数（共通）
Dim vntOverCnt_M	       	'オーバ可能人数（男）
Dim vntOverCnt_F	       	'オーバ可能人数（女）
Dim vntRsvCnt_M	       		'予約済み人数（男）
Dim vntRsvCnt_F		        '予約済み人数（女）

Dim lngRsvFraCnt				'予約枠数

Dim strArrMessage		'エラーメッセージ

Dim i				'カウンタ

Dim Ret				'関数戻り値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objSchedule     = Server.CreateObject("HainsSchedule.Schedule")
'## 2004.03.12 Del By T.Takagi@FSIT コース出力条件変更
'Set objCourse       = Server.CreateObject("HainsCourse.Course")
'## 2004.03.12 Del End

'引数値の取得
strMode           = Request("mode")
strAction         = Request("action")
strStartYear      = Request("startYear")
strStartMonth     = Request("startMonth")
strStartDay       = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strSearchCsCd     = Request("searchCsCd")
lngSearchRsvGrpCd   = Request("searchRsvGrp")

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


Do

	'検索開始
	If strAction = "search" Then
		objCommon.AppendArray strArrMessage, objCommon.CheckDate("開始受診日", strStartYear, strStartMonth, strStartDay, strStartCslDate, CHECK_NECESSARY)
		objCommon.AppendArray strArrMessage, objCommon.CheckDate("終了受診日", strEndYear, strEndMonth, strEndDay, strEndCslDate, CHECK_NECESSARY)

		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'検索開始受診日の編集
		strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
		'検索終了受診日の編集
		strEndCslDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)


		'検索条件に従い予約人数管理一覧を抽出する
		lngRsvFraCnt = objSchedule.SelectRsvFraMngList( _
                    strStartCslDate, strEndCslDate, _
                    strSearchCsCd & "", _
                    lngSearchRsvGrpCd & "", _
                    vntCslDate, _
                    vntCsCd, _
                    vntCsName, _
                    vntWebColor, _
                    vntRsvGrpCd, _
                    vntRsvGrpName, _
                    vntMngGender, _
                    vntMaxCnt, _
                    vntMaxCnt_M, _
                    vntMaxCnt_F, _
                    vntOverCnt, _
                    vntOverCnt_M, _
                    vntOverCnt_F, _
                    vntRsvCnt_M, _
                    vntRsvCnt_F _
                    )
	End If


	Exit Do
Loop


'-------------------------------------------------------------------------------
'
' 機能　　 : コースコードのドロップダウンリスト編集
'
' 引数　　 :
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CsCdList()

	Dim strArrCsCdID		'コースコード
	Dim strArrCsCdName		'コース名

	Dim lngCsCsCnt			'件数

'## 2004.03.12 Mod By T.Takagi@FSIT コース出力条件変更。予約群を持つコースしか出さなくてもよい
'	lngCsCsCnt = objCourse.SelectCourseList ( strArrCsCdID, strArrCsCdName )
	lngCsCsCnt = objSchedule.SelectCourseListRsvGrpManaged ( strArrCsCdID, strArrCsCdName )
'## 2004.03.12 Mod End

	If lngCsCsCnt = 0 Then
		strArrCsCdID = Array()
		Redim Preserve strArrCsCdID(0)
		strArrCsCdName = Array()
		Redim Preserve strArrCsCdName(0)
	End If

	CsCdList = EditDropDownListFromArray("searchCsCd", strArrCsCdID, strArrCsCdName, strSearchCsCd, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 予約群のドロップダウンリスト編集
'
' 引数　　 :
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function RsvGrpList()

	Dim strArrRsvGrpID			'予約群コード
	Dim strArrRsvGrpName		'予約群名

	Dim lngRsvGrpCnt			'件数

	lngRsvGrpCnt = objSchedule.SelectRsvGrpList ( 0, strArrRsvGrpID, strArrRsvGrpName )

	If lngRsvGrpCnt = 0 Then
		strArrRsvGrpID = Array()
		Redim Preserve strArrRsvGrpID(0)
		strArrRsvGrpName = Array()
		Redim Preserve strArrRsvGrpName(0)
	End If

	RsvGrpList = EditDropDownListFromArray("searchRsvGrp", strArrRsvGrpID, strArrRsvGrpName, lngSearchRsvGrpCd, NON_SELECTED_ADD)

End Function

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>予約枠の検索</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!--
var winEditRsvFra;		// 予約枠登録・修正ウィンドウハンドル
//予約枠登録・修正ウィンドウ表示
function editRsvFraWindow( mode, cslDate, cscd, rsvGrpCd) {

	var objForm = document.entrySearch;	// 自画面のフォームエレメント

	var url;			// URL文字列
	var opened = false;	// 画面がすでに開かれているか

	// すでにガイドが開かれているかチェック
	if ( winEditRsvFra != null ) {
		if ( !winEditRsvFra.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/RsvFra/editRsvFra.asp';
	url = url + '?mode=' + mode;
	url = url + '&action=';
	url = url + '&cslDate=' + cslDate;
	url = url + '&cscd=' + cscd;
	url = url + '&rsvGrpCd=' + rsvGrpCd;


	// 開かれている場合はフォーカスを移し、さもなくば新規画面を開く
	if ( opened ) {
		winEditRsvFra.focus();
		winEditRsvFra.location.replace(url);
	} else {
		winEditRsvFra = window.open( url, '', 'width=550,height=435,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

var winGuideCal;
// 日付ガイド呼び出し
function callCalGuide(year, month, day) {


	// 日付ガイド表示
	calGuide_showGuideCalendar( year, month, day, '' );

}

// アンロード時の処理
function closeGuideWindow() {

	// 予約枠登録・修正ウィンドウウインドウを閉じる
	if ( winEditRsvFra != null ) {
		if ( !winEditRsvFra.closed ) {
			winEditRsvFra.close();
		}
	}

	winEditRsvFra = null;

	// 日付ガイドを閉じる
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entrySearch" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="action" VALUE="search">
<BLOCKQUOTE>

<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="635">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">予約枠の検索</FONT></B></TD>
	</TR>
</TABLE>

<BR>
<!-- ここは検索条件 -->
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>受診日範囲</TD>
		<TD>：</TD>
		<TD><A HREF="javascript:callCalGuide('startYear', 'startMonth', 'startDay')"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
		<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
		<TD>年</TD>
		<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
		<TD>月</TD>
		<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
		<TD NOWRAP>日～</TD>
		<TD><A HREF="javascript:callCalGuide('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
		<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
		<TD>年</TD>
		<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
		<TD>月</TD>
		<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
		<TD>日</TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="635">
	<TR>
		<TD WIDTH="90" NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="90" HEIGHT="1" ALT=""><BR>コースコード</TD>
		<TD>：</TD>
		<TD WIDTH="100%"><%= CsCdList() %></TD>
		<TD ROWSPAN="2" VALIGN="bottom"><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entrySearch.submit();return false;"><IMG SRC="../../images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></A></TD>
		
        <% If Session("PAGEGRANT") = "4" Then %>
            <TD ROWSPAN="2" VALIGN="bottom"><A HREF="JavaScript:editRsvFraWindow('insert', '', '',0 )"><IMG SRC="../../images/newrsv.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="新規に登録"></A></TD>
        <% End IF %>

	</TR>
	<TR>
		<TD>予約群</TD>
		<TD>：</TD>
		<TD><%= RsvGrpList() %></TD>
	</TR>
</TABLE>

<BR>
<!--ここは検索件数結果--><SPAN STYLE="font-size:9pt;">
「<FONT COLOR="#ff6600"><B><%= strStartYear %>年<%= strStartMonth %>月<%= strStartDay %>日～<%= strEndYear %>年<%= strEndMonth %>月<%= strEndDay %>日</B></FONT>」の予約枠一覧を表示しています。<BR>
対象予約枠は <FONT COLOR="#ff6600"><B><%= lngRsvFraCnt %></B></FONT>件です。 </SPAN><BR>
<BR>
<SPAN STYLE="color:#cc9999">●</SPAN><FONT COLOR="black">受診日をクリックすると対象の予約枠設定内容修正画面が表示されます。</FONT><BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
	<!-- ここは一覧の見出し -->
	<TR BGCOLOR="cccccc" ALIGN="center">
		<TD ROWSPAN="2" NOWRAP>受診日</TD>
		<TD ROWSPAN="2" NOWRAP>受診コース</TD>
		<TD ROWSPAN="2" NOWRAP>予約群</TD>
		<TD COLSPAN="3" NOWRAP>予約可能人数</TD>
		<TD COLSPAN="3" NOWRAP>オーバ可能人数</TD>
		<TD COLSPAN="2" NOWRAP>予約済み人数</TD>
	</TR>
	<TR BGCOLOR="#cccccc" ALIGN="center">
		<TD NOWRAP WIDTH="50">共通</TD>
		<TD NOWRAP WIDTH="50">男</TD>
		<TD NOWRAP WIDTH="50">女</TD>
		<TD NOWRAP WIDTH="50">共通</TD>
		<TD NOWRAP WIDTH="50">男</TD>
		<TD NOWRAP WIDTH="50">女</TD>
		<TD NOWRAP WIDTH="50">男</TD>
		<TD NOWRAP WIDTH="50">女</TD>
	</TR>
<%
	For i = 0 To lngRsvFraCnt - 1
		If i mod 2 = 0 Then
%>
			<TR BGCOLOR="#ffffff" ALIGN="right">
<%
		Else
%>
			<TR BGCOLOR="#eeeeee" ALIGN="right">
<%
		End If
%>
		<TD ALIGN="left" NOWRAP><A HREF="JavaScript:editRsvFraWindow('update','<%= vntCslDate(i) %>', '<%= vntCsCd(i) %>' ,<%= vntRsvGrpCd(i) %>)"><%= vntCslDate(i) %></A></TD>
<%
		If IsNull(vntWebColor(i)) = True Then
%>
			<TD ALIGN="left" NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>"> </FONT><%= vntCsName(i) %></TD>
<%
		Else
%>
			<TD ALIGN="left" NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>">■ </FONT><%= vntCsName(i) %></TD>
<%
		End If
%>
			<TD ALIGN="left" NOWRAP><%= vntRsvGrpName(i) %></TD>
			<TD NOWRAP><%= vntmaxCnt(i) %></TD>
			<TD NOWRAP><%= vntMaxCnt_M(i) %></TD>
			<TD NOWRAP><%= vntMaxCnt_F(i) %></TD>
			<TD NOWRAP><%= vntOverCnt(i) %></TD>
			<TD NOWRAP><%= vntOverCnt_M(i) %></TD>
			<TD NOWRAP><%= vntOverCnt_F(i) %></TD>
			<TD NOWRAP><%= vntRsvCnt_M(i) %></TD>
			<TD NOWRAP><%= vntRsvCnt_F(i) %></TD>
		</TR>
<%
	Next
%>
</TABLE>
<BR>
<BR>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="ffffff">.</FONT></DIV>

</BODY>
</HTML>
