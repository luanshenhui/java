VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmCalc 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�v�Z�e�[�u�������e�i���X"
   ClientHeight    =   7680
   ClientLeft      =   2295
   ClientTop       =   675
   ClientWidth     =   8550
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmCalc.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7680
   ScaleWidth      =   8550
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.Frame Frame1 
      Caption         =   "�v�Z���@"
      Height          =   4335
      Left            =   120
      TabIndex        =   26
      Top             =   2760
      Width           =   8295
      Begin TabDlg.SSTab TabMain 
         Height          =   3795
         Left            =   240
         TabIndex        =   27
         Top             =   360
         Width           =   7815
         _ExtentX        =   13785
         _ExtentY        =   6694
         _Version        =   393216
         Style           =   1
         Tabs            =   2
         TabHeight       =   520
         TabCaption(0)   =   "�j��"
         TabPicture(0)   =   "frmCalc.frx":000C
         Tab(0).ControlEnabled=   -1  'True
         Tab(0).Control(0)=   "lsvItem(0)"
         Tab(0).Control(0).Enabled=   0   'False
         Tab(0).Control(1)=   "cmdEditItem(0)"
         Tab(0).Control(1).Enabled=   0   'False
         Tab(0).Control(2)=   "cmdAddItem(0)"
         Tab(0).Control(2).Enabled=   0   'False
         Tab(0).Control(3)=   "cmdDeleteItem(0)"
         Tab(0).Control(3).Enabled=   0   'False
         Tab(0).Control(4)=   "cmdItemCopy(0)"
         Tab(0).Control(4).Enabled=   0   'False
         Tab(0).ControlCount=   5
         TabCaption(1)   =   "����"
         TabPicture(1)   =   "frmCalc.frx":0028
         Tab(1).ControlEnabled=   0   'False
         Tab(1).Control(0)=   "cmdItemCopy(1)"
         Tab(1).Control(1)=   "cmdEditItem(1)"
         Tab(1).Control(2)=   "cmdAddItem(1)"
         Tab(1).Control(3)=   "cmdDeleteItem(1)"
         Tab(1).Control(4)=   "lsvItem(1)"
         Tab(1).ControlCount=   5
         Begin VB.CommandButton cmdItemCopy 
            Caption         =   "�����f�[�^����R�s�[(&C)..."
            Height          =   315
            Index           =   0
            Left            =   240
            TabIndex        =   6
            Top             =   3240
            Width           =   2055
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "�폜(&R)"
            Height          =   315
            Index           =   0
            Left            =   6300
            TabIndex        =   9
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "�ǉ�(&W)..."
            Height          =   315
            Index           =   0
            Left            =   3540
            TabIndex        =   7
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditItem 
            Caption         =   "�ҏW(&E)..."
            Height          =   315
            Index           =   0
            Left            =   4920
            TabIndex        =   8
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdItemCopy 
            Caption         =   "�j���f�[�^����R�s�[(&C)..."
            Height          =   315
            Index           =   1
            Left            =   -74760
            TabIndex        =   11
            Top             =   3240
            Width           =   2055
         End
         Begin VB.CommandButton cmdEditItem 
            Caption         =   "�ҏW(&E)..."
            Height          =   315
            Index           =   1
            Left            =   -70080
            TabIndex        =   13
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "�ǉ�(&W)..."
            Height          =   315
            Index           =   1
            Left            =   -71460
            TabIndex        =   12
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "�폜(&R)"
            Height          =   315
            Index           =   1
            Left            =   -68700
            TabIndex        =   14
            Top             =   3240
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   2655
            Index           =   0
            Left            =   180
            TabIndex        =   5
            Top             =   480
            Width           =   7455
            _ExtentX        =   13150
            _ExtentY        =   4683
            LabelEdit       =   1
            MultiSelect     =   -1  'True
            LabelWrap       =   -1  'True
            HideSelection   =   0   'False
            FullRowSelect   =   -1  'True
            _Version        =   393217
            Icons           =   "imlToolbarIcons"
            SmallIcons      =   "imlToolbarIcons"
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   0
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   2655
            Index           =   1
            Left            =   -74820
            TabIndex        =   10
            Top             =   480
            Width           =   7455
            _ExtentX        =   13150
            _ExtentY        =   4683
            LabelEdit       =   1
            MultiSelect     =   -1  'True
            LabelWrap       =   -1  'True
            HideSelection   =   0   'False
            FullRowSelect   =   -1  'True
            _Version        =   393217
            Icons           =   "imlToolbarIcons"
            SmallIcons      =   "imlToolbarIcons"
            ForeColor       =   -2147483640
            BackColor       =   -2147483643
            BorderStyle     =   1
            Appearance      =   1
            NumItems        =   0
         End
      End
   End
   Begin VB.Frame Frame3 
      Caption         =   "�����Ǘ����"
      Height          =   1815
      Left            =   120
      TabIndex        =   18
      Top             =   840
      Width           =   8295
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
         ItemData        =   "frmCalc.frx":0044
         Left            =   1440
         List            =   "frmCalc.frx":0066
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   1
         Top             =   300
         Width           =   6570
      End
      Begin VB.CommandButton cmdNewHistory 
         Caption         =   "�V�K(&N)..."
         Height          =   315
         Left            =   3960
         TabIndex        =   2
         Top             =   660
         Width           =   1275
      End
      Begin VB.CommandButton cmdEditHistory 
         Caption         =   "�ҏW(&H)..."
         Height          =   315
         Left            =   5340
         TabIndex        =   3
         Top             =   660
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteHistory 
         Caption         =   "�폜(&D)..."
         Enabled         =   0   'False
         Height          =   315
         Left            =   6720
         TabIndex        =   4
         Top             =   660
         Width           =   1275
      End
      Begin VB.Label lblExplanation 
         Caption         =   "�̏d�~�̏d�~�̏d"
         Height          =   195
         Left            =   1980
         TabIndex        =   25
         Top             =   1440
         Width           =   6015
      End
      Begin VB.Label lblTiming 
         Caption         =   "�v�Z�v�f�̂����A��ł��l���������ꍇ"
         Height          =   195
         Left            =   4500
         TabIndex        =   24
         Top             =   1140
         Width           =   3495
      End
      Begin VB.Label lblFraction 
         Caption         =   "�l�̌ܓ�"
         Height          =   195
         Left            =   2340
         TabIndex        =   23
         Top             =   1140
         Width           =   915
      End
      Begin VB.Label Label1 
         Caption         =   "�����F"
         Height          =   255
         Index           =   2
         Left            =   1440
         TabIndex        =   21
         Top             =   1440
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "�v�Z�^�C�~���O�F"
         Height          =   255
         Index           =   1
         Left            =   3360
         TabIndex        =   20
         Top             =   1140
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "�[�������F"
         Height          =   255
         Index           =   0
         Left            =   1440
         TabIndex        =   19
         Top             =   1140
         Width           =   975
      End
      Begin VB.Label Label8 
         Caption         =   "�������(&J):"
         Height          =   195
         Index           =   0
         Left            =   300
         TabIndex        =   0
         Top             =   360
         Width           =   1095
      End
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(&A)"
      Height          =   315
      Left            =   7140
      TabIndex        =   17
      Top             =   7260
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   4260
      TabIndex        =   15
      Top             =   7260
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5700
      TabIndex        =   16
      Top             =   7260
      Width           =   1335
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   7620
      Top             =   180
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   4
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCalc.frx":0088
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCalc.frx":04DA
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCalc.frx":092C
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCalc.frx":0A86
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Label lblItemInfo 
      Caption         =   "000120-00"
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
      Left            =   840
      TabIndex        =   22
      Top             =   240
      Width           =   6375
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   4
      Left            =   180
      Picture         =   "frmCalc.frx":0BE0
      Top             =   120
      Width           =   480
   End
End
Attribute VB_Name = "frmCalc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd              As String           '�������ڃR�[�h
Private mstrSuffix              As String           '�T�t�B�b�N�X

Private mintBeforeIndex         As Integer          '�����R���{�ύX�L�����Z���p�̑OIndex
Private mblnNowEdit             As Boolean          'TRUE:�ҏW�������AFALSE:�����Ȃ�

Private mblnInitialize          As Boolean          'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean          'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����

Private mintUniqueKey           As Long             '���X�g�r���[��ӃL�[�Ǘ��p�ԍ�
Private Const KEY_PREFIX        As String = "K"

Private mblnHistoryUpdated      As Boolean          'TRUE:�v�Z�����X�V����AFALSE:�v�Z�����X�V�Ȃ�
Private mblnItemUpdated         As Boolean          'TRUE:�v�Z�ڍ׍X�V����AFALSE:�v�Z�ڍ׍X�V�Ȃ�
Private mblnNewRecordFlg        As Boolean          'TRUE:�V�K�쐬�AFALSE:�X�V���[�h

Private mstrArrCalcHNo()        As String           '�v�Z�Ǘ��R�[�h�i�R���{�{�b�N�X�Ή��p�j
Private mcolCalcRecord          As Collection       '�v�Z���R�[�h�̃R���N�V����
Private mcolCalc_cRecord        As Collection       '�v�Z�ڍ׃��R�[�h�̃R���N�V�����i�ǂݍ��ݒ���̂ݎg�p�j

Friend Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

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

    Dim Ret As Boolean  '�֐��߂�l
    Dim strMsg      As String
    Dim intRet      As Integer

    Ret = False
    
    Do
        
        '�v�Z���ׂ��ǂ���������͂Ȃ�G���[
        If (lsvItem(0).ListItems.Count = 0) And (lsvItem(1).ListItems.Count = 0) Then
            MsgBox "�v�Z���@�����͂���Ă��܂���B", vbExclamation, App.Title
            TabMain.Tab = 0
            lsvItem(0).SetFocus
            Exit Do
        End If
        
        '�ϐ��̐������`�F�b�N
        If CheckVariable() = False Then Exit Do
        
        '�v�Z���ׁi�j�Ȃ��A������j�̏ꍇ
        If (lsvItem(0).ListItems.Count = 0) And (lsvItem(1).ListItems.Count > 0) Then
            strMsg = "�j���̌v�Z���ݒ肳��Ă��܂���B�����̌v�Z���R�s�[���Ċi�[���܂����H"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbYes Then
                Call CopyItem(0, True)
            End If
        End If

        '�v�Z���ׁi���Ȃ��A�j����j�̏ꍇ
        If (lsvItem(1).ListItems.Count = 0) And (lsvItem(0).ListItems.Count > 0) Then
            strMsg = "�����̌v�Z���ݒ肳��Ă��܂���B�j���̌v�Z���R�s�[���Ċi�[���܂����H"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbYes Then
                Call CopyItem(1, True)
            End If
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function
Private Function CheckVariable() As Boolean

    Dim objCalc_C_Record    As Calc_C_Record
    Dim intListViewIndex    As Integer
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    Dim Ret                 As Boolean

    CheckVariable = False
    
    Ret = True
    
    '�j�����X�g�r���[�̒��g���Z�b�g
    For intListViewIndex = 0 To 1
    
        Set obTargetListView = lsvItem(intListViewIndex)
    
        '�}���`�Z���N�g��Ԃ��ꎞ�I�ɉ������A�S���ڂ𖢑I����Ԃɂ���
        obTargetListView.MultiSelect = False
        
        '���S�g�I����Ԃ����肤��̂ŁAOn Error Resume Next
        On Error Resume Next
        obTargetListView.SelectedItem.Selected = False
        On Error GoTo 0
    
        '�S�s�`�F�b�N
        For i = 1 To obTargetListView.ListItems.Count
    
            '���X�g�r���[�ƑΉ�����R���N�V�������Q�b�g
            Set objCalc_C_Record = mcolCalc_cRecord(obTargetListView.ListItems(i).Key)
            
            With objCalc_C_Record
                
                If IsNumeric(.Variable1) Then
                    If CInt(.Variable1) >= i Then
                        MsgBox "�v�Z���ʂ��擾����ɂ́A�����s�����O�Ɍv�Z����Ă���K�v������܂��B�������s����ݒ肵�Ă��������B", vbExclamation
                        TabMain.Tab = intListViewIndex
                        obTargetListView.ListItems(i).Selected = True
                        Ret = False
                        Exit For
                    End If
                End If
                
                If IsNumeric(.Variable2) Then
                    If CInt(.Variable2) >= i Then
                        MsgBox "�v�Z���ʂ��擾����ɂ́A�����s�����O�Ɍv�Z����Ă���K�v������܂��B�������s����ݒ肵�Ă��������B", vbExclamation
                        TabMain.Tab = intListViewIndex
                        obTargetListView.ListItems(i).Selected = True
                        Ret = False
                        Exit For
                    End If
                End If
                
            End With
    
        Next i
    
        If Ret = False Then Exit For
        
    Next intListViewIndex
    
    '�}���`�Z���N�g�ɍĐݒ�
    obTargetListView.MultiSelect = True
    
    '�G���[�����݂���Ȃ珈���I��
    If Ret = False Then Exit Function
    
    CheckVariable = True
    
End Function

'
' �@�\�@�@ : �f�[�^�\���p�ҏW
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditCalc(strItemCd As String, _
                          strSuffix As String, _
                          blnCopy As Boolean) As Boolean

    Dim objCalc             As Object           '�v�Z�Ǘ��A�N�Z�X�p
    
    Dim vntItemCd           As Variant
    Dim vntSuffix           As Variant
    Dim vntItemName         As Variant
    Dim vntCalcHNo          As Variant
    Dim vntStrDate          As Variant
    Dim vntEndDate          As Variant
    Dim vntFraction         As Variant
    Dim vntTiming           As Variant
    Dim vntExplanation      As Variant
    
    Dim lngCount            As Long             '���R�[�h��
    
    Dim i                   As Integer
    Dim Ret                 As Boolean          '�߂�l
    Dim objCalc_Record      As Calc_Record      '�v�Z���R�[�h�I�u�W�F�N�g
    
    On Error GoTo ErrorHandle
    
    'COPY���[�h�łȂ��Ȃ�A�R���N�V�������������̈揉����
    If blnCopy = False Then
        Set mcolCalcRecord = Nothing
        Set mcolCalcRecord = New Collection
        Erase mstrArrCalcHNo
        cboHistory.Clear
    End If
    
    Do
        '�������ڃR�[�h�B�T�t�B�b�N�X���ꂩ���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If (strItemCd = "") Or (strSuffix = "") Then
            Ret = True
            Exit Do
        End If
    
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objCalc = CreateObject("HainsCalc.Calc")
        
        '�v�Z�Ǘ��e�[�u�����R�[�h�ǂݍ���
        lngCount = objCalc.SelectCalcList(False, _
                                          strItemCd, _
                                          strSuffix, _
                                          vntItemCd, _
                                          vntSuffix, _
                                          vntItemName, _
                                          vntCalcHNo, _
                                          vntStrDate, _
                                          vntEndDate, _
                                          vntFraction, _
                                          vntTiming, _
                                          vntExplanation)
        
        If lngCount = 0 Then
            
            'COPY���[�h�łȂ��Ȃ�A�V�K�쐬
            If blnCopy = False Then
                '�v�Z�Ǘ��e�[�u�������݂��Ȃ��ꍇ�i�V�K�쐬���[�h�j
                Call AddNewCalc
            End If
            
        Else
            
            '�v�Z�Ǘ��e�[�u�������݂���ꍇ�i�X�V���[�h�j
        
            '�ǂݍ��ݓ��e�̕ҏW
            For i = 0 To lngCount - 1
                
                Set objCalc_Record = Nothing
                Set objCalc_Record = New Calc_Record
                
                '�I�u�W�F�N�g�쐬
                With objCalc_Record
                    .ItemCd = vntItemCd(i)
                    .Suffix = vntSuffix(i)
                    .CalcHNo = vntCalcHNo(i)
                    .StrDate = vntStrDate(i)
                    .EndDate = vntEndDate(i)
                    .Fraction = vntFraction(i)
                    .Timing = vntTiming(i)
                    .Explanation = vntExplanation(i)
                End With
                
                'COPY���[�h�łȂ��Ȃ�A���f�[�^�Ƃ��Ċi�[
                If blnCopy = False Then
                    
                    '�z��쐬
                    cboHistory.AddItem CStr(vntStrDate(i)) & "�`" & CStr(vntEndDate(i)) & "�ɓK�p����f�[�^"
                    
                    '�R���{�{�b�N�X�Ή��z��̍쐬
                    ReDim Preserve mstrArrCalcHNo(i)
                    mstrArrCalcHNo(i) = KEY_PREFIX & objCalc_Record.CalcHNo
                    
                    '�R���N�V�����ǉ�
                    mcolCalcRecord.Add objCalc_Record, KEY_PREFIX & objCalc_Record.CalcHNo
                
                End If
                
            Next i
        
        End If
    
        Ret = True
        Exit Do
    Loop
    
    'COPY���[�h�łȂ��Ȃ�A�R���{�̎g�p�ۂ̐ݒ�
    If blnCopy = False Then
        
        '�����R���{���P�����Ȃ��Ȃ�폜�{�^���͎g�p�s��
        If cboHistory.ListCount <= 1 Then
            cmdDeleteHistory.Enabled = False
        Else
            cmdDeleteHistory.Enabled = True
        End If
    
    End If
    
    '�߂�l�̐ݒ�
    Set objCalc = Nothing
    EditCalc = Ret
    
    Exit Function

ErrorHandle:

    EditCalc = False
    MsgBox Err.Description, vbCritical
    Set objCalc = Nothing
    
End Function

'
' �@�\�@�@ : �v�Z�ڍ׏��̎擾
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function GetCalc_c(strCalcHNo As String, blnCopy As Boolean) As Boolean

    Dim objCalc             As Object       '�v�Z�Ǘ��A�N�Z�X�p
    
    Dim vntGender           As Variant      '����
    Dim vntSeq              As Variant      '�v�Z��
    Dim vntVariable1        As Variant      '�ϐ��P
    Dim vntCalcItemCd1      As Variant      '�v�Z���ڃR�[�h�P
    Dim vntCalcSuffix1      As Variant      '�v�Z�T�t�B�b�N�X�P
    Dim vntCalcItemName1    As Variant      '�v�Z���ږ��P
    Dim vntConstant1        As Variant      '�萔�P
    Dim vntOperator         As Variant      '���Z�L��
    Dim vntVariable2        As Variant      '�ϐ��Q
    Dim vntCalcItemCd2      As Variant      '�v�Z���ڃR�[�h�Q
    Dim vntCalcSuffix2      As Variant      '�v�Z�T�t�B�b�N�X�Q
    Dim vntCalcItemName2    As Variant      '�v�Z���ږ��Q
    Dim vntConstant2        As Variant      '�萔�Q
    Dim vntCalcResult       As Variant      '�v�Z����
    
    Dim lngCount            As Long         '���R�[�h��
    Dim i                   As Integer
    Dim Ret                 As Boolean      '�߂�l
    
    Dim objCalc_C_Record    As Calc_C_Record    '�v�Z�ڍ׃��R�[�h�I�u�W�F�N�g
    
    On Error GoTo ErrorHandle
    
    If blnCopy = True Then
    
    Else
        '���ݕ\�����Ă���l�̃N���A
        Set mcolCalc_cRecord = Nothing
        Set mcolCalc_cRecord = New Collection
    End If

    Do
'        '�v�Z�Ǘ��R�[�h���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
'        If (strCalcHNo = "") Or (strCalcHNo = "0") Then
'            Ret = True
'            Exit Do
'        End If
        '�v�Z�Ǘ��R�[�h���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If strCalcHNo = "" Then
            Ret = True
            Exit Do
        End If
    
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objCalc = CreateObject("HainsCalc.Calc")
        
        '�v�Z�Ǘ��e�[�u�����R�[�h�ǂݍ���
        lngCount = objCalc.SelectCalc_cList(mstrItemCd, _
                                            mstrSuffix, _
                                            CInt(strCalcHNo), _
                                            vntGender, _
                                            vntSeq, _
                                            vntVariable1, _
                                            vntCalcItemCd1, _
                                            vntCalcSuffix1, _
                                            vntCalcItemName1, _
                                            vntConstant1, _
                                            vntOperator, _
                                            vntVariable2, _
                                            vntCalcItemCd2, _
                                            vntCalcSuffix2, _
                                            vntCalcItemName2, _
                                            vntConstant2, _
                                            vntCalcResult)

        '0���ł��s�v�c�Ȃ�
        If lngCount = 0 Then
            
            If blnCopy = True Then
                Ret = False
            Else
                Ret = True
            End If
            
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW
        For i = 0 To lngCount - 1
            '�ǂݍ��ݓ��e���I�u�W�F�N�g�ɃZ�b�g
            Set objCalc_C_Record = New Calc_C_Record
            With objCalc_C_Record
'                .CalcHNo = strCalcHNo
                .Gender = vntGender(i)
                .Variable1 = vntVariable1(i)
                .CalcItemCd1 = vntCalcItemCd1(i)
                .CalcSuffix1 = vntCalcSuffix1(i)
                .CalcItemName1 = vntCalcItemName1(i)
                .Constant1 = vntConstant1(i)
                .Operator = vntOperator(i)
                .Variable2 = vntVariable2(i)
                .CalcItemCd2 = vntCalcItemCd2(i)
                .CalcSuffix2 = vntCalcSuffix2(i)
                .CalcItemName2 = vntCalcItemName2(i)
                .Constant2 = vntConstant2(i)
                .CalcResult = vntCalcResult(i)
                .Key = KEY_PREFIX & mintUniqueKey
            End With
            
            If blnCopy = True Then
            
            Else
                '�R���N�V�����ɒǉ�
                mcolCalc_cRecord.Add objCalc_C_Record, KEY_PREFIX & mintUniqueKey
                mintUniqueKey = mintUniqueKey + 1
            End If
            
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    Set objCalc = Nothing
    
    '�߂�l�̐ݒ�
    GetCalc_c = Ret
    
    Exit Function

ErrorHandle:

    GetCalc_c = False
    MsgBox Err.Description, vbCritical
    Set objCalc = Nothing
    
End Function

'
' �@�\�@�@ : �v�Z�ڍ׏��̕\���i�R���N�V��������j
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditListViewFromCollection() As Boolean

On Error GoTo ErrorHandle

    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntFraction         As Variant          '�R�[�X�R�[�h
    Dim vntCsName           As Variant          '�R�[�X��
    Dim lngCount            As Long             '���R�[�h��
    Dim i                   As Long             '�C���f�b�N�X
    Dim objCalc_C_Record    As Calc_C_Record    '�v�Z�ڍ׃��R�[�h�I�u�W�F�N�g
    
    EditListViewFromCollection = False

    '���X�g�r���[�p�w�b�_�����i�j�����j
    For i = 0 To 1
        Call EditListViewHeader(CInt(i))
    Next i
    
    '���X�g�̕ҏW
    For Each objCalc_C_Record In mcolCalc_cRecord
        
        '���X�g�r���[�Z�b�g
        Call SetCalcListForListView(objCalc_C_Record.Key, True)
    
    Next objCalc_C_Record
    
    '�I�u�W�F�N�g�p��
    Set objCalc_C_Record = Nothing
    
    EditListViewFromCollection = True
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �������ڏ��擾
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ڂ̊�{�����擾����
'
' ���l�@�@ :
'
Private Function GetItemInfo() As Boolean

    Dim objItem             As Object               '�������ڏ��A�N�Z�X�p
    Dim i                   As Integer
    
    Dim vntItemName         As Variant              '
    Dim vntitemEName        As Variant              '
    Dim vntClassName        As Variant              '
    Dim vntRslQue           As Variant              '
    Dim vntRslqueName       As Variant              '
    Dim vntItemType         As Variant              '
    Dim vntItemTypeName     As Variant              '
    Dim vntResultType       As Variant              '
    Dim vntResultTypeName   As Variant              '
    Dim vntStcItemCd        As Variant              '
    Dim Ret                 As Boolean              '�߂�l
    
    GetItemInfo = False
    
    On Error GoTo ErrorHandle
    
    Ret = False
    Do
        
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If (mstrItemCd = "") Or (mstrSuffix = "") Then
            MsgBox "�������ڃR�[�h���w�肳��Ă��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objItem = CreateObject("HainsItem.Item")
        
        '�������ڃe�[�u�����R�[�h�ǂݍ���
        If objItem.SelectItemHeader(mstrItemCd, _
                                    mstrSuffix, _
                                    vntItemName, _
                                    vntitemEName, _
                                    vntClassName, _
                                    vntRslQue, _
                                    vntRslqueName, _
                                    vntItemType, _
                                    vntItemTypeName, _
                                    vntResultType, _
                                    vntResultTypeName) = False Then
            
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        
        End If

        '���ʃ^�C�v���`�F�b�N
        If CInt(vntResultType) <> RESULTTYPE_CALC Then
            MsgBox "�w�肳�ꂽ����" & vntItemName & "�͌v�Z�^�C�v�̍��ڂł͂���܂���B", vbCritical, App.Title
            Exit Do
        End If
        
        '�ǂݍ��ݓ��e�̕ҏW
        lblItemInfo.Caption = mstrItemCd & "-" & mstrSuffix & "�F�u" & vntItemName & "�v"
        lblItemInfo.Caption = lblItemInfo.Caption & "�̌v�Z���@��o�^���܂��B"
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    GetItemInfo = Ret
    Set objItem = Nothing
    
    Exit Function

ErrorHandle:

    GetItemInfo = False
    MsgBox Err.Description, vbCritical
    Set objItem = Nothing
    
End Function

'
' �@�\�@�@ : �f�[�^�o�^
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function RegistCalc() As Boolean

On Error GoTo ErrorHandle

    Dim objCalc                 As Object       '�v�Z�Ǘ��A�N�Z�X�p
    Dim Ret                     As Long
    Dim objCurCalc_Record       As Calc_Record
    
    '�V�K�o�^���̑ޔ�p
    Dim strEscItemCd            As String
    Dim strEscSuffix            As String
    Dim strEscCalcHNo           As String
    Dim strEscStrDate           As String
    Dim strEscEndDate           As String
    Dim strEscFraction          As String
    Dim strEscTiming            As String
    Dim strEscExplanation       As String

    '�v�Z����No
    Dim intCalcHNo              As Integer

    '�v�Z�ڍׂ̔z��֘A
    Dim intItemCount            As Integer
    Dim vntGender               As Variant
    Dim vntSeq                  As Variant
    Dim vntVariable1            As Variant
    Dim vntCalcItemCd1          As Variant
    Dim vntCalcSuffix1          As Variant
    Dim vntConstant1            As Variant
    Dim vntOperator             As Variant
    Dim vntVariable2            As Variant
    Dim vntCalcItemCd2          As Variant
    Dim vntCalcSuffix2          As Variant
    Dim vntConstant2            As Variant
    Dim vntCalcResult           As Variant

    '���݂̃J�����g�����I�u�W�F�N�g�ɃZ�b�g
    Set objCurCalc_Record = mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex))
    
    
    '�v�Z�Ǘ��e�[�u�����R�[�h�̓o�^
    With objCurCalc_Record

        '�V�K�}�����[�h�̏ꍇ��ݒ���e��ޔ�
        If mblnNewRecordFlg = True Then
            strEscItemCd = .ItemCd
            strEscSuffix = .Suffix
            strEscCalcHNo = .CalcHNo
            strEscStrDate = .StrDate
            strEscEndDate = .EndDate
            strEscFraction = .Fraction
            strEscTiming = .Timing
            strEscExplanation = .Explanation
        End If
        
        '�v�Z�ڍ׃e�[�u���̔z��Z�b�g
        Call EditArrayForUpdate(intItemCount, _
                                vntGender, _
                                vntSeq, _
                                vntVariable1, _
                                vntCalcItemCd1, _
                                vntCalcSuffix1, _
                                vntConstant1, _
                                vntOperator, _
                                vntVariable2, _
                                vntCalcItemCd2, _
                                vntCalcSuffix2, _
                                vntConstant2, _
                                vntCalcResult)
    
        '�v�Z����No�̃Z�b�g
        intCalcHNo = .CalcHNo
    
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objCalc = CreateObject("HainsCalc.Calc")
    
        '�v�Z�f�[�^�̓o�^
        Ret = objCalc.RegistCalc_All(IIf(mblnNewRecordFlg = True, "INS", "UPD"), _
                                     mstrItemCd, _
                                     mstrSuffix, _
                                     intCalcHNo, _
                                     .StrDate, _
                                     .EndDate, _
                                     .Fraction, _
                                     .Timing, _
                                     .Explanation, _
                                     intItemCount, _
                                     vntGender, _
                                     vntSeq, _
                                     vntVariable1, _
                                     vntCalcItemCd1, _
                                     vntCalcSuffix1, _
                                     vntConstant1, _
                                     vntOperator, _
                                     vntVariable2, _
                                     vntCalcItemCd2, _
                                     vntCalcSuffix2, _
                                     vntConstant2, _
                                     vntCalcResult)
    
    End With
    
    If Ret <> INSERT_NORMAL Then
        
        Select Case Ret
            
            Case INSERT_DUPLICATE
                MsgBox "���͂��ꂽ�v�Z�Ǘ��R�[�h�͊��ɑ��݂��܂��B", vbExclamation
            
            Case INSERT_HISTORYDUPLICATE
                MsgBox "���t���d�����Ă��闚�������݂��܂��B����ݒ���ē��͂��Ă��������B", vbExclamation
            
            Case Else
                MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical
    
        End Select
        RegistCalc = False
        Exit Function
    End If
    
    '�V�K�}�����[�h�̏ꍇ�A�ݒ���e��ޔ�
    If mblnNewRecordFlg = True Then

        '�V�����v�Z�����I�u�W�F�N�g���쐬
        Set objCurCalc_Record = Nothing
        Set objCurCalc_Record = New Calc_Record
        With objCurCalc_Record
            .ItemCd = strEscItemCd
            .Suffix = strEscSuffix
            .CalcHNo = intCalcHNo
            .StrDate = strEscStrDate
            .EndDate = strEscEndDate
            .Fraction = strEscFraction
            .Timing = strEscTiming
            .Explanation = strEscExplanation
        End With

        '���̒l���R���N�V��������폜���Ĕ��Ԃ��ꂽ�v�Z����No�ŃR���N�V�����ǉ�
        mcolCalcRecord.Remove KEY_PREFIX & strEscCalcHNo
        mcolCalcRecord.Add objCurCalc_Record, KEY_PREFIX & intCalcHNo

        '�R���{�{�b�N�X�̒l���ύX
        mstrArrCalcHNo(cboHistory.ListIndex) = KEY_PREFIX & intCalcHNo

    End If

    '�����V�K�ł͂Ȃ��̂Ń{�^���g�p�\
    cmdNewHistory.Enabled = True
    mblnNewRecordFlg = False
    
    '�X�V�ς݃t���O��������
    mblnHistoryUpdated = False
    mblnItemUpdated = False
    
    Set objCalc = Nothing
    RegistCalc = True
    
    Exit Function
    
ErrorHandle:

    RegistCalc = False
    MsgBox Err.Description, vbCritical
    Set objCalc = Nothing
    
End Function

' @(e)
'
' �@�\�@�@ : �X�V�p�z��쐬
'
' �����@�@ : ��������
'
' �߂�l�@ : �Ȃ�
'
' �@�\���� : �f�[�^�X�V�p��Variant�z������X�g�r���[�y�уR���N�V��������쐬
'
' ���l�@�@ :
'
Private Sub EditArrayForUpdate(intItemCount As Integer, _
                                vntGender As Variant, _
                                vntSeq As Variant, _
                                vntVariable1 As Variant, _
                                vntCalcItemCd1 As Variant, _
                                vntCalcSuffix1 As Variant, _
                                vntConstant1 As Variant, _
                                vntOperator As Variant, _
                                vntVariable2 As Variant, _
                                vntCalcItemCd2 As Variant, _
                                vntCalcSuffix2 As Variant, _
                                vntConstant2 As Variant, _
                                vntCalcResult As Variant)

    Dim vntArrGender()          As Variant
    Dim vntArrSeq()             As Variant
    Dim vntArrVariable1()       As Variant
    Dim vntArrCalcItemCd1()     As Variant
    Dim vntArrCalcSuffix1()     As Variant
    Dim vntArrConstant1()       As Variant
    Dim vntArrOperator()        As Variant
    Dim vntArrVariable2()       As Variant
    Dim vntArrCalcItemCd2()     As Variant
    Dim vntArrCalcSuffix2()     As Variant
    Dim vntArrConstant2()       As Variant
    Dim vntArrCalcResult()      As Variant
    
    Dim i                       As Integer
    Dim intArrCount             As Integer
    Dim intListViewIndex        As Integer
    Dim obTargetListView        As ListView
    Dim objCalc_C_Record        As Calc_C_Record

    intArrCount = 0

    '�j�����X�g�r���[�̒��g���Z�b�g
    For intListViewIndex = 0 To 1
    
        Set obTargetListView = lsvItem(intListViewIndex)
    
        '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
        For i = 1 To obTargetListView.ListItems.Count
    
            ReDim Preserve vntArrGender(intArrCount)
            ReDim Preserve vntArrSeq(intArrCount)
            ReDim Preserve vntArrVariable1(intArrCount)
            ReDim Preserve vntArrCalcItemCd1(intArrCount)
            ReDim Preserve vntArrCalcSuffix1(intArrCount)
            ReDim Preserve vntArrConstant1(intArrCount)
            ReDim Preserve vntArrOperator(intArrCount)
            ReDim Preserve vntArrVariable2(intArrCount)
            ReDim Preserve vntArrCalcItemCd2(intArrCount)
            ReDim Preserve vntArrCalcSuffix2(intArrCount)
            ReDim Preserve vntArrConstant2(intArrCount)
            ReDim Preserve vntArrCalcResult(intArrCount)
    
            '���X�g�r���[�ƑΉ�����R���N�V�������Q�b�g
            Set objCalc_C_Record = mcolCalc_cRecord(obTargetListView.ListItems(i).Key)
            
            With objCalc_C_Record
                
                vntArrGender(intArrCount) = .Gender
                vntArrSeq(intArrCount) = i
                vntArrVariable1(intArrCount) = .Variable1
                vntArrCalcItemCd1(intArrCount) = .CalcItemCd1
                vntArrCalcSuffix1(intArrCount) = .CalcSuffix1
                vntArrConstant1(intArrCount) = .Constant1
                vntArrOperator(intArrCount) = .Operator
                vntArrVariable2(intArrCount) = .Variable2
                vntArrCalcItemCd2(intArrCount) = .CalcItemCd2
                vntArrCalcSuffix2(intArrCount) = .CalcSuffix2
                vntArrConstant2(intArrCount) = .Constant2
                
                '�v�Z�ŏI�s��Null�Z�b�g
                If i = obTargetListView.ListItems.Count Then
                    vntArrCalcResult(intArrCount) = ""
                Else
                    vntArrCalcResult(intArrCount) = i
                End If
                
            End With
            
            intArrCount = intArrCount + 1
    
        Next i
    
    Next intListViewIndex

    vntGender = vntArrGender
    vntSeq = vntArrSeq
    vntVariable1 = vntArrVariable1
    vntCalcItemCd1 = vntArrCalcItemCd1
    vntCalcSuffix1 = vntArrCalcSuffix1
    vntConstant1 = vntArrConstant1
    vntOperator = vntArrOperator
    vntVariable2 = vntArrVariable2
    vntCalcItemCd2 = vntArrCalcItemCd2
    vntCalcSuffix2 = vntArrCalcSuffix2
    vntConstant2 = vntArrConstant2
    vntCalcResult = vntArrCalcResult

    intItemCount = intArrCount

End Sub

' @(e)
'
' �@�\�@�@ : �����R���{�N���b�N
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : �Ȃ�
'
' �@�\���� : �R���{�N���b�N�ɂ��f�[�^�ύX��Ԃ̗}��
'
' ���l�@�@ :
'
Private Sub cboHistory_Click()

    Dim strMsg      As String
    Dim intRet      As Integer
        
    '�ҏW�r���A�������͏������̏ꍇ�͏������Ȃ�
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '�����R���{��������Ȃ��ꍇ�́A�����I��
    If cboHistory.ListCount = 1 Then Exit Sub

    Do
        
        '�ڍ׍��ڂ��X�V����Ă���ꍇ�́A�x�����b�Z�[�W
        If (mblnItemUpdated = True) Or (mblnHistoryUpdated = True) Then
            strMsg = "�v�Z�̐ݒ���e���X�V����Ă��܂��B�����f�[�^���ĕ\������ƕύX���e���j������܂�" & vbLf & _
                     "��낵���ł����H"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbNo Then
                mblnNowEdit = True                          '����Loop�h�~�̂��߁A��������
                cboHistory.ListIndex = mintBeforeIndex      '�R���{�C���f�b�N�X�����ɖ߂�
                mblnNowEdit = False                         '����������
                Exit Sub
            End If
        End If
        
        Screen.MousePointer = vbHourglass
        
        mblnNowEdit = True

        '�V�K��Ԃ̏ꍇ�A����������폜
        If mblnNewRecordFlg = True Then
            Call RemoveNewCalc
        End If
        
        '�w�b�_���̕ҏW
        Call EditHeaderExplain
        
        '�v�Z�ڍ׏��̕ҏW
        If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
            Exit Do
        End If
        
        '�擾�v�Z���̃��X�g�r���[�i�[
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        '�S�Ė��X�V��Ԃɖ߂�
        mblnHistoryUpdated = False
        mblnItemUpdated = False
        
        Exit Do
    Loop
    
    '���݂�Index��ێ�
    mintBeforeIndex = cboHistory.ListIndex
    
    mblnNowEdit = False
    Screen.MousePointer = vbDefault

End Sub

' @(e)
'
' �@�\�@�@ : �v�Z���@�ǉ��{�^���N���b�N
'
' �����@�@ : (In)   Index    �Ώۃ{�^���i���ʖ��j
'
' �߂�l�@ : �Ȃ�
'
' �@�\���� : �v�Z�s�̕ҏW�_�C�A���O��\�����A�V�K�ɒǉ�����
'
' ���l�@�@ :
'
Private Sub cmdAddItem_Click(Index As Integer)

    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    
    Dim strStrAge           As String           '�J�n�N��
    Dim strEndAge           As String           '�I���N��
    Dim strLowerValue       As String           '�v�Z�i�ȏ�j
    Dim strUpperValue       As String           '�v�Z�i�ȉ��j
    Dim strStdFlg           As String           '�v�Z�t���O
    Dim strJudCd            As String           '����R�[�h
    Dim strJudCmtCd         As String           '����R�����g�R�[�h
    Dim strHealthPoint      As String           '�w���X�|�C���g
    
    Dim objCalc_C_Record    As Calc_C_Record
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ő��ʂ�I��
    Set obTargetListView = lsvItem(Index)

    With frmEditCalcItem
        
        '���ݐݒ肳��Ă���v�Z�s���Z�b�g
        .CalcLine = obTargetListView.ListItems.Count
        
        '���݂̌������ڃR�[�h���Z�b�g�i���J�[�V�u���\�h�j
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        
        '�v�Z�s�ҏW�t�H�[���\��
        .Show vbModal
    
        If .Updated = True Then
            
            '�X�V����Ă���ꍇ�́A�I�u�W�F�N�g�쐬
            Set objCalc_C_Record = New Calc_C_Record
            
'            objCalc_C_Record.ItemCd = mstrItemCd
'            objCalc_C_Record.Suffix = mstrSuffix
'            objCalc_C_Record.CalcHNo = mstrCalcHNo
            objCalc_C_Record.Gender = Index + 1
'            objCalc_C_Record.Seq = obTargetListView.ListItems.Count + 1
            objCalc_C_Record.Variable1 = .Variable1
            objCalc_C_Record.CalcItemCd1 = .CalcItemCd1
            objCalc_C_Record.CalcSuffix1 = .CalcSuffix1
            objCalc_C_Record.CalcItemName1 = .CalcItemName1
            objCalc_C_Record.Constant1 = .Constant1
            objCalc_C_Record.Operator = .Operator
            objCalc_C_Record.Variable2 = .Variable2
            objCalc_C_Record.CalcItemCd2 = .CalcItemCd2
            objCalc_C_Record.CalcSuffix2 = .CalcSuffix2
            objCalc_C_Record.CalcItemName2 = .CalcItemName2
            objCalc_C_Record.Constant2 = .Constant2
            
            mcolCalc_cRecord.Add objCalc_C_Record, KEY_PREFIX & mintUniqueKey
            Call SetCalcListForListView(KEY_PREFIX & mintUniqueKey, True)
            mintUniqueKey = mintUniqueKey + 1
            
            '�v�Z�ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
        
    End With
    
    '�I�u�W�F�N�g�̔p��
    Set frmEditCalcItem = Nothing
    
End Sub

' @(e)
'
' �@�\�@�@ : ���X�g�r���[�ւ̃f�[�^�Z�b�g
'
' �����@�@ : (In)   strTargetKey    �R���N�V�������̕\���ΏۃL�[
' �@�@�@�@ : (In)   blnModeNew      TRUE:�V�K�ǉ��AFALSE:���\���s�X�V
'
' �߂�l�@ : �Ȃ�
'
' �@�\���� : ���R���N�V�����̃f�[�^�����X�g�r���[�ɕ\������
'
' ���l�@�@ :
'
Private Sub SetCalcListForListView(strTargetKey As String, blnModeNew As Boolean)

    Dim objItem             As ListItem             '���X�g�A�C�e���I�u�W�F�N�g
    Dim objCalc_C_Record    As Calc_C_Record
    Dim obTargetListView    As ListView
    Dim strLeftString       As String
    Dim strRightString      As String
    Dim strOperator         As String

    '�R���N�V��������ΏۃI�u�W�F�N�g�̃Z�b�g
    Set objCalc_C_Record = mcolCalc_cRecord(strTargetKey)
    
    '�Z�b�g�惊�X�g�r���[�̃Z�b�g
    Set obTargetListView = lsvItem(CInt(objCalc_C_Record.Gender) - 1)
    
    '���ӁA�E�ӂ̕\��������ҏW
    Call EditCalcString(objCalc_C_Record, strLeftString, strRightString)
    
    '���Z�q���Q�o�C�g�����ɕҏW
    Select Case objCalc_C_Record.Operator
        Case "+"
            strOperator = "�{"
        Case "-"
            strOperator = "�|"
        Case "*"
            strOperator = "�~"
        Case "/"
            strOperator = "��"
        Case "^"
            strOperator = "�O"
    End Select
        
    If blnModeNew = True Then
        '�V�K�ǉ����[�h�̏ꍇ
        Set objItem = obTargetListView.ListItems.Add(, strTargetKey, strLeftString, , "DEFAULTLIST")
        objItem.SubItems(1) = strOperator
        objItem.SubItems(2) = strRightString
    Else
        '�X�V���[�h�̏ꍇ
        obTargetListView.ListItems(strTargetKey).Text = strLeftString
        obTargetListView.ListItems(strTargetKey).SubItems(1) = strOperator
        obTargetListView.ListItems(strTargetKey).SubItems(2) = strRightString
    End If

End Sub

' @(e)
'
' �@�\�@�@ : �v�Z���̕ҏW
'
' �����@�@ : (In)   objTargetList   �v�Z���@���R�[�h�I�u�W�F�N�g
' �@�@�@�@ : (Out)  strLeftString   �v�Z���i���Ӂj
' �@�@�@�@ : (Out)  strRightString  �v�Z���i�E�Ӂj
'
' �߂�l�@ : ����
'
' �@�\���� : �\���p�Ɍv�Z�f�[�^���ĕҏW����
'
' ���l�@�@ :
'
Private Sub EditCalcString(objTargetList As Calc_C_Record, _
                           strLeftString As String, _
                           strRightString As String)

    With objTargetList
        
        '����
        
        '�ϐ����Z�b�g����Ă���ꍇ�̏���
        If Trim(.Variable1) <> "" Then
            strLeftString = .Variable1 & "�s�ڂ̌���"
        End If
        
        '�������ڃR�[�h���Z�b�g����Ă���ꍇ�̏���
        If Trim(.CalcItemCd1) <> "" Then
            strLeftString = .CalcItemName1
        End If
    
        '�ϐ��A�������͌������ڃR�[�h���Z�b�g����Ă���ꍇ�̒萔�\��
        If (Trim(.Variable1) <> "") Or (Trim(.CalcItemCd1) <> "") Then
            
            If IsNumeric(Trim(.Constant1)) Then
                '�萔���P�ł͂Ȃ��ꍇ�ɁA����ҏW
                If CDbl(Trim(.Constant1)) <> 1 Then
                    strLeftString = "( " & strLeftString & "�~ " & .Constant1 & " )"
                End If
            End If
        Else
            '�萔�݂̂̏ꍇ�́A���̂܂܃Z�b�g
            strLeftString = .Constant1
        End If
        
        '�E��
        
        '�ϐ����Z�b�g����Ă���ꍇ�̏���
        If Trim(.Variable2) <> "" Then
            strRightString = .Variable2 & "�s�ڂ̌���"
        End If
        
        '�������ڃR�[�h���Z�b�g����Ă���ꍇ�̏���
        If Trim(.CalcItemCd2) <> "" Then
            strRightString = .CalcItemName2
        End If
    
        '�ϐ��A�������͌������ڃR�[�h���Z�b�g����Ă���ꍇ�̒萔�\��
        If (Trim(.Variable2) <> "") Or (Trim(.CalcItemCd2) <> "") Then
            If IsNumeric(Trim(.Constant2)) Then
                '�萔���P�ł͂Ȃ��ꍇ�ɁA����ҏW
                If CDbl(Trim(.Constant2)) <> 1 Then
                    strRightString = "( " & strRightString & "�~ " & .Constant2 & " )"
                End If
            End If
        Else
            '�萔�݂̂̏ꍇ�́A���̂܂܃Z�b�g
            strRightString = .Constant2
        End If
    
    End With
    
End Sub

' @(e)
'
' �@�\�@�@ : �K�p�{�^���N���b�N
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : �Ȃ�
'
' �@�\���� : ���̓f�[�^��ۑ�����
'
' ���l�@�@ :
'
Private Sub cmdApply_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then Exit Sub
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '�ۑ�����
    Call ApplyData(False)
    
    '�������̉���
    Screen.MousePointer = vbDefault

End Sub
Private Function ApplyData(blnOkMode As Boolean) As Boolean

    ApplyData = False
    
    '���̓`�F�b�N
    If CheckValue() = False Then
        Exit Function
    End If
    
    '�v�Z�Ǘ��e�[�u���̓o�^
    If RegistCalc() = False Then
        Exit Function
    End If
    
    '�X�V�ς݃t���O��TRUE��
    mblnUpdated = True
        
    'OK�{�^���������͗]�v�ȏ��������Ȃ�
    If blnOkMode = True Then
        ApplyData = True
        Exit Function
    End If
    
    MsgBox "���͂��ꂽ���e��ۑ����܂����B", vbInformation

    '�v�Z�ڍ׏��̕ҏW�i��ʍĕ\�����s�����Ƃɂ��v�Z�R�[�h���Ď擾�j
    If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
        Exit Function
    End If
    
    '�擾�v�Z���̃��X�g�r���[�i�[
    If EditListViewFromCollection() = False Then
        Exit Function
    End If
    
    ApplyData = True
    
End Function

' @(e)
'
' �@�\�@�@ : �u�L�����Z���vClick
'
' �@�\���� : �t�H�[�������
'
' ���l�@�@ :
'
Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdDeleteHistory_Click()

    Dim objCalc     As Object           '�v�Z�Ǘ��A�N�Z�X�p
    Dim strMsg      As String
    Dim intRet      As Integer
        
    '�������Ȃ珈���I��
    If Screen.MousePointer = vbHourglass Then Exit Sub
    Screen.MousePointer = vbHourglass

    Do
        
        strMsg = "�w�肳�ꂽ�����f�[�^���폜���܂��B" & vbLf & vbLf & _
                 "�����f�[�^���폜����Ƃ��̗����œo�^���Ă���v�Z���@���폜����܂��B" & vbLf & _
                 "���̑���̓L�����Z���ł��܂���B��낵���ł����H"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then Exit Do
        
        '�f�[�^���폜����(COM+)
        Set objCalc = CreateObject("HainsCalc.Calc")
        objCalc.DeleteCalc mstrItemCd, mstrSuffix, mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo
        Set objCalc = Nothing   'Commit�����邽�߂�Nothing
        
        '�����P��ŏ�����ǂݒ����i�ʓ|��������ł��B�����܂���j
        
        '�v�Z�����Ǘ����̕ҏW
        If EditCalc(mstrItemCd, mstrSuffix, False) = False Then
            Exit Do
        End If

        cboHistory.ListIndex = 0

        '�w�b�_���̕ҏW
        Call EditHeaderExplain

        '�v�Z�ڍ׏��̕ҏW
        If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
            Exit Do
        End If

        '�擾�v�Z���̃��X�g�r���[�i�[
        If EditListViewFromCollection() = False Then
            Exit Do
        End If

        '�S�Ė��X�V��Ԃɖ߂�
        mblnHistoryUpdated = False
        mblnItemUpdated = False
        
        Exit Do
    Loop
    
    Set objCalc = Nothing
    Screen.MousePointer = vbDefault

End Sub

' @(e)
'
' �@�\�@�@ : ���̍폜
'
' �����@�@ : (In)   Index    �����Ώ�Index
'
' �߂�l�@ : �Ȃ�
'
' �@�\���� : �I�����ꂽ�������X�g�r���[�ƃR���N�V��������폜����
'
' ���l�@�@ :
'
Private Sub cmdDeleteItem_Click(Index As Integer)

    Dim i                   As Integer
    Dim obTargetListView    As ListView
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ő��ʂ�I��
    Set obTargetListView = lsvItem(Index)
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To obTargetListView.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > obTargetListView.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ�폜
        If obTargetListView.ListItems(i).Selected = True Then
            
            '�I�u�W�F�N�g�폜
            mcolCalc_cRecord.Remove obTargetListView.ListItems(i).Key
            obTargetListView.ListItems.Remove (obTargetListView.ListItems(i).Key)
            
            '�A�C�e�������ς��̂�-1���čČ���
            i = i - 1
            
            '�v�Z�ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
    
    Next i

End Sub

Private Sub cmdEditHistory_Click()

    Dim objCurCalc_Record As Calc_Record
    
    Set objCurCalc_Record = mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex))

    With frmEditCalcHistory
        
        '�v���p�e�B�Z�b�g
        .StrDate = objCurCalc_Record.StrDate
        .EndDate = objCurCalc_Record.EndDate
        .Fraction = objCurCalc_Record.Fraction
        .Timing = objCurCalc_Record.Timing
        .Explanation = objCurCalc_Record.Explanation
        
        '��ʕ\��
        .Show vbModal
    
        '�X�V����Ă���ꍇ�A���݂̃I�u�W�F�N�g��Ԃ��X�V
        If .Updated = True Then
        
            '�I�u�W�F�N�g���e���X�V
            objCurCalc_Record.StrDate = .StrDate
            objCurCalc_Record.EndDate = .EndDate
            objCurCalc_Record.Fraction = .Fraction
            objCurCalc_Record.Timing = .Timing
            objCurCalc_Record.Explanation = .Explanation
            
            cboHistory.List(cboHistory.ListIndex) = .StrDate & "�`" & .EndDate & "�ɓK�p����f�[�^"
            
            '�X�V���ꂽ���[�h
            mblnHistoryUpdated = True
        
            '�w�b�_���������X�V
            Call EditHeaderExplain
        End If
        
    End With

