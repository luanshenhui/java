<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�c�̐��������ރ����e�i���X (Ver0.0.1)
'		AUTHER  : Eiichi Yamamoto K-MIX
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc" -->
<!-- #include virtual = "/webHains/includes/EditIsrDivList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objOrganization		'�c�̃e�[�u���A�N�Z�X�p
Dim objOrgBillClass		'�c�̐��������ރA�N�Z�X�p

Dim strMode				'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strTarget			'�^�[�Q�b�g���URL
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strOrgKName			'�c�̃J�i��
Dim strOrgName			'�c�̖�
Dim strOrgSName			'�c�̗���

Dim blnOpAnchor			'����p�A���J�[����
Dim strArrMessage		'�G���[���b�Z�[�W
Dim strMessage			'�G���[���b�Z�[�W�i�ҏW�p�j
Dim lngStatus			'�֐��߂�l
Dim i					'�C���f�b�N�X

Dim strBillClassCd		'���������ރR�[�h
Dim strOrgBillName		'�������p����
Dim strArrBillClassCd	'���������ށi�\���p�j
Dim strArrBillClassName	'���������i�\���p�j
Dim strArrOrgCd			'�c�̃R�[�h�i�\���p�j
Dim strArrCheckFlg		'
Dim strCheckFlg			'
Dim strCsCd				'
Dim strLngCount			'
Dim vntArrMessage		'�G���[���b�Z�[�W�̏W��

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBillClass = Server.CreateObject("HainsOrgBillClass.OrgBillClass")

'�����l�̎擾
strMode        = Request("mode")
strAction      = Request("action")
strTarget      = Request("target")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")

strBillClassCd = Request("billClassCd")
strArrBillClassCd	= IIf( strBillClassCd = "" , Empty  , ConvIStringToArray(strBillClassCd) )
strArrCheckFlg		= IIf( strBillClassCd = "" , Empty  , ConvIStringToArray(strBillClassCd) )

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'�ۑ��{�^��������
	If strAction = "save" Then

		'���̓`�F�b�N
		strArrMessage = CheckValue()
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'�ۑ�����
		If strMode = "update" Then

			'���������ފǗ��R�[�X�e�[�u���d���`�F�b�N
			if( Not IsEmpty(strArrBillClassCd) ) Then
				lngStatus = objOrgBillClass.SelectBillClass_c( _
													strArrBillClassCd, _
													strCsCd, _
													strLngCount _
															 )
															 
				'�C���T�[�g�G���[�ƂȂ����ꍇ�̓G���[���b�Z�[�W��ǉ�����B
				If( Not IsEmpty(strCsCd) ) Then
						strMessage = "���������ފǗ��̃R�[�X���d�����Ă��܂��B"
						For i = 0 To Ubound(strCsCd)
							strMessage = strMessage & "( " & strCsCd(i) & " ) <BR>"
							objCommon.AppendArray strArrMessage, strMessage
						Next
						Exit Do
				End If
			End If

			'�c�̐��������ރe�[�u�����R�[�h�X�V
			lngStatus = objOrgBillClass.InsertOrgBillClass( _
												strOrgCd1, _
												strOrgCd2, _
												strArrBillClassCd _
											  			  )
			'�C���T�[�g�G���[�ƂȂ����ꍇ�̓G���[���b�Z�[�W��ǉ�����B
			If( lngStatus < 0 ) Then
				objCommon.AppendArray strArrMessage, "�c�̐��������ރe�[�u���ւ̃f�[�^�ǉ��Ɏ��s���܂����B"
				Exit Do
			End If

		End If

		'�ۑ��ɐ��������ꍇ�A�^�[�Q�b�g�w�莞�͎w����URL�փW�����v���A���w�莞�͍X�V���[�h�Ń��_�C���N�g
		If strTarget <> "" Then
			Response.Redirect strTarget & "?orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2
		Else
			Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&action=saveend&orgcd1=" & strOrgCd1 & "&orgcd2=" & strOrgCd2
		End If
		Response.End
	End If

	Exit Do
Loop

	'�c�̃e�[�u�����R�[�h�ǂݍ���
	objOrganization.SelectOrg strOrgCd1, strOrgCd2, strOrgKName, strOrgName, strOrgBillName, strOrgSName

	'�c�̐��������ރe�[�u�����R�[�h�ǂݍ���
	objOrgBillClass.SelectBillClass _
										strOrgCd1, _
										strOrgCd2, _
										strArrBillClassCd, _
										strArrBillClassName, _
										strArrCheckFlg

									   
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �c�̏��e�l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()
'
'	Dim objCommon		'���ʃN���X
'
'	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��
'	Dim strMessage		'�G���[���b�Z�[�W
'	Dim i				'�C���f�b�N�X
'
'	'���ʃN���X�̃C���X�^���X�쐬
'	Set objCommon = Server.CreateObject("HainsCommon.Common")
'
'	'�e�l�`�F�b�N����
'	With objCommon
'
'
'	End With
'
'	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�c�̐��������ރ����e�i���X</TITLE>
<!-- #include virtual = "/webHains/includes/zipGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--


//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:zipGuide_closeGuideZip()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"   VALUE="<%= strMode %>">
	<INPUT TYPE="hidden" NAME="action" VALUE="save">
	<INPUT TYPE="hidden" NAME="target" VALUE="<%= strTarget %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�c�̐��������ރ����e�i���X</FONT></B></TD>
		</TR>
	</TABLE>

<!-- ����{�^�� -->
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="650">
<TR>
	<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
</TR>
<TR>
	<TD ALIGN="right">
		<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
			<TR>
<!--  2003/01/22  EDIT  START  E.Yamamoto  -->
<!-- 				<TD><A HREF="../mntMenu.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A></TD>  -->
				<TD><A HREF="mntOrganization.asp?mode=update&orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A></TD>
<!--  2003/01/22  EDIT  END    E.Yamamoto  -->
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>

				<TD><INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="���͂����f�[�^��ۑ����܂�"></TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>

			</TR>
		</TABLE>
	</TD>
</TR>
<TR>
	<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
</TR>
</TABLE>

<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		'�ۑ��������́u�ۑ������v�̒ʒm
		If strAction = "saveend" Then
			Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

		'�����Ȃ��΃G���[���b�Z�[�W��ҏW
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�c�̃R�[�h</TD>
			<TD WIDTH="5"></TD>
			<TD><%= strOrgCd1 %>�|<%= strOrgCd2 %>
				<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>"><INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�c�̃J�i����</TD>
			<TD></TD>
			<TD><%= strOrgKName %></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�c�̖���</TD>
			<TD></TD>
			<TD><%= strOrgName %></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">�c�̗���</TD>
			<TD></TD>
			<TD><%= strOrgSName %></TD>
		</TR>
		<TR>
			<TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">���������ޖ���</TD>
			<TD></TD>
			<TD><%= strOrgBillName %></TD>
		</TR>
		<TR>
			<TD ROWSPAN="<%= UBound(strArrBillClassCd) + 1 %>"HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">����������</TD>
<%
		For i = 0 To UBound(strArrBillClassCd)
%>
		<%= IIf( i <> 0 ,"		<TR>" , "") %>
			<TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
					<TR>
						<TD><INPUT TYPE="CHECKBOX" NAME="billClassCd" VALUE="<%= strArrBillClassCd(i) %>" <%= IIf( strArrCheckFlg(i) <> "" , "CHECKED" , ""  ) %>><%= strArrBillClassName(i) %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
<% 
		Next
%>
					</TR>
				</TABLE>
		</TR>
	</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
