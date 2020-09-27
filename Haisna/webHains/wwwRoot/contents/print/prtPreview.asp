<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		印刷(プレビュー) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/print.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim strFileName		'ファイル名

Dim lngPos			'検索用変数
Dim strExtension	'拡張子

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
strFileName = Request("documentFileName")

lngPos = InStrRev(strFileName, ".")
If lngPos > 0 Then
	strExtension = UCase(Mid(strFileName, lngPos + 1))
End If

'cidファイルでなければ
If strExtension <> "CID" Then


'##2004.08.27 UPD STR ORB)A.NAGUMO 拡張子xlsもダウンロードさせる
	'ダウンロードさせる
'	Response.ContentType = "application/x-download"
'	Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
'	Response.AddHeader "Content-Disposition","filename=" & strFileName
'	Server.Execute PRT_TEMPPATH & strFileName
'	Response.End

	If strExtension = "CSV" Then
		'ダウンロードさせる
		Response.ContentType = "application/x-download"
		Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
		Response.AddHeader "Content-Disposition","filename=" & strFileName
		Server.Execute PRT_TEMPPATH & strFileName
		Response.End
	ElseIf strExtension = "XLS" Then
		'ダウンロードさせる
		Response.ContentType = "application/octet-stream"
		Response.AddHeader "Content-Disposition","attachment;filename=" & strFileName
		Server.Execute PRT_TEMPPATH & strFileName
		Response.End
	ElseIf strExtension = "TXT" Then
		'ダウンロードさせる
		Response.ContentType = "application/x-download"
		Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
		Response.AddHeader "Content-Disposition","filename=" & strFileName
		Server.Execute PRT_TEMPPATH & strFileName
		Response.End
	End If
'##2004.08.27 UPD END ORB)A.NAGUMO

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>印刷プレビュー</TITLE>
</HEAD>
<BODY>
<DIV ALIGN="center">
<OBJECT WIDTH="100%" height="100%" CLASSID="clsid:17CFC248-FB93-4136-AFBF-B982F0D54198" CODEBASE="/webHains/cab/ViewCtrl/CrViewU.cab#version=9,0,1,10">
	<PARAM NAME="DocumentFileName" VALUE="http://<%= Request.ServerVariables("SERVER_NAME") & ":" & Request.ServerVariables("SERVER_PORT") & PRT_TEMPPATH & strFileName %>">
	<PARAM NAME="ShowToolBars"     VALUE="7">
</OBJECT>
</DIV>
</BODY>
</HTML>
