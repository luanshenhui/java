VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmItem_P_Price 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�˗����ڒP���e�[�u�������e�i���X"
   ClientHeight    =   6480
   ClientLeft      =   1605
   ClientTop       =   1545
   ClientWidth     =   6555
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmItem_P_Price.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6480
   ScaleWidth      =   6555
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin TabDlg.SSTab TabMain 
      Height          =   5055
      Left            =   120
      TabIndex        =   3
      Top             =   840
      Width           =   6315
      _ExtentX        =   11139
      _ExtentY        =   8916
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "���ۂȂ�"
      TabPicture(0)   =   "frmItem_P_Price.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Frame1"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "���ۂ���"
      TabPicture(1)   =   "frmItem_P_Price.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Frame2"
      Tab(1).Control(1)=   "cmdDeleteItem(1)"
      Tab(1).Control(2)=   "cmdAddItem(1)"
      Tab(1).Control(3)=   "cmdEditItem(1)"
      Tab(1).ControlCount=   4
      Begin VB.CommandButton cmdEditItem 
         Caption         =   "�ҏW(&5)..."
         Height          =   315
         Index           =   1
         Left            =   -71760
         TabIndex        =   15
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "�ǉ�(&4)..."
         Height          =   315
         Index           =   1
         Left            =   -73140
         TabIndex        =   14
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "�폜(&6)"
         Height          =   315
         Index           =   1
         Left            =   -70380
         TabIndex        =   13
         Top             =   4320
         Width           =   1275
      End
      Begin VB.Frame Frame2 
         Caption         =   "�ݒ肵���l(&C)"
         Height          =   4335
         Left            =   -74820
         TabIndex        =   9
         Top             =   480
         Width           =   5955
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
            Height          =   375
            Index           =   1
            Left            =   180
            TabIndex        =   17
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
            Height          =   375
            Index           =   1
            Left            =   180
            TabIndex        =   16
            Top             =   1380
            Width           =   435
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3495
            Index           =   1
            Left            =   720
            TabIndex        =   10
            Top             =   240
            Width           =   4995
            _ExtentX        =   8811
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
         TabIndex        =   4
         Top             =   480
         Width           =   5955
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
            Height          =   375
            Index           =   0
            Left            =   180
            TabIndex        =   12
            Top             =   1380
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
            Height          =   375
            Index           =   0
            Left            =   180
            TabIndex        =   11
            Top             =   1980
            Width           =   435
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "�폜(&3)"
            Height          =   315
            Index           =   0
            Left            =   4440
            TabIndex        =   7
            Top             =   3840
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "�ǉ�(&1)..."
            Height          =   315
            Index           =   0
            Left            =   1680
            TabIndex        =   6
            Top             =   3840
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditItem 
            Caption         =   "�ҏW(&2)..."
            Height          =   315
            Index           =   0
            Left            =   3060
            TabIndex        =   5
            Top             =   3840
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3495
            Index           =   0
            Left            =   720
            TabIndex        =   8
            Top             =   240
            Width           =   4995
            _ExtentX        =   8811
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
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   3660
      TabIndex        =   0
      Top             =   6060
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5100
      TabIndex        =   1
      Top             =   6060
      Width           =   1335
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   240
      Top             =   5760
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
            Picture         =   "frmItem_P_Price.frx":0044
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_P_Price.frx":0496
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_P_Price.frx":08E8
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_P_Price.frx":0A42
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   120
      Picture         =   "frmItem_P_Price.frx":0B9C
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
      TabIndex        =   2
      Top             =   240
      Width           =   6375
   End
End
Attribute VB_Name = "frmItem_P_Price"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd              As String           '�������ڃR�[�h
Private mstrRequestName         As String           '�˗����ږ�

Private mblnInitialize          As Boolean          'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean          'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mcolGotFocusCollection  As Collection       'GotFocus���̕����I��p�R���N�V����

Private mintUniqueKey           As Long             '���X�g�r���[��ӃL�[�Ǘ��p�ԍ�
Private Const KEY_PREFIX        As String = "K"

Private mblnHistoryUpdated      As Boolean          'TRUE:�˗����ڒP�������X�V����AFALSE:�˗����ڒP�������X�V�Ȃ�
Private mblnItemUpdated         As Boolean          'TRUE:�˗����ڒP���ڍ׍X�V����AFALSE:�˗����ڒP���ڍ׍X�V�Ȃ�

Private mintBeforeIndex         As Integer          '�����R���{�ύX�L�����Z���p�̑OIndex
Private mblnNowEdit             As Boolean          'TRUE:�ҏW�������AFALSE:�����Ȃ�

Private mcolItem_P_Price_Record As Collection       '�˗����ڒP�����R�[�h�̃R���N�V����

Friend Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
End Property

Friend Property Let RequestName(ByVal vntNewValue As Variant)

    mstrRequestName = vntNewValue
    
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

    Dim Ret                 As Boolean  '�֐��߂�l
    Dim strMsg              As String
    Dim intRet              As Integer
    Dim intListViewIndex    As Integer
    Dim i                   As Integer
    Dim j                   As Integer
    Dim curStrAge           As Currency
    Dim curEndAge           As Currency
    Dim obTargetListView    As ListView

    Ret = False
    
    Do
        
        '���X�g�r���[�̒��g���Z�b�g
        For intListViewIndex = 0 To 1
        
            Set obTargetListView = lsvItem(intListViewIndex)
        
            '���X�g�r���[����
            For i = 1 To obTargetListView.ListItems.Count
        
                '���݂̊J�n�A�I���N���ޔ�
                With obTargetListView.ListItems(i)
                    curStrAge = CCur(.Text)
                    curEndAge = CCur(.SubItems(1))
                End With
                
                '�N��_�u������邳�Ȃ�
                j = i
                If j < obTargetListView.ListItems.Count Then
                    For j = (i + 1) To obTargetListView.ListItems.Count
                        If ((curStrAge >= CCur(obTargetListView.ListItems(j).Text)) And _
                            (curStrAge <= CCur(obTargetListView.ListItems(j).SubItems(1)))) Or _
                           ((curEndAge >= CCur(obTargetListView.ListItems(j).Text)) And _
                            (curEndAge <= CCur(obTargetListView.ListItems(j).SubItems(1)))) Then
                            
                            '�}���`�Z���N�g���������đI����Ԃ��N���A�B�G���[�s��I����}���`�Z���N�g�ɖ߂�
                            obTargetListView.MultiSelect = False
                            obTargetListView.ListItems(j).Selected = True
                            obTargetListView.MultiSelect = True
                            
                            TabMain.Tab = intListViewIndex
                            MsgBox "�N��ݒ�͈͂��d�����Ă��܂��B�ݒ���e���������Ă��������B"
                            CheckValue = False
                            Exit Function
                        
                        End If
                    Next j
                End If
                                
            Next i
        
        Next intListViewIndex
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

'
' �@�\�@�@ : �˗����ڒP���ڍ׏��̎擾
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function GetItem_P_Price() As Boolean

    Dim objItem_P_Price         As Object       '�˗����ڒP���Ǘ��A�N�Z�X�p
    
    Dim vntItemCd               As Variant      '�������ڃR�[�h
    Dim vntExistsIsr            As Variant      '���ۗL���敪
    Dim vntSeq                  As Variant      'SEQ
    Dim vntStrAge               As Variant      '�J�n�N��
    Dim vntEndAge               As Variant      '�I���N��
    Dim vntBsdPrice             As Variant      '�c�̕��S���z
    Dim vntIsrPrice             As Variant      '���ە��S���z
    
    Dim lngCount                As Long         '���R�[�h��
    Dim i                       As Integer
    Dim Ret                     As Boolean      '�߂�l
    
    Dim objItem_P_Price_Record  As Item_P_Price_Record    '�˗����ڒP�����R�[�h�I�u�W�F�N�g
    
    On Error GoTo ErrorHandle
        
    '�R���N�V�����N���A
    Set mcolItem_P_Price_Record = Nothing
    Set mcolItem_P_Price_Record = New Collection

    Do
        '�������ڃR�[�h���w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrItemCd = "" Then
            Ret = True
            Exit Do
        End If
    
        '�I�u�W�F�N�g�̃C���X�^���X�쐬
        Set objItem_P_Price = CreateObject("HainsItem.Item")
        
        '�˗����ڒP���e�[�u�����R�[�h�ǂݍ���
        lngCount = objItem_P_Price.SelectItem_P_Price(mstrItemCd, _
                                                      vntExistsIsr, _
                                                      vntSeq, _
                                                      vntStrAge, _
                                                      vntEndAge, _
                                                      vntBsdPrice, _
                                                      vntIsrPrice)
        
        '0���ł��s�v�c�Ȃ�
        If lngCount = 0 Then
            Ret = True
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW
        For i = 0 To lngCount - 1
            
            '�ǂݍ��ݓ��e���I�u�W�F�N�g�ɃZ�b�g
            Set objItem_P_Price_Record = New Item_P_Price_Record
            With objItem_P_Price_Record
                .Key = KEY_PREFIX & vntExistsIsr(i) & vntSeq(i)
                .ExistsIsr = vntExistsIsr(i)
                .Seq = vntSeq(i)
                .StrAge = vntStrAge(i)
                .EndAge = vntEndAge(i)
                .BsdPrice = vntBsdPrice(i)
                .IsrPrice = vntIsrPrice(i)
            End With
            
            '�R���N�V�����ɒǉ�
            mcolItem_P_Price_Record.Add objItem_P_Price_Record, KEY_PREFIX & vntExistsIsr(i) & vntSeq(i)
            
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    Set objItem_P_Price = Nothing
    
    '�߂�l�̐ݒ�
    GetItem_P_Price = Ret
    
    Exit Function

ErrorHandle:

    GetItem_P_Price = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' �@�\�@�@ : �˗����ڒP���ڍ׏��̕\���i�R���N�V��������j
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function EditListViewFromCollection() As Boolean

On Error GoTo ErrorHandle

    Dim objItem                 As ListItem             '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntCsCd                 As Variant              '�R�[�X�R�[�h
    Dim vntCsName               As Variant              '�R�[�X��
    Dim lngCount                As Long                 '���R�[�h��
    Dim i                       As Long                 '�C���f�b�N�X
    Dim objItem_P_Price_Record  As Item_P_Price_Record  '�˗����ڒP�����R�[�h�I�u�W�F�N�g
    
    EditListViewFromCollection = False

    '���X�g�r���[�p�w�b�_����
    For i = 0 To 1
        Call EditListViewHeader(CInt(i))
    Next i
    
    '���X�g�r���[�p���j�[�N�L�[������
    mintUniqueKey = 1
    
    '���X�g�̕ҏW
    For Each objItem_P_Price_Record In mcolItem_P_Price_Record
        With objItem_P_Price_Record
            
            '���ۗL���敪�ɂ��Z�b�g���郊�X�g�r���[��ύX����
            i = .ExistsIsr
        
            Set objItem = lsvItem(i).ListItems.Add(, .Key, .StrAge, , "DEFAULTLIST")
            objItem.SubItems(1) = .EndAge
            objItem.SubItems(2) = .BsdPrice
            objItem.SubItems(3) = .IsrPrice
        
        End With
        mintUniqueKey = mintUniqueKey + 1
    
    Next objItem_P_Price_Record
    
    '�I�u�W�F�N�g�p��
    Set objItem_P_Price_Record = Nothing
    
    EditListViewFromCollection = True
    Exit Function
    
ErrorHandle:

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
Private Function RegistItem_P_Price() As Boolean

On Error GoTo ErrorHandle

    Dim objItem_P_Price         As Object       '�˗����ڒP���Ǘ��A�N�Z�X�p
    Dim Ret                     As Long
    
    '�V�K�o�^���̑ޔ�p
    Dim blnNewRecordFlg         As Boolean
    Dim strEscItemCd            As String
    Dim strEscSuffix            As String
    Dim strEscStrDate           As String
    Dim strEscEndDate           As String
    Dim strEscCsCd              As String

    '�˗����ڒP��
    Dim lngItem_P_PriceMngCd        As Long

    '�˗����ڒP���̔z��֘A
    Dim intItemCount            As Integer
    Dim vntExistsIsr            As Variant
    Dim vntSeq                  As Variant
    Dim vntStrAge               As Variant
    Dim vntEndAge               As Variant
    Dim vntBsdPrice             As Variant
    Dim vntIsrPrice             As Variant
    
    Dim blnBeforeUpdatePoint    As Boolean      'TRUE:�X�V�O�AFALSE:�X�V�O�ł͂Ȃ�
    
    blnBeforeUpdatePoint = False
    
    '�˗����ڒP���ڍ׃e�[�u���̔z��Z�b�g
    Call EditArrayForUpdate(intItemCount, _
                            vntExistsIsr, _
                            vntSeq, _
                            vntStrAge, _
                            vntEndAge, _
                            vntBsdPrice, _
                            vntIsrPrice)
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem_P_Price = CreateObject("HainsItem.Item")

    blnBeforeUpdatePoint = True

    '�˗����ڒP���f�[�^�̓o�^
    Ret = objItem_P_Price.RegistItem_P_Price(mstrItemCd, _
                                            intItemCount, _
                                            vntExistsIsr, _
                                            vntSeq, _
                                            vntStrAge, _
                                            vntEndAge, _
                                            vntBsdPrice, _
                                            vntIsrPrice)
    
    blnBeforeUpdatePoint = False
    
    If Ret = INSERT_ERROR Then
        MsgBox "�e�[�u���X�V���ɃG���[���������܂����B", vbCritical
        RegistItem_P_Price = False
        Exit Function
    End If
    
    '�X�V�ς݃t���O��������
    mblnHistoryUpdated = False
    mblnItemUpdated = False
    
    RegistItem_P_Price = True
    
    Exit Function
    
ErrorHandle:

    RegistItem_P_Price = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : ���X�g�r���[�f�[�^�̔z��Z�b�g
'
' �����@�@ : (Out)   intItemCount        ���ڐ�
' �@�@�@�@   (Out)   vntExistsIsr        ���ۗL���敪
' �@�@�@�@   (Out)   vntSeq              Seq
' �@�@�@�@   (Out)   vntStrAge           �J�n�N��
' �@�@�@�@   (Out)   vntEndAge           �I���N��
' �@�@�@�@   (Out)   vntBsdPrice         �c�̕��S��
' �@�@�@�@   (Out)   vntIsrPrice         ���ە��S��
'
' �@�\���� : ���X�g�r���[��̃f�[�^��DB�i�[�p�Ƃ���Variant�z��ɕҏW����
'
' ���l�@�@ :
'
Private Sub EditArrayForUpdate(intItemCount As Integer, _
                               vntExistsIsr As Variant, _
                               vntSeq As Variant, _
                               vntStrAge As Variant, _
                               vntEndAge As Variant, _
                               vntBsdPrice As Variant, _
                               vntIsrPrice As Variant)

    Dim vntArrExistsIsr()       As Variant
    Dim vntArrSeq()             As Variant
    Dim vntArrStrAge()          As Variant
    Dim vntArrEndAge()          As Variant
    Dim vntArrbsdPrice()        As Variant
    Dim vntArrisrPrice()        As Variant
    
    Dim i                       As Integer
    Dim intArrCount             As Integer
    Dim intListViewIndex        As Integer
    Dim intSeqCount             As Integer
    Dim obTargetListView        As ListView

    intArrCount = 0

    '���X�g�r���[�̒��g���Z�b�g
    For intListViewIndex = 0 To 1
    
        intSeqCount = 1
        Set obTargetListView = lsvItem(intListViewIndex)
    
        '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
        For i = 1 To obTargetListView.ListItems.Count
    
            ReDim Preserve vntArrExistsIsr(intArrCount)
            ReDim Preserve vntArrSeq(intArrCount)
            ReDim Preserve vntArrStrAge(intArrCount)
            ReDim Preserve vntArrEndAge(intArrCount)
            ReDim Preserve vntArrbsdPrice(intArrCount)
            ReDim Preserve vntArrisrPrice(intArrCount)
    
            With obTargetListView.ListItems(i)
                
                vntArrExistsIsr(intArrCount) = intListViewIndex
                vntArrSeq(intArrCount) = intSeqCount
                vntArrStrAge(intArrCount) = .Text
                vntArrEndAge(intArrCount) = .SubItems(1)
                vntArrbsdPrice(intArrCount) = .SubItems(2)
                vntArrisrPrice(intArrCount) = .SubItems(3)
            
            End With
            
            intArrCount = intArrCount + 1
            intSeqCount = intSeqCount + 1
            
        Next i
    
    Next intListViewIndex

    vntExistsIsr = vntArrExistsIsr
    vntSeq = vntArrSeq
    vntStrAge = vntArrStrAge
    vntEndAge = vntArrEndAge
    vntBsdPrice = vntArrbsdPrice
    vntIsrPrice = vntArrisrPrice

    intItemCount = intArrCount

End Sub

Private Sub cmdAddItem_Click(Index As Integer)

    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    
    Dim strStrAge           As String           '�J�n�N��
    Dim strEndAge           As String           '�I���N��
    Dim strbsdPrice         As String           '�c�̕��S��
    Dim strisrPrice         As String           '���ە��S��
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ō��ۗL����I��
    Set obTargetListView = lsvItem(Index)

    With frmEditItem_P_Price
        
        '�K�C�h�ɑ΂���v���p�e�B�Z�b�g
        .ExistsIsr = Index
        .StrAge = "0"
        .EndAge = "999.99"
        .BsdPrice = "0"
        .IsrPrice = "0"
    
        .Show vbModal
    
        If .Updated = True Then
            
            strStrAge = .StrAge
            strEndAge = .EndAge
            strbsdPrice = .BsdPrice
            strisrPrice = .IsrPrice
            
            '�X�V����Ă���Ȃ�A���X�g�r���[�ɒǉ�
            Set objItem = obTargetListView.ListItems.Add(, KEY_PREFIX & mintUniqueKey, strStrAge, , "DEFAULTLIST")
            objItem.SubItems(1) = strEndAge
            objItem.SubItems(2) = strbsdPrice
            objItem.SubItems(3) = strisrPrice
        
            mintUniqueKey = mintUniqueKey + 1
            
            '�˗����ڒP���ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
        
    End With
    
    '�I�u�W�F�N�g�̔p��
    Set frmEditItem_P_Price = Nothing
    
End Sub

Private Function ApplyData(blnOkMode As Boolean) As Boolean

    ApplyData = False
    
    '���̓`�F�b�N
    If CheckValue() = False Then
        Exit Function
    End If
    
    '�˗����ڒP���Ǘ��e�[�u���̓o�^
    If RegistItem_P_Price() = False Then
        Exit Function
    End If
    
    '�X�V�ς݃t���O��TRUE��
    mblnUpdated = True
        
    'OK�{�^���������͂����ŏI��
    If blnOkMode = True Then
        ApplyData = True
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
            '�˗����ڒP���ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
    
    Next i

End Sub

Private Sub cmdDownItem_Click(Index As Integer)
    
    Call MoveListItem(1, Index)

End Sub

Private Sub cmdEditItem_Click(Index As Integer)

    Dim i                       As Integer
    Dim strTargetKey            As String
    Dim strTargetDiv            As String
    Dim strTargetCd             As String
    Dim obTargetListView        As ListView
    
    Dim intSelectedIndex        As Integer
    Dim intSelectedCount        As Integer
    
    '�N���b�N���ꂽ�C���f�b�N�X�Ō��ۗL����I��
    Set obTargetListView = lsvItem(Index)
    
    '���X�g�r���[��̑I�����ڐ����J�E���g
    intSelectedIndex = 0
    intSelectedCount = 0
    With obTargetListView
        For i = 1 To .ListItems.Count
            If .ListItems(i).Selected = True Then
                intSelectedIndex = i
                intSelectedCount = intSelectedCount + 1
            End If
        Next i
    End With
    
    '�����I������Ă��Ȃ��Ȃ珈���I��
    If intSelectedCount = 0 Then Exit Sub
    
    '�����I����ԂȂ�G���[
    If intSelectedCount > 1 Then
        MsgBox "���ڂ������I������Ă��܂��B�����C������ꍇ�́A������I�����Ă��������B", vbExclamation, Me.Caption
        Exit Sub
    End If
    
    With frmEditItem_P_Price
        
        '�K�C�h�ɑ΂���v���p�e�B�Z�b�g
        .ExistsIsr = Index
        .StrAge = obTargetListView.ListItems(intSelectedIndex).Text
        .EndAge = obTargetListView.ListItems(intSelectedIndex).SubItems(1)
        .BsdPrice = obTargetListView.ListItems(intSelectedIndex).SubItems(2)
        .IsrPrice = obTargetListView.ListItems(intSelectedIndex).SubItems(3)
    
        .Show vbModal
    
        If .Updated = True Then
            
            obTargetListView.ListItems(intSelectedIndex).Text = .StrAge
            obTargetListView.ListItems(intSelectedIndex).SubItems(1) = .EndAge
            obTargetListView.ListItems(intSelectedIndex).SubItems(2) = .BsdPrice
            obTargetListView.ListItems(intSelectedIndex).SubItems(3) = .IsrPrice
                
            '�˗����ڒP���ڍ׍X�V�ς�
            mblnItemUpdated = True
        
        End If
        
    End With

    '�I�u�W�F�N�g�̔p��
    Set frmEditItem_P_Price = Nothing

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
    
        '�˗����ږ��̂̕\��
        lblItemInfo.Caption = mstrItemCd & "�F" & mstrRequestName
    
        '�˗����ڒP�����̎擾
        If GetItem_P_Price() = False Then Exit Do
        
        '�˗����ڒP�����̃��X�g�r���[�i�[
        If EditListViewFromCollection() = False Then Exit Do
        
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

Private Sub lsvItem_DblClick(Index As Integer)

    Call cmdEditItem_Click(Index)

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
    
    Set objTargetListView = lsvItem(intListViewIndex)
    objTargetListView.ListItems.Clear
    Set objHeader = objTargetListView.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�J�n�N��", 1000, lvwColumnLeft
        .Add , , "�I���N��", 1000, lvwColumnLeft
        .Add , , "�c�̕��S���z", 1300, lvwColumnRight
        .Add , , "���ە��S���z", 1300, lvwColumnRight
    End With
    objTargetListView.View = lvwReport

End Sub
