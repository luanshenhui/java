<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����^���w���X�@�H���E�^���`�F�b�N��ʕ\������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem7.inc"-->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objMentalHealth '�����^���w���X���A�N�Z�X�p

Dim i
Dim j
Dim k
Dim strCheck
Dim strValue
Dim strTarget
Dim intMaxLoopCount
Dim intMaxQuestion
Dim intMaxItem
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
strMode = CInt(Request("ModeItem7"))

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
			strTarget = "mhConsulItem6.asp"
		Case MH_Mode_Next
			'����ʂɑJ��
			strTarget = "mhConsulItem8.asp"
		Case MH_Mode_Result
			'�����]���ɑJ��
			Session("FromAsp") = "mhConsulItem7.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'�Z�b�V�����ɃZ�b�g
	Session("Refusal7") = Request("Check7")

	For i = 0 To UBound(aryQuestion)
		intMaxQuestion = 0
		intMaxItem = 0
		Select case i + 1
			Case 11
				intMaxQuestion = 2
				intMaxItem = 5
			Case 13,14
				intMaxQuestion = 2
				intMaxItem = 3
			Case 15
				intMaxQuestion = 5
				intMaxItem = 2
		End Select

		If intMaxQuestion > 0 Then
			'�P�̐ݖ�ɕ����񓚗��̂���ꍇ
			For j = 1 To intMaxQuestion
				For k = 1 To intMaxItem
					Session("Q7-" & i + 1 & "-" & j & "-" & k ) = Request("A7_" & i + 1 & "_" & j & "_" & k )
				Next
			Next
		Else
			Session("Q7-" & i + 1) = Request("A7_" & i + 1)
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
<TITLE>���Ȃ��̐H���E�^���`�F�b�N</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn,chkAct,chkWalk;
	var	strMsg
	var myForm = document.ConsulItem7;	// ����ʂ̃t�H�[���G�������g

	switch (strActMode) {
		case <%=MH_Mode_Back%>:
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			//�񓚋��ۂ���Ȃ��ꍇ�A�K�{�`�F�b�N
			chkAct = false;
			for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
				switch (i + 1) {
					case 1:case 2:case 3:case 4:case 5:case 6:case 7:case 8:
					case 9:case 10:case 12:case 16:
						if (!myForm.Check7.checked){
							//���W�I�{�^���K�{�`�F�b�N
							chkOn = false;
							for (j=0; j<eval("myForm.A7_" + (i + 1) + ".length"); j++) {
								if (eval("myForm.A7_" + (i + 1) + "[" + j + "]" + ".checked")) {
									chkOn  = true
									if ((i + 1) == 12 && j == 0) {
										//����I�ɉ^�����Ă���
										chkAct = true;
									}
									break;
								}
							}
							
							if (chkOn == false) {
								if ((i + 1) > 10){
									alert( "�^���ɂ��Ă�" + "�ݖ� " + ((i + 1) - 10) + "�ɑ΂���񓚂�I�����Ă��������B");
								}else{
									alert( "�H�����ɂ��Ă�" + "�ݖ� " + (i + 1) + "�ɑ΂���񓚂�I�����Ă��������B");
								}
								return;
							}
						}
						break;
					case 11:
						//�����Ɋւ�炸�A���͂���Ă���ꍇ�A���l�`�F�b�N
						for (j=1; j<=2; j++) {
							//if (eval("myForm.A7_" + (i + 1) + "_" + j + "_2.value" ) != "" && ! eval("myForm.A7_" + (i + 1) + "_" + j + "_2.value.match('^[0-9]+$')" )) {
							if (eval("myForm.A7_" + (i + 1) + "_" + j + "_2.value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_2.value" )))) {
							
								alert("�ߋ��ɒ���I�A�p���I�ɍs�Ȃ��Ă���^����ڂ̎����ɂ́A���l����͂��ĉ������B");
								return;
							}
							//if (eval("myForm.A7_" + (i + 1) + "_" + j + "_3.value" ) != "" && ! eval("myForm.A7_" + (i + 1) + "_" + j + "_3.value.match('^[0-9]+$')" )) {
							if (eval("myForm.A7_" + (i + 1) + "_" + j + "_3.value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_3.value" )))) {
								alert("�ߋ��ɒ���I�A�p���I�ɍs�Ȃ��Ă���^����ڂ̎����ɂ́A���l����͂��ĉ������B");
								return;
							}
							//if (eval("myForm.A7_" + (i + 1) + "_" + j + "_4.value" ) != "" && ! eval("myForm.A7_" + (i + 1) + "_" + j + "_4.value.match('^[0-9]+$')" )) {
							if (eval("myForm.A7_" + (i + 1) + "_" + j + "_4.value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_4.value" )))) {
								alert("�ߋ��ɒ���I�A�p���I�ɍs�Ȃ��Ă���^����ڂ̕p�x�ɂ́A���l����͂��ĉ������B");
								return;
							}
							//if (eval("myForm.A7_" + (i + 1) + "_" + j + "_5.value" ) != "" && ! eval("myForm.A7_" + (i + 1) + "_" + j + "_5.value.match('^[0-9]+$')" )) {
							if (eval("myForm.A7_" + (i + 1) + "_" + j + "_5.value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_5.value" )))) {
								alert("�ߋ��ɒ���I�A�p���I�ɍs�Ȃ��Ă���^����ڂ̉^�����Ԃɂ́A���l����͂��ĉ������B");
								return;
							}
						}
						break;
					case 13:
						for (j=1; j<=3; j++) {
							//����I�ɍs�Ȃ��Ă���^���K�{�`�F�b�N
							if (!myForm.Check7.checked && chkAct == true){
								//�ݖ�P�Q�Łh�͂��h�̏ꍇ�̂�
								if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value") == ""){
									switch (j) {
										case 1:
											strMsg = "���ݒ���I�ɍs�Ȃ��Ă���^����ڂ���͂��Ă��������B";
											break;
										case 2:
											strMsg = "���ݒ���I�ɍs�Ȃ��Ă���^����ڂ̕p�x����͂��Ă��������B";
											break;
										case 3:
											strMsg = "���ݒ���I�ɍs�Ȃ��Ă���^����ڂ̉^�����Ԃ���͂��Ă��������B";
											break;
									}
									alert(strMsg);
									return;
								}
							}
							if (j > 1) {
								//�����Ɋւ�炸�A���͂���Ă���ꍇ�A���l�`�F�b�N
								//if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value" ) != "" && !eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value.match('^[0-9]+$')" )) {
								if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value" )))) {
									if (j == 2){
										alert("���ݒ���I�ɍs�Ȃ��Ă���^����ڂ̕p�x�ɂ́A���l����͂��ĉ������B");
									}else{
										alert("���ݒ���I�ɍs�Ȃ��Ă���^����ڂ̉^�����Ԃɂ́A���l����͂��ĉ������B");
									}
									return;
								}
								//if (eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value" ) != "" && !eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value.match('^[0-9]+$')" )) {
								if (eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value"  ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value"  )))) {
									if (j == 2){
										alert("���ݒ���I�ɍs�Ȃ��Ă���^����ڂ̕p�x�ɂ́A���l����͂��ĉ������B");
									}else{
										alert("���ݒ���I�ɍs�Ȃ��Ă���^����ڂ̉^�����Ԃɂ́A���l����͂��ĉ������B");
									}
									return;
								}
							}
						}
						break;
					case 14:
						if (!myForm.Check7.checked){
							//���s�E���s���ԁE���s���������ꂩ�K�{�`�F�b�N
							chkWalk = -1;
							for (j=1; j<=3; j++) {
								if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value") != ""){
									chkWalk = j;
									break;
								}
							}
							if (chkWalk < 0) {
								alert( "�����̕��s�E���s���ԁE���s���������ꂩ�ɓ��͂��Ă��������B");
								return;
							}
							
							//��L�œ��͂��ꂽ���ڂɑΉ�����x�����ڂ�K�{�`�F�b�N
							if (eval("myForm.A7_" + (i + 1) + "_2_" + chkWalk + ".value") == ""){
								switch (chkWalk) {
									case 1:
										strMsg = "�x���̕��s����͂��Ă��������B";
										break;
									case 2:
										strMsg = "�x���̕��s���Ԃ���͂��Ă��������B";
										break;
									case 3:
										strMsg = "�x���̕��s��������͂��Ă��������B";
										break;
								}
								alert(strMsg);
								return;
							}
							
						}

						//�����Ɋւ�炸�A���͂���Ă���ꍇ�A���l�`�F�b�N
						for (j=1; j<=3; j++) {
							if (eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value") != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_1_" + j + ".value")))) {
								switch (j) {
									case 1:
										strMsg = "�����̕��s�ɂ́A���l����͂��ĉ������B";
										break;
									case 2:
										strMsg = "�����̕��s���Ԃɂ́A���l����͂��ĉ������B";
										break;
									case 3:
										strMsg = "�����̕��s�����ɂ́A���l����͂��ĉ������B";
										break;
								}
								alert(strMsg);
								return;
							}
							if (eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value") != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_2_" + j + ".value")))) {
								switch (j) {
									case 1:
										strMsg = "�x���̕��s�ɂ́A���l����͂��ĉ������B";
										break;
									case 2:
										strMsg = "�x���̕��s���Ԃɂ́A���l����͂��ĉ������B";
										break;
									case 3:
										strMsg = "�x���̕��s�����ɂ́A���l����͂��ĉ������B";
										break;
								}
								alert(strMsg);
								return;
							}
						}
						break;
					case 15:
						//�����ɔ�₵�����ԕK�{�`�F�b�N
						for (j=1; j<=5; j++) {
							for (k=1; k<=2; k++) {
								if (!myForm.Check7.checked){
									if (eval("myForm.A7_" + (i + 1) + "_" + j + "_" + k + ".value") == ""){
										if (k == 1){
											strMsg = "�����A";
										}else{
											strMsg = "�x���A";
										}
										switch (j) {
											case 1:
												strMsg += "�����������ɔ�₵�����Ԃ���͂��Ă��������B";
												break;
											case 2:
												strMsg += "�����x�̊����ɔ�₵�����Ԃ���͂��Ă��������B";
												break;
											case 3:
												strMsg += "�y�������ɔ�₵�����Ԃ���͂��Ă��������B";
												break;
											case 4:
												strMsg += "�������܂܂̐����ɔ�₵�����Ԃ���͂��Ă��������B";
												break;
											case 5:
												strMsg += "�����ɔ�₵�����Ԃ���͂��Ă��������B";
												break;
										}
										alert(strMsg);
										return;
									}
								}

								//�����Ɋւ�炸�A���͂���Ă���ꍇ�A���l�`�F�b�N
								if (eval("myForm.A7_" + (i + 1) + "_" + j + "_" + k + ".value" ) != "" && isNaN(Number(eval("myForm.A7_" + (i + 1) + "_" + j + "_" + k + ".value" )))) {
									if (k == 1){
										strMsg = "�����A";
									}else{
										strMsg = "�x���A";
									}
									switch (j) {
										case 1:
											strMsg += "�����������ɔ�₵�����Ԃɂ́A���l����͂��ĉ������B";
											break;
										case 2:
											strMsg += "�����x�̊����ɔ�₵�����Ԃɂ́A���l����͂��ĉ������B";
											break;
										case 3:
											strMsg += "�y�������ɔ�₵�����Ԃɂ́A���l����͂��ĉ������B";
											break;
										case 4:
											strMsg += "�������܂܂̐����ɔ�₵�����Ԃɂ́A���l����͂��ĉ������B";
											break;
										case 5:
											strMsg += "�����ɔ�₵�����Ԃɂ́A���l����͂��ĉ������B";
											break;
									}
									alert(strMsg);
									return;
								}

							}
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
	myForm.ModeItem7.value = strActMode;
	myForm.submit();

}
function CheckClear(strAnser) {
	var j;
	var myForm = document.ConsulItem7;	// ����ʂ̃t�H�[���G�������g

	for (j=0; j<eval("myForm." + strAnser +".length"); j++) {
		eval("myForm." + strAnser +"[j].checked = false");
	}
}
//-->
</SCRIPT>
</HEAD>

