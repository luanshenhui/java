Attribute VB_Name = "Item_cBas"
Option Explicit


'
' �@�\�@�@ : �����p���ڃR�[�h�̑��݃`�F�b�N
'
' �����@�@ : (In)   strItemCd       �������ڃR�[�h
' �@�@�@�@ : (In)   strSuffix       �T�t�B�b�N�X
' �@�@�@�@ : (In)   strInsItemCd    �����A�g�p���ڃR�[�h
' �@�@�@�@ : (In)   vntSepOrderDiv  �I�[�_�����敪
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Public Function GetInsItemInfo(strItemCd As String, _
                               strSuffix As String, _
                               strInsItemCd As String, _
                               Optional vntSepOrderDiv As Variant _
                               ) As Boolean

    Dim objItem         As Object           '�������ڃA�N�Z�X�p
    
    Dim strMsg          As String
    Dim vntItemCd       As Variant          '�������ږ�
    Dim vntSuffix       As Variant          '�������ږ�
    Dim vntItemName     As Variant          '�������ږ�
    Dim lngCount        As Long             '���݌���
    
    On Error GoTo ErrorHandle
    
    GetInsItemInfo = False
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem = CreateObject("HainsItem.Item")
    
    '�����p���ڃR�[�h���w�肳��Ă��Ȃ��Ȃ琳��I��
    If Trim(strInsItemCd) = "" Then
        GetInsItemInfo = True
        Exit Function
    End If
        
    '�������ڃe�[�u�����R�[�h�ǂݍ���
'### 2004/1/15 Modified by Ishihara@FSIT ���H���ł�vntSepOrderDiv�͂Ȃ����߁A�s�v�B
'    If IsMissing(vntSepOrderDiv) Then
'
'        lngCount = objItem.SelectInsItemInfo(strItemCd, _
'                                             strSuffix, _
'                                             strInsItemCd, _
'                                             vntItemCd, _
'                                             vntSuffix, _
'                                             vntItemName)
'
'    Else
'
'        lngCount = objItem.SelectInsItemInfo(strItemCd, _
'                                             strSuffix, _
'                                             strInsItemCd, _
'                                             vntItemCd, _
'                                             vntSuffix, _
'                                             vntItemName, _
'                                             vntSepOrderDiv)
'
'    End If
    lngCount = 0
'### 2004/1/15 Modified End
            
    '���R�[�h�����݂���Ȃ�
    If lngCount >= 1 Then
        strMsg = "���͂��ꂽ�������ڃR�[�h�͊��Ɏg�p����Ă��܂��B" & vbLf & vbLf & _
                "�i" & vntItemCd & "-" & vntSuffix & ":" & vntItemName & "�@�ɂĎg�p���j"
                
        MsgBox strMsg, vbExclamation, App.Title
        Exit Function
                
    End If
    
    If lngCount < 0 Then Exit Function
    
    '�߂�l�̐ݒ�
    GetInsItemInfo = True
    
    Exit Function

ErrorHandle:

    GetInsItemInfo = False
    
    MsgBox Err.Description, vbCritical
    
End Function


