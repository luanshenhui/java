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

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCommon			'���ʃN���X
Dim objAfterCare		'�A�t�^�[�P�A���p
Dim objPerson			'�l���p
Dim objFree				'�ėp���p

Dim strArroverTimeDiv
strArroverTimeDiv = Array("�Ȃ�","����")

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
'�A�t�^�[�P�A���
Dim strArrContactDate	'�ʐړ�
Dim strArrContactYear	'�ʐڔN�x
Dim strArrUserId 		'���[�U�[�h�c
Dim strArrRsvNo			'�\��ԍ�
Dim strArrUserName		'���[�U�[��
Dim strArrBlood_H		'�����i���j
Dim strArrBlood_L		'�����i��j
Dim strArrCircumStances	'�ʐڏ�
Dim strArrCareComment	'�R�����g

'�A�t�^�[�P�A�Ǘ�����
Dim strJudClassCd		'���蕪��
Dim strJudClassName		'���蕪�ޖ�
Dim strOtherJudClassName '���̑����蕪�ޖ�

'�A�t�^�[�P�A�ʐڕ���
Dim strSeq				'�r�d�p�m�n
Dim strGuidanceDiv		'�w�����e�敪
Dim strGuidance			'�w�����e
Dim strContactStcCd		'��^�ʐڕ��̓R�[�h
Dim strContactstc		'�ʐڕ���

'ini�t�@�C���擾�v�p
Dim strArrGuidanceDiv_ini
Dim strArrGuidance_ini

'�l���
Dim strPerId			'�l�h�c
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strGender			'����
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h2
Dim strOrgKName			'�c�̃J�i����
Dim strOrgName			'�c�̊�������
Dim strOrgSName			'�c�̗���
Dim strOrgBsdCd			'���Ə��R�[�h
Dim strOrgBsdKName		'���ƕ��J�i����
Dim strOrgBsdName		'���ƕ�����
Dim strOrgRoomCd		'�����R�[�h
Dim strOrgRoomName		'��������
Dim strOrgRoomKName		'�����J�i����
Dim strOrgPostCd		'���������R�[�h
Dim strOrgPostName		'��������
Dim strOrgPostKName		'�����J�i����
Dim strJobName			'�E��
Dim strEmpNo			'�]�ƈ��ԍ�
Dim strWorkMeasureName	'����[�u�敪��
Dim strOverTimeDiv		'���ߋΖ��敪

Dim strDispPerName		'�l���́i�����j
Dim strDispPerKName		'�l���́i�J�i�j
Dim strDispAge			'�N��i�\���p�j
Dim strDispBirth		'���N�����i�\���p�j

Dim lngAfteCateCount	'�A�t�^�[�P�A��񃌃R�[�h����
Dim lngAfteCateMCount	'�A�t�^�[�P�A�Ǘ����ڃ��R�[�h����
Dim lngAfteCateCCount	'�A�t�^�[�P�A�ʐڏ�̓��R�[�h����
Dim lngContactDateRowSpan	'HTML�\���p
Dim lngContactRowSpan		'HTML�\���p
Dim i,j,k				'���[�v�J�E���g

Dim strAfterCareDiv

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon    = Server.CreateObject("HainsCommon.Common")
Set objAfterCare = Server.CreateObject("HainsAfterCare.AfterCare")

strPerId = Request("perId")

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objPerson 	= Server.CreateObject("HainsPerson.Person")
Set objFree		= Server.CreateObject("HainsFree.Free")

'�l���ǂݍ���
objPerson.SelectPerson strPerId,     strLastName,    strFirstName,    _
					   strLastKName, strFirstKName,  strBirth,        _
					   strGender,    strOrgCd1,      strOrgCd2,       _
					   strOrgKName,  strOrgName,     strOrgSName,     _
					   strOrgBsdCd,  strOrgBsdKName, strOrgBsdName,   _
					   strOrgRoomCd, strOrgRoomName, strOrgRoomKName, _
					   strOrgPostCd, strOrgPostName, strOrgPostKName, _
					   , strJobName, , , , , _
					   strEmpNo, , , , , , , , , , , , , _
					   strWorkMeasureName, strOverTimeDiv

'�\���p���̂̕ҏW
strDispPerName 	= Trim(strLastName & "�@" & strFirstName)
strDispPerKName = Trim(strLastKName & "�@" & strFirstKName)

'�N��̎Z�o
strDispAge = objFree.CalcAge(strBirth, Date, "")

'�a��ҏW
strDispBirth = objCommon.FormatString(strBirth, "gee.mm.dd")

'����
strGender = IIf(strGender = CStr(GENDER_MALE), "�j��", "����")

'�\�����e�̕ҏW
strDispBirth = strDispBirth & "���@" & strDispAge & "�΁@" & strGender

'�I�u�W�F�N�g�̃C���X�^���X�̊J��
Set objPerson = Nothing

'�A�t�^�[�P�A���̌���
lngAfteCateCount = objAfterCare.SelectAfterCare( _
						strPerId , _
						strArrContactDate , _
						strArrContactYear , _
						strArrUserId , _
						strArrRsvNo , _
						strArrBlood_H , _
						strArrBlood_L , _
						strArrCircumStances , _
						strArrCareComment , _
						strArrUserName _
				   )

objAfterCare.GetGuidanceDiv strArrGuidanceDiv_ini, strArrGuidance_ini
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">

<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
var winInterview;	// �V�K�E�B���h�E�I�u�W�F�N�g

function showInterview( mode, strContactDate, strUserId, strRsvNo ) {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var opened = false;	// ��ʂ��J����Ă��邩
	var url = '';

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winInterview != null ) {
		if ( !winInterview.closed ) {
			opened = true;
		}
	}

	// URL�̕ҏW
	if ( mode != null ) {

		// �ʐړ�����
		url = '/webHains/contents/aftercare/AfterCareInterview.asp';
		url = url + '?perId='       + '<%= strPerId %>';
		url = url + '&contactDate=' + strContactDate;
		url = url + ( ( strRsvNo != '' ) ? '' : '&disp=1' );

	} else {

		// �V�K�o�^
		url = '/webHains/contents/aftercare/SelectAfterCareDiv.asp';
		url = url + '?perId=<%= strPerId %>';

	}

	// �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
//	if ( opened ) {
//		winInterview.location.replace( url );
//	} else {
//		winInterview = window.open( url, '', 'width=750,height=650,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no' );
//	}
	window.open( url, '', 'width=850,height=660,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no' );

}
//-->
</SCRIPT>
<TITLE>����[�u�Ώێ҂̓���</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="default.css">
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="" METHOD="GET">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">����[�u</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP><%= strEmpNo %></TD>
			<TD NOWRAP><A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= strPerId %>" TARGET="_BLANK"><B><%= strDispPerName %></B> (<FONT SIZE="-1"><%= strDispPerKName %></FONT>)</A></TD>
<!--		<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="">���f���ʂ��Q�Ƃ���</A></TD>-->
		<TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= strDispBirth %></TD>
<!--		<TD NOWRAP ALIGN="right" WIDTH="100%"><A HREF="">�������E�Ƒ������Q�Ƃ���</A></TD> -->
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD ALIGN="right" NOWRAP>�c�́F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP><%= strOrgName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;�����F</TD>
						<TD NOWRAP><%= strOrgPostName %></TD>
						<TD NOWRAP>&nbsp;&nbsp;�E��F</TD>
						<TD NOWRAP><%= strJobName %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
		<TR>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD HEIGHT="5"></TD>
					</TR>
					<TR>
						<TD NOWRAP>�A�Ƒ[�u�敪�F</TD>
						<TD NOWRAP><B><%= strWorkMeasureName %></B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
						<TD NOWRAP>���ߋΖ��敪�F</TD>
						<TD NOWRAP><B><%= strArroverTimeDiv(Cint(strOverTimeDiv)) %></B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</TD>
					</TR>
				</TABLE>
			</TD>
			<TD ALIGN="RIGHT" VALIGN="BOTTOM">
				<A HREF="/webHains/contents/maintenance/personal/mntPerInspection.asp?perid=<%= strPerId %>" TARGET="_BLANK">
					<IMG SRC="/webhains/images/insinfo_b.gif" WIDTH="77" HEIGHT="24" ALT="�l���������C�����܂�">
				</A>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="800">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">�ߋ��̖ʐڏ��</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>

	<A HREF="javascript:showInterview()"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�����ʐڏ���o�^���܂�"></A><BR><BR>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="2" WIDTH="800">
<%
		'�A�t�^�[�P�A�Ǘ����ڎ擾
		For i = 0 To lngAfteCateCount - 1
%>
		<TR BGCOLOR="#cccccc">
			<TD NOWRAP>�ʐړ�</TD>
			<TD NOWRAP>����</TD>
			<TD WIDTH="160" NOWRAP>����</TD>
			<TD COLSPAN="3" NOWRAP>�ʐڌ���</TD>
			<TD NOWRAP>�S��</TD>
		</TR>
<%
		'�A�t�^�[�P�A�Ǘ����ڎ擾
		lngAfteCateMCount = objAfterCare.SelectAfterCareM( _
									strPerId , _
									strArrContactDate(i) , _
									strJudClassCd ,  _
									strJudClassName ,  _
									strOtherJudClassName _
													)

		'�A�t�^�[�P�A�ʐڕ����擾
		lngAfteCateCCount = objAfterCare.SelectAfterCareC( _
									strPerId , _
									strArrContactDate(i) , _
									strSeq,  _
									strGuidanceDiv,  _
									strContactStcCd,  _
									strContactStc  _
													)

		lngContactDateRowSpan = lngAfteCateCCount + 3
		lngContactRowSpan = lngAfteCateCCount + 1

		'���ޗp������̕ҏW
		If Trim(strArrRsvNo(i)) = "" Then
			strAfterCareDiv = "�ی��w��"
		Else
			strAfterCareDiv = "<A HREF=""/webHains/contents/common/dailyList.asp?navi=1&key=rsvno%3A" & strArrRsvNo(i) & """ TARGET=""_BLANK"">"
			strAfterCareDiv = strAfterCareDiv & "����[�u</A>"
		End If
%>
		<TR BGCOLOR="#eeeeee" VALIGN="top">
			<TD ROWSPAN="<%= lngContactDateRowSpan %>" NOWRAP><A HREF="javascript:showInterview( 1 , '<%= strArrContactDate(i) %>', '<%= strArrUserId(i) %>', '<%= strArrRsvNo(i) %>')"><%= strArrContactDate(i) %></A></TD>
			<TD ROWSPAN="<%= lngContactDateRowSpan %>" NOWRAP><%= strAfterCareDiv %></TD>
			<TD ROWSPAN="<%= lngContactDateRowSpan %>">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="100%">
<%
					For j = 0 to lngAfteCateMCount - 1
%>
						<TR>
							<TD NOWRAP><%= strJudClassName(j) %></TD>
<%
							If( j + 1 <= lngAfteCateMCount - 1 ) Then
%>
								<TD NOWRAP><%= strJudClassName(j + 1) %></TD>
<%
								j = j + 1
							End If
%>
						</TR>
<%
					Next
%>
				</TABLE>
			</TD>
			<TD BGCOLOR="#cccccc" NOWRAP>��</TD>
			<TD COLSPAN="2"><%= Replace(strArrCircumStances(i), vbCrLf, "<BR>") %></TD>
			<TD ROWSPAN="<%= lngContactDateRowSpan %>" NOWRAP><%= strArrUserName(i) %></TD>
		</TR>
		<TR BGCOLOR="#cccccc" VALIGN="top">
			<TD ROWSPAN="<%= lngContactRowSpan %>" NOWRAP>�ʐڎw��</TD>
			<TD NOWRAP>�w�����e</TD>
			<TD WIDTH="100%" NOWRAP>�w������</TD>
		</TR>
<%
		For k = 0 to lngAfteCateCCount - 1
%>
			<TR BGCOLOR="#eeeeee">
				<TD NOWRAP><%= strArrGuidance_ini(CINT(strGuidanceDiv(k)) - 1 )%></TD>
				<TD NOWRAP><%= strContactStc(k) %></TD>
			</TR>
<%
		Next
%>
		<TR BGCOLOR="#eeeeee" VALIGN="top">
			<TD BGCOLOR="#cccccc" NOWRAP>���]</TD>
			<TD COLSPAN="2"><%= Replace(strArrCareComment(i), vbCrLf, "<BR>") %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
<%
	Next
%>
	</TABLE>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>
