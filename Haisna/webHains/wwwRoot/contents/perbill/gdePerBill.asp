<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �l�������̌��� (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objPerBill			'��v���A�N�Z�X�p
Dim objHainsUser		'���[�U���A�N�Z�X�p

Dim strMode			'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strTarget			'�^�[�Q�b�g���URL
Dim strLineNo              	'�e��ʂ̍s�m��

Dim strDmdDate     		'������
Dim strBillSeq     		'�������r����(������)
Dim strBranchNo     	'�������}��(������)

Dim lngPaymentflg			'1:�����̂� 0:�S��
Dim lngDelDisp				'1:����`�[���� 0:�S��
Dim strKey              	'�����L�[
Dim strArrKey              	'�����L�[(�󔒂ŕ�����̃L�[�j
Dim strStartDmdDate     	'���������������i�J�n�j
Dim strStartYear     		'�������������N�i�J�n�j
Dim strStartMonth     		'���������������i�J�n�j
Dim strStartDay     		'���������������i�J�n�j
Dim strEndDmdDate     		'���������������i�I���j
Dim strEndYear     			'�������������N�i�I���j
Dim strEndMonth     		'���������������i�I���j
Dim strEndDay     			'���������������i�I���j
Dim strSearchDmdDate    	'��������������
Dim lngSearchBillSeq    	'���������������r����
Dim lngSearchBranchno   	'���������������}��
Dim vntDmdDate          	'������
Dim vntBillSeq          	'�������r����
Dim vntBranchNo         	'�������}��
Dim vntRsvNo            	'�\��ԍ�
Dim vntCtrPtCd          	'�_��p�^�[���R�[�h
Dim vntCsName           	'�R�[�X��
Dim vntWebColor           	'�R�[�X�F
Dim vntPerId            	'�l�h�c
Dim vntLastName         	'��
Dim vntFirstName        	'��
Dim vntLastKName        	'�J�i��
Dim vntFirstKName       	'�J�i��
Dim vntAge       	        '�N��
Dim vntGender           	'����
Dim vntPerCount       		'��f�Ґ�
Dim vntOrgSName          	'��f�c�̗���
Dim vntOrgKName          	'��f�c�̃J�i
Dim vntPrice         		'���v���z
Dim vntTax         		'�ŋ����v
Dim vntTotalPrice        	'�������z���v
Dim vntPaymentDate      	'������
Dim vntPaymentSeq	      	'����Seq
Dim vntDelflg           	'����`�[�t���O

Dim lngBillCnt			'��������
Dim lngBillCnt2			'��������(���ꐿ����No.����������)

Dim lngPageMaxLine			'�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()		'�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName()	'�P�y�[�W�\���l�`�w�s���̔z��

Dim i				'�J�E���^
Dim i2				'�J�E���^(���ꐿ����No.����������)

Dim Ret				'�֐��߂�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")

'�����l�̎擾
strLineNo         = Request("lineno")
strMode           = Request("mode")
strAction         = Request("act")
strTarget         = Request("target")
'strStartDmdDate   = Request("dmddate")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strDmdDate        = Request("dmddate")
strKey            = Request("textKey")
strBillSeq        = Request("billseq")
strBranchNo       = Request("branchno")
lngPaymentflg	  = Request("paymentflg")
lngDelDisp		  = Request("deldsp")
lngPageMaxLine      = Request("pageMaxLine")

'�f�t�H���g�͈�����K�p����
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(strDmdDate))
	strStartMonth = CStr(Month(strDmdDate))
	strStartDay   = CStr(Day(strDmdDate))
End If
If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
	strEndYear  = CStr(Year(strDmdDate))
	strEndMonth = CStr(Month(strDmdDate))
	strEndDay   = CStr(Day(strDmdDate))
End If

Call CreatePageMaxLineInfo()

Do
	
	If strKey <> "" Then
		'�����L�[���󔒂ŕ�������
		strArrKey = SplitByBlank(strKey)
	Else 
		
		strArrKey  = Array()
		ReDim Preserve strArrKey(0)
	End if

	If lngPaymentflg <> 1 Then lngPaymentflg = 0
	
	'����`�[�͕\�����Ȃ�
	lngDelDisp = 1

	'�����J�n�������̕ҏW
	strStartDmdDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
	'�����I���������̕ҏW
	strEndDmdDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)

	'���������ɏ]���l�������ꗗ�𒊏o����
	lngBillCnt = objPerBill.SelectListPerBill( _
                    0, 0, lngPaymentflg, lngDelDisp, _
                    strArrKey, _
                    strStartDmdDate, strEndDmdDate, _
                    "", "", _
                    "", _
                    "", "", _
                    "", _
                    vntDmdDate, _
                    vntBillSeq, _
                    vntBranchNo, _
                    vntRsvNo, _
                    vntCtrPtCd, _
                    vntCsName, _
                    vntWebColor, _
                    vntPerId, _
                    vntLastName, _
                    vntFirstName, _
                    vntLastKName, _
                    vntFirstkName, _
                    vntAge, _
                    vntGender, _
                    vntPerCount, _
                    vntOrgSName, _
                    vntOrgSName, _
                    vntPrice, _
                    vntTax, _
                    vntTotalPrice, _
                    vntPaymentDate, _
                    vntPaymentSeq, _
                    vntDelflg _
                    )

	'��������
	lngBillCnt2 = 0
	For i = 0 To lngBillCnt - 1
		'����̐�����No.�͕\�����Ȃ�
		If objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(strBillSeq, "00000") & strBranchNo _
		  <> objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) Then

			lngBillCnt2 = lngBillCnt2 + 1
		End If
	Next

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �P�y�[�W�\���l�`�w�s�̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()


	Redim Preserve lngArrPageMaxLine(4)
	Redim Preserve strArrPageMaxLineName(4)

	lngArrPageMaxLine(0) = 50:strArrPageMaxLineName(0) = "50�s����"
	lngArrPageMaxLine(1) = 100:strArrPageMaxLineName(1) = "100�s����"
	lngArrPageMaxLine(2) = 200:strArrPageMaxLineName(2) = "200�s����"
	lngArrPageMaxLine(3) = 300:strArrPageMaxLineName(3) = "300�s����"
	lngArrPageMaxLine(4) = 0:strArrPageMaxLineName(4) = "���ׂ�"
'	lngArrPageMaxLine(0) = 2:strArrPageMaxLineName(0) = "2�s����"
'	lngArrPageMaxLine(1) = 3:strArrPageMaxLineName(1) = "3�s����"
'	lngArrPageMaxLine(2) = 5:strArrPageMaxLineName(2) = "5�s����"
'	lngArrPageMaxLine(3) = 10:strArrPageMaxLineName(3) = "10�s����"
'	lngArrPageMaxLine(4) = 0:strArrPageMaxLineName(4) = "���ׂ�"

End Sub

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�l�������̌���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �������f�[�^�̃Z�b�g
function SelectDmdData( index ) {

	var objForm;		// ����ʂ̃t�H�[���G�������g
	var varPerId;		// �l�h�c
	var varLastName;	// ��
	var varFirstName;	// ��
	var varLastKName;	// �J�i��
	var varFirstKName;	// �J�i��
        var varAge;		// �N��
        var varGender;		// ����
	var varRsvNo;		// �\��ԍ�
	var varDmdDate;		// ������
	var varBillSeq;		// �������r����
	var varBranchNo;	// �������}��

	objForm = document.entryForm;

	// �Ăь��E�B���h�E�����݂��Ȃ���Ή������Ȃ�
	if ( opener == null ) {
		return;
	}

	// �l�h�c�̎擾
	if ( objForm.perid.length != null ) {
		varPerId  = objForm.perid[ index ].value;
	} else {
		varPerId  = objForm.perid.value;
	}

	// ���̎擾
	if ( objForm.lastname.length != null ) {
		varLastName = objForm.lastname[ index ].value;
	} else {
		varLastName = objForm.lastname.value;
	}

	// ���̎擾
	if ( objForm.firstname.length != null ) {
		varFirstName = objForm.firstname[ index ].value;
	} else {
		varFirstName = objForm.firstname.value;
	}

	// �J�i���̎擾
	if ( objForm.lastkname.length != null ) {
		varLastKName = objForm.lastkname[ index ].value;
	} else {
		varLastKName = objForm.lastkname.value;
	}

	// �J�i���̎擾
	if ( objForm.firstkname.length != null ) {
		varFirstKName = objForm.firstkname[ index ].value;
	} else {
		varFirstKName = objForm.firstkname.value;
	}

	// �N��̎擾
	if ( objForm.age.length != null ) {
		varAge = objForm.age[ index ].value;
	} else {
		varAge = objForm.age.value;
	}

	// ���ʂ̎擾
	if ( objForm.gender.length != null ) {
		varGender = objForm.gender[ index ].value;
	} else {
		varGender = objForm.gender.value;
	}

	// �\��ԍ��̎擾
	if ( objForm.rsvno.length != null ) {
		varRsvNo = objForm.rsvno[ index ].value;
	} else {
		varRsvNo = objForm.rsvno.value;
	}

	// �������̎擾
	if ( objForm.listdmddate.length != null ) {
		varDmdDate = objForm.listdmddate[ index ].value;
	} else {
		varDmdDate = objForm.listdmddate.value;
	}

	// �������r�����̎擾
	if ( objForm.listbillseq.length != null ) {
		varBillSeq = objForm.listbillseq[ index ].value;
	} else {
		varBillSeq = objForm.listbillseq.value;
	}

	// �������}�Ԃ̎擾
	if ( objForm.listbranchno.length != null ) {
		varBranchNo = objForm.listbranchno[ index ].value;
	} else {
		varBranchNo = objForm.listbranchno.value;
	}

	opener.setDmdDataInfo( objForm.lineno.value, varPerId, varLastName, varFirstName, varLastKName, varFirstKName, varAge, varGender, varRsvNo, varDmdDate, varBillSeq, varBranchNo );

	// ��ʂ����
	opener.winGuidePerBill = null;
	close();

}
//-->

<!--
// �A�����[�h���̏���
function closeGuideWindow() {

	//���t�K�C�h�����
	calGuide_closeGuideCalendar();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="search">
<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
<INPUT TYPE="hidden" NAME="lineno" VALUE="<%= strLineNo %>">
<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= strBillSeq %>">
<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= strBranchNo %>">
<INPUT TYPE="hidden" NAME="paymentflg" VALUE="<%= lngPaymentflg %>">
<INPUT TYPE="hidden" NAME="deldsp" VALUE="<%= lngDelDisp %>">
<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD NOWRAP HEIGHT="15" BGCOLOR="#ffffff"><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�l�������̌���</FONT></B></TD>
	</TR>
</TABLE>
<br>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR height="20">
		<TD NOWRAP WIDTH="10" ROWSPAN="2"></TD>
		<TD NOWRAP height="27">�������͈�</TD>
		<TD>�F</TD>
<!--
		<TD NOWRAP height="20"><b><%= strDmdDate %></b></TD>
-->
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
				<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
				<TD>&nbsp;�N&nbsp;</TD>
				<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
				<TD>&nbsp;��&nbsp;</TD>
				<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
				<TD NOWRAP >&nbsp;���`&nbsp;</TD>
				<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
				<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
				<TD>&nbsp;�N&nbsp;</TD>
				<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
				<TD>&nbsp;��&nbsp;</TD>
				<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
				<TD>&nbsp;��</TD>
			</TABLE>
		</TD>
		<TD NOWRAP VALIGN="bottom" height="20"></TD>
	</TR>
	<TR>
		<TD NOWRAP>�L�[</TD>
		<TD NOWRAP>�F</TD>
		<TD NOWRAP><INPUT TYPE="text" NAME="textKey" SIZE="24" VALUE="<%= strKey %>"></TD>
		<TD NOWRAP></TD>
	</TR>
	<tr>
		<td NOWRAP width="10"></td>
		<td NOWRAP colspan="3"><input type="checkbox" name="checkboxName" value="checkboxValue" border="0">�����������҂��\������</td>
		<td NOWRAP><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false;"><IMG SRC="../../images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></A></td>
	</tr>
</TABLE>
<BR>
<!--�����͌�����������--><SPAN STYLE="font-size:9pt;">
	�u<FONT COLOR="#ff6600"><B><%= CStr(Year(strStartDmdDate)) %>�N<%= CStr(Month(strStartDmdDate)) %>��<%= CStr(Day(strStartDmdDate)) %>���`<%= strEndYear %>�N<%= strEndMonth %>��<%= strEndDay %>��</B></FONT>�v�̐������ꗗ��\�����Ă��܂��B<BR>
				�Ώې������� <FONT COLOR="#ff6600"><B><%= lngBillCnt2 %></B></FONT>���ł��B </SPAN><BR>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
<!-- �����͈ꗗ�̌��o�� -->
	<TR BGCOLOR="cccccc">
		<TD NOWRAP>������</TD>
		<TD NOWRAP>������No</TD>
		<TD NOWRAP>�Ώۗ\��ԍ�</TD>
		<TD NOWRAP>��f�R�[�X</TD>
		<TD NOWRAP>�l����</TD>
		<TD NOWRAP>��f�c��</TD>
		<TD NOWRAP ALIGN="right" WIDTH="65">���v</TD>
		<TD NOWRAP ALIGN="right" WIDTH="65">�����z</TD>
<!--
		<TD NOWRAP ALIGN="left" WIDTH="65">����`�[</TD>
-->
	</TR>
<%
	i2 = 0
	For i = 0 To lngBillCnt - 1
		If i mod 2 = 0 Then
%>
			<TR BGCOLOR="#ffffff">
<%
		Else
%>
			<TR BGCOLOR="#eeeeee">
<%
		End If

		'����̐�����No.�͕\�����Ȃ�
		If objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(strBillSeq, "00000") & strBranchNo _
		  <> objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) Then
%>
			<INPUT TYPE="hidden" NAME="perid" VALUE="<%= vntPerId(i) %>">
			<INPUT TYPE="hidden" NAME="lastname" VALUE="<%= vntLastName(i) %>">
			<INPUT TYPE="hidden" NAME="firstname" VALUE="<%= vntFirstName(i) %>">
			<INPUT TYPE="hidden" NAME="lastkname" VALUE="<%= vntLastKname(i) %>">
			<INPUT TYPE="hidden" NAME="firstkname" VALUE="<%= vntFirstKName(i) %>">
<%
			If vntAge(i) <> "" Then
%>
				<INPUT TYPE="hidden" NAME="age" VALUE="<%= vntAge(i) %>">
<%
			Else
%>
				<INPUT TYPE="hidden" NAME="age" VALUE="">
<%
			End If
%>
			<INPUT TYPE="hidden" NAME="gender" VALUE="<%= vntGender(i) %>">
			<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= vntRsvNo(i) %>">
			<INPUT TYPE="hidden" NAME="listdmddate" VALUE="<%= vntDmdDate(i) %>">
			<INPUT TYPE="hidden" NAME="listbillseq" VALUE="<%= vntBillSeq(i) %>">
			<INPUT TYPE="hidden" NAME="listbranchno" VALUE="<%= vntBranchNo(i) %>">

			<TD NOWRAP><%= vntDmdDate(i) %></TD>
			<TD NOWRAP><%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %></TD>
			<TD NOWRAP><A HREF="../Reserve/rsvMain.asp?rsvNo=<%= vntRsvNo(i) %>" TARGET="_blank"><%= vntRsvNo(i) %></A></TD>
<%
			If IsNull(vntWebColor(i)) = True Then
%>
			<TD NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>"> </FONT><%= vntCsName(i) %></TD><%
			Else
%>
			<TD NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>">�� </FONT><%= vntCsName(i) %></TD>
<%
			End If
%>
			<TD NOWRAP><A HREF="JavaScript:SelectDmdData(<%= i2 %>)"><%= vntLastName(i) & " " & vntFirstName(i) %><FONT SIZE="-1" COLOR="#666666">�i<%= vntLastKname(i) & "�@" & vntFirstKName(i) %>�j</FONT></A></TD>
			<TD NOWRAP><%= vntOrgSName(i) %></TD>
<%
			If vntToTalPrice(i) = null Then
%>
			<TD NOWRAP ALIGN="right"><B></B></TD>
<%
			Else
%>
			<TD NOWRAP ALIGN="right"><B><%= FormatCurrency(vntToTalPrice(i)) %></B></TD>
<%
			End If
%>
<%
			If vntPaymentDate(i) = "" Then
%>
				<TD NOWRAP ALIGN="right">����</TD>
<%
			Else
%>
				<TD NOWRAP ALIGN="right"><%= FormatCurrency(vntToTalPrice(i)) %></TD>
<%
			End If

		'''����`�[���̕\�����Ȃ��̂ł��̗����폜
'			If vntDelflg(i) = 1 Then
%>
<!--
				<TD NOWRAP ALIGN="left">���</TD>
-->
<%
'			Else
%>
<!--
				<TD NOWRAP ALIGN="left"></TD>
-->
<%
'			End If
			i2 = i2 + 1
		End if
%>
		</TR>
<%
	Next
%>
</TABLE>
</FORM>
</BODY>
</HTML>