End Sub

Private Sub cmdEditItem_Click(Index As Integer)

    Dim i                       As Integer
    Dim objTargetListView       As ListView
    Dim objTargetListItem       As ListItem
    Dim objCalc_C_Record        As Calc_C_Record
    Dim strTargetKey            As String
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ő��ʂ�I��
    Set objTargetListView = lsvItem(Index)
    
    '�w����W�Ƀ��X�g�A�C�e�������݂��Ȃ��ꍇ�͉������Ȃ�
    If objTargetListView.SelectedItem Is Nothing Then
        Exit Sub
    End If
    
    '���X�g�r���[�ɓK������f�[�^���R���N�V��������Q�b�g
    strTargetKey = objTargetListView.SelectedItem.Key
    Set objCalc_C_Record = mcolCalc_cRecord(strTargetKey)
    
    With frmEditCalcItem
        
        '���݂̌������ڃR�[�h���Z�b�g�i���J�[�V�u���\�h�j
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        
        '�K�C�h�ɑ΂���v���p�e�B�Z�b�g
        .Variable1 = objCalc_C_Record.Variable1
        .CalcItemCd1 = objCalc_C_Record.CalcItemCd1
        .CalcSuffix1 = objCalc_C_Record.CalcSuffix1
        .CalcItemName1 = objCalc_C_Record.CalcItemName1
        .Constant1 = objCalc_C_Record.Constant1
        .Operator = objCalc_C_Record.Operator
        .Variable2 = objCalc_C_Record.Variable2
        .CalcItemCd2 = objCalc_C_Record.CalcItemCd2
        .CalcSuffix2 = objCalc_C_Record.CalcSuffix2
        .CalcItemName2 = objCalc_C_Record.CalcItemName2
        .Constant2 = objCalc_C_Record.Constant2
        .CalcLine = objTargetListView.SelectedItem.Index - 1
        
        .Show vbModal
    
        If .Updated = True Then
            
            '�X�V����Ă���Ȃ���e���i�[
            objCalc_C_Record.Variable1 = .Variable1
            objCalc_C_Record.CalcItemCd1 = .CalcItemCd1
            objCalc_C_Record.CalcSuffix1 = .CalcSuffix1
            objCalc_C_Record.CalcItemName1 = .CalcItemName1
            objCalc_C_Record.Constant1 = .Constant1
            objCalc_C_Record.Operator = .Operator
            objCalc_C_Record.Variable2 = .Variable2
            objCalc_C_Record.CalcItemCd2 = .CalcItemCd2
            objCalc_C_Record.CalcSuffix2 = .CalcSuffix2
            objCalc_C_Record.CalcItemName2 = .CalcItemName2
            objCalc_C_Record.Constant2 = .Constant2
        
            '���X�g�r���[�ĕ\��
            Call SetCalcListForListView(strTargetKey, False)
        
            '�v�Z�ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
        
        '�I�u�W�F�N�g�̔p��
        Set frmEditCalcItem = Nothing
        
    End With

