<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   OCR���͌��ʊm�F�i�G���[�j  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strGrpNo			'�O���[�vNo
Dim strCsCd				'�R�[�X�R�[�h

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
lngRsvNo			= Request("rsvno")

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>OCR���͌��ʊm�F</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �\����Ԃ̕ύX
function chgSelect() {
	var myForm = document.entryForm;

	// �I�����ꂽ��Ԃ̃G���[����\��
	dispErrList( myForm.selectState.value );

	return;
}

// �G���[����\��
function dispErrList( state ) {
	var ElementId;
	var strHtml;
	var i;

	strHtml = '<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">\n';
	strHtml = strHtml + '<TR>\n';
	strHtml = strHtml + '<TD COLSPAN="2" NOWRAP WIDTH="70" BGCOLOR="#eeeeee">���</TD>\n';
	strHtml = strHtml + '<TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">���b�Z�[�W</TD>\n';
	strHtml = strHtml + '</TR>\n';
	for ( i = 0; i < parent.lngErrCount; i++ ) {
		if ( state == 0 || state == parent.varErrState[i] ) {
			strHtml = strHtml + '<TR>\n';
			switch ( parent.varErrState[i] ) {
			case 1:
				strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:function voi(){};voi()"><IMG SRC="../../images/ico_e.gif" WIDTH="16" HEIGHT="16" ALT="�G���[" BORDER="0" ONCLICK="JavaScript:jumpErrInfo(' + i + ')"></A></TD>\n';
				strHtml = strHtml + '<TD NOWRAP>�G���[</TD>\n';
				break;
			case 2:
				strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:function voi(){};voi()"><IMG SRC="../../images/ico_w.gif" WIDTH="16" HEIGHT="16" ALT="�x��" BORDER="0" ONCLICK="JavaScript:jumpErrInfo(' + i + ')"></A></TD>\n';
				strHtml = strHtml + '<TD NOWRAP>�x��</TD>\n';
				break;
			default:
				strHtml = strHtml + '<TD COLSPAN="2" NOWRAP>"&nbsp;"</TD>\n';
			}

			strHtml = strHtml + '<TD NOWRAP><A HREF="JavaScript:function voi(){};voi()" ONCLICK="JavaScript:jumpErrInfo(' + i + ')">' + parent.varErrMessage[i] + '</A></TD>\n';
		}
	}
	strHtml = strHtml + '</TABLE>\n';

	ElementId = 'OcrNyuryokuErrList';
	if( document.all ) {
		document.all(ElementId).innerHTML = strHtml;
	}else if( document.getElementById ) {
		document.getElementById(ElementId).innerHTML = strHtml;
	}

}

// �G���[���փW�����v
function jumpErrInfo( index ) {
	var		strAnchor

	if( parent.varErrNo[index] > 0 ) {
		strAnchor = "Anchor-ErrInfo" + parent.varErrNo[index];

		parent.list.document.entryForm.anchor.value = strAnchor;
		parent.list.JumpAnchor();
	}

	return;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<BODY ONLOAD="javascript:dispErrList(0)">
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<TABLE WIDTH="985" BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD NOWRAP WIDTH="20"></TD>
			<TD NOWRAP VALIGN="top" WIDTH="100">�\���F<SELECT NAME="selectState" SIZE="1" ONCHANGE="javascript:chgSelect()">
					<OPTION VALUE="1">�G���[</OPTION>
					<OPTION VALUE="2">�x��</OPTION>
					<OPTION VALUE="0" SELECTED>�S��</OPTION>
				</SELECT>
			</TD>
			<TD>
				<SPAN ID="OcrNyuryokuErrList">
				<TABLE  BORDER="0" CELLSPACING="2" CELLPADDING="0">
					<TR>
						<TD COLSPAN="2" NOWRAP WIDTH="70" BGCOLOR="#eeeeee">���</TD>
						<TD NOWRAP WIDTH="100%" BGCOLOR="#eeeeee">���b�Z�[�W</TD>
					</TR>
				</TABLE>
				</SPAN>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
