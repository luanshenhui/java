<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		�ėp���̒��o�@���͐��� (Ver0.0.1)
'		AUTHER  : Toyonobu Manabe@takumatec.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/download.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_PRINT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Dim objItem				'���ڃK�C�h�A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objOrganization		'�c�̃e�[�u���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objConsult			'��f���A�N�Z�X�pCOM�I�u�W�F�N�g
Dim objCSVConsult			'��f���A�N�Z�X�pCOM�I�u�W�F�N�g
'�e�X�e�b�v�Ŕėp�I�Ɏg�p�������
Dim mstrStep			'���y�[�W�ւ̃X�e�b�v

'Step1����̈���
'���o����(��f�����)
Dim mstrChkDate			'��f��
Dim mstrChkCsCd			'�R�[�X
Dim mstrChkOrgCd		'��f�c��
'## 2003/5/30 ADD Start NSC(ITO
Dim mstrChkOrgBsdCd		'��f���Ə�
Dim mstrChkOrgRoomCd    '��f����
Dim mstrChkOrgPostCd	'��f����
'## 2003/5/30 ADD End 
Dim mstrChkAge			'��f���N��
Dim mstrChkJud			'��������
'���o����(�l���)
Dim mstrChkPerID		'�lID
Dim mstrChkName			'����
Dim mstrChkBirth		'���N����
Dim mstrChkGender		'����
'## 2003/5/30 ADD Start NSC(ITO
Dim mstrChkEmpNo		'�]�ƈ��ԍ�
Dim mstrChkPOrgCd		'��f�c��
Dim mstrChkPOrgBsdCd	'���Ə�
Dim mstrChkPOrgRoomCd   '����
Dim mstrChkPOrgPostCd	'����
Dim mstrChkOverTime  	'���ߋΖ�����
'## 2003/5/30 ADD End 
'���o����(��������)
Dim mstrOptResult		'�������ʒ��o����
Dim mlngRowCount		'�\�����ڐ�
Dim mstrArrSelItemCd	'�������ڃR�[�h�̔z��
Dim mstrArrSelSuffix	'�������ڃT�t�B�b�N�X�̔z��
Dim mstrChkOption		'���ʃR�����g�E����l�t���O

'Step2����̈���
'��f������
Dim mstrStrDate			'��f�N����(��)
Dim mlngStrYear			'��f�N(��)
Dim mlngStrMonth		'��f��(��)
Dim mlngStrDay			'��f��(��)
Dim mstrEndDate			'��f�N����(��)
Dim mlngEndYear			'��f�N(��)
Dim mlngEndMonth		'��f��(��)
Dim mlngEndDay			'��f��(��)
Dim mstrCsCd			'�R�[�X�R�[�h
Dim mstrSubCsCd			'�T�u�R�[�X�R�[�h
Dim mstrOrgCd1			'�c�̃R�[�h�P
Dim mstrOrgCd2			'�c�̃R�[�h�Q
Dim mstrOrgBsdCd		'���Ə��R�[�h
Dim mstrOrgRoomCd		'�����R�[�h
Dim mstrOrgPostCd1		'�����R�[�h
Dim mstrOrgPostCd2		'�����R�[�h

Dim mstrStrAge			'��f��(��)�N��
Dim mstrStrAgeY			'��f��(��)�N��(�N)
Dim mstrStrAgeM			'��f��(��)�N��(��)
Dim mstrEndAge			'��f��(��)�N��
Dim mstrEndAgeY			'��f��(��)�N��(�N)
Dim mstrEndAgeM			'��f��(��)�N��(��)
Dim mlngGender			'����
'�������ڏ���
Dim mlngRowCountItem	'�\���������ڐ�
Dim mstrArrItemCd		'�������ڃR�[�h�̔z��
Dim mstrArrSuffix		'�������ڃT�t�B�b�N�X�̔z��
Dim mstrArrRslValueFrom	'��������(FROM��)�̔z��
Dim mstrArrRslMarkFrom	'��������(FROM��)�͈͎w��̔z��
Dim mstrArrRslValueTo	'��������(TO��)�̔z��
Dim mstrArrRslMarkTo	'��������(TO��)�͈͎w��̔z��
'�����������
Dim mlngRowCountJud		'�\���������萔
Dim mstrArrJudClassCd	'���蕪�ރR�[�h�̔z��
Dim mstrArrJudValueFrom	'����R�[�h(FROM��)�̔z��
Dim mstrArrJudMarkFrom	'����R�[�h(FROM��)�͈͎w��̔z��
Dim mstrArrJudValueTo	'����R�[�h(TO��)�̔z��
Dim mstrArrJudMarkTo	'����R�[�h(TO��)�͈͎w��̔z��

