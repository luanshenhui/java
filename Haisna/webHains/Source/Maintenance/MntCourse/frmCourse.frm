VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmCourse 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "コース情報の設定"
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
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
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
      Caption         =   "キャンセル"
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
         Name            =   "ＭＳ ゴシック"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      TabCaption(0)   =   "コース"
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
      TabCaption(1)   =   "検査項目"
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
      TabCaption(2)   =   "コース判定分類"
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
      TabCaption(3)   =   "その他"
      TabPicture(3)   =   "frmCourse.frx":0060
      Tab(3).ControlEnabled=   -1  'True
      Tab(3).Control(0)=   "Frame3"
      Tab(3).Control(0).Enabled=   0   'False
      Tab(3).Control(1)=   "Frame4"
      Tab(3).Control(1).Enabled=   0   'False
      Tab(3).ControlCount=   2
      TabCaption(4)   =   "検査項目実施日"
      TabPicture(4)   =   "frmCourse.frx":007C
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "Image1(2)"
      Tab(4).Control(1)=   "LabelOperationGuide"
      Tab(4).Control(2)=   "Label6"
      Tab(4).Control(3)=   "lsvCourse_Ope"
      Tab(4).Control(4)=   "cmdEditCourse_Ope"
      Tab(4).ControlCount=   5
      TabCaption(5)   =   "財務連携"
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
            Caption         =   "請求書に単価を印字しない(&N)"
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
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   45
            Top             =   1980
            Visible         =   0   'False
            Width           =   4155
         End
         Begin VB.ComboBox cboKarteReportCd 
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   300
            Left            =   1680
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   43
            Top             =   1620
            Width           =   4155
         End
         Begin VB.TextBox txtEndTime 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   3960
            MaxLength       =   4
            TabIndex        =   41
            Text            =   "1234"
            Top             =   1140
            Width           =   555
         End
         Begin VB.TextBox txtStartTime 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1740
            MaxLength       =   4
            TabIndex        =   39
            Text            =   "1234"
            Top             =   1140
            Width           =   555
         End
         Begin VB.CheckBox chkRoundFlg 
            Caption         =   "任意の検査項目を追加した場合、金額計上する(&A)"
            Height          =   255
            Left            =   240
            TabIndex        =   36
            Top             =   300
            Width           =   5295
         End
         Begin VB.Label Label8 
            Caption         =   "標準報告書(&H):"
            Height          =   195
            Index           =   3
            Left            =   180
            TabIndex        =   44
            Top             =   2040
            Visible         =   0   'False
            Width           =   1335
         End
         Begin VB.Label Label11 
            Caption         =   "カルテ用帳票(&K)："
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
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
            Caption         =   "検査終了時間(&E)："
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
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
            Caption         =   "検査開始時間(&S)："
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
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
         Caption         =   "定期健康診断対象コース"
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
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   10
         Top             =   2760
         Width           =   3390
      End
      Begin VB.ComboBox cboCsDiv 
         Height          =   300
         ItemData        =   "frmCourse.frx":013C
         Left            =   -73320
         List            =   "frmCourse.frx":015E
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   8
         Top             =   2400
         Width           =   4530
      End
      Begin VB.TextBox txtCsSName 
         Height          =   318
         IMEMode         =   4  '全角ひらがな
         Left            =   -73320
         MaxLength       =   10
         TabIndex        =   6
         Text            =   "人間ドック"
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
               Name            =   "ＭＳ Ｐゴシック"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   300
            Left            =   2640
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   67
            Top             =   1560
            Width           =   2535
         End
         Begin VB.ComboBox cboGovMngShaho 
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   300
            Left            =   2640
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   66
            Top             =   2280
            Width           =   2535
         End
         Begin VB.ComboBox cboGovMng12Div 
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
               Size            =   9
               Charset         =   128
               Weight          =   400
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   300
            Left            =   2640
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   65
            Top             =   1920
            Width           =   2535
         End
         Begin VB.OptionButton optGovMng 
            Caption         =   "政府管掌コース(&S)"
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
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
            Caption         =   "政府管掌対象外(&O)"
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
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
            Caption         =   "政府管掌健康診断コースの場合に設定します。"
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
            Caption         =   "政府管掌社保区分(&H)"
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
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
            Caption         =   "政府管掌健診区分(&D):"
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
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
            Caption         =   "政府管掌一次二次区分(&F):"
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
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
         Caption         =   "編集(&E)"
         Enabled         =   0   'False
         Height          =   315
         Left            =   -70020
         TabIndex        =   60
         Top             =   4920
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddJudClass 
         Caption         =   "追加(&D)..."
         Height          =   315
         Left            =   -73380
         TabIndex        =   33
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteJudClass 
         Caption         =   "削除(&R)"
         Height          =   315
         Left            =   -70620
         TabIndex        =   35
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdDownItem 
         Caption         =   "↓"
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
         Caption         =   "↑"
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
         Caption         =   "編集(&E)"
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
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   14
         Top             =   4020
         Width           =   2910
      End
      Begin VB.Frame Frame2 
         Caption         =   "受診項目(&C)"
         Height          =   3375
         Left            =   -74760
         TabIndex        =   25
         Top             =   2820
         Visible         =   0   'False
         Width           =   6015
         Begin VB.CommandButton cmdItemProperty 
            Caption         =   "プロパティ(&O)"
            Height          =   315
            Left            =   4620
            TabIndex        =   29
            Top             =   2940
            Width           =   1275
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "削除(&R)"
            Height          =   315
            Left            =   3240
            TabIndex        =   28
            Top             =   2940
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "追加(&A)..."
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
         Caption         =   "履歴データ(&H)"
         Height          =   1515
         Left            =   -74760
         TabIndex        =   20
         Top             =   1200
         Width           =   6015
         Begin VB.ComboBox cboHistory 
            BeginProperty Font 
               Name            =   "ＭＳ Ｐゴシック"
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
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   21
            Top             =   300
            Width           =   5610
         End
         Begin VB.CommandButton cmdNewHistory 
            Caption         =   "新規(&N)..."
            Enabled         =   0   'False
            Height          =   315
            Left            =   1800
            TabIndex        =   22
            Top             =   720
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditHistory 
            Caption         =   "編集(&E)..."
            Enabled         =   0   'False
            Height          =   315
            Left            =   3180
            TabIndex        =   23
            Top             =   720
            Width           =   1275
         End
         Begin VB.CommandButton cmdDeleteHistory 
            Caption         =   "削除(&D)..."
            Enabled         =   0   'False
            Height          =   315
            Left            =   4560
            TabIndex        =   24
            Top             =   720
            Width           =   1275
         End
         Begin VB.Label lblPrice 
            Alignment       =   1  '右揃え
            Caption         =   "コース基本料金: \50,000"
            Height          =   255
            Left            =   3840
            TabIndex        =   56
            Top             =   1200
            Width           =   1995
         End
         Begin VB.Label lblCsHNo 
            Caption         =   "履歴No: 3"
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
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
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
         IMEMode         =   4  '全角ひらがな
         Left            =   -73320
         MaxLength       =   30
         TabIndex        =   4
         Text            =   "人間ドック"
         Top             =   1680
         Width           =   2835
      End
      Begin VB.TextBox txtCsCd 
         Height          =   315
         IMEMode         =   3  'ｵﾌ固定
         Left            =   -73320
         MaxLength       =   4
         TabIndex        =   1
         Text            =   "1234"
         Top             =   1320
         Width           =   555
      End
      Begin VB.CommandButton cmdWebColor 
         Caption         =   "表示色(&W)"
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
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
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
         TabCaption(0)   =   "個人請求"
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
         TabCaption(1)   =   "団体請求"
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
            Caption         =   "未収(&1)..."
            Height          =   315
            Index           =   0
            Left            =   240
            TabIndex        =   84
            Top             =   540
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "当日入金(&2)..."
            Height          =   315
            Index           =   1
            Left            =   240
            TabIndex        =   83
            Top             =   960
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "過去未収(&3)..."
            Height          =   315
            Index           =   2
            Left            =   240
            TabIndex        =   82
            Top             =   1380
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "還付未払(&4)..."
            Height          =   315
            Index           =   3
            Left            =   240
            TabIndex        =   81
            Top             =   1800
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "還付当日払(&5)..."
            Height          =   315
            Index           =   4
            Left            =   240
            TabIndex        =   80
            Top             =   2220
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "還付後日払(&6)..."
            Height          =   315
            Index           =   5
            Left            =   240
            TabIndex        =   79
            Top             =   2640
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "未収(&1)..."
            Height          =   315
            Index           =   6
            Left            =   -74760
            TabIndex        =   78
            Top             =   540
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "当日入金(&2)..."
            Height          =   315
            Index           =   7
            Left            =   -74760
            TabIndex        =   77
            Top             =   960
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "過去未収(&3)..."
            Height          =   315
            Index           =   8
            Left            =   -74760
            TabIndex        =   76
            Top             =   1380
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "還付未払(&4)..."
            Height          =   315
            Index           =   9
            Left            =   -74760
            TabIndex        =   75
            Top             =   1800
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "還付当日払(&5)..."
            Height          =   315
            Index           =   10
            Left            =   -74760
            TabIndex        =   74
            Top             =   2220
            Width           =   1995
         End
         Begin VB.CommandButton cmdZaimuCd 
            Caption         =   "還付後日払(&6)..."
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
            Caption         =   "個人分（還付当日作成　当日払い"
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
         Caption         =   "メインコース(&S):"
         ForeColor       =   &H80000011&
         Height          =   195
         Left            =   -73320
         TabIndex        =   9
         Top             =   2820
         Width           =   1155
      End
      Begin VB.Label Label8 
         Caption         =   "コース区分(&S):"
         Height          =   195
         Index           =   2
         Left            =   -74760
         TabIndex        =   7
         Top             =   2460
         Width           =   1335
      End
      Begin VB.Label Label2 
         Caption         =   "コース略称(&R):"
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
         Caption         =   "財務連携時に適用するコードを設定します。"
         Height          =   255
         Left            =   -74040
         TabIndex        =   109
         Top             =   660
         Width           =   3555
      End
      Begin VB.Label Label6 
         Caption         =   "※""0""は当日を表します。"
         Height          =   315
         Left            =   -74760
         TabIndex        =   61
         Top             =   4920
         Width           =   2115
      End
      Begin VB.Label LabelOperationGuide 
         Caption         =   "このコースで受診する項目の検査実施日を設定します。"
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
         Caption         =   "このコースで管理する判定分類を設定します。"
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
         Caption         =   "このコースを受診する際に検査する項目を設定します。"
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
         Caption         =   "２次健診(&D):"
         Height          =   195
         Index           =   1
         Left            =   -74760
         TabIndex        =   11
         Top             =   3240
         Width           =   1335
      End
      Begin VB.Label LabelCourseGuide 
         Caption         =   "コースの基本的な情報を設定します。"
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
         Caption         =   "受診時泊数(&S):"
         Height          =   195
         Index           =   0
         Left            =   -74760
         TabIndex        =   18
         Top             =   5280
         Width           =   1335
      End
      Begin VB.Label Label4 
         Caption         =   "当日IDの範囲(I):"
         Height          =   195
         Left            =   -74760
         TabIndex        =   13
         Top             =   4080
         Width           =   1335
      End
      Begin VB.Label Label3 
         Caption         =   "統計区分(&T):"
         Height          =   195
         Left            =   -71400
         TabIndex        =   16
         Top             =   4500
         Width           =   1095
      End
      Begin VB.Label Label2 
         Caption         =   "コース名(&N):"
         Height          =   195
         Index           =   0
         Left            =   -74760
         TabIndex        =   3
         Top             =   1740
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "コースコード(&C):"
         Height          =   195
         Index           =   2
         Left            =   -74760
         TabIndex        =   0
         Top             =   1380
         Width           =   1275
      End
      Begin VB.Label lblWebColor 
         BorderStyle     =   1  '実線
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

'プロパティ用領域
Private mstrCsCd            As String   'コースコード
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnInitialize      As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗

Private mstrArrDayIDDivCd() As String   '当日ＩＤコンボ対応キー格納領域
Private mintBeforeIndex     As Integer  '履歴コンボ変更キャンセル用の前Index
Private mblnNowEdit         As Boolean  'TRUE:編集処理中、FALSE:処理なし

'履歴コンボ対応データ退避用
Private mintCsHNo()         As Integer  '履歴コンボに対応する履歴番号
Private mstrStrDate()       As String   '履歴コンボに対応する開始日付
Private mstrEndDate()       As String   '履歴コンボに対応する終了日付
Private mlngPrice()         As Long     '履歴コンボに対応するコース基本料金

'タブクリック時の表示制御用フラグ
Private mblnShowItem        As Boolean  'TRUE:表示済み、FALSE:未表示
Private mblnShowOpe         As Boolean  'TRUE:表示済み、FALSE:未表示
Private mblnShowJud         As Boolean  'TRUE:表示済み、FALSE:未表示
Private mblnShowGov         As Boolean  'TRUE:表示済み、FALSE:未表示

'保存対象データ制御用
Private mblnEditMain        As Boolean  'コース基本データ（TRUE:更新、FALSE:未更新）
Private mblnEditItem        As Boolean  'コース内検査項目データ（TRUE:更新、FALSE:未更新）
Private mblnEditJud         As Boolean  'コース内判定データ（TRUE:更新、FALSE:未更新）
Private mblnEditOpe         As Boolean  'コース内検査項目実施日データ（TRUE:更新、FALSE:未更新）

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション
Private mcolZaimuCollection     As Collection   '財務連携適用コードコレクション

'固定コード管理
Const GRPDIV_ITEM           As String = "I"
Const GRPDIV_GRP            As String = "G"
Const mstrListViewKey       As String = "K"

Const NOREASON_TEXT         As String = "する"
Private Const KEY_PREFIX    As String = "K"           'コレクションキープリフィックス
Private mstrRootCsCd()      As String   'コンボボックスに対応するコースコードの格納
Private mstrReportCd()      As String   'コンボボックスに対応する報告書帳票コードの格納
Private mstrKarteCd()       As String   'コンボボックスに対応するカルテ帳票コードの格納
Private mstrReportCd_OnRead As String
Private mstrKarteCd_OnRead  As String

Private Sub MoveListItem(intMovePosition As Integer)

    Dim i                   As Integer
    Dim j                   As Integer
    Dim intSelectedCount    As Integer
    Dim intSelectedIndex    As Integer
    Dim intTargetIndex      As Integer
    Dim objItem             As ListItem             'リストアイテムオブジェクト
    
    Dim strEscCd()          As String
    Dim strEscName()        As String
    Dim strEscNoReason()    As String
    
    intSelectedCount = 0

    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvJud.ListItems.Count

        '選択されている項目なら
        If lsvJud.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '選択項目数が１個以外なら処理しない
    If intSelectedCount <> 1 Then Exit Sub
    
    '項目Up指定かつ、選択項目が先頭なら何もしない
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '項目Down指定かつ、選択項目が最終なら何もしない
    If (intSelectedIndex = lsvJud.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    If intMovePosition = -1 Then
        '項目Upの場合、一つ前の要素をターゲットとする。
        intTargetIndex = intSelectedIndex - 1
    Else
        '項目Downの場合、現在の要素をターゲットとする。
        intTargetIndex = intSelectedIndex
    End If
    
    'リストビューをくるくる回して全項目配列作成
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
    
    'ヘッダの編集
    With lsvJud.ColumnHeaders
        .Clear
        .Add , , "コード", 700, lvwColumnLeft
        .Add , , "判定分類", 2500, lvwColumnLeft
        .Add , , "無条件展開", 1500, lvwColumnLeft
    End With
    
    'リストの編集
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

    '更新状態を管理
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
' 機能　　 : 登録データのチェック
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容の妥当性をチェックする
'
' 備考　　 :
'
Private Function CheckValue() As Boolean

    Dim Ret             As Boolean      '関数戻り値
    Dim objListItem     As ListItem
    Dim i               As Integer
    Dim objTimeTextBox  As TextBox      '開始終了時間チェック用テキストボックス
    
    '初期処理
    Ret = False
    
    Do
        If Trim(txtCsCd.Text) = "" Then
            MsgBox "コースコードが入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCsCd.SetFocus
            Exit Do
        End If
        
'### 2003/11/12 Deleted by Ishihara@FSIT 聖路加では３桁
'        If Len(Trim(txtCsCd.Text)) < 4 Then
'            MsgBox "コースコードはバーコードの関係上必ず４桁で設定してください。", vbExclamation, App.Title
'            tabMain.Tab = 0
'            txtCsCd.SetFocus
'            Exit Do
'        End If
'### 2003/11/12 Deleted End

        If Trim(txtCsName.Text) = "" Then
            MsgBox "コース名が入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCsName.SetFocus
            Exit Do
        End If

        '略称がセットされていない場合、強制的に名称先頭５文字格納
        If Trim(txtCsSName.Text) = "" Then
            txtCsSName.Text = Mid(Trim(txtCsName.Text), 1, 5)
        End If

        If (cboCsDiv.ListIndex = 3) And (cboMainCsCd.ListIndex = 0) Then
            MsgBox "サブコースの場合、必ずメインコースを選択してください。", vbExclamation, App.Title
            tabMain.Tab = 0
            cboMainCsCd.SetFocus
            Exit Do
        End If

        If (Trim(txtStaDiv.Text) <> "") And (IsNumeric(Trim(txtStaDiv.Text)) = False) Then
            MsgBox "統計区分には数値を入力してください", vbExclamation, App.Title
            tabMain.Tab = 0
            txtStaDiv.SetFocus
            Exit Do
        End If

        '検査項目実施日のチェック
        If lsvCourse_Ope.ListItems.Count > 0 Then
            
            For Each objListItem In lsvCourse_Ope.ListItems
                If objListItem.SubItems(2) <> "" Then
                    For i = 2 To 8
                        If objListItem.SubItems(i) > cboStay.ListIndex + 1 Then
                            MsgBox "コースの泊数が " & cboStay.ListIndex & "に設定されています。" & _
                                   "指定された検査日は格納することができません。", vbExclamation
                            objListItem.Selected = True
                            tabMain.Tab = 4
                            Exit Do
                        End If
                    Next i
                End If
            Next objListItem
        
        End If

        '開始終了時間の整合性チェック
        For i = 0 To 1
        
            '２回Loopし、開始終了の何れかをセット
            If i = 0 Then
                Set objTimeTextBox = txtStartTime
            Else
                Set objTimeTextBox = txtEndTime
            End If
        
            '入力データが存在する場合のみ、チェック。
            If Trim(objTimeTextBox.Text) <> "" Then
            
                '数値タイプ及び桁数チェック
'### 2003.03.13 Updated by Ishihara@FSIT Oracleに格納すると３桁になることの考慮もれ
'                If (IsNumeric(Trim(objTimeTextBox.Text)) = False) Or (Len(Trim(objTimeTextBox.Text)) <> 4) Then
'                    MsgBox "検査時間には数値（時分の４桁）を入力してください", vbExclamation, App.Title
'                    tabMain.Tab = 3
'                    objTimeTextBox.SetFocus
'                    Exit Do
'                End If
                
                '数値タイプチェック
                If IsNumeric(Trim(objTimeTextBox.Text)) = False Then
                    MsgBox "検査時間には数値（時分の４桁）を入力してください", vbExclamation, App.Title
                    tabMain.Tab = 3
                    objTimeTextBox.SetFocus
                    Exit Do
                End If

                'チェック用に４桁変換
                objTimeTextBox.Text = Format(Trim(objTimeTextBox.Text), "0000")
'### 2003.03.13 Updated End
            
                If CInt(Mid((Trim(objTimeTextBox.Text)), 1, 2)) > 25 Then
                    MsgBox "正しい時間をセットしてください。", vbExclamation, App.Title
                    tabMain.Tab = 3
                    objTimeTextBox.SetFocus
                    Exit Do
                End If
            
                If CInt(Mid((Trim(objTimeTextBox.Text)), 3, 2)) > 59 Then
                    MsgBox "正しい時間をセットしてください。", vbExclamation, App.Title
                    tabMain.Tab = 3
                    objTimeTextBox.SetFocus
                    Exit Do
                End If
            
            End If
        
        Next i

'### 2002.11.12 Del By H.Ishihara@FSIT 東急殿仕様に財務関連情報は不要
'        '財務連携用コードの設定チェック
''### 2002.03.23 Updated By H.Ishihara@FSIT 還付は使用しない
''        For i = 0 To 11
''            If lblZaimuCd(i).Caption = "" Then
''                MsgBox "財務連携用の適用コードは必ず設定してください", vbExclamation, App.Title
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
'                MsgBox "財務連携用の適用コードは必ず設定してください", vbExclamation, App.Title
'                tabMain.Tab = 5
'                tabZaimu.Tab = 0
'                Exit Do
'            End If
'        Next i
'
'        For i = 6 To 8
'            If lblZaimuCd(i).Caption = "" Then
'                MsgBox "財務連携用の適用コードは必ず設定してください", vbExclamation, App.Title
'                tabMain.Tab = 5
'                tabZaimu.Tab = 1
'                Exit Do
'            End If
'        Next i
''### 2002.03.23 Updated By H.Ishihara@FSIT 還付は使用しない
'### 2002.11.12 Del End

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

' @(e)
'
' 機能　　 : 基本コース情報画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : コースの基本情報を画面に表示する
'
' 備考　　 :
'
Private Function EditCourse() As Boolean

On Error GoTo ErrorHandle

    Dim objCourse       As Object               'コース情報アクセス用
    
    Dim vntCsName       As Variant              'コース名
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
    Dim Ret                 As Boolean              '戻り値
    Dim lngCount            As Long
    
    EditCourse = False
    
    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrCsCd = "" Then
            Ret = True
            Exit Do
        End If
        
        'コーステーブルレコード読み込み
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
            
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If

        '読み込み内容の編集（コース基本情報）
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
        
        'WEBカラーセット
        If Len(vntWebColor) = 6 Then
            'カラー設定ぐらいで落とさない
            On Error Resume Next
            lblWebColor.BackColor = RGB("&H" & Mid(vntWebColor, 1, 2), "&H" & Mid(vntWebColor, 3, 2), "&H" & Mid(vntWebColor, 5, 2))
            On Error GoTo 0
        End If
        
        lblColor.Caption = vntWebColor
    
        'デフォルトセットされた判定分類をセット
        If vntDayIDDiv <> "" Then
            For i = 0 To UBound(mstrArrDayIDDivCd)
                If mstrArrDayIDDivCd(i) = vntDayIDDiv Then
                    cboDayIDDiv.ListIndex = i
                End If
            Next i
        End If
        
        '読み込み内容の編集（政府管掌情報）
        optGovMng(CInt(vntGovMng)).Value = True
        cboGovMngDiv.ListIndex = CInt(vntGovMngDiv)
        cboGovMng12Div.ListIndex = CInt(vntGovMng12Div)
        cboGovMngShaho.ListIndex = CInt(vntGovMngShaho)
    
        If vntNoPrintMonoPrice = "1" Then
            chkNoPrintMonoPrice.Value = vbChecked
        Else
            chkNoPrintMonoPrice.Value = vbUnchecked
        End If
    
    
        '財務連携情報のセット
        For i = 0 To 11
            lblZaimuCd(i).Caption = vntZaimuCd(i)
            lblZaimuName(i).Caption = GetZaimuNameFromCollection(CStr(vntZaimuCd(i)))
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    'インスタンス作成ついでにメインコースコンボを設定
    cboMainCsCd.Clear
    Erase mstrRootCsCd
    
    'コース一覧取得（メインのみ）
    lngCount = objCourse.SelectCourseList(vntMainCsCdList, vntMainCsName, , 3)
    
    'コースは未指定あり
    ReDim Preserve mstrRootCsCd(0)
    mstrRootCsCd(0) = ""
    cboMainCsCd.AddItem ""
    cboMainCsCd.ListIndex = 0
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootCsCd(i + 1)
        mstrRootCsCd(i + 1) = vntMainCsCdList(i)
        cboMainCsCd.AddItem vntMainCsName(i)
        If vntMainCsCdList(i) = vntMainCsCd Then
            cboMainCsCd.ListIndex = i + 1
        End If
    Next i
    
    '戻り値の設定
    EditCourse = Ret
    
    Exit Function

ErrorHandle:

    EditCourse = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : コース基本情報の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容をコーステーブルに保存する。
'
' 備考　　 :
'
Private Function RegistCourse() As Boolean

On Error GoTo ErrorHandle

    Dim objCourse           As Object       'コースアクセス用
    Dim i                   As Integer
    Dim j                   As Integer
    Dim k                   As Integer
    Dim lngRet              As Long
    
    'コース内検査項目、グループ用変数
    Dim intItemCount        As Integer      'コース内検査項目数
    Dim intGrpCount         As Integer      'コース内グループ項目数
    Dim vntItemCd()         As Variant      'コース内検査項目用配列
    Dim vntGrpCd()          As Variant      'コース内グループ用配列
    
    Dim strTargetKey        As String       'キー値編集用変数
    Dim strTargetDiv        As String       '項目 or グループの区分
    Dim strTargetCd         As String       'キー値編集用変数
    Dim strWkMainCsCd       As String
    
    Dim intCsHNo            As Integer
    
    'コース内判定分類用変数
    Dim intJudClassCount    As Integer      'コース内検査項目数
    Dim vntJudClassCd()     As Variant
    Dim vntNoReason()       As Variant
    Dim vntSeq()            As Variant
    Dim strWorkKey          As String
    Dim lngPointer          As Long
    Dim intNoReason         As Integer
    
    '検査項目実施日用変数
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
    
    '初期化
    intItemCount = 0
    intGrpCount = 0
    intOpeClassCount = 0
    Erase vntItemCd
    Erase vntGrpCd
    j = 0
    k = 0

    'コース内グループもしくは検査項目の格納用編集
    For i = 1 To lsvItem.ListItems.Count
        
        'キー値を分割
        strTargetKey = lsvItem.ListItems(i).Key
        strTargetDiv = Mid(strTargetKey, 1, 1)
        strTargetCd = Mid(strTargetKey, 2, Len(strTargetKey))
        
        'キー値先頭文字列をチェック
        If strTargetDiv = GRPDIV_ITEM Then
            '依頼項目なら
            intItemCount = intItemCount + 1
            ReDim Preserve vntItemCd(j)
            vntItemCd(j) = strTargetCd
            j = j + 1
        Else
            'グループなら
            intGrpCount = intGrpCount + 1
            ReDim Preserve vntGrpCd(k)
            vntGrpCd(k) = strTargetCd
            k = k + 1
        End If
    
    Next i

    '検査項目タブを表示していない（つまり未修正）なら履歴番号にゼロセット（コンボそのままなら未セットなのでこける）
    If mblnEditItem = False Then
        intCsHNo = 0
    Else
        intCsHNo = mintCsHNo(cboHistory.ListIndex)
    End If

    '検査項目実施日のチェック
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

    'コース判定分類の格納用編集
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

    'メインコースコードのセット
    strWkMainCsCd = txtCsCd.Text
    If cboCsDiv.ListIndex = 3 Then strWkMainCsCd = mstrRootCsCd(cboMainCsCd.ListIndex)

    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")

    'コーステーブルレコードの登録
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

    '戻り値がダブリありの場合
    If lngRet = INSERT_DUPLICATE Then
        MsgBox "入力されたコースコードは既に存在します。", vbExclamation
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
' 機能　　 : 「コース履歴コンボ」Click
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
    
    '履歴コンボが一つしかない場合は、処理終了
    If cboHistory.ListCount = 1 Then Exit Sub
    
    '現在の状態が更新されていたら、警告
    If mblnEditItem = True Then
        strMsg = "受診項目内容が更新されています。履歴データを再表示すると変更内容が破棄されます" & vbLf & _
                 "よろしいですか？"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then
            mblnNowEdit = True                          '無限Loop防止のため、処理制御
            cboHistory.ListIndex = mintBeforeIndex      'コンボインデックスを元に戻す
            mblnNowEdit = False                         '処理中解除
            Exit Sub
        End If
    End If
    
    '受診検査項目の表示
    Call EditListItem

    '現在のIndexを保持
    mintBeforeIndex = cboHistory.ListIndex

    '未更新状態に初期化
    mblnEditItem = False
    mblnNowEdit = False

End Sub


' @(e)
'
' 機能　　 : 「項目追加」Click
'
' 機能説明 : 指定コース履歴に受診項目を追加する
'
' 備考　　 :
'
Private Sub cmdAddItem_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '項目ガイド表示用
    Dim objItem         As ListItem                 'リストアイテムオブジェクト
    
    Dim lngCount        As Long     'レコード数
    Dim i               As Long     'インデックス
    Dim strKey          As String   '重複チェック用のキー
    
    Dim lngItemCount    As Long     '選択項目数
    Dim vntItemDiv      As Variant  '選択されたアイテムタイプ
    Dim vntItemCd       As Variant  '選択された項目コード
    Dim vntSuffix       As Variant  '選択されたサフィックス
    Dim vntItemName     As Variant  '選択された項目名
    Dim vntClassName    As Variant  '選択された検査分類名
    
    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_REQUEST
        .Group = GROUP_SHOW
        .Item = ITEM_SHOW
        .Question = QUESTION_OFF
    
        'コーステーブルメンテナンス画面を開く
        .Show vbModal
            
        '戻り値としてのプロパティ取得
        lngItemCount = .ItemCount
        vntItemDiv = .ItemDiv
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
        vntItemName = .ItemName
        vntClassName = .ClassName
    
    End With
    
    Screen.MousePointer = vbHourglass
    Me.Refresh
    
    '選択件数が0件以上なら
    If lngItemCount > 0 Then

        'リストの編集
        For i = 0 To lngItemCount - 1

            'リスト上に存在するかチェックする
            strKey = vntItemDiv & vntItemCd(i)
            If CheckExistsItemCd(lsvItem, strKey) = False Then

                'なければ追加する
                Set objItem = lsvItem.ListItems.Add(, strKey, vntClassName(i))
                objItem.SubItems(1) = IIf(CStr(vntItemDiv) = GRPDIV_GRP, "グループ", "検査項目")
                objItem.SubItems(2) = vntItemCd(i)
                objItem.SubItems(3) = vntItemName(i)

                '更新状態を管理
                mblnEditItem = True

            End If
        Next i

    End If

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Sub cmdAddJudClass_Click()
    
    Dim objItem         As ListItem                 'リストアイテムオブジェクト
    Dim strKey          As String
    
    With frmAddJudClass
        
        .JudClassCd = 0
        .NoReason = 0
        .Show vbModal
    
        'データを更新されたら、画面データ再編集
        If .Updated = True Then
        
            strKey = mstrListViewKey & .JudClassCd
            If CheckExistsItemCd(lsvJud, strKey) = False Then
            
                'なければ追加する
                Set objItem = lsvJud.ListItems.Add(, strKey, .JudClassCd)
                objItem.SubItems(1) = .JudClassName
                objItem.SubItems(2) = IIf(.NoReason = 1, NOREASON_TEXT, "")
            
                '更新状態を管理
                mblnEditJud = True
            
            End If
        
        End If
        
    End With

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
    Call ApplyData

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
' 機能　　 : コース履歴削除ボタン
'
' 機能説明 : コース履歴データを削除する
'
' 備考　　 :
'
Private Sub cmdDeleteHistory_Click()

On Error GoTo ErrorHandle

    Dim objCourse   As Object       'コーステーブルアクセス用

    Dim lngRet  As Long
    Dim strMsg  As String
    
    '削除確認メッセージ表示
    strMsg = "履歴データ：" & cboHistory.List(cboHistory.ListIndex) & vbLf & vbLf
    strMsg = strMsg & "指定された履歴データを削除します。削除するとその履歴内で指定されていた受診検査項目設定も削除されます。" & vbLf
    strMsg = strMsg & "よろしいですか？" & vbLf & vbLf
    strMsg = strMsg & "注意：この操作はキャンセルすることができません。"

    lngRet = MsgBox(strMsg, vbExclamation + vbYesNo + vbDefaultButton2, "コース履歴情報削除")
    
    'やめるなら処理終了
    If lngRet = vbNo Then Exit Sub
        
    Screen.MousePointer = vbHourglass
        
    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
    
    'コーステーブルレコードの削除
    objCourse.DeleteCourse_h mstrCsCd, mintCsHNo(cboHistory.ListIndex)
    
    'オブジェクトをNothingしないとCommitされない
    Set objCourse = Nothing
    
    '画面データ再編集
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
' 機能　　 : 「項目削除」Click
'
' 機能説明 : 選択された項目をリストから削除する
'
' 備考　　 :
'
Private Sub cmdDeleteItem_Click()

    Dim i As Integer
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvItem.ListItems.Count
        
        'インデックスがリスト項目を越えたら終了
        If i > lsvItem.ListItems.Count Then Exit For
        
        '選択されている項目なら削除
        If lsvItem.ListItems(i).Selected = True Then
            lsvItem.ListItems.Remove (lsvItem.ListItems(i).Key)
            'アイテム数が変わるので-1して再検査
            i = i - 1
            '更新状態を管理
            mblnEditItem = True
        End If
    
    Next i

End Sub

Private Sub cmdDeleteJudClass_Click()

    Dim i As Integer
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvJud.ListItems.Count
        
        'インデックスがリスト項目を越えたら終了
        If i > lsvJud.ListItems.Count Then Exit For
        
        '選択されている項目なら削除
        If lsvJud.ListItems(i).Selected = True Then
            lsvJud.ListItems.Remove (lsvJud.ListItems(i).Key)
            'アイテム数が変わるので-1して再検査
            i = i - 1
            '更新状態を管理
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
    
    '選択中のノードオブジェクトを取得
    Set objListItem = lsvCourse_Ope.SelectedItem

    'ノード非選択時は処理を行わない
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
' 機能　　 : コース履歴修正ボタン
'
' 機能説明 : コース履歴作成用フォーム表示
'
' 備考　　 :
'
Private Sub cmdEditHistory_Click()
    
    '修正モードでコース履歴を表示
    Call ShowCourse_h(False)

End Sub

Private Sub cmdEditJudClass_Click()

    Dim i               As Integer
    Dim strTargetKey    As String
    Dim strTargetDiv    As String
    Dim strTargetCd     As String
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvJud.ListItems.Count
        
        'インデックスがリスト項目を越えたら終了
        If i > lsvJud.ListItems.Count Then Exit For
        
        '選択されている項目なら処理
        If lsvJud.ListItems(i).Selected = True Then
        
            With frmAddJudClass
                .JudClassCd = lsvJud.ListItems(i).Text
                .NoReason = IIf(lsvJud.ListItems(i).SubItems(2) = NOREASON_TEXT, 1, 0)
                
                .Show vbModal
            
                If .Updated = True Then
                    lsvJud.ListItems(mstrListViewKey & .JudClassCd).SubItems(2) = IIf(.NoReason = 1, NOREASON_TEXT, "")
                    '更新状態を管理
                    mblnEditJud = True
                End If
                
            End With
        
            '１つ見せたら上等（先頭だけ）
            Exit Sub
        
        End If
    
    Next i


End Sub

' @(e)
'
' 機能　　 : 「プロパティ」Click
'
' 機能説明 : 選択された項目の情報を表示する。
'
' 備考　　 :
'
Private Sub cmdItemProperty_Click()

    Dim objGrp          As mntGrp.Grp   'グループテーブルメンテナンス用

    Dim i               As Integer
    Dim strTargetKey    As String
    Dim strTargetDiv    As String
    Dim strTargetCd     As String
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvItem.ListItems.Count
        
        'インデックスがリスト項目を越えたら終了
        If i > lsvItem.ListItems.Count Then Exit For
        
        '選択されている項目なら処理
        If lsvItem.ListItems(i).Selected = True Then
        
            'キー値を分割
            strTargetKey = lsvItem.ListItems(i).Key
            strTargetDiv = Mid(strTargetKey, 1, 1)
            strTargetCd = Mid(strTargetKey, 2, Len(strTargetKey))
            
            'キー値先頭文字列をチェック
            If strTargetDiv = GRPDIV_ITEM Then
                '依頼項目なら
            Else
                'グループなら
                'オブジェクトのインスタンス作成
                Set objGrp = New mntGrp.Grp
                
                'プロパティの設定
                objGrp.GrpDiv = MODE_REQUEST
                objGrp.GrpCd = strTargetCd
                objGrp.ShowOnly = True
                
                'グループテーブルメンテナンス画面を開く
                objGrp.Show vbModal
                
                'オブジェクトの廃棄
                Set objGrp = Nothing
            
                '１つ見せたら上等（先頭だけ）
                Exit Sub
            End If
        
        End If
    
    Next i

End Sub

' @(e)
'
' 機能　　 : コース履歴新規作成ボタン
'
' 機能説明 : コース履歴作成用フォーム表示
'
' 備考　　 :
'
Private Sub cmdNewHistory_Click()

    '新規モードでコース履歴を表示
    Call ShowCourse_h(True)
    
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


Private Sub cmdUpItem_Click()

    Call MoveListItem(-1)

End Sub

' @(e)
'
' 機能　　 : 「表示色ボタン」Click
'
' 機能説明 : 色選択用ダイアログボックス表示
'
' 備考　　 :
'
Private Sub cmdWebColor_Click()

    Dim strTargetColor  As String
    Dim strChangeColor  As String

    'ダイアログ表示
    CommonDialog1.ShowColor
    
    '戻り値をラベルセット
    lblWebColor.BackColor = CommonDialog1.Color

    'カラーを16進数に変更
    strTargetColor = Hex(CommonDialog1.Color)

    'RGBを反転させる
    Select Case Len(strTargetColor)
        Case 2
            strChangeColor = strTargetColor & "0000"
        Case 4
            strChangeColor = Mid(strTargetColor, 3, 2) & Mid(strTargetColor, 1, 2)
            strChangeColor = strChangeColor & "00"
        Case 6
            strChangeColor = Mid(strTargetColor, 5, 2) & Mid(strTargetColor, 3, 2) & Mid(strTargetColor, 1, 2)
    
    End Select
    
    '文字列表示
    lblColor.Caption = strChangeColor
    
End Sub



Private Sub cmdZaimuCd_Click(Index As Integer)

    Dim objCommonGuide  As mntCommonGuide.CommonGuide   '項目ガイド表示用
    Dim i               As Long     'インデックス
    Dim intRecordCount  As Integer
    Dim vntCode         As Variant
    Dim vntName         As Variant
    
    'オブジェクトのインスタンス作成
    Set objCommonGuide = New mntCommonGuide.CommonGuide
    
    With objCommonGuide
        .MultiSelect = False
        .TargetTable = getZaimu
    
        '財務適用コードガイド画面を開く
        .Show vbModal
    
        intRecordCount = .RecordCount
        vntCode = .RecordCode
        vntName = .RecordName
    
    End With
        
    '選択件数が0件以上なら
    If intRecordCount > 0 Then
    
        lblZaimuCd(Index).Caption = vntCode(0)
        lblZaimuName(Index).Caption = vntName(0)
    
'        '選択レコード数が１個ならテキストボックスにセット
'        If intRecordCount = 1 Then
'            txtLowerValue.Text = vntCode(0)
'            lblSentence.Caption = vntName(0)
'        Else
'            txtLowerValue.Text = "*"
'            lblSentence.Caption = "複数の文章が選択されています。"
'        End If
'
'        '文章格納用配列に格納
'        Erase mvntStcCode
'        Erase mvntSentence
'        mintSentenceCount = 0
'
'        ReDim Preserve mvntStcCode(intRecordCount)
'        ReDim Preserve mvntSentence(intRecordCount)
'
'        '配列に格納
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
    
    '画面初期化
    Call InitializeForm

    Do
        
'### 2003.11.23 Deleted by H.Ishihara@FSIT 聖路加未使用項目削除
'        '当日ＩＤコンボの表示編集
'        If EditDayIDDiv() = False Then
'            Exit Do
'        End If
'### 2003.11.23 Deleted End
        
'### 2002.11.12 Mod By H.Ishihara@FSIT 東急殿仕様では財務不要
'        '財務連携用適用コードコレクション作成
'        If GetZaimuRecord() = False Then
'            Exit Do
'        End If
'### 2002.11.12 Mod End
        
        'コース情報の表示編集
        If EditCourse() = False Then
            Exit Do
        End If
        
'### 2003.11.23 Deleted by H.Ishihara@FSIT 聖路加未使用項目削除
'        '帳票コンボの編集
'        If EditReportConbo() = False Then
'            Exit Do
'        End If
'### 2003.11.23 Deleted End
    
        'イネーブル設定
        txtCsCd.Enabled = (txtCsCd.Text = "")
        
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
' 機能　　 : 帳票データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditReportConbo() As Boolean

    Dim objReport       As Object   'コースアクセス用
    Dim vntReportCd     As Variant
    Dim vntReportName   As Variant
    Dim vntReportFlg    As Variant
    Dim vntKarteFlg     As Variant
    Dim lngCount        As Long             'レコード数0
    Dim i               As Long             'インデックス
    Dim intReportCount  As Integer
    
    EditReportConbo = False
    
    cboReport.Clear
    cboKarteReportCd.Clear
    Erase mstrReportCd
    Erase mstrKarteCd

    'オブジェクトのインスタンス作成
    Set objReport = CreateObject("HainsReport.Report")
    lngCount = objReport.SelectReportList(vntReportCd, vntReportName, vntReportFlg, , , , , vntKarteFlg)
    
    '未指定あり
    ReDim Preserve mstrReportCd(0)
    ReDim Preserve mstrKarteCd(0)
    mstrReportCd(0) = ""
    mstrKarteCd(0) = ""
    cboReport.AddItem ""
    cboReport.ListIndex = 0
    cboKarteReportCd.AddItem ""
    cboKarteReportCd.ListIndex = 0
    
    intReportCount = 0
    
    'コンボボックスの編集
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
    
    '先頭コンボを選択状態にする
    EditReportConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

'
' 機能　　 : 財務適用コード全データ取得
'
' 引数　　 :
'
' 戻り値　 : TRUE:データあり、FALSE:データなし
'
' 備考　　 :
'
Private Function GetZaimuRecord() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu            As Object           '財務適用コードアクセス用
    Dim vntZaimuCd          As Variant          '財務コードコード
    Dim vntZaimuName        As Variant            '財務適用名
    Dim vntZaimuDiv         As Variant          '財務種別
    Dim vntZaimuClass       As Variant          '財務分類
    Dim i                   As Long             'インデックス
    Dim strZaimuClassName   As String
    Dim strZaimuDivName     As String
    Dim objZaimuRecord      As Object
    Dim lngCount            As Long
    
    GetZaimuRecord = False
    
    Set mcolZaimuCollection = New Collection
    
    'オブジェクトのインスタンス作成
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    lngCount = objZaimu.SelectZaimuList(vntZaimuCd, vntZaimuName, vntZaimuDiv, vntZaimuClass)
    
    'リストの編集
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
    
    'オブジェクト廃棄
    Set objZaimu = Nothing
    
    'エラー処理対応
    If lngCount = 0 Then
        MsgBox "財務連携用適用コードが設定されていません。財務連携用適用コードを先に登録してください。", vbExclamation, Me.Caption
        Exit Function
    End If
    
    GetZaimuRecord = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : 財務連携適用名の取得
'
' 戻り値　 : 適用名称
'
' 機能説明 : コードから財務連携適用名称を取得する
'
' 備考　　 :
'
Private Function GetZaimuNameFromCollection(strZaimuCd As String) As String

On Error GoTo ErrorHandle

    'コレクションから名称取得
    GetZaimuNameFromCollection = mcolZaimuCollection(KEY_PREFIX & strZaimuCd).ZaimuName
    
    Exit Function

ErrorHandle:
    
    'コレクションの索引に失敗した場合
    GetZaimuNameFromCollection = "？？？？？"

End Function

' @(e)
'
' 機能　　 : 判定分類データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 判定分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditDayIDDiv() As Boolean

    Dim objDayIDDiv         As Object       '判定分類アクセス用
    Dim vntDayIDDivCd       As Variant      '当日ＩＤコード
    Dim vntDayIDDivName     As Variant      '当日ＩＤ名
    Dim vntDayIDDivFrom     As Variant      '当日ＩＤ開始
    Dim vntDayIDDivTo       As Variant      '当日ＩＤ終了

    Dim lngCount    As Long             'レコード数
    Dim i           As Long             'インデックス
    
    EditDayIDDiv = False
    
    cboDayIDDiv.Clear
    Erase mstrArrDayIDDivCd

    'オブジェクトのインスタンス作成
    Set objDayIDDiv = CreateObject("HainsFree.Free")
    lngCount = objDayIDDiv.SelectFree(1, _
                                      "DAYID", _
                                      vntDayIDDivCd, _
                                      vntDayIDDivName, _
                                      , _
                                      vntDayIDDivFrom, _
                                      vntDayIDDivTo)
    
    'エラー処理対応
    If lngCount = 0 Then
        MsgBox "当日ＩＤ範囲が登録されていません。当日ＩＤ範囲を指定してからコースを登録してください。", vbExclamation, Me.Caption
        Exit Function
    Else
        If lngCount < 0 Then
            MsgBox "汎用テーブル読み込み中にシステム的なエラーが発生しました。", vbExclamation, Me.Caption
            Exit Function
        End If
    End If
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrDayIDDivCd(i)
        mstrArrDayIDDivCd(i) = vntDayIDDivCd(i)
        cboDayIDDiv.AddItem vntDayIDDivName(i) & "　(" & vntDayIDDivFrom(i) & "～" & vntDayIDDivTo(i) & ")"
    Next i
    
    '先頭コンボを選択状態にする
    cboDayIDDiv.ListIndex = 0
    
    EditDayIDDiv = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

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
        
        'コーステーブルの登録
        If RegistCourse() = False Then Exit Do

        '更新フラグを初期化
        mblnEditMain = False
        mblnEditItem = False
        mblnEditJud = False
        mblnEditOpe = False
        
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
    mblnShowItem = False
    mblnShowOpe = False
    mblnShowJud = False
    mblnShowGov = False
    
    '更新チェック用フラグ初期化
    mblnEditMain = False
    mblnEditItem = False
    mblnEditJud = False
    mblnEditOpe = False
    
    '--- メインタブ
    
    lblMainCsCd.Caption = "メインコース(&S):"
    
    '宿泊数コンボ編集
    cboStay.AddItem "宿泊なし"
    For i = 1 To 9
        cboStay.AddItem i & "泊"
    Next i
    cboStay.ListIndex = 0
    
    '２次健診
    cboSecondFlg.AddItem "通常コース"
    cboSecondFlg.AddItem "２次健診扱い"
    cboSecondFlg.ListIndex = 0

    'コース区分
    cboCsDiv.AddItem "メインかつサブ（例：定健一次など）"
    cboCsDiv.AddItem "メインコース（契約を作成できます）"
    cboCsDiv.AddItem "メインコース（契約作成できません）"
    cboCsDiv.AddItem "サブコース"
    cboCsDiv.ListIndex = 0

    '政府管掌健診区分コンボ編集
    cboGovMngDiv.AddItem "その他"
    cboGovMngDiv.AddItem "成人病健診"
    cboGovMngDiv.AddItem "日帰りドック"
    cboGovMngDiv.AddItem "定期健康診断"
    cboGovMngDiv.AddItem "入院ドック"
    cboGovMngDiv.AddItem "胃集団検診"
    cboGovMngDiv.AddItem "その他の健診"
    cboGovMngDiv.AddItem "乳がん・子宮がん検診"
    cboGovMngDiv.AddItem "フォロー"
    cboGovMngDiv.ListIndex = 0
    
    '政府管掌健診区分コンボ編集
    cboGovMng12Div.AddItem "その他"
    cboGovMng12Div.AddItem "一次健診"
    cboGovMng12Div.AddItem "二次健診"
    cboGovMng12Div.AddItem "追跡"
    cboGovMng12Div.AddItem "フォロー"
    cboGovMng12Div.AddItem "巡回"
    cboGovMng12Div.ListIndex = 0
    
    '政府管掌社保区分コンボ編集
    cboGovMngShaho.AddItem "その他"
    cboGovMngShaho.AddItem "保健予防活動"
    cboGovMngShaho.AddItem "医療相談収入"
    cboGovMngShaho.ListIndex = 0
    
    'Webカラー
    lblWebColor.BackColor = vbBlack
    lblColor.Caption = "000000"
    
    
    '--- 検査項目タブ
    cmdEditHistory.Enabled = False
    cmdDeleteHistory.Enabled = False

    cmdAddItem.Enabled = False
    cmdDeleteItem.Enabled = False
    cmdItemProperty.Enabled = False
    lsvItem.Enabled = False
    
    
    'ヘッダの編集
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "検査分類", 1200, lvwColumnLeft
        .Add , , "区分", 1000, lvwColumnLeft
        .Add , , "コード", 1000, lvwColumnLeft
        .Add , , "名称", 2000, lvwColumnLeft
    End With
    
End Sub


' @(e)
'
' 機能　　 : 受診検査項目表示
'
' 機能説明 : 現在設定されている検査項目を表示する
'
' 備考　　 :
'
Private Sub EditListItem()
    
On Error GoTo ErrorHandle

    Dim objCourse       As Object               'コースアクセス用
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    Dim vntClassName    As Variant              '検査分類名称
    Dim vntItemDiv      As Variant              '項目区分
    Dim vntItemCd       As Variant              'コード
    Dim vntItemName     As Variant              '名称
    Dim lngCount        As Long                 'レコード数
    
    Dim i               As Long                 'インデックス

    'リストアイテムクリア
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
    
    '受診検査項目検索（開始、終了日は履歴番号を指定しているため、不要）
    lngCount = objCourse.SelectCourseItemOrderByClass(mstrCsCd, 0, 0, _
                                                      vntClassName, vntItemDiv, vntItemCd, _
                                                      vntItemName, mintCsHNo(cboHistory.ListIndex))
    
    'ヘッダの編集
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "検査分類", 1200, lvwColumnLeft
        .Add , , "区分", 1000, lvwColumnLeft
        .Add , , "コード", 1000, lvwColumnLeft
        .Add , , "名称", 2000, lvwColumnLeft
    End With
        
    lsvItem.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, vntItemDiv(i) & vntItemCd(i), vntClassName(i))
        objItem.SubItems(1) = IIf(vntItemDiv(i) = GRPDIV_GRP, "グループ", "検査項目")
        objItem.SubItems(2) = vntItemCd(i)
        objItem.SubItems(3) = vntItemName(i)
    Next i
    
    '項目が１行以上存在した場合、無条件に先頭が選択されるため解除する。
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    '選択履歴データの項目編集
    lblCsHNo.Caption = "履歴No:" & Space(1) & mintCsHNo(cboHistory.ListIndex)
    lblPrice.Caption = "コース基本料金:" & Space(1) & "\" & Format(mlngPrice(cboHistory.ListIndex), "#,###,##0")
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Sub