End Sub

Private Sub cmdItemCopy_Click(Index As Integer)
    
    Call CopyItem(Index, False)
    
End Sub

Private Sub cmdNewHistory_Click()

    Dim strMsg      As String
    Dim intRet      As Integer

    If Screen.MousePointer = vbHourglass Then Exit Sub
    Screen.MousePointer = vbHourglass

    Do
        
        '���ڂ��X�V����Ă���ꍇ�́A�x�����b�Z�[�W
        If (mblnItemUpdated = True) Or (mblnHistoryUpdated = True) Then
            strMsg = "�f�[�^���X�V����Ă��܂��B�����f�[�^���ĕ\������ƕύX���e���j������܂�" & vbLf & _
                     "��낵���ł����H"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbNo Then Exit Do
        End If
        
        '�V�K�_�~�[���R�[�h�̍쐬
        Call AddNewCalc
        
        '�v�Z�ڍ׏��̕ҏW�i�V�K�Ȃ̂Ŗ{���s�v�����擪�Ń������N���A���Ă����܂��j
        If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
            Exit Do
        End If
        
        '�擾�v�Z���̃��X�g�r���[�i�[�i�V�K�Ȃ̂Ŗ{���s�v�����擪�Ń������N���A���Ă����܂��j
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        '�S�Ė��X�V��Ԃɖ߂�
'        mblnHistoryUpdated = False
        mblnHistoryUpdated = True       '�V�K�͍X�V����H
        mblnItemUpdated = False
        
        Exit Do
    Loop
    
    Screen.MousePointer = vbDefault
    
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
Private Sub cmdOk_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '�f�[�^�ۑ�
    If ApplyData(True) = True Then
        '��ʂ����
        Unload Me
    End If
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub


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
    Dim i   As Integer
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    mblnItemUpdated = False
    mblnNewRecordFlg = False
    
    '��ʏ�����
    TabMain.Tab = 0                 '�擪�^�u��Active
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    Do
        '�������ڊ�{���̎擾
        If GetItemInfo() = False Then
            Exit Do
        End If
        
        '�v�Z�����Ǘ����̕ҏW
        If EditCalc(mstrItemCd, mstrSuffix, False) = False Then
            Exit Do
        End If

        cboHistory.ListIndex = 0

        '�w�b�_���̕ҏW
        Call EditHeaderExplain

        '�v�Z�ڍ׏��̕ҏW
        If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
            Exit Do
        End If

        '�擾�v�Z���̃��X�g�r���[�i�[
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop

    '�A�N�Z�X�L�[�̂��߂Ƀ^�u�N���b�N����x�Ă�
    Call TabMain_Click(0)

    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub



Friend Property Let Suffix(ByVal vNewValue As Variant)

    mstrSuffix = vNewValue

End Property

Private Sub lsvItem_DblClick(Index As Integer)

    Call cmdEditItem_Click(Index)

End Sub

' @(e)
'
' �@�\�@�@ : �v�Z�����f�[�^�̐V�K�쐬
'
' �����@�@ : �Ȃ�
'
' �@�\���� : �V�K�쐬���Ɍv�Z�����f�[�^���f�t�H���g�쐬����
'
' ���l�@�@ :
'
Private Sub AddNewCalc()
    
    Dim objCalc_Record      As Calc_Record  '�v�Z���R�[�h�I�u�W�F�N�g
    Dim intArrCount         As Integer
    
    '�z�񐔂̎擾
    intArrCount = mcolCalcRecord.Count
    
    '�z����g���i�R���N�V�����̐��ō쐬����ƕK�R�I��+1�ɂȂ�j
    ReDim Preserve mstrArrCalcHNo(intArrCount)
    
    Set objCalc_Record = New Calc_Record
    With objCalc_Record
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        .CalcHNo = 100              '����ԍ��͂Q���Ȃ̂ł��肦�Ȃ��ԍ��ŐV�K�쐬
        .StrDate = YEARRANGE_MIN & "/01/01"
        .EndDate = YEARRANGE_MAX & "/12/31"
        .Fraction = 0
        .Timing = 0
        cboHistory.AddItem .StrDate & "�`" & .EndDate & "�ɓK�p����f�[�^"
        cboHistory.ListIndex = cboHistory.NewIndex
    End With
    
    '�z��ɑޔ�
    mstrArrCalcHNo(intArrCount) = KEY_PREFIX & objCalc_Record.CalcHNo
    
    '�R���N�V�����ǉ�
    mcolCalcRecord.Add objCalc_Record, KEY_PREFIX & objCalc_Record.CalcHNo

    '�s�������̂ōX�V���ꂽ���[�h
    mblnHistoryUpdated = True

    '�V�K�쐬���[�h
    mblnNewRecordFlg = True

    '���V�K�Ȃ̂ɐV�K�{�^���s�v���됧��
    cmdNewHistory.Enabled = False
    
    '�w�b�_���̕ҏW
    Call EditHeaderExplain
    
