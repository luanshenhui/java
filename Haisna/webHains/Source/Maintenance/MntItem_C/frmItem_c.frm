VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmItem_c 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "検査項目情報の設定"
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
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
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
      Caption         =   "キャンセル"
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
         Name            =   "ＭＳ ゴシック"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      TabCaption(0)   =   "基本情報"
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
      TabCaption(1)   =   "履歴設定関連"
      TabPicture(1)   =   "frmItem_c.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Image1(4)"
      Tab(1).Control(1)=   "Label5"
      Tab(1).Control(2)=   "Frame1"
      Tab(1).ControlCount=   3
      TabCaption(2)   =   "その他設定"
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
      TabCaption(3)   =   "文章結果"
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
         IMEMode         =   3  'ｵﾌ固定
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
         IMEMode         =   3  'ｵﾌ固定
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
         IMEMode         =   3  'ｵﾌ固定
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
         IMEMode         =   3  'ｵﾌ固定
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
         IMEMode         =   3  'ｵﾌ固定
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
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1800
         MaxLength       =   2
         TabIndex        =   83
         Text            =   "@@"
         Top             =   4620
         Visible         =   0   'False
         Width           =   375
      End
      Begin VB.Frame Frame10 
         Caption         =   "その他設定関連"
         Height          =   1515
         Left            =   300
         TabIndex        =   81
         Top             =   5100
         Visible         =   0   'False
         Width           =   5835
         Begin VB.TextBox txtContractItemCd 
            Height          =   318
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1800
            MaxLength       =   17
            TabIndex        =   51
            Text            =   "@@@@@@@@@@@@@@@@@"
            Top             =   1020
            Width           =   2235
         End
         Begin VB.TextBox txtContractCd 
            Height          =   318
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1800
            MaxLength       =   1
            TabIndex        =   49
            Text            =   "@"
            Top             =   660
            Width           =   255
         End
         Begin VB.TextBox txtCollectCd 
            Height          =   318
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1800
            MaxLength       =   3
            TabIndex        =   47
            Text            =   "@@@"
            Top             =   300
            Width           =   495
         End
         Begin VB.Label Label2 
            Caption         =   "外注結果コード(&R):"
            Height          =   195
            Index           =   7
            Left            =   240
            TabIndex        =   50
            Top             =   1080
            Width           =   1635
         End
         Begin VB.Label Label2 
            Caption         =   "外注先コード(&G):"
            Height          =   195
            Index           =   6
            Left            =   240
            TabIndex        =   48
            Top             =   720
            Width           =   1455
         End
         Begin VB.Label Label2 
            Caption         =   "採取コード(&S):"
            Height          =   195
            Index           =   5
            Left            =   240
            TabIndex        =   46
            Top             =   360
            Width           =   1515
         End
      End
      Begin VB.Frame Frame11 
         Caption         =   "検査項目説明"
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
         Caption         =   "設定する文章"
         Height          =   4095
         Left            =   -74820
         TabIndex        =   34
         Top             =   2040
         Width           =   7095
         Begin VB.CommandButton cmdStcItemCd 
            Caption         =   "参照(&B)..."
            Height          =   315
            Left            =   240
            TabIndex        =   37
            Top             =   1080
            Width           =   1395
         End
         Begin VB.OptionButton optStcMySelf 
            Caption         =   "文章はこの項目で設定したものを使用する(&U)"
            Height          =   255
            Index           =   0
            Left            =   240
            TabIndex        =   35
            Top             =   360
            Value           =   -1  'True
            Width           =   4575
         End
         Begin VB.OptionButton optStcMySelf 
            Caption         =   "他の検査項目で設定した文章を使用する(&O)"
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
            Caption         =   "000102：胸部Ｘ線"
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
            Caption         =   "登録されている文章(&P):"
            Height          =   255
            Left            =   300
            TabIndex        =   39
            Top             =   1560
            Width           =   2115
         End
      End
      Begin VB.Frame Frame8 
         Caption         =   "基本設定"
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
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   33
            Top             =   300
            Width           =   4530
         End
         Begin VB.Label Label8 
            Caption         =   "項目タイプ(&I):"
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
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   42
         Top             =   6240
         Width           =   810
      End
      Begin VB.Frame Frame4 
         Caption         =   "項目属性設定関連"
         Height          =   2235
         Left            =   -74820
         TabIndex        =   58
         Top             =   4320
         Width           =   7155
         Begin VB.CheckBox chkHideInterview 
            Caption         =   "結果がセットされていない場合、面接支援画面では非表示にする(&H):"
            Height          =   180
            Left            =   180
            TabIndex        =   19
            Top             =   1740
            Width           =   5655
         End
         Begin VB.CheckBox chkCuTargetFlg 
            Caption         =   "この検査項目はCU経年変化表示対象とする(&U):"
            Height          =   180
            Left            =   180
            TabIndex        =   18
            Top             =   1440
            Width           =   5655
         End
         Begin VB.CheckBox chkNoPrintFlg 
            Caption         =   "この検査結果は報告書の「その他検査欄」に出力しない(&P):"
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
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   14
            Top             =   300
            Width           =   4110
         End
         Begin VB.ComboBox cboSearchChar 
            Height          =   300
            ItemData        =   "frmItem_c.frx":014E
            Left            =   1800
            List            =   "frmItem_c.frx":0170
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   16
            Top             =   660
            Width           =   810
         End
         Begin VB.Label Label8 
            Caption         =   "結果タイプ(&K):"
            Height          =   195
            Index           =   0
            Left            =   180
            TabIndex        =   13
            Top             =   360
            Width           =   1335
         End
         Begin VB.Label Label3 
            Caption         =   "検索用文字列(&C):"
            Height          =   195
            Index           =   2
            Left            =   180
            TabIndex        =   15
            Top             =   720
            Width           =   1395
         End
      End
      Begin VB.Frame Frame3 
         Caption         =   "名称設定関連"
         Height          =   2295
         Left            =   -74820
         TabIndex        =   52
         Top             =   1860
         Width           =   7155
         Begin VB.TextBox txtItemEName 
            Height          =   318
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1800
            MaxLength       =   32
            TabIndex        =   10
            Text            =   "@@@@@@@@@@"
            Top             =   1380
            Width           =   5175
         End
         Begin VB.TextBox txtItemQName 
            Height          =   318
            IMEMode         =   4  '全角ひらがな
            Left            =   1800
            MaxLength       =   40
            TabIndex        =   12
            Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
            Top             =   1740
            Width           =   5175
         End
         Begin VB.TextBox txtItemName 
            Height          =   318
            IMEMode         =   4  '全角ひらがな
            Left            =   1800
            MaxLength       =   100
            TabIndex        =   4
            Text            =   "＠＠＠＠＠＠＠＠＠＠"
            Top             =   300
            Width           =   5175
         End
         Begin VB.TextBox txtItemSName 
            Height          =   318
            IMEMode         =   4  '全角ひらがな
            Left            =   1800
            MaxLength       =   100
            TabIndex        =   6
            Text            =   "＠＠＠＠＠"
            Top             =   660
            Width           =   5175
         End
         Begin VB.TextBox txtItemRName 
            Height          =   318
            IMEMode         =   4  '全角ひらがな
            Left            =   1800
            MaxLength       =   100
            TabIndex        =   8
            Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
            Top             =   1020
            Width           =   5175
         End
         Begin VB.Label Label2 
            Caption         =   "英語項目名(&E):"
            Height          =   195
            Index           =   4
            Left            =   180
            TabIndex        =   9
            Top             =   1440
            Width           =   1635
         End
         Begin VB.Label Label2 
            Caption         =   "問診用文章(&Q):"
            Height          =   195
            Index           =   3
            Left            =   180
            TabIndex        =   11
            Top             =   1800
            Width           =   1635
         End
         Begin VB.Label Label2 
            Caption         =   "検査項目名(&N):"
            Height          =   195
            Index           =   0
            Left            =   180
            TabIndex        =   3
            Top             =   360
            Width           =   1275
         End
         Begin VB.Label Label2 
            Caption         =   "略称(&S):"
            Height          =   195
            Index           =   1
            Left            =   180
            TabIndex        =   5
            Top             =   720
            Width           =   1395
         End
         Begin VB.Label Label2 
            Caption         =   "報告書用表示名(&R):"
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
         IMEMode         =   3  'ｵﾌ固定
         Left            =   -72060
         MaxLength       =   2
         TabIndex        =   2
         Text            =   "@@"
         Top             =   1320
         Width           =   375
      End
      Begin VB.Frame Frame1 
         Caption         =   "履歴データ(&H)"
         Height          =   5595
         Left            =   -74820
         TabIndex        =   53
         Top             =   1080
         Width           =   7215
         Begin VB.Frame Frame9 
            Caption         =   "連携関連情報"
            Height          =   915
            Left            =   180
            TabIndex        =   95
            Top             =   3900
            Width           =   6795
            Begin VB.TextBox txtOrderDiv 
               Height          =   318
               IMEMode         =   3  'ｵﾌ固定
               Left            =   1440
               MaxLength       =   12
               TabIndex        =   25
               Text            =   "@@"
               Top             =   420
               Width           =   2235
            End
            Begin VB.TextBox txtBuiCode 
               Height          =   318
               IMEMode         =   3  'ｵﾌ固定
               Left            =   5100
               MaxLength       =   2
               TabIndex        =   27
               Text            =   "@@"
               Top             =   480
               Width           =   375
            End
            Begin VB.Label Label2 
               Caption         =   "オーダ種別(&D):"
               Height          =   195
               Index           =   15
               Left            =   300
               TabIndex        =   24
               Top             =   480
               Width           =   1515
            End
            Begin VB.Label Label2 
               Caption         =   "部位コード(&B):"
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
            IMEMode         =   3  'ｵﾌ固定
            Left            =   5700
            MaxLength       =   9
            TabIndex        =   29
            Text            =   "@@@@@@@@@"
            Top             =   4980
            Width           =   1275
         End
         Begin VB.Frame Frame5 
            Caption         =   "電子カルテシステム連携"
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
            Caption         =   "検査システム連携"
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
               Caption         =   "依頼用コード:"
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
               Caption         =   "結果変換用コード:"
               Height          =   195
               Index           =   15
               Left            =   240
               TabIndex        =   68
               Top             =   720
               Width           =   1515
            End
         End
         Begin VB.Frame Frame2 
            Caption         =   "入力結果定義関連"
            Height          =   1335
            Left            =   180
            TabIndex        =   59
            Top             =   1200
            Width           =   6795
            Begin VB.Label lblUnit 
               Caption         =   "α"
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
               Caption         =   "99：異常なし"
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
               Caption         =   "整数部桁数:"
               Height          =   195
               Index           =   9
               Left            =   240
               TabIndex        =   65
               Top             =   360
               Width           =   1215
            End
            Begin VB.Label Label8 
               Caption         =   "小数部桁数:"
               Height          =   195
               Index           =   10
               Left            =   2760
               TabIndex        =   64
               Top             =   360
               Width           =   1215
            End
            Begin VB.Label Label8 
               Caption         =   "入力可能な最大値:"
               Height          =   195
               Index           =   11
               Left            =   2760
               TabIndex        =   63
               Top             =   660
               Width           =   1755
            End
            Begin VB.Label Label8 
               Caption         =   "入力可能な最小値:"
               Height          =   195
               Index           =   12
               Left            =   240
               TabIndex        =   62
               Top             =   660
               Width           =   1755
            End
            Begin VB.Label Label8 
               Caption         =   "省略時検査結果:"
               Height          =   195
               Index           =   3
               Left            =   240
               TabIndex        =   61
               Top             =   960
               Width           =   1815
            End
            Begin VB.Label Label8 
               Caption         =   "単位:"
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
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   20
            Top             =   300
            Width           =   5670
         End
         Begin VB.CommandButton cmdNewHistory 
            Caption         =   "新規(&N)..."
            Height          =   315
            Left            =   1860
            TabIndex        =   21
            Top             =   720
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditHistory 
            Caption         =   "編集(&E)..."
            Height          =   315
            Left            =   3240
            TabIndex        =   22
            Top             =   720
            Width           =   1275
         End
         Begin VB.CommandButton cmdDeleteHistory 
            Caption         =   "削除(&D)..."
            Height          =   315
            Left            =   4620
            TabIndex        =   23
            Top             =   720
            Width           =   1275
         End
         Begin VB.Label Label2 
            Caption         =   "移行先旧検査項目コード(&I):"
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
         IMEMode         =   3  'ｵﾌ固定
         Left            =   -73140
         MaxLength       =   6
         TabIndex        =   1
         Text            =   "@@@@@@"
         Top             =   1320
         Width           =   855
      End
      Begin VB.Label Label2 
         Caption         =   "採取管コード(&T):"
         Height          =   195
         Index           =   9
         Left            =   4440
         TabIndex        =   94
         Top             =   4680
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "材料コード(&M):"
         Height          =   195
         Index           =   10
         Left            =   4440
         TabIndex        =   93
         Top             =   4320
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "ラベルマーク(&L):"
         Height          =   195
         Index           =   11
         Left            =   2460
         TabIndex        =   92
         Top             =   4320
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "ＷＳコード(&W):"
         Height          =   195
         Index           =   12
         Left            =   2460
         TabIndex        =   91
         Top             =   4680
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "負荷コード１(&1):"
         Height          =   195
         Index           =   13
         Left            =   300
         TabIndex        =   90
         Top             =   4320
         Visible         =   0   'False
         Width           =   1515
      End
      Begin VB.Label Label2 
         Caption         =   "負荷コード２(&2):"
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
         Caption         =   "この検査項目で使用する文章結果です"
         Height          =   255
         Left            =   -74040
         TabIndex        =   77
         Top             =   660
         Width           =   3915
      End
      Begin VB.Label LabelRecentCount 
         Caption         =   "最近使った文章管理数(&B):"
         Height          =   195
         Left            =   -70620
         TabIndex        =   41
         Top             =   6300
         Width           =   2115
      End
      Begin VB.Label LabelJudGuide 
         Caption         =   "その他設定情報"
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
         Caption         =   "検査項目の履歴管理情報を設定します。"
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
         Caption         =   "検査項目の基本的な情報を設定します。"
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
         Caption         =   "検査項目コード(&C):"
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

