VERSION 5.00
Begin VB.Form frmCourse_h 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�R�[�X�������"
   ClientHeight    =   5220
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5505
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmCourse_h.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5220
   ScaleWidth      =   5505
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   4080
      TabIndex        =   23
      Top             =   4800
      Width           =   1275
   End
   Begin VB.Frame Frame1 
      Caption         =   "��f��������"
      Height          =   1695
      Left            =   120
      TabIndex        =   19
      Top             =   2940
      Visible         =   0   'False
      Width           =   5235
      Begin VB.ComboBox cboHistory 
         BeginProperty Font 
            Name            =   "�l�r �o�S�V�b�N"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         ItemData        =   "frmCourse_h.frx":000C
         Left            =   360
         List            =   "frmCourse_h.frx":002E
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   20
         Top             =   1020
         Width           =   4590
      End
      Begin VB.Label LabelItem 
         Caption         =   "�V�K�쐬���������������f�����R�s�[����ɂ͂����őI�����Ă��������B"
         Height          =   375
         Left            =   840
         TabIndex        =   22
         Top             =   420
         Width           =   4275
      End
      Begin VB.Image Image1 
         Height          =   405
         Index           =   0
         Left            =   300
         Picture         =   "frmCourse_h.frx":0050
         Stretch         =   -1  'True
         Top             =   420
         Width           =   405
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1320
      TabIndex        =   18
      Top             =   4800
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   2700
      TabIndex        =   17
      Top             =   4800
      Width           =   1275
   End
   Begin VB.Frame fraMain 
      Caption         =   "Frame1"
      Height          =   2655
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   5235
      Begin VB.ComboBox cboStrYear 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":0492
         Left            =   2040
         List            =   "frmCourse_h.frx":0499
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   9
         Top             =   1140
         Width           =   735
      End
      Begin VB.ComboBox cboStrMonth 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04A3
         Left            =   3060
         List            =   "frmCourse_h.frx":04AA
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   8
         Top             =   1140
         Width           =   555
      End
      Begin VB.ComboBox cboStrDay 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04B2
         Left            =   3960
         List            =   "frmCourse_h.frx":04B9
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   7
         Top             =   1140
         Width           =   555
      End
      Begin VB.ComboBox cboEndYear 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04C1
         Left            =   2040
         List            =   "frmCourse_h.frx":04C8
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   6
         Top             =   1560
         Width           =   735
      End
      Begin VB.ComboBox cboEndMonth 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04D2
         Left            =   3060
         List            =   "frmCourse_h.frx":04D9
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   5
         Top             =   1560
         Width           =   555
      End
      Begin VB.ComboBox cboEndDay 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04E1
         Left            =   3960
         List            =   "frmCourse_h.frx":04E8
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   4
         Top             =   1560
         Width           =   555
      End
      Begin VB.CommandButton cmdStrDate 
         Caption         =   "�g�p�J�n(&S)..."
         Height          =   315
         Left            =   300
         TabIndex        =   3
         Top             =   1140
         Width           =   1695
      End
      Begin VB.CommandButton cmdEndDate 
         Caption         =   "�g�p�I��(&E)..."
         Height          =   315
         Left            =   300
         TabIndex        =   2
         Top             =   1560
         Width           =   1695
      End
      Begin VB.TextBox txtPrice 
         Height          =   315
         IMEMode         =   3  '�̌Œ�
         Left            =   2040
         MaxLength       =   7
         TabIndex        =   1
         Text            =   "Text1"
         Top             =   1980
         Width           =   855
      End
      Begin VB.Label Label5 
         Caption         =   "�����ŊǗ��������ݒ肵�܂��B"
         Height          =   255
         Index           =   0
         Left            =   900
         TabIndex        =   21
         Top             =   480
         Width           =   4275
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   4
         Left            =   300
         Picture         =   "frmCourse_h.frx":04F0
         Top             =   360
         Width           =   480
      End
      Begin VB.Label Label8 
         Caption         =   "�N"
         Height          =   255
         Index           =   0
         Left            =   2820
         TabIndex        =   16
         Top             =   1200
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   1
         Left            =   3660
         TabIndex        =   15
         Top             =   1200
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   3
         Left            =   4560
         TabIndex        =   14
         Top             =   1200
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "�N"
         Height          =   255
         Index           =   5
         Left            =   2820
         TabIndex        =   13
         Top             =   1620
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   6
         Left            =   3660
         TabIndex        =   12
         Top             =   1620
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   7
         Left            =   4560
         TabIndex        =   11
         Top             =   1620
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "�R�[�X��{����(&C):"
         BeginProperty Font 
            Name            =   "�l�r �o�S�V�b�N"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   2
         Left            =   420
         TabIndex        =   10
         Top             =   2040
         Width           =   1575
      End
   End
End
Attribute VB_Name = "frmCourse_h"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCsCd        As String   '�R�[�X�R�[�h
Private mintCsHNo       As Integer  '����ԍ�
Private mstrStrDate     As String   '�J�n���t
Private mstrEndDate     As String   '�I�����t
Private mlngPrice       As Long     '�R�[�X��{����
Private mblnUpdate      As Boolean  'TRUE:�X�V���܂����AFALSE:���X�V

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Private Sub cmdApply_Click()

    '�f�[�^�K�p�������s��
    Call ApplyData

End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub


Friend Property Let CsCd(ByVal vNewValue As Variant)

    mstrCsCd = vNewValue

End Property

Friend Property Get CsHNo() As Variant

    CsHNo = mintCsHNo

End Property

Friend Property Let CsHNo(ByVal vNewValue As Variant)

    mintCsHNo = vNewValue
    
End Property


Friend Property Get strDate() As Variant

    strDate = mstrStrDate

End Property
Friend Property Let strDate(ByVal vNewValue As Variant)

    mstrStrDate = vNewValue
    
End Property

Friend Property Get endDate() As Variant

    endDate = mstrEndDate

End Property

Friend Property Let endDate(ByVal vNewValue As Variant)

    mstrEndDate = vNewValue

End Property

Friend Property Let Price(ByVal vNewValue As Variant)

    mlngPrice = vNewValue
    
End Property

Private Sub cmdOk_Click()

    '�f�[�^�K�p�������s���i�G���[���͉�ʂ���Ȃ��j
    If ApplyData() = False Then
        Exit Sub
    End If

    '��ʂ����
    Unload Me
    
End Sub

Private Sub Form_Load()

    Dim i As Integer
    
    mblnUpdate = False
    
    '�\���p�t�H�[��������
    Call InitializeForm

End Sub

' @(e)
'
' �@�\�@�@ : �f�[�^�̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �ύX���ꂽ�f�[�^���e�[�u���ɕۑ�����
'
' ���l�@�@ :
'
Private Function ApplyData() As Boolean

    ApplyData = False
    
    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then Exit Function
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    Do
        '���̓`�F�b�N
        If CheckValue() = False Then Exit Do
        
        '�R�[�X�e�[�u���̓o�^
        If RegistCourse_h() = False Then Exit Do
        
        '�X�V�ς݃t���O����
        mblnUpdate = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault
    

End Function
' @(e)
'
' �@�\�@�@ : �R�[�X��{���̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e���R�[�X�e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistCourse_h() As Boolean

On Error GoTo ErrorHandle

    Dim objCourse       As Object   '�R�[�X�A�N�Z�X�p
    Dim lngRet          As Long
    
    RegistCourse_h = False

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")

    '�R�[�X�����Ǘ��e�[�u�����R�[�h�̓o�^
    lngRet = objCourse.RegistCourse_h(IIf(mintCsHNo = -1, "INS", "UPD"), _
                                      mstrCsCd, _
                                      mintCsHNo, _
                                      CDate(mstrStrDate), _
                                      CDate(mstrEndDate), _
                                      mlngPrice)
    
    If lngRet <> INSERT_NORMAL Then
        
        Select Case lngRet
            
            Case INSERT_DUPLICATE
                MsgBox "����ԍ����ő�ɒB���܂����B����ȏ㗚�����Ǘ����邱�Ƃ��ł��܂���B", vbExclamation
            
            Case INSERT_HISTORYDUPLICATE
                MsgBox "���t���d�����Ă��闚�������݂��܂��B����ݒ���ē��͂��Ă��������B", vbExclamation
            
            Case Else
                MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical
    
        End Select
        Exit Function
    End If
    
    
    RegistCourse_h = True
    
    Exit Function
    
ErrorHandle:

    RegistCourse_h = False
    MsgBox Err.Description, vbCritical
    
End Function


' @(e)
'
' �@�\�@�@ : �o�^�f�[�^�̃`�F�b�N
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e�̑Ó������`�F�b�N����
'
' ���l�@�@ :
'
Private Function CheckValue() As Boolean

    Dim Ret             As Boolean  '�֐��߂�l
    Dim strStrDate      As String
    Dim strEndDate      As String
    Dim strWorkDate     As String
    
    '��������
    Ret = False
    
    Do

        '�]���Ȃǂ������čĊi�[
        txtPrice.Text = Trim(txtPrice.Text)
        
        '�R�[�X��{�������ݒ肳��Ă��Ȃ��Ȃ�A\0�Ƃ���
        If Trim(txtPrice.Text) = "" Then
            txtPrice.Text = 0
        End If

        '�R�[�X��{�����̐��l�`�F�b�N
        If IsNumeric(txtPrice.Text) = False Then
            MsgBox "�R�[�X��{�����ɂ͐��l����͂��Ă�������", vbExclamation, App.Title
            txtPrice.SetFocus
            Exit Do
        End If

        '�����_�͐؂�̂Ă�
        txtPrice.Text = Fix(CLng(txtPrice.Text))

        '���z����`�F�b�N
        If CLng(txtPrice.Text) >= 10000000 Then
            MsgBox "�R�[�X��{�����ɂ�\10,000,000�ȏ�̋��z���w�肷�邱�Ƃ͂ł��܂���B", vbExclamation, App.Title
            txtPrice.SetFocus
            Exit Do
        End If
        
        strStrDate = cboStrYear.List(cboStrYear.ListIndex) & "/" & _
                     Format(cboStrMonth.List(cboStrMonth.ListIndex), "00") & "/" & _
                     Format(cboStrDay.List(cboStrDay.ListIndex), "00")

        strEndDate = cboEndYear.List(cboEndYear.ListIndex) & "/" & _
                     Format(cboEndMonth.List(cboEndMonth.ListIndex), "00") & "/" & _
                     Format(cboEndDay.List(cboEndDay.ListIndex), "00")

        '���t�������̃`�F�b�N
        If IsDate(strStrDate) = False Then
            MsgBox "�������J�n���t����͂��Ă�������", vbExclamation, App.Title
            cboStrYear.SetFocus
            Exit Do
        End If
        
        If IsDate(strEndDate) = False Then
            MsgBox "�������I�����t����͂��Ă�������", vbExclamation, App.Title
            cboEndYear.SetFocus
            Exit Do
        End If
        
        '���t�̑召�`�F�b�N
        If CDate(strStrDate) > CDate(strEndDate) Then
            
            If MsgBox("�J�n�I�����t���t�]���Ă��܂��B����ւ��ĕۑ����܂����H", vbYesNo + vbQuestion) = vbNo Then
                cboStrYear.SetFocus
                Exit Do
            Else
                '�J�n�I�����t�̍ăZ�b�g
                cboStrYear.ListIndex = CLng(Mid(strEndDate, 1, 4)) - YEARRANGE_MIN
                cboStrMonth.ListIndex = CLng(Mid(strEndDate, 6, 2)) - 1
                cboStrDay.ListIndex = CLng(Mid(strEndDate, 9, 2)) - 1
            
                cboEndYear.ListIndex = CLng(Mid(strStrDate, 1, 4)) - YEARRANGE_MIN
                cboEndMonth.ListIndex = CLng(Mid(strStrDate, 6, 2)) - 1
                cboEndDay.ListIndex = CLng(Mid(strStrDate, 9, 2)) - 1
                
                strWorkDate = strStrDate
                strStrDate = strEndDate
                strEndDate = strWorkDate
            
            End If
        
        End If
        
        '���W���[�����x���ϐ��֍Ċi�[
        mstrStrDate = strStrDate
        mstrEndDate = strEndDate
        mlngPrice = txtPrice.Text
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function




Private Sub InitializeForm()
    
    Dim i As Integer
    
    '�R���g���[��������
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
    
    '�X�V���[�h���̓��t���Z�b�g����Ă���ꍇ�A�f�t�H���g�Z�b�g
    If Trim(mstrStrDate) <> "" Then
        If (CLng(Mid(mstrStrDate, 1, 4)) - YEARRANGE_MIN) >= 0 Then
            cboStrYear.ListIndex = CLng(Mid(mstrStrDate, 1, 4)) - YEARRANGE_MIN
        Else
            cboStrYear.ListIndex = 0
        End If
        cboStrMonth.ListIndex = CLng(Mid(mstrStrDate, 6, 2)) - 1
        cboStrDay.ListIndex = CLng(Mid(mstrStrDate, 9, 2)) - 1
    Else
        cboStrYear.ListIndex = 0
        cboStrMonth.ListIndex = 0
        cboStrDay.ListIndex = 0
    End If

    '�X�V���[�h���̓��t���Z�b�g����Ă���ꍇ�A�f�t�H���g�Z�b�g
    If Trim(mstrEndDate) <> "" Then
        If (CLng(Mid(mstrEndDate, 1, 4)) - YEARRANGE_MIN) >= 0 Then
            cboEndYear.ListIndex = CLng(Mid(mstrEndDate, 1, 4)) - YEARRANGE_MIN
        Else
            cboEndYear.ListIndex = 0
        End If
        cboEndMonth.ListIndex = CLng(Mid(mstrEndDate, 6, 2)) - 1
        cboEndDay.ListIndex = CLng(Mid(mstrEndDate, 9, 2)) - 1
    Else
        cboEndYear.ListIndex = cboEndYear.ListCount - 1
        cboEndMonth.ListIndex = cboEndMonth.ListCount - 1
        cboEndDay.ListIndex = cboEndDay.ListCount - 1
    End If
    
    '���z�Z�b�g
    txtPrice.Text = mlngPrice

    cboHistory.Clear

    '�V�K�A�X�V���[�h�ɉ����ĉ�ʐ���
    If mintCsHNo = -1 Then
        fraMain.Caption = "�V�K�쐬"
    Else
        fraMain.Caption = "����No:" & mintCsHNo
        cboHistory.Enabled = False
        LabelItem.ForeColor = vbGrayText
    End If

End Sub

Friend Property Get Updated() As Variant

    Updated = mblnUpdate
    
End Property

