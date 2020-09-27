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
Dim objSecondBill	'２次請求明細情報アクセス用

'パラメータ
Dim strItemCd			'検査項目コード
Dim lngItemType			'項目タイプ
Dim strStcClassCd		'文章分類コード

'文章分類
Dim strArrSecondLineDivCd	'２次請求明細コード
Dim strArrSecondLineDivName	'２次請求明細名
Dim strArrstdPrice		'標準単価
Dim strArrstdTax		'標準税額

'文章
Dim strStcCd			'文章コード
Dim strShortStc			'略文章
Dim lngCount			'レコード件数

Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objSecondBill = Server.CreateObject("HainsSecondBill.SecondBill")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>２次請求明細ガイド</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ２次請求明細コード・２次請求明細名のセット
function selectList( index ) {

	// 呼び元ウィンドウが存在しなければ何もしない
	if ( opener == null ) {
		return false;
	}

	// 親画面の連絡域に対し、２次請求明細コード・２次請求明細名を編集(リストが単数の場合と複数の場合とで処理を振り分け)

	// ２次請求明細コード
	if ( opener.secondLineDivGuide_SecondLineDivCd != null ) {
		if ( document.secondLineDivList.secondLineDivCd.length != null ) {
			opener.secondLineDivGuide_SecondLineDivCd = document.secondLineDivList.secondLineDivCd[ index ].value;
		} else {
			opener.secondLineDivGuide_SecondLineDivCd = document.secondLineDivList.secondLineDivCd.value;
		}
	}

	// 略文章
	if ( opener.secondLineDivGuide_SecondLineDivName != null ) {
		if ( document.secondLineDivList.secondLineDivName.length != null ) {
			opener.secondLineDivGuide_SecondLineDivName = document.secondLineDivList.secondLineDivName[ index ].value;
		} else {
			opener.secondLineDivGuide_SecondLineDivName = document.secondLineDivList.secondLineDivName.value;
		}	
	}

	// 標準単価
	if ( opener.secondLineDivGuide_stdPrice != null ) {
		if ( document.secondLineDivList.stdPrice.length != null ) {
			opener.secondLineDivGuide_stdPrice = document.secondLineDivList.stdPrice[ index ].value;
		} else {
			opener.secondLineDivGuide_stdPrice = document.secondLineDivList.stdPrice.value;
		}	
	}

	// 標準税額
	if ( opener.secondLineDivGuide_stdTax != null ) {
		if ( document.secondLineDivList.stdTax.length != null ) {
			opener.secondLineDivGuide_stdTax = document.secondLineDivList.stdTax[ index ].value;
		} else {
			opener.secondLineDivGuide_stdTax = document.secondLineDivList.stdTax.value;
		}	
	}

	// 連絡域に設定されてある親画面の関数呼び出し
//	if ( opener.secondLineDivGuide_CalledFunction != null ) {
		opener.secondLineDivGuide_CalledFunction();
//	}

	opener.winGuideStc = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff">

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">

	２次請求明細名を選択してください。<BR><BR>
	<BR>
</FORM>
<FORM NAME="secondLineDivList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD NOWRAP>コード</TD>
			<TD NOWRAP>名称</TD>
			<TD NOWRAP>金額</TD>
			<TD NOWRAP>税額</TD>
		</TR>
<%
		'２次請求明細一覧の編集
		lngCount = objSecondBill.SelectSecondLineDiv(strArrSecondLineDivCd, strArrSecondLineDivName, strArrstdPrice, strArrstdTax)

		'文章の編集開始
		For i = 0 To lngCount - 1
%>
			<TR BGCOLOR="<%= IIf(i Mod 2 = 0, "#ffffff", "#eeeeee") %>">
				<TD><INPUT TYPE="hidden" NAME="secondLineDivCd" VALUE="<%= strArrSecondLineDivCd(i) %>"><%= strArrSecondLineDivCd(i) %></TD>
				<TD><INPUT TYPE="hidden" NAME="secondLineDivName" VALUE="<%= strArrSecondLineDivName(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= i %>)" CLASS="guideItem"><%= strArrSecondLineDivName(i) %></A></TD>
				<TD><INPUT TYPE="hidden" NAME="stdPrice" VALUE="<%= strArrstdPrice(i) %>"><%= FormatCurrency(strArrstdPrice(i)) %></TD>
				<TD><INPUT TYPE="hidden" NAME="stdTax" VALUE="<%= strArrstdTax(i) %>"><%= FormatCurrency(strArrstdTax(i)) %></TD>
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
