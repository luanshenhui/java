<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �a���K�C�h (Ver0.0.1)
'       AUTHER  : Eiichi Yamamoto
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const STARTPOS = 1		'�J�n�ʒu�̃f�t�H���g�l

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objDisease			'�a���C�a�ޏ��A�N�Z�X�p
Dim objCommon			'���ʊ֐��A�N�Z�X�p

Dim strKey				'�����L�[
Dim strDisDivCd			'�a�ރR�[�h
Dim lngStartPos			'�����J�n�ʒu
Dim lngGetCount			'�\������

'�a�ޏ��
Dim strArrDisDivName	'�a�ޖ���

'�a�����
Dim strArrDisCd			'�a���R�[�h
Dim strArrDisName		'�a��
Dim strArrSearchChar	'�K�C�h�����p������
Dim strArrDisDivCd		'�a�ރR�[�h

Dim strDispDisCd		'�\���p�a���R�[�h
Dim strDispDisName		'�\���p�a��

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
Set objDisease		= Server.CreateObject("HainsDisease.Disease")
Set objCommon   	= Server.CreateObject("HainsCommon.Common")

'�����l�̎擾

strAction      	= Request("act")
strKey        	= Request("key")
strDisDivCd		= Request("disDivCd")
lngStartPos   	= Request("startPos")
lngGetCount   	= Request("getCount")

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", objCommon.SelectJudCmtStcPageMaxLine, lngGetCount))

'�a�ޏ��̎擾
Call objDisease.SelectDisDivList(strArrDisDivCd, strArrDisDivName)

'�a�����̎擾
Call objDisease.SelectDiseaseItemList(strArrDisCd, strArrDisName, strArrSearchChar )

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�a�������K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--


//-->
</SCRIPT>
</HEAD>

<BODY BGCOLOR="#FFFFFF" ONLOAD="JavaScript:window.document.searchForm.key.focus();">


<!-- �\�� -->
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD BGCOLOR="#999999" WIDTH="20%">
			<TABLE BORDER=0 CELLPADDING="2" CELLSPACING="1" WIDTH="100%">
				<TR HEIGHT="15">
					<TD BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�a���̌���</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>

<FORM NAME="searchForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<INPUT TYPE="hidden" NAME="act" SIZE="30" VALUE="search">
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
	<TR>
		<TD COLSPAN="2">������������͂��ĉ������B</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD NOWRAP>�a��</TD>
		<TD>�F</TD>
		<TD><%= EditDropDownListFromArray("disDivCd", strArrDisDivCd, strArrDisDivName , strDisDivCd, NON_SELECTED_ADD) %></TD>
	</TR>	
	<TR>
		<TD NOWRAP>��������</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.searchForm.submit();return false" CLASS="guideItem"><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></A>
	</TR>
</TABLE>
<BR><BR>
<%
	Do

		If( IsEmpty(strAction) or strAction = "" )Then
			Exit Do
		End If

		'�����L�[���󔒂ŕ�������
		strArrKey = SplitByBlank(strKey)

		'���������𖞂������R�[�h�������擾
		lngAllCount = objDisease.SelectDisListCount(strArrKey, strDisDivCd)

		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngAllCount = 0 Then
%>
			���������𖞂�������R�����g���͑��݂��܂���B<BR>
			�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
			Exit Do
		End If
%>
		<% If strKey <> "" Then %>�u<FONT COLOR="#FF6600"><B><%= strKey %></B></FONT>�v��<% End If %>�������ʂ� <FONT color="#FF6600"><B><%= lngAllCount %></B></FONT>������܂����B<BR><BR>
<%
		'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
		lngCount = objDisease.SelectDisList(strArrKey, strDisDivCd, lngStartPos, lngGetCount, strArrDisCd, strArrDisName, strArrSearchChar, strArrDisDivCd)
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1
			'�\���p����R�����g���͂̕ҏW
			strDispDisCd   = strArrDisCd(i)
			strDispDisName = strArrDisName(i)

			If strKey <> "" Then

				'�����L�[�ɍ��v���镔����<B>�^�O��t��
				For j = 0 To UBound(strArrKey)
					strDispDisCd = Replace(strDispDisCd, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispDisName = Replace(strDispDisName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next

			End If

			'�a���I������URL��ҏW
			strURL = "gdeSelectDisease.asp?act=search&disCd=" & strArrDisCd(i) & "&disDivCd=" & strArrDisDivCd(i)

%>
			<TR>
				<TD></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
				<TD NOWRAP><%= strDispDisCd %></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" BORDER="0"></TD>
				<TD WIDTH="500" NOWRAP><A HREF="<%= strURL %>"><%= strDispDisName %></A></TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		'�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?act=search&disDivCd=" & strDisDivCd & "&key=" & Server.URLEncode(strKey), lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
