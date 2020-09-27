<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ��������i�Q�Ɛ�p��ʁj (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc"   -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const JUDDOC_GRPCD = "X049"		'�����O���[�v�R�[�h
Const AUTOJUD_USER = "autouser"		'�������胆�[�U

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterview		'�ʐڏ��A�N�Z�X�p

Dim strAct				'�������
Dim strWinMode			'�E�C���h�E�\�����[�h�i1:�ʃE�C���h�E�A0:���E�C���h�E�j
Dim strGrpCd			'�O���[�v�R�[�h

Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h�i���񕪁j
Dim lngLastDspMode		'�O���\�����[�h�i0:���ׂāA1:����R�[�X�A2:�C�ӎw��j
Dim vntCsGrp			'�R�[�X�R�[�h �܂��́@�R�[�X�O���[�v�R�[�h


'��f���擾�p
Dim vntRsvNo 		'�\��ԍ�
Dim vntCslDate 		'��f��
Dim vntCsCd 			'�R�[�X�R�[�h
Dim vntCsName 		'�R�[�X����
Dim lngCount			'����

'�����R�����g
Dim vntCmtSeq			'�\����
Dim vntTtlJudCmtCd			'����R�����g�R�[�h
Dim vntTtlJudCmtstc		'����R�����g����
Dim vntTtlJudClassCd		'���蕪�ރR�[�h
Dim lngTtlCmtCnt		'�s��

Dim strBakCslDate 		'��f��
Dim strBakCsCd 			'�R�[�X�R�[�h

'�O����R�[�X�R���{�{�b�N�X
Dim strArrLastCsGrp()			'�R�[�X�O���[�v�R�[�h
Dim strArrLastCsGrpName()		'�R�[�X�O���[�v����

Dim i					'���[�v�J�E���^
Dim j					'���[�v�J�E���^

Dim strMessage			'���ʓo�^���A�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objInterview    = Server.CreateObject("HainsInterview.Interview")

'�����l�̎擾
strAct           = Request("action")

lngRsvNo         = Request("rsvno")
strCsCd          = Request("cscd")
strWinMode       = Request("winmode")
strGrpCd         = Request("grpcd")


strSelCsGrp		= Request("csgrp")
strSelCsGrp = IIf( strSelCsGrp="", "0", strSelCsGrp)

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
	

	'���������ɏ]����f���ꗗ�𒊏o����
	lngCount = objInterview.SelectConsultHistory( _
							    lngRsvNo, _
    							 , _
    							lngLastDspMode, _
    							vntCsGrp, _
    							1, _
    							 ,  , _
								vntRsvNo, _
    							vntCslDate, _
    							vntCsCd _
								)

	If lngCount <= 0 Then
		Err.Raise 1000, , "��f��񂪂���܂���BRsvNo= " & lngRsvNo
	End If

	'����R�[�X�R�[�h�ޔ�
	strCsCd = vntCsCd(0)


	'�����R�����g�擾
	lngTtlCmtCnt = objInterview.SelectTotalJudCmt( _
    									lngRsvNo, 1, _
										"*", lngLastDspMode, vntCsGrp, 1, _
    									vntCmtSeq, _
    									vntTtlJudCmtCd, _
    									vntTtlJudCmtstc, _
    									vntTtlJudClassCd, _
										vntRsvNo, _
										vntCslDate, _
										vntCsCd, _
										vntCsName _
										)


	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ߋ������R�����g�ꗗ</TITLE>
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!--
//����������͉�ʌĂяo��
function calltotalJudEdit() {
	var url;							// URL������

	url = '/WebHains/contents/interview/totalJudEdit.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&grpcd=' + '<%= strGrpCd %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	parent.location.href(url);

}


//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/mensetsutable.css">
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="cscd" VALUE="<%= strCsCd %>">
<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="grpcd" VALUE="<%= strGrpCd %>">

<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" class="mensetsu-tb">
	<TR BGCOLOR="#cccccc">
		<th WIDTH="119" ALIGN="left">��f��</th>
		<th WIDTH="180" ALIGN="left">�R�[�X</th>
		<th WIDTH="500" ALIGN="left">�R�����g</th>
	</TR>
<%
	strBakCslDate = ""
	strBakCsCd = ""
	For i = 0 To lngTtlCmtCnt - 1
%>
	<TR>
<%
	'��f�����ς����
	If strBakCslDate <> vntCslDate(i) Then
		strBakCslDate = vntCslDate(i)
		strBakCsCd = vntCsCd(i)
%>
		<TD><%= vntCslDate(i) %></TD>
		<TD><%= vntCsName(i) %></TD>
<%
	Else
%>
		<TD>&nbsp;</TD>
<%
		'��f�R�[�X���ς����
		If strBakCsCd <> vntCsCd(i) Then
			strBakCsCd = vntCsCd(i)
%>
		<TD><%= vntCsName(i) %></TD>
<%
		Else
%>
		<TD>&nbsp;</TD>
<%
		End If
	End If
%>
		<TD><%= vntTtlJudCmtstc(i) %></TD>
	</TR>
<%
	Next
%>
</TABLE>
</FORM>
</BODY>
</HTML>