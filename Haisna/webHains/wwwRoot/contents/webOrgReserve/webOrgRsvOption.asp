<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web�c�̗\����o�^(�����Z�b�g) (Ver1.0.0)
'      AUTHER  : 
'-----------------------------------------------------------------------------
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.3.11
'�S����  �FT.Takagi@RD
'�C�����e�Fweb�\���f�I�v�V�����̎擾���@�ύX

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD START #### %>
<!-- #include virtual = "/webHains/includes/convertWebOption.inc" -->
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD END   #### %>
<%
'�Z�b�V�����E�����`�F�b�N
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' ���ʐ錾��
'-----------------------------------------------------------------------------
Const SETCLASS_STOMAC_NOTHING   = "035" '�Z�b�g����(�P���h�b�N(�݂���))
Const SETCLASS_STOMAC_XRAY      = "001" '�Z�b�g����(�P���h�b�N(�݂w��))
Const SETCLASS_STOMAC_CAMERA    = "002" '�Z�b�g����(�P���h�b�N(�ݓ�����))

Const SETCLASS_BREAST_NOTHING   = "009" '�Z�b�g����(�I�v�V�������[�����Ȃ�)

Const SETCLASS_BREAST_XRAY      = "010" '�Z�b�g����(���[�w��)

Const SETCLASS_BREAST_ECHO      = "011" '�Z�b�g����(���[�����g)

Const SETCLASS_BREAST_XRAY_ECHO = "012" '�Z�b�g����(���[�w���E���[�����g)

'�f�[�^�x�[�X�A�N�Z�X�p�I�u�W�F�N�g
Dim objContract             '�_����A�N�Z�X�p
Dim objSchedule             '�X�P�W���[�����A�N�Z�X�p

'�����l(����)
Dim strPerId                '�l�h�c
Dim lngGender               '����
Dim dtmBirth                '���N����
Dim strOrgCd1               '�c�̃R�[�h�P
Dim strOrgCd2               '�c�̃R�[�h�Q
Dim strCsCd                 '�R�[�X�R�[�h
Dim dtmCslDate              '��f��
Dim strCslDivCd             '��f�敪�R�[�h
Dim lngOptionStomac         '�݌���(0:�݂Ȃ��A1:��X���A2:�ݓ�����)
Dim lngOptionBreast         '���[����(0:���[�Ȃ��A1:���[X���A2:���[�����g�A3:���[X���{���[�����g)
Dim blnShowAll              '�S�Z�b�g�\���t���O
Dim blnReadOnly             '�ǂݍ��ݐ�p
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
Dim strCslOptions			'��f�I�v�V����
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'�����l(�{��ʂ���\���{�^�����������ꂽ�ꍇ�̂ݓn�����)
Dim strCtrPtCd              '�_��p�^�[���R�[�h
Dim strOptCd                '�I�v�V�����R�[�h
Dim strOptBranchNo          '�I�v�V�����}��

'�_����
Dim strNewCtrPtCd           '�_��p�^�[���R�[�h
Dim strAgeCalc              '�N��N�Z��
Dim strRefOrgCd1            '�Q�Ɛ�c�̃R�[�h�P
Dim strRefOrgCd2            '�Q�Ɛ�c�̃R�[�h�Q
Dim strCsName               '�R�[�X��

'�I�v�V�����������
Dim strArrOptCd             '�I�v�V�����R�[�h
Dim strArrOptBranchNo       '�I�v�V�����}��
Dim strOptName              '�I�v�V������
Dim strSetColor             '�Z�b�g�J���[
Dim strSetClassCd           '�Z�b�g���ރR�[�h
Dim strConsult              '��f�v��
Dim strBranchCount          '�I�v�V�����}�Ԑ�
Dim strAddCondition         '�ǉ�����
Dim strHideRsv              '�\���ʔ�\��
Dim strPrice                '�����z
Dim strPerPrice             '�l���S���z
Dim lngCount                '�I�v�V����������

'��\���I�v�V�������
Dim strHideElementName()    '�G�������g��
Dim strHideOptCd()          '�I�v�V�����R�[�h
Dim strHideOptBranchNo()    '�I�v�V�����}��
Dim strHideConsult()        '��f�v��
Dim lngHideCount            '�I�v�V������

'�_����
Dim strArrCsCd              '�R�[�X�R�[�h
Dim strArrCsName            '�R�[�X��
Dim strArrCtrPtCd           '�_��p�^�[���R�[�h
Dim lngCtrCount             '�_����

'��f�敪���
Dim strArrCslDivCd          '��f�敪�R�[�h
Dim strArrCslDivName        '��f�敪��
Dim lngCslDivCount          '��f�敪��

Dim strAge                  '��f���N��
Dim strRealAge              '���N��

Dim strChecked              '�`�F�b�N�{�b�N�X�̃`�F�b�N���

Dim strPrevOptCd            '���O���R�[�h�̃I�v�V�����R�[�h
Dim lngOptGrpSeq            '�I�v�V�����O���[�v��SEQ�l
Dim strElementType          '�I�v�V�����I��p�̃G�������g���
Dim strElementName          '�I�v�V�����I��p�̃G�������g��

Dim blnExist                '���݃t���O
Dim strMessage              '���b�Z�[�W
Dim strURL                  '�W�����v���URL
Dim i                       '�C���f�b�N�X

'-----------------------------------------------------------------------------
' �擪���䕔
'-----------------------------------------------------------------------------
'�I�u�W�F�N�g�̃C���X�^���X�쐬
Set objContract = Server.CreateObject("HainsContract.Contract")

'response.write Request("birth")
'response.write Request("cslDate")
'response.end

'�����l�̎擾
strPerId        = Request("perId")
lngGender       = CLng("0" & Request("gender"))
dtmBirth        = CDate(Request("birth"))
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strCsCd         = Request("csCd")
dtmCslDate      = CDate(Request("cslDate"))
strCslDivCd     = Request("cslDivCd")
lngOptionStomac = CLng("0" & Request("stomac"))
lngOptionBreast = CLng("0" & Request("breast"))
blnShowAll      = (Request("showAll") <> "")
blnReadOnly     = (Request("readOnly") <> "")
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
strCslOptions   = Request("csloptions")
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

strCtrPtCd      = Request("ctrPtCd")
strOptCd        = ConvIStringToArray(Request("optCd"))
strOptBranchNo  = ConvIStringToArray(Request("optBNo"))

