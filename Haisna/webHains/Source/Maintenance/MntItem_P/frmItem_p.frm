VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmItem_P 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�˗����ڃ����e�i���X"
   ClientHeight    =   6810
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7470
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmItem_p.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6810
   ScaleWidth      =   7470
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   6000
      TabIndex        =   30
      Top             =   6360
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4560
      TabIndex        =   29
      Top             =   6360
      Width           =   1335
   End
   Begin TabDlg.SSTab tabMain 
      Height          =   6075
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   7215
      _ExtentX        =   12726
      _ExtentY        =   10716
      _Version        =   393216
      Style           =   1
      Tab             =   2
      TabHeight       =   520
      TabCaption(0)   =   "��{���"
      TabPicture(0)   =   "frmItem_p.frx":000C
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "fraMain(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "�I�[�_���M���"
      TabPicture(1)   =   "frmItem_p.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraMain(1)"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).ControlCount=   1
      TabCaption(2)   =   "�������"
      TabPicture(2)   =   "frmItem_p.frx":0044
      Tab(2).ControlEnabled=   -1  'True
      Tab(2).Control(0)=   "Frame3"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).ControlCount=   1
      Begin VB.Frame Frame3 
         Height          =   3435
         Left            =   240
         TabIndex        =   36
         Top             =   420
         Visible         =   0   'False
         Width           =   6795
         Begin VB.CommandButton cmdItem_P_Price 
            Caption         =   "�c�́A���ۖ��̒P����ݒ肷��(&M)..."
            Height          =   375
            Left            =   2400
            TabIndex        =   43
            Top             =   360
            Width           =   2955
         End
         Begin VB.ComboBox cboRoundClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":0060
            Left            =   2400
            List            =   "frmItem_p.frx":0082
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   40
            Top             =   2340
            Width           =   4230
         End
         Begin VB.ComboBox cboIsrDmdLineClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":00A4
            Left            =   2400
            List            =   "frmItem_p.frx":00C6
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   39
            Top             =   1380
            Width           =   4230
         End
         Begin VB.ComboBox cboDmdLineClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":00E8
            Left            =   2400
            List            =   "frmItem_p.frx":010A
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   37
            Top             =   1020
            Width           =   4230
         End
         Begin VB.Label Label3 
            Caption         =   "���ڒP���ݒ�(&P):"
            Height          =   195
            Index           =   9
            Left            =   240
            TabIndex        =   44
            Top             =   480
            Width           =   1575
         End
         Begin VB.Label Label3 
            Caption         =   "���ی�����������(&I):"
            Height          =   195
            Index           =   7
            Left            =   180
            TabIndex        =   42
            Top             =   1440
            Width           =   1815
         End
         Begin VB.Label Label3 
            Caption         =   "�܂�ߕ���(&R):"
            Height          =   195
            Index           =   8
            Left            =   180
            TabIndex        =   41
            Top             =   2400
            Width           =   1635
         End
         Begin VB.Label Label3 
            Caption         =   "��ʒc�̌�����������(&O):"
            Height          =   195
            Index           =   6
            Left            =   180
            TabIndex        =   38
            Top             =   1080
            Width           =   2115
         End
      End
      Begin VB.Frame fraMain 
         Height          =   2895
         Index           =   1
         Left            =   -74760
         TabIndex        =   28
         Top             =   420
         Visible         =   0   'False
         Width           =   6795
         Begin VB.TextBox txtDocCd 
            Height          =   318
            IMEMode         =   3  '�̌Œ�
            Left            =   1980
            MaxLength       =   4
            TabIndex        =   25
            Text            =   "1234"
            Top             =   1440
            Width           =   795
         End
         Begin VB.TextBox txtOrderFileName 
            Height          =   318
            IMEMode         =   3  '�̌Œ�
            Left            =   1980
            MaxLength       =   20
            TabIndex        =   27
            Text            =   "1234567"
            Top             =   1860
            Width           =   4575
         End
         Begin VB.Label Label3 
            Caption         =   "������ʃR�[�h(&B):"
            Height          =   195
            Index           =   5
            Left            =   300
            TabIndex        =   24
            Top             =   1500
            Width           =   1515
         End
         Begin VB.Label lblOrderDoc 
            Caption         =   "Label2"
            Height          =   675
            Left            =   360
            TabIndex        =   35
            Top             =   420
            Width           =   5955
         End
         Begin VB.Label Label3 
            Caption         =   "�I�[�_�t�@�C����(&O):"
            Height          =   195
            Index           =   4
            Left            =   300
            TabIndex        =   26
            Top             =   1920
            Width           =   1515
         End
      End
      Begin VB.Frame fraMain 
         Height          =   5355
         Index           =   0
         Left            =   -74760
         TabIndex        =   31
         Top             =   420
         Width           =   6795
         Begin VB.Frame Frame1 
            Height          =   1215
            Left            =   1980
            TabIndex        =   33
            Top             =   2940
            Width           =   4635
            Begin VB.OptionButton optEntryOk 
               Caption         =   "�P�ł����ʂ��Z�b�g���ꂽ����͊���(&1)"
               Height          =   255
               Index           =   0
               Left            =   180
               TabIndex        =   15
               ToolTipText     =   "���̈˗����ڂ��Ǘ����錟�����ڂɈ�ł����ʂ��Z�b�g���ꂽ�ꍇ�A���͊����Ƃ��܂��B"
               Top             =   240
               Value           =   -1  'True
               Width           =   3855
            End
            Begin VB.OptionButton optEntryOk 
               Caption         =   "�S�Ă̍��ڂɌ��ʂ��Z�b�g���ꂽ����͊���(&2)"
               Height          =   255
               Index           =   1
               Left            =   180
               TabIndex        =   16
               ToolTipText     =   "���̈˗����ڂ��Ǘ����錟�����ڑS�ĂɌ��ʂ��Z�b�g����Ȃ��Ɠ��͊����Ƃ݂Ȃ��܂���B"
               Top             =   540
               Width           =   4155
            End
            Begin VB.OptionButton optEntryOk 
               Caption         =   "�����̓`�F�b�N�����Ȃ�(&3)"
               Height          =   255
               Index           =   2
               Left            =   180
               TabIndex        =   17
               ToolTipText     =   "�����̓`�F�b�N���s���܂���"
               Top             =   840
               Width           =   2115
            End
         End
         Begin VB.ComboBox cboItemClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":012C
            Left            =   1980
            List            =   "frmItem_p.frx":014E
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   10
            Top             =   1800
            Width           =   4665
         End
         Begin VB.TextBox txtItemCd 
            Height          =   300
            IMEMode         =   3  '�̌Œ�
            Left            =   1980
            MaxLength       =   6
            TabIndex        =   2
            Text            =   "@@@@@@"
            Top             =   360
            Width           =   855
         End
         Begin VB.TextBox txtRequestName 
            Height          =   300
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1980
            MaxLength       =   20
            TabIndex        =   6
            Text            =   "��������������������"
            Top             =   840
            Width           =   2055
         End
         Begin VB.TextBox txtRequestSName 
            Height          =   300
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1980
            MaxLength       =   10
            TabIndex        =   8
            Text            =   "����������"
            Top             =   1200
            Width           =   1035
         End
         Begin VB.ComboBox cboProgress 
            Height          =   300
            ItemData        =   "frmItem_p.frx":0170
            Left            =   1980
            List            =   "frmItem_p.frx":0192
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   12
            Top             =   2160
            Width           =   4650
         End
         Begin VB.ComboBox cboSearchChar 
            Height          =   300
            ItemData        =   "frmItem_p.frx":01B4
            Left            =   1980
            List            =   "frmItem_p.frx":01D6
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   19
            Top             =   4260
            Width           =   810
         End
         Begin VB.ComboBox cboOpeClass 
            Height          =   300
            ItemData        =   "frmItem_p.frx":01F8
            Left            =   1980
            List            =   "frmItem_p.frx":021A
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   14
            Top             =   2520
            Visible         =   0   'False
            Width           =   4650
         End
         Begin VB.Frame Frame2 
            Height          =   495
            Left            =   2940
            TabIndex        =   32
            Top             =   240
            Width           =   3375
            Begin VB.OptionButton optRslQue 
               Caption         =   "��������(&K)"
               Height          =   255
               Index           =   0
               Left            =   180
               TabIndex        =   3
               Top             =   180
               Value           =   -1  'True
               Width           =   1275
            End
            Begin VB.OptionButton optRslQue 
               Caption         =   "��f����(&M)"
               Height          =   255
               Index           =   1
               Left            =   1620
               TabIndex        =   4
               Top             =   180
               Width           =   1275
            End
         End
         Begin VB.TextBox txtPrice2 
            Height          =   318
            IMEMode         =   3  '�̌Œ�
            Left            =   5700
            MaxLength       =   7
            TabIndex        =   23
            Text            =   "1234567"
            Top             =   4260
            Visible         =   0   'False
            Width           =   795
         End
         Begin VB.TextBox txtPrice1 
            Height          =   318
            IMEMode         =   3  '�̌Œ�
            Left            =   3840
            MaxLength       =   7
            TabIndex        =   21
            Text            =   "1234567"
            Top             =   4260
            Visible         =   0   'False
            Width           =   795
         End
         Begin VB.Label Label8 
            Caption         =   "�������ڃR�[�h(&C):"
            Height          =   195
            Index           =   0
            Left            =   300
            TabIndex        =   1
            Top             =   420
            Width           =   1455
         End
         Begin VB.Label Label1 
            Caption         =   "�˗����ږ�(&N):"
            Height          =   180
            Index           =   1
            Left            =   300
            TabIndex        =   5
            Top             =   900
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "�˗����ڗ���(&R):"
            Height          =   180
            Index           =   3
            Left            =   300
            TabIndex        =   7
            Top             =   1260
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "��������(&L):"
            Height          =   180
            Index           =   4
            Left            =   300
            TabIndex        =   9
            Top             =   1860
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "�i������(&P):"
            Height          =   180
            Index           =   5
            Left            =   300
            TabIndex        =   11
            Top             =   2220
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "�����̓`�F�b�N:"
            Height          =   180
            Index           =   6
            Left            =   300
            TabIndex        =   34
            Top             =   3120
            Width           =   1350
         End
         Begin VB.Label Label3 
            Caption         =   "�����p������(&S):"
            Height          =   195
            Index           =   2
            Left            =   300
            TabIndex        =   18
            Top             =   4320
            Width           =   1395
         End
         Begin VB.Label Label3 
            Caption         =   "�������{������(&J):"
            Height          =   195
            Index           =   0
            Left            =   300
            TabIndex        =   13
            Top             =   2580
            Visible         =   0   'False
            Width           =   1635
         End
         Begin VB.Label Label3 
            Caption         =   "��{�����Q(&2):"
            Height          =   195
            Index           =   1
            Left            =   4500
            TabIndex        =   22
            Top             =   4320
            Visible         =   0   'False
            Width           =   1095
         End
         Begin VB.Label Label3 
            Caption         =   "��{�����P(&1):"
            Height          =   195
            Index           =   3
            Left            =   2820
            TabIndex        =   20
            Top             =   4320
            Visible         =   0   'False
            Width           =   1095
         End
      End
   End
