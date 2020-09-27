<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<%
If InStr(Request.ServerVariables("HTTP_USER_AGENT"), "MSIE") > 0 Then
	Response.Write "<BASEFONT SIZE=""2"">"
Else
	Response.Write "<BASEFONT SIZE=""3"">"
End If
%>
