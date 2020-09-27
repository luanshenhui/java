<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�R�����g�̓o�^ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode 		'���[�h
Dim strArrMessage	'�G���[���b�Z�[�W

Dim objBbs 			'���[�U�[���擾�p�b�n�l�I�u�W�F�N�g
Dim objHainsUser 	'���[�U�[���擾�p�b�n�l�I�u�W�F�N�g

Dim strUserId		'���[�U�[ID
Dim strUserName		'���[�U�[��

Dim strStrYear		'�\���J�n���t(�N)
Dim strStrMonth		'�\���J�n���t(��)
Dim strStrDay		'�\���J�n���t(��)
Dim strEndYear		'�\���I�����t(�N)
Dim strEndMonth		'�\���I�����t(��)
Dim strEndDay		'�\�����t(��)
Dim strTitle		'�^�C�g��
Dim strHandle		'���e��
Dim strMessage		'�R�����g

Dim strStrDate		'�\���J�n���t
Dim strEndDate		'�\���I�����t

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------

'�����l�̎擾
strUserId   = Session.Contents("userid")
strMode     = Request("mode")
strStrYear	= Clng("0" & Request("stryear"))	'�\���J�n���t(�N)
strStrMonth	= Clng("0" & Request("strmonth"))	'�\���J�n���t(��)
strStrDay	= Clng("0" & Request("strday"))		'�\���J�n���t(��)
strEndYear	= Clng("0" & Request("endyear"))	'�\���I�����t(�N)
strEndMonth	= Clng("0" & Request("endmonth"))	'�\���I�����t(��)
strEndDay	= Clng("0" & Request("endday"))		'�\�����t(��)
strTitle	= Request("title")		'�^�C�g��
strHandle	= Request("handle")		'���e��
strMessage	= Request("message")	'�R�����g

Do

	'�I�u�W�F�N�g�C���X�^���X�쐬
	Set objBbs = Server.CreateObject("HainsBbs.Bbs")
	Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")

	If strMode = "insert" Then
		
		strArrMessage = objBbs.CheckValue(strStrYear, _
												strStrMonth, _
												strStrDay, _
												strEndYear, _
												strEndMonth, _
												strEndDay, _
												strHandle, _
												strTitle, _
												strMessage, _
												strStrDate, _
												strEndDate)

		If Not IsEmpty(strArrMessage) Then

			Exit Do
		End If

		 objBbs.InsertBbs strStrDate, _
								strEndDate, _
								strHandle, _
								strTitle, _
								strMessage, _
								strUserId


		Response.Redirect "/webHains/contents/common/todaysInfo.asp"

		Response.End

		Exit Do
	Else
		'���[�U���擾
		objHainsUser.SelectHainsUser strUserId, strUserName

		'�����l�Z�b�g
		strStrYear	= Year(Now)		'�\���J�n���t(�N)
		strStrMonth	= Month(Now)	'�\���J�n���t(��)
		strStrDay	= Day(Now)		'�\���J�n���t(��)
		strEndYear	= Year(Now)		'�\���I�����t(�N)
		strEndMonth	= Month(Now)	'�\���I�����t(��)
		strEndDay	= Day(Now)		'�\�����t(��)
		strTitle	= ""			'�^�C�g��
		strHandle	= strUserName	'���e��
		strMessage	= ""			'�R�����g
		
	End If
	
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
<TITLE>�R�����g�̓o�^</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
</HEAD>
<BODY BGCOLOR="#FFFFFF">

<FORM NAME="inqwiz" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>?mode=insert" METHOD="post">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�R�����g�̓o�^</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	If Not IsEmpty(strArrMessage) Then
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="85" NOWRAP>�\���J�n���t</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('stryear', 'strmonth', 'strday')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("stryear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strStrYear), False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("strmonth", 1, 12, CLng(strStrMonth), False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("strday", 1, 31, CLng(strStrDay), False) %></TD>
			<TD>��</TD>
		</TR>
		<TR>
			<TD>�\���I�����t</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endyear', 'endmonth', 'endday')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("endyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strEndYear), False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endmonth", 1, 12, CLng(strEndMonth), False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("endday", 1, 31, CLng(strEndDay), False) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="85" NOWRAP>�\��</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="title" SIZE="50" MAXLENGTH="40" VALUE="<%= strTitle %>"><TD>
		</TR>
		<TR>
			<TD>�L����</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="handle" SIZE="50" MAXLENGTH="30" VALUE="<%= strHandle %>"><TD>
		</TR>
		<TR>
			<TD VALIGN="top">�R�����g</TD>
			<TD VALIGN="top">�F</TD>
			<TD><TEXTAREA ROWS="8" COLS="100" WRAP="hard" NAME="Message" ><%= strMessage %></TEXTAREA></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="150">
		<TR>
			<TD ALIGN="left">
				<INPUT TYPE="submit" VALUE="�o�@�^">
				<INPUT TYPE="reset" VALUE="���Z�b�g">
			</TD>
		</TR>
	</TABLE>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
