<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		項目ガイド(選択済み検査項目表示部) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
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
Dim lngCount			'選択済み項目表示件数
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
' 引数値の取得
lngCount = CLng(Request("count"))

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>項目ガイド</TITLE>
</HEAD>

<BODY>

<FORM NAME="entryform" ACTION="">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD COLSPAN="2" HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="5"></TD>
			<TD>選択済みの項目：</TD>
		</TR>
		<TR>
			<TD COLSPAN="2" HEIGHT="5"></TD>
		</TR>
<%
	Do
		'選択済み項目が0件の場合何も表示しない
		If lngCount = 0 Then
			Exit Do
		End If

		'選択済み検査項目テーブル表示
		For i = 0 To lngCount - 1
%>
		<TR>
			<TD WIDTH="5"></TD>

			<!-- 検査項目名の編集 -->
			<TD>
				<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
					document.write("<B>" + top.selectedList[<%= i %>][3] + "</B>");
				</SCRIPT>
			</TD>
		</TR>
<%
		Next

		Exit Do
	Loop
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
