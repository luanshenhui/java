<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		メンタルヘルス　総合評価画面表示処理(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhResult.inc"-->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objMentalHealth 'メンタルヘルス情報アクセス用

Dim lngRsvNo		'予約番号

Dim i,j,k
Dim lngLockDiv
Dim strOldLockDiv
Dim strMode			'サブミットモード
Dim strTarget		'画面遷移先
Dim strValue		'文字列用ワーク
Dim intCalcValue	'計算用ワーク
Dim intCalcValue2	'計算用ワーク２
Dim blnNoAnswer		'精神健康度用フラグ
Dim blnNoSmoke		'喫煙フラグ
Dim blnNoDrink		'飲酒フラグ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'パラメータの取得
lngRsvNo = Request("RSVNO")
strMode = cInt(Request("ModeResult"))
strOldLockDiv = Request("LockDiv")

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
			strTarget = Session("FromAsp")
			'遷移元クリア
			Session("FromAsp") = ""
		Case MH_Mode_Next
			'次画面に遷移
			strTarget = "mhConsulItem1.asp"
			'遷移元クリア
			Session("FromAsp") = ""
		Case MH_Mode_Comment
			'コメント画面に遷移
			strTarget = "mhComment.asp"
		Case MH_Mode_Change
			'クライアントロック解除
			If objMentalHealth.UpdateClientPermission(Session("RsvNo"), strOldLockDiv) = False Then
				'エラー
				Session("ErrorMsg1") = "クライアントロック情報の更新に失敗しました"
				Session("ErrorMsg2") = "申し訳ありませんが、サポート担当者までご連絡ください"
				Response.Redirect "mhError.asp"
			End If
			Exit Do
		Case Else
			Exit Do
	End Select
	
	'リダイレクト
	Response.Redirect strTarget & "?RSVNO=" & lngRsvNo
	Exit Do
Loop

'クライアントロック区分取得
lngLockDiv = objMentalHealth.SelectClientPermission(Session("RsvNo"))
If lngLockDiv < 0 Then
	'エラー
	Session("ErrorMsg1") = "クライアントロック情報の取得に失敗しました"
	Session("ErrorMsg2") = "申し訳ありませんが、サポート担当者までご連絡ください"
	Response.Redirect "mhError.asp"
End If
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>結果</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {
	var myForm = document.Result;	// 自画面のフォームエレメント
	
	//submit
	myForm.ModeResult.value = strActMode;
	myForm.submit();
}
//-->
</SCRIPT>

</HEAD>

<BODY>
<FORM NAME="Result" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>メンタルヘルスドック総合評価</DIV>
<HR ALIGN=center>
<BR>
<TABLE>
<TR>
	<TD CLASS='personalInfo' NOWRAP>個人番号</TD>
	<TD CLASS='personalInfo' NOWRAP>：<%=Session("PerID")%></TD>
</TR>
<TR>
	<TD CLASS='personalInfo' NOWRAP>氏名</TD>
	<TD CLASS='personalInfo' NOWRAP>：<%=Session("LastName") & "　" & Session("FirstName")%></TD>
</TR>
<TR>
	<TD CLASS='personalInfo' NOWRAP>性別</TD>
<%
	If Session("Gender") = 1 Then
		strValue = "男"
	Else
		strValue = "女"
	End If
%>	
	<TD CLASS='personalInfo' NOWRAP>：<%=strValue%></TD>
</TR>
<TR>
	<TD CLASS='personalInfo' NOWRAP>生年月日</TD>
	<TD CLASS='personalInfo' NOWRAP>：<%=Session("Birth")%></TD>
</TR>
</TABLE>
<%
If Session("LoginDiv") = 1 And lngLockDiv > 0 Then
	If lngLockDiv = 1 Then
		strValue = PC_Client_On
	Else
		strValue = PC_Client_Off
	End If
%>
	<BR>
<!-- 2002.04.18 FAS)T.I Update クライアント情報未入力の場合のみメッセージを表示させる -->
<%
	If lngLockDiv = 1 Then
%>
		<TABLE>
			<TR><TD><%=strValue%></TD></TR>
			<TR><TD><%=PC_Client_Change%></TD></TR>
		</TABLE>
<%
	End If
%>
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Change%>)" ><IMG SRC=<%=MH_ImagePath & "change.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="変更"></A>
<%
End If
%>
<BR>

<HR ALIGN=center>

<%
'項目４精神健康度計算
intCalcValue = 0
blnNoAnswer = False
For i = 1 To 12
	If isNull(Session("Q4-" & i)) Or Session("Q4-" & i) = "" Then
		intCalcValue = 0
		blnNoAnswer = True
		Exit For
	End If

	If CInt(Session("Q4-" & i)) > 2 Then
		intCalcValue = intCalcValue + 1
	End If
Next
%>
<H2>Ⅳ．一般健康調査票（精神健康度）</H2>
<DL><DT>
<%
Select Case True
	Case intCalcValue = 0 And blnNoAnswer = True
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 2
%>
		<DT><B>精神的に健康</B>
		<DD>ストレスはたまっていません<BR>
		あなたは、精神的に全く健康です。今の調子で、ゆとりを持った生活を心がけましょう
		
<%
	Case intCalcValue < 4
%>
		<DT><B>精神的不健康の可能性が否定できない</B>
		<DD>少しストレスがたまりかけているようです<BR>
		あなたは、少し疲れが出ているのかもしれません。無理をしないように心がけましょう
		
<%
	Case Else
%>
		<DT><B>精神的不健康の可能性あり</B>
		<DD>ストレスがたまってきています<BR>
			あなたは、疲れがたまっているようです。時には仕事をうまく調整して休みをとることを考えましょう
		
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'項目５満足度・ストレス度計算
%>
<H2>Ⅴ．満足度・ストレス度</H2>
<DL>
<DT><B>１．職務満足度</B>
<%
If isNull(Session("Q5-1")) Or Session("Q5-1") = "" Then
%>
	<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%	
Else
	Select Case CInt(Session("Q5-1"))
		Case 0,1
%>
			<DD>仕事に対する満足度が低い方です。仕事のやり方を工夫した方がよいかもしれません
<%
		Case 2
%>
			<DD>仕事に対する満足度は平均的です。無理をしないで今のペースで続けてください
<%
		Case 3,4
%>
			<DD>仕事に対する満足感は高い方です。今のペースで続けてください
<%
	End Select
End If
%>
<BR>

<DT><B>２．家庭生活満足度</B>
<%
If isNull(Session("Q5-2")) Or Session("Q5-2") = "" Then
%>
	<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%	
Else
	Select Case CInt(Session("Q5-2"))
		Case 0,1
%>
			<DD>家庭に対する満足感は低い方です。家族と過ごす時間を増やした方がよいかもしれません
<%
		Case 2
%>
			<DD>家庭に対する満足感は平均的です
<%
		Case 3,4
%>
			<DD>家庭に対する満足度は高い方です
<%
	End Select
End If
%>
<BR>

<DT><B>３．職場ストレス度</B>
<%
If isNull(Session("Q5-3")) Or Session("Q5-3") = "" Then
%>
	<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%	
Else
	Select Case CInt(Session("Q5-3"))
		Case 0,1
%>
			<DD>職場でのストレスが，かなりたまっています。ストレス解消法に工夫が必要です
<%
		Case 2
%>
			<DD>職場のストレスは多少たまっています。ストレスを解消しましょう
<%
		Case 3,4
%>
			<DD>職場のストレスは低いレベルです。今の調子で続けてください
<%
	End Select
End If
%>
<BR>

<DT><B>４．家庭ストレス度</B>
<%
If isNull(Session("Q5-4")) Or Session("Q5-4") = "" Then

%>
	<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%	
Else
	Select Case CInt(Session("Q5-4"))
		Case 0,1
%>
			<DD>家庭でのストレスが，かなりたまっています。ストレス解消法に工夫が必要です
<%
		Case 2
%>
			<DD>家庭のストレスは多少たまっています。ストレスを解消しましょう
<%
		Case 3,4
%>
			<DD>家庭のストレスは低いレベルです。今の調子で続けてください
