VERSION 5.00
Begin VB.Form frmRslCmt 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���ʃR�����g�e�[�u�������e�i���X"
   ClientHeight    =   1830
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5805
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRslCmt.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1830
   ScaleWidth      =   5805
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CheckBox chkEntryOk 
      Caption         =   "���̃R�����g���Z�b�g���ꂽ���ʂ͓��͊����Ƃ���(&F)"
      Height          =   255
      Left            =   1680
      TabIndex        =   6
      Top             =   900
      Width           =   4035
   End
   Begin VB.TextBox txtRslCmtName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   30
      TabIndex        =   3
      Text            =   "��������"
      Top             =   480
      Width           =   4035
   End
   Begin VB.TextBox txtRslCmtCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2940
      TabIndex        =   4
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4380
      TabIndex        =   5
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "���ʃR�����g��(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "���ʃR�����g�R�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmRslCmt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrRslCmtCd    As String   '���ʃR�����g�R�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let RslCmtCd(ByVal vntNewValue As Variant)

    mstrRslCmtCd = vntNewValue
    
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
        If Trim(txtRslCmtCd.Text) = "" Then
            MsgBox "���ʃR�����g�R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtRslCmtCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtRslCmtName.Text) = "" Then
            MsgBox "���ʃR�����g�������͂���Ă��܂���B", vbCritical, App.Title
            txtRslCmtName.SetFocus
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
Private Function EditRslCmt() As Boolean

    Dim objRslCmt       As Object           '���ʃR�����g�A�N�Z�X�p
    Dim vntRslCmtName   As Variant          '���ʃR�����g��
    Dim vntEntryOk      As Variant          '���͊����t���O
    Dim Ret             As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRslCmt = CreateObject("HainsRslCmt.RslCmt")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrRslCmtCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '���ʃR�����g�e�[�u�����R�[�h�ǂݍ���
        If objRslCmt.SelectRslCmt(mstrRslCmtCd, vntRslCmtName, vntEntryOk) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtRslCmtCd.Text = mstrRslCmtCd
        txtRslCmtName.Text = vntRslCmtName
        If vntEntryOk = "1" Then
            chkEntryOk.Value = vbChecked
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditRslCmt = Ret
    
    Exit Function

ErrorHandle:

    EditRslCmt = False
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
Private Function RegistRslCmt() As Boolean

On Error GoTo ErrorHandle

    Dim objRslCmt   As Object       '���ʃR�����g�A�N�Z�X�p
    Dim Ret         As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRslCmt = CreateObject("HainsRslCmt.RslCmt")
    
    '���ʃR�����g�e�[�u�����R�[�h�̓o�^
    Ret = objRslCmt.RegistRslCmt(IIf(txtRslCmtCd.Enabled, "INS", "UPD"), _
                                 Trim(txtRslCmtCd.Text), _
                                 Trim(txtRslCmtName.Text), _
                                 IIf(chkEntryOk.Value = vbChecked, 1, 0))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ���ʃR�����g�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistRslCmt = False
        Exit Function
    End If
    
    RegistRslCmt = True
    
    Exit Function
    
ErrorHandle:

    RegistRslCmt = False
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
        
        '���ʃR�����g�e�[�u���̓o�^
        If RegistRslCmt() = False Then
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
        '���ʃR�����g���̕ҏW
        If EditRslCmt() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtRslCmtCd.Enabled = (txtRslCmtCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

