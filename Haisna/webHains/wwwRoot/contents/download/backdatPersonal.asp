<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�l���̒��o (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/download.inc" -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode				'�������[�h(���o���s:"edit")

'��������
Dim strCase				'���o����(�w����Ԃ̎�f��:"csl"�A�X�֔ԍ�:"zip")
'���Ԏw�莞�̏��
Dim strStrDate			'��f�N����(��)
Dim lngStrYear			'��f�N(��)
Dim lngStrMonth			'��f��(��)
Dim lngStrDay			'��f��(��)
Dim strEndDate			'��f�N����(��)
Dim lngEndYear			'��f�N(��)
Dim lngEndMonth			'��f��(��)
Dim lngEndDay			'��f��(��)
Dim strCsCd				'�R�[�X�R�[�h
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgSName			'�c�̗���
Dim strStrAge			'��f��(��)�N��
Dim strStrAgeY			'��f��(��)�N��(�N)
Dim strStrAgeM			'��f��(��)�N��(��)
Dim strEndAge			'��f��(��)�N��
Dim strEndAgeY			'��f��(��)�N��(�N)
Dim strEndAgeM			'��f��(��)�N��(��)
Dim lngGender			'����
'�X�֔ԍ��w�莞�̏��
Dim strZipCd1			'�X�֔ԍ��P
Dim strZipCd2			'�X�֔ԍ��Q

'����p
Dim objOrganization		'�c�̃e�[�u���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objPerson			'�l���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim CsvobjPerson		'�l���A�N�Z�X�pCOM�I�u�W�F�N�g

Dim strFileName			'�o��CSV�t�@�C����
Dim strDownloadFile		'�_�E�����[�h�t�@�C���p�X
Dim strArrMessage		'�G���[���b�Z�[�W
Dim lngMessageStatus	'���b�Z�[�W�X�e�[�^�X(MessageType:NORMAL or WARNING)
Dim lngCount			'�o�̓f�[�^����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------

'CSV�t�@�C���i�[�p�X�ݒ�
strDownloadFile = CSV_DATAPATH & CSV_PERSONAL		'�_�E�����[�h�t�@�C�����Z�b�g
strFileName     = Server.MapPath(strDownloadFile)	'CSV�t�@�C�����Z�b�g

strMode         = Request("mode"   ) & ""			'�������[�h�̎擾

'�����l�̎擾
If strMode = "" Then
	'�����\��
	strCase     = ""
	lngStrYear  = Year(Now())
	lngStrMonth = Month(Now())
	lngStrDay   = Day(Now())
	lngEndYear  = Year(Now())
	lngEndMonth = Month(Now())
	lngEndDay   = Day(Now())
	strCsCd     = ""
	strOrgCd1   = ""
	strOrgCd2   = ""
	strOrgSName = ""
	strStrAgeY  = "0"
	strStrAgeM  = ""
	strEndAgeY  = "150"
	strEndAgeM  = ""
	lngGender   = GENDER_BOTH
	strZipCd1   = ""
	strZipCd2   = ""
Else
	'�ĕ\��
	strCase     = Request("case"   ) & ""
	lngStrYear  = CLng("0" & Request("strYear" ))
	lngStrMonth = CLng("0" & Request("strMonth"))
	lngStrDay   = CLng("0" & Request("strDay"  ))
	lngEndYear  = CLng("0" & Request("endYear" ))
	lngEndMonth = CLng("0" & Request("endMonth"))
	lngEndDay   = CLng("0" & Request("endDay"  ))
	strCsCd     = Request("csCd"   ) & ""
	strOrgCd1   = Request("orgCd1" ) & ""
	strOrgCd2   = Request("orgCd2" ) & ""
	strStrAgeY  = Request("strAgeY") & ""
	strStrAgeM  = Request("strAgeM") & ""
	strEndAgeY  = Request("endAgeY") & ""
	strEndAgeM  = Request("endAgeM") & ""
	lngGender   = CLng("0" & Request("gender"  ))
	strZipCd1   = Request("zipCd1" ) & ""
	strZipCd2   = Request("zipCd2" ) & ""
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objPerson       = Server.CreateObject("HainsPerson.Person")
Set CsvobjPerson       = Server.CreateObject("HainsCsvPerson.CsvPerson")

'�c�̗��̂̍Ď擾
If Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" Then
	Call objOrganization.SelectOrgSName(strOrgCd1, strOrgCd2, strOrgSName)
End If

'�`�F�b�N�ECSV�t�@�C���ҏW�����̐���
Do

	'�u���o���������s�v������
	If strMode = "edit" Then

		'���̓`�F�b�N
		strArrMessage = objPerson.CheckValueDatPerson(strCase, _
													  lngStrYear, lngStrMonth, lngStrDay, _
													  lngEndYear, lngEndMonth, lngEndDay, _
													  strStrAgeY, strStrAgeM, _
													  strEndAgeY, strEndAgeM, _
													  strZipCd1, _
													  strStrDate, strEndDate, _
													  strStrAge,  strEndAge _
													 )

		'�`�F�b�N�G���[���͏����𔲂���
		If Not IsEmpty(strArrMessage) Then
			lngMessageStatus = MESSAGETYPE_WARNING
			Exit Do
		End If

		'CSV�t�@�C���̕ҏW
		lngCount = CsvobjPerson.EditCSVDatPerson(strFileName, _
											  strCase, strStrDate, strEndDate, _
											  strCsCd, strOrgCd1, strOrgCd2, _
											  strStrAge, strEndAge, lngGender, _
											  strZipCd1, strZipCd2 _
											 )

		'�f�[�^������΃_�E�����[�h�A������΃��b�Z�[�W���Z�b�g
		If lngCount > 0 Then
'			Response.Redirect strDownloadFile
			Response.ContentType = "application/x-download"
			Response.AddHeader "Content-Type", "text/csv;charset=Shift_JIS"
			Response.AddHeader "Content-Disposition","filename=" & CSV_PERSONAL
			Server.Execute strDownloadFile
			Response.End
		Else
			ReDim strArrMessage(0)
			strArrMessage(0) = "�w��̃f�[�^�͂���܂���ł����B"
			lngMessageStatus = MESSAGETYPE_NORMAL
		End If

	End If

	Exit Do
Loop

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l���̒��o</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/zipGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̃K�C�h�Ăяo��
function callOrgGuide() {

	orgGuide_showGuideOrg(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');

}

// �c�̃R�[�h�E���̂̃N���A
function clearOrgCd() {

	orgGuide_clearOrgInfo(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');

}

// �X�֔ԍ��K�C�h�Ăяo��
function callZipGuide() {

	var objForm = document.entryCondition;	// ����ʂ̃t�H�[���G�������g

	zipGuide_showGuideZip( '', objForm.zipCd1, objForm.zipCd2 );

}

// �X�֔ԍ��̃N���A
function clearZipInfo() {

	var objForm = document.entryCondition;	// ����ʂ̃t�H�[���G�������g

	zipGuide_clearZipInfo( objForm.zipCd1, objForm.zipCd2 );

}

// �ĕ\��
function redirectPage( actionmode ) {

	document.entryCondition.mode.value = actionmode;		/* ���샂�[�h�ݒ� */
	document.entryCondition.submit();						/* ���g�֑��M */

	return false;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg();zipGuide_closeGuideZip()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">��</SPAN><FONT COLOR="#000000">�l���̒��o</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Call EditMessage(strArrMessage, lngMessageStatus)
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><INPUT TYPE="radio" NAME="case" VALUE="csl" <%= IIf(strCase = "csl", "CHECKED", "") %>></TD>
			<TD COLSPAN="3">�w����Ԃ̎�f�҂Œ��o</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<%= EditSelectYearList(YEARS_SYSTEM, "strYear", lngStrYear) %>�N
							<%= EditSelectNumberList("strMonth", 1, 12, lngStrMonth) %>��
							<%= EditSelectNumberList("strDay"  , 1, 31, lngStrDay  ) %>���`
							<%= EditSelectYearList(YEARS_SYSTEM, "endYear", lngEndYear) %>�N
							<%= EditSelectNumberList("endMonth", 1, 12, lngEndMonth) %>��
							<%= EditSelectNumberList("endDay"  , 1, 31, lngEndDay  ) %>��
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>�R�[�X</TD>
			<TD>�F</TD>
			<TD>
				<%= EditCourseList("csCd", strCsCd, SELECTED_ALL) %>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>�c��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return clearOrgCd()"  ><IMG SRC="../../images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"  ></A></TD>
						<TD WIDTH="5"></TD>
						<TD WIDTH="300">
							<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
							<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
							<SPAN ID="orgname"><%= strOrgSName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>��f���N��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><%= EditSelectNumberList("strAgeY", 0, 150, CLng(IIf(strStrAgeY = "", "-1", strStrAgeY))) %></TD>
						<TD>�D</TD>
						<TD><%= EditSelectNumberList("strAgeM", 0,  11, CLng(IIf(strStrAgeM = "", "-1", strStrAgeM))) %></TD>
						<TD>�Έȏ�</TD>
						<TD><%= EditSelectNumberList("endAgeY", 0, 150, CLng(IIf(strEndAgeY = "", "-1", strEndAgeY))) %></TD>
						<TD>�D</TD>
						<TD><%= EditSelectNumberList("endAgeM", 0,  11, CLng(IIf(strEndAgeM = "", "-1", strEndAgeM))) %></TD>
						<TD>�Έȉ�</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>����</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<%= EditGenderList("gender", CStr(lngGender), NON_SELECTED_DEL) %>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="case" VALUE="zip" <%= IIf(strCase = "zip", "CHECKED", "") %>></TD>
			<TD COLSPAN="3">�X�֔ԍ��Œ��o</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><A HREF="javascript:callZipGuide()">�X�֔ԍ�</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="zipCd1" VALUE="<%= strZipCd1 %>" SIZE="3" MAXLENGTH="3">�|<INPUT TYPE="text" NAME="zipCd2" VALUE="<%= strZipCd2 %>" SIZE="4" MAXLENGTH="4"></TD>
		</TR>
	</TABLE>

	<BR>

	<A HREF="javascript:function voi(){};voi()" ONCLICK="return redirectPage('edit')"><IMG SRC="/webHains/images/DataSelect.gif"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
