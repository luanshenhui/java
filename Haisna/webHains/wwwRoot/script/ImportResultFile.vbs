Option Explicit

Dim objResponse		'���ʎ�荞�ݏ����p
Dim Ret				'�֐��߂�l

'���ʎ�荞�ݏ���
Set objResponse = CreateObject("HainsCooperation.Response")
Ret = objResponse.ImportFile()
