<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ʈꊇ���� (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditGrpList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/tokyu_editCourseList.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Dim mobjConsult			'��f���A�N�Z�X�pCOM�I�u�W�F�N�g

Dim objResult			'�������ʃA�N�Z�X�pCOM�I�u�W�F�N�g
Dim objWorkStation		'�ʉߏ��A�N�Z�X�p

'�e�X�e�b�v�Ŕėp�I�Ɏg�p�������
Dim mstrStep			'���y�[�W�̃X�e�b�v

'Step1����̈���
Dim mlngYear			'��f���i�N�j
Dim mlngMonth			'��f���i���j
Dim mlngDay				'��f���i���j
Dim mstrCsCd			'�R�[�X�R�[�h
Dim mstrDayIdF			'�����h�c�i���j
Dim mstrDayIdT			'�����h�c�i���j
Dim mstrGrpCd			'�������ڃO���[�v�R�[�h
Dim mstrCslDate			'��f��

'Step2����̈���(�������ڏ��)
Dim mstrAction			'���샂�[�h
Dim mstrItemCd			'�������ڃR�[�h
Dim mstrSuffix			'�T�t�B�b�N�X
Dim mstrItemName		'�������ږ���
Dim mstrResultType		'���ʃ^�C�v
Dim mstrItemType		'���ڃ^�C�v
Dim mstrResult			'��������
Dim mstrResultErr		'�������ʃG���[
Dim mstrStcItemCd		'���͎Q�Ɨp���ڃR�[�h
Dim mstrShortStc		'���͗���
Dim mstrAllResultClear	'�u���̃O���[�v�̌������ʂ�S�ăN���A����v

'Step3����̈���(��O�ҏ��)
Dim mstrOverWrite		'�u���łɓ��͂���Ă��錋�ʂ��㏑������v
Dim mstrRsvNo			'�\��ԍ�
Dim mstrSelectFlg		'��O�ґΏۃt���O

'��O�ғ��͂֓n�����߂�Step4�ŕێ��������
Dim mstrOutRsvNo		'�X�V�ΏۊO�\��ԍ�
Dim mlngOutCount		'�X�V�ΏۊO�l��
Dim mlngUpdCount		'�X�V����

'�S�X�e�b�v���ʂ̍�Ɨp�ϐ�
Dim strArrMessage		'�G���[���b�Z�[�W
Dim mlngIndex1			'�C���f�b�N�X
Dim mlngIndex2			'�C���f�b�N�X

'�[���Ǘ����
Dim strIPAddress		'IPAddress
Dim strWkstnName		'�[����
Dim strWkstnGrpCd		'�O���[�v�R�[�h
Dim strWkstnGrpName		'�O���[�v��

Dim strUpdUser			'�X�V��
Dim lngWkStrDayId		'�J�n����ID
Dim lngWkEndDayId		'�I������ID
Dim lngAllUpdCount		'��f���
Dim strAllUpdRsvNo		'�\��ԍ�

Dim lngRsvNoIndex		'�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objResult = Server.CreateObject("HainsResult.Result")

'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'IP�A�h���X�̎擾
strIPAddress = Request.ServerVariables("REMOTE_ADDR")

'�ǂ̃X�e�b�v����Ă΂ꂽ�������߂�
mstrStep = Request("step")

'Step1�Őݒ肳�ꂽ�����l�̎擾
mlngYear   = CLng("0" & Request("year"))
mlngMonth  = CLng("0" & Request("month"))
mlngDay    = CLng("0" & Request("day"))
mstrCsCd   = Request("csCd")
mstrDayIdF = Request("dayIdF")
mstrDayIdT = Request("dayIdT")
mstrGrpCd  = Request("grpCd")

'��f�N�����̕ҏW
mstrCslDate = mlngYear & "/" & mlngMonth & "/" & mlngDay

'Step2�Őݒ肳�ꂽ�����l�̎擾
mstrAction         = Request("act")
mstrItemCd         = ConvIStringToArray(Request("itemCd"))
mstrSuffix         = ConvIStringToArray(Request("suffix"))
mstrItemName       = ConvIStringToArray(Request("itemName"))
mstrResultType     = ConvIStringToArray(Request("resultType"))
mstrItemType       = ConvIStringToArray(Request("itemType"))
mstrResult         = ConvIStringToArray(Request("result"))
mstrResultErr      = ConvIStringToArray(Request("resultErr"))
mstrStcItemCd      = ConvIStringToArray(Request("stcItemCd"))
mstrShortStc       = ConvIStringToArray(Request("shortStc"))
mstrAllResultClear = Request("allResultClear")

'Step3�Őݒ肳�ꂽ�����l�̎擾
mstrOverWrite = Request("overWrite")
mstrRsvNo     = ConvIStringToArray(Request("rsvNo"))
mstrSelectFlg = ConvIStringToArray(Request("selectFlg"))

'�R�[�h���n����Ă��Ȃ��ꍇ
If mstrGrpCd = "" Then

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objWorkStation = Server.CreateObject("HainsWorkStation.WorkStation")

	'�K��̃O���[�v�R�[�h�擾
	If objWorkStation.SelectWorkstation(strIPAddress, strWkstnName, strWkstnGrpCd, strWkstnGrpName) = True Then
		mstrGrpCd = strWkstnGrpCd
	End If

End If

Do
	'�e�X�e�b�v���Ƃ̃`�F�b�N�E�X�V��������
	Select Case mstrStep

		'��f���E�O���[�v�w��
		Case "1"

			'�f�t�H���g�l�̐ݒ�
			mlngYear  = IIf(mlngYear  = 0, CLng(Year(Now)),  mlngYear )
			mlngMonth = IIf(mlngMonth = 0, CLng(Month(Now)), mlngMonth)
			mlngDay   = IIf(mlngDay   = 0, CLng(Day(Now)),   mlngDay  )

			'�u���ցv�{�^����������Ă��Ȃ��ꍇ�͏����𔲂���
			If IsEmpty(Request("step2.x")) Then
				Exit Do
			End If

			'���̓`�F�b�N
			strArrMessage = objResult.CheckRslAllSet1Value(mlngYear, mlngMonth, mlngDay, mstrCslDate, mstrDayIdF, mstrDayIdT)

			'�`�F�b�N�G���[���͏����𔲂���
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'��f��񑶍݃`�F�b�N
			If CheckConsult() <= 0 Then
'## 2004.01.09 Mod By T.Takagi@FSIT ���@�֘A�ǉ�
'				strArrMessage = Array("�w�茟���O���[�v�̌�������f���Ă����f�҂����݂��܂���B")
				strArrMessage = Array("�w�茟���O���[�v�̌�������f���Ă��闈�@�ςݎ�f�҂����݂��܂���B")
'## 2004.01.09 Mod End
				Exit Do
			End If

			'����ʂ֑J��
			mstrStep = "2"
			Exit Do

		'�ꊇ���ʒl����
		Case "2"

			'�u���ցv�u�ۑ��v�ȊO�͏����𔲂���
			If mstrAction <> "next" And mstrAction <> "save" Then
				Exit Do
			End If

			'��f��񑶍݃`�F�b�N
			If CheckConsult() <= 0 Then
'## 2004.01.09 Mod By T.Takagi@FSIT ���@�֘A�ǉ�
'				strArrMessage = Array("�w�茟���O���[�v�̌�������f���Ă����f�҂����݂��܂���B")
				strArrMessage = Array("�w�茟���O���[�v�̌�������f���Ă��闈�@�ςݎ�f�҂����݂��܂���B")
'## 2004.01.09 Mod End
				Exit Do
			End If

			'���ʓ��̓`�F�b�N
			strArrMessage = objResult.CheckResult(mstrCslDate, mstrItemCd, mstrSuffix, mstrResult, mstrShortStc, mstrResultErr)
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End If

			'�u���ցv�̏ꍇ�͗�O�Ҏw���ʂ֑J��
			If mstrAction = "next" Then
				mstrStep = "3"
				Exit Do
			End If

			'�������ʍX�V
			lngWkStrDayId = CLng(IIf(mstrDayIdF = "",    0, mstrDayIdF))
			lngWkEndDayId = CLng(IIf(mstrDayIdT = "", 9999, mstrDayIdT))

			'�I�u�W�F�N�g�̃C���X�^���X�쐬
			Set mobjConsult = CreateObject("HainsConsult.Consult")
    
			'�X�V�ΏۂƂȂ��f����ǂݍ���
'## 2004.01.09 Mod By T.Takagi@FSIT ���@�֘A�ǉ�
'			lngAllUpdCount = mobjConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngWkStrDayId, lngWkEndDayId, mstrGrpCd, , , , , , , , strAllUpdRsvNo)
			'���@�ςݎ�f�҂̂ݑΏ�
			lngAllUpdCount = mobjConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngWkStrDayId, lngWkEndDayId, mstrGrpCd, , , , , , , , strAllUpdRsvNo, , , , , , , , , , , , , , , , , , , , , , , True)
