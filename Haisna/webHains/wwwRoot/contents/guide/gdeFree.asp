<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �ėp�K�C�h (Ver0.0.1)
'       AUTHER  : Eiichi Yamamoto K-MIX
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
Dim objCommon			'���ʊ֐��A�N�Z�X�p
Dim objFree				'�A�t�^�[�P�A�A�N�Z�X�p

Dim strArrFreeCd
Dim strArrFreeClassCd
Dim strArrFreeName
Dim strArrFreeDate
Dim strArrFreeFeild1
Dim strArrFreeFeild2
Dim strArrFreeFeild3
Dim strArrFreeFeild4
Dim strArrFreeFeild5 

Dim strKey				'�����L�[�̏W��
Dim strArrKey			'(�������)�����L�[�̏W��
Dim lngStartPos			'�J�n���R�[�h����
Dim lngGetCount			'�I�����R�[�h����

Dim lngAllCount			'�����𖞂����S���R�[�h����
Dim lngCount			'���R�[�h����
Dim strURL				'URL������
Dim i, j				'�C���f�b�N�X
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objFree		= Server.CreateObject("HainsFree.Free")

'�����l�̎擾
strKey		 	= Request("key")
lngStartPos   	= Request("startPos")
lngGetCount   	= Request("getCount")

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", 20, lngGetCount))

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ėp�K�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

//-->
</SCRIPT>
</HEAD>

<BODY BGCOLOR="#FFFFFF">


<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

<INPUT TYPE="hidden" NAME="key" VALUE="<%= strKey %>">

<!-- �\�� -->
<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD BGCOLOR="#999999" WIDTH="20%">
			<TABLE BORDER=0 CELLPADDING="2" CELLSPACING="1" WIDTH="100%">
				<TR HEIGHT="15">
					<TD BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�ėp���̌���</FONT></B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>

<%
	Do

		'���������𖞂������R�[�h�������擾
		lngAllCount = objFree.GdeSelectFreeCount( strKey )

		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngAllCount = 0 Then
%>
			���������𖞂����w�����͏��͑��݂��܂���B<BR>
			�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
			Exit Do
		End If
%>
		<% If strKey <> "" Then %>�A�u<FONT COLOR="#FF6600"><B><%= strKey %></B></FONT>�v<% End If %>�̌������ʂ� <FONT color="#FF6600"><B><%= lngAllCount %></B></FONT>������܂����B<BR><BR> 
<%
		'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
		lngCount = objFree.GdeSelectFree(strKey, lngStartPos, lngGetCount, strArrFreeCd, strArrFreeClassCd, strArrFreeName, strArrFreeDate, strArrFreeFeild1, strArrFreeFeild2, strArrFreeFeild3, strArrFreeFeild4, strArrFreeFeild5 )
%>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
<%
		For i = 0 to lngCount - 1
			'�I������URL��ҏW
			strURL = "gdeSelectFree.asp?act=search&freeCd=" & strArrFreeCd(i)

%>
			<TR>
				<TD>
					<INPUT TYPE="hidden" NAME="FreeCd"  VALUE="<%= strArrFreeCd(i) %>">
				</TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" BORDER="0"></TD>
				<TD WIDTH="500" NOWRAP><A HREF="<%= strURL %>"  CLASS="guideStc"><%= strArrFreeFeild1(i) %>�i<%= strArrFreeCd(i) %>�j</A></TD>
			</TR>
<%
		Next
%>		
		</TABLE>
<%
		'�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?key=" & Server.URLEncode(strKey), lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
