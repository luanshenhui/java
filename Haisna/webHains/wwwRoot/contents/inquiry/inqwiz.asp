<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �l���� (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditPersonList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GETCOUNT = 20	'�\�������̃f�t�H���g�l

Dim objCommon		'���ʃN���X
Dim objConsult		'��f���A�N�Z�X�p

Dim strKey			'�����L�[
Dim lngStartPos		'�����J�n�ʒu
Dim lngGetCount		'�\������

Dim strToken		'�g�[�N��
Dim strPerId		'�lID

Dim i				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

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
<!--
td.inqtab  { background-color:#FFFFFF }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̃K�C�h�Ăяo��
function callOrgGuide() {

	orgGuide_showGuideOrg( document.kensakulist.orgCd1, document.kensakulist.orgCd2, 'orgName' );

}

// �c�̂̍폜
function clearOrgInfo() {

	orgGuide_clearOrgInfo( document.kensakulist.orgCd1, document.kensakulist.orgCd2, 'orgName' );

}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="JavaScript:document.kensakulist.key.focus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="kensakulist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="inquiry">��</SPAN><FONT COLOR="#000000">�l�̌���</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>��������</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'����ID���ڎw�莞�̏���
	Do
		'�������������݂��Ȃ��ꍇ�͉������Ȃ�
		If strKey = "" Then
			Exit Do
		End If

		'����ID�̌����ƈ�v���Ȃ��ꍇ�͉������Ȃ�
		If Len(strKey) <> LENGTH_RECEIPT_DAYID Then
			Exit Do
		End If

		'�S�����ׂĂ����p���������`�F�b�N
		For i = 1 To Len(strKey)

			'���p�����ȊO�̕��������ꂽ��`�F�b�N�𒆎~����
			strToken = Asc(Mid(strKey, i, 1))
			If strToken < Asc("0") Or strToken > Asc("9") Then
				Exit Do
			End If

		Next

		'��f�����V�X�e�����t�Ƃ��Ďw�蓖��ID�̗\��ԍ����擾����
		If objConsult.SelectConsultFromReceipt(Date(), 0, strKey, , , strPerId) = False Then
%>
			�w�肳�ꂽ����ID�̎�f���͑��݂��܂���B<BR>
<%
			Response.End
		End If

		'���f���Q�Ɖ�ʂ�
		Response.Redirect "inqMain.asp?perid=" & strPerId
		Response.End

		Exit Do
	Loop

	'�l�ꗗ�̕ҏW
	Call EditPersonList(strKey, lngStartPos, lngGetCount, "inqMain.asp?perid=")
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
