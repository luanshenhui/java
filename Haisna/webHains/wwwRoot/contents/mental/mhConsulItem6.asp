<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　喫煙・飲酒チェック画面表示処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem6.inc"-->
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
Dim intRadioCount
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
strMode = CInt(Request("ModeItem6"))

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
			strTarget = "mhConsulItem5.asp"
		Case MH_Mode_Next
			'次画面に遷移
			strTarget = "mhConsulItem7.asp"
		Case MH_Mode_Result
			'総合評価に遷移
			Session("FromAsp") = "mhConsulItem6.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'セッションにセット
	Session("Refusal6") = Request("Check6")
	For i = 0 To UBound(aryQuestion)
		If i = 1 Then
			For j = 1 To 3
				Session("Q6-" & i + 1 & "-" & j) = Request("A6_" & i + 1 & "_" & j)
			Next
		Else
			Session("Q6-" & i + 1) = Request("A6_" & i + 1)
		End If
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
<TITLE>あなたの喫煙・飲酒チェック</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn,ChkSmoke,chkDrink;
	var myForm = document.ConsulItem6;	// 自画面のフォームエレメント
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			if (!myForm.Check6.checked){
				//回答拒否じゃない場合、必須チェック
				//喫煙チェック
				ChkSmoke = -1;
				for (i=0; i<myForm.A6_1.length; i++) {
					if (eval("myForm.A6_1[" + i + "].checked")) {
						ChkSmoke  = i;
						break;
					}
				}
				if (ChkSmoke < 0) {
					alert("喫煙に関する設問 1の回答を選択してください。");
					return;
				}

				if (ChkSmoke == 0) {
					//煙草を吸う場合、設問２～８必須チェック
					//設問２必須チェック
					//喫煙期間チェック
					if (myForm.A6_2_1.value == ""){
						alert("喫煙期間を入力してください。");
						return;
					}
					//喫煙本数チェック
					if (myForm.A6_2_2.value == ""){
						alert("喫煙本数を入力してください。");
						return;
					}
					//銘柄チェック
					chkOn = false;
					for (j=0; j<myForm.A6_2_3.length; j++) {
						if (eval("myForm.A6_2_3[" + j + "].checked")) {
							chkOn  = true;
							break;
						}
					}
					
					if (chkOn == false) {
						alert("主なタバコの銘柄を選択してください。");
						return;
					}

					for (i=3; i<=8; i++) {
						//設問３～８必須チェック
						chkOn = false;
						for (j=0; j<eval("myForm.A6_" + i + ".length"); j++) {
							if (eval("myForm.A6_" + i + "[" + j + "]" + ".checked")) {
								chkOn  = true;
								break;
							}
						}
						
						if (chkOn == false) {
							alert("喫煙に関する設問 " + i + "の回答を選択してください。");
							return;
						}
					}
				}
			}
			//if (myForm.A6_2_1.value != "" && !myForm.A6_2_1.value.match('^[0-9]+$')) {
			if (myForm.A6_2_1.value  != "" && isNaN(Number(myForm.A6_2_1.value))) {
				alert("喫煙期間には、数値を入力して下さい。");
				return;
			}
			//if (myForm.A6_2_2.value != "" && ! myForm.A6_2_2.value.match('^[0-9]+$')) {
				if (myForm.A6_2_2.value != "" && isNaN(Number(myForm.A6_2_2.value))) {
				alert("喫煙本数には、数値を入力して下さい。");
				return;
			}

			if (!myForm.Check6.checked){
				//飲酒チェック
				chkDrink = -1;
				for (i=0; i<myForm.A6_9.length; i++) {
					if (eval("myForm.A6_9[" + i + "].checked")) {
						chkDrink  = i;
						break;
					}
				}
				if (chkDrink < 0) {
					alert("飲酒に関する設問 1の回答を選択してください。");
					return;
				}

				if (chkDrink > 0) {
					//飲酒をする場合、設問１０～１８必須チェック
					for (i=10; i<=18; i++) {
						//設問１０～１８必須チェック
						chkOn = false;
						for (j=0; j<eval("myForm.A6_" + i + ".length"); j++) {
							if (eval("myForm.A6_" + i + "[" + j + "]" + ".checked")) {
								chkOn  = true;
								break;
							}
						}
						
						if (chkOn == false) {
							alert("飲酒に関する設問 " + (i - 8) + "の回答を選択してください。");
							return;
						}
					}
				}
			}
			break;
		default:
			break;
	}

	//submit
	myForm.ModeItem6.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem6;	// 自画面のフォームエレメント

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}

//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem6" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>6/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>Ⅵ．あなたの喫煙・飲酒チェック</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal6") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check6' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='10'>喫煙についてお伺いします</TD></TR>
<%
For i = 0 To UBound(aryQuestion)
	'ヘッダー設定
	Select case i + 1
		Case 2
