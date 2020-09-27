<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		webHains���O�\�� (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"   -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const FREECD_LOG = "LOG"	'�ėp�R�[�h(���O�p�����敪)

Dim objHainsLog		'���O�A�N�Z�X�p
Dim objFree			'�ėp���A�N�Z�X�p

Dim strMode			'�������[�h
Dim strStrDate		'�����
Dim strPrtStatus	'�X�e�[�^�X

Dim strLineColor	'���׍s�J���[
Dim strInUserID		'���[�U�h�c�i�e�[�u�������e�������Ȃ����[�U�͎���������������̂����\���j

Dim lngCount					'�\������

Dim vntIn_TransactionDiv 		'�\�������敪
Dim vntIn_InformationDiv 		'�\�����敪
Dim vntIn_TransactionID			'����ID
Dim vntIn_Message				'����������
Dim vntTransactionID 			'����ID
Dim vntInsDate 					'��������
Dim vntTransactionDiv 			'�����敪
Dim vntTransactionName 			'��������
Dim vntInformationDiv 			'���敪
Dim vntStatementNo 				'�����s
Dim vntLineNo 					'�Ώۏ����s
Dim vntMessage1 				'���b�Z�[�W�P
Dim vntMessage2 				'���b�Z�[�W�Q

Dim strTransactionDiv 			'�����敪
Dim strTransactionName 			'�����敪����

Dim strImageURL					'������ԗp�摜URL
Dim strInformationName			'���
Dim strEditTransactionName		'�ҏW�p������
Dim strEditMessage1				'�ҏW�p���b�Z�[�W�P
Dim strEditMessage2				'�ҏW�p���b�Z�[�W�Q

Dim vntMessage					'�G���[���b�Z�[�W
Dim i							'�C���f�b�N�X

Dim lngStartPos					'�\���J�n�ʒu
Dim strPageMaxLine				'�P�y�[�W�\���s��
Dim lngGetCount					'�P�y�[�W�\������
Dim lngAllCount					'�����𖞂����S���R�[�h����

Dim strSearchString				'�y�[�W�i�r�pQueryString
Dim strOrderByOld				'�\�����i1:�Â����̂���j
Dim lngYear						'�N
Dim lngMonth					'��
Dim lngDay						'��
Dim strDate						'���t

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------

'�����l�̎擾
strMode              = Request("mode")
vntIn_InformationDiv = Request("informationDiv")
vntIn_TransactionDiv = Request("transactionDiv")
vntIn_TransactionID  = Request("transactionID")
vntIn_Message        = Request("searchChar")
strPageMaxLine       = Request("PageMaxLine")
strOrderByOld        = Request("OrderByOld")
lngYear              = CLng("0" & Request("Year"))
lngMonth             = CLng("0" & Request("Month"))
lngDay               = CLng("0" & Request("Day"))
lngStartPos          = CLng("0" & Request("startPos"))
lngStartPos          = IIf(lngStartPos = 0, 1, lngStartPos)

'��f�J�n�E�I�����̃f�t�H���g�l�ݒ�(��f�J�n�N���O�ɂȂ�P�[�X�͏����\�����ȊO�ɂȂ�)
If lngYear = 0 Then
	lngYear  = Year(Date)
	lngMonth = Month(Date)
	lngDay   = Day(Date)
End If

'�\���s�����w��Ȃ�f�t�H���g�Z�b�g
If strPageMaxLine = "" Then
	strPageMaxLine = "50"
End If

'�����l�̃`�F�b�N
vntMessage = CheckValue()

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X

	Dim strMessage		'�G���[���b�Z�[�W�̏W��

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'���t�Ó����̃`�F�b�N
	strDate = lngYear & "/" & lngMonth & "/" & lngDay
	If Not IsDate(strDate) Then
		objCommon.appendArray strMessage, "�J�n��f���̓��͌`��������������܂���B"
	End If

	'�߂�l�̕ҏW
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

End Function

%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�V�X�e�����O�̕\��</TITLE>

<SCRIPT TYPE="text/javascript">
<!--
// �������s
function searchSubmit(){

	var myForm = document.ReportLog;	// ����ʂ̃t�H�[���G�������g
	var url    = '';					// �t�H�[���̑��M��t�q�k

	myForm.startPos.value = 1;			//Position������
	document.ReportLog.submit();
	return false;

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->

<!-- #include virtual = "/webHains/includes/navibar.inc"  -->
<FORM NAME="ReportLog" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= CStr(lngStartPos) %>">
<INPUT TYPE="hidden" NAME="mode" VALUE="print">
<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�V�X�e�����O�̕\��</FONT></B></TD>
	</TR>
</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
	<TR>
<%
	'�ėp�e�[�u�����烍�O��������ǂݍ���
	Set objFree = Server.CreateObject("HainsFree.Free")
	lngCount = objFree.SelectFree(1, FREECD_LOG, strTransactionDiv, strTransactionName)
	Set objFree = Nothing
	If lngCount > 0 Then
%>
		<TD>������</TD>
		<TD>�F</TD>
		<TD><%= EditDropDownListFromArray("transactionDiv", strTransactionDiv, strTransactionName, vntIn_TransactionDiv, NON_SELECTED_ADD) %></TD>
<%
	End If
%>
		<TD NOWRAP>�@���s��</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('Year', 'Month', 'Day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("Year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("Month", 1, 12, lngMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("Day", 1, 31, lngDay, False) %></TD>
					<TD>��</TD>
				</TR>
			</TABLE>
		</TD>

		<TD>����ID</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="text" SIZE="5" NAME="transactionID" VALUE="<%= vntIn_TransactionID %>" STYLE="ime-mode:disabled"></TD>


		<TD></TD>
	</TR>

</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>����������</TD>
		<TD>�F</TD>
		<TD COLSPAN="4">
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><INPUT TYPE="text" SIZE="15" NAME="searchChar" VALUE="<%= vntIn_Message %>"></TD>
					<TD>�@���</TD>
					<TD>�F</TD>
					<TD>
						<SELECT NAME="informationDiv">
							<OPTION VALUE="" <%= IIf(vntIn_InformationDiv = "",  "SELECTED", "")%>>
							<OPTION VALUE="I"  <%= IIf(vntIn_InformationDiv = "I", "SELECTED", "")%>>����
							<OPTION VALUE="W"  <%= IIf(vntIn_InformationDiv = "W", "SELECTED", "" )%>>�x��
							<OPTION VALUE="E"  <%= IIf(vntIn_InformationDiv = "E", "SELECTED", "" )%>>�G���[
						</SELECT>
					</TD>

					<TD>�@�\���F</TD>
					<TD>
						<SELECT NAME="OrderByOld">
							<OPTION VALUE=""  <%= IIf(strOrderByOld = "",  "SELECTED", "")%>>�V�������̂���
							<OPTION VALUE="1" <%= IIf(strOrderByOld = "1", "SELECTED", "")%>>�Â����̂���
						</SELECT>
					</TD>
					<TD WIDTH="5"></TD>
					<TD>
						<SELECT NAME="pageMaxLine">
							<OPTION VALUE="50"  <%= IIf(strPageMaxLine = 50,  "SELECTED", "")%>>50�s����
							<OPTION VALUE="100" <%= IIf(strPageMaxLine = 100, "SELECTED", "")%>>100�s����
							<OPTION VALUE="200" <%= IIf(strPageMaxLine = 200, "SELECTED", "" )%>>200�s����
							<OPTION VALUE="300" <%= IIf(strPageMaxLine = 300, "SELECTED", "" )%>>300�s����
							<OPTION VALUE="999999999" <%= IIf(strPageMaxLine = 999999999, "SELECTED", "" )%>>���ׂ�
						</SELECT>
					</TD>
					<TD WIDTH="40"></TD>
					<TD WIDTH="40"></TD>
					<TD>
<!--						<A HREF="javascript:function voi(){};voi()">
							<IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��">
						</A>
-->
							<INPUT TYPE="IMAGE" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��" ONCLICK="JavaScript:return searchSubmit()">
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<%
	Do
		'�����\�����[�h�Ȃ牽�����Ȃ�
		If strMode = "" Then Exit Do

		'�G���[���͉������Ȃ�
		If Not IsEmpty(vntMessage) Then Exit Do

		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objHainsLog = Server.CreateObject("HainsHainsLog.HainsLog")

		'������O���擾
'		lngAllCount = objHainsLog.SelectHainsLog("CNT", _
'											  , _
'											  , _
'											  vntIn_TransactionDiv, _
'											  vntIn_InformationDiv, _
'											  vntIn_TransactionID, _
'											  vntIn_Message)

		lngAllCount = objHainsLog.SelectHainsLog("CNT", _
											  , _
											  , _
											  vntIn_TransactionDiv, _
											  vntIn_InformationDiv, _
											  vntIn_TransactionID, _
											  vntIn_Message, , , , , , , , , , strOrderByOld, strDate)

%>
		<BR>�������ʂ� <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>������܂����B<BR><BR>
<%
		'������O��񂪑��݂��Ȃ��ꍇ
		If lngAllCount = 0 Then
			Exit Do
		End If

%>
<TABLE>
	<TR BGCOLOR="CCCCCC">
		<TD NOWRAP>������</TD>
		<TD COLSPAN="2" NOWRAP>���</TD>
		<TD NOWRAP>���b�Z�[�W�P</TD>
		<TD NOWRAP>���b�Z�[�W�Q</TD>
		<TD NOWRAP>�����Ώۍs</TD>
		<TD NOWRAP>�����J�n����</TD>
		<TD NOWRAP>StatementNo</TD>
	</TR>

<%

		'������O���擾
		lngCount = objHainsLog.SelectHainsLog("SRC", _
											  lngStartPos, _
											  strPageMaxLine, _
											  vntIn_TransactionDiv, _
											  vntIn_InformationDiv, _
											  vntIn_TransactionID, _
											  vntIn_Message, _
											  vntTransactionID, _
											  vntInsDate, _
											  vntTransactionDiv, _
											  vntTransactionName, _
											  vntInformationDiv, _
											  vntStatementNo, _
											  vntLineNo, _
											  vntMessage1, _
											  vntMessage2, _
											  strOrderByOld, _
											  strDate)

		'������O�̕ҏW
		For i = 0 To lngCount - 1

			'������Ԃ̕ҏW
			Select Case trim(vntInformationDiv(i))
				Case "I"
					strImageURL = "ico_i.gif"
					strInformationName = "����"
				Case "E"
					strImageURL = "ico_e.gif"
					strInformationName = "�G���["
				Case "W"
					strImageURL = "ico_w.gif"
					strInformationName = "�x��"
				Case Else
					strInformationName = vntInformationDiv(i)
			End Select

			'�������̍ĕҏW
			If Trim(vntTransactionName(i)) = "" Then
				strEditTransactionName =  vntTransactionName(i)
			Else
				strEditTransactionName =  vntTransactionName(i)
			End If
			strEditTransactionName = strEditTransactionName & " (ID:" & vntTransactionID(i) & ")"

			'
			'�����񌟍��̏ꍇBold��
			strEditMessage1 = Replace(vntMessage1(i), vntIn_Message, "<FONT COLOR=""#ff6600""><B>" & vntIn_Message & "</B></FONT>")
			strEditMessage2 = Replace(vntMessage2(i), vntIn_Message, "<FONT COLOR=""#ff6600""><B>" & vntIn_Message & "</B></FONT>")

			'���׍s�J���[�̕ύX
			If ((i + 1) Mod 2) > 0 Then
				strLineColor = "#FFFFFF"
			Else
				strLineColor = "#EEEEEE"
			End If
%>
	<TR BGCOLOR=<%= strLineColor%>>
		<TD NOWRAP><%= strEditTransactionName %></TD>
		<TD NOWRAP><IMG SRC="/webHains/images/<%= strImageURL %>" WIDTH="16" HEIGHT="16"></TD>
		<TD NOWRAP><%= strInformationName %></TD>
		<TD NOWRAP><%= strEditMessage1 %></TD>
		<TD NOWRAP><%= strEditMessage2 %></TD>
		<TD NOWRAP><%= vntLineNo(i) %></TD>
		<TD NOWRAP><%= vntInsDate(i) %></TD>
		<TD NOWRAP><%= vntStatementNo(i) %></TD>
	</TR>
<%
		Next
%>
</TABLE>
<%
		Exit Do
	Loop
	Set objHainsLog = Nothing
%>

<%
	'�y�[�W���O�i�r�Q�[�^�̕ҏW
	If IsNumeric(strPageMaxLine) Then
		lngGetCount = CLng(strPageMaxLine)
		strSearchString = ""
		strSearchString = strSearchString & "mode=print"
		strSearchString = strSearchString & "&transactionDiv=" & vntIn_TransactionDiv
		strSearchString = strSearchString & "&informationDiv=" & vntIn_InformationDiv
		strSearchString = strSearchString & "&transactionID="  & vntIn_TransactionID
		strSearchString = strSearchString & "&searchChar="     & vntIn_Message
		strSearchString = strSearchString & "&pageMaxLine="    & strPageMaxLine

		strSearchString = strSearchString & "&Year="           & lngYear
		strSearchString = strSearchString & "&Month="          & lngMonth
		strSearchString = strSearchString & "&Day="            & lngDay
		strSearchString = strSearchString & "&lngMonth="       & strOrderByOld

%>
		<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?" & strSearchString, lngAllCount, lngStartPos, lngGetCount) %>
<%
	End If
%>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
