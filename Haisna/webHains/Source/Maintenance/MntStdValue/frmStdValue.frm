VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmStdValue 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "��l�e�[�u�������e�i���X"
   ClientHeight    =   6855
   ClientLeft      =   1605
   ClientTop       =   1545
   ClientWidth     =   12315
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmStdValue.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6855
   ScaleWidth      =   12315
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin VB.CommandButton cmdOtherItemCopy 
      Caption         =   "���̌������ڂ����l���R�s�[����(&O)..."
      Height          =   375
      Left            =   180
      TabIndex        =   24
      Top             =   6360
      Width           =   3435
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   10740
      TabIndex        =   21
      Top             =   6420
      Width           =   1275
   End
   Begin TabDlg.SSTab TabMain 
      Height          =   5055
      Left            =   120
      TabIndex        =   8
      Top             =   1260
      Width           =   11955
      _ExtentX        =   21087
      _ExtentY        =   8916
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "�j��"
      TabPicture(0)   =   "frmStdValue.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Frame1"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "����"
      TabPicture(1)   =   "frmStdValue.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "cmdEditItem(1)"
      Tab(1).Control(1)=   "cmdAddItem(1)"
      Tab(1).Control(2)=   "cmdDeleteItem(1)"
      Tab(1).Control(3)=   "Frame2"
      Tab(1).ControlCount=   4
      Begin VB.CommandButton cmdEditItem 
         Caption         =   "�ҏW(&E)..."
         Height          =   315
         Index           =   1
         Left            =   -66000
         TabIndex        =   20
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "�ǉ�(&I)..."
         Height          =   315
         Index           =   1
         Left            =   -67380
         TabIndex        =   19
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "�폜(&R)"
         Height          =   315
         Index           =   1
         Left            =   -64620
         TabIndex        =   18
         Top             =   4320
         Width           =   1275
      End
      Begin VB.Frame Frame2 
         Caption         =   "�ݒ肵���l(&C)"
         Height          =   4335
         Left            =   -74820
         TabIndex        =   14
         Top             =   480
         Width           =   11595
         Begin VB.CommandButton cmdDownItem 
            Caption         =   "��"
            BeginProperty Font 
               Name            =   "MS UI Gothic"
               Size            =   9.75
               Charset         =   128
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   435
            Index           =   1
            Left            =   120
            TabIndex        =   26
            Top             =   1980
            Width           =   435
         End
         Begin VB.CommandButton cmdUpItem 
            Caption         =   "��"
            BeginProperty Font 
               Name            =   "MS UI Gothic"
               Size            =   9.75
               Charset         =   128
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   435
            Index           =   1
            Left            =   120
            TabIndex        =   25
            Top             =   1320
            Width           =   435
         End
         Begin VB.CommandButton cmdItemCopy 
            Caption         =   "�j���f�[�^����R�s�[(&C)..."
            Height          =   315
            Index           =   1
            Left            =   660
            TabIndex        =   23
            Top             =   3840
            Width           =   2055
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3495
            Index           =   1
            Left            =   660
            TabIndex        =   15
            Top             =   240
            Width           =   10815
            _ExtentX        =   19076
            _ExtentY        =   6165
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
      Begin VB.Frame Frame1 
         Caption         =   "�ݒ肵���l(&C)"
         Height          =   4335
         Left            =   180
         TabIndex        =   9
         Top             =   480
         Width           =   11595
         Begin VB.CommandButton cmdItemCopy 
            Caption         =   "�����f�[�^����R�s�[(&C)..."
            Height          =   315
            Index           =   0
            Left            =   660
            TabIndex        =   22
            Top             =   3840
            Width           =   2055
         End
         Begin VB.CommandButton cmdUpItem 
            Caption         =   "��"
            BeginProperty Font 
               Name            =   "MS UI Gothic"
               Size            =   9.75
               Charset         =   128
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   435
            Index           =   0
            Left            =   120
            TabIndex        =   17
            Top             =   1320
            Width           =   435
         End
         Begin VB.CommandButton cmdDownItem 
            Caption         =   "��"
            BeginProperty Font 
               Name            =   "MS UI Gothic"
               Size            =   9.75
               Charset         =   128
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   435
            Index           =   0
            Left            =   120
            TabIndex        =   16
            Top             =   1980
            Width           =   435
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "�폜(&R)"
            Height          =   315
            Index           =   0
            Left            =   10200
            TabIndex        =   12
            Top             =   3840
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "�ǉ�(&1)..."
            Height          =   315
            Index           =   0
            Left            =   7440
            TabIndex        =   11
            Top             =   3840
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditItem 
            Caption         =   "�ҏW(&E)..."
            Height          =   315
            Index           =   0
            Left            =   8820
            TabIndex        =   10
            Top             =   3840
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3495
            Index           =   0
            Left            =   660
            TabIndex        =   13
            Top             =   240
            Width           =   10815
            _ExtentX        =   19076
            _ExtentY        =   6165
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
   Begin VB.CommandButton cmdDeleteHistory 
      Caption         =   "�폜(&D)..."
      Enabled         =   0   'False
      Height          =   315
      Left            =   6060
      TabIndex        =   5
      Top             =   900
      Width           =   1275
   End
   Begin VB.CommandButton cmdEditHistory 
      Caption         =   "�ҏW(&H)..."
      Height          =   315
      Left            =   4680
      TabIndex        =   4
      Top             =   900
      Width           =   1275
   End
   Begin VB.CommandButton cmdNewHistory 
      Caption         =   "�V�K(&N)..."
      Height          =   315
      Left            =   3300
      TabIndex        =   3
      Top             =   900
      Width           =   1275
   End
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
      ItemData        =   "frmStdValue.frx":0044
      Left            =   1980
      List            =   "frmStdValue.frx":0066
      Style           =   2  '��ۯ���޳� ؽ�
      TabIndex        =   2
      Top             =   480
      Width           =   5370
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   7860
      TabIndex        =   0
      Top             =   6420
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   9300
      TabIndex        =   1
      Top             =   6420
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
            Picture         =   "frmStdValue.frx":0088
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmStdValue.frx":04DA
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmStdValue.frx":092C
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmStdValue.frx":0A86
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   120
      Picture         =   "frmStdValue.frx":0BE0
      Top             =   120
      Width           =   720
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
      Left            =   900
      TabIndex        =   7
      Top             =   240
      Width           =   6375
   End
   Begin VB.Label Label8 
      Caption         =   "�������(&H):"
      Height          =   195
      Index           =   0
      Left            =   900
      TabIndex        =   6
      Top             =   540
      Width           =   1095
   End
End
Attribute VB_Name = "frmStdValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================
'�Ǘ��ԍ��FSL-HS-Y0101-001
'���۔ԍ��FCOMP-LUKES-0013�i��݊����؁j
'�C����  �F2010.07.16
'�S����  �FFJTH)KOMURO
'�C�����e�F�w���X�|�C���g�̃R�s�[�R��C��
'========================================
Option Explicit

Private mstrStdValueMngCd       As String           '��l�l�Ǘ��R�[�h
Private mstrItemCd              As String           '�������ڃR�[�h
Private mstrSuffix              As String           '�T�t�B�b�N�X
Private mintResultType          As String           '���ʃ^�C�v
Private mintItemType            As String           '���ڃ^�C�v
Private mstrStcItemCd           As String           '���͎Q�Ɨp���ڃR�[�h

Private mblnInitialize          As Boolean          'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean          'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����

Private mintUniqueKey           As Long             '���X�g�r���[��ӃL�[�Ǘ��p�ԍ�
Private Const KEY_PREFIX        As String = "K"

Private mblnHistoryUpdated      As Boolean          'TRUE:��l�����X�V����AFALSE:��l�����X�V�Ȃ�
Private mblnItemUpdated         As Boolean          'TRUE:��l�ڍ׍X�V����AFALSE:��l�ڍ׍X�V�Ȃ�

Private mintBeforeIndex         As Integer          '�����R���{�ύX�L�����Z���p�̑OIndex
Private mblnNowEdit             As Boolean          'TRUE:�ҏW�������AFALSE:�����Ȃ�

Private mstrArrStdValueMngCd()  As String           '��l�Ǘ��R�[�h�i�R���{�{�b�N�X�Ή��p�j
Private mcolStdValueRecord      As Collection       '��l���R�[�h�̃R���N�V����
Private mcolStdValue_cRecord    As Collection       '��l�ڍ׃��R�[�h�̃R���N�V�����i�ǂݍ��ݒ���̂ݎg�p�j
Private mcolItemHistory         As Collection       '�������ڗ������R�[�h�̃R���N�V����

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
        
        '# �����Ċ�l���ׂ̖����̓`�F�b�N���s��Ȃ�
        '�i������Ԃŗ������쐬�{��l�Ȃ��Ȃ炻�̊��Ԃ�����l�ݒ���Ȃ��ɂł���j
        '�i�Ⴆ�΁A��l���ꊇ���ăN���A�������ꍇ�Ȃǁj
        
        '��l���ׁi�j�Ȃ��A������j�̏ꍇ
        If (lsvItem(0).ListItems.Count = 0) And (lsvItem(1).ListItems.Count > 0) Then
            strMsg = "�j���̊�l���ݒ肳��Ă��܂���B�����̊�l���R�s�[���Ċi�[���܂����H"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbYes Then
                Call CopyItem(0, True)
            End If
        End If

        '��l���ׁi���Ȃ��A�j����j�̏ꍇ
        If (lsvItem(1).ListItems.Count = 0) And (lsvItem(0).ListItems.Count > 0) Then
            strMsg = "�����̊�l���ݒ肳��Ă��܂���B�j���̊�l���R�s�[���Ċi�[���܂����H"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbYes Then
                Call CopyItem(1, True)
            End If
        End If

