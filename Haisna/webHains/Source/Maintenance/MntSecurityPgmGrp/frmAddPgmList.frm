VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmAddPgmList 
   Caption         =   "セキュリティーグループ プルグラム管理"
   ClientHeight    =   6864
   ClientLeft      =   6526
   ClientTop       =   4680
   ClientWidth     =   9191
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6864
   ScaleWidth      =   9191
   Begin VB.Frame Frame2 
      Height          =   6565
      Left            =   3770
      TabIndex        =   6
      Top             =   156
      Width           =   5317
      Begin VB.CommandButton Command1 
         Caption         =   "削除"
         Height          =   312
         Index           =   2
         Left            =   4056
         TabIndex        =   23
         Top             =   6084
         Width           =   1144
      End
      Begin VB.CommandButton Command1 
         Caption         =   "修正"
         Height          =   312
         Index           =   1
         Left            =   2808
         TabIndex        =   22
         Top             =   6084
         Width           =   1144
      End
      Begin VB.CommandButton Command1 
         Caption         =   "登録"
         Height          =   312
         Index           =   0
         Left            =   1560
         TabIndex        =   21
         Top             =   6084
         Width           =   1144
      End
      Begin VB.TextBox Text1 
         Appearance      =   0  'ﾌﾗｯﾄ
         Height          =   299
         Left            =   1586
         TabIndex        =   20
         Top             =   5590
         Width           =   923
      End
      Begin VB.OptionButton Option2 
         Caption         =   "削除"
         Height          =   273
         Index           =   2
         Left            =   3874
         TabIndex        =   18
         Top             =   5252
         Width           =   741
      End
      Begin VB.OptionButton Option2 
         Caption         =   "登録、修正"
         Height          =   273
         Index           =   1
         Left            =   2522
         TabIndex        =   17
         Top             =   5252
         Width           =   1157
      End
      Begin VB.OptionButton Option2 
         Caption         =   "参照"
         Height          =   273
         Index           =   0
         Left            =   1586
         TabIndex        =   16
         Top             =   5252
         Value           =   -1  'True
         Width           =   741
      End
      Begin VB.ComboBox cboGrp 
         Height          =   273
         Index           =   0
         Left            =   2002
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   11
         Top             =   312
         Width           =   1989
      End
      Begin VB.ComboBox cboGrp 
         Height          =   273
         Index           =   1
         Left            =   2002
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   10
         Top             =   650
         Width           =   1989
      End
      Begin MSComctlLib.ListView ListView1 
         Height          =   2795
         Index           =   1
         Left            =   78
         TabIndex        =   9
         Top             =   988
         Width           =   5317
         _ExtentX        =   9377
         _ExtentY        =   4938
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin MSComctlLib.ListView ListView1 
         Height          =   1443
         Index           =   2
         Left            =   78
         TabIndex        =   14
         Top             =   3744
         Width           =   5317
         _ExtentX        =   9377
         _ExtentY        =   2540
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "画面表示順番"
         Height          =   169
         Index           =   5
         Left            =   208
         TabIndex        =   19
         Top             =   5642
         Width           =   1014
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "操作権限区分"
         Height          =   169
         Index           =   4
         Left            =   208
         TabIndex        =   15
         Top             =   5304
         Width           =   1014
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "ユーザグループ"
         Height          =   169
         Index           =   3
         Left            =   104
         TabIndex        =   13
         Top             =   390
         Width           =   1105
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "セキュリティーグループ"
         Height          =   169
         Index           =   2
         Left            =   156
         TabIndex        =   12
         Top             =   728
         Width           =   1625
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "プログラムリスト"
      Height          =   6565
      Left            =   78
      TabIndex        =   0
      Top             =   156
      Width           =   3679
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "選択"
         Height          =   338
         Left            =   104
         TabIndex        =   8
         Top             =   6084
         Width           =   1275
      End
      Begin VB.ComboBox Combo1 
         Height          =   273
         Left            =   1404
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   5
         Top             =   650
         Width           =   1937
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Hains"
         Height          =   195
         Index           =   1
         Left            =   1430
         TabIndex        =   3
         Top             =   338
         Value           =   -1  'True
         Width           =   949
      End
      Begin VB.OptionButton Option1 
         Caption         =   "誘導"
         Height          =   195
         Index           =   0
         Left            =   2366
         TabIndex        =   2
         Top             =   338
         Width           =   845
      End
      Begin MSComctlLib.ListView ListView1 
         Height          =   5161
         Index           =   0
         Left            =   52
         TabIndex        =   7
         Top             =   988
         Width           =   3549
         _ExtentX        =   6267
         _ExtentY        =   9092
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "メニュー 区分"
         Height          =   169
         Index           =   1
         Left            =   182
         TabIndex        =   4
         Top             =   676
         Width           =   949
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "システム 区分"
         Height          =   169
         Index           =   0
         Left            =   182
         TabIndex        =   1
         Top             =   338
         Width           =   1027
      End
   End
End
Attribute VB_Name = "frmAddPgmList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
