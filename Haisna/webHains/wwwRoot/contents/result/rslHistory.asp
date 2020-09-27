<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ʎ��n��\�� (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"     -->
<!-- #include virtual = "/webHains/includes/common.inc"           -->
<!-- #include virtual = "/webHains/includes/EditGrpList.inc"      -->
<!-- #include virtual = "/webHains/includes/EditJudClassList.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc"   -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_SELF)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const CODEALL      = "all"	'�S��������
Const CODETYPE_JUD = "1"	'���蕪��
Const CODETYPE_GRP = "2"	'�O���[�v

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objConsult		'��f���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objResult		'�������ʃA�N�Z�X�pCOM�I�u�W�F�N�g
Dim objJudClass		'���蕪�ރA�N�Z�X�pCOM�I�u�W�F�N�g
Dim objGrp			'�O���[�v�A�N�Z�X�pCOM�I�u�W�F�N�g
'## 2002.6.5 Add 2Lines by T.Takagi �l��񌩏o���\��
Dim objPerson		'�l���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
'## 2002.6.5 Add End

Dim strRsvNo		'�\��ԍ�
Dim strPerId		'�l�h�c
Dim lngYear			'�\���J�n��(�N)
Dim lngMonth		'�\���J�n��(��)
Dim lngDay			'�\���J�n��(��)
Dim strCode			'�ΏۃR�[�h
Dim strGrpCd		'�O���[�v�R�[�h
Dim strJudClassCd	'���蕪�ރR�[�h
Dim strAllResult	'�S�������ڕ\��
Dim strCodeType		'�ΏۃR�[�h�^�C�v (1:���蕪��, 2:�O���[�v�R�[�h)
Dim strSecondFlg	'�Q�������Ώۃt���O
Dim strGender		'����

Dim lngSecondFlg	'�Q�������Ώۃt���O(COM�p)

Dim strCslDate		'��f��
Dim strDayId		'�����h�c

'## 2002.6.5 Add 8Lines by T.Takagi �l��񌩏o���\��
'�l���
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��	
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strPerGender	'����
Dim strGenderName	'���ʖ���
'## 2002.6.5 Add End

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�����l�̎擾
strRsvNo      = Request("rsvNo")
strPerId      = Request("perID")
strCode       = Request("code")
strGrpCd      = Request("grpCd")
strJudClassCd = Request("judClassCd")
strAllResult  = Request("allResult")
lngYear       = Request("year")
lngMonth      = Request("month")
lngDay        = Request("day")
strSecondFlg  = Request("secondFlg")
strGender     = Request("gender")

'�Q�������Ώۃt���O�̏ȗ����ݒ�
lngSecondFlg  = IIf(IsEmpty(strSecondFlg) <> "", CLng("0" & strSecondFlg), RSLSECOND_ALL)

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objConsult = Server.CreateObject("HainsConsult.Consult")
'## 2002.6.5 Add 2Lines by T.Takagi �l��񌩏o���\��
Set objPerson  = Server.CreateObject("HainsPerson.Person")
Set objCommon  = Server.CreateObject("HainsCommon.Common")
'## 2002.6.5 Add End

Do
	'�\���J�n�������l�ݒ�
	If lngYear = "" And lngMonth = "" And lngDay ="" Then

		lngYear  = CLng(Year(Now))
		lngMonth = CLng(Month(Now))
		lngDay   = CLng(Day(Now))

		'�\��ԍ��n���̂Ƃ��͌lID�A��f���A��f���O�����擾
		If strRsvNo <> "" Then
			Call objConsult.SelectHistoryRsvNo(strRsvNo, strPerId, strCslDate, lngYear, lngMonth, lngDay)
		End If

		'�ł��������猩����̂ŕҏW���Ȃ���
		lngYear  = CLng(Year(Now))
		lngMonth = CLng(Month(Now))
		lngDay   = CLng(Day(Now))

	Else

		lngYear  = CLng("0" & lngYear)
		lngMonth = CLng("0" & lngMonth)
		lngDay   = CLng("0" & lngDay)

	End If

	'�ΏۃR�[�h���f
	If strJudClassCd <>"" Then
		strCodeType = CODETYPE_JUD
	Else
		strCodeType = CODETYPE_GRP
	End If

	If Not IsEmpty(strCode) Then
		Exit Do
	End If

	'���蕪�ރR�[�h
	If strJudClassCd <>"" Then
		strCode = strJudClassCd
		Exit Do
	End If

	'�O���[�v�R�[�h
	If strGrpCd <> "" Then
		strCode = strGrpCd
		Exit Do
	End If

	'�S��������
	If strAllResult = "1" Then
		strCode = CODEALL
		Exit Do
	End If

	strCode = ""

	Exit Do
Loop
'-----------------------------------------------------------------------------
' ��f�����̕ҏW
'-----------------------------------------------------------------------------
Function EditResultList(strPerId, lngSelYear, lngSelMonth, lngSelDay, strGrpCd)

	Dim objCommon			'���ʃN���X

	Dim strSelCslDate		'������f��

	Dim strArrCslDate		'��f��
	Dim strArrCsCd			'�R�[�X�R�[�h
	Dim strArrCsName		'�R�[�X��
	Dim strArrRsvNo			'�\��ԍ�
	Dim strArrAge			'��f���N��

	Dim strArrItemCd()		'�������ڃR�[�h
	Dim strArrSuffix()		'�T�t�B�b�N�X
	Dim strArrItemName()	'�������ږ�
	Dim strArrResult()		'��������
	Dim strArrColor()		'��l�R�[�h
	Dim strResult()			'
	Dim strColor()			'

	Dim lngHistoryCount		'�\����
	Dim lngConsultCount		'��f��
	Dim lngCount			'���R�[�h��

	Dim strHTML				'HTML������

	Dim i					'�C���f�b�N�X
	Dim j					'�C���f�b�N�X

	strSelCslDate = lngSelYear & "/" & lngSelMonth & "/" & lngSelDay
	
	'�Ó��ȓ��t�łȂ��ꍇ�A�������Ȃ�
	If Not IsDate(strSelCslDate) Then
		EditResultList = "<BR>�E���t�Ɍ�肪����܂��B<BR><BR>"
		Exit Function
	End If

	Do

		'�I�u�W�F�N�g�̃C���X�^���X�쐬
		Set objCommon  = Server.CreateObject("HainsCommon.Common")

		'�\���𐔎擾
		lngHistoryCount = objCommon.SelectHistoryCount

		lngConsultCount = objConsult.SelectConsultHistory(strPerId, _
														  strSelCslDate, _
														  True, _
														  (lngSecondFlg = RSLSECOND_NONE), _
														  lngHistoryCount, _
														  strArrRsvNo, _
														  strArrCslDate, _
														  strArrCsCd, _
														  strArrCsName, _
														  strArrAge)

		If lngConsultCount = 0 Then
			EditResultList = "<BR>�E" & strSelCslDate & "�ȑO�̎�f���͑��݂��܂���B<BR><BR>"
			Exit Do
		End If
%>
		<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="2">
			<TR BGCOLOR="#eeeeee">
				<TD NOWRAP ROWSPAN="2">&nbsp;</TD>
<%
				For i = 0 To lngConsultCount - 1
%>
					<TD ALIGN="right">
						<A HREF="/webHains/contents/inquiry/inqReport.asp?rsvNo=<%= strArrRsvNo(i) %>" TARGET="_top"><%= strArrCslDate(i) %></A>
					</TD>
<%
				Next
%>
			</TR>
			<TR>
<%
				For i = 0 To lngConsultCount - 1
%>
					<TD ALIGN="right" BGCOLOR="#eeeeee"><%= strArrCsName(i) %></TD>
<%
				Next
%>
			</TR>
<%
			'�������ڎ擾
			If strCodeType = CODETYPE_JUD Then

				'�I�u�W�F�N�g�̃C���X�^���X�쐬
				Set objJudClass = Server.CreateObject("HainsJudClass.JudClass")

				'���蕪�ޕʌ������ڃR�[�h�擾
				lngCount = objJudClass.SelectJudClassItemList(strCode, strArrItemCd, strArrSuffix, strArrItemName)

				'�I�u�W�F�N�g�̃C���X�^���X�폜
				Set objJudClass = Nothing

			Else

				If strCode = CODEALL Then

					'�I�u�W�F�N�g�̃C���X�^���X�쐬
					Set objResult = Server.CreateObject("HainsResult.Result")

					'�S�������ڎ擾
					lngCount = objResult.SelectHistoryAllItemList(strPerId, strSelCslDate, strArrItemCd, strArrSuffix, strArrItemName)

					'�I�u�W�F�N�g�̃C���X�^���X�폜
					Set objResult = Nothing

				Else

					'�I�u�W�F�N�g�̃C���X�^���X�쐬
					Set objGrp = Server.CreateObject("HainsGrp.Grp")

					'�����O���[�v���S�������ڎ擾
					lngCount = objGrp.SelectGrp_I_ItemList(strCode, strArrItemCd, strArrSuffix, strArrItemName)

					'�I�u�W�F�N�g�̃C���X�^���X�쐬
					Set objGrp = Nothing

				End If

			End If

			'�I�u�W�F�N�g�̃C���X�^���X�쐬
			Set objResult = Server.CreateObject("HainsResult.Result")

			'�������ʏ��擾
			If lngCount > 0 Then
				ReDim strArrResult(UBound(strArrRsvNo), UBound(strArrItemCd))
				ReDim strArrColor(UBound(strArrRsvNo), UBound(strArrItemCd))
				For i = 0 To UBound(strArrRsvNo)
					objResult.SelectHistoryItemResultList strArrRsvNo(i), strArrItemCd, strArrSuffix, strResult, strColor
					For j = 0 To UBound(strResult)
						strArrResult(i, j) = strResult(j)
						strArrColor(i, j) = strColor(j)
					Next
				Next
			End If

			'�I�u�W�F�N�g�̃C���X�^���X�폜
			Set objResult = Nothing

			For i = 0 To lngCount - 1
%>
				<TR>
					<TD BGCOLOR="#eeeeee" NOWRAP><%= strArrItemName(i) %></TD>
<%
					For j = 0 To UBound(strArrRsvNo)

						'�֐��̕ҏW
						strHTML = "callDtlGuide("
						strHTML = strHTML & "'" & strArrItemCd(i)         & "',"
						strHTML = strHTML & "'" & strArrSuffix(i)         & "',"
						strHTML = strHTML & "'" & strArrCsCd(j)           & "',"
						strHTML = strHTML & "'" & Year(strArrCslDate(j))  & "',"
						strHTML = strHTML & "'" & Month(strArrCslDate(j)) & "',"
						strHTML = strHTML & "'" & Day(strArrCslDate(j))   & "',"
						strHTML = strHTML & "'" & strArrAge(j)            & "',"
						strHTML = strHTML & "'" & strGender               & "')"

						If strArrResult(j, i) = "" Then
							strArrResult(j, i) = "&nbsp;"
						End If
%>
						<TD ALIGN="right"><A HREF="javascript:<%= strHTML %>"><FONT COLOR="<%= IIf(strArrColor(j, i) <> "", strArrColor(j, i), "#000000") %>"><%= strArrResult(j, i) %></FONT></A></TD>
<%
					Next
%>
				</TR>
<%
			Next
%>
		</TABLE>
<%
		Exit Do

	Loop
	
	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objConsult  = Nothing
	Set objResult   = Nothing
	Set objGrp	  = Nothing
	Set objJudClass = Nothing

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�O��l�\��</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/dtlGuide.inc" -->
<!--
// �������ڐ����Ăяo��
function callDtlGuide(itemCd, suffix, csCd, cslYear, cslMonth, cslDay, age, gender) {

	// ������ʂ̘A����ɉ�ʓ��͒l��ݒ肷��
	dtlGuide_ItemCd       = itemCd;
	dtlGuide_Suffix       = suffix;
	dtlGuide_CsCd         = csCd;
	dtlGuide_CslDateYear  = cslYear;
	dtlGuide_CslDateMonth = cslMonth;
	dtlGuide_CslDateDay   = cslDay;
	dtlGuide_Age          = age;
	dtlGuide_Gender       = gender;

	// �������ڐ����\��
	showGuideDtl();
}

// ���n���ʂ�\��
function showHistory() {

	var myForm = document.rethistory;	// ����ʂ̃t�H�[���G�������g
	var url;							// URL������

	// ���n��\����URL�ҏW
	url = '<%= Request.ServerVariables("SCRIPT_NAME") %>';
	url = url + '?rsvNo='      + myForm.rsvno.value;
	url = url + '&perid='      + myForm.perid.value;
	url = url + '&judClassCd=' + myForm.judClassCd.value;
	url = url + '&grpCd='      + myForm.grpCd.value;
	url = url + '&allResult='  + myForm.allResult.value;
	url = url + '&secondFlg='  + myForm.secondFlg.value;
	url = url + '&year='       + myForm.year.value;
	url = url + '&month='      + myForm.month.value;
	url = url + '&day='        + myForm.day.value;
	url = url + '&code='       + myForm.code.value;

	// ���n���ʂ�\��
	location.replace(url);
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff" ONUNLOAD="javascript:closeGuideDtl()">

<FORM NAME="rethistory" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>">

	<INPUT TYPE="hidden" NAME="rsvno"      VALUE="<%= strRsvNo      %>">
	<INPUT TYPE="hidden" NAME="perid"      VALUE="<%= strPerId      %>">
	<INPUT TYPE="hidden" NAME="judClassCd" VALUE="<%= strJudClassCd %>">
	<INPUT TYPE="hidden" NAME="grpCd"      VALUE="<%= strGrpCd      %>">
	<INPUT TYPE="hidden" NAME="allResult"  VALUE="<%= strAllResult  %>">
	<INPUT TYPE="hidden" NAME="secondFlg"  VALUE="<%= lngSecondFlg  %>">
	<INPUT TYPE="hidden" NAME="gender"     VALUE="<%= strGender     %>">

	<!-- �E�C���h�E�������o�� -->
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#000000">�������ʁi���n��j</FONT></B></TD>
		</TR>
	</TABLE>
<%
'## 2002.6.5 Add 19Lines by T.Takagi �l��񌩏o���\��
	'�l���ǂݍ���
	objPerson.SelectPersonInf strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strPerGender, strGenderName
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD><%= strPerID %></TD>
			<TD NOWRAP><B><%= strLastName %>�@<%= strFirstName %></B><FONT SIZE="-1">�i<%= strLastKName %>�@<%= strFirstKName %>�j</FONT></TD>
		</TR>
		<TR>
			<TD></TD>
			<TD NOWRAP><%= objCommon.FormatString(strBirth, "ge.m.d") %>���@<%= strGenderName %></TD>
		</TR>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
	</TABLE>
<%
'## 2002.6.5 Add End
%>
	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
			<TD HEIGHT="5"></TD>
		<TR>
			<TD><A HREF="javascript:calGuide_showGuideCalendar('year', 'month', 'day')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���t�K�C�h��\��"></A></TD>
			<TD><%= EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
			<TD>�N</TD>
			<TD><%= EditNumberList("month", 1, 12, lngMonth, False) %></TD>
			<TD>��</TD>
			<TD><%= EditNumberList("day", 1, 31, lngDay, False) %></TD>
			<TD>���ȑO��</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
		<TR>
<%
			If strCodeType = CODETYPE_JUD Then
%>
				<TD><%= EditJudClassList("code", strCode, NON_SELECTED_ADD) %></TD>
<%
			Else
%>
				<TD><%= EditGrpIList_GrpDiv("code", strCode, CODEALL, "�S�Ă̌�������", ADD_FIRST) %></TD>
<%
			End If
%>
			<TD>��</TD>
			<TD><A HREF="javascript:showHistory()"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�w������ŕ\��"></A></TD>
		</TR>
	</TABLE>
<%
	If strCode <> "" Then
%>
		<%= EditResultList(strPerId, lngYear, lngMonth, lngDay, strCode) %>
<%
	End If
%>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
