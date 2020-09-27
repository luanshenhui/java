<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�l��f���z�\�� (Ver0.0.1)
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
'�萔�̒�`
Const MODE_INSERT   = "insert"	'�������[�h(�}��)
Const MODE_UPDATE   = "update"	'�������[�h(�X�V)
Const ACTMODE_SAVE  = "save"	'���샂�[�h(�ۑ�)
Const ACTMODE_SAVED = "saved"	'���샂�[�h(�ۑ�����)

Dim objCommon				'���ʃN���X
Dim objDemand				'�������A�N�Z�X�p
Dim objConsult				'��f���A�N�Z�X�p
Dim objPerbill				'��f���A�N�Z�X�p


Dim strDmdDate				'������
Dim lngBillSeq				'�������r����
Dim lngBranchNo				'�������}��

Dim lngCountCsl				'�擾����
Dim lngCount				'�擾����
Dim Ret						'�֐��߂�l

'��f���p�ϐ�
Dim vntRsvNo				'�\��ԍ�
Dim vntCslDate				'��f��
Dim vntPerId				'�l�h�c
Dim vntLastName				'��
Dim vntFirstName			'��
Dim vntLastKName			'�J�i��
Dim vntFirstKName			'�J�i��
Dim vntCsCd					'�R�[�X�R�[�h
Dim vntCsName				'�R�[�X��

