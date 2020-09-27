<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(�Q�Ɛ�_��c�̂̌���) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditPageNavi.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const OPMODE_BROWSE  = "browse"	'�������[�h(����)
Const OPMODE_COPY    = "copy"	'�������[�h(�R�s�[)
Const GETCOUNT       = 20		'�\�������̃f�t�H���g�l

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l(�Q�ƁE�R�s�[����)
Dim strOpMode			'�������[�h
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strCsCd				'�R�[�X�R�[�h

'�O��ʂ��瑗�M�����p�����[�^�l(�R�s�[���̂�)
Dim strStrYear			'�_��J�n�N
Dim strStrMonth 		'�_��J�n��
Dim strStrDay			'�_��J�n��
Dim strEndYear			'�_��I���N
Dim strEndMonth 		'�_��I����
Dim strEndDay			'�_��I����

'���g�����_�C���N�g����ꍇ�̂ݑ��M�����p�����[�^�l
Dim strKey				'�����L�[
Dim lngStartPos			'�����J�n�ʒu
Dim lngGetCount			'�\������

'�_��Ǘ����
Dim strOrgName			'�c�̖�
Dim strCsName			'�R�[�X��
Dim dtmStrDate			'�_��J�n��
Dim dtmEndDate			'�_��I����
Dim strStrDate			'�ҏW�p�̌_��J�n��
Dim strEndDate			'�ҏW�p�̌_��I����

'�������
Dim strRefOrgCd1		'�Q�Ɛ�c�̃R�[�h1
Dim strRefOrgCd2		'�Q�Ɛ�c�̃R�[�h2
Dim strRefOrgName		'�Q�Ɛ�c�̖���
Dim strRefOrgSName		'�Q�Ɛ旪��
Dim strRefOrgKanaName	'�Q�Ɛ�c�̃J�i����

'�Œ�c�̃R�[�h
Dim strPerOrgCd1		'�l��f�p�c�̃R�[�h1
Dim strPerOrgCd2		'�l��f�p�c�̃R�[�h2
Dim strWebOrgCd1		'Web�p�c�̃R�[�h1
Dim strWebOrgCd2		'Web�p�c�̃R�[�h2

Dim strArrKey			'(�������)�����L�[�̏W��
Dim lngCount			'���R�[�h����
Dim strDispOrgCd1		'�ҏW�p�̒c�̃R�[�h1
Dim strDispOrgCd2		'�ҏW�p�̒c�̃R�[�h2
Dim strDispOrgName		'�ҏW�p�̊�������
Dim strDispOrgKanaName	'�ҏW�p�̃J�i����
Dim strQueryString		'QUERY������
Dim strURL				'URL������
Dim blnAnchor			'�A���J�[�̗v��
Dim i, j				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objCourse       = Server.CreateObject("HainsCourse.Course")

'�O��ʂ��瑗�M�����p�����[�^�l�̎擾
strOpMode = Request("opMode")
strOrgCd1 = Request("orgCd1")
strOrgCd2 = Request("orgCd2")
strCsCd   = Request("csCd")

'�O��ʂ��瑗�M�����p�����[�^�l�̎擾(�R�s�[���̂�)
strStrYear  = Request("strYear")
strStrMonth = Request("strMonth")
strStrDay   = Request("strDay")
strEndYear  = Request("endYear")
strEndMonth = Request("endMonth")
strEndDay   = Request("endDay")

'���g�����_�C���N�g����ꍇ�̂ݑ��M�����p�����[�^�l�̎擾
strKey      = Request("key")
lngStartPos = CLng("0" & Request("startPos"))
lngGetCount = CLng("0" & Request("getCount"))

'�l��f�Aweb�p�c�̃R�[�h�̎擾
objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
objCommon.GetOrgCd ORGCD_KEY_WEB,    strWebOrgCd1, strWebOrgCd2

'�����J�n�ʒu���w�莞�͐擪���猟������
If lngStartPos = 0 Then
	lngStartPos = 1
End If

'�\���������w�莞�̓f�t�H���g�l��K�p����
If lngGetCount = 0 Then
	lngGetCount = GETCOUNT
End If
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�Q�Ɛ�_��c�̂̌���</TITLE>
<STYLE TYPE="text/css">
td.mnttab  { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="opMode" VALUE="<%= strOpMode %>">
	<INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>">
	<INPUT TYPE="hidden" NAME="csCd"   VALUE="<%= strCsCd   %>">
<%
	'�������[�h�����ʂ̏ꍇ�͌_����Ԃ̒l��ێ�����
	If strOpMode = OPMODE_COPY Then
%>
		<INPUT TYPE="hidden" NAME="strYear"  VALUE="<%= strStrYear  %>">
		<INPUT TYPE="hidden" NAME="strMonth" VALUE="<%= strStrMonth %>">
		<INPUT TYPE="hidden" NAME="strDay"   VALUE="<%= strStrDay   %>">
		<INPUT TYPE="hidden" NAME="endYear"  VALUE="<%= strEndYear  %>">
		<INPUT TYPE="hidden" NAME="endMonth" VALUE="<%= strEndMonth %>">
		<INPUT TYPE="hidden" NAME="endDay"   VALUE="<%= strEndDay   %>">
<%
	End If
%>
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�Q�Ɛ�_��c�̂̌���</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>
<%
	'�c�̖��̓ǂݍ���
	If objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , strOrgName) = False Then
		Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
	End If

	'�R�[�X���̓ǂݍ���
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "�R�[�X��񂪑��݂��܂���B"
	End If
%>
	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD>�_��c��</TD>
			<TD>�F</TD>
			<TD><B><%= strOrgName %></B></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
<%
		'�������[�h�����ʂ̏ꍇ�͐�ɓ��͂����_����Ԃ�ҏW����
		If strOpMode = OPMODE_COPY Then

			'�_��J�n�N�����̎擾
			If strStrYear <> "" And strStrMonth <> "" And strStrDay <> "" Then
				dtmStrDate = CDate(strStrYear & "/" & strStrMonth & "/" & strStrDay)
			End If

			'�_��I���N�����̎擾
			If strEndYear <> "" And strEndMonth <> "" And strEndDay <> "" Then
				dtmEndDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)
			End If

			'�ҏW�p�̌_��J�n���ݒ�
			If dtmStrDate > 0 Then
				strStrDate = FormatDateTime(dtmStrDate, 1)
			End If

			'�ҏW�p�̌_��I�����ݒ�
			If dtmEndDate > 0 Then
				strEndDate = FormatDateTime(dtmEndDate, 1)
			End If
