<% 
'-----------------------------------------------------------------------------
'		�ėp���̒��o (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
%>
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/EditJudList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
If Request.ServerVariables("HTTP_REFERER") = "" Then
	Response.End
End If

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objOrgBsd		'���ƕ����A�N�Z�X�p
Dim objOrgRoom		'�������A�N�Z�X�p
Dim objOrgPost		'�������A�N�Z�X�p

Dim strOrgSName			'�c�̗���
Dim strArrItemName		'�������ږ���
Dim strOrgName			'�c�̗���
Dim strOrgBsdName	    '���Ə���
Dim strOrgRoomName	    '������
Dim strOrgPostName1	    '�����P
Dim strOrgPostName2	    '�����Q

Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�c�̖��̎擾
If Trim(mstrOrgCd1) <> "" And Trim(mstrOrgCd2) <> "" Then
	Call objOrganization.SelectOrgName(mstrOrgCd1, mstrOrgCd2, strOrgName)
End If
'���ƕ�
If mstrOrgCd1 <> "" And mstrOrgCd2 <> "" And mstrOrgBsdCd <> "" Then
	objOrgBsd.SelectOrgBsd mstrOrgCd1, mstrOrgCd2, mstrOrgBsdCd, , strorgBsdName
End If
'����
If mstrOrgCd1 <> "" And mstrOrgCd2 <> "" And mstrOrgBsdCd <> "" And mstrOrgRoomCd <> "" Then
	objOrgRoom.SelectOrgRoom mstrOrgCd1, mstrOrgCd2, mstrOrgBsdCd, mstrOrgRoomCd, strOrgRoomName
End If
'����
If mstrOrgCd1 <> "" And mstrOrgCd2 <> "" And mstrOrgBsdCd <> "" And mstrOrgRoomCd <> "" And mstrOrgPostCd1 <> "" Then
	objOrgPost.SelectOrgPost mstrOrgCd1, mstrOrgCd2, mstrOrgBsdCd, mstrOrgRoomCd, mstrOrgPostCd1, strOrgPostName1
End If
If mstrOrgCd1 <> "" And mstrOrgCd2 <> "" And mstrOrgBsdCd <> "" And mstrOrgRoomCd <> "" And mstrOrgPostCd2 <> "" Then
	objOrgPost.SelectOrgPost mstrOrgCd1, mstrOrgCd2, mstrOrgBsdCd, mstrOrgRoomCd, mstrOrgPostCd2, strOrgPostName2
End If

'�������ږ��̂̎擾
ReDim strArrItemName(mlngRowCountItem - 1)
For i = 0 To mlngRowCountItem - 1
	'�������ڃR�[�h������Ζ��̂��擾�A������΋�
	If Trim(mstrArrItemCd(i)) <> "" Then
		Call objItem.SelectItemName(mstrArrItemCd(i), mstrArrSuffix(i), strArrItemName(i))
	'���̂͋�
	Else
		strArrItemName(i) = ""
	End If
Next
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���o�����̎w��</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/itmGuide.inc" -->
<!-- #include virtual = "/webHains/includes/dtlGuide.inc" -->

<!--
// �c�̃K�C�h�Ăяo��
function callOrgGuide() {

	orgGuide_showGuideOrg(document.step2.orgCd1, document.step2.orgCd2, 'orgname');

}

// �c�̃R�[�h�E���̂̃N���A
function clearOrgCd() {

	orgGuide_clearOrgInfo(document.step2.orgCd1, document.step2.orgCd2, 'orgname');

}


// ���ƕ��K�C�h�Ăяo��
function callOrgBsdGuide() {

	var objForm = document.step2;	// ����ʂ̃t�H�[���G�������g
	orgBsdGuide_showGuideOrgBsd( objForm.orgCd1, objForm.orgCd2, objForm.orgBsdCd, '' , 'orgBsdName', null , false );
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
	}

	if( strErrMsg != '' ){
		alert(strErrMsg);
		return ret;
	}

	return(true);
}