'## 2004.01.09 Mod End

			Set mobjConsult = Nothing

			'�������ʈꊇ�X�V
			IF lngAllUpdCount > 0 Then
				objResult.UpdateResultAll strUpdUser, strIPAddress, mstrAllResultClear, "", strAllUpdRsvNo, mstrItemCd, mstrSuffix, mstrResult
			End If

			'����ʂ֑J��
			mlngUpdCount = 1
			mstrStep = "4"

		'��O�ғ���
		Case "3"

			'�X�V�Ώێ҂Ɨ�O�҂ɐU�蕪����
			For lngRsvNoIndex = 0 To UBound(mstrRsvNo)
				If mstrSelectFlg(lngRsvNoIndex) = "1" Then
					If mlngOutCount = 0 Then
						mstrOutRsvNo = Array()
					End If
					ReDim Preserve mstrOutRsvNo(mlngOutCount)
					mstrOutRsvNo(mlngOutCount) = mstrRsvNo(lngRsvNoIndex)
					mlngOutCount = mlngOutCount + 1
				Else
					If lngAllUpdCount = 0 Then
						strAllUpdRsvNo = Array()
					End If
					ReDim Preserve strAllUpdRsvNo(lngAllUpdCount)
					strAllUpdRsvNo(lngAllUpdCount) = mstrRsvNo(lngRsvNoIndex)
					lngAllUpdCount = lngAllUpdCount + 1
				End If
			Next

			'�X�V�҂����݂���Ό������ʈꊇ�X�V
			If lngAllUpdCount > 0 Then
				mlngUpdCount = objResult.UpdateResultAll(strUpdUser, strIPAddress, mstrAllResultClear, mstrOverWrite, strAllUpdRsvNo, mstrItemCd, mstrSuffix, mstrResult)
			End If

			'����ʂ֑J��
			mstrStep = "4"

	End Select

	Exit Do
