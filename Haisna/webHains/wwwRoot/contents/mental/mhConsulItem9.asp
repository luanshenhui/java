<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����^���w���X�@�]�Ƀ`�F�b�N��ʕ\������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem9.inc"-->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objMentalHealth '�����^���w���X���A�N�Z�X�p

Dim i
Dim j
Dim strCheck
Dim strValue
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
strMode = CInt(Request("ModeItem9"))

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
			strTarget = "mhConsulItem8.asp"
		Case MH_Mode_Next
			'����ʂɑJ��
			strTarget = "mhConsulItem10.asp"
		Case MH_Mode_Result
			'�����]���ɑJ��
			Session("FromAsp") = "mhConsulItem9.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'�Z�b�V�����ɃZ�b�g
	Session("Refusal9") = Request("Check9")
	Session("Q9-1") = Request("A9_1")
	For i = 0 To Ubound(aryAnswer2) + 1
		Session("Q9-2-" & i + 1) = Request("A9_2_" & i + 1)
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
<TITLE>���Ȃ��̗]�Ƀ`�F�b�N</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn;
	var myForm = document.ConsulItem9;	// ����ʂ̃t�H�[���G�������g
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			if (!myForm.Check9.checked){
				//�񓚋��ۂ���Ȃ��ꍇ�A�K�{�`�F�b�N
				//�ݖ�P�K�{�`�F�b�N
				chkOn = false;
				for (j=0; j<myForm.A9_1.length; j++) {
					if (eval("myForm.A9_1[" + j + "]" + ".checked")) {
						chkOn  = true
						break;
					}
				}
				
				if (chkOn == false) {
					alert("�ݖ�P�ɑ΂���񓚂�I�����Ă��������B");
					return;
				}
				//�ݖ�Q���̑����`�F�b�N����Ă��鎞�A�e�L�X�g�K�{�`�F�b�N
				if (myForm.A9_2_38.checked && myForm.A9_2_39.value == "") {
					alert("���̑����`�F�b�N�����ꍇ�́A�ǂ̂悤�Ȃ��Ƃ������̂����͂��Ă��������B");
					return;
				}
			}
			break;
		default:
			break;
	}

	//submit
	myForm.ModeItem9.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem9;	// ����ʂ̃t�H�[���G�������g

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem9" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>9/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>�\�D���Ȃ��̗]�Ƀ`�F�b�N</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal9") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check9' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='10'>���Ȃ��̗]�ɂ̉߂������ɂ��Ă��f�����܂�</TD></TR>

<TR CLASS='question'>
	<TD COLSPAN='9'>�P�D�]�ɂ͂ǂȂ��Ɖ߂�����܂����@�Y��������̈��I�����Ă�������</TD>
	<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A9_1"%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������"></A></TD>
</TR>
<TR>
<%
For i = 0 To Ubound(aryAnswer1)
	If (i mod 5) = 0 Then
%>
		<!--�P��ɂT�܂�-->
		</TR><TR>
<%
	End If

	strCheck = ""
	If not isEmpty(Session("Q9-1")) And not isNull(Session("Q9-1")) Then
		If CInt(Session("Q9-1")) = i + 1 Then
			strCheck = "CHECKED"
		End If
	End If
%>
	<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A9_1"%>' VALUE='<%=i + 1%>' <%=strCheck%>></TD>
	<TD WIDTH='150' NOWRAP><%=aryAnswer1(i)%></TD>
<%
Next
%>
</TR>

<TR CLASS='question'><TD COLSPAN='10'>�Q�D�]�ɂɂ́A�ǂ̂悤�Ȃ��Ƃ�����܂����@�Y��������̑S�Ă�I�����Ă�������</TD></TR>
<TR>
<%
For i = 0 To Ubound(aryAnswer2)
	If (i mod 5) = 0 Then
%>
		<!--�P��ɂT�܂�-->
		</TR><TR>
<%
	End If

	strCheck = ""
	If not isEmpty(Session("Q9-2-" & i + 1)) And not isNull(Session("Q9-2-" & i + 1)) Then
		If CInt(Session("Q9-2-" & i + 1)) = 1 Then
			strCheck = "CHECKED"
		End If
	End If
%>
	<TD NOWRAP><INPUT TYPE='checkbox' NAME='<%="A9_2_" & i + 1 %>' VALUE='1' <%=strCheck%>></TD>
	
<%
	If i = Ubound(aryAnswer2) Then
		'���̑��̏ꍇ�e�L�X�g�\��
		strValue = ""
		If not isEmpty(Session("Q9-2-" & i + 2)) Then
			strValue = Session("Q9-2-" & i + 2)
		End If
%>
		<TD COLSPAN='6' NOWRAP><%=aryAnswer2(i)%>&nbsp;<INPUT TYPE='text' NAME='<%="A9_2_" & i + 2 %>' MAXLENGTH='80' VALUE='<%=strValue%>' SIZE='80' ></TD>
<%
	Else
%>
		<TD WIDTH='150' NOWRAP><%=aryAnswer2(i)%></TD>
<%
	End If
Next
%>
</TR>
</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem9"   VALUE="">
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
