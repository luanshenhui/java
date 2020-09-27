<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		労基署所属ガイド(親画面への労基署所属情報編集) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
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
Dim objOrgPost			'所属情報アクセス用

'労基署所属情報
Dim strOrgWkPostSeq		'労基署所属ＳＥＱ
Dim strOrgWkPostCd		'労基署所属コード
Dim strOrgWkPostName	'労基署所属名称

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

'引数値の取得
strOrgWkPostSeq = Request("orgWkPostSeq")

'労基署所属ＳＥＱが存在する場合
If strOrgWkPostSeq <> "" Then

	'労基署所属情報読み込み
	objOrgPost.SelectOrgWkPostFromSeq strOrgWkPostSeq, strOrgWkPostCd, strOrgWkPostName

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
// 労基署所属情報のセット
function selectOrgWkPost() {

	// 呼び元ウィンドウが存在する場合
	if ( opener != null ) {

		// 親画面の団体編集関数呼び出し
		if ( opener.orgWkPostGuide_setOrgWkPostInfo ) {
			opener.orgWkPostGuide_setOrgWkPostInfo( '<%= strOrgWkPostSeq %>', '<%= strOrgWkPostName %>' );
		}

		opener.winGuideOrgWkPost = null;
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
<BODY ONLOAD="javascript:selectOrgWkPost()">
</BODY>
</HTML>
