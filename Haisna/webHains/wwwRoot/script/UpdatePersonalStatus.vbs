Option Explicit

Dim objWshShell			'WshShell�I�u�W�F�N�g
Dim objArgs				'WshArguments�I�u�W�F�N�g
Dim objCooperation		'�A�g�E�ꊇ�����p

Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim dtmStrCslDate		'�J�n��f��
Dim dtmEndCslDate		'�I����f��
Dim strDelFlg			'�g�p���t���O

Dim Ret					'�֐��߂�l

'�����l�̎擾
Set objArgs = WScript.Arguments

'(1) �c�̃R�[�h�P
'(2) �c�̃R�[�h�Q
'(3) �J�n��f��
'(4) �I����f��
'(5) �g�p���t���O

strOrgCd1     = objArgs(0)
strOrgCd2     = objArgs(1)
dtmStrCslDate = CDate(objArgs(2))
dtmEndCslDate = CDate(objArgs(3))
strDelFlg     = objArgs(4)

'�l���ꊇ�X�V����
Set objCooperation = CreateObject("HainsCooperation.PersonAll")
Ret = objCooperation.UpdateStatus(strOrgCd1, strOrgCd2, dtmStrCslDate, dtmEndCslDate, strDelFlg)
