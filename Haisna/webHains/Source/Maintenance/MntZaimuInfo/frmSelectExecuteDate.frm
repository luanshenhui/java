VERSION 5.00
Begin VB.Form frmSelectExecuteDate 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�������t��I�����Ă��������B"
   ClientHeight    =   4095
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6285
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4095
   ScaleWidth      =   6285
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.OptionButton optAppend 
      Caption         =   "�����f�[�^�ǉ�(&A)"
      Height          =   255
      Index           =   1
      Left            =   3000
      TabIndex        =   29
      Top             =   780
      Value           =   -1  'True
      Width           =   1995
   End
   Begin VB.OptionButton optAppend 
      Caption         =   "�V�K�쐬(&N)"
      Height          =   255
      Index           =   0
      Left            =   1380
      TabIndex        =   28
      Top             =   780
      Width           =   1575
   End
   Begin VB.CheckBox chkOrg 
      Caption         =   "�c�̐����̍����f�[�^���M���s��(&O)"
      Height          =   315
      Left            =   240
      TabIndex        =   25
      Top             =   1140
      Width           =   3375
   End
   Begin VB.Frame fraOrg 
      Caption         =   "�c�̐������ߐݒ�"
      Height          =   1875
      Left            =   240
      TabIndex        =   10
      Top             =   1620
      Width           =   5955
      Begin VB.ComboBox cboEndDay 
         Height          =   300
         ItemData        =   "frmSelectExecuteDate.frx":0000
         Left            =   3780
         List            =   "frmSelectExecuteDate.frx":0007
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   20
         Top             =   1200
         Width           =   555
      End
      Begin VB.ComboBox cboEndMonth 
         Height          =   300
         ItemData        =   "frmSelectExecuteDate.frx":000F
         Left            =   2880
         List            =   "frmSelectExecuteDate.frx":0016
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   19
         Top             =   1200
         Width           =   555
      End
      Begin VB.ComboBox cboEndYear 
         Height          =   300
         ItemData        =   "frmSelectExecuteDate.frx":001E
         Left            =   1860
         List            =   "frmSelectExecuteDate.frx":0025
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   18
         Top             =   1200
         Width           =   735
      End
      Begin VB.ComboBox cboStrDay 
         Height          =   300
         ItemData        =   "frmSelectExecuteDate.frx":002F
         Left            =   3780
         List            =   "frmSelectExecuteDate.frx":0036
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   13
         Top             =   840
         Width           =   555
      End
      Begin VB.ComboBox cboStrMonth 
         Height          =   300
         ItemData        =   "frmSelectExecuteDate.frx":003E
         Left            =   2880
         List            =   "frmSelectExecuteDate.frx":0045
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   12
         Top             =   840
         Width           =   555
      End
      Begin VB.ComboBox cboStrYear 
         Height          =   300
         ItemData        =   "frmSelectExecuteDate.frx":004D
         Left            =   1860
         List            =   "frmSelectExecuteDate.frx":0054
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   11
         Top             =   840
         Width           =   735
      End
      Begin VB.Label orgLabel 
         Caption         =   "�����ɑ��M���鐿�����f�[�^�����͈͂��w�肵�Ă��������B"
         Height          =   315
         Left            =   300
         TabIndex        =   26
         Top             =   360
         Width           =   4635
      End
      Begin VB.Label Label2 
         Caption         =   "�I�����t(&E):"
         Height          =   255
         Index           =   1
         Left            =   780
         TabIndex        =   24
         Top             =   1260
         Width           =   1095
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   8
         Left            =   4380
         TabIndex        =   23
         Top             =   1260
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   7
         Left            =   3480
         TabIndex        =   22
         Top             =   1260
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "�N"
         Height          =   255
         Index           =   6
         Left            =   2640
         TabIndex        =   21
         Top             =   1260
         Width           =   255
      End
      Begin VB.Label Label2 
         Caption         =   "�J�n���t(&S):"
         Height          =   255
         Index           =   0
         Left            =   780
         TabIndex        =   17
         Top             =   900
         Width           =   1095
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   2
         Left            =   4380
         TabIndex        =   16
         Top             =   900
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   4
         Left            =   3480
         TabIndex        =   15
         Top             =   900
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "�N"
         Height          =   255
         Index           =   5
         Left            =   2640
         TabIndex        =   14
         Top             =   900
         Width           =   255
      End
   End
   Begin VB.CheckBox chkAllData 
      Caption         =   "���������M�f�[�^��S�ď�������B(&C)"
      Height          =   315
      Left            =   240
      TabIndex        =   9
      Top             =   3600
      Visible         =   0   'False
      Width           =   3015
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3360
      TabIndex        =   4
      Top             =   3600
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4800
      TabIndex        =   3
      Top             =   3600
      Width           =   1335
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmSelectExecuteDate.frx":005E
      Left            =   1380
      List            =   "frmSelectExecuteDate.frx":0065
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   2
      Top             =   360
      Width           =   735
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmSelectExecuteDate.frx":006F
      Left            =   2400
      List            =   "frmSelectExecuteDate.frx":0076
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   1
      Top             =   360
      Width           =   555
   End
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmSelectExecuteDate.frx":007E
      Left            =   3300
      List            =   "frmSelectExecuteDate.frx":0085
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   0
      Top             =   360
      Width           =   555
   End
   Begin VB.Label Label3 
      Caption         =   "�쐬���[�h�F"
      Height          =   195
      Left            =   300
      TabIndex        =   27
      Top             =   840
      Width           =   975
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   0
      Left            =   2160
      TabIndex        =   8
      Top             =   420
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   1
      Left            =   3000
      TabIndex        =   7
      Top             =   420
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   3
      Left            =   3900
      TabIndex        =   6
      Top             =   420
      Width           =   255
   End
   Begin VB.Label Label1 
      Caption         =   "���[���t(&D):"
      Height          =   255
      Left            =   300
      TabIndex        =   5
      Top             =   420
      Width           =   1095
   End
