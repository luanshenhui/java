<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		所属検索ガイド(親画面への所属情報編集) (Ver0.0.1)
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
Dim objOrgPost		'所属情報アクセス用

'室部情報
Dim strOrgCd1		'団体コード１
Dim strOrgCd2		'団体コード２
Dim strOrgBsdCd		'事業部コード
Dim strOrgRoomCd	'室部コード
Dim strOrgPostCd	'所属コード
Dim strOrgPostName	'所属名称
Dim strOrgPostKName	'所属カナ名称
Dim strOrgKName		'団体カナ名称
Dim strOrgName		'団体名称
Dim strOrgSName		'略称
Dim strOrgBsdKName	'事業部カナ名称
Dim strOrgBsdName	'事業部名称
Dim strOrgRoomName	'室部名称
Dim strOrgRoomKName	'室部カナ名称

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

'引数値の取得
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strOrgBsdCd  = Request("orgBsdCd")
strOrgRoomCd = Request("orgRoomCd")
strOrgPostCd = Request("orgPostCd")

'団体・事業部・室部・所属コードが存在する場合
If strOrgCd1 <> "" And strOrgCd2 <> "" And strOrgBsdCd <> "" And strOrgRoomCd <> "" And strOrgPostCd <> "" Then

	'所属情報読み込み
	objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName, strOrgPostKName, strOrgKName, strOrgName, strOrgSName, strOrgBsdKName, strOrgBsdName, strOrgRoomName, strOrgRoomKName

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>所属の検索</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 所属コード・名称のセット
function selectOrgPost() {

	// 呼び元ウィンドウが存在する場合
	if ( opener != null ) {

		// 親画面の団体編集関数呼び出し
		if ( opener.orgGuide_setOrgInfo ) {
			opener.orgGuide_setOrgInfo('<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strOrgName %>', '<%= strOrgSName %>', '<%= strOrgKName %>');
		}

		// 親画面の関数呼び出し
		if ( opener.orgGuide_CalledFunction != null ) {
			opener.orgGuide_CalledFunction();
		}

		// 親画面の事業部編集関数呼び出し
		if ( opener.orgPostGuide_setOrgBsdInfo ) {
			opener.orgPostGuide_setOrgBsdInfo('<%= strOrgBsdCd %>', '<%= strOrgBsdName %>');
		}

		// 親画面の室部編集関数呼び出し
		if ( opener.orgPostGuide_setOrgRoomInfo ) {
			opener.orgPostGuide_setOrgRoomInfo('<%= strOrgRoomCd %>', '<%= strOrgRoomName %>');
		}

		// 親画面の所属編集関数呼び出し
		if ( opener.orgPostGuide_setOrgPostInfo ) {
			opener.orgPostGuide_setOrgPostInfo('<%= strOrgPostCd %>', '<%= strOrgPostName %>');
		}

		opener.winGuideOrg = null;
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
<BODY ONLOAD="javascript:selectOrgPost()">
</BODY>
</HTML>
