<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		����[�u���� (Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editButtonCol.inc"  -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"   -->

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCommon			'���ʃN���X
Dim objJudClass			'���蕪�ޏ��A�N�Z�X�p
Dim objJud				'������A�N�Z�X�p
Dim objAfterCare		'�A�t�^�[�P�A�A�N�Z�X�p
Dim objOrg				'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objOrgBsd			'���Ə����A�N�Z�X�p
Dim objOrgRoom			'�������A�N�Z�X�p
Dim objOrgPost			'�������A�N�Z�X�p
Dim objFree				'�ėp���A�N�Z�X�p

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Dim strConstverTimeDiv
strConstverTimeDiv = Array("�Ȃ�","����")

'���蕪�ޏ��
Dim strDispJudClassCd		'���蕪�ރR�[�h
Dim strDispJudClassName		'���蕪�ޖ���

'������
Dim strDispJudCd			'����R�[�h
Dim strDispJudSName			'���藪��
Dim strDispJudRName			'�񍐏��p���薼��

'�c�̏��
Dim strOrgName				'�c�̖���
Dim strOrgSName				'����
Dim strOrgKName				'�c�̃J�i����

'�l���
'Dim strPerID				'�l�h�c
Dim strLastName				'��
Dim strFirstName			'��

'���ƕ����
Dim strOrgBsdKName			'���ƕ��J�i����
Dim strOrgBsdName			'���ƕ�����

'�������
Dim strOrgRoomKName			'�����J�i����
Dim strOrgRoomName			'��������

'�������
Dim strOrgPostKName1		'�����J�i���̂P
Dim strOrgPostKName2		'�����J�i���̂Q
Dim strOrgPostName1			'�������̂P
Dim strOrgPostName2			'�������̂Q

'����[�u�ΏێҌ����p
Dim strOutputKbn			'�o�͏�
Dim strOrgCd1				'�c�̃R�[�h�P
Dim strOrgCd2				'�c�̃R�[�h�Q
Dim strOrgBsdCd				'���Ə��R�[�h
Dim strOrgRoomCd			'�����R�[�h
Dim strOrgPostCd1			'�����R�[�h�P
Dim strOrgPostCd2			'�����R�[�h�Q
Dim strPerID				'�l�h�c
Dim strSochiKbn				'�A�Ƒ[�u�敪
Dim strChokaKbn				'���ߋΖ��敪
Dim strJudClassCd			'���蕪�ރR�[�h
Dim strJudCd				'����R�[�h
Dim strStrAgeInt			'�����J�n�N��
Dim strEndAgeInt			'�����I���N��
Dim strGender				'����
Dim strArrPerId         	'�l�h�c
Dim strArrEmpNo         	'�]�ƈ��ԍ�
Dim strArrLastName          '��
Dim strArrFirstName         '��
Dim strArrLastKName         '���i�J�i�j
Dim strArrFirstKName        '���i�J�i�j
Dim strArrBirth             '���N����
Dim strArrGender            '����
Dim strArrOrgName           '�c�̖���
Dim strArrOrgPostName       '��������
Dim strArrWorkMeasureName   '�A�Ƒ[�u�敪
Dim strArrOverTimeDiv       '���ߋΖ��敪
Dim strArrJudString      	'���蕶����

'�A�Ƒ[�u�敪�I�v�V�����{�^���p
Const strKeyWorkMeasureDiv = "WORKDIV"
Dim strWorkMeasureDiv			'�A�Ƒ[�u�敪
Dim strArrWorkMeasureDiv		'�A�Ƒ[�u�敪�i�z��j
Dim strArrWorkMeasureDivName	'�A�Ƒ[�u�敪���i�z��j
Dim lngWorkMeasureDivCount		'�A�Ƒ[�u�敪��

Dim strToday				'�{�����t�i�V�X�e�����t�j
Dim strDispPerName			'�l��
Dim strDispPerKName			'�l�J�i��
Dim strDispAge				'�N��
Dim lngAllJigoCount			'����[�u�Ώێ҃��R�[�h�J�E���g
Dim lngDispJigoCount		'����[�u�ΏێҊǗ����ځi�\���p�j
Dim lngJigoCount			'����[�u�ΏێҊǗ�����
Dim i,j						'���[�v�J�E���g

Dim lngStartPos				'�\���J�n�ʒu
Dim strPageMaxLine			'�P�y�[�W�\���s��
Dim lngGetCount				'�P�y�[�W�\������
Dim lngAllCount				'�����𖞂����S���R�[�h����

Dim strSearchString

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�ꗗ�\���s���̎擾
strPageMaxLine = 30

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")
Set objJudClass	 	= Server.CreateObject("HainsJudClass.JudClass")
Set objJud		 	= Server.CreateObject("HainsJud.Jud")
Set objAfterCare 	= Server.CreateObject("HainsAfterCare.AfterCare")
Set objFree		 	= Server.CreateObject("HainsFree.Free")

strOutputKbn    	= Request("outputKbn")
strOutputKbn    	= IIf(strOutputKbn = "", 1, strOutputKbn)
strOrgCd1 			= Request("orgCd1")
strOrgCd2 			= Request("orgCd2")
strPerID			= Request("perId")
strOrgBsdCd			= Request("orgBsdCd")
strOrgRoomCd		= Request("orgRoomCd")
strOrgPostCd1		= Request("orgPostCd1")
strOrgPostCd2		= Request("orgPostCd2")
strSochiKbn			= Request("sochiKbn")
strChokaKbn			= Request("chokaKbn")
strJudClassCd		= Request("judClassCd")
strJudCd			= Request("judCd")
strStrAgeInt		= Request("strAgeInt")
strEndAgeInt		= Request("endAgeInt")
strGender			= Request("gender")

lngStartPos    = CLng("0" & Request("startPos"))
lngStartPos    = IIf(lngStartPos = 0, 1, lngStartPos)

'���蕪�ޏ��̃��X�g�擾
	objJudClass.SelectJudClassList  strDispJudClassCd, strDispJudClassName, Empty

'����R�[�h�̃��X�g�擾
	objJud.SelectJudList  strDispJudCd, strDispJudSName, strDispJudRName, Empty, Empty, Empty

'�c�̖��̂̎擾
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" ) Then
	Set objOrg = Server.CreateObject("HainsOrganization.Organization")
	objOrg.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
	Set objOrg = Nothing
End If

'�l�����̎擾
If( Trim(strPerID) <> "" ) Then
	Set objPerson = Server.CreateObject("HainsPerson.Person")
	objPerson.SelectPersonName strPerID, strLastName, strFirstName
	Set objPerson = Nothing
End If

'���Ə����̎擾
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" And Trim(strOrgBsdCd) <> "" ) Then
	Set objOrgBsd  = Server.CreateObject("HainsOrgBsd.OrgBsd")
	objOrgBsd.SelectOrgBsd strOrgCd1, strOrgCd2, strOrgBsdCd, _
						   strOrgBsdKName, strOrgBsdName, _
						   Empty, Empty, Empty
	Set objOrgBsd = Nothing
End If

'�������̎擾
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" ) Then
	Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
	objOrgRoom.SelectOrgRoom strOrgCd1,strOrgCd2,strOrgBsdCd, strOrgRoomCd, _
							 strOrgRoomName,strOrgRoomKName, _
							 Empty,Empty,Empty,Empty,Empty 
	Set objOrgRoom = Nothing
End If

'�������P�̎擾
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" _
	And Trim(strOrgPostCd1) <> "" ) Then
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd1, _
							 strOrgPostName1, strOrgPostKName1, _
							 Empty, Empty, Empty, Empty, _
							 Empty, Empty, Empty
	Set objOrgPost = Nothing
End If

'�������Q�̎擾
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" _
	And Trim(strOrgPostCd1) <> "" ) Then
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	objOrgPost.SelectOrgPost strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd2, _
							 strOrgPostName2, strOrgPostKName2, _
							 Empty, Empty, Empty, Empty, _
							 Empty, Empty, Empty 
	Set objOrgPost = Nothing
End If

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">

<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->

<SCRIPT TYPE="text/javascript">
<!--

// �l�����K�C�h�Ăяo��
function callPerGuide() {

	//�l�K�C�h�\��
	perGuide_showGuidePersonal( null, null, null, setPerInfo );

}

// �l���̕ҏW
function setPerInfo( perInfo ) {

	document.entryForm.perId.value = perInfo.perId;
	document.getElementById('perName').innerHTML = perInfo.perName;

}

// �l�h�c�E�����̃N���A
function clearPerInfo() {

	perGuide_clearPerInfo( document.entryForm.perId, 'perName' );

}

// �T�u��ʂ����
function closeWindow() {

	// �c�̌����K�C�h�����
	orgGuide_closeGuideOrg();

}

// �������s
function searchSubmit(){

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var url    = '';					// �t�H�[���̑��M��t�q�k

	if ( myForm.orgCd1.value == '' && myForm.orgCd2.value == '' && myForm.perId.value == '' ){
		strErrMsg = '�������s���ꍇ�A�c�̃R�[�h�܂��͌l�h�c�̂����ꂩ�K�{���͂ł��B';
		alert(strErrMsg);
		return false;
	}

	myForm.startPos.value = 1;			//Position������
	document.entryForm.submit();
	return false;

}

// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', orgPostCd1, 'OrgPostName1', orgPostCd2, 'OrgPostName2' );
	}

}
//-->
</SCRIPT>
<TITLE>����[�u�Ώێ҂̌���</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="default.css">
<STYLE TYPE="text/css">
td.rsltab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()" ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= CStr(lngStartPos) %>">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">����[�u�Ώێ҂̌���</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>�o�͏�</TD>
		<TD>�F</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><INPUT TYPE="radio" NAME="outputKbn" VALUE="1" <%= Iif(strOutputKbn = "1", "CHECKED", "") %> ></TD>
					<TD>�T�O����</TD>
					<TD><INPUT TYPE="radio" NAME="outputKbn" VALUE="2" <%= Iif(strOutputKbn = "2", "CHECKED", "") %> ></TD>
					<TD>�]�ƈ��ԍ���</TD>
					<TD><INPUT TYPE="radio" NAME="outputKbn" VALUE="3" <%= Iif(strOutputKbn = "3", "CHECKED", "") %> ></TD>
					<TD>������</TD>
					<TD><INPUT TYPE="radio" NAME="outputKbn" VALUE="4" <%= Iif(strOutputKbn = "4", "CHECKED", "") %> ></TD>
					<TD>�E�폇</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>�c��</TD>
		<TD>�F</TD>
<!--
		<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
		<TD><A HREF="javascript:clearOrgCd()"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�c�̂��N���A"></A></TD>
-->
		<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
		<TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�c�̂��N���A"></A></TD>
		<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1 %>">
		<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2 %>">
		<TD><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
	</TR>
	<TR>
		<TD NOWRAP>���ƕ�</TD>
		<TD>�F</TD>
<!-- 
		<TD><A HREF="javascript:callOrgBsdGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���ƕ������K�C�h��\��"></A></TD>
		<TD><A HREF="javascript:clearOrgBsdCd()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���Ƃ��N���A"></A></TD>
-->
		<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ƕ������K�C�h��\��"></A></TD>
		<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="���Ə����N���A"></A></TD>
		<INPUT TYPE="hidden" NAME="orgBsdCd"  VALUE="<%= strOrgBsdCd %>">
		<TD><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
	</TR>
	<TR>
		<TD NOWRAP>����</TD>
		<TD>�F</TD>
