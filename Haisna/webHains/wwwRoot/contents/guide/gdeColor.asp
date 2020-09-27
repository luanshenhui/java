<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		契約情報(検査セットの登録) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strColor(215)		'色の配列
Dim lngColorCount		'配列カウンタ

Dim i, j, k				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'色の配列を作成
For i = 5 To 0 Step -1
	For j = 5 To 0 Step -1
		For k = 5 To 0 Step -1
			strColor(lngColorCount) = String(2, CStr(HEX(k * 3))) & String(2, CStr(HEX(i * 3))) & String(2, CStr(HEX(j * 3)))
			lngColorCount = lngColorCount + 1
		Next
	Next
Next
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>色の選択</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function setColor( colorCode ) {

	for ( ; ; ) {

		if ( !opener ) break;

		// セットカラー格納用エレメント値の編集
		var elemObj = opener.colorGuide_ElemObj;
		if ( elemObj != null ) {
			elemObj.value = colorCode;
		}

		// セットカラー変更用エレメント名の取得
		var colorElemName = opener.colorGuide_ColorElemName;

		if ( colorElemName == null ) break;

		if ( colorElemName == '' ) break;

		// セットカラー変更用エレメントの色編集
		var colorElemObj = opener.document.getElementById(colorElemName);
		if ( colorElemObj != null ) {
			colorElemObj.style.color = '#' + colorCode;
		}

		break;

	}

	close();
}
//-->
</SCRIPT>
</HEAD>
<BODY>

<%

%>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
<%
	For i = 0 To 11
%>
		<TR>
<%
			For j = 0 To 17
%>
				<TD WIDTH="12" HEIGHT="12" BGCOLOR="#<%= strColor(i * 18 + j) %>" ONCLICK="javascript:setColor('<%= strColor(i * 18 + j) %>')"></TD>
<%
			Next
%>
		</TR>
<%
	Next
%>
</TABLE>
</FORM>
</BODY>
</HTML>