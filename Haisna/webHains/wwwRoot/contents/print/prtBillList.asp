<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	������ (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"           -->
<!-- #include virtual = "/webHains/includes/common.inc"                 -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"            -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"         -->
<!-- #include virtual = "/webHains/includes/print.inc"                  -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseTable.inc"  -->
<!-- #include virtual = "/webHains/includes/tokyu_editReportList.inc"   -->
<!-- #include virtual = "/webHains/includes/tokyu_editDmdClassList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editJudClassList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode			'������[�h
Dim vntMessage		'�ʒm���b�Z�[�W
Dim strURL			'URL
Dim UID
'-------------------------------------------------------------------------------
' �ŗL�錾���i�e���[�ɉ����Ă��̃Z�N�V�����ɕϐ����`���ĉ������j
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objOrganization	'�c�̏��A�N�Z�X�p

'�����l
Dim strSCslDate,strSCslYear, strSCslMonth, strSCslDay	'�J�n�N����
Dim strECslDate,strECslYear, strECslMonth, strECslDay	'�I���N����
Dim strOrgCd1, strOrgCd2					'�c�̃R�[�h
Dim strOrgName								'�c�̖�
Dim strBillClass							'����������
Dim strBillNo								'�������ԍ�
Dim strBillNo2								'�������ԍ�

Dim strOutPutCls							'�o�͑Ώ�
Dim strUpdFlg								'������t�X�V�Ώۃt���O

Dim strArrOutputCls()						'�o�͑Ώۋ敪
Dim strArrOutputClsName()					'�o�͑Ώۋ敪��

'��Ɨp�ϐ�
Dim i, j			'�J�E���^

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'���ʈ����l�̎擾
strMode = Request("mode")

'�o�͑Ώۋ敪�C���̂̐���
Call CreateOutputInfo()

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
		strSCslMonth  = Month(Now())			'�J�n��
		strSCslDay    = Day(Now())				'�J�n��
	Else
		strSCslYear   = Request("strCslYear")	'�J�n�N
		strSCslMonth  = Request("strCslMonth")	'�J�n��
		strSCslDay    = Request("strCslDay")	'�J�n��
	End If
	strSCslDate   = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay
'�� �I���N����
	If IsEmpty(Request("endCslYear")) Then
		strECslYear   = Year(Now())				'�I���N
		strECslMonth  = Month(Now())			'�J�n��
		strECslDay    = Day(Now())				'�J�n��
	Else
		strECslYear   = Request("endCslYear")	'�I���N
		strECslMonth  = Request("endCslMonth")	'�J�n��
		strECslDay    = Request("endCslDay")	'�J�n��
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

'�� �o�͑Ώ�
	strOutputCls	= Request("outputCls")		'�Ώ�


'�� �������ԍ�
	strBillNo 		= Request("billNo")
	strBillNo2 		= Request("billNo2")
UID = Session("USERID")

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
		If strMode <> "" Then

			'�� �J�n���t�������`�F�b�N
			If Not IsDate(strSCslDate) Then
				.AppendArray vntArrMessage, "�J�n���t������������܂���B"
			End If

			'�� �I�����t�������`�F�b�N
			If Not IsDate(strECslDate) Then
				.AppendArray vntArrMessage, "�I�����t������������܂���B"
			End If


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
' ���l�@�@ : ���[�h�L�������g�t�@�C���쐬���\�b�h���Ăяo���B���\�b�h���ł͎��̏������s����B
' �@�@�@�@   ?@������O���̍쐬
' �@�@�@�@   ?A���[�h�L�������g�t�@�C���̍쐬
' �@�@�@�@   ?B�����������͈�����O��񃌃R�[�h�̎�L�[�ł���v�����gSEQ��߂�l�Ƃ��ĕԂ��B
' �@�@�@�@   ����SEQ�l�����Ɉȍ~�̃n���h�����O���s���B
'
'-------------------------------------------------------------------------------
Function Print()

	Dim objPrintCls	'�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
	Dim objBill		'�������e�[�u���pCOM�R���|�[�l���g
	Dim PrintRet	'�֐��߂�l
	Dim UpdateRet	'�֐��߂�l
Dim objCommon
	If Not IsArray(CheckValue()) Then

'�������������������� ��ʍ��ڂɂ��킹�ĕҏW
		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
'		Set objPrintCls = Server.CreateObject("HainsBillList.BillList")
'*****  2003/03/07  EDIT  START  E.Yamamoto  ���[�p���W���[���uPrintDba2�v�փ��W���[���ړ��̂��ߏC��
'		Set objBill = Server.CreateObject("HainsBill.Bill")
'		Set objBill = Server.CreateObject("HainsPrintDba2.PrintDba2")
'*****  2003/03/07  EDIT  START  E.Yamamoto  ���[�p���W���[���uPrintDba2�v�փ��W���[���ړ��̂��ߏC��

		'�������h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
'		PrintRet = objPrintCls.PrintBillDetailList( Session("USERID"),  ,  _
'													strOutputCls,  _
'													strBillNo, _
'													strSCslDate, _
'													strECslDate , _
'													strOrgCd1, _
'													strOrgCd2, _
'													strBillClass _
'												  )
'											 
'		If( PrintRet > 0 AND strUpdFlg = "1" ) Then
'			UpdateRet = objBill.UpdateBillPrtDate(   strBillNo, _
'													 strSCslDate, _
'													 strECslDate , _
'													 strOrgCd1, _
'													 strOrgCd2, _
'													 strBillClass _
'											   )
'		End If
			
'��������������������
'		Print = PrintRet
Set objCommon = Server.CreateObject("HainsCommon.Common")
strURL = "/webHains/contents/report_form/annaisho.asp"
strURL = strURL & "?p_Uid=" & UID
strURL = strURL & "?p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
Set objCommon = Nothing
strURL = strURL & "&p_Bilseq=" & strBillNo 
strURL = strURL & "&p_BilNo=" & strBillNo2 
strURL = strURL & "&p_Option=" & strOutputCls
Response.Redirect strURL
Response.End



	End If

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �o�͑ΏۂɊւ���z��𐶐�����
'
' �����@�@ : 
'
' �߂�l�@ : �Ȃ�
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Sub CreateOutputInfo()

	Redim Preserve strArrOutputCls(1)
	Redim Preserve strArrOutputClsName(1)

	strArrOutputCls(0) = "0":strArrOutputClsName(0) = "������"
	strArrOutputCls(1) = "1":strArrOutputClsName(1) = "�̎���"

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������`�F�b�N���X�g</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setElement() {


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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">���������`�F�b�N���X�g</SPAN></B></TD>
		</TR>
	</TABLE>
<%
'�G���[���b�Z�[�W�\��

	'���b�Z�[�W�̕ҏW
	If( strMode <> "" )Then

		'�ۑ��������́u�ۑ������v�̒ʒm
		Call EditMessage(vntMessage, MESSAGETYPE_WARNING)

	End If
%>
	<BR>

<!--- ���t -->
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>������</TD>
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
			<!--- �������ԍ� -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>������SEQ</TD>
			<TD>�F</TD>
			<TD><INPUT Type="text" Name="billNo" Size="10" MaxLength="10" Value="<%= strBillNo %>"></TD>
		</TR>
	</TABLE>
	<table border="0" cellpadding="1" cellspacing="2">
		<tr>
			<td><font color="#ff0000">��</font></td>
			<td width="90" nowrap>�������}��</td>
			<td>�F</td>
			<td><input type="text" name="billNo2" size="10" maxlength="10" value="<%= strBillNo2 %>"></td>
		</tr>
	</table>
	
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�o�͑Ώ�</TD>
			<TD>�F</TD>
			<TD><%= EditDropDownListFromArray("outputCls", strArrOutputCls, strArrOutputClsName , strOutputCls, NON_SELECTED_DEL) %></TD>
		</TR>
	</TABLE>
			<BR>
			<!--- ������[�h -->
<!--  2003/03/05  ADD  START  E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߌŒ�ݒ�Ƃ���  -->
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/03/05  ADD  END    E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߌŒ�ݒ�Ƃ���  -->
<%
'*****  2003/03/05  DEL  START  E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߍ폜  
'	'������[�h�̏����ݒ�
'	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
'*****  2003/03/05  DEL  END    E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߍ폜  
%>
<!--  2003/03/05  DEL  START  E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߍ폜  -->
<!--
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <% ' = IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
			<TD NOWRAP>�v���r���[</TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <% ' = IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
			<TD NOWRAP>���ڏo��</TD>
		</TR>
	</TABLE>
-->
<!--  2003/03/05  DEL  END    E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߍ폜  -->
	<BR><BR>

<!--- ����{�^�� -->
	<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
    <% If Session("PAGEGRANT") = "4" Then   %>
		<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">
	<%  End if  %>

</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>