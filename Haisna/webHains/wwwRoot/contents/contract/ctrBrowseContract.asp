<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(�_����̎Q�ƁE�R�s�[) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const OPMODE_BROWSE  = "browse"	'�������[�h(�Q��)
Const OPMODE_COPY    = "copy"	'�������[�h(�R�s�[)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p
Dim objContract			'�_����A�N�Z�X�p
Dim objContractControl	'�_����A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l(�Q�ƁE�R�s�[����)
Dim strOpMode			'�������[�h
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strCsCd				'�R�[�X�R�[�h
Dim strRefOrgCd1		'�Q�Ɛ�c�̃R�[�h1
Dim strRefOrgCd2		'�Q�Ɛ�c�̃R�[�h2

'�O��ʂ��瑗�M�����p�����[�^�l(�R�s�[���̂�)
Dim lngStrYear			'�_��J�n�N
Dim lngStrMonth 		'�_��J�n��
Dim lngStrDay			'�_��J�n��
Dim lngEndYear			'�_��I���N
Dim lngEndMonth 		'�_��I����
Dim lngEndDay			'�_��I����

'���g�����_�C���N�g����ꍇ�̂ݑ��M�����p�����[�^�l
Dim strCtrPtCd			'�_��p�^�[���R�[�h

'�_��Ǘ����
Dim strOrgName			'�c�̖�
Dim strCsName			'�R�[�X��
Dim dtmStrDate			'�_��J�n��
Dim dtmEndDate			'�_��I����
Dim strStrDate			'�ҏW�p�̌_��J�n��
Dim strEndDate			'�ҏW�p�̌_��I����

'�Q�Ɛ�c�̂̌_����
Dim strRefOrgName		'�Q�Ɛ�_��c�̖�
Dim strRefCtrPtCd		'�_��p�^�[���R�[�h
Dim strRefStrDate		'�_��J�n��
Dim strRefEndDate		'�_��I����
Dim blnOrgEquals		'�Q�Ɛ�c�̈�v�t���O(�Q�Ɛ�c�̂̎Q�Ɛ悪�Q�ƌ��c�̂Ɠ������ꍇ��True)
Dim blnReferred			'�Q�ƍς݃t���O(�Q�Ɛ�c�̂̌_���񂪂��łɎQ�ƌ��c�̂���Q�Ƃ���Ă���ꍇ��True)
Dim blnOverlap			'�_����ԏd���t���O(�Q�Ɛ�c�̂̌_����Ԃ��Q�ƌ��c�̂̂���Əd������ꍇ��True)
Dim blnExistBdn 		'���S�����݃t���O(�Q�Ɛ�c�̂̕��S���Ƃ��ĎQ�ƌ��c�̂����݂���ꍇ��True)
Dim lngCount			'�Q�Ɛ�c�̂̌_����

'�G���[���b�Z�[�W
Dim strMsgOrgEquals		'�Q�Ɛ�c�̈�v��
Dim strMsgReferred		'�_��������ݎ�
Dim strMsgOverlap		'�_����ԏd����
Dim strMsgExistBdn		'���S�����ݎ�

Dim strMessage			'�G���[���b�Z�[�W
Dim blnBrowseCopy		'�Q�ƁE�R�s�[�������\��
Dim strOpName			'������
Dim strURL				'URL������
Dim Ret					'�֐��߂�l
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'�O��ʂ��瑗�M�����p�����[�^�l�̎擾
strOpMode    = Request("opMode")
strOrgCd1    = Request("orgCd1")
strOrgCd2    = Request("orgCd2")
strCsCd      = Request("csCd")
strRefOrgCd1 = Request("refOrgCd1")
strRefOrgCd2 = Request("refOrgCd2")

'�O��ʂ��瑗�M�����p�����[�^�l�̎擾(�R�s�[���̂�)
lngStrYear  = CLng("0" & Request("strYear"))
lngStrMonth = CLng("0" & Request("strMonth"))
lngStrDay   = CLng("0" & Request("strDay"))
lngEndYear  = CLng("0" & Request("endYear"))
lngEndMonth = CLng("0" & Request("endMonth"))
lngEndDay   = CLng("0" & Request("endDay"))

'���g�����_�C���N�g����ꍇ�̂ݑ��M�����p�����[�^�l
strCtrPtCd = Request("ctrPtCd")

'�������̕ҏW
strOpName = IIf(strOpMode = OPMODE_BROWSE, "�Q��", "�R�s�[")

'�G���[���b�Z�[�W�̕ҏW
strMsgOrgEquals = "�Q�Ɛ�c�̂��_��c�̎��g�̌_����Q�Ƃ��Ă��܂��B"
strMsgReferred  = "���̌_����͂��łɌ_��c�̎��g����Q�Ƃ���Ă��܂��B"
strMsgOverlap   = "�_��c�̂̌��_����ƌ_����Ԃ��d�����邽�߁A" & strOpName & "���邱�Ƃ͂ł��܂���B"
strMsgExistBdn  = "�_��c�̎��g�����S���Ƃ��đ��݂���_�����" & strOpName & "�͂ł��܂���B"

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'�_��p�^�[���R�[�h���n����Ă��Ȃ��ꍇ�͐��䏈���𔲂���
	If strCtrPtCd = "" Then
		Exit Do
	End If

	'�������[�h���Ƃ̏���
	Select Case strOpMode

		'�Q�Ƃ̏ꍇ
		Case OPMODE_BROWSE

			'�_����̎Q�Ə���
			Ret = objContractControl.Refer(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, strCtrPtCd)
			Select Case Ret
				Case 1: strMessage = strMsgOrgEquals
				Case 2: strMessage = strMsgReferred
				Case 3: strMessage = strMsgOverlap
				Case 4: strMessage = strMsgExistBdn
			End Select

		'�R�s�[�̏ꍇ
		Case OPMODE_COPY

			'�_����̃R�s�[����
			Ret = objContractControl.Copy(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, strCtrPtCd, lngStrYear, lngStrMonth, lngStrDay, lngEndYear, lngEndMonth ,lngEndDay)
			Select Case Ret
				Case 1: strMessage = "���łɓo�^�ς݂̌_����ƌ_����Ԃ��d�����邽�߁A" & strOpName & "�ł��܂���B"
				Case 2: strMessage = strMsgExistBdn
			End Select

	End Select

	'�G���[�������͏������I������
	If strMessage <> "" Then
		Exit Do
	End If

	'�G���[���Ȃ���Ώ��������y�[�W��
	Response.Redirect "ctrFinished.asp?orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2
	Response.End

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
<TITLE>�_����̑I��</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�_����̑I��</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'�c�̖��̓ǂݍ���
	If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
		Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
	End If

	'�R�[�X���̓ǂݍ���
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "�R�[�X��񂪑��݂��܂���B"
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>�_��c��</TD>
			<TD>�F</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
<%
		'�������[�h���R�s�[�̏ꍇ�͐�ɓ��͂����_����Ԃ�ҏW����
		If strOpMode = OPMODE_COPY Then

			'�_��J�n�N�����̎擾
			If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
				dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
			End If

			'�_��I���N�����̎擾
			If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
				dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
			End If

			'�ҏW�p�̌_��J�n���ݒ�
			If dtmStrDate > 0 Then
				strStrDate = FormatDateTime(dtmStrDate, 1)
			End If

			'�ҏW�p�̌_��I�����ݒ�
			If dtmEndDate > 0 Then
				strEndDate = FormatDateTime(dtmEndDate, 1)
			End If
%>
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
			<TR>
				<TD>�_�����</TD>
				<TD>�F</TD>
				<TD><B><%= strStrDate %>�`<%= strEndDate %></B></TD>
			</TR>
<%
		End If
%>
	</TABLE>

	<BR>
<%
	'�Q�Ɛ�_��c�̖��̓ǂݍ���
	If objOrganization.SelectOrg_Lukes(strRefOrgCd1, strRefOrgCd2, , , strRefOrgName) = False Then
		Err.Raise 1000, , "�Q�Ɛ�c�̏�񂪑��݂��܂���B"
	End If
%>
	�Q�Ɛ�_��c�́F<B><%= strRefOrgName %></B>

	<BR>
	<BR>
<%
	'���ݕҏW���R�[�X�ɑ΂���Q�Ɛ�c�̌_����̎Q�ƁE�R�s�[�����ۂ��擾����
	lngCount = objContract.SelectCtrMngRefer(strOrgCd1, strOrgCd2, strRefOrgCd1, strRefOrgCd2, strCsCd, strRefCtrPtCd, strRefStrDate, strRefEndDate, blnOrgEquals, blnReferred, blnOverlap, blnExistBdn)
	If lngCount = 0 Then
		Err.Raise 1000, , "�Q�Ɛ�c�̂̌_���񂪑��݂��܂���B"
	End If

	'�Q�ƁE�R�s�[�\�Ȍ_���񂪑��݂��邩���`�F�b�N����
	blnBrowseCopy = False
	If strOpMode = OPMODE_BROWSE Then
		For i = 0 To lngCount - 1
			If blnOrgEquals(i) = False And blnReferred(i) = False And blnOverlap(i) = False And blnExistBdn(i) = False Then
				blnBrowseCopy = True
				Exit For
			End If
		Next
	Else
		For i = 0 To lngCount - 1
			If blnExistBdn(i) = False Then
				blnBrowseCopy = True
				Exit For
			End If
		Next
	End If

	'�Q�ƁE�R�s�[�̉ۂɉ��������b�Z�[�W�̕ҏW
	If blnBrowseCopy Then
%>
		<FONT COLOR="#cc9999">��</FONT><%= strOpName %>���s���_������ȉ�����I�����ĉ������B<BR><BR>
<%
	Else
%>
		<FONT COLOR="#cc9999">��</FONT><%= strOpName %>�\�Ȍ_����͑��݂��܂���ł����B<BR><BR>
<%
	End If

	'URL������̕ҏW
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?opMode="    & strOpMode
	strURL = strURL & "&orgCd1="    & strOrgCd1
	strURL = strURL & "&orgCd2="    & strOrgCd2
	strURL = strURL & "&csCd="      & strCsCd
	strURL = strURL & "&refOrgCd1=" & strRefOrgCd1
	strURL = strURL & "&refOrgCd2=" & strRefOrgCd2

	'�������[�h���R�s�[�̏ꍇ�͍X�Ɍ_����Ԃ�Query������Ƃ��ĕҏW����
	If strOpMode = OPMODE_COPY Then
		strURL = strURL & "&strYear="  & lngStrYear
		strURL = strURL & "&strMonth=" & lngStrMonth
		strURL = strURL & "&strDay="   & lngStrDay
		strURL = strURL & "&endYear="  & lngEndYear
		strURL = strURL & "&endMonth=" & lngEndMonth
		strURL = strURL & "&endDay="   & lngEndDay
	End If
%>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="#cccccc">
			<TD>�_�����</TD>
			<TD>���l</TD>
		</TR>
<%
		'�_����ԂƂ��ꂼ��̎Q�ƁE�R�s�[�����ۂ�ҏW����
		For i = 0 To lngCount - 1
%>
			<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">
				<TD HEIGHT="20"><%= strRefStrDate(i) %>�`<%= strRefEndDate(i) %></TD>
				<TD>
<%
					Do
						'�������[�h���Q�Ƃ̏ꍇ�͎���3�̃`�F�b�N�������s��
						If strOpMode = OPMODE_BROWSE Then

							'�_��c�̎��g�̌_������Q�Ƃ��Ă���ꍇ
							'(���{�t���O�������͕K���Q�ƍς݃t���O�E�_����ԏd���t���O���������邽�߁A��Ƀ`�F�b�N����K�v������)
							If blnOrgEquals(i) Then
%>
								<FONT COLOR="#666666">�i<%= strMsgOrgEquals %>�j</FONT>
<%
								Exit Do
							End If

							'���łɌ_��c�̎��g����Q�Ƃ���Ă���ꍇ
							'(���{�t���O�������͕K���_����ԏd���t���O���������邽�߁A��Ƀ`�F�b�N����K�v������)
							If blnReferred(i) Then
%>
								<FONT COLOR="#666666">�i<%= strMsgReferred %>�j</FONT>
<%
								Exit Do
							End If

							'�_����Ԃ��d������ꍇ
							If blnOverlap(i) Then
%>
								<FONT COLOR="#666666">�i<%= strMsgOverlap %>�j</FONT>
<%
								Exit Do
							End If

						End If

						'�_��c�̂��Q�Ɛ�_��c�̌_����̕��S���Ƃ��đ��݂���ꍇ
						If blnExistBdn(i) Then
%>
							<FONT COLOR="#666666">�i<%= strMsgExistBdn %>�j</FONT>
<%
							Exit Do
						End If

						'�����܂ŃG���[�ΏۂɂȂ�Ȃ���ΎQ��(�R�s�[)�����p�̃A���J�[��ҏW
%>
						<A HREF="<%= strURL & "&ctrPtCd=" & strRefCtrPtCd(i) %>">���̌_�����<%= strOpName %>����</A>
<%
						Exit Do
					Loop
%>
				</TD>
			</TR>
<%
		Next
%>
	</TABLE>

	<BR>

	<A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
