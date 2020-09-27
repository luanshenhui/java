<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　対処行動・社会的支援チェック画面表示処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem12.inc"-->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objMentalHealth 'メンタルヘルス情報アクセス用

'受け取りパラメータ
Dim lngRsvNo	'予約番号
Dim strMode		'選択されたアクション

Dim i
Dim j
Dim strCheck
Dim strTarget
Dim arrQuestion()	'全質問項目名
Dim arrAnswer()		'全回答
Dim lngLockDiv

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'パラメータ取得
lngRsvNo = Request("RSVNO")
strMode = CInt(Request("ModeItem12"))

'ログインチェック
If LoginCheck(lngRsvNo) = False Then
	Response.Redirect "mhError.asp"
End If

'オブジェクトのインスタンス作成
Set objMentalHealth = Server.CreateObject("HainsMentalHealth.MentalHealth")

Do
	Select Case strMode
		Case MH_Mode_Back
			'前画面に戻る
			strTarget = "mhConsulItem11.asp"
		Case MH_Mode_Next
			'次画面に遷移
			strTarget = "mhResult.asp"
		Case MH_Mode_Result
			'総合評価に遷移
			Session("FromAsp") = "mhConsulItem12.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'セッションにセット
	Session("Refusal12") = Request("Check12")
	For i = 0 To UBound(aryQuestion)
		Session("Q12-" & i + 1) = Request("A12_" & i + 1)
	Next

	If strMode = MH_Mode_Next Or strMode = MH_Mode_Result Then
		'クライアントロック区分取得
		lngLockDiv = objMentalHealth.SelectClientPermission(Session("RsvNo"))
		If lngLockDiv < 0 Then
			'エラー
			Session("ErrorMsg1") = "クライアントロック情報の取得に失敗しました"
			Session("ErrorMsg2") = "申し訳ありませんが、サポート担当者までご連絡ください"
			Response.Redirect "mhError.asp"
		ElseIf lngLockDiv = 2 And Session("LoginDiv") = 0 Then
			'パーミッションなし
			Session("ErrorMsg1") = "現在、メンタルヘルス情報を参照・変更することはできません"
			Session("ErrorMsg2") = "メンタルヘルス情報を参照・変更したい場合は、担当医にご相談ください"
			Response.Redirect "mhError.asp"
		Else
			'セッションを構造体にセット
			If SetUpdateArray(arrQuestion, arrAnswer) = False Then
			End if
			'ＤＢ更新処理
			If objMentalHealth.InsertControlMentalHealth(Session("RsvNo"), arrQuestion, arrAnswer) = False Then
				'エラー
				Session("ErrorMsg1") = "メンタルヘルス情報の更新に失敗しました"
				Session("ErrorMsg2") = "申し訳ありませんが、サポート担当者までご連絡ください"
				Response.Redirect "mhError.asp"
			End If
		End If
	End If
	
	'リダイレクト
	Response.Redirect strTarget & "?RSVNO=" & lngRsvNo

	Exit Do
Loop

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">

<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>あなたの対処行動・社会的支援チェック</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn;
	var myForm = document.ConsulItem12;	// 自画面のフォームエレメント
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			if (!myForm.Check12.checked){
				//回答拒否じゃない場合、必須チェック
				for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
					//必須チェック
					chkOn = false;
					for (j=0; j<eval("myForm.A12_" + (i + 1) + ".length"); j++) {
						if (eval("myForm.A12_" + (i + 1) + "[" + j + "]" + ".checked")) {
							chkOn  = true
							break;
						}
					}
					
					if (chkOn == false) {
						alert("設問 " + (i + 1) + "に対する回答を選択してください。");
						return;
					}
				}
			}
			break;
		default:
			break;
	}

	//submit
	myForm.ModeItem12.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem12;	// 自画面のフォームエレメント

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem12" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>12/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>XII．あなたの対処行動・社会的支援チェック</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal12") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check12' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='12'>次に、ストレスへの対処法が書かれていますが、実際に用いているかどうかを評価してください</TD></TR>
<%
For i = 0 To UBound(aryQuestion)
%>
	<TR CLASS='question'>
		<TD COLSPAN='11'><%=aryQuestion(i)%></TD>
		<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A12_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択解除"></A></TD>
	</TR>
	<TR>
<%
	For j = 0 To UBound(aryAnswer)
		strCheck = ""
		If not isEmpty(Session("Q12-" & i + 1 )) And not isNull(Session("Q12-" & i + 1 )) Then
			If CInt(Session("Q12-" & i + 1 )) = j + 1 Then
				strCheck = "CHECKED"
			End If
		End If
%>
		<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A12_" & i + 1%>' VALUE='<%=j + 1%>' <%=strCheck%>></TD>
		<TD WIDTH='125' NOWRAP><%=aryAnswer(j)%></TD>
<%
	Next
%>
	</TR>
<%
Next
%>
</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem12"   VALUE="">
<INPUT TYPE="hidden" NAME="RSVNO"       VALUE="<%=lngRsvNo%>">

<%If Session("LoginDiv") = 1 Then%>
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Result%>)"><IMG SRC=<%=MH_ImagePath & "result.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="総合評価"></A>
<%End If%>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Clear%>)"><IMG SRC=<%=MH_ImagePath & "clear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="クリア"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Back%>)"><IMG SRC=<%=MH_ImagePath & "back.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)"><IMG SRC=<%=MH_ImagePath & "next.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="次へ"></A>
</FORM>
</CENTER>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>
