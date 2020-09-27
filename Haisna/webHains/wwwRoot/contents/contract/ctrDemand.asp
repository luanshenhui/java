<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�_����(���S���E���S���z�̐ݒ�) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"  -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const MODE_SAVE           = "save"		'�������[�h�i�ۑ��j
Const MODE_CHANGEROW      = "change"	'�������[�h�i�\���s���ύX�j
Const DEFAULT_ROW         = 10			'���S���̃f�t�H���g�\���s��
Const INCREASE_COUNT      =  5			'�\�����S���̑����P��
Const LENGTH_PRICE        =  7			'���S���z�̍��ڒ�

'���b�Z�[�W�̕ҏW
Const MESSAGE_DELETEORG        = "�Z�b�g�������S���s���c�͍̂폜�ł��܂���B"
Const MESSAGE_DELETEPRICE      = "�폜���ڕ��S���s���c�̂̕��S���z�͕K���w�肷��K�v������܂��B"
Const MESSAGE_DELETELIMITPRICE = "���x�z���S�̐ݒ肪�s���Ă��镉�S���͍폜�ł��܂���B"

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objContract			'�_����A�N�Z�X�p
Dim objContractControl	'�_����A�N�Z�X�p
Dim objCourse			'�R�[�X���A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p

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
Dim strApDiv			'�K�p���敪�̔z��
Dim strSeq				'SEQ�̔z��
Dim strBdnOrgCd1		'�c�̃R�[�h1�̔z��
Dim strBdnOrgCd2		'�c�̃R�[�h2�̔z��
Dim strArrOrgName		'�c�̖��̂̔z��
Dim strPrice			'���S���z�̔z��
Dim strTaxFlg			'����ŕ��S�t���O�̔z��
Dim strOptBurden		'�I�v�V�������S�Ώۃt���O�̔z��
Dim strLimitPriceFlg	'���x�z���S�t���O�̔z��
Dim lngCount			'���S���
Dim lngRow				'�\���s��

'�_��Ǘ����
Dim strOrgName			'�c�̖�
Dim strCsName			'�R�[�X��
Dim dtmStrDate			'�_��J�n��
Dim dtmEndDate			'�_��I����

Dim strArrRetOrgName	'�c�̖���
Dim strMessage			'�G���[���b�Z�[�W
Dim strStrDate			'�ҏW�p�̌_��J�n��
Dim strEndDate			'�ҏW�p�̌_��I����
Dim strHTML				'HTML�ҏW�p
Dim Ret					'�֐��߂�l
Dim i					'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract        = Server.CreateObject("HainsContract.Contract")
Set objContractControl = Server.CreateObject("HainsContract.ContractControl")
Set objCourse          = Server.CreateObject("HainsCourse.Course")
Set objOrganization    = Server.CreateObject("HainsOrganization.Organization")

'�����l�̎擾
strMode          = Request("mode")
strCtrPtCd       = Request("ctrPtCd")
strOrgCd1        = Request("orgCd1")
strOrgCd2        = Request("orgCd2")
strCsCd          = Request("csCd")
strStrYear       = Request("strYear")
strStrMonth      = Request("strMonth")
strStrDay        = Request("strDay")
strEndYear       = Request("endYear")
strEndMonth      = Request("endMonth")
strEndDay        = Request("endDay")
strApDiv         = ConvIStringToArray(Request("apDiv"))
strSeq           = ConvIStringToArray(Request("seq"))
strBdnOrgCd1     = ConvIStringToArray(Request("bdnOrgCd1"))
strBdnOrgCd2     = ConvIStringToArray(Request("bdnOrgCd2"))
strArrOrgName    = ConvIStringToArray(Request("orgName"))
strPrice         = ConvIStringToArray(Request("price"))
strTaxFlg        = ConvIStringToArray(Request("taxFlg"))
strOptBurden     = ConvIStringToArray(Request("optBurden"))
strLimitPriceFlg = ConvIStringToArray(Request("limitPriceFlg"))
lngRow           = CLng("0" & Request("row"))

'���S��񐔂̐ݒ�
If Not IsEmpty(strApDiv) Then
	lngCount = UBound(strApDiv) + 1
End If

'�\���s���̐ݒ�
lngRow = IIf(lngRow = 0, DEFAULT_ROW, lngRow)

