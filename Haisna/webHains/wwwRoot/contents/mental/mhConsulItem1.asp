<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　あなたの基本情報チェック画面表示処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem1.inc"-->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objMentalHealth 'メンタルヘルス情報アクセス用

Dim i
Dim j
Dim strCheck
Dim strValue
Dim strTarget		'遷移先
Dim intTagDiv		'input type 区分
Dim intRadioCount	'選択可能ラジオボタン数
Dim arrQuestion()	'全質問項目名
Dim arrAnswer()		'全回答

'受け取りパラメータ
Dim lngRsvNo	'予約番号
Dim strMode		'選択されたアクション

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'引数値の取得
lngRsvNo = Request("RSVNO")
strMode = CInt(Request("ModeItem1"))

'ログインチェック
If LoginCheck(lngRsvNo) = False Then
	Response.Redirect "mhError.asp"
End If

'オブジェクトのインスタンス作成
Set objMentalHealth = Server.CreateObject("HainsMentalHealth.MentalHealth")

Do
	Select Case strMode
		Case MH_Mode_Next
			'次画面に遷移
			strTarget = "mhConsulItem2.asp"
		Case MH_Mode_Result
			'総合評価に遷移
			Session("FromAsp") = "mhConsulItem1.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'セッションにセット
	Session("Refusal1") = Request("Check1")
	For i = 0 To UBound(aryQuestion)
		Session("Q1-" & i + 1) = Request("A1_" & i + 1)
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
<TITLE>あなたの基本情報チェック</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn;
	var myForm = document.ConsulItem1;	// 自画面のフォームエレメント
	
	switch (strActMode) {
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
				//必須チェック
				switch (i + 1) {
					case 1:case 3:case 4:
						//回答拒否じゃない場合、必須チェック
						if (!myForm.Check1.checked){
							//ラジオボタン
							chkOn = false;
							for (j=0; j<eval("myForm.A1_" + (i + 1) + ".length"); j++) {
								if (eval("myForm.A1_" + (i + 1) + "[" + j + "]" + ".checked")) {
									chkOn  = true
									break;
								}
							}
							
							if (chkOn == false) {
								alert("設問 " + (i + 1) + "に対する回答を選択してください。");
								return;
							}
						}
						break;
					case 2:
						//回答拒否じゃない場合、必須チェック
						if (!myForm.Check1.checked){
							//テキスト入力チェック
							if (eval("myForm.A1_" + (i + 1) + ".value") == ""){
								alert("設問 " + (i + 1) + "に対する回答を入力してください。");
								return;
							}
						}
					case 6:case 13:case 14:case 15:case 16:
						//テキストフォーマットチェック
						//if (eval("myForm.A1_" + (i + 1) + ".value") != "" && ! eval("myForm.A1_" + (i + 1) + ".value.match('^[0-9]+$')") ) {
						if (eval("myForm.A1_" + (i + 1) + ".value") != "" && isNaN(Number(eval("myForm.A1_" + (i + 1) + ".value")))) {
							alert("設問 " + (i + 1) + "には、数値を入力して下さい。");
							return;
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
	myForm.ModeItem1.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem1;	// 自画面のフォームエレメント

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem1" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">

<DIV CLASS='page' NOWRAP>1/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>Ⅰ．あなたの基本情報チェック</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal1") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check1' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='10'>次の質問にお答ください</TD></TR>
<%
	For i = 0 To UBound(aryQuestion)
	If i = 4 Then
%>
		<TR CLASS="head"><TD COLSPAN='10'>仕事をされていない方は、<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)" CLASS="headA">ここをクリックしてⅡに進んでください</A></TD></TR>
<%
	End If

	intRadioCount = 0
	intTagDiv = pcRadio

	Select case i + 1
		Case 1,4
			intRadioCount = 2
		Case 3,5
			intRadioCount = 3
		Case 7,8,11
			intRadioCount = 5
		Case 9
			intRadioCount = 16
		Case 10
			intRadioCount = 7
		Case 12
			intRadioCount = 8
		Case Else
			'text
			intTagDiv = pcText
	End Select

	If intTagDiv = pcRadio Then
		'ラジオボタン表示
%>
		<TR CLASS='question'>
			<TD COLSPAN='9'><%=aryQuestion(i)%></TD>
			<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A1_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="選択解除"></A></TD>
		</TR>
		<TR>
<%
		For j = 0 To intRadioCount -1
			If (j mod 5) = 0 Then
				'１列に５個まで
%>
					</TR><TR>
<%
			End If
			strCheck = ""
			If not isEmpty(Session("Q1-" & i + 1 )) And not isNull(Session("Q1-" & i + 1 )) Then
				If CInt(Session("Q1-" & i + 1 )) = j + 1 Then
					strCheck = "CHECKED"
				End If
			End If
%>
			<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A1_" & i + 1%>' VALUE='<%=j + 1%>' <%=strCheck%>></TD>
			<TD WIDTH='140' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
		Next
%>
		</TR>
<%
	Else
		'テキスト表示
		strValue = ""
		If not isEmpty(Session("Q1-" & i + 1 )) Then
			strValue = Session("Q1-" & i + 1 )
		End If
%>
		<TR CLASS='question'><TD COLSPAN='10'><%=aryQuestion(i)%></TD></TR>
		<TR>
			<TD COLSPAN='10' NOWRAP><INPUT TYPE='text' NAME='<%="A1_" & i + 1%>' MAXLENGTH='5' VALUE='<%=strValue%>' SIZE='5' ISTYLE='4'>
			<%=aryAnswer(i,0)%></TD>
		</TR>
<%
	End If
Next
%>
</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem1"   VALUE="">
<INPUT TYPE="hidden" NAME="RSVNO"       VALUE="<%=lngRsvNo%>">
<%If Session("LoginDiv") = 1 Then%>
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Result%>)"><IMG SRC=<%=MH_ImagePath & "result.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="総合評価"></A>
<%End If%>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Clear%>)"><IMG SRC=<%=MH_ImagePath & "clear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="クリア"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)"><IMG SRC=<%=MH_ImagePath & "next.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="次へ"></A>
</FORM>
</CENTER>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>
