<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'		�\��g����(�G�������g���I����) (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' ���ʐ錾��
'-------------------------------------------------------------------------------
Const OPTCOUNT_PER_ROW = 3	'�P�s������̍ő�\���I�v�V������

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objCommon			'���ʃN���X
Dim objContract			'�_����A�N�Z�X�p
Dim objFree				'�ėp���A�N�Z�X�p
Dim objOrganization		'�c�̏��A�N�Z�X�p
Dim objPerson			'�l���A�N�Z�X�p
Dim objSchedule			'�X�P�W���[�����A�N�Z�X�p

'�����l
Dim strCslDate			'��f��
Dim lngCondIndex		'���������C���f�b�N�X
Dim strPerId			'�l�h�c
Dim strGender			'����
Dim strBirth			'���N����
Dim strAge				'��f���N��
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strCsCd				'�R�[�X�R�[�h
Dim strCslDivCd			'��f�敪�R�[�h
Dim strRsvGrpCd			'�\��Q�R�[�h
Dim strCtrPtCd			'�_��p�^�[���R�[�h
Dim strOptCd			'�I�v�V�����R�[�h
Dim strOptBranchNo		'�I�v�V�����}��

'�l���
Dim strLastName			'��
Dim strFirstName		'��
Dim strLastKName		'�J�i��
Dim strFirstKName		'�J�i��
Dim strPerBirth			'���N����
Dim strPerGender		'����
Dim strPerAge			'��f���N��
Dim strCompPerId		'�����҂h�c

'20080417 �\��g������ʂɃR�����g�{�^���ǉ��̂��� START
'��M����
Dim lngRsvNo            '�Ō��M��
Dim lngPerCmt           '�l�E�ߋ���M�R�����g�L��
Dim lngHisCsl           '��M��L��
'20080417 �\��g������ʂɃR�����g�{�^���ǉ��̂��� END

'�ҏW�p�̌l���
Dim strPerName			'����
Dim strPerKName			'�J�i����
Dim strPerBirthJpn		'���N����

'�c�̏��
Dim strOrgName			'�c�̖���
Dim strOrgKName			'�c�̃J�i����

'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###
Dim strHighLight        ' �c�̖��̃n�C���C�g�\���敪
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###


'�_����
Dim strArrCsCd			'�R�[�X�R�[�h
Dim strArrCsName		'�R�[�X��
Dim strArrCtrPtCd		'�_��p�^�[���R�[�h
Dim strArrAgeCalc		'�N��N�Z��
Dim lngCtrCount			'�_����

'��f�敪���
Dim strArrCslDivCd		'��f�敪�R�[�h
Dim strArrCslDivName	'��f�敪��
Dim lngCslDivCount		'��f�敪��

'�\��Q���
Dim strArrRsvGrpCd		'�\��Q�R�[�h
Dim strArrRsvGrpName	'�\��Q����
Dim lngRsvGrpCount		'�\��Q��

'�I�v�V�����������̏����L�[
Dim lngKeyGender		'����
Dim strKeyAge			'��f���N��

'�I�v�V�����������
Dim strArrOptCd			'�I�v�V�����R�[�h
Dim strArrOptBranchNo	'�I�v�V�����}��
Dim strOptSName			'�I�v�V��������
Dim strSetColor			'�Z�b�g�J���[
Dim strConsult			'��f�v��
Dim strBranchCount		'�I�v�V�����}�Ԑ�
Dim strAddCondition		'�ǉ�����
Dim strHideRsvFra		'�\��g��ʔ�\��
Dim lngCount			'�I�v�V����������

'�\���I�v�V�����p��HTML
Dim strShowHTML()		'HTML������
Dim lngShowCount		'�z��̗v�f��

Dim strPrevOptCd		'���O���R�[�h�̃I�v�V�����R�[�h
Dim strElementType		'�I�v�V�����I��p�̃G�������g���
Dim lngOptGrpSeq		'�I�v�V�����O���[�v��SEQ�l
Dim strElementName		'�I�v�V�����I��p�̃G�������g��
Dim lngHorizIndex		'�������̃C���f�b�N�X
Dim strHTML				'HTML������

Dim strNewCsCd			'�R�[�X�R�[�h
Dim strNewCtrPtCd		'�_��p�^�[���R�[�h
Dim strNewAgeCalc		'�N��N�Z��
Dim strNewCslDivCd		'��f�敪�R�[�h
Dim blnEditSet			'�Z�b�g�ҏW�Ώۃt���O
Dim strMessage			'���b�Z�[�W
Dim strChecked			'�`�F�b�N�p������
Dim i					'�C���f�b�N�X
'## 2003.11.25 Add By T.Takagi@FSIT �C�ӎ�f�̃Z�b�g�O���[�v�Ȃ�擪���f�t�H���g�Ŏ�f��Ԃɂ���
Dim lngCurIndex			'�C���f�b�N�X
Dim blnExistsSet		'�v�I���Z�b�g�̗L��
Dim blnEdited			'�ҏW�t���O
'## 2003.11.25 Add End

'-------------------------------------------------------------------------------
' �擪���䕔
'-------------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract = Server.CreateObject("HainsContract.Contract")

'�����l�̎擾
strCslDate     = Request("cslDate")
lngCondIndex   = CLng("0" & Request("condIndex"))
strPerId       = Request("perId")
strGender      = Request("gender")
strBirth       = Request("birth")
strAge         = Request("age")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strCsCd        = Request("csCd")
strCslDivCd    = Request("cslDivCd")
strRsvGrpCd    = Request("rsvGrpCd")
strCtrPtCd     = Request("ctrPtCd")
strOptCd       = ConvIStringToArray(Request("optCd"))
strOptBranchNo = ConvIStringToArray(Request("optBranchNo"))
%>
<SCRIPT TYPE="text/javascript">
<!--
<%
'�l���ǂݍ���
If strPerId <> "" Then

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objCommon = Server.CreateObject("HainsCommon.Common")
	Set objPerson = Server.CreateObject("HainsPerson.Person")

	'�l���ǂݍ���
	If objPerson.SelectPerson_lukes(strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strPerBirth, strPerGender, , , , strCompPerId) = False Then
		strPerId = Empty
	End If

	'�����̕ҏW
	strPerName  = Trim(strLastName  & "�@" & strFirstName)
	strPerKName = Trim(strLastKName & "�@" & strFirstKName)

	'���N�����̕ҏW
	strPerBirthJpn = objCommon.FormatString(strPerBirth, "ge.m.d")

' 20080417 �\��g������ʂɃR�����g�{�^���ǉ��̂��� START    
    '��M��L���m�F
    lngHisCsl = objPerson.SelectPerson_note(strPerId, lngRsvNo, lngPerCmt)
' 20080417 �\��g������ʂɃR�����g�{�^���ǉ��̂��� END
    
    Set objCommon = Nothing
	Set objPerson = Nothing

End If

'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'�c�̏��ǂݍ���
'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@Start ###

'objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , strOrgKName, strOrgName
objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2,,strOrgKName,strOrgName,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,strHighLight

'### 2013.12.25 �c�̖��̃n�C���C�g�\���L�����`�F�b�N�̈גǉ��@End   ###





Set objOrganization = Nothing

'�w��c�̂ɂ������f�����_�ŗL���Ȃ��ׂĂ̂P�����f�R�[�X���_��Ǘ��������ɓǂݍ���
lngCtrCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, "", strCslDate, strCslDate, , strArrCsCd, , strArrCsName, , , , strArrCtrPtCd, , , strArrAgeCalc, , True)

'��f�����_�ŗL���Ȃ��ׂĂ̌_��R�[�X�Ɏw��R�[�X�����݂��邩���������A���ݎ��͂��̌_��p�^�[���ƔN��N�Z���Ƃ��擾
For i = 0 To lngCtrCount - 1
	If strArrCsCd(i) = strCsCd Then
		strNewCsCd    = strArrCsCd(i)
		strNewCtrPtCd = strArrCtrPtCd(i)
		strNewAgeCalc = strArrAgeCalc(i)
		Exit For
	End If
Next

'�N��v�Z
Do

	'�_��p�^�[�������݂��Ȃ��ꍇ�͉������Ȃ�
	If strNewCtrPtCd = "" Then
		Exit Do
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objFree = Server.CreateObject("HainsFree.Free")

	'�l��񂪑��݂���ꍇ�A�l�̐��N���������ƂɔN��v�Z
	If strPerId <> "" Then
		strPerAge = objFree.CalcAge(strPerBirth, strCslDate, strNewAgeCalc)
		If strPerAge <> "" Then
			strPerAge = CStr(Int(strPerAge))
		End If
	End If

	'���N�����������w�肳��Ă���ꍇ
	If strBirth <> "" Then

		'�w�肳�ꂽ���N���������ƂɔN��v�Z(�����ɔN��������w�肳��Ă���ꍇ�A�{�v�Z�����ɂ���Ă��̒l�͖����ƂȂ�)
		strAge = objFree.CalcAge(strBirth, strCslDate, strNewAgeCalc)
		If strAge <> "" Then
			strAge = CStr(CInt(strAge))	'�����_�ȉ�������
		End If

		Exit Do
	End If

	'���N�������w�莞�͔N��l�̃`�F�b�N���s��
	If CheckAge(strAge) Then
		strAge = CStr(CInt(strAge))	'�擪�Ƀ[�������͂���Ă���ꍇ�͏���
	End If

	Exit Do
Loop

'-------------------------------------------------------------------------------
'�l���̕ҏW
'-------------------------------------------------------------------------------
%>
// 20080417 �\��g������ʂɃR�����g�{�^���ǉ��̂��ߕύX START
//top.editPerson( <%= lngCondIndex %>, '<%= strPerId %>', '<%= strPerName %>', '<%= strPerKName %>', '<%= strPerBirthJpn %>', '<%= strPerAge %>', '<%= strPerGender %>', '<%= strCompPerId %>', <%= IIf(strGender <> "", 1, 0) %>, '<%= strAge %>'
// 20080417 �\��g������ʂɃR�����g�{�^���ǉ��̂��ߕύX END

top.editPerson( <%= lngCondIndex %>, '<%= strPerId %>', '<%= strPerName %>', '<%= strPerKName %>', '<%= strPerBirthJpn %>', '<%= strPerAge %>', '<%= strPerGender %>', '<%= strCompPerId %>', <%= IIf(strGender <> "", 1, 0) %>, '<%= strAge %>','<%= lngRsvNo %>','<%= lngPerCmt %>');
<%
'-------------------------------------------------------------------------------
'�_��p�^�[�����̕ҏW
'-------------------------------------------------------------------------------
%>
top.editCtrPtInfo( <%= lngCondIndex %>, '<%= strNewCtrPtCd %>', '<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strNewCsCd %>' );
<%
'-------------------------------------------------------------------------------
'�c�̏��̕ҏW
'-------------------------------------------------------------------------------
%>
//top.editOrg( <%= lngCondIndex %>, '<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strOrgName %>', '<%= strOrgKName %>' );
top.editOrg( <%= lngCondIndex %>, '<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strOrgName %>', '<%= strOrgKName %>' , '<%= strHighLight %>' );
<%
'-------------------------------------------------------------------------------
'�R�[�X�Z���N�V�����{�b�N�X�̕ҏW
'-------------------------------------------------------------------------------
%>
var courseInfo = new Array();
<%
For i = 0 To lngCtrCount - 1
%>
	courseInfo[ <%= i %> ] = new top.codeAndName('<%= strArrCsCd(i) %>', '<%= strArrCsName(i) %>');
