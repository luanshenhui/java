<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		��^�����K�C�h (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim lngJudClassCd	'���蕪�ރR�[�h

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
lngJudClassCd = CLng(Request("judClassCd") & "")

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��^�����ꗗ�̕ҏW
'
' �����@�@ : (In)     lngJudClassCd  ���蕪�ރR�[�h
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditObsList(lngJudClassCd)

	Dim objStdJud		'��^�����A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim strStdJudCd		'��^�����R�[�h
	Dim strStdJudNote	'��^��������

	Dim lngCount		'���R�[�h����

	Dim strDispStdJudCd	'�ҏW�p�̒�^�����R�[�h
	Dim strDispStdJudNote	'�ҏW�p�̒�^��������
	Dim i			'�C���f�b�N�X

	Do
		'��^�����̃��R�[�h���擾
		Set objStdJud = Server.CreateObject("HainsStdJud.StdJud")
		lngCount = objStdJud.SelectStdJudList(lngJudClassCd, strStdJudCd, strStdJudNote)

		'��^�����ꗗ�̕ҏW�J�n
		For i = 0 To lngCount - 1

			'��^�����̎擾
			strDispStdJudCd   = strStdJudCd(i)
			strDispStdJudNote = strStdJudNote(i)

			'��^�����̕ҏW
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
					<INPUT TYPE="hidden" NAME="stdjudcd" VALUE="<%= strStdJudCd(i) %>"><%= strDispStdJudCd %>
				</TD>
				<TD>
					<INPUT TYPE="hidden" NAME="stdjudnote" VALUE="<%= strStdJudNote(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= CStr(i) %>)" CLASS="guideItem"><%= strDispStdJudNote %></A>
				</TD>
			</TR>
<%
		Next

		Exit Do
	Loop

	Set objStdJud = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��^�����K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ��^�����R�[�h�E��^�������̂̃Z�b�g
function selectList( index ) {

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A��^�����R�[�h�E��^�������̂�ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

	// ��^�����R�[�h
	if ( opener.obsGuide_StdJudCd != null ) {
		if ( document.entryform.stdjudcd.length != null ) {
			opener.obsGuide_StdJudCd = document.entryform.stdjudcd[ index ].value;
		} else {
			opener.obsGuide_StdJudCd = document.entryform.stdjudcd.value;
		}
	}

	// ��^��������
	if ( opener.obsGuide_StdJudNote != null ) {
		if ( document.entryform.stdjudnote.length != null ) {
			opener.obsGuide_StdJudNote = document.entryform.stdjudnote[ index ].value;
		} else {
			opener.obsGuide_StdJudNote = document.entryform.stdjudnote.value;
		}
	}

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.obsGuide_CalledFunction != null ) {
		opener.obsGuide_CalledFunction();
	}

	opener.winGuideObs = null;
	close();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<P>��^������I�����Ă��������B</P>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD WIDTH="50">�R�[�h</TD>
			<TD>��^����</TD>
		</TR>
<%
		'��^�����ꗗ�̕ҏW
		EditObsList lngJudClassCd
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