<%
	End Select
End If
%>
</DL><BR>

<HR ALIGN=center>

<%
'項目６喫煙
intCalcValue = 0
blnNoSmoke = False
Do
	If isNull(Session("Q6-1")) Or  Session("Q6-1") = "" Then
		Exit Do
	Else
		If CInt(Session("Q6-1")) > 1 Then
			blnNoSmoke = True
		End if
	End If

	If blnNoSmoke = False Then
		If isNull(Session("Q6-2-2")) Or Session("Q6-2-2") = "" Then
			Exit Do
		ElseIf CDbl(Session("Q6-2-2")) >= 26 Then
			intCalcValue = intCalcValue + 2
		ElseIf CDbl(Session("Q6-2-2")) >= 16 Then
			intCalcValue = intCalcValue + 1
		End If

		If isNull(Session("Q6-2-3")) Or Session("Q6-2-3") = "" Then
			intCalcValue = 0
			Exit Do
		End If
		intCalcValue = intCalcValue + CInt(Session("Q6-2-3"))

		For i = 3 To 8
			If isNull(Session("Q6-" & i)) Or Session("Q6-" & i) = "" Then
				intCalcValue = 0
				Exit Do
			End If

			If i = 8 Then
				If CInt(Session("Q6-" & i)) = 2 then
					intCalcValue = intCalcValue + 1
				ElseIf CInt(Session("Q6-" & i)) = 3 Then
					intCalcValue = intCalcValue + 2
				End If
			Else
				If CInt(Session("Q6-" & i)) = 1 then
					intCalcValue = intCalcValue + 1
				End If
			End If
		Next
	End If
	Exit Do
Loop	
%>
<H2>Ⅵ．喫煙・飲酒</H2>
<DL>
<DT><B>喫煙</B>
<%
Select Case True
	Case blnNoSmoke = True
%>
		<DD>0点<BR>
		（非喫煙者）
<%
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 6
%>
		<DD><%=intCalcValue%>点<BR>
		（中等度タバコ依存）今が断煙のチャンスです。この機会に、身体をタバコから解き放って、リフレッシュしましょう
<%
	Case Else
%>
		<DD><%=intCalcValue%>点<BR>
		（重度タバコ依存）断煙は困難かもしれませんが，やってみるだけの価値は十分にあります<BR>
		あなたとあなたをあなたの周りの大切な人たちのために
<%
End Select

'項目６飲酒
intCalcValue = 0
blnNoDrink = False
Do
	If isNull(Session("Q6-9")) Or  Session("Q6-9") = "" Then
		Exit Do
	Else
		If CInt(Session("Q6-9")) = 1 Then
			blnNoDrink = True
		Else
			intCalcValue = intCalcValue + (CInt(Session("Q6-9") - 1 ))
		End if
	End If

	If blnNoDrink = False Then
		For i = 10 To 18
			If isNull(Session("Q6-" & i)) Or Session("Q6-" & i) = "" Then
				intCalcValue = 0
				Exit Do
			End If
			intCalcValue = intCalcValue + (CInt(Session("Q6-" & i) - 1 ))
		Next
	End If
	Exit Do
Loop	
%>
<DT><B>飲酒</B>
<%
Select Case True
	Case blnNoDrink = True
%>
		<DD>0点<BR>
		（非飲酒者）
<%
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 11
%>
		<DD><%=intCalcValue%>点<BR>
		適正飲酒者。特に７点以下の人は，上手な飲み方をしているといえましょう<BR>
		そのままお酒といい関係を続けてください
<%
	Case intCalcValue < 15
%>
		<DD><%=intCalcValue%>点<BR>
		問題飲酒者の可能性あり。今一度ご自身の飲酒について、振り返ってみてください
<%
	Case Else
%>
		<DD><%=intCalcValue%>点<BR>
		問題飲酒者の可能性が強い。現在の飲み方では、近い将来健康をはじめ様々な飲酒の問題<BR>
		が起きてくる恐れがあります。要注意が必要です
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'項目７食事・運動計算
'食事
intCalcValue = 0
For i = 1 To 10
	If isNull(Session("Q7-" & i)) Or Session("Q7-" & i) = "" Then
		intCalcValue = 0
		Exit For
	End If
	intCalcValue = intCalcValue + CInt(Session("Q7-" & i))
