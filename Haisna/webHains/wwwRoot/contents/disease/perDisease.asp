<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�������E�Ƒ��� (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim strMode  		'�������[�h(�폜:"delete")
Dim strPerID		'�l�h�c
Dim strRelation		'����
Dim strDisCd		'�a���R�[�h
Dim strDisName		'�a��
Dim strStrDate		'���a�N��
Dim strEndDate		'�����N��
Dim strCondition	'���
Dim strMedical		'��Ë@��

Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strGenderName	'���ʖ���

Dim lngAllCount		'�����𖞂����S���R�[�h����
Dim lngCount		'���R�[�h����

Dim strDispStrDate	'�ҏW�p�̔��a�N��
Dim strDispEndDate	'�ҏW�p�̎����N��

Dim objCommon		'�����A��ԏ��A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objDisease		'�������Ƒ������A�N�Z�X�pCOM�I�u�W�F�N�g
Dim i				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objDisease = Server.CreateObject("HainsDisease.Disease")

'�����l�̎擾
strMode		= Request("mode") & ""
strPerID	= Request("perID") & ""
strRelation	= Request("relation") & ""
strDisCd	= Request("disCd") & ""
strStrDate	= Request("strDate") & ""

Do
	'�폜���[�h�ŋN�����ꂽ�Ƃ��A�폜���s��
	If strMode = "delete" Then

		objDisease.DeleteDisHistory strPerID, strRelation, strDisCd, strStrDate

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
<TITLE>�������E�Ƒ���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function deleteCheck(jumpUrl, paraRelationName, paraDisName, paraDispStrDate){

	if(paraRelationName=='')
	{
		res=confirm("���a�N���F" + paraDispStrDate + "�@�����ǁF" + paraDisName + "�̊��������폜���܂��B��낵���ł����H");
	}
	else
	{
		res=confirm("�����F" + paraRelationName + "�@�a���F" + paraDisName + "�@���a�N���F" + paraDispStrDate + "�̉Ƒ������폜���܂��B��낵���ł����H");
	}
	if(res==true){
		location.replace(jumpUrl); 
	}

	return false;
}

//-->
</SCRIPT>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->

<FORM NAME="diseaselist" action="#">
	<BLOCKQUOTE>

<%
		'�l���̃��R�[�h���擾
		If objDisease.SelectPerson(strPerID, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGenderName) Then

			'�l���̕ҏW
%>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="626">
				<TR>
					<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="TOP"><%= strPerID %></TD>
					<TD NOWRAP><B><%= strLastName & "�@" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>)</TD>
				</TR>
				<TR>
					<TD NOWRAP><%= strBirth %>���@<%= strGenderName %></TD>
				</TR>
			</TABLE>
<%
		End If
%>
		<BR>

		<BR>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="635">
			<TR VALIGN="bottom">
				<TD COLSPAN="2"><FONT SIZE="+2"><B>�������E�Ƒ���</B></FONT></TD>
			</TR>
			<TR HEIGHT="2">
				<TD COLSPAN="2" BGCOLOR="#CCCCCC"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2" BORDER="0"></TD>
			</TR>
		</TABLE>
		<BR>

		<BR>
		<TABLE WIDTH="500" BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
				<TD BGCOLOR="#999999" WIDTH="20%">
					<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH=100%>
						<TR HEIGHT="15">
							<TD BGCOLOR=#eeeeee NOWRAP><B>������</B></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>

		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
<%
				'�������̃��R�[�h�������擾
				lngAllCount = objDisease.SelectDiseaseListCount(strPerID)
				'�����������݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
				If lngAllCount = 0 Then
%>
					<TD NOWRAP>�������̓o�^�����͂O���ł��B</TD>
<%
				Else
%>
					<TD>
						<TABLE BORDER="0" CELLPADDING="2">
							<TR BGCOLOR="CCCCCC" ALIGN="CENTER">
								<TD NOWRAP>���a�N��</TD>
								<TD NOWRAP>������</TD>
								<TD NOWRAP>��Ë@��</TD>
								<TD NOWRAP>�����N��</TD>
								<TD NOWRAP>���</TD>
								<TD WIDTH="45" NOWRAP>����</TD>
							</TR>
<%
							'�������̃��R�[�h���擾
							lngCount = objDisease.SelectDiseaseList(strPerID, strStrDate, strDisCd, strDisName, strMedical, strEndDate, strCondition)

							For i = 0 To lngCount - 1
								strDispStrDate = objCommon.FormatString(strStrDate(i), "yyyy�Nmm��")
								If strEndDate(i) = "" Then
									strDispEndDate =  strEndDate(i)
								Else
									strDispEndDate = objCommon.FormatString(strEndDate(i), "yyyy�Nmm��")
								End If

								'�������̕ҏW
