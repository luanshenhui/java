<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�t�B�����ԍ����� (Ver0.0.1)
'		AUTHER  : Yamamoto yk-mix@kjps.net
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
'## 2003.02.12 Mod 2Lines By T.Takagi@FSIT ��������������
'Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)
'## 2003.02.12 Mod End

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const FREECD = "FILM"	'�ėp�R�[�h

Dim objCommon		'���ʃN���X
Dim objFree	 		'�ėp�e�[�u��
Dim objConsult		'��f���A�N�Z�X�p
Dim objFilmNo		'�t�B�����ԍ��X�V�p�I�u�W�F�N�g

'-----------------------------------------------------------------------------
' �ϐ��錾
'-----------------------------------------------------------------------------
Dim strKey			'�o�[�R�[�h���̓f�[�^

'��f���
Dim lngRsvNo		'�\��ԍ�
'Dim strCancelFlg	'�L�����Z���t���O
Dim strCslDate		'��f�N����
Dim strPerId		'�l�h�c
Dim strCsCd			'�R�[�X�R�[�h
Dim strCsName		'�R�[�X��
Dim strAge			'��f���N��
Dim strDayId		'�����h�c
Dim strOrgSName		'�c�̗���
Dim strUpdDate		'(��t����)�X�V����
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strGender		'����

'�T�u�R�[�X���
Dim strSubCsName	'�T�u�R�[�X��
Dim lngCount		'���R�[�h��


'�ėp�e�[�u��
Dim strKeyFreeCd  		'�ėp�R�[�h�i�L�[�j
Dim strFreeCd			'�ėp�R�[�h
Dim strFreeClassCd		'�ėp���ރR�[�h
Dim strFreeName			'�ėp��

Dim strToday			'�{�����t�i�V�X�e�����t�j
Dim strDispPerName		'�l���́i�����j
Dim strDispPerKName		'�l���́i�J�i�j
Dim strDispAge			'�N��i�\���p�j
Dim strDispBirth		'���N�����i�\���p�j

Dim strHtml         	'html�o�͗p���[�N
Dim strBuffer       	'html�o�͗p���[�N
Dim lngPerCount			'�߂�l�i�l�e�[�u���j
Dim lngFreeCount		'�߂�l�i�ėp�e�[�u���j
Dim lngStatus			'�X�e�[�^�X

Dim strFilmKind     	'�I����ޕۑ��p���[�N
Dim i	  				'���[�v�J�E���g

'*****  2002/01/17  ADD  START  E.Yamamoto
Dim strOldFilmNo		'�������ʃe�[�u���̃t�B�����ԍ��i�Q�x�ǂݑΉ��j
'*****  2002/01/17  ADD  END    E.Yamamoto
'## 2003.01.17 Add 1Line By T.Takagi@FSIT �B�e���Ή�
Dim strOldFilmDate		'�������ʃe�[�u���̎B�e���i�Q�x�ǂݑΉ��j
'## 2003.01.17 Add End

'*****  2003/01/21  ADD  START  E.Yamamoto
Dim strMachineCls		'���@�敪
Dim strMachineNo		'���@�ԍ�
Dim blnMachineCls		'���@�敪�t���O
Dim strSrchKeyFreeCd  	'�ėp�R�[�h�i�����p�j
'*****  2003/01/21  ADD  END    E.Yamamoto

Dim strURL				'�W�����v���URL

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
Set objCommon  = Server.CreateObject("HainsCommon.Common")
Set objFree 	= Server.CreateObject("HainsFree.Free")
Set objConsult	= Server.CreateObject("HainsConsult.Consult")
	Set objFilmNo 	= Server.CreateObject("HainsFilmNo.FilmNo")

'�����l�̎擾
strKey 			= Request("key")
strKeyFreeCd	= Request("freeCd")

lngStatus = 0

'*****  2003/01/22  ADD  START  E.Yamamoto
'���@�敪�`�F�b�N
blnMachineCls = EditFreeCd(strKeyFreeCd)
'*****  2003/01/22  ADD  END    E.Yamamoto

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'�o�[�R�[�h�l�����݂��Ȃ��ꍇ�͉������Ȃ�
	If( strKey = "" )Then
		Exit Do
	End If

	'�o�[�R�[�h���������f���̗\��ԍ����擾
	lngRsvNo = objConsult.GetRsvNoFromBarCode(strKey)
