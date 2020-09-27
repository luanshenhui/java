<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		オプション検査の登録(金額計算方法の設定) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_INSERT      = "INS"	'処理モード(挿入)
Const MODE_UPDATE      = "UPD"	'処理モード(更新)
Const CALCMODE_NORMAL  = "0"	'金額計算モード（料金手動設定）
Const CALCMODE_ROUNDUP = "1"	'金額計算モード（検査項目単価積算）

'データベースアクセス用オブジェクト
Dim objCommon		'共通クラス
Dim objContract		'契約情報アクセス用

'引数値
Dim strOrgCd1		'団体コード1
Dim strOrgCd2		'団体コード2
Dim lngCtrPtCd		'契約パターンコード
Dim strOptCd		'オプションコード
Dim strCalcMode		'金額計算モード

'契約管理情報
Dim strOrgName		'団体名
Dim strCsCd			'コースコード
Dim strCsName		'コース名
Dim dtmStrDate		'契約開始日
Dim dtmEndDate		'契約終了日
Dim strTaxFraction  '税端数区分

Dim strMode			'処理モード
Dim strURL			'ジャンプ先のURL

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objContract = Server.CreateObject("HainsContract.Contract")

'引数値の取得
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
lngCtrPtCd  = CLng("0" & Request("ctrPtCd"))
strOptCd    = Request("optCd")
strCalcMode = Request("calcMode")

'チェック・更新・読み込み処理の制御
Do
	'オプションコードおよびモード未指定時は制御処理を抜ける
	If strOptCd = "" And IsEmpty(Request("next.x")) Then
		Exit Do
	End If

	'処理モードの設定
	strMode = IIf(strOptCd <> "", MODE_UPDATE, MODE_INSERT)

	'オプション検査登録画面へ
	strURL = "ctrOption.asp"
	strURL = strURL & "?orgCd1="   & strOrgCd1
	strURL = strURL & "&orgCd2="   & strOrgCd2
	strURL = strURL & "&ctrPtCd="  & lngCtrPtCd
	strURL = strURL & "&optCd="    & strOptCd
	strURL = strURL & "&mode="     & strMode
	strURL = strURL & "&calcMode=" & strCalcMode
	Response.Redirect strURL
	Response.End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>オプション検査の登録</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= lngCtrPtCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">■</SPAN><FONT COLOR="#000000">オプション検査の登録</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'契約管理情報を読み、団体・コースの名称及び契約期間を取得する
	objContract.SelectCtrMng strOrgCd1, strOrgCd2, lngCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate, strTaxFraction
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>契約団体</TD>
			<TD>：</TD>
			<TD NOWRAP><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>対象コース</TD>
			<TD>：</TD>
			<TD NOWRAP><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>契約期間</TD>
			<TD>：</TD>
			<TD NOWRAP><B><%= objCommon.FormatString(dtmStrDate, "yyyy年m月d日") %>～<%= objCommon.FormatString(dtmEndDate, "yyyy年m月d日") %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">●</FONT>金額計算方法を指定して下さい。<BR><BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP>金額計算方法：</TD>
			<TD><INPUT TYPE="radio" NAME="calcMode" VALUE="<%= CALCMODE_NORMAL %>" <%= IIf(strCalcMode <> CALCMODE_ROUNDUP, "CHECKED", "") %>></TD>
			<TD NOWRAP>このオプション設定画面で料金を設定する。</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD><INPUT TYPE="radio" NAME="calcMode" VALUE="<%= CALCMODE_ROUNDUP %>" <%= IIf(strCalcMode = CALCMODE_ROUNDUP, "CHECKED", "") %>></TD>
			<TD NOWRAP>検査項目ごとに設定された金額を計上する。（マルメあり）</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" BORDER="0" ALT="キャンセル"></A>
	<INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" BORDER="0" ALT="次へ">

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>