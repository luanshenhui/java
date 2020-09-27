<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		判定コメントガイド(親画面への判定コメント情報編集) (Ver0.0.1)
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
Dim objJudCmtStc	'判定コメント情報アクセス用

'判定コメント情報
Dim strJudCmtCd		'判定コメントコード
Dim strJudCmtStc	'判定コメント文章
Dim strJudClassCd	'判定分類コード
Dim strGuidanceCd	'指導内容コード
Dim strGuidanceStc	'指導内容
Dim strJudCd		'判定コード
Dim strJudSName		'判定略称

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objJudCmtStc = Server.CreateObject("HainsJudCmtStc.JudCmtStc")

'引数値の取得
strJudCmtCd = Request("judCmtCd")

'判定コメントコードが存在する場合
If strJudCmtCd <> "" Then

	'判定コメント情報読み込み
	objJudCmtStc.SelectJudCmtStc strJudCmtCd, strJudCmtStc, strJudClassCd, strGuidanceCd, strGuidanceStc, strJudCd, strJudSName

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>判定コメントの検索</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 判定コメント情報のセット
function selectJudCmt() {

	// 呼び元ウィンドウが存在する場合
	if ( opener != null ) {

		// 親画面の団体編集関数呼び出し
		if ( opener.jcmGuide_setJudCmtInfo ) {
			opener.jcmGuide_setJudCmtInfo('<%= strJudCmtCd %>','<%= strJudCmtStc %>','<%= strGuidanceCd %>','<%= strGuidanceStc %>','<%= strJudCd %>','<%= strJudSName %>');
		}

		opener.jcmGuide_closeGuideJcm();

	} else {
		close();
	}

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 0; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:selectJudCmt()">
</BODY>
</HTML>
