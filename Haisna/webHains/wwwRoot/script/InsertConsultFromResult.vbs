Option Explicit

Dim objWshShell			'WshShell�I�u�W�F�N�g
Dim objArgs				'WshArguments�I�u�W�F�N�g
Dim objConsult			'�ꊇ�\�񏈗��p

Dim strUserId			'���[�U�h�c
Dim dtmStrCslDate		'�J�n��f��
Dim dtmEndCslDate		'�I����f��
Dim strArrCsCd			'�R�[�X�R�[�h�̔z��
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim strOrgBsdCd			'���ƕ��R�[�h
Dim strOrgRoomCd		'�����R�[�h
Dim strStrOrgPostCd		'�J�n�����R�[�h
Dim strEndOrgPostCd		'�I�������R�[�h
Dim lngCtrPtCd			'�_��p�^�[���R�[�h
Dim dtmSecStrCslDate	'���蓖�ĊJ�n��
Dim dtmSecEndCslDate	'���蓖�ďI����

Dim Ret					'�֐��߂�l

'�����l�̎擾
Set objArgs = WScript.Arguments

'(1)  ���[�U�h�c
'(2)  �J�n��f��
'(3)  �I����f��
'(4)  �R�[�X�R�[�h
'(5)  �c�̃R�[�h�P
'(6)  �c�̃R�[�h�Q
'(7)  ���ƕ��R�[�h
'(8)  �����R�[�h
'(9)  �J�n�����R�[�h
'(10)  �I�������R�[�h
'(11) �_��p�^�[���R�[�h
'(12) ���蓖�ĊJ�n��
'(13) ���蓖�ďI����

strUserId        = objArgs(0)
dtmStrCslDate    = CDate(objArgs(1))
dtmEndCslDate    = CDate(objArgs(2))
strArrCsCd       = Split(objArgs(3), ",")
strOrgCd1        = objArgs(4)
strOrgCd2        = objArgs(5)
strOrgBsdCd      = objArgs(6)
strOrgRoomCd     = objArgs(7)
strStrOrgPostCd  = objArgs(8)
strEndOrgPostCd  = objArgs(9)
lngCtrPtCd       = CLng(objArgs(10))
dtmSecStrCslDate = CDate(objArgs(11))
dtmSecEndCslDate = CDate(objArgs(12))

'�ꊇ�\�񏈗�
Set objConsult = CreateObject("HainsCooperation.ConsultAll")
Ret = objConsult.InsertConsultFromResult(strUserId, dtmStrCslDate, dtmEndCslDate, strArrCsCd, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, lngCtrPtCd, dtmSecStrCslDate, dtmSecEndCslDate)