' @(e)
'
' 機能　　 : コース判定分類表示
'
' 機能説明 : 現在設定されている判定分類を表示する
'
' 備考　　 :
'
Private Sub EditListJud()
    
On Error GoTo ErrorHandle

    Dim objCourse       As Object               'コースアクセス用
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    Dim vntJudClassCd   As Variant              '判定分類コード
    Dim vntJudClassName As Variant              '判定分類名称
    Dim vntNoReason     As Variant              '無条件展開フラグ
    Dim vntSeq          As Variant              '表示順番
    
    Dim lngCount        As Long                 'レコード数
    Dim i               As Long                 'インデックス

    '既に表示済みの場合、処理しない
    If mblnShowJud = True Then Exit Sub

    'リストアイテムクリア
    lsvJud.ListItems.Clear
    lsvJud.View = lvwList
    
    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
    
    '受診検査項目検索（開始、終了日は履歴番号を指定しているため、不要）
    lngCount = objCourse.SelectCourse_JudList(mstrCsCd, _
                                              vntJudClassCd, _
                                              vntJudClassName, _
                                              vntNoReason, _
                                              vntSeq)
    'ヘッダの編集
    Set objHeader = lsvJud.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "コード", 700, lvwColumnLeft
        .Add , , "判定分類", 2500, lvwColumnLeft
        .Add , , "無条件展開", 1500, lvwColumnLeft
    End With
    lsvJud.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvJud.ListItems.Add(, mstrListViewKey & vntJudClassCd(i), vntJudClassCd(i))
        objItem.SubItems(1) = vntJudClassName(i)
        objItem.SubItems(2) = IIf(vntNoReason(i) = 1, NOREASON_TEXT, "")
    Next i
    
    '項目が１行以上存在した場合、無条件に先頭が選択されるため解除する。
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
' 機能　　 : コース項目実施日表示
'
' 機能説明 : 現在設定されているコース項目実施日を表示する
'
' 備考　　 :
'
Private Sub EditListCourse_Ope()
    
