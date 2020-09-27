<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���_���z (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_SHITTENBUNPU = "X020"	'���_���z�O���[�v�R�[�h

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
Dim strPerId			'�lID
Dim lngAge				'�N��
Dim lngGender			'����

'�������ʗp�ϐ�
Dim lngLastDspMode		'�O���\�����[�h�i0:���ׂāA1:����R�[�X�A2:�C�ӎw��j
Dim vntCsGrp			'�O���\�����[�h��0:null ��1:�R�[�X�R�[�h ��2:�R�[�X�O���[�v�R�[�h
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

Dim lngShitten			'���_��

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


Do	

	'��f��񌟍��i�\��ԍ����l���擾�j
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, , _
									strPerId, _
									, , , , , , , _
									lngAge, _
									, , , , , , , , , , , , , , , _
									0, , , , , , , , , , , , , , , _
									, , , , , _
									lngGender _
									)

	'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
	If Ret = False Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
	End If

	lngLastDspMode = 0
	vntCsGrp = ""
	'�w��Ώێ�f�҂̌������ʂ��擾����
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_SHITTENBUNPU, _
						lngLastDspMode, _
						vntCsGrp, _
						1, _
						0, _
						0, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	'���_�v�Z
	lngShitten = 0
	For i=0 To lngRslCnt-1
		If IsNumeric(vntResult(i)) Then
			lngShitten = lngShitten + CLng(vntResult(i))
		End If
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
<meta http-equiv="x-ua-compatible" content="IE=10">
<TITLE>���_���z</TITLE>
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

<FORM ACTION="" METHOD="get" NAME="entryForm" STYLE="margin: 0px;">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">���_���z</FONT></B></TD>
		</TR>
	</TABLE>

	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#ffffff">
		<TR>
			<TD ALIGN="RIGHT">
			<A HREF="MenKyoketsu.asp?grpno=<%= strGrpNo %>&rsvno=<%= lngRsvNo %>&cscd=<%= strCsCd %>&winmode=<%= strWinMode %>">�������S�����w���\�p�^�[����</A>
			</TD>
		</TR>
	</TABLE>

<!-- �O���t�̕\�� -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="900" HEIGHT="500" BGCOLOR="#000000">
<!--
-->
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="100%" HEIGHT="100%" BGCOLOR="#ffffff">
					<TR>
						<TD ALIGN="center">
							<OBJECT ID="HainsChartDist" CLASSID="CLSID:BFD8C23E-2B51-41EA-BFD0-7EACB2A47657" CODEBASE="/webHains/cab/Graph/HainsChartDist.CAB#version=1,0,0,1"></OBJECT>
<script type="text/javascript">
<!--
	var GraphActiveX = document.getElementById('HainsChartDist');
	GraphActiveX.SetAge( <%=lngAge%> );
	GraphActiveX.SetGender( <%=lngGender%> );
	GraphActiveX.SetShitten( <%=lngShitten%> );
	GraphActiveX.ShowGraph();
//-->
</script>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>