<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_��p�^�[�������K�C�h (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objContract		'�_����A�N�Z�X�p
Dim objOrganization	'�c�̏��A�N�Z�X�p

'�����l
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strCsCd				'�R�[�X�R�[�h
Dim strShowAllPattern	'�S�p�^�[����\�����邩

Dim dtmStrDate		'�_��J�n��
Dim dtmEndDate		'�_��I����

'�_��Ǘ����
Dim strWebColor		'web�J���[
Dim strArrCsCd		'�R�[�X�R�[�h
Dim strCsName		'�R�[�X��
Dim strCtrPtCd		'�_��p�^�[���R�[�h
Dim strStrDate		'�_��J�n��
Dim strEndDate		'�_��I����
Dim lngCount		'���R�[�h��

Dim strOrgName		'�c�̊�������
Dim i				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objContract     = Server.CreateObject("HainsContract.Contract")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strCsCd           = Request("csCd")
strShowAllPattern = Request("showAllPattern")

If strShowAllPattern = "" Then

	'�V�X�e�����t���_��I�����̍ő�l�܂ł����������Ƃ��邽�߂̐ݒ�
	dtmStrDate = Date()

Else

	'�S�p�^�[�������������Ƃ��邽�߂̐ݒ�
	dtmStrDate = CDate("1970/1/1")

End If

dtmEndDate = CDate("2200/12/31")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�_����̌���</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̃K�C�h�Ăяo��
function callOrgGuide() {

	orgGuide_showGuideOrg( document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName', null, null, null, null, null, '0' );

}

// �_��p�^�[���I�����̏���
function selectPattern( index ) {

	var selCtrPtCd;	// �_��p�^�[���R�[�h
	var selCsName;	// �R�[�X��
	var selStrDate;	// �_��J�n��
	var selEndDate;	// �_��I����

	// �Ăь��E�B���h�E�����݂��Ȃ��ꍇ�͉�ʂ����
	if ( !opener ) {
		close();
		return;
	}

	// �I�����ꂽ�_��p�^�[���̎擾
	with ( document.patternList ) {

		if ( ctrPtCd.length ) {
			selCtrPtCd = ctrPtCd[ index ].value;
			selCsName  = csName[ index ].value;
			selStrDate = strDate[ index ].value;
			selEndDate = endDate[ index ].value;
		} else {
			selCtrPtCd = ctrPtCd.value;
			selCsName  = csName.value;
			selStrDate = strDate.value;
			selEndDate = endDate.value;
		}

		// �e��ʂ̌_��p�^�[���ҏW�֐��Ăяo��
		opener.ptnGuide_setPatternInfo( selCtrPtCd, selCsName, selStrDate, selEndDate, orgCd1.value, orgCd2.value, orgName.value );

	}

	// ��ʂ����
	opener.ptnGuide_closeGuidePattern();

}

// submit���̏���
function submitForm() {

	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:orgGuide_closeGuideOrg()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="orgCd1"         VALUE="<%= strOrgCd1         %>">
	<INPUT TYPE="hidden" NAME="orgCd2"         VALUE="<%= strOrgCd2         %>">
	<INPUT TYPE="hidden" NAME="showAllPattern" VALUE="<%= strShowAllPattern %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�_����̌���</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD>�c��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
<%
						'�c�̖��̓ǂݍ���
						If strOrgCd1 <> "" And strOrgCd2 <> "" Then
							objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , strOrgName
						End If
%>
						<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>��f�R�[�X</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %></TD>
						<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<FORM NAME="patternList" action="#">

	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="orgName" VALUE="<%= strOrgName %>">
<%
	Do

		'�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
		If strOrgCd1 = "" Or strOrgCd2 = "" Then
			Exit Do
		End If

		'�_��Ǘ����ǂݍ���
		lngCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, strCsCd, dtmStrdate, dtmEndDate, strWebColor, strArrCsCd, strCsName, , , , , strCtrPtCd, strStrDate, strEndDate)
		If lngCount <= 0 Then
%>
			���������𖞂����_����͑��݂��܂���B
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
			<TR>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>��f�R�[�X</TD>
				<TD WIDTH="10"></TD>
				<TD COLSPAN="7" NOWRAP>�_�����</TD>
			</TR>
			<TR>
				<TD></TD>
				<TD BGCOLOR="#999999" COLSPAN="10"></TD>
			</TR>
			<TR>
				<TD HEIGHT="2"></TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
					<TD>
						<INPUT TYPE="hidden" NAME="csCd"    VALUE="<%= strArrCsCd(i) %>">
						<INPUT TYPE="hidden" NAME="csName"  VALUE="<%= strCsName(i)  %>">
						<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd(i) %>">
						<INPUT TYPE="hidden" NAME="strDate" VALUE="<%= objCommon.FormatString(strStrDate(i), "yyyy�Nm��d��") %>">
						<INPUT TYPE="hidden" NAME="endDate" VALUE="<%= objCommon.FormatString(strEndDate(i), "yyyy�Nm��d��") %>">
					</TD>
					<TD NOWRAP><FONT COLOR="#<%= strWebColor(i) %>">��</FONT><A HREF="javascript:selectPattern(<%= i %>)"><%= strCsName(i) %></A></TD>
					<TD></TD>
					<TD NOWRAP><%= Year(strStrDate(i)) %>�N</TD>
					<TD NOWRAP ALIGN="right"><%= Month(strStrDate(i)) %>��</TD>
					<TD NOWRAP ALIGN="right"><%= Day(strStrDate(i))   %>��</TD>
					<TD>�`</TD>
					<TD NOWRAP><%= Year(strEndDate(i)) %>�N</TD>
					<TD NOWRAP ALIGN="right"><%= Month(strEndDate(i)) %>��</TD>
					<TD NOWRAP ALIGN="right"><%= Day(strEndDate(i))   %>��</TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