End Sub

' @(e)
'
' �@�\�@�@ : �V�K�v�Z�����f�[�^�̃������폜
'
' �����@�@ : �Ȃ�
'
' �@�\���� : �f�t�H���g�쐬�����v�Z�����f�[�^������������폜����
'
' ���l�@�@ :
'
Private Sub RemoveNewCalc()
    
    Dim objCalc_Record      As Calc_Record  '�v�Z���R�[�h�I�u�W�F�N�g
    Dim intArrCount         As Integer
    Dim intListIndex        As Integer
    
    '�z�񐔂̎擾
    intArrCount = mcolCalcRecord.Count
    
    '�z����k��
    ReDim Preserve mstrArrCalcHNo(intArrCount - 2)
    
    '�R���N�V��������폜
    mcolCalcRecord.Remove KEY_PREFIX & "100"

    '�R���{����폜
    intListIndex = cboHistory.NewIndex
    cboHistory.RemoveItem intListIndex
    If (intListIndex - 1) < 0 Then
        cboHistory.ListIndex = 0
    Else
        cboHistory.ListIndex = (intListIndex - 1)
    End If

    mblnHistoryUpdated = False
    mblnNewRecordFlg = False
    cmdNewHistory.Enabled = True
    
    '�w�b�_���̕ҏW
    Call EditHeaderExplain
    
