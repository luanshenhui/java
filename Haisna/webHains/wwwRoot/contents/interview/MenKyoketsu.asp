<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �������S�����w���\�p�^�[��  (Ver0.0.1)
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
Const GRPCD_KYOKETSU1 = "X020"	'�������S�����w���\�p�^�[���i���_�j�O���[�v�R�[�h
Const GRPCD_KYOKETSU2 = "X021"	'�������S�����w���\�p�^�[���i�S�d�}����敪�j�O���[�v�R�[�h

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objHainsUser		'���[�U���A�N�Z�X�p
Dim objInterView		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h

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
Dim vntResult1			'��������(�S�d�}����敪)

Dim vntGraphValue1(11)	'�O���t�p�f�[�^�i����j
Dim vntGraphValue2(11)	'�O���t�p�f�[�^�i�O��j
Dim strItemCd			'�������ڃR�[�h
Dim strSuffix			'�T�t�B�b�N�X
Dim lngItemCnt			'��������No

Dim lngShitten(2)		'���_��

Dim strShinden()		'�S�d�}����敪
Dim lngShindenCnt		'�S�d�}����敪��

Dim i, j				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objHainsUser	= Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strSelCsGrp			= Request("csgrp")

'### 2004/01/07 K.Kagawa �R�[�X���΂�̃f�t�H���g�l�𔻒f����
If strSelCsGrp = "" Then
	Dim lngCsGrpCnt		'�R�[�X�O���[�v��
	Dim vntCsGrpCd		'�R�[�X�O���[�v�R�[�h

	'�R�[�X�O���[�v�擾
	lngCsGrpCnt = objInterview.SelectCsGrp( lngRsvNo, vntCsGrpCd )
	If lngCsGrpCnt > 0 Then
		strSelCsGrp = vntCsGrpCd(0)
	Else
		strSelCsGrp = "0"
	End If
End If

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
						2, _
						0, _
						vntHisPerId, _
						vntHisRsvNo, _
						vntHisCslDate, _
						vntCsCd, _
						vntCsName, _
						vntCsSName _
						)
	If lngHisCount < 1 Then
		Err.Raise 1000, , "��f�����擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	'�w��Ώێ�f�҂̌������ʂ��擾����[���_]
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						2, _
						GRPCD_KYOKETSU1, _
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
						vntItemName, _
						vntResult _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	'���_���O���t�p�ɕҏW
	lngItemCnt = 0
	If lngRslCnt > 0 Then
		strItemCd = vntItemCd(0)
		strSuffix = vntSuffix(0)
		For i=0 To lngRslCnt-1
			'�������ڂ��ς����
			If vntItemCd(i) <> strItemCd Or vntSuffix(i) <> strSuffix Then
				lngItemCnt = lngItemCnt + 1
				'���Z�b�g
				strItemCd = vntItemCd(i)
				strSuffix = vntSuffix(i)
			End If
			'����ƑO��̌��ʂ𕪂��ăZ�b�g
			Select Case vntHisNo(i)
			Case 1:
				vntGraphValue1(lngItemCnt) = vntResult(i)
			Case 2:
				vntGraphValue2(lngItemCnt) = vntResult(i)
			End Select
		Next
	End If

	'���_�̍��v�v�Z
	lngShitten(0) = 0
	lngShitten(1) = 0
	For i=0 To lngRslCnt-1
		If IsNumeric(vntResult(i)) Then
			lngShitten(vntHisNo(i)-1) = lngShitten(vntHisNo(i)-1) + CLng("0" & vntResult(i))
		End If
	Next

	'�w��Ώێ�f�҂̌������ʂ��擾����[�S�d�}����敪]
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_KYOKETSU2, _
						lngLastDspMode, _
						vntCsGrp, _
						0, _
						0, _
						0, _
						, , , , , , , , ,_
						vntResult1 _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	'�S�d�}����敪��ҏW
	lngShindenCnt = 0
	For i=0 To lngRslCnt-1
		If Not IsNull(vntResult1(i)) And vntResult1(i) <> "" Then
			Redim Preserve strShinden(lngShindenCnt)
			strShinden(lngShindenCnt) = vntResult1(i)
			lngShindenCnt = lngShindenCnt + 1
		End If
	Next

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="x-ua-compatible" content="IE=10">
<TITLE>�������S�����w���\�p�^�[��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//�F�����x���̓o�^��ʌĂяo��
function callEntryRecogLevel() {
	var url;							// URL������

	url = '/WebHains/contents/interview/EntryRecogLevel.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	location.href(url);

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
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" STYLE="margin: 0px;" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�������S�����w���\�p�^�[��</FONT></B></TD>
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
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="900">
		<TR>
			<TD NOWRAP HEIGHT="30">�O���f���F</TD>
<%
	If lngHisCount > 1 Then
%>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= vntHisCslDate(1) %>�@<%= vntCsSName(1) %></B></FONT></TD>
<%
	Else
%>
			<TD NOWRAP>&nbsp;</TD>
<%
	End If
%>


			<TD WIDTH="100%" ALIGN="right" NOWRAP><A HREF="MenShittenBunpu.asp?grpno=<%= strGrpNo %>&rsvno=<%= lngRsvNo %>&cscd=<%= strCsCd %>&winmode=<%= strWinMode %>">���_���z</A></TD>
			<TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
			<TD WIDTH="100%" ALIGN="right" NOWRAP><A HREF="JavaScript:callEntryRecogLevel()">�F�����x��</A></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD WIDTH="614" HEIGHT="400" BGCOLOR="#000000">
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="100%">
					<TR>
						<TD>
							<OBJECT ID="HainsChartCircle" CLASSID="CLSID:EED1C467-A6B5-4758-9439-08CC9986AD74" CODEBASE="/webHains/cab/Graph/HainsChartCircle.CAB#version=1,0,0,1"></OBJECT>
<script type="text/javascript">
<!--
	var GraphActiveX = document.getElementById('HainsChartCircle');

<%
	For i=0 To lngItemCnt
%>
		GraphActiveX.SetResult(<%=i%>,"<%=vntGraphValue1(i)%>");
		GraphActiveX.SetLastResult(<%=i%>,"<%=vntGraphValue2(i)%>");
<%
	Next
%>
	GraphActiveX.ShowGraph();
//-->
</script>
						</TD>
					</TR>
				</TABLE>
			</TD>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
			<TD VALIGN="top" WIDTH="270">
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1" WIDTH="100%">
					<TR>
						<TD BGCOLOR="#000000">
							<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="100%">
								<TR>
									<TD HEIGHT="270" VALIGN="top">
										<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
											<TR>
												<TD NOWRAP>�S�d�}����敪�F</TD>
<%
	If lngShindenCnt > 0 Then
%>
												<TD NOWRAP><%=strShinden(0)%></TD>
<%
	Else
%>
												<TD NOWRAP>&nbsp;</TD>
<%
	End If
%>
											</TR>
<%
	For i=1 To lngShindenCnt-1
%>
											<TR>
												<TD></TD>
												<TD NOWRAP><%=strShinden(i)%></TD>
											</TR>
<%
	Next
%>
										</TABLE>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD HEIGHT="10"></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#000000">
							<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="100%">
								<TR>
									<TD VALIGN="top">
										<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
											<TR>
												<TD NOWRAP><FONT COLOR="red"><B>�����f���F</B></FONT></TD>
												<TD NOWRAP><FONT COLOR="red"><B><%= vntHisCslDate(0) %></B></FONT></TD>
												<TD>
													<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" BGCOLOR="red">
														<TR>
															<TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="3" ALT=""></TD>
														</TR>
													</TABLE>
												</TD>
											</TR>
											<TR>
												<TD NOWRAP><FONT COLOR="blue"><B>�O���f���F</B></FONT></TD>
<%
	If lngHisCount > 1 Then
%>
												<TD NOWRAP><FONT COLOR="blue"><B><%= vntHisCslDate(1) %></B></FONT></TD>
<%
	Else
%>
												<TD NOWRAP><FONT COLOR="blue"><B>&nbsp;</B></FONT></TD>
<%
	End If
%>
												<TD>
													<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" BGCOLOR="blue">
														<TR>
															<TD NOWRAP><IMG SRC="../../images/spacer.gif" WIDTH="50" HEIGHT="3" ALT=""></TD>
														</TR>
													</TABLE>
												</TD>
											</TR>
										</TABLE>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
					<TR>
						<TD HEIGHT="10"></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#000000">
							<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="100%">
								<TR>
									<TD VALIGN="top">
										<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2">
											<TR>
												<TD VALIGN="top" NOWRAP>���_�F</TD>
												<TD NOWRAP><FONT SIZE="5" COLOR="red"><B>����</B></FONT></TD>
												<TD NOWRAP><FONT SIZE="5" COLOR="blue"><B>�O��</B></FONT></TD>
											</TR>
											<TR ALIGN="center">
												<TD></TD>
												<TD NOWRAP><FONT SIZE="5" COLOR="red"><B><%= lngShitten(0) %></B></FONT></TD>
<%
	If lngHisCount > 1 Then
%>
												<TD NOWRAP><FONT SIZE="5" COLOR="blue"><B><%= lngShitten(1) %></B></FONT></TD>
<%
	Else
%>
												<TD NOWRAP><FONT SIZE="5" COLOR="blue"><B>&nbsp;</B></FONT></TD>
<%
	End If
%>
											</TR>
										</TABLE>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>