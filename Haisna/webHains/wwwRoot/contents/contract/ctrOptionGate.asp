<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�I�v�V���������̓o�^(���z�v�Z���@�̐ݒ�) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_INSERT      = "INS"	'�������[�h(�}��)
Const MODE_UPDATE      = "UPD"	'�������[�h(�X�V)
Const CALCMODE_NORMAL  = "0"	'���z�v�Z���[�h�i�����蓮�ݒ�j
Const CALCMODE_ROUNDUP = "1"	'���z�v�Z���[�h�i�������ڒP���ώZ�j

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objContract		'�_����A�N�Z�X�p

'�����l
Dim strOrgCd1		'�c�̃R�[�h1
Dim strOrgCd2		'�c�̃R�[�h2
Dim lngCtrPtCd		'�_��p�^�[���R�[�h
Dim strOptCd		'�I�v�V�����R�[�h
Dim strCalcMode		'���z�v�Z���[�h

'�_��Ǘ����
Dim strOrgName		'�c�̖�
Dim strCsCd			'�R�[�X�R�[�h
Dim strCsName		'�R�[�X��
Dim dtmStrDate		'�_��J�n��
Dim dtmEndDate		'�_��I����
Dim strTaxFraction  '�Œ[���敪

Dim strMode			'�������[�h
Dim strURL			'�W�����v���URL

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon   = Server.CreateObject("HainsCommon.Common")
Set objContract = Server.CreateObject("HainsContract.Contract")

'�����l�̎擾
strOrgCd1   = Request("orgCd1")
strOrgCd2   = Request("orgCd2")
lngCtrPtCd  = CLng("0" & Request("ctrPtCd"))
strOptCd    = Request("optCd")
strCalcMode = Request("calcMode")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'�I�v�V�����R�[�h����у��[�h���w�莞�͐��䏈���𔲂���
	If strOptCd = "" And IsEmpty(Request("next.x")) Then
		Exit Do
	End If

	'�������[�h�̐ݒ�
	strMode = IIf(strOptCd <> "", MODE_UPDATE, MODE_INSERT)

	'�I�v�V���������o�^��ʂ�
	strURL = "ctrOption.asp"
	strURL = strURL & "?orgCd1="   & strOrgCd1
	strURL = strURL & "&orgCd2="   & strOrgCd2
	strURL = strURL & "&ctrPtCd="  & lngCtrPtCd
	strURL = strURL & "&optCd="    & strOptCd
	strURL = strURL & "&mode="     & strMode
	strURL = strURL & "&calcMode=" & strCalcMode
	Response.Redirect strURL
	Response.End

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�I�v�V���������̓o�^</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= lngCtrPtCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�I�v�V���������̓o�^</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'�_��Ǘ�����ǂ݁A�c�́E�R�[�X�̖��̋y�ь_����Ԃ��擾����
	objContract.SelectCtrMng strOrgCd1, strOrgCd2, lngCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate, strTaxFraction
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>�_��c��</TD>
			<TD>�F</TD>
			<TD NOWRAP><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD NOWRAP><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>�_�����</TD>
			<TD>�F</TD>
			<TD NOWRAP><B><%= objCommon.FormatString(dtmStrDate, "yyyy�Nm��d��") %>�`<%= objCommon.FormatString(dtmEndDate, "yyyy�Nm��d��") %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">��</FONT>���z�v�Z���@���w�肵�ĉ������B<BR><BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP>���z�v�Z���@�F</TD>
			<TD><INPUT TYPE="radio" NAME="calcMode" VALUE="<%= CALCMODE_NORMAL %>" <%= IIf(strCalcMode <> CALCMODE_ROUNDUP, "CHECKED", "") %>></TD>
			<TD NOWRAP>���̃I�v�V�����ݒ��ʂŗ�����ݒ肷��B</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD><INPUT TYPE="radio" NAME="calcMode" VALUE="<%= CALCMODE_ROUNDUP %>" <%= IIf(strCalcMode = CALCMODE_ROUNDUP, "CHECKED", "") %>></TD>
			<TD NOWRAP>�������ڂ��Ƃɐݒ肳�ꂽ���z���v�シ��B�i�}��������j</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" BORDER="0" ALT="�L�����Z��"></A>
	<INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" BORDER="0" ALT="����">

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>