End Sub

Private Sub CopyItem(Index As Integer, Cancel As Boolean)

    Dim intOtherIndex       As Integer
    Dim strMsg              As String
    Dim intRet              As Integer
    
    Dim strCurrName         As String
    Dim strOtherName        As String
    
    Dim objItem             As ListItem
    Dim i                   As Integer
    Dim j                   As Integer
    Dim intEscFieldCount    As Integer      '���X�g�r���[�P�s�̃T�u�A�C�e����
    Dim strTargetKey        As String
    Dim objCalc_C_Record    As Calc_C_Record

    '�����ʂƋt�̃C���f�b�N�X�����߂�
    intOtherIndex = 1 Xor Index
    
    If Index = 0 Then
        strCurrName = "�j���v�Z�ݒ藓"
        strOtherName = "�����v�Z�ݒ藓"
    Else
        strCurrName = "�����v�Z�ݒ藓"
        strOtherName = "�j���v�Z�ݒ藓"
    End If
    
    '�R�s�[���̃A�C�e�����m�F
    If (lsvItem(intOtherIndex).ListItems.Count = 0) And (Cancel = False) Then
        MsgBox strOtherName & "�ɍ��ڂ������ݒ肳��Ă��܂���", vbInformation
        Exit Sub
    End If
    
    '�����ڂ̃A�C�e���m�F
    If (lsvItem(Index).ListItems.Count > 0) And (Cancel = False) Then
    
        strMsg = strCurrName & "�ɍ��ڂ��ݒ肳��Ă��܂��B���ɂ��鍀�ڂɒǉ����܂����H" & vbLf & vbLf & _
                 "��������I������ƃN���A���Ă���ǉ����܂��B"
        intRet = MsgBox(strMsg, vbYesNoCancel + vbDefaultButton3 + vbExclamation)
        
        '�L�����Z�������ŏ����I��
        If intRet = vbCancel Then Exit Sub
    
        '�������Ȃ�P��N���A
        If intRet = vbNo Then
            lsvItem(Index).ListItems.Clear
        End If
    
    End If
    
    '�Ƃ��I���ڃR�s�[
    For i = 1 To lsvItem(intOtherIndex).ListItems.Count
        '�L�[�l�̎擾
        strTargetKey = lsvItem(intOtherIndex).ListItems(i).Key
        
        Set objCalc_C_Record = New Calc_C_Record
        
        With objCalc_C_Record
'            .ItemCd = mcolCalc_cRecord(strTargetKey).ItemCd
'            .Suffix = mcolCalc_cRecord(strTargetKey).Suffix
            
            .Gender = Index + 1
            
'            .Seq = mcolCalc_cRecord(strTargetKey).Seq
            .Variable1 = mcolCalc_cRecord(strTargetKey).Variable1
            .CalcItemCd1 = mcolCalc_cRecord(strTargetKey).CalcItemCd1
            .CalcSuffix1 = mcolCalc_cRecord(strTargetKey).CalcSuffix1
            .CalcItemName1 = mcolCalc_cRecord(strTargetKey).CalcItemName1
            .Constant1 = mcolCalc_cRecord(strTargetKey).Constant1
            .Operator = mcolCalc_cRecord(strTargetKey).Operator
            .Variable2 = mcolCalc_cRecord(strTargetKey).Variable2
            .CalcItemCd2 = mcolCalc_cRecord(strTargetKey).CalcItemCd2
            .CalcSuffix2 = mcolCalc_cRecord(strTargetKey).CalcSuffix2
            .CalcItemName2 = mcolCalc_cRecord(strTargetKey).CalcItemName2
            .Constant2 = mcolCalc_cRecord(strTargetKey).Constant2
        End With
    
        mcolCalc_cRecord.Add objCalc_C_Record, KEY_PREFIX & mintUniqueKey
        Call SetCalcListForListView(KEY_PREFIX & mintUniqueKey, True)
        mintUniqueKey = mintUniqueKey + 1
    
    Next i

    '��ʂ������̂ōĕ`��
    lsvItem(Index).Refresh
    
