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
Const DATADIV_SELF   = "self"	'取り込みデータ区分(本人)
Const DATADIV_FAMILY = "family"	'取り込みデータ区分(家族)

'オブジェクト
Dim objFso			'ファイルシステムオブジェクト
Dim objFolder		'フォルダオブジェクト
Dim colFile			'ファイルコレクション
Dim objFile			'ファイルオブジェクト

'引数値
Dim strDataDiv		'取り込みデータ区分
Dim strDriveLetter	'ドライブ文字

Dim strMessage		'エラーメッセージ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strDataDiv     = Request("dataDiv")
strDriveLetter = Request("driveLetter")

'オブジェクトのインスタンス作成
Set objFso = CreateObject("Scripting.FileSystemObject")

'一覧表示対象となるフォルダ(ここではドライブのルートフォルダ)オブジェクトを取得
Set objFolder = objFso.GetFolder(strDriveLetter & ":\")

'ファイルコレクションの参照設定
Set colFile = objFolder.Files
If colFile.Count = 0 Then
	strMessage = "取り込みファイルが存在しません。"
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>健保データ取り込み</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function importFile( fileName ) {

	var url;	// URL文字列

	if ( !confirm( '選択されたデータを取り込みます。よろしいですか？' ) ) {
		return;
	}

	url = 'mntImportPerson.asp';
	url = url + '?dataDiv=<%= strDataDiv %>';
	url = url + '&driveLetter=<%= strDriveLetter %>';
	url = url + '&fileName=' + fileName;
	location.href = url;

}
//-->
</SCRIPT>
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">Step2：取り込みファイルの選択</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)

	If colFile.Count > 0 Then
%>
		<BR>取り込みを行う健保<%= IIf(strDataDiv = DATADIV_SELF, "本人", "家族") %>データファイルを選択してください。<BR><BR>

		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
<%
		For Each objFile In objFolder.Files
%>
			<TR>
				<TD WIDTH="30"></TD>
				<TD NOWRAP><A HREF="javascript:importFile('<%= objFile.Name %>')"><%= objFile.Name %></A></TD>
			</TR>
<%
		Next
%>
		</TABLE>
<%
	End If
%>
	<BR><BR><A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="戻る"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>