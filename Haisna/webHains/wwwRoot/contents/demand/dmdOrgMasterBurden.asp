<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       ��������{��� (Ver0.0.1)
'       AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditBillClassList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�����l
Dim strMode					'�������[�h(�폜��:"delete")
Dim strAction				'������ԁi�m��E�폜�{�^��������:"save"�C�ۑ�������:"saveend"�C
							'          ����{�^��������:"print"�C���������:"printend"�j
Dim strBillNo				'�������ԍ�(�󔒎�:"�V�K")

'���������
Dim strOrgCd1				'�c�̃R�[�h�P
Dim strOrgCd2				'�c�̃R�[�h�Q
Dim strOrgName				'�c�̖���
Dim lngCloseYear			'���ߓ��i�N�j
Dim lngCloseMonth			'���ߓ��i���j
Dim lngCloseDay				'���ߓ��i���j
Dim strCloseDate			'���ߓ�
Dim lngMethod				'�쐬���@(0:����͂ɂ��쐬 1:���ߏ����ɂ��쐬)
Dim strTaxRates				'�K�p�ŗ�
Dim lngPrtYear				'�������o�͓��i�N�j
Dim lngPrtMonth				'�������o�͓��i���j
Dim lngPrtDay				'�������o�͓��i���j
Dim strPrtDate				'�������o�͓�
Dim blnPaymentFlg			'�����f�[�^���݃t���O
'2004.06.02 ADD STR ORB)T.YAGUCHI ���ڒǉ�
Dim strSecondFlg			'�Q�������t���O
'2004.06.02 ADD END

Dim strBillClassCd			'���������ރR�[�h
Dim strBillClassName		'���������ޖ�

Dim strPaymentBill			'�����ςݐ������폜�t���O(0:�����ςݐ������폜�s�� 1:�����ςݐ������폜��)

Dim objDemand				'�������A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objOrganization			'�c�̏��A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objCommon				'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objReportLog			'������O�pCOM�I�u�W�F�N�g

Dim strArrMessage			'�G���[���b�Z�[�W
Dim strRet					'�֐��߂�l
Dim i						'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�擾
strMode        = Request("mode")
strAction      = Request("act")
strBillNo      = Request("billNo")

'���������擾
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strBillClassCd = Request("billClassCd")

lngCloseYear   = CLng("0" & Request("closeYear"))
lngCloseMonth  = CLng("0" & Request("closeMonth"))
lngCloseDay    = CLng("0" & Request("closeDay"))
lngMethod      = CLng("0" & Request("billMethod"))
strTaxRates    = Request("taxRates")
lngPrtYear     = CLng("0" & Request("prtYear"))
lngPrtMonth    = CLng("0" & Request("prtMonth"))
lngPrtDay      = CLng("0" & Request("prtDay"))
'2004.06.02 ADD STR ORB)T.YAGUCHI ���ڒǉ�
strSecondFlg   = Request("secondFlg")
'2004.06.02 ADD END

lngCloseYear   = IIf(lngCloseYear  = 0, Year(Now),    lngCloseYear )
lngCloseMonth  = IIf(lngCloseMonth = 0, Month(Now),   lngCloseMonth)
lngCloseDay    = IIf(lngCloseDay   = 0, Day(Now),     lngCloseDay  )
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��������{���o�^</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<%

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objDemand = Server.CreateObject("HainsDemand.Demand")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objCommon = Server.CreateObject("HainsCommon.Common")

'�c�̖��̎擾
If strOrgCd1 <> "" And strOrgCd2 <> "" Then
	Call objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName)
End If

'�����ςݐ������폜�t���O
strPaymentBill = CLng(objCommon.SelectPaymentBillDelete())

Do

	'�ۑ�����
	If strAction = "save" Then
		'���̓`�F�b�N
		strArrMessage = objDemand.CheckValueDmdOrgMasterBurden(lngCloseYear, lngCloseMonth, _
																lngCloseDay, strCloseDate, _
																strOrgCd1, strOrgCd2, _
																strTaxRates, _
																lngPrtYear, lngPrtMonth, _
																lngPrtDay, strPrtDate)

		'���̓G���[���͉������Ȃ�
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

'2004.06.02 MOD STR ORB)T.YAGUCHI ���ڒǉ�
'		'�V�K�쐬��
'		strRet = objDemand.InsertBill(strBillNo, _
'										strCloseDate, _
'										strOrgCd1, _
'										strOrgCd2, _
'										strPrtDate, _
'										strTaxRates)
		'�V�K�쐬��
		strRet = objDemand.InsertBill(strBillNo, _
										strCloseDate, _
										strOrgCd1, _
										strOrgCd2, _
										strPrtDate, _
										strTaxRates, _
										strSecondFlg)
'2004.06.02 MOD END

		'�L�[�d�����̓G���[���b�Z�[�W��ҏW����
		If strRet = INSERT_DUPLICATE Then
			strArrMessage = Array("��������̐�������񂪂��łɑ��݂��܂��B")
			Exit Do
		End If

		'�I�u�W�F�N�g�̃C���X�^���X�폜
		Set objDemand = Nothing
		Set objOrganization = Nothing

		'�ۑ�����
		Response.Write "<BODY ONLOAD=""location.href='dmdBurdenModify.asp?billNo=" & strBillNo & "'"">"
		Response.Write "</BODY></HTML>"
		Response.End

	End If

	'�����\����
	If strAction = "" Then
		'�K�p�ŗ��擾
		Call objDemand.GetNowTax(Date, strTaxRates, 0)
	End If

	'�������C����
'	If strBillNo <> "" Then

		'���������擾
'		strRet = objDemand.SelectDmdOrgMasterBurden(strBillNo, _
'													strCloseDate, _
'													strOrgCd1, _
'													strOrgCd2, _
'													strOrgName, _
'													strBillClassCd, _
'													strBillClassName, _
'													lngMethod, _
'													strTaxRates, _
'													strPrtDate, _
'													blnPaymentFlg)

'		If strRet = False Then
'			strArrMessage = Array("��������񂪎擾�ł��܂���ł��� �������ԍ�:" & strBillNo)
'			strAction = "error"
'			Exit Do
'		End If

		'���ߓ���N�E���E���ɕ���
'		lngCloseYear = Year(strCloseDate)
'		lngCloseMonth = Month(strCloseDate)
'		lngCloseDay = Day(strCloseDate)

		'�������o�͓���N�E���E���ɕ���
'		If IsDate(strPrtDate) Then
'			lngPrtYear = Year(strPrtDate)
'			lngPrtMonth = Month(strPrtDate)
'			lngPrtDay = Day(strPrtDate)
'		Else
'			lngPrtYear = 0
'			lngPrtMonth = 0
'			lngPrtDay = 0
'		End If
'		'�����ςݐ������̍폜���\�̏ꍇ�A��ɓ������Ȃ�����
'		If strPaymentBill = PAYMENTBILL_DELETE_ENABLED Then
'			blnPaymentFlg = False
'		End If
'	Else
'		'�V�K�쐬���́A�쐬���@������͍쐬
'		lngMethod = BILL_METHOD_MAN
'	End If

	Exit Do
Loop

'�I�u�W�F�N�g�폜
Set objDemand = Nothing
Set objOrganization = Nothing
%>

<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
var myForm;		// ���t�H�[��

// �c�̌����K�C�h�Ăяo��
function callOrgGuide() {

	orgGuide_showGuideOrg(document.dmdOrgMasterBurden.orgCd1, document.dmdOrgMasterBurden.orgCd2, 'orgName', '', '');

}

// �e�E�C���h�E�֖߂�
function goBackPage() {

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.dmdOrgMasterBurden_CalledFunction != null ) {
		opener.dmdOrgMasterBurden_CalledFunction();
	}

	close();

	return false;
}

