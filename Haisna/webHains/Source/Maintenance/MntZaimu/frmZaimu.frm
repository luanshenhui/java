VERSION 5.00
Begin VB.Form frmZaimu 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�����K�p�R�[�h�e�[�u�������e�i���X"
   ClientHeight    =   2700
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6945
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmZaimu.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2700
   ScaleWidth      =   6945
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CheckBox chkDisabled 
      Caption         =   "���̃R�[�h���l�����������ɕ\�����Ȃ�(&D)"
      Height          =   255
      Left            =   1740
      TabIndex        =   10
      Top             =   1680
      Width           =   4395
   End
   Begin VB.ComboBox cboZaimuClass 
      Height          =   300
      Left            =   1680
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   3
      Top             =   540
      Width           =   3375
   End
   Begin VB.ComboBox cboZaimuDiv 
      Height          =   300
      Left            =   1680
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   7
      Top             =   1260
      Width           =   3375
   End
   Begin VB.TextBox txtZaimuName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   60
      TabIndex        =   5
      Text            =   "������������������������������"
      Top             =   900
      Width           =   5115
   End
   Begin VB.TextBox txtZaimuCd 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   1680
      MaxLength       =   5
      TabIndex        =   1
      Text            =   "@@@@@"
      Top             =   180
      Width           =   675
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4020
      TabIndex        =   8
      Top             =   2220
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5460
      TabIndex        =   9
      Top             =   2220
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "��������(&B):"
      Height          =   180
      Index           =   3
      Left            =   180
      TabIndex        =   2
      Top             =   600
      Width           =   1110
   End
   Begin VB.Label Label1 
      Caption         =   "�������(&S):"
      Height          =   180
      Index           =   2
      Left            =   180
      TabIndex        =   6
      Top             =   1320
      Width           =   1170
   End
   Begin VB.Label Label1 
      Caption         =   "�����K�p��(&N):"
      Height          =   180
      Index           =   1
      Left            =   180
      TabIndex        =   4
      Top             =   960
      Width           =   1350
   End
   Begin VB.Label Label1 
      Caption         =   "�����K�p�R�[�h(&C):"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   240
      Width           =   1530
   End
End
Attribute VB_Name = "frmZaimu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrZaimuCd     As String   '�����R�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let ZaimuCd(ByVal vntNewValue As Variant)

    mstrZaimuCd = vntNewValue
    
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
        If Trim(txtZaimuCd.Text) = "" Then
            MsgBox "�����R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtZaimuCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtZaimuName.Text) = "" Then
            MsgBox "�����K�p�������͂���Ă��܂���B", vbCritical, App.Title
            txtZaimuName.SetFocus
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
Private Function EditZaimu() As Boolean

    Dim objZaimu        As Object           '�����A�N�Z�X�p
    Dim vntZaimuName    As Variant          '������
    Dim vntZaimuDiv     As Variant          '�������
    Dim vntZaimuClass   As Variant          '��������
    Dim vntDisabled     As Variant          '���g�p�t���O
    Dim Ret             As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrZaimuCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�����e�[�u�����R�[�h�ǂݍ���
        If objZaimu.SelectZaimu(mstrZaimuCd, vntZaimuName, vntZaimuDiv, vntZaimuClass, vntDisabled) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtZaimuCd.Text = mstrZaimuCd
        txtZaimuName.Text = vntZaimuName
        cboZaimuDiv.ListIndex = CInt(vntZaimuDiv) - 1
        cboZaimuClass.ListIndex = CInt(vntZaimuClass) - 1
        chkDisabled.Value = IIf(vntDisabled = "1", vbChecked, vbUnchecked)
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditZaimu = Ret
    
    Exit Function

ErrorHandle:

    EditZaimu = False
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
Private Function RegistZaimu() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu    As Object       '�����A�N�Z�X�p
    Dim Ret         As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    '�����e�[�u�����R�[�h�̓o�^
    Ret = objZaimu.RegistZaimu(IIf(txtZaimuCd.Enabled, "INS", "UPD"), _
                                     Trim(txtZaimuCd.Text), _
                                     Trim(txtZaimuName.Text), _
                                     cboZaimuDiv.ListIndex + 1, _
                                     cboZaimuClass.ListIndex + 1, _
                                     IIf(chkDisabled.Value = vbChecked, "1", "0"))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�����K�p�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistZaimu = False
        Exit Function
    End If
    
    RegistZaimu = True
    
    Exit Function
    
ErrorHandle:

    RegistZaimu = False
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
        
        '�����e�[�u���̓o�^
        If RegistZaimu() = False Then
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
    
    With cboZaimuClass
        .Clear
        .AddItem "�l"
        .AddItem "�c��"
        .AddItem "�d�b����"
        .AddItem "�����쐬"
        .AddItem "���̑�����"
        .ListIndex = 0
    End With

    With cboZaimuDiv
        .Clear
        .AddItem "����"
        .AddItem "����"
        .AddItem "�ߋ�������"
        .AddItem "�ҕt"
        .AddItem "�ҕt����"
        .ListIndex = 0
    End With

    Do
        '�������̕ҏW
        If EditZaimu() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtZaimuCd.Enabled = (txtZaimuCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

