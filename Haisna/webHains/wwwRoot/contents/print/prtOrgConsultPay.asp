<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'	�c�̕ʗ\���f�������v (Ver0.0.1)
'	AUTHER  :
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"          -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/print.inc"                -->
<!-- #include virtual = "/webHains/includes/editOrgGrp_PList.inc"     -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim strMode			'������[�h
Dim vntMessage		'�ʒm���b�Z�[�W
Dim strHdnMode

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
Dim strYear					'�J�n�N
Dim strOrgCd1				'�c�̃R�[�h11
Dim strOrgCd2				'�c�̃R�[�h12
Dim strOrgCd3				'�c�̃R�[�h21
Dim strOrgCd4				'�c�̃R�[�h22
Dim strOrgCd5				'�c�̃R�[�h31
Dim strOrgCd6				'�c�̃R�[�h32
Dim strOrgCd7				'�c�̃R�[�h41
Dim strOrgCd8				'�c�̃R�[�h42
Dim strOrgCd9				'�c�̃R�[�h51
Dim strOrgCd10				'�c�̃R�[�h52
Dim strOrgCd11				'�c�̃R�[�h61
Dim strOrgCd12				'�c�̃R�[�h62
Dim strOrgCd13				'�c�̃R�[�h71
Dim strOrgCd14				'�c�̃R�[�h72
Dim strOrgCd15				'�c�̃R�[�h81
Dim strOrgCd16				'�c�̃R�[�h82
Dim strOrgCd17				'�c�̃R�[�h91
Dim strOrgCd18				'�c�̃R�[�h92
Dim strOrgCd19				'�c�̃R�[�h101
Dim strOrgCd20				'�c�̃R�[�h102

'2006/02/27		Add by�@�� ST) -----------------------
Dim strOrgGrpCd1			'�c�̃O���[�v�R�[�h1
Dim strOrgGrpCd2			'�c�̃O���[�v�R�[�h2
Dim strOrgGrpCd3			'�c�̃O���[�v�R�[�h3
Dim strOrgGrpCd4			'�c�̃O���[�v�R�[�h4
Dim strOrgGrpCd5			'�c�̃O���[�v�R�[�h5
Dim strOrgGrpCd6			'�c�̃O���[�v�R�[�h6
Dim strOrgGrpCd7			'�c�̃O���[�v�R�[�h7
Dim strOrgGrpCd8			'�c�̃O���[�v�R�[�h8
Dim strOrgGrpCd9			'�c�̃O���[�v�R�[�h9
Dim strOrgGrpCd10			'�c�̃O���[�v�R�[�h10
Dim strOrgView
'2006/02/27		Add by�@�� ED) -----------------------

Dim strTYear				'���o�N�x
Dim strContents	    			'�W�v���e
Dim strTarget				'�W�v�Ώ�
Dim strOrgMethod			'�c�̎w����@
Dim strSort				'�\�[�g
Dim strSysDate				'�N����
Dim strSCslYear				'�N���N
Dim strSCslMonth			'�N����
Dim strSCslDay				'�N����
Dim UID

'��������������������
'��Ɨp�ϐ�
Dim P_Month	
Dim strOrgName		'�c�̖�
Dim i
Dim Flg
Dim PriFlg

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
PriFlg = 0
strHdnMode = Request("hdn_Mode")
strOrgView = Request("hdn_OrgView")

if strOrgView = "" then
    strOrgView = "0"
end if

if strHdnMode <> "XX" then
	'���[�o�͏�������
	vntMessage = PrintControl(strMode)
else
	Call GetQueryString()
end if

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

'�� ���o�N�x
	If IsEmpty(Request("strCslYear")) Then
		strYear  = Year(Now())
		strTYear   = Year(Now())
		P_Month = Month(Now())
		If P_Month < 4 Then
			strTYear = strTYear - 1
			strYear  = Year(Now()) - 1
		End If
	Else
		strTYear   = Request("strCslYear")		'���o�N�x
        strYear = strTYear
	End If
	
	strSCslYear   = Year(Now())			'�N���N
	strSCslMonth  = Month(Now())			'�N����
	strSCslDay    = Day(Now())			'�N����
	strSysDate    = strSCslYear & "/" & strSCslMonth & "/" & strSCslDay	'�N���N����

