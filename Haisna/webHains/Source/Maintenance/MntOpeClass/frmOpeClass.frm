VERSION 5.00
Begin VB.Form frmOpeClass 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�������{�����ރe�[�u�������e�i���X"
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
   Icon            =   "frmOpeClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1830
   ScaleWidth      =   5805
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtOrderCntl 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   2220
      MaxLength       =   12
      TabIndex        =   5
      Text            =   "123456789012"
      Top             =   840
      Width           =   1215
   End
   Begin VB.TextBox txtOpeClassName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   2220
      MaxLength       =   15
      TabIndex        =   3
      Text            =   "������������������������������"
      Top             =   480
      Width           =   3075
   End
   Begin VB.TextBox txtOpeClassCd 
      Height          =   300
      IMEMode         =   3  '�̌Œ�
      Left            =   2220
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
      TabIndex        =   6
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4380
      TabIndex        =   7
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�I�[�_����p�ԍ�(&O)"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   4
      Top             =   900
      Width           =   1770
   End
   Begin VB.Label Label1 
      Caption         =   "�������{�����ޖ�(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1770
   End
   Begin VB.Label Label1 
      Caption         =   "�������{�����ރR�[�h(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   2010
   End
End
Attribute VB_Name = "frmOpeClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrOpeClassCd  As String   '�������{�����ރR�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let OpeClassCd(ByVal vntNewValue As Variant)

    mstrOpeClassCd = vntNewValue
    
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
        If Trim(txtOpeClassCd.Text) = "" Then
            MsgBox "�������{�����ރR�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtOpeClassCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtOpeClassName.Text) = "" Then
            MsgBox "�������{�����ޖ������͂���Ă��܂���B", vbCritical, App.Title
            txtOpeClassName.SetFocus
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
Private Function EditOpeClass() As Boolean

    Dim objOpeClass     As Object           '�������{�����ރA�N�Z�X�p
    Dim vntOpeClassName As Variant          '�������{�����ޖ�
    Dim vntOrderCntl    As Variant          '�I�[�_����p�ԍ�
    Dim Ret             As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objOpeClass = CreateObject("HainsOpeClass.OpeClass")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrOpeClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�������{�����ރe�[�u�����R�[�h�ǂݍ���
        If objOpeClass.SelectOpeClass(mstrOpeClassCd, vntOpeClassName, vntOrderCntl) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtOpeClassCd.Text = mstrOpeClassCd
        txtOpeClassName.Text = vntOpeClassName
        txtOrderCntl.Text = vntOrderCntl
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditOpeClass = Ret
    
    Exit Function

ErrorHandle:

    EditOpeClass = False
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
Private Function RegistOpeClass() As Boolean

On Error GoTo ErrorHandle

    Dim objOpeClass As Object       '�������{�����ރA�N�Z�X�p
    Dim Ret         As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objOpeClass = CreateObject("HainsOpeClass.OpeClass")
    
    '�������{�����ރe�[�u�����R�[�h�̓o�^
    Ret = objOpeClass.RegistOpeClass(IIf(txtOpeClassCd.Enabled, "INS", "UPD"), _
                                     Trim(txtOpeClassCd.Text), _
                                     Trim(txtOpeClassName.Text), _
                                     Trim(txtOrderCntl.Text))

    If Ret = 0 Then
        MsgBox "���͂��ꂽ�������{�����ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistOpeClass = False
        Exit Function
    End If
    
    RegistOpeClass = True
    
    Exit Function
    
ErrorHandle:

    RegistOpeClass = False
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
        
        '�������{�����ރe�[�u���̓o�^
        If RegistOpeClass() = False Then
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
        '�������{�����ޏ��̕ҏW
        If EditOpeClass() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtOpeClassCd.Enabled = (txtOpeClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

