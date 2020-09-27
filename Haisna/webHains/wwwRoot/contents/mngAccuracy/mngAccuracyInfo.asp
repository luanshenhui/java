<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���x�Ǘ� (Ver1.0.0)
'	   AUTHER  : Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon				'���ʃN���X
Dim objMngAccuracy			'���x�Ǘ��N���X

'--- Post or Get Data
Dim strStartCslDate     	'����������f�N�����i�J�n�j
Dim strStartYear     		'����������f�N�i�J�n�j
Dim strStartMonth     		'����������f���i�J�n�j
Dim strStartDay     		'����������f���i�J�n�j
Dim lngGenderMode			'
Dim lngBorder				'

'--- From COM+ Data
Dim vntSeq
Dim vntItemCd
Dim vntSuffix
Dim vntItemName
Dim vntGender
Dim vntResultCount
Dim vntVal_L
Dim vntVal_S
Dim vntVal_H
Dim vntPercent_L
Dim vntPercent_H

'--- Control Variables
Dim strAction				'search:��������
Dim lngGetCount				'����
Dim i						'�J�E���^
Dim strMessage

'--- For Brouser Control
Dim lngArrGenderMode()		'���ʃ��[�h�R���{�p�z��i�R�[�h�j
Dim strArrGenderModeName()	'���ʃ��[�h�R���{�p�z��i���́j
Dim strDispItemCd			'
Dim strDispItemName			'
Dim strDispGenderName		'
Dim lngPrevSeq				'
Dim strDispPercent_L		'
Dim strDispPercent_H		'
Dim blnBoldMode				'

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strAction         = Request("action")
strStartYear      = Request("startYear")
strStartMonth     = Request("startMonth")
strStartDay       = Request("startDay")

strStartDay       = Request("startDay")

'�f�t�H���g�̓V�X�e���N������K�p����
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(Now))
	strStartMonth = CStr(Month(Now))
	strStartDay   = CStr(Day(Now))
End If

'-- �R���{�{�b�N�X�ҏW�p�ϐ��ݒ�
Call CreateGenderModeInfo()

Do

	If strAction <> "" Then

		'���̓`�F�b�N
		strMessage = CheckValue()
		If Not IsEmpty(strMessage) Then
			strAction = ""
			Exit Do
		End If

		'���������ɏ]�����я����ꗗ�𒊏o����
		Set objMngAccuracy = Server.CreateObject("HainsMngAccuracy.MngAccuracy")

		lngGetCount = objMngAccuracy.SelectMngAccuracy(cDate(strStartCslDate), _
		                                               lngGenderMode, _
													   vntSeq, _
													   vntItemCd, _
													   vntSuffix, _
													   vntItemName, _
													   vntGender, _
													   vntResultCount, _
													   vntVal_L, _
													   vntVal_S, _
													   vntVal_H, _
													   vntPercent_L, _
													   vntPercent_H)
	

	End If

	Exit Do

Loop
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X
	Dim strArrMessage	'�G���[���b�Z�[�W�̔z��

	'�����J�n�I����f���̕ҏW
	strStartCslDate = strStartYear & "/" & strStartMonth & "/" & strStartDay

	lngGenderMode = Request("genderMode")
	lngBorder     = Request("border")

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	If Not IsDate(strStartCslDate) Then
		objCommon.AppendArray strArrMessage, "�w�肳�ꂽ��f�������������t�ł͂���܂���B"
	End If

	If Trim(lngBorder) <> "" Then
		If Not IsNumeric(lngBorder) Then
			objCommon.AppendArray strArrMessage, "��O���E�䗦�ɂ͐�������������͂��Ă��������B"
		End If
	End If

	'�`�F�b�N���ʂ�Ԃ�
	CheckValue = strArrMessage

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ʎw��̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateGenderModeInfo()

	Redim Preserve lngArrGenderMode(3)
	Redim Preserve strArrGenderModeName(3)

	lngArrGenderMode(0) = 1 :strArrGenderModeName(0) = "�j���̂�"
	lngArrGenderMode(1) = 2 :strArrGenderModeName(1) = "�����̂�"
	lngArrGenderMode(2) = 3 :strArrGenderModeName(2) = "�j���ʂőS��"
	lngArrGenderMode(3) = 4 :strArrGenderModeName(3) = "���ʋ�ʂȂ�"

