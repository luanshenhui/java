<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		バーコード受付 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objConsult		'受診情報アクセス用

'引数値
Dim strKey			'バーコード値
Dim lngMode			'飛び先モード

'受診情報
Dim lngRsvNo		'予約番号
Dim strCancelFlg	'キャンセルフラグ
Dim strCslDate		'受診日
Dim strPerId		'個人ＩＤ
Dim strDayId		'当日ＩＤ

Dim strMessage		'エラーメッセージ
Dim strURL			'ジャンプ先のURL
Dim lngStatus		'状態
Dim Ret				'関数戻り値

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strKey  = Request("key")
lngMode = CLng("0" & Request("mode"))

'チェック・更新・読み込み処理の制御
Do
	lngStatus = 1

	'バーコード値が存在しない場合は何もしない
	If strKey = "" Then
		Exit Do
	End If

	'予約番号よりも長いなら、それは問診票のバーコードね。
	If Len(Trim(strKey)) > LENGTH_CONSULT_RSVNO Then
		lngRsvNo = objConsult.GetRsvNoFromBarCode(Trim(strKey))
		If lngRsvNo < 1 Then
			lngStatus = -99
			Exit Do
		End If
	Else
		'数値チェック
		strMessage = objCommon.CheckNumeric("予約番号", strKey, LENGTH_CONSULT_RSVNO)
		If strMessage <> "" Then
			lngStatus = -99
			Exit Do
		End If

		'予約番号を取得
		lngRsvNo = CLng(strKey)

	End IF

	'予約番号を元に受診情報を読み込む
	If objConsult.SelectConsult(lngRsvNo, strCancelFlg, strCslDate, strPerId, , , , , , , , , , , , , , , , , , , , , strDayId) = False Then
		lngStatus = 0
		Exit Do
	End If

	'予約情報へジャンプする以外の場合、キャンセル者はジャンプできない
	If lngMode <> 0 And CLng(strCancelFlg) <> CONSULT_USED Then
		lngStatus = -1
		Exit Do
	End If

	'進捗情報、判定情報へジャンプする場合、未受付者はジャンプできない
	If (lngMode = 2 Or lngMode = 3) And strDayId = "" Then
		lngStatus = -2
		Exit Do
	End If

	'飛び先の振り分け
	Select Case lngMode

		Case 0	'予約情報へ

			'予約情報画面のURL編集
			strURL = "/webHains/contents/reserve/rsvMain.asp"
			strURL = strURL & "?rsvNo=" & lngRsvNo

		Case 1	'結果入力へ

			'結果入力画面のURL編集
			strURL = "/webHains/contents/result/rslMain.asp"
			strURL = strURL & "?rsvNo="      & lngRsvNo
			strURL = strURL & "&cslYear="    & Year(strCslDate)
			strURL = strURL & "&cslMonth="   & Month(strCslDate)
			strURL = strURL & "&cslDay="     & Day(strCslDate)
			strURL = strURL & "&dayId="      & strDayId
			strURL = strURL & "&noPrevNext=" & "1"

		Case 2	'進捗情報へ

			'受診進捗情報画面のURL編集
			strURL = "/webHains/contents/common/progress.asp"
			strURL = strURL & "?rsvNo="   & lngRsvNo
			strURL = strURL & "&actMode=" & "select"

		Case 3	'判定入力へ

			'判定入力画面のURL編集
			strURL = "/webHains/contents/judgement/judMain.asp"
			strURL = strURL & "?cslYear="    & Year(strCslDate)
			strURL = strURL & "&cslMonth="   & Month(strCslDate)
			strURL = strURL & "&cslDay="     & Day(strCslDate)
			strURL = strURL & "&dayId="      & strDayId
			strURL = strURL & "&noPrevNext=" & "1"

		Case 4	'結果参照へ

			'結果参照画面のURL編集
			strURL = "/webHains/contents/inquiry/inqMain.asp"
			strURL = strURL & "?perid=" & strPerId

		Case 5	'事後措置へ

			'事後措置画面のURL編集
			strURL = "/webHains/contents/aftercare/Jigoinfo.asp"
			strURL = strURL & "?perid=" & strPerId

	End Select

	'各画面へジャンプ
	Response.Redirect strURL
	Response.End

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
<TITLE>バーコードからの画面遷移</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function selectMode( val ) {

	var curDate = new Date();
	var previsit = curDate.toGMTString();

	curDate.setTime( curDate.getTime() + 7*24*60*60*1000 ); // 7日後

	var expire = curDate.toGMTString();

	document.cookie = 'mode=' + val + ';expires=' + expire;

	document.entryForm.key.focus();

}

function setDefaltCookie() {

	for ( var i = 0; i < document.entryForm.mode.length; i++ ) {
		if ( document.entryForm.mode[ i ].checked ) {
			selectMode( i );
			break;
		}
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setDefaltCookie();document.entryForm.key.focus();document.entryForm.key.value = ''">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONCLICK="javascript:document.entryForm.key.focus()">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">■</SPAN><FONT COLOR="#000000">バーコードからの画面遷移</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<IMG SRC="/webHains/images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left">
<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="220" ALIGN="left">
<BR>
<!--
	<IMG SRC="/webHains/images/text.jpg" WIDTH="450" HEIGHT="50" ALT="">
-->
<%
	'案内メッセージの編集
	Select Case lngStatus

		Case 0
%>
			<FONT SIZE="6">受診情報が存在しません。</FONT>
<%
		Case -1
%>
			<FONT SIZE="6">この受診情報はキャンセルされています。</FONT>
<%
		Case -2
%>
			<FONT SIZE="6">この受診情報は受付されていません。</FONT>
<%
		Case -99
%>
			<FONT SIZE="6">バーコードの値が正しくありません。</FONT>
<%
		Case Else
%>
			<FONT SIZE="6">バーコードを読み込ませてください。</FONT>
<%
	End Select
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>BarCode：</TD>
			<TD WIDTH="100%"><INPUT TYPE="text" NAME="key" SIZE="30" style="ime-mode:disabled"></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(lngMode = 0, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>予約情報へ</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(lngMode = 1, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>結果入力へ</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="2" <%= IIf(lngMode = 2, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>進捗情報へ</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="3" <%= IIf(lngMode = 3, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>判定情報へ</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="4" <%= IIf(lngMode = 4, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>健診歴参照へ</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="5" <%= IIf(lngMode = 5, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>事後措置入力へ</TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
