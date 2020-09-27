VERSION 5.00
Begin VB.Form frmStcClass 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�����e�[�u�������e�i���X"
   ClientHeight    =   1365
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4380
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmStcClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1365
   ScaleWidth      =   4380
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtStcClassName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1620
      MaxLength       =   10
      TabIndex        =   3
      Text            =   "��������"
      Top             =   480
      Width           =   2235
   End
   Begin VB.TextBox txtStcClassCd 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   1620
      MaxLength       =   2
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1440
      TabIndex        =   4
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   2880
      TabIndex        =   5
      Top             =   960
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "���͕��ޖ�(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "���͕��ރR�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmStcClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrStcClassCd As String   '���͕��ރR�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let StcClassCd(ByVal vntNewValue As Variant)

    mstrStcClassCd = vntNewValue
    
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
        If Trim(txtStcClassCd.Text) = "" Then
            MsgBox "���͕��ރR�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtStcClassCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtStcClassName.Text) = "" Then
            MsgBox "���͕��ޖ������͂���Ă��܂���B", vbCritical, App.Title
            txtStcClassName.SetFocus
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
Private Function EditStcClass() As Boolean

    Dim objStcClass        As Object           '���͕��ރA�N�Z�X�p
    Dim vntStcClassName    As Variant          '���͕��ޖ�
    Dim Ret                 As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStcClass = CreateObject("HainsSentence.Sentence")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrStcClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '���͕��ރe�[�u�����R�[�h�ǂݍ���
        If objStcClass.SelectStcClass(mstrStcClassCd, vntStcClassName) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtStcClassCd.Text = mstrStcClassCd
        txtStcClassName.Text = vntStcClassName
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditStcClass = Ret
    
    Exit Function

ErrorHandle:

    EditStcClass = False
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
Private Function RegistStcClass() As Boolean

    Dim objStcClass    As Object       '���͕��ރA�N�Z�X�p
    Dim Ret             As Long
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStcClass = CreateObject("HainsSentence.Sentence")
    
    '���͕��ރe�[�u�����R�[�h�̓o�^
    Ret = objStcClass.RegistStcClass(IIf(txtStcClassCd.Enabled, "INS", "UPD"), Trim(txtStcClassCd.Text), Trim(txtStcClassName.Text))
    If Ret = 0 Then
        MsgBox "���͂��ꂽ���͕��ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistStcClass = False
        Exit Function
    End If
    
    RegistStcClass = True
    
    Exit Function
    
ErrorHandle:

    RegistStcClass = False
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
        
        '���͕��ރe�[�u���̓o�^
        If RegistStcClass() = False Then
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
        '���͕��ޏ��̕ҏW
        If EditStcClass() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtStcClassCd.Enabled = (txtStcClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub txtRelationName_Change()

End Sub
