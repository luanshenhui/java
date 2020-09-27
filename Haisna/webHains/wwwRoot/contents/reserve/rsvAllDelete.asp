<%@ LANGUAGE="VBScript" %>
<%
'-------------------------------------------------------------------------------
'		�b�r�u�t�@�C������̈ꊇ�\��폜 (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-------------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'COM�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objContract		'�_����A�N�Z�X�p
Dim objCreateCsv	'�b�r�u�t�@�C���쐬�p
Dim objImport		'�l����荞�ݗp
Dim objOrganization	'�c�̏��A�N�Z�X�p
Dim objParse		'POST�f�[�^��͗p

'POST���ꂽ���
Dim strName			'�G�������g��
Dim strFileName		'�t�@�C����
Dim strContentType	'content-type�l
Dim strContent		'�G�������g�l

'�����l
Dim strOrgCd1		'�c�̃R�[�h�P
Dim strOrgCd2		'�c�̃R�[�h�Q
Dim strCtrPtCd		'�_��p�^�[���R�[�h
Dim strCsvFileName	'CSV�t�@�C����
Dim strStartPos		'�ǂݍ��݊J�n�ʒu
Dim strReadCount	'�ǂݍ��݃��R�[�h��
Dim strDelCount		'�폜��f���

'�_����
Dim strCsCd			'�R�[�X�R�[�h
Dim strCsName		'�R�[�X��
Dim dtmStrDate		'�_��J�n��
Dim dtmEndDate		'�_��I����

Dim strUpdUser		'�X�V��
Dim vntPostedData	'POST�f�[�^
Dim lngCnt			'POST�f�[�^�̃T�C�Y
Dim strOrgName		'�c�̖���
Dim strMessage		'�G���[���b�Z�[�W
Dim strURL			'�W�����v���URL

Dim objExec			'��荞�ݏ������s�p
Dim strCommand		'�R�}���h���C��������

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'�����l�̎擾
strOrgCd1    = Request.QueryString("orgCd1")
strOrgCd2    = Request.QueryString("orgCd2")
strCtrPtCd   = Request.QueryString("ctrPtCd")
strStartPos  = Request.QueryString("startPos")
strReadCount = Request.QueryString("readCount")
strDelCount  = Request.QueryString("delCount")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	'������QueryString�ɂēn����Ă���ꍇ
	If strOrgCd1 <> "" Then
		strMessage = "�ǂݍ��݃��R�[�h����" & strReadCount & "�A�폜��f��񐔁�" & strDelCount
		Exit Do
	End If

	'�f�[�^��POST����Ă��Ȃ���Ή������Ȃ�
	lngCnt = Request.TotalBytes
	If lngCnt <= 0 Then
		Exit Do
	End If

	'POST�f�[�^�̎擾
	vntPostedData = Request.BinaryRead(lngCnt)

	Set objParse = Server.CreateObject("HainsCooperation.Parse")

	'���
	objParse.ParseMulti Request.ServerVariables("CONTENT_TYPE"), vntPostedData, strName, strFileName, strContentType, strContent

	Set objParse = Nothing

	'�����l�̎擾
	strOrgCd1      = strContent(0)
	strOrgCd2      = strContent(1)
	strCtrPtCd     = strContent(2)
	strCsvFileName = strFileName(3)
	strStartPos    = strContent(4)

	'���̓`�F�b�N
	strMessage = CheckValue()
	If Not IsEmpty(strMessage) Then
		Exit Do
	End If

	Set objCreateCsv = Server.CreateObject("HainsCreateCsv.CreateCsv")

	'POST�f�[�^����ꎞ�t�@�C�����쐬
	strFileName = objCreateCsv.ConvertStreamToFile(strContent(3))

	Set objCreateCsv = Nothing

	'�쐬���ׂ��o�̓t�@�C�����̒�`

	Set objImport = Server.CreateObject("HainsCooperation.Truncate")

	'��f���̍폜
	objImport.DeleteFromCsvFile strFileName, strOrgCd1, strOrgCd2, strUpdUser, strCtrPtCd, CLng("0" & strStartPos), strReadCount, strDelCount

	Set objImport = Nothing

	Set objCreateCsv = Server.CreateObject("HainsCreateCsv.CreateCsv")

	'�ꎞ�t�@�C�����폜
	objCreateCsv.DeleteFile strFileName

	Set objCreateCsv = Nothing

'	strCommand = "cscript " & Server.MapPath("/webHains/script") & "\ImportPerson.vbs"
'	strCommand = strCommand & " " & strFileName
'	strCommand = strCommand & " " & strOrgCd1
'	strCommand = strCommand & " " & strOrgCd2
'	strCommand = strCommand & " " & strUpdUser
'	strCommand = strCommand & " " & strCtrPtCd
'
'	'��荞�ݏ����N��
'	Set objExec = Server.CreateObject("HainsCooperation.Exec")
'	objExec.Run strCommand
'	strWritePersonCount = "0"

	'����ʂ����_�C���N�g
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?orgCd1="    & strOrgCd1
	strURL = strURL & "&orgCd2="    & strOrgCd2
	strURL = strURL & "&ctrPtCd="   & strCtrPtCd
	strURL = strURL & "&startPos="  & strStartPos
	strURL = strURL & "&readCount=" & strReadCount
	strURL = strURL & "&delCount="  & strDelCount
	Response.Redirect strURL
	Response.End

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim strMessage	'�G���[���b�Z�[�W�̏W��
	Dim i			'�C���f�b�N�X

	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�c�̃R�[�h�̃`�F�b�N
	If strOrgCd1 = "" Or strOrgCd2 = "" Then
		objCommon.appendArray strMessage, "�c�̂��w�肵�ĉ������B"
	End If

	'�_��p�^�[���R�[�h�̃`�F�b�N
	If strCtrPtCd = "" Then
		objCommon.appendArray strMessage, "�_��p�^�[�����w�肵�ĉ������B"
	End If

	'CSV�t�@�C���̃`�F�b�N
	If strCsvFileName = "" Then
		objCommon.appendArray strMessage, "�b�r�u�t�@�C�����w�肵�ĉ������B"
	End If

	'�ǂݍ��݊J�n�ʒu�̃`�F�b�N
	If strStartPos <> "" Then
		For i = 1 To Len(strStartPos)
			If InStr("0123456789", Mid(strStartPos, i, 1)) <= 0 Then
				objCommon.appendArray strMessage, "�ǂݍ��݊J�n�ʒu�͂O�ȏ�̐����Ŏw�肵�ĉ������B"
				Exit For
			End If
		Next
	End If

	'�߂�l�̕ҏW
	If IsArray(strMessage) Then
		CheckValue = strMessage
	End If

	Set objCommon = Nothing

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�b�r�u�t�@�C������̗\��ꊇ�폜</TITLE>
<STYLE TYPE="text/css">
<!--
td.rsvtab  { background-color:#ffffff }
-->
</STYLE>
<!-- #include virtual = "/webHains/includes/orgPostGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// �G�������g�̎Q�Ɛݒ�
function setElement() {

	with ( document.entryForm ) {
		orgPostGuide_getElement( orgCd1, orgCd2, 'orgName' );
		orgPostGuide_getPatternElement( ctrPtCd, 'csName', 'strDate', 'endDate');
	}

}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="javascript:setElement()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ENCTYPE="multipart/form-data" ONSUBMIT="javascript:return confirm('���̓��e�ō폜�������s���܂��B��낵���ł����H')">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">�b�r�u�t�@�C������̗\��ꊇ�폜</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	Do

		'�������w�莞�͒ʏ�̃��b�Z�[�W�ҏW
		If strDelCount = "" then
			EditMessage strMessage, MESSAGETYPE_WARNING
			Exit Do
		End If

		'��f���̍X�V���b�Z�[�W
		If strDelCount = "0" Then
			strMessage = strMessage & "<BR>��f���͍폜����܂���ł����B"
		Else
			strMessage = strMessage & "<BR>" & strDelCount & "���̎�f��񂪍폜����܂����B"
		End If

		EditMessage strMessage & "<BR>�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL

'		EditMessage "�b�r�u�t�@�C������̈ꊇ�\�񏈗����J�n����܂����B�ڍׂ̓V�X�e�����O���Q�Ƃ��ĉ������B", MESSAGETYPE_NORMAL

		Exit Do
	Loop
%>
	<BR>

	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
<%
	'�c�̖��̂̓ǂݍ���
	If strOrgCd1 <> "" And strOrgCd2 <> "" Then

		Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

		If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
			Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
		End If

		Set objOrganization = Nothing

	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="130" NOWRAP>�c��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuideOrg()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̌����K�C�h��\��"></A></TD>
			<TD NOWRAP><SPAN ID="orgName"><%= strOrgName %></SPAN></TD>
		</TR>
	</TABLE>

	<INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strCtrPtCd %>">
<%
	'�_����̓ǂݍ���
	If strOrgCd1 <> "" And strOrgCd2 <> "" And strCtrPtCd <> "" Then

		Set objContract = Server.CreateObject("HainsContract.Contract")

		If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
			Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
		End If

		Set objContract = Nothing

	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="130" NOWRAP>�_��p�^�[��</TD>
			<TD>�F</TD>
			<TD><A HREF="javascript:orgPostGuide_showGuidePattern()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�_��p�^�[�������K�C�h��\��"></A></TD>
<%
			Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
			<TD NOWRAP>
				<SPAN ID="csName"><%= strCsName %></SPAN>&nbsp;
				<SPAN ID="strDate"><%= IIf(Not IsEmpty(dtmStrDate), objCommon.FormatString(dtmStrDate, "yyyy�Nm��d��"), "") %></SPAN><SPAN ID="endDate"><%= IIf(Not IsEmpty(dtmEndDate), objCommon.FormatString(dtmEndDate, "�`yyyy�Nm��d��"), "") %></SPAN>
			</TD>
<%
			Set objCommon = Nothing
%>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD><FONT COLOR="#ff0000">��</FONT></TD>
			<TD WIDTH="130" NOWRAP>�b�r�u�t�@�C��</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="file" NAME="csvFileName" SIZE="50"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD>��</TD>
			<TD WIDTH="130" NOWRAP>�ǂݍ��݊J�n�ʒu</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="startPos" SIZE="3" VALUE="<%= strStartPos %>" STYLE="ime-mode:disabled"></TD>
		</TR>
	</TABLE>

	<BR><BR>

	<A HREF="rsvMenu.asp"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>

    <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	    <INPUT TYPE="image" NAME="reserve" SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���̏����ō폜����">
    <%  end if  %>

	<BR><BR>

	<A HREF="/webHains/contents/maintenance/hainslog/dispHainsLog.asp?mode=print&amp;transactionDiv=LOGRSVDEL"><IMG SRC="/webHains/images/prevlog.gif" WIDTH="77" HEIGHT="24" ALT="���O���Q�Ƃ���"></A>

	</BLOCKQUOTE>
</FORM>
</BODY>
</HTML>