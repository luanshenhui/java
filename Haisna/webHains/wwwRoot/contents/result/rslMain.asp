<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   結果入力 (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const ACTMODE_SAVEEND  = "saveend"	'動作モード(保存完了)

'前画面から送信されるパラメータ値
Dim strActMode		'動作モード
Dim strDispMode		'表示状態(文章表示時:"1"、文章非表示時:"2")
Dim strRsvNo		'予約番号
Dim strMode			'入力対象モード
Dim strCode			'入力対象コード
Dim lngCslYear		'受診日(年)
Dim lngCslMonth		'受診日(月)
Dim lngCslDay		'受診日(日)
Dim strCsCd			'コース
Dim strSortKey		'表示順
Dim strCntlNo		'管理番号
Dim strDayId		'当日ID
Dim strNoPrevNext	'前後受診者への遷移を行わない
Dim strEcho			'有所見者は自動で超音波検査表を出力する場合に"1"

Dim strURL			'URL文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strActMode    = Request("actMode")
strDispMode   = Request("dispMode")
strRsvNo      = Request("rsvNo")
strMode       = Request("mode")
strCode       = Request("code")
lngCslYear    = CLng("0" & Request("cslYear") )
lngCslMonth   = CLng("0" & Request("cslMonth"))
lngCslDay     = CLng("0" & Request("cslDay")  )
strCsCd       = Request("csCd")
strSortKey    = Request("sortKey")
strCntlNo     = Request("cntlNo")
strDayId      = Request("dayId")
strNoPrevNext = Request("noPrevNext")
strEcho       = Request("echo")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>結果入力</TITLE>
</HEAD>
<%
'前次受診者遷移モードの場合はフレーム割りを行う
If strNoPrevNext = "" Then
%>
	<FRAMESET ROWS="30,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
		<FRAME SRC="rslNavibar.asp" name="header">
		<FRAMESET COLS="300,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
<%
			'受診者一覧URLの編集
			strURL = "rslDailyList.asp"
			strURL = strURL & "?actMode="  & strActMode
			strURL = strURL & "&cslYear="  & lngCslYear
			strURL = strURL & "&cslMonth=" & lngCslMonth
			strURL = strURL & "&cslDay="   & lngCslDay
			strURL = strURL & "&csCd="     & strCsCd
			strURL = strURL & "&sortKey="  & strSortKey
			strURL = strURL & "&cntlNo="   & strCntlNo
%>
			<FRAME SRC="<%= strURL %>" name="list">
<%
			strURL = ""

			'保存完了時のみ、結果入力フレームの初期表示を行う
			If strActMode = ACTMODE_SAVEEND Then

				'結果入力URLの編集
				strURL = "rslDetail.asp"
				strURL = strURL & "?actMode="  & strActMode
				strURL = strURL & "&dispMode=" & strDispMode
				strURL = strURL & "&rsvNo="    & strRsvNo
				strURL = strURL & "&mode="     & strMode
				strURL = strURL & "&code="     & strCode
				strURL = strURL & "&cslYear="  & lngCslYear
				strURL = strURL & "&cslMonth=" & lngCslMonth
				strURL = strURL & "&cslDay="   & lngCslDay
				strURL = strURL & "&csCd="     & strCsCd
				strURL = strURL & "&sortKey="  & strSortKey
				strURL = strURL & "&cntlNo="   & strCntlNo
				strURL = strURL & "&dayId="    & strDayId
				strURL = strURL & "&echo="     & strEcho

			End If
%>
			<FRAME SRC="<%= strURL %>" name="result">
		</FRAMESET>
	</FRAMESET>
<%
'前次受診者非遷移モードの場合はフレーム割りを行わない
'(実際は履歴制御のため、画面全体を１つの子フレームで占める)
Else
%>
	<FRAMESET BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
<%
		'結果入力URLの編集
		strURL = "rslDetail.asp"
		strURL = strURL & "?actMode="    & strActMode
		strURL = strURL & "&dispMode="   & strDispMode
		strURL = strURL & "&rsvNo="      & strRsvNo
		strURL = strURL & "&mode="       & strMode
		strURL = strURL & "&code="       & strCode
		strURL = strURL & "&cslYear="    & lngCslYear
		strURL = strURL & "&cslMonth="   & lngCslMonth
		strURL = strURL & "&cslDay="     & lngCslDay
		strURL = strURL & "&cntlNo="     & strCntlNo
		strURL = strURL & "&dayId="      & strDayId
		strURL = strURL & "&noPrevNext=" & strNoPrevNext
		strURL = strURL & "&echo="       & strEcho
%>
		<FRAME SRC="<%= strURL %>" name="result">
	</FRAMESET>
<%
End If
%>
</HTML>
