VERSION 5.00
Begin VB.Form frmStdContactStc 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "��^�ʐڕ��̓e�[�u�������e�i���X"
   ClientHeight    =   2085
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6960
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmStdContactStc.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2085
   ScaleWidth      =   6960
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.ComboBox cboGuidanceDiv 
      Height          =   300
      ItemData        =   "frmStdContactStc.frx":000C
      Left            =   1920
      List            =   "frmStdContactStc.frx":002E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   1
      Top             =   240
      Width           =   4110
   End
   Begin VB.TextBox txtContactStc 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1920
      MaxLength       =   25
      TabIndex        =   5
      Text            =   "��������������������������������������������������"
      Top             =   960
      Width           =   4755
   End
   Begin VB.TextBox txtStdContactStcCd 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   1920
      MaxLength       =   4
      TabIndex        =   3
      Text            =   "@@@@"
      Top             =   600
      Width           =   555
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3960
      TabIndex        =   6
      Top             =   1620
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5400
      TabIndex        =   7
      Top             =   1620
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�w�����e�敪(&D):"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   0
      Top             =   300
      Width           =   1950
   End
   Begin VB.Label Label1 
      Caption         =   "�ʐڕ���(&N):"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   4
      Top             =   1020
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "��^�ʐڕ��̓R�[�h(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   2
      Top             =   660
      Width           =   1950
   End
End
Attribute VB_Name = "frmStdContactStc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrGuidanceDiv         As String   '�w�����e�敪
Private mstrStdContactStcCd     As String   '��^�ʐڕ��̓R�[�h
Private mblnInitialize          As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let GuidanceDiv(ByVal vntNewValue As Variant)

    mstrGuidanceDiv = vntNewValue
    
End Property

Friend Property Let StdContactStcCd(ByVal vntNewValue As Variant)

    mstrStdContactStcCd = vntNewValue
    
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
        If Trim(txtStdContactStcCd.Text) = "" Then
            MsgBox "��^�ʐڕ��̓R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtStdContactStcCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtContactStc.Text) = "" Then
            MsgBox "��^�ʐڕ��͖������͂���Ă��܂���B", vbCritical, App.Title
            txtContactStc.SetFocus
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
Private Function EditStdContactStc() As Boolean

    Dim objStdContactStc        As Object           '��^�ʐڕ��̓A�N�Z�X�p
    Dim vntContactStc           As Variant          '��^�ʐڕ��͖�
    Dim Ret                     As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStdContactStc = CreateObject("HainsStdContactStc.StdContactStc")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If (mstrStdContactStcCd = "") Or (IsNumeric(mstrGuidanceDiv) = False) Then
            Ret = True
            Exit Do
        End If
        
        '��^�ʐڕ��̓e�[�u�����R�[�h�ǂݍ���
        If objStdContactStc.SelectStdContactStc(CInt(mstrGuidanceDiv), mstrStdContactStcCd, vntContactStc) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        cboGuidanceDiv.ListIndex = CInt(mstrGuidanceDiv) - 1
        txtStdContactStcCd.Text = mstrStdContactStcCd
        txtContactStc.Text = vntContactStc
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditStdContactStc = Ret
    
    Exit Function

ErrorHandle:

    EditStdContactStc = False
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
Private Function RegistStdContactStc() As Boolean

    Dim objStdContactStc    As Object       '��^�ʐڕ��̓A�N�Z�X�p
    Dim Ret             As Long
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStdContactStc = CreateObject("HainsStdContactStc.StdContactStc")
    
    '��^�ʐڕ��̓e�[�u�����R�[�h�̓o�^
    Ret = objStdContactStc.RegistStdContactStc(IIf(txtStdContactStcCd.Enabled, "INS", "UPD"), _
                                               cboGuidanceDiv.ListIndex + 1, _
                                               Trim(txtStdContactStcCd.Text), _
                                               Trim(txtContactStc.Text))
    If Ret = 0 Then
        MsgBox "���͂��ꂽ��^�ʐڕ��̓R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistStdContactStc = False
        Exit Function
    End If
    
    RegistStdContactStc = True
    
    Exit Function
    
ErrorHandle:

    RegistStdContactStc = False
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
        
        '��^�ʐڕ��̓e�[�u���̓o�^
        If RegistStdContactStc() = False Then
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

    cboGuidanceDiv.Clear
    cboGuidanceDiv.AddItem "�����̐���"
    cboGuidanceDiv.AddItem "�����E�H���w��"
    cboGuidanceDiv.AddItem "�o�ߒǐ�"
    cboGuidanceDiv.AddItem "�v��������"
    cboGuidanceDiv.AddItem "�v����"
    cboGuidanceDiv.AddItem "��f�̂�����"
    cboGuidanceDiv.AddItem "�^���w��"
    cboGuidanceDiv.AddItem "�S�����k"
    cboGuidanceDiv.ListIndex = 0

    Do
        '��^�ʐڕ��͏��̕ҏW
        If EditStdContactStc() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        cboGuidanceDiv.Enabled = (txtStdContactStcCd.Text = "")
        txtStdContactStcCd.Enabled = (txtStdContactStcCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub
