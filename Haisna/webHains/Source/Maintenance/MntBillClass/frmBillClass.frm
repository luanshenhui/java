VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmBillClass 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���������ރe�[�u�������e�i���X"
   ClientHeight    =   7095
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7320
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmBillClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7095
   ScaleWidth      =   7320
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin TabDlg.SSTab tabMain 
      Height          =   6435
      Left            =   120
      TabIndex        =   17
      Top             =   120
      Width           =   7095
      _ExtentX        =   12515
      _ExtentY        =   11351
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "��{���"
      TabPicture(0)   =   "frmBillClass.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Label2(2)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Frame1"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "txtBillTitle"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).ControlCount=   3
      TabCaption(1)   =   "�����ΏۃR�[�X"
      TabPicture(1)   =   "frmBillClass.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraItemMain"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).ControlCount=   1
      Begin VB.TextBox txtBillTitle 
         Height          =   318
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   2700
         MaxLength       =   60
         TabIndex        =   10
         Text            =   "���������g�Q��"
         Top             =   3300
         Width           =   3915
      End
      Begin VB.Frame fraItemMain 
         Caption         =   "���̐��������쐬���鎞�ɑΏۂƂȂ�R�[�X(&I)"
         Height          =   5595
         Left            =   -74820
         TabIndex        =   11
         Top             =   540
         Width           =   6675
         Begin VB.CommandButton cmdChangeMode 
            Caption         =   "�����Ώۏ�Ԃ̕ύX(&A)"
            Height          =   315
            Left            =   4260
            TabIndex        =   13
            Top             =   5040
            Width           =   2175
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   4260
            Left            =   180
            TabIndex        =   12
            Top             =   720
            Width           =   6315
            _ExtentX        =   11139
            _ExtentY        =   7514
            LabelEdit       =   1
            MultiSelect     =   -1  'True
            LabelWrap       =   -1  'True
            HideSelection   =   0   'False
            FullRowSelect   =   -1  'True
            _Version        =   393217
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   0
         End
         Begin VB.Label Label3 
            Caption         =   "���ڂ�I�����ă{�^���������ƑI���A��I����Ԃ��؂�ւ��܂��B"
            Height          =   255
            Left            =   240
            TabIndex        =   18
            Top             =   360
            Width           =   6075
         End
      End
      Begin VB.Frame Frame1 
         Caption         =   "��{���(&B)"
         Height          =   2355
         Left            =   180
         TabIndex        =   0
         Top             =   540
         Width           =   6675
         Begin VB.TextBox txtBillClassName 
            Height          =   318
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1920
            MaxLength       =   15
            TabIndex        =   4
            Text            =   "���������g�Q��"
            Top             =   660
            Width           =   2775
         End
         Begin VB.TextBox txtBillClassCd 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   1920
            MaxLength       =   4
            TabIndex        =   2
            Text            =   "1324"
            Top             =   300
            Width           =   675
         End
         Begin VB.CheckBox chkOtherIncome 
            Caption         =   "���̐��������ނ͎G�����Ƃ��Ĉ���(&Z)"
            Height          =   255
            Left            =   1920
            TabIndex        =   5
            Top             =   1140
            Width           =   3195
         End
         Begin VB.CheckBox chkDefCheck 
            Caption         =   "���̐��������ނ͒c�̐V�K�o�^���Ƀf�t�H���g�Ń`�F�b�N(&O)"
            Height          =   315
            Left            =   1920
            TabIndex        =   6
            Top             =   1380
            Width           =   4575
         End
         Begin VB.TextBox txtCrfFileName 
            Height          =   318
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1920
            MaxLength       =   15
            TabIndex        =   8
            Text            =   "���������g�Q��"
            Top             =   1740
            Width           =   2895
         End
         Begin VB.Label Label2 
            Caption         =   "���������ޖ�(&N):"
            Height          =   195
            Index           =   0
            Left            =   240
            TabIndex        =   3
            Top             =   720
            Width           =   1455
         End
         Begin VB.Label Label1 
            Caption         =   "���������ރR�[�h(&C):"
            Height          =   195
            Index           =   2
            Left            =   240
            TabIndex        =   1
            Top             =   360
            Width           =   1635
         End
         Begin VB.Label Label2 
            Caption         =   "���[�t�@�C����(&P):"
            Height          =   195
            Index           =   1
            Left            =   240
            TabIndex        =   7
            Top             =   1800
            Width           =   1455
         End
      End
      Begin VB.Label Label2 
         Caption         =   "���ې������󏑗p�^�C�g��(&T):"
         Height          =   195
         Index           =   2
         Left            =   420
         TabIndex        =   9
         Top             =   3360
         Width           =   2235
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4560
      TabIndex        =   15
      Top             =   6660
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3180
      TabIndex        =   14
      Top             =   6660
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   5940
      TabIndex        =   16
      Top             =   6660
      Width           =   1275
   End
