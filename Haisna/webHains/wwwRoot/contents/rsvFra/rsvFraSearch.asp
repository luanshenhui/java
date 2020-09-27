<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �\��g�̌��� (Ver0.0.1)
'	   AUTHER  : keiko fujii@ffcs.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objSchedule			'�\����A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p

Dim strMode				'�������[�h(�}��:"insert"�A�X�V:"update")
Dim strAction			'�������(�ۑ��{�^��������:"save"�A�ۑ�������:"saveend")


Dim strStartCslDate     	'����������f�N�����i�J�n�j
Dim strStartYear     		'����������f�N�i�J�n�j
Dim strStartMonth     		'����������f���i�J�n�j
Dim strStartDay     		'����������f���i�J�n�j
Dim strEndCslDate     		'����������f�N�����i�I���j
Dim strEndYear     			'����������f�N�i�I���j
Dim strEndMonth     		'����������f���i�I���j
Dim strEndDay     			'����������f���i�I���j
Dim strSearchCsCd	    	'���������R�[�X�R�[�h
Dim lngSearchRsvGrpCd    	'���������\��Q�R�[�h

Dim vntCslDate          	'��f��
Dim vntCsCd		          	'�R�[�X�R�[�h
Dim vntCsName           	'�R�[�X��
Dim vntWebColor           	'�R�[�X�F
Dim vntRsvGrpCd         	'�\��Q�R�[�h
Dim vntRsvGrpName         	'�\��Q����
Dim vntMngGender			'�j���ʘg�Ǘ�
Dim vntMaxCnt				'�\��\�l���i���ʁj
Dim vntMaxCnt_M	    	   	'�\��\�l���i�j�j
Dim vntMaxCnt_F	       		'�\��\�l���i���j
Dim vntOverCnt		       	'�I�[�o�\�l���i���ʁj
Dim vntOverCnt_M	       	'�I�[�o�\�l���i�j�j
Dim vntOverCnt_F	       	'�I�[�o�\�l���i���j
Dim vntRsvCnt_M	       		'�\��ςݐl���i�j�j
Dim vntRsvCnt_F		        '�\��ςݐl���i���j

Dim lngRsvFraCnt				'�\��g��

Dim strArrMessage		'�G���[���b�Z�[�W

Dim i				'�J�E���^

Dim Ret				'�֐��߂�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objSchedule     = Server.CreateObject("HainsSchedule.Schedule")
'## 2004.03.12 Del By T.Takagi@FSIT �R�[�X�o�͏����ύX
'Set objCourse       = Server.CreateObject("HainsCourse.Course")
'## 2004.03.12 Del End

'�����l�̎擾
strMode           = Request("mode")
strAction         = Request("action")
strStartYear      = Request("startYear")
strStartMonth     = Request("startMonth")
strStartDay       = Request("startDay")
strEndYear        = Request("endYear")
strEndMonth       = Request("endMonth")
strEndDay         = Request("endDay")
strSearchCsCd     = Request("searchCsCd")
lngSearchRsvGrpCd   = Request("searchRsvGrp")

'�f�t�H���g�̓V�X�e���N������K�p����
If strStartYear = "" And strStartMonth = "" And strStartDay = "" Then
	strStartYear  = CStr(Year(Now))
	strStartMonth = CStr(Month(Now))
	strStartDay   = CStr(Day(Now))
End If
If strEndYear = "" And strEndMonth = "" And strEndDay = "" Then
	strEndYear  = CStr(Year(Now))
	strEndMonth = CStr(Month(Now))
	strEndDay   = CStr(Day(Now))
End If


Do

	'�����J�n
	If strAction = "search" Then
		objCommon.AppendArray strArrMessage, objCommon.CheckDate("�J�n��f��", strStartYear, strStartMonth, strStartDay, strStartCslDate, CHECK_NECESSARY)
		objCommon.AppendArray strArrMessage, objCommon.CheckDate("�I����f��", strEndYear, strEndMonth, strEndDay, strEndCslDate, CHECK_NECESSARY)

		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'�����J�n��f���̕ҏW
		strStartCslDate = CDate(strStartYear & "/" & strStartMonth & "/" & strStartDay)
		'�����I����f���̕ҏW
		strEndCslDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)


		'���������ɏ]���\��l���Ǘ��ꗗ�𒊏o����
		lngRsvFraCnt = objSchedule.SelectRsvFraMngList( _
                    strStartCslDate, strEndCslDate, _
                    strSearchCsCd & "", _
                    lngSearchRsvGrpCd & "", _
                    vntCslDate, _
                    vntCsCd, _
                    vntCsName, _
                    vntWebColor, _
                    vntRsvGrpCd, _
                    vntRsvGrpName, _
                    vntMngGender, _
                    vntMaxCnt, _
                    vntMaxCnt_M, _
                    vntMaxCnt_F, _
                    vntOverCnt, _
                    vntOverCnt_M, _
                    vntOverCnt_F, _
                    vntRsvCnt_M, _
                    vntRsvCnt_F _
                    )
	End If


	Exit Do
Loop


'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �R�[�X�R�[�h�̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ :
'
' �߂�l�@ : HTML������
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CsCdList()

	Dim strArrCsCdID		'�R�[�X�R�[�h
	Dim strArrCsCdName		'�R�[�X��

	Dim lngCsCsCnt			'����

'## 2004.03.12 Mod By T.Takagi@FSIT �R�[�X�o�͏����ύX�B�\��Q�����R�[�X�����o���Ȃ��Ă��悢
'	lngCsCsCnt = objCourse.SelectCourseList ( strArrCsCdID, strArrCsCdName )
	lngCsCsCnt = objSchedule.SelectCourseListRsvGrpManaged ( strArrCsCdID, strArrCsCdName )
'## 2004.03.12 Mod End

	If lngCsCsCnt = 0 Then
		strArrCsCdID = Array()
		Redim Preserve strArrCsCdID(0)
		strArrCsCdName = Array()
		Redim Preserve strArrCsCdName(0)
	End If

	CsCdList = EditDropDownListFromArray("searchCsCd", strArrCsCdID, strArrCsCdName, strSearchCsCd, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\��Q�̃h���b�v�_�E�����X�g�ҏW
'
' �����@�@ :
'
' �߂�l�@ : HTML������
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function RsvGrpList()

	Dim strArrRsvGrpID			'�\��Q�R�[�h
	Dim strArrRsvGrpName		'�\��Q��

	Dim lngRsvGrpCnt			'����

	lngRsvGrpCnt = objSchedule.SelectRsvGrpList ( 0, strArrRsvGrpID, strArrRsvGrpName )

	If lngRsvGrpCnt = 0 Then
		strArrRsvGrpID = Array()
		Redim Preserve strArrRsvGrpID(0)
		strArrRsvGrpName = Array()
		Redim Preserve strArrRsvGrpName(0)
	End If

	RsvGrpList = EditDropDownListFromArray("searchRsvGrp", strArrRsvGrpID, strArrRsvGrpName, lngSearchRsvGrpCd, NON_SELECTED_ADD)

End Function

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�\��g�̌���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">

<!--
var winEditRsvFra;		// �\��g�o�^�E�C���E�B���h�E�n���h��
//�\��g�o�^�E�C���E�B���h�E�\��
function editRsvFraWindow( mode, cslDate, cscd, rsvGrpCd) {

	var objForm = document.entrySearch;	// ����ʂ̃t�H�[���G�������g

	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winEditRsvFra != null ) {
		if ( !winEditRsvFra.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/RsvFra/editRsvFra.asp';
	url = url + '?mode=' + mode;
	url = url + '&action=';
	url = url + '&cslDate=' + cslDate;
	url = url + '&cscd=' + cscd;
	url = url + '&rsvGrpCd=' + rsvGrpCd;


	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winEditRsvFra.focus();
		winEditRsvFra.location.replace(url);
	} else {
		winEditRsvFra = window.open( url, '', 'width=550,height=435,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}
}

var winGuideCal;
// ���t�K�C�h�Ăяo��
function callCalGuide(year, month, day) {


	// ���t�K�C�h�\��
	calGuide_showGuideCalendar( year, month, day, '' );

}

// �A�����[�h���̏���
function closeGuideWindow() {

	// �\��g�o�^�E�C���E�B���h�E�E�C���h�E�����
	if ( winEditRsvFra != null ) {
		if ( !winEditRsvFra.closed ) {
			winEditRsvFra.close();
		}
	}

	winEditRsvFra = null;

	// ���t�K�C�h�����
	calGuide_closeGuideCalendar();

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entrySearch" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="action" VALUE="search">
<BLOCKQUOTE>

<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="635">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�\��g�̌���</FONT></B></TD>
	</TR>
</TABLE>

<BR>
<!-- �����͌������� -->
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
	<TR>
		<TD WIDTH="90" NOWRAP>��f���͈�</TD>
		<TD>�F</TD>
		<TD><A HREF="javascript:callCalGuide('startYear', 'startMonth', 'startDay')"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
		<TD><%= EditSelectNumberList("startYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strStartYear)) %></TD>
		<TD>�N</TD>
		<TD><%= EditSelectNumberList("startMonth", 1, 12, Clng("0" & strStartMonth)) %></TD>
		<TD>��</TD>
		<TD><%= EditSelectNumberList("startDay",   1, 31, Clng("0" & strStartDay  )) %></TD>
		<TD NOWRAP>���`</TD>
		<TD><A HREF="javascript:callCalGuide('endYear', 'endMonth', 'endDay' )"><IMG SRC="/webHains/images/question.gif" ALT="���t�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
		<TD><%= EditSelectNumberList("endYear", YEARRANGE_MIN, YEARRANGE_MAX, Clng("0" & strEndYear)) %></TD>
		<TD>�N</TD>
		<TD><%= EditSelectNumberList("endMonth", 1, 12, Clng("0" & strEndMonth)) %></TD>
		<TD>��</TD>
		<TD><%= EditSelectNumberList("endDay",   1, 31, Clng("0" & strEndDay  )) %></TD>
		<TD>��</TD>
	</TR>
</TABLE>
<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="635">
	<TR>
		<TD WIDTH="90" NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="90" HEIGHT="1" ALT=""><BR>�R�[�X�R�[�h</TD>
		<TD>�F</TD>
		<TD WIDTH="100%"><%= CsCdList() %></TD>
		<TD ROWSPAN="2" VALIGN="bottom"><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entrySearch.submit();return false;"><IMG SRC="../../images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
		
        <% If Session("PAGEGRANT") = "4" Then %>
            <TD ROWSPAN="2" VALIGN="bottom"><A HREF="JavaScript:editRsvFraWindow('insert', '', '',0 )"><IMG SRC="../../images/newrsv.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="�V�K�ɓo�^"></A></TD>
        <% End IF %>

	</TR>
	<TR>
		<TD>�\��Q</TD>
		<TD>�F</TD>
		<TD><%= RsvGrpList() %></TD>
	</TR>
</TABLE>

<BR>
<!--�����͌�����������--><SPAN STYLE="font-size:9pt;">
�u<FONT COLOR="#ff6600"><B><%= strStartYear %>�N<%= strStartMonth %>��<%= strStartDay %>���`<%= strEndYear %>�N<%= strEndMonth %>��<%= strEndDay %>��</B></FONT>�v�̗\��g�ꗗ��\�����Ă��܂��B<BR>
�Ώۗ\��g�� <FONT COLOR="#ff6600"><B><%= lngRsvFraCnt %></B></FONT>���ł��B </SPAN><BR>
<BR>
<SPAN STYLE="color:#cc9999">��</SPAN><FONT COLOR="black">��f�����N���b�N����ƑΏۂ̗\��g�ݒ���e�C����ʂ��\������܂��B</FONT><BR>
<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
	<!-- �����͈ꗗ�̌��o�� -->
	<TR BGCOLOR="cccccc" ALIGN="center">
		<TD ROWSPAN="2" NOWRAP>��f��</TD>
		<TD ROWSPAN="2" NOWRAP>��f�R�[�X</TD>
		<TD ROWSPAN="2" NOWRAP>�\��Q</TD>
		<TD COLSPAN="3" NOWRAP>�\��\�l��</TD>
		<TD COLSPAN="3" NOWRAP>�I�[�o�\�l��</TD>
		<TD COLSPAN="2" NOWRAP>�\��ςݐl��</TD>
	</TR>
	<TR BGCOLOR="#cccccc" ALIGN="center">
		<TD NOWRAP WIDTH="50">����</TD>
		<TD NOWRAP WIDTH="50">�j</TD>
		<TD NOWRAP WIDTH="50">��</TD>
		<TD NOWRAP WIDTH="50">����</TD>
		<TD NOWRAP WIDTH="50">�j</TD>
		<TD NOWRAP WIDTH="50">��</TD>
		<TD NOWRAP WIDTH="50">�j</TD>
		<TD NOWRAP WIDTH="50">��</TD>
	</TR>
<%
	For i = 0 To lngRsvFraCnt - 1
		If i mod 2 = 0 Then
%>
			<TR BGCOLOR="#ffffff" ALIGN="right">
<%
		Else
%>
			<TR BGCOLOR="#eeeeee" ALIGN="right">
<%
		End If
%>
		<TD ALIGN="left" NOWRAP><A HREF="JavaScript:editRsvFraWindow('update','<%= vntCslDate(i) %>', '<%= vntCsCd(i) %>' ,<%= vntRsvGrpCd(i) %>)"><%= vntCslDate(i) %></A></TD>
<%
		If IsNull(vntWebColor(i)) = True Then
%>
			<TD ALIGN="left" NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>"> </FONT><%= vntCsName(i) %></TD>
<%
		Else
%>
			<TD ALIGN="left" NOWRAP><FONT COLOR="#<%= vntWebColor(i) %>">�� </FONT><%= vntCsName(i) %></TD>
<%
		End If
%>
			<TD ALIGN="left" NOWRAP><%= vntRsvGrpName(i) %></TD>
			<TD NOWRAP><%= vntmaxCnt(i) %></TD>
			<TD NOWRAP><%= vntMaxCnt_M(i) %></TD>
			<TD NOWRAP><%= vntMaxCnt_F(i) %></TD>
			<TD NOWRAP><%= vntOverCnt(i) %></TD>
			<TD NOWRAP><%= vntOverCnt_M(i) %></TD>
			<TD NOWRAP><%= vntOverCnt_F(i) %></TD>
			<TD NOWRAP><%= vntRsvCnt_M(i) %></TD>
			<TD NOWRAP><%= vntRsvCnt_F(i) %></TD>
		</TR>
<%
	Next
%>
</TABLE>
<BR>
<BR>
<BR>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="ffffff">.</FONT></DIV>

</BODY>
</HTML>
