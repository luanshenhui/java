Option Explicit

Dim objWshShell		'WshShell�I�u�W�F�N�g
Dim objArgs			'WshArguments�I�u�W�F�N�g
Dim objScreening	'�X�N���[�j���O�p

Dim strStrCslDate	'�J�n��f�N����
Dim strEndCslDate	'�I����f�N����
Dim strStrDayId		'�J�n����ID
Dim strEndDayId		'�I������ID
Dim strCsCd			'�R�[�X�R�[�h
Dim strJudClassCd	'���蕪�ރR�[�h
Dim strPerId		'�l�h�c
Dim lngReJudge		'�Ĕ���(0:���Ȃ��A1:����)
Dim lngEntryCheck	'�����̓`�F�b�N(0:���Ȃ��A1:����)

Dim Ret				'�֐��߂�l

'�����l�̎擾
Set objArgs = WScript.Arguments

'(1) �J�n��f�N����
'(2) �I����f�N����
'(3) �J�n����ID
'(4) �I������ID
'(5) �R�[�X�R�[�h
'(6) ���蕪�ރR�[�h
'(7) �l�h�c
'(8) �����̓`�F�b�N
'(9) �Ĕ���

strStrCslDate = objArgs(0)
strEndCslDate = objArgs(1)
strStrDayId   = objArgs(2)
strEndDayId   = objArgs(3)
strCsCd       = objArgs(4)
strJudClassCd = objArgs(5)
strPerId      = objArgs(6)
lngReJudge    = CLng(objArgs(7))
lngEntryCheck = CLng(objArgs(8))

'�X�N���[�j���O
Set objScreening = CreateObject("HainsJudgement.Screening")
Ret = objScreening.Screening(strStrCslDate, strEndCslDate, strStrDayId, strEndDayId, strCsCd, strJudClassCd, strPerId, lngReJudge, lngEntryCheck)