'プロパティ用領域
Private mstrItemCd              As String       '検査項目コード
Private mstrSuffix              As String       'サフィックス
Private mintRslQue              As String       '結果問診フラグ
Private mstrStcItemCd           As String       '文章参照用項目コード

Private mblnUpdated             As Boolean      'TRUE:更新あり、FALSE:更新なし
Private mblnInitialize          As Boolean      'TRUE:正常に初期化、FALSE:初期化失敗

Private mcolItemHistory         As Collection   '検査項目履歴管理データ格納用コレクション
Private mcolKarteItem           As Collection   '電子カルテ項目コード変換用データ格納用コレクション

'履歴コンボ対応データ退避用
Const mstrColKeyPrefix          As String = "K"
Private mstrItemHistoryKey()    As String       '履歴コンボに対応するコレクションキー
Private mintColKey              As Integer      'リストビューキーをユニークにするためのIndex（履歴用）
Private mintKarteColKey         As Integer      'リストビューキーをユニークにするためのIndex（カルテ用）

Private mintCsHNo()             As Integer  '履歴コンボに対応する履歴番号
Private mstrStrDate()           As String   '履歴コンボに対応する開始日付
Private mstrEndDate()           As String   '履歴コンボに対応する終了日付
Private mlngPrice()             As Long     '履歴コンボに対応する検査項目基本料金

'タブクリック時の表示制御用フラグ
Private mblnShowHistory         As Boolean  'TRUE:表示済み、FALSE:未表示
Private mblnShowOpe             As Boolean  'TRUE:表示済み、FALSE:未表示
Private mblnShowJud             As Boolean  'TRUE:表示済み、FALSE:未表示
Private mblnShowGov             As Boolean  'TRUE:表示済み、FALSE:未表示

'保存対象データ制御用
Private mblnEditMain            As Boolean  'TRUE:更新、FALSE:未更新
Private mblnEditItemHistory     As Boolean  'TRUE:更新、FALSE:未更新
Private mblnEditOpe             As Boolean  'TRUE:更新、FALSE:未更新
Private mblnEditJud             As Boolean  'TRUE:更新、FALSE:未更新

Private mblnNowEdit             As Boolean  'TRUE:編集処理中、FALSE:処理なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

'固定コード管理
Const GRPDIV_ITEM               As String = "I"
Const GRPDIV_GRP                As String = "G"
Const mstrListViewKey           As String = "K"

Const INSERT_NORMAL             As Long = 1
Const INSERT_DUPLICATE          As Long = 0
Const INSERT_ERROR              As Long = -1

Const NOREASON_TEXT             As String = "する"

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Friend Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
End Property

' @(e)
'
' 機能　　 : 登録データのチェック
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容の妥当性をチェックする
'
' 備考　　 :
'
Private Function CheckValue() As Boolean

    Dim Ret             As Boolean  '関数戻り値
    Dim objItemHistory  As ItemHistory
    Dim strInsItemCd    As String
    Dim strSepOrderDiv  As String
    
    '初期処理
    Ret = False
        
    '自分自身にSetFocusすると文字列選択状態が外れるので、ダミーSetFocus
    cmdOk.SetFocus
    
    Do
        'コードはとりみんぐ
        txtItemCd.Text = Trim(txtItemCd.Text)
        txtSuffix.Text = Trim(txtSuffix.Text)
        
        '検査項目関連
        If Trim(txtItemCd.Text) = "" Then
            MsgBox "検査項目コードが入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtItemCd.SetFocus
            Exit Do
        End If
        
        'コードのハイフンチェック
        If InStr(txtItemCd.Text, "-") > 0 Then
            MsgBox "検査項目コードにハイフンを含めることはできません。", vbExclamation, App.Title
            txtItemCd.SetFocus
            Exit Do
        End If
        
        '依頼項目の存在チェック
        If GetItem_PInfo() = False Then
            MsgBox "親となる依頼項目レコードが存在しません。依頼項目コードを登録してから検査項目を登録してください。", vbCritical, App.Title
            txtItemCd.SetFocus
            Exit Do
        End If
        
        'サフィックス関連
        If Trim(txtSuffix.Text) = "" Then
            MsgBox "サフィックスが入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtSuffix.SetFocus
            Exit Do
        End If
        
        'コードのハイフンチェック
        If InStr(txtSuffix.Text, "-") > 0 Then
            MsgBox "サフィックスにハイフンを含めることはできません。", vbExclamation, App.Title
            txtSuffix.SetFocus
            Exit Do
        End If
        
        If IsNumeric(txtSuffix.Text) = False Then
            MsgBox "サフィックスには数値を入力してください。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtSuffix.SetFocus
            Exit Do
        Else
            txtSuffix.Text = Format(txtSuffix.Text, "00")
        End If

        '検査項目名
        If Trim(txtItemName.Text) = "" Then
            MsgBox "検査項目名が入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtItemName.SetFocus
            Exit Do
        End If

        '略称（なかったら突っ込む）
        If Trim(txtItemSName.Text) = "" Then
            txtItemSName.Text = Mid(txtItemName.Text, 1, 5)
        End If

        '報告書名（なかったら突っ込む）
        If Trim(txtItemRName.Text) = "" Then
            txtItemRName.Text = txtItemName.Text
        End If

        '問診用項目名（なかったら突っ込む）
        If (Trim(txtItemQName.Text) = "") And (mintRslQue = RSLQUE_Q) Then
            txtItemQName.Text = txtItemName.Text
        End If

        '検査用項目コードの存在チェック
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
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

'
' 機能　　 : 依頼項目情報検索
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function GetItem_PInfo() As Boolean

    Dim objItem_P       As Object          '依頼項目アクセス用
    Dim vntRequestName  As Variant         '検査項目名称
    Dim vntRslQue       As Variant         '結果問診フラグ
    
    Dim Ret             As Boolean          '戻り値
    Dim i               As Integer
    
    On Error GoTo ErrorHandle
    
    GetItem_PInfo = False
    Ret = False

    'オブジェクトのインスタンス作成
    Set objItem_P = CreateObject("HainsItem.Item")
    
    Do
        
        '依頼項目テーブルレコード読み込み
        If objItem_P.SelectItem_P(txtItemCd.Text, _
                                  vntRequestName, _
                                  vntRslQue) = False Then
            Exit Do
        End If
        
        mintRslQue = CInt(vntRslQue)
        Ret = True
        Exit Do
    
    Loop
    
    '戻り値の設定
    GetItem_PInfo = Ret
    
    Exit Function

ErrorHandle:

    GetItem_PInfo = False
    MsgBox Err.Description, vbCritical
    
End Function


' @(e)
'
' 機能　　 : 基本検査項目情報画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査項目の基本情報を画面に表示する
'
' 備考　　 :
'
Private Function EditItem_c() As Boolean

    Dim objItem             As Object               '検査項目情報アクセス用
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
    
'## 2003.02.05 Add 6Lines By H.Ishihara@FSIT 検体ラベル関係の変数追加
    Dim vntCollectTubeCd    As Variant              '採取管コード
    Dim vntMaterials        As Variant              '材料コード
    Dim vntLabelMark        As Variant              'マーク
    Dim vntWsCd             As Variant              'ＷＳコード
    Dim vntLoadCd1          As Variant              '負荷コード１
    Dim vntLoadCd2          As Variant              '負荷コード２
'## 2003.02.05 Add End

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
    Dim vntCuTargetFlg      As Variant              'CU経年変化表示対象
    Dim vntOrderDiv         As Variant              'オーダ種別
    Dim vntBuiCode          As Variant              '部位コード
    Dim vntExplanation      As Variant              '項目説明
'### 2004/1/15 Added End

'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
    Dim vntHideInterview    As Variant              '面接画面非表示
'### 2004/1/29 Added End

    Dim Ret         As Boolean              '戻り値
    
    EditItem_c = False
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objItem = CreateObject("HainsItem.Item")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If (mstrItemCd = "") Or (mstrSuffix = "") Then
        
            'つまり新規なので履歴を作っちゃう
            Call AddNewHistory
            
            Ret = True
            Exit Do
        End If
        
        '検査項目テーブルレコード読み込み
'## 2003.11.23 Mod 1Line By H.Ishihara@FSIT 聖路加不要項目の削除
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
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
'### 2004/1/29 Modified by Ishihara@FSIT 聖路加項目の追加
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
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
'## 2003.02.05 Mod End
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If


'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        If vntCuTargetFlg = "1" Then chkCuTargetFlg.Value = vbChecked
        txtOrderDiv.Text = vntOrderDiv
        txtBuiCode.Text = vntBuiCode
        txtExplanation.Text = vntExplanation
'### 2004/1/15 Added end

        '読み込み内容の編集（検査項目基本情報）
        mintRslQue = CInt(vntRslQue)

        txtItemCd.Text = mstrItemCd
        txtSuffix.Text = mstrSuffix
        txtItemName.Text = vntItemName
        txtItemSName.Text = vntItemSName
        txtItemRName.Text = vntItemRName
        txtItemEName.Text = vntitemEName
        txtItemQName.Text = vntItemQName

        lblStcItemCd.Caption = vntStcItemCd & ":" & vntStcItemName

        '検索文字列コンボの設定
        For i = 0 To cboSearchChar.ListCount - 1
            If cboSearchChar.List(i) = vntSearchChar Then
                cboSearchChar.ListIndex = i
            End If
        Next i

        'コンボの設定（数値セットで設定が完了するもの）
        cboResultType.ListIndex = CInt(vntResultType)
        cboItemType.ListIndex = CInt(vntItemType)

        'その他フィールドへのセット
        txtCollectCd.Text = vntCollectCd
        txtContractCd.Text = vntContractCd
        txtContractItemCd.Text = vntContractItemCd
        txtOldItemCd.Text = vntOldItemCd
    
'## 2003.02.05 Add 6Lines By H.Ishihara@FSIT 検体ラベル関係の変数追加
        txtCollectTubeCd.Text = vntCollectTubeCd
        txtMaterials.Text = vntMaterials
        txtLabelMark.Text = vntLabelMark
        txtWsCd.Text = vntWsCd
        txtLoadCd1.Text = vntLoadCd1
        txtLoadCd2.Text = vntLoadCd2
'## 2003.02.05 Add End
    
'### 2004/1/29 Added by Ishihara@FSIT 聖路加項目の追加
        chkHideInterview.Value = IIf(vntHideInterview = "1", vbChecked, vbUnchecked)
'### 2004/1/29 Added End
    
'## 2002.11.10 Add 5Lines By H.Ishihara@FSIT 報告書未出力フラグ対応
        If Trim(vntNoPrintFlg) = ITEM_NOPRINT Then
            chkNoPrintFlg.Value = vbChecked
        Else
            chkNoPrintFlg.Value = vbUnchecked
        End If
'## 2002.11.10 Add End
    
        '文章タブフィールド
        mstrStcItemCd = vntStcItemCd
        cboRecentCount.ListIndex = CInt(vntRecentCount)
        
        '参照先とコードが同じなら
        optStcMySelf(1).Value = Not (vntStcItemCd = mstrItemCd)
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditItem_c = Ret
    
    Exit Function

ErrorHandle:

    EditItem_c = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : 検査項目基本情報の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容を検査項目テーブルに保存する。
'
' 備考　　 :
'
Private Function RegistItem_c() As Boolean

On Error GoTo ErrorHandle

    Dim objItem_c           As Object       '検査項目アクセス用
    Dim lngRet              As Long
    Dim strSearchChar       As String
    
    '履歴データ
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
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
    Dim vntInsSuffix()      As Variant
    Dim vntEUnit()          As Variant
'### 2004/1/15 Added End
    
    'カルテデータ
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

    'ガイド検索文字列の再編集
    strSearchChar = cboSearchChar.List(cboSearchChar.ListIndex)
    If strSearchChar = "その他" Then
        strSearchChar = "*"
    End If

    i = 0
    j = 0
    intItemCount = mcolItemHistory.Count
    intkarteItemCount = mcolKarteItem.Count
    
    '履歴管理テーブル用データ編集
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
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        ReDim Preserve vntInsSuffix(i)
        ReDim Preserve vntEUnit(i)
'### 2004/1/15 Added End
    
        With objItemHistory
            
            '電カルコレクションとの整合性を統一するため履歴Noのみ退避（新規時の履歴番号）
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
        
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
            vntInsSuffix(i) = .InsSuffix
            vntEUnit(i) = .eUnit
