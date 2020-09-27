VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmReport 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "帳票管理メンテナンス"
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
   StartUpPosition =   2  '画面の中央
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
      TabCaption(0)   =   "基本情報"
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
      TabCaption(1)   =   "帳票ファイル"
      TabPicture(1)   =   "frmReport.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraMain(6)"
      Tab(1).Control(1)=   "fraMain(5)"
      Tab(1).ControlCount=   2
      Begin VB.Frame fraMain 
         Caption         =   "部数"
         Height          =   1695
         Index           =   4
         Left            =   4140
         TabIndex        =   59
         Top             =   3420
         Width           =   2655
         Begin VB.TextBox txtCopyCount 
            Height          =   300
            IMEMode         =   3  'ｵﾌ固定
            Left            =   240
            MaxLength       =   2
            TabIndex        =   16
            Text            =   "@@"
            Top             =   360
            Width           =   435
         End
         Begin VB.Label Label5 
            Caption         =   "部数は１以上の値を設定してください。"
            Height          =   675
            Index           =   2
            Left            =   240
            TabIndex        =   62
            Top             =   780
            Width           =   2115
         End
         Begin VB.Label Label2 
            Caption         =   "部印刷"
            Height          =   255
            Left            =   720
            TabIndex        =   60
            Top             =   420
            Width           =   1455
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "特殊帳票設定"
         Height          =   1515
         Index           =   6
         Left            =   -74820
         TabIndex        =   58
         Top             =   5280
         Width           =   6615
         Begin VB.TextBox txtViewOrder 
            Height          =   300
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1140
            MaxLength       =   3
            TabIndex        =   47
            Text            =   "@@"
            ToolTipText     =   "面接支援画面にて、表示する順番を指定します"
            Top             =   1020
            Width           =   495
         End
         Begin VB.CheckBox chkKarteFlg 
            Caption         =   "この帳票をカルテとして設定する(&K)"
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
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   44
            Top             =   300
            Width           =   1830
         End
         Begin VB.CheckBox chkReportFlg 
            Caption         =   "この帳票を報告書として設定する(&H)"
            Height          =   315
            Left            =   240
            TabIndex        =   42
            Top             =   300
            Width           =   3015
         End
         Begin VB.Label Label1 
            Caption         =   "表示順(&J):"
            Height          =   180
            Index           =   15
            Left            =   240
            TabIndex        =   46
            ToolTipText     =   "面接支援画面にて、表示する順番を指定します"
            Top             =   1080
            Width           =   870
         End
         Begin VB.Label LabelHistoryPrint 
            Caption         =   "過去歴印刷(&O):"
            Height          =   180
            Left            =   3360
            TabIndex        =   43
            Top             =   360
            Width           =   1290
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "出力方法"
         Height          =   795
         Index           =   3
         Left            =   180
         TabIndex        =   57
         Top             =   4320
         Width           =   3795
         Begin VB.OptionButton optPreView 
            Caption         =   "プレビュー(&R)"
            Height          =   195
            Index           =   0
            Left            =   180
            TabIndex        =   14
            Top             =   360
            Value           =   -1  'True
            Width           =   1335
         End
         Begin VB.OptionButton optPreView 
            Caption         =   "直接出力(&D)"
            Height          =   195
            Index           =   1
            Left            =   2040
            TabIndex        =   15
            Top             =   360
            Width           =   1335
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "出力先"
         Height          =   795
         Index           =   2
         Left            =   180
         TabIndex        =   56
         Top             =   3420
         Width           =   3795
         Begin VB.OptionButton optPrtMachine 
            Caption         =   "ブラウザ(&B)"
            Height          =   315
            Index           =   0
            Left            =   180
            TabIndex        =   12
            Top             =   300
            Value           =   -1  'True
            Width           =   1575
         End
         Begin VB.OptionButton optPrtMachine 
            Caption         =   "サーバ(&V)"
            Height          =   315
            Index           =   1
            Left            =   2040
            TabIndex        =   13
            Top             =   300
            Width           =   1575
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "用紙設定"
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
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   5
            Top             =   300
            Width           =   1830
         End
         Begin VB.OptionButton optOrientation 
            Caption         =   "指定なし(&E)"
            Height          =   255
            Index           =   0
            Left            =   1860
            TabIndex        =   7
            Top             =   720
            Value           =   -1  'True
            Width           =   1215
         End
         Begin VB.OptionButton optOrientation 
            Caption         =   "縦(&P)"
            Height          =   255
            Index           =   1
            Left            =   3300
            TabIndex        =   8
            Top             =   720
            Width           =   795
         End
         Begin VB.OptionButton optOrientation 
            Caption         =   "横(&L)"
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
            Caption         =   "用紙サイズ(&G)"
            Height          =   180
            Index           =   4
            Left            =   180
            TabIndex        =   4
            Top             =   360
            Width           =   1770
         End
         Begin VB.Label Label1 
            Caption         =   "印刷の向き:"
            Height          =   180
            Index           =   5
            Left            =   180
            TabIndex        =   6
            Top             =   780
            Width           =   1350
         End
         Begin VB.Label Label1 
            Caption         =   "標準出力プリンタ(&S):"
            Height          =   180
            Index           =   13
            Left            =   180
            TabIndex        =   10
            Top             =   1140
            Width           =   1590
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "基本情報"
         Height          =   1095
         Index           =   0
         Left            =   180
         TabIndex        =   54
         Top             =   540
         Width           =   6615
         Begin VB.TextBox txtReportCd 
            Height          =   300
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1320
            MaxLength       =   6
            TabIndex        =   1
            Text            =   "@@@@@@"
            Top             =   240
            Width           =   855
         End
         Begin VB.TextBox txtReportName 
            Height          =   300
            IMEMode         =   4  '全角ひらがな
            Left            =   1320
            MaxLength       =   20
            TabIndex        =   3
            Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
            Top             =   600
            Width           =   3855
         End
         Begin VB.Label Label1 
            Caption         =   "帳票コード(&C):"
            Height          =   180
            Index           =   0
            Left            =   180
            TabIndex        =   0
            Top             =   300
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "帳票名(&N):"
            Height          =   180
            Index           =   2
            Left            =   180
            TabIndex        =   2
            Top             =   660
            Width           =   1590
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "帳票ファイル指定"
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
            Caption         =   "参照..."
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
            Caption         =   "参照..."
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
            Caption         =   "参照..."
            Height          =   315
            Index           =   7
            Left            =   5220
            TabIndex        =   37
            Top             =   3360
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "参照..."
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
            Caption         =   "参照..."
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
            Caption         =   "参照..."
            Height          =   315
            Index           =   0
            Left            =   5220
            TabIndex        =   19
            Top             =   840
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "参照..."
            Height          =   315
            Index           =   1
            Left            =   5220
            TabIndex        =   22
            Top             =   1200
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "参照..."
            Height          =   315
            Index           =   2
            Left            =   5220
            TabIndex        =   25
            Top             =   1560
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "参照..."
            Height          =   315
            Index           =   3
            Left            =   5220
            TabIndex        =   28
            Top             =   1920
            Width           =   1035
         End
         Begin VB.CommandButton cmdSearchFile 
            Caption         =   "参照..."
            Height          =   315
            Index           =   4
            Left            =   5220
            TabIndex        =   31
            Top             =   2280
            Width           =   1035
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名９(&9):"
            Height          =   240
            Index           =   14
            Left            =   180
            TabIndex        =   67
            Top             =   3780
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名１０(&10):"
            Height          =   240
            Index           =   7
            Left            =   180
            TabIndex        =   66
            Top             =   4140
            Width           =   1635
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名８(&8):"
            Height          =   240
            Index           =   6
            Left            =   180
            TabIndex        =   65
            Top             =   3420
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名７(&7):"
            Height          =   240
            Index           =   3
            Left            =   180
            TabIndex        =   64
            Top             =   3060
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名６(&6):"
            Height          =   240
            Index           =   1
            Left            =   180
            TabIndex        =   63
            Top             =   2700
            Width           =   1410
         End
         Begin VB.Label Label5 
            Caption         =   "CoReportsフォームファイルを指定します。"
            Height          =   255
            Index           =   1
            Left            =   180
            TabIndex        =   61
            Top             =   420
            Width           =   3555
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名５(&5):"
            Height          =   240
            Index           =   12
            Left            =   180
            TabIndex        =   29
            Top             =   2340
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名４(&4):"
            Height          =   240
            Index           =   11
            Left            =   180
            TabIndex        =   26
            Top             =   1980
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名３(&3):"
            Height          =   240
            Index           =   10
            Left            =   180
            TabIndex        =   23
            Top             =   1620
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名２(&2):"
            Height          =   240
            Index           =   9
            Left            =   180
            TabIndex        =   20
            Top             =   1260
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "帳票ファイル名１(&1):"
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
      Caption         =   "適用(&A)"
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
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4380
      TabIndex        =   49
      Top             =   7860
      Width           =   1335
   End
   Begin VB.Label Label5 
      Caption         =   "印刷する帳票の設定を行います。"
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
'修正履歴
'----------------------------
'管理番号: SL-UI-Y0101-116
'修正日  ：2010.06.17
'担当者  ：TCS)田村
'修正内容: 帳票ファイル８～１０を追加