'�l�������׏��̎擾
'Dim vntBillLineNo			'�������׍sNo
Dim vntPrice				'���z
Dim vntEditPrice			'�������z
Dim vntTaxPrice				'�Ŋz
Dim vntEditTax				'�����Ŋz
'Dim vntCtrPtCd				'�_��p�^�[���R�[�h
'Dim vntOptCd				'�I�v�V�����R�[�h
'Dim vntOptBranchNo			'�I�v�V�����}��
'Dim vntRsvNo				'�\��ԍ�
'Dim vntPriceSeq			'��M���z�r�d�p
Dim vntLineName				'���ז���
Dim vntOtherLineDivCd		'�Z�b�g�O���׃R�[�h
Dim vntOtherLineName		'�Z�b�g�O���ז�
Dim vntLastName_c			'��f�Җ��@��
Dim vntFirstName_c			'��f�Җ��@��

'�l�����Ǘ����(BillNo)
Dim vntDelFlg				'������`�[�t���O
'Dim vntIcomeDate			'�X�V����
'Dim vntUserId				'���[�U�h�c
'Dim vntUserName				'���[�U��������
Dim vntBillcoment			'�������R�����g
Dim vntPaymentDate			'������
Dim vntPaymentSeq			'�����r����
Dim vntPriceTotal			'���z�i���������v�j
Dim vntEditPriceTotal		'�������z�i���������v�j
Dim vntTaxPriceTotal		'�Ŋz�i���������v�j
Dim vntEditTaxTotal			'�����Ŋz�i���������v�j
Dim vntTotal				'���v�i���������v�j
Dim vntTaxTotal				'�ō��v�i���������v�j
Dim vntPrintDate			'�̎��������
''' 2003.12.19 add start
Dim vntBillName				'��������
Dim vntKeishou				'�h��
Dim strDspBillName			'�\���p�ҏW����
''' 2003.12.19 add end

'�������
'Dim vntPaymentDate			'������
'Dim vntPaymentSeq			'�����r����
Dim vntPriceTotal_Pay		'�������z���v
Dim vntCredit				'�����a�����
Dim vntHappy_ticket			'�n�b�s�[������
Dim vntCard					'�J�[�h
Dim vntCardKind				'�J�[�h���
Dim vntCardNAME				'�J�[�h����
Dim vntCreditslipno			'�`�[�m��
Dim vntJdebit				'�i�f�r�b�g
Dim vntBankCode				'���Z�@�փR�[�h
Dim vntBankName				'���Z�@�֖�
Dim vntCheque				'���؎�
Dim vntRegisterno			'���W�ԍ�
Dim vntIcomedate			'�X�V���t
Dim vntUserId				'���[�U�h�c
Dim vntUserName				'���[�U��������
' ## 2003.12.25 add 
Dim vntTransfer				'�U����


Dim lngLineTotal			'���v
Dim lngPaymentFlg			'�����σt���O�i������:"1"�A����:"0"�j


Dim strMode					'�������[�h
Dim lngRsvNo				'�\��ԍ�
Dim lngSubCount				'�擾����
Dim lngPerBillCount			'�擾����

Dim strActMode				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strMessage				'�G���[���b�Z�[�W
Dim i						'�C���f�b�N�X

Dim strLastName
Dim strFirstName
Dim vntSubTotal

Dim strHTML

strMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'�����l�̎擾

strDmdDate     = Request("dmddate")
lngBillSeq     = Request("billseq")
lngBranchNo    = Request("branchno")
lngRsvNo       = Request("rsvno")

strActMode   = Request("act")

'�p�����^�̃f�t�H���g�l�ݒ�
'lngRsvNo   = IIf(IsNumeric(lngRsvNo) = False, 0,  lngRsvNo )

Do

	'�ۑ��{�^��������
	If strActMode = "delete" Then
'KMT
'Err.Raise 1000, , "�ilngRsvNo= " & lngRsvNo & " )  "
'Exit Do

		'�������̎�����
		Ret = objPerbill.DeletePerBill(strDmdDate, _
										lngBillSeq, _
										lngBranchNo, _
										Session("USERID"))

		'�ۑ��Ɏ��s�����ꍇ
		If Ret <> True Then
			srtMessage = "�������̎�����Ɏ��s���܂���"
'			Err.Raise 1000, , "�̎�����Ɏ��s���܂����B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
		Else

			Response.Redirect "perPaymentInfo.asp?rsvno="&lngRsvNo
'			Response.end

		End If
	End If


	'�������m������\��ԍ����擾�����ꂼ��̎�f�����擾����
	lngCountCsl = objPerbill.SelectPerBill_csl(strDmdDate, _
										lngBillSeq, _
										lngBranchNo, _
										vntRsvNo, _
										vntCslDate, _
										vntPerId, _
										vntLastName, _
										vntFirstName, _
										vntLastKName, _
										vntFirstKName, _
										vntCsCd, _
										vntCsName )
	'��f��񂪑��݂��Ȃ��ꍇ
	If lngCountCsl < 1 Then
'		Err.Raise 1000, , "��f��񂪎擾�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If


	'�l�������׏��̎擾
	lngCount = objPerbill.SelectPerBill_c(strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											, _
											vntPrice, _
											vntEditPrice, _
											vntTaxPrice, _
											vntEditTax, _
											, , , , , _
											vntLineName, _
											vntOtherLineDivCd, _
											vntOtherLineName, _
											vntLastName_c, _
											vntFirstName_c )

	'�l�������׏�񂪑��݂��Ȃ��ꍇ
	If lngCount < 1 Then
		Err.Raise 1000, , "�l�������׏�񂪎擾�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If


	'�l�����Ǘ����̎擾
	''' ����A�h�̂�ǉ� 2003.12.19
	Ret = objPerbill.SelectPerBill_BillNo(strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											vntDelFlg, _
											, , , _
											vntBillComent, _
											vntPaymentDate, _
											vntPaymentSeq, _
                                            vntPriceTotal, _
											vntEditPriceTotal, _
											vntTaxPriceTotal, _
											vntEditTaxTotal, _
											vntTotal, _
											vntTaxTotal, _
											vntPrintDate, _
											vntBillName, _
											vntKeishou )
	'��f��񂪑��݂��Ȃ��ꍇ
	If Ret <> True Then
		Err.Raise 1000, , "�l�����Ǘ���񂪎擾�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If

	'�����σt���O������
	lngPaymentFlg = 0

	'������񂠂�H
	If IsNull(vntPaymentDate) = False Then
'KMT	If vntPaymentDate <> "" Then
		'�����σZ�b�g
		lngPaymentFlg = 1

		'�������̎擾
		'### �U����(TRANSFER)��ǉ� 2003.12.25
		Ret = objPerbill.SelectPerPayment(vntPaymentDate, _
											vntPaymentSeq, _
											vntPriceTotal_Pay, _
											vntCredit, _
											vntHappy_ticket, _
											vntCard, _
											vntCardKind, _
											vntCardNAME, _
											vntCreditslipno, _
											vntJdebit, _
											vntBankCode, _
											vntBankName, _
											vntCheque, _
											vntRegisterno, _
											vntIcomedate, _
											vntUserId, _
											vntUserName, _
											vntTransfer )
		'��f��񂪑��݂��Ȃ��ꍇ
		If Ret <> True Then
			Err.Raise 1000, , "������񂪎擾�ł��܂���B�i����No�@= " & vntPaymentDate(i) & vntPaymentSeq(i) &" )"
		End If
	End If

	Exit Do
Loop

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���������</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
var winComment;			// �R�����g���̓E�B���h�E�n���h��
var winMerge;			// �����������E�B���h�E�n���h��
var winPrint;			// ����E�B���h�E�n���h��
var winIncome;			// �������E�B���h�E�n���h��

function showCommentWindow() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winComment != null ) {
		if ( !winComment.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/perBillComment.asp'
	url = url + '?dmddate=' + '<%= strDmdDate %>';
	url = url + '&billseq=' + <%= lngBillSeq %>;
	url = url + '&branchno=' + <%= lngBranchNo %>;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winComment.focus();
		winComment.location.replace(url);
	} else {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//		winComment = window.open( url, '', 'width=550,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
		winComment = window.open( url, '', 'width=500,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
// ## 2003.12.20 Mod End
	}
}

//�����������E�B���h�E�\��
function showMergeWindow() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winMerge != null ) {
		if ( !winMerge.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/perbill/mergePerBill1.asp';
	url = url + '?dmddate=' + '<%= strDmdDate %>';
	url = url + '&billseq=' + <%= lngBillSeq %>;
	url = url + '&branchno=' + <%= lngBranchNo %>;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winMerge.focus();
		winMerge.location.replace(url);
	} else {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//		winMerge = window.open( url, '', 'width=600,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
		winMerge = window.open( url, '', 'width=750,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
// ## 2003.12.20 Mod End
	}
}

//������E�B���h�E�\��
function PrintWindow() {
// ## 2003.12.20 Mod By T.Takagi@FSIT
//	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
//
//	var url;			// URL������
//	var opened = false;	// ��ʂ����łɊJ����Ă��邩
//
//	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
//	if ( winPrint != null ) {
//		if ( !winPrint.closed ) {
//			opened = true;
//		}
//	}
//
//	url = '/WebHains/contents/perbill/prtPerBill.asp';
//	url = url + '?rsvno=' + '<%= lngRsvNo %>';
//	url = url + '&dmddate=' + '<%= strDmdDate %>';
//	url = url + '&billseq=' + <%= lngBillSeq %>;
//	url = url + '&branchno=' + <%= lngBranchNo %>;
//
//	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
//	if ( opened ) {
//		winPrint.focus();
//		winPrint.location.replace(url);
//	} else {
//		winPrint = window.open( url, '', 'width=600,height=450,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
//	}
/// �̎�������E�C���h�E��\������ 2003.12.25 start
//	var url = '/webHains/contents/report_form/rd_18_prtBill.asp';
//	url = url + '?p_Uid='      + '<%= Session("USERID") %>';
//	url = url + '&p_ScslDate=' + '<%= strDmdDate %>';
//	url = url + '&p_BilSeq='   + '<%= lngBillSeq %>';
//	url = url + '&p_BilBan='   + '<%= lngBranchNo %>';
//	url = url + '&p_Option='   + '0';
//	open( url );
	var url = '/webHains/contents/perbill/prtPerBill.asp';
	url = url + '?reqdmddate=' + '<%= strDmdDate %>';
	url = url + '&reqbillseq='   + '<%= lngBillSeq %>';
	url = url + '&reqbranchno='   + '<%= lngBranchNo %>';
	url = url + '&prtKbn='   + '0';
	open( url );
/// �̎�������E�C���h�E��\������ 2003.12.25 end
// ## 2003.12.20 Mod End

}

//�������E�B���h�E�\��
function IncomeWindow() {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g

	var varBranchNo;

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			opened = true;
		}
	}

	varBranchNo = <%= lngBranchNo %>;
	// ����`�[�Ȃ�ԋ��E�C���h�E
	if ( varBranchNo == 1 ) {
		url = '/WebHains/contents/perbill/perHenkin.asp';
	} else {
		url = '/WebHains/contents/perbill/perBillIncome.asp';
	}
	url = url + '?rsvno=' + '<%= lngRsvNo %>';
	url = url + '&dmddate=' + '<%= strDmdDate %>';
	url = url + '&billseq=' + <%= lngBillSeq %>;
	url = url + '&branchno=' + <%= lngBranchNo %>;

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winIncome.focus();
		winIncome.location.replace(url);
	} else {
		winIncome = window.open( url, '', 'width=600,height=650,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

// �폜����
function deleteData() {

	if ( !confirm( '���̐��������폜���܂��B��낵���ł����H' ) ) {
		return;
	}

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'delete';
	document.entryForm.submit();

}
function windowClose() {

	// �������E�C���h�E�����
	if ( winIncome != null ) {
		if ( !winIncome.closed ) {
			winIncome.close();
		}
	}

	winIncome = null;

	// ����E�C���h�E�����
	if ( winPrint != null ) {
		if ( !winPrint.closed ) {
			winPrint.close();
		}
	}

	winPrint = null;

	// �����������E�C���h�E�����
	if ( winMerge != null ) {
		if ( !winMerge.closed ) {
			winMerge.close();
		}
	}

	winMerge = null;

	// �R�����g���̓E�C���h�E�����
	if ( winComment != null ) {
		if ( !winComment.closed ) {
			winComment.close();
		}
	}

	winComment = null;

}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#ffffff }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<BLOCKQUOTE>
	<INPUT TYPE="hidden" NAME="act" VALUE="select">
	<INPUT TYPE="hidden" NAME="startPos">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE=<%= lngRsvNo %>>
	<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
	<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
	<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">���������</B></TD>
		</TR>
	</TABLE>
<%
'���b�Z�[�W�̕ҏW
	If strMessage <> "" Then
		Call EditMessage(strMessage, MESSAGETYPE_WARNING)
	End If

%>
	<BR>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD NOWRAP height="15">����������</TD>
			<TD height="15">�F</TD>
			<TD height="15"><%= strDmdDate %></TD>
			<TD height="15"></TD>
		</TR>
		<TR>
			<TD NOWRAP height="15">������No</TD>
			<TD height="15">�F</TD>
			<TD height="15">
				<%= objCommon.FormatString(strDmdDate, "yyyymmdd") %><%= objCommon.FormatString(lngBillSeq, "00000") %><%= lngBranchNo %></TD>
			<TD height="15"></TD>
		</TR>
		<TR>
			<TD NOWRAP height="15">�������z</TD>
			<TD NOWRAP height="15">�F</TD>
			<TD NOWRAP height="15"><B><%= FormatCurrency(vntTotal) %></B>�@�i���@�����<%= FormatCurrency(vntTaxTotal) %>�j</TD>
<!--
			<TD NOWRAP rowspan="2"><a href="prtPerBill.asp?dmddate=<%= strDmdDate %>&billseq=<%= lngBillSeq %>&branchno=<%= lngBranchNo %>" target="_blank"><IMG SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="���̐�������������܂�" BORDER="0"></A></TD>
-->
		</TR>
		<TR>
			<TD NOWRAP >�������R�����g</TD>
			<TD >�F</TD>
			<TD >
			<TABLE  border="0" cellspacing="1" cellpadding="0">
				<TR>
					<TD><A HREF="JavaScript:showCommentWindow();"><IMG SRC="../../images/question.gif" ALT="�������R�����g����" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
					<TD width= "357"><%= vntBillComent %></TD>
				</TR>
			</TABLE>
			</TD>
<!--- ������ǉ������̂Ń{�^���̈ʒu�����炵���i1�s�������j 2003.12.19 -->
			<TD NOWRAP rowspan="2"><A HREF="JavaScript:history.back();"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A></TD>
            
            <% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
			    <TD NOWRAP rowspan="2"><A HREF="JavaScript:PrintWindow()"><IMG SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="���̐�������������܂�" BORDER="0"></A></TD>
            <% End If %>

		</TR>
<!-- �����ǉ��@2003.12.19 start -->
		<TR>
<%
			'��������w�肠��H
			If vntBillName <> "" Then
				strDspBillName = vntBillName
			Else
				strDspBillName = vntLastName(0) & " " & vntFirstName(0)
			End If

			'�h�̎w�肠��H
			If vntKeishou <> "" Then
				strDspBillName = strDspBillName & " " & vntKeishou
			Else
				strDspBillName = strDspBillName & " �l"
			End If
%>
			<TD NOWRAP >����</TD>
			<TD >�F</TD>
			<TD ><%= strDspBillName %></TD>
		</TR>
<!-- �����ǉ��@2003.12.19 end -->
	</TABLE>
	<BR>
	<TABLE WIDTH="157" BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR>
<%
			'�̎�������ς͓����ł��Ȃ�
'### 2004/11/05 Updated by Ishihara@FSIT �����ς݂̏ꍇ�ɁA��������ɓ��������Ȃ��悤�ɂ���B
'			If vntPrintDate <> "" Then
			If (vntPrintDate <> "") Or (Trim(vntPaymentDate) <> "")  Then
'### 2004/11/05 Updated End
%>
				<TD NOWRAP><FONT COLOR="RED">���̎�������ς������͓����ς݂̏ꍇ�A�������̓����͂ł��܂���B</FONT></TD>
<%
			Else
                if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
				    <TD NOWRAP><A HREF="JavaScript:showMergeWindow();"><IMG SRC="/webHains/images/b_MergePerBill.gif" WIDTH="110" HEIGHT="24" ALT="���̐������𑼂̐������Ɠ������܂�"></A></TD>
<%
			    End If
            End If
%>
<!-- KMT
			<TD NOWRAP><A HREF="/webHains/contents/perbill/mergePerBill1.asp?dmddate=<%= strDmdDate %>&billseq=<%= lngBillSeq %>&branchno=<%= lngBranchNo %>">���̐������𑼂̐������Ɠ���</A></TD>
-->
		</TR>
	</TABLE>
	<BR>
<!-- ��f�ҏ��ҏW -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
		<TR BGCOLOR="SILVER" height="15">
			<TD NOWRAP height="15">��f��</TD>
			<TD NOWRAP height="15">��f�R�[�X</TD>
			<TD NOWRAP height="15">�\��ԍ�</TD>
			<TD NOWRAP height="15">�l�h�c</TD>
			<TD NOWRAP height="15">��f�Җ�</TD>
		</TR>
<%
		For i = 0 To lngCountCsl - 1
%>
			<TR>
				<TD NOWRAP height="15"><%= vntCslDate(i) %></TD>
				<TD NOWRAP height="15"><%= vntCsName(i) %></TD>
				<TD NOWRAP height="15"><A HREF="/webHains/contents/reserve/rsvMain.asp?rsvNo=<%= vntRsvNo(i) %>" TARGET="_blank"><%= vntRsvNo(i) %></A></TD>
				<TD NOWRAP height="15"><%= vntPerId(i) %></TD>
				<TD NOWRAP height="15"><B><%= vntLastName(i) & " " & vntFirstName(i) %></B> (<FONT SIZE="-1"><%= vntLastKname(i) & "�@" & vntFirstKName(i) %></FONT>)</TD>
			</TR>
<%
		Next
%>
<!-- ��f���ҏW -->
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
		<TR BGCOLOR="SILVER" height="15">
			<TD nowrap height="15">��f��</TD>
			<TD NOWRAP height="15">�������ז�</TD>
			<TD NOWRAP ALIGN="RIGHT" height="15">�@���z</TD>
			<TD NOWRAP ALIGN="RIGHT" height="15">�������z</TD>
			<TD NOWRAP ALIGN="RIGHT" height="15">�@�Ŋz</TD>
			<TD NOWRAP ALIGN="RIGHT" height="15">�����Ŋz</TD>
			<TD ALIGN="right" NOWRAP WIDTH="69" height="15">���v���z</TD>
		</TR>

<%
		strLastName = ""
		strFirstName = ""
		For i = 0 To lngCount - 1

			lngLineTotal = Clng(vntPrice(i)) +  Clng(vntEditPrice(i)) + Clng(vntTaxPrice(i)) +  Clng(vntEditTax(i))
%>
			<TR height="15">
				<INPUT TYPE="hidden" NAME="billNo" VALUE="315">
				<INPUT TYPE="hidden" NAME="seq" VALUE="">
<%
				'��f�Җ��̓C���f�B�P�C�g����B
				If ((strLastName = vntLastName_c(i)) AND (strFirstName = vntFirstName_c(i))) Then
%>
					<TD nowrap height="15"></TD>
<%
				Else
%>
					<TD nowrap height="15"><%= vntLastName_c(i) & " " & vntFirstName_c(i) %></TD>
<%
					'��f�Җ��L��
					strLastName = vntLastName_c(i)
					strFirstName = vntFirstName_c(i)
				End If

'### 2004/3/6 Added by Ishihara@FSIT ���ז��̏o���������{�I�ɂ��������̂ŏC���i���ז����D��j
%>
				<TD NOWRAP height="15"><%= IIf( vntLineName(i) <> "", vntLineName(i),  vntOtherLineName(i) ) %><FONT COLOR="#666666"></FONT></TD>
				<TD NOWRAP ALIGN="RIGHT" height="15"><%= FormatCurrency(vntPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT" height="15"><%= FormatCurrency(vntEditPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT" height="15"><%= FormatCurrency(vntTaxPrice(i)) %></TD>
				<TD NOWRAP ALIGN="RIGHT" height="15"><%= FormatCurrency(vntEditTax(i)) %></TD>
				<TD WIDTH="69" NOWRAP ALIGN="right" height="15"><%= FormatCurrency(lngLineTotal) %></TD>
			</TR>
<%
		Next
%>
		<TR height="1">
			<TD colspan="7" style="border-top: 1px solid #999" height="1"></TD>
		</TR>
		<TR height="15">
			<td 70" nowrap align="right" height="15"></td>
			<TD COLSPAN="1"70" NOWRAP ALIGN="right" height="15">���v</TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(vntPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(vntEditPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(vntTaxPriceTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><%= FormatCurrency(vntEditTaxTotal) %></TD>
			<TD NOWRAP ALIGN="right" height="15"><B><%= FormatCurrency(vntTotal) %></B></TD>
		</TR>
	</TABLE>

<!-- �������ҏW --><BR>
	<BR>
	<TABLE WIDTH="541" BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
<!-- �V�K�쐬��ʂɍ��킹��
			<TD NOWRAP WIDTH="100%"><FONT COLOR="#cc9999">��</FONT>&nbsp;�������</TD>
-->
			<TD NOWRAP WIDTH="100%"><FONT COLOR="#cc9999">��</FONT>
<!-- �ԋ������̂Ƃ��͕ԋ��ɂ���@2004.01.20  start -->
<%
				'�������`�[�̏ꍇ
				If lngBranchNo = 1 Then
%>
					<A HREF="JavaScript:IncomeWindow()">�ԋ����</A>
<%
				Else
%>
<!-- �ԋ������̂Ƃ��͕ԋ��ɂ���@2004.01.20  end -->
					<A HREF="JavaScript:IncomeWindow()">�������</A>
<!-- �ԋ������̂Ƃ��͕ԋ��ɂ���@2004.01.20  start -->
<%
				End If
%>
<!-- �ԋ������̂Ƃ��͕ԋ��ɂ���@2004.01.20  end -->
			</TD>
			<TD NOWRAP WIDTH="100%"></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="SILVER">
<!-- �ԋ������̂Ƃ��͕ԋ��ɂ���@2004.01.20  start -->
<%
			'�������`�[�̏ꍇ
			If lngBranchNo = 1 Then
%>
				<TD ALIGN="left" NOWRAP>�ԋ���</TD>
<%
			Else
%>
<!-- �ԋ������̂Ƃ��͕ԋ��ɂ���@2004.01.20  end -->
				<TD ALIGN="left" NOWRAP>������</TD>
<!-- �ԋ������̂Ƃ��͕ԋ��ɂ���@2004.01.20  start -->
<%
			End If
%>
<!-- �ԋ������̂Ƃ��͕ԋ��ɂ���@2004.01.20  end -->
			<TD NOWRAP>����</TD>
			<TD NOWRAP>�N���W�b�g</TD>
			<TD NOWRAP>J�f�r�b�h</TD>
			<TD NOWRAP>�n�b�s�[����</TD>
			<TD NOWRAP>���؎�E�t�����Y</TD>
<!-- �U���ݒǉ��@2003.12.25 -->
			<TD NOWRAP>�U����</TD>
			<TD NOWRAP>�I�y���[�^</TD>
		</TR>
<%
		If lngPaymentFlg = 0 Then
%>
			<TR>
<%
				'�������`�[�̏ꍇ
				If lngBranchNo = 1 Then
%>
					<TD NOWRAP><B>�ԋ�����Ă��܂���B</B></TD>
<%
				Else
%>
					<TD NOWRAP><B>��������Ă��܂���B</B></TD>
<%
				End If
%>
			</TR>
<%
		Else
%>
			<TR>
				<TD NOWRAP ALIGN="left"><A HREF="JavaScript:IncomeWindow();"><%= vntPaymentDate %></A></TD>
<!-- KMT
				<TD NOWRAP ALIGN="left"><A HREF="perBillIncome.asp?rsvno=<%= lngRsvNo %>&dmddate=<%= strDmdDate %>&billseq=<%= lngBillSeq %>&branchno=<%= lngBranchNo %>" TARGET="_blank"><%= vntPaymentDate %></A></TD>
-->
<!--
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntCredit <> "", FormatCurrency(vntPriceTotal_Pay), "") %></B></TD>
-->
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntCredit <> "", FormatCurrency(vntCredit), "") %></B></FONT></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntCard <> "", FormatCurrency(vntCard), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntJdebit <> "", FormatCurrency(vntJdebit), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntHappy_ticket <> "", FormatCurrency(vntHappy_ticket), "") %></B></TD>
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntCheque <> "", FormatCurrency(vntCheque), "") %></B></TD>
<!-- �U���݁@�ǉ� 2003.12.25 -->
				<TD NOWRAP ALIGN="right"><B><%= IIf( vntTransfer <> "", FormatCurrency(vntTransfer), "") %></B></TD>
				<TD NOWRAP ALIGN="left"><%= vntUserName %></TD>
			</TR>
<%
		End If
%>
	</TABLE>
	<BR>
	<TABLE WIDTH="109" BORDER="0" CELLSPACING="2" CELLPADDING="0">
<%
		'������`�[�͎�����{�^����\��
 		If vntDelFlg <> 1 Then
%>
			<TR>
				<% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
                    <TD NOWRAP>
					<A HREF="JavaScript:deleteData()"><IMG SRC="/webHains/images/b_delPerBill.gif" WIDTH="110" HEIGHT="24" ALT="���̐�������������"></A>
				    </TD>
                <% End If %>
			</TR>
<%
		End If
%>
	</TABLE>
	<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->

</BODY>
</HTML>
