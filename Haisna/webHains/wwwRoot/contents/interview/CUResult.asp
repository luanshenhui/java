<%
'-----------------------------------------------------------------------------
'	   �b�t�o�N�ω��i����l�j (Ver0.0.1)
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
Dim lngRslCnt			'�������ʐ�

Dim lngItemCnt			'�I������Ă��錟�����ڐ�
Dim strArrItemInfo()	'�I������Ă��錟�����ڂ̏��
Dim strArrResult()		'�I������Ă��錟�����ڂ̌���
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
														, , , , , , , , , _
														1 _
														)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	lngItemCnt = 0
	Redim strArrItemInfo( 3, -1 )
	Redim strArrResult( lngHisCount-1, -1 )
	'�I������Ă��錟�����ڂ𒊏o
	strItem = ""
	For i=0 To lngRslCnt-1
		If strItem <> vntItemCd(i) & "-" & vntSuffix(i) Then
			lngItemCnt = lngItemCnt + 1
			Redim Preserve strArrItemInfo( 3, lngItemCnt ) 
			Redim Preserve strArrResult( lngHisCount-1, lngItemCnt ) 
		End If

		strArrItemInfo( 0, lngItemCnt ) = vntItemName(i)
		strArrItemInfo( 1, lngItemCnt ) = vntItemCd(i)
		strArrItemInfo( 2, lngItemCnt ) = vntSuffix(i)
		'�ߋ��̌��ʂ����ɂ���悤�ɂ���
		strArrResult( lngHisCount - vntHisNo(i), lngItemCnt ) = vntResult(i)

		strItem = vntItemCd(i) & "-" & vntSuffix(i)
	Next

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
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- ����l�̕\�� -->
	<TABLE BORDER="1" CELLSPACING="1" CELLPADDING="1">
		<TR ALIGN="center" BGCOLOR="#cccccc">
			<TD WIDTH="130" NOWRAP>��������</TD>
<%
	For i=0 To lngHisCount-1
%>
			<TD WIDTH="60" NOWRAP><%=vntHisCslDate(i)%></TD>
<%
	Next
%>
		</TR>
<%
	For i=1 To lngItemCnt
%>	
		<TR ALIGN="right">
			<TD ALIGN="left" NOWRAP><%=strArrItemInfo(0, i)%></TD>
<%
		For j=0 To lngHisCount-1
%>
			<TD><%=IIf(strArrResult(j, i)="", "&nbsp;", strArrResult(j, i))%></TD>
<%
		Next
%>
		</TR>
<%
	Next
%>
	</TABLE>
</FORM>
</BODY>
</HTML>
