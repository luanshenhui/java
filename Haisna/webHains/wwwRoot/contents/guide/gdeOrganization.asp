<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�c�̌����K�C�h (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_BSD  = "1"	'�������[�h(���ƕ�)
Const MODE_ROOM = "2"	'�������[�h(����)
Const MODE_POST = "3"	'�������[�h(����)
Const STARTPOS  = 1		'�J�n�ʒu�̃f�t�H���g�l
Const GETCOUNT  = 20	'�\�������̃f�t�H���g�l

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objOrganization	'�c�̏��A�N�Z�X�p

'�����l
Dim strMode			'�������[�h(���w��F�c�̂̂݁A"1":���ƕ��J�ځA"2":�����J�ځA"3":�����J��)
Dim lngDispMode		'�\�����[�h(0:�R�����g�\���A1:�Z���\��)
Dim strKey			'�����L�[
Dim strDelFlg		'�폜�t���O
Dim lngAddrDiv		'�Z���敪
Dim lngStartPos		'�����J�n�ʒu
Dim lngGetCount		'�\������

'�c�̏��
Dim strArrOrgCd1	'�c�̃R�[�h�P
Dim strArrOrgCd2	'�c�̃R�[�h�Q
Dim strOrgSName		'����
Dim strNotes		'���L����
Dim strPrefName		'�s���{����
Dim strCityName		'�s�撬����
Dim strAddress1		'�Z���P
Dim strDispOrgCd1	'�ҏW�p�̒c�̃R�[�h�P
Dim strDispOrgCd2	'�ҏW�p�̒c�̃R�[�h�Q
Dim strDispOrgName	'�ҏW�p�̊�������

'�Œ�c�̃R�[�h
Dim strPerOrgCd1	'�l��f�p�c�̃R�[�h�P
Dim strPerOrgCd2	'�l��f�p�c�̃R�[�h�Q

Dim strArrKey		'(�������)�����L�[�̏W��
Dim lngCount		'���R�[�h����
Dim blnDelFlg(3)	'�폜�t���O�̃`�F�b�N���
Dim strURL			'URL������
Dim strBuffer		'������o�b�t�@
Dim i, j			'�C���f�b�N�X

Dim strCnvKey		'�L�[�ϊ��l

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strMode     = Request("mode")
lngDispMode = CLng("0" & Request("dispMode"))
strKey      = Request("key")
strDelFlg   = ConvIStringToArray(Request("delFlg"))
lngAddrDiv  = CLng("0" & Request("addrDiv"))
lngStartPos = Request("startPos")
lngGetCount = Request("getCount")

'�����ȗ����̃f�t�H���g�l�ݒ�
lngStartPos = CLng(IIf(lngStartPos = "", STARTPOS, lngStartPos))
lngGetCount = CLng(IIf(lngGetCount = "", GETCOUNT, lngGetCount))
lngAddrDiv  = IIf(lngAddrDiv = 0, 1, lngAddrDiv)

'### �g�p��ԋ敪�̕ύX�ɂ��C�� 2005.04.02 ��
'�g�p��Ԃ̃f�t�H���g�l�́u�g�p���v
'�ˁ@�g�p��Ԃ̃f�t�H���g�l�́u�g�p���@�v�u�g�p���A�v�����`�F�b�N�����悤�ɏC��
If IsEmpty(Request("act")) Then
    strDelFlg = Array("0","2")
End If
'If IsEmpty(Request("act")) Then
'    strDelFlg = Array("0")
'End If

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�c�̂̌���</TITLE>
<style type="text/css">
	body { margin: 10px 10px 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.key.focus()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
	<TR>
		<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="hainsdef">��</SPAN><FONT COLOR="#000000">�c�̂̌���</FONT></B></TD>
	</TR>
</TABLE>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" STYLE="margin: 0px;">
	<INPUT TYPE="hidden" NAME="act"      VALUE="1">
	<INPUT TYPE="hidden" NAME="mode"     VALUE="<%= strMode     %>">
	<INPUT TYPE="hidden" NAME="dispMode" VALUE="<%= lngDispMode %>">
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="100%">
		<TR>
			<TD HEIGHT="25" COLSPAN="4">�c�̃R�[�h�������͒c�̖��̂���͂��ĉ������B</TD>
		</TR>
		<TR>
			<TD NOWRAP>��������</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>" STYLE="ime-mode:active;"></TD>
			<TD><INPUT TYPE="image" NAME="search" SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="���̏����Ō���"></TD>
<%
			'�l��f�p�c�̃R�[�h�̎擾
			Set objCommon = Server.CreateObject("HainsCommon.Common")
			objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
			Set objCommon = Nothing

			'�l�I������URL��ҏW
			strURL = "gdeSelectOrg.asp"
			strURL = strURL & "?orgCd1="  & strPerOrgCd1
			strURL = strURL & "&orgCd2="  & strPerOrgCd2
			strURL = strURL & "&addrDiv=" & lngAddrDiv
%>
			<TD WIDTH="100%" ALIGN="right"><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/perconsult.gif" WIDTH="77" HEIGHT="24" ALT="�l�Ŏ�f����ꍇ�ɑI�����܂�"></A></TD>
		</TR>
		<TR>
			<TD NOWRAP>�g�p���</TD>
			<TD>�F</TD>
<%
			'�폜�t���O�̃`�F�b�N��Ԃ��擾
			If IsArray(strDelFlg) Then
				For i = 0 To UBound(strDelFlg)
					blnDelFlg(CLng(strDelFlg(i))) = True
				Next
			End If
%>
			<TD COLSPAN="3">
                <!--### �c�̎g�p��ԕύX�ɂ��C�� 2005.04.02 Start �� ###-->
				<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="0"<%= IIf(blnDelFlg(0), " CHECKED", "") %>></TD>
						<TD NOWRAP>�g�p���@</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="2"<%= IIf(blnDelFlg(2), " CHECKED", "") %>></TD>
						<TD NOWRAP>�g�p���A</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="3"<%= IIf(blnDelFlg(3), " CHECKED", "") %>></TD>
						<TD NOWRAP>�������g�p</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="1"<%= IIf(blnDelFlg(1), " CHECKED", "") %>></TD>
						<TD NOWRAP>���g�p</TD>
					</TR>
				</TABLE>

                <!--TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
					<TR>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="0"<%= IIf(blnDelFlg(0), " CHECKED", "") %>></TD>
						<TD NOWRAP>�g�p��</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="2"<%= IIf(blnDelFlg(2), " CHECKED", "") %>></TD>
						<TD NOWRAP>�_��葱��</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="3"<%= IIf(blnDelFlg(3), " CHECKED", "") %>></TD>
						<TD NOWRAP>�������g�p</TD>
						<TD><INPUT TYPE="checkbox" NAME="delFlg" VALUE="1"<%= IIf(blnDelFlg(1), " CHECKED", "") %>></TD>
						<TD NOWRAP>���g�p</TD>
					</TR>
				</TABLE-->
                <!--### �c�̎g�p��ԕύX�ɂ��C�� 2005.04.02 End   �� ###-->
			</TD>
		</TR>
<%
		If lngDispMode = 1 Then
%>
			<TR>
				<TD>�Z��</TD>
				<TD>�F</TD>
				<TD COLSPAN="3">
					<SELECT NAME="addrDiv">
						<OPTION VALUE="1"<%= IIf(lngAddrDiv = 1, " SELECTED", "") %>>�Z���P
						<OPTION VALUE="2"<%= IIf(lngAddrDiv = 2, " SELECTED", "") %>>�Z���Q
						<OPTION VALUE="3"<%= IIf(lngAddrDiv = 3, " SELECTED", "") %>>�Z���R
					</SELECT>
				</TD>
			</TR>
<%
		End If
%>
	</TABLE>
</FORM>
<BR>
<%
Do

	'�����{�^���������ȊO�͉������Ȃ�
	If Request("act") = "" Then
		Exit Do
	End If

	'�����L�[���폜�t���O���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
	If strKey = "" And IsEmpty(strDelFlg) Then
		Exit Do
	End If

	'�����L�[���󔒂ŕ�������
	strArrKey = SplitByBlank(strKey)

	'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
	lngCount = objOrganization.SelectOrgList(strArrKey, lngStartPos, lngGetCount, strArrOrgCd1, strArrOrgCd2, , strOrgSName, , , , , , strDelFlg, lngAddrDiv, strNotes, strPrefName, strCityName, strAddress1)

	'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
	If lngCount = 0 Then
%>
		���������𖞂����c�̏��͑��݂��܂���B<BR>
		�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
		Exit Do
	End If

	'���R�[�h��������ҏW
	If strKey <> "" Then
%>
		�u<FONT COLOR="#ff6600"><B><%= strKey %></B></FONT>�v�̌������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>������܂����B<BR><BR>
<%
	Else
%>
		�������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>������܂����B<BR><BR>
<%
	End If

	'�c�̈ꗗ�̕ҏW�J�n
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>�c�̃R�[�h</TD>
			<TD WIDTH="10"></TD>
			<TD NOWRAP>�c�̖���</TD>
			<TD WIDTH="10"></TD>
			<TD WIDTH="400" NOWRAP><%= IIf(lngDispMode = 0, "�R�����g", "�Z��") %></TD>
			<TD WIDTH="10"></TD>
			<TD></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD BGCOLOR="#999999" COLSPAN="5"></TD>
		</TR>
		<TR>
			<TD HEIGHT="2"></TD>
		</TR>
<%
		For i = 0 To UBound(strArrOrgCd1)

			'�c�̏��̎擾
			strDispOrgCd1  = strArrOrgCd1(i)
			strDispOrgCd2  = strArrOrgCd2(i)
			strDispOrgName = strOrgSName(i)

			'�����L�[�ɍ��v���镔����<B>�^�O��t��
			If Not IsEmpty(strArrKey) Then

				For j = 0 To UBound(strArrKey)

					If Instr(strDispOrgCd1, strArrKey(j)) = 1 Then
						strDispOrgCd1 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd1, Len(strDispOrgCd1) - Len(strArrKey(j)))
					End If

					If Instr(strDispOrgCd2, strArrKey(j)) = 1 Then
						strDispOrgCd2 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd2, Len(strDispOrgCd2) - Len(strArrKey(j)))
					End If

					strDispOrgName = Replace(strDispOrgName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")

					'�������J�i��ϊ������p�^�[��
					strCnvKey = strArrKey(j)
					strCnvKey = Replace(strCnvKey, "�@", "�A")
					strCnvKey = Replace(strCnvKey, "�B", "�C")
					strCnvKey = Replace(strCnvKey, "�D", "�E")
					strCnvKey = Replace(strCnvKey, "�F", "�G")
					strCnvKey = Replace(strCnvKey, "�H", "�I")
					strCnvKey = Replace(strCnvKey, "�b", "�c")
					strCnvKey = Replace(strCnvKey, "��", "��")
					strCnvKey = Replace(strCnvKey, "��", "��")
					strCnvKey = Replace(strCnvKey, "��", "��")

					'�ϊ���̒l�����̒l�ƈقȂ�ꍇ�͍X�ɒu������
					If strCnvKey <> strArrKey(j) Then
						strDispOrgName = Replace(strDispOrgName, strCnvKey, "<B>" & strCnvKey & "</B>")
					End If

				Next


			End If

			'�c�̑I������URL��ҏW
			strURL = "gdeSelectOrg.asp"
			strURL = strURL & "?orgCd1="  & strArrOrgCd1(i)
			strURL = strURL & "&orgCd2="  & strArrOrgCd2(i)
			strURL = strURL & "&addrDiv=" & lngAddrDiv

			'�c�̏��̕ҏW
%>
			<TR VALIGN="top">
				<TD></TD>
				<TD NOWRAP><%= strDispOrgCd1 %>-<%= strDispOrgCd2 %></TD>
				<TD></TD>
				<TD NOWRAP><A HREF="<%= strURL %>"><%= strDispOrgName %></A></TD>
				<TD></TD>
				<TD WIDTH="400"><%= IIf(lngDispMode = 0, strNotes(i), strPrefName(i) & strCityName(i) & strAddress1(i)) %></TD>
<%
				'�c�̈ȉ�����������ꍇ�A�����{�^����ҏW
				If strMode = MODE_BSD Or strMode = MODE_ROOM Or strMode = MODE_POST Then

					'�������[�h�ɑΉ������URL�̕ҏW
					Select Case strMode
						Case MODE_BSD
							strURL = "gdeOrgBusinessDiv.asp"
							strBuffer = "���ƕ�"
						Case MODE_ROOM
							strURL = "gdeOrgRoom.asp"
							strBuffer = "����"
						Case MODE_POST
							strURL = "gdeOrgPost.asp"
							strBuffer = "����"
					End Select

					'�����̒ǉ�
					strURL = strURL & "?orgCd1=" & strArrOrgCd1(i)
					strURL = strURL & "&orgCd2=" & strArrOrgCd2(i)
%>
					<TD></TD>
					<TD><A HREF="<%= strURL %>"><IMG SRC="/webHains/images/cue.gif" WIDTH="14" HEIGHT="14" ALT="���̒c�̂̑S<%= strBuffer %>������"></A></TD>
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
	strURL = strURL & "?act="      & "1"
	strURL = strURL & "&mode="     & strMode
	strURL = strURL & "&dispMode=" & lngDispMode
	strURL = strURL & "&key="      & Server.URLEncode(strKey)

	'�폜�t���O�̃`�F�b�N��Ԃ����Ƃ�URL��ҏW
	If IsArray(strDelFlg) Then
		For i = 0 To UBound(strDelFlg)
			strURL = strURL & "&delFlg=" & strDelFlg(i)
		Next
	End If

	strURL = strURL & "&addrDiv=" & lngAddrDiv
%>
	<%= EditPageNavi(strURL, lngCount, lngStartPos, lngGetCount) %>
<%
	Exit Do
Loop
%>
</BODY>
</HTML>
