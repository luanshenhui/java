<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		������� (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const ACTMODE_PREVIOUS = "previous"	'���샂�[�h(�O��f�҂�)
Const ACTMODE_NEXT     = "next"		'���샂�[�h(����f�҂�)
Const ACTMODE_SAVE     = "save"		'���샂�[�h(�ۑ�)
Const ACTMODE_SAVEEND  = "saveend"	'���샂�[�h(�ۑ�����)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objConsult			'��f���A�N�Z�X�p
Dim objJudgeMent		'���茋�ʃA�N�Z�X�p
Dim objJudgementControl	'���茋�ʃA�N�Z�X�p
Dim objJud				'����A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strActMode			'���샂�[�h
Dim lngCslYear			'��f��(�N)
Dim lngCslMonth			'��f��(��)
Dim lngCslDay			'��f��(��)
Dim strCntlNo			'�Ǘ��ԍ�
Dim strDayId			'����ID
Dim strKeyCsCd			'�R�[�X�R�[�h
Dim strSortKey			'�\����
Dim strBadJud			'�u����̈����l�v
Dim strUnFinished		'�u���薢�����ҁv
Dim strNoPrevNext		'�O���f�҂ւ̑J�ڂ��s��Ȃ�

'�ۑ����̂ݑ��M�����p�����[�^�l
Dim strRsvNo			'�\��ԍ�

'��f�ҏ��
Dim strPerId			'�l�h�c
Dim strCslDate			'��f��
Dim strCsCd				'�R�[�X�R�[�h
Dim strCsName			'�R�[�X��
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strBirth			'���N����
Dim strAge				'�N��
Dim strGender			'����
Dim strDoctorCd			'��t�R�[�h
Dim strDoctorName		'��t��

'���茋�ʏ��
Dim strJudClassCd		'���蕪�ރR�[�h
Dim strJudClassName		'���蕪�ޖ���
Dim strNoReason			'�������W�J�t���O(0:�W�J���Ȃ� 1:�W�J����)
Dim strJudCd			'����R�[�h
Dim strBefJudSName		'�O�񔻒薼��
Dim strJudDoctorCd		'�����R�[�h
Dim strJudDoctorName	'����㖼
Dim strFreeJudCmt		'�t���[����R�����g

' ��Updated 2002.11.18
Dim strJudCmtCd			'����R�����g�R�[�h
Dim strJudCmtStc		'����R�����g
Dim strGuidanceCd		'�w�����e�R�[�h
Dim strGuidanceStc		'�w�����e

Dim strStdJudCd			'��^�����R�[�h
Dim strStdJudNote		'��^��������
Dim strArrStdJudCd		'��^�����R�[�h�̔z��
Dim strArrStdJudNote	'��^�������̂̔z��
Dim lngAllCount			'�S���R�[�h����

Dim strInitdoctorCd		'�����ǂݍ��ݏ�Ԃ̑��������
Dim strInitJudCd		'�����ǂݍ��ݏ�Ԃ̔���
Dim strInitStdJudCd		'�����ǂݍ��ݏ�Ԃ̒�^����
Dim strInitFreeJudCmt	'�����ǂݍ��ݏ�Ԃ̃t���[����R�����g
Dim strInitJudDoctorCd	'�����ǂݍ��ݏ�Ԃ̔����R�[�h

' ��Updated 2002.11.18
Dim strInitJudCmtCd		'�����ǂݍ��ݏ�Ԃ̔���R�����g�R�[�h
Dim strInitGuidanceCd	'�����ǂݍ��ݏ�Ԃ̎w�����e�R�[�h

Dim strClearJudDoctor	'0:����㌻��ێ��A1:����R�[�h�N���A
Dim blnUpdated			'TRUE:�ύX����AFALSE:�ύX�Ȃ�
Dim i					'�C���f�b�N�X

'���ۂɍX�V���鍀�ڏ����i�[������������
Dim strUpdJudClassCd	'���蕪�ރR�[�h	
Dim strUpdJudCd			'����R�[�h
Dim strUpdStdJudCd		'��^�����R�[�h			--- �ՊC���g�p(2002.03.26)
Dim strUpdFreeJudCmt	'�t���[����R�����g
Dim strUpdJudDoctorCd	'�����R�[�h
Dim strUpdJudCmtCd      '����R�����g�R�[�h
Dim strUpdGuidanceCd    '�w�����̓R�[�h
Dim lngUpdCount			'�X�V���ڐ�

Dim strElementName		'�G�������g��
Dim strMessage			'�G���[���b�Z�[�W
Dim lngMessageType		'���b�Z�[�W�̑���
Dim strSecondFlg		'�Q�����f�\���t���O
Dim dtmCslDate			'��f��
Dim strPrevRsvNo		'(�O��f�҂�)�\��ԍ�
Dim strPrevDayId		'(�O��f�҂�)����ID
Dim strNextRsvNo		'(����f�҂�)�\��ԍ�
Dim strNextDayId		'(����f�҂�)����ID
Dim blnExists			'��f���̗L��
Dim strHTML				'HTML������
Dim strURL				'�W�����v���URL

Dim strArrJudCd			'����R�[�h
Dim strArrJudSName		'���藪��
Dim lngJudCount			'���萔
Dim lngJudIndex			'����C���f�b�N�X
Dim strDispJudSName		'���藪��
Dim j					'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon           = Server.CreateObject("HainsCommon.Common")
Set objConsult          = Server.CreateObject("HainsConsult.Consult")
Set objJudgement        = Server.CreateObject("HainsJudgement.Judgement")
Set objJudgementControl = Server.CreateObject("HainsJudgement.JudgementControl")
Set objJud              = Server.CreateObject("HainsJud.Jud")

'�S�����ǂݍ���
lngJudCount = objJud.SelectJudList(strArrJudCd, strArrJudSName)

'�����l�̎擾
strActMode    = Request("actMode")
lngCslYear    = Request("cslYear")
lngCslMonth   = Request("cslMonth")
lngCslDay     = Request("cslDay")
strCntlNo     = Request("cntlNo")
strDayId      = Request("dayId")
strKeyCsCd    = Request("csCd")
strSortKey    = Request("sortKey")
strBadJud     = Request("badJud")
strUnFinished = Request("unFinished")
strNoPrevNext = Request("noPrevNext")

'��f���̎擾
dtmCslDate = CDate(lngCslYear & "/" & lngCslMonth & "/" & lngCslDay)

'�u�Q�����f�͕\�����Ȃ��v�t���O�擾
strSecondFlg = objCommon.SelectBefJudCourseFlg()

'�ۑ����̂ݑ��M�����p�����[�^�l�̎擾
strRsvNo         = Request("rsvNo")
strDoctorCd      = Request("doctorCd")
strInitdoctorCd  = Request("initdoctorCd")

'���茋�ʏ��̎擾
strJudClassCd      = ConvIStringToArray(Request("judClassCd"))
strJudClassName    = ConvIStringToArray(Request("judClassName"))
strNoReason        = ConvIStringToArray(Request("noReason"))
strJudCd           = ConvIStringToArray(Request("judCd"))
strBefJudSName     = ConvIStringToArray(Request("befJudSName"))
strJudDoctorCd     = ConvIStringToArray(Request("judDoctorCd"))
strJudDoctorName   = ConvIStringToArray(Request("judDoctorName"))
'## 2003.03.07 Mod 6Lines By T.Takagi@FSIT �J���}�΍�
'strFreeJudCmt      = ConvIStringToArray(Request("freeJudCmt"))
strFreeJudCmt = Array()
ReDim Preserve strFreeJudCmt(Request("freeJudCmt").Count - 1)
For i = 1 To Request("freeJudCmt").Count
	strFreeJudCmt(i - 1) = Request("freeJudCmt")(i)
Next
'## 2003.03.07 Mod End

strStdJudCd        = ConvIStringToArray(Request("stdJudCd"))
strStdJudNote      = ConvIStringToArray(Request("stdJudNote"))
strInitJudCd       = ConvIStringToArray(Request("initJudCd"))
strInitStdJudCd    = ConvIStringToArray(Request("initStdJudCd"))
'## 2003.03.07 Mod 6Lines By T.Takagi@FSIT �J���}�΍�
'strInitFreeJudCmt  = ConvIStringToArray(Request("initFreeJudCmt"))
strInitFreeJudCmt = Array()
ReDim Preserve strInitFreeJudCmt(Request("initFreeJudCmt").Count - 1)
For i = 1 To Request("initFreeJudCmt").Count
	strInitFreeJudCmt(i - 1) = Request("initFreeJudCmt")(i)
Next
'## 2003.03.07 Mod End

strInitJudDoctorCd = ConvIStringToArray(Request("initJudDoctorCd"))
strClearJudDoctor  = ConvIStringToArray(Request("clearJudDoctor"))

' ��Updated 2002.11.18
strJudCmtCd        = ConvIStringToArray(Request("JudCmtCd"))
strGuidanceCd      = ConvIStringToArray(Request("GuidanceCd"))
strInitJudCmtCd    = ConvIStringToArray(Request("initJudCmtCd"))
strInitGuidanceCd  = ConvIStringToArray(Request("initGuidanceCd"))

' ��Updated 2002.12.17
strJudCmtStc       = ConvIStringToArray(Request("judCmtStc"))
strGuidanceStc     = ConvIStringToArray(Request("guidanceStc"))

lngAllCount = CLng("0" & Request("allCount"))

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	Do
		'�e���[�h���Ƃ̏�������
		Select Case strActMode

			'�ۑ��{�^��������
			Case ACTMODE_SAVE

				If lngAllCount > 0 Then

					'���ۂɍX�V���s�����ڂ݂̂𒊏o(�����\���f�[�^�ƈقȂ�f�[�^���X�V�Ώ�)
					lngUpdCount = 0
					strUpdJudClassCd  = Array()
					strUpdJudCd       = Array()
					strUpdStdJudCd    = Array()
					strUpdJudDoctorCd = Array()
					strUpdFreeJudCmt  = Array()
					strUpdJudCmtCd    = Array()
					strUpdGuidanceCd  = Array()

					For i = 0 To UBound(strJudClassCd)

						'����A�t���[����R�����g�A��^�����A�����A���ꂩ���X�V����Ă�����f�[�^�X�V
						blnUpdated = False
						If ( strJudCd(i)       <> strInitJudCd(i) ) Or _
						   ( strFreeJudCmt(i)  <> strInitFreeJudCmt(i) ) Or _
						   ( strJudDoctorCd(i) <> strInitJudDoctorCd(i) ) Or _
						   ( strJudCmtCd(i)    <> strInitJudCmtCd(i) ) Or _
						   ( strGuidanceCd(i)  <> strInitGuidanceCd(i) ) Then
							blnUpdated = True
						End If

						'�f�[�^�X�V��ԂȂ�z����g�����ĕۑ���Ԃ��Z�b�g
						If blnUpdated = True Then

							ReDim Preserve strUpdJudClassCd(lngUpdCount)
							ReDim Preserve strUpdJudCd(lngUpdCount)
							ReDim Preserve strUpdStdJudCd(lngUpdCount)
							ReDim Preserve strUpdFreeJudCmt(lngUpdCount)
							ReDim Preserve strUpdJudDoctorCd(lngUpdCount)
							ReDim Preserve strUpdJudCmtCd(lngUpdCount)
							ReDim Preserve strUpdGuidanceCd(lngUpdCount)

							strUpdJudClassCd(lngUpdCount)  = strJudClassCd(i)
							strUpdJudCd(lngUpdCount)       = strJudCd(i)
							strUpdStdJudCd(lngUpdCount)    = strStdJudCd(i)
							strUpdFreeJudCmt(lngUpdCount)  = strFreeJudCmt(i)
							strUpdJudCmtCd(lngUpdCount)    = strJudCmtCd(i)
							strUpdGuidanceCd(lngUpdCount)  = strGuidanceCd(i)

							'����オ�󔒁A���Ӑ}�I�ɏ����ĂȂ��Ȃ�A���O�C�����[�U�Z�b�g
							If ( Trim(strJudDoctorCd(i)) = "" ) And ( strClearJudDoctor(i) <> "1" ) Then
								strJudDoctorCd(i) = Session("userid")
							End If
							strUpdJudDoctorCd(lngUpdCount) = strJudDoctorCd(i)

							lngUpdCount = lngUpdCount + 1

						End If
					Next

					'������̓`�F�b�N
					strMessage = objJudgement.CheckValue(strDoctorCd, strJudClassCd, strJudClassName, strJudCd, strStdJudCd, strFreeJudCmt, strJudDoctorCd)
					If Not IsEmpty(strMessage) Then
						lngMessageType = MESSAGETYPE_WARNING
						Exit Do
					End If

					'���������̂ݍX�V���ꂽ�ꍇ�A�z��ɍX�V����Ȃ��l���Z�b�g
					If ( lngUpdCount < 1 ) And ( strdoctorCd <> strInitdoctorCd ) Then

						ReDim Preserve strUpdJudClassCd(lngUpdCount)
						ReDim Preserve strUpdJudCd(lngUpdCount)
						ReDim Preserve strUpdStdJudCd(lngUpdCount)
						ReDim Preserve strUpdFreeJudCmt(lngUpdCount)
						ReDim Preserve strUpdJudDoctorCd(lngUpdCount)

						strUpdJudClassCd(lngUpdCount)  = "XXXXX"
						strUpdJudCd(lngUpdCount)       = ""
						strUpdStdJudCd(lngUpdCount)    = ""
						strUpdFreeJudCmt(lngUpdCount)  = ""
						strUpdJudDoctorCd(lngUpdCount) = ""

					End If

					'�X�V�Ώۃf�[�^�����݂���Ƃ��̂ݔ��茋�ʕۑ�
					If ( lngUpdCount > 0 ) Or ( strdoctorCd <> strInitdoctorCd ) Then
						objJudgementControl.UpdateJudRsl strRsvNo, strDoctorCd, Session("USERID"), strUpdJudClassCd, strUpdJudCd, strUpdJudDoctorCd, strUpdFreeJudCmt, strUpdStdJudCd, strUpdJudCmtCd, strUpdGuidanceCd
					End If

				End If

				'�G���[���Ȃ���ΐe�t���[��REPLACE�p��URL��ҏW
				strURL = "judMain.asp"
				strURL = strURL & "?actMode="    & ACTMODE_SAVEEND
				strURL = strURL & "&cslYear="    & lngCslYear
				strURL = strURL & "&cslMonth="   & lngCslMonth
				strURL = strURL & "&cslDay="     & lngCslDay
				strURL = strURL & "&cntlNo="     & strCntlNo
				strURL = strURL & "&dayId="      & strDayId
				strURL = strURL & "&csCd="       & strKeyCsCd
				strURL = strURL & "&sortKey="    & strSortKey
				strURL = strURL & "&badJud="     & strBadJud
				strURL = strURL & "&unFinished=" & strUnFinished
				strURL = strURL & "&noPrevNext=" & strNoPrevNext

				'�e�t���[����URL��REPLACE����
				strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
				strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.replace('" & strURL & "')"">"
				strHTML = strHTML & "</BODY>"
				strHTML = strHTML & "</HTML>"
				Response.Write strHTML
				Response.End

			'�ۑ�������
			Case ACTMODE_SAVEEND

				'�ۑ��������b�Z�[�W��ҏW����
				strMessage     = "�ۑ����������܂����B"
				lngMessageType = MESSAGETYPE_NORMAL

		End Select

		Exit Do
	Loop

	'��t�������ƂɎ�f����ǂݍ���
	blnExists = objConsult.SelectConsultFromReceipt(dtmCslDate,    _
													strCntlNo,     _
													strDayId,      _
													strRsvNo,      _
													strCslDate,    _
													strPerID,      _
													strLastName,   _
													strFirstName,  _
													strLastKName,  _
													strFirstKName, _
													strBirth,      _
													strGender,     _
													strCsCd,       _
													strCsName,     _
													strAge,        _
													strDoctorCd,   _
									 				strDoctorName)

	'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
	If blnExists = False Then
		strMessage     = "��f��񂪑��݂��܂���B"
		lngMessageType = MESSAGETYPE_WARNING
		Exit Do
	End If

	'�ۑ����[�h�Ń`�F�b�N�G���[�����������ꍇ�̓e�[�u������ǂݍ��܂Ȃ�
	If strActMode = ACTMODE_SAVE And Not IsEmpty(strMessage) Then
		Exit Do
	End If

	'���������𖞂������茋�ʂ��擾
	lngAllCount = objJudgement.SelectJudRslList(strRsvNo, _
												strCsCd, _
												strSecondFlg, _
												strJudClassCd, _
												strJudClassName, _
												strNoReason, _
												strJudCd, _
												strBefJudSName, _
												strJudDoctorCd, _
												strJudDoctorName, _
												strFreeJudCmt, _
												strStdJudCd, _
												strStdJudNote, _
												strJudCmtCd, _
												strJudCmtStc, _
												strGuidanceCd, _
												strGuidanceStc)

	'�ǂݍ��񂾒���̔������������Ԃ̔z��Ƃ��ĕێ�
	strInitJudCd       = strJudCd
	strInitFreeJudCmt  = strFreeJudCmt
	strInitJudDoctorCd = strJudDoctorCd
	strInitdoctorCd    = strDoctorCd
	strInitJudCmtCd    = strJudCmtCd
	strInitGuidanceCd  = strGuidanceCd

	'�����񂪑��݂��Ȃ��ꍇ�̓��b�Z�[�W��ҏW����
	If lngAllCount = 0 Then
		strMessage     = "�\�����ׂ������񂪑��݂��܂���B"
		lngMessageType = MESSAGETYPE_WARNING
	End If

	Exit Do
Loop

'-------------------------------------------------------------------------------
' ���茋�ʈꗗ�̕ҏW
'-------------------------------------------------------------------------------
Sub EditJudRslList()

	Dim strURL	'�W�����v���URL
	Dim i		'�C���f�b�N�X
	Dim j		'�C���f�b�N�X

	'�Ώۃf�[�^�����݂��Ȃ��ꍇ�͉������Ȃ�
	If lngAllCount = 0 Then
		Exit Sub
	End If
%>
	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
			<TD>����</TD>
			<TD>����</TD>
			<TD>�R�����g�^�w�����e</TD>
		</TR>
<%
		For i = 0 To lngAllCount - 1

			strElementName = "stcName" & i
%>
			<TR>
				<TD VALIGN="top" NOWRAP>
					<INPUT TYPE="hidden" NAME="judClassCd"      VALUE="<%= strJudClassCd(i)      %>">
					<INPUT TYPE="hidden" NAME="judClassName"    VALUE="<%= strJudClassName(i)    %>">
					<INPUT TYPE="hidden" NAME="noReason"        VALUE="<%= strNoreason(i)        %>">
					<INPUT TYPE="hidden" NAME="stdJudCd"        VALUE="<%= strStdJudCd(i)        %>">
					<INPUT TYPE="hidden" NAME="stdJudNote"      VALUE="<%= strStdJudNote(i)      %>">
					<INPUT TYPE="hidden" NAME="befJudSName"     VALUE="<%= strBefJudSName(i)     %>">
					<INPUT TYPE="hidden" NAME="initJudCd"       VALUE="<%= strInitJudCd(i)       %>">
					<INPUT TYPE="hidden" NAME="initFreeJudCmt"  VALUE="<%= strInitFreeJudCmt(i)  %>">
					<INPUT TYPE="hidden" NAME="initJudDoctorCd" VALUE="<%= strInitJudDoctorCd(i) %>">
					<INPUT TYPE="hidden" NAME="clearJudDoctor"  VALUE="0">
					<INPUT TYPE="hidden" NAME="initJudCmtCd"    VALUE="<%= strInitJudCmtCd(i)   %>">
					<INPUT TYPE="hidden" NAME="initGuidanceCd"  VALUE="<%= strInitGuidanceCd(i) %>">
					<INPUT TYPE="hidden" NAME="judCmtCd"        VALUE="<%= strJudCmtCd(i)       %>">
					<INPUT TYPE="hidden" NAME="guidanceCd"      VALUE="<%= strGuidanceCd(i)     %>">
					<INPUT TYPE="hidden" NAME="judCmtStc"       VALUE="<%= strJudCmtStc(i)      %>">
					<INPUT TYPE="hidden" NAME="guidanceStc"     VALUE="<%= strGuidanceStc(i)    %>">
					<INPUT TYPE="hidden" NAME="judCd"           VALUE="<%= strJudCd(i)          %>">
					<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" BORDER="0" ALT=""><BR>
<%
					'���蕪��
					If strNoreason(i) = "0" Then
%>
						<A HREF="javascript:showRslHistory('<%= strJudClassCd(i) %>')"><B><%= strJudClassName(i) %></B></A><BR>
<%
					Else
%>
						<B><FONT COLOR="#666666"><%= strJudClassName(i) %></FONT></B>
<%
					End If
%>
				</TD>
				<!-- ���� -->
				<TD WIDTH="125" VALIGN="top">
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD><A HREF="javascript:callJudGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="����R�����g�K�C�h��\�����܂�"></A></TD>
							<TD><A HREF="javascript:deleteJudInfo(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�I����������R�����g���폜���܂�"></A></TD>
<%
							strElementName = "JudSName" & CStr(i)
							lngJudIndex = -1
							strDispJudSName = ""
							For j = 0 To lngJudCount - 1
								If strArrJudCd(j) = strJudCd(i) Then
									lngJudIndex = j
									Exit For
								End If
							Next

							If lngJudIndex >= 0 Then
								strDispJudSName = strArrJudSName(lngJudIndex)
							Else
								strDispJudSName = strJudCd(i)
							End If
%>
							<TD NOWRAP><SPAN ID="<%= strElementName %>"><%= strDispJudSName %></SPAN></TD>
						</TR>
					</TABLE>
				</TD>
				<!-- ����R�����g�i�Œ�j -->
				<TD>
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR VALIGN="top">
							<TD><A HREF="javascript:callJcmGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="����R�����g�K�C�h��\�����܂�"></A></TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return clearJudCmtCd(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�I����������R�����g���폜���܂�"></A></TD>
<%
							strElementName = "JudCmtStc" & CStr(i)
%>
							<TD>
								<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" BORDER="0" ALT=""><BR>
								<SPAN ID="<%= strElementName %>"><%= strJudCmtStc(i) %></SPAN>
							</TD>
						</TR>
						<!-- ����R�����g�i���[�v���j -->
						<TR>
							<TD COLSPAN="2"></TD>
							<TD><TEXTAREA NAME="freeJudCmt" COLS="50" ROWS="2"><%= strFreeJudCmt(i) %></TEXTAREA></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR>
				<TD COLSPAN="2" NOWRAP>
					<FONT SIZE="-1"><%= IIf(strBefJudSName(i) = "", "", "�O��F" & strBefJudSName(i)) %></FONT>
					<!-- ��^�����i�ꉞ�u���Ă����Ȃ��ƃG���[�ɂȂ邽�߁j -->
					<SELECT NAME="stdJudList" SIZE="3" STYLE="width:0;height:0;"></SELECT>
				</TD>
				<TD>
					<!-- �w������ -->
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR VALIGN="top">
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callGuidanceGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�w�����̓K�C�h��\�����܂�"></A></TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return clearGuidanceCd(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="�I�������w�����͂��폜���܂�"></A></TD>
<%
							strElementName = "GuidanceStc" & CStr(i)
%>
							<TD>
								<IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="3" BORDER="0" ALT=""><BR>
								<SPAN ID="<%= strElementName %>"><%= strGuidanceStc(i) %></SPAN>
							</TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR>
				<TD COLSPAN="2">
					<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
						<TR>
<%
							'���ʓ��͉�ʂ�URL�ҏW
							strURL = "/webHains/contents/result/rslMain.asp"
							strURL = strURL & "?rsvNo="      & strRsvNo
							strURL = strURL & "&mode="       & "1"
							strURL = strURL & "&code="       & strJudClassCd(i)
							strURL = strURL & "&cslYear="    & lngCslYear
							strURL = strURL & "&cslMonth="   & lngCslMonth
							strURL = strURL & "&cslDay="     & lngCslDay
							strURL = strURL & "&dayId="      & strDayId
							strURL = strURL & "&noPrevNext=" & "1"
%>
							<TD><A HREF="<%= strURL %>" TARGET="_blank"><IMG SRC="/webHains/images/result.gif" WIDTH="21" HEIGHT="21" ALT="���ʓ��͉�ʂֈړ����܂�"></A></TD>
							<TD><A HREF="<%= strURL %>" TARGET="_blank"><SPAN STYLE="font-size:10px">���̔���̌��ʓ���</SPAN></A></TD>
						<TR>
					</TABLE>
				</TD>
				<!-- ����� -->
				<TD ALIGN="right">
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
							<TD>
								<INPUT TYPE="hidden" NAME="judDoctorCd" VALUE="<%= strJudDoctorCd(i) %>">
								<INPUT TYPE="hidden" NAME="judDoctorName" VALUE="<%= strJudDoctorName(i) %>">
<%
								strElementName = "docName" & CStr(i)
%>
								<SPAN ID="<%= strElementName %>" STYLE="position:relative;font-weight:bolder;color:#999999"><%= strJudDoctorName(i) %></SPAN>
							</TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return callJudDocGuide(<%= i %>)"><IMG SRC="/webHains/images/doctor.gif" WIDTH="77" HEIGHT="24" ALT="<%= strJudClassName(i) %>�̔����t���w�肵�܂�"></A></TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return setJudDoctor(<%= i %>, '1')"><IMG SRC="/webHains/images/disme.gif" WIDTH="21" HEIGHT="21" ALT="���݂̃��O�C�����[�U�𔻒��ɃZ�b�g���܂�"></TD>
							<TD><A HREF="javascript:function voi(){};voi()" ONCLICK="return setJudDoctor(<%= i %>, '0')"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="<%= strJudClassName(i) %>�̔����t���N���A���܂�"></A></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			<TR><TD COLSPAN="3" HEIGHT="1" BGCOLOR="#FFFFFF"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2"></TD></TR>
			<TR><TD COLSPAN="3" HEIGHT="1" BGCOLOR="#999999"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD></TR>
			<TR><TD COLSPAN="3" HEIGHT="1" BGCOLOR="#FFFFFF"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="2"></TD></TR>
<%
		Next
%>
<!--
		<TR>
			<TD ALIGN="RIGHT" COLSPAN="6">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="return goNextPage()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
			</TD>
		</TR>
-->
	</TABLE>
<%
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>�������</TITLE>
<!-- #include virtual = "/webHains/includes/jcmGuide.inc" -->
<!-- #include virtual = "/webHains/includes/judGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/docGuide.inc" -->
<!-- #include virtual = "/webHains/includes/obsGuide.inc" -->
<!-- #include virtual = "/webHains/includes/guidanceGuide.inc" -->
<!--
var lngSelectedIndex;	// �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
var winJudHistory;		// ������E�C���h�E�n���h��
var winPerInspection;	// �l�������E�C���h�E�n���h��

// ����K�C�h�Ăяo��
function callJudGuide( index ) {

	if ( document.judgement.judCd.length != null ) {
		judGuide_ShowGuideJud( document.judgement.judCd[ index ], 'JudSName' + index );
	} else {
		judGuide_ShowGuideJud( document.judgement.judCd, 'JudSName' + index );
	}

}

// ����̍폜
function deleteJudInfo( index ) {

	if ( document.judgement.judCd.length != null ) {
		judGuide_clearJudInfo( document.judgement.judCd[ index ], 'JudSName' + index );
	} else {
		judGuide_clearJudInfo( document.judgement.judCd, 'JudSName' + index );
	}

}

// �����t���K�C�h�Ăяo��
function callDocGuide() {

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	docGuide_CalledFunction = setDocInfo;

	// �����t���K�C�h�\��
	showGuideDoc();
}

// ��t�R�[�h�E��t���̃Z�b�g
function setDocInfo() {

	var docNameElement;	// ��t����ҏW����G�������g�̖���
	var docName;		// ��t����ҏW����G�������g���g

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	document.judgement.doctorCd.value = docGuide_DoctorCd;
	document.judgement.doctorName.value = docGuide_DoctorName;

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		docNameElement = 'docName';

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(docNameElement).innerHTML = docGuide_DoctorName;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = docGuide_DoctorName;
		}

		break;
	}

	return false;
}

// ��t�R�[�h�E��t���̃N���A
function delDoctor() {

	document.judgement.doctorCd.value = '';
	document.judgement.doctorName.value = '';

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		docNameElement = 'docName';

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(docNameElement).innerHTML = '';
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = '';
		}

		break;
	}

}

