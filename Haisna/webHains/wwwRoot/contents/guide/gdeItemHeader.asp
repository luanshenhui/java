<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���ڃK�C�h(�w�b�_�[��) (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const TABLEDIV_I = 1		'��������ڣ
Const TABLEDIV_G = 2		'��O���[�v�

Dim lngGroup				'�O���[�v�\���L���@0:�\�����Ȃ��A1:�\������
Dim lngItem					'�������ڕ\���L���@0:�\�����Ȃ��A1:�\������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
lngGroup = CLng(Request("group"))
lngItem  = CLng(Request("item" ))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>���ڃK�C�h</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function setDefaultTableDiv() {
<%
Do
	'�O���[�v�̂ݕ\������ꍇ
	If lngGroup = ITEM_DISP And lngItem = ITEM_NOTDISP Then
%>
		top.gdeTableDiv = <%= TABLEDIV_G %>;
<%
		Exit Do
	End If

	'�������ڂ̂ݕ\������ꍇ
	If lngGroup = ITEM_NOTDISP And lngItem = ITEM_DISP Then
%>
		top.gdeTableDiv = <%= TABLEDIV_I %>;
<%
		Exit Do
	End If

	'����ȊO�͉������Ȃ�
	Exit Do
Loop
%>
}

// �������ځ^�O���[�v���̐���B�Y��������ONCLICK�C�x���g����Ăяo�����B
function controlTableDiv( tableDiv ) {

	// ���C�����̌��������ێ��p�ϐ��ɃL�[�l���Z�b�g
	top.gdeTableDiv = tableDiv;

	// ���X�g���̍Č����֐��Ăяo��
	top.setParamToList();

	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setDefaultTableDiv()">
<FORM NAME="entryform" ACTION="">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="145" VALIGN="bottom"><SPAN STYLE="font-size:13px;">����Ō����F</SPAN></TD>
			<TD BGCOLOR="#999999">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR ALIGN="center">
<%
					'�������ڂ̕\���L��
					If lngItem = ITEM_NOTDISP Then
%>
						<TD BGCOLOR="#eeeeee" WIDTH="69" NOWRAP><B><SPAN STYLE="font-size:13px;">��������</SPAN></B></TD>
<%
					ElseIf lngItem = ITEM_DISP Then
%>
						<TD BGCOLOR="#eeeeee" WIDTH="69" NOWRAP><B><A HREF="javascript:function voi(){};voi()" CLASS="guideItem" ONCLICK="controlTableDiv(<%= TABLEDIV_I %>)"><SPAN STYLE="font-size:13px;">��������</SPAN></A></B></TD>
<%
					End If
%>
					</TR>
				</TABLE>
			</TD>
			<TD WIDTH="10"></TD>
			<TD BGCOLOR="#999999">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR ALIGN="center">
<%
					'�O���[�v�̕\���L��
					If lngGroup = ITEM_NOTDISP Then
%>
						<TD BGCOLOR="#eeeeee" WIDTH="69" NOWRAP><B><SPAN STYLE="font-size:13px;">�O���[�v</SPAN></B></TD>
<%
					ElseIf lngGroup = ITEM_DISP Then
%>
						<TD BGCOLOR="#eeeeee" WIDTH="69" NOWRAP><B><A HREF="javascript:function voi(){};voi()" CLASS="guideItem" ONCLICK="controlTableDiv(<%= TABLEDIV_G %>)"><SPAN STYLE="font-size:13px;">�O���[�v</SPAN></A></B></TD>
<%
					End If
%>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