Do

    strMessage = "��{������͂��ĉ������B"

    '��f�����_�ł̎��N��v�Z
    strRealAge = CalcAge(dtmBirth, dtmCslDate, "")

    '�����_�ȉ��̏���
    If InStr(strRealAge, ".") > 0 Then
        strRealAge = Left(strRealAge, InStr(strRealAge, ".") - 1)
    End If

    '�w��c�̂ɂ������f�����_�ŗL���Ȃ��ׂẴR�[�X���_��Ǘ��������ɓǂݍ���
    lngCtrCount = objContract.SelectAllCtrMng(strOrgCd1, strOrgCd2, "", dtmCslDate, dtmCslDate, , strArrCsCd, , strArrCsName, , , , strArrCtrPtCd)
    If lngCtrCount <= 0 Then
        Exit Do
    End If

    '��f�����_�ŗL���Ȃ��ׂẴR�[�X�Ɏw�肳�ꂽ�R�[�X�����݂��邩���������A���̌_��p�^�[���R�[�h���擾
    For i = 0 To lngCtrCount - 1
        If strArrCsCd(i) = strCsCd Then
            strNewCtrPtCd = strArrCtrPtCd(i)
            Exit For
        End If
    Next

    '�w������𖞂����_���񂪑��݂��Ȃ��ꍇ�A�N��v�Z���s�\�A���I�v�V���������̎擾���s�\�Ȃ��߁A�������I������
    If strNewCtrPtCd = "" Then
        strMessage = "���̒c�̂̃h�b�N�_����͑��݂��܂���B"
        Exit Do
    End If

    '�w��c�̂ɂ������f�����_�ŗL���Ȏ�f�敪���_��Ǘ��������ɓǂݍ���
    lngCslDivCount = objContract.SelectAllCslDiv(strOrgCd1, strOrgCd2, strCsCd, dtmCslDate, dtmCslDate, strArrCslDivCd, strArrCslDivName)
    If lngCslDivCount <= 0 Then
        Exit Do
    End If

    '�N��v�Z�ɍۂ��A�܂��_�����ǂݍ���ŔN��N�Z�����擾����(�Q�Ɛ�̒c�̂͌�ŃA���J�[�p�Ɏg�p����)
    objContract.SelectCtrMng strOrgCd1, strOrgCd2, strNewCtrPtCd, , , , , , , , strRefOrgCd1, strRefOrgCd2, strAgeCalc

    '�N��v�Z
    strAge = CalcAge(dtmBirth, dtmCslDate, strAgeCalc)

    '�I�����ׂ���f�敪�����݂��邩������
    For i = 0 To lngCslDivCount - 1
        If strArrCslDivCd(i) = strCslDivCd Then
            blnExist = True
            Exit For
        End If
    Next

    '�I�����ׂ���f�敪�����݂��Ȃ���΃I�v�V���������̎擾�͕s�\�Ɣ��f���A�������I������
    If Not blnExist Then
        Exit Do
    End If

    '�w��_��p�^�[���̑S�I�v�V���������Ƃ��̃f�t�H���g��f��Ԃ��擾
    lngCount = objContract.SelectCtrPtOptFromConsult( _
                   dtmCslDate,        _
                   strCslDivCd,       _
                   strNewCtrPtCd,     _
                   strPerId,          _
                   lngGender,         _
                   dtmBirth, ,        _
                   True,              _
                   False,             _
                   strArrOptCd,       _
                   strArrOptBranchNo, _
                   strOptName, ,      _
                   strSetColor,       _
                   strSetClassCd,     _
                   strConsult, , ,    _
                   strBranchCount,    _
                   strAddCondition, , _
                   strHideRsv, , ,    _
                   strPrice,          _
                   strPerPrice,       _
                   1                  _
               )

    '�I�v�V�����������Ƃ��ēn����Ă��Ȃ��ꍇ�A�܂��͓n����Ă��邪�_��p�^�[������v���Ȃ��ꍇ(��҂͎����㔭�����Ȃ�)
    If strCtrPtCd = "" Or strCtrPtCd <> strNewCtrPtCd Then

        '�f�t�H���g��f��Ԃ�ݒ�
        Call SetDefaultConsults

        Exit Do
    End If

    '�I�v�V�������n����A���_��p�^�[������v����ꍇ�͎�f��Ԃ̌p�����s��
    SetConsultPreviousStatus strOptCd, strOptBranchNo

    Exit Do
Loop
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �N��v�Z
'
' �����@�@ : (In)     dtmParaBirth    ���N����
' �@�@�@�@   (In)     dtmParaCslDate  ��f�N����
' �@�@�@�@   (In)     strParaAgeCalc  �N��N�Z��
'
' �߂�l�@ : �N��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Function CalcAge(dtmParaBirth, dtmParaCslDate, strParaAgeCalc)

    Dim objFree     '�ėp���A�N�Z�X�p

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = Server.CreateObject("HainsFree.Free")

    '�N��̌v�Z
    CalcAge = objFree.CalcAge(dtmParaBirth, dtmParaCslDate, strParaAgeCalc)

End Function
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �f�t�H���g��f��Ԑݒ�
'
' �����@�@ :
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub SetDefaultConsults()

    Dim strArrSetClassCd    '�Z�b�g���ރR�[�h

'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
	Dim i					'�C���f�b�N�X

	'��f�I�v�V�����̃J���}��؂蕶���񂪎w�肳��Ă���ꍇ�͂��̓��e�����ƂɃf�t�H���g��f��Ԃ�ݒ�B�����Ȃ��΋����̐ݒ胍�W�b�N���̗p�B
	If strCslOptions <> "" Then

		'��f�I�v�V�����̃J���}��؂蕶������Z�b�g���ނ̔z��ɕϊ�
		strArrSetClassCd = ConvertToSetClass(strCslOptions)

		'�z��v�f�����݂���ꍇ�͂��̂��ׂẴZ�b�g���ނ��������A�f�t�H���g��f��Ԃ�ݒ�
		If Not IsEmpty(strArrSetClassCd) Then
			For i = 0 To UBound(strArrSetClassCd)
				SetConsults strArrSetClassCd(i)
			Next
		End If

	Else
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

    '�݌����̃f�t�H���g��f��Ԑݒ�
    strArrSetClassCd = Array(SETCLASS_STOMAC_NOTHING, SETCLASS_STOMAC_XRAY, SETCLASS_STOMAC_CAMERA)
    SetConsults strArrSetClassCd(lngOptionStomac)

    '���[�����̃f�t�H���g��f��Ԑݒ�
    strArrSetClassCd = Array(SETCLASS_BREAST_NOTHING, SETCLASS_BREAST_XRAY, SETCLASS_BREAST_ECHO, SETCLASS_BREAST_XRAY_ECHO)
    SetConsults strArrSetClassCd(lngOptionBreast)

