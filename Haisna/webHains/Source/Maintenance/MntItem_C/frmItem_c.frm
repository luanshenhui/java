VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmItem_c 
   BorderStyle     =   3  '�Œ��޲�۸�
   Caption         =   "�������ڏ��̐ݒ�"
   ClientHeight    =   7575
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7815
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmItem_c.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7575
   ScaleWidth      =   7815
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '��Ű ̫�т̒���
   Begin VB.CommandButton cmdApply 
      Caption         =   "�K�p(A)"
      Height          =   315
      Left            =   6420
      TabIndex        =   45
      Top             =   7080
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3660
      TabIndex        =   43
      Top             =   7080
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "�L�����Z��"
      Height          =   315
      Left            =   5040
      TabIndex        =   44
      Top             =   7080
      Width           =   1275
   End
   Begin TabDlg.SSTab tabMain 
      Height          =   6855
      Left            =   120
      TabIndex        =   54
      Top             =   120
      Width           =   7575
      _ExtentX        =   13361
      _ExtentY        =   12091
      _Version        =   393216
      Style           =   1
      Tabs            =   4
      Tab             =   2
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
      TabCaption(0)   =   "��{���"
      TabPicture(0)   =   "frmItem_c.frx":000C
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "Frame4"
      Tab(0).Control(1)=   "Frame3"
      Tab(0).Control(2)=   "txtSuffix"
      Tab(0).Control(3)=   "txtItemCd"
      Tab(0).Control(4)=   "Label1(0)"
      Tab(0).Control(5)=   "LabelCourseGuide"
      Tab(0).Control(6)=   "Image1(0)"
      Tab(0).Control(7)=   "Label1(2)"
      Tab(0).ControlCount=   8
      TabCaption(1)   =   "����ݒ�֘A"
      TabPicture(1)   =   "frmItem_c.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Image1(4)"
      Tab(1).Control(1)=   "Label5"
      Tab(1).Control(2)=   "Frame1"
      Tab(1).ControlCount=   3
      TabCaption(2)   =   "���̑��ݒ�"
      TabPicture(2)   =   "frmItem_c.frx":0044
      Tab(2).ControlEnabled=   -1  'True
      Tab(2).Control(0)=   "Image1(3)"
      Tab(2).Control(0).Enabled=   0   'False
      Tab(2).Control(1)=   "LabelJudGuide"
      Tab(2).Control(1).Enabled=   0   'False
      Tab(2).Control(2)=   "Label2(14)"
      Tab(2).Control(2).Enabled=   0   'False
      Tab(2).Control(3)=   "Label2(13)"
      Tab(2).Control(3).Enabled=   0   'False
      Tab(2).Control(4)=   "Label2(12)"
      Tab(2).Control(4).Enabled=   0   'False
      Tab(2).Control(5)=   "Label2(11)"
      Tab(2).Control(5).Enabled=   0   'False
      Tab(2).Control(6)=   "Label2(10)"
      Tab(2).Control(6).Enabled=   0   'False
      Tab(2).Control(7)=   "Label2(9)"
      Tab(2).Control(7).Enabled=   0   'False
      Tab(2).Control(8)=   "Frame11"
      Tab(2).Control(8).Enabled=   0   'False
      Tab(2).Control(9)=   "Frame10"
      Tab(2).Control(9).Enabled=   0   'False
      Tab(2).Control(10)=   "txtLoadCd2"
      Tab(2).Control(10).Enabled=   0   'False
      Tab(2).Control(11)=   "txtLoadCd1"
      Tab(2).Control(11).Enabled=   0   'False
      Tab(2).Control(12)=   "txtWsCd"
      Tab(2).Control(12).Enabled=   0   'False
      Tab(2).Control(13)=   "txtLabelMark"
      Tab(2).Control(13).Enabled=   0   'False
      Tab(2).Control(14)=   "txtMaterials"
      Tab(2).Control(14).Enabled=   0   'False
      Tab(2).Control(15)=   "txtCollectTubeCd"
      Tab(2).Control(15).Enabled=   0   'False
      Tab(2).ControlCount=   16
      TabCaption(3)   =   "���͌���"
      TabPicture(3)   =   "frmItem_c.frx":0060
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "LabelRecentCount"
      Tab(3).Control(1)=   "LabelGovGuide"
      Tab(3).Control(2)=   "Image1(1)"
      Tab(3).Control(3)=   "cboRecentCount"
      Tab(3).Control(4)=   "Frame8"
      Tab(3).Control(5)=   "Frame7"
      Tab(3).ControlCount=   6
      Begin VB.TextBox txtCollectTubeCd 
         Height          =   318
         IMEMode         =   3  '�̌Œ�
         Left            =   5700
         MaxLength       =   2
         TabIndex        =   88
         Text            =   "@@"
         Top             =   4620
         Visible         =   0   'False
         Width           =   375
      End
      Begin VB.TextBox txtMaterials 
         Height          =   318
         IMEMode         =   3  '�̌Œ�
         Left            =   5700
         MaxLength       =   3
         TabIndex        =   87
         Text            =   "@@"
         Top             =   4260
         Visible         =   0   'False
         Width           =   375
      End
      Begin VB.TextBox txtLabelMark 
         Height          =   318
         IMEMode         =   3  '�̌Œ�
         Left            =   3960
         MaxLength       =   2
         TabIndex        =   86
         Text            =   "@@"
         Top             =   4260
         Visible         =   0   'False
         Width           =   375
      End
      Begin VB.TextBox txtWsCd 
         Height          =   318
         IMEMode         =   3  '�̌Œ�
         Left            =   3960
         MaxLength       =   2
         TabIndex        =   85
         Text            =   "@@"
         Top             =   4620
         Visible         =   0   'False
         Width           =   375
      End
      Begin VB.TextBox txtLoadCd1 
         Height          =   318
         IMEMode         =   3  '�̌Œ�
         Left            =   1800
         MaxLength       =   2
         TabIndex        =   84
         Text            =   "@@"
         Top             =   4260
         Visible         =   0   'False
         Width           =   375
      End
      Begin VB.TextBox txtLoadCd2 
         Height          =   318
         IMEMode         =   3  '�̌Œ�
         Left            =   1800
         MaxLength       =   2
         TabIndex        =   83
         Text            =   "@@"
         Top             =   4620
         Visible         =   0   'False
         Width           =   375
      End
      Begin VB.Frame Frame10 
         Caption         =   "���̑��ݒ�֘A"
         Height          =   1515
         Left            =   300
         TabIndex        =   81
         Top             =   5100
         Visible         =   0   'False
         Width           =   5835
         Begin VB.TextBox txtContractItemCd 
            Height          =   318
            IMEMode         =   3  '�̌Œ�
            Left            =   1800
            MaxLength       =   17
            TabIndex        =   51
            Text            =   "@@@@@@@@@@@@@@@@@"
            Top             =   1020
            Width           =   2235
         End
         Begin VB.TextBox txtContractCd 
            Height          =   318
            IMEMode         =   3  '�̌Œ�
            Left            =   1800
            MaxLength       =   1
            TabIndex        =   49
            Text            =   "@"
            Top             =   660
            Width           =   255
         End
         Begin VB.TextBox txtCollectCd 
            Height          =   318
            IMEMode         =   3  '�̌Œ�
            Left            =   1800
            MaxLength       =   3
            TabIndex        =   47
            Text            =   "@@@"
            Top             =   300
            Width           =   495
         End
         Begin VB.Label Label2 
            Caption         =   "�O�����ʃR�[�h(&R):"
            Height          =   195
            Index           =   7
            Left            =   240
            TabIndex        =   50
            Top             =   1080
            Width           =   1635
         End
         Begin VB.Label Label2 
            Caption         =   "�O����R�[�h(&G):"
            Height          =   195
            Index           =   6
            Left            =   240
            TabIndex        =   48
            Top             =   720
            Width           =   1455
         End
         Begin VB.Label Label2 
            Caption         =   "�̎�R�[�h(&S):"
            Height          =   195
            Index           =   5
            Left            =   240
            TabIndex        =   46
            Top             =   360
            Width           =   1515
         End
      End
      Begin VB.Frame Frame11 
         Caption         =   "�������ڐ���"
         Height          =   2475
         Left            =   240
         TabIndex        =   82
         Top             =   1200
         Width           =   7035
         Begin VB.TextBox txtExplanation 
            Height          =   1935
            Left            =   240
            MultiLine       =   -1  'True
            TabIndex        =   30
            Text            =   "frmItem_c.frx":007C
            Top             =   300
            Width           =   6555
         End
      End
      Begin VB.Frame Frame7 
         Caption         =   "�ݒ肷�镶��"
         Height          =   4095
         Left            =   -74820
         TabIndex        =   34
         Top             =   2040
         Width           =   7095
         Begin VB.CommandButton cmdStcItemCd 
            Caption         =   "�Q��(&B)..."
            Height          =   315
            Left            =   240
            TabIndex        =   37
            Top             =   1080
            Width           =   1395
         End
         Begin VB.OptionButton optStcMySelf 
            Caption         =   "���͂͂��̍��ڂŐݒ肵�����̂��g�p����(&U)"
            Height          =   255
            Index           =   0
            Left            =   240
            TabIndex        =   35
            Top             =   360
            Value           =   -1  'True
            Width           =   4575
         End
         Begin VB.OptionButton optStcMySelf 
            Caption         =   "���̌������ڂŐݒ肵�����͂��g�p����(&O)"
            Height          =   255
            Index           =   1
            Left            =   240
            TabIndex        =   36
            Top             =   660
            Width           =   4575
         End
         Begin MSComctlLib.ListView lsvStc 
            Height          =   2175
            Left            =   240
            TabIndex        =   40
            Top             =   1800
            Width           =   6555
            _ExtentX        =   11562
            _ExtentY        =   3836
            LabelEdit       =   1
            MultiSelect     =   -1  'True
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
            NumItems        =   0
         End
         Begin VB.Label lblStcItemCd 
            Caption         =   "000102�F�����w��"
            BeginProperty Font 
               Name            =   "MS UI Gothic"
               Size            =   9
               Charset         =   128
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   255
            Left            =   1740
            TabIndex        =   38
            Top             =   1140
            Width           =   3735
         End
         Begin VB.Label Label4 
            Caption         =   "�o�^����Ă��镶��(&P):"
            Height          =   255
            Left            =   300
            TabIndex        =   39
            Top             =   1560
            Width           =   2115
         End
      End
      Begin VB.Frame Frame8 
         Caption         =   "��{�ݒ�"
         Height          =   795
         Left            =   -74820
         TabIndex        =   31
         Top             =   1080
         Width           =   7095
         Begin VB.ComboBox cboItemType 
            Height          =   300
            ItemData        =   "frmItem_c.frx":0082
            Left            =   1260
            List            =   "frmItem_c.frx":00A4
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   33
            Top             =   300
            Width           =   4530
         End
         Begin VB.Label Label8 
            Caption         =   "���ڃ^�C�v(&I):"
            Height          =   195
            Index           =   2
            Left            =   240
            TabIndex        =   32
            Top             =   360
            Width           =   1095
         End
      End
      Begin VB.ComboBox cboRecentCount 
         Height          =   300
         ItemData        =   "frmItem_c.frx":00C6
         Left            =   -68580
         List            =   "frmItem_c.frx":00E8
         Style           =   2  '��ۯ���޳� ؽ�
         TabIndex        =   42
         Top             =   6240
         Width           =   810
      End
      Begin VB.Frame Frame4 
         Caption         =   "���ڑ����ݒ�֘A"
         Height          =   2235
         Left            =   -74820
         TabIndex        =   58
         Top             =   4320
         Width           =   7155
         Begin VB.CheckBox chkHideInterview 
            Caption         =   "���ʂ��Z�b�g����Ă��Ȃ��ꍇ�A�ʐڎx����ʂł͔�\���ɂ���(&H):"
            Height          =   180
            Left            =   180
            TabIndex        =   19
            Top             =   1740
            Width           =   5655
         End
         Begin VB.CheckBox chkCuTargetFlg 
            Caption         =   "���̌������ڂ�CU�o�N�ω��\���ΏۂƂ���(&U):"
            Height          =   180
            Left            =   180
            TabIndex        =   18
            Top             =   1440
            Width           =   5655
         End
         Begin VB.CheckBox chkNoPrintFlg 
            Caption         =   "���̌������ʂ͕񍐏��́u���̑��������v�ɏo�͂��Ȃ�(&P):"
            Height          =   180
            Left            =   180
            TabIndex        =   17
            Top             =   1140
            Width           =   5655
         End
         Begin VB.ComboBox cboResultType 
            Height          =   300
            ItemData        =   "frmItem_c.frx":010A
            Left            =   1800
            List            =   "frmItem_c.frx":012C
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   14
            Top             =   300
            Width           =   4110
         End
         Begin VB.ComboBox cboSearchChar 
            Height          =   300
            ItemData        =   "frmItem_c.frx":014E
            Left            =   1800
            List            =   "frmItem_c.frx":0170
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   16
            Top             =   660
            Width           =   810
         End
         Begin VB.Label Label8 
            Caption         =   "���ʃ^�C�v(&K):"
            Height          =   195
            Index           =   0
            Left            =   180
            TabIndex        =   13
            Top             =   360
            Width           =   1335
         End
         Begin VB.Label Label3 
            Caption         =   "�����p������(&C):"
            Height          =   195
            Index           =   2
            Left            =   180
            TabIndex        =   15
            Top             =   720
            Width           =   1395
         End
      End
      Begin VB.Frame Frame3 
         Caption         =   "���̐ݒ�֘A"
         Height          =   2295
         Left            =   -74820
         TabIndex        =   52
         Top             =   1860
         Width           =   7155
         Begin VB.TextBox txtItemEName 
            Height          =   318
            IMEMode         =   3  '�̌Œ�
            Left            =   1800
            MaxLength       =   32
            TabIndex        =   10
            Text            =   "@@@@@@@@@@"
            Top             =   1380
            Width           =   5175
         End
         Begin VB.TextBox txtItemQName 
            Height          =   318
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1800
            MaxLength       =   40
            TabIndex        =   12
            Text            =   "����������������������������������������"
            Top             =   1740
            Width           =   5175
         End
         Begin VB.TextBox txtItemName 
            Height          =   318
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1800
            MaxLength       =   100
            TabIndex        =   4
            Text            =   "��������������������"
            Top             =   300
            Width           =   5175
         End
         Begin VB.TextBox txtItemSName 
            Height          =   318
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1800
            MaxLength       =   100
            TabIndex        =   6
            Text            =   "����������"
            Top             =   660
            Width           =   5175
         End
         Begin VB.TextBox txtItemRName 
            Height          =   318
            IMEMode         =   4  '�S�p�Ђ炪��
            Left            =   1800
            MaxLength       =   100
            TabIndex        =   8
            Text            =   "��������������������������������"
            Top             =   1020
            Width           =   5175
         End
         Begin VB.Label Label2 
            Caption         =   "�p�ꍀ�ږ�(&E):"
            Height          =   195
            Index           =   4
            Left            =   180
            TabIndex        =   9
            Top             =   1440
            Width           =   1635
         End
         Begin VB.Label Label2 
            Caption         =   "��f�p����(&Q):"
            Height          =   195
            Index           =   3
            Left            =   180
            TabIndex        =   11
            Top             =   1800
            Width           =   1635
         End
         Begin VB.Label Label2 
            Caption         =   "�������ږ�(&N):"
            Height          =   195
            Index           =   0
            Left            =   180
            TabIndex        =   3
            Top             =   360
            Width           =   1275
         End
         Begin VB.Label Label2 
            Caption         =   "����(&S):"
            Height          =   195
            Index           =   1
            Left            =   180
            TabIndex        =   5
            Top             =   720
            Width           =   1395
         End
         Begin VB.Label Label2 
            Caption         =   "�񍐏��p�\����(&R):"
            Height          =   195
            Index           =   2
            Left            =   180
            TabIndex        =   7
            Top             =   1080
            Width           =   1635
         End
      End
      Begin VB.TextBox txtSuffix 
         Height          =   315
         IMEMode         =   3  '�̌Œ�
         Left            =   -72060
         MaxLength       =   2
         TabIndex        =   2
         Text            =   "@@"
         Top             =   1320
         Width           =   375
      End
      Begin VB.Frame Frame1 
         Caption         =   "�����f�[�^(&H)"
         Height          =   5595
         Left            =   -74820
         TabIndex        =   53
         Top             =   1080
         Width           =   7215
         Begin VB.Frame Frame9 
            Caption         =   "�A�g�֘A���"
            Height          =   915
            Left            =   180
            TabIndex        =   95
            Top             =   3900
            Width           =   6795
            Begin VB.TextBox txtOrderDiv 
               Height          =   318
               IMEMode         =   3  '�̌Œ�
               Left            =   1440
               MaxLength       =   12
               TabIndex        =   25
               Text            =   "@@"
               Top             =   420
               Width           =   2235
            End
            Begin VB.TextBox txtBuiCode 
               Height          =   318
               IMEMode         =   3  '�̌Œ�
               Left            =   5100
               MaxLength       =   2
               TabIndex        =   27
               Text            =   "@@"
               Top             =   480
               Width           =   375
            End
            Begin VB.Label Label2 
               Caption         =   "�I�[�_���(&D):"
               Height          =   195
               Index           =   15
               Left            =   300
               TabIndex        =   24
               Top             =   480
               Width           =   1515
            End
            Begin VB.Label Label2 
               Caption         =   "���ʃR�[�h(&B):"
               Height          =   195
               Index           =   16
               Left            =   3960
               TabIndex        =   26
               Top             =   540
               Width           =   1215
            End
         End
         Begin VB.TextBox txtOldItemCd 
            Height          =   318
            IMEMode         =   3  '�̌Œ�
            Left            =   5700
            MaxLength       =   9
            TabIndex        =   29
            Text            =   "@@@@@@@@@"
            Top             =   4980
            Width           =   1275
         End
         Begin VB.Frame Frame5 
            Caption         =   "�d�q�J���e�V�X�e���A�g"
            Height          =   795
            Left            =   4800
            TabIndex        =   66
            Top             =   2880
            Visible         =   0   'False
            Width           =   2055
            Begin MSComctlLib.ListView lsvKarteItem 
               Height          =   315
               Left            =   180
               TabIndex        =   78
               Top             =   300
               Width           =   1755
               _ExtentX        =   3096
               _ExtentY        =   556
               LabelEdit       =   1
               MultiSelect     =   -1  'True
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
               NumItems        =   0
            End
         End
         Begin VB.Frame Frame6 
            Caption         =   "�����V�X�e���A�g"
            Height          =   1155
            Left            =   180
            TabIndex        =   67
            Top             =   2640
            Width           =   6795
            Begin VB.Label lblReqItemCd 
               Caption         =   "12345678901234567"
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
               Left            =   1380
               TabIndex        =   80
               Top             =   360
               Width           =   4035
            End
            Begin VB.Label Label8 
               Caption         =   "�˗��p�R�[�h:"
               Height          =   195
               Index           =   1
               Left            =   240
               TabIndex        =   79
               Top             =   360
               Width           =   1515
            End
            Begin VB.Label lblinsItemCd 
               Caption         =   "12345678901234567"
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
               Left            =   1680
               TabIndex        =   75
               Top             =   720
               Width           =   1995
            End
            Begin VB.Label Label8 
               Caption         =   "���ʕϊ��p�R�[�h:"
               Height          =   195
               Index           =   15
               Left            =   240
               TabIndex        =   68
               Top             =   720
               Width           =   1515
            End
         End
         Begin VB.Frame Frame2 
            Caption         =   "���͌��ʒ�`�֘A"
            Height          =   1335
            Left            =   180
            TabIndex        =   59
            Top             =   1200
            Width           =   6795
            Begin VB.Label lblUnit 
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
               Height          =   195
               Left            =   5100
               TabIndex        =   74
               Top             =   360
               Width           =   1275
            End
            Begin VB.Label lblDefResult 
               Caption         =   "99�F�ُ�Ȃ�"
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
               Left            =   1800
               TabIndex        =   73
               Top             =   960
               Width           =   3435
            End
            Begin VB.Label lblMaxValue 
               Caption         =   "12345678"
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
               Left            =   4380
               TabIndex        =   72
               Top             =   660
               Width           =   1035
            End
            Begin VB.Label lblMinValue 
               Caption         =   "12345678"
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
               Left            =   1800
               TabIndex        =   71
               Top             =   660
               Width           =   855
            End
            Begin VB.Label lblFigure2 
               Caption         =   "2"
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
               Left            =   4080
               TabIndex        =   70
               Top             =   360
               Width           =   255
            End
            Begin VB.Label lblFigure1 
               Caption         =   "3"
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
               Left            =   1560
               TabIndex        =   69
               Top             =   360
               Width           =   255
            End
            Begin VB.Label Label8 
               Caption         =   "����������:"
               Height          =   195
               Index           =   9
               Left            =   240
               TabIndex        =   65
               Top             =   360
               Width           =   1215
            End
            Begin VB.Label Label8 
               Caption         =   "����������:"
               Height          =   195
               Index           =   10
               Left            =   2760
               TabIndex        =   64
               Top             =   360
               Width           =   1215
            End
            Begin VB.Label Label8 
               Caption         =   "���͉\�ȍő�l:"
               Height          =   195
               Index           =   11
               Left            =   2760
               TabIndex        =   63
               Top             =   660
               Width           =   1755
            End
            Begin VB.Label Label8 
               Caption         =   "���͉\�ȍŏ��l:"
               Height          =   195
               Index           =   12
               Left            =   240
               TabIndex        =   62
               Top             =   660
               Width           =   1755
            End
            Begin VB.Label Label8 
               Caption         =   "�ȗ�����������:"
               Height          =   195
               Index           =   3
               Left            =   240
               TabIndex        =   61
               Top             =   960
               Width           =   1815
            End
            Begin VB.Label Label8 
               Caption         =   "�P��:"
               Height          =   195
               Index           =   14
               Left            =   4500
               TabIndex        =   60
               Top             =   360
               Width           =   795
            End
         End
         Begin VB.ComboBox cboHistory 
            Height          =   300
            ItemData        =   "frmItem_c.frx":0192
            Left            =   240
            List            =   "frmItem_c.frx":01B4
            Style           =   2  '��ۯ���޳� ؽ�
            TabIndex        =   20
            Top             =   300
            Width           =   5670
         End
         Begin VB.CommandButton cmdNewHistory 
            Caption         =   "�V�K(&N)..."
            Height          =   315
            Left            =   1860
            TabIndex        =   21
            Top             =   720
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditHistory 
            Caption         =   "�ҏW(&E)..."
            Height          =   315
            Left            =   3240
            TabIndex        =   22
            Top             =   720
            Width           =   1275
         End
         Begin VB.CommandButton cmdDeleteHistory 
            Caption         =   "�폜(&D)..."
            Height          =   315
            Left            =   4620
            TabIndex        =   23
            Top             =   720
            Width           =   1275
         End
         Begin VB.Label Label2 
            Caption         =   "�ڍs�拌�������ڃR�[�h(&I):"
            Height          =   195
            Index           =   8
            Left            =   3480
            TabIndex        =   28
            Top             =   5040
            Width           =   2295
         End
      End
      Begin VB.TextBox txtItemCd 
         Height          =   315
         IMEMode         =   3  '�̌Œ�
         Left            =   -73140
         MaxLength       =   6
         TabIndex        =   1
         Text            =   "@@@@@@"
         Top             =   1320
         Width           =   855
      End
      Begin VB.Label Label2 
         Caption         =   "�̎�ǃR�[�h(&T):"
         Height          =   195
         Index           =   9
         Left            =   4440
         TabIndex        =   94
         Top             =   4680
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "�ޗ��R�[�h(&M):"
         Height          =   195
         Index           =   10
         Left            =   4440
         TabIndex        =   93
         Top             =   4320
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "���x���}�[�N(&L):"
         Height          =   195
         Index           =   11
         Left            =   2460
         TabIndex        =   92
         Top             =   4320
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "�v�r�R�[�h(&W):"
         Height          =   195
         Index           =   12
         Left            =   2460
         TabIndex        =   91
         Top             =   4680
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "���׃R�[�h�P(&1):"
         Height          =   195
         Index           =   13
         Left            =   300
         TabIndex        =   90
         Top             =   4320
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "���׃R�[�h�Q(&2):"
         Height          =   195
         Index           =   14
         Left            =   300
         TabIndex        =   89
         Top             =   4680
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   1
         Left            =   -74700
         Picture         =   "frmItem_c.frx":01D6
         Top             =   540
         Width           =   480
      End
      Begin VB.Label LabelGovGuide 
         Caption         =   "���̌������ڂŎg�p���镶�͌��ʂł�"
         Height          =   255
         Left            =   -74040
         TabIndex        =   77
         Top             =   660
         Width           =   3915
      End
      Begin VB.Label LabelRecentCount 
         Caption         =   "�ŋߎg�������͊Ǘ���(&B):"
         Height          =   195
         Left            =   -70620
         TabIndex        =   41
         Top             =   6300
         Width           =   2115
      End
      Begin VB.Label LabelJudGuide 
         Caption         =   "���̑��ݒ���"
         Height          =   255
         Left            =   900
         TabIndex        =   76
         Top             =   720
         Width           =   3555
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   3
         Left            =   240
         Picture         =   "frmItem_c.frx":04E0
         Top             =   600
         Width           =   480
      End
      Begin VB.Label Label1 
         Caption         =   "-"
         Height          =   195
         Index           =   0
         Left            =   -72240
         TabIndex        =   57
         Top             =   1380
         Width           =   135
      End
      Begin VB.Label Label5 
         Caption         =   "�������ڂ̗����Ǘ�����ݒ肵�܂��B"
         Height          =   255
         Left            =   -73980
         TabIndex        =   56
         Top             =   660
         Width           =   4275
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   4
         Left            =   -74700
         Picture         =   "frmItem_c.frx":0922
         Top             =   540
         Width           =   480
      End
      Begin VB.Label LabelCourseGuide 
         Caption         =   "�������ڂ̊�{�I�ȏ���ݒ肵�܂��B"
         Height          =   255
         Left            =   -74160
         TabIndex        =   55
         Top             =   660
         Width           =   3915
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   0
         Left            =   -74820
         Picture         =   "frmItem_c.frx":1064
         Top             =   540
         Width           =   480
      End
      Begin VB.Label Label1 
         Caption         =   "�������ڃR�[�h(&C):"
         Height          =   195
         Index           =   2
         Left            =   -74760
         TabIndex        =   0
         Top             =   1380
         Width           =   1395
      End
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   120
      Top             =   6840
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
            Picture         =   "frmItem_c.frx":14A6
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_c.frx":18F8
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_c.frx":1D4A
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_c.frx":1EA4
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "frmItem_c"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'�v���p�e�B�p�̈�
Private mstrItemCd              As String       '�������ڃR�[�h
Private mstrSuffix              As String       '�T�t�B�b�N�X
Private mintRslQue              As String       '���ʖ�f�t���O
Private mstrStcItemCd           As String       '���͎Q�Ɨp���ڃR�[�h

