<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		�w����f�󋵁i�N�j(Ver0.0.1)
'		AUTHER  : (ORB)T.YAGUCHI
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
Dim strMode				'������[�h
Dim vntMessage			'�ʒm���b�Z�[�W
Dim strURL				'URL
Dim objFree						'�ėp���A�N�Z�X�p
'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon								'���ʃN���X

'�p�����[�^�l
Dim strSCslYear, strSCslMonth, strSCslDay	'��f�J�n�N����
Dim strDayId								'����ID
Dim UID										'���[�UID
Dim dtmStrCslDate 	'�J�n��f
'��Ɨp�ϐ�
Dim strSCslDate								'�J�n��
Dim strFreeCd					'�ėp�R�[�h
Dim strFreeField1				'�t�B�[���h�P
Dim strFreeField2				'�t�B�[���h�P
Dim lngFreeCount				'�ėp�R�[�h��
Dim strNationCd					'���ЃR�[�h
Dim i					'���[�v�C���f�b�N�X
Dim j					'���[�v�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFree       = Server.CreateObject("HainsFree.Free")

'���ʈ����l�̎擾
strMode = Request("mode")
'strNationCd = Request("nationcd")

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
' ���l�@�@ : URL�̈����l���擾���鏈�����L�q���ĉ�����
'
'-------------------------------------------------------------------------------
Sub GetQueryString()

'�� �J�n�N����
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'�J�n�N
'		strSCslMonth  = Month(Now())			'�J�n��
'		strSCslDay    = Day(Now())				'�J�n��
	Else
		strSCslYear   = Request("strCslYear")	'�J�n�N
'		strSCslMonth  = Request("strCslMonth")	'�J�n��
'		strSCslDay    = Request("strCslDay")	'�J�n��
	End If
'	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
	strSCslDate   = strSCslYear 


'�� ���[�UID
	UID = Session("USERID")
strNationCd     = Request("nationcd")
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

	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��

	'�����Ƀ`�F�b�N�������L�q
	With objCommon
'��)		.AppendArray vntArrMessage, �R�����g

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

	Dim objPrintCls		'�w����f�󋵁i�N�jCSV�쐬�pCOM�R���|�[�l���g
	Dim Ret			'�֐��߂�l
	Dim strURL

	If Not IsArray(CheckValue()) Then
	

		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
		Set objPrintCls = Server.CreateObject("HainsprtXsituationsYear.XsituationsYear")

	    	'�w����f�󋵁i�N�jCSV�쐬����
		Ret = objPrintCls.PrintXsituationsYear(Session("USERID"), _
			                                strSCslYear, strNationCd)

		strMode = "csv"
		Print = Ret
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
<TITLE>���w����f�󋵁i�N�j</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">���w����f�󋵁i�N�j</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>

	<!--- ���t -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="114" NOWRAP>���o�N</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>�N</TD>
		</TR>
	</TABLE>

<%
	lngFreeCount = objFree.SelectFree(1,"LST000592",strFreeCd,,,strFreeField1,strFreeField2)
%>


	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
					<TR>
						<TD><FONT COLOR="#ff0000">��</FONT></TD>
						<TD WIDTH="114" NOWRAP>���o�Ώی���</TD>
						<TD>�F</TD>
						<TD><%= EditDropDownListFromArray("nationcd", strFreeCd, strFreeField2, strNationCd, NON_SELECTED_DEL) %></TD>
					</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<INPUT TYPE="hidden" NAME="mode" VALUE="0">
		</TR>
	</TABLE>
				<BR><BR>

<!--- ����{�^�� -->
	<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">
	<%  End if  %>
	</BLOCKQUOTE>
<!--
 <%= strSCslDate %> 
 <%= strNationCd  %>
-->
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>