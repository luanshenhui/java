<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		����� (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim strPerId						'�l�h�c
Dim strYear							'�\���N
Dim strMonth						'�\����
Dim strDay							'�\����
Dim strDate							'�\�����t

'�l���
Dim strLastName						'��
Dim strFirstName					'��
Dim strLastKName					'�J�i��	
Dim strFirstKName					'�J�i��
Dim strBirth						'���N����
Dim strGender						'����
Dim strGenderName					'���ʖ���

'���茋�ʏ��
Dim strArrRsvNo()					'�\��ԍ�
Dim lngArrRsvNoRows()				'�\��ԍ����Ƃ̍s��
Dim strArrCslDate()					'��f��
Dim strArrCsName()					'�R�[�X��
Dim strArrJudClassCd()				'���蕪�ރR�[�h
Dim lngArrJudClassRows()			'�\��ԍ��E���蕪�ނ��Ƃ̍s��
Dim strArrJudClassName()			'���蕪�ޖ���
Dim strArrJudSName()				'���藪��
Dim strArrStdJudNote()				'��^��������
Dim strArrFreeJudCmt()				'�t���[����R�����g
Dim strArrGuidanceStc()				'�w�����e����
Dim strArrJudCmtStc()				'����R�����g

Dim strOldRsvNo						'�����J�E���g�p�E�\��ԍ�
Dim strOldJudClassCd				'�����J�E���g�p�E���蕪��
Dim lngRsvNoRows					'�\��ԍ����Ƃ̍s���J�E���^
Dim lngRsvNoStartPos				'�z�񌟍��p�E�\��ԍ��ʒu
Dim lngJudClassRows					'�\��ԍ��E���蕪�ނ��Ƃ̍s���J�E���^
Dim lngJudClassStartPos				'�z�񌟍��p�E���蕪�ވʒu

Dim objPerson						'�l���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objJudgement					'���茋�ʏ��A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objCommon						'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g

Dim i								'�C���f�b�N�X
Dim j								'�C���f�b�N�X
Dim lngCount						'���R�[�h����
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strPerId = Request("perID")
strYear  = Request("year")
strMonth = Request("month")
strDay   = Request("day")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objPerson	= Server.CreateObject("HainsPerson.Person")
Set objJudgement = Server.CreateObject("HainsJudgement.Judgement")
Set objCommon	= Server.CreateObject("HainsCommon.Common")

Do

	'�\���J�n���t���n����Ȃ������ꍇ�A�V�X�e�����t��\���J�n���t�Ƃ���
	If strYear = "" And strMonth = "" And strDay = "" Then
		strYear  = Year(Now)
		strMonth = Month(Now)
		strDay   = Day(Now)
	End If

	'���t�^�ɕϊ�
	strDate = CDate(strYear & "/" & strMonth & "/" & strDay)

	'�l���ǂݍ���
	Call objPerson.SelectPersonInf(strPerId, _
									strLastName, _
									strFirstName, _
									strLastKName, _
									strFirstKName, _
									strBirth, _
									strGender, _
									strGenderName)

	'���N�����a��\��
	strBirth = objCommon.FormatString(strBirth, "g ee.mm.dd")

	'���茋�ʏ��ǂݍ���
	lngCount = objJudgement.SelectHistoryJudRslList(strPerId, _
													strDate, _
													strArrRsvNo, _
													strArrCslDate, _
													strArrCsName, _
													strArrJudClassCd, _
													strArrJudClassName, _
													strArrJudSName, _
													strArrStdJudNote, _
													strArrFreeJudCmt, _
													strArrGuidanceStc, _
													strArrJudCmtStc)

	'�Ώۃf�[�^�����݂��Ȃ��ꍇ�A�������Ȃ�
	If lngCount = 0 Then
		Exit Do
	End If
	
	'�z�񏉊���
	ReDim lngArrRsvNoRows(UBound(strArrRsvNo))
	ReDim lngArrJudClassRows(UBound(strArrRsvNo))

	'��r�p���[�N������
	strOldRsvNo = ""
	strOldJudClassCd = ""

	'�J�E���^������
	lngRsvNoRows = 0
	lngRsvNoStartPos = 0
	lngJudClassRows = 0
	lngJudClassStartPos = 0

	'�\��ԍ��E���蕪�ނ��Ƃɍs�����J�E���g
	For i = 0 To UBound(strArrRsvNo)
		'�������
		If strOldRsvNo = "" Then
			strOldRsvNo = strArrRsvNo(i)
			strOldJudClassCd = strArrJudClassCd(i)
		End If
		'�\��ԍ����ς�����Ƃ��A�\��ԍ����Ƃ̍s�����Z�b�g
		If strArrRsvNo(i) <> strOldRsvNo Then
			lngArrJudClassRows(lngJudClassStartPos) = lngJudClassRows
			lngArrRsvNoRows(lngRsvNoStartPos) = lngRsvNoRows
			strOldRsvNo = strArrRsvNo(i)
			strOldJudClassCd = strArrJudClassCd(i)
			lngRsvNoStartPos = i
			lngRsvNoRows = 0
			lngJudClassStartPos = i
			lngJudClassRows = 0
		End If
		'���蕪�ނ��ς�����Ƃ��A���蕪�ނ��Ƃ̍s�����Z�b�g
		If strArrJudClassCd(i) <> strOldJudClassCd Then
			lngArrJudClassRows(lngJudClassStartPos) = lngJudClassRows
			strOldJudClassCd = strArrJudClassCd(i)
			lngJudClassStartPos = i
			lngJudClassRows = 0
		End If
		'�s�����J�E���g
		lngRsvNoRows = lngRsvNoRows + 1
		lngJudClassRows = lngJudClassRows + 1
	Next
	'�Ō�̗\��ԍ��E���蕪�ނ̍s�����Z�b�g
	If strOldRsvNo <> "" Then
		lngArrJudClassRows(lngJudClassStartPos) = lngJudClassRows
		lngArrRsvNoRows(lngRsvNoStartPos) = lngRsvNoRows
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
<TITLE>�����</TITLE>
</HEAD>

<BODY MARGINWIDTH="0" MARGINHEIGHT="0" BGCOLOR="#FFFFFF">

<!-- �E�C���h�E�������o�� -->
<TABLE width=100% border=0 cellspacing=0 cellpadding=0>
	<TR>
		<TD bgcolor="#999999" width="20%">
			<TABLE border=0 cellpadding=2 cellspacing=1 width=100%>
				<TR height="15">
					<TD bgcolor=#eeeeee nowrap><B>�ߋ��̔�����͓��e</B></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="100%">
	<TR>
		<TD COLSPAN="2"><IMG SRC="/webHains/images/spacer.gif" HEIGHT="3"></TD>
	</TR>
	<TR>
		<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="TOP"><%= strPerId %></TD>
		<TD NOWRAP><B><%= strLastName & "�@" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKName & "�@" & strFirstKName %></FONT>)<BR><%= strBirth %>���@<%= strGenderName %></TD>
	</TR>
