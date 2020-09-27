<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(�_����Ԃ̐ݒ�) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const ACTMODE_BROWSE = "browse"	'���샂�[�h(�Q��)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objContract			'�_����A�N�Z�X�p
Dim objContractControl	'�_����A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l(�V�K�E�X�V����)
Dim strActMode			'���샂�[�h(�Q��:"browse")
Dim strOpMode			'�������[�h
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strCsCd				'�R�[�X�R�[�h

'�O��ʂ��瑗�M�����p�����[�^�l(�X�V�̂�)
Dim strCtrPtCd			'�_��p�^�[���R�[�h

'���g�����_�C���N�g����ꍇ�̂ݑ��M�����p�����[�^�l
Dim strNext				'�u���ցv�{�^�������̗L��
Dim strSave				'�u�ۑ��v�{�^�������̗L��

'�_�����(���g���_�C���N�g���Ɋi�[�A�����̓f�[�^�x�[�X���擾)
Dim strStrYear			'�_��J�n�N
Dim strStrMonth 		'�_��J�n��
Dim strStrDay			'�_��J�n��
Dim strEndYear			'�_��I���N
Dim strEndMonth 		'�_��I����
Dim strEndDay			'�_��I����

'�_����
Dim strOrgName			'�c�̖�
Dim strCsName			'�R�[�X��
Dim dtmStrDate			'�_��J�n��
Dim dtmEndDate			'�_��I����
Dim strAgeCalc			'�N��N�Z��

'�_����ԏ��
Dim strArrCtrPtCd		'�_��p�^�[���R�[�h
Dim dtmArrStrDate		'�_��J�n��
Dim dtmArrEndDate		'�_��I����
Dim lngCount			'�_����

'�R�[�X�������
Dim dtmCsStrDate		'�R�[�X�K�p�J�n���t
Dim dtmCsEndDate		'�R�[�X�K�p�I�����t
Dim lngPrice			'�R�[�X��{����
Dim lngTax				'�����
Dim lngCsCount			'�R�[�X����

'�Œ�c�̃R�[�h
Dim strPerOrgCd1		'�l��f�p�c�̃R�[�h1
Dim strPerOrgCd2		'�l��f�p�c�̃R�[�h2
Dim strWebOrgCd1		'Web�p�c�̃R�[�h1
Dim strWebOrgCd2		'Web�p�c�̃R�[�h2

