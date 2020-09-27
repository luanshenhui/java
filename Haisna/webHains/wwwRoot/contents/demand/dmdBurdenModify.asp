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
Dim strBillNo				'�������m��
Dim lngStartPos				'�\���J�n�ʒu

'COM�I�u�W�F�N�g
Dim objCommon				'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objDemand				'�����A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objOrganization			'�c�̃A�N�Z�X�pCOM�I�u�W�F�N�g

'���������ǂݍ���
Dim lngAllCount				'�����𖞂����S���R�[�h����
Dim strPageMaxLine			'�P�y�[�W�\���s��
Dim lngGetCount				'�P�y�[�W�\������
Dim lngCount				'�����ł�������
Dim lngCount2				'�����ł�������
Dim lngArrBillNo			'�������m��
Dim strArrCloseDate			'���ߓ��i"yyyy/m/d"�ҏW�j
Dim strArrBillSeq			'������Seq
Dim strArrBranchno			'�������}��
Dim strArrOrgCd1			'�c�̃R�[�h1
Dim strArrOrgCd2			'�c�̃R�[�h2
Dim strArrOrgName			'�c�̖�
Dim strArrOrgKName			'�c�̃J�i��
Dim strArrPrtDate			'�������o�͓�
Dim lngArrSumPriceTotal		'���v
Dim lngArrSumTaxTotal		'�Ŋz���v
Dim strArrSeq				'Seq
Dim strArrDispatchDate		'�������t
Dim strArrUpdUser			'�X�V��
Dim strArrUserName			'���[�U��
Dim strArrUpdDate			'�X�V��
Dim strArrDelFlg			'����`�[�t���O
'### 2004/11/10 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ�
Dim strArrBillComment		'�������R�����g
'### 2004/11/10 Add End

Dim strArrLineNo			'����No
Dim strArrCslDate			'��f��
Dim strArrDayId				'����ID
Dim strArrRsvNo				'�\��ԍ�
Dim strArrDetailName		'���ז�
Dim strArrPerId				'�lID
Dim strArrLastName			'��
Dim strArrFirstName			'��
Dim strArrLastKName			'�J�i��
Dim strArrFirstKName		'�J�i��
Dim strArrPrice				'���z
Dim strArrEditPrice			'�������z
Dim strArrTaxPrice			'�Ŋz
Dim strArrEditTax			'�����Ŋz
Dim strArrMethod			'�쐬���@
'2004.06.02 ADD STR ORB)T.YAGUCHI
Dim strArrSecondFlg			'�Q�������t���O
Dim strSumPrice				'���z���v
Dim strSumEditPrice			'�������z���v
Dim strSumTaxPrice			'�Ŋz���v
Dim strSumEditTax			'�����Ŋz���v
Dim strSumPriceTotal			'�����v
Dim lngSumRecord			'���R�[�h��
'## 2004.06.02 ADD END

Dim vntArrPaymentCnt		'��������
Dim vntArrDispatchCnt		'��������
Dim strGetCount				'�P�y�[�W�\������
Dim strOldGetCount			'�P�y�[�W�\�������i�ύX�O�j
Dim lngDelResult 			'�������폜����

'��ʕ\���p�ҏW�̈�
Dim strDispCloseDate		'�ҏW�p�̒��ߓ��i"yyyy/m/d"�ҏW�j
Dim strDispBillNo			'�������ԍ�
Dim strDispOrgName			'�ҏW�p�̕��S���c�̖�
Dim strDispOrgKName

Dim strDispDiscount			'�ҏW�p�̒l����
Dim strDispCsSubTotal
Dim strDispCsTax
Dim strDispCsTotal


Dim strDispCslDate			'��f��
Dim strDispDayId			'����ID
Dim strDispRsvNo			'�\��ԍ�
Dim strDispPerId			'�lID
Dim strDispLastName			'��
Dim strDispFirstName		'��
Dim strDispLastKName		'�J�i��
Dim strDispFirstKName		'�J�i��

Dim strDispBillTotal		'�������z
Dim strDispTaxTotal			'�����
Dim strDispPrice			'���v
Dim strDispPriceTotal		'�����z

'�O���[�v�C���f���g�����p
Dim strWCslDate
Dim strWDayId
Dim strWRsvNo
Dim strWPerId

