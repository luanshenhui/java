<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���a�x�ƃ��X�g (Ver0.0.1)
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
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCommon			'���ʃN���X
Dim objPerDisease		'���a�x�Ə��A�N�Z�X�p
Dim objOrg				'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objOrgBsd			'���Ə����A�N�Z�X�p
Dim objOrgRoom			'�������A�N�Z�X�p
Dim objOrgPost			'�������A�N�Z�X�p
Dim objFree				'�ėp���A�N�Z�X�p

'�c�̏��
Dim strOrgName			'�c�̖���
Dim strOrgSName			'����
Dim strOrgKName			'�c�̃J�i����

'�l���
'Dim strPerID			'�l�h�c
Dim strLastName			'��
Dim strFirstName		'��

'���ƕ����
Dim strOrgBsdKName		'���ƕ��J�i����
Dim strOrgBsdName		'���ƕ�����

'�������
Dim strOrgRoomKName		'�����J�i����
Dim strOrgRoomName		'��������

'�������
Dim strOrgPostKName1	'�����J�i���̂P
Dim strOrgPostKName2	'�����J�i���̂Q
Dim strOrgPostName1		'�������̂P
Dim strOrgPostName2		'�������̂Q

'���a�x�Ə��
Dim strDataDate			'�f�[�^�N�i�����p�j
Dim strPerID			'�l�h�c�i�����p�j
Dim strOrgCd1 			'�c�̃R�[�h�P�i�����p�j
Dim strOrgCd2			'�c�̃R�[�h�Q�i�����p�j
Dim strOrgBsdCd			'���Ə��R�[�h�i�����p�j
Dim strOrgRoomCd		'�����R�[�h�i�����p�j
Dim strOrgPostCd1		'�����R�[�h�P�i�����p�j
Dim strOrgPostCd2		'�����R�[�h�Q�i�����p�j
Dim arrPerId			'�l�R�[�h�i�������ʁj
Dim arrEmpNo			'�]�ƈ��ԍ��i�������ʁj
Dim arrLastName			'���i�������ʁj
Dim arrFirstName		'���i�������ʁj
Dim arrLastKName		'���J�i�i�������ʁj
Dim arrFirstKName		'���J�i�i�������ʁj
Dim arrBirth			'���N�����i�������ʁj
Dim arrGender			'���ʁi�������ʁj
Dim arrOrgName			'�c�̖��́i�������ʁj
Dim arrOrgPostName		'�������́i�������ʁj
Dim arrDisName			'�a���i�������ʁj
Dim arrDataDate			'�f�[�^���t�i�������ʁj
Dim arrDisCd			'�a���R�[�h�i�������ʁj
Dim arrOccurDate		'���a���t�i�������ʁj
Dim arrHoliday			'�x�ɓ����i�������ʁj
Dim arrAbsence			'���Γ����i�������ʁj
Dim arrContinues		'�p���敪�i�������ʁj
Dim arrMedicalDiv		'�×{�敪�i�������ʁj
Dim arrAge

Dim strDataYear			'�f�[�^�N�i�����p�j
Dim strDataMonth		'�f�[�^���i�����p�j
Dim strToday			'�{�����t�i�V�X�e�����t�j
Dim strAge				'�N��
Dim strKeyPerId			'�l�h�c�i�����p�j

Dim lngGetCount			'

Dim lngStartPos			'�\���J�n�ʒu
Dim strPageMaxLine		'�\���ő�s
Dim strSearchString		'�y�[�W���O�i�r�p����������
Dim lngAllCount			'�擾����
Dim lngCount			'�擾����
Dim vntMessage 			'���b�Z�[�W
Dim strOldPerId			'�R���g���[���u���C�N�p�lID

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Dim BlnCheckFlg			'�������ʃ`�F�b�N�p
Dim strHtml         	'html�o�͗p���[�N
Dim lngPerDisCount		'���a�x�ƌ�������
Dim lngALLPerDisCount	'���a�x�ƌ�������
Dim i , j      			'���[�v�J�E���g�p���[�N

