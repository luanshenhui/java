<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�t�B�����ԍ���ޑI�� (Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Dim objFree 			'�t�B�����ԍ��Ǘ�
Dim strHtml				'html�o�͗p���[�N
Dim lngCount			'�߂�l
Dim strFreeCd  			'�ėp�R�[�h
Dim strFreeClassCd		'�ėp���ރR�[�h
Dim strFreeName			'�ėp��

'*****  2003/01/21  ADD  START  E.Yamamoto
Dim strMachineCls		'���@�敪
Dim strMachineNo		'���@�ԍ�
Dim strOldMachineCls	'���@�ԍ�
'*****  2003/01/21  ADD  END    E.Yamamoto

Dim i	  				'���[�v�J�E���g

Const FREECD = "FILM"	'�ėp�R�[�h

Set objFree = Server.CreateObject("HainsFree.Free")

'*****  2003/01/21  ADD  START  E.Yamamoto
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �t���[�R�[�h�����獆�@�敪�C���@�ԍ����擾����
'
' �����@�@ : 
'
' �߂�l�@ : �Ȃ�
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function EditFreeCd(strFreeCd)

	Dim lngStrLength
	Dim lngConstStrLength
	
	lngStrLength = len(strFreeCd)
	lngConstStrLength = len(FREECD) + 1
	
	strMachineCls = mid(strFreeCd,lngConstStrLength,1)
	lngConstStrLength = lngConstStrLength + 1
	
	strMachineNo = mid(strFreeCd,lngConstStrLength,1)

	'�O��ǂݍ��񂾍��@�敪�ƈقȂ�ꍇ�܂��́u�O�v�̏ꍇ��true�A����ȊO��false�Ƃ���B
	If( ( strOldMachineCls <> strMachineCls ) Or strMachineCls = "0" )Then
		strOldMachineCls = strMachineCls
		EditFreeCd = True
	else
		EditFreeCd = false
	End If
 	
End Function
'*****  2003/01/21  ADD  END    E.Yamamoto

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�t�B�����ԍ���ޑI��</TITLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<BASEFONT SIZE="2">
<BLOCKQUOTE>
<FORM NAME="entryForm" ACTION="/webHains/contents/FilmNo/FilmNo.asp" METHOD="get">

<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�t�B�����ԍ���ޑI��</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0" WIDTH="308">
	<TR>
		<TD NOWRAP COLSPAN="5">�t�B�����ԍ���ނ�I�����Ă��������B</TD>
	</TR>
<%

	'�ėp�e�[�u�����t�B������ʖ����擾
	lngCount = objFree.SelectFree( 1,FREECD,strFreeCd,strFreeName)
	strOldMachineCls = "0"

	'���W�I�{�^���̐ݒ�
	For i = 0 To lngCount - 1 
		If( EditFreeCd(strFreeCd(i)) ) Then
		
			strHtml = strHtml & "			<TR><TD NOWRAP>" 
			strHtml = strHtml & "<INPUT TYPE=""radio"" NAME=""freeCd"" VALUE=""" & strFreeCd(i) & """" 
			If( i = 0 ) then
				strHtml = strHtml & " CHECKED>"
			Else
				strHtml = strHtml & " >"
			End if

			strHtml = strHtml & strFreeName(i) & "</TD></TR>" & vbCrLf
		End If
	Next
	
	Response.Write strHtml
%>

	<TR><TD HEIGHT="10"></TD>
	</TR>
	<TR>
		<TD NOWRAP><INPUT TYPE="image" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="�t�B������ʂ�I��"></TD>
	</TR>
</TABLE>
<BR>
<BR>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>