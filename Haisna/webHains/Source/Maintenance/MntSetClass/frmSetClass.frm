VERSION 5.00
Begin VB.Form frmSetClass 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�Z�b�g���ރe�[�u�������e�i���X"
   ClientHeight    =   1500
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6570
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmSetClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1500
   ScaleWidth      =   6570
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtSetClassName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1740
      MaxLength       =   60
      TabIndex        =   3
      Text            =   "��������������������"
      Top             =   480
      Width           =   4635
   End
   Begin VB.TextBox txtSetClassCd 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   1740
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   615
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3660
      TabIndex        =   4
      Top             =   1020
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5100
      TabIndex        =   5
      Top             =   1020
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�Z�b�g���ޖ�(&N)"
      Height          =   180
      Index           =   1
      Left            =   180
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�Z�b�g���ރR�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmSetClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrSetClassCd  As String   '�Z�b�g���ރR�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let SetClassCd(ByVal vntNewValue As Variant)

    mstrSetClassCd = vntNewValue
    
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
        If Trim(txtSetClassCd.Text) = "" Then
            MsgBox "�Z�b�g���ރR�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtSetClassCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtSetClassName.Text) = "" Then
            MsgBox "�i�����ޖ������͂���Ă��܂���B", vbCritical, App.Title
            txtSetClassName.SetFocus
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
Private Function EditSetClass() As Boolean

    Dim objSetClass         As Object         '�Z�b�g���ރA�N�Z�X�p
    Dim vntSetClassName     As Variant        '�Z�b�g���ޖ�
    Dim vntSetClassSName    As Variant        '�Z�b�g���ޗ���
    Dim vntSeq              As Variant        '�\������
    Dim Ret                 As Boolean        '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSetClass = CreateObject("HainsSetClass.SetClass")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrSetClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�Z�b�g���ރe�[�u�����R�[�h�ǂݍ���
        If objSetClass.SelectSetClass(mstrSetClassCd, vntSetClassName) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtSetClassCd.Text = mstrSetClassCd
        txtSetClassName.Text = vntSetClassName
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditSetClass = Ret
    
    Exit Function

ErrorHandle:

    EditSetClass = False
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
Private Function RegistSetClass() As Boolean

On Error GoTo ErrorHandle

    Dim objSetClass     As Object       '�Z�b�g���ރA�N�Z�X�p
    Dim Ret             As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSetClass = CreateObject("HainsSetClass.SetClass")
    
    '�Z�b�g���ރe�[�u�����R�[�h�̓o�^
    Ret = objSetClass.RegistSetClass(IIf(txtSetClassCd.Enabled, "INS", "UPD"), _
                                     Trim(txtSetClassCd.Text), _
                                     Trim(txtSetClassName.Text))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�Z�b�g���ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistSetClass = False
        Exit Function
    End If
    
    RegistSetClass = True
    
    Set objSetClass = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSetClass = Nothing
    
    RegistSetClass = False
    
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
        
        '�Z�b�g���ރe�[�u���̓o�^
        If RegistSetClass() = False Then
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
        '�Z�b�g���ޏ��̕ҏW
        If EditSetClass() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtSetClassCd.Enabled = (txtSetClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

