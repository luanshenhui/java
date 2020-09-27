<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'	   �h�{�w��  (Ver0.0.1)
'	   AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const GRPCD_EIYOSHIDO = "X019"	'�h�{�v�Z���ʃO���[�v�R�[�h

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objInterView		'�ʐڏ��A�N�Z�X�p
Dim objConsult			'��f�N���X
Dim objJudgement		'����p

'�p�����[�^
Dim strAction			'�������
Dim	strWinMode			'�E�B���h�E���[�h
Dim strGrpNo			'�O���[�vNo
Dim lngRsvNo			'�\��ԍ��i���񕪁j
Dim strCsCd				'�R�[�X�R�[�h

'��f���p�ϐ�
Dim strCslDate			'��f��
Dim strDayId			'����ID

'��������
Dim vntItemCd			'�������ڃR�[�h
Dim vntSuffix			'�T�t�B�b�N�X
Dim vntResultType		'���ʃ^�C�v
Dim vntItemType			'���ڃ^�C�v
Dim vntItemName			'�������ږ���
Dim vntResult			'��������
Dim lngRslCnt			'�������ʐ�

'�h�{�v�Z����
Dim vntTargetTotalEnergy	'���G�l���M�[�i�ڕW�ʁj
Dim vntTargetSweet			'�َq�E�����i�ڕW�ʁj
Dim vntTargetAlcohol		'�A���R�[���i�ڕW�ʁj
Dim vntTargetProtein		'�`�����i�ڕW�ʁj
Dim vntTargetFat			'�����i�ڕW�ʁj
Dim vntTargetcarbohydrate	'�Y�������i�ڕW�ʁj
Dim vntTargetCalcium		'�J���V�E���i�ڕW�ʁj
Dim vntTargetIron			'�S�i�ڕW�ʁj
Dim vntTargetCholesterol	'�R���X�e���[���i�ڕW�ʁj
Dim vntTargetSalt			'�����i�ڕW�ʁj
Dim vntTotalEnergy			'���G�l���M�[�i�ێ�ʁj
Dim vntSweet				'�َq�E�����i�ێ�ʁj
Dim vntAlcohol				'�A���R�[���i�ێ�ʁj
Dim vntProtein				'�`�����i�ێ�ʁj
Dim vntFat					'�����i�ێ�ʁj
Dim vntCarbohydrate			'�Y�������i�ێ�ʁj
Dim vntCalcium				'�J���V�E���i�ێ�ʁj
Dim vntIron					'�S�i�ێ�ʁj
Dim vntCholesterol			'�R���X�e���[���i�ێ�ʁj
Dim vntSalt					'�����i�ێ�ʁj
Dim vntRateTotalEnergy		'���G�l���M�[�i�[�����j
Dim vntRateSweet			'�َq�E�����i�[�����j
Dim vntRateAlcohol			'�A���R�[���i�[�����j
Dim vntRateProtein			'�`�����i�[�����j
Dim vntRateFat				'�����i�[�����j
Dim vntRateCarbohydrate		'�Y�������i�[�����j
Dim vntRateCalcium			'�J���V�E���i�[�����j
Dim vntRateIron				'�S�i�[�����j
Dim vntRateCholesterol		'�R���X�e���[���i�[�����j
Dim vntRateSalt				'�����i�[�����j
Dim vntMorningCereals		'���ނ���ш�ށi���j
Dim vntMorningFruit			'�ʕ��i���j
Dim vntMorningMeat			'����E���E���E�哤���i�i���j
Dim vntMorningDairy			'�����i�i���j
Dim vntMorningOils			'�����E�������H�i�i���j
Dim vntMorningVegetable		'��؁i���j
Dim vntMorningFavorite		'�n�D�i�i���j
Dim vntMorningOthers		'���̑��i���j
Dim vntLunchCereals			'���ނ���ш�ށi���j
Dim vntLunchFruit			'�ʕ��i���j
Dim vntLunchMeat			'����E���E���E�哤���i�i���j
Dim vntLunchDairy			'�����i�i���j
Dim vntLunchOils			'�����E�������H�i�i���j
Dim vntLunchVegetable		'��؁i���j
Dim vntLunchFavorite		'�n�D�i�i���j
Dim vntLunchOthers			'���̑��i���j
Dim vntDinnerCereals		'���ނ���ш�ށi�[�j
Dim vntDinnerFruit			'�ʕ��i�[�j
Dim vntDinnerMeat			'����E���E���E�哤���i�i�[�j
Dim vntDinnerDairy			'�����i�i���j
Dim vntDinnerOils			'�����E�������H�i�i�[�j
Dim vntDinnerVegetable		'��؁i�[�j
Dim vntDinnerFavorite		'�n�D�i�i�[�j
Dim vntDinnerOthers			'���̑��i�[�j

Dim dblRate(5,2)			'�[����(�H�i�ێ��)
Dim dblNyuRate				'�[����(�����i)
Dim dblFavorite(2)			'�n�D�i
Dim dblRateP				'�[����(�^���p�N��)
Dim dblRateC				'�[����(�Y������)
Dim dblRateF				'�[����(����)

'�h�{�Čv�Z�p
Dim vntCalcFlg()		'�v�Z�Ώۃt���O
Dim vntArrDayId()		'�����h�c�i�����w��̏ꍇ�̌v�Z�����ւ̈����j
Dim strArrMessage		'�G���[���b�Z�[�W

Dim strUpdUser			'�X�V��
Dim strIPAddress		'IP�A�h���X

Dim i, j				'�C���f�b�N�X
Dim Ret					'���A�l

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objCommon		= Server.CreateObject("HainsCommon.Common")
Set objInterView	= Server.CreateObject("HainsInterView.InterView")

'�����l�̎擾
strAction			= Request("act")
strWinMode			= Request("winmode")
strGrpNo			= Request("grpno")
lngRsvNo			= Request("rsvno")
strCsCd				= Request("cscd")

Do	
	'��f��񌟍�
	Set objConsult = Server.CreateObject("HainsConsult.Consult")
	Ret = objConsult.SelectConsult(lngRsvNo, _
									, _
									strCslDate, _
									, , , , , , , , , , , , , , , , , , , , , _
									strDayId _
									)
	'��f��񂪑��݂��Ȃ��ꍇ�̓G���[�Ƃ���
	If Ret = False Then
		Err.Raise 1000, , "��f��񂪑��݂��܂���B�i�\��ԍ�= " & lngRsvNo & " )"
	End If

	'�h�{�Čv�Z
	If strAction = "calc" Then
		'�X�V�҂̐ݒ�
		strUpdUser = Session("USERID")
		'IP�A�h���X�̎擾
		strIPAddress = Request.ServerVariables("REMOTE_ADDR")

        '### 2008.04.01 �� ���茒�f�K�w������ǉ��ɂ���ďC�� ###
        'Redim Preserve vntCalcFlg(5)

        '### 2012.10.06 �� �H�K���̎�������C�� Start ###
        'Redim Preserve vntCalcFlg(6)
        Redim Preserve vntCalcFlg(7)
        '### 2012.10.06 �� �H�K���̎�������C�� End   ###

        vntCalcFlg(0) = 0
		vntCalcFlg(1) = 0
		vntCalcFlg(2) = 1	'�h�{�v�Z�̂݋N��
		vntCalcFlg(3) = 0
		vntCalcFlg(4) = 0
		vntCalcFlg(5) = 0
		vntCalcFlg(6) = 0
'## 2012.10.06 Add by ishihara@RD �H�K���̎�������
		vntCalcFlg(7) = 0
'## 2012.10.06 Add End

		Redim Preserve vntArrDayId(0)

		'���胁�C���Ăяo��
		Set objJudgement = Server.CreateObject("HainsJudgement.JudgementControl")
		Ret = objJudgement.JudgeAutomaticallyMain (strUpdUser, _
												strIPAddress, _
												strCslDate, _
												 vntCalcFlg, _
												1, _
												strDayId, _
												strDayId, _
												vntArrDayId, _
												"", _
												"", _
												0, _
												0)

		If Ret = True Then
			strAction = "calcend"
		Else
			objCommon.AppendArray strArrMessage, "�������肪�ُ�I�����܂����B�i�ڍׂ́H�j"
		End If
	End If

	'�h�{�v�Z���ʎ擾
	lngRslCnt = objInterView.SelectHistoryRslList( _
						lngRsvNo, _
						1, _
						GRPCD_EIYOSHIDO, _
						0, _
						"", _
						0, _
						0, _
						0, _
						, _
						, _
						, _
						, _
						vntItemCd, _
						vntSuffix, _
						vntResultType, _
						vntItemType, _
						vntItemName, _
						vntResult _
						)
	If lngRslCnt < 0 Then
		Err.Raise 1000, , "�h�{�v�Z���ʂ��擾�ł��܂���B�i�\��ԍ� = " & lngRsvNo & ")"
	End If

	'�h�{�v�Z���ʂ̃Z�b�g
	For i=0 To lngRslCnt-1

		Select Case (vntItemCd(i) & "-" & vntSuffix(i))
		Case "60011-00"	'���G�l���M�[�i�ڕW�ʁj
			vntTargetTotalEnergy = vntResult(i)
		Case "60012-00"	'�َq�E�����i�ڕW�ʁj
			vntTargetSweet = vntResult(i)
		Case "60013-00"	'�A���R�[���i�ڕW�ʁj
			vntTargetAlcohol = vntResult(i)
		Case "60014-00"	'�`�����i�ڕW�ʁj
			vntTargetProtein = vntResult(i)
		Case "60015-00"	'�����i�ڕW�ʁj
			vntTargetFat = vntResult(i)
		Case "60016-00"	'�Y�������i�ڕW�ʁj
			vntTargetcarbohydrate = vntResult(i)
		Case "60017-00"	'�J���V�E���i�ڕW�ʁj
			vntTargetCalcium = vntResult(i)
		Case "60018-00"	'�S�i�ڕW�ʁj
			vntTargetIron = vntResult(i)
		Case "60019-00"	'�R���X�e���[���i�ڕW�ʁj
			vntTargetCholesterol = vntResult(i)
		Case "60020-00"	'�����i�ڕW�ʁj
			vntTargetSalt = vntResult(i)

		Case "60510-01"	'���G�l���M�[�i�ێ�ʁj
			vntTotalEnergy = vntResult(i)
		Case "XXXXX-XX"	'�َq�E�����i�ێ�ʁj
			'�n�D�i�i���j�Ɠ���
		Case "XXXXX-XX"	'�A���R�[���i�ێ�ʁj
			'�n�D�i�i�[�j�Ɠ���
		Case "60511-01"	'�`�����i�ێ�ʁj
			vntProtein = vntResult(i)
		Case "60512-01"	'�����i�ێ�ʁj
			vntFat = vntResult(i)
		Case "60513-01"	'�Y�������i�ێ�ʁj
			vntCarbohydrate = vntResult(i)
		Case "60514-01"	'�J���V�E���i�ێ�ʁj
			vntCalcium = vntResult(i)
		Case "60515-01"	'�S�i�ێ�ʁj
			vntIron = vntResult(i)
		Case "60516-01"	'�R���X�e���[���i�ێ�ʁj
			vntCholesterol = vntResult(i)
		Case "60517-01"	'�����i�ێ�ʁj
			vntSalt = vntResult(i)

		Case "60561-00"	'���G�l���M�[�i�[�����j
			vntRateTotalEnergy = vntResult(i)
		Case "60562-00"	'�َq�E�����i�[�����j
			vntRateSweet = vntResult(i)
		Case "60563-00"	'�A���R�[���i�[�����j
			vntRateAlcohol = vntResult(i)
		Case "60564-00"	'�`�����i�[�����j
			vntRateProtein = vntResult(i)
		Case "60565-00"	'�����i�[�����j
			vntRateFat = vntResult(i)
		Case "60566-00"	'�Y�������i�[�����j
			vntRateCarbohydrate = vntResult(i)
		Case "60567-00"	'�J���V�E���i�[�����j
			vntRateCalcium = vntResult(i)
		Case "60568-00"	'�S�i�[�����j
			vntRateIron = vntResult(i)
		Case "60569-00"	'�R���X�e���[���i�[�����j
			vntRateCholesterol = vntResult(i)
		Case "60570-00"	'�����i�[�����j
			vntRateSalt = vntResult(i)

		Case "60501-01"	'���ނ���ш�ށi���j
			vntMorningCereals = vntResult(i)
		Case "60502-01"	'�ʕ��i���j
			vntMorningFruit = vntResult(i)
		Case "60503-01"	'����E���E���E�哤���i�i���j
			vntMorningMeat = vntResult(i)
		Case "60504-01"	'�����i�i���j
			vntMorningDairy = vntResult(i)
		Case "60505-01"	'�����E�������H�i�i���j
			vntMorningOils = vntResult(i)
		Case "60506-01"	'��؁i���j
			vntMorningVegetable = vntResult(i)
		Case "60507-01"	'�n�D�i�i���j
			vntMorningFavorite = vntResult(i)

		Case "60501-02"	'���ނ���ш�ށi���j
			vntLunchCereals = vntResult(i)
		Case "60502-02"	'�ʕ��i���j
			vntLunchFruit = vntResult(i)
		Case "60503-02"	'����E���E���E�哤���i�i���j
			vntLunchMeat = vntResult(i)
		Case "60504-02"	'�����i�i���j
			vntLunchDairy = vntResult(i)
		Case "60505-02"	'�����E�������H�i�i���j
			vntLunchOils = vntResult(i)
		Case "60506-02"	'��؁i���j
			vntLunchVegetable = vntResult(i)
		Case "60507-02"	'�n�D�i�i���j
			vntLunchFavorite = vntResult(i)
			vntSweet = vntResult(i)

		Case "60501-03"	'���ނ���ш�ށi�[�j
			vntDinnerCereals = vntResult(i)
		Case "60502-03"	'�ʕ��i�[�j
			vntDinnerFruit = vntResult(i)
		Case "60503-03"	'����E���E���E�哤���i�i�[�j
			vntDinnerMeat = vntResult(i)
		Case "60504-03"	'�����i�i�[�j
			vntDinnerDairy = vntResult(i)
		Case "60505-03"	'�����E�������H�i�i�[�j
			vntDinnerOils = vntResult(i)
		Case "60506-03"	'��؁i�[�j
			vntDinnerVegetable = vntResult(i)
		Case "60507-03"	'�n�D�i�i�[�j
			vntDinnerFavorite = vntResult(i)
			vntAlcohol = vntResult(i)
		End Select
	Next

	'�[�����̕ҏW
	For i = 0 To UBound(dblRate,1)
		For j = 0 To UBound(dblRate,2)
			dblRate(i, j) = "0.0"
		Next
	Next
	If vntMorningCereals <> "" Then
		dblRate(0, 0) = IIf(IsNumeric(vntMorningCereals),   objCommon.FormatString(CDbl(vntMorningCereals), "0.0"),   "0.0")
	End If
	If vntLunchCereals <> "" Then
		dblRate(0, 1) = IIf(IsNumeric(vntLunchCereals),     objCommon.FormatString(CDbl(vntLunchCereals), "0.0"),     "0.0")
	End If
	If vntDinnerCereals <> "" Then
		dblRate(0, 2) = IIf(IsNumeric(vntDinnerCereals),    objCommon.FormatString(CDbl(vntDinnerCereals), "0.0"),    "0.0")
	End If
	If vntMorningFruit <> "" Then
		dblRate(1, 0) = IIf(IsNumeric(vntMorningFruit),     objCommon.FormatString(CDbl(vntMorningFruit), "0.0"),     "0.0")
	End If
	If vntLunchFruit <> "" Then
		dblRate(1, 1) = IIf(IsNumeric(vntLunchFruit),       objCommon.FormatString(CDbl(vntLunchFruit), "0.0"),       "0.0")
	End If
	If vntDinnerFruit <> "" Then
		dblRate(1, 2) = IIf(IsNumeric(vntDinnerFruit),      objCommon.FormatString(CDbl(vntDinnerFruit), "0.0"),      "0.0")
	End If
	If vntMorningMeat <> "" Then
		dblRate(2, 0) = IIf(IsNumeric(vntMorningMeat),      objCommon.FormatString(CDbl(vntMorningMeat), "0.0"),      "0.0")
	End If
	If vntLunchMeat <> "" Then
		dblRate(2, 1) = IIf(IsNumeric(vntLunchMeat),        objCommon.FormatString(CDbl(vntLunchMeat), "0.0"),        "0.0")
	End If
	If vntDinnerMeat <> "" Then
		dblRate(2, 2) = IIf(IsNumeric(vntDinnerMeat),       objCommon.FormatString(CDbl(vntDinnerMeat), "0.0"),       "0.0")
	End If
	If vntMorningDairy <> "" Then
		dblRate(3, 0) = IIf(IsNumeric(vntMorningDairy),     objCommon.FormatString(CDbl(vntMorningDairy), "0.0"),     "0.0")
	End If
	If vntLunchDairy <> "" Then
		dblRate(3, 1) = IIf(IsNumeric(vntLunchDairy),       objCommon.FormatString(CDbl(vntLunchDairy), "0.0"),       "0.0")
	End If
	If vntDinnerDairy <> "" Then
		dblRate(3, 2) = IIf(IsNumeric(vntDinnerDairy),      objCommon.FormatString(CDbl(vntDinnerDairy), "0.0"),      "0.0")
	End If
	If vntMorningOils <> "" Then
		dblRate(4, 0) = IIf(IsNumeric(vntMorningOils),      objCommon.FormatString(CDbl(vntMorningOils), "0.0"),      "0.0")
	End If
	If vntLunchOils <> "" Then
		dblRate(4, 1) = IIf(IsNumeric(vntLunchOils),        objCommon.FormatString(CDbl(vntLunchOils), "0.0"),        "0.0")
	End If
	If vntDinnerOils <> "" Then
		dblRate(4, 2) = IIf(IsNumeric(vntDinnerOils),       objCommon.FormatString(CDbl(vntDinnerOils), "0.0"),       "0.0")
	End If
	If vntMorningVegetable <> "" Then
		dblRate(5, 0) = IIf(IsNumeric(vntMorningVegetable), objCommon.FormatString(CDbl(vntMorningVegetable), "0.0"), "0.0")
	End If
	If vntLunchVegetable <> "" Then
		dblRate(5, 1) = IIf(IsNumeric(vntLunchVegetable),   objCommon.FormatString(CDbl(vntLunchVegetable), "0.0"),   "0.0")
	End If
	If vntDinnerVegetable <> "" Then
		dblRate(5, 2) = IIf(IsNumeric(vntDinnerVegetable),  objCommon.FormatString(CDbl(vntDinnerVegetable), "0.0"),  "0.0")
	End If
	For i=0 To 2
		dblNyuRate = objCommon.FormatString(CDbl(dblNyuRate) + CDbl(dblRate(3, i)), "0.0")
	Next

	dblRateP="0.0"
	dblRateC="0.0"
	dblRateF="0.0"
	If vntRateProtein <> "" Then
		dblRateP = IIf(IsNumeric(vntRateProtein),      objCommon.FormatString(CDbl(vntRateProtein), "0.0"),      "0.0")
	End If
	If vntRateCarbohydrate <> "" Then
		dblRateC = IIf(IsNumeric(vntRateCarbohydrate), objCommon.FormatString(CDbl(vntRateCarbohydrate), "0.0"), "0.0")
	End If
	If vntRateFat <> "" Then
		dblRateF = IIf(IsNumeric(vntRateFat),          objCommon.FormatString(CDbl(vntRateFat), "0.0"),          "0.0")
	End If

	'�n�D�i
	For i=0 To UBound(dblFavorite)
		dblFavorite(i) = "0"
	Next
	If vntMorningFavorite <> "" Then
		dblFavorite(0) = IIf(IsNumeric(vntMorningFavorite), objCommon.FormatString(vntMorningFavorite, "0"), 0)
	End If
	If vntLunchFavorite <> "" Then
		dblFavorite(1) = IIf(IsNumeric(vntLunchFavorite),   objCommon.FormatString(vntLunchFavorite,   "0"), 0)
	End If
	If vntDinnerFavorite <> "" Then
		dblFavorite(2) = IIf(IsNumeric(vntDinnerFavorite),  objCommon.FormatString(vntDinnerFavorite,  "0"), 0)
	End If


	'�I�u�W�F�N�g�̃C���X�^���X�폜
	Set objInterview = Nothing
	Set objConsult = Nothing
	Set objJudgement = Nothing
Exit Do
Loop
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="x-ua-compatible" content="IE=10">
<TITLE>�h�{�w��</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
//�H�K����f��ʌĂяo��
function callShokusyukan() {
	var url;							// URL������

	url = '/WebHains/contents/interview/Shokusyukan.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	location.href(url);

}

var winMenFoodComment;			// �E�B���h�E�n���h��

//�H�K���A��f�R�����g���͉�ʌĂяo��
function callMenFoodComment() {
	var url;			// URL������
	var opened = false;	// ��ʂ����łɊJ����Ă��邩

	var i;


	// �K�C�h��ʂ̘A����ɃK�C�h��ʂ���Ăяo����鎩��ʂ̊֐���ݒ肷��
//	CalledFunction = functionName;

	// ���łɃK�C�h���J����Ă��邩�`�F�b�N
	if ( winMenFoodComment != null ) {
		if ( !winMenFoodComment.closed ) {
			opened = true;
		}
	}

	url = '/WebHains/contents/interview/MenFoodComment.asp';
	url = url + '?winmode=' + '<%= strWinMode %>';
	url = url + '&grpno=' + '<%= strGrpNo %>';
	url = url + '&rsvno=' + '<%= lngRsvNo %>';
	url = url + '&cscd=' + '<%= strCsCd %>';

	// �J����Ă���ꍇ�̓t�H�[�J�X���ڂ��A�����Ȃ��ΐV�K��ʂ��J��
	if ( opened ) {
		winMenFoodComment.focus();
		winMenFoodComment.location.replace( url );
	} else {
		winMenFoodComment = window.open( url, '', 'width=750,height=350,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
	}

}
// �H�K���A��f�R�����g���͉�ʂ����
function closeMenFoodComment() {

	if ( winMenFoodComment != null ) {
		if ( !winMenFoodComment.closed ) {
			winMenFoodComment.close();
		}
	}

	winMenFoodComment = null;
}

//�h�{�Čv�Z��ʌĂяo��
function callMenEiyokeisan() {

	// �m�F���b�Z�[�W
	if( !confirm('�h�{�v�Z�����܂��B��낵���ł����H') ) return;

	document.entryForm.act.value = "calc";
	document.entryForm.submit();

}
//-->
</SCRIPT>
<LINK HREF="../css/default.css" TYPE="text/css" REL="stylesheet">
<style type="text/css">
	body { margin: 0 0 0 20px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeMenFoodComment()">
<%
	'�u�ʃE�B���h�E�ŕ\���v�̏ꍇ�A�w�b�_�[�����\��
	If strWinMode = "1" Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
		Call interviewHeader(lngRsvNo, 0)
	End If
%>
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post" STYLE="margin: 0px;">
	<!-- �����l -->
	<INPUT TYPE="hidden" NAME="act"       VALUE="<%= strAction %>">
	<INPUT TYPE="hidden" NAME="winmode"   VALUE="<%= strWinMode %>">
	<INPUT TYPE="hidden" NAME="grpno"     VALUE="<%= strGrpNo %>">
	<INPUT TYPE="hidden" NAME="rsvno"     VALUE="<%= lngRsvNo %>">
	<INPUT TYPE="hidden" NAME="cscd"      VALUE="<%= strCsCd %>">
	<INPUT TYPE="hidden" NAME="RslCnt"    VALUE="<%= lngRslCnt %>">

	<!-- �^�C�g���̕\�� -->
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
		<TR>
			<TD NOWRAP BGCOLOR="#ffffff" HEIGHT="15"><B><SPAN CLASS="result">��</SPAN><FONT COLOR="#000000">�h�{�w��</FONT></B></TD>
		</TR>
	</TABLE>
	<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2">
		<TR>
			<TD><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="5" WIDTH="1"></TD>
		</TR>
		<TR>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><A HREF="JavaScript:callShokusyukan()">�H�K����f</A></TD>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><A HREF="JavaScript:callMenFoodComment()">�H�K���A��f�R�����g����</A></TD>
<%
	'�^�p�J�n�O�i�ڍs�f�[�^�j�ɂ��Ă͍Čv�Z�s�Ƃ���
	If objCommon.FormatString(strCslDate, "yyyy/mm/dd") > "2004/01/04" Then
%>
			<TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><A HREF="JavaScript:callMenEiyokeisan()">�h�{�Čv�Z</A></TD>
<%
	End If
%>
		</TR>
	</TABLE>
<%
	'���b�Z�[�W�̕ҏW
	If strAction <> "" Then

		Select Case strAction

			'�ۑ��������́u����I���v�̒ʒm
			Case "calcend"
				Call EditMessage("�v�Z������I�����܂����B", MESSAGETYPE_NORMAL)

			'�����Ȃ��΃G���[���b�Z�[�W��ҏW
			Case Else
				Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

		End Select

	End If
%>
	<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<TR>
			<TD ROWSPAN="2" VALIGN="top">
				<OBJECT ID="HainsChartBar" CLASSID="CLSID:C785ABB0-B256-4EC1-8B6F-CD7F4D923F08" CODEBASE="/webHains/cab/Graph/HainsChartBar.CAB#version=1,0,0,1"></OBJECT>
<script type="text/javascript">
<!--
	var GraphActiveX = document.getElementById('HainsChartBar');
<%
For i=0 To UBound(dblRate, 1)
	For j=0 To UBound(dblRate, 2)
%>
		GraphActiveX.SetRate(<%= i %>, <%= j %>, <%= dblRate(i, j) %>);
<%
	Next
Next
%>
		GraphActiveX.SetNyuRate(<%= dblNyuRate %>);
		GraphActiveX.ShowGraph();
//-->
</script>
				<BR>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="2" WIDTH="100%" BGCOLOR="#ffffff" STYLE="font-size: 13px;">
					<TR>
						<TD></TD>
						<TD NOWRAP WIDTH="100">�F�n�D�H�i</TD>
						<TD NOWRAP>�َq�E�����F</TD>
						<TD NOWRAP>�@<B><%= dblFavorite(1) %>kcal</B></TD>
						<TD NOWRAP><IMG SRC="../../images/spacer.gif" ALT="" HEIGHT="1" WIDTH="50"></TD>
						<TD NOWRAP>�A���R�[���F</TD>
						<TD NOWRAP>�@<B><%= dblFavorite(2) %>kcal</B></TD>
						<TD WIDTH="100%"></TD>
					</TR>
				</TABLE>
			</TD>
			<TD>
				<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1" ALIGN="left">
					<TR BGCOLOR="#cccccc">
						<TD NOWRAP WIDTH="100%">&nbsp;</TD>
						<TD NOWRAP>�ڕW��</TD>
						<TD NOWRAP>�ێ��</TD>
						<TD NOWRAP>�[����(��)</TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>���G�l���M�[�ikcal�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetTotalEnergy="", "&nbsp;", objCommon.FormatString(vntTargetTotalEnergy, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTotalEnergy="", "&nbsp;", objCommon.FormatString(vntTotalEnergy, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateTotalEnergy="", "&nbsp;", objCommon.FormatString(vntRateTotalEnergy, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>�َq�E�����ikcal�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetSweet="", "&nbsp;", objCommon.FormatString(vntTargetSweet, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntSweet="", "&nbsp;", objCommon.FormatString(vntSweet, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateSweet="", "&nbsp;", objCommon.FormatString(vntRateSweet, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>�A���R�[���ikcal�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetAlcohol="", "&nbsp;", objCommon.FormatString(vntTargetAlcohol, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntAlcohol="", "&nbsp;", objCommon.FormatString(vntAlcohol, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateAlcohol="", "&nbsp;", objCommon.FormatString(vntRateAlcohol, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>�^���p�N���ig�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetProtein="", "&nbsp;", objCommon.FormatString(vntTargetProtein, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntProtein="", "&nbsp;", objCommon.FormatString(vntProtein, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateProtein="", "&nbsp;", objCommon.FormatString(vntRateProtein, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>�����ig�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetFat="", "&nbsp;", objCommon.FormatString(vntTargetFat, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntFat="", "&nbsp;", objCommon.FormatString(vntFat, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateFat="", "&nbsp;", objCommon.FormatString(vntRateFat, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>�Y�������ig�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetCarbohydrate="", "&nbsp;", objCommon.FormatString(vntTargetCarbohydrate, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntCarbohydrate="", "&nbsp;", objCommon.FormatString(vntCarbohydrate, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateCarbohydrate="", "&nbsp;", objCommon.FormatString(vntRateCarbohydrate, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>�J���V�E���img�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetCalcium="", "&nbsp;", objCommon.FormatString(vntTargetCalcium, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntCalcium="", "&nbsp;", objCommon.FormatString(vntCalcium, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateCalcium="", "&nbsp;", objCommon.FormatString(vntRateCalcium, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>�S�img�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetIron="", "&nbsp;", objCommon.FormatString(vntTargetIron, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntIron="", "&nbsp;", objCommon.FormatString(vntIron, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateIron="", "&nbsp;", objCommon.FormatString(vntRateIron, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>�R���X�e���[���img�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetCholesterol="", "&nbsp;", objCommon.FormatString(vntTargetCholesterol, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntCholesterol="", "&nbsp;", objCommon.FormatString(vntCholesterol, "0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateCholesterol="", "&nbsp;", objCommon.FormatString(vntRateCholesterol, "0.0")) %></TD>
					</TR>
					<TR>
						<TD BGCOLOR="#eeeeee" NOWRAP>�����ig�j</TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntTargetSalt="", "&nbsp;", objCommon.FormatString(vntTargetSalt, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#eeeeee"><%= IIf(vntSalt="", "&nbsp;", objCommon.FormatString(vntSalt, "0.0")) %></TD>
						<TD ALIGN="right" BGCOLOR="#ffffcc"><%= IIf(vntRateSalt="", "&nbsp;", objCommon.FormatString(vntRateSalt, "0.0")) %></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
		<TR>
			<TD>
				<OBJECT ID="HainsChartEnergy" CLASSID="CLSID:70E5B4BA-2BEE-4ADB-8041-DB39CA74DE59" CODEBASE="/webHains/cab/Graph/HainsChartEnergy.CAB#version=1,0,0,1"></OBJECT>
<script type="text/javascript">
<!--
	var GraphActiveX = document.getElementById('HainsChartEnergy');
	GraphActiveX.SetRateP(<%= dblRateP %>);	// �[����(�^���p�N��)
	GraphActiveX.SetRateC(<%= dblRateC %>);	// �[����(�Y������)
	GraphActiveX.SetRateF(<%= dblRateF %>);	// �[����(����)
	GraphActiveX.ShowGraph();
//-->
</script>
			</TD>
		</TR>
	</TABLE>
</FORM>
</BODY>
</HTML>
