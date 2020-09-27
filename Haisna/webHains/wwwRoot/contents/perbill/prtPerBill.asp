<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�̎����E����������\�� (Ver0.0.1)
'		AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
'       �Ǘ��ԍ��FSL-UI-Y0101-239~240
'       �C����  �F2010.06.11
'       �S����  �FASC)����
'       �C�����e�FReport Designer��Co Reports�ɕύX
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objCommon				'���ʃN���X
Dim objPerbill				'��f���A�N�Z�X�p



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

'�l�����Ǘ����(BillNo)
Dim vntDelFlg				'������`�[�t���O
Dim vntPrintDate			'�̎��������
Dim vntBillName				'��������
Dim vntKeishou				'�h��

'�z��
Dim vntArrRsvNo()			'�\��ԍ�
Dim vntArrCslDate()			'��f��
Dim vntArrPerId()			'�l�h�c
Dim vntArrLastName			'��
Dim vntArrFirstName			'��
Dim vntArrLastKName()		'�J�i��
Dim vntArrFirstKName()		'�J�i��
Dim vntArrCsCd()			'�R�[�X�R�[�h
Dim vntArrCsName			'�R�[�X��
Dim vntArrDelFlg()			'������`�[�t���O
Dim vntArrPrintDate()		'�̎��������
Dim vntArrBillName			'��������
Dim vntArrKeishou			'�h��

Dim strPrintDate			'�̎��������

Dim vntDmdDate     		'������ �z��
Dim vntBillSeq     		'�������r���� �z��
Dim vntBranchNo     	'�������}�� �z��


Dim strReqDmdDate     	'������ Request
Dim strReqBillSeq     	'�������r���� Request
Dim strReqBranchNo     	'�������}�� Request

Dim strArrKeishou()			'�h�́@�z��
Dim strArrKeishouName()		'�h�́i�\���p�j�@�z��

Dim strAct  			'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strMessage			'�G���[���b�Z�[�W
Dim i					'�C���f�b�N�X

Dim lngPrtKbn			'����Ώ�

Dim strHTML

Dim strReqDisp			'�Ăяo������ʖ�

'#### 2010.06.11 SL-UI-Y0101-239~240 ADD START ####'
Dim objPrintCls			'�������A�̎����쐬�p
Dim lngRet				'�v�����gSEQ
Dim vntFileName()		'���[�t�@�C����
Dim intCnt				'�C���f�b�N�X
'#### 2010.06.11 SL-UI-Y0101-239~240 ADD END ####'

strMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objPerbill = Server.CreateObject("HainsPerBill.PerBill")

'�����l�̎擾


strReqDmdDate     = Request("reqdmddate")
strReqBillSeq     = Request("reqbillseq")
strReqBranchNo    = Request("reqbranchno")

strAct            = Request("act")

strReqDisp        = Request("reqDisp")

lngPrtKbn         = Request("prtKbn")
lngPrtKbn = IIf( lngPrtKbn = "", "1", lngPrtKbn )

vntArrLastName	  = ConvIStringToArray(Request("lastName"))
vntArrFirstName	  = ConvIStringToArray(Request("firstName"))
vntArrCsName	  = ConvIStringToArray(Request("csName"))
vntArrBillName    = ConvIStringToArray(Request("billName"))
vntArrKeishou     = ConvIStringToArray(Request("keishou"))

'�h�̔z��̍쐬
Call CreateKeishouInfo

Do

	vntDmdDate = Split(strReqDmdDate,",")
	vntBillSeq = Split(strReqBillSeq,",")
	vntBranchNo = Split(strReqBranchNo,",")

	'�ۑ��{�^��������
	If strAct = "save" Then
		'���̓`�F�b�N
		strMessage = CheckValue()
		If Not IsEmpty(strMessage) Then
			Exit Do
		End If
		For i = 0 To UBound(vntDmdDate)
			'�����̕ۑ�
			Ret = objPerBill.UpdatePerBill( _
								vntDmdDate(i), vntBillSeq(i), vntBranchNo(i), _
								vntArrBillName(i), vntArrKeishou(i) )

			'�ۑ��Ɏ��s�����ꍇ
			If Ret <> True Then
				objCommon.AppendArray strMessage, "�ۑ��Ɏ��s���܂��� ( " & objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) & " )"
				Exit Do
			End If
		Next
		strAct = "saveend"
	End If

	'�ۑ����Ĉ���܂��͈���{�^��������
	If strAct = "saveprt" Or strAct = "print" Then
		'�ۑ����Ĉ��
		If strAct = "saveprt" Then
			'���̓`�F�b�N
			strMessage = CheckValue()
			If Not IsEmpty(strMessage) Then
				Exit Do
			End If
			'�̎������
			If lngPrtKbn = "1" Then
				'�̎���������̕ҏW
				strPrintDate = CStr(Year(Now)) & "/" & CStr(Month(Now)) & "/" & CStr(Day(Now))
				For i = 0 To UBound(vntDmdDate)
					'����, �̎���������̕ۑ�
					Ret = objPerBill.UpdatePerBill( _
								vntDmdDate(i), vntBillSeq(i), vntBranchNo(i), _
								vntArrBillName(i), vntArrKeishou(i), strPrintDate )
					'�ۑ��Ɏ��s�����ꍇ
					If Ret <> True Then
						objCommon.AppendArray strMessage, "�ۑ��Ɏ��s���܂��� ( " & objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) & " )"
						Exit Do
					End If
				Next
			Else
				For i = 0 To UBound(vntDmdDate)
					'�����̕ۑ�
					Ret = objPerBill.UpdatePerBill( _
								vntDmdDate(i), vntBillSeq(i), vntBranchNo(i), _
								vntArrBillName(i), vntArrKeishou(i) )
					'�ۑ��Ɏ��s�����ꍇ
					If Ret <> True Then
						objCommon.AppendArray strMessage, "�ۑ��Ɏ��s���܂��� ( " & objCommon.FormatString(vntDmdDate(i), "yyyymmdd") & objCommon.FormatString(vntBillSeq(i), "00000") & vntBranchNo(i) & " )"
						Exit Do
					End If
				Next
			End If
		End If

