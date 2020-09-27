<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����̊��蓖�� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objOrgBsd			'���ƕ����A�N�Z�X�p
Dim objOrgPost			'�������A�N�Z�X�p
Dim objOrgRoom			'�������A�N�Z�X�p

'�����l
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgWkPostCd		'�J������R�[�h
Dim strOrgBsdCd			'���ƕ��R�[�h
Dim strOrgRoomCd		'�����R�[�h
Dim strStrOrgPostCd		'�J�n�����R�[�h
Dim strEndOrgPostCd		'�I�������R�[�h
Dim strOrgWkPostSeq		'�J������r�d�p

'�������
Dim strOrgName			'�c�̖���
Dim strOrgWkPostName	'�J���������
Dim strOrgBsdName		'���ƕ�����
Dim strOrgRoomName		'��������
Dim strStrOrgPostName	'�J�n��������
Dim strEndOrgPostName	'�I����������

Dim strMessage			'���b�Z�[�W
Dim strHTML				'HTML������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")

'�����l�̎擾
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgWkPostCd  = Request("orgWkPostCd")
strOrgBsdCd     = Request("orgBsdCd")
strOrgRoomCd    = Request("orgRoomCd")
strStrOrgPostCd = Request("strOrgPostCd")
strEndOrgPostCd = Request("endOrgPostCd")
strOrgWkPostSeq = Request("orgWkPostSeq")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'�m��{�^���������ȊO�͉������Ȃ�
	If Request("save.x") = "" Then
		Exit Do
	End If

	'���̓`�F�b�N
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		Exit Do
	End If

	'�����e�[�u�����R�[�h�̍X�V
	objOrgPost.UpdateOrgPost_OrgWkPostSeq strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, strOrgWkPostSeq

	'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
	strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
	strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
	strHTML = strHTML & "</BODY>"
	strHTML = strHTML & "</HTML>"
	Response.Write strHTML
	Response.End

	Exit Do
Loop

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

	Dim objCommon	'���ʃN���X
	Dim strMessage	'�G���[���b�Z�[�W�̏W��

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'���ƕ��R�[�h�̃`�F�b�N
	If strOrgBsdCd = "" Then
		objCommon.AppendArray strMessage, "���ƕ����w�肵�ĉ������B"
	End If

	'�����R�[�h�̃`�F�b�N
	If strOrgRoomCd = "" Then
		objCommon.AppendArray strMessage, "�������w�肵�ĉ������B"
	End If

	'�߂�l�̕ҏW
	If IsArray(strMessage) Then
		CheckValue = strMessage
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
<TITLE>��f�c�̂̐ݒ�</TITLE>
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', strOrgPostCd, 'strOrgPostName', endOrgPostCd, 'endOrgPostName' );
	}

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setElement()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="javascript:return confirm('���̓��e�ŏ����̊��蓖�Ă��s���܂����H')">

	<INPUT TYPE="hidden" NAME="orgCd1"       VALUE="<%= strOrgCd1       %>">
	<INPUT TYPE="hidden" NAME="orgCd2"       VALUE="<%= strOrgCd2       %>">
	<INPUT TYPE="hidden" NAME="orgWkPostCd"  VALUE="<%= strOrgWkPostCd  %>">
	<INPUT TYPE="hidden" NAME="orgBsdCd"     VALUE="<%= strOrgBsdCd     %>">
	<INPUT TYPE="hidden" NAME="orgRoomCd"    VALUE="<%= strOrgRoomCd    %>">
	<INPUT TYPE="hidden" NAME="strOrgPostCd" VALUE="<%= strStrOrgPostCd %>">
	<INPUT TYPE="hidden" NAME="endOrgPostCd" VALUE="<%= strEndOrgPostCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="95%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�����̊��蓖��</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕\��
	EditMessage strMessage, MESSAGETYPE_WARNING
%>
	<BR>
<%
	'�c�̖��̂̓ǂݍ���
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	objOrganization.SelectOrg strOrgCd1, strOrgCd2, , strOrgName

	'�J��������̂̓ǂݍ���
	objOrgPost.SelectOrgWkPost strOrgCd1, strOrgCd2, strOrgWkPostCd, strOrgWkPostName, strOrgWkPostSeq
%>
	<INPUT TYPE="hidden" NAME="orgWkPostSeq" VALUE="<%= strOrgWkPostSeq %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>�c��</TD>
			<TD>�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strOrgName %></B></FONT></TD>
		</TR>
		<TR>
			<TD NOWRAP>�J�����</TD>
			<TD>�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strOrgWkPostName %></B></FONT></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'�e�햼�̂̎擾
	Do

		'���ƕ��R�[�h���w�莞�͉������Ȃ�
		If strOrgBsdCd = "" Then
			Exit Do
		End If

		'���ƕ����̂̓ǂݍ���
		Set objOrgBsd = Server.CreateObject("HainsOrgBsd.OrgBsd")
		objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, , strOrgBsdName

		'�����R�[�h���w�莞�͉������Ȃ�
		If strOrgRoomCd = "" Then
			Exit Do
		End If

		'�������̂̓ǂݍ���
		Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
		objOrgRoom.SelectOrgRoom strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName

		'�J�n�������̂̓ǂݍ���
		If strStrOrgPostCd <> "" Then
			objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strStrOrgPostName
		End If

		'�I���������̂̓ǂݍ���
		If strEndOrgPostCd <> "" Then
			objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strEndOrgPostCd, strEndOrgPostName
		End If

		Exit Do
	Loop
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="60" NOWRAP>���ƕ�</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ƕ������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
		</TR>
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD>����</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>��</TD>
			<TD WIDTH="60" NOWRAP>����</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="strOrgPostName"><%= strStrOrgPostName %></SPAN></TD>
			<TD>�`</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="endOrgPostName"><%= strEndOrgPostName %></SPAN></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A>
	<INPUT TYPE="image" NAME="save" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm�肷��">

</FORM>
</BODY>
</HTML>
