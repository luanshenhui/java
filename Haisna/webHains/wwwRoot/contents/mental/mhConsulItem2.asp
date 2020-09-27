<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　あなたの治療情報入力画面表示処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem2.inc"-->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Dim objMentalHealth 'メンタルヘルス情報アクセス用

Dim i
Dim j
Dim strCheck
Dim strValue
Dim strTarget		'遷移先
Dim intRadioCount	'選択可能ラジオボタン数
Dim arrQuestion()	'全質問項目名
Dim arrAnswer()		'全回答
Dim test

'受け取りパラメータ
Dim lngRsvNo	'予約番号
Dim strMode		'選択されたアクション

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'パラメータ取得
lngRsvNo = Request("RSVNO")
strMode = CInt(Request("ModeItem2"))

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
			strTarget = "mhConsulItem1.asp"
		Case MH_Mode_Next
			'次画面に遷移
			strTarget = "mhConsulItem3.asp"
		Case MH_Mode_Result
			'総合評価に遷移
			Session("FromAsp") = "mhConsulItem2.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'セッションにセット
	Session("Refusal2") = Request("Check2")
	For i = 0 To UBound(aryQuestion)
		For j = 1 To 3
			Session("Q2-" & i + 1 & "-" & j) = Request("A2_" & i + 1 & "_" & j)
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
<TITLE>あなたの治療情報入力</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkSick,chkTreat,strMsg;
	var myForm = document.ConsulItem2;	// 自画面のフォームエレメント
	var Question = new Array(10);
	Question[0] = "高血圧";
	Question[1] = "糖尿病";
	Question[2] = "肝臓病";
	Question[3] = "高脂血症";
	Question[4] = "心臓病";
	Question[5] = "脳卒中";
	Question[6] = "痛風";
	Question[7] = "その他";
	Question[8] = "その他";
	Question[9] = "その他";
	Question[10] = "その他";
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
				strMsg = "";
				chkSick = -1;
				if (!myForm.Check2.checked){
					//回答拒否じゃない場合、必須チェック
					if (i < 7){
						//病名ありなしチェック(ラジオボタン)
						for (j=0; j<eval("myForm.A2_" + (i + 1) + "_1.length"); j++) {
							if (eval("myForm.A2_" + (i + 1) + "_1[" + j + "]" + ".checked")) {
								chkSick  = j;
								break;
							}
						}

						if (chkSick < 0) {
							alert(Question[i] + "に対するあり・なしを選択してください。");
							return;
						}
					}else{
						//病名ありなしチェック(テキスト入力)
						if (eval("myForm.A2_" + (i + 1) + "_1.value") != ""){
							chkSick = 0;
							strMsg = eval("myForm.A2_" + (i + 1) + "_1.value");
						}
					}
					
					if (chkSick == 0){
						//病名ありの場合のみ
						//期間入力チェック
						if (eval("myForm.A2_" + (i + 1) + "_2.value") == ""){
							if (strMsg == "") {
								alert(Question[i] + "に対する期間を入力してください。");
							} else {
								alert(strMsg + "に対する期間を入力してください。");
							}
							return;
						}

						//治療内容チェック
						if (i != 0 && i != 3 && i != 6){
							chkTreat = false;
							for (j=0; j<eval("myForm.A2_" + (i + 1) + "_3.length"); j++) {
								if (eval("myForm.A2_" + (i + 1) + "_3[" + j + "]" + ".checked")) {
									chkTreat  = true;
									break;
								}
							}
							
							if (chkTreat == false) {
								if (strMsg == "") {
									alert(Question[i] + "に対する治療内容を選択してください。");
								} else {
									alert(strMsg + "に対する治療内容を選択してください。");
								}
								return;
							}
						}
					}
				}
				//回答拒否に関わらず、数値項目が入力されている場合は、数値チェック
				//期間フォーマットチェック
				//if (eval("myForm.A2_" + (i + 1) + "_2.value") != "" && ! eval("myForm.A2_" + (i + 1) + "_2.value.match('^[0-9]+$')") ) {
				if (eval("myForm.A2_" + (i + 1) + "_2.value") != "" && isNaN(Number(eval("myForm.A2_" + (i + 1) + "_2.value")))) {
					if (strMsg == "") {
						alert(Question[i] + "に対する期間には、数値を入力してください。");
					} else {
						alert(strMsg + "に対する期間には、数値を入力してください。");
					}
					return;
				}
			}
			break;
		default:
			break;
	}

	//submit
	myForm.ModeItem2.value = strActMode;
	myForm.submit();

}
function CheckClear(intNo) {
	var j;
	var myForm = document.ConsulItem2;	// 自画面のフォームエレメント

	switch(intNo) {
		case 1:case 4:case 7:
			for (j=0; j<eval("myForm.A2_" + intNo +"_1.length"); j++) {
				eval("myForm.A2_" + intNo +"_1[j].checked = false");
			}
			break;
		case 2:case 3:case 5:case 6:
			for (j=0; j<eval("myForm.A2_" + intNo +"_1.length"); j++) {
				eval("myForm.A2_" + intNo +"_1[j].checked = false");
			}
		default: 
			for (j=0; j<eval("myForm.A2_" + intNo +"_3.length"); j++) {
				eval("myForm.A2_" + intNo +"_3[j].checked = false");
			}
			break;
	}
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem2" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>2/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>Ⅱ．あなたの治療情報入力</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal2") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check2' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE BORDER ="1" CELLSPACING="0" CELLPADDING="5" CLASS="tableNomal">
<TR CLASS='head'><TD COLSPAN='5'>現在、あるいはこれまでにあなたが治療を受けている病気がありましたら、記入してください</TD></TR>
<TR CLASS='questionCenter'>
	<TD>病名</TD>
	<TD>&nbsp;</TD>
	<TD>期間</TD>
	<TD>治療内容</TD>
	<TD>&nbsp;</TD>