'        '�R�[�h�̓��̓`�F�b�N
'        If Trim(txtItemCd.Text) = "" Then
'            MsgBox "��l�Ǘ��R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
'            txtItemCd.SetFocus
'            Exit Do
'        End If
'
'        '���̂̓��̓`�F�b�N
'        If Trim(txtStdValueName.Text) = "" Then
'            MsgBox "��l�Ǘ��������͂���Ă��܂���B", vbCritical, App.Title
'            txtStdValueName.SetFocus
'            Exit Do
'        End If
'
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
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
Private Function EditStdValue(strItemCd As String, _
                              strSuffix As String, _
                              blnCopy As Boolean, _
                              Optional colWorkCollection As Collection) As Boolean

    Dim objStdValue         As Object           '��l�Ǘ��A�N�Z�X�p
    Dim vntStdValueMngCd    As Variant          '��l�Ǘ��R�[�h
    Dim vntItemCd           As Variant          '�������ڃR�[�h
    Dim vntSuffix           As Variant          '�T�t�B�b�N�X
    Dim vntStrDate          As Variant          '�g�p�J�n���t
    Dim vntEndDate          As Variant          '�g�p�I�����t
    Dim vntCsCd             As Variant          '�ΏۃR�[�X�R�[�h
    Dim vntItemName         As Variant          '�������ږ�
    Dim vntCsName           As Variant          '�ΏۃR�[�X��
    Dim lngCount            As Long             '���R�[�h��
    
    Dim i                   As Integer
    Dim Ret                 As Boolean          '�߂�l
    Dim objStdValue_Record  As StdValue_Record  '��l���R�[�h�I�u�W�F�N�g
    
    On Error GoTo ErrorHandle
    
    'COPY���[�h�łȂ��Ȃ�A�R���N�V����������
    If blnCopy = False Then
        Set mcolStdValueRecord = Nothing
        Set mcolStdValueRecord = New Collection
    End If
    
    Do
        '�������ڃR�[�h�B�T�t�B�b�N�X���ꂩ���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
'        If (mstrItemCd = "") Or (mstrSuffix = "") Then
        If (strItemCd = "") Or (strSuffix = "") Then
            Ret = True
            Exit Do
        End If
    
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objStdValue = CreateObject("HainsStdValue.StdValue")
        
        '��l�Ǘ��e�[�u�����R�[�h�ǂݍ���
        lngCount = objStdValue.SelectStdValueList("", _
                                                  strItemCd, _
                                                  strSuffix, _
                                                  vntStdValueMngCd, _
                                                  vntItemCd, _
                                                  vntSuffix, _
                                                  vntStrDate, _
                                                  vntEndDate, _
                                                  vntCsCd, _
                                                  vntItemName, _
                                                  vntCsName)
        
        
        If lngCount = 0 Then
            
            If blnCopy = False Then
                'COPY���[�h�łȂ��Ȃ�A�V�K�쐬
                '��l�Ǘ��e�[�u�������݂��Ȃ��ꍇ�i�V�K�쐬���[�h�j
                Call AddNewStdValue
            Else
                'COPY���[�h�Ȃ�ACOPY�ł��Ȃ�����G���[
                MsgBox "�I�����ꂽ���ڂɂ͊�l���ݒ肳��Ă��܂���B", vbExclamation, Me.Caption
                Exit Do
            End If
            
        Else
            
            '��l�Ǘ��e�[�u�������݂���ꍇ�i�X�V���[�h�j
        
            '�ǂݍ��ݓ��e�̕ҏW
            For i = 0 To lngCount - 1
                
                Set objStdValue_Record = Nothing
                Set objStdValue_Record = New StdValue_Record
                
                '�I�u�W�F�N�g�쐬
                With objStdValue_Record
                    .StdValueMngCd = vntStdValueMngCd(i)
                    .ItemCd = vntItemCd(i)
                    .Suffix = vntSuffix(i)
                    .strDate = vntStrDate(i)
                    .endDate = vntEndDate(i)
                    .CsCd = vntCsCd(i)
                    .CsName = vntCsName(i)
                End With
                
                If blnCopy = False Then
                    'COPY���[�h�łȂ��Ȃ�A���f�[�^�Ƃ��Ċi�[
                    
                    '�z��쐬
                    If Trim(vntCsName(i)) = "" Then
                        cboHistory.AddItem CStr(vntStrDate(i)) & "�`" & CStr(vntEndDate(i)) & "�ɓK�p����f�[�^"
                    Else
                        cboHistory.AddItem CStr(vntStrDate(i)) & "�`" & CStr(vntEndDate(i)) & "�i" & vntCsName(i) & "�j�ɓK�p����f�[�^"
                    End If
                    
                    '�R���{�{�b�N�X�Ή��z��̍쐬
                    ReDim Preserve mstrArrStdValueMngCd(i)
                    mstrArrStdValueMngCd(i) = KEY_PREFIX & objStdValue_Record.StdValueMngCd
                    
                    '�R���N�V�����ǉ�
                    mcolStdValueRecord.Add objStdValue_Record, KEY_PREFIX & objStdValue_Record.StdValueMngCd
                
                Else
                    'COPY���[�h�Ȃ�A�����̃R���N�V�����Ɋi�[
                    
                    '�R���N�V�����ǉ�
                    colWorkCollection.Add objStdValue_Record, KEY_PREFIX & objStdValue_Record.StdValueMngCd
                
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
    Set objStdValue = Nothing
    EditStdValue = Ret
    
    Exit Function

ErrorHandle:

    EditStdValue = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' �@�\�@�@ : ��l�ڍ׏��̎擾
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function GetStdValue_c(strStdValueMngCd As String, blnCopy As Boolean) As Boolean

    Dim objStdValue             As Object       '��l�Ǘ��A�N�Z�X�p
    
    Dim vntStdValueCd           As Variant      '��l�R�[�h
    Dim vntGender               As Variant      '����
    Dim vntStrAge               As Variant      '�J�n�N��
    Dim vntEndAge               As Variant      '�I���N��
    Dim vntPriorSeq             As Variant      '�K�p�D�揇�ʔԍ�
    Dim vntLowerValue           As Variant      '��l�i�ȏ�j
    Dim vntUpperValue           As Variant      '��l�i�ȉ��j
    Dim vntStdFlg               As Variant      '��l�t���O
    Dim vntJudCd                As Variant      '����R�[�h
    Dim vntJudCmtCd             As Variant      '����R�����g�R�[�h
    Dim vntHealthPoint          As Variant      '�w���X�|�C���g
    Dim vntSentence             As Variant      '����
    Dim lngCount                As Long         '���R�[�h��
'    Dim strStdValueMngCd        As String
    
    Dim i                       As Integer
    Dim Ret                     As Boolean      '�߂�l
    
    Dim objStdValue_C_Record    As StdValue_C_Record    '��l�ڍ׃��R�[�h�I�u�W�F�N�g
    
    On Error GoTo ErrorHandle
        
    '���ݕ\�����Ă���l�̃N���A (COPY���[�h�̂Ƃ����N���A�j
    Set mcolStdValue_cRecord = Nothing
    Set mcolStdValue_cRecord = New Collection

    Do
        '��l�Ǘ��R�[�h���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If (strStdValueMngCd = "") Or (strStdValueMngCd = "0") Then
            Ret = True
            Exit Do
        End If
    
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objStdValue = CreateObject("HainsStdValue.StdValue")
        
        '��l�Ǘ��e�[�u�����R�[�h�ǂݍ���
        lngCount = objStdValue.SelectStdValue_cList(strStdValueMngCd, _
                                                    vntStdValueCd, _
                                                    vntGender, _
                                                    vntStrAge, _
                                                    vntEndAge, _
                                                    vntPriorSeq, _
                                                    vntLowerValue, _
                                                    vntUpperValue, _
                                                    vntStdFlg, _
                                                    vntJudCd, _
                                                    vntJudCmtCd, _
                                                    vntHealthPoint, _
                                                    vntSentence)
        
        '0���ł��s�v�c�Ȃ�
        If lngCount = 0 Then
            Ret = True
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW
        For i = 0 To lngCount - 1
            '�ǂݍ��ݓ��e���I�u�W�F�N�g�ɃZ�b�g
            Set objStdValue_C_Record = New StdValue_C_Record
            With objStdValue_C_Record
                
                If blnCopy = True Then
                    'Copy���[�h�̏ꍇ�A��l�Ǘ��R�[�h�͂��Ƃ̂܂܁A����l�R�[�h�̓Z�b�g���Ȃ��i�V�K�C���[�W�j
                    .StdValueMngCd = mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd
                    .StdValueCd = ""
                Else
                    .StdValueMngCd = strStdValueMngCd
                    .StdValueCd = vntStdValueCd(i)
                End If
                
                .Gender = vntGender(i)
                .StrAge = vntStrAge(i)
                .EndAge = vntEndAge(i)
                .PriorSeq = vntPriorSeq(i)
                .LowerValue = vntLowerValue(i)
                .UpperValue = vntUpperValue(i)
                .StdFlg = vntStdFlg(i)
                .JudCd = vntJudCd(i)
                .JudCmtCd = vntJudCmtCd(i)
                .HealthPoint = vntHealthPoint(i)
                .Sentence = vntSentence(i)
            End With
            
            '�R���N�V�����ɒǉ�
            mcolStdValue_cRecord.Add objStdValue_C_Record, KEY_PREFIX & vntStdValueCd(i)
            
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    Set objStdValue = Nothing
    
    '�߂�l�̐ݒ�
    GetStdValue_c = Ret
    
    Exit Function

ErrorHandle:

    GetStdValue_c = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' �@�\�@�@ : ��l�ڍ׏��̕\���i�R���N�V��������j
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditListViewFromCollection() As Boolean

On Error GoTo ErrorHandle

    Dim objItem     As ListItem             '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntCsCd     As Variant              '�R�[�X�R�[�h
    Dim vntCsName   As Variant              '�R�[�X��
    Dim lngCount    As Long                 '���R�[�h��
    Dim i           As Long                 '�C���f�b�N�X
    Dim objStdValue_C_Record    As StdValue_C_Record    '��l�ڍ׃��R�[�h�I�u�W�F�N�g
    
    EditListViewFromCollection = False

    '���X�g�r���[�p�w�b�_����
    For i = 0 To 1
        Call EditListViewHeader(CInt(i))
    Next i
    
    '���X�g�r���[�p���j�[�N�L�[������
    mintUniqueKey = 1
    
    '���X�g�̕ҏW
    For Each objStdValue_C_Record In mcolStdValue_cRecord
        With objStdValue_C_Record
            
            '���ʂɂ��Z�b�g���郊�X�g�r���[��ύX����
            i = .Gender - 1
        
            Set objItem = lsvItem(i).ListItems.Add(, KEY_PREFIX & mintUniqueKey, .StrAge, , "DEFAULTLIST")
            objItem.SubItems(1) = .EndAge
            objItem.SubItems(2) = .LowerValue
            If mintResultType = RESULTTYPE_SENTENCE Then
                objItem.SubItems(3) = .Sentence
            Else
                objItem.SubItems(3) = .UpperValue
            End If
            objItem.SubItems(4) = .StdFlg
            objItem.SubItems(5) = .JudCd
            objItem.SubItems(6) = .JudCmtCd
            objItem.SubItems(7) = .HealthPoint
            objItem.SubItems(8) = .StdValueCd
        
        End With
        mintUniqueKey = mintUniqueKey + 1
    
    Next objStdValue_C_Record
    
    '�I�u�W�F�N�g�p��
    Set objStdValue_C_Record = Nothing
    
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
    
    Dim Ret         As Boolean              '�߂�l
    
    GetItemInfo = False
    
    On Error GoTo ErrorHandle
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If (mstrItemCd = "") Or (mstrSuffix = "") Then
            Ret = False
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
                                    vntResultTypeName, , , , vntStcItemCd _
                                    ) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW
        mintResultType = CInt(vntResultType)        '���ʃ^�C�v�̕ҏW
        mintItemType = CInt(vntItemType)            '���ڃ^�C�v�̕ҏW
        mstrStcItemCd = CStr(vntStcItemCd)          '�����Q�Ɨp�R�[�h�̕ҏW
        
        lblItemInfo.Caption = mstrItemCd & "-" & mstrSuffix & "�F" & vntItemName
        Select Case mintResultType
            Case RESULTTYPE_NUMERIC
                lblItemInfo.Caption = lblItemInfo.Caption & "�i���l�^�C�v�j"
            Case RESULTTYPE_TEISEI1
                lblItemInfo.Caption = lblItemInfo.Caption & "�i�萫�P�^�C�v�j"
            Case RESULTTYPE_TEISEI2
                lblItemInfo.Caption = lblItemInfo.Caption & "�i�萫�Q�^�C�v�j"
            Case RESULTTYPE_SENTENCE
                lblItemInfo.Caption = lblItemInfo.Caption & "�i���̓^�C�v�j"
            Case RESULTTYPE_CALC
                lblItemInfo.Caption = lblItemInfo.Caption & "�i�v�Z�^�C�v�j"
            Case RESULTTYPE_DATE
                lblItemInfo.Caption = lblItemInfo.Caption & "�i���t�^�C�v�j"
            Case Else
                lblItemInfo.Caption = lblItemInfo.Caption & "�i�H�K��O�̌��ʃ^�C�v�j"
        End Select
        
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    GetItemInfo = Ret
    
    Exit Function

ErrorHandle:

    GetItemInfo = False
    MsgBox Err.Description, vbCritical
    
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
Private Function RegistStdValue() As Boolean

On Error GoTo ErrorHandle

    Dim objStdValue             As Object       '��l�Ǘ��A�N�Z�X�p
    Dim Ret                     As Long
    Dim objCurStdValue_Record   As StdValue_Record
    
    '�V�K�o�^���̑ޔ�p
    Dim blnNewRecordFlg         As Boolean
    Dim strEscItemCd            As String
    Dim strEscSuffix            As String
    Dim strEscStrDate           As String
    Dim strEscEndDate           As String
    Dim strEscCsCd              As String

    '��l
    Dim lngStdValueMngCd        As Long

    '��l�ڍׂ̔z��֘A
    Dim intItemCount            As Integer
    Dim vntStdValueCd           As Variant
    Dim vntGender               As Variant
    Dim vntStrAge               As Variant
    Dim vntEndAge               As Variant
    Dim vntPriorSeq             As Variant
    Dim vntLowerValue           As Variant
    Dim vntUpperValue           As Variant
    Dim vntStdFlg               As Variant
    Dim vntJudCd                As Variant
    Dim vntJudCmtCd             As Variant
    Dim vntHealthPoint          As Variant
    
    Dim blnBeforeUpdatePoint    As Boolean      'TRUE:�X�V�O�AFALSE:�X�V�O�ł͂Ȃ�
    
    blnBeforeUpdatePoint = False
    
    '�V�K�}�����̓t���O����
    blnNewRecordFlg = False
    If mstrArrStdValueMngCd(cboHistory.ListIndex) = "K0" Then
        blnNewRecordFlg = True
    End If

    '���݂̃J�����g�����I�u�W�F�N�g�ɃZ�b�g
    Set objCurStdValue_Record = mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex))
    
    '��l�Ǘ��e�[�u�����R�[�h�̓o�^
    With objCurStdValue_Record
        
        '�V�K�}�����[�h�̏ꍇ�A�ݒ���e��ޔ�
        If blnNewRecordFlg = True Then
            strEscItemCd = .ItemCd
            strEscSuffix = .Suffix
            strEscStrDate = .strDate
            strEscEndDate = .endDate
            strEscCsCd = .CsCd
        End If
        
        '��l�Ǘ��R�[�h�̃Z�b�g
        lngStdValueMngCd = .StdValueMngCd
        
        '��l�ڍ׃e�[�u���̔z��Z�b�g
        Call EditArrayForUpdate(intItemCount, _
                                vntStdValueCd, _
                                vntGender, _
                                vntStrAge, _
                                vntEndAge, _
                                vntPriorSeq, _
                                vntLowerValue, _
                                vntUpperValue, _
                                vntStdFlg, _
                                vntJudCd, _
                                vntJudCmtCd, _
                                vntHealthPoint)
        
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objStdValue = CreateObject("HainsStdValue.StdValue")
    
        blnBeforeUpdatePoint = True
    
        '��l�f�[�^�̓o�^
        Ret = objStdValue.RegistStdValue_All(lngStdValueMngCd, _
                                             .ItemCd, _
                                             .Suffix, _
                                             .strDate, _
                                             .endDate, _
                                             .CsCd, _
                                             intItemCount, _
                                             vntStdValueCd, _
                                             vntGender, _
                                             vntStrAge, _
                                             vntEndAge, _
                                             vntPriorSeq, _
                                             vntLowerValue, _
                                             vntUpperValue, _
                                             vntStdFlg, _
                                             vntJudCd, _
                                             vntJudCmtCd, _
                                             vntHealthPoint)
    End With
    
    blnBeforeUpdatePoint = False
    
    If Ret = INSERT_DUPLICATE Then
        MsgBox "���͂��ꂽ��l�Ǘ��R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistStdValue = False
        Exit Function
    End If
