<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�������쐬�����i�����I���j (Ver0.0.1)
'		AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------

Dim objCommon				'���ʃN���X
Dim objDemand				'�������A�N�Z�X�p
Dim objConsult				'��f���A�N�Z�X�p

Dim Ret						'�֐��߂�l

Dim lngCount				'�擾����
Dim lngBillCount			'�擾����
Dim lngSelectNo				'�I�𖇐�
Dim lngRsvNo				'�\��ԍ�

'��f���p�ϐ�
Dim strPerId				'�lID
Dim strCslDate				'��f��
Dim strCsCd					'�R�[�X�R�[�h
Dim strCsName				'�R�[�X��
Dim strLastName				'��
Dim strFirstName			'��
Dim strLastKName			'�J�i��
Dim strFirstKName			'�J�i��
Dim strBirth				'���N����
Dim strAge					'�N��
Dim strGender				'����
Dim strGenderName			'���ʖ���
Dim strKeyDayId				'����ID

'�l��f���z�p�ϐ�
Dim vntOrgCd1               '�c�̃R�[�h�P
Dim vntOrgCd2               '�c�̃R�[�h�Q
Dim vntOrgSeq				'�_��p�^�[���r�d�p
Dim vntOrgName              '�c�̖�
Dim vntPrice                '���z
Dim vntEditPrice            '�������z
Dim vntTaxPrice             '�Ŋz
Dim vntEditTax            	'�����Ŋz
Dim vntLineTotal			'���v�i���z�A�������z�A�Ŋz�A�����Ŋz�j
Dim vntPriceSeq             '�r�d�p
Dim vntCtrPtCd				'�_��p�^�[���R�[�h
Dim vntOptCd				'�I�v�V�����R�[�h
Dim vntOptBranchNo			'�I�v�V�����}��
Dim vntOptName				'�I�v�V��������
Dim vntOtherLineDivCd		'�Z�b�g�O���̋敪
Dim vntLineName				'���ז��́i�Z�b�g�O���ז��̊܂ށj
Dim vntDmdDate				'������
Dim vntBillSeq				'�������r����
Dim vntBranchNo				'�������}��
Dim vntBillLineNo			'���������׍sNo
Dim vntPaymentDate			'������
Dim vntPaymentSeq			'�����r����

Dim strMode					'�������[�h
Dim strAction				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim i						'�C���f�b�N�X
Dim strHTML
Dim strArrMessage	'�G���[���b�Z�[�W

strArrMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

lngRsvNo       = Request("rsvno")
lngSelectNo    = Request("selectno")

strAction      = Request("act")
strMode        = Request("mode")

'IIf( lngSelectNo = "" , "1", lngSelectNo)

Do

	If strAction = "move" Then
		Response.Redirect "createPerBill2.asp" & "?rsvno=" & lngRsvNo & "&selectno=" & lngSelectNo & "&act=new"
	End If


	'��f��񌟍�
	Ret = objConsult.SelectRslConsult(lngRsvNo,      _
									  strPerId,      _
									  strCslDate,    _
									  strCsCd,       _
									  strCsName,     _
									  strLastName,   _
									  strFirstName,  _
									  strLastKName,  _
									  strFirstKName, _
									  strBirth,      _
									  strAge,        _
									  strGender,     _
									  strGenderName, _
									  strKeyDayId)

	'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
	If Ret = False Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
	End If

	'�l��f���z���擾
	lngCount = objDemand.SelectConsult_mInfo(lngRsvNo, _
											 vntOrgCd1, _
											 vntOrgCd2, _
											 vntOrgSeq, _
											 vntOrgName, _
											 vntPrice, _
											 vntEditPrice, _
											 vntTaxPrice, _
											 vntEditTax, _
											 vntLineTotal, _ 
											 vntPriceSeq, _
											 vntCtrPtCd, _
											 vntOptCd, _
											 vntOptBranchNo, _
											 vntOptName, _
											 vntOtherLineDivCd, _
											 vntLineName, _
											 vntDmdDate, _
											 vntBillSeq, _
											 vntBranchNo, _
											 vntBillLineNo, _
											 vntPaymentDate, _
											 vntPaymentSeq )


	'��f���z��񂪑��݂��Ȃ��ꍇ
	If lngCount < 1 Then
		Exit Do
	End If

	'�쐬�����������J�E���g
	lngBillCount = 0
	For i=0 To lngCount - 1
		If ( ( vntORGCD1(i) = "XXXXX" ) AND (vntORGCD2(i) = "XXXXX") AND _
		    ((vntDmdDate(i) = "") OR (vntBillSeq(i) = "") OR (vntBranchNo(i) = "")) ) Then
			
			lngBillCount = lngBillCount + 1
		End If
	Next

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �I�𖇐��̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ : 
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function SelectList()

	Redim Preserve strArrSelectNo(lngBillCount-1)		'����
	Redim Preserve strArrSelectName(lngBillCount-1) 	'����

	'�Œ�l�̕ҏW

	For i=0 To lngBillCount - 1
		strArrSelectNo(i)  = i + 1
		strArrSelectName(i) = i + 1
	Next

'	SelectList = EditDropDownListFromArray("selectno", strArrSelectNo, strArrSelectName, IIf( lngSelectNo = "" , "1", lngSelectNo), NON_SELECTED_DEL)
	SelectList = EditDropDownListFromArray("selectno", strArrSelectNo, strArrSelectName, lngSelectNo, NON_SELECTED_DEL)

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�������쐬�i�����I���j����</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function changeUrl() {

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'move';
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="act" VALUE="">
<INPUT TYPE="hidden" NAME="RsvNo"   VALUE="<%= lngRsvNo %>">
<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>�������쐬�i�����I���j����</B></TD>
	</TR>
</TABLE>

<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>�\��ԍ�</TD>
			<TD>�F</TD>
			<TD><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
		</TR>
		<TR>
			<TD NOWRAP>��f�R�[�X</TD>
			<TD>�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
			<TD></TD>
			<TD></TD>
			<TD></TD>
			<TD></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP ROWSPAN="2" VALIGN="top"><%= strPerId %></TD>
			<TD NOWRAP><B><%= strLastName & " " & strFirstName %></a></B> (<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>)</TD>
		</TR>
		<TR>
			<TD NOWRAP><%= FormatDateTime(strBirth, 1) %>���@<%= strAge %>�΁@<%= IIf(strGender = "1", "�j��", "����") %></TD>
		</TR>
	</TABLE>
	<BR>
<!-- ������� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
<%
			If lngBillCount > 0 Then
%>
				<TD COLSPAN="5" NOWRAP><SPAN STYLE="color:#cc9999">��</SPAN>�������쐬��������͂��Ă��������B</TD>
				<TD NOWRAP><%= SelectList() %> ��</TD>
<%
			Else
%>
				<TD NOWRAP><FONT COLOR="#ff6600"><B>�l�������͑S�č쐬�ρB</B></TD>
<%
			End If
%>
		</TR>
	</TABLE>

	<BR>

<!-- �C���� -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="100%"></TD>
<%
			If lngBillCount > 0 Then
				if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then 
%>
				<TD><A HREF="javascript:changeUrl()"><IMG SRC="../../images/next.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="����"></A></TD>
<%
				End If
			End If
%>
			<TD>&nbsp;</TD>
			<TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