Option Explicit

Private mstrReportCd            As String       '帳票コード
Private mblnInitialize          As Boolean      'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean      'TRUE:更新あり、FALSE:更新なし

Private mstrPaperSize()         As String       '用紙サイズ
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

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
' 機能　　 : 入力データチェック
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常データ、FALSE:異常データあり
'
' 備考　　 :
'
Private Function CheckValue() As Boolean

    Dim Ret As Boolean  '関数戻り値
    
    Ret = False
    
    Do
        'コードの入力チェック
        If Trim(txtReportCd.Text) = "" Then
            MsgBox "帳票コードが入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtReportCd.SetFocus
            Exit Do
        End If

        '帳票名の入力チェック
        If Trim(txtReportName.Text) = "" Then
            MsgBox "帳票名が入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtReportName.SetFocus
            Exit Do
        End If

        '印刷部数の入力チェック
        If Trim(txtCopyCount.Text) = "" Then
            txtCopyCount.Text = 1
        End If
        
        If IsNumeric(txtCopyCount.Text) = False Then
            MsgBox "印刷部数には数値（２桁）を入力してください。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCopyCount.SetFocus
            Exit Do
        End If
        
        If CInt(txtCopyCount.Text) < 1 Then
            MsgBox "部数は１以上を設定してください。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCopyCount.SetFocus
            Exit Do
        End If

        '帳票ファイル名の入力チェック
        If Trim(txtFedFile.Text) = "" Then
            MsgBox "帳票ファイル名１は必須入力です。", vbExclamation, App.Title
            tabMain.Tab = 1
            txtFedFile.SetFocus
            Exit Do
        End If

