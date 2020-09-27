<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		室部検索ガイド(親画面への室部情報編集) (Ver0.0.1)
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
Dim objOrgRoom		'室部情報アクセス用

'室部情報
Dim strOrgCd1		'団体コード1
Dim strOrgCd2		'団体コード2
Dim strOrgBsdCd		'事業部コード
Dim strOrgRoomCd	'室部コード
Dim strOrgRoomName	'室部名称
Dim strOrgRoomKName	'室部カナ名称
Dim strOrgKName		'団体カナ名称
Dim strOrgName		'団体名称
Dim strOrgSName		'略称
Dim strOrgBsdKName	'事業部カナ名称
Dim strOrgBsdName	'事業部名称

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")

'引数値の取得
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strOrgBsdCd  = Request("orgBsdCd")
strOrgRoomCd = Request("orgRoomCd")

'団体・事業部・室部コードが存在する場合
If strOrgCd1 <> "" And strOrgCd2 <> "" And strOrgBsdCd <> "" And strOrgRoomCd <> "" Then

	'室部情報読み込み
	objOrgRoom.SelectOrgRoom strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName, strOrgRoomKName, strOrgKName, strOrgName, strOrgSName, strOrgBsdKName, strOrgBsdName

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>室部の検索</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 室部コード・名称のセット
function selectOrgRoom() {

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
<BODY ONLOAD="javascript:selectOrgRoom()">
</BODY>
</HTML>
