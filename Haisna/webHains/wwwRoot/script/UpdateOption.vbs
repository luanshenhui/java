Option Explicit

Dim objWshShell			'WshShell�I�u�W�F�N�g
Dim objArgs				'WshArguments�I�u�W�F�N�g
Dim objConsult			'�ꊇ�\�񏈗��p

Dim dtmStrCslDate		'�J�n��f��
Dim dtmEndCslDate		'�I����f��
Dim strOrgCd1			'�c�̃R�[�h�P
Dim strOrgCd2			'�c�̃R�[�h�Q
Dim lngCtrPtCd			'�_��p�^�[���R�[�h
Dim strReCreatePrice	'���z���č쐬���邩

Dim Ret					'�֐��߂�l

'�����l�̎擾
Set objArgs = WScript.Arguments

'(1) �J�n��f��
'(2) �I����f��
'(3) �c�̃R�[�h�P
'(4) �c�̃R�[�h�Q
'(5) �_��p�^�[���R�[�h
'(6) ���z���č쐬���邩

dtmStrCslDate    = CDate(objArgs(0))
dtmEndCslDate    = CDate(objArgs(1))
strOrgCd1        = objArgs(2)
strOrgCd2        = objArgs(3)
lngCtrPtCd       = CLng(objArgs(4))
strReCreatePrice = objArgs(5)

'�I�v�V���������X�V����
Set objConsult = CreateObject("HainsCooperation.ConsultAll")
Ret = objConsult.UpdateOption(dtmStrCslDate, dtmEndCslDate, strOrgCd1, strOrgCd2, lngCtrPtCd, strReCreatePrice)
