<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		�Ǝ˘^ (Ver0.0.1)
'		AUTHER  : (NSC)birukawa
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode				'������[�h
Dim vntMessage			'�ʒm���b�Z�[�W

'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon								'���ʃN���X
Dim objOrganization							'�c�̏��A�N�Z�X�p
Dim objOrgBsd								'���ƕ����A�N�Z�X�p
Dim objOrgRoom								'�������A�N�Z�X�p
Dim objOrgPost								'�������A�N�Z�X�p
Dim objPerson								'�l���A�N�Z�X�p
Dim objReport								'���[���A�N�Z�X�p

Dim strOutPutCls							'�o�͑Ώ�
'�p�����[�^�l
Dim strSCslYear, strSCslMonth, strSCslDay				'�J�n�N����
Dim strECslYear, strECslMonth, strECslDay				'�I���N����
Dim strSDayId								'�J�n����ID
Dim strEDayId								'�I������ID
Dim strParts								'�Ǝ˕��@
Dim strLID								'���O�C��ID
Dim strUID								'���[�UID

Dim strReportOutDate							'�o�͓�

'��Ɨp�ϐ�
Dim strSCslDate								'�J�n��
Dim strECslDate								'�I����

'���[���
Dim strArrReportCd							'���[�R�[�h
Dim strArrReportName							'���[��
Dim strArrHistoryPrint							'�ߋ������
Dim lngReportCount							'���R�[�h��

Dim i									'���[�v�C���f�b�N�X
Dim j									'���[�v�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'���ʈ����l�̎擾
strMode = Request("mode")

'���[�o�͏�������
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : URL�����l�̎擾
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : URL�̈����l���擾���鏈�����L�q���ĉ�����
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

'�� �J�n�N����
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'�J�n�N
		strSCslMonth  = Month(Now())				'�J�n��
		strSCslDay    = Day(Now())				'�J�n��
	Else
		strSCslYear   = Request("strCslYear")			'�J�n�N
		strSCslMonth  = Request("strCslMonth")			'�J�n��
		strSCslDay    = Request("strCslDay")			'�J�n��
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = Year(Now())				'�I���N
		strECslMonth  = Month(Now())				'�J�n��
		strECslDay    = Day(Now())				'�J�n��
	Else
		strECslYear   = Request("endCslYear")			'�I���N
		strECslMonth  = Request("endCslMonth")			'�J�n��
		strECslDay    = Request("endCslDay")			'�J�n��
	End If
	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'�� �J�n�N�����ƏI���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
	   Right("00" & Trim(CStr(strSCslDay)), 2) _
	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
	   Right("00" & Trim(CStr(strECslDay)), 2) Then
		strSCslYear   = strECslYear
		strSCslMonth  = strECslMonth
		strSCslDay    = strECslDay
		strSCslDate   = strECslDate
		strECslYear   = Request("strCslYear")			'�J�n�N
		strECslMonth  = Request("strCslMonth")			'�J�n��
		strECslDay    = Request("strCslDay")			'�J�n��
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	End If

'�� �J�n�����h�c
	strSDayId	= Request("SDayId")
	
'�� �I�������h�c
	strEDayId	= Request("EDayId")

'�� �Ǝ˕��@
	strParts	= Request("Parts")
     
'�� ���O�C���h�c
	strLID          = Request("LoginId")

'�� ���[�UID
	strUID          = Session("USERID")
	

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

	'�����Ƀ`�F�b�N�������L�q
	With objCommon
'��)		.AppendArray vntArrMessage, �R�����g
		If strMode <> "" Then
			'��f���`�F�b�N
			If Not IsDate(strSCslDate) Then
				.AppendArray vntArrMessage, "�J�n���t������������܂���B"
			End If
			If Not IsDate(strECslDate) Then
				.AppendArray vntArrMessage, "�I�����t������������܂���B"
			End If
      
		End If
    
	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���[�h�L�������g�t�@�C���쐬����
'
' �����@�@ :
'
' �߂�l�@ : ������O���̃V�[�P���X�l
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objPrintCls
	Dim objCommon	'���ʃN���X
	Dim Ret			'�֐��߂�l

	If Not IsArray(CheckValue()) Then

		'���R�����΍��p���O�����o��
		Call putPrivacyInfoLog("PH037", "�Ǝ˘^�̈�����s����")

		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
		Set objPrintCls = Server.CreateObject("HainsprtXrecord.prtXrecord")
		
		'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
		Ret = objPrintCls.PrintOut(strSCslDate, strECslDate, strSDayID, strEDayID, strParts, strUID, strLID)

		print = Ret
		
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Microsoft FrontPage 4.0">
<TITLE>�Ǝ˘^</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̉�ʕ\��
function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {
	// �c�̏��G�������g�̎Q�Ɛݒ�
	orgPostGuide_getElement( Cd1, Cd2, CtrlName );
	// ��ʕ\��
	orgPostGuide_showGuideOrg();
}
// �c�̏��폜
function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {
	// �c�̏��G�������g�̎Q�Ɛݒ�
	orgPostGuide_getElement( Cd1, Cd2, CtrlName );
	// �폜
	orgPostGuide_clearOrgInfo();
}
// submit���̏���
function submitForm() {
	document.entryForm.submit();
}
//function selectHistoryPrint( index ) {
//	document.entryForm.historyPrint.value = document.historyPrintForm.historyPrint[ index ].value;
//}
-->
</SCRIPT>
<STYLE TYPE="text/css">
<!--
td.prttab { background-color:#ffffff }
-->
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">���Ǝ˘^</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>
	<!--- ���t -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>��</TD>
			<TD>�`</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>
	
	<table border="0" cellpadding="1" cellspacing="2">
		<tr>
			<TD>��</TD>
			<td width="90" nowrap>�J�n����ID</td>
			<td>�F</td>
			<td><input type="text" name="SDayId" size="20" value="" maxlength="10"> </td>
		</tr>
		<tr>
			<TD>��</TD>
			<td width="90" nowrap>�I������ID</td>
			<td>�F</td>
			<td><input type="text" name="EDayId" size="20" value="" maxlength="10"></td>
		</tr>
	</table>
	<table border="0" cellpadding="1" cellspacing="2">
		<tr>
			<td><font color="#ff0000">��</font></td>
			<td width="92" nowrap>�Ǝ˕��@</td>
			<td>�F</td>
			<td><select name="Parts" size="1">
					<option selected value="0">�S��</option>
					<option value="1">�ݓ���</option>
					<option value="2">����</option>
					<option value="3">����CT</option>
					<option value="4">���[</option>
					<option value="5">�����x</option>
				</select></td>
			<td></td>
		</tr>
	</table>
	<table border="0" cellpadding="1" cellspacing="2">
		<tr>
			<td>��</td>
			<td width="92" nowrap>���O�C��ID</td>
			<td>�F</td>
			<td><input type="text" name="LoginId" size="20" value="" maxlength="10"></td>
		</tr>
	</table>
	<p><!--- ������[�h --><BR>
<%
	'������[�h�̏����ݒ�
	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
    <INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--
		<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
		<TD NOWRAP>�v���r���[</TD>

		<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
		<TD NOWRAP>���ڏo��</TD>
		</TR>
-->
	</TABLE>
	
	
	
	<BR>
	<!--- ����{�^�� -->
	<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>	
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������"></p>
	<%  End if  %>

	</BLOCKQUOTE>



</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>