'�� �W�v���e
	strContents 	= Request("Contents")		'�W�v���e

'�� �W�v�Ώ�
	strTarget	= Request("Target")		'�W�v�Ώ�

'�� �c�̎w����@
	strOrgMethod	= Request("OrgMethod")		'�c�̎w����@

'�� �c�̂P�`�P�O
	strOrgCd1       = Request("orgCd1")			'�c�̂P�̃R�[�h�P
	strOrgCd2       = Request("orgCd2")			'�c�̂P�̃R�[�h�Q
	strOrgCd3		= Request("orgCd3")			'�c�̂Q�̃R�[�h�P
	strOrgCd4		= Request("orgCd4")			'�c�̂Q�̃R�[�h�Q
	strOrgCd5		= Request("orgCd5")			'�c�̂R�̃R�[�h�P
	strOrgCd6		= Request("orgCd6")			'�c�̂R�̃R�[�h�Q
	strOrgCd7		= Request("orgCd7")			'�c�̂S�̃R�[�h�P
	strOrgCd8		= Request("orgCd8")			'�c�̂S�̃R�[�h�Q
	strOrgCd9		= Request("orgCd9")			'�c�̂T�̃R�[�h�P
	strOrgCd10		= Request("orgCd10")		'�c�̂T�̃R�[�h�Q
	strOrgCd11		= Request("orgCd11")		'�c�̂U�̃R�[�h�P
	strOrgCd12		= Request("orgCd12")		'�c�̂U�̃R�[�h�Q
	strOrgCd13		= Request("orgCd13")		'�c�̂V�̃R�[�h�P
	strOrgCd14		= Request("orgCd14")		'�c�̂V�̃R�[�h�Q
	strOrgCd15		= Request("orgCd15")		'�c�̂W�̃R�[�h�P
	strOrgCd16		= Request("orgCd16")		'�c�̂W�̃R�[�h�Q
	strOrgCd17		= Request("orgCd17")		'�c�̂X�̃R�[�h�P
	strOrgCd18		= Request("orgCd18")		'�c�̂X�̃R�[�h�Q
	strOrgCd19		= Request("orgCd19")		'�c�̂P�O�̃R�[�h�P
	strOrgCd20		= Request("orgCd20")		'�c�̂P�O�̃R�[�h�Q


' 2006.03.01  Add by ���@ST) ---------------------------------------
'�� �c�̃O���[�v�P�`�P�O
	strOrgGrpCd1	= Request("OrgGrpCd1")		'�c�̃O���[�v�P�̃R�[�h
	strOrgGrpCd2	= Request("OrgGrpCd2")		'�c�̃O���[�v�Q�̃R�[�h
	strOrgGrpCd3	= Request("OrgGrpCd3")		'�c�̃O���[�v�R�̃R�[�h
	strOrgGrpCd4	= Request("OrgGrpCd4")		'�c�̃O���[�v�S�̃R�[�h
	strOrgGrpCd5	= Request("OrgGrpCd5")		'�c�̃O���[�v�T�̃R�[�h
	strOrgGrpCd6	= Request("OrgGrpCd6")		'�c�̃O���[�v�U�̃R�[�h
	strOrgGrpCd7	= Request("OrgGrpCd7")		'�c�̃O���[�v�V�̃R�[�h
	strOrgGrpCd8	= Request("OrgGrpCd8")		'�c�̃O���[�v�W�̃R�[�h
	strOrgGrpCd9	= Request("OrgGrpCd9")		'�c�̃O���[�v�X�̃R�[�h
	strOrgGrpCd10	= Request("OrgGrpCd10")		'�c�̃O���[�v�P�O�̃R�[�h

' 2006.03.01  Add by ���@ED) ---------------------------------------	