'### 2004/1/15 Added End
        
        End With
            
        '電カルコレクションのデータセット
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

    '履歴の重複チェック
    Set objLocalCommon = New LocalCommon.Common
    If objLocalCommon.CheckHistoryDuplicate(intItemCount, vntStrDate, vntEndDate) = False Then
        MsgBox "日付が重複している履歴が存在します。履歴設定を再入力してください。", vbExclamation
        tabMain.Tab = 1
        cboHistory.SetFocus
        Exit Function
    End If

    'オブジェクトのインスタンス作成
    Set objItem_c = CreateObject("HainsItem.Item")

    '検査項目テーブルレコードの登録
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
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
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
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
'### 2004/1/29 Modified by Ishihara@FSIT 聖路加項目の追加
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
        
        '戻り値がエラーの場合
        Case INSERT_ERROR
            MsgBox "データ保存中にエラーが発生しました。", vbExclamation
            Exit Function
        
        '戻り値がダブリありの場合
        Case INSERT_DUPLICATE
            MsgBox "入力された検査項目コードは既に存在します。", vbExclamation
            Exit Function
        
        '戻り値が履歴ダブリありの場合
        Case INSERT_HISTORYDUPLICATE
            MsgBox "日付が重複している履歴が存在します。履歴設定を再入力してください。", vbExclamation
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
    
    '履歴管理数が複数存在しないなら処理終了
    If intItemCount < 2 Then
        CheckHistoryDuplicate = True
        Exit Function
    End If
    
    '履歴項目数分Loop
    For i = 0 To intItemCount - 1
        j = i + 1
        
        '現在位置＋１から検索
        For j = i + 1 To intItemCount - 1
        
            '開始日付の重複チェック
            If (CDate(vntStrDate(i) >= vntStrDate(j))) And (CDate(vntStrDate(i) <= vntEndDate(j))) Then
                Exit Function
            End If
    
            '終了日付の重複チェック
            If (CDate(vntEndDate(i) >= vntStrDate(j))) And (CDate(vntEndDate(i) <= vntEndDate(j))) Then
                Exit Function
            End If
    
        Next j
    Next i
        
    CheckHistoryDuplicate = True

End Function

' @(e)
'
' 機能　　 : 検査項目履歴情報の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容を検査項目履歴管理テーブルに保存する。
'
' 備考　　 :
'
Private Function RegistItemHistory() As Boolean

On Error GoTo ErrorHandle

    Dim objItem             As Object       '検査項目アクセス用
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

    'オブジェクトのインスタンス作成
    Set objItem = CreateObject("HainsItem.Item")

    '検査項目テーブルレコードの登録
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
    
    '戻り値がダブリありの場合
    If lngRet = INSERT_DUPLICATE Then
        MsgBox "入力された検査項目コードは既に存在します。", vbExclamation
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
' 機能　　 : 「検査項目履歴コンボ」Click
'
' 機能説明 : 選択された履歴内で管理している項目を表示する
'
' 備考　　 :
'
Private Sub cboHistory_Click()

    Dim strMsg      As String
    Dim intRet      As Integer
    
    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    '受診検査項目の表示
    Call EditItemHistoryFromCollection

    '未更新状態に初期化
'    mblnEditItemHistory = False

End Sub

Private Sub cboItemType_Click()

    '管理している文章一覧を表示する
    Call EditSentenceList(mstrStcItemCd)

End Sub

' @(e)
'
' 機能　　 : 「適用」クリック
'
' 引数　　 : なし
'
' 機能説明 : 入力内容を適用する。画面は閉じない
'
' 備考　　 :
'
Private Sub cmdApply_Click()
    
    'データ適用処理を行う
    If ApplyData() = True Then
        MsgBox "入力内容を保存しました。", vbInformation
    End If

End Sub

' @(e)
'
' 機能　　 : 「キャンセル」Click
'
' 機能説明 : フォームを閉じる
'
' 備考　　 :
'
Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : 検査項目履歴削除ボタン
'
' 機能説明 : 検査項目履歴データを削除する
'
' 備考　　 :
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
    
    'コンボボックスに対応するキーでコレクションから削除
    mcolItemHistory.Remove mstrItemHistoryKey(cboHistory.ListIndex)
    
    cboHistory.Clear
    Erase mstrItemHistoryKey
    
    'コンボボックスと対応キー配列を再構成
    For Each objTargetItemHistory In mcolItemHistory
        With objTargetItemHistory
            cboHistory.AddItem .strDate & "～" & .endDate & "に適用するデータ"
            
            ReDim Preserve mstrItemHistoryKey(cboHistory.NewIndex)
            mstrItemHistoryKey(cboHistory.NewIndex) = objTargetItemHistory.UniqueKey
        End With
    
    Next objTargetItemHistory
    
    If cboHistory.ListCount <> 0 Then
        cboHistory.ListIndex = 0
    End If
            
    '画面再表示
    Call EditItemHistoryFromCollection
    
    '検査項目履歴フラグを更新済みに変更
    mblnEditItemHistory = True
    
    '削除ボタン使用可否制御
    If cboHistory.ListCount < 2 Then
        cmdDeleteHistory.Enabled = False
    End If
    
End Sub

' @(e)
'
' 機能　　 : 検査項目履歴修正ボタン
'
' 機能説明 : 検査項目履歴作成用フォーム表示
'
' 備考　　 :
'
Private Sub cmdEditHistory_Click()
    
    '修正モードで検査項目履歴を表示
    Call ShowItem_h(False)

End Sub

' @(e)
'
' 機能　　 : 検査項目履歴新規作成ボタン
'
' 機能説明 : 検査項目履歴作成用フォーム表示
'
' 備考　　 :
'
Private Sub cmdNewHistory_Click()

    '新規モードで検査項目履歴を表示
    Call ShowItem_h(True)
    
End Sub

' @(e)
'
' 機能　　 : 「ＯＫ」クリック
'
' 引数　　 : なし
'
' 機能説明 : 入力内容を適用し、画面を閉じる
'
' 備考　　 :
'
Private Sub cmdOk_Click()
    
    'データ適用処理を行う（エラー時は画面を閉じない）
    If ApplyData() = False Then
        Exit Sub
    End If

    '画面を閉じる
    Unload Me
    
End Sub


Private Sub cmdStcItemCd_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '項目ガイド表示用
    
    Dim i               As Long     'インデックス
    Dim strKey          As String   '重複チェック用のキー
    Dim strItemString   As String
    Dim strItemKey      As String   'リストビュー用アイテムキー
    Dim strItemCdString As String   '表示用キー編集領域
    
    Dim lngItemCount    As Long     '選択項目数
    Dim vntItemCd       As Variant  '選択された項目コード
    Dim vntItemName     As Variant  '選択された項目名
    
    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_REQUEST
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
        .MultiSelect = False
        .ResultType = RESULTTYPE_SENTENCE
    
        'コーステーブルメンテナンス画面を開く
        .Show vbModal
    
        '戻り値としてのプロパティ取得
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntItemName = .ItemName
    
    End With

    '選択されたいるなら値をセット
    If lngItemCount > 0 Then
        
        mstrStcItemCd = vntItemCd(0)
        lblStcItemCd.Caption = vntItemCd(0) & "：" & vntItemName(0)
        
        '管理している文章一覧を表示する
        Call EditSentenceList(mstrStcItemCd)
    
    End If

End Sub

' @(e)
'
' 機能　　 : 「フォーム」Load
'
' 機能説明 : フォームの初期表示を行う
'
' 備考　　 :
'
Private Sub Form_Load()

    Dim Ret As Boolean  '戻り値
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    mintColKey = 0
    mintKarteColKey = 0
    
    '画面初期化
    Call InitializeForm

    Do
        
        'オブジェクトコレクション作成（新規作成時を考慮し、ここで作成）
        Set mcolItemHistory = Nothing
        Set mcolKarteItem = Nothing
        Set mcolItemHistory = New Collection
        Set mcolKarteItem = New Collection
        
        '検査項目情報の表示編集
        If EditItem_c() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtItemCd.Enabled = (txtItemCd.Text = "")
        txtSuffix.Enabled = (txtSuffix.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' 機能　　 : データの保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 変更されたデータをテーブルに保存する
'
' 備考　　 :
'
Private Function ApplyData() As Boolean

    ApplyData = False
    
    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then Exit Function
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    Do
        '入力チェック
        If CheckValue() = False Then Exit Do
        
        '検査項目テーブルの登録
        If RegistItem_c() = False Then Exit Do

        '更新フラグを初期化
        mblnEditMain = False
        mblnEditItemHistory = False
        mblnEditOpe = False
        mblnEditJud = False
        
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Function

' @(e)
'
' 機能　　 : フォームコントロールの初期化
'
' 機能説明 : コントロールを初期状態に変更する。
'
' 備考　　 :
'
Private Sub InitializeForm()

    Dim Ctrl        As Object
    Dim i           As Integer
    Dim objHeader   As ColumnHeaders        'カラムヘッダオブジェクト
    
    tabMain.Tab = 0                 '先頭タブをActive
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    'タブクリック制御フラグ初期化
    mblnShowHistory = False
    mblnShowOpe = False
    mblnShowJud = False
    mblnShowGov = False
    
    '更新チェック用フラグ初期化
    mblnEditMain = False
    mblnEditItemHistory = False
    mblnEditOpe = False
    mblnEditJud = False
    
    '--- メインタブ
    '検索文字列コンボ初期化
    Call InitSearchCharCombo(cboSearchChar)
    
    '結果タイプ用コンボ編集
    With cboResultType
        .AddItem "0:数値を格納します"
        .AddItem "1:定性（標準：-,+-,+）を格納します"
        .AddItem "2:定性（拡張：-,+-,1+～9+）を格納します"
        .AddItem "3:結果内容を固定しません（フリー）"
        .AddItem "4:文章結果を格納します"
        .AddItem "5:計算項目です"
        .AddItem "6:日付を格納します"
        
'### 2003/11/19 Added by Ishihara@FSIT 聖路加専用追加
        .AddItem "7:メモタイプを格納します"
        .AddItem "8:符号つき数字を格納します"
'### 2003/11/19 Added End
        
        .ListIndex = 0
    End With
    
    '項目タイプ用コンボ編集
    With cboItemType
        .AddItem "0:標準"
        .AddItem "1:この項目は「部位」を表します"
        .AddItem "2:この項目は「所見」を表します"
        .AddItem "3:この項目は「処置」を表します"
        .ListIndex = 0
    End With
    
    '最近使った文章管理数
    With cboRecentCount
        For i = 0 To 9
            .AddItem i & "個"
        Next i
        .ListIndex = 0
    End With
    
    '--- 検査項目タブ
    cmdEditHistory.Enabled = False
    cmdDeleteHistory.Enabled = False
    
    '--- 文章タブ
'    optStcMySelf_Click (0)
    
'## 2003.03.13 Add 5Lines By H.Ishihara@FSIT 報告書未出力フラグはデフォルトでON
    '報告書未出力フラグはデフォルトでON
    chkNoPrintFlg.Value = vbChecked
'## 2003.03.13 Add End
    
End Sub

' @(e)
'
' 機能　　 : 文章参照先設定オプションボタンクリック
'
' 機能説明 : 参照用コントロールの使用可否状態を制御する
'
' 備考　　 :
'
Private Sub optStcMySelf_Click(Index As Integer)

    Dim strItemCd   As String

    If Index = 0 Then
        '参照なし
        cmdStcItemCd.Enabled = False
        lblStcItemCd.ForeColor = vbGrayText
        
        strItemCd = txtItemCd.Text
        
        '参照先文章コードを自分に設定
'        mstrStcItemCd = txtItemCd.Text
    
    Else
        '参照あり
        cmdStcItemCd.Enabled = True
        lblStcItemCd.ForeColor = vbButtonText
    
        '参照先コードが現在の検査項目コードと違う場合のみ文章一覧を表示
'        If txtItemCd.Text <> mstrStcItemCd Then
'            Call EditSentenceList
'        End If
    
        strItemCd = mstrStcItemCd
    
    End If
    

        '管理している文章一覧を表示する
        Call EditSentenceList(strItemCd)
    
End Sub

' @(e)
'
' 機能　　 : タブクリック
'
' 機能説明 : クリックされたタブに応じて表示制御を行う
'
' 備考　　 :
'
Private Sub tabMain_Click(PreviousTab As Integer)

    'クリックされたタブに応じて処理実行
    Select Case tabMain.Tab
        Case 1
            '履歴管理タブ
            Call EditHistoryTab
        Case 3
            '文章結果表示タブ
            Call CntlSentenceTab(cboResultType.ListIndex = RESULTTYPE_SENTENCE)
    End Select
    
End Sub


' @(e)
'
' 機能　　 : 検査項目履歴データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査項目に存在する履歴データを表示する
'
' 備考　　 :
'
Private Function EditItemHistory() As Boolean

    Dim objItem_c           As Object           '検査項目アクセス用
    Dim objItemHistory      As ItemHistory      '検査項目履歴データ格納用オブジェクト
    Dim objKarteItem        As KarteItem        '電カル変換用データ格納用オブジェクト
    
    '検査項目履歴データ
    Dim vntHistoryCount     As Variant          '履歴数
    Dim vntItemHNo          As Variant          '検査項目履歴Ｎｏ
    Dim vntStrDate          As Variant          '使用開始日付
    Dim vntEndDate          As Variant          '使用終了日付
    Dim vntFigure1          As Variant          '整数部桁数
    Dim vntFigure2          As Variant          '小数部桁数
    Dim vntMaxValue         As Variant          '最大値
    Dim vntMinValue         As Variant          '最小値
    Dim vntInsItemCd        As Variant          '検査用項目コード
    Dim vntUnit             As Variant          '単位
    Dim vntDefResult        As Variant          '省略時検査結果
    Dim vntDefRslCmtCd      As Variant          '省略時結果コメントコード
    Dim vntReqItemCd        As Variant
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除
'    Dim vntSepOrderDiv      As Variant
'## 2003.11.23 Deleted By H.Ishihara@FSIT 聖路加不要項目の削除

    '電子カルテ用項目変換データ
'    Dim vntKarteItemHNo     As Variant          '検査項目履歴Ｎｏ
    Dim vntKarteDocCd       As Variant          '電カル用文書種別コード
    Dim vntKarteItemAttr    As Variant          '電カル用項目属性
    Dim vntKarteItemcd      As Variant          '電カル用項目コード
    Dim vntKarteItemName    As Variant          '電カル用項目名
    Dim vntKarteTagName     As Variant          '電カル用タグ名称
    Dim lngKarteItemCount   As Long             '電カル用項目設定数

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
    Dim vntInsSuffix        As Variant          '検査用サフィックス
    Dim vntEUnit            As Variant          '英語単位
'### 2004/1/15 Added End

    Dim i           As Long             'インデックス
    Dim Ret         As Boolean
    
    EditItemHistory = False
'
'    '初期化
'    mintColKey = 0

    '新規作成時は処理終了
    If (mstrItemCd = "") Or (mstrSuffix = "") Then
        Exit Function
    End If

    'コンボボックスクリアー
    cboHistory.Clear
    
    'オブジェクトのインスタンス作成
    Set objItem_c = CreateObject("HainsItem.Item")
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
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
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加項目の追加
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
        
        '履歴オブジェクト（コレクション）の作成
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
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
'            .SepOrderDiv = vntSepOrderDiv(i)

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
            .InsSuffix = vntInsSuffix(i)
            .eUnit = vntEUnit(i)
'### 2004/1/15 Added End
        
        End With
        mcolItemHistory.Add objItemHistory, mstrColKeyPrefix & i
        Set objItemHistory = Nothing
        
        'コレクションキーの退避（コンボボックスからの参照用）
        ReDim Preserve mstrItemHistoryKey(i)
        mstrItemHistoryKey(i) = mstrColKeyPrefix & i
        
        'コンボの名称追加
        cboHistory.AddItem CStr(vntStrDate(i)) & "～" & CStr(vntEndDate(i)) & "に適用するデータ"
    
    Next i
    
    'コレクションキーの最大値管理用
    mintColKey = i

    If CInt(vntHistoryCount) > 0 Then
        
        '履歴データが存在するなら、コンボ選択
        cboHistory.ListIndex = 0
        
'### 2003.01.23 Modified by Ishihara@FSIT 電カル関係なし
'        '電子カルテ項目変換データの取得
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
'        '電子カルテ項目変換データのオブジェクトセット
'        For i = 0 To lngKarteItemCount - 1
'
'            '履歴オブジェクト（コレクション）の作成
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
        
        'コレクションキーの最大値管理用
        mintKarteColKey = i

        '受診検査項目の表示
        Call EditItemHistoryFromCollection
            
        '履歴が１個しかないときは削除ボタンは無効
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
' 機能　　 : 検査項目タブクリック
'
' 機能説明 : 履歴情報及び、受診検査項目の表示を行う
'
' 備考　　 :
'
Private Sub EditHistoryTab()

    Dim blnStatus       As Boolean
    Dim blnCboStatus    As Boolean

    '処理中フラグを更新中に変更
    mblnNowEdit = True

    '検査項目履歴コンボの設定（初めて表示、もしくはデータ変更した後のみ）
    If mblnShowHistory = False Then
        blnStatus = EditItemHistory()
    End If

    blnStatus = (cboHistory.ListCount > 0)

    'コントロールのイネーブル制御（履歴コンボの有無により設定）
    cmdNewHistory.Enabled = (mstrItemCd <> "")
    cmdEditHistory.Enabled = blnStatus
    
    If cboHistory.ListCount < 2 Then
        cmdDeleteHistory.Enabled = False
    Else
        cmdDeleteHistory.Enabled = True
    End If
    
    '処理中フラグを未処理に変更
    mblnNowEdit = False
    
    'データ表示済みとして定義
    mblnShowHistory = True
    
End Sub

' @(e)
'
' 機能　　 : 判定分類タブクリック
'
' 機能説明 : 検査項目内管轄の判定分類を表示する
'
' 備考　　 :
'
Private Sub EditJudClassTab()

    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    '処理中フラグを更新中に変更
    mblnNowEdit = True

    '検査項目判定分類の表示編集
'    Call EditListJud
    
    '処理中フラグを未処理に変更
    mblnNowEdit = False
    
    'データ表示済みとして定義
    mblnShowJud = True
    
End Sub


' @(e)
'
' 機能　　 : 検査項目履歴編集ウインドウ表示
'
' 引数　　 : (In)      modeNew  TRUE:新規モード、FALSE:更新モード
'
' 機能説明 :
'
' 備考　　 :
'
Private Sub ShowItem_h(modeNew As Boolean)
    
    Dim objTargetItemHistory    As ItemHistory
    Dim objKarteItem            As KarteItem
    Dim colWork                 As Collection
    
    With frmItem_h
        
        .ItemInfo = txtItemCd.Text & "-" & txtSuffix.Text & "：" & txtItemName.Text
        
        If modeNew = True Then
            
            '新規モードの場合、デフォルト値セット
            Call AddNewHistory
        
        End If
            
        'コレクションから対象アイテムの抽出
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
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        .InsSuffix = objTargetItemHistory.InsSuffix
        .eUnit = objTargetItemHistory.eUnit
'### 2004/1/15 Added End
        
        .Show vbModal
    
        'データを更新されたら、画面データ再編集
        If .Updated = True Then
            
'            '新規モードの場合、オブジェクト新規作成
'            If modeNew = True Then
'                Set objTargetItemHistory = New ItemHistory
'            End If
                
            'フォームの値をセット（履歴データ）
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
            
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
            objTargetItemHistory.InsSuffix = .InsSuffix
            objTargetItemHistory.eUnit = .eUnit
'### 2004/1/15 Added End
            
            'フォームの値をセット（電子カルテデータ）
            mintKarteColKey = .KarteColKey
            Set colWork = .KarteItem
            
            '電カル変換コレクション再セット
            Set mcolKarteItem = New Collection
            
            For Each objKarteItem In colWork
                mcolKarteItem.Add objKarteItem, objKarteItem.UniqueKey
                Set objKarteItem = Nothing
            Next objKarteItem
                        
'            If modeNew = True Then
'                '新規モードの場合
'
'                'コレクションキーの最大値カウントアップ＆セット
'                mintColKey = mintColKey + 1
'                objTargetItemHistory.UniqueKey = mstrColKeyPrefix & mintColKey
'
'                'コレクションの追加
'                mcolItemHistory.Add objTargetItemHistory, mstrColKeyPrefix & mintColKey
'
'                'コレクションキーの退避（コンボボックスからの参照用）
'                ReDim Preserve mstrItemHistoryKey(mcolItemHistory.Count - 1)
'                mstrItemHistoryKey(mcolItemHistory.Count - 1) = mstrColKeyPrefix & mintColKey
'
'                'コンボの名称追加
'                cboHistory.AddItem .strDate & "～" & .endDate & "に適用するデータ"
'                cboHistory.ListIndex = cboHistory.NewIndex
'
'            Else
'
                'コンボ内容編集
                cboHistory.List(cboHistory.ListIndex) = CStr(.strDate) & "～" & CStr(.endDate) & "に適用するデータ"
            
'            End If
            
            '画面再表示
            Call EditItemHistoryFromCollection
            
            '検査項目履歴フラグを更新済みに変更
            mblnEditItemHistory = True

        End If
        
    End With

    Set objTargetItemHistory = Nothing
    Set frmItem_h = Nothing

End Sub

' @(e)
'
' 機能　　 : 基準値履歴データの新規作成
'
' 引数　　 : なし
'
' 機能説明 : 新規作成時に基準値履歴データをデフォルト作成する
'
' 備考　　 :
'
Private Sub AddNewHistory()
    
    Dim objTargetItemHistory    As ItemHistory
    
    'オブジェクトを新規作成
    Set objTargetItemHistory = New ItemHistory
    With objTargetItemHistory
        .ItemHNo = "XXXX" & mintColKey         '新規なので有り得ない番号をセット
        .strDate = YEARRANGE_MIN & "/01/01"
        .endDate = YEARRANGE_MAX & "/12/31"
        .Figure1 = 8
        .Figure2 = 0
    End With
    
    'コレクションキーの最大値カウントアップ＆セット
    mintColKey = mintColKey + 1
    objTargetItemHistory.UniqueKey = mstrColKeyPrefix & mintColKey
    
    'コレクションの追加
    mcolItemHistory.Add objTargetItemHistory, mstrColKeyPrefix & mintColKey
    
    'コレクションキーの退避（コンボボックスからの参照用）
    ReDim Preserve mstrItemHistoryKey(mcolItemHistory.Count - 1)
    mstrItemHistoryKey(mcolItemHistory.Count - 1) = mstrColKeyPrefix & mintColKey
    
    'コンボの名称追加
    cboHistory.AddItem YEARRANGE_MIN & "/01/01" & "～" & YEARRANGE_MIN & "/12/31" & "に適用するデータ"
    cboHistory.ListIndex = cboHistory.NewIndex
    
    '検査項目履歴フラグを更新済みに変更
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
' 機能　　 : 検査項目履歴内容表示（コレクション）
'
' 機能説明 : 検査項目履歴内容をコレクションから表示する
'
' 備考　　 :
'
Private Sub EditItemHistoryFromCollection()

    Dim objTargetItemHistory    As ItemHistory
    Dim objItem                 As ListItem
    Dim objKarteItem            As KarteItem        '電カル変換用データ格納用オブジェクト
    
    'ラベル情報初期化
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
    
    'コレクションから対象アイテムの抽出
    Set objTargetItemHistory = mcolItemHistory(mstrItemHistoryKey(cboHistory.ListIndex))
    
    '履歴データの画面表示
    With objTargetItemHistory
        lblFigure1.Caption = .Figure1
        lblFigure2.Caption = .Figure2
        lblMaxValue.Caption = .MaxValue
        lblMinValue.Caption = .MinValue
        lblinsItemCd.Caption = .InsItemCd
        lblUnit.Caption = .Unit
        lblDefResult.Caption = .DefResult
        lblReqItemCd.Caption = .ReqItemCd
'## 2003.11.23 Modified By H.Ishihara@FSIT 聖路加不要項目の削除
'        If .SepOrderDiv = "1" Then
'            lblReqItemCd.Caption = lblReqItemCd.Caption & "　（分割して検査依頼）"
'        End If

'        lblDefRslCmtCd.Caption = .DefRslCmtCd
    End With
    
'## 2003.01.23 Deleted *Lines By H.Ishihara@FSIT 電カルロジックは不要
'    '電カル変換項目リストビュー設定
'    lsvKarteItem.ListItems.Clear
'
'    'ヘッダの編集
'    With lsvKarteItem.ColumnHeaders
'        .Clear
'        .Add , , "文書種別コード", 1000, lvwColumnLeft
'        .Add , , "項目属性", 1000, lvwColumnLeft
'        .Add , , "項目コード", 1000, lvwColumnLeft
'        .Add , , "項目名", 1500, lvwColumnLeft
'        .Add , , "タグ名", 1200, lvwColumnLeft
'    End With
'
'    lsvKarteItem.View = lvwReport
'
'    '電子カルテ項目情報の編集
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
' 機能　　 : 文章タブ制御
'
' 機能説明 : 結果タイプによって文章タブの使用可否状態を制御する。
'
' 備考　　 :
'
Private Sub CntlSentenceTab(blnSentenceEnabled As Boolean)

    '指定された状態で使用可否を制御
    cboItemType.Enabled = blnSentenceEnabled
    optStcMySelf(0).Enabled = blnSentenceEnabled
    optStcMySelf(1).Enabled = blnSentenceEnabled
    cmdStcItemCd.Enabled = blnSentenceEnabled
    lsvStc.Enabled = blnSentenceEnabled
    cboRecentCount.Enabled = blnSentenceEnabled

    'ラベル系の制御
    If blnSentenceEnabled = True Then
        lblStcItemCd.ForeColor = vbButtonText
        LabelRecentCount.ForeColor = vbButtonText
    
        'オプションボタンの制御を利かせる（ついでに文章も表示してくれる）
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
' 機能　　 : 文章結果表示
'
' 機能説明 : この項目で管理している文章結果を表示する
'
' 備考　　 :
'
Private Sub EditSentenceList(strItemCd As String)

On Error GoTo ErrorHandle

    Const KEY_PREFIX = "K"
    Const KEY_SEPARATE = "-"
    
    Dim objSentence     As Object           '文章アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    
    Dim vntItemCd       As Variant          '検査項目コード
    Dim vntItemType     As Variant          '項目タイプ
    Dim vntStcCd        As Variant          '文章コード
    Dim vntShortStc     As Variant          '略称
    Dim vntLongStc      As Variant          '正式文章
    Dim vntRequestName  As Variant          '依頼項目名
    
    Dim lngCount        As Long             'レコード数
    Dim i               As Long             'インデックス
    
    '検査項目コードが空白なら処理終了（新規作成のときとかね）
    If strItemCd = "" Then Exit Sub
    
    '現在選択されている結果タイプが文章でないなら処理終了
    If cboResultType.ListIndex <> RESULTTYPE_SENTENCE Then Exit Sub

    'オブジェクトのインスタンス作成
    Set objSentence = CreateObject("HainsSentence.Sentence")
    lngCount = objSentence.SelectSentenceList(strItemCd, _
                                              cboItemType.ListIndex, _
                                              vntStcCd, _
                                              vntShortStc)
    
    'ヘッダの編集
    lsvStc.ListItems.Clear
    Set objHeader = lsvStc.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "文章コード", 1000, lvwColumnLeft
    objHeader.Add , , "文章名", 5000, lvwColumnLeft
        
    lsvStc.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvStc.ListItems.Add(, KEY_PREFIX & mstrStcItemCd & KEY_SEPARATE & cboItemType.ListIndex & KEY_SEPARATE & vntStcCd(i) _
                                            , vntStcCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntShortStc(i)
    Next i
    
    'オブジェクト廃棄
    Set objSentence = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    

End Sub
