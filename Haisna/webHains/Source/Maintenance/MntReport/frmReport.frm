VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmReport 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "���[�Ǘ������e�i���X"
   ClientHeight    =   8265
   ClientLeft      =   570
   ClientTop       =   330
   ClientWidth     =   7230
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmReport.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   8265
   ScaleWidth      =   7230
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��ʂ̒���
   Begin TabDlg.SSTab tabMain 
      Height          =   6975
      Left            =   120
      TabIndex        =   52
      Top             =   780
      Width           =   6975
      _ExtentX        =   12303
      _ExtentY        =   12303
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "��{���"
      TabPicture(0)   =   "frmReport.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "fraMain(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "fraMain(1)"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "fraMain(2)"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "fraMain(3)"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "fraMain(4)"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).ControlCount=   5
      TabCaption(1)   =   "���[�t�@�C��"
      TabPicture(1)   =   "frmReport.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraMain(6)"
      Tab(1).Control(1)=   "fraMain(5)"
      Tab(1).ControlCount=   2
      Begin VB.Frame fraMain 
         Caption         =   "����"
         Height          =   1695
         Index           =   4
         Left            =   4140
         TabIndex        =   59
         Top             =   3420
         Width           =   2655
         Begin VB.TextBox txtCopyCount 
            Height          =   300
            IMEMode         =   3  '�̌Œ�
            Left            =   240
            MaxLength       =   2
            TabIndex        =   16
            Text            =   "@@"
            Top             =   360
            Width           =   435
         End
         Begin VB.Label Label5 
            Caption         =   "�����͂P�ȏ�̒l��ݒ肵�Ă��������B"
            Height          =   675
            Index           =   2
            Left            =   240
            TabIndex        =   62
            Top             =   780
            Width           =   2115
         End
         Begin VB.Label Label2 
            Caption         =   "�����"
            Height          =   255
            Left            =   720
            TabIndex        =   60
            Top             =   420
            Width           =   1455
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "���꒠�[�ݒ�"
         Height          =   1515
         Index           =   6
         Left            =   -74820
         TabIndex        =   58
         Top             =   5280
         Width           =   6615
         Begin VB.TextBox txtViewOrder 
            Height          =   300
            IMEMode         =   3  '�̌Œ�
            Left            =   1140
            MaxLength       =   3
            TabIndex        =   47
            Text            =   "@@"
            ToolTipText     =   "�ʐڎx����ʂɂāA�\�����鏇�Ԃ��w�肵�܂�"
            Top             =   1020
            Width           =   495
         End
         Begin VB.CheckBox chkKarteFlg 
            Caption         =   "���̒��[���J���e�Ƃ��Đݒ肷��(&K)"
            Height          =   315
            Left            =   240
            TabIndex        =   45
            Top             =   660
            Width           =   3975
         End
         Begin VB.ComboBox cboHistoryPrint 
            Height          =   300
            ItemData        =   "frmReport.frx":0044
            Left            =   4620
            List            =   "frmReport.frx":0066
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   44
            Top             =   300
            Width           =   1830
         End
         Begin VB.CheckBox chkReportFlg 
            Caption         =   "���̒��[��񍐏��Ƃ��Đݒ肷��(&H)"
            Height          =   315
            Left            =   240
            TabIndex        =   42
            Top             =   300
            Width           =   3015
         End
         Begin VB.Label Label1 
            Caption         =   "�\����(&J):"
            Height          =   180
            Index           =   15
            Left            =   240
            TabIndex        =   46
            ToolTipText     =   "�ʐڎx����ʂɂāA�\�����鏇�Ԃ��w�肵�܂�"
            Top             =   1080
            Width           =   870
         End
         Begin VB.Label LabelHistoryPrint 
            Caption         =   "�ߋ������(&O):"
            Height          =   180
            Left            =   3360
            TabIndex        =   43
            Top             =   360
            Width           =   1290
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "�o�͕��@"
         Height          =   795
         Index           =   3
         Left            =   180
         TabIndex        =   57
         Top             =   4320
         Width           =   3795
         Begin VB.OptionButton optPreView 
            Caption         =   "�v���r���[(&R)"
            Height          =   195
            Index           =   0
            Left            =   180
            TabIndex        =   14
            Top             =   360
            Value           =   -1  'True
            Width           =   1335
         End
         Begin VB.OptionButton optPreView 
            Caption         =   "���ڏo��(&D)"
            Height          =   195
            Index           =   1
            Left            =   2040
            TabIndex        =   15
            Top             =   360
            Width           =   1335
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "�o�͐�"
         Height          =   795
         Index           =   2
         Left            =   180
         TabIndex        =   56
         Top             =   3420
         Width           =   3795
         Begin VB.OptionButton optPrtMachine 
            Caption         =   "�u���E�U(&B)"
            Height          =   315
            Index           =   0
            Left            =   180
            TabIndex        =   12
            Top             =   300
            Value           =   -1  'True
            Width           =   1575
         End
         Begin VB.OptionButton optPrtMachine 
            Caption         =   "�T�[�o(&V)"
            Height          =   315
            Index           =   1
            Left            =   2040
            TabIndex        =   13
            Top             =   300
            Width           =   1575
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "�p���ݒ�"
         Height          =   1575
         Index           =   1
         Left            =   180
         TabIndex        =   55
         Top             =   1740
         Width           =   6615
         Begin VB.ComboBox cboPaperSize 
            Height          =   300
            ItemData        =   "frmReport.frx":0088
            Left            =   1860
            List            =   "frmReport.frx":00AA
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   5
            Top             =   300
            Width           =   1830
         End
         Begin VB.OptionButton optOrientation 
            Caption         =   "�w��Ȃ�(&E)"
            Height          =   255
            Index           =   0
            Left            =   1860
            TabIndex        =   7
            Top             =   720
            Value           =   -1  'True
            Width           =   1215
         End
         Begin VB.OptionButton optOrientation 
            Caption         =   "�c(&P)"
            Height          =   255
            Index           =   1
            Left            =   3300
            TabIndex        =   8
            Top             =   720
            Width           =   795
         End
         Begin VB.OptionButton optOrientation 
            Caption         =   "��(&L)"
            Height          =   255
            Index           =   2
            Left            =   4260
            TabIndex        =   9
            Top             =   720
            Width           =   795
         End
         Begin VB.ComboBox cboDefaultPrinter 
            Height          =   300
            ItemData        =   "frmReport.frx":00CC
            Left            =   1860
            List            =   "frmReport.frx":00EE
            TabIndex        =   11
            Text            =   "cboDefaultPrinter"
            Top             =   1080
            Width           =   4590
         End
         Begin VB.Label Label1 
            Caption         =   "�p���T�C�Y(&G)"
            Height          =   180
            Index           =   4
            Left            =   180
            TabIndex        =   4
            Top             =   360
            Width           =   1770
         End
         Begin VB.Label Label1 
            Caption         =   "����̌���:"
            Height          =   180
            Index           =   5
            Left            =   180
            TabIndex        =   6
            Top             =   780
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "�W���o�̓v�����^(&S):"
            Height          =   180
            Index           =   13
            Left            =   180
            TabIndex        =   10
            Top             =   1140
            Width           =   1590
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "��{���"
         Height          =   1095
         Index           =   0
         Left            =   180
         TabIndex        =   54
         Top             =   540
         Width           =   6615
         Begin VB.TextBox txtReportCd 
            Height          =   300
            IMEMode         =   3  '�̌Œ�
            Left            =   1320
            MaxLength       =   6
            TabIndex        =   1
            Text            =   "@@@@@@"
            Top             =   240
            Width           =   855
         End
         Begin VB.TextBox txtReportName 
            Height          =   300
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1320
            MaxLength       =   20
            TabIndex        =   3
            Text            =   "����������������������������������������"
            Top             =   600
            Width           =   3855
         End
         Begin VB.Label Label1 
            Caption         =   "���[�R�[�h(&C):"
            Height          =   180
            Index           =   0
            Left            =   180
            TabIndex        =   0
            Top             =   300
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "���[��(&N):"
            Height          =   180
            Index           =   2
            Left            =   180
            TabIndex        =   2
            Top             =   660
            Width           =   1590
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "���[�t�@�C���w��"
         Height          =   4635
         Index           =   5
         Left            =   -74820
         TabIndex        =   53
         Top             =   600
         Width           =   6615
         Begin VB.TextBox txtFedFile9 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   38
            Text            =   "Text1"
            Top             =   3720
            Width           =   3255
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   9
            Left            =   5220
            TabIndex        =   41
            Top             =   4080
            Width           =   1035
         End
         Begin VB.TextBox txtFedFile10 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   40
            Text            =   "Text1"
            Top             =   4080
            Width           =   3255
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   8
            Left            =   5220
            TabIndex        =   39
            Top             =   3720
            Width           =   1035
         End
         Begin VB.TextBox txtFedFile8 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   36
            Text            =   "Text1"
            Top             =   3360
            Width           =   3255
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   7
            Left            =   5220
            TabIndex        =   37
            Top             =   3360
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   6
            Left            =   5220
            TabIndex        =   35
            Top             =   3000
            Width           =   1035
         End
         Begin VB.TextBox txtFedFile7 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   34
            Text            =   "Text1"
            Top             =   3000
            Width           =   3255
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   5
            Left            =   5220
            TabIndex        =   33
            Top             =   2640
            Width           =   1035
         End
         Begin VB.TextBox txtFedFile6 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   32
            Text            =   "Text1"
            Top             =   2640
            Width           =   3255
         End
         Begin VB.TextBox txtFedFile5 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   30
            Text            =   "Text1"
            Top             =   2280
            Width           =   3255
         End
         Begin VB.TextBox txtFedFile4 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   27
            Text            =   "Text1"
            Top             =   1920
            Width           =   3255
         End
         Begin VB.TextBox txtFedFile3 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   24
            Text            =   "Text1"
            Top             =   1560
            Width           =   3255
         End
         Begin VB.TextBox txtFedFile2 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   21
            Text            =   "Text1"
            Top             =   1200
            Width           =   3255
         End
         Begin VB.TextBox txtFedFile 
            Height          =   330
            Left            =   1860
            MaxLength       =   40
            TabIndex        =   18
            Text            =   "Text1"
            Top             =   840
            Width           =   3255
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   0
            Left            =   5220
            TabIndex        =   19
            Top             =   840
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   1
            Left            =   5220
            TabIndex        =   22
            Top             =   1200
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   2
            Left            =   5220
            TabIndex        =   25
            Top             =   1560
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   3
            Left            =   5220
            TabIndex        =   28
            Top             =   1920
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "�Q��..."
            Height          =   315
            Index           =   4
            Left            =   5220
            TabIndex        =   31
            Top             =   2280
            Width           =   1035
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����X(&9):"
            Height          =   240
            Index           =   14
            Left            =   180
            TabIndex        =   67
            Top             =   3780
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����P�O(&10):"
            Height          =   240
            Index           =   7
            Left            =   180
            TabIndex        =   66
            Top             =   4140
            Width           =   1635
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����W(&8):"
            Height          =   240
            Index           =   6
            Left            =   180
            TabIndex        =   65
            Top             =   3420
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����V(&7):"
            Height          =   240
            Index           =   3
            Left            =   180
            TabIndex        =   64
            Top             =   3060
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����U(&6):"
            Height          =   240
            Index           =   1
            Left            =   180
            TabIndex        =   63
            Top             =   2700
            Width           =   1410
         End
         Begin VB.Label Label5 
            Caption         =   "CoReports�t�H�[���t�@�C�����w�肵�܂��B"
            Height          =   255
            Index           =   1
            Left            =   180
            TabIndex        =   61
            Top             =   420
            Width           =   3555
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����T(&5):"
            Height          =   240
            Index           =   12
            Left            =   180
            TabIndex        =   29
            Top             =   2340
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����S(&4):"
            Height          =   240
            Index           =   11
            Left            =   180
            TabIndex        =   26
            Top             =   1980
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����R(&3):"
            Height          =   240
            Index           =   10
            Left            =   180
            TabIndex        =   23
            Top             =   1620
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����Q(&2):"
            Height          =   240
            Index           =   9
            Left            =   180
            TabIndex        =   20
            Top             =   1260
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "���[�t�@�C�����P(&1):"
            Height          =   240
            Index           =   8
            Left            =   180
            TabIndex        =   17
            Top             =   900
            Width           =   1410
         End
      End
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(&A)"
      Height          =   315
      Left            =   5820
      TabIndex        =   50
      Top             =   7860
      Width           =   1275
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   5460
      Top             =   180
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2940
      TabIndex        =   48
      Top             =   7860
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4380
      TabIndex        =   49
      Top             =   7860
      Width           =   1335
   End
   Begin VB.Label Label5 
      Caption         =   "������钠�[�̐ݒ���s���܂��B"
      Height          =   255
      Index           =   0
      Left            =   780
      TabIndex        =   51
      Top             =   300
      Width           =   4275
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   4
      Left            =   180
      Picture         =   "frmReport.frx":0110
      Top             =   180
      Width           =   480
   End
