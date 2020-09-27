<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �t�H���[�A�b�v�Ɖ� (Ver0.0.1)
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
Dim objFollowUp			'�t�H���[�A�b�v�A�N�Z�X�p

Dim strMode			'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strMessage			'�G���[���b�Z�[�W

Dim strKey              	'�����L�[
Dim strArrKey              	'�����L�[(�󔒂ŕ�����̃L�[�j
Dim strStartCslDate     	'����������f�N�����i�J�n�j
Dim strStartYear     		'����������f�N�i�J�n�j
Dim strStartMonth     		'����������f���i�J�n�j
Dim strStartDay     		'����������f���i�J�n�j
Dim strEndCslDate     		'����������f�N�����i�I���j
Dim strEndYear     		'����������f�N�i�I���j
Dim strEndMonth     		'����������f���i�I���j
Dim strEndDay     		'����������f���i�I���j
Dim strOrgCd1		   	'���������c�̃R�[�h�P
Dim strOrgCd2		   	'���������c�̃R�[�h�Q
Dim strOrgName		   	'���������c�̖�

Dim strCsCd					'�R�[�X�R�[�h
Dim strPerId
Dim strPerName

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
Dim vntJudClassName		'���蕪�ޖ�
Dim vntQuestionName		'�A���P�[�g��

Dim strLastName         	'����������
Dim strFirstName        	'����������

Dim vntGFFlg				'���GF��f�t���O
Dim vntCFFlg				'���GF��f�t���O
Dim vntSeq					'SEQ

Dim lngAllCount				'������
Dim lngRsvAllCount			'�d���\��Ȃ�����
Dim lngGetCount				'����
Dim i					'�J�E���^
Dim j

Dim lngStartPos				'�\���J�n�ʒu
Dim lngPageMaxLine			'�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()		'�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName()	'�P�y�[�W�\���l�`�w�s���̔z��

Dim lngArrSendMode()		'�������m�F��Ԃ̔z��
Dim strArrSendModeName()	'�������m�F��Ԗ��̔z��

Dim Ret						'�֐��߂�l
Dim strURL					'�W�����v���URL

Dim vntDelRsvNo				'
Dim vntDelSeq				'

'��ʕ\������p��������
Dim strBeforeRsvNo			'�O�s�̗\��ԍ�

Dim strWebCslDate			'��f��
Dim strWebDayId				'����ID
Dim strWebCsInfo			'�R�[�X��
Dim strWebPerId				'�lID
Dim strWebPerName			'�J�i�����E����
Dim strWebGender			'����
Dim strWebBirth				'���N����
Dim strWebOrgName			'�c�̗���
Dim strWebJudClassName			'���蕪�ޖ�
Dim strWebQuestionName			'�A���P�[�g��
Dim strWebRsvNo				'�\��ԍ�

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objOrg          = Server.CreateObject("HainsOrganization.Organization")
Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")

'�����l�̎擾
strMode           = Request("mode")
strAction         = Request("action")
strStartYear      = Request("startYear")
strStartMonth     = Request("startMonth")
strStartDay       = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strPerId          = Request("perId")
lngStartPos       = Request("startPos")
lngPageMaxLine    = Request("pageMaxLine")
strCsCd           = Request("csCd")

'�f�t�H���g�̓V�X�e���N������K�p����
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(Now))
	strStartMonth = CStr(Month(Now))
	strStartDay   = CStr(Day(Now))
End If
If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
	strEndYear  = CStr(Year(Now))
	strEndMonth = CStr(Month(Now))
	strEndDay   = CStr(Day(Now))
End If

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Call CreatePageMaxLineInfo()

Do

	'�����{�^���N���b�N
	If strAction = "search" Then

		'��f��(��)�̓��t�`�F�b�N
		If strStartYear <> 0 Or strStartMonth <> 0 Or strStartDay <> 0 Then
			If Not IsDate(strStartYear & "/" & strStartMonth & "/" & strStartDay) Then
				strMessage = "��f���̎w��Ɍ�肪����܂��B"
				Exit Do
			End If
		End If

		'��f��(��)�̓��t�`�F�b�N
		If strEndYear <> 0 Or strEndMonth <> 0 Or strEndDay <> 0 Then
			If Not IsDate(strEndYear & "/" & strEndMonth & "/" & strEndDay) Then
				strMessage = "��f���̎w��Ɍ�肪����܂��B"
				Exit Do
			End If
		End If

		'�����J�n�I����f���̕ҏW
		strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
		strEndCslDate   = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)

		''�P�N�ȓ����`�F�b�N
		If strEndCslDate - strStartCslDate > 366 Then
			strMessage = "��f���͂P�N�ȓ����w�肵�ĉ������B"
			Exit Do
		End If

		'�S�����擾����
		lngAllCount = objFollowUp.SelectFromToFollow_I(strStartCslDate, strEndCslDate, _
			                                       strCsCd, strOrgCd1, strOrgCd2, _
			                                       lngPageMaxLine, lngStartPos, _
			                                       , , _
			                                       , , _
			                                       , , _
			                                       , , _
			                                       , , _
			                                       , , _
			                                       , False _
                					      )

		If lngAllCount > 0 Then

			lngRsvAllCount = objFollowUp.SelectFromToFollow_I(strStartCslDate, strEndCslDate, _
				                                          strCsCd, strOrgCd1, strOrgCd2, _
				                                          lngPageMaxLine, lngStartPos, _
				                                          vntRsvNo, vntCslDate, _
				                                          vntDayId, vntCsname, _
				                                          vntWebColor, vntPerId, _
				                                          vntPerKName, vntPerName, _
				                                          vntGender, vntBirth, _
				                                          vntOrgSName, vntJudClassName, _
				                                          vntQuestionName, True _
	                					         )


		End If

		'�c�̃R�[�h����H
		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			ObjOrg.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , strOrgName 
		Else
			strOrgName = ""
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

	lngArrPageMaxLine(0) = 20:strArrPageMaxLineName(0) = "20�s����"
	lngArrPageMaxLine(1) = 50:strArrPageMaxLineName(1) = "50�s����"
	lngArrPageMaxLine(2) = 100:strArrPageMaxLineName(2) = "100�s����"
	lngArrPageMaxLine(3) = 999:strArrPageMaxLineName(3) = "���ׂ�"

End Sub
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML LANG="ja">

<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�t�H���[�A�b�v�Ɖ�</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winGuideFollowUp;		//�t�H���[�A�b�v��ʃn���h��
// �����{�^���N���b�N
function searchClick() {

	with ( document.entryFollowInfo ) {
		startPos.value = 1;
		action.value = 'search';
		submit();
	}

	return false;

}

// �K�C�h��ʂ�\��
function followUp_openWindow( url ) {

	var opened = false;	// ��ʂ��J����Ă��邩

	var dialogWidth = 1000, dialogHeight = 600;
	var dialogTop, dialogLeft;

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winGuideFollowUp ) {
		if ( !winGuideFollowUp.closed ) {
			opened = true;
		}
	}

	// ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
	dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
	dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

	// �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winGuideFollowUp.focus();
		winGuideFollowUp.location.replace( url );
	} else {
		winGuideFollowUp = window.open( url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
	}

}

// �A�����[�h���̏���
function closeGuideWindow() {

	// �c�̌����K�C�h�����
	orgGuide_closeGuideOrg();

	//���t�K�C�h�����
	calGuide_closeGuideCalendar();

	if ( winGuideFollowUp != null ) {
		if ( !winGuideFollowUp.closed ) {
			winGuideFollowUp.close();
		}
	}

	winGuideFollowUp = null;


	return false;
}
//-->
</SCRIPT>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryFollowInfo" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="action" VALUE=""> 
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<% = lngStartPos %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" width="85%" HEIGHT="15"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�t�H���[�A�b�v�Ɖ�</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="2">
	<TR>
		<TD>��f��</TD>
		<TD>�F</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
					<TD>&nbsp;���`&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
					<TD>&nbsp;��</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</TD>
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
					<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryFollowInfo.orgCd1, document.entryFollowInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="�c�̌����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:orgGuide_clearOrgInfo(document.entryFollowInfo.orgCd1, document.entryFollowInfo.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
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
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
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
						�u<FONT COLOR="#ff6600"><B><%= strStartYear %>�N<%= strStartMonth %>��<%= strStartDay %>���`<%= strEndYear %>�N<%= strEndMonth %>��<%= strEndDay %>��</B></FONT>�v�̃t�H���[�A�b�v�Ɖ���ꗗ��\�����Ă��܂��B<BR>
								�������ʂ�<FONT COLOR="#ff6600"><B><%= lngRsvAllCount %></B></FONT>���i�t�H���[�A�b�v�Ɖ���P�ʁj�ł��B 
						</SPAN>
					</TD>
				</TR>
			</TABLE>
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
					<TD ALIGN="left" NOWRAP>���f����</TD>
					<TD ALIGN="left" NOWRAP>�A���P�[�g</TD>
					<TD ALIGN="left" NOWRAP>�\��ԍ�</TD>
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
				strWebJudClassName	= vntJudClassName(i)
				strWebQuestionName	= vntQuestionName(i)
				strWebRsvNo		= ""

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
					strURL = "/webHains/contents/followUp/followupTop.asp"
					strURL = strURL & "?rsvno="  & vntRsvNo(i)
					strURL = strURL & "&winmode="  & "1"

				End If
%>
				<TR HEIGHT="18" BGCOLOR="#eeeeee">
					<TD NOWRAP><%= strWebCslDate      %></TD>
					<TD NOWRAP><%= strWebDayId        %></TD>
					<TD NOWRAP><%= strWebCsInfo       %></TD>
					<TD NOWRAP><%= strWebPerId        %></TD>
					<TD NOWRAP><A HREF="javascript:followUp_openWindow('<%= strURL %>')" TARGET="_top"><%= strWebPerName %></A></TD>
					<TD NOWRAP><%= strWebGender       %></TD>
					<TD NOWRAP><%= strWebBirth        %></TD>
					<TD NOWRAP><%= strWebOrgName      %></TD>
					<TD NOWRAP><%= strWebJudClassName %></TD>
					<TD NOWRAP><%= strWebQuestionName %></TD>
					<TD NOWRAP><%= strWebRsvNo        %></TD>
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
				strURL = strURL & "&startYear="   & strStartYear
				strURL = strURL & "&startMonth="  & strStartMonth
				strURL = strURL & "&startDay="    & strStartDay
				strURL = strURL & "&endYear="     & strEndYear
				strURL = strURL & "&endMonth="    & strEndMonth
				strURL = strURL & "&endDay="      & strEndDay
				strURL = strURL & "&orgCd1="      & strOrgCd1
				strURL = strURL & "&orgCd2="      & strOrgCd2
				strURL = strURL & "&csCd="        & strCsCd
				strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
				'�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
				<%= EditPageNavi(strURL, CLng(lngAllCount), lngStartPos, CLng(lngPageMaxLine)) %>
<%
			End If
%>
			<BR>
<%
		End If
		Exit do
	Loop
%>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>

</HTML>