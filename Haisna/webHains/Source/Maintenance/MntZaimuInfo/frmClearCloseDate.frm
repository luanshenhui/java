VERSION 5.00
Begin VB.Form frmClearCloseDate 
   BorderStyle     =   1  '�Œ�(����)
   Caption         =   "���߂̂��Ȃ���"
   ClientHeight    =   4455
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8100
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   Icon            =   "frmClearCloseDate.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4455
   ScaleWidth      =   8100
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmClearCloseDate.frx":000C
      Left            =   3840
      List            =   "frmClearCloseDate.frx":0013
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   21
      Top             =   900
      Width           =   555
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmClearCloseDate.frx":001B
      Left            =   2940
      List            =   "frmClearCloseDate.frx":0022
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   20
      Top             =   900
      Width           =   555
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmClearCloseDate.frx":002A
      Left            =   1920
      List            =   "frmClearCloseDate.frx":0031
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   19
      Top             =   900
      Width           =   735
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   6420
      TabIndex        =   18
      Top             =   3960
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4980
      TabIndex        =   17
      Top             =   3960
      Width           =   1335
   End
   Begin VB.Frame fraOrg 
      Caption         =   "�c�̐������߃N���A�ݒ�"
      Height          =   1875
      Left            =   780
      TabIndex        =   1
      Top             =   1920
      Width           =   6975
      Begin VB.ComboBox cboStrYear 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":003B
         Left            =   1860
         List            =   "frmClearCloseDate.frx":0042
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   7
         Top             =   840
         Width           =   735
      End
      Begin VB.ComboBox cboStrMonth 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":004C
         Left            =   2880
         List            =   "frmClearCloseDate.frx":0053
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   6
         Top             =   840
         Width           =   555
      End
      Begin VB.ComboBox cboStrDay 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":005B
         Left            =   3780
         List            =   "frmClearCloseDate.frx":0062
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   5
         Top             =   840
         Width           =   555
      End
      Begin VB.ComboBox cboEndYear 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":006A
         Left            =   1860
         List            =   "frmClearCloseDate.frx":0071
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   4
         Top             =   1200
         Width           =   735
      End
      Begin VB.ComboBox cboEndMonth 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":007B
         Left            =   2880
         List            =   "frmClearCloseDate.frx":0082
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   3
         Top             =   1200
         Width           =   555
      End
      Begin VB.ComboBox cboEndDay 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":008A
         Left            =   3780
         List            =   "frmClearCloseDate.frx":0091
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   2
         Top             =   1200
         Width           =   555
      End
      Begin VB.Label Label8 
         Caption         =   "�N"
         Height          =   255
         Index           =   5
         Left            =   2640
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
         Caption         =   "��"
         Height          =   255
         Index           =   2
         Left            =   4380
         TabIndex        =   14
         Top             =   900
         Width           =   255
      End
      Begin VB.Label Label2 
         Caption         =   "�J�n���t(&S):"
         Height          =   255
         Index           =   0
         Left            =   780
         TabIndex        =   13
         Top             =   900
         Width           =   1095
      End
      Begin VB.Label Label8 
         Caption         =   "�N"
         Height          =   255
         Index           =   6
         Left            =   2640
         TabIndex        =   12
         Top             =   1260
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   7
         Left            =   3480
         TabIndex        =   11
         Top             =   1260
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "��"
         Height          =   255
         Index           =   8
         Left            =   4380
         TabIndex        =   10
         Top             =   1260
         Width           =   255
      End
      Begin VB.Label Label2 
         Caption         =   "�I�����t(&E):"
         Height          =   255
         Index           =   1
         Left            =   780
         TabIndex        =   9
         Top             =   1260
         Width           =   1095
      End
      Begin VB.Label orgLabel 
         Caption         =   "�N���A���鐿�����f�[�^�����͈͂��w�肵�Ă��������B"
         Height          =   315
         Left            =   300
         TabIndex        =   8
         Top             =   360
         Width           =   4635
      End
   End
   Begin VB.CheckBox chkOrg 
      Caption         =   "�c�̐����̍������M���߂��N���A����(&O)"
      Height          =   315
      Left            =   780
      TabIndex        =   0
      Top             =   1500
      Width           =   4335
   End
   Begin VB.Label Label3 
      Caption         =   "�w�肳�ꂽ���t�̒��ߓ����N���A���܂��B"
      Height          =   255
      Left            =   840
      TabIndex        =   26
      Top             =   300
      Width           =   4935
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   300
      Picture         =   "frmClearCloseDate.frx":0099
      Top             =   180
      Width           =   480
   End
   Begin VB.Label Label1 
      Caption         =   "���[���t(&D):"
      Height          =   255
      Left            =   840
      TabIndex        =   25
      Top             =   960
      Width           =   1095
   End
   Begin VB.Label Label8 
      Caption         =   "���쐬�f�[�^�̒��ߏ����N���A���܂��B"
      Height          =   255
      Index           =   3
      Left            =   4440
      TabIndex        =   24
      Top             =   960
      Width           =   3255
   End
   Begin VB.Label Label8 
      Caption         =   "��"
      Height          =   255
      Index           =   1
      Left            =   3540
      TabIndex        =   23
      Top             =   960
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "�N"
      Height          =   255
      Index           =   0
      Left            =   2700
      TabIndex        =   22
      Top             =   960
      Width           =   255
   End
End
Attribute VB_Name = "frmClearCloseDate"
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

    Dim objZaimu            As Object       '�����A�g�A�N�Z�X�p
    Dim strInsDate          As String
    Dim strStrCloseDate     As String
    Dim strEndCloseDate     As String
    Dim blnRet              As Boolean

    '���͒l�̃`�F�b�N
    If CheckValue(strInsDate, strStrCloseDate, strEndCloseDate) = False Then Exit Sub
    
    If MsgBox("�w�肳�ꂽ���t�̒��߃N���A���s���܂��B��낵���ł����H", vbQuestion + vbYesNo + vbDefaultButton2) = vbNo Then Exit Sub
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    '���ߏ��̃N���A
    If chkOrg.Value = vbUnchecked Then
        blnRet = objZaimu.ClearCloseDate(CDate(strInsDate))
    Else
        blnRet = objZaimu.ClearCloseDate(CDate(strInsDate), strStrCloseDate, strEndCloseDate)
    End If
    
    Set objZaimu = Nothing
    
    If blnRet Then
        MsgBox "�N���A����܂����B" & vbLf & "���ɍ쐬���ꂽ�����f�[�^���Y�ꂸ�ɍ폜���Ă��������B" & vbLf & "�i�������M�f�[�^�͍폜���Ă����x�n�j�{�^���������Ȃ��Ə����܂���j", vbInformation, Me.Caption
        Unload Me
    Else
        MsgBox "�N���A�������ُ�I�����܂����B", vbInformation, Me.Caption
    End If
    
End Sub


Private Function CheckValue(strInsDate As String, _
                            strStrCloseDate As String, _
                            strEndCloseDate As String) As Boolean

    Dim strTargetDate   As String

    CheckValue = False
    
    '���t�̐������`�F�b�N
    strTargetDate = cboYear.ListIndex + 2002
    strTargetDate = strTargetDate & "/" & Format((cboMonth.ListIndex + 1), "00")
    strTargetDate = strTargetDate & "/" & Format((cboDay.ListIndex + 1), "00")
    
    If IsDate(strTargetDate) = False Then
        MsgBox "���������t���w�肵�Ă��������B", vbExclamation, Me.Caption
        cboDay.SetFocus
        Exit Function
    End If
    
    '�����ɒl�Z�b�g
    strInsDate = strTargetDate

    '�c�̒��ߏ������ΏۂłȂ��Ȃ�A�����I��
    If chkOrg.Value = vbUnchecked Then
        CheckValue = True
        Exit Function
    End If
    
    '�J�n���t�i�c�̒��ߏ����j�̐������`�F�b�N
    strTargetDate = cboStrYear.ListIndex + 2002
    strTargetDate = strTargetDate & "/" & Format((cboStrMonth.ListIndex + 1), "00")
    strTargetDate = strTargetDate & "/" & Format((cboStrDay.ListIndex + 1), "00")
    
    If IsDate(strTargetDate) = False Then
        MsgBox "�������J�n���t���w�肵�Ă��������B", vbExclamation, Me.Caption
        cboStrDay.SetFocus
        Exit Function
    End If
    
    '�����ɒl�Z�b�g
    strStrCloseDate = strTargetDate
    
    '�I�����t�i�c�̒��ߏ����j�̐������`�F�b�N
    strTargetDate = cboEndYear.ListIndex + 2002
    strTargetDate = strTargetDate & "/" & Format((cboEndMonth.ListIndex + 1), "00")
    strTargetDate = strTargetDate & "/" & Format((cboEndDay.ListIndex + 1), "00")
    
    If IsDate(strTargetDate) = False Then
        MsgBox "�������I�����t���w�肵�Ă��������B", vbExclamation, Me.Caption
        cboEndDay.SetFocus
        Exit Function
    End If
    
    '�����ɒl�Z�b�g
    strEndCloseDate = strTargetDate
    
    CheckValue = True
    
End Function

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