var lngSelectedIndex;	/* �K�C�h�\�����ɑI�����ꂽ�������ڂ̃C���f�b�N�X */

// ���ڃK�C�h�Ăяo��
function callItmGuide( index ) {

	// �I�����ꂽ���̃C���f�b�N�X��ޔ�
	lngSelectedIndex = index;

	// �K�C�h�Ɉ����n���f�[�^�̃Z�b�g
	itmGuide_mode     = 2;	// �˗��^���ʃ��[�h�@1:�˗��A2:����
	itmGuide_group    = 0;	// �O���[�v�\���L���@0:�\�����Ȃ��A1:�\������
	itmGuide_item     = 1;	// �������ڕ\���L���@0:�\�����Ȃ��A1:�\������
	itmGuide_question = 1;	// ��f���ڕ\���L���@0:�\�����Ȃ��A1:�\������

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	itmGuide_CalledFunction = setItmInfo;

	// ���ڃK�C�h�\��
	showGuideItm();

	return false;
}

// �������ڂ̃Z�b�g
function setItmInfo() {

	var itmNameElement = new Array;		/* �������ږ���ҏW����G�������g�̖��� */
	var itmName        = new Array;		/* �������ږ���ҏW����G�������g���g */
	var itmOK          = new Array;		/* �d�����Ă��Ȃ����ڂ̓Y�����̔z�� */
	var itmNG          = new Array;		/* �d�����Ă��鍀�ڂ̓Y�����̔z�� */
	var okFlg;							/* �d���`�F�b�N�t���O */
	var strAlert;						/* �A���[�g���b�Z�[�W */
	var i, j;							/* �C���f�b�N�X */
	var icount;							/* ���[�v�� */

	// ���łɑI���ς݂̍��ڂƂ̏d���`�F�b�N
	itmOK.length = 0; itmNG.length = 0;
	if ( itmGuide_itemCd.length > 0 ) {
		for (i = 0; i < itmGuide_itemCd.length; i++ ) {
			okFlg = true;
			j = 0;
			do {
				if ((itmGuide_itemCd[i] == document.step2.itemCd[j].value) && (itmGuide_suffix[i] == document.step2.suffix[j].value)) {
					okFlg = false;
					break;
				}
				j = j + 1;
			} while (j < <%= mlngRowCountItem %>)
			if (okFlg) {
				itmOK[itmOK.length] = i;
			}
			else {
				itmNG[itmNG.length] = i;
			}
		}
		// �d�����ڂ�����΃A���[�g�\��
		if (itmNG.length > 0) {
			strAlert = '�ȉ��̌������ڂ͂��łɑI������Ă��܂��B\n';
			for ( i = 0; i < itmNG.length; i++ ){
				strAlert = strAlert + '�E' + itmGuide_itemName[itmNG[i]] + '\n';
			}
			alert(strAlert);
		}
	} else {
		return false;
	}

	icount = <%= mlngRowCountItem %> - lngSelectedIndex;			/* ���[�v�񐔂��v�Z */

	// �\�ߑޔ������C���f�b�N�X��̌������ڏ��ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( itmGuide_itemCd.length > 0 ) {
		for (i = 0; i < icount; i++ ) {
			if (i < itmOK.length) {
				document.step2.itemCd[lngSelectedIndex + i].value = itmGuide_itemCd[itmOK[i]];
				document.step2.suffix[lngSelectedIndex + i].value = itmGuide_suffix[itmOK[i]];
			}
		}
	} else {
		return false;
	}

	// �u���E�U���Ƃ̌������ږ��ҏW�p�G�������g�̐ݒ菈��
	if ( itmGuide_itemCd.length > 0 ) {
		for ( ; ; ) {

			// �G�������g���̕ҏW
			for (i = 0; i < icount; i++) {
				if (i < itmOK.length) {
					itmNameElement[i] = 'itemname' + (lngSelectedIndex + i);
				}
			}

			// IE�̏ꍇ
			if ( document.all ) {
				for (i = 0; i < icount; i++) {
					if (i < itmOK.length) {
						document.all(itmNameElement[i]).innerHTML = itmGuide_itemName[itmOK[i]];
					}
				}
				break;
			}

			// Netscape6�̏ꍇ
			if ( document.getElementById ) {
				for (i = 0; i < icount; i++) {
					if (i < itmOK.length) {
						document.getElementById(itmNameElement[i]).innerHTML = itmGuide_itemName[itmOK[i]];
					}
				}
			}

			break;
		}
	}
	return false;
}

// �������ڃR�[�h�E���̂̃N���A
function clearItemCd( index ) {

	var itmNameElement;			/* �������ږ���ҏW����G�������g�̖��� */
	var itmName;				/* �������ږ���ҏW����G�������g���g */

	// hidden���ڂ̍Đݒ�
	document.step2.itemCd[index].value = '';
	document.step2.suffix[index].value = '';

	// �u���E�U���Ƃ̌������ږ��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		itmNameElement = 'itemname' + index;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(itmNameElement).innerHTML = '';
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(itmNameElement).innerHTML = '';
		}

		break;
	}

	return false;

}

// �������ڐ����Ăяo��
function callDtlGuide( index ) {

	var index;						/* �C���f�b�N�X */

	// ������ʂ̘A����ɉ�ʓ��͒l��ݒ肷��
	dtlGuide_ItemCd       = document.step2.itemCd[index].value;
	dtlGuide_Suffix       = document.step2.suffix[index].value;
	dtlGuide_CsCd         = document.step2.csCd.options[document.step2.csCd.selectedIndex].value;
	dtlGuide_CslDateYear  = '';
	dtlGuide_CslDateMonth = '';
	dtlGuide_CslDateDay   = '';
	dtlGuide_Age          = '';
	dtlGuide_Gender       = document.step2.gender.options[document.step2.gender.selectedIndex].value;
	if (dtlGuide_Gender == '0') {
		dtlGuide_Gender = '';		/* ���ʎw�薳���̎� */
	}

	// �������ڐ����\��
	showGuideDtl();

	return false;
}

// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.step2 ) {
//		orgPostGuide_getElement( orgCd1, orgCd2, 'orgname', orgBsdCd, 'orgBsdName', orgRoomCd, 'orgRoomName', orgPostCd1, 'OrgPostName1', orgPostCd2, 'OrgPostName2' );
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgname', '', '', '', '', '', '', '', '' );

	}

}
//-->

