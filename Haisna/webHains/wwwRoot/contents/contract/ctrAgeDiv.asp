<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(�N��N�Z���E�N��敪�̐ݒ�) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_NEXT        = "next"	'�������[�h�i���ցj
Const MODE_SAVE        = "save"	'�������[�h�i�ۑ��j
Const AGEDIV_ROWCOUNT  = 10		'�N��͈́E�N��敪�̕\���s��
Const AGECALC_CSLDATE  = 0		'�N��N�Z���@�i��f���w��j
Const AGECALC_DIRECT   = 1		'�N��N�Z���@�i�N�Z���w��j

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p
Dim objContract			'�_��Ǘ����A�N�Z�X�p
Dim objContractControl	'�_����A�N�Z�X�p

'�����l
Dim strMode				'�������[�h
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strOrgCd1			'�c�̃R�[�h1
Dim strOrgCd2			'�c�̃R�[�h2
Dim strCsCd				'�R�[�X�R�[�h
Dim strStrYear			'�_��J�n�N
Dim strStrMonth 		'�_��J�n��
Dim strStrDay			'�_��J�n��
Dim strEndYear			'�_��I���N
Dim strEndMonth 		'�_��I����
Dim strEndDay			'�_��I����
Dim lngAgeCalc			'�N��N�Z���@
Dim lngAgeCalcYear		'�N��N�Z���i�N�j
Dim lngAgeCalcMonth		'�N��N�Z���i���j
Dim lngAgeCalcDay		'�N��N�Z���i���j
Dim strStrAge			'�J�n�N��
Dim strEndAge			'�I���N��
Dim strAgeDiv			'�N��敪

'�_��Ǘ����
Dim strOrgName			'�c�̖�
Dim strCsName			'�R�[�X��
Dim dtmStrDate			'�_��J�n��
Dim dtmEndDate			'�_��I����

Dim strAgeCalc			'�N��N�Z��
Dim strStrDate			'�ҏW�p�̌_��J�n��
Dim strEndDate			'�ҏW�p�̌_��I����
Dim strMessage			'�G���[���b�Z�[�W
Dim strHTML				'HTML������
Dim strURL				'�W�����v���URL
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")

'�����l�̎擾
strMode         = Request("mode")
strCtrPtCd      = Request("ctrPtCd")
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strCsCd         = Request("csCd")
strStrYear      = Request("strYear")
strStrMonth     = Request("strMonth")
strStrDay       = Request("strDay")
strEndYear      = Request("endYear")
strEndMonth     = Request("endMonth")
strEndDay       = Request("endDay")
lngAgeCalc      = CLng("0" & Request("ageCalc"))
lngAgeCalcYear  = CLng("0" & Request("ageCalcYear"))
lngAgeCalcMonth = CLng("0" & Request("ageCalcMonth"))
lngAgeCalcDay   = CLng("0" & Request("ageCalcDay"))
strStrAge       = ConvIStringToArray(Request("strAge"))
strEndAge       = ConvIStringToArray(Request("endAge"))
strAgeDiv       = ConvIStringToArray(Request("ageDiv"))