// �����t���K�C�h�Ăяo��
function callJudDocGuide( index ) {

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(��t�R�[�h�E��t���̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex = index;

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	docGuide_CalledFunction = setJudDocInfo;

	// �����t���K�C�h�\��
	showGuideDoc();

	return false;
}

// ��t�R�[�h�E��t���̃Z�b�g
function setJudDocInfo() {

	var docNameElement;	/* ��t����ҏW����G�������g�̖��� */
	var docName;		/* ��t����ҏW����G�������g���g */

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( document.judgement.judDoctorCd.length != null ) {
		document.judgement.judDoctorCd[lngSelectedIndex].value = docGuide_DoctorCd;
	} else {
		document.judgement.judDoctorCd.value = docGuide_DoctorCd;
	}
	if ( document.judgement.judDoctorName.length != null ) {
		document.judgement.judDoctorName[lngSelectedIndex].value = docGuide_DoctorName;
	} else {
		document.judgement.judDoctorName.value = docGuide_DoctorName;
	}
	if ( document.judgement.clearJudDoctor.length != null ) {
		document.judgement.clearJudDoctor[lngSelectedIndex].value = '0';
	} else {
		document.judgement.clearJudDoctor.value = '0';
	}

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		docNameElement = 'docName' + lngSelectedIndex;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(docNameElement).innerHTML = '' + docGuide_DoctorName;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = '' + docGuide_DoctorName;
		}

		break;
	}

	return false;
}

// �����R�[�h�E�����t���̃N���A
function setJudDoctor( index, loginmode ) {

	var newcd
	var newname

	if ( loginmode == '0' ) {
		newcd   = '';
		newname = '';
	} else {
		newcd   = document.judgement.logIn.value;
		newname = document.judgement.logInName.value;
	}

	if ( document.judgement.judDoctorCd.length != null ) {
		document.judgement.judDoctorCd[index].value = newcd;
	} else {
		document.judgement.judDoctorCd.value = newcd;
	}

	if ( document.judgement.judDoctorName.length != null ) {
		document.judgement.judDoctorName[index].value = newname;
	} else {
		document.judgement.judDoctorName.value = newname;
	}

	if ( document.judgement.clearJudDoctor.length != null ) {
		document.judgement.clearJudDoctor[index].value = '1';
	} else {
		document.judgement.clearJudDoctor.value = '1';
	}

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		docNameElement = 'docName' + index;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(docNameElement).innerHTML = newname;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(docNameElement).innerHTML = newname;
		}

		break;
	}

	return false;
}

// �w�����̓K�C�h�Ăяo��
function callGuidanceGuide( index ) {

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�
	lngSelectedIndex = index;

	if ( document.judgement.judClassCd.length != null ) {
		guidanceGuide_JudClassCd = document.judgement.judClassCd[index].value;
	} else {
		guidanceGuide_JudClassCd = document.judgement.judClassCd.value;
	}

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	guidanceGuide_CalledFunction = setGuidanceStcInfo;

	// �����t���K�C�h�\��
	showGuideGuidance();

	return false;
}

