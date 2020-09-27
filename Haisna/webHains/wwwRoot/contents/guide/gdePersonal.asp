<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�l�����K�C�h (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"    -->
<!-- #include virtual = "/webHains/includes/common.inc"          -->
<!-- #include virtual = "/webHains/includes/EditEraYearList.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc"    -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const STARTPOS     = 1		'�J�n�ʒu�̃f�t�H���g�l
Const GETCOUNT     = 15		'�\�������̃f�t�H���g�l
Const PREFIX_PERID = "ID:"	'�������̌l�h�c�w��

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objPerson			'�l���A�N�Z�X�p

'�����l
Dim strKey				'�����L�[
'#### 2011.01.22 ADD STA TCS)Y.T ####
Dim strKey1				'�����L�[
Dim strKey2				'�����L�[
Dim strKey3				'�����L�[
'#### 2011.01.22 ADD END TCS)Y.T ####
Dim strBirthYear		'���N�����i�N�j
Dim strBirthMonth		'���N�����i���j
Dim strBirthDay			'���N�����i���j
Dim lngGender			'����
Dim lngAddrDiv			'�Z���敪
Dim blnRomeMulti		'���[�}�������������s����
Dim lngMode				'�������[�h(0:�ʏ�A1:�X�Ɏ�f�������֑J�ډ\)
Dim lngStartPos			'�����J�n�ʒu
Dim lngGetCount			'�\������
Dim strDefPerId			'�����\���p�l�h�c
Dim strDefGender		'�����\���p����

'�l���
Dim strPerId			'�l�h�c
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strRomeName			'���[�}����
Dim strArrBirth			'���N����
Dim strAge				'�N��
Dim strGender			'����
Dim strPrefName			'�s���{����
Dim strCityName			'�s�撬����
Dim strAddress1			'�Z���P
Dim strAddress2			'�Z���Q
Dim strTel1				'�d�b�ԍ�
Dim lngCount			'���R�[�h����

Dim strArrKey			'(�������)�����L�[�̏W��
Dim strBirth			'���N����
Dim lngAllCount			'�����𖞂����S���R�[�h����
Dim strDispPerId		'�ҏW�p�̌l�h�c
Dim strDispLastName		'�ҏW�p�̊�������
Dim strDispFirstName	'�ҏW�p�̊�������
Dim strDispName			'�ҏW�p�̊�������
Dim strDispLastKName	'�ҏW�p�̃J�i����
Dim strDispFirstKName	'�ҏW�p�̃J�i����
Dim strDispKName		'�ҏW�p�̃J�i����
Dim strCnvKey			'�L�[�ϊ��l
Dim strBuffer			'������o�b�t�@
Dim strURL				'URL������
Dim i, j				'�C���f�b�N�X
Dim strDispRomeName		'���[�}����
Dim lngPos				'�����ʒu
Dim strEditAge			'�N��

Dim strRepStr1			'�u���p������P
Dim strRepStr2			'�u���p������Q
Dim strRepPerId			'�u���p�l�h�c
Dim lngCnvMode			'�u�����[�h

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objPerson = Server.CreateObject("HainsPerson.Person")

'�����l�̎擾
strKey        = Request("key")
strBirthYear  = Request("birthYear")
strBirthMonth = Request("birthMonth")
strBirthDay   = Request("birthDay")
lngGender     = CLng("0" & Request("gender"))
blnRomeMulti  = (Request("romeMulti") <> "")
lngAddrDiv    = Request("addrDiv")
lngMode       = CLng("0" & Request("mode"))
lngStartPos   = Request("startPos")
lngGetCount   = Request("getCount")
strDefPerId   = Request("defPerId")
strDefGender  = Request("defGender")

'�����L�[���̔��p�J�i��S�p�J�i�ɕϊ�����
strKey = objCommon.StrConvKanaWide(strKey)

'�����L�[���̏�������啶���ɕϊ�����
strKey = UCase(strKey)

'�S�p�󔒂𔼊p�󔒂ɒu������
strKey = Replace(Trim(strKey), "�@", " ")

'2�o�C�g�ȏ�̔��p�󔒕��������݂��Ȃ��Ȃ�܂Œu�����J��Ԃ�
Do Until InStr(1, strKey, "  ") = 0
    strKey = Replace(strKey, "  ", " ")
Loop

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))
lngAddrDiv  = IIf(lngAddrDiv = 0, 1, lngAddrDiv)