//-->
</SCRIPT>
</HEAD>

<BODY BGCOLOR="#ffffff" ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">
<FORM NAME="dmdOrgMasterBurden" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">��������{���o�^</FONT></B></TD>
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
<BR>
<INPUT TYPE="hidden" NAME="mode">
<INPUT TYPE="hidden" NAME="act" VALUE="save">
<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo %>">
<INPUT TYPE="hidden" NAME="billMethod" VALUE="<%= lngMethod %>">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
<!--
	<TR>
						<TD NOWRAP HEIGHT="23">�������ԍ�</TD>
						<TD>�F</TD>
		<TD NOWRAP><%= strBillNo %>�@<FONT COLOR="#999999"><%= IIf(lngMethod = BILL_METHOD_PRG,"�i���ߏ����ō쐬����܂����j","") %></FONT>
		</TD>
	</TR>
-->
	<TR>
						<TD NOWRAP HEIGHT="23">������c��</TD>
						<TD>�F</TD>
		<TD NOWRAP>
			<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
			<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
					<TD WIDTH="5"></TD>
					<TD WIDTH="310"><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP HEIGHT="23">���ߓ�</TD>
		<TD>�F</TD>
		<TD NOWRAP>
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
				<TR>
				<TD><A HREF="javascript:calGuide_showGuideCalendar('closeYear', 'closeMonth', 'closeDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
				<TD><%= EditNumberList("closeYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCloseYear, False) %></TD>
				<TD>�N</TD>
				<TD><%= EditNumberList("closeMonth", 1, 12, lngCloseMonth, False) %></TD>
				<TD>��</TD>
				<TD><%= EditNumberList("closeDay", 1, 31, lngCloseDay, False) %></TD>
				<TD>��</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>�������o�͓�</TD>
		<TD>�F</TD>
		<TD NOWRAP>
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
				<TR>
				<TD><A HREF="javascript:calGuide_showGuideCalendar('prtYear', 'prtMonth', 'prtDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
				<TD><A HREF="JavaScript:calGuide_clearDate('prtYear', 'prtMonth', 'prtDay')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
				<TD><%= EditNumberList("prtYear", YEARRANGE_MIN, YEARRANGE_MAX, lngPrtYear, True) %></TD>
				<TD>�N</TD>
				<TD><%= EditNumberList("prtMonth", 1, 12, lngPrtMonth, True) %></TD>
				<TD>��</TD>
				<TD><%= EditNumberList("prtDay", 1, 31, lngPrtDay, True) %></TD>
				<TD>��</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
<!--
	<tr>
		<td nowrap></td>
		<td></td>
		<td><FONT COLOR="#999999">���������o�͓��������Ɛ����������o�͂ƂȂ薾�ׂ��C���ł��܂��B</FONT></td>
	</tr>
-->
	<TR>
		<TD NOWRAP>�ŗ�</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="text" NAME="taxRates" SIZE="8" MAXLENGTH="8" style="text-align:right" VALUE="<%= strTaxRates %>"><FONT COLOR="#999999">�@��5%�̏ꍇ�A0.05�Ɠ��͂��Ă��������B</FONT></TD>
	</TR>
<% '2004.06.02 ADD STR ORB)T.YAGUCHI ���ڒǉ� %>
	<TR>
		<TD NOWRAP>�Q������</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="checkbox" NAME="secondFlg" VALUE="1"><FONT COLOR="#999999">�@���Q�������������̏ꍇ�A�`�F�b�N���Ă��������B</FONT></TD>
	</TR>
<% '2004.06.02 ADD END %>
</TABLE>
<BR><BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" ALIGN="right">
	<TR>
		<TD WIDTH="160"></TD>
		<TD WIDTH="5"></TD>

		<TD>
		<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
			<A HREF="JavaScript:document.dmdOrgMasterBurden.submit()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e��ۑ�"></A>
		<%  else    %>
			 &nbsp;
		<%  end if  %>
		<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
		</TD>
		
		<TD WIDTH="5"></TD>
		<TD><A HREF="javascript:opener.winfl=0;window.close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
	</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
