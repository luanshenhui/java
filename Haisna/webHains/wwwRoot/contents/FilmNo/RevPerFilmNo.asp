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

'�X�V����
If( strMode = "update"  ) Then
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
End If


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

	 if( confirm('�f�[�^��ۑ����܂��B��낵���ł����H') ){
		if( Number( objForm.freeField1.value ) ){
			objForm.mode.value = 'update';
			objForm.submit();
		}else{
			alert('�t�B�����ԍ��ɐ��l�ȊO�̕������܂܂�Ă��܂��B');
			objForm.freeField1.focus();
		}
	}

}

//-->
</SCRIPT>

<TITLE>�l�t�B�����ԍ��C��</TITLE>
</HEAD>

<BODY ONLOAD="document.entryForm.freeField1.focus()">


<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<BASEFONT SIZE="2">
<BLOCKQUOTE>
<FORM NAME="entryForm" ACTION="" METHOD="get">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�l�t�B�����ԍ����ԏ��C��</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<INPUT TYPE="hidden" NAME="mode"  VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="freeCd" VALUE="<%= strKeyFreeCd %>">
<INPUT TYPE="hidden" NAME="freeClassCd" VALUE="<%= strFreeClassCd %>">
<INPUT TYPE="hidden" NAME="freeName" VALUE="<%= strFreeName %>">
<INPUT TYPE="hidden" NAME="freeField2" VALUE="<%= strFreeField2 %>">
<INPUT TYPE="hidden" NAME="freeField3" VALUE="<%= strFreeField3 %>">
<INPUT TYPE="hidden" NAME="freeField4" VALUE="<%= strFreeField4 %>">
<INPUT TYPE="hidden" NAME="freeField5" VALUE="<%= strFreeField5 %>">
<BR>
<%
	If( strMode = "update" )Then
		Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)
	End If
%>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="1159">
	<TR>
		<TD VALIGN="top" WIDTH="15"></TD>
		<TD VALIGN="top">�C���t�B�����ԍ���ށF<B><%= strFreeName %></B><BR>
		<BR>
			���݂̃t�B�����ԍ��F<INPUT TYPE="text" NAME="freeField1" SIZE="10" MAXLENGTH="8" VALUE="<%= strFreeField1 %>"></TD>
	</TR>
	<TR>
		<TD WIDTH="15"></TD>
		<TD><BR>
			<A HREF="javascript:updateSubmit()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�t�B�����ԍ��̍X�V"></A>
		</TD>
	</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
