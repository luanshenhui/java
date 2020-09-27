<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		予約情報詳細(セット内検査項目情報) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objContract			'契約情報アクセス用

'引数値
Dim strCtrPtCd			'契約パターンコード
Dim strOptCd			'オプションコード
Dim strOptBranchNo		'オプション枝番

'検査項目情報
Dim strArrItemCd		'検査項目コード
Dim strArrSuffix		'サフィックス
Dim strArrItemName		'検査項目名
Dim strArrExplanation	'項目説明
Dim lngCount			'レコード数

Dim strOptName			'オプション名
Dim i					'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objContract = Server.CreateObject("HainsContract.Contract")

'引数値の取得
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = Request("optCd")
strOptBranchNo = Request("optBranchNo")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>セット内検査項目情報</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">セット内検査項目情報</FONT></B></TD>
	</TR>
</TABLE>
<%
'契約パターンオプション管理情報読み込み
objContract.SelectCtrPtOpt strCtrPtCd, strOptCd, strOptBranchNo, strOptName
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
	<TR>
		<TD NOWRAP>セット名</TD>
		<TD>：</TD>
		<TD><B><%= strOptName %></B></TD>
	</TR>
</TABLE>
<%
Do
	'指定契約パターン・オプションにおける検査項目の説明情報を取得
	lngCount = objContract.SelectCtrPtOptExplanation(strCtrPtCd, strOptCd, strOptBranchNo, strArrItemCd, strArrSuffix, strArrItemName, strArrExplanation)
	If lngCount <= 0 Then
%>
		<BR>このセットにおける情報はありません。<BR>
<%
		Exit Do
	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
<%
		For i = 0 To lngCount - 1
%>
			<TR>
<%
				If i = 0 Then
%>
					<TD NOWRAP>検査項目コメント</TD>
					<TD>：</TD>
<%
				Else
%>
					<TD></TD><TD></TD>
<%
				End If
%>
				<TD><B><%= strArrItemCd(i) %>-<%= strArrSuffix(i) %>：<%= strArrItemName(i) %></B></TD>
			</TR>
			<TR>
				<TD></TD><TD></TD>
				<TD><%= strArrExplanation(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
<%
	Exit Do
Loop
%>
<BR><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルします"></A>
</BODY>
</HTML>