'
'    If Ret = INSERT_FKEYERROR Then
'        MsgBox "�폜�w�肳�ꂽ�ݒ��l�͊��Ɍ������ʂ̊�l�Ƃ��ăZ�b�g����Ă��܂��B" & vbLf & _
'               "�R�s�[�@�\�Ȃǂ��w�肵�ēo�^�����ꍇ�́A����̒l��ݒ肵�Ȃ������A" & vbLf & _
'               "�����Ǘ��@�\���g�p���ĐV������l�������쐬���Ă��������B", vbCritical
'        RegistStdValue = False
'        Exit Function
'    End If
    
    If Ret = INSERT_ERROR Then
        MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical
        RegistStdValue = False
        Exit Function
    End If
    
    '�V�K�}�����[�h�̏ꍇ�A�ݒ���e��ޔ�
    If blnNewRecordFlg = True Then
        
        '�V������l�����I�u�W�F�N�g���쐬
        Set objCurStdValue_Record = Nothing
        Set objCurStdValue_Record = New StdValue_Record
        With objCurStdValue_Record
            .StdValueMngCd = lngStdValueMngCd
            .ItemCd = strEscItemCd
            .Suffix = strEscSuffix
            .strDate = strEscStrDate
            .endDate = strEscEndDate
            .CsCd = strEscCsCd
        End With
        
        '���݂̒l(0)���R���N�V��������폜���Ĕ��Ԃ��ꂽ��l�����R�[�h�ŃR���N�V�����ǉ�
        mcolStdValueRecord.Remove (mstrArrStdValueMngCd(cboHistory.ListIndex))
        mcolStdValueRecord.Add objCurStdValue_Record, KEY_PREFIX & lngStdValueMngCd
        
        '�R���{�{�b�N�X�̒l���ύX
        mstrArrStdValueMngCd(cboHistory.ListIndex) = KEY_PREFIX & lngStdValueMngCd

    End If

    '�����V�K�ł͂Ȃ��̂Ń{�^���g�p�\
    cmdNewHistory.Enabled = True
    
    '�X�V�ς݃t���O��������
    mblnHistoryUpdated = False
    mblnItemUpdated = False
    
    RegistStdValue = True
    
    Exit Function
    
ErrorHandle:

    RegistStdValue = False
    
    If blnBeforeUpdatePoint = True Then
        MsgBox "��l�������ݏ����Ɏ��s���܂����B�����Ƃ��Ă͈ȉ��̎��R���l�����܂��B" & vbLf & vbLf & _
               "�E�ݒ肳��Ă����l���g�p���Ă��錟�����ʂ����݂���ɂ��ւ�炸�A���̊�l���폜�����B" & vbLf & _
               "�E�ݒ肳��Ă����l���g�p���Ă��錟�����ʂ����݂���ɂ��ւ�炸�A�j���R�s�[�@�\���g�p�����B" & vbLf & _
               "�E�ݒ肳��Ă����l���g�p���Ă��錟�����ʂ����݂���ɂ��ւ�炸�A���̑����ڃR�s�[�@�\���g�p�����B" & vbLf & _
               "�E�l�b�g���[�N�Ăяo���G���[�ACOM+�ݒ�G���[��..." & vbLf _
               , vbCritical
    Else
        MsgBox Err.Description, vbCritical
    End If
    
End Function
Private Sub EditArrayForUpdate(intItemCount As Integer, _
                               vntStdValueCd As Variant, _
                               vntGender As Variant, _
                               vntStrAge As Variant, _
                               vntEndAge As Variant, _
                               vntPriorSeq As Variant, _
                               vntLowerValue As Variant, _
                               vntUpperValue As Variant, _
                               vntStdFlg As Variant, _
                               vntJudCd As Variant, _
                               vntJudCmtCd As Variant, _
                               vntHealthPoint As Variant)

    Dim vntArrStdValueCd()      As Variant
    Dim vntArrGender()          As Variant
    Dim vntArrStrAge()          As Variant
    Dim vntArrEndAge()          As Variant
    Dim vntArrPriorSeq()        As Variant
    Dim vntArrLowerValue()      As Variant
    Dim vntArrUpperValue()      As Variant
    Dim vntArrStdFlg()          As Variant
    Dim vntArrJudCd()           As Variant
    Dim vntArrJudCmtCd()        As Variant
    Dim vntArrHealthPoint()     As Variant
    
    Dim i                       As Integer
    Dim intArrCount             As Integer
    Dim intListViewIndex        As Integer
    Dim obTargetListView        As ListView

    intArrCount = 0

    '�j�����X�g�r���[�̒��g���Z�b�g
    For intListViewIndex = 0 To 1
    
        '�N���b�N���ꂽ�C���f�b�N�X�Ő��ʂ�I��
        Set obTargetListView = lsvItem(intListViewIndex)
    
        '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
        For i = 1 To obTargetListView.ListItems.Count
    
            ReDim Preserve vntArrStdValueCd(intArrCount)
            ReDim Preserve vntArrGender(intArrCount)
            ReDim Preserve vntArrStrAge(intArrCount)
            ReDim Preserve vntArrEndAge(intArrCount)
            ReDim Preserve vntArrPriorSeq(intArrCount)
            ReDim Preserve vntArrLowerValue(intArrCount)
            ReDim Preserve vntArrUpperValue(intArrCount)
            ReDim Preserve vntArrStdFlg(intArrCount)
            ReDim Preserve vntArrJudCd(intArrCount)
            ReDim Preserve vntArrJudCmtCd(intArrCount)
            ReDim Preserve vntArrHealthPoint(intArrCount)
    
            With obTargetListView.ListItems(i)
                
                vntArrStdValueCd(intArrCount) = .SubItems(8)
                vntArrGender(intArrCount) = intListViewIndex + 1
                vntArrStrAge(intArrCount) = .Text
                vntArrEndAge(intArrCount) = .SubItems(1)
                vntArrPriorSeq(intArrCount) = i
                vntArrLowerValue(intArrCount) = .SubItems(2)
                
                If (mintResultType = RESULTTYPE_TEISEI1) Or _
                   (mintResultType = RESULTTYPE_TEISEI2) Or _
                   (mintResultType = RESULTTYPE_SENTENCE) Then
                    '���́A�萫�̏ꍇ�́A�J�n�l���I���l�ɂ��Z�b�g
                    vntArrUpperValue(intArrCount) = .SubItems(2)
                Else
                    vntArrUpperValue(intArrCount) = .SubItems(3)
                End If
                
                
                
                vntArrStdFlg(intArrCount) = .SubItems(4)
                vntArrJudCd(intArrCount) = .SubItems(5)
                vntArrJudCmtCd(intArrCount) = .SubItems(6)
                vntArrHealthPoint(intArrCount) = .SubItems(7)
            
            End With
            
            intArrCount = intArrCount + 1
    
        Next i
    
    Next intListViewIndex

    vntStdValueCd = vntArrStdValueCd
    vntGender = vntArrGender
    vntStrAge = vntArrStrAge
    vntEndAge = vntArrEndAge
    vntPriorSeq = vntArrPriorSeq
    vntLowerValue = vntArrLowerValue
    vntUpperValue = vntArrUpperValue
    vntStdFlg = vntArrStdFlg
    vntJudCd = vntArrJudCd
    vntJudCmtCd = vntArrJudCmtCd
    vntHealthPoint = vntArrHealthPoint

    intItemCount = intArrCount

End Sub

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
            strMsg = "��l�̐ݒ���e���X�V����Ă��܂��B�����f�[�^���ĕ\������ƕύX���e���j������܂�" & vbLf & _
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
        
        '��l�ڍ׏��̕ҏW
        If GetStdValue_c(mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd, False) = False Then
            Exit Do
        End If
        
        '�擾��l���̃��X�g�r���[�i�[
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


Private Sub cmdAddItem_Click(Index As Integer)

    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    
    Dim strStrAge           As String           '�J�n�N��
    Dim strEndAge           As String           '�I���N��
    Dim strLowerValue       As String           '��l�i�ȏ�j
    Dim strUpperValue       As String           '��l�i�ȉ��j
    Dim strStdFlg           As String           '��l�t���O
    Dim strJudCd            As String           '����R�[�h
    Dim strJudCmtCd         As String           '����R�����g�R�[�h
    Dim strHealthPoint      As String           '�w���X�|�C���g
    
    Dim vntStcCd            As Variant          '��l�p���̓R�[�h�z��
    Dim vntSentence         As Variant          '���͔z��
    Dim intSentenceCount    As Integer          '�I�����ꂽ���͂̐�
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ő��ʂ�I��
    Set obTargetListView = lsvItem(Index)

    With frmEditStdValueItem
        
        .ResultType = mintResultType
        .ItemType = mintItemType
        .StcItemCd = mstrStcItemCd
        .ItemHistory = mcolItemHistory
        
        .Show vbModal
    
        If .Updated = True Then
            
            strStrAge = .StrAge
            strEndAge = .EndAge
            strLowerValue = .LowerValue
            strUpperValue = .UpperValue
            strStdFlg = .StdFlg
            strJudCd = .JudCd
            strJudCmtCd = .JudCmtCd
            strHealthPoint = .HealthPoint
            
            vntStcCd = .StcCd
            vntSentence = .Sentence
            intSentenceCount = .SentenceCount
            
            If mintResultType = RESULTTYPE_SENTENCE Then
                '���̓^�C�v�̏ꍇ
                For i = 0 To intSentenceCount - 1
                    
                    '�X�V����Ă���Ȃ�A���X�g�r���[�ɒǉ�
                    Set objItem = obTargetListView.ListItems.Add(, KEY_PREFIX & mintUniqueKey, strStrAge, , "DEFAULTLIST")
                    objItem.SubItems(1) = strEndAge
                    objItem.SubItems(2) = vntStcCd(i)
                    objItem.SubItems(3) = vntSentence(i)
                    objItem.SubItems(4) = strStdFlg
                    objItem.SubItems(5) = strJudCd
                    objItem.SubItems(6) = strJudCmtCd
                    objItem.SubItems(7) = strHealthPoint
'#### 2010.07.16 SL-HS-Y0101-001 ADD START ####�@COMP-LUKES-0013�i��݊����؁j
                    objItem.SubItems(8) = ""
'#### 2010.07.16 SL-HS-Y0101-001 ADD END ####�@�@COMP-LUKES-0013�i��݊����؁j
                
                    mintUniqueKey = mintUniqueKey + 1
                
                Next i
            
            Else
                '���̓^�C�v�ȊO�̏ꍇ
            
                '�X�V����Ă���Ȃ�A���X�g�r���[�ɒǉ�
                Set objItem = obTargetListView.ListItems.Add(, KEY_PREFIX & mintUniqueKey, strStrAge, , "DEFAULTLIST")
                objItem.SubItems(1) = strEndAge
                objItem.SubItems(2) = strLowerValue
                objItem.SubItems(3) = strUpperValue
                objItem.SubItems(4) = strStdFlg
                objItem.SubItems(5) = strJudCd
                objItem.SubItems(6) = strJudCmtCd
                objItem.SubItems(7) = strHealthPoint
'#### 2010.07.16 SL-HS-Y0101-001 ADD START ####�@COMP-LUKES-0013�i��݊����؁j
                objItem.SubItems(8) = ""
'#### 2010.07.16 SL-HS-Y0101-001 ADD END ####�@�@COMP-LUKES-0013�i��݊����؁j
            
                mintUniqueKey = mintUniqueKey + 1
            End If
            
            '��l�ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
        
    End With
    
    '�I�u�W�F�N�g�̔p��
    Set frmEditStdValueItem = Nothing
    
End Sub

Private Sub cmdApply_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '�f�[�^�̕ۑ�
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
    
    '��l�Ǘ��e�[�u���̓o�^
    If RegistStdValue() = False Then
        Exit Function
    End If
    
    '�X�V�ς݃t���O��TRUE��
    mblnUpdated = True
        
    'OK�{�^���������������ŏI��
    If blnOkMode = True Then
        ApplyData = True
        Exit Function
    End If
        
    MsgBox "���͂��ꂽ���e��ۑ����܂����B", vbInformation

    '��l�ڍ׏��̕ҏW�i��ʍĕ\�����s�����Ƃɂ���l�R�[�h���Ď擾�j
    If GetStdValue_c(mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd, False) = False Then
        Exit Function
    End If
    
    '�擾��l���̃��X�g�r���[�i�[
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
            obTargetListView.ListItems.Remove (obTargetListView.ListItems(i).Key)
            '�A�C�e�������ς��̂�-1���čČ���
            i = i - 1
            '��l�ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
    
    Next i

End Sub

Private Sub cmdDownItem_Click(Index As Integer)
    
    Call MoveListItem(1, Index)

End Sub

Private Sub cmdEditHistory_Click()

    Dim objCurStdValue_Record As StdValue_Record
    Set objCurStdValue_Record = mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex))

    With frmEditStdValueHistory
        
        '�v���p�e�B�Z�b�g
        .strDate = objCurStdValue_Record.strDate
        .endDate = objCurStdValue_Record.endDate
        .CsCd = objCurStdValue_Record.CsCd
        
        '��ʕ\��
        .Show vbModal
    
        '�X�V����Ă���ꍇ�A���݂̃I�u�W�F�N�g��Ԃ��X�V
        If .Updated = True Then
        
            '�I�u�W�F�N�g���e���X�V
            objCurStdValue_Record.strDate = .strDate
            objCurStdValue_Record.endDate = .endDate
            objCurStdValue_Record.CsCd = .CsCd
            
            '�R���{�{�b�N�X�̕\�����e��ύX
            If Trim(.CsCd) = "" Then
                cboHistory.List(cboHistory.ListIndex) = .strDate & "�`" & .endDate & "�ɓK�p����f�[�^"
            Else
                cboHistory.List(cboHistory.ListIndex) = .strDate & "�`" & .endDate & "�i" & .CsName & "�j�ɓK�p����f�[�^"
            End If
            
            '�X�V���ꂽ���[�h
            mblnHistoryUpdated = True
        
        End If
        
    End With

End Sub

