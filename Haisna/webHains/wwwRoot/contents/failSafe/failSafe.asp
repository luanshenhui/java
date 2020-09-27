<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   FAILSAFE (Ver0.0.1)
'	   AUTHER  : t.yaguchi@orbsys.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"    -->
<!-- #include virtual = "/webHains/includes/common.inc"          -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"     -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon					'���ʃN���X
Dim objFailSafe					'FailSafe�A�N�Z�X�p

'�p�����[�^�l
Dim lngStrYear			'��f��(��)(�N)
Dim lngStrMonth			'��f��(��)(��)
Dim lngStrDay			'��f��(��)(��)
Dim lngEndYear			'��f��(��)(�N)
Dim lngEndMonth			'��f��(��)(��)
Dim lngEndDay			'��f��(��)(��)
Dim strMode			'���[�h

'��f���̔z��
Dim strArrRsvNo			'�\��ԍ��̔z��
Dim strArrCslDate		'��f���̔z��
Dim strArrPerId			'�lID�̔z��
Dim strArrCsCd			'�R�[�X�R�[�h�̔z��
Dim strArrOrgCd1		'�c�̃R�[�h�P�̔z��
Dim strArrOrgCd2		'�c�̃R�[�h�Q�̔z��
Dim strArrAge			'��f���N��̔z��
Dim strArrLastName		'���̔z��
Dim strArrFirstName		'���̔z��
Dim strArrCsName		'�R�[�X���̔z��
Dim strArrMOrgCd1		'�c�̃R�[�h�P�̔z��
Dim strArrMOrgCd2		'�c�̃R�[�h�Q�̔z��
Dim strArrMPrice		'���z�̔z��
Dim strArrMTax			'�Ŋz�̔z��
Dim strArrCPrice		'���S���z�̔z��
Dim strArrCTax			'����ł̔z��
Dim strArrCtrPtCd		'�_��p�^�[���R�[�h�̔z��
Dim strArrOptCd			'�I�v�V�����R�[�h�̔z��
Dim strArrOptBranchNo		'�I�v�V�����}�Ԃ̔z��
Dim strArrOptName		'�I�v�V�������̔z��
Dim strArrOrgSName		'�c�̗��̖��̔z��
Dim strArrOptMsg		'�I�v�V�������b�Z�[�W(�N:�N��,��:����,��:��f�敪)�̔z��
Dim strArrP_Age			'���݂̌_�񂩂�̎�f���N��̔z��
Dim strArrLimitFlg		'���x�z�t���O(0:���x�z�ƈ�v,1:���x�z�ƈႤ)
Dim lngCount			'���R�[�h����(��f���)

Dim blnTargetFlg		'�Ώۃt���O
Dim blnTargetFlg2		'�Ώۃt���O
Dim dtmStrDate			'��f��(��)
Dim dtmEndDate			'��f��(��)
Dim dtmDate			'���t
Dim strDispDate			'�\���p�̎�f���t
Dim strMessage			'�G���[���b�Z�[�W
Dim i, j, k			'�C���f�b�N�X
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objFailSafe = Server.CreateObject("HainsFailSafe.FailSafe")
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
lngStrYear  = CLng("0" & Request("strYear"))
lngStrMonth = CLng("0" & Request("strMonth"))
lngStrDay   = CLng("0" & Request("strDay"))
lngEndYear  = CLng("0" & Request("endYear"))
lngEndMonth = CLng("0" & Request("endMonth"))
lngEndDay   = CLng("0" & Request("endDay"))
strMode     = Request("mode")

Do

	If strMode <> "RUN"Then
		Exit Do
	End If

	'��f��(��)�̓��t�`�F�b�N
	If lngStrYear <> 0 Or lngStrMonth <> 0 Or lngStrDay <> 0 Then
		If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Then
			strMessage = "��f���̎w��Ɍ�肪����܂��B"
			Exit Do
		End If
	End If

	'��f��(��)�̓��t�`�F�b�N
	If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
		If Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
			strMessage = "��f���̎w��Ɍ�肪����܂��B"
			Exit Do
		End If
	End If

	'��f���̕ҏW
	If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
		dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
	End If

	If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
		dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
	End If

	Do

		'�I�������ݒ莞�͉������Ȃ�
		If dtmEndDate = 0 Then
			Exit Do
		End If

		'�J�n�����ݒ�A�܂��͊J�n�����I�������ߋ��ł����
		If dtmStrDate = 0 Or dtmStrDate > dtmEndDate Then

			'�l������
			dtmDate    = dtmStrDate
			dtmStrDate = dtmEndDate
			dtmEndDate = dtmDate

		End If

		'�X�ɓ��l�̏ꍇ�A�I�����̓N���A
		If dtmStrDate = dtmEndDate Then
			dtmEndDate = 0
		End If

		Exit Do
	Loop

	'��̏����̂��߂ɔN�������ĕҏW
	If dtmStrDate <> 0 Then
		lngStrYear  = Year(dtmStrDate)
		lngStrMonth = Month(dtmStrDate)
		lngStrDay   = Day(dtmStrDate)
	Else
		lngStrYear  = 0
		lngStrMonth = 0
		lngStrDay   = 0
	End If

	If dtmEndDate <> 0 Then
		lngEndYear  = Year(dtmEndDate)
		lngEndMonth = Month(dtmEndDate)
		lngEndDay   = Day(dtmEndDate)
	Else
		lngEndYear  = 0
		lngEndMonth = 0
		lngEndDay   = 0
	End If

	'�����L�[�A��f���̂����ꂩ���w�肳��Ă��Ȃ��ꍇ�͌������s��Ȃ�
	If dtmEndDate = 0 And dtmStrDate = 0 Then
		strMessage = "���������𖞂�����f���͑��݂��܂���B"
		Exit Do
	End If

	If dtmStrDate < Date Then
		strMessage = "��f���͍����ȍ~���w�肵�ĉ������B"
		Exit Do
	End If


	'���t�͈̔̓`�F�b�N�R�P���܂�
	If dtmEndDate - dtmStrDate > 30 Then
		strMessage = "���t�͂P�����ȓ����w�肵�ĉ������I�I"
		Exit Do
	End If

'	'��f���̓ǂݍ���
'	Set objFailSafe = Server.CreateObject("HainsFailSafe.FailSafe")
	lngCount = objFailSafe.SelectConsult( _
						dtmStrDate, dtmEndDate, _
						strArrRsvNo, strArrCslDate, _
						strArrPerId, strArrCsCd, _
						strArrOrgCd1, strArrOrgCd2, _
						strArrAge, strArrLastName, _
						strArrFirstName, strArrCsName, _
						strArrMOrgCd1, strArrMOrgCd2, _
						strArrMPrice, strArrMTax, _
						strArrCPrice, strArrCTax, _
						strArrCtrPtCd, strArrOptCd, _
						strArrOptBranchNo, strArrOptName, _
						strArrOrgSName, strArrOptMsg, _
						strArrP_Age, strArrLimitFlg _
			   		)

	If lngCount = 0 Then
		strMessage = "���������𖞂�����f���͑��݂��܂���B"
	End If

'	Set objFailSafe = Nothing

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �^�C�g���s�̕ҏW
'
' �����@�@ : (In)     strAddDiv   �ǉ������敪
' �@�@�@�@   (In)     strAddName  �ǉ�������
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditTitle()

	Dim strTitle	'�^�C�g��

	'�^�C�g�����̔z����쐬
	strTitle = Array( _
				   "�\��ԍ�",       "��f��",           "�lID",         "����",             "�R�[�X", _
				   "�R�[�X��",       "�\��",             "�_��",           "��",               "��", _
				   "���S��",         "���S����",           "�I�v�V����",     "�I�v�V������",     "�\�񎞋��z", _
				   "�\�񎞏����",   "�_����z",       "�_������"							 _
			   )
%>
	<TR BGCOLOR="#cccccc">
<%
		For i = 0 To UBound(strTitle)
%>
			<TD NOWRAP><%= strTitle(i) %></TD>
<%
		Next
%>
	</TR>
