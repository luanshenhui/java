VERSION 5.00
Begin VB.Form frmRoundClassPrice 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�܂�ߍ��ڐ��ʒP���̐ݒ�"
   ClientHeight    =   2535
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6840
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRoundClassPrice.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2535
   ScaleWidth      =   6840
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.Frame Frame1 
      Caption         =   "�ΏۂƂȂ�f�[�^"
      Height          =   1815
      Left            =   60
      TabIndex        =   8
      Top             =   120
      Width           =   6615
      Begin VB.TextBox txtisrPrice 
         Height          =   270
         IMEMode         =   3  '�̌Œ�
         Left            =   2040
         MaxLength       =   8
         TabIndex        =   7
         Text            =   "99999999"
         Top             =   1200
         Width           =   975
      End
      Begin VB.TextBox txtbsdPrice 
         Height          =   270
         IMEMode         =   3  '�̌Œ�
         Left            =   2040
         MaxLength       =   8
         TabIndex        =   5
         Text            =   "99999999"
         Top             =   780
         Width           =   975
      End
      Begin VB.TextBox txtStrCount 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   2040
         MaxLength       =   6
         TabIndex        =   1
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.TextBox txtEndCount 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   3000
         MaxLength       =   6
         TabIndex        =   3
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.Label Label1 
         Caption         =   "�c�̕��S���z(&O):"
         Height          =   180
         Index           =   6
         Left            =   180
         TabIndex        =   4
         Top             =   840
         Width           =   1650
      End
      Begin VB.Label Label1 
         Caption         =   "���ڐ��K�p�͈�(&A):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   420
         Width           =   1710
      End
      Begin VB.Label Label2 
         Caption         =   "�`"
         Height          =   255
         Index           =   0
         Left            =   2760
         TabIndex        =   2
         Top             =   420
         Width           =   255
      End
      Begin VB.Label Label1 
         Caption         =   "���ە��S���z(&K):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   6
         Top             =   1260
         Width           =   1650
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5340
      TabIndex        =   10
      Top             =   2100
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3900
      TabIndex        =   9
      Top             =   2100
      Width           =   1335
   End
End
Attribute VB_Name = "frmRoundClassPrice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrStrCount              As String           '�J�n���ڐ�
Private mstrEndCount              As String           '�I�����ڐ�
Private mstrbsdPrice            As String           '�܂�ߕ��ދ��z�Ǘ��i�ȏ�j
Private mstrisrPrice            As String           '�܂�ߕ��ދ��z�Ǘ��i�ȉ��j

Private mblnUpdated             As Boolean          'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����
Private mblnModeNew             As Boolean          'TRUE:�V�K�AFALSE:�X�V

Private Const DefaultStrCount As String = "0"
Private Const DefaultEndCount As String = "999999"

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    '���̓`�F�b�N
    If CheckValue() = False Then Exit Sub
    
    '�v���p�e�B�l�̉�ʃZ�b�g
    mstrStrCount = txtStrCount.Text
    mstrEndCount = txtEndCount.Text
    mstrbsdPrice = CLng(txtbsdPrice.Text)
    mstrisrPrice = CLng(txtisrPrice.Text)

    mblnUpdated = True
    Unload Me
    
End Sub