Private Sub cmdEditItem_Click(Index As Integer)

    Dim i                       As Integer
    Dim strTargetKey            As String
    Dim strTargetDiv            As String
    Dim strTargetCd             As String
    Dim obTargetListView        As ListView
    
    Dim intArrSelectedIndex()   As Integer
    Dim intSelectedCount        As Integer
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ő��ʂ�I��
    Set obTargetListView = lsvItem(Index)
    
    '���X�g�r���[��̑I�����ڐ����J�E���g
    intSelectedCount = 0
    With obTargetListView
        For i = 1 To .ListItems.Count
            If .ListItems(i).Selected = True Then
                ReDim Preserve intArrSelectedIndex(intSelectedCount)
                intArrSelectedIndex(intSelectedCount) = i
                intSelectedCount = intSelectedCount + 1
            End If
        Next i
    End With
    
    '�����I������Ă��Ȃ��Ȃ珈���I��
    If intSelectedCount = 0 Then Exit Sub
    
    '�����I����ԂȂ�ꉞ�P�񕷂��Ă�����
    If intSelectedCount > 1 Then
        If MsgBox("���ڂ������I������Ă��܂��B�I�����ꂽ���ڑS�Ăɓ����ݒ��K�p���鏈�����s���܂����H", vbYesNo + vbDefaultButton2 + vbQuestion, Me.Caption) = vbNo Then
            Exit Sub
        End If
    End If
    
    With frmEditStdValueItem
        
        '�K�C�h�ɑ΂���v���p�e�B�Z�b�g�i�����I���̏ꍇ�͂Ƃ肠�����擪���Z�b�g�j
        .ResultType = mintResultType
        .ItemType = mintItemType
        .StcItemCd = mstrStcItemCd
        
        .StrAge = obTargetListView.ListItems(intArrSelectedIndex(0)).Text
        .EndAge = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(1)
        .LowerValue = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(2)
        .UpperValue = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(3)
        .StdFlg = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(4)
        .JudCd = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(5)
        .JudCmtCd = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(6)
        .HealthPoint = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(7)
        If intSelectedCount > 1 Then
            .MultiSelect = True
        Else
            .MultiSelect = False
        End If
        .ItemHistory = mcolItemHistory
    
        .Show vbModal
    
        If .Updated = True Then
            
            For i = 0 To UBound(intArrSelectedIndex)
            
                obTargetListView.ListItems(intArrSelectedIndex(i)).Text = .StrAge
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(1) = .EndAge
                
                If intSelectedCount = 1 Then
                    
                    If mintResultType = RESULTTYPE_SENTENCE Then
                        obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(2) = .StcCd(0)
                        obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(3) = .Sentence(0)
                    Else
                        obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(2) = .LowerValue
                        obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(3) = .UpperValue
                    End If
                                    
                End If
                
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(4) = .StdFlg
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(5) = .JudCd
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(6) = .JudCmtCd
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(7) = .HealthPoint
            
            Next i
        
            '��l�ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
        
        '�I�u�W�F�N�g�̔p��
        Set frmEditStdValueItem = Nothing
        
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
            strMsg = "��l�̐ݒ���e���X�V����Ă��܂��B�����f�[�^���ĕ\������ƕύX���e���j������܂�" & vbLf & _
                     "��낵���ł����H"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbNo Then Exit Sub
        End If
        
        '�V�K�_�~�[���R�[�h�̍쐬
        Call AddNewStdValue
        
        '��l�ڍ׏��̕ҏW�i�V�K�Ȃ̂Ŗ{���s�v�����擪�Ń������N���A���Ă����܂��j
        If GetStdValue_c(mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd, False) = False Then
            Exit Do
        End If
        
        '�擾��l���̃��X�g�r���[�i�[�i�V�K�Ȃ̂Ŗ{���s�v�����擪�Ń������N���A���Ă����܂��j
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        '�S�Ė��X�V��Ԃɖ߂�
        mblnHistoryUpdated = False
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
    
    '�f�[�^�̕ۑ�
    If ApplyData(True) = True Then
        '��ʂ����
        Unload Me
    End If
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub cmdOtherItemCopy_Click()
    
    Dim objItemGuide        As mntItemGuide.ItemGuide   '���ڃK�C�h�\���p
    
    Dim lngItemCount        As Long     '�I�����ڐ�
    Dim vntItemCd           As Variant  '�I�����ꂽ���ڃR�[�h
    Dim vntSuffix           As Variant  '�I�����ꂽ�T�t�B�b�N�X
    Dim i                   As Integer
    Dim blnUpdated          As Boolean
    Dim strMsg              As String
    Dim colWorkCollection   As Collection
    
    '��l�f�[�^���P�ł��ݒ肳��Ă���ꍇ�ɃA���[�g
    If (lsvItem(0).ListItems.Count > 0) Or (lsvItem(0).ListItems.Count > 0) Then
        strMsg = "���̃f�[�^����R�s�[���s���ƌ��ݐݒ肳��Ă����l�̓N���A�[����܂��B��낵���ł����H" & vbLf & vbLf & _
                 "�܂��A���ݐݒ肳��Ă����l�R�[�h���g�p���Ă��錟�����ڂ����݂��Ă���ꍇ�A�ۑ����ɎQ�ƃG���[�Ŏ��s����ꍇ������܂��B"
        If MsgBox(strMsg, vbQuestion + vbYesNo + vbDefaultButton2, Me.Caption) = vbNo Then
            Exit Sub
        End If
    End If
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
        .ResultType = mintResultType
        .MultiSelect = False
    
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
        
        '�߂�l�Ƃ��Ẵv���p�e�B�擾
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
    
    End With

    Set objItemGuide = Nothing
        
    '�I��������0���ȏ�Ȃ�
    If lngItemCount > 0 Then

        Set colWorkCollection = Nothing
        Set colWorkCollection = New Collection

        '��l�����Ǘ����̕ҏW
        If EditStdValue(CStr(vntItemCd(0)), CStr(vntSuffix(0)), True, colWorkCollection) = False Then
            Exit Sub
        End If

        '���𐔂��P�ȏ゠��ꍇ�A�I���_�C�A���O�\��
'        If colWorkCollection.Count > 1 Then
        If colWorkCollection.Count > 0 Then
            With frmSelectCopyStdValue
                .HistoryCollection = colWorkCollection
                .Show vbModal
                blnUpdated = .Updated
                i = .Index
            End With
        
            '�L�����Z�����ꂽ��X�V�Ȃ�
            If blnUpdated = False Then
                MsgBox "�������L�����Z������܂����B", vbInformation, Me.Caption
                Exit Sub
            End If
        Else
            '�R���N�V�����͖������łP
            i = 1
        End If

        '��l�ڍ׏��̕ҏW
        If GetStdValue_c(colWorkCollection(i).StdValueMngCd, True) = False Then
            Exit Sub
        End If

        '�擾��l���̃��X�g�r���[�i�[
        If EditListViewFromCollection() = False Then
            Exit Sub
        End If
    
    End If

End Sub

