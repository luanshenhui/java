<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����I�� (Ver0.0.1)
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
Dim strStcCd			'���̓R�[�h

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
lnglineno			= Request("lineno")
strItemCd			= Request("itemcd")
strSuffix			= Request("suffix")
lngItemType			= Request("itemtype")
strItemName			= Request("itemname")
strStcCd			= Request("stccd")
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����I��</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!--
// �����I����ʂ̊m��
function SentenceOk() {
	var		listForm = top.list.document.entryForm;	// �����I��(�{�f�B)�̃t�H�[���G�������g
	var		count;			// �����I��
	var		i;				// �C���f�b�N�X

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return;
	}

	// �I���`�F�b�N
	count = 0;
	for( i=0; i<listForm.chk.length; i++ ) {
		if( listForm.chk[i].checked ) {
			count++;
		}
	}
	if( count > opener.SameCount ) {
		alert( "���̌������ڂ̑I���\����" + opener.SameCount + "���ł�" );
		return;
	}

	// �����̃Z�b�g
	count = 0;
	for( i=0; i<listForm.chk.length; i++ ) {
		if( listForm.chk[i].checked ) {
			opener.setSentenceInfo( opener.SameLineno[count], listForm.stccd[i].value, listForm.shortstc[i].value );
			count++;
		}
	}
	for( i=count; i<opener.SameCount; i++ ) {
		opener.clearSentenceInfo( opener.SameLineno[i] );
	}
	

	opener.winSentence = null;
	close();

	return;
}
//-->
</SCRIPT>
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="90,*">
	<FRAME NAME="header" SRC="SentenceHeader.asp?itemname=<%=strItemName%>">
	<FRAME NAME="list"   SRC="SentenceBody.asp?itemcd=<%=strItemCd%>&itemtype=<%=lngItemType%>&stccd=<%=strStcCd%>">
</FRAMESET>
</HTML>