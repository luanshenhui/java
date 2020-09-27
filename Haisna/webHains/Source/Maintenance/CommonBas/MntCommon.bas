Attribute VB_Name = "MntCommon"
Option Explicit


' @(e)
'
' �@�\�@�@ : �t�H�[���R���g���[���̏�����
'
' �����@�@ : (In)      TargetForm  �R���g���[��������������Form
'
' �@�\���� : �t�H�[����̃R���g���[��������������
'
' ���l�@�@ :
'
Public Sub InitFormControls(TargetForm As Form, colGotFocusCollection As Collection)

    Dim Ctrl            As Object
    Dim i               As Integer
    Dim objTxtGotFocus  As TextGotFocus
    
    If TargetForm Is Nothing Then Exit Sub
    
    Set colGotFocusCollection = New Collection
    
    ''�e�R���g���[���̐ݒ�l���N���A����
    For Each Ctrl In TargetForm.Controls
        
        '''�e�L�X�g�{�b�N�X
        If TypeOf Ctrl Is TextBox Then
            Ctrl.Text = Empty
            Ctrl.ToolTipText = Empty
            Ctrl.BackColor = vbWindowBackground
        
            Set objTxtGotFocus = New TextGotFocus
            objTxtGotFocus.TargetTextBox = Ctrl
            colGotFocusCollection.Add objTxtGotFocus
        End If
        
        '''�R���{�{�b�N�X
        If TypeOf Ctrl Is ComboBox Then
            Ctrl.Clear
            Ctrl.ToolTipText = Empty
        End If
        
        '''���x���i���ڕ\���p�̂݁j
        If TypeOf Ctrl Is Label Then
            If Left(Ctrl.Name, 3) = "lbl" Then
                Ctrl.Caption = Empty
            End If
        End If
        
        '''�`�F�b�N�{�b�N�X
        If TypeOf Ctrl Is CheckBox Then
            Ctrl.Value = vbUnchecked
        End If
    Next

End Sub
' @(e)
'
' �@�\�@�@ : �R�[�h�̕���
'
' �����@�@ : (In)   strTargetKey    �n�C�t���t���̍��ڃR�[�h
' �@�@�@�@ : (Out)  strItem1        �������ڃR�[�h
' �@�@�@�@ : (Out)  strItem2        �T�t�B�b�N�X
' �@�@�@�@ : (In)   intStartPoint   �����J�n�ʒu�i�ȗ��j
'
' �@�\���� : ���X�g�r���[�̈�ӃL�[�ׂ̈ɃZ�b�g�����n�C�t���t���̃R�[�h�𕪊�����
'
' ���l�@�@ :
'
Public Sub SplitItemAndSuffix(strTargetKey As String, _
                              strItem1 As String, _
                              strItem2 As String, _
                              Optional intStartPoint As Integer)

    Dim lngPointer  As Long     '�n�C�t���ʒu���o�p�|�C���^�[
        
    '������
    strTargetKey = Trim(strTargetKey)
    strItem1 = ""
    strItem2 = ""
        
    '�L�[���w�肳��Ă��Ȃ��Ȃ珈���I��
    If strTargetKey = "" Then Exit Sub
    
    '�J�n�ʒu���w�肳��Ă��Ȃ��Ȃ�P�Z�b�g
    If intStartPoint = 0 Then
        intStartPoint = 1
    End If
    
    '����
    lngPointer = InStr(intStartPoint, strTargetKey, "-")
    If lngPointer <> 0 Then
        strItem1 = Mid(strTargetKey, 1, lngPointer - 1)
        strItem2 = Mid(strTargetKey, lngPointer + 1, Len(strTargetKey))
    End If

End Sub

' @(e)
'
' �@�\�@�@ : ���ڂ̑��݃`�F�b�N
'
' �����@�@ : (In)      TargetListView  �`�F�b�N���郊�X�g�r���[
' �@�@�@�@ : (In)      strKey          (���X�g�A�C�e����)�A�C�e���L�[
'
' �߂�l�@ : TRUE:���݂��܂��AFALSE:���݂��܂���
'
' �@�\���� : �w�肳�ꂽ�L�[�����X�g�A�C�e����ɑ��݂��邩�`�F�b�N����B
'
' ���l�@�@ :
'
Public Function CheckExistsItemCd(TargetListView As Object, strKey As String) As Boolean

On Error GoTo ErrorHandle
    
'    Dim objTestItems    As ListItem
    Dim objTestItems    As Object

    CheckExistsItemCd = False
    
    '�w�肳�ꂽ�L�[�l�ŃI�u�W�F�N�g�쐬�i�Ȃ����Error Raise)
    Set objTestItems = TargetListView.ListItems(strKey)
    
    CheckExistsItemCd = True
    Exit Function
    
ErrorHandle:
    CheckExistsItemCd = False
    
End Function

' @(e)
'
' �@�\�@�@ : �����p������R���{�̏�����
'
' �����@�@ : (In)      objTargetCombo  �Z�b�g����R���{�{�b�N�X
'
' �@�\���� : �����̃R���{�{�b�N�X�ɏ�����Ԃ̕�������Z�b�g
'
' ���l�@�@ :
'
Public Sub InitSearchCharCombo(objTargetCombo As ComboBox)
    
    Dim i As Integer
    
    With objTargetCombo
        
        '�p�����Z�b�g
        For i = 65 To 90
            .AddItem Chr(i)
        Next i
        
        '���ȃZ�b�g
        .AddItem "��"
        .AddItem "��"
        .AddItem "��"
        .AddItem "��"
        .AddItem "��"
        .AddItem "��"
        .AddItem "��"
        .AddItem "��"
        .AddItem "��"
        .AddItem "��"
    
        '���l�Z�b�g
        For i = 0 To 10
            .AddItem i
        Next i
        
        .AddItem "���̑�"
        .ListIndex = objTargetCombo.NewIndex
    
    End With

End Sub

