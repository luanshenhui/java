<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�������R�����g (Ver0.0.1)
'		AUTHER  : M.Gouda@FSIT
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
Dim objDemand				'�����A�N�Z�X�pCOM�I�u�W�F�N�g

Dim strBillNo				'�������ԍ�
Dim strBillComment			'�������R�����g

'��������{���
Dim lngArrBillNo			'�������ԍ�
Dim strArrCloseDate			'���ߓ�
Dim strArrBillSeq			'�������r����
Dim strArrBranchno			'�������}��
Dim strArrOrgCd1			'�c�̃R�[�h�P
Dim strArrOrgCd2			'�c�̃R�[�h�Q
Dim strArrOrgName			'�c�̖�
Dim strArrOrgKName			'�c�̃J�i��
Dim strArrPrtDate			'�������o�͓�
Dim lngArrSumPriceTotal		'���v
Dim lngArrSumTaxTotal		'�Ŋz���v
Dim strArrSeq				'Seq
Dim strArrDispatchDate		'������
Dim strArrUpdUser			'�X�V��ID�i�����j
Dim strArrUserName			'�X�V�Җ��i�����j
Dim strArrUpdDate			'����`�[�t���O
Dim strArrDelFlg			'����`�[�t���O
Dim strArrBillComment		'�������R�����g

Dim Ret						'�֐��߂�l
Dim lngCount				'���R�[�h��

Dim strMode					'�������[�h
Dim strAction				'���샂�[�h(�ۑ�:"save"�A�ۑ�����:"saved")
Dim strMessage				'�G���[���b�Z�[�W
Dim i						'�C���f�b�N�X
Dim strHTML

strMessage = ""

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objDemand  = Server.CreateObject("HainsDemand.Demand")

'�����l�̎擾

strBillNo      = Request("billno")
strBillComment = Request("comment")

strAction      = Request("action")
strMode        = Request("mode")

Do
	
	'�ۑ��{�^��������
	If strAction = "save" Then

		'���̓`�F�b�N
		strMessage = CheckValue()
		If strMessage <> "" Then
			Exit Do
		End If

		'�c�̐������R�����g�̍X�V
		Ret = objDemand.UpdateDmdBill_comment(strBillNo, strBillComment)

		'�ۑ��Ɏ��s�����ꍇ
		If Ret <> True Then
			strMessage = "�������R�����g�̕ۑ��Ɏ��s���܂���"
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
	
	'�c�̐�������{���̎擾
	lngCount = objDemand.SelectDmdBurdenDispatch( _
								strBillNo, "", "", _
								lngArrBillNo, _
								strArrCloseDate, _
								strArrBillSeq, _
								strArrBranchno, _
								strArrOrgCd1, _
								strArrOrgCd2, _
								strArrOrgName, _
								strArrOrgKName, _
								strArrPrtDate, _
								lngArrSumPriceTotal, _
								lngArrSumTaxTotal, _
								strArrSeq, _
								strArrDispatchDate, _
								strArrUpdUser, _
								strArrUserName, _
								strArrUpdDate, _
								strArrDelFlg, _
								strArrBillComment)

	'��������{��񂪑��݂��Ȃ��ꍇ
	If lngCount = 0 Then
		Err.Raise 1000, , "�c�̐�������{��񂪎擾�ł��܂���B�i������No�@= " & lngBillNo &" )"
	End If
	
	strBillComment = strArrBillComment(0)

	'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̉��
	Set objDemand = Nothing
	Set objCommon = Nothing

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
		strMessage = .CheckWideValue("�������R�����g", strBillComment, 100)
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
	document.entryForm.action.value = 'save';
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 20px 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<INPUT TYPE="hidden" NAME="action" VALUE="">
	<INPUT TYPE="hidden" NAME="billno" VALUE="<%= strBillNo %>">

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
			<TD NOWRAP VALIGN="top">�R�����g</TD>
			<TD VALIGN="top">�F</TD>
			<TD><TEXTAREA NAME="comment" ROWS="4" COLS="50"><%= strBillComment %></TEXTAREA></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD></TD>

			<TD ALIGN="right">
			<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %> 
				<A HREF="javascript:saveData()"><IMG SRC="../../images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���̓��e�ŕۑ�"></A>
			<%  else    %>
				 &nbsp;
			<%  end if  %>
			<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
			</TD>

		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