'�� �\�[�g
	strSort         = Request("Sort")		'�\�[�g

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
	Dim aryChkString
	
	aryChkString = Array("1","2","3","4","5","6","7","8","9","0")

	'�����Ƀ`�F�b�N�������L�q
	With objCommon

		If strMode <> "" Then
			
			Flg = 0
			If strOrgMethod = 1 Then
				If Len(strOrgCd1) = 0 Or Len(strOrgCd2) = 0 Or Len(strOrgCd3) = 0 Or Len(strOrgCd4) = 0 Then	
						Flg = 1
				End if
			ElseIf strOrgMethod = 2 Then
				If Len(strOrgCd1) <> 0 Or Len(strOrgCd2) <> 0 Or Len(strOrgCd3) <> 0 Or Len(strOrgCd4) <> 0 Or Len(strOrgCd5) <> 0 Or _
				   Len(strOrgCd6) <> 0 Or Len(strOrgCd7) <> 0 Or Len(strOrgCd8) <> 0 Or Len(strOrgCd9) <> 0 Or Len(strOrgCd10) <> 0 Or _
				   Len(strOrgCd11) <> 0 Or Len(strOrgCd12) <> 0 Or Len(strOrgCd13) <> 0 Or Len(strOrgCd14) <> 0 Or Len(strOrgCd15) <> 0 Or _
				   Len(strOrgCd16) <> 0 Or Len(strOrgCd17) <> 0 Or Len(strOrgCd18) <> 0 Or Len(strOrgCd19) <> 0 Or Len(strOrgCd20) <> 0 Then
					Flg = 0
				Else
					Flg = 2
				End If
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

	Dim objPrintCls  	'�c�̈ꗗ�o�͗pCOM�R���|�[�l���g
	Dim objPrintCls2	
	
	Dim Ret			'�֐��߂�l
	Dim Ret2
	
	
	If Not IsArray(CheckValue()) Then

		'�c�̕ʗ\���f���z���v���[
		'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
		Set objPrintCls = Server.CreateObject("HainsprtOrgConPay.prtOrgConsultPay")

		If strContents = 0 Then
			'�h�L�������g�t�@�C���쐬�����i�I�u�W�F�N�g.���\�b�h��(����)�j
			Ret = objPrintCls.PrintOut(Session("USERID"), Cdate(strSysDate), strTYear, strContents, strTarget, strOrgMethod, _
						   strOrgCd1, strOrgCd2, strOrgCd3, strOrgCd4, strOrgCd5, _
						   strOrgCd6, strOrgCd7, strOrgCd8, strOrgCd9, strOrgCd10, _
						   strOrgCd11, strOrgCd12, strOrgCd13, strOrgCd14, strOrgCd15, _
						   strOrgCd16, strOrgCd17, strOrgCd18, strOrgCd19, strOrgCd20, _
						   strSort)
			print = Ret		
		
		''�c�̃O���[�v��
		Else
			Ret = objPrintCls.PrintOut(Session("USERID"), Cdate(strSysDate), strTYear, strContents, strTarget, strOrgMethod, _
						   strOrgGrpCd1, strOrgGrpCd2, strOrgGrpCd3, strOrgGrpCd4, strOrgGrpCd5, _
						   strOrgGrpCd6, strOrgGrpCd7, strOrgGrpCd8, strOrgGrpCd9, strOrgGrpCd10, _
						   , , , , , _
						   , , , , , _
						   strSort)
			print = Ret				
		End if
		
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
<TITLE>�c�̕ʗ\���f�l���E�������v</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̉�ʕ\��
function showGuideOrgGrp( Cd1, Cd2, CtrlName ) {
    // �c�̏��G�������g�̎Q�Ɛݒ�
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );
    // ��ʕ\��
    orgPostGuide_showGuideOrg();
}

// �c�̏��폜
function clearGuideOrgGrp( Cd1, Cd2, CtrlName ) {
    // �c�̏��G�������g�̎Q�Ɛݒ�
    orgPostGuide_getElement( Cd1, Cd2, CtrlName );

    // �폜
    orgPostGuide_clearOrgInfo();
}

function checkDisp(sval) {
    document.entryForm.hdn_OrgView.value = sval ;
	document.entryForm.hdn_Mode.value = "XX" ;
   // alert ('sval = ' + sval);
	parent.document.entryForm.submit();
}

-->
</SCRIPT>

<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>

<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">
	<BLOCKQUOTE>

<!--- �^�C�g�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN>�c�̕ʗ\���f�������v</B></TD>
		</TR>
	</TABLE>
	<BR>

<%
'�G���[���b�Z�[�W�\��
	Call EditMessage(vntMessage, MESSAGETYPE_WARNING)
%>
<BR>
<!--- ���o�N�x -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>���o�N�x</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strCslYear', 'strCslMonth', 'strCslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("strCslYear", YEARRANGE_MIN, YEARRANGE_MAX, strYear, False) %></TD>
			<TD>�N�x</TD>
		</TR>
	</TABLE>
	
<!-- �W�v���e -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�W�v���@</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="Radio" NAME="Contents" VALUE="<%= strOrgView %>" <%= IIf(strOrgView = "0", "CHECKED", "") %> ONCLICK="javascript:checkDisp('0')" >�c�̕ʏW�v</TD>
						<TD><INPUT TYPE="Radio" NAME="Contents" VALUE="<%= strOrgView %>" <%= IIf(strOrgView = "1", "CHECKED", "") %> ONCLICK="javascript:checkDisp('1')" >�c�̃O���[�v�ʏW�v</TD>
                        
                        <TD><INPUT TYPE="hidden" NAME="hdn_OrgView" ></TD>
						<TD><INPUT TYPE="hidden" NAME="hdn_Mode" ></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	
<!-- �W�v�Ώ� -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�W�v�Ώ�</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="Radio" NAME="Target" VALUE="0" <%= "CHECKED" %> >����</TD>
						<TD><INPUT TYPE="Radio" NAME="Target" VALUE="1" >�Q�N��r</TD>
						
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

<!-- �c�̎w����@  -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�c�̎w����@</TD>
			<TD>�F</TD>
			<TD>
				<select name="OrgMethod" size="1">
					<option selected value="0">�S��</option>
					<option value="2">�ʎw��(�P�O�c�̂܂Ŏw���)</option>
				</select>
			</TD>
		</TR>
	</TABLE>

		
<% if strOrgView = "0"  or  strOrgView = "" then  %>

	<!-- �c�̂P -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂P</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName1')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd1, document.entryForm.orgCd2, 'orgName1')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName1"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<% = strOrgCd1 %>">
					<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<% = strOrgCd2 %>">
				</TD>
			</TR>
		</TABLE>
		
	<!-- �c�̂Q -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂Q</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd3, document.entryForm.orgCd4, 'orgName2')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd3, document.entryForm.orgCd4, 'orgName2')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName2"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd3" VALUE="<% = strOrgCd3 %>">
					<INPUT TYPE="hidden" NAME="orgCd4" VALUE="<% = strOrgCd4 %>">
				</TD>
			</TR>
		</TABLE>
			
	<!-- �c�̂R -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂R</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd5, document.entryForm.orgCd6, 'orgName3')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd5, document.entryForm.orgCd6, 'orgName3')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName3"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd5" VALUE="<% = strOrgCd5 %>">
					<INPUT TYPE="hidden" NAME="orgCd6" VALUE="<% = strOrgCd6 %>">
				</TD>
			</TR>
		</TABLE>
		
	<!-- �c�̂S -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂S</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd7, document.entryForm.orgCd8, 'orgName4')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd7, document.entryForm.orgCd8, 'orgName4')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName4"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd7" VALUE="<% = strOrgCd7 %>">
					<INPUT TYPE="hidden" NAME="orgCd8" VALUE="<% = strOrgCd8 %>">
				</TD>
			</TR>
		</TABLE>
			
	<!-- �c�̂T -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂T</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd9, document.entryForm.orgCd10, 'orgName5')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd9, document.entryForm.orgCd10, 'orgName5')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName5"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd9" VALUE="<% = strOrgCd9 %>">
					<INPUT TYPE="hidden" NAME="orgCd10" VALUE="<% = strOrgCd10 %>">
				</TD>
			</TR>
		</TABLE>

	<!-- �c�̂U -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂U</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'orgName6')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd11, document.entryForm.orgCd12, 'orgName6')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName6"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd11" VALUE="<% = strOrgCd11 %>">
					<INPUT TYPE="hidden" NAME="orgCd12" VALUE="<% = strOrgCd12 %>">
				</TD>
			</TR>
		</TABLE>
			
	<!-- �c�̂V -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂V</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd13, document.entryForm.orgCd14, 'orgName7')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd13, document.entryForm.orgCd14, 'orgName7')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName7"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd13" VALUE="<% = strOrgCd13 %>">
					<INPUT TYPE="hidden" NAME="orgCd14" VALUE="<% = strOrgCd14 %>">
				</TD>
			</TR>
		</TABLE>
		
	<!-- �c�̂W -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂W</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd15, document.entryForm.orgCd16, 'orgName8')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd15, document.entryForm.orgCd16, 'orgName8')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName8"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd15" VALUE="<% = strOrgCd15 %>">
					<INPUT TYPE="hidden" NAME="orgCd16" VALUE="<% = strOrgCd16 %>">
				</TD>
			</TR>
		</TABLE>
			
	<!-- �c�̂X -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂X</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd17, document.entryForm.orgCd18, 'orgName9')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd17, document.entryForm.orgCd18, 'orgName9')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName9"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd17" VALUE="<% = strOrgCd17 %>">
					<INPUT TYPE="hidden" NAME="orgCd18" VALUE="<% = strOrgCd18 %>">
				</TD>
			</TR>
		</TABLE>

	<!-- �c�̂P�O -->
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̂P�O</TD>
				<TD>�F</TD>
				<TD>
				<TD><A HREF="javascript:showGuideOrgGrp(document.entryForm.orgCd19, document.entryForm.orgCd20, 'orgName10')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
				<TD><A HREF="javascript:clearGuideOrgGrp(document.entryForm.orgCd19, document.entryForm.orgCd20, 'orgName10')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD NOWRAP><SPAN ID="orgName10"></SPAN>
					<INPUT TYPE="hidden" NAME="orgCd19" VALUE="<% = strOrgCd19 %>">
					<INPUT TYPE="hidden" NAME="orgCd20" VALUE="<% = strOrgCd20 %>">
				</TD>
			</TR>
		</TABLE>
		<BR>

<%  Else  %>

		<!-- �c�̃O���[�v�P-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�P</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd1", strOrgGrpCd1, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- �c�̃O���[�v�Q-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�Q</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd2", strOrgGrpCd2, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- �c�̃O���[�v�R-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�R</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd3", strOrgGrpCd3, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- �c�̃O���[�v�S-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�S</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd4", strOrgGrpCd4, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>
		<!-- �c�̃O���[�v�T-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�T</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd5", strOrgGrpCd5, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- �c�̃O���[�v�U-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�U</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd6", strOrgGrpCd6, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- �c�̃O���[�v�V-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�V</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd7", strOrgGrpCd7, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- �c�̃O���[�v�W-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�W</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd8", strOrgGrpCd8, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- �c�̃O���[�v�X-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�X</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd9", strOrgGrpCd9, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

		<!-- �c�̃O���[�v�P�O-->
		<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
			<TR>
				<TD>��</TD>
				<TD WIDTH="90" NOWRAP>�c�̃O���[�v�P�O</TD>
				<TD>�F</TD>
				<TD><%= EditOrgGrp_PList2("OrgGrpCd10", strOrgGrpCd10, NON_SELECTED_ADD, 3) %></TD>
			</TR>
		</TABLE>

<%  End If %>
	


<!-- �\�[�g -->
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR>
			<TD>��</TD>
			<TD WIDTH="90" NOWRAP>�\�[�g</TD>
			<TD>�F</TD>
			<TD>
				<select name="Sort" size="1">
					<option selected value="0">�c�̃R�[�h��</option>
					<option value="1">�c�̃J�i����</option>
					<option value="2">���z��</option>
				</select>
			</TD>
		</TR>
		
	</TABLE>
	
<!--- ������[�h -->
<%
	'������[�h�̏����ݒ�
	strMode = IIf(strMode = "", PRINTMODE_PREVIEW, strMode)
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
<INPUT TYPE="hidden" NAME="mode" VALUE="0">
<!--
			<TD><INPUT TYPE="radio" NAME="mode" VALUE="0" <%= IIf(strMode = PRINTMODE_PREVIEW, "CHECKED", "") %>></TD>
			<TD NOWRAP>�v���r���[</TD>

			<TD><INPUT TYPE="radio" NAME="mode" VALUE="1" <%= IIf(strMode = PRINTMODE_DIRECT,  "CHECKED", "") %>></TD>
			<TD NOWRAP>���ڏo��</TD>
		</TR>
-->
	</TABLE>

	<BR>

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

