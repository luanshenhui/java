<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		面接文書検索ガイド(親画面への面接文書情報編集) (Ver0.0.1)
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
Dim objAfterCare			'アフターケア情報アクセス用

'面接文章情報
Dim strGuidanceDiv			'指導内容区分
Dim strStdContactStcCd		'定型面接文章コード
Dim strArrGuidanceDiv		'指導文章コード
Dim strArrStdContactStcCd	'定型面接文章コード
Dim strArrContactStc		'面接文章

strStdContactStcCd = Array("")

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")

'引数値の取得
strGuidanceDiv 			= Request("guidanceDiv")
strStdContactStcCd(0)	= Request("stdContactStcCd")

'コードが存在する場合
If( strGuidanceDiv <> "" And strStdContactStcCd(0) <> "" ) Then

	'定型面接文章情報の読み込み
	objAfterCare.SelectStdContactStc strStdContactStcCd, _
									 strGuidanceDiv, _
									 1, _
									 1, _
									 strArrGuidanceDiv, _
									 strArrStdContactStcCd, _
									 strArrContactStc

End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>団体の検索</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 病名コード・名称のセット
function selectContactStc() {

	// 呼び元ウィンドウが存在する場合
	if ( opener != null ) {

		// 親画面の団体編集関数呼び出し
		if ( opener.contactStcGuide_setContactStcInfo ) {
			opener.contactStcGuide_setContactStcInfo('<%= strArrGuidanceDiv(0) %>', '<%= strArrStdContactStcCd(0) %>', '<%= strArrContactStc(0) %>' );
		}

		// 親画面の関数呼び出し
		if ( opener.contactStcGuide_CalledFunction != null ) {
			opener.contactStcGuide_CalledFunction();
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
<BODY ONLOAD="JavaScript:selectContactStc()">
</BODY>
</HTML>
