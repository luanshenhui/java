<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		���ʓ���(�ڍ׉��) (Ver0.0.1)
'		AUTHER  : Tatsuhiko Nishi@Takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"  -->
<!-- #include virtual = "/webHains/includes/editGrpList.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
'Call CheckSession(BUSINESSCD_RESULT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const ACTMODE_SAVE     = "save"		'���샂�[�h(�ۑ�)
Const ACTMODE_CHANGE   = "change"	'���샂�[�h(�O���[�v�ύX)
Const ACTMODE_PREVIOUS = "previous"	'���샂�[�h(�O��f�҂�)
Const ACTMODE_NEXT     = "next"		'���샂�[�h(����f�҂�)
Const ACTMODE_SAVEEND  = "saveend"	'���샂�[�h(�ۑ�����)
Const DISPMODE_DETAIL  = "detail"	'�\�����[�h(���͕\��)
Const DISPMODE_SIMPLE  = "simple"	'�\�����[�h(�����\��)
Const DISPMODE_DELETE  = "delete"	'�\�����[�h(�[���ʉߏ��폜)

Const STDFLG_H = "H"		'�ُ�i��j
Const STDFLG_U = "U"		'�y�x�ُ�i��j
Const STDFLG_D = "D"		'�y�x�ُ�i���j
Const STDFLG_L = "L"		'�ُ�i���j
Const STDFLG_T1 = "*"		'�萫�l�ُ�
Const STDFLG_T2 = "@"		'�萫�l�y�x�ُ�

Const FREECD_ECHO    = "000023"		'�ėp�R�[�h(�����g�����\�o�͐ݒ�p)
Const FREECD_ECHOSKN = "ECHOSKN"	'�ėp�R�[�h(�����g�L�������̓R�[�h)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon		'���ʃN���X
Dim objConsult		'��f���A�N�Z�X�p
Dim objGrp			'�O���[�v�A�N�Z�X�p
Dim objJudClass		'���蕪�ރA�N�Z�X�p
Dim objProgress		'�i���Ǘ����ރA�N�Z�X�p
Dim objResult		'�������ʃA�N�Z�X�p
Dim objWorkStation	'�ʉߏ��A�N�Z�X�p
Dim objFree			'�ėp���A�N�Z�X�p

'�O��ʂ��瑗�M�����p�����[�^�l
Dim strActMode		'���샂�[�h
Dim strDispMode		'�\�����(���͕\����:"1"�A���͔�\����:"2")
Dim strRsvNo		'�\��ԍ�
Dim strMode			'���͑Ώۃ��[�h
Dim strCode			'���͑ΏۃR�[�h
Dim strKeyCslYear	'(��t����)��f��(�N)
Dim strKeyCslMonth	'(��t����)��f��(��)
Dim strKeyCslDay	'(��t����)��f��(��)
Dim strKeyCntlNo	'�Ǘ��ԍ�
Dim strKeyCsCd		'�R�[�X�R�[�h
Dim strKeySortKey	'�\����
Dim strKeyDayId		'����ID
Dim strNoPrevNext	'�O���f�҂ւ̑J�ڂ��s��Ȃ�
Dim strIPAddress	'IPAddress

'��f���
Dim strPerId		'�lID
Dim strCslDate		'��f��
Dim strCsCd			'�R�[�X�R�[�h
Dim strCsName		'�R�[�X��
Dim strLastName		'��
Dim strFirstName	'��
Dim strLastKName	'�J�i��
Dim strFirstKName	'�J�i��
Dim strBirth		'���N����
Dim strAge			'�N��
Dim strGender		'����
Dim strGenderName	'���ʖ���

'�������ʏ��
Dim strConsultFlg	'��f���ڃt���O
Dim strItemCd		'�������ڃR�[�h
Dim strSuffix		'�T�t�B�b�N�X
Dim strItemName		'�������ږ���
Dim strResult		'��������
Dim strResultType	'���ʃ^�C�v
Dim strItemType		'���ڃ^�C�v
Dim strStcItemCd	'���͎Q�Ɨp���ڃR�[�h
Dim strResultErr	'�������ʃG���[
Dim strShortStc		'���͗���
Dim strRslCmtCd1	'���ʃR�����g�R�[�h�P
Dim strRslCmtErr1	'���ʃR�����g�G���[�P
Dim strRslCmtName1	'���ʃR�����g���̂P
Dim strRslCmtCd2	'���ʃR�����g�R�[�h�Q
Dim strRslCmtErr2	'���ʃR�����g�G���[�Q
Dim strRslCmtName2	'���ʃR�����g���̂Q
Dim strRet			'�������ڃG���[
Dim strBefResult	'�O�񌟍�����
Dim strBefShortStc	'�O�񕶏͗���
Dim strDefResult	'�ȗ�����������
Dim strDefShortStc	'�ȗ������͗���
Dim strDefRslCmtCd		'�ȗ������ʃR�����g�R�[�h
Dim strDefRslCmtName	'�ȗ������ʃR�����g����
Dim strLastRsvNo	'�O��\��ԍ�
Dim strStdFlg		'��l�t���O
Dim lngCount		'���R�[�h����
Dim lngUpdItemCount	'�X�V�\���ڐ�

Dim strInitRsl		'�����ǂݍ��ݏ�Ԃ̌���
Dim strInitRslCmt1	'�����ǂݍ��ݏ�Ԃ̌��ʃR�����g�P
Dim strInitRslCmt2	'�����ǂݍ��ݏ�Ԃ̌��ʃR�����g�Q
Dim blnUpdated		'TRUE:�ύX����AFALSE:�ύX�Ȃ�

'���ۂɍX�V���鍀�ڏ����i�[������������
Dim strUpdIndex			'�C���f�b�N�X
Dim strUpdItemCd		'�������ڃR�[�h
Dim strUpdSuffix		'�T�t�B�b�N�X
Dim strUpdResult		'��������
Dim strUpdShortStc		'���͗���
Dim strUpdResultErr		'�������ʃG���[
Dim strUpdRslCmtCd1		'���ʃR�����g�R�[�h�P
Dim strUpdRslCmtName1	'���ʃR�����g���̂P
Dim strUpdRslCmtErr1	'���ʃR�����g�G���[�P
Dim strUpdRslCmtCd2		'���ʃR�����g�R�[�h�Q
Dim strUpdRslCmtName2	'���ʃR�����g���̂Q
Dim strUpdRslCmtErr2	'���ʃR�����g�G���[�Q
Dim lngUpdCount			'�X�V���ڐ�

'���͕���
Dim strOrientation	'���͕����i�c�A���j
Dim strPortrait		'�c
Dim strLandscape	'��

Dim lngAllCount		'�����𖞂����S���R�[�h����

Dim strElementName	'�G�������g��

Dim lngMargin		'�}�[�W���l
Dim strSeq			'�\���s�ʒu
Dim dtmCslDate		'(��t����)��f��
Dim strPrevRsvNo	'(�O��f�҂�)�\��ԍ�
Dim strPrevDayId	'(�O��f�҂�)����ID
Dim strNextRsvNo	'(����f�҂�)�\��ԍ�
Dim strNextDayId	'(����f�҂�)����ID
Dim strCodeName		'�R�[�h�ɑ΂��閼��
Dim strArrMessage	'�G���[���b�Z�[�W
Dim strHTML			'HTML������
Dim strURL			'URL������
Dim Ret				'�֐��߂�l
Dim strPassedDate	'�[���ʉߓ��t
Dim i, j			'�C���f�b�N�X

'�[���Ǘ����
Dim strWkstnName		'�[����
Dim strWkstnGrpCd		'�O���[�v�R�[�h
Dim strWkstnGrpName		'�O���[�v��
Dim strIsPrintButton	'����{�^���\��(1:�����g�A2:���o����)

'�\���F
Dim strH_Color		'��l�t���O�F�i�g�j
Dim strU_Color		'��l�t���O�F�i�t�j
Dim strD_Color		'��l�t���O�F�i�c�j
Dim strL_Color		'��l�t���O�F�i�k�j
Dim strT1_Color		'��l�t���O�F�i���j
Dim strT2_Color		'��l�t���O�F�i���j

Dim dtmDate			'��f��
Dim strUpdUser		'�X�V��

Dim blnWs			'�[�����̗L��
Dim strEcho			'�L�����҂͎����Œ����g�����\���o�͂���ꍇ��"1"

'�����g�������ڏ��
Dim strEchoItemCd		'�������ڃR�[�h
Dim strEchoSuffix		'�T�t�B�b�N�X
Dim strEchoShoken		'�������ڃt���O(�������s���ׂ����ڂȂ��""�ȊO�̒l)
Dim lngEchoItemCount	'�������ڐ�
Dim blnEchoFlg			'�����g���폊�����f�t���O
Dim blnEchoShokenFlg	'�����g���폊���t���O

Dim strEchoStcCd		'�����g���폊���R�[�h
Dim lngEchoStcCount		'�����g���폊�����͐�

'## 2004.01.09 Add By T.Takagi@FSIT ���@�֘A�ǉ�
Dim strComeDate			'���@����
Dim Ret2				'�֐��߂�l
'## 2004.01.09 Add End

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon      = Server.CreateObject("HainsCommon.Common")
Set objConsult     = Server.CreateObject("HainsConsult.Consult")
Set objGrp         = Server.CreateObject("HainsGrp.Grp")
Set objJudClass    = Server.CreateObject("HainsJudClass.JudClass")
Set objProgress    = Server.CreateObject("HainsProgress.Progress")
Set objResult      = Server.CreateObject("HainsResult.Result")
Set objWorkStation = Server.CreateObject("HainsWorkStation.WorkStation")

'�X�V�҂̐ݒ�
strUpdUser = Session("USERID")

'�����l�̎擾
strActMode     = Request("actMode")
strDispMode    = Request("dispMode")
strRsvNo       = Request("rsvNo")
strMode        = Request("mode")
strCode        = Request("code")
strKeyCslYear  = Request("cslYear")
strKeyCslMonth = Request("cslMonth")
strKeyCslDay   = Request("cslDay")
strKeyCntlNo   = Request("cntlNo")
strKeyCsCd     = Request("csCd")
strKeySortKey  = Request("sortKey")
strKeyDayId    = Request("dayId")
strNoPrevNext  = Request("noPrevNext")

'�����g�o�͕��@�̎擾
strEcho = Request("echo")
strEcho = IIf(strEcho = "", "1", strEcho)

'IP�A�h���X�̎擾
strIPAddress = Request.ServerVariables("REMOTE_ADDR")

'�[������ǂݍ���
blnWs = objWorkStation.SelectWorkstation(strIPAddress, strWkstnName, strWkstnGrpCd, strWkstnGrpName, , strIsPrintButton)

'�\�����[�h�̃f�t�H���g�l�́u���͕\���v�Ƃ���
strDispMode = IIf(strDispMode = "", DISPMODE_DETAIL, strDispMode)

'�R�[�h���n����Ă��Ȃ��ꍇ
If strCode = "" Then

	'�K��̃O���[�v�R�[�h�擾
	If blnWs = True Then
		strCode = strWkstnGrpCd
	Else
		strCode = "all"
	End If

End If

'��l�t���O�F�擾
objCommon.SelectStdFlgColor "H_COLOR", strH_Color
objCommon.SelectStdFlgColor "U_COLOR", strU_Color
objCommon.SelectStdFlgColor "D_COLOR", strD_Color
objCommon.SelectStdFlgColor "L_COLOR", strL_Color
objCommon.SelectStdFlgColor "*_COLOR", strT1_Color
objCommon.SelectStdFlgColor "@_COLOR", strT2_Color

'��f���̎擾
dtmCslDate = CDate(strKeyCslYear & "/" & strKeyCslMonth & "/" & strKeyCslDay)

'�������ʏ��
strConsultFlg    = ConvIStringToArray(Request("cFlg"))
strItemCd        = ConvIStringToArray(Request("itemCd"))
strSuffix        = ConvIStringToArray(Request("suffix"))
strItemName      = ConvIStringToArray(Request("itemName"))
strResult        = ConvIStringToArray(Request("result"))
strResultErr     = ConvIStringToArray(Request("resultErr"))
strResultType    = ConvIStringToArray(Request("resultType"))
strItemType      = ConvIStringToArray(Request("itemType"))
strStcItemCd     = ConvIStringToArray(Request("stcItemCd"))
strShortStc      = ConvIStringToArray(Request("shortStc"))
strRslCmtCd1     = ConvIStringToArray(Request("rslCmtCd1"))
strRslCmtErr1    = ConvIStringToArray(Request("rslCmtErr1"))
strRslCmtName1   = ConvIStringToArray(Request("rcNm1"))
strRslCmtCd2     = ConvIStringToArray(Request("rslCmtCd2"))
strRslCmtErr2    = ConvIStringToArray(Request("rslCmtErr2"))
strRslCmtName2   = ConvIStringToArray(Request("rcNm2"))
strBefResult     = ConvIStringToArray(Request("befResult"))
strBefShortStc   = ConvIStringToArray(Request("befStc"))
strStdFlg        = ConvIStringToArray(Request("stdFlg"))
strInitRsl       = ConvIStringToArray(Request("initRsl"))
strInitRslCmt1   = ConvIStringToArray(Request("initRslCmt1"))
strInitRslCmt2   = ConvIStringToArray(Request("initRslCmt2"))
strDefResult     = ConvIStringToArray(Request("defResult"))
strDefShortStc   = ConvIStringToArray(Request("defShortStc"))
strDefRslCmtCd   = ConvIStringToArray(Request("defRslCmtCd"))
strDefRslCmtName = ConvIStringToArray(Request("defRslCmtName"))
strLastRsvNo     = Request("lastRsvNo")

lngCount        = CLng("0" & Request("count"))
lngUpdItemCount = CLng("0" & Request("updItemCount"))

'���͒萔
strPortrait  = ORIENTATION_PORTRAIT
strLandscape = ORIENTATION_LANDSCAPE

'�J�[�\�������擾
strOrientation = CLng(objCommon.SelectRslOrientation)
If Trim(strOrientation) = "" Then
	strOrientation = ORIENTATION_PORTRAIT		'�c
End If

'�`�F�b�N�E�X�V�E�ǂݍ��ݏ����̐���
Do

	Do
		'�e���[�h���Ƃ̏�������
		Select Case strActMode

			'�O��f�ҁE����f�҂�
			Case ACTMODE_PREVIOUS, ACTMODE_NEXT

				'�O���f�҂̗\��ԍ��E����ID�擾
'## 2004.01.09 Mod By T.Takagi@FSIT ���@�֘A�ǉ�
'				objConsult.SelectCurRsvNoPrevNext dtmCslDate, strKeyCsCd, strKeySortKey, CLng("0" & strKeyCntlNo), True, False, False, strRsvNo, strPrevRsvNo, strPrevDayId, strNextRsvNo, strNextDayId
				objConsult.SelectCurRsvNoPrevNext dtmCslDate, strKeyCsCd, strKeySortKey, CLng("0" & strKeyCntlNo), True, False, False, strRsvNo, strPrevRsvNo, strPrevDayId, strNextRsvNo, strNextDayId, True
'## 2004.01.09 Mod End

				'�O��f�҂̎�f��񂪑��݂��Ȃ��ꍇ
				If strActMode = "previous" And strPrevRsvNo = "" Then
					Err.Raise 1000, , "�O��f�҂̎�f���͑��݂��܂���B"
				End If

				'����f�҂̎�f��񂪑��݂��Ȃ��ꍇ
				If strActMode = "next" And strNextRsvNo = "" Then
					Err.Raise 1000, , "����f�҂̎�f���͑��݂��܂���B"
				End If

				'���ݎ��̓��_�C���N�g�p��URL��ҏW����
				strURL = Request.ServerVariables("SCRIPT_NAME")
				strURL = strURL & "?dispMode=" & strDispMode
				strURL = strURL & "&rsvNo="    & IIf(strActMode = "previous", strPrevRsvNo, strNextRsvNo)
				strURL = strURL & "&mode="     & strMode
				strURL = strURL & "&code="     & strCode
				strURL = strURL & "&cslYear="  & strKeyCslYear
				strURL = strURL & "&cslMonth=" & strKeyCslMonth
				strURL = strURL & "&cslDay="   & strKeyCslDay
				strURL = strURL & "&cntlNo="   & strKeyCntlNo
				strURL = strURL & "&csCd="     & strKeyCsCd
				strURL = strURL & "&sortKey="  & strKeySortKey
				strURL = strURL & "&dayId="    & IIf(strActMode = "previous", strPrevDayId, strNextDayId)
				strURL = strURL & "&echo="     & strEcho

				'�O���f�҂̌��ʓ��͉�ʂ�
				Response.Redirect strURL
				Response.End

			'�ۑ�
			Case ACTMODE_SAVE

				lngUpdCount = 0
				strUpdIndex = Array()
				strUpdItemCd = Array()
				strUpdSuffix = Array()
				strUpdResult = Array()
				strUpdRslCmtCd1 = Array()
				strUpdRslCmtCd2 = Array()

				'���ۂɍX�V���s�����ڂ݂̂𒊏o(�����\���f�[�^�ƈقȂ�f�[�^���X�V�Ώ�)
				For i = 0 To UBound(strConsultFlg)

					Do

						'��f���ڂłȂ��ꍇ�͒ǉ����Ȃ�
						If strConsultFlg(i) <> CStr(CONSULT_ITEM_T) Then
							Exit Do
						End If

						'���ʁA���ʃR�����g�̉�����X�V����Ă��Ȃ��ꍇ�͒ǉ����Ȃ�
						If strResult(i) = strInitRsl(i) And strRslCmtCd1(i) = strInitRslCmt1(i) And strRslCmtCd2(i) = strInitRslCmt2(i) Then
							Exit Do
						End If

						'�X�V���ڂ�ǉ�
						ReDim Preserve strUpdIndex(lngUpdCount)
						ReDim Preserve strUpdItemCd(lngUpdCount)
						ReDim Preserve strUpdSuffix(lngUpdCount)
						ReDim Preserve strUpdResult(lngUpdCount)
						ReDim Preserve strUpdRslCmtCd1(lngUpdCount)
						ReDim Preserve strUpdRslCmtCd2(lngUpdCount)
						strUpdIndex(lngUpdCount)     = i
						strUpdItemCd(lngUpdCount)    = strItemCd(i)
						strUpdSuffix(lngUpdCount)    = strSuffix(i)
						strUpdResult(lngUpdCount)    = strResult(i)
						strUpdRslCmtCd1(lngUpdCount) = strRslCmtCd1(i)
						strUpdRslCmtCd2(lngUpdCount) = strRslCmtCd2(i)
						lngUpdCount = lngUpdCount + 1

						Exit Do
					Loop

				Next

				'�X�V�ΏۂƂȂ錟�����ڂ������
				If lngUpdCount > 0 Then

					'�������ʍX�V
					If objResult.UpdateResultForDetail(strRsvNo, strIPAddress, strUpdUser, strUpdItemCd, strUpdSuffix, strUpdResult, strUpdShortStc, strUpdResultErr, strUpdRslCmtCd1, strUpdRslCmtName1, strUpdRslCmtErr1, strUpdRslCmtCd2, strUpdRslCmtName2, strUpdRslCmtErr2, strArrMessage) = False Then

						'�G���[���͕��͕\�����[�h�ɕύX
						strDispMode = DISPMODE_DETAIL

						'�`�F�b�N���ʂɂĒl��u��������
						For i = 0 To lngUpdCount - 1
							strResult(strUpdIndex(i))      = strUpdResult(i)
							strShortStc(strUpdIndex(i))    = strUpdShortStc(i)
							strResultErr(strUpdIndex(i))   = strUpdResultErr(i)
							strRslCmtCd1(strUpdIndex(i))   = strUpdRslCmtCd1(i)
							strRslCmtName1(strUpdIndex(i)) = strUpdRslCmtName1(i)
							strRslCmtErr1(strUpdIndex(i))  = strUpdRslCmtErr1(i)
							strRslCmtCd2(strUpdIndex(i))   = strUpdRslCmtCd2(i)
							strRslCmtName2(strUpdIndex(i)) = strUpdRslCmtName2(i)
							strRslCmtErr2(strUpdIndex(i))  = strUpdRslCmtErr2(i)
						Next

						Exit Do
					End If

				End If

				'�G���[���Ȃ���ΐe�t���[��REPLACE�p��URL��ҏW
				strURL = "rslMain.asp"
				strURL = strURL & "?actMode="    & ACTMODE_SAVEEND
				strURL = strURL & "&dispMode="   & strDispMode
				strURL = strURL & "&rsvNo="      & strRsvNo
				strURL = strURL & "&mode="       & strMode
				strURL = strURL & "&code="       & strCode
				strURL = strURL & "&cslYear="    & strKeyCslYear
				strURL = strURL & "&cslMonth="   & strKeyCslMonth
				strURL = strURL & "&cslDay="     & strKeyCslDay
				strURL = strURL & "&cntlNo="     & strKeyCntlNo
				strURL = strURL & "&csCd="       & strKeyCsCd
				strURL = strURL & "&sortKey="    & strKeySortKey
				strURL = strURL & "&dayId="      & strKeyDayId
				strURL = strURL & "&noPrevNext=" & strNoPrevNext
				strURL = strURL & "&echo="       & strEcho

				'�e�t���[����URL��REPLACE����
				strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
				strHTML = strHTML & "<BODY ONLOAD=""JavaScript:top.location.replace('" & strURL & "')"">"
				strHTML = strHTML & "</BODY>"
				strHTML = strHTML & "</HTML>"
				Response.Write strHTML
				Response.End

		End Select

		Exit Do
	Loop

	'����ID���w�肳��Ă���ꍇ
	If strKeyDayId <> "" Then

		'��t�������ƂɎ�f����ǂݍ���
		Ret = objConsult.SelectConsultFromReceipt(dtmCslDate,               _
												  CLng("0" & strKeyCntlNo), _
												  CLng(strKeyDayId),        _
												  strRsvNo,                 _
												  strCslDate,               _
												  strPerID,                 _
												  strLastName,              _
												  strFirstName,             _
												  strLastKName,             _
												  strFirstKName,            _
												  strBirth,                 _
												  strGender,                _
												  strCsCd,                  _
												  strCsName,                _
												  strAge)

		'�[���ʉߏ��̎擾
		If objWorkStation.SelectPassedInfo(dtmCslDate, 0, strKeyDayId, strIPAddress, ,strPassedDate) < 1 Then
			strPassedDate = ""
		End If

	'����ID���w�肳��Ă��Ȃ��ꍇ
	Else

		'��f��񌟍�
		Ret = objConsult.SelectConsult(strRsvNo, 0, strCslDate, strPerId, strCsCd, strCsName, , , , , , _
									   strAge, , , , , , , , , , , , , _
									   strKeyDayId, , , , , , , , , , , , , , , , , , _
									   strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender)

	End If

	'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
	If Ret = False Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B"
	End If

'## 2004.01.09 Add By T.Takagi@FSIT ���@�֘A�ǉ�
	'��t���y�ї��@��Ԃ��擾
	Ret2 = objConsult.SelectReceipt(strRsvNo, , , , strComeDate)
	If Ret2 = False Then
		Err.Raise 1000, , "���̎�f�҂͎�t����Ă��܂���B���ʓ��͂͂ł��܂���B"
	End If

	'�����@�̎�f���ɑ΂��錋�ʓ��͕͂s��
	If strComeDate = "" Then
		Err.Raise 1000, , "���̎�f�҂͂܂������@�ł��B���ʓ��͂͂ł��܂���B"
	End If
'## 2004.01.09 Add End

	'�\�����[�h�ύX���̓e�[�u������ǂݍ��܂Ȃ�
	If strActMode = ACTMODE_CHANGE Then
		Exit Do
	End If

	'�ۑ����[�h�Ń`�F�b�N�G���[�����������ꍇ�̓e�[�u������ǂݍ��܂Ȃ�
	If strActMode = ACTMODE_SAVE And Not IsEmpty(strArrMessage) Then
		Exit Do
	End If

	'���������𖞂������w��J�n�ʒu�A�������̃��R�[�h���擾
	lngCount = objResult.SelectRslList( _
				   strMode, strRsvNo, strCode, lngUpdItemCount, strSeq, _
				   strConsultFlg, strItemCd, strSuffix, strItemName, _
				   strResult, strResultType, strItemType, strStcItemCd, _
				   strShortStc, strRslCmtCd1, strRslCmtName1, strRslCmtCd2, _
				   strRslCmtName2, strBefResult, strBefShortStc, strStdFlg, _
				   strDefResult, strDefShortStc, strDefRslCmtCd, strDefRslCmtName, strLastRsvNo _
			   )

	'�ǂݍ��񂾒���̌��ʁA���ʃR�����g��������Ԃ̔z��Ƃ��ĕێ�
	strInitRsl     = strResult
	strInitRslCmt1 = strRslCmtCd1
	strInitRslCmt2 = strRslCmtCd2

	'�G���[�����p�̔z��쐬
	If lngCount > 0 Then
		ReDim strResultErr(lngCount - 1)
		ReDim strRslCmtErr1(lngCount - 1)
		ReDim strRslCmtErr2(lngCount - 1)
	End If

	Exit Do
Loop

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �������ʏ��ꗗ�̕ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditRslList()

	Const CLASS_ERROR     = " rslErr"				'�G���[�\���̃N���X�w��
	Dim objCourse			'�R�[�X���A�N�Z�X�p
	Dim strDispStdFlgColor	'�ҏW�p��l�\���F
	Dim strClass			'�X�^�C���V�[�g��CLASS�w��
	Dim strHTML				'HTML������
	Dim i					'�C���f�b�N�X

	Dim strLastCslDate		'�O���f��
	Dim strLastCsCd			'�O��R�[�X�R�[�h
	Dim strLastCsName		'�O��R�[�X��
	Dim strLastCsSName		'�O��R�[�X����
	Dim strLastInfo			'�O����

	If lngCount = 0 Then
		Exit Sub
	End If
%>
	<INPUT TYPE="hidden" NAME="lastRsvNo" VALUE="<%= strLastRsvNo %>">

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" STYLE="table-layout: fixed;">
		<TR>
			<TD style="width: 15em;"></TD>
			<TD style="width: 21px;"></TD>
			<TD style="width: 67px;"></TD>
			<TD style="width:180px;"></TD>
			<TD style="width: 21px;"></TD>
			<TD style="width: 30px;"></TD>
			<TD style="width: 80px;"></TD>
			<TD style="width: 21px;"></TD>
			<TD style="width: 30px;"></TD>
			<TD style="width: 80px;"></TD>
			<TD style="width:200px;"></TD>
		</TR>
		<TR BGCOLOR="#eeeeee">
			<TD HEIGHT="21" ALIGN="right">�������ږ�</TD>
			<TD COLSPAN="2">��������</TD>
			<TD>����</TD>
			<TD COLSPAN="6" ALIGN="center">�R�����g</TD>
<%
			'�O��\��ԍ������݂���ꍇ
			If strLastRsvNo <> "" Then

				If objConsult.SelectConsult(strLastRsvNo, , strLastCslDate, , strLastCsCd) = True Then

					'�I�u�W�F�N�g�̃C���X�^���X�쐬
					Set objCourse = Server.CreateObject("HainsCourse.Course")

					'�R�[�X���̎擾
					objCourse.SelectCourse strLastCsCd, strLastCsName, , , , , , , , , , , , , , , , , , , , , , , , strLastCsSName

					Set objCourse = Nothing

					strLastInfo = strLastCslDate & "�F" & strLastCsSName

				End If

			End If
%>
			<TD>�O��i<%= IIf(strLastInfo <> "", strLastInfo, "�Ȃ�") %>�j</TD>
		</TR>
<%
		'�������ʈꗗ�̕ҏW�J�n
		For i = 0 To lngCount - 1

			'�������ږ���
%>
			<TR BGCOLOR="#eeeeee">
				<TD ALIGN="right"><A HREF="javascript:callDtlGuide('<%= i %>')"><%= strItemName(i) %></A>
<%
					'���ʍ��ڏ��
					strHTML = ""
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""cFlg"" VALUE=""" & strConsultFlg(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""itemCd"" VALUE=""" & strItemCd(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""suffix"" VALUE=""" & strSuffix(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""itemName"" VALUE=""" & strItemName(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""resultType"" VALUE=""" & strResultType(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""itemType"" VALUE=""" & strItemType(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""stcItemCd"" VALUE=""" & strStcItemCd(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""shortStc"" VALUE=""" & strShortStc(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""resultErr"" VALUE=""" & strResultErr(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""rslCmtErr1"" VALUE=""" & strRslCmtErr1(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""rcNm1"" VALUE=""" & strRslCmtName1(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""rslCmtErr2"" VALUE=""" & strRslCmtErr2(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""rcNm2"" VALUE=""" & strRslCmtName2(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""befResult"" VALUE=""" & strBefResult(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""befStc"" VALUE=""" & strBefShortStc(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""stdFlg"" VALUE=""" & strStdFlg(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""initRsl"" VALUE=""" & strInitRsl(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""initRslCmt1"" VALUE=""" & strInitRslCmt1(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""initRslCmt2"" VALUE=""" & strInitRslCmt2(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""defResult"" VALUE=""" & strDefResult(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""defShortStc"" VALUE=""" & strDefShortStc(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""defRslCmtCd"" VALUE=""" & strDefRslCmtCd(i) & """>"
					strHTML = strHTML & "<INPUT TYPE=""hidden"" NAME=""defRslCmtName"" VALUE=""" & strDefRslCmtName(i) & """>"
					Response.Write strHTML
%>
				</TD>
<%
				If Not IsEmpty(strItemCd(i)) And Trim(strItemCd(i)) <> "" And CStr(strConsultFlg(i)) = CStr(CONSULT_ITEM_T) Then

					Select Case CLng(strResultType(i))

						'�萫�K�C�h�\��
						Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
							<TD><A HREF="javascript:callTseGuide('<%= i %>')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="�萫�K�C�h�\��"></A></TD>
<%
						'���̓K�C�h�\��
						Case RESULTTYPE_SENTENCE
%>
							<TD><A HREF="javascript:callStcGuide('<%= i %>')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���̓K�C�h�\��"></A></TD>
<%
						'�K�C�h�\���Ȃ�
						Case Else
%>
							<TD HEIGHT="21"></TD>
<%
					End Select

					'�������ʁ�����

					'��l�t���O�ɂ��F��ݒ肷��
					Select Case strStdFlg(i)
						Case STDFLG_H
							strDispStdFlgColor = "resultcolor-h"
						Case STDFLG_U
							strDispStdFlgColor = "resultcolor-u"
						Case STDFLG_D
							strDispStdFlgColor = "resultcolor-d"
						Case STDFLG_L
							strDispStdFlgColor = "resultcolor-l"
						Case STDFLG_T1
							strDispStdFlgColor = "resultcolor-t1"
						Case STDFLG_T2
							strDispStdFlgColor = "resultcolor-t2"
						Case Else
							strDispStdFlgColor = ""
					End Select

					If strResultErr(i) <> "" Then
						strClass       = CLASS_ERROR
					Else
						strClass       = ""
					End If

					'�v�Z���ʂ̏ꍇ
					If CLng(strResultType(i)) = RESULTTYPE_CALC Then
%>
						<TD ALIGN="right" style="padding:0 8px 0 0;"><INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(i) %>"><SPAN class="<%= strDispStdFlgColor %>"><%= strResult(i) %></SPAN></TD>
<%
					'����ȊO�̏ꍇ
					Else
%>
						<TD NOWRAP><INPUT TYPE="text" NAME="result" SIZE="<%= TextLength(8) %>" MAXLENGTH="8" VALUE="<%= strResult(i) %>" class="<%= strDispStdFlgColor %> <%= IIf(CLng(strResultType(i)) = RESULTTYPE_NUMERIC, " alignright", "") %><%= strClass %>"  ONFOCUS="return resultClick('<%= i %>')" ONCHANGE="clearStcName('<%= i %>')"></TD>
<%
					End If
%>
					<TD><SPAN ID="stcName<%= i %>"><%= strShortStc(i) %></SPAN></TD>
<%
					'���ʃR�����g1
%>
					<TD><A HREF="javascript:callCmtGuide(1, '<%= i %>')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ʃR�����g�K�C�h�\��"></A></TD>
<%
					'�X�^�C���V�[�g�̐ݒ�
					strClass = IIf(strRslCmtErr1(i) <> "", CLASS_ERROR, "")
%>
					<TD><INPUT TYPE="text" NAME="rslCmtCd1" SIZE="3" MAXLENGTH="3" VALUE="<%= strRslCmtCd1(i) %>" class="<%= strClass %>" ONFOCUS="javascript:rlCmtCd1Click('<%= i %>')"></TD>
					<TD><SPAN ID="rcNm1_<%= i %>"><%= strRslCmtName1(i) %></SPAN></TD>
<%
					'���ʃR�����g2
%>
					<TD><A HREF="javascript:callCmtGuide(2, '<%= i %>')"><IMG SRC="../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="���ʃR�����g�K�C�h�\��"></A></TD>
<%
					'�X�^�C���V�[�g�̐ݒ�
					strClass = IIf(strRslCmtErr2(i) <> "", CLASS_ERROR, "")
%>
					<TD><INPUT TYPE="text" NAME="rslCmtCd2" SIZE="<%= TextLength(3) %>" MAXLENGTH="3" VALUE="<%= strRslCmtCd2(i) %>" class="<%= strClass %>" ONFOCUS="javascript:rlCmtCd2Click('<%= i %>')"></TD>
					<TD><SPAN ID="rcNm2_<%= i %>"><%= strRslCmtName2(i) %></SPAN></TD>
<%
				Else
%>
					<TD HEIGHT="21"><INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(i) %>"></TD>
					<TD></TD>
					<TD></TD>
					<TD></TD>
					<TD><INPUT TYPE="hidden" NAME="rslCmtCd1" VALUE="<%= strRslCmtCd1(i) %>"></TD>
					<TD></TD>
					<TD></TD>
					<TD><INPUT TYPE="hidden" NAME="rslCmtCd2" VALUE="<%= strRslCmtCd2(i) %>"></TD>
					<TD></TD>
<%
				End If
%>
				<TD><%= IIf(CLng(strResultType(i)) = RESULTTYPE_SENTENCE, strBefShortStc(i), strBefResult(i)) %></TD>
			</TR>
<%
		Next
%>
	</TABLE>
<%
End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �������ʏ��ꗗ�̕ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub EditRslListSimply()

	Const CLASS_ERROR     = " rslErr"				'�G���[�\���̃N���X�w��

	Dim strDispStdFlgColor	'�ҏW�p��l�\���F

	Dim strClass			'�X�^�C���V�[�g��CLASS�w��

	Dim i					'�C���f�b�N�X
	Dim j					'�C���f�b�N�X
%>
	<INPUT TYPE="hidden" NAME="lastRsvNo" VALUE="<%= strLastRsvNo %>">

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">
		<TR BGCOLOR="#eeeeee">
<%
			'�\��̕ҏW
			For i = 0 To lngCount - 1

				If i > 2 Then
					Exit For
				End If
%>
				<TD HEIGHT="21" ALIGN="right"><IMG SRC="/webHains/images/spacer.gif" WIDTH="128" HEIGHT="1"><BR>�������ږ�</TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="90" HEIGHT="1"><BR>��������</TD>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="110" HEIGHT="1"><BR>�O�񌋉�</TD>
<%
			Next
%>
		</TR>
<%
		'�������ʈꗗ�̕ҏW�J�n
		For i = 0 To lngCount - 1 Step 3
%>
			<TR BGCOLOR="#eeeeee">
<%
				For j = i To i + 2

					If j > (lngCount - 1) Then
						Exit For
					End If

					'�������ږ���
%>
					<TD ALIGN="right"><A HREF="javascript:callDtlGuide('<%= j %>')"><%= strItemName(j) %></A>
<%
						'���ʍ��ڏ��
%>
						<INPUT TYPE="hidden" NAME="cFlg"        VALUE="<%= strConsultFlg(j)      %>">
						<INPUT TYPE="hidden" NAME="itemCd"      VALUE="<%= strItemCd(j)          %>">
						<INPUT TYPE="hidden" NAME="suffix"      VALUE="<%= strSuffix(j)          %>">
						<INPUT TYPE="hidden" NAME="itemName"    VALUE="<%= strItemName(j)        %>">
						<INPUT TYPE="hidden" NAME="resultType"  VALUE="<%= strResultType(j)      %>">
						<INPUT TYPE="hidden" NAME="itemType"    VALUE="<%= strItemType(j)        %>">
						<INPUT TYPE="hidden" NAME="stcItemCd"   VALUE="<%= strStcItemCd(j)       %>">
						<INPUT TYPE="hidden" NAME="shortStc"    VALUE="<%= strShortStc(j)        %>">
						<INPUT TYPE="hidden" NAME="resultErr"   VALUE="<%= strResultErr(j)       %>">
						<INPUT TYPE="hidden" NAME="rslCmtErr1"  VALUE="<%= strRslCmtErr1(j)      %>">
						<INPUT TYPE="hidden" NAME="rcNm1" VALUE="<%= strRslCmtName1(j)     %>">
						<INPUT TYPE="hidden" NAME="rslCmtErr2"  VALUE="<%= strRslCmtErr2(j)      %>">
						<INPUT TYPE="hidden" NAME="rcNm2" VALUE="<%= strRslCmtName2(j)     %>">
						<INPUT TYPE="hidden" NAME="befResult"   VALUE="<%= strBefResult(j)       %>">
						<INPUT TYPE="hidden" NAME="befStc" VALUE="<%= strBefShortStc(j)     %>">
						<INPUT TYPE="hidden" NAME="stdFlg"      VALUE="<%= strStdFlg(j)          %>">
						<INPUT TYPE="hidden" NAME="initRsl"     VALUE="<%= strInitRsl(j)         %>">
						<INPUT TYPE="hidden" NAME="initRslCmt1" VALUE="<%= strInitRslCmt1(j)     %>">
						<INPUT TYPE="hidden" NAME="initRslCmt2" VALUE="<%= strInitRslCmt2(j)     %>">
						<INPUT TYPE="hidden" NAME="defResult"   VALUE="<%= strDefResult(j)       %>">
						<INPUT TYPE="hidden" NAME="defShortStc" VALUE="<%= strDefShortStc(j)     %>">
						<INPUT TYPE="hidden" NAME="defRslCmtCd"   VALUE="<%= strDefRslCmtCd(j)   %>">
						<INPUT TYPE="hidden" NAME="defRslCmtName" VALUE="<%= strDefRslCmtName(j) %>">
					</TD>
<%
					If Not IsEmpty(strItemCd(j)) And Trim(strItemCd(j)) <> "" And CStr(strConsultFlg(j)) = CStr(CONSULT_ITEM_T) Then
%>
						<TD>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
								<TR>
<%
									Select Case CLng(strResultType(j))

										'�萫�K�C�h�\��
										Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
%>
											<TD><A HREF="javascript:callTseGuide('<%= j %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�萫�K�C�h�\��"></A></TD>
<%
										'���̓K�C�h�\��
										Case RESULTTYPE_SENTENCE
%>
											<TD><A HREF="javascript:callStcGuide('<%= j %>')"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="���̓K�C�h�\��"></A></TD>
<%
										'�K�C�h�\���Ȃ�
										Case Else
%>
											<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21"></TD>
<%
									End Select

									'�������ʁ�����

									'��l�t���O�ɂ��F��ݒ肷��
									Select Case strStdFlg(j)
										Case STDFLG_H
											strDispStdFlgColor = "resultcolor-h"
										Case STDFLG_U
											strDispStdFlgColor = "resultcolor-u"
										Case STDFLG_D
											strDispStdFlgColor = "resultcolor-d"
										Case STDFLG_L
											strDispStdFlgColor = "resultcolor-l"
										Case STDFLG_T1
											strDispStdFlgColor = "resultcolor-t1"
										Case STDFLG_T2
											strDispStdFlgColor = "resultcolor-t2"
										Case Else
											strDispStdFlgColor = ""
									End Select

									If strResultErr(j) <> "" Then
										strClass       = CLASS_ERROR
									Else
										strClass       = ""
									End If

									'�v�Z���ʂ̏ꍇ
									If CLng(strResultType(j)) = RESULTTYPE_CALC Then
%>
										<TD><INPUT TYPE="hidden" NAME="result" VALUE="<%= strResult(j) %>"><SPAN class="<%= strDispStdFlgColor %> alignright"><%= strResult(j) %></SPAN></TD>
<%
									'����ȊO�̏ꍇ
									Else
%>
										<TD NOWRAP>
											<INPUT TYPE="text" NAME="result" SIZE="<%= TextLength(8) %>" MAXLENGTH="8" VALUE="<%= strResult(j) %>" class="<%= strDispStdFlgColor %> <%= IIf(CLng(strResultType(i)) = RESULTTYPE_NUMERIC, " alignright", "") %><%= strClass %>"  ONFOCUS="return resultClick('<%= j %>')" ONCHANGE="clearStcName('<%= j %>')">
										</TD>
<%
									End If
%>
								</TR>
							</TABLE>
						</TD>
<%
						'�O�񌋉�
%>
						<TD WIDTH="100">
							&nbsp;<%= strBefResult(j) %>
<%
							'���ʃR�����g�P
%>
							<INPUT TYPE="hidden" NAME="rslCmtCd1" VALUE="<%= strRslCmtCd1(j) %>">
<%
							'���ʃR�����g�Q
%>
							<INPUT TYPE="hidden" NAME="rslCmtCd2" VALUE="<%= strRslCmtCd2(j) %>">
						</TD>
<%
					Else
%>
						<TD>
							<INPUT TYPE="hidden" NAME="result"    VALUE="<%= strResult(j)    %>">
							<INPUT TYPE="hidden" NAME="rslCmtCd1" VALUE="<%= strRslCmtCd1(j) %>">
							<INPUT TYPE="hidden" NAME="rslCmtCd2" VALUE="<%= strRslCmtCd2(j) %>">
						</TD>
						<TD WIDTH="100"><IMG SRC="/webHains/images/spacer.gif" WIDTH="100" HEIGHT="21"></TD>
<%
					End If

				Next
%>
			</TR>
<%
		Next
%>
	</TABLE>
<%
End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="x-ua-compatible" content="IE=10">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>���ʓ���</TITLE>
<!-- #include virtual = "/webHains/includes/printDialog.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/tseGuide.inc"    -->
<!-- #include virtual = "/webHains/includes/stcGuide.inc"    -->
<!-- #include virtual = "/webHains/includes/cmtGuide.inc"    -->
<!-- #include virtual = "/webHains/includes/dtlGuide.inc"    -->
<!-- #include virtual = "/webHains/includes/repGuide.inc"    -->
<!--
var lngSelectedIndex1;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X
var lngSelectedIndex2;  // �K�C�h�\�����ɑI�����ꂽ�G�������g�̃C���f�b�N�X

var winProgress;		// �i���Ǘ��E�B���h�E�I�u�W�F�N�g
var winHistory;			// �o�N�ω��E�B���h�E�I�u�W�F�N�g

function updatePassedInfo( passedDate ) {

	var html;	// HTML������

	// �ʉߓ����̑��ݗL���ɂ�郁�b�Z�[�W�̃n���h�����O
	if ( passedDate != '' ) {
		html = '<A HREF="javascript:UpdateProgress(false)">' + passedDate + '�ɒʉ߂��܂����B</A>';
	} else {
		html = '<A HREF="javascript:UpdateProgress(true)">�ʉߏ����X�V</A>';
	}

	// �u���E�U���Ƃ̒c�̖��ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// IE�̏ꍇ
		if ( document.all ) {
			document.all('passedInfo').innerHTML = html;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(passedInfo).innerHTML = html;
		}

		break;
	}

}

// �i���Ǘ��p�y�[�W���Ăяo��
function UpdateProgress( InsertMode ) {

	var opened = false;	// ��ʂ��J����Ă��邩
	var url;			// �i���Ǘ���ʂ�URL

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winProgress != null ) {
		if ( !winProgress.closed ) {
			opened = true;
		}
	}

	// �i���Ǘ���ʂ�URL�ҏW
	url = '/webHains/contents/result/passedInfo.asp?dayId=<%= strKeyDayId %>&cslDate=<%= dtmCslDate %>';

	if ( InsertMode == false ) {
		url = url + '&mode=<%= DISPMODE_DELETE %>'
	}

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winProgress.focus();
	} else {
		winProgress = window.open(url , '', 'width=450,height=200,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no');
	}

}

// �ꗗ��ʂƂ̏������ك`�F�b�N
function checkCondition() {

	var listForm = top.list.document.entryForm;	// ��f�҈ꗗ��ʂ̃t�H�[���G�������g

	var conditionFlg;							// �����t���O

	// �����������ύX����Ă��邩�𔻒�
	for ( conditionFlg = false; ; ) {

		// ��f���i�N�j
		if ( listForm.cslYear.value != '<%= strKeyCslYear %>' ) {
			break;
		}

		// ��f���i���j
		if ( listForm.cslMonth.value != '<%= strKeyCslMonth %>' ) {
			break;
		}

		// ��f���i���j
		if ( listForm.cslDay.value != '<%= strKeyCslDay %>' ) {
			break;
		}

		// �R�[�X
		if ( listForm.csCd.value != '<%= strKeyCsCd %>' ) {
			break;
		}

		// ���я�
		if ( listForm.sortKey.value != '<%= strKeySortKey %>' ) {
			break;
		}

		// �Ǘ��ԍ�
		if ( listForm.cntlNo.value != '<%= strKeyCntlNo %>' ) {
			break;
		}

		conditionFlg = true;
		break;
	}

	return conditionFlg;
}

// �萫�K�C�h�Ăяo��
function callTseGuide( index ) {

	var myForm = document.resultList;

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(�萫���ʂ̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex1 = index;

	// �K�C�h��ʂ̘A����ɍ��ڃ^�C�v��ݒ肷��
	if ( myForm.resultType.length != null ) {
		tseGuide_ResultType = myForm.resultType[ index ].value;
	} else {
		tseGuide_ResultType = myForm.resultType.value;
	}

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	tseGuide_CalledFunction = setTseInfo;

	// �萫�K�C�h�\��
	showGuideTse();
}

// �萫���ʂ̃Z�b�g
function setTseInfo() {

	var myForm = document.resultList;

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( myForm.result.length != null ) {
		myForm.result[lngSelectedIndex1].value = tseGuide_Result;
	} else {
		myForm.result.value = tseGuide_Result;
	}
	return false;
}

// ���̓K�C�h�Ăяo��
function callStcGuide( index ) {

	var myForm = document.resultList;

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���̓R�[�h�E�����͂̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex1 = index;

	// �K�C�h��ʂ̘A����Ɍ������ڃR�[�h��ݒ肷��
	if ( myForm.stcItemCd.length != null ) {
		stcGuide_ItemCd = myForm.stcItemCd[ index ].value;
	} else {
		stcGuide_ItemCd = myForm.stcItemCd.value;
	}

	// �K�C�h��ʂ̘A����ɍ��ڃ^�C�v�i�W���j��ݒ肷��
	if ( myForm.itemType.length != null ) {
		stcGuide_ItemType = myForm.itemType[ index ].value;
	} else {
		stcGuide_ItemType = myForm.itemType.value;
	}

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	stcGuide_CalledFunction = setStcInfo;

	// ���̓K�C�h�\��
	showGuideStc();
}

// ���̓R�[�h�E�����͂̃Z�b�g
function setStcInfo() {

	setStc( lngSelectedIndex1, stcGuide_StcCd, stcGuide_ShortStc );

}

// �������ڐ����Ăяo��
function callDtlGuide( index ) {

	var myForm = document.resultList;

	// ������ʂ̘A����ɉ�ʓ��͒l��ݒ肷��
	if ( myForm.itemCd.length != null ) {
		dtlGuide_ItemCd = myForm.itemCd[ index ].value;
	} else {
		dtlGuide_ItemCd = myForm.itemCd.value;
	}
	if ( myForm.suffix.length != null ) {
		dtlGuide_Suffix = myForm.suffix[ index ].value;
	} else {
		dtlGuide_Suffix = myForm.suffix.value;
	}

	dtlGuide_CsCd         = '<%= strCsCd           %>';
	dtlGuide_CslDateYear  = '<%= Year(strCslDate)  %>';
	dtlGuide_CslDateMonth = '<%= Month(strCslDate) %>';
	dtlGuide_CslDateDay   = '<%= Day(strCslDate)   %>';
	dtlGuide_Age          = '<%= strAge            %>';
	dtlGuide_Gender       = '<%= strGender         %>';

	// �������ڐ����\��
	showGuideDtl();

}

// ���ʃR�����g�K�C�h�Ăяo��
function callCmtGuide( index1, index2 ) {

	// �I�����ꂽ�G�������g�̃C���f�b�N�X��ޔ�(���ʃR�����g�R�[�h�E���ʃR�����g���̃Z�b�g�p�֐��ɂĎg�p����)
	lngSelectedIndex1 = index1;
	lngSelectedIndex2 = index2;

	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
	cmtGuide_CalledFunction = setCmtInfo;

	// ���ʃR�����g�K�C�h�\��
	showGuideCmt();
}

// ���ʃR�����g�R�[�h�E���ʃR�����g���̃Z�b�g
function setCmtInfo() {

	var rslCmtNameElement;	/* ���ʃR�����g����ҏW����G�������g�̖��� */
	var rslCmtName;			/* ���ʃR�����g����ҏW����G�������g���g */
	var myForm = document.resultList;

	// �\�ߑޔ������C���f�b�N�X��̃G�������g�ɁA�K�C�h��ʂŐݒ肳�ꂽ�A����̒l��ҏW
	if ( lngSelectedIndex1 == 1 ) {
		if ( myForm.rslCmtCd1.length != null ) {
			myForm.rslCmtCd1[lngSelectedIndex2].value = cmtGuide_RslCmtCd;
		} else {
			myForm.rslCmtCd1.value = cmtGuide_RslCmtCd;
		}
		if ( myForm.rcNm1.length != null ) {
			myForm.rcNm1[lngSelectedIndex2].value = cmtGuide_RslCmtName;
		} else {
			myForm.rcNm1.value = cmtGuide_RslCmtName;
		}
	} else {
		if ( myForm.rslCmtCd2.length != null ) {
			myForm.rslCmtCd2[lngSelectedIndex2].value = cmtGuide_RslCmtCd;
		} else {
			myForm.rslCmtCd2.value = cmtGuide_RslCmtCd;
		}
		if ( myForm.rcNm2.length != null ) {
			myForm.rcNm2[lngSelectedIndex2].value = cmtGuide_RslCmtName;
		} else {
			myForm.rcNm2.value = cmtGuide_RslCmtName;
		}
	}

	// �u���E�U���Ƃ̌��ʃR�����g���ҏW�p�G�������g�̐ݒ菈��
	for ( ; ; ) {

		// �G�������g���̕ҏW
		rslCmtNameElement = 'rcNm' + lngSelectedIndex1 + '_' + lngSelectedIndex2;

		// IE�̏ꍇ
		if ( document.all ) {
			document.all(rslCmtNameElement).innerHTML = cmtGuide_RslCmtName;
			break;
		}

		// Netscape6�̏ꍇ
		if ( document.getElementById ) {
			document.getElementById(rslCmtNameElement).innerHTML = cmtGuide_RslCmtName;
		}

	break;
	}

	return false;
}

// ���͗p�������ڃZ�b�g��ύX���čX�V
function saveRslDetail() {

	var myForm = document.resultList;

	if ( myForm.count.value == '' ) {
		return false;
	}

	if ( myForm.count.value < 1 ) {
		return false;
	}

	myForm.code.value    = '<%= strCode      %>';
	myForm.actMode.value = '<%= ACTMODE_SAVE %>';
	myForm.submit();

	return false;
}

// �\�����[�h�̐؂�ւ�
function chgDetail(dispMode) {

	var myForm = document.resultList;

	myForm.code.value     = '<%= strCode %>';
	myForm.actMode.value  = '<%= ACTMODE_CHANGE %>';
	myForm.dispMode.value = dispMode;

	myForm.submit();

}

// ���������擾
function loadPage() {

	var myForm = document.resultList;	// ����ʂ̃t�H�[���G�������g
	var i;								// �C���f�b�N�X

	// �Ώی������ʂ����݂��Ȃ��ꍇ�A�������Ȃ�
	if ( myForm.result == null ) {
		return;
	}

	// �擪�̌������ʂփJ�[�\���ړ�
	myForm.activeCount.value = 0;
	myForm.activeColumn.value = 0;

	if ( myForm.result.length != null ) {
		for ( i = 0; i < myForm.count.value; i++ ) {
			if ( myForm.result[i].type == 'text' ) {
				myForm.result[i].focus();
				myForm.activeCount.value = i;
				myForm.activeColumn.value = 0;
				break;
			}
		}
	} else {
		if ( myForm.result.type == 'text' ) {
			myForm.result.focus();
		}
	}

}

// �������ʃN���b�N
function resultClick( i ) {

	var myForm = document.resultList;

	// ���݂̃J�[�\���ʒu��ݒ�
	myForm.activeCount.value  = i;
	myForm.activeColumn.value = <%= IIf(strDispMode = DISPMODE_DETAIL, "0", "i % 3") %>;

	return false;
}

// ���ʃR�����g�P�N���b�N
function rlCmtCd1Click( i ) {

	var myForm = document.resultList;

	// ���݂̃J�[�\���ʒu��ݒ�
	myForm.activeCount.value = i;
	myForm.activeColumn.value = 1;

	return false;
}

// ���ʃR�����g�Q�N���b�N
function rlCmtCd2Click( i ) {

	var myForm = document.resultList;

	// ���݂̃J�[�\���ʒu��ݒ�
	myForm.activeCount.value = i;
	myForm.activeColumn.value = 2;

	return false;
}

// ���͍폜
function clearStcName( i ) {

	var stcNameElement;					// �����͂�ҏW����G�������g�̖���
	var myForm = document.resultList;	// ����ʂ̃t�H�[���G�������g

	if ( myForm.shortStc.length != null ) {
		myForm.shortStc[i].value = '';
	} else {
		myForm.shortStc.value = '';
	}

	// �G�������g���̕ҏW
	stcNameElement = 'stcName' + i;

	if ( document.getElementById(stcNameElement) ) {
		document.getElementById(stcNameElement).innerHTML = '';
	}

}

// �o�N�ω���ʂ�
function showInqRslHistrory() {

	var curGrpCd;		// �O���[�v�R�[�h
	var opened = false;	// ��ʂ��J����Ă��邩
	var url;			// �o�N�ω���ʂ�URL

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winHistory != null ) {
		if ( !winHistory.closed ) {
			opened = true;
		}
	}

	// �o�N�ω���ʂ�URL�ҏW
	url = '/webHains/contents/inquiry/inqRslHistory.asp?perId=<%= strPerId %>';

	// ���݂̃O���[�v�R�[�h���擾
	curGrpCd = document.resultList.code.value;
	if ( curGrpCd != 'all' ) {
		url = url + '&act=select';
		url = url + '&grpCd=' + curGrpCd;
	}

	// �J����Ă���ꍇ�͉�ʂ�REPLACE���A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winHistory.focus();
		winHistory.location.replace(url);
	} else {
		winHistory = window.open(url , '', 'width=800,height=650,status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no');
	}

}

// �O���f�҂̓��͉�ʂ�
function showPrevNextPage(actMode) {

	var myForm = document.resultList;	// ����ʂ̃t�H�[���G�������g
	var url;							// URL������

	// �����������ύX����Ă���ꍇ�͉������Ȃ�
	if ( !checkCondition() ) {
		alert('�ꗗ�̏������ύX����Ă���̂ŁA�O����f�ґJ�ڂ��s�����Ƃ��ł��܂���B');
		return;
	}

	// ���ʓ��͉�ʂ�URL�ҏW
	url = '<%= Request.ServerVariables("SCRIPT_NAME") %>';
	url = url + '?actMode='  + actMode;
	url = url + '&dispMode=' + myForm.dispMode.value;
	url = url + '&rsvNo='    + myForm.rsvNo.value;
	url = url + '&mode='     + myForm.mode.value;
	url = url + '&code='     + myForm.code.value;
	url = url + '&cslYear='  + myForm.cslYear.value;
	url = url + '&cslMonth=' + myForm.cslMonth.value;
	url = url + '&cslDay='   + myForm.cslDay.value;
	url = url + '&cntlNo='   + myForm.cntlNo.value;
	url = url + '&csCd='     + myForm.csCd.value;
	url = url + '&sortKey='  + myForm.sortKey.value;

	// �y�[�W�ړ�
	location.replace(url);
}

// �O���[�v�̕ύX
function changeGroup() {

	var myForm = document.resultList;	// ����ʂ̃t�H�[���G�������g
	var url;							// URL������

	// ���ʓ��͉�ʂ�URL�ҏW
	url = '<%= Request.ServerVariables("SCRIPT_NAME") %>';
	url = url + '?dispMode='   + myForm.dispMode.value;
	url = url + '&rsvNo='      + myForm.rsvNo.value;
	url = url + '&mode='       + myForm.mode.value;
	url = url + '&code='       + myForm.code.value;
	url = url + '&cslYear='    + myForm.cslYear.value;
	url = url + '&cslMonth='   + myForm.cslMonth.value;
	url = url + '&cslDay='     + myForm.cslDay.value;
	url = url + '&cntlNo='     + myForm.cntlNo.value;
	url = url + '&csCd='       + myForm.csCd.value;
	url = url + '&sortKey='    + myForm.sortKey.value;
	url = url + '&dayId='      + myForm.dayId.value;
	url = url + '&noPrevNext=' + myForm.noPrevNext.value;

	// �y�[�W�ړ�
	location.replace(url);
}

// �T�u��ʂ����
function closeWindow() {

	// �i���Ǘ���ʂ����
	if ( winProgress != null ) {
		if ( !winProgress.closed ) {
			winProgress.close();
		}
	}

	// �o�N�ω���ʂ����
	if ( winHistory != null ) {
		if ( !winHistory.closed ) {
			winHistory.close();
		}
	}

	// ���̓K�C�h�����
	closeGuideStc();

	// �萫���ʃK�C�h�����
	closeGuideTse();

	// �������ڐ�����ʂ����
	closeGuideDtl();

	// ���ʃR�����g�K�C�h�����
	closeGuideCmt();

	// �I�[�_���|�[�g�ꗗ�����
	closeGuideReport();

	winProgress = null;
	winHistory  = null;
}

// �f�t�H���g�l�̓W�J����
function setDefaultValue() {

	var myForm = document.resultList;	// ����ʂ̃t�H�[���G�������g
	var i								// �C���f�b�N�X

	// ���ʐ����P���̏ꍇ
	if ( myForm.result.length == null ) {
		setDefaultValueOfUnit();
		return;
	}

	// ���ʐ��������̏ꍇ
	for ( i = 0; i < myForm.result.length; i++ ) {
		setDefaultValueOfUnit( i );
	}

}

// �f�t�H���g�l�̓W�J����
function setDefaultValueOfUnit( index ) {

	var myForm = document.resultList;	// ����ʂ̃t�H�[���G�������g
	var objResult, objDefResult;		// �G�������g

	// �G�������g�̐ݒ�
	if ( index != null ) {
		objResult      = myForm.result[ index ];
		objDefResult   = myForm.defResult[ index ];
		objDefShortStc = myForm.defShortStc[ index ];
	} else {
		objResult      = myForm.result;
		objDefResult   = myForm.defResult;
		objDefShortStc = myForm.defShortStc;
	}

	// �f�t�H���g�l����A�����������ڈ˗��������Č��ʖ����͂̏ꍇ
	if ( objDefResult.value != '' && objResult.type == 'text' && objResult.value == '' ) {

		// �f�t�H���g�������ʂ���ѕ��͂̓W�J
		setStc( ( index != null ? index : 0 ), objDefResult.value, objDefShortStc.value );

	}

}

// ���͂̕ҏW
function setStc( index, stcCd, shortStc ) {

	var myForm = document.resultList;	// ����ʂ̃t�H�[���G�������g
	var objResult, objShortStc;			// ���ʁE���͂̃G�������g
	var stcNameElement;					// ���͂̃G�������g

	// �ҏW�G�������g�̐ݒ�
	if ( myForm.result.length != null ) {
		objResult   = myForm.result[ index ];
		objShortStc = myForm.shortStc[ index ];
	} else {
		objResult   = myForm.result;
		objShortStc = myForm.shortStc;
	}

	stcNameElement = 'stcName' + index;

	// �l�̕ҏW
	objResult.value   = stcCd;
	objShortStc.value = shortStc;

	if ( document.getElementById(stcNameElement) ) {
		document.getElementById(stcNameElement).innerHTML = shortStc;
	}

}
//-->
</SCRIPT>
<!--[if lte IE 9]>
<script type="text/vbscript" src="rslDetail.vbs"></script>
<![endif]-->
<!--[if !(lte IE 9)]><!-->
<script type="text/javascript" src="rslDetail.js"></script>
<!--<![endif]-->
<style type="text/css">
	body { margin: <%= lngMargin %>px 0 0 <%= lngMargin %>px; }
	td.rsltab  { background-color:#FFFFFF }
	.resultcolor-h  { color:<%= strH_Color %>;}
	.resultcolor-u  { color:<%= strU_Color %>;}
	.resultcolor-d  { color:<%= strD_Color %>;}
	.resultcolor-l  { color:<%= strL_Color %>;}
	.resultcolor-t1 { color:<%= strT1_Color %>;}
	.resultcolor-t2 { color:<%= strT2_Color %>;}
	.alignright 	{ text-align: right; }
</style>
</HEAD>
<%
'�}�[�W���l�̐ݒ�
lngMargin = IIf(strNoPrevNext = "1", 0, 10)
%>
<BODY ONLOAD="javascript:loadPage()" ONUNLOAD="javascript:closeWindow()">
<%
'�O����ʑJ�ڂȂ����[�h�őJ�ڂ����ꍇ�̓t���[�����̃y�[�W�ł͂Ȃ����߁A�i�r�o�[��\������
If strNoPrevNext = "1" Then
%>
	<!-- #include virtual = "/webHains/includes/navibar.inc" -->
	<BLOCKQUOTE>
<%
End If
%>
<FORM NAME="resultList" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<%
	'�����l�̕ێ�
%>
<INPUT TYPE="hidden" NAME="actMode">
<INPUT TYPE="hidden" NAME="dispMode"    VALUE="<%= strDispMode    %>">
<INPUT TYPE="hidden" NAME="rsvNo"       VALUE="<%= strRsvNo       %>">
<INPUT TYPE="hidden" NAME="mode"        VALUE="<%= strMode        %>">
<INPUT TYPE="hidden" NAME="cslYear"     VALUE="<%= strKeyCslYear  %>">
<INPUT TYPE="hidden" NAME="cslMonth"    VALUE="<%= strKeyCslMonth %>">
<INPUT TYPE="hidden" NAME="cslDay"      VALUE="<%= strKeyCslDay   %>">
<INPUT TYPE="hidden" NAME="cntlNo"      VALUE="<%= strKeyCntlNo   %>">
<INPUT TYPE="hidden" NAME="csCd"        VALUE="<%= strKeyCsCd     %>">
<INPUT TYPE="hidden" NAME="sortKey"     VALUE="<%= strKeySortKey  %>">
<INPUT TYPE="hidden" NAME="dayId"       VALUE="<%= strKeyDayId    %>">
<INPUT TYPE="hidden" NAME="noPrevNext"  VALUE="<%= strNoPrevNext  %>">

<!-- �J�[�\�����͐���p -->
<INPUT TYPE="hidden" NAME="orientation" VALUE="<%= strOrientation %>">
<INPUT TYPE="hidden" NAME="portrait"    VALUE="<%= strPortrait    %>">
<INPUT TYPE="hidden" NAME="landscape"   VALUE="<%= strLandscape   %>">
<INPUT TYPE="hidden" NAME="activeCount" >
<INPUT TYPE="hidden" NAME="activeColumn">

<!-- �E�C���h�E�������o�� -->
<TABLE WIDTH="<%= IIf(strNoPrevNext = "1", "90", "100") %>%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
	<TR>
		<TD VALIGN="TOP">
			<!-- �\�� -->
			<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%"><!-- or WIDTH="90%" -->
				<TR><TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">���ʓ���</FONT></B></TD></TR>
			</TABLE>
		</TD>
		<TD WIDTH="5"><IMG SRC="/webHains/images/spacer.gif" WIDTH="5"></TD>
		<TD WIDTH="50">
<%
		'�O���f�҂ւ̑J�ڃ{�^���ҏW
		If strNoPrevNext = "" Then

			'�O���f�҂̗\��ԍ��E����ID�擾
'## 2004.01.09 Mod By T.Takagi@FSIT ���@�֘A�ǉ�
'			objConsult.SelectCurRsvNoPrevNext dtmCslDate, strKeyCsCd, strKeySortKey, strKeyCntlNo, True, False, False, strRsvNo, strPrevRsvNo, strPrevDayId, strNextRsvNo, strNextDayId
			objConsult.SelectCurRsvNoPrevNext dtmCslDate, strKeyCsCd, strKeySortKey, strKeyCntlNo, True, False, False, strRsvNo, strPrevRsvNo, strPrevDayId, strNextRsvNo, strNextDayId, True
'## 2004.01.09 Mod End
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
	If strActMode <> "" Then

		'�ۑ��������́u�ۑ������v�̒ʒm
		If strActMode = ACTMODE_SAVEEND Then
			Call EditMessage("�ۑ����������܂����B", MESSAGETYPE_NORMAL)

		'�����Ȃ��΃G���[���b�Z�[�W��ҏW
		Else
			Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)
		End If

	End If
%>
	<BR>

	<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TD NOWRAP><%= IIf(strKeyDayId <> "", "�������F", "��f���F") %></TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= IIf(strKeyDayId <> "", dtmCslDate, strCslDate) %>
<%
			If ( strKeyDayId <> "" ) AND (dtmCslDate <> strCslDate) Then
%>
			<%= "&nbsp;(" & cDate(dtmCslDate) - cDate(strCslDate) + 1 & "����)" %>
<%
			End If
%>

			</B></FONT></TD>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
			<TD NOWRAP>��f�R�[�X�F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
<%
			If strKeyDayId <> "" Then
%>
				<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
				<TD NOWRAP>�����h�c�F</TD>
				<TD NOWRAP><FONT COLOR="#ff6600"><B><%= objCommon.FormatString(strKeyDayId, "0000") %></B></FONT></TD>
<%
			End If
%>
			<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1" ALT=""></TD>
			<TD NOWRAP>�\��ԍ��F</TD>
			<TD NOWRAP><FONT COLOR="#ff6600"><B><%= strRsvNo %></B></FONT></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="675">
		<TR>
			<TD HEIGHT="3"></TD>
		</TR>
		<TR>
			<TD NOWRAP WIDTH="46" ROWSPAN="2" VALIGN="top"><%= strPerId %></TD>
			<TD NOWRAP><B><%= Trim(strLastName & "�@" & strFirstName) %></B> (<FONT SIZE="-1"><%= Trim(strLastKname & "�@" & strFirstKName) %></FONT>)</TD>
<%
			If lngUpdItemCount > 0 Then
%>
				<TD ROWSPAN="2" VALIGN="bottom" ALIGN="right">
					<SPAN ID="passedInfo">
<%
					If strPassedDate = "" Then
						If strKeyDayId <> "" Then
%>
<!--
							<A HREF="javascript:UpdateProgress(true)">�m�ʉߏ����X�V�n</A>
-->
<%
						End If
					Else
%>
<!--
						<A HREF="javascript:UpdateProgress(false)">�m<%= strPassedDate %>�ɒʉ߁n</A>
-->
<%
					End If
%>
					</SPAN>
				</TD>
<%
			End If
%>
			<TD VALIGN="top" ALIGN="right">
<!-- ���}�����ɂ�����Ɖ��� 2002/09/09
				<A HREF="javascript:function voi(){};voi()" ONCLICK="return showGuideReport('<%= strRsvNo %>')">���傩��̃��|�[�g������</A>
-->
				<A HREF="javascript:setDefaultValue()">�f�t�H���g�l��W�J</A>
			</TD>
		</TR>
		<TR>
			<TD VALIGN="top" NOWRAP><%= objCommon.FormatString(strBirth, "ge.m.d") %>���@<%= strAge %>�΁@<%= IIf(strGender = "1", "�j��", "����") %></TD>
<%
			If strMode = "" Then
%>
				<TD HEIGHT="40" ALIGN="right"><A HREF="javascript:showInqRslHistrory()"><IMG SRC="/webHains/images/inqhistory.gif" WIDTH="77" HEIGHT="24" ALT="�o�N�ω�"></A></TD>
<%
			End If
%>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" WIDTH="675">
		<TR>
<%
			Select Case strMode
				Case Empty, ""
%>
					<TD NOWRAP>���͗p�������ڃZ�b�g�F</TD>
					<TD>
						<%= EditGrpIList_GrpDiv("code", strCode, "all", "���ׂ�", ADD_LAST) %>
					</TD>
					<TD>
						<A HREF="javascript:changeGroup()"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="���͗p�������ڃZ�b�g��ύX���ĕ\��"></A>
					</TD>
<%
				Case CStr(RSLMODE_JUDCLASS)

					'���蕪�ޖ��̓ǂݍ���
					objJudClass.SelectJudClass strCode, strCodeName
%>
					<TD NOWRAP>
						<INPUT TYPE="hidden" NAME="code" VALUE="<%= strCode %>">
						<%= "���蕪�ށi" & strCodeName & "�j�ɊY�����錟�����ڂ�\�����Ă��܂��B" %>
					</TD>
<%
				Case CStr(RSLMODE_PROGRESS)

					'�i�����ޖ��̓ǂݍ���
					objProgress.SelectProgress strCode, strCodeName
%>
					<TD NOWRAP>
						<INPUT TYPE="hidden" NAME="code" VALUE="<%= strCode %>">
						<%= "�i���Ǘ����ށi" & strCodeName & "�j�ɊY�����錟�����ڂ�\�����Ă��܂��B" %>
					</TD>
<%
			End Select
%>
			<TD WIDTH="100%"></TD>
<%
			'����{�^������
			Do

				'�v���͍��ڂ����݂��Ȃ��ꍇ�͔�\��
				If lngUpdItemCount = 0 Then
					Exit Do
				End If

				'�[����񂪑��݂��Ȃ���Δ�\��
				If Not blnWs Then
					Exit Do
				End If

				'����{�^���\���l���Ȃ���Ε\�����Ȃ�
				If strIsPrintButton <> "1" And strIsPrintButton <> "2" Then
					Exit Do
				End If

				'�����̏ꍇ�̂ݓ��[�����[����{�^����\��
				If strGender = "2" Then
%>
					<TD NOWRAP><A HREF="javascript:showPrintDialog(5,<%= strRsvNo %>)">���[�����[���</A></TD>
<%
				End If
%>
				<TD>&nbsp;<A HREF="javascript:showPrintDialog(<%= strIsPrintButton %>,<%= strRsvNo %>)"><IMG SRC="/webHains/images/print.gif" WIDTH="77" HEIGHT="24" ALT="���̎�f�҂�<%= IIf(strIsPrintButton = "1", "�����g�����\", "���o�����������ʕ\") %>�����"></A></TD>
<%
				Exit Do
			Loop
%>
			<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                <TD ALIGN="right">&nbsp;<A HREF="javascript:function voi(){};voi()" ONCLICK="return saveRslDetail()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A></TD>
            <%  end if  %>
		</TR>
		<TR>
			<TD HEIGHT="10"></TD>
		</TR>
	</TABLE>

	<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="675">
		<TR>
			<TD NOWRAP><A HREF="javascript:chgDetail('<%= IIf(strDispMode = DISPMODE_DETAIL, DISPMODE_SIMPLE, DISPMODE_DETAIL) %>')" METHOD="post">���͌��ʂ�\��<%= IIf(strDispMode = DISPMODE_DETAIL, "���Ȃ�", "����") %></A></TD>
<%
			If strIsPrintButton = "1" Then
%>
				<TD WIDTH="100%"></TD>
				<TD><INPUT TYPE="hidden" NAME="echo" VALUE="<%= strEcho %>"><INPUT TYPE="checkbox" <%= IIf(strEcho = "1", "CHECKED", "") %> ONCLICK="javascript:document.resultList.echo.value = (this.checked ? '1' : '0')"></TD>
				<TD ALIGN="right" NOWRAP>�L�����҂͎����Œ����g�����[���o��</TD>
<%
			End If
%>
		</TR>
	</TABLE>
<%
	If lngUpdItemCount = 0 Then

		Select Case strMode

			Case Empty, ""
				Call EditMessage("���̓��͌������ڃZ�b�g���Ɏ�f���ڂ͑��݂��܂���B", MESSAGETYPE_NORMAL)

			Case CStr(RSLMODE_JUDCLASS)
				Call EditMessage("���蕪�ށi" & strCodeName & "�j�Ɏ�f���ڂ͑��݂��܂���B", MESSAGETYPE_NORMAL)

			Case CStr(RSLMODE_PROGRESS)
				Call EditMessage("�i���Ǘ����ށi" & strCodeName & "�j�Ɏ�f���ڂ͑��݂��܂���B", MESSAGETYPE_NORMAL)

		End Select
%>
		<BR>
<%
	End If
%>
	<INPUT TYPE="hidden" NAME="count"        VALUE="<%= lngCount        %>">
	<INPUT TYPE="hidden" NAME="updItemCount" VALUE="<%= lngUpdItemCount %>">
<%
	'�\�����[�h���Ƃ̏�������
	Select Case strDispMode

		Case DISPMODE_DETAIL	'�ڍו\��
			Call EditRslList()

		Case DISPMODE_SIMPLE	'�����\��
			Call EditRslListSimply()

	End Select
%>
</FORM>
<%
If strNoPrevNext = "1" Then
%>
	</BLOCKQUOTE>
<%
End If
%>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
<%
Do

	'�ۑ��������ȊO�͉������Ȃ�
	If strActMode <> ACTMODE_SAVEEND Then
		Exit Do
	End If

	'�����g�����\���o�͑ΏۂƂȂ��Ă��Ȃ��ꍇ�͉������Ȃ�
	If strIsPrintButton <> "1" Then
		Exit Do
	End If

	'�L�����҂̒����g�����\�������ŏo�͂��Ȃ��ꍇ�͉������Ȃ�
	If strEcho <> "1" Then
		Exit Do
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objFree = Server.CreateObject("HainsFree.Free")

	'�����g���폊���𔻒f���邽�߂̍��ڏ���ėp�e�[�u������擾����
	lngEchoItemCount = objFree.SelectFree(1, FREECD_ECHO, , , , strEchoItemCd, strEchoSuffix, , strEchoShoken)
	If lngEchoItemCount <= 0 Then
		Exit Do
	End If

	'�����g���폊���𔻒f���邽�߂̕��̓R�[�h����ėp�e�[�u������擾����
	lngEchoStcCount = objFree.SelectFree(1, FREECD_ECHOSKN, , , , strEchoStcCd)
	If lngEchoStcCount <= 0 Then
		Exit Do
	End If

	For i = 0 To lngCount - 1

		Do

			'�˗��A�܂��͌��ʂ����݂��Ȃ���΃X�L�b�v
			If CStr(strConsultFlg(i)) <> CStr(CONSULT_ITEM_T) Or strResult(i) = "" Then
				Exit Do
			End If

			'�����g���폊�����f���ڂł��邩�𔻒�
			blnEchoFlg = False
			For j = 0 To lngEchoItemCount - 1
				If strItemCd(i) = strEchoItemCd(j) And strSuffix(i) = strEchoSuffix(j) And strEchoShoken(j) <> "" Then
					blnEchoFlg = True
					Exit For
				End If
			Next

			'�����g���폊�����f���ڂłȂ���΃X�L�b�v
			If blnEchoFlg = False Then
				Exit Do
			End If

			'���ʂ����݂��Ȃ��ꍇ�̓X�L�b�v
			If strResult(i) = "" Then
				Exit Do
			End If

			'�������ʂ������g���폊���R�[�h�ł��邩�𔻒�
			blnEchoShokenFlg = False
			For j = 0 To lngEchoStcCount - 1
				If strResult(i) = strEchoStcCd(j) Then
					blnEchoShokenFlg = True
					Exit For
				End If
			Next

			'���̎��_�ł��łɐ��폊���łȂ��Ɣ��f�ł���Ȃ烋�[�v�𔲂���
			If blnEchoShokenFlg = False Then
				Exit For
			End If

			Exit Do
		Loop

	Next

	'���폊���҂ł���Ή������Ȃ�
	If blnEchoShokenFlg = True Then
		Exit Do
	End If

	'�������
%>
	<SCRIPT TYPE="text/javascript">
	<!--
	showPrintDialog(<%= strIsPrintButton %>,<%= strRsvNo %>)
	//-->
	</SCRIPT>
<%
	Exit Do
Loop
%>
</HTML>
