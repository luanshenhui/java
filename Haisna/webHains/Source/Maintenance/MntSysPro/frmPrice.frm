VERSION 5.00
Begin VB.Form frmPrice 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�K�p���z�̐ݒ�"
   ClientHeight    =   1965
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5640
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmPrice.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1965
   ScaleWidth      =   5640
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmPrice.frx":000C
      Left            =   2100
      List            =   "frmPrice.frx":0013
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   8
      Top             =   780
      Width           =   555
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmPrice.frx":001B
      Left            =   1200
      List            =   "frmPrice.frx":0022
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   7
      Top             =   780
      Width           =   555
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmPrice.frx":002A
      Left            =   180
      List            =   "frmPrice.frx":0031
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   6
      Top             =   780
      Width           =   735
   End
   Begin VB.ComboBox cboPrice 
      Height          =   300
      Index           =   1
      Left            =   3480
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   5
      Top             =   780
      Width           =   1215
   End
   Begin VB.ComboBox cboPrice 
      Height          =   300
      Index           =   0
      Left            =   1260
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   4
      Top             =   240
      Width           =   1215
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2700
      TabIndex        =   2
      Top             =   1500
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4140
      TabIndex        =   3
      Top             =   1500
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "���ȍ~"
      Height          =   255
      Index           =   3
      Left            =   2700
      TabIndex        =   11
      Top             =   840
      Width           =   555
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   1
      Left            =   1800
      TabIndex        =   10
      Top             =   840
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   0
      Left            =   960
      TabIndex        =   9
      Top             =   840
      Width           =   255
   End
   Begin VB.Label Label1 
      Caption         =   "��K�p"
      Height          =   180
      Index           =   1
      Left            =   4800
      TabIndex        =   1
      Top             =   840
      Width           =   630
   End
   Begin VB.Label Label1 
      Caption         =   "��{���z(&B):"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   300
      Width           =   1110
   End
End
Attribute VB_Name = "frmPrice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnModeNew     As Boolean  'TRUE:�V�K�AFALSE:�X�V

Private mintField1      As Integer
Private mintField2      As Integer
Private mdtnFreeDate    As Date

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

'
' �@�\�@�@ : ���̓f�[�^�`�F�b�N
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����f�[�^�AFALSE:�ُ�f�[�^����
'
' ���l�@�@ :
'
Private Function CheckValue() As Boolean

    Dim Ret         As Boolean  '�֐��߂�l
    Dim blnRet      As Boolean
    
    Ret = False
    
    Do
        If cboPrice(0).ListIndex = cboPrice(1).ListIndex Then
            blnRet = MsgBox("���z�������Ƃ��������e�Őݒ肳��Ă��܂��B���̓��e�ŕۑ����܂����H", vbExclamation + vbYesNo + vbDefaultButton2, vbQuestion)
            If blnRet = vbNo Then Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

'
' �@�\�@�@ : �f�[�^�o�^
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function RegistFree() As Boolean

    Dim objFree As Object       '�ėp�e�[�u���A�N�Z�X�p
    Dim Ret     As Long
    
    On Error GoTo ErrorHandle
    
    mdtnFreeDate = CDate((cboYear.List(cboYear.ListIndex) & "/" & cboMonth.List(cboMonth.ListIndex) & "/" & cboDay.List(cboDay.ListIndex)))
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")

    '�ėp�e�[�u�����R�[�h�̓o�^
    If mblnModeNew = True Then
    
        '�V�K�o�^
        Ret = objFree.InsertFree(SYSPRO_PRICE_KEY, _
                                 SYSPRO_COMMON_CLASS, _
                                 SYSPRO_PRICE_NAME, _
                                 mdtnFreeDate, _
                                 cboPrice(0).ListIndex + 1, _
                                 cboPrice(1).ListIndex + 1)
        
    
    Else
    
        '�X�V
        Ret = objFree.UpdateFree(SYSPRO_PRICE_KEY, _
                                 SYSPRO_COMMON_CLASS, _
                                 SYSPRO_PRICE_NAME, _
                                 mdtnFreeDate, _
                                 cboPrice(0).ListIndex + 1, _
                                 cboPrice(1).ListIndex + 1)
    
        If Ret = True Then Ret = INSERT_NORMAL
        
    End If

    If Ret <> INSERT_NORMAL Then
        MsgBox "�f�[�^�X�V���ɃG���[���������܂����B", vbCritical
        RegistFree = False
        Exit Function
    End If

    '�f�[�^���݂̂��߁A�X�V���[�h
    mblnModeNew = False
    
    RegistFree = True
    
    Exit Function
    
ErrorHandle:

    RegistFree = False
    MsgBox Err.Description, vbCritical
    
End Function


'
' �@�\�@�@ : �f�[�^�\���p�ҏW
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditFree() As Boolean

    Dim objFree         As Object           '�ėp�e�[�u���A�N�Z�X�p
    
    Dim lngMode         As Long
    Dim strFreeCdKey    As String
    Dim vntFreeCd       As Variant
    Dim vntFreeName     As Variant
    Dim vntFreeDate     As Variant
    Dim vntFreeField1   As Variant
    Dim vntFreeField2   As Variant

    Dim Ret             As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")
    
    Do
        
        '����Ŋz���R�[�h�ǂݍ���
        If objFree.SelectFree(0, _
                              SYSPRO_PRICE_KEY, _
                              vntFreeCd, _
                              vntFreeName, _
                              vntFreeDate, _
                              vntFreeField1, _
                              vntFreeField2) = False Then
            
            '�f�[�^�Ȃ��ł��A��ʂ͊J��
            Ret = True
            Exit Do
        End If
    
        '�f�[�^���݂̂��߁A�X�V���[�h
        mblnModeNew = False
    
        '�ǂݍ��ݓ��e�̕ҏW
        If IsDate(vntFreeDate) Then
            mdtnFreeDate = vntFreeDate
        End If
        
        '
        If IsNumeric(vntFreeField1) Then
            If (CLng(vntFreeField1) >= 1) And (CLng(vntFreeField1) <= 2) Then
                mintField1 = CInt(vntFreeField1)
            End If
        End If

        If IsNumeric(vntFreeField2) Then
            If (CLng(vntFreeField2) >= 1) And (CLng(vntFreeField2) <= 2) Then
                mintField2 = CInt(vntFreeField2)
            End If
        End If

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditFree = Ret
    
    Exit Function

ErrorHandle:

    EditFree = False
    
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �u�L�����Z���vClick
'
' �@�\���� : �t�H�[�������
'
' ���l�@�@ :
'
Private Sub CMDcancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : �u�n�j�v�N���b�N
'
' �����@�@ : �Ȃ�
'
' �@�\���� : ���͓��e��K�p���A��ʂ����
'
' ���l�@�@ :
'
Private Sub CMDok_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    Do
        '���̓`�F�b�N
        If CheckValue() = False Then
            Exit Do
        End If
        
        '�f�[�^�̓o�^
        If RegistFree() = False Then
            Exit Do
        End If
            
        '�X�V�ς݃t���O��TRUE��
        mblnUpdated = True
    
        '��ʂ����
        Unload Me
        
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' �@�\�@�@ : �u�t�H�[���vLoad
'
' �@�\���� : �t�H�[���̏����\�����s��
'
' ���l�@�@ :
'
Private Sub Form_Load()

    Dim Ret As Boolean  '�߂�l
    Dim i   As Integer
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    mblnModeNew = True

    mdtnFreeDate = Now
    mintField1 = 1
    mintField2 = 2
    
    Do
        '�ėp�e�[�u������̃f�[�^�ҏW
        If EditFree() = False Then
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '���z�R���{�N���A
    For i = 0 To 1
        With cboPrice(i)
            .Clear
            .AddItem "���z�P"
            .AddItem "���z�Q"
        End With
    Next i
    
    cboPrice(0).ListIndex = mintField1 - 1
    cboPrice(1).ListIndex = mintField2 - 1
    
    
    '�R���{�{�b�N�X�ɒl���Z�b�g
    With cboYear
        .Clear
        For i = YEARRANGE_MIN To YEARRANGE_MAX
            .AddItem i
            If (i = Year(mdtnFreeDate)) And _
               (YEARRANGE_MIN <= Year(mdtnFreeDate)) And _
               (YEARRANGE_MAX >= Year(mdtnFreeDate)) Then
                .ListIndex = i - YEARRANGE_MIN
            End If
        Next i
    End With
    
    With cboMonth
        .Clear
        For i = 1 To 12
            .AddItem i
            If i = Month(mdtnFreeDate) Then
                .ListIndex = i - 1
            End If
        Next i
    End With
    
    With cboDay
        .Clear
        For i = 1 To 31
            .AddItem i
            If i = Day(mdtnFreeDate) Then
                .ListIndex = i - 1
            End If
        Next i
    End With
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub
