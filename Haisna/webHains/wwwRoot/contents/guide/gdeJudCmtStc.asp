<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		����R�����g�K�C�h (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const STARTPOS = 1		'�J�n�ʒu�̃f�t�H���g�l

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objJudCmtStc		'����R�����g���A�N�Z�X�p
Dim objJudClass			'���蕪�ޏ��A�N�Z�X�p
Dim objCommon			'���ʊ֐��A�N�Z�X�p

Dim strJudClassCd		'�������蕪�ރR�[�h
Dim strJudClassName		'�������蕪�ޖ���
Dim strKey				'�����L�[
Dim lngStartPos			'�����J�n�ʒu
Dim lngGetCount			'�\������

'����R�����g���
Dim strArrJudCmtCd		'����R�����g�R�[�h
Dim strArrJudCmtStc		'����R�����g����
Dim strArrJudClassCd	'���蕪�ރR�[�h
Dim strArrJudClassName	'���蕪�ޖ���

Dim strDispJudCmtStc	'�ҏW�p�̔���R�����g����
Dim strDispJudCmtCd		'�ҏW�p�̔���R�����g�R�[�h

Dim strAction			'
Dim strArrKey			'(�������)�����L�[�̏W��
Dim lngAllCount			'�����𖞂����S���R�[�h����
Dim lngCount			'���R�[�h����
Dim strURL				'URL������
Dim i, j				'�C���f�b�N�X
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objJudCmtStc = Server.CreateObject("HainsJudCmtStc.JudCmtStc")
Set objJudClass  = Server.CreateObject("HainsJudClass.JudClass")
Set objCommon    = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
strAction     = Request("act")
strJudClassCd = Request("judClassCd")
strKey        = Request("key")
lngStartPos   = Request("startPos")
lngGetCount   = Request("getCount")

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", objCommon.SelectJudCmtStcPageMaxLine, lngGetCount))

'���蕪�ޖ��擾
If Not IsEmpty(strJudClassCd) Then
	Call objJudClass.SelectJudClass(strJudClassCd, strJudClassName)
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>����R�����g�K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ����R�����g�R�[�h�E����R�����g���͂̃Z�b�g
function selectList( index ) {

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return false;
	}

	// �e��ʂ̘A����ɑ΂��A����R�����g�R�[�h�E����R�����g���͂�ҏW(���X�g���P���̏ꍇ�ƕ����̏ꍇ�Ƃŏ�����U�蕪��)

	// ����R�����g�R�[�h
	if ( opener.jcmGuide_JudCmtCd != null ) {
		if ( document.kensakulist.judCmtCd.length != null ) {
			opener.jcmGuide_JudCmtCd = document.kensakulist.judCmtCd[ index ].value;
		} else {
			opener.cmtGuide_JudCmtCd = document.kensakulist.judCmtCd.value;
		}
	}

	// ����R�����g����
	if ( opener.jcmGuide_JudCmtStc != null ) {
		if ( document.kensakulist.judCmtStc.length != null ) {
			opener.jcmGuide_JudCmtStc = document.kensakulist.judCmtStc[ index ].value;
		} else {
			opener.jcmGuide_JudCmtStc = document.kensakulist.judCmtStc.value;
		}
	}

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.jcmGuide_CalledFunction != null ) {
		opener.jcmGuide_CalledFunction();
	}

	opener.winGuideJcm = null;
	close();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:window.document.entryForm.key.focus();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<INPUT TYPE="hidden" NAME="act" VALUE="select">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">����R�����g�̌���</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR><TD COLSPAN="2">������������͂��ĉ������B</TD></TR>
	<TR><TD HEIGHT="5"></TD></TR>
	<TR>
		<TD><%= EditJudClassList("judClassCd", strJudClassCd, "�S�Ă̔��蕪��") %></TD>
		<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false" CLASS="guideItem"><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></A>
	</TR>
</TABLE>
</FORM>
<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<%
	Do
		If IsEmpty(strAction) Then
			Exit Do
		End If

		'�����L�[���󔒂ŕ�������
		strArrKey = SplitByBlank(strKey)

		'���������𖞂������R�[�h�������擾
		lngAllCount = objJudCmtStc.SelectJudCmtStcListCount(strJudClassCd, strArrKey)

		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngAllCount = 0 Then
%>
			���������𖞂�������R�����g���͑��݂��܂���B<BR>
			�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
			Exit Do
		End If
%>
		�u<FONT COLOR="#FF6600"><B><%= IIf(strJudClassCd = "", "�S�Ă̔��蕪��", strJudClassName) %></B></FONT>�v
		<% If strKey <> "" Then %>�A�u<FONT COLOR="#FF6600"><B><%= strKey %></B></FONT>�v<% End If %>�̌������ʂ� <FONT color="#FF6600"><B><%= lngAllCount %></B></FONT>������܂����B<BR><BR>
<%
		'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
		lngCount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, strArrKey, lngStartPos, lngGetCount, strArrJudCmtCd, strArrJudCmtStc, strArrJudClassCd, strArrJudClassName)
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1

			'�\���p����R�����g���͂̕ҏW
			strDispJudCmtStc = strArrJudCmtStc(i)
			strDispJudCmtCd  = strArrJudCmtCd(i)

			If strKey <> "" Then

				'�����L�[�ɍ��v���镔����<B>�^�O��t��
				For j = 0 To UBound(strArrKey)
					strDispJudCmtStc = Replace(strDispJudCmtStc, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispJudCmtCd  = Replace(strDispJudCmtCd, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next

			End If
%>
			<TR VALIGN="top">
				<TD>
					<INPUT TYPE="hidden" NAME="judCmtCd"  VALUE="<%= strArrJudCmtCd(i) %>">
					<INPUT TYPE="hidden" NAME="judCmtStc" VALUE="<%= strArrJudCmtStc(i) %>">
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0">
				</TD>
				<TD NOWRAP><%= strDispJudCmtCd %></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
<!--
				<TD WIDTH="500" NOWRAP><A HREF="javascript:function voi(){};voi()" ONCLICK="selectList(<%= i %>)" CLASS="guideItem"><%= strDispJudCmtStc %></A></TD>
-->
				<TD WIDTH="500" NOWRAP><A HREF="gdeSelectJudCmtStc.asp?judCmtCd=<%= strArrJudCmtCd(i) %>" CLASS="guideItem"><%= strDispJudCmtStc %></A></TD>
				<TD NOWRAP>
<%
					If strArrJudClassName(i) <> "" Then
%>
						<FONT SIZE="-1" COLOR="666666">�i<%= strArrJudClassName(i) %>�j</FONT>
<%
					End If
%>
				</TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		'�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?act=select&judClassCd=" & strJudClassCd & "&key=" & Server.URLEncode(strKey), lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