'## 2003.02.15 Add 16Lines By T.Takagi@FSIT �\��ԍ��̎擾��ASP���ōs��
	Select Case lngRsvNo
		Case 0	'��f��񂪑��݂��Ȃ�
			lngStatus = -20
		Case -1	'�o�[�R�[�h�����񂪑��݂��Ȃ�
			lngStatus = -2
		Case -2	'�����񂪕s��
			lngStatus = -3
		Case -3	'��f�N���������t�Ƃ��ĔF���ł��Ȃ�
			lngStatus = -4
		Case -4	'�敪�̒l���s��
			lngStatus = -5
	End Select

	If lngRsvNo <= 0 Then
		Exit Do
	End If
'## 2003.02.15 Add End

	'�t�B�����ԍ��̍X�V
'## 2003.01.17 Mod 2Lines By T.Takagi@FSIT �B�e���Ή�
'	lngStatus = objFilmNo.UpdateFilmNo(strKey, strKeyFreeCd, strOldFilmNo )
'## 2003.02.15 Mod 2Lines By T.Takagi@FSIT �\��ԍ��̎擾��ASP���ōs��
'	lngStatus = objFilmNo.UpdateFilmNo(strKey, strKeyFreeCd, strOldFilmNo, strOldFilmDate)
	lngStatus = objFilmNo.UpdateFilmNo(lngRsvNo, strKeyFreeCd, strOldFilmNo, strOldFilmDate)
'## 2003.02.15 Mod End
'## 2003.01.17 Mod End

	Exit Do
Loop

If( strKeyFreeCd <> "" ) Then
'*****  2003/01/22  ADD  START  E.Yamamoto
	If( blnMachineCls = False ) Then
		strSrchKeyFreeCd = FREECD & strMachineCls
	Else
		strSrchKeyFreeCd = strKeyFreeCd
	End If
'*****  2003/01/22  ADD  END    E.Yamamoto

	'�ėp�e�[�u�����t�B������ʖ����擾
	lngFreeCount = objFree.SelectFree( 1,strSrchKeyFreeCd,strFreeCd,strFreeName)

End If

'*****  2003/01/21  ADD  START  E.Yamamoto
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �t���[�R�[�h�����獆�@�敪�C���@�ԍ����擾����
'
' �����@�@ : 
'
' �߂�l�@ : �Ȃ�
'
' ���l�@�@ : 
'
'-------------------------------------------------------------------------------
Function EditFreeCd(strFreeCd)

	Dim lngStrLength
	Dim lngConstStrLength
	
	lngStrLength = len(strFreeCd)
	lngConstStrLength = len(FREECD) + 1
	
	strMachineCls = mid(strFreeCd,lngConstStrLength,1)
	lngConstStrLength = lngConstStrLength + 1
	
	strMachineNo = mid(strFreeCd,lngConstStrLength,1)

	'�O��ǂݍ��񂾍��@�敪�ƈقȂ�ꍇ�܂��́u�O�v�̏ꍇ��true�A����ȊO��false�Ƃ���B
	If( strMachineCls = "0" )Then
		EditFreeCd = True
	else
		EditFreeCd = false
	End If
 	
End Function
'*****  2003/01/21  ADD  END    E.Yamamoto

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�t�B�����ԍ�����</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �t�B�����ԍ��C����ʌĂяo��
function callRevFilmNo(fileNo) {

	var objForm = document.entryForm;	// ����ʂ̃t�H�[���G�������g
	var url		= '/webHains/contents/FilmNo/';		// �Ăяo���悕����
	var filename1	= 'RevFilmNo.asp?freeCd=';		// �t�@�C�����P
	var filename2	= 'RevPerFilmNo.asp?freeCd=';	// �t�@�C�����Q

	switch ( fileNo ) {
		case 1 :
			 url = url + filename1 + objForm.freeCd.value;
			 break;
		case 2 :
			 url = url + filename2 + objForm.freeCd.value;
			 break;
	}
	
	location.href(url);
	
}
//-->
</SCRIPT>
</HEAD>
<BODY ONLOAD="document.entryForm.key.focus()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="GET">
<BLOCKQUOTE>
<!--  2003/01/22  DEL  START  E.Yamamoto  -->
<!--  <INPUT TYPE="hidden" NAME="freeCd" SIZE="24" VALUE="<%= strKeyFreeCd %>" >  -->
<!--  2003/01/22  DEL  END    E.Yamamoto  -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="print">��</SPAN><FONT COLOR="#000000">�t�B�����ԍ�����</FONT></B></TD>
	</TR>
</TABLE>
<!-- 2003/01/17  ADD  START  E.Yamamoto  ����{�^�� -->
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="650">
	<TR>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="5"></TD>
	</TR>
	<TR>
		<TD ALIGN="left">
			<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0">
				<TR>
					<TD><A HREF="SltFilmkind.asp"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�t�B�����ԍ��I����ʂɖ߂�܂�"></A></TD>
					<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
	</TR>
</TABLE>
<!-- 2003/01/17  ADD  END    E.Yamamoto  ����{�^�� -->
<!--	<IMG SRC="/webHains/images/barcode.jpg" WIDTH="171" HEIGHT="172" ALIGN="left">-->
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
<%
'*****  2003/01/22  ADD  START  E.Yamamoto
			If blnMachineCls = True Then
%>
				<TD VALIGN="bottom"><FONT SIZE="6"><%= strFreeName(0) %><BR><INPUT TYPE="hidden" NAME="freeCd" SIZE="24" VALUE="<%= strKeyFreeCd %>"></FONT></TD>
<%
			Else

				'�t�B�������̕ҏW�@���@�ԍ���t������
				For i = 0 To UBound(strFreeCd)
					If( Not EditFreeCd(strFreeCd(i)) ) Then
						strFreeName(i) = strFreeName(i) & "�i " & strMachineNo & "���@�j"
					End If
				Next
%>
				<TD VALIGN="bottom"><%= EditDropDownListFromArray("freeCd", strFreeCd, strFreeName , strKeyFreeCd, NON_SELECTED_DEL) %></TD>
<%
			End If
'*****  2003/01/22  ADD  END    E.Yamamoto
%>
		</TR>
	</TABLE>
<BR>
<%
	Do

		'�ē����b�Z�[�W�̕ҏW
		Select Case lngStatus

			Case -2
%>
				<FONT SIZE="6">�o�[�R�[�h��񂪑��݂��܂���B<BR>�ēx�o�[�R�[�h��ǂݍ��܂��Ă��������B</FONT>
<%
			Case -3
%>
				<FONT SIZE="6">�o�[�R�[�h��񂪊Ԉ���Ă��܂��B<BR>�ēx�o�[�R�[�h��ǂݍ��܂��Ă��������B</FONT>
<%
			Case -4
%>
				<FONT SIZE="6">�o�[�R�[�h�̎�f�����F���ł��܂���B<BR>�ēx�o�[�R�[�h��ǂݍ��܂��Ă��������B</FONT>
<%
			Case -5
%>
				<FONT SIZE="6">�o�[�R�[�h�̋敪���Ԉ���Ă��܂��B<BR>�ēx�o�[�R�[�h��ǂݍ��܂��Ă��������B</FONT>
<%
			Case -10
%>
				<FONT SIZE="6">�ėp�e�[�u�����ɊY���f�[�^�����݂��܂���B<BR>�V�X�e���S���҂ɘA�����Ă��������B</FONT>
<%
			Case -20
%>
				<FONT SIZE="6">��f��񂪑��݂��܂���B</FONT>
<%
			Case -30
%>
				<FONT SIZE="6">���̎�f�҂͎B�e�ΏۂɂȂ��Ă��܂���B</FONT>
<%
			Case -40
%>
				<FONT SIZE="6">�t�B�����ԍ��̍X�V�Ɏ��s���܂����B<BR>�V�X�e���S���҂ɘA�����Ă��������B</FONT>
<%
			Case -50
%>
				<FONT SIZE="6">�{�����Ԃ��ꂽ�ԍ��Əd�����܂����B<BR>�V�X�e���S���҂ɘA�����Ă��������B</FONT>
<%
			Case -60
%>
				<FONT SIZE="6">���ԉ\�ԍ��̍ő�ɒB���܂����B<BR>�V�X�e���S���҂ɘA�����Ă��������B</FONT>
<%
			Case 0
%>
				<FONT SIZE="6">�o�[�R�[�h��ǂݍ��܂��Ă��������B</FONT>
<%
			Case -15
%>
				<FONT SIZE="6">�������ڂ܂��̓T�t�B�b�N�X����`����Ă��܂���B�i�ėp�e�[�u���j</FONT>
<%
			Case Else

				'��f���ǂݍ���
				objConsult.SelectConsult lngRsvNo, ,   _
										 strCslDate,   _
										 strPerId,     _
										 strCsCd,      _
										 strCsName, , , , , , _
										 strAge, , , , , , , , , , , , , _
										 strDayId, , , , , , _
										 strOrgSName , , , , , , , , , , , _
										 strUpdDate,    _
										 strLastName,   _
										 strFirstName,  _
										 strLastKName,  _
										 strFirstKName, _
										 strBirth,      _
										 strGender

				If lngStatus = -35 Then
%>
					<FONT SIZE="5" COLOR="RED">�t�B�����ԍ��F<%= IIf(strOldFilmNo <> "", strOldFilmNo, "�Ȃ�") %><BR>�B�e���F<%= IIf(strOldFilmDate <> "", strOldFilmDate, "�Ȃ�") %><BR>�œǍ��ݍς݂ł��B</FONT>
<%
				Else
%>
					<FONT SIZE="5"><%= strLastName %>�@<%= strFirstName %>�����<BR>�t�B�����ԍ��@<B><%= lngStatus %></B>�@�Ŕ��Ԃ��܂����B<BR></FONT>
<%
				End If

		End Select
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
			<TR>
				<TD NOWRAP>BarCode�F</TD>
				<TD WIDTH="100%"><INPUT TYPE="text" NAME="key" SIZE="30"></TD>
			</TR>
		</TABLE>

		<BR>
<%
		'�\������i���ԍς݂��������\���j
		If ( lngStatus <= 0 ) And ( lngStatus <> -35 )Then
			Exit Do
		End If
%>
		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
			<TR>
				<TD NOWRAP>
					<%= strPerId %>&nbsp;
				</TD>
				<TD NOWRAP COLSPAN="2">
					<B><%= strLastName %>&nbsp;<%= strFirstName %></B>�i<%= strLastKName %>&nbsp;<%= strFirstKName %>�j
				</TD>
			</TR>
			<TR>
				<TD></TD>
				<TD>
					<%= objCommon.FormatString(strBirth, "ge.m.d") %>��&nbsp;<%= strAge %>��&nbsp;<%= IIf(strGender = CStr(GENDER_MALE), "�j��", "����") %>
				</TD>
			</TR>
<%
			strBuffer = ""

			'��f�I�v�V�����Ǘ��������ƂɎ�f�T�u�R�[�X���擾
			lngCount = objConsult.SelectConsult_O_SubCourse(lngRsvNo, strSubCsName)

			'���R�[�h�����݂���ꍇ�͑S�T�u�R�[�X����Ǔ_�ŘA��
			If lngCount > 0 Then
				strBuffer = "&nbsp;�i" & Join(strSubCsName, "�A") & "&nbsp;������f�j"
			End If
%>
			<TR>
				<TD></TD>
				<TD NOWRAP><B><%= strCsName %></B><%= strBuffer %></TD>
				<TD NOWRAP><%= strOrgSName %></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
		</TABLE>
<%
		Exit Do
	Loop
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD NOWRAP><A HREF="JavaScript:callRevFilmNo(1)">���݂̔��ԏ����C��&nbsp;</A></TD>
		</TR>
		<TR><TD><BR></TD>
		</TR>
<%
			'�X�e�[�^�X���펞(���̏ꍇ��f��񂪓ǂ܂�Ă���)
			If ( lngStatus > 0 ) Or ( lngStatus = -35 ) Then

				'���ʓ��͉�ʂ�URL�ҏW
				strURL = "/webHains/contents/result/rslMain.asp"
				strURL = strURL & "?rsvNo="    & lngRsvNo
				strURL = strURL & "&cslYear="  & Year(CDate(strCslDate))
				strURL = strURL & "&cslMonth=" & Month(CDate(strCslDate))
				strURL = strURL & "&cslDay="   & Day(CDate(strCslDate))
				strURL = strURL & "&dayId="    & strDayId
				strURL = strURL & "&noPrevNext=1"
%>
		<TR>
				<TD NOWRAP><A HREF="<%= strURL %>" TARGET="_blank">���ʓ��͉�ʂցi�t�B�����ԍ��C���j</A></TD>
		</TR>
<%
			End IF
%>
	</TABLE>
	<BR>
</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