End Sub
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>���x�Ǘ�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �����{�^���N���b�N
function searchClick() {

	with ( document.mngAccuracy ) {
		action.value = 'search';
		submit();
	}

	return false;

}

// �A�����[�h���̏���
function closeGuideWindow() {

	//���t�K�C�h�����
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="mngAccuracy" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>"> 
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">���x�Ǘ�</FONT></B></TD>
	</TR>
</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
	<TR>
		<TD>��f��</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
					<TD>&nbsp;��
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>�\���Ώ�</TD>
		<TD>�F</TD>
		<TD><%= EditDropDownListFromArray("genderMode", lngArrGenderMode, strArrGenderModeName, lngGenderMode, NON_SELECTED_DEL) %>�@</TD>
	</TR>
	<TR>
		<TD>��O</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="TEXTBOX" NAME="Border" MAXLENGTH="4" SIZE="6" VALUE="<%= lngBorder %>">&nbsp;%�ȏ�̊�l�O�䗦�͋������ĕ\��</TD>
		<TD WIDTH="45"></TD>
		<TD ROWSPAN="2" VALIGN="BOTTOM"><A HREF="javascript:searchClick()"><IMG SRC="../../images/b_search.gif" ALT="���̏����Ō���" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
	</TR>
	<TR>
		<TD></TD>
		<TD></TD>
		<TD><SPAN STYLE="color:#999999">���󔒂Ŏ��s�����ꍇ�A�����\���͂���܂���B</SPAN></TD>
	</TR>
</TABLE>
<BR>
<!--�����͌�����������-->
<%
	If strAction <> "" Then
%>

<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD>�u<FONT COLOR="#ff6600"><B><%= strStartYear %>�N<%= strStartMonth %>��<%= strStartDay %>��</B></FONT>�v�̌������ʏ���\�����Ă��܂��B
			�������ʂ�<FONT COLOR="#ff6600"><B><%= lngGetCount %></B></FONT>���ł��B 
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
	<TR BGCOLOR="silver">
		<TD ALIGN="left" NOWRAP ROWSPAN="2">�������ڃR�[�h</TD>
		<TD ALIGN="left" NOWRAP ROWSPAN="2">�������ږ�</TD>
		<TD ALIGN="left" NOWRAP ROWSPAN="2">����</TD>
		<TD ALIGN="left" ROWSPAN="2" WRAP>�L���������ʐ�</TD>
		<TD BGCOLOR="#FFFFFF" WIDTH="4" ROWSPAN="2"></TD>
		<TD ALIGN="CENTER" COLSPAN="3" NOWRAP>�������ʐ�</TD>
		<TD BGCOLOR="#FFFFFF" WIDTH="4"></TD>
		<TD ALIGN="CENTER" COLSPAN="2" NOWRAP>�䗦</TD>
	</TR>
	<TR BGCOLOR="silver">
		<TD ALIGN="left" NOWRAP>��O�i��j</TD>
		<TD ALIGN="left" NOWRAP>���</TD>
		<TD ALIGN="left" NOWRAP>��O�i���j</TD>
		<TD BGCOLOR="#FFFFFF"></TD>
		<TD ALIGN="left" NOWRAP>��O�i��j</TD>
		<TD ALIGN="left" NOWRAP>��O�i���j</TD>
	</TR>
<%
	End If

	If lngGetCount > 0 Then

		For i = 0 To UBound(vntItemCd)

			blnBoldMode = False
			strDispItemCd = ""
			strDispItemName = ""
			strDispGenderName = ""
			strDispPercent_L = FormatNumber(vntPercent_L(i), 1) & "%"
			strDispPercent_H = FormatNumber(vntPercent_H(i), 1) & "%"

			'�O��Ɠ����������ڂ̏ꍇ�A�C���f�B�P�C�g����
			If vntSeq(i) <> lngPrevSeq Then
				strDispItemCd = vntItemCd(i) & "-" & vntSuffix(i)
				strDispItemName = vntItemName(i)
			Else
				strDispItemCd = ""
				strDispItemName = ""
			End If

			'���ʖ��̐ݒ�
			Select Case vntGender(i)
				Case 1
					strDispGenderName = "�j��"
				Case 2
					strDispGenderName = "����"
				Case 3
					strDispGenderName = "����"
				Case Else
					strDispGenderName = "�H�H"
			End Select

			If IsNumeric(lngBorder) Then

				If cDbl(vntPercent_L(i)) >= cDbl(lngBorder) Then
					strDispPercent_L = "<B>" & strDispPercent_L & "</B>"
					blnBoldMode = True
				End If 

				If cDbl(vntPercent_H(i)) >= cDbl(lngBorder) Then
					strDispPercent_H = "<B>" & strDispPercent_H & "</B>"
					blnBoldMode = True
				End If 

				If blnBoldMode = True Then
					strDispItemCd      = "<B>" & strDispItemCd & "</B>"
					strDispItemName    = "<B>" & strDispItemName & "</B>"
					strDispGenderName  = "<B>" & strDispGenderName & "</B>"
				Else
					strDispItemCd      = "<FONT COLOR=""#999999"">" & strDispItemCd & "</FONT>"
					strDispItemName    = "<FONT COLOR=""#999999"">" & strDispItemName & "</FONT>"
					strDispGenderName  = "<FONT COLOR=""#999999"">" & strDispGenderName & "</FONT>"
				End If

			End If

%>
			<TR HEIGHT="18" BGCOLOR="#eeeeee">
				<TD NOWRAP><%= strDispItemCd %></TD>
				<TD NOWRAP><%= strDispItemName %></TD>
				<TD NOWRAP><%= strDispGenderName %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= vntResultCount(i) %></TD>
				<TD BGCOLOR="#FFFFFF"></TD>
				<TD NOWRAP ALIGN="RIGHT" BGCOLOR="#E6E6FA"><%= vntVal_L(i) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= vntVal_S(i) %></TD>
				<TD NOWRAP ALIGN="RIGHT" BGCOLOR="#FFC0CB"><%= vntVal_H(i) %></TD>
				<TD BGCOLOR="#FFFFFF"></TD>
				<TD NOWRAP ALIGN="RIGHT" BGCOLOR="#E6E6FA"><%= strDispPercent_L %></TD>
				<TD NOWRAP ALIGN="RIGHT" BGCOLOR="#FFC0CB"><%= strDispPercent_H %></TD>
			</TR>
<%

			lngPrevSeq = vntSeq(i)

		Next

	End If
%>
</TABLE>
		<BR>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>