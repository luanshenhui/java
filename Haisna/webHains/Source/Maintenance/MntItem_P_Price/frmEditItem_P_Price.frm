VERSION 5.00
Begin VB.Form frmEditItem_P_Price 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�˗����ڒP���̐ݒ�"
   ClientHeight    =   2985
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
   Icon            =   "frmEditItem_P_Price.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2985
   ScaleWidth      =   6840
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.Frame Frame1 
      Caption         =   "�ΏۂƂȂ�f�[�^"
      Height          =   1815
      Left            =   120
      TabIndex        =   9
      Top             =   600
      Width           =   6615
      Begin VB.TextBox txtisrPrice 
         Height          =   270
         IMEMode         =   3  '�̌Œ�
         Left            =   1800
         MaxLength       =   7
         TabIndex        =   6
         Text            =   "99999999"
         Top             =   1200
         Width           =   975
      End
      Begin VB.TextBox txtbsdPrice 
         Height          =   270
         IMEMode         =   3  '�̌Œ�
         Left            =   1800
         MaxLength       =   7
         TabIndex        =   4
         Text            =   "99999999"
         Top             =   780
         Width           =   975
      End
      Begin VB.TextBox txtStrAge 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   1800
         MaxLength       =   6
         TabIndex        =   1
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.TextBox txtEndAge 
         Height          =   300
         IMEMode         =   3  '�̌Œ�
         Left            =   2760
         MaxLength       =   6
         TabIndex        =   2
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.Label Label1 
         Caption         =   "�c�̕��S���z(&O):"
         Height          =   180
         Index           =   6
         Left            =   180
         TabIndex        =   3
         Top             =   840
         Width           =   1650
      End
      Begin VB.Label Label1 
         Caption         =   "�N��K�p�͈�(&A):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   420
         Width           =   1470
      End
      Begin VB.Label Label2 
         Caption         =   "�`"
         Height          =   255
         Index           =   0
         Left            =   2520
         TabIndex        =   10
         Top             =   420
         Width           =   255
      End
      Begin VB.Label Label1 
         Caption         =   "���ە��S���z(&K):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   5
         Top             =   1260
         Width           =   1650
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5400
      TabIndex        =   8
      Top             =   2580
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3960
      TabIndex        =   7
      Top             =   2580
      Width           =   1335
   End
   Begin VB.Label lblMode 
      Caption         =   "���ۂ���f�[�^�ݒ�"
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   180
      TabIndex        =   11
      Top             =   180
      Width           =   6075
   End
End
Attribute VB_Name = "frmEditItem_P_Price"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mintExistsIsr           As Integer          '���ۗL���敪
Private mstrStrAge              As String           '�J�n�N��
Private mstrEndAge              As String           '�I���N��
Private mstrbsdPrice            As String           '�˗����ڒP���i�ȏ�j
Private mstrisrPrice            As String           '�˗����ڒP���i�ȉ��j

Private mblnUpdated             As Boolean          'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����
Private mblnModeNew             As Boolean          'TRUE:�V�K�AFALSE:�X�V

Private Const DefaultStrAge As String = "0"
Private Const DefaultEndAge As String = "999.99"

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    '���̓`�F�b�N
    If CheckValue() = False Then Exit Sub
    
    '�v���p�e�B�l�̉�ʃZ�b�g
    mstrStrAge = txtStrAge.Text
    mstrEndAge = txtEndAge.Text
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
        '�N��i���j�̖����̓`�F�b�N�i����ɂ����ށj
        If Trim(txtStrAge.Text) = "" Then
            txtStrAge.Text = DefaultStrAge
        End If
        
        '�N��i��j�̓��̓`�F�b�N�i����ɂ����ށj
        If Trim(txtEndAge.Text) = "" Then
            txtEndAge.Text = DefaultEndAge
        End If

        '�N��i���j�̐��l�`�F�b�N
        If IsNumeric(txtStrAge.Text) = False Then
            MsgBox "�N��K�p�͈͂ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtStrAge.SetFocus
            Exit Do
        End If
        
        '�N��i��j�̐��l�`�F�b�N
        If IsNumeric(txtEndAge.Text) = False Then
            MsgBox "�N��K�p�͈͂ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            txtEndAge.SetFocus
            Exit Do
        End If
        
        txtStrAge.Text = Abs(Trim(txtStrAge.Text))
        txtEndAge.Text = Abs(Trim(txtEndAge.Text))

        '�N��i�㉺�j���t�̃`�F�b�N
        If CDbl(txtStrAge.Text) > CDbl(txtEndAge.Text) Then
            '����ɋt���ɂ��܂��B
            strWorkResult = txtEndAge.Text
            txtEndAge.Text = txtStrAge.Text
            txtStrAge.Text = strWorkResult
        End If

        '�N��̏㉺���`�F�b�N
        If CDbl(txtStrAge.Text) < 0 Then
            MsgBox "�N��̉�����0�ł��B", vbExclamation, App.Title
            txtStrAge.SetFocus
            Exit Do
        End If
        
        If CDbl(txtEndAge.Text) > 999.99 Then
            MsgBox "�N��̏����999.99�ł��B", vbExclamation, App.Title
            txtEndAge.SetFocus
            Exit Do
        End If
        

        '�N��i����j�ɍő�l�Ƃ��Ă�.99��ǉ�
        If (CDbl(txtEndAge.Text) - Int(CDbl(txtEndAge.Text))) = 0 Then
            If Mid(Trim(txtEndAge.Text), Len(Trim(txtEndAge.Text)), 1) = "." Then
                txtEndAge.Text = txtEndAge.Text & "99"
            Else
                txtEndAge.Text = txtEndAge.Text & ".99"
            End If
        End If
        
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
    txtStrAge.Text = mstrStrAge
    txtEndAge.Text = mstrEndAge
    txtbsdPrice.Text = mstrbsdPrice
    txtisrPrice.Text = mstrisrPrice
    
    '�N��Z�b�g����Ă��Ȃ��Ȃ�A����ɃZ�b�g�i�傫�Ȃ����b�V���[�Y�j
    If txtStrAge.Text = "" Then txtStrAge.Text = DefaultStrAge
    If txtEndAge.Text = "" Then txtEndAge.Text = DefaultEndAge
    
    '���ۗL���ɂ���ʐ��䃂�[�h
    If mintExistsIsr = 0 Then
        lblMode.Caption = "���ۂȂ��f�[�^�ݒ�i���ۂȂ��̏ꍇ�A���ە��S���z�͐ݒ�ł��܂���j"
        txtisrPrice.Text = 0
        txtisrPrice.Visible = False
        Label1(1).Visible = False
    Else
        lblMode.Caption = "���ۂ���f�[�^�ݒ�"
    End If

    
End Sub

Friend Property Get ExistsIsr() As Integer
    
    ExistsIsr = mintExistsIsr

End Property

Friend Property Let ExistsIsr(ByVal vNewValue As Integer)

    mintExistsIsr = vNewValue

End Property

Friend Property Get StrAge() As Variant
    
    StrAge = mstrStrAge

End Property

Friend Property Let StrAge(ByVal vNewValue As Variant)

    mstrStrAge = vNewValue

End Property

Friend Property Get EndAge() As Variant

    EndAge = mstrEndAge

End Property

Friend Property Let EndAge(ByVal vNewValue As Variant)

    mstrEndAge = vNewValue

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
