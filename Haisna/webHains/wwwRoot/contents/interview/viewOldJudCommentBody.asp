<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   総合判定（参照専用画面） (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc"   -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const JUDDOC_GRPCD = "X049"		'判定医グループコード
Const AUTOJUD_USER = "autouser"		'自動判定ユーザ

'データベースアクセス用オブジェクト
Dim objCommon			'共通クラス
Dim objInterview		'面接情報アクセス用

Dim strAct				'処理状態
Dim strWinMode			'ウインドウ表示モード（1:別ウインドウ、0:同ウインドウ）
Dim strGrpCd			'グループコード

Dim lngRsvNo			'予約番号（今回分）
Dim strCsCd				'コースコード（今回分）
Dim lngLastDspMode		'前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
Dim vntCsGrp			'コースコード または　コースグループコード


'受診情報取得用
Dim vntRsvNo 		'予約番号
Dim vntCslDate 		'受診日
Dim vntCsCd 			'コースコード
Dim vntCsName 		'コース名称
Dim lngCount			'件数

'総合コメント
Dim vntCmtSeq			'表示順
Dim vntTtlJudCmtCd			'判定コメントコード
Dim vntTtlJudCmtstc		'判定コメント文章
Dim vntTtlJudClassCd		'判定分類コード
Dim lngTtlCmtCnt		'行数

Dim strBakCslDate 		'受診日
Dim strBakCsCd 			'コースコード

'前回歴コースコンボボックス
Dim strArrLastCsGrp()			'コースグループコード
Dim strArrLastCsGrpName()		'コースグループ名称

Dim i					'ループカウンタ
Dim j					'ループカウンタ

Dim strMessage			'結果登録復帰値

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")

'引数値の取得
strAct           = Request("action")

lngRsvNo         = Request("rsvno")
strCsCd          = Request("cscd")
strWinMode       = Request("winmode")
strGrpCd         = Request("grpcd")


strSelCsGrp		= Request("csgrp")
strSelCsGrp = IIf( strSelCsGrp="", "0", strSelCsGrp)

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
	

	'検索条件に従い受診情報一覧を抽出する
	lngCount = objInterview.SelectConsultHistory( _
							    lngRsvNo, _
    							 , _
    							lngLastDspMode, _
    							vntCsGrp, _
    							1, _
    							 ,  , _
								vntRsvNo, _
    							vntCslDate, _
    							vntCsCd _
								)

	If lngCount <= 0 Then
		Err.Raise 1000, , "受診情報がありません。RsvNo= " & lngRsvNo
	End If

	'今回コースコード退避
	strCsCd = vntCsCd(0)


	'総合コメント取得
	lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
    									lngRsvNo, 1, _
										"*", lngLastDspMode, vntCsGrp, 1, _
    									vntCmtSeq, _
    									vntTtlJudCmtCd, _
    									vntTtlJudCmtstc, _
    									vntTtlJudClassCd, _
										vntRsvNo, _
										vntCslDate, _
										vntCsCd, _
										vntCsName _
										)


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
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
//総合判定入力画面呼び出し
function calltotalJudEdit() {
	var url;							// URL文字列

	url = '/WebHains/contents/interview/totalJudEdit.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&grpcd=' + '<%= strGrpCd %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	parent.location.href(url);

}


//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="cscd" VALUE="<%= strCsCd %>">
<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="grpcd" VALUE="<%= strGrpCd %>">

<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" class="mensetsu-tb">
	<TR BGCOLOR="#cccccc">
		<th WIDTH="119" ALIGN="left">受診日</th>
		<th WIDTH="180" ALIGN="left">コース</th>
		<th WIDTH="500" ALIGN="left">コメント</th>
	</TR>
<%
	strBakCslDate = ""
	strBakCsCd = ""
	For i = 0 To lngTtlCmtCnt - 1
%>
	<TR>
<%
	'受診日が変わった
	If strBakCslDate <> vntCslDate(i) Then
		strBakCslDate = vntCslDate(i)
		strBakCsCd = vntCsCd(i)
%>
		<TD><%= vntCslDate(i) %></TD>
		<TD><%= vntCsName(i) %></TD>
<%
	Else
%>
		<TD>&nbsp;</TD>
<%
		'受診コースが変わった
		If strBakCsCd <> vntCsCd(i) Then
			strBakCsCd = vntCsCd(i)
%>
		<TD><%= vntCsName(i) %></TD>
<%
		Else
%>
		<TD>&nbsp;</TD>
<%
		End If
	End If
%>
		<TD><%= vntTtlJudCmtstc(i) %></TD>
	</TR>
<%
	Next
%>
</TABLE>
</FORM>
</BODY>
</HTML>