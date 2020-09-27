<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�������ߏ��� (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc" -->


<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�����l
Dim strAction			'������ԁi�m��{�^��������:"submit"�C���ߏ����N��������:"submitend"�j
Dim lngCloseYear		'���ߓ�(�N)
Dim lngCloseMonth		'���ߓ�(��)
Dim lngCloseDay			'���ߓ�(��)
Dim lngStrYear			'�J�n��f��(�N)
Dim lngStrMonth			'�J�n��f��(��)
Dim lngStrDay			'�J�n��f��(��)
Dim lngEndYear			'�I����f��(�N)
Dim lngEndMonth			'�I����f��(��)
Dim lngEndDay			'�I����f��(��)
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgCd5Char		'�c�̃R�[�h�̐擪�T��
Dim strCsCd				'�R�[�X�R�[�h


'COM�I�u�W�F�N�g
Dim objDmdAddUp			'���ߏ����A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objDmdAddUpControl	'���ߏ����A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objOrganization		'�c�̃A�N�Z�X�pCOM�I�u�W�F�N�g

'�w�����
Dim strEditCloseDate	'���ߓ�
Dim strEditStrDate		'�J�n��f��
Dim strEditEndDate		'�I����f��
Dim strEditOrgCd1		'�c�̃R�[�h�P
Dim strEditOrgCd2		'�c�̃R�[�h�Q
Dim strEditCsCd			'�R�[�X�R�[�h

'�c�̓ǂݍ���
Dim strOrgName			'�c�̖���

'���̓`�F�b�N
Dim strArrMessage		'�G���[���b�Z�[�W
Dim dtmDate				'��f���f�t�H���g�l�v�Z�p�̓��t
Dim lngRet				'�߂�l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strAction     = Request("action") & ""
lngCloseYear  = CLng("0" & Request("closeYear"))
lngCloseMonth = CLng("0" & Request("closeMonth"))
lngCloseDay   = CLng("0" & Request("closeDay"))
lngStrYear    = CLng("0" & Request("strYear"))
lngStrMonth   = CLng("0" & Request("strMonth"))
lngStrDay     = CLng("0" & Request("strDay"))
lngEndYear    = CLng("0" & Request("endYear"))
lngEndMonth   = CLng("0" & Request("endMonth"))
lngEndDay     = CLng("0" & Request("endDay"))
strOrgCd1     = Request("orgCd1") & ""
strOrgCd2     = Request("orgCd2") & ""
strOrgCd5Char = Request("orgCd5Char") & ""
strCsCd       = Request("CsCd") & ""



''���ߓ��̃f�t�H���g�l(�V�X�e�����t)��ݒ�
'lngCloseYear  = IIf(lngCloseYear  = 0, Year(Now()),  lngCloseYear )
'lngCloseMonth = IIf(lngCloseMonth = 0, Month(Now()), lngCloseMonth)
'lngCloseDay   = IIf(lngCloseDay   = 0, Day(Now()),   lngCloseDay  )
'���ߓ��̃f�t�H���g�l(�O���̖���)��ݒ� ..... updated by C's
dtmDate = CDate(Year(Now()) & "/" & Month(Now()) & "/1") - 1
lngCloseYear  = IIf(lngCloseYear  = 0, Year(dtmDate),  lngCloseYear )
lngCloseMonth = IIf(lngCloseMonth = 0, Month(dtmDate), lngCloseMonth)
lngCloseDay   = IIf(lngCloseDay   = 0, Day(dtmDate),   lngCloseDay  )

'��f��(�J�n)�̃f�t�H���g�l(�O���̐擪��)��ݒ�
dtmDate = DateAdd("m", -1, Year(Now()) & "/" & Month(Now()) & "/1")
lngStrYear    = IIf(lngStrYear  = 0, Year(dtmDate),  lngStrYear )
lngStrMonth   = IIf(lngStrMonth = 0, Month(dtmDate), lngStrMonth)
lngStrDay     = IIf(lngStrDay   = 0, Day(dtmDate),   lngStrDay  )

'��f��(�I��)�̃f�t�H���g�l(�O���̖���)��ݒ�
dtmDate = CDate(Year(Now()) & "/" & Month(Now()) & "/1") - 1
lngEndYear    = IIf(lngEndYear  = 0, Year(dtmDate),  lngEndYear )
lngEndMonth   = IIf(lngEndMonth = 0, Month(dtmDate), lngEndMonth)
lngEndDay     = IIf(lngEndDay   = 0, Day(dtmDate),   lngEndDay  )

'�c�̃R�[�h�擪�T�����ǂ����H
'If Trim(strOrgCd5Char) = "" Then
	strEditOrgCd1 = Trim(strOrgCd1)
	strEditOrgCd2 = Trim(strOrgCd2)
'Else
'	strEditOrgCd1 = Trim(strOrgCd5Char)
'	strEditOrgCd2 = ""
'End If

'�����ݒ�
strArrMessage = Empty
strEditCloseDate = Empty
strEditStrDate = Empty
strEditEndDate = Empty

'�c�̖��̂̎擾
If Trim(strOrgCd1) <> "" And Trim(strOrgCd2) <> "" Then
	Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
	objOrganization.SelectOrgName strOrgCd1, strOrgCd2, strOrgName
	Set objOrganization = Nothing
End If

'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̊��蓖��
Set objDmdAddUp        = Server.CreateObject("HainsDmdAddUp.DmdAddUp")

'�����̐���
Do

	'�m��{�^��������
	If strAction = "submit" Then

		'���̓`�F�b�N
		strArrMessage = objDmdAddUp.CheckValueDmdAddUp(lngCloseYear, lngCloseMonth, lngCloseDay, lngStrYear, lngStrMonth, lngStrDay, lngEndYear, lngEndMonth, lngEndDay, strEditOrgCd1, strEditOrgCd2, strEditCloseDate, strEditStrDate, strEditEndDate)

		'�`�F�b�N�G���[���͏����𔲂���
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'���ߏ����N��
		Set objDmdAddUpControl = Server.CreateObject("HainsDmdAddUp.DmdAddUpControl")
		lngRet = objDmdAddUpControl.ExecuteDmdAddUp(strEditCloseDate, strEditStrDate, strEditEndDate, strEditOrgCd1, strEditOrgCd2, strCsCd, Session.Contents("userid"))
		Set objDmdAddUpControl = Nothing

		'�N���ɐ��������ꍇ�A�N�������ヂ�[�h�֑J�ځi�������b�Z�[�W��\������j
		If lngRet >= 0 Then
			strAction = "submitend"
		Else 
			strArrMessage = Array("�������ߏ����Ɏ��s���܂����B")
		End If

	End If

	Exit Do
Loop

'�����A�N�Z�X�pCOM�I�u�W�F�N�g�̉��
Set objDmdAddUp = Nothing
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������ߏ���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->

<SCRIPT TYPE="text/javascript">
<!--
// �c�̌����K�C�h�Ăяo��
function callOrgGuide() {

	// �c�̌����K�C�h�\��
	orgGuide_showGuideOrg(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName', null, null, setOrgByGuide);


}

// �c�̌����K�C�h�Œc�̂�I���������̏���
function setOrgByGuide() {

	// �c�̃R�[�h�̐擪�T�����͒l�̃N���A
	document.entryCondition.CheckboxOrgCd5Char.checked = false;
	document.entryCondition.orgCd5Char.value           = document.entryCondition.orgCd1.value;

}
// �c�̃R�[�h�E���̂̃N���A
function clearOrgInfo() {

	orgGuide_clearOrgInfo(document.entryCondition.orgCd1, document.entryCondition.orgCd2, 'orgName');

}

// �u�c�̃R�[�h�̐擪�T�����w�肷��v���ύX���ꂽ���̏���
function ChangeOrgCd5Char( targetsel ) {

	// �`�F�b�N���ꂽ��
	if ( targetsel.checked ) {
		// �c�̃R�[�h�E���̂̃N���A
		clearOrgInfo();
	// �`�F�b�N���͂����ꂽ��
	} else {
		// �c�̃R�[�h�̐擪�T�����͒l�̃N���A
		document.entryCondition.orgCd5Char.value = '';
	}

	return false;
}

// �m��{�^���������̏���
function goFinish() {

	var myCheck
	var msg;
	msg = '';

	// �c�̃R�[�h�̐擪�T���`�F�b�N���͂����Ă��Ȃ��Ȃ�N���A
	if ( document.entryCondition.CheckboxOrgCd5Char.checked == false ) {
		document.entryCondition.orgCd5Char.value = '';
	}

	// �c�̃R�[�h�̐擪�T���������͎��A�`�F�b�N���͂����Ă���Ȃ�
	if ( document.entryCondition.orgCd5Char.value == '' && document.entryCondition.CheckboxOrgCd5Char.checked ) {
		// �c�̃R�[�h�̐擪�T���w��`�F�b�N���͂���
		msg = msg + '�c�̃R�[�h�̐擪�T���̎w��͖�������܂��B\n';
		document.entryCondition.CheckboxOrgCd5Char.checked = false;
	}

	// �m�F�n�j���A���s��
	if ( msg != '') {
		msg = msg + '\n';
	}
	msg = msg + '�w�肳�ꂽ�����Œ��ߏ��������s���܂��B';
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
<BODY ONUNLOAD="JavaScript:orgGuide_closeGuideOrg(); calGuide_closeGuideCalendar()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�������ߏ���</FONT></B></TD>
	</TR>
</TABLE>
<!-- �����̓G���[���b�Z�[�W -->
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		'�N���������́u�N�������v�̒ʒm
		If strAction = "submitend" Then
			If lngRet = 0 Then
				strArrMessage = "<FONT COLOR=""#ff6600""><B>�������ߏ��������s���܂������Ώۃf�[�^������܂���ł����B</B></FONT>"
			Else
				strArrMessage = "<FONT COLOR=""#ff6600""><B>�������ߏ������������܂����B</B></FONT>"
			End If
			Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)

		'�����Ȃ��΃G���[���b�Z�[�W��ҏW
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
	<TR>
		<TD>���ߓ�</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('closeYear', 'closeMonth', 'closeDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("closeYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCloseYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("closeMonth", 1, 12, lngCloseMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("closeDay", 1, 31, lngCloseDay, False) %></TD>
					<TD>��</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD NOWRAP>��f���͈�</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("strMonth", 1, 12, lngStrMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("strDay", 1, 31, lngStrDay, False) %></TD>
					<TD>��</TD>
					<TD>�`</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("endMonth", 1, 12, lngEndMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("endDay", 1, 31, lngEndDay, False) %></TD>
					<TD>��</TD>
				</TR>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>���S�c��</TD>
		<TD>�F</TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><A HREF="javascript:callOrgGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\�����܂�"></A></TD>
					<TD><A HREF="javascript:clearOrgInfo()"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�ݒ肵���l���N���A"></A></TD>
					<TD WIDTH="5"></TD>
					<TD WIDTH="300">
						<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
						<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
						<SPAN ID="orgName"><%= strOrgName %></SPAN>
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD></TD>
		<TD></TD>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><INPUT TYPE="checkbox" NAME="CheckboxOrgCd5Char" <%= IIf(Trim(strOrgCd5Char) = "", "", "CHECKED") %> ONCLICK="JavaScript:ChangeOrgCd5Char(this);" VALUE="1">
					<TD>�c�̃R�[�h�̐擪�T�����w�肷��</TD>
					<TD><INPUT TYPE="text" NAME="orgCd5Char" SIZE="6" MAXLENGTH="5" VALUE="<%= strOrgCd5Char %>">
					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>�R�[�X</TD>
		<TD>�F</TD>
		<TD><%= EditCourseList("csCd", strCsCd, "�S�ẴR�[�X") %></TD>
	</TR>

</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="500">
<TR>
	<TD><A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&transactionDiv=LOGBILLC"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���s���O���Q�Ƃ��܂�"></A></TD>
	
	<TD ALIGN="RIGHT">
	<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
		<A HREF="javascript:function voi(){};voi()" ONCLICK="return goFinish()" METHOD="post"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="�������ߊm��"></A>
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
