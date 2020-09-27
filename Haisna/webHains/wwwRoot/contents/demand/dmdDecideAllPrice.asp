<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�l��f���z�č쐬 (Ver0.0.1)
'		AUTHER  : Hiroki Ishihara
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/EditBillClassList.inc" -->

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�����l
Dim strAction			'������ԁi�m��{�^��������:"submit"�C���ߏ����N��������:"submitend"�j
Dim lngStrYear			'�J�n��f��(�N)
Dim lngStrMonth			'�J�n��f��(��)
Dim lngStrDay			'�J�n��f��(��)
Dim lngEndYear			'�I����f��(�N)
Dim lngEndMonth			'�I����f��(��)
Dim lngEndDay			'�I����f��(��)
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgName			'�c�̖���
Dim strForceUpdate		'
Dim strPutLog			'

'COM�I�u�W�F�N�g
Dim objDemand			'���������A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objCommon			'���ʃN���X

'�w�����
Dim strStrDate			'�J�n��f��
Dim strEndDate			'�I����f��

'���̓`�F�b�N
Dim vntArrMessage		'�G���[���b�Z�[�W
Dim dtmDate				'��f���f�t�H���g�l�v�Z�p�̓��t
Dim lngRet				'�߂�l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strAction     = Request("action") & ""
lngStrYear    = CLng("0" & Request("strYear"))
lngStrMonth   = CLng("0" & Request("strMonth"))
lngStrDay     = CLng("0" & Request("strDay"))
lngEndYear    = CLng("0" & Request("endYear"))
lngEndMonth   = CLng("0" & Request("endMonth"))
lngEndDay     = CLng("0" & Request("endDay"))
strOrgCd1     = Request("orgCd1") & ""
strOrgCd2     = Request("orgCd2") & ""


'��f��(�J�n)�̃f�t�H���g�l(�O���̐擪��)��ݒ�
dtmDate = DateAdd("m", -1, Year(Now()) & "/" & Month(Now()) & "/1")
lngStrYear    = IIf(lngStrYear  = 0, Year(dtmDate),  lngStrYear )
lngStrMonth   = IIf(lngStrMonth = 0, Month(dtmDate), lngStrMonth)
lngStrDay     = IIf(lngStrDay   = 0, Day(dtmDate),   lngStrDay  )
strStrDate    = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay

'��f��(�I��)�̃f�t�H���g�l(�O���̖���)��ݒ�
dtmDate = CDate(Year(Now()) & "/" & Month(Now()) & "/1") - 1
lngEndYear    = IIf(lngEndYear  = 0, Year(dtmDate),  lngEndYear )
lngEndMonth   = IIf(lngEndMonth = 0, Month(dtmDate), lngEndMonth)
lngEndDay     = IIf(lngEndDay   = 0, Day(dtmDate),   lngEndDay  )
strEndDate    = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay

strForceUpdate = Request("forceUpdate")
strPutLog      = Request("logMode")

'�����ݒ�
vntArrMessage = Empty

'�����̐���
Do

	'�m��{�^��������
	If strAction = "submit" Then

		Set objCommon = Server.CreateObject("HainsCommon.Common")

		With objCommon
			'���t�������`�F�b�N
			If Not IsDate(strStrDate) Then
				.AppendArray vntArrMessage, "�J�n���t������������܂���B"
			End If
	
			'���t�������`�F�b�N
			If Not IsDate(strEndDate) Then
				.AppendArray vntArrMessage, "�I�����t������������܂���B"
			End If
	
		End With
		Set objCommon = Nothing

		'�`�F�b�N�G���[���͏����𔲂���
		If Not IsEmpty(vntArrMessage) Then
			Exit Do
		End If

		'���ߏ����N��
		Set objDemand = Server.CreateObject("HainsDmdAddUp.DecideAllConsultPrice")
		lngRet = objDemand.DecideAllConsultPrice(strStrDate, strEndDate, strOrgCd1, strOrgCd2, strForceUpdate, strPutLog)
		Set objDemand = Nothing

		'�N���ɐ��������ꍇ�A�N�������ヂ�[�h�֑J�ځi�������b�Z�[�W��\������j
		If lngRet >= 0 Then
			strAction = "submitend"
		Else
			vntArrMessage = Array("��f���z�č쐬�Ɏ��s���܂����B")
		End If

	End If

	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�l��f���z�č쐬</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �c�̌����K�C�h�Ăяo��
function callOrgGuide() {

	orgGuide_showGuideOrg(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName', '', '', null);

}

// �c�̃R�[�h�E���̂̃N���A
function clearOrgInfo() {

	orgGuide_clearOrgInfo(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');

}

// �m��{�^���������̏���
function goFinish() {

	var msg;
	msg = '';

	msg = msg + '�w�肳�ꂽ�����Ōl��f���z���č쐬���܂��B';
	if ( confirm(msg) ) {
		document.entryCondition.action.value = 'submit';
		document.entryCondition.submit();
	}

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.dmdtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�l��f���z�č쐬</FONT></B></TD>
	</TR>
</TABLE>
<!-- �����̓G���[���b�Z�[�W -->
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		'�N���������́u�N�������v�̒ʒm
		If strAction = "submitend" Then
			If lngRet = 0 Then
				vntArrMessage = "<FONT COLOR=""#ff6600""><B>��f���z�č쐬�����s���܂������Ώۃf�[�^������܂���ł����B</B></FONT>"
			Else
				vntArrMessage = "<FONT COLOR=""#ff6600""><B>��f���z�č쐬���������܂����B����=" & lngRet & "��</B></FONT>"
			End If
			Call EditMessage(vntArrMessage, MESSAGETYPE_NORMAL)

		'�����Ȃ��΃G���[���b�Z�[�W��ҏW
		Else
			Call EditMessage(vntArrMessage, MESSAGETYPE_WARNING)
		End If
	
	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD NOWRAP>��f���͈�</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Now()), False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("strMonth", 1, 12, Month(Now()), False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("strDay", 1, 31, Day(Now()), False) %></TD>
					<TD>��</TD>
					<TD>�`</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(Now()), False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("endMonth", 1, 12, Month(Now()), False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("endDay", 1, 31, Day(Now()), False) %></TD>
					<TD>��</TD>
				</TR>
				</TR>
			</TABLE>
		</TD>
	</TR>

	<TR>
		<TD NOWRAP>�c��</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\�����܂�"></A></TD>
					<TD><A HREF="javascript:clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
					<TD>
						<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
						<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
						<SPAN ID="orgName"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>

	<TR>
		<TD NOWRAP>���s���O</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="RADIO" NAME="logMode" VALUE="0" <%= IIf(strPutLog = "0", "CHECKED", "") %>>�J�n�I���̂ݏo��
			<INPUT TYPE="RADIO" NAME="logMode" VALUE="1" <%= IIf(strPutLog = "1", "CHECKED", "") %>>�G���[�̂ݏo��
			<INPUT TYPE="RADIO" NAME="logMode" VALUE="2" <%= IIf(strPutLog = "2", "CHECKED", "") %>>�S�ďo��
		</TD>
	</TR>
<!--
	<TR>
		<TD NOWRAP>�Ώۃf�[�^</TD>
		<TD>�F</TD>
		<TD><INPUT TYPE="CHECKBOX" NAME="forceUpdate" VALUE="1">�w���f���͈͓��̎�f���z�����ׂčč쐬</TD>
	</TR>
	<TR>
		<TD></TD>
		<TD></TD>
		<TD><FONT COLOR="#999999">�@�@�����̃I�v�V�������w�肷��ƁA�������ߍς݃f�[�^�A����t�f�[�^���S�čč쐬���܂��B</FONT></TD>
	</TR>
-->
</TABLE>

<INPUT TYPE="HIDDEN" NAME="forceUpdate" VALUE="0">

<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="500">
<TR>
	<TD><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGREMONEY"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���s���O���Q�Ƃ��܂�"></A></TD>
	<TD ALIGN="RIGHT">
	<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
		<A HREF="javascript:function voi(){};voi()" ONCLICK="return goFinish()" METHOD="post"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="�l��f���z���č쐬���܂�"></A>
	<%  else    %>
		 &nbsp;
	<%  end if  %>
	<% '2005.08.22 �����Ǘ� Add by ���@--- END %>
	</TD>

</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
