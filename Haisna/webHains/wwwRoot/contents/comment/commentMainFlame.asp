<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   ���R�����g  (Ver0.0.1)
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
Dim objHainsUser		'���[�U���A�N�Z�X�p
Dim objConsult			'��f�N���X
Dim objFree				'�ėp���A�N�Z�X�p

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
Dim lngDispMode			'�\�����[�h(0:�l�{�����f�{�ߋ���f, 1:�l�E��f�{�c�́{�_��,
						'           2:�l�E��f, 3:�l, 4:�c��, 5:�_��)
Dim strCmtMode			'�R�����g���[�h
Dim strAct				'�������
Dim	strWinMode			'�E�B���h�E���[�h
'### 2004/3/24 Added by Ishihara@FSIT �폜�f�[�^�\���Ή�
Dim lngIncDelNote		'1:�폜�f�[�^���\��
'### 2004/3/24 Added End

'���[�U���
Dim strUpdUser			'�X�V��
Dim lngAuthNote      	'�Q�Ɠo�^����
Dim lngDefNoteDispKbn	'�m�[�g�����\�����

'�ėp���
Dim strFreeField1		'�t�B�[���h�P
Dim strFreeField2		'�t�B�[���h�Q

Dim strStrDate			'�\������(�J�n)
Dim strEndDate			'�\������(�I��)

Dim vntCslDate			'��f��
Dim dtmStrDate			'�\������(�J�n)
Dim dtmEndDate			'�\������(�I��)
Dim dtmDate				'���t

Dim strUrlPara			'�t���[���ւ̃p�����[�^
Dim Ret
Dim strHtml				'Html������

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
Set objHainsUser	= Server.CreateObject("HainsHainsUser.HainsUser")

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
strCmtMode		= Request("cmtMode")
strAct			= Request("act")
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

	Select Case lngAuthNote
	Case 1		'��Â̂�
		lngDispKbn = lngAuthNote
	Case 2		'�����̂�
		lngDispKbn = lngAuthNote
	Case 3		'����
		'�p�����[�^�̂܂�
	Case Else
		strHtml = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHtml = strHtml & vbCrLf & "<HTML lang=""ja"">"
		strHtml = strHtml & "<BODY>"
		strHtml = strHtml & "<TABLE HEIGHT=""100%"" WIDTH=""100%"">"
		strHtml = strHtml & "<TR ALIGN=""center"" VALIGN=""center""><TD><B>�Q�Ɠo�^����������܂���</B></TD></TR>"
		strHtml = strHtml & "</TABLE>"
		strHtml = strHtml & "</BODY>"
		strHtml = strHtml & "</HTML>"
		Response.Write strHtml
		Response.End
	End Select

	'�\��ԍ��A�lID�A�c�̃R�[�h�A�_��p�^�[���R�[�h�̂ǂ���w�肳��Ă��Ȃ�
	If lngRsvNo = "0" & strPerId = "" And strOrgCd1 = "" And strOrgCd2 = "" And strCtrPtCd = "" Then
		Err.Raise 1000, , "�\��ԍ��A�lID�A�c�̃R�[�h�A�_��p�^�[���R�[�h�̂����ꂩ���K���w�肵�Ă�������"
	End If

	'�\��ԍ����w�肳��Ă���ꍇ�A��f��񂩌lID�A�c�̃R�[�h�A�_��p�^�[���R�[�h���擾
	If  lngRsvNo <> "0" Then
		Set objConsult	= Server.CreateObject("HainsConsult.Consult")

		'��f���̎擾
		Ret = objConsult.SelectConsult( lngRsvNo, _
										, _
										vntCslDate, _
										strPerId, _
										, , _
										strOrgCd1, _
										strOrgCd2, _
										, , , , , , , , , , , , , , , , , , , _
										0, _
										, , , , , , , , , , , , _
										strCtrPtCd )
		If Ret = False Then
			Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
		End If
	End If


	If strAct = "" Then
		'����\�����ɕ\�����Ԃ��w�肳��Ă��Ȃ��Ƃ��́A�f�t�H���g�Ƃ��Ĕėp�e�[�u���ɐݒ肳��Ă�����t�Ƃ���

		'�ėp�e�[�u������\�����Ԃ�ǂݍ���
		Set objFree = Server.CreateObject("HainsFree.Free")
		If objFree.SelectFree(0, "CMTPERIOD", , , , strFreeField1, strFreeField2) = 1 Then
			If strFreeField2 <> "" Then
				If CLng(strFreeField2) < 0 Then
					'�ߋ�
					If lngStrYear = 0 And lngStrMonth = 0 And lngStrDay = 0 Then
                        '### 2004/9/22 �C���i���j
                        '### �c�̂ƌ_��֌W�̃R�����g�̏ꍇ�f�t�H���g�\�����t�𓖓��ɓ��ꂵ�ĕ\������悤�ɏC��
'                        lngStrYear  = Year(DateAdd(strFreeField1, strFreeField2, Date))
'                        lngStrMonth = Month(DateAdd(strFreeField1, strFreeField2, Date))
'                        lngStrDay   = Day(DateAdd(strFreeField1, strFreeField2, Date))
                        If lngDispMode = 4 Or lngDispMode = 5 Then
                            lngStrYear  = Year(Date)
                            lngStrMonth = Month(Date)
                            lngStrDay   = Day(Date)
                        Else
                            lngStrYear  = Year(DateAdd(strFreeField1, strFreeField2, Date))
                            lngStrMonth = Month(DateAdd(strFreeField1, strFreeField2, Date))
                            lngStrDay   = Day(DateAdd(strFreeField1, strFreeField2, Date))
                        End If
                    End If
					If lngEndYear = 0 Or lngEndMonth = 0 Or lngEndDay = 0 Then
						lngEndYear  = Year(Date)
						lngEndMonth = Month(Date)
						lngEndDay   = Day(Date)
					End If
				Else
					'����
					If lngStrYear = 0 And lngStrMonth = 0 And lngStrDay = 0 Then
						lngStrYear  = Year(Date)
						lngStrMonth = Month(Date)
						lngStrDay   = Day(Date)
					End If
					If lngEndYear = 0 Or lngEndMonth = 0 Or lngEndDay = 0 Then
                        '### 2004/9/22 �C���i���j
                        '### �c�̂ƌ_��֌W�̃R�����g�̏ꍇ�f�t�H���g�\�����t�𓖓��ɓ��ꂵ�ĕ\������悤�ɏC��
						'lngEndYear  = Year(DateAdd(strFreeField1, strFreeField2, Date))
						'lngEndMonth = Month(DateAdd(strFreeField1, strFreeField2, Date))
						'lngEndDay   = Day(DateAdd(strFreeField1, strFreeField2, Date))
                        If lngDispMode = 4  Or lngDispMode = 5 Then
                            lngEndYear  = Year(Date)
                            lngEndMonth = Month(Date)
                            lngEndDay   = Day(Date)
                        Else
						    lngEndYear  = Year(DateAdd(strFreeField1, strFreeField2, Date))
						    lngEndMonth = Month(DateAdd(strFreeField1, strFreeField2, Date))
						    lngEndDay   = Day(DateAdd(strFreeField1, strFreeField2, Date))
                        End If
					End If
				End If
			End If
		End If

		strAct = "search"

	Else
		If lngStrYear <> 0 And lngStrMonth <> 0 And lngStrDay <> 0 Then
			If Not IsDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay) Then
				Err.Raise 1000, , "�\�����Ԃ̎w��Ɍ�肪����܂��B"
			End If

			strStrDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
			dtmStrDate = CDate(lngStrYear & "/" & lngStrMonth & "/" & lngStrDay)
		Else
			strStrDate = ""
			dtmStrDate = 0
		End If

		If lngEndYear <> 0 Or lngEndMonth <> 0 Or lngEndDay <> 0 Then
			If Not IsDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay) Then
				Err.Raise 1000, , "�\�����Ԃ̎w��Ɍ�肪����܂��B"
			End If

			strEndDate = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay
			dtmEndDate = CDate(lngEndYear & "/" & lngEndMonth & "/" & lngEndDay)
		Else
			strEndDate = ""
			dtmEndDate = 0
		End If

		'�I�������ݒ莞�͉������Ȃ�
		If dtmEndDate <> 0 Then
			'�J�n�����ݒ�A�܂��͊J�n�����I�������ߋ��ł����
			If dtmStrDate = 0 Or dtmStrDate > dtmEndDate Then

				'�l������
				dtmDate    = dtmStrDate
				dtmStrDate = dtmEndDate
				dtmEndDate = dtmDate

			End If

			'�X�ɓ��l�̏ꍇ�A�I�����̓N���A
