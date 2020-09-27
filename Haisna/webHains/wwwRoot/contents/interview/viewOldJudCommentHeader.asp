<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   過去総合コメント一覧（ヘッダ） (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterView		'面接情報アクセス用

'パラメータ
Dim	strWinMode			'ウィンドウモード
Dim strAct				'処理状態
Dim lngRsvNo			'予約番号（今回分）
Dim strGrpCd			'グループコード
Dim strCsCd				'コースコード

Dim lngLastDspMode		'前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp			'前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
Dim vntPerId			'個人ＩＤ
Dim vntRsvNo			'予約番号
Dim vntCslDate			'受診日
Dim vntCsCd				'コースコード
Dim vntCsName			'コース名
Dim vntCsSName			'コース略称
Dim lngHisCount			'表示歴数

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'引数値の取得
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")
strGrpCd			= Request("grpcd")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strSelCsGrp			= IIf( strSelCsGrp="", "0", strSelCsGrp)

Select Case strSelCsGrp
	'すべてのコース
	Case "0"
		lngLastDspMode = 0
		vntCsGrp = ""
	'同一コース
	Case "1"
		lngLastDspMode = 1
		vntCsGrp = strCsCd
	Case Else
		lngLastDspMode = 2
		vntCsGrp = strSelCsGrp
End Select

Do	

	DispCalledFunction = "javascript:callOldJudCommentTop()"

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>過去総合コメント一覧</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
//表示
function callOldJudCommentTop() {

	// Topに選択されたコースグループを指定してsubmit
	parent.params.cscd = document.entryForm.cscd.value;
	parent.params.csgrp = document.entryForm.csgrp.value;
    common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);

}

//画面遷移用（サンプル)
function movePage() {
	if ( document.entryForm.moveTo.value != '' ) {
		location.href = document.entryForm.moveTo.value;
	}
}


//-->
</SCRIPT>
<script type="text/javascript" src="/webHains/js/common.js"></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
	'「別ウィンドウで表示」の場合、ヘッダー部分表示
	If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- 引数値 -->
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd" VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpcd" VALUE="<%= strGrpCd %>">

	<!-- タイトルの表示 -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">■</SPAN><FONT COLOR="#000000">過去総合コメント一覧</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
			'前回歴コンボボックス表示
			Call  EditCsGrpInfo( lngRsvNo )
%>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