<BODY>
<CENTER>
<FORM NAME="ConsulItem7" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<DIV CLASS='page' NOWRAP>7/<%=MH_TotalPage%></DIV>
<HR ALIGN=center>
<DIV CLASS='title' NOWRAP>�Z�D���Ȃ��̐H���E�^���`�F�b�N</DIV>
<HR ALIGN=center>
<TABLE>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText1%></TD></TR>
<TR><TD CLASS='attention' NOWRAP><%=MH_RefusalText2%></TD></TR>
<%
strCheck = ""
If Session("Refusal7") = 1 Then
	strCheck = "CHECKED"
End If
%>
<TR><TD ALIGN=center NOWRAP><INPUT TYPE='checkbox' NAME='Check7' VALUE='1' <%=strCheck%>>
<%=MH_RefusalText3%>
</TD></TR>
</TABLE>
<HR ALIGN=center>

<TABLE CELLSPACING="0" CELLPADDING="0" CLASS="tableNomal"><TR><TD>
<TABLE CELLSPACING="0" CELLPADDING="5">
<TR CLASS='head'><TD COLSPAN='6'>���Ȃ��̐H�����ɂ��Ă��f�����܂�</TD></TR>
<%For i = 0 To UBound(aryQuestion)
	'�w�b�_�[�ݒ�
	Select case i + 1
		Case 11
%>
			<TR CLASS='head'><TD COLSPAN='6'>���ɁA�^���ɂ��Ă��f�����܂�</TD></TR>
<%
		Case 13
%>
			<TR CLASS='head'><TD COLSPAN='6'>�Q�łP�j�͂��A�Ɠ������l�͈ȉ��̎���ɂ��������������@<A HREF="#Next" CLASS="headA">�Q�j�������A�Ɠ��������͂������N���b�N���ĉ^���ɂ��Ă̐ݖ�S�ɐi��ł�������</A></TD></TR>
<%
	End Select
	
	'���W�I�{�^���E�s�d�w�s���͍���MAX���ݒ�
	intMaxLoopCount = 0
	Select case i + 1
		Case 1,2,3,4,5,6,7,8,9,10,16
			intMaxLoopCount = 3
		Case 11,12,13,14
			intMaxLoopCount = 2
		Case Else
			intMaxLoopCount = 5
	End Select

	Select case i + 1
		Case 1,2,3,4,5,6,7,8,9,10,12,16	'���W�I�{�^������
%>
			<TR CLASS='question'>
				<TD COLSPAN='5'><%=aryQuestion(i)%></TD>
				<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A7_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������"></A></TD>
			</TR>
			<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					strCheck = ""
					If not isEmpty(Session("Q7-" & i + 1 )) And not isNull(Session("Q7-" & i + 1 )) Then
						If CInt(Session("Q7-" & i + 1 )) = j + 1 Then
							strCheck = "CHECKED"
						End If
					End If
%>
					<TD NOWRAP><INPUT TYPE='radio' NAME='<%="A7_" & i + 1%>' VALUE='<%=j + 1%>' <%=strCheck%>></TD>
					<TD WIDTH='180' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
				Next
%>
			</TR>
<%
		Case 11 '�^���o�����͗�
%>
				<TR CLASS='question'><TD COLSPAN='6'><%=aryQuestion(i)%></TD></TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'�^�����
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-1")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-1")
					End If
%>
					<TD COLSPAN='2' NOWRAP><%=aryAnswer(i,j)%>&nbsp;&nbsp;<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_1" %>' MAXLENGTH='32' VALUE='<%=strValue%>' SIZE='32' ></TD>
<%
				Next
%>
				</TR>
				<TR>

<%
				For j = 0 To intMaxLoopCount - 1
					'����(From)
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-2")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-2")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_2" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >�΂���
<%
					'����(To)
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-3")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-3")
					End If
%>
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_3" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >��
					</TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'�p�x
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-4")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-4")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;�p�x&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_4" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >��^��
					</TD>
<%
				Next
%>
				</TR>
				<TR>

<%
				For j = 0 To intMaxLoopCount - 1
					'�^������
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-5")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-5")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;�^������&nbsp;&nbsp;
						<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_5" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >���^��
					</TD>
<%
				Next
%>
				</TR>
<%
		Case 13 '����I�ɍs�Ȃ��Ă���^�����͗�
%>
				<TR CLASS='question'><TD COLSPAN='6'><%=aryQuestion(i)%></TD></TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'�^�����
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-1")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-1")
					End If
%>
					<TD COLSPAN='2' NOWRAP><%=aryAnswer(i,j)%>&nbsp;&nbsp;<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_1" %>' MAXLENGTH='32' VALUE='<%=strValue%>' SIZE='32' ></TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'�p�x
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-2")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-2")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;�p�x&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_2" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >��^��
					</TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'�^������
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-3")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-3")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;�^������&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_3" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >���^��
					</TD>
<%
				Next
%>
				</TR>
<%
		Case 14 '���s
%>
				<TR CLASS='question'><TD COLSPAN='6'><A NAME="Next"> <%=aryQuestion(i)%></TD></TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'�����^�x��
%>
					<TD COLSPAN='2' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'���s
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-1")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-1")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;���s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_1" %>' MAXLENGTH='7' VALUE='<%=strValue%>' SIZE='7' ISTYLE='4' >�����x
					</TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'���s����
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-2")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-2")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;���s����&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_2" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >��
					</TD>
<%
				Next
%>
				</TR>
				<TR>
<%
				For j = 0 To intMaxLoopCount - 1
					'���s����
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-3")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-3")
					End If
%>
					<TD COLSPAN='2' NOWRAP>&nbsp;&nbsp;&nbsp;&nbsp;���s����&nbsp;&nbsp;
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_3" %>' MAXLENGTH='7' VALUE='<%=strValue%>' SIZE='7' ISTYLE='4' >��
					</TD>
<%
				Next
%>
				</TR>
<%
		Case 15 '�P�T�Ԃ̊���
%>
				<TR CLASS='question'><TD COLSPAN='6'><%=aryQuestion(i)%></TD></TR>
				<TR>
					<TD COLSPAN='2' NOWRAP>&nbsp;</TD>
					<TD COLSPAN='4' NOWRAP>����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�x��</TD>
				</TR>

<%
				For j = 0 To intMaxLoopCount - 1
%>
					<TR><TD COLSPAN='2' NOWRAP><%=aryAnswer(i,j)%></TD>
<%
					'��������
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-1")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-1")
					End If
%>
					<TD COLSPAN='4' NOWRAP>
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_1" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >����&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
					'�x������
					strValue = ""
					If not isEmpty(Session("Q7-" & i + 1 & "-" & j + 1 & "-2")) Then
						strValue = Session("Q7-" & i + 1 & "-" & j + 1 & "-2")
					End If
%>
					<INPUT TYPE='text' NAME='<%="A7_" & i + 1 & "_" & j + 1 & "_2" %>' MAXLENGTH='4' VALUE='<%=strValue%>' SIZE='4' ISTYLE='4' >����
					</TD>
					</TR>
<%
				Next

		Case 17 '���R���͗�
			strValue = ""
			If not isEmpty(Session("Q7-" & i + 1 )) Then
				strValue = Session("Q7-" & i + 1 )
			End If
%>
			<TR CLASS='question'><TD COLSPAN='6'><%=aryQuestion(i)%></TD></TR>
			<TR><TD COLSPAN='6'><INPUT TYPE='textarea' NAME='<%="A7_" & i + 1 %>' MAXLENGTH='256' VALUE='<%=strValue%>' SIZE='172' ></TD></TR>
<%
	End Select
Next
%>
</TABLE>
</TD></TR></TABLE><BR><BR>
<INPUT TYPE="hidden" NAME="ModeItem7"   VALUE="">
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
