<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		定型所見ガイド (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim lngJudClassCd	'判定分類コード

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
lngJudClassCd = CLng(Request("judClassCd") & "")

'-------------------------------------------------------------------------------
'
' 機能　　 : 定型所見一覧の編集
'
' 引数　　 : (In)     lngJudClassCd  判定分類コード
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditObsList(lngJudClassCd)

	Dim objStdJud		'定型所見アクセス用COMオブジェクト

	Dim strStdJudCd		'定型所見コード
	Dim strStdJudNote	'定型所見名称

	Dim lngCount		'レコード件数

	Dim strDispStdJudCd	'編集用の定型所見コード
	Dim strDispStdJudNote	'編集用の定型所見名称
	Dim i			'インデックス

	Do
		'定型所見のレコードを取得
		Set objStdJud = Server.CreateObject("HainsStdJud.StdJud")
		lngCount = objStdJud.SelectStdJudList(lngJudClassCd, strStdJudCd, strStdJudNote)

		'定型所見一覧の編集開始
		For i = 0 To lngCount - 1

			'定型所見の取得
			strDispStdJudCd   = strStdJudCd(i)
			strDispStdJudNote = strStdJudNote(i)

			'定型所見の編集
			If (i Mod 2) = 0 Then
%>
			<TR BGCOLOR="#ffffff">
<%
			Else
%>
			<TR BGCOLOR="#eeeeee">
<%
			End If
%>
				<TD>
					<INPUT TYPE="hidden" NAME="stdjudcd" VALUE="<%= strStdJudCd(i) %>"><%= strDispStdJudCd %>
				</TD>
				<TD>
					<INPUT TYPE="hidden" NAME="stdjudnote" VALUE="<%= strStdJudNote(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= CStr(i) %>)" CLASS="guideItem"><%= strDispStdJudNote %></A>
				</TD>
			</TR>
<%
		Next

		Exit Do
	Loop

	Set objStdJud = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>定型所見ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 定型所見コード・定型所見名称のセット
function selectList( index ) {

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、定型所見コード・定型所見名称を編集(リストが単数の場合と複数の場合とで処理を振り分け)

	// 定型所見コード
	if ( opener.obsGuide_StdJudCd != null ) {
		if ( document.entryform.stdjudcd.length != null ) {
			opener.obsGuide_StdJudCd = document.entryform.stdjudcd[ index ].value;
		} else {
			opener.obsGuide_StdJudCd = document.entryform.stdjudcd.value;
		}
	}

	// 定型所見名称
	if ( opener.obsGuide_StdJudNote != null ) {
		if ( document.entryform.stdjudnote.length != null ) {
			opener.obsGuide_StdJudNote = document.entryform.stdjudnote[ index ].value;
		} else {
			opener.obsGuide_StdJudNote = document.entryform.stdjudnote.value;
		}
	}

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.obsGuide_CalledFunction != null ) {
		opener.obsGuide_CalledFunction();
	}

	opener.winGuideObs = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<P>定型所見を選択してください。</P>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD WIDTH="50">コード</TD>
			<TD>定型所見</TD>
		</TR>
<%
		'定型所見一覧の編集
		EditObsList lngJudClassCd
%>
		<TR BGCOLOR="#ffffff" HEIGHT="40">
			<TD COLSPAN="2" ALIGN="RIGHT" VALIGN="BOTTOM">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