'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
	End If
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

    '��f�t���O�������Ă��Ȃ��C�ӎ�f�̃Z�b�g�ɑ΂��A�擪�Z�b�g����f��Ԃɂ���
    Call SetConsultTopSet

    '�����̎}�ԃZ�b�g�Ɏ�f�t���O�����C�ӎ�f�̃Z�b�g�ɑ΂��āA�}�Ԃ��Ⴂ����D�悷��
    Call SetConsultMinimumOpt

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �C�ӎ�f�I�v�V�����̃f�t�H���g��f��Ԑݒ�P
'
' �����@�@ : (In)     strParaSetClassCd  ��f�ΏۂƂȂ�Z�b�g���ރR�[�h
'
' ���l�@�@ : �w��Z�b�g���ނɎ�f�t���O�𗧂Ă�
'
'-------------------------------------------------------------------------------
Sub SetConsults(strParaSetClassCd)

    Dim i   '�C���f�b�N�X

    '�w��Z�b�g���ނ̔C�ӎ�f�����Z�b�g�Ɏ�f�t���O�𗧂Ă�
    For i = 0 To lngCount - 1
        If strAddCondition(i) = "1" And strSetClassCd(i) = strParaSetClassCd Then
            strConsult(i) = "1"
        End If
    Next

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �C�ӎ�f�I�v�V�����̃f�t�H���g��f��Ԑݒ�Q
'
' �����@�@ :
'
' ���l�@�@ : ��f�t���O�������Ă��Ȃ��C�ӎ�f�̃Z�b�g�ɑ΂��A�擪�Z�b�g����f��Ԃɂ���
'
'-------------------------------------------------------------------------------
Sub SetConsultTopSet()

    Dim blnConsult  '��f�`�F�b�N�̗v��
    Dim i, j        '�C���f�b�N�X

    i = 0
    Do Until i >= lngCount

        Do

            '�����ǉ��I�v�V�����̓X�L�b�v
            If strAddCondition(i) = "0" Then
                i = i + 1
                Exit Do
            End If

            '�}�Ԑ����P�̂��̂�(�`�F�b�N�{�b�N�X����ƂȂ�̂�)�X�L�b�v
            If CLng("0" & strBranchCount(i)) <= 1 Then
                i = i + 1
                Exit Do
            End If

            '���݈ʒu���L�[�v
            j = i

            strPrevOptCd = strArrOptCd(i)
            blnConsult = False

            '���݈ʒu���瓯��I�v�V�����R�[�h�̎�f��Ԃ�����
            Do Until i >= lngCount

                '���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ�͏I��
                If strArrOptCd(i) <> strPrevOptCd Then
                    Exit Do
                End If

                '���łɎ�f��Ԃ̂��̂�����΃t���O����
                If strConsult(i) = "1" Then
                    blnConsult = True
                End If

                '���݂̃I�v�V�����R�[�h��ޔ�
                strPrevOptCd = strArrOptCd(i)
                i = i + 1
            Loop

            '���ʁA��f��Ԃ̂��̂��Ȃ���ΐ�ɃL�[�v���Ă������擪�̃I�v�V��������f��Ԃɂ���
            If Not blnConsult Then
                strConsult(j) = "1"
            End If

            Exit Do
        Loop

    Loop

End Sub
'-------------------------------------------------------------------------------
'
' �@�\�@�@ : �C�ӎ�f�I�v�V�����̃f�t�H���g��f��Ԑݒ�R
'
' �����@�@ :
'
' ���l�@�@ : �����̎}�ԃZ�b�g�Ɏ�f�t���O�����C�ӎ�f�̃Z�b�g�ɑ΂��āA�}�Ԃ��Ⴂ����D�悷��
'
'-------------------------------------------------------------------------------
Sub SetConsultMinimumOpt()

    Dim blnConsult  '��f�`�F�b�N�̗v��
    Dim i, j        '�C���f�b�N�X

    i = 0
    Do Until i >= lngCount

        Do

            '�����ǉ��I�v�V�����̓X�L�b�v
            If strAddCondition(i) = "0" Then
                i = i + 1
                Exit Do
            End If

            '�}�Ԑ����P�̂��̂�(�`�F�b�N�{�b�N�X����ƂȂ�̂�)�X�L�b�v
            If CLng("0" & strBranchCount(i)) <= 1 Then
                i = i + 1
                Exit Do
            End If

            strPrevOptCd = strArrOptCd(i)
            blnConsult = False

            '���݈ʒu���瓯��I�v�V�����R�[�h�̎�f��Ԃ�����
            Do Until i >= lngCount

                '���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ�͏I��
                If strArrOptCd(i) <> strPrevOptCd Then
                    Exit Do
                End If

                '���łɃt���O�������͈ȍ~�̎}�ԃI�v�V�����̎�f��Ԃ��N���A
                If blnConsult Then
                    strConsult(i) = ""
                End If

                '��f��Ԃ̃Z�b�g���ŏ��Ɍ��������ꍇ�Ƀt���O����
                If strConsult(i) = "1" Then
                    blnConsult = True
                End If

                '���݂̃I�v�V�����R�[�h��ޔ�
                strPrevOptCd = strArrOptCd(i)
                i = i + 1
            Loop

            Exit Do
        Loop

    Loop

End Sub

'-------------------------------------------------------------------------------
'
' �@�\�@�@ : ���O��f��Ԃ̐ݒ�
'
' �����@�@ : (In)     strParaDefOptCd        �p���`�F�b�N���ׂ��I�v�V�����R�[�h�̏W��
' �@�@�@�@   (In)     strParaDefOptBranchNo  �p���`�F�b�N���ׂ��I�v�V�����}�Ԃ̏W��
'
' ���l�@�@ :
'
'-------------------------------------------------------------------------------
Sub SetConsultPreviousStatus(strParaDefOptCd, strParaDefOptBranchNo)

    Dim i, j    '�C���f�b�N�X

    '�S�����Z�b�g�̌���
    For i = 0 To lngCount - 1

        Do

            '�t���O�̏�����
            strConsult(i) = ""

            '�������w�莞�͖��I���Ƃ���
            If IsEmpty(strParaDefOptCd) Or IsEmpty(strParaDefOptBranchNo) Then
                Exit Do
            End If

            '�����w�肳�ꂽ�I�v�V�����ɑ΂��ă`�F�b�N������
            For j = 0 To UBound(strParaDefOptCd)
                If strParaDefOptCd(j) = strArrOptCd(i) And strParaDefOptBranchNo(j) = strArrOptBranchNo(i) Then
                    strConsult(i) = "1"
                    Exit Do
                End If
            Next

            Exit Do
        Loop

    Next

End Sub
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>�I�v�V��������</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// �w��G�������g�̃`�F�b�N��Ԃɂ��s�\���F�ݒ�
function selColor( selObj ) {

    var rowColor, topColor;     // �s�S�̂̐F�A�擪��̐F

    // �\���F��ύX���ׂ��m�[�h���擾
    var changedNode = selObj.parentNode.parentNode;

    // �\���F�̐ݒ�
    if ( selObj.checked ) {
        rowColor = '#eeeeee';
        topColor = '#ffc0cb';
    } else {
        rowColor = '#ffffff';
        topColor = '#ffffff';
    }

    // �\���F�̕ύX
    changedNode.style.backgroundColor = rowColor;
    changedNode.getElementsByTagName('td')[0].style.backgroundColor = topColor;

}

// �w��G�������g�ɑΉ�����s�̑I��\��
function setRow( selObj ) {

    var objRadio;   // ���W�I�{�^���̏W��
    var selFlg;     // �I���t���O

    // �G�������g�^�C�v���Ƃ̏�������
    switch ( selObj.type ) {

        case 'checkbox':    // �`�F�b�N�{�b�N�X
            selColor( selObj );
            break;

        case 'radio':       // ���W�I�{�^��

            // �����̑S�G�������g�ɑ΂���I��\��
            objRadio = document.optList.elements[ selObj.name ];
            for ( var i = 0; i < objRadio.length; i++ ) {
                selColor( objRadio[ i ] );
            }

    }

}

