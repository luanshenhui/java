<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\����ڍ�(�Z�b�g���������ڏ��) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objContract			'�_����A�N�Z�X�p

'�����l
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strOptCd			'�I�v�V�����R�[�h
Dim strOptBranchNo		'�I�v�V�����}��

'�������ڏ��
Dim strArrItemCd		'�������ڃR�[�h
Dim strArrSuffix		'�T�t�B�b�N�X
Dim strArrItemName		'�������ږ�
Dim strArrExplanation	'���ڐ���
Dim lngCount			'���R�[�h��

Dim strOptName			'�I�v�V������
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract = Server.CreateObject("HainsContract.Contract")

'�����l�̎擾
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = Request("optCd")
strOptBranchNo = Request("optBranchNo")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�Z�b�g���������ڏ��</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�Z�b�g���������ڏ��</FONT></B></TD>
	</TR>
</TABLE>
<%
'�_��p�^�[���I�v�V�����Ǘ����ǂݍ���
objContract.SelectCtrPtOpt strCtrPtCd, strOptCd, strOptBranchNo, strOptName
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
	<TR>
		<TD NOWRAP>�Z�b�g��</TD>
		<TD>�F</TD>
		<TD><B><%= strOptName %></B></TD>
	</TR>
</TABLE>
<%
Do
	'�w��_��p�^�[���E�I�v�V�����ɂ����錟�����ڂ̐��������擾
	lngCount = objContract.SelectCtrPtOptExplanation(strCtrPtCd, strOptCd, strOptBranchNo, strArrItemCd, strArrSuffix, strArrItemName, strArrExplanation)
	If lngCount <= 0 Then
%>
		<BR>���̃Z�b�g�ɂ�������͂���܂���B<BR>
<%
		Exit Do
	End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
<%
		For i = 0 To lngCount - 1
%>
			<TR>
<%
				If i = 0 Then
%>
					<TD NOWRAP>�������ڃR�����g</TD>
					<TD>�F</TD>
<%
				Else
%>
					<TD></TD><TD></TD>
<%
				End If
%>
				<TD><B><%= strArrItemCd(i) %>-<%= strArrSuffix(i) %>�F<%= strArrItemName(i) %></B></TD>
			</TR>
			<TR>
				<TD></TD><TD></TD>
				<TD><%= strArrExplanation(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
<%
	Exit Do
Loop
%>
<BR><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z�����܂�"></A>
</BODY>
</HTML>