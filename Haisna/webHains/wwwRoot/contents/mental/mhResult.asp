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

Dim lngRsvNo		'�\��ԍ�

Dim i,j,k
Dim lngLockDiv
Dim strOldLockDiv
Dim strMode			'�T�u�~�b�g���[�h
Dim strTarget		'��ʑJ�ڐ�
Dim strValue		'������p���[�N
Dim intCalcValue	'�v�Z�p���[�N
Dim intCalcValue2	'�v�Z�p���[�N�Q
Dim blnNoAnswer		'���_���N�x�p�t���O
Dim blnNoSmoke		'�i���t���O
Dim blnNoDrink		'�����t���O

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�p�����[�^�̎擾
lngRsvNo = Request("RSVNO")
strMode = cInt(Request("ModeResult"))
strOldLockDiv = Request("LockDiv")

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
			strTarget = Session("FromAsp")
			'�J�ڌ��N���A
			Session("FromAsp") = ""
		Case MH_Mode_Next
			'����ʂɑJ��
			strTarget = "mhConsulItem1.asp"
			'�J�ڌ��N���A
			Session("FromAsp") = ""
		Case MH_Mode_Comment
			'�R�����g��ʂɑJ��
			strTarget = "mhComment.asp"
		Case MH_Mode_Change
			'�N���C�A���g���b�N����
			If objMentalHealth.UpdateClientPermission(Session("RsvNo"), strOldLockDiv) = False Then
				'�G���[
				Session("ErrorMsg1") = "�N���C�A���g���b�N���̍X�V�Ɏ��s���܂���"
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

'�N���C�A���g���b�N�敪�擾
lngLockDiv = objMentalHealth.SelectClientPermission(Session("RsvNo"))
If lngLockDiv < 0 Then
	'�G���[
	Session("ErrorMsg1") = "�N���C�A���g���b�N���̎擾�Ɏ��s���܂���"
	Session("ErrorMsg2") = "�\���󂠂�܂��񂪁A�T�|�[�g�S���҂܂ł��A����������"
	Response.Redirect "mhError.asp"
End If
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>����</TITLE>
<LINK REL=STYLESHEET TYPE="text/css" HREF=<%=MH_StyleSheet%> TITLE="MentalHealth">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function MoveCheck(strActMode) {
	var myForm = document.Result;	// ����ʂ̃t�H�[���G�������g
	
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
<DIV CLASS='title' NOWRAP>�����^���w���X�h�b�N�����]��</DIV>
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
<%
If Session("LoginDiv") = 1 And lngLockDiv > 0 Then
	If lngLockDiv = 1 Then
		strValue = PC_Client_On
	Else
		strValue = PC_Client_Off
	End If
%>
	<BR>
<!-- 2002.04.18 FAS)T.I Update �N���C�A���g��񖢓��͂̏ꍇ�̂݃��b�Z�[�W��\�������� -->
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
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Change%>)" ><IMG SRC=<%=MH_ImagePath & "change.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�ύX"></A>
<%
End If
%>
<BR>

<HR ALIGN=center>

<%
'���ڂS���_���N�x�v�Z
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
<H2>�W�D��ʌ��N�����[�i���_���N�x�j</H2>
<DL><DT>
<%
Select Case True
	Case intCalcValue = 0 And blnNoAnswer = True
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 2
%>
		<DT><B>���_�I�Ɍ��N</B>
		<DD>�X�g���X�͂��܂��Ă��܂���<BR>
		���Ȃ��́A���_�I�ɑS�����N�ł��B���̒��q�ŁA��Ƃ��������������S�����܂��傤
		
<%
	Case intCalcValue < 4
%>
		<DT><B>���_�I�s���N�̉\�����ے�ł��Ȃ�</B>
		<DD>�����X�g���X�����܂肩���Ă���悤�ł�<BR>
		���Ȃ��́A������ꂪ�o�Ă���̂�������܂���B���������Ȃ��悤�ɐS�����܂��傤
		
<%
	Case Else
%>
		<DT><B>���_�I�s���N�̉\������</B>
		<DD>�X�g���X�����܂��Ă��Ă��܂�<BR>
			���Ȃ��́A��ꂪ���܂��Ă���悤�ł��B���ɂ͎d�������܂��������ċx�݂��Ƃ邱�Ƃ��l���܂��傤
		
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'���ڂT�����x�E�X�g���X�x�v�Z
%>
<H2>�X�D�����x�E�X�g���X�x</H2>
<DL>
<DT><B>�P�D�E�������x</B>
<%
If isNull(Session("Q5-1")) Or Session("Q5-1") = "" Then
%>
	<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%	
Else
	Select Case CInt(Session("Q5-1"))
		Case 0,1
%>
			<DD>�d���ɑ΂��閞���x���Ⴂ���ł��B�d���̂������H�v���������悢��������܂���
<%
		Case 2
%>
			<DD>�d���ɑ΂��閞���x�͕��ϓI�ł��B���������Ȃ��ō��̃y�[�X�ő����Ă�������
<%
		Case 3,4
%>
			<DD>�d���ɑ΂��閞�����͍������ł��B���̃y�[�X�ő����Ă�������
<%
	End Select
End If
%>
<BR>

<DT><B>�Q�D�ƒ됶�������x</B>
<%
If isNull(Session("Q5-2")) Or Session("Q5-2") = "" Then
%>
	<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%	
Else
	Select Case CInt(Session("Q5-2"))
		Case 0,1
%>
			<DD>�ƒ�ɑ΂��閞�����͒Ⴂ���ł��B�Ƒ��Ɖ߂������Ԃ𑝂₵�������悢��������܂���
<%
		Case 2
%>
			<DD>�ƒ�ɑ΂��閞�����͕��ϓI�ł�
<%
		Case 3,4
%>
			<DD>�ƒ�ɑ΂��閞���x�͍������ł�
<%
	End Select
End If
%>
<BR>

<DT><B>�R�D�E��X�g���X�x</B>
<%
If isNull(Session("Q5-3")) Or Session("Q5-3") = "" Then
%>
	<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%	
Else
	Select Case CInt(Session("Q5-3"))
		Case 0,1
%>
			<DD>�E��ł̃X�g���X���C���Ȃ肽�܂��Ă��܂��B�X�g���X�����@�ɍH�v���K�v�ł�
<%
		Case 2
%>
			<DD>�E��̃X�g���X�͑������܂��Ă��܂��B�X�g���X���������܂��傤
<%
		Case 3,4
%>
			<DD>�E��̃X�g���X�͒Ⴂ���x���ł��B���̒��q�ő����Ă�������
<%
	End Select
End If
%>
<BR>

<DT><B>�S�D�ƒ�X�g���X�x</B>
<%
If isNull(Session("Q5-4")) Or Session("Q5-4") = "" Then

%>
	<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%	
Else
	Select Case CInt(Session("Q5-4"))
		Case 0,1
%>
			<DD>�ƒ�ł̃X�g���X���C���Ȃ肽�܂��Ă��܂��B�X�g���X�����@�ɍH�v���K�v�ł�
<%
		Case 2
%>
			<DD>�ƒ�̃X�g���X�͑������܂��Ă��܂��B�X�g���X���������܂��傤
<%
		Case 3,4
%>
			<DD>�ƒ�̃X�g���X�͒Ⴂ���x���ł��B���̒��q�ő����Ă�������
<%
	End Select
End If
%>
</DL><BR>

<HR ALIGN=center>

<%
'���ڂU�i��
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
<H2>�Y�D�i���E����</H2>
<DL>
<DT><B>�i��</B>
<%
Select Case True
	Case blnNoSmoke = True
%>
		<DD>0�_<BR>
		�i��i���ҁj
<%
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 6
%>
		<DD><%=intCalcValue%>�_<BR>
		�i�����x�^�o�R�ˑ��j�����f���̃`�����X�ł��B���̋@��ɁA�g�̂��^�o�R������������āA���t���b�V�����܂��傤
<%
	Case Else
%>
		<DD><%=intCalcValue%>�_<BR>
		�i�d�x�^�o�R�ˑ��j�f���͍��������܂��񂪁C����Ă݂邾���̉��l�͏\���ɂ���܂�<BR>
		���Ȃ��Ƃ��Ȃ������Ȃ��̎���̑�؂Ȑl�����̂��߂�
<%
End Select

'���ڂU����
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
<DT><B>����</B>
<%
Select Case True
	Case blnNoDrink = True
%>
		<DD>0�_<BR>
		�i������ҁj
<%
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 11
%>
		<DD><%=intCalcValue%>�_<BR>
		�K�������ҁB���ɂV�_�ȉ��̐l�́C���Ȉ��ݕ������Ă���Ƃ����܂��傤<BR>
		���̂܂܂����Ƃ����֌W�𑱂��Ă�������
<%
	Case intCalcValue < 15
%>
		<DD><%=intCalcValue%>�_<BR>
		�������҂̉\������B����x�����g�̈����ɂ��āA�U��Ԃ��Ă݂Ă�������
<%
	Case Else
%>
		<DD><%=intCalcValue%>�_<BR>
		�������҂̉\���������B���݂̈��ݕ��ł́A�߂��������N���͂��ߗl�X�Ȉ����̖��<BR>
		���N���Ă��鋰�ꂪ����܂��B�v���ӂ��K�v�ł�
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'���ڂV�H���E�^���v�Z
'�H��
intCalcValue = 0
For i = 1 To 10
	If isNull(Session("Q7-" & i)) Or Session("Q7-" & i) = "" Then
		intCalcValue = 0
		Exit For
	End If
	intCalcValue = intCalcValue + CInt(Session("Q7-" & i))
Next
%>
<H2>�Z�D�H���E�^��</H2>
<DL>
<DT><B>�H��</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 20 And CInt(Session("BMI")) < 19
%>
		<DD>�H�����͂��܂�悭����܂���B�₹�Ă����܂��̂ŁA�H�����e�C�ʂ��������܂��傤
<%
	Case intCalcValue < 20 And CInt(Session("BMI")) < 26
%>
		<DD>�H�����͂��܂�悭����܂���B�H�������������܂��傤
<%
	Case intCalcValue < 20 And CInt(Session("BMI")) >= 26
%>
		<DD>�H�����͂��܂�悭����܂���B�얞�������܂��̂ŁC�H�����e�C�ʂ��������܂��傤
<%
	Case intCalcValue < 26 And CInt(Session("BMI")) < 19
%>
		<DD>�H���̃o�����X�͈����Ȃ��悤�ł����C�₹�Ă�����̂ŁA�H���ɂ͂����������ӂ��܂��傤
<%
	Case intCalcValue < 26 And CInt(Session("BMI")) < 26
%>
		<DD>�H���̃o�����X�͈����Ȃ��悤�ł����C���������̉��P�����҂ł��܂�
<%
	Case intCalcValue < 26 And CInt(Session("BMI")) >= 26
%>
		<DD>�H���̃o�����X�͈����Ȃ��悤�ł����C�얞�������܂��̂ŁC�H�����e�C�ʂɒ��ӂ��Ă�������
<%
	Case intCalcValue >= 26 And CInt(Session("BMI")) < 19
%>
		<DD>�H���̃o�����X�͗ǂ��悤�ł����A�₹�Ă�����̂ŁA�H�����e�Ɉ�w�̒��ӂ����܂��傤
<%
	Case intCalcValue >= 26 And CInt(Session("BMI")) < 26
%>
		<DD>�H�K���͗ǂ��悤�ł��B������ێ�����悤�ɒ��ӂ��Ă�������
<%
	Case intCalcValue >= 26 And CInt(Session("BMI")) >= 26
%>
		<DD>�H���̃o�����X�͗ǂ��悤�ł����A�얞�������܂��̂ŁA�H�׉߂��ɂ͒��ӂ��Ă�������
<%
End Select

'�^��
'�P���̕��s
intCalcValue = 0
intCalcValue2 = 0
If (not isNull(Session("Q7-14-1-1")) And Session("Q7-14-1-1") <> "") And _
	(not isNull(Session("Q7-14-2-1")) And Session("Q7-14-2-1") <> "") Then
	'���s���Ōv�Z
	intCalcValue = ((CLng(Session("Q7-14-1-1")) * 5) + (CLng(Session("Q7-14-2-1")) * 2)) / 7
	'�������ʂŎl�̌ܓ�
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
	'���s�����Ōv�Z
	intCalcValue = (CDbl(Session("Weight")) * CDbl(Session("Q7-14-1-3")) * 0.001 * 0.5 * 5) _ 
					+ (CDbl(Session("Weight")) * CDbl(Session("Q7-14-2-3")) * 0.001 * 0.5 * 2)
	'�������ʂŎl�̌ܓ�
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
	'���s���ԂŌv�Z
	intCalcValue = ((CDbl(Session("Q7-14-1-2")) * 120 * 5) + (CDbl(Session("Q7-14-2-2")) * 120 * 2)) / 7
	'�������ʂŎl�̌ܓ�
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
<DT><B>�^��</B>
<DL>
<DT><B>���ϓI�ȂP���̕��s�ɂ���</B>
<%
Select Case intCalcValue2
	Case 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case 1
%>
		<DD>�����ʂ��s�����Ă��܂�
<%
	Case 2
%>
		<DD>���s�\��
<%
	Case 3
%>
		<DD>�\���Ȋ�����
<%
End Select

'�P���̉^��
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
	'�������ʂŎl�̌ܓ�
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
<DT><B>���̂P�T�Ԃ̕��ϓI�ȂP���ɂ�����^���ɔ�₵�����Ԃɂ���</B>
<%
Select Case intCalcValue2
	Case 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case 1
%>
		<DD>�����ʂ��s�����Ă��܂�
<%
	Case 2
%>
		<DD>���s�\��
<%
	Case 3
%>
		<DD>�\���Ȋ�����
<%
End Select
%>
</DL>
</DL>

<HR ALIGN=center>

<%
'���ڂW�Љ�I�x���v�Z
intCalcValue = 0
For i = 1 To 3
	If isNull(Session("Q8-" & i & "-2")) Or Session("Q8-" & i & "-2") = "" Then
		intCalcValue = 0
		Exit For
	End If
	intCalcValue = intCalcValue + CInt(Session("Q8-" & i & "-2"))
Next
%>
<H2>�[�D�Љ�I�x��</H2>
<DL>
<!-- 2002.04.08 FAS)T.I 1Line delete
<DT><B>�Љ�I�x��</B>-->
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 7
%>
		<DD>���͂̐l�Ԋ֌W�͗ǍD�ł�
<%
	Case intCalcValue < 12
%>
		<DD>���͂Ƃ̐l�Ԋ֌W�ɏ�����肪����̂�������܂���
<%
	Case Else
%>
		<DD>���͂Ƃ̐l�Ԋ֌W�̍Č������K�v��������܂���
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'���ڂX�]�Ɍv�Z
intCalcValue = 0
For i = 1 To 38
	If not isNull(Session("Q9-2-" & i)) And Session("Q9-2-" & i) <> "" Then
		If CInt(Session("Q9-2-" & i)) = 1 Then
			intCalcValue = intCalcValue + 1
		End if
	End If
Next
%>
<H2>�\�D�]��</H2>
<DL>
<!-- 2002.04.08 FAS)T.I 1Line delete
<DT><B>�]��</B> -->
<%
Select Case True
	Case intCalcValue < 2
%>
		<DD>����L���܂��傤

<%
	Case intCalcValue < 4
%>
		<DD>�]�ɂ����܂��߂�����Ă���悤�ł�
<%
	Case Else
%>
		<DD>���ʂȎ��������Ă��܂���
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'���ڂP�O�^�C�v�`�v�Z
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
<H2>�]�D�^�C�v�`</H2>
<DL>
<!-- 2002.04.08 FAS)T.I 1Line delete
<DT><B>�^�C�v�`</B> -->
<%
Select Case True
	Case intCalcValue = 0 And intCalcValue2 = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case (intCalcValue2 + (21 - intCalcValue)) < 25
%>
		<DD>���̎d���̃y�[�X�ł悢�悤�ł�
<%
	Case (intCalcValue2 + (21 - intCalcValue)) < 28
%>
		<DD>�d���̃y�[�X���������Ƃ��������悢��������܂���
<%
	Case Else
%>
		<DD>���ɂ͎d���̎���~�߂邱�Ƃ���؂ł�
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'���ڂP�P�X�g���X�֘A�v���v�Z
'�Ɩ�����
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
<H2>XI�D�X�g���X�֌W�v��</H2>
<DL>
<DT><B>�Ɩ�����</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 24
%>
		<DD>�d���̕��S�͓K�x�ł�
<%
	Case intCalcValue < 27
%>
		<DD>�d���̕��S�����傫���悤�ł��B���������Ȃ��悤�ɐS�����܂��傤
<%
	Case Else
%>
		<DD>�d���̕��S���傫���Ȃ��Ă��܂��B���ɋx�݂����܂��傤
<%
End Select

'�l�Ԋ֌W
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
<DT><B>�l�Ԋ֌W</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 37
%>
		<DD>�E��̐l�Ԋ֌W�͗ǍD�ł�
<%
	Case intCalcValue < 43
%>
		<DD>�E��̐l�Ԋ֌W�ŏ������Ă��܂��B�C���]�������܂��傤
<%
	Case Else
%>
		<DD>�E��̐l�Ԋ֌W�ŁC���Ȃ���Ă��܂��B������l�ŔY�܂Ȃ��悤�ɂ��܂��傤
<%
End Select

'�E��Ɖƒ�̃o�����X
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
<DT><B>�E��Ɖƒ�̃o�����X</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 23
%>
		<DD>�d���Ɖƒ�̃o�����X�����Ɏ��Ă���悤�ł�
<%
	Case intCalcValue < 25
%>
		<DD>�d���Ɖƒ�̃o�����X�ɍH�v���K�v�ł�
<%
	Case Else
%>
		<DD>�d���Ɖƒ�̃o�����X�ɏ\���C�����܂��傤

<%
End Select

'�Ǘ��Ɩ�
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
<DT><B>�Ǘ��Ɩ�</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 14
%>
		<DD>�Ǘ��̎d���͂��܂������Ă��܂�
<%
	Case intCalcValue < 16
%>
		<DD>�Ǘ��̎d�����������S�ɂȂ��Ă��܂�
<%
	Case Else
%>
		<DD>�Ǘ��̎d���ɋC���g�������ł�
<%
End Select

'�ӔC��
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
<DT><B>�ӔC��</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 17
%>
		<DD>���ɖ��͂���܂���
<%
	Case intCalcValue < 19
%>
		<DD>�d���ŐӔC�𑽏����������ł�
<%
	Case Else
%>
		<DD>�d���ŐӔC���������������ł�
<%
End Select

'�X�g���X
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
<DT><B>�X�g���X</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 17
%>
		<DD>�X�g���X�͂���قǂ��܂��Ă��܂���
<%
	Case intCalcValue < 19
%>
		<DD>�X�g���X�����܂�X���ɂ���܂�
<%
	Case Else
%>
		<DD>�X�g���X�����܂肷���ł�
<%
End Select
%>
</DL>

<HR ALIGN=center>

<%
'���ڂP�Q�Ώ��s���E�Љ�I�x���v�Z
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
<H2>XII�D�Ώ��s���E�Љ�I�x��</H2>
<DL>
<DT><B>�Ώ��s��</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 26
%>
		<DD>�X�g���X�̑Ώ��͏��Ȃق��ł�
<%
	Case intCalcValue < 28
%>
		<DD>�X�g���X�̑Ώ��ɂ���肪����܂�
<%
	Case Else
%>
		<DD>�X�g���X�̑Ώ��̕��@����������K�v�����肻���ł�
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
<DT><B>�Љ�I�x��</B>
<%
Select Case True
	Case intCalcValue = 0
%>
		<DD CLASS='noAnswer'><%=PC_NoAnswer%>
<%
	Case intCalcValue < 18
%>
		<DD>���ɖ��͂���܂���
<%
	Case intCalcValue < 20
%>
		<DD>�E��̐l�Ԋ֌W���l���Ă݂܂��傤
<%
	Case Else
%>
		<DD>�E��̐l�Ԋ֌W�ɍH�v�����Ă݂܂��傤
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
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Comment%>)"><IMG SRC=<%=MH_ImagePath & "comment.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�R�����g"></A>
	<%If not isEmpty(Session("FromAsp")) And not isNull(Session("FromAsp")) And Session("FromAsp") <> "" Then%>
		<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Back%>)"><IMG SRC=<%=MH_ImagePath & "back.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
	<%End If%>
	<A HREF="JavaScript:MoveCheck(<%=MH_Mode_Next%>)"><IMG SRC=<%=MH_ImagePath & "next.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="����"></A>
<%End If%>
<A HREF="JavaScript:close()"><IMG SRC=<%=MH_ImagePath & "end.gif"%> BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I��"></A>
</CENTER>
</FORM>
<HR ALIGN=center>
<BR>
</BODY>
</HTML>