</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY  ONLOAD="javascript:setElement()" ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="step2" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="edit" VALUE="">
	<INPUT TYPE="hidden" NAME="step" VALUE="<%= mstrStep %>">

	<INPUT TYPE="hidden" NAME="chkDate"   VALUE="<%= mstrChkDate %>"  >
	<INPUT TYPE="hidden" NAME="chkCsCd"   VALUE="<%= mstrChkCsCd %>"  >
	<INPUT TYPE="hidden" NAME="chkOrgCd"  VALUE="<%= mstrChkOrgCd %>" >
	<INPUT TYPE="hidden" NAME="chkOrgBsdCd"  VALUE="<%= mstrChkOrgBsdCd %>" >
	<INPUT TYPE="hidden" NAME="chkOrgRoomCd"  VALUE="<%= mstrChkOrgRoomCd %>" >
	<INPUT TYPE="hidden" NAME="chkOrgPostCd"  VALUE="<%= mstrChkOrgPostCd %>" >
	<INPUT TYPE="hidden" NAME="chkAge"    VALUE="<%= mstrChkAge %>"   >
	<INPUT TYPE="hidden" NAME="chkJud"    VALUE="<%= mstrChkJud %>"   >
	<INPUT TYPE="hidden" NAME="chkPerID"  VALUE="<%= mstrChkPerID %>" >
	<INPUT TYPE="hidden" NAME="chkName"   VALUE="<%= mstrChkName %>"  >
	<INPUT TYPE="hidden" NAME="chkBirth"  VALUE="<%= mstrChkBirth %>" >
	<INPUT TYPE="hidden" NAME="chkGender" VALUE="<%= mstrChkGender %>">
	<INPUT TYPE="hidden" NAME="optResult" VALUE="<%= mstrOptResult %>">
	<INPUT TYPE="hidden" NAME="rowCount"  VALUE="<%= mlngRowCount %>" >
	<INPUT TYPE="hidden" NAME="chkPEmpNo"  VALUE="<%= mstrChkEmpNo %>" >
	<INPUT TYPE="hidden" NAME="chkPOrgCd"  VALUE="<%= mstrChkPOrgCd %>" >
	<INPUT TYPE="hidden" NAME="chkPOrgBsdCd"  VALUE="<%= mstrChkPOrgBsdCd %>" >
	<INPUT TYPE="hidden" NAME="chkPOrgRoomCd"  VALUE="<%= mstrChkPOrgRoomCd %>" >
	<INPUT TYPE="hidden" NAME="chkPOrgPostCd"  VALUE="<%= mstrChkPOrgPostCd %>" >
	<INPUT TYPE="hidden" NAME="chkOverTime"  VALUE="<%= mstrChkOverTime %>" >
	<% For i = 0 To mlngRowCount - 1 %>
		<INPUT TYPE="hidden" NAME="selItemCd" VALUE="<%= mstrArrSelItemCd(i) %>">
		<INPUT TYPE="hidden" NAME="selSuffix" VALUE="<%= mstrArrSelSuffix(i) %>">
	<% Next %>
	<INPUT TYPE="hidden" NAME="chkOption" VALUE="<%= mstrChkOption %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="download">��</SPAN><FONT COLOR="#000000">���o�����̎w��</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'���b�Z�[�W�̕ҏW
	If Not IsEmpty(strArrMessage) Then
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	Else
		If mstrEdit = "on" And mlngCount = 0 Then
			Call EditMessage("�w��̃f�[�^�͂���܂���ł����", MESSAGETYPE_NORMAL)
		End If
	End If
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">��f������</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
						<TD NOWRAP>��f��</TD>
						<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>
							<%= EditSelectYearList(YEARS_SYSTEM, "strYear", mlngStrYear) %>�N
							<%= EditSelectNumberList("strMonth", 1, 12, mlngStrMonth) %>��
							<%= EditSelectNumberList("strDay",   1, 31, mlngStrDay  ) %>���`
							<%= EditSelectYearList(YEARS_SYSTEM, "endYear", mlngEndYear) %>�N
							<%= EditSelectNumberList("endMonth", 1, 12, mlngEndMonth) %>��
							<%= EditSelectNumberList("endDay",   1, 31, mlngEndDay  ) %>��
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
						<TD NOWRAP>�R�[�X</TD>
						<TD>�F</TD>
			<TD>
				<%= EditCourseList("csCd", mstrCsCd, SELECTED_ALL) %>
			</TD>
		</TR>
<!--
					<tr>
						<td nowrap>�T�u�R�[�X</td>
						<td>�F</td>
						<td><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_SUB, "SubcsCd", Empty, NON_SELECTED_ADD, False) %></td>
					</tr>
-->
					<TR>
						<TD NOWRAP>�c��</TD>
						<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
						<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return clearOrgCd()"  ><IMG SRC="../../images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"  ></A></TD>
						<TD WIDTH="5"></TD>
						<TD WIDTH="300">
							<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= mstrOrgCd1 %>">
							<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= mstrOrgCd2 %>">
							<SPAN ID="orgname"><%= strOrgName %></SPAN>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<!--
		<TR>
			<TD NOWRAP>���ƕ�</TD>
			<TD>�F</TD>
			<TD><TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TD><A HREF="javascript:orgPostGuide_showGuideOrgBsd()"><IMG SRC="/webHains/images/question.gif" BORDER="0"  WIDTH="21" HEIGHT="21" ALT="���ƕ������K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgBsdInfo()"><IMG SRC="/webHains/images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="���Ə����N���A"></A></TD>
			<INPUT TYPE="hidden" NAME="orgBsdCd"  VALUE="<%= mstrOrgBsdCd %>">
			<TD><SPAN ID="orgBsdName"><%= strOrgBsdName %></SPAN></TD>
			</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>����</TD>
			<TD>�F</TD>
			<TD >
			  <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			    <TD><A HREF="javascript:orgPostGuide_showGuideOrgRoom()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			    <TD><A HREF="javascript:orgPostGuide_clearOrgRoomInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			      <INPUT TYPE="hidden" NAME="orgRoomCd"  VALUE="<%= mstrOrgRoomCd %>">
			    <TD><SPAN ID="orgRoomName"><%= strOrgRoomName %></SPAN></TD>
			  </TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>����</TD>
			<TD>�F</TD>
			<TD>
			  <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			    <TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			    <TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			      <INPUT TYPE="hidden" NAME="orgPostCd1"  VALUE="<%= mstrOrgPostCd1 %>">
			    <TD><SPAN ID="OrgPostName1"><%= strOrgPostName1 %></SPAN></TD>
			    <TD ALIGN="left">�`</TD>
			    <TD><A HREF="javascript:orgPostGuide_showGuideOrgPost(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���������K�C�h��\��"></A></TD>
			    <TD><A HREF="javascript:orgPostGuide_clearOrgPostInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�������N���A"></A></TD>
			      <INPUT TYPE="hidden" NAME="orgPostCd2"  VALUE="<%= mstrOrgPostCd2 %>">
			    <TD><SPAN ID="OrgPostName2"><%= strOrgPostName2 %></SPAN></TD>
			  </TABLE>
			</TD>
		</TR>
-->
			<TR>
			<TD NOWRAP>��f���N��</TD>
			<TD>�F</TD>
			<TD><TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TD><%= EditSelectNumberList("strAgeY", 0, 150, CLng(IIf(mstrStrAgeY = "", "-1", mstrStrAgeY))) %></TD>
						<TD>�D</TD>
						<TD><%= EditSelectNumberList("strAgeM", 0,  11, CLng(IIf(mstrStrAgeM = "", "-1", mstrStrAgeM))) %></TD>
						<TD>�Έȏ�</TD>
						<TD><%= EditSelectNumberList("endAgeY", 0, 150, CLng(IIf(mstrEndAgeY = "", "-1", mstrEndAgeY))) %></TD>
						<TD>�D</TD>
						<TD><%= EditSelectNumberList("endAgeM", 0,  11, CLng(IIf(mstrEndAgeM = "", "-1", mstrEndAgeM))) %></TD>
						<TD>�Έȉ�</TD>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>����</TD>
			<TD>�F</TD>
			<TD><TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><%= EditGenderList("gender", CStr(mlngGender), NON_SELECTED_DEL) %></TD>
				</TR>
			  </TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">��������</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
		For i = 0 To mlngRowCountItem - 1
%>
			<TR>
				<TD>
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return callItmGuide(<%= i %>)"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="���ڃK�C�h��\��"  ></A>
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return clearItemCd(<%= i %>)" ><IMG SRC="../../images/delicon.gif"  BORDER="0" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A>
				</TD>
				<TD WIDTH="90" NOWRAP>
					<INPUT TYPE="hidden" NAME="itemCd" VALUE="<%= mstrArrItemCd(i) %>">
					<INPUT TYPE="hidden" NAME="suffix" VALUE="<%= mstrArrSuffix(i) %>">
					<A HREF="javascript:function voi(){};voi()" ONCLICK="return callDtlGuide('<%= i %>')"><SPAN ID="itemname<%= i %>"><%= strArrItemName(i) %></SPAN></A>
				</TD>
				<TD>�̌������ʂ�</TD>
				<TD><INPUT TYPE="text" NAME="rslValueFrom" SIZE="12" MAXLENGTH="8" VALUE="<%= mstrArrRslValueFrom(i) %>"></TD>
				<TD><%= EditSignList("rslSignFrom", mstrArrRslMarkFrom(i), NON_SELECTED_ADD) %></TD>
				<TD>�`</TD>
				<TD><INPUT TYPE="text" NAME="rslValueTo"   SIZE="12" MAXLENGTH="8" VALUE="<%= mstrArrRslValueTo(i) %>"  ></TD>
				<TD><%= EditSignList("rslSignTo",   mstrArrRslMarkTo(i),   NON_SELECTED_ADD) %></TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD ALIGN="right" COLSPAN="8">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>�ǉ��������ڂ�&nbsp;</TD>
						<TD>
							<SELECT NAME="rowCountItem">
							<% For i = 10 To 50 Step 10 %>
								<OPTION VALUE="<%= i %>" <%= IIf(i = mlngRowCountItem, "SELECTED", "") %>><%= i %>��
							<% Next %>
							</SELECT>
						</TD>
						<TD>
							<INPUT TYPE="image" NAME="change" ONCLICK="document.step2.edit.value='';" SRC="../../images/b_prev.gif" BORDER="0" WIDTH="53" HEIGHT="28" ALT="�\��">
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD BGCOLOR="#eeeeee">��������</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="radio" NAME="judAll" VALUE="0" <%= IIf(mlngJudAll = 0, "CHECKED", "") %>></TD>
			<TD>���ׂĂ̔��蕪�ނ𒊏o</TD>
			<TD><INPUT TYPE="radio" NAME="judAll" VALUE="1" <%= IIf(mlngJudAll = 1, "CHECKED", "") %>></TD>
			<TD>�ȉ��̏����𖞂������蕪�ނ݂̂𒊏o</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
<%
		For i = 0 To mlngRowCountJud - 1
%>
			<TR>
				<TD><%= EditJudClassList("judClass", mstrArrJudClassCd(i), NON_SELECTED_ADD) %></TD>
				<TD>�̔��茋�ʂ�</TD>
				<TD><%= EditJudList("judValueFrom", mstrArrJudValueFrom(i)) %></TD>
				<TD><%= EditSignList("judSignFrom", mstrArrJudMarkFrom(i), NON_SELECTED_ADD) %></TD>
				<TD>�`</TD>
				<TD><%= EditJudList("judValueTo",   mstrArrJudValueTo(i)) %></TD>
				<TD><%= EditSignList("judSignTo",   mstrArrJudMarkTo(i),   NON_SELECTED_ADD) %></TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD COLSPAN="3">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="radio" NAME="judOperation" VALUE="0" <%= IIf(mlngJudOperation = 0, "CHECKED", "") %>></TD>
						<TD>AND</TD>
						<TD><INPUT TYPE="radio" NAME="judOperation" VALUE="1" <%= IIf(mlngJudOperation = 1, "CHECKED", "") %>></TD>
						<TD>OR</TD>
					</TR>
				</TABLE>
			</TD>
			<TD ALIGN="right" COLSPAN="5">
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD>�ǉ������&nbsp;</TD>
						<TD>
							<SELECT NAME="rowCountJud">
							<% For i = 5 To 20 Step 5 %>
								<OPTION VALUE="<%= i %>" <%= IIf(i = mlngRowCountJud, "SELECTED", "") %>><%= i %>��
							<% Next %>
							</SELECT>
						</TD>
						<TD>
							<INPUT TYPE="image" NAME="change" ONCLICK="document.step2.edit.value='';" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��">
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>
	<A HREF="javascript:function voi(){};voi()" ONCLICK="document.step2.edit.value='on';document.step2.submit();return false;"><IMG SRC="/webHains/images/DataSelect.gif"></A></TD>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>