On Error GoTo ErrorHandle

    Dim objCourse       As Object               'コースアクセス用
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    Dim vntOpeClassCd   As Variant              '検査実施日分類コード
    Dim vntOpeClassName As Variant              '検査実施日分類名
    Dim vntMonMng       As Variant              '月曜受診時検査日
    Dim vntTueMng       As Variant              '火曜受診時検査日
    Dim vntWedMng       As Variant              '水曜受診時検査日
    Dim vntThuMng       As Variant              '木曜受診時検査日
    Dim vntFriMng       As Variant              '金曜受診時検査日
    Dim vntSatMng       As Variant              '土曜受診時検査日
    Dim vntSunMng       As Variant              '日曜受診時検査日

    Dim vntNoReason     As Variant              '無条件展開フラグ
    Dim vntSeq          As Variant              '表示順番
    
    Dim lngCount        As Long                 'レコード数
    Dim i               As Long                 'インデックス

    '既に表示済みの場合、処理しない
    If mblnShowOpe = True Then Exit Sub

    'リストアイテムクリア
    lsvCourse_Ope.ListItems.Clear
    lsvCourse_Ope.View = lvwList
    
    'オブジェクトのインスタンス作成
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
    
    'ヘッダの編集
    Set objHeader = lsvCourse_Ope.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "コード", 700, lvwColumnLeft
        .Add , , "実施日分類名", 2200, lvwColumnLeft
        .Add , , "月", 400, lvwColumnCenter
        .Add , , "火", 400, lvwColumnCenter
        .Add , , "水", 400, lvwColumnCenter
        .Add , , "木", 400, lvwColumnCenter
        .Add , , "金", 400, lvwColumnCenter
        .Add , , "土", 400, lvwColumnCenter
        .Add , , "日", 400, lvwColumnCenter
    End With
    lsvCourse_Ope.View = lvwReport
    
    'リストの編集
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
    
    '項目が１行以上存在した場合、無条件に先頭選択
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
' 機能　　 : 受診項目一覧カラムクリック
'
' 機能説明 : クリックされたカラム項目でSortを行う
'
' 備考　　 :
'
Private Sub lsvItem_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    
    'マウスポインタが砂時計のときは入力無視
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

    'プロパティ表示
    Call cmdItemProperty_Click

