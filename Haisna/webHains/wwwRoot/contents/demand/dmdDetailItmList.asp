<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		���������ד��󌟍� (Ver0.0.1)
'		AUTHER  : T.Yaguchi@orbsys.co.jp
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
Dim strLineNo				'���ׂm��
Dim strItemNo				'����m��
Dim strPerId				'�lID
Dim strLastName				'��
Dim strFirstName			'��
Dim strCslDate				'��f��
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

'## 2004.06.02 ADD STR ORB)T.YAGUCHI �Q�������̍��v���z�ǉ��ǉ�
Dim strSumPrice				'���z���v
Dim strSumEditPrice			'�������z���v
Dim strSumTaxPrice			'�Ŋz���v
Dim strSumEditTax			'�����Ŋz���v
Dim strSumPriceTotal			'�����v
Dim lngSumRecord			'���R�[�h��
'## 2004.06.02 ADD END

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
Dim strArrItemNo			'����R�[�h
Dim strArrSecondLineDivCd		'�Q���������׃R�[�h
Dim strArrSecondLineDivName		'�Q���������ז�

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
strLineNo      = Request("lineNo")
strItemNo      = Request("itemNo")
strPerId       = Request("perId")
strLastName    = Request("lastName")
strFirstName   = Request("firstName")
strCslDate     = Request("cslDate")
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
<TITLE>��������{���</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̊��蓖��
Set objDemand = Server.CreateObject("HainsDemand.Demand")

'If strAction = "delete" Then
'	lngDelResult = objDemand.DeleteBill(strBillNo)
'	Select Case lngDelResult
'	Case 2
'		strArrMessage = Array("������������`�[�ɂ��܂����B")
'	Case 1
'		strArrMessage = Array("���������폜���܂����B")
'	Case 0
'		strArrMessage = Array("�Y�����鐿����������܂���B")
'	Case -1
'		strArrMessage = Array("�������̍폜�Ɏ��s���܂����B")
'	End Select
'End If

%>
<SCRIPT TYPE="text/javascript">
<!--
var dmdSendCheckDay_CalledFunction;		// ���M���C����Ăяo���֐�
var winSendCheckDay;					// ���M���C���E�B���h�E�n���h��


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
<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo%>">
<INPUT TYPE="hidden" NAME="lineNo" VALUE="<%= strLineNo%>">
<INPUT TYPE="hidden" NAME="itemNo" VALUE="<%= strItemNo%>">
<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId%>">
<INPUT TYPE="hidden" NAME="lastName" VALUE="<%= strLastName%>">
<INPUT TYPE="hidden" NAME="firstName" VALUE="<%= strFirstName%>">
<INPUT TYPE="hidden" NAME="cslDate" VALUE="<%= strCslDate%>">
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

	'�������擾
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
								strArrDelFlg)

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
	lngSumRecord = objDemand.SelectSumDetailItems(strBillNo,strLineNo, _
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
	<TR>
		<TD>�lID</TD>
		<TD>�F</TD>
		<TD><%= strPerId%></TD>
	</TR>
	<TR>
		<TD>����</TD>
		<TD>�F</TD>
		<TD><%= strLastName%>�@<%= strFirstName%></TD>
	</TR>
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
	strArrSecondLineDivCd = null
	strArrSecondLineDivName = null
	strArrItemNo = null

	'���������𖞂������R�[�h�������擾
	'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
	lngAllCount = objDemand.SelectDmdDetailItmList( _
											strBillNo, strLineNo, "", "", "")
	lngCount = objDemand.SelectDmdDetailItmList( _
											strBillNo, strLineNo, "", lngStartPos, strGetCount, _
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
											strArrEditTax,"","","","","","",strArrItemNo,strArrSecondLineDivCd,strArrSecondLineDivName)

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
				<FONT color="#ff6600"><B><%= CStr(lngAllCount) %></B></FONT>���̖��׏�񂪊܂܂�Ă��܂��B
			</TD>
		<%If vntArrPaymentCnt(0) = 0 And vntArrDispatchCnt(0) = 0 Then%>
			<TD COLSPAN=5 ALIGN="right">
			<A HREF="dmdEditDetailItemLine.asp?action=insert&BillNo=<%=strBillNo%>&getCount=<%=strGetCount%>&startpos=<%=lngStartPos%>&LineNo=<%=strLineNo%>&perId=<%=strPerId%>&lastName=<%=strLastName%>&firstName=<%=strFirstName%>&cslDate=<%=strCslDate%>">
			<IMG SRC="../../images/newrsv.gif" BORDER="0" HEIGHT="24" WIDTH="77" ALT="���������ד����ǉ�">
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
			<TD NOWRAP>�Q������</TD>
			<TD NOWRAP ALIGN="right">���v</TD>
			<TD NOWRAP ALIGN="right">���v</TD>
			<TD NOWRAP>����</TD>
		</TR>
<%
	'���ׂ̐��������[�v����
	For i = 0 To lngCount - 1
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
%>
		<%If i=0 Then%>
			<TR>
				<TD HEIGHT="1" COLSPAN="5" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" BORDER="0"></TD>
			</TR>
		<%End If%>
			<TR>
				<TD NOWRAP><%= strArrSecondLineDivName(i)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispPriceTotal)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispBillTotal)%></TD>
				<TD><A HREF="dmdEditDetailItemLine.asp?BillNo=<%=lngArrBillNo(i)%>&LineNo=<%=strArrLineNo(i)%>&ItemNo=<%=strArrItemNo(i)%>&getCount=<%=strGetCount%>&startpos=<%=lngStartPos%>&perId=<%=strPerId%>&lastName=<%=strLastName%>&firstName=<%=strFirstName%>&cslDate=<%=strCslDate%>">�C��</A></TD>
			</TR>
<!--
			<TR>
				<TD NOWRAP><%= strArrDetailName(i)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispPriceTotal)%></TD>
				<TD ALIGN="right"><%= FormatCurrency(strDispBillTotal)%></TD>
				<TD><A HREF="dmdEditDetailItemLine.asp?BillNo=<%=lngArrBillNo(i)%>&LineNo=<%=strArrLineNo(i)%>">�C��</A></TD>
			</TR>
-->
			<TR>
				<TD HEIGHT="1" COLSPAN="5" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
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
			<%= EditPageNavi(Request.ServerVariables("SCRIPT_NAME") & "?action=search&billNo=" & strBillNo & "&LineNo=" & strLineNo & "&oldGetCount=" & lngGetCount & "&perId=" & strPerId & "&lastName=" & strLastName & "&firstName=" & strFirstName & "&cslDate=" & strCslDate, lngAllCount, lngStartPos, lngGetCount) %>
<%
		End If
'### 2004/3/4 Updated by Ishihara@FSIT ���׌������O���̏ꍇ�A���̈ʒu�ł̓C���f�b�N�X�G���[�ŗ�����
%>
<BR>
<!--<A HREF="/webHains/contents/print/prtOrgBill.asp?mode=0&BillNo=<%= lngArrBillNo(0) %>"><IMG SRC="../../images/print.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="��������������܂�" ></A>-->
<%
		Exit Do
	Loop

	'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̉��
	Set objDemand = Nothing
%>
<%If strArrDelFlg(0) = "0" Then%>
<!--<A HREF="" onClick="return callDelete()"><IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���������폜���܂��B"></A>-->
<%End if%>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
<%
Set objCommon = Nothing
%>