'			If dtmStrDate = dtmEndDate Then
'				dtmEndDate = 0
'			End If
		End If

		'��̏����̂��߂ɔN�������ĕҏW
		If dtmStrDate <> 0 Then
			lngStrYear  = Year(dtmStrDate)
			lngStrMonth = Month(dtmStrDate)
			lngStrDay   = Day(dtmStrDate)
		Else
			lngStrYear  = 0
			lngStrMonth = 0
			lngStrDay   = 0
		End If

		If dtmEndDate <> 0 Then
			lngEndYear  = Year(dtmEndDate)
			lngEndMonth = Month(dtmEndDate)
			lngEndDay   = Day(dtmEndDate)
		Else
			lngEndYear  = 0
			lngEndMonth = 0
			lngEndDay   = 0
		End If
	End If

	'�t���[���ւ̃p�����[�^�ݒ�
	strUrlPara = "?rsvno=" & lngRsvNo
	strUrlPara = strUrlPara & "&perid=" & strPerId 
	strUrlPara = strUrlPara & "&orgcd1=" & strOrgCd1
	strUrlPara = strUrlPara & "&orgcd2=" & strOrgCd2
	strUrlPara = strUrlPara & "&ctrptcd=" & strCtrPtCd
	strUrlPara = strUrlPara & "&StrYear=" & lngStrYear
	strUrlPara = strUrlPara & "&StrMonth=" & lngStrMonth
	strUrlPara = strUrlPara & "&StrDay=" & lngStrDay
	strUrlPara = strUrlPara & "&EndYear=" & lngEndYear
	strUrlPara = strUrlPara & "&EndMonth=" & lngEndMonth
	strUrlPara = strUrlPara & "&EndDay=" & lngEndDay
	strUrlPara = strUrlPara & "&PubNoteDivCd=" & strPubNoteDivCd
	strUrlPara = strUrlPara & "&PubNoteDivCdCtr=" & strPubNoteDivCdCtr
	strUrlPara = strUrlPara & "&PubNoteDivCdOrg=" & strPubNoteDivCdOrg
	strUrlPara = strUrlPara & "&DispKbn=" & lngDispKbn
'### 2004/3/24 Added by Ishihara@FSIT �폜�f�[�^�\���Ή�
	strUrlPara = strUrlPara & "&IncDelNote=" & lngIncDelNote
'### 2004/3/24 Added End
	strUrlPara = strUrlPara & "&dispmode=" & lngDispMode
	strUrlPara = strUrlPara & "&cmtMode=" & strCmtMode
	strUrlPara = strUrlPara & "&winmode=" & strWinMode

Exit Do
Loop
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>���R�����g</TITLE>
<script type="text/javascript">
var params = {
    rsvno:           "<%= lngRsvNo %>",
    perid:           "<%= strPerId %>",
    orgcd1:          "<%= strOrgCd1 %>",
    orgcd2:          "<%= strOrgCd2 %>",
    ctrptcd:         "<%= strCtrPtCd %>",
    StrYear:         "<%= lngStrYear %>",
    StrMonth:        "<%= lngStrMonth %>",
    StrDay:          "<%= lngStrDay %>",
    EndYear:         "<%= lngEndYear %>",
    EndMonth:        "<%= lngEndMonth %>",
    EndDay:          "<%= lngEndDay %>",
    PubNoteDivCd:    "<%= strPubNoteDivCd %>",
    PubNoteDivCdCtr: "<%= strPubNoteDivCdCtr %>",
    PubNoteDivCdOrg: "<%= strPubNoteDivCdOrg %>",
    DispKbn:         "<%= lngDispKbn %>",
    dispmode:        "<%= lngDispMode %>",
    IncDelNote:      "<%= lngIncDelNote %>",
    cmtMode:         "<%= strCmtMode %>",
    winmode:         "<%= strWinMode %>",
    act:             "<%= strAct %>"
};
</script>
<LINK REL="stylesheet" TYPE="text/css" HREF="../css/default.css">
</HEAD>
<%
	Select Case lngDispMode
	Case 0		'�l�{�����f�{�ߋ���f
%>
	<FRAMESET ROWS="175,*,*,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=1">
		<FRAME NAME="List2"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=2">
		<FRAME NAME="List3"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=3">
<%
	Case 1		'�l�E��f�{�c�́{�_��
%>
	<FRAMESET ROWS="175,*,*,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=4">
		<FRAME NAME="List2"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=5">
		<FRAME NAME="List3"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=6">
<%
	Case 2		'�l�E��f�i�ʐڎx���̃`���[�g���A���ӎ�����p�j
%>
	<FRAMESET BORDER="0" FRAMESPACING="0" FRAMEBORDER="no" ROWS="<%= IIf(strWinMode="1",190,115) %>,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=4">
<%
	Case 3		'�l
%>
	<FRAMESET ROWS="175,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=1">
<%
	Case 4		'�c��
%>
	<FRAMESET ROWS="175,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=5">
<%
	Case 5		'����
%>
	<FRAMESET ROWS="175,*">
		<FRAME NAME="header" NORESIZE SRC="/WebHains/contents/comment/commentList_Header.asp<%= strUrlPara %>">
		<FRAME NAME="List1"  NORESIZE SRC="/WebHains/contents/comment/commentList_Body.asp<%= strUrlPara %>&type=6">

<%
	End Select
%>
		<NOFRAMES>
			<BODY BGCOLOR="#ffffff">
				<P></P>
			</BODY>
		</NOFRAMES>
	</FRAMESET>
</HTML>
