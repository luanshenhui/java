<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	�l�ԃh�b�N�Ǘ�ʐl�����v (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode			'������[�h
Dim vntMessage			'�ʒm���b�Z�[�W
Dim strURL			'URL
'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objOrganization	'�c�̏��A�N�Z�X�p
Dim objOrgBsd		'���ƕ����A�N�Z�X�p
Dim objOrgRoom		'�������A�N�Z�X�p
Dim objOrgPost		'�������A�N�Z�X�p
Dim objPerson		'�l���A�N�Z�X�p

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
'�����l
Dim strSCslYear, strSCslMonth, strSCslDay	'�J�n�N����
Dim strECslYear, strECslMonth, strECslDay	'�I���N����
Dim strCsKbn					'�R�[�X�敪	1:�P���l�ԃh�b�N 2:�P���a�@�O���h�b�N 3:�P���l�ԃh�b�N 4:���̑�
Dim strCsCd					'�R�[�X�R�[�h1�`10

Dim  prinmode					'�v�����g���[�h 
'��������������������

'��Ɨp�ϐ�
Dim strSCslDate		'�J�n��
Dim strECslDate		'�I����
Dim prinh
Dim prinhh

Dim i
Dim Flg
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBsd       = Server.CreateObject("HainsOrgBsd.OrgBsd")
Set objOrgRoom      = Server.CreateObject("HainsOrgRoom.OrgRoom")
Set objOrgPost      = Server.CreateObject("HainsOrgPost.OrgPost")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

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
' ���l�@�@ : URL�̈����l���擾���鏈�����L�q���ĉ�����
'
'-------------------------------------------------------------------------------
Sub GetQueryString()
'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
	'���ʓ��̕������HTML���ŋL�q�������ڂ̖��̂ƂȂ�܂�

'�� �J�n�N����
	If IsEmpty(Request("strCslYear")) Then
		strSCslYear   = Year(Now())				'�J�n�N
		strSCslMonth  = Month(Now())				'�J�n��
		strSCslDay    = Day(Now())				'�J�n��
	Else
		strSCslYear   = Request("strCslYear")			'�J�n�N
		strSCslMonth  = Request("strCslMonth")			'�J�n��
		strSCslDay    = Request("strCslDay")			'�J�n��
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = Year(Now())				'�I���N
		strECslMonth  = Month(Now())				'�J�n��
		strECslDay    = Day(Now())				'�J�n��
	Else
		strECslYear   = Request("endCslYear")			'�I���N
		strECslMonth  = Request("endCslMonth")			'�J�n��
		strECslDay    = Request("endCslDay")			'�J�n��
	End If
	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'�� �J�n�N�����ƏI���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
	   Right("00" & Trim(CStr(strSCslDay)), 2) _
	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
	   Right("00" & Trim(CStr(strECslDay)), 2) Then
		strSCslYear   = strECslYear
		strSCslMonth  = strECslMonth
		strSCslDay    = strECslDay
		strSCslDate   = strECslDate
		strECslYear   = Request("strCslYear")	'�J�n�N
		strECslMonth  = Request("strCslMonth")	'�J�n��
		strECslDay    = Request("strCslDay")	'�J�n��
		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	End If
	
	strCskbn     = Request("Cskbn")			'�R�[�X�敪

	ReDim strCsCd(10)
        
	strCsCd(1)     = Request("csCd1")			'�R�[�X�R�[�h1
        strCsCd(2)     = Request("csCd2")			'�R�[�X�R�[�h2
        strCsCd(3)     = Request("csCd3")			'�R�[�X�R�[�h3
        strCsCd(4)     = Request("csCd4")			'�R�[�X�R�[�h4
        strCsCd(5)     = Request("csCd5")			'�R�[�X�R�[�h5
        strCsCd(6)     = Request("csCd6")			'�R�[�X�R�[�h6
        strCsCd(7)     = Request("csCd7")			'�R�[�X�R�[�h7
        strCsCd(8)     = Request("csCd8")			'�R�[�X�R�[�h8
        strCsCd(9)     = Request("csCd9")			'�R�[�X�R�[�h9
        strCsCd(10)    = Request("csCd10")			'�R�[�X�R�[�h10

'    prinh = Request("print.x")
'    prinhh =Request("prevew.x")
    
'    if prinh <> "" then
'       prinmode = "0"
'    elseif prinhh <>"" then
'       prinmode = "1" 
'    end if   
       
 
'��������������������
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

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
	'�����Ƀ`�F�b�N�������L�q
	With objCommon
'��)		.AppendArray vntArrMessage, �R�����g

		If strMode <> "" Then
			If Not IsDate(strSCslDate) Then
				.AppendArray vntArrMessage, "�J�n���t������������܂���B"
			End If

			If Not IsDate(strECslDate) Then
				.AppendArray vntArrMessage, "�I�����t������������܂���B"
			End If
			
			Flg = 0
			For i = 1 To 10
				If Len(strCscd(i)) <> 0 then
					Flg = 1
				End if
			Next 
			
			If Flg = 0 then
				.AppendArray vntArrMessage, "�R�[�X�R�[�h���P�ȏ�I�����Ă��������B"
			End if
		End If

	End With
'��������������������

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
' ���l�@�@ : ���[�h�L�������g�t�@�C���쐬���\�b�h���Ăяo���B���\�b�h���ł͎��̏������s����B
' �@�@�@�@   �@������O���̍쐬
' �@�@�@�@   �A���[�h�L�������g�t�@�C���̍쐬
' �@�@�@�@   �B�����������͈�����O��񃌃R�[�h�̎�L�[�ł���v�����gSEQ��߂�l�Ƃ��ĕԂ��B
' �@�@�@�@   ����SEQ�l�����Ɉȍ~�̃n���h�����O���s���B
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objCommon	'���ʃN���X

	Dim objPrintCls		'�l�ԃh�b�N�Ǘ�ʐl�����v�o�͗pCOM�R���|�[�l���g
	Dim Ret			'�֐��߂�l

	If Not IsArray(CheckValue()) Then

'''�������������������� ��ʍ��ڂɂ��킹�ĕҏW
''		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
'''		Set objPrintCls = Server.CreateObject("HainsCslSheet.CslSheet")
''			'�v���W�F�N�g���̓\�[�X���J���Ċm�F�B
''
''		'�c�̈ꗗ�\�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
'''		Ret = objPrintCls.PrintCslSheet(Session("USERID"), ,cdate(strSCslDate), cdate(strECslDate),cint(strObject) )
'''��������������������
''
'''		Print = Ret


		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j	
		Set objPrintCls = Server.CreateObject("HainsDockStatistics.DockStatistics")

		'�l�ԃh�b�N�Ǘ�ʐl�����v�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
		Ret = objPrintCls.PrintDockStatistics( _
							Session("USERID"), _
						      	, _
						    	strSCslDate, _
						    	strECslDate, _
						    	strCskbn, _
						    	strCsCd(1), _
						    	strCsCd(2), _
						    	strCsCd(3), _
						    	strCsCd(4), _
						    	strCsCd(5), _
						    	strCsCd(6), _
						    	strCsCd(7), _
						    	strCsCd(8), _
						    	strCsCd(9), _
						    	strCsCd(10) _
						 	) 
		

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
<!--- �� ��<Title>�̏C����Y��Ȃ��悤�� �� -->
<TITLE>�l�ԃh�b�N���ѕ񍐗p��</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY >

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">  
	<BLOCKQUOTE>

<!--- �^�C�g�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><Font color="#0000FF">��</font>�l�ԃh�b�N���ѕ񍐗p��</TD>
		</TR>
	</TABLE>
<%
'�G���[���b�Z�[�W�\��

'	Dim strArrMessage
'	strArrMessage = CheckValue()
'	if IsArray(strArrMessage) Then
'		Response.Write "<BR>" & vblf
'		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
'	End If
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
	<BR>

<!--- ���t -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>��</TD>

			<TD>�`</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>
	<BR>	


<!--- �R�[�X�敪 -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�敪</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="Radio" NAME="Cskbn" VALUE="1" <%= "CHECKED" %>>�P���l�ԃh�b�N</TD>
			<TD><INPUT TYPE="Radio" NAME="Cskbn" VALUE="2" >�P���a�@�O���h�b�N</TD>
			<TD><INPUT TYPE="Radio" NAME="Cskbn" VALUE="3" >�P���l�ԃh�b�N</TD>
			<TD><INPUT TYPE="Radio" NAME="Cskbn" VALUE="4" >���̑�</TD>
		</TR>
	</TABLE>
	<BR>
	
<!--- �R�[�X�P -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�P</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd1", strCsCd(1), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- �R�[�X�Q -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�Q</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd2", strCsCd(2), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- �R�[�X�R -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�R</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd3", strCsCd(3), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- �R�[�X�S -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�S</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd4", strCsCd(4), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- �R�[�X�T -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�T</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd5", strCsCd(5), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- �R�[�X�U -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�U</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd6", strCsCd(6), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- �R�[�X�V -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�V</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd7", strCsCd(7), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- �R�[�X�W -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�W</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd8", strCsCd(8), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- �R�[�X�X -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�X</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd9", strCsCd(9), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>
<!--- �R�[�X�P�O -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�R�[�X�P�O</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd10", strCsCd(10), NON_SELECTED_ADD, False) %></TD>
		</TR>
	</TABLE>

	<BR>


<!--- ������[�h -->
<%
	'������[�h�̏����ݒ�
	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<INPUT TYPE="hidden" NAME="mode" VALUE="0">
	</TABLE>

	<BR><BR>

<!--- ����{�^�� -->
	<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">&nbsp;
	<%  End if  %>


<!--    <INPUT TYPE="image" NAME="prevew" SRC="/webHains/images/Preview.gif" WIDTH="77" HEIGHT="24" ALT="�v���r���[����(��������X�V���܂���I)"> -->
 
	</BLOCKQUOTE>
<!-- 2004/01/02 DEL START DEBUG������폜 (NSC)Birukawa
<%= strSCslDate %>
<BR>
<%= strECslDate %>
<br>
<%= strCskbn %>
<BR>
<%=  strCsCd(1) %>
<BR>
<%=  strCsCd(2) %>
<BR>
<%=  strCsCd(3) %>
<BR>
<%=  strCsCd(4) %>
<BR>
<%=  strCsCd(5) %>
<BR>
<%=  strCsCd(6) %>
<BR>
<%=  strCsCd(7) %>
<BR>
<%=  strCsCd(8) %>
<BR>
<%=  strCsCd(9) %>
<BR>
<%=  strCsCd(10) %>
<BR>
<%= strMode %>
-->

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>