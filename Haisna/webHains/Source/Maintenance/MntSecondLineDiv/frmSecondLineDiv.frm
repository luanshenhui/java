VERSION 5.00
Begin VB.Form frmSecondLineDiv 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�Q���������׃e�[�u�������e�i���X"
   ClientHeight    =   2910
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6900
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmSecondLineDiv.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2910
   ScaleWidth      =   6900
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.Frame Frame1 
      Caption         =   "��{���"
      Height          =   2175
      Index           =   0
      Left            =   60
      TabIndex        =   8
      Top             =   120
      Width           =   6735
      Begin VB.TextBox txtStdTax 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   2340
         MaxLength       =   7
         TabIndex        =   7
         Text            =   "9999999"
         Top             =   1440
         Width           =   855
      End
      Begin VB.TextBox txtStdPrice 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   2340
         MaxLength       =   7
         TabIndex        =   5
         Text            =   "9999999"
         Top             =   1020
         Width           =   855
      End
      Begin VB.TextBox txtSecondLineDivName 
         Height          =   300
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   2340
         MaxLength       =   40
         TabIndex        =   3
         Text            =   "������������������������������"
         Top             =   600
         Width           =   4035
      End
      Begin VB.TextBox txtSecondLineDivCd 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   2340
         MaxLength       =   5
         TabIndex        =   1
         Text            =   "@@"
         Top             =   240
         Width           =   795
      End
      Begin VB.Label Label1 
         Caption         =   "�W���Ŋz(&T):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   6
         Top             =   1500
         Width           =   1710
      End
      Begin VB.Label Label1 
         Caption         =   "�W���P��(&P):"
         Height          =   180
         Index           =   3
         Left            =   180
         TabIndex        =   4
         Top             =   1080
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "�Q���������ז�(&N):"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   2
         Top             =   660
         Width           =   1950
      End
      Begin VB.Label Label1 
         Caption         =   "�Q���������׃R�[�h(&C):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   300
         Width           =   1950
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4020
      TabIndex        =   9
      Top             =   2460
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5460
      TabIndex        =   10
      Top             =   2460
      Width           =   1335
   End
End
Attribute VB_Name = "frmSecondLineDiv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrSecondLineDivCd      As String   '�Z�b�g�O�������׃R�[�h
Private mblnInitialize          As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let SecondLineDivCd(ByVal vntNewValue As Variant)

    mstrSecondLineDivCd = vntNewValue
    
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
        If Trim(txtSecondLineDivCd.Text) = "" Then
            MsgBox "�Q���������׃R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtSecondLineDivCd.SetFocus
            Exit Do
        End If

        '�Q�������ז��̓��̓`�F�b�N
        If Trim(txtSecondLineDivName.Text) = "" Then
            MsgBox "�Q���������ז������͂���Ă��܂���B", vbCritical, App.Title
            txtSecondLineDivName.SetFocus
            Exit Do
        End If

        '���z���ҏW
        If Trim(txtStdPrice.Text) = "" Then txtStdPrice.Text = "0"
        If Trim(txtStdTax.Text) = "" Then txtStdTax.Text = "0"

        If IsNumeric(Trim(txtStdPrice.Text)) = False Then
            MsgBox "�W�����z�ɂ͐��l���Z�b�g���Ă��������B", vbCritical, App.Title
            txtStdPrice.SetFocus
            Exit Do
        End If

        If IsNumeric(Trim(txtStdTax.Text)) = False Then
            MsgBox "�W�����z�ɂ͐��l���Z�b�g���Ă��������B", vbCritical, App.Title
            txtStdTax.SetFocus
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
Private Function EditSecondLineDiv() As Boolean

    Dim objSecondLineDiv         As Object   '�Z�b�g�O�������׃A�N�Z�X�p
    Dim vntSecondLineDivName     As Variant  '�Z�b�g�O�������ז�
    Dim vntStdPrice             As Variant  '�W���P��
    Dim vntStdTax               As Variant  '�W���Ŋz
    Dim Ret                     As Boolean  '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSecondLineDiv = CreateObject("HainsSecondBill.SecondBill")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrSecondLineDivCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�Z�b�g�O�������׃e�[�u�����R�[�h�ǂݍ���
        If objSecondLineDiv.SelectSecondLineDivFromCode(mstrSecondLineDivCd, vntSecondLineDivName, vntStdPrice, vntStdTax) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtSecondLineDivCd.Text = mstrSecondLineDivCd
        txtSecondLineDivName.Text = vntSecondLineDivName
        txtStdPrice.Text = vntStdPrice
        txtStdTax.Text = vntStdTax
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditSecondLineDiv = Ret
    
    Exit Function

ErrorHandle:

    EditSecondLineDiv = False
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
Private Function RegistSecondLineDiv() As Boolean

On Error GoTo ErrorHandle

    Dim objSecondLineDiv     As Object       '�Z�b�g�O�������׃A�N�Z�X�p
    Dim Ret                 As Long
    Dim strWkStdTax         As String
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSecondLineDiv = CreateObject("HainsSecondBill.SecondBill")
    
    '�Z�b�g�O�������׃e�[�u�����R�[�h�̓o�^
    Ret = objSecondLineDiv.RegistSecondLineDiv(IIf(txtSecondLineDivCd.Enabled, "INS", "UPD"), _
                                             Trim(txtSecondLineDivCd.Text), _
                                             Trim(txtSecondLineDivName.Text), _
                                             Trim(txtStdPrice.Text), _
                                             Trim(txtStdTax.Text))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�Z�b�g�O�������׃R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistSecondLineDiv = False
        Exit Function
    End If
    
    RegistSecondLineDiv = True
    
    Exit Function
    
ErrorHandle:

    RegistSecondLineDiv = False
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
        
        '�Z�b�g�O�������׃e�[�u���̓o�^
        If RegistSecondLineDiv() = False Then
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

    Dim Ret     As Boolean  '�߂�l
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    Do
        '�Z�b�g�O�������׏��̕ҏW
        If EditSecondLineDiv() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtSecondLineDivCd.Enabled = (txtSecondLineDivCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

