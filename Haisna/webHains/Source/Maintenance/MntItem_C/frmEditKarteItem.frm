VERSION 5.00
Begin VB.Form frmEditKarteItem 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�d�q�J���e�A�g���ڃR�[�h�̕ҏW"
   ClientHeight    =   2730
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6660
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditKarteItem.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2730
   ScaleWidth      =   6660
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.TextBox txtKarteTagName 
      Height          =   315
      IMEMode         =   3  '�̌Œ�
      Left            =   1680
      MaxLength       =   20
      TabIndex        =   9
      Text            =   "@@@@@@@@@@@@@@@@@@@@"
      Top             =   1620
      Width           =   2595
   End
   Begin VB.TextBox txtKarteItemcd 
      Height          =   315
      IMEMode         =   3  '�̌Œ�
      Left            =   1680
      MaxLength       =   8
      TabIndex        =   5
      Text            =   "@@@@@@@@"
      Top             =   900
      Width           =   1095
   End
   Begin VB.TextBox txtKarteItemName 
      Height          =   315
      IMEMode         =   4  '�S�p�Ђ炪��
      Left            =   1680
      MaxLength       =   50
      TabIndex        =   7
      Text            =   "��������������������������������������������������"
      Top             =   1260
      Width           =   4695
   End
   Begin VB.TextBox txtKarteItemAttr 
      Height          =   315
      IMEMode         =   3  '�̌Œ�
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   3
      Text            =   "@@@"
      Top             =   540
      Width           =   555
   End
   Begin VB.TextBox txtKarteDocCd 
      Height          =   315
      IMEMode         =   3  '�̌Œ�
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   1
      Text            =   "@@@@"
      Top             =   180
      Width           =   615
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5220
      TabIndex        =   11
      Top             =   2280
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3840
      TabIndex        =   10
      Top             =   2280
      Width           =   1275
   End
   Begin VB.Label Label8 
      Caption         =   "�^�O��(&T):"
      Height          =   195
      Index           =   0
      Left            =   180
      TabIndex        =   8
      Top             =   1680
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "�ϊ��R�[�h(&C):"
      Height          =   195
      Index           =   16
      Left            =   180
      TabIndex        =   4
      Top             =   960
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "���ږ�(&N):"
      Height          =   195
      Index           =   17
      Left            =   180
      TabIndex        =   6
      Top             =   1320
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "���ڑ���(&A):"
      Height          =   195
      Index           =   18
      Left            =   180
      TabIndex        =   2
      Top             =   600
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "������ʃR�[�h(&B):"
      Height          =   195
      Index           =   19
      Left            =   180
      TabIndex        =   0
      Top             =   240
      Width           =   1515
   End
End
Attribute VB_Name = "frmEditKarteItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim mblnUpdated         As Boolean      'TRUE:�X�V�ς݁AFALSE:�X�V�Ȃ�

Dim mstrKarteDocCd      As String
Dim mstrKarteItemAttr   As String
Dim mstrKarteItemcd     As String
Dim mstrKarteItemName   As String
Dim mstrKarteTagName    As String

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Friend Property Get KarteDocCd() As String

    KarteDocCd = mstrKarteDocCd

End Property

Friend Property Let KarteDocCd(ByVal vNewValue As String)

    mstrKarteDocCd = vNewValue

End Property

Friend Property Get KarteItemAttr() As String

    KarteItemAttr = mstrKarteItemAttr

End Property

Friend Property Let KarteItemAttr(ByVal vNewValue As String)

    mstrKarteItemAttr = vNewValue
    
End Property

Friend Property Get KarteItemcd() As String

    KarteItemcd = mstrKarteItemcd

End Property

Friend Property Let KarteItemcd(ByVal vNewValue As String)

    mstrKarteItemcd = vNewValue

End Property

Friend Property Get KarteItemName() As String

    KarteItemName = mstrKarteItemName

End Property

Friend Property Let KarteItemName(ByVal vNewValue As String)

    mstrKarteItemName = vNewValue
    
End Property

Friend Property Get KarteTagName() As String

    KarteTagName = mstrKarteTagName

End Property

Friend Property Let KarteTagName(ByVal vNewValue As String)

    mstrKarteTagName = vNewValue
    
End Property

Private Sub cmdOk_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '�f�[�^�ۑ�
    If ApplyData() = True Then
    
        '�X�V�ς݃t���O��True��
        mblnUpdated = True
        
        '��ʂ����
        Unload Me
    End If
    
    '�������̉���
    Screen.MousePointer = vbDefault

End Sub

Private Function ApplyData() As Boolean

    ApplyData = False
    
    '�X�V�ς݃t���O��false��
    mblnUpdated = False
    
    '���̓`�F�b�N
    If CheckValue() = False Then
        Exit Function
    End If
    
    '�f�[�^�Z�b�g
    mstrKarteDocCd = Trim(txtKarteDocCd.Text)
    mstrKarteItemAttr = Trim(txtKarteItemAttr.Text)
    mstrKarteItemcd = Trim(txtKarteItemcd.Text)
    mstrKarteItemName = Trim(txtKarteItemName.Text)
    mstrKarteTagName = Trim(txtKarteTagName.Text)
    
    ApplyData = True
    
End Function

Private Function CheckValue() As Boolean

    CheckValue = False
    
    '������ʃR�[�h�̖����̓`�F�b�N
    If Trim(txtKarteDocCd) = "" Then
        MsgBox "������ʃR�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
        txtKarteDocCd.SetFocus
        Exit Function
    End If
    
    '���ڑ����̖����̓`�F�b�N
    If Trim(txtKarteItemAttr) = "" Then
        MsgBox "���ڑ��������͂���Ă��܂���B", vbExclamation, App.Title
        txtKarteItemAttr.SetFocus
        Exit Function
    End If
    
    '�ϊ��R�[�h�̖����̓`�F�b�N
    If Trim(txtKarteItemcd) = "" Then
        MsgBox "�ϊ��R�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
        txtKarteItemcd.SetFocus
        Exit Function
    End If
    
    '���ږ��̖����̓`�F�b�N
    If Trim(txtKarteItemName) = "" Then
        MsgBox "���ږ������͂���Ă��܂���B", vbExclamation, App.Title
        txtKarteItemName.SetFocus
        Exit Function
    End If
    
    CheckValue = True
    
End Function

Private Sub Form_Load()

    Call InitFormControls(Me, mcolGotFocusCollection)

    mblnUpdated = False
    
    txtKarteDocCd.Text = mstrKarteDocCd
    txtKarteItemAttr.Text = mstrKarteItemAttr
    txtKarteItemcd.Text = mstrKarteItemcd
    txtKarteItemName.Text = mstrKarteItemName
    txtKarteTagName.Text = mstrKarteTagName

End Sub

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated
    
End Property
