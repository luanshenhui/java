<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���ڃK�C�h(�������ޑI��) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objItem			'���ڃK�C�h�A�N�Z�X�pCOM�I�u�W�F�N�g

Dim strClassCd		'�������ރR�[�h
Dim strClassName	'�������ޖ���

Dim lngCount		'���R�[�h����
Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objItem = Server.CreateObject("HainsItem.Item")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>���ڃK�C�h</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �������ޏ��̐���B�������ޖ��̂�ONCLICK�C�x���g����Ăяo�����B
function controlClassCd( classCd , className ) {

	// ���C�����̌��������ێ��p�ϐ��ɃL�[�l���Z�b�g
	top.gdeClassCd   = classCd;
	top.gdeClassName = className;

	// ���X�g���̍Č����֐��Ăяo��
	top.setParamToList();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
<%
	Do
		'�������ރe�[�u���̑S���R�[�h���擾
		lngCount = objItem.SelectItemClassList(strClassCd, strClassName)

		'�������ރe�[�u���̕ҏW
%>
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="100%">
<%
					'�u���ׂāv�s
%>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP><A HREF="javascript:function voi(){};voi()" CLASS="guideItem" ONCLICK="controlClassCd('','���ׂ�')"><B><SPAN STYLE="font-size:13px;">���ׂ�</SPAN></B></A></TD>
					</TR>
<%
					'�Y�����ڂ��Ȃ��ꍇ�\�����Ȃ�
					If lngCount = 0 Then
						Exit Do
					End If

					'��������̕\��
					For i = 0 To lngCount - 1
%>
						<TR>
							<TD BGCOLOR="#eeeeee" NOWRAP><A HREF="javascript:function voi(){};voi()" CLASS="guideItem" ONCLICK="controlClassCd('<%= strClassCd(i) %>','<%= strClassName(i) %>')"><B><SPAN STYLE="font-size:13px;"><%= strClassName(i) %></SPAN></B></A></TD>
						</TR>
<%
					Next
%>
				</TABLE>
			</TD>
		</TR>
<%
		Exit Do
	Loop
%>
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
</TABLE>
</BODY>
</HTML>
