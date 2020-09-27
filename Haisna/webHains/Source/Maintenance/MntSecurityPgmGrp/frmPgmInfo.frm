VERSION 5.00
Begin VB.Form frmPgmInfo 
   Caption         =   "プログラム情報管理"
   ClientHeight    =   4459
   ClientLeft      =   4641
   ClientTop       =   6526
   ClientWidth     =   6851
   LinkTopic       =   "Form1"
   ScaleHeight     =   4459
   ScaleWidth      =   6851
   Begin VB.Frame Frame1 
      Height          =   429
      Left            =   3094
      TabIndex        =   16
      Top             =   5382
      Visible         =   0   'False
      Width           =   2379
      Begin VB.OptionButton Option1 
         Caption         =   "Hains"
         Height          =   195
         Index           =   1
         Left            =   156
         TabIndex        =   18
         Top             =   182
         Value           =   -1  'True
         Width           =   949
      End
      Begin VB.OptionButton Option1 
         Caption         =   "誘導"
         Height          =   195
         Index           =   0
         Left            =   1092
         TabIndex        =   17
         Top             =   130
         Width           =   845
      End
   End
   Begin VB.CommandButton Command1 
      Caption         =   "登録"
      Height          =   312
      Index           =   0
      Left            =   3068
      TabIndex        =   15
      Top             =   4004
      Width           =   1144
   End
   Begin VB.CommandButton Command1 
      Caption         =   "修正"
      Height          =   312
      Index           =   1
      Left            =   4316
      TabIndex        =   14
      Top             =   4004
      Width           =   1144
   End
   Begin VB.CommandButton Command1 
      Caption         =   "削除"
      Height          =   312
      Index           =   2
      Left            =   5564
      TabIndex        =   13
      Top             =   4004
      Width           =   1144
   End
   Begin VB.Frame Frame2 
      Height          =   3731
      Left            =   78
      TabIndex        =   0
      Top             =   78
      Width           =   6617
      Begin VB.TextBox Text5 
         Height          =   1313
         Left            =   2028
         MultiLine       =   -1  'True
         TabIndex        =   12
         Top             =   2236
         Width           =   4381
      End
      Begin VB.ComboBox Combo1 
         Height          =   273
         Left            =   2028
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   11
         Top             =   1846
         Width           =   2301
      End
      Begin VB.TextBox Text4 
         Height          =   325
         Left            =   2028
         TabIndex        =   10
         Top             =   1404
         Width           =   4381
      End
      Begin VB.TextBox Text3 
         Height          =   325
         Left            =   2028
         TabIndex        =   9
         Top             =   988
         Width           =   4381
      End
      Begin VB.TextBox Text2 
         Height          =   325
         Left            =   2028
         TabIndex        =   8
         Top             =   598
         Width           =   4381
      End
      Begin VB.TextBox Text1 
         Height          =   325
         Left            =   2028
         TabIndex        =   7
         Top             =   208
         Width           =   1781
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "プログラム説明"
         Height          =   169
         Index           =   6
         Left            =   130
         TabIndex        =   6
         Top             =   2366
         Width           =   1079
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "メニュー 区分"
         Height          =   169
         Index           =   4
         Left            =   130
         TabIndex        =   5
         Top             =   1924
         Width           =   949
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "リンクイメージ"
         Height          =   169
         Index           =   3
         Left            =   182
         TabIndex        =   4
         Top             =   1482
         Width           =   962
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "起動プログラム"
         Height          =   195
         Index           =   2
         Left            =   182
         TabIndex        =   3
         Top             =   1066
         Width           =   1079
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "プログラム　メニュー名"
         Height          =   169
         Index           =   1
         Left            =   182
         TabIndex        =   2
         Top             =   676
         Width           =   1586
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "プログラムコード"
         Height          =   169
         Index           =   0
         Left            =   182
         TabIndex        =   1
         Top             =   286
         Width           =   1144
      End
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      Caption         =   "システム 区分"
      Height          =   169
      Index           =   5
      Left            =   1430
      TabIndex        =   19
      Top             =   5460
      Visible         =   0   'False
      Width           =   1027
   End
End
Attribute VB_Name = "frmPgmInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
