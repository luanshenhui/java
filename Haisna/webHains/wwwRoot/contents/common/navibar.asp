<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�i�r�Q�[�V�����o�[ (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode	'�I���^�u���[�h

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strMode = Request("mode")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�i�r�Q�[�V�����o�[</TITLE>
<%
	'���[�h�̕ύX�i�^�u��I����Ԃɂ���j
	Select Case strMode
		Case "rsv"	'�\��^�u
			Response.Write "<STYLE TYPE=""text/css""><!-- td.rsvtab  { background-color:#FFFFFF } --> </STYLE>"
		Case "rsl"	'���ʃ^�u
			Response.Write "<STYLE TYPE=""text/css""><!-- td.rsltab  { background-color:#FFFFFF } --> </STYLE>"
		Case "jud"	'����^�u
			Response.Write "<STYLE TYPE=""text/css""><!-- td.judtab  { background-color:#FFFFFF } --> </STYLE>"
		Case "inq"	'���ʎQ�ƃ^�u
			Response.Write "<STYLE TYPE=""text/css""><!-- td.inqtab  { background-color:#FFFFFF } --> </STYLE>"
		Case "prt"	'����^�u
			Response.Write "<STYLE TYPE=""text/css""><!-- td.prttab  { background-color:#FFFFFF } --> </STYLE>"
		Case "dmd"	'�����^�u
			Response.Write "<STYLE TYPE=""text/css""><!-- td.dmdtab  { background-color:#FFFFFF } --> </STYLE>"
		Case "data"	'�f�[�^�^�u
			Response.Write "<STYLE TYPE=""text/css""><!-- td.datatab { background-color:#FFFFFF } --> </STYLE>"
		Case "mnt"	'�����e�i���X�^�u
			Response.Write "<STYLE TYPE=""text/css""><!-- td.mnttab  { background-color:#FFFFFF } --> </STYLE>"
		Case "flw"	' �t�H���[�A�b�v�^�u
			Response.Write "<STYLE TYPE=""text/css""><!-- td.flwtab  { background-color:#FFFFFF } --> </STYLE>"
 		Case Else	'�w��Ȃ�
	End Select
%>
<style>
body {background-color: #eee;}
</style>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
</BODY>
</HTML>
