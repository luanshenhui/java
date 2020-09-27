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
<TITLE>�����������m�F���ݒ�</TITLE>

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�����l
Dim strAction			'������ԁisubmit / next)
Dim strMode				'�������[�h("delete"�F�폜 "update":�㏑��)
Dim lngSendYear			'������(�N)
Dim lngSendMonth		'������(��)
Dim lngSendDay			'������(��)
Dim strSeq				'����Seq
Dim strBillNo			'�������ԍ�

Dim lngCloseYear		'���ߓ��i�N�j
Dim lngCloseMonth		'���ߓ��i���j
Dim lngCloseDay			'���ߓ��i���j
Dim strCloseDate		'���ߓ�
Dim lngBillSeq			'������Seq
Dim lngBranchNo			'�������}��
Dim lngSeq				'����Seq
Dim strDispatchDate		'������
Dim strUpdUser			'�X�V��


'COM�I�u�W�F�N�g
Dim objDemand			'�������A�N�Z�X�pCOM�I�u�W�F�N�g

'�w�����
Dim strEditSendDate	'������

'���̓`�F�b�N
Dim strArrMessage		'�G���[���b�Z�[�W
Dim lngMax
Dim lngDelFlg

Dim url					'
'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strAction    = Request("action") & ""
strMode      = Request("mode") & ""
strBillNo    = Request("billNo") & ""
strSeq       = Request("seq") & ""
lngSendYear  = CLng("0" & Request("sendYear"))
lngSendMonth = CLng("0" & Request("sendMonth"))
lngSendDay   = CLng("0" & Request("sendDay"))
strUpdUser      = Session("userid")


'�������̃f�t�H���g�l(�V�X�e�����t)��ݒ�
lngSendYear  = IIf(lngSendYear  = 0, Year(Now()),  lngSendYear )
lngSendMonth = IIf(lngSendMonth = 0, Month(Now()), lngSendMonth)
lngSendDay   = IIf(lngSendDay   = 0, Day(Now()),   lngSendDay  )


'�����ݒ�
strArrMessage = Empty
strEditSendDate = Empty

'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̊��蓖��
Set objDemand        = Server.CreateObject("HainsDemand.Demand")

'�����̐���
Do

	'�K�{
	If strMode = "update" Or strMode = "delete" Then		'��{��񂩂�̑J��

		If strBillNo = "" Or strSeq = "" Then
			strArrMessage = Array("������񂪎w�肳��Ă��܂���")
			Exit Do
		End If

		' Request ���琿�����L�[
		If Len(strBillNo) <> 14 Then
			strArrMessage = Array("�������ԍ����s���ł�")
			Exit Do
		Else 
			If Not IsNumeric(strBillNo) Then
				strArrMessage = Array("�������ԍ����s���ł�")
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
			Exit Do
		End If
		strCloseDate = CDate(strCloseDate)

		'����`�[�͔������Ȃ�
		If Not objDemand.GetDispatchSeqMax(strCloseDate, _
											lngBillSeq, _
											lngBranchNo, _
											lngMax, _
											lngDelFlg ) Then
			strArrMessage = Array("�������̎擾�Ɏ��s���܂���")
			Exit Do
		End If


		' ��{��񂩂�J�ڂ����ꍇ�͔���Seq�͎w�肳�ꂽ���̂��g�p����
		lngSeq = CLng(strSeq)

		If strAction = "submit" Then
			If CLng(lngDelFlg) = 1 Then
				strArrMessage = Array("����`�[�͔�������ύX�ł��܂���")

			Else 
				If strMode = "delete" Then
					' �폜����
					If Not objDemand.DeleteDispatch(strCloseDate, _
													lngBillSeq, _
													lngBranchNo, _
													lngSeq) Then 
						strArrMessage = Array("�������͍폜�ł��܂���ł���")
						Exit Do
					End If

				Else 

					'���̓`�F�b�N
					strArrMessage = objDemand.CheckValueSendCheckDay(lngSendYear, lngSendMonth, lngSendDay, strDispatchDate)

					'���̓G���[���͉������Ȃ�
					If Not IsEmpty(strArrMessage) Then
						Exit Do
					End If

					If strCloseDate > strDispatchDate Then 
						strArrMessage = Array("�������͒��ߓ��ȍ~�̓��t����͂��Ă��������B")
						Exit Do
					End If

					' �X�V����
					If Not objDemand.UpdateDispatch(strCloseDate, _
													lngBillSeq, _
													lngBranchNo, _
													lngSeq, _
													strDispatchDate, _
													strUpdUser) Then
						strArrMessage = Array("�������͍X�V�ł��܂���ł���")
						Exit Do
					End If

				End If
				strAction = "saveend"
				Response.Write "<BODY ONLOAD=""goBackPage()"">"
			End If
		End If

		'�������擾
		If Not objDemand.SelectDispatch(strCloseDate, _
							lngBillSeq, _
							lngBranchNo, _
							lngSeq, _
							strDispatchDate) Then
			strArrMessage = Array("�������̎擾�Ɏ��s���܂���")
			Exit Do
		End If

		lngSendYear  = Year(strDispatchDate)
		lngSendMonth = Month(strDispatchDate)
		lngSendDay   = Day(strDispatchDate)

	End If

	'mode�ɂ�菈������
	If strAction = "next" Then 
		' ���։��� �m�F��ʂ֑J��

		url = "/webHains/contents/demand/dmdSendCheck.asp"
		url = url & "?sendYear=" & lngSendYear
		url = url & "&sendMonth=" & lngSendMonth 
		url = url & "&sendDay=" & lngSendDay

		Response.Redirect url
		Response.End

	End If
		
	Exit Do
