<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����I���i�{�f�B�j (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objSentence			'���͏��A�N�Z�X�p

'�p�����[�^
Dim strItemCd			'�������ڃR�[�h
Dim lngItemType			'���ڃ^�C�v
Dim arrStcCd			'���̓R�[�h �z��

'����
Dim strStcCd			'���̓R�[�h
Dim strShortStc			'������
Dim lngCount			'���R�[�h����

Dim lngChkFlg			'�`�F�b�N�t���O
Dim i,j					'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objSentence 	= Server.CreateObject("HainsSentence.Sentence")

'�����l�̎擾
strItemCd			= Request("itemcd")
lngItemType			= CLng("0" & Request("itemtype"))
arrStcCd			= ConvIStringToArray(Request("stccd"))

Do

	'�w�茟�����ڃR�[�h�A���ڃ^�C�v�̃��R�[�h���擾
	lngCount = objSentence.SelectSentenceList(strItemCd, _
											  lngItemType, _
											  strStcCd, _
											  strShortStc, _
											  , , , , , , , , _
											  1 _
											  )
	If lngCount < 0 Then
		Err.Raise 1000, , "���͂̈ꗗ���擾�ł��܂���B�i�������ڃR�[�h = " & strItemCd & ",���ڃ^�C�v = " & lngItemType & ")"
	End If

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����I��</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="" METHOD="get">
	<INPUT TYPE="hidden" NAME="itemcd"   VALUE="<%= strItemCd   %>">
	<INPUT TYPE="hidden" NAME="itemtype" VALUE="<%= lngItemType %>">

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<TD NOWRAP COLSPAN="2">�R�[�h</TD>
			<TD NOWRAP>���͖�</TD>
		</TR>
<%
	For i=0 To lngCount -1
		'�I���ς݃`�F�b�N
		lngChkFlg = 0
		For j=0 To UBound(arrStcCd)
			If arrStcCd(j) = strStcCd(i) Then
				lngChkFlg = 1
				Exit For
			End If
		Next
%>
		<TR BGCOLOR="<%= IIf(i Mod 2 = 0, "#ffffff", "#eeeeee") %>">
			<TD NOWRAP><INPUT TYPE="checkbox" NAME="chk" <%=IIf(lngChkFlg=1,"CHECKED","")%> ></TD>
			<TD NOWRAP><INPUT TYPE="hidden" NAME="stccd" VALUE="<%= strStcCd(i) %>"><%= strStcCd(i) %></TD>
			<TD NOWRAP><INPUT TYPE="hidden" NAME="shortstc" VALUE="<%= strShortStc(i) %>"><%= strShortStc(i) %></TD>
		</TR>
<%
	Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
