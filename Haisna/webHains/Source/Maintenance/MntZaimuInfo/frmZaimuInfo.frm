VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmZaimuInfo 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�����A�g���׏��C��"
   ClientHeight    =   6645
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7860
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
   Icon            =   "frmZaimuInfo.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6645
   ScaleWidth      =   7860
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin TabDlg.SSTab tabMain 
      Height          =   6075
      Left            =   120
      TabIndex        =   37
      Top             =   60
      Width           =   7635
      _ExtentX        =   13467
      _ExtentY        =   10716
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "�����A�g���"
      TabPicture(0)   =   "frmZaimuInfo.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "fraMain(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "��������p�⑫���"
      TabPicture(1)   =   "frmZaimuInfo.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraMain(1)"
      Tab(1).ControlCount=   1
      Begin VB.Frame fraMain 
         Caption         =   "��������p"
         Height          =   5235
         Index           =   1
         Left            =   -74820
         TabIndex        =   42
         Top             =   540
         Width           =   7215
         Begin VB.TextBox txtCount_NIP 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   1500
            MaxLength       =   8
            TabIndex        =   34
            Text            =   "88888888"
            Top             =   1080
            Width           =   915
         End
         Begin VB.TextBox txtTekiyou_NIP 
            Height          =   315
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1500
            MaxLength       =   120
            TabIndex        =   32
            Text            =   "88888888"
            Top             =   720
            Width           =   5115
         End
         Begin VB.TextBox txtSyubetsu_NIP 
            Height          =   315
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1500
            MaxLength       =   120
            TabIndex        =   30
            Text            =   "88888888"
            Top             =   360
            Width           =   5115
         End
         Begin VB.Label Label3 
            Caption         =   "����(&M):"
            Height          =   195
            Index           =   14
            Left            =   240
            TabIndex        =   33
            Top             =   1140
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "�E�v(&M):"
            Height          =   195
            Index           =   13
            Left            =   240
            TabIndex        =   31
            Top             =   780
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "���(&M):"
            Height          =   195
            Index           =   12
            Left            =   240
            TabIndex        =   29
            Top             =   420
            Width           =   1275
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "�A�g���"
         Height          =   5295
         Index           =   0
         Left            =   180
         TabIndex        =   13
         Top             =   540
         Width           =   7215
         Begin VB.CommandButton cmdOrg 
            Caption         =   "������c��(&O)..."
            Height          =   315
            Left            =   120
            TabIndex        =   8
            Top             =   1620
            Width           =   1575
         End
         Begin VB.TextBox txtOrgCd 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   1800
            MaxLength       =   10
            TabIndex        =   9
            Text            =   "XXXXX"
            Top             =   1620
            Width           =   1395
         End
         Begin VB.TextBox txtOrgName 
            Height          =   315
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1800
            MaxLength       =   30
            TabIndex        =   11
            Text            =   "�x�m�ʊ������"
            Top             =   2040
            Width           =   5115
         End
         Begin VB.ComboBox cboTekiyou 
            Height          =   300
            Left            =   1800
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   16
            Top             =   2880
            Width           =   5115
         End
         Begin VB.TextBox txtTekiyouName 
            Height          =   315
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1800
            MaxLength       =   30
            TabIndex        =   18
            Text            =   "�x�m�ʑ��Y�@��92���@�茒�`"
            Top             =   3300
            Width           =   5115
         End
         Begin VB.TextBox txtPrice 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   1800
            MaxLength       =   8
            TabIndex        =   24
            Text            =   "88888888"
            Top             =   4620
            Width           =   915
         End
         Begin VB.ComboBox cboShubetsu 
            Height          =   300
            Left            =   1800
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   22
            Top             =   4140
            Width           =   5115
         End
         Begin VB.TextBox txtTaxPrice 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   3720
            MaxLength       =   8
            TabIndex        =   26
            Text            =   "88888888"
            Top             =   4620
            Width           =   915
         End
         Begin VB.TextBox txtTax 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   5700
            MaxLength       =   2
            TabIndex        =   28
            Text            =   "5"
            Top             =   4620
            Width           =   315
         End
         Begin VB.ComboBox cboDay 
            Height          =   300
            ItemData        =   "frmZaimuInfo.frx":0044
            Left            =   3720
            List            =   "frmZaimuInfo.frx":004B
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   5
            Top             =   780
            Width           =   555
         End
         Begin VB.ComboBox cboMonth 
            Height          =   300
            ItemData        =   "frmZaimuInfo.frx":0053
            Left            =   2820
            List            =   "frmZaimuInfo.frx":005A
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   4
            Top             =   780
            Width           =   555
         End
         Begin VB.ComboBox cboYear 
            Height          =   300
            ItemData        =   "frmZaimuInfo.frx":0062
            Left            =   1800
            List            =   "frmZaimuInfo.frx":0069
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   3
            Top             =   780
            Width           =   735
         End
         Begin VB.TextBox txtSysCd 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   1800
            MaxLength       =   2
            TabIndex        =   1
            Text            =   "05"
            Top             =   360
            Width           =   315
         End
         Begin VB.ComboBox cboCsCd 
            Height          =   300
            Left            =   1800
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   14
            Top             =   2460
            Width           =   5115
         End
         Begin VB.OptionButton optKanendo 
            Caption         =   "�ߔN�x(&N)"
            Height          =   255
            Index           =   1
            Left            =   3360
            TabIndex        =   7
            Top             =   1200
            Width           =   1335
         End
         Begin VB.OptionButton optKanendo 
            Caption         =   "���N�x(&T)"
            Height          =   255
            Index           =   0
            Left            =   1800
            TabIndex        =   6
            Top             =   1200
            Value           =   -1  'True
            Width           =   1335
         End
         Begin VB.ComboBox cboKbn 
            Height          =   300
            Left            =   1800
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   20
            Top             =   3720
            Width           =   5115
         End
         Begin VB.Label Label3 
            Caption         =   "�����於��(&N):"
            Height          =   195
            Index           =   0
            Left            =   300
            TabIndex        =   10
            Top             =   2100
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "�K�p�R�[�h(&T):"
            Height          =   195
            Index           =   1
            Left            =   300
            TabIndex        =   15
            Top             =   2940
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "�K�p����(&K):"
            Height          =   195
            Index           =   2
            Left            =   300
            TabIndex        =   17
            Top             =   3360
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "���z(&M):"
            Height          =   195
            Index           =   3
            Left            =   300
            TabIndex        =   23
            Top             =   4680
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "�敪:"
            Height          =   195
            Index           =   4
            Left            =   300
            TabIndex        =   19
            Top             =   3780
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "���(&S):"
            Height          =   195
            Index           =   5
            Left            =   300
            TabIndex        =   21
            Top             =   4200
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "�Ŋz(&X):"
            Height          =   195
            Index           =   6
            Left            =   2940
            TabIndex        =   25
            Top             =   4680
            Width           =   735
         End
         Begin VB.Label Label3 
            Caption         =   "�ŗ�(&P):"
            Height          =   195
            Index           =   7
            Left            =   4920
            TabIndex        =   27
            Top             =   4680
            Width           =   735
         End
         Begin VB.Label Label3 
            Caption         =   "%"
            Height          =   195
            Index           =   8
            Left            =   6060
            TabIndex        =   41
            Top             =   4680
            Width           =   195
         End
         Begin VB.Label Label8 
            Caption         =   "��"
            Height          =   255
            Index           =   3
            Left            =   4320
            TabIndex        =   40
            Top             =   840
            Width           =   255
         End
         Begin VB.Label Label8 
            Caption         =   "��"
            Height          =   255
            Index           =   1
            Left            =   3420
            TabIndex        =   39
            Top             =   840
            Width           =   255
         End
         Begin VB.Label Label8 
            Caption         =   "�N"
            Height          =   255
            Index           =   0
            Left            =   2580
            TabIndex        =   38
            Top             =   840
            Width           =   255
         End
         Begin VB.Label Label3 
            Caption         =   "������(&D):"
            Height          =   195
            Index           =   9
            Left            =   300
            TabIndex        =   2
            Top             =   840
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "�V�X�e�����(&Y):"
            Height          =   195
            Index           =   10
            Left            =   300
            TabIndex        =   0
            Top             =   420
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "�R�[�X�R�[�h(&C):"
            Height          =   195
            Index           =   11
            Left            =   300
            TabIndex        =   12
            Top             =   2520
            Width           =   1275
         End
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   6420
      TabIndex        =   36
      Top             =   6240
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4980
      TabIndex        =   35
      Top             =   6240
      Width           =   1335
   End
End
Attribute VB_Name = "frmZaimuInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const CSVFILENAME       As String = "tekiyoDB.csv"
Private Const KEY_PREFIX        As String = "K"         '�R���N�V�����p�L�[�v���t�B�b�N�X

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����
Private mcolTekiyouCollection   As Collection   '�K�p�R�[�h�̃R���N�V����
Private mobjZaimuCsv            As ZaimuCsv
Private mstrInitialDate         As String       '�����\�����t
Private mblnUpdated             As Boolean
Private mblnModeNew             As Boolean
Private mstrCsCd()              As String

Friend Property Let InitialDate(ByVal vNewValue As String)

    mstrInitialDate = vNewValue

End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Friend Property Let ParaZaimuCsv(ByVal vntNewValue As Object)

    Set mobjZaimuCsv = vntNewValue
    
End Property

Friend Property Let TekiyouCollection(ByVal vntNewValue As Collection)

    Set mcolTekiyouCollection = vntNewValue
    
End Property

Friend Property Get ParaZaimuCsv() As Object

    Set ParaZaimuCsv = mobjZaimuCsv

End Property

Friend Property Let Mode(ByVal vntNewValue As Boolean)

    mblnModeNew = vntNewValue
    
End Property

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()
    
    If Screen.MousePointer <> vbDefault Then Exit Sub
    Screen.MousePointer = vbHourglass
    
    '���̓`�F�b�N
    If CheckValue() = False Then
        Screen.MousePointer = vbDefault
        Exit Sub
    End If
    
    '�f�[�^�Z�b�g
    Call SetDataToObject

    Screen.MousePointer = vbDefault
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
Private Function CheckValue() As Boolean

    Dim strYY       As String
    Dim strMM       As String
    Dim strDD       As String
    
    CheckValue = False
    
    strYY = cboYear.ListIndex + 2002
    strMM = Format((cboMonth.ListIndex + 1), "00")
    strDD = Format((cboDay.ListIndex + 1), "00")
        
    If Trim(txtSysCd) = "" Then
        MsgBox "�V�X�e����ʃR�[�h���w�肵�Ă��������B", vbExclamation, Me.Caption
        txtSysCd.SetFocus
        Exit Function
    End If
        
    If Trim(txtSysCd) <> "05" Then
        MsgBox "�V�X�e����ʃR�[�h��""05""�Œ�ł��B�B", vbExclamation, Me.Caption
        txtSysCd.SetFocus
        Exit Function
    End If
        
    If IsDate(strYY & "/" & strMM & "/" & strDD) = False Then
        MsgBox "���������t���w�肵�Ă��������B", vbExclamation, Me.Caption
        cboYear.SetFocus
        Exit Function
    End If
    
    If Trim(txtOrgCd.Text) = "" Then
        MsgBox "�c�̃R�[�h���w�肵�Ă��������B", vbExclamation, Me.Caption
        txtOrgCd.SetFocus
        Exit Function
    End If
    
    If Trim(txtOrgName.Text) = "" Then
        MsgBox "�����於�̂��w�肵�Ă��������B", vbExclamation, Me.Caption
        txtOrgName.SetFocus
        Exit Function
    End If
    
    If Trim(txtTekiyouName.Text) = "" Then
        MsgBox "�K�p���̂��w�肵�Ă��������B", vbExclamation, Me.Caption
        txtTekiyouName.SetFocus
        Exit Function
    End If
    
    If Trim(txtPrice.Text) = "" Then
        MsgBox "���z���w�肵�Ă��������B", vbExclamation, Me.Caption
        txtPrice.SetFocus
        Exit Function
    End If
    
    If IsNumeric(txtPrice.Text) = False Then
        MsgBox "���z�ɂ͐��l���w�肵�Ă��������B", vbExclamation, Me.Caption
        txtPrice.SetFocus
        Exit Function
    End If
    
    If Trim(txtTaxPrice.Text) = "" Then
        MsgBox "�Ŋz���w�肵�Ă��������B", vbExclamation, Me.Caption
        txtTaxPrice.SetFocus
        Exit Function
    End If
    
    If IsNumeric(txtTaxPrice.Text) = False Then
        MsgBox "�Ŋz�ɂ͐��l���w�肵�Ă��������B", vbExclamation, Me.Caption
        txtTaxPrice.SetFocus
        Exit Function
    End If
    
    If Trim(txtTax.Text) = "" Then
        MsgBox "�ŗ����w�肵�Ă��������B", vbExclamation, Me.Caption
        txtTax.SetFocus
        Exit Function
    End If
    
    If IsNumeric(txtTax.Text) = False Then
        MsgBox "�ŗ��ɂ͐��l���w�肵�Ă��������B", vbExclamation, Me.Caption
        txtTax.SetFocus
        Exit Function
    End If
    
    CheckValue = True
    
End Function

Private Sub cmdOrg_Click()

    Dim objCommonGuide  As mntCommonGuide.CommonGuide   '���ڃK�C�h�\���p
    Dim i               As Long     '�C���f�b�N�X
    Dim intRecordCount  As Integer
    Dim vntCode         As Variant
    Dim vntName         As Variant
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCommonGuide = New mntCommonGuide.CommonGuide
    
    With objCommonGuide
        .MultiSelect = False
        .TargetTable = getZaimuOrg
    
        '�����K�p�R�[�h�K�C�h��ʂ��J��
        .Show vbModal
    
        intRecordCount = .RecordCount
        vntCode = .RecordCode
        vntName = .RecordName
    
    End With

    '�I��������0���ȏ�Ȃ�
    If intRecordCount > 0 Then
    
        txtOrgCd.Text = vntCode(0)
        txtOrgName.Text = vntName(0)
    
    End If

    Set objCommonGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Sub Form_Load()

    Dim intListIndex    As Integer
    Dim i               As Integer

    '�t�H�[��������
    Call InitializeForm
    
    '�X�V���[�h�̏ꍇ�A�f�[�^�Z�b�g
    If mblnModeNew = False Then
    
        With mobjZaimuCsv
            
            txtSysCd.Text = .SysCd
            cboYear.ListIndex = CLng(.ZaimuYY) - 2002
            cboMonth.ListIndex = CLng(Mid(.ZaimuMMDD, 1, 2)) - 1
            cboDay.ListIndex = CLng(Mid(.ZaimuMMDD, 3, 2)) - 1
            
            optKanendo(CInt(.Kanendo)).Value = True
            
            txtOrgCd.Text = .OrgCd
            txtOrgName.Text = .OrgName
            
            For i = 0 To UBound(mstrCsCd)
                If mstrCsCd(i) = .CsCd Then
                    cboCsCd.ListIndex = i
                    Exit For
                End If
            Next i
            
            intListIndex = GetListIndexFromTekiyouCollection(.TekiyouCd)
            If intListIndex > -1 Then
                cboTekiyou.ListIndex = intListIndex
            End If
            
            txtTekiyouName.Text = .TekiyouName
            txtPrice.Text = .Price
            cboKbn.ListIndex = .Kubun - 1

            cboShubetsu.ListIndex = .Shubetsu - 1
            
            txtTaxPrice.Text = .TaxPrice
            txtTax = .Tax
        
            txtSyubetsu_NIP = .Syubetsu_NIP
            txtTekiyou_NIP = .Tekiyou_NIP
            txtCount_NIP = .Count_NIP
        
        End With
    
    End If
    
    tabMain.Tab = 0
    Call tabMain_Click(1)
    
End Sub

Private Function GetListIndexFromTekiyouCollection(strTekiyouCd As String) As Integer

    Dim objTekiyouClass     As TekiyouClass
    
    GetListIndexFromTekiyouCollection = -1
    GetListIndexFromTekiyouCollection = mcolTekiyouCollection(KEY_PREFIX & strTekiyouCd).ListIndex

End Function

'
' �@�\�@�@ : �t�H�[��������
'
' ���l�@�@ :
'
Private Sub InitializeForm()
    
    Dim objTekiyouClass     As TekiyouClass
    Dim i                   As Integer
    Dim lngYear             As Long
    Dim lngMonth            As Long
    Dim lngDay              As Long
    Dim strWorkDate         As String
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

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

    '���t�R���{�{�b�N�X�ɒl���Z�b�g
    cboYear.Clear
    For i = 2002 To YEARRANGE_MAX
        cboYear.AddItem i
    Next i
    cboYear.ListIndex = lngYear - 2002
    
    cboMonth.Clear
    For i = 1 To 12
        cboMonth.AddItem i
    Next i
    cboMonth.ListIndex = lngMonth - 1
    
    cboDay.Clear
    For i = 1 To 31
        cboDay.AddItem i
    Next i
    cboDay.ListIndex = lngDay - 1

    '�R�[�X�R�[�h�Z�b�g
    Call EditComboFromCourse

    '��ʂ̃Z�b�g
    With cboShubetsu
        .Clear
        .AddItem "����"
        .AddItem "����"
        .AddItem "�ߋ�������"
        .AddItem "�ҕt"
        .AddItem "�ҕt������"
        .ListIndex = 0
    End With

    '�V�X�e����ʃR�[�h��05�Z�b�g
    txtSysCd.Text = "05"

    '�K�p�R�[�h���R���N�V��������Z�b�g
    cboTekiyou.Clear
    For Each objTekiyouClass In mcolTekiyouCollection
        cboTekiyou.AddItem objTekiyouClass.TekiyouName
        objTekiyouClass.ListIndex = cboTekiyou.NewIndex
    Next objTekiyouClass
    cboTekiyou.ListIndex = 0

    '�敪�Z�b�g
    With cboKbn
        .Clear
        .AddItem "�����l"
        .AddItem "�c�̐���"
        .AddItem "�d�b����"
        .AddItem "������"
        .AddItem "�G����"
    End With
    
End Sub

'
' �@�\�@�@ : �R�[�X�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditComboFromCourse()

On Error GoTo ErrorHandle

    Dim objCourse   As Object               '�R�[�X�A�N�Z�X�p
    Dim vntCsCd     As Variant              '�R�[�X�R�[�h
    Dim vntCsName   As Variant              '�R�[�X��
    Dim i           As Long                 '�C���f�b�N�X
    Dim lngCount    As Long
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName)
    
    cboCsCd.Clear
    Erase mstrCsCd
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrCsCd(i)
        
        mstrCsCd(i) = vntCsCd(i)
        cboCsCd.AddItem vntCsName(i)
        
    Next i
    
    If lngCount > 0 Then
        cboCsCd.ListIndex = 0
    End If
    
    '�I�u�W�F�N�g�p��
    Set objCourse = Nothing
            
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Sub

'
' �@�\�@�@ : �f�[�^�m�莞�̃I�u�W�F�N�g�Z�b�g
'
' ���l�@�@ :
'
Private Sub SetDataToObject()

    Dim objTekiyouClass As TekiyouClass

    If mobjZaimuCsv Is Nothing Then
        Set mobjZaimuCsv = New ZaimuCsv
    End If

    With mobjZaimuCsv
        .SysCd = txtSysCd.Text
        .ZaimuYY = cboYear.ListIndex + 2002
        .ZaimuMMDD = Format((cboMonth.ListIndex + 1), "00") & Format((cboDay.ListIndex + 1), "00")
        .OrgCd = Trim(txtOrgCd.Text)
        .OrgName = Trim(txtOrgName.Text)
        For Each objTekiyouClass In mcolTekiyouCollection
            If objTekiyouClass.ListIndex = cboTekiyou.ListIndex Then
                .TekiyouCd = objTekiyouClass.TekiyouCd
                Exit For
            End If
        Next objTekiyouClass
        .TekiyouName = Trim(txtTekiyouName.Text)
        .Price = Trim(txtPrice.Text)
        .Kubun = cboKbn.ListIndex + 1
        .Shubetsu = cboShubetsu.ListIndex + 1
        .TaxPrice = Trim(txtTaxPrice.Text)
        .Tax = Trim(txtTax.Text)
        .CsCd = mstrCsCd(cboCsCd.ListIndex)
        .Kanendo = IIf(optKanendo(0).Value = True, 0, 1)
        .Syubetsu_NIP = Trim(txtSyubetsu_NIP.Text)
        .Tekiyou_NIP = Trim(txtTekiyou_NIP)
        .Count_NIP = Trim(txtCount_NIP)
    
    End With
    
End Sub

Private Sub tabMain_Click(PreviousTab As Integer)
    
    fraMain(PreviousTab).Enabled = False
    fraMain(tabMain.Tab).Enabled = True
    
End Sub