'�L�[�Ȃ��A���f�t�H�l�h�c���ݎ��A���̃��[�}�������Z�b�g
If strKey = "" And strDefPerId <> "" Then
'#### 2011.01.22 MOD STA TCS)Y.T ####
'	objPerson.SelectPerson_lukes strDefPerId, , , , , strKey
        '���[�}��������J�i�����ɕύX
	objPerson.SelectPerson_lukes strDefPerId, , , strKey1, strKey2, strKey3
        If strKey1 <> "" Or strKey2 <> "" Then
                '�J�i����������ꍇ�͐��Ɩ���A�����Đݒ肷��
                strKey = strKey1 & " " & strKey2
	Else
                '�J�i���������݂��Ȃ��ꍇ�̓��[�}����ݒ肷��B
                strKey = strKey3
        End If
'#### 2011.01.22 MOD END TCS)Y.T ####
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>��f�҂̌���</TITLE>
<style type="text/css">
	body { margin: 15px 0 0 15px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:window.document.entryForm.key.focus();">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">��f�҂̌���</FONT></B></TD>
		</TR>
	</TABLE>
	<INPUT TYPE="hidden" NAME="mode" VALUE="<%= lngMode %>">
<% '## 2003.12.15 Add by T.Takagi@FSIT ���ʌŒ� %>
	<INPUT TYPE="hidden" NAME="defGender" VALUE="<%= strDefGender %>">
<% '## 2003.12.15 Add End %>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>��������</TD>
			<TD>�F</TD>
			<TD COLSPAN="9"><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD ROWSPAN="2" VALIGN="bottom"><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></TD>
		</TR>
		<TR>
			<TD NOWRAP>���N����</TD>
			<TD>�F</TD>
			<TD><%= EditEraYearList("birthYear", strBirthYear, True) %></TD>
			<TD>�N</TD>
			<TD><%= EditSelectNumberList("birthMonth", 1, 12, CLng("0" & strBirthMonth)) %></TD>
			<TD>��</TD>
			<TD><%= EditSelectNumberList("birthDay", 1, 31, CLng("0" & strBirthDay)) %></TD>
			<TD>��</TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
			<TD NOWRAP>���ʁF</TD>
<% '## 2003.12.15 Mod by T.Takagi@FSIT ���ʌŒ� %>
<%
			If strDefGender = "" Then
%>
				<TD>
					<SELECT NAME="gender">
						<OPTION VALUE="0">&nbsp;
						<OPTION VALUE="<%= GENDER_MALE   %>"<%= IIf(lngGender = GENDER_MALE,   " SELECTED", "") %>>�j��
						<OPTION VALUE="<%= GENDER_FEMALE %>"<%= IIf(lngGender = GENDER_FEMALE, " SELECTED", "") %>>����
					</SELECT>
				</TD>
<%
			Else
%>
				<TD NOWRAP><INPUT TYPE="hidden" NAME="gender" VALUE="<%= strDefGender %>"><%= IIf(strDefGender = CStr(GENDER_MALE), "�j��", "����") %></TD>
<%
			End If
%>
<% '## 2003.12.15 Add End %>
		</TR>
		<TR>
			<TD NOWRAP>�Z��</TD>
			<TD>�F</TD>
			<TD>
				<SELECT NAME="addrDiv">
					<OPTION VALUE="1"<%= IIf(lngAddrDiv = 1, " SELECTED", "") %>>�Z���i����j
					<OPTION VALUE="2"<%= IIf(lngAddrDiv = 2, " SELECTED", "") %>>�Z���i�Ζ���j
					<OPTION VALUE="3"<%= IIf(lngAddrDiv = 3, " SELECTED", "") %>>�Z���i���̑��j
				</SELECT>
			</TD>
			<TD><INPUT TYPE="checkbox" NAME="romeMulti" VALUE="1"<%= IIf(blnRomeMulti, " CHECKED", "") %>></TD>
			<TD COLSPAN="7" NOWRAP>���[�}���̕����������s��</TD>
		</TR>
	</TABLE>
<%
	Do
		'�������������݂��Ȃ��ꍇ�͉������Ȃ�
'## 2003.11.21 Mod by T.Takagi@FSIT ���ʂ݂̂̌����������Ȃ�
'		If strKey = "" And strBirthYear = "" And strBirthMonth = "" And strBirthDay = "" And lngGender = 0 Then
		If strKey = "" And strBirthYear = "" And strBirthMonth = "" And strBirthDay = "" Then
'## 2003.11.21 Mod End
			Exit Do
		End If

		'���N�����w�莞
		If strBirthYear <> "" Or strBirthMonth <> "" Or strBirthDay <> "" Then

			'���N�����̕ҏW
			strBirth = strBirthYear & "/" & strBirthMonth & "/" & strBirthDay

			'���N�����̓��t�`�F�b�N
			If Not IsDate(strBirth) Then
				Response.Write "<BR>���N�����̓��͌`��������������܂���B"
				Exit Do
			End If

		End If

		'���������𖞂������R�[�h�������擾
		lngAllCount = objPerson.SelectPersonListCount(strKey, strBirth, lngGender, blnRomeMulti)
%>
		<BR>
<%
		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngAllCount = 0 Then
%>
			���������𖞂����l���͑��݂��܂���B<BR>
			�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
			Exit Do
		End If

		'���R�[�h��������ҏW
%>
		�������ʂ� <FONT COLOR="#ff6600"><B><%= lngAllCount %></B></FONT>������܂����B<BR><BR>
<%
		'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
		lngCount = objPerson.SelectPersonList(strKey,       lngAddrDiv,  lngStartPos,  lngGetCount,  strBirth,      lngGender, blnRomeMulti, , _
											  strPerId, ,   strLastName, strFirstName, strLastKName, strFirstKName, strRomeName, _
											  strArrBirth,  strAge,      strGender, ,  strPrefName,  strCityName,   strAddress1, _
											  strAddress2,  strTel1)
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>�l�h�c</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>����</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>���[�}��</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>���N����</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>����</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>�N��</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>�d�b�ԍ�</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>�Z��</TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD></TD>
			</TR>
			<TR>
				<TD></TD>
				<TD BGCOLOR="#999999" COLSPAN="19"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1" ALT=""></TD>
			</TR>
<%
			'����u�����邩����
			Select Case True
				Case objPerson.IsWide(strKey)
					lngCnvMode = 0
				Case objPerson.IsPerId(strKey)
					lngCnvMode = 1
				Case Else
					lngCnvMode = 2
			End Select

			For i = 0 To lngCount - 1

				'�\���p�l���̂̕ҏW
				strDispPerId      = strPerID(i)
				strDispLastName   = strLastName(i)
				strDispFirstName  = strFirstName(i)
				strDispLastKName  = strLastKName(i)
				strDispFirstKName = strFirstKName(i)
				strDispRomeName   = strRomeName(i)

				Do

					'�P�ڂ̋󔒂������B������Ȃ��ꍇ�͐��̂݁B
					lngPos = InStr(1, strKey, " ")
					If lngPos <= 0 Then
						strRepStr1 = Trim(strKey)
						strRepStr2 = ""
						Exit Do
					End If

					'�P�ڂ̋󔒈ȍ~�̕�����������擾�B�Ȃ���Ε����������s��Ȃ��ꍇ�Ɠ���
					strBuffer = Trim(Right(strKey, Len(strKey) - lngPos))
					If strBuffer = "" Then
						strRepStr1 = Trim(strKey)
						strRepStr2 = ""
						Exit Do
					End If

					'�����ɕ���
					strRepStr1 = Trim(Left(strKey, lngPos - 1))
					strRepStr2 = strBuffer

					Exit Do
				Loop

				'�����L�[�ɍ��v���镔����<B>�^�O��t��

				'�l�h�c
				If lngCnvMode = 1 Then

					'�擪�R������"ID:"�ł���ꍇ�͐擪������菜�����������lID�Ƃ��Ď擾�A����ȊO�͈����l�����̂܂܎g�p
					If UCase(Left(strKey, Len(PREFIX_PERID))) = PREFIX_PERID Then
						strRepPerId = Right(strKey, Len(strKey) - Len(PREFIX_PERID))
					Else
						strRepPerId = strKey
					End If

					'������̖�����"*"�Ȃ�J�b�g
					If Right(strRepPerId, 1) = "*" Then
						strRepPerId = Left(strRepPerId, Len(strRepPerId) - 1)
					End If

					strDispPerId = Replace(strDispPerId, strRepPerId, "<B>" & strRepPerId & "</B>", 1, 1)

				End If

				'���[�}����
				If lngCnvMode = 2 Then

					lngPos = InStr(1, strDispRomeName, " ", 1)

					If strRepStr2 <> "" And lngPos > 0 Then
						strDispRomeName = Left(strDispRomeName, lngPos) & Replace(strDispRomeName, strRepStr2, "<FONT COLOR=""#ff6600""><B>" & strRepStr2 & "</B></FONT>", lngPos + 1, 1, 1)
					End If

					strDispRomeName = Replace(strDispRomeName, strRepStr1, "<FONT COLOR=""#ff6600""><B>" & strRepStr1 & "</B></FONT>", 1, 1)

				End If

				'����
				If lngCnvMode = 0 Then

					If InStr(1, strDispLastName, strRepStr1, 1) = 1 Then
						strDispLastName   = Replace(strDispLastName,   strRepStr1, "<B>" & strRepStr1 & "</B>", 1, 1, 1)
					End If

					If InStr(1, strDispFirstName, strRepStr2, 1) = 1 Then
						strDispFirstName  = Replace(strDispFirstName,  strRepStr2, "<B>" & strRepStr2 & "</B>", 1, 1, 1)
					End If

					If InStr(1, strDispLastKName, strRepStr1, 1) = 1 Then
						strDispLastKName  = Replace(strDispLastKName,  strRepStr1, "<B>" & strRepStr1 & "</B>", 1, 1, 1)
					End If

					If InStr(1, strDispFirstKName, strRepStr2, 1) = 1 Then
						strDispFirstKName = Replace(strDispFirstKName, strRepStr2, "<B>" & strRepStr2 & "</B>", 1, 1, 1)
					End If

				End If

				strDispName  = Trim(strDispLastName  & "�@" & strDispFirstName)
				strDispKName = Trim(strDispLastKName & "�@" & strDispFirstKName)

				'�l�I������URL��ҏW
				strURL = "gdeSelectPerson.asp?perId=" & strPerId(i)

				If strAge(i) <> "" Then
					strEditAge = Int(strAge(i)) & "��"
				Else
					strEditAge = ""
				End If

				'�l���̕ҏW
%>
				<TR VALIGN="bottom">
					<TD></TD>
					<TD NOWRAP><%= strDispPerId %></TD>
					<TD></TD>
					<TD NOWRAP><SPAN STYLE="font-size:9px;"><%= strDispKName %><BR></SPAN><A HREF="<%= strURL %>"><%= strDispName %></A></TD>
					<TD></TD>
					<TD NOWRAP><%= strDispRomeName %></TD>
					<TD></TD>
					<TD ALIGN="right" NOWRAP><%= objCommon.FormatString(strArrBirth(i), "gee.mm.dd") %></TD>
					<TD></TD>
					<TD NOWRAP><%= IIf(strGender(i) = CStr(GENDER_MALE), "�j��", "����") %></TD>
					<TD></TD>
					<TD ALIGN="right" NOWRAP><%= strEditAge %></TD>
					<TD></TD>
					<TD NOWRAP><%= strTel1(i) %></TD>
					<TD></TD>
					<TD NOWRAP><%= strPrefName(i) & strCityName(i) & strAddress1(i) & strAddress2(i) %></TD>
<%
					'�X�Ɏ�f�������֑J�ډ\�ȏꍇ
					If lngMode = 1 Then

						'��f���ꗗ�p��URL��ҏW
						strURL = "gdeCslList.asp?perId=" & strPerId(i)
%>
						<TD></TD>
						<TD><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/cue.gif" WIDTH="14" HEIGHT="14" ALT="���̌l�̎�f�����������܂�"></A></TD>
<%
					End If
%>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		'�y�[�W���O�i�r�Q�[�^�̕ҏW
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?key="        & Server.URLEncode(strKey)
		strURL = strURL & "&birthYear="  & strBirthYear
		strURL = strURL & "&birthMonth=" & strBirthMonth
		strURL = strURL & "&birthDay="   & strBirthDay
		strURL = strURL & "&gender="     & lngGender
		strURL = strURL & "&addrDiv="    & lngAddrDiv
		strURL = strURL & "&mode="       & lngMode
		strURL = strURL & "&romeMulti="  & IIf(blnRomeMulti, "1", "")
'## 2005.03.16 Add by T.Takagi@FSIT �i�r�Q�[�^���N���b�N����ƌŒ�������O���
		strURL = strURL & "&defPerId="   & strDefPerId
		strURL = strURL & "&defGender="  & strDefGender
'## 2005.03.16 Add End
%>
		<%= EditPageNavi(strURL, lngAllCount, lngStartPos, lngGetCount) %>
<%
		Exit Do
	Loop
%>
</FORM>
</BODY>
</HTML>
