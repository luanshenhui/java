VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmSecurityPgmGrp 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�Z�L�����e�B�[�O���[�v�ʃv���O����"
   ClientHeight    =   8010
   ClientLeft      =   525
   ClientTop       =   1305
   ClientWidth     =   8490
   Icon            =   "frmSecurityPgmGrp.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8010
   ScaleWidth      =   8490
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.TextBox txtGrpCd 
      Appearance      =   0  '�ׯ�
      Height          =   273
      Index           =   1
      Left            =   6916
      TabIndex        =   25
      Top             =   1456
      Visible         =   0   'False
      Width           =   975
   End
   Begin VB.TextBox txtGrpCd 
      Appearance      =   0  '�ׯ�
      Height          =   273
      Index           =   0
      Left            =   6916
      TabIndex        =   24
      Top             =   1066
      Visible         =   0   'False
      Width           =   975
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   7020
      TabIndex        =   15
      Top             =   7462
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4260
      TabIndex        =   14
      Top             =   7462
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5640
      TabIndex        =   13
      Top             =   7462
      Width           =   1275
   End
   Begin VB.Frame Frame2 
      Caption         =   "�v���O�������X�g"
      Height          =   5343
      Left            =   130
      TabIndex        =   6
      Top             =   2002
      Width           =   8265
      Begin VB.CommandButton cmdUpdateItem 
         Caption         =   "�C��(&U)..."
         Height          =   312
         Left            =   5565
         TabIndex        =   12
         Top             =   4810
         Width           =   1245
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "�ǉ�(&A)..."
         Height          =   312
         Left            =   4290
         TabIndex        =   11
         Top             =   4810
         Width           =   1245
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "�폜(&R)"
         Height          =   312
         Left            =   6840
         TabIndex        =   10
         Top             =   4810
         Width           =   1245
      End
      Begin VB.CommandButton cmdUpItem 
         Caption         =   "��"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   182
         TabIndex        =   9
         Top             =   1482
         Width           =   315
      End
      Begin VB.CommandButton cmdDownItem 
         Caption         =   "��"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   182
         TabIndex        =   8
         Top             =   2028
         Width           =   315
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   3960
         Left            =   570
         TabIndex        =   7
         Top             =   345
         Width           =   7605
         _ExtentX        =   13414
         _ExtentY        =   6985
         LabelEdit       =   1
         MultiSelect     =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         FullRowSelect   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.Frame Frame4 
         Height          =   507
         Left            =   585
         TabIndex        =   26
         Top             =   4245
         Width           =   7575
         Begin VB.OptionButton optGrant 
            Caption         =   "���ׂ�"
            Height          =   247
            Index           =   4
            Left            =   5160
            TabIndex        =   30
            Top             =   180
            Width           =   825
         End
         Begin VB.OptionButton optGrant 
            Caption         =   "�폜"
            Height          =   247
            Index           =   3
            Left            =   4110
            TabIndex        =   29
            Top             =   182
            Width           =   705
         End
         Begin VB.OptionButton optGrant 
            Caption         =   "�o�^�A�C��"
            Height          =   247
            Index           =   2
            Left            =   2625
            TabIndex        =   28
            Top             =   182
            Width           =   1140
         End
         Begin VB.OptionButton optGrant 
            Caption         =   "�Q��"
            Height          =   247
            Index           =   1
            Left            =   1620
            TabIndex        =   27
            Top             =   182
            Width           =   675
         End
         Begin VB.Label Label1 
            AutoSize        =   -1  'True
            Caption         =   "���쌠���敪 �F"
            Height          =   165
            Index           =   2
            Left            =   225
            TabIndex        =   31
            Top             =   210
            Width           =   1155
         End
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "��{���(&B)"
      Height          =   1131
      Left            =   130
      TabIndex        =   0
      Top             =   780
      Width           =   8265
      Begin VB.TextBox txtUserGrp 
         Appearance      =   0  '�ׯ�
         Height          =   273
         Index           =   1
         Left            =   2106
         TabIndex        =   23
         Top             =   676
         Visible         =   0   'False
         Width           =   2910
      End
      Begin VB.TextBox txtUserGrp 
         Appearance      =   0  '�ׯ�
         Height          =   273
         Index           =   0
         Left            =   2106
         TabIndex        =   22
         Top             =   286
         Visible         =   0   'False
         Width           =   2910
      End
      Begin VB.ComboBox cboGrp 
         Height          =   300
         Index           =   1
         Left            =   4498
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   4
         Top             =   676
         Visible         =   0   'False
         Width           =   2145
      End
      Begin VB.ComboBox cboGrp 
         Height          =   300
         Index           =   0
         Left            =   4472
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   3
         Top             =   286
         Visible         =   0   'False
         Width           =   2145
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "�Z�L�����e�B�[�O���[�v"
         Height          =   169
         Index           =   1
         Left            =   208
         TabIndex        =   2
         Top             =   702
         Width           =   1625
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "���[�U�[�O���[�v"
         Height          =   169
         Index           =   0
         Left            =   208
         TabIndex        =   1
         Top             =   390
         Width           =   1261
      End
   End
   Begin VB.Frame Frame3 
      Height          =   559
      Left            =   130
      TabIndex        =   16
      Top             =   8710
      Visible         =   0   'False
      Width           =   6513
      Begin VB.CheckBox chkGrant 
         Caption         =   "�Q��"
         Height          =   273
         Index           =   0
         Left            =   1638
         TabIndex        =   20
         Top             =   182
         Value           =   1  '����
         Width           =   793
      End
      Begin VB.CheckBox chkGrant 
         Caption         =   "�o�^�A�C��"
         Height          =   273
         Index           =   1
         Left            =   2522
         TabIndex        =   19
         Top             =   182
         Width           =   1105
      End
      Begin VB.CheckBox chkGrant 
         Caption         =   "�폜"
         Height          =   273
         Index           =   2
         Left            =   3796
         TabIndex        =   18
         Top             =   182
         Width           =   767
      End
      Begin VB.CheckBox chkGrant 
         Caption         =   "ALL"
         Height          =   273
         Index           =   3
         Left            =   4628
         TabIndex        =   17
         Top             =   182
         Width           =   689
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "���쌠���敪 �F"
         Height          =   169
         Index           =   4
         Left            =   182
         TabIndex        =   21
         Top             =   234
         Width           =   1157
      End
   End
   Begin VB.Label LabelCourseGuide 
      Caption         =   "�v���O�����g�p�������O���[�v�Ƃ��ĂƂ�܂Ƃ߂܂��B"
      Height          =   260
      Left            =   871
      TabIndex        =   5
      Top             =   299
      Width           =   3913
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   0
      Left            =   210
      Picture         =   "frmSecurityPgmGrp.frx":000C
      Top             =   180
      Width           =   480
   End
End
Attribute VB_Name = "frmSecurityPgmGrp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�v���p�e�B�p�̈�
Public mstrUserGrpCd           As String   '
Public mstrUserGrpName         As String   '
Public mstrSecurityGrpCd       As String   '
Public mstrSecurityGrpName     As String   '
Public iMode                   As Integer
Public mblnInitialize          As Boolean  'TRUE:����ɏ������AFALSE:���������s

Private mblnUpdated             As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnShowOnly            As Boolean  'TRUE:�f�[�^�̍X�V�����Ȃ��i�Q�Ƃ̂݁j
Private mintPgmGrant            As Integer

'���W���[���ŗL�̈�̈�
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����
Private aryUserGrpCd()          As String       'User Group�i�z��́A�R���{�{�b�N�X�ƑΉ��j
Private arySecurityGrpCd()      As String       'Security Group�i�z��́A�R���{�{�b�N�X�ƑΉ��j
Private isSave                  As Boolean

Const mstrListViewKey   As String = "K"


Private Sub cboGrp_Click(Index As Integer)
    
    If Index = 0 Then
        mstrUserGrpCd = aryUserGrpCd(cboGrp(Index).ListIndex)
        txtGrpCd(Index).Text = aryUserGrpCd(cboGrp(Index).ListIndex)
    ElseIf Index = 1 Then
        mstrSecurityGrpCd = arySecurityGrpCd(cboGrp(Index).ListIndex)
        txtGrpCd(Index).Text = arySecurityGrpCd(cboGrp(Index).ListIndex)
    End If
    
End Sub



Private Sub chkGrant_Click(Index As Integer)
    Dim i   As Integer
    
    Select Case Index
        Case 3
            If chkGrant(Index).Value = 1 Then
                For i = 0 To 2
                    chkGrant(i).Value = 1
                    chkGrant(i).Enabled = False
                Next
            Else
                For i = 0 To 2
                    chkGrant(i).Value = 0
                    chkGrant(i).Enabled = True
                Next
            End If
            
        Case Else
            If chkGrant(3).Value = 1 Then Exit Sub
            If chkGrant(0).Value = 1 And chkGrant(1).Value = 1 And chkGrant(2).Value = 1 Then
                chkGrant(3).Value = 1
                Call chkGrant_Click(3)
            Else
                chkGrant(3).Value = 0
            End If
            
    End Select

End Sub

Private Sub cmdAddItem_Click()
    Dim objItemGuide        As mntPgmInfoGuide.ItemGuide    '���ڃK�C�h�\���p
    Dim objItem             As ListItem                     '���X�g�A�C�e���I�u�W�F�N�g
    Dim objHeader           As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g

    Dim i                   As Integer
    Dim strKey              As String       '�d���`�F�b�N�p�̃L�[
    Dim strItemString       As String
    Dim strItemKey          As String       '���X�g�r���[�p�A�C�e���L�[
    Dim strItemCdString     As String       '�\���p�L�[�ҏW�̈�
    
    Dim lngItemCount        As Long         '�I�����ڐ�
    Dim vntPgmCd            As Variant      '�I�����ꂽ���ڃR�[�h
    Dim vntPgmName          As Variant      '�I�����ꂽ�Ɩ���
    Dim vntPgmFileName      As Variant      '�I�����ꂽ�v���O������
    Dim vntPgmGrant         As Variant      '�I�����ꂽ
    Dim vntGrantName        As Variant
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntPgmInfoGuide.ItemGuide
    
    With objItemGuide
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
        
        '�߂�l�Ƃ��Ẵv���p�e�B�擾
        lngItemCount = .ItemCount
        vntPgmCd = .ItemCd
        vntPgmName = .ItemName
        vntPgmFileName = .ItemFileName
        vntPgmGrant = .ItemGrant
        vntGrantName = .ItemGrantName
    End With
    
    Screen.MousePointer = vbHourglass
    Me.Refresh
        
        
    '�I��������0���ȏ�Ȃ�
    If lngItemCount > 0 Then
        '���X�g�̕ҏW
        For i = 0 To lngItemCount - 1
            strItemCdString = vntPgmCd(i)
'            strItemKey = mstrListViewKey & strItemCdString
            strItemKey = strItemCdString
            
             '���X�g��ɑ��݂��邩�`�F�b�N����
            If CheckExistsItemCd(lsvItem, strItemKey) = False Then
                '�Ȃ���Βǉ�����
                Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
                objItem.SubItems(1) = CStr(vntPgmName(i))
                objItem.SubItems(2) = CStr(vntPgmFileName(i))
                objItem.SubItems(3) = CStr(vntGrantName(i))
                objItem.SubItems(4) = ""
                objItem.SubItems(5) = CStr(vntPgmGrant(i))
            End If
        Next i
        isSave = True
    End If

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault
    
End Sub

' �@�\�@�@ : �f�[�^�̕ۑ�
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
' �@�\���� : �ύX���ꂽ�f�[�^���e�[�u���ɕۑ�����
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
'        If CheckValue() = False Then Exit Do
        
        '�O���[�v�e�[�u���̓o�^
        If RegistGrp() = False Then Exit Do
        
        '�X�V�ς݂ɂ���
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault

End Function

Private Function CheckValue() As Boolean
    Dim Ret             As Boolean  '�֐��߂�l
    Dim i               As Integer
    
    '��������
    Ret = False
    
    For i = optGrant.LBound To optGrant.UBound
        If optGrant(i).Value Then
            Ret = True
            Exit For
        End If
    Next i
    
   
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function


' �@�\�@�@ :
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e���O���[�v�e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistGrp() As Boolean
    On Error GoTo ErrorHandle

    Dim objGrp              As Object     '�O���[�v�A�N�Z�X�p
    Dim strSearchChar       As String
    Dim lngRet              As Long
    Dim i                   As Integer
    Dim j                   As Integer
    Dim k                   As Integer
    Dim intItemCount        As Integer
    Dim vntPgmCd()          As Variant           '�v���O�����R�[�h
    Dim vntGrant()          As Variant           '���쌠��
    Dim vntseq()            As Variant          '��ʕW������
    Dim strWorkKey          As String
    Dim strPgmCd            As String
    Dim strUsrGrpcd         As String
    
    
    j = 0
    k = 0
    intItemCount = 0
    
    Erase vntPgmCd
    Erase vntGrant
    Erase vntseq
   
    RegistGrp = False

    '���X�g�r���[�p�̃L�[�v���t�B�b�N�X���폜
    strUsrGrpcd = mstrSecurityGrpCd        '���[�U�[�O���[�v�R�[�h

    '�O���[�v���ڂ̔z��쐬
    For i = 0 To lsvItem.ListItems.Count - 1
        ReDim Preserve vntPgmCd(i)
        ReDim Preserve vntGrant(i)
        ReDim Preserve vntseq(i)

        vntPgmCd(i) = lsvItem.ListItems(i + 1).Text
        vntGrant(i) = lsvItem.ListItems(i + 1).SubItems(5)
        vntseq(i) = i + 1
        intItemCount = intItemCount + 1
    Next i

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGrp = CreateObject("HainsPgmInfo.PgmInfo")
'
    lngRet = objGrp.RegistGrp_PgmInfo(IIf(cboGrp(1).Visible, "INS", "UPD"), _
                                strUsrGrpcd, _
                                vntPgmCd, _
                                vntGrant, _
                                vntseq, _
                                intItemCount)
    
    If lngRet = 0 Then
        MsgBox "�f�[�^�ۑ��Ɏ��s���܂����B", vbExclamation
        Exit Function
    End If
    
'    mstrGrpCd = Trim(txtGrpCd.Text)
'    txtGrpCd.Enabled = (txtGrpCd.Text = "")
    
'    Set objGrp = Nothing
    RegistGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objGrp = Nothing
    RegistGrp = False
    
End Function



Private Sub cmdApply_Click()
    
    If isSave Then
        '�f�[�^�K�p�������s��
        Call ApplyData
        Call EditListItem(1)
    '    Call InitFormControlsPos("O")
    End If
    isSave = False
End Sub

Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub cmdDeleteItem_Click()
    Dim i As Integer
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvItem.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ�폜
        If lsvItem.ListItems(i).Selected = True Then
            lsvItem.ListItems.Remove (lsvItem.ListItems(i).Key)
            isSave = True
            '�A�C�e�������ς��̂�-1���čČ���
            i = i - 1
        End If
    
    Next i
End Sub

Private Sub cmdDownItem_Click()
    Call MoveListItem(1)
End Sub

Private Sub cmdOk_Click()
    
    If isSave Then
        If ApplyData() = False Then
            Exit Sub
        End If
    End If
    
'    Call InitFormControlsPos("O")
    
    '��ʂ����
    isSave = False
    Unload Me
    
End Sub

Private Sub cmdUpdateItem_Click()
    Dim i       As Integer

'    Call InitFormControlsPos("U")
    If Not CheckValue Then
        MsgBox "���쌠����ݒ肵�Ă��������B"
        Exit Sub
    End If
    
    With lsvItem
        For i = 1 To .ListItems.Count
            If .ListItems(i).Selected = True Then
                .ListItems(i).SubItems(3) = optGrant(mintPgmGrant).Caption
                .ListItems(i).SubItems(5) = CStr(mintPgmGrant)
                isSave = True
                .ListItems(i).ListSubItems(3).ForeColor = vbBlue
            End If
        Next i
    End With

End Sub

Private Sub cmdUpItem_Click()
    Call MoveListItem(-1)
End Sub

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
    
    Dim strPgmName()        As String
    Dim strFileName()       As String
    Dim strGrantName()      As String
    Dim strDispSeq()        As String
    Dim strGrantFlg()       As String
    Dim strMenuName()       As String
    
    If lsvItem.ListItems.Count = 0 Then Exit Sub
    
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
        
        ReDim Preserve strPgmName(i)
        ReDim Preserve strFileName(i)
        ReDim Preserve strGrantName(i)
        ReDim Preserve strDispSeq(i)
        ReDim Preserve strGrantFlg(i)
        ReDim Preserve strMenuName(i)
        
        
        '�����Ώ۔z��ԍ�������
        If intTargetIndex = i Then
            strEscKey(i) = lsvItem.ListItems(i + 1).Key
            strEscCd(i) = lsvItem.ListItems(i + 1)
            
            strPgmName(i) = lsvItem.ListItems(i + 1).SubItems(1)
            strFileName(i) = lsvItem.ListItems(i + 1).SubItems(2)
            strGrantName(i) = lsvItem.ListItems(i + 1).SubItems(3)
            strDispSeq(i) = lsvItem.ListItems(i + 1).SubItems(4)
            strGrantFlg(i) = lsvItem.ListItems(i + 1).SubItems(5)
            strMenuName(i) = lsvItem.ListItems(i + 1).SubItems(6)
            i = i + 1
        
            ReDim Preserve strEscKey(i)
            ReDim Preserve strEscCd(i)
            ReDim Preserve strEscName(i)
            ReDim Preserve strEscClassName(i)
            
            ReDim Preserve strPgmName(i)
            ReDim Preserve strFileName(i)
            ReDim Preserve strGrantName(i)
            ReDim Preserve strDispSeq(i)
            ReDim Preserve strGrantFlg(i)
            ReDim Preserve strMenuName(i)
        
            strEscKey(i) = lsvItem.ListItems(intTargetIndex).Key
            strEscCd(i) = lsvItem.ListItems(intTargetIndex)
            
            strPgmName(i) = lsvItem.ListItems(intTargetIndex).SubItems(1)
            strFileName(i) = lsvItem.ListItems(intTargetIndex).SubItems(2)
            strGrantName(i) = lsvItem.ListItems(intTargetIndex).SubItems(3)
            strDispSeq(i) = lsvItem.ListItems(intTargetIndex).SubItems(4)
            strGrantFlg(i) = lsvItem.ListItems(intTargetIndex).SubItems(5)
            strMenuName(i) = lsvItem.ListItems(intTargetIndex).SubItems(6)
            
        
        Else
            strEscKey(i) = lsvItem.ListItems(i).Key
            strEscCd(i) = lsvItem.ListItems(i)
            
            strPgmName(i) = lsvItem.ListItems(i).SubItems(1)
            strFileName(i) = lsvItem.ListItems(i).SubItems(2)
            strGrantName(i) = lsvItem.ListItems(i).SubItems(3)
            strDispSeq(i) = lsvItem.ListItems(i).SubItems(4)
            strGrantFlg(i) = lsvItem.ListItems(i).SubItems(5)
            strMenuName(i) = lsvItem.ListItems(i).SubItems(6)
        
        End If
    
    Next i
    
    lsvItem.ListItems.Clear
    
    '�w�b�_�̕ҏW
    With lsvItem.ColumnHeaders
        .Clear
        .Add , , "�R�[�h", 1500, lvwColumnLeft
        .Add , , "�Ɩ���", 2200, lvwColumnLeft
        .Add , , "�v���O������", 2000, lvwColumnLeft    ' 2005.08.23 �ǉ�
        .Add , , "���쌠��", 1100, lvwColumnLeft
        .Add , , "Seq", 600, lvwColumnLeft
        .Add , , "�����t���O", 500, lvwColumnLeft
        .Add , , "MENU", 1300, lvwColumnLeft

    End With
    
    
    '���X�g�̕ҏW
    For i = 1 To UBound(strEscKey)
        Set objItem = lsvItem.ListItems.Add(, strEscKey(i), strEscCd(i))
        objItem.SubItems(1) = strPgmName(i)
        objItem.SubItems(2) = strFileName(i)
        objItem.SubItems(3) = strGrantName(i)
        objItem.SubItems(4) = strDispSeq(i)
        objItem.SubItems(5) = strGrantFlg(i)
        objItem.SubItems(6) = strMenuName(i)
    Next i

    lsvItem.ListItems(1).Selected = False
    
    '�ړ��������ڂ�I�������A�ړ��i�X�N���[���j������
    If intMovePosition = 1 Then
        lsvItem.ListItems(intTargetIndex + 1).Selected = True
    Else
        lsvItem.ListItems(intTargetIndex).Selected = True
    End If

    isSave = True
    '�I������Ă��鍀�ڂ�\������
    lsvItem.SelectedItem.EnsureVisible
    lsvItem.SetFocus

End Sub


Private Sub Form_Load()
    Dim Ret         As Boolean              '�߂�l
    Dim objButton   As CommandButton        '�R�}���h�{�^���I�u�W�F�N�g
    
    '�I�u�W�F�N�g�̃C���X�^���X�̍쐬
'    Set objButton = cmdInsert_Title

    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitializeForm
    
    Do
        If iMode = 0 Then                       '�J��
            txtUserGrp(0).Text = mstrUserGrpName
            txtUserGrp(1).Text = mstrSecurityGrpName
            txtUserGrp(0).Enabled = (txtUserGrp(0).Text = "")
            txtUserGrp(1).Enabled = (txtUserGrp(1).Text = "")

            '�O���[�v���v���O�������X�g�̕ҏW
            If EditListItem(1) = False Then
                Exit Do
            End If
            Ret = True
            Exit Do
        Else                                    '�V�K
            txtUserGrp(0).Visible = False
            txtUserGrp(1).Visible = False
            cboGrp(0).Visible = True
            cboGrp(1).Visible = True
        
            If EditUserGrp(0) = False Then
                Exit Do
            End If
                    
            Ret = True
            Exit Do
        End If
    Loop
    
    '�Q�Ɛ�p�̏ꍇ�A�o�^�n�R���g���[�����~�߂�
    If mblnShowOnly = True Then

    End If
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    mblnInitialize = True
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

'
' �@�\�@�@ :
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
' �@�\���� :
' ���l�@�@ :
'
Private Function EditUserGrp(idx As Integer) As Boolean
    Dim objItem                 As Object           '�R�[�X�A�N�Z�X�p
    Dim vntUserGrpCd            As Variant
    Dim vntUserGrpName          As Variant
    Dim lngCount                As Long             '���R�[�h��
    Dim i                       As Long             '�C���f�b�N�X
    Dim iMode                   As Integer
    Dim strKey                  As String
    
    Dim vntFreeCd               As Variant          '�R�[�h
    Dim vntFreeName             As Variant          '�R�[�h��
    Dim vntFreeDate             As Variant
    Dim vntFreeField1           As Variant
    Dim vntFreeField2           As Variant
    Dim vntFreeField3           As Variant
    Dim vntFreeField4           As Variant
    Dim vntFreeField5           As Variant
    Dim vntFreeField6           As Variant
    Dim vntFreeField7           As Variant
    Dim vntFreeClassCd          As Variant
    
    EditUserGrp = False
    cboGrp(idx).Clear
    
    Select Case idx
        Case 0                   '���[�U�[�O���[�v
            iMode = 0
            strKey = "UGR"
            Erase aryUserGrpCd
            
        Case 1                  '�Z�L�����e�B�[�O���[�v
            iMode = 1
            strKey = aryUserGrpCd(cboGrp(0).ListIndex)
            Erase arySecurityGrpCd
        
    End Select
        
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem = CreateObject("HainsFree.Free")
    lngCount = objItem.SelectFreeByClassCd(iMode, _
                                          strKey, _
                                          vntFreeCd, _
                                          vntFreeName, _
                                          vntFreeDate, _
                                          vntFreeField1, _
                                          vntFreeField2, _
                                          vntFreeField3, _
                                          vntFreeField4, _
                                          vntFreeField5, _
                                          , _
                                          vntFreeClassCd, _
                                          vntFreeField6, _
                                          vntFreeField7)
    
    '�����f�[�^�����݂��Ȃ��Ȃ�A�G���[
    If lngCount <= 0 Then
        MsgBox "���[�U�[�O���[�v�����݂��Ȃ��ł��B", vbExclamation
        Exit Function
    End If
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        If idx = 0 Then
            ReDim Preserve aryUserGrpCd(i)
            aryUserGrpCd(i) = vntFreeCd(i)
        ElseIf idx = 1 Then
            ReDim Preserve arySecurityGrpCd(i)
            arySecurityGrpCd(i) = vntFreeCd(i)
        End If
        cboGrp(idx).AddItem vntFreeField1(i)
    Next i
    
    '�擪�R���{��I����Ԃɂ���
    
    EditUserGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub InitializeForm()
    cboGrp(0).Visible = False
    cboGrp(1).Visible = False
    txtUserGrp(0).Visible = True
    txtUserGrp(1).Visible = True
    
    cboGrp(0).Left = txtUserGrp(0).Left
    cboGrp(0).Top = txtUserGrp(0).Top
    cboGrp(1).Left = txtUserGrp(1).Left
    cboGrp(1).Top = txtUserGrp(1).Top
    
    Call InitFormControls(Me, mcolGotFocusCollection)      '�g�p�R���g���[��������
'    Call InitFormControlsPos("O")
'    optGrant(1).Value = True
    mintPgmGrant = 1
    
End Sub

Private Sub InitFormControlsPos(HType As String)

    Select Case HType
        Case "U"
            Frame4.Top = Frame2.Top + Frame2.Height + 20
            Frame4.Visible = True
            cmdOk.Top = Frame4.Top + Frame4.Height + 120
            cmdCancel.Top = cmdOk.Top
            cmdApply.Top = cmdOk.Top
            cmdAddItem.Enabled = False
            cmdDeleteItem.Enabled = False
        
        Case "O"
            Frame4.Visible = False
            cmdAddItem.Enabled = True
            cmdDeleteItem.Enabled = True
            cmdOk.Top = Frame2.Top + Frame2.Height + 100
            cmdCancel.Top = cmdOk.Top
            cmdApply.Top = cmdOk.Top
    End Select
    
'    Select Case HType
'        Case "U"
'            Frame3.Top = Frame2.Top + Frame2.Height + 20
'            Frame3.Visible = True
'            cmdOk.Top = Frame3.Top + Frame3.Height + 120
'            cmdCancel.Top = cmdOk.Top
'            cmdApply.Top = cmdOk.Top
'            cmdAddItem.Enabled = False
'            cmdDeleteItem.Enabled = False
'
'        Case "O"
'            Frame3.Visible = False
'            cmdAddItem.Enabled = True
'            cmdDeleteItem.Enabled = True
'            cmdOk.Top = Frame2.Top + Frame2.Height + 100
'            cmdCancel.Top = cmdOk.Top
'            cmdApply.Top = cmdOk.Top
'    End Select
    
    Me.Width = Frame1.Left + Frame1.Width + 200
    Me.Height = cmdOk.Top + cmdOk.Height + 520
    
End Sub

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

Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)
    Dim i As Long

    'CTRL+A���������ꂽ�ꍇ�A���ڂ�S�đI������
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem.ListItems.Count
            lsvItem.ListItems(i).Selected = True
        Next i
    End If
End Sub

Private Sub optGrant_Click(Index As Integer)
    mintPgmGrant = Index
    Call cmdUpdateItem_Click
End Sub

Private Sub txtGrpCd_Change(Index As Integer)
    
    If Index = 0 Then           '���[�U�[�O���[�v
        '' �����O���[�v���X�g��ǂ�ŗ���
        If EditUserGrp(1) = False Then Exit Sub
        
    ElseIf Index = 1 Then       '�Z�L�����e�B�[�O���[�v
        '' �Y���̌����O���[�v�̎g�p�\�v���O�������X�g��ǂ�ŗ���
        Call EditListItem(1)
    End If

End Sub


'
' �@�\�@�@ : �Ǘ��������ڕ\��
'
' �@�\���� : ���ݐݒ肳��Ă���O���[�v���������ڂ�\������
'
' ���l�@�@ :
'
Private Function EditListItem(iMode As Integer) As Boolean
    On Error GoTo ErrorHandle

    Dim objGrp              As Object               '�O���[�v�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntUsrGrpCd         As Variant              '���[�U�[�O���[�v
    Dim vntPgmCd            As Variant              '�v���O�����R�[�h
    Dim vntPgmName          As Variant              '�Ɩ�����
    Dim vntPgmFileName      As Variant              '�v���O��������
    Dim vntPgmGrant         As Variant              '�v���O�������쌠���t���O
    Dim vntGrantName        As Variant              '�v���O�������쌠����
    Dim vntDispSeq          As Variant              '��ʕ\������
    Dim vntDelFlg           As Variant
    Dim vntMenuName         As Variant
    
    Dim lngCount            As Long                 '���R�[�h��
    Dim strSelectKey        As String               '���X�g�r���[�p�A�C�e���L�[
    Dim intSelectMode       As Integer
    Dim strItemCdString     As String               '�\���p�L�[�ҏW�̈�
    Dim i                   As Long                 '�C���f�b�N�X

    EditListItem = False
    strSelectKey = Trim(mstrSecurityGrpCd)

    '���X�g�A�C�e���N���A
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    '�w�b�_�̕ҏW
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�R�[�h", 1500, lvwColumnLeft
        .Add , , "�Ɩ���", 2200, lvwColumnLeft
        .Add , , "�v���O������", 2000, lvwColumnLeft    ' 2005.08.23 �ǉ�
        .Add , , "���쌠��", 1100, lvwColumnLeft
        .Add , , "Seq", 600, lvwColumnLeft
        .Add , , "�����t���O", 500, lvwColumnLeft
        .Add , , "MENU", 1300, lvwColumnLeft
    End With
    lsvItem.View = lvwReport
    
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGrp = CreateObject("HainsPgmInfo.PgmInfo")
    
    lngCount = objGrp.SelectGrp_PgmInfoList(strSelectKey, _
                                            iMode, _
                                            vntUsrGrpCd, _
                                            vntPgmCd, _
                                            vntPgmName, _
                                            vntPgmFileName, _
                                            vntPgmGrant, _
                                            vntGrantName, _
                                            vntDispSeq, _
                                            vntDelFlg, _
                                            vntMenuName)

   If lngCount = 0 Then Exit Function
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        '�L�[�l�ƕ\���R�[�h�̕ҏW
        Set objItem = lsvItem.ListItems.Add(, vntPgmCd(i), vntPgmCd(i))
        With objItem
            .SubItems(1) = vntPgmName(i)
            .SubItems(2) = vntPgmFileName(i)
            .SubItems(3) = vntGrantName(i)
            .SubItems(4) = vntDispSeq(i)
            .SubItems(5) = vntPgmGrant(i)
            .SubItems(6) = vntMenuName(i)
            
            If CInt(vntDelFlg(i)) = 1 Then
                .ForeColor = vbRed
                .ListSubItems.Item(1).ForeColor = vbRed
                .ListSubItems.Item(2).ForeColor = vbRed
                .ListSubItems.Item(3).ForeColor = vbRed
                .ListSubItems.Item(4).ForeColor = vbRed
                .ListSubItems.Item(5).ForeColor = vbRed
                .ListSubItems.Item(6).ForeColor = vbRed
            End If
        End With
        
    Next i
   
    '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    EditListItem = True
    
    Exit Function
    
ErrorHandle:
    
    MsgBox Err.Description, vbCritical

End Function



