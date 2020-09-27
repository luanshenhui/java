<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		項目ガイド(ヘッダー部) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const TABLEDIV_I = 1		'｢検査項目｣
Const TABLEDIV_G = 2		'｢グループ｣

Dim lngGroup				'グループ表示有無　0:表示しない、1:表示する
Dim lngItem					'検査項目表示有無　0:表示しない、1:表示する

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
lngGroup = CLng(Request("group"))
lngItem  = CLng(Request("item" ))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>項目ガイド</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function setDefaultTableDiv() {
<%
Do
	'グループのみ表示する場合
	If lngGroup = ITEM_DISP And lngItem = ITEM_NOTDISP Then
%>
		top.gdeTableDiv = <%= TABLEDIV_G %>;
<%
		Exit Do
	End If

	'検査項目のみ表示する場合
	If lngGroup = ITEM_NOTDISP And lngItem = ITEM_DISP Then
%>
		top.gdeTableDiv = <%= TABLEDIV_I %>;
<%
		Exit Do
	End If

	'それ以外は何もしない
	Exit Do
Loop
%>
}

// 検査項目／グループ情報の制御。該当文字のONCLICKイベントから呼び出される。
function controlTableDiv( tableDiv ) {

	// メイン部の検索条件保持用変数にキー値をセット
	top.gdeTableDiv = tableDiv;

	// リスト部の再検索関数呼び出し
	top.setParamToList();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setDefaultTableDiv()">
<FORM NAME="entryform" ACTION="">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="145" VALIGN="bottom"><SPAN STYLE="font-size:13px;">分野で検索：</SPAN></TD>
			<TD BGCOLOR="#999999">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR ALIGN="center">
<%
					'検査項目の表示有無
					If lngItem = ITEM_NOTDISP Then
%>
						<TD BGCOLOR="#eeeeee" WIDTH="69" NOWRAP><B><SPAN STYLE="font-size:13px;">検査項目</SPAN></B></TD>
<%
					ElseIf lngItem = ITEM_DISP Then
%>
						<TD BGCOLOR="#eeeeee" WIDTH="69" NOWRAP><B><A HREF="javascript:function voi(){};voi()" CLASS="guideItem" ONCLICK="controlTableDiv(<%= TABLEDIV_I %>)"><SPAN STYLE="font-size:13px;">検査項目</SPAN></A></B></TD>
<%
					End If
%>
					</TR>
				</TABLE>
			</TD>
			<TD WIDTH="10"></TD>
			<TD BGCOLOR="#999999">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR ALIGN="center">
<%
					'グループの表示有無
					If lngGroup = ITEM_NOTDISP Then
%>
						<TD BGCOLOR="#eeeeee" WIDTH="69" NOWRAP><B><SPAN STYLE="font-size:13px;">グループ</SPAN></B></TD>
<%
					ElseIf lngGroup = ITEM_DISP Then
%>
						<TD BGCOLOR="#eeeeee" WIDTH="69" NOWRAP><B><A HREF="javascript:function voi(){};voi()" CLASS="guideItem" ONCLICK="controlTableDiv(<%= TABLEDIV_G %>)"><SPAN STYLE="font-size:13px;">グループ</SPAN></A></B></TD>
<%
					End If
%>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
