<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		健診歴一覧 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objConsult		'受診情報アクセス用

'前画面から送信されるパラメータ値(更新のみ)
Dim strPerId		'個人ID
Dim strCslYear		'受診年
Dim strCslMonth 	'受診月
Dim strCslDay		'受診日
Dim strRsvNo		'予約番号

'受診情報
Dim strArrCslDate	'受診年月日
Dim strArrCsCd		'コースコード
Dim strArrCsName	'コース名
Dim strArrRsvNo		'予約番号
Dim strArrAge		'受診時年齢
Dim lngCount		'レコード数

Dim strCslDate		'受診年月日
Dim i				'インデックス
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'引数値の取得
strPerId    = Request("perId")
strCslYear  = Request("cslYear")
strCslMonth = Request("cslMonth")
strCslDay   = Request("cslDay")
strRsvNo    = Request("rsvNo")

'受診年月日の編集
strCslDate = strCslYear & "/" & strCslMonth & "/" & strCslDay
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>健診歴の一覧</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 健診歴の選択
function selectList( index ) {

	var myForm = document.entryForm;	// 自画面のフォームエレメント
	var rsvNo;							// 予約番号
	var cslDate;						// 受診年月日
	var csName;							// コース名

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return;
	}

	if ( myForm.firstRsvNo.length == null ) {

		// 健診歴一覧が１件しか存在しない場合の選択処理
		rsvNo   = myForm.firstRsvNo.value;
		cslDate = myForm.firstCslDate.value;
		csName  = myForm.firstCsName.value;

	} else {

		// 健診歴一覧が複数件存在する場合の選択処理
		rsvNo   = myForm.firstRsvNo[ index ].value;
		cslDate = myForm.firstCslDate[ index ].value;
		csName  = myForm.firstCsName[ index ].value;

	}

	// 親画面の関数呼び出し
	opener.top.setFirstCslInfo( rsvNo, cslDate, csName );

	// 画面を閉じる
	opener.winConsult = null;
	close();
}
//-->
</SCRIPT>
</HEAD>
<BODY>

<FORM NAME="entryForm" action="#">
<%
	'健診歴一覧の読み込み
	lngCount = objConsult.SelectConsultHistory(strPerId, strCslDate, True, True, , strArrRsvNo, strArrCslDate, strArrCsCd, strArrCsName, strArrAge)
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD NOWRAP>受診日</TD>
			<TD WIDTH="100%">コース</TD>
		</TR>
<%
		'健診歴一覧の編集開始
		For i = 0 To lngCount - 1
%>
			<INPUT TYPE="hidden" NAME="firstRsvNo"   VALUE="<%= strArrRsvNo(i)   %>">
			<INPUT TYPE="hidden" NAME="firstCslDate" VALUE="<%= strArrCslDate(i) %>">
			<INPUT TYPE="hidden" NAME="firstCsName"  VALUE="<%= strArrCsName(i)  %>">
			<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">
				<TD><A HREF="JavaScript:selectList(<%= i %>)"><%= strArrCslDate(i) %></A></TD>
				<TD><%= strArrCsName(i) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>

	<BR>

	<A HREF="JavaScript:close()"><IMG ALIGN="right" SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>

</FORM>
</BODY>
</HTML>
