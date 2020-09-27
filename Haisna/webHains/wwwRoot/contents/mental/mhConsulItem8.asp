<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　社会的支援チェック画面表示処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem8.inc"-->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objMentalHealth 'メンタルヘルス情報アクセス用

Dim i
Dim j
Dim strCheck
Dim strValue
Dim strTarget
Dim arrQuestion()	'全質問項目名
Dim arrAnswer()		'全回答

'受け取りパラメータ
Dim lngRsvNo	'予約番号
Dim strMode		'選択されたアクション

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'パラメータ取得
lngRsvNo = Request("RSVNO")
strMode = CInt(Request("ModeItem8"))

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
			strTarget = "mhConsulItem7.asp"
		Case MH_Mode_Next
			'次画面に遷移
			strTarget = "mhConsulItem9.asp"
		Case MH_Mode_Result
			'総合評価に遷移
			Session("FromAsp") = "mhConsulItem8.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'セッションにセット
	Session("Refusal8") = Request("Check8")
	For i = 0 To UBound(aryQuestion)
		For j = 1 To 2
			Session("Q8-" & i + 1 & "-" & j) = Request("A8_" & i + 1 & "_" & j)
		Next
	Next
	
	If strMode = MH_Mode_Result Then
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

	'リダイレクト
	Response.Redirect strTarget & "?RSVNO=" & lngRsvNo

	Exit Do
Loop

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">

<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>あなたの社会的支援チェック</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn;
	var myForm = document.ConsulItem8;	// 自画面のフォームエレメント
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			//回答拒否じゃない場合、必須チェック
			for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
				if (!myForm.Check8.checked){
					//必須チェック
					//テキスト入力チェック
					if (eval("myForm.A8_" + (i + 1) + "_1.value") == ""){
						alert("設問 " + (i + 1) + "に対する人数を入力してください。");
						return;
					}
					
					if (eval("myForm.A8_" + (i + 1) + "_1.value") != 0) {
						//ラジオボタンチェック
						chkOn = false;
						for (j=0; j<eval("myForm.A8_" + (i + 1) + "_2.length"); j++) {
							if (eval("myForm.A8_" + (i + 1) + "_2[" + j + "]" + ".checked")) {
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
				//テキストフォーマットチェック
				//if (eval("myForm.A8_" + (i + 1) + "_1.value") != "" && ! eval("myForm.A8_" + (i + 1) + "_1.value.match('^[0-9]+$')") ) {
				if (eval("myForm.A8_" + (i + 1) + "_1.value") != "" && isNaN(Number(eval("myForm.A8_" + (i + 1) + "_1.value")))) {
					alert("設問 " + (i + 1) + "に対する人数には、数値を入力して下さい。");
					return;
				}
			}
			
			break;
		default:
			break;
	}

	//submit
	myForm.ModeItem8.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem8;	// 自画面のフォームエレメント

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem8" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>8/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>Ⅷ．あなたの社会的支援チェック</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal8") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check8' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='12'>あなたの周囲の人々についてお伺いします</TD></TR>
<%
For i = 0 To UBound(aryQuestion)
%>
	<TR CLASS='question'>
		<TD COLSPAN='11'><%=aryQuestion(i)%></TD>
		<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A8_" & i + 1 & "_2"%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択解除"></A></TD>
	</TR>
	<TR>
<%
		strValue = ""
		If not isEmpty(Session("Q8-" & i + 1 & "-1")) Then
			strValue = Session("Q8-" & i + 1 & "-1")
		End If
%>
		<TD COLSPAN='12' NOWRAP><INPUT TYPE='text' NAME='<%="A8_" & i + 1 & "_1"%>' MAXLENGTH='5' VALUE='<%=strValue%>' SIZE='5' ISTYLE='4'>人</TD>
	</TR>
	<TR><TD COLSPAN='12' NOWRAP>こうした人々によって得られるサポートに満足していますか</TD></TR>
	<TR>
<%
		For j = 0 To UBound(aryAnswer)
			strCheck = ""
			If not isEmpty(Session("Q8-" & i + 1 & "-2")) And not isNull(Session("Q8-" & i + 1 & "-2")) Then
				If CInt(Session("Q8-" & i + 1 & "-2")) = j + 1 Then
					strCheck = "CHECKED"
				End If
			End If
%>
			<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A8_" & i + 1 & "_2"%>' VALUE='<%=j + 1%>' <%=strCheck%>></TD>
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
<INPUT TYPE="hidden" NAME="ModeItem8"   VALUE="">
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
