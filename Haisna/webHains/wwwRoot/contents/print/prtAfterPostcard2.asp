<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	��f�ΏێҖ��� (Ver0.0.1)
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
Dim vntMessage		'�ʒm���b�Z�[�W
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
Dim YstrSCslYear, YstrSCslMonth, YstrSCslDay	'�\��J�n�N����
Dim YstrECslYear, YstrECslMonth, YstrECslDay	'�\��I���N����

Dim strCsCd									'�R�[�X�R�[�h
'Dim strSCsCd								'�T�u�R�[�X�R�[�h
Dim strOrgCd1, strOrgCd2					'�c�̃R�[�h
Dim strNotes								'�R�����g
Dim strOrgBsdCd, strOrgRoomCd				'���ƕ��R�[�h, �����R�[�h
Dim strSOrgPostCd, strEOrgPostCd			'�J�n�����R�[�h, �I�������R�[�h
Dim strPerId								'�l�R�[�h
Dim strObject								'�o�͑Ώ�
'��������������������
Dim UID
'��Ɨp�ϐ�
Dim strOrgName		'�c�̖�
Dim strBsdName		'���ƕ���
Dim strRoomName		'������
Dim strSPostName	'�J�n������
Dim strEPostName	'�I��������
Dim strLastName		'��
Dim strFirstName	'��
Dim strPerName		'����
Dim strSCslDate		'�J�n��
Dim strECslDate		'�I����

Dim YstrSCslDate		'�\��J�n��
Dim YstrECslDate		'�\��I����
Dim WYstrSCslDate		'�\��J�n��
Dim WYstrECslDate		'�\��I����
Dim WstrSCslDate		'�J�n��
Dim WstrECslDate		'�I����

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
'		strSCslYear   = Year(Now())				'�J�n�N
'		strSCslMonth  = Month(Now())			'�J�n��
'		strSCslDay    = Day(Now())				'�J�n��
          WstrSCslDate = DateAdd("M", -9, Now)
          strSCslYear = Mid(WstrSCslDate, 1, 4)
          strSCslMonth = Mid(WstrSCslDate, 6, 2)
'## 2003/12/27 Del NSC@Itoh
'          strSCslDay = Mid(WstrSCslDate, 10, 2)
	Else
		strSCslYear   = Request("strCslYear")	'�J�n�N
		strSCslMonth  = Request("strCslMonth")	'�J�n��
'## 2003/12/27 Del NSC@Itoh
'		strSCslDay    = Request("strCslDay")	'�J�n��
	End If

'## 2003/12/27 Upd NSC@Itoh
'	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
	strSCslDate   = strSCslYear & "/" & strSCslMonth 

'�� �I���N����
	If IsEmpty(Request("endCslYear")) Then
'		strECslYear   = Year(Now())				'�I���N
'		strECslMonth  = Month(Now())			'�J�n��
'		strECslDay    = Day(Now())				'�J�n��
          WstrECslDate = DateAdd("M", -9, Now)
          strECslYear = Mid(WstrSCslDate, 1, 4)
          strECslMonth = Mid(WstrSCslDate, 6, 2)
'## 2003/12/27 Del NSC@Itoh
'          strECslDay = Mid(WstrSCslDate, 10, 2)
	Else
		strECslYear   = Request("endCslYear")	'�I���N
		strECslMonth  = Request("endCslMonth")	'�J�n��
'## 2003/12/27 Del NSC@Itoh
'		strECslDay    = Request("endCslDay")	'�J�n��
	End If

'## 2003/12/27 Upd NSC@Itoh
'	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
	strECslDate   = strECslYear & "/" & strECslMonth 

'�� �J�n�N�����ƏI���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
'## 2003/12/27 Upd NSC@Itoh
'	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
'	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strSCslDay)), 2) _
'	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
'	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strECslDay)), 2) Then
	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
	   Right("00" & Trim(CStr(strSCslMonth)), 2) _
	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
	   Right("00" & Trim(CStr(strECslMonth)), 2) Then

		strSCslYear   = strECslYear
		strSCslMonth  = strECslMonth
'## 2003/12/27 Del NSC@Itoh
'		strSCslDay    = strECslDay
		strSCslDate   = strECslDate
		strECslYear   = Request("strCslYear")	'�J�n�N
		strECslMonth  = Request("strCslMonth")	'�J�n��
'## 2003/12/27 Del NSC@Itoh
'		strECslDay    = Request("strCslDay")	'�J�n��

'## 2003/12/27 Upd NSC@Itoh
'		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
		strECslDate   = strECslYear & "/" & strECslMonth 

	End If


'���\�� �J�n�N����
	If IsEmpty(Request("YstrCslYear")) Then
'		YstrSCslYear   = Year(Now())				'�J�n�N
'		YstrSCslMonth  = Month(Now())			'�J�n��
'		YstrSCslDay    = Day(Now())				'�J�n��
          WYstrSCslDate = DateAdd("M", -4, Now)
          YstrSCslYear = Mid(WYstrSCslDate, 1, 4)
          YstrSCslMonth = Mid(WYstrSCslDate, 6, 2)
'## 2003/12/27 Del NSC@Itoh
'          YstrSCslDay = Mid(WYstrSCslDate, 10, 2)
	Else
		YstrSCslYear   = Request("YstrCslYear")	'�J�n�N
		YstrSCslMonth  = Request("YstrCslMonth")	'�J�n��
'## 2003/12/27 Del NSC@Itoh
'		YstrSCslDay    = Request("YstrCslDay")	'�J�n��
	End If
'## 2003/12/27 Upd NSC@Itoh
'	YstrSCslDate   = YstrSCslYear & "/" & YstrSCslMonth & "/" & YstrSCslDay
	YstrSCslDate   = YstrSCslYear & "/" & YstrSCslMonth 

'�� �\��I���N����
	If IsEmpty(Request("YendCslYear")) Then
'		YstrECslYear   = Year(Now())				'�I���N
'		YstrECslMonth  = Month(Now())			'�J�n��
'		YstrECslDay    = Day(Now())				'�J�n��
          WYstrECslDate = DateAdd("M", +4, Now)
'## 2003/12/29 Upd Start NSC@birukawa
'          YstrECslYear = Mid(WYstrSCslDate, 1, 4)
'          YstrECslMonth = Mid(WYstrSCslDate, 6, 2)
          YstrECslYear = Mid(WYstrECslDate, 1, 4)
          YstrECslMonth = Mid(WYstrECslDate, 6, 2)
'## 2003/12/29 Upd End   NSC@birukawa
'## 2003/12/27 Del NSC@Itoh
'          YstrECslDay = Mid(WYstrSCslDate, 10, 2)
	Else
		YstrECslYear   = Request("YendCslYear")	'�I���N
		YstrECslMonth  = Request("YendCslMonth")	'�J�n��
'## 2003/12/27 Del NSC@Itoh
'		YstrECslDay    = Request("YendCslDay")	'�J�n��
	End If
'## 2003/12/27 Upd NSC@Itoh
'	YstrECslDate   = YstrECslYear & "/" & YstrECslMonth & "/" & YstrECslDay
	YstrECslDate   = YstrECslYear & "/" & YstrECslMonth 

'�� �\��J�n�N�����Ɨ\��I���N�����̑召����Ɠ���
'   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
'## 2003/12/27 Upd NSC@Itoh
'	If Right("0000" & Trim(CStr(YstrSCslYear)), 4) & _
'	   Right("00" & Trim(CStr(YstrSCslMonth)), 2) & _
'	   Right("00" & Trim(CStr(YstrSCslDay)), 2) _
'	 > Right("0000" & Trim(CStr(YstrECslYear)), 4) & _
'	   Right("00" & Trim(CStr(YstrECslMonth)), 2) & _
'	   Right("00" & Trim(CStr(YstrECslDay)), 2) Then
	If Right("0000" & Trim(CStr(YstrSCslYear)), 4) & _
	   Right("00" & Trim(CStr(YstrSCslMonth)), 2) _
	 > Right("0000" & Trim(CStr(YstrECslYear)), 4) & _
	   Right("00" & Trim(CStr(YstrECslMonth)), 2) Then
		YstrSCslYear   = YstrECslYear
		YstrSCslMonth  = YstrECslMonth
'## 2003/12/27 Del NSC@Itoh
'		YstrSCslDay    = YstrECslDay
		YstrSCslDate   = YstrECslDate
		YstrECslYear   = Request("YstrCslYear")	'�J�n�N
		YstrECslMonth  = Request("YstrCslMonth")	'�J�n��
'## 2003/12/27 Del NSC@Itoh
'		YstrECslDay    = Request("YstrCslDay")	'�J�n��
'## 2003/12/27 Upd NSC@Itoh
'		YstrECslDate   = YstrECslYear & "/" & YstrECslMonth & "/" & YstrECslDay
		YstrECslDate   = YstrECslYear & "/" & YstrECslMonth
	End If

	strCsCd       = Request("csCd")			'�R�[�X�R�[�h
'	strSCsCd      = Request("scsCd")		'�T�u�R�[�X�R�[�h

'�� �c��
	strOrgCd1     = Request("orgCd1")		'�c�̃R�[�h�P
	strOrgCd2     = Request("orgCd2")		'�c�̃R�[�h�Q
	If strOrgCd1 <> "" And strOrgCd2 <> "" Then
'## 2004/1/2 Upd Start (NSC)birukawa ���\�b�h���ύX
'		objOrganization.SelectlukeOrg strOrgCd1, strOrgCd2, , strOrgName
		objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgName
'## 2004/1/2 Upd End   (NSC)birukawa ���\�b�h���ύX

	End If

'�� �R�����g
	strNotes     = Request("notes")			'�R�����g

     UID = Session("USERID")

'�� ���ƕ�
'�� ����
'�� ����
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
'## 2003/12/27 Del NSC@Itoh
'			If Not IsDate(strSCslDate) Then
'				.AppendArray vntArrMessage, "�J�n���t������������܂���B"
'			End If
'			If Not IsDate(strECslDate) Then
'				.AppendArray vntArrMessage, "�I�����t������������܂���B"
'			End If
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
' �@�@�@�@   ?@������O���̍쐬
' �@�@�@�@   ?A���[�h�L�������g�t�@�C���̍쐬
' �@�@�@�@   ?B�����������͈�����O��񃌃R�[�h�̎�L�[�ł���v�����gSEQ��߂�l�Ƃ��ĕԂ��B
' �@�@�@�@   ����SEQ�l�����Ɉȍ~�̃n���h�����O���s���B
'
'-------------------------------------------------------------------------------
Function Print()

    Dim objCommon	'���ʃN���X
	Dim objPrintCls	'�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
	Dim Ret			'�֐��߂�l

	If Not IsArray(CheckValue()) Then

          Set objCommon = Server.CreateObject("HainsCommon.Common")
'## 2003/12/27 Upd NSC@Itoh
'		strURL = "/webHains/contents/report_form/rd_1_prtAfterPostcard.asp"
		strURL = "/webHains/contents/report_form/rd_01_prtAfterPostcard.asp"
		strURL = strURL & "?p_Uid=" & UID
'## 2003/12/27 Upd NSC@Itoh
'        strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
'        strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
'        strURL = strURL & "&p_yscsldate=" & objCommon.FormatString(CDate(YstrSCslDate ), "yyyy/mm/dd")
'		 strURL = strURL & "&p_yecsldate=" & objCommon.FormatString(CDate(YstrECslDate ), "yyyy/mm/dd") 
        strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate & "/01"), "yyyy/mm")
        strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate & "/01"), "yyyy/mm")
		strURL = strURL & "&p_yscsldate=" & objCommon.FormatString(CDate(YstrSCslDate & "/01"), "yyyy/mm")
		strURL = strURL & "&p_yecsldate=" & objCommon.FormatString(CDate(YstrECslDate & "/01"), "yyyy/mm") 

		Set objCommon = Nothing
        strURL = strURL & "&p_Org1=" & strOrgCd1
		strURL = strURL & "&p_Org2=" & strOrgCd2

		strURL = strURL & "&p_cmt=" & strNotes
 
		Response.Redirect strURL
		Response.End

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
<TITLE>�\��m�F�͂���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setNotes() {

	var wk_Notes;
	
	with ( document.entryForm ) {

		if ( NoteDiv.value == 1 ) {
			wk_Notes = ''
			wk_Notes = wk_Notes + '�q�[�@�M�Ђ܂��܂������˂̂��ƂƂ���ѐ\���グ�܂��B\n';
			wk_Notes = wk_Notes + '�������@�l�ԃh�b�N�������p�����������肪�Ƃ��������܂��B\n';
			wk_Notes = wk_Notes + '���āA�挎�ɂ��󂯂����������l�ԃh�b�N�̐�������������\���グ�܂��B\n';
			wk_Notes = wk_Notes + '���m�F�̏�A�w������܂ł������������܂��悤���肢�\���グ�܂��B\n';
			wk_Notes = wk_Notes + '����Ƃ��A����w�̂����������܂��悤���肢�\���グ�܂��B\n';
			wk_Notes = wk_Notes + '�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�@�h��';
			Notes.value = wk_Notes;

		}

		if ( NoteDiv.value == 2 ) {
			Notes.value = '';
		}

	}

}
// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.entryForm ) {

		// �c�́E�������G�������g�̎Q�Ɛݒ�i���͍��ڂɒc�́E�����������ꍇ�͕s�v�j
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName' );


	}

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

<!--- �^�C�g�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">����N�ڂ͂���</SPAN></B></TD>
		</TR>
	</TABLE>
	<BR>

<!--- ���t -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
<!-- ##2003/12/29 Upd NSC@birukawa
			<TD WIDTH="90" NOWRAP>��f��</TD>
-->
			<TD WIDTH="90" NOWRAP>��f�N��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>��</TD>
<!-- ## 2003/12/27 Del  NSC@Itoh
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>��</TD>
-->
			<TD>�`</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
			<TD>��</TD>
<!-- ## 2003/12/27 Del  NSC@Itoh
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
			<TD>��</TD>
-->
		</TR>
	</TABLE>
<!--- ���t -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
<!-- ##2003/12/29 Upd NSC@birukawa
			<TD WIDTH="90" NOWRAP>�\���</TD>
-->
			<TD WIDTH="90" NOWRAP>�\��N��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('YstrCslYear', 'YstrCslMonth', 'YstrCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("YstrCslYear", YEARRANGE_MIN, YEARRANGE_MAX, YstrSCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("YstrCslMonth", 1, 12, YstrSCslMonth, False) %></TD>
			<TD>��</TD>
<!-- ## 2003/12/27 Del  NSC@Itoh
			<TD><%= EditNumberList("YstrCslDay", 1, 31, YstrSCslDay, False) %></TD>
			<TD>��</TD>
-->
			<TD>�`</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('YendCslYear', 'YendCslMonth', 'YendCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("YendCslYear", YEARRANGE_MIN, YEARRANGE_MAX, YstrECslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("YendCslMonth", 1, 12, YstrECslMonth, False) %></TD>
			<TD>��</TD>
<!-- ## 2003/12/27 Del  NSC@Itoh
			<TD><%= EditNumberList("YendCslDay", 1, 31, YstrECslDay, False) %></TD>
			<TD>��</TD>
-->
		</TR>
	</TABLE>

<!--- �c�� -->
<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<% = strOrgCd1 %>">
<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<% = strOrgCd2 %>">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD><A HREF="javascript:orgPostGuide_clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
			<TD NOWRAP><SPAN ID="orgName"><% = strOrgName %></SPAN></TD>
		</TR>
	</TABLE>
<!--�R�����g-->
		<TR>
			<TD ROWSPAN="2" VALIGN="TOP"><font color="black">��</font></TD>
			<TD ROWSPAN="2" VALIGN="TOP" WIDTH="90" NOWRAP>�ē���</TD>
			<TD ROWSPAN="2" VALIGN="TOP">�F</TD>
			<TD>
				<select name="NoteDiv" size="1" ONCHANGE="javascript:setNotes()">
					<option selected value="1">�ē����P</option>
					<option value="2">�ē����Q</option>
				</select>
			</TD>
		</TR>
		<TR>
			<TD COLSPAN="15">
				<TEXTAREA NAME="Notes" ROWS="10" COLS="80" WRAP="SOFT"></TEXTAREA>
			</TD>
		</TR>
	</TABLE>
				<!--- �o�͑Ώ� --><BR>
<!--- ������[�h -->
<%
	'������[�h�̏����ݒ�
	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<!--  2003/02/27  START  START  E.Yamamoto  -->
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/02/27  START  END    E.Yamamoto  -->
<!--  2003/02/27  DEL  START  E.Yamamoto  -->
<!--
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
			<TD NOWRAP>�v���r���[</TD>

			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
			<TD NOWRAP>���ڏo��</TD>
		</TR>
-->
<!--  2003/02/27  DEL  END    E.Yamamoto  -->
	</TABLE>

	<BR><BR>

<!--- ����{�^�� -->
	<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">
    <%  End if  %>

	</BLOCKQUOTE>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>