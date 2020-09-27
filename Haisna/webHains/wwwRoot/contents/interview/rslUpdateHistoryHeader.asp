<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �ύX�����i�w�b�_�j (Ver0.0.1)
'	   AUTHER  : K.Fujii@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objHainsUser		'���[�U���A�N�Z�X�p
Dim objInterView		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strAct				'�������
Dim lngRsvNo			'�\��ԍ�
Dim strFromDate			'�X�V���i�J�n�j
Dim strFromYear			'�X�V���@�N�i�J�n�j
Dim strFromMonth		'�X�V���@���i�J�n�j
Dim strFromDay			'�X�V���@���i�J�n�j
Dim strToDate			'�X�V���i�J�n�j
Dim strToYear			'�X�V���@�N�i�J�n�j
Dim strToMonth			'�X�V���@���i�J�n�j
Dim strToDay			'�X�V���@���i�J�n�j
Dim lngStartPos			'�\���J�n�ʒu

Dim strClass			'����
Dim strArrClass()		'���ރR�[�h�̔z��
Dim strArrClassName()	'���ޖ��̂̔z��

Dim strUpdUser				'�X�V���[�U
Dim strUpdUsername			'�X�V���[�U��

Dim strOrderByItem			'���בւ�����
Dim strArrOrderByItem() 	'���בւ����ڂ̔z��
Dim strArrOrderByItemName()	'���בւ����ږ��̔z��

Dim strOrderBy				'���בւ��i0:����1:�~���j
Dim strArrOrderBy()			'���בւ��̔z��
Dim strArrOrderByName()		'���בւ����̔z��

Dim lngPageMaxLine			'�P�y�[�W�\���l�`�w�s
Dim lngArrPageMaxLine()		'�P�y�[�W�\���l�`�w�s�̔z��
Dim strArrPageMaxLineName()	'�P�y�[�W�\���l�`�w�s���̔z��


Dim lngCount				'�l�`�w����

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strAct              = Request("action")
strWinMode			= Request("winmode")
lngRsvNo            = Request("rssvno")
strFromYear         = Request("fromyear")
strFromMonth        = Request("frommonth")
strFromDay          = Request("fromday")
strToYear           = Request("toyear")
strToMonth          = Request("tomonth")
strToDay            = Request("today")
strUpdUser          = Request("upduser")
strClass            = Request("updclass")
strOrderByItem      = Request("orderbyItem")
strOrderBy          = Request("orderbyMode")
lngStartPos         = Request("startPos")
lngPageMaxLine      = Request("pageMaxLine")

'���t���w��̏ꍇ�A�V�X�e���N������K�p����
If strFromYear = "" Then
	strFromYear  = CStr(Year(Now))
	strFromMonth = CStr(Month(Now))
	strFromDay   = CStr(Day(Now))
End If
If strToYear = "" Then
	strToYear  = CStr(Year(Now))
	strToMonth = CStr(Month(Now))
	strToDay   = CStr(Day(Now))
End If

'���ޖ��w�莞�͂��ׂ�
If strClass = "" Then
	strClass = 0
End If

'���בւ����ږ��w�莞�͍X�V��
If strOrderByItem = "" Then
	strOrderByItem = "0"
End If

'���בւ����@���w�莞�͏���
If strOrderBy = "" Then
	strOrderBy = "0" 
End If

If strUpdUser <> "" Then
	objHainsUser.SelectHainsUser strUpdUser, strUpdUserName
End If


lngCount = CLng(IIf( lngCount="", 0, lngCount))


Call CreateClassInfo()

Call CreateOrderByItemInfo()

Call CreateOrderByInfo()

Call CreatePageMaxLineInfo()


Do	

Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ޖ��̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateClassInfo()


	Redim Preserve strArrClass(4)
	Redim Preserve strArrClassName(4)

	strArrClass(0) = "0":strArrClassName(0) = "���ׂ�"
	strArrClass(1) = "1":strArrClassName(1) = "���f����"
	strArrClass(2) = "2":strArrClassName(2) = "����"
	strArrClass(3) = "3":strArrClassName(3) = "�R�����g"
	strArrClass(4) = "4":strArrClassName(4) = "�l��������"

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ёւ����ږ��̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateOrderByItemInfo()


	Redim Preserve strArrOrderByItem(2)
	Redim Preserve strArrOrderByItemName(2)

	strArrOrderByItem(0) = "0":strArrOrderByItemName(0) = "�X�V��"
	strArrOrderByItem(1) = "1":strArrOrderByItemName(1) = "�X�V��"
	strArrOrderByItem(2) = "2":strArrOrderByItemName(2) = "���ށA����"

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���ёւ����̂̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreateOrderByInfo()


	Redim Preserve strArrOrderBy(1)
	Redim Preserve strArrOrderByName(1)

	strArrOrderBy(0) = "0":strArrOrderByName(0) = "����"
	strArrOrderBy(1) = "1":strArrOrderByName(1) = "�~��"

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �P�y�[�W�\���l�`�w�s�̔z��쐬
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub CreatePageMaxLineInfo()


	Redim Preserve lngArrPageMaxLine(4)
	Redim Preserve strArrPageMaxLineName(4)

	lngArrPageMaxLine(0) = 50:strArrPageMaxLineName(0) = "50�s����"
	lngArrPageMaxLine(1) = 100:strArrPageMaxLineName(1) = "100�s����"
	lngArrPageMaxLine(2) = 200:strArrPageMaxLineName(2) = "200�s����"
	lngArrPageMaxLine(3) = 300:strArrPageMaxLineName(3) = "300�s����"
	lngArrPageMaxLine(4) = 0:strArrPageMaxLineName(4) = "���ׂ�"
'	lngArrPageMaxLine(0) = 2:strArrPageMaxLineName(0) = "2�s����"
'	lngArrPageMaxLine(1) = 3:strArrPageMaxLineName(1) = "3�s����"
'	lngArrPageMaxLine(2) = 5:strArrPageMaxLineName(2) = "5�s����"
'	lngArrPageMaxLine(3) = 10:strArrPageMaxLineName(3) = "10�s����"
'	lngArrPageMaxLine(4) = 0:strArrPageMaxLineName(4) = "���ׂ�"

End Sub

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<TITLE>�ύX����</TITLE>
<SCRIPT TYPE="text/JavaScript">
<!--
<!-- #include virtual = "/webHains/includes/usrGuide2.inc" -->
// usrGuid.inc�@����Ăяo�����gdeDoctor.asp�@���g���Ȃ��̂ŕύX 2004.01.13
// -- #include virtual = "/webHains/includes/usrGuide.inc" --
//�\��
function callUpdateHistoryTop() {

	var myForm;


	myForm = document.entryForm;


	// Top�Ɉ������w�肵��submit
	parent.params.fromDate    = myForm.fromyear.value + '/' + myForm.frommonth.value + '/' + myForm.fromday.value;
	parent.params.fromyear    = myForm.fromyear.value;
	parent.params.frommonth   = myForm.frommonth.value;
	parent.params.fromday     = myForm.fromday.value;
	parent.params.toDate      = myForm.toyear.value + '/' + myForm.tomonth.value + '/' + myForm.today.value;
	parent.params.toyear      = myForm.toyear.value;
	parent.params.tomonth     = myForm.tomonth.value;
	parent.params.today       = myForm.today.value;
	parent.params.upduser     = myForm.upduser.value;
	parent.params.updclass    = myForm.updclass.value;
	parent.params.orderbyItem = myForm.orderbyItem.value;
	parent.params.orderbyMode = myForm.orderbyMode.value;
	parent.params.startPos    = myForm.startPos.value;
	parent.params.pageMaxLine = myForm.pageMaxLine.value;
	parent.params.action      = "search";
    common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);

}

// ���[�U�[�K�C�h�Ăяo��
function callGuideUsr() {

	usrGuide_CalledFunction = SetUpdUser;

	// ���[�U�[�K�C�h�\��
	showGuideUsr( );

}

// ���[�U�[�Z�b�g
function SetUpdUser() {

	document.entryForm.upduser.value = usrGuide_UserCd;
	document.entryForm.updusername.value = usrGuide_UserName;

	document.getElementById('username').innerHTML = usrGuide_UserName;

}

// ���[�U�[�w��N���A
function clearUpdUser() {

	document.entryForm.upduser.value = '';
	document.entryForm.updusername.value = '';

	document.getElementById('username').innerHTML = '';

}


var winGuideCalendar;			// �E�B���h�E�n���h��
// ���t�K�C�h�Ăяo��
function callCalGuide(year, month, day) {


	// ���t�K�C�h�\��
	calGuide_showGuideCalendar( year, month, day);

}

function windowClose() {

	// ���t�K�C�h�E�C���h�E�����
	calGuide_closeGuideCalendar();

	// ���[�U�[�K�C�h�E�C���h�E�����
	closeGuideDoc();
	winGuideUsr = null;
}

//-->
</SCRIPT>
<script type="text/javascript" src="/webHains/js/common.js"></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<%
	'�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
	If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="action" VALUE="<%= strAct %>">
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="fromDate" VALUE="<%= strFromDate %>">
	<INPUT TYPE="hidden" NAME="toDate" VALUE="<%= strToDate %>">
	<INPUT TYPE="hidden" NAME="startPos" VALUE="<%= lngStartPos %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="900">
		<TR>
			<TD WIDTH="100%">
				<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
					<TR>
						<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�ύX����</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
		<TR>
			<TD HEIGHT="5"></TD>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�X�V��</TD>
			<TD NOWRAP>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
					<TR>
						<TD><A HREF="javascript:callCalGuide('fromyear', 'frommonth', 'fromday')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��" border="0"></A></TD>
						<TD><%= EditSelectNumberList("fromyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strFromYear)) %></TD>
						<TD>�N</TD>
						<TD><%= EditSelectNumberList("frommonth", 1, 12, CLng("0" & strFromMonth)) %></TD>
						<TD>��</TD>
						<TD><%= EditSelectNumberList("fromday",   1, 31, CLng("0" & strFromDay  )) %></TD>
						<TD>���`</TD>
						<TD><A HREF="javascript:callCalGuide('toyear', 'tomonth', 'today')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��" border="0"></A></TD>
						<TD><%= EditSelectNumberList("toyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strToYear)) %></TD>
						<TD>�N</TD>
						<TD><%= EditSelectNumberList("tomonth", 1, 12, CLng("0" & strToMonth)) %></TD>
						<TD>��</TD>
						<TD><%= EditSelectNumberList("today",   1, 31, CLng("0" & strToDay  )) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD NOWRAP>�@����</TD>
			<TD NOWRAP>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
					<INPUT TYPE="hidden" NAME="upduser" VALUE="<%= strUpdUser %>">
					<INPUT TYPE="hidden" NAME="updusername" VALUE="<%= strUpdUserName %>">
					<TR>
						<TD><%= EditDropDownListFromArray("updclass", strArrClass, strArrClassName, strClass, NON_SELECTED_DEL) %></TD>
						<TD NOWRAP><INPUT TYPE="image" SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="15"></TD>
						<TD NOWRAP>�X�V���[�U�F</TD>
						<TD NOWRAP><A HREF="javascript:callGuideUsr()"><IMG SRC="/webHains/images/question.gif" ALT="���[�U�K�C�h��\��" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
						<TD NOWRAP><A HREF="javascript:clearUpdUser()"><IMG SRC="/webHains/images/delicon.gif" ALT="���[�U�w��폜" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
						<TD NOWRAP><SPAN ID="username"><%= strUpdUserName %></SPAN></TD>
						<TD NOWRAP>�@�\���F</TD>
						<TD><%= EditDropDownListFromArray("orderbyItem", strArrOrderByItem, strArrOrderByItemName, strOrderByItem, NON_SELECTED_DEL) %></TD>
						<TD>��</TD>
						<TD><%= EditDropDownListFromArray("orderbyMode", strArrOrderBy, strArrOrderByName, strOrderBy, NON_SELECTED_DEL) %></TD>
						<TD>��</TD>
						<TD><%= EditDropDownListFromArray("pageMaxLine", lngArrPageMaxLine, strArrPageMaxLineName, lngPageMaxLine, NON_SELECTED_DEL) %></TD>
						<TD><A HREF="JavaScript:callUpdateHistoryTop()"><IMG SRC="/webHains/images/b_prev.gif" ALT="�\��" HEIGHT="28" WIDTH="53"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
</FORM>
</BODY>
</HTML>