Next
%>
<H2>Ⅶ．食事・運動</H2>
<DL>
<DT><B>食事</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 20 And CInt(Session("BMI")) < 19
%>
		<DD>食生活はあまりよくありません。やせておられますので、食事内容，量を見直しましょう
<%
	Case intCalcValue < 20 And CInt(Session("BMI")) < 26
%>
		<DD>食生活はあまりよくありません。食生活を見直しましょう
<%
	Case intCalcValue < 20 And CInt(Session("BMI")) >= 26
%>
		<DD>食生活はあまりよくありません。肥満が見られますので，食事内容，量を見直しましょう
<%
	Case intCalcValue < 26 And CInt(Session("BMI")) < 19
%>
		<DD>食事のバランスは悪くないようですが，やせておられるので、食事にはもう少し注意しましょう
<%
	Case intCalcValue < 26 And CInt(Session("BMI")) < 26
%>
		<DD>食事のバランスは悪くないようですが，もう少しの改善が期待できます
<%
	Case intCalcValue < 26 And CInt(Session("BMI")) >= 26
%>
		<DD>食事のバランスは悪くないようですが，肥満が見られますので，食事内容，量に注意してください
<%
	Case intCalcValue >= 26 And CInt(Session("BMI")) < 19
%>
		<DD>食事のバランスは良いようですが、やせておられるので、食事内容に一層の注意をしましょう
<%
	Case intCalcValue >= 26 And CInt(Session("BMI")) < 26
%>
		<DD>食習慣は良いようです。現状を維持するように注意してください
<%
	Case intCalcValue >= 26 And CInt(Session("BMI")) >= 26
%>
		<DD>食事のバランスは良いようですが、肥満が見られますので、食べ過ぎには注意してください
<%
End Select

'運動
'１日の歩行
intCalcValue = 0
intCalcValue2 = 0
If (not isNull(Session("Q7-14-1-1")) And Session("Q7-14-1-1") <> "") And _
	(not isNull(Session("Q7-14-2-1")) And Session("Q7-14-2-1") <> "") Then
	'歩行数で計算
	intCalcValue = ((CLng(Session("Q7-14-1-1")) * 5) + (CLng(Session("Q7-14-2-1")) * 2)) / 7
	'少数第一位で四捨五入
	intCalcValue = (intCalcValue * 10 + 5) \ 10

	Select Case True
		Case intCalcValue <= 7000
			intCalcValue2 = 1
		Case intCalcValue < 9000
			intCalcValue2 = 2
		Case Else
			intCalcValue2 = 3
	End Select
ElseIf (not isNull(Session("Q7-14-1-3")) And Session("Q7-14-1-3") <> "") And _
		(not isNull(Session("Q7-14-2-3")) And Session("Q7-14-2-3") <> "") Then
	'歩行距離で計算
	intCalcValue = (CDbl(Session("Weight")) * CDbl(Session("Q7-14-1-3")) * 0.001 * 0.5 * 5) _ 
					+ (CDbl(Session("Weight")) * CDbl(Session("Q7-14-2-3")) * 0.001 * 0.5 * 2)
	'少数第一位で四捨五入
	intCalcValue = (intCalcValue * 10 + 5) \ 10

	Select Case True
		Case intCalcValue < 1300
			intCalcValue2 = 1
		Case intCalcValue < 1700
			intCalcValue2 = 2
		Case Else
			intCalcValue2 = 3
	End Select

ElseIf (not isNull(Session("Q7-14-1-2")) And Session("Q7-14-1-2") <> "") And _
		(not isNull(Session("Q7-14-2-2")) And Session("Q7-14-2-2") <> "") Then
	'歩行時間で計算
	intCalcValue = ((CDbl(Session("Q7-14-1-2")) * 120 * 5) + (CDbl(Session("Q7-14-2-2")) * 120 * 2)) / 7
	'少数第一位で四捨五入
	intCalcValue = (intCalcValue * 10 + 5) \ 10

	Select Case True
		Case intCalcValue < 7000
			intCalcValue2 = 1
		Case intCalcValue < 9000
			intCalcValue2 = 2
		Case Else
			intCalcValue2 = 3
	End Select
