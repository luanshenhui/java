<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�����t���K�C�h (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
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
Dim strDoctorFlg		'�����t���O
Dim strTitle			'�K�C�h�^�C�g��
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strDoctorFlg = Request("doctorFlg")
If strDoctorFlg = DOCTORFLG_USER Then
	strTitle = "�S���Җ�"
Else
	strTitle = "�����t��"
End If
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����t���ꗗ�̕ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditDocList()

	Dim objHainsUser	'��t���A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim strDoctorCd		'��t�R�[�h
	Dim strDoctorName	'��t��

	Dim lngCount		'���R�[�h����

	Dim strDispDoctorCd	'�ҏW�p�̈�t�R�[�h
	Dim strDispDoctorName	'�ҏW�p�̈�t��
	Dim i			'�C���f�b�N�X

	Do
		'�����t�̃��R�[�h���擾
		Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
		lngCount = objHainsUser.SelectDoctorList(strDoctorFlg, strDoctorCd, strDoctorName)

		'�����t���ꗗ�̕ҏW�J�n
		For i = 0 To lngCount - 1

			'�����t���̎擾
			strDispDoctorCd   = strDoctorCd(i)
			strDispDoctorName = strDoctorName(i)

			'�����t���̕ҏW
			If (i Mod 2) = 0 Then
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
					<INPUT TYPE="hidden" NAME="doctorcd" VALUE="<%= strDoctorCd(i) %>"><%= strDispDoctorCd %>
				</TD>
				<TD>
					<INPUT TYPE="hidden" NAME="doctorname" VALUE="<%= strDoctorName(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= CStr(i) %>)" CLASS="guideItem"><%= strDispDoctorName %></A>
				</TD>
			</TR>
<%
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
<TITLE><%= strTitle %>�K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ��t�R�[�h�E��t���̃Z�b�g
function selectList( index ) {

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A��t�R�[�h�E��t����ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

	// ��t�R�[�h
	if ( document.entryform.doctorFlg.value == '<%= DOCTORFLG_USER %>' ) {
		if ( opener.usrGuide_UserCd != null ) {
			if ( document.entryform.doctorcd.length != null ) {
				opener.usrGuide_UserCd = document.entryform.doctorcd[ index ].value;
			} else {
				opener.usrGuide_UserCd = document.entryform.doctorcd.value;
			}
		}
	} else {
		if ( opener.docGuide_DoctorCd != null ) {
			if ( document.entryform.doctorcd.length != null ) {
				opener.docGuide_DoctorCd = document.entryform.doctorcd[ index ].value;
			} else {
				opener.docGuide_DoctorCd = document.entryform.doctorcd.value;
			}
		}
	}

	// ��t��
	if ( document.entryform.doctorFlg.value == '<%= DOCTORFLG_USER %>' ) {
		if ( opener.usrGuide_UserName != null ) {
			if ( document.entryform.doctorname.length != null ) {
				opener.usrGuide_UserName = document.entryform.doctorname[ index ].value;
			} else {
				opener.usrGuide_UserName = document.entryform.doctorname.value;
			}
		}
	} else {
		if ( opener.docGuide_DoctorName != null ) {
			if ( document.entryform.doctorname.length != null ) {
				opener.docGuide_DoctorName = document.entryform.doctorname[ index ].value;
			} else {
				opener.docGuide_DoctorName = document.entryform.doctorname.value;
			}
		}
	}

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( document.entryform.doctorFlg.value == '<%= DOCTORFLG_USER %>' ) {
		if ( opener.usrGuide_CalledFunction != null ) {
			opener.usrGuide_CalledFunction();
		}
	} else {
		if ( opener.docGuide_CalledFunction != null ) {
			opener.docGuide_CalledFunction();
		}
	}

	opener.winGuideDoc = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<P>�����t��I�����Ă��������B</P>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD WIDTH="50">�R�[�h</TD>
			<TD>��t��</TD>
		</TR>
		<INPUT TYPE="hidden" NAME="doctorFlg" VALUE="<%= strDoctorFlg %>">
<%
		'�����t���ꗗ�̕ҏW
		EditDocList
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
