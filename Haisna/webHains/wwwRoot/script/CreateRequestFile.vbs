Option Explicit

Dim objWshShell		'WshShell�I�u�W�F�N�g
Dim objArgs			'WshArguments�I�u�W�F�N�g
Dim objRequest		'�����˗������p

Dim dtmCslDate		'��f��
Dim strPerId		'�l�h�c
Dim blnIncSentData	'���M�ς݃f�[�^��ΏۂƂ��邩

Dim Ret				'�֐��߂�l

'�����l�̎擾
Set objArgs = WScript.Arguments

'(1) ��f��
'(2) �l�h�c
'(3) ���M�ς݃f�[�^��ΏۂƂ��邩

dtmCslDate     = CDate(objArgs(0))
strPerId       = objArgs(1)
blnIncSentData = CBool(objArgs(2))

'�����˗�����
Set objRequest = CreateObject("HainsCooperation.Request")
Ret = objRequest.CreateFile(dtmCslDate, strPerId, blnIncSentData)
