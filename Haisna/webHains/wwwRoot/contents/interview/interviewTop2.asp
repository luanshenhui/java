<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�ʐڎx�����C�� (Ver0.0.1)
'		AUTHER  : 
'		�p�����[�^�ɂ���ď����\����ʕω�
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g

'�O��ʂ��瑗�M�����p�����[�^�l
Dim lngRsvNo		'�\��ԍ�
Dim lngIndex		'�C���f�b�N�X�i��ʑI���R���{�j
Dim lngGrpCd		'�C���f�b�N�X�i������ʑI���j

Dim strURL			'URL������
Dim mainURL			'URL������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
lngRsvNo    = Request("rsvNo")
lngIndex    = Request("index")
lngGrpCd    = Request("grpcd")

'�����\����URL�Z�b�g
strURL = ""
If lngGrpCd = "" Then
    '## ������ʋ敪�������Ȃ������ꍇ�A���������ʕ\��
    strURL = "totalJudView.asp?grpno=0"
    strURL = strURL & "&rsvNo=" & lngRsvNo
    strURL = strURL & "&winmode=0"
Else
    Select Case lngGrpCd
        '## �a������ʓW�J
        Case 21 strURL = "DiseaseHistory.asp"
        '## ��f���e��ʓW�J
        Case 24 strURL = "MonshinNyuryoku.asp"
    End Select

    strURL = strURL & "?grpno=" & lngGrpCd
    strURL = strURL & "&rsvNo=" & lngRsvNo
    strURL = strURL & "&winmode=0"
End If

mainURL = IIf( Request("urlname") <> "", Request("urlname"), strURL)

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML lang="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>�ʐڎx��</TITLE>
</HEAD>
<FRAMESET ROWS="125,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
	strURL = "interviewHeader.asp"
	strURL = strURL & "?rsvNo=" & lngRsvNo
	strURL = strURL & "&Index=" & lngIndex
%>
	<FRAME SRC="<%= strURL %>" NAME="header" NORESIZE>
	<FRAME SRC="<%= mainURL %>" NAME="main" NORESIZE>
</FRAMESET>
</HTML>
