VERSION 5.00
Begin VB.Form frmDisDiv 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�a�ރe�[�u�������e�i���X"
   ClientHeight    =   1575
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6885
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmDisDiv.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1575
   ScaleWidth      =   6885
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.TextBox txtDisDivName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   25
      TabIndex        =   3
      Text            =   "��������������������������������������������������"
      Top             =   480
      Width           =   4875
   End
   Begin VB.TextBox txtDisDivCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   555
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3840
      TabIndex        =   4
      Top             =   1020
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5280
      TabIndex        =   5
      Top             =   1020
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�a�ޖ�(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "�a�ރR�[�h(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmDisDiv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrDisDivCd      As String   '�a�ރR�[�h
Private mblnInitialize  As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated     As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Friend Property Let DisDivCd(ByVal vntNewValue As Variant)

    mstrDisDivCd = vntNewValue
    
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
        If Trim(txtDisDivCd.Text) = "" Then
            MsgBox "�a�ރR�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtDisDivCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If Trim(txtDisDivName.Text) = "" Then
            MsgBox "�a�ޖ������͂���Ă��܂���B", vbCritical, App.Title
            txtDisDivName.SetFocus
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
Private Function EditDisDiv() As Boolean

    Dim objDisDiv     As Object           '�a�ރA�N�Z�X�p
    Dim vntDisDivName As Variant          '�a�ޖ�
    Dim Ret         As Boolean          '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDisDiv = CreateObject("HainsDisease.Disease")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrDisDivCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�a�ރe�[�u�����R�[�h�ǂݍ���
        If objDisDiv.SelectDisDiv(mstrDisDivCd, vntDisDivName) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtDisDivCd.Text = mstrDisDivCd
        txtDisDivName.Text = vntDisDivName
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditDisDiv = Ret
    
    Exit Function

ErrorHandle:

    EditDisDiv = False
    
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
Private Function RegistDisDiv() As Boolean

    Dim objDisDiv As Object       '�a�ރA�N�Z�X�p
    Dim Ret     As Long
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDisDiv = CreateObject("HainsDisease.Disease")
    
    '�a�ރe�[�u�����R�[�h�̓o�^
    Ret = objDisDiv.RegistDisDiv(IIf(txtDisDivCd.Enabled, "INS", "UPD"), Trim(txtDisDivCd.Text), Trim(txtDisDivName.Text))
    If Ret = 0 Then
        MsgBox "���͂��ꂽ�a�ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistDisDiv = False
        Exit Function
    End If
    
    RegistDisDiv = True
    
    Exit Function
    
ErrorHandle:

    RegistDisDiv = False
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
        
        '�a�ރe�[�u���̓o�^
        If RegistDisDiv() = False Then
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
    txtDisDivCd.Text = ""
    txtDisDivName.Text = ""

    Do
        '�a�ޏ��̕ҏW
        If EditDisDiv() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtDisDivCd.Enabled = (txtDisDivCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub
