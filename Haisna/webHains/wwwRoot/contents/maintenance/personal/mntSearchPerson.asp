<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �l���� (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditPersonList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GETCOUNT = 20	'�\�������̃f�t�H���g�l

Dim objCommon		'���ʃN���X

Dim strKey			'�����L�[
Dim lngStartPos		'�����J�n�ʒu
Dim lngGetCount		'�\������

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
strKey      = Request("key")
lngStartPos = CLng("0" & Request("startpos"))
lngGetCount = CLng("0" & Request("getcount"))

'## 2003.11.21 Add by T.Takagi@FSIT ���������͂�߂�
'�����L�[���̔��p�J�i��S�p�J�i�ɕϊ�����
strKey = objCommon.StrConvKanaWide(strKey)

'�����L�[���̏�������啶���ɕϊ�����
strKey = UCase(strKey)

'�S�p�󔒂𔼊p�󔒂ɒu������
strKey = Replace(Trim(strKey), "�@", " ")

'2�o�C�g�ȏ�̔��p�󔒕��������݂��Ȃ��Ȃ�܂Œu�����J��Ԃ�
Do Until InStr(1, strKey, "  ") = 0
    strKey = Replace(strKey, "  ", " ")
Loop
'## 2003.11.21 Add End

'�����J�n�ʒu���w�莞�͐擪���猟������
If lngStartPos = 0 Then
	lngStartPos = 1
End If

'�\���������w�莞�̓f�t�H���g�l��K�p����
If lngGetCount = 0 Then
	lngGetCount = GETCOUNT
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l�̌���</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY ONLOAD="JavaScript:document.kensakulist.key.focus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�l�̌���</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD COLSPAN="3">������������͂��ĉ������B</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
						<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.kensakulist.submit();return false"><IMG SRC="/webHains/images/findrsv.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
					</TR>
				</TABLE>
			</TD>
			
            <% If Session("PAGEGRANT") = "4" Then %>
                <TD ALIGN="right" VALIGN="top"><A HREF="mntPersonal.asp?mode=insert"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�K�Ɍl�f�[�^�̓o�^���s���܂�"></A> </TD>
            <% End IF %>

		</TR>
	</TABLE>
<%
	'�l�ꗗ�̕ҏW
	Call EditPersonList(strKey, lngStartPos, lngGetCount, "mntPersonal.asp?mode=update&perid=")
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>