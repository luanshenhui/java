<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�o�[�R�[�h��t (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objConsult		'��f���A�N�Z�X�p

'�����l
Dim strKey			'�o�[�R�[�h�l
Dim lngMode			'��ѐ惂�[�h

'��f���
Dim lngRsvNo		'�\��ԍ�
Dim strCancelFlg	'�L�����Z���t���O
Dim strCslDate		'��f��
Dim strPerId		'�l�h�c
Dim strDayId		'�����h�c

Dim strMessage		'�G���[���b�Z�[�W
Dim strURL			'�W�����v���URL
Dim lngStatus		'���
Dim Ret				'�֐��߂�l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
strKey  = Request("key")
lngMode = CLng("0" & Request("mode"))

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	lngStatus = 1

	'�o�[�R�[�h�l�����݂��Ȃ��ꍇ�͉������Ȃ�
	If strKey = "" Then
		Exit Do
	End If

	'�\��ԍ����������Ȃ�A����͖�f�[�̃o�[�R�[�h�ˁB
	If Len(Trim(strKey)) > LENGTH_CONSULT_RSVNO Then
		lngRsvNo = objConsult.GetRsvNoFromBarCode(Trim(strKey))
		If lngRsvNo < 1 Then
			lngStatus = -99
			Exit Do
		End If
	Else
		'���l�`�F�b�N
		strMessage = objCommon.CheckNumeric("�\��ԍ�", strKey, LENGTH_CONSULT_RSVNO)
		If strMessage <> "" Then
			lngStatus = -99
			Exit Do
		End If

		'�\��ԍ����擾
		lngRsvNo = CLng(strKey)

	End IF

	'�\��ԍ������Ɏ�f����ǂݍ���
	If objConsult.SelectConsult(lngRsvNo, strCancelFlg, strCslDate, strPerId, , , , , , , , , , , , , , , , , , , , , strDayId) = False Then
		lngStatus = 0
		Exit Do
	End If

	'�\����փW�����v����ȊO�̏ꍇ�A�L�����Z���҂̓W�����v�ł��Ȃ�
	If lngMode <> 0 And CLng(strCancelFlg) <> CONSULT_USED Then
		lngStatus = -1
		Exit Do
	End If

	'�i�����A������փW�����v����ꍇ�A����t�҂̓W�����v�ł��Ȃ�
	If (lngMode = 2 Or lngMode = 3) And strDayId = "" Then
		lngStatus = -2
		Exit Do
	End If

	'��ѐ�̐U�蕪��
	Select Case lngMode

		Case 0	'�\�����

			'�\�����ʂ�URL�ҏW
			strURL = "/webHains/contents/reserve/rsvMain.asp"
			strURL = strURL & "?rsvNo=" & lngRsvNo

		Case 1	'���ʓ��͂�

			'���ʓ��͉�ʂ�URL�ҏW
			strURL = "/webHains/contents/result/rslMain.asp"
			strURL = strURL & "?rsvNo="      & lngRsvNo
			strURL = strURL & "&cslYear="    & Year(strCslDate)
			strURL = strURL & "&cslMonth="   & Month(strCslDate)
			strURL = strURL & "&cslDay="     & Day(strCslDate)
			strURL = strURL & "&dayId="      & strDayId
			strURL = strURL & "&noPrevNext=" & "1"

		Case 2	'�i������

			'��f�i������ʂ�URL�ҏW
			strURL = "/webHains/contents/common/progress.asp"
			strURL = strURL & "?rsvNo="   & lngRsvNo
			strURL = strURL & "&actMode=" & "select"

		Case 3	'������͂�

			'������͉�ʂ�URL�ҏW
			strURL = "/webHains/contents/judgement/judMain.asp"
			strURL = strURL & "?cslYear="    & Year(strCslDate)
			strURL = strURL & "&cslMonth="   & Month(strCslDate)
			strURL = strURL & "&cslDay="     & Day(strCslDate)
			strURL = strURL & "&dayId="      & strDayId
			strURL = strURL & "&noPrevNext=" & "1"

		Case 4	'���ʎQ�Ƃ�

			'���ʎQ�Ɖ�ʂ�URL�ҏW
			strURL = "/webHains/contents/inquiry/inqMain.asp"
			strURL = strURL & "?perid=" & strPerId

		Case 5	'����[�u��

			'����[�u��ʂ�URL�ҏW
			strURL = "/webHains/contents/aftercare/Jigoinfo.asp"
			strURL = strURL & "?perid=" & strPerId

	End Select

	'�e��ʂփW�����v
	Response.Redirect strURL
	Response.End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�o�[�R�[�h����̉�ʑJ��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function selectMode( val ) {

	var curDate = new Date();
	var previsit = curDate.toGMTString();

	curDate.setTime( curDate.getTime() + 7*24*60*60*1000 ); // 7����

	var expire = curDate.toGMTString();

	document.cookie = 'mode=' + val + ';expires=' + expire;

	document.entryForm.key.focus();

}

function setDefaltCookie() {

	for ( var i = 0; i < document.entryForm.mode.length; i++ ) {
		if ( document.entryForm.mode[ i ].checked ) {
			selectMode( i );
			break;
		}
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.rsvtab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setDefaltCookie();document.entryForm.key.focus();document.entryForm.key.value = ''">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONCLICK="javascript:document.entryForm.key.focus()">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�o�[�R�[�h����̉�ʑJ��</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<IMG SRC="/webHains/images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left">
<IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="220" ALIGN="left">
<BR>
<!--
	<IMG SRC="/webHains/images/text.jpg" WIDTH="450" HEIGHT="50" ALT="">
-->
<%
	'�ē����b�Z�[�W�̕ҏW
	Select Case lngStatus

		Case 0
%>
			<FONT SIZE="6">��f��񂪑��݂��܂���B</FONT>
<%
		Case -1
%>
			<FONT SIZE="6">���̎�f���̓L�����Z������Ă��܂��B</FONT>
<%
		Case -2
%>
			<FONT SIZE="6">���̎�f���͎�t����Ă��܂���B</FONT>
<%
		Case -99
%>
			<FONT SIZE="6">�o�[�R�[�h�̒l������������܂���B</FONT>
<%
		Case Else
%>
			<FONT SIZE="6">�o�[�R�[�h��ǂݍ��܂��Ă��������B</FONT>
<%
	End Select
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>BarCode�F</TD>
			<TD WIDTH="100%"><INPUT TYPE="text" NAME="key" SIZE="30" style="ime-mode:disabled"></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(lngMode = 0, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>�\�����</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(lngMode = 1, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>���ʓ��͂�</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="2" <%= IIf(lngMode = 2, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>�i������</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="3" <%= IIf(lngMode = 3, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>�������</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="4" <%= IIf(lngMode = 4, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>���f���Q�Ƃ�</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="5" <%= IIf(lngMode = 5, "CHECKED", "") %> ONCLICK="javascript:selectMode(this.value)"></TD>
			<TD NOWRAP>����[�u���͂�</TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
