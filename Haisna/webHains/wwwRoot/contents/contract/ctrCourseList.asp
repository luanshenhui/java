<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_���� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/editOrgHeader.inc"        -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const ACTMODE_BROWSE  = "browse"	'���샂�[�h(�Q��)
Const ACTMODE_COPY    = "copy"		'���샂�[�h(�R�s�[)
Const ACTMODE_RELEASE = "release"	'���샂�[�h(�Q�Ɖ���)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objContract			'�_����A�N�Z�X�p
Dim objContractControl	'�_����A�N�Z�X�p

'�����l
Dim strActMode			'���샂�[�h
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strCsCd				'�R�[�X�R�[�h
Dim lngStrYear			'�_��J�n�N
Dim lngStrMonth			'�_��J�n��
Dim lngStrDay			'�_��J�n��
Dim lngEndYear			'�_��I���N
Dim lngEndMonth			'�_��I����
Dim lngEndDay			'�_��I����
Dim strRefOrgCd1		'�Q�Ɛ�c�̃R�[�h1
Dim strRefOrgCd2		'�Q�Ɛ�c�̃R�[�h2
Dim strCtrPtCd			'�_��p�^�[���R�[�h

'�_��Ǘ����
Dim strWebColor			'web�J���[
Dim strArrCsCd			'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��
Dim strArrRefOrgCd1		'�Q�Ɛ�c�̃R�[�h1
Dim strArrRefOrgCd2		'�Q�Ɛ�c�̃R�[�h2
Dim strRefOrgName		'�Q�Ɛ�c�̊�������
Dim strArrCtrPtCd		'�_��p�^�[���R�[�h
Dim strArrStrDate		'�_��J�n��
Dim strArrEndDate		'�_��I����
Dim strAgeCalc			'�N��N�Z��
Dim blnReferred			'���c�̎Q�ƃt���O(���c�̂���Q�Ƃ���Ă����True)
Dim lngCount			'���R�[�h��

Dim strStrDate			'�_��J�n�N����
Dim strEndDate			'�_��I���N����
Dim blnChecked			'���t�`�F�b�N�����킩
Dim blnExistRefOrg		'�Q�Ɛ�c�̂����݂���ꍇ��True
Dim strMessage			'�G���[���b�Z�[�W
Dim strURL				'�W�����v���URL
Dim Ret					'�֐��߂�l
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'�����l�̎擾
strActMode   = Request("actMode")
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strCsCd      = Request("csCd")
lngStrYear   = CLng("0" & Request("strYear"))
lngStrMonth  = CLng("0" & Request("strMonth"))
lngStrDay    = CLng("0" & Request("strDay"))
lngEndYear   = CLng("0" & Request("endYear"))
lngEndMonth  = CLng("0" & Request("endMonth"))
lngEndDay    = CLng("0" & Request("endDay"))
strRefOrgCd1 = Request("refOrgCd1")
strRefOrgCd2 = Request("refOrgCd2")
strCtrPtCd   = Request("ctrPtCd")

'�_��J�n�E�I�����̃f�t�H���g�l�ݒ�
'### 2003/11/26 Updated by Ishihara@FSIT �f�t�H���g�͈͂��L����
'lngStrYear  = IIf(lngStrYear  = 0, Year(Now()),  lngStrYear)
lngStrYear  = IIf(lngStrYear  = 0, Year(Now()) -1 ,  lngStrYear)

lngStrMonth = IIf(lngStrMonth = 0, Month(Now()), lngStrMonth)
lngStrDay   = IIf(lngStrDay   = 0, Day(Now()),   lngStrDay)

'### 2003/11/26 Updated by Ishihara@FSIT �f�t�H���g�͈͂��L����
'lngEndYear  = IIf(lngEndYear  = 0, Year(Now()),  lngEndYear)
lngEndYear  = IIf(lngEndYear  = 0, Year(Now()) + 1,  lngEndYear)

lngEndMonth = IIf(lngEndMonth = 0, Month(Now()), lngEndMonth)
lngEndDay   = IIf(lngEndDay   = 0, Day(Now()),   lngEndDay)

'### ���t�ݒ�G���[�ɂ���ėՎ��Ή� 2008/02/29 �� Start
lngStrDay   = IIf(lngStrMonth = 2 and lngStrDay = 29, 28,   lngStrDay)
lngEndDay   = IIf(lngEndMonth = 2 and lngEndDay = 29, 28,   lngEndDay)
'### ���t�ݒ�G���[�ɂ���ėՎ��Ή� 2008/02/29 �� End


'�_��J�n�E�I���N�����̕ҏW
strStrDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
strEndDate = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay
blnChecked = True

Do
	'���샂�[�h���Ƃ̐���
	Select Case strActMode

		'�_��p�^�[���̃R�s�[
		Case ACTMODE_COPY

			'�R�s�[����
			Ret = objContractControl.CopyReferredContract(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, strCtrPtCd)
			Select Case Ret
				Case 0
				Case 1
					strMessage = "�_��c�̎��g�����S���Ƃ��đ��݂���_����̃R�s�[�͂ł��܂���B"
					Exit Do
				Case Else
					Exit Do
			End Select

			'�G���[���Ȃ���Ύ������g�����_�C���N�g
			strURL = Request.ServerVariables("SCRIPT_NAME")
			strURL = strURL & "?orgCd1="    & strOrgCd1
			strURL = strURL & "&orgCd2="    & strOrgCd2
			strURL = strURL & "&csCd="      & strCsCd
			strURL = strURL & "&strYear="   & lngStrYear
			strURL = strURL & "&strMonth="  & lngStrMonth
			strURL = strURL & "&strDay="    & lngStrDay
			strURL = strURL & "&endYear="   & lngEndYear
			strURL = strURL & "&endMonth="  & lngEndMonth
			strURL = strURL & "&endDay="    & lngEndDay
			Response.Redirect strURL
			Response.End

		'�_����̎Q�Ɖ���
		Case ACTMODE_RELEASE

			'�Q�Ɖ�������
			Ret = objContractControl.Release(strOrgCd1, strOrgCd2, strCtrPtCd)
			Select Case Ret
				Case 0
				Case 1
					strMessage = "���̌_������Q�Ƃ��Ă����f��񂪑��݂��܂��B�폜�ł��܂���B"
					Exit Do
				Case Else
					Exit Do
			End Select

			'�G���[���Ȃ���Ύ������g�����_�C���N�g
			strURL = Request.ServerVariables("SCRIPT_NAME")
			strURL = strURL & "?orgCd1="    & strOrgCd1
			strURL = strURL & "&orgCd2="    & strOrgCd2
			strURL = strURL & "&csCd="      & strCsCd
			strURL = strURL & "&strYear="   & lngStrYear
			strURL = strURL & "&strMonth="  & lngStrMonth
			strURL = strURL & "&strDay="    & lngStrDay
			strURL = strURL & "&endYear="   & lngEndYear
			strURL = strURL & "&endMonth="  & lngEndMonth
			strURL = strURL & "&endDay="    & lngEndDay
			Response.Redirect strURL
			Response.End

	End Select

	'�u�\���v�{�^���������ȊO�͉������Ȃ�
	If IsEmpty(Request("display.x")) Then
		Exit Do
	End If

	'�_��J�n�N�����̓��t�`�F�b�N
	If Not IsDate(strStrDate) Then
		strMessage = "��f�J�n���̓��͌`��������������܂���B"
		blnChecked = False
		Exit Do
	End If

	'�_��I���N�����̓��t�`�F�b�N
	If Not IsDate(strEndDate) Then
		strMessage = "��f�I�����̓��͌`��������������܂���B"
		blnChecked = False
		Exit Do
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
<TITLE>�_����</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var style = 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no';

var winNewContract;	// �V�K�_��쐬�E�B���h�E�I�u�W�F�N�g

// �V�K�_��쐬�E�B�U�[�h��\��
function showNewContractWizard() {

	var opened = false;	// ��ʂ��J����Ă��邩
	var url;			// �V�K�_��쐬��ʂ�URL

	var dialogWidth = 800, dialogHeight = 650;
	var dialogTop, dialogLeft;

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winNewContract != null ) {
		if ( !winNewContract.closed ) {
			opened = true;
		}
	}

	// �V�K�_��쐬��ʂ�URL�ҏW
	url = 'ctrSelectCourse.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>';

	// ��ʂ𒆉��ɕ\�����邽�߂̌v�Z
	dialogTop  = ( screen.height - 80 - dialogHeight ) / 2;
	dialogLeft = ( screen.width  - 5  - dialogWidth  ) / 2;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winNewContract.focus();
	} else {
		winNewContract = window.open(url, '', 'width=' + dialogWidth + ',height=' + dialogHeight + ',top=' + dialogTop + ',left=' + dialogLeft + ',' + style );
	}

}

// �V�K�_��쐬�E�B�U�[�h�����
function closeWindow() {

	// �V�K�_��쐬�E�B�U�[�h�����
	if ( winNewContract != null ) {
		if ( !winNewContract.closed ) {
			winNewContract.close();
		}
	}

	winNewContract = null;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">

	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�_����</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="85%">
		<TR>
			<TD HEIGHT="6"></TD>
		</TR>
		<TR>
			<TD ROWSPAN="3" VALIGN="top">
<%
				'�c�̏��̕ҏW
				Call EditOrgHeader(strOrgCd1, strOrgCd2)
%>
			</TD>
		</TR>
	</TABLE>


	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH="900">
		<TR>
			<TD ALIGN="RIGHT">
				<A HREF="ctrSearchOrg.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�c�̌�����ʂ֖߂�܂��B"></A>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="900">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">�_����̈ꗗ</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="900">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD VALIGN="top" ROWSPAN="2">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP>�R�[�X</TD>
						<TD>�F</TD>
						<TD COLSPAN="15"><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %></TD>
					</TR>
					<TR>
						<TD NOWRAP>��f����</TD>
						<TD>�F</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
						<TD NOWRAP>���`</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, False) %></TD>
						<TD NOWRAP>���̌_�����</TD>
						<TD><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></TD>
					</TR>
				</TABLE>
			</TD>
			
			<TD ALIGN="right">
			<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="javaScript:showNewContractWizard()"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�����_������쐬���܂�"></A>
			<%  else    %>
				 &nbsp;
			<%  end if  %>
			<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
			</TD>
		
		</TR>
		<TR>
			<TD ALIGN="right">
			<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
				<A HREF="ctrSelectCourse.asp?actMode=<%= ACTMODE_BROWSE %>&orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webHains/images/prevcopy.gif" WIDTH="77" HEIGHT="24" ALT="�_����̎Q�Ƃ܂��͕��ʂ��s���܂�"></A>
			<%  else    %>
				 &nbsp;
			<%  end if  %>
			<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
			</TD>
		</TR>
	
	</TABLE>

	<BR>
<%
	Do
		'���t�`�F�b�N�ُ펞�͉������Ȃ�
		If Not blnChecked Then
			Exit Do
		End If

		'�_��Ǘ����ǂݍ���
		lngCount = objContract.SelectAllCtrMng(strOrgCd1,       strOrgCd2,     strCsCd, _
											   strStrDate,      strEndDate,    strWebColor, _
											   strArrCsCd,      strCsName, ,   strArrRefOrgCd1, _
											   strArrRefOrgCd2, strRefOrgName, strArrCtrPtCd, _
											   strArrStrDate,   strArrEndDate, strAgeCalc, _
											   blnReferred)
		If lngCount <= 0 Then
%>
			���������𖞂����_����͑��݂��܂���B
<%
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
			<TR BGCOLOR="#eeeeee">
				<TD WIDTH="200" NOWRAP>��f�R�[�X</TD>
				<TD ALIGN="center" COLSPAN="7" NOWRAP>�_�����</TD>
				<TD ALIGN="center" COLSPAN="6" NOWRAP>�N��N�Z��</TD>
				<TD NOWRAP>����</TD>
				<TD NOWRAP>�Q�ƒ��̌_����</TD>
			</TR>
<%
			For i = 0 To lngCount - 1
%>
				<TR>
					<TD NOWRAP><FONT COLOR="#<%= strWebColor(i) %>">��</FONT><%= strCsName(i) %></TD>
					<TD NOWRAP><%= Year(strArrStrDate(i)) %>�N</TD>
					<TD NOWRAP ALIGN="right"><%= Month(strArrStrDate(i)) %>��</TD>
					<TD NOWRAP ALIGN="right"><%= Day(strArrStrDate(i))   %>��</TD>
					<TD>�`</TD>
					<TD NOWRAP><%= Year(strArrEndDate(i)) %>�N</TD>
					<TD NOWRAP ALIGN="right"><%= Month(strArrEndDate(i)) %>��</TD>
					<TD NOWRAP ALIGN="right"><%= Day(strArrEndDate(i))   %>��</TD>
<%
					'�N��N�Z���ɂ�鐧��
					Select Case Len(strAgeCalc(i))
						Case 8
%>
							<TD NOWRAP ALIGN="right">&nbsp;<%= CLng(Left(strAgeCalc(i), 4)) %></TD>
							<TD>�N</TD>
							<TD NOWRAP ALIGN="right"><%= CLng(Mid(strAgeCalc(i), 5, 2)) %></TD>
							<TD>��</TD>
							<TD NOWRAP ALIGN="right"><%= CLng(Right(strAgeCalc(i), 2)) %></TD>
							<TD>��</TD>
<%
						Case 4
%>
							<TD COLSPAN="2"></TD>
							<TD NOWRAP ALIGN="right"><%= CLng(Left(strAgeCalc(i), 2)) %></TD>
							<TD>��</TD>
							<TD NOWRAP ALIGN="right"><%= CLng(Right(strAgeCalc(i), 2)) %></TD>
							<TD>��</TD>
<%
						Case Else
%>
							<TD COLSPAN="6"></TD>
<%
					End Select

					'���c�̂ƎQ�Ɛ�c�̂����ꂩ���`�F�b�N
					If strArrRefOrgCd1(i) = strOrgCd1 And strArrRefOrgCd2(i) = strOrgCd2 Then

						'����ȏꍇ�A�_����Q�ƁE�o�^�pURL�̕ҏW
						strURL = "ctrDetail.asp"
						strURL = strURL & "?orgCd1="  & strOrgCd1
						strURL = strURL & "&orgCd2="  & strOrgCd2
						strURL = strURL & "&csCd="    & strArrCsCd(i)
						strURL = strURL & "&ctrPtCd=" & strArrCtrPtCd(i)
%>
						<TD ALIGN="center"><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/godetail.gif" WIDTH="21" HEIGHT="21" ALT="���̌_��̏ڍׂ�����"></A></TD>
						<TD></TD>
<%
					'���c�̂̌_������Q�Ƃ��Ă���ꍇ
					Else
%>
						<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></TD>
						<TD NOWRAP>
<%
							'�Q�Ɛ�c�̂̌_����Q�ƗpURL�̕ҏW
							strURL = "ctrDetail.asp"
							strURL = strURL & "?orgCd1="  & strArrRefOrgCd1(i)
							strURL = strURL & "&orgCd2="  & strArrRefOrgCd2(i)
							strURL = strURL & "&csCd="    & strArrCsCd(i)
							strURL = strURL & "&ctrPtCd=" & strArrCtrPtCd(i)
%>
							<A HREF="<%= strURL %>"><%= strRefOrgName(i) %></A>&nbsp;��
<%
							'�R�s�[�����pURL�̕ҏW
							strURL = Request.ServerVariables("SCRIPT_NAME")
							strURL = strURL & "?actMode="   & ACTMODE_COPY
							strURL = strURL & "&orgCd1="    & strOrgCd1
							strURL = strURL & "&orgCd2="    & strOrgCd2
							strURL = strURL & "&csCd="      & strCsCd
							strURL = strURL & "&strYear="   & lngStrYear
							strURL = strURL & "&strMonth="  & lngStrMonth
							strURL = strURL & "&strDay="    & lngStrDay
							strURL = strURL & "&endYear="   & lngEndYear
							strURL = strURL & "&endMonth="  & lngEndMonth
							strURL = strURL & "&endDay="    & lngEndDay
							strURL = strURL & "&refOrgCd1=" & strArrRefOrgCd1(i)
							strURL = strURL & "&refOrgCd2=" & strArrRefOrgCd2(i)
							strURL = strURL & "&ctrPtCd="   & strArrCtrPtCd(i)
%>
							<A HREF="<%= strURL %>" ONCLICK="javascript:return confirm('���̌_������R�s�[���܂��B��낵���ł����H')">�R�s�[</A>&nbsp;
<%
							'�Q�Ɖ����pURL�̕ҏW
							strURL = Request.ServerVariables("SCRIPT_NAME")
							strURL = strURL & "?actMode="  & ACTMODE_RELEASE
							strURL = strURL & "&orgCd1="   & strOrgCd1
							strURL = strURL & "&orgCd2="   & strOrgCd2
							strURL = strURL & "&strYear="  & lngStrYear
							strURL = strURL & "&strMonth=" & lngStrMonth
							strURL = strURL & "&strDay="   & lngStrDay
							strURL = strURL & "&endYear="  & lngEndYear
							strURL = strURL & "&endMonth=" & lngEndMonth
							strURL = strURL & "&endDay="   & lngEndDay
							strURL = strURL & "&ctrPtCd="  & strArrCtrPtCd(i)
%>
							<A HREF="<%= strURL %>" ONCLICK="JavaScript:return confirm('���̌_����̎Q�Ƃ��������܂��B��낵���ł����H')">�Q�Ɖ���</A>
						</TD>
<%
					End If
%>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do
	Loop
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
