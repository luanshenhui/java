<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����^���w���X�@���Ȃ��̊�{���`�F�b�N��ʕ\������(Ver0.0.1)
'		AUTHER  : S.Sugie@C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhCommon.inc"-->
<!--#INCLUDE VIRTUAL="/webhains/includes/mental/mhConsulItem1.inc"-->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objMentalHealth '�����^���w���X���A�N�Z�X�p

Dim i
Dim j
Dim strCheck
Dim strValue
Dim strTarget		'�J�ڐ�
Dim intTagDiv		'input type �敪
Dim intRadioCount	'�I���\���W�I�{�^����
Dim arrQuestion()	'�S���⍀�ږ�
Dim arrAnswer()		'�S��

'�󂯎��p�����[�^
Dim lngRsvNo	'�\��ԍ�
Dim strMode		'�I�����ꂽ�A�N�V����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
lngRsvNo = Request("RSVNO")
strMode = CInt(Request("ModeItem1"))

'���O�C���`�F�b�N
If LoginCheck(lngRsvNo) = False Then
	Response.Redirect "mhError.asp"
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objMentalHealth = Server.CreateObject("HainsMentalHealth.MentalHealth")

Do
	Select Case strMode
		Case MH_Mode_Next
			'����ʂɑJ��
			strTarget = "mhConsulItem2.asp"
		Case MH_Mode_Result
			'�����]���ɑJ��
			Session("FromAsp") = "mhConsulItem1.asp"
			strTarget = "mhResult.asp"
		Case Else
			Exit Do
	End Select

	'�Z�b�V�����ɃZ�b�g
	Session("Refusal1") = Request("Check1")
	For i = 0 To UBound(aryQuestion)
		Session("Q1-" & i + 1) = Request("A1_" & i + 1)
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
<TITLE>���Ȃ��̊�{���`�F�b�N</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {

	var i,j;
	var chkOn;
	var myForm = document.ConsulItem1;	// ����ʂ̃t�H�[���G�������g
	
	switch (strActMode) {
		case <%=MH_Mode_Next%>:
		case <%=MH_Mode_Result%>:
			for (i=0; i<=<%=UBound(aryQuestion)%>; i++) {
				//�K�{�`�F�b�N
				switch (i + 1) {
					case 1:case 3:case 4:
						//�񓚋��ۂ���Ȃ��ꍇ�A�K�{�`�F�b�N
						if (!myForm.Check1.checked){
							//���W�I�{�^��
							chkOn = false;
							for (j=0; j<eval("myForm.A1_" + (i + 1) + ".length"); j++) {
								if (eval("myForm.A1_" + (i + 1) + "[" + j + "]" + ".checked")) {
									chkOn  = true
									break;
								}
							}
							
							if (chkOn == false) {
								alert("�ݖ� " + (i + 1) + "�ɑ΂���񓚂�I�����Ă��������B");
								return;
							}
						}
						break;
					case 2:
						//�񓚋��ۂ���Ȃ��ꍇ�A�K�{�`�F�b�N
						if (!myForm.Check1.checked){
							//�e�L�X�g���̓`�F�b�N
							if (eval("myForm.A1_" + (i + 1) + ".value") == ""){
								alert("�ݖ� " + (i + 1) + "�ɑ΂���񓚂���͂��Ă��������B");
								return;
							}
						}
					case 6:case 13:case 14:case 15:case 16:
						//�e�L�X�g�t�H�[�}�b�g�`�F�b�N
						//if (eval("myForm.A1_" + (i + 1) + ".value") != "" && ! eval("myForm.A1_" + (i + 1) + ".value.match('^[0-9]+$')") ) {
						if (eval("myForm.A1_" + (i + 1) + ".value") != "" && isNaN(Number(eval("myForm.A1_" + (i + 1) + ".value")))) {
							alert("�ݖ� " + (i + 1) + "�ɂ́A���l����͂��ĉ������B");
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
	var myForm = document.ConsulItem1;	// ����ʂ̃t�H�[���G�������g

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
<DIV CLASS='title' NOWRAP>�T�D���Ȃ��̊�{���`�F�b�N</DIV>
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
<TR CLASS='head'><TD COLSPAN='10'>���̎���ɂ�����������</TD></TR>
<%
	For i = 0 To UBound(aryQuestion)
	If i = 4 Then
%>
		<TR CLASS="head"><TD COLSPAN='10'>�d��������Ă��Ȃ����́A<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)" CLASS="headA">�������N���b�N���ćU�ɐi��ł�������</A></TD></TR>
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
		'���W�I�{�^���\��
%>
		<TR CLASS='question'>
			<TD COLSPAN='9'><%=aryQuestion(i)%></TD>
			<TD COLSPAN='1' ><A HREF="JavaScript:CheckClear('<%="A1_" & i + 1%>')"><IMG SRC=<%=MH_ImagePath & "checkclear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I������"></A></TD>
		</TR>
		<TR>
<%
		For j = 0 To intRadioCount -1
			If (j mod 5) = 0 Then
				'�P��ɂT�܂�
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
		'�e�L�X�g�\��
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
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Result%>)"><IMG SRC=<%=MH_ImagePath & "result.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�����]��"></A>
<%End If%>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Clear%>)"><IMG SRC=<%=MH_ImagePath & "clear.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�N���A"></A>
<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)"><IMG SRC=<%=MH_ImagePath & "next.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="����"></A>
</FORM>
</CENTER>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>