Loop

'�e�X�e�b�v�l���Ƃ̕\��ASP����
Select Case mstrStep

	'��f���E�O���[�v�w��
	Case "1"
%>
		<!-- #include virtual = "/webHains/contents/resultAllSet/rslAllSetStep1.asp" -->
<%
	'�ꊇ���ʒl����
	Case "2"
%>
		<!-- #include virtual = "/webHains/contents/resultAllSet/rslAllSetStep2.asp" -->
<%
	'��O�ғ���
	Case "3"
%>
		<!-- #include virtual = "/webHains/contents/resultAllSet/rslAllSetStep3.asp" -->
<%
	'���͊���
	Case "4"
%>
		<!-- #include virtual = "/webHains/contents/resultAllSet/rslAllSetStep4.asp" -->
<%
End Select

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �w��O���[�v���������ڎ�f�҂̑��݃`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ : ��f�Ґ�
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckConsult()

	Dim objConsult	'��f���A�N�Z�X�pCOM�I�u�W�F�N�g

	Dim lngStrDayId	'�J�n����ID
	Dim lngEndDayId	'�I������ID

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objConsult = Server.CreateObject("HainsConsult.Consult")

	'����ID�̕ҏW
	lngStrDayId = CLng(IIf(mstrDayIdF = "",    0, mstrDayIdF))
	lngEndDayId = CLng(IIf(mstrDayIdT = "", 9999, mstrDayIdT))

	'��f��񑶍݃`�F�b�N
'## 2004.01.09 Mod By T.Takagi@FSIT ���@�֘A�ǉ�
'	CheckConsult = objConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngStrDayId, lngEndDayId, mstrGrpCd)
	'���@�ςݎ�f�҂̂ݑΏ�
	CheckConsult = objConsult.SelectConsultList(mstrCslDate, 0, mstrCsCd, lngStrDayId, lngEndDayId, mstrGrpCd, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , True)
'## 2004.01.09 Mod End

End Function
%>