<%
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���z���̕ҏW
'
' �����@�@ : (In)     strMOrgCd1	���S���R�[�h�P
' �@�@�@�@   (In)     strMOrgCd2	���S���R�[�h�Q
' �@�@�@�@   (In)     strMPrice		���z(CONSULT_M)
' �@�@�@�@   (In)     strMTax		�����(CONSULT_M)
' �@�@�@�@   (In)     strCPrice		���z(CTRPT_PRICE)
' �@�@�@�@   (In)     strCTax		�����(CTRPT_PRICE)
' �@�@�@�@   (In)     strCtrPtCd	�_��p�^�[���R�[�h
' �@�@�@�@   (In)     strOptCd		�I�v�V�����R�[�h
' �@�@�@�@   (In)     strOptBranchNo	�I�v�V�����}��
' �@�@�@�@   (In)     strOptName	�I�v�V������
' �@�@�@�@   (In)     strOrgSName	�c�̗��̖�
' �@�@�@�@   (In)     strOptMsg		�I�v�V�������b�Z�[�W(�N:�N��,��:����,��:��f�敪)
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditPriceItem(strMOrgCd1, strMOrgCd2, strMPrice, _
		  strMTax, strCPrice, strCTax, _
		  strCtrPtCd, strOptCd, strOptBranchNo, _
		  strOptName, strOrgSName, strOptMsg _
		 )

	Const COLS_PER_ROW = 3	'�P�s�ӂ�̗�

	Dim strWrkMOrgCd1		'���S���R�[�h�P
	Dim strWrkMOrgCd2		'���S���R�[�h�Q
	Dim strWrkMPrice		'���z(CONSULT_M)
	Dim strWrkMTax			'�����(CONSULT_M)
	Dim strWrkCPrice		'���z(CTRPT_PRICE)
	Dim strWrkCTax			'�����(CTRPT_PRICE)
	Dim strWrkCtrPtCd		'�_��p�^�[���R�[�h
	Dim strWrkOptCd			'�I�v�V�����R�[�h
	Dim strWrkOptBranchNo		'�I�v�V�����}��
	Dim strWrkOptName		'�I�v�V������
	Dim strWrkOrgSName		'�c�̗��̖�
	Dim strWrkOptMsg		'�I�v�V�������b�Z�[�W(�N:�N��,��:����,��:��f�敪)
	Dim lngCount			'�ǉ�������

	Dim strWOrgCd1			'�c�̃R�[�h�P�̑ޔ�
	Dim strWOrgCd2			'�c�̃R�[�h�Q�̑ޔ�
	Dim strMark				'�ǉ������敪�������}�[�N
	Dim i, j				'�C���f�b�N�X

	'���z��񂪑��݂��Ȃ��ꍇ�͏����I��
	If strMOrgCd1 = "" Then
%>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
<%
		Exit Sub
	End If

	'�J���}���Z�p���[�^�Ƃ��Ĕz��ɕϊ�
	strWrkMOrgCd1     = Split(strMOrgCd1,  ",")
	strWrkMOrgCd2     = Split(strMOrgCd2,  ",")
	strWrkMPrice      = Split(strMPrice,  ",")
	strWrkMTax        = Split(strMTax,  ",")
	strWrkCPrice      = Split(strCPrice,  ",")
	strWrkCTax        = Split(strCTax,  ",")
	strWrkCtrPtCd     = Split(strCtrPtCd,  ",")
	strWrkOptCd       = Split(strOptCd,  ",")
	strWrkOptBranchNo = Split(strOptBranchNo,  ",")
	strWrkOptName     = Split(strOptName,  ",")
	strWrkOrgSName    = Split(strOrgSName,  ",")
	strWrkOptMsg      = Split(strOptMsg,  ",")
	lngCount = UBound(strWrkMOrgCd1)
	'�z��ł͂Ȃ����͂P�ԖڂɊi�[����
	If lngCount = 0 Then
		Redim strWrkMOrgCd1(0)
		Redim strWrkMOrgCd2(0)
		Redim strWrkMPrice(0)
		Redim strWrkMTax(0)
		Redim strWrkCPrice(0)
		Redim strWrkCTax(0)
		Redim strWrkCtrPtCd(0)
		Redim strWrkOptCd(0)
		Redim strWrkOptBranchNo(0)
		Redim strWrkOptName(0)
		Redim strWrkOrgSName(0)
		Redim strWrkOptMsg(0)
		strWrkMOrgCd1(0)     = strMOrgCd1
		strWrkMOrgCd2(0)     = strMOrgCd2
		strWrkMPrice(0)      = strMPrice
		strWrkMTax(0)        = strMTax
		strWrkCPrice(0)      = strCPrice
		strWrkCTax(0)        = strCTax
		strWrkCtrPtCd(0)     = strCtrPtCd
		strWrkOptCd(0)       = strOptCd
		strWrkOptBranchNo(0) = strOptBranchNo
		strWrkOptName(0)     = strOptName
		strWrkOrgSName(0)    = strOrgSName
		strWrkOptMsg(0)      = strOptMsg
	End If

%>

	<% '�敪 %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
