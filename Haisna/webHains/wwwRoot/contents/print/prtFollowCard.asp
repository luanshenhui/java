<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	FailSafe����p (Ver0.0.1)
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
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode		'������[�h
Dim vntMessage		'�ʒm���b�Z�[�W
Dim strURL		'URL
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
Dim objPrtFollowCard	'�t�H���[�A�b�v�͂����A�N�Z�X�p

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'�����l
Dim strSCslYear, strSCslMonth, strSCslDay	'�J�n�N����
Dim strECslYear, strECslMonth, strECslDay	'�I���N����
Dim strSSecYear, strSSecMonth, strSSecDay	'�J�n�񎟌����N����
Dim strESecYear, strESecMonth, strESecDay	'�I���񎟌����N����
Dim strSecKbn     				'���������񎟓��t���O(1:���\��)
Dim strCsCd					'�R�[�X�R�[�h
'Dim strSCsCd					'�T�u�R�[�X�R�[�h
Dim strOrgCd1, strOrgCd2			'�c�̃R�[�h
Dim strOrgBsdCd, strOrgRoomCd			'���ƕ��R�[�h, �����R�[�h
Dim strSOrgPostCd, strEOrgPostCd		'�J�n�����R�[�h, �I�������R�[�h
Dim strPerId					'�l�R�[�h
'Dim strReceiptNo				'��t�ԍ�
'Dim strZipCd1, strZipCd2			'�X�֔ԍ�(4, 3)
Dim  prinmode 
'��������������������

'��Ɨp�ϐ�
Dim strKey              	'�����L�[
Dim lngArrMailMode()		'�͂��������Ԃ̔z��
Dim strArrMailModeName()	'�͂��������Ԗ��̔z��

Dim lngMailMode			'�͂��������Ԃ̌��ݒl

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
Dim strSSecDate		'�J�n�񎟌�����
Dim strESecDate		'�I���񎟌�����
Dim prinh
Dim prinhh
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

Call CreateMailInfo()

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
		strSCslYear   = Year(Now())		'�J�n�N
		strSCslMonth  = Month(Now())		'�J�n��
		strSCslDay    = Day(Now())		'�J�n��
	Else
		strSCslYear   = Request("strCslYear")	'�J�n�N
		strSCslMonth  = Request("strCslMonth")	'�J�n��
		strSCslDay    = Request("strCslDay")	'�J�n��
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = strSCslYear		'�I���N
		strECslMonth  = strSCslMonth		'�J�n��
		strECslDay    = strSCslDay		'�J�n��
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
'�� �J�n�񎟌����N����
	strSSecYear   = Request("strSecYear")	'�J�n�񎟌����N
	strSSecMonth  = Request("strSecMonth")	'�J�n�񎟌�����
	strSSecDay    = Request("strSecDay")	'�J�n�񎟌�����
	If Request("strSecYear") = "" Then
		strSSecDate   = CDate("0")
	Else
		strSSecDate   = strSSecYear & "/" & strSSecMonth & "/" & strSSecDay
	End If
'�� �I���񎟌����N����
	strESecYear   = Request("endSecYear")	'�I���񎟌����N
	strESecMonth  = Request("endSecMonth")	'�I���񎟌�����
	strESecDay    = Request("endSecDay")	'�I���񎟌�����
	If Request("endSecYear") = "" Then
		strESecDate   = CDate(strSSecDate)
	Else
		strESecDate   = strESecYear & "/" & strESecMonth & "/" & strESecDay
	End If
'�� �񎟌����t���O
	If Request("secKbn") = "" Then
		strSecKbn     = "0"			'�񎟌����t���O
	Else
		strSecKbn     = Request("secKbn")	'�񎟌����t���O
	End If
'�� �R�[�X�R�[�h
	strCsCd       = Request("csCd")
'�� �c�̃R�[�h
	strOrgCd1     = Request("orgCd1")
	strOrgCd2     = Request("orgCd2")
'�� �l�h�c
	strPerId      = Request("perId")
'�� �͂����敪
	lngMailMode   = Request("mailMode")
 
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
	Dim Flg
	
'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
	'�����Ƀ`�F�b�N�������L�q
	With objCommon
'��)		.AppendArray vntArrMessage, �R�����g

		If Not IsDate(strSCslDate) Then
			.AppendArray vntArrMessage, "�J�n���t������������܂���B"
		End If

		If Not IsDate(strECslDate) Then
			.AppendArray vntArrMessage, "�I�����t������������܂���B"
		End If

		If strSSecDate <> "0" Then
			If Not IsDate(strSSecDate) Then
				.AppendArray vntArrMessage, "�J�n�񎟌������t������������܂���B"
			End If
		End If

		If strESecDate <> "0" Then
			If Not IsDate(strESecDate) Then
				.AppendArray vntArrMessage, "�I���񎟌������t������������܂���B"
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

	Dim objPrintCls	
	Dim Ret			'�֐��߂�l

	If Not IsArray(CheckValue()) Then

		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j	
		Set objPrintCls = Server.CreateObject("HainsprtFollowCard.prtFollowCard")

		'��f�Ґ��ɂ��ăh�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
		Ret = objPrintCls.PrintOut( _
					   Session("USERID"), _
					   strSCslDate, strECslDate, _
					   strSSecDate, strESecDate, _
					   strSecKbn,   strCsCd, _
					   strOrgCd1,   strOrgCd2, _
					   strPerId,    lngMailMode _
					  ) 

	

		Print = Ret

	End If

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �P�y�[�W�\���l�`�w�s�̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateMailInfo()

	Redim Preserve lngArrMailMode(2)
	Redim Preserve strArrMailModeName(2)

	lngArrMailMode(0)     = 0
	strArrMailModeName(0) = "�S��"

	lngArrMailMode(1)     = 1
	strArrMailModeName(1) = "�o�͍ς݂̂�"

	lngArrMailMode(2)     = 2
	strArrMailModeName(2) = "���o�͂̂�"

End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--- �� ��<Title>�̏C����Y��Ȃ��悤�� �� -->
<TITLE>�t�H���[�A�b�v�͂�������p</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �`�F�b�N�{�b�N�X�̒l����
function checkClick(selObj) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	if (selObj.checked) {
		selObj.value = '1'
	} else {
		selObj.value = '0'
	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY >

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">  
	<BLOCKQUOTE>

<!--- �^�C�g�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><Font color="#0000FF">���t�H���[�A�b�v�͂�������p</font></TD>
		</TR>
	</TABLE>
<%
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>

	<BR>

<!--- ���t -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
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
			</TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�񎟌�����f��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strSecYear', 'strSecMonth', 'strSecDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:calGuide_clearDate('strSecYear', 'strSecMonth', 'strSecDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD><%= EditSelectNumberList("strSecYear", YEARRANGE_MIN, YEARRANGE_MAX, strSSecYear) %></TD>
						<TD>�N</TD>
						<TD><%= EditSelectNumberList("strSecMonth", 1, 12, strSSecMonth) %></TD>
						<TD>��</TD>
						<TD><%= EditSelectNumberList("strSecDay", 1, 31, strSSecDay) %></TD>
						<TD>��</TD>

						<TD>�`</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endSecYear', 'endSecMonth', 'endSecDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:calGuide_clearDate('endSecYear', 'endSecMonth', 'endSecDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
						<TD><%= EditSelectNumberList("endSecYear", YEARRANGE_MIN, YEARRANGE_MAX, strESecYear) %></TD>
						<TD>�N</TD>
						<TD><%= EditSelectNumberList("endSecMonth", 1, 12, strESecMonth) %></TD>
						<TD>��</TD>
						<TD><%= EditSelectNumberList("endSecDay", 1, 31, strESecDay) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD NOWRAP>���\���</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="checkbox" NAME="secKbn" VALUE="<%=strSecKbn%>" <%= IIf(strSecKbn = "1", " CHECKED","") %> ONCLICK="javascript:checkClick(this)">�񎟌��f�\�񂵂Ă��Ȃ�����f�҂��ΏۂƂ���B</TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD NOWRAP>�R�[�X</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD>�c��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="�c�̌����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
						<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
						<TD WIDTH="5"></TD>
						<TD>
							<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
							<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
							<INPUT TYPE="hidden" NAME="txtorgName" VALUE="<%= strOrgName %>">
							<SPAN ID="orgName"><%= strOrgName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD>�lID</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryForm.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
						<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryForm.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
						<TD WIDTH="5"></TD>
						<TD>
							<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strKey %>">
							<INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
							<SPAN ID="perName"><%= strPerName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>��</TD>
			<TD>�͂���</TD>
			<TD>�F</TD>
			<TD><%= EditDropDownListFromArray("mailMode", lngArrMailMode, strArrMailModeName, lngMailMode, NON_SELECTED_DEL) %>�@</TD>
		</TR>
	</TABLE>
	<p><BR>
		<!--- ������[�h --></p>
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
--><!--  2003/02/27  DEL  END    E.Yamamoto  -->
				</TABLE>
				<BR><BR>

<!--- ����{�^�� -->
	<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">&nbsp;
	<%  End if  %>

	<INPUT TYPE="hidden" NAME="mode" VALUE="0"> 

	</BLOCKQUOTE>
<!--
<%= strSCslDate %>
<BR>
<%= strECslDate %>
<BR>
-->
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>