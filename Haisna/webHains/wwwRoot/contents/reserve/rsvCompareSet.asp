<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\����ڍ�(�����Z�b�g���̔�r) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p
Dim objContract			'�_����A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p
Dim objFree				'�ėp���A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objSetClass			'�Z�b�g���ޏ��A�N�Z�X�p

'�����l
Dim dtmCslDate			'��f��
Dim lngRsvNo			'�\��ԍ�
Dim strPerId			'�l�h�c
Dim strAge				'��f���N��
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strCsCd				'�R�[�X�R�[�h
Dim strCslDivCd			'��f�敪�R�[�h
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strOptCd			'�I�v�V�����R�[�h
Dim strOptBranchNo		'�I�v�V�����}��

'�l���
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strGender			'����

'�Z�b�g���ޏ��
Dim strSetClassCd		'�Z�b�g���ރR�[�h
Dim strSetClassName		'�Z�b�g���ޖ�
Dim lngSetClassCount	'�Z�b�g���ސ�

'�O��ۑ����̎�f�I�v�V�������
Dim strLastOptCd		'�I�v�V�����R�[�h
Dim strLastOptBranchNo	'�I�v�V�����}��
Dim strLastOptName		'�I�v�V������
Dim strLastSetClassCd	'�Z�b�g���ރR�[�h
Dim lngLastOptCount		'�I�v�V����������

'�w��_��p�^�[���̎�f�I�v�V�������
Dim strCtrOptCd			'�I�v�V�����R�[�h
Dim strCtrOptBranchNo	'�I�v�V�����}��
Dim strCtrOptName		'�I�v�V������
Dim strCtrSetClassCd	'�Z�b�g���ރR�[�h
Dim lngCtrOptCount		'�I�v�V����������

'�ŐV�̎�f�I�v�V�������
Dim strCurOptCd()		'�I�v�V�����R�[�h
Dim strCurOptBranchNo()	'�I�v�V�����}��
Dim strCurOptName()		'�I�v�V������
Dim strCurSetClassCd()	'�Z�b�g���ރR�[�h
Dim lngCurOptCount		'�I�v�V����������

'�O��ۑ��Ƃ��ĕҏW����I�v�V�����̃C���f�b�N�X���
Dim strLastIndex()		'�O��ۑ����̎�f�I�v�V�������̃C���f�b�N�X�����z��
Dim lngLastIndexCount	'�I�v�V����������

'�ŐV���Ƃ��ĕҏW����I�v�V�����̃C���f�b�N�X���
Dim strCurIndex()		'�ŐV�̎�f�I�v�V�������̃C���f�b�N�X�����z��
Dim lngCurIndexCount	'�I�v�V����������

Dim strLastGender		'�O��ۑ����̐���
Dim strLastAge			'�O��ۑ����̎�f���N��
Dim strLastCslDivCd		'�O��ۑ����̎�f�敪�R�[�h

Dim strOrgSName			'�c�̗���
Dim strCsName			'�R�[�X��
Dim strFreeField		'�t���[�t�B�[���h
Dim lngOptCount			'�ŐV�̃I�v�V����������
Dim lngSetIndex			'�Z�b�g���ނ̃C���f�b�N�X
Dim blnEdit				'���炩��ҏW������
Dim Ret					'�֐��߂�l
Dim i, j				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
dtmCslDate     = CDate(Request("cslDate"))
lngRsvNo       = CLng("0" & Request("rsvNo"))
strPerId       = Request("perId")
strAge         = Request("age")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCsCd        = Request("csCd")
strCslDivCd    = Request("cslDivCd")
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = ConvIStringToArray(Request("optCd"))
strOptBranchNo = ConvIStringToArray(Request("optBranchNo"))
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�����Z�b�g���̔�r</TITLE>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�����Z�b�g���̔�r</FONT></B></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD NOWRAP>��f��</TD>
		<TD>�F</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= dtmCslDate %></B></FONT></TD>
		<TD NOWRAP>�@�\��ԍ��F</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
	</TR>
</TABLE>
<%
'�l���ǂݍ���
Set objPerson = Server.CreateObject("HainsPerson.Person")
Ret = objPerson.SelectPerson_Lukes(strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strBirth, strGender)
Set objPerson = Nothing
If Ret = False Then
	Err.Raise 1000, , "�l��񂪑��݂��܂���B"
End If

Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD HEIGHT="3"></TD>
	</TR>
	<TR>
		<TD ROWSPAN="2" VALIGN="top" NOWRAP><%= strPerId %></TD>
		<TD NOWRAP><B><%= Trim(strLastName  & "�@" & strFirstName) %></B>�i<%= Trim(strLastKName & "�@" & strFirstKName) %>�j</TD>
	</TR>
	<TR>
		<TD NOWRAP><%= objCommon.FormatString(CDate(strBirth), "ge.m.d") %>���@<%= CLng(strAge) %>�΁@<%= IIf(strGender = CStr(GENDER_MALE), "�j��", "����") %></TD>
	</TR>
</TABLE>
<%
Set objCommon = Nothing

'�c�̖��̓ǂݍ���
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , strOrgSName
Set objOrganization = Nothing

'�R�[�X���̓ǂݍ���
Set objCourse = Server.CreateObject("HainsCourse.Course")
objCourse.SelectCourse strCsCd, strCsName
Set objCourse = Nothing

Set objFree = Server.CreateObject("HainsFree.Free")

'��f�敪�̓ǂݍ���
objFree.SelectFree 0, strCslDivCd, , , , strFreeField
%>
<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
	<TR>
		<TD HEIGHT="30" NOWRAP>�c�́F</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strOrgSName %></B></FONT></TD>
		<TD NOWRAP>��f�R�[�X�F</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
		<TD NOWRAP>��f�敪�F</TD>
		<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strFreeField %></B></FONT></TD>
	</TR>
</TABLE>
<%
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'��f���̓ǂݍ���
objConsult.SelectConsult lngRsvNo, , , , , strCsName, , , , , , strLastAge, , , , , , , , , , , , , , , , , , , strOrgSName, , , , , , , , , , , , , , , , , strLastGender, , , , , strLastCslDivCd

'��f�敪�̓ǂݍ���
objFree.SelectFree 0, strLastCslDivCd, , , , strFreeField

Set objFree = Nothing
%>
<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
	<TR>
		<TD HEIGHT="30" NOWRAP>�i�O��ۑ����j</TD>
		<TD NOWRAP><%= strOrgSName %></TD>
		<TD NOWRAP><%= strCsName %></TD>
		<TD NOWRAP><%= CLng(strLastAge) %>��</TD>
		<TD NOWRAP><%= IIf(strLastGender = CStr(GENDER_MALE), "�j��", "����") %></TD>
		<TD NOWRAP>��f�敪�F<%= strFreeField %></TD>
	</TR>
</TABLE>
<%
'�Z�b�g���ޏ��̓ǂݍ���
Set objSetClass = Server.CreateObject("HainsSetClass.SetClass")
lngSetClassCount = objSetClass.SelectSetClassList(strSetClassCd, strSetClassName)
Set objSetClass = Nothing

'�Z�b�g���ނȂ��p�̗v�f�ǉ��ɍۂ��A�v�f�����݂��Ȃ��ꍇ�͔z����쐬
If lngSetClassCount = 0 Then
	strSetClassCd   = Array()
	strSetClassName = Array()
End If

'�Z�b�g���ނȂ��p�̗v�f��ǉ�
ReDim Preserve strSetClassCd(lngSetClassCount)
ReDim Preserve strSetClassName(lngSetClassCount)
strSetClassCd(lngSetClassCount)   = ""
strSetClassName(lngSetClassCount) = "�i�Ȃ��j"
lngSetClassCount = lngSetClassCount + 1

'�f�[�^�x�[�X��̍ŐV�ƂȂ�I�v�V�����������̓ǂݍ���
lngLastOptCount = objConsult.SelectConsult_O(lngRsvNo, strLastOptCd, strLastOptBranchNo, strLastOptName, strLastSetClassCd)

Set objConsult = Nothing

'�ŐV�̃I�v�V�����������n����Ă���ꍇ
If IsArray(strOptCd) Then

	'�ŐV�̃I�v�V�������������擾
	lngOptCount = UBound(strOptCd) + 1

	'�w��_��p�^�[���̑S�I�v�V�����������擾
	Set objContract = Server.CreateObject("HainsContract.Contract")
	lngCtrOptCount = objContract.SelectCtrPtOptFromConsult(dtmCslDate, strCslDivCd, strCtrPtCd, , strGender, strBirth, , , , strCtrOptCd,  strCtrOptBranchNo, strCtrOptName, , , strCtrSetClassCd)
	Set objContract = Nothing

	'�ŐV�̃I�v�V�����Ƃ��đ��݂�����݂̂̂�ǉ�
	For i = 0 To lngCtrOptCount - 1
		For j = 0 To lngOptCount - 1
			If strOptCd(j) = strCtrOptCd(i) And strOptBranchNo(j) = strCtrOptBranchNo(i) Then
				ReDim Preserve strCurOptCd(lngCurOptCount)
				ReDim Preserve strCurOptBranchNo(lngCurOptCount)
				ReDim Preserve strCurOptName(lngCurOptCount)
				ReDim Preserve strCurSetClassCd(lngCurOptCount)
				strCurOptCd(lngCurOptCount)       = strCtrOptCd(i)
				strCurOptBranchNo(lngCurOptCount) = strCtrOptBranchNo(i)
				strCurOptName(lngCurOptCount)     = strCtrOptName(i)
				strCurSetClassCd(lngCurOptCount)  = strCtrSetClassCd(i)
				lngCurOptCount = lngCurOptCount + 1
				Exit For
			End If
		Next
	Next

End If

'�f�[�^�x�[�X��̍ŐV�A��ʏ�̍ŐV�I�v�V���������̂����ꂩ�����݂���Δ�r����ҏW����
If lngLastOptCount > 0 Or lngCurOptCount > 0 Then
%>
	<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="0">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<TD NOWRAP>�Z�b�g����</TD>
			<TD COLSPAN="4" WIDTH="50%" NOWRAP>�O��ۑ���</TD>
			<TD COLSPAN="4" WIDTH="50%" NOWRAP>�ŐV�̏��</TD>
		</TR>
<%
		'�Z�b�g���ނ��x�[�X�Ɍ����J�n
		For lngSetIndex = 0 To lngSetClassCount - 1

			'�i�[���̏�����
			Erase strLastIndex
			lngLastIndexCount = 0
			Erase strCurIndex
			lngCurIndexCount = 0

			'�O��ۑ����̎�f�I�v�V������񂩂猻�Z�b�g���ނ̂��̂��������A���̃C���f�b�N�X���i�[
			For i = 0 To lngLastOptCount - 1
				If strLastSetClassCd(i) = strSetClassCd(lngSetIndex) Then
					ReDim Preserve strLastIndex(lngLastIndexCount)
					strLastIndex(lngLastIndexCount) = i
					lngLastIndexCount = lngLastIndexCount + 1
				End If
			Next

			'�ŐV�̂̎�f�I�v�V������񂩂猻�Z�b�g���ނ̂��̂��������A���̃C���f�b�N�X���i�[
			For i = 0 To lngCurOptCount - 1
				If strCurSetClassCd(i) = strSetClassCd(lngSetIndex) Then
					ReDim Preserve strCurIndex(lngCurIndexCount)
					strCurIndex(lngCurIndexCount) = i
					lngCurIndexCount = lngCurIndexCount + 1
				End If
			Next

			'�i�[���ɉ��炩�̓��e�����݂���ΕҏW���J�n����
			If lngLastIndexCount > 0 Or lngCurIndexCount > 0 Then

				'���łɉ��炩�̕ҏW���s���Ă���ꍇ�A�Z�b�g���ނ̕ς��ڂŃZ�p���[�^��ҏW����
				If blnEdit Then
%>
					<TR>
						<TD COLSPAN="9" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" HEIGHT="1" WIDTH="1" ALT=""></TD>
					</TR>
<%
				End If

				'�ȍ~�̃Z�b�g���ނ̕ς��ڂŃZ�p���[�^��ҏW�ł���悤�A�t���O�𐬗�������
				blnEdit = True

				'�O��l����эŐV���Ƃ��ɕҏW���ׂ��I�v�V���������ҏW��������܂ŏ����𔽕�
				i = 0
				Do Until i >= lngLastIndexCount And i >= lngCurIndexCount
%>
					<TR>
						<TD NOWRAP><%= IIf(i = 0, strSetClassName(lngSetIndex), "") %></TD>
<%
						'�ҏW���ׂ��O��ۑ����̎�f�I�v�V�������ɒB���Ă��Ȃ��ꍇ�͕ҏW
						If i < lngLastIndexCount Then
%>
							<TD NOWRAP><%= strLastOptCd(strLastIndex(i)) %></TD>
							<TD NOWRAP>-<%= strLastOptBranchNo(strLastIndex(i)) %></TD>
							<TD>�F</TD>
							<TD WIDTH="50%" NOWRAP><%= strLastOptName(strLastIndex(i)) %></TD>
<%
						Else
%>
							<TD COLSPAN="4"></TD>
<%
						End If

						'�ҏW���ׂ��ŐV�̎�f�I�v�V�������ɒB���Ă��Ȃ��ꍇ�͕ҏW
						If i < lngCurIndexCount Then
%>
							<TD NOWRAP><%= strCurOptCd(strCurIndex(i)) %></TD>
							<TD NOWRAP>-<%= strCurOptBranchNo(strCurIndex(i)) %></TD>
							<TD>�F</TD>
							<TD WIDTH="50%" NOWRAP><%= strCurOptName(strCurIndex(i)) %></TD>
<%
						End If
%>
					</TR>
<%
					i = i + 1
				Loop

			End If

		Next
%>
	</TABLE>
<%
Else
%>
	<BR>�����Z�b�g�͂���܂���B
<%
End If
%>
</BODY>
</HTML>