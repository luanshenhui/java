<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���ڃK�C�h(�����񌟍���) (Ver0.0.1)
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
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Dim i
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
// �擪��������̐���B��������ONCLICK�C�x���g����Ăяo�����B
function controlSearchChar( searchChar ) {

	// ���C�����̌��������ێ��p�ϐ��ɃL�[�l���Z�b�g
	top.gdeSearchChar = searchChar;

	// ���X�g���̍Č����֐��Ăяo��
	top.setParamToList();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryform" ACTION="">
<!--
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1" STYLE="font-size:13px;">
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD BGCOLOR="#ffffff" NOWRAP>���O�Ō����F</TD>
<%
			For i = Asc("A") To Asc("O")
%>
				<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('<%= Chr(i) %>')" CLASS="guideItem"><%= Chr(i) %></A></B></TD>
<%
			Next
%>
		</TR>
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD BGCOLOR="#ffffff"></TD>
<%
			For i = Asc("P") To Asc("Z")
%>
				<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('<%= Chr(i) %>')" CLASS="guideItem"><%= Chr(i) %></A></B></TD>
<%
			Next
%>
			<TD BGCOLOR="#ffffff"></TD>
			<TD COLSPAN="3"><B><A HREF="javascript:controlSearchChar('*')" CLASS="guideItem">���̑�</A></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="8"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD BGCOLOR="#ffffff"></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
			<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('��')" CLASS="guideItem">��</A></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="8"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee" ALIGN="center">
			<TD BGCOLOR="#ffffff"></TD>
<%
			For i = Asc("0") To Asc("9")
%>
				<TD WIDTH="14"><B><A HREF="javascript:controlSearchChar('<%= Chr(i) %>')" CLASS="guideItem"><%= Chr(i) %></A></B></TD>
<%
			Next
%>
			<TD COLSPAN="2" BGCOLOR="#ffffff"></TD>
			<TD COLSPAN="3"><B><A HREF="javascript:controlSearchChar('')" CLASS="guideItem">���ׂ�</A></B></TD>
		</TR>
	</TABLE>
-->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ALIGN="right">
		<TR>
			<TD><A HREF="javascript:top.selectList()"><IMG SRC="/webHains/images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�I�������������ڂŊm��"></A></TD>
			<TD WIDTH="5"></TD>
			<TD><A HREF="javascript:top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