%>
								<TR BGCOLOR="EEEEEE">
									<TD NOWRAP><%= strDispStrDate %></TD>
									<TD NOWRAP><A HREF="/webHains/contents/disease/perEntryDisease.asp?mode=update&perID=<%= strPerID %>&relation=0&disCd=<%= strDisCd(i) %>&stryear=<%= Year(strStrDate(i)) %>&strmonth=<%= Month(strStrDate(i)) %>"><%= strDisName(i) %></A></TD>
									<TD NOWRAP><%= strMedical(i) %></TD>
									<TD NOWRAP><%= strDispEndDate %></TD>
									<TD NOWRAP><%= objCommon.SelectConditionName(strCondition(i)) %></TD>
									<TD ALIGN="center" WIDTH="45" NOWRAP><A HREF="javascript:function voi(){};voi()" ONCLICK="return deleteCheck('<%= Request.ServerVariables("SCRIPT_NAME") %>?mode=delete&perID=<%= strPerID %>&relation=0&disCd=<%= strDisCd(i) %>&strDate=<%= strStrDate(i) %>', '', '<%= strDisName(i) %>', '<%= strDispStrDate %>')">�폜</A></TD>
								</TR>
<%
							Next
%>
						</TABLE>
					</TD>
<%
				End If
%>
			</TR>
			<TR>
				<TD>
					<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
						<TR HEIGHT="15" ALIGN="CENTER">
							<TD BGCOLOR="#FFCCCC" NOWRAP><B><A HREF="/webHains/contents/disease/perEntryDisease.asp?mode=insert&perID=<%= strPerID %>&relation=0">�V���������Ǐ���ǉ�</A></B></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>
		<BR>

		<BR>
		<TABLE WIDTH="500" BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
				<TD BGCOLOR="#999999" WIDTH="20%">
					<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" WIDTH=100%>
						<TR HEIGHT="15">
							<TD BGCOLOR=#eeeeee NOWRAP><B>�Ƒ���</B></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>

		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
			<TR>
<%
				'�Ƒ����̃��R�[�h�������擾
				lngAllCount = objDisease.SelectFamilyListCount(strPerID)
				'�Ƒ��������݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
				If lngAllCount = 0 Then
%>
					<TD NOWRAP>�Ƒ����̓o�^�����͂O���ł��B</TD>
<%
				Else
%>
					<TD>
						<TABLE BORDER="0" CELLPADDING="2">
							<TR BGCOLOR="CCCCCC" ALIGN="CENTER">
								<TD NOWRAP>����</TD>
								<TD NOWRAP>�a��</TD>
								<TD NOWRAP>���a�N��</TD>
								<TD NOWRAP>�����N��</TD>
								<TD NOWRAP>���</TD>
								<TD WIDTH="45" NOWRAP>����</TD>
							</TR>
<%
							'�Ƒ����̃��R�[�h���擾
							lngCount = objDisease.SelectFamilyList(strPerID, strRelation, strDisCd, strDisName, strStrDate, strEndDate, strCondition)

							For i = 0 To lngCount - 1
								strDispStrDate = objCommon.FormatString(strStrDate(i), "yyyy�Nmm��")
								If strEndDate(i) = "" Then
									strDispEndDate =  strEndDate(i)
								Else
									strDispEndDate = objCommon.FormatString(strEndDate(i), "yyyy�Nmm��")
								End If

								'�Ƒ����̕ҏW
%>
								<TR BGCOLOR="EEEEEE">
									<TD NOWRAP><%= objCommon.SelectRelationName(strRelation(i)) %></TD>
									<TD NOWRAP><A HREF="/webHains/contents/disease/perEntryFamily.asp?mode=update&perID=<%= strPerID %>&relation=<%= strRelation(i) %>&disCd=<%= strDisCd(i) %>&stryear=<%= Year(strStrDate(i)) %>&strmonth=<%= Month(strStrDate(i)) %>"><%= strDisName(i) %></A></TD>
									<TD NOWRAP><%= strDispStrDate %></TD>
									<TD NOWRAP><%= strDispEndDate %></TD>
									<TD NOWRAP><%= objCommon.SelectConditionName(strCondition(i)) %></TD>
									<TD ALIGN="center" WIDTH="45" NOWRAP><A HREF="javascript:function voi(){};voi()" ONCLICK="return deleteCheck('<%= Request.ServerVariables("SCRIPT_NAME") %>?mode=delete&perID=<%= strPerID %>&relation=<%= strRelation(i) %>&disCd=<%= strDisCd(i) %>&strDate=<%= strStrDate(i) %>', '<%= objCommon.SelectRelationName(strRelation(i)) %>', '<%= strDisName(i) %>', '<%= strDispStrDate %>')">�폜</A></TD>
								</TR>
<%
							Next
%>
						</TABLE>
					</TD>
<%
				End If
%>
			</TR>
			<TR>
				<TD>
					<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
						<TR HEIGHT="15" ALIGN="CENTER">
							<TD BGCOLOR="#FFCCCC" NOWRAP><B><A HREF="/webHains/contents/disease/perEntryFamily.asp?mode=insert&perID=<%= strPerID %>">�V�����Ƒ��Ǐ���ǉ�</A></B></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
		</TABLE>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
