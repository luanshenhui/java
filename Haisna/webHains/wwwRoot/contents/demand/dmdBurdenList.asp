<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���������� (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<!-- #include virtual = "/webHains/includes/EditBillClassList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�����l
Dim strAction				'������ԁi�����{�^��������:"search"�j
Dim lngStrYear				'�J�n���ߓ�(�N)
Dim lngStrMonth				'�J�n���ߓ�(��)
Dim lngStrDay				'�J�n���ߓ�(��)
Dim lngEndYear				'�I�����ߓ�(�N)
Dim lngEndMonth				'�I�����ߓ�(��)
Dim lngEndDay				'�I�����ߓ�(��)
Dim strOrgCd1				'�c�̃R�[�h�P
Dim strOrgCd2				'�c�̃R�[�h�Q
Dim strBillNo				'�������m��
Dim lngStartPos				'�\���J�n�ʒu
Dim strIsPrint				'�������o�͏��
'��2004/01/09 Shiramizu Modified Start
Dim strIsDispatch			'�������������
Dim strIsPayment			'�������
Dim strIsCancel				'����`�[�\��
Dim strSortName				'�\�[�g��
Dim strSortType				'�\�[�g���i1:�����A2�F�~���j
Dim strGetCount				'�P�y�[�W�\������
Dim strCloseDate			'�������ԍ�������������擾�������ߓ�
Const LENGTH_BILLNO = 14
'��2004/01/09 Shiramizu Modified End
Dim strHideIsrData			'���ۃf�[�^��\��

Dim strCslOrgCd1			'��f�c�̃R�[�h�P
Dim strCslOrgCd2			'��f�c�̃R�[�h�Q
Dim strCslOrgName			'��f�c�̖�

'COM�I�u�W�F�N�g
Dim objCommon				'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objDemand				'�����A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objOrganization			'�c�̃A�N�Z�X�pCOM�I�u�W�F�N�g

'���������ǂݍ���
Dim strStrDate				'�J�n���ߓ�
Dim strEndDate				'�I�����ߓ�
Dim lngAllCount				'�����𖞂����S���R�[�h����
Dim strPageMaxLine			'�P�y�[�W�\���s��
Dim lngGetCount				'�P�y�[�W�\������
Dim lngCount				'�����ł�������
Dim lngArrBillNo			'�������m��
Dim strArrCloseDate			'���ߓ��i"yyyy/m/d"�ҏW�j
Dim strArrOrgCd1			'���S���c�̃R�[�h1
Dim strArrOrgCd2			'���S���c�̃R�[�h2
Dim strArrOrgName			'���S���c�̖�
Dim lngArrMethod			'�쐬���@
Dim lngArrSeq				'
Dim strArrCslOrgCd1			'��f�c�̃R�[�h1
Dim strArrCslOrgCd2			'��f�c�̃R�[�h2
Dim strArrCslOrgName		'��f�c�̖�
Dim strArrCsCd				'�R�[�X�R�[�h
Dim strArrCsName			'�R�[�X��
Dim strArrWebColor			'�R�[�X���\���F
Dim strArrCsSubTotal		'���z
Dim strArrCsTax				'�����
Dim strArrCsDiscount		'�l����
Dim strArrCsTotal			'���v
'��2004/01/09 Shiramizu Modified Start
Dim strArrOrgKName			'�c�̃J�i��
Dim strArrBillSeq			'������Seq
Dim strArrBranchno			'�������}��
Dim strArrDispatchDate		'�������t
Dim strArrPaymentDate		'�������t
Dim lngArrPriceTotal		'���v
Dim lngArrTaxTotal			'�Ŋz
Dim lngArrBillTotal			'�����z
Dim lngArrPaymentPrice		'�����z
Dim lngArrSumPaymentPrice	'�����z���v
Dim strArrUpdUser			'�X�V��ID
Dim strArrUserName			'�X�V��
Dim strArrDelFlg			'����`�[�t���O
'Dim lngArrSeq				'Seq
'��2004/01/09 Shiramizu Modified End
'### 2004/11/11 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ�
Dim strArrBillComment		'�������R�����g
'### 2004/11/11 Add End
'## 2004.06.02 ADD STR ORB)T.YAGUCHI �Q�������̍��v���z�ǉ��ǉ�
Dim strSumPrice				'���z���v
Dim strSumEditPrice			'�������z���v
Dim strSumTaxPrice			'�Ŋz���v
Dim strSumEditTax			'�����Ŋz���v
Dim strSumPriceTotal			'�����v
Dim lngSumRecord			'���R�[�h��
'## 2004.06.02 ADD END

Dim strBillClassCd			'���������ރR�[�h

Dim strArrBillClassCd		'���������ރR�[�h
Dim strArrBillClassName		'���������ޖ�
Dim strArrPrtDate			'�������o�͓�
Dim strArrIsrSign			'���ۋL��
Dim strArrIsrOrgName		'���ۋL������̑Ώےc�̖�
Dim strArrCsSeq				'�R�[�XSEQ

'��ʕ\���p�ҏW�̈�
Dim strDispCloseDate		'�ҏW�p�̒��ߓ��i"yyyy/m/d"�ҏW�j
Dim strDispBillNo			'�������ԍ�
Dim strDispOrgName			'�ҏW�p�̕��S���c�̖�
Dim strDispOrgKName

Dim strDispDiscount			'�ҏW�p�̒l����
Dim strDispCsSubTotal
Dim strDispCsTax
Dim strDispCsTotal

Dim strDispCslOrgName		'�ҏW�p�̎�f�c�̖�
Dim strDispBillClassName	'���������ޖ�
Dim strDispCsMark			'�R�[�X�}�[�N
Dim strDispCsMarkColor		'�R�[�X�}�[�N�J���[
Dim strDispCsName			'�R�[�X��
Dim blnBreakMode			'TRUE:�������P�ʂ̍��v�\���AFALSE:�������P�ʂ̍��v��\��

Dim strDispPriceTotal		'���v
Dim strDispTaxTotal			'�����
Dim strDispBillTotal		'�������z
Dim strDispPaymentPrice		'�����z
Dim strDispNoPaymentPrice	'�����z


'�u���C�N�L�[�p�ϐ��i�[�̈�
Dim strKeyBillNo			'�u���C�N�L�[�ۑ��p�̐������m��
Dim strKeyCslOrgCd1			'�u���C�N�L�[�ۑ��p�̎�f�c�̃R�[�h1
Dim strKeyCslOrgCd2			'�u���C�N�L�[�ۑ��p�̎�f�c�̃R�[�h2

Dim lngBillSubTotal			'���v
Dim lngBillTax				'�Ŋz
Dim lngBillDiscount			'�l����
Dim lngBillTotal			'�����v

'�c�̓ǂݍ���
Dim strOrgName			'�c�̖���

'���̓`�F�b�N
Dim strArrMessage		'�G���[���b�Z�[�W

'�C���f�b�N�X
Dim i

Dim dtmDate				'��f���f�t�H���g�l�v�Z�p�̓��t
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strAction      = Request("action") & ""
lngStrYear     = CLng("0" & Request("strYear"))
lngStrMonth    = CLng("0" & Request("strMonth"))
lngStrDay      = CLng("0" & Request("strDay"))
lngEndYear     = CLng("0" & Request("endYear"))
lngEndMonth    = CLng("0" & Request("endMonth"))
lngEndDay      = CLng("0" & Request("endDay"))
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCslOrgCd1   = Request("cslOrgCd1")
strCslOrgCd2   = Request("cslOrgCd2")

strBillNo      = Request("billNo")
lngStartPos    = CLng("0" & Request("startPos"))
lngStartPos    = IIf(lngStartPos = 0, 1, lngStartPos)
strBillCLassCd = Request("billCLassCd") & ""
strIsPrint     = Request("IsPrint")
'��2004/01/09 Shiramizu Modified Start
strIsDispatch  = Request("IsDispatch")
strIsPayment   = Request("IsPayment")
strIsCancel    = Request("IsCancel")
strSortName    = Request("SortName")
strSortType    = Request("SortType")
strGetCount    = Request("getCount")
'��2004/01/09 Shiramizu Modified End
strHideIsrData = Request("HideIsrData")

'### 2003.04.01 �����\�����̂݁A�������o�͓��͖��o�݂͂̂Ƃ���B
'### 2003.04.08 ����Ɏw��
'If lngStrYear  = 0 then
If (lngStrYear  = 0) AND (strIsPrint = "") then
	strIsPrint = "2"
End If

'���w�莞�͏����l�Z�b�g
lngStrYear    = IIf(lngStrYear  = 0, Year(Now),    lngStrYear )
lngStrMonth   = IIf(lngStrMonth = 0, Month(Now),   lngStrMonth)
lngStrDay     = IIf(lngStrDay   = 0, Day(Now),     lngStrDay  )
lngEndYear    = IIf(lngEndYear  = 0, Year(Now()),  lngEndYear )
lngEndMonth   = IIf(lngEndMonth = 0, Month(Now()), lngEndMonth)
lngEndDay     = IIf(lngEndDay   = 0, Day(Now()),   lngEndDay  )

'�����ݒ�
strArrMessage = Empty

'�ꗗ�\���s���̎擾
Set objCommon = Server.CreateObject("HainsCommon.Common")
strPageMaxLine = objCommon.SelectDmdBurdenListPageMaxLine
If strGetCount = "" Then
	strGetCount = strPageMaxLine
Else
	If strGetCount = "*" Then
'		strGetCount = ""
	End If
End If

Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�c�̖��̂̎擾
If Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" Then
	objOrganization.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
End If

'��f�c�̖��̂̎擾
If Trim(strCslOrgCd1) <> "" And Trim(strCslOrgCd2) <> "" Then
	objOrganization.SelectOrgName strCslOrgCd1, strCslOrgCd2, strCslOrgName
End If

Set objOrganization = Nothing

'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̊��蓖��
Set objDemand = Server.CreateObject("HainsDemand.Demand")
'�����{�^�����������̓`�F�b�N�istrStrDate��strEndDate�ɁADate�^�ŕԂ����j
If strAction = "search" Then
	strArrMessage = objDemand.CheckValueDmdPaymentSearch(lngStrYear, lngStrMonth, lngStrDay, strStrDate, lngEndYear, lngEndMonth, lngEndDay, strEndDate, strBillNo)
	If Not IsNull(strBillNo) And strBillNo <> "" Then
		If Len(strBillNo) = LENGTH_BILLNO Then
			strCloseDate = Mid(strBillNo,1,4) & "/" & Mid(strBillNo,5,2) & "/" & Mid(strBillNo,7,2)
			If Not IsDate(strCloseDate) Then
				If IsArray(strArrMessage) = true Then
					Redim Preserve strArrMessage(UBound(strArrMessage)+1)
					strArrMessage(UBound(strArrMessage)) = "�������ԍ��̓��t���͌`��������������܂���B"
				Else
					strArrMessage = Array("�������ԍ��̓��t���͌`��������������܂���B")
				End If
			End If
		End If
	End If
End If



'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���������̕ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function getSortURL(strWkSortName)
	Dim strURL
	Dim strWkSortType

	If strWkSortName = strSortName Then
		If strSortType = "1" Then
			strWkSortType = "2"
		Else
			strWkSortType = "1"
		End If
	Else
		strWkSortType = "1"
	End If

	'URL�̕ҏW
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?action="        & strAction
	strURL = strURL & "&strYear="       & lngStrYear
	strURL = strURL & "&strMonth="      & lngStrMonth
	strURL = strURL & "&strDay="        & lngStrDay
	strURL = strURL & "&endYear="       & lngEndYear
	strURL = strURL & "&endMonth="      & lngEndMonth
	strURL = strURL & "&endDay="        & lngEndDay
	strURL = strURL & "&orgCd1="        & strOrgCd1
	strURL = strURL & "&orgCd2="        & strOrgCd2

	strURL = strURL & "&billNo="        & strBillNo
	strURL = strURL & "&IsDispatch="    & strIsDispatch
	strURL = strURL & "&IsPayment="     & strIsPayment
	strURL = strURL & "&IsCancel="      & strIsCancel
	strURL = strURL & "&SortName="      & strWkSortName
	strURL = strURL & "&SortType="      & strWkSortType
	strURL = strURL & "&GetCount="      & strGetCount

	getSortURL = strURL
End Function


'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\���s���ꗗ�h���b�v�_�E�����X�g�̕ҏW
'
' �����@�@ : (In)     strName                 �G�������g��
' �@�@�@�@ : (In)     strSelectedPageMaxLine  ���X�g�ɂđI�����ׂ��\���s��
'
' �߂�l�@ : HTML������
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditDailyPageMaxLineList(strName, strSelectedPageMaxLine)

	Dim vntPageMaxLine	'�\���s��
	Dim vntPageMaxName	'�\���s������

	'�\���s�����̎擾
	If objCommon.SelectDailyPageMaxLineList(vntPageMaxLine, vntPageMaxName) > 0 Then

		'�h���b�v�_�E�����X�g�̕ҏW
		EditDailyPageMaxLineList = EditDropDownListFromArray(strName, vntPageMaxLine, vntPageMaxName, strSelectedPageMaxLine, NON_SELECTED_DEL)

	End If

End Function

'�\�[�g���w�莞�̃Z���w�i�F�ύX
Function getSelectedColor(strWkSortName)
	Dim strColor

	If strWksortName = strSortName Then
		strColor = "CLASS=""selectedcolor"""
	Else
		strColor = ""
	End If

	getSelectedColor = strColor
End Function


'����`�[�̍s�w�i�F�ύX
Function getCanceledColor(strDelFlg)
	Dim strColor

	If strDelFlg = "1" Then
		strColor = "CLASS=""canceled"""
	Else
		strDelFlg = ""
	End If

	getCanceledColor = strColor
End Function

'�����z�̕����F�ύX
Function getNopaymentColor(strDispNoPaymentPrice)
	Dim strColor

	If IsNull(strDispNoPaymentPrice) Or strDispNoPaymentPrice = "" Then
		strColor="BLACK"
	Else
		If CLng(strDispNoPaymentPrice) = 0 Then
			strColor="BLACK"
		Else
			strColor="RED"
		End If
	End If
	getNopaymentColor = strColor
End Function

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>����������</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var dmdOrgMasterBurden_CalledFunction;	// ��������{��񏈗���Ăяo���֐�
var winOrgMasterBurden;					// ��������{���E�B���h�E�n���h��
var dmdBurdenModify_CalledFunction;		// ������{��񏈗���Ăяo���֐�
var winBurdenModify;					// ������{���E�B���h�E�n���h��
var flgBurdenModify;					// ��������{���Ăяo���t���O
var dmdPayment_CalledFunction;			// ����������Ăяo���֐�
var winPayment;							// ���������E�B���h�E�n���h��
flgBurdenModify = false;
flgOrgMasterBurden = false;

// �c�̌����K�C�h�Ăяo��
function callOrgGuide( mode ) {

	var targetOrgCd1;
	var targetOrgCd2;
	var targetOrgName;

	if ( mode == 1 ) {
		targetOrgCd1  = document.entryCondition.orgCd1
		targetOrgCd2  = document.entryCondition.orgCd2
		orgGuide_showGuideOrg(targetOrgCd1, targetOrgCd2, 'orgName', '', '');

		targetOrgName = document.entryCondition.orgCdName
	} else {
		targetOrgCd1  = document.entryCondition.cslOrgCd1
		targetOrgCd2  = document.entryCondition.cslOrgCd2
		orgGuide_showGuideOrg(targetOrgCd1, targetOrgCd2, 'cslOrgName', '', '');
	}

}

// �c�̃R�[�h�E���̂̃N���A
function clearOrgInfo( mode ) {

	if ( mode == 1 ) {
		orgGuide_clearOrgInfo(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');
	} else {
		orgGuide_clearOrgInfo(document.entryCondition.cslOrgCd1, document.entryCondition.cslOrgCd2, 'cslOrgName');
	}

}


// �������V�K�쐬�Ăяo��
function callDmdOrgMasterBurden() {

	var opened = false;
	flgOrgMasterBurden = true;

	dmdOrgMasterBurden_CalledFunction = loadBurdenList;

	// ���łɐ�������{��񂪊J����Ă��邩�`�F�b�N
	if ( winOrgMasterBurden != null ) {
		if ( !winOrgMasterBurden.closed ) {
			opened = true;
		}
	}

	if ( opened ) {
		winOrgMasterBurden.location.replace("dmdOrgMasterBurden.asp");
		winOrgMasterBurden.focus();
	} else {
//		winOrgMasterBurden = window.open("dmdOrgMasterBurden.asp?billNo=" + billNo,"","toolbar=no,directories=no,menubar=no,resizable=yes,scrollbars=yes,width=650,height=400");
		winOrgMasterBurden = window.open("dmdOrgMasterBurden.asp");
	}
	
	return false;
}


// ��������{���Ăяo��
function callDmdBurdenModify( billNo) {

	var opened = false;
	flgBurdenModify = true;

	dmdBurdenModify_CalledFunction = loadBurdenList;

	// ���łɐ������C�����J����Ă��邩�`�F�b�N
	if ( winBurdenModify != null ) {
		if ( !winBurdenModify.closed ) {
			opened = true;
		}
	}

	if ( opened ) {
		winBurdenModify.location.replace("dmdBurdenModify.asp?billNo=" + billNo);
		winBurdenModify.focus();
	} else {
		winBurdenModify = window.open("dmdBurdenModify.asp?billNo=" + billNo);
	}
	
	return false;
}


// ���������Ăяo��
function callDmdPayment(mode, billNo, seq) {

	var opened = false;

	dmdPayment_CalledFunction = loadBurdenList;

	// ���łɐ������C�����J����Ă��邩�`�F�b�N
	if ( winPayment != null ) {
		if ( !winPayment.closed ) {
			opened = true;
		}
	}

	if ( opened ) {
		winPayment.location.replace("dmdPayment.asp?mode=" + mode + "&billNo=" + billNo + "&seq=" + seq);
		winPayment.focus();
	} else {
		winPayment = window.open("dmdPayment.asp?mode=" + mode + "&billNo=" + billNo + "&seq=" + seq);
	}
	
	return false;
}

// ��������{���E�������C��������A����ʍX�V
function loadBurdenList() {
	document.entryCondition.submit();
	return false;
}

// ��������{��񏈗���A����ʍX�V
function focusBurdenList() {
	if(flgBurdenModify == true){
		if(winBurdenModify == null || winBurdenModify.closed){
			document.entryCondition.submit();
		}
	}

	if(flgOrgMasterBurden == true){
		if(winOrgMasterBurden == null || winOrgMasterBurden.closed){
			document.entryCondition.submit();
		}
	}
	return false;
}


// �����{�^���������̏���
function submitSearch() {

	document.entryCondition.startPos.value = '1';
	document.entryCondition.submit();

	return false;
}

// �A�����[�h���̏���
function closeDmdBurdenWindow() {

	// �������C�������
	if ( winBurdenModify != null ) {
		if ( !winBurdenModify.closed ) {
			winBurdenModify.close();
		}
	}

	// ��������{�������
	if ( winPayment != null ) {
		if ( !winPayment.closed ) {
			winPayment.close();
		}
	}

	// �J�����_�[�K�C�h�����
	if ( winGuideCalendar ) {
		if ( !winGuideCalendar.closed ) {
			winGuideCalendar.close();
		}
	}

	// �c�̌����K�C�h�����
	orgGuide_closeGuideOrg();

	return false;
}
//-->
</SCRIPT>
<style>
	table.mainresult td { padding: 0 4px 0; }
	td.dmdtab  { background-color:#FFFFFF }
	div.maindiv { margin: 10px 10px 0 10px; }
</STYLE>
</HEAD>
<BODY onFocus="focusBurdenList();" onUnload="closeDmdBurdenWindow();">
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<!--<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">-->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="return submitSearch()" METHOD="get">
<INPUT TYPE="hidden" NAME="action" VALUE="search">
<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= CStr(lngStartPos) %>">
<INPUT TYPE="hidden" NAME="SortName" VALUE="<%= strSortName%>">
<INPUT TYPE="hidden" NAME="SortType" VALUE="<%= strSortType%>">
<!--
��2004/01/09 Shiramizu Modified Start
��ʖ��񕝕ύX
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
-->

<div class="maindiv">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">����������</FONT></B></TD>
	</TR>
</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
<TABLE WIDTH=80%>
<TR><TD>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD>���ߓ�</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
					<TD>��</TD>
					<TD>�`</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, False) %></TD>
					<TD>��</TD>
				</TR>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>������</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:callOrgGuide(1)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
					<TD><A HREF="javascript:clearOrgInfo(1)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
					<TD WIDTH="5"></TD>
					<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
					<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
					<TD><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
<!--
	<TR>
		<TD>��f�c��</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:callOrgGuide(2)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
					<TD><A HREF="javascript:clearOrgInfo(2)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
					<TD WIDTH="5"></TD>
					<INPUT TYPE="hidden" NAME="cslOrgCd1" VALUE="<%= strCslOrgCd1 %>">
					<INPUT TYPE="hidden" NAME="cslOrgCd2" VALUE="<%= strCslOrgCd2 %>">
					<TD><SPAN ID="cslOrgName"><%= strCslOrgName %></SPAN></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
-->
<!--
��2004/01/09 Shiramizu Modified Start
�@�����������ڕύX
	<TR>
		<TD>���ۃf�[�^</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="CHECKBOX" VALUE="1" NAME="hideIsrData" <%= IIf(strHideIsrData = "1", "CHECKED", "") %>>���N�ی��g���̃f�[�^�͕\���ΏۊO
		</TD>
	</TR>
	<TR>
		<TD>����������</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><%= Replace(EditBillClassList("billClassCd", strBillClassCd, NON_SELECTED_ADD), "NAME=""billClassCd""", "NAME=""billClassCd""" ) %></TD>
					<TD WIDTH="5"></TD>
					<TD NOWRAP>�������ԍ�</TD>
					<TD>�F</TD>
					<TD><INPUT TYPE="text" NAME="billNo" SIZE="11" MAXLENGTH="9" VALUE="<%= strBillNo %>"></TD>
					<TD WIDTH="5"></TD>
					<TD NOWRAP>������</TD>
					<TD>�F</TD>
					<TD>
						<SELECT NAME="IsPrint">
							<OPTION VALUE="2" <%= Iif(strIsPrint = "2", "SELECTED", "") %>>���o�͂̂�
							<OPTION VALUE="1" <%= Iif(strIsPrint = "1", "SELECTED", "") %>>�o�͍ς݂̂�
<!-- 2003.04.08 Updated by Ishihara@FSIT �󔒂ł͌l�������z�����Jump�ł��܂�
							<OPTION VALUE=""  <%= Iif(strIsPrint = "",  "SELECTED", "") %>>�S��
-->
<!--
							<OPTION VALUE="0"  <%= Iif(strIsPrint = "0",  "SELECTED", "") %>>�S��
						</SELECT>
					</TD>
					<TD WIDTH="25"></TD>
					<TD ALIGN="right"><A HREF="javascript:function voi(){};voi()" ONCLICK="return submitSearch()"><IMG SRC="/webHains/images/b_search.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
					<TD WIDTH="5"></TD>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return callDmdOrgMasterBurden('');"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�������������쐬����"></A></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
-->
	<TR>
		<TD NOWRAP>������No.</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TD><INPUT TYPE="text" NAME="billNo" SIZE="20" MAXLENGTH="14" VALUE="<%= strBillNo %>"></TD>
				<TD WIDTH="10"></TD>
				<TD NOWRAP>����������</TD>
				<TD>�F</TD>
				<TD>
					<SELECT NAME="IsDispatch">
						<OPTION VALUE="0" <%= Iif(strIsDispatch = "0", "SELECTED", "") %>>
						<OPTION VALUE="2" <%= Iif(strIsDispatch = "2", "SELECTED", "") %>>�������̂�
						<OPTION VALUE="1" <%= Iif(strIsDispatch = "1", "SELECTED", "") %>>�����ς݂̂�
					</SELECT>
				</TD>
				<TD WIDTH="10">
				</TD>
				<TD NOWRAP>����</TD>
				<TD>�F</TD>
				<TD>
					<SELECT NAME="IsPayment">
						<OPTION VALUE="0" <%= Iif(strIsPayment = "0", "SELECTED", "") %>>
						<OPTION VALUE="2" <%= Iif(strIsPayment = "2", "SELECTED", "") %>>�����̂�
						<OPTION VALUE="1" <%= Iif(strIsPayment = "1", "SELECTED", "") %>>�����ς݂̂�
					</SELECT>
				</TD>
				<TD WIDTH="25"></TD>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>����`�[</TD>
		<TD>�F</TD>
		<TD>
		<TABLE>
			<TR>
				<TD NOWRAP>
					<INPUT TYPE="CHECKBOX" NAME="IsCancel" <%= Iif(strIsCancel = "1","CHECKED","") %> VALUE="1">����`�[���\������
				</TD>
			</TR>
		</TABLE>
		</TD>
	</TR>
<!--
					<TD><INPUT TYPE="text" NAME="billNo" SIZE="11" MAXLENGTH="9" VALUE="<%= strBillNo %>"></TD>
					<TD WIDTH="5"></TD>
-->
<!--
��2004/01/09 Shiramizu Modified End
-->
</TABLE>
</TD>
<TD VALIGN="BOTTOM">
	<TABLE BORDER=0>
		<TD>
<%= EditDailyPageMaxLineList("getCount", strGetCount) %>
		</TD>
		<TD ALIGN="right"><A HREF="javascript:function voi(){};voi()" ONCLICK="return submitSearch()"><IMG SRC="/webHains/images/b_search.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
		<TD WIDTH="5"></TD>
		
        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
            <TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return callDmdOrgMasterBurden();"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="�V�������������쐬����"></A></TD>
        <%  end if  %>

		</TD>
	</TABLE>
</TD>
</TABLE>
<%
Do
	'�����{�^���������ȊO�͉������Ȃ�
	If strAction <> "search" Then Exit Do

	'��������������Ă���ꍇ�͉������Ȃ�
	If Not IsEmpty(strArrMessage) Then Exit Do

	'���������𖞂������R�[�h�������擾
	lngAllCount = objDemand.SelectDmdBurdenList("CNT", strStrDate, strEndDate, strBillNo, strOrgCd1, strOrgCd2, strIsDispatch, strIsPayment, strIsCancel)

	'��f�c�̂��p�����^�w�肳��Ă���ꍇ�́A���v���u���C�N�����Ȃ��i���Ă������ł��Ȃ��j���[�h
	blnBreakMode = True
	If (strCslOrgCd1 <> "") And (strCslOrgCd2 <> "") Then
		blnBreakMode = false
	End If

	'���R�[�h��������ҏW
%>
<BR>
<!--�����͌�����������-->
<SPAN STYLE="font-size:9pt;">
�u<FONT COLOR="#ff6600"><B><%= CStr(Year(strStrDate)) %>�N<%= CStr(Month(strStrDate)) %>��<%= CStr(Day(strStrDate)) %>��<%= IIf(strStrDate = strEndDate, "", "�`" & CStr(Year(strEndDate)) & "�N" & CStr(Month(strEndDate)) & "��" & CStr(Day(strEndDate)) & "��") %></B></FONT>�v�̐������ꗗ��\�����Ă��܂��B<BR>
<FONT color="#ff6600"><B><%= CStr(lngAllCount) %></B></FONT>���̐������i<%= IIf( blnBreakMode = false, "�擾�f�[�^�����P��", "�����������P��") %>�j������܂��B
</SPAN>
<BR><BR>
<%
	'�������ʂ����݂��Ȃ��ꍇ�͉������Ȃ�
	If lngAllCount = 0 Then
		Exit Do
	End If

	'strStrDate��strEndDate���AString�^�ɕϊ�
	strStrDate = CStr(Year(strStrDate)) & "/" & CStr(Month(strStrDate)) & "/" & CStr(Day(strStrDate))
	strEndDate = CStr(Year(strEndDate)) & "/" & CStr(Month(strEndDate)) & "/" & CStr(Day(strEndDate))

'### 2004/11/11 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ�

	'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
'	lngCount = objDemand.SelectDmdBurdenList("", strStrDate, strEndDate, strBillNo, strOrgCd1, strOrgCd2, strIsDispatch, strIsPayment, strIsCancel, lngStartPos, strGetCount, strSortName, strSortType, _
'	                                         lngArrBillNo, _
'	                                         strArrCloseDate, _
'	                                         strArrBillSeq, _
'	                                         strArrBranchno, _
'	                                         strArrOrgCd1, _
'	                                         strArrOrgCd2, _
'	                                         strArrOrgName, _
'	                                         strArrOrgKName, _
'	                                         lngArrMethod, _
'	                                         strArrPrtDate, _
'	                                         strArrDispatchDate, _
'	                                         strArrPaymentDate, _
'	                                         lngArrPriceTotal, _
'	                                         lngArrTaxTotal, _
'	                                         lngArrBillTotal, _
'	                                         lngArrPaymentPrice, _
'	                                         lngArrSumPaymentPrice, _
'	                                         strArrUpdUser, _
'	                                         strArrUserName, _
'	                                         lngArrSeq, _
'	                                         strArrDelFlg)

	lngCount = objDemand.SelectDmdBurdenList("", strStrDate, strEndDate, strBillNo, strOrgCd1, strOrgCd2, strIsDispatch, strIsPayment, strIsCancel, lngStartPos, strGetCount, strSortName, strSortType, _
	                                         lngArrBillNo, _
	                                         strArrCloseDate, _
	                                         strArrBillSeq, _
	                                         strArrBranchno, _
	                                         strArrOrgCd1, _
	                                         strArrOrgCd2, _
	                                         strArrOrgName, _
	                                         strArrOrgKName, _
	                                         lngArrMethod, _
	                                         strArrPrtDate, _
	                                         strArrDispatchDate, _
	                                         strArrPaymentDate, _
	                                         lngArrPriceTotal, _
	                                         lngArrTaxTotal, _
	                                         lngArrBillTotal, _
	                                         lngArrPaymentPrice, _
	                                         lngArrSumPaymentPrice, _
	                                         strArrUpdUser, _
	                                         strArrUserName, _
	                                         lngArrSeq, _
	                                         strArrDelFlg, _
											 strArrBillComment)
'### 2004/11/11 Add End

	'�������ꗗ�̕ҏW�J�n
%>
<!--
	<SPAN STYLE="color:#cc9999">��</SPAN>�u<B>�����於</B>�v���N���b�N����ƁA���������e�̏C����ʂ��\������܂��B<BR>
	<SPAN STYLE="color:#cc9999">��</SPAN>�u<B>�R�[�X��</B>�v���N���b�N����ƁA���S���ʁA�c�̕ʁA�R�[�X�ʂ̐������׏C����ʂ��\������܂��B<BR>
-->
	<SPAN STYLE="color:#cc9999;">��</SPAN>�u<B>�������ԍ�</B>�v���N���b�N����ƁA���������e�̏C����ʂ��\������܂��B<BR>
	<TABLE class="mainresult" style="margin:10px 0 0 0;">
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP <%= getSelectedColor("1")%>><A HREF="<%= getSortURL("1")%>">���ߓ�</A></TD>
			<TD NOWRAP>������No.</TD>
			<TD NOWRAP <%= getSelectedColor("2")%>><A HREF="<%= getSortURL("2")%>">�c�̖�</A></TD>
			<TD NOWRAP <%= getSelectedColor("3")%>><A HREF="<%= getSortURL("3")%>">�c�̃J�i��</A></TD>
			<TD NOWRAP ALIGN="right">���v</TD>
			<TD NOWRAP ALIGN="right">�����</TD>
			<TD NOWRAP ALIGN="right">�������z</TD>
			<TD NOWRAP ALIGN="right">�����z</TD>
			<TD NOWRAP <%= getSelectedColor("4")%>><A HREF="<%= getSortURL("4")%>">������</A></TD>
			<TD NOWRAP ALIGN="right">�����z</TD>
			<TD NOWRAP>�����S��</TD>
			<TD NOWRAP>����</TD>
			<TD NOWRAP>������������</TD>
<!-- ### 2004/11/11 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ� -->
			<TD NOWRAP>�������R�����g</TD>
<!-- ### 2004/11/11 Add End -->
		</TR>
<%
	'���ׂ̐��������[�v����
	For i = 0 To lngCount - 1
		'�\���p�ɕҏW
		strDispCloseDate = strArrCloseDate(i)
		strDispBillNo = lngArrBillNo(i)
		strDispOrgName = strArrOrgName(i)
		strDispOrgKName = strArrOrgKName(i)

		'���v
		if lngArrPriceTotal(i) <> "" Then
			strDispPriceTotal = FormatCurrency(lngArrPriceTotal(i))
		Else
			strDispPriceTotal = ""
		End If

		'�Ŋz
		if lngArrTaxTotal(i) <> "" Then
			strDispTaxTotal = FormatCurrency(lngArrTaxTotal(i))
		Else
			strDispTaxTotal = ""
		End If

		'�������z
		If lngArrBillTotal(i) <> "" Then
			strDispBillTotal = FormatCurrency(lngArrBillTotal(i))
		Else
			strDispBillTotal = ""
		End If

		'�����z
		If lngArrBillTotal(i) <> "" Then
			If lngArrSumPaymentPrice(i) <> "" Then
				strDispNoPaymentPrice = FormatCurrency(lngArrBillTotal(i) - lngArrSumPaymentPrice(i))
			Else
				strDispNoPaymentPrice = FormatCurrency(lngArrBillTotal(i))
			End If
		Else
			If lngArrSumPaymentPrice(i) <> "" Then
				strDispNoPaymentPrice = FormatCurrency(lngArrSumPaymentPrice(i) * -1)
			Else
				strDispNoPaymentPrice = ""
			End If
		End If

		If lngArrPaymentPrice(i) <> "" Then
			strDispPaymentPrice = FormatCurrency(lngArrPaymentPrice(i))
		Else
			strDispPaymentPrice = ""
		End If

'## 2004.06.02 ADD STR ORB)T.YAGUCHI �Q�������̍��v���z�ǉ��ǉ�
		lngSumRecord = objDemand.SelectSumDetailItems(strDispBillNo,, _
								strSumPrice, _
								strSumEditPrice, _
								strSumTaxPrice, _
								strSumEditTax, _
								strSumPriceTotal)
		'�Q���������v���z�̒ǉ�
		If lngSumRecord > 0 Then
			strDispPriceTotal = CDbl(strDispPriceTotal) + strSumPrice(0) + strSumEditPrice(0)
			strDispTaxTotal = CDbl(strDispTaxTotal) + strSumTaxPrice(0) + strSumEditTax(0)
			strDispBillTotal = CDbl(strDispBillTotal) + strSumPriceTotal(0)
			strDispNoPaymentPrice = CDbl(strDispNoPaymentPrice) + strSumPriceTotal(0)
			strDispPriceTotal = FormatCurrency(strDispPriceTotal)
			strDispTaxTotal = FormatCurrency(strDispTaxTotal)
			strDispBillTotal = FormatCurrency(strDispBillTotal)
			strDispNoPaymentPrice = FormatCurrency(strDispNoPaymentPrice)
		End If
'## 2004.06.02 ADD END

		If i = 0 Then
%>
			<TR>
				<TD HEIGHT="1" COLSPAN="28" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>
			</TR>
			<TR><TD HEIGHT=5></TD></TR>
<%
		End If
%>
			<TR <%=getCanceledColor(strArrDelFlg(i))%>>
				<TD><%= strDispCloseDate%></TD>
				<TD><A HREF="" onClick="return callDmdBurdenModify('<%= strDispBillNo%>');"><%= strDispBillNo%></A></TD>
				<TD><%= strDispOrgName%></TD>
				<TD><%= strDispOrgKName%></TD>
				<TD NOWRAP ALIGN="right"><%= strDispPriceTotal%></TD>
				<TD NOWRAP ALIGN="right"><%= strDispTaxTotal%></TD>
				<TD NOWRAP ALIGN="right"><B><%= strDispBillTotal%></B></TD>
				<TD NOWRAP ALIGN="right"><FONT COLOR="<%=getNopaymentColor(strDispNoPaymentPrice)%>"><B><%= strDispNoPaymentPrice%></B></FONT></TD>
				<TD><%= strArrPaymentDate(i)%></TD>
				<TD NOWRAP ALIGN="right"><%= strDispPaymentPrice%></TD>
				<TD><%= strArrUserName(i)%></TD>
				<TD NOWRAP>
<!--					<A HREF="" onClick="return callDmdPayment('add','<%= lngArrBillNo(i)%>','');">�ǉ�</A>�@-->
					<A HREF="" onClick="return callDmdPayment('update','<%= lngArrBillNo(i)%>','<%= lngArrSeq(i)%>');">����</A>
				</TD>
				<TD><%= strArrDispatchDate(i)%></TD>
<!-- ### 2004/11/11 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ� -->
				<TD NOWRAP><%= strArrBillComment(i)%></TD>
<!-- ### 2004/11/11 Add End -->
			</TR>

			<TR><TD HEIGHT=5></TD></TR>
			<TR>
				<TD HEIGHT="1" COLSPAN="28" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
			</TR>
			<TR><TD HEIGHT=5></TD></TR>
<%
			'�u���C�N���̃L�[�Z�b�g�A�y�ѕҏW�W�v�̈�̏�����
'			strKeyBillNo         = lngArrBillNo(i)
'			strDispCloseDate     = strArrCloseDate(i)
'			strDispOrgName       = strArrOrgName(i)
'			strDispBillClassName = strArrBillClassName(i)
'			strKeyCslOrgCd1 = ""
'			strKeyCslOrgCd2 = ""
'			lngBillSubTotal = 0
'			lngBillTax      = 0
'			lngBillDiscount = 0
'			lngBillTotal    = 0

'		End If

'		strDispCslOrgName = strArrCslOrgName(i)

		'�u���C�N���[�h�łȂ��Ȃ疾�ז��̂�S�ĕ\������
		If blnBreakMode = false Then
			strDispCloseDate     = strArrCloseDate(i)
			strDispOrgName       = lngArrBillNo(i) & ":" & strArrOrgName(i)
			strDispBillClassName = strArrBillClassName(i)
		End If

		'�O�s�ƈ˗��c�̂������Ȃ�A�˗��c�̖��̂��N���A
'		If ( strKeyCslOrgCd1 = strArrCslOrgCd1(i) ) AND ( strKeyCslOrgCd2 = strArrCslOrgCd2(i)) and ( blnBreakMode = True ) Then
'			strDispCslOrgName = ""
'		Else
'			strKeyCslOrgCd1 = strArrCslOrgCd1(i)
'			strKeyCslOrgCd2 = strArrCslOrgCd2(i)
'		End If

		'NULL���z���̕ҏW
'		If strArrCsSubTotal(i) = "" Then strArrCsSubTotal(i) = 0
'		If strArrCsTax(i)      = "" Then strArrCsTax(i)      = 0
'		If strArrCsDiscount(i) = "" Then strArrCsDiscount(i) = 0
'		If strArrCsTotal(i)    = "" Then strArrCsTotal(i)    = 0

'		strDispCsSubTotal = ""
'		strDispCsTax = ""
'		strDispCsTotal = ""

'		If strArrCsSeq(i) <> "" Then
'			strDispCsSubTotal = FormatCurrency(strArrCsSubTotal(i))
'			strDispCsTax      = FormatCurrency(strArrCsTax(i))
'			strDispCsTotal    = FormatCurrency(strArrCsTotal(i))
'			strDispDiscount   = Iif(Clng(strArrCsDiscount(i)) = 0, "", FormatCurrency(strArrCsDiscount(i)))
'		End If

		'�R�[�X���̊֘A�ݒ�
'		strDispCsMark = "��"
'		strDispCsMarkColor = strArrWebColor(i)
'		strDispCsName = strArrCsName(i)
		
		'�R�[�XSEQ���Ȃ��ꍇ�A���̊֘A���N���A
'		If strArrCsSeq(i) = "" Then
'			strDispCsMark = ""
'			strDispCsMarkColor = "FFFFFF"
'			strDispCsName = ""
'		End If
		
		'�R�[�X���w��̏ꍇ�A���̐ݒ�ύX
'		If strArrCsSeq(i) <> "" And strDispCsName = "" Then
'			strDispCsMark = "��"
'			strDispCsMarkColor = "999999"
'			strDispCsName = "�R�[�X�w��Ȃ�"
'		End If


		'���v���z�p�̕ҏW
'		If blnBreakMode = True Then
'			lngBillSubTotal = lngBillSubTotal + strArrCsSubTotal(i)
'			lngBillTax      = lngBillTax      + strArrCsTax(i)
'			lngBillDiscount = lngBillDiscount + strArrCsDiscount(i)
'			lngBillTotal    = lngBillTotal    + strArrCsTotal(i)
'			strDispCloseDate     = ""
'			strDispOrgName       = ""
'			strDispBillClassName = ""
'		End If

	Next
%>
	</TABLE>
	<BR>
<%
		'�y�[�W���O�i�r�Q�[�^�̕ҏW
		If IsNumeric(strGetCount) Then
			lngGetCount = CLng(strGetCount)
%>
			<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?action=search&strYear=" & CStr(lngStrYear) & "&strMonth=" & CStr(lngStrMonth) & "&strDay=" & CStr(lngStrDay) & "&endYear=" & CStr(lngEndYear) & "&endMonth=" & CStr(lngEndMonth) & "&endDay=" & CStr(lngEndDay) & "&orgCd1=" & Server.URLEncode(strOrgCd1) & "&orgCd2=" & Server.URLEncode(strOrgCd2) & "&billNo=" & strBillNo & "&IsDispatch=" & strIsDispatch & "&IsPayment=" & strIsPayment & "&IsCancel=" & strIsCancel & "&SortName=" & strSortName & "&SortType=" & strSortType, lngAllCount, lngStartPos, lngGetCount) %>
<%
		End If
		Exit Do
	Loop

	'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̉��
	Set objDemand = Nothing
	Set objCommon = Nothing

%>
</div>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
