Option Explicit

Dim objWshShell		'WshShell�I�u�W�F�N�g
Dim objArgs			'WshArguments�I�u�W�F�N�g
Dim objConsult		'�ꊇ�\�񏈗��p

Dim strUserId		'���[�U�h�c
Dim strOrgCd1		'�c�̃R�[�h�P
Dim strOrgCd2		'�c�̃R�[�h�Q
Dim strOrgBsdCd		'���ƕ��R�[�h
Dim strOrgRoomCd	'�����R�[�h
Dim strStrOrgPostCd	'�J�n�����R�[�h
Dim strEndOrgPostCd	'�I�������R�[�h
Dim lngCtrPtCd		'�_��p�^�[���R�[�h
Dim dtmCslDate		'��f��
Dim lngOpMode		'�������[�h

Dim Ret				'�֐��߂�l

'�����l�̎擾
Set objArgs = WScript.Arguments

'(1)  ���[�U�h�c
'(2)  �c�̃R�[�h�P
'(3)  �c�̃R�[�h�Q
'(4)  ���ƕ��R�[�h
'(5)  �����R�[�h
'(6)  �J�n�����R�[�h
'(7)  �I�������R�[�h
'(8)  �_��p�^�[���R�[�h
'(9)  ��f��
'(10) �������[�h

strUserId       = objArgs(0)
strOrgCd1       = objArgs(1)
strOrgCd2       = objArgs(2)
strOrgBsdCd     = objArgs(3)
strOrgRoomCd    = objArgs(4)
strStrOrgPostCd = objArgs(5)
strEndOrgPostCd = objArgs(6)
lngCtrPtCd      = CLng(objArgs(7))
dtmCslDate      = CDate(objArgs(8))
lngOpMode       = CLng(objArgs(9))

'�ꊇ�\�񏈗�
Set objConsult = CreateObject("HainsCooperation.ConsultAll")
Ret = objConsult.InsertConsultFromPerson(strUserId, strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strStrOrgPostCd, strEndOrgPostCd, lngCtrPtCd, dtmCslDate, lngOpMode)
