<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ��f�҂̌���  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
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
Dim objConsult			'��f�N���X

'�p�����[�^
Dim strCslDate			'��f��
Dim strPerId			'�lID
Dim lngLineNo			'�I���ʒu
Dim strKey				'�����L�[

Dim dtmStrDate			'��f��(��)
Dim dtmEndDate			'��f��(��)
Dim lngArrPrtField		'�o�͍��ڂ̔z��
Dim lngSortKey			'�\�[�g�L�[

'��f���
Dim strArrRsvNo			'�\��ԍ��̔z��
Dim strArrCancelFlg		'�L�����Z���t���O�̔z��
Dim strArrCslDate		'��f���̔z��
Dim strArrPerId			'�lID�̔z��
Dim strArrOrgSName		'�c�̗��̂̔z��
Dim strArrRsvDate		'�\����̔z��
Dim strArrAge			'�N��̔z��
Dim strArrDayId			'����ID�̔z��
Dim strArrWebColor		'�R�[�X���\���F�̔z��
Dim strArrCsName		'�R�[�X���̔z��
Dim strArrName			'�����̔z��
Dim strArrKanaName		'�J�i�����̔z��
Dim strArrBirth			'���N�����̔z��
Dim strArrGender		'���ʂ̔z��
Dim strArrAddDiv		'�ǉ������敪�̔z��
Dim strArrAddName		'�ǉ��������̔z��
Dim strArrRequestName	'�������ږ��̔z��
Dim strArrIsrSign		'���ۋL���̔z��
Dim strArrIsrNo			'���۔ԍ��̔z��
Dim strArrSubCsWebColor	'�T�u�R�[�X��web�J���[�̔z��
Dim strArrSubCsName		'�T�u�R�[�X���̔z��
Dim strArrEntry			'���ʓ��͏�Ԃ̔z��
Dim strArrRsvStatus		'�\��󋵂̔z��
Dim strArrCardPrintDate	'�m�F�͂����o�͓��̔z��
Dim strArrFormPrintDate	'�ꎮ�����o�͓��̔z��
Dim strArrRsvGrpName	'�\��Q���̂̔z��
Dim strArrCompPerId		'�����ҌlID�̔z��
Dim lngCount			'���R�[�h����

'## 2003.11.26 Add By T.Takagi@FSIT �������g�̓J�E���g���Ă͂����Ȃ�
Dim lngCount2			'����
'## 2003.11.26 Add End

Dim i, j				'�J�E���^

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")

'�����l�̎擾
strCslDate			= Request("csldate")
strPerId			= Request("perid")
strKey				= Request("key")

Do
	dtmStrDate = CDate(strCslDate)
	dtmEndDate = 0
	lngArrPrtField = Array(2,4,5,6,10,17,39)
	lngSortKey = lngArrPrtField(0)
	lngSortKey = 11

	'��f���̓ǂݍ���
'## 2004/01/20 Add By K.Kagawa@FFCS �����҂̒ǉ�
	lngCount = objConsult.SelectDailyList( _
				   strKey,             dtmStrDate,          dtmEndDate,        _
				   "",                 "",                  "",                  "",                _
				   "",                 "",                  lngArrPrtField,    _
				   lngSortKey,         0,                   0,                   0,                 _
				   strArrRsvNo,        strArrCancelFlg,     strArrCslDate,       strArrPerId,       _
				   strArrOrgSName,     strArrRsvDate,       strArrAge,         _
				   strArrDayId,        strArrWebColor,      strArrCsName,      _
				   strArrName,         strArrKanaName,      strArrBirth,         strArrGender,      _
				   strArrAddDiv,       strArrAddName,       strArrRequestName,                      _
				   strArrIsrSign,      strArrIsrNo,         strArrSubCsWebColor, strArrSubCsName,   _
				   strArrEntry,        strArrRsvStatus,     strArrCardPrintDate, strArrFormPrintDate, _
				   strArrRsvGrpName,   ,                    ,                    ,                  _
				   strArrCompPerId _
			   )
'## 2004/01/20 Add End
	If lngCount < 0 Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�L�[= " & strCslDate & " ��f��= " & strCslDate & " )"
	End If


	Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>��f�҂̌���</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// ��f�҂̑I��
function selectFriends( index ) {
	var openerForm = opener.document.entryForm;
	var myForm = document.entryForm;
	var i;

// ## 2003.11.26 Add By T.Takagi@FSIT �P�����ƃG���[
	if ( myForm.s_rsvno.length == null ) {

		// �d���`�F�b�N
		for ( i = 0; i < openerForm.f_rsvno.length; i++ ) {
			if ( openerForm.f_rsvno[i].value == myForm.s_rsvno.value ) {
				alert( '���łɑI������Ă��܂�' );
				return;
			}
		}

		// ��f�ҏ��̃Z�b�g
		openerForm.f_csldate[opener.SelectLineNo].value = <%= strCslDate %>;
		openerForm.f_rsvno[opener.SelectLineNo].value   = myForm.s_rsvno.value;
		openerForm.f_perid[opener.SelectLineNo].value   = myForm.s_perid.value;
		openerForm.f_orgname[opener.SelectLineNo].value = myForm.s_orgname.value;
		openerForm.f_csname[opener.SelectLineNo].value  = myForm.s_csname.value;
		openerForm.f_name[opener.SelectLineNo].value    = myForm.s_name.value;
		openerForm.f_kname[opener.SelectLineNo].value   = myForm.s_kname.value;
		openerForm.f_rsvgrpname[opener.SelectLineNo].value   = myForm.s_rsvgrpname.value;
// ## 2004.01.20 Add By K.Kagawa@FFCS �����Ґݒ�̒ǉ�
		openerForm.comporg[opener.SelectLineNo].value   = myForm.s_compperid.value;
		openerForm.compnew[opener.SelectLineNo].value   = myForm.s_compperid.value;
// ## 2004.01.20 Add End

		// ���A��l���X�g�̍ĕ\��
		opener.dispFriendsList();

		opener.winGuide = null;
		close();

		return;
	}
// ## 2003.11.26 Add End

	// �d���`�F�b�N
	for( i=0; i<openerForm.f_rsvno.length; i++ ) {
		if( openerForm.f_rsvno[i].value == myForm.s_rsvno[index].value) {
			alert( "���łɑI������Ă��܂�" );
			return;
		}
	}

	// ��f�ҏ��̃Z�b�g
	openerForm.f_csldate[opener.SelectLineNo].value = <%= strCslDate %>;
	openerForm.f_rsvno[opener.SelectLineNo].value   = myForm.s_rsvno[index].value;
	openerForm.f_perid[opener.SelectLineNo].value   = myForm.s_perid[index].value;
	openerForm.f_orgname[opener.SelectLineNo].value = myForm.s_orgname[index].value;
	openerForm.f_csname[opener.SelectLineNo].value  = myForm.s_csname[index].value;
	openerForm.f_name[opener.SelectLineNo].value    = myForm.s_name[index].value;
	openerForm.f_kname[opener.SelectLineNo].value   = myForm.s_kname[index].value;
	openerForm.f_rsvgrpname[opener.SelectLineNo].value   = myForm.s_rsvgrpname[index].value;
// ## 2004.01.20 Add By K.Kagawa@FFCS �����Ґݒ�̒ǉ�
	openerForm.comporg[opener.SelectLineNo].value   = myForm.s_compperid[index].value;
	openerForm.compnew[opener.SelectLineNo].value   = myForm.s_compperid[index].value;
// ## 2004.01.20 Add End

	// ���A��l���X�g�̍ĕ\��
	opener.dispFriendsList();

	opener.winGuide = null;
	close();

	return;
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" ONLOAD="javascript:document.entryForm.key.focus();">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="csldate" VALUE="<%= strCslDate %>">
	<INPUT TYPE="hidden" NAME="perid"   VALUE="<%= strPerId %>">
	<!-- �^�C�g���̕\�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">��</SPAN><FONT COLOR="#000000">��f�҂̌���</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
	<!-- ���������̕\�� -->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="326">
		<TR HEIGHT="20">
			<TD WIDTH="10" ROWSPAN="2"></TD>
			<TD NOWRAP>��f��</TD>
			<TD>�F</TD>
			<TD><B><%= strCslDate %></B></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD>�L�[</TD>
			<TD>�F</TD>
			<TD NOWRAP><INPUT TYPE="text" NAME="key" SIZE="24" VALUE="<%= strKey %>"></TD>
			<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false;"><IMG SRC="../../images/b_search.gif" BORDER="0" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></A></TD>
		</TR>
	</TABLE>
	<BR>
	<!-- �����������ʂ̕\�� -->
<%
'## 2003.11.26 Add By T.Takagi@FSIT �������g�̓J�E���g���Ă͂����Ȃ�
	For i = 0 To lngCount - 1
		If strPerId <> strArrPerId(i) Then
			lngCount2 = lngCount2 + 1
		End If
	Next
'## 2003.11.26 Add End
%>
<%
'## 2003.11.26 Mod By T.Takagi@FSIT �������g�̓J�E���g���Ă͂����Ȃ�
'	If lngCount = 0 Then
	If lngCount2 = 0 Then
'## 2003.11.26 Mod End
		Response.Write "���������𖞂�����f���͑��݂��܂���B <BR>"
'## 2003.11.26 Add By T.Takagi@FSIT
		Response.Write "</FORM></BODY></HTML>"
		Response.End
'## 2003.11.26 Add End
	Else
%>
		�u<FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strCslDate, "yyyy�Nm��d��") %></B></FONT>�v�̎�f�҈ꗗ��\�����Ă��܂��B<BR>
<!-- ## 2003.11.26 Add By T.Takagi@FSIT -->
<!--
		�Ώێ�f�҂� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>�l�ł��B <BR>
-->
		�Ώێ�f�҂� <FONT COLOR="#ff6600"><B><%= lngCount2 %></B></FONT>�l�ł��B <BR>
<!-- ## 2003.11.26 Add End -->
<%
	End If
%>
	<BR>
	<!-- �����������ʈꗗ�̕\�� -->
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
		<TR BGCOLOR="#cccccc">
			<TD NOWRAP>�Ώۗ\��ԍ�</TD>
			<TD NOWRAP>��f�R�[�X</TD>
			<TD NOWRAP>�l����</TD>
		</TR>
<%
	j=0
	For i = 0 To lngCount - 1
		If strPerId <> strArrPerId(i) Then
%>
		<TR BGCOLOR="#<%= IIf(j Mod 2 = 0, "ffffff", "eeeeee") %>">
			<TD NOWRAP><A HREF="../Reserve/rsvMain.asp?rsvNo=<%= strArrRsvNo(i) %>" TARGET="_blank"><%= strArrRsvNo(i) %></A></TD>
			<TD NOWRAP><FONT COLOR="#<%= strArrWebColor(i) %>">��</FONT><%= strArrCsName(i) %></TD>
			<TD NOWRAP><A HREF="JavaScript:selectFriends(<%= j %>)"><%= strArrName(i) %><FONT SIZE="-1" COLOR="#666666">�i<%= strArrKanaName(i) %>�j</FONT></A></TD>

			<INPUT TYPE="hidden" NAME="s_rsvno"   VALUE="<%= strArrRsvNo(i) %>">
			<INPUT TYPE="hidden" NAME="s_perid"   VALUE="<%= strArrPerId(i) %>">
			<INPUT TYPE="hidden" NAME="s_orgname" VALUE="<%= strArrOrgSName(i) %>">
			<INPUT TYPE="hidden" NAME="s_csname"  VALUE="<%= strArrCsName(i) %>">
			<INPUT TYPE="hidden" NAME="s_name"    VALUE="<%= strArrName(i) %>">
			<INPUT TYPE="hidden" NAME="s_kname"   VALUE="<%= strArrKanaName(i) %>">
			<INPUT TYPE="hidden" NAME="s_rsvgrpname" VALUE="<%= strArrRsvGrpName(i) %>">
			<INPUT TYPE="hidden" NAME="s_compperid"  VALUE="<%= strArrCompPerId(i) %>">
		</TR>
<%
			j = j + 1
		End If
	Next
%>
	</TABLE>
<!-- ## 2003.11.26 Add By T.Takagi@FSIT -->
<!--
	<BR>
	<BR>
	<BR>
	</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="ffffff">.</FONT></DIV>
-->
</FORM>
<!-- ## 2003.11.26 Add End -->
</BODY>
</HTML>
