<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���(�v���r���[) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-204/238
'       �C����  �F2010.06.10
'       �S����  �FASC)�V��
'       �C�����e�FReport Designer��Co Reports�ɕύX
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/print.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strFileName		'�t�@�C����

Dim lngPos			'�����p�ϐ�
Dim strExtension	'�g���q

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
strFileName = Request("documentFileName")

lngPos = InStrRev(strFileName, ".")
If lngPos > 0 Then
	strExtension = UCase(Mid(strFileName, lngPos + 1))
End If

'cid�t�@�C���łȂ����
If strExtension <> "CID" Then


'##2004.08.27 UPD STR ORB)A.NAGUMO �g���qxls���_�E�����[�h������
	'�_�E�����[�h������
'	Response.ContentType = "application/x-download"
'	Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
'	Response.AddHeader "Content-Disposition","filename=" & strFileName
'	Server.Execute PRT_TEMPPATH & strFileName
'	Response.End

	If strExtension = "CSV" Then
		'�_�E�����[�h������
		Response.ContentType = "application/x-download"
		Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
		Response.AddHeader "Content-Disposition","filename=" & strFileName
		Server.Execute PRT_TEMPPATH & strFileName
		Response.End
	ElseIf strExtension = "XLS" Then
		'�_�E�����[�h������
		Response.ContentType = "application/octet-stream"
		Response.AddHeader "Content-Disposition","attachment;filename=" & strFileName
		Server.Execute PRT_TEMPPATH & strFileName
		Response.End
	ElseIf strExtension = "TXT" Then
		'�_�E�����[�h������
		Response.ContentType = "application/x-download"
		Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
		Response.AddHeader "Content-Disposition","filename=" & strFileName
		Server.Execute PRT_TEMPPATH & strFileName
		Response.End
	End If
'##2004.08.27 UPD END ORB)A.NAGUMO

End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>����v���r���[</TITLE>
</HEAD>
<BODY>
<OBJECT CLASSID="clsid:5220CB21-C88D-11CF-B347-00AA00A28331">
	<PARAM NAME="LPKPath" VALUE="/webHains/cab/ViewCtrl/CrView.lpk">
</OBJECT>
<DIV ALIGN="center">
	<OBJECT WIDTH="100%" HEIGHT="100%" CLASSID="clsid:551553D6-DAEA-11D3-BE3F-0090FE014382" CODEBASE="/webHains/cab/ViewCtrl/CrView.cab">
		<PARAM NAME="DocumentFileName" VALUE="http://<%= Request.ServerVariables("SERVER_NAME") & PRT_TEMPPATH & strFileName %>">
		<PARAM NAME="ShowToolBars"     VALUE="7">
	</OBJECT>
</DIV>
</BODY>
</HTML>
