<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(�_����Ԃ̕���) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objContract			'�_����A�N�Z�X�p
Dim objContractControl	'�_����A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strCtrPtCd			'�_��p�^�[���R�[�h

'�_�����(���g���_�C���N�g���Ɋi�[)
Dim strYear				'�����N
Dim strMonth 			'������
Dim strDay				'������

'�_��Ǘ����
Dim strOrgName			'�c�̖�
Dim strCsCd				'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��
Dim dtmStrDate			'�_��J�n��
Dim dtmEndDate			'�_��I����

Dim strDate				'������
Dim strStrDate			'�_��J�n�N����
Dim strEndDate			'�_��I���N����
Dim strMessage			'�G���[���b�Z�[�W
Dim strURL				'�W�����v���URL
Dim strHTML				'HTML������
Dim Ret					'�֐��߂�l
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon          = Server.CreateObject("HainsCommon.Common")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'�O��ʂ��瑗�M�����p�����[�^�l�̎擾
strOrgCd1  = Request("orgCd1")
strOrgCd2  = Request("orgCd2")
strCtrPtCd = Request("ctrPtCd")

'���g�����_�C���N�g����ꍇ�̂ݑ��M�����p�����[�^�l�̎擾
strYear  = Request("year")
strMonth = Request("month")
strDay   = Request("day")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'�ۑ��{�^��������
	If Not IsEmpty(Request("save.x")) Then

		'�������`�F�b�N
		Do
			'�_��J�n���̕K�{�`�F�b�N
			If strYear = "" And strMonth = "" And strDay = "" Then
				strMessage = "����������͂��ĉ������B"
				Exit Do
			End If

			'�_��J�n�N�����̕ҏW
			strDate = strYear & "/" & strMonth & "/" & strDay

			'�������̓��t�`�F�b�N
			If Not IsDate(strDate) Then
				strMessage = "�K�p�J�n���̓��͌`��������������܂���B"
				Exit Do
			End If

			Exit Do
		Loop

		'�N�����`�F�b�N�ɂăG���[�����݂���ꍇ�͏������I������
		If strMessage <> "" Then
			Exit Do
		End If

		'�_����Ԃ̍X�V
		Ret = objContractControl.Split(strOrgCd1, strOrgCd2, strCtrPtCd, strDate)
		Select Case Ret
			Case 0
			Case 1
				strMessage = "���̌_����͕����ł��܂���B"
				Exit Do
			Case 2
				strMessage = "�������͕K���_����ԓ��̓��t�Ŏw�肵�ĉ������B"
				Exit Do
'## 2004.01.27 Add By T.Takagi@FSIT �������ȍ~�Ɏ�t��񂪂���Ε����s��
			Case 3
				strMessage = "�������ȍ~�Ɏ�t�ςݎ�f��񂪑��݂��܂��B�����ł��܂���B"
				Exit Do
'## 2004.01.27 Add End
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
<TITLE>�_����Ԃ̕���</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryform" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="orgCd1"  VALUE="<%= strOrgCd1  %>">
	<INPUT TYPE="hidden" NAME="orgCd2"  VALUE="<%= strOrgCd2  %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="85%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�_����Ԃ̕���</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)

	'�_����̓ǂݍ���
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
	End If

	'�ҏW�p�̌_��J�n���ݒ�
	If Not IsEmpty(dtmStrDate) Then
		strStrDate = FormatDateTime(dtmStrDate, 1)
	End If

	'�ҏW�p�̌_��I�����ݒ�
	If Not IsEmpty(dtmEndDate) Then
		strEndDate = FormatDateTime(dtmEndDate, 1)
	End If
%>
	<BR>

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
			<TD NOWRAP>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>�_�����</TD>
			<TD>�F</TD>
			<TD NOWRAP><B><%= strStrDate %>�`<%= strEndDate %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD><FONT COLOR="#cc9999">��</FONT></TD>
			<TD COLSPAN="7">���̌_����Ԃ𕪊����镪�������w�肵�ĉ������B</TD>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP>�i��j</TD>
			<TD></TD>
			<TD>�_�����</TD>
			<TD>�F</TD>
			<TD ALIGN="right" NOWRAP>2001�N</TD>
			<TD ALIGN="right" NOWRAP>4��</TD>
			<TD ALIGN="right" NOWRAP>1��</TD>
			<TD>�`</TD>
			<TD ALIGN="right" NOWRAP>2002�N</TD>
			<TD ALIGN="right" NOWRAP>&nbsp;&nbsp;3��</TD>
			<TD ALIGN="right" NOWRAP>&nbsp;31��</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD COLSPAN="3"></TD>
			<TD NOWRAP>������</TD>
			<TD>�F</TD>
			<TD ALIGN="right" NOWRAP>2001�N</TD>
			<TD ALIGN="right" NOWRAP>9��</TD>
			<TD ALIGN="right" NOWRAP>30��</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD COLSPAN="3"></TD>
			<TD NOWRAP>������̌_�����</TD>
			<TD>�F</TD>
			<TD ALIGN="right" NOWRAP>2001�N</TD>
			<TD ALIGN="right" NOWRAP>4��</TD>
			<TD ALIGN="right" NOWRAP>1��</TD>
			<TD>�`</TD>
			<TD ALIGN="right" NOWRAP>2001�N</TD>
			<TD ALIGN="right" NOWRAP>9��</TD>
			<TD ALIGN="right" NOWRAP>30��</TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD COLSPAN="5"></TD>
			<TD ALIGN="right" NOWRAP>2001�N</TD>
			<TD ALIGN="right" NOWRAP>10��</TD>
			<TD ALIGN="right" NOWRAP>1��</TD>
			<TD>�`</TD>
			<TD ALIGN="right" NOWRAP>2002�N</TD>
			<TD ALIGN="right" NOWRAP>3��</TD>
			<TD ALIGN="right" NOWRAP>31��</TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="" CELLSPACING="2">
		<TR>
			<TD>�������F</TD>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditSelectNumberList("year", 2000, YEARRANGE_MAX, CLng("0" & strYear) ) %></TD>
			<TD>�N</TD>
			<TD><%= EditSelectNumberList("month",1,      12, CLng("0" & strMonth)) %></TD>
			<TD>��</TD>
			<TD><%= EditSelectNumberList("day",  1,      31, CLng("0" & strDay)  ) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>

    <% '2005.08.22 �����Ǘ� Add by ���@--- START %>
   	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
    	<INPUT TYPE="image" NAME="save" SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�">
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 �����Ǘ� Add by ���@--- END %>

	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