End If
%>
<DT><B>運動</B>
<DL>
<DT><B>平均的な１日の歩行について</B>
<%
Select Case intCalcValue2
	Case 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case 1
%>
		<DD>活動量が不足しています
<%
	Case 2
%>
		<DD>やや不十分
<%
	Case 3
%>
		<DD>十分な活動量
<%
End Select

'１日の運動
intCalcValue = 0
intCalcValue2 = 0
If (not isNull(Session("Q7-15-1-1")) And Session("Q7-15-1-1") <> "") And _
	(not isNull(Session("Q7-15-1-2")) And Session("Q7-15-1-2") <> "") And _
	(not isNull(Session("Q7-15-2-1")) And Session("Q7-15-2-1") <> "") And _
	(not isNull(Session("Q7-15-2-2")) And Session("Q7-15-2-2") <> "") And _
	(not isNull(Session("Q7-15-3-1")) And Session("Q7-15-3-1") <> "") And _
	(not isNull(Session("Q7-15-3-2")) And Session("Q7-15-3-2") <> "") Then
	
	intCalcValue = ((CDbl(Session("Q7-15-1-1")) + CDbl(Session("Q7-15-1-2"))) / 2) * 60 * 8 _
				+ ((CDbl(Session("Q7-15-2-1")) + CDbl(Session("Q7-15-2-2"))) / 2) * 60 * 6 _
				+ ((CDbl(Session("Q7-15-3-1")) + CDbl(Session("Q7-15-3-2"))) / 2) * 60 * 4
	'少数第一位で四捨五入
	intCalcValue = (intCalcValue * 10 + 5) \ 10

	Select Case True
		Case intCalcValue < 200
			intCalcValue2 = 1
		Case intCalcValue < 240
			intCalcValue2 = 2
		Case Else
			intCalcValue2 = 3
	End Select
End If 

%>
<DT><B>この１週間の平均的な１日における運動に費やした時間について</B>
<%
Select Case intCalcValue2
	Case 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case 1
%>
		<DD>活動量が不足しています
<%
	Case 2
%>
		<DD>やや不十分
<%
	Case 3
%>
		<DD>十分な活動量
<%
End Select
%>
</DL>
</DL>

<HR ALIGN=center>

<%
'項目８社会的支援計算
intCalcValue = 0
For i = 1 To 3
	If isNull(Session("Q8-" & i & "-2")) Or Session("Q8-" & i & "-2") = "" Then
		intCalcValue = 0
		Exit For
	End If
	intCalcValue = intCalcValue + CInt(Session("Q8-" & i & "-2"))
Next
%>
<H2>Ⅷ．社会的支援</H2>
<DL>
<!-- 2002.04.08 FAS)T.I 1Line delete
<DT><B>社会的支援</B>-->
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 7
%>
		<DD>周囲の人間関係は良好です
<%
	Case intCalcValue < 12
%>
		<DD>周囲との人間関係に少し問題があるのかもしれません
<%
	Case Else
%>
		<DD>周囲との人間関係の再検討が必要かもしれません
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'項目９余暇計算
intCalcValue = 0
For i = 1 To 38
	If not isNull(Session("Q9-2-" & i)) And Session("Q9-2-" & i) <> "" Then
		If CInt(Session("Q9-2-" & i)) = 1 Then
			intCalcValue = intCalcValue + 1
		End if
	End If
Next
%>
<H2>Ⅸ．余暇</H2>
<DL>
<!-- 2002.04.08 FAS)T.I 1Line delete
<DT><B>余暇</B> -->
<%
Select Case True
	Case intCalcValue < 2
%>
		<DD>趣味を広げましょう

<%
	Case intCalcValue < 4
%>
		<DD>余暇をうまく過ごされているようです
<%
	Case Else
