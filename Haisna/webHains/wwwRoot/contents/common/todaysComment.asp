<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����̃R�����g (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objBbs 			'BBS�A�N�Z�X�p

Dim strMode 		'�N�����[�h
Dim strDelBbsKey	'�R�����g�폜�L�[

Dim strUserId		'���[�UID

'�����̃R�����g�p
Dim vntTitle		'�^�C�g��
Dim vntHandle		'���e�Җ�
Dim vntUpdDate		'�X�V��
Dim vntStrDate		'�\���J�n���t
Dim vntEndDate		'�\���I�����t
Dim vntMessage		'�R�����g
Dim vntBbsKey		'�L�[
Dim vntUpdUser		'�X�V���[�U�[
Dim lngMesCount		'���R�[�h��
Dim strWeekDay		'�j���p������

Dim strHtml			'HTML������
Dim i				'�C���f�b�N�X
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objBbs = Server.CreateObject("HainsBbs.Bbs")

'�����l�̎擾
strMode      = Request("mode")
strDelBbsKey = Request("bbskey")

strUserId    = Session.Contents("userid")

'�폜���[�h�ŋN�����ꂽ�Ƃ��A�폜���s��
If strMode = "delete" Then
	objBbs.DeleteBbs strDelBbsKey
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML lang="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����̗\��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function deletecheck( jumpUrl, para1, delUserId, userId ) {

	if ( delUserId != userId ) {
		alert( '���e�҂ƃ��[�U�[ID���Ⴂ�܂��B' );
	} else {
		res = confirm( '�w�胁�b�Z�[�W���폜���܂��B��낵���ł����H' );
		if ( res == true ) {
			location.replace(jumpUrl + '?' + para1); 
		}
	}

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="97%">
	<TR>
		<TD HEIGHT="8"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="3" WIDTH="20"><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1" BORDER="0"></TD>
		<TD NOWRAP VALIGN="bottom"><FONT SIZE="3">�� �� �� �R �� �� �g</FONT></TD>
		<TD NOWRAP VALIGN="bottom" ALIGN="right"><FONT FACE="Arial Narrow" SIZE="6" COLOR="silver">Today's Comment</FONT></TD>
	</TR>
	<TR>
		<TD BGCOLOR="#cccccc" COLSPAN="2"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
	</TR>
	<TR>
		
    <%  if Session("PAGEGRANT") = "4" then   %>    
        <TD HEIGHT="30" COLSPAN="2" ALIGN="right"><A HREF="/webHains/contents/common/entryComment.asp" TARGET="_parent"><IMG SRC="/webHains/images/addcoment.gif" WIDTH="120" HEIGHT="24" BORDER="0"></A></TD>
    <%  end if  %>

	</TR>
</TABLE>


<%
	'�����̃R�����g�擾
	lngMesCount = objBbs.SelectAllBbs(Date, vntBbsKey, vntStrDate, vntEndDate, vntHandle, vntTitle, vntMessage, vntUpdDate, vntUpdUser)
%>

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
	'�����̃R�����g�\��
	For i = 0 To lngMesCount - 1 

		Select Case WeekDay(vntUpdDate(i))
			Case vbSunday
				strWeekDay =  "(Sun)"
			Case vbMonday
				strWeekDay =  "(Mon)"
			Case vbTuesday
				strWeekDay =  "(Tue)"
			Case vbWednesDay
				strWeekDay =  "(Wen)"
			Case vbThursDay
				strWeekDay =  "(Thr)"
			Case vbFriDay
				strWeekDay =  "(Fri)"
			Case vbSaturDay
				strWeekDay =  "(Sat)"
		End Select

%>
	<TR>
		<TD WIDTH="20" NOWRAP></TD>
		<TD WIDTH="17" NOWRAP><FONT COLOR="#cccccc">��</FONT></TD>
		<TD NOWRAP><FONT COLOR="#777777"><B><%= vntTitle(i) %></B></FONT></TD>
		<TD ALIGN="RIGHT"><FONT COLOR="#999999"><%= vntHandle(i) %></FONT>&nbsp;<FONT SIZE="-1" COLOR="#999999"><%= DateValue(vntUpdDate(i)) %>&nbsp;<%= strWeekDay %>&nbsp;<%= TimeValue(vntUpdDate(i)) %></FONT></TD>
		<TD WIDTH="5"></TD>
		<TD NOWRAP>
			<A HREF="javascript:function voi(){};voi()" onClick="return deletecheck('/webHains/contents/common/todaysComment.asp', 'mode=delete&bbskey=<%= vntBbsKey(i) %>','<%= vntUpdUser(i) %>','<%= strUserId %>')"><IMAGE SRC="/webHains/Images/delicon.gif" ALT="���̃R�����g���폜���܂�"></A>
		</TD>
	</TR>
	<TR>
		<TD></TD>
	</TR>
	<TR>
		<TD COLSPAN="2"></TD>
		<TD COLSPAN="5"><%= Replace(vntMessage(i),Chr(13) & Chr(10),"</BR>") %></TD>
	</TR>
	<TR HEIGHT="5">
		<TD WIDTH="20"></TD>
		<TD WIDTH="17"></TD>
	</TR>		
<%
	Next
%>
</TABLE>
</BODY>
</HTML>


