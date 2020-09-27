<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       �������폜 (Ver1.0.0)
'       AUTHER  : Ishihara@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditBillClassList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�����l
Dim strAction				'�������(�����{�^��������"select")
Dim lngYear					'�\���J�n�N
Dim lngMonth				'�\���J�n��
Dim lngDay					'�\���J�n��
Dim strOrgCd1				'�c�̃R�[�h�P
Dim strOrgCd2				'�c�̃R�[�h�Q
'Dim strIsDeleteHand			'�蓮�쐬�f�[�^�̍폜�L��
'Dim strIsDeletePayment		'�����ς݃f�[�^�̍폜�L��

Dim strDate					'���t
Dim strOrgName				'�c�̖���

Dim objDemand				'�������A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objOrganization			'�c�̏��A�N�Z�X�pCOM�I�u�W�F�N�g

Dim strArrMessage			'���b�Z�[�W
Dim lngMessageIcon			'���b�Z�[�W�p�A�C�R��
Dim lngDeleteCount			'�폜�ς݌���
Dim i						'�C���f�b�N�X
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strAction          = Request("act")
lngYear            = CLng("0" & Request("strYear"))
lngMonth           = CLng("0" & Request("strMonth"))
lngDay             = CLng("0" & Request("strDay"))
strOrgCd1          = Request("orgCd1")
strOrgCd2          = Request("orgCd2")
'strIsDeleteHand    = Request("IsDeleteHand")
'strIsDeletePayment = Request("IsDeletePayment")
strArrMessage      = ""

'���w�莞�͏����l�Z�b�g
lngYear    = IIf(lngYear  = 0, Year(Now),    lngYear )
lngMonth   = IIf(lngMonth = 0, Month(Now),   lngMonth)
lngDay     = IIf(lngDay   = 0, Day(Now),     lngDay  )
strDate    = lngYear & "/" & lngMonth & "/" & lngDay

'�c�̖��̎擾
If strOrgCd1 <> "" And strOrgCd2 <> "" Then
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	Call objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName)
	Set objOrganization = Nothing
End If

Do

	'��������
	If strAction = "delete" Then
		lngMessageIcon = MESSAGETYPE_WARNING

		'���͓��t�̃`�F�b�N
		If Not IsDate(strDate) Then
			strArrMessage = "���ߓ��̓��͌`��������������܂���B"
			Exit Do
		End If

		'�����ɍ��v���鐿����������
		Set objDemand = Server.CreateObject("HainsDemand.Demand")
		lngDeleteCount = objDemand.DeleteAllBill(strDate, strOrgCd1, strOrgCd2)
'		lngDeleteCount = objDemand.DeleteAllBill(strDate, strOrgCd1, strOrgCd2, strIsDeleteHand, strIsDeletePayment)
		If lngDeleteCount < 0 Then
			strArrMessage = "�������폜�����Ɏ��s���܂����B"
			strAction = "error"
		Else
			strArrMessage = lngDeleteCount & "���̐��������폜���܂����B"
			lngMessageIcon = MESSAGETYPE_NORMAL
		End If
		Set objDemand = Nothing

	End If

	Exit Do

Loop

'�I�u�W�F�N�g�̃C���X�^���X�폜
Set objDemand = Nothing
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������폜</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winDmdPayment;				// �E�B���h�E�n���h��
var dmdPayment_CalledFunction;	// ����������Ăяo���֐�

// �c�̌����K�C�h�Ăяo��
function callOrgGuide() {

	orgGuide_showGuideOrg(document.entrycondition.orgCd1, document.entrycondition.orgCd2, 'orgName');

}

// �c�̃R�[�h�폜
function delOrgCd() {

	orgGuide_clearOrgInfo(document.entrycondition.orgCd1, document.entrycondition.orgCd2, 'orgName');

}
// �����{�^���������̏���
function submitSearch() {

	if ( !confirm( '�w�肳�ꂽ�����Ő��������폜���܂��B��낵���ł����H' ) ) {
		return;
	}
	document.entrycondition.act.value = 'delete';
	document.entrycondition.submit();

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entrycondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<INPUT TYPE="hidden" NAME="act" VALUE="">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�������폜</FONT></B></TD>
	</TR>
</TABLE>
<%
	If strArrMessage <> "" Then
		Call EditMessage(strArrMessage, lngMessageIcon)
	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD WIDTH="10"></TD>
		<TD HEIGHT="27">���ߓ�</TD>
		<TD>�F</TD>
		<TD COLSPAN="5">
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("strMonth", 1, 12, lngMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("strDay", 1, 31, lngDay, False) %></TD>
					<TD>��</TD>
				</TR>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD WIDTH="10"></TD>
		<TD HEIGHT="27">������</TD>
		<TD>�F</TD>
		<TD COLSPAN="5">
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callOrgGuide()"><IMG SRC="../../images/question.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
					<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return delOrgCd()"><IMG SRC="../../images/delicon.gif" BORDER="0" WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
					<TD WIDTH="5"></TD>
					<TD><INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>"></TD>
					<TD><INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>"></TD>
					<TD WIDTH="400">
						<SPAN ID="orgName" STYLE="position:relative"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD WIDTH="10"></TD>
	</TR>
	<TR>
		<TD COLSPAN=8 ALIGN="right">
		<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
		<%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
			<A HREF="javascript:function voi(){};voi()" ONCLICK="return submitSearch()">
			<IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���������폜���܂��B">
			</A>
		<%  else    %>
			 &nbsp;
		<%  end if  %>
		<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
		</TD>
	</TR>
<!--
	<TR HEIGHT="21">
		<TD WIDTH="10"></TD>
		<TD WIDTH="70"></TD>
		<TD></TD>
		<TD><INPUT TYPE="CHECKBOX" VALUE="1" NAME="isDeleteHand">����͂ō쐬�������������폜����</TD>
	</TR>
	<TR HEIGHT="24">
		<TD WIDTH="10"></TD>
		<TD WIDTH="70"></TD>
		<TD></TD>
		<TD><INPUT TYPE="CHECKBOX" VALUE="1" NAME="isDeletePayment">�����ςݐ��������폜����</TD>
		<TD>
			<A HREF="javascript:function voi(){};voi()" ONCLICK="return submitSearch()">
			<IMG SRC="../../images/delete.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="���������폜���܂��B">
			</A>
		</TD>
	</TR>
</TABLE>
-->
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