%>
		<DD>多彩な趣味を持たれていますね
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'項目１０タイプＡ計算
intCalcValue = 0
intCalcValue2 = 0
For i = 1 To 6
	If isNull(Session("Q10-" & i)) Or Session("Q10-" & i) = "" Then
		intCalcValue = 0
		intCalcValue2 = 0
		Exit For
	End If
	
	Select Case i
		Case 1,3,5
			intCalcValue = intCalcValue + CInt(Session("Q10-" & i))
		Case 2,4,6
			intCalcValue2 = intCalcValue2 + CInt(Session("Q10-" & i))
	End Select
Next
%>
<H2>Ⅹ．タイプＡ</H2>
<DL>
<!-- 2002.04.08 FAS)T.I 1Line delete
<DT><B>タイプＡ</B> -->
<%
Select Case True
	Case intCalcValue = 0 And intCalcValue2 = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case (intCalcValue2 + (21 - intCalcValue)) < 25
%>
		<DD>今の仕事のペースでよいようです
<%
	Case (intCalcValue2 + (21 - intCalcValue)) < 28
%>
		<DD>仕事のペースを少し落とした方がよいかもしれません
<%
	Case Else
%>
		<DD>時には仕事の手を止めることも大切です
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'項目１１ストレス関連要因計算
'業務負荷
intCalcValue = 0
For i = 1 To 39
	If i = 2 Or i = 6 OR i = 12 Or i = 13 OR i = 17 Or i = 25 Then
		If isNull(Session("Q11-" & i)) Or Session("Q11-" & i) = "" Then
			intCalcValue = 0
			Exit For
		End If
		intCalcValue = intCalcValue + CInt(Session("Q11-" & i))
	End If
Next
%>
<H2>XI．ストレス関係要因</H2>
<DL>
<DT><B>業務負荷</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 24
%>
		<DD>仕事の負担は適度です
<%
	Case intCalcValue < 27
%>
		<DD>仕事の負担がやや大きいようです。無理をしないように心がけましょう
<%
	Case Else
%>
		<DD>仕事の負担が大きくなっています。上手に休みを取りましょう
<%
End Select

'人間関係
intCalcValue = 0
For i = 1 To 39
	If i = 4 Or i = 5 OR i = 8 Or i = 14 Or i = 15 OR i = 16 Or i = 17 Or i = 18 OR i = 20 Then
		If isNull(Session("Q11-" & i)) Or Session("Q11-" & i) = "" Then
			intCalcValue = 0
			Exit For
		End If
		intCalcValue = intCalcValue + CInt(Session("Q11-" & i))
	End If
Next
%>
<DT><B>人間関係</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 37
%>
		<DD>職場の人間関係は良好です
<%
	Case intCalcValue < 43
%>
		<DD>職場の人間関係で少し疲れています。気分転換をしましょう
<%
	Case Else
%>
		<DD>職場の人間関係で，かなり疲れています。自分一人で悩まないようにしましょう
<%
End Select

'職場と家庭のバランス
intCalcValue = 0
For i = 1 To 39
	If i = 11 Or i = 24 OR i = 28 Or i = 30 Or i = 38 OR i = 39 Then
		If isNull(Session("Q11-" & i)) Or Session("Q11-" & i) = "" Then
			intCalcValue = 0
			Exit For
		End If
		intCalcValue = intCalcValue + CInt(Session("Q11-" & i))
	End If
Next
%>
<DT><B>職場と家庭のバランス</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 23
%>
		<DD>仕事と家庭のバランスが上手に取れているようです
<%
	Case intCalcValue < 25
%>
		<DD>仕事と家庭のバランスに工夫が必要です
<%
	Case Else
%>
		<DD>仕事と家庭のバランスに十分気をつけましょう

<%
End Select

'管理業務
intCalcValue = 0
For i = 1 To 39
	If i = 1 Or i = 21 OR i = 22 Or i = 32 Then
		If isNull(Session("Q11-" & i)) Or Session("Q11-" & i) = "" Then
			intCalcValue = 0
			Exit For
		End If
		intCalcValue = intCalcValue + CInt(Session("Q11-" & i))
	End If
Next
%>
<DT><B>管理業務</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 14
%>
		<DD>管理の仕事はうまくいっています
