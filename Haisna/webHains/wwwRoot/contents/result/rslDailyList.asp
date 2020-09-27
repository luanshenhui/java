<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ʓ��́i��f�҈ꗗ�j (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"         -->
<!-- #include virtual = "/webHains/includes/common.inc"               -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"         -->
<!-- #include virtual = "/webHains/includes/EditRslDailyList.inc"     -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const ACTMODE_SAVEEND  = "saveend"	'���샂�[�h(�ۑ�����)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objConsult		'��f���A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strActMode		'���샂�[�h
Dim lngCslYear		'��f��(�N)
Dim lngCslMonth		'��f��(��)
Dim lngCslDay		'��f��(��)
Dim strCsCd			'�R�[�X
Dim strSortKey		'�\����
Dim strCntlNo		'�Ǘ��ԍ�
Dim lngStartPos		'�\���J�n�ʒu
Dim strGetCount		'�擾����

'��f���ꗗ�擾���Ɏg�p����ϐ�
Dim dtmCslDate		'��f��
Dim lngCntlNo		'�Ǘ��ԍ�
Dim lngGetCount		'�擾����

'��f���
Dim strArrRsvNo		'�\��ԍ��̔z��
Dim strArrDayId		'����ID�̔z��
Dim strArrWebColor	'web�J���[�̔z��
Dim strArrCsName	'�R�[�X���̔z��
Dim strArrPerId		'�lID�̔z��
Dim strArrLastName	'���̔z��
Dim strArrFirstName	'���̔z��
Dim lngCount		'���R�[�h����

Dim strArrSortKey		'�\����
Dim strArrSortKeyName	'�\��������

Dim strPageMaxLine		'�\���s��
Dim strPageMaxLineName	'�\���s������

Dim lngCntlNoFlg	'�Ǘ��ԍ�����t���O
Dim strURL			'URL������
Dim i				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")
Set objCommon  = Server.CreateObject("HainsCommon.Common")

'�����l�̎擾
strActMode  = Request("actMode")
lngCslYear  = CLng("0" & Request("cslYear") )
lngCslMonth = CLng("0" & Request("cslMonth"))
lngCslDay   = CLng("0" & Request("cslDay")  )
strCsCd     = Request("csCd")
strSortKey  = Request("sortKey")
strCntlNo   = Request("cntlNo")
lngStartPos = CLng("0" & Request("startPos"))
strGetCount = Request("getCount")

'�����J�n�ʒu���w�莞�͐擪���猟������
lngStartPos = IIf(lngStartPos = 0, 1, lngStartPos)

'�擾�������w�莞�̓f�t�H���g�l���擾
strGetCount = IIf(strGetCount = "", objCommon.SelectRslPageMaxLine, strGetCount)

'�Ǘ��ԍ��̐�����@���擾
lngCntlNoFlg = CLng("0" & objCommon.SelectCntlFlg)
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>���ʓ��́i��f�҈ꗗ�j</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/Date.inc"     -->
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

// ���ʏڍו\��
function showDetail(rsvNo, dayId) {

	var code = '';	// �����O���[�v�R�[�h
	var url;		// URL������

	// ���ɏڍׂ��\������Ă���ꍇ�́A�������ڃO���[�v���擾
	if ( top.result.location.pathname == '/webHains/contents/result/rslDetail.asp' ) {
		if ( top.result.resultList != null ) {
			code = top.result.resultList.code.value;
		}
	}

	// URL������̕ҏW
	url = 'rslDetail.asp';
	url = url + '?rsvNo='    + rsvNo;
	url = url + '&cslYear='  + '<%= lngCslYear  %>';
	url = url + '&cslMonth=' + '<%= lngCslMonth %>';
	url = url + '&cslDay='   + '<%= lngCslDay   %>';
	url = url + '&cntlNo='   + '<%= strCntlNo   %>';
	url = url + '&csCd='     + '<%= strCsCd     %>';
	url = url + '&sortKey='  + '<%= strSortKey  %>';
	url = url + '&dayId='    + dayId;
	url = url + '&code='     + code;

	// ���ʏڍו\��
	top.result.location.replace(url);
	return false;
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 5px; }
	td.rsltab { background-color:#FFFFFF }
</style>
</HEAD>
<%
'�ۑ��������ȊO�͌��ʓ��̓t���[���������I�ɋ󔒂ɂ���
If strActMode = ACTMODE_SAVEEND Then
%>
	<BODY>
<%
Else
%>
	<BODY ONLOAD="javascript:top.result.location.replace('/webHains/contents/common/Blank.htm')">
<%
End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONSUBMIT="javascript:return checkData()">
<!-- �\�� -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="255"><!-- or WIDTH="90%" -->
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">��f�҈ꗗ</FONT></B></TD>
	</TR>
</TABLE>

<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('cslYear', 'cslMonth', 'cslDay')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, lngCslYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("cslMonth", 1, 12, lngCslMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditNumberList("cslDay", 1, 31, lngCslDay, False) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�R�[�X</TD>
			<TD>�F</TD>
			<TD><%= Tokyu_EditCourseList(EDITCOURSELIST_MODE_MAIN, "csCd", strCsCd, SELECTED_ALL, False) %></TD>
		</TR>
		<TR>
			<TD HEIGHT="4"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�\����</TD>
			<TD>�F</TD>
			<TD><%= EditSortKeyList("sortKey", strSortKey) %></TD>
		</TR>
<%
		'�Ǘ��ԍ����g�p����ꍇ�͓��̓e�L�X�g��\��
		If lngCntlNoFlg = CNTLNO_ENABLED Then
%>
			<TR>
				<TD HEIGHT="4"></TD>
			</TR>
			<TR>
				<TD NOWRAP>�Ǘ��ԍ�</TD>
				<TD>�F</TD>
				<TD><INPUT TYPE="text" NAME="cntlNo" SIZE="<%= TextLength(4) %>" MAXLENGTH="4" VALUE="<%= strCntlNo %>"></TD>
			</TR>
<%
		End If
%>
		<TR>
			<TD NOWRAP>����</TD>
			<TD>�F</TD>
			<TD>
<%
				If lngCntlNoFlg <> CNTLNO_ENABLED Then
%>
					<INPUT TYPE="hidden" NAME="cntlNo" VALUE="">
<%
				End If
%>
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD>
<%
							'�\���s�����̓ǂݍ���
							If objCommon.SelectRslPageMaxLineList(strPageMaxLine, strPageMaxLineName) > 0 Then
								Response.Write EditDropDownListFromArray("getCount", strPageMaxLine, strPageMaxLineName, strGetCount, NON_SELECTED_DEL)
							End If
%>
						</TD>
						<TD><INPUT TYPE="image" SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��"></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR>

	<SPAN style="font-size:9pt;">�u<FONT color="#FF6600"><B><%= lngCslYear %>�N<%= lngCslMonth %>��<%= lngCslDay %>��</B></FONT>�v<BR>�̗��@�ςݎ�f�҈ꗗ��\�����Ă��܂��B<BR></SPAN>
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

		'���������𖞂�����f�����擾
'## 2004.01.09 Mod By T.Takagi@FSIT ���@�֘A�ǉ�
'		lngCount = objConsult.SelectConsultList(dtmCslDate,     _
'												lngCntlNo,      _
'												strCsCd, , , ,  _
'												lngStartPos,    _
'												lngGetCount,    _
'												strSortKey,     _
'												True, , , ,     _
'												strArrRsvNo,    _
'												strArrDayId,    _
'												strArrWebColor, _
'												strArrCsName,   _
'												strArrPerId,    _
'												strArrLastName, _
'												strArrFirstName)
		'���@�҂̂ݎ擾
		lngCount = objConsult.SelectConsultList(dtmCslDate,     _
												lngCntlNo,      _
												strCsCd, , , ,  _
												lngStartPos,    _
												lngGetCount,    _
												strSortKey,     _
												True, , , ,     _
												strArrRsvNo,    _
												strArrDayId,    _
												strArrWebColor, _
												strArrCsName,   _
												strArrPerId,    _
												strArrLastName, _
												strArrFirstName, , , , , , , , , , , , , , , , , _
												True)
'## 2004.01.09 Mod End
%>
		�ΏێҐ��� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>�l�ł��B<BR><BR>
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
				<TD NOWRAP>�l����</TD>
				<TD NOWRAP>�l�h�c</TD>
			</TR>
<%
			For i = 0 To UBound(strArrRsvNo)
%>
				<TR BGCOLOR="#ffffff">
					<TD><%= IIf(strArrDayId(i) <> "", objCommon.FormatString(strArrDayId(i), "0000"), "&nbsp;") %></TD>
					<TD NOWRAP><FONT COLOR="<%= strArrWebColor(i) %>">��</FONT><%= strArrCsName(i) %></TD>
					<TD NOWRAP><A HREF="javascript:function voi(){};voi()" ONCLICK="javascript:showDetail('<%= strArrRsvNo(i) %>', '<%= strArrDayId(i) %>')"><%= strArrLastName(i) & "�@" & strArrFirstName(i) %></A></TD>
					<TD><%= strArrPerId(i) %></TD>
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
		strURL = strURL & "?cslYear="  & lngCslYear
		strURL = strURL & "&cslMonth=" & lngCslMonth
		strURL = strURL & "&cslDay="   & lngCslDay
		strURL = strURL & "&csCd="     & strCsCd
		strURL = strURL & "&sortKey="  & strSortKey
		strURL = strURL & "&cntlNo="   & strCntlNo

		'�y�[�W���O�i�r�Q�[�^�̕ҏW
		Response.Write EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount)

		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>