'�X�V���[�h���Ƃ̏�������
Select Case strMode

	'����
	Case MODE_NEXT

		'���̓`�F�b�N
		strMessage = CheckValue()
		If IsEmpty(strMessage) Then

			'�����URL�̕ҏW�J�n
			strURL = "ctrDemand.asp?"

			'QueryString�l�̕ҏW
			strURL = strURL & "orgCd1="   & strOrgCd1   & "&"
			strURL = strURL & "orgCd2="   & strOrgCd2   & "&"
			strURL = strURL & "csCd="     & strCsCd     & "&"
			strURL = strURL & "strYear="  & strStrYear  & "&"
			strURL = strURL & "strMonth=" & strStrMonth & "&"
			strURL = strURL & "strDay="   & strStrDay   & "&"
			strURL = strURL & "endYear="  & strEndYear  & "&"
			strURL = strURL & "endMonth=" & strEndMonth & "&"
			strURL = strURL & "endDay="   & strEndDay   & "&"

			'�N��͈́E�N��敪�̕ҏW
			If IsArray(strStrAge) Then
				For i = 0 To UBound(strStrAge)
					strURL = strURL & "strAge="  & strStrAge(i) & "&"
					strURL = strURL & "endAge="  & strEndAge(i) & "&"
					strURL = strURL & "ageDiv="  & strAgeDiv(i) & "&"
				Next
			End If

			'�N��N�Z���̕ҏW
			strAgeCalc = EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)
			strURL = strURL & "ageCalc="  & strAgeCalc

			'����ʂփ��_�C���N�g
			Response.Redirect strURL
			Response.End

		End If

	'�ۑ�
	Case MODE_SAVE

		'���̓`�F�b�N
		strMessage = CheckValue()
		If IsEmpty(strMessage) Then

			'�N��N�Z���̕ҏW
			strAgeCalc = EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)

			'�N��N�Z���E�N��敪�̍X�V
			objContractControl.UpdateAgeDiv strOrgCd1, strOrgCd2, strCtrPtCd, strAgeCalc, strStrAge, strEndAge, strAgeDiv

			'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
			strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
			strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
			strHTML = strHTML & "</BODY>"
			strHTML = strHTML & "</HTML>"
			Response.Write strHTML
			Response.End

		End If

	Case Else

		'�_��p�^�[���R�[�h�w�莞(�����X�V��)
		If strCtrPtCd <> "" Then

			'�_��p�^�[�����ǂݍ���
			objContract.SelectCtrPt strCtrPtCd, dtmStrDate, dtmEndDate, strAgeCalc

			'�N��N�Z���̐ݒ�
			Select Case Len(strAgeCalc)
				Case 8
					lngAgeCalc      = AGECALC_DIRECT
					lngAgeCalcYear  = CLng("0" & Mid(strAgeCalc, 1, 4))
					lngAgeCalcMonth = CLng("0" & Mid(strAgeCalc, 5, 2))
					lngAgeCalcDay   = CLng("0" & Mid(strAgeCalc, 7, 2))
				Case 4
					lngAgeCalc      = AGECALC_DIRECT
					lngAgeCalcYear  = 0
					lngAgeCalcMonth = CLng("0" & Mid(strAgeCalc, 1, 2))
					lngAgeCalcDay   = CLng("0" & Mid(strAgeCalc, 3, 2))
				Case Else
					lngAgeCalc      = AGECALC_CSLDATE
					lngAgeCalcYear  = 0
					lngAgeCalcMonth = 0
					lngAgeCalcDay   = 0
			End Select

			'�_��p�^�[���N��敪���ǂݍ���
			objContract.SelectCtrPtAge strCtrPtCd, strStrAge, strEndAge, strAgeDiv

		End If

End Select

'�_��p�^�[���R�[�h�w�莞(�����X�V��)
If strCtrPtCd <> "" Then

	'�_��Ǘ�����ǂ݁A�c�́E�R�[�X�̖��̋y�ь_����Ԃ��擾����
	If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, strCtrPtCd, strOrgName, strCsCd, strCsName, dtmStrDate, dtmEndDate) = False Then
		Err.Raise 1000, ,"�_���񂪑��݂��܂���B"
	End If


'�_��p�^�[���R�[�h���w�莞(�����V�K�o�^��)
Else

	'�c�̖��̓ǂݍ���
	If objOrganization.SelectOrgName(strOrgCd1, strOrgCd2, strOrgName) = False Then
		Err.Raise 1000, , "�c�̏�񂪑��݂��܂���B"
	End If

	'�R�[�X���̓ǂݍ���
	If objCourse.SelectCourse(strCsCd, strCsName) = False Then
		Err.Raise 1000, , "�R�[�X��񂪑��݂��܂���B"
	End If

	'�_��J�n�N�����̎擾
	dtmStrDate = CDate(strStrYear & "/" & strStrMonth & "/" & strStrDay)

	'�_��I���N�����̎擾
	If strEndYear <> "" Or strEndMonth <> "" Or strEndDay <> "" Then
		dtmEndDate = CDate(strEndYear & "/" & strEndMonth & "/" & strEndDay)
	End If

End If

'�N��敪�����݂��Ȃ��ꍇ�i�����\�����j�͋�̔z����쐬
If IsEmpty(strStrAge) Then
	strStrAge = Array()
	strEndAge = Array()
	strAgeDiv = Array()
End If

