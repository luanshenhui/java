<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���R�����g�i�w�b�_�[�j  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
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
Dim objPerson			'�l�N���X
Dim objConsult			'��f�N���X
Dim objPubNote			'�m�[�g�N���X
Dim objOrg				'�c�̏��A�N�Z�X�p

'�p�����[�^
Dim lngRsvNo			'�\��ԍ�
Dim strPerId			'�lID
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim lngStrYear			'�\���J�n�N
Dim lngStrMonth			'�\���J�n��
Dim lngStrDay			'�\���J�n��
Dim lngEndYear			'�\���I���N
Dim lngEndMonth			'�\���I����
Dim lngEndDay			'�\���I����
Dim strPubNoteDivCd		'�m�[�g����
Dim strPubNoteDivCdCtr	'�m�[�g����(�_��p)
Dim strPubNoteDivCdOrg	'�m�[�g����(�c�̗p)
Dim lngDispKbn			'�\���Ώۋ敪
Dim lngDispMode			'�\�����[�h
Dim	strWinMode			'�E�B���h�E���[�h
'### 2004/3/24 Added by Ishihara@FSIT �폜�f�[�^�\���Ή�
Dim lngIncDelNote		'1:�폜�f�[�^���\��
'### 2004/3/24 Added End

'�l���
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strGender			'����
Dim strGenderName		'���ʖ���

'��f���
Dim strCslDate			'��f��
Dim strCsCd				'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��
Dim strAge				'�N��
Dim strDayId			'����ID
Dim strOrgName			'�c�̊�������

'�m�[�g����
Dim vntPubNoteDivCd		'��f���m�[�g���ރR�[�h
Dim vntPubNoteDivName	'��f���m�[�g���ޖ���
Dim vntDefaultDispKbn	'�\���Ώۋ敪�����l
Dim vntOnlyDispKbn		'�\���Ώۋ敪���΂�

'�\���Ώۋ敪
Dim vntDispKbnCd		'�\���Ώۋ敪�R�[�h
Dim vntDispKbnName		'�\���Ώۋ敪����

'���[�U���
Dim strUpdUser			'�X�V��
Dim lngAuthNote      	'�Q�Ɠo�^����
Dim lngDefNoteDispKbn	'�m�[�g�����\�����

Dim lngCount			'�擾����
Dim Ret					'���A�l
Dim i, j				'�J�E���^�[


'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objHainsUser	= Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerson		= Server.CreateObject("HainsPerSon.Person")
Set objConsult		= Server.CreateObject("HainsConsult.Consult")
Set objPubNote		= Server.CreateObject("HainsPubNote.PubNote")
Set objOrg			= Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
lngRsvNo		= CLng("0" & Request("rsvno"))
strPerId		= Request("perid")
strOrgCd1		= Request("orgcd1")
strOrgCd2		= Request("orgcd2")
strCtrPtCd		= Request("ctrptcd")
lngStrYear		= CLng("0" & Request("StrYear"))
lngStrMonth		= CLng("0" & Request("StrMonth"))
lngStrDay		= CLng("0" & Request("StrDay"))
lngEndYear		= CLng("0" & Request("EndYear"))
lngEndMonth		= CLng("0" & Request("EndMonth"))
lngEndDay		= CLng("0" & Request("EndDay"))
strPubNoteDivCd	= Request("PubNoteDivCd")
strPubNoteDivCdCtr	= Request("PubNoteDivCdOrg")
strPubNoteDivCdOrg	= Request("PubNoteDivCdCtr")
lngDispKbn		= CLng("0" & Request("DispKbn"))
lngDispMode		= CLng("0" & Request("DispMode"))
strWinMode		= Request("winmode")
'### 2004/3/24 Added by Ishihara@FSIT �폜�f�[�^�\���Ή�
lngIncDelNote   = Request("IncDelNote")
'### 2004/3/24 Added End

strUpdUser		= Session("USERID")


Do
	'���[�U�̎Q�Ɠo�^�������擾
	objHainsUser.SelectHainsUser strUpdUser, _
								,,,,,,,,,,,,,,,,,,,,,,,, _
								lngAuthNote, lngDefNoteDispKbn

	If lngRsvNo <> "0" Then
		'��f���̎擾
		Ret = objConsult.SelectConsult(	lngRsvNo, _
										, _
										strCslDate,    _
										strPerId,      _
										strCsCd,       _
										strCsName,     _
										, , _
										strOrgName,     _
										, , _
										strAge,        _
										, , , , , , , , , , , , _
										strDayId,   _
										, , 0, , , , , , , , , , , , , , , _
										strLastName,   _
										strFirstName,  _
										strLastKName,  _
										strFirstKName, _
										strBirth,      _
										strGender )
		If Ret = False Then
			Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
		End If
	Else
		If strPerId <> "" Then
			'�l���̎擾
			Ret = objPerson.SelectPersonInf(	strPerId,      _
												strLastName,   _
												strFirstName,  _
												strLastKName,  _
												strFirstKName, _
												strBirth,      _
												strGender,     _
												strGenderName, _
												strAge )
			If Ret = False Then
				Err.Raise 1000, , "�l��񂪑��݂��܂���B�i�lID= " & strPerId & " )"
			End If
		End If

		If strOrgCd1 <> "" And strOrgCd2 <> "" Then
			'�c�̏����擾����
			Ret = objOrg.SelectOrg_lukes(	strOrgCd1, strOrgCd2, _
											 , , _
											strOrgName )
			If Ret = False Then
				Err.Raise 1000, , "�c�̏�񂪎擾�ł��܂���B�i�c�̃R�[�h= " & strOrgCd1 & "-" & strOrgCd2 &  "�j"
			End If
		End If
	End If

	'�m�[�g���ނ̎擾
	lngCount = objPubNote.SelectPubNoteDivList(	strUpdUser, _
												vntPubNoteDivCd,   _
												vntPubNoteDivName, _
												vntDefaultDispKbn, _
												vntOnlyDispKbn )
	If lngCount < 0 Then
		Err.Raise 1000, , "�m�[�g���ނ����݂��܂���B"
	End If

	'�\���Ώۋ敪
	vntDispKbnCd = Array()
	vntDispKbnName = Array()
	Redim Preserve vntDispKbnCd(1)
	Redim Preserve vntDispKbnName(1)
	vntDispKbnCd(0) = "1":vntDispKbnName(0) = "��Ï��̂ݕ\��"
	vntDispKbnCd(1) = "2":vntDispKbnName(1) = "�������̂ݕ\��"

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�R�����g�ꗗ</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!--
var winCommentDetail;			// �R�����g���ڍ׃E�B���h�E�n���h��

// �V�K
function calCommentDetail() {
	var myForm = document.entryForm;
	var url;							// URL������
	var opened = false;					// ��ʂ����łɊJ����Ă��邩


	url = '/WebHains/contents/comment/commentDetail2.asp';
	url = url + '?rsvno='   + myForm.rsvno.value;
	url = url + '&perid='   + myForm.perid.value;
	url = url + '&orgcd1='  + myForm.orgcd1.value;
	url = url + '&orgcd2='  + myForm.orgcd2.value;
	url = url + '&ctrptcd=' + myForm.ctrptcd.value;
	url = url + '&PubNoteDivCd=' + myForm.PubNoteDivCd.value;
	url = url + '&cmtMode=' + parent.params.cmtMode;
	url = url + '&seq=0';

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winCommentDetail != null ) {
		if ( !winCommentDetail.closed ) {
			opened = true;
		}
	}

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winCommentDetail.focus();
		winCommentDetail.location.replace( url );
	} else {
		winCommentDetail = window.open( url, '', 'width=650,height=500,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
	}
}

