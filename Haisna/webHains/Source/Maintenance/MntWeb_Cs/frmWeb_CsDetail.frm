VERSION 5.00
Begin VB.Form frmWeb_CsDetail 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "WEB�R�[�X�������ڐ���"
   ClientHeight    =   4470
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
   Icon            =   "frmWeb_CsDetail.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4470
   ScaleWidth      =   6105
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.TextBox txtInspect 
      Height          =   300
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   180
      MaxLength       =   30
      TabIndex        =   1
      Text            =   "@@"
      Top             =   420
      Width           =   5775
   End
   Begin VB.TextBox txtInsDetail 
      Height          =   2865
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   180
      MaxLength       =   300
      MultiLine       =   -1  'True
      ScrollBars      =   2  '����
      TabIndex        =   3
      Text            =   "frmWeb_CsDetail.frx":000C
      Top             =   1080
      Width           =   5775
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4620
      TabIndex        =   5
      Top             =   4020
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   3180
      TabIndex        =   4
      Top             =   4020
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "������(&A)"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "��������(&K)"
      Height          =   180
      Index           =   2
      Left            =   180
      TabIndex        =   2
      Top             =   840
      Width           =   1410
   End
End
Attribute VB_Name = "frmWeb_CsDetail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCsCd        As String   '�R�[�X�R�[�h
Private mintSeq         As Integer  '�\����
Private mstrInspect     As String   '������
Private mstrInsDetail   As String   '��������

Private mblnUpdate      As Boolean  'TRUE:�X�V���܂����AFALSE:���X�V
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Friend Property Get Inspect() As Variant

    Inspect = mstrInspect

End Property

Friend Property Let Inspect(ByVal vNewValue As Variant)

    mstrInspect = vNewValue
    
End Property

Friend Property Get InsDetail() As Variant

    InsDetail = mstrInsDetail

End Property

Friend Property Let InsDetail(ByVal vNewValue As Variant)

    mstrInsDetail = vNewValue
    
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

    mstrInspect = txtInspect.Text
    mstrInsDetail = txtInsDetail.Text
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

        '�������̓��̓`�F�b�N
        If Trim(txtInspect.Text) = "" Then
            MsgBox "�����������͂���Ă��܂���B", vbCritical, App.Title
            txtInspect.SetFocus
            Exit Do
        End If

        '���������̓��̓`�F�b�N
        If Trim(txtInsDetail.Text) = "" Then
            MsgBox "�������������͂���Ă��܂���B", vbCritical, App.Title
            txtInsDetail.SetFocus
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
    
    txtInspect.Text = mstrInspect
    txtInsDetail.Text = mstrInsDetail
    
End Sub



Public Property Get Updated() As Variant

    Updated = mblnUpdate
    
End Property