Private Sub cmdUpItem_Click(Index As Integer)

    Call MoveListItem(-1, Index)
    
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
    
    '��ʏ�����
    TabMain.Tab = 0                 '�擪�^�u��Active
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    Do
        '�������ڊ�{���̎擾
        If GetItemInfo() = False Then
            Exit Do
        End If
        
        '�������ڗ������̎擾
        If GetItemHistory() = False Then
            Exit Do
        End If

        '��l�����Ǘ����̕ҏW
        If EditStdValue(mstrItemCd, mstrSuffix, False) = False Then
            Exit Do
        End If
    
        cboHistory.ListIndex = 0
    
        '��l�Ǘ��R�[�h���ݒ肳��Ă���ꍇ�A���̒l�ŃR���{�����\��
        If mstrStdValueMngCd <> "" Then
            
            For i = 0 To UBound(mstrArrStdValueMngCd)
                If mstrArrStdValueMngCd(i) = KEY_PREFIX & mstrStdValueMngCd Then
                    cboHistory.ListIndex = i
                End If
            Next i
        
        End If
    
        '��l�ڍ׏��̕ҏW
        If GetStdValue_c(mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd, False) = False Then
            Exit Do
        End If
        
        '�擾��l���̃��X�g�r���[�i�[
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        '�C�l�[�u���ݒ�
'        txtItemCd.Enabled = (txtItemCd.Text = "")
        
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
' �@�\�@�@ : �������ڗ����f�[�^�擾
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ڂɑ��݂��闚���f�[�^��\������
'
' ���l�@�@ :
'
Private Function GetItemHistory() As Boolean

    Dim objItem_c           As Object           '�������ڃA�N�Z�X�p
    Dim objItemHistory      As ItemHistory
    
    Dim vntHistoryCount     As Variant  '
    Dim vntUnit             As Variant  '
    Dim vntFigure1          As Variant  '
    Dim vntFigure2          As Variant  '
    Dim vntMaxValue         As Variant  '
    Dim vntMinValue         As Variant  '
    Dim vntItemHNo          As Variant  '
    Dim vntStrDate          As Variant  '
    Dim vntEndDate          As Variant  '
    Dim vntInsItemCd        As Variant  '
    Dim vntKarteItemcd      As Variant  '
    Dim vntKarteItemName    As Variant  '
    Dim vntKarteItemAttr    As Variant  '
    Dim vntKarteDocCd       As Variant  '
    Dim vntDefResult        As Variant  '
    Dim vntDefRslCmtCd      As Variant  '

    Dim i           As Long             '�C���f�b�N�X
    Dim Ret         As Boolean
    
    GetItemHistory = False

    '�V�K�쐬���͏����I��
    If (mstrItemCd = "") Or (mstrSuffix = "") Then
        Exit Function
    End If
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem_c = CreateObject("HainsItem.Item")
    Ret = objItem_c.SelectItemHistory(mstrItemCd, _
                                      mstrSuffix, _
                                      "", _
                                      "", _
                                      "", _
                                      vntHistoryCount, _
                                      vntUnit, _
                                      vntFigure1, _
                                      vntFigure2, _
                                      vntMaxValue, _
                                      vntMinValue, _
                                      vntItemHNo, _
                                      vntStrDate, _
                                      vntEndDate, _
                                      vntInsItemCd, _
                                      vntDefResult, _
                                      vntDefRslCmtCd)
                                      
'                                      vntKarteItemcd, _
'                                      vntKarteItemName, _
'                                      vntKarteItemAttr, _
'                                      vntKarteDocCd, _

    '�R���N�V�����쐬
    Set mcolItemHistory = New Collection
    
    For i = 0 To CInt(vntHistoryCount) - 1
        
        '�����I�u�W�F�N�g�i�R���N�V�����j�̍쐬
        Set objItemHistory = New ItemHistory
        With objItemHistory
            .Unit = vntUnit(i)
            .Figure1 = vntFigure1(i)
            .Figure2 = vntFigure2(i)
            .MaxValue = vntMaxValue(i)
            .MinValue = vntMinValue(i)
            .ItemHNo = vntItemHNo(i)
            .strDate = vntStrDate(i)
            .endDate = vntEndDate(i)
            .InsItemCd = vntInsItemCd(i)
'            .KarteItemcd = vntKarteItemcd(i)
'            .KarteItemName = vntKarteItemName(i)
'            .KarteItemAttr = vntKarteItemAttr(i)
'            .KarteDocCd = vntKarteDocCd(i)
            .DefResult = vntDefResult(i)
            .DefRslCmtCd = vntDefRslCmtCd(i)
            .UniqueKey = KEY_PREFIX & vntItemHNo(i)
        
        End With

        mcolItemHistory.Add objItemHistory, KEY_PREFIX & vntItemHNo(i)
        Set objItemHistory = Nothing

'
'        '�R���{�̖��̒ǉ�
'        cboHistory.AddItem CStr(vntStrDate(i)) & "�`" & CStr(vntEndDate(i)) & "�ɓK�p����f�[�^"
    
    Next i
        
    '�f�[�^���擾�ł����Ȃ珈���I��
    If CInt(vntHistoryCount) >= 1 Then
        GetItemHistory = True
    Else
        MsgBox "�������ڗ�����񂪑��݂��܂���B", vbCritical
    End If
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

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
Private Sub MoveListItem(intMovePosition As Integer, intListViewIndex As Integer)

    Dim i                   As Integer
    Dim j                   As Integer
    Dim objItem             As ListItem
    
    Dim intSelectedCount    As Integer      '���ݑI������Ă��鍀�ڐ�
    Dim intSelectedIndex    As Integer      '���ݑI������Ă���s
    Dim intTargetIndex      As Integer      '+-�ő������������Ώۍs
    
    Dim intScrollPoint      As Integer
    
    Dim strEscField()       As String       '���X�g�r���[�̍��ڂ�ޔ����邽�߂̂Q�����z��
    Dim intEscFieldCount    As Integer      '���X�g�r���[�P�s�̃T�u�A�C�e����
    
    Dim obTargetListView    As ListView
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ő��ʂ�I��
    Set obTargetListView = lsvItem(intListViewIndex)
    
    intSelectedCount = 0

    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To obTargetListView.ListItems.Count

        '�I������Ă��鍀�ڂȂ�
        If obTargetListView.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '�I�����ڐ����P�ȊO�Ȃ珈�����Ȃ�
    If intSelectedCount = 0 Then Exit Sub
    
    '�I�����ڐ����P�ȏ�Ȃ狃�����b�Z�[�W
    If intSelectedCount > 1 Then
        MsgBox "�����I���������ڂ̗D�揇�ʕύX�͂ł��܂���B", vbExclamation, Me.Caption
        Exit Sub
    End If
    
    '����Up�w�肩�A�I�����ڂ��擪�Ȃ牽�����Ȃ�
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '����Down�w�肩�A�I�����ڂ��ŏI�Ȃ牽�����Ȃ�
    If (intSelectedIndex = obTargetListView.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    If intMovePosition = -1 Then
        '����Up�̏ꍇ�A��O�̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex - 1
    Else
        '����Down�̏ꍇ�A���݂̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex
    End If
    
    '���ݕ\����̐擪Index���擾
    intScrollPoint = obTargetListView.GetFirstVisible.Index
    
    '���X�g�r���[�����邭��񂵂đS���ڔz��쐬
    For i = 1 To obTargetListView.ListItems.Count
        
        '�T�u�A�C�e���̐����擾
        intEscFieldCount = obTargetListView.ListItems(i).ListSubItems.Count
'        intEscFieldCount = obTargetListView.ListItems(i).ListSubItems.Count + 2
        
        '�T�u�A�C�e���{�L�[�{�e�L�X�g�A�s���Ŕz��g��
        ReDim Preserve strEscField(intEscFieldCount + 2, i)
'        ReDim Preserve strEscField(intEscFieldCount, i)
        
        '�����Ώ۔z��ԍ�������
        If intTargetIndex = i Then
        
            '���ڑޔ�
            strEscField(0, i) = obTargetListView.ListItems(i + 1).Key
            strEscField(1, i) = obTargetListView.ListItems(i + 1)
            For j = 1 To intEscFieldCount
                strEscField(j + 1, i) = obTargetListView.ListItems(i + 1).SubItems(j)
            Next j
        
            i = i + 1
        
            '�T�u�A�C�e���{�L�[�{�e�L�X�g�A�s���Ŕz��g��
'            ReDim Preserve strEscField(10, i)
            ReDim Preserve strEscField(intEscFieldCount + 2, i)
        
            strEscField(0, i) = obTargetListView.ListItems(intTargetIndex).Key
            strEscField(1, i) = obTargetListView.ListItems(intTargetIndex)
            For j = 1 To intEscFieldCount
                strEscField(j + 1, i) = obTargetListView.ListItems(intTargetIndex).SubItems(j)
            Next j
        
        Else
            strEscField(0, i) = obTargetListView.ListItems(i).Key
            strEscField(1, i) = obTargetListView.ListItems(i)
            For j = 1 To intEscFieldCount
                strEscField(j + 1, i) = obTargetListView.ListItems(i).SubItems(j)
            Next j
        
        End If
    
    Next i
    
    '���X�g�r���[�p�w�b�_����
    Call EditListViewHeader(intListViewIndex)

'    obTargetListView.ListItems.Clear
'
'    '�w�b�_�̕ҏW
'    With obTargetListView.ColumnHeaders
'        .Clear
'        .Add , , "�J�n�N��", 900, lvwColumnLeft
'        .Add , , "�I���N��", 900, lvwColumnLeft
'        .Add , , "��l�i�ȉ��j", 1400, lvwColumnLeft
'        .Add , , "��l�i�ȏ�j", 1400, lvwColumnLeft
'        .Add , , "��l�t���O", 1200, lvwColumnLeft
'        .Add , , "����R�[�h", 1200, lvwColumnLeft
'        .Add , , "����R�����g�R�[�h", 1200, lvwColumnLeft
'        .Add , , "�w���X�|�C���g", 1200, lvwColumnLeft
'        .Add , , "��l�R�[�h", 1200, lvwColumnLeft
'    End With
    
    '���X�g�̕ҏW
    For i = 1 To UBound(strEscField, 2)
        Set objItem = obTargetListView.ListItems.Add(, strEscField(0, i), strEscField(1, i), , "DEFAULTLIST")
        For j = 1 To intEscFieldCount
            objItem.SubItems(j) = strEscField(j + 1, i)
        Next j
    Next i

    obTargetListView.ListItems(1).Selected = False
    
    '�ړ��������ڂ�I�������A�ړ��i�X�N���[���j������
    If intMovePosition = 1 Then
        obTargetListView.ListItems(intTargetIndex + 1).Selected = True
    Else
        obTargetListView.ListItems(intTargetIndex).Selected = True
    End If

    '�I������Ă��鍀�ڂ�\������
    obTargetListView.SelectedItem.EnsureVisible

    obTargetListView.SetFocus

End Sub


Friend Property Get StdValueMngCd() As String

    StdValueMngCd = mstrStdValueMngCd

End Property

Friend Property Let StdValueMngCd(ByVal vNewValue As String)

    mstrStdValueMngCd = vNewValue

End Property


Friend Property Let Suffix(ByVal vNewValue As Variant)

    mstrSuffix = vNewValue

End Property

Private Sub lsvItem_DblClick(Index As Integer)

    Call cmdEditItem_Click(Index)

End Sub

' @(e)
'
' �@�\�@�@ : ��l�����f�[�^�̐V�K�쐬
'
' �����@�@ : �Ȃ�
'
' �@�\���� : �V�K�쐬���Ɋ�l�����f�[�^���f�t�H���g�쐬����
'
' ���l�@�@ :
'
Private Sub AddNewStdValue()
    
    Dim objStdValue_Record  As StdValue_Record  '��l���R�[�h�I�u�W�F�N�g
    Dim intArrCount         As Integer
    
    '�z�񐔂̎擾
    intArrCount = mcolStdValueRecord.Count
    
    '�z����g���i�R���N�V�����̐��ō쐬����ƕK�R�I��+1�ɂȂ�j
    ReDim Preserve mstrArrStdValueMngCd(intArrCount)
    
    Set objStdValue_Record = New StdValue_Record
    With objStdValue_Record
        .StdValueMngCd = "0"
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        .strDate = YEARRANGE_MIN & "/01/01"
        .endDate = YEARRANGE_MAX & "/12/31"
        .CsCd = ""
        cboHistory.AddItem .strDate & "�`" & .endDate & "�ɓK�p����f�[�^"
        cboHistory.ListIndex = cboHistory.NewIndex
    End With
    
    '�z��ɑޔ�
    mstrArrStdValueMngCd(intArrCount) = KEY_PREFIX & objStdValue_Record.StdValueMngCd
    
    '�R���N�V�����ǉ�
    mcolStdValueRecord.Add objStdValue_Record, KEY_PREFIX & objStdValue_Record.StdValueMngCd

    '�s�������̂ōX�V���ꂽ���[�h
    mblnHistoryUpdated = True

    '���V�K�Ȃ̂ɐV�K�{�^���s�v���됧��
    cmdNewHistory.Enabled = False
    
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
    

    '�����ʂƋt�̃C���f�b�N�X�����߂�
    intOtherIndex = 1 Xor Index
    
    If Index = 0 Then
        strCurrName = "�j����l�ݒ藓"
        strOtherName = "������l�ݒ藓"
    Else
        strCurrName = "������l�ݒ藓"
        strOtherName = "�j����l�ݒ藓"
    End If
    
    '�R�s�[���̃A�C�e�����m�F
    If (lsvItem(intOtherIndex).ListItems.Count = 0) And (Cancel = False) Then
        MsgBox strOtherName & "�ɍ��ڂ������ݒ肳��Ă��܂���", vbInformation
        Exit Sub
    End If
    
    '�����ڂ̃A�C�e���m�F
    If (lsvItem(Index).ListItems.Count > 0) And (Cancel = False) Then
    
        strMsg = strCurrName & "�ɍ��ڂ��ݒ肳��Ă��܂��B���ɂ��鍀�ڂɒǉ����܂����H" & vbLf & vbLf & _
                 "��������I������ƃN���A���Ă���ǉ����܂��B" & vbLf & vbLf & _
                 "�܂��A���ݐݒ肳��Ă����l�R�[�h���g�p���Ă��錟�����ڂ����݂��Ă���ꍇ�A�ۑ����ɎQ�ƃG���[�Ŏ��s����ꍇ������܂��B"
        intRet = MsgBox(strMsg, vbYesNoCancel + vbDefaultButton3 + vbExclamation)
        
        '�L�����Z�������ŏ����I��
        If intRet = vbCancel Then Exit Sub
    
        '�������Ȃ�P��N���A
        If intRet = vbNo Then
            lsvItem(Index).ListItems.Clear
        End If
    
    End If
    
    '�T�u�A�C�e���̐����擾
    intEscFieldCount = lsvItem(intOtherIndex).ListItems(1).ListSubItems.Count
    
    '�Ƃ��I���ڃR�s�[
    For i = 1 To lsvItem(intOtherIndex).ListItems.Count
        Set objItem = lsvItem(Index).ListItems.Add(, KEY_PREFIX & mintUniqueKey, _
                                                   lsvItem(intOtherIndex).ListItems(i), , "DEFAULTLIST")
        '�A�C�e���R�s�[�i��l�R�[�h�ݒ藓�̓R�s�[�����Ⴞ�߁j
        For j = 1 To intEscFieldCount - 1
            objItem.SubItems(j) = lsvItem(intOtherIndex).ListItems(i).SubItems(j)
        Next j
        
        '��l�R�[�h�ݒ藓�͋󔒃Z�b�g
        objItem.SubItems(j) = ""
        mintUniqueKey = mintUniqueKey + 1
    Next i

    '��ʂ������̂ōĕ`��
    lsvItem(Index).Refresh
    
End Sub

Private Sub lsvItem_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)

    Dim i As Long

    'CTRL+A���������ꂽ�ꍇ�A���ڂ�S�đI������
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem(Index).ListItems.Count
            lsvItem(Index).ListItems(i).Selected = True
        Next i
    End If

End Sub

Private Sub EditListViewHeader(intListViewIndex As Integer)
    
    Dim objHeader           As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objTargetListView   As ListView
    
'    Dim i           As Long                 '�C���f�b�N�X
    
    '�w�b�_�̕ҏW
'    For i = 0 To 1
    
    Set objTargetListView = lsvItem(intListViewIndex)
    objTargetListView.ListItems.Clear
    Set objHeader = objTargetListView.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�J�n�N��", 900, lvwColumnLeft
        .Add , , "�I���N��", 900, lvwColumnLeft
        
        Select Case mintResultType
            '�萫�^�C�v�̏ꍇ
            Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
                .Add , , "�萫�l", 1400, lvwColumnLeft
                .Add , , "", 0, lvwColumnLeft
            
            '���̓^�C�v�̏ꍇ
            Case RESULTTYPE_SENTENCE
                .Add , , "���̓R�[�h", 1000, lvwColumnLeft
                .Add , , "����", 1800, lvwColumnLeft
            
            '����ȊO�̃^�C�v
            Case Else
                .Add , , "��l�i�ȉ��j", 1400, lvwColumnLeft
                .Add , , "��l�i�ȏ�j", 1400, lvwColumnLeft
        End Select
        
        .Add , , "��l�t���O", 1200, lvwColumnLeft
        .Add , , "����R�[�h", 1200, lvwColumnLeft
        .Add , , "����R�����g�R�[�h", 1200, lvwColumnLeft
        .Add , , "�w���X�|�C���g", 1200, lvwColumnLeft
        .Add , , "��l�R�[�h", 800, lvwColumnLeft
    End With
    objTargetListView.View = lvwReport
    
'    Next i

End Sub