<!--
		<TD><A HREF="javascript:callOrgRoomGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
		<TD><A HREF="javascript:clearOrgRoomCd()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
		<INPUT TYPE="hidden" NAME="orgRoomCd"  VALUE="<%= strOrgRoomCd %>">
		<TD><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
-->
		<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
		<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
		<INPUT TYPE="hidden" NAME="orgRoomCd"  VALUE="<%= strOrgRoomCd %>">
		<TD><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
	</TR>
		<TR>
			<TD WIDTH=90" NOWRAP>����</TD>
			<TD>�F</TD>
<!--
			<TD><A HREF="javascript:callOrgPostGuide(1)"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearOrgPostCd(1)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd1"  VALUE="<%= strOrgPostCd1 %>">
			<TD><SPAN ID="OrgPostName1"><%= strOrgPostName1 %></SPAN></TD>
			<TD>�`</TD>
			<TD><A HREF="javascript:callOrgPostGuide(2)"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearOrgPostCd(2)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd2"  VALUE="<%= strOrgPostCd2 %>">
			<TD><SPAN ID="OrgPostName2"><%= strOrgPostName2 %></SPAN></TD>
-->
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd1"  VALUE="<%= strOrgPostCd1 %>">
			<TD><SPAN ID="OrgPostName1"><%= strOrgPostName1 %></SPAN></TD>
			<TD>�`</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd2"  VALUE="<%= strOrgPostCd2 %>">
			<TD><SPAN ID="OrgPostName2"><%= strOrgPostName2 %></SPAN></TD>
		</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH='90"' NOWRAP>��f�Ҏw��</TD>
		<TD>�F</TD>
		<TD><A HREF="javascript:callPerGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\��"></A></TD>
		<TD><A HREF="javascript:clearPerInfo()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�l���N���A"></A></TD>
		<INPUT TYPE="hidden" NAME="perId"  VALUE="<%= strPerID %>">
		<TD><SPAN ID="perName"><%= strLastName %>    <%= strFirstName %></SPAN></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>�A�Ƒ[�u�敪</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="radio" NAME="sochiKbn" VALUE=""  <%= Iif(strSochiKbn = "", "CHECKED", "") %>></TD>
		<TD NOWRAP>���ׂ�</TD>
<%
			'�A�Ƒ[�u�敪�擾
			lngWorkMeasureDivCount = objFree.SelectFree (1, strKeyWorkMeasureDiv, strArrWorkMeasureDiv, , , strArrWorkMeasureDivName)
			For i = 0 To lngWorkMeasureDivCount - 1
%>
				<TD><INPUT TYPE="radio" NAME="sochiKbn" VALUE="<%= strArrWorkMeasureDiv(i) %>" <%= Iif(strSochiKbn = strArrWorkMeasureDiv(i), "CHECKED", "") %> ></TD>
				<TD NOWRAP><%= strArrWorkMeasureDivName(i) %></TD>
<%
			Next
%>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>���ߋΖ��敪</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="radio" NAME="chokaKbn" VALUE=""  <%= Iif(strChokaKbn = "", "CHECKED", "") %>></TD>
		<TD NOWRAP>���ׂ�</TD>
		<TD><INPUT TYPE="radio" NAME="chokaKbn" VALUE="0" <%= Iif(strChokaKbn = "0", "CHECKED", "") %>></TD>
		<TD NOWRAP>�Ȃ�</TD>
		<TD><INPUT TYPE="radio" NAME="chokaKbn" VALUE="1" <%= Iif(strChokaKbn = "1", "CHECKED", "") %>></TD>
		<TD NOWRAP>����</TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>���蕪��</TD>
		<TD>�F</TD>
		<TD><%= EditDropDownListFromArray("judClassCd", strDispJudClassCd, strDispJudClassName , strJudClassCd, NON_SELECTED_ADD) %></TD>
		<TD>����</TD>
		<TD>�F</TD>
		<TD><%= EditDropDownListFromArray("judCd", strDispJudCd, strDispJudSName , strJudCd, NON_SELECTED_ADD) %></TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="650">
	<TR>
		<TD WIDTH="90" NOWRAP>�N��</TD>
		<TD WIDTH="1">�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><%= EditNumberList("strAgeInt", 1, 150, strStrAgeInt , true) %></TD>
					<TD>��</TD>
					<TD>
						
					</TD>
					<TD NOWRAP>�`</TD>
					<TD><%= EditNumberList("endAgeInt", 1, 150, strEndAgeInt , true) %></TD>
					</TD>
					<TD>��</TD>
				</TR>
			</TABLE>
		</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
				<TR>
					<TD NOWRAP>����</TD>
					<TD>�F</TD>
					<TD>
						<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
							<TR>
								<TD><INPUT TYPE="radio" NAME="gender" VALUE=""  <%= Iif(strGender = "", "CHECKED", "") %>></TD>
								<TD NOWRAP>���ׂ�</TD>
								<TD><INPUT TYPE="radio" NAME="gender" VALUE="1" <%= Iif(strGender = "1", "CHECKED", "") %> ></TD>
								<TD NOWRAP>�j���̂�</TD>
								<TD><INPUT TYPE="radio" NAME="gender" VALUE="2" <%= Iif(strGender = "2", "CHECKED", "") %>></TD>
								<TD NOWRAP>�����̂�</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD ALIGN="right"><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return searchSubmit(5)"><IMG SRC="/webHains/images/b_search.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
	</TR>
</TABLE>
<BR>

<%
'-------------------------------------------------------------------------------
'����[�u�Ώێ҂̌���
'-------------------------------------------------------------------------------
If( strPerId <> "" Or ( strOrgCd1 <> "" And strOrgCd2 <> "" )) Then

	'����[�u�Ώێ҂̌����i�l���j
	lngAllCount = objAfterCare.SelectAfterCareTarget( _
								"CNT" , _
								strOutputKbn , _
								strPerID , _
								strOrgCd1 , _
								strOrgCd2 , _
								strOrgBsdCd , _
								strOrgRoomCd , _
								strOrgPostCd1 , _
								strOrgPostCd2 , _
								strSochiKbn , _
								strChokaKbn , _
								strJudClassCd , _
								strJudCd , _
								strStrAgeInt , _
								strEndAgeInt , _
								strGender)

	If( lngAllCount > 0 ) Then
%>
	�w������̎���[�u�Ώێ҈ꗗ��\�����Ă��܂��B<BR>
	�ΏێҐ��� <FONT COLOR="#FF6600"><B><%= lngAllCount %></B></FONT>�l�ł��B<BR><BR>
<% 
	Else
%>
	���������𖞂�������[�u���͑Ώێ҂͑��݂��܂���B<BR>
	�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR><BR>
<%
	End If
End If

If lngAllCount > 0 Then 

	'����[�u�Ώێ҂̌����i���f�[�^�j
	lngDispJigoCount = objAfterCare.SelectAfterCareTarget( _
								"SRC" , _
								strOutputKbn , _
								strPerID , _
								strOrgCd1 , _
 								strOrgCd2 , _
 								strOrgBsdCd , _
 								strOrgRoomCd , _
 								strOrgPostCd1 , _
 								strOrgPostCd2 , _
 								strSochiKbn , _
 								strChokaKbn , _
 								strJudClassCd , _
 								strJudCd , _
 								strStrAgeInt , _
 								strEndAgeInt , _
 								strGender , _
 								lngStartPos, _
 								strPageMaxLine, _
 								strArrPerId , _
 								strArrEmpNo , _
 								strArrLastName , _
 								strArrFirstName , _
 								strArrLastKName , _
 								strArrFirstKName , _
 								strArrBirth , _
 								strArrGender , _
 								strArrOrgName , _
 								strArrOrgPostName , _
 								strArrWorkMeasureName , _
 								strArrOverTimeDiv , _
								strArrJudString)

End If

If lngDispJigoCount > 0 Then
%>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="#cccccc">
<%
		If ( strOrgCd1 = "" ) Or ( strOrgCd2 = "" ) Then
%>
			<TD NOWRAP>�c��</TD>
<%
		End If
%>
			<TD NOWRAP>�]�ƈ��ԍ�</TD>
			<TD NOWRAP>����</TD>
			<TD NOWRAP>����</TD>
			<TD NOWRAP>�N��</TD>
			<TD NOWRAP>����</TD>
			<TD NOWRAP>�[�u�敪</TD>
			<TD NOWRAP>���΋敪</TD>
			<TD NOWRAP>�v�Ǘ�����</TD>
		</TR>
<%
End If
%>

<%
For i = 0 To lngDispJigoCount - 1
	'�\���p���̂̕ҏW
	strDispPerName 	= Trim(strArrLastName(i) & "�@" & strArrFirstName(i))
	strDispPerKName = Trim(strArrLastKName(i) & "�@" & strArrFirstKName(i))

	'�N��̎Z�o
	strToday = Year(now) & "/" & Month(now) & "/" & Day(now)
'	strDispAge = objFree.CalcAge( strArrBirth(i) , strToday , "" )
	strDispAge = strArrBirth(i)
%>

	<TR BGCOLOR="#ffffff">
<%
	If ( strOrgCd1 = "" ) Or ( strOrgCd2 = "" ) Then
%>
		<TD NOWRAP><%= strArrOrgName(i) %></TD>
<%
	End If
%>
		<TD><%= strArrEmpNo(i) %></TD>
		<TD NOWRAP><A HREF="JigoInfo.asp?perId=<%= strArrPerId(i) %>"><%= strDispPerName %><FONT SIZE="-1" COLOR="#666666">�i<%= strDispPerKName %>�j</FONT></A></TD>
		<TD NOWRAP><%= strArrGender(i) %></TD>
		<TD ALIGN="right" NOWRAP><%= strDispAge %>��</TD>
		<TD NOWRAP><%= strArrOrgPostName(i) %></TD>
		<TD NOWRAP><%= strArrWorkMeasureName(i) %></TD>
		<TD ALIGN="center" NOWRAP><%= strConstverTimeDiv(Cint(strArrOverTimeDiv(i))) %></TD>
		<TD NOWRAP><%= strArrJudString(i) %></TD>
	</TR>
<%
Next
%>
	</TABLE>

<%
	'�y�[�W���O�i�r�Q�[�^�̕ҏW
	If IsNumeric(strPageMaxLine) Then
		lngGetCount = CLng(strPageMaxLine)
		strSearchString = ""
		strSearchString = strSearchString & "outputKbn=" & strOutputKbn
		strSearchString = strSearchString & "&orgCd1=" & strOrgCd1
		strSearchString = strSearchString & "&orgCd2=" & strOrgCd2
		strSearchString = strSearchString & "&orgBsdCd=" & strOrgBsdCd
		strSearchString = strSearchString & "&orgRoomCd=" & strOrgRoomCd
		strSearchString = strSearchString & "&orgPostCd1=" & strOrgPostCd1
		strSearchString = strSearchString & "&orgPostCd2=" & strOrgPostCd2
		strSearchString = strSearchString & "&perId=" & strPerID
		strSearchString = strSearchString & "&sochiKbn=" & strSochiKbn
		strSearchString = strSearchString & "&chokaKbn=" & strChokaKbn
		strSearchString = strSearchString & "&judClassCd=" & strJudClassCd
		strSearchString = strSearchString & "&judCd=" & strJudCd
		strSearchString = strSearchString & "&strAgeInt=" & strStrAgeInt
		strSearchString = strSearchString & "&endAgeInt=" & strEndAgeInt
		strSearchString = strSearchString & "&gender=" & strGender
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?" & strSearchString, lngAllCount, lngStartPos, lngGetCount) %>
<%
	End If
%>

</FORM>
</BODY>
</HTML>
