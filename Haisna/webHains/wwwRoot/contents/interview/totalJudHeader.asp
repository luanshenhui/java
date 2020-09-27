<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ��������i�w�b�_�j (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strAct				'�������
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strGrpCd			'�O���[�v�R�[�h
Dim strCsCd				'�R�[�X�R�[�h

Dim lngLastDspMode		'�O���\�����[�h�i0:���ׂāA1:����R�[�X�A2:�C�ӎw��j
Dim vntCsGrp			'�O���\�����[�h��0:null ��1:�R�[�X�R�[�h ��2:�R�[�X�O���[�v�R�[�h
Dim vntPerId			'�l�h�c
Dim vntRsvNo			'�\��ԍ�
Dim vntCslDate			'��f��
Dim vntCsCd				'�R�[�X�R�[�h
Dim vntCsName			'�R�[�X��
Dim vntCsSName			'�R�[�X����
Dim lngHisCount			'�\����

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")
strGrpCd			= Request("grpcd")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strSelCsGrp			= IIf( strSelCsGrp="", "0", strSelCsGrp)

Select Case strSelCsGrp
	'���ׂẴR�[�X
	Case "0"
		lngLastDspMode = 0
		vntCsGrp = ""
	'����R�[�X
	Case "1"
		lngLastDspMode = 1
		vntCsGrp = strCsCd
	Case Else
		lngLastDspMode = 2
		vntCsGrp = strSelCsGrp
End Select

Do	
	'�w�肳�ꂽ�l�h�c�̎�f���ꗗ���擾����
	lngHisCount = objInterView.SelectConsultHistory( _
						lngRsvNo, _
						False, _
						lngLastDspMode, _
						vntCsGrp, _
						3, _
						0, _
						vntPerId, _
						vntRsvNo, _
						vntCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "��f�����擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	'����R�[�X�R�[�h�ޔ�
	strCsCd = vntCsCd(0)

	DispCalledFunction = "javascript:callJudTotalTop()"

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������ʕ\��</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
//�\��
function callJudTotalTop() {

	// Top�ɑI�����ꂽ�R�[�X�O���[�v���w�肵��submit
	parent.params.cscd = document.entryForm.cscd.value;
	parent.params.csgrp = document.entryForm.csgrp.value;
    common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);

}

//��ʑJ�ڗp�i�T���v��)
function movePage() {
	if ( document.entryForm.moveTo.value != '' ) {
		location.href = document.entryForm.moveTo.value;
	}
}


//-->
</SCRIPT>
<script type="text/javascript" src="/webHains/js/common.js"></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
	'�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd" VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpcd" VALUE="<%= strGrpCd %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">��������</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
			'�O����R���{�{�b�N�X�\��
			Call  EditCsGrpInfo( lngRsvNo )
%>
		</TR>
	</TABLE>
	<!-- ��f�����̕\�� -->
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="920">
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
					<TR>
						<TD NOWRAP HEIGHT="30">�O���f���F</TD>
<%
	If lngHisCount > 1 Then
%>
						<TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntCslDate(1) %>�@<%= vntCsSName(1) %></B></FONT></TD>
<%
	Else
%>
						<TD NOWRAP>&nbsp;</TD>
<%
	End If
%>
						<TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
						<TD NOWRAP>�O�X���f���F</TD>
<%
	If lngHisCount > 2 Then
%>
						<TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntCslDate(2) %>�@<%= vntCsSName(2) %></B></FONT></TD>
<%
	Else
%>
						<TD NOWRAP>&nbsp;</TD>
<%
	End If
%>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