// �w�����͂̃Z�b�g
function setGuidanceStcInfo() {

	var guidanceStcElement;

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( document.judgement.guidanceCd.length != null ) {
		document.judgement.guidanceCd[lngSelectedIndex].value = guidanceGuide_GuidanceCd;
		document.judgement.guidanceStc[lngSelectedIndex].value = guidanceGuide_GuidanceStc;
	} else {
		document.judgement.guidanceCd.value = guidanceGuide_GuidanceCd;
		document.judgement.guidanceStc.value = guidanceGuide_GuidanceStc;
	}

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		guidanceStcElement = 'GuidanceStc' + lngSelectedIndex;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(guidanceStcElement).innerHTML = guidanceGuide_GuidanceStc;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(guidanceStcElement).innerHTML = guidanceGuide_GuidanceStc;
		}

		break;
	}

	return false;
}

// �w�����͂̃N���A
function clearGuidanceCd( index ) {

	var guidanceStcElement;

	if ( document.judgement.guidanceCd.length != null ) {
		document.judgement.guidanceCd[index].value = '';
		document.judgement.guidanceStc[index].value = '';
	} else {
		document.judgement.guidanceCd.value = '';
		document.judgement.guidanceStc.value = '';
	}

	// �u���E�U���Ƃ̕ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		guidanceStcElement = 'GuidanceStc' + index;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(guidanceStcElement).innerHTML = '';
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(guidanceStcElement).innerHTML = '';
		}

		break;
	}

	return false;
}