End
Attribute VB_Name = "frmReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'�C������
'----------------------------
'�Ǘ��ԍ�: SL-UI-Y0101-116
'�C����  �F2010.06.17
'�S����  �FTCS)�c��
'�C�����e: ���[�t�@�C���W�`�P�O��ǉ�

Option Explicit

Private mstrReportCd            As String       '���[�R�[�h
Private mblnInitialize          As Boolean      'TRUE:����ɏ������AFALSE:���������s
Private mblnUpdated             As Boolean      'TRUE:�X�V����AFALSE:�X�V�Ȃ�

Private mstrPaperSize()         As String       '�p���T�C�Y
Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

Friend Property Let ReportCd(ByVal vntNewValue As Variant)

    mstrReportCd = vntNewValue
    
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
        If Trim(txtReportCd.Text) = "" Then
            MsgBox "���[�R�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtReportCd.SetFocus
            Exit Do
        End If

        '���[���̓��̓`�F�b�N
        If Trim(txtReportName.Text) = "" Then
            MsgBox "���[�������͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtReportName.SetFocus
            Exit Do
        End If

        '��������̓��̓`�F�b�N
        If Trim(txtCopyCount.Text) = "" Then
            txtCopyCount.Text = 1
        End If
        
        If IsNumeric(txtCopyCount.Text) = False Then
            MsgBox "��������ɂ͐��l�i�Q���j����͂��Ă��������B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCopyCount.SetFocus
            Exit Do
        End If
        
        If CInt(txtCopyCount.Text) < 1 Then
            MsgBox "�����͂P�ȏ��ݒ肵�Ă��������B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCopyCount.SetFocus
            Exit Do
        End If

        '���[�t�@�C�����̓��̓`�F�b�N
        If Trim(txtFedFile.Text) = "" Then
            MsgBox "���[�t�@�C�����P�͕K�{���͂ł��B", vbExclamation, App.Title
            tabMain.Tab = 1
            txtFedFile.SetFocus
            Exit Do
        End If

'2002.11.10�@�����ă`�F�b�N���͂����Ɖ����Ɏg����悤�ȁE�E�E
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT �J���e�t���O�̒ǉ�
'        If (chkReportFlg = vbChecked) And (chkKarteFlg = vbChecked) Then
'            MsgBox "�񍐏��ł���A�J���e�ł���悤�Ȓ��[�͐ݒ�ł��܂���B", vbExclamation, App.Title
'            tabMain.Tab = 1
'            chkReportFlg.SetFocus
'            Exit Do
'        End If
'## 2002.11.10 Add End
        
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
        '���蕪�ޕ\�����̐��l�`�F�b�N
        If Trim(txtViewOrder.Text) <> "" Then
        
            If IsNumeric(Trim(txtViewOrder.Text)) = False Then
                MsgBox "�\�����͐��l�œ��͂��Ă��������B", vbCritical, App.Title
                txtViewOrder.SetFocus
                Exit Do
            End If
        
            If CLng(Trim(txtViewOrder.Text)) < 0 Then
                MsgBox "�\�����ɂ͕������w�肷�邱�Ƃ͂ł��܂���B", vbCritical, App.Title
                txtViewOrder.SetFocus
                Exit Do
            End If
        
        End If
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####

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
Private Function EditReport() As Boolean

    Dim objReport           As Object   '���[�A�N�Z�X�p
    Dim vntReportName       As Variant  '�񍐏��p���[��
    Dim vntPaperSize        As Variant  '�p���T�C�Y
    Dim vntOrientation      As Variant  '
    Dim vntDefaultPrinter   As Variant  '
    Dim vntPrtMachine       As Variant  '
    Dim vntPreView          As Variant
    Dim vntFedFile          As Variant
    Dim vntCopyCount        As Variant
    Dim vntFedFile2         As Variant
    Dim vntFedFile3         As Variant
    Dim vntFedFile4         As Variant
    Dim vntFedFile5         As Variant
    
'## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jStart
    Dim vntFedFile6         As Variant
    Dim vntFedFile7         As Variant
'## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jEnd
'#### 2010.06.17 SL-UI-Y0101-116 ADD START ####'
    Dim vntFedFile8         As Variant
    Dim vntFedFile9         As Variant
    Dim vntFedFile10        As Variant
'#### 2010.06.17 SL-UI-Y0101-116 ADD END ####'
    
    Dim vntReportFlg        As Variant
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT �J���e�t���O�̒ǉ�
    Dim vntKarteFlg         As Variant
'## 2002.11.10 Add End
    Dim vntHistoryPrint     As Variant
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    Dim vntViewOrder        As Variant  '�\����
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
    Dim i                   As Integer
    
    Dim Ret                 As Boolean  '�߂�l
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objReport = CreateObject("HainsReport.Report")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrReportCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '���[�e�[�u�����R�[�h�ǂݍ���
'#### 2010.06.17 SL-UI-Y0101-116 MOD START ####'
''''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT �J���e�t���O�̒ǉ�
''''        If objReport.SelectReport(mstrReportCd, _
'''                                  vntReportName, _
'''                                  vntPaperSize, _
'''                                  vntOrientation, _
'''                                  vntDefaultPrinter, _
'''                                  vntPrtMachine, _
'''                                  vntPreView, _
'''                                  vntFedFile, _
'''                                  vntCopyCount, _
'''                                  vntFedFile2, _
'''                                  vntFedFile3, _
'''                                  vntFedFile4, _
'''                                  vntFedFile5, _
'''                                  vntReportFlg, _
'''                                  vntHistoryPrint) = False Then
'''    '## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jStart
''''        If objReport.SelectReport(mstrReportCd, _
''''                                  vntReportName, _
''''                                  vntPaperSize, _
''''                                  vntOrientation, _
''''                                  vntDefaultPrinter, _
''''                                  vntPrtMachine, _
''''                                  vntPreView, _
''''                                  vntFedFile, _
''''                                  vntCopyCount, _
''''                                  vntFedFile2, _
''''                                  vntFedFile3, _
''''                                  vntFedFile4, _
''''                                  vntFedFile5, _
''''                                  vntReportFlg, _
''''                                  vntHistoryPrint, _
''''                                  vntKarteFlg) = False Then
'''
'''        If objReport.SelectReport(mstrReportCd, _
'''                                  vntReportName, _
'''                                  vntPaperSize, _
'''                                  vntOrientation, _
'''                                  vntDefaultPrinter, _
'''                                  vntPrtMachine, _
'''                                  vntPreView, _
'''                                  vntFedFile, _
'''                                  vntCopyCount, _
'''                                  vntFedFile2, _
'''                                  vntFedFile3, _
'''                                  vntFedFile4, _
'''                                  vntFedFile5, _
'''                                  vntFedFile6, _
'''                                  vntFedFile7, _
'''                                  vntReportFlg, _
'''                                  vntHistoryPrint, _
'''                                  vntKarteFlg) = False Then
'''    '## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jEnd
''''## 2002.11.10 Mod End
        
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'        If objReport.SelectReport(mstrReportCd _
'                                , vntReportName _
'                                , vntPaperSize _
'                                , vntOrientation _
'                                , vntDefaultPrinter _
'                                , vntPrtMachine _
'                                , vntPreView _
'                                , vntFedFile _
'                                , vntCopyCount _
'                                , vntFedFile2 _
'                                , vntFedFile3 _
'                                , vntFedFile4 _
'                                , vntFedFile5 _
'                                , vntFedFile6 _
'                                , vntFedFile7 _
'                                , vntReportFlg _
'                                , vntHistoryPrint _
'                                , vntKarteFlg _
'                                , vntFedFile8 _
'                                , vntFedFile9 _
'                                , vntFedFile10 _
'                                ) = False Then
        If objReport.SelectReport(mstrReportCd _
                                , vntReportName _
                                , vntPaperSize _
                                , vntOrientation _
                                , vntDefaultPrinter _
                                , vntPrtMachine _
                                , vntPreView _
                                , vntFedFile _
                                , vntCopyCount _
                                , vntFedFile2 _
                                , vntFedFile3 _
                                , vntFedFile4 _
                                , vntFedFile5 _
                                , vntFedFile6 _
                                , vntFedFile7 _
                                , vntReportFlg _
                                , vntHistoryPrint _
                                , vntKarteFlg _
                                , vntFedFile8 _
                                , vntFedFile9 _
                                , vntFedFile10 _
                                , vntViewOrder _
                                ) = False Then
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
'#### 2010.06.17 SL-UI-Y0101-116 MOD END ####'

            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If
    
        '�ǂݍ��ݓ��e�̕ҏW
        txtReportCd.Text = mstrReportCd
        txtReportName.Text = vntReportName
