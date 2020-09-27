<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(���x�z�̐ݒ�) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const ACTMODE_SAVE         = "save"	'���샂�[�h(�ۑ�)
Const ACTMODE_DELETE       = "del"	'���샂�[�h(�폜)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objContract			'�_����A�N�Z�X�p
Dim objContractControl	'�_����A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p

'�����l
Dim strActMode			'���샂�[�h

'�����l�i�_���{���j
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strLimitRate		'���x��
Dim lngLimitTaxFlg		'���x�z����Ńt���O
Dim strLimitPrice		'������z

'�����l�i���S�����j
Dim strSeq				'�r�d�p
Dim strApDiv			'�K�p���敪
Dim strBdnOrgCd1		'�c�̃R�[�h�P
Dim strBdnOrgCd2		'�c�̃R�[�h�Q
Dim strOrgSName			'�c�̗���
Dim strLimitPriceFlg	'�c�̖�

Dim strSeqOrg			'�Ώە��S���r�d�p
Dim strSeqBdnOrg		'���Z�������z�̕��S���r�d�p

Dim strMyOrgSName		'�c�̗���
Dim strMessage			'�G���[���b�Z�[�W
Dim strHTML				'HTML�ҏW�p
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strActMode     = Request("actMode")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCtrPtCd     = Request("ctrPtCd")
strLimitRate   = Request("limitRate")
lngLimitTaxFlg = CLng("0" & Request("limitTaxFlg"))
strLimitPrice  = Request("limitPrice")
strSeq         = ConvIStringToArray(Request("seq"))
strBdnOrgCd1   = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2   = ConvIStringToArray(Request("bdnOrgCd2"))
strOrgSName    = ConvIStringToArray(Request("orgSName"))
strSeqOrg      = Request("seqOrg")
strSeqBdnOrg   = Request("seqBdnOrg")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'���샂�[�h���Ƃ̐���
	Select Case strActMode

		'�폜�{�^��������
		Case ACTMODE_DELETE

			'���x�z���̍X�V(�S�l�N���A)
			If objContractControl.UpdateLimitPrice(strOrgCd1 ,strOrgCd2, strCtrPtcd, Empty, Empty, Empty, "", "", 1, 0, "") <> 0 then
				strMessage = "���̌_����̕��S�����͕ύX����Ă��܂��B�X�V�ł��܂���B"
				Exit Do
			End If

			'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End

		'�ۑ��{�^��������
		Case ACTMODE_SAVE

			'���̓`�F�b�N
			strMessage = CheckValue()
			If Not IsEmpty(strMessage) Then
				Exit Do
			End If

			'���x�z���̍X�V
			If objContractControl.UpdateLimitPrice(strOrgCd1 ,strOrgCd2, strCtrPtcd, strSeq, strBdnOrgCd1, strBdnOrgCd2, strSeqOrg, strLimitRate, lngLimitTaxFlg, IIf(strLimitPrice <> "", strLimitPrice, "0"), strSeqBdnOrg) <> 0 then
				strMessage = "���̌_����̕��S�����͕ύX����Ă��܂��B�X�V�ł��܂���B"
				Exit Do
			End If

			'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End

	End Select

	'�_��p�^�[�����̓ǂݍ���
	If objContract.SelectCtrPt(strCtrPtCd, , , , , , , , strLimitRate, lngLimitTaxFlg, strLimitPrice) = False Then
		Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
	End If

	'���S������ь��x�z���S�t���O�̓ǂݍ���
	If objContract.SelectCtrPtOrgPrice(strCtrPtCd, , , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, , strOrgSName, , , , , , , , , , , strLimitPriceFlg) <= 0 Then
		Err.Raise 1000, ,"�_��p�^�[�����S����񂪑��݂��܂���B"
	End If

	'���S�����̌���
	For i = 0 To UBound(strSeq)

		'�_��c�̎��g�̏ꍇ�͒c�̖��̂��擾
		If strApDiv(i) = CStr(APDIV_MYORG) Then
			objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , strMyOrgSName
			strOrgSName(i) = strMyOrgSName
		End If

		'���x�z���S�t���O�l�̕ϊ�
		Select Case strLimitPriceFlg(i)
			Case "0"
				strSeqOrg = strSeq(i)
			Case "1"
				strSeqBdnOrg = strSeq(i)
		End Select
	Next

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ : �G���[���b�Z�[�W�̔z��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X

	Dim strArrMessage	'�G���[���b�Z�[�W�̔z��
	Dim strMessage		'�G���[���b�Z�[�W

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'���ׂĖ����͂Ȃ�΃`�F�b�N�s�v
	If strSeqOrg = "" And strLimitRate = "" And strLimitPrice = "" And strSeqBdnOrg = "" Then
		Exit Function
	End If

	'�Ώە��S���̃`�F�b�N
	If strSeqOrg = "" Then
		objCommon.AppendArray strArrMessage, "�Ώە��S����ݒ肵�Ă��������B"
	End If

	'���x���`�F�b�N
	Do

		If strLimitRate = "" Then
			objCommon.AppendArray strArrMessage, "���x����ݒ肵�Ă��������B"
			Exit Do
		End If

		'���l�`�F�b�N
		strMessage = objCommon.CheckNumeric("���x��", strLimitRate, 3)
		If strMessage <> "" Then
			objCommon.AppendArray strArrMessage, strMessage
			Exit Do
		End If

		'���x���͂P�O�O���܂�
		If CLng(strLimitRate) > 100 Then
			objCommon.AppendArray strArrMessage, "���x���̒l������������܂���B"
		End If

		Exit Do
	Loop

	'������z�`�F�b�N
	objCommon.AppendArray strArrMessage, objCommon.CheckNumeric("������z", strLimitPrice, 7)

	'���Z�������z�̕��S���̃`�F�b�N
	If strSeqBdnOrg = "" Then
		objCommon.AppendArray strArrMessage, "���Z�������z�̕��S����ݒ肵�Ă��������B"
	End If

	'�Ƃ��ɐݒ肳��Ă���ꍇ�A�����ɓ������S���͐ݒ�ł��Ȃ�
	If strSeqOrg <> "" And strSeqBdnOrg <> "" And strSeqOrg = strSeqBdnOrg Then
		objCommon.AppendArray strArrMessage, "�Ώە��S���A���Z�������z�̕��S���ɓ����l��ݒ肷�邱�Ƃ͂ł��܂���B"
	End If

	'�`�F�b�N���ʂ�Ԃ�
	CheckValue = strArrMessage

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>���x�z�̐ݒ�</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
function submitForm( actMode ) {

	// �폜���̓��b�Z�[�W��\������
	if ( actMode == '<%= ACTMODE_DELETE %>' ) {
		if ( !confirm('���̌��x�z�����폜���܂��B��낵���ł����H') ) {
			return;
		}
	}

	document.entryForm.actMode.value = actMode;
	document.entryForm.submit();
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="actMode" VALUE="">
	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">
<%
	For i = 0 To UBound(strSeq)
%>
	<INPUT TYPE="hidden" NAME="seq"       VALUE="<%= strSeq(i)       %>">
	<INPUT TYPE="hidden" NAME="bdnOrgCd1" VALUE="<%= strBdnOrgCd1(i) %>">
	<INPUT TYPE="hidden" NAME="bdnOrgCd2" VALUE="<%= strBdnOrgCd2(i) %>">
	<INPUT TYPE="hidden" NAME="orgSName"  VALUE="<%= strOrgSName(i)  %>">
<%
	Next
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">���x�z�̐ݒ�</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	EditMessage strMessage, MESSAGETYPE_WARNING
%>
	<BR>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
                <A HREF="javascript:submitForm('<%= ACTMODE_DELETE %>')"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="�폜"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
            </TD>

			
            <TD>
            <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <A HREF="javascript:javascript:submitForm('<%= ACTMODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
            <%  else    %>
                 &nbsp;
            <%  end if  %>
            <% '2005.08.22 �����Ǘ� Add by ���@--- END %>
            </TD>
			
            
            <TD><A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A></TD>
		</TR>
	</TABLE>
	<BR>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD>�Ώە��S��</TD>
			<TD>�F</TD>
			<TD><%= EditDropDownListFromArray("seqOrg", strSeq, strOrgSName, strSeqOrg, NON_SELECTED_ADD) %></TD>
		</TR>
		<TR>
			<TD>���x�z</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP>�����z�ɑ΂�����x��</TD>
						<TD><INPUT TYPE="text" NAME="limitRate" SIZE="4" MAXLENGTH="3" STYLE="text-align:right;ime-mode:disabled;" VALUE="<%= strLimitRate %>"></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD></TD><TD></TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD NOWRAP>�����z�F</TD>
						<TD><INPUT TYPE="radio" NAME="limitTaxFlg" VALUE="1"<%= IIf(lngLimitTaxFlg = 1, " CHECKED", "") %>></TD>
						<TD NOWRAP>����ł��܂�
						<TD><INPUT TYPE="radio" NAME="limitTaxFlg" VALUE="0"<%= IIf(lngLimitTaxFlg = 0, " CHECKED", "") %>></TD>
						<TD NOWRAP>����ł��܂܂Ȃ�</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>������z</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="text" NAME="limitPrice" SIZE="11" MAXLENGTH="7" STYLE="text-align:right;ime-mode:disabled;" VALUE="<%= strLimitPrice %>"></TD>
						<TD>�~</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>���Z�������z�̕��S��</TD>
			<TD>�F</TD>
			<TD><%= EditDropDownListFromArray("seqBdnOrg", strSeq, strOrgSName, strSeqBdnOrg, NON_SELECTED_ADD) %></TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>