Dim lngMargin			'�}�[�W���l
Dim strStrDate			'�_��J�n�N����
Dim strEndDate			'�_��I���N����
Dim strMessage			'�G���[���b�Z�[�W
Dim strTitle			'���o��
Dim blnExist			'�_����̑��ݗL��
Dim strURL				'�W�����v���URL
Dim strHTML				'HTML������
Dim Ret					'�֐��߂�l
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�Z�b�V�����E�����`�F�b�N
If Request("actMode") = ACTMODE_BROWSE Then
	Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)
Else
	Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)
End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon          = Server.CreateObject("HainsCommon.Common")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'�O��ʂ��瑗�M�����p�����[�^�l�̎擾(�V�K�E�X�V����)
strActMode = Request("actMode")
strOpMode  = Request("opMode")
strOrgCd1  = Request("orgCd1")
strOrgCd2  = Request("orgCd2")
strCsCd    = Request("csCd")

'�O��ʂ��瑗�M�����p�����[�^�l�̎擾(�X�V�̂�)
strCtrPtCd = Request("ctrPtCd")

'���g�����_�C���N�g����ꍇ�̂ݑ��M�����p�����[�^�l�̎擾
strNext     = Request("next.x")
strSave     = Request("save.x")
strStrYear  = Request("strYear")
strStrMonth = Request("strMonth")
strStrDay   = Request("strDay")
strEndYear  = Request("endYear")
strEndMonth = Request("endMonth")
strEndDay   = Request("endDay")

'�f�t�H���g�l�̐ݒ�
'## 2003.11.07 Mod 6Lines By T.Takagi@FSIT �f�t�H���g�̊J�n���̓V�X�e�����t
'strStrYear  = IIf(strStrYear  = "", YEARRANGE_MIN, strStrYear )
'strStrMonth = IIf(strStrMonth = "",    "1", strStrMonth)
'strStrDay   = IIf(strStrDay   = "",    "1", strStrDay  )
strStrYear  = IIf(strStrYear  = "", Year(Date),  strStrYear )
strStrMonth = IIf(strStrMonth = "", Month(Date), strStrMonth)
strStrDay   = IIf(strStrDay   = "", Day(Date),   strStrDay  )
'## 2003.11.07 Mod End
strEndYear  = IIf(strEndYear  = "", YEARRANGE_MAX, strEndYear )
strEndMonth = IIf(strEndMonth = "",   "12", strEndMonth)
strEndDay   = IIf(strEndDay   = "",   "31", strEndDay  )

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'�u���ցv�u�ۑ��v�{�^��������
	If strNext <> "" Or strSave <> "" Then

		'�_��J�n�I���N�����`�F�b�N
		Do
			'�_��J�n���̕K�{�`�F�b�N
			If strStrYear = "" And strStrMonth = "" And strStrDay = "" Then
				strMessage = "�_��J�n������͂��ĉ������B"
				Exit Do
			End If

			'�_��J�n�N�����̕ҏW
			strStrDate = strStrYear & "/" & strStrMonth & "/" & strStrDay

			'�_��J�n�N�����̓��t�`�F�b�N
			If Not IsDate(strStrDate) Then
				strMessage = "�_��J�n���̓��͌`��������������܂���B"
				Exit Do
			End If

			'�_��I�����������͂ł���΃`�F�b�N�I��
			If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
				Exit Do
			End If

			'�_��I���N�����̕ҏW
			strEndDate = strEndYear & "/" & strEndMonth & "/" & strEndDay

			'�_��I���N�����̓��t�`�F�b�N
			If Not IsDate(strEndDate) Then
				strMessage = "�_��I�����̓��͌`��������������܂���B"
				Exit Do
			End If

			'�_��J�n�E�I���N�����͈̔̓`�F�b�N
			If CDate(strStrDate) > CDate(strEndDate) Then
				strMessage = "�_��J�n�E�I�����͈͎̔w�肪����������܂���B"
				Exit Do
			End If

			Exit Do
		Loop

		'�N�����`�F�b�N�ɂăG���[�����݂���ꍇ�͏������I������
		If strMessage <> "" Then
			Exit Do
		End If

		'����c�́E�R�[�X�ɂ����Ċ����̌_����ƌ_����Ԃ��d�����Ȃ������`�F�b�N����
		If objContract.CheckContractPeriod(strOrgCd1, strOrgCd2, strCsCd, strCtrPtCd, strStrDate, strEndDate) = True Then
			strMessage = "���łɓo�^�ς݂̌_����ƌ_����Ԃ��d�����܂��B"
			Exit Do
		End If

		'�u���ցv�{�^��������(�����V�K��)
		If strNext <> "" Then

			'�_��K�p���Ԃ��R�[�X�K�p���ԂɊ܂܂�邩�`�F�b�N
			If objCourse.GetHistoryCount(strCsCd, strStrDate, strEndDate) <= 0 Then
				strMessage = "�w�肳�ꂽ�_����ԂɓK�p�\�ȃR�[�X���������݂��܂���B"
				Exit Do
			End If

			'�����܂Ő���ł���Ύ���ʂ֑J��

			'�_����̎Q�ƁE�R�s�[���s���ꍇ�͎Q�Ɛ�c�̂̑I����ʂ�
			If strActMode = ACTMODE_BROWSE Then

				'�l��f�Aweb�p�c�̃R�[�h�̎擾
				objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
				objCommon.GetOrgCd ORGCD_KEY_WEB,    strWebOrgCd1, strWebOrgCd2

				'web�\��̏ꍇ�͒��ڌ_����̑I����ʂɑJ�ڂ��A����ȊO�͎Q�Ɛ�_��c�̂̌�����ʂ�
				If strOrgCd1 = strWebOrgCd1 And strOrgCd2 = strWebOrgCd2 Then
					strURL = "ctrBrowseContract.asp?opMode=" & strOpMode & "&refOrgCd1=" & strPerOrgCd1 & "&refOrgCd2=" & strPerOrgCd2 & "&"
				Else
					strURL = "ctrBrowseOrg.asp?opMode=" & strOpMode & "&"
				End If

			'�V�K�_��쐬���͕��S���E���S���z�̐ݒ��
			Else
				strURL = "ctrDemand.asp?"
			End If

			'QueryString�l�̕ҏW
			strURL = strURL & "orgCd1="   & strOrgCd1   & "&"
			strURL = strURL & "orgCd2="   & strOrgCd2   & "&"
			strURL = strURL & "csCd="     & strCsCd     & "&"
			strURL = strURL & "strYear="  & strStrYear  & "&"
			strURL = strURL & "strMonth=" & strStrMonth & "&"
			strURL = strURL & "strDay="   & strStrDay   & "&"
			strURL = strURL & "endYear="  & strEndYear  & "&"
			strURL = strURL & "endMonth=" & strEndMonth & "&"
			strURL = strURL & "endDay="   & strEndDay

			'����ʂփ��_�C���N�g
			Response.Redirect strURL
			Response.End

		End If

		'�ȉ��́u�ۑ��v�{�^��������(�����X�V��)�̏����ƂȂ�

		'�_����Ԃ̍X�V
		Ret = objContractControl.UpdatePeriod(strOrgCd1, strOrgCd2, strCsCd, strCtrPtCd, strStrDate, strEndDate)
		Select Case Ret
			Case 0
			Case 1
				strMessage = "�w�肳�ꂽ�_����ԂɓK�p�\�ȃR�[�X���������݂��܂���B"
				Exit Do
			Case 2
				strMessage = "���łɓo�^�ς݂̌_����ƌ_����Ԃ��d�����܂��B"
				Exit Do
			Case 3
				strMessage = "�_����Ԃ̕ύX�ɂ��A���̌_����̎Q�Ƃ��ł��Ȃ��Ȃ��f��񂪔������܂��B�ύX�ł��܂���B"
				Exit Do
			Case Else
				Exit Do
		End Select

		'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
		strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
		strHTML = strHTML & "<BODY ONLOAD=""JavaScript:if ( opener != null ) opener.location.reload(); close()"">"
		strHTML = strHTML & "</BODY>"
		strHTML = strHTML & "</HTML>"
		Response.Write strHTML
		Response.End

		Exit Do
	End If

	'�_��p�^�[���R�[�h�w�莞(�����X�V��)
	If strCtrPtCd <> "" Then

		'�_��p�^�[�����̓ǂݍ���
		If objContract.SelectCtrPt(strCtrPtCd, dtmStrDate, dtmEndDate, strAgeCalc) = False Then
			Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
		End If

		'�_��J�n�E�I��������N�����𒊏o
		strStrYear  = CStr(DatePart("yyyy", dtmStrDate))
		strStrMonth = CStr(DatePart("m",    dtmStrDate))
		strStrDay   = CStr(DatePart("d",    dtmStrDate))
		strEndYear  = CStr(DatePart("yyyy", dtmEndDate))
		strEndMonth = CStr(DatePart("m",    dtmEndDate))
		strEndDay   = CStr(DatePart("d",    dtmEndDate))

	End If

	Exit Do
