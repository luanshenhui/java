<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ʐڏ��̓o�^(Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCommon			'���ʃN���X
Dim objAfterCare		'�A�t�^�[�P�A���p

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Const strSectionName = "OTHERJUDCLASS"
Const strKeyName = "NAME"

Dim strPerId			'�l�h�c
Dim strContactDate		'�ʐړ�
Dim strJudClassEtcCd	'���̑����蕪�ރR�[�h
Dim strRsvNo			'�\��ԍ�

'�A�t�^�[�P�A�Ǘ����ڏ��
Dim strJudClassCd_af	'���蕪��
Dim strJudClassName_af	'���蕪�ޖ�
Dim strJudClassEtc_af	'���̑����蕪�ޖ�

'���蕪�ޏ��
Dim strJudClassCd		'���蕪�ރR�[�h
Dim strJudClassName		'���蕪�ޖ���
Dim strAllJudFlg		'���v�p��������t���O
Dim strAfterCareCd		'�A�t�^�[�P�A�R�[�h

Dim strToday			'�{�����t�i�V�X�e�����t�j
Dim strDispPerName		'�l���́i�����j
Dim strDispPerKName		'�l���́i�J�i�j
Dim strDispAge			'�N��i�\���p�j
Dim strDispBirth		'���N�����i�\���p�j
Dim strDispJudClassEtc	'���̑����蕪�ޖ��i�\���p�j

Dim strChargeLastName	'�S���Ґ�
Dim strChargeFirstName	'�S���Җ�
Dim lngLudClassCount	'���蕪�ރ��R�[�h�J�E���g
Dim lngAfteCateMCount	'�A�t�^�[�P�A�Ǘ����ڃ��R�[�h�J�E���g
Dim strHtml				'HTML���[�N
Dim i,j					'���[�v�J�E���g

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")
Set objAfterCare 	= Server.CreateObject("HainsAfterCare.AfterCare")

strPerId			= Request("perId")
strContactDate		= Request("contactDate")
strRsvNo			= Request("RsvNo")

'ini�t�@�C�����炻�̑����蕪�ނ̃R�[�h���擾
	strJudClassEtcCd = objCommon.ReadIniFile( strSectionName, strKeyName )

'���蕪�ރe�[�u������A�t�^�[�P�A�֘A�̔��蕪�ޖ��̂��擾�i��ʕ\�����ڂ̎擾�j
	lngLudClassCount = objAfterCare.SelectJudClassAfterCare( strJudClassCd , strJudClassName, strAllJudFlg, strAfterCareCd )

If ( strPerId <> "" And strContactDate <> "" ) Or (strRsvNo <> "") Then

	'�A�t�^�[�P�A�Ǘ����ڂ��l�h�c�C�ʐړ��ɊY�����郌�R�[�h���擾
	lngAfteCateMCount = objAfterCare.SelectAfterCareM( strPerId , _
													   strContactDate , _
													   strJudClassCd_af ,  _
													   strJudClassName_af,  _
													   strJudClassEtc_af, _
													   strRsvNo)

End If


Function JudClassCdCheck( arrDispJudCd, arrCheckJudCd )

	If Not IsArray(arrCheckJudCd) Then
		Exit Function
	End If

	
	For j = 0 To Ubound(arrCheckJudCd)
		If( arrCheckJudCd(j) = arrDispJudCd ) Then
			JudClassCdCheck = " CHECKED"
			Exit Function
		End If
	Next

	JudClassCdCheck = ""

End Function

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ʐڏ��̓o�^</TITLE>
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="" METHOD="get" target="_top" ONSUBMIT="return false;">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="100%">
		<TR>
			<TD>�����F</TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
<%
'�����i���蕪�ށj��HTML�ҏW
If( lngLudClassCount > 0 ) Then
	For i = 0 to lngLudClassCount - 1
		strHtml = "		<TR>" & vbCrLf & _
				  "			<TD>" & vbCrLf & _
				  "				<TABLE BORDER=""0"" CELLPADDING=""0"" CELLSPACING=""0"">" & vbCrLf & _
		  		  "					  <TR>" & vbCrLf & "						<TD><INPUT TYPE=""checkbox"" NAME=""judClassCd"""
		strHtml = strHtml & "VALUE=""" & strJudClassCd(i) & """" & JudClassCdCheck(strJudClassCd(i), strJudClassCd_af ) & " ></TD>" & vbCrLf
		strHtml = strHtml & "						<TD NOWRAP>" & strJudClassName(i) & "</TD>" & vbCrLf
		strHtml = strHtml & "					</TR>" & vbCrLf & _
							"				</TABLE>" & vbCrLf & _
							"			</TD>" & vbCrLf & _
							" 		</TR>" & vbCrLf
		Response.Write strHtml

	Next

End If

'���̑����蕪�ޖ��̂̐ݒ�
For i = 0 To lngAfteCateMCount - 1
	If( strJudClassEtc_af(i) <> "" or Not IsNull(strJudClassEtc_af(i)) ) Then
		strDispJudClassEtc = strJudClassEtc_af(i)
	End If
Next

%>

		<TR>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD WIDTH="20"></TD>
						<TD><INPUT TYPE="text" NAME="judClassCdEtc" SIZE="14" MAXLENGTH="10" VALUE="<%= strDispJudClassEtc %>"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
