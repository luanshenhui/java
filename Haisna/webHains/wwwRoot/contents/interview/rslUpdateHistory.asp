<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �ύX����  (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
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
'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h

Dim strAct				'�������
Dim strUrlPara			'�t���[���ւ̃p�����[�^
Dim lngRsvNo			'�\��ԍ�

Dim strFromDate			'�X�V���i�J�n�j
Dim strFromYear			'�X�V���@�N�i�J�n�j
Dim strFromMonth		'�X�V���@���i�J�n�j
Dim strFromDay			'�X�V���@���i�J�n�j
Dim strToDate			'�X�V���i�J�n�j
Dim strToYear			'�X�V���@�N�i�J�n�j
Dim strToMonth			'�X�V���@���i�J�n�j
Dim strToDay			'�X�V���@���i�J�n�j
Dim strUpdUser			'�X�V��
Dim strClass			'�X�V����
Dim lngOrderbyItem		'���בւ�����(0:�X�V��,1:�X�V��,2:���ށE���ځj
Dim lngOrderbyMode      '���בւ����@(0:����,1:�~��)
Dim lngStartPos			'�\���J�n�ʒu
Dim lngPageMaxLine		'�P�y�[�W�\���l�`�w�s
'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo			= Request("rsvno")
strFromDate         = Request("fromDate")
strFromYear         = Request("fromyear")
strFromMonth        = Request("frommonth")
strFromDay          = Request("fromday")
strToDate           = Request("toDate")
strToYear           = Request("toyear")
strToMonth          = Request("tomonth")
strToDay            = Request("today")
strUpdUser          = Request("upduser")
strClass            = Request("updclass")
lngOrderbyItem      = Request("orderbyItem")
lngOrderbyMode      = Request("orderbyMode")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")



'�t���[���ւ̃p�����[�^�ݒ�
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&action="      & strAct
strUrlPara = strUrlPara & "&rsvno="       & lngRsvNo
strUrlPara = strUrlPara & "&fromDate="    & strFromDate
strUrlPara = strUrlPara & "&fromyear="    & strFromYear
strUrlPara = strUrlPara & "&frommonth="   & strFromMonth
strUrlPara = strUrlPara & "&fromday="     & strFromDay
strUrlPara = strUrlPara & "&toDate="      & strToDate
strUrlPara = strUrlPara & "&toyear="      & strToYear
strUrlPara = strUrlPara & "&tomonth="     & strToMonth
strUrlPara = strUrlPara & "&today="       & strToDay
strUrlPara = strUrlPara & "&upduser="     & strUpdUser
strUrlPara = strUrlPara & "&updclass="    & strClass
strUrlPara = strUrlPara & "&orderbyItem=" & lngOrderbyItem
strUrlPara = strUrlPara & "&orderbyMode=" & lngOrderbyMode
strUrlPara = strUrlPara & "&startPos="    & lngStartPos
strUrlPara = strUrlPara & "&pageMaxLine=" & lngPageMaxLine
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�ύX����</TITLE>
<script type="text/javascript">
var params = {
    action:      "<%= strAct %>",
    winmode:     "<%= strWinMode %>",
    rsvno:       "<%= lngRsvNo %>",
    fromDate:    "<%= strFromDate %>",
    fromyear:    "<%= strFromYear %>",
    frommonth:   "<%= strFromMonth %>",
    fromday:     "<%= strFromDay %>",
    toDate:      "<%= strToDate %>",
    toyear:      "<%= strToYear %>",
    tomonth:     "<%= strToMonth %>",
    today:       "<%= strToDay %>",
    upduser:     "<%= strUpdUser %>",
    updclass:    "<%= strClass %>",
    orderbyItem: "<%= lngOrderbyItem %>",
    orderbyMode: "<%= lngOrderbyMode %>",
    startPos:    "<%= lngStartPos %>",
    pageMaxLine: "<%= lngPageMaxLine %>"
};
</script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%=IIf(strWinMode=1,180,110)%>,*">
	<FRAME NAME="header" SRC="rslUpdateHistoryHeader.asp<%=strUrlPara%>">
	<FRAME NAME="bodyview"  SRC="rslUpdateHistoryBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