'2002.11.10　あえてチェックをはずすと何かに使えるような・・・
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT カルテフラグの追加
'        If (chkReportFlg = vbChecked) And (chkKarteFlg = vbChecked) Then
'            MsgBox "報告書であり、カルテであるような帳票は設定できません。", vbExclamation, App.Title
'            tabMain.Tab = 1
'            chkReportFlg.SetFocus
'            Exit Do
'        End If
'## 2002.11.10 Add End
        
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
        '判定分類表示順の数値チェック
        If Trim(txtViewOrder.Text) <> "" Then
        
            If IsNumeric(Trim(txtViewOrder.Text)) = False Then
                MsgBox "表示順は数値で入力してください。", vbCritical, App.Title
                txtViewOrder.SetFocus
                Exit Do
            End If
        
            If CLng(Trim(txtViewOrder.Text)) < 0 Then
                MsgBox "表示順には負数を指定することはできません。", vbCritical, App.Title
                txtViewOrder.SetFocus
                Exit Do
            End If
        
        End If
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

'
' 機能　　 : データ表示用編集
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditReport() As Boolean

    Dim objReport           As Object   '帳票アクセス用
    Dim vntReportName       As Variant  '報告書用帳票名
    Dim vntPaperSize        As Variant  '用紙サイズ
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
    
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
    Dim vntFedFile6         As Variant
    Dim vntFedFile7         As Variant
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
'#### 2010.06.17 SL-UI-Y0101-116 ADD START ####'
    Dim vntFedFile8         As Variant
    Dim vntFedFile9         As Variant
    Dim vntFedFile10        As Variant
'#### 2010.06.17 SL-UI-Y0101-116 ADD END ####'
    
    Dim vntReportFlg        As Variant
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT カルテフラグの追加
    Dim vntKarteFlg         As Variant