%>
			<TR CLASS='head'><TD COLSPAN='10'>１）にチェックを付けた方にお伺いします　<A HREF="#DrinkHead" CLASS="headA">２）または３）の方はここをクリックして飲酒に進んでください</A></TD></TR>
<%
		Case 9
%>
			<TR CLASS='head'><TD COLSPAN='10'><A NAME="DrinkHead"> 次に、飲酒についてお伺いします</TD></TR>
<%
		Case 10
%>
			<TR CLASS='head'><TD COLSPAN='10'>お酒を飲まない方は、<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)" CLASS="headA">ここをクリックしてⅦに進んでください</A></TD></TR>
<%
	End Select

	'ラジオボタンMAX数設定
	intRadioCount = 0

	Select case i + 1
		Case 1,2,5,8,17,18
			intRadioCount = 3
		Case 3,4,6,7
			intRadioCount = 2
		Case Else
			intRadioCount = 5
	End Select

	Select case i + 1
		Case 1			'設問１
			'ラジオボタン縦ならび
%>
			<TR CLASS='question'>
				<TD COLSPAN='9'><%=aryQuestion(i)%></TD>
				<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A6_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択解除"></A></TD>
			</TR>
<%
			For j = 0 To intRadioCount - 1
				strCheck = ""
				If not isEmpty(Session("Q6-" & i + 1 )) And not isNull(Session("Q6-" & i + 1 )) Then
					If CInt(Session("Q6-" & i + 1 )) = j + 1 Then
						strCheck = "CHECKED"
					End If
				End If
%>
				<TR><TD COLSPAN='10' NOWRAP><INPUT TYPE='radio' NAME='<%="A6_" & i + 1%>' VALUE='<%=j + 1%>' <%=strCheck%>>
					<%=aryAnswer(i,j)%></TD>
				</TR>
<%
			Next

		Case 2			'設問２
			'テキスト表示
			strValue = ""
			If not isEmpty(Session("Q6-" & i + 1 & "-1")) Then
				strValue = Session("Q6-" & i + 1 & "-1")
			End If
%>
			<TR CLASS='question'>
				<TD COLSPAN='9'><%=aryQuestion(i)%></TD>
				<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A6_" & i + 1 & "_3"%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択解除"></A></TD>
			</TR>
			<TR>
			<TD COLSPAN='2' NOWRAP>喫煙期間<INPUT TYPE='text' NAME='<%="A6_" & i + 1 & "_1"%>' MAXLENGTH='5' VALUE='<%=strValue%>' SIZE='5' ISTYLE='4'>年間</TD>
<%
			strValue = ""
			If not isEmpty(Session("Q6-" & i + 1 & "-2")) Then
				strValue = Session("Q6-" & i + 1 & "-2")
			End If
%>
			<TD COLSPAN='2' NOWRAP>喫煙本数<INPUT TYPE='text' NAME='<%="A6_" & i + 1 & "_2"%>' MAXLENGTH='5' VALUE='<%=strValue%>' SIZE='5' ISTYLE='4'>本</TD>
			</TR>
<%
			'ラジオボタン縦ならび
			For j = 0 To intRadioCount - 1
				strCheck = ""
				If not isEmpty(Session("Q6-" & i + 1 & "-3")) And not isNull(Session("Q6-" & i + 1 & "-3")) Then
					If CInt(Session("Q6-" & i + 1 & "-3")) = j + 1 Then
						strCheck = "CHECKED"
					End If
				End If
%>
				<TR><TD COLSPAN='10' NOWRAP><INPUT TYPE='radio' NAME='<%="A6_" & i + 1 & "_3"%>' VALUE='<%=j + 1%>' <%=strCheck%>>
					<%=aryAnswer(i,j)%></TD>
				</TR>
<%
			Next

		Case Else	'ラジオボタン横ならび
%>
			<TR CLASS='question'>
				<TD COLSPAN='9'><%=aryQuestion(i)%></TD>
				<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A6_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択解除"></A></TD>
			</TR>
			<TR>
<%
			For j = 0 To intRadioCount - 1
				strCheck = ""
				If not isEmpty(Session("Q6-" & i + 1 )) And not isNull(Session("Q6-" & i + 1 )) Then
					If CInt(Session("Q6-" & i + 1 )) = j + 1 Then
						strCheck = "CHECKED"
					End If
				End If
%>
				<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A6_" & i + 1%>' VALUE='<%=j + 1%>' <%=strCheck%>></TD>
				<TD WIDTH='160' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
			Next
%>
			</TR>
<%
	End Select
Next
%>
</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem6"   VALUE="">
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
