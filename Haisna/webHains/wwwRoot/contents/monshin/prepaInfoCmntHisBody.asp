<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���f�O�����i��f�j�O�񑍍��R�����g  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim objCommon			'���ʃN���X
Dim objInterview		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim lngRsvNo			'�\��ԍ�


'�����R�����g
Dim vntCmtSeq			'�\����
Dim vntTtlJudCmtCd		'����R�����g�R�[�h
Dim vntTtlJudCmtstc		'����R�����g����
Dim vntTtlJudClassCd	'���蕪�ރR�[�h
Dim vntRsvNo 			'�\��ԍ�
Dim vntCslDate 			'��f��
Dim vntCsCd 			'�R�[�X�R�[�h
Dim vntCsName 			'�R�[�X����
Dim lngTtlCmtCnt		'�s��


Dim strBakCslDate 		'��f���i�O�s�j
Dim strBakCsCd 			'�R�[�X�R�[�h�i�O�s�j

Dim strColor			'�w�i�F

Dim Ret					'���A�l
Dim i, j				'�J�E���^�[

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon 		= Server.CreateObject("HainsCommon.Common")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")

'�����l�̎擾
lngRsvNo			= Request("rsvno")


Do


	'�����R�����g�擾
	lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
    									lngRsvNo, 1, _
										"*", 0,  , 1, _
    									vntCmtSeq, _
    									vntTtlJudCmtCd, _
    									vntTtlJudCmtstc, _
    									vntTtlJudClassCd, _
										vntRsvNo, _
										vntCslDate, _
										vntCsCd, _
										vntCsName _
										)
	If lngTtlCmtCnt < 0 Then
		Err.Raise 1000, , "�����R�����g�����݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
	End If

	Exit Do
Loop

Set objCommon 		= Nothing
Set objInterview    = Nothing
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���f�O�����i��f�j�O�񑍍��R�����g</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 15px; }
</style>

</HEAD>
<BODY>
		<TABLE WIDTH="431" BORDER="0" CELLSPACING="1" CELLPADDING="0">
<%
		strBakCslDate = ""
		strBakCsCd    = ""
		For i = 0 To lngTtlCmtCnt - 1
			If i mod 2 = 0 Then
				strColor = ""
			Else
				strColor = "#e0ffff"
			End If
%>
			<TR HEIGHT="17">
<%
			'�O�̍s�ƈႤ
			If strBakCslDate <> vntCslDate(i) Then
%>
				<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="81" HEIGHT="17"><%= vntCslDate(i) %></TD>
<%
				strBakCslDate = vntCslDate(i)
			Else
%>
				<TD ALIGN="left" BGCOLOR="<%= strColor %>" WIDTH="81" HEIGHT="17"></TD>
<%
			End If
%>
<%
			'�O�̍s�ƈႤ
			If strBakCsCd <> vntCsCd(i) Then
%>
				<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="116" HEIGHT="17"><%= vntCsName(i) %></TD>
<%
				strBakCsCd = vntCsCd(i)
			Else
%>
				<TD ALIGN="left" BGCOLOR="<%= strColor %>" WIDTH="116" HEIGHT="17"></TD>
<%
			End If
%>
				<TD ALIGN="left" NOWRAP BGCOLOR="<%= strColor %>" WIDTH="350" HEIGHT="17"><%= vntTtlJudCmtstc(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</BODY>
</HTML>