// ����R�����g�K�C�h�Ăяo��
function callJcmGuide( index ) {

	var myForm = document.judgement;	// ����ʂ̃t�H�[���G�������g

	var judClassCd;		// ���蕪�ރR�[�h
	var judCmtCd;		// ����R�����g�R�[�h
	var judCmtStc;		// ����R�����g����
	var freeJudCmtStc;	// ����R�����g����(�t���[���͗p)
	var guidanceCd;		// �w�����e�R�[�h
	var guidanceStc;	// �w�����e
	var judCd;			// ����R�[�h
	var judSName;		// ����

	// �����̐ݒ�
	if ( myForm.judClassCd.length != null ) {
		judClassCd    = myForm.judClassCd[ index ].value;
		judCmtCd      = myForm.judCmtCd[ index ];
		freeJudCmtStc = myForm.freeJudCmt[ index ];
		guidanceCd    = myForm.guidanceCd[ index ];
		judCd         = myForm.judCd[ index ];
	} else {
		judClassCd    = myForm.judClassCd.value;
		judCmtCd      = myForm.judCmtCd;
		freeJudCmtStc = myForm.freeJudCmt;
		guidanceCd    = myForm.guidanceCd;
		judCd         = myForm.judCd;
	}

	judCmtStc   = 'JudCmtStc' + index;
	guidanceStc = 'GuidanceStc' + index;
	judSName    = 'JudSName' + index;

	// ����R�����g�K�C�h�\��
	jcmGuide_ShowGuideJcm( judClassCd, judCmtCd, judCmtStc, freeJudCmtStc, guidanceCd, guidanceStc, judCd, judSName );

}

