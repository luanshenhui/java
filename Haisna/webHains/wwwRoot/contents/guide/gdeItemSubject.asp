<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		項目ガイド(検査分類選択部) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
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
Dim objItem			'項目ガイドアクセス用COMオブジェクト

Dim strClassCd		'検査分類コード
Dim strClassName	'検査分類名称

Dim lngCount		'レコード件数
Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objItem = Server.CreateObject("HainsItem.Item")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>項目ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 検査分類情報の制御。検査分類名称のONCLICKイベントから呼び出される。
function controlClassCd( classCd , className ) {

	// メイン部の検索条件保持用変数にキー値をセット
	top.gdeClassCd   = classCd;
	top.gdeClassName = className;

	// リスト部の再検索関数呼び出し
	top.setParamToList();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
<%
	Do
		'検査分類テーブルの全レコードを取得
		lngCount = objItem.SelectItemClassList(strClassCd, strClassName)

		'検査分類テーブルの編集
%>
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="100%">
<%
					'「すべて」行
%>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP><A HREF="javascript:function voi(){};voi()" CLASS="guideItem" ONCLICK="controlClassCd('','すべて')"><B><SPAN STYLE="font-size:13px;">すべて</SPAN></B></A></TD>
					</TR>
<%
					'該当項目がない場合表示しない
					If lngCount = 0 Then
						Exit Do
					End If

					'検査分野の表示
					For i = 0 To lngCount - 1
%>
						<TR>
							<TD BGCOLOR="#eeeeee" NOWRAP><A HREF="javascript:function voi(){};voi()" CLASS="guideItem" ONCLICK="controlClassCd('<%= strClassCd(i) %>','<%= strClassName(i) %>')"><B><SPAN STYLE="font-size:13px;"><%= strClassName(i) %></SPAN></B></A></TD>
						</TR>
<%
					Next
%>
				</TABLE>
			</TD>
		</TR>
<%
		Exit Do
	Loop
%>
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
</TABLE>
</BODY>
</HTML>