End
Attribute VB_Name = "frmSelectExecuteDate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mblnUpdated         As Boolean      'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mstrInitialDate     As String       '�����\�����t

Private mdtmInsDate         As Date         '���[���t
Private mdtmStrDate         As Date         '�c�̒��ߊJ�n���t
Private mdtmEndDate         As Date         '�c�̒��ߏI�����t
Private mblnCalcOrg         As Boolean      'TRUE:�c�̐������ߏ������{�AFALSE:�l�̂�
Private mblnAppendMode      As Boolean      'TRUE:�����f�[�^�ǉ��AFALSE:�V�K�쐬

Friend Property Let InitialDate(ByVal vNewValue As String)

    mstrInitialDate = vNewValue

End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Friend Property Get CalcOrg() As Boolean

    CalcOrg = mblnCalcOrg

End Property

Friend Property Get AppendMode() As Boolean

    AppendMode = mblnAppendMode

End Property

Friend Property Get InsDate() As Date

    InsDate = mdtmInsDate

End Property

Friend Property Get strDate() As Date

    strDate = mdtmStrDate

End Property

Friend Property Get endDate() As Date

    endDate = mdtmEndDate

End Property

Friend Property Get AllData() As Boolean

    AllData = chkAllData.Value

End Property

Private Sub chkOrg_Click()

    If chkOrg.Value = vbChecked Then
        fraOrg.Visible = True
    Else
        fraOrg.Visible = False
    End If
    
