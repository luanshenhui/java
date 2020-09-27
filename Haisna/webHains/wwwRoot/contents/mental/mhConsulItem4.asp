<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����^���w���X�@���_���N�x�`�F�b�N��ʕ\������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem4.inc"-->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objMentalHealth '�����^���w���X���A�N�Z�X�p

Dim i
Dim j
Dim strCheck
Dim strTarget
Dim arrQuestion()	'�S���⍀�ږ�
Dim arrAnswer()		'�S��

'�󂯎��p�����[�^
Dim lngRsvNo	'�\��ԍ�
Dim strMode		'�I�����ꂽ�A�N�V����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�p�����[�^�擾
lngRsvNo = Request("RSVNO")
strMode = CInt(Request("ModeItem4"))

'���O�C���`�F�b�N
If LoginCheck(lngRsvNo) = False Then
	Response.Redirect "mhError.asp"
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objMentalHealth = Server.CreateObject("HainsMentalHealth.MentalHealth")

Do
	Select Case strMode
		Case MH_Mode_Back
			'�O��ʂɖ߂�
			strTarget = "mhConsulItem3.asp"
		Case MH_Mode_Next
			'����ʂɑJ��
			strTarget = "mhConsulItem5.asp"
		Case MH_Mode_Result
			'�����]���ɑJ��
			Session("FromAsp") = "mhConsulItem4.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'�Z�b�V�����ɃZ�b�g
	Session("Refusal4") = Request("Check4")
	For i = 0 To UBound(aryQuestion)
		Session("Q4-" & i + 1) = Request("A4_" & i + 1)
	Next
	
	If strMode = MH_Mode_Result Then
		'�Z�b�V�������\���̂ɃZ�b�g
		If SetUpdateArray(arrQuestion, arrAnswer) = False Then
		End if
		'�c�a�X�V����
		If objMentalHealth.InsertControlMentalHealth(Session("RsvNo"), arrQuestion, arrAnswer) = False Then
			'�G���[
			Session("ErrorMsg1") = "�����^���w���X���̍X�V�Ɏ��s���܂���"
			Session("ErrorMsg2") = "�\���󂠂�܂��񂪁A�T�|�[�g�S���҂܂ł��A����������"
			Response.Redirect "mhError.asp"
		End If
	End If

	'���_�C���N�g
	Response.Redirect strTarget & "?RSVNO=" & lngRsvNo
	Exit Do
Loop

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">

<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>���Ȃ��̐��_���N�x�`�F�b�N</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn;
	var myForm = document.ConsulItem4;	// ����ʂ̃t�H�[���G�������g
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			if (!myForm.Check4.checked){
				//�񓚋��ۂ���Ȃ��ꍇ�A�K�{�`�F�b�N
				for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
					//�K�{�`�F�b�N
					chkOn = false;
					for (j=0; j<eval("myForm.A4_" + (i + 1) + ".length"); j++) {
						if (eval("myForm.A4_" + (i + 1) + "[" + j + "]" + ".checked")) {
							chkOn  = true
							break;
						}
					}
					
					if (chkOn == false) {
						alert("�ݖ� " + (i + 1) + "�ɑ΂���񓚂�I�����Ă��������B");
						return;
					}
				}
			}
			break;
		default:
			break;
	}

	//submit
	myForm.ModeItem4.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem4;	// ����ʂ̃t�H�[���G�������g

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem4" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>4/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>�W�D���Ȃ��̐��_���N�x�`�F�b�N</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal4") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check4' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='8'>���̐��T�Ԃ̌��N��Ԃɂ��Ă��f�����܂�</TD></TR>
<%
For i = 0 To UBound(aryQuestion)
%>
	<TR CLASS='question'>
		<TD COLSPAN='7'><%=aryQuestion(i)%></TD>
		<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A4_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������"></A></TD>
	</TR>
	<TR>
<%
	For j = 0 To 3
		strCheck = ""
		If not isEmpty(Session("Q4-" & i + 1 )) And not isNull(Session("Q4-" & i + 1 )) Then
			If CInt(Session("Q4-" & i + 1 )) = j + 1 Then
				strCheck = "CHECKED"
			End If
		End If
%>
		<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A4_" & i + 1%>' VALUE='<%=j + 1%>' <%=strCheck%>></TD>
		<TD WIDTH='180' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
	Next
%>
	</TR>
<%
Next
%>
</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem4"   VALUE="">
<INPUT TYPE="hidden" NAME="RSVNO"       VALUE="<%=lngRsvNo%>">

<%If Session("LoginDiv") = 1 Then%>
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Result%>)"><IMG SRC=<%=MH_ImagePath & "result.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�����]��"></A>
<%End If%>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Clear%>)"><IMG SRC=<%=MH_ImagePath & "clear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�N���A"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Back%>)"><IMG SRC=<%=MH_ImagePath & "back.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)"><IMG SRC=<%=MH_ImagePath & "next.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="����"></A>
</FORM>
</CENTER>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>
