<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �ʐڕ��̓K�C�h (Ver0.0.1)
'       AUTHER  : ishihara@fsit.fujitsu.com
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
Dim objCommon			'���ʊ֐��A�N�Z�X�p
Dim objAfterCare		'�A�t�^�[�P�A�A�N�Z�X�p

Dim strKey				'�����L�[
Dim strGuidanceDiv		'�w�����e�敪
Dim lngStartPos			'�����J�n�ʒu
Dim lngGetCount			'�\������

'�ʐڕ��͏��
Dim strArrGuidanceDiv		'�w�����̓R�[�h
Dim strArrStdContactStcCd	'��^�ʐڕ��̓R�[�h
Dim strArrContactStc		'�ʐڕ���

'ini�t�@�C����`���e
Dim vntGuidanceDivCd	'�w�����e�敪
Dim vntGuidanceDiv		'�w�����e������

Dim strDispStdContactStcCd	'�ҏW�p�̎w�����e�敪
Dim strDispContactStc		'�ҏW�p�̖ʐڕ���
Dim strDispGuidanceDiv		'�ҏW�p�̎w�����e

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
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")

'�����l�̎擾
strAction      	= Request("act")
strKey         	= Request("key")
strGuidanceDiv 	= Request("guidanceDiv")
lngStartPos   	= Request("startPos")
lngGetCount   	= Request("getCount")

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", 30, lngGetCount))

'ini�t�@�C������w�����e���擾
	objAfterCare.GetGuidanceDiv  vntGuidanceDivCd , vntGuidanceDiv 

If( strGuidanceDiv <> "" ) then
	strDispGuidanceDiv = vntGuidanceDiv(Cint(strGuidanceDiv) - 1)
End if


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ʐڕ��̓K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

//-->
</SCRIPT>
</HEAD>

<BODY BGCOLOR="#FFFFFF" ONLOAD="JavaScript:window.document.kensakulist.key.focus();">


<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

<INPUT TYPE="hidden" NAME="act" VALUE="select">
<INPUT TYPE="hidden" NAME="guidanceDiv" VALUE="<%= strGuidanceDiv %>">

<!-- �\�� -->
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD BGCOLOR="#999999" WIDTH="20%">
			<TABLE BORDER=0 CELLPADDING="2" CELLSPACING="1" WIDTH="100%">
				<TR HEIGHT="15">
					<TD BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�ʐڕ����̌���</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
	<TR>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR><TD COLSPAN="2">������������͂��ĉ������B</TD></TR>
				<TR><TD HEIGHT="5"></TD></TR>
				<TR>
					<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.kensakulist.submit();return false" CLASS="guideItem"><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></A>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR><BR>
<%
	Do
		If IsEmpty(strAction) Then
			Exit Do
		End If

		'�����L�[���󔒂ŕ�������
		strArrKey = SplitByBlank(strKey)

		'���������𖞂������R�[�h�������擾
		lngAllCount = objAfterCare.SelectStdContactStcListCount( strArrKey, strGuidanceDiv )

		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngAllCount = 0 Then
%>
			���������𖞂����w�����͏��͑��݂��܂���B<BR>
			�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
			Exit Do
		End If
%>
		�u<FONT COLOR="#FF6600"><B><%= IIf(strGuidanceDiv = "", "�S�Ă̖ʐڕ���", strDispGuidanceDiv) %></B></FONT>�v
		<% If strKey <> "" Then %>�A�u<FONT COLOR="#FF6600"><B><%= strKey %></B></FONT>�v<% End If %>�̌������ʂ� <FONT color="#FF6600"><B><%= lngAllCount %></B></FONT>������܂����B<BR><BR>
<%
		'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
		lngCount = objAfterCare.SelectStdContactStc(strArrKey, strGuidanceDiv, lngStartPos, lngGetCount, strArrGuidanceDiv, strArrStdContactStcCd, strArrContactStc)
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1
			'�\���p�w�����͕��͂̕ҏW
			strDispContactStc = strArrContactStc(i)

			If strKey <> "" Then

				'�����L�[�ɍ��v���镔����<B>�^�O��t��
				For j = 0 To UBound(strArrKey)
					strDispStdContactStcCd 	= Replace(strDispContactStc, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					strDispContactStc 		= Replace(strDispContactStc, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
				Next

			End If

			'�ʐڕ��͑I������URL��ҏW
			strURL = "gdeSelectStdContactStc.asp?act=search&guidanceDiv=" & strArrGuidanceDiv(i) & "&stdContactStcCd=" & strArrStdContactStcCd(i)

%>
			<TR>
				<TD>
					<INPUT TYPE="hidden" NAME="dispGuidanceDiv"  VALUE="<%= strArrGuidanceDiv(i) %>">
					<INPUT TYPE="hidden" NAME="dispStdContactStc" VALUE="<%= strArrStdContactStcCd(i) %>">
				</TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
				<TD NOWRAP><%= strArrStdContactStcCd(i) %></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" BORDER="0"></TD>
				<TD WIDTH="500" NOWRAP><A HREF="<%= strURL %>"  CLASS="guideStc"><%= strDispContactStc %></A></TD>
				<TD WIDTH="150" NOWRAP><% If strArrGuidanceDiv(i) <> "" Then %><FONT SIZE="-1" COLOR="666666">�i<%= vntGuidanceDiv(Cint(strArrGuidanceDiv(i)) -1 ) %>�j</FONT><% End If %></TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		'�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?act=select&guidanceDiv=" & strGuidanceDiv & "&key=" & Server.URLEncode(strKey), lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
