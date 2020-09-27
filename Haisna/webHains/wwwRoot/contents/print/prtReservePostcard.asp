<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	��f�ΏێҖ��� (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode			'������[�h
Dim vntMessage		'�ʒm���b�Z�[�W
Dim strURL			'URL
Dim UID
'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objOrganization	'�c�̏��A�N�Z�X�p
Dim objOrgBsd		'���ƕ����A�N�Z�X�p
Dim objOrgRoom		'�������A�N�Z�X�p
Dim objOrgPost		'�������A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'�����l
Dim strSCslYear, strSCslMonth, strSCslDay	'�J�n�N����
Dim strECslYear, strECslMonth, strECslDay	'�I���N����
Dim strCsCd									'�R�[�X�R�[�h
'Dim strSCsCd								'�T�u�R�[�X�R�[�h
Dim strOrgCd1, strOrgCd2					'�c�̃R�[�h
Dim strOrgBsdCd, strOrgRoomCd				'���ƕ��R�[�h, �����R�[�h
Dim strSOrgPostCd, strEOrgPostCd			'�J�n�����R�[�h, �I�������R�[�h
Dim strPerId								'�l�R�[�h
'Dim strReceiptNo							'��t�ԍ�
Dim strObject								'�o�͑Ώ�
'Dim strZipCd1, strZipCd2					'�X�֔ԍ�(4, 3)
'��������������������

'��Ɨp�ϐ�
Dim strOrgName		'�c�̖�
Dim strBsdName		'���ƕ���
Dim strRoomName		'������
Dim strSPostName	'�J�n������
Dim strEPostName	'�I��������
Dim strLastName		'��
Dim strFirstName	'��
Dim strPerName		'����
Dim strSCslDate		'�J�n��
Dim strECslDate		'�I����

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
'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
	'���ʓ��̕������HTML���ŋL�q�������ڂ̖��̂ƂȂ�܂�

'�� �J�n�N����
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'�J�n�N
		strSCslMonth  = Month(Now())			'�J�n��
		strSCslDay    = Day(Now())				'�J�n��
	Else
		strSCslYear   = Request("strCslYear")	'�J�n�N
		strSCslMonth  = Request("strCslMonth")	'�J�n��
		strSCslDay    = Request("strCslDay")	'�J�n��
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = Year(Now())				'�I���N
		strECslMonth  = Month(Now())			'�J�n��
		strECslDay    = Day(Now())				'�J�n��
	Else
		strECslYear   = Request("endCslYear")	'�I���N
		strECslMonth  = Request("endCslMonth")	'�J�n��
		strECslDay    = Request("endCslDay")	'�J�n��
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
		strECslYear   = Request("strCslYear")	'�J�n�N
		strECslMonth  = Request("strCslMonth")	'�J�n��
		strECslDay    = Request("strCslDay")	'�J�n��
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	End If

	strCsCd       = Request("csCd")			'�R�[�X�R�[�h
'	strSCsCd      = Request("scsCd")		'�T�u�R�[�X�R�[�h

'�� �c��
	strOrgCd1     = Request("orgCd1")		'�c�̃R�[�h�P
	strOrgCd2     = Request("orgCd2")		'�c�̃R�[�h�Q
     strOrgName   = Request("strOrgName")
	If strOrgCd1 <> "" And strOrgCd2 <> "" Then
'## 2004/1/2 Upd Start (NSC)birukawa ���\�b�h���ύX
'		objOrganization.SelectlukeOrg strOrgCd1, strOrgCd2 , strOrgName
		objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2 , strOrgName
'## 2004/1/2 Upd End   (NSC)birukawa ���\�b�h���ύX
	End If
'�� ���ƕ�
'�� ����
'�� ����
UID = Session("USERID")
	strPerId      = Request("perId")		'�l�R�[�h
	If strPerId <> "" Then
		objPerson.SelectlukePerson strPerId, strLastName, strFirstName
		strPerName = Trim(strLastName) & "�@" & Trim(strFirstName)
	End If
'��������������������
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

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
	'�����Ƀ`�F�b�N�������L�q
	With objCommon
'��)		.AppendArray vntArrMessage, �R�����g

		If strMode <> "" Then
			If Not IsDate(strSCslDate) Then
				.AppendArray vntArrMessage, "�J�n���t������������܂���B"
			End If

			If Not IsDate(strECslDate) Then
				.AppendArray vntArrMessage, "�I�����t������������܂���B"
			End If
		End If

	End With
'��������������������

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
' ���l�@�@ : ���[�h�L�������g�t�@�C���쐬���\�b�h���Ăяo���B���\�b�h���ł͎��̏������s����B
' �@�@�@�@   ?@������O���̍쐬
' �@�@�@�@   ?A���[�h�L�������g�t�@�C���̍쐬
' �@�@�@�@   ?B�����������͈�����O��񃌃R�[�h�̎�L�[�ł���v�����gSEQ��߂�l�Ƃ��ĕԂ��B
' �@�@�@�@   ����SEQ�l�����Ɉȍ~�̃n���h�����O���s���B
'
'-------------------------------------------------------------------------------
Function Print()
     Dim objCommon	'���ʃN���X
	Dim objPrintCls	'�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
	Dim Ret			'�֐��߂�l

	If Not IsArray(CheckValue()) Then

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
'		Set objPrintCls = Server.CreateObject("HainsCslSheet.CslSheet")
'			'�v���W�F�N�g���̓\�[�X���J���Ċm�F�B
'		'�c�̈ꗗ�\�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
'		Ret = objPrintCls.PrintCslSheet(Session("USERID"), ,cdate(strSCslDate), cdate(strECslDate),strCsCd, strOrgCd1, strOrgCd2, _
'		                                strOrgBsdCd, strOrgRoomCd, strSOrgPostCd, strEOrgPostCd, strPerId, cint(strObject) )
'��������������������
'
'		Print = Ret

Set objCommon = Server.CreateObject("HainsCommon.Common")
strURL = "/webHains/contents/report_form/rd_02_prtReservePostCard.asp"
'## 2004/1/2 UPD Start (NSC)birukawa UID���܂߂�i����URL�̃p�����[�^���Łu?�v�������Ă���j
'strURL = strURL & "?p_Uid=" & UID
strURL = strURL & "?p_Uid=" & UID
'## 2004/1/2 UPD Start (NSC)birukawa UID���܂߂�i����URL�̃p�����[�^���Łu?�v�������Ă���j
strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
Set objCommon = Nothing
strURL = strURL & "&p_CSCD=" & strCsCd 
strURL = strURL & "&p_Org1=" & strOrgCd1
strURL = strURL & "&p_Org2=" & strOrgCd2
strURL = strURL & "&p_PERID=" & strPerId
Response.Redirect strURL
Response.End

	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--- �� ��<Title>�̏C����Y��Ȃ��悤�� �� -->
<TITLE>�\��m�F�͂���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.entryForm ) {

		// �c�́E�������G�������g�̎Q�Ɛݒ�i���͍��ڂɒc�́E�����������ꍇ�͕s�v�j
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName' );

		// �l���G�������g�̎Q�Ɛݒ�i���͍��ڂɌl��񂪖����Ƃ��͕s�v�j
		orgPostGuide_getPerElement( perId, 'perName' );

	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

<!--- �^�C�g�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�\��m�F�͂���</FONT></B></TD>
		</TR>
	</TABLE>
<%
'�G���[���b�Z�[�W�\��

'	Dim strArrMessage
'	strArrMessage = CheckValue()
'	if IsArray(strArrMessage) Then
'		Response.Write "<BR>" & vblf
'		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
'	End If
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
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

<!--- �R�[�X -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>

<!--- �c�� -->
	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<% = strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<% = strOrgCd2 %>">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="orgName"><% = strorgName %></SPAN></TD>
		</TR>
	</TABLE>

<!--- �]�ƈ� -->
     <INPUT TYPE="hidden" NAME="perId" VALUE="<% = strPerId %>">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�lID</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuidePersonal()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearAllPerInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="perName"><% = strPerName %></SPAN></TD>
		</TR>
	</TABLE>

<!--- �o�͑Ώ� --><BR>
<!--- ������[�h -->
<%
	'������[�h�̏����ݒ�
	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<!--  2003/02/27  START  START  E.Yamamoto  -->
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/02/27  START  END    E.Yamamoto  -->
<!--  2003/02/27  DEL  START  E.Yamamoto  -->
<!--
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
			<TD NOWRAP>�v���r���[</TD>

			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
			<TD NOWRAP>���ڏo��</TD>
		</TR>
-->
<!--  2003/02/27  DEL  END    E.Yamamoto  -->
	</TABLE>

	<BR><BR>

<!--- ����{�^�� -->
	<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">
	<%  End if  %>

	</BLOCKQUOTE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>