VERSION 5.00
Begin VB.Form frmProgress 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�i���Ǘ��p���ރe�[�u�������e�i���X"
   ClientHeight    =   2415
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4140
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmProgress.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2415
   ScaleWidth      =   4140
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtSeq 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   1860
      MaxLength       =   2
      TabIndex        =   7
      Text            =   "@@"
      Top             =   1260
      Width           =   375
   End
   Begin VB.TextBox txtProgressSName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1860
      MaxLength       =   2
      TabIndex        =   5
      Text            =   "����"
      Top             =   900
      Width           =   495
   End
   Begin VB.TextBox txtProgressName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1860
      MaxLength       =   10
      TabIndex        =   3
      Text            =   "��������������������"
      Top             =   540
      Width           =   1935
   End
   Begin VB.TextBox txtProgressCd 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   1860
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   180
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1140
      TabIndex        =   8
      Top             =   1980
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   2580
      TabIndex        =   9
      Top             =   1980
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�\������(&O)"
      Height          =   180
      Index           =   3
      Left            =   300
      TabIndex        =   6
      Top             =   1320
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�i�����ޗ���(&R)"
      Height          =   180
      Index           =   2
      Left            =   300
      TabIndex        =   4
      Top             =   960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�i�����ޖ�(&N)"
      Height          =   180
      Index           =   1
      Left            =   300
      TabIndex        =   2
      Top             =   600
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�i�����ރR�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   300
      TabIndex        =   0
      Top             =   240
      Width           =   1410
   End
End
Attribute VB_Name = "frmProgress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrProgressCd  As String   '�i���Ǘ��p���ރR�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let ProgressCd(ByVal vntNewValue As Variant)

    mstrProgressCd = vntNewValue
    
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
        If Trim(txtProgressCd.Text) = "" Then
            MsgBox "�i���Ǘ��p���ރR�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtProgressCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtProgressName.Text) = "" Then
            MsgBox "�i�����ޖ������͂���Ă��܂���B", vbCritical, App.Title
            txtProgressName.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtProgressSName.Text) = "" Then
            MsgBox "�i�����ޗ��̂����͂���Ă��܂���B", vbCritical, App.Title
            txtProgressSName.SetFocus
            Exit Do
        End If

        '�\�����Ԃ̓��̓`�F�b�N
        If Trim(txtSeq.Text) = "" Then
            MsgBox "�\�����Ԃ����͂���Ă��܂���B", vbCritical, App.Title
            txtSeq.SetFocus
            Exit Do
        End If
        
        '�\�����Ԃ̐��l�`�F�b�N
        If IsNumeric(txtSeq.Text) = False Then
            MsgBox "�\�����Ԃɂ͐��l����͂��Ă��������B", vbCritical, App.Title
            txtSeq.SetFocus
            Exit Do
        End If
        
        '�\�����Ԃ̐��l�`�F�b�N�Q
        If CInt(txtSeq.Text) < 1 Then
            MsgBox "�\�����Ԃɂ͐��̒l����͂��Ă��������B", vbCritical, App.Title
            txtSeq.SetFocus
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
Private Function EditProgress() As Boolean

    Dim objProgress         As Object         '�i���Ǘ��p���ރA�N�Z�X�p
    Dim vntProgressName     As Variant        '�i���Ǘ��p���ޖ�
    Dim vntProgressSName    As Variant        '�i���Ǘ��p���ޗ���
    Dim vntSeq              As Variant        '�\������
    Dim Ret                 As Boolean        '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objProgress = CreateObject("HainsProgress.Progress")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrProgressCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�i���Ǘ��p���ރe�[�u�����R�[�h�ǂݍ���
        If objProgress.SelectProgress(mstrProgressCd, vntProgressName, vntProgressSName, vntSeq) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtProgressCd.Text = mstrProgressCd
        txtProgressName.Text = vntProgressName
        txtProgressSName.Text = vntProgressSName
        txtSeq.Text = vntSeq
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditProgress = Ret
    
    Exit Function

ErrorHandle:

    EditProgress = False
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
Private Function RegistProgress() As Boolean

On Error GoTo ErrorHandle

    Dim objProgress     As Object       '�i���Ǘ��p���ރA�N�Z�X�p
    Dim Ret             As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objProgress = CreateObject("HainsProgress.Progress")
    
    '�i���Ǘ��p���ރe�[�u�����R�[�h�̓o�^
    Ret = objProgress.RegistProgress(IIf(txtProgressCd.Enabled, "INS", "UPD"), _
                                     Trim(txtProgressCd.Text), _
                                     Trim(txtProgressName.Text), _
                                     Trim(txtProgressSName.Text), _
                                     Trim(txtSeq.Text))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�i���Ǘ��p���ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistProgress = False
        Exit Function
    End If
    
    RegistProgress = True
    
    Set objProgress = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objProgress = Nothing
    
    RegistProgress = False
    
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
        
        '�i���Ǘ��p���ރe�[�u���̓o�^
        If RegistProgress() = False Then
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
        '�i���Ǘ��p���ޏ��̕ҏW
        If EditProgress() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtProgressCd.Enabled = (txtProgressCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