End Sub


Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)
    
    Dim i As Long

    'CTRL+Aを押下された場合、項目を全て選択する
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

    'CTRL+Aを押下された場合、項目を全て選択する
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvJud.ListItems.Count
            lsvJud.ListItems(i).Selected = True
        Next i
    End If

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

    Screen.MousePointer = vbHourglass
    
    'クリックされたタブに応じて処理実行
    Select Case tabMain.Tab
        
        Case 1  '受診項目及び履歴管理タブ
            Call EditItemTab
        
        Case 2  '判定タブ
            Call EditJudClassTab
        
        Case 3  '政府管掌タブ
            Frame3.Visible = False
        
        Case 4  '実施日管理タブ
            
            LabelOperationGuide.Caption = "このコースで受診する項目の検査実施日を設定します。" & vbLf & vbLf & _
                                          "ここで指定した設定は他システムとの連携時に有効です。" & vbLf & _
                                          "健診システム内で実施する項目には設定する必要はありません。"
            Call EditListCourse_Ope
    
    End Select
    
    Screen.MousePointer = vbDefault
    
End Sub


' @(e)
'
' 機能　　 : コース履歴データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : コースに存在する履歴データを表示する
'
' 備考　　 :
'
Private Function EditCourseHistory() As Boolean

    Dim objCourse   As Object           'コースアクセス用
    
    Dim dtmStrDate  As Date
    Dim dtmEndDate  As Date
    Dim vntStrDate  As Variant
    Dim vntEndDate  As Variant
    Dim vntPrice    As Variant
    Dim vntTax      As Variant
    Dim vntCsHNo    As Variant

    Dim lngCount    As Long             'レコード数
    Dim i           As Long             'インデックス
    
    EditCourseHistory = False
    cboHistory.Clear
    Erase mintCsHNo
    Erase mstrStrDate
    Erase mstrEndDate
    Erase mlngPrice

    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
    lngCount = objCourse.SelectCourseHistory(mstrCsCd, dtmStrDate, dtmEndDate, _
                                             vntStrDate, vntEndDate, vntPrice, _
                                             vntTax, vntCsHNo)
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mintCsHNo(i)
        ReDim Preserve mstrStrDate(i)
        ReDim Preserve mstrEndDate(i)
        ReDim Preserve mlngPrice(i)
