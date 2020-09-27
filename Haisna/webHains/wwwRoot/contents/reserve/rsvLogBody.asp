<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   変更履歴（ヘッダ） (Ver0.0.1)
'	   AUTHER  : Tsutomy Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const STARTPOS  = 1		'開始位置のデフォルト値
Const GETCOUNT  = 50	'表示件数のデフォルト値

'データベースアクセス用オブジェクト
Dim objConsult			'受診情報アクセス用

'パラメータ値
Dim lngStrYear			'更新日(自)(年)
Dim lngStrMonth			'更新日(自)(月)
Dim lngStrDay			'更新日(自)(日)
Dim lngEndYear			'更新日(至)(年)
Dim lngEndMonth			'更新日(至)(月)
Dim lngEndDay			'更新日(至)(日)
Dim strRsvNo			'予約番号
Dim strUpdUser			'更新者
Dim lngOrderbyItem		'並べ替え項目(0:更新日,1:更新者,2:予約番号）
Dim lngOrderbyMode		'並べ替え方法(0:昇順,1:降順)
Dim lngStartPos			'検索開始位置
'## 2004.10.27 Add By T.Takagi@FSIT 更新履歴への遷移追加
Dim lngMargin			'TOPMARGIN
'## 2004.10.27 Add End
Dim lngGetCount			'表示件数

Dim strArrRsvNo			'予約番号
Dim strArrSeq			'ＳＥＱ
Dim strArrUpdDate		'更新日
Dim strArrUpdUser		'ユーザＩＤ
Dim strArrUserName		'ユーザ名
Dim strArrCslInfo		'予約更新情報

Dim strUpdClassName			'更新分類名称
Dim strItemName				'項目名称
Dim strUpdDivName			'処理区分名称

Dim lngCount				'全件数

Dim strURL					'ジャンプ先のURL

Dim i						'ループカウンタ

Dim dtmStrDate			'更新日(自)
Dim dtmEndDate			'更新日(至)
Dim strMessage			'エラーメッセージ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
lngStrYear     = CLng("0" & Request("strYear"))
lngStrMonth    = CLng("0" & Request("strMonth"))
lngStrDay      = CLng("0" & Request("strDay"))
lngEndYear     = CLng("0" & Request("endYear"))
lngEndMonth    = CLng("0" & Request("endMonth"))
lngEndDay      = CLng("0" & Request("endDay"))
strRsvNo       = Request("rsvNo")
strUpdUser     = Request("updUser")
lngOrderByItem = CLng("0" & Request("orderByItem"))
lngOrderByMode = CLng("0" & Request("orderByMode"))
lngStartPos    = Request("startPos")
lngGetCount    = Request("getCount")
'## 2004.10.27 Add By T.Takagi@FSIT 更新履歴への遷移追加
lngMargin      = CLng("0" & Request("margin"))
'## 2004.10.27 Add End

'引数省略時のデフォルト値設定
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))

Do

	'更新日(自)の日付チェック
	If lngStrYear <> 0 Or lngStrMonth <> 0 Or lngStrDay <> 0 Then
		If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Then
			strMessage = "更新日の指定に誤りがあります。"
			Exit Do
		End If
	End If

	'更新日(至)の日付チェック
	If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
		If Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
			strMessage = "更新日の指定に誤りがあります。"
			Exit Do
		End If
	End If

	'予約番号の数値チェック
	If strRsvNo <> "" Then
		For i = 1 To Len(strRsvNo)
			If InStr("0123456789", Mid(strRsvNo, i, 1)) <= 0 Then
				strMessage = "予約番号の指定に誤りがあります。"
				Exit Do
			End If
		Next
	End If

	'更新日の編集
	If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
		dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
	End If

	If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
		dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
	End If

	'受診情報ログの読み込み
	Set objConsult = Server.CreateObject("HainsConsult.Consult")
	lngCount = objConsult.SelectConsultLogList(dtmStrDate, dtmEndDate, CLng("0" & strRsvNo), strUpdUser, lngOrderByItem, lngOrderByMode, lngStartPos, lngGetCount, strArrRsvNo, strArrSeq, strArrUpdDate, strArrUpdUser, strArrUserName, strArrCslInfo)
	Set objConsult = Nothing

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>変更履歴</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winConsultLog;		// ウィンドウハンドル

// 予約更新情報の表示
function showCslLog( rsvNo, seq ) {

	var url = 'rsvConsultLog.asp';	// 予約更新情報画面のURL

	var opened = false;	// 画面が開かれているか

	// すでにガイドが開かれているかチェック
	if ( winConsultLog ) {
		if ( !winConsultLog.closed ) {
			opened = true;
		}
	}

	// 比較のためwindowはクリックのたびに新規で開く
	url = url + '?rsvNo=' + rsvNo + '&seq=' + seq;
	winConsultLog = window.open( url, '', 'width=600,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: <%= lngMargin %>px 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
Do
	'メッセージが発生している場合は編集して処理終了
	If strMessage <> "" Then
		Response.Write strMessage
		Exit Do
	End If

	If lngCount <= 0 Then
%>
		検索条件を満たす履歴は存在しませんでした。
<%
		Exit Do
	End If
%>
	検索結果は <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>件ありました。<BR><BR>

	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="#cccccc">
			<TD NOWRAP>更新日時</TD>
			<TD NOWRAP>更新者</TD>
			<TD NOWRAP>予約番号</TD>
		</TR>
<%
		For i = 0 To UBound(strArrRsvNo)
%>
			<TR BGCOLOR="#eeeeee">
				<TD NOWRAP><A HREF="javascript:showCslLog(<%= strArrRsvNo(i) %>,<%= strArrSeq(i) %>)"><%= strArrUpdDate(i) %></A></TD>
				<TD NOWRAP><%= strArrUserName(i) %></TD>
				<TD NOWRAP><%= strArrRsvNo(i)    %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'全件検索時はページングナビゲータ不要
    If lngGetCount = 0 Then
		Exit Do
	End If

	'URLの編集
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?strYear="     & lngStrYear
	strURL = strURL & "&strMonth="    & lngStrMonth
	strURL = strURL & "&strDay="      & lngStrDay
	strURL = strURL & "&endYear="     & lngEndYear
	strURL = strURL & "&endMonth="    & lngEndMonth
	strURL = strURL & "&endDay="      & lngEndDay
	strURL = strURL & "&rsvNo="       & strRsvNo
	strURL = strURL & "&updUser="     & strUpdUser
	strURL = strURL & "&orderByItem=" & lngOrderByItem
	strURL = strURL & "&orderByMode=" & lngOrderByMode

	'ページングナビゲータの編集
%>
	<%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
	Exit Do
Loop
%>
</BODY>
</HTML>