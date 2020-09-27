<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		病名検索ガイド(親画面への病名情報編集) (Ver0.0.1)
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
'データベースアクセス用オブジェクト
Dim objDisease		'病名情報アクセス用

'病名情報
Dim strDisCd		'病名コード1
Dim strDisName		'病名
Dim strSearchChar	'ガイド検索用文字列
Dim strDisDivCd		'病類コード
Dim strDisDivName	'病類名

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objDisease = Server.CreateObject("HainsDisease.Disease")

'引数値の取得
strDisCd = Request("disCd")
strDisDivCd = Request("disDivCd")

'病名コードが存在する場合
If( strDisCd <> "" ) Then

	'病名情報読み込み
	objDisease.SelectDisease strDisCd, strDisName, strSearchChar, strDisDivCd, strDisDivName 

End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>傷病の検索</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 病名コード・名称のセット
function selectOrg() {

	// 呼び元ウィンドウが存在する場合
	if ( opener != null ) {

		// 親画面の団体編集関数呼び出し
		if ( opener.disGuide_setDiseaseInfo ) {
			opener.disGuide_setDiseaseInfo('<%= strDisCd %>', '<%= strDisName %>', '<%= strSearchChar %>', '<%= strDisDivCd %>', '<%= strDisDivName %>');
		}

		// 親画面の関数呼び出し
		if ( opener.disGuide_CalledFunction != null ) {
			opener.disGuide_CalledFunction();
		}

		opener.winGuideDisease = null;
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
<BODY ONLOAD="JavaScript:selectOrg()">
</BODY>
</HTML>
