<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �h�{�w���`�H�K����f  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_SHOKUSYUKAN = "X022"	'�H�K����f�O���[�v�R�[�h

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p

'�p�����[�^
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h

'�������ʏ��
Dim vntPerId			'�\��ԍ�
Dim vntCslDate			'�������ڃR�[�h
Dim vntHisNo			'����No.
Dim vntRsvNo			'�\��ԍ�
Dim vntItemCd			'�������ڃR�[�h
Dim vntSuffix			'�T�t�B�b�N�X
Dim vntResultType		'���ʃ^�C�v
Dim vntItemType			'���ڃ^�C�v
Dim vntItemName			'�������ږ���
Dim vntResult			'��������
Dim vntUnit				'�P��
Dim vntItemQName		'��f����
Dim vntGrpSeq			'�\������
Dim vntRslFlg			'�������ʑ��݃t���O
Dim lngRslCnt			'�������ʐ�

Dim strLimit(1)			'�J�����[����
Dim strShokusyukan()	'�H�K��
Dim strFavorite()		'�n�D�i
Dim strDairy()			'�����i
Dim strMeal()			'�H���ɂ���
Dim strMorning()		'���H
Dim strLunch()			'���H
Dim strDinner()			'�[�H
Dim lngShokusyukanCnt	'�H�K���f�[�^��
Dim lngFavoriteCnt		'�n�D�i�f�[�^��
Dim lngDairyCnt			'�����i�f�[�^��
Dim lngMealCnt			'�H���ɂ��ăf�[�^��
Dim lngMorningCnt(2)	'���H�f�[�^��
Dim lngLunchCnt(2)		'���H�f�[�^��
Dim lngDinnerCnt(2)		'�[�H�f�[�^��

Dim strAlcohol()		'�A���R�[��
Dim lngAlcoholCnt		'�A���R�[���f�[�^��

'### 2004/01/23 Start K.Kagawa �����K���̒ǉ�
Dim strDrinking()		'�����ɂ���
Dim lngDrinkingCnt		'�����ɂ��ăf�[�^��
'### 2004/01/23 End

Dim strURL				'�W�����v���URL
Dim i, j				'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

'## 2012.09.11 Add by T.Takagi@RD �ؑ֓��t�ɂ���ʐؑ�
'�ؑ֓��ȍ~�̎�f���ł����2012�N�ŗp�̉�ʂ�
If IsVer201210(lngRsvNo) Then
	Response.Redirect "Shokusyukan201210.asp?grpno=" & strGrpNo & "&rsvno=" & lngRsvNo & "&cscd=" & strCsCd & "&winmode=" & strWinMode
End If
'## 2012.09.11 Add End

Do
	'�w��Ώێ�f�҂̌������ʂ��擾����
''## 2006.05.10 Mod by ��  *****************************
''�O���\�����[�h�ݒ�

'	lngRslCnt = objInterView.SelectHistoryRslList( _
'						lngRsvNo, _
'						1, _
'						GRPCD_SHOKUSYUKAN, _
'						0, _
'						"", _
'						0, _
'						0, _
'						1, _
'						vntPerId, _
'						vntCslDate, _
'						vntHisNo, _
'						vntRsvNo, _
'						vntItemCd, _
'						vntSuffix, _
'						vntResultType, _
'						vntItemType, _
'						vntItemName, _
'						vntResult, _
'						, , , , , , _
'						vntUnit, _
'						, , , , , _
'						vntItemQName, _
'						vntGrpSeq, _
'						vntRslFlg _
'						)

	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_SHOKUSYUKAN, _
						1, _
						strCsCd, _
						0, _
						0, _
						1, _
						vntPerId, _
						vntCslDate, _
						vntHisNo, _
						vntRsvNo, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult, _
						, , , , , , _
						vntUnit, _
						, , , , , _
						vntItemQName, _
						vntGrpSeq, _
						vntRslFlg _
						)

	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�������ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	Redim strMorning(1,2,-1)
	Redim strLunch(1,2,-1)
	Redim strDinner(1,2,-1)

	For i=0 To lngRslCnt-1
		'�J�����[����
		If CLng(vntGrpSeq(i)) = 1 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				strLimit(0) = vntItemQName(i)
				strLimit(1) = vntResult(i)
			End IF
		End If
		'�J�����[������
		If CLng(vntGrpSeq(i)) = 2 Then
			'�u�͂��v�̂Ƃ�
			If strLimit(1) = "�͂�" Then
				strLimit(1) = strLimit(1) & "�@�i" & IIf(vntRslFlg(i)="1", vntResult(i), "�@") & "���������j"
			End If
		End If
		'�H�K��
		If 3 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 13 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				Do
					If vntItemQName(i) = "�P�T�Ԃ̌��H��" Then
						'�u����قǂł��Ȃ��v�̂Ƃ��������H�񐔂�\��
						If strShokusyukan(1, lngShokusyukanCnt) = "����قǂł��Ȃ�" Then
							strShokusyukan(1, lngShokusyukanCnt) = strShokusyukan(1, lngShokusyukanCnt) & "�@�i" & vntItemQName(i) & "�@" & vntResult(i) & "��j"
						End If
						Exit Do
					End If
					If vntItemQName(i) = "�P�T�Ԃ̊ԐH��" Then
						'�u�H�ׂ�v�̂Ƃ��������H�񐔂�\��
						If strShokusyukan(1, lngShokusyukanCnt) = "�H�ׂ�" Then
							strShokusyukan(1, lngShokusyukanCnt) = strShokusyukan(1, lngShokusyukanCnt) & "�@�i" & vntItemQName(i) & "�@" & vntResult(i) & "��j"
						End If
						Exit Do
					End If
					lngShokusyukanCnt = lngShokuSYukanCnt + 1
					Redim Preserve strShokusyukan(1, lngShokusyukanCnt)
					strShokusyukan(0, lngShokusyukanCnt) = vntItemQName(i)
					strShokusyukan(1, lngShokusyukanCnt) = vntResult(i)

					Exit Do
				Loop
			End If
		End If
		'�n�D�i
		If 14 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 31 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngFavoriteCnt = lngFavoriteCnt + 1
				Redim Preserve strFavorite(1, lngFavoriteCnt)
				strFavorite(0, lngFavoriteCnt) = vntItemQName(i)
				strFavorite(1, lngFavoriteCnt) = vntResult(i) & vntUnit(i)
			End If
		End If
		'�����i
		If 32 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 35 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDairyCnt = lngDairyCnt + 1
				Redim Preserve strDairy(1, lngDairyCnt)
				strDairy(0, lngDairyCnt) = vntItemQName(i)
				strDairy(1, lngDairyCnt) = vntResult(i) & vntUnit(i)
			End If
		End If
		'�H���ɂ���
		If 36 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 38 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngMealCnt = lngMealCnt + 1
				Redim Preserve strMeal(1, lngMealCnt)
				strMeal(0, lngMealCnt) = vntItemQName(i)
				strMeal(1, lngMealCnt) = vntResult(i)
			End If
		End If
		'��H�i���H�j
		If 39 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 69 Then
			j = 0
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngMorningCnt(j) = lngMorningCnt(j) + 1
				If lngMorningCnt(j) > UBound(strMorning, 3) Then
					Redim Preserve strMorning(1, 2, lngMorningCnt(j))
				End If
				strMorning(0, j, lngMorningCnt(j)) = vntItemQName(i)
				strMorning(1, j, lngMorningCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'��؁i���H�j
		If 70 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 100 Then
			j = 1
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngMorningCnt(j) = lngMorningCnt(j) + 1
				If lngMorningCnt(j) > UBound(strMorning, 3) Then
					Redim Preserve strMorning(1, 2, lngMorningCnt(j))
				End If
				strMorning(0, j, lngMorningCnt(j)) = vntItemQName(i)
				strMorning(1, j, lngMorningCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'���؁i���H�j
		If 101 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 120 Then
			j = 2
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngMorningCnt(j) = lngMorningCnt(j) + 1
				If lngMorningCnt(j) > UBound(strMorning, 3) Then
					Redim Preserve strMorning(1, 2, lngMorningCnt(j))
				End If
				strMorning(0, j, lngMorningCnt(j)) = vntItemQName(i)
				strMorning(1, j, lngMorningCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'��H�i���H�j
		If 121 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 151 Then
			j = 0
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngLunchCnt(j) = lngLunchCnt(j) + 1
				If lngLunchCnt(j) > UBound(strLunch, 3) Then
					Redim Preserve strLunch(1, 2, lngLunchCnt(j))
				End If
				strLunch(0, j, lngLunchCnt(j)) = vntItemQName(i)
				strLunch(1, j, lngLunchCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'��؁i���H�j
		If 152 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 182 Then
			j = 1
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngLunchCnt(j) = lngLunchCnt(j) + 1
				If lngLunchCnt(j) > UBound(strLunch, 3) Then
					Redim Preserve strLunch(1, 2, lngLunchCnt(j))
				End If
				strLunch(0, j, lngLunchCnt(j)) = vntItemQName(i)
				strLunch(1, j, lngLunchCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'���؁i���H�j
		If 183 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 202 Then
			j = 2
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngLunchCnt(j) = lngLunchCnt(j) + 1
				If lngLunchCnt(j) > UBound(strLunch, 3) Then
					Redim Preserve strLunch(1, 2, lngLunchCnt(j))
				End If
				strLunch(0, j, lngLunchCnt(j)) = vntItemQName(i)
				strLunch(1, j, lngLunchCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'��H�i�[�H�j
		If 203 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 233 Then
			j = 0
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDinnerCnt(j) = lngDinnerCnt(j) + 1
				If lngDinnerCnt(j) > UBound(strDinner, 3) Then
					Redim Preserve strDinner(1, 2, lngDinnerCnt(j))
				End If
				strDinner(0, j, lngDinnerCnt(j)) = vntItemQName(i)
				strDinner(1, j, lngDinnerCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'��؁i�[�H�j
		If 234 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 264 Then
			j = 1
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDinnerCnt(j) = lngDinnerCnt(j) + 1
				If lngDinnerCnt(j) > UBound(strDinner, 3) Then
					Redim Preserve strDinner(1, 2, lngDinnerCnt(j))
				End If
				strDinner(0, j, lngDinnerCnt(j)) = vntItemQName(i)
				strDinner(1, j, lngDinnerCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'���؁i�[�H�j
		If 265 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 284 Then
			j = 2
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDinnerCnt(j) = lngDinnerCnt(j) + 1
				If lngDinnerCnt(j) > UBound(strDinner, 3) Then
					Redim Preserve strDinner(1, 2, lngDinnerCnt(j))
				End If
				strDinner(0, j, lngDinnerCnt(j)) = vntItemQName(i)
				strDinner(1, j, lngDinnerCnt(j)) = vntResult(i) & vntUnit(i)
			End If
		End If
		'�A���R�[����
		If 285 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 292 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngAlcoholCnt = lngAlcoholCnt + 1
				Redim Preserve strAlcohol(1, lngAlcoholCnt)
				strAlcohol(0, lngAlcoholCnt) = vntItemQName(i)
				strAlcohol(1, lngAlcoholCnt) = vntResult(i) & vntUnit(i)
			End If
		End If
'### 2004/01/23 Start K.Kagawa �����K���̒ǉ�
		'�����ɂ���
		If 293 <= CLng(vntGrpSeq(i)) And CLng(vntGrpSeq(i)) <= 294 Then
			If vntRslFlg(i) = "1" And vntResult(i) <> "" Then
				lngDrinkingCnt = lngDrinkingCnt + 1
				Redim Preserve strDrinking(1, lngDrinkingCnt)
				strDrinking(0, lngDrinkingCnt) = vntItemQName(i)
				strDrinking(1, lngDrinkingCnt) = vntResult(i) & vntUnit(i)
			End If
		End If
'### 2004/01/23 End
	Next

Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�h�{�w���`�H�K����f</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//�h�{�w����ʌĂяo��
function callMenEiyoShido() {
	var url;							// URL������

	url = '/WebHains/contents/interview/MenEiyoShido.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	location.href(url);

}

//OCR���͌��ʊm�F��ʌĂяo��
function callOcrNyuryoku() {
	var url;							// URL������

	url = '/WebHains/contents/Monshin/ocrNyuryoku.asp';
	url = url + '?rsvno=' + '<%= lngRsvNo %>';
	url = url + '&anchor=5';

	location.href(url);

}

// �W�����v
function JumpAnchor() {
	var PosY;

	PosY = document.getElementById('Anchor-FoodMenu').offsetTop;
	scrollTo(0, PosY);
}
//-->
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY>
<%
	'�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
	If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post"  STYLE="margin: 0px;">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"   VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"   VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"    VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="RslCnt"  VALUE="<%= lngRslCnt %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�h�{�w���`�H�K����f</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="900">
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
<%
'			<TD NOWRAP WIDTH="100%"><A HREF="JavaScript:callOcrNyuryoku()">OCR���͌��ʊm�F</A></TD>
			strURL = "/WebHains/contents/Monshin/ocrNyuryoku.asp"
			strURL = strURL & "?rsvno=" & lngRsvNo
			strURL = strURL & "&anchor=5"
%>
			<TD NOWRAP WIDTH="100%"><A HREF="<%= strURL %>" TARGET="_blank">OCR���͌��ʊm�F</A></TD>
			<TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
			<TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:JumpAnchor()">����</A></TD>
			<TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="10"></TD>
			<TD NOWRAP WIDTH="100%" ALIGN="right"><A HREF="JavaScript:callMenEiyoShido()">�h�{�w��</A></TD>
		</TR>
	</TABLE>

	<!-- �H�K����f�̕\�� -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="0">
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">�P�D�ێ�G�l���M�[�ɂ���</TD>
					</TR>
<%
	If strLimit(0) <> "" Then
%>
					<TR>
						<TD NOWRAP WIDTH="281"><%= strLimit(0) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee" WIDTH="143"><%= strLimit(1) %></TD>
					</TR>
<%
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">�Q�D�H�K���ɓ��Ă͂܂����</TD>
					</TR>
<%
	If lngShokusyukanCnt > 0 Then
		For i = 1 To lngShokusyukanCnt
			If strShokusyukan(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strShokusyukan(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strShokusyukan(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">�R�D�P���̚n�D�i�ێ��</TD>
					</TR>
<%
	If lngFavoriteCnt > 0 Then
		For i = 1 To lngFavoriteCnt
			If strFavorite(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strFavorite(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strFavorite(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
'### 2004/01/23 Start K.Kagawa �����K���̒ǉ�
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">�S�D�����ɂ���</TD>
					</TR>
<%
	If lngDrinkingCnt > 0 Then
		For i = 1 To lngDrinkingCnt
			If strDrinking(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strDrinking(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strDrinking(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
'### 2004/01/23 End
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">�T�D�P���̈����</TD>
					</TR>
<%
	If lngAlcoholCnt > 0 Then
		For i = 1 To lngAlcoholCnt
			If strAlcohol(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strAlcohol(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strAlcohol(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
					<TR HEIGHT="20">
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">�U�D�����i�̂P���ێ��</TD>
					</TR>
<%
	If lngDairyCnt > 0 Then
		For i = 1 To lngDairyCnt
			If strDairy(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP WIDTH="281"><%= strDairy(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strDairy(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
					<TR>
						<TD COLSPAN="2" NOWRAP BGCOLOR="#eeeeee" WIDTH="427" HEIGHT="20">�V�D�H���ɂ���</TD>
					</TR>
<%
	If lngMealCnt > 0 Then
		For i = 1 To lngMealCnt
			If strMeal(0, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strMeal(0, i) %></TD>
						<TD NOWRAP BGCOLOR="#eeeeee"><%= strMeal(1, i) %></TD>
					</TR>
<%
			End If
		Next
	Else
%>
					<TR>
						<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
					</TR>
<%
	End If
%>
				</TABLE>
			</TD>
		</TR>
	</TABLE>
	<BR>
	<SPAN ID="Anchor-FoodMenu" STYLE="position:relative"></SPAN>
	<TABLE WIDTH="21" BORDER="1" CELLSPACING="2" CELLPADDING="0">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" WIDTH="21" HEIGHT="21" ALT="" BORDER="0"></TD>
			<TD NOWRAP WIDTH="200">��H</TD>
			<TD NOWRAP WIDTH="200">���</TD>
			<TD NOWRAP WIDTH="200">����</TD>
		</TR>
		<TR>
			<TD BGCOLOR="#ffe4b5" ALIGN="center">���H</TD>
<%
	For j=0 To 2
%>
			<TD NOWRAP VALIGN="top" BGCOLOR="#ffe4b5">
				<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
<%
		For i = 1 To lngMorningCnt(j)
			If strMorning(0, j, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strMorning(0, j, i) %></TD>
						<TD NOWRAP></TD>
						<TD NOWRAP ALIGN="right" WIDTH="100%"><%= strMorning(1, j, i) %></TD>
					</TR>
<%
			End If
		Next
%>
				</TABLE>
			</TD>
<%
	Next
%>
		</TR>
		<TR>
			<TD BGCOLOR="#f0e68c" ALIGN="center">���H</TD>
<%
	For j=0 To 2
%>
			<TD NOWRAP VALIGN="top" BGCOLOR="#f0e68c">
				<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
<%
		For i = 1 To lngLunchCnt(j)
			If strLunch(0, j, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strLunch(0, j, i) %></TD>
						<TD NOWRAP></TD>
						<TD NOWRAP ALIGN="right" WIDTH="100%"><%= strLunch(1, j, i) %></TD>
					</TR>
<%
			End If
		Next
%>
				</TABLE>
			</TD>
<%
	Next
%>
		</TR>
		<TR>
			<TD BGCOLOR="#add8e6" ALIGN="center">�[�H</TD>
<%
	For j=0 To 2
%>
			<TD NOWRAP VALIGN="top" BGCOLOR="#add8e6">
				<TABLE BORDER="0" CELLSPACING="3" CELLPADDING="2">
<%
		For i = 1 To lngDinnerCnt(j)
			If strDinner(0, j, i) <> "" Then
%>
					<TR>
						<TD NOWRAP><%= strDinner(0, j, i) %></TD>
						<TD NOWRAP></TD>
						<TD NOWRAP ALIGN="right" WIDTH="100%"><%= strDinner(1, j, i) %></TD>
					</TR>
<%
			End If
		Next
%>
				</TABLE>
			</TD>
<%
	Next
%>
		</TR>
	</TABLE>
	<BR>
</FORM>
</BODY>
</HTML>
