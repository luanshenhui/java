<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����^���w���X�@�Ǐ�`�F�b�N��ʕ\������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem3.inc"-->
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
strMode = CInt(Request("ModeItem3"))

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
			strTarget = "mhConsulItem2.asp"
		Case MH_Mode_Next
			'����ʂɑJ��
			strTarget = "mhConsulItem4.asp"
		Case MH_Mode_Result
			'�����]���ɑJ��
			Session("FromAsp") = "mhConsulItem3.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'�Z�b�V�����ɃZ�b�g
	Session("Refusal3") = Request("Check3")
	For i = 0 To UBound(aryQuestion)
		Session("Q3-" & i + 1) = Request("A3_" & i + 1)
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
<TITLE>���Ȃ��̏Ǐ�`�F�b�N</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn;
	var myForm = document.ConsulItem3;	// ����ʂ̃t�H�[���G�������g
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			if (!myForm.Check3.checked){
				//�񓚋��ۂ���Ȃ��ꍇ�A�K�{�`�F�b�N
				for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
					//�K�{�`�F�b�N
					chkOn = false;
					for (j=0; j<eval("myForm.A3_" + (i + 1) + ".length"); j++) {
						if (eval("myForm.A3_" + (i + 1) + "[" + j + "]" + ".checked")) {
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
	myForm.ModeItem3.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem3;	// ����ʂ̃t�H�[���G�������g

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}

//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem3" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>3/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>�V�D���Ȃ��̏Ǐ�`�F�b�N</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal3") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check3' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE BORDER="1" CELLSPACING="0" CELLPADDING="5" CLASS="tableNomal">
<TR CLASS='head'><TD COLSPAN='4'>���݈ȉ��̂悤�ȏǏ󂪂���܂���</TD></TR>
<TR CLASS='questionCenter'>
<%
For i = 0 To 1
%>
	<TD WIDTH='160' NOWRAP>�Ǐ�</TD>
	<TD WIDTH='295' NOWRAP>�L����</TD>
<%
Next
%>
</TR>

<%
For i = 0 To 22
%>
	<TR>
	<!--�P��ځi�ݖ�Q�R�܂Łj-->
	<TD WIDTH='160' NOWRAP>
		<%=aryQuestion(i)%>
		<A HREF="JavaScript:CheckClear('<%="A3_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������" ALIGN='right'></A>
	</TD>
	<TD WIDTH='295' NOWRAP>
<%
	For j = 0 To UBound(aryAnswer)
		strCheck = ""
		If not isEmpty(Session("Q3-" & i + 1)) And not isNull(Session("Q3-" & i + 1)) Then
			If CInt(Session("Q3-" & i + 1)) = j Then
				strCheck = "CHECKED"
			End If
		End If
%>
		<INPUT TYPE='radio' NAME='<%="A3_" & i + 1%>' VALUE='<%=j%>' <%=strCheck%>>
		<%=aryAnswer(j)%>
<%
	Next
%>
	</TD>

	<!--�Q��ځi�ݖ�Q�R�ȍ~�j-->
	<TD  WIDTH='160' NOWRAP>
		<%=aryQuestion(i + 23)%>
		<A HREF="JavaScript:CheckClear('<%="A3_" & (i + 23) + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������" ALIGN='right'></A>
	</TD>
	<TD  WIDTH='295' NOWRAP>
<%
	For j = 0 To UBound(aryAnswer)
		strCheck = ""
		If not isEmpty(Session("Q3-" & (i + 23) + 1)) And not isNull(Session("Q3-" & (i + 23) + 1)) Then
			If CInt(Session("Q3-" & (i + 23) + 1)) = j Then
				strCheck = "CHECKED"
			End If
		End If
%>
		<INPUT TYPE='radio' NAME='<%="A3_" & (i + 23) + 1%>' VALUE='<%=j%>' <%=strCheck%>>
		<%=aryAnswer(j)%>
<%
	Next
%>
	</TD>
	</TR>
<%
Next
%>

</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem3"   VALUE="">
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
