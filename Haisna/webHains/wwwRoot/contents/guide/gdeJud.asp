<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       判定ガイド (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"     -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objJud		'判定アクセス用

Dim strJudCd	'判定コード
Dim strJudSName	'判定略称
Dim strJudRName	'報告書用判定名        
Dim lngCount	'判定数
Dim i			'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objJud = Server.CreateObject("HainsJud.Jud")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>判定ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 判定コメントコード・判定コメント文章のセット
function selectJud( judCd, judSName, judRName ) {

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		close();
		return;
	}

	// 判定情報編集
	opener.judGuide_setJudInfo( judCd, judSName, judRName );

	// 画面を閉じる
	opener.judGuide_closeGuideJud();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY>
判定を選択して下さい。<BR><BR>
<%
Do
	'全判定を読み込む
	lngCount = objJud.SelectJudList(strJudCd, strJudSName, strJudRName)
	If lngCount = 0 Then
		Exit Do
	End If
%>
	<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
<%
		For i = 0 To lngCount - 1
%>
			<TR>
				<TD><A HREF="javascript:selectJud('<%= strJudCd(i) %>','<%= strJudSName(i) %>','<%= strJudRName(i) %>' )"><%= strJudCd(i) %></TD>
				<TD><A HREF="javascript:selectJud('<%= strJudCd(i) %>','<%= strJudSName(i) %>','<%= strJudRName(i) %>' )"><%= strJudSName(i) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	Exit Do
Loop
%>
<BR>
<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
</BODY>
</HTML>
