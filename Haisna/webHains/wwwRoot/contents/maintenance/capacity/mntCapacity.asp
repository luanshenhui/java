<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\��g�o�^ (Ver0.0.1)
'		AUTHER  : Miyoshi Jun@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"    -->
<!-- #include virtual = "/webHains/includes/common.inc"          -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"     -->
<!-- #include virtual = "/webHains/includes/EditNumberList.inc"  -->
<!-- #include virtual = "/webHains/includes/EditTimeFraList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
'�����l
Dim strAction			'������ԁi�ۑ��{�^��������:"save"�C�ۑ�������:"saveend"�j
Dim lngYear				'��f�J�n�N
Dim lngMonth			'��f�J�n��
Dim lngTimeFra			'���Ԙg
Dim strRsvFraCd			'�\��g�R�[�h

'�t�H�[�����i�o�n�r�s�`���ő��M������ʓ��͒l�j
Dim strEditYear			'�ҏW�N
Dim strEditMonth		'�ҏW��
Dim strEditDay			'�ҏW��
Dim strEndDay			'����
Dim lngHoliday			'�a�@�ݒ�l�i0:���ݒ�C1:�x�f���C2:�j���j
Dim lngArrHoliday		'�P���`�����̕a�@�ݒ�l�i0:���ݒ�C1:�x�f���C2:�j���j
Dim strEmptyCount		'�\��ݒ�l�i"hidden":��\���C"":���ݒ�C"0":�\��s�C"1"�`"999":�\��\�j
Dim strArrEmptyCount	'�P���`�����̗\��ݒ�l�i"hidden":��\���C"":���ݒ�C"0":�\��s�C"1"�`"999":�\��\�j
Dim strCheckType		'���Ԙg�Ǘ�����Ă��邩�ۂ��̔���i"":���ݒ�C"0":�I���Ǘ��C"1":���Ԙg�Ǘ��j

'COM�I�u�W�F�N�g
Dim objSchedule			'�X�P�W���[���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objCommon			'���ʊ֐��A�N�Z�X�pCOM�I�u�W�F�N�g

'ini�t�@�C���ǂݍ���
Dim strHolidayFlg		'�x���E�j���ɑ΂���\��̋���

'�\��g�f�[�^�ǂݍ���
Dim strRsvFraName		'�\��g����
Dim lngOverRsv			'�g�l���I�[�o�[�o�^
Dim lngFraType			'�g�Ǘ��^�C�v
Dim lngDefCnt0			'�f�t�H���g�l���i���ԑјg�O�j
Dim lngDefCnt1			'�f�t�H���g�l���i���ԑјg�P�j
Dim lngDefCnt2			'�f�t�H���g�l���i���ԑјg�Q�j
Dim lngDefCnt3			'�f�t�H���g�l���i���ԑјg�R�j
Dim lngDefCnt4			'�f�t�H���g�l���i���ԑјg�S�j
Dim lngDefCnt5			'�f�t�H���g�l���i���ԑјg�T�j
Dim lngDefCnt6			'�f�t�H���g�l���i���ԑјg�U�j
Dim lngDefCnt7			'�f�t�H���g�l���i���ԑјg�V�j
Dim lngDefCnt8			'�f�t�H���g�l���i���ԑјg�W�j
Dim lngDefCnt9			'�f�t�H���g�l���i���ԑјg�X�j
Dim lngDefCnt			'�f�t�H���g�l��
Dim blnRetCd			'���^�[���R�[�h

'�X�P�W���[�����O�f�[�^�ǂݍ���
Dim strStrDate			'�ǂݍ��݊J�n���t
Dim strEndDate			'�ǂݍ��ݏI�����t
Dim vntCslDate			'��f��
Dim vntHoliday			'�x�f��
Dim vntTimeFra			'���Ԙg
Dim vntRsvFraCd			'�\��g�R�[�h
Dim vntEmptyCount		'�\��\�l��
Dim vntRsvCount			'�\��ςݐl��
Dim lngCount			'���R�[�h��

'���̓`�F�b�N
Dim strArrMessage		'�G���[���b�Z�[�W
Dim strArrMessage2		'�x�����b�Z�[�W

Dim strClass			'CLASS�����ҏW�p
Dim strURL				'�W�����v���URL
Dim i, j, k				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�����l�̎擾
strAction   = Request("action") & ""
lngYear     = Request("year") & ""
lngYear     = CLng(IIf(lngYear = "", Year(Date), lngYear))
lngMonth    = Request("month") & ""
lngMonth    = CLng(IIf(lngMonth = "", Month(Date), lngMonth))
lngTimeFra  = Request("timeFra") & ""
lngTimeFra  = CLng(IIf(lngTimeFra = "", TIME_FRA_NON, lngTimeFra))
strRsvFraCd = Request("rsvFraCd") & ""

'�����ݒ�
lngArrHoliday = Empty
strArrEmptyCount = Empty
strArrMessage = Empty
strArrMessage2 = Empty

'ini�t�@�C���ǂݍ��݁i�x���E�j���ɑ΂���\��̋��j
Set objCommon = Server.CreateObject("HainsCommon.Common")
strHolidayFlg = objCommon.SelectHolidayFlg
Set objCommon = Nothing

'�X�P�W���[���A�N�Z�X�pCOM�I�u�W�F�N�g�̊��蓖��
Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do
	'���O����
	If strRsvFraCd = "ALL" Then			'�a�@�X�P�W���[�����O

		'���Ԙg�̎w��͖���
		lngTimeFra = CLng(TIME_FRA_NON)

	ElseIf strRsvFraCd <> "" Then		'�\��X�P�W���[�����O

		'�w��\��g�R�[�h�̗\��g�����擾����
		blnRetCd = objSchedule.SelectRsvFra(strRsvFraCd, strRsvFraName, lngOverRsv, lngFraType, lngDefCnt0, lngDefCnt1, lngDefCnt2, lngDefCnt3, lngDefCnt4, lngDefCnt5, lngDefCnt6, lngDefCnt7, lngDefCnt8, lngDefCnt9)

		'�ǂݍ��݃G���[���͏����𔲂���
		If blnRetCd <> True Then
			strArrMessage = Array("�����Ŏw�肳�ꂽ�\��g�R�[�h���s���ł��B[" & strRsvFraCd & "]")
			strRsvFraCd = ""
			Exit Do
		End If

		'�g�Ǘ��^�C�v���R�[�X�g�Ǘ��łȂ����i�������ژg�Ǘ��̎��j�A���Ԙg�́u�O�F�I���v�̂ݗL��
		If lngFraType <> FRA_TYPE_CS Then
			'�\���{�^���������A�܂��͕ۑ�������́A���Ԙg�̎w��͖���
			If strAction <> "save" Then
				lngTimeFra = CLng(TIME_FRA_NON)
			'�ۑ��{�^���������A���Ԙg�́u�O�F�I���v�ȊO�G���[
			Else
				If lngTimeFra <> TIME_FRA_NON Then
					strArrMessage = Array("�������̗\��g�u" & strRsvFraName & "�v�̘g�Ǘ��^�C�v���������ژg�Ǘ��ɕύX����܂����B")
					i = UBound(strArrMessage) + 1
					ReDim Preserve strArrMessage(i)
					strArrMessage(i) = "�����͒��f����܂����B������x��蒼���ĉ������B"
					strRsvFraCd = ""
					Exit Do
				End If
			End If
		End If

		'�Y���̎��Ԙg�̃f�t�H���g�l��
		Select	Case 	lngTimeFra
			Case 0
				lngDefCnt = lngDefCnt0
			Case 1
				lngDefCnt = lngDefCnt1
			Case 2
				lngDefCnt = lngDefCnt2
			Case 3
				lngDefCnt = lngDefCnt3
			Case 4
				lngDefCnt = lngDefCnt4
			Case 5
				lngDefCnt = lngDefCnt5
			Case 6
				lngDefCnt = lngDefCnt6
			Case 7
				lngDefCnt = lngDefCnt7
			Case 8
				lngDefCnt = lngDefCnt8
			Case 9
				lngDefCnt = lngDefCnt9
			Case Else
				lngDefCnt = lngDefCnt0
		End Select

		'�a�@�X�P�W���[�����O�f�[�^�ǂݍ���
		GetLngArrHoliday

	End If

	'�ۑ��{�^��������
	If strAction = "save" Then

		'�t�H�[�����i�o�n�r�s�`���ő��M���ꂽ��ʓ��͒l�j�̎擾
		If strRsvFraCd = "ALL" Then			'�a�@�X�P�W���[�����O

			'�w��N��
			strEditYear = CStr(lngYear)
			strEditMonth = CStr(lngMonth)

			'�X�^�[�g���i�擪�����j�������擾�j
			strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")

			'������
			strEndDay = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))

			'�P�T�Ԃ��Ƃɏ������s���i�ő�U�T����̂Łj
			For j = 1 To 6

				'�P�����Ƃɏ������s��
				For k = 1 To 7

					strEditDay = strEditDay + 1

					If strEditDay >= 1 And strEditDay <= strEndDay Then
						If IsEmpty(lngArrHoliday) Then
							lngArrHoliday = Array(CLng(Request("day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k) & ""))
						Else
							i = UBound(lngArrHoliday) + 1
							ReDim Preserve lngArrHoliday(i)
							lngArrHoliday(i) = CLng(Request("day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k) & "")
						End If
					End If

				Next 

			Next

		ElseIf strRsvFraCd <> "" Then		'�\��X�P�W���[�����O

			'�w��N��
			strEditYear = CStr(lngYear)
			strEditMonth = CStr(lngMonth)

			'�X�^�[�g���i�擪�����j�������擾�j
			strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")

			'������
			strEndDay = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))

			'�P�T�Ԃ��Ƃɏ������s���i�ő�U�T����̂Łj
			For j = 1 To 6

				'�P�����Ƃɏ������s��
				For k = 1 To 7

					strEditDay = strEditDay + 1

					If strEditDay >= 1 And strEditDay <= strEndDay Then
						If IsEmpty(strArrEmptyCount) Then
							strArrEmptyCount = Array(Request("day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k) & "")
						Else
							i = UBound(strArrEmptyCount) + 1
							ReDim Preserve strArrEmptyCount(i)
							strArrEmptyCount(i) = Request("day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k) & ""
						End If
					End If

				Next 

			Next

		End If

		'���̓`�F�b�N
		If strRsvFraCd = "ALL" Then			'�a�@�X�P�W���[�����O

			strArrMessage = objSchedule.CheckValueSchedule_h((strEditYear & "/" & strEditMonth & "/1"), (strEditYear & "/" & strEditMonth & "/" & strEndDay), lngArrHoliday, strArrMessage2)

		ElseIf strRsvFraCd <> "" Then		'�\��X�P�W���[�����O

			strArrMessage = objSchedule.CheckValueSchedule((strEditYear & "/" & strEditMonth & "/1"), (strEditYear & "/" & strEditMonth & "/" & strEndDay), lngTimeFra, strRsvFraCd, strArrEmptyCount, strArrMessage2)
			'�x�����b�Z�[�W�͕\���s�v�i�\���K�v�Ȃ牺�̂P�s���R�����g�ɂ���j
			strArrMessage2 = Empty

		End If

		'�`�F�b�N�G���[���͏����𔲂���
		If Not IsEmpty(strArrMessage) Then
			Exit Do
		End If

		'�ۑ�����
		If strRsvFraCd = "ALL" Then			'�a�@�X�P�W���[�����O

			objSchedule.UpdateSchedule_h (strEditYear & "/" & strEditMonth & "/1"), (strEditYear & "/" & strEditMonth & "/" & strEndDay), lngArrHoliday

		ElseIf strRsvFraCd <> "" Then		'�\��X�P�W���[�����O

			objSchedule.UpdateSchedule_tk (strEditYear & "/" & strEditMonth & "/1"), (strEditYear & "/" & strEditMonth & "/" & strEndDay), lngTimeFra, strRsvFraCd, strArrEmptyCount, strArrMessage
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

		End If

		'�ۑ��ɐ��������ꍇ�A�ۑ������ヂ�[�h�֑J��
		strURL = Request.ServerVariables("SCRIPT_NAME")
		strURL = strURL & "?year="     & lngYear
		strURL = strURL & "&month="    & lngMonth
		strURL = strURL & "&timeFra="  & lngTimeFra
		strURL = strURL & "&rsvFraCd=" & strRsvFraCd
		strURL = strURL & "&action="   & "saveend"
		Response.Redirect strURL
		Response.End

	End If

	'�f�[�^�ǂݍ���
	If strRsvFraCd = "ALL" Then			'�a�@�X�P�W���[�����O

		'�a�@�X�P�W���[�����O�f�[�^�ǂݍ���
		lngArrHoliday = Empty
		GetLngArrHoliday

	ElseIf strRsvFraCd <> "" Then		'�\��X�P�W���[�����O

		'�\��X�P�W���[�����O�f�[�^�ǂݍ���
		strArrEmptyCount = Empty
		GetStrArrEmptyCount

	End If

	Exit Do
Loop

'�X�P�W���[���A�N�Z�X�pCOM�I�u�W�F�N�g�̉��
Set objSchedule = Nothing

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �a�@�X�P�W���[�����O�f�[�^�ǂݍ���
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : �Ȃ�
'
' ���l�@�@ : lngArrHoliday �ɂP���`�����̕a�@�ݒ�l��ҏW����
' �@�@�@�@ : �i0:���ݒ�C1:�x�f���C2:�j���j
'
'-------------------------------------------------------------------------------
Sub GetLngArrHoliday()

	'�w��N���̂P�����疖��
	strStrDate = CStr(lngYear) & "/" & CStr(lngMonth) & "/1"
	strEndDate = CStr(lngYear) & "/" & CStr(lngMonth) & "/" & CStr(Day(DateAdd("d", -1, DateAdd("m", 1, CStr(lngYear) & "/" & CStr(lngMonth) & "/1"))))

	'�w����Ԃ̕a�@�X�P�W���[�����O�����擾����
	lngCount = objSchedule.SelectSchedule_h(strStrDate, strEndDate, vntCslDate, vntHoliday)

	'�P���`�����̐ݒ�l�𔻒�
	k = 0
	For j = 1 To Day(DateAdd("d", -1, DateAdd("m", 1, CStr(lngYear) & "/" & CStr(lngMonth) & "/1")))
		lngHoliday = HOLIDAY_NON
		If k < lngCount Then
			If DateValue(vntCslDate(k)) = DateValue(CStr(lngYear) & "/" & CStr(lngMonth) & "/" & CStr(j)) Then
				lngHoliday = vntHoliday(k)
				k = k + 1
			End if
		End If
		'�P���`�����̐ݒ�l���Z�b�g
		If IsEmpty(lngArrHoliday) Then
			lngArrHoliday = Array(lngHoliday)
		Else
			i = UBound(lngArrHoliday) + 1
			ReDim Preserve lngArrHoliday(i)
			lngArrHoliday(i) = lngHoliday
		End If
	Next

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\��X�P�W���[�����O�f�[�^�ǂݍ���
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : �Ȃ�
'
' ���l�@�@ : strArrEmptyCount �ɂP���`�����̗\��ݒ�l��ҏW����
' �@�@�@�@ : �i"hidden":��\���C"":���ݒ�C"0":�\��s�C"1"�`"999":�\��\�j
' �@�@�@�@ : �O������lngArrHoliday �ɂP���`�����̕a�@�ݒ�l���ҏW����Ă��邱��
'
'-------------------------------------------------------------------------------
Sub GetStrArrEmptyCount()

	'�w��N���̂P�����疖��
	strStrDate = CStr(lngYear) & "/" & CStr(lngMonth) & "/1"
	strEndDate = CStr(lngYear) & "/" & CStr(lngMonth) & "/" & CStr(Day(DateAdd("d", -1, DateAdd("m", 1, CStr(lngYear) & "/" & CStr(lngMonth) & "/1"))))

	'�w����Ԃ̊Y���\��g�R�[�h�̗\��X�P�W���[�����O�����擾����i���Ԙg�̎w��͂����A���ׂĂ̎��Ԙg�𒊏o�j
	lngCount = objSchedule.SelectSchedule(strStrDate, strEndDate, "", strRsvFraCd, vntCslDate, vntTimeFra, vntRsvFraCd, vntEmptyCount, vntRsvCount)

	'�P���`�����̐ݒ�l�𔻒�
	k = 0
	For j = 1 To Day(DateAdd("d", -1, DateAdd("m", 1, CStr(lngYear) & "/" & CStr(lngMonth) & "/1")))
		'���̓��̗\��X�P�W���[�����O�̐ݒ��c������
		strEmptyCount = ""
		strCheckType = ""
		If k < lngCount Then
			Do While DateValue(vntCslDate(k)) = DateValue(CStr(lngYear) & "/" & CStr(lngMonth) & "/" & CStr(j))
				'�Y�����Ԙg�̗\��ݒ�l
				If vntTimeFra(k) = lngTimeFra Then
					strEmptyCount = vntEmptyCount(k)
				End If
				'���Ԙg�Ǘ�����Ă��邩�ۂ��̔���
				If vntTimeFra(k) = TIME_FRA_NON Then
					strCheckType = "0"
				Else
					strCheckType = "1"
				End If
				k = k + 1
				If k >= lngCount Then
					Exit Do
				End If
			Loop
		End If
		'�x���E�j���ŁA���̓��̗\��������Ȃ��ꍇ
		If lngArrHoliday(j - 1) <> HOLIDAY_NON And strHolidayFlg = CStr(HOLIDAYFLG_DENY) Then
			'��\���Ƃ���
			strEmptyCount = "hidden"
		'�x���E�j���ȊO�A�܂��́A�x���E�j���ł��\��������ꍇ
		Else
			'�I���̓��͎��A���Ԙg�Ǘ�����Ă�����͔�\���Ƃ���
			If lngTimeFra = TIME_FRA_NON And strCheckType = "1" Then
				strEmptyCount = "hidden"
			End If
			'�w�莞�Ԙg�̓��͎��A�I���Ǘ�����Ă�����͔�\���Ƃ���
			If lngTimeFra <> TIME_FRA_NON And strCheckType = "0" Then
				strEmptyCount = "hidden"
			End If
		End If
		'�P���`�����̐ݒ�l���Z�b�g
		If IsEmpty(strArrEmptyCount) Then
			strArrEmptyCount = Array(strEmptyCount)
		Else
			i = UBound(strArrEmptyCount) + 1
			ReDim Preserve strArrEmptyCount(i)
			strArrEmptyCount(i) = strEmptyCount
		End If
	Next

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\��g�ꗗ�h���b�v�_�E�����X�g�̕ҏW
'
' �����@�@ : (In)	strName					�G�������g��
' �@�@�@�@ : (In)	strSelectedRsvFraCd		���X�g�ɂđI�����ׂ��\��g�R�[�h
' �@�@�@�@ : (In)	strNonSelDelFlg			���I��p�󃊃X�g�폜�t���O
'
' �߂�l�@ : HTML������
'
' ���l�@�@ : "SELECTED_ALL"�Ŗ��I��p�̋󃊃X�g�������ɍ쐬
'
'-------------------------------------------------------------------------------
Function EditRsvFraList(strName, strSelectedRsvFraCd, strNonSelDelFlg)

	Dim vntRsvFraCd			'�\��g�R�[�h
	Dim vntRsvFraName		'�\��g����
	Dim vntEditRsvFraCd		'�ҏW�p�\��g�R�[�h
	Dim vntEditRsvFraName	'�ҏW�p�\��g����
	Dim i					'�C���f�b�N�X
	Dim j					'�C���f�b�N�X
	Dim k					'�C���f�b�N�X

	Dim objSchedule			'�X�P�W���[���A�N�Z�X�pCOM�I�u�W�F�N�g

	'�����ݒ�
	vntEditRsvFraCd = Empty
	vntEditRsvFraName = Empty

	'���I��p�̋󃊃X�g���쐬
'### 2004/3/27 Deleted by Ishihara@FSIT ���H���łł͗\��g�����e�i���X�͕�
'	If strNonSelDelFlg = NON_SELECTED_ADD Or strNonSelDelFlg = SELECTED_ALL Then
'		vntEditRsvFraCd = Array("")
'		vntEditRsvFraName = Array("���\������R�[�X�܂��͐ݔ����w�肵�Ă�������")
'	End If
'### 2004/3/27 Deleted End

	'�u���ׂāi�a�@�X�P�W���[���j�v�I��p�̃��X�g���쐬
	If strNonSelDelFlg = SELECTED_ALL Then
		If IsEmpty(vntEditRsvFraName) Then
			vntEditRsvFraCd = Array("ALL")
			vntEditRsvFraName = Array("�x�f���ݒ�i�y�E���E�j�j")
		Else
			i = UBound(vntEditRsvFraCd) + 1
			ReDim Preserve vntEditRsvFraCd(i)
			vntEditRsvFraCd(i) = "ALL"
			i = UBound(vntEditRsvFraName) + 1
			ReDim Preserve vntEditRsvFraName(i)
			vntEditRsvFraName(i) = "�x�f���ݒ�i�y�E���E�j�j"
		End If
	End If

'### 2004/3/27 Deleted by Ishihara@FSIT ���H���łł͗\��g�����e�i���X�͕�
'	'�\��g�̈ꗗ���擾
'	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")
'	j = objSchedule.SelectRsvFraList(vntRsvFraCd, vntRsvFraName)
'	Set objSchedule = Nothing
'
'	'�u�\��g�w��v�I��p
'	For k = 0 To j - 1
'		If IsEmpty(vntEditRsvFraName) Then
'			vntEditRsvFraCd = Array(vntRsvFraCd(k))
'			vntEditRsvFraName = Array(vntRsvFraName(k))
'		Else
'			i = UBound(vntEditRsvFraCd) + 1
'			ReDim Preserve vntEditRsvFraCd(i)
'			vntEditRsvFraCd(i) = vntRsvFraCd(k)
'			i = UBound(vntEditRsvFraName) + 1
'			ReDim Preserve vntEditRsvFraName(i)
'			vntEditRsvFraName(i) = vntRsvFraName(k)
'		End If
'	Next
'### 2004/3/27 Deleted End

	'�h���b�v�_�E�����X�g�̕ҏW
	If Not IsEmpty(vntEditRsvFraName) Then
		EditRsvFraList = EditDropDownListFromArray(strName, vntEditRsvFraCd, vntEditRsvFraName, strSelectedRsvFraCd, NON_SELECTED_DEL)
	End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<!--<TITLE>�\��g�o�^</TITLE>-->
<TITLE>�x�f���ݒ�</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
// �u�f�t�H���g�l����W�J����v���N���b�N���ꂽ���̏���
function SetDefault( defcnt ) {

	var i;

	// �t�H�[����̃G�������g�𑖍�����
	for ( i=0; i<document.entryForm.length; i++ ) {
		// TEXT�I�u�W�F�N�g�̎�
		if ( document.entryForm.elements[i].type == 'text') {
			// "hidden"�i��\���j�ȊO���ݒ肳��Ă��鎞
			if ( document.entryForm.elements[i].value != 'hidden') {
				// �f�t�H���g�l����ݒ肷��
				document.entryForm.elements[i].value = defcnt;
			}
		}
	}

	return false;
}

// �u���j���͑S�ċx�f���v���ύX���ꂽ���̏���
function ChangeSunday( targetsel ) {

	var i;
	var elementname;

	// �`�F�b�N���ꂽ��
	if ( targetsel.checked ) {
		// �t�H�[����̃G�������g�𑖍�����
		for ( i=0; i<document.entryForm.length; i++ ) {
			// SELECT�I�u�W�F�N�g�̎�
			if ( document.entryForm.elements[i].type == 'select-one') {
				// �G�������g���̖�����"1"�i���j���j�̎�
				elementname = document.entryForm.elements[i].name;
				if ( elementname.charAt(elementname.length - 1) == '1') {
					// "1"�i�x�f���j��ݒ肷��
					document.entryForm.elements[i].value = '1';
				}
			}
		}
	// �`�F�b�N���͂����ꂽ��
	} else {
		// �t�H�[����̃G�������g�𑖍�����
		for ( i=0; i<document.entryForm.length; i++ ) {
			// SELECT�I�u�W�F�N�g�̎�
			if ( document.entryForm.elements[i].type == 'select-one') {
				// �G�������g���̖�����"1"�i���j���j�̎�
				elementname = document.entryForm.elements[i].name;
				if ( elementname.charAt(elementname.length - 1) == '1') {
					// "1"�i�x�f���j���ݒ肳��Ă��鎞
					if ( document.entryForm.elements[i].value == '1') {
						// "0"�i���ݒ�j��ݒ肷��
						document.entryForm.elements[i].value = '0';
					}
				}
			}
		}
	}

	return false;
}

// �u�y�j���͑S�ċx�f���v���ύX���ꂽ���̏���
function ChangeSaturday( targetsel ) {

	var i;
	var elementname;

	// �`�F�b�N���ꂽ��
	if ( targetsel.checked ) {
		// �t�H�[����̃G�������g�𑖍�����
		for ( i=0; i<document.entryForm.length; i++ ) {
			// SELECT�I�u�W�F�N�g�̎�
			if ( document.entryForm.elements[i].type == 'select-one') {
				// �G�������g���̖�����"7"�i�y�j���j�̎�
				elementname = document.entryForm.elements[i].name;
				if ( elementname.charAt(elementname.length - 1) == '7') {
					// "1"�i�x�f���j��ݒ肷��
					document.entryForm.elements[i].value = '1';
				}
			}
		}
	// �`�F�b�N���͂����ꂽ��
	} else {
		// �t�H�[����̃G�������g�𑖍�����
		for ( i=0; i<document.entryForm.length; i++ ) {
			// SELECT�I�u�W�F�N�g�̎�
			if ( document.entryForm.elements[i].type == 'select-one') {
				// �G�������g���̖�����"7"�i�y�j���j�̎�
				elementname = document.entryForm.elements[i].name;
				if ( elementname.charAt(elementname.length - 1) == '7') {
					// "1"�i�x�f���j���ݒ肳��Ă��鎞
					if ( document.entryForm.elements[i].value == '1') {
						// "0"�i���ݒ�j��ݒ肷��
						document.entryForm.elements[i].value = '0';
					}
				}
			}
		}
	}

	return false;
}
//-->
</SCRIPT>
<STYLE TYPE="text/css">
<!-- #include virtual = "/webHains/contents/css/calender.css" -->
td.mnttab { background-color:#FFFFFF }
a.weekday,
a.holiday,
a.saturday { margin-right:20px }
</STYLE>
</HEAD>
<BODY>

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="selectForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
	<BLOCKQUOTE>

	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
		<TR>
<!--			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�\��g�o�^</FONT></B></TD> -->
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">��</SPAN><FONT COLOR="#000000">�x�f���ݒ�</FONT></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR>
			<TD>��f�N��</TD>
			<TD>�F</TD>
			<TD>
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
					<TR>
						<TD><%= EditNumberList("year", YEARRANGE_MIN, YEARRANGE_MAX, lngYear, False) %></TD>
						<TD>�N</TD>
						<TD><%= EditNumberList("month", 1, 12, lngMonth, False) %></TD>
						<TD>��</TD>
						<TD><%= EditTimeFraList("timeFra", CStr(lngTimeFra)) %></TD>
					</TR>
				</TABLE>
			</TD>
			<TD>&nbsp;<A HREF="mntCapacityList.asp?year=<%= lngYear %>&month=<%= lngMonth %>">�ݒ�󋵂�����</A></TD>
		</TR>
		<TR>
			<TD>�\��g</TD>
			<TD>�F</TD>
			<TD><%= EditRsvFraList("rsvFraCd", strRsvFraCd, SELECTED_ALL) %></TD>
			<TD VALIGN="bottom" ROWSPAN="3">
				<A HREF="javascript:function voi(){};voi()" ONCLICK="document.selectForm.submit();return false"><IMG SRC="/webHains/images/b_prev.gif" ALT="�\��"></A>
			</TD>
		</TR>
	</TABLE>

	</BLOCKQUOTE>
</FORM>

<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<BLOCKQUOTE>

	<INPUT TYPE="hidden" NAME="action" VALUE="save">
	<INPUT TYPE="hidden" NAME="year" VALUE="<%= CStr(lngYear) %>">
	<INPUT TYPE="hidden" NAME="month" VALUE="<%= CStr(lngMonth) %>">
	<INPUT TYPE="hidden" NAME="timeFra" VALUE="<%= CStr(lngTimeFra) %>">
	<INPUT TYPE="hidden" NAME="rsvFraCd" VALUE="<%= strRsvFraCd %>">
<%
'���b�Z�[�W�̕ҏW
If strAction <> "" Then

	'�ۑ��������́u�ۑ������v�̒ʒm
	If strAction = "saveend" Then
		Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)
		Call EditMessage(strArrMessage2, MESSAGETYPE_WARNING)
%>
		<BR>
<%

	'�����Ȃ��΃G���[���b�Z�[�W��ҏW
	Else
		Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
%>
		<BR>
<%
	End If

End If
%>
<%
'*******************************************************************************
'�\��X�P�W���[�����O�̕\��
If strRsvFraCd <> "ALL" And strRsvFraCd <> "" Then
%>
	<SPAN STYLE="font-size:9pt;">
	<FONT COLOR="#ff6600"><B><%= CStr(lngYear) %>�N<%= CStr(lngMonth) %>���x�@<%= strRsvFraName %></B></FONT>�̗\��g����\�����Ă��܂��B
	<%= IIf(lngFraType = FRA_TYPE_CS, "�i�R�[�X�g�Ǘ��j", "�i�������ژg�Ǘ��j") %>
	</SPAN>
	<BR><BR>
	<TABLE BORDER="1" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD COLSPAN="7"><B><%= CStr(lngYear) %>�N<%= CStr(lngMonth) %>���x�@<%= strRsvFraName %>�\��l��</B></TD>
		</TR>
		<TR ALIGN="right" BGCOLOR="#eeeeee">
			<TD CLASS="holiday"><B>��</B></FONT></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="saturday"><B>�y</B></FONT></TD>
		</TR>
<%
			'�w��N��
			strEditYear = CStr(lngYear)
			strEditMonth = CStr(lngMonth)

			'�X�^�[�g���i�擪�����j�������擾�j
			strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")

			'������
			strEndDay = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))

			'�P�T�Ԃ��Ƃɏ������s���i�ő�U�T����̂Łj
			For j = 1 To 6
%>
				<TR ALIGN="right">
<%
				'�P�����Ƃɏ������s��
				For k = 1 To 7

					strEditDay = strEditDay + 1

					If strEditDay >= 1 And strEditDay <= strEndDay Then
						'CLASS�����̕ҏW
						strClass = ""
						'�����̐F�w��
						If strEditYear = CStr(Year(Date)) And strEditMonth = CStr(Month(Date)) And strEditDay = Day(Date) Then
							strClass = "today"
						Else
							'�x�f���A�j���̐F�w��
							If lngArrHoliday(strEditDay - 1) = HOLIDAY_CLS Then
								strClass = "kyusin"
							ElseIf lngArrHoliday(strEditDay - 1) = HOLIDAY_HOL Then
									strClass = "holiday"
							End If
						End If
						If strClass = "" Then
							'�y�j�A���j�̐F�w��
							Select	Case 	k
								Case vbSunday
									strClass = "holiday"
								Case vbSaturday
									strClass = "saturday"
								Case Else
									strClass = "weekday"
							End Select
						End If
%>
						<TD WIDTH="50" VALIGN="top">
							<A HREF="/webHains/frontdoor.asp?cslYear=<%= lngYear %>&cslMonth=<%= lngMonth %>&cslDay=<%= strEditDay %>" CLASS="<%= strClass %>">
							<B><I><%= IIf(Len(CStr(strEditDay)) = 1, "&nbsp;" & CStr(strEditDay), CStr(strEditDay)) %></I></B></A><BR>
							<INPUT TYPE="<%= IIf(strArrEmptyCount(strEditDay - 1) = "hidden", "hidden", "text") %>"
								NAME="<%= "day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k %>"
								VALUE="<%= strArrEmptyCount(strEditDay - 1) %>"
								<%= IIf(strArrEmptyCount(strEditDay - 1) = "hidden", "", "SIZE=""4"" MAXLENGTH=""3"" STYLE=""text-align:right""") %>>
								<%= IIf(strArrEmptyCount(strEditDay - 1) = "hidden", "�@<BR>�@", "�l") %>
						</TD>
<%
					Else
%>
						<TD WIDTH="50" VALIGN="top">&nbsp;</TD>
<%
					End If

				Next 
%>
				</TR>
<%
				If strEditDay >= strEndDay Then
					Exit For
				End If

			Next
%>
	</TABLE>
	<BR>
<!--
	<INPUT TYPE="button" NAME="ButtonDefault" VALUE="�f�t�H���g�l����W�J����" ONCLICK="JavaScript:SetDefault('<%= CStr(lngDefCnt) %>');">
-->
	<A HREF="javascript:function voi(){};voi()" ONCLICK="SetDefault('<%= CStr(lngDefCnt) %>')">�f�t�H���g�l����W�J����</A>
	<BR>
	<BR>
	
    <% If Session("PAGEGRANT") = "4" Then %>
        <A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
	<% End IF %>
    <BR>
<%
End If
%>
<%
'*******************************************************************************
'�a�@�X�P�W���[�����O�̕\��
If strRsvFraCd = "ALL" Then
%>
	<SPAN STYLE="font-size:9pt;">
	<FONT COLOR="#ff6600"><B><%= CStr(lngYear) %>�N<%= CStr(lngMonth) %>���x�@�a�@�X�P�W���[��</B></FONT>����\�����Ă��܂��B
	</SPAN>
	<BR><BR>
	<TABLE BORDER="1" CELLSPACING="1" CELLPADDING="1">
		<TR>
			<TD COLSPAN="7"><B><%= CStr(lngYear) %>�N<%= CStr(lngMonth) %>���x�@�a�@�X�P�W���[��</B></TD>
		</TR>
		<TR ALIGN="right" BGCOLOR="#eeeeee">
			<TD CLASS="holiday"><B>��</B></FONT></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="weekday"><B>��</B></TD>
			<TD CLASS="saturday"><B>�y</B></FONT></TD>
		</TR>
<%
			'�w��N��
			strEditYear = CStr(lngYear)
			strEditMonth = CStr(lngMonth)

			'�X�^�[�g���i�擪�����j�������擾�j
			strEditDay = 1 - Weekday(strEditYear & "/" & strEditMonth & "/1")

			'������
			strEndDay = Day(DateAdd("d",-1,DateAdd("m",1,strEditYear & "/" & strEditMonth & "/1")))

			'�P�T�Ԃ��Ƃɏ������s���i�ő�U�T����̂Łj
			For j = 1 To 6
%>
				<TR ALIGN="right">
<%
				'�P�����Ƃɏ������s��
				For k = 1 To 7

					strEditDay = strEditDay + 1

					If strEditDay >= 1 And strEditDay <= strEndDay Then
						'CLASS�����̕ҏW
						strClass = ""
'						'�����̐F�w��
'						If strEditYear = CStr(Year(Date)) And strEditMonth = CStr(Month(Date)) And strEditDay = Day(Date) Then
'							strClass = "today"
'						Else
'							'�x�f���A�j���̐F�w��
'							If lngArrHoliday(strEditDay - 1) = HOLIDAY_CLS Then
'								strClass = "kyusin"
'							ElseIf lngArrHoliday(strEditDay - 1) = HOLIDAY_HOL Then
'									strClass = "holiday"
'							End If
'						End If
						If strClass = "" Then
							'�y�j�A���j�̐F�w��
							Select	Case 	k
								Case vbSunday
									strClass = "holiday"
								Case vbSaturday
									strClass = "saturday"
								Case Else
									strClass = "weekday"
							End Select
						End If
%>
						<TD WIDTH="50" VALIGN="top">
							<A HREF="/webHains/frontdoor.asp?cslYear=<%= lngYear %>&cslMonth=<%= lngMonth %>&cslDay=<%= strEditDay %>" CLASS="<%= strClass %>">
							<B><I><%= IIf(Len(CStr(strEditDay)) = 1, "&nbsp;" & CStr(strEditDay), CStr(strEditDay)) %></I></B></A><BR>
							<SELECT NAME="<%= "day" & IIf(Len(CStr(strEditDay)) = 1, "0" & CStr(strEditDay), CStr(strEditDay)) & "-" & k %>">
								<OPTION VALUE="<%= HOLIDAY_NON %>" <%= IIf(lngArrHoliday(strEditDay - 1) = HOLIDAY_NON, "SELECTED", "") %>>
								<OPTION VALUE="<%= HOLIDAY_CLS %>" <%= IIf(lngArrHoliday(strEditDay - 1) = HOLIDAY_CLS, "SELECTED", "") %>>�x�f��
								<OPTION VALUE="<%= HOLIDAY_HOL %>" <%= IIf(lngArrHoliday(strEditDay - 1) = HOLIDAY_HOL, "SELECTED", "") %>>�j��
							</SELECT>
						</TD>
<%
					Else
%>
						<TD WIDTH="50" VALIGN="top">&nbsp;</TD>
<%
					End If

				Next 
%>
				</TR>
<%
				If strEditDay >= strEndDay Then
					Exit For
				End If

			Next
%>
	</TABLE>
	<BR>
	<INPUT TYPE="checkbox" NAME="CheckboxSunday" ONCLICK="JavaScript:ChangeSunday(this);">���j���͑S�ċx�f��<BR>
	<INPUT TYPE="checkbox" NAME="CheckboxSaturday" ONCLICK="JavaScript:ChangeSaturday(this);">�y�j���͑S�ċx�f��<BR>
	<BR>
	<BR>
	
    <% If Session("PAGEGRANT") = "4" Then %>
        <A HREF="javascript:function voi(){};voi()" ONCLICK="document.entryForm.submit();return false"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
	<% End IF %>
    <BR>
<%
End If
%>
	</BLOCKQUOTE>
</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
