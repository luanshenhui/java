VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmCourse 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�R�[�X���̐ݒ�"
   ClientHeight    =   7110
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6885
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmCourse.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7110
   ScaleWidth      =   6885
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   5400
      TabIndex        =   49
      Top             =   6660
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2640
      TabIndex        =   47
      Top             =   6660
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   4020
      TabIndex        =   48
      Top             =   6660
      Width           =   1275
   End
   Begin TabDlg.SSTab tabMain 
      Height          =   6435
      Left            =   120
      TabIndex        =   46
      Top             =   120
      Width           =   6615
      _ExtentX        =   11668
      _ExtentY        =   11351
      _Version        =   393216
      Style           =   1
      Tabs            =   6
      Tab             =   3
      TabsPerRow      =   6
      TabHeight       =   520
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "�l�r �S�V�b�N"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      TabCaption(0)   =   "�R�[�X"
      TabPicture(0)   =   "frmCourse.frx":000C
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "chkRegularFlg"
      Tab(0).Control(1)=   "cboMainCsCd"
      Tab(0).Control(2)=   "cboCsDiv"
      Tab(0).Control(3)=   "txtCsSName"
      Tab(0).Control(4)=   "cboDayIDDiv"
      Tab(0).Control(5)=   "cboSecondFlg"
      Tab(0).Control(6)=   "txtStrDayID"
      Tab(0).Control(7)=   "txtStaDiv"
      Tab(0).Control(8)=   "txtCsName"
      Tab(0).Control(9)=   "txtCsCd"
      Tab(0).Control(10)=   "cmdWebColor"
      Tab(0).Control(11)=   "cboStay"
      Tab(0).Control(12)=   "CommonDialog1"
      Tab(0).Control(13)=   "lblMainCsCd"
      Tab(0).Control(14)=   "Label8(2)"
      Tab(0).Control(15)=   "Label2(1)"
      Tab(0).Control(16)=   "lblColor"
      Tab(0).Control(17)=   "Label8(1)"
      Tab(0).Control(18)=   "LabelCourseGuide"
      Tab(0).Control(19)=   "Image1(0)"
      Tab(0).Control(20)=   "Label8(0)"
      Tab(0).Control(21)=   "Label4"
      Tab(0).Control(22)=   "Label3"
      Tab(0).Control(23)=   "Label2(0)"
      Tab(0).Control(24)=   "Label1(2)"
      Tab(0).Control(25)=   "lblWebColor"
      Tab(0).ControlCount=   26
      TabCaption(1)   =   "��������"
      TabPicture(1)   =   "frmCourse.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Image1(4)"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).Control(1)=   "Label5"
      Tab(1).Control(1).Enabled=   0   'False
      Tab(1).Control(2)=   "Frame1"
      Tab(1).Control(2).Enabled=   0   'False
      Tab(1).Control(3)=   "Frame2"
      Tab(1).Control(3).Enabled=   0   'False
      Tab(1).ControlCount=   4
      TabCaption(2)   =   "�R�[�X���蕪��"
      TabPicture(2)   =   "frmCourse.frx":0044
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Image1(3)"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).Control(1)=   "LabelJudGuide"
      Tab(2).Control(1).Enabled=   0   'False
      Tab(2).Control(2)=   "lsvJud"
      Tab(2).Control(2).Enabled=   0   'False
      Tab(2).Control(3)=   "cmdEditJudClass"
      Tab(2).Control(3).Enabled=   0   'False
      Tab(2).Control(4)=   "cmdUpItem"
      Tab(2).Control(4).Enabled=   0   'False
      Tab(2).Control(5)=   "cmdDownItem"
      Tab(2).Control(5).Enabled=   0   'False
      Tab(2).Control(6)=   "cmdDeleteJudClass"
      Tab(2).Control(6).Enabled=   0   'False
      Tab(2).Control(7)=   "cmdAddJudClass"
      Tab(2).Control(7).Enabled=   0   'False
      Tab(2).ControlCount=   8
      TabCaption(3)   =   "���̑�"
      TabPicture(3)   =   "frmCourse.frx":0060
      Tab(3).ControlEnabled=   -1  'True
      Tab(3).Control(0)=   "Frame3"
      Tab(3).Control(0).Enabled=   0   'False
      Tab(3).Control(1)=   "Frame4"
      Tab(3).Control(1).Enabled=   0   'False
      Tab(3).ControlCount=   2
      TabCaption(4)   =   "�������ڎ��{��"
      TabPicture(4)   =   "frmCourse.frx":007C
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "Image1(2)"
      Tab(4).Control(1)=   "LabelOperationGuide"
      Tab(4).Control(2)=   "Label6"
      Tab(4).Control(3)=   "lsvCourse_Ope"
      Tab(4).Control(4)=   "cmdEditCourse_Ope"
      Tab(4).ControlCount=   5
      TabCaption(5)   =   "�����A�g"
      TabPicture(5)   =   "frmCourse.frx":0098
      Tab(5).ControlEnabled=   0   'False
      Tab(5).Control(0)=   "tabZaimu"
      Tab(5).Control(1)=   "Image1(5)"
      Tab(5).Control(2)=   "Label7"
      Tab(5).ControlCount=   3
      Begin VB.Frame Frame4 
         Height          =   2655
         Left            =   240
         TabIndex        =   110
         Top             =   540
         Width           =   6075
         Begin VB.CheckBox chkNoPrintMonoPrice 
            Caption         =   "�������ɒP�����󎚂��Ȃ�(&N)"
            Height          =   255
            Left            =   240
            TabIndex        =   37
            Top             =   600
            Width           =   5295
         End
         Begin VB.ComboBox cboReport 
            Height          =   300
            ItemData        =   "frmCourse.frx":00B4
            Left            =   1680
            List            =   "frmCourse.frx":00D6
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   45
            Top             =   1980
            Visible         =   0   'False
            Width           =   4155
         End
         Begin VB.ComboBox cboKarteReportCd 
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
            Left            =   1680
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   43
            Top             =   1620
            Width           =   4155
         End
         Begin VB.TextBox txtEndTime 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   3960
            MaxLength       =   4
            TabIndex        =   41
            Text            =   "1234"
            Top             =   1140
            Width           =   555
         End
         Begin VB.TextBox txtStartTime 
            Height          =   315
            IMEMode         =   3  '�̌Œ�
            Left            =   1740
            MaxLength       =   4
            TabIndex        =   39
            Text            =   "1234"
            Top             =   1140
            Width           =   555
         End
         Begin VB.CheckBox chkRoundFlg 
            Caption         =   "�C�ӂ̌������ڂ�ǉ������ꍇ�A���z�v�シ��(&A)"
            Height          =   255
            Left            =   240
            TabIndex        =   36
            Top             =   300
            Width           =   5295
         End
         Begin VB.Label Label8 
            Caption         =   "�W���񍐏�(&H):"
            Height          =   195
            Index           =   3
            Left            =   180
            TabIndex        =   44
            Top             =   2040
            Visible         =   0   'False
            Width           =   1335
         End
         Begin VB.Label Label11 
            Caption         =   "�J���e�p���[(&K)�F"
            BeginProperty Font 
               Name            =   "�l�r �o�S�V�b�N"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   3
            Left            =   180
            TabIndex        =   42
            Top             =   1680
            Width           =   1455
         End
         Begin VB.Label Label11 
            Caption         =   "�����I������(&E)�F"
            BeginProperty Font 
               Name            =   "�l�r �o�S�V�b�N"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   2
            Left            =   2460
            TabIndex        =   40
            Top             =   1200
            Width           =   1455
         End
         Begin VB.Label Label11 
            Caption         =   "�����J�n����(&S)�F"
            BeginProperty Font 
               Name            =   "�l�r �o�S�V�b�N"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   1
            Left            =   180
            TabIndex        =   38
            Top             =   1200
            Width           =   1455
         End
      End
      Begin VB.CheckBox chkRegularFlg 
         Caption         =   "������N�f�f�ΏۃR�[�X"
         Height          =   255
         Left            =   -72660
         TabIndex        =   2
         Top             =   1320
         Width           =   2355
      End
      Begin VB.ComboBox cboMainCsCd 
         Height          =   300
         ItemData        =   "frmCourse.frx":00F8
         Left            =   -72180
         List            =   "frmCourse.frx":011A
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   10
         Top             =   2760
         Width           =   3390
      End
      Begin VB.ComboBox cboCsDiv 
         Height          =   300
         ItemData        =   "frmCourse.frx":013C
         Left            =   -73320
         List            =   "frmCourse.frx":015E
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   8
         Top             =   2400
         Width           =   4530
      End
      Begin VB.TextBox txtCsSName 
         Height          =   318
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   -73320
         MaxLength       =   10
         TabIndex        =   6
         Text            =   "�l�ԃh�b�N"
         Top             =   2040
         Width           =   915
      End
      Begin VB.Frame Frame3 
         Height          =   2895
         Left            =   240
         TabIndex        =   62
         Top             =   3300
         Visible         =   0   'False
         Width           =   6075
         Begin VB.ComboBox cboGovMngDiv 
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
            Left            =   2640
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   67
            Top             =   1560
            Width           =   2535
         End
         Begin VB.ComboBox cboGovMngShaho 
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
            Left            =   2640
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   66
            Top             =   2280
            Width           =   2535
         End
         Begin VB.ComboBox cboGovMng12Div 
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
            Left            =   2640
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   65
            Top             =   1920
            Width           =   2535
         End
         Begin VB.OptionButton optGovMng 
            Caption         =   "���{�Ǐ��R�[�X(&S)"
            BeginProperty Font 
               Name            =   "�l�r �o�S�V�b�N"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Index           =   1
            Left            =   2220
            TabIndex        =   64
            Top             =   1140
            Width           =   2055
         End
         Begin VB.OptionButton optGovMng 
            Caption         =   "���{�Ǐ��ΏۊO(&O)"
            BeginProperty Font 
               Name            =   "�l�r �o�S�V�b�N"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   195
            Index           =   0
            Left            =   300
            TabIndex        =   63
            Top             =   1140
            Value           =   -1  'True
            Width           =   1815
         End
         Begin VB.Label LabelGovGuide 
            Caption         =   "���{�Ǐ����N�f�f�R�[�X�̏ꍇ�ɐݒ肵�܂��B"
            Height          =   255
            Left            =   900
            TabIndex        =   71
            Top             =   540
            Width           =   3915
         End
         Begin VB.Image Image1 
            Height          =   480
            Index           =   1
            Left            =   240
            Picture         =   "frmCourse.frx":0180
            Top             =   420
            Width           =   480
         End
         Begin VB.Label Label12 
            Caption         =   "���{�Ǐ��Еۋ敪(&H)"
            BeginProperty Font 
               Name            =   "�l�r �o�S�V�b�N"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   360
            TabIndex        =   70
            Top             =   2340
            Width           =   1995
         End
         Begin VB.Label Label11 
            Caption         =   "���{�Ǐ����f�敪(&D):"
            BeginProperty Font 
               Name            =   "�l�r �o�S�V�b�N"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Index           =   0
            Left            =   360
            TabIndex        =   69
            Top             =   1620
            Width           =   1995
         End
         Begin VB.Label Label10 
            Caption         =   "���{�Ǐ��ꎟ�񎟋敪(&F):"
            BeginProperty Font 
               Name            =   "�l�r �o�S�V�b�N"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   360
            TabIndex        =   68
            Top             =   1980
            Width           =   2175
         End
      End
      Begin VB.CommandButton cmdEditCourse_Ope 
         Caption         =   "�ҏW(&E)"
         Enabled         =   0   'False
         Height          =   315
         Left            =   -70020
         TabIndex        =   60
         Top             =   4920
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddJudClass 
         Caption         =   "�ǉ�(&D)..."
         Height          =   315
         Left            =   -73380
         TabIndex        =   33
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteJudClass 
         Caption         =   "�폜(&R)"
         Height          =   315
         Left            =   -70620
         TabIndex        =   35
         Top             =   4320
         Width           =   1275
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
         Left            =   -69300
         TabIndex        =   32
         Top             =   2460
         Width           =   315
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
         Left            =   -69300
         TabIndex        =   31
         Top             =   1920
         Width           =   315
      End
      Begin VB.CommandButton cmdEditJudClass 
         Caption         =   "�ҏW(&E)"
         Height          =   315
         Left            =   -72000
         TabIndex        =   34
         Top             =   4320
         Width           =   1275
      End
      Begin VB.ComboBox cboDayIDDiv 
         Height          =   300
         ItemData        =   "frmCourse.frx":05C2
         Left            =   -73320
         List            =   "frmCourse.frx":05E4
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   14
         Top             =   4020
         Width           =   2910
      End
      Begin VB.Frame Frame2 
         Caption         =   "��f����(&C)"
         Height          =   3375
         Left            =   -74760
         TabIndex        =   25
         Top             =   2820
         Visible         =   0   'False
         Width           =   6015
         Begin VB.CommandButton cmdItemProperty 
            Caption         =   "�v���p�e�B(&O)"
            Height          =   315
            Left            =   4620
            TabIndex        =   29
            Top             =   2940
            Width           =   1275
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "�폜(&R)"
            Height          =   315
            Left            =   3240
            TabIndex        =   28
            Top             =   2940
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "�ǉ�(&A)..."
            Enabled         =   0   'False
            Height          =   315
            Left            =   1860
            TabIndex        =   27
            Top             =   2940
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   2595
            Left            =   120
            TabIndex        =   26
            Top             =   240
            Width           =   5775
            _ExtentX        =   10186
            _ExtentY        =   4577
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
      End
      Begin VB.Frame Frame1 
         Caption         =   "�����f�[�^(&H)"
         Height          =   1515
         Left            =   -74760
         TabIndex        =   20
         Top             =   1200
         Width           =   6015
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
            ItemData        =   "frmCourse.frx":0606
            Left            =   240
            List            =   "frmCourse.frx":0628
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   21
            Top             =   300
            Width           =   5610
         End
         Begin VB.CommandButton cmdNewHistory 
            Caption         =   "�V�K(&N)..."
            Enabled         =   0   'False
            Height          =   315
            Left            =   1800
            TabIndex        =   22
            Top             =   720
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditHistory 
            Caption         =   "�ҏW(&E)..."
            Enabled         =   0   'False
            Height          =   315
            Left            =   3180
            TabIndex        =   23
            Top             =   720
            Width           =   1275
         End
         Begin VB.CommandButton cmdDeleteHistory 
            Caption         =   "�폜(&D)..."
            Enabled         =   0   'False
            Height          =   315
            Left            =   4560
            TabIndex        =   24
            Top             =   720
            Width           =   1275
         End
         Begin VB.Label lblPrice 
            Alignment       =   1  '�E����
            Caption         =   "�R�[�X��{����: \50,000"
            Height          =   255
            Left            =   3840
            TabIndex        =   56
            Top             =   1200
            Width           =   1995
         End
         Begin VB.Label lblCsHNo 
            Caption         =   "����No: 3"
            Height          =   255
            Left            =   2880
            TabIndex        =   55
            Top             =   1200
            Width           =   855
         End
      End
      Begin VB.ComboBox cboSecondFlg 
         Height          =   300
         ItemData        =   "frmCourse.frx":064A
         Left            =   -73320
         List            =   "frmCourse.frx":066C
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   12
         Top             =   3180
         Width           =   1650
      End
      Begin VB.TextBox txtStrDayID 
         Height          =   318
         Left            =   -69180
         MaxLength       =   4
         TabIndex        =   50
         Text            =   "1234"
         Top             =   5340
         Visible         =   0   'False
         Width           =   495
      End
      Begin VB.TextBox txtStaDiv 
         Height          =   318
         Left            =   -70320
         MaxLength       =   1
         TabIndex        =   17
         Text            =   "5"
         Top             =   4440
         Width           =   375
      End
      Begin VB.TextBox txtCsName 
         Height          =   318
         IMEMode         =   4  '�S�p�Ђ炪��
         Left            =   -73320
         MaxLength       =   30
         TabIndex        =   4
         Text            =   "�l�ԃh�b�N"
         Top             =   1680
         Width           =   2835
      End
      Begin VB.TextBox txtCsCd 
         Height          =   315
         IMEMode         =   3  '�̌Œ�
         Left            =   -73320
         MaxLength       =   4
         TabIndex        =   1
         Text            =   "1234"
         Top             =   1320
         Width           =   555
      End
      Begin VB.CommandButton cmdWebColor 
         Caption         =   "�\���F(&W)"
         Height          =   315
         Left            =   -74760
         TabIndex        =   15
         Top             =   4440
         Width           =   1335
      End
      Begin VB.ComboBox cboStay 
         Height          =   300
         ItemData        =   "frmCourse.frx":068E
         Left            =   -73320
         List            =   "frmCourse.frx":06B0
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   19
         Top             =   5220
         Width           =   1650
      End
      Begin MSComDlg.CommonDialog CommonDialog1 
         Left            =   -69120
         Top             =   5760
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
      End
      Begin MSComctlLib.ListView lsvJud 
         Height          =   2895
         Left            =   -74700
         TabIndex        =   30
         Top             =   1260
         Width           =   5355
         _ExtentX        =   9446
         _ExtentY        =   5106
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
      Begin MSComctlLib.ListView lsvCourse_Ope 
         Height          =   3195
         Left            =   -74820
         TabIndex        =   58
         Top             =   1620
         Width           =   6075
         _ExtentX        =   10716
         _ExtentY        =   5636
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
      Begin TabDlg.SSTab tabZaimu 
         Height          =   3135
         Left            =   -74760
         TabIndex        =   72
         Top             =   1200
         Visible         =   0   'False
         Width           =   5955
         _ExtentX        =   10504
         _ExtentY        =   5530
         _Version        =   393216
         Style           =   1
         Tabs            =   2
         TabHeight       =   520
         TabCaption(0)   =   "�l����"
         TabPicture(0)   =   "frmCourse.frx":06D2
         Tab(0).ControlEnabled=   -1  'True
         Tab(0).Control(0)=   "lblZaimuName(5)"
         Tab(0).Control(0).Enabled=   0   'False
         Tab(0).Control(1)=   "lblZaimuCd(5)"
         Tab(0).Control(1).Enabled=   0   'False
         Tab(0).Control(2)=   "lblZaimuName(4)"
         Tab(0).Control(2).Enabled=   0   'False
         Tab(0).Control(3)=   "lblZaimuCd(4)"
         Tab(0).Control(3).Enabled=   0   'False
         Tab(0).Control(4)=   "lblZaimuName(3)"
         Tab(0).Control(4).Enabled=   0   'False
         Tab(0).Control(5)=   "lblZaimuCd(3)"
         Tab(0).Control(5).Enabled=   0   'False
         Tab(0).Control(6)=   "lblZaimuName(2)"
         Tab(0).Control(6).Enabled=   0   'False
         Tab(0).Control(7)=   "lblZaimuCd(2)"
         Tab(0).Control(7).Enabled=   0   'False
         Tab(0).Control(8)=   "lblZaimuName(1)"
         Tab(0).Control(8).Enabled=   0   'False
         Tab(0).Control(9)=   "lblZaimuCd(1)"
         Tab(0).Control(9).Enabled=   0   'False
         Tab(0).Control(10)=   "lblZaimuName(0)"
         Tab(0).Control(10).Enabled=   0   'False
         Tab(0).Control(11)=   "lblZaimuCd(0)"
         Tab(0).Control(11).Enabled=   0   'False
         Tab(0).Control(12)=   "cmdZaimuCd(5)"
         Tab(0).Control(12).Enabled=   0   'False
         Tab(0).Control(13)=   "cmdZaimuCd(4)"
         Tab(0).Control(13).Enabled=   0   'False
         Tab(0).Control(14)=   "cmdZaimuCd(3)"
         Tab(0).Control(14).Enabled=   0   'False
         Tab(0).Control(15)=   "cmdZaimuCd(2)"
         Tab(0).Control(15).Enabled=   0   'False
         Tab(0).Control(16)=   "cmdZaimuCd(1)"
         Tab(0).Control(16).Enabled=   0   'False
         Tab(0).Control(17)=   "cmdZaimuCd(0)"
         Tab(0).Control(17).Enabled=   0   'False
         Tab(0).ControlCount=   18
         TabCaption(1)   =   "�c�̐���"
         TabPicture(1)   =   "frmCourse.frx":06EE
         Tab(1).ControlEnabled=   0   'False
         Tab(1).Control(0)=   "lblZaimuName(11)"
         Tab(1).Control(1)=   "lblZaimuCd(11)"
         Tab(1).Control(2)=   "lblZaimuName(10)"
         Tab(1).Control(3)=   "lblZaimuCd(10)"
         Tab(1).Control(4)=   "lblZaimuName(9)"
         Tab(1).Control(5)=   "lblZaimuCd(9)"
         Tab(1).Control(6)=   "lblZaimuName(8)"
         Tab(1).Control(7)=   "lblZaimuCd(8)"
         Tab(1).Control(8)=   "lblZaimuName(7)"
         Tab(1).Control(9)=   "lblZaimuCd(7)"
         Tab(1).Control(10)=   "lblZaimuName(6)"
         Tab(1).Control(11)=   "lblZaimuCd(6)"
         Tab(1).Control(12)=   "cmdZaimuCd(11)"
         Tab(1).Control(13)=   "cmdZaimuCd(10)"
         Tab(1).Control(14)=   "cmdZaimuCd(9)"
         Tab(1).Control(15)=   "cmdZaimuCd(8)"
         Tab(1).Control(16)=   "cmdZaimuCd(7)"
         Tab(1).Control(17)=   "cmdZaimuCd(6)"
         Tab(1).ControlCount=   18
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "����(&1)..."
            Height          =   315
            Index           =   0
            Left            =   240
            TabIndex        =   84
            Top             =   540
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "��������(&2)..."
            Height          =   315
            Index           =   1
            Left            =   240
            TabIndex        =   83
            Top             =   960
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "�ߋ�����(&3)..."
            Height          =   315
            Index           =   2
            Left            =   240
            TabIndex        =   82
            Top             =   1380
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "�ҕt����(&4)..."
            Height          =   315
            Index           =   3
            Left            =   240
            TabIndex        =   81
            Top             =   1800
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "�ҕt������(&5)..."
            Height          =   315
            Index           =   4
            Left            =   240
            TabIndex        =   80
            Top             =   2220
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "�ҕt�����(&6)..."
            Height          =   315
            Index           =   5
            Left            =   240
            TabIndex        =   79
            Top             =   2640
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "����(&1)..."
            Height          =   315
            Index           =   6
            Left            =   -74760
            TabIndex        =   78
            Top             =   540
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "��������(&2)..."
            Height          =   315
            Index           =   7
            Left            =   -74760
            TabIndex        =   77
            Top             =   960
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "�ߋ�����(&3)..."
            Height          =   315
            Index           =   8
            Left            =   -74760
            TabIndex        =   76
            Top             =   1380
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "�ҕt����(&4)..."
            Height          =   315
            Index           =   9
            Left            =   -74760
            TabIndex        =   75
            Top             =   1800
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "�ҕt������(&5)..."
            Height          =   315
            Index           =   10
            Left            =   -74760
            TabIndex        =   74
            Top             =   2220
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "�ҕt�����(&6)..."
            Height          =   315
            Index           =   11
            Left            =   -74760
            TabIndex        =   73
            Top             =   2640
            Width           =   1995
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   0
            Left            =   2340
            TabIndex        =   108
            Top             =   600
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   0
            Left            =   3120
            TabIndex        =   107
            Top             =   600
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   1
            Left            =   2340
            TabIndex        =   106
            Top             =   1020
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   1
            Left            =   3120
            TabIndex        =   105
            Top             =   1020
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   2
            Left            =   2340
            TabIndex        =   104
            Top             =   1440
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   2
            Left            =   3120
            TabIndex        =   103
            Top             =   1440
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   3
            Left            =   2340
            TabIndex        =   102
            Top             =   1860
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   3
            Left            =   3120
            TabIndex        =   101
            Top             =   1860
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   4
            Left            =   2340
            TabIndex        =   100
            Top             =   2280
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   4
            Left            =   3120
            TabIndex        =   99
            Top             =   2280
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   5
            Left            =   2340
            TabIndex        =   98
            Top             =   2700
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   5
            Left            =   3120
            TabIndex        =   97
            Top             =   2700
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   6
            Left            =   -72660
            TabIndex        =   96
            Top             =   600
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   6
            Left            =   -71880
            TabIndex        =   95
            Top             =   600
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   7
            Left            =   -72660
            TabIndex        =   94
            Top             =   1020
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   7
            Left            =   -71880
            TabIndex        =   93
            Top             =   1020
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   8
            Left            =   -72660
            TabIndex        =   92
            Top             =   1440
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   8
            Left            =   -71880
            TabIndex        =   91
            Top             =   1440
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   9
            Left            =   -72660
            TabIndex        =   90
            Top             =   1860
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   9
            Left            =   -71880
            TabIndex        =   89
            Top             =   1860
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   10
            Left            =   -72660
            TabIndex        =   88
            Top             =   2280
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   10
            Left            =   -71880
            TabIndex        =   87
            Top             =   2280
            Width           =   2535
         End
         Begin VB.Label lblZaimuCd 
            Caption         =   "A00002"
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
            Index           =   11
            Left            =   -72660
            TabIndex        =   86
            Top             =   2700
            Width           =   675
         End
         Begin VB.Label lblZaimuName 
            Caption         =   "�l���i�ҕt�����쐬�@��������"
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
            Index           =   11
            Left            =   -71880
            TabIndex        =   85
            Top             =   2700
            Width           =   2535
         End
      End
      Begin VB.Label lblMainCsCd 
         Caption         =   "���C���R�[�X(&S):"
         ForeColor       =   &H80000011&
         Height          =   195
         Left            =   -73320
         TabIndex        =   9
         Top             =   2820
         Width           =   1155
      End
      Begin VB.Label Label8 
         Caption         =   "�R�[�X�敪(&S):"
         Height          =   195
         Index           =   2
         Left            =   -74760
         TabIndex        =   7
         Top             =   2460
         Width           =   1335
      End
      Begin VB.Label Label2 
         Caption         =   "�R�[�X����(&R):"
         Height          =   195
         Index           =   1
         Left            =   -74760
         TabIndex        =   5
         Top             =   2100
         Width           =   1095
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   5
         Left            =   -74700
         Picture         =   "frmCourse.frx":070A
         Top             =   540
         Width           =   480
      End
      Begin VB.Label Label7 
         Caption         =   "�����A�g���ɓK�p����R�[�h��ݒ肵�܂��B"
         Height          =   255
         Left            =   -74040
         TabIndex        =   109
         Top             =   660
         Width           =   3555
      End
      Begin VB.Label Label6 
         Caption         =   "��""0""�͓�����\���܂��B"
         Height          =   315
         Left            =   -74760
         TabIndex        =   61
         Top             =   4920
         Width           =   2115
      End
      Begin VB.Label LabelOperationGuide 
         Caption         =   "���̃R�[�X�Ŏ�f���鍀�ڂ̌������{����ݒ肵�܂��B"
         Height          =   735
         Left            =   -74100
         TabIndex        =   59
         Top             =   780
         Width           =   4575
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   2
         Left            =   -74760
         Picture         =   "frmCourse.frx":0B4C
         Top             =   660
         Width           =   480
      End
      Begin VB.Label LabelJudGuide 
         Caption         =   "���̃R�[�X�ŊǗ����锻�蕪�ނ�ݒ肵�܂��B"
         Height          =   255
         Left            =   -74100
         TabIndex        =   57
         Top             =   720
         Width           =   3555
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   3
         Left            =   -74760
         Picture         =   "frmCourse.frx":0F8E
         Top             =   600
         Width           =   480
      End
      Begin VB.Label Label5 
         Caption         =   "���̃R�[�X����f����ۂɌ������鍀�ڂ�ݒ肵�܂��B"
         Height          =   255
         Left            =   -73980
         TabIndex        =   54
         Top             =   660
         Width           =   4275
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   4
         Left            =   -74760
         Picture         =   "frmCourse.frx":13D0
         Top             =   540
         Width           =   480
      End
      Begin VB.Label lblColor 
         Caption         =   "#FFFFFF"
         Height          =   255
         Left            =   -72900
         TabIndex        =   53
         Top             =   4500
         Width           =   1035
      End
      Begin VB.Label Label8 
         Caption         =   "�Q�����f(&D):"
         Height          =   195
         Index           =   1
         Left            =   -74760
         TabIndex        =   11
         Top             =   3240
         Width           =   1335
      End
      Begin VB.Label LabelCourseGuide 
         Caption         =   "�R�[�X�̊�{�I�ȏ���ݒ肵�܂��B"
         Height          =   255
         Left            =   -74160
         TabIndex        =   52
         Top             =   660
         Width           =   3915
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   0
         Left            =   -74820
         Picture         =   "frmCourse.frx":1812
         Top             =   540
         Width           =   480
      End
      Begin VB.Label Label8 
         Caption         =   "��f������(&S):"
         Height          =   195
         Index           =   0
         Left            =   -74760
         TabIndex        =   18
         Top             =   5280
         Width           =   1335
      End
      Begin VB.Label Label4 
         Caption         =   "����ID�͈̔�(I):"
         Height          =   195
         Left            =   -74760
         TabIndex        =   13
         Top             =   4080
         Width           =   1335
      End
      Begin VB.Label Label3 
         Caption         =   "���v�敪(&T):"
         Height          =   195
         Left            =   -71400
         TabIndex        =   16
         Top             =   4500
         Width           =   1095
      End
      Begin VB.Label Label2 
         Caption         =   "�R�[�X��(&N):"
         Height          =   195
         Index           =   0
         Left            =   -74760
         TabIndex        =   3
         Top             =   1740
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "�R�[�X�R�[�h(&C):"
         Height          =   195
         Index           =   2
         Left            =   -74760
         TabIndex        =   0
         Top             =   1380
         Width           =   1275
      End
      Begin VB.Label lblWebColor 
         BorderStyle     =   1  '����
         Height          =   315
         Left            =   -73320
         TabIndex        =   51
         Top             =   4440
         Width           =   315
      End
   End
End
Attribute VB_Name = "frmCourse"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�v���p�e�B�p�̈�
Private mstrCsCd            As String   '�R�[�X�R�[�h
Private mblnUpdated         As Boolean  'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnInitialize      As Boolean  'TRUE:����ɏ������AFALSE:���������s

Private mstrArrDayIDDivCd() As String   '�����h�c�R���{�Ή��L�[�i�[�̈�
Private mintBeforeIndex     As Integer  '�����R���{�ύX�L�����Z���p�̑OIndex
Private mblnNowEdit         As Boolean  'TRUE:�ҏW�������AFALSE:�����Ȃ�

'�����R���{�Ή��f�[�^�ޔ�p
Private mintCsHNo()         As Integer  '�����R���{�ɑΉ����闚��ԍ�
Private mstrStrDate()       As String   '�����R���{�ɑΉ�����J�n���t
Private mstrEndDate()       As String   '�����R���{�ɑΉ�����I�����t
Private mlngPrice()         As Long     '�����R���{�ɑΉ�����R�[�X��{����

'�^�u�N���b�N���̕\������p�t���O
Private mblnShowItem        As Boolean  'TRUE:�\���ς݁AFALSE:���\��
Private mblnShowOpe         As Boolean  'TRUE:�\���ς݁AFALSE:���\��
Private mblnShowJud         As Boolean  'TRUE:�\���ς݁AFALSE:���\��
Private mblnShowGov         As Boolean  'TRUE:�\���ς݁AFALSE:���\��

'�ۑ��Ώۃf�[�^����p
Private mblnEditMain        As Boolean  '�R�[�X��{�f�[�^�iTRUE:�X�V�AFALSE:���X�V�j
Private mblnEditItem        As Boolean  '�R�[�X���������ڃf�[�^�iTRUE:�X�V�AFALSE:���X�V�j
Private mblnEditJud         As Boolean  '�R�[�X������f�[�^�iTRUE:�X�V�AFALSE:���X�V�j
Private mblnEditOpe         As Boolean  '�R�[�X���������ڎ��{���f�[�^�iTRUE:�X�V�AFALSE:���X�V�j

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����
Private mcolZaimuCollection     As Collection   '�����A�g�K�p�R�[�h�R���N�V����

'�Œ�R�[�h�Ǘ�
Const GRPDIV_ITEM           As String = "I"
Const GRPDIV_GRP            As String = "G"
Const mstrListViewKey       As String = "K"

Const NOREASON_TEXT         As String = "����"
Private Const KEY_PREFIX    As String = "K"           '�R���N�V�����L�[�v���t�B�b�N�X
Private mstrRootCsCd()      As String   '�R���{�{�b�N�X�ɑΉ�����R�[�X�R�[�h�̊i�[
Private mstrReportCd()      As String   '�R���{�{�b�N�X�ɑΉ�����񍐏����[�R�[�h�̊i�[
Private mstrKarteCd()       As String   '�R���{�{�b�N�X�ɑΉ�����J���e���[�R�[�h�̊i�[
Private mstrReportCd_OnRead As String
Private mstrKarteCd_OnRead  As String

Private Sub MoveListItem(intMovePosition As Integer)

    Dim i                   As Integer
    Dim j                   As Integer
    Dim intSelectedCount    As Integer
    Dim intSelectedIndex    As Integer
    Dim intTargetIndex      As Integer
    Dim objItem             As ListItem             '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim strEscCd()          As String
    Dim strEscName()        As String
    Dim strEscNoReason()    As String
    
    intSelectedCount = 0

    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvJud.ListItems.Count

        '�I������Ă��鍀�ڂȂ�
        If lsvJud.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '�I�����ڐ����P�ȊO�Ȃ珈�����Ȃ�
    If intSelectedCount <> 1 Then Exit Sub
    
    '����Up�w�肩�A�I�����ڂ��擪�Ȃ牽�����Ȃ�
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '����Down�w�肩�A�I�����ڂ��ŏI�Ȃ牽�����Ȃ�
    If (intSelectedIndex = lsvJud.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    If intMovePosition = -1 Then
        '����Up�̏ꍇ�A��O�̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex - 1
    Else
        '����Down�̏ꍇ�A���݂̗v�f���^�[�Q�b�g�Ƃ���B
        intTargetIndex = intSelectedIndex
    End If
    
    '���X�g�r���[�����邭��񂵂đS���ڔz��쐬
    For i = 1 To lsvJud.ListItems.Count
        
        ReDim Preserve strEscCd(i)
        ReDim Preserve strEscName(i)
        ReDim Preserve strEscNoReason(i)
        
        If intTargetIndex = i Then
        
            strEscCd(i) = lsvJud.ListItems(i + 1)
            strEscName(i) = lsvJud.ListItems(i + 1).SubItems(1)
            strEscNoReason(i) = lsvJud.ListItems(i + 1).SubItems(2)
        
            i = i + 1
        
            ReDim Preserve strEscCd(i)
            ReDim Preserve strEscName(i)
            ReDim Preserve strEscNoReason(i)
        
            strEscCd(i) = lsvJud.ListItems(intTargetIndex)
            strEscName(i) = lsvJud.ListItems(intTargetIndex).SubItems(1)
            strEscNoReason(i) = lsvJud.ListItems(intTargetIndex).SubItems(2)
        
        Else
            strEscCd(i) = lsvJud.ListItems(i)
            strEscName(i) = lsvJud.ListItems(i).SubItems(1)
            strEscNoReason(i) = lsvJud.ListItems(i).SubItems(2)
        
        End If
    
    Next i
    
    lsvJud.ListItems.Clear
    
    '�w�b�_�̕ҏW
    With lsvJud.ColumnHeaders
        .Clear
        .Add , , "�R�[�h", 700, lvwColumnLeft
        .Add , , "���蕪��", 2500, lvwColumnLeft
        .Add , , "�������W�J", 1500, lvwColumnLeft
    End With
    
    '���X�g�̕ҏW
    For i = 1 To UBound(strEscCd)
        Set objItem = lsvJud.ListItems.Add(, mstrListViewKey & strEscCd(i), strEscCd(i))
        objItem.SubItems(1) = strEscName(i)
        objItem.SubItems(2) = strEscNoReason(i)
    Next i

    lsvJud.ListItems(1).Selected = False
    
    If intMovePosition = 1 Then
        lsvJud.ListItems(intTargetIndex + 1).Selected = True
    Else
        lsvJud.ListItems(intTargetIndex).Selected = True
    End If
    
    lsvJud.SetFocus

    '�X�V��Ԃ��Ǘ�
    mblnEditJud = True

End Sub

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Friend Property Let CsCd(ByVal vntNewValue As Variant)

    mstrCsCd = vntNewValue
    
End Property

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

    Dim Ret             As Boolean      '�֐��߂�l
    Dim objListItem     As ListItem
    Dim i               As Integer
    Dim objTimeTextBox  As TextBox      '�J�n�I�����ԃ`�F�b�N�p�e�L�X�g�{�b�N�X
    
    '��������
    Ret = False
    
    Do
        If Trim(txtCsCd.Text) = "" Then
            MsgBox "�R�[�X�R�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCsCd.SetFocus
            Exit Do
        End If
        
'### 2003/11/12 Deleted by Ishihara@FSIT ���H���ł͂R��
'        If Len(Trim(txtCsCd.Text)) < 4 Then
'            MsgBox "�R�[�X�R�[�h�̓o�[�R�[�h�̊֌W��K���S���Őݒ肵�Ă��������B", vbExclamation, App.Title
'            tabMain.Tab = 0
'            txtCsCd.SetFocus
'            Exit Do
'        End If
'### 2003/11/12 Deleted End

        If Trim(txtCsName.Text) = "" Then
            MsgBox "�R�[�X�������͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCsName.SetFocus
            Exit Do
        End If

        '���̂��Z�b�g����Ă��Ȃ��ꍇ�A�����I�ɖ��̐擪�T�����i�[
        If Trim(txtCsSName.Text) = "" Then
            txtCsSName.Text = Mid(Trim(txtCsName.Text), 1, 5)
        End If

        If (cboCsDiv.ListIndex = 3) And (cboMainCsCd.ListIndex = 0) Then
            MsgBox "�T�u�R�[�X�̏ꍇ�A�K�����C���R�[�X��I�����Ă��������B", vbExclamation, App.Title
            tabMain.Tab = 0
            cboMainCsCd.SetFocus
            Exit Do
        End If

        If (Trim(txtStaDiv.Text) <> "") And (IsNumeric(Trim(txtStaDiv.Text)) = False) Then
            MsgBox "���v�敪�ɂ͐��l����͂��Ă�������", vbExclamation, App.Title
            tabMain.Tab = 0
            txtStaDiv.SetFocus
            Exit Do
        End If

        '�������ڎ��{���̃`�F�b�N
        If lsvCourse_Ope.ListItems.Count > 0 Then
            
            For Each objListItem In lsvCourse_Ope.ListItems
                If objListItem.SubItems(2) <> "" Then
                    For i = 2 To 8
                        If objListItem.SubItems(i) > cboStay.ListIndex + 1 Then
                            MsgBox "�R�[�X�̔����� " & cboStay.ListIndex & "�ɐݒ肳��Ă��܂��B" & _
                                   "�w�肳�ꂽ�������͊i�[���邱�Ƃ��ł��܂���B", vbExclamation
                            objListItem.Selected = True
                            tabMain.Tab = 4
                            Exit Do
                        End If
                    Next i
                End If
            Next objListItem
        
        End If

        '�J�n�I�����Ԃ̐������`�F�b�N
        For i = 0 To 1
        
            '�Q��Loop���A�J�n�I���̉��ꂩ���Z�b�g
            If i = 0 Then
                Set objTimeTextBox = txtStartTime
            Else
                Set objTimeTextBox = txtEndTime
            End If
        
            '���̓f�[�^�����݂���ꍇ�̂݁A�`�F�b�N�B
            If Trim(objTimeTextBox.Text) <> "" Then
            
                '���l�^�C�v�y�ь����`�F�b�N
'### 2003.03.13 Updated by Ishihara@FSIT Oracle�Ɋi�[����ƂR���ɂȂ邱�Ƃ̍l������
'                If (IsNumeric(Trim(objTimeTextBox.Text)) = False) Or (Len(Trim(objTimeTextBox.Text)) <> 4) Then
'                    MsgBox "�������Ԃɂ͐��l�i�����̂S���j����͂��Ă�������", vbExclamation, App.Title
'                    tabMain.Tab = 3
'                    objTimeTextBox.SetFocus
'                    Exit Do
'                End If
                
                '���l�^�C�v�`�F�b�N
                If IsNumeric(Trim(objTimeTextBox.Text)) = False Then
                    MsgBox "�������Ԃɂ͐��l�i�����̂S���j����͂��Ă�������", vbExclamation, App.Title
                    tabMain.Tab = 3
                    objTimeTextBox.SetFocus
                    Exit Do
                End If

                '�`�F�b�N�p�ɂS���ϊ�
                objTimeTextBox.Text = Format(Trim(objTimeTextBox.Text), "0000")
'### 2003.03.13 Updated End
            
                If CInt(Mid((Trim(objTimeTextBox.Text)), 1, 2)) > 25 Then
                    MsgBox "���������Ԃ��Z�b�g���Ă��������B", vbExclamation, App.Title
                    tabMain.Tab = 3
                    objTimeTextBox.SetFocus
                    Exit Do
                End If
            
                If CInt(Mid((Trim(objTimeTextBox.Text)), 3, 2)) > 59 Then
                    MsgBox "���������Ԃ��Z�b�g���Ă��������B", vbExclamation, App.Title
                    tabMain.Tab = 3
                    objTimeTextBox.SetFocus
                    Exit Do
                End If
            
            End If
        
        Next i

'### 2002.11.12 Del By H.Ishihara@FSIT ���}�a�d�l�ɍ����֘A���͕s�v
'        '�����A�g�p�R�[�h�̐ݒ�`�F�b�N
''### 2002.03.23 Updated By H.Ishihara@FSIT �ҕt�͎g�p���Ȃ�
''        For i = 0 To 11
''            If lblZaimuCd(i).Caption = "" Then
''                MsgBox "�����A�g�p�̓K�p�R�[�h�͕K���ݒ肵�Ă�������", vbExclamation, App.Title
''                tabMain.Tab = 5
''                If i < 6 Then
''                    tabZaimu.Tab = 0
''                Else
''                    tabZaimu.Tab = 1
''                End If
''                Exit Do
''            End If
''        Next i
'        For i = 0 To 2
'            If lblZaimuCd(i).Caption = "" Then
'                MsgBox "�����A�g�p�̓K�p�R�[�h�͕K���ݒ肵�Ă�������", vbExclamation, App.Title
'                tabMain.Tab = 5
'                tabZaimu.Tab = 0
'                Exit Do
'            End If
'        Next i
'
'        For i = 6 To 8
'            If lblZaimuCd(i).Caption = "" Then
'                MsgBox "�����A�g�p�̓K�p�R�[�h�͕K���ݒ肵�Ă�������", vbExclamation, App.Title
'                tabMain.Tab = 5
'                tabZaimu.Tab = 1
'                Exit Do
'            End If
'        Next i
''### 2002.03.23 Updated By H.Ishihara@FSIT �ҕt�͎g�p���Ȃ�
'### 2002.11.12 Del End

        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

' @(e)
'
' �@�\�@�@ : ��{�R�[�X����ʕ\��
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �R�[�X�̊�{������ʂɕ\������
'
' ���l�@�@ :
'
Private Function EditCourse() As Boolean

On Error GoTo ErrorHandle

    Dim objCourse       As Object               '�R�[�X���A�N�Z�X�p
    
    Dim vntCsName       As Variant              '�R�[�X��
    Dim vntStaDiv       As Variant
    Dim vntDayIDDiv     As Variant
    Dim vntStrDayID     As Variant
    Dim vntEndDayID     As Variant
    Dim vntWebColor     As Variant
    Dim vntSecondFlg    As Variant
    Dim vntStay         As Variant
    Dim vntGovMng       As Variant
    Dim vntGovMng12Div  As Variant
    Dim vntGovMngDiv    As Variant
    Dim vntGovMngShaho  As Variant
    Dim vntZaimuCd(11)  As Variant
    
    Dim vntCsSName          As Variant
    Dim vntCsDiv            As Variant
    Dim vntMainCsCd         As Variant
    Dim vntRoundFlg         As Variant
    Dim vntRegularFlg       As Variant
    Dim vntStartTime        As Variant
    Dim vntEndTime          As Variant
    Dim vntKarteReportCd    As Variant
    Dim vntNoPrintMonoPrice As Variant

    Dim vntMainCsCdList     As Variant
    Dim vntMainCsName       As Variant

    Dim i                   As Integer
    Dim Ret                 As Boolean              '�߂�l
    Dim lngCount            As Long
    
    EditCourse = False
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If mstrCsCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '�R�[�X�e�[�u�����R�[�h�ǂݍ���
        If objCourse.SelectCourse(mstrCsCd, _
                                  vntCsName, _
                                  vntStaDiv, _
                                  vntDayIDDiv, _
                                  vntStrDayID, _
                                  vntEndDayID, _
                                  vntWebColor, _
                                  vntSecondFlg, _
                                  vntStay, _
                                  vntGovMng, vntGovMng12Div, _
                                  vntGovMngDiv, vntGovMngShaho, _
                                  vntZaimuCd(0), vntZaimuCd(1), _
                                  vntZaimuCd(2), vntZaimuCd(3), _
                                  vntZaimuCd(4), vntZaimuCd(5), _
                                  vntZaimuCd(6), vntZaimuCd(7), _
                                  vntZaimuCd(8), vntZaimuCd(9), _
                                  vntZaimuCd(10), vntZaimuCd(11), _
                                  vntCsSName, _
                                  vntCsDiv, _
                                  vntMainCsCd, _
                                  vntRoundFlg, _
                                  vntRegularFlg, _
                                  vntStartTime, _
                                  vntEndTime, _
                                  vntKarteReportCd, vntNoPrintMonoPrice) = False Then
            
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If

        '�ǂݍ��ݓ��e�̕ҏW�i�R�[�X��{���j
        txtCsCd.Text = mstrCsCd
        txtCsName.Text = vntCsName
        txtCsSName.Text = vntCsSName
        cboCsDiv.ListIndex = CInt(vntCsDiv)
        cboStay.ListIndex = CInt(vntStay)
        cboSecondFlg.ListIndex = CInt(vntSecondFlg)
        txtStaDiv.Text = vntStaDiv & ""
        
        If vntRoundFlg = "1" Then chkRoundFlg.Value = vbChecked
        If vntRegularFlg = "1" Then chkRegularFlg.Value = vbChecked
        txtStartTime.Text = vntStartTime
        txtEndTime.Text = vntEndTime
        
        'mstrReportCd_OnRead
        mstrKarteCd_OnRead = vntKarteReportCd
        
        'WEB�J���[�Z�b�g
        If Len(vntWebColor) = 6 Then
            '�J���[�ݒ肮�炢�ŗ��Ƃ��Ȃ�
            On Error Resume Next
            lblWebColor.BackColor = RGB("&H" & Mid(vntWebColor, 1, 2), "&H" & Mid(vntWebColor, 3, 2), "&H" & Mid(vntWebColor, 5, 2))
            On Error GoTo 0
        End If
        
        lblColor.Caption = vntWebColor
    
        '�f�t�H���g�Z�b�g���ꂽ���蕪�ނ��Z�b�g
        If vntDayIDDiv <> "" Then
            For i = 0 To UBound(mstrArrDayIDDivCd)
                If mstrArrDayIDDivCd(i) = vntDayIDDiv Then
                    cboDayIDDiv.ListIndex = i
                End If
            Next i
        End If
        
        '�ǂݍ��ݓ��e�̕ҏW�i���{�Ǐ����j
        optGovMng(CInt(vntGovMng)).Value = True
        cboGovMngDiv.ListIndex = CInt(vntGovMngDiv)
        cboGovMng12Div.ListIndex = CInt(vntGovMng12Div)
        cboGovMngShaho.ListIndex = CInt(vntGovMngShaho)
    
        If vntNoPrintMonoPrice = "1" Then
            chkNoPrintMonoPrice.Value = vbChecked
        Else
            chkNoPrintMonoPrice.Value = vbUnchecked
        End If
    
    
        '�����A�g���̃Z�b�g
        For i = 0 To 11
            lblZaimuCd(i).Caption = vntZaimuCd(i)
            lblZaimuName(i).Caption = GetZaimuNameFromCollection(CStr(vntZaimuCd(i)))
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    '�C���X�^���X�쐬���łɃ��C���R�[�X�R���{��ݒ�
    cboMainCsCd.Clear
    Erase mstrRootCsCd
    
    '�R�[�X�ꗗ�擾�i���C���̂݁j
    lngCount = objCourse.SelectCourseList(vntMainCsCdList, vntMainCsName, , 3)
    
    '�R�[�X�͖��w�肠��
    ReDim Preserve mstrRootCsCd(0)
    mstrRootCsCd(0) = ""
    cboMainCsCd.AddItem ""
    cboMainCsCd.ListIndex = 0
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootCsCd(i + 1)
        mstrRootCsCd(i + 1) = vntMainCsCdList(i)
        cboMainCsCd.AddItem vntMainCsName(i)
        If vntMainCsCdList(i) = vntMainCsCd Then
            cboMainCsCd.ListIndex = i + 1
        End If
    Next i
    
    '�߂�l�̐ݒ�
    EditCourse = Ret
    
    Exit Function

ErrorHandle:

    EditCourse = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �R�[�X��{���̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e���R�[�X�e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistCourse() As Boolean

On Error GoTo ErrorHandle

    Dim objCourse           As Object       '�R�[�X�A�N�Z�X�p
    Dim i                   As Integer
    Dim j                   As Integer
    Dim k                   As Integer
    Dim lngRet              As Long
    
    '�R�[�X���������ځA�O���[�v�p�ϐ�
    Dim intItemCount        As Integer      '�R�[�X���������ڐ�
    Dim intGrpCount         As Integer      '�R�[�X���O���[�v���ڐ�
    Dim vntItemCd()         As Variant      '�R�[�X���������ڗp�z��
    Dim vntGrpCd()          As Variant      '�R�[�X���O���[�v�p�z��
    
    Dim strTargetKey        As String       '�L�[�l�ҏW�p�ϐ�
    Dim strTargetDiv        As String       '���� or �O���[�v�̋敪
    Dim strTargetCd         As String       '�L�[�l�ҏW�p�ϐ�
    Dim strWkMainCsCd       As String
    
    Dim intCsHNo            As Integer
    
    '�R�[�X�����蕪�ޗp�ϐ�
    Dim intJudClassCount    As Integer      '�R�[�X���������ڐ�
    Dim vntJudClassCd()     As Variant
    Dim vntNoReason()       As Variant
    Dim vntSeq()            As Variant
    Dim strWorkKey          As String
    Dim lngPointer          As Long
    Dim intNoReason         As Integer
    
    '�������ڎ��{���p�ϐ�
    Dim intOpeClassCount    As Integer
    Dim vntOpeClassCd()     As Variant
    Dim vntMonMng()         As Variant
    Dim vntTueMng()         As Variant
    Dim vntWedMng()         As Variant
    Dim vntThuMng()         As Variant
    Dim vntFriMng()         As Variant
    Dim vntSatMng()         As Variant
    Dim vntSunMng()         As Variant
    
    Dim objListItem         As ListItem
    
    RegistCourse = False
    
    '������
    intItemCount = 0
    intGrpCount = 0
    intOpeClassCount = 0
    Erase vntItemCd
    Erase vntGrpCd
    j = 0
    k = 0

    '�R�[�X���O���[�v�������͌������ڂ̊i�[�p�ҏW
    For i = 1 To lsvItem.ListItems.Count
        
        '�L�[�l�𕪊�
        strTargetKey = lsvItem.ListItems(i).Key
        strTargetDiv = Mid(strTargetKey, 1, 1)
        strTargetCd = Mid(strTargetKey, 2, Len(strTargetKey))
        
        '�L�[�l�擪��������`�F�b�N
        If strTargetDiv = GRPDIV_ITEM Then
            '�˗����ڂȂ�
            intItemCount = intItemCount + 1
            ReDim Preserve vntItemCd(j)
            vntItemCd(j) = strTargetCd
            j = j + 1
        Else
            '�O���[�v�Ȃ�
            intGrpCount = intGrpCount + 1
            ReDim Preserve vntGrpCd(k)
            vntGrpCd(k) = strTargetCd
            k = k + 1
        End If
    
    Next i

    '�������ڃ^�u��\�����Ă��Ȃ��i�܂薢�C���j�Ȃ痚��ԍ��Ƀ[���Z�b�g�i�R���{���̂܂܂Ȃ疢�Z�b�g�Ȃ̂ł�����j
    If mblnEditItem = False Then
        intCsHNo = 0
    Else
        intCsHNo = mintCsHNo(cboHistory.ListIndex)
    End If

    '�������ڎ��{���̃`�F�b�N
    If lsvCourse_Ope.ListItems.Count > 0 Then
        
        For Each objListItem In lsvCourse_Ope.ListItems
            If objListItem.SubItems(2) <> "" Then
                
                ReDim Preserve vntOpeClassCd(intOpeClassCount)
                ReDim Preserve vntMonMng(intOpeClassCount)
                ReDim Preserve vntTueMng(intOpeClassCount)
                ReDim Preserve vntWedMng(intOpeClassCount)
                ReDim Preserve vntThuMng(intOpeClassCount)
                ReDim Preserve vntFriMng(intOpeClassCount)
                ReDim Preserve vntSatMng(intOpeClassCount)
                ReDim Preserve vntSunMng(intOpeClassCount)
                
                With objListItem
                    vntOpeClassCd(intOpeClassCount) = .Text
                    vntMonMng(intOpeClassCount) = IIf(.SubItems(2) = 0, "", .SubItems(2))
                    vntTueMng(intOpeClassCount) = IIf(.SubItems(3) = 0, "", .SubItems(3))
                    vntWedMng(intOpeClassCount) = IIf(.SubItems(4) = 0, "", .SubItems(4))
                    vntThuMng(intOpeClassCount) = IIf(.SubItems(5) = 0, "", .SubItems(5))
                    vntFriMng(intOpeClassCount) = IIf(.SubItems(6) = 0, "", .SubItems(6))
                    vntSatMng(intOpeClassCount) = IIf(.SubItems(7) = 0, "", .SubItems(7))
                    vntSunMng(intOpeClassCount) = IIf(.SubItems(8) = 0, "", .SubItems(8))
                End With
            
                intOpeClassCount = intOpeClassCount + 1
            
            End If
        Next objListItem
    
    End If

    '�R�[�X���蕪�ނ̊i�[�p�ҏW
    For i = 1 To lsvJud.ListItems.Count
        
        j = i - 1
        ReDim Preserve vntJudClassCd(j)
        ReDim Preserve vntNoReason(j)
        ReDim Preserve vntSeq(j)
        
        vntJudClassCd(j) = lsvJud.ListItems(i).Text
        If lsvJud.ListItems(i).SubItems(2) = NOREASON_TEXT Then
            intNoReason = 1
        Else
            intNoReason = 0
        End If
        vntNoReason(j) = intNoReason
        vntSeq(j) = i
        
        intJudClassCount = intJudClassCount + 1
    
    Next i

    '���C���R�[�X�R�[�h�̃Z�b�g
    strWkMainCsCd = txtCsCd.Text
    If cboCsDiv.ListIndex = 3 Then strWkMainCsCd = mstrRootCsCd(cboMainCsCd.ListIndex)

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")

    '�R�[�X�e�[�u�����R�[�h�̓o�^
'### 2003.11.22 Modified by H.Ishihara@FSIT
'    lngRet = objCourse.RegistCourse_All(IIf(txtCsCd.Enabled, "INS", "UPD"), Trim(txtCsCd.Text), _
                                        Trim(txtCsName.Text), Trim(txtStaDiv.Text), _
                                        mstrArrDayIDDivCd(cboDayIDDiv.ListIndex), lblColor.Caption, _
                                        cboSecondFlg.ListIndex, cboStay.ListIndex, _
                                        IIf(optGovMng(0).Value = True, 0, 1), cboGovMng12Div.ListIndex, _
                                        cboGovMngDiv.ListIndex, cboGovMngShaho.ListIndex, _
                                        mblnEditItem, intCsHNo, _
                                        intItemCount, vntItemCd, _
                                        intGrpCount, vntGrpCd, _
                                        mblnEditJud, intJudClassCount, _
                                        vntJudClassCd, vntNoReason, _
                                        vntSeq, mblnEditOpe, _
                                        intOpeClassCount, vntOpeClassCd, _
                                        vntMonMng, vntTueMng, vntWedMng, vntThuMng, vntFriMng, vntSatMng, vntSunMng, _
                                        lblZaimuCd(0).Caption, lblZaimuCd(1).Caption, _
                                        lblZaimuCd(2).Caption, lblZaimuCd(3).Caption, _
                                        lblZaimuCd(4).Caption, lblZaimuCd(5).Caption, _
                                        lblZaimuCd(6).Caption, lblZaimuCd(7).Caption, _
                                        lblZaimuCd(8).Caption, lblZaimuCd(9).Caption, _
                                        lblZaimuCd(10).Caption, lblZaimuCd(11).Caption, _
                                        Trim(txtCsSName.Text), cboCsDiv.ListIndex, _
                                        strWkMainCsCd, IIf(chkRoundFlg.Value = vbChecked, "1", ""), _
                                        IIf(chkRegularFlg.Value = vbChecked, "1", "0"), txtStartTime, txtEndTime, _
                                        mstrKarteCd(cboKarteReportCd.ListIndex), IIf(chkNoPrintMonoPrice.Value = vbChecked, "1", ""))
    lngRet = objCourse.RegistCourse_All(IIf(txtCsCd.Enabled, "INS", "UPD"), Trim(txtCsCd.Text), _
                                        Trim(txtCsName.Text), Trim(txtStaDiv.Text), _
                                        "", lblColor.Caption, _
                                        cboSecondFlg.ListIndex, cboStay.ListIndex, _
                                        IIf(optGovMng(0).Value = True, 0, 1), cboGovMng12Div.ListIndex, _
                                        cboGovMngDiv.ListIndex, cboGovMngShaho.ListIndex, _
                                        mblnEditItem, intCsHNo, _
                                        intItemCount, vntItemCd, _
                                        intGrpCount, vntGrpCd, _
                                        mblnEditJud, intJudClassCount, _
                                        vntJudClassCd, vntNoReason, _
                                        vntSeq, mblnEditOpe, _
                                        intOpeClassCount, vntOpeClassCd, _
                                        vntMonMng, vntTueMng, vntWedMng, vntThuMng, vntFriMng, vntSatMng, vntSunMng, _
                                        Trim(txtCsSName.Text), cboCsDiv.ListIndex, _
                                        strWkMainCsCd, IIf(chkRoundFlg.Value = vbChecked, "1", ""), _
                                        IIf(chkRegularFlg.Value = vbChecked, "1", "0"), txtStartTime, txtEndTime, _
                                        "", IIf(chkNoPrintMonoPrice.Value = vbChecked, "1", ""))
'### 2003.11.22 Modified End

    '�߂�l���_�u������̏ꍇ
    If lngRet = INSERT_DUPLICATE Then
        MsgBox "���͂��ꂽ�R�[�X�R�[�h�͊��ɑ��݂��܂��B", vbExclamation
        Exit Function
        End If
    
    mstrCsCd = Trim(txtCsCd.Text)
    txtCsCd.Enabled = (txtCsCd.Text = "")
    
    Set objCourse = Nothing
    RegistCourse = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objCourse = Nothing
    RegistCourse = False
    
End Function

Private Sub cboCsDiv_Click()

    cboMainCsCd.Enabled = (cboCsDiv.ListIndex = 3)
    If cboCsDiv.ListIndex = 3 Then
        lblMainCsCd.ForeColor = vbBlack
    Else
        lblMainCsCd.ForeColor = &H80000011
    End If

End Sub

' @(e)
'
' �@�\�@�@ : �u�R�[�X�����R���{�vClick
'
' �@�\���� : �I�����ꂽ������ŊǗ����Ă��鍀�ڂ�\������
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
    
    '���݂̏�Ԃ��X�V����Ă�����A�x��
    If mblnEditItem = True Then
        strMsg = "��f���ړ��e���X�V����Ă��܂��B�����f�[�^���ĕ\������ƕύX���e���j������܂�" & vbLf & _
                 "��낵���ł����H"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then
            mblnNowEdit = True                          '����Loop�h�~�̂��߁A��������
            cboHistory.ListIndex = mintBeforeIndex      '�R���{�C���f�b�N�X�����ɖ߂�
            mblnNowEdit = False                         '����������
            Exit Sub
        End If
    End If
    
    '��f�������ڂ̕\��
    Call EditListItem

    '���݂�Index��ێ�
    mintBeforeIndex = cboHistory.ListIndex

    '���X�V��Ԃɏ�����
    mblnEditItem = False
    mblnNowEdit = False

End Sub


' @(e)
'
' �@�\�@�@ : �u���ڒǉ��vClick
'
' �@�\���� : �w��R�[�X�����Ɏ�f���ڂ�ǉ�����
'
' ���l�@�@ :
'
Private Sub cmdAddItem_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '���ڃK�C�h�\���p
    Dim objItem         As ListItem                 '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim lngCount        As Long     '���R�[�h��
    Dim i               As Long     '�C���f�b�N�X
    Dim strKey          As String   '�d���`�F�b�N�p�̃L�[
    
    Dim lngItemCount    As Long     '�I�����ڐ�
    Dim vntItemDiv      As Variant  '�I�����ꂽ�A�C�e���^�C�v
    Dim vntItemCd       As Variant  '�I�����ꂽ���ڃR�[�h
    Dim vntSuffix       As Variant  '�I�����ꂽ�T�t�B�b�N�X
    Dim vntItemName     As Variant  '�I�����ꂽ���ږ�
    Dim vntClassName    As Variant  '�I�����ꂽ�������ޖ�
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_REQUEST
        .Group = GROUP_SHOW
        .Item = ITEM_SHOW
        .Question = QUESTION_OFF
    
        '�R�[�X�e�[�u�������e�i���X��ʂ��J��
        .Show vbModal
            
        '�߂�l�Ƃ��Ẵv���p�e�B�擾
        lngItemCount = .ItemCount
        vntItemDiv = .ItemDiv
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
        vntItemName = .ItemName
        vntClassName = .ClassName
    
    End With
    
    Screen.MousePointer = vbHourglass
    Me.Refresh
    
    '�I��������0���ȏ�Ȃ�
    If lngItemCount > 0 Then

        '���X�g�̕ҏW
        For i = 0 To lngItemCount - 1

            '���X�g��ɑ��݂��邩�`�F�b�N����
            strKey = vntItemDiv & vntItemCd(i)
            If CheckExistsItemCd(lsvItem, strKey) = False Then

                '�Ȃ���Βǉ�����
                Set objItem = lsvItem.ListItems.Add(, strKey, vntClassName(i))
                objItem.SubItems(1) = IIf(CStr(vntItemDiv) = GRPDIV_GRP, "�O���[�v", "��������")
                objItem.SubItems(2) = vntItemCd(i)
                objItem.SubItems(3) = vntItemName(i)

                '�X�V��Ԃ��Ǘ�
                mblnEditItem = True

            End If
        Next i

    End If

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Sub cmdAddJudClass_Click()
    
    Dim objItem         As ListItem                 '���X�g�A�C�e���I�u�W�F�N�g
    Dim strKey          As String
    
    With frmAddJudClass
        
        .JudClassCd = 0
        .NoReason = 0
        .Show vbModal
    
        '�f�[�^���X�V���ꂽ��A��ʃf�[�^�ĕҏW
        If .Updated = True Then
        
            strKey = mstrListViewKey & .JudClassCd
            If CheckExistsItemCd(lsvJud, strKey) = False Then
            
                '�Ȃ���Βǉ�����
                Set objItem = lsvJud.ListItems.Add(, strKey, .JudClassCd)
                objItem.SubItems(1) = .JudClassName
                objItem.SubItems(2) = IIf(.NoReason = 1, NOREASON_TEXT, "")
            
                '�X�V��Ԃ��Ǘ�
                mblnEditJud = True
            
            End If
        
        End If
        
    End With

End Sub

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

' @(e)
'
' �@�\�@�@ : �R�[�X�����폜�{�^��
'
' �@�\���� : �R�[�X�����f�[�^���폜����
'
' ���l�@�@ :
'
Private Sub cmdDeleteHistory_Click()

On Error GoTo ErrorHandle

    Dim objCourse   As Object       '�R�[�X�e�[�u���A�N�Z�X�p

    Dim lngRet  As Long
    Dim strMsg  As String
    
    '�폜�m�F���b�Z�[�W�\��
    strMsg = "�����f�[�^�F" & cboHistory.List(cboHistory.ListIndex) & vbLf & vbLf
    strMsg = strMsg & "�w�肳�ꂽ�����f�[�^���폜���܂��B�폜����Ƃ��̗�����Ŏw�肳��Ă�����f�������ڐݒ���폜����܂��B" & vbLf
    strMsg = strMsg & "��낵���ł����H" & vbLf & vbLf
    strMsg = strMsg & "���ӁF���̑���̓L�����Z�����邱�Ƃ��ł��܂���B"

    lngRet = MsgBox(strMsg, vbExclamation + vbYesNo + vbDefaultButton2, "�R�[�X�������폜")
    
    '��߂�Ȃ珈���I��
    If lngRet = vbNo Then Exit Sub
        
    Screen.MousePointer = vbHourglass
        
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    
    '�R�[�X�e�[�u�����R�[�h�̍폜
    objCourse.DeleteCourse_h mstrCsCd, mintCsHNo(cboHistory.ListIndex)
    
    '�I�u�W�F�N�g��Nothing���Ȃ���Commit����Ȃ�
    Set objCourse = Nothing
    
    '��ʃf�[�^�ĕҏW
    mblnShowItem = False
    Call EditItemTab
    
    Screen.MousePointer = vbDefault
    Exit Sub
    
ErrorHandle:

    Screen.MousePointer = vbDefault
    MsgBox Err.Description, vbCritical
    
End Sub

' @(e)
'
' �@�\�@�@ : �u���ڍ폜�vClick
'
' �@�\���� : �I�����ꂽ���ڂ����X�g����폜����
'
' ���l�@�@ :
'
Private Sub cmdDeleteItem_Click()

    Dim i As Integer
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvItem.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ�폜
        If lsvItem.ListItems(i).Selected = True Then
            lsvItem.ListItems.Remove (lsvItem.ListItems(i).Key)
            '�A�C�e�������ς��̂�-1���čČ���
            i = i - 1
            '�X�V��Ԃ��Ǘ�
            mblnEditItem = True
        End If
    
    Next i

End Sub

Private Sub cmdDeleteJudClass_Click()

    Dim i As Integer
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvJud.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvJud.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ�폜
        If lsvJud.ListItems(i).Selected = True Then
            lsvJud.ListItems.Remove (lsvJud.ListItems(i).Key)
            '�A�C�e�������ς��̂�-1���čČ���
            i = i - 1
            '�X�V��Ԃ��Ǘ�
            mblnEditJud = True
        End If
    
    Next i

End Sub

Private Sub cmdDownItem_Click()
    
    Call MoveListItem(1)

End Sub

Private Sub cmdEditCourse_Ope_Click()
    
    Dim objListItem     As ListItem
    
    If Screen.MousePointer <> vbDefault Then Exit Sub
    
    '�I�𒆂̃m�[�h�I�u�W�F�N�g���擾
    Set objListItem = lsvCourse_Ope.SelectedItem

    '�m�[�h��I�����͏������s��Ȃ�
    If objListItem Is Nothing Then
        Exit Sub
    End If
    
    With frmEditCourse_Ope
        
        .Stay = cboStay.ListIndex
        .OpeClassCd = objListItem.Text
        .OpeClassName = objListItem.SubItems(1)
        
        .MonMng = objListItem.SubItems(2)
        .TueMng = objListItem.SubItems(3)
        .WedMng = objListItem.SubItems(4)
        .ThuMng = objListItem.SubItems(5)
        .FriMng = objListItem.SubItems(6)
        .SatMng = objListItem.SubItems(7)
        .SunMng = objListItem.SubItems(8)
        
        .Show vbModal
    
        If .Updated = True Then
            
            objListItem.SubItems(2) = .MonMng
            objListItem.SubItems(3) = .TueMng
            objListItem.SubItems(4) = .WedMng
            objListItem.SubItems(5) = .ThuMng
            objListItem.SubItems(6) = .FriMng
            objListItem.SubItems(7) = .SatMng
            objListItem.SubItems(8) = .SunMng
        
            mblnEditOpe = True
        
        End If
    
    End With
    
End Sub

' @(e)
'
' �@�\�@�@ : �R�[�X�����C���{�^��
'
' �@�\���� : �R�[�X�����쐬�p�t�H�[���\��
'
' ���l�@�@ :
'
Private Sub cmdEditHistory_Click()
    
    '�C�����[�h�ŃR�[�X������\��
    Call ShowCourse_h(False)

End Sub

Private Sub cmdEditJudClass_Click()

    Dim i               As Integer
    Dim strTargetKey    As String
    Dim strTargetDiv    As String
    Dim strTargetCd     As String
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvJud.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvJud.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ珈��
        If lsvJud.ListItems(i).Selected = True Then
        
            With frmAddJudClass
                .JudClassCd = lsvJud.ListItems(i).Text
                .NoReason = IIf(lsvJud.ListItems(i).SubItems(2) = NOREASON_TEXT, 1, 0)
                
                .Show vbModal
            
                If .Updated = True Then
                    lsvJud.ListItems(mstrListViewKey & .JudClassCd).SubItems(2) = IIf(.NoReason = 1, NOREASON_TEXT, "")
                    '�X�V��Ԃ��Ǘ�
                    mblnEditJud = True
                End If
                
            End With
        
            '�P��������㓙�i�擪�����j
            Exit Sub
        
        End If
    
    Next i


End Sub

' @(e)
'
' �@�\�@�@ : �u�v���p�e�B�vClick
'
' �@�\���� : �I�����ꂽ���ڂ̏���\������B
'
' ���l�@�@ :
'
Private Sub cmdItemProperty_Click()

    Dim objGrp          As mntGrp.Grp   '�O���[�v�e�[�u�������e�i���X�p

    Dim i               As Integer
    Dim strTargetKey    As String
    Dim strTargetDiv    As String
    Dim strTargetCd     As String
    
    '���X�g�r���[�����邭��񂵂đI�����ڔz��쐬
    For i = 1 To lsvItem.ListItems.Count
        
        '�C���f�b�N�X�����X�g���ڂ��z������I��
        If i > lsvItem.ListItems.Count Then Exit For
        
        '�I������Ă��鍀�ڂȂ珈��
        If lsvItem.ListItems(i).Selected = True Then
        
            '�L�[�l�𕪊�
            strTargetKey = lsvItem.ListItems(i).Key
            strTargetDiv = Mid(strTargetKey, 1, 1)
            strTargetCd = Mid(strTargetKey, 2, Len(strTargetKey))
            
            '�L�[�l�擪��������`�F�b�N
            If strTargetDiv = GRPDIV_ITEM Then
                '�˗����ڂȂ�
            Else
                '�O���[�v�Ȃ�
                '�I�u�W�F�N�g�̃C���X�^���X�쐬
                Set objGrp = New mntGrp.Grp
                
                '�v���p�e�B�̐ݒ�
                objGrp.GrpDiv = MODE_REQUEST
                objGrp.GrpCd = strTargetCd
                objGrp.ShowOnly = True
                
                '�O���[�v�e�[�u�������e�i���X��ʂ��J��
                objGrp.Show vbModal
                
                '�I�u�W�F�N�g�̔p��
                Set objGrp = Nothing
            
                '�P��������㓙�i�擪�����j
                Exit Sub
            End If
        
        End If
    
    Next i

End Sub

' @(e)
'
' �@�\�@�@ : �R�[�X����V�K�쐬�{�^��
'
' �@�\���� : �R�[�X�����쐬�p�t�H�[���\��
'
' ���l�@�@ :
'
Private Sub cmdNewHistory_Click()

    '�V�K���[�h�ŃR�[�X������\��
    Call ShowCourse_h(True)
    
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
    
    '�f�[�^�K�p�������s���i�G���[���͉�ʂ���Ȃ��j
    If ApplyData() = False Then
        Exit Sub
    End If

    '��ʂ����
    Unload Me
    
End Sub


Private Sub cmdUpItem_Click()

    Call MoveListItem(-1)

End Sub

' @(e)
'
' �@�\�@�@ : �u�\���F�{�^���vClick
'
' �@�\���� : �F�I��p�_�C�A���O�{�b�N�X�\��
'
' ���l�@�@ :
'
Private Sub cmdWebColor_Click()

    Dim strTargetColor  As String
    Dim strChangeColor  As String

    '�_�C�A���O�\��
    CommonDialog1.ShowColor
    
    '�߂�l�����x���Z�b�g
    lblWebColor.BackColor = CommonDialog1.Color

    '�J���[��16�i���ɕύX
    strTargetColor = Hex(CommonDialog1.Color)

    'RGB�𔽓]������
    Select Case Len(strTargetColor)
        Case 2
            strChangeColor = strTargetColor & "0000"
        Case 4
            strChangeColor = Mid(strTargetColor, 3, 2) & Mid(strTargetColor, 1, 2)
            strChangeColor = strChangeColor & "00"
        Case 6
            strChangeColor = Mid(strTargetColor, 5, 2) & Mid(strTargetColor, 3, 2) & Mid(strTargetColor, 1, 2)
    
    End Select
    
    '������\��
    lblColor.Caption = strChangeColor
    
End Sub



Private Sub cmdZaimuCd_Click(Index As Integer)

    Dim objCommonGuide  As mntCommonGuide.CommonGuide   '���ڃK�C�h�\���p
    Dim i               As Long     '�C���f�b�N�X
    Dim intRecordCount  As Integer
    Dim vntCode         As Variant
    Dim vntName         As Variant
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCommonGuide = New mntCommonGuide.CommonGuide
    
    With objCommonGuide
        .MultiSelect = False
        .TargetTable = getZaimu
    
        '�����K�p�R�[�h�K�C�h��ʂ��J��
        .Show vbModal
    
        intRecordCount = .RecordCount
        vntCode = .RecordCode
        vntName = .RecordName
    
    End With
        
    '�I��������0���ȏ�Ȃ�
    If intRecordCount > 0 Then
    
        lblZaimuCd(Index).Caption = vntCode(0)
        lblZaimuName(Index).Caption = vntName(0)
    
'        '�I�����R�[�h�����P�Ȃ�e�L�X�g�{�b�N�X�ɃZ�b�g
'        If intRecordCount = 1 Then
'            txtLowerValue.Text = vntCode(0)
'            lblSentence.Caption = vntName(0)
'        Else
'            txtLowerValue.Text = "*"
'            lblSentence.Caption = "�����̕��͂��I������Ă��܂��B"
'        End If
'
'        '���͊i�[�p�z��Ɋi�[
'        Erase mvntStcCode
'        Erase mvntSentence
'        mintSentenceCount = 0
'
'        ReDim Preserve mvntStcCode(intRecordCount)
'        ReDim Preserve mvntSentence(intRecordCount)
'
'        '�z��Ɋi�[
'        For i = 0 To intRecordCount - 1
'            mvntStcCode(i) = vntCode(i)
'            mvntSentence(i) = vntName(i)
'            mintSentenceCount = mintSentenceCount + 1
'        Next i
        
    End If

    Set objCommonGuide = Nothing
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
    Call InitializeForm

    Do
        
'### 2003.11.23 Deleted by H.Ishihara@FSIT ���H�����g�p���ڍ폜
'        '�����h�c�R���{�̕\���ҏW
'        If EditDayIDDiv() = False Then
'            Exit Do
'        End If
'### 2003.11.23 Deleted End
        
'### 2002.11.12 Mod By H.Ishihara@FSIT ���}�a�d�l�ł͍����s�v
'        '�����A�g�p�K�p�R�[�h�R���N�V�����쐬
'        If GetZaimuRecord() = False Then
'            Exit Do
'        End If
'### 2002.11.12 Mod End
        
        '�R�[�X���̕\���ҏW
        If EditCourse() = False Then
            Exit Do
        End If
        
'### 2003.11.23 Deleted by H.Ishihara@FSIT ���H�����g�p���ڍ폜
'        '���[�R���{�̕ҏW
'        If EditReportConbo() = False Then
'            Exit Do
'        End If
'### 2003.11.23 Deleted End
    
        '�C�l�[�u���ݒ�
        txtCsCd.Enabled = (txtCsCd.Text = "")
        
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
' �@�\�@�@ : ���[�f�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditReportConbo() As Boolean

    Dim objReport       As Object   '�R�[�X�A�N�Z�X�p
    Dim vntReportCd     As Variant
    Dim vntReportName   As Variant
    Dim vntReportFlg    As Variant
    Dim vntKarteFlg     As Variant
    Dim lngCount        As Long             '���R�[�h��0
    Dim i               As Long             '�C���f�b�N�X
    Dim intReportCount  As Integer
    
    EditReportConbo = False
    
    cboReport.Clear
    cboKarteReportCd.Clear
    Erase mstrReportCd
    Erase mstrKarteCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objReport = CreateObject("HainsReport.Report")
    lngCount = objReport.SelectReportList(vntReportCd, vntReportName, vntReportFlg, , , , , vntKarteFlg)
    
    '���w�肠��
    ReDim Preserve mstrReportCd(0)
    ReDim Preserve mstrKarteCd(0)
    mstrReportCd(0) = ""
    mstrKarteCd(0) = ""
    cboReport.AddItem ""
    cboReport.ListIndex = 0
    cboKarteReportCd.AddItem ""
    cboKarteReportCd.ListIndex = 0
    
    intReportCount = 0
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        
'        If vntReportFlg(i) = "1" Then
'            ReDim Preserve mstrReportCd(i + 1)
'            mstrReportCd(i + 1) = vntReportCd(i)
'            cboReport.AddItem vntReportName(i)
'        End If
        
        If vntKarteFlg(i) = "1" Then
            ReDim Preserve mstrKarteCd(intReportCount + 1)
            mstrKarteCd(intReportCount + 1) = vntReportCd(i)
            cboKarteReportCd.AddItem vntReportName(i)
            If mstrKarteCd_OnRead = vntReportCd(i) Then
                cboKarteReportCd.ListIndex = (intReportCount + 1)
            End If
            intReportCount = intReportCount + 1
        End If
        
    Next i
    
    '�擪�R���{��I����Ԃɂ���
    EditReportConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

'
' �@�\�@�@ : �����K�p�R�[�h�S�f�[�^�擾
'
' �����@�@ :
'
' �߂�l�@ : TRUE:�f�[�^����AFALSE:�f�[�^�Ȃ�
'
' ���l�@�@ :
'
Private Function GetZaimuRecord() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu            As Object           '�����K�p�R�[�h�A�N�Z�X�p
    Dim vntZaimuCd          As Variant          '�����R�[�h�R�[�h
    Dim vntZaimuName        As Variant            '�����K�p��
    Dim vntZaimuDiv         As Variant          '�������
    Dim vntZaimuClass       As Variant          '��������
    Dim i                   As Long             '�C���f�b�N�X
    Dim strZaimuClassName   As String
    Dim strZaimuDivName     As String
    Dim objZaimuRecord      As Object
    Dim lngCount            As Long
    
    GetZaimuRecord = False
    
    Set mcolZaimuCollection = New Collection
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    lngCount = objZaimu.SelectZaimuList(vntZaimuCd, vntZaimuName, vntZaimuDiv, vntZaimuClass)
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        
        Set objZaimuRecord = New ZaimuRecord
        With objZaimuRecord
            .ZaimuCd = vntZaimuCd(i)
            .ZaimuName = vntZaimuName(i)
            .ZaimuDiv = vntZaimuDiv(i)
            .ZaimuClass = vntZaimuClass(i)
        End With
        mcolZaimuCollection.Add objZaimuRecord, KEY_PREFIX & vntZaimuCd(i)
        Set objZaimuRecord = Nothing
        
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objZaimu = Nothing
    
    '�G���[�����Ή�
    If lngCount = 0 Then
        MsgBox "�����A�g�p�K�p�R�[�h���ݒ肳��Ă��܂���B�����A�g�p�K�p�R�[�h���ɓo�^���Ă��������B", vbExclamation, Me.Caption
        Exit Function
    End If
    
    GetZaimuRecord = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �����A�g�K�p���̎擾
'
' �߂�l�@ : �K�p����
'
' �@�\���� : �R�[�h��������A�g�K�p���̂��擾����
'
' ���l�@�@ :
'
Private Function GetZaimuNameFromCollection(strZaimuCd As String) As String

On Error GoTo ErrorHandle

    '�R���N�V�������疼�̎擾
    GetZaimuNameFromCollection = mcolZaimuCollection(KEY_PREFIX & strZaimuCd).ZaimuName
    
    Exit Function

ErrorHandle:
    
    '�R���N�V�����̍����Ɏ��s�����ꍇ
    GetZaimuNameFromCollection = "�H�H�H�H�H"

End Function

' @(e)
'
' �@�\�@�@ : ���蕪�ރf�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���蕪�ރf�[�^���R���{�{�b�N�X�ɃZ�b�g����
'
' ���l�@�@ :
'
Private Function EditDayIDDiv() As Boolean

    Dim objDayIDDiv         As Object       '���蕪�ރA�N�Z�X�p
    Dim vntDayIDDivCd       As Variant      '�����h�c�R�[�h
    Dim vntDayIDDivName     As Variant      '�����h�c��
    Dim vntDayIDDivFrom     As Variant      '�����h�c�J�n
    Dim vntDayIDDivTo       As Variant      '�����h�c�I��

    Dim lngCount    As Long             '���R�[�h��
    Dim i           As Long             '�C���f�b�N�X
    
    EditDayIDDiv = False
    
    cboDayIDDiv.Clear
    Erase mstrArrDayIDDivCd

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objDayIDDiv = CreateObject("HainsFree.Free")
    lngCount = objDayIDDiv.SelectFree(1, _
                                      "DAYID", _
                                      vntDayIDDivCd, _
                                      vntDayIDDivName, _
                                      , _
                                      vntDayIDDivFrom, _
                                      vntDayIDDivTo)
    
    '�G���[�����Ή�
    If lngCount = 0 Then
        MsgBox "�����h�c�͈͂��o�^����Ă��܂���B�����h�c�͈͂��w�肵�Ă���R�[�X��o�^���Ă��������B", vbExclamation, Me.Caption
        Exit Function
    Else
        If lngCount < 0 Then
            MsgBox "�ėp�e�[�u���ǂݍ��ݒ��ɃV�X�e���I�ȃG���[���������܂����B", vbExclamation, Me.Caption
            Exit Function
        End If
    End If
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrDayIDDivCd(i)
        mstrArrDayIDDivCd(i) = vntDayIDDivCd(i)
        cboDayIDDiv.AddItem vntDayIDDivName(i) & "�@(" & vntDayIDDivFrom(i) & "�`" & vntDayIDDivTo(i) & ")"
    Next i
    
    '�擪�R���{��I����Ԃɂ���
    cboDayIDDiv.ListIndex = 0
    
    EditDayIDDiv = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

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
        
        '�R�[�X�e�[�u���̓o�^
        If RegistCourse() = False Then Exit Do

        '�X�V�t���O��������
        mblnEditMain = False
        mblnEditItem = False
        mblnEditJud = False
        mblnEditOpe = False
        
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '�������̉���
    Screen.MousePointer = vbDefault

End Function

' @(e)
'
' �@�\�@�@ : �t�H�[���R���g���[���̏�����
'
' �@�\���� : �R���g���[����������ԂɕύX����B
'
' ���l�@�@ :
'
Private Sub InitializeForm()

    Dim Ctrl        As Object
    Dim i           As Integer
    Dim objHeader   As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    
    tabMain.Tab = 0                 '�擪�^�u��Active
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    '�^�u�N���b�N����t���O������
    mblnShowItem = False
    mblnShowOpe = False
    mblnShowJud = False
    mblnShowGov = False
    
    '�X�V�`�F�b�N�p�t���O������
    mblnEditMain = False
    mblnEditItem = False
    mblnEditJud = False
    mblnEditOpe = False
    
    '--- ���C���^�u
    
    lblMainCsCd.Caption = "���C���R�[�X(&S):"
    
    '�h�����R���{�ҏW
    cboStay.AddItem "�h���Ȃ�"
    For i = 1 To 9
        cboStay.AddItem i & "��"
    Next i
    cboStay.ListIndex = 0
    
    '�Q�����f
    cboSecondFlg.AddItem "�ʏ�R�[�X"
    cboSecondFlg.AddItem "�Q�����f����"
    cboSecondFlg.ListIndex = 0

    '�R�[�X�敪
    cboCsDiv.AddItem "���C�����T�u�i��F�茒�ꎟ�Ȃǁj"
    cboCsDiv.AddItem "���C���R�[�X�i�_����쐬�ł��܂��j"
    cboCsDiv.AddItem "���C���R�[�X�i�_��쐬�ł��܂���j"
    cboCsDiv.AddItem "�T�u�R�[�X"
    cboCsDiv.ListIndex = 0

    '���{�Ǐ����f�敪�R���{�ҏW
    cboGovMngDiv.AddItem "���̑�"
    cboGovMngDiv.AddItem "���l�a���f"
    cboGovMngDiv.AddItem "���A��h�b�N"
    cboGovMngDiv.AddItem "������N�f�f"
    cboGovMngDiv.AddItem "���@�h�b�N"
    cboGovMngDiv.AddItem "�ݏW�c���f"
    cboGovMngDiv.AddItem "���̑��̌��f"
    cboGovMngDiv.AddItem "������E�q�{���񌟐f"
    cboGovMngDiv.AddItem "�t�H���["
    cboGovMngDiv.ListIndex = 0
    
    '���{�Ǐ����f�敪�R���{�ҏW
    cboGovMng12Div.AddItem "���̑�"
    cboGovMng12Div.AddItem "�ꎟ���f"
    cboGovMng12Div.AddItem "�񎟌��f"
    cboGovMng12Div.AddItem "�ǐ�"
    cboGovMng12Div.AddItem "�t�H���["
    cboGovMng12Div.AddItem "����"
    cboGovMng12Div.ListIndex = 0
    
    '���{�Ǐ��Еۋ敪�R���{�ҏW
    cboGovMngShaho.AddItem "���̑�"
    cboGovMngShaho.AddItem "�ی��\�h����"
    cboGovMngShaho.AddItem "��Ñ��k����"
    cboGovMngShaho.ListIndex = 0
    
    'Web�J���[
    lblWebColor.BackColor = vbBlack
    lblColor.Caption = "000000"
    
    
    '--- �������ڃ^�u
    cmdEditHistory.Enabled = False
    cmdDeleteHistory.Enabled = False

    cmdAddItem.Enabled = False
    cmdDeleteItem.Enabled = False
    cmdItemProperty.Enabled = False
    lsvItem.Enabled = False
    
    
    '�w�b�_�̕ҏW
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "��������", 1200, lvwColumnLeft
        .Add , , "�敪", 1000, lvwColumnLeft
        .Add , , "�R�[�h", 1000, lvwColumnLeft
        .Add , , "����", 2000, lvwColumnLeft
    End With
    
End Sub


' @(e)
'
' �@�\�@�@ : ��f�������ڕ\��
'
' �@�\���� : ���ݐݒ肳��Ă��錟�����ڂ�\������
'
' ���l�@�@ :
'
Private Sub EditListItem()
    
On Error GoTo ErrorHandle

    Dim objCourse       As Object               '�R�[�X�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntClassName    As Variant              '�������ޖ���
    Dim vntItemDiv      As Variant              '���ڋ敪
    Dim vntItemCd       As Variant              '�R�[�h
    Dim vntItemName     As Variant              '����
    Dim lngCount        As Long                 '���R�[�h��
    
    Dim i               As Long                 '�C���f�b�N�X

    '���X�g�A�C�e���N���A
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    
    '��f�������ڌ����i�J�n�A�I�����͗���ԍ����w�肵�Ă��邽�߁A�s�v�j
    lngCount = objCourse.SelectCourseItemOrderByClass(mstrCsCd, 0, 0, _
                                                      vntClassName, vntItemDiv, vntItemCd, _
                                                      vntItemName, mintCsHNo(cboHistory.ListIndex))
    
    '�w�b�_�̕ҏW
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "��������", 1200, lvwColumnLeft
        .Add , , "�敪", 1000, lvwColumnLeft
        .Add , , "�R�[�h", 1000, lvwColumnLeft
        .Add , , "����", 2000, lvwColumnLeft
    End With
        
    lsvItem.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, vntItemDiv(i) & vntItemCd(i), vntClassName(i))
        objItem.SubItems(1) = IIf(vntItemDiv(i) = GRPDIV_GRP, "�O���[�v", "��������")
        objItem.SubItems(2) = vntItemCd(i)
        objItem.SubItems(3) = vntItemName(i)
    Next i
    
    '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    '�I�𗚗��f�[�^�̍��ڕҏW
    lblCsHNo.Caption = "����No:" & Space(1) & mintCsHNo(cboHistory.ListIndex)
    lblPrice.Caption = "�R�[�X��{����:" & Space(1) & "\" & Format(mlngPrice(cboHistory.ListIndex), "#,###,##0")
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Sub

' @(e)
'
' �@�\�@�@ : �R�[�X���蕪�ޕ\��
'
' �@�\���� : ���ݐݒ肳��Ă��锻�蕪�ނ�\������
'
' ���l�@�@ :
'
Private Sub EditListJud()
    
On Error GoTo ErrorHandle

    Dim objCourse       As Object               '�R�[�X�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntJudClassCd   As Variant              '���蕪�ރR�[�h
    Dim vntJudClassName As Variant              '���蕪�ޖ���
    Dim vntNoReason     As Variant              '�������W�J�t���O
    Dim vntSeq          As Variant              '�\������
    
    Dim lngCount        As Long                 '���R�[�h��
    Dim i               As Long                 '�C���f�b�N�X

    '���ɕ\���ς݂̏ꍇ�A�������Ȃ�
    If mblnShowJud = True Then Exit Sub

    '���X�g�A�C�e���N���A
    lsvJud.ListItems.Clear
    lsvJud.View = lvwList
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    
    '��f�������ڌ����i�J�n�A�I�����͗���ԍ����w�肵�Ă��邽�߁A�s�v�j
    lngCount = objCourse.SelectCourse_JudList(mstrCsCd, _
                                              vntJudClassCd, _
                                              vntJudClassName, _
                                              vntNoReason, _
                                              vntSeq)
    '�w�b�_�̕ҏW
    Set objHeader = lsvJud.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�R�[�h", 700, lvwColumnLeft
        .Add , , "���蕪��", 2500, lvwColumnLeft
        .Add , , "�������W�J", 1500, lvwColumnLeft
    End With
    lsvJud.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvJud.ListItems.Add(, mstrListViewKey & vntJudClassCd(i), vntJudClassCd(i))
        objItem.SubItems(1) = vntJudClassName(i)
        objItem.SubItems(2) = IIf(vntNoReason(i) = 1, NOREASON_TEXT, "")
    Next i
    
    '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪���I������邽�߉�������B
    If lsvJud.ListItems.Count > 0 Then
        lsvJud.ListItems(1).Selected = False
    End If
    
    mblnShowJud = True
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Sub

' @(e)
'
' �@�\�@�@ : �R�[�X���ڎ��{���\��
'
' �@�\���� : ���ݐݒ肳��Ă���R�[�X���ڎ��{����\������
'
' ���l�@�@ :
'
Private Sub EditListCourse_Ope()
    
On Error GoTo ErrorHandle

    Dim objCourse       As Object               '�R�[�X�A�N�Z�X�p
    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    Dim vntOpeClassCd   As Variant              '�������{�����ރR�[�h
    Dim vntOpeClassName As Variant              '�������{�����ޖ�
    Dim vntMonMng       As Variant              '���j��f��������
    Dim vntTueMng       As Variant              '�Ηj��f��������
    Dim vntWedMng       As Variant              '���j��f��������
    Dim vntThuMng       As Variant              '�ؗj��f��������
    Dim vntFriMng       As Variant              '���j��f��������
    Dim vntSatMng       As Variant              '�y�j��f��������
    Dim vntSunMng       As Variant              '���j��f��������

    Dim vntNoReason     As Variant              '�������W�J�t���O
    Dim vntSeq          As Variant              '�\������
    
    Dim lngCount        As Long                 '���R�[�h��
    Dim i               As Long                 '�C���f�b�N�X

    '���ɕ\���ς݂̏ꍇ�A�������Ȃ�
    If mblnShowOpe = True Then Exit Sub

    '���X�g�A�C�e���N���A
    lsvCourse_Ope.ListItems.Clear
    lsvCourse_Ope.View = lvwList
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    lngCount = objCourse.SelectCourse_OpeList(txtCsCd.Text, _
                                              vntOpeClassCd, _
                                              vntOpeClassName, _
                                              vntMonMng, _
                                              vntTueMng, _
                                              vntWedMng, _
                                              vntThuMng, _
                                              vntFriMng, _
                                              vntSatMng, _
                                              vntSunMng)
    
    '�w�b�_�̕ҏW
    Set objHeader = lsvCourse_Ope.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "�R�[�h", 700, lvwColumnLeft
        .Add , , "���{�����ޖ�", 2200, lvwColumnLeft
        .Add , , "��", 400, lvwColumnCenter
        .Add , , "��", 400, lvwColumnCenter
        .Add , , "��", 400, lvwColumnCenter
        .Add , , "��", 400, lvwColumnCenter
        .Add , , "��", 400, lvwColumnCenter
        .Add , , "�y", 400, lvwColumnCenter
        .Add , , "��", 400, lvwColumnCenter
    End With
    lsvCourse_Ope.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvCourse_Ope.ListItems.Add(, mstrListViewKey & vntOpeClassCd(i), vntOpeClassCd(i))
        objItem.SubItems(1) = vntOpeClassName(i)
        objItem.SubItems(2) = vntMonMng(i)
        objItem.SubItems(3) = vntTueMng(i)
        objItem.SubItems(4) = vntWedMng(i)
        objItem.SubItems(5) = vntThuMng(i)
        objItem.SubItems(6) = vntFriMng(i)
        objItem.SubItems(7) = vntSatMng(i)
        objItem.SubItems(8) = vntSunMng(i)
    Next i
    
    '���ڂ��P�s�ȏ㑶�݂����ꍇ�A�������ɐ擪�I��
    If lsvCourse_Ope.ListItems.Count > 0 Then
        lsvCourse_Ope.ListItems(1).Selected = True
    End If
    
    mblnShowOpe = True

    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Sub

Private Sub lsvCourse_Ope_DblClick()

    Call cmdEditCourse_Ope_Click
    
End Sub

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


Private Sub lsvItem_DblClick()

    '�v���p�e�B�\��
    Call cmdItemProperty_Click

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

Private Sub lsvJud_DblClick()

    Call cmdEditJudClass_Click
    
End Sub


Private Sub lsvJud_KeyDown(KeyCode As Integer, Shift As Integer)
    
    Dim i As Long

    'CTRL+A���������ꂽ�ꍇ�A���ڂ�S�đI������
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvJud.ListItems.Count
            lsvJud.ListItems(i).Selected = True
        Next i
    End If

End Sub


' @(e)
'
' �@�\�@�@ : �^�u�N���b�N
'
' �@�\���� : �N���b�N���ꂽ�^�u�ɉ����ĕ\��������s��
'
' ���l�@�@ :
'
Private Sub tabMain_Click(PreviousTab As Integer)

    Screen.MousePointer = vbHourglass
    
    '�N���b�N���ꂽ�^�u�ɉ����ď������s
    Select Case tabMain.Tab
        
        Case 1  '��f���ڋy�ї����Ǘ��^�u
            Call EditItemTab
        
        Case 2  '����^�u
            Call EditJudClassTab
        
        Case 3  '���{�Ǐ��^�u
            Frame3.Visible = False
        
        Case 4  '���{���Ǘ��^�u
            
            LabelOperationGuide.Caption = "���̃R�[�X�Ŏ�f���鍀�ڂ̌������{����ݒ肵�܂��B" & vbLf & vbLf & _
                                          "�����Ŏw�肵���ݒ�͑��V�X�e���Ƃ̘A�g���ɗL���ł��B" & vbLf & _
                                          "���f�V�X�e�����Ŏ��{���鍀�ڂɂ͐ݒ肷��K�v�͂���܂���B"
            Call EditListCourse_Ope
    
    End Select
    
    Screen.MousePointer = vbDefault
    
End Sub


' @(e)
'
' �@�\�@�@ : �R�[�X�����f�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �R�[�X�ɑ��݂��闚���f�[�^��\������
'
' ���l�@�@ :
'
Private Function EditCourseHistory() As Boolean

    Dim objCourse   As Object           '�R�[�X�A�N�Z�X�p
    
    Dim dtmStrDate  As Date
    Dim dtmEndDate  As Date
    Dim vntStrDate  As Variant
    Dim vntEndDate  As Variant
    Dim vntPrice    As Variant
    Dim vntTax      As Variant
    Dim vntCsHNo    As Variant

    Dim lngCount    As Long             '���R�[�h��
    Dim i           As Long             '�C���f�b�N�X
    
    EditCourseHistory = False
    cboHistory.Clear
    Erase mintCsHNo
    Erase mstrStrDate
    Erase mstrEndDate
    Erase mlngPrice

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objCourse = CreateObject("HainsCourse.Course")
    lngCount = objCourse.SelectCourseHistory(mstrCsCd, dtmStrDate, dtmEndDate, _
                                             vntStrDate, vntEndDate, vntPrice, _
                                             vntTax, vntCsHNo)
    
    '�R���{�{�b�N�X�̕ҏW
    For i = 0 To lngCount - 1
        ReDim Preserve mintCsHNo(i)
        ReDim Preserve mstrStrDate(i)
        ReDim Preserve mstrEndDate(i)
        ReDim Preserve mlngPrice(i)
'### 2002.05.01 Modified by Ishihara@FSIT NT��2000�N���ł��܂���
'        cboHistory.AddItem CStr(vntStrDate(i)) & "�`" & CStr(vntEndDate(i)) & "�ɓK�p����f�[�^"
        cboHistory.AddItem CStr(Format(vntStrDate(i), "YYYY/MM/DD")) & "�`" & CStr(Format(vntEndDate(i), "YYYY/MM/DD")) & "�ɓK�p����f�[�^"
'### 2002.05.01 Modified End
        mintCsHNo(i) = vntCsHNo(i)
'### 2002.05.01 Modified by Ishihara@FSIT NT��2000�N���ł��܂���
'        mstrStrDate(i) = vntStrDate(i)
'        mstrEndDate(i) = vntEndDate(i)
        mstrStrDate(i) = Format(vntStrDate(i), "YYYY/MM/DD")
        mstrEndDate(i) = Format(vntEndDate(i), "YYYY/MM/DD")
'### 2002.05.01 Modified End
        mlngPrice(i) = vntPrice(i)
    Next i
    
    '�����f�[�^�����݂���Ȃ�A�R���{�I��
    If lngCount > 0 Then
        cboHistory.ListIndex = 0
        EditCourseHistory = True
    End If
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' �@�\�@�@ : �������ڃ^�u�N���b�N
'
' �@�\���� : �������y�сA��f�������ڂ̕\�����s��
'
' ���l�@�@ :
'
Private Sub EditItemTab()

    Dim blnStatus       As Boolean
    Dim blnCboStatus    As Boolean

    '�������t���O���X�V���ɕύX
    mblnNowEdit = True

    '�R�[�X�����R���{�̐ݒ�i���߂ĕ\���A�������̓f�[�^�ύX������̂݁j
    If mblnShowItem = False Then
        blnStatus = EditCourseHistory()
    Else
        '���ڂ�\�����Ă��܂��Ă���Ȃ�A�����͎擾�������̂Ƃ���TRUE�ɂ���
        blnStatus = (cboHistory.ListCount > 0)
    End If

    '�R���g���[���̃C�l�[�u������i�����R���{�̗L���ɂ��ݒ�j
    cmdNewHistory.Enabled = (mstrCsCd <> "")
    cmdEditHistory.Enabled = blnStatus
    cmdDeleteHistory.Enabled = blnStatus
'### 2003/11/11 Deleted by Ishihara@FSIT �R�[�X���������ڂ̒ǉ��͋����Ȃ�
'    cmdAddItem.Enabled = blnStatus
'### 2003/11/11 Deleted End
    cmdDeleteItem.Enabled = blnStatus
    cmdItemProperty.Enabled = blnStatus
    lsvItem.Enabled = blnStatus
    
    '�R�[�X���������݁A�����܂���x���\�����ĂȂ��ꍇ�A��f���ڂ̕ҏW
    If (blnStatus = True) And (mblnShowItem = False) Then
        Call EditListItem
    End If
        
    '�R�[�X�������Ȃ������\���̂Ƃ��ɂP�񂾂����b�Z�[�W�\��
    If cmdNewHistory.Enabled = False Then
        MsgBox "�������ڊ֘A�f�[�^��o�^����ۂ́A��x��{�����i�[����K�v������܂��B" & vbLf & _
               "��{�����i�[���Ă���o�^���Ă��������B", vbExclamation, Me.Caption
    End If
    
    '�������t���O�𖢏����ɕύX
    mblnNowEdit = False
    
    '�f�[�^�\���ς݂Ƃ��Ē�`
    mblnShowItem = True
    
End Sub

' @(e)
'
' �@�\�@�@ : ���蕪�ރ^�u�N���b�N
'
' �@�\���� : �R�[�X���Ǌ��̔��蕪�ނ�\������
'
' ���l�@�@ :
'
Private Sub EditJudClassTab()

    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    '�������t���O���X�V���ɕύX
    mblnNowEdit = True

    '�R�[�X���蕪�ނ̕\���ҏW
    Call EditListJud
    
    '�������t���O�𖢏����ɕύX
    mblnNowEdit = False
    
    '�f�[�^�\���ς݂Ƃ��Ē�`
    mblnShowJud = True
    
End Sub

' @(e)
'
' �@�\�@�@ : �R�[�X���ڎ��{���^�u�N���b�N
'
' �@�\���� : �R�[�X���Ǌ��̔��蕪�ނ�\������
'
' ���l�@�@ :
'
Private Sub EditCourseOpeTab()

    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    '�������t���O���X�V���ɕύX
    mblnNowEdit = True

    '�R�[�X���蕪�ނ̕\���ҏW
    Call EditListJud
    
    '�������t���O�𖢏����ɕύX
    mblnNowEdit = False
    
    '�f�[�^�\���ς݂Ƃ��Ē�`
    mblnShowJud = True
    
End Sub


' @(e)
'
' �@�\�@�@ : �R�[�X����ҏW�E�C���h�E�\��
'
' �����@�@ : (In)      modeNew  TRUE:�V�K���[�h�AFALSE:�X�V���[�h
'
' �@�\���� :
'
' ���l�@�@ :
'
Private Sub ShowCourse_h(modeNew As Boolean)
    
    With frmCourse_h
        
        .CsCd = mstrCsCd
        
        If modeNew = True Then
            '�V�K���[�h�̏ꍇ�A����ԍ���-1���Z�b�g�i���蓾�Ȃ����߁j
            .CsHNo = -1
            .strDate = ""
            .endDate = ""
            .Price = 0
        Else
            '�X�V���[�h�̏ꍇ�A���݂̗��������Z�b�g
            .CsHNo = mintCsHNo(cboHistory.ListIndex)
            .strDate = mstrStrDate(cboHistory.ListIndex)
            .endDate = mstrEndDate(cboHistory.ListIndex)
            .Price = mlngPrice(cboHistory.ListIndex)
        End If
        
        .Show vbModal
    
        '�f�[�^���X�V���ꂽ��A��ʃf�[�^�ĕҏW
        If .Updated = True Then
            mblnShowItem = False
            Call EditItemTab
        End If
        
    End With

End Sub

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