// �S�s�̑I��\��
function setRows() {

    // �ꗗ�����݂��Ȃ���Ή������Ȃ�
    if ( !document.optList ) {
        return;
    }

    var objElements = document.optList.elements;
    for ( var i = 0; i < objElements.length; i++ ) {
        setRow( objElements[ i ] );
    }

}

// �ꗗ�̍ĕ\��
function showOptList() {

    var arrOptCd       = new Array();	// �I�v�V�����R�[�h
    var arrOptBranchNo = new Array();	// �I�v�V�����}��

    // ���݂̑I���I�v�V�����l���擾
    top.convOptCd( document.optList, arrOptCd, arrOptBranchNo );

    // �I�v�V����������ʂ̍X�V
    top.replaceOptionFrame( document.entryForm.ctrPtCd.value, arrOptCd, arrOptBranchNo );

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:setRows()">
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="464">
    <TR>
        <TD HEIGHT="15" BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">�����Z�b�g</FONT></B></TD>
    </TR>
</TABLE>
<%
Do
    '�_����̕\�����s���Ȃ��ꍇ�̓��b�Z�[�W��ҏW
    If Not blnExist Then
%>
        <BR><%= strMessage %>
<%
        Exit Do
    End If
%>
    <FORM NAME="entryForm" STYLE="margin: 0px" action="#">
        <INPUT TYPE="hidden" NAME="ctrPtCd" VALUE="<%= strNewCtrPtCd %>">
        <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="0" WIDTH="464">
            <TR>
                <TD NOWRAP><FONT SIZE="-1">�p�^�[��No.�F<B><%= strNewCtrPtCd %></B></FONT></TD>
<%
                '�_��Q�Ɨp��URL�ҏW
                strURL = "/webHains/contents/contract/ctrDetail.asp"
                strURL = strURL & "?orgCd1="  & strRefOrgCd1
                strURL = strURL & "&orgCd2="  & strRefOrgCd2
                strURL = strURL & "&csCd="    & strCsCd
                strURL = strURL & "&ctrPtCd=" & strNewCtrPtCd
%>
                <TD WIDTH="100%" NOWRAP><FONT SIZE="-1">&nbsp;&nbsp;<A HREF="<%= strURL %>" TARGET="_blank">���̌_����Q��</A></FONT></TD>
                <TD><INPUT TYPE="checkBox" NAME="showAll" VALUE="1"<%= IIf(blnShowAll, " CHECKED", "") %>></TD>
                <TD NOWRAP><FONT SIZE="-1">���ׂĂ̌�����&nbsp;</FONT></TD>
                <TD><A HREF="javascript:showOptList()"><IMG SRC="/webhains/images/b_prev.gif" HEIGHT="28" WIDTH="53" ALT="�����Z�b�g���ĕ\�����܂�"></A></TD>
            </TR>
            <TR>
                <TD HEIGHT="5"></TD>
            </TR>
        </TABLE>
    </FORM>
<%
    '�I�v�V�������������݂��Ȃ��ꍇ�̓��b�Z�[�W�ҏW
    If lngCount = 0 Then
        Response.Write "���̌_����̃I�v�V���������͑��݂��܂���B"
        Exit Do
    End If

    lngOptGrpSeq = 0
%>
    <FORM NAME="optList" STYLE="margin: 0px" action="#">
        <TABLE ID="optTable" BORDER="0" CELLPADDING="1" CELLSPACING="1" WIDTH="464">
            <TR>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="1" ALT=""></TD>
            </TR>
            <TR BGCOLOR="#eeeeee" ALIGN="center">
<%
                '�_��p�^�[������ǂ݁A�_���̃R�[�X�����擾
                objContract.SelectCtrPt strNewCtrPtCd, , , , , strCsName
%>
                <TD ALIGN="left" COLSPAN="3">�����Z�b�g���i<%= strCsName %>�j</TD>
                <TD NOWRAP>���S���z�v</TD>
                <TD NOWRAP>�l���S��</TD>
                <TD></TD>
            </TR>
<%
            '�ǂݍ��񂾃I�v�V�����������̌���
            strPrevOptCd = ""
            For i = 0 To lngCount - 1

                '���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ
                If strArrOptCd(i) <> strPrevOptCd Then

                    '�܂��ҏW����G�������g��ݒ肷��(�}�Ԑ����P�Ȃ�`�F�b�N�{�b�N�X�A�����Ȃ��΃��W�I�{�^���I��)
                    strElementType = IIf(CLng(strBranchCount(i)) = 1, "checkbox", "radio")

                    '�I�v�V�����ҏW�p�̃G�������g�����`����
                    lngOptGrpSeq   = lngOptGrpSeq + 1
                    strElementName = "opt" & CStr(lngOptGrpSeq)

                End If

                '�\���ʔ�\���I�v�V�����A�����ׂĂ̌�����\�����Ȃ��ꍇ
                If strHideRsv(i) <> "" And blnShowAll = False Then

                    '��ŕҏW���邽�߂ɂ����ŃX�^�b�N����
                    ReDim Preserve strHideElementName(lngHideCount)
                    ReDim Preserve strHideOptCd(lngHideCount)
                    ReDim Preserve strHideOptBranchNo(lngHideCount)
                    ReDim Preserve strHideConsult(lngHideCount)
                    strHideElementName(lngHideCount) = strElementName
                    strHideOptCd(lngHideCount) = strArrOptCd(i)
                    strHideOptBranchNo(lngHideCount) = strArrOptBranchNo(i)
                    strHideConsult(lngHideCount) = strConsult(i)
                    lngHideCount = lngHideCount + 1

                '�\���ΏۃI�v�V�����̏ꍇ
                Else

                    '���O���R�[�h�ƃI�v�V�����R�[�h���قȂ�ꍇ�̓Z�p���[�^��ҏW
                    If strPrevOptCd <> "" And strArrOptCd(i) <> strPrevOptCd Then
%>
                        <TR><TD HEIGHT="3"></TD></TR>
<%
                    End If

                    strChecked = IIf(strConsult(i) = "1", " CHECKED", "")
%>
                    <TR ALIGN="right">
                        <TD></TD>
                        <TD><INPUT TYPE="<%= strElementType %>" NAME="<%= strElementName %>" VALUE="<%= strArrOptCd(i) & "," & strArrOptBranchNo(i) %>"<%= strChecked %> ONCLICK="javascript:setRow(this)"></TD>
                        <TD ALIGN="left" WIDTH="100%"><FONT COLOR="<%= strSetColor(i) %>">��</FONT><%= strOptName(i) %></TD>
                        <TD><%= FormatCurrency(strPrice(i)) %></TD>
                        <TD><%= FormatCurrency(strPerPrice(i)) %></TD>
                        <TD NOWRAP>&nbsp;<%= strArrOptCd(i) & "-" & strArrOptBranchNo(i) %></TD>
                    </TR>
<%
                End If

                '�����R�[�h�̃I�v�V�����R�[�h��ޔ�
                strPrevOptCd = strArrOptCd(i)

            Next
%>
        </TABLE>
<%
        '�X�^�b�N���ꂽ����������hidden�ɂĕێ�
        For i = 0 To lngHideCount - 1
%>
            <INPUT TYPE="hidden" NAME="<%= strHideElementName(i) %>" VALUE="<%= strHideOptCd(i) & "," & strHideOptBranchNo(i) & "," & strHideConsult(i) %>">
<%
        Next
%>
    </FORM>
<%
    Exit Do
Loop
%>
<SCRIPT TYPE="text/javascript">
<!--
<%
'��f�敪�Z���N�V�����{�b�N�X�̕ҏW
%>
var cslDivInfo = new Array();
<%
For i = 0 To lngCslDivCount - 1
%>
    cslDivInfo[ <%= i %> ] = new top.codeAndName( '<%= strArrCslDivCd(i) %>', '<%= strArrCslDivName(i) %>' );
<%
Next
%>
top.editCslDiv(cslDivInfo, '<%= strCslDivCd %>');
<%
'�N����v�Z���A��{���ɕҏW����
%>
top.editAge('<%= strAge %>', '<%= strRealAge %>');
<%
'�ǂݍ��ݐ�p���͂��ׂĂ̓��͗v�f���g�p�s�\�ɂ���
If blnReadOnly Then
%>
    top.disableElements( document.optList );
<%
End If
%>
//-->
</SCRIPT>
</BODY>
</HTML>
