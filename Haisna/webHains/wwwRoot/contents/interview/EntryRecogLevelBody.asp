<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �F�����x���̓o�^�i�{�f�B�j (Ver0.0.1)
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
Const DISPMODE_LIFEADVICE = 2	'�\�����ށF�����w��

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterview		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h
Dim strAct				'�������

'�����R�����g
Dim lngDispMode			'�\������
Dim vntCmtSeq			'�\����
Dim vntTtlJudCmtCd		'����R�����g�R�[�h
Dim vntTtlJudCmtstc		'����R�����g����
Dim vntTtlJudClassCd	'���蕪�ރR�[�h
Dim lngTtlCmtCnt		'�s��

'�����w���R�����g���
Dim vntEditTtlJudCmtCd	'����R�����g�R�[�h
Dim vntEditCmtDelFlag	'�폜�t���O
'## �ύX����p�@�ǉ� 2004.01.07
Dim vntEditTtlJudCmtStc	'����R�����g

'���ۂɍX�V���鐶���w���R�����g
Dim vntUpdCmtSeq		'�\����
Dim vntUpdTtlJudCmtCd	'����R�����g�R�[�h
Dim lngUpdCount			'�X�V���ڐ�
'## �ύX����p�@�ǉ� 2004.01.07
Dim vntUpdTtlJudCmtStc	'����R�����g

Dim i,j					'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterview	= Server.CreateObject("HainsInterview.Interview")

'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")
strAct				= Request("act")

'�����w���R�����g���
vntEditTtlJudCmtCd	= ConvIStringToArray(Request("TtlJudCmtCd"))
vntEditCmtDelFlag	= ConvIStringToArray(Request("CmtDelFlag"))
'## �ύX����p�@�ǉ� 2004.01.07
vntEditTtlJudCmtStc	= ConvIStringToArray(Request("TtlJudCmtStc"))

Do
	'�ۑ�
	If strAct = "save" Then

		lngUpdCount = 0
		vntUpdCmtSeq = Array()
		vntUpdTtlJudCmtCd = Array()
		ReDim vntUpdCmtSeq(-1)
		ReDim vntUpdTtlJudCmtCd(-1)
		'## �ύX����p�@�ǉ� 2004.01.07
		vntUpdTtlJudCmtStc = Array()
		ReDim vntUpdTtlJudCmtSTc(-1)

		'���ۂɍX�V���s�����ڂ݂̂𒊏o
		For i = 0 To UBound(vntEditTtlJudCmtCd)
			If vntEditCmtDelFlag(i) <> "1" Then
				ReDim Preserve vntUpdCmtSeq(lngUpdCount)
				ReDim Preserve vntUpdTtlJudCmtCd(lngUpdCount)
				'## �ύX����p�@�ǉ� 2004.01.07
				ReDim Preserve vntUpdTtlJudCmtStc(lngUpdCount)

				vntUpdCmtSeq(lngUpdCount) = lngUpdCount + 1
				vntUpdTtlJudCmtCd(lngUpdCount) = vntEditTtlJudCmtCd(i)
				'## �ύX����p�@�ǉ� 2004.01.07
				vntUpdTtlJudCmtStc(lngUpdCount) = vntEditTtlJudCmtStc(i)
				lngUpdCount = lngUpdCount + 1
			End If
		Next

		'�����R�����g�̕ۑ�
		'## 2004.01.07 �X�V����p�ɕ��͂ƃ��[�U�h�c�ǉ�
		objInterview.UpdateTotalJudCmt _
								lngRsvNo, _
								DISPMODE_LIFEADVICE, _
								vntUpdCmtSeq, _
								vntUpdTtlJudCmtCd, _
								vntUpdTtlJudCmtSTc, _
								Session.Contents("userId")
	End If

	'�����R�����g�擾
'** #### 2011.11.17 SL-SN-Y0101-006 MOD START #### **
'	lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
'										lngRsvNo, _
'										DISPMODE_LIFEADVICE, _
'										1, 0,  , 0, _
'										vntCmtSeq, _
'										vntTtlJudCmtCd, _
'										vntTtlJudCmtstc, _
'										vntTtlJudClassCd _
'										)
	lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
										lngRsvNo, _
										DISPMODE_LIFEADVICE, _
										1, 1, strCsCd , 0, _
										vntCmtSeq, _
										vntTtlJudCmtCd, _
										vntTtlJudCmtstc, _
										vntTtlJudClassCd _
										)
'** #### 2011.11.17 SL-SN-Y0101-006 MOD END #### **

	Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�F�����x���̓o�^</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="act"     VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="CmtCnt"  VALUE="<%= lngTtlCmtCnt %>">

	<!-- �����w���R�����g�̕\�� -->
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" BGCOLOR="#999999" WIDTH="900">
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">�����w���R�����g</FONT></B></TD>
		</TR>
	</TABLE>
	<SPAN ID="LifeAdviceList">
	<TABLE BORDER="0" CELLSPACING="4" CELLPADDING="0" WIDTH="908">
<%
	For i=0 To lngTtlCmtCnt - 1
%>
		<TR>
			<TD WIDTH="100%"><%= vntTtlJudCmtstc(i) %></TD>
			<TD NOWRAP VALIGN="top"><INPUT TYPE="checkbox" NAME="chkCmtDel">�폜</TD>
			<INPUT TYPE="hidden" NAME="TtlJudCmtCd"   VALUE="<%= vntTtlJudCmtCd(i) %>">
			<INPUT TYPE="hidden" NAME="TtlJudCmtstc"  VALUE="<%= vntTtlJudCmtstc(i) %>">
			<INPUT TYPE="hidden" NAME="TtlJudClassCd" VALUE="<%= vntTtlJudClassCd(i) %>">
			<INPUT TYPE="hidden" NAME="CmtDelFlag" VALUE="">
		</TR>
		<TR>
			<TD HEIGHT="1" BGCOLOR="#999999"></TD>
			<TD NOWRAP VALIGN="top" HEIGHT="1" BGCOLOR="#999999"></TD>
		</TR>
<%
	Next
%>
	</TABLE>
	</SPAN>
</FORM>
</BODY>
</HTML>
