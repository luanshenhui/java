VERSION 5.00
Begin VB.Form frmNutriCompFood 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�\���H�i�e�[�u�������e�i���X"
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6480
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmNutriCompFood.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2265
   ScaleWidth      =   6480
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboFoodClassCd 
      Height          =   300
      Left            =   2100
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   5
      Top             =   900
      Width           =   3315
   End
   Begin VB.TextBox txtComposeFoodName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   2100
      MaxLength       =   100
      TabIndex        =   3
      Text            =   "��������������������"
      Top             =   540
      Width           =   4215
   End
   Begin VB.TextBox txtComposeFoodCd 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   2100
      MaxLength       =   5
      TabIndex        =   1
      Text            =   "99999"
      Top             =   180
      Width           =   855
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3540
      TabIndex        =   6
      Top             =   1800
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4980
      TabIndex        =   7
      Top             =   1800
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�H�i����(&B)�F"
      Height          =   180
      Index           =   2
      Left            =   300
      TabIndex        =   4
      Top             =   960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�\���H�i��(&N)�F"
      Height          =   180
      Index           =   1
      Left            =   300
      TabIndex        =   2
      Top             =   600
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�\���H�i�R�[�h(&C)�F"
      Height          =   180
      Index           =   0
      Left            =   300
      TabIndex        =   0
      Top             =   240
      Width           =   1650
   End
End
Attribute VB_Name = "frmNutriCompFood"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrComposeFoodCd  As String   '�\���H�i�R�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let ComposeFoodCd(ByVal vntNewValue As Variant)

    mstrComposeFoodCd = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
Friend Property Get Initialize() As Boolean

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

    Dim Ret As Boolean  '�֐��߂�l
    
    Ret = False
    
    Do
        '�R�[�h�̓��̓`�F�b�N
        If Trim(txtComposeFoodCd.Text) = "" Then
            MsgBox "�\���H�i�R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtComposeFoodCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtComposeFoodName.Text) = "" Then
            MsgBox "�\���H�i�������͂���Ă��܂���B", vbCritical, App.Title
            txtComposeFoodName.SetFocus
            Exit Do
        End If
        
        '���̂̓��̓`�F�b�N
        If LenB(Trim(txtComposeFoodName.Text)) > 50 Then
            MsgBox "�\���H�i�����������܂�", vbCritical, App.Title
            txtComposeFoodName.SetFocus
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
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
Private Function EditNutriCompFood() As Boolean

    Dim objNutriCompFood        As Object         '�\���H�i�A�N�Z�X�p
    Dim vntComposeFoodName      As Variant        '�\���H�i��
    Dim vntFoodClassCd          As Variant        '�\���H�i����
    Dim Ret                     As Boolean        '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objNutriCompFood = CreateObject("HainsNourishment.Nourishment")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrComposeFoodCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�\���H�i�e�[�u�����R�[�h�ǂݍ���
        If objNutriCompFood.SelectNutriCompFood(mstrComposeFoodCd, , vntComposeFoodName, vntFoodClassCd) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtComposeFoodCd.Text = mstrComposeFoodCd
        txtComposeFoodName.Text = vntComposeFoodName(0)
        cboFoodClassCd.ListIndex = CInt(vntFoodClassCd(0)) - 1
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditNutriCompFood = Ret
    
    Exit Function

ErrorHandle:

    EditNutriCompFood = False
    MsgBox Err.Description, vbCritical
    
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
Private Function RegistNutriCompFood() As Boolean

On Error GoTo ErrorHandle

    Dim objNutriCompFood     As Object       '�\���H�i�A�N�Z�X�p
    Dim Ret                  As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objNutriCompFood = CreateObject("HainsNourishment.Nourishment")
    
    '�\���H�i�e�[�u�����R�[�h�̓o�^
    Ret = objNutriCompFood.RegistNutriCompFood(IIf(txtComposeFoodCd.Enabled, "INS", "UPD"), _
                                     Trim(txtComposeFoodCd.Text), _
                                     Trim(txtComposeFoodName.Text), _
                                     cboFoodClassCd.ListIndex + 1)

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�\���H�i�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistNutriCompFood = False
        Exit Function
    End If
    
    RegistNutriCompFood = True
    
    Set objNutriCompFood = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNutriCompFood = Nothing
    
    RegistNutriCompFood = False
    
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
        
        '�\���H�i�e�[�u���̓o�^
        If RegistNutriCompFood() = False Then
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
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    With cboFoodClassCd
        .Clear
        .AddItem "1�F���ނ���ш��"
        .AddItem "2�F�ʕ�"
        .AddItem "3�F����E���E���E�哤���i"
        .AddItem "4�F�����i"
        .AddItem "5�F�����E�������H�i"
        .AddItem "6�F���"
        .AddItem "7�F�n�D�i�i�َq�ށj"
        .AddItem "8�F���̑�"
        .AddItem "9�F�n�D�i�i�A���R�[���j"
    End With

    Do
        '�\���H�i���̕ҏW
        If EditNutriCompFood() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtComposeFoodCd.Enabled = (txtComposeFoodCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

