<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �t�H���[�A�b�v�͂������ (Ver0.0.1)
'	   AUTHER  : T.Yaguchi@ORB
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p
Dim objOrg			'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objPrtFollowCard		'�t�H���[�A�b�v�͂����A�N�Z�X�p

Dim strMode				'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strMessage			'�G���[���b�Z�[�W

Dim strKey              	'�����L�[
Dim strArrKey              	'�����L�[(�󔒂ŕ�����̃L�[�j
Dim strStrCslDate     		'����������f�N�����i�J�n�j
Dim strStrCslYear     		'����������f�N�i�J�n�j
Dim strStrCslMonth     		'����������f���i�J�n�j
Dim strStrCslDay     		'����������f���i�J�n�j
Dim strEndCslDate     		'����������f�N�����i�I���j
Dim strEndCslYear     		'����������f�N�i�I���j
Dim strEndCslMonth     		'����������f���i�I���j
Dim strEndCslDay     		'����������f���i�I���j
Dim strStrSecDate     		'���������񎟔N�����i�J�n�j
Dim strStrSecYear     		'���������񎟔N�i�J�n�j
Dim strStrSecMonth     		'���������񎟌��i�J�n�j
Dim strStrSecDay     		'���������񎟓��i�J�n�j
Dim strEndSecDate     		'���������񎟔N�����i�I���j
Dim strEndSecYear     		'���������񎟔N�i�I���j
Dim strEndSecMonth     		'���������񎟌��i�I���j
Dim strEndSecDay     		'���������񎟓��i�I���j
Dim strSecKbn     		'���������񎟓��t���O(1:���\��)
Dim strOrgCd1		   	'���������c�̃R�[�h�P
Dim strOrgCd2		   	'���������c�̃R�[�h�Q
Dim strOrgName		   	'���������c�̖�

Dim strOrgGrpCd			'�c�̃O���[�v�R�[�h
Dim strCsCd			'�R�[�X�R�[�h
Dim strPerId
Dim strPerName

'Dim strPerId		   	'���������l�h�c
'Dim strPerName		   	'���������l��
Dim strLastName         	'����������
Dim strFirstName        	'����������

Dim vntRsvNo			'�\��ԍ�
Dim vntCslDate			'��f��
Dim vntDayId			'����ID
Dim vntCsname			'�R�[�X��
Dim vntWebColor			'�R�[�X�J���[
Dim vntPerId			'�lID
Dim vntPerKName			'�J�i����
Dim vntPerName			'����
Dim vntGender			'����
Dim vntBirth			'���N����
Dim vntOrgSName			'�c�̗���
Dim vntPosCardPrintDate		'�o�͓���
Dim vntUserName			'�X�V�Җ�

Dim lngAllCount			'����
Dim lngRsvAllCount		'�d���\��Ȃ�����
Dim lngGetCount			'����
Dim i				'�J�E���^
Dim j

Dim lngStartPos			'�\���J�n�ʒu
Dim lngPageMaxLine		'�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()		'�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName()	'�P�y�[�W�\���l�`�w�s���̔z��

Dim lngArrMailMode()		'�͂��������Ԃ̔z��
Dim strArrMailModeName()	'�͂��������Ԗ��̔z��

Dim lngMailMode			'�͂��������Ԃ̌��ݒl

Dim Ret				'�֐��߂�l
Dim strURL			'�W�����v���URL

'��ʕ\������p��������
Dim strBeforeRsvNo		'�O�s�̗\��ԍ�

Dim strWebCslDate		'��f��
Dim strWebDayId			'����ID
Dim strWebCsInfo		'�R�[�X��
Dim strWebPerId			'�lID
Dim strWebPerName		'�J�i�����E����
Dim strWebGender		'����
Dim strWebBirth			'���N����
Dim strWebOrgName		'�c�̗���
Dim strWebPosCardPrintDate	'�o�͓���
Dim strWebRsvNo			'�\��ԍ�
Dim strWebUserName		'�X�V�Җ�

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon        = Server.CreateObject("HainsCommon.Common")
Set objConsult       = Server.CreateObject("HainsConsult.Consult")
Set objOrg           = Server.CreateObject("HainsOrganization.Organization")
Set objPerson        = Server.CreateObject("HainsPerson.Person")
Set objPrtFollowCard = Server.CreateObject("HainsprtFollowCard.prtFollowCard")

'�����l�̎擾
strMode           = Request("mode")
strAction         = Request("action")
strStrCslYear     = Request("strCslYear")
strStrCslMonth    = Request("strCslMonth")
strStrCslDay      = Request("strCslDay")
strEndCslYear     = Request("endCslYear")
strEndCslMonth    = Request("endCslMonth")
strEndCslDay      = Request("endCslDay")
strStrSecYear     = Request("strSecYear")
strStrSecMonth    = Request("strSecMonth")
strStrSecDay      = Request("strSecDay")
strEndSecYear     = Request("endSecYear")
strEndSecMonth    = Request("endSecMonth")
strEndSecDay      = Request("endSecDay")
strSecKbn         = IIf(Request("secKbn") = "", 0, Request("secKbn"))
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
'strKey            = Request("textKey")
strPerId          = Request("perId")
lngStartPos       = Request("startPos")
lngPageMaxLine    = Request("pageMaxLine")
lngMailMode       = IIf(Request("mailMode")="", 1, Request("mailMode"))
strCsCd           = Request("csCd")
strOrgGrpCd       = Request("OrgGrpCd")

'�f�t�H���g�̓V�X�e���N������K�p����
If strStrCslYear = "" And strStrCslMonth = "" And strStrCslDay = "" Then
	strStrCslYear  = CStr(Year(Now))
	strStrCslMonth = CStr(Month(Now))
	strStrCslDay   = CStr(Day(Now))
End If
If strEndCslYear = "" And strEndCslMonth = "" And strEndCslDay = "" Then
	strEndCslYear  = strStrCslYear
	strEndCslMonth = strStrCslMonth
	strEndCslDay   = strStrCslDay
End If
If strAction <> "search" Then
	If strStrSecYear = "" And strStrSecMonth = "" And strStrSecDay = "" Then
		strStrSecYear  = CStr(Year(Now))
		strStrSecMonth = CStr(Month(Now))
		strStrSecDay   = CStr(Day(Now))
	End If
	If strEndSecYear = "" And strEndSecMonth = "" And strEndSecDay = "" Then
		strEndSecYear  = strStrSecYear
		strEndSecMonth = strStrSecMonth
		strEndSecDay   = strStrSecDay
	End If
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Call CreatePageMaxLineInfo()

Do

	'�����{�^���N���b�N
	If strAction = "search" Then

		'��f��(��)�̓��t�`�F�b�N
		If strStrCslYear <> 0 Or strStrCslMonth <> 0 Or strStrCslDay <> 0 Then
			If Not IsDate(strStrCslYear & "/" & strStrCslMonth & "/" & strStrCslDay) Then
				strMessage = "��f���̎w��Ɍ�肪����܂��B"
				Exit Do
			End If
		End If

		'��f��(��)�̓��t�`�F�b�N
		If strEndCslYear <> 0 Or strEndCslMonth <> 0 Or strEndCslDay <> 0 Then
			If Not IsDate(strEndCslYear & "/" & strEndCslMonth & "/" & strEndCslDay) Then
				strMessage = "��f���̎w��Ɍ�肪����܂��B"
				Exit Do
			End If
		End If

		'��f��(��)�̓��t�`�F�b�N
		If strStrSecYear <> "" Or strStrSecMonth <> "" Or strStrSecDay <> "" Then
			If Not IsDate(strStrSecYear & "/" & strStrSecMonth & "/" & strStrSecDay) Then
				strMessage = "��f���̎w��Ɍ�肪����܂��B"
				Exit Do
			End If
		End If

		'��f��(��)�̓��t�`�F�b�N
		If strEndSecYear <> "" Or strEndSecMonth <> "" Or strEndSecDay <> "" Then
			If Not IsDate(strEndSecYear & "/" & strEndSecMonth & "/" & strEndSecDay) Then
				strMessage = "��f���̎w��Ɍ�肪����܂��B"
				Exit Do
			End If
		End If

		'�����J�n�I����f���̕ҏW
		strStrCslDate = CDate(strStrCslYear & "/" & strStrCslMonth & "/" & strStrCslDay)
		strEndCslDate = CDate(strEndCslYear & "/" & strEndCslMonth & "/" & strEndCslDay)

		''�P�N�ȓ����`�F�b�N
		If strEndCslDate - strStrCslDate > 366 Then
			strMessage = "��f���͂P�N�ȓ����w�肵�ĉ������B"
			Exit Do
		End If

		If strStrSecYear <> "" And strStrSecMonth <> "" And strStrSecDay <> "" Then
			strStrSecDate = CDate(strStrSecYear & "/" & strStrSecMonth & "/" & strStrSecDay)
		Else
			strStrSecDate = 0
		End If
		If strEndSecYear <> "" And strEndSecMonth <> "" And strEndSecDay <> "" Then
			strEndSecDate = CDate(strEndSecYear & "/" & strEndSecMonth & "/" & strEndSecDay)
		Else
			strEndSecDate = 0
		End If

		'�S�����擾����
		lngRsvAllCount = objPrtFollowCard.GetData(strStrCslDate, strEndCslDate, _
				                       strStrSecDate, strEndSecDate, _
				                       strSecKbn, strCsCd, _
				                       strOrgCd1, strOrgCd2, _
				                       strPerId, lngMailMode, _
				                       lngPageMaxLine, lngStartPos, _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       , , _
				                       True _
                				      )

		If lngRsvAllCount > 0 Then

			lngAllCount = objPrtFollowCard.GetData(strStrCslDate, strEndCslDate, _
				                       		  strStrSecDate, strEndSecDate, _
				                       		  strSecKbn, strCsCd, _
					                          strOrgCd1, strOrgCd2, _
					                          strPerId, lngMailMode, _
					                          lngPageMaxLine, lngStartPos, _
					                          vntRsvNo, vntCslDate, _
					                          vntDayId, vntCsname, _
					                          vntWebColor, vntPerId, _
					                          vntPerKName, vntPerName, _
					                          vntGender, vntBirth, _
					                          vntOrgSName, vntPosCardPrintDate, _
					                          , , _
					                          , , _
					                          False, , _
							          vntUserName _
	                					 )


		End If

		'�c�̃R�[�h����H
		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			ObjOrg.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , strOrgName 
		Else
			strOrgName = ""
		End If 

		'�lID�̎w�肪����ꍇ�A���̎擾
		If strPerId <> "" Then
			ObjPerson.SelectPerson_lukes strPerId, strLastName, strFirstName 
			strPerName = strLastName & "�@" & strFirstName
		Else
			strPerName = ""
		End If 

	End If

	Exit Do
Loop

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
Sub CreatePageMaxLineInfo()


	Redim Preserve lngArrPageMaxLine(3)
	Redim Preserve strArrPageMaxLineName(3)

	Redim Preserve lngArrMailMode(2)
	Redim Preserve strArrMailModeName(2)

	lngArrPageMaxLine(0) = 20:strArrPageMaxLineName(0) = "20�s����"
	lngArrPageMaxLine(1) = 50:strArrPageMaxLineName(1) = "50�s����"
	lngArrPageMaxLine(2) = 100:strArrPageMaxLineName(2) = "100�s����"
	lngArrPageMaxLine(3) = 999:strArrPageMaxLineName(3) = "���ׂ�"

	lngArrMailMode(0)     = 0
	strArrMailModeName(0) = "�S��"

	lngArrMailMode(1)     = 1
	strArrMailModeName(1) = "���o�͂̂�"

	lngArrMailMode(2)     = 2
	strArrMailModeName(2) = "�o�͍ς݂̂�"


End Sub
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�t�H���[�A�b�v�͂������</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �����{�^���N���b�N
function searchClick() {

	with ( document.entryFollowMailInfo ) {
		startPos.value = 1;
		action.value = 'search';
		submit();
	}

	return false;

}

// �`�F�b�N�{�b�N�X�̒l����
function checkClick(selObj) {

	var myForm = document.entryFollowMailInfo;	// ����ʂ̃t�H�[���G�������g

	if (selObj.checked) {
		selObj.value = '1'
	} else {
		selObj.value = '0'
	}

}

// �t�H���[�A�b�v�͂��������ʌĂяo��
function followCardPrint() {
	var url;							// URL������
	var mainForm = document.entryFollowMailInfo;			// ���C����ʂ̃t�H�[���G�������g

	url = '/WebHains/contents/print/prtFollowCard.asp?';
	url = url + 'mode=' + '0';
	url = url + '&strCslYear=' + mainForm.strCslYear.value;
	url = url + '&strCslMonth=' + mainForm.strCslMonth.value;
	url = url + '&strCslDay=' + mainForm.strCslDay.value;
	url = url + '&endCslYear=' + mainForm.endCslYear.value;
	url = url + '&endCslMonth=' + mainForm.endCslMonth.value;
	url = url + '&endCslDay=' + mainForm.endCslDay.value;
	url = url + '&strSecYear=' + mainForm.strSecYear.value;
	url = url + '&strSecMonth=' + mainForm.strSecMonth.value;
	url = url + '&strSecDay=' + mainForm.strSecDay.value;
	url = url + '&endSecYear=' + mainForm.endSecYear.value;
	url = url + '&endSecMonth=' + mainForm.endSecMonth.value;
	url = url + '&endSecDay=' + mainForm.endSecDay.value;
	url = url + '&secKbn=' + mainForm.secKbn.value;
	url = url + '&csCd=' + mainForm.csCd.value;
	url = url + '&orgCd1=' + mainForm.orgCd1.value;
	url = url + '&orgCd2=' + mainForm.orgCd2.value;
	url = url + '&perId=' + mainForm.perId.value;
	url = url + '&mailMode=' + mainForm.mailMode.value;

	parent.location.href(url);

}
// �A�����[�h���̏���
function closeGuideWindow() {

	// �c�̌����K�C�h�����
	orgGuide_closeGuideOrg();

	// �l�����K�C�h�����
	perGuide_closeGuidePersonal();

	//���t�K�C�h�����
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryFollowMailInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="action" VALUE=""> 
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<% = lngStartPos %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v�͂������</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
	<TR>
		<TD>�ꎟ���f��f��</TD>
		<TD>�F</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<!--<TD><A HREF="javascript:calGuide_clearDate('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>-->
					<TD><%= EditSelectNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStrCslYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("strCslMonth", 1, 12, Clng("0" & strStrCslMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("strCslDay",   1, 31, Clng("0" & strStrCslDay  )) %></TD>
					<TD>&nbsp;���`&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<!--<TD><A HREF="javascript:calGuide_clearDate('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>-->
					<TD><%= EditSelectNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndCslYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("endCslMonth", 1, 12, Clng("0" & strEndCslMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("endCslDay",   1, 31, Clng("0" & strEndCslDay  )) %></TD>
					<TD>&nbsp;��</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>�񎟌��f��f��</TD>
		<TD>�F</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strSecYear', 'strSecMonth', 'strSecDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><A HREF="javascript:calGuide_clearDate('strSecYear', 'strSecMonth', 'strSecDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
					<TD><%= EditSelectNumberList("strSecYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStrSecYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("strSecMonth", 1, 12, Clng("0" & strStrSecMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("strSecDay",   1, 31, Clng("0" & strStrSecDay  )) %></TD>
					<TD>&nbsp;���`&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endSecYear', 'endSecMonth', 'endSecDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><A HREF="javascript:calGuide_clearDate('endSecYear', 'endSecMonth', 'endSecDay')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
					<TD><%= EditSelectNumberList("endSecYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndSecYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("endSecMonth", 1, 12, Clng("0" & strEndSecMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("endSecDay",   1, 31, Clng("0" & strEndSecDay  )) %></TD>
					<TD>&nbsp;��</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>���\���</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="checkbox" NAME="secKbn" VALUE="<%=strSecKbn%>" <%= IIf(strSecKbn = "1", " CHECKED","") %> ONCLICK="javascript:checkClick(this)">�񎟌��f�\�񂵂Ă��Ȃ�����f�҂��ΏۂƂ���B</TD>
	</TR>
	<TR>
		<TD NOWRAP>�R�[�X</TD>
		<TD>�F</TD>
		<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, NON_SELECTED_ADD, False) %></TD>
	</TR>
	<TR>
		<TD>�c��</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryFollowMailInfo.orgCd1, document.entryFollowMailInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="�c�̌����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryFollowMailInfo.orgCd1, document.entryFollowMailInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
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
<!--
		<TD NOWRAP COLSPAN="2">�c�̃O���[�v�F<%= EditOrgGrp_PList("OrgGrpCd", strOrgGrpCd, NON_SELECTED_ADD) %></TD>
-->
	</TR>
	<TR>
		<TD>�lID</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryFollowMailInfo.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryFollowMailInfo.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
						<INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
						<SPAN ID="perName"><%= strPerName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD>�͂���</TD>
		<TD>�F</TD>
		<TD><%= EditDropDownListFromArray("mailMode", lngArrMailMode, strArrMailModeName, lngMailMode, NON_SELECTED_DEL) %>�@</TD>
		<TD><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %>�@</TD>
		<TD><A HREF="javascript:searchClick()"><IMG SRC="../../images/b_search.gif" ALT="���̏����Ō���" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
	</TR>
</TABLE>
<BR>
<!--�����͌�����������-->
<%
	Do
		'���b�Z�[�W���������Ă���ꍇ�͕ҏW���ď����I��
		If strMessage <> "" Then
%>
			<BR>&nbsp;<%= strMessage %>
<%
			Exit Do
		End If

		If strAction <> "" Then
%>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>
				<SPAN STYLE="font-size:9pt;">
				�u<FONT COLOR="#ff6600"><B><%= strStrCslYear %>�N<%= strStrCslMonth %>��<%= strStrCslDay %>���`<%= strEndCslYear %>�N<%= strEndCslMonth %>��<%= strEndCslDay %>��</B></FONT>�v�̂͂���������ꗗ��\�����Ă��܂��B<BR>
						�������ʂ�<FONT COLOR="#ff6600"><B><%= lngRsvAllCount %></B></FONT>���i�͂����ΏێҒP�ʁj�ł��B 
				</SPAN>
			</TD>
<%
		If lngRsvAllCount > 0 Then
%>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="1"></TD>
			<!--<TD><A HREF="javascript:setReportSendDateClr()"><IMG SRC="../../images/save.gif" ALT="�����m�F�������N���A" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>-->
			<TD><A HREF="javascript:followCardPrint()"><IMG SRC="../../images/print.gif" ALT="������܂�" HEIGHT="24" WIDTH="77" BORDER="0"></A></TD>
<%
		End If
%>
		</TR>

	<BR><BR>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
		<TR BGCOLOR="silver">
			<TD ALIGN="left" NOWRAP>��f��</TD>
			<TD ALIGN="left" NOWRAP>�����h�c</TD>
			<TD ALIGN="left" NOWRAP>�R�[�X</TD>
			<TD ALIGN="left" NOWRAP>�l�h�c</TD>
			<TD ALIGN="left" NOWRAP>��f�Җ�</TD>
			<TD ALIGN="left" NOWRAP>����</TD>
			<TD ALIGN="left" NOWRAP>���N����</TD>
			<TD ALIGN="left" NOWRAP>�c�̖�</TD>
			<TD ALIGN="left" NOWRAP>�͂����o�͓�</TD>
			<TD ALIGN="left" NOWRAP>�\��ԍ�</TD>
			<TD ALIGN="left" NOWRAP>�o�͎�</TD>
		</TR>
	<%
		End If

		If lngAllCount > 0 Then
			strBeforeRsvNo = ""

			For i = 0 To UBound(vntCslDate)

				strWebCslDate		= ""
				strWebDayId		= ""
				strWebCsInfo		= ""
				strWebPerId		= ""
				strWebPerName		= ""
				strWebGender		= ""
				strWebBirth		= ""
				strWebOrgName		= ""
				strWebPosCardPrintDate	= vntPosCardPrintDate(i)
				strWebRsvNo		= ""
				strWebUserName		= vntUserName(i)

				If strBeforeRsvNo <> vntRsvNo(i) Then

					strWebCslDate		= vntCslDate(i)
					strWebDayId		= objCommon.FormatString(vntDayId(i), "0000")
					strWebCsInfo		= "<FONT COLOR=""#" & vntwebColor(i) & """>��</FONT>" & vntCsName(i) 
					strWebPerId		= vntPerId(i)
					strWebPerName		= "<SPAN STYLE=""font-size:9px;"">" & vntPerKName(i) & "</SPAN><BR>" & vntPerName(i)
					strWebGender		= vntGender(i)
					strWebBirth		= vntBirth(i)
					strWebOrgName		= vntOrgSName(i)
					strWebRsvNo		= vntRsvNo(i)

				End If
%>
				<TR HEIGHT="18" BGCOLOR="#eeeeee">
					<TD NOWRAP><%= strWebCslDate          %></TD>
					<TD NOWRAP><%= strWebDayId            %></TD>
					<TD NOWRAP><%= strWebCsInfo           %></TD>
					<TD NOWRAP><%= strWebPerId            %></TD>
					<TD NOWRAP><%= strWebPerName          %></TD>
					<TD NOWRAP><%= strWebGender           %></TD>
					<TD NOWRAP><%= strWebBirth            %></TD>
					<TD NOWRAP><%= strWebOrgName          %></TD>
					<TD NOWRAP><%= strWebPosCardPrintDate %></TD>
					<TD NOWRAP><%= strWebRsvNo            %></TD>
					<TD NOWRAP><%= strWebUserName         %></TD>
				</TR>
<%
				strBeforeRsvNo = vntRsvno(i)
			Next
		End If
%>
	</TABLE>
<%
		If lngAllCount > 0 Then
			'�S���������̓y�[�W���O�i�r�Q�[�^�s�v
		     	If lngPageMaxLine <= 0 Then
			Else
				'URL�̕ҏW
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?mode="        & strMode
				strURL = strURL & "&action="      & "search"
				strURL = strURL & "&strCslYear="  & strStrCslYear
				strURL = strURL & "&strCslMonth=" & strStrCslMonth
				strURL = strURL & "&strCslDay="   & strStrCslDay
				strURL = strURL & "&endCslYear="  & strEndCslYear
				strURL = strURL & "&endCslMonth=" & strEndCslMonth
				strURL = strURL & "&endCslDay="   & strEndCslDay
				strURL = strURL & "&strSecYear="  & strStrSecYear
				strURL = strURL & "&strSecMonth=" & strStrSecMonth
				strURL = strURL & "&strSecDay="   & strStrSecDay
				strURL = strURL & "&endSecYear="  & strEndSecYear
				strURL = strURL & "&endSecMonth=" & strEndSecMonth
				strURL = strURL & "&endSecDay="   & strEndSecDay
				strURL = strURL & "&secKbn="      & strSecKbn
				strURL = strURL & "&orgCd1="      & strOrgCd1
				strURL = strURL & "&orgCd2="      & strOrgCd2
				strURL = strURL & "&perId="       & strPerId
				strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
				strURL = strURL & "&mailMode="    & lngMailMode
				strURL = strURL & "&csCd="        & strCsCd
				'�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
				<%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
			End If
%>
			<BR>
<%
		End If
		Exit Do
	Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>