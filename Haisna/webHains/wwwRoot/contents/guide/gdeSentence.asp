<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���̓K�C�h (Ver0.0.1)
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
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objSentence	'���͏��A�N�Z�X�p

'�p�����[�^
Dim strItemCd			'�������ڃR�[�h
Dim lngItemType			'���ڃ^�C�v
Dim strStcClassCd		'���͕��ރR�[�h

'���͕���
Dim strArrStcClassCd	'���͕��ރR�[�h
Dim strArrStcClassName	'���͕��ޖ�

'����
Dim strStcCd			'���̓R�[�h
Dim strShortStc			'������
Dim lngCount			'���R�[�h����

Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objSentence = Server.CreateObject("HainsSentence.Sentence")

'�p�����[�^�l�̎擾
strItemCd     = Request("itemCd")
lngItemType   = CLng("0" & Request("itemType"))
strStcClassCd = Request("stcClassCd")

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �悭�g�����ڂ̕ҏW
'
' �����@�@ : (In)     strItemCd    �������ڃR�[�h
' �@�@�@�@ : (In)     lngItemType  ���ڃ^�C�v
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub FavoriteStcList(strItemCd, lngItemType)

	Dim objSentence	'���̓A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim strStcCd		'���̓R�[�h
	Dim strShortStc		'������

	Dim lngCount		'���R�[�h����

	Dim strHTML			'HTML������
	Dim strDispStcCd	'�ҏW�p�̕��̓R�[�h
	Dim strDispShortStc	'�ҏW�p�̗�����
	Dim i				'�C���f�b�N�X

	'�������ڃR�[�h���w�肳��ĂȂ��ꍇ�͉������Ȃ�
	If IsEmpty(strItemCd) Then
		Exit Sub
	End If

	Do
		'�w�茟�����ڃR�[�h�A���ڃ^�C�v�̃��R�[�h���擾
		Set objSentence = Server.CreateObject("HainsSentence.Sentence")
		lngCount = objSentence.SelectRecentSentenceList(strItemCd, lngItemType, strStcCd, strShortStc)

		'�f�[�^�����݂��Ȃ��ꍇ�͉������Ȃ�
		If lngCount = 0 Then
			Exit Do
		End If

%>
		<BR><BR>�悭�g������<BR>
		<UL>
<%

		'���͂̕ҏW�J�n
		For i = 0 To lngCount - 1

			'���͂̎擾
			strDispStcCd   = strStcCd(i)
			strDispShortStc = strShortStc(i)

			'���͂̕ҏW
%>
			<LI>
				<INPUT TYPE="hidden" NAME="stccd2" VALUE="<%= strStcCd(i) %>">
				<INPUT TYPE="hidden" NAME="shortstc2" VALUE="<%= strShortStc(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(2, <%= CStr(i) %>)" CLASS="guideItem"><%= strDispShortStc %></A>
<%
		Next

%>
		</UL>
<%

		Exit Do
	Loop

	Set objSentence = Nothing

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���̓K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ���̓R�[�h�E�����͂̃Z�b�g
function selectList( mode, index ) {

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A���̓R�[�h�E�����͂�ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

	// ���̓R�[�h
	if ( opener.stcGuide_StcCd != null ) {
		if ( mode == 1 ) {
			if ( document.stcList.stccd1.length != null ) {
				opener.stcGuide_StcCd = document.stcList.stccd1[ index ].value;
			} else {
				opener.stcGuide_StcCd = document.stcList.stccd1.value;
			}
		} else {
			if ( document.stcList.stccd2.length != null ) {
				opener.stcGuide_StcCd = document.stcList.stccd2[ index ].value;
			} else {
				opener.stcGuide_StcCd = document.stcList.stccd2.value;
			}
		}
	}

	// ������
	if ( opener.stcGuide_ShortStc != null ) {
		if ( mode == 1 ) {
			if ( document.stcList.shortstc1.length != null ) {
				opener.stcGuide_ShortStc = document.stcList.shortstc1[ index ].value;
			} else {
				opener.stcGuide_ShortStc = document.stcList.shortstc1.value;
			}
		} else {
			if ( document.stcList.shortstc2.length != null ) {
				opener.stcGuide_ShortStc = document.stcList.shortstc2[ index ].value;
			} else {
				opener.stcGuide_ShortStc = document.stcList.shortstc2.value;
			}
		}
	}

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.stcGuide_CalledFunction != null ) {
		opener.stcGuide_CalledFunction();
	}

	opener.winGuideStc = null;
	close();

	return false;
}
//-->
</SCRIPT>
<style>
body { margin: 8px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="itemCd"   VALUE="<%= strItemCd   %>">
	<INPUT TYPE="hidden" NAME="itemType" VALUE="<%= lngItemType %>">
	���͂�I�����Ă��������B<BR><BR>
<%
	'���͕��ވꗗ�̕ҏW
	objSentence.SelectStcClassList strItemCd, lngItemType, strArrStcClassCd, strArrStcClassName
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD NOWRAP>���͕��ށF</TD>
			<TD><%= EditDropDownListFromArray("stcClassCd", strArrStcClassCd, strArrStcClassName, strStcClassCd, NON_SELECTED_ADD) %></TD>
			<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="���͗p�������ڃZ�b�g��ύX���ĕ\��"></TD>
		</TR>
	</TABLE>
</FORM>
<FORM NAME="stcList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<%
	'�悭�g�����ڂ̕ҏW
	FavoriteStcList strItemCd, lngItemType
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD NOWRAP>�R�[�h</TD>
			<TD NOWRAP>���͖�</TD>
		</TR>
<%
		'�w�茟�����ڃR�[�h�A���ڃ^�C�v�̃��R�[�h���擾
'## 2003.12.30 Mod By K.Kagawa@FFCS		�\�����ԁA���g�p�t���O�Ή�
'		lngCount = objSentence.SelectSentenceList(strItemCd, lngItemType, strStcCd, strShortStc, , , , , , , strStcClassCd)
		lngCount = objSentence.SelectSentenceList(strItemCd, lngItemType, strStcCd, strShortStc, , , , , , , strStcClassCd, , 1)
'## 2003.12.30 Mod End

		'���͂̕ҏW�J�n
		For i = 0 To lngCount - 1
%>
			<TR BGCOLOR="<%= IIf(i Mod 2 = 0, "#ffffff", "#eeeeee") %>">
				<TD><INPUT TYPE="hidden" NAME="stccd1" VALUE="<%= strStcCd(i) %>"><%= strStcCd(i) %></TD>
				<TD><INPUT TYPE="hidden" NAME="shortstc1" VALUE="<%= strShortStc(i) %>"><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(1, <%= i %>)" CLASS="guideItem"><%= strShortStc(i) %></A></TD>
			</TR>
<%
		Next
%>
		<TR BGCOLOR="#ffffff" HEIGHT="40">
			<TD COLSPAN="2" ALIGN="right" VALIGN="bottom">
				<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