// ����R�����g�R�[�h�̃N���A
function clearJudCmtCd( index ) {


	if ( document.judgement.judCmtCd.length != null ) {
		jcmGuide_clearJudCmtInfo( document.judgement.judCmtCd[ index ], 'JudCmtStc' + index );
// 2003.03.01 Added by Ishihara@FSIT
		document.judgement.freeJudCmt[ index ].value = '';
	} else {
		jcmGuide_clearJudCmtInfo( document.judgement.judCmtCd, 'JudCmtStc' + index );
// 2003.03.01 Added by Ishihara@FSIT
		document.judgement.freeJudCmt.value = '';
	}

}

// �ۑ�����
function goNextPage() {

	var stdJudList;
	var stdJudCd;
	var stdJudNote;

	var i;
	var j;

	for ( i = 0; i < document.judgement.allCount.value; i++ ) {

		// �e���ڂ̔z����쐬
		stdJudCd   = new Array();
		stdJudNote = new Array();

		stdJudList = document.judgement.stdJudList[i];

		if ( stdJudList != null ) {
			for ( j = 0; j < stdJudList.length; j++ ) {
				stdJudCd[stdJudCd.length] = stdJudList.options[j].value;
				stdJudNote[stdJudNote.length] = stdJudList.options[j].text;
			}
			document.judgement.stdJudCd[i].value   = stdJudCd.join(",");
			document.judgement.stdJudNote[i].value = stdJudNote.join(",");
		}

	}

	document.judgement.submit();

	return false;
}

