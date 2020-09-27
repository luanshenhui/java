<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �����ڌ������猩�����Ȃ��̌X�� (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_SDI = "X050"	'���_���z�O���[�v�R�[�h

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p
Dim objConsult			'��f�N���X

Dim Ret					'���A�l
Dim i, j				'�J�E���^�[

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h

'��f���p�ϐ�
Dim lngLastDspMode		'�O���\�����[�h�i0:���ׂāA1:����R�[�X�A2:�C�ӎw��j
Dim vntCsGrp			'�O���\�����[�h��0:null ��1:�R�[�X�R�[�h ��2:�R�[�X�O���[�v�R�[�h
Dim vntCslRsvNo			'�\��ԍ�
Dim vntCslCslDate		'��f��
Dim lngCount			'����

Dim	dblValueX			'���v�ʂy�P�i�w���W�j
Dim	dblValueY			'���v�ʂy�Q�i�w���W�j

'�O���t�ւ̈���
Dim vntGraphCslDate		'��f���̔z��
Dim vntValueX			'���v�ʂy�P�i�w���W�j�̔z��
Dim vntValueY			'���v�ʂy�Q�i�x���W�j�̔z��

Dim strArrMessage		'�G���[���b�Z�[�W

Dim vntPerId
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult 		= Server.CreateObject("HainsConsult.Consult")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

strSelCsGrp		= Request("csgrp")
strSelCsGrp = IIf( strSelCsGrp="", 0, strSelCsGrp)

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

'	strArrMessage = ""
'	lngLastDspMode = 0
'	vntCsGrp = ""
	'���������ɏ]����f���ꗗ�𒊏o����i�S���j
	lngCount = objInterview.SelectConsultHistory( _
							    lngRsvNo, _
    							 , _
    							lngLastDspMode, _
    							vntCsGrp, _
    							 , _
    							 ,  , _
								vntCslRsvNo, _
    							vntCslCslDate _
								)

	If lngCount <= 0 Then
		objCommon.AppendArray strArrMessage, "��f��񂪂���܂���BRsvNo= "  & lngRsvNo 
'		Err.Raise 1000, , "��f��񂪂���܂���BRsvNo= " & lngLastDspMode & "(" & lngRsvNo 
		Exit Do
	End If

	vntGraphCslDate = Array()
	vntValueX = Array()
	vntValueY = Array()
	Redim Preserve vntGraphCslDate(1)
	Redim Preserve vntValueX(0)
	Redim Preserve vntValueY(0)
	vntGraphCslDate(1) = ""
	'���݂̓��v�ʂ��v�Z����
	Ret = objInterView.StatisticsCalc( _
						lngRsvNo, _
						dblValueX, _
						dblValueY _
						)
	If Ret = False Then
		objCommon.AppendArray strArrMessage, "�����l�����݂��邽�߁A�v�Z�ł��܂���ł����B"
		vntGraphCslDate(0) = vntCslCslDate(0)
		vntValueX(0) = ""
		vntValueY(0) = ""
	Else
		vntGraphCslDate(0) = vntCslCslDate(0)
		vntValueX(0) = dblValueX
		vntValueY(0) = dblValueY
	End If

	If lngCount = 1 Then
		objCommon.AppendArray strArrMessage, "�ߋ��̃f�[�^�͂���܂���B"
		vntGraphCslDate(1) = ""
	Else
		j = 1
		For	i = 1 To UBound(vntCslRsvNo)
			'1997/4/1�ȑO�Ȃ�I��
			If vntCslCslDate(i) < "1997/04/01" Then
				Exit For
			End If
			'�ߋ��̓��v�ʂ��v�Z����
			Ret = objInterView.StatisticsCalc( _
							vntCslRsvNo(i), _
							dblValueX, _
							dblValueY _
							)
			If Ret = False Then
				vntGraphCslDate(1) = vntCslCslDate(i)
'				objCommon.AppendArray strArrMessage, "�����l�����݂��邽�߁A�v�Z�ł��܂���ł����B"
			Else
				Redim Preserve vntValueX(j)
				Redim Preserve vntValueY(j)
				vntGraphCslDate(1) = vntCslCslDate(i)
				vntValueX(j) = dblValueX
				vntValueY(j) = dblValueY
				j = j + 1
			End If
		Next
	End If


	'�e�X�g�f�[�^
'	lngHisCount = 2
'	vntGraphCslDate = Array("2003/12/09","2002/12/01" )
'	vntValueX = Array(2.2, -0.2)
'	vntValueY = Array(2.2, -0.2)

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="x-ua-compatible" content="IE=10">
<TITLE>�����ڌ�������݂����Ȃ��̌X��</TITLE>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
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

<FORM ACTION="" METHOD="get" NAME="entryForm">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�����ڌ�������݂����Ȃ��̌X��</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
<%
			'�O����R���{�{�b�N�X�\��
			Call  EditCsGrpInfo( lngRsvNo )
%>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If IsEmpty(strArrMessage) = False Then

		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

	End If
%>
<!-- �O���t�̕\�� -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="900" HEIGHT="300" BGCOLOR="#000000">
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="100%" HEIGHT="100%" BGCOLOR="#ffffff">
					<TR>
						<TD ALIGN="center">
							<OBJECT ID="HainsChartTend" CLASSID="CLSID:9179E3C7-F0BB-4D64-A848-958F14EA6DF6" CODEBASE="/webHains/cab/Graph/HainsChartTend.CAB#version=1,0,0,2">
							</OBJECT>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
<script type="text/javascript">
var GraphActiveX = document.getElementById('HainsChartTend');
<%
For i = 0 To 2 - 1
%>
	GraphActiveX.SetCslDate(<%= i %>, '<%= vntGraphCslDate(i) %>');
<%
Next

For i = 0 To UBound(vntValueX)
%>
	GraphActiveX.SetResult(<%= i %>, '<%= vntValueX(i) %>', '<%= vntValueY(i) %>');
<%
Next
%>
GraphActiveX.ShowGraph();
</script>
</BODY>
</HTML>