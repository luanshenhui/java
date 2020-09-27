<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����^���w���X�@�i���E�����`�F�b�N��ʕ\������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem6.inc"-->
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
Dim intRadioCount
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
strMode = CInt(Request("ModeItem6"))

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
			strTarget = "mhConsulItem5.asp"
		Case MH_Mode_Next
			'����ʂɑJ��
			strTarget = "mhConsulItem7.asp"
		Case MH_Mode_Result
			'�����]���ɑJ��
			Session("FromAsp") = "mhConsulItem6.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'�Z�b�V�����ɃZ�b�g
	Session("Refusal6") = Request("Check6")
	For i = 0 To UBound(aryQuestion)
		If i = 1 Then
			For j = 1 To 3
				Session("Q6-" & i + 1 & "-" & j) = Request("A6_" & i + 1 & "_" & j)
			Next
		Else
			Session("Q6-" & i + 1) = Request("A6_" & i + 1)
		End If
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
<TITLE>���Ȃ��̋i���E�����`�F�b�N</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn,ChkSmoke,chkDrink;
	var myForm = document.ConsulItem6;	// ����ʂ̃t�H�[���G�������g
	
	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			if (!myForm.Check6.checked){
				//�񓚋��ۂ���Ȃ��ꍇ�A�K�{�`�F�b�N
				//�i���`�F�b�N
				ChkSmoke = -1;
				for (i=0; i<myForm.A6_1.length; i++) {
					if (eval("myForm.A6_1[" + i + "].checked")) {
						ChkSmoke  = i;
						break;
					}
				}
				if (ChkSmoke < 0) {
					alert("�i���Ɋւ���ݖ� 1�̉񓚂�I�����Ă��������B");
					return;
				}

				if (ChkSmoke == 0) {
					//�������z���ꍇ�A�ݖ�Q�`�W�K�{�`�F�b�N
					//�ݖ�Q�K�{�`�F�b�N
					//�i�����ԃ`�F�b�N
					if (myForm.A6_2_1.value == ""){
						alert("�i�����Ԃ���͂��Ă��������B");
						return;
					}
					//�i���{���`�F�b�N
					if (myForm.A6_2_2.value == ""){
						alert("�i���{������͂��Ă��������B");
						return;
					}
					//�����`�F�b�N
					chkOn = false;
					for (j=0; j<myForm.A6_2_3.length; j++) {
						if (eval("myForm.A6_2_3[" + j + "].checked")) {
							chkOn  = true;
							break;
						}
					}
					
					if (chkOn == false) {
						alert("��ȃ^�o�R�̖�����I�����Ă��������B");
						return;
					}

					for (i=3; i<=8; i++) {
						//�ݖ�R�`�W�K�{�`�F�b�N
						chkOn = false;
						for (j=0; j<eval("myForm.A6_" + i + ".length"); j++) {
							if (eval("myForm.A6_" + i + "[" + j + "]" + ".checked")) {
								chkOn  = true;
								break;
							}
						}
						
						if (chkOn == false) {
							alert("�i���Ɋւ���ݖ� " + i + "�̉񓚂�I�����Ă��������B");
							return;
						}
					}
				}
			}
			//if (myForm.A6_2_1.value != "" && !myForm.A6_2_1.value.match('^[0-9]+$')) {
			if (myForm.A6_2_1.value  != "" && isNaN(Number(myForm.A6_2_1.value))) {
				alert("�i�����Ԃɂ́A���l����͂��ĉ������B");
				return;
			}
			//if (myForm.A6_2_2.value != "" && ! myForm.A6_2_2.value.match('^[0-9]+$')) {
				if (myForm.A6_2_2.value != "" && isNaN(Number(myForm.A6_2_2.value))) {
				alert("�i���{���ɂ́A���l����͂��ĉ������B");
				return;
			}

			if (!myForm.Check6.checked){
				//�����`�F�b�N
				chkDrink = -1;
				for (i=0; i<myForm.A6_9.length; i++) {
					if (eval("myForm.A6_9[" + i + "].checked")) {
						chkDrink  = i;
						break;
					}
				}
				if (chkDrink < 0) {
					alert("�����Ɋւ���ݖ� 1�̉񓚂�I�����Ă��������B");
					return;
				}

				if (chkDrink > 0) {
					//����������ꍇ�A�ݖ�P�O�`�P�W�K�{�`�F�b�N
					for (i=10; i<=18; i++) {
						//�ݖ�P�O�`�P�W�K�{�`�F�b�N
						chkOn = false;
						for (j=0; j<eval("myForm.A6_" + i + ".length"); j++) {
							if (eval("myForm.A6_" + i + "[" + j + "]" + ".checked")) {
								chkOn  = true;
								break;
							}
						}
						
						if (chkOn == false) {
							alert("�����Ɋւ���ݖ� " + (i - 8) + "�̉񓚂�I�����Ă��������B");
							return;
						}
					}
				}
			}
			break;
		default:
			break;
	}

	//submit
	myForm.ModeItem6.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem6;	// ����ʂ̃t�H�[���G�������g

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}