%>
			<TR>
				<TD NOWRAP><%= IIf(strWrkOptMsg(i) = "","�@",strWrkOptMsg(i)) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</TD>

	<% '�c�̃R�[�h %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		strWOrgCd1 = ""
		strWOrgCd2 = ""
		For i = 0 To lngCount

			'���S�����ς������o��
			If strWrkMOrgCd1(i) <> strWOrgCd1 And _
			   strWrkMOrgCd2(i) <> strWOrgCd2 Then
%>
				<TR VALIGN="top"><TD NOWRAP><%= strWrkMOrgCd1(i) & "-" & strWrkMOrgCd2(i) %></TD></TR>
<%
				strWOrgCd1 = strWrkMOrgCd1(i)
			   	strWOrgCd2 = strWrkMOrgCd2(i)
			Else
%>
				<TR><TD NOWRAP>�@</TD></TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% '�c�̖� %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		strWOrgCd1 = ""
		strWOrgCd2 = ""
		For i = 0 To lngCount

			'���S�����ς������o��
			If strWrkMOrgCd1(i) <> strWOrgCd1 And _
			   strWrkMOrgCd2(i) <> strWOrgCd2 Then
%>
				<TR><TD NOWRAP><%= strWrkOrgSName(i) %></TD></TR>
<%
				strWOrgCd1 = strWrkMOrgCd1(i)
			   	strWOrgCd2 = strWrkMOrgCd2(i)
			Else
%>
				<TR><TD NOWRAP>�@</TD></TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% '�I�v�V���� %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
