<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		判定入力 (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const ACTMODE_PREVIOUS = "previous"	'動作モード(前受診者へ)
Const ACTMODE_NEXT     = "next"		'動作モード(次受診者へ)
Const ACTMODE_SAVEEND  = "saveend"	'動作モード(保存完了)

'データベースアクセス用オブジェクト
Dim objConsult		'受診情報アクセス用

'前画面から送信されるパラメータ値
Dim strActMode		'動作モード
Dim lngCslYear		'受診日(年)
Dim lngCslMonth		'受診日(月)
Dim lngCslDay		'受診日(日)
Dim strCntlNo		'管理番号
Dim lngDayId		'当日ID
Dim strCsCd			'コースコード
Dim strSortKey		'表示順
Dim strBadJud		'「判定の悪い人」
Dim strUnFinished	'「判定未完了者」
Dim strNoPrevNext	'前後受診者への遷移を行わない

'前後受診者遷移時のみ送信されるパラメータ値
Dim strRsvNo		'予約番号

Dim dtmCslDate		'受診日
Dim strPrevRsvNo	'(前受診者の)予約番号
Dim strPrevDayId	'(前受診者の)当日ID
Dim strNextRsvNo	'(次受診者の)予約番号
Dim strNextDayId	'(次受診者の)当日ID
Dim strURL			'ジャンプ先のURL

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strActMode    = Request("actMode")
lngCslYear    = CLng("0" & Request("cslYear") )
lngCslMonth   = CLng("0" & Request("cslMonth"))
lngCslDay     = CLng("0" & Request("cslDay")  )
strCntlNo     = Request("cntlNo")
lngDayId      = CLng("0" & Request("dayId"))
strCsCd       = Request("csCd")
strSortKey    = Request("sortKey")
strBadJud     = Request("badJud")
strUnFinished = Request("unFinished")
strNoPrevNext = Request("noPrevNext")

'前後受診者遷移時のみ送信されるパラメータ値の取得
strRsvNo      = Request("rsvNo")

'チェック・更新・読み込み処理の制御
Select Case strActMode

	'前受診者・次受診者へ
	Case ACTMODE_PREVIOUS, ACTMODE_NEXT

		'受診日の取得
		dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

		'前後受診者の予約番号・当日ID取得
		objConsult.SelectCurRsvNoPrevNext dtmCslDate,            _
										  strCsCd,               _
										  strSortKey,            _
										  strCntlNo,             _
										  False,                 _
										  (strBadJud     <> ""), _
										  (strUnFinished <> ""), _
										  strRsvNo,              _
										  strPrevRsvNo,          _
										  strPrevDayId,          _
										  strNextRsvNo,          _
										  strNextDayId

		'前受診者の受診情報が存在しない場合
		If strActMode = ACTMODE_PREVIOUS And strPrevRsvNo = "" Then
			Err.Raise 1000, , "前受診者の受診情報は存在しません。"
		End If

		'次受診者の受診情報が存在しない場合
		If strActMode = ACTMODE_NEXT And strNextRsvNo = "" Then
			Err.Raise 1000, , "次受診者の受診情報は存在しません。"
		End If

		'存在時はリダイレクト用のURLを編集する

		'判定入力画面のURL編集
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?cslYear="    & lngCslYear
		strURL = strURL & "&cslMonth="   & lngCslMonth
		strURL = strURL & "&cslDay="     & lngCslDay
		strURL = strURL & "&cntlNo="     & strCntlNo
		strURL = strURL & "&dayId="      & IIf(strActMode = ACTMODE_PREVIOUS, strPrevDayId, strNextDayId)
		strURL = strURL & "&csCd="       & strCsCd
		strURL = strURL & "&sortKey="    & strSortKey
		strURL = strURL & "&badJud="     & strBadJud
		strURL = strURL & "&unFinished=" & strUnFinished
		strURL = strURL & "&noPrevNext=" & strNoPrevNext

		'前後受診者の判定入力画面へ
		Response.Redirect strURL
		Response.End

End Select
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>判定入力</TITLE>
</HEAD>

<FRAMESET ROWS="55,*" BORDER="1" FRAMESPACING="0" FRAMEBORDER="YES">
	<FRAME SRC="/webHains/contents/judgement/judNavibar.asp" name="header">
	<FRAMESET COLS="*,355" BORDER="1" FRAMESPACING="0" FRAMEBORDER="yes">
<%
		'判定入力画面のURL編集
		strURL = "judDetail.asp"
		strURL = strURL & "?actMode="    & strActMode
		strURL = strURL & "&cslYear="    & lngCslYear
		strURL = strURL & "&cslMonth="   & lngCslMonth
		strURL = strURL & "&cslDay="     & lngCslDay
		strURL = strURL & "&cntlNo="     & strCntlNo
		strURL = strURL & "&dayId="      & lngDayId
		strURL = strURL & "&csCd="       & strCsCd
		strURL = strURL & "&sortKey="    & strSortKey
		strURL = strURL & "&badJud="     & strBadJud
		strURL = strURL & "&unFinished=" & strUnFinished
		strURL = strURL & "&noPrevNext=" & strNoPrevNext
%>
		<FRAME SRC="<%= strURL %>" name="judge">
		<FRAME SRC="/webHains/contents/common/blank.htm" name="resultinfo">
	</FRAMESET>
</FRAMESET>

</HTML>