<%
Next
%>
top.editSelectionBox( 'csCd', <%= lngCondIndex %>, courseInfo, '<%= strCsCd %>' );
<%
'-------------------------------------------------------------------------------
'��f�敪�Z���N�V�����{�b�N�X�̕ҏW
'-------------------------------------------------------------------------------
%>
var cslDivInfo = new Array();
<%
'�w��c�̂ɂ������f�����_�ŗL���Ȏ�f�敪���_��Ǘ��������ɓǂݍ���(�R�[�X�w�莞�͂���ɂ��̃R�[�X�ŗL���Ȃ���)
lngCslDivCount = objContract.SelectAllCslDiv(strOrgCd1, strOrgCd2, strNewCsCd, strCslDate, strCslDate, strArrCslDivCd, strArrCslDivName)

For i = 0 To lngCslDivCount - 1
%>
	cslDivInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrCslDivCd(i) %>', '<%= strArrCslDivName(i) %>' );
<%
Next
%>
top.editSelectionBox( 'cslDivCd', <%= lngCondIndex %>, cslDivInfo, '<%= strCslDivCd %>' );
<%
'�L���Ȃ��ׂĂ̎�f�敪�Ɏw���f�敪�����݂��邩������
For i = 0 To lngCslDivCount - 1
	If strArrCslDivCd(i) = strCslDivCd Then
		strNewCslDivCd = strArrCslDivCd(i)
		Exit For
	End If
Next

'-------------------------------------------------------------------------------
'�\��Q�Z���N�V�����{�b�N�X�̕ҏW
'-------------------------------------------------------------------------------
%>
var rsvGrpInfo = new Array();
<%
'�\��Q�̌���
Do

	'�R�[�X�����莞�͉������Ȃ�
	If strNewCsCd = "" Then
		Exit Do
	End If

	'�I�u�W�F�N�g�̃C���X�^���X�쐬
	Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

	'�w��R�[�X�ɂ�����L���ȗ\��Q�R�[�X��f�\��Q�������ɓǂݍ���
	lngRsvGrpCount = objSchedule.SelectCourseRsvGrpListSelCourse(strNewCsCd, 0, strArrRsvGrpCd, strArrRsvGrpName)

	Set objSchedule = Nothing

	'�\��Q�����݂��Ȃ��ꍇ�͏I��
	If lngRsvGrpCount <= 0 Then
		Exit Do
	End If

	For i = 0 To lngRsvGrpCount - 1
%>
		rsvGrpInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrRsvGrpCd(i) %>', '<%= strArrRsvGrpName(i) %>' );
<%
	Next

	Exit Do
Loop
%>
top.editSelectionBox( 'rsvGrpCd', <%= lngCondIndex %>, rsvGrpInfo, '<%= strRsvGrpCd %>', true );
<%
'-------------------------------------------------------------------------------
'�Z�b�g�̕ҏW
'-------------------------------------------------------------------------------
Do

	'�Z�b�g�\���v�ۂ̃`�F�b�N
	Do

		blnEditSet = False

		'�_��p�^�[���Ȃ��ꍇ�͕\�����Ȃ�
		If strNewCtrPtCd = "" Then
			strMessage = "�_���񂪑��݂��܂���B"
			Exit Do
		End If

		'��f�敪�Ȃ��̏ꍇ�͕\�����Ȃ�
		If strNewCslDivCd = "" Then
			strMessage = "��f�敪��I�����ĉ������B"
			Exit Do
		End If

		'�l�h�c�w�莞�͕\��
		If strPerId <> "" Then
			blnEditSet = True
			Exit Do
		End If

		'�ȉ��͌l�h�c���w��̏ꍇ

		'�N��E���ʖ��m��Ȃ�Ε\�����Ȃ�
		If strGender = "" And strAge = "" Then
			Exit Do
		End If

		'���ʒl���������Ȃ��ꍇ�͕\�����Ȃ�
		Select Case strGender
			Case CStr(GENDER_MALE), CStr(GENDER_FEMALE)
			Case Else
				strMessage = "���ʂ̒l������������܂���B"
				Exit Do
		End Select

		'�N��l���������Ȃ��ꍇ�͕\�����Ȃ�
		If Not CheckAge(strAge) Then
			strMessage = "�N��w�肳��Ă��܂���B�܂��͌v�Z�ł��܂���B"
			Exit Do
		End If

		blnEditSet = True
		Exit Do
	Loop

	'�Z�b�g�\�����s��Ȃ��ꍇ�̓Z�b�g���N���A���A�I��
	If Not blnEditSet Then
%>
		top.editSet( <%= lngCondIndex %>, '<%= strMessage %>' );
<%
		Exit Do
	End If

	'�l�h�c�w�莞
	If strPerId <> "" Then

		'���ʁA�N��w��͕s�v
		lngKeyGender = 0
		strKeyAge = ""

	'�l�h�c���w�莞
	Else

		'���ʁA�N����w��
		lngKeyGender = CLng(strGender)
		strKeyAge = strAge

	End If

	'�w��_��p�^�[���̑S�I�v�V���������Ƃ��̃f�t�H���g��f��Ԃ��擾
	lngCount = objContract.SelectCtrPtOptFromConsult(strCslDate, strNewCslDivCd, strNewCtrPtCd, strPerId, lngKeyGender, , strKeyAge, True, , strArrOptCd, strArrOptBranchNo, , strOptSName, strSetColor, , strConsult, , , strBranchCount, strAddCondition, strHideRsvFra)

	'�\���I�v�V�����̕ҏW
	i = 0
	Do Until i >= lngCount

		Do

			'�\��g��ʕ\����ΏہA�܂��͎����I���I�v�V�����ł���ꍇ�̓X�L�b�v
			If strHideRsvFra(i) <> "" Or strAddCondition(i) = "0" Then
				i = i + 1
				Exit Do
			End If

			'�܂��ҏW����G�������g��ݒ肷��(�}�Ԑ����P�Ȃ�`�F�b�N�{�b�N�X�A�����Ȃ��΃��W�I�{�^���I��)
			strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

			'�I�v�V�����ҏW�p�̃G�������g�����`����
			lngOptGrpSeq   = lngOptGrpSeq + 1
			strElementName = "opt" & CStr(lngOptGrpSeq)

			'�G�������g�^�C�v���Ƃ̏�������
			Select Case strElementType

				Case "radio"	'���W�I�{�^���̏ꍇ

					'���s����
					If lngHorizIndex > 0 Then
						AddShowHTMLArray "</TR>"
						lngHorizIndex = 0
					End If

					'�ҏW�J�n
					AddShowHTMLArray "<TR>"

'## 2003.11.25 Add By T.Takagi@FSIT �C�ӎ�f�̃Z�b�g�O���[�v�Ȃ�擪���f�t�H���g�Ŏ�f��Ԃɂ���
					'���݂̃C���f�b�N�X��ޔ�����
					lngCurIndex = i

					'�t���O������
					blnExistsSet = False

					'����I�v�V�����̌���
					strPrevOptCd = strArrOptCd(i)
					Do Until i >= lngCount

						'���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ�͏I��
						If strArrOptCd(i) <> strPrevOptCd Then
							Exit Do
						End If

						'�`�F�b�N�ΏۂƂȂ�Z�b�g�̗L���𔻒肵�A����ΏI��
						If IsConsults(strNewCtrPtCd, strArrOptCd(i), strArrOptBranchNo(i)) Then
							blnExistsSet = True
							Exit Do
						End If

						'�����R�[�h�̃I�v�V�����R�[�h��ޔ�
						strPrevOptCd = strArrOptCd(i)
						i = i + 1
					Loop

					'�ҏW�ɍۂ��A�ޔ����Ă����C���f�b�N�X��߂�
					i = lngCurIndex

					'�t���O������
					blnEdited = False