// ���ʁ`���n��\���\��
function showRslHistory( judClassCd ) {

	var url;	// URL������

	// ���n��\����URL�ҏW
	url = '/webHains/contents/result/rslHistory.asp';
	url = url + '?rsvNo=<%= strRsvNo %>';
	url = url + '&gender=<%= strGender %>';
	url = url + '&secondFlg=<%= strSecondFlg %>';

	// ���蕪�ރR�[�h�w�莞�͈����ɒǉ����A���w�莞�͑S���ڎw����s��
	if ( judClassCd != null ) {
		url = url + '&judClassCd=' + judClassCd;
	} else {
		// �����\�����͂��ׂ�
		url = url + '&allResult=1';
	}

	// ���ʁ`���n��\����\��
	top.resultinfo.location.replace(url);
}

// �����\��
function showHistory( perId, Year, Month, Day ) {

	var opened = false;

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winJudHistory != null ) {
		if ( !winJudHistory.closed ) {
			opened = true;
		}
	}

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winJudHistory.focus();
	} else {
		winJudHistory = window.open('/webHains/contents/judgement/judHistory.asp?perId=' + perId + '&year=' + Year + '&month=' + Month + '&day=' + Day, '', 'width=650,height=500,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}

// �l�������\��
function showPerInspection(perId) {

	var opened = false;

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winPerInspection != null ) {
		if ( !winPerInspection.closed ) {
			opened = true;
		}
	}

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winPerInspection.focus();
	} else {
		winPerInspection = window.open('/webHains/contents/inquiry/inqPerInspection.asp?perId=' + perId, '', 'width=430,height=400,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}

// �O���f�҂̓��͉�ʂ�
function showPrevNextPage(actMode) {

	var myForm = document.judgement;	// ����ʂ̃t�H�[���G�������g
	var url;							// URL������

	// ������͉�ʂ�URL�ҏW
	url = 'judMain.asp';
	url = url + '?actMode='    + actMode;
	url = url + '&cslYear='    + myForm.cslYear.value;
	url = url + '&cslMonth='   + myForm.cslMonth.value;
	url = url + '&cslDay='     + myForm.cslDay.value;
	url = url + '&cntlNo='     + myForm.cntlNo.value;
	url = url + '&csCd='       + myForm.csCd.value;
	url = url + '&sortKey='    + myForm.sortKey.value;
	url = url + '&badJud='     + myForm.badJud.value;
	url = url + '&unFinished=' + myForm.unFinished.value;
	url = url + '&rsvNo='      + myForm.rsvNo.value;

	// �y�[�W�ړ�
	top.location.replace(url);
}

// �T�u��ʂ����
function closeWindow() {

	// �l��������ʂ����
	if ( winPerInspection != null ) {
		if ( !winPerInspection.closed ) {
			winPerInspection.close();
		}
	}

	// �������ʂ����
	if ( winJudHistory != null ) {
		if ( !winJudHistory.closed ) {
			winJudHistory.close();
		}
	}

	// �����t���K�C�h�����
	closeGuideDoc();

	// ��^�����K�C�h�����
//	closeGuideObs();

	// ����R�����g�K�C�h�����
	jcmGuide_closeGuideJcm();

	// �w�����̓K�C�h�����
	closeGuideGuidance();

	// ����K�C�h�����
	judGuide_closeGuideJud();

	winPerInspection = null;
	winJudHistory  = null;
}
//-->
</SCRIPT>
</HEAD>
<BODY BGCOLOR="#ffffff" ONLOAD="javascript:showRslHistory(null)" ONUNLOAD="javascript:closeWindow()">

<FORM NAME="judgement" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="actMode"    VALUE="<%= ACTMODE_SAVE  %>">
<INPUT TYPE="hidden" NAME="rsvNo"      VALUE="<%= strRsvNo      %>">
<INPUT TYPE="hidden" NAME="cslYear"    VALUE="<%= lngCslYear    %>">
<INPUT TYPE="hidden" NAME="cslMonth"   VALUE="<%= lngCslMonth   %>">
<INPUT TYPE="hidden" NAME="cslDay"     VALUE="<%= lngCslDay     %>">
<INPUT TYPE="hidden" NAME="cntlNo"     VALUE="<%= strCntlNo     %>">
<INPUT TYPE="hidden" NAME="dayId"      VALUE="<%= strDayId      %>">
<INPUT TYPE="hidden" NAME="csCd"       VALUE="<%= strKeyCsCd    %>">
<INPUT TYPE="hidden" NAME="sortKey"    VALUE="<%= strSortKey    %>">
<INPUT TYPE="hidden" NAME="badJud"     VALUE="<%= strBadJud     %>">
<INPUT TYPE="hidden" NAME="unFinished" VALUE="<%= strUnFinished %>">
<INPUT TYPE="hidden" NAME="noPrevNext" VALUE="<%= strNoPrevNext %>">
<INPUT TYPE="hidden" NAME="allCount"   VALUE="<%= lngAllCount   %>">
<INPUT TYPE="hidden" NAME="logIn"      VALUE="<%= Session("USERID") %>">
<INPUT TYPE="hidden" NAME="logInName"  VALUE="<%= Session("USERNAME") %>">

	<!-- �E�C���h�E�������o�� -->
	<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD VALIGN="TOP">
				<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
					<TR>
						<TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#000000">�������</FONT></B></TD>
					</TR>
				</TABLE>
			</TD>
			<TD WIDTH="5"></TD>
			<TD WIDTH="50">
<%
				'�O���f�҂ւ̑J�ڃ{�^���ҏW
				If strNoPrevNext = "" Then

					'�O���f�҂̗\��ԍ��E����ID�擾
					objConsult.SelectCurRsvNoPrevNext dtmCslDate,            _
													  strKeyCsCd,            _
													  strSortKey,            _
													  strCntlNo,             _
													  False,                 _
													  (strBadJud     <> ""), _
													  (strUnFinished <> ""), _
													  strRsvNo,              _
													  strPrevRsvNo,          _
													  strPrevDayId,          _
													  strNextRsvNo,          _
													  strNextDayId
%>
					<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
						<TR HEIGHT="25" VALIGN="TOP">
							<TD WIDTH="25">
<%
								'�O��f�҂����݂���ꍇ�̓{�^���\��
								If strPrevRsvNo <> "" Then
%>
									<A HREF="javascript:showPrevNextPage('<%= ACTMODE_PREVIOUS %>')"><IMG SRC="/webHains/images/review.gif" WIDTH="21" HEIGHT="21" ALT="�O�̎�f�҂�\��"></A>
<%
								End If
%>
							</TD>
							<TD WIDTH="25">
<%
								'����f�҂����݂���ꍇ�̓{�^���\��
								If strNextRsvNo <> "" Then
%>
									<A HREF="javascript:showPrevNextPage('<%= ACTMODE_NEXT %>')"><IMG SRC="/webHains/images/cue.gif" WIDTH="21" HEIGHT="21" ALT="���̎�f�҂�\��"></A>
<%
								End If
%>
							</TD>
						</TR>
					</TABLE>
<%
				End If
%>
			</TD>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	EditMessage strMessage, lngMessageType
%>
	<BR>
<%
	'��f���̕ҏW
	If blnExists Then
%>
		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>
				<TD>��f���F</TD>
				<TD><FONT COLOR="#ff6600"><B><%= dtmCslDate %></B></FONT></TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10"></TD>
				<TD>��f�R�[�X�F</TD>
				<TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10"></TD>
				<TD>����ID�F</TD>
				<TD><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strDayId, "0000") %></B></FONT></TD>
				<TD WIDTH="10"><IMG SRC="/webHains/images/spacer.gif" WIDTH="10"></TD>
				<TD>�\��ԍ��F</TD>
				<TD><FONT COLOR="#ff6600"><B><%= strRsvNo %></B></FONT></TD>
			</TR>
		</TABLE>

		<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="626">
			<TR>
				<TD COLSPAN="2"><IMG SRC="/webHains/images/spacer.gif" HEIGHT="3"></TD>
			</TR>
			<TR>
				<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="top"><%= strPerId %></TD>
				<TD NOWRAP><B><%= strLastName & "�@" & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "�@" & strFirstKName %></FONT>)</TD>
<%
				If lngAllCount > 0 Then
%>
					<TD ROWSPAN="2" VALIGN="bottom" ALIGN="right">
						<A HREF="javascript:function voi(){};voi()" ONCLICK="return goNextPage()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
					</TD>
<%
				End If
%>
			</TR>
			<TR>
				<TD NOWRAP><%= objCommon.FormatString(strBirth, "ge.m.d") %>���@<%= strAge %>�΁@<%= IIf(strGender = "1", "�j��", "����") %></TD>
			</TR>
		</TABLE>

		<BR>

		<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
			<TR>

<!--				<TD><A HREF="javaScript:showPerInspection('<%= strPerid %>')">�l��������\��</A></TD>-->
				<TD><A HREF="javaScript:showPerInspection('<%= strPerid %>')"><IMG SRC="/webHains/images/insinfo_b.gif" WIDTH="77" HEIGHT="24" ALT="�l���i�������Ȃǁj��\�����܂�"></A></TD>
				<TD WIDTH="10"></TD>
				<TD><A HREF="javaScript:showHistory('<%= strPerid %>','<%= lngCslYear %>','<%= lngCslMonth %>','<%= lngCslDay %>')"><IMG SRC="/webHains/images/oldJud.gif" WIDTH="77" HEIGHT="24" ALT="�ߋ��̔������\�����܂�"></A></TD>
<!--
				<TD>�b</TD>
				<TD><A HREF="/webHains/contents/disease/perDisease.asp?perId=<%= strPerid %>" TARGET="_top">�������E�Ƒ�����\��</A></TD>
-->
				<TD><IMG SRC="/webHains/images/spacer.gif" HEIGHT="1" WIDTH="20"></TD>
				<INPUT TYPE="hidden" NAME="doctorCd" VALUE="<%= strDoctorCd %>">
				<INPUT TYPE="hidden" NAME="initdoctorCd"  VALUE="<%= strInitdoctorCd %>">
<%
				If lngAllCount > 0 Then
%>
					<TD><A HREF="javascript:callDocGuide()"><IMG SRC="/webHains/images/doctor.gif" WIDTH="77" HEIGHT="23" ALT="�����t������"></A></TD>
					<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="2"></TD>
					<TD><A HREF="javascript:delDoctor()"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�����t���폜���܂�"></A></TD>
					<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5" HEIGHT="2"></TD>
<%
				End If
%>
				<INPUT TYPE="hidden" NAME="doctorName" VALUE="<%= strDoctorName %>">
				<TD><SPAN ID="docName" STYLE="position:relative"><%= strDoctorName %></SPAN></TD>
			</TR>
		</TABLE>
<%
	End If

	'���茋�ʈꗗ�ҏW
	Call EditJudRslList()
%>

</FORM>
</BODY>
</HTML>
