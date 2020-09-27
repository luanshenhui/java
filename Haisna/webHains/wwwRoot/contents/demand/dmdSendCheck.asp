<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�����������m�F���ݒ菈�� (Ver0.0.1)
'		AUTHER  : C's
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�����������m�F</TITLE>

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�����l
Dim strAction			'������ԁisubmit)
Dim strMode				'�������[�h("update":�㏑�� "insert":�ǉ� "cancel":�L�����Z��)
Dim lngSendYear			'������(�N)
Dim lngSendMonth		'������(��)
Dim lngSendDay			'������(��)
Dim strBillNo			'�������ԍ�
Dim strUpdUser			'�X�V��

Dim lngCloseYear		'���ߓ��i�N�j
Dim lngCloseMonth		'���ߓ��i���j
Dim lngCloseDay			'���ߓ��i���j
Dim strCloseDate		'���ߓ�
Dim lngBillSeq			'������Seq
Dim lngBranchNo			'�������}��
Dim lngSeq				'����Seq
Dim strDispatchDate		'������
Dim strRet				'�߂�l

Dim flgConfirm			'�����I�����b�Z�[�W�\���t���O �i1:�\������j
Dim lngMax				'����Seq�̍ő�l
Dim lngDelFlg			'�폜�t���O
Dim lngTotal				'�������z
Dim lngNotPayment			'�������z
Dim strOrgName				'���S���c�̖�
Dim strOrgKName				'���S���c�̖�
Dim strDispTotal

'COM�I�u�W�F�N�g
Dim objDemand			'�������A�N�Z�X�pCOM�I�u�W�F�N�g

'���̓`�F�b�N
Dim strArrMessage		'�G���[���b�Z�[�W

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strAction    = Request("action") & ""
strMode      = Request("mode") & ""
strBillNo    = Request("billNo") & ""
lngSendYear  = CLng("0" & Request("sendYear"))
lngSendMonth = CLng("0" & Request("sendMonth"))
lngSendDay   = CLng("0" & Request("sendDay"))
strUpdUser   = Session("userid")

'�����ݒ�
strArrMessage = Empty
flgConfirm = 0
strDispTotal = Empty

'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̊��蓖��
Set objDemand        = Server.CreateObject("HainsDemand.Demand")

'�����̐���
Do

	'�p�����^�`�F�b�N�i�������j
	strArrMessage = objDemand.CheckValueSendCheckDay(lngSendYear, lngSendMonth, lngSendDay, strDispatchDate)
	
	'�G���[���͉������Ȃ�
	If Not IsEmpty(strArrMessage) Then
		strBillNo = ""
		Exit Do
	End If

	If strAction = "submit" Then
		If strBillNo = "" Then
			strArrMessage = Array("�������ԍ����w�肵�Ă�������")
			Exit Do
		End If

		' Request ���琿�����L�[
		If Len(strBillNo) <> 14 Then
			strArrMessage = Array("�������ԍ����s���ł�")
			strBillNo = ""
			Exit Do
		Else 
			If Not IsNumeric(strBillNo) Then
				strArrMessage = Array("�������ԍ����s���ł�")
				strBillNo = ""
				Exit Do
			End If
		End If

		lngCloseYear  = CLng("0" & Mid(strBillNo, 1, 4))
		lngCloseMonth = CLng("0" & Mid(strBillNo, 5, 2))
		lngCloseDay   = CLng("0" & Mid(strBillNo, 7, 2))
		lngBillSeq    = CLng("0" & Mid(strBillNo, 9, 5))
		lngBranchNo   = CLng("0" & Mid(strBillNo, 14, 1))

		strCloseDate = lngCloseYear & "/" & lngCloseMonth & "/" & lngCloseDay
		If Not IsDate(strCloseDate) Then	
			strArrMessage = Array("�������ԍ����s���ł�")
			strBillNo = ""
			Exit Do
		End If
		strCloseDate = CDate(strCloseDate)

		If Not objDemand.GetDispatchSeqMax(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngMax, _
											lngDelFlg ) Then
			strArrMessage = Array("�������̎擾�Ɏ��s���܂���")
			strBillNo = ""
			Exit Do
		End If

		'�������`�[�͔������Ȃ�
		If CLng(lngDelFlg) = 1 Then
			strArrMessage = Array("����`�[�͔����ł��܂���")
			Exit Do
		End If

		If strCloseDate > strDispatchDate Then 
			strArrMessage = Array("�������͒��ߓ��ȍ~�̓��t����͂��Ă��������B")
			Exit Do
		End If

		'���łɔ����f�[�^�����݂��邩
		'���݂���Ȃ�㏑�����ǉ����I��������
		'���݂��Ȃ���Βǉ�
		If strMode = "" Then
			If lngMax = 0 Then
				strMode = "insert"
			Else 
				'�I���{�^���\��
				flgConfirm = 1
				Exit Do
			End If

		End If

		'�L�����Z���͉������Ȃ�(�������ԍ��e�L�X�g�{�b�N�X�N���A����H)
		If strMode = "cancel" Then
			strBillNo = ""
			Exit Do

		'��ʑJ�ڒ��ɑS���폜����Ă��܂�����������Ȃ��̂�
		ElseIf strMode = "update" and lngMax <> 0 Then

			' �X�V���� ���̉�ʂł� MAX(SEQ) ���X�V����
			If Not objDemand.UpdateDispatch(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngMax, _
											strDispatchDate, _
											strUpdUser, lngMax ) Then
				strArrMessage = Array("�������͍X�V�ł��܂���ł���")
				strBillNo = ""
				Exit Do
			End If

		Else 

			' �ǉ�����
			strRet = objDemand.InsertDispatch(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											strDispatchDate, _
											strUpdUser )
			'�L�[�d�����̓G���[���b�Z�[�W��ҏW����
			If strRet = INSERT_DUPLICATE Then
				strArrMessage = Array("��������̔�����񂪂��łɑ��݂��܂��B")
				strBillNo = ""
				Exit Do
			End If

		End If

		'�����������b�Z�[�W�\��
		'���������擾����
		If Not objDemand.SelectDmdPaymentBillSum(lngCloseYear, _
												lngCloseMonth, _
												lngCloseDay, _
												strCloseDate, _
												lngBillSeq, _
												lngBranchNo, _
												lngDelFlg, _
												strOrgName, _
												lngTotal, _
												lngNotPayment, _
												strOrgKName ) Then
			strArrMessage = Array("�������ԍ����s���ł�")
			strBillNo = ""
			Exit Do
		End If

		strDispTotal = FormatCurrency(lngTotal)

		strAction = "submitend"

	End If
	Exit Do
Loop

'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̉��
Set objDemand = Nothing

%>


<SCRIPT TYPE="text/javascript">
<!--

function setFocus() {

	if ( document.entryForm.confirm.value != 1 ) {
		document.entryForm.billNo.focus();
		document.entryForm.billNo.value = '';

//	} else {
//		document.entryForm.billNo.blur();
	}
	return false;
}

function callDispatchCancel() {

	document.entryForm.mode.value ='cancel';
	document.entryForm.action.value = 'submit';
	document.entryForm.submit();
	return false;

}
function callDispatchUpdate() {

	document.entryForm.mode.value ='update';
	document.entryForm.action.value = 'submit';
	document.entryForm.submit();
	return false;

}
function callDispatchInsert() {

	document.entryForm.mode.value ='insert';
	document.entryForm.action.value = 'submit';
	document.entryForm.submit();
	return false;

}
function submitDispatch() {

	document.entryForm.action.value = 'submit';

}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONLOAD="JavaScript:setFocus();">

<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get" ONSUBMIT="JavaScript:submitDispatch()">
<INPUT TYPE="hidden" NAME="action" VALUE="">
<INPUT TYPE="hidden" NAME="mode" VALUE="">
<INPUT TYPE="hidden" NAME="sendYear" VALUE="<%= lngSendYear %>">
<INPUT TYPE="hidden" NAME="sendMonth" VALUE="<%= lngSendMonth %>">
<INPUT TYPE="hidden" NAME="sendDay" VALUE="<%= lngSendDay %>">
<INPUT TYPE="hidden" NAME="confirm" VALUE="<%= flgConfirm %>">
<BLOCKQUOTE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�����������m�F</FONT></B></TD>
	</TR>
</TABLE>
<BR>

<IMG SRC="../../images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left" ONCLICK="javascript:setFocus();">
<IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="320" ALIGN="left"><BR>
<table width="180" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="middle" nowrap><font size="6">�������F</font></td>
		<td nowrap><font size="6" color="#ff4500"><b><%= FormatDateTime(strDispatchDate, vbShortDate) %></b></font></td>
		<td nowrap><font size="6">�̊m�F�������s���܂��B</font></td>
	</tr>
</table>
<br>
<br>
<br>

<!-- �������b�Z�[�W -->
<% If strAction = "submitend" Then %>
<FONT SIZE="6">�����m�F���܂����B</FONT>
<% End If %>

<!-- �G���[���b�Z�[�W -->
<%
	'���b�Z�[�W�̕ҏW
	If Not IsEmpty(strArrMessage) Then

		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>

<!-- �I�����b�Z�[�W��\������Ƃ��̓e�L�X�g�{�b�N�X���B�� -->
<% If flgConfirm <> 1 Then %>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>BarCode�F</TD>
			<TD><INPUT TYPE="text" NAME="billNo" SIZE="30" STYLE="ime-mode:disabled"></TD>
		</TR>
	</TABLE>

<% Else %>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo %>">
	<TR>
		<TD colspan="5"><FONT SIZE="6">�����m�F���݂ł��B</FONT></TD>
	</TR>

	<TR>
		<TD width="5">
			<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>" onClick="return callDispatchCancel();"><IMG SRC="../../images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z�����܂�" border="0"></A>
		</TD>
		<TD width="20">
		<TD width="5">
			<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>" onClick="return callDispatchUpdate();"><IMG SRC="../../images/b_replace.gif" WIDTH="77" HEIGHT="24" ALT="��������ύX���܂�" border="0"></A>
		</TD>
		<TD width="20">
		<TD width="5">
			<A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>" onClick="return callDispatchInsert();"><IMG SRC="../../images/b_append.gif" WIDTH="77" HEIGHT="24" ALT="��������ǉ����܂�" border="0"></A>
		</TD>
	</TR>
	</TABLE>

<% End If %>


<% If strAction = "submitend" Then %>
<TABLE>
	<TR>
		<TD NOWRAP><B><FONT COLOR="#ff0000"><%= FormatDateTime(Now(), vbShortDate) & " " &  FormatDateTime(Now(), vbShortTime) %> &nbsp;�����m�F����</FONT></B></TD>
	</TR</TABLE>

<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
	<TR>
		<TD NOWRAP>������No:</TD>
		<TD NOWRAP><B><%= strBillNo %></B></TD>
		<TD></TD>
	</TR>
	<TR>
		<TD ROWSPAN="3"></TD>
		<TD NOWRAP><B><%= strOrgName %></B>�i<%= strOrgKName %>�j</TD>
	</TR>

	<TR>
		<TD NOWRAP><%= strDispTotal %></TD>
	</TR>
</TABLE>
<% End If %>

<BR><BR>

<% If strBillNo <> "" Then %>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="450">
	<TR>
		<TD><A HREF="/webHains/contents/demand/dmdBurdenModify.asp?billNo=<%= strBillNo %>">���������Q��</A></TD>
	</TR>
</TABLE>
<% End If %>
</BLOCKQUOTE>
</FORM>

<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>