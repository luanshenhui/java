<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �������� (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim lnglineno			'�s�ԍ�
Dim strItemCd			'�������ڃR�[�h
Dim strSuffix			'�T�t�B�b�N�X
Dim lngItemType			'���ڃ^�C�v
Dim strItemName			'�������ږ���
Dim strResult			'��������

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
lnglineno			= Request("lineno")
strItemCd			= Request("itemcd")
strSuffix			= Request("suffix")
lngItemType			= Request("itemtype")
strItemName			= Request("itemname")
strResult			= Request("result")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��������</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!--
// �������͉�ʂ̊m��
function MemoOk() {
	var		myForm = document.entryForm;	// �t�H�[���G�������g

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return;
	}

	opener.setSentenceInfo( <%= lnglineno %>, myForm.Memo.value, myForm.Memo.value );
	opener.winMemo = null;
	close();

	return;
}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="" METHOD="get">
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">��������</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2" WIDTH="100%">
		<TR>
			<TD NOWRAP HEIGHT="40">�������ځF</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%=strItemName%></B></FONT></TD>
			<TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:MemoOk()"><IMG SRC="../../images/ok.gif" HEIGHT="24" WIDTH="77" ALT="���̓��e�Ŋm�肷��"></TD>
			<TD NOWRAP><A HREF="JavaScript:close()"><IMG SRC="../../images/cancel.gif" HEIGHT="24" WIDTH="77" ALT="�L�����Z������"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2" WIDTH="100%">
		<TR>
			<TD><TEXTAREA NAME="Memo" ROWS="10" COLS="40"><%= strResult %></TEXTAREA></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