'�X�V���[�h���Ƃ̏�������
Select Case strMode

	'�ۑ�
	Case MODE_SAVE

		'���̓`�F�b�N
		strMessage = CheckValue()
		If IsEmpty(strMessage) Then

			'�_��p�^�[���R�[�h���w�莞(�����V�K�o�^��)
			If strCtrPtCd = "" Then

				'�_����̑}��
				Ret = objContractControl.InsertContract(strOrgCd1, strOrgCd2, strCsCd, strStrYear, strStrMonth, strStrDay, strEndYear, strEndMonth, strEndDay, strSeq, strApdiv, strBdnOrgCd1, strBdnOrgCd2, strPrice, strTaxFlg)

				'�����̌_����ƌ_����Ԃ����݂���ꍇ�̓��b�Z�[�W��ҏW����
				If Ret = 0 Then
					strMessage = Array("���łɓo�^�ς݂̌_����ƌ_����Ԃ��d�����邽�߁A�o�^�ł��܂���B")
				End If

			'�_��p�^�[���R�[�h�w�莞(�����X�V��)
			Else

				'�_����̍X�V
				Ret = objContractControl.UpdateContract(strOrgCd1, strOrgCd2, strCtrPtCd, strSeq, strApdiv, strBdnOrgCd1, strBdnOrgCd2, strPrice, strTaxFlg, strArrRetOrgName)

				'�߂�l�̔���
				Select Case Ret
					Case 0
					Case 1
						strMessage = Array(MESSAGE_DELETEORG)
					Case 2
						strMessage = Array(MESSAGE_DELETEPRICE)
					Case 3
						'���̌_����Q�Ƃ��Ă���c�̂����S���Ƃ��Ēǉ�����G���[�ƂȂ����ꍇ�A���̒c�̖������ׂĕҏW
						strMessage = Array()
						Redim Preserve strMessage(UBound(strArrRetOrgName))
						For i = 0 To UBound(strArrRetOrgName)
							strMessage(i) = "���S���u" & strArrRetOrgName(i) & "�v�͌��݂��̌_������Q�Ƃ��Ă��܂��B�o�^�ł��܂���B"
						Next
					Case 4
						strMessage = Array("��f���ŎQ�Ƃ���Ă��镉�S�����폜���悤�Ƃ��܂����B�폜�ł��܂���B")
					Case 5
						strMessage = Array(MESSAGE_DELETELIMITPRICE)
					Case Else
						strMessage = Array("���̑��̃G���[���������܂����B")
				End Select

			End If

			'�G���[���Ȃ���ΌĂь�(�_����)��ʂ������[�h���Ď��g�����
			If IsEmpty(strMessage) Then
				strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
				strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
				strHTML = strHTML & "</BODY>"
				strHTML = strHTML & "</HTML>"
				Response.Write strHTML
				Response.End
			End If

		End If

	'�\���s���ύX
	Case MODE_CHANGEROW

	Case Else

		'�_��p�^�[���R�[�h�w�莞(�����X�V��)
		If strCtrPtCd <> "" Then

			'�_��p�^�[�����S���z�Ǘ�����ǂݍ���
			lngCount = objContract.SelectCtrPtOrgPrice(strCtrPtCd, , , strSeq, strApDiv, strBdnOrgCd1, strBdnOrgCd2, strArrOrgName, , strPrice, , , , strTaxFlg, , , strOptBurden, , , strLimitPriceFlg)

		End If

		lngRow = IIf(lngCount > DEFAULT_ROW, Int((lngCount + INCREASE_COUNT - 1) / INCREASE_COUNT) * INCREASE_COUNT, DEFAULT_ROW)

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

