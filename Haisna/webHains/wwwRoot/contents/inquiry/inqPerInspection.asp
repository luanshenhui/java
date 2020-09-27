<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �l������� (Ver0.0.1)
'	   AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
If Request("mode") = "1" Then
	Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_BUSINESS_TOP)
Else
	Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)
End If

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�����l
Dim strPerID			'�l�h�c
Dim strMode				'�������[�h(�t���[�����\��:"1")

'���o��
Dim strArrTitle()		'��f�����o��

'��f��
Dim strCslDate			'��f��
Dim strCsName			'�R�[�X��

'�l��������
Dim strItemCd			'�������ڃR�[�h
Dim strSuffix			'�T�t�B�b�N�X
Dim strItemName			'�������ږ���
Dim strResult			'��������
Dim strResultType		'���ʃ^�C�v
Dim strItemType			'���ڃ^�C�v
Dim strStcItemCd		'���͎Q�Ɨp���ڃR�[�h
Dim strShortStc			'���͗���
Dim strIspDate			'������

Dim objConsult			'��f���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objPerResult		'�l�������ʏ��A�N�Z�X�pCOM�I�u�W�F�N�g

Dim lngConsultCount		'��f������
Dim lngPerResultCount	'�l�������ʌ���
Dim i					'�C���f�b�N�X

Dim blnExist			'���݃t���O

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strPerID = Request("perID")
strMode  = Request("mode")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult   = Server.CreateObject("HainsConsult.Consult")
Set objPerResult = Server.CreateObject("HainsPerResult.PerResult")

'��f�����o���̕ҏW
Call EditTitle

'��f��ǂݍ���
lngConsultCount = objConsult.SelectConsultHistory(strPerID, , , , 2, , strCslDate, , strCsName)

'�l�������ʓǂݍ���
lngPerResultCount = objPerResult.SelectPerResultList(strPerID, _
														strItemCd, _
														strSuffix, _
														strItemName, _
														strResult, _
														strResultType, _
														strItemType, _
														strStcItemCd, _
														strShortStc, _
														strIspDate)

'-----------------------------------------------------------------------------
' ��f�����o���̕ҏW
'-----------------------------------------------------------------------------
Sub EditTitle()
	Redim strArrTitle(1)
	strArrTitle(0) = "���߂̎�f��"
	strArrTitle(1) = "�P�O�̎�f��"
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�l���</TITLE>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<INPUT TYPE="hidden" NAME="perID" VALUE="<%= strPerID %>">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD BGCOLOR="#EEEEEE" NOWRAP><B>�l���</B></TD>
	</TR>
</TABLE>
<BR>
<B>�l�������</B><BR>
<%
blnExist = False
For i = 0 To lngPerResultCount - 1
	If strResult(i) <> "" Then
		blnExist = True
		Exit For
	End If
Next

If Not blnExist Then
%>
	<BR>�l�������͑��݂��܂���B<BR>
<%
Else
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP>�������ږ�</TD>
			<TD NOWRAP>��������</TD>
			<TD NOWRAP>������</TD>
		</TR>
<%
		For i = 0 To lngPerResultCount - 1

			If strResult(i) <> "" Then
%>
				<TR BGCOLOR="#eeeeee">
					<TD NOWRAP><%= strItemName(i) %></TD>
					<TD NOWRAP><%= IIf(strShortStc(i) <> "", strShortStc(i), IIf(strResult(i) <> "", strResult(i), "&nbsp;")) %></TD>
					<TD NOWRAP><%= IIf(strIspDate(i)="", "&nbsp;", strIspDate(i)) %></TD>
				</TR>
<%
			End If

		Next
%>
</TABLE>
<%
End If
%>
<BR>
<B>��f��</B><BR>
<%
If lngConsultCount = 0 Then
%>
	<BR>��f���͑��݂��܂���B
<%
Else
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
		For i = 0 To lngConsultCount - 1
%>
			<TR BGCOLOR="#EEEEEE">
				<TD NOWRAP><%= strArrTitle(i) %></TD>
				<TD NOWRAP><%= strCslDate(i) %></TD>
				<TD NOWRAP><%= strCsName(i) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
End If
%>
<BR>
<%
If strMode <> "1" Then
%>
	<TABLE>
		<TR BGCOLOR="#ffffff" HEIGHT="40">
			<TD WIDTH="340" COLSPAN="2" ALIGN="RIGHT" VALIGN="BOTTOM">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
			</TD>
		</TR>
	</TABLE>
<%
End If
%>
</BODY>
</HTML>