'## 2002.11.10 Add End
    Dim vntHistoryPrint     As Variant
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    Dim vntViewOrder        As Variant  '表示順
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
    Dim i                   As Integer
    
    Dim Ret                 As Boolean  '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objReport = CreateObject("HainsReport.Report")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrReportCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '帳票テーブルレコード読み込み
'#### 2010.06.17 SL-UI-Y0101-116 MOD START ####'
''''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT カルテフラグの追加
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
'''    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
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
'''    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
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

            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtReportCd.Text = mstrReportCd
        txtReportName.Text = vntReportName
'        txtPaperSize.Text = vntPaperSize       'なに設定すんの？
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
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT カルテフラグの追加
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
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
        txtFedFile6.Text = vntFedFile6
        txtFedFile7.Text = vntFedFile7
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
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
    
    '戻り値の設定
    EditReport = Ret
    
    Exit Function

ErrorHandle:

    EditReport = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : データ登録
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function RegistReport() As Boolean

On Error GoTo ErrorHandle

    Dim objReport           As Object       '帳票アクセス用
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
    
    'オブジェクトのインスタンス作成
    Set objReport = CreateObject("HainsReport.Report")
    
    '帳票テーブルレコードの登録
'#### 2010.06.17 SL-UI-Y0101-116 MOD START ####'
''''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT カルテフラグの追加
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
'''    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
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
'''    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
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
        MsgBox "入力された帳票コードは既に存在します。", vbExclamation
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
Private Sub CMDcancel_Click()

    Unload Me
    
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
Private Sub CMDok_Click()
    
    'データ適用処理を行う
    If ApplyData() = False Then Exit Sub

    '画面を閉じる
    Unload Me
    
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
        
        '帳票テーブルの登録
        If RegistReport() = False Then
            Exit Do
        End If

        '更新済みフラグをTRUEに
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Function

Private Sub cmdSearchFile_Click(Index As Integer)

    Dim strFileName     As String
    Dim strPath         As String
    
    With CommonDialog1
        .DialogTitle = "CoReports定義ファイルを選択してください。"
        .InitDir = "D:\webHains\wwwRoot\Reports\"
        .Filter = "CoReportsフォームファイル(*.crf)|*.crf|すべてのファイル(*.*)|*.*|"
        .ShowOpen
        strFileName = .FileTitle
    End With

    'ファイル指定なしなら処理終了
    If strFileName = "" Then Exit Sub
    
    'ファイル名セット
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
    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
        Case 5
            txtFedFile6.Text = strFileName
        Case 6
            txtFedFile7.Text = strFileName
    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
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
' 機能　　 : 「フォーム」Load
'
' 機能説明 : フォームの初期表示を行う
'
' 備考　　 :
'
Private Sub Form_Load()

    Dim Ret             As Boolean  '戻り値
    Dim objPrinter      As Printer
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    
    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    '過去歴印刷
    With cboHistoryPrint
        .Clear
        .AddItem "全て"
        .AddItem "再検査を除く"
        .AddItem "同一コースのみ"
'### 2003.02.23 Added by Ishihara@FSIT 定期健康診断追加
        .AddItem "定期健診のみ"
'### 2003.02.23 Added End
        .ListIndex = 0
    End With
    Call chkReportFlg_Click
    
    '用紙サイズ
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
    cboPaperSize.AddItem "はがき"
    
    cboPaperSize.ListIndex = 0
    
    '出力プリンタ
    With cboDefaultPrinter
        .Clear
        For Each objPrinter In Printers
            .AddItem objPrinter.DeviceName
        Next
    End With

    Do
        '帳票情報の編集
        If EditReport() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtReportCd.Enabled = (txtReportCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    tabMain.Tab = 0

    'Enabled制御のため１度呼び出す
    Call tabMain_Click(0)

    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub optPrtMachine_Click(Index As Integer)

    'サーバで印刷を設定された場合は、出力方法を制御
    If Index = 1 Then
        optPreView(1).Value = True
        optPreView(0).Enabled = False
    Else
        optPreView(0).Enabled = True
    End If
    
End Sub

' @(e)
'
' 機能　　 : 「タブ」Click
'
' 機能説明 : 非表示タブ内コントロールを使用不可にする（Focusが飛んでしまうため）
'
' 備考　　 :
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

