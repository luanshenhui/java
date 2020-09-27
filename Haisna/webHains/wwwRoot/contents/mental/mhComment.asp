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

Dim i,j,k
Dim intMaxQuestion
Dim intMaxItem
Dim strMode
Dim strTarget
Dim strValue
Dim strComment
Dim strDocComment
Dim lngRsvNo		'予約番号

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'パラメータ取得
lngRsvNo = Request("RSVNO")
strMode = CInt(Request("ModeComment"))
strDocComment = Request("COMMENT")


'ログインチェック
If LoginCheck(lngRsvNo) = False Then
	Response.Redirect "mhError.asp"
End If

'オブジェクトのインスタンス作成
Set objMentalHealth = Server.CreateObject("HainsMentalHealth.MentalHealth")

Do
	Select Case strMode
		Case MH_Mode_Back
			'総合評価画面に戻る
			strTarget = "mhResult.asp"
		Case MH_Mode_Regist
			'コメント登録
			If objMentalHealth.InsertControlComment(Session("PerID"), strDocComment) = False Then
				'エラー
				Session("ErrorMsg1") = "コメント情報の更新に失敗しました"
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

'個人番号をもとにコメント情報を取得する
If objMentalHealth.SelectComment(Session("PerID"), strComment) < 0 Then
	'エラー
	Session("ErrorMsg1") = "コメント情報の取得に失敗しました"
	Session("ErrorMsg2") = "申し訳ありませんが、サポート担当者までご連絡ください"
	Response.Redirect "mhError.asp"
End If
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>メンタルヘルスドック総合評価に対するコメント</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {
	var myForm = document.Comment;	// 自画面のフォームエレメント
	
	//submit
	myForm.ModeComment.value = strActMode;
	myForm.submit();
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<FORM NAME="Comment" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>メンタルヘルスドック総合評価に対するコメント</DIV>
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
<BR>

<BASEFONT SIZE="4">
<HR ALIGN=center>
<CENTER>
<TEXTAREA ROWS="10" COLS="100" NAME="COMMENT" MAXLENGTH="1000" WRAP="soft" ><%=strComment%></TEXTAREA>
</CENTER>
<BR>

<INPUT TYPE="hidden" NAME="ModeComment"   VALUE="">
<INPUT TYPE="hidden" NAME="RSVNO"       VALUE="<%=lngRsvNo%>">

<CENTER>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Clear%>)"><IMG SRC=<%=MH_ImagePath & "clear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="クリア"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Regist%>)"><IMG SRC=<%=MH_ImagePath & "regist.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="登録"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Back%>)"><IMG SRC=<%=MH_ImagePath & "back.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="戻る"></A>
</CENTER>

</FORM>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>