Private mblnUpdated             As Boolean      'TRUE:�X�V����AFALSE:�X�V�Ȃ�
Private mblnInitialize          As Boolean      'TRUE:����ɏ������AFALSE:���������s

Private mcolItemHistory         As Collection   '�������ڗ����Ǘ��f�[�^�i�[�p�R���N�V����
Private mcolKarteItem           As Collection   '�d�q�J���e���ڃR�[�h�ϊ��p�f�[�^�i�[�p�R���N�V����

'�����R���{�Ή��f�[�^�ޔ�p
Const mstrColKeyPrefix          As String = "K"
Private mstrItemHistoryKey()    As String       '�����R���{�ɑΉ�����R���N�V�����L�[
Private mintColKey              As Integer      '���X�g�r���[�L�[�����j�[�N�ɂ��邽�߂�Index�i����p�j
Private mintKarteColKey         As Integer      '���X�g�r���[�L�[�����j�[�N�ɂ��邽�߂�Index�i�J���e�p�j

Private mintCsHNo()             As Integer  '�����R���{�ɑΉ����闚��ԍ�
Private mstrStrDate()           As String   '�����R���{�ɑΉ�����J�n���t
Private mstrEndDate()           As String   '�����R���{�ɑΉ�����I�����t
Private mlngPrice()             As Long     '�����R���{�ɑΉ����錟�����ڊ�{����

'�^�u�N���b�N���̕\������p�t���O
Private mblnShowHistory         As Boolean  'TRUE:�\���ς݁AFALSE:���\��
Private mblnShowOpe             As Boolean  'TRUE:�\���ς݁AFALSE:���\��
Private mblnShowJud             As Boolean  'TRUE:�\���ς݁AFALSE:���\��
Private mblnShowGov             As Boolean  'TRUE:�\���ς݁AFALSE:���\��

'�ۑ��Ώۃf�[�^����p
Private mblnEditMain            As Boolean  'TRUE:�X�V�AFALSE:���X�V
Private mblnEditItemHistory     As Boolean  'TRUE:�X�V�AFALSE:���X�V
Private mblnEditOpe             As Boolean  'TRUE:�X�V�AFALSE:���X�V
Private mblnEditJud             As Boolean  'TRUE:�X�V�AFALSE:���X�V

Private mblnNowEdit             As Boolean  'TRUE:�ҏW�������AFALSE:�����Ȃ�

Private mcolGotFocusCollection  As Collection   'GotFocus���̕����I��p�R���N�V����

'�Œ�R�[�h�Ǘ�
Const GRPDIV_ITEM               As String = "I"
Const GRPDIV_GRP                As String = "G"
Const mstrListViewKey           As String = "K"

Const INSERT_NORMAL             As Long = 1
Const INSERT_DUPLICATE          As Long = 0
Const INSERT_ERROR              As Long = -1

Const NOREASON_TEXT             As String = "����"

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Friend Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
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

    Dim Ret             As Boolean  '�֐��߂�l
    Dim objItemHistory  As ItemHistory
    Dim strInsItemCd    As String
    Dim strSepOrderDiv  As String
    
    '��������
    Ret = False
        
    '�������g��SetFocus����ƕ�����I����Ԃ��O���̂ŁA�_�~�[SetFocus
    cmdOk.SetFocus
    
    Do
        '�R�[�h�͂Ƃ�݂�
        txtItemCd.Text = Trim(txtItemCd.Text)
        txtSuffix.Text = Trim(txtSuffix.Text)
        
        '�������ڊ֘A
        If Trim(txtItemCd.Text) = "" Then
            MsgBox "�������ڃR�[�h�����͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtItemCd.SetFocus
            Exit Do
        End If
        
        '�R�[�h�̃n�C�t���`�F�b�N
        If InStr(txtItemCd.Text, "-") > 0 Then
            MsgBox "�������ڃR�[�h�Ƀn�C�t�����܂߂邱�Ƃ͂ł��܂���B", vbExclamation, App.Title
            txtItemCd.SetFocus
            Exit Do
        End If
        
        '�˗����ڂ̑��݃`�F�b�N
        If GetItem_PInfo() = False Then
            MsgBox "�e�ƂȂ�˗����ڃ��R�[�h�����݂��܂���B�˗����ڃR�[�h��o�^���Ă��猟�����ڂ�o�^���Ă��������B", vbCritical, App.Title
            txtItemCd.SetFocus
            Exit Do
        End If
        
        '�T�t�B�b�N�X�֘A
        If Trim(txtSuffix.Text) = "" Then
            MsgBox "�T�t�B�b�N�X�����͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtSuffix.SetFocus
            Exit Do
        End If
        
        '�R�[�h�̃n�C�t���`�F�b�N
        If InStr(txtSuffix.Text, "-") > 0 Then
            MsgBox "�T�t�B�b�N�X�Ƀn�C�t�����܂߂邱�Ƃ͂ł��܂���B", vbExclamation, App.Title
            txtSuffix.SetFocus
            Exit Do
        End If
        
        If IsNumeric(txtSuffix.Text) = False Then
            MsgBox "�T�t�B�b�N�X�ɂ͐��l����͂��Ă��������B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtSuffix.SetFocus
            Exit Do
        Else
            txtSuffix.Text = Format(txtSuffix.Text, "00")
        End If

        '�������ږ�
        If Trim(txtItemName.Text) = "" Then
            MsgBox "�������ږ������͂���Ă��܂���B", vbExclamation, App.Title
            tabMain.Tab = 0
            txtItemName.SetFocus
            Exit Do
        End If

        '���́i�Ȃ�������˂����ށj
        If Trim(txtItemSName.Text) = "" Then
            txtItemSName.Text = Mid(txtItemName.Text, 1, 5)
        End If

        '�񍐏����i�Ȃ�������˂����ށj
        If Trim(txtItemRName.Text) = "" Then
            txtItemRName.Text = txtItemName.Text
        End If

        '��f�p���ږ��i�Ȃ�������˂����ށj
        If (Trim(txtItemQName.Text) = "") And (mintRslQue = RSLQUE_Q) Then
            txtItemQName.Text = txtItemName.Text
        End If

        '�����p���ڃR�[�h�̑��݃`�F�b�N
        For Each objItemHistory In mcolItemHistory
            
            strInsItemCd = objItemHistory.InsItemCd
            strSepOrderDiv = objItemHistory.SepOrderDiv
            
            If GetInsItemInfo(txtItemCd.Text, txtSuffix.Text, strInsItemCd, strSepOrderDiv) = False Then
                tabMain.Tab = 1
                Exit Do
            End If

        Next objItemHistory
        
        Ret = True
        Exit Do
    
    Loop
    
    '�߂�l�̐ݒ�
    CheckValue = Ret
    
End Function

'
' �@�\�@�@ : �˗����ڏ�񌟍�
'
' �����@�@ : �Ȃ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' ���l�@�@ :
'
Private Function GetItem_PInfo() As Boolean

    Dim objItem_P       As Object          '�˗����ڃA�N�Z�X�p
    Dim vntRequestName  As Variant         '�������ږ���
    Dim vntRslQue       As Variant         '���ʖ�f�t���O
    
    Dim Ret             As Boolean          '�߂�l
    Dim i               As Integer
    
    On Error GoTo ErrorHandle
    
    GetItem_PInfo = False
    Ret = False

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem_P = CreateObject("HainsItem.Item")
    
    Do
        
        '�˗����ڃe�[�u�����R�[�h�ǂݍ���
        If objItem_P.SelectItem_P(txtItemCd.Text, _
                                  vntRequestName, _
                                  vntRslQue) = False Then
            Exit Do
        End If
        
        mintRslQue = CInt(vntRslQue)
        Ret = True
        Exit Do
    
    Loop
    
    '�߂�l�̐ݒ�
    GetItem_PInfo = Ret
    
    Exit Function

ErrorHandle:

    GetItem_PInfo = False
    MsgBox Err.Description, vbCritical
    
End Function


' @(e)
'
' �@�\�@�@ : ��{�������ڏ���ʕ\��
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ڂ̊�{������ʂɕ\������
'
' ���l�@�@ :
'
Private Function EditItem_c() As Boolean

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
    Dim vntItemSName        As Variant              '
    Dim vntItemRName        As Variant              '
    Dim vntSearchChar       As Variant              '
    Dim vntStcItemCd        As Variant              '
    Dim vntStcItemName      As Variant              '
    Dim vntRecentCount      As Variant              '
    Dim vntItemQName        As Variant              '
    Dim vntCollectCd        As Variant              '
    Dim vntContractCd       As Variant              '
    Dim vntContractItemCd   As Variant              '
    Dim vntOldItemCd        As Variant              '
    Dim vntNoPrintFlg       As Variant              '
    
'## 2003.02.05 Add 6Lines By H.Ishihara@FSIT ���̃��x���֌W�̕ϐ��ǉ�
    Dim vntCollectTubeCd    As Variant              '�̎�ǃR�[�h
    Dim vntMaterials        As Variant              '�ޗ��R�[�h
    Dim vntLabelMark        As Variant              '�}�[�N
    Dim vntWsCd             As Variant              '�v�r�R�[�h
    Dim vntLoadCd1          As Variant              '���׃R�[�h�P
    Dim vntLoadCd2          As Variant              '���׃R�[�h�Q
'## 2003.02.05 Add End

'### 2004/1/15 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
    Dim vntCuTargetFlg      As Variant              'CU�o�N�ω��\���Ώ�
    Dim vntOrderDiv         As Variant              '�I�[�_���
    Dim vntBuiCode          As Variant              '���ʃR�[�h
    Dim vntExplanation      As Variant              '���ڐ���
'### 2004/1/15 Added End

'### 2004/1/29 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
    Dim vntHideInterview    As Variant              '�ʐډ�ʔ�\��
'### 2004/1/29 Added End

    Dim Ret         As Boolean              '�߂�l
    
    EditItem_c = False
    
    On Error GoTo ErrorHandle
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem = CreateObject("HainsItem.Item")
    
    Do
        '�����������w�肳��Ă��Ȃ��ꍇ�͉������Ȃ�
        If (mstrItemCd = "") Or (mstrSuffix = "") Then
        
            '�܂�V�K�Ȃ̂ŗ�����������Ⴄ
            Call AddNewHistory
            
            Ret = True
            Exit Do
        End If
        
        '�������ڃe�[�u�����R�[�h�ǂݍ���
'## 2003.11.23 Mod 1Line By H.Ishihara@FSIT ���H���s�v���ڂ̍폜
'        If objItem.SelectItemHeader(mstrItemCd, _
                                    mstrSuffix, _
                                    vntItemName, _
                                    vntitemEName, _
                                    vntClassName, _
                                    vntRslQue, _
                                    vntRslqueName, _
                                    vntItemType, _
                                    vntItemTypeName, _
                                    vntResultType, _
                                    vntResultTypeName, _
                                    vntItemSName, _
                                    vntItemRName, _
                                    vntSearchChar, _
                                    vntStcItemCd, _
                                    vntStcItemName, _
                                    vntRecentCount, _
                                    vntItemQName, _
                                    vntCollectCd, _
                                    vntContractCd, _
                                    vntContractItemCd, _
                                    vntOldItemCd, _
                                    , vntNoPrintFlg _
                                    ) = False Then
'### 2004/1/15 Modified by Ishihara@FSIT ���H�����ڂ̒ǉ�
'### 2004/1/29 Modified by Ishihara@FSIT ���H�����ڂ̒ǉ�
'        If objItem.SelectItemHeader(mstrItemCd, mstrSuffix, _
                                    vntItemName, vntitemEName, _
                                    vntClassName, vntRslQue, _
                                    vntRslqueName, vntItemType, _
                                    vntItemTypeName, vntResultType, _
                                    vntResultTypeName, vntItemSName, _
                                    vntItemRName, vntSearchChar, _
                                    vntStcItemCd, vntStcItemName, _
                                    vntRecentCount, vntItemQName, _
                                    vntCollectCd, vntContractCd, _
                                    vntContractItemCd, vntOldItemCd, _
                                    , vntNoPrintFlg, vntCollectTubeCd, vntMaterials, vntLabelMark, vntWsCd, _
                                    vntLoadCd1, vntLoadCd2, _
                                    vntCuTargetFlg, vntOrderDiv, vntBuiCode, vntExplanation) = False Then
        If objItem.SelectItemHeader(mstrItemCd, mstrSuffix, _
                                    vntItemName, vntitemEName, _
                                    vntClassName, vntRslQue, _
                                    vntRslqueName, vntItemType, _
                                    vntItemTypeName, vntResultType, _
                                    vntResultTypeName, vntItemSName, _
                                    vntItemRName, vntSearchChar, _
                                    vntStcItemCd, vntStcItemName, _
                                    vntRecentCount, vntItemQName, _
                                    vntCollectCd, vntContractCd, _
                                    vntContractItemCd, vntOldItemCd, _
                                    , vntNoPrintFlg, vntCollectTubeCd, vntMaterials, vntLabelMark, vntWsCd, _
                                    vntLoadCd1, vntLoadCd2, _
                                    vntCuTargetFlg, vntOrderDiv, vntBuiCode, vntExplanation, vntHideInterview) = False Then
'### 2004/1/29 Modified End
'### 2004/1/15 Modified by Ishihara@FSIT ���H�����ڂ̒ǉ�
'## 2003.02.05 Mod End
            MsgBox "�����𖞂������R�[�h�����݂��܂���B", vbCritical, App.Title
            Exit Do
        End If


'### 2004/1/15 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
        If vntCuTargetFlg = "1" Then chkCuTargetFlg.Value = vbChecked
        txtOrderDiv.Text = vntOrderDiv
        txtBuiCode.Text = vntBuiCode
        txtExplanation.Text = vntExplanation
'### 2004/1/15 Added end

        '�ǂݍ��ݓ��e�̕ҏW�i�������ڊ�{���j
        mintRslQue = CInt(vntRslQue)

        txtItemCd.Text = mstrItemCd
        txtSuffix.Text = mstrSuffix
        txtItemName.Text = vntItemName
        txtItemSName.Text = vntItemSName
        txtItemRName.Text = vntItemRName
        txtItemEName.Text = vntitemEName
        txtItemQName.Text = vntItemQName

        lblStcItemCd.Caption = vntStcItemCd & ":" & vntStcItemName

        '����������R���{�̐ݒ�
        For i = 0 To cboSearchChar.ListCount - 1
            If cboSearchChar.List(i) = vntSearchChar Then
                cboSearchChar.ListIndex = i
            End If
        Next i

        '�R���{�̐ݒ�i���l�Z�b�g�Őݒ肪����������́j
        cboResultType.ListIndex = CInt(vntResultType)
        cboItemType.ListIndex = CInt(vntItemType)

        '���̑��t�B�[���h�ւ̃Z�b�g
        txtCollectCd.Text = vntCollectCd
        txtContractCd.Text = vntContractCd
        txtContractItemCd.Text = vntContractItemCd
        txtOldItemCd.Text = vntOldItemCd
    
'## 2003.02.05 Add 6Lines By H.Ishihara@FSIT ���̃��x���֌W�̕ϐ��ǉ�
        txtCollectTubeCd.Text = vntCollectTubeCd
        txtMaterials.Text = vntMaterials
        txtLabelMark.Text = vntLabelMark
        txtWsCd.Text = vntWsCd
        txtLoadCd1.Text = vntLoadCd1
        txtLoadCd2.Text = vntLoadCd2
'## 2003.02.05 Add End
    
'### 2004/1/29 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
        chkHideInterview.Value = IIf(vntHideInterview = "1", vbChecked, vbUnchecked)
'### 2004/1/29 Added End
    
'## 2002.11.10 Add 5Lines By H.Ishihara@FSIT �񍐏����o�̓t���O�Ή�
        If Trim(vntNoPrintFlg) = ITEM_NOPRINT Then
            chkNoPrintFlg.Value = vbChecked
        Else
            chkNoPrintFlg.Value = vbUnchecked
        End If
'## 2002.11.10 Add End
    
        '���̓^�u�t�B�[���h
        mstrStcItemCd = vntStcItemCd
        cboRecentCount.ListIndex = CInt(vntRecentCount)
        
        '�Q�Ɛ�ƃR�[�h�������Ȃ�
        optStcMySelf(1).Value = Not (vntStcItemCd = mstrItemCd)
        
        Ret = True
        Exit Do
    Loop
    
    '�߂�l�̐ݒ�
    EditItem_c = Ret
    
    Exit Function

ErrorHandle:

    EditItem_c = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' �@�\�@�@ : �������ڊ�{���̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e���������ڃe�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistItem_c() As Boolean

On Error GoTo ErrorHandle

    Dim objItem_c           As Object       '�������ڃA�N�Z�X�p
    Dim lngRet              As Long
    Dim strSearchChar       As String
    
    '�����f�[�^
    Dim intItemCount        As Integer
    Dim vntItemHNo()        As Variant
    Dim vntStrDate()        As Variant
    Dim vntEndDate()        As Variant
    Dim vntFigure1()        As Variant
    Dim vntFigure2()        As Variant
    Dim vntMaxValue()       As Variant
    Dim vntMinValue()       As Variant
    Dim vntInsItemCd()      As Variant
    Dim vntUnit()           As Variant
    Dim vntDefResult()      As Variant
    Dim vntDefRslCmtCd()    As Variant
    Dim vntReqItemCd()      As Variant
    Dim vntSepOrderDiv()    As Variant
'### 2004/1/15 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
    Dim vntInsSuffix()      As Variant
    Dim vntEUnit()          As Variant
'### 2004/1/15 Added End
    
    '�J���e�f�[�^
    Dim intkarteItemCount   As Integer
    Dim vntKarteItemHNo()   As Variant
    Dim vntKarteDocCd()     As Variant
    Dim vntKarteItemAttr()  As Variant
    Dim vntKarteItemcd()    As Variant
    Dim vntKarteItemName()  As Variant
    Dim vntKarteTagName()   As Variant
    
    Dim i                   As Integer
    Dim j                   As Integer
    
    Dim objItemHistory      As ItemHistory
    Dim objKarteItem        As KarteItem
    Dim strEscItemHNo       As String
    
    Dim objLocalCommon      As LocalCommon.Common
    
    RegistItem_c = False

    '�K�C�h����������̍ĕҏW
    strSearchChar = cboSearchChar.List(cboSearchChar.ListIndex)
    If strSearchChar = "���̑�" Then
        strSearchChar = "*"
    End If

    i = 0
    j = 0
    intItemCount = mcolItemHistory.Count
    intkarteItemCount = mcolKarteItem.Count
    
    '�����Ǘ��e�[�u���p�f�[�^�ҏW
    For Each objItemHistory In mcolItemHistory
    
        ReDim Preserve vntItemHNo(i)
        ReDim Preserve vntStrDate(i)
        ReDim Preserve vntEndDate(i)
        ReDim Preserve vntFigure1(i)
        ReDim Preserve vntFigure2(i)
        ReDim Preserve vntMaxValue(i)
        ReDim Preserve vntMinValue(i)
        ReDim Preserve vntInsItemCd(i)
        
        ReDim Preserve vntUnit(i)
        ReDim Preserve vntDefResult(i)
        ReDim Preserve vntDefRslCmtCd(i)
        ReDim Preserve vntReqItemCd(i)
        ReDim Preserve vntSepOrderDiv(i)
'### 2004/1/15 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
        ReDim Preserve vntInsSuffix(i)
        ReDim Preserve vntEUnit(i)
'### 2004/1/15 Added End
    
        With objItemHistory
            
            '�d�J���R���N�V�����Ƃ̐������𓝈ꂷ�邽�ߗ���No�̂ݑޔ��i�V�K���̗���ԍ��j
            strEscItemHNo = .ItemHNo
            
            .ItemHNo = i
            vntItemHNo(i) = i
            vntStrDate(i) = .strDate
            vntEndDate(i) = .endDate
            vntFigure1(i) = .Figure1
            vntFigure2(i) = .Figure2
            vntMaxValue(i) = .MaxValue
            vntMinValue(i) = .MinValue
            vntInsItemCd(i) = .InsItemCd
            vntUnit(i) = .Unit
            vntDefResult(i) = .DefResult
            vntDefRslCmtCd(i) = .DefRslCmtCd
            vntReqItemCd(i) = .ReqItemCd
            vntSepOrderDiv(i) = .SepOrderDiv
        
'### 2004/1/15 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
            vntInsSuffix(i) = .InsSuffix
            vntEUnit(i) = .eUnit
