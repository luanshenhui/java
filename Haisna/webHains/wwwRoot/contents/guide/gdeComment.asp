<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���ʃR�����g�K�C�h (Ver0.0.1)
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
Dim strEntryOk	'���͊����t���O

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
strEntryOk = Request("entryOk")

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ʃR�����g�ꗗ�̕ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditCmtList()

	Dim objRslCmt		'���ʃR�����g�A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim strRslCmtCd		'���ʃR�����g�R�[�h
	Dim strRslCmtName	'���ʃR�����g��
	Dim strArrEntryOk	'���͊����t���O

	Dim lngCount		'���R�[�h����

	Dim strBgColor		'�w�i�F
	Dim i				'�C���f�b�N�X
	Dim j				'�C���f�b�N�X

	'���ʃR�����g�̃��R�[�h���擾
	Set objRslCmt = Server.CreateObject("HainsRslCmt.RslCmt")
	lngCount = objRslCmt.SelectRslCmtList(strRslCmtCd, strRslCmtName, strArrEntryOk)
	Set objRslCmt = Nothing

	strBgColor = "ffffff"

	'���ʃR�����g�̕ҏW�J�n
	j = 0
	For i = 0 To lngCount - 1

		If strEntryOk = "" Or strArrEntryOk(i) = strEntryOk Then
%>
			<TR BGCOLOR="#<%= strBgColor %>">
				<TD><INPUT TYPE="hidden" NAME="rslcmtcd" VALUE="<%= strRslCmtCd(i) %>"><%= strRslCmtCd(i) %></TD>
				<TD><INPUT TYPE="hidden" NAME="rslcmtname" VALUE="<%= strRslCmtName(i) %>"><A HREF="javascript:selectList(<%= CStr(j) %>)" CLASS="guideItem"><%= strRslCmtName(i) %></A></TD>
			</TR>
<%
			j = j + 1

			'���s�̔w�i�F��ݒ�
			strBgColor = IIf(strBgColor = "ffffff", "eeeeee", "ffffff")

		End If

	Next

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>���ʃR�����g�K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ���ʃR�����g�R�[�h�E���ʃR�����g���̃Z�b�g
function selectList( index ) {

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A���ʃR�����g�R�[�h�E���ʃR�����g����ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

	// ���ʃR�����g�R�[�h
	if ( opener.cmtGuide_RslCmtCd != null ) {
		if ( document.entryform.rslcmtcd.length != null ) {
			opener.cmtGuide_RslCmtCd = document.entryform.rslcmtcd[ index ].value;
		} else {
			opener.cmtGuide_RslCmtCd = document.entryform.rslcmtcd.value;
		}
	}

	// ���ʃR�����g��
	if ( opener.cmtGuide_RslCmtName != null ) {
		if ( document.entryform.rslcmtname.length != null ) {
			opener.cmtGuide_RslCmtName = document.entryform.rslcmtname[ index ].value;
		} else {
			opener.cmtGuide_RslCmtName = document.entryform.rslcmtname.value;
		}
	}

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.cmtGuide_CalledFunction != null ) {
		opener.cmtGuide_CalledFunction();
	}

	opener.winGuideCmt = null;
	close();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 10px 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<P>���ʃR�����g��I�����Ă��������B</P>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="100%">
		<TR BGCOLOR="#cccccc" ALIGN="center">
			<TD WIDTH="50">�R�[�h</TD>
			<TD>���ʃR�����g</TD>
		</TR>
<%
		'���ʃR�����g�ꗗ�̕ҏW
		EditCmtList
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
