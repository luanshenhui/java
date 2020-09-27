<%
Do
	'環境変数HTTP_USER_AGENTのチェック(IE5)
	If InStr(Request.ServerVariables("HTTP_USER_AGENT"), "MSIE 5") > 0 Then
		Exit Do
	End If

	'環境変数HTTP_USER_AGENTのチェック(IE6)
	If InStr(Request.ServerVariables("HTTP_USER_AGENT"), "MSIE 6") > 0 Then
		Exit Do
	End If

	'環境変数HTTP_USER_AGENTのチェック(Netscape6)
	If InStr(Request.ServerVariables("HTTP_USER_AGENT"), "Netscape6") > 0 Then
		Exit Do
	End If

	'認証失敗時は専用ページへ
'	Server.Transfer "/webHains/contents/common/HainsError2.asp"

	Exit Do
Loop
%>