'### 2004/1/15 Added End
        
        End With
            
        '�d�J���R���N�V�����̃f�[�^�Z�b�g
        For Each objKarteItem In mcolKarteItem
            If objKarteItem.ItemHNo = strEscItemHNo Then
                
                With objKarteItem
                    .ItemHNo = i
            
                    ReDim Preserve vntKarteItemHNo(j)
                    ReDim Preserve vntKarteDocCd(j)
                    ReDim Preserve vntKarteItemAttr(j)
                    ReDim Preserve vntKarteItemcd(j)
                    ReDim Preserve vntKarteItemName(j)
                    ReDim Preserve vntKarteTagName(j)
                
                    vntKarteItemHNo(j) = .ItemHNo
                    vntKarteDocCd(j) = .KarteDocCd
                    vntKarteItemAttr(j) = .KarteItemAttr
                    vntKarteItemcd(j) = .KarteItemcd
                    vntKarteItemName(j) = .KarteItemName
                    vntKarteTagName(j) = .KarteTagName
                
                End With
                j = j + 1
            
            End If
        Next objKarteItem
        
        i = i + 1
    Next objItemHistory

    '�����̏d���`�F�b�N
    Set objLocalCommon = New LocalCommon.Common
    If objLocalCommon.CheckHistoryDuplicate(intItemCount, vntStrDate, vntEndDate) = False Then
        MsgBox "���t���d�����Ă��闚�������݂��܂��B����ݒ���ē��͂��Ă��������B", vbExclamation
        tabMain.Tab = 1
        cboHistory.SetFocus
        Exit Function
    End If

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem_c = CreateObject("HainsItem.Item")

    '�������ڃe�[�u�����R�[�h�̓o�^
'## 2003.11.23 Deleted By H.Ishihara@FSIT ���H���s�v���ڂ̍폜
'    lngRet = objItem_c.RegistItem_c_all(IIf(txtItemCd.Enabled, "INS", "UPD"), Trim(txtItemCd.Text), _
                                    Trim(txtSuffix.Text), cboResultType.ListIndex, _
                                    cboItemType.ListIndex, Trim(txtItemName.Text), _
                                    Trim(txtItemSName.Text), Trim(txtItemRName.Text), _
                                    strSearchChar, IIf(optStcMySelf(0).Value = True, _
                                    Trim(txtItemCd.Text), mstrStcItemCd), _
                                    cboRecentCount.ListIndex, Trim(txtItemEName.Text), _
                                    Trim(txtItemQName.Text), Trim(txtCollectCd.Text), _
                                    Trim(txtContractCd.Text), Trim(txtContractItemCd.Text), _
                                    Trim(txtOldItemCd.Text), IIf(chkNoPrintFlg.Value = Checked, "1", ""), _
                                    mblnEditItemHistory, intItemCount, _
                                    vntItemHNo, vntStrDate, _
                                    vntEndDate, vntFigure1, _
                                    vntFigure2, vntMaxValue, _
                                    vntMinValue, vntInsItemCd, _
                                    vntUnit, vntDefResult, _
                                    vntDefRslCmtCd, _
                                    intkarteItemCount, vntKarteItemHNo, _
                                    vntKarteDocCd, vntKarteItemAttr, _
                                    vntKarteItemcd, vntKarteItemName, _
                                    vntKarteTagName, vntReqItemCd, vntSepOrderDiv, _
                                    Trim(txtCollectTubeCd.Text), Trim(txtMaterials.Text), Trim(txtLabelMark.Text), Trim(txtWsCd.Text), Trim(txtLoadCd1.Text), Trim(txtLoadCd2.Text))
'### 2004/1/15 Modified by Ishihara@FSIT ���H�����ڂ̒ǉ�
'    lngRet = objItem_c.RegistItem_c_all(IIf(txtItemCd.Enabled, "INS", "UPD"), Trim(txtItemCd.Text), _
                                    Trim(txtSuffix.Text), cboResultType.ListIndex, _
                                    cboItemType.ListIndex, Trim(txtItemName.Text), _
                                    Trim(txtItemSName.Text), Trim(txtItemRName.Text), _
                                    strSearchChar, IIf(optStcMySelf(0).Value = True, Trim(txtItemCd.Text), mstrStcItemCd), _
                                    cboRecentCount.ListIndex, Trim(txtItemEName.Text), _
                                    Trim(txtItemQName.Text), Trim(txtCollectCd.Text), _
                                    Trim(txtContractCd.Text), Trim(txtContractItemCd.Text), _
                                    Trim(txtOldItemCd.Text), IIf(chkNoPrintFlg.Value = Checked, "1", ""), _
                                    mblnEditItemHistory, intItemCount, _
                                    vntItemHNo, vntStrDate, _
                                    vntEndDate, vntFigure1, _
                                    vntFigure2, vntMaxValue, _
                                    vntMinValue, vntInsItemCd, _
                                    vntUnit, vntDefResult, _
                                    vntDefRslCmtCd, _
                                    vntReqItemCd)
'### 2004/1/29 Modified by Ishihara@FSIT ���H�����ڂ̒ǉ�
'    lngRet = objItem_c.RegistItem_c_all(IIf(txtItemCd.Enabled, "INS", "UPD"), Trim(txtItemCd.Text), _
                                    Trim(txtSuffix.Text), cboResultType.ListIndex, _
                                    cboItemType.ListIndex, Trim(txtItemName.Text), _
                                    Trim(txtItemSName.Text), Trim(txtItemRName.Text), _
                                    strSearchChar, IIf(optStcMySelf(0).Value = True, Trim(txtItemCd.Text), mstrStcItemCd), _
                                    cboRecentCount.ListIndex, Trim(txtItemEName.Text), _
                                    Trim(txtItemQName.Text), Trim(txtCollectCd.Text), _
                                    Trim(txtContractCd.Text), Trim(txtContractItemCd.Text), _
                                    Trim(txtOldItemCd.Text), IIf(chkNoPrintFlg.Value = Checked, "1", ""), _
                                    mblnEditItemHistory, intItemCount, _
                                    vntItemHNo, vntStrDate, _
                                    vntEndDate, vntFigure1, _
                                    vntFigure2, vntMaxValue, _
                                    vntMinValue, vntInsItemCd, _
                                    vntUnit, vntDefResult, _
                                    vntDefRslCmtCd, _
                                    vntReqItemCd, _
                                    Trim(txtMaterials.Text), IIf(chkCuTargetFlg.Value = vbChecked, 1, 0), Trim(txtOrderDiv.Text), _
                                    Trim(txtBuiCode.Text), Trim(txtExplanation.Text), _
                                    vntInsSuffix, vntEUnit)
    lngRet = objItem_c.RegistItem_c_all(IIf(txtItemCd.Enabled, "INS", "UPD"), Trim(txtItemCd.Text), _
                                    Trim(txtSuffix.Text), cboResultType.ListIndex, _
                                    cboItemType.ListIndex, Trim(txtItemName.Text), _
                                    Trim(txtItemSName.Text), Trim(txtItemRName.Text), _
                                    strSearchChar, IIf(optStcMySelf(0).Value = True, Trim(txtItemCd.Text), mstrStcItemCd), _
                                    cboRecentCount.ListIndex, Trim(txtItemEName.Text), _
                                    Trim(txtItemQName.Text), Trim(txtCollectCd.Text), _
                                    Trim(txtContractCd.Text), Trim(txtContractItemCd.Text), _
                                    Trim(txtOldItemCd.Text), IIf(chkNoPrintFlg.Value = Checked, "1", ""), _
                                    mblnEditItemHistory, intItemCount, _
                                    vntItemHNo, vntStrDate, _
                                    vntEndDate, vntFigure1, _
                                    vntFigure2, vntMaxValue, _
                                    vntMinValue, vntInsItemCd, _
                                    vntUnit, vntDefResult, _
                                    vntDefRslCmtCd, _
                                    vntReqItemCd, _
                                    Trim(txtMaterials.Text), IIf(chkCuTargetFlg.Value = vbChecked, 1, 0), Trim(txtOrderDiv.Text), _
                                    Trim(txtBuiCode.Text), Trim(txtExplanation.Text), _
                                    vntInsSuffix, vntEUnit, IIf(chkHideInterview.Value = vbChecked, 1, 0))
'### 2004/1/15 Modified End

    Select Case lngRet
        
        '�߂�l���G���[�̏ꍇ
        Case INSERT_ERROR
            MsgBox "�f�[�^�ۑ����ɃG���[���������܂����B", vbExclamation
            Exit Function
        
        '�߂�l���_�u������̏ꍇ
        Case INSERT_DUPLICATE
            MsgBox "���͂��ꂽ�������ڃR�[�h�͊��ɑ��݂��܂��B", vbExclamation
            Exit Function
        
        '�߂�l�������_�u������̏ꍇ
        Case INSERT_HISTORYDUPLICATE
            MsgBox "���t���d�����Ă��闚�������݂��܂��B����ݒ���ē��͂��Ă��������B", vbExclamation
            tabMain.Tab = 1
            cboHistory.SetFocus
            Exit Function
    
    End Select
    
    mstrItemCd = Trim(txtItemCd.Text)
    mstrSuffix = Trim(txtSuffix.Text)
    
    txtItemCd.Enabled = (txtItemCd.Text = "")
    txtSuffix.Enabled = (txtSuffix.Text = "")
    
    RegistItem_c = True
    
    Exit Function
    
ErrorHandle:

    RegistItem_c = False
    
    MsgBox Err.Description, vbCritical
    
End Function

Public Function CheckHistoryDuplicate(intItemCount As Integer, _
                                      vntStrDate As Variant, _
                                      vntEndDate As Variant) As Boolean

    Dim i   As Integer
    Dim j   As Integer

    CheckHistoryDuplicate = False
    
    '�����Ǘ������������݂��Ȃ��Ȃ珈���I��
    If intItemCount < 2 Then
        CheckHistoryDuplicate = True
        Exit Function
    End If
    
    '�������ڐ���Loop
    For i = 0 To intItemCount - 1
        j = i + 1
        
        '���݈ʒu�{�P���猟��
        For j = i + 1 To intItemCount - 1
        
            '�J�n���t�̏d���`�F�b�N
            If (CDate(vntStrDate(i) >= vntStrDate(j))) And (CDate(vntStrDate(i) <= vntEndDate(j))) Then
                Exit Function
            End If
    
            '�I�����t�̏d���`�F�b�N
            If (CDate(vntEndDate(i) >= vntStrDate(j))) And (CDate(vntEndDate(i) <= vntEndDate(j))) Then
                Exit Function
            End If
    
        Next j
    Next i
        
    CheckHistoryDuplicate = True

End Function

