<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		��������f���ꗗ (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode			'������[�h
Dim vntMessage		'�ʒm���b�Z�[�W

'-------------------------------------------------------------------------------
' �ŗL�錾��
'-------------------------------------------------------------------------------
'�����l
Dim lngGetMode			'���o���[�h(0:��f���w��A1:���ߓ��w��)
Dim lngStrCslYear		'�J�n��f�N
Dim lngStrCslMonth		'�J�n��f��
Dim lngStrCslDay		'�J�n��f��
Dim lngEndCslYear		'�I����f�N
Dim lngEndCslMonth		'�I����f��
Dim lngEndCslDay		'�I����f��
Dim strNoDemandData		'"1":�������f�[�^�̂ݒ��o
Dim strBillNo			'�������ԍ�

'��Ɨp�ϐ�
Dim strStrCslDate		'�J�n��f�N����
Dim strEndCslDate		'�I����f�N����

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'���ʈ����l�̎擾
strMode = Request("mode")

'���[�o�͏�������
vntMessage = PrintControl(strMode)

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : URL�����l�̎擾
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

	'���o���[�h
	lngGetMode = CLng("0" & Request("getMode"))

	'�J�n��f�N����
	lngStrCslYear  = CLng("0" & Request("strCslYear"))
	lngStrCslMonth = CLng("0" & Request("strCslMonth"))
	lngStrCslDay   = CLng("0" & Request("strCslDay"))
	lngStrCslYear  = IIf(lngStrCslYear  <> 0, lngStrCslYear,  Year(Date))
	lngStrCslMonth = IIf(lngStrCslMonth <> 0, lngStrCslMonth, Month(Date))
	lngStrCslDay   = IIf(lngStrCslDay   <> 0, lngStrCslDay,   Day(Date))
	strStrCslDate  = lngStrCslYear & "/" & lngStrCslMonth & "/" & lngStrCslDay

	'�I����f�N����
	lngEndCslYear  = CLng("0" & Request("endCslYear"))
	lngEndCslMonth = CLng("0" & Request("endCslMonth"))
	lngEndCslDay   = CLng("0" & Request("endCslDay"))
	lngEndCslYear  = IIf(lngEndCslYear  <> 0, lngEndCslYear,  Year(Date))
	lngEndCslMonth = IIf(lngEndCslMonth <> 0, lngEndCslMonth, Month(Date))
	lngEndCslDay   = IIf(lngEndCslDay   <> 0, lngEndCslDay,   Day(Date))
	strEndCslDate  = lngEndCslYear & "/" & lngEndCslMonth & "/" & lngEndCslDay

	'�Ώۃf�[�^
	strNoDemandData = IIf(strMode <> "", Request("noDemandData"), "1")

	'�������ԍ�
	strBillNo = Request("billNo")

End Sub
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
	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	With objCommon

		'��f���w��̏ꍇ
		If lngGetMode = 0 Then

			If Not IsDate(strStrCslDate) Then
				.AppendArray vntArrMessage, "�J�n��f���̓��͌`��������������܂���B"
			End If

			If Not IsDate(strEndCslDate) Then
				.AppendArray vntArrMessage, "�I����f���̓��͌`��������������܂���B"
			End If

		'���ߓ��w��̏ꍇ
		Else

'## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ�
'			.AppendArray vntArrMessage, .CheckNumeric("�������ԍ�", strBillNo, 9)
			.AppendArray vntArrMessage, .CheckNumeric("�������ԍ�", strBillNo, 14)
'## 2004/06/28 MOD END

		End If

	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���[�h�L�������g�t�@�C���쐬����
'
' �����@�@ :
'
' �߂�l�@ : ������O���̃V�[�P���X�l
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objBillConsultList	'�l��f���z�ꗗ�o�͗pCOM�R���|�[�l���g

	Dim dtmStrCslDate	'�J�n��f���܂��͒��ߓ�
	Dim dtmEndCslDate	'�I����f���܂��͒��ߓ�
	Dim Ret				'�֐��߂�l

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objBillConsultList = Server.CreateObject("HainsBillConsultList.BillConsultList")

	dtmStrCslDate = CDate(strStrCslDate)
	dtmEndCslDate = CDate(strEndCslDate)

	'���R�����΍��p���O�����o��
	Call putPrivacyInfoLog("PH103", "�f�[�^���o ��������f�ꗗ���o���t�@�C���o�͂��s����")

	'�l��f���z�ꗗ�h�L�������g�t�@�C���쐬����
	Ret = objBillConsultList.PrintBillConsultList(Session("USERID"), lngGetMode, dtmStrCslDate, dtmEndCslDate, strBillNo, (strNoDemandData = "1"))

	Print = Ret

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��������f���ꗗ</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<SCRIPT TYPE="text/javascript">
<!--

// submit���̏���
function submitForm() {

	document.entryForm.submit();

}

// �K�C�h��ʂ����
function closeWindow() {

	calGuide_closeGuideCalendar();

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.datatab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">��������f���ꗗ</FONT></B></TD>
	</TR>
</TABLE>
<%
	'�G���[���b�Z�[�W�\��
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR>
		<TD><INPUT TYPE="radio" NAME="getMode" VALUE="0" <%= IIf(lngGetMode = 0, "CHECKED", "") %>></TD>
		<TD NOWRAP>��f���ԂŒ��o</TD>
	</TR>
	<TR>
		<TD></TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
				<TR>
					<TD><FONT COLOR="#ff0000">��</FONT></TD>
					<TD WIDTH="90" NOWRAP>��f��</TD>
					<TD>�F</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrCslYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("strCslMonth", 1, 12, lngStrCslMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("strCslDay", 1, 31, lngStrCslDay, False) %></TD>
					<TD>��</TD>
					<TD>�`</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndCslYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("endCslMonth", 1, 12, lngEndCslMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("endCslDay", 1, 31, lngEndCslDay, False) %></TD>
					<TD>��</TD>
				</TR>
			</TABLE>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
				<TR>
					<TD><FONT COLOR="#ff0000">��</FONT></TD>
					<TD WIDTH="90" NOWRAP>�Ώۃf�[�^</TD>
					<TD>�F</TD>
					<TD><INPUT TYPE="checkbox" NAME="noDemandData" VALUE="1" <%= IIf(strNoDemandData <> "", "CHECKED", "") %>></TD>
					<TD>�������f�[�^�̂ݏo��</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD><INPUT TYPE="radio" NAME="getMode" VALUE="1" <%= IIf(lngGetMode = 1, "CHECKED", "") %>></TD>
		<TD NOWRAP>������No�Œ��o</TD>
	</TR>
	<TR>
		<TD></TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
				<TR>
					<TD><FONT COLOR="#ff0000">��</FONT></TD>
					<TD WIDTH="90" NOWRAP>�������ԍ�</TD>
					<TD>�F</TD>
<% '## 2004/06/28 MOD STR ORB)T.YAGUCHI ���H���őΉ� %>
<!--					<TD><INPUT TYPE="text" NAME="billNo" SIZE="12" MAXLENGTH="9" VALUE="<%= strBillNo %>"></TD>-->
					<TD><INPUT TYPE="text" NAME="billNo" SIZE="20" MAXLENGTH="14" VALUE="<%= strBillNo %>"></TD>
<% '## 2004/06/28 MOD END %>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>

<BR><BR>

<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>    
    <A HREF="javascript:submitForm()"><IMG SRC="/webHains/images/DataSelect.gif"></A>
<%  end if  %>

</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>