<%
	Case intCalcValue < 16
%>
		<DD>管理の仕事が多少負担になっています
<%
	Case Else
%>
		<DD>管理の仕事に気を使いすぎです
<%
End Select

'責任性
intCalcValue = 0
For i = 1 To 39
	If i = 19 Or i = 31 OR i = 35 Or i = 36 Then
		If isNull(Session("Q11-" & i)) Or Session("Q11-" & i) = "" Then
			intCalcValue = 0
			Exit For
		End If
		intCalcValue = intCalcValue + CInt(Session("Q11-" & i))
	End If
Next
%>
<DT><B>責任性</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 17
%>
		<DD>特に問題はありません
<%
	Case intCalcValue < 19
%>
		<DD>仕事で責任を多少感じすぎです
<%
	Case Else
%>
		<DD>仕事で責任を強く感じすぎです
<%
End Select

'ストレス
intCalcValue = 0
For i = 1 To 39
	If i = 7 Or i = 9 OR i = 10 Or i = 27 Then
		If isNull(Session("Q11-" & i)) Or Session("Q11-" & i) = "" Then
			intCalcValue = 0
			Exit For
		End If
		intCalcValue = intCalcValue + CInt(Session("Q11-" & i))
	End If
Next
%>
<DT><B>ストレス</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 17
%>
		<DD>ストレスはそれほどたまっていません
<%
	Case intCalcValue < 19
%>
		<DD>ストレスがたまる傾向にあります
<%
	Case Else
%>
		<DD>ストレスがたまりすぎです
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'項目１２対処行動・社会的支援計算
intCalcValue = 0
For i = 1 To 10
	If i = 2 Or i = 3 OR i = 5 Or i = 7 OR i = 8 Or i = 9 Then
		If isNull(Session("Q12-" & i)) Or Session("Q12-" & i) = "" Then
			intCalcValue = 0
			Exit For
		End If
		intCalcValue = intCalcValue + CInt(Session("Q12-" & i))
	End If
Next
%>
<H2>XII．対処行動・社会的支援</H2>
<DL>
<DT><B>対処行動</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 26
%>
		<DD>ストレスの対処は上手なほうです
<%
	Case intCalcValue < 28
%>
		<DD>ストレスの対処にやや問題があります
<%
	Case Else
%>
		<DD>ストレスの対処の方法を検討する必要がありそうです
<%
End Select

intCalcValue = 0
For i = 1 To 10
	If i = 1 Or i = 4 OR i = 6 Or i = 10 Then
		If isNull(Session("Q12-" & i)) Or Session("Q12-" & i) = "" Then
			intCalcValue = 0
			Exit For
		End If
		intCalcValue = intCalcValue + CInt(Session("Q12-" & i))
	End If
Next
%>
<DT><B>社会的支援</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 18
%>
		<DD>特に問題はありません
<%
	Case intCalcValue < 20
%>
		<DD>職場の人間関係を考えてみましょう
<%
	Case Else
%>
		<DD>職場の人間関係に工夫をしてみましょう
<%
End Select
%>
</DL>
<INPUT TYPE="hidden" NAME="RSVNO"       VALUE="<%=lngRsvNo%>">
<INPUT TYPE="hidden" NAME="LockDiv"     VALUE="<%=lngLockDiv%>">
<INPUT TYPE="hidden" NAME="ModeResult"  VALUE="">
<BR><BR>

<CENTER>
<HR ALIGN=center>
<%If Session("LoginDiv") = 1 Then%>
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Comment%>)"><IMG SRC=<%=MH_ImagePath & "comment.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="コメント"></A>
	<%If not isEmpty(Session("FromAsp")) And not isNull(Session("FromAsp")) And Session("FromAsp") <> "" Then%>
		<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Back%>)"><IMG SRC=<%=MH_ImagePath & "back.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
	<%End If%>
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)"><IMG SRC=<%=MH_ImagePath & "next.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="次へ"></A>
<%End If%>
<A HREF="JavaScript:close()"><IMG SRC=<%=MH_ImagePath & "end.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="終了"></A>
</CENTER>
</FORM>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>