'## 2002.6.5 Add 1Line by T.Takagi@FSIT ���Z�q�w��Ή�
Dim mlngJudOperation	'������������w�艉�Z�q(0:AND�A1:OR)
'## 2002.6.5 Add End
'## 2002.6.13 Add 1Line by T.Takagi@FSIT ���蒊�o�I���@�\
Dim mlngJudAll			'���蒊�o���@(0:���ׂāA1:�w�蔻�蕪�ނ̂�)
'## 2002.6.13 Add End

'���o���
Dim mstrEdit			'���o�{�^��������"on"

'�f�[�^���o�p�����t���O
Dim mstrArrRslCondition	'�������ʏ����z��(�������w�莞:""�A�w�莞�͌��ʃ^�C�v)
Dim mlngArrWeightFrom	'����p�d�ݔz��(FROM��)
Dim mlngArrWeightTo		'����p�d�ݔz��(TO��)
Dim mstrArrJudCondition	'������������z��(�������w�莞:""�A�w�莞��"CHECK")

'�S�X�e�b�v���ʂ̍�Ɨp�ϐ�
Dim strArrMessage		'�G���[���b�Z�[�W
Dim mstrTempFile		'��ƗpCSV�t�@�C����
Dim mstrFileName		'�o��CSV�t�@�C����
Dim mstrDownloadFile	'�_�E�����[�h�t�@�C����
Dim mlngCount			'�o�̓f�[�^����
Dim i, j, k				'�C���f�b�N�X

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'CSV�t�@�C���i�[�p�X�ݒ�
mstrDownloadFile = CSV_DATAPATH & CSV_CONSULT						'�_�E�����[�h�t�@�C�����Z�b�g
mstrFileName     = Server.MapPath(mstrDownloadFile)					'CSV�t�@�C�����Z�b�g
mstrTempFile     = Server.MapPath(CSV_DATAPATH & CSV_CONSULTTMP)	'��Ɨp�t�@�C�����Z�b�g

'@@@@@@@@@@@@@@
'Response.Write "  mstrFileName = " & mstrFileName
'Response.Write "  mstrTempFile = " & mstrTempFile
'@@@@@@@@@@@@@@


'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objItem         = Server.CreateObject("HainsItem.Item")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objCSVConsult      = Server.CreateObject("HainsCSVConsult.CSVConsult")
'�ǂ̃X�e�b�v����Ă΂ꂽ�������߂�
mstrStep = Request("step")

'Step1�Őݒ肳�ꂽ�����l�̎擾
mstrChkDate       = Request("chkDate"  )
mstrChkCsCd       = Request("chkCsCd"  )
mstrChkOrgCd      = Request("chkOrgCd" )
'## 2003/5/30 ADD Start NSC(ITO
mstrChkOrgBsdCd   = Request("chkOrgBsdCd" )
mstrChkOrgRoomCd  = Request("chkOrgRoomCd" )
mstrChkOrgPostCd  = Request("chkOrgPostCd" )
'## 2003/5/30 ADD End
mstrChkAge        = Request("chkAge"   )
mstrChkJud        = Request("chkJud"   )
mstrChkPerID      = Request("chkPerID" )
mstrChkName       = Request("chkName"  )
mstrChkBirth      = Request("chkBirth" )
mstrChkGender     = Request("chkGender")
'## 2003/5/30 ADD Start NSC(ITO
mstrChkEmpNo      = Request("chkEmpNo" )
mstrChkPOrgCd     = Request("chkPOrgCd" )
mstrChkPOrgBsdCd  = Request("chkPOrgBsdCd" )
mstrChkPOrgRoomCd = Request("chkPOrgRoomCd" )
mstrChkPOrgPostCd = Request("chkPOrgPostCd" )
mstrChkOverTime   = Request("chkOverTime" )
'## 2003/5/30 ADD End
mstrOptResult     = IIf(IsEmpty(Request("optResult")), CASE_NOTSELECT, Request("optResult"))
mlngRowCount      = IIf(IsEmpty(Request("rowCount" )), ROWCOUNT_ITEM,  CLng(Request("rowCount")))
mstrArrSelItemCd  = ConvIStringToArray(Request("selItemCd"))
mstrArrSelSuffix  = ConvIStringToArray(Request("selSuffix"))
mstrChkOption     = Request("chkOption")

