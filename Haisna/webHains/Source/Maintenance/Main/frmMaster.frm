VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmMaster 
   AutoRedraw      =   -1  'True
   Caption         =   "webH@ins �V�X�e�����ݒ�"
   ClientHeight    =   7050
   ClientLeft      =   2280
   ClientTop       =   3165
   ClientWidth     =   9855
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMaster.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   7050
   ScaleWidth      =   9855
   Begin MSComctlLib.Toolbar tlbMain 
      Align           =   1  '�㑵��
      Height          =   360
      Left            =   0
      TabIndex        =   8
      Top             =   0
      Width           =   9855
      _ExtentX        =   17383
      _ExtentY        =   635
      ButtonWidth     =   1640
      ButtonHeight    =   582
      Appearance      =   1
      Style           =   1
      TextAlignment   =   1
      ImageList       =   "imlToolbarIcons"
      _Version        =   393216
      BeginProperty Buttons {66833FE8-8583-11D1-B16A-00C0F0283628} 
         NumButtons      =   2
         BeginProperty Button1 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "����"
            Key             =   "Search"
            ImageIndex      =   5
            Style           =   2
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "�t�H���_"
            Key             =   "Folder"
            ImageIndex      =   1
            Style           =   2
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picSplitter 
      BackColor       =   &H00808080&
      BorderStyle     =   0  '�Ȃ�
      FillColor       =   &H00808080&
      BeginProperty Font 
         Name            =   "�l�r �o�S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   4800
      Left            =   5135
      ScaleHeight     =   2090.126
      ScaleMode       =   0  'հ�ް
      ScaleWidth      =   520
      TabIndex        =   6
      Top             =   676
      Visible         =   0   'False
      Width           =   52
   End
   Begin VB.PictureBox picTitles 
      Align           =   1  '�㑵��
      Appearance      =   0  '�ׯ�
      BorderStyle     =   0  '�Ȃ�
      BeginProperty Font 
         Name            =   "�l�r �o�S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   300
      Left            =   0
      ScaleHeight     =   300
      ScaleWidth      =   9855
      TabIndex        =   2
      TabStop         =   0   'False
      Top             =   360
      Width           =   9855
      Begin VB.Label lblTitle 
         BorderStyle     =   1  '����
         Caption         =   " �t�H���_"
         Height          =   270
         Index           =   0
         Left            =   0
         TabIndex        =   3
         Tag             =   " �ذ �ޭ�:"
         Top             =   12
         Width           =   2016
      End
      Begin VB.Label lblTitle 
         BorderStyle     =   1  '����
         Caption         =   " �f�[�^"
         Height          =   270
         Index           =   1
         Left            =   2078
         TabIndex        =   4
         Tag             =   " ؽ� �ޭ�:"
         Top             =   12
         Width           =   3216
      End
   End
   Begin MSComctlLib.StatusBar stbMain 
      Align           =   2  '������
      Height          =   270
      Left            =   0
      TabIndex        =   1
      Top             =   6780
      Width           =   9855
      _ExtentX        =   17383
      _ExtentY        =   476
      _Version        =   393216
      BeginProperty Panels {8E3867A5-8586-11D1-B16A-00C0F0283628} 
         NumPanels       =   3
         BeginProperty Panel1 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            AutoSize        =   1
            Object.Width           =   11748
         EndProperty
         BeginProperty Panel2 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   6
            AutoSize        =   2
            TextSave        =   "2013/04/01"
         EndProperty
         BeginProperty Panel3 {8E3867AB-8586-11D1-B16A-00C0F0283628} 
            Style           =   5
            AutoSize        =   2
            TextSave        =   "10:29"
         EndProperty
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin MSComDlg.CommonDialog dlgCommonDialog 
      Left            =   8880
      Top             =   840
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin MSComctlLib.ListView lsvView 
      Height          =   4797
      Left            =   2054
      TabIndex        =   5
      Top             =   650
      Width           =   3211
      _ExtentX        =   5662
      _ExtentY        =   8467
      View            =   3
      LabelEdit       =   1
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      Icons           =   "imlToolbarIcons"
      SmallIcons      =   "imlToolbarIcons"
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      NumItems        =   0
   End
   Begin VB.Frame fraSearch 
      BackColor       =   &H00FFFFFF&
      Height          =   4875
      Left            =   5880
      TabIndex        =   7
      Top             =   2100
      Visible         =   0   'False
      Width           =   3975
      Begin VB.CommandButton cmdSearchStart 
         Caption         =   "�����J�n(&S)"
         Default         =   -1  'True
         Height          =   315
         Left            =   180
         TabIndex        =   15
         Top             =   3300
         Width           =   1395
      End
      Begin VB.ComboBox cboTableName 
         Height          =   300
         Left            =   180
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   14
         Top             =   2700
         Width           =   3555
      End
      Begin VB.TextBox txtSearchString 
         Height          =   315
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   180
         TabIndex        =   12
         Text            =   "Text1"
         Top             =   1980
         Width           =   3555
      End
      Begin VB.TextBox txtSearchCode 
         Height          =   315
         IMEMode         =   3  '�̌Œ�
         Left            =   180
         TabIndex        =   10
         Text            =   "Text1"
         Top             =   1260
         Width           =   3555
      End
      Begin VB.Line Line1 
         BorderColor     =   &H8000000A&
         BorderStyle     =   6  '���� (�ӂ��ǂ�)
         BorderWidth     =   2
         X1              =   180
         X2              =   3540
         Y1              =   660
         Y2              =   660
      End
      Begin VB.Label Label1 
         BackStyle       =   0  '����
         Caption         =   "�f�[�^�̌���"
         Height          =   255
         Index           =   3
         Left            =   600
         TabIndex        =   16
         Top             =   300
         Width           =   2175
      End
      Begin VB.Image Image1 
         Height          =   300
         Index           =   4
         Left            =   120
         Picture         =   "frmMaster.frx":0442
         Top             =   240
         Width           =   330
      End
      Begin VB.Label Label1 
         BackStyle       =   0  '����
         Caption         =   "�T���ꏊ(&L):"
         Height          =   195
         Index           =   2
         Left            =   180
         TabIndex        =   13
         Top             =   2460
         Width           =   2175
      End
      Begin VB.Label Label1 
         BackStyle       =   0  '����
         Caption         =   "���̂Ɋ܂܂�镶����(&M):"
         Height          =   255
         Index           =   1
         Left            =   180
         TabIndex        =   11
         Top             =   1740
         Width           =   2175
      End
      Begin VB.Label Label1 
         BackStyle       =   0  '����
         Caption         =   "�ݒ肵���R�[�h(&C):"
         Height          =   255
         Index           =   0
         Left            =   180
         TabIndex        =   9
         Top             =   1020
         Width           =   2175
      End
   End
   Begin MSComctlLib.TreeView trvMaster 
      Height          =   4797
      Left            =   0
      TabIndex        =   0
      Top             =   702
      Width           =   2041
      _ExtentX        =   3598
      _ExtentY        =   8440
      _Version        =   393217
      Indentation     =   353
      LabelEdit       =   1
      LineStyle       =   1
      Style           =   7
      FullRowSelect   =   -1  'True
      ImageList       =   "imlToolbarIcons"
      Appearance      =   1
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   8000
      Top             =   1000
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   6
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMaster.frx":060C
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMaster.frx":0766
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMaster.frx":08C0
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMaster.frx":0A1A
            Key             =   "DEFAULTLIST"
         EndProperty
         BeginProperty ListImage5 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMaster.frx":0B74
            Key             =   "SEARCH"
         EndProperty
         BeginProperty ListImage6 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmMaster.frx":0CCE
            Key             =   "SECURITY"
         EndProperty
      EndProperty
   End
   Begin VB.Image imgSplitter 
      Height          =   4784
      Left            =   1963
      MousePointer    =   9  '����(���E)
      Top             =   702
      Width           =   52
   End
   Begin VB.Menu mnuFile 
      Caption         =   "�t�@�C��(&F)"
      Begin VB.Menu mnuFileNew 
         Caption         =   "�V�K�쐬(&N)..."
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuFileBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileOpen 
         Caption         =   "�J��(&O)..."
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuFileBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileQuit 
         Caption         =   "�I��(&X)"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "�\��(&V)"
      Begin VB.Menu mnuViewFolder 
         Caption         =   "�t�H���_(&O)"
         Checked         =   -1  'True
         Shortcut        =   ^D
      End
      Begin VB.Menu mnuViewSearch 
         Caption         =   "����(&F)"
         Shortcut        =   ^F
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "�ҏW(&E)"
      Begin VB.Menu mnuEditDelete 
         Caption         =   "�폜(&D)"
      End
   End
   Begin VB.Menu mnuOption 
      Caption         =   "��߼��(&O)"
      Begin VB.Menu mnuOptionMch 
         Caption         =   "MCH�a���A�g(&B)"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "�w���v(&H)"
      Begin VB.Menu mnyHelpVersion 
         Caption         =   "�o�[�W�������(&A)"
      End
   End
   Begin VB.Menu mnuPopUp 
      Caption         =   "�|�b�v�A�b�v"
      Visible         =   0   'False
      Begin VB.Menu mnuPopUpUpdate 
         Caption         =   "�J��(&R)"
      End
      Begin VB.Menu mnuPopUpBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuPopUpNew 
         Caption         =   "�V�K�쐬(&W)"
      End
      Begin VB.Menu mnuPopUpBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuPopUpDelete 
         Caption         =   "�폜(&D)"
      End
   End
End
Attribute VB_Name = "frmMaster"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================
'�Ǘ��ԍ��FSL-HS-Y0101-001
'���۔ԍ��FCOMP-LUKES-0018�i��݊����؁j
'�C����  �F2010.07.16
'�S����  �FFJTH)KOMURO
'�C�����e�F����e�[�u�����C�A�E�g�Ƃ̓���
'========================================
'========================================
'�Ǘ��ԍ��FSL-HS-Y0101-001
'���۔ԍ��FCOMP-LUKES-0029�i��݊����؁j
'�C����  �F2010.07.16
'�S����  �FFJTH)KOMURO
'�C�����e�F�\�����̂̏C��
'========================================
'========================================
'�Ǘ��ԍ��FSL-SN-Y0101-612
'�C�����@�F2013.3.4
'�S����  �FT.Takagi@RD
'�C�����e�F�\��m�F���[�����M�@�\�ǉ�
'========================================
Option Explicit

Private mcolGotFocusCollection      As Collection               'GotFocus���̕����I��p�R���N�V����

Private mstrNodeKey                 As String                   'KeyDown,MouseDown���_�őI�𒆂̃m�[�h�L�[
Private mblnComAccess               As Boolean                  'TRUE=COM+�A�N�Z�X�ς݁ACOM+���A�N�Z�X
Private mstrNowSearchTable          As String                   '�����Ώۃe�[�u��

Private PV_MovingFlg                As Boolean                  ''�ړ����t���O

Private Const SGLSPLITLIMIT         As Integer = 500            '�X�v���b�^�[�̌��E�l

Private Const ICON_CLOSED           As String = "CLOSED"        '�����t�H���_
Private Const ICON_OPEN             As String = "OPEN"          '�J�����t�H���_
Private Const ICON_MYCOMPUTER       As String = "MYCOMP"        '�}�C�R���s���[�^
Private Const ICON_DEFAULTLIST      As String = "DEFAULTLIST"   '���X�g�r���[�p�̕W���A�C�R��
Private Const ICON_SEARCH           As String = "SEARCH"        '����

'## 2005.03.23  Add by ��
Private Const SECURITY              As String = "SECURITY"      '�����Ǘ�
'## 2005.03.23  Add by End ..

Private Const NODE_ROOT             As String = "ROOT"          '���[�g�̃L�[�l
Private Const NODE_SEARCH           As String = "SEARCH"        '�������ʂ̃L�[�l
Private Const NODE_TYPEFOLDER       As String = "FOLDER"        '�t�H���_�^�C�v�̃m�[�h
Private Const KEY_PREFIX            As String = "KEY"           '���X�g�r���[�p�L�[�l
Private Const KEY_SEPARATE          As String = "-"             '���X�g�r���[�p�L�[�l�i�������ڂ̌����L�[�Ɏg�p�j

Private Const BUTTON_KEY_SEARCH     As String = "Search"        '����
Private Const BUTTON_KEY_FOLDER     As String = "Folder"        '����

Private Const TABLE_ITEMCLASS       As String = "ITEMCLASS"     '��������
Private Const TABLE_PROGRESS        As String = "PROGRESS"      '�i���Ǘ��p����
Private Const TABLE_OPECLASS        As String = "OPECLASS"      '�������{������
Private Const TABLE_ITEM_P          As String = "ITEM_P"        '�˗�����
Private Const TABLE_ITEM_C          As String = "ITEM_C"        '��������

Private Const TABLE_GRP             As String = "GRP"           '�O���[�v
Private Const TABLE_GRP_R           As String = "GRP_R"         '�O���[�v���˗�����
Private Const TABLE_GRP_I           As String = "GRP_I"         '�O���[�v����������

'********** 2004/08/26 FJTH)M,E �c�̃O���[�v�ǉ��@*************************
Private Const TABLE_ORGGRP          As String = "ORGGRP_P"         '�O���[�v
'********** 2004/08/26 FJTH)M,E �c�̃O���[�v�ǉ��@*************************


Private Const TABLE_CALC            As String = "CALC"          '�v�Z
Private Const TABLE_STDVALUE        As String = "STDVALUE"      '��l

'### 2008.02.10 Add by �� ########################################################
Private Const TABLE_SP_STDVALUE     As String = "SP_STDVALUE"   '���茒�f��l
'### 2008.02.10 Add End ##########################################################

Private Const TABLE_STCCLASS        As String = "STCCLASS"      '���͕���
Private Const TABLE_SENTENCE_REC    As String = "SENTENCE_REC"  '����
Private Const TABLE_SENTENCE_ITEM   As String = "SENTENCE_ITEM" '���́i�������ڂ��當�̓^�C�v�̂��̂𒊏o�j
Private Const TABLE_RSLCMT          As String = "RSLCMT"        '���ʃR�����g

Private Const TABLE_JUDCLASS        As String = "JUDCLASS"      '���蕪��
Private Const TABLE_JUD             As String = "JUD"           '����
Private Const TABLE_STDJUD          As String = "STDJUD"        '��^����
Private Const TABLE_JUDCMTSTC       As String = "JUDCMTSTC"     '����R�����g
Private Const TABLE_GUIDANCE        As String = "GUIDANCE"      '�w�����e

Private Const TABLE_NUTRITARGET     As String = "NUTRITARGET"       '�h�{�v�Z�ڕW�ʃe�[�u��
Private Const TABLE_NUTRIFOODENERGY As String = "NUTRIFOODENERGY"   '�H�i�Q�ʐێ�e�[�u��
Private Const TABLE_NUTRICOMPFOOD   As String = "NUTRICOMPFOOD"     '�\���H�i�e�[�u��
Private Const TABLE_NUTRIMENULIST   As String = "NUTRIMENULIST"     '�h�{�������X�g�e�[�u��

Private Const TABLE_COURSE          As String = "COURSE"        '�R�[�X
Private Const TABLE_WEB_CS          As String = "WEB_CS"        'web�R�[�X
Private Const TABLE_SETCLASS        As String = "SETCLASS"      '�Z�b�g����

Private Const TABLE_DISDIV          As String = "DISDIV"        '�a��
Private Const TABLE_DISEASE         As String = "DISEASE"       '�a��
Private Const TABLE_STDCONTACTSTC   As String = "STDCONTACTSTC" '��^�ʐڕ���

Private Const TABLE_RSVFRA          As String = "RSVFRA"        '�\��g
Private Const TABLE_RSVGRP          As String = "RSVGRP"        '�\��Q
Private Const TABLE_COURSE_RSVGRP   As String = "COURSE_RSVGRP" '�R�[�X��f�\��Q


Private Const TABLE_ZAIMU           As String = "ZAIMU"         '�������
Private Const TABLE_ZAIMUINFO       As String = "ZAIMUINFO"     '�����A�gCSV���
Private Const TABLE_BILLCLASS       As String = "BILLCLASS"     '����������
Private Const TABLE_DMDLINECLASS    As String = "DMDLINECLASS"  '�������ו���

'### 2004/1/15 Added by Ishihara@FSIT �Z�b�g�O�������גǉ�
Private Const TABLE_OTHERLINEDIV    As String = "OTHERLINEDIV"  '�Z�b�g�O��������
'### 2004/1/15 Added End
'## 2004.05.28 ADD STR ORB)T.YAGUCHI �Q����������
Private Const TABLE_SECONDLINEDIV   As String = "SECONDLINEDIV"  '�Q����������
'## 2004.05.28 ADD END

Private Const TABLE_ROUNDCLASS      As String = "ROUNDCLASS"    '�܂�ߕ���

Private Const TABLE_RELATION        As String = "RELATION"      '����
Private Const TABLE_PUBNOTEDIV      As String = "PUBNOTEDIV"    '�m�[�g���敪

Private Const TABLE_REPORT          As String = "REPORT"        '���[
Private Const TABLE_PREF            As String = "PREF"          '�s���{��
Private Const TABLE_SYSPRO          As String = "SYSPRO"        '���ݒ�
Private Const TABLE_FREE            As String = "FREE"          '�ėp�e�[�u��
Private Const TABLE_SYSPROSUB       As String = "SYSPROSUB"     '���ݒ蕪�ޕ�
Private Const TABLE_WORKSTATION     As String = "WORKSTATION"   '�[���Ǘ�
Private Const TABLE_HAINSUSER       As String = "HAINSUSER"     '���[�U
Private Const TABLE_UPDSTDVALUE     As String = "UPDSTDVALUE"   '�w����ԓ��̊�l�X�V

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
Private Const TABLE_MAILCONF        As String = "MAILCONF"      '�\�񃁁[�����M�ݒ�i��{�ݒ�j
Private Const TABLE_MAILTEMPLATE    As String = "MAILTEMPLATE"  '�\�񃁁[�����M�ݒ�i���[���e���v���[�g�j
Private Const TABLE_ORDEREXCEL      As String = "ORDEREXCEL"    '�I�[�_�A�g�ݒ�pEXCEL
Private Const ORDEREXCELFILENAME    As String = "�I�[�_�A�g�������ڃ}�X�^�ݒ�.xls"
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####

'### 2005.3.23 Add by ��
Private Const NODE_SECURITY_ROOT        As String = "NODE_SECURITY_ROOT"        '�����Ǘ� ROOT
Private Const NODE_SECURITY_UGRPGM      As String = "NODE_SECURITY_UGRPGM"       '���[�U�[�O���[�v�ʃv���O����
Private Const NODE_SECURITY_USERGRP     As String = "NODE_SECURITY_USERGRP"     '���[�U�[�O���[�v
Private Const NODE_SECURITY_MENUGRP     As String = "NODE_SECURITY_MENUGRP"     '���j���[�O���[�v
Private Const NODE_SECURITY_PGMINFO     As String = "NODE_SECURITY_PGMINFO"     '
Private Const NODE_SECURITY_PWD         As String = "NODE_SECURITY_PWD"     '

Private Const TABLE_SECURITYGRP         As String = "UGR"                       '
Private Const TABLE_MENUPGM             As String = "MENU"                      '
'### 2005.3.23 Add End ...

'
' �@�\�@�@ : �c���[�ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditTreeView()

    Dim colNodes    As Nodes    '�m�[�h�R���N�V����
    Dim objNode     As Node     '�m�[�h�I�u�W�F�N�g
    
    '�e�m�[�h�̕ҏW
    Set colNodes = trvMaster.Nodes
    
    With colNodes
        .Clear
        '�e�[�u��(Root)��ݒ�
        .Add , , NODE_ROOT, "webHains�̊Ǘ�"
            
        '�e�e�[�u��������w���q�m�[�h��ҏW
        
        '�������ڏ��֘A
        .Add NODE_ROOT, tvwChild, "ITEM", "�������ڏ��"
        .Add "ITEM", tvwChild, TABLE_ITEMCLASS, "��������"
        .Add "ITEM", tvwChild, TABLE_PROGRESS, "�i���Ǘ��p����"
'### 2003.11.23 Deleted by H.Ishihara@FSIT ���H�����g�p���ڍ폜
'        .Add "ITEM", tvwChild, TABLE_OPECLASS, "�������{������"
'### 2003.11.23 Deleted End
        .Add "ITEM", tvwChild, TABLE_ITEM_P, "�˗�����"
        .Add "ITEM", tvwChild, TABLE_ITEM_C, "��������"
    
        '�O���[�v�֘A
        .Add NODE_ROOT, tvwChild, "GROUP", "�O���[�v���"
        .Add "GROUP", tvwChild, TABLE_GRP_R, "�˗����ڂ̃O���[�v"
        .Add "GROUP", tvwChild, TABLE_GRP_I, "�������ڂ̃O���[�v"
'************ 2004/08/26 fjth)M,E�@�c�̃O���[�v�̒ǉ��@-S ******************
        .Add "GROUP", tvwChild, TABLE_ORGGRP, "�c�̃O���[�v"
'************ 2004/08/26 fjth)M,E�@�c�̃O���[�v�̒ǉ��@-E ******************
    
        '���ʊ֘A
        .Add NODE_ROOT, tvwChild, "RESULT", "���ʊ֘A"
        .Add "RESULT", tvwChild, TABLE_CALC, "�v�Z"
        .Add "RESULT", tvwChild, TABLE_STDVALUE, "��l"
'### 2008.02.10 Add by �� ���茒�f��l�ǉ� ###############################
        .Add "RESULT", tvwChild, TABLE_SP_STDVALUE, "���茒�f�p��l"
'### 2008.02.10 Add End ###################################################
        .Add "RESULT", tvwChild, TABLE_RSLCMT, "���ʃR�����g"
        .Add "RESULT", tvwChild, "SENTENCE", "����"
        .Add "SENTENCE", tvwChild, TABLE_STCCLASS, "���͕���"
        .Add "SENTENCE", tvwChild, TABLE_SENTENCE_REC, "���͈ꗗ"
        .Add "SENTENCE", tvwChild, TABLE_SENTENCE_ITEM, "���̓^�C�v�̍��ڈꗗ"
        
        '����֘A
        .Add NODE_ROOT, tvwChild, "JUDGMENT", "����֘A"
        .Add "JUDGMENT", tvwChild, TABLE_JUDCLASS, "���蕪��"
        .Add "JUDGMENT", tvwChild, TABLE_JUD, "����"
'        .Add "JUDGMENT", tvwChild, TABLE_STDJUD, "��^����"
        .Add "JUDGMENT", tvwChild, TABLE_JUDCMTSTC, "����R�����g"
        .Add "JUDGMENT", tvwChild, TABLE_GUIDANCE, "�w�����e"
    
        .Add NODE_ROOT, tvwChild, "NOURISHMENT", "�h�{�֘A"
        .Add "NOURISHMENT", tvwChild, TABLE_NUTRITARGET, "�h�{�v�Z�ڕW��"
        .Add "NOURISHMENT", tvwChild, TABLE_NUTRIFOODENERGY, "�H�i�Q�ʐێ�"
        .Add "NOURISHMENT", tvwChild, TABLE_NUTRICOMPFOOD, "�\���H�i"
        .Add "NOURISHMENT", tvwChild, TABLE_NUTRIMENULIST, "�h�{�������X�g"
    
        '�R�[�X�֘A
        .Add NODE_ROOT, tvwChild, "COURSE_MAIN", "��f�R�[�X"
        .Add "COURSE_MAIN", tvwChild, TABLE_COURSE, "��{�R�[�X"
        .Add "COURSE_MAIN", tvwChild, TABLE_SETCLASS, "�Z�b�g����"
'### 2003.11.23 Deleted by H.Ishihara@FSIT ���H�����g�p���ڍ폜
'        .Add "COURSE_MAIN", tvwChild, TABLE_WEB_CS, "�C���^�[�l�b�g�p����"
'### 2003.11.23 Deleted End
    
'### 2003.11.23 Deleted by H.Ishihara@FSIT ���H�����g�p���ڍ폜
'        '�R�[�X�֘A
'        .Add NODE_ROOT, tvwChild, "AFTER_MAIN", "����[�u�A���a�x��"
'        .Add "AFTER_MAIN", tvwChild, TABLE_DISDIV, "�a��"
'        .Add "AFTER_MAIN", tvwChild, TABLE_DISEASE, "�a��"
'        .Add "AFTER_MAIN", tvwChild, TABLE_STDCONTACTSTC, "��^�ʐڕ���"
'### 2003.11.23 Deleted End
    
        '�X�P�W���[���֘A
        .Add NODE_ROOT, tvwChild, "SCHEDULE", "�X�P�W���[��"
        .Add "SCHEDULE", tvwChild, TABLE_RSVFRA, "�\��g"
        .Add "SCHEDULE", tvwChild, TABLE_RSVGRP, "�\��Q"
        .Add "SCHEDULE", tvwChild, TABLE_COURSE_RSVGRP, "�R�[�X��f�\��Q"
    
        '�����֘A
        .Add NODE_ROOT, tvwChild, "DEMAND", "�����֘A"
'### 2004/1/15 Added by Ishihara@FSIT �Z�b�g�O�������גǉ�
        .Add "DEMAND", tvwChild, TABLE_OTHERLINEDIV, "�Z�b�g�O��������"
'### 2004/1/15 Added End
'## 2004.05.28 ADD STR ORB)T.YAGUCHI �Q����������
        .Add "DEMAND", tvwChild, TABLE_SECONDLINEDIV, "�Q����������"
'## 2004.05.28 ADD END

'### 2004/01/15 Deleted by H.Ishihara@FSIT ���H�����g�p���ڍ폜
'        .Add "DEMAND", tvwChild, TABLE_BILLCLASS, "����������"
'        .Add "DEMAND", tvwChild, TABLE_DMDLINECLASS, "�������ו���"
'### 2003.11.23 Deleted by H.Ishihara@FSIT ���H�����g�p���ڍ폜
'        .Add "DEMAND", tvwChild, TABLE_ROUNDCLASS, "�܂�ߕ���"
'        .Add "DEMAND", tvwChild, TABLE_ZAIMU, "�����A�g�ݒ�R�[�h"
'        .Add "DEMAND", tvwChild, TABLE_ZAIMUINFO, "�����A�g�f�[�^"
    
'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        .Add NODE_ROOT, tvwChild, "SENDMAIL", "�\�񃁁[�����M�ݒ�"
        .Add "SENDMAIL", tvwChild, TABLE_MAILCONF, "��{�ݒ�"
        .Add "SENDMAIL", tvwChild, TABLE_MAILTEMPLATE, "���[���e���v���[�g"
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####
    
        '���̑��ݒ�
        .Add NODE_ROOT, tvwChild, "OTHER", "���̑��Ǘ��p�ݒ�"
        .Add "OTHER", tvwChild, TABLE_RELATION, "����"
        .Add "OTHER", tvwChild, TABLE_PUBNOTEDIV, "�R�����g���敪"
        .Add "OTHER", tvwChild, TABLE_REPORT, "���[�ݒ�"
        .Add "OTHER", tvwChild, TABLE_PREF, "�s���{��"
        .Add "OTHER", tvwChild, TABLE_SYSPRO, "�V�X�e�����ݒ�"
        .Add TABLE_SYSPRO, tvwChild, TABLE_SYSPROSUB, "���ݒ�"
        .Add TABLE_SYSPRO, tvwChild, TABLE_FREE, "�ėp�e�[�u��"
'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        .Add TABLE_SYSPRO, tvwChild, TABLE_ORDEREXCEL, "�I�[�_�A�g�}�X�^�ݒ�"
'#### 2013.3.4 SL-SN-Y0101-612 ADD END ####
        
        .Add "OTHER", tvwChild, TABLE_WORKSTATION, "�[���Ǘ�"
        .Add "OTHER", tvwChild, TABLE_HAINSUSER, "���[�U"
        .Add "OTHER", tvwChild, TABLE_UPDSTDVALUE, "��l�̍Đݒ�"
        .Add , , NODE_SEARCH, "��������"
        
'## 2005.03.18 YHLEE --------------------------------------------------------------------------------
        .Add , , NODE_SECURITY_ROOT, "�����Ǘ�"
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_UGRPGM, "�Z�L�����e�B�[�O���[�v�ʃv���O�������"
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_USERGRP, "���[�U�[�O���[�v�Ǘ�"
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_MENUGRP, "���j���[�O���[�v�Ǘ�"
'#### 2010.07.16 SL-HS-Y0101-001 MOD START ####�@COMP-LUKES-0029�i��݊����؁j
'        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_PGMINFO, "�v���O�������Ǘ�"
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_PGMINFO, "�v���O�������Ǘ�"
'#### 2010.07.16 SL-HS-Y0101-001 MOD END �@####�@COMP-LUKES-0029�i��݊����؁j
        
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_PWD, "�p�X���[�h�L�����Ԑݒ�"
'## 2005.03.18 YHLEE --------------------------------------------------------------------------------

    End With
    
    For Each objNode In colNodes
        '�e�m�[�h�ɑ΂���C���[�W�̐ݒ�
        objNode.Image = ICON_CLOSED
        
        Select Case objNode.Key
            Case "ROOT"
                'ROOT�m�[�h�Ȃ炻�̂܂ܓW�J
                objNode.Child.EnsureVisible
            
            Case NODE_SEARCH
'                objNode.Visible = False

            '## 2005.3.23 Add by ��
            Case NODE_SECURITY_ROOT
                objNode.Image = SECURITY
            
            '## 2005.3.23 Add�@End ...
            
            Case Else
''                'ROOT�m�[�h�����A���q�m�[�h�����݂���Ȃ�W�J
''                If (objNode.Parent.Key = "ROOT") And (objNode.Children <> 0) Then
''                    objNode.Child.EnsureVisible
''                End If
        
        End Select

'        If objNode.Key = "ROOT" Then
'            'ROOT�m�[�h�Ȃ炻�̂܂ܓW�J
'            objNode.Child.EnsureVisible
'        Else
'
'            'ROOT�m�[�h�����A���q�m�[�h�����݂���Ȃ�W�J
'            If (objNode.Parent.Key = "ROOT") And (objNode.Children <> 0) Then
'                objNode.Child.EnsureVisible
'            End If
'        End If
    
    Next
    
    'ROOT�m�[�h��I���ς݂ɂ���
    colNodes(NODE_ROOT).Selected = True

End Sub

'
' �@�\�@�@ : �c���[�r���[����̃��X�g�r���[�ҏW
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : �w�肳�ꂽ�m�[�h�ɑΉ�����R���e���c�ꗗ��\������
'
Private Sub EditListViewFromContents(strNodeKey As String)

    Dim lngCount            As Long             '���R�[�h��

    '�����\���p�̈揉����
    lngCount = -1
    stbMain.Panels.Item(1).Text = ""
    
    Select Case strNodeKey
        
        Case TABLE_ITEMCLASS
            '�������ރe�[�u��
            Call EditListViewFromItemClass(strNodeKey, lngCount)
        
        Case TABLE_PROGRESS
            '�i���Ǘ��p���ރe�[�u��
            Call EditListViewFromProgress(strNodeKey, lngCount)
        
        Case TABLE_OPECLASS
            '�������{�����ރe�[�u��
            Call EditListViewFromOpeClass(strNodeKey, lngCount)
    
        Case TABLE_ITEM_P
            '�˗����ڃe�[�u���i�e�m�[�h�j
            Call EditTreeViewFromItemClass(TABLE_ITEM_P)
    
        Case TABLE_ITEM_C
            '�������ڃe�[�u���i�e�m�[�h�j
            Call EditTreeViewFromItemClass(TABLE_ITEM_C)
        
        '------------------------------------------------
        Case TABLE_GRP_R
            '�O���[�v�e�[�u���i�˗����ځj
            Call EditListViewFromGrp(strNodeKey, TABLE_GRP_R, lngCount)
        
        Case TABLE_GRP_I
            '�O���[�v�e�[�u���i�������ځj
            Call EditListViewFromGrp(strNodeKey, TABLE_GRP_I, lngCount)
            
' ********* 2004/08/26 FJTH)M,E -S ***********************************************
        Case TABLE_ORGGRP
            '�O���[�v�e�[�u���i�c�̍��ځj
            Call EditListViewFromGrp(strNodeKey, TABLE_ORGGRP, lngCount)
' ********* 2004/08/26 FJTH)M,E -E ***********************************************
            
    
        '------------------------------------------------

        Case TABLE_CALC
            '�v�Z�e�[�u��
            Call EditListViewFromCalc(strNodeKey, lngCount)
        
        Case TABLE_STDVALUE
            '��l�e�[�u���i�e�m�[�h�j
            Call EditTreeViewFromItemClass(TABLE_STDVALUE)
    
'### 2008.02.10 Add by �� ���茒�f��l�ǉ� ###############################
        Case TABLE_SP_STDVALUE
            '���茒�f�p��l�e�[�u���i�e�m�[�h�j
            Call EditTreeViewFromItemClass(TABLE_SP_STDVALUE)
'### 2008.02.10 Add End ###################################################
        
        Case TABLE_STCCLASS
            '���̓e�[�u���i���R�[�h�C���[�W�j
            Call EditListViewFromStcClass(strNodeKey, lngCount)
    
        Case TABLE_SENTENCE_REC
            '���̓e�[�u���i���R�[�h�C���[�W�j
            Call EditListViewFromSentence(strNodeKey, lngCount)
    
        Case TABLE_SENTENCE_ITEM
            '���̓e�[�u���i���̓^�C�v�̌������ڈꗗ�j
            Call EditListViewFromSentenceItem(strNodeKey, lngCount)

        Case TABLE_RSLCMT
            '���ʃR�����g�e�[�u��
            Call EditListViewFromRslCmt(strNodeKey, lngCount)
    
        '------------------------------------------------
        Case TABLE_NUTRITARGET
            '�h�{�v�Z�ڕW�ʃe�[�u��
            Call EditListViewFromNutriTarget(strNodeKey, lngCount)
    
        Case TABLE_NUTRIFOODENERGY
            '�H�i�Q�ʐێ�e�[�u��
            Call EditListViewFromNutriFoodEnergy(strNodeKey, lngCount)
        
        Case TABLE_NUTRICOMPFOOD
            '�\���H�i�e�[�u��
            Call EditListViewFromNutriCompFood(strNodeKey, lngCount)
        
        Case TABLE_NUTRIMENULIST
            '�h�{�������X�g�e�[�u��
            Call EditListViewFromNutriMenuList(strNodeKey, lngCount)
    
        '------------------------------------------------
        Case TABLE_JUDCLASS
            '���蕪�ރe�[�u��
            Call EditListViewFromJudClass(strNodeKey, lngCount)
    
        Case TABLE_JUD
            '����e�[�u��
            Call EditListViewFromJud(strNodeKey, lngCount)
    
        Case TABLE_STDJUD
            '��^�����e�[�u���i�e�m�[�h�j
            Call EditTreeViewFromJudClass(TABLE_STDJUD)
    
        Case TABLE_GUIDANCE
            '�w�����e�e�[�u���i�e�m�[�h�j
            Call EditTreeViewFromJudClass(TABLE_GUIDANCE)
    
        Case TABLE_JUDCMTSTC
            '����R�����g�e�[�u���i�e�m�[�h�j
            Call EditTreeViewFromJudClass(TABLE_JUDCMTSTC)
    
        '------------------------------------------------
        Case TABLE_COURSE
            '�R�[�X�e�[�u��
            Call EditListViewFromCourse(strNodeKey, lngCount)
        
        Case TABLE_WEB_CS
            'web�R�[�X�e�[�u��
            Call EditListViewFromWeb_Cs(strNodeKey, lngCount)
        
        Case TABLE_SETCLASS
            '�Z�b�g���ރe�[�u��
            Call EditListViewFromSetClass(strNodeKey, lngCount)
        
        '------------------------------------------------
        Case TABLE_DISDIV
            '�a��
            Call EditListViewFromDisDiv(strNodeKey, lngCount)
        
        Case TABLE_DISEASE
            '�a��
            Call EditListViewFromDisease(strNodeKey, lngCount)
        
        Case TABLE_STDCONTACTSTC
            '��^�ʐڕ���
            Call EditListViewFromStdContactStc(strNodeKey, lngCount)
        
        '------------------------------------------------
        Case TABLE_RSVFRA
            '�\��g�e�[�u��
            Call EditListViewFromRsvFra(strNodeKey, lngCount)
        
        Case TABLE_RSVGRP
            '�\��Q�e�[�u��
            Call EditListViewFromRsvGrp(strNodeKey, lngCount)
        
        Case TABLE_COURSE_RSVGRP
            '�R�[�X��f�\��Q�e�[�u��
            Call EditListViewFromCourseRsvGrp(strNodeKey, lngCount)

        '------------------------------------------------
        Case TABLE_ZAIMU
            '�����e�[�u��
            Call EditListViewFromZaimu(strNodeKey, lngCount)
        
        Case TABLE_BILLCLASS
            '�������e�[�u��
            Call EditListViewFromBillClass(strNodeKey, lngCount)
        
        Case TABLE_DMDLINECLASS
            '�������ו��ރe�[�u��
            Call EditListViewFromDmdLineClass(strNodeKey, lngCount)
        
        Case TABLE_ROUNDCLASS
            '�܂�ߕ��ރe�[�u��
            Call EditListViewFromRoundClass(strNodeKey, lngCount)
        
'### 2004/1/15 Added by Ishihara@FSIT �Z�b�g�O�������גǉ�
        Case TABLE_OTHERLINEDIV
            '�Z�b�g�O�������׃e�[�u��
            Call EditListViewFromOtherLineDiv(strNodeKey, lngCount)
'### 2004/1/15 Added End
        
'## 2004.05.28 ADD STR ORB)T.YAGUCHI �Q����������
        Case TABLE_SECONDLINEDIV
            '�Q���������׃e�[�u��
            Call EditListViewFromSecondLineDiv(strNodeKey, lngCount)
'## 2004.05.28 ADD END
        
'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        Case TABLE_MAILCONF
            '�\�񃁁[�����M�ݒ�i��{�ݒ�j
            Call EditListViewFromMailConf(strNodeKey, lngCount)

        Case TABLE_MAILTEMPLATE
            '�\�񃁁[�����M�ݒ�i��{�ݒ�j
            Call EditListViewFromMailTemplate(strNodeKey, lngCount)

        Case TABLE_ORDEREXCEL
            '�I�[�_�A�gExcel�N��
            Call OpenOrderRenkeiExcel
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####
        
        '------------------------------------------------
        Case TABLE_RELATION
            '�����e�[�u��
            Call EditListViewFromRelation(strNodeKey, lngCount)
        
        Case TABLE_PUBNOTEDIV
            '�m�[�g��񕪗ރe�[�u��
            Call EditListViewFromPubNoteDiv(strNodeKey, lngCount)
        
        Case TABLE_PREF
            '�s���{���e�[�u��
            Call EditListViewFromPref(strNodeKey, lngCount)
    
        Case TABLE_SYSPROSUB
            '�V�X�e�����ݒ�
            Call EditListViewFromSysPro(strNodeKey, lngCount)
        
        Case TABLE_FREE
            '�ėp�e�[�u��
            Call EditListViewFromFree(strNodeKey, lngCount)
        
        Case TABLE_WORKSTATION
            '�[���Ǘ��e�[�u��
            Call EditListViewFromWorkStation(strNodeKey, lngCount)
        
        Case TABLE_REPORT
            '���[�e�[�u��
            Call EditListViewFromReport(strNodeKey, lngCount)
        
        Case TABLE_HAINSUSER
            '���[�U�e�[�u��
            Call EditListViewFromHainsUser(strNodeKey, lngCount)
        
        Case TABLE_UPDSTDVALUE
            '���ʒl����̊�l�R�[�h�S�X�V
'            Call EditListViewFromHainsUser(strNodeKey, lngCount)
        
        '------------------------------------------------
''####### 2005.03.23  ADD by ��
        Case NODE_SECURITY_UGRPGM
            Call EditListViewFromUserGroup(strNodeKey, lngCount)
    
        Case NODE_SECURITY_USERGRP, NODE_SECURITY_MENUGRP, NODE_SECURITY_PGMINFO, NODE_SECURITY_PWD
            Call EditListViewFromUserGroup(strNodeKey, lngCount)
    
''####### 2005.03.23  ADD End ...
    
    
        Case Else
            '�˗����ڃe�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_ITEM_P)) = TABLE_ITEM_P Then
                Call EditListViewFromItem_p(strNodeKey, Mid(strNodeKey, Len(TABLE_ITEM_P) + 1, Len(strNodeKey)), lngCount)
            End If
            
            '�������ڃe�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_ITEM_C)) = TABLE_ITEM_C Then
                Call EditListViewFromItem_c(strNodeKey, Mid(strNodeKey, Len(TABLE_ITEM_C) + 1, Len(strNodeKey)), lngCount)
            End If
            
            '��l�e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_STDVALUE)) = TABLE_STDVALUE Then
                Call EditListViewFromStdValue(strNodeKey, Mid(strNodeKey, Len(TABLE_STDVALUE) + 1, Len(strNodeKey)), lngCount)
            End If
            
'### 2008.02.10 Add by �� ���茒�f��l�ǉ� ###############################
            
            '���茒�f�p��l�e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_SP_STDVALUE)) = TABLE_SP_STDVALUE Then
                Call EditListViewFromSpStdValue(strNodeKey, Mid(strNodeKey, Len(TABLE_SP_STDVALUE) + 1, Len(strNodeKey)), lngCount)
            End If
            
'### 2008.02.10 Add End ###################################################
            
            '��^�����e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_STDJUD)) = TABLE_STDJUD Then
                Call EditListViewFromStdJud(strNodeKey, CInt(Mid(strNodeKey, Len(TABLE_STDJUD) + 1, Len(strNodeKey))), lngCount)
            End If
            
            '�w�����e�e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_GUIDANCE)) = TABLE_GUIDANCE Then
'### 2003.01.17 Modified by H.Ishihara@FSIT ���蕪�ޖ��w����\������
'                Call EditListViewFromGuidance(strNodeKey, CInt(Mid(strNodeKey, Len(TABLE_GUIDANCE) + 1, Len(strNodeKey))), lngCount)
                 Call EditListViewFromGuidance(strNodeKey, Mid(strNodeKey, Len(TABLE_GUIDANCE) + 1, Len(strNodeKey)), lngCount)
'### 2003.01.17 Modified End
            End If
        
            '����R�����g�e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_JUDCMTSTC)) = TABLE_JUDCMTSTC Then
                Call EditListViewFromJudCmtStc(strNodeKey, Mid(strNodeKey, Len(TABLE_JUDCMTSTC) + 1, Len(strNodeKey)), lngCount)
            End If
        
'#### 2005.3.25 Add by ��
            If Mid(strNodeKey, 1, Len(TABLE_SECURITYGRP)) = TABLE_SECURITYGRP Then
                Call EditListViewFromUserGroup(strNodeKey, lngCount)
            End If
            
            If Mid(strNodeKey, 1, Len(TABLE_MENUPGM)) = TABLE_MENUPGM Then
                Call EditListViewFromPgmInfoList(strNodeKey, lngCount)
            End If
            
'#### 2005.3.25 Add End ...
            
    End Select
    
    '�擾������\��
    If lngCount > -1 Then
        stbMain.Panels.Item(1).Text = lngCount & " �̃��R�[�h��������܂����B"
    End If
    
End Sub

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
'
' �@�\�@�@ : �I�[�_�[�A�g�pExcel�t�@�C���N��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub OpenOrderRenkeiExcel()

    '�N���m�F�i�L�����Z���Ȃ�I���j
    If MsgBox("�I�[�_�A�g�p�}�X�^�ݒ�Excel(�I�[�_�A�g�������ڃ}�X�^�ݒ�.xls)���J���܂��A��낵���ł����H" & vbLf & _
              "(Excel���C���X�g�[������Ă��Ȃ����ł͋N���ł��܂���)", vbQuestion + vbYesNo, "�I�[�_�A�gEXCEL�N��") = vbCancel Then Exit Sub
    
    '�t�@�C���̑��݃`�F�b�N
    Dim cFso As FileSystemObject
    Set cFso = New FileSystemObject
    Dim excelFileFullPath   As String
    excelFileFullPath = App.Path & "\" & ORDEREXCELFILENAME
    
    ' �t�@�C�������݂��Ă��邩�ǂ����m�F����
    If cFso.FileExists(excelFileFullPath) = False Then
        
        Call MsgBox("�w�肳�ꂽ�t�@�C���͑��݂��܂���" & vbLf & excelFileFullPath, vbCritical)
        Exit Sub
    
    End If


    'Excel�N��
    Dim xlApp    As Object
    Dim xlSheet  As Object
    Dim xlBook   As Object
    
    Set xlApp = CreateObject("Excel.Application")
    Set xlBook = xlApp.Workbooks.Open(excelFileFullPath)
    Set xlSheet = xlBook.Worksheets(1)
    
    xlApp.Visible = True
    xlApp.WindowState = vbMaximized
    xlSheet.Activate

End Sub


'## 2003.12.13 ADD TCS)H.F
' MCH�A�g�F�a���}�X�^�A�g
Private Sub MchByomeiCooperation()

    Dim wFileName           As String                   'CSV�t�@�C���p�X��
    Dim wFno                As Integer                  'CSV�t�@�C���ԍ�
    Dim wCancelFlg          As Boolean                  '�L�����Z���t���O
    Dim wBuff               As String                   '�ҏW�̈�
    
    Dim i                   As Long                     '�Y����
    Dim RetB                As String                   '�߂�l�i�^�U�j
    
    Dim lngCount            As Long                     '�J�E���^
    Dim vntFreeField1       As Variant                  '���ڃR�[�h
    Dim vntFreeField2       As Variant                  '���ڃ^�C�v
    Dim vntStcCd            As Variant                  '�a���R�[�h�i���̓R�[�h�j
    Dim vntShortStc         As Variant                  '�a���i���́j
    Dim objFree             As Object                   '�ėp�e�[�u��
    Dim objSentence         As Object                   '���̓e�[�u��

On Error GoTo MchByomeiCooperation_Error

    
    wCancelFlg = False
    Set objFree = CreateObject("HainsFree.Free")
    Set objSentence = CreateObject("HainsSentence.Sentence")
    
    '�ėp�e�[�u������a���R�[�h���擾���鍀�ڃR�[�h�y�э��ڃ^�C�v���擾����
    lngCount = objFree.SelectFree(0, "MCHCOOP", , , , vntFreeField1, vntFreeField2)
    If lngCount <= 0 Then
        '�Ώۃf�[�^�Ȃ�
        MsgBox "MCH�A�g�p�̔ėp�e�[�u���iMCHCOOP�j���o�^����Ă��܂���B", vbCritical, "HCH �a���}�X�^�A�g"
        GoTo MchByomeiCooperation_Exit
    End If
    
    lngCount = objSentence.SelectSentenceList(vntFreeField1 & "", vntFreeField2 & "" _
                                                            , vntStcCd, vntShortStc)
    If lngCount <= 0 Then
        MsgBox "�ΏۂƂȂ�a���f�[�^������܂���B", vbExclamation, "HCH �a���}�X�^�A�g"
        GoTo MchByomeiCooperation_Exit
    End If
    
    'CSV�t�@�C���w��
    wFileName = GetSetting("MchCooperation", "MchDisease", "CsvFileName", "disease.txt")
    With dlgCommonDialog
        .Filter = "÷��̧��(*.TXT)|*.TXT|CSV̧��(*.CSV)|*.CSV|�S�Ă�̧��(*.*)|*.*"
        .FileName = wFileName
        .ShowSave
    End With
    If wCancelFlg = True Then
        '�L�����Z��
        GoTo MchByomeiCooperation_Exit
    End If
    
    '�a���A�g�f�[�^��������
    wFno = FreeFile
    Open wFileName For Output Shared As #wFno
    
    For i = 0 To lngCount - 1
        wBuff = vntStcCd(i) & "," & vntShortStc(i)
        Print #wFno, wBuff
    Next i
    
    SaveSetting "MchCooperation", "MchDisease", "CsvFileName", wFileName
    
MchByomeiCooperation_Exit:
    On Error Resume Next
    Set objFree = Nothing
    Set objSentence = Nothing
    Close #wFno
    
    Exit Sub

MchByomeiCooperation_Error:

    If Err.Number = cdlCancel Then
        wCancelFlg = True
        Resume Next
    End If

    MsgBox Err.Number & ":" & Err.Description, vbCritical, Err.Source

    Exit Sub
    Resume  '�f�o�b�O�p

End Sub

'
' �@�\�@�@ : �e�[�u�������e�i���X��ʂ��J��
'
' �����@�@ : (In)      vntNodeKey  (���X�g�A�C�e����)�m�[�h�L�[
' �@�@�@�@ : (In)      vntItemKey  (���X�g�A�C�e����)�A�C�e���L�[
'
' �߂�l�@ : TRUE:�f�[�^�X�V����AFALSE:�f�[�^�X�V�Ȃ�
'
' ���l�@�@ :
'
Private Function ShowEditWindow(ByVal vntNodeKey As Variant, _
                                Optional ByVal vntItemKey As Variant, _
                                Optional ByVal vntItemText As Variant) As Boolean

On Error GoTo ErrorHandle

    Dim colNodes        As Nodes    '�m�[�h�R���N�V����
    Dim objEditWindow   As Object   '�����e�i���X�E�C���h�E�I�u�W�F�N�g
    Dim vntKey          As Variant  '���R�[�h�L�[
    Dim strSetKey       As String
    
    Dim strSplitKey1    As String   '�X�v���b�g�p�L�[
    Dim strSplitKey2    As String   '�X�v���b�g�p�L�[
    
    Dim strItemCd       As String   '�X�v���b�g�p�L�[
    Dim strSuffix       As String   '�X�v���b�g�p�L�[
    Dim strItemType     As String   '�X�v���b�g�p�L�[
    Dim strStcCd        As String   '�X�v���b�g�p�L�[
    Dim strItemName     As String   '���̓e�[�u�������e�i���X�p�̍��ږ��ޔ�p
    
    ShowEditWindow = False
    
    
    '�L�[�l�̎擾
    If Not IsMissing(vntItemKey) Then
        vntKey = SplitKey(KEY_PREFIX, vntItemKey)
    End If
    
    'Split�������ʁA�l������Ȃ�Key�Z�b�g
    If Not IsEmpty(vntKey) Then
        strSetKey = vntKey(0)
    Else
        strSetKey = ""
    End If
    
    Select Case vntNodeKey
        
        '�������ރe�[�u��
        Case TABLE_ITEMCLASS
            Set objEditWindow = New mntItemClass.ItemClass
            objEditWindow.ItemClassCd = strSetKey

        '�i���Ǘ��p���ރe�[�u��
        Case TABLE_PROGRESS
            Set objEditWindow = New mntProgress.Progress
            objEditWindow.ProgressCd = strSetKey

        '�������{�����ރe�[�u��
        Case TABLE_OPECLASS
            Set objEditWindow = New mntOpeClass.OpeClass
            objEditWindow.OpeClassCd = strSetKey

        '�R�[�X�e�[�u��
        Case TABLE_COURSE
            Set objEditWindow = New mntCourse.Course
            objEditWindow.CsCd = strSetKey

        '�R�[�X�e�[�u��
        Case TABLE_SETCLASS
            Set objEditWindow = New mntSetClass.SetClass
            objEditWindow.SetClassCd = strSetKey

        'WEB�R�[�X�ݒ�
        Case TABLE_WEB_CS
            Set objEditWindow = New mntWeb_Cs.Web_Cs
            objEditWindow.CsCd = strSetKey

        '�\��g�e�[�u��
        Case TABLE_RSVFRA
            Set objEditWindow = New mntRsvFra.RsvFra
            objEditWindow.RsvFraCd = strSetKey

        '�\��Q�e�[�u��
        Case TABLE_RSVGRP
            Set objEditWindow = New mntRsvGrp.RsvGrp
            objEditWindow.RsvGrpCd = strSetKey

        '�R�[�X��f�\��Q
        Case TABLE_COURSE_RSVGRP
            Set objEditWindow = New mntCourseRsvGrp.CourseRsvGrp
            '�R�[�X�R�[�h�Ɨ\��Q�R�[�h�𔲂�
            Call SplitItemAndSuffix(strSetKey, strItemCd, strSuffix)
            objEditWindow.CsCd = strItemCd
            objEditWindow.RsvGrpCd = strSuffix

        '�O���[�v���˗����ڃe�[�u��
        Case TABLE_GRP_R
            Set objEditWindow = New mntGrp.Grp
            objEditWindow.GrpDiv = MODE_REQUEST
            objEditWindow.GrpCd = strSetKey

        '�O���[�v���������ڃe�[�u��
        Case TABLE_GRP_I
            Set objEditWindow = New mntGrp.Grp
            objEditWindow.GrpDiv = MODE_RESULT
            objEditWindow.GrpCd = strSetKey
'
''************** 2004/08/26 FJTH)M,E  �c�̃O���[�v�ǉ��@-S ***********************
'        '�c�̃O���[�v�e�[�u��
        Case TABLE_ORGGRP
            Set objEditWindow = New mntOrgGrp.Grp
            objEditWindow.GrpDiv = MODE_RESULT
            objEditWindow.GrpCd = strSetKey
''************** 2004/08/26 FJTH)M,E  �c�̃O���[�v�ǉ��@-E ***********************


        '���ʃR�����g�e�[�u��
        Case TABLE_RSLCMT
            Set objEditWindow = New mntRslCmt.RslCmt
            objEditWindow.RslCmtCd = strSetKey

        '���蕪�ރe�[�u��
        Case TABLE_JUDCLASS
            Set objEditWindow = New mntJudClass.JudClass
            objEditWindow.JudClassCd = strSetKey

        '����e�[�u��
        Case TABLE_JUD
            Set objEditWindow = New mntJud.Jud
            objEditWindow.JudCd = strSetKey

        '�h�{�v�Z�ڕW�ʃe�[�u��
        Case TABLE_NUTRITARGET
'*********** 2004/08/26 FJTH)M,E ���b�Z�[�W�ł�������� - S
             MsgBox "�h�{�v�Z�y�уV�X�e�������Ŏg�p���Ă���ׁA�h�{�v�Z�ڕW�ʂ͏C���ł��܂���B", vbCritical, "�h�{�v�Z�ڕW��"
             Exit Function
'*********** 2004/08/26 FJTH)M,E ���b�Z�[�W�ł�������� - S


        '�H�i�Q�ʐێ�e�[�u��
        Case TABLE_NUTRIFOODENERGY
            Set objEditWindow = New mntNutriFoodEnergy.NutriFoodEnergy
            objEditWindow.Energy = strSetKey

        '�\���H�i�e�[�u��
        Case TABLE_NUTRICOMPFOOD
            Set objEditWindow = New mntNutriCompFood.NutriCompFood
            objEditWindow.ComposeFoodCd = strSetKey

        '�h�{�������X�g�e�[�u��
        Case TABLE_NUTRIMENULIST
'*********** 2004/08/26 FJTH)M,E ���b�Z�[�W�ł�������� - S
             MsgBox "�h�{�v�Z�y�уV�X�e�������Ŏg�p���Ă���ׁA�h�{�������X�g�͏C���ł��܂���B", vbCritical, "�h�{�������X�g"
             Exit Function
'*********** 2004/08/26 FJTH)M,E ���b�Z�[�W�ł�������� - S


        '�a�ރe�[�u��
        Case TABLE_DISDIV
            Set objEditWindow = New mntDisDiv.DisDiv
            objEditWindow.DisDivCd = strSetKey

        '�a���e�[�u��
        Case TABLE_DISEASE
            Set objEditWindow = New mntDisease.Disease
            objEditWindow.DisCd = strSetKey

        '��^�ʐڕ��̓e�[�u��
        Case TABLE_STDCONTACTSTC
            Set objEditWindow = New mntStdContactStc.StdContactStc
            '�w�����e�敪�ƒ�^�ʐڕ��̓R�[�h�𔲂�
            Call SplitItemAndSuffix(strSetKey, strItemCd, strSuffix)
            With objEditWindow
                .GuidanceDiv = strItemCd
                .StdContactStcCd = strSuffix
            End With

        '�����K�p�e�[�u��
        Case TABLE_ZAIMU
            Set objEditWindow = New mntZaimu.Zaimu
            objEditWindow.ZaimuCd = strSetKey

        '�����A�g���e�[�u��
        Case TABLE_ZAIMUINFO
            Set objEditWindow = New mntZaimuInfo.ZaimuInfo
'            objEditWindow.ZaimuCd = strSetKey

        '���������ރe�[�u��
        Case TABLE_BILLCLASS
            Set objEditWindow = New mntBillClass.BillClass
            objEditWindow.BillClassCd = strSetKey

        '�������ו��ރe�[�u��
        Case TABLE_DMDLINECLASS
            Set objEditWindow = New mntDmdLineClass.DmdLineClass
            objEditWindow.DmdLineClassCd = strSetKey

        '�܂�ߕ��ރe�[�u��
        Case TABLE_ROUNDCLASS
            Set objEditWindow = New mntRoundClass.RoundClass
            objEditWindow.RoundClassCd = strSetKey

'### 2004/1/15 Added by Ishihara@FSIT �Z�b�g�O�������גǉ�
        '�Z�b�g�O�������ו��ރe�[�u��
        Case TABLE_OTHERLINEDIV
            Set objEditWindow = New mntOtherLineDiv.OtherLineDiv
            objEditWindow.OtherLineDivCd = strSetKey
'### 2004/1/15 Added End

'## 2004.05.28 ADD STR ORB)T.YAGUCHI �Q����������
        '�Q���������׃e�[�u��
        Case TABLE_SECONDLINEDIV
            Set objEditWindow = New mntSecondLineDiv.SecondLineDiv
            objEditWindow.SecondLineDivCd = strSetKey
'### 2004/1/15 Added End

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        '�\�񃁁[�����M�ݒ�i��{�ݒ�j
        Case TABLE_MAILCONF
            Set objEditWindow = New mntMailConf.MailConf
        
        '���[���e���v���[�g�e�[�u��
        Case TABLE_MAILTEMPLATE
            Set objEditWindow = New mntMailTemplate.MailTemplate
            objEditWindow.TemplateCd = strSetKey
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####
        
        '�����e�[�u��
        Case TABLE_RELATION
            Set objEditWindow = New mntRelation.Relation
            objEditWindow.RelationCd = strSetKey

        '�R�����g��񕪗ރe�[�u��
        Case TABLE_PUBNOTEDIV
            Set objEditWindow = New mntPubNoteDiv.PubNotediv
            objEditWindow.PubNoteDivCd = strSetKey

        '�s���{���e�[�u��
        Case TABLE_PREF
            Set objEditWindow = New mntPref.Pref
            objEditWindow.PrefCd = strSetKey

        '���͕��ރe�[�u��
        Case TABLE_STCCLASS
            Set objEditWindow = New mntStcClass.StcClass
            objEditWindow.StcClassCd = strSetKey

        '���[�Ǘ�
        Case TABLE_REPORT
            Set objEditWindow = New mntReport.Report
            objEditWindow.ReportCd = strSetKey

        '�V�X�e�����ݒ�
        Case TABLE_SYSPROSUB
            Set objEditWindow = New mntSysPro.SysPro
            objEditWindow.TargetSysPro = strSetKey

        '�ėp�e�[�u��
        Case TABLE_FREE
            Set objEditWindow = New mntSysPro.SysPro
            objEditWindow.TargetSysPro = TARGETSYSPRO_FREE
            objEditWindow.FreeCd = strSetKey

        '�[���Ǘ��e�[�u��
        Case TABLE_WORKSTATION
            Set objEditWindow = New mntWorkStation.WorkStation
            objEditWindow.IpAddress = strSetKey

        '���[�U�e�[�u��
        Case TABLE_HAINSUSER
            Set objEditWindow = New mntHainsUser.HainsUser
            objEditWindow.UserID = strSetKey

        '��l�̍Đݒ�
        Case TABLE_UPDSTDVALUE
            frmUpdStdValue.Show vbModal
            Exit Function

        '��������
        Case NODE_SEARCH
            Call CntlViewMode(False)
            Exit Function

'### 2005.03.25  Add by ��
        Case NODE_SECURITY_MENUGRP, NODE_SECURITY_USERGRP, NODE_SECURITY_PWD
            Set objEditWindow = New mntSysPro.SysPro
            objEditWindow.TargetSysPro = TARGETSYSPRO_FREE
            objEditWindow.FreeCd = strSetKey
            
'### 2005.03.25  Add by End ...


        Case Else

            '�˗����ڃe�[�u��
            If Mid(vntNodeKey, 1, Len(TABLE_ITEM_P)) = TABLE_ITEM_P Then
                Set objEditWindow = New mntItem_P.Item_P
                With objEditWindow
                    .ItemCd = strSetKey
                End With
            End If

            '�������ڃe�[�u��
            If Mid(vntNodeKey, 1, Len(TABLE_ITEM_C)) = TABLE_ITEM_C Then
                Set objEditWindow = New mntItem_c.Item_c

                '�������ڃR�[�h�ƃT�t�B�b�N�X�𔲂�
                Call SplitItemAndSuffix(strSetKey, strItemCd, strSuffix)
                With objEditWindow
                    .ItemCd = strItemCd
                    .Suffix = strSuffix
                End With
            End If

            '�v�Z�e�[�u��
            If Mid(vntNodeKey, 1, Len(TABLE_CALC)) = TABLE_CALC Then
                Set objEditWindow = New mntCalc.Calc

                If Trim(strSetKey) <> "" Then
                    '�X�V���͌������ڃR�[�h�ƃT�t�B�b�N�X�𔲂�
                    Call SplitItemAndSuffix(lsvView.ListItems(vntItemKey).Text, strItemCd, strSuffix)
                Else
                    '�V�K�쐬���͌������ڃK�C�h��\��
                    If ShowItemGuide(strItemCd, strSuffix, , RESULTTYPE_CALC) = False Then
                        Exit Function
                    End If
                End If

                With objEditWindow
'                    .stdValueMngCd = strSetKey
                    .ItemCd = strItemCd
                    .Suffix = strSuffix
                End With

            End If

            '��l�e�[�u��
            If Mid(vntNodeKey, 1, Len(TABLE_STDVALUE)) = TABLE_STDVALUE Then
                Set objEditWindow = New mntStdValue.StdValue

                If Trim(strSetKey) <> "" Then
                    '�X�V���͌������ڃR�[�h�ƃT�t�B�b�N�X�𔲂�
                    Call SplitItemAndSuffix(lsvView.ListItems(vntItemKey).Text, strItemCd, strSuffix)
                Else
                    '�V�K�쐬���͌������ڃK�C�h��\��
                    If ShowItemGuide(strItemCd, strSuffix, Mid(vntNodeKey, Len(TABLE_STDVALUE) + 1, Len(vntNodeKey))) = False Then
                        Exit Function
                    End If
                End If

                With objEditWindow
                    .StdValueMngCd = strSetKey
                    .ItemCd = strItemCd
                    .Suffix = strSuffix
                End With

            End If

'### 2008.02.10 Add by �� ���茒�f��l�ǉ� ###############################
            '���茒�f�p��l�e�[�u��
            If Mid(vntNodeKey, 1, Len(TABLE_SP_STDVALUE)) = TABLE_SP_STDVALUE Then
                Set objEditWindow = New mntSpStdValue.SpStdValue

                If Trim(strSetKey) <> "" Then
                    '�X�V���͌������ڃR�[�h�ƃT�t�B�b�N�X�𔲂�
                    Call SplitItemAndSuffix(lsvView.ListItems(vntItemKey).Text, strItemCd, strSuffix)
                Else
                    '�V�K�쐬���͌������ڃK�C�h��\��
                    If ShowItemGuide(strItemCd, strSuffix, Mid(vntNodeKey, Len(TABLE_SP_STDVALUE) + 1, Len(vntNodeKey))) = False Then
                        Exit Function
                    End If
                End If

                With objEditWindow
                    .SpStdValueMngCd = strSetKey
                    .ItemCd = strItemCd
                    .Suffix = strSuffix
                End With

            End If
'### 2008.02.10 Add End ###################################################

            '���̓e�[�u��
            If (Mid(vntNodeKey, 1, Len(TABLE_SENTENCE_REC)) = TABLE_SENTENCE_REC) Or _
               (Mid(vntNodeKey, 1, Len(TABLE_SENTENCE_ITEM)) = TABLE_SENTENCE_ITEM) Then

                strItemCd = ""
                strItemName = ""
                strItemType = 0
                strStcCd = ""
                strSuffix = ""

                If strSetKey <> "" Then
                    '�������ڃR�[�h�ƍ��ڃ^�C�v�𔲂�
                    Call SplitItemAndSuffix(strSetKey, strItemCd, strItemType)

                    '���̓��R�[�h�̏ꍇ�A����ɃL�[�𕪊�
                    If (Mid(vntNodeKey, 1, Len(TABLE_SENTENCE_REC)) = TABLE_SENTENCE_REC) Then
                        '���ڃ^�C�v�ƕ��̓R�[�h�𔲂��i�J�n�ʒu�͌������ڃR�[�h���{���ڃ^�C�v�j
                        Call SplitItemAndSuffix(Mid(strSetKey, Len(strItemCd) + 2, Len(strSetKey) - Len(strItemCd) + 2), _
                                                strItemType, _
                                                strStcCd)
                        '�\���p�Ɍ������ږ��̂𔲂�
                        strItemName = lsvView.ListItems(vntItemKey).SubItems(1)
                    Else
                        '�T�t�B�b�N�X�Z�b�g
                        strSuffix = strItemType
                        strItemType = 0
                        '�\���p�Ɍ������ږ��̂𔲂�
                        strItemName = lsvView.ListItems(vntItemKey).SubItems(1)
                    End If

                End If

                Set objEditWindow = New mntSentence.Sentence
                With objEditWindow
                    .ItemCd = strItemCd
                    .Suffix = strSuffix
                    .ItemName = strItemName
                    .ItemType = CInt(strItemType)
                    .StcCd = strStcCd
                End With

            End If

            '��^�����e�[�u��
            If Mid(vntNodeKey, 1, Len(TABLE_STDJUD)) = TABLE_STDJUD Then
                '�m�[�h�̎擾
                Set colNodes = trvMaster.Nodes
                Set objEditWindow = New mntStdJud.StdJud

                '�������ڃR�[�h�ƃT�t�B�b�N�X�𔲂�
                Call SplitItemAndSuffix(strSetKey, strSplitKey1, strSplitKey2)

                With objEditWindow
                    If Trim(strSetKey) <> "" Then
                        .JudClassCd = strSplitKey1
                    Else
                        If trvMaster.Visible = True Then
                            '�t�H���_���[�h�Ȃ画�蕪�ރR�[�h�Z�b�g
                            .JudClassCd = CInt(Mid(vntNodeKey, Len(TABLE_STDJUD) + 1, Len(vntNodeKey)))
                        End If
                    End If

'                    .JudClassName = colNodes.Item(vntNodeKey).Text
'                    .StdJudCd = strSetKey
                    .StdJudCd = strSplitKey2
                End With
            End If


            '�w�����e�e�[�u��
            If Mid(vntNodeKey, 1, Len(TABLE_GUIDANCE)) = TABLE_GUIDANCE Then
                Set objEditWindow = New mntGuidance.Guidance
                With objEditWindow
                    .GuidanceCd = strSetKey
                    If trvMaster.Visible = True Then
                        '�t�H���_���[�h�̏ꍇ�A���蕪�ރR�[�h���Z�b�g����
                        .JudClassCd = Mid(vntNodeKey, Len(TABLE_GUIDANCE) + 1, Len(vntNodeKey))
                    End If
                End With
            End If

'            Case TABLE_GUIDANCE
'                Set objEditWindow = New mntGuidance.Guidance
'                objEditWindow.GuidanceCd = strSetKey

            '����R�����g�e�[�u��
            If Mid(vntNodeKey, 1, Len(TABLE_JUDCMTSTC)) = TABLE_JUDCMTSTC Then
                Set objEditWindow = New mntJudCmtStc.JudCmtStc
                With objEditWindow
                    .JudCmtCd = strSetKey
                    If trvMaster.Visible = True Then
                        '�t�H���_���[�h�̏ꍇ�A���蕪�ރR�[�h���Z�b�g����
                        .JudClassCd = Mid(vntNodeKey, Len(TABLE_JUDCMTSTC) + 1, Len(vntNodeKey))
                    End If
                End With
            End If
    
    
'### 2005.3.23  Add by ��
            If Mid(vntNodeKey, 1, Len(TABLE_SECURITYGRP)) = TABLE_SECURITYGRP Then
                Set objEditWindow = New mntSecurityPgmGrp.SecurityPgm
                
                If strSetKey <> "" Then         '�J��
                    objEditWindow.SetMode = 0
                    objEditWindow.SetUserGrpCd = trvMaster.Nodes.Item(trvMaster.SelectedItem.Index).Key
                    objEditWindow.SetUserGrpName = trvMaster.Nodes.Item(trvMaster.SelectedItem.Index).Text
                    objEditWindow.SetSecurityGrpCd = strSetKey
                    objEditWindow.SetSecurityGrpName = lsvView.SelectedItem.ListSubItems.Item(2).Text
                Else                            '�V�K
                    objEditWindow.SetMode = 1
                End If
            End If
            
            If Mid(vntNodeKey, 1, Len(TABLE_MENUPGM)) = TABLE_MENUPGM Then
                Set objEditWindow = New mntPgmInfo.PgmInfo

                If strSetKey <> "" Then         '�J��
'                    objEditWindow.PgmInfoCd = trvMaster.Nodes.Item(trvMaster.SelectedItem.Index).Key
                    objEditWindow.PgmInfoCd = strSetKey
                Else                            '�V�K

                End If
            End If
            
            
'### 2005.3.23  Add End ...

    
    End Select
    
    '�e�[�u�������e�i���X��ʂ��J��
    objEditWindow.Show vbModal
    
    '�X�V��Ԃ�߂�l�ɕԂ�
    ShowEditWindow = objEditWindow.Updated
    
    '�I�u�W�F�N�g�̔p���i�g�����U�N�V������Commit����Ȃ��j
    Set objEditWindow = Nothing
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Number & ":" & Err.Description, vbCritical, Err.Source
    Set objEditWindow = Nothing
    
End Function

'
' �@�\�@�@ : �e�[�u�����R�[�h���폜����
'
' �����@�@ : (In)   strNodeKey  (���X�g�A�C�e����)�m�[�h�L�[
' �@�@�@�@ : (In)   strItemKey  (���X�g�A�C�e����)�A�C�e���L�[
'
' �߂�l�@ :
'
' ���l�@�@ : ���������}�X�^���Ƀv���V�[�W���ǉ�����̂͌��Ȃ̂ŁA���C�g�o�C���h�őΉ�
'
Private Function DeleteRecord(ByVal strNodeKey As String, ByVal strItemKey As String) As Boolean

On Error GoTo ErrorHandle

    Dim objTargetMaster As Object                   '�e�[�u���A�N�Z�X�p
    Dim vntKey          As Variant                  '���R�[�h�L�[
    Dim strItemCd       As String                   '�X�v���b�g�p�L�[
    Dim strSuffix       As String                   '�X�v���b�g�p�L�[
    Dim strItemType     As String                   '�X�v���b�g�p�L�[
    Dim strStcCd        As String                   '�X�v���b�g�p�L�[
    
    Dim strSplitKey1    As String                   '�X�v���b�g�p�L�[
    Dim strSplitKey2    As String                   '�X�v���b�g�p�L�[
    
    DeleteRecord = False
    
    '�L�[�l�̎擾
    If Not IsMissing(strItemKey) Then
        vntKey = SplitKey(KEY_PREFIX, strItemKey)
    End If
    
    '�L�[��񂪑��݂��Ȃ��ꍇ�͉������Ȃ�
    If IsEmpty(strItemKey) Then
        Exit Function
    End If
    
    Select Case strNodeKey
        
        '�������ރe�[�u��
        Case TABLE_ITEMCLASS
            Set objTargetMaster = CreateObject("HainsItem.Item")
            objTargetMaster.DeleteItemClass vntKey(0)
        
        '�i���Ǘ��p���ރe�[�u��
        Case TABLE_PROGRESS
            Set objTargetMaster = CreateObject("HainsProgress.Progress")
            objTargetMaster.DeleteProgress vntKey(0)
        
        '�������{�����ރe�[�u��
        Case TABLE_OPECLASS
            Set objTargetMaster = CreateObject("HainsOpeClass.OpeClass")
            objTargetMaster.DeleteOpeClass vntKey(0)
        
        '�R�[�X�e�[�u��
        Case TABLE_COURSE
            Set objTargetMaster = CreateObject("HainsCourse.Course")
            objTargetMaster.DeleteCourse_p vntKey(0)
        
        '�Z�b�g���ރe�[�u��
        Case TABLE_SETCLASS
            Set objTargetMaster = CreateObject("HainsSetClass.SetClass")
            objTargetMaster.DeleteSetClass vntKey(0)
        
        '�\��g�e�[�u��
        Case TABLE_RSVFRA
            Set objTargetMaster = CreateObject("HainsSchedule.Schedule")
            objTargetMaster.DeleteRsvFra vntKey(0)
    
        '�\��Q�e�[�u��
        Case TABLE_RSVGRP
            Set objTargetMaster = CreateObject("HainsSchedule.Schedule")
            objTargetMaster.DeleteRsvGrp vntKey(0)

        '�R�[�X��f�\��Q
        Case TABLE_COURSE_RSVGRP
            Set objTargetMaster = CreateObject("HainsSchedule.Schedule")
                
            '�L�[�l�𕪊�
            Call SplitItemAndSuffix(CStr(vntKey(0)), strSplitKey1, strSplitKey2)
            objTargetMaster.DeleteCourseRsvGrp strSplitKey1, strSplitKey2
    
        '�O���[�v�e�[�u��
        Case TABLE_GRP_R, TABLE_GRP_I
'### 2003.03.13 Added by Ishihara@FSIT �V�X�e���g�p�O���[�v�͊ȒP�ɏ����Ȃ��悤�ɂ���B
            '�V�X�e���g�p�O���[�v�̏ꍇ�A�폜�ł��Ȃ��悤�ɂ���B
            If lsvView.SelectedItem.ListSubItems(3) <> "" Then
                MsgBox "�폜�w�肳�ꂽ�O���[�v�́u�V�X�e���g�p�O���[�v�v�Ƃ��Đݒ肳��Ă��܂��B" & vbLf & _
                       "���[�o�͎��ȂǁA�V�X�e�������Ŏg�p����Ă���\�������邽�ߍ폜�ł��܂���B" & vbLf & vbLf & _
                       "���폜�\�Ȋm�F���Ƃ�Ă���̂ł���΁A�O���[�v�����e�i���X��ʂ�" & vbLf & _
                       "�u���̃O���[�v�͒ʏ�Ɩ���ʂɕ\�����Ȃ��v�`�F�b�N�{�b�N�X���͂������Ƃɂ��" & vbLf & _
                       "�폜���邱�Ƃ͉\�ł��B", vbCritical
                Exit Function
            End If
'### 2003.03.13 Added End
            
            Set objTargetMaster = CreateObject("HainsGrp.Grp")
            objTargetMaster.DeleteGrp_p vntKey(0)
            
'****FJTH)2004/10/4M,E �c�̃O���[�v�Ή� -S ********************************************************************
         Case TABLE_ORGGRP
         
            '�V�X�e���g�p�O���[�v�̏ꍇ�A�폜�ł��Ȃ��悤�ɂ���B
            If lsvView.SelectedItem.ListSubItems(2) <> "" Then
                MsgBox "�폜�w�肳�ꂽ�O���[�v�́u�V�X�e���g�p�O���[�v�v�Ƃ��Đݒ肳��Ă��܂��B" & vbLf & _
                       "���[�o�͎��ȂǁA�V�X�e�������Ŏg�p����Ă���\�������邽�ߍ폜�ł��܂���B" & vbLf & vbLf & _
                       "���폜�\�Ȋm�F���Ƃ�Ă���̂ł���΁A�O���[�v�����e�i���X��ʂ�" & vbLf & _
                       "�u���̃O���[�v�͒ʏ�Ɩ���ʂɕ\�����Ȃ��v�`�F�b�N�{�b�N�X���͂������Ƃɂ��" & vbLf & _
                       "�폜���邱�Ƃ͉\�ł��B", vbCritical
                Exit Function
            End If
            
            Set objTargetMaster = CreateObject("HainsOrgGrp.Grp")
            objTargetMaster.DeleteGrp_p vntKey(0)
'****FJTH)2004/10/4M,E �c�̃O���[�v�Ή� -E ********************************************************************
       
       
        '���ʃR�����g�e�[�u��
        Case TABLE_RSLCMT
            Set objTargetMaster = CreateObject("HainsRslCmt.RslCmt")
            objTargetMaster.DeleteRslCmt vntKey(0)
        
        '���蕪�ރe�[�u��
        Case TABLE_JUDCLASS
            Set objTargetMaster = CreateObject("HainsJudClass.JudClass")
            objTargetMaster.DeleteJudClass vntKey(0)
        
        '����e�[�u��
        Case TABLE_JUD
            Set objTargetMaster = CreateObject("HainsJud.Jud")
            objTargetMaster.DeleteJud vntKey(0)
        
        '�h�{�v�Z�ڕW�ʃe�[�u��
        Case TABLE_NUTRITARGET
            Set objTargetMaster = CreateObject("HainsNourishment.Nourishment")
 '           objTargetMaster.DeleteNutriFoodEnergy vntKey(0)
    
        '�H�i�Q�ʐێ�e�[�u��
        Case TABLE_NUTRIFOODENERGY
            Set objTargetMaster = CreateObject("HainsNourishment.Nourishment")
            objTargetMaster.DeleteNutriFoodEnergy vntKey(0)
        
        '�\���H�i�e�[�u��
        Case TABLE_NUTRICOMPFOOD
            Set objTargetMaster = CreateObject("HainsNourishment.Nourishment")
            objTargetMaster.DeleteNutriCompFood vntKey(0)
        
        '�h�{�������X�g�e�[�u��
        Case TABLE_NUTRIMENULIST
            Set objTargetMaster = CreateObject("HainsNourishment.Nourishment")
'            objTargetMaster.DeleteNutriFoodEnergy vntKey(0)
        
        '�a�ރe�[�u��
        Case TABLE_DISDIV
            Set objTargetMaster = CreateObject("HainsDisease.Disease")
            objTargetMaster.DeleteDisDiv vntKey(0)
        
        '�a���e�[�u��
        Case TABLE_DISEASE
            Set objTargetMaster = CreateObject("HainsDisease.Disease")
            objTargetMaster.DeleteDisease vntKey(0)
        
        '�����K�p�e�[�u��
        Case TABLE_ZAIMU
            Set objTargetMaster = CreateObject("HainsZaimu.Zaimu")
            objTargetMaster.DeleteZaimu vntKey(0)
        
        '���������ރe�[�u��
        Case TABLE_BILLCLASS
            Set objTargetMaster = CreateObject("HainsDmdClass.DmdClass")
            objTargetMaster.DeleteBillClass vntKey(0)
        
        '�������ו��ރe�[�u��
        Case TABLE_DMDLINECLASS
            Set objTargetMaster = CreateObject("HainsDmdClass.DmdClass")
            objTargetMaster.DeleteDmdLineClass vntKey(0)
        
'### 2004/1/15 Added by Ishihara@FSIT �Z�b�g�O�������גǉ�
        '�Z�b�g�O�������׃e�[�u��
        Case TABLE_OTHERLINEDIV
            Set objTargetMaster = CreateObject("HainsPerBill.PerBill")
            objTargetMaster.DeleteOtherLineDiv vntKey(0)
'### 2004/1/15 Added End

'## 2004.05.28 ADD STR ORB)T.YAGUCHI �Q����������
        '�Q���������׃e�[�u��
        Case TABLE_SECONDLINEDIV
            Set objTargetMaster = CreateObject("HainsSecondBill.SecondBill")
            objTargetMaster.DeleteSecondLineDiv vntKey(0)
'### 2004/1/15 Added End

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        '���[���e���v���[�g�e�[�u��
        Case TABLE_MAILTEMPLATE
            Set objTargetMaster = CreateObject("HainsMail.Template")
            objTargetMaster.DeleteMailTemplate vntKey(0)
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####

        '�܂�ߕ��ރe�[�u��
        Case TABLE_ROUNDCLASS
            Set objTargetMaster = CreateObject("HainsRoundClass.RoundClass")
            objTargetMaster.DeleteRoundClass vntKey(0)
        
        '�s���{���e�[�u��
        Case TABLE_PREF
            Set objTargetMaster = CreateObject("HainsPref.Pref")
            objTargetMaster.DeletePref vntKey(0)
        
        'WEB�R�[�X�ݒ�
        Case TABLE_WEB_CS
            Set objTargetMaster = CreateObject("HainsWeb_Cs.Web_Cs")
            objTargetMaster.DeleteWeb_Cs vntKey(0)
        
        '���[�Ǘ�
        Case TABLE_REPORT
            Set objTargetMaster = CreateObject("HainsReport.Report")
            objTargetMaster.DeleteReport vntKey(0)
        
        '����
        Case TABLE_RELATION
            Set objTargetMaster = CreateObject("HainsPerson.Person")
            objTargetMaster.DeleteRelation vntKey(0)
        
        '�R�����g����
        Case TABLE_PUBNOTEDIV
            Set objTargetMaster = CreateObject("HainsPubNote.PubNote")
            objTargetMaster.DeletePubNoteDiv vntKey(0)
    
        '�ėp�e�[�u��
        Case TABLE_FREE
            Set objTargetMaster = CreateObject("HainsFree.Free")
            objTargetMaster.DeleteFree vntKey(0)
    
        '�[���Ǘ��e�[�u��
        Case TABLE_WORKSTATION
            Set objTargetMaster = CreateObject("HainsWorkStation.WorkStation")
            objTargetMaster.DeleteWorkStation vntKey(0)
    
        '���[�U�e�[�u��
        Case TABLE_HAINSUSER
            Set objTargetMaster = CreateObject("HainsHainsUser.HainsUser")
            objTargetMaster.DeleteHainsUser vntKey(0)
    
        '���͕��ރe�[�u��
        Case TABLE_STCCLASS
            Set objTargetMaster = CreateObject("HainsSentence.Sentence")
            objTargetMaster.DeleteStcClass vntKey(0)
    
        '��^�ʐڕ��̓e�[�u��
        Case TABLE_STDCONTACTSTC
            
            '�w�����e�敪�ƒ�^�ʐڕ��̓R�[�h�𔲂��i�������Ƃ��Ă�Itemcd,Suffix�ł͂Ȃ����A�ϐ��̈�ߖ�Ɓj
            Call SplitItemAndSuffix(CStr(vntKey(0)), strItemCd, strSuffix)
            
            Set objTargetMaster = CreateObject("HainsStdContactStc.StdContactStc")
            objTargetMaster.DeleteStdContactStc strItemCd, strSuffix
    
        Case Else

            '�˗����ڃe�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_ITEM_P)) = TABLE_ITEM_P Then
                Set objTargetMaster = CreateObject("HainsItem.Item")
                objTargetMaster.DeleteItem_p vntKey(0)
            End If
            
            '�������ڃe�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_ITEM_C)) = TABLE_ITEM_C Then
                
                '�������ڃR�[�h�ƃT�t�B�b�N�X�𔲂�
                Call SplitItemAndSuffix(CStr(vntKey(0)), strItemCd, strSuffix)
                
                Set objTargetMaster = CreateObject("HainsItem.Item")
                objTargetMaster.DeleteItem_c strItemCd, strSuffix
            
            End If
            
            '�v�Z�e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_CALC)) = TABLE_CALC Then
                
                '�������ڃR�[�h�ƃT�t�B�b�N�X�𔲂�
                Call SplitItemAndSuffix(CStr(vntKey(0)), strItemCd, strSuffix)
                
                Set objTargetMaster = CreateObject("HainsCalc.Calc")
                objTargetMaster.DeleteCalc strItemCd, strSuffix
            
            End If
            
            '��l�e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_STDVALUE)) = TABLE_STDVALUE Then
                Set objTargetMaster = CreateObject("HainsStdValue.StdValue")
                objTargetMaster.DeleteStdValue vntKey(0)
            End If
            
'### 2008.02.10 Add by �� ���茒�f��l�ǉ� ###############################
            
            '���茒�f�p��l�e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_SP_STDVALUE)) = TABLE_SP_STDVALUE Then
                Set objTargetMaster = CreateObject("HainsSpStdValue.SpStdValue")
                objTargetMaster.DeleteSpStdValue vntKey(0)
            End If
            
'### 2008.02.10 Add End ###################################################
            
            '���̓e�[�u���i���̓��R�[�h�j
            If (Mid(strNodeKey, 1, Len(TABLE_SENTENCE_REC)) = TABLE_SENTENCE_REC) Then
                
                strItemCd = ""
                strItemType = 0
                strStcCd = ""
                
                '�������ڃR�[�h�ƍ��ڃ^�C�v�𔲂�
                Call SplitItemAndSuffix(CStr(vntKey(0)), strItemCd, strItemType)
                
                '���ڃ^�C�v�ƕ��̓R�[�h�𔲂��i�J�n�ʒu�͌������ڃR�[�h���{���ڃ^�C�v�j
                Call SplitItemAndSuffix(Mid(vntKey(0), Len(strItemCd) + 2, Len(vntKey(0)) - Len(strItemCd) + 2), _
                                        strItemType, _
                                        strStcCd)
                
                Set objTargetMaster = CreateObject("HainsSentence.Sentence")
                objTargetMaster.DeleteSentence strItemCd, CInt(strItemType), strStcCd
            
            End If
            
            '��^�����e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_STDJUD)) = TABLE_STDJUD Then
                
                '�L�[�l�𕪊�
                Call SplitItemAndSuffix(CStr(vntKey(0)), strSplitKey1, strSplitKey2)
                Set objTargetMaster = CreateObject("HainsStdJud.StdJud")
                objTargetMaster.DeleteStdJud strSplitKey1, strSplitKey2
            End If
            
            '����R�����g�e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_JUDCMTSTC)) = TABLE_JUDCMTSTC Then
                Set objTargetMaster = CreateObject("HainsJudCmtStc.JudCmtStc")
                objTargetMaster.DeleteJudCmtStc vntKey(0)
            End If
    
            '�w�����̓e�[�u��
            If Mid(strNodeKey, 1, Len(TABLE_GUIDANCE)) = TABLE_GUIDANCE Then
                Set objTargetMaster = CreateObject("HainsGuidance.Guidance")
                objTargetMaster.DeleteGuidance vntKey(0)
            End If
    
    End Select
    
    '�I�u�W�F�N�g�p���iCommit?)
    Set objTargetMaster = Nothing
    
    DeleteRecord = True
    
    Exit Function
    
ErrorHandle:

    '�C�x���g���O��������
    WriteErrorLog "Mentenance.DeleteRecord"
    MsgBox EditAdditionalMessage(Err.Description), vbCritical
    Set objTargetMaster = Nothing
    
End Function

'
' �@�\�@�@ : ���X�g�ҏW
'
' �����@�@ : (In)      strNodeKey  �c���[�r���[�̃m�[�h�L�[
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListView(strNodeKey As String, Optional strItemKey As String)

    Dim colNodes    As Nodes    '�m�[�h�R���N�V����
    Dim objNode     As Node     '�m�[�h�I�u�W�F�N�g
    Dim objListItem As ListItem '���X�g�A�C�e���I�u�W�F�N�g
    
    '���X�g�A�C�e���N���A
    lsvView.ListItems.Clear
    lsvView.View = lvwList
    
    '�����\���̈�N���A
    stbMain.Panels.Item(1).Text = ""
    
    '�m�[�h�R���N�V�����̎擾
    Set colNodes = trvMaster.Nodes
    
    '�w��m�[�h���q�������Ȃ��ꍇ�A�e�R���e���c���̕ҏW
    If colNodes(strNodeKey).Children = 0 Then
        
        '���X�g�r���[��ҏW
        Call EditListViewFromContents(strNodeKey)
        
        '�A�C�e���L�[���Z�b�g����Ă���ꍇ�A���̍��ڂ�I����Ԃɂ���
        If strItemKey <> "" Then
            '�������ނ��ύX���ꂽ�ꍇ�Ȃǂ́A���̂��Ȃ��Ȃ邱�Ƃ�����̂�RESUME NEXT
            On Error Resume Next
            lsvView.ListItems(strItemKey).Selected = True
            lsvView.SelectedItem.EnsureVisible
            On Error GoTo 0
        End If
        
        Exit Sub
    End If
    
    '�w��m�[�h��e�ɂ��m�[�h�̓��e��ҏW
    For Each objNode In colNodes
        
        Do
            '�e�m�[�h���Ȃ���Ή������Ȃ�
            If objNode.Parent Is Nothing Then
                Exit Do
            End If
        
            '�e�m�[�h���w��m�[�h�ƈ�v���Ȃ��ꍇ�͉������Ȃ�
            If objNode.Parent.Key <> strNodeKey Then
                Exit Do
            End If
       
            '���X�g�A�C�e���̕ҏW
            Set objListItem = lsvView.ListItems.Add
            With objListItem
                .Text = objNode.Text
                .Key = objNode.Key
                .SmallIcon = ICON_CLOSED
                .Tag = NODE_TYPEFOLDER        '�f�[�^�Ƃ��Ẵ��X�g�A�C�e���Ƌ�ʂ���
            End With
            
            Exit Do
        Loop
    
    Next

End Sub

'
' �@�\�@�@ : ��^�ʐڕ��͈ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromStdContactStc(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objStdContactStc    As Object           '�s���{���A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntGuidanceDiv      As Variant          '�w�����e�敪
    Dim vntStdContactStcCd  As Variant          '��^�ʐڕ��̓R�[�h
    Dim vntContactStc       As Variant          '�ʐڕ���
    Dim i                   As Long             '�C���f�b�N�X
    Dim strUniqueKey        As String
    Dim strGuidanceDivName  As String
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStdContactStc = CreateObject("HainsStdContactStc.StdContactStc")
    lngCount = objStdContactStc.SelectStdContactStcList(vntGuidanceDiv, _
                                                        vntStdContactStcCd, _
                                                        vntContactStc)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�w�����e�敪", 1800, lvwColumnLeft
    objHeader.Add , , "��^�ʐڕ��̓R�[�h", 1800, lvwColumnLeft
    objHeader.Add , , "�ʐڕ���", 4000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        strUniqueKey = KEY_PREFIX & vntGuidanceDiv(i) & KEY_SEPARATE & vntStdContactStcCd(i)
        
        Select Case vntGuidanceDiv(i)
            Case "1"
                strGuidanceDivName = "�����̐���"
            Case "2"
                strGuidanceDivName = "�����E�H���w��"
            Case "3"
                strGuidanceDivName = "�o�ߒǐ�"
            Case "4"
                strGuidanceDivName = "�v��������"
            Case "5"
                strGuidanceDivName = "�v����"
            Case "6"
                strGuidanceDivName = "��f�̂�����"
            Case "7"
                strGuidanceDivName = "�^���w��"
            Case "8"
                strGuidanceDivName = "�S�����k"
            Case Else
                strGuidanceDivName = "�H�i" & vntGuidanceDiv(i) & "�j"
        End Select
        
        Set objItem = lsvView.ListItems.Add(, strUniqueKey, strGuidanceDivName, , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntStdContactStcCd(i)
        objItem.SubItems(2) = vntContactStc(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objStdContactStc = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objStdContactStc = Nothing
    
End Sub

'
' �@�\�@�@ : �������ו��ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromDmdLineClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objDmdLineClass         As Object           '�������ו��ރA�N�Z�X�p
    Dim objHeader               As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem                 As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntDmdLineClassCd       As Variant          '�������ו��ރR�[�h
    Dim vntDmdLineClassName     As Variant          '�������ו���
    Dim vntSumDetails           As Variant          '���f��{���W�v�t���O
    Dim vntIsrFlg               As Variant          '���ێg�p�t���O
'    Dim vntMakeBillLine         As Variant          '���������׍쐬�t���O
    Dim i                       As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDmdLineClass = CreateObject("HainsDmdClass.DmdClass")
    lngCount = objDmdLineClass.SelectDmdLineClassItemList(vntDmdLineClassCd, vntDmdLineClassName, vntSumDetails, vntIsrFlg)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���ו��ރR�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�������ו��ޖ�", 3000, lvwColumnLeft
    objHeader.Add , , "���f��{��", 1200, lvwColumnLeft
    objHeader.Add , , "�����ގg�p�Ώ�", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntDmdLineClassCd(i), vntDmdLineClassCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntDmdLineClassName(i)
        objItem.SubItems(2) = IIf(vntSumDetails(i) = "1", "�܂Ƃ߂�", "")
        Select Case vntIsrFlg(i)
            Case ""
                objItem.SubItems(3) = "���ہA�c�̗����Ŏg�p"
            Case "0"
                objItem.SubItems(3) = "��ʒc�̂̂�"
            Case "1"
                objItem.SubItems(3) = "���ۂ̂�"
        End Select
        
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objDmdLineClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objDmdLineClass = Nothing
    
End Sub
'### 2004/1/15 Added by Ishihara@FSIT �Z�b�g�O�������גǉ�
'
' �@�\�@�@ : �Z�b�g�O�������׈ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromOtherLineDiv(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objOtherLineDiv         As Object           '�Z�b�g�O�������׃A�N�Z�X�p
    Dim objHeader               As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem                 As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntOtherLineDivCd       As Variant          '�Z�b�g�O�������׃R�[�h
    Dim vntOtherLineDivName     As Variant          '�Z�b�g�O��������
    Dim vntStdPrice             As Variant          '�W���P��
    Dim vntStdTax               As Variant          '�W���Ŋz
    Dim i                       As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objOtherLineDiv = CreateObject("HainsPerBill.PerBill")
    lngCount = objOtherLineDiv.SelectOtherLineDiv(vntOtherLineDivCd, vntOtherLineDivName, vntStdPrice, vntStdTax)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�Z�b�g�O�������׃R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�Z�b�g�O�������ז�", 3000, lvwColumnLeft
    objHeader.Add , , "�W���P��", 1200, lvwColumnLeft
    objHeader.Add , , "�W���Ŋz", 1200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntOtherLineDivCd(i), vntOtherLineDivCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntOtherLineDivName(i)
        objItem.SubItems(2) = vntStdPrice(i)
        objItem.SubItems(3) = vntStdTax(i)
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objOtherLineDiv = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objOtherLineDiv = Nothing
    
End Sub

'## 2004.05.28 ADD STR ORB)T.YAGUCHI �Q����������
'
' �@�\�@�@ : �Q���������׈ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromSecondLineDiv(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objSecondLineDiv         As Object           '�Z�b�g�O�������׃A�N�Z�X�p
    Dim objHeader               As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem                 As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntSecondLineDivCd       As Variant          '�Z�b�g�O�������׃R�[�h
    Dim vntSecondLineDivName     As Variant          '�Z�b�g�O��������
    Dim vntStdPrice             As Variant          '�W���P��
    Dim vntStdTax               As Variant          '�W���Ŋz
    Dim i                       As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSecondLineDiv = CreateObject("HainsSecondBill.SecondBill")
    lngCount = objSecondLineDiv.SelectSecondLineDiv(vntSecondLineDivCd, vntSecondLineDivName, vntStdPrice, vntStdTax)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�Q���������׃R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�Q���������ז�", 3000, lvwColumnLeft
    objHeader.Add , , "�W���P��", 1200, lvwColumnLeft
    objHeader.Add , , "�W���Ŋz", 1200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntSecondLineDivCd(i), vntSecondLineDivCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntSecondLineDivName(i)
        objItem.SubItems(2) = vntStdPrice(i)
        objItem.SubItems(3) = vntStdTax(i)
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objSecondLineDiv = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSecondLineDiv = Nothing
    
End Sub


'
' �@�\�@�@ : ���������ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromBillClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objBillClass            As Object           '���������ރA�N�Z�X�p
    Dim objHeader               As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem                 As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntBillClassCd          As Variant          '���������ރR�[�h
    Dim vntBillClassName        As Variant          '����������
    Dim vntDefCheck             As Variant          '�f�t�H���g�`�F�b�N
    Dim vntOtherIncome          As Variant          '�G��������
    Dim vntCrfFileName          As Variant          '�o�̓t�@�C����
    Dim i                       As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objBillClass = CreateObject("HainsDmdClass.DmdClass")
    lngCount = objBillClass.SelectBillClassList(vntBillClassCd, vntBillClassName, vntDefCheck, vntOtherIncome, vntCrfFileName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���������ރR�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "���������ޖ�", 3000, lvwColumnLeft
    objHeader.Add , , "�G����", 800, lvwColumnLeft
    objHeader.Add , , "�c�̓o�^��", 1200, lvwColumnLeft
    objHeader.Add , , "�o�̓t�@�C����", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntBillClassCd(i), vntBillClassCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntBillClassName(i)
        objItem.SubItems(2) = IIf(vntOtherIncome(i) = "1", "�G����", "")
        objItem.SubItems(3) = IIf(vntDefCheck(i) = "1", "�f�t�H���g", "")
        objItem.SubItems(4) = vntCrfFileName(i)
        
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objBillClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objBillClass = Nothing
    
End Sub

'
' �@�\�@�@ : �R�����g��񕪗ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromPubNoteDiv(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objPubNoteDiv           As Object           '�R�����g���ރA�N�Z�X�p
    Dim objHeader               As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem                 As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntPubNoteDivCd         As Variant          '�R�����g���ރR�[�h
    Dim vntPubNoteDivName       As Variant          '�R�����g����
    Dim vntDefaultDispKbn       As Variant          '�\���Ώۋ敪�����l
    Dim vntOnlyDispKbn          As Variant          '�\���Ώۋ敪���΂�
    Dim i                       As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPubNoteDiv = CreateObject("HainsPubNote.PubNote")
'### 2004/1/15 Updated by Ishihara@FSIT ���\�b�h���ς���Ă��܂���...
'    lngCount = objPubNoteDiv.SelectPubNoteDivList(3, vntPubNoteDivCd, vntPubNoteDivName, vntDefaultDispKbn, vntOnlyDispKbn)
    lngCount = objPubNoteDiv.SelectAllPubNoteDivList(vntPubNoteDivCd, vntPubNoteDivName, vntDefaultDispKbn, vntOnlyDispKbn)
'### 2004/1/15 Updated End
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���ރR�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "���ޖ�", 2500, lvwColumnLeft
    objHeader.Add , , "�����l", 1200, lvwColumnLeft
    objHeader.Add , , "�\������", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntPubNoteDivCd(i), vntPubNoteDivCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntPubNoteDivName(i)
        Select Case vntDefaultDispKbn(i)
            Case "1"
                objItem.SubItems(2) = "��ÃR�����g"
            Case "2"
                objItem.SubItems(2) = "�����R�����g"
            Case "3"
                objItem.SubItems(2) = "����"
            Case Else
                objItem.SubItems(2) = "?=" & vntDefaultDispKbn(i)
        End Select
        
        Select Case vntOnlyDispKbn(i)
            Case ""
                objItem.SubItems(3) = ""
            Case "1"
                objItem.SubItems(3) = "��Ð�p�R�����g"
            Case "2"
                objItem.SubItems(3) = "������p�R�����g"
            Case Else
                objItem.SubItems(3) = "?=" & vntOnlyDispKbn(i)
        End Select
        
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objPubNoteDiv = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPubNoteDiv = Nothing
    
End Sub

'
' �@�\�@�@ : �a���ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromDisease(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objDisease      As Object           '�a���A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntDisCd        As Variant          '�a���R�[�h
    Dim vntDisName      As Variant          '�a��
    Dim vntDisDivName   As Variant          '�a��
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDisease = CreateObject("HainsDisease.Disease")
    lngCount = objDisease.SelectDiseaseItemList(vntDisCd, vntDisName, vntDisDivName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�a���R�[�h", 1200, lvwColumnLeft
    objHeader.Add , , "�a��", 3000, lvwColumnLeft
    objHeader.Add , , "�a��", 3000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntDisCd(i), vntDisCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntDisName(i)
        objItem.SubItems(2) = vntDisDivName(i)
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objDisease = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objDisease = Nothing
    
End Sub

'
' �@�\�@�@ : �a�ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromDisDiv(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objDisDiv       As Object           '�a�ރA�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntDisDivCd     As Variant          '�a�ރR�[�h
    Dim vntDisDivName   As Variant          '�a�ޖ�
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDisDiv = CreateObject("HainsDisease.Disease")
    lngCount = objDisDiv.SelectDisDivList(vntDisDivCd, vntDisDivName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�a�ރR�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�a�ޖ�", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntDisDivCd(i), vntDisDivCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntDisDivName(i)
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objDisDiv = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objDisDiv = Nothing
    
End Sub

'
' �@�\�@�@ : �܂�ߕ��ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromRoundClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRoundClass       As Object           '�܂�ߕ��ރA�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntRoundClassCd     As Variant          '�܂�ߕ��ރR�[�h
    Dim vntRoundClassName   As Variant          '�܂�ߕ��ޖ�
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRoundClass = CreateObject("HainsRoundClass.RoundClass")
    lngCount = objRoundClass.SelectRoundClassList(vntRoundClassCd, vntRoundClassName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�܂�ߕ��ރR�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�܂�ߕ��ޖ�", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRoundClassCd(i), vntRoundClassCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntRoundClassName(i)
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objRoundClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRoundClass = Nothing
    
End Sub

'
' �@�\�@�@ : ���͕��ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromStcClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objStcClass     As Object           '���͕��ރA�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntStcClassCd   As Variant          '���͕��ރR�[�h
    Dim vntStcClassName As Variant          '���͕��ޖ�
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStcClass = CreateObject("HainsSentence.Sentence")
    lngCount = objStcClass.SelectStcClassItemList(vntStcClassCd, vntStcClassName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���͕��ރR�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "���͕��ޖ�", 4500, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntStcClassCd(i), vntStcClassCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntStcClassName(i)
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objStcClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objStcClass = Nothing
    
End Sub

'
' �@�\�@�@ : �s���{���ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromPref(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objPref     As Object           '�s���{���A�N�Z�X�p
    Dim objHeader   As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem     As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntPrefCd   As Variant          '�s���{���R�[�h
    Dim vntPrefName As Variant          '�s���{����
    Dim i           As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPref = CreateObject("HainsPref.Pref")
    lngCount = objPref.SelectPrefList(vntPrefCd, vntPrefName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�s���{���R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�s���{����", 1100, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntPrefCd(i), vntPrefCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntPrefName(i)
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objPref = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPref = Nothing
    
End Sub

'
' �@�\�@�@ : �����ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromRelation(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRelation     As Object           '�����A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntRelationCd   As Variant          '�����R�[�h
    Dim vntRelationName As Variant          '������
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRelation = CreateObject("HainsPerson.Person")
    lngCount = objRelation.SelectRelationList(vntRelationCd, vntRelationName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�����R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "������", 4500, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRelationCd(i), vntRelationCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntRelationName(i)
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objRelation = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRelation = Nothing
    
End Sub

'
' �@�\�@�@ : ���[�U�ꗗ�\��
'
' �����@�@ : (Out)  lngCount          �������ʌ���
' �@�@�@�@ : (In)   vntSearchCode     �����p�R�[�h�i�ȗ��j
' �@�@�@�@ : (In)   vntSearchString   �����p������i�ȗ��j
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromHainsUser(strNodeKey As String, lngCount As Long, _
                                      Optional ByVal vntSearchCode As Variant, _
                                      Optional ByVal vntSearchString As Variant)

On Error GoTo ErrorHandle

    Dim objHainsUser     As Object           '���[�U�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntUserID       As Variant          '���[�U�R�[�h
    Dim vntUserName     As Variant          '���[�U��
    Dim vntDelFlg       As Variant          '�폜�t���O
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objHainsUser = CreateObject("HainsHainsUser.HainsUser")
    
    If (IsMissing(vntSearchCode) = False) Or (IsMissing(vntSearchCode) = False) Then
        lngCount = objHainsUser.SelectUserList(vntUserID, vntUserName, vntSearchCode, vntSearchString, vntDelFlg)
    Else
        lngCount = objHainsUser.SelectUserList(vntUserID, vntUserName, , , vntDelFlg)
    End If
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���[�U�h�c", 1500, lvwColumnLeft
    objHeader.Add , , "���[�U��", 4000, lvwColumnLeft
    objHeader.Add , , "�g�p���", 1000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntUserID(i), vntUserID(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntUserName(i)
        If vntDelFlg(i) = "1" Then
            objItem.SubItems(2) = "�~"
        End If
        objItem.Tag = strNodeKey
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objHainsUser = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objHainsUser = Nothing
    
End Sub

'
' �@�\�@�@ : �V�X�e�����ݒ�i�ėp�e�[�u���Aini�t�@�C���n�j
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromSysPro(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objHeader   As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem     As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim i           As Long             '�C���f�b�N�X
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���O", 1500, lvwColumnLeft
    objHeader.Add , , "����", 6200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & TARGETSYSPRO_PRICE, "�K�p���z", , "DEFAULTLIST")
    objItem.SubItems(1) = "�O���[�v�}�X�^�A�������ڃ}�X�^�Őݒ肳��Ă���Q�̋��z�̓K�p���@���w�肵�܂��B"
    objItem.Tag = strNodeKey
    
    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & TARGETSYSPRO_TAX, "�K�p�Ŋz", , "DEFAULTLIST")
    objItem.SubItems(1) = "����Ŋz�̐ݒ���s���܂��B"
    objItem.Tag = strNodeKey
    
'    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & TARGETSYSPRO_COURSEFRA, "�R�[�X�g�Ȃ��\��", , "DEFAULTLIST")
'    objItem.SubItems(1) = "�R�[�X�g��ݒ肵�Ȃ��܂܂̗\����\�ɂ��邩�ǂ�����ݒ肵�܂��B"
'
'    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & TARGETSYSPRO_BILLNO, "�R�[�X�g�Ȃ��\��", , "DEFAULTLIST")
'    objItem.SubItems(1) = "�R�[�X�g��ݒ肵�Ȃ��܂܂̗\����\�ɂ��邩�ǂ�����ݒ肵�܂��B"
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Sub

'
' �@�\�@�@ : ���[�ݒ�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromReport(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objReport               As Object           '���[�A�N�Z�X�p
    Dim objHeader               As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem                 As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntReportCd             As Variant          '���[�R�[�h
    Dim vntReportName           As Variant          '���[��
    Dim vntDefaultPrinter       As Variant
    Dim vntPrtMachine           As Variant
    Dim vntPreView              As Variant
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    Dim vntReportFlg            As Variant          '�񍐏��t���O
    Dim vntViewOrder            As Variant          '�\����
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####

    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objReport = CreateObject("HainsReport.Report")
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'    lngcount = objReport.SelectReportList(vntReportCd, _
'                                          vntReportName, _
'                                          , _
'                                          vntDefaultPrinter, _
'                                          vntPrtMachine, _
'                                          vntPreView)
    lngCount = objReport.SelectReportList(vntReportCd, _
                                          vntReportName, _
                                          vntReportFlg, _
                                          vntDefaultPrinter, _
                                          vntPrtMachine, _
                                          vntPreView, , , _
                                          vntViewOrder, _
                                          True)
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
        
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���[�R�[�h", 1000, lvwColumnLeft
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'    objHeader.Add , , "���[��", 2200, lvwColumnLeft
    objHeader.Add , , "���[��", 2900, lvwColumnLeft
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
    objHeader.Add , , "�o�͐�", 1100, lvwColumnLeft
    objHeader.Add , , "�o�͕��@", 1100, lvwColumnLeft
    objHeader.Add , , "�W���v�����^", 2200, lvwColumnLeft
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    objHeader.Add , , "�񍐏�", 750, lvwColumnCenter
    objHeader.Add , , "�\����", 750, lvwColumnLeft
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntReportCd(i), vntReportCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntReportName(i)
        
            If vntPrtMachine(i) = 1 Then
                .SubItems(2) = "�T�[�o"
            Else
                .SubItems(2) = "�N���C�A���g"
            End If
            
            If vntPreView(i) = 1 Then
                .SubItems(3) = "���ڏo��"
            Else
                .SubItems(3) = "�v���r���["
            End If
            
            .SubItems(4) = vntDefaultPrinter(i)
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
            .SubItems(5) = IIf(CLng("0" & vntReportFlg(i)) > 0, "��", "")
            .SubItems(6) = vntViewOrder(i)
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
        End With
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objReport = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objReport = Nothing
    
End Sub

'
' �@�\�@�@ : �ėp�e�[�u���ݒ�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromFree(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objFree                 As Object           '���[�A�N�Z�X�p
    Dim objHeader               As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem                 As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntFreeCd               As Variant          '���[�R�[�h
    Dim vntFreeName             As Variant          '���[��
    Dim vntFreeDate             As Variant
    Dim vntFreeField1           As Variant
    Dim vntFreeField2           As Variant
    Dim vntFreeField3           As Variant
    Dim vntFreeField4           As Variant
    Dim vntFreeField5           As Variant
'### 2003.02.15 Added by Ishihara@FSIT �t�B�[���h�ǉ�
    Dim vntFreeField6           As Variant
    Dim vntFreeField7           As Variant
'### 2003.02.15 Added End
    Dim vntFreeClassCd          As Variant

    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")
'### 2003.02.15 Added by Ishihara@FSIT �t�B�[���h�ǉ�
'    lngCount = objFree.SelectFree(2, _
                                  "", _
                                  vntFreeCd, _
                                  vntFreeName, _
                                  vntFreeDate, _
                                  vntFreeField1, _
                                  vntFreeField2, _
                                  vntFreeField3, _
                                  vntFreeField4, _
                                  vntFreeField5, _
                                  , _
                                  vntFreeClassCd)
    lngCount = objFree.SelectFree(2, _
                                  "", _
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
'### 2003.02.15 Added End
        
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�ėp�R�[�h", 1700, lvwColumnLeft
    objHeader.Add , , "�ėp����", 1000, lvwColumnLeft
    objHeader.Add , , "�ėp��", 1800, lvwColumnLeft
    objHeader.Add , , "�ėp���t", 1100, lvwColumnLeft
    objHeader.Add , , "�t�B�[���h�P", 1100, lvwColumnLeft
    objHeader.Add , , "�t�B�[���h�Q", 1100, lvwColumnLeft
    objHeader.Add , , "�t�B�[���h�R", 1100, lvwColumnLeft
    objHeader.Add , , "�t�B�[���h�S", 1100, lvwColumnLeft
    objHeader.Add , , "�t�B�[���h�T", 1100, lvwColumnLeft
'### 2003.02.15 Added by Ishihara@FSIT �t�B�[���h�ǉ�
    objHeader.Add , , "�t�B�[���h�U", 1100, lvwColumnLeft
    objHeader.Add , , "�t�B�[���h�V", 1100, lvwColumnLeft
'### 2003.02.15 Added End
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntFreeCd(i), vntFreeCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntFreeClassCd(i)
            .SubItems(2) = vntFreeName(i)
            .SubItems(3) = vntFreeDate(i)
            .SubItems(4) = vntFreeField1(i)
            .SubItems(5) = vntFreeField2(i)
            .SubItems(6) = vntFreeField3(i)
            .SubItems(7) = vntFreeField4(i)
            .SubItems(8) = vntFreeField5(i)
'### 2003.02.15 Added by Ishihara@FSIT �t�B�[���h�ǉ�
            .SubItems(9) = vntFreeField6(i)
            .SubItems(10) = vntFreeField7(i)
'### 2003.02.15 Added End
        End With
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objFree = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objFree = Nothing
    
End Sub

'
' �@�\�@�@ : �ėp�e�[�u���ݒ�ꗗ�\��
' �����@�@ :
' �߂�l�@ :
' ���l�@�@ : 2005.03.28 Add by ��
'
Private Sub EditListViewFromPgmInfoList(strNodeKey As String, lngCount As Long)
    On Error GoTo ErrorHandle

    Dim colNodes            As Nodes            '�m�[�h�R���N�V����
    Dim objNode             As Node             '�m�[�h�I�u�W�F�N�g
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objListItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim objPgmInfo          As Object           '���ʃR�����g�A�N�Z�X�p
    
    Dim vntPgmCd            As Variant          '�v���O�����R�[�h
    Dim vntPgmName          As Variant          '�v���O������
    Dim vntStartPgm         As Variant          '�N���v���O����
    '2005.07.26 Add (ST)
    Dim vntFilePath         As Variant
    '2005.07.26 Add (END)
    Dim vntLinkImage        As Variant          '�����N�C���[�W
    Dim vntMenuGrpCd        As Variant          '���j���[�O���[�v�R�[�h
    Dim vntPgmDesc          As Variant          '�v���O��������
    Dim vntDelFlag          As Variant          '
    Dim vntMenuName         As Variant          '
    
    Dim vntYudoBunrui       As Variant          '�U����������
    Dim vntYobi1            As Variant          '�\��1
    Dim vntYobi2            As Variant          '�\��2
    
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�e�m�[�h�̕ҏW
    Set colNodes = trvMaster.Nodes
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objPgmInfo = CreateObject("HainsPgmInfo.PgmInfo")
    lngCount = objPgmInfo.SelectPgmInfo(strNodeKey, _
                                            2, _
                                            vntPgmCd, _
                                            vntPgmName, _
                                            vntStartPgm, _
                                            vntFilePath, _
                                            vntLinkImage, _
                                            vntMenuGrpCd, _
                                            vntPgmDesc, _
                                            vntDelFlag, _
                                            vntMenuName, _
                                            vntYudoBunrui, _
                                            vntYobi1, _
                                            vntYobi2)

    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�v���O��������", 2700, lvwColumnLeft
    objHeader.Add , , "DEL", 500, lvwColumnLeft
    objHeader.Add , , "�N���v���O����", 1500, lvwColumnLeft
    objHeader.Add , , "�v���O�����o�H", 2500, lvwColumnLeft
    objHeader.Add , , "�����N�C���[�W", 1500, lvwColumnLeft
    objHeader.Add , , "���j���[�O���[�v�R�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "���j���[�O���[�v��", 1000, lvwColumnLeft
    objHeader.Add , , "�U����������", 1000, lvwColumnLeft
    objHeader.Add , , "�v���O��������", 3000, lvwColumnLeft

    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objListItem = lsvView.ListItems.Add(, KEY_PREFIX & vntPgmCd(i), vntPgmCd(i), , "DEFAULTLIST")
        With objListItem
            .Tag = strNodeKey
            .SubItems(1) = vntPgmName(i)
            .SubItems(2) = vntDelFlag(i)
            .SubItems(3) = vntStartPgm(i)
            .SubItems(4) = vntFilePath(i)
            .SubItems(5) = vntLinkImage(i)
            .SubItems(6) = vntMenuGrpCd(i)
            .SubItems(7) = vntMenuName(i)
            .SubItems(8) = vntYudoBunrui(i)
            .SubItems(9) = vntPgmDesc(i)
              
            If CInt(vntDelFlag(i)) = 1 Then
                .ForeColor = vbRed
                .ListSubItems.Item(1).ForeColor = vbRed
                .ListSubItems.Item(2).ForeColor = vbRed
                .ListSubItems.Item(3).ForeColor = vbRed
                .ListSubItems.Item(4).ForeColor = vbRed
                .ListSubItems.Item(5).ForeColor = vbRed
                .ListSubItems.Item(6).ForeColor = vbRed
                .ListSubItems.Item(7).ForeColor = vbRed
                .ListSubItems.Item(8).ForeColor = vbRed
                .ListSubItems.Item(9).ForeColor = vbRed
            End If
        End With
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objPgmInfo = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPgmInfo = Nothing
    
End Sub


'
' �@�\�@�@ : �ėp�e�[�u���ݒ�ꗗ�\��
' �����@�@ :
' �߂�l�@ :
' ���l�@�@ : 2005.03.23 Add by ��
'
Private Sub EditListViewFromUserGroup(strNodeKey As String, lngCount As Long)
    On Error GoTo ErrorHandle

    Dim objFree                 As Object           '���[�A�N�Z�X�p
    Dim objHeader               As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem                 As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim colNodes                As Nodes            '�m�[�h�R���N�V����
    Dim objNode                 As Node             '�m�[�h�I�u�W�F�N�g
    Dim i                       As Integer          '�C���f�b�N�X
    Dim iMode                   As Integer
    Dim strKey                  As String
    Dim sColTitle(10)           As String
    
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

    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    Select Case strNodeKey
        Case NODE_SECURITY_UGRPGM, NODE_SECURITY_USERGRP          '���[�U�[�O���[�v
            iMode = 0
            strKey = "UGR"
            sColTitle(0) = "�R�[�h"
            sColTitle(1) = "CLASS"
            sColTitle(2) = "���[�U�[�O���[�v����"
            sColTitle(3) = "�t�B�[���h�Q"
            sColTitle(4) = "�t�B�[���h�R"
            sColTitle(5) = "�t�B�[���h�S"
            sColTitle(6) = "�t�B�[���h�T"
            sColTitle(7) = "�t�B�[���h�U"
            sColTitle(8) = "�t�B�[���h�V"
        
        Case NODE_SECURITY_PWD
            iMode = 0
            strKey = "PWD"
            sColTitle(0) = "�R�[�h"
            sColTitle(1) = "CLASS"
            sColTitle(2) = "TERM"                       'ExpTerm
            sColTitle(3) = "ALERT"                      'AltTerm
            sColTitle(4) = "�������b�Z�[�W1"             'ExpMsg
            sColTitle(5) = "�������b�Z�[�W2"             'ExpMsg
            sColTitle(6) = "�A���[�����b�Z�[�W1"         'AltMsg
            sColTitle(7) = "�A���[�����b�Z�[�W2"         'AltMsg
            sColTitle(8) = "�t�B�[���h�U"
            
        Case NODE_SECURITY_MENUGRP, NODE_SECURITY_PGMINFO
            iMode = 2
            strKey = "PGM"
            sColTitle(0) = "�R�[�h"
            sColTitle(1) = "CLASS"
            sColTitle(2) = "���j���[����"
            sColTitle(3) = "�t�B�[���h�Q"
            sColTitle(4) = "�t�B�[���h�R"
            sColTitle(5) = "�t�B�[���h�S"
            sColTitle(6) = "�t�B�[���h�T"
            sColTitle(7) = "�t�B�[���h�U"
            sColTitle(8) = "�t�B�[���h�V"
        
        Case Else
            If Mid(strNodeKey, 1, Len(TABLE_SECURITYGRP)) = TABLE_SECURITYGRP Then
                iMode = 1
                strKey = trvMaster.SelectedItem.Key
                sColTitle(0) = "�R�[�h"
                sColTitle(1) = "CLASS"
                sColTitle(2) = "����"
                sColTitle(3) = "�t�B�[���h�Q"
                sColTitle(4) = "�t�B�[���h�R"
                sColTitle(5) = "�t�B�[���h�S"
                sColTitle(6) = "�t�B�[���h�T"
                sColTitle(7) = "�t�B�[���h�U"
                sColTitle(8) = "�t�B�[���h�V"
            End If
            
    End Select
    
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objFree = CreateObject("HainsFree.Free")
    lngCount = objFree.SelectFreeByClassCd(iMode, _
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
        
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    
    '���X�g�̕ҏW
    Select Case strNodeKey
        Case NODE_SECURITY_UGRPGM
            '�e�m�[�h�̕ҏW
            Set colNodes = trvMaster.Nodes
            
            For i = 1 To lngCount
                With colNodes
'                    .Add NODE_SECURITY_UGRPGM, tvwChild, vntFreeCd(i - 1), vntFreeField1(i - 1), ICON_CLOSED
                    .Add NODE_SECURITY_UGRPGM, tvwChild, vntFreeCd(i - 1), vntFreeField1(i - 1), ICON_CLOSED
                    .Item(trvMaster.SelectedItem.Index + i).Tag = vntFreeField2(i - 1)
                End With
            Next i
        
            '���X�g�ҏW
            Call EditListView(trvMaster.SelectedItem.Key)
            
        Case NODE_SECURITY_PGMINFO
'            '�e�m�[�h�̕ҏW
            Set colNodes = trvMaster.Nodes

            For i = 1 To lngCount
                With colNodes
                    .Add NODE_SECURITY_PGMINFO, tvwChild, vntFreeCd(i - 1), vntFreeField1(i - 1), ICON_CLOSED
                    .Item(trvMaster.SelectedItem.Index + i).Tag = vntFreeField2(i - 1)
'                    .Item.EnsureVisible = True
                End With
            Next i
            

            '���X�g�ҏW
            Call EditListView(trvMaster.SelectedItem.Key)
            
            
        Case Else
            If (Mid(strNodeKey, 1, Len(TABLE_SECURITYGRP)) = TABLE_SECURITYGRP) Or _
               (Mid(strNodeKey, 1, Len(NODE_SECURITY_USERGRP)) = NODE_SECURITY_USERGRP) Or _
               (Mid(strNodeKey, 1, Len(NODE_SECURITY_MENUGRP)) = NODE_SECURITY_MENUGRP) Then
               
                Set objHeader = lsvView.ColumnHeaders
                objHeader.Clear
                objHeader.Add , , sColTitle(0), 1500, lvwColumnLeft
                objHeader.Add , , sColTitle(1), 1000, lvwColumnLeft
                objHeader.Add , , sColTitle(2), 2000, lvwColumnLeft
                objHeader.Add , , sColTitle(3), 1000, lvwColumnLeft
                objHeader.Add , , sColTitle(4), 1000, lvwColumnLeft
                objHeader.Add , , sColTitle(5), 1000, lvwColumnLeft
                objHeader.Add , , sColTitle(6), 1000, lvwColumnLeft
                objHeader.Add , , sColTitle(7), 1000, lvwColumnLeft
                objHeader.Add , , sColTitle(8), 1000, lvwColumnLeft
                    
                lsvView.View = lvwReport
                    
                For i = 0 To lngCount - 1
                    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntFreeCd(i), vntFreeCd(i), , "DEFAULTLIST")
                    With objItem
                        .Tag = strNodeKey
                        .SubItems(1) = vntFreeClassCd(i)
                        .SubItems(2) = vntFreeField1(i)
                        .SubItems(3) = vntFreeField2(i)
                        .SubItems(4) = vntFreeField3(i)
                        .SubItems(5) = vntFreeField4(i)
                        .SubItems(6) = vntFreeField5(i)
                        .SubItems(7) = vntFreeField6(i)
                        .SubItems(8) = vntFreeField7(i)
                    End With
                Next i
            End If
            '---------------------------------------------------------------------------------
            If (Mid(strNodeKey, 1, Len(NODE_SECURITY_PWD)) = NODE_SECURITY_PWD) Then
                Set objHeader = lsvView.ColumnHeaders
                objHeader.Clear
                objHeader.Add , , sColTitle(0), 1500, lvwColumnLeft
                objHeader.Add , , sColTitle(1), 1000, lvwColumnLeft
                objHeader.Add , , sColTitle(2), 800, lvwColumnLeft
                objHeader.Add , , sColTitle(3), 800, lvwColumnLeft
                objHeader.Add , , sColTitle(4), 2000, lvwColumnLeft
                objHeader.Add , , sColTitle(5), 1500, lvwColumnLeft
                objHeader.Add , , sColTitle(6), 2000, lvwColumnLeft
                objHeader.Add , , sColTitle(7), 1500, lvwColumnLeft
                objHeader.Add , , sColTitle(8), 1000, lvwColumnLeft
                    
                lsvView.View = lvwReport
                    
                For i = 0 To lngCount - 1
                    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntFreeCd(i), vntFreeCd(i), , "DEFAULTLIST")
                    With objItem
                        .Tag = strNodeKey
                        .SubItems(1) = vntFreeClassCd(i)
                        .SubItems(2) = vntFreeField1(i)
                        .SubItems(3) = vntFreeField2(i)
                        .SubItems(4) = vntFreeField3(i)
                        .SubItems(5) = vntFreeField4(i)
                        .SubItems(6) = vntFreeField5(i)
                        .SubItems(7) = vntFreeField6(i)
                        .SubItems(8) = vntFreeField7(i)
                    End With
                Next i
            End If

    End Select
    
    
    '�I�u�W�F�N�g�p��
    Set objFree = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objFree = Nothing
    
End Sub



'
' �@�\�@�@ : �v�Z�ݒ�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromCalc(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objCalc         As Object           '�s���{���A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntItemCd       As Variant          '�������ڃR�[�h
    Dim vntSuffix       As Variant          '�T�t�B�b�N�X
    Dim vntItemName     As Variant          '�������ږ�
    Dim vntHistoryCount As Variant          '�������ږ�
    Dim i               As Long             '�C���f�b�N�X
    Dim strFullItemCd   As String
    Dim strDummy1       As String
    Dim strDummy2       As String
    
    strDummy1 = ""
    strDummy2 = ""
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCalc = CreateObject("HainsCalc.Calc")
    lngCount = objCalc.SelectCalcList(True, _
                                      strDummy1, _
                                      strDummy2, _
                                      vntItemCd, _
                                      vntSuffix, _
                                      vntItemName, _
                                      vntHistoryCount)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�������ڃR�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�������ږ�", 2000, lvwColumnLeft
    objHeader.Add , , "�����Ǘ���", 1100, lvwColumnRight
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        strFullItemCd = vntItemCd(i) & KEY_SEPARATE & vntSuffix(i)
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & strFullItemCd, strFullItemCd, , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntItemName(i)
        objItem.SubItems(2) = vntHistoryCount(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objCalc = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objCalc = Nothing
    
End Sub
'
' �@�\�@�@ : ���ʃR�����g�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromRslCmt(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRslCmt       As Object           '���ʃR�����g�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntRslCmtCd     As Variant          '���ʃR�����g�R�[�h
    Dim vntRslCmtName   As Variant          '���ʃR�����g��
    Dim vntEntryOk      As Variant          '���͊����t���O
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRslCmt = CreateObject("HainsRslCmt.RslCmt")
    lngCount = objRslCmt.SelectRslCmtList(vntRslCmtCd, vntRslCmtName, vntEntryOk)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�����g�R�[�h", 1200, lvwColumnLeft
    objHeader.Add , , "���ʃR�����g��", 2200, lvwColumnLeft
    objHeader.Add , , "���͊������f", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRslCmtCd(i), vntRslCmtCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntRslCmtName(i)
        If vntEntryOk(i) = 1 Then
            objItem.SubItems(2) = "���͊����Ƃ���"
        Else
            objItem.SubItems(2) = ""
        End If
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objRslCmt = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRslCmt = Nothing
    
End Sub

'
' �@�\�@�@ : �������{�����ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromOpeClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objOpeClass     As Object           '�������{�����ރA�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntOpeClassCd   As Variant          '�������{�����ރR�[�h
    Dim vntOpeClassName As Variant          '�������{�����ޖ�
    Dim vntOrderCntl    As Variant          '���͊����t���O
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objOpeClass = CreateObject("HainsOpeClass.OpeClass")
    lngCount = objOpeClass.SelectOpeClassList(vntOpeClassCd, vntOpeClassName, vntOrderCntl)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�������{�����ރR�[�h", 1200, lvwColumnLeft
    objHeader.Add , , "�������{�����ޖ�", 2200, lvwColumnLeft
    objHeader.Add , , "�I�[�_����p�ԍ�", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntOpeClassCd(i), vntOpeClassCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntOpeClassName(i)
        objItem.SubItems(2) = vntOrderCntl(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objOpeClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objOpeClass = Nothing
    
End Sub

'
' �@�\�@�@ : �����K�p�R�[�h�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromZaimu(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objZaimu            As Object           '�����K�p�R�[�h�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntZaimuCd          As Variant          '�����R�[�h�R�[�h
    Dim vntZaimuName        As Variant          '�����K�p��
    Dim vntZaimuDiv         As Variant          '�������
    Dim vntZaimuClass       As Variant          '��������
    Dim vntDisabled         As Variant          '���g�p�t���O
    Dim i                   As Long             '�C���f�b�N�X
    Dim strZaimuClassName   As String
    Dim strZaimuDivName     As String
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    lngCount = objZaimu.SelectZaimuList(vntZaimuCd, vntZaimuName, vntZaimuDiv, vntZaimuClass, , vntDisabled, True)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "��������", 1300, lvwColumnLeft
    objHeader.Add , , "�����K�p�R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�����K�p��", 3300, lvwColumnLeft
    objHeader.Add , , "�������", 1500, lvwColumnLeft
    objHeader.Add , , "�g�p��", 1500, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Select Case vntZaimuClass(i)
            Case 0
                strZaimuClassName = "������"
            Case 1
                strZaimuClassName = "�l"
            Case 2
                strZaimuClassName = "�c��"
            Case 3
                strZaimuClassName = "�d�b����"
            Case 4
                strZaimuClassName = "�����쐬"
            Case 5
                strZaimuClassName = "���̑�����"
            Case Else
                strZaimuClassName = vntZaimuClass(i)
        End Select
        
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntZaimuCd(i), strZaimuClassName, , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntZaimuCd(i)
        objItem.SubItems(2) = vntZaimuName(i)
        
        Select Case vntZaimuDiv(i)
            Case 1
                strZaimuDivName = "����"
            Case 2
                strZaimuDivName = "����"
            Case 3
                strZaimuDivName = "�ߋ�������"
            Case 4
                strZaimuDivName = "�ҕt"
            Case 5
                strZaimuDivName = "�ҕt����"
            Case Else
                strZaimuDivName = vntZaimuDiv(i)
        End Select
        
        objItem.SubItems(3) = strZaimuDivName
        If vntDisabled(i) = "1" Then
            objItem.SubItems(4) = "�ʏ�\�����Ȃ�"
        End If
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objZaimu = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objZaimu = Nothing
    
End Sub

'
' �@�\�@�@ : ��l�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromStdValue(strNodeKey As String, strClassCd As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objStdValue         As Object           '��l�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntStdValueMngCd    As Variant          '��l�Ǘ��R�[�h
    Dim vntItemCd           As Variant          '�������ڃR�[�h
    Dim vntSuffix           As Variant          '�T�t�B�b�N�X
    Dim vntStrDate          As Variant          '�g�p�J�n���t
    Dim vntEndDate          As Variant          '�g�p�I�����t
    Dim vntCsCd             As Variant          '�ΏۃR�[�X�R�[�h
    Dim vntItemName         As Variant          '�������ږ�
    Dim vntCsName           As Variant          '�ΏۃR�[�X��
    
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStdValue = CreateObject("HainsStdValue.StdValue")
    lngCount = objStdValue.SelectStdValueList(strClassCd, _
                                              "", _
                                              "", _
                                              vntStdValueMngCd, _
                                              vntItemCd, _
                                              vntSuffix, _
                                              vntStrDate, _
                                              vntEndDate, _
                                              vntCsCd, _
                                              vntItemName, _
                                              vntCsName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���ڃR�[�h", 1200, lvwColumnLeft
    objHeader.Add , , "�������ږ�", 2000, lvwColumnLeft
    objHeader.Add , , "�g�p�J�n���t", 1300, lvwColumnLeft
    objHeader.Add , , "�g�p�I�����t", 1300, lvwColumnLeft
    objHeader.Add , , "�ΏۃR�[�X", 2000, lvwColumnLeft
    objHeader.Add , , "��l�Ǘ��R�[�h", 1600, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntStdValueMngCd(i), vntItemCd(i) & "-" & vntSuffix(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntItemName(i)
        objItem.SubItems(2) = vntStrDate(i)
        objItem.SubItems(3) = vntEndDate(i)
        objItem.SubItems(4) = vntCsName(i)
        objItem.SubItems(5) = vntStdValueMngCd(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objStdValue = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objStdValue = Nothing
    
End Sub
'
' �@�\�@�@ : ���茒�f�p��l�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromSpStdValue(strNodeKey As String, strClassCd As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objSpStdValue       As Object           '���茒�f�p��l�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntSpStdValueMngCd  As Variant          '���茒�f�p��l�Ǘ��R�[�h
    Dim vntItemCd           As Variant          '�������ڃR�[�h
    Dim vntSuffix           As Variant          '�T�t�B�b�N�X
    Dim vntStrDate          As Variant          '�g�p�J�n���t
    Dim vntEndDate          As Variant          '�g�p�I�����t
    Dim vntCsCd             As Variant          '�ΏۃR�[�X�R�[�h
    Dim vntItemName         As Variant          '�������ږ�
    Dim vntCsName           As Variant          '�ΏۃR�[�X��
    
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSpStdValue = CreateObject("HainsSpStdValue.SpStdValue")
    lngCount = objSpStdValue.SelectSpStdValueList(strClassCd, _
                                              "", _
                                              "", _
                                              vntSpStdValueMngCd, _
                                              vntItemCd, _
                                              vntSuffix, _
                                              vntStrDate, _
                                              vntEndDate, _
                                              vntCsCd, _
                                              vntItemName, _
                                              vntCsName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���ڃR�[�h", 1200, lvwColumnLeft
    objHeader.Add , , "�������ږ�", 2000, lvwColumnLeft
    objHeader.Add , , "�g�p�J�n���t", 1300, lvwColumnLeft
    objHeader.Add , , "�g�p�I�����t", 1300, lvwColumnLeft
    objHeader.Add , , "�ΏۃR�[�X", 2000, lvwColumnLeft
    objHeader.Add , , "��l�Ǘ��R�[�h", 1600, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntSpStdValueMngCd(i), vntItemCd(i) & "-" & vntSuffix(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntItemName(i)
        objItem.SubItems(2) = vntStrDate(i)
        objItem.SubItems(3) = vntEndDate(i)
        objItem.SubItems(4) = vntCsName(i)
        objItem.SubItems(5) = vntSpStdValueMngCd(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objSpStdValue = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSpStdValue = Nothing
    
End Sub


'
' �@�\�@�@ : �w�����e�ꗗ�\��
'
' �����@�@ : (In)   strNodeKey      �m�[�h�L�[
' �@�@�@�@ : (Out)  strJudClassCd   ���蕪�ރR�[�h
' �@�@�@�@ : (Out)  lngCount        �������ʌ���
'
' �߂�l�@ :
'
' ���l�@�@ : �����Ŏw�肳�ꂽ���蕪�ރR�[�h�ɊY������w�����e��\������B
'
Private Sub EditListViewFromGuidance(strNodeKey As String, _
                                     strJudClassCd As String, _
                                     lngCount As Long)


On Error GoTo ErrorHandle

    Dim objGuidance         As Object           '�w�����e�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntGuidanceCd       As Variant          '�w�����e�R�[�h
    Dim vntGuidanceStc      As Variant          '�w�����e��
    Dim vntJudClassCd       As Variant          '���蕪�ރR�[�h
    Dim vntJudClassName     As Variant          '���蕪�ޖ�
    Dim vntEntryOk          As Variant          '���͊����t���O
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGuidance = CreateObject("HainsGuidance.Guidance")
    lngCount = objGuidance.SelectGuidanceList(strJudClassCd, vntGuidanceCd, vntGuidanceStc)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�w�����e�R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�w�����e��", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntGuidanceCd(i), vntGuidanceCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntGuidanceStc(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objGuidance = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objGuidance = Nothing
    
End Sub

'
' �@�\�@�@ : ��^�����ꗗ�\��
'
' �����@�@ : (In)   strJudClassCd     ���蕪�ރR�[�h
' �@�@�@�@ : (Out)  lngCount          �������ʌ���
' �@�@�@�@ : (In)   vntSearchCode     �����p�R�[�h�i�ȗ��j
' �@�@�@�@ : (In)   vntSearchString   �����p������i�ȗ��j
'
' �߂�l�@ :
'
' ���l�@�@ : �����Ŏw�肳�ꂽ���蕪�ރR�[�h�ɊY�������^������\������B
'
Private Sub EditListViewFromStdJud(strNodeKey As String, intJudClassCd As Integer, lngCount As Long, _
                                     Optional ByVal vntSearchCode As Variant, _
                                     Optional ByVal vntSearchString As Variant)


On Error GoTo ErrorHandle

    Dim objStdJud       As Object           '��^�����A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntJudClassCd   As Variant          '���蕪�ރR�[�h
    Dim vntStdJudCd     As Variant          '��^�����R�[�h
    Dim vntStdJudName   As Variant          '��^������
    Dim vntEntryOk      As Variant          '���͊����t���O
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objStdJud = CreateObject("HainsStdJud.StdJud")
    
    If (IsMissing(vntSearchCode) = False) Or (IsMissing(vntSearchCode) = False) Then
        lngCount = objStdJud.SelectStdJudList(intJudClassCd, vntStdJudCd, vntStdJudName, vntJudClassCd, vntSearchCode, vntSearchString)
    Else
        lngCount = objStdJud.SelectStdJudList(intJudClassCd, vntStdJudCd, vntStdJudName, vntJudClassCd)
    End If
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "��^�����R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "��^������", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntJudClassCd(i) & "-" & vntStdJudCd(i), vntStdJudCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntStdJudName(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objStdJud = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objStdJud = Nothing
    
End Sub

'
' �@�\�@�@ : �˗����ڈꗗ�\��
'
' �����@�@ : (In)   strItemClassCd    �������ރR�[�h
' �@�@�@�@ : (Out)  lngCount          �������ʌ���
' �@�@�@�@ : (In)   vntSearchCode     �����p�R�[�h�i�ȗ��j
' �@�@�@�@ : (In)   vntSearchString   �����p������i�ȗ��j
'
' �߂�l�@ :
'
' ���l�@�@ : �����Ŏw�肳�ꂽ�������ރR�[�h�ɊY������˗����ڂ�\������B
'
Private Sub EditListViewFromItem_p(strNodeKey As String, strItemClassCd As String, _
                                   lngCount As Long, _
                                   Optional ByVal vntSearchCode As Variant, _
                                   Optional ByVal vntSearchString As Variant)

On Error GoTo ErrorHandle

    Dim objItem_P               As Object           '�˗����ڃA�N�Z�X�p
    Dim objHeader               As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem                 As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntItemCd               As Variant          '�������ڃR�[�h
    Dim vntSuffix               As Variant          '�T�t�B�b�N�X
    Dim vntRequestName          As Variant          '�˗����ږ�
    Dim vntProgressName         As Variant          '�i�����ޖ�
    Dim vntRslQue               As Variant          '���ʖ�f�t���O
    Dim vntEntryOk              As Variant          '�����̓`�F�b�N
    Dim vntSearchChar           As Variant          '�K�C�h����������
    Dim vntOpeClassName         As Variant          '�������{������
    Dim vntPrice1               As Variant          '�P���P
    Dim vntPrice2               As Variant          '�P���Q
    
    Dim vntDmdLineClassName     As Variant
    Dim vntIsrDmdLineClassName  As Variant
    Dim vntRoundClassName       As Variant
    
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem_P = CreateObject("HainsItem.Item")
    
    If (IsMissing(vntSearchCode) = False) Or (IsMissing(vntSearchCode) = False) Then
        lngCount = objItem_P.SelectItem_pList(strItemClassCd, _
                                              "", _
                                              ITEM_DISP, _
                                              vntItemCd, _
                                              vntSuffix, _
                                              vntRequestName, _
                                              vntRslQue, _
                                              , _
                                              vntProgressName, _
                                              vntEntryOk, _
                                              vntSearchChar, _
                                              vntOpeClassName, _
                                              vntPrice1, _
                                              vntPrice2, _
                                              vntSearchCode, _
                                              vntSearchString, _
                                              vntDmdLineClassName, _
                                              vntIsrDmdLineClassName, _
                                              vntRoundClassName)
    Else
        lngCount = objItem_P.SelectItem_pList(strItemClassCd, _
                                              "", _
                                              ITEM_DISP, _
                                              vntItemCd, _
                                              vntSuffix, _
                                              vntRequestName, _
                                              vntRslQue, _
                                              , _
                                              vntProgressName, _
                                              vntEntryOk, _
                                              vntSearchChar, _
                                              vntOpeClassName, _
                                              vntPrice1, _
                                              vntPrice2, _
                                              , , _
                                              vntDmdLineClassName, _
                                              vntIsrDmdLineClassName, _
                                              vntRoundClassName)
    
    End If
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���ڃR�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "�˗����ږ�", 2000, lvwColumnLeft
    objHeader.Add , , "����", 700, lvwColumnLeft
    objHeader.Add , , "�����̓`�F�b�N", 1300, lvwColumnLeft
    objHeader.Add , , "�i������", 1400, lvwColumnLeft
    objHeader.Add , , "��ʐ�������", 1400, lvwColumnLeft
    objHeader.Add , , "���ې�������", 1400, lvwColumnLeft
    objHeader.Add , , "�܂�ߕ���", 1400, lvwColumnLeft
    
'    objHeader.Add , , "�P���P", 900, lvwColumnRight
'    objHeader.Add , , "�P���Q", 900, lvwColumnRight
'    objHeader.Add , , "�������{����", 2600, lvwColumnLeft
    objHeader.Add , , "��������", 1000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntItemCd(i), vntItemCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntRequestName(i)
            If vntRslQue(i) = 0 Then
                .SubItems(2) = "����"
            Else
                .SubItems(2) = "��f"
            End If
            
            Select Case vntEntryOk(i)
                Case 0
                    .SubItems(3) = "�Œ�P��"
                Case 1
                    .SubItems(3) = "�S��"
                Case 2
                    .SubItems(3) = "�`�F�b�N���Ȃ�"
            End Select
            
            .SubItems(4) = vntProgressName(i)
            .SubItems(5) = vntDmdLineClassName(i)
            .SubItems(6) = vntIsrDmdLineClassName(i)
            .SubItems(7) = vntRoundClassName(i)
            .SubItems(8) = vntSearchChar(i)
            
'            .SubItems(5) = vntPrice1(i)
'            .SubItems(6) = vntPrice2(i)
'            .SubItems(7) = vntOpeClassName(i)
        
        
        End With
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objItem_P = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItem_P = Nothing
    
End Sub

'
' �@�\�@�@ : ���͈ꗗ�\��
'
' �����@�@ : (Out)  lngCount          �������ʌ���
' �@�@�@�@ : (In)   vntSearchCode     �����p�R�[�h�i�ȗ��j
' �@�@�@�@ : (In)   vntSearchString   �����p������i�ȗ��j
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromSentence(strNodeKey As String, lngCount As Long, _
                                     Optional ByVal vntSearchCode As Variant, _
                                     Optional ByVal vntSearchString As Variant)


On Error GoTo ErrorHandle

    Dim objSentence     As Object           '���̓A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntItemCd       As Variant          '�������ڃR�[�h
    Dim vntItemType     As Variant          '���ڃ^�C�v
    Dim vntStcCd        As Variant          '���̓R�[�h
    Dim vntShortStc     As Variant          '����
    Dim vntLongStc      As Variant          '��������
    Dim vntRequestName  As Variant          '�˗����ږ�
    Dim vntInsStc       As Variant          '�����A�g�p�ϊ�����
    
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSentence = CreateObject("HainsSentence.Sentence")
    
    If (IsMissing(vntSearchCode) = False) Or (IsMissing(vntSearchCode) = False) Then
        lngCount = objSentence.SelectSentenceList("", _
                                                  0, _
                                                  vntStcCd, _
                                                  vntShortStc, _
                                                  vntItemCd, _
                                                  vntItemType, _
                                                  vntLongStc, _
                                                  vntRequestName, _
                                                  vntSearchCode, _
                                                  vntSearchString, , vntInsStc)
    Else
        lngCount = objSentence.SelectSentenceList("", _
                                                  0, _
                                                  vntStcCd, _
                                                  vntShortStc, _
                                                  vntItemCd, _
                                                  vntItemType, _
                                                  vntLongStc, _
                                                  vntRequestName, , , , vntInsStc)
    End If
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���ڃR�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "���ږ�", 2000, lvwColumnLeft
    objHeader.Add , , "�^�C�v", 600, lvwColumnLeft
    objHeader.Add , , "���̓R�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "���͖�", 2200, lvwColumnLeft
    objHeader.Add , , "����", 2000, lvwColumnLeft
    objHeader.Add , , "�����A�g�p����", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntItemCd(i) & KEY_SEPARATE & vntItemType(i) & KEY_SEPARATE & vntStcCd(i) _
                                            , vntItemCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntRequestName(i)
            Select Case vntItemType(i)
                Case ITEMTYPE_STANDARD
                    .SubItems(2) = "�W��"
                Case ITEMTYPE_BUI
                    .SubItems(2) = "����"
                Case ITEMTYPE_SHOKEN
                    .SubItems(2) = "����"
                Case ITEMTYPE_SHOCHI
                    .SubItems(2) = "���u"
                Case Else
                    .SubItems(2) = vntItemType(i)
            End Select
            
            .SubItems(3) = vntStcCd(i)
            .SubItems(4) = vntLongStc(i)
            .SubItems(5) = vntShortStc(i)
            .SubItems(6) = vntInsStc(i)
        End With
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objSentence = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSentence = Nothing
    
End Sub
'
' �@�\�@�@ : ���̓^�C�v�̌������ڈꗗ�\��
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromSentenceItem(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objSentenceItem As Object           '���̓A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntCd           As Variant          '�������ڃR�[�h
    Dim vntSuffix       As Variant          '�T�t�B�b�N�X
    Dim vntName         As Variant          '����
    Dim vntClassCd      As Variant          '�������ރR�[�h
    Dim vntClassName    As Variant          '�������ޖ�
    
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSentenceItem = CreateObject("HainsItem.Item")
    lngCount = objSentenceItem.SelectItem_cList(vntClassCd, _
                                                "", _
                                                1, _
                                                vntCd, _
                                                vntSuffix, _
                                                vntName, _
                                                vntClassName, _
                                                RESULTTYPE_SENTENCE)
   
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���ڃR�[�h", 1200, lvwColumnLeft
    objHeader.Add , , "���ږ�", 2000, lvwColumnLeft
    objHeader.Add , , "�������ޖ�", 1800, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntCd(i) & KEY_SEPARATE & vntSuffix(i), vntCd(i) & "-" & vntSuffix(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntName(i)
            .SubItems(2) = vntClassName(i)
        End With
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objItem = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItem = Nothing
    
End Sub

'
' �@�\�@�@ : �������ڈꗗ�\��
'
' �����@�@ : (In)   strItemClassCd      �������ރR�[�h
' �@�@�@�@ : (Out)  lngCount            �������ʌ���
' �@�@�@�@ : (In)   vntSearchCode       �����p�R�[�h�i�ȗ��j
' �@�@�@�@ : (In)   vntSearchString     �����p������i�ȗ��j
'
' �߂�l�@ :
'
' ���l�@�@ : �����Ŏw�肳�ꂽ�������ރR�[�h�ɊY�����錟�����ڂ�\������B
'
Private Sub EditListViewFromItem_c(strNodeKey As String, strItemClassCd As String, _
                                   lngCount As Long, _
                                   Optional ByVal vntSearchCode As Variant, _
                                   Optional ByVal vntSearchString As Variant)

On Error GoTo ErrorHandle

    Dim objItem_P       As Object           '�������ڃA�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntItemCd       As Variant          '�������ڃR�[�h
    Dim vntSuffix       As Variant          '�T�t�B�b�N�X
    Dim vntItemName     As Variant          '�������ږ�
    Dim vntResultType   As Variant          '���ʃ^�C�v
    
    Dim i               As Long             '�C���f�b�N�X
    Dim strFullItemCd   As String
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem_P = CreateObject("HainsItem.Item")
    If (IsMissing(vntSearchCode) = False) Or (IsMissing(vntSearchCode) = False) Then
        lngCount = objItem_P.SelectItem_cList(strItemClassCd, _
                                              "", _
                                              ITEM_DISP, _
                                              vntItemCd, _
                                              vntSuffix, _
                                              vntItemName, _
                                              , _
                                              vntResultType, _
                                              vntSearchCode, _
                                              vntSearchString)
    Else
        lngCount = objItem_P.SelectItem_cList(strItemClassCd, _
                                              "", _
                                              ITEM_DISP, _
                                              vntItemCd, _
                                              vntSuffix, _
                                              vntItemName, _
                                              , _
                                              vntResultType)
    End If
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���ڃR�[�h", 1200, lvwColumnLeft
    objHeader.Add , , "�������ږ�", 2000, lvwColumnLeft
    objHeader.Add , , "���ʃ^�C�v", 1900, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        strFullItemCd = vntItemCd(i) & KEY_SEPARATE & vntSuffix(i)
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & strFullItemCd, strFullItemCd, , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntItemName(i)
            Select Case vntResultType(i)
        
                Case RESULTTYPE_NUMERIC         '���l
                    .SubItems(2) = "���l�^�C�v"
                Case RESULTTYPE_TEISEI1         '�萫�P
                    .SubItems(2) = "�萫�i�W���j"
                Case RESULTTYPE_TEISEI2         '�萫�Q
                    .SubItems(2) = "�萫�i�g���j"
                Case RESULTTYPE_FREE            '�t���[
                    .SubItems(2) = "�t���["
                Case RESULTTYPE_SENTENCE        '����
                    .SubItems(2) = "���̓^�C�v"
                Case RESULTTYPE_CALC            '�v�Z
                    .SubItems(2) = "�v�Z�^�C�v"
                Case RESULTTYPE_DATE            '���t�^�C�v
                    .SubItems(2) = "���t�^�C�v"
'### 2003/11/19 Added by Ishihara@FSIT ���H���łŒǉ��ɂȂ���
                Case 7                          '�����^�C�v
                    .SubItems(2) = "�����^�C�v"
                Case 8                          '�����^�C�v
                    .SubItems(2) = "�����������^�C�v"
'### 2003/11/19 Added End
                Case Else
                    .SubItems(2) = "�H"
            End Select
        End With
    
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objItem_P = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItem_P = Nothing
    
End Sub


'
' �@�\�@�@ : ����R�����g�ꗗ�\��
'
' �����@�@ : (In)   strJudClassCd     ���蕪�ރR�[�h
' �@�@�@�@ : (Out)  lngCount          �������ʌ���
' �@�@�@�@ : (In)   vntSearchCode     �����p�R�[�h�i�ȗ��j
' �@�@�@�@ : (In)   vntSearchString   �����p������i�ȗ��j
'
' �߂�l�@ :
'
' ���l�@�@ : �����Ŏw�肳�ꂽ���蕪�ރR�[�h�ɊY�����锻��R�����g��\������B
'
Private Sub EditListViewFromJudCmtStc(strNodeKey As String, _
                                      strJudClassCd As String, _
                                      lngCount As Long, _
                                      Optional ByVal vntSearchCode As Variant, _
                                      Optional ByVal vntSearchString As Variant)

On Error GoTo ErrorHandle

    Dim objJudCmtStc        As Object           '����R�����g�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntJudCmtCd         As Variant          '����R�����g�R�[�h
    Dim vntJudCmtStcName    As Variant          '����R�����g��
    Dim vntDummy(2)         As Variant          'COM+�����p�_�~�[�ϐ�
    
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    
    If (IsMissing(vntSearchCode) = False) Or (IsMissing(vntSearchCode) = False) Then

'### 2004/11/17 Add by Gouda@FSIT �����w���R�����g�̕\������
'        lngcount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, _
'                                                    vntDummy(0), _
'                                                    1, _
'                                                    "", _
'                                                    vntJudCmtCd, _
'                                                    vntJudCmtStcName, _
'                                                    vntDummy(1), _
'                                                    vntDummy(2), _
'                                                    vntSearchCode, _
'                                                    vntSearchString)
        lngCount = objJudCmtStc.SelectJudCmtStcList(strJudClassCd, _
                                                    vntDummy(0), _
                                                    1, _
                                                    "", _
                                                    vntJudCmtCd, _
                                                    vntJudCmtStcName, _
                                                    vntDummy(1), _
                                                    vntDummy(2), _
                                                    vntSearchCode, _
                                                    vntSearchString, _
                                                    , , , , 1)
'### 2004/11/17 Add End
    
    Else
        
'### 2004/1/15 Modified by Ishihara@FSIT�@���̂܂ɂ��\�����[�h���ǉ��ɂȂ��Ă����B
'        lngCount = objJudCmtStc.SelectJudCmtStcList(IIf(strJudClassCd = TABLE_JUDCMTSTC, "", strJudClassCd), _
                                                    vntDummy(0), _
                                                    1, _
                                                    "", _
                                                    vntJudCmtCd, _
                                                    vntJudCmtStcName, _
                                                    vntDummy(1), _
                                                    vntDummy(2))

'### 2004/11/17 Add by Gouda@FSIT �����w���R�����g�̕\������
'        lngcount = objJudCmtStc.SelectJudCmtStcList(IIf(strJudClassCd = TABLE_JUDCMTSTC, "", strJudClassCd), _
'                                                    vntDummy(0), _
'                                                    1, _
'                                                    "", _
'                                                    vntJudCmtCd, _
'                                                    vntJudCmtStcName, _
'                                                    vntDummy(1), _
'                                                    vntDummy(2), , , 1)
        lngCount = objJudCmtStc.SelectJudCmtStcList(IIf(strJudClassCd = TABLE_JUDCMTSTC, "", strJudClassCd), _
                                                    vntDummy(0), _
                                                    1, _
                                                    "", _
                                                    vntJudCmtCd, _
                                                    vntJudCmtStcName, _
                                                    vntDummy(1), _
                                                    vntDummy(2), , , 1, _
                                                    , , , 1)

'### 2004/1/15 Modified End
'### 2004/11/17 Add End
    End If
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "����R�����g�R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "����R�����g", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntJudCmtCd(i), vntJudCmtCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntJudCmtStcName(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objJudCmtStc = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objJudCmtStc = Nothing
    
End Sub

'
' �@�\�@�@ : WEB�p�R�[�X�ݒ�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromWeb_Cs(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objWeb_Cs       As Object           'WEB�p�R�[�X�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntWeb_CsCd     As Variant          'WEB�p�R�[�X�R�[�h
    Dim vntWeb_CsName   As Variant          'WEB�p�R�[�X��
    Dim vntWeb_OutLine  As Variant          '�������ڐ���
    Dim vntEntryOk      As Variant          '���͊����t���O
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWeb_Cs = CreateObject("HainsWeb_Cs.Web_Cs")
    lngCount = objWeb_Cs.SelectWeb_CsList(vntWeb_CsCd, vntWeb_CsName, vntWeb_OutLine)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�X�R�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "WEB�p�R�[�X��", 2000, lvwColumnLeft
    objHeader.Add , , "�T��", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntWeb_CsCd(i), vntWeb_CsCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntWeb_CsName(i)
        objItem.SubItems(2) = Replace(vntWeb_OutLine(i), "<BR>", Space(1))
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objWeb_Cs = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objWeb_Cs = Nothing
    
End Sub

'
' �@�\�@�@ : �i���Ǘ��p���ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromProgress(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objProgress         As Object           '�i���Ǘ��p���蕪�ރA�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntProgressCd       As Variant          '�i���Ǘ��p�R�[�h
    Dim vntProgressName     As Variant          '�i���Ǘ��p��
    Dim vntProgressSName    As Variant          '�i���Ǘ��p����
    Dim vntSeq              As Variant          '�\������
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objProgress = CreateObject("HainsProgress.Progress")
    lngCount = objProgress.SelectProgressList(vntProgressCd, vntProgressName, vntProgressSName, vntSeq)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    lsvView.ListItems.Clear
    objHeader.Clear
    objHeader.Add , , "�i�����ރR�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "�i���Ǘ��p��", 2200, lvwColumnLeft
    objHeader.Add , , "����", 2200, lvwColumnLeft
    objHeader.Add , , "�\������", 1000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntProgressCd(i), vntProgressCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntProgressName(i)
        objItem.SubItems(2) = vntProgressSName(i)
        objItem.SubItems(3) = vntSeq(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objProgress = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objProgress = Nothing
    
End Sub

'
' �@�\�@�@ : �[���Ǘ��ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromWorkStation(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objWorkStation      As Object           '�i���Ǘ��p���蕪�ރA�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntIpAddress        As Variant          'IP�A�h���X
    Dim vntWkStnName        As Variant          '�[����
    Dim vntGrpCd            As Variant          '�O���[�v�R�[�h
    Dim vntGrpName          As Variant          '�O���[�v��
    Dim vntProgressName     As Variant          '�i�����ޖ�
    Dim vntIsPrintButton    As Variant          '���ʓ��͏�̃{�^���\��
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objWorkStation = CreateObject("HainsWorkStation.WorkStation")
    lngCount = objWorkStation.SelectWorkStationList(vntIpAddress, vntWkStnName, vntGrpCd, vntGrpName, , vntProgressName, vntIsPrintButton)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    lsvView.ListItems.Clear
    objHeader.Clear
    objHeader.Add , , "IP�A�h���X", 1500, lvwColumnLeft
    objHeader.Add , , "�[����", 2200, lvwColumnLeft
    objHeader.Add , , "�O���[�v�R�[�h", 1200, lvwColumnLeft
    objHeader.Add , , "�O���[�v��", 1500, lvwColumnLeft
'    objHeader.Add , , "�i�����ޖ�", 1500, lvwColumnLeft
    objHeader.Add , , "���ʓ��͂̈���{�^��", 3000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntIpAddress(i), vntIpAddress(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntWkStnName(i)
        objItem.SubItems(2) = vntGrpCd(i)
        objItem.SubItems(3) = vntGrpName(i)
'        objItem.SubItems(4) = vntProgressName(i)
        Select Case vntIsPrintButton(i)
            Case "1"
                objItem.SubItems(4) = "�����g�����\����{�^���\��"
            Case "2"
                objItem.SubItems(4) = "���o�����������ʕ\����{�^���\��"
        End Select
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objWorkStation = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objWorkStation = Nothing
    
End Sub

'
' �@�\�@�@ : ����ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromJud(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objJud              As Object           '����A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntJudCd            As Variant          '����R�[�h
    Dim vntJudSName         As Variant          '���藪��
    Dim vntJudRName         As Variant          '�񍐏��p���薼
    Dim vntWeight           As Variant          '����p�d��
    Dim vntGovMngJud        As Variant          '���{�Ǐ��p�R�[�h
    Dim vntGovMngJudName    As Variant          '���{�Ǐ��p����
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJud = CreateObject("HainsJud.Jud")
    lngCount = objJud.SelectJudList(vntJudCd, vntJudSName, vntJudRName, vntWeight, vntGovMngJud, vntGovMngJudName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�h", 650, lvwColumnLeft
    objHeader.Add , , "����", 1300, lvwColumnLeft
    objHeader.Add , , "�񍐏��p���薼", 2000, lvwColumnLeft
    objHeader.Add , , "�d��", 600, lvwColumnLeft
'#### 2010.07.16 SL-HS-Y0101-001 DEL START ####�@COMP-LUKES-0018�i��݊����؁j
'    objHeader.Add , , "���Ǘp�R�[�h", 1200, lvwColumnLeft
'    objHeader.Add , , "���Ǘp����", 2000, lvwColumnLeft
'#### 2010.07.16 SL-HS-Y0101-001 DEL END �@####�@COMP-LUKES-0018�i��݊����؁j
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntJudCd(i), vntJudCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntJudSName(i)
            .SubItems(2) = vntJudRName(i)
            .SubItems(3) = vntWeight(i)
'#### 2010.07.16 SL-HS-Y0101-001 DEL START ####�@COMP-LUKES-0018�i��݊����؁j
'            .SubItems(4) = vntGovMngJud(i)
'            .SubItems(5) = vntGovMngJudName(i)
'#### 2010.07.16 SL-HS-Y0101-001 DEL END �@####�@COMP-LUKES-0018�i��݊����؁j
        End With
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objJud = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objJud = Nothing
    
End Sub

'
' �@�\�@�@ : �\��g�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromRsvFra(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRsvFra           As Object           '�\��g�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntRsvFraCd         As Variant          '�\��g�R�[�h
    Dim vntRsvFraName       As Variant          '�\��g��
    Dim vntOverRsv          As Variant          '�g�I�[�o�o�^
    Dim vntFraType          As Variant          '�g�^�C�v
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRsvFra = CreateObject("HainsSchedule.Schedule")
    lngCount = objRsvFra.SelectRsvFraList(vntRsvFraCd, vntRsvFraName, vntOverRsv, vntFraType)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�h", 750, lvwColumnLeft
    objHeader.Add , , "�\��g��", 3500, lvwColumnLeft
    objHeader.Add , , "�g�^�C�v", 1200, lvwColumnLeft
    objHeader.Add , , "�g�I�[�o�o�^", 1200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRsvFraCd(i), vntRsvFraCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntRsvFraName(i)
        If vntFraType(i) = "1" Then
            objItem.SubItems(2) = "�������ژg"
        Else
            objItem.SubItems(2) = "�R�[�X�g"
        End If
        If vntOverRsv(i) = "1" Then
            objItem.SubItems(3) = "�\"
        End If
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objRsvFra = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRsvFra = Nothing
    
End Sub

'
' �@�\�@�@ : �\��Q�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromRsvGrp(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRsvGrp           As Object           '�\��Q�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntRsvGrpCd         As Variant          '�\��Q�R�[�h
    Dim vntRsvGrpName       As Variant          '�\��Q����
    Dim vntStrTime          As Variant          '�J�n����
    Dim vntEndTime          As Variant          '�I������
    Dim vntRptEndTime       As Variant          '���f��t�I������
    Dim vntlead             As Variant          '�U���Ώ�
    Dim vntrsvSetGrpCd      As Variant          '�\�񎞃Z�b�g�O���[�v�R�[�h
    Dim i                   As Long             '�C���f�b�N�X
    Dim lngSortOrder        As Long             '�\�[�g��(0:�\��Q�R�[�h���A0�ȊO:�J�n���ԏ�)
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objRsvGrp = CreateObject("HainsSchedule.Schedule")
    lngCount = objRsvGrp.SelectRsvGrpList(lngSortOrder, vntRsvGrpCd, vntRsvGrpName, vntStrTime, vntEndTime, vntRptEndTime)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�h", 750, lvwColumnLeft
    objHeader.Add , , "�\��Q����", 2000, lvwColumnLeft
    objHeader.Add , , "�J�n����", 1000, lvwColumnRight
    objHeader.Add , , "�I������", 1000, lvwColumnRight
    objHeader.Add , , "���f��t�I������", 1700, lvwColumnRight
    
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRsvGrpCd(i), vntRsvGrpCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntRsvGrpName(i)
        objItem.SubItems(2) = IIf(vntStrTime(i) > 0, Format(vntStrTime(i), "##:#0"), "�@")
        objItem.SubItems(3) = IIf(vntEndTime(i) > 0, Format(vntEndTime(i), "##:#0"), "�@")
        objItem.SubItems(4) = IIf(vntRptEndTime(i) > 0, Format(vntRptEndTime(i), "##:#0"), "�@")
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objRsvGrp = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRsvGrp = Nothing
    
End Sub
'
' �@�\�@�@ : �R�[�X��f�\��Q�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromCourseRsvGrp(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objCrsRsvGrp        As Object           '�\��Q�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntCsCd             As Variant          '�R�[�X�R�[�h
    Dim vntRsvGrpCd         As Variant          '�\��Q�R�[�h
    Dim vntmngGender        As Variant          '�j���ʘg�Ǘ�
    Dim vntDefCnt           As Variant          '�f�t�H���g�l���i���ʁj
    Dim vntDefCnt_m         As Variant          '�f�t�H���g�l���i�j�j
    Dim vntDefCnt_f         As Variant          '�f�t�H���g�l���i���j
    Dim vntDefCnt_sat       As Variant          '�f�t�H���g�l���i�y�j���ʁj
    Dim vntDefCnt_sat_m     As Variant          '�f�t�H���g�l���i�y�j�j�j
    Dim vntDefCnt_sat_f     As Variant          '�f�t�H���g�l���i�y�j���j
    Dim vntRsvGrpName       As Variant          '�\��Q����
    Dim vntCsName           As Variant          '�R�[�X����
    Dim i                   As Long             '�C���f�b�N�X

    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCrsRsvGrp = CreateObject("HainsSchedule.Schedule")
    lngCount = objCrsRsvGrp.SelectCrsRsvGrpList(vntCsCd, vntRsvGrpCd, vntmngGender, vntDefCnt, vntDefCnt_m, vntDefCnt_f, vntDefCnt_sat, vntDefCnt_sat_m, vntDefCnt_sat_f, vntRsvGrpName, vntCsName)
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�X�R�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "�R�[�X����", 1800, lvwColumnLeft
    objHeader.Add , , "�\��Q����", 1500, lvwColumnLeft
    objHeader.Add , , "�j���ʘg�Ǘ�", 1300, lvwColumnLeft
    objHeader.Add , , "�f�t�H���g�l���i���ʁj", 2100, lvwColumnLeft
    objHeader.Add , , "�f�t�H���g�l���i�j�j", 2100, lvwColumnLeft
    objHeader.Add , , "�f�t�H���g�l���i���j", 2100, lvwColumnLeft
    objHeader.Add , , "�f�t�H���g�l���i�y�j���ʁj", 2100, lvwColumnLeft
    objHeader.Add , , "�f�t�H���g�l���i�y�j�j�j", 2100, lvwColumnLeft
    objHeader.Add , , "�f�t�H���g�l���i�y�j���j", 2100, lvwColumnLeft
    
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntCsCd(i) & KEY_SEPARATE & vntRsvGrpCd(i), vntCsCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntCsName(i)
        objItem.SubItems(2) = vntRsvGrpName(i)
        If vntmngGender(i) = "1" Then
            objItem.SubItems(3) = "����"
        Else
            objItem.SubItems(3) = "���Ȃ�"
        End If
        objItem.SubItems(4) = vntDefCnt(i) & "�l"
        objItem.SubItems(5) = vntDefCnt_m(i) & "�l"
        objItem.SubItems(6) = vntDefCnt_f(i) & "�l"
        objItem.SubItems(7) = vntDefCnt_sat(i) & "�l"
        objItem.SubItems(8) = vntDefCnt_sat_m(i) & "�l"
        objItem.SubItems(9) = vntDefCnt_sat_f(i) & "�l"
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objCrsRsvGrp = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objCrsRsvGrp = Nothing
    
End Sub

'
' �@�\�@�@ : ���蕪�ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromJudClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objJudClass     As Object           '���ʃR�����g�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntJudClassCd   As Variant          '���ʃR�����g�R�[�h
    Dim vntJudClassName As Variant          '���ʃR�����g��
    Dim vntAllJudFlg    As Variant          '���͊����t���O
    Dim vntAfterCareCd  As Variant          '�A�t�^�[�P�A�R�[�h
    Dim vntIsrOrganDiv  As Variant          '���ۗp�튯�敪������
    Dim i               As Long             '�C���f�b�N�X
    
'## 2004.02.13 Added 5Lines By H.Ishihara@FSIT ���H����p���ڂ̒ǉ�
    Dim vntCommentOnly      As Variant      '�R�����g�\�����[�h
    Dim vntViewOrder        As Variant      '���蕪�ޕ\����
    Dim vntResultDispMode   As Variant      '�������ʕ\�����[�h�i���胊���N�p�j
    Dim vntNotAutoFlg       As Variant      '��������ΏۊO�t���O
    Dim vntNotNormalFlg     As Variant      '�ʏ픻��ΏۊO�t���O
'## 2004.02.13 Added End
        
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
'## 2004.02.13 Mod By H.Ishihara@FSIT ���H����p���ڂ̒ǉ�
'    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName, vntAllJudFlg, vntAfterCareCd, vntIsrOrganDiv)
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName, vntAllJudFlg, _
                                              vntAfterCareCd, vntIsrOrganDiv, _
                                              vntCommentOnly, _
                                              vntViewOrder, _
                                              vntResultDispMode, _
                                              vntNotAutoFlg, _
                                              vntNotNormalFlg)
'## 2004.02.13 Mod End
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���蕪�ރR�[�h", 1500, lvwColumnLeft
    objHeader.Add , , "���蕪�ޖ�", 2500, lvwColumnLeft
'    objHeader.Add , , "���v���̔��f", 2000, lvwColumnLeft
'## 2004.02.13 Mod By H.Ishihara@FSIT ���H����p���ڂ̒ǉ�
'    objHeader.Add , , "�A�t�^�[�P�A�R�[�h", 2000, lvwColumnLeft
'    objHeader.Add , , "���ۗp�튯�敪������", 2000, lvwColumnLeft
    objHeader.Add , , "�R�����g�p", 1000, lvwColumnCenter
    objHeader.Add , , "����\����", 1200, lvwColumnRight
    objHeader.Add , , "��������ΏۊO", 1500, lvwColumnCenter
    objHeader.Add , , "�ʏ�v�Z�ΏۊO", 1500, lvwColumnCenter
'## 2004.02.13 Mod End
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntJudClassCd(i), vntJudClassCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntJudClassName(i)
'        If vntAllJudFlg(i) = 1 Then
'            objItem.SubItems(2) = "��������Ƃ���"
'        Else
'            objItem.SubItems(2) = ""
'        End If
'## 2004.02.13 Mod By H.Ishihara@FSIT ���H����p���ڂ̒ǉ�
'        objItem.SubItems(2) = vntAfterCareCd(i)
'        objItem.SubItems(3) = vntIsrOrganDiv(i)
        objItem.SubItems(2) = IIf(vntCommentOnly(i) = "1", "��", "")
        objItem.SubItems(3) = vntViewOrder(i)
        objItem.SubItems(4) = IIf(vntNotAutoFlg(i) = "1", "��", "")
        objItem.SubItems(5) = IIf(vntNotNormalFlg(i) = "1", "��", "")
'## 2004.02.13 Mod End
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objJudClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objJudClass = Nothing
    
End Sub



'
' �@�\�@�@ : �������ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromItemClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objItemClass        As Object           '�������ރA�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntItemClassCd      As Variant          '�������ރR�[�h
    Dim vntItemClassName    As Variant          '�������ޖ�
'    Dim lngCount            As Long             '���R�[�h��
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemClass = CreateObject("HainsItem.Item")
    lngCount = objItemClass.SelectItemClassList(vntItemClassCd, vntItemClassName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�������ރR�[�h", 1400, lvwColumnLeft
    objHeader.Add , , "�������ޖ�", 4000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntItemClassCd(i), vntItemClassCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntItemClassName(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objItemClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItemClass = Nothing
    
End Sub

'
' �@�\�@�@ : �Z�b�g���ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromSetClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objSetClass        As Object           '�������ރA�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntSetClassCd      As Variant          '�������ރR�[�h
    Dim vntSetClassName    As Variant          '�������ޖ�
'    Dim lngCount            As Long             '���R�[�h��
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSetClass = CreateObject("HainsSetClass.SetClass")
    lngCount = objSetClass.SelectSetClassList(vntSetClassCd, vntSetClassName)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�Z�b�g���ރR�[�h", 1400, lvwColumnLeft
    objHeader.Add , , "�Z�b�g���ޖ�", 4000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntSetClassCd(i), vntSetClassCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntSetClassName(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objSetClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSetClass = Nothing
    
End Sub

'
' �@�\�@�@ : �O���[�v�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromGrp(strNodeKey As String, strGrpDiv As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objGrp          As Object           '�O���[�v�A�N�Z�X�p
    
'*********************:2004/08/26 FJTH)M,E **********************************************
    Dim objGrp2          As Object           '�O���[�v�A�N�Z�X�p
'*********************:2004/08/26 FJTH)M,E **********************************************

    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntGrpDiv       As Variant          '�����O���[�v�敪
    Dim vntGrpCd        As Variant          '�O���[�v�R�[�h
    Dim vntGrpName      As Variant          '�O���[�v��
    Dim vntClassCd      As Variant          '���ރR�[�h
    Dim vntClassName    As Variant          '���ޖ�
    Dim vntPrice1       As Variant          '�P���P
    Dim vntPrice2       As Variant          '�P���Q
    Dim i               As Long             '�C���f�b�N�X
    Dim strWorkPrice    As String           '���z��\�ҏW�p
'### 2003.2.17 Added by Ishihara@FSIT �V�X�e������p�O���[�v�ǉ�
    Dim vntSystemGrp    As Variant          '�V�X�e������p�O���[�v
'### 2003.2.17 Added End
    
    
'### 2006/02/03 Add by �� ST)  -------->
    Dim vntUseGrp       As Variant
    Dim strUseGrp       As String
'### 2006/02/03 Add by �� ED)  -------->
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objGrp = CreateObject("HainsGrp.Grp")
    
    '�O���[�v�敪�ɂ��ϐ��n���h�����O
    If strGrpDiv = TABLE_GRP_R Then
        vntGrpDiv = "1"
    Else
        vntGrpDiv = "2"
    End If

 
'*********************:2004/08/26 FJTH)M,E **********************************************
'    '�������ޖ�����A�������ڂȂ��ł��o�͎w��œǂݍ���
'    lngcount = objGrp.SelectGrp_IList_GrpDiv(vntGrpDiv, _
'                                             vntGrpCd, _
'                                             vntGrpName, _
'                                             vntClassCd, _
'                                             vntPrice1, _
'                                             vntPrice2, _
'                                             vntClassName, _
'                                             True, _
'                                             vntSystemGrp)
'
Set objGrp2 = CreateObject("HainsOrgGrp.Grp")
If strGrpDiv = TABLE_ORGGRP Then
    '�������ޖ�����A�������ڂȂ��ł��o�͎w��œǂݍ���
    
'## 2006/02/03 Edit by �� - UseGrp �ǉ� ST) --------------------------------------------->
'    lngcount = objGrp2.SelectGrp_ORGList_GrpDiv(vntGrpDiv, vntGrpCd, _
                                             vntGrpName, _
                                             vntSystemGrp)

    lngCount = objGrp2.SelectGrp_ORGList_GrpDiv(vntGrpDiv, vntGrpCd, _
                                             vntGrpName, _
                                             vntSystemGrp, _
                                             vntUseGrp)
'## 2006/02/03 Edit by �� - UseGrp �ǉ� ED) --------------------------------------------->


Else
    '�������ޖ�����A�������ڂȂ��ł��o�͎w��œǂݍ���
    lngCount = objGrp.SelectGrp_IList_GrpDiv(vntGrpDiv, _
                                             vntGrpCd, _
                                             vntGrpName, _
                                             vntClassCd, _
                                             vntPrice1, _
                                             vntPrice2, _
                                             vntClassName, _
                                             True, _
                                             vntSystemGrp)
End If
'*********************:2004/08/26 FJTH)M,E **********************************************
    
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�h", 1200, lvwColumnLeft
    objHeader.Add , , "�O���[�v��", 2200, lvwColumnLeft

'*********************:2004/08/26 FJTH)M,E **********************************************
'    objHeader.Add , , "��������", 1500, lvwColumnLeft
    If strGrpDiv <> TABLE_ORGGRP Then
        objHeader.Add , , "��������", 1500, lvwColumnLeft
    End If
'*********************:2004/08/26 FJTH)M,E **********************************************


'### 2003.2.17 Added by Ishihara@FSIT �V�X�e������p�O���[�v�ǉ�
    objHeader.Add , , "�V�X�e���O���[�v", 2000, lvwColumnLeft
'### 2003.2.17 Added End
'### 2002.12.22 Deleted by H.Ishihara@FSIT ���}�a�̓O���[�v�ɋ��z������Ȃ�
'    objHeader.Add , , "�P���P", 1100, lvwColumnRight
'    objHeader.Add , , "�P���Q", 1100, lvwColumnRight
'### 2002.12.22 Deleted End
        
'### 2006.02.03 Add by ��  ST) -------------------------------------->
    objHeader.Add , , "�g�p�敪", 1500, lvwColumnLeft
'### 2006.02.03 Add by ��  ED) -------------------------------------->
                
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntGrpCd(i), vntGrpCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntGrpName(i)

'*********************:2004/08/26 FJTH)M,E - s**********************************************
'            .SubItems(2) = vntClassName(i)
    If strGrpDiv <> TABLE_ORGGRP Then
            .SubItems(2) = vntClassName(i)
    End If
'*********************:2004/08/26 FJTH)M,E - e**********************************************

'*********************:2004/08/26 FJTH)M,E -s**********************************************
    If strGrpDiv = TABLE_ORGGRP Then
            If vntSystemGrp(i) = "1" Then
                .SubItems(2) = "�V�X�e���g�p�O���[�v"
            Else
                .SubItems(2) = ""
            End If
            
            '2006.02.03 Add by ���FUseGrp�ǉ�
            Select Case Format(vntUseGrp(i))
                Case 0
                    strUseGrp = ""
                Case 1
                    strUseGrp = "���я��O���[�v"
                Case 2
                    strUseGrp = "�W��FPD�O���[�v"
                Case 3
                    strUseGrp = "���v�O���[�v"
            End Select
            
            .SubItems(3) = strUseGrp
            
   Else
            If vntSystemGrp(i) = "1" Then
                .SubItems(3) = "�V�X�e���g�p�O���[�v"
            Else
                .SubItems(3) = ""
            End If
   End If
'*********************:2004/08/26 FJTH)M,E -e**********************************************
        
        
'### 2002.12.22 Deleted by H.Ishihara@FSIT ���}�a�̓O���[�v�ɋ��z������Ȃ�
'            '���z��\�ҏW
'            strWorkPrice = ""
'            If Trim(vntPrice1(i)) <> "" Then
'                strWorkPrice = "\" & Format(Trim(vntPrice1(i)), "#,###,##0")
'            End If
'            .SubItems(3) = strWorkPrice
'
'            strWorkPrice = ""
'            If Trim(vntPrice2(i)) <> "" Then
'                strWorkPrice = "\" & Format(Trim(vntPrice2(i)), "#,###,##0")
'            End If
'            .SubItems(4) = strWorkPrice
'### 2002.12.22 Deleted End
        End With
    Next i
    
    Set objGrp = Nothing
'*********************:2004/08/26 FJTH)M,E -s**********************************************
    Set objGrp2 = Nothing
'*********************:2004/08/26 FJTH)M,E -e**********************************************
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objGrp = Nothing

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
Private Sub EditListViewFromCourse(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objCourse       As Object               '�R�[�X�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g
    Dim vntCsCd         As Variant              '�R�[�X�R�[�h
    Dim vntCsName       As Variant              '�R�[�X��
    
    Dim vntMainCsCd     As Variant
    Dim vntMainCsName   As Variant
    Dim vntCsDiv        As Variant
    Dim vntRoundFlg     As Variant
    Dim vntRegularFlg   As Variant
    

    
    Dim i           As Long                 '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName, , , vntMainCsCd, vntMainCsName, vntCsDiv, vntRoundFlg, vntRegularFlg)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�X�R�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "�R�[�X��", 2500, lvwColumnLeft
    objHeader.Add , , "�R�[�X�敪", 1000, lvwColumnLeft
    objHeader.Add , , "���C���R�[�X", 2000, lvwColumnLeft
    objHeader.Add , , "�ǉ�����", 1200, lvwColumnLeft
    objHeader.Add , , "������f�t���O", 1500, lvwColumnLeft
    
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntCsCd(i), vntCsCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntCsName(i)
    
        Select Case vntCsDiv(i)
            Case "0"
                objItem.SubItems(2) = "���C���E�T�u"
            Case "1"
                objItem.SubItems(2) = "���C��"
            Case "2"
                objItem.SubItems(2) = "���C�� (�~)"
            Case "3"
                objItem.SubItems(2) = "�T�u"
        End Select
            
        If vntCsCd(i) <> vntMainCsCd(i) Then objItem.SubItems(3) = vntMainCsName(i)
        If vntRoundFlg(i) = "1" Then objItem.SubItems(4) = "���z�v�シ��"
        If vntRegularFlg(i) = "1" Then objItem.SubItems(5) = "������f"
        
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objCourse = Nothing
            
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objCourse = Nothing

End Sub

'
' �@�\�@�@ : ���蕪�ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : ���蕪�ވꗗ����m�[�h�t�H���_��W�J����B
'
Private Sub EditTreeViewFromJudClass(strNodeKey As String)

On Error GoTo ErrorHandle

    Dim colNodes        As Nodes            '�m�[�h�R���N�V����
    Dim objNode         As Node             '�m�[�h�I�u�W�F�N�g
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objListItem     As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim objJudClass     As Object           '���ʃR�����g�A�N�Z�X�p
    Dim vntJudClassCd   As Variant          '���ʃR�����g�R�[�h
    Dim vntJudClassName As Variant          '���ʃR�����g��
    Dim lngCount        As Long             '���R�[�h��
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�e�m�[�h�̕ҏW
    Set colNodes = trvMaster.Nodes
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)

    '�m�[�h������R�����g�e�[�u���̏ꍇ�A�h���ގw��Ȃ�"�m�[�h��ǉ�
'### 2003.01.17 Modified by H.Ishihara@FSIT �w�����͂ɂ��w��Ȃ����K�v
'    If strNodeKey = TABLE_JUDCMTSTC Then
    If (strNodeKey = TABLE_JUDCMTSTC) Or (strNodeKey = TABLE_GUIDANCE) Then
        '�m�[�h�L�[�͊����ČJ��Ԃ����Ƃɂ�胆�j�[�N���i����R�����g�R�[�h��8Byte�Ȃ̂ŏd�����邱�Ƃ͂Ȃ��j
        colNodes.Add strNodeKey, tvwChild, strNodeKey & strNodeKey, "�S�ĕ\��", ICON_CLOSED
    End If

    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        colNodes.Add strNodeKey, tvwChild, strNodeKey & vntJudClassCd(i), vntJudClassName(i), ICON_CLOSED
    Next i
        
    '���X�g�A�C�e���N���A
    lsvView.ListItems.Clear
    lsvView.View = lvwList
        
    '�w��m�[�h��e�ɂ��m�[�h�̓��e��ҏW
    For Each objNode In colNodes
        
        Do
            '�e�m�[�h���Ȃ���Ή������Ȃ�
            If objNode.Parent Is Nothing Then
                Exit Do
            End If
        
            '�e�m�[�h���w��m�[�h�ƈ�v���Ȃ��ꍇ�͉������Ȃ�
            If objNode.Parent.Key <> strNodeKey Then
                Exit Do
            End If
       
            '���X�g�A�C�e���̕ҏW
            Set objListItem = lsvView.ListItems.Add
            With objListItem
                .Text = objNode.Text
                .Key = objNode.Key
                .SmallIcon = ICON_CLOSED
                .Tag = NODE_TYPEFOLDER        '�f�[�^�Ƃ��Ẵ��X�g�A�C�e���Ƌ�ʂ���
            End With
            
            Exit Do
        Loop
    
    Next
    
    '�I�u�W�F�N�g�p��
    Set objJudClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objJudClass = Nothing
    
End Sub

'
' �@�\�@�@ : �������ވꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ : �������ވꗗ����m�[�h�t�H���_��W�J����B
'
Private Sub EditTreeViewFromItemClass(strNodeKey As String)

On Error GoTo ErrorHandle

    Dim colNodes            As Nodes            '�m�[�h�R���N�V����
    Dim objNode             As Node             '�m�[�h�I�u�W�F�N�g
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objListItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim objItemClass        As Object           '���ʃR�����g�A�N�Z�X�p
    Dim vntItemClassCd      As Variant          '���ʃR�����g�R�[�h
    Dim vntItemClassName    As Variant          '���ʃR�����g��
    Dim lngCount            As Long             '���R�[�h��
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�e�m�[�h�̕ҏW
    Set colNodes = trvMaster.Nodes
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemClass = CreateObject("HainsItem.Item")
    lngCount = objItemClass.SelectItemClassList(vntItemClassCd, vntItemClassName)

    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        colNodes.Add strNodeKey, tvwChild, strNodeKey & vntItemClassCd(i), vntItemClassName(i), ICON_CLOSED
    Next i
        
    '���X�g�A�C�e���N���A
    lsvView.ListItems.Clear
    lsvView.View = lvwList
        
    '�w��m�[�h��e�ɂ��m�[�h�̓��e��ҏW
    For Each objNode In colNodes
        
        Do
            '�e�m�[�h���Ȃ���Ή������Ȃ�
            If objNode.Parent Is Nothing Then
                Exit Do
            End If
        
            '�e�m�[�h���w��m�[�h�ƈ�v���Ȃ��ꍇ�͉������Ȃ�
            If objNode.Parent.Key <> strNodeKey Then
                Exit Do
            End If
       
            '���X�g�A�C�e���̕ҏW
            Set objListItem = lsvView.ListItems.Add
            With objListItem
                .Text = objNode.Text
                .Key = objNode.Key
                .SmallIcon = ICON_CLOSED
                .Tag = NODE_TYPEFOLDER        '�f�[�^�Ƃ��Ẵ��X�g�A�C�e���Ƌ�ʂ���
            End With
            
            Exit Do
        Loop
    
    Next
    
    '�I�u�W�F�N�g�p��
    Set objItemClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItemClass = Nothing
    
End Sub

'
' �@�\�@�@ : �H�i�Q�ʐێ�e�[�u���ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromNutriFoodEnergy(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objNourishment  As Object           '�T�[�o�I�u�W�F�N�g�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntEnergy       As Variant          '�G�l���M�[
    Dim vntFoodGrp1     As Variant          '�H�i�Q�P
    Dim vntFoodGrp2     As Variant          '�H�i�Q�Q
    Dim vntFoodGrp3     As Variant          '�H�i�Q�R
    Dim vntFoodGrp4     As Variant          '�H�i�Q�S
    Dim vntFoodGrp5     As Variant          '�H�i�Q�T
    Dim vntFoodGrp6     As Variant          '�H�i�Q�U
    Dim vntFoodGrp7     As Variant          '�H�i�Q�V
    
    Dim i               As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objNourishment = CreateObject("HainsNourishment.Nourishment")
    lngCount = objNourishment.SelectNutriFoodEnergy("", vntEnergy, vntFoodGrp1, vntFoodGrp2, vntFoodGrp3, vntFoodGrp4, vntFoodGrp5, vntFoodGrp6, vntFoodGrp7)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    With objHeader
        .Add , , "�G�l���M�[", 1000, lvwColumnLeft
        .Add , , "�H�i�Q�P", 1000, lvwColumnRight
        .Add , , "�H�i�Q�Q", 1000, lvwColumnRight
        .Add , , "�H�i�Q�R", 1000, lvwColumnRight
        .Add , , "�H�i�Q�S", 1000, lvwColumnRight
        .Add , , "�H�i�Q�T", 1000, lvwColumnRight
        .Add , , "�H�i�Q�U", 1000, lvwColumnRight
        .Add , , "�H�i�Q�V", 1000, lvwColumnRight
    End With
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntEnergy(i), vntEnergy(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntFoodGrp1(i)
        objItem.SubItems(2) = vntFoodGrp2(i)
        objItem.SubItems(3) = vntFoodGrp3(i)
        objItem.SubItems(4) = vntFoodGrp4(i)
        objItem.SubItems(5) = vntFoodGrp5(i)
        objItem.SubItems(6) = vntFoodGrp6(i)
        objItem.SubItems(7) = vntFoodGrp7(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objNourishment = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNourishment = Nothing
    
End Sub

'
' �@�\�@�@ : �\���H�i�e�[�u���ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromNutriCompFood(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objNourishment      As Object           '�T�[�o�I�u�W�F�N�g�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntComposeFoodCd    As Variant          '�\���H�i�R�[�h
    Dim vntComposeFoodName  As Variant          '�\���H�i��
    Dim vntFoodClassCd      As Variant          '�H�i����
    
    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objNourishment = CreateObject("HainsNourishment.Nourishment")
    lngCount = objNourishment.SelectNutriCompFood("", vntComposeFoodCd, vntComposeFoodName, vntFoodClassCd)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    With objHeader
        .Add , , "�\���H�i�R�[�h", 1500, lvwColumnLeft
        .Add , , "�\���H�i��", 3500, lvwColumnLeft
        .Add , , "�H�i����", 3500, lvwColumnLeft
    End With
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntComposeFoodCd(i), vntComposeFoodCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntComposeFoodName(i)
        Select Case vntFoodClassCd(i)
            Case "1"
                objItem.SubItems(2) = "1�F���ނ���ш��"
            Case "2"
                objItem.SubItems(2) = "2�F�ʕ�"
            Case "3"
                objItem.SubItems(2) = "3�F����E���E���E�哤���i"
            Case "4"
                objItem.SubItems(2) = "4�F�����i"
            Case "5"
                objItem.SubItems(2) = "5�F�����E�������H�i"
            Case "6"
                objItem.SubItems(2) = "6�F���"
            Case "7"
                objItem.SubItems(2) = "7�F�n�D�i�i�َq�ށj"
            Case "8"
                objItem.SubItems(2) = "8�F���̑�"
            Case "9"
                objItem.SubItems(2) = "9�F�n�D�i�i�A���R�[���j"
            Case Else
                objItem.SubItems(2) = "�H�H�H(Value=" & vntFoodClassCd(i) & ")"
        End Select
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objNourishment = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNourishment = Nothing
    
End Sub

'
' �@�\�@�@ : �h�{�v�Z�ڕW�ʃe�[�u���ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromNutriTarget(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objNourishment      As Object           '�T�[�o�I�u�W�F�N�g�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntGender           As Variant          '����
    Dim vntLowerAge         As Variant          '�N��ȏ�
    Dim vntUpperAge         As Variant          '�N��ȉ�
    Dim vntLowerHeight      As Variant          '�g���ȏ�
    Dim vntUpperHeight      As Variant          '�g���ȉ�
    Dim vntActStrength      As Variant          '�����������x
    Dim vntTotalEnergy      As Variant          '���G�l���M�[
    Dim vntProtein          As Variant          '����ς���
    Dim vntFat              As Variant          '����
    Dim vntCarbohydrate     As Variant          '�Y������
    Dim vntCalcium          As Variant          '�J���V�E��
    Dim vntIron             As Variant          '�S
    Dim vntCholesterol      As Variant          '�R���X�e���[��
    Dim vntSalt             As Variant          '����
    
    Dim i                   As Long             '�C���f�b�N�X
    Dim strGenderName       As String
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objNourishment = CreateObject("HainsNourishment.Nourishment")
    lngCount = objNourishment.SelectNutriTarget("", "", "", "", "", "", "", _
                                                vntGender, vntLowerAge, vntUpperAge, vntLowerHeight, vntUpperHeight, vntActStrength, vntTotalEnergy, _
                                                vntProtein, vntFat, vntCarbohydrate, vntCalcium, vntIron, vntCholesterol, vntSalt)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    With objHeader
        .Add , , "����", 1000, lvwColumnLeft
        .Add , , "�N��ȏ�", 1000, lvwColumnRight
        .Add , , "�N��ȉ�", 1000, lvwColumnRight
        .Add , , "�g���ȏ�", 1000, lvwColumnRight
        .Add , , "�g���ȉ�", 1000, lvwColumnRight
        .Add , , "�����������x", 1000, lvwColumnRight
        .Add , , "���G�l���M�[", 1000, lvwColumnRight
        .Add , , "����ς���", 1000, lvwColumnRight
        .Add , , "����", 1000, lvwColumnRight
        .Add , , "�Y������", 1000, lvwColumnRight
        .Add , , "�J���V�E��", 1000, lvwColumnRight
        .Add , , "�S", 1000, lvwColumnRight
        .Add , , "�R���X�e���[��", 1000, lvwColumnRight
        .Add , , "����", 1000, lvwColumnRight
    End With
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        
        Select Case vntGender(i)
            Case "1"
                strGenderName = "�j��"
            Case "2"
                strGenderName = "����"
        End Select
        
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntGender(i) & i, strGenderName, , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntLowerAge(i)
        objItem.SubItems(2) = vntUpperAge(i)
        objItem.SubItems(3) = vntLowerHeight(i)
        objItem.SubItems(4) = vntUpperHeight(i)
        objItem.SubItems(5) = vntActStrength(i)
        objItem.SubItems(6) = vntTotalEnergy(i)
        objItem.SubItems(7) = vntProtein(i)
        objItem.SubItems(8) = vntFat(i)
        objItem.SubItems(9) = vntCarbohydrate(i)
        objItem.SubItems(10) = vntCalcium(i)
        objItem.SubItems(11) = vntIron(i)
        objItem.SubItems(12) = vntCholesterol(i)
        objItem.SubItems(13) = vntSalt(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objNourishment = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNourishment = Nothing
    
End Sub

'
' �@�\�@�@ : �h�{�������X�g�e�[�u���ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromNutriMenuList(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objNourishment      As Object           '�T�[�o�I�u�W�F�N�g�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntItemCd           As Variant          '�������ڃR�[�h
    Dim vntSuffix           As Variant          '�T�t�B�b�N�X
    Dim vntItemName         As Variant          '���ږ�
    Dim vntComposeFoodCd    As Variant          '�\���H�i�R�[�h
    Dim vntComposeFoodName  As Variant          '�\���H�i��
    Dim vntFoodClassCd      As Variant          '�H�i����
    Dim vntTakeAmount       As Variant          '�ێ��
    Dim vntTotalEnergy      As Variant          '���G�l���M�[
    Dim vntProtein          As Variant          '�`����
    Dim vntFat              As Variant          '����
    Dim vntSugar            As Variant          '����
    Dim vntCalcium          As Variant          '�J���V�E��
    Dim vntIron             As Variant          '�S
    Dim vntCholesterol      As Variant          '�R���X�e���[��
    Dim vntSalt             As Variant          '����
    Dim vntLowSaltFlg       As Variant          '�����t���O
    
    Dim i                   As Long             '�C���f�b�N�X
    Dim strGenderName       As String
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objNourishment = CreateObject("HainsNourishment.Nourishment")
    lngCount = objNourishment.SelectNutriMenuList("", "", "", _
                                                  vntItemCd, vntSuffix, vntItemName, vntComposeFoodCd, vntComposeFoodName, _
                                                  vntFoodClassCd, vntTakeAmount, vntTotalEnergy, vntProtein, vntFat, _
                                                  vntSugar, vntCalcium, vntIron, vntCholesterol, vntSalt, vntLowSaltFlg)
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    With objHeader
        .Add , , "�������ڃR�[�h", 1000, lvwColumnLeft
        .Add , , "�T�t�B�b�N�X", 1200, lvwColumnLeft
        .Add , , "���ږ�", 2500, lvwColumnLeft
        .Add , , "�\���H�i�R�[�h", 1000, lvwColumnLeft
        .Add , , "�\���H�i��", 2500, lvwColumnLeft
        .Add , , "�H�i����", 2000, lvwColumnLeft
        .Add , , "�ێ��", 1000, lvwColumnLeft
        .Add , , "���G�l���M�[", 1000, lvwColumnRight
        .Add , , "�`����", 1000, lvwColumnRight
        .Add , , "����", 1000, lvwColumnRight
        .Add , , "����", 1000, lvwColumnRight
        .Add , , "�J���V�E��", 1000, lvwColumnRight
        .Add , , "�S", 1000, lvwColumnRight
        .Add , , "�R���X�e���[��", 1000, lvwColumnRight
        .Add , , "����", 1000, lvwColumnRight
        .Add , , "�����t���O", 1000, lvwColumnLeft
    End With
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        
'        Select Case vntGender(i)
'            Case "1"
'                strGenderName = "�j��"
'            Case "2"
'                strGenderName = "����"
'        End Select
        
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntItemCd(i) & "-" & vntSuffix(i) & "-" & vntComposeFoodCd(i), vntItemCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntSuffix(i)
            .SubItems(2) = vntItemName(i)
            .SubItems(3) = vntComposeFoodCd(i)
            .SubItems(4) = vntComposeFoodName(i)
            
            Select Case vntFoodClassCd(i)
                Case "1"
                    objItem.SubItems(5) = "1�F���ނ���ш��"
                Case "2"
                    objItem.SubItems(5) = "2�F�ʕ�"
                Case "3"
                    objItem.SubItems(5) = "3�F����E���E���E�哤���i"
                Case "4"
                    objItem.SubItems(5) = "4�F�����i"
                Case "5"
                    objItem.SubItems(5) = "5�F�����E�������H�i"
                Case "6"
                    objItem.SubItems(5) = "6�F���"
                Case "7"
                    objItem.SubItems(5) = "7�F�n�D�i�i�َq�ށj"
                Case "8"
                    objItem.SubItems(5) = "8�F���̑�"
                Case "9"
                    objItem.SubItems(5) = "9�F�n�D�i�i�A���R�[���j"
                Case Else
                    objItem.SubItems(5) = "�H�H�H(Value=" & vntFoodClassCd(i) & ")"
            End Select
            
            .SubItems(6) = vntTakeAmount(i)
            .SubItems(7) = vntTotalEnergy(i)
            .SubItems(8) = vntProtein(i)
            .SubItems(9) = vntFat(i)
            .SubItems(10) = vntSugar(i)
            .SubItems(11) = vntCalcium(i)
            .SubItems(12) = vntIron(i)
            .SubItems(13) = vntCholesterol(i)
            .SubItems(14) = vntSalt(i)
            If vntLowSaltFlg(i) = "1" Then
                .SubItems(15) = "����"
            Else
                .SubItems(15) = ""
            End If
        End With
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objNourishment = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNourishment = Nothing
    
End Sub

'
' �@�\�@�@ : �e��R���g���[���̃T�C�Y�ύX
'
' �����@�@ : (In)      x  �X�v���b�^�[�̍����Ԋu
'
' �߂�l�@ :
'
' ���l�@�@ : �c���[�r���[�E���X�g�r���[�E�X�v���b�^�[�E���x�����̃T�C�Y��ύX����
'
Private Sub SizeControls(X As Single)
    
    '����ݒ肵�܂��B
    If X < 3000 Then
        X = 3000
    End If
    If X > (Me.Width - 1500) Then
        X = Me.Width - 1500
    End If
    
    trvMaster.Width = X
    imgSplitter.Left = X
    lsvView.Left = X + 40
    lsvView.Width = Me.Width - (trvMaster.Width + 140)
    
    fraSearch.Width = X - imgSplitter.Width + 140
    txtSearchCode.Width = fraSearch.Width - 180 - 240
    txtSearchString.Width = txtSearchCode.Width
    cboTableName.Width = txtSearchCode.Width
    Line1.X2 = fraSearch.Width - 240
    
    lblTitle(0).Width = trvMaster.Width
    lblTitle(1).Left = lsvView.Left + 20
    lblTitle(1).Width = lsvView.Width - 40

    ''��ӂ�ݒ肵�܂��B
    trvMaster.Top = picTitles.Height + tlbMain.Height
    lsvView.Top = trvMaster.Top
    fraSearch.Top = trvMaster.Top - 70
    fraSearch.Left = 0
    
    ''������ݒ肵�܂��B
    trvMaster.Height = Me.ScaleHeight - (picTitles.Top + picTitles.Height) - stbMain.Height
    fraSearch.Height = trvMaster.Height + 70
    
    lsvView.Height = trvMaster.Height
    imgSplitter.Top = trvMaster.Top
    imgSplitter.Height = trvMaster.Height

End Sub

'
' �@�\�@�@ : �L�[�l�̕���
'
' �����@�@ : (In)      strTableName  �e�[�u����
' �@�@�@�@   (In)      strKey        �L�[�l
'
' �߂�l�@ : �L�[�l�̔z��
'
' ���l�@�@ :
'
Private Function SplitKey(ByVal strTableName As String, ByVal strKey As String) As Variant

    '�L�[�l���w�莞�͉������Ȃ�
    If strKey = "" Then
        Exit Function
    End If
    
    '�L�[�l�𕪊�
    SplitKey = Split(Right(strKey, Len(strKey) - Len(strTableName)), ",")

End Function

'
' �@�\�@�@ : �����{�^���N���b�N
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : �����ɉ������������ʂ�\������
'
' ���l�@�@ :
'
Private Sub cmdSearchStart_Click()

    Dim lngCount        As Long
    Dim colNodes        As Nodes    '�m�[�h�R���N�V����

    Screen.MousePointer = vbHourglass
    mstrNowSearchTable = ""
    
    'SEARCH�m�[�h��I���ς݂ɂ���
    trvMaster.Nodes(NODE_SEARCH).Selected = True
    
    Select Case cboTableName.ListIndex
        
        Case 0      '�˗����ڃe�[�u��
            Call EditListViewFromItem_p(TABLE_ITEM_P, "", lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_ITEM_P
        
        Case 1      '�������ڃe�[�u��
            Call EditListViewFromItem_c(TABLE_ITEM_C, "", lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_ITEM_C
        
        Case 2      '���̓e�[�u��
            Call EditListViewFromSentence(TABLE_SENTENCE_REC, lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_SENTENCE_REC
        
        Case 3      '��^�����e�[�u��
            Call EditListViewFromStdJud(TABLE_STDJUD, 0, lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_STDJUD
        
        Case 4      '����R�����g�e�[�u��
            Call EditListViewFromJudCmtStc(TABLE_JUDCMTSTC, "", lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_JUDCMTSTC
        
        Case 5      '���[�U�e�[�u��
            Call EditListViewFromHainsUser(TABLE_HAINSUSER, lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_HAINSUSER
    
    End Select
    
    '�����\��
    stbMain.Panels.Item(1).Text = lngCount & " �̃��R�[�h��������܂����B"
    
    '��ʗ���h�~
    lsvView.Refresh

    Screen.MousePointer = vbDefault
    
End Sub

Private Sub Form_Load()

    Screen.MousePointer = vbHourglass
    
    mblnComAccess = False

    '�t�H�[��������
    Call InitFormControls(Me, mcolGotFocusCollection)

    With cboTableName
        .Clear
        .AddItem "�˗����ڃe�[�u��"
        .AddItem "�������ڃe�[�u��"
        .AddItem "���̓e�[�u��"
        .AddItem "��^�����e�[�u��"
        .AddItem "����R�����g�e�[�u��"
        .AddItem "���[�U�e�[�u��"
        .ListIndex = 0
    End With
    
    '�c���[�ҏW
    Call EditTreeView

    '���X�g�r���[�ҏW�\��
    Call EditListView(NODE_ROOT)
        
    '���[�g�A�C�R���̓}�C�R���s���[�^
    trvMaster.Nodes(NODE_ROOT).Image = ICON_MYCOMPUTER
    trvMaster.Nodes(NODE_SEARCH).Image = ICON_SEARCH
    
    '�ő剻�\��
    Me.WindowState = vbMaximized
    
    '�t�H���_�\�����[�h������
    Call mnuViewFolder_Click
    
    Screen.MousePointer = vbDefault

End Sub

' @(e)
'
' �@�\�@�@ : �u�t�H�[���vResize
'
' �@�\���� : �e��R���g���[���̃T�C�Y��ύX����B
'
' ���l�@�@ :
'
Private Sub Form_Resize()
    
    If Me.WindowState <> vbMinimized Then
        If Me.Width < 10000 Then Me.Width = 10000
        If Me.Height < 8000 Then Me.Height = 8000
        Call SizeControls(imgSplitter.Left)
    End If

End Sub

Private Sub Form_Unload(Cancel As Integer)

    Set frmMaster = Nothing
    
End Sub

' @(e)
'
' �@�\�@�@ : �u�C���[�W�vMouseDown
'
' �@�\���� :
'
' ���l�@�@ :
'
Private Sub imgSplitter_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    With imgSplitter
        picSplitter.Move .Left, .Top, .Width \ 2, .Height - 20
    End With
    picSplitter.Visible = True
    PV_MovingFlg = True

End Sub
' @(e)
'
' �@�\�@�@ : �u�C���[�W�vMouseDown
'
' �@�\���� :
'
' ���l�@�@ :
'
Private Sub IMGSplitter_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    Dim sglPos As Single
    
    If PV_MovingFlg Then
        sglPos = X + imgSplitter.Left
        If sglPos < SGLSPLITLIMIT Then
            picSplitter.Left = SGLSPLITLIMIT
        ElseIf sglPos > Me.Width - SGLSPLITLIMIT Then
            picSplitter.Left = Me.Width - SGLSPLITLIMIT
        Else
            picSplitter.Left = sglPos
        End If
    End If

End Sub

Private Sub imgSplitter_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    
    Call SizeControls(picSplitter.Left)
    picSplitter.Visible = False
    PV_MovingFlg = False

End Sub

Private Sub lsvView_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    
    '�}�E�X�|�C���^�������v�̂Ƃ��͓��͖���
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    With lsvView
        .SortKey = ColumnHeader.Index - 1
        .Sorted = True
        .SortOrder = IIf(.SortOrder = lvwAscending, lvwDescending, lvwAscending)
    End With

End Sub

Private Sub lsvView_DblClick()

    Dim colNodes    As Nodes    '�m�[�h�R���N�V����
    Dim objNode     As Node     '�m�[�h�I�u�W�F�N�g
    Dim objItem     As ListItem
    Dim Ret         As Boolean
    
    
    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then Exit Sub
    
    '�w����W�Ƀ��X�g�A�C�e�������݂��Ȃ��ꍇ�͉������Ȃ�
    If lsvView.SelectedItem Is Nothing Then Exit Sub

    '���X�g�r���[��ł̏����ȊO�͏����I���i���j���[�����Open�Ή��j
    If Me.ActiveControl.Name <> "lsvView" Then Exit Sub

    '�������̕\��
    Screen.MousePointer = vbHourglass

    Set objItem = lsvView.SelectedItem

    '���X�g�r���[�\���A�C�e�����f�[�^�Ȃ炻�̃A�C�e���̍X�V��ʕ\��
    If lsvView.SelectedItem.Tag <> NODE_TYPEFOLDER Then
        
        '�����e�i���X��ʂ��J���i�e�m�[�h���^�O����Z�b�g����悤�ɂ��Ȃ��ƃt�H���_��+�ŕ�����Ǝ擾�ł��Ȃ��Ȃ�j
        Ret = ShowEditWindow(objItem.Tag, objItem.Key)
        
        '���X�g�̍ĕҏW�i�t�H���_���[�h�������e�i���X���ꂽ�ꍇ�̂݁j
        If (Ret = True) And (trvMaster.Nodes(NODE_SEARCH).Selected = False) Then
            Call EditListView(objItem.Tag, objItem.Key)
        End If
        
        Screen.MousePointer = vbDefault
        Exit Sub
    
    End If
    
    If trvMaster.Nodes(NODE_SEARCH).Selected = False Then
        
        '�t�H���_�\�����[�h�̏ꍇ
    
        '�I�����X�g�A�C�e���Ɠ���L�[�̃m�[�h���擾
        Set objNode = trvMaster.Nodes(lsvView.SelectedItem.Key)
        
        '�m�[�h��I����Ԃɂ���
        objNode.Selected = True
            
        '�I���m�[�h�̃t�H���_�̂݊J������Ԃɂ���
        Set colNodes = trvMaster.Nodes
        For Each objNode In colNodes
            objNode.Image = IIf(objNode.Selected, ICON_OPEN, ICON_CLOSED)
        Next
            
        '���X�g�ҏW
        Call EditListView(trvMaster.SelectedItem.Key)
    
    End If
    
    '## 2005.3.23  Add by ��
    trvMaster.Nodes(NODE_SECURITY_ROOT).Image = SECURITY
    '## 2005.3.23  Add �@End..
    
    
    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub lsvView_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = vbKeyReturn Then
        Call lsvView_DblClick
    End If
    
End Sub


Private Sub lsvView_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    '�w����W�Ƀ��X�g�A�C�e�������݂��Ȃ��ꍇ�͉������Ȃ�
    If lsvView.HitTest(X, Y) Is Nothing Then
        Set lsvView.SelectedItem = Nothing
    End If

End Sub

Private Sub lsvView_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim objNode     As Node     '�m�[�h�I�u�W�F�N�g
    
    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then Exit Sub

    '�E�{�^���N���b�N�ȊO�͉������Ȃ�
    If Button <> vbRightButton Then Exit Sub
    
    '�I�𒆂̃m�[�h�I�u�W�F�N�g���擾
    Set objNode = trvMaster.SelectedItem

    '�m�[�h��I�����͏������s��Ȃ�
    If objNode Is Nothing Then
        Exit Sub
    End If

    '���j���[�̃C�l�[�u������
    
'    If trvMaster.Visible = True Then
    If trvMaster.Nodes(NODE_SEARCH).Selected = False Then
        
        '�t�H���_�\�����[�h�̏ꍇ
        mnuPopUpNew.Enabled = (objNode.Children = 0)
        mnuFileNew.Enabled = (objNode.Children = 0)
        
        If lsvView.HitTest(X, Y) Is Nothing Then

            mnuPopUpUpdate.Enabled = False
            mnuFileOpen.Enabled = False

            mnuPopUpDelete.Enabled = False
            mnuEditDelete.Enabled = False

        Else
        
            mnuPopUpUpdate.Enabled = True
            mnuFileOpen.Enabled = True

            If lsvView.HitTest(X, Y).Tag <> NODE_TYPEFOLDER Then
'#### 2013.3.4 SL-SN-Y0101-612 UPD START ####
'                mnuPopUpDelete.Enabled = True
'                mnuEditDelete.Enabled = True
                If objNode.Key = TABLE_MAILCONF Then
                    mnuPopUpNew.Enabled = False
                    mnuFileNew.Enabled = False
                    mnuPopUpDelete.Enabled = False
                    mnuEditDelete.Enabled = False
                Else
                    mnuPopUpDelete.Enabled = True
                    mnuEditDelete.Enabled = True
                End If
'#### 2013.3.4 SL-SN-Y0101-612 UPD END   ####
            Else
                mnuPopUpDelete.Enabled = False
                mnuEditDelete.Enabled = False
            End If
        
        End If
        
        
'        mnuPopUpUpdate.Enabled = (objNode.Children = 0) And Not lsvView.HitTest(X, Y) Is Nothing
'        mnuFileOpen.Enabled = (objNode.Children = 0) And Not lsvView.HitTest(X, Y) Is Nothing
'
'        mnuPopUpDelete.Enabled = (objNode.Children = 0) And Not lsvView.HitTest(X, Y) Is Nothing
'        mnuEditDelete.Enabled = (objNode.Children = 0) And Not lsvView.HitTest(X, Y) Is Nothing
        
    Else
        
        '�������[�h�̏ꍇ
        mnuPopUpNew.Enabled = True
        mnuFileNew.Enabled = True
        
        mnuPopUpUpdate.Enabled = True
        mnuFileOpen.Enabled = True
        
        mnuPopUpDelete.Enabled = True
        mnuEditDelete.Enabled = True
    End If

'#### 2013.3.4 SL-SN-Y0101-612 DEL START ####
'    '�V�X�e�����ݒ�͍폜���V�K�쐬���ł��Ȃ�
'    mnuPopUpNew.Visible = (objNode.Key <> TABLE_SYSPRO)
'    mnuPopUpBar1.Visible = (objNode.Key <> TABLE_SYSPRO)
'    mnuPopUpDelete.Visible = (objNode.Key <> TABLE_SYSPRO)
'    mnuPopUpBar2.Visible = (objNode.Key <> TABLE_SYSPRO)
'#### 2013.3.4 SL-SN-Y0101-612 DEL END   ####
        
    '�|�b�v�A�b�v���j���[�\��
    PopupMenu mnuPopUp
    
End Sub

Private Sub mnuEditDelete_Click()

    Call mnuPopUpDelete_Click
    
End Sub

Private Sub mnuFileNew_Click()

    Call mnuPopUpNew_Click
    
End Sub

Private Sub mnuFileOpen_Click()

    Call lsvView_DblClick

End Sub

Private Sub mnuFileQuit_Click()

    Unload Me
    
End Sub

'## 2003.12.13 ADD TCS)H.F
Private Sub mnuOptionMch_Click()

    'MCH�A�g�i�a���}�X�^�A�g�j�Ăяo��
    Call MchByomeiCooperation

End Sub

Private Sub mnuPopUpDelete_Click()

    Dim objItem         As ListItem '���X�g�A�C�e���I�u�W�F�N�g
    Dim lngRet          As Long
    Dim Ret             As Boolean
    Dim strObjNodeKey   As String
    
    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then Exit Sub
    
    '�I�����X�g�̃I�u�W�F�N�g���擾
    Set objItem = lsvView.SelectedItem
    
    '�I�����X�g�����݂��Ȃ��ꍇ�͉������Ȃ�
    If objItem Is Nothing Then Exit Sub
    
    '�I�����X�g���t�H���_�i�f�[�^�ł͂Ȃ��j�̏ꍇ�͉������Ȃ�
    If objItem.Tag = NODE_TYPEFOLDER Then Exit Sub
    
    '�ŏI�m�F
    lngRet = MsgBox("�w�肳�ꂽ�f�[�^���폜���܂��B��낵���ł����H", vbExclamation + vbYesNo + vbDefaultButton2)
    If lngRet = vbNo Then Exit Sub
    
    '�������̕\��
    Screen.MousePointer = vbHourglass
    
    '�폜�������s
    strObjNodeKey = objItem.Tag
    Ret = DeleteRecord(objItem.Tag, objItem.Key)
    
    '���X�g�̍ĕҏW
    If Ret Then
'### 2003.01.28 Deleted 1Line by Ishihara@FSIT ����������폜
'        MsgBox "�w�肳�ꂽ�f�[�^���폜���܂���", vbInformation
        Call EditListView(strObjNodeKey)
    End If

    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub mnuPopUpNew_Click()

    Dim objNode As Node     '�m�[�h�I�u�W�F�N�g
    Dim objItem As ListItem '���X�g�A�C�e���I�u�W�F�N�g
    Dim Ret     As Boolean
    
    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then Exit Sub
    
    '�I�𒆂̃m�[�h�I�u�W�F�N�g���擾
    Set objNode = trvMaster.SelectedItem
    
    '�I���m�[�h�����݂��Ȃ��ꍇ�͉������Ȃ�
    If objNode Is Nothing Then Exit Sub
    
    '�q�m�[�h�����m�[�h�̏ꍇ�͉������Ȃ�
    If objNode.Children > 0 Then Exit Sub
    
    If trvMaster.Nodes(NODE_SEARCH).Selected = False Then
    
        '�t�H���_�\�����[�h�̏ꍇ
    
        '�����e�i���X��ʂ��J��
        Ret = ShowEditWindow(objNode.Key)
        
        '���X�g�̍ĕҏW
        If Ret Then
            Call EditListView(objNode.Key)
        End If
    
    Else
    
        If fraSearch.Visible = True Then
            '�������[�h�̏ꍇ�i�m�[�h�L�[�͑ޔ����Ă������̂�n���j
            Ret = ShowEditWindow(mstrNowSearchTable)
        Else
            '�t�H���_���[�h�̏ꍇ�A�������[�h�Ɉڍs����
            Call CntlViewMode(False)
        End If
    
    End If

    '�������̉���
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub mnuPopUpUpdate_Click()
    
    Call lsvView_DblClick
    
End Sub

Private Sub mnuViewFolder_Click()
    
    Call CntlViewMode(True)
    
End Sub

Private Sub mnuViewSearch_Click()

    Call CntlViewMode(False)

End Sub

Private Sub CntlViewMode(blnFolderMode As Boolean)

    Dim objNode     As Node     '�m�[�h�I�u�W�F�N�g
    Dim strNodeKey  As String

    '�c�[���{�^������
    With tlbMain
        If blnFolderMode Then
            .Buttons(BUTTON_KEY_FOLDER).Value = tbrPressed
            .Buttons(BUTTON_KEY_SEARCH).Value = tbrUnpressed
        Else
            .Buttons(BUTTON_KEY_FOLDER).Value = tbrUnpressed
            .Buttons(BUTTON_KEY_SEARCH).Value = tbrPressed
        End If
    End With

    '�e���[�h�̉�ʕ\������
    trvMaster.Visible = blnFolderMode
    fraSearch.Visible = Not blnFolderMode
    
    If blnFolderMode Then
        lblTitle(0).Caption = Space(1) & "�t�H���_"
        mnuViewFolder.Checked = vbChecked
        mnuViewSearch.Checked = vbUnchecked
    Else
        lblTitle(0).Caption = Space(1) & "����"
        mnuViewFolder.Checked = vbUnchecked
        mnuViewSearch.Checked = vbChecked
        
        '�I�𒆂̃m�[�h�I�u�W�F�N�g���擾
        Set objNode = trvMaster.SelectedItem
        
        '�m�[�h�I����
        If objNode Is Nothing Then
        Else
            
            '�I���m�[�h�ɑΉ������e�[�u�����f�t�H���g�\��
            strNodeKey = objNode.Key
            
            '�˗�����
            If InStr(strNodeKey, TABLE_ITEM_P) > 0 Then
                cboTableName.ListIndex = 0
            End If
        
            '��������
            If InStr(strNodeKey, TABLE_ITEM_C) > 0 Then
                cboTableName.ListIndex = 1
            End If
        
            '����
            If InStr(strNodeKey, "SENTENCE") > 0 Then
                cboTableName.ListIndex = 2
            End If
        
            '��^����
            If InStr(strNodeKey, TABLE_STDJUD) > 0 Then
                cboTableName.ListIndex = 3
            End If
        
            '����R�����g
            If InStr(strNodeKey, TABLE_JUDCMTSTC) > 0 Then
                cboTableName.ListIndex = 4
            End If
        
            '���[�U
            If InStr(strNodeKey, TABLE_HAINSUSER) > 0 Then
                cboTableName.ListIndex = 5
            End If
        
        End If
        
        txtSearchCode.SetFocus
    End If

End Sub


Private Sub mnyHelpVersion_Click()

    frmAbout.Show vbModal
    
End Sub

Private Sub tlbMain_ButtonClick(ByVal Button As MSComctlLib.Button)

    Select Case Button.Key
        
        Case BUTTON_KEY_SEARCH
            Call mnuViewSearch_Click
        
        Case BUTTON_KEY_FOLDER
            Call mnuViewFolder_Click
    
    End Select

End Sub

Private Sub trvMaster_KeyDown(KeyCode As Integer, Shift As Integer)

    mstrNodeKey = ""
    
    '�����_�őI�𒆂̃m�[�h�L�[��ޔ�
    If Not trvMaster.SelectedItem Is Nothing Then
        mstrNodeKey = trvMaster.SelectedItem.Key
    End If
    
End Sub

Private Sub trvMaster_KeyUp(KeyCode As Integer, Shift As Integer)

    Dim colNodes    As Nodes    '�m�[�h�R���N�V����
    Dim objNode     As Node     '�m�[�h�I�u�W�F�N�g
    
    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If

    '�m�[�h�R���N�V�����̎擾
    Set colNodes = trvMaster.Nodes
    
    '�I�𒆂̃m�[�h�I�u�W�F�N�g���擾
    Set objNode = trvMaster.SelectedItem

    '�m�[�h��I�����͏������s��Ȃ�
    If objNode Is Nothing Then
        Exit Sub
    End If

    'KeyDown���ɑޔ����ꂽ�m�[�h�L�[�ƌ��ݑI�𒆂̒l����v����ꍇ�͉������Ȃ�
    If objNode.Key = mstrNodeKey Then Exit Sub
    
'    '�|�b�v�A�b�v�L�[(?)���������ꂽ�ꍇ
'    If KeyCode = 93 Then
'
'        '���j���[�̃C�l�[�u������
'        mnuPopUpNew.Enabled = (objNode.Children = 0)
'        mnuPopUpUpdate.Enabled = False
'        mnuPopUpDelete.Enabled = False
'
'        '�|�b�v�A�b�v���j���[�\��
'        PopupMenu mnuPopUp
'
'        Exit Sub
'    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass

    '�I���m�[�h�̃t�H���_�̂݊J������Ԃɂ���
    For Each objNode In colNodes
        objNode.Image = IIf(objNode.Selected, ICON_OPEN, ICON_CLOSED)
    Next
    
    'ROOT�����̓}�C�R���s���[�^�A�C�R��
    trvMaster.Nodes(NODE_ROOT).Image = ICON_MYCOMPUTER
    
    '## 2005.3.23  Add by ��
    trvMaster.Nodes(NODE_SECURITY_ROOT).Image = SECURITY
    '## 2005.3.23  Add �@End..

    '���X�g�ҏW
    Call EditListView(trvMaster.SelectedItem.Key)

    '�������̉���
    Screen.MousePointer = vbDefault

End Sub

Private Sub trvMaster_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    mstrNodeKey = ""
    
    '�����_�őI�𒆂̃m�[�h�L�[��ޔ�
    If Not trvMaster.SelectedItem Is Nothing Then
        mstrNodeKey = trvMaster.SelectedItem.Key
    End If

End Sub

Private Sub trvMaster_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim colNodes    As Nodes    '�m�[�h�R���N�V����
    Dim objNode     As Node     '�m�[�h�I�u�W�F�N�g
    
    '�������̏ꍇ�͉������Ȃ�
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If

    '�m�[�h�R���N�V�����̎擾
    Set colNodes = trvMaster.Nodes
    
    '�}�E�X�I�����ꂽ�m�[�h�I�u�W�F�N�g���擾
    Set objNode = trvMaster.HitTest(X, Y)

    '�m�[�h��I�����͏������s��Ȃ�
    If objNode Is Nothing Then
        Exit Sub
    End If

    '�E�{�^�����N���b�N���ꂽ�ꍇ
    If Button = vbRightButton Then
    
        '���j���[�̃C�l�[�u������
        mnuPopUpNew.Enabled = (objNode.Children = 0)
        mnuPopUpUpdate.Enabled = False
        mnuPopUpDelete.Enabled = False
        
        '�|�b�v�A�b�v���j���[�\��
        PopupMenu mnuPopUp
        
        Exit Sub
    End If

    'MouoseDown���ɑޔ����ꂽ�m�[�h�L�[�ƌ��ݑI�𒆂̒l����v����ꍇ�͉������Ȃ�
    If objNode.Key = mstrNodeKey Then
        Exit Sub
    End If
    
    '�������̕\��
    Screen.MousePointer = vbHourglass

    '�I���m�[�h�̃t�H���_�̂݊J������Ԃɂ���
    For Each objNode In colNodes
        objNode.Image = IIf(objNode.Selected, ICON_OPEN, ICON_CLOSED)
    Next
    
    'ROOT�����̓}�C�R���s���[�^�A�C�R��
    trvMaster.Nodes(NODE_ROOT).Image = ICON_MYCOMPUTER
    
    '## 2005.3.23  Add by ��
    trvMaster.Nodes(NODE_SECURITY_ROOT).Image = SECURITY
    '## 2005.3.23  Add �@End..

    '���X�g�ҏW
    Call EditListView(trvMaster.SelectedItem.Key)

    '�������̉���
    Screen.MousePointer = vbDefault

End Sub



' @(e)
'
' �@�\�@�@ : ���b�Z�[�W�\��
'
' �@�\���� : COM���ŏ��Ɍďo�ꍇ�̑҂����ԕ\��
'
' ���l�@�@ :
'
Private Sub ShowWaitMessage()

    Dim objHeader   As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem     As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    '��x�ł�COM+�ɃA�N�Z�X���Ă����烌�X�|���X�͏o��̂ŕ\���s�v
    If mblnComAccess = True Then Exit Sub

    With lsvView
        .View = lvwReport
    
        Set objHeader = .ColumnHeaders
        objHeader.Clear
        objHeader.Add , , "�ݒ���", .Width, lvwColumnLeft
        .ListItems.Clear
        Set objItem = .ListItems.Add(, "MSG", "�ݒ�����擾���Ă��܂�...")
    
    End With
    
    Me.Refresh
    mblnComAccess = True

End Sub

Private Function ShowItemGuide(strItemCd As String, _
                               strSuffix As String, _
                               Optional strClassCd As String, _
                               Optional vntResultType As Variant) As Boolean
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '���ڃK�C�h�\���p
    
    Dim lngItemCount    As Long     '�I�����ڐ�
    Dim vntItemCd       As Variant  '�I�����ꂽ���ڃR�[�h
    Dim vntSuffix       As Variant  '�I�����ꂽ�T�t�B�b�N�X
    
    ShowItemGuide = False

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
        .MultiSelect = False
        If IsMissing(strClassCd) = False Then .ClassCd = strClassCd
        If IsMissing(vntResultType) = False Then .ResultType = CInt(vntResultType)
    
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
        
        '�߂�l�Ƃ��Ẵv���p�e�B�擾
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
    
    End With
        
    '�I��������0���ȏ�Ȃ�
    If lngItemCount > 0 Then
        strItemCd = vntItemCd(0)
        strSuffix = vntSuffix(0)
        ShowItemGuide = True
    End If

    Set objItemGuide = Nothing

End Function

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
'
' �@�\�@�@ : ���[�����M�ݒ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromMailConf(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objHeader   As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem     As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    Dim i           As Long             '�C���f�b�N�X
    
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���O", 1500, lvwColumnLeft
    objHeader.Add , , "����", 6200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & "1", "��{�ݒ�", , "DEFAULTLIST")
    objItem.SubItems(1) = "���M���[���T�[�o�[�̐ݒ�A�y�я����̓o�^���s���܂��B"
    objItem.Tag = strNodeKey
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Sub

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
'
' �@�\�@�@ : ���[���e���v���[�g�ꗗ�\��
'
' �����@�@ :
'
' �߂�l�@ :
'
' ���l�@�@ :
'
Private Sub EditListViewFromMailTemplate(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objMailTemplate     As Object           '���[�A�N�Z�X�p
    Dim objHeader           As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem             As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntTemplateCd       As Variant          '�e���v���[�g�R�[�h
    Dim vntTemplateName     As Variant          '�e���v���[�g��

    Dim i                   As Long             '�C���f�b�N�X
    
    'COM�ďo�҂����b�Z�[�W
    Call ShowWaitMessage
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objMailTemplate = CreateObject("HainsMail.Template")
    
    lngCount = objMailTemplate.SelectMailTemplateList(vntTemplateCd, vntTemplateName)
        
    '�w�b�_�̕ҏW
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "�R�[�h", 750, lvwColumnLeft
    objHeader.Add , , "�e���v���[�g��", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntTemplateCd(i), vntTemplateCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntTemplateName(i)
        End With
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objMailTemplate = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
    Set objMailTemplate = Nothing
    
End Sub
