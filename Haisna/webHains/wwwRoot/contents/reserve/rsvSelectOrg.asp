<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		受診団体の設定 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objOrgPost		'所属情報アクセス用

'引数値
Dim strMode			'処理モード
Dim strPerId		'個人ＩＤ
Dim strOrgCd1		'団体コード１
Dim strOrgCd2		'団体コード２
Dim strOrgBsdCd		'事業部コード
Dim strOrgRoomCd	'室部コード
Dim strOrgPostCd	'所属コード
Dim strIsrSign		'健保記号
Dim strIsrNo		'健保番号

'所属情報
Dim strOrgName		'団体名称
Dim strOrgSName		'団体略称
Dim strOrgBsdName	'事業部名称
Dim strOrgRoomName	'室部名称
Dim strOrgPostName	'所属名称

Dim strMessage		'メッセージ
Dim strHTML			'HTML文字列

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
strIsrSign   = Request("isrSign")
strIsrNo     = Request("isrNo")

'所属情報読み込み
objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName, , , , strOrgSName, , strOrgBsdName, strOrgRoomName
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>受診団体の設定</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 団体情報の設定
function setOrgInfo() {

	// 親画面が存在しない場合は画面を閉じる
	if ( !opener ) {
		close();
		return;
	}

	// 親画面の団体情報設定関数呼び出し
	with ( document.entryForm ) {
		opener.setOrgInfo( orgCd1.value, orgCd2.value, orgSName.value, orgBsdCd.value, orgBsdName.value, orgRoomCd.value, orgRoomName.value, orgPostCd.value, orgPostName.value, isrSign.value, isrNo.value );
	}

	// 画面を閉じる
	opener.closeChangeWindow();
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="javascript:setOrgInfo()">
<FORM NAME="entryForm" action="#">
	<INPUT TYPE="hidden" NAME="orgCd1"      VALUE="<%= strOrgCd1      %>">
	<INPUT TYPE="hidden" NAME="orgCd2"      VALUE="<%= strOrgCd2      %>">
	<INPUT TYPE="hidden" NAME="orgSName"    VALUE="<%= strOrgSName    %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"    VALUE="<%= strOrgBsdCd    %>">
	<INPUT TYPE="hidden" NAME="orgBsdName"  VALUE="<%= strOrgBsdName  %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"   VALUE="<%= strOrgRoomCd   %>">
	<INPUT TYPE="hidden" NAME="orgRoomName" VALUE="<%= strOrgRoomName %>">
	<INPUT TYPE="hidden" NAME="orgPostCd"   VALUE="<%= strOrgPostCd   %>">
	<INPUT TYPE="hidden" NAME="orgPostName" VALUE="<%= strOrgPostName %>">
	<INPUT TYPE="hidden" NAME="isrSign"     VALUE="<%= strIsrSign     %>">
	<INPUT TYPE="hidden" NAME="isrNo"       VALUE="<%= strIsrNo       %>">
</FORM>
</BODY>
</HTML>