'�\���s�����z����g������
ReDim Preserve strStrAge(AGEDIV_ROWCOUNT - 1)
ReDim Preserve strEndAge(AGEDIV_ROWCOUNT - 1)
ReDim Preserve strAgeDiv(AGEDIV_ROWCOUNT - 1)

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �N��N�Z���̕ҏW
'
' �����@�@ : (In)     lngAgeCalc       �N��N�Z���@
' �@�@�@�@ : (In)     lngAgeCalcYear   �N��N�Z���i�N�j
' �@�@�@�@ : (In)     lngAgeCalcMonth  �N��N�Z���i���j
' �@�@�@�@ : (In)     lngAgeCalcDay    �N��N�Z���i���j
'
' �߂�l�@ : �N��N�Z��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function EditAgeCalc(lngAgeCalc, lngAgeCalcYear, lngAgeCalcMonth, lngAgeCalcDay)

	EditAgeCalc = IIf(lngAgeCalc = 1, IIf(lngAgeCalcYear <> 0, Right("0000" & lngAgeCalcYear, 4), "") & Right("00" & lngAgeCalcMonth, 2) & Right("00" & lngAgeCalcDay, 2), "")

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �����l�̑Ó����`�F�b�N���s��
'
' �����@�@ :
'
' �߂�l�@ : �G���[�l������ꍇ�A�G���[���b�Z�[�W�̔z���Ԃ�
'
' ���l�@�@ : �f�[�^���펞�͔N��͈́E�N��敪�̔z����č\������
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X

	Dim strArrStrAge()	'�J�n�N��̔z��
	Dim strArrEndAge()	'�I���N��̔z��
	Dim strArrAgeDiv()	'�N��敪�̔z��
	Dim lngCount		'�z��̗v�f��

	Dim strWkStrAge		'�J�n�N��
	Dim strWkEndAge		'�I���N��
	Dim strWkAgeDiv		'�N��敪

	Dim strMessage		'�G���[���b�Z�[�W
	Dim blnAdd			'�ǉ��t���O
	Dim i, j			'�C���f�b�N�X

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�N��N�Z���@���u�N�Z���𒼐ڎw��v�̏ꍇ�͔N��N�Z���`�F�b�N���s��
	Do
		'��f���ŋN�Z����ꍇ�͕s�v
		If lngAgeCalc = 0 Then
			Exit Do
		End If

		'�������w�肳��Ă��Ȃ��ꍇ�̓G���[
		If lngAgeCalcMonth + lngAgeCalcDay = 0 Then
			objCommon.AppendArray strMessage, "�N��N�Z���𒼐ڎw�肷��ꍇ�͌�������͂��ĉ������B"
			Exit Do
		End If

		'�N���w�肳��Ă��Ȃ��ꍇ�̌����`�F�b�N(�[�N�łȂ��C�ӂ̔N���g�p���ĔN�����`�F�b�N���s��)
		If lngAgeCalcYear = 0 Then
			If Not IsDate("2001/" & lngAgeCalcMonth & "/" & lngAgeCalcDay) Then
				objCommon.AppendArray strMessage, "�N��N�Z���̓��͌`��������������܂���B"
			End If

		'�N���w�肳��Ă���ꍇ�̌����`�F�b�N
		Else
			If Not IsDate(lngAgeCalcYear & "/" & lngAgeCalcMonth & "/" & lngAgeCalcDay) Then
				objCommon.AppendArray strMessage, "�N��N�Z���̓��͌`��������������܂���B"
			End If
		End If

		Exit Do
	Loop

	'�z��̍č\��
	For i = 0 To UBound(strStrAge)

		blnAdd = True

		'�e�s�̍č\��
		Do

			'�������͂���Ă��Ȃ��s�̓X�L�b�v
			If strStrAge(i) = "" And strEndAge(i) = "" And strAgeDiv(i) = "" Then
				blnAdd = False
				Exit Do
			End If

			'�N��͈͂����͂���Ă��Ȃ��s�͂Ƃ肠�����ǉ��i��ŃG���[�ɂȂ邪�j
			If strStrAge(i) = "" And strEndAge(i) = "" Then
				strWkStrAge = strStrAge(i)
				strWkEndAge = strEndAge(i)
				strWkAgeDiv = strAgeDiv(i)
				Exit Do
			End If

			'�J�n�N����͂���Ă��Ȃ��s�͍ŏ��N���K�p���Ēǉ�������
			If strStrAge(i) = "" And strEndAge(i) <> "" Then
				strWkStrAge = CStr(AGE_MINVALUE)
				strWkEndAge = strEndAge(i)
				strWkAgeDiv = strAgeDiv(i)
				Exit Do
			End If

			'�I���N����͂���Ă��Ȃ��s�͍ő�N���K�p���Ēǉ�������
			If strStrAge(i) <> "" And strEndAge(i) = "" Then
				strWkStrAge = strStrAge(i)
				strWkEndAge = CStr(AGE_MAXVALUE)
				strWkAgeDiv = strAgeDiv(i)
				Exit Do
			End If

			'�J�n�N��I���N����傫���s�͍ő�A�ŏ����������Ēǉ�������
			If CLng(strStrAge(i)) > CLng(strEndAge(i)) Then
				strWkStrAge = strEndAge(i)
				strWkEndAge = strStrAge(i)
				strWkAgeDiv = strAgeDiv(i)
				Exit Do
			End If

			'��L�ȊO�͂��̂܂ܒǉ�
			strWkStrAge = strStrAge(i)
			strWkEndAge = strEndAge(i)
			strWkAgeDiv = strAgeDiv(i)

			Exit Do
		Loop

		'�z��̍ő�v�f�����C���N�������g���A�v�f��ǉ�����
		If blnAdd Then
			ReDim Preserve strArrStrAge(lngCount)
			ReDim Preserve strArrEndAge(lngCount)
			ReDim Preserve strArrAgeDiv(lngCount)
			strArrStrAge(lngCount) = strWkStrAge
			strArrEndAge(lngCount) = strWkEndAge
			strArrAgeDiv(lngCount) = strWkAgeDiv
			lngCount = lngCount + 1
		End If

	Next

	'�N��͈͂̓��̓`�F�b�N
	For i = 0 To lngCount - 1
		If strArrStrAge(i) = "" And strArrEndAge(i) = "" Then
			objCommon.AppendArray strMessage, "�N��͈͂̓��͂���Ă��Ȃ��s������܂��B"
			Exit For
		End If
	Next

	'�N��敪�̓��̓`�F�b�N
	For i = 0 To lngCount - 1
		If strArrAgeDiv(i) = "" Then
			objCommon.AppendArray strMessage, "�N��敪�̓��͂���Ă��Ȃ��s������܂��B"
			Exit For
		End If
	Next

	'�N��͈͂̏d���`�F�b�N
	i = 0
	Do Until i >= lngCount

		'�N��͈͂����͂���Ă���ꍇ
		If strArrStrAge(i) <> "" And strArrEndAge(i) <> "" Then

			'���O�̗v�f�܂ł̔N��͈͂Ƃ̏d���`�F�b�N
			For j = 0 To i - 1

				'�N��͈͂����͂���Ă���ꍇ
				If strArrStrAge(j) <> "" And strArrEndAge(j) <> "" Then

					'�N��͈͂��d�����Ă���ꍇ�̓G���[
					If CLng(strArrStrAge(i)) <= CLng(strArrEndAge(j)) And CLng(strArrEndAge(i)) >= CLng(strArrStrAge(j)) Then
						objCommon.AppendArray strMessage, "�N��͈͂��d�����Ă��܂��B"
						Exit Do
					End If

				End If

			Next

		End If

		i = i + 1
	Loop

	'�G���[�����݂��Ȃ��ꍇ
	If IsEmpty(strMessage) Then

		'�v�f�����݂���ꍇ�͌��̔N��͈́E�N��敪���č\����̂���ɒu�������A���݂��Ȃ����Empty�l�Ƃ���
		If lngCount > 0 Then
			strStrAge = strArrStrAge
			strEndAge = strArrEndAge
			strAgeDiv = strArrAgeDiv
		Else
			strStrAge = Empty
			strEndAge = Empty
			strAgeDiv = Empty
		End If

	End If

	'�߂�l�̕ҏW
	CheckValue = strMessage

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�N��N�Z���E�N��敪�̐ݒ�</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// submit���̏���
function submitForm( mode ) {

	// �������[�h���w�肵��submit
	document.entryForm.mode.value = mode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 0; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="mode"     VALUE="">
	<INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd  %>">
	<INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1   %>">
	<INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2   %>">
	<INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd     %>">
	<INPUT TYPE="hidden" NAME="strYear"  VALUE="<%= strStrYear  %>">
	<INPUT TYPE="hidden" NAME="strMonth" VALUE="<%= strStrMonth %>">
	<INPUT TYPE="hidden" NAME="strDay"   VALUE="<%= strStrDay   %>">
	<INPUT TYPE="hidden" NAME="endYear"  VALUE="<%= strEndYear  %>">
	<INPUT TYPE="hidden" NAME="endMonth" VALUE="<%= strEndMonth %>">
	<INPUT TYPE="hidden" NAME="endDay"   VALUE="<%= strEndDay   %>">

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="80%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">�N��N�Z���E�N��敪�̐ݒ�</FONT></B></TD>
		</TR>
	</TABLE>
<%
	'�G���[���b�Z�[�W�̕ҏW
	Call EditMessage(strMessage, MESSAGETYPE_WARNING)

	'�ҏW�p�̌_��J�n���ݒ�
	If Not IsEmpty(dtmStrDate) Then
		strStrDate = FormatDateTime(dtmStrDate, 1)
	End If

	'�ҏW�p�̌_��I�����ݒ�
	If Not IsEmpty(dtmEndDate) Then
		strEndDate = FormatDateTime(dtmEndDate, 1)
	End If
%>
	<BR>

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
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD>�_�����</TD>
			<TD>�F</TD>
			<TD><B><%= strStrDate %>�`<%= strEndDate %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">��</FONT>�N��̋N�Z���@���w�肵�ĉ������B

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD NOWRAP>�N��N�Z��</TD>
			<TD>�F</TD>
			<TD><INPUT TYPE="radio" NAME="ageCalc" VALUE="0" <%= IIf(lngAgeCalc = "0", "CHECKED", "") %>></TD>
			<TD NOWRAP>��f���ŋN�Z����</TD>
		</TR>
		<TR>
			<TD COLSPAN="2"></TD>
			<TD><INPUT TYPE="radio" NAME="ageCalc" VALUE="1" <%= IIf(lngAgeCalc = "1", "CHECKED", "") %>></TD>
			<TD NOWRAP>�N�Z���𒼐ڎw��&nbsp;</TD>
			<TD NOWRAP>�N�Z�N�F</TD>
			<TD><%= EditSelectNumberList("ageCalcYear", YEARRANGE_MIN, YEARRANGE_MAX, lngAgeCalcYear) %></TD>
			<TD NOWRAP>&nbsp;�N�Z�����F</TD>
			<TD><%= EditSelectNumberList("ageCalcMonth", 1, 12, lngAgeCalcMonth) %></TD>
			<TD>��</TD>
			<TD><%= EditSelectNumberList("ageCalcDay", 1, 31, lngAgeCalcDay) %></TD>
			<TD>��</TD>
		</TR>
	</TABLE>

	<BR>

	<FONT COLOR="#cc9999">��</FONT>�_��c�̂����S���錒�f��{���̒P���v�Z�p�N��敪��ݒ肵�ĉ������B

	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="1">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee">
			<TD ALIGN="center" COLSPAN="4" NOWRAP>�N��͈�</TD>
			<TD NOWRAP>�N��敪</TD>
		</TR>
<%
		'�N��͈́E�N��敪�̕ҏW
		For i = 0 To AGEDIV_ROWCOUNT - 1
%>
			<TR>
				<TD><%= EditSelectNumberList("strAge", 1, 150, CLng("0" & strStrAge(i))) %></TD>
				<TD>�`</TD>
				<TD><%= EditSelectNumberList("endAge", 1, 150, CLng("0" & strEndAge(i))) %></TD>
				<TD>��</TD>
				<TD ALIGN="center"><INPUT TYPE="text" NAME="ageDiv" SIZE="2" MAXLENGTH="2" VALUE="<%= strAgeDiv(i) %>"></TD>
			</TR>
<%
		Next
%>
	</TABLE>

	<BR><BR>
<%
	'�X�V���́u�L�����Z���v�u�ۑ��v�{�^�����A�V�K���́u�߂�v�u���ցv�{�^�������ꂼ��p�ӂ���
	If strCtrPtCd <> "" Then
%>
		<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
		<A HREF="javascript:submitForm('<%= MODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
<%
	Else
%>
		<A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
		<A HREF="javascript:submitForm('<%= MODE_NEXT %>')"><IMG SRC="/webHains/images/next.gif" WIDTH="77" HEIGHT="24" ALT="����"></A>
<%
	End If
%>
</FORM>
</BLOCKQUOTE>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
