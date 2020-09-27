<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�������̒��o (Ver0.0.1)
'		AUTHER  : ishihara@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/download.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode				'�������[�h(���o���s:"edit")

'����p
Dim objDemand			'�c�̃e�[�u���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim strFileName			'�o��CSV�t�@�C����
Dim strDownloadFile		'�_�E�����[�h�t�@�C����
Dim strArrMessage		'�G���[���b�Z�[�W(�S��)
Dim lngMessageStatus	'���b�Z�[�W�X�e�[�^�X(MessageType:NORMAL or WARNING)
Dim lngCount			'�o�̓f�[�^����

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
Dim strOrgName			'�c�̖���
Dim strSelectMode		'�f�[�^���o���[�h

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------

'CSV�t�@�C���i�[�p�X�ݒ�
strDownloadFile   = CSV_DATAPATH & CSV_DEMAND			'�_�E�����[�h�t�@�C�����Z�b�g
strFileName       = Server.MapPath(strDownloadFile)		'CSV�t�@�C�����Z�b�g

strMode           = Request("mode") & ""				'�������[�h�̎擾

'�����l�̎擾
If strMode = "" Then
	'�����\��
	lngStrYear  = Year(Now())
	lngStrMonth = Month(Now())
	lngStrDay   = Day(Now())
	lngEndYear  = Year(Now())
	lngEndMonth = Month(Now())
	lngEndDay   = Day(Now())
	strCsCd     = ""
	strOrgCd1   = ""
	strOrgCd2   = ""
	strOrgName = ""
	strSelectMode = ""
Else
	'�ĕ\��
	lngStrYear  = CLng("0" & Request("strYear" ))
	lngStrMonth = CLng("0" & Request("strMonth"))
	lngStrDay   = CLng("0" & Request("strDay"  ))
	lngEndYear  = CLng("0" & Request("endYear" ))
	lngEndMonth = CLng("0" & Request("endMonth"))
	lngEndDay   = CLng("0" & Request("endDay"  ))
	strCsCd     = Request("csCd"   ) & ""
	strOrgCd1   = Request("orgCd1" ) & ""
	strOrgCd2   = Request("orgCd2" ) & ""
	strSelectMode = Request("SelectMode" ) & ""
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objDemand = Server.CreateObject("HainsDemand.Demand")

'CSV�t�@�C���ҏW�����̐���
Do

	'�u���o���������s�v������
	If strMode = "edit" Then

		strStrDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
		strEndDate = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay

		If IsDate(strStrDate) = False Then
			ReDim strArrMessage(0)
			strArrMessage(0) = "�������J�n���t���w�肵�Ă��������B"
			lngMessageStatus = MESSAGETYPE_WARNING
			Exit Do
		End If

		If IsDate(strEndDate) = False Then
			strEndDate = strStrDate
		End If

		'CSV�t�@�C���̕ҏW
		lngCount = objDemand.SelectDmdCSVList(strFileName, strStrDate, strEndDate , strCsCd, strOrgCd1, strOrgCd2, strSelectMode)

		'�f�[�^������΃_�E�����[�h�A������΃��b�Z�[�W���Z�b�g
		If lngCount > 0 Then
			Response.Redirect strDownloadFile
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
<TITLE>�������̒��o</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �ĕ\��
function redirectPage( actionmode ) {

	document.entryCondition.mode.value = actionmode;		/* ���샂�[�h�ݒ� */
	document.entryCondition.submit();						/* ���g�֑��M */

	return false;

}
<!--
// �c�̌����K�C�h�Ăяo��
function callOrgGuide() {

	orgGuide_showGuideOrg(document.entryCondition.orgcd1, document.entryCondition.orgcd2, 'orgname');

}

// �c�̖��폜
function callOrgChange() {

	orgGuide_clearOrgInfo(document.entryCondition.orgcd1, document.entryCondition.orgcd2, 'orgname');

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">��</SPAN><FONT COLOR="#000000">�������̒��o</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Call EditMessage(strArrMessage, lngMessageStatus)
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
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
			<TD NOWRAP>��f�c�̃R�[�h</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
					<TR>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
						<TD>
							<INPUT TYPE="text" ONCHANGE="callOrgChange()" NAME="orgcd1" SIZE="5" MAXLENGTH="5" VALUE="<%=strOrgCd1%>">-
							<INPUT TYPE="text" ONCHANGE="callOrgChange()" NAME="orgcd2" SIZE="5" MAXLENGTH="5" VALUE="<%=strOrgCd2%>">
						</TD>
						<TD WIDTH="5"></TD>
						<TD WIDTH="250"><SPAN ID="orgname"><%=strOrgName%></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD>
			<TD>�o�͑Ώ�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="SelectMode" VALUE="0" <%= IIf(strSelectMode <> "1" And strSelectMode <> "2", "CHECKED", "") %>></TD>
						<TD>�w��Ȃ�</TD>
						<TD><INPUT TYPE="radio" NAME="SelectMode" VALUE="1" <%= IIf(strSelectMode  = "1", "CHECKED", "") %>></TD>
						<TD>��{�R�[�X�̂�</TD>
						<TD><INPUT TYPE="radio" NAME="SelectMode" VALUE="2" <%= IIf(strSelectMode  = "2", "CHECKED", "") %>></TD>
						<TD>�I�v�V���������̂�</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>
	<A HREF="javascript:function voi(){};voi()" ONCLICK="return redirectPage('edit')"><IMG SRC="/webHains/images/DataSelect.gif"></A></B></TD>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
