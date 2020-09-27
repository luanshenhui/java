<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   結果入力２【グループ指定版】 (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
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
Dim strCode			'入力対象コード
Dim lngCslYear		'受診日(年)
Dim lngCslMonth		'受診日(月)
Dim lngCslDay		'受診日(日)
Dim strCsCd			'コース
Dim strCntlNo		'管理番号
Dim strDayId		'当日ID
Dim strURL			'URL文字列

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
strActMode    = Request("actMode")
strDispMode   = Request("dispMode")
strRsvNo      = Request("rsvNo")
strCode       = Request("code")
lngCslYear    = CLng("0" & Request("cslYear") )
lngCslMonth   = CLng("0" & Request("cslMonth"))
lngCslDay     = CLng("0" & Request("cslDay")  )
strCsCd       = Request("csCd")
strCntlNo     = Request("cntlNo")
strDayId      = Request("dayId")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>結果入力</TITLE>
</HEAD>
	<FRAMESET BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
<%
		'結果入力URLの編集
		strURL = "rslDetail2.asp"
		strURL = strURL & "?actMode="    & strActMode
		strURL = strURL & "&dispMode="   & strDispMode
		strURL = strURL & "&rsvNo="      & strRsvNo
		strURL = strURL & "&code="       & strCode
		strURL = strURL & "&cslYear="    & lngCslYear
		strURL = strURL & "&cslMonth="   & lngCslMonth
		strURL = strURL & "&cslDay="     & lngCslDay
		strURL = strURL & "&cntlNo="     & strCntlNo
		strURL = strURL & "&dayId="      & strDayId
'## 2004.02.12 Add By H.Ishihara@FSIT 未受付状態でも結果入力できるモード追加（希望医師入力）
		strURL = strURL & "&NoReceipt="  & Request("noReceipt")
'## 2004.02.12 Add End
%>
		<FRAME SRC="<%= strURL %>" name="result">
	</FRAMESET>
</HTML>