// ����
function searchComment() {
	var myForm = document.entryForm;
	var url;		// URL������

	// �\�����ԓ��̓`�F�b�N
	if ( myForm.StrYear.value != '' || myForm.StrMonth.value != '' || myForm.StrDay.value != '' ) {
		if ( !isDate( myForm.StrYear.value, myForm.StrMonth.value, myForm.StrDay.value ) ) {
			alert('�\�����Ԃ̌`���Ɍ�肪����܂��B');
			return;
		}
	}

	if ( myForm.EndYear.value != '' || myForm.EndMonth.value != '' || myForm.EndDay.value != '' ) {
		if ( !isDate( myForm.EndYear.value, myForm.EndMonth.value, myForm.EndDay.value ) ) {
			alert('�\�����Ԃ̌`���Ɍ�肪����܂��B');
			return;
		}
	}

	// URL������̕ҏW
	url = parent.location.pathname;
	url = url + '?rsvno='        + myForm.rsvno.value;
	url = url + '&perid='        + myForm.perid.value;
	url = url + '&orgcd1='       + myForm.orgcd1.value;
	url = url + '&orgcd2='       + myForm.orgcd2.value;
	url = url + '&ctrptcd='      + myForm.ctrptcd.value;
	url = url + '&StrYear='      + myForm.StrYear.value;
	url = url + '&StrMonth='     + myForm.StrMonth.value;
	url = url + '&StrDay='       + myForm.StrDay.value;
	url = url + '&EndYear='      + myForm.EndYear.value;
	url = url + '&EndMonth='     + myForm.EndMonth.value;
	url = url + '&EndDay='       + myForm.EndDay.value;
	url = url + '&PubNoteDivCd=' + myForm.PubNoteDivCd.value;
	url = url + '&PubNoteDivCdCtr=' + myForm.PubNoteDivCdCtr.value;
	url = url + '&PubNoteDivCdOrg=' + myForm.PubNoteDivCdOrg.value;
	url = url + '&DispKbn='      + myForm.DispKbn.value;
	url = url + '&DispMode='     + myForm.DispMode.value;
	url = url + '&IncDelNote='   + myForm.IncDelNote.value;
	url = url + '&CmtMode='      + parent.params.cmtMode;
	url = url + '&winmode='      + parent.params.winmode;
	url = url + '&act='          + parent.params.act;
	// �������ʕ\��
	parent.location.replace(url);

	return;

}

