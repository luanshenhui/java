<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�������ߏ��� (Ver0.0.1)
'		AUTHER  : Miyuki Gouda@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->

<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�����l
Dim strAction				'������ԁi�m��{�^��������:"submit"�C���ߏ����N��������:"submitend"�j
Dim lngCloseYear			'���ߓ�(�N)
Dim lngCloseMonth			'���ߓ�(��)
Dim lngCloseDay				'���ߓ�(��)
Dim strLoginId				'���O�C��ID

'COM�I�u�W�F�N�g
Dim objHainsUser			'���[�U�A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objFree					'���ߓ��pCOM�I�u�W�F�N�g

'�w�����
Const strKey = "DAILYCLS"	'�ėp�e�[�u���̃L�[
Dim strCloseDate			'���ߓ�
Dim strUserId				'���[�UID
Dim strUserName				'�X�V�Җ�
Dim strUpdate				'�X�V����

'���̓`�F�b�N
Dim strArrMessage			'�G���[���b�Z�[�W
Dim lngRet					'�X�V�̖߂�l
Dim intRet					'���R�[�h�̌���

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strAction     = Request("action") & ""
lngCloseYear  = CLng("0" & Request("closeYear"))
lngCloseMonth = CLng("0" & Request("closeMonth"))
lngCloseDay   = CLng("0" & Request("closeDay"))
strLoginId    = Session.Contents("userId")

'���ߓ��pCOM�I�u�W�F�N�g�̊��蓖��
Set objFree = Server.CreateObject("HainsFree.Free") 

'�����ݒ�
strArrMessage = Empty

Do

	'���ߓ����R�[�h�̗L��
	intRet = objFree.GdeSelectFreeCount(strKey)
	
	'���R�[�h�����݂��Ȃ��ꍇ�͏����𔲂���
	If intRet <= 0 Then
		strArrMessage = "���ߓ����i�[���郌�R�[�h�����݂��܂���B�}�X�^�����e�i���X��ʂ��uKEY = DAILYCLS�v�̃��R�[�h���쐬���ĉ������B"
		Exit Do
	End If

	'�m��{�^��������
	If strAction = "submit" Then

		'�������ߓ��̕ҏW
		strCloseDate = lngCloseYear & "/" & lngCloseMonth & "/" & lngCloseDay
	
		'���͓��t�̃`�F�b�N
		If Not IsDate(strCloseDate) Then
			strArrMessage = "���ߓ��̓��͌`��������������܂���B"
		Else

			'���ߓ��E�X�V�ҁE�X�V�����̍X�V
			lngRet = objFree.UpdateFree(strKey, , , strCloseDate, strLoginId, Now)

			'�X�V�̐���E�ُ�`�F�b�N
			If lngRet <> 0 Then
				strAction = "submitend"
			Else 
				strArrMessage = Array("�������ߏ����Ɏ��s���܂����B")
			End If

		End If
	
	End If

	'DB�ɕۑ�����Ă���������ߓ��A�X�V��ID�A�X�V�������擾
	objFree.SelectFree 0, strKey, , , strCloseDate, strUserId, strUpdate

	'�������ߓ��̐ݒ�
	'�����Ȃ��̏ꍇ
	If Trim(lngCloseYear) = 0 Then
	
		'�擾�����������ߓ������t�Ƃ��Ĕ��f�ł����ꍇ(NULL�ł͂Ȃ��ꍇ) 
		If IsDate(strCloseDate) = True Then 

			'���ߓ��̐ݒ�
			lngCloseYear  = CStr(Year(strCloseDate))
			lngCloseMonth = CStr(Month(strCloseDate))
			lngCloseDay   = CStr(Day(strCloseDate))

		'���ߓ��̃��R�[�h�͑��݂��邪�A���ߓ���NULL�̏ꍇ
		Else 

			'�V�X�e������ݒ�
			lngCloseYear  = Year(Now())
			lngCloseMonth = Month(Now())
			lngCloseDay   = Day(Now())

		End If
	
	End If
	
	'���[�U���ǂݍ���
	If Trim(strUserId) <> "" Then
		Set objHainsUser = Server.CreateObject("HainsHainsUser.HainsUser")
		objHainsUser.SelectHainsUser strUserId, strUserName
		Set objHainsUser = Nothing
	End If

	Exit Do

Loop

'���ߓ��pCOM�I�u�W�F�N�g�̉��
Set objFree = Nothing
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

// �m��{�^���������̏���
function goFinish() {

	var msg;

	msg = '';
	msg = msg + document.perentryCondition.closeYear.value + '�N';
	msg = msg + document.perentryCondition.closeMonth.value + '��';
	msg = msg + document.perentryCondition.closeDay.value + '��';
	msg = msg + '�̓������ߏ��������s���܂��B';
	
	if ( confirm(msg) ) {
		document.perentryCondition.action.value = 'submit';
		document.perentryCondition.submit();
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
<FORM NAME="perentryCondition" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="action" VALUE="">
<BLOCKQUOTE>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="demand">��</SPAN><FONT COLOR="#000000">�����������ߏ���</FONT></B></TD>
	</TR>
</TABLE>
<%
'���b�Z�[�W�̕ҏW
If strAction <> "" Then

	'�X�V�������́u�X�V�����v�̒ʒm
	If strAction = "submitend" Then
		
		strArrMessage = "<FONT COLOR=""#ff6600""><B>�������ߏ������������܂����B</B></FONT>"
		Call EditMessage(strArrMessage, MESSAGETYPE_NORMAL)

	'�G���[���b�Z�[�W��ҏW
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
		<TD>�X�V��</TD>
		<TD>�F</TD>
		<TD><%= strUserName %></TD>
		</TD>
	</TR>
	<TR>
		<TD>�X�V����</TD>
		<TD>�F</TD>
		<TD><%= strUpdate %></TD>
		</TD>
	</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0" WIDTH="500">
<TR>
	<% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
        <TD ALIGN="RIGHT"><A HREF="javascript:function voi(){};voi()" ONCLICK="return goFinish()" METHOD="post"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="���������ߊm��"></A></TD>
    <% End If %>
</TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