End Sub

Private Sub lsvItem_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)

    Dim i As Long

    'CTRL+A���������ꂽ�ꍇ�A���ڂ�S�đI������
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        
        With lsvItem(Index)
            For i = 1 To .ListItems.Count
                .ListItems(i).Selected = True
            Next i
        End With
    
    End If

End Sub

' @(e)
'
' �@�\�@�@ : ���X�g�r���[�w�b�_�ҏW
'
' �����@�@ : (In)   intListViewIndex    �Z�b�g���郊�X�g�r���[�̃C���f�b�N�X
'
' �߂�l�@ : �Ȃ�
'
' �@�\���� : �w�b�_���̕ҏW
'
' ���l�@�@ :
'
Private Sub EditListViewHeader(intListViewIndex As Integer)
    
    Dim objHeader           As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objTargetListView   As ListView
    
    Set objTargetListView = lsvItem(intListViewIndex)
    objTargetListView.ListItems.Clear
    Set objHeader = objTargetListView.ColumnHeaders
    
    With objHeader
        .Clear
        .Add , , "����", 3200, lvwColumnLeft
        .Add , , "���Z�q", 750, lvwColumnCenter
        .Add , , "�E��", 3200, lvwColumnLeft
    End With
    
    objTargetListView.View = lvwReport

End Sub

Private Sub EditHeaderExplain()
    
    Dim objCurCalc_Record       As Calc_Record
    
    '���݂̃J�����g�����I�u�W�F�N�g�ɃZ�b�g
    Set objCurCalc_Record = mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex))
    
    With objCurCalc_Record
        
        '�[������
        Select Case .Fraction
            Case 0
                lblFraction.Caption = "�l�̌ܓ�"
            Case 1
                lblFraction.Caption = "�؂�グ"
            Case 2
                lblFraction.Caption = "�؂�̂�"
        End Select
    
        '�v�Z�^�C�~���O
        Select Case .Timing
            Case 0
                lblTiming.Caption = "�S�Ă̒l���������Ƃ��Ɍv�Z"
            Case 1
                lblTiming.Caption = "�v�Z�v�f�̂����A��ł��l���������ꍇ"
        End Select
        
        '����
        lblExplanation.Caption = .Explanation
    
    End With

    Set objCurCalc_Record = Nothing

End Sub

Private Sub TabMain_Click(PreviousTab As Integer)
    
    Dim i As Integer
    
    '�A�N�e�B�u�^�u�C���f�b�N�X�Ɠ����Ȃ�R���g���[���͎g�p�\
    For i = 0 To 1
        lsvItem(i).Enabled = TabMain.Tab = i
        cmdItemCopy(i).Enabled = TabMain.Tab = i
        cmdAddItem(i).Enabled = TabMain.Tab = i
        cmdEditItem(i).Enabled = TabMain.Tab = i
        cmdDeleteItem(i).Enabled = TabMain.Tab = i
    Next i
    
End Sub