End
Attribute VB_Name = "frmItem_P"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd                  As String   '�������ڃR�[�h
Private mblnInitialize              As Boolean  'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated                 As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrRootClassCd()           As String   '�R���{�{�b�N�X�ɑΉ����錟�����ރR�[�h�̊i�[
Private mstrRootProgressCd()        As String   '�R���{�{�b�N�X�ɑΉ�����i�����ރR�[�h�̊i�[
Private mstrRootOpeClassCd()        As String   '�R���{�{�b�N�X�ɑΉ����錟�����{�����ރR�[�h�̊i�[

Private mstrRootDmdLineClassCd()    As String   '�R���{�{�b�N�X�ɑΉ����鐿�����ו��ށi��ʁj�R�[�h�̊i�[
Private mstrRootIsrDmdLineClassCd() As String   '�R���{�{�b�N�X�ɑΉ����鐿�����ו��ށi�c�́j�R�[�h�̊i�[
Private mstrRootRoundClassCd()      As String   '�R���{�{�b�N�X�ɑΉ����鐿�����ו��ރR�[�h�̊i�[

Private mintDetailMaxKey            As Integer      '�׏��̃��X�g�r���[�L�[�����j�[�N�ɂ��邽�߂ɕێ�
Private mcolGotFocusCollection      As Collection   'GotFocus���̕����I��p�R���N�V����

Const mstrListViewKey               As String = "K"
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
    
    Ret = False
    
    Do
        
        '�R�[�h�͂Ƃ�݂�
        txtItemCd.Text = Trim(txtItemCd.Text)
        
        '�R�[�h�̓��̓`�F�b�N
        If txtItemCd.Text = "" Then
            MsgBox "�������ڃR�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            txtItemCd.SetFocus
            Exit Do
        End If
        
        '�R�[�h�̃n�C�t���`�F�b�N
        If InStr(txtItemCd.Text, "-") > 0 Then
            MsgBox "�������ڃR�[�h�Ƀn�C�t�����܂߂邱�Ƃ͂ł��܂���B", vbExclamation, App.Title
            txtItemCd.SetFocus
            Exit Do
        End If
        
        '���̂̓��̓`�F�b�N
        If Trim(txtRequestName.Text) = "" Then
            MsgBox "�˗����ږ������͂���Ă��܂���B", vbExclamation, App.Title
            txtRequestName.SetFocus
            Exit Do
        End If
        
        '���̂̓��̓`�F�b�N
        If Trim(txtRequestSName.Text) = "" Then
            txtRequestSName.Text = Mid(Trim(txtRequestName.Text), 1, 5)
        End If
        
'### 2003/11/23 Deleted by Ishihara@FSIT �s�v���ڂ̍폜
'        ���z1�̓��̓`�F�b�N
'        If Trim(txtPrice1.Text) = "" Then
'            txtPrice1.Text = 0
'        End If
'
'        ���z1�̐��l�`�F�b�N
'        If IsNumeric(Trim(txtPrice1.Text)) = False Then
'            MsgBox "���z�P�ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
'            txtPrice1.SetFocus
'            Exit Do
'        End If
'
'        ���z2�̓��̓`�F�b�N
'        If Trim(txtPrice2.Text) = "" Then
'            txtPrice2.Text = 0
'        End If
'
'        ���z2�̐��l�`�F�b�N
'        If IsNumeric(Trim(txtPrice2.Text)) = False Then
'            MsgBox "���z�Q�ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
'            txtPrice2.SetFocus
'            Exit Do
'        End If
'
'        '�������ނ͗�����x�ɓo�^����B
'        If (cboDmdLineClass.ListIndex = 0) And (cboIsrDmdLineClass.ListIndex <> 0) Then
'            tabMain.Tab = 2
'            cboDmdLineClass.SetFocus
'            MsgBox "�������ނ�ݒ肷��ꍇ�́A�K�������ݒ肵�Ă��������B", vbExclamation, App.Title
'            Exit Do
'        End If
'
'        If (cboDmdLineClass.ListIndex <> 0) And (cboIsrDmdLineClass.ListIndex = 0) Then
'            tabMain.Tab = 2
'            cboIsrDmdLineClass.SetFocus
'            MsgBox "�������ނ�ݒ肷��ꍇ�́A�K�������ݒ肵�Ă��������B", vbExclamation, App.Title
'            Exit Do
'        End If
'### 2003/11/23 Deleted End

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function



' @(e)
'
' �@�\�@�@ : �������ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditItemClassConbo() As Boolean

    Dim objItemClass        As Object   '�������ރA�N�Z�X�p
    Dim vntClassCd      As Variant
    Dim vntItemClassName    As Variant
    Dim lngCount            As Long     '���R�[�h��
    Dim i                   As Long     '�C���f�b�N�X
    
    EditItemClassConbo = False
    
    cboItemClass.Clear
    Erase mstrRootClassCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemClass = CreateObject("HainsItem.Item")
    lngCount = objItemClass.SelectItemClassList(vntClassCd, vntItemClassName)
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootClassCd(i)
        mstrRootClassCd(i) = vntClassCd(i)
        cboItemClass.AddItem vntItemClassName(i)
    Next i
    
    '�f�[�^�����݂��Ȃ��Ȃ�A�G���[
    If lngCount <= 0 Then
        MsgBox "�������ނ����݂��܂���B�������ރf�[�^��o�^���Ȃ��ƈ˗����ڐݒ���s�����Ƃ͂ł��܂���B", vbExclamation
        Exit Function
    End If
    
    '�擪�R���{��I����Ԃɂ���
    cboItemClass.ListIndex = 0
    EditItemClassConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' �@�\�@�@ : �������ו��ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ו��ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditDmdLineClassConbo() As Boolean

    Dim objDmdLineClass     As Object   '�������{�����ރA�N�Z�X�p
    Dim vntDmdLineClassCd   As Variant
    Dim vntDmdLineClassName As Variant
    Dim vntIsrFlg           As Variant
    
    Dim lngCount            As Long     '���R�[�h��
    Dim i                   As Long     '�C���f�b�N�X
    Dim j                   As Long     '�C���f�b�N�X
    Dim k                   As Long     '�C���f�b�N�X
    
    EditDmdLineClassConbo = False
    
    cboDmdLineClass.Clear
    cboIsrDmdLineClass.Clear
    Erase mstrRootDmdLineClassCd
    Erase mstrRootIsrDmdLineClassCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDmdLineClass = CreateObject("HainsDmdClass.DmdClass")
    lngCount = objDmdLineClass.SelectDmdLineClassItemList(vntDmdLineClassCd, vntDmdLineClassName, , vntIsrFlg)
    
    '�������ו��ނ͖��w�肠��
    ReDim Preserve mstrRootDmdLineClassCd(0)
    ReDim Preserve mstrRootIsrDmdLineClassCd(0)
    mstrRootDmdLineClassCd(0) = ""
    mstrRootIsrDmdLineClassCd(0) = ""
    
    cboDmdLineClass.AddItem ""
    cboIsrDmdLineClass.AddItem ""
    cboDmdLineClass.ListIndex = 0
    cboIsrDmdLineClass.ListIndex = 0
    
    '�R���{�{�b�N�X�̕ҏW
    j = 1
    k = 1
    For i = 0 To lngCount - 1
        
        Select Case vntIsrFlg(i)
            Case ""
                ReDim Preserve mstrRootDmdLineClassCd(j)
                mstrRootDmdLineClassCd(j) = vntDmdLineClassCd(i)
                cboDmdLineClass.AddItem vntDmdLineClassName(i)
                j = j + 1
            
                ReDim Preserve mstrRootIsrDmdLineClassCd(k)
                mstrRootIsrDmdLineClassCd(k) = vntDmdLineClassCd(i)
                cboIsrDmdLineClass.AddItem vntDmdLineClassName(i)
                k = k + 1
            
            Case "0"
                ReDim Preserve mstrRootDmdLineClassCd(j)
                mstrRootDmdLineClassCd(j) = vntDmdLineClassCd(i)
                cboDmdLineClass.AddItem vntDmdLineClassName(i)
                j = j + 1
            
            Case "1"
                ReDim Preserve mstrRootIsrDmdLineClassCd(k)
                mstrRootIsrDmdLineClassCd(k) = vntDmdLineClassCd(i)
                cboIsrDmdLineClass.AddItem vntDmdLineClassName(i)
                k = k + 1
        End Select
        
    Next i
    
    '�f�[�^�����݂��Ȃ��Ȃ�A�����I���i�������ނ̖��o�^�̓G���[�ł͂Ȃ��j
    If lngCount <= 0 Then
        EditDmdLineClassConbo = True
        Exit Function
    End If
    
    EditDmdLineClassConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' �@�\�@�@ : �܂�ߕ��ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �܂�ߕ��ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditRoundClassConbo() As Boolean

    Dim objRoundClass       As Object   '�܂�ߕ��ރA�N�Z�X�p
    Dim vntRoundClassCd     As Variant
    Dim vntRoundClassName   As Variant
    Dim vntIsrFlg           As Variant
    
    Dim lngCount            As Long     '���R�[�h��
    Dim i                   As Long     '�C���f�b�N�X
    
    EditRoundClassConbo = False
    
    cboRoundClass.Clear
    Erase mstrRootRoundClassCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRoundClass = CreateObject("HainsRoundClass.RoundClass")
    lngCount = objRoundClass.SelectRoundClassList(vntRoundClassCd, vntRoundClassName)
    
    '�������ו��ނ͖��w�肠��
    ReDim Preserve mstrRootRoundClassCd(0)
    mstrRootRoundClassCd(0) = ""
    cboRoundClass.AddItem ""
    cboRoundClass.ListIndex = 0
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        
        ReDim Preserve mstrRootRoundClassCd(i + 1)
        mstrRootRoundClassCd(i + 1) = vntRoundClassCd(i)
        cboRoundClass.AddItem vntRoundClassName(i)
        
    Next i
    
    '�f�[�^�����݂��Ȃ��Ȃ�A�����I���i�܂�ߕ��ނ̖��o�^�̓G���[�ł͂Ȃ��j
    If lngCount <= 0 Then
        EditRoundClassConbo = True
        Exit Function
    End If
    
    EditRoundClassConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' �@�\�@�@ : �������{�����ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������{�����ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditOpeClassConbo() As Boolean

    Dim objOpeClass     As Object   '�������{�����ރA�N�Z�X�p
    Dim vntOpeClassCd   As Variant
    Dim vntOpeClassName As Variant
    Dim lngCount        As Long     '���R�[�h��
    Dim i               As Long     '�C���f�b�N�X
    
    EditOpeClassConbo = False
    
    cboOpeClass.Clear
    Erase mstrRootOpeClassCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objOpeClass = CreateObject("HainsOpeClass.OpeClass")
    lngCount = objOpeClass.SelectOpeClassList(vntOpeClassCd, vntOpeClassName)
    
    '�������{�����ނ͖��w�肠��
    ReDim Preserve mstrRootOpeClassCd(0)
    mstrRootOpeClassCd(0) = ""
    cboOpeClass.AddItem ""
'## 2002.02.12 ADD H.Ishihara@FSIT ���{�����o�^�Ή�
    cboOpeClass.ListIndex = 0
'## 2002.02.12 ADD END
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootOpeClassCd(i + 1)
        mstrRootOpeClassCd(i + 1) = vntOpeClassCd(i)
        cboOpeClass.AddItem vntOpeClassName(i)
    Next i
    
    '�f�[�^�����݂��Ȃ��Ȃ�A�����I���i�������{���̖��o�^�̓G���[�ł͂Ȃ��j
    If lngCount <= 0 Then
'## 2002.02.12 ADD H.Ishihara@FSIT ���o�^�͐���I��
        EditOpeClassConbo = True
'## 2002.02.12 ADD END
        Exit Function
    End If
    
    '�擪�R���{��I����Ԃɂ���
    cboOpeClass.ListIndex = 0
    EditOpeClassConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' �@�\�@�@ : �i�����ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �i�����ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditProgressConbo() As Boolean

    Dim objProgress     As Object   '�i�����ރA�N�Z�X�p
    Dim vntProgressCd   As Variant
    Dim vntProgressName As Variant
    Dim lngCount        As Long     '���R�[�h��
    Dim i               As Long     '�C���f�b�N�X
    
    EditProgressConbo = False
    
    cboProgress.Clear
    Erase mstrRootProgressCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objProgress = CreateObject("HainsProgress.Progress")
    lngCount = objProgress.SelectProgressList(vntProgressCd, vntProgressName)
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootProgressCd(i)
        mstrRootProgressCd(i) = vntProgressCd(i)
        cboProgress.AddItem vntProgressName(i)
    Next i
    
    '�f�[�^�����݂��Ȃ��Ȃ�A�G���[
    If lngCount <= 0 Then
        MsgBox "�i�����ނ����݂��܂���B�i�����ރf�[�^��o�^���Ȃ��ƈ˗����ڐݒ���s�����Ƃ͂ł��܂���B", vbExclamation
        Exit Function
    End If
    
    '�擪�R���{��I����Ԃɂ���
    cboProgress.ListIndex = 0
    EditProgressConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

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
Private Function EditItem_P() As Boolean

    Dim objItem_P           As Object          '�˗����ڃA�N�Z�X�p
    
    Dim vntRequestName          As Variant          '�������ږ���
    Dim vntRslQue               As Variant          '���ʖ�f�t���O
    Dim vntClassCd              As Variant          '�������ރR�[�h
    Dim vntRequestSName         As Variant          '�������ڗ���
    Dim vntProgressCd           As Variant          '�i�����ރR�[�h
    Dim vntEntryOk              As Variant          '�����̓`�F�b�N
    Dim vntSearchChar           As Variant          '�K�C�h����������
    Dim vntOpeClassCd           As Variant          '�������{�����ރR�[�h
    Dim vntPrice1               As Variant          '�P���P
    Dim vntPrice2               As Variant          '�P���Q
    Dim vntOrderFileName        As Variant          '�I�[�_�t�@�C����
    Dim vntDocCd                As Variant          '������ʃR�[�h
    Dim vntDmdLineClassCd       As Variant          '�������ו��ރR�[�h
    Dim vntIsrDmdLineClassCd    As Variant          '���ې������ו��ރR�[�h
    Dim vntRoundClassCd         As Variant          '�܂�ߕ��ރR�[�h

    Dim Ret                 As Boolean          '�߂�l
    Dim i                   As Integer
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem_P = CreateObject("HainsItem.Item")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrItemCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�˗����ڃe�[�u�����R�[�h�ǂݍ���
        If objItem_P.SelectItem_P(mstrItemCd, _
                                  vntRequestName, _
                                  vntRslQue, _
                                  vntClassCd, _
                                  vntRequestSName, _
                                  vntProgressCd, _
                                  vntEntryOk, _
                                  vntSearchChar, _
                                  vntOpeClassCd, _
                                  vntPrice1, _
                                  vntPrice2, _
                                  vntOrderFileName, _
                                  vntDocCd, _
                                  vntDmdLineClassCd, _
                                  vntIsrDmdLineClassCd, _
                                  vntRoundClassCd) = False Then
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
        
        '�e�L�X�g�{�b�N�X�̃Z�b�g
        txtItemCd.Text = mstrItemCd
        txtRequestName.Text = vntRequestName
        txtRequestSName.Text = vntRequestSName
        txtPrice1.Text = vntPrice1
        txtPrice2.Text = vntPrice2
    
        '�I�v�V�����{�^���̃Z�b�g
        optRslQue(CInt(vntRslQue)).Value = True
        optEntryOk(CInt(vntEntryOk)).Value = True
    
        '�������ރR���{�̐ݒ�
        For i = 0 To cboItemClass.ListCount - 1
            If mstrRootClassCd(i) = vntClassCd Then
                cboItemClass.ListIndex = i
            End If
        Next i
    
        '�i�����ރR���{�̐ݒ�
        For i = 0 To cboProgress.ListCount - 1
            If mstrRootProgressCd(i) = vntProgressCd Then
                cboProgress.ListIndex = i
            End If
        Next i
        
        '����������R���{�̐ݒ�
        For i = 0 To cboSearchChar.ListCount - 1
            If cboSearchChar.List(i) = vntSearchChar Then
                cboSearchChar.ListIndex = i
            End If
        Next i
        
        '�������{�����ރR���{�̐ݒ�
        If Trim(vntOpeClassCd) <> "" Then
            For i = 0 To cboOpeClass.ListCount - 1
                If mstrRootOpeClassCd(i) = vntOpeClassCd Then
                    cboOpeClass.ListIndex = i
                End If
            Next i
        End If
        
        '��ʐ������ו��ރR���{�̐ݒ�
        If Trim(vntDmdLineClassCd) <> "" Then
            For i = 0 To cboDmdLineClass.ListCount - 1
                If mstrRootDmdLineClassCd(i) = vntDmdLineClassCd Then
                    cboDmdLineClass.ListIndex = i
                End If
            Next i
        End If
    
        '���ې������ו��ރR���{�̐ݒ�
        If Trim(vntIsrDmdLineClassCd) <> "" Then
            For i = 0 To cboIsrDmdLineClass.ListCount - 1
                If mstrRootIsrDmdLineClassCd(i) = vntIsrDmdLineClassCd Then
                    cboIsrDmdLineClass.ListIndex = i
                End If
            Next i
        End If
    
        '�܂�ߕ��ރR���{�̐ݒ�
        If Trim(vntRoundClassCd) <> "" Then
            For i = 0 To cboRoundClass.ListCount - 1
                If mstrRootRoundClassCd(i) = vntRoundClassCd Then
                    cboRoundClass.ListIndex = i
                End If
            Next i
        End If
    
        '�d�J���A�g�֘A���̐ݒ�
        txtOrderFileName.Text = vntOrderFileName
        txtDocCd.Text = vntDocCd
    
        Ret = True
        Exit Do
    
    Loop
    
    '�߂�l�̐ݒ�
    EditItem_P = Ret
    
    Exit Function

ErrorHandle:

    EditItem_P = False
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
Private Function RegistItem_P() As Boolean

On Error GoTo ErrorHandle

    Dim objItem_P       As Object       '�˗����ڃA�N�Z�X�p
    Dim Ret             As Long
    Dim intEntryOk      As Integer
    Dim strSearchChar   As String
    
    '�����̓`�F�b�N�̐��l��
    intEntryOk = 0
    Select Case True
        Case optEntryOk(1).Value
            intEntryOk = 1
        Case optEntryOk(2).Value
            intEntryOk = 2
    End Select
        
    '�K�C�h����������̍ĕҏW
    strSearchChar = cboSearchChar.List(cboSearchChar.ListIndex)
    If strSearchChar = "���̑�" Then
        strSearchChar = "*"
    End If
        
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem_P = CreateObject("HainsItem.Item")
    
    '�˗����ڃe�[�u�����R�[�h�̓o�^
'### 2003/11/23 Modifed by Ishihara@FSIT �s�v���ڂ̍폜
'    Ret = objItem_P.RegistItem_P(IIf(txtItemCd.Enabled, "INS", "UPD"), _
                                 Trim(txtItemCd.Text), _
                                 mstrRootClassCd(cboItemClass.ListIndex), _
                                 IIf(optRslQue(0).Value = True, 0, 1), _
                                 Trim(txtRequestName.Text), _
                                 Trim(txtRequestSName.Text), _
                                 mstrRootProgressCd(cboProgress.ListIndex), _
                                 intEntryOk, _
                                 strSearchChar, _
                                 mstrRootOpeClassCd(cboOpeClass.ListIndex), _
                                 Trim(txtPrice1.Text), _
                                 Trim(txtPrice2.Text), _
                                 Trim(txtOrderFileName.Text), _
                                 Trim(txtDocCd.Text), _
                                 mstrRootDmdLineClassCd(cboDmdLineClass.ListIndex), _
                                 mstrRootIsrDmdLineClassCd(cboIsrDmdLineClass.ListIndex), _
                                 mstrRootRoundClassCd(cboRoundClass.ListIndex))
    Ret = objItem_P.RegistItem_P(IIf(txtItemCd.Enabled, "INS", "UPD"), _
                                 Trim(txtItemCd.Text), _
                                 mstrRootClassCd(cboItemClass.ListIndex), _
                                 IIf(optRslQue(0).Value = True, 0, 1), _
                                 Trim(txtRequestName.Text), _
                                 Trim(txtRequestSName.Text), _
                                 mstrRootProgressCd(cboProgress.ListIndex), _
                                 intEntryOk, _
                                 strSearchChar, _
                                 "")
'### 2003/11/23 Modifed End
    
    If Ret = 0 Then
        MsgBox "���͂��ꂽ�˗����ڃR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistItem_P = False
        Exit Function
    End If
    
    RegistItem_P = True
    
    Exit Function
    
ErrorHandle:

    RegistItem_P = False
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
Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdItem_P_Price_Click()

    Dim objItem_P_Price   As Object   '�����e�i���X�E�C���h�E�I�u�W�F�N�g

    Set objItem_P_Price = New mntItem_P_Price.Item_P_Price
    With objItem_P_Price
        .ItemCd = mstrItemCd
        .RequestName = Trim(txtRequestName.Text)
    End With

    '�e�[�u�������e�i���X��ʂ��J��
    objItem_P_Price.Show vbModal
    
    '�I�u�W�F�N�g�̔p���i�g�����U�N�V������Commit����Ȃ��j
    Set objItem_P_Price = Nothing

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
    
    Do
        '���̓`�F�b�N
        If CheckValue() = False Then Exit Do
        
        '�˗����ڃe�[�u���̓o�^
        If RegistItem_P() = False Then Exit Do
            
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
    tabMain.Tab = 0         '�擪�^�u��Active
    mintDetailMaxKey = 0

    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    '�I�[�_�A�g�ݒ�̐���
    lblOrderDoc.Caption = "�����Őݒ肳�ꂽ�I�[�_�t�@�C�����A�����ԍ����g�p���ăI�[�_���M���s���܂��B" & vbLf & "�I�[�_���M�ɂ͂����Ŏw�肷����@�ƌ������ږ��ɕϊ��R�[�h���w�肷��ꍇ�̂Q�ʂ肪���݂��܂��B"

    '����������R���{������
    Call InitSearchCharCombo(cboSearchChar)
    
    Do
        '�������ރR���{�̕ҏW
        If EditItemClassConbo() = False Then
            Exit Do
        End If
        
        '�i�����ރR���{�̕ҏW
        If EditProgressConbo() = False Then
            Exit Do
        End If
        
'### 2003/11/23 Deleted by Ishihara@FSIT �s�v���ڂ̍폜
'        �������{�����ރR���{�̕ҏW
'        If EditOpeClassConbo() = False Then
'            Exit Do
'        End If
'
'        '�������ރR���{�̕ҏW
'        If EditDmdLineClassConbo() = False Then
'            Exit Do
'        End If
'
'        �܂�ߕ��ރR���{�̕ҏW
'        If EditRoundClassConbo() = False Then
'            Exit Do
'        End If
'### 2003/11/23 Deleted End
        
        '�˗����ڏ��̕ҏW
        If EditItem_P() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtItemCd.Enabled = (mstrItemCd = "")
        cmdItem_P_Price.Enabled = (mstrItemCd <> "")
                
        Ret = True
        Exit Do
    Loop
    
    tabMain.Tab = 0
    Call tabMain_Click(1)
    
    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub tabMain_Click(PreviousTab As Integer)

'    fraMain(tabMain.Tab).Enabled = True
'    fraMain(PreviousTab).Enabled = False

End Sub

