VERSION 5.00
Begin VB.Form frmWeb_CsOpt 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "WEB�R�[�X�I�v�V������������"
   ClientHeight    =   6045
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6105
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmWeb_CsOpt.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6045
   ScaleWidth      =   6105
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.TextBox txtOptPurpose 
      Height          =   600
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   180
      MaxLength       =   50
      MultiLine       =   -1  'True
      ScrollBars      =   2  '����
      TabIndex        =   3
      Text            =   "frmWeb_CsOpt.frx":000C
      Top             =   1560
      Width           =   5775
   End
   Begin VB.TextBox txtOptName 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   180
      MaxLength       =   30
      TabIndex        =   1
      Text            =   "@@"
      Top             =   840
      Width           =   5775
   End
   Begin VB.TextBox txtOptDetail 
      Height          =   2865
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   180
      MaxLength       =   300
      MultiLine       =   -1  'True
      ScrollBars      =   2  '����
      TabIndex        =   5
      Text            =   "frmWeb_CsOpt.frx":000F
      Top             =   2640
      Width           =   5775
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4620
      TabIndex        =   7
      Top             =   5640
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   3180
      TabIndex        =   6
      Top             =   5640
      Width           =   1335
   End
   Begin VB.Label lblCtrOptName 
      Caption         =   "�����ǃI�v�V�����̐���"
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   180
      TabIndex        =   8
      Top             =   180
      Width           =   3375
   End
   Begin VB.Label Label1 
      Caption         =   "�I�v�V���������̖ړI(&A)"
      Height          =   180
      Index           =   1
      Left            =   180
      TabIndex        =   2
      Top             =   1260
      Width           =   3150
   End
   Begin VB.Label Label1 
      Caption         =   "�I�v�V����������(&A)"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   600
      Width           =   3090
   End
   Begin VB.Label Label1 
      Caption         =   "�I�v�V���������̏ڍא���(&K)"
      Height          =   180
      Index           =   2
      Left            =   180
      TabIndex        =   4
      Top             =   2340
      Width           =   4290
   End
End
Attribute VB_Name = "frmWeb_CsOpt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCtrOptName  As String   '������
Private mstrOptName     As String   '������
Private mstrOptPurpose  As String   '�����ړI
Private mstrOptDetail   As String   '��������

Private mblnUpdate      As Boolean  'TRUE:�X�V���܂����AFALSE:���X�V
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Friend Property Let CtrOptName(ByVal vNewValue As String)

    mstrCtrOptName = vNewValue
    
End Property

Friend Property Get OptName() As String

    OptName = mstrOptName

End Property

Friend Property Let OptName(ByVal vNewValue As String)

    mstrOptName = vNewValue
    
End Property

Friend Property Get OptDetail() As String

    OptDetail = mstrOptDetail

End Property

Friend Property Let OptDetail(ByVal vNewValue As String)

    mstrOptDetail = vNewValue
    
End Property

Private Sub cmdOk_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass

    '���̓`�F�b�N
    If CheckValue() = False Then
        '�������̉���
        Screen.MousePointer = vbDefault
        Exit Sub
    End If

    mstrOptName = txtOptName.Text
    mstrOptPurpose = txtOptPurpose.Text
    mstrOptDetail = txtOptDetail.Text
    mblnUpdate = True
    Unload Me

    '�������̉���
    Screen.MousePointer = vbDefault

End Sub

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

        '�I�v�V�����������̓��̓`�F�b�N
        If Trim(txtOptName.Text) = "" Then
            MsgBox "�I�v�V���������������͂���Ă��܂���B", vbCritical, App.Title
            txtOptName.SetFocus
            Exit Do
        End If

        '���������̓��̓`�F�b�N
        If Trim(txtOptPurpose.Text) = "" Then
            MsgBox "�����ړI�����͂���Ă��܂���B", vbCritical, App.Title
            txtOptPurpose.SetFocus
            Exit Do
        End If

        '�I�v�V���������ڍא����̓��̓`�F�b�N
        If Trim(txtOptDetail.Text) = "" Then
            MsgBox "�ڍא��������͂���Ă��܂���B", vbCritical, App.Title
            txtOptDetail.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function


Private Sub Form_Load()

    mblnUpdate = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    lblCtrOptName.Caption = mstrCtrOptName & "�̐���"

    txtOptName.Text = mstrOptName
    
    '�V�K���͎��Ȃǂ̓I�v�V�������������f�t�H���g�\������
    If Trim(txtOptName.Text) = "" Then
        txtOptName.Text = mstrCtrOptName
    End If
    
    txtOptPurpose.Text = mstrOptPurpose
    txtOptDetail.Text = mstrOptDetail
    
End Sub

Public Property Get Updated() As Variant

    Updated = mblnUpdate
    
End Property

Friend Property Get OptPurpose() As String

    OptPurpose = mstrOptPurpose

End Property

Friend Property Let OptPurpose(ByVal vNewValue As String)

    mstrOptPurpose = vNewValue

End Property
