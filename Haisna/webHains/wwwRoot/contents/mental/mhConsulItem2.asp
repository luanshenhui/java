<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����^���w���X�@���Ȃ��̎��Ï����͉�ʕ\������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem2.inc"-->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objMentalHealth '�����^���w���X���A�N�Z�X�p

Dim i
Dim j
Dim strCheck
Dim strValue
Dim strTarget		'�J�ڐ�
Dim intRadioCount	'�I���\���W�I�{�^����
Dim arrQuestion()	'�S���⍀�ږ�
Dim arrAnswer()		'�S��
Dim test

'�󂯎��p�����[�^
Dim lngRsvNo	'�\��ԍ�
Dim strMode		'�I�����ꂽ�A�N�V����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�p�����[�^�擾
lngRsvNo = Request("RSVNO")
strMode = CInt(Request("ModeItem2"))

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
			strTarget = "mhConsulItem1.asp"
		Case MH_Mode_Next
			'����ʂɑJ��
			strTarget = "mhConsulItem3.asp"
		Case MH_Mode_Result
			'�����]���ɑJ��
			Session("FromAsp") = "mhConsulItem2.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'�Z�b�V�����ɃZ�b�g
	Session("Refusal2") = Request("Check2")
	For i = 0 To UBound(aryQuestion)
		For j = 1 To 3
			Session("Q2-" & i + 1 & "-" & j) = Request("A2_" & i + 1 & "_" & j)
		Next
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
<TITLE>���Ȃ��̎��Ï�����</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkSick,chkTreat,strMsg;
	var myForm = document.ConsulItem2;	// ����ʂ̃t�H�[���G�������g
	var Question = new Array(10);
	Question[0] = "������";
	Question[1] = "���A�a";
	Question[2] = "�̑��a";
	Question[3] = "��������";
	Question[4] = "�S���a";
	Question[5] = "�]����";
	Question[6] = "�ɕ�";
	Question[7] = "���̑�";
	Question[8] = "���̑�";
	Question[9] = "���̑�";
	Question[10] = "���̑�";
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
				strMsg = "";
				chkSick = -1;
				if (!myForm.Check2.checked){
					//�񓚋��ۂ���Ȃ��ꍇ�A�K�{�`�F�b�N
					if (i < 7){
						//�a������Ȃ��`�F�b�N(���W�I�{�^��)
						for (j=0; j<eval("myForm.A2_" + (i + 1) + "_1.length"); j++) {
							if (eval("myForm.A2_" + (i + 1) + "_1[" + j + "]" + ".checked")) {
								chkSick  = j;
								break;
							}
						}

						if (chkSick < 0) {
							alert(Question[i] + "�ɑ΂��邠��E�Ȃ���I�����Ă��������B");
							return;
						}
					}else{
						//�a������Ȃ��`�F�b�N(�e�L�X�g����)
						if (eval("myForm.A2_" + (i + 1) + "_1.value") != ""){
							chkSick = 0;
							strMsg = eval("myForm.A2_" + (i + 1) + "_1.value");
						}
					}
					
					if (chkSick == 0){
						//�a������̏ꍇ�̂�
						//���ԓ��̓`�F�b�N
						if (eval("myForm.A2_" + (i + 1) + "_2.value") == ""){
							if (strMsg == "") {
								alert(Question[i] + "�ɑ΂�����Ԃ���͂��Ă��������B");
							} else {
								alert(strMsg + "�ɑ΂�����Ԃ���͂��Ă��������B");
							}
							return;
						}

						//���Ó��e�`�F�b�N
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
									alert(Question[i] + "�ɑ΂��鎡�Ó��e��I�����Ă��������B");
								} else {
									alert(strMsg + "�ɑ΂��鎡�Ó��e��I�����Ă��������B");
								}
								return;
							}
						}
					}
				}
				//�񓚋��ۂɊւ�炸�A���l���ڂ����͂���Ă���ꍇ�́A���l�`�F�b�N
				//���ԃt�H�[�}�b�g�`�F�b�N
				//if (eval("myForm.A2_" + (i + 1) + "_2.value") != "" && ! eval("myForm.A2_" + (i + 1) + "_2.value.match('^[0-9]+$')") ) {
				if (eval("myForm.A2_" + (i + 1) + "_2.value") != "" && isNaN(Number(eval("myForm.A2_" + (i + 1) + "_2.value")))) {
					if (strMsg == "") {
						alert(Question[i] + "�ɑ΂�����Ԃɂ́A���l����͂��Ă��������B");
					} else {
						alert(strMsg + "�ɑ΂�����Ԃɂ́A���l����͂��Ă��������B");
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
	var myForm = document.ConsulItem2;	// ����ʂ̃t�H�[���G�������g

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
<DIV CLASS='title' NOWRAP>�U�D���Ȃ��̎��Ï�����</DIV>
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
<TR CLASS='head'><TD COLSPAN='5'>���݁A���邢�͂���܂łɂ��Ȃ������Â��󂯂Ă���a�C������܂�����A�L�����Ă�������</TD></TR>
<TR CLASS='questionCenter'>
	<TD>�a��</TD>
	<TD>&nbsp;</TD>
	<TD>����</TD>
	<TD>���Ó��e</TD>
	<TD>&nbsp;</TD>
</TR>

<%
For i = 0 To UBound(aryQuestion)
	Select Case i + 1
		Case 1,4,7
			'���Ó��e'-'
			intRadioCount = 0
		Case 2
			'���Ó��e�@���@�E�ʉ@
			intRadioCount = 1
		Case 3,5,6
			'���Ó��e�@��p�E���@�E�ʉ@
			intRadioCount = 2
		Case Else
			'�a������
			intRadioCount = 3
	End Select
%>
<TR>
<%
	'�a��
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
		'�e�L�X�g�\��
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

	'����
	strValue = ""
	If not isEmpty(Session("Q2-" & i + 1 & "-2")) Then
		strValue = Session("Q2-" & i + 1 & "-2")
	End If
%>
	<TD NOWRAP><INPUT TYPE='text' NAME='<%="A2_" & i + 1 & "_2"%>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' >�N��</TD>
	
<%
	'���Ó��e
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
		<TD ALIGN='center' NOWRAP>�|</TD>
<%
	End If
%>
	<TD NOWRAP><A HREF="JavaScript:CheckClear(<%=i + 1%>)"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������" ALIGN="right" ></A></TD>
</TR>
<%
Next
%>

</TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem2"   VALUE="">
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