'@@@@@@@@@@@@@@
'Response.Write "  mstrChkOrgBsdCd = " & mstrChkOrgBsdCd
'Response.Write "  mstrChkOrgRoomCd = " & mstrChkOrgRoomCd
'Response.Write "  mstrChkOrgPostCd = " & mstrChkOrgPostCd
'@@@@@@@@@@@@@@

'�\�������ύX�̏���
If IsArray(mstrArrSelItemCd) Then
	ReDim Preserve mstrArrSelItemCd(mlngRowCount - 1)
	ReDim Preserve mstrArrSelSuffix(mlngRowCount - 1)
Else
	ReDim mstrArrSelItemCd(mlngRowCount - 1)
	ReDim mstrArrSelSuffix(mlngRowCount - 1)
End If

'Step2�Őݒ肳�ꂽ�����l�̎擾
mlngStrYear  = CLng("0" & Request("strYear" ))
mlngStrMonth = CLng("0" & Request("strMonth"))
mlngStrDay   = CLng("0" & Request("strDay"  ))
mlngEndYear  = CLng("0" & Request("endYear" ))
mlngEndMonth = CLng("0" & Request("endMonth"))
mlngEndDay   = CLng("0" & Request("endDay"  ))
mstrCsCd     = Request("csCd"    )
mstrSubCsCd  = Request("SubcsCd"    )
mstrOrgCd1   = Request("orgCd1"  )
mstrOrgCd2   = Request("orgCd2"  )
mstrOrgBsdCd   = Request("orgBsdCd"  )
mstrOrgRoomCd  = Request("orgRoomCd"  )
mstrOrgPostCd1 = Request("orgPostCd1"  )
mstrOrgPostCd2 = Request("orgPostCd2"  )

mstrStrAgeY  = IIf(IsEmpty(Request("strAgeY")),   "0", Request("strAgeY"))
mstrStrAgeM  = Request("strAgeM" )
mstrEndAgeY  = IIf(IsEmpty(Request("endAgeY")), "150", Request("endAgeY"))
mstrEndAgeM  = Request("endAgeM" )
mlngGender   = IIf(IsEmpty(Request("gender")), GENDER_BOTH, Request("gender"))

'## 2002.6.5 Add 1Line by T.Takagi@FSIT ���Z�q�w��Ή�
mlngJudOperation = CLng("0" & Request("judOperation"))
'## 2002.6.5 Add End
'## 2002.6.13 Add 1Line by T.Takagi@FSIT ���蒊�o�I���@�\
mlngJudAll = CLng("0" & Request("judAll"))
'## 2002.6.13 Add End

mlngRowCountItem    = IIf(IsEmpty(Request("rowCountItem")), ROWCOUNT_ITEM, CLng(Request("rowCountItem")))
mstrArrItemCd       = ConvIStringToArray(Request("itemCd"))
mstrArrSuffix       = ConvIStringToArray(Request("suffix"))
'�\�������ύX�̏���(��������)
If IsArray(mstrArrItemCd) Then
	ReDim Preserve mstrArrItemCd(mlngRowCountItem - 1)
	ReDim Preserve mstrArrSuffix(mlngRowCountItem - 1)
Else
	ReDim mstrArrItemCd(mlngRowCountItem - 1)
	ReDim mstrArrSuffix(mlngRowCountItem - 1)
End If

mstrArrRslValueFrom = ConvIStringToArray(Request("rslValueFrom"))
mstrArrRslMarkFrom  = ConvIStringToArray(Request("rslSignFrom" ))
mstrArrRslValueTo   = ConvIStringToArray(Request("rslValueTo"  ))
mstrArrRslMarkTo    = ConvIStringToArray(Request("rslSignTo"   ))
'�\�������ύX�̏���(��������)
If IsArray(mstrArrRslValueFrom) Then
	ReDim Preserve mstrArrRslValueFrom(mlngRowCountItem - 1)
	ReDim Preserve mstrArrRslMarkFrom(mlngRowCountItem - 1)
	ReDim Preserve mstrArrRslValueTo(mlngRowCountItem - 1)
	ReDim Preserve mstrArrRslMarkTo(mlngRowCountItem - 1)
Else
	ReDim mstrArrRslValueFrom(mlngRowCountItem - 1)
	ReDim mstrArrRslMarkFrom(mlngRowCountItem - 1)
	ReDim mstrArrRslValueTo(mlngRowCountItem - 1)
	ReDim mstrArrRslMarkTo(mlngRowCountItem - 1)
End If

mlngRowCountJud     = IIf(IsEmpty(Request("rowCountJud")), ROWCOUNT_JUDCLASS, CLng(Request("rowCountJud")))
mstrArrJudClassCd   = ConvIStringToArray(Request("judClass"    ))
mstrArrJudValueFrom = ConvIStringToArray(Request("judValueFrom"))
mstrArrJudMarkFrom  = ConvIStringToArray(Request("judSignFrom" ))
mstrArrJudValueTo   = ConvIStringToArray(Request("judValueTo"  ))
mstrArrJudMarkTo    = ConvIStringToArray(Request("judSignTo"   ))
'�\�������ύX�̏���(��������)
If IsArray(mstrArrJudClassCd) Then
	ReDim Preserve mstrArrJudClassCd(mlngRowCountJud - 1)
	ReDim Preserve mstrArrJudValueFrom(mlngRowCountJud - 1)
	ReDim Preserve mstrArrJudMarkFrom(mlngRowCountJud - 1)
	ReDim Preserve mstrArrJudValueTo(mlngRowCountJud - 1)
	ReDim Preserve mstrArrJudMarkTo(mlngRowCountJud - 1)
Else
	ReDim mstrArrJudClassCd(mlngRowCountJud - 1)
	ReDim mstrArrJudValueFrom(mlngRowCountJud - 1)
	ReDim mstrArrJudMarkFrom(mlngRowCountJud - 1)
	ReDim mstrArrJudValueTo(mlngRowCountJud - 1)
	ReDim mstrArrJudMarkTo(mlngRowCountJud - 1)
End If

mstrEdit = Request("edit")

'�`�F�b�N�����̐���
Do

	'�e�X�e�b�v���Ƃ̃`�F�b�N�E�X�V��������
	Select Case mstrStep
		'���o���ڎw��
		Case "1"

			'�u���ցv�{�^����������Ă��Ȃ��ꍇ�͏����𔲂���
			If IsEmpty(Request("step2")) Then
				Exit Do
			End If

			'���̓`�F�b�N
'			strArrMessage = objConsult.CheckValueDatSelect(mstrChkDate,   mstrChkCsCd, _
'														   mstrChkOrgCd,  mstrChkAge, _
'														   mstrChkJud,    mstrChkPerID, _
'														   mstrChkName,   mstrChkBirth, _
'														   mstrChkGender, mstrOptResult, _
'														   mstrArrSelItemCd _
'														  )
			strArrMessage = objConsult.CheckValueDatSelect(mstrChkDate,   mstrChkCsCd, _
														   mstrChkOrgCd,  mstrChkAge, _
														   mstrChkJud,    mstrChkPerID, _
														   mstrChkName,   mstrChkBirth, _
														   mstrChkGender, mstrOptResult, _
														   mstrArrSelItemCd, _
														   mstrChkOrgBsdCd, mstrChkOrgRoomCd, _
														   mstrChkOrgPostCd, mstrChkEmpNo, _ 
														   mstrChkPOrgCd, mstrChkPOrgBsdCd, _
														   mstrChkPOrgRoomCd, mstrChkPOrgPostCd, _
														   mstrChkOverTime  _
														  )

			'�`�F�b�N�G���[���͏����𔲂���
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End if

			'����ʂ֑J��
			mstrStep = "2"
			Exit Do

		'���o�����w��
		Case "2"

			'�u���o�v�{�^����������Ă��Ȃ��ꍇ�͏����𔲂���
			If mstrEdit <> "on" Then
				Exit Do
			End If

