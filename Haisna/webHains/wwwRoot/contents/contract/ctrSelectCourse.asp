<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(�_��R�[�X�̑I��) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const ACTMODE_BROWSE = "browse"	'���샂�[�h(�Q��)
Const OPMODE_BROWSE  = "browse"	'�������[�h(����)
Const OPMODE_COPY    = "copy"	'�������[�h(�R�s�[)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objOrganization	'�c�̏��A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strActMode		'���샂�[�h(�Q��:"browse")
Dim strOrgCd1		'�c�̃R�[�h1
Dim strOrgCd2		'�c�̃R�[�h2

'�Œ�c�̃R�[�h
Dim strPerOrgCd1	'�l��f�p�c�̃R�[�h1
Dim strPerOrgCd2	'�l��f�p�c�̃R�[�h2
Dim strWebOrgCd1	'Web�p�c�̃R�[�h1
Dim strWebOrgCd2	'Web�p�c�̃R�[�h2

Dim strOrgName		'�c�̖�
Dim strTitle		'�\��
Dim lngMargin		'�}�[�W���l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�Z�b�V�����E�����`�F�b�N
If Request("actMode") = ACTMODE_BROWSE Then
	Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)
Else
	Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strActMode = Request("actMode")
strOrgCd1  = Request("orgCd1")
strOrgCd2  = Request("orgCd2")

'�\��E�}�[�W���l�̐ݒ�
strTitle  = IIf(strActMode = ACTMODE_BROWSE, "�_����̎Q�ƁE�R�s�[", "�_��R�[�X�̑I��")
lngMargin = IIf(strActMode = ACTMODE_BROWSE, 0, 20)

'�l��f�Aweb�p�c�̃R�[�h�̎擾
objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
objCommon.GetOrgCd ORGCD_KEY_WEB,    strWebOrgCd1, strWebOrgCd2
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE><%= strTitle %></TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function goNextPage(myForm) {

	var url;

	// �R�[�X���I�����͉������Ȃ�
	if ( myForm.csCd.value == '' ) {
		return false;
	}

	// �������@���ҏW����Ă��Ȃ��A�����V�K�_����쐬���͂����ŏ����I��
	if ( myForm.opMode == null ) {
		return;
	}

	// �������@���Q�Ƃ̏ꍇ�A�_����Ԑݒ�͕s�v�̂��߁A�J�ڐ��ύX
	if ( myForm.opMode[0].checked ) {
<%
		'web�\��̏ꍇ�͒��ڌ_����̑I����ʂɑJ��
		If strOrgCd1 = strWebOrgCd1 And strOrgCd2 = strWebOrgCd2 Then
%>
			url = 'ctrBrowseContract.asp';
			url = url + '?opMode=<%= OPMODE_BROWSE %>';
			url = url + '&orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>';
			url = url + '&csCd=' + myForm.csCd.value;
			url = url + '&refOrgCd1=<%= strPerOrgCd1 %>&refOrgCd2=<%= strPerOrgCd1 %>';
			location.href = url;
			return false;
<%
		Else
%>
			myForm.action = 'ctrBrowseOrg.asp';
<%
		End If
%>
	}

	return true;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: <%= lngMargin %>px 0 0 0; }
	td.mnttab { background-color:#ffffff }
</style>
</HEAD>
<BODY>
<%
'�_����̎Q�ƁE�R�s�[���s���ꍇ�̓i�r��ҏW
If strActMode = ACTMODE_BROWSE Then
%>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<%
End If
%>
<FORM NAME="entryForm" ACTION="ctrPeriod.asp" METHOD="get" ONSUBMIT="JavaScript:return goNextPage(this)">
	<BLOCKQUOTE>
<%
	'�_����̎Q�ƁE�R�s�[���s���ꍇ�͓��샂�[�h�̒l��ێ�
	If strActMode = ACTMODE_BROWSE Then
%>
		<INPUT TYPE="hidden" NAME="actMode" VALUE="<%= strActMode %>">
<%
	End If
%>
	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2 %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000"><%= strTitle %></FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'�c�̖��̓ǂݍ���
	If objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName) = False Then
		Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
	End If
%>
	�_��c�́F<B><%= strOrgName %></B><BR><BR>
<%
	'�_����̎Q�ƁE�R�s�[���s���ꍇ�͑I������ҏW����
	If strActMode = ACTMODE_BROWSE Then
%>
		<FONT COLOR="#cc9999">��</FONT>�Q�ƁA�܂��̓R�s�[�̂����ꂩ�̏������@��I�����ĉ������B

		<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
			<TR VALIGN="top">
				<TD><INPUT TYPE="radio" NAME="opMode" VALUE="<%= OPMODE_BROWSE %>" CHECKED></TD>
				<TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>�_������Q�Ƃ���</TD>
				<TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>�E�E�E�E�E</TD>
				<TD>
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>
					<FONT COLOR="#666666">�Q�Ƃ���_��������L����_��c�̂ƁA�_����ԁE��f���ځE���S���̑S�Ă̌_����e�����L���܂��B<BR>
					�Q�Ɛ�̌_����e���C�������ƁA���̓��e�����_����ɔ��f����܂��B</FONT>
				</TD>
			</TR>
			<TR>
				<TD HEIGHT="10"></TD>
			</TR>
			<TR VALIGN="top">
				<TD><INPUT TYPE="radio" NAME="opMode" VALUE="<%= OPMODE_COPY %>"></TD>
				<TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>�_������R�s�[����</TD>
				<TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>�E�E�E�E�E</TD>
				<TD>
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3"><BR>
					<FONT COLOR="#666666">�R�s�[�ΏۂƂȂ�_���񂩂��f���ځE���S���̓��e���R�s�[���A���̂܂܎��c�̂̐V�����_����Ƃ��ĕۑ����܂��B<BR>
					�R�s�[�����_����e��K�p����_����Ԃɂ��Ă͂����Ŏw�肵�܂��B</FONT>
				</TD>
			</TR>
		</TABLE>

		<BR><BR>

		<FONT COLOR="#cc9999">��</FONT>�_����̎Q�ƁA�܂��̓R�s�[���s���R�[�X��I�����ĉ������B
<%
	'�V�K�_������쐬����ꍇ�̓��b�Z�[�W�݂̂�ҏW����
	Else
%>
		<FONT COLOR="#cc9999">��</FONT>�V�����_������쐬����R�[�X��I�����ĉ������B
<%
	End If
%>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", Empty, NON_SELECTED_ADD, False) %></TD>
	</TABLE>

	<BR>
<%
	'�_����̎Q�ƁE�R�s�[���s���ꍇ�́u�߂�v�{�^����z�u
	If strActMode = ACTMODE_BROWSE Then
%>
		<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
<%
	'�V�K�_������쐬����ꍇ�́u�L�����Z���v�{�^����z�u
	Else
%>
		<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
<%
	End If
%>
	<INPUT TYPE="image" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����">

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
