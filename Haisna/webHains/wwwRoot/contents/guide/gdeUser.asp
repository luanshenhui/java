<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���[�U���K�C�h (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'		�@�@�@�@�@�����t���K�C�h ���R�s�[���č쐬 2004.01.13 K.Fujii@ffcs
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���[�U���ꗗ�̕ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditUserList()

	Dim objHainsUser	'���[�U���A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim strUserCd		'���[�U�R�[�h
	Dim strUserName	'���[�U��
	Dim strDelFlg		'�폜�t���O

	Dim lngCount		'���R�[�h����

	Dim strDispUserCd	'�ҏW�p�̃��[�U�R�[�h
	Dim strDispUserName	'�ҏW�p�̃��[�U��
	Dim i			'�C���f�b�N�X
	Dim j			'�C���f�b�N�X

	Do
		'���[�U�̃��R�[�h���擾
		Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
		lngCount = objHainsUser.SelectUserList(strUserCd, strUserName, , , strDelFlg)

		j = 0
		'���[�U���ꗗ�̕ҏW�J�n
		For i = 0 To lngCount - 1

			Do
				If strDelFlg(i) = "1" Then
					Exit Do
				End If

				'���[�U���̎擾
				strDispUserCd   = strUserCd(i)
				strDispUserName = strUserName(i)

				'���[�U���̕ҏW
				If (j Mod 2) = 0 Then
%>
				<TR BGCOLOR="#ffffff">
<%
				Else
%>
				<TR BGCOLOR="#eeeeee">
<%
				End If
%>
					<TD>
						<INPUT TYPE="hidden" NAME="usercd" VALUE="<%= strUserCd(i) %>"><%= strDispUserCd %>
					</TD>
					<TD>
						<INPUT TYPE="hidden" NAME="username" VALUE="<%= strUserName(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= CStr(j) %>)" CLASS="guideItem"><%= strDispUserName %></A>
					</TD>
				</TR>
<%
				j = j + 1
				Exit Do
			Loop
		Next

		Exit Do
	Loop

	Set objHainsUser = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���[�U�K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ��t�R�[�h�E��t���̃Z�b�g
function selectList( index ) {

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A���[�U�R�[�h�E���[�U����ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

	if ( opener.usrGuide_UserCd != null ) {
		if ( document.entryform.usercd.length != null ) {
			opener.usrGuide_UserCd = document.entryform.usercd[ index ].value;
		} else {
			opener.usrGuide_UserCd = document.entryform.usercd.value;
		}
	}

	if ( opener.usrGuide_UserName != null ) {
		if ( document.entryform.username.length != null ) {
			opener.usrGuide_UserName = document.entryform.username[ index ].value;
		} else {
			opener.usrGuide_UserName = document.entryform.username.value;
		}
	}

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.usrGuide_CalledFunction != null ) {
		opener.usrGuide_CalledFunction();
	}

	opener.winGuideUsr = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<P>���[�U����I�����Ă��������B</P>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD WIDTH="50">�R�[�h</TD>
			<TD>���[�U��</TD>
		</TR>
<%
		'���[�U���ꗗ�̕ҏW
		EditUserList
%>
		<TR BGCOLOR="#ffffff" HEIGHT="40">
			<TD COLSPAN="2" ALIGN="RIGHT" VALIGN="BOTTOM">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
