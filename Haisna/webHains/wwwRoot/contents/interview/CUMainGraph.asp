<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �b�t�o�N�ω��i�O���t�j (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h
Dim strArrItemCd		'�������ڃR�[�h
Dim strArrSuffix		'�T�t�B�b�N�X

'��f���ꗗ�p�ϐ�
Dim lngLastDspMode		'�O���\�����[�h�i0:���ׂāA1:����R�[�X�A2:�C�ӎw��j
Dim vntCsGrp			'�O���\�����[�h��0:null ��1:�R�[�X�R�[�h ��2:�R�[�X�O���[�v�R�[�h
Dim vntHisPerId			'�l�h�c
Dim vntHisRsvNo			'�\��ԍ�
Dim vntHisCslDate		'��f��
Dim vntCsCd				'�R�[�X�R�[�h
Dim vntCsName			'�R�[�X��
Dim vntCsSName			'�R�[�X����
Dim lngHisCount			'�\����

'�������ʗp�ϐ�
Dim vntPerId			'�\��ԍ�
Dim vntCslDate			'�������ڃR�[�h
Dim vntHisNo			'����No.
Dim vntRsvNo			'�\��ԍ�
Dim vntItemCd			'�������ڃR�[�h
Dim vntSuffix			'�T�t�B�b�N�X
Dim vntResultType		'���ʃ^�C�v
Dim vntItemType			'���ڃ^�C�v
Dim vntItemName			'�������ږ���
Dim vntResult			'��������
Dim vntLowerValue		'��l�i�Œ�j
Dim vntUpperValue		'��l�i�ō��j
Dim lngRslCnt			'�������ʐ�

Dim lngItemCnt			'�I������Ă��錟�����ڐ�
Dim strArrItemInfo()	'�I������Ă��錟�����ڂ̏��
Dim strArrResult()		'�I������Ă��錟�����ڂ̌���

'### 2004/07/17 Added by Ishihara@FSIT �e��f�𖈂̊�l�ݒ�Ή�
Dim strArrLowerValue()		'�e��f�𖈂̊�l�i��j
Dim strArrUpperValue()		'�e��f�𖈂̊�l�i���j
'### 2004/07/17 Added End

Dim strItem				'�����Ώۂ̌�������
Dim i, j				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")
strSelCsGrp			= IIf(strSelCsGrp="", "0", strSelCsGrp)

strArrItemCd		= ConvIStringToArray(Request("itemcd"))
strArrSuffix		= ConvIStringToArray(Request("suffix"))

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
						10, _
						0, _
						vntHisPerId, _
						vntHisRsvNo, _
						vntHisCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName, _
						1 _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "��f�����擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	'�w��Ώێ�f�҂̌������ʂ��擾����
	lngRslCnt = objInterView.SelectHistoryRslList_Item( _
														lngRsvNo, _
														lngHisCount, _
														strArrItemCd, _
														strArrSuffix, _
														lngLastDspMode, _
														vntCsGrp, _
														0, _
														0, _
														1, _
														vntPerId, _
														vntCslDate, _
														vntHisNo, _
														vntRsvNo, _
														vntItemCd, _
														vntSuffix, _
														vntResultType, _
														vntItemType, _
														, _
														vntItemName, _
														, _
														, _
														vntResult, _
														, _
														vntLowerValue, _
														vntUpperValue, _
														, , , , , , 1 _
														)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	lngItemCnt = 0
	Redim strArrItemInfo( 5, -1 )
'	Redim strArrResult( lngHisCount-1, -1 )
	Redim strArrResult( 10, -1 )
'### 2004/07/17 Added by Ishihara@FSIT �e��f�𖈂̊�l�ݒ�Ή�
	Redim Preserve strArrLowerValue( 10, -1 )
	Redim Preserve strArrUpperValue( 10, -1 )
'### 2004/07/17 Added End
	'�I������Ă��錟�����ڂ𒊏o
	strItem = ""
	For i=0 To lngRslCnt-1
		If strItem <> vntItemCd(i) & "-" & vntSuffix(i) Then
			lngItemCnt = lngItemCnt + 1
			Redim Preserve strArrItemInfo( 5, lngItemCnt ) 
'			Redim Preserve strArrResult( lngHisCount-1, lngItemCnt ) 
			Redim Preserve strArrResult( 10, lngItemCnt ) 

'### 2004/07/17 Added by Ishihara@FSIT �e��f�𖈂̊�l�ݒ�Ή�
			Redim Preserve strArrLowerValue( 10, lngItemCnt ) 
			Redim Preserve strArrUpperValue( 10, lngItemCnt ) 
'### 2004/07/17 Added End
		End If

		strArrItemInfo( 0, lngItemCnt ) = vntItemName(i)	'�������ږ���
		strArrItemInfo( 1, lngItemCnt ) = vntItemCd(i)		'�������ڃR�[�h
		strArrItemInfo( 2, lngItemCnt ) = vntSuffix(i)		'�T�t�B�b�N�X
		strArrItemInfo( 3, lngItemCnt ) = vntLowerValue(i)	'��l�i�Œ�j
		strArrItemInfo( 4, lngItemCnt ) = vntUpperValue(i)	'��l�i�ō��j
		'�ߋ��̌��ʂ����ɂ���悤�ɂ���
		strArrResult( lngHisCount - vntHisNo(i), lngItemCnt ) = vntResult(i)
'### 2004/07/17 Added by Ishihara@FSIT �e��f�𖈂̊�l�ݒ�Ή�
		strArrLowerValue( lngHisCount - vntHisNo(i), lngItemCnt ) = vntLowerValue(i)
		strArrUpperValue( lngHisCount - vntHisNo(i), lngItemCnt ) = vntUpperValue(i)
'### 2004/07/17 Added End

		strItem = vntItemCd(i) & "-" & vntSuffix(i)
	Next

	'�\���{�^���������ɌĂяo����鎩��ʂ̊֐���ݒ肷��
	DispCalledFunction = "callCUMainGraphTop()"

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="x-ua-compatible" content="IE=10" >
<TITLE>�b�t�o�N�ω�</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// ���t���[���̉�ʐؑ�
function changeResultFrame() {

	var elem   = document.getElementById('anchorName');
	var myForm = document.entryForm;

	switch ( elem.innerHTML ) {
		case '�����K��':
			elem.innerHTML = '����l';
			parent.result.location.href = 'CULifeHabit.asp?<%= Request.ServerVariables("QUERY_STRING") %>';
			break;

		case '����l':
			elem.innerHTML = '�����K��';
			parent.result.location.href = 'CUResult.asp?<%= Request.ServerVariables("QUERY_STRING") %>';
			break;

	}

	return;
}

//�\��
function callCUMainGraphTop() {

	// Top�ɑI�����ꂽ�R�[�X�O���[�v���w�肵��submit
	parent.document.entryForm.csgrp.value = document.entryForm.csgrp.value;

	parent.document.entryForm.submit();

}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
	'�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
	If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" STYLE="margin: 0px;" TARGET="result" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="920">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�b�t�o�N�ω�</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
			'�O����R���{�{�b�N�X�\��
			Call  EditCsGrpInfo( lngRsvNo )
%>
		</TR>
	</TABLE>
	<!-- �����N�̕\�� -->
	<TABLE BORDER="1" CELLSPACING="2" CELLPADDING="0">
		<TR>
			<TD NOWRAP ALIGN="center" WIDTH="120"><A HREF="CUSelectItemsMain.asp?<%= Request.ServerVariables("QUERY_STRING") %>" TARGET="_parent">���ڑI����ʂ�</A></TD>
			<TD NOWRAP ALIGN="center" WIDTH="120"><A HREF="JavaScript:" ONCLICK="JavaScript:changeResultFrame(); return false;"><SPAN ID="anchorName">�����K��</SPAN></A></TD>
		</TR>
	</TABLE>
	<!-- �O���t�̕\�� -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="900">
		<TR>
			<TD>
<%
	If lngItemCnt > 0 Then
'### 2004/07/15 Updated by Ishihara@FSIT �e��f�𖈂̊�l�ݒ�Ή��iActiveX UpGrade)
%>
				<OBJECT ID="HainsChartCu" CLASSID="CLSID:4038097A-F1AD-4DE1-B76F-27A225AF5E54" CODEBASE="/webHains/cab/Graph/HainsChartCu.CAB#version=1,1,0,0"></OBJECT>
<%
	End If
%>
			</TD>
		</TR>
	</TABLE>

<%
	If lngItemCnt > 0 Then
%>
<script type="text/javascript">
	var GraphActiveX = document.getElementById("HainsChartCu");

	// X�����Œ肷�邽�߂ɏ�Ɏ�f�񐔂�10��Ƃ���
	GraphActiveX.SetConsCount(10);
	GraphActiveX.SetItemCount(<%=lngItemCnt %>);
<%	For i=0 To lngHisCount-1 %>
	GraphActiveX.SetCslDate(<%=i%>,"<%=vntHisCslDate(i)%>");
<%	Next %>
<%	For i=1 To lngItemCnt %>
		GraphActiveX.SetItemName(<%=i-1%>,"<%=strArrItemInfo(0, i)%>");
		GraphActiveX.SetStdValue(<%=i-1%>, "<%=strArrItemInfo(3, i)%>", "<%=strArrItemInfo(4, i)%>");
<%		For j=0 To lngHisCount-1 %>
			GraphActiveX.SetResultWithStdValue(<%=i-1%>,<%=j%>,"<%=strArrResult(j, i)%>","<%= strArrLowerValue(j, i) %>", "<%= strArrUpperValue(j, i) %>");
<%		Next
	Next
%>
	GraphActiveX.ShowGraph();
</script>
<%
	End If
%>
</FORM>
</BODY>
</HTML>
