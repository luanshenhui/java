<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   個人検索 (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditPersonList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const GETCOUNT = 20	'表示件数のデフォルト値

Dim objCommon		'共通クラス
Dim objConsult		'受診情報アクセス用

Dim strKey			'検索キー
Dim lngStartPos		'検索開始位置
Dim lngGetCount		'表示件数

Dim strToken		'トークン
Dim strPerId		'個人ID

Dim i				'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strKey      = Request("key")
lngStartPos = CLng("0" & Request("startpos"))
lngGetCount = CLng("0" & Request("getcount"))

'## 2003.11.21 Add by T.Takagi@FSIT 複合検索はやめる
'検索キー中の半角カナを全角カナに変換する
strKey = objCommon.StrConvKanaWide(strKey)

'検索キー中の小文字を大文字に変換する
strKey = UCase(strKey)

'全角空白を半角空白に置換する
strKey = Replace(Trim(strKey), "　", " ")

'2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
Do Until InStr(1, strKey, "  ") = 0
    strKey = Replace(strKey, "  ", " ")
Loop
'## 2003.11.21 Add End

'検索開始位置未指定時は先頭から検索する
If lngStartPos = 0 Then
	lngStartPos = 1
End If

'表示件数未指定時はデフォルト値を適用する
If lngGetCount = 0 Then
	lngGetCount = GETCOUNT
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>個人の検索</TITLE>
<STYLE TYPE="text/css">
<!--
td.inqtab  { background-color:#FFFFFF }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 団体ガイド呼び出し
function callOrgGuide() {

	orgGuide_showGuideOrg( document.kensakulist.orgCd1, document.kensakulist.orgCd2, 'orgName' );

}

// 団体の削除
function clearOrgInfo() {

	orgGuide_clearOrgInfo( document.kensakulist.orgCd1, document.kensakulist.orgCd2, 'orgName' );

}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="JavaScript:document.kensakulist.key.focus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="inquiry">■</SPAN><FONT COLOR="#000000">個人の検索</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>検索条件</TD>
			<TD>：</TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="この条件で検索"></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'当日ID直接指定時の処理
	Do
		'検索条件が存在しない場合は何もしない
		If strKey = "" Then
			Exit Do
		End If

		'当日IDの桁数と一致しない場合は何もしない
		If Len(strKey) <> LENGTH_RECEIPT_DAYID Then
			Exit Do
		End If

		'４桁すべてが半角数字かをチェック
		For i = 1 To Len(strKey)

			'半角数字以外の文字が現れたらチェックを中止する
			strToken = Asc(Mid(strKey, i, 1))
			If strToken < Asc("0") Or strToken > Asc("9") Then
				Exit Do
			End If

		Next

		'受診日をシステム日付として指定当日IDの予約番号を取得する
		If objConsult.SelectConsultFromReceipt(Date(), 0, strKey, , , strPerId) = False Then
%>
			指定された当日IDの受診情報は存在しません。<BR>
<%
			Response.End
		End If

		'健診歴参照画面へ
		Response.Redirect "inqMain.asp?perid=" & strPerId
		Response.End

		Exit Do
	Loop

	'個人一覧の編集
	Call EditPersonList(strKey, lngStartPos, lngGetCount, "inqMain.asp?perid=")
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