'### 2002.05.01 Modified by Ishihara@FSIT NTは2000年問題でいまいち
'        cboHistory.AddItem CStr(vntStrDate(i)) & "～" & CStr(vntEndDate(i)) & "に適用するデータ"
        cboHistory.AddItem CStr(Format(vntStrDate(i), "YYYY/MM/DD")) & "～" & CStr(Format(vntEndDate(i), "YYYY/MM/DD")) & "に適用するデータ"
'### 2002.05.01 Modified End
        mintCsHNo(i) = vntCsHNo(i)
'### 2002.05.01 Modified by Ishihara@FSIT NTは2000年問題でいまいち
'        mstrStrDate(i) = vntStrDate(i)
'        mstrEndDate(i) = vntEndDate(i)
        mstrStrDate(i) = Format(vntStrDate(i), "YYYY/MM/DD")
        mstrEndDate(i) = Format(vntEndDate(i), "YYYY/MM/DD")
'### 2002.05.01 Modified End
        mlngPrice(i) = vntPrice(i)
    Next i
    
    '履歴データが存在するなら、コンボ選択
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
' 機能　　 : 検査項目タブクリック
'
' 機能説明 : 履歴情報及び、受診検査項目の表示を行う
'
' 備考　　 :
'
Private Sub EditItemTab()

    Dim blnStatus       As Boolean
    Dim blnCboStatus    As Boolean

    '処理中フラグを更新中に変更
    mblnNowEdit = True

    'コース履歴コンボの設定（初めて表示、もしくはデータ変更した後のみ）
    If mblnShowItem = False Then
        blnStatus = EditCourseHistory()
    Else
        '項目を表示してしまっているなら、履歴は取得したものとしてTRUEにする
        blnStatus = (cboHistory.ListCount > 0)
    End If

    'コントロールのイネーブル制御（履歴コンボの有無により設定）
    cmdNewHistory.Enabled = (mstrCsCd <> "")
    cmdEditHistory.Enabled = blnStatus
    cmdDeleteHistory.Enabled = blnStatus