'���S���z��̐���
Call ControlDemandArray()

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���S���z���̔z��𐧌䂷��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub ControlDemandArray()

	Dim lngSeq	'SEQ

	'���S��񂪑��݂��Ȃ��ꍇ�i�����\�����j�͐V�K�z��̍쐬
	If IsEmpty(strApDiv) Then
		Call CreateDemandArray()
	End If

	'�z��̗v�f�����\���s���ɖ����Ȃ��ꍇ
	If lngCount < lngRow Then

		'�����S���z���̍ŏI�������ƂɁA���ɔ��Ԃ���SEQ�l���擾����
		If lngCount > 0 Then
			lngSeq = CLng(strSeq(lngCount - 1)) + 1
		Else
			lngSeq = 1
		End If

		'�\���s���ɒB����܂Ŕz��̊g�����s��
		Do Until lngCount >= lngRow
			Call AppendDemandArray(APDIV_ORG, lngSeq, "", "", "")
			lngSeq = lngSeq + 1
		Loop

	'�z��̗v�f�����\���s���ȏ�̏ꍇ
	Else

		'�v�f�����\���s���ɓ������Ȃ�悤�A�z��̍Ē�`���s��
		Call ReDimDemandArray(lngRow)

	End If

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���S���z���̔z����쐬����
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : �V�K���S���Ƃ��Čl���S�E�_��c�̕��S�̕��S�����쐬
' �@�@�@�@   �������l��f�Eweb�\��̏ꍇ�A�_��c�͕̂K�v�Ȃ�
'
'-------------------------------------------------------------------------------
Sub CreateDemandArray()

	Dim objCommon		'���ʃN���X

	Dim strPerOrgCd1	'�i�l��f�j�c�̃R�[�h�P
	Dim strPerOrgCd2	'�i�l��f�j�c�̃R�[�h�Q
	Dim strWebOrgCd1	'�i�v�����\��j�c�̃R�[�h�P
	Dim strWebOrgCd2	'�i�v�����\��j�c�̃R�[�h�Q

	'���ʃN���X�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	'�l��f�AWeb�\��p�̒c�̃R�[�h�擾
	objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
	objCommon.GetOrgCd ORGCD_KEY_WEB,    strWebOrgCd1, strWebOrgCd2

	'�V�����z����쐬����
	strApDiv         = Array()
	strSeq           = Array()
	strBdnOrgCd1     = Array()
	strBdnOrgCd2     = Array()
	strArrOrgName    = Array()
	strPrice         = Array()
	strTaxFlg        = Array()
	strOptBurden     = Array()
	strLimitPriceFlg = Array()
	lngCount = 0

	'�l��f�EWeb�\��̏ꍇ
	If (strOrgCd1 = strPerOrgCd1 And strOrgCd2 = strPerOrgCd2) Or (strOrgCd1 = strWebOrgCd1 And strOrgCd2 = strWebOrgCd2) Then

		'���c�̗p�̗v�f��ǉ�
		Call AppendDemandArray(APDIV_MYORG, 2, "", "", "�l���S")

	'�_��c�̂̏ꍇ
	Else

		'�l�p�E�_��c�̗p�̗v�f��ǉ�
		Call AppendDemandArray(APDIV_PERSON, 1, strPerOrgCd1, strPerOrgCd2, "�l���S")
		Call AppendDemandArray(APDIV_MYORG, 2, "", "", "�_��c�̕��S")

	End If

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���S���z��̗v�f�ǉ�
'
' �����@�@ : (In)     lngAddApDiv    �K�p���敪
' �@�@�@�@   (In)     lngAddSeq      SEQ
' �@�@�@�@   (In)     strAddOrgCd1   �c�̃R�[�h�P
' �@�@�@�@   (In)     strAddOrgCd2   �c�̃R�[�h�Q
' �@�@�@�@   (In)     strAddOrgName  �c�̖���
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub AppendDemandArray(lngAddApDiv, lngAddSeq, strAddOrgCd1, strAddOrgCd2, strAddOrgName)

	'�z��̊g��
	Call ReDimDemandArray(lngCount + 1)

	'�����l�̕ҏW
	strApDiv(lngCount - 1)         = CStr(lngAddApDiv)
	strSeq(lngCount - 1)           = CStr(lngAddSeq)
	strBdnOrgCd1(lngCount - 1)     = strAddOrgCd1
	strBdnOrgCd2(lngCount - 1)     = strAddOrgCd2
	strArrOrgName(lngCount - 1)    = strAddOrgName
	strPrice(lngCount - 1)         = "0"
	strTaxFlg(lngCount - 1)        = "0"
	strOptBurden(lngCount - 1)     = "0"
	strLimitPriceFlg(lngCount - 1) = ""

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���S���z��̍Ē�`
'
' �����@�@ : (In)     lngElementCount  �z��̗v�f��
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub ReDimDemandArray(lngElementCount)

	'�z��̍Ē�`
	ReDim Preserve strApDiv(lngElementCount - 1)
	ReDim Preserve strSeq(lngElementCount - 1)
	ReDim Preserve strBdnOrgCd1(lngElementCount - 1)
	ReDim Preserve strBdnOrgCd2(lngElementCount - 1)
	ReDim Preserve strArrOrgName(lngElementCount - 1)
	ReDim Preserve strPrice(lngElementCount - 1)
	ReDim Preserve strTaxFlg(lngElementCount - 1)
	ReDim Preserve strOptBurden(lngElementCount - 1)
	ReDim Preserve strLimitPriceFlg(lngElementCount - 1)

	'�z��̗v�f�����擾
	lngCount = UBound(strApDiv) + 1

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���̓`�F�b�N
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckValue()

	Dim objCommon		'���ʃN���X

	Dim strPerOrgCd1	'�l��f�p�c�̃R�[�h�P
	Dim strPerOrgCd2	'�l��f�p�c�̃R�[�h�Q

	Dim strArrMessage	'�G���[���b�Z�[�W�̔z��
	Dim strMessage		'�G���[���b�Z�[�W

	Dim blnError1		'�G���[�t���O
	Dim blnError2		'�G���[�t���O
	Dim i, j			'�C���f�b�N�X

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")

	blnError1 = False
	blnError2 = False

	'�l��f�p�c�̃R�[�h�̎擾
	objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2

	'�l��f�Ǘ��p�̒c�̂��w�肳��Ă��Ȃ���������
	For i = 0 To lngCount - 1
		If CLng(strApDiv(i)) <> APDIV_PERSON And strBdnOrgCd1(i) = strPerOrgCd1 And strBdnOrgCd2(i) = strPerOrgCd2 Then
			objCommon.AppendArray strArrMessage, "�l��f�p�̒c�̃R�[�h���w�肷�邱�Ƃ͂ł��܂���B"
			Exit For
		End If
	Next

	'���Ђ��w�肳��Ă��Ȃ���������
	For i = 0 To lngCount - 1
		If strBdnOrgCd1(i) = strOrgCd1 And strBdnOrgCd2(i) = strOrgCd2 Then
			objCommon.AppendArray strArrMessage, "�_��c�̎��g�̒c�̃R�[�h���w�肷�邱�Ƃ͂ł��܂���B"
			Exit For
		End If
	Next

	'�c�̏d���`�F�b�N
	For i = 0 To lngCount - 1
		j = 0
		Do Until j >= i
			If strBdnOrgCd1(j) & strBdnOrgCd2(j) <> "" Then
				If strBdnOrgCd1(j) = strBdnOrgCd1(i) And strBdnOrgCd2(j) = strBdnOrgCd2(i) Then
					objCommon.AppendArray strArrMessage, "����c�̂𕡐��w�肷�邱�Ƃ͂ł��܂���B"
					Exit For
				End If
			End If
			j = j + 1
		Loop
	Next

	'�Z�b�g�������S���s�����S���͍폜�ł��Ȃ�
	For i = 0 To lngCount - 1
		If CLng(strApDiv(i)) = APDIV_ORG And strBdnOrgCd1(i) = "" And strBdnOrgCd2(i) = "" Then
			If strOptBurden(i) <> "0" Or strTaxFlg(i) <> "0" Then
				objCommon.AppendArray strArrMessage, MESSAGE_DELETEORG
				Exit For
			End If
		End If
	Next

	'���x�z�ݒ�ɂĎg�p����Ă��镉�S���͍폜�ł��Ȃ�
	For i = 0 To lngCount - 1
		If CLng(strApDiv(i)) = APDIV_ORG And strBdnOrgCd1(i) = "" And strBdnOrgCd2(i) = "" Then
			If strLimitPriceFlg(i) <> "" Then
				objCommon.AppendArray strArrMessage, MESSAGE_DELETELIMITPRICE
				Exit For
			End If
		End If
	Next

	'���S����SEQ�l�`�F�b�N
	For i = 0 To lngCount - 1
		If strBdnOrgCd1(i) <> "" Or strBdnOrgCd2(i) <> "" Then
			If CLng(strSeq(i)) > 99 Then
				objCommon.AppendArray strArrMessage, "���S���̃V�[�P���X�l���ő吔�𒴂��܂����B"
				Exit For
			End If
		End If
	Next

	'�`�F�b�N���ʂ�Ԃ�
	CheckValue = strArrMessage

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>���S���̐ݒ�</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var lngSelectedIndex;	// �K�C�h�\�����ɑI�����ꂽ���S���̃C���f�b�N�X

// �c�̖��̂���ѕ��S���z���v�̕ҏW
function setValue() {

	// ���ׂĂ̒c�̖��̂�ҏW����
	for ( var i = 0; i < document.entryForm.orgName.length; i++ ) {
		if ( document.getElementById('orgName' + i) ) {
			document.getElementById('orgName' + i).innerHTML = document.entryForm.orgName[ i ].value;
		}
	}

}

// �c�̃K�C�h�Ăяo��
function callOrgGuide( index ) {

	// �I�����ꂽ�K�C�h�̃C���f�b�N�X��ێ�
	lngSelectedIndex = index;

	orgGuide_showGuideOrg(document.entryForm.bdnOrgCd1[ index ], document.entryForm.bdnOrgCd2[ index ], 'orgName' + index, '', '', setOrgName);

}

// hidden�^�O�̒c�̖��ҏW
function setOrgName() {

	document.entryForm.orgName[ lngSelectedIndex ].value = orgGuide_OrgName.innerHTML;

}

// �c�̂̍폜
function deleteOrgInfo( index ) {

	orgGuide_clearOrgInfo( document.entryForm.bdnOrgCd1[index], document.entryForm.bdnOrgCd2[index], 'orgName' + index );

	document.entryForm.orgName[index].value = '';

}

// submit���̏���
function submitForm( mode ) {

	// �������[�h���w�肵��submit
	document.entryForm.mode.value = mode;
	document.entryForm.submit();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
	td.mnttab { background-color:#FFFFFF }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:setValue()" ONUNLOAD="JavaScript:orgGuide_closeGuideOrg()">
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
	<INPUT TYPE="hidden" NAME="mode"     VALUE="">
	<INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= strOrgCd1 %>">
	<INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= strOrgCd2 %>">
	<INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd %>">
	<INPUT TYPE="hidden" NAME="strYear"  VALUE="<%= strStrYear  %>">
	<INPUT TYPE="hidden" NAME="strMonth" VALUE="<%= strStrMonth %>">
	<INPUT TYPE="hidden" NAME="strDay"   VALUE="<%= strStrDay   %>">
	<INPUT TYPE="hidden" NAME="endYear"  VALUE="<%= strEndYear  %>">
	<INPUT TYPE="hidden" NAME="endMonth" VALUE="<%= strEndMonth %>">
	<INPUT TYPE="hidden" NAME="endDay"   VALUE="<%= strEndDay   %>">
	<INPUT TYPE="hidden" NAME="csCd"     VALUE="<%= strCsCd     %>">
	<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
		<TR>
			<TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="contract">��</SPAN><FONT COLOR="#000000">���S���̐ݒ�</FONT></B></TD>
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
			<TD HEIGHT="25" NOWRAP>�ΏۃR�[�X</TD>
			<TD>�F</TD>
			<TD><B><%= strCsName %></B></TD>
		</TR>
		<TR>
			<TD>�_�����</TD>
			<TD>�F</TD>
			<TD><B><%= strStrDate %>�`<%= strEndDate %></B></TD>
		</TR>
	</TABLE>

	<BR>

	<TABLE BORDER="0" CELLSPACING="2" CELLPADDING="0">
		<TR BGCOLOR="#eeeeee">
			<TD>���S��</TD>
			<TD ALIGN="center">�Z�b�g���S</TD>
			<TD ALIGN="center">���x�z�ݒ�</TD>
		</TR>
<%
		For i = 0 To UBound(strApDiv)
%>
			<TR>
				<TD HEIGHT="24">
					<INPUT TYPE="hidden" NAME="apDiv"         VALUE="<%= strApDiv(i)         %>">
					<INPUT TYPE="hidden" NAME="seq"           VALUE="<%= strSeq(i)           %>">
					<INPUT TYPE="hidden" NAME="bdnOrgCd1"     VALUE="<%= strBdnOrgCd1(i)     %>">
					<INPUT TYPE="hidden" NAME="bdnOrgCd2"     VALUE="<%= strBdnOrgCd2(i)     %>">
					<INPUT TYPE="hidden" NAME="orgName"       VALUE="<%= strArrOrgName(i)    %>">
					<INPUT TYPE="hidden" NAME="price"         VALUE="<%= strPrice(i)         %>">
					<INPUT TYPE="hidden" NAME="taxFlg"        VALUE="<%= strTaxFlg(i)        %>">
					<INPUT TYPE="hidden" NAME="optBurden"     VALUE="<%= strOptBurden(i)     %>">
					<INPUT TYPE="hidden" NAME="limitPriceFlg" VALUE="<%= strLimitPriceFlg(i) %>">
					<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
						<TR>
<%
							'�K�p���敪���Ƃ̒c�̖��̕ҏW��������
							Select Case CLng(strApDiv(i))

								'�l���S�̏ꍇ�͖��̂̂ݕҏW
								Case APDIV_PERSON
%>
									<TD><%= strArrOrgName(i) %></TD>
<%
								'���Е��S�̏ꍇ�͎��c�̖��̂̂ݕҏW
								Case APDIV_MYORG
%>
									<TD><%= strOrgName %></TD>
<%
								'����ȊO�̓K�C�h�{�^���E�c�̃R�[�h�E�c�̖���ҏW
								Case Else
%>
									<TD><A HREF="JavaScript:callOrgGuide(<%= CStr(i) %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="�c�̃K�C�h�\��"></A></TD>
<%
									'�Z�b�g�������S���s��Ȃ��A�����x�z�ݒ肪�s���Ă��Ȃ����S���̂ݍ폜�\�Ƃ���
									If strOptBurden(i) = "0" And strLimitPriceFlg(i) = "" Then
%>
										<TD><A HREF="JavaScript:deleteOrgInfo(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif" WIDTH="21" HEIGHT="21" ALT="�폜"></A></TD>
<%
									Else
%>
										<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="21" ALT=""></TD>
<%
									End If
%>
									<TD WIDTH="250"><SPAN ID="orgName<%= i %>" STYLE="position:relative"><%= strArrOrgName(i) %></SPAN></TD>
<%
							End Select
%>
						</TR>
					</TABLE>
				</TD>
				<TD ALIGN="center"><%= IIf(strOptBurden(i)     <> "0", "��", "") %></TD>
				<TD ALIGN="center"><%= IIf(strLimitPriceFlg(i) <> "",  "��", "") %></TD>
			</TR>
<%
		Next
%>
		<TR>
			<TD HEIGHT="5"></TD>
		</TR>
		<TR>
			<TD HEIGHT="1" BGCOLOR="#999999" COLSPAN="8"><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="1"></TD>
		</TR>
		<TR>
			<TD>
				<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
					<TR>
						<TD>���S���̓��͍s�����w��F</TD>
						<TD>
							<SELECT NAME="row">
<%
								'���S�����͍s���I�����X�g�̕ҏW
								i = DEFAULT_ROW
								Do

									'���݂̕��S�����ȏ�̍s����I���\�Ƃ���
									If i >= lngCount Then
%>
										<OPTION VALUE="<%= i %>" <%= IIf(i = lngRow, "SELECTED", "") %>><%= i %>�s
<%
									End If

									'�ҏW�s�����\���s���𒴂����ꍇ�͏������I������
									If i > lngRow Then
										Exit Do
									End If

									i = i + INCREASE_COUNT

									'���_��̍ő吔��100�Ȃ̂ł���𒴂���ΏI��
									If i > 100 Then
										Exit Do
									End If

								Loop
%>
							</SELECT>
						</TD>
						<TD><A HREF="javascript:submitForm('<%= MODE_CHANGEROW %>')"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="�\��"></A></TD>
					</TR>
				</TABLE>
			</TD>
		</TR>
	</TABLE>

	<BR><BR>
<%
	'�X�V���́u�L�����Z���v�u�ۑ��v�{�^�����A�V�K���́u�߂�v�u���ցv�{�^�������ꂼ��p�ӂ���
	If strCtrPtCd <> "" Then
%>
		<A HREF="javascript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="�L�����Z��"></A>
<%
	Else
%>
		<A HREF="javascript:history.back()"><IMG SRC="/webHains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="�߂�"></A>
<%
	End If
%>
	<% '2005.08.22 �����Ǘ� Add by ���@--- START %>
	<%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
	    <A HREF="javascript:submitForm('<%= MODE_SAVE %>')"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="�ۑ�"></A>
    <%  else    %>
         &nbsp;
    <%  end if  %>
    <% '2005.08.22 �����Ǘ� Add by ���@--- END %>

</FORM>
<!-- #include virtual = "/webHains/includes/bottom.inc" -->
</BODY>
</HTML>
