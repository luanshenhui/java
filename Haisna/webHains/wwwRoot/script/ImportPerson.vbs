Option Explicit

Dim objWshShell		'WshShell�I�u�W�F�N�g
Dim objArgs			'WshArguments�I�u�W�F�N�g
Dim objImport		'�ꊇ�\�񏈗��p
Dim objFso			'�t�@�C���V�X�e���I�u�W�F�N�g

Dim strFileName		'��荞�݃t�@�C����
Dim strOrgCd1		'�c�̃R�[�h�P
Dim strOrgCd2		'�c�̃R�[�h�Q
Dim strUserId		'���[�U�h�c
Dim lngCtrPtCd		'�_��p�^�[���R�[�h

'�����l�̎擾
Set objArgs = WScript.Arguments

'(1) ��荞�݃t�@�C����
'(2) �c�̃R�[�h�P
'(3) �c�̃R�[�h�Q
'(4) ���[�U�h�c
'(5) �_��p�^�[���R�[�h

strFileName = objArgs(0)
strOrgCd1   = objArgs(1)
strOrgCd2   = objArgs(2)
strUserId   = objArgs(3)
lngCtrPtCd  = CLng(objArgs(4))

'�ꊇ�\�񏈗�
Set objImport = CreateObject("HainsCooperation.ImportPerson")
objImport.ImportPerson strFileName, strOrgCd1, strOrgCd2, strUserId, lngCtrPtCd, , , , False

'�t�@�C���̍폜
Set objFso = CreateObject("Scripting.FileSystemObject")
objFso.DeleteFile(strFileName)
