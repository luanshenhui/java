<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		健保データ取り込み(ファイルの選択) (Ver0.0.1)
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
Const DATADIV_SELF   = "self"		'取り込みデータ区分(本人)
Const DATADIV_FAMILY = "family"		'取り込みデータ区分(家族)

'オブジェクト
Dim objExec			'取り込み処理実行用
Dim objFso			'ファイルシステムオブジェクト
Dim objTempFolder	'フォルダオブジェクト

'引数値
Dim strDataDiv		'取り込みデータ区分
Dim strDriveLetter	'ドライブ文字
Dim strFileName		'取り込みファイル名
Dim strActEnd		'処理が開始済みであれば値が格納される

Dim strImportFile	'取り込みファイル名
Dim strTempFile		'一時ファイル名

Dim strMessage		'エラーメッセージ
Dim strURL			'URL文字列

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strDataDiv     = Request("dataDiv")
strDriveLetter = Request("driveLetter")
strFileName    = Request("fileName")
strActEnd      = Request("actEnd")

Do

	'処理が開始済みであれば何もしない
	If strActEnd <> "" Then
		Exit Do
	End If

	'オブジェクトのインスタンス作成
	Set objFso = CreateObject("Scripting.FileSystemObject")

	'ドライブ文字とファイル名より取り込みファイル名のフルパスを作成
	strImportFile = strDriveLetter & ":\" & strFileName

	'一時ファイルのフォルダを取得
	Set objTempFolder = objFso.GetSpecialFolder(2)
	If objTempFolder Is Nothing Then
		Exit Do
	End If

	'一時ファイル名をランダムに作成
	strTempFile = Server.MapPath("/webHains/Temp") & "\" & strFileName

	'ファイルの複写
	objFso.CopyFile strImportFile, strTempFile, True

	'取り込み処理起動
	Set objExec = Server.CreateObject("HainsCooperation.Exec")
	objExec.Run "cscript " & Server.MapPath("/webHains/script") & "\ImportIsr.vbs " & strDataDiv & " " & strTempFile & " " & Session("USERID")

	'処理完了とする
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?dataDiv="     & strDataDiv
	strURL = strURL & "&driveLetter=" & strDriveLetter
	strURL = strURL & "&fileName="    & strFileName
	strURL = strURL & "&actEnd="      & "actEnd"
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">Step3：起動完了</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>健保<%= IIf(strDataDiv = DATADIV_SELF, "本人", "家族") %>データの取り込み処理を開始しました。詳細はシステムログを参照して下さい。<BR><BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=<%= IIf(strDataDiv = DATADIV_SELF, "LOGISRSLF", "LOGISRFML") %>"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="ログを参照する"></A><BR><BR>
	<A HREF="/webHains/contents/maintenance/mntMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>