VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmPgmItemGuide 
   Caption         =   "プログラム項目ガイド"
   ClientHeight    =   6591
   ClientLeft      =   7579
   ClientTop       =   2171
   ClientWidth     =   5304
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6591
   ScaleWidth      =   5304
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3783
      TabIndex        =   9
      Top             =   6110
      Width           =   1313
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2314
      TabIndex        =   8
      Top             =   6110
      Width           =   1313
   End
   Begin VB.Frame Frame2 
      Height          =   949
      Left            =   78
      TabIndex        =   1
      Top             =   598
      Width           =   5083
      Begin VB.OptionButton Option1 
         Caption         =   "誘導"
         Height          =   195
         Index           =   0
         Left            =   2366
         TabIndex        =   4
         Top             =   234
         Width           =   845
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Hains"
         Height          =   195
         Index           =   1
         Left            =   1430
         TabIndex        =   3
         Top             =   234
         Value           =   -1  'True
         Width           =   949
      End
      Begin VB.ComboBox Combo1 
         Height          =   273
         Left            =   1404
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   2
         Top             =   546
         Width           =   1937
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "システム 区分"
         Height          =   169
         Index           =   0
         Left            =   182
         TabIndex        =   6
         Top             =   234
         Width           =   1027
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "メニュー 区分"
         Height          =   169
         Index           =   1
         Left            =   182
         TabIndex        =   5
         Top             =   572
         Width           =   949
      End
   End
   Begin MSComctlLib.ListView ListView1 
      Height          =   3913
      Left            =   78
      TabIndex        =   7
      Top             =   1586
      Width           =   5265
      _ExtentX        =   9282
      _ExtentY        =   6908
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Frame Frame1 
      Height          =   559
      Left            =   78
      TabIndex        =   10
      Top             =   5408
      Width           =   5083
      Begin VB.CheckBox Check1 
         Caption         =   "ALL"
         Height          =   273
         Index           =   3
         Left            =   4342
         TabIndex        =   15
         Top             =   182
         Width           =   689
      End
      Begin VB.CheckBox Check1 
         Caption         =   "削除"
         Height          =   273
         Index           =   2
         Left            =   3536
         TabIndex        =   14
         Top             =   182
         Width           =   767
      End
      Begin VB.CheckBox Check1 
         Caption         =   "登録、修正"
         Height          =   273
         Index           =   1
         Left            =   2288
         TabIndex        =   13
         Top             =   182
         Width           =   1105
      End
      Begin VB.CheckBox Check1 
         Caption         =   "参照"
         Height          =   273
         Index           =   0
         Left            =   1482
         TabIndex        =   12
         Top             =   182
         Width           =   793
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "操作権限区分 ："
         Height          =   169
         Index           =   4
         Left            =   182
         TabIndex        =   11
         Top             =   234
         Width           =   1157
      End
   End
   Begin VB.Image Image1 
      Height          =   624
      Index           =   4
      Left            =   0
      Picture         =   "frmPgmItemGuide.frx":0000
      Top             =   0
      Width           =   624
   End
   Begin VB.Label LabelTitle 
      Caption         =   "プログラム項目を選択してください"
      Height          =   375
      Left            =   780
      TabIndex        =   0
      Top             =   175
      Width           =   4275
   End
End
Attribute VB_Name = "frmPgmItemGuide"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
