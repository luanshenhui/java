Option Explicit

Dim objWshShell			'WshShell�I�u�W�F�N�g
Dim objArgs				'WshArguments�I�u�W�F�N�g
Dim objConsult			'�ꊇ�\�񏈗��p

Dim dtmStrCslDate		'�J�n��f��
Dim dtmEndCslDate		'�I����f��
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgBsdCd			'���ƕ��R�[�h
Dim strOrgRoomCd		'�����R�[�h
Dim strStrOrgPostCd		'�J�n�����R�[�h
Dim strEndOrgPostCd		'�I�������R�[�h
Dim lngCtrPtCd			'�_��p�^�[���R�[�h
Dim lngNotFixedOnly		'��f�����m�蕪�폜�w��("1":��f�����m�蕪�݂̂��폜)
Dim lngNotCancelForce	'�����폜��("1":��f�����͂���Ă����f���͍폜���Ȃ�)
Dim lngNotExistsOptOnly	'"1":�I�v�V�����������P�����݂��Ȃ���f���̂ݍ폜

Dim Ret					'�֐��߂�l

'�����l�̎擾
Set objArgs = WScript.Arguments

'(1)  �J�n��f��
'(2)  �I����f��
'(3)  �c�̃R�[�h�P
'(4)  �c�̃R�[�h�Q
'(5)  ���ƕ��R�[�h
'(6)  �����R�[�h
'(7)  �J�n�����R�[�h
'(8)  �I�������R�[�h
'(9)  �_��p�^�[���R�[�h
'(10) ��f�����m�蕪�폜�w��
'(11) �����폜��
'(12) �I�v�V���������L���`�F�b�N

dtmStrCslDate     = CDate(objArgs(0))
dtmEndCslDate     = CDate(objArgs(1))
strOrgCd1         = objArgs(2)
strOrgCd2         = objArgs(3)
strOrgBsdCd       = objArgs(4)
strOrgRoomCd      = objArgs(5)
strStrOrgPostCd   = objArgs(6)
strEndOrgPostCd   = objArgs(7)
lngCtrPtCd        = CLng(objArgs(8))
lngNotFixedOnly   = CLng(objArgs(9))
lngNotCancelForce = CLng(objArgs(10))
lngNotExistsOptOnly = CLng(objArgs(11))

'�ꊇ�\��폜����
Set objConsult = CreateObject("HainsCooperation.ConsultAll")
Ret = objConsult.DeleteConsultAll(dtmStrCslDate, dtmEndCslDate, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, lngCtrPtCd, lngNotFixedOnly, lngNotCancelForce, lngNotExistsOptOnly)
