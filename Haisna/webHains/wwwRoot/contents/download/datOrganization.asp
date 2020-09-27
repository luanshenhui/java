<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		団体情報の抽出 (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/download.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strMode				'処理モード(抽出実行:"edit")

'制御用
Dim objOrganization		'団体テーブルアクセス用COMオブジェクト
Dim strFileName			'出力CSVファイル名
Dim strDownloadFile		'ダウンロードファイル名
Dim strArrMessage		'エラーメッセージ(全体)
Dim lngMessageStatus	'メッセージステータス(MessageType:NORMAL or WARNING)
Dim lngCount			'出力データ件数

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------

'CSVファイル格納パス設定
strDownloadFile   = CSV_DATAPATH & CSV_ORGANIZATION		'ダウンロードファイル名セット
strFileName       = Server.MapPath(strDownloadFile)		'CSVファイル名セット

strMode           = Request("mode") & ""				'処理モードの取得

'オブジェクトのインスタンス作成
Set objOrganization = Server.CreateObject("HainsCsvOrganization.CsvOrganization")

'CSVファイル編集処理の制御
Do

	'「抽出処理を実行」押下時
	If strMode = "edit" Then

		'CSVファイルの編集
		lngCount = objOrganization.EditCSVDatOrg(strFileName)

		'データがあればダウンロード、無ければメッセージをセット
		If lngCount > 0 Then
			Response.ContentType = "application/x-download"
			Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
			Response.AddHeader "Content-Disposition","filename=" & CSV_ORGANIZATION
			Server.Execute strDownloadFile
			Response.End
		Else
			ReDim strArrMessage(0)
			strArrMessage(0) = "指定のデータはありませんでした。"
			lngMessageStatus = MESSAGETYPE_NORMAL
		End If

	End If

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
<TITLE>団体情報の抽出</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// 再表示
function redirectPage( actionmode ) {

	document.entryCondition.mode.value = actionmode;		/* 動作モード設定 */
	document.entryCondition.submit();						/* 自身へ送信 */

	return false;

}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">■</SPAN><FONT COLOR="#000000">団体情報の抽出</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'メッセージの編集
	Call EditMessage(strArrMessage, lngMessageStatus)
%>
	<BR>

	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>    
        <A HREF="javascript:function voi(){};voi()" ONCLICK="return redirectPage('edit')"><IMG SRC="/webHains/images/DataSelect.gif"></A>
    <%  end if  %>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