// �\�����[�h�`�F�b�N
function checkDispMode() {
	var myForm = document.entryForm;

	if( myForm.Chk.checked ) {
		myForm.DispMode.value = '1';
	} else {
		myForm.DispMode.value = '0';
	}
}

// �폜�f�[�^���[�h�`�F�b�N
function checkIncDelNote() {
	var myForm = document.entryForm;

	if( myForm.chkIncDelNote.checked ) {
		myForm.IncDelNote.value = '1';
	} else {
		myForm.IncDelNote.value = '0';
	}
}

// �E�B���h�E�����
function windowClose() {

	// ���t�K�C�h�E�C���h�E�����
	calGuide_closeGuideCalendar();

	// �R�����g���ڍׂ����
	if ( winCommentDetail != null ) {
		if ( !winCommentDetail.closed ) {
			winCommentDetail.close();
		}
	}

	winCommentDetail  = null;
}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: <%= IIF(lngDispMode="2","0","12") %>px 0 0 <%= IIF(lngDispMode="2","20","5") %>px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:windowClose()">
<%
	'�ʐڎx���̂Ƃ�
	If lngDispMode = "2" Then
		'�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
		If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
			Call interviewHeader(lngRsvNo, 0)
		End If
	End  If
%>
<BASEFONT SIZE="2">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="rsvno"           VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="perid"           VALUE="<%= strPerId %>">
	<INPUT TYPE="hidden" NAME="orgcd1"          VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgcd2"          VALUE="<%= strOrgCd2 %>">
	<INPUT TYPE="hidden" NAME="ctrptcd"         VALUE="<%= strCtrPtCd %>">
	<INPUT TYPE="hidden" NAME="orgStrYear"      VALUE="<%= lngStrYear %>">
	<INPUT TYPE="hidden" NAME="orgStrMonth"     VALUE="<%= lngStrMonth %>">
	<INPUT TYPE="hidden" NAME="orgStrDay"       VALUE="<%= lngStrDay %>">
	<INPUT TYPE="hidden" NAME="orgEndYear"      VALUE="<%= lngEndYear %>">
	<INPUT TYPE="hidden" NAME="orgEndMonth"     VALUE="<%= lngEndMonth %>">
	<INPUT TYPE="hidden" NAME="orgEndDay"       VALUE="<%= lngEndDay %>">
	<INPUT TYPE="hidden" NAME="orgPubNoteDivCd" VALUE="<%= strPubNoteDivCd %>">
	<INPUT TYPE="hidden" NAME="PubNoteDivCdCtr" VALUE="<%= strPubNoteDivCdCtr %>">
	<INPUT TYPE="hidden" NAME="PubNoteDivCdOrg" VALUE="<%= strPubNoteDivCdOrg %>">
	<INPUT TYPE="hidden" NAME="orgDispKbn"      VALUE="<%= lngDispKbn %>">
	<INPUT TYPE="hidden" NAME="DispMode"        VALUE="<%= lngDispMode %>">
	<INPUT TYPE="hidden" NAME="IncDelNote"      VALUE="<%= lngIncDelNote %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�R�����g���</FONT></B></TD>
		</TR>
	</TABLE>
	<BR>
<%
'�ʐڎx���̂Ƃ��͌l�E��f���͕\�����Ȃ�
If lngDispMode <> "2" Then
	If lngRsvNo <> "0" Then

'### 2013.03.26 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@Start ###
Dim objSpecialInterview         '���茒�f���A�N�Z�X�p
Dim lngSpCheck                  '����ی��w���Ώۂ��`�F�b�N

Set objSpecialInterview     = Server.CreateObject("HainsSpecialInterview.SpecialInterview")

    lngSpCheck = objSpecialInterview.CheckSpecialTarget(lngRsvNo)

'### 2013.03.26 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@End   ###
%>
	<!-- ��f���̕\�� -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD NOWRAP>��f���F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCslDate %></B></FONT></TD>
			<TD NOWRAP>�@�R�[�X�F</TD>
            <TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD NOWRAP>�@�����h�c�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayID, "0000") %></B></FONT></TD>
			<TD NOWRAP>�@�c�́F</TD>
			<TD NOWRAP><%= strOrgName %></TD>
<%
'### 2013.03.26 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@Start ###
            If lngSpCheck > 0 Then 
%>
            <TD NOWRAP><IMG SRC="../../images/physical10.gif"  HEIGHT="22" WIDTH="22" BORDER="0" ALT="����ی��w���Ώ�"></TD>
<%
            End If
'### 2013.03.26 ����ی��w���Ώێ҃`�F�b�N�̈גǉ��@End  ###
%>

		</TR>
	</TABLE>
<%
	Else
		'�c�̖�����H
		If strOrgName <> "" Then
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD NOWRAP>�c�́F</TD>
			<TD NOWRAP><%= strOrgName %></TD>
		</TR>
	</TABLE>
<%
		End If
	End If
	If lngRsvNo <> "0" Or strPerId <> "" Then
%>
	<!-- �l���̕\�� -->
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD NOWRAP><%= strPerId %></TD>
			<TD NOWRAP WIDTH="10">�@</TD>
			<TD NOWRAP>�@<B><%= strLastName & " " & strFirstName %></B> �i<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>�j</TD>
			<TD NOWRAP>�@�@<%= objCommon.FormatString(CDate(strBirth), "ge�iyyyy�j.m.d") %>���@<%= Int(strAge) %>�΁@<%= IIf(strGender = "1", "�j��", "����") %></TD>
		</TR>
	</TABLE>
