VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmSentence 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���̓e�[�u�������e�i���X"
   ClientHeight    =   7710
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7485
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmSentence.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7710
   ScaleWidth      =   7485
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4560
      TabIndex        =   29
      Top             =   7260
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   6000
      TabIndex        =   30
      Top             =   7260
      Width           =   1335
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   7095
      Left            =   60
      TabIndex        =   31
      Top             =   60
      Width           =   7305
      _ExtentX        =   12885
      _ExtentY        =   12515
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "���C��"
      TabPicture(0)   =   "frmSentence.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Frame2"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Frame1"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).ControlCount=   2
      TabCaption(1)   =   "�\������"
      TabPicture(1)   =   "frmSentence.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Frame4"
      Tab(1).Control(1)=   "Frame3"
      Tab(1).ControlCount=   2
      Begin VB.Frame Frame4 
         Caption         =   "�񍐏��p����"
         Height          =   1875
         Left            =   -74880
         TabIndex        =   18
         Top             =   540
         Width           =   6975
         Begin VB.TextBox txtReptStc 
            Height          =   900
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1920
            MaxLength       =   200
            TabIndex        =   17
            Text            =   "��������������������������������������������������"
            Top             =   420
            Width           =   4875
         End
         Begin VB.Label Label1 
            Caption         =   "�񍐏��p����(&P)�F"
            Height          =   180
            Index           =   11
            Left            =   180
            TabIndex        =   16
            Top             =   480
            Width           =   1590
         End
      End
      Begin VB.Frame Frame3 
         Caption         =   "�\���p����"
         Height          =   2955
         Left            =   -74880
         TabIndex        =   19
         Top             =   2520
         Width           =   6975
         Begin VB.TextBox txtImageFileName 
            Height          =   300
            IMEMode         =   3  '�̌Œ�
            Left            =   2640
            MaxLength       =   30
            TabIndex        =   28
            Text            =   "hogehoge.gif"
            Top             =   2220
            Width           =   3435
         End
         Begin VB.CheckBox chkDelFlg 
            Caption         =   "���̕��͂͌��ʓ��̓K�C�h�ɕ\�����Ȃ�(&D):"
            Height          =   255
            Left            =   360
            TabIndex        =   20
            Top             =   420
            Width           =   4095
         End
         Begin VB.TextBox txtQuestionRank 
            Height          =   300
            IMEMode         =   3  '�̌Œ�
            Left            =   2640
            MaxLength       =   1
            TabIndex        =   26
            Text            =   "@"
            Top             =   1620
            Width           =   315
         End
         Begin VB.TextBox txtPrintOrder 
            Height          =   300
            IMEMode         =   3  '�̌Œ�
            Left            =   2640
            MaxLength       =   5
            TabIndex        =   24
            Text            =   "@@@@@"
            Top             =   1260
            Width           =   735
         End
         Begin VB.TextBox txtViewOrder 
            Height          =   300
            IMEMode         =   3  '�̌Œ�
            Left            =   2640
            MaxLength       =   5
            TabIndex        =   22
            Text            =   "@@@@@"
            Top             =   900
            Width           =   735
         End
         Begin VB.Label Label1 
            Caption         =   "���͑Ή��C���[�W�t�@�C����(&I):"
            Height          =   180
            Index           =   10
            Left            =   360
            TabIndex        =   27
            Top             =   2280
            Width           =   2730
         End
         Begin VB.Label Label1 
            Caption         =   "�ʐڎx����f�\�������N(&Q):"
            Height          =   180
            Index           =   9
            Left            =   360
            TabIndex        =   25
            Top             =   1680
            Width           =   2250
         End
         Begin VB.Label Label1 
            Caption         =   "���я��o�͏�(&R):"
            Height          =   180
            Index           =   8
            Left            =   360
            TabIndex        =   23
            Top             =   1320
            Width           =   1470
         End
         Begin VB.Label Label1 
            Caption         =   "�K�C�h�\������(&G):"
            Height          =   180
            Index           =   7
            Left            =   360
            TabIndex        =   21
            Top             =   960
            Width           =   1470
         End
      End
      Begin VB.Frame Frame1 
         Caption         =   "�R�[�h"
         Height          =   3015
         Left            =   120
         TabIndex        =   32
         Top             =   360
         Width           =   7035
         Begin VB.CommandButton cmdItemGuide 
            Caption         =   "�������ڃR�[�h(&C)"
            Height          =   315
            Left            =   180
            TabIndex        =   0
            Top             =   360
            Width           =   1635
         End
         Begin VB.ComboBox cboItemType 
            Height          =   300
            ItemData        =   "frmSentence.frx":0044
            Left            =   1380
            List            =   "frmSentence.frx":0066
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   2
            Top             =   1020
            Width           =   3750
         End
         Begin VB.TextBox txtStcCd 
            Height          =   300
            IMEMode         =   3  '�̌Œ�
            Left            =   1380
            MaxLength       =   8
            TabIndex        =   4
            Text            =   "@@@@@@@@"
            Top             =   1380
            Width           =   1095
         End
         Begin VB.ComboBox cboStcClass 
            Height          =   300
            ItemData        =   "frmSentence.frx":0088
            Left            =   1380
            List            =   "frmSentence.frx":00AA
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   6
            Top             =   1740
            Width           =   3750
         End
         Begin VB.Label lblstcItem 
            Caption         =   "�i���̍��ڂ́A001230�F�A�o�g�����������̕��͂��Q�Ƃ��Ă��܂��j"
            Height          =   675
            Left            =   1380
            TabIndex        =   36
            Top             =   2220
            Width           =   5535
         End
         Begin VB.Label lblItemName 
            Caption         =   "�������݂܂��B�����A���݂܂�"
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
            Left            =   2760
            TabIndex        =   35
            Top             =   420
            Width           =   2775
         End
         Begin VB.Label lblItemCd 
            Caption         =   "000120"
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
            Left            =   1920
            TabIndex        =   34
            Top             =   420
            Width           =   735
         End
         Begin VB.Label Label1 
            Caption         =   "���ڃ^�C�v(&T):"
            Height          =   180
            Index           =   3
            Left            =   240
            TabIndex        =   1
            Top             =   1080
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "���̓R�[�h(&B):"
            Height          =   180
            Index           =   0
            Left            =   240
            TabIndex        =   3
            Top             =   1440
            Width           =   1410
         End
         Begin VB.Image imgWarning 
            Height          =   480
            Left            =   780
            Picture         =   "frmSentence.frx":00CC
            Top             =   2160
            Visible         =   0   'False
            Width           =   480
         End
         Begin VB.Label lblItemDetail 
            Caption         =   "�i�������ځ@123456-02�F�APHPHPHPHPH�j"
            Height          =   195
            Left            =   1920
            TabIndex        =   33
            Top             =   660
            Width           =   4455
         End
         Begin VB.Label Label1 
            Caption         =   "���͕���(&S):"
            Height          =   180
            Index           =   2
            Left            =   240
            TabIndex        =   5
            Top             =   1800
            Width           =   1410
         End
      End
      Begin VB.Frame Frame2 
         Caption         =   "���͐ݒ���"
         Height          =   3495
         Left            =   120
         TabIndex        =   15
         Top             =   3420
         Width           =   7035
         Begin VB.TextBox txtEngStc 
            Height          =   1140
            IMEMode         =   2  '��
            Left            =   1380
            MaxLength       =   200
            TabIndex        =   12
            Text            =   "��������������������������������������������������"
            Top             =   1680
            Width           =   5535
         End
         Begin VB.TextBox txtLongStc 
            Height          =   900
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1380
            MaxLength       =   200
            TabIndex        =   10
            Text            =   "��������������������������������������������������"
            Top             =   720
            Width           =   5535
         End
         Begin VB.TextBox txtShortStc 
            Height          =   300
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1380
            MaxLength       =   50
            TabIndex        =   8
            Text            =   "��������������������������������������������������"
            Top             =   360
            Width           =   5535
         End
         Begin VB.TextBox txtInsStc 
            Height          =   300
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   2160
            MaxLength       =   16
            TabIndex        =   14
            Text            =   "����������������"
            Top             =   2940
            Width           =   4695
         End
         Begin VB.Label Label1 
            Caption         =   "�p�ꕶ��(&E)"
            Height          =   180
            Index           =   5
            Left            =   180
            TabIndex        =   11
            Top             =   1740
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "��������(&F)"
            Height          =   180
            Index           =   4
            Left            =   180
            TabIndex        =   9
            Top             =   780
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "������(&R)"
            Height          =   180
            Index           =   1
            Left            =   180
            TabIndex        =   7
            Top             =   420
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "�����A�g�p�ϊ�����(&K):"
            Height          =   180
            Index           =   6
            Left            =   180
            TabIndex        =   13
            Top             =   3000
            Width           =   2010
         End
      End
   End
End
Attribute VB_Name = "frmSentence"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd              As String   '�������ڃR�[�h
Private mstrSuffix              As String   '�T�t�B�b�N�X
Private mstrItemName            As String   '���ږ���
Private mintItemType            As Integer  '���ڃ^�C�v
Private mstrStcCd               As String   '���̓R�[�h

Private mstrStcItemCd           As String   '���͎Q�Ɨp�������ڃR�[�h
Private mstrStcItemName         As String   '���͎Q�Ɨp�������ږ���

Private mblnInitialize          As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrStcClassCd()        As String   '�R���{�{�b�N�X�ɑΉ����镶�͕��ރR�[�h�̊i�[

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let StcCd(ByVal vntNewValue As Variant)

    mstrStcCd = vntNewValue
    
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
    
    Ret = False
    
    Do
        '�R�[�h�̓��̓`�F�b�N
        If Trim(mstrItemCd) = "" Then
            MsgBox "�������ڂ��ݒ肳��Ă��܂���B", vbCritical, App.Title
            cmdItemGuide.SetFocus
            Exit Do
        End If
        
        '�R�[�h�̓��̓`�F�b�N
        If Trim(txtStcCd.Text) = "" Then
            MsgBox "���̓R�[�h�����͂���Ă��܂���B", vbCritical, App.Title
            txtStcCd.SetFocus
            Exit Do
        End If

        '���̂̓��̓`�F�b�N
        If (Trim(txtShortStc.Text) = "") And (Trim(txtLongStc.Text) = "") Then
            MsgBox "���͖������͂���Ă��܂���B", vbCritical, App.Title
            txtShortStc.SetFocus
            Exit Do
        End If

'        '���̂̓��̓`�F�b�N
'        If LenB(Trim(txtShortStc.Text)) > 50 Then
'            MsgBox "�ݒ肳�ꂽ���̂��������܂��B", vbCritical, App.Title
'            txtShortStc.SetFocus
'            Exit Do
'        End If

        '�ǂ��炩�Е������̖����͂Ȃ珟��ɃZ�b�g����
        If Trim(txtShortStc.Text) = "" Then
            Trim(txtShortStc.Text) = Trim(txtLongStc.Text)
        End If

        If Trim(txtLongStc.Text) = "" Then
            txtLongStc.Text = Trim(txtShortStc.Text)
        End If

        '�����A�g�p���͕͂K���S�p�ɕϊ�
        txtInsStc.Text = StrConv(Trim(txtInsStc.Text), vbWide)

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
Private Function EditSentence() As Boolean

    Dim objSentence         As Object           '���̓A�N�Z�X�p
    Dim vntShortStc         As Variant          '����
    Dim vntLongStc          As Variant          '���͖�
    Dim vntEngStc           As Variant          '���͖�
    Dim vntStcClassCd       As Variant          '���͕��ރR�[�h
    Dim vntInsStc           As Variant          '�����A�g�p�ϊ�����
    Dim Ret                 As Boolean          '�߂�l
    
    Dim vntStcClassCdList   As Variant
    Dim vntStcClassName     As Variant
    Dim lngCount            As Long
    Dim i                   As Integer
    
    Dim vntViewOrder        As Variant
    Dim vntPrintOrder       As Variant
    Dim vntImageFileName    As Variant
    Dim vntQuestionRank     As Variant
    Dim vntDelFlg           As Variant
'### 2004/01/15 Added by Ishihara@FSIT �񍐏��p���͒ǉ�
    Dim vntReptStc          As Variant
'### 2004/01/15 Added End
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSentence = CreateObject("HainsSentence.Sentence")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If (mstrItemCd = "") Or (mstrStcCd = "") Then
            Ret = True
            Exit Do
        End If
        
        '���̓e�[�u�����R�[�h�ǂݍ���
'### 2004/01/15 Modified by Ishihara@FSIT �񍐏��p���͒ǉ�
'        If objSentence.SelectSentence(mstrItemCd, _
                                      mintItemType, _
                                      mstrStcCd, _
                                      vntShortStc, _
                                      vntLongStc, _
                                      vntEngStc, _
                                      vntStcClassCd, _
                                      vntInsStc, _
                                      vntViewOrder, _
                                      vntPrintOrder, _
                                      vntImageFileName, _
                                      vntQuestionRank, _
                                      vntDelFlg) = False Then
        If objSentence.SelectSentence(mstrItemCd, _
                                      mintItemType, _
                                      mstrStcCd, _
                                      vntShortStc, _
                                      vntLongStc, _
                                      vntEngStc, _
                                      vntStcClassCd, _
                                      vntInsStc, _
                                      vntViewOrder, _
                                      vntPrintOrder, _
                                      vntImageFileName, _
                                      vntQuestionRank, _
                                      vntDelFlg, , , _
                                      vntReptStc) = False Then
'### 2004/01/15 Modified End
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        
        txtShortStc.Text = vntShortStc
        txtLongStc.Text = vntLongStc
        txtEngStc.Text = vntEngStc
        txtInsStc.Text = vntInsStc
        
        txtViewOrder.Text = vntViewOrder
        txtPrintOrder.Text = vntPrintOrder
        txtImageFileName.Text = vntImageFileName
        txtQuestionRank.Text = vntQuestionRank
'### 2004/01/15 Added by Ishihara@FSIT �񍐏��p���͒ǉ�
        txtReptStc.Text = vntReptStc
'### 2004/01/15 Added End
    
        If vntDelFlg = "1" Then
            chkDelFlg.Value = vbChecked
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '�C���X�^���X�쐬���łɕ��͕��ރR���{��ݒ�
    cboStcClass.Clear
    Erase mstrStcClassCd
    
    '�R�[�X�ꗗ�擾�i���C���̂݁j
    lngCount = objSentence.SelectStcClassItemList(vntStcClassCdList, vntStcClassName)
    
    '�R�[�X�͖��w�肠��
    ReDim Preserve mstrStcClassCd(0)
    mstrStcClassCd(0) = ""
    cboStcClass.AddItem ""
    cboStcClass.ListIndex = 0
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrStcClassCd(i + 1)
        mstrStcClassCd(i + 1) = vntStcClassCdList(i)
        cboStcClass.AddItem vntStcClassName(i)
        If vntStcClassCdList(i) = vntStcClassCd Then
            cboStcClass.ListIndex = i + 1
        End If
    Next i
    
    '�߂�l�̐ݒ�
    EditSentence = Ret
    
    Exit Function

ErrorHandle:

    EditSentence = False
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
Private Function RegistSentence() As Boolean

    Dim objSentence    As Object       '���̓A�N�Z�X�p
    Dim Ret             As Long
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSentence = CreateObject("HainsSentence.Sentence")
    
    '���̓e�[�u�����R�[�h�̓o�^
'### 2004/01/15 Modified by Ishihara@FSIT �񍐏��p���͒ǉ�
'    Ret = objSentence.RegistSentence(IIf(txtStcCd.Enabled, "INS", "UPD"), _
                                     mstrStcItemCd, _
                                     cboItemType.ListIndex, _
                                     Trim(txtStcCd.Text), _
                                     Trim(txtShortStc.Text), _
                                     Trim(txtLongStc.Text), _
                                     Trim(txtEngStc.Text), _
                                     mstrStcClassCd(cboStcClass.ListIndex), _
                                     Trim(txtInsStc.Text), _
                                     Trim(txtViewOrder.Text), _
                                     Trim(txtPrintOrder.Text), _
                                     Trim(txtImageFileName.Text), _
                                     Trim(txtQuestionRank.Text), _
                                     IIf(chkDelFlg.Value = vbChecked, "1", ""))
    Ret = objSentence.RegistSentence(IIf(txtStcCd.Enabled, "INS", "UPD"), _
                                     mstrStcItemCd, _
                                     cboItemType.ListIndex, _
                                     Trim(txtStcCd.Text), _
                                     Trim(txtShortStc.Text), _
                                     Trim(txtLongStc.Text), _
                                     Trim(txtEngStc.Text), _
                                     mstrStcClassCd(cboStcClass.ListIndex), _
                                     Trim(txtInsStc.Text), _
                                     Trim(txtViewOrder.Text), _
                                     Trim(txtPrintOrder.Text), _
                                     Trim(txtImageFileName.Text), _
                                     Trim(txtQuestionRank.Text), _
                                     IIf(chkDelFlg.Value = vbChecked, "1", ""), _
                                     Trim(txtReptStc.Text))
'### 2004/01/15 Modified End

    If Ret = 0 Then
        MsgBox "���͂��ꂽ���̓R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistSentence = False
        Exit Function
    End If
    
    RegistSentence = True
    
    Exit Function
    
ErrorHandle:

    RegistSentence = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �u�L�����Z���vClick
'
' �@�\���� : �t�H�[�������
'
' ���l�@�@ :
'
Private Sub CMDcancel_Click()

    Unload Me
    
End Sub

Private Sub cmdItemGuide_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '���ڃK�C�h�\���p
    
    Dim lngItemCount    As Long     '�I�����ڐ�
    Dim vntItemCd       As Variant  '�I�����ꂽ���ڃR�[�h
    Dim vntSuffix       As Variant  '�I�����ꂽ�T�t�B�b�N�X
    Dim vntItemName     As Variant  '�I�����ꂽ���ږ�
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
        .MultiSelect = False
        .ResultType = RESULTTYPE_SENTENCE
    
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
        
        '�߂�l�Ƃ��Ẵv���p�e�B�擾
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
        vntItemName = .ItemName
    
    End With
        
    Screen.MousePointer = vbHourglass
    Me.Refresh
        
    '�I��������0���ȏ�Ȃ�
    If lngItemCount > 0 Then
        
        mstrItemCd = vntItemCd(0)
        mstrSuffix = vntSuffix(0)
            
        '�������ڏ��̕ҏW�i�������ڃR�[�h�A�T�t�B�b�N�X���w�肳�ꂽ�ꍇ�j
        If GetItemInfo() = False Then
            MsgBox "�K�C�h�Q�ƌ�̌������ڏ��擾�Ɏ��s���܂����B��ʂ���Ă��������B", vbCritical
        End If
        
        lblItemCd.Caption = vntItemCd(0)
        lblItemName.Caption = vntItemName(0)
    End If

    Set objItemGuide = Nothing
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
Private Sub CMDok_Click()

    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    Do
        '���̓`�F�b�N
        If CheckValue() = False Then
            Exit Do
        End If
        
        '���̓e�[�u���̓o�^
        If RegistSentence() = False Then
            Exit Do
        End If
            
        '�X�V�ς݃t���O��TRUE��
        mblnUpdated = True
    
        '��ʂ����
        Unload Me
        
        Exit Do
    Loop
    
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
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    SSTab1.Tab = 0
    
    With cboItemType
        .AddItem "0:�W��"
        .AddItem "1:���̕��͂́u���ʁv�ׂ̈̕��͌��ʂł�"
        .AddItem "2:���̕��͂́u�����v�ׂ̈̕��͌��ʂł�"
        .AddItem "3:���̕��͂́u���u�v�ׂ̈̕��͌��ʂł�"
        .ListIndex = 0
    End With

    mstrStcItemCd = mstrItemCd
    mstrStcItemName = mstrItemName

    Do
        '�������ڏ��̕ҏW�i�������ڃR�[�h�A�T�t�B�b�N�X���w�肳�ꂽ�ꍇ�j
        If GetItemInfo() = False Then
            Exit Do
        End If
        
        '���͏��̕ҏW
        If EditSentence() = False Then
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop

    '�\�����ڐݒ�
    lblItemCd.Caption = mstrItemCd
    lblItemName.Caption = mstrItemName
    txtStcCd.Text = mstrStcCd
    cboItemType.ListIndex = mintItemType
    
    '�C�l�[�u���ݒ�
    cmdItemGuide.Enabled = (txtStcCd.Text = "")
    txtStcCd.Enabled = (txtStcCd.Text = "")
    cboItemType.Enabled = (txtStcCd.Text = "")
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' �@�\�@�@ : �������ڏ��擾
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ڂ̊�{�����擾����
'
' ���l�@�@ : �~�������͕��͎Q�Ɨp���ڃR�[�h
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
    Dim vntStcItemName      As Variant
    Dim vntRequestName      As Variant

    Dim Ret         As Boolean              '�߂�l
    
    GetItemInfo = False
    
    On Error GoTo ErrorHandle
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If (mstrItemCd = "") Or (mstrSuffix = "") Then
            Ret = True
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
                                    vntResultTypeName, , , , vntStcItemCd, vntStcItemName, , , , , , , vntRequestName _
                                    ) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If

        '���̂̍ĕҏW
        mstrItemName = vntRequestName

        '���͎Q�Ɨp���ڃR�[�h�̎擾
        mstrStcItemCd = vntStcItemCd
        mstrStcItemName = vntStcItemName
        
        '�w�b�_���̕ҏW
        lblItemDetail.Caption = "�i�������ځ@" & mstrItemCd & "-" & mstrSuffix & "�F" & vntItemName & "�j"

        '���ڃR�[�h�̔�r
        If mstrStcItemCd <> mstrItemCd Then
            lblstcItem.Caption = "���̍��ڂ́A" & mstrStcItemCd & "�F" & mstrStcItemName & "�̕��͂��Q�Ƃ��Ă��܂��B" & vbLf & _
                                 "�f�[�^�̍X�V�������s�����ꍇ�A�u" & mstrStcItemName & "�v" & vbLf & "�ɑ΂��镶�͂Ƃ��ēo�^����܂��B"
            imgWarning.Visible = True
        Else
            lblstcItem.Caption = ""
            imgWarning.Visible = False
        End If
        
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

Friend Property Get ItemCd() As Variant

    ItemCd = mstrItemCd

End Property

Friend Property Let ItemCd(ByVal vNewValue As Variant)

    mstrItemCd = vNewValue

End Property

Friend Property Get ItemType() As Integer

    ItemType = mintItemType

End Property

Friend Property Let ItemType(ByVal vNewValue As Integer)

    mintItemType = vNewValue

End Property

Friend Property Let ItemName(ByVal vNewValue As Variant)

    mstrItemName = vNewValue
    
End Property

Friend Property Get Suffix() As String

    Suffix = mstrSuffix
    
End Property

Friend Property Let Suffix(ByVal vNewValue As String)

    mstrSuffix = vNewValue
    
End Property

