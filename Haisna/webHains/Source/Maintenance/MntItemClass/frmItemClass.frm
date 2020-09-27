VERSION 5.00
Begin VB.Form frmItemClass 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�������ރe�[�u�������e�i���X"
   ClientHeight    =   1380
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5100
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmItemClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1380
   ScaleWidth      =   5100
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtItemClassName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   10
      TabIndex        =   3
      Text            =   "��������"
      Top             =   480
      Width           =   2235
   End
   Begin VB.TextBox txtItemClassCd 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2220
      TabIndex        =   4
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   3660
      TabIndex        =   5
      Top             =   960
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�������ޖ�(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�������ރR�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmItemClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemClassCd As String   '�������ރR�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let ItemClassCd(ByVal vntNewValue As Variant)

    mstrItemClassCd = vntNewValue
    
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
        If Trim(txtItemClassCd.Text) = "" Then
            MsgBox "�������ރR�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtItemClassCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtItemClassName.Text) = "" Then
            MsgBox "�������ޖ������͂���Ă��܂���B", vbCritical, App.Title
            txtItemClassName.SetFocus
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
Private Function EditItemClass() As Boolean

    Dim objItemClass        As Object           '�������ރA�N�Z�X�p
    Dim vntItemClassName    As Variant          '�������ޖ�
    Dim Ret                 As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemClass = CreateObject("HainsItem.Item")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrItemClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�������ރe�[�u�����R�[�h�ǂݍ���
        If objItemClass.SelectItemClass(mstrItemClassCd, vntItemClassName) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtItemClassCd.Text = mstrItemClassCd
        txtItemClassName.Text = vntItemClassName
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditItemClass = Ret
    
    Exit Function

ErrorHandle:

    EditItemClass = False
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
Private Function RegistItemClass() As Boolean

    Dim objItemClass    As Object       '�������ރA�N�Z�X�p
    Dim Ret             As Long
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemClass = CreateObject("HainsItem.Item")
    
    '�������ރe�[�u�����R�[�h�̓o�^
    Ret = objItemClass.RegistItemClass(IIf(txtItemClassCd.Enabled, "INS", "UPD"), Trim(txtItemClassCd.Text), Trim(txtItemClassName.Text))
    If Ret = 0 Then
        MsgBox "���͂��ꂽ�������ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistItemClass = False
        Exit Function
    End If
    
    RegistItemClass = True
    
    Exit Function
    
ErrorHandle:

    RegistItemClass = False
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
        
        '�������ރe�[�u���̓o�^
        If RegistItemClass() = False Then
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
        '�������ޏ��̕ҏW
        If EditItemClass() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtItemClassCd.Enabled = (txtItemClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub
