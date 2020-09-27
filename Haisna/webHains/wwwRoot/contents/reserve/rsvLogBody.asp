<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �ύX�����i�w�b�_�j (Ver0.0.1)
'	   AUTHER  : Tsutomy Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const STARTPOS  = 1		'�J�n�ʒu�̃f�t�H���g�l
Const GETCOUNT  = 50	'�\�������̃f�t�H���g�l

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult			'��f���A�N�Z�X�p

'�p�����[�^�l
Dim lngStrYear			'�X�V��(��)(�N)
Dim lngStrMonth			'�X�V��(��)(��)
Dim lngStrDay			'�X�V��(��)(��)
Dim lngEndYear			'�X�V��(��)(�N)
Dim lngEndMonth			'�X�V��(��)(��)
Dim lngEndDay			'�X�V��(��)(��)
Dim strRsvNo			'�\��ԍ�
Dim strUpdUser			'�X�V��
Dim lngOrderbyItem		'���בւ�����(0:�X�V��,1:�X�V��,2:�\��ԍ��j
Dim lngOrderbyMode		'���בւ����@(0:����,1:�~��)
Dim lngStartPos			'�����J�n�ʒu
'## 2004.10.27 Add By T.Takagi@FSIT �X�V�����ւ̑J�ڒǉ�
Dim lngMargin			'TOPMARGIN
'## 2004.10.27 Add End
Dim lngGetCount			'�\������

Dim strArrRsvNo			'�\��ԍ�
Dim strArrSeq			'�r�d�p
Dim strArrUpdDate		'�X�V��
Dim strArrUpdUser		'���[�U�h�c
Dim strArrUserName		'���[�U��
Dim strArrCslInfo		'�\��X�V���

Dim strUpdClassName			'�X�V���ޖ���
Dim strItemName				'���ږ���
Dim strUpdDivName			'�����敪����

Dim lngCount				'�S����

Dim strURL					'�W�����v���URL

Dim i						'���[�v�J�E���^

Dim dtmStrDate			'�X�V��(��)
Dim dtmEndDate			'�X�V��(��)
Dim strMessage			'�G���[���b�Z�[�W

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
lngStrYear     = CLng("0" & Request("strYear"))
lngStrMonth    = CLng("0" & Request("strMonth"))
lngStrDay      = CLng("0" & Request("strDay"))
lngEndYear     = CLng("0" & Request("endYear"))
lngEndMonth    = CLng("0" & Request("endMonth"))
lngEndDay      = CLng("0" & Request("endDay"))
strRsvNo       = Request("rsvNo")
strUpdUser     = Request("updUser")
lngOrderByItem = CLng("0" & Request("orderByItem"))
lngOrderByMode = CLng("0" & Request("orderByMode"))
lngStartPos    = Request("startPos")
lngGetCount    = Request("getCount")
'## 2004.10.27 Add By T.Takagi@FSIT �X�V�����ւ̑J�ڒǉ�
lngMargin      = CLng("0" & Request("margin"))
'## 2004.10.27 Add End

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))

Do

	'�X�V��(��)�̓��t�`�F�b�N
	If lngStrYear <> 0 Or lngStrMonth <> 0 Or lngStrDay <> 0 Then
		If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Then
			strMessage = "�X�V���̎w��Ɍ�肪����܂��B"
			Exit Do
		End If
	End If

	'�X�V��(��)�̓��t�`�F�b�N
	If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
		If Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
			strMessage = "�X�V���̎w��Ɍ�肪����܂��B"
			Exit Do
		End If
	End If

	'�\��ԍ��̐��l�`�F�b�N
	If strRsvNo <> "" Then
		For i = 1 To Len(strRsvNo)
			If InStr("0123456789", Mid(strRsvNo, i, 1)) <= 0 Then
				strMessage = "�\��ԍ��̎w��Ɍ�肪����܂��B"
				Exit Do
			End If
		Next
	End If

	'�X�V���̕ҏW
	If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
		dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
	End If

	If lngEndYear <> 0 And lngEndMonth <> 0 And lngEndDay <> 0 Then
		dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
	End If

	'��f��񃍃O�̓ǂݍ���
	Set objConsult = Server.CreateObject("HainsConsult.Consult")
	lngCount = objConsult.SelectConsultLogList(dtmStrDate, dtmEndDate, CLng("0" & strRsvNo), strUpdUser, lngOrderByItem, lngOrderByMode, lngStartPos, lngGetCount, strArrRsvNo, strArrSeq, strArrUpdDate, strArrUpdUser, strArrUserName, strArrCslInfo)
	Set objConsult = Nothing

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�ύX����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winConsultLog;		// �E�B���h�E�n���h��

// �\��X�V���̕\��
function showCslLog( rsvNo, seq ) {

	var url = 'rsvConsultLog.asp';	// �\��X�V����ʂ�URL

	var opened = false;	// ��ʂ��J����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winConsultLog ) {
		if ( !winConsultLog.closed ) {
			opened = true;
		}
	}

	// ��r�̂���window�̓N���b�N�̂��тɐV�K�ŊJ��
	url = url + '?rsvNo=' + rsvNo + '&seq=' + seq;
	winConsultLog = window.open( url, '', 'width=600,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: <%= lngMargin %>px 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
Do
	'���b�Z�[�W���������Ă���ꍇ�͕ҏW���ď����I��
	If strMessage <> "" Then
		Response.Write strMessage
		Exit Do
	End If

	If lngCount <= 0 Then
%>
		���������𖞂��������͑��݂��܂���ł����B
<%
		Exit Do
	End If
%>
	�������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>������܂����B<BR><BR>

	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="#cccccc">
			<TD NOWRAP>�X�V����</TD>
			<TD NOWRAP>�X�V��</TD>
			<TD NOWRAP>�\��ԍ�</TD>
		</TR>
<%
		For i = 0 To UBound(strArrRsvNo)
%>
			<TR BGCOLOR="#eeeeee">
				<TD NOWRAP><A HREF="javascript:showCslLog(<%= strArrRsvNo(i) %>,<%= strArrSeq(i) %>)"><%= strArrUpdDate(i) %></A></TD>
				<TD NOWRAP><%= strArrUserName(i) %></TD>
				<TD NOWRAP><%= strArrRsvNo(i)    %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'�S���������̓y�[�W���O�i�r�Q�[�^�s�v
    If lngGetCount = 0 Then
		Exit Do
	End If

	'URL�̕ҏW
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?strYear="     & lngStrYear
	strURL = strURL & "&strMonth="    & lngStrMonth
	strURL = strURL & "&strDay="      & lngStrDay
	strURL = strURL & "&endYear="     & lngEndYear
	strURL = strURL & "&endMonth="    & lngEndMonth
	strURL = strURL & "&endDay="      & lngEndDay
	strURL = strURL & "&rsvNo="       & strRsvNo
	strURL = strURL & "&updUser="     & strUpdUser
	strURL = strURL & "&orderByItem=" & lngOrderByItem
	strURL = strURL & "&orderByMode=" & lngOrderByMode

	'�y�[�W���O�i�r�Q�[�^�̕ҏW
%>
	<%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
	Exit Do
Loop
%>
</BODY>
</HTML>