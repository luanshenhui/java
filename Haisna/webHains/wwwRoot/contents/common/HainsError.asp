<%@ language="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		HainsError画面表示 (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@FSIT
'-----------------------------------------------------------------------------
  Option Explicit

  Const lngMaxFormBytes = 200

  Dim objASPError, blnErrorWritten, strServername, strServerIP, strRemoteIP
  Dim strMethod, lngPos, datNow, strQueryString, strURL

  If Response.Buffer Then
    Response.Clear
    Response.Status = "500 Internal Server Error"
    Response.ContentType = "text/html"
    Response.Expires = 0
  End If

  Set objASPError = Server.GetLastError
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>ページを表示できません</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<DIV ALIGN="center">
<BR><BR><BR>
<IMG SRC="/webHains/images/error.gif" ALT="ページを表示できません">
<BR><BR><BR>

<%
Dim bakCodepage
Dim strWorkMessage

On Error Resume Next

bakCodepage = Session.Codepage
Session.Codepage = 1252

On Error GoTo 0

	If objASPError.ASPDescription > "" Then
		Response.Write "<FONT SIZE=""3"">" & Server.HTMLEncode(objASPError.ASPDescription) & "</FONT><br>"
	ElseIf (objASPError.Description > "") Then
		Response.Write "<BR><FONT COLOR=""#EC6B76""><B>" & Server.HTMLEncode(objASPError.Description) & "</B></FONT><br><br><br><br><br>"
	End If

	Response.Write "<FONT COLOR=""#CCCCCC"">"

	'実行時エラーと表示されると感じ悪いのでコメントアウト
'	Response.Write Server.HTMLEncode(objASPError.Category)

	If objASPError.ASPCode > "" Then
		Response.Write Server.HTMLEncode(", " & objASPError.ASPCode)
	End If
	Response.Write Server.HTMLEncode(" (0x" & Hex(objASPError.Number) & ")" ) & "<br>"

	blnErrorWritten = False

	' Only show the Source if it is available and the request is from the same machine as IIS
	If objASPError.Source > "" Then

		strServername = LCase(Request.ServerVariables("SERVER_NAME"))
		strServerIP   = Request.ServerVariables("LOCAL_ADDR")
		strRemoteIP   = Request.ServerVariables("REMOTE_ADDR")

		If (strServername = "localhost" Or strServerIP = strRemoteIP) And objASPError.File <> "?" Then

			Response.Write Server.HTMLEncode(objASPError.File)

			If objASPError.Line > 0 Then
				Response.Write ", line " & objASPError.Line
			End If

			If objASPError.Column > 0 Then
				Response.Write ", column " & objASPError.Column
			End If

			Response.Write "<br>"
			Response.Write "<font style=""COLOR:000000; FONT: 8pt/11pt ＭＳ ゴシック""><b>"
			Response.Write Server.HTMLEncode(objASPError.Source) & "<br>"

			If objASPError.Column > 0 Then
				Response.Write String((objASPError.Column - 1), "-") & "^<br>"
			End If

			Response.Write "</b></font>"
			blnErrorWritten = True
		End If
	End If

If Not blnErrorWritten And objASPError.File <> "?" Then

	Response.Write "<b>" & Server.HTMLEncode(  objASPError.File)

    If objASPError.Line > 0 Then
		Response.Write Server.HTMLEncode(", line " & objASPError.Line)
	End If

    If objASPError.Column > 0 Then
		Response.Write ", column " & objASPError.Column
	End If

	Response.Write "</b><br>"
End If
%>

<p>
ブラウザ タイプ<br>
<%= Request.ServerVariables("HTTP_USER_AGENT") %>
<p>
ページ<br>
<%
  strMethod = Request.ServerVariables("REQUEST_METHOD")

  Response.Write strMethod & " "

  If strMethod = "POST" Then
    Response.Write Request.TotalBytes & " bytes to "
  End If

  Response.Write Request.ServerVariables("SCRIPT_NAME")

  lngPos = InStr(Request.QueryString, "|")

  If lngPos > 1 Then
    Response.Write "?" & Left(Request.QueryString, (lngPos - 1))
  End If

  If strMethod = "POST" Then
    Response.Write "<p>POST Data:<br>"
    If Request.TotalBytes > lngMaxFormBytes Then
       Response.Write Server.HTMLEncode(Left(Request.Form, lngMaxFormBytes)) & " . . ."
    Else
      Response.Write Server.HTMLEncode(Request.Form)
    End If
  End If


%>

<BR><BR>時刻<br>
<%
  datNow = Now()

 Response.Write Server.HTMLEncode(FormatDateTime(datNow, 1) & ", " & FormatDateTime(datNow, 3))
  on error resume next
	  Session.Codepage = bakCodepage 
  on error goto 0

	Response.Write "</FONT>"

%>

</DIV>
</body>
</html>