</TABLE>
<BR>
<%
	If lngCount > 0 Then
%>
		<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="2" WIDTH="600">
		<TR>
			<TD BGCOLOR="#eeeeee">��f��</TD>
			<TD BGCOLOR="#eeeeee">�R�[�X</TD>
			<TD BGCOLOR="#eeeeee">����</TD>
			<TD BGCOLOR="#eeeeee">����</TD>
			<TD BGCOLOR="#eeeeee">����R�����g</TD>
			<TD BGCOLOR="#eeeeee">�w�����e</TD>
		</TR>
<% 
	Else
%>
		<UL><LI>������͑��݂��܂���</UL>
<%
	End If
	
	For i = 0 To lngCount - 1
%>
		<TR>
<%
			If lngArrRsvNoRows(i) <> "" Then
%>
				<TD ROWSPAN="<%= lngArrRsvNoRows(i) %>" VALIGN="TOP"><%= strArrCslDate(i) %></TD>
				<TD ROWSPAN="<%= lngArrRsvNoRows(i) %>" VALIGN="TOP"><%= strArrCsName(i) %></TD>
<%
			End If
			If lngArrJudClassRows(i) <> "" Then
%>
				<TD ROWSPAN="<%= lngArrJudClassRows(i) %>" NOWRAP><%= strArrJudClassName(i) %></TD>
				<TD ROWSPAN="<%= lngArrJudClassRows(i) %>" NOWRAP><%= IIf(strArrJudSName(i)<>"",strArrJudSName(i),"&nbsp;") %></TD>
<%
			End If
%>
			<TD><%= IIf(strArrJudCmtStc(i)<>"",strArrJudCmtStc(i),"&nbsp;") %></TD>
<%
			If lngArrJudClassRows(i) <> "" Then
%>
				<TD ROWSPAN="<%= lngArrJudClassRows(i) %>"><%= IIf(strArrGuidanceStc(i)<>"", strArrGuidanceStc(i),"&nbsp;") %></TD>
<%
			End If
%>
		</TR>
<%
	Next
%>

</TABLE>
<BR>
<TR BGCOLOR="#ffffff" HEIGHT="40">
	<TD COLSPAN="2" ALIGN="RIGHT" VALIGN="BOTTOM">
		<A HREF="javascript:function voi(){};voi()" ONCLICK="top.close()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
	</TD>
</TR>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