'## 2003.5.30 Add Start  NSC(ITOH
			'�����P���w�肠��ŏ����Q�����w��̏ꍇ�A�����P���Q�ɐݒ�
			If mstrOrgPostCd1 <> "" And _
			   mstrOrgPostCd2 = "" Then
				mstrOrgPostCd2 = mstrOrgPostCd1
			End If
'## 2003.5.30 Add End

			'���̓`�F�b�N
			strArrMessage = objConsult.CheckValueDatConsult(mlngStrYear, mlngStrMonth, mlngStrDay, _
															mlngEndYear, mlngEndMonth, mlngEndDay, _
															mstrStrAgeY, mstrStrAgeM,  mstrEndAgeY, mstrEndAgeM, _
															mstrArrItemCd,       mstrArrSuffix, _
															mstrArrRslValueFrom, mstrArrRslMarkFrom, _
															mstrArrRslValueTo,   mstrArrRslMarkTo, _
															mstrArrJudClassCd, _
															mstrArrJudValueFrom, mstrArrJudMarkFrom, _
															mstrArrJudValueTo,   mstrArrJudMarkTo, _
															mstrStrDate,         mstrEndDate, _
															mstrStrAge,          mstrEndAge, _
															mstrArrRslCondition, _
															mlngArrWeightFrom,   mlngArrWeightTo, _
															mstrArrJudCondition _
														   )

			'�`�F�b�N�G���[���͏����𔲂���
			If Not IsEmpty(strArrMessage) Then
				Exit Do
			End if

			'CSV�t�@�C����ҏW
