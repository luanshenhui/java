VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmPgmInfoGuide 
   Caption         =   "�v���O�������ڃK�C�h"
   ClientHeight    =   6555
   ClientLeft      =   8010
   ClientTop       =   3765
   ClientWidth     =   5250
   Icon            =   "frmPgmInfoGuide.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6555
   ScaleWidth      =   5250
   Begin VB.CheckBox chkGrant 
      Caption         =   "�Q��"
      Height          =   273
      Index           =   0
      Left            =   390
      TabIndex        =   13
      Top             =   7644
      Visible         =   0   'False
      Width           =   793
   End
   Begin VB.CheckBox chkGrant 
      Caption         =   "�o�^�A�C��"
      Height          =   273
      Index           =   1
      Left            =   1196
      TabIndex        =   12
      Top             =   7644
      Visible         =   0   'False
      Width           =   1105
   End
   Begin VB.CheckBox chkGrant 
      Caption         =   "�폜"
      Height          =   273
      Index           =   2
      Left            =   2444
      TabIndex        =   11
      Top             =   7644
      Visible         =   0   'False
      Width           =   767
   End
   Begin VB.CheckBox chkGrant 
      Caption         =   "ALL"
      Height          =   273
      Index           =   3
      Left            =   3250
      TabIndex        =   10
      Top             =   7644
      Visible         =   0   'False
      Width           =   689
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   3783
      TabIndex        =   7
      Top             =   6110
      Width           =   1313
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2314
      TabIndex        =   6
      Top             =   6110
      Width           =   1313
   End
   Begin VB.Frame Frame2 
      Height          =   611
      Left            =   78
      TabIndex        =   1
      Top             =   598
      Width           =   5083
      Begin VB.ComboBox cboMenu 
         Height          =   273
         Left            =   1404
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   2
         Top             =   208
         Width           =   1937
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Hains"
         Height          =   195
         Index           =   1
         Left            =   1430
         TabIndex        =   3
         Top             =   234
         Value           =   -1  'True
         Visible         =   0   'False
         Width           =   949
      End
      Begin VB.OptionButton Option1 
         Caption         =   "�U��"
         Height          =   195
         Index           =   0
         Left            =   2366
         TabIndex        =   4
         Top             =   234
         Visible         =   0   'False
         Width           =   845
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "���j���[ �敪"
         Height          =   169
         Index           =   1
         Left            =   208
         TabIndex        =   5
         Top             =   260
         Width           =   949
      End
   End
   Begin VB.Frame Frame1 
      Height          =   559
      Left            =   78
      TabIndex        =   8
      Top             =   5382
      Width           =   5083
      Begin VB.OptionButton optGrant 
         Caption         =   "���F�X�[�p�[���[�U"
         Height          =   247
         Index           =   4
         Left            =   3075
         TabIndex        =   17
         Top             =   208
         Width           =   1845
      End
      Begin VB.OptionButton optGrant 
         Caption         =   "�폜"
         Height          =   247
         Index           =   3
         Left            =   3406
         TabIndex        =   16
         Top             =   420
         Visible         =   0   'False
         Width           =   690
      End
      Begin VB.OptionButton optGrant 
         Caption         =   "�o�^�A�C��"
         Height          =   247
         Index           =   2
         Left            =   2184
         TabIndex        =   15
         Top             =   420
         Visible         =   0   'False
         Width           =   1140
      End
      Begin VB.OptionButton optGrant 
         Caption         =   "���F�Q�Ƃ̂�"
         Height          =   247
         Index           =   1
         Left            =   1430
         TabIndex        =   14
         Top             =   208
         Width           =   1380
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "���쌠���敪 �F"
         Height          =   165
         Index           =   4
         Left            =   135
         TabIndex        =   9
         Top             =   240
         Width           =   1155
      End
   End
   Begin MSComctlLib.ListView lsvItem 
      Height          =   4215
      Left            =   60
      TabIndex        =   18
      Top             =   1215
      Width           =   5115
      _ExtentX        =   9022
      _ExtentY        =   7435
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
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   0
      Picture         =   "frmPgmInfoGuide.frx":000C
      Top             =   0
      Width           =   720
   End
   Begin VB.Label LabelTitle 
      Caption         =   "�v���O�������ڂ�I�����Ă�������"
      Height          =   375
      Left            =   780
      TabIndex        =   0
      Top             =   175
      Width           =   4275
   End
End
Attribute VB_Name = "frmPgmInfoGuide"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�v���p�e�B�p��`�̈�
Private mblnRet             As Boolean  '�߂�l
Private mblnNowEdit         As Boolean  'TRUE:�ҏW���AFALSE:�\���p�ҏW�\
Private mblnMultiSelect     As Boolean  '���X�g�r���[�̕����I��
Private mintItemCount       As Integer  '�I�����ꂽ���ڐ�
Private mstrPgmGrant        As String
Private mintPgmGrant        As Integer

Private aryMenuGrpCd()      As String
Private mvntItemCd()        As Variant  '�I�����ꂽ���ڃR�[�h
Private mvntItemName()      As Variant  '�I�����ꂽ�Ɩ���
Private mvntItemFileName()  As Variant  '�I�����ꂽ�v���O������
Private mvntItemGrant()     As Variant  '�I�����ꂽ���쌠��
Private mvntGrantName()     As Variant

Private Const FORM_WIDTH    As Integer = 5360
Private Const FORM_HEIGHT   As Integer = 6940
Private Const LSVITEM_TOP   As Integer = 1250


Public Property Get Ret() As Variant
    Ret = mblnRet
End Property

Private Sub cboMenu_Click()
    Call EditPgmInfo
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

Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Dim Ret         As Boolean
    
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mintItemCount = 0
    mintPgmGrant = 1
    mblnNowEdit = True
    
    '��ʏ�����
'    Call InitializeForm
    
    Do
        '�Z�b�g���ޏ��̕ҏW
        If EditMenuGrp() = False Then
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    mblnRet = Ret
    
    '�������̉���
    mblnNowEdit = False
    
    '���ڃ��X�g�ҏW�i�����\���j
'    Call EditItemList
    
    '���X�g�̃}���`�Z���N�g�Z�b�g
'    lsvItem.MultiSelect = mblnMultiSelect
    Screen.MousePointer = vbDefault

End Sub


'
' �@�\�@�@ : �f�[�^�\���p�ҏW
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditPgmInfo() As Boolean
    On Error GoTo ErrorHandle

    Dim objPgmInfo          As Object               '�O���[�v�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem             '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntPgmCd            As Variant              '�v���O�����R�[�h
    Dim vntPgmName          As Variant              '�v���O��������
    Dim vntStartPgm         As Variant              '�N���v���O����
    '## 2005.07.26 �ǉ�
    Dim vntFilePath         As Variant
    '## 2005.07.26 �ǉ�  End.
    Dim vntLinkImage        As Variant              '�����N�C���[�W
    Dim vntMenuGrpCd        As Variant              '���j���[�O���[�v�R�[�h
    Dim vntPgmDesc          As Variant              '�v���O��������
    Dim vntDelFlag          As Variant              '�g�p�ۃt���b�O
    
    Dim lngCount            As Long                 '���R�[�h��
    Dim i                   As Long                 '�C���f�b�N�X
    Dim Ret                 As Boolean
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPgmInfo = CreateObject("HainsPgmInfo.PgmInfo")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If cboMenu.Text = "" Then
            Ret = True
            Exit Do
        End If
        
        '�v���O���������R�[�h�œǂݍ���
        lngCount = objPgmInfo.SelectPgmInfo(aryMenuGrpCd(cboMenu.ListIndex), _
                                                1, _
                                                vntPgmCd, _
                                                vntPgmName, _
                                                vntStartPgm, _
                                                vntFilePath, _
                                                vntLinkImage, _
                                                vntMenuGrpCd, _
                                                vntPgmDesc, _
                                                vntDelFlag)
    
        '�w�b�_�̕ҏW
        Set objHeader = lsvItem.ColumnHeaders
        With objHeader
            .Clear
            .Add , , "�R�[�h", 700, lvwColumnLeft
            .Add , , "�v���O��������", 3000, lvwColumnLeft
            .Add , , "�N���v���O����", 1500, lvwColumnLeft
            .Add , , "�����N�C���[�W", 1500, lvwColumnLeft
            .Add , , "�v���O��������", 3500, lvwColumnLeft
        End With
            
        lsvItem.View = lvwReport
        
        lsvItem.ListItems.Clear
    
        '�ǂݍ��ݓ��e�̕ҏW
        If lngCount > 0 Then
             '���X�g�̕ҏW
             For i = 0 To lngCount - 1
                 '�L�[�l�ƕ\���R�[�h�̕ҏW
                 Set objItem = lsvItem.ListItems.Add(, vntPgmCd(i), vntPgmCd(i))
                 objItem.SubItems(1) = vntPgmName(i)
                 objItem.SubItems(2) = vntStartPgm(i)
                 objItem.SubItems(3) = vntLinkImage(i)
                 objItem.SubItems(4) = vntPgmDesc(i)
             Next i
            
             '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
             If lsvItem.ListItems.Count > 0 Then
                 lsvItem.ListItems(1).Selected = False
             End If
        Else
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditPgmInfo = Ret
    
    Exit Function

ErrorHandle:

    EditPgmInfo = False
    MsgBox Err.Description, vbCritical
    
End Function


'
' �@�\�@�@ :
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
' �@�\���� :
' ���l�@�@ :
'
Private Function EditMenuGrp() As Boolean
    Dim objItem                 As Object           '�R�[�X�A�N�Z�X�p
    Dim lngCount                As Long             '���R�[�h��
    Dim i                       As Long             '�C���f�b�N�X
    Dim imode                   As Integer
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
    
    EditMenuGrp = False
    cboMenu.Clear
    
    imode = 0
    strKey = "PGM"
    Erase aryMenuGrpCd
        
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem = CreateObject("HainsFree.Free")
    lngCount = objItem.SelectFreeByClassCd(imode, _
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
        MsgBox "���[�j���[�O���[�v�����݂��Ȃ��ł��B", vbExclamation
        Exit Function
    End If
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve aryMenuGrpCd(i)
        aryMenuGrpCd(i) = vntFreeCd(i)
        cboMenu.AddItem vntFreeField1(i)
    Next i
    
'    cboMenu.ListIndex = 0
    
    '�擪�R���{��I����Ԃɂ���
    EditMenuGrp = True
    
    Exit Function
    
ErrorHandle:
    MsgBox Err.Description, vbCritical

End Function

Friend Property Let MultiSelect(ByVal vNewValue As Boolean)
    mblnMultiSelect = vNewValue
End Property

Public Property Get ItemName() As Variant
    ItemName = mvntItemName
End Property

Public Property Get ItemFileName() As Variant
    ItemFileName = mvntItemFileName
End Property

Public Property Get ItemCount() As Variant
    ItemCount = mintItemCount
End Property

Public Property Get ItemCd() As Variant
    ItemCd = mvntItemCd
End Property

Public Property Get ItemGrant() As Variant
    ItemGrant = mvntItemGrant
End Property

Public Property Get GrantName() As Variant
    GrantName = mvntGrantName
End Property

Private Sub Form_Resize()
    If Me.WindowState <> vbMinimized Then
        Call SizeControls
    End If
End Sub

' �@�\�@�@ : �e��R���g���[���̃T�C�Y�ύX
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ :
'
' ���l�@�@ : �c���[�r���[�E���X�g�r���[�E�X�v���b�^�[�E���x�����̃T�C�Y��ύX����
'
Private Sub SizeControls()
    
    '���ύX
    If Me.Width > FORM_WIDTH Then
        lsvItem.Width = Me.Width - 120
        cmdOk.Left = Me.Width - 3040
        cmdCancel.Left = cmdOk.Left + 1460
    End If
    
    '�����ύX
    If Me.Height > FORM_HEIGHT Then
        lsvItem.Height = Me.Height - 2620
        cmdOk.Top = Me.Height - 830
        cmdCancel.Top = cmdOk.Top
        Frame1.Top = cmdOk.Top - 730
    End If

End Sub


Private Sub lsvItem_DblClick()
    Call cmdOK_Click
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

' @(e)
' �@�\�@�@ : �u�n�j�v�N���b�N
' �@�\���� : ���͓��e��K�p���A��ʂ����
' ���l�@�@ :
Private Sub cmdOK_Click()
    Dim x           As Object
    Dim i           As Integer
    Dim j           As Integer
    Dim strWorkKey  As String
    Dim lngPointer  As Long

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
'    '���쌠���敪 �`�F�b�N
    If Not Validation() Then
        MsgBox "���쌠���敪���I������Ă��܂���B", vbExclamation
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '�ϐ�������
    mintItemCount = 0
    j = 0
    Erase mvntItemCd
    Erase mvntItemName
    Erase mvntItemFileName
    Erase mvntItemGrant
    Erase mvntGrantName
    
    Do
        '�����I������Ă��Ȃ��Ȃ炨�I��
        If lsvItem.SelectedItem Is Nothing Then
            MsgBox "���ڂ������I������Ă��܂���B", vbExclamation
            Exit Do
        End If
        
        '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
        For i = 1 To lsvItem.ListItems.Count
            If lsvItem.ListItems(i).Selected = True Then
                
                '�J�E���g�A�b�v
                mintItemCount = mintItemCount + 1
                                
                '�z��g��
                ReDim Preserve mvntItemCd(j)
                ReDim Preserve mvntItemName(j)
                ReDim Preserve mvntItemFileName(j)
                ReDim Preserve mvntItemGrant(j)
                ReDim Preserve mvntGrantName(j)
                
                '���X�g�r���[�p�̃L�[�v���t�B�b�N�X���폜
                mvntItemCd(j) = lsvItem.ListItems(i).Key
                mvntItemName(j) = lsvItem.ListItems(i).SubItems(1)
                mvntItemFileName(j) = lsvItem.ListItems(i).SubItems(2)
                mvntItemGrant(j) = mintPgmGrant
                mvntGrantName(j) = optGrant(mintPgmGrant).Caption
                j = j + 1
            
            End If
        Next i
            
        '�����I������Ă��Ȃ��Ȃ炨�I��
        If mintItemCount = 0 Then
            MsgBox "���ڂ������I������Ă��܂���B", vbExclamation
            Exit Do
        End If
            
        '��ʂ����
        Unload Me
        
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Function Validation() As Boolean
    Dim i       As Integer
    Dim bRet    As Boolean
    
    For i = 1 To 4
        If optGrant(i).Value = True Then
            bRet = True
            Exit For
        End If
    Next i
    
    Validation = bRet
End Function

Private Sub optGrant_Click(Index As Integer)
    mintPgmGrant = Index
End Sub