'        txtPaperSize.Text = vntPaperSize       '�Ȃɐݒ肷��́H
        If IsNumeric(vntOrientation) Then
            If (vntOrientation = "1") Or (vntOrientation = "2") Then
                optOrientation(CInt(vntOrientation)).Value = True
            End If
        End If
        cboDefaultPrinter.Text = vntDefaultPrinter
        optPrtMachine(CInt(vntPrtMachine)).Value = True
        optPreView(CInt(vntPreView)).Value = True
        cboHistoryPrint.ListIndex = CInt(vntHistoryPrint)
        If vntReportFlg = "1" Then
            chkReportFlg.Value = vbChecked
        Else
            chkReportFlg.Value = vbUnchecked
        End If
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT �J���e�t���O�̒ǉ�
        If vntKarteFlg = "1" Then
            chkKarteFlg.Value = vbChecked
        Else
            chkKarteFlg.Value = vbUnchecked
        End If
'## 2002.11.10 Add End
        txtCopyCount.Text = vntCopyCount
        txtFedFile.Text = vntFedFile
        txtFedFile2.Text = vntFedFile2
        txtFedFile3.Text = vntFedFile3
        txtFedFile4.Text = vntFedFile4
        txtFedFile5.Text = vntFedFile5
'## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jStart
        txtFedFile6.Text = vntFedFile6
        txtFedFile7.Text = vntFedFile7
'## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jEnd
'#### 2010.06.17 SL-UI-Y0101-116 ADD START ####'
        txtFedFile8.Text = vntFedFile8
        txtFedFile9.Text = vntFedFile9
        txtFedFile10.Text = vntFedFile10
'#### 2010.06.17 SL-UI-Y0101-116 ADD END ####'
    
        For i = 0 To UBound(mstrPaperSize)
            If mstrPaperSize(i) = vntPaperSize Then
                cboPaperSize.ListIndex = i
                Exit For
            End If
        Next i
    
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
        txtViewOrder.Text = vntViewOrder
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditReport = Ret
    
    Exit Function

ErrorHandle:

    EditReport = False
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
Private Function RegistReport() As Boolean

On Error GoTo ErrorHandle

    Dim objReport           As Object       '���[�A�N�Z�X�p
    Dim Ret                 As Long
    Dim strOrientation      As String
    
    Select Case True
        Case optOrientation(1).Value
            strOrientation = "1"
        Case optOrientation(2).Value
            strOrientation = "2"
        Case Else
            strOrientation = ""
    End Select
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objReport = CreateObject("HainsReport.Report")
    
    '���[�e�[�u�����R�[�h�̓o�^
'#### 2010.06.17 SL-UI-Y0101-116 MOD START ####'
''''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT �J���e�t���O�̒ǉ�
''''    Ret = objReport.RegistReport(IIf(txtReportCd.Enabled, "INS", "UPD"), _
'''                                 Trim(txtReportCd.Text), _
'''                                 Trim(txtReportName.Text), _
'''                                 mstrPaperSize(cboPaperSize.ListIndex), _
'''                                 strOrientation, _
'''                                 Trim(cboDefaultPrinter.Text), _
'''                                 IIf(optPrtMachine(0).Value = True, 0, 1), _
'''                                 IIf(optPreView(0).Value = True, 0, 1), _
'''                                 IIf(chkReportFlg.Value = vbUnchecked, 0, 1), _
'''                                 cboHistoryPrint.ListIndex, _
'''                                 Trim(txtCopyCount.Text), _
'''                                 Trim(txtFedFile.Text), _
'''                                 Trim(txtFedFile2.Text), _
'''                                 Trim(txtFedFile3.Text), _
'''                                 Trim(txtFedFile4.Text), _
'''                                 Trim(txtFedFile5.Text))
''''    Ret = objReport.RegistReport(IIf(txtReportCd.Enabled, "INS", "UPD"), _
''''                                 Trim(txtReportCd.Text), _
''''                                 Trim(txtReportName.Text), _
''''                                 mstrPaperSize(cboPaperSize.ListIndex), _
''''                                 strOrientation, _
''''                                 Trim(cboDefaultPrinter.Text), _
''''                                 IIf(optPrtMachine(0).Value = True, 0, 1), _
''''                                 IIf(optPreView(0).Value = True, 0, 1), _
''''                                 IIf(chkReportFlg.Value = vbUnchecked, 0, 1), _
''''                                 IIf(chkKarteFlg.Value = vbUnchecked, 0, 1), _
''''                                 cboHistoryPrint.ListIndex, _
''''                                 Trim(txtCopyCount.Text), _
''''                                 Trim(txtFedFile.Text), _
''''                                 Trim(txtFedFile2.Text), _
''''                                 Trim(txtFedFile3.Text), _
''''                                 Trim(txtFedFile4.Text), _
''''                                 Trim(txtFedFile5.Text))
'''
'''    '## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jStart
'''    Ret = objReport.RegistReport(IIf(txtReportCd.Enabled, "INS", "UPD"), _
'''                                 Trim(txtReportCd.Text), _
'''                                 Trim(txtReportName.Text), _
'''                                 mstrPaperSize(cboPaperSize.ListIndex), _
'''                                 strOrientation, _
'''                                 Trim(cboDefaultPrinter.Text), _
'''                                 IIf(optPrtMachine(0).Value = True, 0, 1), _
'''                                 IIf(optPreView(0).Value = True, 0, 1), _
'''                                 IIf(chkReportFlg.Value = vbUnchecked, 0, 1), _
'''                                 IIf(chkKarteFlg.Value = vbUnchecked, 0, 1), _
'''                                 cboHistoryPrint.ListIndex, _
'''                                 Trim(txtCopyCount.Text), _
'''                                 Trim(txtFedFile.Text), _
'''                                 Trim(txtFedFile2.Text), _
'''                                 Trim(txtFedFile3.Text), _
'''                                 Trim(txtFedFile4.Text), _
'''                                 Trim(txtFedFile5.Text), _
'''                                 Trim(txtFedFile6.Text), _
'''                                 Trim(txtFedFile7.Text))
'''    '## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jEnd
''''## 2002.11.10 Mod End
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'    Ret = objReport.RegistReport(IIf(txtReportCd.Enabled, "INS", "UPD") _
'                               , Trim(txtReportCd.Text) _
'                               , Trim(txtReportName.Text) _
'                               , mstrPaperSize(cboPaperSize.ListIndex) _
'                               , strOrientation _
'                               , Trim(cboDefaultPrinter.Text) _
'                               , IIf(optPrtMachine(0).Value = True, 0, 1) _
'                               , IIf(optPreView(0).Value = True, 0, 1) _
'                               , IIf(chkReportFlg.Value = vbUnchecked, 0, 1) _
'                               , IIf(chkKarteFlg.Value = vbUnchecked, 0, 1) _
'                               , cboHistoryPrint.ListIndex _
'                               , Trim(txtCopyCount.Text) _
'                               , Trim(txtFedFile.Text) _
'                               , Trim(txtFedFile2.Text) _
'                               , Trim(txtFedFile3.Text) _
'                               , Trim(txtFedFile4.Text) _
'                               , Trim(txtFedFile5.Text) _
'                               , Trim(txtFedFile6.Text) _
'                               , Trim(txtFedFile7.Text) _
'                               , Trim(txtFedFile8.Text) _
'                               , Trim(txtFedFile9.Text) _
'                               , Trim(txtFedFile10.Text) _
'                                 )
    Ret = objReport.RegistReport(IIf(txtReportCd.Enabled, "INS", "UPD") _
                               , Trim(txtReportCd.Text) _
                               , Trim(txtReportName.Text) _
                               , mstrPaperSize(cboPaperSize.ListIndex) _
                               , strOrientation _
                               , Trim(cboDefaultPrinter.Text) _
                               , IIf(optPrtMachine(0).Value = True, 0, 1) _
                               , IIf(optPreView(0).Value = True, 0, 1) _
                               , IIf(chkReportFlg.Value = vbUnchecked, 0, 1) _
                               , IIf(chkKarteFlg.Value = vbUnchecked, 0, 1) _
                               , cboHistoryPrint.ListIndex _
                               , Trim(txtCopyCount.Text) _
                               , Trim(txtFedFile.Text) _
                               , Trim(txtFedFile2.Text) _
                               , Trim(txtFedFile3.Text) _
                               , Trim(txtFedFile4.Text) _
                               , Trim(txtFedFile5.Text) _
                               , Trim(txtFedFile6.Text) _
                               , Trim(txtFedFile7.Text) _
                               , Trim(txtFedFile8.Text) _
                               , Trim(txtFedFile9.Text) _
                               , Trim(txtFedFile10.Text) _
                               , Trim(txtViewOrder.Text) _
                                 )
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
'#### 2010.06.17 SL-UI-Y0101-116 MOD END ####'


    If Ret = 0 Then
        MsgBox "���͂��ꂽ���[�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        RegistReport = False
        Exit Function
    End If
    
    RegistReport = True
    
    Exit Function
    
ErrorHandle:

    RegistReport = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub chkReportFlg_Click()

    If chkReportFlg.Value = vbChecked Then
        cboHistoryPrint.Enabled = True
        LabelHistoryPrint.ForeColor = vbButtonText
    Else
        cboHistoryPrint.ListIndex = 0
        cboHistoryPrint.Enabled = False
        LabelHistoryPrint.ForeColor = vbGrayText
    End If
    
End Sub

Private Sub cmdApply_Click()
    
    '�f�[�^�K�p�������s��
    If ApplyData() = True Then
        MsgBox "���͓��e��ۑ����܂����B", vbInformation
    End If

End Sub

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
    
    '�f�[�^�K�p�������s��
    If ApplyData() = False Then Exit Sub

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
        
        '���[�e�[�u���̓o�^
        If RegistReport() = False Then
            Exit Do
        End If

        '�X�V�ς݃t���O��TRUE��
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault

End Function

Private Sub cmdSearchFile_Click(Index As Integer)

    Dim strFileName     As String
    Dim strPath         As String
    
    With CommonDialog1
        .DialogTitle = "CoReports��`�t�@�C����I�����Ă��������B"
        .InitDir = "D:\webHains\wwwRoot\Reports\"
        .Filter = "CoReports�t�H�[���t�@�C��(*.crf)|*.crf|���ׂẴt�@�C��(*.*)|*.*|"
        .ShowOpen
        strFileName = .FileTitle
    End With

    '�t�@�C���w��Ȃ��Ȃ珈���I��
    If strFileName = "" Then Exit Sub
    
    '�t�@�C�����Z�b�g
    Select Case Index
        Case 0
            txtFedFile.Text = strFileName
        Case 1
            txtFedFile2.Text = strFileName
        Case 2
            txtFedFile3.Text = strFileName
        Case 3
            txtFedFile4.Text = strFileName
        Case 4
            txtFedFile5.Text = strFileName
    '## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jStart
        Case 5
            txtFedFile6.Text = strFileName
        Case 6
            txtFedFile7.Text = strFileName
    '## 2008.02.08 �� ���[�t�@�C���V��ǉ��̂��ߏC���i�������[�t�@�C���U���ɂ��Ă��Ή��jEnd
'#### 2010.06.17 SL-UI-Y0101-116 ADD START ####'
        Case 7
            txtFedFile8.Text = strFileName
        Case 8
            txtFedFile9.Text = strFileName
        Case 9
            txtFedFile10.Text = strFileName
'#### 2010.06.17 SL-UI-Y0101-116 ADD END ####'
    
    End Select
        
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

    Dim Ret             As Boolean  '�߂�l
    Dim objPrinter      As Printer
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '��������
    Ret = False
    mblnUpdated = False
    
    '��ʏ�����
    Call InitFormControls(Me, mcolGotFocusCollection)

    '�ߋ������
    With cboHistoryPrint
        .Clear
        .AddItem "�S��"
        .AddItem "�Č���������"
        .AddItem "����R�[�X�̂�"
'### 2003.02.23 Added by Ishihara@FSIT ������N�f�f�ǉ�
        .AddItem "������f�̂�"
'### 2003.02.23 Added End
        .ListIndex = 0
    End With
    Call chkReportFlg_Click
    
    '�p���T�C�Y
    ReDim Preserve mstrPaperSize(6)
    mstrPaperSize(0) = ""
    cboPaperSize.AddItem ""
    
    mstrPaperSize(1) = "8"
    cboPaperSize.AddItem "A3"
    mstrPaperSize(2) = "9"
    cboPaperSize.AddItem "A4"
    mstrPaperSize(3) = "11"
    cboPaperSize.AddItem "A5"
    mstrPaperSize(4) = "12"
    cboPaperSize.AddItem "B4"
    mstrPaperSize(5) = "13"
    cboPaperSize.AddItem "B5"
    mstrPaperSize(6) = "43"
    cboPaperSize.AddItem "�͂���"
    
    cboPaperSize.ListIndex = 0
    
    '�o�̓v�����^
    With cboDefaultPrinter
        .Clear
        For Each objPrinter In Printers
            .AddItem objPrinter.DeviceName
        Next
    End With

    Do
        '���[���̕ҏW
        If EditReport() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtReportCd.Enabled = (txtReportCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    tabMain.Tab = 0

    'Enabled����̂��߂P�x�Ăяo��
    Call tabMain_Click(0)

    '�߂�l�̐ݒ�
    mblnInitialize = Ret
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub optPrtMachine_Click(Index As Integer)

    '�T�[�o�ň����ݒ肳�ꂽ�ꍇ�́A�o�͕��@�𐧌�
    If Index = 1 Then
        optPreView(1).Value = True
        optPreView(0).Enabled = False
    Else
        optPreView(0).Enabled = True
    End If
    
End Sub

' @(e)
'
' �@�\�@�@ : �u�^�u�vClick
'
' �@�\���� : ��\���^�u���R���g���[�����g�p�s�ɂ���iFocus�����ł��܂����߁j
'
' ���l�@�@ :
'
Private Sub tabMain_Click(PreviousTab As Integer)

    Dim i   As Integer
    
    For i = 0 To 6
        fraMain(i).Enabled = False
    Next i
    
    If tabMain.Tab = 0 Then
        For i = 0 To 4
            fraMain(i).Enabled = True
        Next i
    
    Else
        For i = 5 To 6
            fraMain(i).Enabled = True
        Next i
    
    End If
    
End Sub

