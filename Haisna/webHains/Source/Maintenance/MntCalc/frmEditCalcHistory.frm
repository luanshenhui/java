VERSION 5.00
Begin VB.Form frmEditCalcHistory 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�v�Z���ڗ������̐ݒ�"
   ClientHeight    =   2805
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7380
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditCalcHistory.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2805
   ScaleWidth      =   7380
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.TextBox txtExplanation 
      Height          =   735
      Left            =   1560
      MaxLength       =   30
      TabIndex        =   12
      Text            =   "Text1"
      Top             =   1500
      Width           =   5595
   End
   Begin VB.ComboBox cboTiming 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":000C
      Left            =   1560
      List            =   "frmEditCalcHistory.frx":002E
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   10
      Top             =   1080
      Width           =   5610
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4440
      TabIndex        =   13
      Top             =   2400
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5880
      TabIndex        =   14
      Top             =   2400
      Width           =   1335
   End
   Begin VB.ComboBox cboFraction 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":0050
      Left            =   1560
      List            =   "frmEditCalcHistory.frx":0072
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   8
      Top             =   660
      Width           =   2670
   End
   Begin VB.ComboBox cboEndDay 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":0094
      Left            =   6420
      List            =   "frmEditCalcHistory.frx":009B
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   6
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboEndMonth 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00A3
      Left            =   5520
      List            =   "frmEditCalcHistory.frx":00AA
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   5
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboEndYear 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00B2
      Left            =   4500
      List            =   "frmEditCalcHistory.frx":00B9
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   4
      Top             =   240
      Width           =   735
   End
   Begin VB.ComboBox cboStrDay 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00C3
      Left            =   3480
      List            =   "frmEditCalcHistory.frx":00CA
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   3
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboStrMonth 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00D2
      Left            =   2580
      List            =   "frmEditCalcHistory.frx":00D9
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   2
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboStrYear 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00E1
      Left            =   1560
      List            =   "frmEditCalcHistory.frx":00E8
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   1
      Top             =   240
      Width           =   735
   End
   Begin VB.Label Label8 
      Caption         =   "����(&E):"
      Height          =   195
      Index           =   8
      Left            =   180
      TabIndex        =   11
      Top             =   1560
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "�v�Z�^�C�~���O(&T):"
      Height          =   195
      Index           =   4
      Left            =   180
      TabIndex        =   9
      Top             =   1140
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "�[������(&H):"
      Height          =   195
      Index           =   2
      Left            =   180
      TabIndex        =   7
      Top             =   720
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "�L������(&D):"
      Height          =   255
      Left            =   180
      TabIndex        =   0
      Top             =   300
      Width           =   1155
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   7
      Left            =   7020
      TabIndex        =   20
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   6
      Left            =   6120
      TabIndex        =   19
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   5
      Left            =   5280
      TabIndex        =   18
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "���`"
      Height          =   255
      Index           =   3
      Left            =   4080
      TabIndex        =   17
      Top             =   300
      Width           =   435
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   1
      Left            =   3180
      TabIndex        =   16
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   0
      Left            =   2340
      TabIndex        =   15
      Top             =   300
      Width           =   255
   End
End
Attribute VB_Name = "frmEditCalcHistory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrStrDate             As String   '�J�n���t
Private mstrEndDate             As String   '�I�����t
Private mintFraction            As Integer  '�[������
Private mintTiming              As Integer  '�v�Z�^�C�~���O
Private mstrExplanation         As String   '����

Private mblnUpdated             As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrRootFraction()      As String   '�R���{�{�b�N�X�ɑΉ�����R�[�X�R�[�h�̊i�[
Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    Dim strStrDate As String
    Dim strEndDate As String

    '���̓`�F�b�N
    If CheckValue(strStrDate, strEndDate) = False Then Exit Sub
    
    '�v���p�e�B�l�̉�ʃZ�b�g
    mstrStrDate = strStrDate
    mstrEndDate = strEndDate
    mintFraction = cboFraction.ListIndex
    mintTiming = cboTiming.ListIndex
    mstrExplanation = Trim(txtExplanation.Text)

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
' ���l�@�@ :
'
Private Function CheckValue(strStrDate As String, strEndDate As String) As Boolean

    Dim Ret             As Boolean  '�֐��߂�l
    Dim strWorkResult   As String
        
    '����R���g���[����SetFocus�ł͕�����I�����L���ɂȂ�Ȃ��̂Ń_�~�[�łƂ΂�
    cmdOk.SetFocus
    
    Ret = False
    
    Do
        
        '�J�n���t�`�F�b�N
        strStrDate = cboStrYear.Text & "/" & _
                     Format(cboStrMonth.Text, "00") & "/" & _
                     Format(cboStrDay.Text, "00")

        If IsDate(strStrDate) = False Then
            MsgBox "�������J�n���t����͂��Ă��������B", vbExclamation, App.Title
            cboStrYear.SetFocus
            Exit Do
        End If

        '�I�����t�`�F�b�N
        strEndDate = cboEndYear.Text & "/" & _
                     Format(cboEndMonth.Text, "00") & "/" & _
                     Format(cboEndDay.Text, "00")

        If IsDate(strEndDate) = False Then
            MsgBox "�������I�����t����͂��Ă��������B", vbExclamation, App.Title
            cboEndYear.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

Private Sub Form_Load()

    Dim Ret             As Boolean  '�߂�l
    Dim i               As Integer
    Dim intWorkYear     As Integer
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False

    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    '�R���{�{�b�N�X�ɒl���Z�b�g
    For i = YEARRANGE_MIN To YEARRANGE_MAX
        cboStrYear.AddItem i
        cboEndYear.AddItem i
    Next i
    
    For i = 1 To 12
        cboStrMonth.AddItem i
        cboEndMonth.AddItem i
    Next i
    
    For i = 1 To 31
        cboStrDay.AddItem i
        cboEndDay.AddItem i
    Next i

    '�J�n���̐ݒ�
    If IsDate(mstrStrDate) = True Then
        intWorkYear = CInt(Format(CDate(mstrStrDate), "YYYY"))
        If intWorkYear >= YEARRANGE_MIN Then
            cboStrYear.ListIndex = intWorkYear - YEARRANGE_MIN
        End If
        cboStrMonth.ListIndex = CInt(Format(CDate(mstrStrDate), "MM")) - 1
        cboStrDay.ListIndex = CInt(Format(CDate(mstrStrDate), "DD")) - 1
    End If

    '�I�����̐ݒ�
    If IsDate(mstrEndDate) = True Then
        intWorkYear = CInt(Format(CDate(mstrEndDate), "YYYY"))
        If intWorkYear >= YEARRANGE_MIN Then
            cboEndYear.ListIndex = intWorkYear - YEARRANGE_MIN
        End If
        cboEndMonth.ListIndex = CInt(Format(CDate(mstrEndDate), "MM")) - 1
        cboEndDay.ListIndex = CInt(Format(CDate(mstrEndDate), "DD")) - 1
    End If

    With cboFraction
        .Clear
        .AddItem "0:�l�̌ܓ�"
        .AddItem "1:�؂�グ"
        .AddItem "2:�؂�̂�"
        .ListIndex = mintFraction
    End With
    
    With cboTiming
        .Clear
        .AddItem "0:�S�Ă̒l���������Ƃ��Ɍv�Z���A���ʂ��i�["
        .AddItem "1:�v�Z�v�f�̂����A��ł��l���������ꍇ�ɁA�v�Z�����s"
        .ListIndex = mintTiming
    End With
    
    txtExplanation.Text = mstrExplanation

    Ret = True
    
    '�������̉���
    Screen.MousePointer = vbDefault

End Sub

Friend Property Get Fraction() As Integer

    Fraction = mintFraction

End Property

Friend Property Let Fraction(ByVal vNewValue As Integer)

    mintFraction = vNewValue

End Property

Friend Property Get Timing() As Integer

    Timing = mintTiming

End Property

Friend Property Let Timing(ByVal vNewValue As Integer)

    mintTiming = vNewValue

End Property

Friend Property Get Explanation() As String

    Explanation = mstrExplanation

End Property

Friend Property Let Explanation(ByVal vNewValue As String)

    mstrExplanation = vNewValue

End Property

Friend Property Get StrDate() As Variant

    StrDate = mstrStrDate

End Property

Friend Property Let StrDate(ByVal vNewValue As Variant)

    mstrStrDate = vNewValue

End Property

Friend Property Get EndDate() As Variant

    EndDate = mstrEndDate

End Property

Friend Property Let EndDate(ByVal vNewValue As Variant)

    mstrEndDate = vNewValue

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property