</TR>

<%
For i = 0 To UBound(aryQuestion)
	Select Case i + 1
		Case 1,4,7
			'治療内容'-'
			intRadioCount = 0
		Case 2
			'治療内容　入院・通院
			intRadioCount = 1
		Case 3,5,6
			'治療内容　手術・入院・通院
			intRadioCount = 2
		Case Else
			'病名入力
			intRadioCount = 3
	End Select
%>
<TR>
<%
	'病名
	If i < 7 Then
%>
		<TD NOWRAP><%=aryQuestion(i)%></TD>
		<TD NOWRAP>
<%
		For j = 0 To UBound(aryTreat)
			strCheck = ""
			If not isEmpty(Session("Q2-" & i + 1 & "-1")) And not isNull(Session("Q2-" & i + 1 & "-1")) Then
				If CInt(Session("Q2-" & i + 1 & "-1")) = j + 1 Then
					strCheck = "CHECKED"
				End If
			End If
%>
			<INPUT TYPE='radio' NAME='<%="A2_" & i + 1 & "_1"%>' VALUE='<%=j + 1%>' <%=strCheck%>>
			<%=aryTreat(j)%>
<%
		Next
%>
		</TD>
<%
	Else
		'テキスト表示
		strValue = ""
		If not isEmpty(Session("Q2-" & i + 1 & "-1")) Then
			strValue = Session("Q2-" & i + 1 & "-1")
		End If
%>
		<TD COLSPAN='2' NOWRAP><%=aryQuestion(i)%>
			<INPUT TYPE='text' NAME='<%="A2_" & i + 1 & "_1"%>' MAXLENGTH='32' VALUE='<%=strValue%>' SIZE='32' >
		</TD>
<%
	End If

	'期間
	strValue = ""
	If not isEmpty(Session("Q2-" & i + 1 & "-2")) Then
		strValue = Session("Q2-" & i + 1 & "-2")
	End If
%>
	<TD NOWRAP><INPUT TYPE='text' NAME='<%="A2_" & i + 1 & "_2"%>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' >年間</TD>
	
<%
	'治療内容
	If intRadioCount > 0 Then
%>
		<TD NOWRAP>
<%
		For j = 0 To intRadioCount
			strCheck = ""
			If not isEmpty(Session("Q2-" & i + 1 & "-3")) And not isNull(Session("Q2-" & i + 1 & "-3")) Then
				If CInt(Session("Q2-" & i + 1 & "-3")) = j + 1 Then
					strCheck = "CHECKED"
				End If
			End If
%>
			<INPUT TYPE='radio' NAME='<%="A2_" & i + 1 & "_3"%>' VALUE='<%=j + 1%>' <%=strCheck%>>
			<%=aryTreatInfo(j)%>
<%
		Next
%>
		</TD>
<%
	Else
%>
		<TD ALIGN='center' NOWRAP>－</TD>
<%
	End If
%>
	<TD NOWRAP><A HREF="JavaScript:CheckClear(<%=i + 1%>)"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択解除" ALIGN="right" ></A></TD>
</TR>
<%
Next
%>

</TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem2"   VALUE="">
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
