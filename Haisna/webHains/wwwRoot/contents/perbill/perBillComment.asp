<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�������R�����g (Ver0.0.1)
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
Dim objPerbill				'��f���A�N�Z�X�p

Dim strDmdDate				'������
Dim lngBillSeq				'�������r����
Dim lngBranchNo				'�������}��
Dim strBillComent			'�������R�����g

Dim Ret						'�֐��߂�l

'�l�����Ǘ����(BillNo)
Dim vntDelFlg				'������`�[�t���O
'Dim vntIcomeDate			'�X�V����
'Dim vntUserId				'���[�U�h�c
'Dim vntUserName			'���[�U��������
'Dim vntBillcoment			'�������R�����g
Dim vntPaymentDate			'������
Dim vntPaymentSeq			'�����r����
Dim vntPriceTotal			'���z�i���������v�j
Dim vntEditPriceTotal		'�������z�i���������v�j
Dim vntTaxPriceTotal		'�Ŋz�i���������v�j
Dim vntEditTaxTotal			'�����Ŋz�i���������v�j
Dim vntTotal				'���v�i���������v�j
Dim vntTaxTotal				'�ō��v�i���������v�j


Dim strMode					'�������[�h
Dim strActMode				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strMessage				'�G���[���b�Z�[�W
Dim i						'�C���f�b�N�X
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
strBillComent  = Request("coment")

strActMode     = Request("act")
strMode        = Request("mode")


'�p�����^�̃f�t�H���g�l�ݒ�
'	lngRsvNo   = IIf(IsNumeric(lngRsvNo) = False, 0,  lngRsvNo )

Do

	'�ۑ��{�^��������
	If strActMode = "save" Then

		'���̓`�F�b�N
		strMessage = CheckValue()
		If strMessage <> "" Then
			Exit Do
		End If

		'�l�����Ǘ����̎擾
		Ret = objPerbill.UpdatePerBill_coment(strDmdDate, _
												lngBillSeq, _
												lngBranchNo, _
												strBillComent )
		'�ۑ��Ɏ��s�����ꍇ
		If Ret <> True Then
			srtMessage = "�������R�����g�̕ۑ��Ɏ��s���܂���"
'			Err.Raise 1000, , "�������R�����g���ۑ��ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
			Exit Do
		Else
			'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
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


	'�l�����Ǘ����̎擾
	Ret = objPerbill.SelectPerBill_BillNo(strDmdDate, _
											lngBillSeq, _
											lngBranchNo, _
											, , , , _
											strBillComent, _
											vntPaymentDate, _
											vntPaymentSeq, _
                                            vntPriceTotal, _
											vntEditPriceTotal, _
											vntTaxPriceTotal, _
											vntEditTaxTotal, _
											vntTotal, _
											vntTaxTotal )
	'��f��񂪑��݂��Ȃ��ꍇ
	If Ret <> True Then
		Err.Raise 1000, , "�l�����Ǘ���񂪎擾�ł��܂���B�i������No�@= " & objCommon.FormatString(strDmdDate, "yyyymmdd") & objCommon.FormatString(lngBillSeq, "00000") & lngBranchNo &" )"
	End If

	Exit Do
Loop


'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �������R�����g�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X
	Dim strMessage		'�G���[���b�Z�[�W
	strMessage = ""

	'���ʃN���X�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�e�l�`�F�b�N����
	With objCommon
		'�������R�����g�`�F�b�N
		strMessage = .CheckWideValue("�������R�����g", strBillComent, 200)
	End With

	CheckValue = strMessage

End Function



%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�������R�����g</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �ۑ�
function saveData() {

	// ���[�h���w�肵��submit
	document.entryForm.act.value = 'save';
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

	<INPUT TYPE="hidden" NAME="dmddate" VALUE="<%= strDmdDate %>">
	<INPUT TYPE="hidden" NAME="billseq" VALUE="<%= lngBillSeq %>">
	<INPUT TYPE="hidden" NAME="branchno" VALUE="<%= lngBranchNo %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>�������R�����g</B></TD>
		</TR>
	</TABLE>
<%
'���b�Z�[�W�̕ҏW
	If strMessage <> "" Then
		Call EditMessage(strMessage, MESSAGETYPE_WARNING)
	End If

%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP>�R�����g</TD>
			<TD>�F</TD>
			<TD><TEXTAREA NAME="coment" ROWS="4" COLS="50"><%= strBillComent %></TEXTAREA></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>
			<TD ALIGN="right"><A HREF="javascript:saveData()"><IMG SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�ŕۑ�"></A></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
