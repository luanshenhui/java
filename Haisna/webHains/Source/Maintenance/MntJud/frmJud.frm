VERSION 5.00
Begin VB.Form frmJud 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "����e�[�u�������e�i���X"
   ClientHeight    =   4305
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7170
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmJud.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4305
   ScaleWidth      =   7170
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.Frame Frame1 
      Caption         =   "���{�Ǐ�"
      Height          =   1275
      Index           =   1
      Left            =   120
      TabIndex        =   15
      Top             =   2400
      Visible         =   0   'False
      Width           =   6915
      Begin VB.TextBox txtGovMngJudName 
         Height          =   300
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   1860
         MaxLength       =   30
         TabIndex        =   11
         Text            =   "��������"
         Top             =   660
         Width           =   4875
      End
      Begin VB.TextBox txtGovMngjud 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   1860
         MaxLength       =   2
         TabIndex        =   9
         Text            =   "@@"
         Top             =   300
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "���{�Ǐ��p��(&K)"
         Height          =   180
         Index           =   5
         Left            =   180
         TabIndex        =   10
         Top             =   720
         Width           =   1590
      End
      Begin VB.Label Label1 
         Caption         =   "���{�Ǐ��p�R�[�h(&G)"
         Height          =   180
         Index           =   4
         Left            =   180
         TabIndex        =   8
         Top             =   360
         Width           =   1770
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "��{���"
      Height          =   2115
      Index           =   0
      Left            =   120
      TabIndex        =   14
      Top             =   180
      Width           =   6915
      Begin VB.TextBox txtWeight 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   1860
         MaxLength       =   2
         TabIndex        =   7
         Text            =   "@@"
         Top             =   1380
         Width           =   375
      End
      Begin VB.TextBox txtJudRName 
         Height          =   300
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   1860
         MaxLength       =   30
         TabIndex        =   5
         Text            =   "��������"
         Top             =   960
         Width           =   4875
      End
      Begin VB.TextBox txtJudCd 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   1860
         MaxLength       =   2
         TabIndex        =   1
         Text            =   "@@"
         Top             =   240
         Width           =   375
      End
      Begin VB.TextBox txtJudSName 
         Height          =   300
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   1860
         MaxLength       =   6
         TabIndex        =   3
         Text            =   "��������"
         Top             =   600
         Width           =   1215
      End
      Begin VB.Label Label2 
         Caption         =   "���ݒ肵���������傫�����A�ُ픻��̓x�����������Ȃ�܂��B"
         Height          =   255
         Left            =   1860
         TabIndex        =   16
         Top             =   1740
         Width           =   4635
      End
      Begin VB.Label Label1 
         Caption         =   "����p�d��(&W)"
         Height          =   180
         Index           =   3
         Left            =   180
         TabIndex        =   6
         Top             =   1440
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "�񍐏��p���薼(&R)"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   4
         Top             =   1020
         Width           =   1590
      End
      Begin VB.Label Label1 
         Caption         =   "����R�[�h(&C)"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   300
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "���藪��(&N)"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   2
         Top             =   660
         Width           =   1410
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4260
      TabIndex        =   12
      Top             =   3840
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5700
      TabIndex        =   13
      Top             =   3840
      Width           =   1335
   End
End
Attribute VB_Name = "frmJud"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrJudCd       As String   '����R�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let JudCd(ByVal vntNewValue As Variant)

    mstrJudCd = vntNewValue
    
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
        If Trim(txtJudCd.Text) = "" Then
            MsgBox "����R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtJudCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtJudSName.Text) = "" Then
            MsgBox "���藪�̂����͂���Ă��܂���B", vbCritical, App.Title
            txtJudSName.SetFocus
            Exit Do
        End If

        '�񍐏��p���薼�̓��̓`�F�b�N
        If Trim(txtJudRName.Text) = "" Then
            MsgBox "�񍐏��p���薼�����͂���Ă��܂���B", vbCritical, App.Title
            txtJudRName.SetFocus
            Exit Do
        End If

        '�d�݂̓��̓`�F�b�N
        If Trim(txtWeight.Text) = "" Then
            MsgBox "����p�d�݂����͂���Ă��܂���B", vbCritical, App.Title
            txtWeight.SetFocus
            Exit Do
        End If
        
        '�d�݂̓��̓`�F�b�N
        If IsNumeric(Trim(txtWeight.Text)) = False Then
            MsgBox "����p�d�݂ɂ͐��l����͂��Ă��������B", vbCritical, App.Title
            txtWeight.SetFocus
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
Private Function EditJud() As Boolean

    Dim objJud              As Object   '����A�N�Z�X�p
    Dim vntJudSName         As Variant  '���藪��
    Dim vntJudRName         As Variant  '�񍐏��p���薼
    Dim vntWeight           As Variant  '����p�d��
    Dim vntGovMngJud        As Variant  '���{�Ǐ��p�R�[�h
    Dim vntGovMngJudName    As Variant  '���{�Ǐ��p����
    Dim Ret                 As Boolean  '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJud = CreateObject("HainsJud.Jud")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrJudCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '����e�[�u�����R�[�h�ǂݍ���
        If objJud.SelectJud(mstrJudCd, vntJudSName, vntJudRName, vntWeight, vntGovMngJud, vntGovMngJudName) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtJudCd.Text = mstrJudCd
        txtJudSName.Text = vntJudSName
        txtJudRName.Text = vntJudRName
        txtWeight.Text = vntWeight
        txtGovMngjud.Text = vntGovMngJud
        txtGovMngJudName.Text = vntGovMngJudName
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditJud = Ret
    
    Exit Function

ErrorHandle:

    EditJud = False
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
Private Function RegistJud() As Boolean

On Error GoTo ErrorHandle

    Dim objJud   As Object       '����A�N�Z�X�p
    Dim Ret         As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJud = CreateObject("HainsJud.Jud")
    
    '����e�[�u�����R�[�h�̓o�^
    Ret = objJud.RegistJud(IIf(txtJudCd.Enabled, "INS", "UPD"), _
                           Trim(txtJudCd.Text), _
                           Trim(txtJudSName.Text), _
                           Trim(txtJudRName.Text), _
                           Trim(txtWeight.Text), _
                           Trim(txtGovMngjud.Text), _
                           Trim(txtGovMngJudName.Text))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ����R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistJud = False
        Exit Function
    End If
    
    RegistJud = True
    
    Exit Function
    
ErrorHandle:

    RegistJud = False
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
        
        '����e�[�u���̓o�^
        If RegistJud() = False Then
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
        '������̕ҏW
        If EditJud() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtJudCd.Enabled = (txtJudCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub Text3_Change()

End Sub


