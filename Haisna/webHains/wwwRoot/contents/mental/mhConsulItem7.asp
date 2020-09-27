<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　食事・運動チェック画面表示処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem7.inc"-->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objMentalHealth 'メンタルヘルス情報アクセス用

Dim i
Dim j
Dim k
Dim strCheck
Dim strValue
Dim strTarget
Dim intMaxLoopCount
Dim intMaxQuestion
Dim intMaxItem
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
strMode = CInt(Request("ModeItem7"))

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
			strTarget = "mhConsulItem6.asp"
		Case MH_Mode_Next
			'次画面に遷移
			strTarget = "mhConsulItem8.asp"
		Case MH_Mode_Result
			'総合評価に遷移
			Session("FromAsp") = "mhConsulItem7.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'セッションにセット
	Session("Refusal7") = Request("Check7")

	For i = 0 To UBound(aryQuestion)
		intMaxQuestion = 0
		intMaxItem = 0
		Select case i + 1
			Case 11
				intMaxQuestion = 2
				intMaxItem = 5
			Case 13,14
				intMaxQuestion = 2
				intMaxItem = 3
			Case 15
				intMaxQuestion = 5
				intMaxItem = 2
		End Select

		If intMaxQuestion > 0 Then
			'１つの設問に複数回答欄のある場合
			For j = 1 To intMaxQuestion
				For k = 1 To intMaxItem
					Session("Q7-" & i + 1 & "-" & j & "-" & k ) = Request("A7_" & i + 1 & "_" & j & "_" & k )
				Next
			Next
		Else
			Session("Q7-" & i + 1) = Request("A7_" & i + 1)
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
<TITLE>あなたの食事・運動チェック</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn,chkAct,chkWalk;
	var	strMsg
	var myForm = document.ConsulItem7;	// 自画面のフォームエレメント

	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			//回答拒否じゃない場合、必須チェック
			chkAct = false;
			for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
				switch (i + 1) {
					case 1:case 2:case 3:case 4:case 5:case 6:case 7:case 8:
					case 9:case 10:case 12:case 16:
						if (!myForm.Check7.checked){
							//ラジオボタン必須チェック
							chkOn = false;
							for (j=0; j<eval("myForm.A7_" + (i + 1) + ".length"); j++) {
								if (eval("myForm.A7_" + (i + 1) + "[" + j + "]" + ".checked")) {
									chkOn  = true
									if ((i + 1) == 12 && j == 0) {
										//定期的に運動している
										chkAct = true;
									}
									break;
								}
							}
							
							if (chkOn == false) {
								if ((i + 1) > 10){
									alert( "運動についての" + "設問 " + ((i + 1) - 10) + "に対する回答を選択してください。");
								}else{
									alert( "食生活についての" + "設問 " + (i + 1) + "に対する回答を選択してください。");
								}
								return;
							}
						}
						break;
					case 11:
						//条件に関わらず、入力されている場合、数値チェック
						for (j=1; j<=2; j++) {
							//if (eval("myForm.A7_" + (i + 1) + "_" + j + "_2.value" ) != "" && ! eval("myForm.A7_" + (i + 1) + "_" + j + "_2.value.match('^[0-9]+$')" )) {
							if (eval("myForm.A7_" + (i + 1) + "_" + j + "_2.value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_2.value" )))) {
							
								alert("過去に定期的、継続的に行なっている運動種目の時期には、数値を入力して下さい。");
								return;
							}
							//if (eval("myForm.A7_" + (i + 1) + "_" + j + "_3.value" ) != "" && ! eval("myForm.A7_" + (i + 1) + "_" + j + "_3.value.match('^[0-9]+$')" )) {
							if (eval("myForm.A7_" + (i + 1) + "_" + j + "_3.value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_3.value" )))) {
								alert("過去に定期的、継続的に行なっている運動種目の時期には、数値を入力して下さい。");
								return;
							}
							//if (eval("myForm.A7_" + (i + 1) + "_" + j + "_4.value" ) != "" && ! eval("myForm.A7_" + (i + 1) + "_" + j + "_4.value.match('^[0-9]+$')" )) {
							if (eval("myForm.A7_" + (i + 1) + "_" + j + "_4.value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_4.value" )))) {
								alert("過去に定期的、継続的に行なっている運動種目の頻度には、数値を入力して下さい。");
								return;
							}
							//if (eval("myForm.A7_" + (i + 1) + "_" + j + "_5.value" ) != "" && ! eval("myForm.A7_" + (i + 1) + "_" + j + "_5.value.match('^[0-9]+$')" )) {
							if (eval("myForm.A7_" + (i + 1) + "_" + j + "_5.value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_5.value" )))) {
								alert("過去に定期的、継続的に行なっている運動種目の運動時間には、数値を入力して下さい。");
								return;
							}
						}
						break;
					case 13:
						for (j=1; j<=3; j++) {
							//定期的に行なっている運動必須チェック
							if (!myForm.Check7.checked && chkAct == true){
								//設問１２で”はい”の場合のみ
								if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value") == ""){
									switch (j) {
										case 1:
											strMsg = "現在定期的に行なっている運動種目を入力してください。";
											break;
										case 2:
											strMsg = "現在定期的に行なっている運動種目の頻度を入力してください。";
											break;
										case 3:
											strMsg = "現在定期的に行なっている運動種目の運動時間を入力してください。";
											break;
									}
									alert(strMsg);
									return;
								}
							}
							if (j > 1) {
								//条件に関わらず、入力されている場合、数値チェック
								//if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value" ) != "" && !eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value.match('^[0-9]+$')" )) {
								if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value" )))) {
									if (j == 2){
										alert("現在定期的に行なっている運動種目の頻度には、数値を入力して下さい。");
									}else{
										alert("現在定期的に行なっている運動種目の運動時間には、数値を入力して下さい。");
									}
									return;
								}
								//if (eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value" ) != "" && !eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value.match('^[0-9]+$')" )) {
								if (eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value"  ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value"  )))) {
									if (j == 2){
										alert("現在定期的に行なっている運動種目の頻度には、数値を入力して下さい。");
									}else{
										alert("現在定期的に行なっている運動種目の運動時間には、数値を入力して下さい。");
									}
									return;
								}
							}
						}
						break;
					case 14:
						if (!myForm.Check7.checked){
							//歩行・歩行時間・歩行距離いずれか必須チェック
							chkWalk = -1;
							for (j=1; j<=3; j++) {
								if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value") != ""){
									chkWalk = j;
									break;
								}
							}
							if (chkWalk < 0) {
								alert( "平日の歩行・歩行時間・歩行距離いずれかに入力してください。");
								return;
							}
							
							//上記で入力された項目に対応する休日項目を必須チェック
							if (eval("myForm.A7_" + (i + 1) + "_2_" + chkWalk + ".value") == ""){
								switch (chkWalk) {
									case 1:
										strMsg = "休日の歩行を入力してください。";
										break;
									case 2:
										strMsg = "休日の歩行時間を入力してください。";
										break;
									case 3:
										strMsg = "休日の歩行距離を入力してください。";
										break;
								}
								alert(strMsg);
								return;
							}
							
						}

						//条件に関わらず、入力されている場合、数値チェック
						for (j=1; j<=3; j++) {
							if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value") != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value")))) {
								switch (j) {
									case 1:
										strMsg = "平日の歩行には、数値を入力して下さい。";
										break;
									case 2:
										strMsg = "平日の歩行時間には、数値を入力して下さい。";
										break;
									case 3:
										strMsg = "平日の歩行距離には、数値を入力して下さい。";
										break;
								}
								alert(strMsg);
								return;
							}
							if (eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value") != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value")))) {
								switch (j) {
									case 1:
										strMsg = "休日の歩行には、数値を入力して下さい。";
										break;
									case 2:
										strMsg = "休日の歩行時間には、数値を入力して下さい。";
										break;
									case 3:
										strMsg = "休日の歩行距離には、数値を入力して下さい。";
										break;
								}
								alert(strMsg);
								return;
							}
						}
						break;
					case 15:
						//活動に費やした時間必須チェック
						for (j=1; j<=5; j++) {
							for (k=1; k<=2; k++) {
								if (!myForm.Check7.checked){
									if (eval("myForm.A7_" + (i + 1) + "_" + j + "_" + k + ".value") == ""){
										if (k == 1){
											strMsg = "平日、";
										}else{
											strMsg = "休日、";
										}
										switch (j) {
											case 1:
												strMsg += "激しい活動に費やした時間を入力してください。";
												break;
											case 2:
												strMsg += "中程度の活動に費やした時間を入力してください。";
												break;
											case 3:
												strMsg += "軽い活動に費やした時間を入力してください。";
												break;
											case 4:
												strMsg += "座ったままの生活に費やした時間を入力してください。";
												break;
											case 5:
												strMsg += "睡眠に費やした時間を入力してください。";
												break;
										}
										alert(strMsg);
										return;
									}
								}

								//条件に関わらず、入力されている場合、数値チェック
								if (eval("myForm.A7_" + (i + 1) + "_" + j + "_" + k + ".value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_" + k + ".value" )))) {
									if (k == 1){
										strMsg = "平日、";
									}else{
										strMsg = "休日、";
									}
									switch (j) {
										case 1:
											strMsg += "激しい活動に費やした時間には、数値を入力して下さい。";
											break;
										case 2:
											strMsg += "中程度の活動に費やした時間には、数値を入力して下さい。";
											break;
										case 3:
											strMsg += "軽い活動に費やした時間には、数値を入力して下さい。";
											break;
										case 4:
											strMsg += "座ったままの生活に費やした時間には、数値を入力して下さい。";
											break;
										case 5:
											strMsg += "睡眠に費やした時間には、数値を入力して下さい。";
											break;
									}
									alert(strMsg);
									return;
								}

							}
						}
						break;
					default:
						break;
				}
			}
			
			break;
		default:
			break;
	}

	//submit
	myForm.ModeItem7.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem7;	// 自画面のフォームエレメント

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem7" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>7/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>Ⅶ．あなたの食事・運動チェック</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal7") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check7' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='6'>あなたの食生活についてお伺いします</TD></TR>
<%For i = 0 To UBound(aryQuestion)
	'ヘッダー設定
	Select case i + 1
		Case 11
%>
			<TR CLASS='head'><TD COLSPAN='6'>次に、運動についてお伺いします</TD></TR>
<%
		Case 13
%>
			<TR CLASS='head'><TD COLSPAN='6'>２で１）はい、と答えた人は以下の質問にお答えください　<A HREF="#Next" CLASS="headA">２）いいえ、と答えた方はここをクリックして運動についての設問４に進んでください</A></TD></TR>
<%
	End Select
	
	'ラジオボタン・ＴＥＸＴ入力項目MAX数設定
	intMaxLoopCount = 0
	Select case i + 1
		Case 1,2,3,4,5,6,7,8,9,10,16
			intMaxLoopCount = 3
		Case 11,12,13,14
			intMaxLoopCount = 2
		Case Else
			intMaxLoopCount = 5
	End Select

	Select case i + 1
		Case 1,2,3,4,5,6,7,8,9,10,12,16	'ラジオボタン項目
%>
			<TR CLASS='question'>
				<TD COLSPAN='5'><%=aryQuestion(i)%></TD>
				<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A7_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択解除"></A></TD>
			</TR>
			<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					strCheck = ""
					If not isEmpty(Session("Q7-" & i + 1 )) And not isNull(Session("Q7-" & i + 1 )) Then
						If CInt(Session("Q7-" & i + 1 )) = j + 1 Then
							strCheck = "CHECKED"
						End If
					End If
%>
					<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A7_" & i + 1%>' VALUE='<%=j + 1%>' <%=strCheck%>></TD>
					<TD WIDTH='180' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
				Next
%>
			</TR>
<%
		Case 11 '運動経験入力欄
%>
				<TR CLASS='question'><TD COLSPAN='6'><%=aryQuestion(i)%></TD></TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'運動種目
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-1")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-1")
					End If
%>
					<TD COLSPAN='2' NOWRAP><%=aryAnswer(i,j)%>&nbsp;&nbsp;<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_1" %>' MAXLENGTH='32' VALUE='<%=strValue%>' SIZE='32' ></TD>
<%
				Next
%>
				</TR>
				<TR>

<%
				For j = 0 To intMaxLoopCount - 1
					'時期(From)
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-2")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-2")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;時期&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_2" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >歳から
<%
					'時期(To)
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-3")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-3")
					End If
%>
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_3" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >歳
					</TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'頻度
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-4")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-4")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;頻度&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_4" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >回／月
					</TD>
<%
				Next
%>
				</TR>
				<TR>

<%
				For j = 0 To intMaxLoopCount - 1
					'運動時間
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-5")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-5")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;運動時間&nbsp;&nbsp;
						<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_5" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >分／回
					</TD>
<%
				Next
%>
				</TR>
<%
		Case 13 '定期的に行なっている運動入力欄
%>
				<TR CLASS='question'><TD COLSPAN='6'><%=aryQuestion(i)%></TD></TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'運動種目
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-1")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-1")
					End If
%>
					<TD COLSPAN='2' NOWRAP><%=aryAnswer(i,j)%>&nbsp;&nbsp;<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_1" %>' MAXLENGTH='32' VALUE='<%=strValue%>' SIZE='32' ></TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'頻度
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-2")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-2")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;頻度&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_2" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >回／月
					</TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'運動時間
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-3")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-3")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;運動時間&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_3" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >分／回
					</TD>
<%
				Next
%>
				</TR>
<%
		Case 14 '歩行
%>
				<TR CLASS='question'><TD COLSPAN='6'><A NAME="Next"> <%=aryQuestion(i)%></TD></TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'平日／休日
%>
					<TD COLSPAN='2' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'歩行
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-1")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-1")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;歩行&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_1" %>' MAXLENGTH='7' VALUE='<%=strValue%>' SIZE='7' ISTYLE='4' >歩程度
					</TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'歩行時間
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-2")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-2")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;歩行時間&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_2" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >分
					</TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'歩行距離
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-3")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-3")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;歩行距離&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_3" %>' MAXLENGTH='7' VALUE='<%=strValue%>' SIZE='7' ISTYLE='4' >ｍ
					</TD>
<%
				Next
%>
				</TR>
<%
		Case 15 '１週間の活動
%>
				<TR CLASS='question'><TD COLSPAN='6'><%=aryQuestion(i)%></TD></TR>
				<TR>
					<TD COLSPAN='2' NOWRAP>&nbsp;</TD>
					<TD COLSPAN='4' NOWRAP>平日&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;休日</TD>
				</TR>

<%
				For j = 0 To intMaxLoopCount - 1
%>
					<TR><TD COLSPAN='2' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
					'平日時間
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-1")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-1")
					End If
%>
					<TD COLSPAN='4' NOWRAP>
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_1" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >時間&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
					'休日時間
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-2")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-2")
					End If
%>
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_2" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >時間
					</TD>
					</TR>
<%
				Next

		Case 17 '自由入力欄
			strValue = ""
			If not isEmpty(Session("Q7-" & i + 1 )) Then
				strValue = Session("Q7-" & i + 1 )
			End If
%>
			<TR CLASS='question'><TD COLSPAN='6'><%=aryQuestion(i)%></TD></TR>
			<TR><TD COLSPAN='6'><INPUT TYPE='textarea' NAME='<%="A7_" & i + 1 %>' MAXLENGTH='256' VALUE='<%=strValue%>' SIZE='172' ></TD></TR>
<%
	End Select
Next
%>
</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem7"   VALUE="">
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
