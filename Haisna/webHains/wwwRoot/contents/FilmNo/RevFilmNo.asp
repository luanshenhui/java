<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�t�B�����ԍ����ԏ��C�� (Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCommon	 		'���ʃN���X
Dim objFree	 			'�ėp�e�[�u��

Dim strMode				'�������[�h

'�ėp�e�[�u��
Dim strKeyFreeCd		'�ėp�R�[�h�i�����L�[�j
Dim strFreeCd			'�ėp�R�[�h
Dim strFreeName			'�ėp����
Dim strFreeDate			'�X�V��
Dim strFreeField1		'�t�B�����ԍ�
Dim strFreeField2		'�v���t�B�b�N�X
Dim strFreeField3		'�������ڃR�[�h
Dim strFreeField4		'�T�t�B�b�N�X
Dim strFreeField5		'�ėp�t�B�[���h�T�i���g�p�j
Dim strFreeClassCd		'�ėp���ރR�[�h

Dim lngFreeCount		'�߂�l�i�ėp�e�[�u���j

Dim i	  				'���[�v�J�E���g

'*****  2003/01/21  ADD  START  E.Yamamoto
Const FREECD = "FILM"	'�ėp�R�[�h
Dim strMachineCls		'���@�敪
Dim strMachineNo		'���@�ԍ�
Dim strDispFreeName		'�ėp���i�\���p�j
Dim strArrMessage		'�G���[���b�Z�[�W
'*****  2003/01/21  ADD  END    E.Yamamoto
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon 		= Server.CreateObject("HainsCommon.Common")
Set objFree 		= Server.CreateObject("HainsFree.Free")

strMode			= Request("mode")
strKeyFreeCd	= Request("freeCd")
strFreeClassCd	= Request("freeClassCd")
strFreeName		= Request("freeName")
strFreeField1	= Request("freeField1")
strFreeField2	= Request("freeField2")
strFreeField3	= Request("freeField3")
strFreeField4	= Request("freeField4")
strFreeField5	= Request("freeField5")

strFreeDate = FormatDateTime(Now,2)

'*****  2003/01/21  ADD  START  E.Yamamoto
call EditFreeCd(strKeyFreeCd)
'*****  2003/01/21  ADD  END    E.Yamamoto

'*****  2003/01/22  ADD  START  E.Yamamoto  
'�X�V����
do
	If( strMode = "update"  ) Then
		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		lngFreeCount = objFree.UpdateFree( _
										strKeyFreeCd, _
										strFreeClassCd, _
										strFreeName, _
										strFreeDate, _
										strFreeField1, _
										strFreeField2, _
										strFreeField3, _
										strFreeField4, _
										strFreeField5 _
									 	)
		If( lngFreeCount = False ) Then
			objCommon.AppendArray vntArrMessage, "�t�B�����ԍ��̍X�V�Ɏ��s���܂����B"
		End If
	Else

		'�ėp�e�[�u�����t�B������ʖ����擾
		If( strKeyFreeCd <> "" ) Then
			lngFreeCount = objFree.SelectFree( _
											0, _
											strKeyFreeCd, _
											strFreeCd, _
											strFreeName, _
											strFreeDate, _
											strFreeField1, _
											strFreeField2, _
											strFreeField3, _
											strFreeField4, _
											strFreeField5, _
											false, _
											strFreeClassCd _
										 	)

		'*****  2003/01/17  EDIT  START  E.Yamamoto
			If( Not IsNull(strFreeField1) AND strFreeField1 <> "" ) Then
				If( Clng(strFreeField1) = 99999999 ) Then
					strFreeField1 = "1"
				End If
			End If
		'*****  2003/01/17  EDIT  END  E.Yamamoto

		End If
	
	End If

	
	exit Do
Loop


'*****  2003/01/21  ADD  START  E.Yamamoto
If( strMachineCls <> 0 ) then
	strDispFreeName = strFreeName & "�i" & strMachineNo & "���@)"
Else
	strDispFreeName = strFreeName
End If
'*****  2003/01/21  ADD  END    E.Yamamoto

'*****  2003/01/21  ADD  START  E.Yamamoto
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �t���[�R�[�h�����獆�@�敪�C���@�ԍ����擾����
'
' �����@�@ : 
'
' �߂�l�@ : �Ȃ�
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function EditFreeCd(strFreeCd)

	Dim lngStrLength
	Dim lngConstStrLength
	
	lngStrLength = len(strFreeCd)
	lngConstStrLength = len(FREECD) + 1
	
	strMachineCls = mid(strFreeCd,lngConstStrLength,1)
	lngConstStrLength = lngConstStrLength + 1
	
	strMachineNo = mid(strFreeCd,lngConstStrLength,1)
 	
End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �c�̏��e�l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()


	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��
	Dim strMessage		'�G���[���b�Z�[�W
	Dim i				'�C���f�b�N�X

	'�e�l�`�F�b�N����
	With objCommon
	
		'�J�i��
		If( strFreeField1 <> "" ) Then
			If( Not IsNumeric(strFreeField1) ) Then
				.AppendArray vntArrMessage, "�t�B�����ԍ��ɐ��l�ȊO�̕������܂܂�Ă��܂��B"
			End If
		End If

	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'*****  2003/01/21  ADD  END    E.Yamamoto
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

function updateSubmit(){

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	objForm.mode.value = 'update';
	objForm.submit();

}

//-->
</SCRIPT>

<TITLE>�t�B�����ԍ��C��</TITLE>
</HEAD>

<BODY ONLOAD="document.entryForm.freeField1.focus()">


<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<BASEFONT SIZE="2">
<BLOCKQUOTE>
<FORM NAME="entryForm" ACTION="" METHOD="get">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�t�B�����ԍ����ԏ��C��</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<INPUT TYPE="hidden" NAME="mode"  VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="freeCd" VALUE="<%= strKeyFreeCd %>">
<INPUT TYPE="hidden" NAME="freeClassCd" VALUE="<%= strFreeClassCd %>">
<INPUT TYPE="hidden" NAME="freeName" VALUE="<%= strFreeName %>">
<INPUT TYPE="hidden" NAME="freeField3" VALUE="<%= strFreeField3 %>">
<INPUT TYPE="hidden" NAME="freeField4" VALUE="<%= strFreeField4 %>">
<INPUT TYPE="hidden" NAME="freeField5" VALUE="<%= strFreeField5 %>">
<%
	'���b�Z�[�W�̕ҏW
	If( strMode = "update" )Then

		'�ۑ��������́u�ۑ������v�̒ʒm
		If( IsEmpty(strArrMessage) ) Then
			Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If
%>
		<BR>
<%
	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD NOWRAP>�C���t�B�����ԍ����</TD>
		<TD>�F</TD>
		<TD><B><%= strDispFreeName %></B></TD>
	</TR>
	<TR><TD HEIGHT="10"></TD>
	</TR>
	<TR>
		<TD NOWRAP>�t�B�����ԍ��擪������</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="text" NAME="freeField2" SIZE="8" MAXLENGTH="2" VALUE="<%= strFreeField2 %>"></TD>
	</TR>
		<TD NOWRAP>���݂̃t�B�����ԍ�</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="text" NAME="freeField1" SIZE="10" MAXLENGTH="8" VALUE="<%= strFreeField1 %>"></TD>
		<TD></TD>
	</TR>
	</TR>
		<TD></TD>
		<TD></TD>
		<TD><FONT COLOR="#666666">�����̎�f�҂́A�����Ŏw�肳�ꂽ�ԍ��{�P���甭�Ԃ���܂��B</FONT></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
<TR>
<TD><A HREF="FilmNo.asp?freeCd=<%= strKeyFreeCd %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�o�[�R�[�h���͉�ʂɖ߂�܂�"></A></TD>
<TD WIDTH="7"></TD>
<TD><A HREF="javascript:updateSubmit()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�t�B�����ԍ��̍X�V"></A></TD>
</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
