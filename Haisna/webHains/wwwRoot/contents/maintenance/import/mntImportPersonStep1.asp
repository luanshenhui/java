<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		健保データ取り込み(本人・家族の選択) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const DATADIV_SELF   = "self"	'取り込みデータ区分(本人)
Const DATADIV_FAMILY = "family"	'取り込みデータ区分(家族)

Const MODRIVELETTER  = "F"		'ＭＯドライブ文字

'オブジェクト
Dim objFso		'ファイルシステムオブジェクト
Dim objDrive	'ドライブオブジェクト

'引数値
Dim strDataDiv	'取り込みデータ区分

Dim strMessage	'エラーメッセージ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strDataDiv = Request("dataDiv")

'チェック・更新・読み込み処理の制御
Do

	'「次へ」ボタンが押されてなければ何もしない
	If Request("next.x") = "" Then
		Exit Do
	End If

	'取り込みデータ区分の必須チェック
	If strDataDiv = "" Then
		strMessage = "取り込みを行うデータが選択されていません。"
		Exit Do
	End If

	'オブジェクトのインスタンス作成
	Set objFso = CreateObject("Scripting.FileSystemObject")

	'ドライブ自体の存在チェック
	If Not objFso.DriveExists(MODRIVELETTER) Then
		strMessage = UCase(MODRIVELETTER) & "ドライブが存在しません。"
		Exit Do
	End If

	'ドライブオブジェクトの取得
	Set objDrive = objFso.GetDrive(MODRIVELETTER)

	'ドライブの準備ができているかをチェック
	If Not objDrive.IsReady Then
		strMessage = "ドライブの準備ができていません。"
		Exit Do
	End If

	'ステップ２へ
	Response.Redirect "mntImportPersonStep2.asp?dataDiv=" & strDataDiv & "&driveLetter=" & MODRIVELETTER

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
<TITLE>健保データ取り込み</TITLE>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">Step1：取り込みデータの選択</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>取り込みを行うデータを選択してください。<BR><BR>

	<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="3">
		<TR>
			<TD><INPUT TYPE="radio" NAME="dataDiv" VALUE="<%= DATADIV_SELF %>" <%= IIf(strDataDiv = DATADIV_SELF, "CHECKED", "") %>></TD>
			<TD NOWRAP>本人データ</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="dataDiv" VALUE="<%= DATADIV_FAMILY %>" <%= IIf(strDataDiv = DATADIV_FAMILY, "CHECKED", "") %>></TD>
			<TD NOWRAP>家族データ</TD>
		</TR>
	</TABLE>

	<BR>選択されたデータが格納されているＭＯをＫＥＮＳＶ００１サーバにセットし、「次へ」をクリックしてください。<BR><BR><BR>

	<A HREF="/webHains/contents/maintenance/mntMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
	<INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="次へ">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>