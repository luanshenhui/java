<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　満足度・ストレス度チェック画面表示処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem5.inc"-->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objMentalHealth 'メンタルヘルス情報アクセス用

Dim i
Dim j
Dim strCheck
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
strMode = CInt(Request("ModeItem5"))

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
			strTarget = "mhConsulItem4.asp"
		Case MH_Mode_Next
			'次画面に遷移
			strTarget = "mhConsulItem6.asp"
		Case MH_Mode_Result
			'総合評価に遷移
			Session("FromAsp") = "mhConsulItem5.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'セッションにセット
	Session("Refusal5") = Request("Check5")
	For i = 0 To UBound(aryQuestion)
		Session("Q5-" & i + 1) = Request("A5_" & i + 1)
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
<TITLE>あなたの満足度・ストレス度チェック</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn;
	var myForm = document.ConsulItem5;	// 自画面のフォームエレメント
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			if (!myForm.Check5.checked){
				//回答拒否じゃない場合、必須チェック
				for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
					switch (i + 1) {
						case 2:
						case 4:
							//設問２、４必須チェック
							chkOn = false;
							for (j=0; j<eval("myForm.A5_" + i + ".length"); j++) {
								if (eval("myForm.A5_" + (i + 1) + "[" + j + "]" + ".checked")) {
									chkOn  = true
									break;
								}
							}
							
							if (chkOn == false) {
								alert("設問 " + (i + 1) + "に対する回答を選択してください。");
								return;
							}
							break;
						default:
							break;
					}
				}
			}
			break;
		default:
			break;
	}

	//submit
	myForm.ModeItem5.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem5;	// 自画面のフォームエレメント

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}

//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem5" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>5/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>Ⅴ．あなたの満足度・ストレス度チェック</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal5") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check5' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='10'>生活への満足感とストレスについてお伺いします</TD></TR>
<%
For i = 0 To UBound(aryQuestion)%>
	<TR CLASS='question'>
		<TD COLSPAN='9'><%=aryQuestion(i)%>
<%
		If i = 0 Or i = 2 Then
%>
		<A HREF="<%="#A5_" & i + 2%>"><%=PC_Anchor%></A>
<%
		End If
%>
		</TD>
		<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A5_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択解除"></A></TD>
	</TR>
	<TR>
<%
	For j = 0 To 4
		strCheck = ""
		If not isEmpty(Session("Q5-" & i + 1 )) And not isNull(Session("Q5-" & i + 1 )) Then
			If CInt(Session("Q5-" & i + 1 )) = j Then
				strCheck = "CHECKED"
			End If
		End If
%>
		<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A5_" & i + 1%>' VALUE='<%=j%>' <%=strCheck%>></TD>
		<TD WIDTH='150' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
	Next
%>
	</TR>
<%
Next
%>
</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem5"   VALUE="">
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