Loop

'�}�[�W���l�̐ݒ�
lngMargin = IIf(strActMode = ACTMODE_BROWSE, 0, 20)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�_����Ԃ̐ݒ�</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<style type="text/css">
	td.mnttab { background-color:#FFFFFF }
	body { margin: <%= lngMargin %>px 0 0 0; }
</style>
</HEAD>
<BODY>
<%
'�_����̎Q�ƁE�R�s�[���s���ꍇ�̓i�r��ҏW
If strActMode = ACTMODE_BROWSE Then
%>
<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<%
End If
%>
<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>
<%
	'�_��p�^�[���R�[�h�w�莞�͂��̓��e��hidden�ŕێ�
	If strCtrPtCd <> "" Then
%>
		<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">
<%
	End If

	'�_����̎Q�ƁE�R�s�[���s���ꍇ���샂�[�h�E�������[�h�̒l��ێ�
	If strActMode = ACTMODE_BROWSE Then
%>
		<INPUT TYPE="hidden" NAME="actMode" VALUE="<%= strActMode %>">
		<INPUT TYPE="hidden" NAME="opMode"  VALUE="<%= strOpMode  %>">
<%
	End If
%>
	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
	<INPUT TYPE="hidden" NAME="csCd" VALUE="<%= strCsCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�_����Ԃ̎w��</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
	<BR>
<%
	'�c�̖��̓ǂݍ���
	If objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName) = False Then
		Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
	End If

	'�R�[�X���̓ǂݍ���
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "�R�[�X��񂪑��݂��܂���B"
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>�_��c��</TD>
			<TD>�F</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'�������@�ɉ��������b�Z�[�W��ҏW����
%>
	<FONT COLOR="#cc9999">��</FONT><%= IIf(strActMode = ACTMODE_BROWSE, "�R�s�[����_�����K�p����", "") %>�_����Ԃ��w�肵�ĉ������B<BR>
	<FONT COLOR="#cc9999">��</FONT>���łɓo�^����Ă���_����̌_����Ԃɂ܂�������t�w��͂ł��܂���B<BR><BR>

	<TABLE BORDER="0" CELLPADDING="" CELLSPACING="2">
		<TR>
			<TD>�_��J�n���F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('strYear', 'strMonth', 'strDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditSelectNumberList("strYear", YEARRANGE_MIN, YEARRANGE_MAX, CLng("0" & strStrYear))  %></TD>
			<TD>�N</TD>
			<TD><%= EditSelectNumberList("strMonth",   1,   12, CLng("0" & strStrMonth)) %></TD>
			<TD>��</TD>
			<TD><%= EditSelectNumberList("strDay",     1,   31, CLng("0" & strStrDay))   %></TD>
			<TD>��</TD>
		</TR>
		<TR>
			<TD>�_��I�����F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('endYear', 'endMonth', 'endDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, CLng("0" & strEndYear)) %></TD>
			<TD>�N</TD>
			<TD><%= EditSelectNumberList("endMonth", 1, 12, CLng("0" & strEndMonth)) %></TD>
			<TD>��</TD>
			<TD><%= EditSelectNumberList("endDay", 1, 31, CLng("0" & strEndDay)) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<BR><BR>
<%
	'���_����̌_����ԓǂݍ���
	lngCount = objContract.SelectCtrMngWithPeriod(strOrgCd1, strOrgCd2, strCsCd, strArrCtrPtCd, dtmArrStrDate, dtmArrEndDate)

	'�V�K�E�_����Ԃ̕ύX���Ƃɉ��������o���̕ҏW
	strTitle = strCsName & "��" & IIf(strCtrPtCd = "", "����", "���̑�") & "�̌_����F"

	'�_����̑��ݗL���𔻒�
	'(�V�K�쐬����1���ł����݂���΁A�Ƃ�������ŗǂ����A�_����ԕύX���͐�ɓǂݍ��񂾌_����ԏ��ɕK�����ݕҏW���̌_���񂪊܂܂��B
	'�̂Ɍ_����ԏ��1�������Ȃ��ꍇ�A����͌��ݕҏW���̌_����ƈ�v���邽�߁A���̍l���������ōs���B)
	blnExist = IIf(strCtrPtCd = "", (lngCount > 0), (lngCount > 1))

	'�_����Ԃ����݂���ꍇ�̕ҏW����
	If blnExist Then
%>
		<%= strTitle %>
		<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
			<TR BGCOLOR="#cccccc">
				<TD>�_�����</TD>
			</TR>
<%
			'�_����Ԉꗗ�̕ҏW
			For i = 0 To lngCount - 1

				'���ݕҏW���_����ȊO�̌_����Ԃ�ҏW����
				If strArrCtrPtCd(i) <> strCtrPtCd Then
%>
					<TR BGCOLOR="#eeeeee">
						<TD><%= dtmArrStrDate(i) %>�`<%= dtmArrEndDate(i) %></TD>
					</TR>
<%
				End If

			Next
%>
		</TABLE>
<%
	'�_����Ԃ����݂��Ȃ��ꍇ
	Else
%>
		<%= strTitle %>�Ȃ�
<%
	End If
%>
	<BR><BR>
<%
	'�R�[�X�����̓ǂݍ���
	lngCsCount = objCourse.SelectCourseHistory(strCsCd, 0, 0, dtmCsStrDate, dtmCsEndDate, lngPrice, lngTax)
%>
	�R�[�X�̗����F
	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR BGCOLOR="#cccccc">
			<TD NOWRAP>�K�p����</TD>
<!--
			<TD ALIGN="right"><IMG SRC="/webHains/images/spacer.gif" WIDTH="85" HEIGHT="1"><BR>��{����</TD>
			<TD ALIGN="right"><IMG SRC="/webHains/images/spacer.gif" WIDTH="85" HEIGHT="1"><BR>�����</TD>
-->
		</TR>
<%
		'�R�[�X�ꗗ�̕ҏW
		For i = 0 To lngCsCount - 1
%>
			<TR BGCOLOR="#eeeeee">
				<TD><%= dtmCsStrDate(i) %>�`<%= dtmCsEndDate(i) %></TD>
<!--
				<TD ALIGN="right"><%= FormatCurrency(lngPrice(i)) %></TD>
				<TD ALIGN="right"><%= FormatCurrency(lngTax(i)) %></TD>
-->
			</TR>
<%
		Next
%>
	</TABLE>

	<BR><BR>
<%
	'�_��p�^�[���R�[�h���w�莞�́u�߂�v�u���ցv�{�^����z�u
	If strCtrPtCd = "" Then
%>
		<A HREF="JavaScript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
		<INPUT TYPE="image" NAME="next" SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����">
<%
	'�_��p�^�[���R�[�h�w�莞�́u�ۑ��v�u�L�����Z���v�{�^����z�u
	Else
%>
		<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>

        <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
    	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
		    <INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�">
        <%  else    %>
             &nbsp;
        <%  end if  %>
        <% '2005.08.22 �����Ǘ� Add by ���@--- END %>

<%
	End If
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
