<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ʐڏ��̓o�^(Ver0.0.1)
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

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Const lngGuidanceDivCount = 8	'�w�����e�\����

'�l���
Dim strPerId			'�l�h�c
Dim strContactDate		'�ʐړ�

'�A�t�^�[�P�A���
Dim strArrContactYear	'�ʐڔN�x
Dim strArrUserId 		'���[�U�[�h�c
Dim strArrRsvNo			'�\��ԍ�
Dim strArrUserName		'���[�U�[��
Dim strArrBlood_H		'�����i���j
Dim strArrBlood_L		'�����i��j
Dim strArrCircumStances	'�ʐڏ�
Dim strArrCareComment	'�R�����g

'�A�t�^�[�P�A�ʐڕ������
Dim strSeq				'�r�d�p�m�n
Dim strGuidanceDiv		'�w�����e�敪
Dim strGuidance			'�w�����e
Dim strContactStcCd		'��^�ʐڕ��̓R�[�h
Dim strContactstc		'�ʐڕ���


'ini�t�@�C����`���e
Dim vntGuidanceDivCd	'�w�����e�敪
Dim vntGuidanceDiv		'�w�����e������

'��ʕ\���p
Dim strBlood_H			'�����i���j
Dim strBlood_L			'�����i��j
Dim strCircumStances	'�ʐڏ�
Dim strCareComment		'�R�����g


Dim lngAfteCateCount	'�A�t�^�[�P�A���R�[�h�J�E���g
Dim lngAfteCateCCount	'�A�t�^�[�P�A�ʐڕ������R�[�h�J�E���g
Dim lngLudClassCount	'���R�[�h�J�E���g
Dim i,j					'���[�v�J�E���g

Dim strSelectedDiv		'�����\�����ɑI���ς݂ɂ���敪

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon	 	= Server.CreateObject("HainsCommon.Common")
Set objAfterCare 	= Server.CreateObject("HainsAfterCare.AfterCare")

strPerId			= Request("perId")
strContactDate		= Request("contactDate")

'ini�t�@�C������w�����e���擾
lngLudClassCount = objAfterCare.GetGuidanceDiv( vntGuidanceDivCd , vntGuidanceDiv )

'�A�t�^�[�P�A���̌���
If( strPerId <> "" And strContactDate <> "") Then

	lngAfteCateCount = objAfterCare.SelectAfterCare( _
								strPerId , _
								strContactDate , _
								strArrContactYear , _
								strArrUserId , _
								strArrRsvNo , _
								strArrBlood_H , _
								strArrBlood_L , _
								strArrCircumStances , _
								strArrCareComment , _
								strArrUserName _
													)

	strBlood_H 			= strArrBlood_H( lngAfteCateCount - 1 )
	strBlood_L 			= strArrBlood_L( lngAfteCateCount - 1 )
	strCircumStances 	= strArrCircumStances( lngAfteCateCount - 1 )
	strCareComment 		= strArrCareComment( lngAfteCateCount - 1 )

'�A�t�^�[�P�A�ʐڕ����擾
	lngAfteCateCCount = objAfterCare.SelectAfterCareC( _
								strPerId , _
								strContactDate( lngAfteCateCount - 1 ) , _
								strSeq,  _
								strGuidance,  _
								strContactStcCd,  _
								strContactstc  _
	 												)

End If

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ʐڏ��̓o�^</TITLE>
<!-- #include virtual = "/WebHains/includes/ContactStcGuide.inc" -->

<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--

// �ʐڕ����K�C�h�\��
function callStcGuide(lngArrCount) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var strSpanName = 'guidance' + lngArrCount;

	contactStcGuide_showGuideContactStc( objForm.guidanceDiv[ lngArrCount ], objForm.contactStcCd[ lngArrCount ], strSpanName, null , false );

}
// �ʐڕ����N���A
function clearStc(lngArrCount) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var strSpanName = 'guidance' + lngArrCount;
	contactStcGuide_clearContactStcInfo( objForm.guidanceDiv[ lngArrCount ], objForm.contactStcCd[ lngArrCount ], strSpanName);

}

//-->
</SCRIPT>
</HEAD>
<BODY>

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return false;">

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP>�����i���^��j</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE=text" SIZE="9" MAXLENGTH="6" NAME="bloodPressure_h" VALUE="<%= strBlood_H %>"></TD>
						<TD>�^</TD>
						<TD><INPUT TYPE=text" SIZE="9" MAXLENGTH="6" NAME="bloodPressure_l" VALUE="<%= strBlood_L %>"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR VALIGN="top">
			<TD NOWRAP>�ʐڏ�</TD>
			<TD>�F</TD>
			<TD><TEXTAREA NAME="circumStances" COLS="76" ROWS="5"><%= strCircumStances %></TEXTAREA></TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR VALIGN="top">
			<TD NOWRAP>�ʐړ��e</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
					<TR ALIGN="center" BGCOLOR="#cccccc">
						<TD NOWRAP>�w�����e</TD>
						<TD COLSPAN="3" NOWRAP>�w������</TD>
					</TR>
<%
			For i = 0 to lngGuidanceDivCount
%>
					<TR>
<%
				If( i < lngAfteCateCCount ) Then
%>
					<TD><%= EditDropDownListFromArray("guidanceDiv", vntGuidanceDivCd, vntGuidanceDiv , vntGuidanceDivCd(Cint(strGuidance(i) - 1 )), NON_SELECTED_ADD) %></TD>
					<TD><A HREF="javascript:callStcGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�ʐڃR�����g�K�C�h��\�����܂�"></A></TD>
					<TD><A HREF="javascript:clearStc(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
					<TD WIDTH="100%" NOWRAP><SPAN ID="guidance<%= i %>"><%= strContactstc(i) %></SPAN>
					<INPUT TYPE="hidden" NAME="contactStcCd"  VALUE="<%= strContactStcCd(i) %>"></TD>
<%
				Else

					'��R�A���V�K�o�^�̏ꍇ�͏����\�����ɁA�f�t�H���g�Z�b�g
					If (i < 3)  And (lngAfteCateCCount <= 0) And (lngAfteCateCount <= 0)Then
						strSelectedDiv = vntGuidanceDivCd(i)
					Else
						strSelectedDiv = ""
					End If

%>
					<TD><%= EditDropDownListFromArray("guidanceDiv", vntGuidanceDivCd, vntGuidanceDiv , strSelectedDiv , NON_SELECTED_ADD) %></TD>
					<TD><A HREF="javascript:callStcGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�ʐڃR�����g�K�C�h��\�����܂�"></A></TD>
					<TD><A HREF="javascript:clearStc(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
					<TD WIDTH="100%" NOWRAP><SPAN ID="guidance<%= i %>"></SPAN>
					<INPUT TYPE="hidden" NAME="contactStcCd"  VALUE=""></TD>
<%
				End If
%>
					</TR>
<%			
			Next
%>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR VALIGN="top">
			<TD NOWRAP>���]</TD>
			<TD>�F</TD>
			<TD><TEXTAREA NAME="careComment" COLS="76" ROWS="5"><%= strCareComment %></TEXTAREA></TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