'### 2003/11/11 Deleted by Ishihara@FSIT コース内検査項目の追加は許さない
'    cmdAddItem.Enabled = blnStatus
'### 2003/11/11 Deleted End
    cmdDeleteItem.Enabled = blnStatus
    cmdItemProperty.Enabled = blnStatus
    lsvItem.Enabled = blnStatus
    
    'コース履歴が存在、かついまだ一度も表示してない場合、受診項目の編集
    If (blnStatus = True) And (mblnShowItem = False) Then
        Call EditListItem
    End If
        
    'コース履歴がないかつ未表示のときに１回だけメッセージ表示
    If cmdNewHistory.Enabled = False Then
        MsgBox "検査項目関連データを登録する際は、一度基本情報を格納する必要があります。" & vbLf & _
               "基本情報を格納してから登録してください。", vbExclamation, Me.Caption
    End If
    
    '処理中フラグを未処理に変更
    mblnNowEdit = False
    
    'データ表示済みとして定義
    mblnShowItem = True
    
End Sub

' @(e)
'
' 機能　　 : 判定分類タブクリック
'
' 機能説明 : コース内管轄の判定分類を表示する
'
' 備考　　 :
'
Private Sub EditJudClassTab()

    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    '処理中フラグを更新中に変更
    mblnNowEdit = True

    'コース判定分類の表示編集
    Call EditListJud
    
    '処理中フラグを未処理に変更
    mblnNowEdit = False
    
    'データ表示済みとして定義
    mblnShowJud = True
    
End Sub

' @(e)
'
' 機能　　 : コース項目実施日タブクリック
'
' 機能説明 : コース内管轄の判定分類を表示する
'
' 備考　　 :
'
Private Sub EditCourseOpeTab()

    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    '処理中フラグを更新中に変更
    mblnNowEdit = True

    'コース判定分類の表示編集
    Call EditListJud
    
    '処理中フラグを未処理に変更
    mblnNowEdit = False
    
    'データ表示済みとして定義
    mblnShowJud = True
    
End Sub


' @(e)
'
' 機能　　 : コース履歴編集ウインドウ表示
'
' 引数　　 : (In)      modeNew  TRUE:新規モード、FALSE:更新モード
'
' 機能説明 :
'
' 備考　　 :
'
Private Sub ShowCourse_h(modeNew As Boolean)
    
    With frmCourse_h
        
        .CsCd = mstrCsCd
        
        If modeNew = True Then
            '新規モードの場合、履歴番号の-1をセット（あり得ないため）
            .CsHNo = -1
            .strDate = ""
            .endDate = ""
            .Price = 0
        Else
            '更新モードの場合、現在の履歴情報をセット
            .CsHNo = mintCsHNo(cboHistory.ListIndex)
            .strDate = mstrStrDate(cboHistory.ListIndex)
            .endDate = mstrEndDate(cboHistory.ListIndex)
            .Price = mlngPrice(cboHistory.ListIndex)
        End If
        
        .Show vbModal
    
        'データを更新されたら、画面データ再編集
        If .Updated = True Then
            mblnShowItem = False
            Call EditItemTab
        End If
        
    End With

End Sub

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