Loop

'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̉��
Set objDemand = Nothing
%>


<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
// �e�E�C���h�E�֖߂�
function goBackPage() {

	// �A����ɐݒ肳��Ă���e��ʂ̊֐��Ăяo��
	if ( opener.dmdSendCheckDay_CalledFunction != null ) {
		opener.dmdSendCheckDay_CalledFunction();
	}
	close();

	return false;
}

function callDmdSendCheck() {

	// ���������̓`�F�b�N
	if ( !isDate(document.entryForm.sendYear.value, document.entryForm.sendMonth.value, document.entryForm.sendDay.value) ) {
		self.alert('�������̌`���Ɍ�肪����܂��B');
		return false;
	}

	// ����ʂ𑗐M
	document.entryForm.action.value = 'next';
	document.entryForm.submit();

	return false;

}
function DmdDispatchDelete() {
	var ret;		//�߂�l

	ret = self.confirm('�w�肳�ꂽ���������폜���܂��B��낵���ł����B');

	// OK
	if ( ret ) {
		// ����ʂ𑗐M
		document.entryForm.action.value = 'submit';
		document.entryForm.mode.value = 'delete';
		document.entryForm.submit();
	}
	return false;

}
function DmdDispatchUpdate() {

	// ���������̓`�F�b�N
	if ( !isDate(document.entryForm.sendYear.value, document.entryForm.sendMonth.value, document.entryForm.sendDay.value) ) {
		self.alert('�������̌`���Ɍ�肪����܂��B');
		return false;
	}

	// ����ʂ𑗐M
	document.entryForm.action.value = 'submit';
	document.entryForm.mode.value = 'update';
	document.entryForm.submit();

	return false;

}

//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY  ONUNLOAD="JavaScript:calGuide_closeGuideCalendar()" >
<BR>
<% If strMode = "" Then %>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<% End If %>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAction %>">
<INPUT TYPE="hidden" NAME="mode" VALUE="<%= strMode %>">
<INPUT TYPE="hidden" NAME="billNo" VALUE="<%= strBillNo %>">
<INPUT TYPE="hidden" NAME="seq" VALUE="<%= strSeq %>">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
<% If strBillNo = "" Then %>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><font color="#000000">�����������m�F���ݒ�</font></B></TD>
<% Else %>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><font color="#000000">�����������m�F���C��</font></B></TD>
<% End If %>
	</TR>
</TABLE>
<!-- �����̓G���[���b�Z�[�W -->
<%
	'���b�Z�[�W�̕ҏW
	If Not IsEmpty(strArrMessage) Then

		'�N���������́u�N�������v�̒ʒm
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>

<BR>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
	<TR>
		<TD><FONT COLOR="#ff0000">��</FONT></TD>
		<TD WIDTH="90" NOWRAP>������</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('sendYear', 'sendMonth', 'sendDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("sendYear", YEARRANGE_MIN, YEARRANGE_MAX, lngSendYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("sendMonth", 1, 12, lngSendMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("sendDay", 1, 31, lngSendDay, False) %></TD>
					<TD>��</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
<TR>
<!-- ���j���[����̑J�� -->
<% If strBillNo = "" Then %>
	
    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
        <TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return callDmdSendCheck();"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="�������m�F����"></A></TD>
    <%  end if  %>

<!-- ��{��񂩂�̑J�� -->
<% Else %>

	<!-- ����`�[�̕ύX�͂ł��Ȃ� -->
	<% If CLng(lngDelFlg) <> 1 Then %>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return DmdDispatchDelete();"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="���̔��������폜���܂�"></A></TD>
		<TD WIDTH="190"></TD>
		<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="JavaScript:return DmdDispatchUpdate();"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm�肷��"></A></TD>
		<TD WIDTH="5"></TD>
	<% End If %>


	<TD><A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
<% End If %>
</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>

<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>