'
' �@�\�@�@ : ���̓f�[�^�`�F�b�N
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����f�[�^�AFALSE:�ُ�f�[�^����
'
' ���l�@�@ : �u���������͂���Ă��܂���v��MSG�ɖO�������Ȃ��̂��߂ɏ���ɂ����މ��l���W�b�N
'
Private Function CheckValue() As Boolean

    Dim Ret             As Boolean  '�֐��߂�l
    Dim strWorkResult   As String
        
    '����R���g���[����SetFocus�ł͕�����I�����L���ɂȂ�Ȃ��̂Ń_�~�[�łƂ΂�
    cmdOk.SetFocus
    
    Ret = False
    
    Do
        '���ڐ��i���j�̖����̓`�F�b�N�i����ɂ����ށj
        If Trim(txtStrCount.Text) = "" Then
            txtStrCount.Text = DefaultStrCount
        End If
        
        '���ڐ��i��j�̓��̓`�F�b�N�i����ɂ����ށj
        If Trim(txtEndCount.Text) = "" Then
            txtEndCount.Text = DefaultEndCount
        End If

        '���ڐ��i���j�̐��l�`�F�b�N
        If IsNumeric(txtStrCount.Text) = False Then
            MsgBox "���ڐ��K�p�͈͂ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtStrCount.SetFocus
            Exit Do
        End If
        
        '���ڐ��i��j�̐��l�`�F�b�N
        If IsNumeric(txtEndCount.Text) = False Then
            MsgBox "���ڐ��K�p�͈͂ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtEndCount.SetFocus
            Exit Do
        End If
        
        txtStrCount.Text = Abs(Trim(txtStrCount.Text))
        txtEndCount.Text = Abs(Trim(txtEndCount.Text))

        '���ڐ��i�㉺�j���t�̃`�F�b�N
        If CDbl(txtStrCount.Text) > CDbl(txtEndCount.Text) Then
            '����ɋt���ɂ��܂��B
            strWorkResult = txtEndCount.Text
            txtEndCount.Text = txtStrCount.Text
            txtStrCount.Text = strWorkResult
        End If

        '���ڐ��i����j�ɍő�l�Ƃ��Ă�.99��ǉ�
'        If (CDbl(txtEndCount.Text) - Int(CDbl(txtEndCount.Text))) = 0 Then
'            If Mid(Trim(txtEndCount.Text), Len(Trim(txtEndCount.Text)), 1) = "." Then
'                txtEndCount.Text = txtEndCount.Text & "99"
'            Else
'                txtEndCount.Text = txtEndCount.Text & ".99"
'            End If
'        End If
        
        '���z�����͗��̓[���Z�b�g
        If Trim(txtbsdPrice.Text) = "" Then txtbsdPrice.Text = 0
        If Trim(txtisrPrice.Text) = "" Then txtisrPrice.Text = 0
        
        '���z�̐������`�F�b�N
        If (IsNumeric(txtbsdPrice.Text) = False) Or (IsNumeric(txtisrPrice.Text) = False) Then
            MsgBox "���z�ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtbsdPrice.SetFocus
            Exit Do
        End If
        
        '���z�̃}�C�i�X�`�F�b�N
        If (CLng(txtbsdPrice.Text) < 0) Or (CLng(txtisrPrice.Text) < 0) Then
            MsgBox "���z�Ƀ}�C�i�X�l���w�肷�邱�Ƃ͂ł��܂���B", vbExclamation, App.Title
            txtbsdPrice.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

Private Sub Form_Load()

    Dim i       As Integer

    mblnUpdated = False

    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    '�v���p�e�B�l�̉�ʃZ�b�g
    txtStrCount.Text = mstrStrCount
    txtEndCount.Text = mstrEndCount
    txtbsdPrice.Text = mstrbsdPrice
    txtisrPrice.Text = mstrisrPrice
    
    '���ڐ����Z�b�g����Ă��Ȃ��Ȃ�A����ɃZ�b�g�i�傫�Ȃ����b�V���[�Y�j
    If txtStrCount.Text = "" Then txtStrCount.Text = DefaultStrCount
    If txtEndCount.Text = "" Then txtEndCount.Text = DefaultEndCount
    
End Sub

Friend Property Get StrCount() As Variant
    
    StrCount = mstrStrCount

End Property

Friend Property Let StrCount(ByVal vNewValue As Variant)

    mstrStrCount = vNewValue

End Property

Friend Property Get EndCount() As Variant

    EndCount = mstrEndCount

End Property

Friend Property Let EndCount(ByVal vNewValue As Variant)

    mstrEndCount = vNewValue

End Property

Friend Property Get BsdPrice() As Variant

    BsdPrice = mstrbsdPrice

End Property

Friend Property Let BsdPrice(ByVal vNewValue As Variant)

    mstrbsdPrice = vNewValue

End Property

Friend Property Get IsrPrice() As Variant

    IsrPrice = mstrisrPrice

End Property

Friend Property Let IsrPrice(ByVal vNewValue As Variant)

    mstrisrPrice = vNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
