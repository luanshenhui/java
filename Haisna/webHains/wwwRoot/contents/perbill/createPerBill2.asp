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
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------

Dim objCommon				'���ʃN���X
Dim objDemand				'�������A�N�Z�X�p
Dim objConsult				'��f���A�N�Z�X�p
Dim objPerBill				'�l�������A�N�Z�X�p

Dim Ret						'�֐��߂�l

Dim lngCreateCnt
Dim lngCount				'�擾����
Dim lngBillCount			'�擾����
Dim lngSelectNo				'�I�𖇐�
Dim lngRsvNo				'�\��ԍ�

Dim strYear				'����������(�N)
Dim strMonth				'����������(��)
Dim strDay				'����������(��)
Dim strDmdDate				'������

Dim strUpdUser        			'�X�V��

'�������쐬�p
Dim lngArrPriceSeq             		'�r�d�p
Dim lngArrLineNo             		'�쐬�y�[�W
Dim arrParamSeq             		'�p�����[�^�r�d�p

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
Dim strHTML
Dim strArrMessage	'�G���[���b�Z�[�W

Dim i			'���[�v�J�E���^
Dim j			'���[�v�J�E���^
Dim cnt			'�J�E���^

strArrMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objPerBill = Server.CreateObject("HainsPerBill.PerBill")

lngRsvNo       = Request("rsvno")
lngSelectNo    = Request("selectno")
lngArrLineNo   = ConvIStringToArray(Request("lineno"))
lngArrPriceSeq = ConvIStringToArray(Request("arrPriceSeq"))
'lngArrLineNo   = Request("lineno")
strAction      = Request("act")
strMode        = Request("mode")

strYear        = Request("year")
strMonth       = Request("month")
strDay         = Request("day")

strUpdUser     = Session.Contents("userId")

Do

	If strAction = "create" Then

		'�������̕ҏW
		strDmdDate = CDate(strYear & "/" & strMonth & "/" & strDay)

		'�f�[�^�`�F�b�N
		lngCreateCnt = 0
		For i=0 To UBound(lngArrLineNo)
			If lngArrLineNo(i) = "" OR IsNull(lngArrLineNo(i)) Then
				lngArrLineNo(i) = 0
			Else
				If lngArrLineNo(i) <> 0 Then
					lngCreateCnt = lngCreateCnt + 1
				End If
			End If
		Next

		If lngCreateCnt = 0 Then
			strArrMessage = Array("������No��I�����ĉ������B")
			Exit Do
		End If

		'��f��񂩂琿�������쐬����
		Ret = objPerBill.CreatePerBill_CSL(lngSelectNo, _
						   strDmdDate,  _
						   lngRsvNo,    _
						   lngArrLineNo, _
					 	   lngArrPriceSeq, _
						   strUpdUser)

		'�ۑ��Ɏ��s�����ꍇ
		If Ret <> True Then
			strArrMessage = Array("�������̍쐬�Ɏ��s���܂����B")
'			Err.Raise 1000, , "�������̍쐬�Ɏ��s���܂����B�iRet�@= " & Ret
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь���ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End
			Exit Do
		End If

	End If
	Exit Do
Loop

Do
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

	'�f�t�H���g����������f���ɐݒ�
	strYear        = IIf(strYear  = "", Year(strCslDate),  strYear )
	strMonth       = IIf(strMonth = "", Month(strCslDate), strMonth)
	strDay         = IIf(strDay   = "", Day(strCslDate),   strDay  )

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

	If strAction = "new" Then
		lngArrLineNo = Array()
		ReDim Preserve lngArrLineNo(lngCount)
	End If

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
Function SelectList( no )

	Dim num

	Redim Preserve strArrSelectNo(lngSelectNo-1)	'����
	Redim Preserve strArrSelectName(lngSelectNo-1) 	'����


	'�Œ�l�̕ҏW

	For num =0 To lngSelectNo - 1
		strArrSelectNo(num)  = Cstr(num + 1)
		strArrSelectName(num) = num + 1 & "����"
	Next

	'1���̂Ƃ��̓f�t�H���g�łP��\��
	If lngSelectNo = 1 Then
		SelectList = EditDropDownListFromArray("lineno", strArrSelectNo, strArrSelectName, lngArrLineNo(no), NON_SELECTED_DEL)
	Else
		SelectList = EditDropDownListFromArray("lineno", strArrSelectNo, strArrSelectName, lngArrLineNo(no), NON_SELECTED_ADD)
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�������גǉ�</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function createData() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'create';
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
<INPUT TYPE="hidden" NAME="selectno" VALUE="<%= lngSelectNo %>">
<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>�������쐬����</B></TD>
	</TR>
</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then
		Select Case strAction
			Case "new"

			'�G���[���b�Z�[�W��ҏW
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End Select
	End If
%>
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
		<TD NOWRAP></TD>
		<TD NOWRAP></TD>
	</TR>
	<TR>
		<TD NOWRAP><%= FormatDateTime(strBirth, 1) %>���@<%= strAge %>�΁@<%= IIf(strGender = "1", "�j��", "����") %></TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
	<TR>
		<TD NOWRAP>����������</TD>     
		<TD NOWRAP>�F</TD>
		<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��" BORDER="0"></A></TD>
		<TD><%= EditSelectNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strYear)) %></TD>
		<TD>�N</TD>
		<TD><%= EditSelectNumberList("month", 1, 12, Clng("0" & strMonth)) %></TD>
		<TD>��</TD>
		<TD><%= EditSelectNumberList("day",   1, 31, Clng("0" & strDay  )) %></TD>
		<TD>��</TD>
	</TR>
</TABLE>
<BR>
<!-- ������� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
	<TR BGCOLOR="CCCCCC">
		<TD NOWRAP ALIGN="RIGHT">������No.</TD>
		<TD NOWRAP>�������ו���</TD>
		<TD NOWRAP ALIGN="RIGHT">�@���z</TD>
		<TD NOWRAP ALIGN="RIGHT">�������z</TD>
		<TD NOWRAP ALIGN="RIGHT">�@�Ŋz</TD>
		<TD NOWRAP ALIGN="RIGHT">�����Ŋz</TD>
	</TR>
<%
	Do

		For i = 0 To lngCount - 1

			'�l���S����\������B
			If ((vntOrgCd1(i) = "XXXXX") AND (vntOrgCd2(i) = "XXXXX")) Then
%>
			<TR BGCOLOR=#EEEEEE>
<%
				If (vntDmdDate(i) <> "") AND (vntBillSeq(i) <> "") AND (vntBranchNo(i) <> "") Then
%>
					<INPUT TYPE="hidden" NAME="lineno" VALUE="0">
					<TD NOWRAP ALIGN="left">�쐬�ς�</TD>
<%
				Else
%>
					<TD NOWRAP><%= SelectList(i) %></TD>
<%
				End If
%>
				<!--- �������쐬�����֓n���f�[�^ -->
				<INPUT TYPE="hidden" NAME="arrPriceSeq" VALUE="<%= vntPriceSeq(i) %>">

				<TD NOWRAP><%= vntLineName(i) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT"><%= FormatCurrency(vntEditTax(i)) %></TD>
			</TR>
<%
			End If

		Next

		Exit Do
	Loop
%>
</TABLE>
<BR>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<!-- �C���� -->
		<TD WIDTH="100%"></TD>
		<TD NOWRAP><A HREF="javascript:createData()"><IMG SRC="../../images/ok.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�Ŋm�肷��"></A></TD>
		<TD>&nbsp;</TD>
		<TD><A HREF="javascript:close()"><IMG SRC="../../images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="�L�����Z������"></A></TD>
	</TR>
</TABLE>
</FORM>
</BODY>
</HTML>
