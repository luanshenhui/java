<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���ڃK�C�h(�I���ς݌������ڕ\����) (Ver0.0.1)
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
Dim lngCount			'�I���ςݍ��ڕ\������
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
' �����l�̎擾
lngCount = CLng(Request("count"))

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���ڃK�C�h</TITLE>
</HEAD>

<BODY>

<FORM NAME="entryform" ACTION="">
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD COLSPAN="2" HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD WIDTH="5"></TD>
			<TD>�I���ς݂̍��ځF</TD>
		</TR>
		<TR>
			<TD COLSPAN="2" HEIGHT="5"></TD>
		</TR>
<%
	Do
		'�I���ςݍ��ڂ�0���̏ꍇ�����\�����Ȃ�
		If lngCount = 0 Then
			Exit Do
		End If

		'�I���ς݌������ڃe�[�u���\��
		For i = 0 To lngCount - 1
%>
		<TR>
			<TD WIDTH="5"></TD>

			<!-- �������ږ��̕ҏW -->
			<TD>
				<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
					document.write("<B>" + top.selectedList[<%= i %>][3] + "</B>");
				</SCRIPT>
			</TD>
		</TR>
<%
		Next

		Exit Do
	Loop
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
