VERSION 5.00
Begin VB.Form frmNutriFoodEnergy 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�H�i�Q�ʐێ�e�[�u�������e�i���X"
   ClientHeight    =   3765
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   3615
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmNutriFoodEnergy.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3765
   ScaleWidth      =   3615
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Index           =   6
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   15
      Text            =   "9999"
      Top             =   2640
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Index           =   5
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   13
      Text            =   "9999"
      Top             =   2280
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Index           =   4
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   11
      Text            =   "9999"
      Top             =   1920
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Index           =   3
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   9
      Text            =   "9999"
      Top             =   1560
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Index           =   2
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   7
      Text            =   "9999"
      Top             =   1200
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Index           =   1
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   5
      Text            =   "9999"
      Top             =   840
      Width           =   615
   End
   Begin VB.TextBox txtFoodGrp 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Index           =   0
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   3
      Text            =   "9999"
      Top             =   480
      Width           =   615
   End
   Begin VB.TextBox txtEnergy 
      Height          =   300
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   1
      Text            =   "9999"
      Top             =   120
      Width           =   615
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   480
      TabIndex        =   16
      Top             =   3180
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   1920
      TabIndex        =   17
      Top             =   3180
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�H�i�Q�V(&7)�F"
      Height          =   180
      Index           =   7
      Left            =   420
      TabIndex        =   14
      Top             =   2700
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�H�i�Q�U(&6)�F"
      Height          =   180
      Index           =   6
      Left            =   420
      TabIndex        =   12
      Top             =   2340
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�H�i�Q�T(&5)�F"
      Height          =   180
      Index           =   5
      Left            =   420
      TabIndex        =   10
      Top             =   1980
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�H�i�Q�S(&4)�F"
      Height          =   180
      Index           =   4
      Left            =   420
      TabIndex        =   8
      Top             =   1620
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�H�i�Q�R(&3)�F"
      Height          =   180
      Index           =   3
      Left            =   420
      TabIndex        =   6
      Top             =   1245
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�H�i�Q�Q(&2)�F"
      Height          =   180
      Index           =   2
      Left            =   420
      TabIndex        =   4
      Top             =   885
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�H�i�Q�P(&1)�F"
      Height          =   180
      Index           =   1
      Left            =   420
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�G�l���M�[(&C)�F"
      Height          =   180
      Index           =   0
      Left            =   420
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmNutriFoodEnergy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrEnergy      As String   '�G�l���M�[
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let Energy(ByVal vntNewValue As Variant)

    mstrEnergy = vntNewValue
    
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
    Dim i   As Long
    
    Ret = False
    
    Do
        
        '�R�[�h�̓��̓`�F�b�N
        If Trim(txtEnergy.Text) = "" Then
            MsgBox "�G�l���M�[�����͂���Ă��܂���B", vbCritical, App.Title
            txtEnergy.SetFocus
            Exit Do
        End If

        For i = 0 To 6
            If (Trim(txtFoodGrp(i)) = "") Or (IsNumeric(txtFoodGrp(i)) = False) Then
                MsgBox "�H�i�Q" & (i) & "�̃G�l���M�[���������ݒ肳��Ă��܂���B", vbCritical, App.Title
                txtFoodGrp(i).SetFocus
                Exit Do
            End If
        
        Next i

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
Private Function EditNutriFoodEnergy() As Boolean

    Dim objNutriFoodEnergy  As Object           '�H�i�Q�ʐێ�e�[�u���A�N�Z�X�p
    Dim vntFoodGrp1         As Variant          '�H�i�Q�P
    Dim vntFoodGrp2         As Variant          '�H�i�Q�Q
    Dim vntFoodGrp3         As Variant          '�H�i�Q�Q
    Dim vntFoodGrp4         As Variant          '�H�i�Q�Q
    Dim vntFoodGrp5         As Variant          '�H�i�Q�Q
    Dim vntFoodGrp6         As Variant          '�H�i�Q�Q
    Dim vntFoodGrp7         As Variant          '�H�i�Q�Q
    Dim Ret                 As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objNutriFoodEnergy = CreateObject("HainsNourishment.Nourishment")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrEnergy = "" Then
            Ret = True
            Exit Do
        End If
        
        '�H�i�Q�ʐێ�e�[�u�����R�[�h�ǂݍ���
        If objNutriFoodEnergy.SelectNutriFoodEnergy(mstrEnergy, , vntFoodGrp1, vntFoodGrp2, vntFoodGrp3, vntFoodGrp4, vntFoodGrp5, vntFoodGrp6, vntFoodGrp7) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtEnergy.Text = mstrEnergy
        txtFoodGrp(0).Text = vntFoodGrp1(0)
        txtFoodGrp(1).Text = vntFoodGrp2(0)
        txtFoodGrp(2).Text = vntFoodGrp3(0)
        txtFoodGrp(3).Text = vntFoodGrp4(0)
        txtFoodGrp(4).Text = vntFoodGrp5(0)
        txtFoodGrp(5).Text = vntFoodGrp6(0)
        txtFoodGrp(6).Text = vntFoodGrp7(0)
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditNutriFoodEnergy = Ret
    
    Exit Function

ErrorHandle:

    EditNutriFoodEnergy = False
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
Private Function RegistNutriFoodEnergy() As Boolean

On Error GoTo ErrorHandle

    Dim objNutriFoodEnergy      As Object       '�H�i�Q�ʐێ�A�N�Z�X�p
    Dim Ret                     As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objNutriFoodEnergy = CreateObject("HainsNourishment.Nourishment")
    
    '�H�i�Q�ʐێ�e�[�u�����R�[�h�̓o�^
    Ret = objNutriFoodEnergy.RegistNutriFoodEnergy(IIf(txtEnergy.Enabled, "INS", "UPD"), _
                                                   Trim(txtEnergy.Text), _
                                                   Trim(txtFoodGrp(0).Text), _
                                                   Trim(txtFoodGrp(1).Text), _
                                                   Trim(txtFoodGrp(2).Text), _
                                                   Trim(txtFoodGrp(3).Text), _
                                                   Trim(txtFoodGrp(4).Text), _
                                                   Trim(txtFoodGrp(5).Text), _
                                                   Trim(txtFoodGrp(6).Text))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�G�l���M�[�f�[�^�͊��ɑ��݂��܂��B", vbExclamation
        RegistNutriFoodEnergy = False
        Exit Function
    End If
    
    RegistNutriFoodEnergy = True
    
    Exit Function
    
ErrorHandle:

    RegistNutriFoodEnergy = False
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
        
        '�H�i�Q�ʐێ�e�[�u���̓o�^
        If RegistNutriFoodEnergy() = False Then
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

    Do
        '�H�i�Q�ʐێ���̕ҏW
        If EditNutriFoodEnergy() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtEnergy.Enabled = (txtEnergy.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

