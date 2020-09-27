<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		結果コメントガイド (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strEntryOk	'入力完了フラグ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
strEntryOk = Request("entryOk")

'-------------------------------------------------------------------------------
'
' 機能　　 : 結果コメント一覧の編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditCmtList()

	Dim objRslCmt		'結果コメントアクセス用COMオブジェクト

	Dim strRslCmtCd		'結果コメントコード
	Dim strRslCmtName	'結果コメント名
	Dim strArrEntryOk	'入力完了フラグ

	Dim lngCount		'レコード件数

	Dim strBgColor		'背景色
	Dim i				'インデックス
	Dim j				'インデックス

	'結果コメントのレコードを取得
	Set objRslCmt = Server.CreateObject("HainsRslCmt.RslCmt")
	lngCount = objRslCmt.SelectRslCmtList(strRslCmtCd, strRslCmtName, strArrEntryOk)
	Set objRslCmt = Nothing

	strBgColor = "ffffff"

	'結果コメントの編集開始
	j = 0
	For i = 0 To lngCount - 1

		If strEntryOk = "" Or strArrEntryOk(i) = strEntryOk Then
%>
			<TR BGCOLOR="#<%= strBgColor %>">
				<TD><INPUT TYPE="hidden" NAME="rslcmtcd" VALUE="<%= strRslCmtCd(i) %>"><%= strRslCmtCd(i) %></TD>
				<TD><INPUT TYPE="hidden" NAME="rslcmtname" VALUE="<%= strRslCmtName(i) %>"><A HREF="javascript:selectList(<%= CStr(j) %>)" CLASS="guideItem"><%= strRslCmtName(i) %></A></TD>
			</TR>
<%
			j = j + 1

			'次行の背景色を設定
			strBgColor = IIf(strBgColor = "ffffff", "eeeeee", "ffffff")

		End If

	Next

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>結果コメントガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 結果コメントコード・結果コメント名のセット
function selectList( index ) {

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、結果コメントコード・結果コメント名を編集(リストが単数の場合と複数の場合とで処理を振り分け)

	// 結果コメントコード
	if ( opener.cmtGuide_RslCmtCd != null ) {
		if ( document.entryform.rslcmtcd.length != null ) {
			opener.cmtGuide_RslCmtCd = document.entryform.rslcmtcd[ index ].value;
		} else {
			opener.cmtGuide_RslCmtCd = document.entryform.rslcmtcd.value;
		}
	}

	// 結果コメント名
	if ( opener.cmtGuide_RslCmtName != null ) {
		if ( document.entryform.rslcmtname.length != null ) {
			opener.cmtGuide_RslCmtName = document.entryform.rslcmtname[ index ].value;
		} else {
			opener.cmtGuide_RslCmtName = document.entryform.rslcmtname.value;
		}
	}

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.cmtGuide_CalledFunction != null ) {
		opener.cmtGuide_CalledFunction();
	}

	opener.winGuideCmt = null;
	close();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 10px 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<P>結果コメントを選択してください。</P>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD WIDTH="50">コード</TD>
			<TD>結果コメント</TD>
		</TR>
<%
		'結果コメント一覧の編集
		EditCmtList
%>
		<TR BGCOLOR="#ffffff" HEIGHT="40">
			<TD COLSPAN="2" ALIGN="RIGHT" VALIGN="BOTTOM">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
