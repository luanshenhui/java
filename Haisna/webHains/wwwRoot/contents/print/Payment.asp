<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	������ (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-211~212
'       �C����  �F2010.05.13
'       �S����  �FASC)�O�Y
'       �C�����e�FReport Designer��Co Reports�ɕύX
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
Dim strOutPutCls2							'�o�͑Ώ�
Dim strArrOutputCls()						'�o�͑Ώۋ敪
Dim strArrOutputClsName()					'�o�͑Ώۋ敪��

Dim strArrOutputCls2()						'�o�͑Ώۋ敪
Dim strArrOutputClsName2()					'�o�͑Ώۋ敪��
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
'## 2003/12/30 Del Start NSC@birukawa ���[�Ƃ̃C���^�t�F�[�X�Ή�
''�� �I���N����
'	If IsEmpty(Request("endCslYear")) Then
'		strECslYear   = Year(Now())				'�I���N
'		strECslMonth  = Month(Now())			'�J�n��
'		strECslDay    = Day(Now())				'�J�n��
'	Else
'		strECslYear   = Request("endCslYear")	'�I���N
'		strECslMonth  = Request("endCslMonth")	'�J�n��
'		strECslDay    = Request("endCslDay")	'�J�n��
'	End If
'	strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
''�� �J�n�N�����ƏI���N�����̑召����Ɠ���
''   �i���t�^�ɕϊ����ă`�F�b�N���Ȃ��͓̂��t�Ƃ��Č�����l�ł������Ƃ��̃G���[����ׁ̈j
'	If Right("0000" & Trim(CStr(strSCslYear)), 4) & _
'	   Right("00" & Trim(CStr(strSCslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strSCslDay)), 2) _
'	 > Right("0000" & Trim(CStr(strECslYear)), 4) & _
'	   Right("00" & Trim(CStr(strECslMonth)), 2) & _
'	   Right("00" & Trim(CStr(strECslDay)), 2) Then
'		strSCslYear   = strECslYear
'		strSCslMonth  = strECslMonth
'		strSCslDay    = strECslDay
'		strSCslDate   = strECslDate
'		strECslYear   = Request("strCslYear")	'�J�n�N
'		strECslMonth  = Request("strCslMonth")	'�J�n��
'		strECslDay    = Request("strCslDay")	'�J�n��
'		strECslDate   = strECslYear & "/" & strECslMonth & "/" & strECslDay
'	End If
'## 2003/12/30 Del End   NSC@birukawa ���[�Ƃ̃C���^�t�F�[�X�Ή�

'�� �o�͑Ώ�
	strOutputCls	= Request("outputCls")		'�Ώ�

	strOutputCls2	= Request("outputCls2")		'�Ώ�
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
'## 2003/12/30 Upd Start NSC@birukawa ���[�Ƃ̃C���^�t�F�[�X�Ή�
'				.AppendArray vntArrMessage, "�J�n���t������������܂���B"
'				.AppendArray vntArrMessage, "������������������܂���B"
'## 2004/12/22 Upd Start �C�[�R�[�|@�� ���[�Ƃ̃C���^�t�F�[�X�Ή�
				.AppendArray vntArrMessage, "�v���������������܂���B"
'## 2004/12/22 Upd End �C�[�R�[�|@�� ���[�Ƃ̃C���^�t�F�[�X�Ή�
'## 2003/12/30 Upd End   NSC@birukawa ���[�Ƃ̃C���^�t�F�[�X�Ή�
			End If

'## 2003/12/30 Upd Start NSC@birukawa ���[�Ƃ̃C���^�t�F�[�X�Ή�
'			'�� �I�����t�������`�F�b�N
'			If Not IsDate(strECslDate) Then
'				.AppendArray vntArrMessage, "�I�����t������������܂���B"
'			End If
'## 2003/12/30 Upd End   NSC@birukawa ���[�Ƃ̃C���^�t�F�[�X�Ή�

			'�� �������ԍ��`�F�b�N
'			if strBillNo <> ""  then
'				if( isNumeric(strBillNo) = false ) Then
'					.AppendArray vntArrMessage, "�������ԍ��ɊԈႢ������܂��B"
'				else
'					.AppendArray vntArrMessage, .CheckNumeric("�������ԍ�",strBillNo, 9)
'				end if	
'			end If
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

	'���R�����΍��p���O�����o��
	Call putPrivacyInfoLog("PH027", "�����W���[�i���E�����䒠�̈�����s����")

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

'#### 2010.05.13 SL-UI-Y0101-211~212 MOD START ####'

'Set objCommon = Server.CreateObject("HainsCommon.Common")
'strURL = "/webHains/contents/report_form/rd_20_Payment.asp"
'strURL = strURL & "?p_Uid=" & UID
''## 2003/12/30 Upd Start NSC@birukawa ���[�Ƃ̃C���^�t�F�[�X�Ή�
''strURL = strURL & "&p_ScslDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
''strURL = strURL & "&p_EcslDate=" & objCommon.FormatString(CDate(strECslDate), "yyyy/mm/dd")
'strURL = strURL & "&p_PayDate=" & objCommon.FormatString(CDate(strSCslDate), "yyyy/mm/dd")
''## 2003/12/30 Upd End   NSC@birukawa ���[�Ƃ̃C���^�t�F�[�X�s��
'Set objCommon = Nothing
'strURL = strURL & "&p_Option1=" & strOutputCls 
'strURL = strURL & "&p_Option2=" & strOutputCls2 
'Response.Redirect strURL
'Response.End

	'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
	if strOutputCls2 = "0" then
		Set objPrintCls = Server.CreateObject("HainsPaymentJa.PaymentJa")
	Else
		Set objPrintCls = Server.CreateObject("HainsPaymentDai.PaymentDai")
	End if
	'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
	PrintRet = objPrintCls.PrintOut(UID, _
							   strSCslDate, _
							   strOutputCls, _
							   strOutputCls2)

	Print = PrintRet

'#### 2010.05.13 SL-UI-Y0101-211~212 MOD END ####'



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

	Redim Preserve strArrOutputCls(3)
	Redim Preserve strArrOutputClsName(3)
	Redim Preserve strArrOutputCls2(1)
	Redim Preserve strArrOutputClsName2(1)

	strArrOutputCls2(0) = "0":strArrOutputClsName2(0) = "�����W���[�i��"
	strArrOutputCls2(1) = "1":strArrOutputClsName2(1) = "�����䒠"

	strArrOutputCls(0) = "0":strArrOutputClsName(0) = "�S�w��"
	strArrOutputCls(1) = "1":strArrOutputClsName(1) = "�[���P"
     strArrOutputCls(2) = "2":strArrOutputClsName(2) = "�[��2"
    strArrOutputCls(3) = "3":strArrOutputClsName(3) = "�[��3"



End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�̎���</TITLE>
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
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�����W���[�i���E�����䒠</FONT></B></TD>
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
<!--- ## 2004/12/22 Upd Start �C�[�R�[�|@�� ���[�Ƃ̃C���^�t�F�[�X�Ή� -->
			<!--TD WIDTH="90" NOWRAP>������</TD-->
			<TD WIDTH="90" NOWRAP>�v���</TD>
<!--- ## 2004/12/22 Upd End   �C�[�R�[�|@�� ���[�Ƃ̃C���^�t�F�[�X�Ή� -->
<!--- ���t -->
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strSCslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("strCslMonth", 1, 12, strSCslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("strCslDay", 1, 31, strSCslDay, False) %></TD>
			<TD>��</TD>

<!-- ##2003/12/30 Upd Start NSC@birukawa ���[�Ƃ̃C���^�t�F�[�X�Ή�
			<TD>�`</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endCslYear', 'endCslMonth', 'endCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("endCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strECslYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("endCslMonth", 1, 12, strECslMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("endCslDay", 1, 31, strECslDay, False) %></TD>
			<TD>��</TD>
-->
		</TR>
	</TABLE>
			<!--- �������ԍ� -->
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="90" NOWRAP>�[����</TD>
			<TD>�F</TD>
			<TD><%= EditDropDownListFromArray("outputCls", strArrOutputCls, strArrOutputClsName , strOutputCls, NON_SELECTED_DEL) %></TD>
		</TR>
	</TABLE>
		
			<table border="0" cellpadding="1" cellspacing="2">
				<tr>
					<td><font color="#ff0000">��</font></td>
					<td width="90" nowrap>���[�I��</td>
					<td>�F</td>
					<td><%= EditDropDownListFromArray("outputCls2", strArrOutputCls2, strArrOutputClsName2 , strOutputCls2, NON_SELECTED_DEL) %></td>
				</tr>
			</table>
			<p><BR>
				<!--- ������[�h --><!--  2003/03/05  ADD  START  E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߌŒ�ݒ�Ƃ���  --><INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--  2003/03/05  ADD  END    E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߌŒ�ݒ�Ƃ���  --><%
'*****  2003/03/05  DEL  START  E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߍ폜  
'	'������[�h�̏����ݒ�
'	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
'*****  2003/03/05  DEL  END    E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߍ폜  
%><!--  2003/03/05  DEL  START  E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߍ폜  --><!--
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <% ' = IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
			<TD NOWRAP>�v���r���[</TD>
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <% ' = IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
			<TD NOWRAP>���ڏo��</TD>
		</TR>
	</TABLE>
--><!--  2003/03/05  DEL  END    E.Yamamoto  ����͑S�ăv���r���[�Ƃ��邽�ߍ폜  --><BR>
				<BR>
				<!--- ����{�^�� -->
				<!---2006.07.04 �����Ǘ� �ǉ� by ��  -->
				<% If Session("PAGEGRANT") = "4" Then   %>
					<INPUT TYPE="image" NAME="print" SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="�������">
				<%  End if  %>
				<br>
				
</FORM></p>
			<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
		

</BODY>
</HTML>