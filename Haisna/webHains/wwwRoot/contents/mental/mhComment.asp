<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����^���w���X�@�����]����ʕ\������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhResult.inc"-->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objMentalHealth '�����^���w���X���A�N�Z�X�p

Dim i,j,k
Dim intMaxQuestion
Dim intMaxItem
Dim strMode
Dim strTarget
Dim strValue
Dim strComment
Dim strDocComment
Dim lngRsvNo		'�\��ԍ�

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�p�����[�^�擾
lngRsvNo = Request("RSVNO")
strMode = CInt(Request("ModeComment"))
strDocComment = Request("COMMENT")


'���O�C���`�F�b�N
If LoginCheck(lngRsvNo) = False Then
	Response.Redirect "mhError.asp"
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objMentalHealth = Server.CreateObject("HainsMentalHealth.MentalHealth")

Do
	Select Case strMode
		Case MH_Mode_Back
			'�����]����ʂɖ߂�
			strTarget = "mhResult.asp"
		Case MH_Mode_Regist
			'�R�����g�o�^
			If objMentalHealth.InsertControlComment(Session("PerID"), strDocComment) = False Then
				'�G���[
				Session("ErrorMsg1") = "�R�����g���̍X�V�Ɏ��s���܂���"
				Session("ErrorMsg2") = "�\���󂠂�܂��񂪁A�T�|�[�g�S���҂܂ł��A����������"
				Response.Redirect "mhError.asp"
			End If
			Exit Do
		Case Else
			Exit Do
	End Select
	
	'���_�C���N�g
	Response.Redirect strTarget & "?RSVNO=" & lngRsvNo

	Exit Do
Loop

'�l�ԍ������ƂɃR�����g�����擾����
If objMentalHealth.SelectComment(Session("PerID"), strComment) < 0 Then
	'�G���[
	Session("ErrorMsg1") = "�R�����g���̎擾�Ɏ��s���܂���"
	Session("ErrorMsg2") = "�\���󂠂�܂��񂪁A�T�|�[�g�S���҂܂ł��A����������"
	Response.Redirect "mhError.asp"
End If
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>�����^���w���X�h�b�N�����]���ɑ΂���R�����g</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {
	var myForm = document.Comment;	// ����ʂ̃t�H�[���G�������g
	
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
<DIV CLASS='title' NOWRAP>�����^���w���X�h�b�N�����]���ɑ΂���R�����g</DIV>
<HR ALIGN=center>
<BR>
<TABLE>
<TR>
	<TD CLASS='personalInfo' NOWRAP>�l�ԍ�</TD>
	<TD CLASS='personalInfo' NOWRAP>�F<%=Session("PerID")%></TD>
</TR>
<TR>
	<TD CLASS='personalInfo' NOWRAP>����</TD>
	<TD CLASS='personalInfo' NOWRAP>�F<%=Session("LastName") & "�@" & Session("FirstName")%></TD>
</TR>
<TR>
	<TD CLASS='personalInfo' NOWRAP>����</TD>
<%
	If Session("Gender") = 1 Then
		strValue = "�j"
	Else
		strValue = "��"
	End If
%>	
	<TD CLASS='personalInfo' NOWRAP>�F<%=strValue%></TD>
</TR>
<TR>
	<TD CLASS='personalInfo' NOWRAP>���N����</TD>
	<TD CLASS='personalInfo' NOWRAP>�F<%=Session("Birth")%></TD>
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
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Clear%>)"><IMG SRC=<%=MH_ImagePath & "clear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�N���A"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Regist%>)"><IMG SRC=<%=MH_ImagePath & "regist.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�o�^"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Back%>)"><IMG SRC=<%=MH_ImagePath & "back.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
</CENTER>

</FORM>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>