<%
	End If
%>
	<BR>
<%
End If
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="2">
		<!-- ���������F�\������ -->
		<TR>
			<TD NOWRAP>�\������</TD>
			<TD>�F</TD>
			<TD COLSPAN="2">
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('StrYear', 'StrMonth', 'StrDay')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditSelectNumberList("StrYear", YEARRANGE_MIN, YEARRANGE_MAX, lngStrYear) %></TD>
						<TD>�N</TD>
						<TD><%= EditSelectNumberList("StrMonth", 1, 12, lngStrMonth) %></TD>
						<TD>��</TD>
						<TD><%= EditSelectNumberList("StrDay", 1, 31, lngStrDay) %></TD>
						<TD>��</TD>
						<TD>�`</TD>
						<TD><A HREF="javascript:calGuide_showGuideCalendar('EndYear', 'EndMonth', 'EndDay')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
						<TD><%= EditSelectNumberList("EndYear", YEARRANGE_MIN, YEARRANGE_MAX, lngEndYear) %></TD>
						<TD>�N</TD>
						<TD><%= EditSelectNumberList("EndMonth", 1, 12, lngEndMonth) %></TD>
						<TD>��</TD>
						<TD><%= EditSelectNumberList("EndDay", 1, 31, lngEndDay) %></TD>
						<TD>��</TD>
					</TR>
				</TABLE>
			</TD>
			<TD COLSPAN="3"><INPUT TYPE="checkbox" NAME="chkIncDelNote" VALUE="1" <%= IIf(lngIncDelNote = "1", " CHECKED", "") %> ONCHANGE="javascript:checkIncDelNote()">�폜�f�[�^���\��</TD>
		</TR>
		<!-- ���������F�R�����g��� -->
		<TR>
			<TD NOWRAP>�R�����g���</TD>
			<TD>�F</TD>
			<TD>
				<%= EditDropDownListFromArray("PubNoteDivCd", vntPubNoteDivCd, vntPubNoteDivName, strPubNoteDivCd, SELECTED_ALL) %>
				�@
<%
	If lngAuthNote = "3" Then
%>
				<%= EditDropDownListFromArray("DispKbn", vntDispKbnCd, vntDispKbnName, lngDispKbn, SELECTED_ALL) %>
<%
	Else
%>
				<INPUT TYPE="hidden" NAME="DispKbn" VALUE="<%= lngDispKbn %>">
<%
	End If
%>
			</TD>
<%
	If lngDispMode = "2" Then
%>
			<TD>&nbsp;</TD>
<%
	Else
%>
			<TD>
				<INPUT TYPE="checkbox" NAME="Chk" VALUE="1" <%= IIf(lngDispMode=1, " CHECKED", "") %> ONCHANGE="javascript:checkDispMode()">�_��E�c�̃R�����g��\������
			</TD>
<%
	End If


%>


<%

    '2006.07.04 �����Ǘ� �ǉ� by ���@
    if Session("PAGEGRANT") = "4" then 
%>
			<TD NOWRAP>
				<A HREF="JavaScript:calCommentDetail()"><IMG SRC="../../images/newrsv.gif" ALT="�R�����g��ǉ�" HEIGHT="24" WIDTH="77" BORDER="0"></A>

<%  else    %>
             <TD NOWRAP>
                 &nbsp;
<%  End If   %>

				<A HREF="JavaScript:searchComment()"><IMG SRC="../../images/b_search.gif" ALT="�w������ŕ\��" HEIGHT="24" WIDTH="77" BORDER="0"></A>
			</TD>
		</TR>
	</TABLE>

</FORM>
</BODY>
</HTML>