End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    Dim strYY           As String
    Dim strMM           As String
    Dim strDD           As String
    Dim strstrYY        As String
    Dim strstrMM        As String
    Dim strstrDD        As String
    Dim strendYY        As String
    Dim strendMM        As String
    Dim strendDD        As String
    
    strYY = cboYear.ListIndex + 2002
    strMM = Format((cboMonth.ListIndex + 1), "00")
    strDD = Format((cboDay.ListIndex + 1), "00")
        
    If IsDate(strYY & "/" & strMM & "/" & strDD) = False Then
        MsgBox "���������[���t���w�肵�Ă��������B", vbExclamation, Me.Caption
        cboDay.SetFocus
        Exit Sub
    End If
    
    If chkOrg.Value = vbChecked Then
        strstrYY = cboStrYear.ListIndex + 2002
        strstrMM = Format((cboStrMonth.ListIndex + 1), "00")
        strstrDD = Format((cboStrDay.ListIndex + 1), "00")
            
        If IsDate(strstrYY & "/" & strstrMM & "/" & strstrDD) = False Then
            MsgBox "�������J�n���t���w�肵�Ă��������B", vbExclamation, Me.Caption
            cboStrDay.SetFocus
            Exit Sub
        End If
        
        strendYY = cboEndYear.ListIndex + 2002
        strendMM = Format((cboEndMonth.ListIndex + 1), "00")
        strendDD = Format((cboEndDay.ListIndex + 1), "00")
            
        If IsDate(strendYY & "/" & strendMM & "/" & strendDD) = False Then
            MsgBox "�������J�n���t���w�肵�Ă��������B", vbExclamation, Me.Caption
            cboEndDay.SetFocus
            Exit Sub
        End If
    
        mdtmStrDate = CDate(strstrYY & "/" & strstrMM & "/" & strstrDD)
        mdtmEndDate = CDate(strendYY & "/" & strendMM & "/" & strendDD)
    
    End If
    
    mdtmInsDate = CDate(strYY & "/" & strMM & "/" & strDD)
    
    mblnCalcOrg = chkOrg.Value = vbChecked
    mblnAppendMode = optAppend(1).Value = True
    
    mblnUpdated = True
    Unload Me

End Sub

Private Sub Form_Load()

    Dim i               As Integer
    Dim strWorkDate     As String
    Dim lngYear         As Long
    Dim lngMonth        As Long
    Dim lngDay          As Long

    lngYear = Year(Now)
    lngMonth = Month(Now)
    lngDay = Day(Now)

    '�f�t�H���g���t���Z�b�g����Ă���ꍇ�́A�Z�b�g�p�ɕ���
    If Len(Trim(mstrInitialDate)) = 8 Then
        strWorkDate = Mid(mstrInitialDate, 1, 4) & "/" & Mid(mstrInitialDate, 5, 2) & "/" & Mid(mstrInitialDate, 7, 2)
        If IsDate(strWorkDate) = True Then
            lngYear = CLng(Mid(mstrInitialDate, 1, 4))
            lngMonth = CLng(Mid(mstrInitialDate, 5, 2))
            lngDay = CLng(Mid(mstrInitialDate, 7, 2))
        End If
    End If

    '�R���{�{�b�N�X�ɒl���Z�b�g
    cboYear.Clear
    cboStrYear.Clear
    cboEndYear.Clear
    For i = 2002 To YEARRANGE_MAX
        cboYear.AddItem i
        cboStrYear.AddItem i
        cboEndYear.AddItem i
    Next i
    cboYear.ListIndex = lngYear - 2002
    cboStrYear.ListIndex = lngYear - 2002
    cboEndYear.ListIndex = lngYear - 2002
    
    cboMonth.Clear
    cboStrMonth.Clear
    cboEndMonth.Clear
    For i = 1 To 12
        cboMonth.AddItem i
        cboStrMonth.AddItem i
        cboEndMonth.AddItem i
    Next i
    cboMonth.ListIndex = lngMonth - 1
    cboStrMonth.ListIndex = lngMonth - 1
    cboEndMonth.ListIndex = lngMonth - 1
    
    cboDay.Clear
    cboStrDay.Clear
    cboEndDay.Clear
    For i = 1 To 31
        cboDay.AddItem i
        cboStrDay.AddItem i
        cboEndDay.AddItem i
    Next i
    cboDay.ListIndex = lngDay - 1
    cboStrDay.ListIndex = lngDay - 1
    cboEndDay.ListIndex = lngDay - 1

    Call chkOrg_Click
    
    mblnUpdated = False
    
End Sub
