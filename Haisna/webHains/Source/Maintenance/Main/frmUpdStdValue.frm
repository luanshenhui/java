VERSION 5.00
Begin VB.Form frmUpdStdValue 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�w��͈͌������ʂ̊�l�X�V"
   ClientHeight    =   2715
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6840
   ControlBox      =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2715
   ScaleWidth      =   6840
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.ComboBox cboEndDay 
      Height          =   300
      ItemData        =   "frmUpdStdValue.frx":0000
      Left            =   4620
      List            =   "frmUpdStdValue.frx":0007
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   8
      Top             =   1440
      Width           =   555
   End
   Begin VB.ComboBox cboEndMonth 
      Height          =   300
      ItemData        =   "frmUpdStdValue.frx":000F
      Left            =   3720
      List            =   "frmUpdStdValue.frx":0016
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   7
      Top             =   1440
      Width           =   555
   End
   Begin VB.ComboBox cboEndYear 
      Height          =   300
      ItemData        =   "frmUpdStdValue.frx":001E
      Left            =   2700
      List            =   "frmUpdStdValue.frx":0025
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   6
      Top             =   1440
      Width           =   735
   End
   Begin VB.ComboBox cboStrDay 
      Height          =   300
      ItemData        =   "frmUpdStdValue.frx":002F
      Left            =   4620
      List            =   "frmUpdStdValue.frx":0036
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   5
      Top             =   1020
      Width           =   555
   End
   Begin VB.ComboBox cboStrMonth 
      Height          =   300
      ItemData        =   "frmUpdStdValue.frx":003E
      Left            =   3720
      List            =   "frmUpdStdValue.frx":0045
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   4
      Top             =   1020
      Width           =   555
   End
   Begin VB.ComboBox cboStrYear 
      Height          =   300
      ItemData        =   "frmUpdStdValue.frx":004D
      Left            =   2700
      List            =   "frmUpdStdValue.frx":0054
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   3
      Top             =   1020
      Width           =   735
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5400
      TabIndex        =   1
      Top             =   2220
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3960
      TabIndex        =   0
      Top             =   2220
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "�����ΏۏI�����t(&E):"
      Height          =   195
      Index           =   1
      Left            =   900
      TabIndex        =   16
      Top             =   1500
      Width           =   1755
   End
   Begin VB.Label Label1 
      Caption         =   "�����ΏۊJ�n���t(&S):"
      Height          =   195
      Index           =   0
      Left            =   900
      TabIndex        =   15
      Top             =   1080
      Width           =   1755
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   7
      Left            =   5220
      TabIndex        =   14
      Top             =   1500
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   6
      Left            =   4320
      TabIndex        =   13
      Top             =   1500
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   5
      Left            =   3480
      TabIndex        =   12
      Top             =   1500
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   3
      Left            =   5220
      TabIndex        =   11
      Top             =   1080
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   1
      Left            =   4320
      TabIndex        =   10
      Top             =   1080
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   0
      Left            =   3480
      TabIndex        =   9
      Top             =   1080
      Width           =   255
   End
   Begin VB.Label lblMsg 
      Caption         =   "�w�肳�ꂽ�͈͂̌������ʂɑ΂��āC���݂̊�l�ݒ��K�p���܂��B"
      Height          =   495
      Left            =   900
      TabIndex        =   2
      Top             =   300
      Width           =   5715
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   240
      Picture         =   "frmUpdStdValue.frx":005E
      Top             =   240
      Width           =   480
   End
End
Attribute VB_Name = "frmUpdStdValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    Dim strStrDate  As String
    Dim strEndDate  As String
    Dim lngRet      As Long
    
    strStrDate = cboStrYear.List(cboStrYear.ListIndex) & "/" & _
                 Format(cboStrMonth.List(cboStrMonth.ListIndex), "00") & "/" & _
                 Format(cboStrDay.List(cboStrDay.ListIndex), "00")

    strEndDate = cboEndYear.List(cboEndYear.ListIndex) & "/" & _
                 Format(cboEndMonth.List(cboEndMonth.ListIndex), "00") & "/" & _
                 Format(cboEndDay.List(cboEndDay.ListIndex), "00")

    '���t�������̃`�F�b�N
    If IsDate(strStrDate) = False Then
        MsgBox "�������J�n���t����͂��Ă�������", vbExclamation, App.Title
        cboStrDay.SetFocus
        Exit Sub
    End If
    
    If IsDate(strEndDate) = False Then
        MsgBox "�������I�����t����͂��Ă�������", vbExclamation, App.Title
        cboEndDay.SetFocus
        Exit Sub
    End If

    lngRet = MsgBox("�w�肳�ꂽ���t�͈͓��̌������ʂɑ΂��āA���݂̊�l��K�p���܂��B" & vbLf & "��낵���ł����H", vbQuestion + vbDefaultButton2 + vbYesNo, Me.Caption)
    If lngRet = vbNo Then Exit Sub
    
    Screen.MousePointer = vbHourglass
    
    '��l�̍X�V
    Call ExecuteUpdateStdValue(CDate(strStrDate), CDate(strEndDate))
    
    Screen.MousePointer = vbDefault
    
End Sub

'
' �@�\�@�@ : ��l�K�p
'
' ���l�@�@ : �w��͈͓��̌������ʂɑ΂����l���X�V���܂��B
'
Private Sub ExecuteUpdateStdValue(dtmStrDate As Date, dtmEndDate As Date)

On Error GoTo ErrorHandle

    Dim objStdValue     As Object           '��l�A�N�Z�X�p
    Dim lngRet          As Long             '�C���f�b�N�X
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStdValue = CreateObject("HainsStdValue.StdValue")
    lngRet = objStdValue.UpdateAllStdValue(dtmStrDate, dtmEndDate)
    
    If lngRet = INSERT_NORMAL Then
        MsgBox "��l�̍X�V������I�����܂����B", vbInformation
    Else
        MsgBox "�X�V�������ɃG���[���������܂����B", vbCritical
    End If
    
    '�I�u�W�F�N�g�p��
    Set objStdValue = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objStdValue = Nothing
    
End Sub

Private Sub Form_Load()

    '�\���p�t�H�[��������
    Call InitializeForm

End Sub

Private Sub InitializeForm()
    
    Dim i As Integer
    
    '�R���g���[��������
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    lblMsg.Caption = "�w�肳�ꂽ�͈͂̌������ʂɑ΂��āC���݂̊�l�ݒ���ēK�p���܂��B" & vbLf & _
                     "���̏����͎w�肳�ꂽ���t�͈͂��傫���ꍇ�A�����Ɏ��Ԃ�������܂��B"
    
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
    
    cboStrYear.ListIndex = Year(Now) - YEARRANGE_MIN
    cboStrMonth.ListIndex = Month(Now) - 1
    cboStrDay.ListIndex = 0

    cboEndYear.ListIndex = Year(Now) - YEARRANGE_MIN
    cboEndMonth.ListIndex = Month(Now) - 1
    cboEndDay.ListIndex = cboEndDay.ListCount - 1

End Sub