'���̓`�F�b�N
Dim strArrMessage		'�G���[���b�Z�[�W

'�C���f�b�N�X
Dim i

Dim dtmDate				'��f���f�t�H���g�l�v�Z�p�̓��t
Dim strBranchno			'�������}�ԁi�폜�{�^���̕\������j

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strAction      = Request("action") & ""
strBillNo      = Request("billNo")
lngStartPos    = CLng("0" & Request("startPos"))
lngStartPos    = IIf(lngStartPos = 0, 1, lngStartPos)
strGetCount    = Request("getCount")
strOldGetCount = Request("oldGetCount")

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

If strOldGetCount = "" Then
'	strOldGetCount = strPageMaxLine
	strOldGetCount = strGetCount
End If

If strOldGetCount <> "" And strOldGetCount <> strGetCount Then
	lngStartPos = 1
End If
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
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��������{���</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̊��蓖��
Set objDemand = Server.CreateObject("HainsDemand.Demand")

If strAction = "delete" Then
	lngDelResult = objDemand.DeleteBill(strBillNo)
	Select Case lngDelResult
	Case 2
		strArrMessage = Array("������������`�[�ɂ��܂����B")
	Case 1
		strArrMessage = Array("���������폜���܂����B")
	Case 0
		strArrMessage = Array("�Y�����鐿����������܂���B")
	Case -1
		strArrMessage = Array("�������̍폜�Ɏ��s���܂����B")
	End Select
End If

%>
<SCRIPT TYPE="text/javascript">
<!--
var dmdSendCheckDay_CalledFunction;		// ���M���C����Ăяo���֐�
var winSendCheckDay;					// ���M���C���E�B���h�E�n���h��

//'2004.05.24 ADD STR Orb)T.Yaguchi
var winDmdDetailItmList;				// �������ד�����E�B���h�E�n���h��
var flgDmdDetailItmList;				// �������ד�����Ăяo���t���O
//'2004.05.24 ADD END

// ### 2004/11/10 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ�
var winComment;			// �R�����g���̓E�B���h�E�n���h��
// ### 2004/11/10 Add End

// ��������{���Ăяo��
function callSendCheckDay( billNo, seq ) {
	var opened = false;

	dmdSendCheckDay_CalledFunction = loadBurdenModify;

	// ���łɐ�������{��񂪊J����Ă��邩�`�F�b�N
	if ( winSendCheckDay != null ) {
		if ( !winSendCheckDay.closed ) {
			opened = true;
		}
	}

	if ( opened ) {
		winSendCheckDay.location.replace("dmdSendCheckDay.asp?billNo=" + billNo);
		winSendCheckDay.focus();
	} else {
		winSendCheckDay = window.open("dmdSendCheckDay.asp?billNo=" + billNo + "&seq=" + seq + "&mode=update","","toolbar=no,directories=no,menubar=no,resizable=yes,scrollbars=yes,width=700,height=400");
//		winSendCheckDay = window.open("dmdSendCheckDay.asp?billNo=" + billNo,"","");
	}

	return false;
}

function closeSendCheckDay(){
	if ( winSendCheckDay != null ) {
		if ( !winSendCheckDay.closed ) {
			winSendCheckDay.close();
		}
	}
	// ### 2004/11/10 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ�
	// �R�����g���̓E�C���h�E�����
	if ( winComment != null ) {
		if ( !winComment.closed ) {
			winComment.close();
		}
	}
	winComment = null;
	// ### 2004/11/10 Add End
}

// �������폜
function callDelete(){
	var rtn = false;

	rtn = confirm("���̐��������폜���Ă���낵���ł����H")

	if(rtn == true){
		document.entryCondition.action.value = "delete";
		document.entryCondition.submit();
	}

	return false;
}

function loadBurdenModify() {
	location.reload();
}

//'2004.05.24 ADD STR Orb)T.Yaguchi
// ��������{���Ăяo��
function callDmdDetailItmList( billNo, lineNo, perId, lastName, firstName, cslDate) {

	var opened = false;
	flgDmdDetailItmList = true;

//	dmdBurdenModify_CalledFunction = loadBurdenList;

	// ���łɐ������C�����J����Ă��邩�`�F�b�N
	if ( winDmdDetailItmList != null ) {
		if ( !winDmdDetailItmList.closed ) {
			opened = true;
		}
	}

	if ( opened ) {
		winDmdDetailItmList.location.replace("dmdDetailItmList.asp?billNo=" + billNo + "&lineNo=" + lineNo + "&perId=" + perId + "&lastName=" + lastName + "&firstName=" + firstName + "&cslDate=" + cslDate);
		winDmdDetailItmList.focus();
	} else {
		winDmdDetailItmList = window.open("dmdDetailItmList.asp?BillNo=" + billNo + "&LineNo=" + lineNo + "&perId=" + perId + "&lastName=" + lastName + "&firstName=" + firstName + "&cslDate=" + cslDate);
	}
	
	return false;
}
//'2004.05.24 ADD END

// ### 2004/11/10 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ�
function showCommentWindow( billNo ) {

	var objForm = document.entryCondition;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winComment != null ) {
		if ( !winComment.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/demand/dmdBillComment.asp'
	url = url + '?billNo=' + billNo;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winComment.focus();
		winComment.location.replace(url);
	} else {
		winComment = window.open( url, '', 'width=500,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}
// ### 2004/11/10 Add End

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:closeSendCheckDay()">
<!--<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">-->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="action" VALUE="search">
<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= CStr(lngStartPos) %>">
<INPUT TYPE="hidden" NAME="getCoutn" VALUE="<%=strGetCount%>">
<INPUT TYPE="hidden" NAME="BillNo" VALUE="<%= strBillNo%>">
<INPUT TYPE="hidden" NAME="oldGetCount" VALUE="<%= strOldGetCount%>">

<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">��������{���</FONT></B></TD>
	</TR>
</TABLE>
<%
If strAction = "delete" Then
	If lngDelResult < 0 Then
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	Else
		Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)
	End If
%>
<BR>
<BR>
<A HREF = "" onClick="window.close(); return false;"><IMG SRC="/webHains/images/back.gif" BORDER=0></A>
<%
	Response.End
End If

' ### 2004/11/11 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ�
	'�������擾
'	lngCount = objDemand.SelectDmdBurdenDispatch( _
'								strBillNo, "", "", _
'								lngArrBillNo, _
'								strArrCloseDate, _
'								strArrBillSeq, _
'								strArrBranchno, _
'								strArrOrgCd1, _
'								strArrOrgCd2, _
'								strArrOrgName, _
'								strArrOrgKName, _
'								strArrPrtDate, _
'								lngArrSumPriceTotal, _
'								lngArrSumTaxTotal, _
'								strArrSeq, _
'								strArrDispatchDate, _
'								strArrUpdUser, _
'								strArrUserName, _
'								strArrUpdDate, _
'								strArrDelFlg)

	lngCount = objDemand.SelectDmdBurdenDispatch( _
								strBillNo, "", "", _
								lngArrBillNo, _
								strArrCloseDate, _
								strArrBillSeq, _
								strArrBranchno, _
								strArrOrgCd1, _
								strArrOrgCd2, _
								strArrOrgName, _
								strArrOrgKName, _
								strArrPrtDate, _
								lngArrSumPriceTotal, _
								lngArrSumTaxTotal, _
								strArrSeq, _
								strArrDispatchDate, _
								strArrUpdUser, _
								strArrUserName, _
								strArrUpdDate, _
								strArrDelFlg, _
								strArrBillComment)
// ### 2004/11/11 Add End

	If lngCount = 0 Then
		strArrMessage = Array("�Y�����鐿����������܂���")
	Else
		strBranchno = strArrBranchno(0)
	End If

	'���b�Z�[�W�̕ҏW
	Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
	If lngCount = 0 Then
		Response.End
	End If

Do
	If Not IsEmpty(strArrMessage) Then Exit Do

	'�\���p�ɕҏW
	If lngArrSumPriceTotal(0) <> "" Then
		strDispBillTotal = lngArrSumPriceTotal(0)
		If lngArrSumTaxTotal(0) <> "" Then
			strDispBillTotal = CDbl(strDispBillTotal) + CDbl(lngArrSumTaxTotal(0))
			strDispTaxTotal = FormatCurrency(lngArrSumTaxTotal(0))
		End If
		strDispBillTotal = FormatCurrency(strDispBillTotal)
	End If
'## 2004.06.02 ADD STR ORB)T.YAGUCHI �Q�������̍��v���z�ǉ��ǉ�
	lngSumRecord = objDemand.SelectSumDetailItems(strBillNo,, _
							strSumPrice, _
							strSumEditPrice, _
							strSumTaxPrice, _
							strSumEditTax, _
							strSumPriceTotal)
	'�Q���������v���z�̒ǉ�
	If lngSumRecord > 0 Then
		strDispBillTotal = CDbl(strDispBillTotal) + strSumPriceTotal(0)
		strDispTaxTotal = CDbl(strDispTaxTotal) + strSumTaxPrice(0) + strSumEditTax(0)
		strDispBillTotal = FormatCurrency(strDispBillTotal)
		strDispTaxTotal = FormatCurrency(strDispTaxTotal)
	End If
'## 2004.06.02 ADD END

'### 2004/3/27 Deleted by Ishihara@FSIT�ߋ��f�[�^�����H�������ꍇ�����邽�߁A����
''### 2004/3/8 Added by Ishihara@FSIT ���ߓ����ߋ����̏ꍇ�i�܂�ڍs�f�[�^�j��������i�폜���������Ȃ����߁j
'	If strArrCloseDate(0) < "2004/01/01" Then
'		strArrDelFlg(0) = "1"
'	End If
'### 2004/3/27 Deleted End

%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD>�������ԍ�</TD>
		<TD>�F</TD>
		<TD><%= lngArrBillNo(0)%></TD>
	</TR>
	<TR>
		<TD>������c��</TD>
		<TD>�F</TD>
		<TD><%= strArrOrgName(0)%></TD>
	</TR>
	<TR>
		<TD>���ߓ�</TD>
		<TD>�F</TD>
		<TD><%= strArrCloseDate(0)%></TD>
	</TR>
	<TR>
		<TD>�������o�͓�</TD>
		<TD>�F</TD>
		<TD><%= strArrPrtDate(0)%></TD>
	</TR>
	<TR>
		<TD>�������z</TD>
		<TD>�F</TD>
		<TD><%= strDispBillTotal%>�@�i�� ����� <%=strDispTaxTotal%>�j</TD>
	</TR>
<!-- ### 2004/11/10 Add by Gouda@FSIT �c�̐����R�����g�̒ǉ� -->
		<TR>
			<TD NOWRAP >�������R�����g</TD>
			<TD >�F</TD>
			<TD >
			<TABLE>
				<TR>
					<TD><A HREF="JavaScript:showCommentWindow('<%=lngArrBillNo(i)%>');"><IMG SRC="../../images/question.gif" ALT="�������R�����g����" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD width= "357"><%= strArrBillComment(0) %></TD>
				</TR>
			</TABLE>
			</TD>
		</TR>
<!-- ### 2004/11/10 Add ENd -->
<%
	For i = 0 to lngCount -1
%>
	<TR>
<%
		If i = 0 Then
%>
		<TD>������������</TD>
<%
		Else
%>
		<TD></TD>
<%
		End If
%>
		<TD>�F</TD>
		<TD>
<%
		If strArrDispatchDate(i) <> "" Then
%>
			<TABLE>
				<TR>
					<TD>
						<%If strArrDelFlg(i) = "1" And strArrBranchno(i) = "0"Then%>
						<%Else%>
						<A HREF="" onClick="return callSendCheckDay('<%= lngArrBillNo(i)%>','<%=strArrSeq(i)%>');">
							<IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="��������������ύX" BORDER=0>
						</A>
						<%End If%>
					</TD>
					<TD><%= strArrDispatchDate(i)%></TD>
					<TD WIDTH=50>
					<TD>�X�V�ҁF</TD>
					<TD><%= strArrUserName(i)%></TD>
					<TD WIDTH=50></TD>
					<TD>�X�V���F</TD>
					<TD><%= strArrUpdDate(i)%></TD>
				</TR>
			</TABLE>
		</TD>
<%
		Else
%>
		<TD></TD>
<%
		End If
%>
	</TR>
<%
	Next
%>
</TABLE>
<%
	Exit Do
Loop

Do
	'��������������Ă���ꍇ�͉������Ȃ�
	If Not IsEmpty(strArrMessage) Then Exit Do

	lngArrBillNo = null
	strArrLineNo = null
	strArrCloseDate = null
	strArrBillSeq = null
	strArrBranchno = null
	strArrRsvNo = null
	strArrCslDate = null
	strArrDetailName = null
	strArrPerId = null
	strArrLastName = null
	strArrFirstName = null
	strArrLastKName = null
	strArrFirstKName = null
	strArrPrice = null
	strArrEditPrice = null
	strArrTaxPrice = null
	strArrEditTax = null
	'���������𖞂������R�[�h�������擾
	'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
	lngAllCount = objDemand.SelectDmdBurdenBillDetail( _
											strBillNo, "", "", "")
'2004.06.02 MOD STR ORB)T.YAGUCHI
'	lngCount = objDemand.SelectDmdBurdenBillDetail( _
'											strBillNo, "", lngStartPos, strGetCount, _
'											lngArrBillNo, _
'											strArrLineNo, _
'											strArrCloseDate, _
'											strArrBillSeq, _
'											strArrBranchno, _
'											strArrDayId, _
'											strArrRsvNo, _
'											strArrCslDate, _
'											strArrDetailName, _
'											strArrPerId, _
'											strArrLastName, _
'											strArrFirstName, _
'											strArrLastKName, _
'											strArrFirstKName, _
'											strArrPrice, _
'											strArrEditPrice, _
'											strArrTaxPrice, _
'											strArrEditTax,"","")
	lngCount = objDemand.SelectDmdBurdenBillDetail( _
											strBillNo, "", lngStartPos, strGetCount, _
											lngArrBillNo, _
											strArrLineNo, _
											strArrCloseDate, _
											strArrBillSeq, _
											strArrBranchno, _
											strArrDayId, _
											strArrRsvNo, _
											strArrCslDate, _
											strArrDetailName, _
											strArrPerId, _
											strArrLastName, _
											strArrFirstName, _
											strArrLastKName, _
											strArrFirstKName, _
											strArrPrice, _
											strArrEditPrice, _
											strArrTaxPrice, _
											strArrEditTax,"","",, _
											strArrSecondFlg)
'2004.06.02 MOD END

	'�����ς݁A�����ς݃`�F�b�N
	lngCount2 = objDemand.SelectPaymentAndDispatchCnt(strBillNo, _
													vntArrPaymentCnt, _
													vntArrDispatchCnt)

	'���R�[�h��������ҏW
%>
<BR>
<!--�����͌�����������-->

	<TABLE BORDER="0" CELLSPACING="4" CELLPADDING="0">
		<TR>
			<TD NOWRAP COLSPAN=4>
				<SPAN STYLE="font-size:9pt;">
				<FONT color="#ff6600"><B><%= CStr(lngAllCount) %></B></FONT>���̖��׏�񂪊܂܂�Ă��܂��B
				</SPAN>
			</TD>
		<%If vntArrPaymentCnt(0) = 0 And vntArrDispatchCnt(0) = 0 Then%>
			<TD COLSPAN=5 ALIGN="right">
			<A HREF="dmdEditBillLine.asp?action=insert&BillNo=<%=strBillNo%>&getCount=<%=strGetCount%>&startpos=<%=lngStartPos%>">
			<IMG SRC="../../images/newrsv.gif" BORDER="0" HEIGHT="24" WIDTH="77" ALT="���������ׂ�ǉ�">
			</A>
			</TD>
		<%End If%>
		</TR>
		<TR>
			<TD COLSPAN=7 ALIGN=RIGHT><TD>
				<%= EditDailyPageMaxLineList("getCount", strGetCount) %>
			</TD>
			<TD>
				<A HREF="" onClick="javascript:document.entryCondition.submit();return false;">
					<img src="../../images/b_prev.gif" BORDER="0" >
				</A>
			</TD>
		</TR>
		<TR>
			<TD><BR></TD>
		</TR>
<%
	'�������ʂ����݂��Ȃ��ꍇ�͉������Ȃ�
	If lngCount = 0 Then
%>
	</TABLE>
<%
		Exit Do
	End If

	'�������ꗗ�̕ҏW�J�n
%>
		<TR BGCOLOR="#eeeeee">
			<TD NOWRAP>��f��</TD>
			<TD NOWRAP>����ID</TD>
			<TD NOWRAP>�\��ԍ�</TD>
			<TD NOWRAP>�lID</TD>
			<TD NOWRAP>����</TD>
			<TD NOWRAP>��f�R�[�X</TD>
			<TD NOWRAP ALIGN="right">���v</TD>
			<TD NOWRAP ALIGN="right">���v</TD>
			<TD NOWRAP>����</TD>
<% '2004.05.24 ADD STR Orb)T.Yaguchi %>
			<TD NOWRAP>�Q������</TD>
<% '2004.05.24 ADD END %>
		</TR>
<%
	'���ׂ̐��������[�v����
	For i = 0 To lngCount - 1
'		If i=0 Then
'			strWCslDate = strArrCslDate(i)
'			strWDayId = strArrDayId(i)
'			strWRsvNo = strArrRsvNo(i)
'			strWPerId = strArrPerId(i)
'		End If

'## 2004.06.02 ADD STR ORB)T.YAGUCHI �Q�������̍��v���z�ǉ��ǉ�
		lngSumRecord = objDemand.SelectSumDetailItems(strBillNo,strArrLineNo(i), _
								strSumPrice, _
								strSumEditPrice, _
								strSumTaxPrice, _
								strSumEditTax, _
								strSumPriceTotal)

'## 2004.06.02 ADD END

		'�\���p�ɕҏW
		If strArrPrice(i) <> "" Then
			If strArrEditPrice(i) <> "" Then
				strDispPriceTotal = CDbl(strArrPrice(i)) + CDbl(strArrEditPrice(i))
			Else
				strDispPriceTotal = strArrPrice(i)
			End If
		Else
			strDispPriceTotal = ""
		End If
		If strArrTaxPrice(i) <> "" Then
			If strArrEditTax(i) <> "" Then
				strDispBillTotal = CDbl(strDispPriceTotal) + CDbl(strArrTaxPrice(i)) + CDbl(strArrEditTax(i))
			Else
				strDispBillTotal = CDbl(strDispPriceTotal) + CDbl(strArrTaxPrice(i))
			End If
		Else
			strDispBillTotal = strDispPriceTotal
		End If

'## 2004.06.02 ADD STR ORB)T.YAGUCHI �Q�������̍��v���z�ǉ��ǉ�
		'�Q���������v���z�̒ǉ�
		If lngSumRecord > 0 Then
			strDispBillTotal = CDbl(strDispBillTotal) + strSumPriceTotal(0)
			strDispPriceTotal = CDbl(strDispPriceTotal) + strSumPrice(0) + strArrEditPrice(0)
		End If
'## 2004.06.02 ADD END

		'�O���[�v�C���f���g����
		If strWCslDate = strArrCslDate(i) And _
		   strWDayId = strArrDayId(i) And _
		   strWRsvNo = strArrRsvNo(i) And _
		   strWPerId = strArrPerId(i) Then
			strDispCslDate = ""
			strDispDayId = ""
			strDispRsvNo = ""
			strDispPerId = ""
			strDispLastName = ""
			strDispFirstName = ""
			strDispLastName = ""
			strDispLastKName = ""
			strDispFirstKName = ""
		Else
			strWCslDate = strArrCslDate(i)
			strWDayId = strArrDayId(i)
			strWRsvNo = strArrRsvNo(i)
			strWPerId = strArrPerId(i)
			strDispCslDate = strArrCslDate(i)
			strDispDayId = strArrDayId(i)
			strDispRsvNo = strArrRsvNo(i)
			strDispPerId = strArrPerId(i)
			strDispLastName = strArrLastName(i)
			strDispFirstName = strArrFirstName(i)
			strDispLastName = strArrLastName(i)
			strDispLastKName = strArrLastKName(i)
			strDispFirstKName = strArrFirstKName(i)
		End If
%>
		<%If i=0 Then%>
			<TR>
<% '2004.05.24 MOD STR Orb)T.Yaguchi %>
<!--				<TD HEIGHT="1" COLSPAN="9" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>-->
				<TD HEIGHT="1" COLSPAN="10" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>
<% '2004.05.24 MOD END %>
			</TR>
		<%End If%>
			<TR>
				<TD NOWRAP><%= strDispCslDate%></TD>
				<TD NOWRAP ALIGN=RIGHT><%= strDispDayId%></TD>
				<TD NOWRAP ALIGN=RIGHT><A HREF="/webhains/contents/perbill/perPaymentInfo.asp?rsvno=<%=strArrRsvNo(i)%>"><%= strDispRsvNo%></A></TD>
				<TD NOWRAP><%= strDispPerId%></TD>
				<TD NOWRAP>
					<SPAN STYLE="font-size:9px;">
						<B><%= strDispLastKName%>�@<%= strDispFirstKName%></B><BR>
					</SPAN>
					<%= strDispLastName%>�@<%= strDispFirstName%>
				</TD>
				<TD NOWRAP><%= strArrDetailName(i)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispPriceTotal)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispBillTotal)%></TD>
				<TD><A HREF="dmdEditBillLine.asp?BillNo=<%=lngArrBillNo(i)%>&LineNo=<%=strArrLineNo(i)%>&getCount=<%=strGetCount%>&startpos=<%=lngStartPos%>">�C��</A></TD>
<% '2004.05.24 ADD STR Orb)T.Yaguchi %>
				<!--<TD><A HREF="dmdDetailItmList.asp?BillNo=<%=lngArrBillNo(i)%>&LineNo=<%=strArrLineNo(i)%>&getCount=<%=strGetCount%>&startpos=<%=lngStartPos%>">�Q������</A></TD>-->
				<% If strArrSecondFlg(i) = "1" Then %>
					<TD><A HREF="" onClick="return callDmdDetailItmList('<%=lngArrBillNo(i)%>','<%=strArrLineNo(i)%>','<%=strArrPerId(i)%>','<%=strArrLastName(i)%>','<%=strArrFirstName(i)%>','<%=strArrCslDate(i)%>');">�Q������</A></TD>
				<% Else %>
					<TD></TD>
				<% End If %>
<% '2004.05.24 ADD END %>
			</TR>
<!--
			<TR>
				<TD NOWRAP><%= strArrCslDate(i)%></TD>
				<TD NOWRAP ALIGN=RIGHT><%= strArrDayId(i)%></TD>
				<TD NOWRAP><A HREF="/webhains/contents/perbill/perPaymentInfo.asp?rsvno=<%=strArrRsvNo(i)%>"><%= strArrRsvNo(i)%></A></TD>
				<TD NOWRAP><%= strArrPerId(i)%></TD>
				<TD NOWRAP>
					<SPAN STYLE="font-size:9px;">
						<B><%= strArrLastKName(i)%>�@<%= strArrFirstKName(i)%></B><BR>
					</SPAN>
					<%= strArrLastName(i)%>�@<%= strArrFirstName(i)%>
				</TD>
				<TD NOWRAP><%= strArrDetailName(i)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispPriceTotal)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispBillTotal)%></TD>
				<TD><A HREF="dmdEditBillLine.asp?BillNo=<%=lngArrBillNo(i)%>&LineNo=<%=strArrLineNo(i)%>">�C��</A></TD>
			</TR>
-->
			<TR>
				<TD HEIGHT="1" COLSPAN="20" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
			</TR>
<%
	Next
%>
	</TABLE>
	<BR>
<%
		'�y�[�W���O�i�r�Q�[�^�̕ҏW
'		If IsNumeric(strPageMaxLine) Then
'			lngGetCount = CLng(strPageMaxLine)
		If IsNumeric(strGetCount) Then
			lngGetCount = CLng(strGetCount)
%>
			<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?action=search&billNo=" & strBillNo & "&oldGetCount=" & lngGetCount, lngAllCount, lngStartPos, lngGetCount) %>
<%
		End If
'### 2004/3/4 Updated by Ishihara@FSIT ���׌������O���̏ꍇ�A���̈ʒu�ł̓C���f�b�N�X�G���[�ŗ�����
%>
<BR>
<A HREF="/webHains/contents/print/prtOrgBill.asp?mode=0&BillNo=<%= lngArrBillNo(0) %>"><IMG SRC="../../images/print.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="��������������܂�" ></A>
<%
		Exit Do
	Loop

	'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̉��
	Set objDemand = Nothing
%>
<%If strArrDelFlg(0) = "0" Then%>

	<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
	<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
		<A HREF="" onClick="return callDelete()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���������폜���܂��B"></A>
	<%  else    %>
		 &nbsp;
	<%  end if  %>
	<% '2005.08.22 �����Ǘ� Add by ��  ---- END %>

<%End if%>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
<%
Set objCommon = Nothing
%>