%>
			<TR>
				<TD HEIGHT="5"></TD>
			</TR>
			<TR>
				<TD>�_�����</TD>
				<TD>�F</TD>
				<TD><B><%= strStrDate %>�`<%= strEndDate %></B></TD>
			</TR>
<%
		End If
%>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD COLSPAN="2"><FONT COLOR="#cc9999">��</FONT>�c�̃R�[�h�������͒c�̖��̂���͂��ĉ������B<FONT COLOR="#666666">�i�ΏۃR�[�X�̌_��������c�݂̂̂��������܂��j</FONT></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD COLSPAN="2"><FONT COLOR="#cc9999">��</FONT>��ʒc�̂���l�EWeb�\��̌_������Q�Ƃ���A�܂����̋t�͍s�����Ƃ͂ł��܂���B</FONT></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><INPUT TYPE="text" NAME="key" SIZE="30" VALUE="<%= strKey %>"></TD>
			<TD WIDTH="100%"><INPUT TYPE="image" NAME="search" SRC="/webHains/images/b_search.gif" WIDTH="70" HEIGHT="24" ALT="���̏����Ō���"></TD>
		</TR>
	</TABLE>
<%
	Do

		'�����L�[���󔒂ŕ�������
		strArrKey = SplitByBlank(strKey)

		'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
		lngCount = objOrganization.SelectOrgList(strArrKey, lngStartPos, lngGetCount, strRefOrgCd1, strRefOrgCd2, strRefOrgName, strRefOrgSName, strRefOrgKanaName, strCsCd)
%>
		<BR><BR>
<%
		'�������ʂ����݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW
		If lngCount = 0 Then
%>
			���������𖞂����c�̏��͑��݂��܂���B<BR>
			�L�[���[�h�����炷�A�������͕ύX����Ȃǂ��āA�ēx�������Ă݂ĉ������B<BR>
<%
			Exit Do
		End If

		'Query������̕ҏW
		'(���̕�����͎Q�Ɛ�c�̑I�����A�y�[�W���O�i�r�Q�[�^�̗����Ŏg�p���邽�߁A�����ŕҏW���Ă���)
		strQueryString = "?opMode=" & strOpMode & "&orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2 & "&csCd=" & strCsCd

		'�������[�h�����ʂ̏ꍇ�͍X�Ɍ_����Ԃ�Query������Ƃ��ĕҏW����
		If strOpMode = OPMODE_COPY Then
			strQueryString = strQueryString & "&strYear=" & strStrYear & "&strMonth=" & strStrMonth & "&strDay=" & strStrDay & _
											  "&endYear=" & strEndYear & "&endMonth=" & strEndMonth & "&endDay=" & strEndDay
		End If
%>
		�������ʂ� <FONT COLOR="#ff6600"><B><%= lngCount %></B></FONT>������܂����B<BR><BR>
		<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
<%
			For i = 0 To UBound(strRefOrgCd1)

				'�c�̏��̎擾
				strDispOrgCd1      = strRefOrgCd1(i)
				strDispOrgCd2      = strRefOrgCd2(i)
				strDispOrgName     = strRefOrgName(i)
				strDispOrgKanaName = strRefOrgKanaName(i)

				'�����L�[�ɍ��v���镔����<B>�^�O��t��
				If Not IsEmpty(strArrKey) Then
					For j = 0 To UBound(strArrKey)
						If Instr(strDispOrgCd1, strArrKey(j)) = 1 Then
							strDispOrgCd1 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd1, Len(strDispOrgCd1) - Len(strArrKey(j)))
						End If
						If Instr(strDispOrgCd2, strArrKey(j)) = 1 Then
							strDispOrgCd2 = "<B>" & strArrKey(j) & "</B>" & Right(strDispOrgCd2, Len(strDispOrgCd2) - Len(strArrKey(j)))
						End If
						strDispOrgName     = Replace(strDispOrgName,     strArrKey(j), "<B>" & strArrKey(j) & "</B>")
						strDispOrgKanaName = Replace(strDispOrgKanaName, strArrKey(j), "<B>" & strArrKey(j) & "</B>")
					Next
				End If

				'�c�̏��̕ҏW
%>
				<TR>
					<TD WIDTH="10"></TD>
					<TD NOWRAP><%= strDispOrgCd1 %>-<%= strDispOrgCd2 %></TD>
					<TD WIDTH="10"></TD>
					<TD NOWRAP>
<%
						'�A���J�[�̗v��
						blnAnchor = False

						Do
							'�Q�ƃ��[�h�̏ꍇ�A���������c�̂��_��c�̎��g�ł���΃A���J�[�𒣂�Ȃ�
							If strOpMode = OPMODE_BROWSE Then
								If strRefOrgCd1(i) = strOrgCd1 And strRefOrgCd2(i) = strOrgCd2 Then
									Exit Do
								End If
							End If

							'�l�EWeb�̏ꍇ
							If (strOrgCd1 = strPerOrgCd1 And strOrgCd2 = strPerOrgCd2) Or (strOrgCd1 = strWebOrgCd1 And strOrgCd2 = strWebOrgCd2) Then

								'�l�EWeb�ȊO�̏ꍇ�̓A���J�[�𒣂�Ȃ�
								If Not ((strRefOrgCd1(i) = strPerOrgCd1 And strRefOrgCd2(i) = strPerOrgCd2) Or (strRefOrgCd1(i) = strWebOrgCd1 And strRefOrgCd2(i) = strWebOrgCd2)) Then
									Exit Do
								End If

							'�ʏ�c�̂̏ꍇ
							Else

								'�l�EWeb�̏ꍇ�̓A���J�[�𒣂�Ȃ�
								If (strRefOrgCd1(i) = strPerOrgCd1 And strRefOrgCd2(i) = strPerOrgCd2) Or (strRefOrgCd1(i) = strWebOrgCd1 And strRefOrgCd2(i) = strWebOrgCd2) Then
									Exit Do
								End If

							End If

							blnAnchor = True
							Exit Do
						Loop

						If blnAnchor Then
%>
							<A HREF="ctrBrowseContract.asp<%= strQueryString %>&refOrgCd1=<%= strRefOrgCd1(i) %>&refOrgCd2=<%= strRefOrgCd2(i) %>"><%= strDispOrgName %></A>
<%
						Else
%>
							<%= strDispOrgName %>
<%
						End If
%>
					</TD>
					<TD WIDTH="10"></TD>
					<TD NOWRAP><FONT COLOR="666666">�i<%= strDispOrgKanaName %>�j</FONT></TD>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		'�y�[�W���O�i�r�Q�[�^�pURL�̕ҏW
		strURL = Request.ServerVariables("SCRIPT_NAME") & strQueryString & "&key=" & Server.URLEncode(strKey)

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