' @(e)
'
' �@�\�@�@ : �������ڗ������̕ۑ�
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : ���͓��e���������ڗ����Ǘ��e�[�u���ɕۑ�����B
'
' ���l�@�@ :
'
Private Function RegistItemHistory() As Boolean

On Error GoTo ErrorHandle

    Dim objItem             As Object       '�������ڃA�N�Z�X�p
    Dim lngRet              As Long
    
    Dim intItemCount        As Integer
    Dim vntItemHNo()        As Variant
    Dim vntStrDate()        As Variant
    Dim vntEndDate()        As Variant
    Dim vntFigure1()        As Variant
    Dim vntFigure2()        As Variant
    Dim vntMaxValue()       As Variant
    Dim vntMinValue()       As Variant
    Dim vntInsItemCd()      As Variant
    Dim vntKarteItemcd()    As Variant
    Dim vntKarteItemName()  As Variant
    Dim vntKarteItemAttr()  As Variant
    Dim vntKarteDocCd()     As Variant
    Dim vntUnit()           As Variant
    Dim vntDefResult()      As Variant
    Dim vntDefRslCmtCd()    As Variant
    
    Dim objItemHistory      As ItemHistory
    Dim i                   As Integer
    
    RegistItemHistory = False

    intItemCount = mcolItemHistory.Count
    i = 0
    
    For Each objItemHistory In mcolItemHistory
    
        ReDim Preserve vntItemHNo(i)
        ReDim Preserve vntStrDate(i)
        ReDim Preserve vntEndDate(i)
        ReDim Preserve vntFigure1(i)
        ReDim Preserve vntFigure2(i)
        ReDim Preserve vntMaxValue(i)
        ReDim Preserve vntMinValue(i)
        ReDim Preserve vntInsItemCd(i)
        ReDim Preserve vntKarteItemcd(i)
        ReDim Preserve vntKarteItemName(i)
        ReDim Preserve vntKarteItemAttr(i)
        ReDim Preserve vntKarteDocCd(i)
        ReDim Preserve vntUnit(i)
        ReDim Preserve vntDefResult(i)
        ReDim Preserve vntDefRslCmtCd(i)
    
        With objItemHistory
            vntItemHNo(i) = i + 1
            vntStrDate(i) = .strDate
            vntEndDate(i) = .endDate
            vntFigure1(i) = .Figure1
            vntFigure2(i) = .Figure2
            vntMaxValue(i) = .MaxValue
            vntMinValue(i) = .MinValue
            vntInsItemCd(i) = .InsItemCd
'            vntKarteItemcd(i) = .KarteItemcd
'            vntKarteItemName(i) = .KarteItemName
'            vntKarteItemAttr(i) = .KarteItemAttr
'            vntKarteDocCd(i) = .KarteDocCd
            vntUnit(i) = .Unit
            vntDefResult(i) = .DefResult
            vntDefRslCmtCd(i) = .DefRslCmtCd
        End With
        
        i = i + 1
    Next objItemHistory

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem = CreateObject("HainsItem.Item")

    '�������ڃe�[�u�����R�[�h�̓o�^
    lngRet = objItem.RegistItemHistory(mstrItemCd, _
                                       mstrSuffix, _
                                       intItemCount, _
                                       vntItemHNo, _
                                       vntStrDate, _
                                       vntEndDate, _
                                       vntFigure1, _
                                       vntFigure2, _
                                       vntMaxValue, _
                                       vntMinValue, _
                                       vntInsItemCd, _
                                       vntKarteItemcd, _
                                       vntKarteItemName, _
                                       vntKarteItemAttr, _
                                       vntKarteDocCd, _
                                       vntUnit, _
                                       vntDefResult, _
                                       vntDefRslCmtCd)
    
    '�߂�l���_�u������̏ꍇ
    If lngRet = INSERT_DUPLICATE Then
        MsgBox "���͂��ꂽ�������ڃR�[�h�͊��ɑ��݂��܂��B", vbExclamation
        Exit Function
    End If
    
    mstrItemCd = Trim(txtItemCd.Text)
    mstrSuffix = Trim(txtSuffix.Text)
    
    txtItemCd.Enabled = (txtItemCd.Text = "")
    txtSuffix.Enabled = (txtSuffix.Text = "")
    
    RegistItemHistory = True
    
    Exit Function
    
ErrorHandle:

    RegistItemHistory = False
    
    MsgBox Err.Description, vbCritical
    
End Function


' @(e)
'
' �@�\�@�@ : �u�������ڗ����R���{�vClick
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
    
    '��f�������ڂ̕\��
    Call EditItemHistoryFromCollection

    '���X�V��Ԃɏ�����
'    mblnEditItemHistory = False

End Sub

Private Sub cboItemType_Click()

    '�Ǘ����Ă��镶�͈ꗗ��\������
    Call EditSentenceList(mstrStcItemCd)

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
Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' �@�\�@�@ : �������ڗ����폜�{�^��
'
' �@�\���� : �������ڗ����f�[�^���폜����
'
' ���l�@�@ :
'
Private Sub cmdDeleteHistory_Click()

    Dim objTargetItemHistory    As ItemHistory
    Dim strTargetItemHNo        As String
    Dim objKarteItem            As KarteItem
    
    strTargetItemHNo = mcolItemHistory(mstrItemHistoryKey(cboHistory.ListIndex)).ItemHNo
    
    For Each objKarteItem In mcolKarteItem
        If objKarteItem.ItemHNo = strTargetItemHNo Then
            mcolKarteItem.Remove objKarteItem.UniqueKey
        End If
    Next objKarteItem
    
    '�R���{�{�b�N�X�ɑΉ�����L�[�ŃR���N�V��������폜
    mcolItemHistory.Remove mstrItemHistoryKey(cboHistory.ListIndex)
    
    cboHistory.Clear
    Erase mstrItemHistoryKey
    
    '�R���{�{�b�N�X�ƑΉ��L�[�z����č\��
    For Each objTargetItemHistory In mcolItemHistory
        With objTargetItemHistory
            cboHistory.AddItem .strDate & "�`" & .endDate & "�ɓK�p����f�[�^"
            
            ReDim Preserve mstrItemHistoryKey(cboHistory.NewIndex)
            mstrItemHistoryKey(cboHistory.NewIndex) = objTargetItemHistory.UniqueKey
        End With
    
    Next objTargetItemHistory
    
    If cboHistory.ListCount <> 0 Then
        cboHistory.ListIndex = 0
    End If
            
    '��ʍĕ\��
    Call EditItemHistoryFromCollection
    
    '�������ڗ����t���O���X�V�ς݂ɕύX
    mblnEditItemHistory = True
    
    '�폜�{�^���g�p�ې���
    If cboHistory.ListCount < 2 Then
        cmdDeleteHistory.Enabled = False
    End If
    
End Sub

' @(e)
'
' �@�\�@�@ : �������ڗ����C���{�^��
'
' �@�\���� : �������ڗ����쐬�p�t�H�[���\��
'
' ���l�@�@ :
'
Private Sub cmdEditHistory_Click()
    
    '�C�����[�h�Ō������ڗ�����\��
    Call ShowItem_h(False)

End Sub

' @(e)
'
' �@�\�@�@ : �������ڗ���V�K�쐬�{�^��
'
' �@�\���� : �������ڗ����쐬�p�t�H�[���\��
'
' ���l�@�@ :
'
Private Sub cmdNewHistory_Click()

    '�V�K���[�h�Ō������ڗ�����\��
    Call ShowItem_h(True)
    
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


Private Sub cmdStcItemCd_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '���ڃK�C�h�\���p
    
    Dim i               As Long     '�C���f�b�N�X
    Dim strKey          As String   '�d���`�F�b�N�p�̃L�[
    Dim strItemString   As String
    Dim strItemKey      As String   '���X�g�r���[�p�A�C�e���L�[
    Dim strItemCdString As String   '�\���p�L�[�ҏW�̈�
    
    Dim lngItemCount    As Long     '�I�����ڐ�
    Dim vntItemCd       As Variant  '�I�����ꂽ���ڃR�[�h
    Dim vntItemName     As Variant  '�I�����ꂽ���ږ�
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_REQUEST
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
        vntItemName = .ItemName
    
    End With

    '�I�����ꂽ����Ȃ�l���Z�b�g
    If lngItemCount > 0 Then
        
        mstrStcItemCd = vntItemCd(0)
        lblStcItemCd.Caption = vntItemCd(0) & "�F" & vntItemName(0)
        
        '�Ǘ����Ă��镶�͈ꗗ��\������
        Call EditSentenceList(mstrStcItemCd)
    
    End If

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
    mintColKey = 0
    mintKarteColKey = 0
    
    '��ʏ�����
    Call InitializeForm

    Do
        
        '�I�u�W�F�N�g�R���N�V�����쐬�i�V�K�쐬�����l�����A�����ō쐬�j
        Set mcolItemHistory = Nothing
        Set mcolKarteItem = Nothing
        Set mcolItemHistory = New Collection
        Set mcolKarteItem = New Collection
        
        '�������ڏ��̕\���ҏW
        If EditItem_c() = False Then
            Exit Do
        End If
    
        '�C�l�[�u���ݒ�
        txtItemCd.Enabled = (txtItemCd.Text = "")
        txtSuffix.Enabled = (txtSuffix.Text = "")
        
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
        
        '�������ڃe�[�u���̓o�^
        If RegistItem_c() = False Then Exit Do

        '�X�V�t���O��������
        mblnEditMain = False
        mblnEditItemHistory = False
        mblnEditOpe = False
        mblnEditJud = False
        
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
    mblnShowHistory = False
    mblnShowOpe = False
    mblnShowJud = False
    mblnShowGov = False
    
    '�X�V�`�F�b�N�p�t���O������
    mblnEditMain = False
    mblnEditItemHistory = False
    mblnEditOpe = False
    mblnEditJud = False
    
    '--- ���C���^�u
    '����������R���{������
    Call InitSearchCharCombo(cboSearchChar)
    
    '���ʃ^�C�v�p�R���{�ҏW
    With cboResultType
        .AddItem "0:���l���i�[���܂�"
        .AddItem "1:�萫�i�W���F-,+-,+�j���i�[���܂�"
        .AddItem "2:�萫�i�g���F-,+-,1+�`9+�j���i�[���܂�"
        .AddItem "3:���ʓ��e���Œ肵�܂���i�t���[�j"
        .AddItem "4:���͌��ʂ��i�[���܂�"
        .AddItem "5:�v�Z���ڂł�"
        .AddItem "6:���t���i�[���܂�"
        
'### 2003/11/19 Added by Ishihara@FSIT ���H����p�ǉ�
        .AddItem "7:�����^�C�v���i�[���܂�"
        .AddItem "8:�������������i�[���܂�"
'### 2003/11/19 Added End
        
        .ListIndex = 0
    End With
    
    '���ڃ^�C�v�p�R���{�ҏW
    With cboItemType
        .AddItem "0:�W��"
        .AddItem "1:���̍��ڂ́u���ʁv��\���܂�"
        .AddItem "2:���̍��ڂ́u�����v��\���܂�"
        .AddItem "3:���̍��ڂ́u���u�v��\���܂�"
        .ListIndex = 0
    End With
    
    '�ŋߎg�������͊Ǘ���
    With cboRecentCount
        For i = 0 To 9
            .AddItem i & "��"
        Next i
        .ListIndex = 0
    End With
    
    '--- �������ڃ^�u
    cmdEditHistory.Enabled = False
    cmdDeleteHistory.Enabled = False
    
    '--- ���̓^�u
'    optStcMySelf_Click (0)
    
'## 2003.03.13 Add 5Lines By H.Ishihara@FSIT �񍐏����o�̓t���O�̓f�t�H���g��ON
    '�񍐏����o�̓t���O�̓f�t�H���g��ON
    chkNoPrintFlg.Value = vbChecked
'## 2003.03.13 Add End
    
End Sub

' @(e)
'
' �@�\�@�@ : ���͎Q�Ɛ�ݒ�I�v�V�����{�^���N���b�N
'
' �@�\���� : �Q�Ɨp�R���g���[���̎g�p�ۏ�Ԃ𐧌䂷��
'
' ���l�@�@ :
'
Private Sub optStcMySelf_Click(Index As Integer)

    Dim strItemCd   As String

    If Index = 0 Then
        '�Q�ƂȂ�
        cmdStcItemCd.Enabled = False
        lblStcItemCd.ForeColor = vbGrayText
        
        strItemCd = txtItemCd.Text
        
        '�Q�Ɛ敶�̓R�[�h�������ɐݒ�
'        mstrStcItemCd = txtItemCd.Text
    
    Else
        '�Q�Ƃ���
        cmdStcItemCd.Enabled = True
        lblStcItemCd.ForeColor = vbButtonText
    
        '�Q�Ɛ�R�[�h�����݂̌������ڃR�[�h�ƈႤ�ꍇ�̂ݕ��͈ꗗ��\��
'        If txtItemCd.Text <> mstrStcItemCd Then
'            Call EditSentenceList
'        End If
    
        strItemCd = mstrStcItemCd
    
    End If
    

        '�Ǘ����Ă��镶�͈ꗗ��\������
        Call EditSentenceList(strItemCd)
    
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

    '�N���b�N���ꂽ�^�u�ɉ����ď������s
    Select Case tabMain.Tab
        Case 1
            '�����Ǘ��^�u
            Call EditHistoryTab
        Case 3
            '���͌��ʕ\���^�u
            Call CntlSentenceTab(cboResultType.ListIndex = RESULTTYPE_SENTENCE)
    End Select
    
End Sub


' @(e)
'
' �@�\�@�@ : �������ڗ����f�[�^�Z�b�g
'
' �߂�l�@ : TRUE:����I���AFALSE:�ُ�I��
'
' �@�\���� : �������ڂɑ��݂��闚���f�[�^��\������
'
' ���l�@�@ :
'
Private Function EditItemHistory() As Boolean

    Dim objItem_c           As Object           '�������ڃA�N�Z�X�p
    Dim objItemHistory      As ItemHistory      '�������ڗ����f�[�^�i�[�p�I�u�W�F�N�g
    Dim objKarteItem        As KarteItem        '�d�J���ϊ��p�f�[�^�i�[�p�I�u�W�F�N�g
    
    '�������ڗ����f�[�^
    Dim vntHistoryCount     As Variant          '����
    Dim vntItemHNo          As Variant          '�������ڗ����m��
    Dim vntStrDate          As Variant          '�g�p�J�n���t
    Dim vntEndDate          As Variant          '�g�p�I�����t
    Dim vntFigure1          As Variant          '����������
    Dim vntFigure2          As Variant          '����������
    Dim vntMaxValue         As Variant          '�ő�l
    Dim vntMinValue         As Variant          '�ŏ��l
    Dim vntInsItemCd        As Variant          '�����p���ڃR�[�h
    Dim vntUnit             As Variant          '�P��
    Dim vntDefResult        As Variant          '�ȗ�����������
    Dim vntDefRslCmtCd      As Variant          '�ȗ������ʃR�����g�R�[�h
    Dim vntReqItemCd        As Variant
'## 2003.11.23 Deleted By H.Ishihara@FSIT ���H���s�v���ڂ̍폜
'    Dim vntSepOrderDiv      As Variant
'## 2003.11.23 Deleted By H.Ishihara@FSIT ���H���s�v���ڂ̍폜

    '�d�q�J���e�p���ڕϊ��f�[�^
'    Dim vntKarteItemHNo     As Variant          '�������ڗ����m��
    Dim vntKarteDocCd       As Variant          '�d�J���p������ʃR�[�h
    Dim vntKarteItemAttr    As Variant          '�d�J���p���ڑ���
    Dim vntKarteItemcd      As Variant          '�d�J���p���ڃR�[�h
    Dim vntKarteItemName    As Variant          '�d�J���p���ږ�
    Dim vntKarteTagName     As Variant          '�d�J���p�^�O����
    Dim lngKarteItemCount   As Long             '�d�J���p���ڐݒ萔

'### 2004/1/15 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
    Dim vntInsSuffix        As Variant          '�����p�T�t�B�b�N�X
    Dim vntEUnit            As Variant          '�p��P��
'### 2004/1/15 Added End

    Dim i           As Long             '�C���f�b�N�X
    Dim Ret         As Boolean
    
    EditItemHistory = False
'
'    '������
'    mintColKey = 0

    '�V�K�쐬���͏����I��
    If (mstrItemCd = "") Or (mstrSuffix = "") Then
        Exit Function
    End If

    '�R���{�{�b�N�X�N���A�[
    cboHistory.Clear
    
    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objItem_c = CreateObject("HainsItem.Item")
'## 2003.11.23 Modified By H.Ishihara@FSIT ���H���s�v���ڂ̍폜
'    Ret = objItem_c.SelectItemHistory(mstrItemCd, _
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
                                      vntDefRslCmtCd, _
                                      vntReqItemCd, _
                                      vntSepOrderDiv)
'### 2004/1/15 Modified by Ishihara@FSIT ���H�����ڂ̒ǉ�
'    Ret = objItem_c.SelectItemHistory(mstrItemCd, _
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
                                      vntDefRslCmtCd, _
                                      vntReqItemCd)
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
                                      vntDefRslCmtCd, _
                                      vntReqItemCd, vntInsSuffix, vntEUnit)
'### 2004/1/15 Modified End
'## 2003.11.23 Modified End

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
            .DefResult = vntDefResult(i)
            .DefRslCmtCd = vntDefRslCmtCd(i)
            .UniqueKey = mstrColKeyPrefix & i
            .ReqItemCd = vntReqItemCd(i)
'## 2003.11.23 Modified By H.Ishihara@FSIT ���H���s�v���ڂ̍폜
'            .SepOrderDiv = vntSepOrderDiv(i)

'### 2004/1/15 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
            .InsSuffix = vntInsSuffix(i)
            .eUnit = vntEUnit(i)
'### 2004/1/15 Added End
        
        End With
        mcolItemHistory.Add objItemHistory, mstrColKeyPrefix & i
        Set objItemHistory = Nothing
        
        '�R���N�V�����L�[�̑ޔ��i�R���{�{�b�N�X����̎Q�Ɨp�j
        ReDim Preserve mstrItemHistoryKey(i)
        mstrItemHistoryKey(i) = mstrColKeyPrefix & i
        
        '�R���{�̖��̒ǉ�
        cboHistory.AddItem CStr(vntStrDate(i)) & "�`" & CStr(vntEndDate(i)) & "�ɓK�p����f�[�^"
    
    Next i
    
    '�R���N�V�����L�[�̍ő�l�Ǘ��p
    mintColKey = i

    If CInt(vntHistoryCount) > 0 Then
        
        '�����f�[�^�����݂���Ȃ�A�R���{�I��
        cboHistory.ListIndex = 0
        
'### 2003.01.23 Modified by Ishihara@FSIT �d�J���֌W�Ȃ�
'        '�d�q�J���e���ڕϊ��f�[�^�̎擾
'        lngKarteItemCount = objItem_c.SelectKarteItemList(mstrItemCd, _
'                                                          mstrSuffix, _
'                                                          "", _
'                                                          vntItemHNo, _
'                                                          vntKarteDocCd, _
'                                                          vntKarteItemAttr, _
'                                                          vntKarteItemcd, _
'                                                          vntKarteItemName, _
'                                                          vntKarteTagName)
'
'        '�d�q�J���e���ڕϊ��f�[�^�̃I�u�W�F�N�g�Z�b�g
'        For i = 0 To lngKarteItemCount - 1
'
'            '�����I�u�W�F�N�g�i�R���N�V�����j�̍쐬
'            Set objKarteItem = New KarteItem
'            With objKarteItem
'                .ItemHNo = vntItemHNo(i)
'                .KarteDocCd = vntKarteDocCd(i)
'                .KarteItemAttr = vntKarteItemAttr(i)
'                .KarteItemcd = vntKarteItemcd(i)
'                .KarteItemName = vntKarteItemName(i)
'                .KarteTagName = vntKarteTagName(i)
'                .UniqueKey = mstrColKeyPrefix & i
'            End With
'
'            mcolKarteItem.Add objKarteItem, mstrColKeyPrefix & i
'            Set objKarteItem = Nothing
'
'        Next i
        i = 0
'### 2003.01.23 Modified End
        
        '�R���N�V�����L�[�̍ő�l�Ǘ��p
        mintKarteColKey = i

        '��f�������ڂ̕\��
        Call EditItemHistoryFromCollection
            
        '�������P�����Ȃ��Ƃ��͍폜�{�^���͖���
        If CInt(vntHistoryCount) = 1 Then
            cmdDeleteHistory.Enabled = False
        End If
        
        EditItemHistory = True
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
Private Sub EditHistoryTab()

    Dim blnStatus       As Boolean
    Dim blnCboStatus    As Boolean

    '�������t���O���X�V���ɕύX
    mblnNowEdit = True

    '�������ڗ����R���{�̐ݒ�i���߂ĕ\���A�������̓f�[�^�ύX������̂݁j
    If mblnShowHistory = False Then
        blnStatus = EditItemHistory()
    End If

    blnStatus = (cboHistory.ListCount > 0)

    '�R���g���[���̃C�l�[�u������i�����R���{�̗L���ɂ��ݒ�j
    cmdNewHistory.Enabled = (mstrItemCd <> "")
    cmdEditHistory.Enabled = blnStatus
    
    If cboHistory.ListCount < 2 Then
        cmdDeleteHistory.Enabled = False
    Else
        cmdDeleteHistory.Enabled = True
    End If
    
    '�������t���O�𖢏����ɕύX
    mblnNowEdit = False
    
    '�f�[�^�\���ς݂Ƃ��Ē�`
    mblnShowHistory = True
    
End Sub

' @(e)
'
' �@�\�@�@ : ���蕪�ރ^�u�N���b�N
'
' �@�\���� : �������ړ��Ǌ��̔��蕪�ނ�\������
'
' ���l�@�@ :
'
Private Sub EditJudClassTab()

    Dim objHeader       As ColumnHeaders        '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem             '���X�g�A�C�e���I�u�W�F�N�g

    '�������t���O���X�V���ɕύX
    mblnNowEdit = True

    '�������ڔ��蕪�ނ̕\���ҏW
'    Call EditListJud
    
    '�������t���O�𖢏����ɕύX
    mblnNowEdit = False
    
    '�f�[�^�\���ς݂Ƃ��Ē�`
    mblnShowJud = True
    
End Sub


' @(e)
'
' �@�\�@�@ : �������ڗ���ҏW�E�C���h�E�\��
'
' �����@�@ : (In)      modeNew  TRUE:�V�K���[�h�AFALSE:�X�V���[�h
'
' �@�\���� :
'
' ���l�@�@ :
'
Private Sub ShowItem_h(modeNew As Boolean)
    
    Dim objTargetItemHistory    As ItemHistory
    Dim objKarteItem            As KarteItem
    Dim colWork                 As Collection
    
    With frmItem_h
        
        .ItemInfo = txtItemCd.Text & "-" & txtSuffix.Text & "�F" & txtItemName.Text
        
        If modeNew = True Then
            
            '�V�K���[�h�̏ꍇ�A�f�t�H���g�l�Z�b�g
            Call AddNewHistory
        
        End If
            
        '�R���N�V��������ΏۃA�C�e���̒��o
        Set objTargetItemHistory = mcolItemHistory(mstrItemHistoryKey(cboHistory.ListIndex))
        
        .ItemCd = Trim(txtItemCd.Text)
        .Suffix = Trim(txtSuffix.Text)
        .ItemHNo = objTargetItemHistory.ItemHNo
        .ResultType = cboResultType.ListIndex
        .strDate = objTargetItemHistory.strDate
        .endDate = objTargetItemHistory.endDate
        .Figure1 = objTargetItemHistory.Figure1
        .Figure2 = objTargetItemHistory.Figure2
        .MaxValue = objTargetItemHistory.MaxValue
        .MinValue = objTargetItemHistory.MinValue
        .InsItemCd = objTargetItemHistory.InsItemCd
        .Unit = objTargetItemHistory.Unit
        .DefResult = objTargetItemHistory.DefResult
        .DefRslCmtCd = objTargetItemHistory.DefRslCmtCd
        .KarteItem = mcolKarteItem
        .KarteColKey = mintKarteColKey
        .ReqItemCd = objTargetItemHistory.ReqItemCd
        .SepOrderDiv = objTargetItemHistory.SepOrderDiv
'### 2004/1/15 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
        .InsSuffix = objTargetItemHistory.InsSuffix
        .eUnit = objTargetItemHistory.eUnit
'### 2004/1/15 Added End
        
        .Show vbModal
    
        '�f�[�^���X�V���ꂽ��A��ʃf�[�^�ĕҏW
        If .Updated = True Then
            
'            '�V�K���[�h�̏ꍇ�A�I�u�W�F�N�g�V�K�쐬
'            If modeNew = True Then
'                Set objTargetItemHistory = New ItemHistory
'            End If
                
            '�t�H�[���̒l���Z�b�g�i�����f�[�^�j
            objTargetItemHistory.strDate = .strDate
            objTargetItemHistory.endDate = .endDate
            objTargetItemHistory.Figure1 = .Figure1
            objTargetItemHistory.Figure2 = .Figure2
            objTargetItemHistory.MaxValue = .MaxValue
            objTargetItemHistory.MinValue = .MinValue
            objTargetItemHistory.InsItemCd = .InsItemCd
            objTargetItemHistory.Unit = .Unit
            objTargetItemHistory.DefResult = .DefResult
            objTargetItemHistory.DefRslCmtCd = .DefRslCmtCd
            objTargetItemHistory.ReqItemCd = .ReqItemCd
            objTargetItemHistory.SepOrderDiv = .SepOrderDiv
            
'### 2004/1/15 Added by Ishihara@FSIT ���H�����ڂ̒ǉ�
            objTargetItemHistory.InsSuffix = .InsSuffix
            objTargetItemHistory.eUnit = .eUnit
'### 2004/1/15 Added End
            
            '�t�H�[���̒l���Z�b�g�i�d�q�J���e�f�[�^�j
            mintKarteColKey = .KarteColKey
            Set colWork = .KarteItem
            
            '�d�J���ϊ��R���N�V�����ăZ�b�g
            Set mcolKarteItem = New Collection
            
            For Each objKarteItem In colWork
                mcolKarteItem.Add objKarteItem, objKarteItem.UniqueKey
                Set objKarteItem = Nothing
            Next objKarteItem
                        
'            If modeNew = True Then
'                '�V�K���[�h�̏ꍇ
'
'                '�R���N�V�����L�[�̍ő�l�J�E���g�A�b�v���Z�b�g
'                mintColKey = mintColKey + 1
'                objTargetItemHistory.UniqueKey = mstrColKeyPrefix & mintColKey
'
'                '�R���N�V�����̒ǉ�
'                mcolItemHistory.Add objTargetItemHistory, mstrColKeyPrefix & mintColKey
'
'                '�R���N�V�����L�[�̑ޔ��i�R���{�{�b�N�X����̎Q�Ɨp�j
'                ReDim Preserve mstrItemHistoryKey(mcolItemHistory.Count - 1)
'                mstrItemHistoryKey(mcolItemHistory.Count - 1) = mstrColKeyPrefix & mintColKey
'
'                '�R���{�̖��̒ǉ�
'                cboHistory.AddItem .strDate & "�`" & .endDate & "�ɓK�p����f�[�^"
'                cboHistory.ListIndex = cboHistory.NewIndex
'
'            Else
'
                '�R���{���e�ҏW
                cboHistory.List(cboHistory.ListIndex) = CStr(.strDate) & "�`" & CStr(.endDate) & "�ɓK�p����f�[�^"
            
'            End If
            
            '��ʍĕ\��
            Call EditItemHistoryFromCollection
            
            '�������ڗ����t���O���X�V�ς݂ɕύX
            mblnEditItemHistory = True

        End If
        
    End With

    Set objTargetItemHistory = Nothing
    Set frmItem_h = Nothing

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
Private Sub AddNewHistory()
    
    Dim objTargetItemHistory    As ItemHistory
    
    '�I�u�W�F�N�g��V�K�쐬
    Set objTargetItemHistory = New ItemHistory
    With objTargetItemHistory
        .ItemHNo = "XXXX" & mintColKey         '�V�K�Ȃ̂ŗL�蓾�Ȃ��ԍ����Z�b�g
        .strDate = YEARRANGE_MIN & "/01/01"
        .endDate = YEARRANGE_MAX & "/12/31"
        .Figure1 = 8
        .Figure2 = 0
    End With
    
    '�R���N�V�����L�[�̍ő�l�J�E���g�A�b�v���Z�b�g
    mintColKey = mintColKey + 1
    objTargetItemHistory.UniqueKey = mstrColKeyPrefix & mintColKey
    
    '�R���N�V�����̒ǉ�
    mcolItemHistory.Add objTargetItemHistory, mstrColKeyPrefix & mintColKey
    
    '�R���N�V�����L�[�̑ޔ��i�R���{�{�b�N�X����̎Q�Ɨp�j
    ReDim Preserve mstrItemHistoryKey(mcolItemHistory.Count - 1)
    mstrItemHistoryKey(mcolItemHistory.Count - 1) = mstrColKeyPrefix & mintColKey
    
    '�R���{�̖��̒ǉ�
    cboHistory.AddItem YEARRANGE_MIN & "/01/01" & "�`" & YEARRANGE_MIN & "/12/31" & "�ɓK�p����f�[�^"
    cboHistory.ListIndex = cboHistory.NewIndex
    
    '�������ڗ����t���O���X�V�ς݂ɕύX
    mblnEditItemHistory = True
    
    Set objTargetItemHistory = Nothing
    
End Sub

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property


Friend Property Let Suffix(ByVal vNewValue As Variant)

    mstrSuffix = vNewValue

End Property


' @(e)
'
' �@�\�@�@ : �������ڗ�����e�\���i�R���N�V�����j
'
' �@�\���� : �������ڗ�����e���R���N�V��������\������
'
' ���l�@�@ :
'
Private Sub EditItemHistoryFromCollection()

    Dim objTargetItemHistory    As ItemHistory
    Dim objItem                 As ListItem
    Dim objKarteItem            As KarteItem        '�d�J���ϊ��p�f�[�^�i�[�p�I�u�W�F�N�g
    
    '���x����񏉊���
    lblFigure1.Caption = ""
    lblFigure2.Caption = ""
    lblMaxValue.Caption = ""
    lblMinValue.Caption = ""
    lblinsItemCd.Caption = ""
    lblUnit.Caption = ""
    lblDefResult.Caption = ""
    lblReqItemCd.Caption = ""
'    lblDefRslCmtCd.Caption = ""
    
    If cboHistory.ListCount <= 0 Then Exit Sub
    
    '�R���N�V��������ΏۃA�C�e���̒��o
    Set objTargetItemHistory = mcolItemHistory(mstrItemHistoryKey(cboHistory.ListIndex))
    
    '�����f�[�^�̉�ʕ\��
    With objTargetItemHistory
        lblFigure1.Caption = .Figure1
        lblFigure2.Caption = .Figure2
        lblMaxValue.Caption = .MaxValue
        lblMinValue.Caption = .MinValue
        lblinsItemCd.Caption = .InsItemCd
        lblUnit.Caption = .Unit
        lblDefResult.Caption = .DefResult
        lblReqItemCd.Caption = .ReqItemCd
'## 2003.11.23 Modified By H.Ishihara@FSIT ���H���s�v���ڂ̍폜
'        If .SepOrderDiv = "1" Then
'            lblReqItemCd.Caption = lblReqItemCd.Caption & "�@�i�������Č����˗��j"
'        End If

'        lblDefRslCmtCd.Caption = .DefRslCmtCd
    End With
    
'## 2003.01.23 Deleted *Lines By H.Ishihara@FSIT �d�J�����W�b�N�͕s�v
'    '�d�J���ϊ����ڃ��X�g�r���[�ݒ�
'    lsvKarteItem.ListItems.Clear
'
'    '�w�b�_�̕ҏW
'    With lsvKarteItem.ColumnHeaders
'        .Clear
'        .Add , , "������ʃR�[�h", 1000, lvwColumnLeft
'        .Add , , "���ڑ���", 1000, lvwColumnLeft
'        .Add , , "���ڃR�[�h", 1000, lvwColumnLeft
'        .Add , , "���ږ�", 1500, lvwColumnLeft
'        .Add , , "�^�O��", 1200, lvwColumnLeft
'    End With
'
'    lsvKarteItem.View = lvwReport
'
'    '�d�q�J���e���ڏ��̕ҏW
'    For Each objKarteItem In mcolKarteItem
'        If objKarteItem.ItemHNo = objTargetItemHistory.ItemHNo Then
'            With objKarteItem
'                Set objItem = lsvKarteItem.ListItems.Add(, .UniqueKey, .KarteDocCd, , "DEFAULTLIST")
'                objItem.SubItems(1) = .KarteItemAttr
'                objItem.SubItems(2) = .KarteItemcd
'                objItem.SubItems(3) = .KarteItemName
'                objItem.SubItems(4) = .KarteTagName
'            End With
'        End If
'    Next objKarteItem
    
End Sub

'
' @(e)
'
' �@�\�@�@ : ���̓^�u����
'
' �@�\���� : ���ʃ^�C�v�ɂ���ĕ��̓^�u�̎g�p�ۏ�Ԃ𐧌䂷��B
'
' ���l�@�@ :
'
Private Sub CntlSentenceTab(blnSentenceEnabled As Boolean)

    '�w�肳�ꂽ��ԂŎg�p�ۂ𐧌�
    cboItemType.Enabled = blnSentenceEnabled
    optStcMySelf(0).Enabled = blnSentenceEnabled
    optStcMySelf(1).Enabled = blnSentenceEnabled
    cmdStcItemCd.Enabled = blnSentenceEnabled
    lsvStc.Enabled = blnSentenceEnabled
    cboRecentCount.Enabled = blnSentenceEnabled

    '���x���n�̐���
    If blnSentenceEnabled = True Then
        lblStcItemCd.ForeColor = vbButtonText
        LabelRecentCount.ForeColor = vbButtonText
    
        '�I�v�V�����{�^���̐���𗘂�����i���łɕ��͂��\�����Ă����j
        If optStcMySelf(0).Value = True Then
            Call optStcMySelf_Click(0)
        End If
        
    Else
        lblStcItemCd.ForeColor = vbGrayText
        LabelRecentCount.ForeColor = vbGrayText
    End If

    
End Sub

'
' @(e)
'
' �@�\�@�@ : ���͌��ʕ\��
'
' �@�\���� : ���̍��ڂŊǗ����Ă��镶�͌��ʂ�\������
'
' ���l�@�@ :
'
Private Sub EditSentenceList(strItemCd As String)

On Error GoTo ErrorHandle

    Const KEY_PREFIX = "K"
    Const KEY_SEPARATE = "-"
    
    Dim objSentence     As Object           '���̓A�N�Z�X�p
    Dim objHeader       As ColumnHeaders    '�J�����w�b�_�I�u�W�F�N�g
    Dim objItem         As ListItem         '���X�g�A�C�e���I�u�W�F�N�g
    
    Dim vntItemCd       As Variant          '�������ڃR�[�h
    Dim vntItemType     As Variant          '���ڃ^�C�v
    Dim vntStcCd        As Variant          '���̓R�[�h
    Dim vntShortStc     As Variant          '����
    Dim vntLongStc      As Variant          '��������
    Dim vntRequestName  As Variant          '�˗����ږ�
    
    Dim lngCount        As Long             '���R�[�h��
    Dim i               As Long             '�C���f�b�N�X
    
    '�������ڃR�[�h���󔒂Ȃ珈���I���i�V�K�쐬�̂Ƃ��Ƃ��ˁj
    If strItemCd = "" Then Exit Sub
    
    '���ݑI������Ă��錋�ʃ^�C�v�����͂łȂ��Ȃ珈���I��
    If cboResultType.ListIndex <> RESULTTYPE_SENTENCE Then Exit Sub

    '�I�u�W�F�N�g�̃C���X�^���X�쐬
    Set objSentence = CreateObject("HainsSentence.Sentence")
    lngCount = objSentence.SelectSentenceList(strItemCd, _
                                              cboItemType.ListIndex, _
                                              vntStcCd, _
                                              vntShortStc)
    
    '�w�b�_�̕ҏW
    lsvStc.ListItems.Clear
    Set objHeader = lsvStc.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "���̓R�[�h", 1000, lvwColumnLeft
    objHeader.Add , , "���͖�", 5000, lvwColumnLeft
        
    lsvStc.View = lvwReport
    
    '���X�g�̕ҏW
    For i = 0 To lngCount - 1
        Set objItem = lsvStc.ListItems.Add(, KEY_PREFIX & mstrStcItemCd & KEY_SEPARATE & cboItemType.ListIndex & KEY_SEPARATE & vntStcCd(i) _
                                            , vntStcCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntShortStc(i)
    Next i
    
    '�I�u�W�F�N�g�p��
    Set objSentence = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    

End Sub
