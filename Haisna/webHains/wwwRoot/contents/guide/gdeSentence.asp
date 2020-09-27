<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		文章ガイド (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objSentence	'文章情報アクセス用

'パラメータ
Dim strItemCd			'検査項目コード
Dim lngItemType			'項目タイプ
Dim strStcClassCd		'文章分類コード

'文章分類
Dim strArrStcClassCd	'文章分類コード
Dim strArrStcClassName	'文章分類名

'文章
Dim strStcCd			'文章コード
Dim strShortStc			'略文章
Dim lngCount			'レコード件数

Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objSentence = Server.CreateObject("HainsSentence.Sentence")

'パラメータ値の取得
strItemCd     = Request("itemCd")
lngItemType   = CLng("0" & Request("itemType"))
strStcClassCd = Request("stcClassCd")

'-------------------------------------------------------------------------------
'
' 機能　　 : よく使う項目の編集
'
' 引数　　 : (In)     strItemCd    検査項目コード
' 　　　　 : (In)     lngItemType  項目タイプ
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub FavoriteStcList(strItemCd, lngItemType)

	Dim objSentence	'文章アクセス用COMオブジェクト

	Dim strStcCd		'文章コード
	Dim strShortStc		'略文章

	Dim lngCount		'レコード件数

	Dim strHTML			'HTML文字列
	Dim strDispStcCd	'編集用の文章コード
	Dim strDispShortStc	'編集用の略文章
	Dim i				'インデックス

	'検査項目コードが指定されてない場合は何もしない
	If IsEmpty(strItemCd) Then
		Exit Sub
	End If

	Do
		'指定検査項目コード、項目タイプのレコードを取得
		Set objSentence = Server.CreateObject("HainsSentence.Sentence")
		lngCount = objSentence.SelectRecentSentenceList(strItemCd, lngItemType, strStcCd, strShortStc)

		'データが存在しない場合は何もしない
		If lngCount = 0 Then
			Exit Do
		End If

%>
		<BR><BR>よく使う項目<BR>
		<UL>
<%

		'文章の編集開始
		For i = 0 To lngCount - 1

			'文章の取得
			strDispStcCd   = strStcCd(i)
			strDispShortStc = strShortStc(i)

			'文章の編集
%>
			<LI>
				<INPUT TYPE="hidden" NAME="stccd2" VALUE="<%= strStcCd(i) %>">
				<INPUT TYPE="hidden" NAME="shortstc2" VALUE="<%= strShortStc(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(2, <%= CStr(i) %>)" CLASS="guideItem"><%= strDispShortStc %></A>
<%
		Next

%>
		</UL>
<%

		Exit Do
	Loop

	Set objSentence = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>文章ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 文章コード・略文章のセット
function selectList( mode, index ) {

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、文章コード・略文章を編集(リストが単数の場合と複数の場合とで処理を振り分け)

	// 文章コード
	if ( opener.stcGuide_StcCd != null ) {
		if ( mode == 1 ) {
			if ( document.stcList.stccd1.length != null ) {
				opener.stcGuide_StcCd = document.stcList.stccd1[ index ].value;
			} else {
				opener.stcGuide_StcCd = document.stcList.stccd1.value;
			}
		} else {
			if ( document.stcList.stccd2.length != null ) {
				opener.stcGuide_StcCd = document.stcList.stccd2[ index ].value;
			} else {
				opener.stcGuide_StcCd = document.stcList.stccd2.value;
			}
		}
	}

	// 略文章
	if ( opener.stcGuide_ShortStc != null ) {
		if ( mode == 1 ) {
			if ( document.stcList.shortstc1.length != null ) {
				opener.stcGuide_ShortStc = document.stcList.shortstc1[ index ].value;
			} else {
				opener.stcGuide_ShortStc = document.stcList.shortstc1.value;
			}
		} else {
			if ( document.stcList.shortstc2.length != null ) {
				opener.stcGuide_ShortStc = document.stcList.shortstc2[ index ].value;
			} else {
				opener.stcGuide_ShortStc = document.stcList.shortstc2.value;
			}
		}
	}

	// 連絡域に設定されてある親画面の関数呼び出し
	if ( opener.stcGuide_CalledFunction != null ) {
		opener.stcGuide_CalledFunction();
	}

	opener.winGuideStc = null;
	close();

	return false;
}
//-->
</SCRIPT>
<style>
body { margin: 8px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="itemCd"   VALUE="<%= strItemCd   %>">
	<INPUT TYPE="hidden" NAME="itemType" VALUE="<%= lngItemType %>">
	文章を選択してください。<BR><BR>
<%
	'文章分類一覧の編集
	objSentence.SelectStcClassList strItemCd, lngItemType, strArrStcClassCd, strArrStcClassName
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD NOWRAP>文章分類：</TD>
			<TD><%= EditDropDownListFromArray("stcClassCd", strArrStcClassCd, strArrStcClassName, strStcClassCd, NON_SELECTED_ADD) %></TD>
			<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="入力用検査項目セットを変更して表示"></TD>
		</TR>
	</TABLE>
</FORM>
<FORM NAME="stcList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<%
	'よく使う項目の編集
	FavoriteStcList strItemCd, lngItemType
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD NOWRAP>コード</TD>
			<TD NOWRAP>文章名</TD>
		</TR>
<%
		'指定検査項目コード、項目タイプのレコードを取得
'## 2003.12.30 Mod By K.Kagawa@FFCS		表示順番、未使用フラグ対応
'		lngCount = objSentence.SelectSentenceList(strItemCd, lngItemType, strStcCd, strShortStc, , , , , , , strStcClassCd)
		lngCount = objSentence.SelectSentenceList(strItemCd, lngItemType, strStcCd, strShortStc, , , , , , , strStcClassCd, , 1)
'## 2003.12.30 Mod End

		'文章の編集開始
		For i = 0 To lngCount - 1
%>
			<TR BGCOLOR="<%= IIf(i Mod 2 = 0, "#ffffff", "#eeeeee") %>">
				<TD><INPUT TYPE="hidden" NAME="stccd1" VALUE="<%= strStcCd(i) %>"><%= strStcCd(i) %></TD>
				<TD><INPUT TYPE="hidden" NAME="shortstc1" VALUE="<%= strShortStc(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(1, <%= i %>)" CLASS="guideItem"><%= strShortStc(i) %></A></TD>
			</TR>
<%
		Next
%>
		<TR BGCOLOR="#ffffff" HEIGHT="40">
			<TD COLSPAN="2" ALIGN="right" VALIGN="bottom">
				<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
