Option Explicit

Dim objWshShell		'WshShell�I�u�W�F�N�g
Dim objArgs			'WshArguments�I�u�W�F�N�g
Dim objConsult		'��荞�ݏ����p

Dim strDataDiv		'��荞�݃f�[�^�敪
Dim strFileName		'��荞�݃t�@�C����
Dim strUserId		'���[�U�h�c

'�����l�̎擾
'(1) �敪("SELF":�{�l�A"FAMILY":�Ƒ�)
'(2) ��荞�݃t�@�C����
'(3) ���[�U�h�c
Set objArgs = WScript.Arguments

'�敪�̎擾(�G���[�Ȃ�ُ�I������B��Ύw�肳��Ă���O��Ń��W�b�N�\�z�B)
strDataDiv = objArgs(0)

'�t�@�C�����̎擾(�Ȃ��Ă���荞�ݏ������s���A��荞�ݎ��̃��O�Ɉς˂�B)
If objArgs.Count > 1 Then
	strFileName = objArgs(1)
End If

'���[�U�h�c�̎擾
If objArgs.Count > 2 Then
	strUserId = objArgs(2)
End If

'�f�[�^�敪���Ƃ̏����U�蕪��
Select Case UCase(strDataDiv)

	Case "SELF"		'�{�l�̏ꍇ

		'���ۖ{�l�f�[�^��荞��
		Set objConsult = CreateObject("HainsCooperation.ImportSelf")
		objConsult.ImportIsrSelf strFileName, strUserId

	Case "FAMILY"	'�Ƒ��̏ꍇ

		Set objConsult = CreateObject("HainsCooperation.ImportFamily")
		objConsult.ImportIsrFamily strFileName, strUserId

End Select