'## 2002.6.5 Modify 26Lines by T.Takagi@FSIT ���Z�q�w��Ή�
'			mlngCount = objConsult.EditCSVDatConsult(mstrFileName,  mstrTempFile, _
'									mstrChkDate,   mstrChkCsCd,   mstrChkOrgCd,     mstrChkAge,       mstrChkJud, _
'									mstrChkPerID,  mstrChkName,   mstrChkBirth,     mstrChkGender, _
'									mstrOptResult, mstrChkOption, mstrArrSelItemCd, mstrArrSelSuffix, _
'									mstrStrDate, mstrEndDate, mstrCsCd,   mstrOrgCd1,    mstrOrgCd2, _
'									mstrStrAge,  mstrEndAge,  mlngGender, mstrArrItemCd, mstrArrSuffix, _
'									mstrArrRslValueFrom, mstrArrRslMarkFrom, _
'									mstrArrRslValueTo,   mstrArrRslMarkTo, _
'									mstrArrRslCondition, mstrArrJudClassCd, _
'									mlngArrWeightFrom,   mstrArrJudMarkFrom, _
'									mlngArrWeightTo,     mstrArrJudMarkTo, _
'									mstrArrJudCondition _
'						)
'## 2002.6.13 Modify 26Lines by T.Takagi@FSIT ���蒊�o�I���@�\
'			mlngCount = objConsult.EditCSVDatConsult(mstrFileName,  mstrTempFile, _
'									mstrChkDate,   mstrChkCsCd,   mstrChkOrgCd,     mstrChkAge,       mstrChkJud, _
'									mstrChkPerID,  mstrChkName,   mstrChkBirth,     mstrChkGender, _
'									mstrOptResult, mstrChkOption, mstrArrSelItemCd, mstrArrSelSuffix, _
'									mstrStrDate, mstrEndDate, mstrCsCd,   mstrOrgCd1,    mstrOrgCd2, _
'									mstrStrAge,  mstrEndAge,  mlngGender, mstrArrItemCd, mstrArrSuffix, _
'									mstrArrRslValueFrom, mstrArrRslMarkFrom, _
'									mstrArrRslValueTo,   mstrArrRslMarkTo, _
'									mstrArrRslCondition, mstrArrJudClassCd, _
'									mlngArrWeightFrom,   mstrArrJudMarkFrom, _
'									mlngArrWeightTo,     mstrArrJudMarkTo, _
'									mstrArrJudCondition, mlngJudOperation _
'						)
'## 2003.5.30 Modify Start NSC(ITO
'			mlngCount = objConsult.EditCSVDatConsult(mstrFileName,  mstrTempFile, _
'									mstrChkDate,   mstrChkCsCd,   mstrChkOrgCd,     mstrChkAge,       mstrChkJud, _
'									mstrChkPerID,  mstrChkName,   mstrChkBirth,     mstrChkGender, _
'									mstrOptResult, mstrChkOption, mstrArrSelItemCd, mstrArrSelSuffix, _
'									mstrStrDate, mstrEndDate, mstrCsCd,   mstrOrgCd1,    mstrOrgCd2, _
'									mstrStrAge,  mstrEndAge,  mlngGender, mstrArrItemCd, mstrArrSuffix, _
'									mstrArrRslValueFrom, mstrArrRslMarkFrom, _
'									mstrArrRslValueTo,   mstrArrRslMarkTo, _
'									mstrArrRslCondition, mstrArrJudClassCd, _
'									mlngArrWeightFrom,   mstrArrJudMarkFrom, _
'									mlngArrWeightTo,     mstrArrJudMarkTo, _
'									mstrArrJudCondition, mlngJudOperation, mlngJudAll _
'						)
''## 2002.6.13 Modify End
''## 2002.6.5 Modify End
			mlngCount = objConsult.EditCSVDatConsult(mstrFileName,  mstrTempFile, _
									mstrChkDate,   mstrChkCsCd,   mstrChkOrgCd,     mstrChkAge,       mstrChkJud, _
									mstrChkOrgBsdCd,  mstrChkOrgRoomCd, mstrChkOrgPostCd, _ 
									mstrChkPerID,  mstrChkName,   mstrChkBirth,    mstrChkGender, _
									mstrChkEmpNo,   mstrChkPOrgCd,   mstrChkPOrgBsdCd,  mstrChkPOrgRoomCd,  _
									mstrChkPOrgPostCd,   mstrChkOverTime, _
									mstrOptResult, mstrChkOption, mstrArrSelItemCd, mstrArrSelSuffix, _
									mstrStrDate, mstrEndDate, mstrCsCd,   mstrOrgCd1,    mstrOrgCd2, _
									mstrOrgBsdCd, mstrOrgRoomCd, mstrOrgPostCd1, mstrOrgPostCd2, mstrSubCsCd, _
									mstrStrAge,  mstrEndAge,  mlngGender, mstrArrItemCd, mstrArrSuffix, _
									mstrArrRslValueFrom, mstrArrRslMarkFrom, _
									mstrArrRslValueTo,   mstrArrRslMarkTo, _
									mstrArrRslCondition, mstrArrJudClassCd, _
									mlngArrWeightFrom,   mstrArrJudMarkFrom, _
									mlngArrWeightTo,     mstrArrJudMarkTo, _
									mstrArrJudCondition, mlngJudOperation, mlngJudAll _
						)
'## 2003.5.30 Modify End NSC(ITO

			'�f�[�^������΃_�E�����[�h
			If mlngCount > 0 Then
				Response.Redirect mstrDownloadFile
				Response.End
			End If
			Exit Do

	End Select

	Exit Do
Loop

'�e�X�e�b�v�l���Ƃ̕\��ASP����
Select Case mstrStep

	'���o���ڎw��
	Case "1"
%>
		<!-- #include virtual = "/webHains/contents/download/datSelectItemStep1.asp" -->
<%
	'���o�����w��
	Case "2"
%>
		<!-- #include virtual = "/webHains/contents/download/datSelectItemStep2.asp" -->
<%
End Select
%>