//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem6" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>6/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>�Y�D���Ȃ��̋i���E�����`�F�b�N</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal6") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check6' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='10'>�i���ɂ��Ă��f�����܂�</TD></TR>
<%
For i = 0 To UBound(aryQuestion)
	'�w�b�_�[�ݒ�
	Select case i + 1
		Case 2
%>
			<TR CLASS='head'><TD COLSPAN='10'>�P�j�Ƀ`�F�b�N��t�������ɂ��f�����܂��@<A HREF="#DrinkHead" CLASS="headA">�Q�j�܂��͂R�j�̕��͂������N���b�N���Ĉ����ɐi��ł�������</A></TD></TR>
<%
		Case 9
%>
			<TR CLASS='head'><TD COLSPAN='10'><A NAME="DrinkHead"> ���ɁA�����ɂ��Ă��f�����܂�</TD></TR>
<%
		Case 10
%>
			<TR CLASS='head'><TD COLSPAN='10'>���������܂Ȃ����́A<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)" CLASS="headA">�������N���b�N���ćZ�ɐi��ł�������</A></TD></TR>
<%
	End Select

	'���W�I�{�^��MAX���ݒ�
	intRadioCount = 0

	Select case i + 1
		Case 1,2,5,8,17,18
			intRadioCount = 3
		Case 3,4,6,7
			intRadioCount = 2
		Case Else
			intRadioCount = 5
	End Select

	Select case i + 1
		Case 1			'�ݖ�P
			'���W�I�{�^���c�Ȃ��
%>
			<TR CLASS='question'>
				<TD COLSPAN='9'><%=aryQuestion(i)%></TD>
				<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A6_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������"></A></TD>
			</TR>
<%
			For j = 0 To intRadioCount - 1
				strCheck = ""
				If not isEmpty(Session("Q6-" & i + 1 )) And not isNull(Session("Q6-" & i + 1 )) Then
					If CInt(Session("Q6-" & i + 1 )) = j + 1 Then
						strCheck = "CHECKED"
					End If
				End If
%>
				<TR><TD COLSPAN='10' NOWRAP><INPUT TYPE='radio' NAME='<%="A6_" & i + 1%>' VALUE='<%=j + 1%>' <%=strCheck%>>
					<%=aryAnswer(i,j)%></TD>
				</TR>
<%
			Next

		Case 2			'�ݖ�Q
			'�e�L�X�g�\��
			strValue = ""
			If not isEmpty(Session("Q6-" & i + 1 & "-1")) Then
				strValue = Session("Q6-" & i + 1 & "-1")
			End If
%>
			<TR CLASS='question'>
				<TD COLSPAN='9'><%=aryQuestion(i)%></TD>
				<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A6_" & i + 1 & "_3"%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������"></A></TD>
			</TR>
			<TR>
			<TD COLSPAN='2' NOWRAP>�i������<INPUT TYPE='text' NAME='<%="A6_" & i + 1 & "_1"%>' MAXLENGTH='5' VALUE='<%=strValue%>' SIZE='5' ISTYLE='4'>�N��</TD>
<%
			strValue = ""
			If not isEmpty(Session("Q6-" & i + 1 & "-2")) Then
				strValue = Session("Q6-" & i + 1 & "-2")
			End If
%>
			<TD COLSPAN='2' NOWRAP>�i���{��<INPUT TYPE='text' NAME='<%="A6_" & i + 1 & "_2"%>' MAXLENGTH='5' VALUE='<%=strValue%>' SIZE='5' ISTYLE='4'>�{</TD>
			</TR>
<%
			'���W�I�{�^���c�Ȃ��
			For j = 0 To intRadioCount - 1
				strCheck = ""
				If not isEmpty(Session("Q6-" & i + 1 & "-3")) And not isNull(Session("Q6-" & i + 1 & "-3")) Then
					If CInt(Session("Q6-" & i + 1 & "-3")) = j + 1 Then
						strCheck = "CHECKED"
					End If
				End If
%>
				<TR><TD COLSPAN='10' NOWRAP><INPUT TYPE='radio' NAME='<%="A6_" & i + 1 & "_3"%>' VALUE='<%=j + 1%>' <%=strCheck%>>
					<%=aryAnswer(i,j)%></TD>
				</TR>
<%
			Next

		Case Else	'���W�I�{�^�����Ȃ��
%>
			<TR CLASS='question'>
				<TD COLSPAN='9'><%=aryQuestion(i)%></TD>
				<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A6_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������"></A></TD>
			</TR>
			<TR>
<%
			For j = 0 To intRadioCount - 1
				strCheck = ""
				If not isEmpty(Session("Q6-" & i + 1 )) And not isNull(Session("Q6-" & i + 1 )) Then
					If CInt(Session("Q6-" & i + 1 )) = j + 1 Then
						strCheck = "CHECKED"
					End If
				End If
%>
				<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A6_" & i + 1%>' VALUE='<%=j + 1%>' <%=strCheck%>></TD>
				<TD WIDTH='160' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
			Next
%>
			</TR>
<%
	End Select
Next
%>
</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem6"   VALUE="">
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