'#### 2010.06.11 SL-UI-Y0101-239~240 MOD START ####'
'		'�G���[���Ȃ���Έ���݂̂��s��HTML��ҏW���A�����㎩�g��CLOSE���Ăяo�������ĕ\���B
'		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
'		strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
'		strHTML = strHTML & vbCrLf & "<!--"
'		For i = 0 To UBound(vntDmdDate)
'			strHTML = strHTML & vbCrLf & "var url = '/webHains/contents/report_form/rd_18_prtBill.asp';"
'			strHTML = strHTML & vbCrLf & "url = url + '?p_Uid='      + '" & Session("USERID") & "';"
'			strHTML = strHTML & vbCrLf & "url = url + '&p_ScslDate=' + '" & vntDmdDate(i) & "';"
'			strHTML = strHTML & vbCrLf & "url = url + '&p_BilSeq='   + '" & vntBillSeq(i) & "';"
'			strHTML = strHTML & vbCrLf & "url = url + '&p_BilBan='   + '" & vntBranchNo(i) & "';"
'			strHTML = strHTML & vbCrLf & "url = url + '&p_Option='   + '" & lngPrtKbn & "';"
'			strHTML = strHTML & vbCrLf & "open( url );"
'		Next
''		strHTML = strHTML & vbCrLf & "top.location.replace('" & strURL & "');"
'		strHTML = strHTML & vbCrLf & "//-->"
'		strHTML = strHTML & vbCrLf & "</SCRIPT>"
'		' �Ăяo�������������@
'		If strReqDisp = "perBillIncome" Then
'			strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
'		Else
'			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
'		End If
'		strHTML = strHTML & "</BODY>"
'		strHTML = strHTML & vbCrLf & "</HTML>"
'		Response.Write strHTML
'		Response.End

		'���������
		if lngPrtKbn = 0 Then

			'���R�����΍��p���O�����o��
			Call putPrivacyInfoLog("PH045", "�l��������� �������̈�����s����")

			'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
			Set objPrintCls = Server.CreateObject("HainsprtBill.prtBill")
		'�̎������
		Else

			'���R�����΍��p���O�����o��
			Call putPrivacyInfoLog("PH046", "�l��������� �̎����̈�����s����")

			'�I�u�W�F�N�g�̃C���X�^���X�쐬�i�v���W�F�N�g��.�N���X���j
			Set objPrintCls = Server.CreateObject("HainsprtReceipt.prtReceipt")
		End If

		Redim vntFileName(1)

		'��������Ή��̂��߁Aprint.inc�͖��g�p
		For intCnt = 0 To UBound(vntDmdDate)
			Redim Preserve vntFileName(intCnt + 1)
			'���[�쐬�i�쐬�����v�����gSEQ�A���[�t�@�C�������擾�j
			lngRet = objPrintCls.PrintOut(Session("USERID"), vntDmdDate(intCnt), vntBillSeq(intCnt), vntBranchNo(intCnt), vntFileName(intCnt))
			If lngRet < 1 Then
				objCommon.AppendArray strMessage, "�f�[�^������܂���ł����B ( " & objCommon.FormatString(vntDmdDate(intCnt), "yyyymmdd") & _
						objCommon.FormatString(vntBillSeq(intCnt), "00000") & vntBranchNo(intCnt) & " )"
				Exit Do
			End If
		Next

		'�G���[���Ȃ���Έ���݂̂��s��HTML��ҏW���A�����㎩�g��CLOSE���Ăяo�������ĕ\���B
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
		strHTML = strHTML & vbCrLf & "<!--"
		'���[�̐����A�E�C���h�E��\��
		For intCnt = 0 To UBound(vntDmdDate)
			strHTML = strHTML & vbCrLf & "var url = '/webHains/contents/print/prtPreview.asp?documentFileName=" & vntFileName(intCnt) & "';"
			strHTML = strHTML & vbCrLf & "open( url );"
		Next
		strHTML = strHTML & vbCrLf & "//-->"
		strHTML = strHTML & vbCrLf & "</SCRIPT>"
		' �Ăяo�������������
		If strReqDisp = "perBillIncome" Then
			strHTML = strHTML & "<BODY ONLOAD=""javascript:close()"">"
		Else
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
		End If
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & vbCrLf & "</HTML>"
		Response.Write strHTML
		Response.End
'#### 2010.06.11 SL-UI-Y0101-239~240 MOD END ####'

	End If


	Redim Preserve vntArrRsvNo(UBound(vntDmdDate))			
	Redim Preserve vntArrCslDate(UBound(vntDmdDate))			
	Redim Preserve vntArrPerId(UBound(vntDmdDate))			
	vntArrLastName = Array()
	Redim Preserve vntArrLastName(UBound(vntDmdDate))			
	vntArrFirstName = Array()
	Redim Preserve vntArrFirstName(UBound(vntDmdDate))		
	Redim Preserve vntArrLastKName(UBound(vntDmdDate))		
	Redim Preserve vntArrFirstKName(UBound(vntDmdDate))		
	Redim Preserve vntArrCsCd(UBound(vntDmdDate))				
	vntArrCsName = Array()
	Redim Preserve vntArrCsName(UBound(vntDmdDate))			
	Redim Preserve vntArrDelFlg(UBound(vntDmdDate))			
	Redim Preserve vntArrPrintDate(UBound(vntDmdDate))
	vntArrBillName = Array()
	vntArrKeishou = Array()
	Redim Preserve vntArrBillName(UBound(vntDmdDate))			
	Redim Preserve vntArrKeishou(UBound(vntDmdDate))			
	For i = 0 To UBound(vntDmdDate)
		'�������m������\��ԍ����擾�����ꂼ��̎�f�����擾����
		lngCountCsl = objPerbill.SelectPerBill_csl(vntDmdDate(i), _
											vntBillSeq(i), _
											vntBranchNo(i), _
											vntRsvNo, _
											vntCslDate, _
											vntPerId, _
											vntLastName, _
											vntFirstName, _
											vntLastKName, _
											vntFirstKName, _
											vntCsCd, _
											vntCsName )
		'��f��񂪑��݂���ꍇ
		If lngCountCsl > 0 Then
			vntArrRsvNo(i)		= vntRsvNo(0)
            vntArrCslDate(i)	= vntCslDate(0)
            vntArrPerId(i)		= vntPerId(0)
            vntArrLastName(i)	= vntLastName(0)
            vntArrFirstName(i)	= vntFirstName(0)
            vntArrLastKName(i)	= vntLastKName(0)
            vntArrFirstKName(i)	= vntFirstKName(0)
            vntArrCsCd(i)		= vntCsCd(0)
            vntArrCsName(i)		= vntCsName(0)
		End If



		'�l�����Ǘ����̎擾
		''' ����A�h�̂�ǉ� 2003.12.19
		Ret = objPerbill.SelectPerBill_BillNo(vntDmdDate(i), _
											vntBillSeq(i), _
											vntBranchNo(i), _
											vntDelFlg, _
											, , , _
											, _
											, _
											, _
                                            , _
											, _
											, _
											, _
											, _
											, _
											vntPrintDate, _
											vntBillName, _
											vntKeishou )
		If Ret = True Then
            vntArrDelFlg(i)		= vntDelFlg
            vntArrPrintDate(i)	= vntPrintDate
            vntArrBillName(i)	= vntBillName
            vntArrKeishou(i)	= vntKeishou
		End If
	Next


	Exit Do
Loop
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���͂̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()
	Dim vntArrMessage	'�G���[���b�Z�[�W�̏W��
	Dim strMessage		'�G���[���b�Z�[�W

	'�e�l�`�F�b�N����
	With objCommon

		For i = 0 To UBound(vntDmdDate)
			'����
			vntArrBillName(i) = .StrConvKanaWide( vntArrBillName(i) )

			strMessage = .CheckWideValue("����", vntArrBillName(i), 100)

			If strMessage <> "" Then
				.AppendArray vntArrMessage, strMessage
			End If
		Next

	End With

	'�߂�l�̕ҏW
	If IsArray(vntArrMessage) Then
		CheckValue = vntArrMessage
	End If

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �h�̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateKeishouInfo()

	Redim Preserve strArrKeishou(1)
	Redim Preserve strArrKeishouName(1)

	strArrKeishou(0) = "�l":strArrKeishouName(0) = "�l"
	strArrKeishou(1) = "�䒆":strArrKeishouName(1) = "�䒆"

End Sub

%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�̎����E���������</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--


//����Ώۃ`�F�b�N
function checkPrtKbnAct(index) {

	with ( document.entryForm ) {
		prtKbn.value = index;
		chkPrtKbn.value = index;
	}

}

// �����ۑ�
function saveBillName() {

	// ����ʂ𑗐M
	document.entryForm.act.value = 'save';
	document.entryForm.submit();

//	return false;
}

// �ۑ����Ĉ��
function savePrint() {


	// ����ʂ𑗐M
	document.entryForm.act.value = 'saveprt';
	document.entryForm.submit();

	return false;
}

// ���
function printFunc() {


	// ����ʂ𑗐M
	document.entryForm.act.value = 'print';
	document.entryForm.submit();

	return false;
}


// �E�C���h�E�N���[�Y
function windowClose() {



	return false;
}

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
	<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN>�̎����E���������</B></TD>
		</TR>
	</TABLE>
	<INPUT TYPE="hidden" NAME="act" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="reqDisp" VALUE="<%= strReqDisp %>">
	<INPUT TYPE="hidden" NAME="reqdmddate" VALUE="<%= strReqDmdDate %>">
	<INPUT TYPE="hidden" NAME="reqbillseq" VALUE="<%= strReqBillSeq %>">
	<INPUT TYPE="hidden" NAME="reqbranchno" VALUE="<%= strReqBranchNo %>">
<%
	'���b�Z�[�W�̕ҏW
	If strAct <> "" Then

		Select Case strAct

			'�ۑ��������́u�ۑ������v�̒ʒm
			Case "saveend"
				Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)


			'�����Ȃ��΃G���[���b�Z�[�W��ҏW
			Case Else
				Call EditMessage(strMessage, MESSAGETYPE_WARNING)

		End Select

	End If
%>
	<BR>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR><!-- �C���� -->
			<% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
                <TD><A HREF="javascript:saveBillName()"><IMG SRC="/webHains/images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="��������ۑ����܂�"></A></TD>
                <TD WIDTH="10"></TD>
                <TD><A HREF="javascript:savePrint()"><IMG SRC="/webHains/images/prtsave.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="������ۑ����Ĉ�����܂��B"></A></TD>
                <TD WIDTH="10"></TD>
                <TD><A HREF="javascript:printFunc()"><IMG SRC="/webHains/images/print.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="����̂ݎ��s"></A></TD>
             <% End If %>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<TR BGCOLOR="#DDDDDD">
			<TD NOWRAP>&nbsp;</TD>
			<TD NOWRAP>����</TD>
			<TD NOWRAP>�h��</TD>
		</TR>
<%
		For i = 0 To UBound(vntDmdDate)
			'�����w��Ȃ��H
			If vntArrBillName(i) = "" Then
				vntArrBillName(i) = vntArrLastName(i) & " " & vntArrFirstName(i)
			End If
%>
			<INPUT TYPE="hidden" NAME="lastName" VALUE="<%= vntArrLastName(i) %>">
			<INPUT TYPE="hidden" NAME="firstName" VALUE="<%= vntArrFirstName(i) %>">
			<INPUT TYPE="hidden" NAME="csName" VALUE="<%= vntArrCsName(i) %>">
			<TD NOWRAP><%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %>�@<%= vntArrCsName(i) %>�@<%= vntArrLastName(i) %> <%= vntArrFirstName(i) %></TD>
			<TD><INPUT TYPE="text" NAME="billName" VALUE="<%= vntArrBillName(i) %>" SIZE="42" MAXLENGTH="50"></TD>
			<TD WIDTH="69"><%= EditDropDownListFromArray("keishou", strArrKeishou, strArrKeishouName, vntArrKeishou(i), NON_SELECTED_DEL) %></TD>
		</TR>
<%
		Next
%>
	</TABLE>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<tr height="12">
			<td height="12"></td>
			<td height="12"></td>
			<td height="12"></td>
			<td width="69" height="12"></td>
		</tr>
		<TR>
			<INPUT TYPE="hidden" NAME="prtKbn" VALUE="<%= lngPrtKbn %>">
			<TD WIDTH="49">���</TD>
			<TD>�F</TD>
			<TD COLSPAN="2" NOWRAP>
				<INPUT TYPE="radio" NAME="chkPrtKbn" VALUE="<%= lngPrtKbn %>" <%= IIf(lngPrtKbn = "1", " CHECKED", "") %> ONCLICK="javascript:checkPrtKbnAct('1')"  BORDER="0">�̎�������@
				<INPUT TYPE="radio" NAME="chkPrtKbn" VALUE="<%= lngPrtKbn %>" <%= IIf(lngPrtKbn = "0", " CHECKED", "") %> ONCLICK="javascript:checkPrtKbnAct('0')"  BORDER="0">���������
		</TR>
	</TABLE>
	<BR>
	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>

</BODY>
</HTML>