Dim strMode				'���͂���ʌĂяo�����̓��샂�[�h�ݒ�
Dim strDspContinue		'�\���p�p���敪
Dim strDspMedicalDiv	'�\���p�×{�敪

strDspContinue   = Array("�V�K","�p��")
strDspMedicalDiv = Array("����×{","�ʉ@","���@")

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
strOrgCd1 		= Request("orgCd1")
strOrgCd2 		= Request("orgCd2")
strDataYear		= Request("dataYear")
strDataMonth	= Request("dataMonth")
strPerID		= Request("perId")
strOrgBsdCd		= Request("orgBsdCd")
strOrgRoomCd	= Request("orgRoomCd")
strOrgPostCd1	= Request("orgPostCd1")
strOrgPostCd2	= Request("orgPostCd2")
strMode         = Request("mode")

strPageMaxLine  = Request("PageMaxLine")
lngStartPos     = CLng("0" & Request("startPos"))
lngStartPos     = IIf(lngStartPos = 0, 1, lngStartPos)

'�����p�̓��t�ݒ�
If( strDataYear <> "" And strDataMonth <> "" ) Then
	strDataDate		= strDataYear & "/" & strDataMonth
End If

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
	BlnCheckFlg = objOrgBsd.SelectOrgBsd( strOrgCd1, strOrgCd2, strOrgBsdCd, _
										   strOrgBsdKName, strOrgBsdName, _
										   Empty, Empty, Empty _
						     			 )
	Set objOrgBsd = Nothing
End If

'�������̎擾
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" ) Then
	Set objOrgRoom = Server.CreateObject("HainsOrgRoom.OrgRoom")
	BlnCheckFlg = objOrgRoom.SelectOrgRoom( strOrgCd1,strOrgCd2,strOrgBsdCd, strOrgRoomCd, _
							  				strOrgRoomName,strOrgRoomKName, _
							  				Empty,Empty,Empty,Empty,Empty _
		     							  )
	Set objOrgRoom = Nothing
End If

'�������P�̎擾
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" _
	And Trim(strOrgPostCd1) <> "" ) Then
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	BlnCheckFlg = objOrgPost.SelectOrgPost( strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd1, _
							  				strOrgPostName1, strOrgPostKName1, _
							  				Empty, Empty, Empty, Empty, _
							  				Empty, Empty, Empty _
										  )
	Set objOrgPost = Nothing
End If

'�������Q�̎擾
If( Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" _
	And Trim(strOrgBsdCd) <> "" And Trim(strOrgRoomCd) <> "" _
	And Trim(strOrgPostCd1) <> "" ) Then
	Set objOrgPost = Server.CreateObject("HainsOrgPost.OrgPost")
	BlnCheckFlg = objOrgPost.SelectOrgPost( strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd2, _
							  				strOrgPostName2, strOrgPostKName2, _
							  				Empty, Empty, Empty, Empty, _
							  				Empty, Empty, Empty _
										  )
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
var strMode;	//  ����ʁi���͉�ʁj�ֈڍs���鎞�̏������[�h��ݒ�

// �K�C�h��ʌĂяo��
function callOrgGuide() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	orgGuide_showGuideOrg( objForm.orgCd1, objForm.orgCd2, 'orgName', '', '' , null , false );

}
// �c�̃N���A
function clearOrgCd() {

	orgGuide_clearOrgInfo(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName');

}

// ���ƕ��K�C�h�Ăяo��
function callOrgBsdGuide() {

	if( checkData(1) ){
		var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
		orgBsdGuide_showGuideOrgBsd( objForm.orgCd1, objForm.orgCd2, objForm.orgBsdCd, '' , 'orgBsdName', null , false );
	}
}

// ���ƕ��N���A
function clearOrgBsdCd() {

	orgBsdGuide_clearOrgBsdInfo(document.entryForm.orgBsdCd, '' , 'orgBsdName');

}

// �����K�C�h�Ăяo��
function callOrgRoomGuide() {

	if( checkData(2) ){
		var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
		OrgRoomGuide_showGuideOrgRoom( objForm.orgCd1, objForm.orgCd2, objForm.orgBsdCd, objForm.orgRoomCd, '' , 'orgRoomName', null , false );
	}
}

// �����N���A
function clearOrgRoomCd() {

	OrgRoomGuide_clearOrgRoomInfo(document.entryForm.orgRoomCd, 'orgRoomName' , '' );

}

// �����K�C�h�Ăяo��
function callOrgPostGuide( postCdNo ) {
	var  objPostCd;
	var  idPostName;

	if( postCdNo == 1 ){
		objPostCd = document.entryForm.orgPostCd1;
		idPostCd  = 'OrgPostName1';
	}else{
		objPostCd = document.entryForm.orgPostCd2;
		idPostCd  = 'OrgPostName2';
	}

	if( checkData(3) ){
		var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
		OrgPostGuide_showGuideOrgPost( objForm.orgCd1, objForm.orgCd2, objForm.orgBsdCd, objForm.orgRoomCd, objPostCd, idPostCd, '' , null , false );
	}
}

// �����N���A
function clearOrgPostCd( postCdNo ) {
	var  objPostCd;
	var  idPostName;

	if( postCdNo == 1 ){
		objPostCd = document.entryForm.orgPostCd1;
		idPostCd  = 'OrgPostName1';
	}else{
		objPostCd = document.entryForm.orgPostCd2;
		idPostCd  = 'OrgPostName2';
	}


	OrgPostGuide_clearOrgPostInfo(objPostCd, idPostCd , '' );

}
// �l�����K�C�h�Ăяo��
function callPerGuide() {

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

// ���a�x�Ɠ��͉�ʂ̕\��
function showPerDisease(CheckMode){

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var url    = '';					// �t�H�[���̑��M��t�q�k

	//  �G���[�`�F�b�N���n�j�̏ꍇ���͉�ʂ�\������
	if( checkData(CheckMode) ){

		if( CheckMode == 4 ){
			myForm.mode.value = 'insert';
			url = '/webHains/contents/disease/perDiseaseInfo.asp';
		}else{
			myForm.mode.value = 'replace';
		}

		myForm.action = url ;
		document.entryForm.submit();
	}

	return false;

}

// �T�u��ʂ����
function closeWindow() {

	// �c�̌����K�C�h�����
	orgGuide_closeGuideOrg();

}
// ���̓`�F�b�N
function checkData(CheckMode) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var ret    = false;					// �֐��߂�l
	var CheckRsl;
	var strErrMsg = '';

	switch (CheckMode){
		case 1 :
			// ���ƕ��I�����̃`�F�b�N
			if ( myForm.orgCd1.value == '' || myForm.orgCd2.value == '' ){
				strErrMsg = '���ƕ���I������ꍇ�A�c�̃R�[�h�͕K�{���͂ł��B';
			}
			break;
		case 2 :
			// �����I�����̃`�F�b�N
			if ( (myForm.orgCd1.value == '' || myForm.orgCd2.value == '' ) && myForm.orgBsdCd.value == '' ){
				strErrMsg = '������I������ꍇ�A�c�́C���ƕ��R�[�h�͕K�{���͂ł��B';
			}
			break;
		case 3 :
			// �����I�����̃`�F�b�N
			if ( (myForm.orgCd1.value == '' || myForm.orgCd2.value == '' ) && myForm.orgBsdCd.value == '' && myForm.orgRoomCd.value == '' ){
				strErrMsg = '������I������ꍇ�A�c�́C���ƕ��C�����R�[�h�͕K�{���͂ł��B';
			}
			break;
//		case 4 :
//			// �V�K�{�^���N���b�N���̃`�F�b�N
//			if ( myForm.perId.value == '' ) {
//				strErrMsg = '�V�K���͂��s���ꍇ�A�l�h�c�͕K�{���͂ł��B';
//			}
//			break;
		case 5 :
			// �����{�^���N���b�N���̃`�F�b�N
			if ( myForm.orgCd1.value == '' && myForm.orgCd2.value == '' && myForm.perId.value == '' ){
				strErrMsg = '�������s���ꍇ�A�c�̃R�[�h�܂��͌l�h�c�̂����ꂩ�K�{���͂ł��B';
			}
	}

	if( strErrMsg != '' ){
		alert(strErrMsg);
		return ret;
	}

	return(true);
}

// ## 2002.12.12 Add 8Lines by T.Takagi@FSIT �i�����K�C�h�Ή��jONLOAD�C�x���g�ɂăG�������g�̎Q�Ɛݒ���s��
// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', orgPostCd1, 'OrgPostName1', orgPostCd2, 'OrgPostName2' );
	}

}
// ## 2002.12.12 Add End
//-->
</SCRIPT>

<TITLE>���a�x�Ə��̌���</TITLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()" ONUNLOAD="JavaScript:closeWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="/webHains/contents/disease/perDiseaseList.asp" METHOD="get">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="mode"  VALUE="<%= strMode %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">���a�x�Ə��̌���</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD WIDTH="90" NOWRAP>�c��</TD>
			<TD>�F</TD>
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT �K�C�h�Ăяo���֐���ύX���܂���
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
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT �K�C�h�Ăяo���֐���ύX���܂���
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
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT �K�C�h�Ăяo���֐���ύX���܂���
			<TD><A HREF="javascript:callOrgRoomGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearOrgRoomCd()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
-->
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			<INPUT TYPE="hidden" NAME="orgRoomCd"  VALUE="<%= strOrgRoomCd %>">
			<TD><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD WIDTH=90" NOWRAP>����</TD>
			<TD>�F</TD>
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT �K�C�h�Ăяo���֐���ύX���܂���
			<TD><A HREF="javascript:callOrgPostGuide(1)"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearOrgPostCd(1)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
-->
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd1"  VALUE="<%= strOrgPostCd1 %>">
			<TD><SPAN ID="OrgPostName1"><%= strOrgPostName1 %></SPAN></TD>
			<TD>�`</TD>
<!-- ## 2002.12.12 Mod by T.Takagi@FSIT �K�C�h�Ăяo���֐���ύX���܂���
			<TD><A HREF="javascript:callOrgPostGuide(2)"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearOrgPostCd(2)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
-->
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			<INPUT TYPE="hidden" NAME="orgPostCd2"  VALUE="<%= strOrgPostCd2 %>">
			<TD><SPAN ID="OrgPostName2"><%= strOrgPostName2 %></SPAN></TD>
		</TR>
		<TR>
			<TD WIDTH='90"' NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:callPerGuide()"><IMG SRC="/webHains/images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�l�����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:clearPerInfo()"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�l���N���A"></A></TD>
			<INPUT TYPE="hidden" NAME="perId"  VALUE="<%= strPerID %>">
			<TD><SPAN ID="perName"><%= strLastName %>    <%= strFirstName %></SPAN></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD WIDTH="90" NOWRAP>�f�[�^�N��</TD>
			<TD>�F</TD>
			<TD><%= EditNumberList("dataYear", YEARRANGE_MIN, YEARRANGE_MAX, strDataYear , true) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("dataMonth", 1, 12, strDataMonth, true) %></TD>
			<TD>��</TD>
			<TD></TD>
			<TD>�\�������F</TD>
			<TD>
				<SELECT NAME="pageMaxLine">
					<OPTION VALUE="50"  <%= IIf(strPageMaxLine = 50,  "SELECTED", "")%>>50�s����
					<OPTION VALUE="100" <%= IIf(strPageMaxLine = 100, "SELECTED", "")%>>100�s����
					<OPTION VALUE="200" <%= IIf(strPageMaxLine = 200, "SELECTED", "" )%>>200�s����
					<OPTION VALUE="300" <%= IIf(strPageMaxLine = 300, "SELECTED", "" )%>>300�s����
					<OPTION VALUE="999999999" <%= IIf(strPageMaxLine = 999999999, "SELECTED", "" )%>>���ׂ�
				</SELECT>
			</TD>
			<TD WIDTH="50"></TD>
			<TD ALIGN="right" VALIGN="middle">
				<TABLE WIDTH="180" BORDER="0" CELLSPACING="0" CELLPADDING="0">
					<TR>
						<TD><A HREF="perDiseaseInfo.asp?mode=insert"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�������a�x�Ə���o�^���܂�"></A></TD>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return showPerDisease(5)"><IMG SRC="/webHains/images/b_search.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
						<TD></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
<% 
'-------------------------------------------------------------------------------
' �������ʂ̕\��
'-------------------------------------------------------------------------------
	Do
		'�����\�����[�h�Ȃ牽�����Ȃ�
		If strMode = "" Then Exit Do

		'�G���[���͉������Ȃ�
		If Not IsEmpty(vntMessage) Then Exit Do

		'�L���ȃf�[�^�N�����w�肳��Ă���ꍇ�A�ҏW
		strDataDate = strDataYear & "/" & strDataMonth & "/" & "1"
		If IsDate(strDataDate) = False Then
			strDataDate = ""
		End If

		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objPerDisease 	= Server.CreateObject("HainsPerDisease.PerDisease")

		'���a�x�Ə�񌏐��擾
		lngAllCount = objPerDisease.SelectPerDisease("CNT", _
													strDataDate,	_
													strPerID,		_
													strOrgCd1,		_
													strOrgCd2,		_
													strOrgBsdCd,	_
													strOrgRoomCd,	_
													strOrgPostCd1,	_
													strOrgPostCd2, "")
													
%>
		<BR>�������ʂ� <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>������܂����B<BR><BR>
<%
		'���R�[�h��񂪑��݂��Ȃ��ꍇ�A�����I��
		If lngAllCount = 0 Then
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
			<TR BGCOLOR="#cccccc"  ALIGN="CENTER">
				<TD NOWRAP ROWSPAN="2">�]�ƈ��ԍ�</TD>
				<TD NOWRAP ROWSPAN="2">���@�@��</TD>
				<TD NOWRAP ROWSPAN="2">�N��</TD>
				<TD NOWRAP COLSPAN="3" ALIGN="CENTER">���a���E�R�[�h</TD>
				<TD NOWRAP COLSPAN="2" ALIGN="CENTER">�x�Ə�</TD>
				<TD NOWRAP ROWSPAN="2">�x�ƊJ�n�N��</TD>
				<TD NOWRAP ROWSPAN="2">�×{<BR>�敪</TD>
				<TD NOWRAP ROWSPAN="2">�f�[�^�N��</TD>
				<TD ROWSPAN="2">����</TD>
				<TD NOWRAP ROWSPAN="2">����</TD>
				<TD NOWRAP ROWSPAN="2">�c��</TD>
			</TR>
			<TR BGCOLOR="#cccccc">
				<TD NOWRAP>���a��</TD>
				<TD NOWRAP>�p��</TD>
				<TD NOWRAP>���a�R�[�h</TD>
				<TD NOWRAP>�x�ɓ���</TD>
				<TD NOWRAP>���Γ���</TD>
			</TR>
<%
			'���a�x�Ə��擾
			lngCount = objPerDisease.SelectPerDisease("", _
														strDataDate,	_
														strPerID,		_
														strOrgCd1,		_
														strOrgCd2,		_
														strOrgBsdCd,	_
														strOrgRoomCd,	_
														strOrgPostCd1,	_
														strOrgPostCd2,	_
														"",               _
														lngStartPos, _
														strPageMaxLine, _
														arrPerId,		_
														arrEmpNo,		_
														arrLastName,	_
														arrFirstName,	_
														arrLastKName,	_
														arrFirstKName,	_
														arrBirth,		_
														arrAge,		_
														arrGender,		_
														arrOrgName,		_
														arrOrgPostName,	_
														arrDisCd,		_
														arrDisName,		_
														arrDataDate,	_
														arrOccurDate,	_
														arrHoliday,		_
														arrAbsence,		_
														arrContinues,	_
														arrMedicalDiv)

			strOldPerId = ""

			'���a�x�Ə��̕ҏW
			For i = 0 To lngCount - 1
%>
				<TR  BGCOLOR="#eeeeee">
<%
					If strOldPerId = arrPerId(i) Then
%>
						<TD NOWRAP></TD>
						<TD NOWRAP></TD>
						<TD NOWRAP></TD>
<%
					Else
%>
						<TD NOWRAP><%= arrEmpNo(i) %></TD>
						<TD NOWRAP><%= arrLastName(i) & "�@" & arrFirstName(i) %><FONT SIZE="-1" COLOR="#666666">�i<%= arrLastKName(i) & "�@" &  arrFirstKName(i) %>�j</FONT></TD>
						<TD NOWRAP><%= Int(arrAge(i)) %>��</TD>
<%
					End If

					strHtml = "perDiseaseInfo.asp?mode=update&perId=" & arrPerId(i) & "&dataYear=" & Year(arrDataDate(i)) & "&dataMonth=" & Month(arrDataDate(i)) & "&disCd=" & arrDisCd(i)
%>
					<TD NOWRAP><A HREF="<%= strHtml %>" ><%= arrDisName(i) %></A></TD>
					<TD NOWRAP><%= strDspContinue(arrContinues(i)) %></TD>
					<TD NOWRAP><%= arrDisCd(i) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= arrHoliday(i) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= arrAbsence(i) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= DatePart("yyyy", arrOccurDate(i)) & "�N" & DatePart("m", arrOccurDate(i)) & "��" %></TD>
					<TD NOWRAP><%= strDspMedicalDiv(arrMedicalDiv(i)) %></TD>
					<TD NOWRAP ALIGN="RIGHT"><%= DatePart("yyyy", arrDataDate(i)) & "�N" & DatePart("m", arrDataDate(i)) & "��" %></TD>
					<TD NOWRAP><%= arrGender(i) %></TD>
					<TD NOWRAP><%= arrOrgPostName(i) %></TD>
					<TD NOWRAP><%= arrOrgName(i) %></TD>
				</TR>
<%
				strOldPerId = arrPerId(i)
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop

	Set objPerDisease = Nothing

	'�y�[�W���O�i�r�Q�[�^�̕ҏW
	If IsNumeric(strPageMaxLine) Then
		lngGetCount = CLng(strPageMaxLine)
		strSearchString = ""
		strSearchString = strSearchString & "mode=print"
		strSearchString = strSearchString & "&orgCd1="      & strOrgCd1
		strSearchString = strSearchString & "&orgCd2="      & strOrgCd2
		strSearchString = strSearchString & "&orgBsdCd="    & strOrgBsdCd
		strSearchString = strSearchString & "&orgRoomCd="   & strOrgRoomCd
		strSearchString = strSearchString & "&orgPostCd1="  & strOrgPostCd1
		strSearchString = strSearchString & "&orgPostCd2="  & strOrgPostCd2
		strSearchString = strSearchString & "&perId="       & strPerID
		strSearchString = strSearchString & "&dataYear="    & strDataYear
		strSearchString = strSearchString & "&dataMonth="   & strDataMonth
		strSearchString = strSearchString & "&pageMaxLine=" & strPageMaxLine
%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?" & strSearchString, lngAllCount, lngStartPos, lngGetCount) %>
<%
	End If
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
