<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		汎用検索ガイド(親画面への汎用情報編集) (Ver0.0.1)
'		AUTHER  : Eiichi Yamamoto
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
Const lngMode = 0		'検索モード（0:一意検索）
Const blnLock = False	'レコードロック(False:ロック無し）

'データベースアクセス用オブジェクト
Dim objFree				'汎用情報アクセス用

Dim strFreeCdKey

'汎用情報
Dim strFreeCd
Dim strFreeClassCd
Dim strFreeName
Dim strFreeDate
Dim strFreeFeild1
Dim strFreeFeild2
Dim strFreeFeild3
Dim strFreeFeild4
Dim strFreeFeild5 

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFree = Server.CreateObject("HainsFree.Free")

'引数値の取得
strFreeCdKey	 			= Request("freeCd")

'コードが存在する場合
If( strFreeCdKey <> "" ) Then

	'汎用情報の読み込み
	objFree.SelectFree	lngMode, _
						strFreeCdKey, _
						strFreeCd, _
						strFreeName, _
						strFreeDate, _
						strFreeFeild1, _
						strFreeFeild2, _
						strFreeFeild3, _
						strFreeFeild4, _
						strFreeFeild5, _
						False, _
						strFreeClassCd

End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>汎用情報の検索</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 汎用コード・名称のセット
function selectContactStc() {

	// 呼び元ウィンドウが存在する場合
	if ( opener != null ) {

		// 親画面の団体編集関数呼び出し
		if ( opener.freeGuide_setFreeInfo ) {
			opener.freeGuide_setFreeInfo('<%= strFreeCd %>', '<%= strFreeClassCd %>', '<%= strFreeName %>', '<%= strFreeDate %>', '<%= strFreeFeild1 %>', '<%= strFreeFeild2 %>', '<%= strFreeFeild3 %>', '<%= strFreeFeild4 %>', '<%= strFreeFeild5 %>' );
		}

		// 親画面の関数呼び出し
		if ( opener.freeGuide_CalledFunction ) {
			opener.freeGuide_CalledFunction();
		}

		opener.winGuideFree = null;
	}

	// 自画面を閉じる
	close();
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 0; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:selectContactStc()">
</BODY>
</HTML>
