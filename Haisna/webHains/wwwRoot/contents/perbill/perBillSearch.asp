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
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
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
Dim objOrg			'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p

Dim strMode			'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")
Dim strTarget			'�^�[�Q�b�g���URL
Dim strLineNo              	'�e��ʂ̍s�m��

Dim strDmdDate     		'������

Dim strArrKey              	'�����L�[(�󔒂ŕ�����̃L�[�j
Dim strStartDmdDate     	'�������������N�����i�J�n�j
Dim strStartYear     		'�������������N�i�J�n�j
Dim strStartMonth     		'���������������i�J�n�j
Dim strStartDay     		'���������������i�J�n�j
Dim strEndDmdDate     		'���������������i�I���j
Dim strEndYear     			'�������������N�i�I���j
Dim strEndMonth     		'���������������i�I���j
Dim strEndDay     			'���������������i�I���j
Dim strSearchDmdNo	    	'������������No
Dim strSearchDmdDate    	'��������������
Dim lngSearchBillSeq    	'���������������r����
Dim lngSearchBranchno   	'���������������}��
Dim strOrgCd1		   	'���������c�̃R�[�h�P
Dim strOrgCd2		   	'���������c�̃R�[�h�Q
Dim strOrgName		   	'���������c�̖�
Dim strPerId		   	'���������l�h�c
Dim strPerName		   	'���������l��
Dim strLastName         	'����������
Dim strFirstName        	'����������

Dim lngCheckPayment		'�����������̂ݕ\���`�F�b�N
Dim lngCheckDel			'����`�[�͕\�����Ȃ��`�F�b�N

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
Dim lngPerCount       		'��f�Ґ��@�|�@�P
Dim vntOrgSName          	'��f�c�̗���
Dim vntOrgKName          	'��f�c�̃J�i
Dim vntPrice         		'���v���z
Dim vntTax         		'�ŋ����v
Dim vntTotalPrice        	'�������z���v
Dim vntPaymentDate      	'������
Dim vntPaymentSeq	      	'����Seq
Dim vntDelflg           	'����`�[�t���O
'### 2004/9/29 Updated by FSIT)Gouda �l�������̌�����ʂɓ���ID��\������
Dim vntDayId           	    '����ID
'### 2004/9/29 Updated End

Dim lngBillCnt			'��������

Dim i				'�J�E���^

Dim lngStartPos				'�\���J�n�ʒu
Dim lngPageMaxLine			'�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()		'�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName()	'�P�y�[�W�\���l�`�w�s���̔z��

Dim Ret				'�֐��߂�l

Dim strURL					'�W�����v���URL

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")
Set objOrg          = Server.CreateObject("HainsOrganization.Organization")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
'strLineNo         = Request("lineno")
strMode           = Request("mode")
strAction         = Request("act")
'strTarget         = Request("target")
'strDmdDate        = Request("dmddate")
strStartYear        = Request("startYear")
strStartMonth       = Request("startMonth")
strStartDay         = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strSearchDmdNo    = Request("searchDmdNo")
strOrgCd1         = Request("orgCd1")
strOrgCd2         = Request("orgCd2")
strPerId          = Request("perId")
lngCheckPayment   = Request("checkPaymentVal")
lngCheckDel       = Request("checkDelVal")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

'�f�t�H���g�̓V�X�e���N������K�p����
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(Now))
	strStartMonth = CStr(Month(Now))
	strStartDay   = CStr(Day(Now))
End If
If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
	strEndYear  = CStr(Year(Now))
	strEndMonth = CStr(Month(Now))
	strEndDay   = CStr(Day(Now))
End If

lngCheckPayment = IIf( lngCheckPayment = "" , 0, lngCheckPayment)
lngCheckDel = IIf( lngCheckDel = "" , 1, lngCheckDel)

lngStartPos = IIf(lngStartPos = "" , 1, lngStartPos ) 
lngPageMaxLine = IIf(lngPageMaxLine = "" , 0, lngPageMaxLine ) 

Call CreatePageMaxLineInfo()

Do
	
	strArrKey = Array()
	Redim Preserve strArrKey(0)

	'�����J�n�������̕ҏW
	strStartDmdDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
	'�����I���������̕ҏW
	strEndDmdDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)

	'����������No����
	If strSearchDmdNo <> "" Then
		strSearchDmdDate = CDate(mid(strSearchDmdNo,1,4) & "/" & mid(strSearchDmdNo,5,2) & "/" & _
									mid(strSearchDmdNo,7,2))
		lngSearchBillSeq = CLng(mid(strSearchDmdNo,9,5))
		lngSearchBranchNo = CLng(mid(strSearchDmdNo,14,1))
	End If

'### 2004/9/29 Updated by FSIT)Gouda �l�������̌�����ʂɓ���ID��\������

	'���������ɏ]���l�������ꗗ�𒊏o����
'	lngBillCnt = objPerBill.SelectListPerBill( _
'                    0, 0, lngCheckPayment, lngCheckDel, _
'                    strArrKey, _
'                    strStartDmdDate, strEndDmdDate, _
'                    strOrgCd1 & "", _
'                    strOrgCd2 & "", _
'                    strPerId & "", _
'                    strSearchDmdDate & "", _
'                    lngSearchBillSeq & "", _
'                    lngSearchBranchNo & "", _
'                    vntDmdDate, _
'                    vntBillSeq, _
'                    vntBranchNo, _
'                    vntRsvNo, _
'                    vntCtrPtCd, _
'                    vntCsName, _
'                    vntWebColor, _
'                    vntPerId, _
'                    vntLastName, _
'                    vntFirstName, _
'                    vntLastKName, _
'                    vntFirstkName, _
'                    vntAge, _
'                    vntGender, _
'                    vntPerCount, _
'                    vntOrgSName, _
'                    vntOrgSName, _
'                    vntPrice, _
'                    vntTax, _
'                    vntTotalPrice, _
'                    vntPaymentDate, _
'                    vntPaymentSeq, _
'                    vntDelflg, lngStartPos, lngPageMaxLine _
'                    )
                    
	'���������ɏ]���l�������ꗗ�𒊏o����
	lngBillCnt = objPerBill.SelectListPerBill( _
                    0, 0, lngCheckPayment, lngCheckDel, _
                    strArrKey, _
                    strStartDmdDate, strEndDmdDate, _
                    strOrgCd1 & "", _
                    strOrgCd2 & "", _
                    strPerId & "", _
                    strSearchDmdDate & "", _
                    lngSearchBillSeq & "", _
                    lngSearchBranchNo & "", _
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
                    vntDelflg, lngStartPos, lngPageMaxLine, _
                    vntDayId _
                    )
'### 2004/9/29 Updated End

	'�c�̃R�[�h����H
	If strOrgCd1 <> "" And strOrgCd2 <> "" Then
		ObjOrg.SelectOrg_Lukes _
    				strOrgCd1, strOrgCd2, _
    			 	 , , strOrgName 
	Else
		strOrgName = ""
	End If 

	'�l�h�c����H
	If strPerId <> "" Then
		ObjPerson.SelectPerson_lukes _
    						strPerId, _
    						strLastName, strFirstName 

		strPerName = strLastName & "�@" & strFirstName
	Else
		strPerName = ""
	End If 

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
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l�������̌���</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/perGuide.inc"  -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �����������̂݃`�F�b�N
function checkPaymentAct() {

	with ( document.entryPersearch ) {
		checkPayment.value = (checkPayment.checked ? '1' : '0');
		checkPaymentVal.value = (checkPayment.checked ? '1' : '0');
	}

}
// ����`�[�͕\�����Ȃ��`�F�b�N
function checkDelAct() {

	with ( document.entryPersearch ) {
		checkDel.value = (checkDel.checked ? '1' : '0');
		checkDelVal.value = (checkDel.checked ? '1' : '0');
	}

}
// �����{�^���N���b�N
function searchClick() {

	with ( document.entryPersearch ) {
		startPos.value = 1;
		submit();
	}

	return false;

}
// �A�����[�h���̏���
function closeGuideWindow() {

	// �c�̌����K�C�h�����
	orgGuide_closeGuideOrg();

	// �l�����K�C�h�����
	perGuide_closeGuidePersonal();

	//���t�K�C�h�����
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY >

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryPersearch" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="action" VALUE="search">
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= lngStartPos %>">
<BLOCKQUOTE>

<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="635">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="perbill">��</SPAN><FONT COLOR="#000000">�l�������̌���</FONT></B></TD>
	</TR>
</TABLE>

<BR>
<!-- �����͌������� -->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD WIDTH="10" ></TD>
		<TD NOWRAP HEIGHT="27">�������͈�</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('startYear', 'startMonth', 'startDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
					<TD>&nbsp;���`&nbsp;</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
					<TD>&nbsp;�N&nbsp;</TD>
					<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
					<TD>&nbsp;��&nbsp;</TD>
					<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
					<TD>&nbsp;��</TD>
				</TR>
			</TABLE>
		</TD>
		<TD WIDTH="100"></TD>
		<TD ROWSPAN="4" VALIGN="bottom">
			<A HREF="javascript:searchClick()" ><IMG SRC="/webHains/images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></A>
		</TD>
	</TR>
	<TR>
		<TD WIDTH="10" ROWSPAN="2"></TD>
		<TD HEIGHT="27">�c�̃R�[�h</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:orgGuide_showGuideOrg(document.entryPersearch.orgCd1, document.entryPersearch.orgCd2, 'orgName')"><IMG SRC="/webHains/images/question.gif" ALT="�c�̌����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryPersearch.orgCd1, document.entryPersearch.orgCd2, 'orgName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
						<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
						<INPUT TYPE="hidden" NAME="txtorgName" VALUE="<%= strOrgName %>">
						<SPAN ID="orgName"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD HEIGHT="27">�l�h�c</TD>
		<TD>�F</TD>
		<TD NOWRAP>
			<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:perGuide_showGuidePersonal(document.entryPersearch.perId, 'perName')"><IMG SRC="/webHains/images/question.gif" ALT="�l�����K�C�h��\��" HEIGHT="21" WIDTH="21"></A></TD>
					<TD><A HREF="javascript:perGuide_clearPerInfo(document.entryPersearch.perId, 'perName')"><IMG SRC="/webHains/images/delicon.gif" ALT="�ݒ肵���l���N���A" HEIGHT="21" WIDTH="21"></TD>
					<TD WIDTH="5"></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="perId" VALUE="<%= strPerId %>">
						<INPUT TYPE="hidden" NAME="txtperName" VALUE="<%= strPerName %>">
						<SPAN ID="perName"><%= strPerName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD WIDTH="10"></TD>
		<TD HEIGHT="27">������No</TD>
		<TD>�F</TD>
		<TD NOWRAP><INPUT TYPE="text" NAME="searchDmdNo" SIZE="24"  VALUE="<%= strSearchDmdNo %>">
			<INPUT TYPE="hidden" NAME="checkPaymentVal" VALUE="<%= lngCheckPayment %>">
			<INPUT TYPE="hidden" NAME="checkDelVal" VALUE="<%= lngCheckDel %>">
			<INPUT TYPE="checkbox" NAME="checkPayment" VALUE="1" <%= IIf(lngCheckPayment <> "0", " CHECKED", "") %>  ONCLICK="javascript:checkPaymentAct()" border="0">�����������̂ݕ\���@			
			<INPUT TYPE="checkbox" NAME="checkDel" VALUE="1" <%= IIf(lngCheckDel <> "0", " CHECKED", "") %>  ONCLICK="javascript:checkDelAct()" border="0">����`�[�͕\�����Ȃ�
		</TD>
		<TD>�@<%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %>�@</TD>
	</TR>
</TABLE>

<BR>
<!--�����͌�����������--><SPAN STYLE="font-size:9pt;">
�u<FONT COLOR="#ff6600"><B><%= strStartYear %>�N<%= strStartMonth %>��<%= strStartDay %>���`<%= strEndYear %>�N<%= strEndMonth %>��<%= strEndDay %>��</B></FONT>�v�̐������ꗗ��\�����Ă��܂��B
<BR>
�Ώې������� <FONT COLOR="#ff6600"><B><%= lngBillCnt %></B></FONT>���ł��B </SPAN>
<BR>
<BR>
<SPAN STYLE="color:#cc9999">��</SPAN><FONT COLOR="black">�\��ԍ����N���b�N����Ɨ\����A������No���N���b�N����ƊY�����鐿������񂪕\������܂��B</FONT><BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
	<!-- �����͈ꗗ�̌��o�� -->
	<TR BGCOLOR="cccccc">
		<TD NOWRAP>������No</TD>
		<TD NOWRAP>�Ώۗ\��ԍ�</TD>
<!--'### 2004/10/3 Updated by FJTH)ITO �擪����\��ԍ��̌��ֈʒu�ύX-->
		<TD NOWRAP>������</TD>
		<TD NOWRAP>��f�R�[�X</TD>
		<TD NOWRAP>�lID</TD>
<!--'### 2004/9/29 Updated by FSIT)Gouda �l�������̌�����ʂɓ���ID��\������-->
		<TD NOWRAP>����ID</TD>
<!--'### 2004/9/29 Updated End-->
		<TD NOWRAP>�l����</TD>
		<TD NOWRAP>��</TD>
		<TD NOWRAP>��f�c��</TD>
		<TD NOWRAP ALIGN="right" WIDTH="65">���v</TD>
<!--'### 2004/10/14 Updated by FSIT)Gouda �l�������̌�����ʂɓ�������\������-->
		<TD NOWRAP>������</TD>
<!--'### 2004/10/14 Updated End-->
		<TD NOWRAP ALIGN="right" WIDTH="65">����</TD>
		<TD NOWRAP ALIGN="left" WIDTH="65">����`�[</TD>
	</TR>
<%
	If lngBillCnt > 0 Then
	For i = 0 To UBound(vntDelflg)
		If i mod 2 = 0 Then
%>
<!--- ����`�[�̓s���N 2004.01.04
			<TR BGCOLOR="#ffffff">
-->
			<TR BGCOLOR=<%= IIf( vntDelflg(i) = "1", "#FFC0CB", "#ffffff") %>>
<%
		Else
%>
<!--- ����`�[�̓s���N 2004.01.04
			<TR BGCOLOR="#eeeeee">
-->
			<TR BGCOLOR=<%= IIf( vntDelflg(i) = "1", "#FFC0CB", "#eeeeee") %>>
<%
		End If
%>
<%
			'��f��񂠂�H
			If vntRsvNo(i) <> "" Then
%>
				<TD NOWRAP><A href="perBillInfo.asp?dmddate=<%= vntDmdDate(i) %>&billseq=<%= vntBillSeq(i) %>&branchno=<%= vntBranchNo(i) %>&rsvno=<%= vntRsvNo(i) %>"><%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %></TD>
<%
			Else
%>
				<TD NOWRAP><A href="createPerBill.asp?mode=update&dmddate=<%= vntDmdDate(i) %>&billseq=<%= vntBillSeq(i) %>&branchno=<%= vntBranchNo(i) %>"><%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %></TD>
<%
			End If
%>
			<TD NOWRAP><A HREF="../Reserve/rsvMain.asp?rsvNo=<%= vntRsvNo(i) %>" TARGET="_blank"><%= vntRsvNo(i) %></A></TD>
<!--'### 2004/10/3 Updated by FJTH)ITO �擪����\��ԍ��̌��ֈʒu�ύX-->
			<TD NOWRAP><%= vntDmdDate(i) %></TD>
<%
			If IsNull(vntWebColor(i)) = True Then
%>
				<TD NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>"> </FONT><%= vntCsName(i) %></TD>
<%
			Else
%>
				<TD NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>">�� </FONT><%= vntCsName(i) %></TD>
<%
			End If
%>
			<TD NOWRAP><%= vntPerId(i) %></TD>
<!--'### 2004/9/29 Updated by FSIT)Gouda �l�������̌�����ʂɓ���ID��\������-->
<%
			If IsNull(vntDayId(i)) = True Then
%>
				<TD NOWRAP><%= vntDayId(i) %></TD>
<%
			Else 
%>
				<TD NOWRAP><%= objCommon.FormatString(vntDayId(i), "0000") %></TD>
<%
			End If
%>
<!--'### 2004/9/29 Updated End-->
<!--- 2004.01.04 ���O���N���b�N������l�����e���\�������悤�ɂ��� start -->
			<TD NOWRAP><%= vntLastName(i) & " " & vntFirstName(i) %><A HREF="/webHains/contents/maintenance/personal/mntPersonal.asp?mode=update&perid=<%= vntPerId(i) %>"  TARGET="_top"><FONT SIZE="-1" COLOR="#666666">�i<%= vntLastKname(i) & "�@" & vntFirstKName(i) %>�j</FONT></A></TD>
<!--
			<TD NOWRAP><%= vntLastName(i) & " " & vntFirstName(i) %><A HREF="/webHains/contents/demand/dmdMoneyReceive.asp?rsvno=<%= vntRsvNo(i) %>"  TARGET="_top"><FONT SIZE="-1" COLOR="#666666">�i<%= vntLastKname(i) & "�@" & vntFirstKName(i) %>�j</FONT></A></TD>
-->
<!--- 2004.01.04 ���O���N���b�N������l�����e���\�������悤�ɂ��� end -->
<%
			If vntPerCount(i) = 1 Then
%>
				<TD NOWRAP></TD>
<%
			Else
				lngPerCount = vntPerCount(i) - 1
%>
				<TD NOWRAP><%= lngPerCount %>��</TD>
<%
			End If
%>
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
<!--'### 2004/10/14 Updated by FSIT)Gouda �l�������̌�����ʂɓ�������\������-->
			<TD NOWRAP ><%= vntPaymentDate(i) %></TD>
<!--'### 2004/10/14 Updated End-->
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

			If vntDelflg(i) = 1 Then
%>
				<TD NOWRAP ALIGN="left">���</TD>
<%
			Else
%>
				<TD NOWRAP ALIGN="left"></TD>
<%
			End If
%>
		</TR>
<%
	Next
	End If
%>
</TABLE>
<BR>
<%
	If lngBillCnt > 0 Then
			'�S���������̓y�[�W���O�i�r�Q�[�^�s�v
   	     	If lngPageMaxLine <= 0 Then
			Else
				'URL�̕ҏW
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?mode="        & strMode
				strURL = strURL & "&act="         & strAction
				strURL = strURL & "&startYear="   & strStartYear
				strURL = strURL & "&startMonth="  & strStartMonth
				strURL = strURL & "&startDay="    & strStartDay
				strURL = strURL & "&endYear="     & strEndYear
				strURL = strURL & "&endMonth="    & strEndMonth
				strURL = strURL & "&endDay="      & strEndDay
				strURL = strURL & "&searchDmdNo=" & strSearchDmdNo
				strURL = strURL & "&orgCd1="      & strOrgCd1
				strURL = strURL & "&orgCd2="      & strOrgCd2
				strURL = strURL & "&perId="       & strPerId
				strURL = strURL & "&checkPaymentVal=" & lngCheckPayment
				strURL = strURL & "&checkDelVal="     & lngCheckDel
				strURL = strURL & "&pageMaxLine=" & lngPageMaxLine
				'�y�[�W���O�i�r�Q�[�^�̕ҏW
'Err.Raise 1000, , lngCount & " " &  lngStartPos & " " & lngPageMaxLine 
%>
				<%= EditPageNavi(strURL, CLng(lngBillCnt), lngStartPos, CLng(lngPageMaxLine)) %>
<%
			End If
%>
		<BR>
<%
	End If
%>
<BR>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="ffffff">.</FONT></DIV>

</BODY>
</HTML>
