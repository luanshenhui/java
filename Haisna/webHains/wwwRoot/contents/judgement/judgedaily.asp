<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�������(��f�҈ꗗ) (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"   -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<!-- #include virtual = "/webHains/includes/EditRslDailyList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim lngCslYear			'��f��(�N)
Dim lngCslMonth			'��f��(��)
Dim lngCslDay			'��f��(��)
Dim strCsCd				'�R�[�X�R�[�h
Dim strSortKey			'�\����
Dim strCntlNo			'�Ǘ��ԍ�
Dim strBadJud			'�u���肪�����l�v
Dim strUnFinished		'�u���薢�����ҁv
Dim lngStartPos			'�\���J�n�ʒu
Dim strGetCount			'�擾����

'��f���ꗗ�擾���Ɏg�p����ϐ�
Dim dtmCslDate			'��f��
Dim lngCntlNo			'�Ǘ��ԍ�
Dim lngGetCount			'�擾����

'��f���
Dim strArrRsvNo			'�\��ԍ��̔z��
Dim strArrDayId			'����ID�̔z��
Dim strArrWebColor		'web�J���[�̔z��
Dim strArrCsName		'�R�[�X���̔z��
Dim strArrPerId			'�lID�̔z��
Dim strArrLastName		'���̔z��
Dim strArrFirstName		'���̔z��
Dim strArrLastKName		'�J�i���̔z��
Dim strArrFirstKName	'�J�i���̔z��
Dim strArrGender		'���ʂ̔z��
Dim strArrBirth			'���N�����̔z��
Dim strArrAge			'�N��̔z��
Dim strArrOrgSName		'�c�̗��̂̔z��
Dim strArrCsSName		'�R�[�X���̂̔z��
Dim strArrFilmNo		'�t�B�����ԍ��̔z��
Dim strArrFilmDate		'�B�e���̔z��
Dim lngCount			'���R�[�h����

Dim lngCntlNoFlg		'�Ǘ��ԍ�����t���O
Dim strURL				'URL������
Dim i					'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objConsult = Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
lngCslYear    = CLng("0" & Request("cslYear") )
lngCslMonth   = CLng("0" & Request("cslMonth"))
lngCslDay     = CLng("0" & Request("cslDay")  )
strCsCd       = Request("csCd")
strSortKey    = Request("sortKey")
strCntlNo     = Request("cntlNo")
strBadJud     = Request("badJud")
strUnFinished = Request("unfinished")
lngStartPos   = CLng("0" & Request("startPos"))
strGetCount   = Request("getCount")

'�����J�n�ʒu���w�莞�͐擪���猟������
lngStartPos = IIf(lngStartPos = 0, 1, lngStartPos)

'�擾�������w�莞�̓f�t�H���g�l���擾
strGetCount = IIf(strGetCount = "", EditRslPageMaxLine(), strGetCount)

'�Ǘ��ԍ��̐�����@���擾
lngCntlNoFlg = CLng("0" & objCommon.SelectCntlFlg)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>������́i��f�҈ꗗ�j</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
// ���̓`�F�b�N
function checkData() {

	var myForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var ret    = false;					// �֐��߂�l

	// ��f�����̓`�F�b�N
	for ( ; ; ) {

		if ( !isDate( myForm.cslYear.value, myForm.cslMonth.value, myForm.cslDay.value ) ) {
			alert('��f���̌`���Ɍ�肪����܂��B');
			break;
		}

		// �Ǘ��ԍ����̓`�F�b�N
		if ( myForm.cntlNo.value != '' ) {
			if ( !myForm.cntlNo.value.match('^[0-9]+$') ) {
				alert('�Ǘ��ԍ��ɂ�1�`9999�̒l����͂��ĉ������B');
				break;
			}
		}

		ret = true;
		break;
	}

	return ret;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.judtab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return checkData()">
<BLOCKQUOTE>

<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="judgement">��</SPAN><FONT COLOR="#000000">��f�҈ꗗ</FONT></B></TD>
	</TR>
</TABLE>

<BR>

<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
	<TR>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD>��f���F</TD>
					<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
					<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
					<TD>�N</TD>
					<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
					<TD>��</TD>
					<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
					<TD>��</TD>
					<TD>&nbsp;�R�[�X�F</TD>
					<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
<%
					'�Ǘ��ԍ����g�p����ꍇ�͓��̓e�L�X�g��\��
					If lngCntlNoFlg = CNTLNO_ENABLED Then
%>
						<TD>�Ǘ��ԍ��F</TD>
						<TD><INPUT TYPE="text" NAME="cntlNo" SIZE="<%= TextLength(4) %>" MAXLENGTH="4" VALUE="<%= strCntlNo %>"></TD>
<%
					Else
%>
						<INPUT TYPE="hidden" NAME="cntlNo" VALUE="">
<%
					End If
%>
					<TD>�\�����F</TD>
					<TD><%= EditSortKeyList("sortKey", strSortKey) %></TD>
					<TD><%= EditRslPageMaxLineList("getCount", strGetCount) %></TD>
					<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��"></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD HEIGHT="5"></TD>
	</TR>
	<TR>
		<TD>
			<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
				<TR>
					<TD><INPUT TYPE="checkbox" NAME="badJud" VALUE="1" <%= IIf(strBadJud <> "","CHECKED", "") %>></TD>
					<TD>���肪�����l�̂�</TD>
					<TD WIDTH="10"></TD>
					<TD><INPUT TYPE="checkbox" NAME="unFinished" VALUE="1" <%= IIf(strUnFinished <> "", "CHECKED", "") %>></TD>
					<TD>���薢�����҂̂�</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
</TABLE>
<%
	'��f�҈ꗗ�ҏW
	Do

		'��f���E�Ǘ��ԍ��̐ݒ�
		dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)
		lngCntlNo  = CLng("0" & strCntlNo)

		'�擾�����̐ݒ�
		lngGetCount = 0
		If IsNumeric(strGetCount) Then
			lngGetCount = CLng(strGetCount)
		End If

		'���������𖞂������R�[�h�y�у��R�[�h�������擾
		lngCount = objConsult.SelectConsultList(dtmCslDate,              _
												lngCntlNo,               _
												strCsCd, , , ,           _
												lngStartPos,             _
												lngGetCount,             _
												strSortKey, ,            _
												(strBadJud     <> ""),   _
												(strUnFinished <> ""), , _
												strArrRsvNo,             _
												strArrDayId,             _
												strArrWebColor,          _
												strArrCsName,            _
												strArrPerId,             _
												strArrLastName,          _
												strArrFirstName,         _
												strArrLastKName,         _
												strArrFirstKName,        _
												strArrGender,            _
												strArrBirth, ,           _
												strArrAge,               _
												strArrOrgSName, ,        _
												strArrCsSName,           _
												strArrFilmNo,            _
												strArrFilmDate)
%>
		�u<FONT COLOR="#ff6600"><B><%= lngCslYear %>�N<%= lngCslMonth %>��<%= lngCslDay %>��</B></FONT>�v�̎�f�҈ꗗ��\�����Ă��܂��B<BR>
		�ΏێҐ��� <FONT COLOR="#FF6600"><B><%= lngCount %></B></FONT>�l�ł��B<BR><BR>
<%
		'�Ώۃf�[�^�����݂��Ȃ��ꍇ�͕ҏW�𔲂���
		If IsEmpty(strArrRsvNo) Then
			Exit Do
		End If
%>
<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
	<TR BGCOLOR="#cccccc">
		<TD NOWRAP>�����h�c</TD>
		<TD NOWRAP>��f�R�[�X</TD>
		<TD NOWRAP>�\��ԍ�</TD>
		<TD NOWRAP>�l�h�c</TD>
		<TD NOWRAP>�l����</TD>
		<TD NOWRAP>����</TD>
		<TD NOWRAP>���N����</TD>
		<TD NOWRAP>�N��</TD>
		<TD NOWRAP>��f�c��</TD>
<%
		If Left(strSortKey, 4) = "FILM" Then
%>
			<TD NOWRAP>�t�B�����ԍ�</TD>
			<TD NOWRAP>�B�e��</TD>
<%
		End If
%>
	</TR>
<%
		For i = 0 To UBound(strArrRsvNo)
%>
			<TR BGCOLOR="#<%= IIf(i Mod 2 = 0, "ffffff", "eeeeee") %>">
				<TD NOWRAP><%= objCommon.FormatString(strArrDayId(i), "0000") %></TD>
				<TD NOWRAP><FONT COLOR="#<%= strArrWebColor(i) %>">��</FONT><%= strArrCsSName(i) %></TD>
				<TD><%= strArrRsvNo(i) %></TD>
				<TD><%= strArrPerId(i) %></TD>
<%
				'������͉�ʂ�URL�ҏW
				strURL = "judMain.asp"
				strURL = strURL & "?cslYear="    & lngCslYear
				strURL = strURL & "&cslMonth="   & lngCslMonth
				strURL = strURL & "&cslDay="     & lngCslDay
				strURL = strURL & "&cntlNo="     & strCntlNo
				strURL = strURL & "&dayId="      & strArrDayId(i)
				strURL = strURL & "&csCd="       & strCsCd
				strURL = strURL & "&sortKey="    & strSortKey
				strURL = strURL & "&badJud="     & strBadJud
				strURL = strURL & "&unFinished=" & strUnFinished
%>
				<TD NOWRAP><A HREF="<%= strURL %>"><%= Trim(strArrLastName(i) & "�@" & strArrFirstName(i)) %><FONT SIZE="-1" COLOR="#666666">�i<%= Trim(strArrLastKName(i) & "�@" & strArrFirstKName(i)) %>�j</FONT></A></TD>
				<TD NOWRAP><%= IIf(strArrGender(i) ="1", "�j��", "����") %></TD>
				<TD NOWRAP><%= objCommon.FormatString(strArrBirth(i), "gee.mm.dd") %></TD>
				<TD ALIGN="right" NOWRAP><%= strArrAge(i) %>��</TD>
				<TD NOWRAP><%= strArrOrgSName(i) %></TD>
<%
				If Left(strSortKey, 4) = "FILM" Then
%>
					<TD NOWRAP><%= strArrFilmNo(i)   %></TD>
					<TD NOWRAP><%= strArrFilmDate(i) %></TD>
<%
				End If
%>
			</TR>
<%
		Next
%>
	</TABLE>
<%
	'�擾�������w�莞�̓y�[�W���O�i�r�Q�[�^�s�p
	If lngGetCount = 0 Then
		Exit Do
	End If

	'URL������̕ҏW
	strURL = Request.ServerVariables("SCRIPT_NAME")
	strURL = strURL & "?cslYear="    & lngCslYear
	strURL = strURL & "&cslMonth="   & lngCslMonth
	strURL = strURL & "&cslDay="     & lngCslDay
	strURL = strURL & "&csCd="       & strCsCd
	strURL = strURL & "&sortKey="    & strSortKey
	strURL = strURL & "&cntlNo="     & strCntlNo
	strURL = strURL & "&badJud="     & strBadJud
	strURL = strURL & "&unfinished=" & strUnFinished

	'�y�[�W���O�i�r�Q�[�^�̕ҏW
	Response.Write EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount)

	Exit Do
Loop
%>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>