'## 2003.11.25 Add End

					'����I�v�V�������������ɕҏW
					strPrevOptCd = strArrOptCd(i)
					Do Until i >= lngCount

						'���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ�͏I��
						If strArrOptCd(i) <> strPrevOptCd Then
							Exit Do
						End If

						'�`�F�b�N�Ώۂ��𔻒�
'## 2003.11.25 Mod By T.Takagi@FSIT �C�ӎ�f�̃Z�b�g�O���[�v�Ȃ�擪���f�t�H���g�Ŏ�f��Ԃɂ���
'						strChecked = IIf(IsConsults(strNewCtrPtCd, strArrOptCd(i), strArrOptBranchNo(i)), " CHECKED", "")

						'�`�F�b�N�ΏۂƂȂ�Z�b�g�����݂���Ȃ炻�̓��e�ɏ���
						If blnExistsSet Then
							strChecked = IIf(IsConsults(strNewCtrPtCd, strArrOptCd(i), strArrOptBranchNo(i)), " CHECKED", "")

						'���݂��Ȃ��Ȃ�擪�Z�b�g�̂ݎ�f��Ԃɂ�����
						Else

							strChecked = IIf(Not blnEdited, " CHECKED", "")
							blnEdited = True

						End If
'## 2003.11.25 Mod End

						'�I�v�V�����̕ҏW
						AddShowHTMLArray "<TD><INPUT TYPE=""radio"" NAME=""" & strElementName & """ VALUE=""" & strArrOptCd(i) & "," & strArrOptBranchNo(i) & """" & strChecked & "></TD>"
						AddShowHTMLArray "<TD NOWRAP><FONT COLOR=""" & strSetColor(i) & """>��</FONT><A HREF=""javascript:callSetInfoWindow(\'" & strNewCtrPtCd & "\',\'" & strArrOptCd(i) & "\',\'" & strArrOptBranchNo(i) & "\')"">" & strOptSName(i) & "</A></TD>"

						'�����R�[�h�̃I�v�V�����R�[�h��ޔ�
						strPrevOptCd = strArrOptCd(i)
						i = i + 1
					Loop

					'�ҏW�I��
					AddShowHTMLArray "</TR>"

				Case "checkbox"	'�`�F�b�N�{�b�N�X�̏ꍇ

					'���s����
					If lngHorizIndex >= OPTCOUNT_PER_ROW Then
						AddShowHTMLArray "</TR>"
						lngHorizIndex = 0
					End If

					'��̐擪�̏ꍇ
					If lngHorizIndex = 0 Then
						AddShowHTMLArray "<TR>"
					End If

					'�`�F�b�N�Ώۂ��𔻒�
					strChecked = IIf(IsConsults(strNewCtrPtCd, strArrOptCd(i), strArrOptBranchNo(i)), " CHECKED", "")

					'�I�v�V�����̕ҏW
					AddShowHTMLArray "<TD><INPUT TYPE=""checkbox"" NAME=""" & strElementName & """ VALUE=""" & strArrOptCd(i) & "," & strArrOptBranchNo(i) & """" & strChecked & "></TD>"
					AddShowHTMLArray "<TD NOWRAP><FONT COLOR=""" & strSetColor(i) & """>��</FONT><A HREF=""javascript:callSetInfoWindow(\'" & strNewCtrPtCd & "\',\'" & strArrOptCd(i) & "\',\'" & strArrOptBranchNo(i) & "\')"">" & strOptSName(i) & "</A></TD>"

					lngHorizIndex = lngHorizIndex + 1
					i = i + 1

			End Select

			Exit Do
		Loop

	Loop

	'��̕ҏW�r���̏ꍇ
	If lngHorizIndex > 0 Then
		AddShowHTMLArray "</TR>"
	End If
%>
	var html = '<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">';
	html = html + '<TR>';
	html = html + '<TD VALIGN="top">';
	html = html + '<TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">';
	html = html + '<TR>';
	html = html + '<TD NOWRAP>�Z�b�g�F</TD>';
	html = html + '</TR>';
	html = html + '</TABLE>';
	html = html + '</TD>';
	html = html + '<TD NOWRAP>';
<%
	'�\���p�I�v�V���������݂���ꍇ
	If lngShowCount > 0 Then

		'�\���p�I�v�V�����̕ҏW
%>
		html = html + '<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">';
<%
		For i = 0 To lngShowCount - 1
%>
			html = html + '<%= strShowHTML(i) %>';
<%
		Next
%>
		html = html + '</TABLE>';
<%
	Else
%>
		html = html + '�Ȃ�';
<%
	End If
%>
	html = html + '</TD>';
	html = html + '</TR>';
	html = html + '</TABLE>';

	top.editSet( <%= lngCondIndex %>, html );
<%
	Exit Do
Loop
%>
top.editAnchor( <%= lngCondIndex %> );
//-->
</SCRIPT>
<%
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �N��O�ȏ�̐��������`�F�b�N
'
' �����@�@ : (In)     strAge  �N��
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CheckAge(strAge)

	Dim i	'�C���f�b�N�X

	If Trim(strAge) = "" Then
		Exit Function
	End If

	'���ׂĂ̕����񂪐����ł��邩���`�F�b�N
	For i = 1 To Len(Trim(strAge))
		If InStr("0123456789", Mid(strAge, i, 1)) <= 0 Then
			Exit Function
		End If
	Next

	CheckAge = True

End Function

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �\���I�v�V�����pHTML������ǉ�
'
' �����@�@ : (In)     strHTML  HTML������
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub AddShowHTMLArray(strHTML)

	ReDim Preserve strShowHTML(lngShowCount)
	strShowHTML(lngShowCount) = strHTML
	lngShowCount = lngShowCount + 1

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��\���I�v�V�����pHTML������ǉ�
'
' �����@�@ : (In)     strHTML  HTML������
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub AddHiddenHTMLArray(strHTML)

	ReDim Preserve strHiddenHTML(lngHiddenCount)
	strHiddenHTML(lngHiddenCount) = strHTML
	lngHiddenCount = lngHiddenCount + 1

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ��f�Ώۂ����`�F�b�N
'
' �����@�@ : (In)     strCheckCtrPtCd      �_��p�^�[���R�[�h
' �@�@�@�@   (In)     strCheckOptCd        �I�v�V�����R�[�h
' �@�@�@�@   (In)     strCheckOptBranchNo  �I�v�V�����}��
'
' �߂�l�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function IsConsults(strCheckCtrPtCd, strCheckOptCd, strCheckOptBranchNo)

	Dim Ret	'�֐��߂�l
	Dim i	'�C���f�b�N�X

	Do

		Ret = False

		'�_��p�^�[�����̂��قȂ�Δ�Ώ�
		If strCheckCtrPtCd <> strCtrPtCd Then
			Exit Do
		End If

		'�`�F�b�N�ΏۂƂȂ�I�v�V���������݂��Ȃ��ꍇ�͔�Ώ�
		If Not IsArray(strOptCd) Then
			Exit Do
		End If

		'�����w�肳�ꂽ�I�v�V���������݂��邩������
		For i = 0 To UBound(strOptCd)
			If strOptCd(i) = strCheckOptCd And strOptBranchNo(i) = strCheckOptBranchNo Then
				Ret = True
				Exit Do
			End If
		Next

		Exit Do
	Loop

	IsConsults = Ret

End Function
%>