%>
			<TR>
				<TD NOWRAP><%= strWrkOptCd(i) & "-" & strWrkOptBranchNo(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</TD>

	<% '�I�v�V������ %>
	<TD NOWRAP>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
%>
			<TR>
				<TD NOWRAP><%= strWrkOptName(i) %></TD>
			</TR>
<%
		Next
%>
		</TABLE>
	</TD>

	<% '�\�񎞋��z %>
	<TD NOWRAP ALIGN="right">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
			'���z������Ă�����F��ς���
			If strWrkMPrice(i) <> strWrkCPrice(i) Then
%>
				<TR BGCOLOR="#cccccc">
					<TD NOWRAP ALIGN="right"><%= strWrkMPrice(i) %></TD>
				</TR>
<%
			Else
%>
				<TR>
					<TD NOWRAP ALIGN="right"><%= strWrkMPrice(i) %></TD>
				</TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% '�\�񎞏���� %>
	<TD NOWRAP ALIGN="right">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
			'����ł�����Ă�����F��ς���
			If strWrkMTax(i) <> strWrkCTax(i) Then
%>
				<TR BGCOLOR="#cccccc">
					<TD NOWRAP ALIGN="right"><%= strWrkMTax(i) %></TD>
				</TR>
<%
			Else
%>
				<TR>
					<TD NOWRAP ALIGN="right"><%= strWrkMTax(i) %></TD>
				</TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% '�_����z %>
	<TD NOWRAP ALIGN="right">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
			'���z������Ă�����F��ς���
			If strWrkMPrice(i) <> strWrkCPrice(i) Then
%>
				<TR BGCOLOR="#cccccc">
					<TD NOWRAP ALIGN="right"><%= strWrkCPrice(i) %></TD>
				</TR>
<%
			Else
%>
				<TR>
					<TD NOWRAP ALIGN="right"><%= strWrkCPrice(i) %></TD>
				</TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

	<% '�_������ %>
	<TD NOWRAP ALIGN="right">

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
		For i = 0 To lngCount
			'����ł�����Ă�����F��ς���
			If strWrkMTax(i) <> strWrkCTax(i) Then
%>
				<TR BGCOLOR="#cccccc">
					<TD NOWRAP ALIGN="right"><%= strWrkCTax(i) %></TD>
				</TR>
<%
			Else
%>
				<TR>
					<TD NOWRAP ALIGN="right"><%= strWrkCTax(i) %></TD>
				</TR>
<%
			End If
		Next
%>
		</TABLE>
	</TD>

<%
End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>FailSafe</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �q�E�B���h�E�����
function closeWindow() {

	// ���t�K�C�h�����
	calGuide_closeGuideCalendar();
}
//-->
</SCRIPT>

<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>

<BODY ONLOAD="JavaScript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<FORM NAME="failsafelist" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">FailSafe</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<INPUT TYPE="hidden" NAME="mode" VALUE="RUN">
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD COLSPAN="3">������������͂��ĉ������B</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD NOWRAP>��f���F</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:calGuide_clearDate('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, True) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, True) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, True) %></TD>
						<TD>��</TD>
						<TD>�`</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:calGuide_clearDate('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, True) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, True) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, True) %></TD>
						<TD>��</TD>
						<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.failsafelist.submit();return false"><IMG SRC="/webHains/images/findrsv.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
						<!--<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��"></TD>-->
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

<%
	Do
		'���s���Ȃ��ꍇ�͏I��
		If strMode <> "RUN"Then
			Exit Do
		End If

		'���b�Z�[�W���������Ă���ꍇ�͕ҏW���ď����I��
		If strMessage <> "" Then
			Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
			<!--<BR>&nbsp;<%= strMessage %>-->
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="10" BORDER="0"></TD>
				<TD></TD>
				<TD></TD>
			</TR>
			<TR>
				<TD>
				</TD>
				<TD WIDTH="300"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
				<TD>
					��F�_��̵�߼�݂Ɩ������������ꍇ�ɔN[�N��]�A��[��f�敪]�A��[����]���\������܂��B
				</TD>
			</TR>
			<TR>
				<TD>
					�Y���҂�
					<%=lngCount%>
					���ł��B
				</TD>
				<TD WIDTH="300"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="1" BORDER="0"></TD>
				<TD>
					���F�\��쐬��Ɍ_��̌��x�z���ύX���ꖵ�������������ꍇ�Ɂ����\������܂��B
				</TD>
			</TR>
		</TABLE>
		<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
<%
		'�^�C�g���s�̕ҏW
		Call EditTitle()

		For i = 0 to lngCount - 1
			Response.Write "<TR VALIGN=""""top"""">"
			Response.Write "<TD NOWRAP>" & strArrRsvNo(i) & "</TD>"
			strDispDate = objCommon.FormatString(strArrCslDate(i), "yyyy/m/d")
			Response.Write "<TD NOWRAP>" & strDispDate & "</TD>"
			Response.Write "<TD NOWRAP>" & strArrPerId(i) & "</TD>"
			Response.Write "<TD NOWRAP>" & strArrLastName(i) & "�@" & strArrFirstName(i) & "</TD>"
			Response.Write "<TD NOWRAP>" & strArrCsCd(i) & "</TD>"
			Response.Write "<TD NOWRAP>" & strArrCsName(i) & "</TD>"
%>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
				If strArrAge(i) <> strArrP_Age(i) Then
					Response.Write "<TR BGCOLOR=""#eeeeee"">"
					Response.Write "<TD NOWRAP>" & strArrAge(i) & "</TD>"
					Response.Write "</TR>"
				Else
					Response.Write "<TR>"
					Response.Write "<TD NOWRAP>" & strArrAge(i) & "</TD>"
					Response.Write "</TR>"
				End If
%>
				</TABLE>
			</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
				If strArrAge(i) <> strArrP_Age(i) Then
					Response.Write "<TR BGCOLOR=""#cccccc"">"
					Response.Write "<TD NOWRAP>" & strArrP_Age(i) & "</TD>"
					Response.Write "</TR>"
				Else
					Response.Write "<TR>"
					Response.Write "<TD NOWRAP>" & strArrP_Age(i) & "</TD>"
					Response.Write "</TR>"
				End If
%>
				</TABLE>
			</TD>
			<TD NOWRAP>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
<%
				If strArrLimitFlg(i) = 1 Then
					Response.Write "<TR BGCOLOR=""#cccccc"">"
					Response.Write "<TD NOWRAP>" & "��" & "</TD>"
					Response.Write "</TR>"
				Else
					Response.Write "<TR>"
					Response.Write "<TD NOWRAP></TD>"
					Response.Write "</TR>"
				End If
%>
				</TABLE>
			</TD>
<%

			'���z�ҏW
			Call EditPriceItem(strArrMOrgCd1(i), strArrMOrgCd2(i), strArrMPrice(i), _
					   strArrMTax(i), strArrCPrice(i), strArrCTax(i), _
					   strArrCtrPtCd(i), strArrOptCd(i), strArrOptBranchNo(i), _
					   strArrOptName(i), strArrOrgSName(i), strArrOptMsg(i) _
					  )

%>
			</TR>
<%
		Next
%>
		</TABLE>
<%
		Exit Do
	Loop
	Set objFailSafe = Nothing
%>
	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