End
Attribute VB_Name = "frmBillClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�v���p�e�B�p�̈�
Private mstrBillClassCd     As String   '���������ރR�[�h
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s

'���W���[���ŗL�̈�̈�
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����
Private mstrClassCd()           As String       '�������ރR�[�h�i�z��́A�R���{�{�b�N�X�ƑΉ��j

Const mstrListViewKey   As String = "K"

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property

' @(e)
'
' �@�\�@�@ : �u�K�p�v�N���b�N
'
' �����@�@ : �Ȃ�
'
' �@�\���� : ���͓��e��K�p����B��ʂ͕��Ȃ�
'
' ���l�@�@ :
'
Private Sub cmdApply_Click()
    
    '�f�[�^�K�p�������s��
    Call ApplyData

End Sub


Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : ��{���������ޏ���ʕ\��
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���������ނ̊�{������ʂɕ\������
'
' ���l�@�@ :
'
Private Function EditBillClass() As Boolean

    Dim objBillClass        As Object       '���������ޏ��A�N�Z�X�p
    
    Dim vntBillClassName    As Variant
    Dim vntDefCheck         As Variant
    Dim vntOtherIncome      As Variant
    Dim vntCrfFileName      As Variant
    Dim vntBillTitle        As Variant

    Dim vntCsCd             As Variant
    Dim vntCsName           As Variant

    Dim objHeader           As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim lngCount            As Long                 '���R�[�h��
    Dim Ret                 As Boolean      '�߂�l
    Dim i                   As Integer
    
    EditBillClass = False
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objBillClass = CreateObject("HainsDmdClass.DmdClass")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrBillClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '���������ރe�[�u�����R�[�h�ǂݍ���
        If objBillClass.SelectBillClass(mstrBillClassCd, _
                                        vntBillClassName, _
                                        vntDefCheck, _
                                        vntOtherIncome, _
                                        vntCrfFileName, _
                                        vntBillTitle) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW�i�R�[�X��{���j
        txtBillClassCd.Text = mstrBillClassCd
        txtBillClassName.Text = vntBillClassName
        If vntDefCheck = "1" Then chkDefCheck.Value = vbChecked
        If vntOtherIncome = "1" Then chkOtherIncome.Value = vbChecked
        txtCrfFileName.Text = vntCrfFileName
        txtBillTitle.Text = vntBillTitle
        
        '���������ފǗ��R�[�X�̓ǂݍ���
        lngCount = objBillClass.SelectBillClass_cList(mstrBillClassCd, vntCsCd, vntCsName)
    
        '�����ΏۃR�[�X�̕ҏW
        For i = 0 To lngCount - 1

            Set objItem = lsvItem.ListItems(mstrListViewKey & vntCsCd(i))
            objItem.SubItems(2) = "�����Ώ�"

        Next i

        '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
        If lsvItem.ListItems.Count > 0 Then
            lsvItem.ListItems(1).Selected = False
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditBillClass = Ret
    
    Set objBillClass = Nothing
    Exit Function

ErrorHandle:

    EditBillClass = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub cmdDownItem_Click()
    
    Call MoveListItem(1)

End Sub

' @(e)
'
' �@�\�@�@ : �R�[�X�Ǘ���Ԃ̕ύX
'
' �����@ �@: TRUE:�Ǘ�����AFALSE:�Ǘ�����͂���
'
' �@�\���� : �\��g���R�[�X���ڂ̊Ǘ���Ԃ�ύX����
'
' ���l�@�@ :
'
Private Sub ChangeItemMode()

    Dim i As Integer
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvItem.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ珈��
        If lsvItem.ListItems(i).Selected = True Then
            If lsvItem.ListItems(i).SubItems(2) <> "" Then
                lsvItem.ListItems(i).SubItems(2) = ""
            Else
                lsvItem.ListItems(i).SubItems(2) = "�����Ώ�"
            End If
        End If
    
    Next i

End Sub

Private Sub cmdChangeMode_Click()
    
    Call ChangeItemMode

End Sub

' @(e)
'
' �@�\�@�@ : �u�n�j�v�N���b�N
'
' �����@�@ : �Ȃ�
'
' �@�\���� : ���͓��e��K�p���A��ʂ����
'
' ���l�@�@ :
'
Private Sub CMDok_Click()
    
    '�f�[�^�K�p�������s���i�G���[���͉�ʂ���Ȃ��j
    If ApplyData() = False Then
        Exit Sub
    End If

    '��ʂ����
    Unload Me
    
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
        
        '���������ރe�[�u���̓o�^
        If RegistBillClass() = False Then Exit Do
        
        '�X�V�ς݂ɂ���
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault
    

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
    
    '��������
    Ret = False
    
    Do
        
        If Trim(txtBillClassCd.Text) = "" Then
            MsgBox "���������ރR�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            txtBillClassCd.SetFocus
            Exit Do
        End If

        If Trim(txtBillClassName.Text) = "" Then
            MsgBox "���������ޖ������͂���Ă��܂���B", vbExclamation, App.Title
            txtBillClassName.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

' @(e)
'
' �@�\�@�@ : ���������ފ�{���̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e�𐿋������ރe�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistBillClass() As Boolean

On Error GoTo ErrorHandle

    Dim objBillClass    As Object     '���������ރA�N�Z�X�p
    Dim strCrfFileName  As String
    Dim lngRet          As Long
    
    Dim i               As Integer
    Dim j               As Integer
    Dim k               As Integer
    Dim intItemCount    As Integer
    
    Dim vntCsCd()       As Variant
    
    Dim strWorkKey      As String
    Dim strCsCd         As String
    Dim strSuffix       As String
    
    RegistBillClass = False

    intItemCount = 0
    Erase vntCsCd
    j = 0

    '���������ޓ��������ڂ̔z��쐬
    For i = 1 To lsvItem.ListItems.Count
        
        If lsvItem.ListItems(i).SubItems(2) <> "" Then
            ReDim Preserve vntCsCd(j)
            vntCsCd(j) = lsvItem.ListItems(i).Text
            intItemCount = intItemCount + 1
            j = j + 1
        End If
    
    Next i

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objBillClass = CreateObject("HainsDmdClass.DmdClass")

    '���������ރe�[�u�����R�[�h�̓o�^
    lngRet = objBillClass.RegistBillClass_All(IIf(txtBillClassCd.Enabled, "INS", "UPD"), _
                                              Trim(txtBillClassCd.Text), _
                                              Trim(txtBillClassName.Text), _
                                              IIf(chkDefCheck.Value = vbChecked, 1, 0), _
                                              IIf(chkOtherIncome.Value = vbChecked, 1, 0), _
                                              Trim(txtCrfFileName.Text), _
                                              intItemCount, _
                                              vntCsCd, _
                                              Trim(txtBillTitle.Text))
    
    If lngRet = 0 Then
        MsgBox "���͂��ꂽ���������ރR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        Exit Function
    End If
    
    mstrBillClassCd = Trim(txtBillClassCd.Text)
    txtBillClassCd.Enabled = (txtBillClassCd.Text = "")
    
    Set objBillClass = Nothing
    RegistBillClass = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objBillClass = Nothing
    RegistBillClass = False
    
End Function

' @(e)
'
' �@�\�@�@ : �u�t�H�[���vLoad
'
' �@�\���� : �t�H�[���̏����\�����s��
'
' ���l�@�@ :
'
Private Sub Form_Load()

    Dim Ret As Boolean  '�߂�l
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)      '�g�p�R���g���[��������

    tabMain.Tab = 0
    
    Do
        '�R�[�X�ꗗ�̕ҏW
        If EditCourseItem() = False Then
            Exit Do
        End If
        
        '���������ޏ��̕\���ҏW
        If EditBillClass() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtBillClassCd.Enabled = (txtBillClassCd.Text = "")
        
        Ret = True
        Exit Do
    
    Loop
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' �@�\�@�@ : �R�[�X�ꗗ�\��
'
' �@�\���� : �R�[�X��\������B
'
' ���l�@�@ :
'
Private Function EditCourseItem() As Boolean
    
On Error GoTo ErrorHandle

    Dim objCourse       As Object               '
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntCsCd         As Variant              '�R�[�X�R�[�h
    Dim vntCsName       As Variant              '�R�[�X��
    Dim lngCount        As Long                 '���R�[�h��
    Dim strItemKey      As String               '���X�g�r���[�p�A�C�e���L�[
    Dim strItemCodeString As String             '�\���p�L�[�ҏW�̈�
    
    Dim i               As Long                 '�C���f�b�N�X

    EditCourseItem = False

    '���X�g�A�C�e���N���A
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    
    '�R�[�X�ꗗ�擾�i���C���̂݁j
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName, , 3)

    '�w�b�_�̕ҏW
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�R�[�X�R�[�h", 1000, lvwColumnLeft
        .Add , , "�R�[�X����", 2000, lvwColumnLeft
        .Add , , "�����Ώ�", 2000, lvwColumnLeft
    End With
        
    lsvItem.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, mstrListViewKey & vntCsCd(i), vntCsCd(i))
        objItem.SubItems(1) = vntCsName(i)
        objItem.SubItems(2) = ""
    Next i
    
    '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    EditCourseItem = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Friend Property Get BillClassCd() As Variant

    BillClassCd = mstrBillClassCd
    
End Property

Friend Property Let BillClassCd(ByVal vNewValue As Variant)
    
    mstrBillClassCd = vNewValue

End Property

' @(e)
'
' �@�\�@�@ : ��f���ڈꗗ�J�����N���b�N
'
' �@�\���� : �N���b�N���ꂽ�J�������ڂ�Sort���s��
'
' ���l�@�@ :
'
Private Sub lsvItem_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    
    '�}�E�X�|�C���^�������v�̂Ƃ��͓��͖���
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    With lsvItem
        .SortKey = ColumnHeader.Index - 1
        .Sorted = True
        .SortOrder = IIf(.SortOrder = lvwAscending, lvwDescending, lvwAscending)
    End With

End Sub



' @(e)
'
' �@�\�@�@ : �I�����ڂ̈ړ�
'
' �����@�@ : (In)   intMovePosition �ړ������i-1:���ցA1:������ցj
'
' �@�\���� : ���X�g�r���[��̍��ڂ��ړ�������
'
' ���l�@�@ :
'
Private Sub MoveListItem(intMovePosition As Integer)

    Dim i                   As Integer
    Dim j                   As Integer
    Dim objItem             As ListItem
    
    Dim intSelectedCount    As Integer
    Dim intSelectedIndex    As Integer
    Dim intTargetIndex      As Integer
    Dim intScrollPoint      As Integer
    
    Dim strEscKey()         As String
    Dim strEscCd()          As String
    Dim strEscName()        As String
    Dim strEscClassName()   As String
    
    intSelectedCount = 0

    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count

        '�I������Ă��鍀�ڂȂ�
        If lsvItem.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '�I�����ڐ����P�ȊO�Ȃ珈�����Ȃ�
    If intSelectedCount <> 1 Then Exit Sub
    
    '����Up�w�肩�A�I�����ڂ��擪�Ȃ牽�����Ȃ�
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '����Down�w�肩�A�I�����ڂ��ŏI�Ȃ牽�����Ȃ�
    If (intSelectedIndex = lsvItem.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    If intMovePosition = -1 Then
        '����Up�̏ꍇ�A��O�̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex - 1
    Else
        '����Down�̏ꍇ�A���݂̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex
    End If
    
    '���ݕ\����̐擪Index���擾
    intScrollPoint = lsvItem.GetFirstVisible.Index
    
    '���X�g�r���[�����邭��񂵂đS���ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        ReDim Preserve strEscKey(i)
        ReDim Preserve strEscCd(i)
        ReDim Preserve strEscName(i)
        ReDim Preserve strEscClassName(i)
        
        '�����Ώ۔z��ԍ�������
        If intTargetIndex = i Then
        
            '���ڑޔ�
            strEscKey(i) = lsvItem.ListItems(i + 1).Key
            strEscCd(i) = lsvItem.ListItems(i + 1)
            strEscName(i) = lsvItem.ListItems(i + 1).SubItems(1)
            strEscClassName(i) = lsvItem.ListItems(i + 1).SubItems(2)
        
            i = i + 1
        
            ReDim Preserve strEscKey(i)
            ReDim Preserve strEscCd(i)
            ReDim Preserve strEscName(i)
            ReDim Preserve strEscClassName(i)
        
            strEscKey(i) = lsvItem.ListItems(intTargetIndex).Key
            strEscCd(i) = lsvItem.ListItems(intTargetIndex)
            strEscName(i) = lsvItem.ListItems(intTargetIndex).SubItems(1)
            strEscClassName(i) = lsvItem.ListItems(intTargetIndex).SubItems(2)
        
        Else
            strEscKey(i) = lsvItem.ListItems(i).Key
            strEscCd(i) = lsvItem.ListItems(i)
            strEscName(i) = lsvItem.ListItems(i).SubItems(1)
            strEscClassName(i) = lsvItem.ListItems(i).SubItems(2)
        
        End If
    
    Next i
    
    lsvItem.ListItems.Clear
    
    '�w�b�_�̕ҏW
    With lsvItem.ColumnHeaders
        .Clear
        .Add , , "�R�[�h", 1000, lvwColumnLeft
        .Add , , "����", 2000, lvwColumnLeft
        .Add , , "��������", 1200, lvwColumnLeft
    End With
    
    '���X�g�̕ҏW
    For i = 1 To UBound(strEscKey)
        Set objItem = lsvItem.ListItems.Add(, strEscKey(i), strEscCd(i))
        objItem.SubItems(1) = strEscName(i)
        objItem.SubItems(2) = strEscClassName(i)
    Next i

    lsvItem.ListItems(1).Selected = False
    
    '�ړ��������ڂ�I�������A�ړ��i�X�N���[���j������
    If intMovePosition = 1 Then
        lsvItem.ListItems(intTargetIndex + 1).Selected = True
    Else
        lsvItem.ListItems(intTargetIndex).Selected = True
    End If

    '�I������Ă��鍀�ڂ�\������
    lsvItem.SelectedItem.EnsureVisible

    lsvItem.SetFocus

End Sub

Private Sub lsvItem_DblClick()

    Call ChangeItemMode

End Sub

Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)
    
    Dim i As Long

    'CTRL+A���������ꂽ�ꍇ�A���ڂ�S�đI������
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem.ListItems.Count
            lsvItem.ListItems(i).Selected = True
        Next i
    End If

End Sub


Private Sub TabStrip1_Click()

End Sub

