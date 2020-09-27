<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		������O�\�� (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objReportLog	'������O�A�N�Z�X�p

Dim strMode			'�������[�h
Dim lngPrtYear		'����N
Dim lngPrtMonth		'�����
Dim lngPrtDay		'�����
Dim lngCount		'�\������
Dim strStrDate		'�����
Dim intSortOld		'�\�[�g��
Dim strPrtStatus	'�X�e�[�^�X

Dim vntPrintSeq 	'�v�����g�r�d�p
Dim vntPrintDate 	'����J�n����
Dim vntReportCd 	'���[�R�[�h
Dim vntReportName 	'���[��
Dim vntUserId 		'���[�U�h�c
Dim vntUserName 	'���[�U��
Dim vntStatus 		'�X�e�[�^�X
Dim vntReportTempID '���[�ꎞ�t�@�C����
Dim vntEndDate 		'����I������
Dim vntCount 		'�o�͖���
Dim strStatusString	'����X�e�[�^�X�i������j
Dim strStatusColor	'����X�e�[�^�X�i�F�j
Dim strLineColor	'���׍s�J���[
Dim strInUserID		'���[�U�h�c�i�e�[�u�������e�������Ȃ����[�U�͎���������������̂����\���j

Dim strMessage		'�G���[���b�Z�[�W
Dim i				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objReportLog       = Server.CreateObject("HainsReportLog.ReportLog")

'�����l�̎擾
strMode      = Request("mode")
lngPrtYear   = CLng("0" & Request("prtYear"))
lngPrtMonth  = CLng("0" & Request("prtMonth"))
lngPrtDay    = CLng("0" & Request("prtDay"))
intSortOld   = Request("SortOld")
strPrtStatus = Request("PrtStatus")

'�p�����^�̃f�t�H���g�l�ݒ�
lngPrtYear   = IIf(lngPrtYear  = 0, Year(Now()),  lngPrtYear )
lngPrtMonth  = IIf(lngPrtMonth = 0, Month(Now()), lngPrtMonth)
lngPrtDay    = IIf(lngPrtDay = 0,   Day(Now()),   lngPrtDay)
intSortOld   = IIf(intSortOld = Empty, 0, intSortOld)

Do
	'�����\�����[�h�Ȃ牽�����Ȃ�
	If strMode = "" Then
		Exit Do
	End If

	'������̕ҏW
	strStrDate = lngPrtYear & "/" & lngPrtMonth & "/" & lngPrtDay

	'������̓��t�`�F�b�N
	If Not IsDate(strStrDate) Then
		strMessage = "������̓��͌`��������������܂���B"
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
<TITLE>������O�̕\��</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="ReportLog" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode" VALUE="print">

	<!-- �\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">������O�̕\��</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>������F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('prtYear', 'prtMonth', 'prtDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("prtYear", YEARRANGE_MIN, YEARRANGE_MAX, lngPrtYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("prtMonth", 1, 12, lngPrtMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("prtDay", 1, 31, lngPrtDay, False) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
			<TD>
				<SELECT NAME="prtStatus">
					<OPTION VALUE="" <%= IIf(strPrtStatus = "",  "SELECTED", "")%>>
					<OPTION VALUE=0  <%= IIf(strPrtStatus = "0", "SELECTED", "")%>>�����
					<OPTION VALUE=1  <%= IIf(strPrtStatus = "1", "SELECTED", "" )%>>����I��
					<OPTION VALUE=2  <%= IIf(strPrtStatus = "2", "SELECTED", "" )%>>�ُ�I��
				</SELECT>
			</TD>
			<TD>
				<SELECT NAME="SortOld">
					<OPTION VALUE=0 <%= IIf(intSortOld = "0", "SELECTED", "")%>>�V������
					<OPTION VALUE=1 <%= IIf(intSortOld = "1", "SELECTED", "" )%>>�Â���
				</SELECT>
			</TD>
			<TD><INPUT TYPE="image" NAME="display" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></TD>
		</TR>
	</TABLE>
<%
	Do
		'�����\�����[�h�Ȃ牽�����Ȃ�
		If strMode = "" Then Exit Do

		'�G���[���͉������Ȃ�
		If strMessage <> "" Then Exit Do

		'�S���O�\�����A�����[�U�݂̂��H
		strInUserID = ""
		If Session("AUTH_TBLMNT") = 0 Then
			strInUserID = Session("USERID")
		End If

		'������O���擾
		lngCount = objReportLog.SelectReportLog(strStrDate, _
												, _
												Iif(intSortOld = "1", True, False),_
												strPrtStatus,_
												vntPrintSeq, _
												vntPrintDate, _
												vntReportCd, _
												vntReportName, _
												vntUserId, _
												vntUserName, _
												vntStatus, _
												vntReportTempID, _
												vntEndDate, _
												vntCount, _
												strInUserID)

%>
		<BR>�u<FONT COLOR="#ff6600"><B><%= strStrDate %>�ȍ~�̈�����O</B></FONT>�v�̌������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>������܂����B<BR><BR>
<%
		'������O��񂪑��݂��Ȃ��ꍇ
		If lngCount = 0 Then
			Exit Do
		End If
%>
	<TABLE>
		<TR BGCOLOR="CCCCCC">
			<TD NOWRAP>�v�����g�r�d�p</TD>
			<TD NOWRAP>����J�n����</TD>
			<TD NOWRAP>���[�R�[�h</TD>
			<TD NOWRAP>���[��</TD>
			<TD NOWRAP>�X�e�[�^�X</TD>
			<TD NOWRAP>����I������</TD>
			<TD NOWRAP>�o�͖���</TD>
			<TD NOWRAP>���[�U�h�c</TD>
			<TD NOWRAP>���[�U��</TD>
			<TD NOWRAP>���[�ꎞ�t�@�C����</TD>
		</TR>

<%
		'������O�̕ҏW
		For i = 0 To lngCount - 1
			Select Case vntStatus(i)
				Case 0
					strStatusString = "�����"
					strStatusColor = "#999999"
				Case 1
					strStatusString = "����I��"
					strStatusColor = "BLACK"
				Case 2
					strStatusString = "�ُ�I��"
					strStatusColor = "RED"
				Case Else
					strStatusString = vntStatus(i)
					strStatusColor = "RED"
			End Select

			If ((i + 1) Mod 2) > 0 Then
				strLineColor = "#FFFFFF"
			Else
				strLineColor = "#EEEEEE"
			End If
%>
		<TR BGCOLOR=<%= strLineColor%>>
			<TD NOWRAP ALIGN="RIGHT"><%= vntPrintSeq(i) %></TD>
			<TD NOWRAP><%= vntPrintDate(i) %></TD>
			<TD NOWRAP ALIGN="RIGHT"><%= vntReportCd(i) %></TD>
			<TD NOWRAP><%= vntReportName(i) %></TD>
			<TD NOWRAP><FONT COLOR="<%= strStatusColor %>"><%= strStatusString %></FONT<</TD>
			<TD NOWRAP><%= vntEndDate(i) %></TD>
			<TD NOWRAP ALIGN="RIGHT"><%= vntCount(i) %></TD>
			<TD NOWRAP><%= vntUserId(i) %></TD>
			<TD NOWRAP><%= vntUserName(i) %></TD>
			<TD NOWRAP><A HREF="/webHains/contents/print/prtPreview.asp?documentFileName=<%= vntReportTempID(i) %>"><%= vntReportTempID(i) %></A></TD>
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
