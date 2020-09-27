VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmMaster 
   AutoRedraw      =   -1  'True
   Caption         =   "webH@ins システム環境設定"
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
      Align           =   1  '上揃え
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
            Caption         =   "検索"
            Key             =   "Search"
            ImageIndex      =   5
            Style           =   2
         EndProperty
         BeginProperty Button2 {66833FEA-8583-11D1-B16A-00C0F0283628} 
            Caption         =   "フォルダ"
            Key             =   "Folder"
            ImageIndex      =   1
            Style           =   2
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox picSplitter 
      BackColor       =   &H00808080&
      BorderStyle     =   0  'なし
      FillColor       =   &H00808080&
      BeginProperty Font 
         Name            =   "ＭＳ Ｐゴシック"
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
      ScaleMode       =   0  'ﾕｰｻﾞｰ
      ScaleWidth      =   520
      TabIndex        =   6
      Top             =   676
      Visible         =   0   'False
      Width           =   52
   End
   Begin VB.PictureBox picTitles 
      Align           =   1  '上揃え
      Appearance      =   0  'ﾌﾗｯﾄ
      BorderStyle     =   0  'なし
      BeginProperty Font 
         Name            =   "ＭＳ Ｐゴシック"
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
         BorderStyle     =   1  '実線
         Caption         =   " フォルダ"
         Height          =   270
         Index           =   0
         Left            =   0
         TabIndex        =   3
         Tag             =   " ﾂﾘｰ ﾋﾞｭｰ:"
         Top             =   12
         Width           =   2016
      End
      Begin VB.Label lblTitle 
         BorderStyle     =   1  '実線
         Caption         =   " データ"
         Height          =   270
         Index           =   1
         Left            =   2078
         TabIndex        =   4
         Tag             =   " ﾘｽﾄ ﾋﾞｭｰ:"
         Top             =   12
         Width           =   3216
      End
   End
   Begin MSComctlLib.StatusBar stbMain 
      Align           =   2  '下揃え
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
         Caption         =   "検索開始(&S)"
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
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   14
         Top             =   2700
         Width           =   3555
      End
      Begin VB.TextBox txtSearchString 
         Height          =   315
         IMEMode         =   4  '全角ひらがな
         Left            =   180
         TabIndex        =   12
         Text            =   "Text1"
         Top             =   1980
         Width           =   3555
      End
      Begin VB.TextBox txtSearchCode 
         Height          =   315
         IMEMode         =   3  'ｵﾌ固定
         Left            =   180
         TabIndex        =   10
         Text            =   "Text1"
         Top             =   1260
         Width           =   3555
      End
      Begin VB.Line Line1 
         BorderColor     =   &H8000000A&
         BorderStyle     =   6  '実線 (ふちどり)
         BorderWidth     =   2
         X1              =   180
         X2              =   3540
         Y1              =   660
         Y2              =   660
      End
      Begin VB.Label Label1 
         BackStyle       =   0  '透明
         Caption         =   "データの検索"
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
         BackStyle       =   0  '透明
         Caption         =   "探す場所(&L):"
         Height          =   195
         Index           =   2
         Left            =   180
         TabIndex        =   13
         Top             =   2460
         Width           =   2175
      End
      Begin VB.Label Label1 
         BackStyle       =   0  '透明
         Caption         =   "名称に含まれる文字列(&M):"
         Height          =   255
         Index           =   1
         Left            =   180
         TabIndex        =   11
         Top             =   1740
         Width           =   2175
      End
      Begin VB.Label Label1 
         BackStyle       =   0  '透明
         Caption         =   "設定したコード(&C):"
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
      MousePointer    =   9  'ｻｲｽﾞ(左右)
      Top             =   702
      Width           =   52
   End
   Begin VB.Menu mnuFile 
      Caption         =   "ファイル(&F)"
      Begin VB.Menu mnuFileNew 
         Caption         =   "新規作成(&N)..."
         Shortcut        =   ^N
      End
      Begin VB.Menu mnuFileBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileOpen 
         Caption         =   "開く(&O)..."
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuFileBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuFileQuit 
         Caption         =   "終了(&X)"
      End
   End
   Begin VB.Menu mnuView 
      Caption         =   "表示(&V)"
      Begin VB.Menu mnuViewFolder 
         Caption         =   "フォルダ(&O)"
         Checked         =   -1  'True
         Shortcut        =   ^D
      End
      Begin VB.Menu mnuViewSearch 
         Caption         =   "検索(&F)"
         Shortcut        =   ^F
      End
   End
   Begin VB.Menu mnuEdit 
      Caption         =   "編集(&E)"
      Begin VB.Menu mnuEditDelete 
         Caption         =   "削除(&D)"
      End
   End
   Begin VB.Menu mnuOption 
      Caption         =   "ｵﾌﾟｼｮﾝ(&O)"
      Begin VB.Menu mnuOptionMch 
         Caption         =   "MCH病名連携(&B)"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "ヘルプ(&H)"
      Begin VB.Menu mnyHelpVersion 
         Caption         =   "バージョン情報(&A)"
      End
   End
   Begin VB.Menu mnuPopUp 
      Caption         =   "ポップアップ"
      Visible         =   0   'False
      Begin VB.Menu mnuPopUpUpdate 
         Caption         =   "開く(&R)"
      End
      Begin VB.Menu mnuPopUpBar1 
         Caption         =   "-"
      End
      Begin VB.Menu mnuPopUpNew 
         Caption         =   "新規作成(&W)"
      End
      Begin VB.Menu mnuPopUpBar2 
         Caption         =   "-"
      End
      Begin VB.Menu mnuPopUpDelete 
         Caption         =   "削除(&D)"
      End
   End
End
Attribute VB_Name = "frmMaster"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================
'管理番号：SL-HS-Y0101-001
'事象番号：COMP-LUKES-0018（非互換検証）
'修正日  ：2010.07.16
'担当者  ：FJTH)KOMURO
'修正内容：判定テーブルレイアウトとの同期
'========================================
'========================================
'管理番号：SL-HS-Y0101-001
'事象番号：COMP-LUKES-0029（非互換検証）
'修正日  ：2010.07.16
'担当者  ：FJTH)KOMURO
'修正内容：表示名称の修正
'========================================
'========================================
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.4
'担当者  ：T.Takagi@RD
'修正内容：予約確認メール送信機能追加
'========================================
Option Explicit

Private mcolGotFocusCollection      As Collection               'GotFocus時の文字選択用コレクション

Private mstrNodeKey                 As String                   'KeyDown,MouseDown時点で選択中のノードキー
Private mblnComAccess               As Boolean                  'TRUE=COM+アクセス済み、COM+未アクセス
Private mstrNowSearchTable          As String                   '検索対象テーブル

Private PV_MovingFlg                As Boolean                  ''移動中フラグ

Private Const SGLSPLITLIMIT         As Integer = 500            'スプリッターの限界値

Private Const ICON_CLOSED           As String = "CLOSED"        '閉じたフォルダ
Private Const ICON_OPEN             As String = "OPEN"          '開いたフォルダ
Private Const ICON_MYCOMPUTER       As String = "MYCOMP"        'マイコンピュータ
Private Const ICON_DEFAULTLIST      As String = "DEFAULTLIST"   'リストビュー用の標準アイコン
Private Const ICON_SEARCH           As String = "SEARCH"        '検索

'## 2005.03.23  Add by 李
Private Const SECURITY              As String = "SECURITY"      '権限管理
'## 2005.03.23  Add by End ..

Private Const NODE_ROOT             As String = "ROOT"          'ルートのキー値
Private Const NODE_SEARCH           As String = "SEARCH"        '検索結果のキー値
Private Const NODE_TYPEFOLDER       As String = "FOLDER"        'フォルダタイプのノード
Private Const KEY_PREFIX            As String = "KEY"           'リストビュー用キー値
Private Const KEY_SEPARATE          As String = "-"             'リストビュー用キー値（複数項目の結合キーに使用）

Private Const BUTTON_KEY_SEARCH     As String = "Search"        '検索
Private Const BUTTON_KEY_FOLDER     As String = "Folder"        '検索

Private Const TABLE_ITEMCLASS       As String = "ITEMCLASS"     '検査分類
Private Const TABLE_PROGRESS        As String = "PROGRESS"      '進捗管理用分類
Private Const TABLE_OPECLASS        As String = "OPECLASS"      '検査実施日分類
Private Const TABLE_ITEM_P          As String = "ITEM_P"        '依頼項目
Private Const TABLE_ITEM_C          As String = "ITEM_C"        '検査項目

Private Const TABLE_GRP             As String = "GRP"           'グループ
Private Const TABLE_GRP_R           As String = "GRP_R"         'グループ内依頼項目
Private Const TABLE_GRP_I           As String = "GRP_I"         'グループ内検査項目

'********** 2004/08/26 FJTH)M,E 団体グループ追加　*************************
Private Const TABLE_ORGGRP          As String = "ORGGRP_P"         'グループ
'********** 2004/08/26 FJTH)M,E 団体グループ追加　*************************


Private Const TABLE_CALC            As String = "CALC"          '計算
Private Const TABLE_STDVALUE        As String = "STDVALUE"      '基準値

'### 2008.02.10 Add by 張 ########################################################
Private Const TABLE_SP_STDVALUE     As String = "SP_STDVALUE"   '特定健診基準値
'### 2008.02.10 Add End ##########################################################

Private Const TABLE_STCCLASS        As String = "STCCLASS"      '文章分類
Private Const TABLE_SENTENCE_REC    As String = "SENTENCE_REC"  '文章
Private Const TABLE_SENTENCE_ITEM   As String = "SENTENCE_ITEM" '文章（検査項目から文章タイプのものを抽出）
Private Const TABLE_RSLCMT          As String = "RSLCMT"        '結果コメント

Private Const TABLE_JUDCLASS        As String = "JUDCLASS"      '判定分類
Private Const TABLE_JUD             As String = "JUD"           '判定
Private Const TABLE_STDJUD          As String = "STDJUD"        '定型所見
Private Const TABLE_JUDCMTSTC       As String = "JUDCMTSTC"     '判定コメント
Private Const TABLE_GUIDANCE        As String = "GUIDANCE"      '指導内容

Private Const TABLE_NUTRITARGET     As String = "NUTRITARGET"       '栄養計算目標量テーブル
Private Const TABLE_NUTRIFOODENERGY As String = "NUTRIFOODENERGY"   '食品群別摂取テーブル
Private Const TABLE_NUTRICOMPFOOD   As String = "NUTRICOMPFOOD"     '構成食品テーブル
Private Const TABLE_NUTRIMENULIST   As String = "NUTRIMENULIST"     '栄養献立リストテーブル

Private Const TABLE_COURSE          As String = "COURSE"        'コース
Private Const TABLE_WEB_CS          As String = "WEB_CS"        'webコース
Private Const TABLE_SETCLASS        As String = "SETCLASS"      'セット分類

Private Const TABLE_DISDIV          As String = "DISDIV"        '病類
Private Const TABLE_DISEASE         As String = "DISEASE"       '病名
Private Const TABLE_STDCONTACTSTC   As String = "STDCONTACTSTC" '定型面接文章

Private Const TABLE_RSVFRA          As String = "RSVFRA"        '予約枠
Private Const TABLE_RSVGRP          As String = "RSVGRP"        '予約群
Private Const TABLE_COURSE_RSVGRP   As String = "COURSE_RSVGRP" 'コース受診予約群


Private Const TABLE_ZAIMU           As String = "ZAIMU"         '財務情報
Private Const TABLE_ZAIMUINFO       As String = "ZAIMUINFO"     '財務連携CSV情報
Private Const TABLE_BILLCLASS       As String = "BILLCLASS"     '請求書分類
Private Const TABLE_DMDLINECLASS    As String = "DMDLINECLASS"  '請求明細分類

'### 2004/1/15 Added by Ishihara@FSIT セット外請求明細追加
Private Const TABLE_OTHERLINEDIV    As String = "OTHERLINEDIV"  'セット外請求明細
'### 2004/1/15 Added End
'## 2004.05.28 ADD STR ORB)T.YAGUCHI ２次請求明細
Private Const TABLE_SECONDLINEDIV   As String = "SECONDLINEDIV"  '２次請求明細
'## 2004.05.28 ADD END

Private Const TABLE_ROUNDCLASS      As String = "ROUNDCLASS"    'まるめ分類

Private Const TABLE_RELATION        As String = "RELATION"      '続柄
Private Const TABLE_PUBNOTEDIV      As String = "PUBNOTEDIV"    'ノート情報区分

Private Const TABLE_REPORT          As String = "REPORT"        '帳票
Private Const TABLE_PREF            As String = "PREF"          '都道府県
Private Const TABLE_SYSPRO          As String = "SYSPRO"        '環境設定
Private Const TABLE_FREE            As String = "FREE"          '汎用テーブル
Private Const TABLE_SYSPROSUB       As String = "SYSPROSUB"     '環境設定分類別
Private Const TABLE_WORKSTATION     As String = "WORKSTATION"   '端末管理
Private Const TABLE_HAINSUSER       As String = "HAINSUSER"     'ユーザ
Private Const TABLE_UPDSTDVALUE     As String = "UPDSTDVALUE"   '指定期間内の基準値更新

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
Private Const TABLE_MAILCONF        As String = "MAILCONF"      '予約メール送信設定（基本設定）
Private Const TABLE_MAILTEMPLATE    As String = "MAILTEMPLATE"  '予約メール送信設定（メールテンプレート）
Private Const TABLE_ORDEREXCEL      As String = "ORDEREXCEL"    'オーダ連携設定用EXCEL
Private Const ORDEREXCELFILENAME    As String = "オーダ連携検査項目マスタ設定.xls"
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####

'### 2005.3.23 Add by 李
Private Const NODE_SECURITY_ROOT        As String = "NODE_SECURITY_ROOT"        '権限管理 ROOT
Private Const NODE_SECURITY_UGRPGM      As String = "NODE_SECURITY_UGRPGM"       'ユーザーグループ別プログラム
Private Const NODE_SECURITY_USERGRP     As String = "NODE_SECURITY_USERGRP"     'ユーザーグループ
Private Const NODE_SECURITY_MENUGRP     As String = "NODE_SECURITY_MENUGRP"     'メニューグループ
Private Const NODE_SECURITY_PGMINFO     As String = "NODE_SECURITY_PGMINFO"     '
Private Const NODE_SECURITY_PWD         As String = "NODE_SECURITY_PWD"     '

Private Const TABLE_SECURITYGRP         As String = "UGR"                       '
Private Const TABLE_MENUPGM             As String = "MENU"                      '
'### 2005.3.23 Add End ...

'
' 機能　　 : ツリー編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditTreeView()

    Dim colNodes    As Nodes    'ノードコレクション
    Dim objNode     As Node     'ノードオブジェクト
    
    '各ノードの編集
    Set colNodes = trvMaster.Nodes
    
    With colNodes
        .Clear
        'テーブル(Root)を設定
        .Add , , NODE_ROOT, "webHainsの管理"
            
        '各テーブル分野を指す子ノードを編集
        
        '検査項目情報関連
        .Add NODE_ROOT, tvwChild, "ITEM", "検査項目情報"
        .Add "ITEM", tvwChild, TABLE_ITEMCLASS, "検査分類"
        .Add "ITEM", tvwChild, TABLE_PROGRESS, "進捗管理用分類"
'### 2003.11.23 Deleted by H.Ishihara@FSIT 聖路加未使用項目削除
'        .Add "ITEM", tvwChild, TABLE_OPECLASS, "検査実施日分類"
'### 2003.11.23 Deleted End
        .Add "ITEM", tvwChild, TABLE_ITEM_P, "依頼項目"
        .Add "ITEM", tvwChild, TABLE_ITEM_C, "検査項目"
    
        'グループ関連
        .Add NODE_ROOT, tvwChild, "GROUP", "グループ情報"
        .Add "GROUP", tvwChild, TABLE_GRP_R, "依頼項目のグループ"
        .Add "GROUP", tvwChild, TABLE_GRP_I, "検査項目のグループ"
'************ 2004/08/26 fjth)M,E　団体グループの追加　-S ******************
        .Add "GROUP", tvwChild, TABLE_ORGGRP, "団体グループ"
'************ 2004/08/26 fjth)M,E　団体グループの追加　-E ******************
    
        '結果関連
        .Add NODE_ROOT, tvwChild, "RESULT", "結果関連"
        .Add "RESULT", tvwChild, TABLE_CALC, "計算"
        .Add "RESULT", tvwChild, TABLE_STDVALUE, "基準値"
'### 2008.02.10 Add by 張 特定健診基準値追加 ###############################
        .Add "RESULT", tvwChild, TABLE_SP_STDVALUE, "特定健診用基準値"
'### 2008.02.10 Add End ###################################################
        .Add "RESULT", tvwChild, TABLE_RSLCMT, "結果コメント"
        .Add "RESULT", tvwChild, "SENTENCE", "文章"
        .Add "SENTENCE", tvwChild, TABLE_STCCLASS, "文章分類"
        .Add "SENTENCE", tvwChild, TABLE_SENTENCE_REC, "文章一覧"
        .Add "SENTENCE", tvwChild, TABLE_SENTENCE_ITEM, "文章タイプの項目一覧"
        
        '判定関連
        .Add NODE_ROOT, tvwChild, "JUDGMENT", "判定関連"
        .Add "JUDGMENT", tvwChild, TABLE_JUDCLASS, "判定分類"
        .Add "JUDGMENT", tvwChild, TABLE_JUD, "判定"
'        .Add "JUDGMENT", tvwChild, TABLE_STDJUD, "定型所見"
        .Add "JUDGMENT", tvwChild, TABLE_JUDCMTSTC, "判定コメント"
        .Add "JUDGMENT", tvwChild, TABLE_GUIDANCE, "指導内容"
    
        .Add NODE_ROOT, tvwChild, "NOURISHMENT", "栄養関連"
        .Add "NOURISHMENT", tvwChild, TABLE_NUTRITARGET, "栄養計算目標量"
        .Add "NOURISHMENT", tvwChild, TABLE_NUTRIFOODENERGY, "食品群別摂取"
        .Add "NOURISHMENT", tvwChild, TABLE_NUTRICOMPFOOD, "構成食品"
        .Add "NOURISHMENT", tvwChild, TABLE_NUTRIMENULIST, "栄養献立リスト"
    
        'コース関連
        .Add NODE_ROOT, tvwChild, "COURSE_MAIN", "受診コース"
        .Add "COURSE_MAIN", tvwChild, TABLE_COURSE, "基本コース"
        .Add "COURSE_MAIN", tvwChild, TABLE_SETCLASS, "セット分類"
'### 2003.11.23 Deleted by H.Ishihara@FSIT 聖路加未使用項目削除
'        .Add "COURSE_MAIN", tvwChild, TABLE_WEB_CS, "インターネット用説明"
'### 2003.11.23 Deleted End
    
'### 2003.11.23 Deleted by H.Ishihara@FSIT 聖路加未使用項目削除
'        'コース関連
'        .Add NODE_ROOT, tvwChild, "AFTER_MAIN", "事後措置、傷病休業"
'        .Add "AFTER_MAIN", tvwChild, TABLE_DISDIV, "病類"
'        .Add "AFTER_MAIN", tvwChild, TABLE_DISEASE, "病名"
'        .Add "AFTER_MAIN", tvwChild, TABLE_STDCONTACTSTC, "定型面接文章"
'### 2003.11.23 Deleted End
    
        'スケジュール関連
        .Add NODE_ROOT, tvwChild, "SCHEDULE", "スケジュール"
        .Add "SCHEDULE", tvwChild, TABLE_RSVFRA, "予約枠"
        .Add "SCHEDULE", tvwChild, TABLE_RSVGRP, "予約群"
        .Add "SCHEDULE", tvwChild, TABLE_COURSE_RSVGRP, "コース受診予約群"
    
        '請求関連
        .Add NODE_ROOT, tvwChild, "DEMAND", "請求関連"
'### 2004/1/15 Added by Ishihara@FSIT セット外請求明細追加
        .Add "DEMAND", tvwChild, TABLE_OTHERLINEDIV, "セット外請求明細"
'### 2004/1/15 Added End
'## 2004.05.28 ADD STR ORB)T.YAGUCHI ２次請求明細
        .Add "DEMAND", tvwChild, TABLE_SECONDLINEDIV, "２次請求明細"
'## 2004.05.28 ADD END

'### 2004/01/15 Deleted by H.Ishihara@FSIT 聖路加未使用項目削除
'        .Add "DEMAND", tvwChild, TABLE_BILLCLASS, "請求書分類"
'        .Add "DEMAND", tvwChild, TABLE_DMDLINECLASS, "請求明細分類"
'### 2003.11.23 Deleted by H.Ishihara@FSIT 聖路加未使用項目削除
'        .Add "DEMAND", tvwChild, TABLE_ROUNDCLASS, "まるめ分類"
'        .Add "DEMAND", tvwChild, TABLE_ZAIMU, "財務連携設定コード"
'        .Add "DEMAND", tvwChild, TABLE_ZAIMUINFO, "財務連携データ"
    
'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        .Add NODE_ROOT, tvwChild, "SENDMAIL", "予約メール送信設定"
        .Add "SENDMAIL", tvwChild, TABLE_MAILCONF, "基本設定"
        .Add "SENDMAIL", tvwChild, TABLE_MAILTEMPLATE, "メールテンプレート"
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####
    
        'その他設定
        .Add NODE_ROOT, tvwChild, "OTHER", "その他管理用設定"
        .Add "OTHER", tvwChild, TABLE_RELATION, "続柄"
        .Add "OTHER", tvwChild, TABLE_PUBNOTEDIV, "コメント情報区分"
        .Add "OTHER", tvwChild, TABLE_REPORT, "帳票設定"
        .Add "OTHER", tvwChild, TABLE_PREF, "都道府県"
        .Add "OTHER", tvwChild, TABLE_SYSPRO, "システム環境設定"
        .Add TABLE_SYSPRO, tvwChild, TABLE_SYSPROSUB, "環境設定"
        .Add TABLE_SYSPRO, tvwChild, TABLE_FREE, "汎用テーブル"
'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        .Add TABLE_SYSPRO, tvwChild, TABLE_ORDEREXCEL, "オーダ連携マスタ設定"
'#### 2013.3.4 SL-SN-Y0101-612 ADD END ####
        
        .Add "OTHER", tvwChild, TABLE_WORKSTATION, "端末管理"
        .Add "OTHER", tvwChild, TABLE_HAINSUSER, "ユーザ"
        .Add "OTHER", tvwChild, TABLE_UPDSTDVALUE, "基準値の再設定"
        .Add , , NODE_SEARCH, "検索結果"
        
'## 2005.03.18 YHLEE --------------------------------------------------------------------------------
        .Add , , NODE_SECURITY_ROOT, "権限管理"
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_UGRPGM, "セキュリティーグループ別プログラム情報"
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_USERGRP, "ユーザーグループ管理"
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_MENUGRP, "メニューグループ管理"
'#### 2010.07.16 SL-HS-Y0101-001 MOD START ####　COMP-LUKES-0029（非互換検証）
'        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_PGMINFO, "プルグラム情報管理"
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_PGMINFO, "プログラム情報管理"
'#### 2010.07.16 SL-HS-Y0101-001 MOD END 　####　COMP-LUKES-0029（非互換検証）
        
        .Add NODE_SECURITY_ROOT, tvwChild, NODE_SECURITY_PWD, "パスワード有効期間設定"
'## 2005.03.18 YHLEE --------------------------------------------------------------------------------

    End With
    
    For Each objNode In colNodes
        '各ノードに対するイメージの設定
        objNode.Image = ICON_CLOSED
        
        Select Case objNode.Key
            Case "ROOT"
                'ROOTノードならそのまま展開
                objNode.Child.EnsureVisible
            
            Case NODE_SEARCH
'                objNode.Visible = False

            '## 2005.3.23 Add by 李
            Case NODE_SECURITY_ROOT
                objNode.Image = SECURITY
            
            '## 2005.3.23 Add　End ...
            
            Case Else
''                'ROOTノード直下、かつ子ノードが存在するなら展開
''                If (objNode.Parent.Key = "ROOT") And (objNode.Children <> 0) Then
''                    objNode.Child.EnsureVisible
''                End If
        
        End Select

'        If objNode.Key = "ROOT" Then
'            'ROOTノードならそのまま展開
'            objNode.Child.EnsureVisible
'        Else
'
'            'ROOTノード直下、かつ子ノードが存在するなら展開
'            If (objNode.Parent.Key = "ROOT") And (objNode.Children <> 0) Then
'                objNode.Child.EnsureVisible
'            End If
'        End If
    
    Next
    
    'ROOTノードを選択済みにする
    colNodes(NODE_ROOT).Selected = True

End Sub

'
' 機能　　 : ツリービューからのリストビュー編集
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : 指定されたノードに対応するコンテンツ一覧を表示する
'
Private Sub EditListViewFromContents(strNodeKey As String)

    Dim lngCount            As Long             'レコード数

    '件数表示用領域初期化
    lngCount = -1
    stbMain.Panels.Item(1).Text = ""
    
    Select Case strNodeKey
        
        Case TABLE_ITEMCLASS
            '検査分類テーブル
            Call EditListViewFromItemClass(strNodeKey, lngCount)
        
        Case TABLE_PROGRESS
            '進捗管理用分類テーブル
            Call EditListViewFromProgress(strNodeKey, lngCount)
        
        Case TABLE_OPECLASS
            '検査実施日分類テーブル
            Call EditListViewFromOpeClass(strNodeKey, lngCount)
    
        Case TABLE_ITEM_P
            '依頼項目テーブル（親ノード）
            Call EditTreeViewFromItemClass(TABLE_ITEM_P)
    
        Case TABLE_ITEM_C
            '検査項目テーブル（親ノード）
            Call EditTreeViewFromItemClass(TABLE_ITEM_C)
        
        '------------------------------------------------
        Case TABLE_GRP_R
            'グループテーブル（依頼項目）
            Call EditListViewFromGrp(strNodeKey, TABLE_GRP_R, lngCount)
        
        Case TABLE_GRP_I
            'グループテーブル（検査項目）
            Call EditListViewFromGrp(strNodeKey, TABLE_GRP_I, lngCount)
            
' ********* 2004/08/26 FJTH)M,E -S ***********************************************
        Case TABLE_ORGGRP
            'グループテーブル（団体項目）
            Call EditListViewFromGrp(strNodeKey, TABLE_ORGGRP, lngCount)
' ********* 2004/08/26 FJTH)M,E -E ***********************************************
            
    
        '------------------------------------------------

        Case TABLE_CALC
            '計算テーブル
            Call EditListViewFromCalc(strNodeKey, lngCount)
        
        Case TABLE_STDVALUE
            '基準値テーブル（親ノード）
            Call EditTreeViewFromItemClass(TABLE_STDVALUE)
    
'### 2008.02.10 Add by 張 特定健診基準値追加 ###############################
        Case TABLE_SP_STDVALUE
            '特定健診用基準値テーブル（親ノード）
            Call EditTreeViewFromItemClass(TABLE_SP_STDVALUE)
'### 2008.02.10 Add End ###################################################
        
        Case TABLE_STCCLASS
            '文章テーブル（レコードイメージ）
            Call EditListViewFromStcClass(strNodeKey, lngCount)
    
        Case TABLE_SENTENCE_REC
            '文章テーブル（レコードイメージ）
            Call EditListViewFromSentence(strNodeKey, lngCount)
    
        Case TABLE_SENTENCE_ITEM
            '文章テーブル（文章タイプの検査項目一覧）
            Call EditListViewFromSentenceItem(strNodeKey, lngCount)

        Case TABLE_RSLCMT
            '結果コメントテーブル
            Call EditListViewFromRslCmt(strNodeKey, lngCount)
    
        '------------------------------------------------
        Case TABLE_NUTRITARGET
            '栄養計算目標量テーブル
            Call EditListViewFromNutriTarget(strNodeKey, lngCount)
    
        Case TABLE_NUTRIFOODENERGY
            '食品群別摂取テーブル
            Call EditListViewFromNutriFoodEnergy(strNodeKey, lngCount)
        
        Case TABLE_NUTRICOMPFOOD
            '構成食品テーブル
            Call EditListViewFromNutriCompFood(strNodeKey, lngCount)
        
        Case TABLE_NUTRIMENULIST
            '栄養献立リストテーブル
            Call EditListViewFromNutriMenuList(strNodeKey, lngCount)
    
        '------------------------------------------------
        Case TABLE_JUDCLASS
            '判定分類テーブル
            Call EditListViewFromJudClass(strNodeKey, lngCount)
    
        Case TABLE_JUD
            '判定テーブル
            Call EditListViewFromJud(strNodeKey, lngCount)
    
        Case TABLE_STDJUD
            '定型所見テーブル（親ノード）
            Call EditTreeViewFromJudClass(TABLE_STDJUD)
    
        Case TABLE_GUIDANCE
            '指導内容テーブル（親ノード）
            Call EditTreeViewFromJudClass(TABLE_GUIDANCE)
    
        Case TABLE_JUDCMTSTC
            '判定コメントテーブル（親ノード）
            Call EditTreeViewFromJudClass(TABLE_JUDCMTSTC)
    
        '------------------------------------------------
        Case TABLE_COURSE
            'コーステーブル
            Call EditListViewFromCourse(strNodeKey, lngCount)
        
        Case TABLE_WEB_CS
            'webコーステーブル
            Call EditListViewFromWeb_Cs(strNodeKey, lngCount)
        
        Case TABLE_SETCLASS
            'セット分類テーブル
            Call EditListViewFromSetClass(strNodeKey, lngCount)
        
        '------------------------------------------------
        Case TABLE_DISDIV
            '病類
            Call EditListViewFromDisDiv(strNodeKey, lngCount)
        
        Case TABLE_DISEASE
            '病名
            Call EditListViewFromDisease(strNodeKey, lngCount)
        
        Case TABLE_STDCONTACTSTC
            '定型面接文章
            Call EditListViewFromStdContactStc(strNodeKey, lngCount)
        
        '------------------------------------------------
        Case TABLE_RSVFRA
            '予約枠テーブル
            Call EditListViewFromRsvFra(strNodeKey, lngCount)
        
        Case TABLE_RSVGRP
            '予約群テーブル
            Call EditListViewFromRsvGrp(strNodeKey, lngCount)
        
        Case TABLE_COURSE_RSVGRP
            'コース受診予約群テーブル
            Call EditListViewFromCourseRsvGrp(strNodeKey, lngCount)

        '------------------------------------------------
        Case TABLE_ZAIMU
            '財務テーブル
            Call EditListViewFromZaimu(strNodeKey, lngCount)
        
        Case TABLE_BILLCLASS
            '請求書テーブル
            Call EditListViewFromBillClass(strNodeKey, lngCount)
        
        Case TABLE_DMDLINECLASS
            '請求明細分類テーブル
            Call EditListViewFromDmdLineClass(strNodeKey, lngCount)
        
        Case TABLE_ROUNDCLASS
            'まるめ分類テーブル
            Call EditListViewFromRoundClass(strNodeKey, lngCount)
        
'### 2004/1/15 Added by Ishihara@FSIT セット外請求明細追加
        Case TABLE_OTHERLINEDIV
            'セット外請求明細テーブル
            Call EditListViewFromOtherLineDiv(strNodeKey, lngCount)
'### 2004/1/15 Added End
        
'## 2004.05.28 ADD STR ORB)T.YAGUCHI ２次請求明細
        Case TABLE_SECONDLINEDIV
            '２次請求明細テーブル
            Call EditListViewFromSecondLineDiv(strNodeKey, lngCount)
'## 2004.05.28 ADD END
        
'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        Case TABLE_MAILCONF
            '予約メール送信設定（基本設定）
            Call EditListViewFromMailConf(strNodeKey, lngCount)

        Case TABLE_MAILTEMPLATE
            '予約メール送信設定（基本設定）
            Call EditListViewFromMailTemplate(strNodeKey, lngCount)

        Case TABLE_ORDEREXCEL
            'オーダ連携Excel起動
            Call OpenOrderRenkeiExcel
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####
        
        '------------------------------------------------
        Case TABLE_RELATION
            '続柄テーブル
            Call EditListViewFromRelation(strNodeKey, lngCount)
        
        Case TABLE_PUBNOTEDIV
            'ノート情報分類テーブル
            Call EditListViewFromPubNoteDiv(strNodeKey, lngCount)
        
        Case TABLE_PREF
            '都道府県テーブル
            Call EditListViewFromPref(strNodeKey, lngCount)
    
        Case TABLE_SYSPROSUB
            'システム環境設定
            Call EditListViewFromSysPro(strNodeKey, lngCount)
        
        Case TABLE_FREE
            '汎用テーブル
            Call EditListViewFromFree(strNodeKey, lngCount)
        
        Case TABLE_WORKSTATION
            '端末管理テーブル
            Call EditListViewFromWorkStation(strNodeKey, lngCount)
        
        Case TABLE_REPORT
            '帳票テーブル
            Call EditListViewFromReport(strNodeKey, lngCount)
        
        Case TABLE_HAINSUSER
            'ユーザテーブル
            Call EditListViewFromHainsUser(strNodeKey, lngCount)
        
        Case TABLE_UPDSTDVALUE
            '結果値からの基準値コード全更新
'            Call EditListViewFromHainsUser(strNodeKey, lngCount)
        
        '------------------------------------------------
''####### 2005.03.23  ADD by 李
        Case NODE_SECURITY_UGRPGM
            Call EditListViewFromUserGroup(strNodeKey, lngCount)
    
        Case NODE_SECURITY_USERGRP, NODE_SECURITY_MENUGRP, NODE_SECURITY_PGMINFO, NODE_SECURITY_PWD
            Call EditListViewFromUserGroup(strNodeKey, lngCount)
    
''####### 2005.03.23  ADD End ...
    
    
        Case Else
            '依頼項目テーブル
            If Mid(strNodeKey, 1, Len(TABLE_ITEM_P)) = TABLE_ITEM_P Then
                Call EditListViewFromItem_p(strNodeKey, Mid(strNodeKey, Len(TABLE_ITEM_P) + 1, Len(strNodeKey)), lngCount)
            End If
            
            '検査項目テーブル
            If Mid(strNodeKey, 1, Len(TABLE_ITEM_C)) = TABLE_ITEM_C Then
                Call EditListViewFromItem_c(strNodeKey, Mid(strNodeKey, Len(TABLE_ITEM_C) + 1, Len(strNodeKey)), lngCount)
            End If
            
            '基準値テーブル
            If Mid(strNodeKey, 1, Len(TABLE_STDVALUE)) = TABLE_STDVALUE Then
                Call EditListViewFromStdValue(strNodeKey, Mid(strNodeKey, Len(TABLE_STDVALUE) + 1, Len(strNodeKey)), lngCount)
            End If
            
'### 2008.02.10 Add by 張 特定健診基準値追加 ###############################
            
            '特定健診用基準値テーブル
            If Mid(strNodeKey, 1, Len(TABLE_SP_STDVALUE)) = TABLE_SP_STDVALUE Then
                Call EditListViewFromSpStdValue(strNodeKey, Mid(strNodeKey, Len(TABLE_SP_STDVALUE) + 1, Len(strNodeKey)), lngCount)
            End If
            
'### 2008.02.10 Add End ###################################################
            
            '定型所見テーブル
            If Mid(strNodeKey, 1, Len(TABLE_STDJUD)) = TABLE_STDJUD Then
                Call EditListViewFromStdJud(strNodeKey, CInt(Mid(strNodeKey, Len(TABLE_STDJUD) + 1, Len(strNodeKey))), lngCount)
            End If
            
            '指導内容テーブル
            If Mid(strNodeKey, 1, Len(TABLE_GUIDANCE)) = TABLE_GUIDANCE Then
'### 2003.01.17 Modified by H.Ishihara@FSIT 判定分類未指定も表示する
'                Call EditListViewFromGuidance(strNodeKey, CInt(Mid(strNodeKey, Len(TABLE_GUIDANCE) + 1, Len(strNodeKey))), lngCount)
                 Call EditListViewFromGuidance(strNodeKey, Mid(strNodeKey, Len(TABLE_GUIDANCE) + 1, Len(strNodeKey)), lngCount)
'### 2003.01.17 Modified End
            End If
        
            '判定コメントテーブル
            If Mid(strNodeKey, 1, Len(TABLE_JUDCMTSTC)) = TABLE_JUDCMTSTC Then
                Call EditListViewFromJudCmtStc(strNodeKey, Mid(strNodeKey, Len(TABLE_JUDCMTSTC) + 1, Len(strNodeKey)), lngCount)
            End If
        
'#### 2005.3.25 Add by 李
            If Mid(strNodeKey, 1, Len(TABLE_SECURITYGRP)) = TABLE_SECURITYGRP Then
                Call EditListViewFromUserGroup(strNodeKey, lngCount)
            End If
            
            If Mid(strNodeKey, 1, Len(TABLE_MENUPGM)) = TABLE_MENUPGM Then
                Call EditListViewFromPgmInfoList(strNodeKey, lngCount)
            End If
            
'#### 2005.3.25 Add End ...
            
    End Select
    
    '取得件数を表示
    If lngCount > -1 Then
        stbMain.Panels.Item(1).Text = lngCount & " 個のレコードが見つかりました。"
    End If
    
End Sub

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
'
' 機能　　 : オーダー連携用Excelファイル起動
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub OpenOrderRenkeiExcel()

    '起動確認（キャンセルなら終了）
    If MsgBox("オーダ連携用マスタ設定Excel(オーダ連携検査項目マスタ設定.xls)を開きます、よろしいですか？" & vbLf & _
              "(Excelがインストールされていない環境では起動できません)", vbQuestion + vbYesNo, "オーダ連携EXCEL起動") = vbCancel Then Exit Sub
    
    'ファイルの存在チェック
    Dim cFso As FileSystemObject
    Set cFso = New FileSystemObject
    Dim excelFileFullPath   As String
    excelFileFullPath = App.Path & "\" & ORDEREXCELFILENAME
    
    ' ファイルが存在しているかどうか確認する
    If cFso.FileExists(excelFileFullPath) = False Then
        
        Call MsgBox("指定されたファイルは存在しません" & vbLf & excelFileFullPath, vbCritical)
        Exit Sub
    
    End If


    'Excel起動
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
' MCH連携：病名マスタ連携
Private Sub MchByomeiCooperation()

    Dim wFileName           As String                   'CSVファイルパス名
    Dim wFno                As Integer                  'CSVファイル番号
    Dim wCancelFlg          As Boolean                  'キャンセルフラグ
    Dim wBuff               As String                   '編集領域
    
    Dim i                   As Long                     '添え字
    Dim RetB                As String                   '戻り値（真偽）
    
    Dim lngCount            As Long                     'カウンタ
    Dim vntFreeField1       As Variant                  '項目コード
    Dim vntFreeField2       As Variant                  '項目タイプ
    Dim vntStcCd            As Variant                  '病名コード（文章コード）
    Dim vntShortStc         As Variant                  '病名（略称）
    Dim objFree             As Object                   '汎用テーブル
    Dim objSentence         As Object                   '文章テーブル

On Error GoTo MchByomeiCooperation_Error

    
    wCancelFlg = False
    Set objFree = CreateObject("HainsFree.Free")
    Set objSentence = CreateObject("HainsSentence.Sentence")
    
    '汎用テーブルから病名コードを取得する項目コード及び項目タイプを取得する
    lngCount = objFree.SelectFree(0, "MCHCOOP", , , , vntFreeField1, vntFreeField2)
    If lngCount <= 0 Then
        '対象データなし
        MsgBox "MCH連携用の汎用テーブル（MCHCOOP）が登録されていません。", vbCritical, "HCH 病名マスタ連携"
        GoTo MchByomeiCooperation_Exit
    End If
    
    lngCount = objSentence.SelectSentenceList(vntFreeField1 & "", vntFreeField2 & "" _
                                                            , vntStcCd, vntShortStc)
    If lngCount <= 0 Then
        MsgBox "対象となる病名データがありません。", vbExclamation, "HCH 病名マスタ連携"
        GoTo MchByomeiCooperation_Exit
    End If
    
    'CSVファイル指定
    wFileName = GetSetting("MchCooperation", "MchDisease", "CsvFileName", "disease.txt")
    With dlgCommonDialog
        .Filter = "ﾃｷｽﾄﾌｧｲﾙ(*.TXT)|*.TXT|CSVﾌｧｲﾙ(*.CSV)|*.CSV|全てのﾌｧｲﾙ(*.*)|*.*"
        .FileName = wFileName
        .ShowSave
    End With
    If wCancelFlg = True Then
        'キャンセル
        GoTo MchByomeiCooperation_Exit
    End If
    
    '病名連携データ書き込み
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
    Resume  'デバッグ用

End Sub

'
' 機能　　 : テーブルメンテナンス画面を開く
'
' 引数　　 : (In)      vntNodeKey  (リストアイテムの)ノードキー
' 　　　　 : (In)      vntItemKey  (リストアイテムの)アイテムキー
'
' 戻り値　 : TRUE:データ更新あり、FALSE:データ更新なし
'
' 備考　　 :
'
Private Function ShowEditWindow(ByVal vntNodeKey As Variant, _
                                Optional ByVal vntItemKey As Variant, _
                                Optional ByVal vntItemText As Variant) As Boolean

On Error GoTo ErrorHandle

    Dim colNodes        As Nodes    'ノードコレクション
    Dim objEditWindow   As Object   'メンテナンスウインドウオブジェクト
    Dim vntKey          As Variant  'レコードキー
    Dim strSetKey       As String
    
    Dim strSplitKey1    As String   'スプリット用キー
    Dim strSplitKey2    As String   'スプリット用キー
    
    Dim strItemCd       As String   'スプリット用キー
    Dim strSuffix       As String   'スプリット用キー
    Dim strItemType     As String   'スプリット用キー
    Dim strStcCd        As String   'スプリット用キー
    Dim strItemName     As String   '文章テーブルメンテナンス用の項目名退避用
    
    ShowEditWindow = False
    
    
    'キー値の取得
    If Not IsMissing(vntItemKey) Then
        vntKey = SplitKey(KEY_PREFIX, vntItemKey)
    End If
    
    'Splitした結果、値があるならKeyセット
    If Not IsEmpty(vntKey) Then
        strSetKey = vntKey(0)
    Else
        strSetKey = ""
    End If
    
    Select Case vntNodeKey
        
        '検査分類テーブル
        Case TABLE_ITEMCLASS
            Set objEditWindow = New mntItemClass.ItemClass
            objEditWindow.ItemClassCd = strSetKey

        '進捗管理用分類テーブル
        Case TABLE_PROGRESS
            Set objEditWindow = New mntProgress.Progress
            objEditWindow.ProgressCd = strSetKey

        '検査実施日分類テーブル
        Case TABLE_OPECLASS
            Set objEditWindow = New mntOpeClass.OpeClass
            objEditWindow.OpeClassCd = strSetKey

        'コーステーブル
        Case TABLE_COURSE
            Set objEditWindow = New mntCourse.Course
            objEditWindow.CsCd = strSetKey

        'コーステーブル
        Case TABLE_SETCLASS
            Set objEditWindow = New mntSetClass.SetClass
            objEditWindow.SetClassCd = strSetKey

        'WEBコース設定
        Case TABLE_WEB_CS
            Set objEditWindow = New mntWeb_Cs.Web_Cs
            objEditWindow.CsCd = strSetKey

        '予約枠テーブル
        Case TABLE_RSVFRA
            Set objEditWindow = New mntRsvFra.RsvFra
            objEditWindow.RsvFraCd = strSetKey

        '予約群テーブル
        Case TABLE_RSVGRP
            Set objEditWindow = New mntRsvGrp.RsvGrp
            objEditWindow.RsvGrpCd = strSetKey

        'コース受診予約群
        Case TABLE_COURSE_RSVGRP
            Set objEditWindow = New mntCourseRsvGrp.CourseRsvGrp
            'コースコードと予約群コードを抜く
            Call SplitItemAndSuffix(strSetKey, strItemCd, strSuffix)
            objEditWindow.CsCd = strItemCd
            objEditWindow.RsvGrpCd = strSuffix

        'グループ内依頼項目テーブル
        Case TABLE_GRP_R
            Set objEditWindow = New mntGrp.Grp
            objEditWindow.GrpDiv = MODE_REQUEST
            objEditWindow.GrpCd = strSetKey

        'グループ内検査項目テーブル
        Case TABLE_GRP_I
            Set objEditWindow = New mntGrp.Grp
            objEditWindow.GrpDiv = MODE_RESULT
            objEditWindow.GrpCd = strSetKey
'
''************** 2004/08/26 FJTH)M,E  団体グループ追加　-S ***********************
'        '団体グループテーブル
        Case TABLE_ORGGRP
            Set objEditWindow = New mntOrgGrp.Grp
            objEditWindow.GrpDiv = MODE_RESULT
            objEditWindow.GrpCd = strSetKey
''************** 2004/08/26 FJTH)M,E  団体グループ追加　-E ***********************


        '結果コメントテーブル
        Case TABLE_RSLCMT
            Set objEditWindow = New mntRslCmt.RslCmt
            objEditWindow.RslCmtCd = strSetKey

        '判定分類テーブル
        Case TABLE_JUDCLASS
            Set objEditWindow = New mntJudClass.JudClass
            objEditWindow.JudClassCd = strSetKey

        '判定テーブル
        Case TABLE_JUD
            Set objEditWindow = New mntJud.Jud
            objEditWindow.JudCd = strSetKey

        '栄養計算目標量テーブル
        Case TABLE_NUTRITARGET
'*********** 2004/08/26 FJTH)M,E メッセージでお茶を濁す - S
             MsgBox "栄養計算及びシステム内部で使用している為、栄養計算目標量は修正できません。", vbCritical, "栄養計算目標量"
             Exit Function
'*********** 2004/08/26 FJTH)M,E メッセージでお茶を濁す - S


        '食品群別摂取テーブル
        Case TABLE_NUTRIFOODENERGY
            Set objEditWindow = New mntNutriFoodEnergy.NutriFoodEnergy
            objEditWindow.Energy = strSetKey

        '構成食品テーブル
        Case TABLE_NUTRICOMPFOOD
            Set objEditWindow = New mntNutriCompFood.NutriCompFood
            objEditWindow.ComposeFoodCd = strSetKey

        '栄養献立リストテーブル
        Case TABLE_NUTRIMENULIST
'*********** 2004/08/26 FJTH)M,E メッセージでお茶を濁す - S
             MsgBox "栄養計算及びシステム内部で使用している為、栄養献立リストは修正できません。", vbCritical, "栄養献立リスト"
             Exit Function
'*********** 2004/08/26 FJTH)M,E メッセージでお茶を濁す - S


        '病類テーブル
        Case TABLE_DISDIV
            Set objEditWindow = New mntDisDiv.DisDiv
            objEditWindow.DisDivCd = strSetKey

        '病名テーブル
        Case TABLE_DISEASE
            Set objEditWindow = New mntDisease.Disease
            objEditWindow.DisCd = strSetKey

        '定型面接文章テーブル
        Case TABLE_STDCONTACTSTC
            Set objEditWindow = New mntStdContactStc.StdContactStc
            '指導内容区分と定型面接文章コードを抜く
            Call SplitItemAndSuffix(strSetKey, strItemCd, strSuffix)
            With objEditWindow
                .GuidanceDiv = strItemCd
                .StdContactStcCd = strSuffix
            End With

        '財務適用テーブル
        Case TABLE_ZAIMU
            Set objEditWindow = New mntZaimu.Zaimu
            objEditWindow.ZaimuCd = strSetKey

        '財務連携情報テーブル
        Case TABLE_ZAIMUINFO
            Set objEditWindow = New mntZaimuInfo.ZaimuInfo
'            objEditWindow.ZaimuCd = strSetKey

        '請求書分類テーブル
        Case TABLE_BILLCLASS
            Set objEditWindow = New mntBillClass.BillClass
            objEditWindow.BillClassCd = strSetKey

        '請求明細分類テーブル
        Case TABLE_DMDLINECLASS
            Set objEditWindow = New mntDmdLineClass.DmdLineClass
            objEditWindow.DmdLineClassCd = strSetKey

        'まるめ分類テーブル
        Case TABLE_ROUNDCLASS
            Set objEditWindow = New mntRoundClass.RoundClass
            objEditWindow.RoundClassCd = strSetKey

'### 2004/1/15 Added by Ishihara@FSIT セット外請求明細追加
        'セット外請求明細分類テーブル
        Case TABLE_OTHERLINEDIV
            Set objEditWindow = New mntOtherLineDiv.OtherLineDiv
            objEditWindow.OtherLineDivCd = strSetKey
'### 2004/1/15 Added End

'## 2004.05.28 ADD STR ORB)T.YAGUCHI ２次請求明細
        '２次請求明細テーブル
        Case TABLE_SECONDLINEDIV
            Set objEditWindow = New mntSecondLineDiv.SecondLineDiv
            objEditWindow.SecondLineDivCd = strSetKey
'### 2004/1/15 Added End

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        '予約メール送信設定（基本設定）
        Case TABLE_MAILCONF
            Set objEditWindow = New mntMailConf.MailConf
        
        'メールテンプレートテーブル
        Case TABLE_MAILTEMPLATE
            Set objEditWindow = New mntMailTemplate.MailTemplate
            objEditWindow.TemplateCd = strSetKey
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####
        
        '続柄テーブル
        Case TABLE_RELATION
            Set objEditWindow = New mntRelation.Relation
            objEditWindow.RelationCd = strSetKey

        'コメント情報分類テーブル
        Case TABLE_PUBNOTEDIV
            Set objEditWindow = New mntPubNoteDiv.PubNotediv
            objEditWindow.PubNoteDivCd = strSetKey

        '都道府県テーブル
        Case TABLE_PREF
            Set objEditWindow = New mntPref.Pref
            objEditWindow.PrefCd = strSetKey

        '文章分類テーブル
        Case TABLE_STCCLASS
            Set objEditWindow = New mntStcClass.StcClass
            objEditWindow.StcClassCd = strSetKey

        '帳票管理
        Case TABLE_REPORT
            Set objEditWindow = New mntReport.Report
            objEditWindow.ReportCd = strSetKey

        'システム環境設定
        Case TABLE_SYSPROSUB
            Set objEditWindow = New mntSysPro.SysPro
            objEditWindow.TargetSysPro = strSetKey

        '汎用テーブル
        Case TABLE_FREE
            Set objEditWindow = New mntSysPro.SysPro
            objEditWindow.TargetSysPro = TARGETSYSPRO_FREE
            objEditWindow.FreeCd = strSetKey

        '端末管理テーブル
        Case TABLE_WORKSTATION
            Set objEditWindow = New mntWorkStation.WorkStation
            objEditWindow.IpAddress = strSetKey

        'ユーザテーブル
        Case TABLE_HAINSUSER
            Set objEditWindow = New mntHainsUser.HainsUser
            objEditWindow.UserID = strSetKey

        '基準値の再設定
        Case TABLE_UPDSTDVALUE
            frmUpdStdValue.Show vbModal
            Exit Function

        '検索結果
        Case NODE_SEARCH
            Call CntlViewMode(False)
            Exit Function

'### 2005.03.25  Add by 李
        Case NODE_SECURITY_MENUGRP, NODE_SECURITY_USERGRP, NODE_SECURITY_PWD
            Set objEditWindow = New mntSysPro.SysPro
            objEditWindow.TargetSysPro = TARGETSYSPRO_FREE
            objEditWindow.FreeCd = strSetKey
            
'### 2005.03.25  Add by End ...


        Case Else

            '依頼項目テーブル
            If Mid(vntNodeKey, 1, Len(TABLE_ITEM_P)) = TABLE_ITEM_P Then
                Set objEditWindow = New mntItem_P.Item_P
                With objEditWindow
                    .ItemCd = strSetKey
                End With
            End If

            '検査項目テーブル
            If Mid(vntNodeKey, 1, Len(TABLE_ITEM_C)) = TABLE_ITEM_C Then
                Set objEditWindow = New mntItem_c.Item_c

                '検査項目コードとサフィックスを抜く
                Call SplitItemAndSuffix(strSetKey, strItemCd, strSuffix)
                With objEditWindow
                    .ItemCd = strItemCd
                    .Suffix = strSuffix
                End With
            End If

            '計算テーブル
            If Mid(vntNodeKey, 1, Len(TABLE_CALC)) = TABLE_CALC Then
                Set objEditWindow = New mntCalc.Calc

                If Trim(strSetKey) <> "" Then
                    '更新時は検査項目コードとサフィックスを抜く
                    Call SplitItemAndSuffix(lsvView.ListItems(vntItemKey).Text, strItemCd, strSuffix)
                Else
                    '新規作成時は検査項目ガイドを表示
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

            '基準値テーブル
            If Mid(vntNodeKey, 1, Len(TABLE_STDVALUE)) = TABLE_STDVALUE Then
                Set objEditWindow = New mntStdValue.StdValue

                If Trim(strSetKey) <> "" Then
                    '更新時は検査項目コードとサフィックスを抜く
                    Call SplitItemAndSuffix(lsvView.ListItems(vntItemKey).Text, strItemCd, strSuffix)
                Else
                    '新規作成時は検査項目ガイドを表示
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

'### 2008.02.10 Add by 張 特定健診基準値追加 ###############################
            '特定健診用基準値テーブル
            If Mid(vntNodeKey, 1, Len(TABLE_SP_STDVALUE)) = TABLE_SP_STDVALUE Then
                Set objEditWindow = New mntSpStdValue.SpStdValue

                If Trim(strSetKey) <> "" Then
                    '更新時は検査項目コードとサフィックスを抜く
                    Call SplitItemAndSuffix(lsvView.ListItems(vntItemKey).Text, strItemCd, strSuffix)
                Else
                    '新規作成時は検査項目ガイドを表示
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

            '文章テーブル
            If (Mid(vntNodeKey, 1, Len(TABLE_SENTENCE_REC)) = TABLE_SENTENCE_REC) Or _
               (Mid(vntNodeKey, 1, Len(TABLE_SENTENCE_ITEM)) = TABLE_SENTENCE_ITEM) Then

                strItemCd = ""
                strItemName = ""
                strItemType = 0
                strStcCd = ""
                strSuffix = ""

                If strSetKey <> "" Then
                    '検査項目コードと項目タイプを抜く
                    Call SplitItemAndSuffix(strSetKey, strItemCd, strItemType)

                    '文章レコードの場合、さらにキーを分割
                    If (Mid(vntNodeKey, 1, Len(TABLE_SENTENCE_REC)) = TABLE_SENTENCE_REC) Then
                        '項目タイプと文章コードを抜く（開始位置は検査項目コード長＋項目タイプ）
                        Call SplitItemAndSuffix(Mid(strSetKey, Len(strItemCd) + 2, Len(strSetKey) - Len(strItemCd) + 2), _
                                                strItemType, _
                                                strStcCd)
                        '表示用に検査項目名称を抜く
                        strItemName = lsvView.ListItems(vntItemKey).SubItems(1)
                    Else
                        'サフィックスセット
                        strSuffix = strItemType
                        strItemType = 0
                        '表示用に検査項目名称を抜く
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

            '定型所見テーブル
            If Mid(vntNodeKey, 1, Len(TABLE_STDJUD)) = TABLE_STDJUD Then
                'ノードの取得
                Set colNodes = trvMaster.Nodes
                Set objEditWindow = New mntStdJud.StdJud

                '検査項目コードとサフィックスを抜く
                Call SplitItemAndSuffix(strSetKey, strSplitKey1, strSplitKey2)

                With objEditWindow
                    If Trim(strSetKey) <> "" Then
                        .JudClassCd = strSplitKey1
                    Else
                        If trvMaster.Visible = True Then
                            'フォルダモードなら判定分類コードセット
                            .JudClassCd = CInt(Mid(vntNodeKey, Len(TABLE_STDJUD) + 1, Len(vntNodeKey)))
                        End If
                    End If

'                    .JudClassName = colNodes.Item(vntNodeKey).Text
'                    .StdJudCd = strSetKey
                    .StdJudCd = strSplitKey2
                End With
            End If


            '指導内容テーブル
            If Mid(vntNodeKey, 1, Len(TABLE_GUIDANCE)) = TABLE_GUIDANCE Then
                Set objEditWindow = New mntGuidance.Guidance
                With objEditWindow
                    .GuidanceCd = strSetKey
                    If trvMaster.Visible = True Then
                        'フォルダモードの場合、判定分類コードをセットする
                        .JudClassCd = Mid(vntNodeKey, Len(TABLE_GUIDANCE) + 1, Len(vntNodeKey))
                    End If
                End With
            End If

'            Case TABLE_GUIDANCE
'                Set objEditWindow = New mntGuidance.Guidance
'                objEditWindow.GuidanceCd = strSetKey

            '判定コメントテーブル
            If Mid(vntNodeKey, 1, Len(TABLE_JUDCMTSTC)) = TABLE_JUDCMTSTC Then
                Set objEditWindow = New mntJudCmtStc.JudCmtStc
                With objEditWindow
                    .JudCmtCd = strSetKey
                    If trvMaster.Visible = True Then
                        'フォルダモードの場合、判定分類コードをセットする
                        .JudClassCd = Mid(vntNodeKey, Len(TABLE_JUDCMTSTC) + 1, Len(vntNodeKey))
                    End If
                End With
            End If
    
    
'### 2005.3.23  Add by 李
            If Mid(vntNodeKey, 1, Len(TABLE_SECURITYGRP)) = TABLE_SECURITYGRP Then
                Set objEditWindow = New mntSecurityPgmGrp.SecurityPgm
                
                If strSetKey <> "" Then         '開く
                    objEditWindow.SetMode = 0
                    objEditWindow.SetUserGrpCd = trvMaster.Nodes.Item(trvMaster.SelectedItem.Index).Key
                    objEditWindow.SetUserGrpName = trvMaster.Nodes.Item(trvMaster.SelectedItem.Index).Text
                    objEditWindow.SetSecurityGrpCd = strSetKey
                    objEditWindow.SetSecurityGrpName = lsvView.SelectedItem.ListSubItems.Item(2).Text
                Else                            '新規
                    objEditWindow.SetMode = 1
                End If
            End If
            
            If Mid(vntNodeKey, 1, Len(TABLE_MENUPGM)) = TABLE_MENUPGM Then
                Set objEditWindow = New mntPgmInfo.PgmInfo

                If strSetKey <> "" Then         '開く
'                    objEditWindow.PgmInfoCd = trvMaster.Nodes.Item(trvMaster.SelectedItem.Index).Key
                    objEditWindow.PgmInfoCd = strSetKey
                Else                            '新規

                End If
            End If
            
            
'### 2005.3.23  Add End ...

    
    End Select
    
    'テーブルメンテナンス画面を開く
    objEditWindow.Show vbModal
    
    '更新状態を戻り値に返す
    ShowEditWindow = objEditWindow.Updated
    
    'オブジェクトの廃棄（トランザクションがCommitされない）
    Set objEditWindow = Nothing
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Number & ":" & Err.Description, vbCritical, Err.Source
    Set objEditWindow = Nothing
    
End Function

'
' 機能　　 : テーブルレコードを削除する
'
' 引数　　 : (In)   strNodeKey  (リストアイテムの)ノードキー
' 　　　　 : (In)   strItemKey  (リストアイテムの)アイテムキー
'
' 戻り値　 :
'
' 備考　　 : いちいちマスタ毎にプロシージャ追加するのは嫌なので、レイトバインドで対応
'
Private Function DeleteRecord(ByVal strNodeKey As String, ByVal strItemKey As String) As Boolean

On Error GoTo ErrorHandle

    Dim objTargetMaster As Object                   'テーブルアクセス用
    Dim vntKey          As Variant                  'レコードキー
    Dim strItemCd       As String                   'スプリット用キー
    Dim strSuffix       As String                   'スプリット用キー
    Dim strItemType     As String                   'スプリット用キー
    Dim strStcCd        As String                   'スプリット用キー
    
    Dim strSplitKey1    As String                   'スプリット用キー
    Dim strSplitKey2    As String                   'スプリット用キー
    
    DeleteRecord = False
    
    'キー値の取得
    If Not IsMissing(strItemKey) Then
        vntKey = SplitKey(KEY_PREFIX, strItemKey)
    End If
    
    'キー情報が存在しない場合は何もしない
    If IsEmpty(strItemKey) Then
        Exit Function
    End If
    
    Select Case strNodeKey
        
        '検査分類テーブル
        Case TABLE_ITEMCLASS
            Set objTargetMaster = CreateObject("HainsItem.Item")
            objTargetMaster.DeleteItemClass vntKey(0)
        
        '進捗管理用分類テーブル
        Case TABLE_PROGRESS
            Set objTargetMaster = CreateObject("HainsProgress.Progress")
            objTargetMaster.DeleteProgress vntKey(0)
        
        '検査実施日分類テーブル
        Case TABLE_OPECLASS
            Set objTargetMaster = CreateObject("HainsOpeClass.OpeClass")
            objTargetMaster.DeleteOpeClass vntKey(0)
        
        'コーステーブル
        Case TABLE_COURSE
            Set objTargetMaster = CreateObject("HainsCourse.Course")
            objTargetMaster.DeleteCourse_p vntKey(0)
        
        'セット分類テーブル
        Case TABLE_SETCLASS
            Set objTargetMaster = CreateObject("HainsSetClass.SetClass")
            objTargetMaster.DeleteSetClass vntKey(0)
        
        '予約枠テーブル
        Case TABLE_RSVFRA
            Set objTargetMaster = CreateObject("HainsSchedule.Schedule")
            objTargetMaster.DeleteRsvFra vntKey(0)
    
        '予約群テーブル
        Case TABLE_RSVGRP
            Set objTargetMaster = CreateObject("HainsSchedule.Schedule")
            objTargetMaster.DeleteRsvGrp vntKey(0)

        'コース受診予約群
        Case TABLE_COURSE_RSVGRP
            Set objTargetMaster = CreateObject("HainsSchedule.Schedule")
                
            'キー値を分割
            Call SplitItemAndSuffix(CStr(vntKey(0)), strSplitKey1, strSplitKey2)
            objTargetMaster.DeleteCourseRsvGrp strSplitKey1, strSplitKey2
    
        'グループテーブル
        Case TABLE_GRP_R, TABLE_GRP_I
'### 2003.03.13 Added by Ishihara@FSIT システム使用グループは簡単に消せないようにする。
            'システム使用グループの場合、削除できないようにする。
            If lsvView.SelectedItem.ListSubItems(3) <> "" Then
                MsgBox "削除指定されたグループは「システム使用グループ」として設定されています。" & vbLf & _
                       "帳票出力時など、システム内部で使用されている可能性があるため削除できません。" & vbLf & vbLf & _
                       "※削除可能な確認がとれているのであれば、グループメンテナンス画面の" & vbLf & _
                       "「このグループは通常業務画面に表示しない」チェックボックスをはずすことにより" & vbLf & _
                       "削除することは可能です。", vbCritical
                Exit Function
            End If
'### 2003.03.13 Added End
            
            Set objTargetMaster = CreateObject("HainsGrp.Grp")
            objTargetMaster.DeleteGrp_p vntKey(0)
            
'****FJTH)2004/10/4M,E 団体グループ対応 -S ********************************************************************
         Case TABLE_ORGGRP
         
            'システム使用グループの場合、削除できないようにする。
            If lsvView.SelectedItem.ListSubItems(2) <> "" Then
                MsgBox "削除指定されたグループは「システム使用グループ」として設定されています。" & vbLf & _
                       "帳票出力時など、システム内部で使用されている可能性があるため削除できません。" & vbLf & vbLf & _
                       "※削除可能な確認がとれているのであれば、グループメンテナンス画面の" & vbLf & _
                       "「このグループは通常業務画面に表示しない」チェックボックスをはずすことにより" & vbLf & _
                       "削除することは可能です。", vbCritical
                Exit Function
            End If
            
            Set objTargetMaster = CreateObject("HainsOrgGrp.Grp")
            objTargetMaster.DeleteGrp_p vntKey(0)
'****FJTH)2004/10/4M,E 団体グループ対応 -E ********************************************************************
       
       
        '結果コメントテーブル
        Case TABLE_RSLCMT
            Set objTargetMaster = CreateObject("HainsRslCmt.RslCmt")
            objTargetMaster.DeleteRslCmt vntKey(0)
        
        '判定分類テーブル
        Case TABLE_JUDCLASS
            Set objTargetMaster = CreateObject("HainsJudClass.JudClass")
            objTargetMaster.DeleteJudClass vntKey(0)
        
        '判定テーブル
        Case TABLE_JUD
            Set objTargetMaster = CreateObject("HainsJud.Jud")
            objTargetMaster.DeleteJud vntKey(0)
        
        '栄養計算目標量テーブル
        Case TABLE_NUTRITARGET
            Set objTargetMaster = CreateObject("HainsNourishment.Nourishment")
 '           objTargetMaster.DeleteNutriFoodEnergy vntKey(0)
    
        '食品群別摂取テーブル
        Case TABLE_NUTRIFOODENERGY
            Set objTargetMaster = CreateObject("HainsNourishment.Nourishment")
            objTargetMaster.DeleteNutriFoodEnergy vntKey(0)
        
        '構成食品テーブル
        Case TABLE_NUTRICOMPFOOD
            Set objTargetMaster = CreateObject("HainsNourishment.Nourishment")
            objTargetMaster.DeleteNutriCompFood vntKey(0)
        
        '栄養献立リストテーブル
        Case TABLE_NUTRIMENULIST
            Set objTargetMaster = CreateObject("HainsNourishment.Nourishment")
'            objTargetMaster.DeleteNutriFoodEnergy vntKey(0)
        
        '病類テーブル
        Case TABLE_DISDIV
            Set objTargetMaster = CreateObject("HainsDisease.Disease")
            objTargetMaster.DeleteDisDiv vntKey(0)
        
        '病名テーブル
        Case TABLE_DISEASE
            Set objTargetMaster = CreateObject("HainsDisease.Disease")
            objTargetMaster.DeleteDisease vntKey(0)
        
        '財務適用テーブル
        Case TABLE_ZAIMU
            Set objTargetMaster = CreateObject("HainsZaimu.Zaimu")
            objTargetMaster.DeleteZaimu vntKey(0)
        
        '請求書分類テーブル
        Case TABLE_BILLCLASS
            Set objTargetMaster = CreateObject("HainsDmdClass.DmdClass")
            objTargetMaster.DeleteBillClass vntKey(0)
        
        '請求明細分類テーブル
        Case TABLE_DMDLINECLASS
            Set objTargetMaster = CreateObject("HainsDmdClass.DmdClass")
            objTargetMaster.DeleteDmdLineClass vntKey(0)
        
'### 2004/1/15 Added by Ishihara@FSIT セット外請求明細追加
        'セット外請求明細テーブル
        Case TABLE_OTHERLINEDIV
            Set objTargetMaster = CreateObject("HainsPerBill.PerBill")
            objTargetMaster.DeleteOtherLineDiv vntKey(0)
'### 2004/1/15 Added End

'## 2004.05.28 ADD STR ORB)T.YAGUCHI ２次請求明細
        '２次請求明細テーブル
        Case TABLE_SECONDLINEDIV
            Set objTargetMaster = CreateObject("HainsSecondBill.SecondBill")
            objTargetMaster.DeleteSecondLineDiv vntKey(0)
'### 2004/1/15 Added End

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
        'メールテンプレートテーブル
        Case TABLE_MAILTEMPLATE
            Set objTargetMaster = CreateObject("HainsMail.Template")
            objTargetMaster.DeleteMailTemplate vntKey(0)
'#### 2013.3.4 SL-SN-Y0101-612 ADD END   ####

        'まるめ分類テーブル
        Case TABLE_ROUNDCLASS
            Set objTargetMaster = CreateObject("HainsRoundClass.RoundClass")
            objTargetMaster.DeleteRoundClass vntKey(0)
        
        '都道府県テーブル
        Case TABLE_PREF
            Set objTargetMaster = CreateObject("HainsPref.Pref")
            objTargetMaster.DeletePref vntKey(0)
        
        'WEBコース設定
        Case TABLE_WEB_CS
            Set objTargetMaster = CreateObject("HainsWeb_Cs.Web_Cs")
            objTargetMaster.DeleteWeb_Cs vntKey(0)
        
        '帳票管理
        Case TABLE_REPORT
            Set objTargetMaster = CreateObject("HainsReport.Report")
            objTargetMaster.DeleteReport vntKey(0)
        
        '続柄
        Case TABLE_RELATION
            Set objTargetMaster = CreateObject("HainsPerson.Person")
            objTargetMaster.DeleteRelation vntKey(0)
        
        'コメント分類
        Case TABLE_PUBNOTEDIV
            Set objTargetMaster = CreateObject("HainsPubNote.PubNote")
            objTargetMaster.DeletePubNoteDiv vntKey(0)
    
        '汎用テーブル
        Case TABLE_FREE
            Set objTargetMaster = CreateObject("HainsFree.Free")
            objTargetMaster.DeleteFree vntKey(0)
    
        '端末管理テーブル
        Case TABLE_WORKSTATION
            Set objTargetMaster = CreateObject("HainsWorkStation.WorkStation")
            objTargetMaster.DeleteWorkStation vntKey(0)
    
        'ユーザテーブル
        Case TABLE_HAINSUSER
            Set objTargetMaster = CreateObject("HainsHainsUser.HainsUser")
            objTargetMaster.DeleteHainsUser vntKey(0)
    
        '文章分類テーブル
        Case TABLE_STCCLASS
            Set objTargetMaster = CreateObject("HainsSentence.Sentence")
            objTargetMaster.DeleteStcClass vntKey(0)
    
        '定型面接文章テーブル
        Case TABLE_STDCONTACTSTC
            
            '指導内容区分と定型面接文章コードを抜く（引数名としてはItemcd,Suffixではないが、変数領域節約と）
            Call SplitItemAndSuffix(CStr(vntKey(0)), strItemCd, strSuffix)
            
            Set objTargetMaster = CreateObject("HainsStdContactStc.StdContactStc")
            objTargetMaster.DeleteStdContactStc strItemCd, strSuffix
    
        Case Else

            '依頼項目テーブル
            If Mid(strNodeKey, 1, Len(TABLE_ITEM_P)) = TABLE_ITEM_P Then
                Set objTargetMaster = CreateObject("HainsItem.Item")
                objTargetMaster.DeleteItem_p vntKey(0)
            End If
            
            '検査項目テーブル
            If Mid(strNodeKey, 1, Len(TABLE_ITEM_C)) = TABLE_ITEM_C Then
                
                '検査項目コードとサフィックスを抜く
                Call SplitItemAndSuffix(CStr(vntKey(0)), strItemCd, strSuffix)
                
                Set objTargetMaster = CreateObject("HainsItem.Item")
                objTargetMaster.DeleteItem_c strItemCd, strSuffix
            
            End If
            
            '計算テーブル
            If Mid(strNodeKey, 1, Len(TABLE_CALC)) = TABLE_CALC Then
                
                '検査項目コードとサフィックスを抜く
                Call SplitItemAndSuffix(CStr(vntKey(0)), strItemCd, strSuffix)
                
                Set objTargetMaster = CreateObject("HainsCalc.Calc")
                objTargetMaster.DeleteCalc strItemCd, strSuffix
            
            End If
            
            '基準値テーブル
            If Mid(strNodeKey, 1, Len(TABLE_STDVALUE)) = TABLE_STDVALUE Then
                Set objTargetMaster = CreateObject("HainsStdValue.StdValue")
                objTargetMaster.DeleteStdValue vntKey(0)
            End If
            
'### 2008.02.10 Add by 張 特定健診基準値追加 ###############################
            
            '特定健診用基準値テーブル
            If Mid(strNodeKey, 1, Len(TABLE_SP_STDVALUE)) = TABLE_SP_STDVALUE Then
                Set objTargetMaster = CreateObject("HainsSpStdValue.SpStdValue")
                objTargetMaster.DeleteSpStdValue vntKey(0)
            End If
            
'### 2008.02.10 Add End ###################################################
            
            '文章テーブル（文章レコード）
            If (Mid(strNodeKey, 1, Len(TABLE_SENTENCE_REC)) = TABLE_SENTENCE_REC) Then
                
                strItemCd = ""
                strItemType = 0
                strStcCd = ""
                
                '検査項目コードと項目タイプを抜く
                Call SplitItemAndSuffix(CStr(vntKey(0)), strItemCd, strItemType)
                
                '項目タイプと文章コードを抜く（開始位置は検査項目コード長＋項目タイプ）
                Call SplitItemAndSuffix(Mid(vntKey(0), Len(strItemCd) + 2, Len(vntKey(0)) - Len(strItemCd) + 2), _
                                        strItemType, _
                                        strStcCd)
                
                Set objTargetMaster = CreateObject("HainsSentence.Sentence")
                objTargetMaster.DeleteSentence strItemCd, CInt(strItemType), strStcCd
            
            End If
            
            '定型所見テーブル
            If Mid(strNodeKey, 1, Len(TABLE_STDJUD)) = TABLE_STDJUD Then
                
                'キー値を分割
                Call SplitItemAndSuffix(CStr(vntKey(0)), strSplitKey1, strSplitKey2)
                Set objTargetMaster = CreateObject("HainsStdJud.StdJud")
                objTargetMaster.DeleteStdJud strSplitKey1, strSplitKey2
            End If
            
            '判定コメントテーブル
            If Mid(strNodeKey, 1, Len(TABLE_JUDCMTSTC)) = TABLE_JUDCMTSTC Then
                Set objTargetMaster = CreateObject("HainsJudCmtStc.JudCmtStc")
                objTargetMaster.DeleteJudCmtStc vntKey(0)
            End If
    
            '指導文章テーブル
            If Mid(strNodeKey, 1, Len(TABLE_GUIDANCE)) = TABLE_GUIDANCE Then
                Set objTargetMaster = CreateObject("HainsGuidance.Guidance")
                objTargetMaster.DeleteGuidance vntKey(0)
            End If
    
    End Select
    
    'オブジェクト廃棄（Commit?)
    Set objTargetMaster = Nothing
    
    DeleteRecord = True
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Mentenance.DeleteRecord"
    MsgBox EditAdditionalMessage(Err.Description), vbCritical
    Set objTargetMaster = Nothing
    
End Function

'
' 機能　　 : リスト編集
'
' 引数　　 : (In)      strNodeKey  ツリービューのノードキー
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListView(strNodeKey As String, Optional strItemKey As String)

    Dim colNodes    As Nodes    'ノードコレクション
    Dim objNode     As Node     'ノードオブジェクト
    Dim objListItem As ListItem 'リストアイテムオブジェクト
    
    'リストアイテムクリア
    lsvView.ListItems.Clear
    lsvView.View = lvwList
    
    '件数表示領域クリア
    stbMain.Panels.Item(1).Text = ""
    
    'ノードコレクションの取得
    Set colNodes = trvMaster.Nodes
    
    '指定ノードが子を持たない場合、各コンテンツ毎の編集
    If colNodes(strNodeKey).Children = 0 Then
        
        'リストビューを編集
        Call EditListViewFromContents(strNodeKey)
        
        'アイテムキーがセットされている場合、その項目を選択状態にする
        If strItemKey <> "" Then
            '検査分類が変更された場合などは、ものがなくなることもあるのでRESUME NEXT
            On Error Resume Next
            lsvView.ListItems(strItemKey).Selected = True
            lsvView.SelectedItem.EnsureVisible
            On Error GoTo 0
        End If
        
        Exit Sub
    End If
    
    '指定ノードを親にもつノードの内容を編集
    For Each objNode In colNodes
        
        Do
            '親ノードがなければ何もしない
            If objNode.Parent Is Nothing Then
                Exit Do
            End If
        
            '親ノードが指定ノードと一致しない場合は何もしない
            If objNode.Parent.Key <> strNodeKey Then
                Exit Do
            End If
       
            'リストアイテムの編集
            Set objListItem = lsvView.ListItems.Add
            With objListItem
                .Text = objNode.Text
                .Key = objNode.Key
                .SmallIcon = ICON_CLOSED
                .Tag = NODE_TYPEFOLDER        'データとしてのリストアイテムと区別する
            End With
            
            Exit Do
        Loop
    
    Next

End Sub

'
' 機能　　 : 定型面接文章一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromStdContactStc(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objStdContactStc    As Object           '都道府県アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntGuidanceDiv      As Variant          '指導内容区分
    Dim vntStdContactStcCd  As Variant          '定型面接文章コード
    Dim vntContactStc       As Variant          '面接文章
    Dim i                   As Long             'インデックス
    Dim strUniqueKey        As String
    Dim strGuidanceDivName  As String
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objStdContactStc = CreateObject("HainsStdContactStc.StdContactStc")
    lngCount = objStdContactStc.SelectStdContactStcList(vntGuidanceDiv, _
                                                        vntStdContactStcCd, _
                                                        vntContactStc)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "指導内容区分", 1800, lvwColumnLeft
    objHeader.Add , , "定型面接文章コード", 1800, lvwColumnLeft
    objHeader.Add , , "面接文章", 4000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        strUniqueKey = KEY_PREFIX & vntGuidanceDiv(i) & KEY_SEPARATE & vntStdContactStcCd(i)
        
        Select Case vntGuidanceDiv(i)
            Case "1"
                strGuidanceDivName = "所見の説明"
            Case "2"
                strGuidanceDivName = "生活・食事指導"
            Case "3"
                strGuidanceDivName = "経過追跡"
            Case "4"
                strGuidanceDivName = "要精密検査"
            Case "5"
                strGuidanceDivName = "要治療"
            Case "6"
                strGuidanceDivName = "受診のすすめ"
            Case "7"
                strGuidanceDivName = "運動指導"
            Case "8"
                strGuidanceDivName = "心理相談"
            Case Else
                strGuidanceDivName = "？（" & vntGuidanceDiv(i) & "）"
        End Select
        
        Set objItem = lsvView.ListItems.Add(, strUniqueKey, strGuidanceDivName, , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntStdContactStcCd(i)
        objItem.SubItems(2) = vntContactStc(i)
    Next i
    
    'オブジェクト廃棄
    Set objStdContactStc = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objStdContactStc = Nothing
    
End Sub

'
' 機能　　 : 請求明細分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromDmdLineClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objDmdLineClass         As Object           '請求明細分類アクセス用
    Dim objHeader               As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem                 As ListItem         'リストアイテムオブジェクト
    Dim vntDmdLineClassCd       As Variant          '請求明細分類コード
    Dim vntDmdLineClassName     As Variant          '請求明細分類
    Dim vntSumDetails           As Variant          '健診基本料集計フラグ
    Dim vntIsrFlg               As Variant          '健保使用フラグ
'    Dim vntMakeBillLine         As Variant          '請求書明細作成フラグ
    Dim i                       As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objDmdLineClass = CreateObject("HainsDmdClass.DmdClass")
    lngCount = objDmdLineClass.SelectDmdLineClassItemList(vntDmdLineClassCd, vntDmdLineClassName, vntSumDetails, vntIsrFlg)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "明細分類コード", 1500, lvwColumnLeft
    objHeader.Add , , "請求明細分類名", 3000, lvwColumnLeft
    objHeader.Add , , "健診基本料", 1200, lvwColumnLeft
    objHeader.Add , , "当分類使用対象", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntDmdLineClassCd(i), vntDmdLineClassCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntDmdLineClassName(i)
        objItem.SubItems(2) = IIf(vntSumDetails(i) = "1", "まとめる", "")
        Select Case vntIsrFlg(i)
            Case ""
                objItem.SubItems(3) = "健保、団体両方で使用"
            Case "0"
                objItem.SubItems(3) = "一般団体のみ"
            Case "1"
                objItem.SubItems(3) = "健保のみ"
        End Select
        
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objDmdLineClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objDmdLineClass = Nothing
    
End Sub
'### 2004/1/15 Added by Ishihara@FSIT セット外請求明細追加
'
' 機能　　 : セット外請求明細一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromOtherLineDiv(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objOtherLineDiv         As Object           'セット外請求明細アクセス用
    Dim objHeader               As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem                 As ListItem         'リストアイテムオブジェクト
    Dim vntOtherLineDivCd       As Variant          'セット外請求明細コード
    Dim vntOtherLineDivName     As Variant          'セット外請求明細
    Dim vntStdPrice             As Variant          '標準単価
    Dim vntStdTax               As Variant          '標準税額
    Dim i                       As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objOtherLineDiv = CreateObject("HainsPerBill.PerBill")
    lngCount = objOtherLineDiv.SelectOtherLineDiv(vntOtherLineDivCd, vntOtherLineDivName, vntStdPrice, vntStdTax)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "セット外請求明細コード", 1500, lvwColumnLeft
    objHeader.Add , , "セット外請求明細名", 3000, lvwColumnLeft
    objHeader.Add , , "標準単価", 1200, lvwColumnLeft
    objHeader.Add , , "標準税額", 1200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntOtherLineDivCd(i), vntOtherLineDivCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntOtherLineDivName(i)
        objItem.SubItems(2) = vntStdPrice(i)
        objItem.SubItems(3) = vntStdTax(i)
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objOtherLineDiv = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objOtherLineDiv = Nothing
    
End Sub

'## 2004.05.28 ADD STR ORB)T.YAGUCHI ２次請求明細
'
' 機能　　 : ２次請求明細一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromSecondLineDiv(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objSecondLineDiv         As Object           'セット外請求明細アクセス用
    Dim objHeader               As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem                 As ListItem         'リストアイテムオブジェクト
    Dim vntSecondLineDivCd       As Variant          'セット外請求明細コード
    Dim vntSecondLineDivName     As Variant          'セット外請求明細
    Dim vntStdPrice             As Variant          '標準単価
    Dim vntStdTax               As Variant          '標準税額
    Dim i                       As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objSecondLineDiv = CreateObject("HainsSecondBill.SecondBill")
    lngCount = objSecondLineDiv.SelectSecondLineDiv(vntSecondLineDivCd, vntSecondLineDivName, vntStdPrice, vntStdTax)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "２次請求明細コード", 1500, lvwColumnLeft
    objHeader.Add , , "２次請求明細名", 3000, lvwColumnLeft
    objHeader.Add , , "標準単価", 1200, lvwColumnLeft
    objHeader.Add , , "標準税額", 1200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntSecondLineDivCd(i), vntSecondLineDivCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntSecondLineDivName(i)
        objItem.SubItems(2) = vntStdPrice(i)
        objItem.SubItems(3) = vntStdTax(i)
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objSecondLineDiv = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSecondLineDiv = Nothing
    
End Sub


'
' 機能　　 : 請求書分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromBillClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objBillClass            As Object           '請求書分類アクセス用
    Dim objHeader               As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem                 As ListItem         'リストアイテムオブジェクト
    Dim vntBillClassCd          As Variant          '請求書分類コード
    Dim vntBillClassName        As Variant          '請求書分類
    Dim vntDefCheck             As Variant          'デフォルトチェック
    Dim vntOtherIncome          As Variant          '雑収入扱い
    Dim vntCrfFileName          As Variant          '出力ファイル名
    Dim i                       As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objBillClass = CreateObject("HainsDmdClass.DmdClass")
    lngCount = objBillClass.SelectBillClassList(vntBillClassCd, vntBillClassName, vntDefCheck, vntOtherIncome, vntCrfFileName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "請求書分類コード", 1500, lvwColumnLeft
    objHeader.Add , , "請求書分類名", 3000, lvwColumnLeft
    objHeader.Add , , "雑収入", 800, lvwColumnLeft
    objHeader.Add , , "団体登録時", 1200, lvwColumnLeft
    objHeader.Add , , "出力ファイル名", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntBillClassCd(i), vntBillClassCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntBillClassName(i)
        objItem.SubItems(2) = IIf(vntOtherIncome(i) = "1", "雑収入", "")
        objItem.SubItems(3) = IIf(vntDefCheck(i) = "1", "デフォルト", "")
        objItem.SubItems(4) = vntCrfFileName(i)
        
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objBillClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objBillClass = Nothing
    
End Sub

'
' 機能　　 : コメント情報分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromPubNoteDiv(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objPubNoteDiv           As Object           'コメント分類アクセス用
    Dim objHeader               As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem                 As ListItem         'リストアイテムオブジェクト
    Dim vntPubNoteDivCd         As Variant          'コメント分類コード
    Dim vntPubNoteDivName       As Variant          'コメント分類
    Dim vntDefaultDispKbn       As Variant          '表示対象区分初期値
    Dim vntOnlyDispKbn          As Variant          '表示対象区分しばり
    Dim i                       As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objPubNoteDiv = CreateObject("HainsPubNote.PubNote")
'### 2004/1/15 Updated by Ishihara@FSIT メソッドが変わってしまった...
'    lngCount = objPubNoteDiv.SelectPubNoteDivList(3, vntPubNoteDivCd, vntPubNoteDivName, vntDefaultDispKbn, vntOnlyDispKbn)
    lngCount = objPubNoteDiv.SelectAllPubNoteDivList(vntPubNoteDivCd, vntPubNoteDivName, vntDefaultDispKbn, vntOnlyDispKbn)
'### 2004/1/15 Updated End
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "分類コード", 1000, lvwColumnLeft
    objHeader.Add , , "分類名", 2500, lvwColumnLeft
    objHeader.Add , , "初期値", 1200, lvwColumnLeft
    objHeader.Add , , "表示制限", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntPubNoteDivCd(i), vntPubNoteDivCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntPubNoteDivName(i)
        Select Case vntDefaultDispKbn(i)
            Case "1"
                objItem.SubItems(2) = "医療コメント"
            Case "2"
                objItem.SubItems(2) = "事務コメント"
            Case "3"
                objItem.SubItems(2) = "共通"
            Case Else
                objItem.SubItems(2) = "?=" & vntDefaultDispKbn(i)
        End Select
        
        Select Case vntOnlyDispKbn(i)
            Case ""
                objItem.SubItems(3) = ""
            Case "1"
                objItem.SubItems(3) = "医療専用コメント"
            Case "2"
                objItem.SubItems(3) = "事務専用コメント"
            Case Else
                objItem.SubItems(3) = "?=" & vntOnlyDispKbn(i)
        End Select
        
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objPubNoteDiv = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPubNoteDiv = Nothing
    
End Sub

'
' 機能　　 : 病名一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromDisease(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objDisease      As Object           '病名アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntDisCd        As Variant          '病名コード
    Dim vntDisName      As Variant          '病名
    Dim vntDisDivName   As Variant          '病類
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objDisease = CreateObject("HainsDisease.Disease")
    lngCount = objDisease.SelectDiseaseItemList(vntDisCd, vntDisName, vntDisDivName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "病名コード", 1200, lvwColumnLeft
    objHeader.Add , , "病名", 3000, lvwColumnLeft
    objHeader.Add , , "病類", 3000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntDisCd(i), vntDisCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntDisName(i)
        objItem.SubItems(2) = vntDisDivName(i)
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objDisease = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objDisease = Nothing
    
End Sub

'
' 機能　　 : 病類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromDisDiv(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objDisDiv       As Object           '病類アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntDisDivCd     As Variant          '病類コード
    Dim vntDisDivName   As Variant          '病類名
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objDisDiv = CreateObject("HainsDisease.Disease")
    lngCount = objDisDiv.SelectDisDivList(vntDisDivCd, vntDisDivName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "病類コード", 1500, lvwColumnLeft
    objHeader.Add , , "病類名", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntDisDivCd(i), vntDisDivCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntDisDivName(i)
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objDisDiv = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objDisDiv = Nothing
    
End Sub

'
' 機能　　 : まるめ分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromRoundClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRoundClass       As Object           'まるめ分類アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntRoundClassCd     As Variant          'まるめ分類コード
    Dim vntRoundClassName   As Variant          'まるめ分類名
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objRoundClass = CreateObject("HainsRoundClass.RoundClass")
    lngCount = objRoundClass.SelectRoundClassList(vntRoundClassCd, vntRoundClassName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "まるめ分類コード", 1500, lvwColumnLeft
    objHeader.Add , , "まるめ分類名", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRoundClassCd(i), vntRoundClassCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntRoundClassName(i)
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objRoundClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRoundClass = Nothing
    
End Sub

'
' 機能　　 : 文章分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromStcClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objStcClass     As Object           '文章分類アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntStcClassCd   As Variant          '文章分類コード
    Dim vntStcClassName As Variant          '文章分類名
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objStcClass = CreateObject("HainsSentence.Sentence")
    lngCount = objStcClass.SelectStcClassItemList(vntStcClassCd, vntStcClassName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "文章分類コード", 1500, lvwColumnLeft
    objHeader.Add , , "文章分類名", 4500, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntStcClassCd(i), vntStcClassCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntStcClassName(i)
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objStcClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objStcClass = Nothing
    
End Sub

'
' 機能　　 : 都道府県一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromPref(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objPref     As Object           '都道府県アクセス用
    Dim objHeader   As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem     As ListItem         'リストアイテムオブジェクト
    Dim vntPrefCd   As Variant          '都道府県コード
    Dim vntPrefName As Variant          '都道府県名
    Dim i           As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objPref = CreateObject("HainsPref.Pref")
    lngCount = objPref.SelectPrefList(vntPrefCd, vntPrefName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "都道府県コード", 1500, lvwColumnLeft
    objHeader.Add , , "都道府県名", 1100, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntPrefCd(i), vntPrefCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntPrefName(i)
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objPref = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPref = Nothing
    
End Sub

'
' 機能　　 : 続柄一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromRelation(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRelation     As Object           '続柄アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntRelationCd   As Variant          '続柄コード
    Dim vntRelationName As Variant          '続柄名
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objRelation = CreateObject("HainsPerson.Person")
    lngCount = objRelation.SelectRelationList(vntRelationCd, vntRelationName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "続柄コード", 1500, lvwColumnLeft
    objHeader.Add , , "続柄名", 4500, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRelationCd(i), vntRelationCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntRelationName(i)
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objRelation = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRelation = Nothing
    
End Sub

'
' 機能　　 : ユーザ一覧表示
'
' 引数　　 : (Out)  lngCount          検索結果件数
' 　　　　 : (In)   vntSearchCode     検索用コード（省略可）
' 　　　　 : (In)   vntSearchString   検索用文字列（省略可）
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromHainsUser(strNodeKey As String, lngCount As Long, _
                                      Optional ByVal vntSearchCode As Variant, _
                                      Optional ByVal vntSearchString As Variant)

On Error GoTo ErrorHandle

    Dim objHainsUser     As Object           'ユーザアクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntUserID       As Variant          'ユーザコード
    Dim vntUserName     As Variant          'ユーザ名
    Dim vntDelFlg       As Variant          '削除フラグ
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objHainsUser = CreateObject("HainsHainsUser.HainsUser")
    
    If (IsMissing(vntSearchCode) = False) Or (IsMissing(vntSearchCode) = False) Then
        lngCount = objHainsUser.SelectUserList(vntUserID, vntUserName, vntSearchCode, vntSearchString, vntDelFlg)
    Else
        lngCount = objHainsUser.SelectUserList(vntUserID, vntUserName, , , vntDelFlg)
    End If
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "ユーザＩＤ", 1500, lvwColumnLeft
    objHeader.Add , , "ユーザ名", 4000, lvwColumnLeft
    objHeader.Add , , "使用状態", 1000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntUserID(i), vntUserID(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntUserName(i)
        If vntDelFlg(i) = "1" Then
            objItem.SubItems(2) = "×"
        End If
        objItem.Tag = strNodeKey
    Next i
    
    'オブジェクト廃棄
    Set objHainsUser = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objHainsUser = Nothing
    
End Sub

'
' 機能　　 : システム環境設定（汎用テーブル、iniファイル系）
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromSysPro(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objHeader   As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem     As ListItem         'リストアイテムオブジェクト
    Dim i           As Long             'インデックス
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "名前", 1500, lvwColumnLeft
    objHeader.Add , , "説明", 6200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & TARGETSYSPRO_PRICE, "適用金額", , "DEFAULTLIST")
    objItem.SubItems(1) = "グループマスタ、検査項目マスタで設定されている２つの金額の適用方法を指定します。"
    objItem.Tag = strNodeKey
    
    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & TARGETSYSPRO_TAX, "適用税額", , "DEFAULTLIST")
    objItem.SubItems(1) = "消費税額の設定を行います。"
    objItem.Tag = strNodeKey
    
'    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & TARGETSYSPRO_COURSEFRA, "コース枠なし予約", , "DEFAULTLIST")
'    objItem.SubItems(1) = "コース枠を設定しないままの予約を可能にするかどうかを設定します。"
'
'    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & TARGETSYSPRO_BILLNO, "コース枠なし予約", , "DEFAULTLIST")
'    objItem.SubItems(1) = "コース枠を設定しないままの予約を可能にするかどうかを設定します。"
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Sub

'
' 機能　　 : 帳票設定一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromReport(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objReport               As Object           '帳票アクセス用
    Dim objHeader               As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem                 As ListItem         'リストアイテムオブジェクト
    Dim vntReportCd             As Variant          '帳票コード
    Dim vntReportName           As Variant          '帳票名
    Dim vntDefaultPrinter       As Variant
    Dim vntPrtMachine           As Variant
    Dim vntPreView              As Variant
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    Dim vntReportFlg            As Variant          '報告書フラグ
    Dim vntViewOrder            As Variant          '表示順
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####

    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
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
        
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "帳票コード", 1000, lvwColumnLeft
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'    objHeader.Add , , "帳票名", 2200, lvwColumnLeft
    objHeader.Add , , "帳票名", 2900, lvwColumnLeft
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
    objHeader.Add , , "出力先", 1100, lvwColumnLeft
    objHeader.Add , , "出力方法", 1100, lvwColumnLeft
    objHeader.Add , , "標準プリンタ", 2200, lvwColumnLeft
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    objHeader.Add , , "報告書", 750, lvwColumnCenter
    objHeader.Add , , "表示順", 750, lvwColumnLeft
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntReportCd(i), vntReportCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntReportName(i)
        
            If vntPrtMachine(i) = 1 Then
                .SubItems(2) = "サーバ"
            Else
                .SubItems(2) = "クライアント"
            End If
            
            If vntPreView(i) = 1 Then
                .SubItems(3) = "直接出力"
            Else
                .SubItems(3) = "プレビュー"
            End If
            
            .SubItems(4) = vntDefaultPrinter(i)
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
            .SubItems(5) = IIf(CLng("0" & vntReportFlg(i)) > 0, "○", "")
            .SubItems(6) = vntViewOrder(i)
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
        End With
    Next i
    
    'オブジェクト廃棄
    Set objReport = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objReport = Nothing
    
End Sub

'
' 機能　　 : 汎用テーブル設定一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromFree(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objFree                 As Object           '帳票アクセス用
    Dim objHeader               As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem                 As ListItem         'リストアイテムオブジェクト
    
    Dim vntFreeCd               As Variant          '帳票コード
    Dim vntFreeName             As Variant          '帳票名
    Dim vntFreeDate             As Variant
    Dim vntFreeField1           As Variant
    Dim vntFreeField2           As Variant
    Dim vntFreeField3           As Variant
    Dim vntFreeField4           As Variant
    Dim vntFreeField5           As Variant
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    Dim vntFreeField6           As Variant
    Dim vntFreeField7           As Variant
'### 2003.02.15 Added End
    Dim vntFreeClassCd          As Variant

    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
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
        
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "汎用コード", 1700, lvwColumnLeft
    objHeader.Add , , "汎用分類", 1000, lvwColumnLeft
    objHeader.Add , , "汎用名", 1800, lvwColumnLeft
    objHeader.Add , , "汎用日付", 1100, lvwColumnLeft
    objHeader.Add , , "フィールド１", 1100, lvwColumnLeft
    objHeader.Add , , "フィールド２", 1100, lvwColumnLeft
    objHeader.Add , , "フィールド３", 1100, lvwColumnLeft
    objHeader.Add , , "フィールド４", 1100, lvwColumnLeft
    objHeader.Add , , "フィールド５", 1100, lvwColumnLeft
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    objHeader.Add , , "フィールド６", 1100, lvwColumnLeft
    objHeader.Add , , "フィールド７", 1100, lvwColumnLeft
'### 2003.02.15 Added End
        
    lsvView.View = lvwReport
    
    'リストの編集
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
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
            .SubItems(9) = vntFreeField6(i)
            .SubItems(10) = vntFreeField7(i)
'### 2003.02.15 Added End
        End With
    Next i
    
    'オブジェクト廃棄
    Set objFree = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objFree = Nothing
    
End Sub

'
' 機能　　 : 汎用テーブル設定一覧表示
' 引数　　 :
' 戻り値　 :
' 備考　　 : 2005.03.28 Add by 李
'
Private Sub EditListViewFromPgmInfoList(strNodeKey As String, lngCount As Long)
    On Error GoTo ErrorHandle

    Dim colNodes            As Nodes            'ノードコレクション
    Dim objNode             As Node             'ノードオブジェクト
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objListItem         As ListItem         'リストアイテムオブジェクト
    Dim objPgmInfo          As Object           '結果コメントアクセス用
    
    Dim vntPgmCd            As Variant          'プログラムコード
    Dim vntPgmName          As Variant          'プログラム名
    Dim vntStartPgm         As Variant          '起動プログラム
    '2005.07.26 Add (ST)
    Dim vntFilePath         As Variant
    '2005.07.26 Add (END)
    Dim vntLinkImage        As Variant          'リンクイメージ
    Dim vntMenuGrpCd        As Variant          'メニューグループコード
    Dim vntPgmDesc          As Variant          'プログラム説明
    Dim vntDelFlag          As Variant          '
    Dim vntMenuName         As Variant          '
    
    Dim vntYudoBunrui       As Variant          '誘導検査分類
    Dim vntYobi1            As Variant          '予備1
    Dim vntYobi2            As Variant          '予備2
    
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    '各ノードの編集
    Set colNodes = trvMaster.Nodes
    
    'オブジェクトのインスタンス作成
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

    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コード", 1500, lvwColumnLeft
    objHeader.Add , , "プログラム名称", 2700, lvwColumnLeft
    objHeader.Add , , "DEL", 500, lvwColumnLeft
    objHeader.Add , , "起動プログラム", 1500, lvwColumnLeft
    objHeader.Add , , "プログラム経路", 2500, lvwColumnLeft
    objHeader.Add , , "リンクイメージ", 1500, lvwColumnLeft
    objHeader.Add , , "メニューグループコード", 1000, lvwColumnLeft
    objHeader.Add , , "メニューグループ名", 1000, lvwColumnLeft
    objHeader.Add , , "誘導検査分類", 1000, lvwColumnLeft
    objHeader.Add , , "プログラム説明", 3000, lvwColumnLeft

    lsvView.View = lvwReport
    
    'リストの編集
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
    
    'オブジェクト廃棄
    Set objPgmInfo = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPgmInfo = Nothing
    
End Sub


'
' 機能　　 : 汎用テーブル設定一覧表示
' 引数　　 :
' 戻り値　 :
' 備考　　 : 2005.03.23 Add by 李
'
Private Sub EditListViewFromUserGroup(strNodeKey As String, lngCount As Long)
    On Error GoTo ErrorHandle

    Dim objFree                 As Object           '帳票アクセス用
    Dim objHeader               As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem                 As ListItem         'リストアイテムオブジェクト
    Dim colNodes                As Nodes            'ノードコレクション
    Dim objNode                 As Node             'ノードオブジェクト
    Dim i                       As Integer          'インデックス
    Dim iMode                   As Integer
    Dim strKey                  As String
    Dim sColTitle(10)           As String
    
    Dim vntFreeCd               As Variant          'コード
    Dim vntFreeName             As Variant          'コード名
    Dim vntFreeDate             As Variant
    Dim vntFreeField1           As Variant
    Dim vntFreeField2           As Variant
    Dim vntFreeField3           As Variant
    Dim vntFreeField4           As Variant
    Dim vntFreeField5           As Variant
    Dim vntFreeField6           As Variant
    Dim vntFreeField7           As Variant
    Dim vntFreeClassCd          As Variant

    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    Select Case strNodeKey
        Case NODE_SECURITY_UGRPGM, NODE_SECURITY_USERGRP          'ユーザーグループ
            iMode = 0
            strKey = "UGR"
            sColTitle(0) = "コード"
            sColTitle(1) = "CLASS"
            sColTitle(2) = "ユーザーグループ名称"
            sColTitle(3) = "フィールド２"
            sColTitle(4) = "フィールド３"
            sColTitle(5) = "フィールド４"
            sColTitle(6) = "フィールド５"
            sColTitle(7) = "フィールド６"
            sColTitle(8) = "フィールド７"
        
        Case NODE_SECURITY_PWD
            iMode = 0
            strKey = "PWD"
            sColTitle(0) = "コード"
            sColTitle(1) = "CLASS"
            sColTitle(2) = "TERM"                       'ExpTerm
            sColTitle(3) = "ALERT"                      'AltTerm
            sColTitle(4) = "満了メッセージ1"             'ExpMsg
            sColTitle(5) = "満了メッセージ2"             'ExpMsg
            sColTitle(6) = "アラームメッセージ1"         'AltMsg
            sColTitle(7) = "アラームメッセージ2"         'AltMsg
            sColTitle(8) = "フィールド６"
            
        Case NODE_SECURITY_MENUGRP, NODE_SECURITY_PGMINFO
            iMode = 2
            strKey = "PGM"
            sColTitle(0) = "コード"
            sColTitle(1) = "CLASS"
            sColTitle(2) = "メニュー名称"
            sColTitle(3) = "フィールド２"
            sColTitle(4) = "フィールド３"
            sColTitle(5) = "フィールド４"
            sColTitle(6) = "フィールド５"
            sColTitle(7) = "フィールド６"
            sColTitle(8) = "フィールド７"
        
        Case Else
            If Mid(strNodeKey, 1, Len(TABLE_SECURITYGRP)) = TABLE_SECURITYGRP Then
                iMode = 1
                strKey = trvMaster.SelectedItem.Key
                sColTitle(0) = "コード"
                sColTitle(1) = "CLASS"
                sColTitle(2) = "名称"
                sColTitle(3) = "フィールド２"
                sColTitle(4) = "フィールド３"
                sColTitle(5) = "フィールド４"
                sColTitle(6) = "フィールド５"
                sColTitle(7) = "フィールド６"
                sColTitle(8) = "フィールド７"
            End If
            
    End Select
    
    
    'オブジェクトのインスタンス作成
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
        
    'ヘッダの編集
    lsvView.ListItems.Clear
    
    'リストの編集
    Select Case strNodeKey
        Case NODE_SECURITY_UGRPGM
            '各ノードの編集
            Set colNodes = trvMaster.Nodes
            
            For i = 1 To lngCount
                With colNodes
'                    .Add NODE_SECURITY_UGRPGM, tvwChild, vntFreeCd(i - 1), vntFreeField1(i - 1), ICON_CLOSED
                    .Add NODE_SECURITY_UGRPGM, tvwChild, vntFreeCd(i - 1), vntFreeField1(i - 1), ICON_CLOSED
                    .Item(trvMaster.SelectedItem.Index + i).Tag = vntFreeField2(i - 1)
                End With
            Next i
        
            'リスト編集
            Call EditListView(trvMaster.SelectedItem.Key)
            
        Case NODE_SECURITY_PGMINFO
'            '各ノードの編集
            Set colNodes = trvMaster.Nodes

            For i = 1 To lngCount
                With colNodes
                    .Add NODE_SECURITY_PGMINFO, tvwChild, vntFreeCd(i - 1), vntFreeField1(i - 1), ICON_CLOSED
                    .Item(trvMaster.SelectedItem.Index + i).Tag = vntFreeField2(i - 1)
'                    .Item.EnsureVisible = True
                End With
            Next i
            

            'リスト編集
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
    
    
    'オブジェクト廃棄
    Set objFree = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objFree = Nothing
    
End Sub



'
' 機能　　 : 計算設定一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromCalc(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objCalc         As Object           '都道府県アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntItemCd       As Variant          '検査項目コード
    Dim vntSuffix       As Variant          'サフィックス
    Dim vntItemName     As Variant          '検査項目名
    Dim vntHistoryCount As Variant          '検査項目名
    Dim i               As Long             'インデックス
    Dim strFullItemCd   As String
    Dim strDummy1       As String
    Dim strDummy2       As String
    
    strDummy1 = ""
    strDummy2 = ""
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objCalc = CreateObject("HainsCalc.Calc")
    lngCount = objCalc.SelectCalcList(True, _
                                      strDummy1, _
                                      strDummy2, _
                                      vntItemCd, _
                                      vntSuffix, _
                                      vntItemName, _
                                      vntHistoryCount)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "検査項目コード", 1500, lvwColumnLeft
    objHeader.Add , , "検査項目名", 2000, lvwColumnLeft
    objHeader.Add , , "履歴管理数", 1100, lvwColumnRight
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        strFullItemCd = vntItemCd(i) & KEY_SEPARATE & vntSuffix(i)
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & strFullItemCd, strFullItemCd, , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntItemName(i)
        objItem.SubItems(2) = vntHistoryCount(i)
    Next i
    
    'オブジェクト廃棄
    Set objCalc = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objCalc = Nothing
    
End Sub
'
' 機能　　 : 結果コメント一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromRslCmt(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRslCmt       As Object           '結果コメントアクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntRslCmtCd     As Variant          '結果コメントコード
    Dim vntRslCmtName   As Variant          '結果コメント名
    Dim vntEntryOk      As Variant          '入力完了フラグ
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objRslCmt = CreateObject("HainsRslCmt.RslCmt")
    lngCount = objRslCmt.SelectRslCmtList(vntRslCmtCd, vntRslCmtName, vntEntryOk)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コメントコード", 1200, lvwColumnLeft
    objHeader.Add , , "結果コメント名", 2200, lvwColumnLeft
    objHeader.Add , , "入力完了判断", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRslCmtCd(i), vntRslCmtCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntRslCmtName(i)
        If vntEntryOk(i) = 1 Then
            objItem.SubItems(2) = "入力完了とする"
        Else
            objItem.SubItems(2) = ""
        End If
    Next i
    
    'オブジェクト廃棄
    Set objRslCmt = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRslCmt = Nothing
    
End Sub

'
' 機能　　 : 検査実施日分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromOpeClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objOpeClass     As Object           '検査実施日分類アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntOpeClassCd   As Variant          '検査実施日分類コード
    Dim vntOpeClassName As Variant          '検査実施日分類名
    Dim vntOrderCntl    As Variant          '入力完了フラグ
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objOpeClass = CreateObject("HainsOpeClass.OpeClass")
    lngCount = objOpeClass.SelectOpeClassList(vntOpeClassCd, vntOpeClassName, vntOrderCntl)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "検査実施日分類コード", 1200, lvwColumnLeft
    objHeader.Add , , "検査実施日分類名", 2200, lvwColumnLeft
    objHeader.Add , , "オーダ制御用番号", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntOpeClassCd(i), vntOpeClassCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntOpeClassName(i)
        objItem.SubItems(2) = vntOrderCntl(i)
    Next i
    
    'オブジェクト廃棄
    Set objOpeClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objOpeClass = Nothing
    
End Sub

'
' 機能　　 : 財務適用コード一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromZaimu(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objZaimu            As Object           '財務適用コードアクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntZaimuCd          As Variant          '財務コードコード
    Dim vntZaimuName        As Variant          '財務適用名
    Dim vntZaimuDiv         As Variant          '財務種別
    Dim vntZaimuClass       As Variant          '財務分類
    Dim vntDisabled         As Variant          '未使用フラグ
    Dim i                   As Long             'インデックス
    Dim strZaimuClassName   As String
    Dim strZaimuDivName     As String
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    lngCount = objZaimu.SelectZaimuList(vntZaimuCd, vntZaimuName, vntZaimuDiv, vntZaimuClass, , vntDisabled, True)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "財務分類", 1300, lvwColumnLeft
    objHeader.Add , , "財務適用コード", 1500, lvwColumnLeft
    objHeader.Add , , "財務適用名", 3300, lvwColumnLeft
    objHeader.Add , , "財務種別", 1500, lvwColumnLeft
    objHeader.Add , , "使用可否", 1500, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Select Case vntZaimuClass(i)
            Case 0
                strZaimuClassName = "未分類"
            Case 1
                strZaimuClassName = "個人"
            Case 2
                strZaimuClassName = "団体"
            Case 3
                strZaimuClassName = "電話料金"
            Case 4
                strZaimuClassName = "文書作成"
            Case 5
                strZaimuClassName = "その他収入"
            Case Else
                strZaimuClassName = vntZaimuClass(i)
        End Select
        
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntZaimuCd(i), strZaimuClassName, , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntZaimuCd(i)
        objItem.SubItems(2) = vntZaimuName(i)
        
        Select Case vntZaimuDiv(i)
            Case 1
                strZaimuDivName = "未収"
            Case 2
                strZaimuDivName = "入金"
            Case 3
                strZaimuDivName = "過去未収金"
            Case 4
                strZaimuDivName = "還付"
            Case 5
                strZaimuDivName = "還付未払"
            Case Else
                strZaimuDivName = vntZaimuDiv(i)
        End Select
        
        objItem.SubItems(3) = strZaimuDivName
        If vntDisabled(i) = "1" Then
            objItem.SubItems(4) = "通常表示しない"
        End If
    Next i
    
    'オブジェクト廃棄
    Set objZaimu = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objZaimu = Nothing
    
End Sub

'
' 機能　　 : 基準値一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromStdValue(strNodeKey As String, strClassCd As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objStdValue         As Object           '基準値アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntStdValueMngCd    As Variant          '基準値管理コード
    Dim vntItemCd           As Variant          '検査項目コード
    Dim vntSuffix           As Variant          'サフィックス
    Dim vntStrDate          As Variant          '使用開始日付
    Dim vntEndDate          As Variant          '使用終了日付
    Dim vntCsCd             As Variant          '対象コースコード
    Dim vntItemName         As Variant          '検査項目名
    Dim vntCsName           As Variant          '対象コース名
    
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
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
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "項目コード", 1200, lvwColumnLeft
    objHeader.Add , , "検査項目名", 2000, lvwColumnLeft
    objHeader.Add , , "使用開始日付", 1300, lvwColumnLeft
    objHeader.Add , , "使用終了日付", 1300, lvwColumnLeft
    objHeader.Add , , "対象コース", 2000, lvwColumnLeft
    objHeader.Add , , "基準値管理コード", 1600, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntStdValueMngCd(i), vntItemCd(i) & "-" & vntSuffix(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntItemName(i)
        objItem.SubItems(2) = vntStrDate(i)
        objItem.SubItems(3) = vntEndDate(i)
        objItem.SubItems(4) = vntCsName(i)
        objItem.SubItems(5) = vntStdValueMngCd(i)
    Next i
    
    'オブジェクト廃棄
    Set objStdValue = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objStdValue = Nothing
    
End Sub
'
' 機能　　 : 特定健診用基準値一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromSpStdValue(strNodeKey As String, strClassCd As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objSpStdValue       As Object           '特定健診用基準値アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntSpStdValueMngCd  As Variant          '特定健診用基準値管理コード
    Dim vntItemCd           As Variant          '検査項目コード
    Dim vntSuffix           As Variant          'サフィックス
    Dim vntStrDate          As Variant          '使用開始日付
    Dim vntEndDate          As Variant          '使用終了日付
    Dim vntCsCd             As Variant          '対象コースコード
    Dim vntItemName         As Variant          '検査項目名
    Dim vntCsName           As Variant          '対象コース名
    
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
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
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "項目コード", 1200, lvwColumnLeft
    objHeader.Add , , "検査項目名", 2000, lvwColumnLeft
    objHeader.Add , , "使用開始日付", 1300, lvwColumnLeft
    objHeader.Add , , "使用終了日付", 1300, lvwColumnLeft
    objHeader.Add , , "対象コース", 2000, lvwColumnLeft
    objHeader.Add , , "基準値管理コード", 1600, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntSpStdValueMngCd(i), vntItemCd(i) & "-" & vntSuffix(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntItemName(i)
        objItem.SubItems(2) = vntStrDate(i)
        objItem.SubItems(3) = vntEndDate(i)
        objItem.SubItems(4) = vntCsName(i)
        objItem.SubItems(5) = vntSpStdValueMngCd(i)
    Next i
    
    'オブジェクト廃棄
    Set objSpStdValue = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSpStdValue = Nothing
    
End Sub


'
' 機能　　 : 指導内容一覧表示
'
' 引数　　 : (In)   strNodeKey      ノードキー
' 　　　　 : (Out)  strJudClassCd   判定分類コード
' 　　　　 : (Out)  lngCount        検索結果件数
'
' 戻り値　 :
'
' 備考　　 : 引数で指定された判定分類コードに該当する指導内容を表示する。
'
Private Sub EditListViewFromGuidance(strNodeKey As String, _
                                     strJudClassCd As String, _
                                     lngCount As Long)


On Error GoTo ErrorHandle

    Dim objGuidance         As Object           '指導内容アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntGuidanceCd       As Variant          '指導内容コード
    Dim vntGuidanceStc      As Variant          '指導内容名
    Dim vntJudClassCd       As Variant          '判定分類コード
    Dim vntJudClassName     As Variant          '判定分類名
    Dim vntEntryOk          As Variant          '入力完了フラグ
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objGuidance = CreateObject("HainsGuidance.Guidance")
    lngCount = objGuidance.SelectGuidanceList(strJudClassCd, vntGuidanceCd, vntGuidanceStc)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "指導内容コード", 1500, lvwColumnLeft
    objHeader.Add , , "指導内容名", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntGuidanceCd(i), vntGuidanceCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntGuidanceStc(i)
    Next i
    
    'オブジェクト廃棄
    Set objGuidance = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objGuidance = Nothing
    
End Sub

'
' 機能　　 : 定型所見一覧表示
'
' 引数　　 : (In)   strJudClassCd     判定分類コード
' 　　　　 : (Out)  lngCount          検索結果件数
' 　　　　 : (In)   vntSearchCode     検索用コード（省略可）
' 　　　　 : (In)   vntSearchString   検索用文字列（省略可）
'
' 戻り値　 :
'
' 備考　　 : 引数で指定された判定分類コードに該当する定型所見を表示する。
'
Private Sub EditListViewFromStdJud(strNodeKey As String, intJudClassCd As Integer, lngCount As Long, _
                                     Optional ByVal vntSearchCode As Variant, _
                                     Optional ByVal vntSearchString As Variant)


On Error GoTo ErrorHandle

    Dim objStdJud       As Object           '定型所見アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntJudClassCd   As Variant          '判定分類コード
    Dim vntStdJudCd     As Variant          '定型所見コード
    Dim vntStdJudName   As Variant          '定型所見名
    Dim vntEntryOk      As Variant          '入力完了フラグ
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objStdJud = CreateObject("HainsStdJud.StdJud")
    
    If (IsMissing(vntSearchCode) = False) Or (IsMissing(vntSearchCode) = False) Then
        lngCount = objStdJud.SelectStdJudList(intJudClassCd, vntStdJudCd, vntStdJudName, vntJudClassCd, vntSearchCode, vntSearchString)
    Else
        lngCount = objStdJud.SelectStdJudList(intJudClassCd, vntStdJudCd, vntStdJudName, vntJudClassCd)
    End If
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "定型所見コード", 1500, lvwColumnLeft
    objHeader.Add , , "定型所見名", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntJudClassCd(i) & "-" & vntStdJudCd(i), vntStdJudCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntStdJudName(i)
    Next i
    
    'オブジェクト廃棄
    Set objStdJud = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objStdJud = Nothing
    
End Sub

'
' 機能　　 : 依頼項目一覧表示
'
' 引数　　 : (In)   strItemClassCd    検査分類コード
' 　　　　 : (Out)  lngCount          検索結果件数
' 　　　　 : (In)   vntSearchCode     検索用コード（省略可）
' 　　　　 : (In)   vntSearchString   検索用文字列（省略可）
'
' 戻り値　 :
'
' 備考　　 : 引数で指定された検査分類コードに該当する依頼項目を表示する。
'
Private Sub EditListViewFromItem_p(strNodeKey As String, strItemClassCd As String, _
                                   lngCount As Long, _
                                   Optional ByVal vntSearchCode As Variant, _
                                   Optional ByVal vntSearchString As Variant)

On Error GoTo ErrorHandle

    Dim objItem_P               As Object           '依頼項目アクセス用
    Dim objHeader               As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem                 As ListItem         'リストアイテムオブジェクト
    Dim vntItemCd               As Variant          '検査項目コード
    Dim vntSuffix               As Variant          'サフィックス
    Dim vntRequestName          As Variant          '依頼項目名
    Dim vntProgressName         As Variant          '進捗分類名
    Dim vntRslQue               As Variant          '結果問診フラグ
    Dim vntEntryOk              As Variant          '未入力チェック
    Dim vntSearchChar           As Variant          'ガイド検索文字列
    Dim vntOpeClassName         As Variant          '検査実施日分類
    Dim vntPrice1               As Variant          '単価１
    Dim vntPrice2               As Variant          '単価２
    
    Dim vntDmdLineClassName     As Variant
    Dim vntIsrDmdLineClassName  As Variant
    Dim vntRoundClassName       As Variant
    
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
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
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "項目コード", 1000, lvwColumnLeft
    objHeader.Add , , "依頼項目名", 2000, lvwColumnLeft
    objHeader.Add , , "分類", 700, lvwColumnLeft
    objHeader.Add , , "未入力チェック", 1300, lvwColumnLeft
    objHeader.Add , , "進捗分類", 1400, lvwColumnLeft
    objHeader.Add , , "一般請求分類", 1400, lvwColumnLeft
    objHeader.Add , , "健保請求分類", 1400, lvwColumnLeft
    objHeader.Add , , "まるめ分類", 1400, lvwColumnLeft
    
'    objHeader.Add , , "単価１", 900, lvwColumnRight
'    objHeader.Add , , "単価２", 900, lvwColumnRight
'    objHeader.Add , , "検査実施分類", 2600, lvwColumnLeft
    objHeader.Add , , "検索文字", 1000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntItemCd(i), vntItemCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntRequestName(i)
            If vntRslQue(i) = 0 Then
                .SubItems(2) = "結果"
            Else
                .SubItems(2) = "問診"
            End If
            
            Select Case vntEntryOk(i)
                Case 0
                    .SubItems(3) = "最低１つ"
                Case 1
                    .SubItems(3) = "全て"
                Case 2
                    .SubItems(3) = "チェックしない"
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
    
    'オブジェクト廃棄
    Set objItem_P = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItem_P = Nothing
    
End Sub

'
' 機能　　 : 文章一覧表示
'
' 引数　　 : (Out)  lngCount          検索結果件数
' 　　　　 : (In)   vntSearchCode     検索用コード（省略可）
' 　　　　 : (In)   vntSearchString   検索用文字列（省略可）
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromSentence(strNodeKey As String, lngCount As Long, _
                                     Optional ByVal vntSearchCode As Variant, _
                                     Optional ByVal vntSearchString As Variant)


On Error GoTo ErrorHandle

    Dim objSentence     As Object           '文章アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    
    Dim vntItemCd       As Variant          '検査項目コード
    Dim vntItemType     As Variant          '項目タイプ
    Dim vntStcCd        As Variant          '文章コード
    Dim vntShortStc     As Variant          '略称
    Dim vntLongStc      As Variant          '正式文章
    Dim vntRequestName  As Variant          '依頼項目名
    Dim vntInsStc       As Variant          '検査連携用変換文章
    
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
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
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "項目コード", 1000, lvwColumnLeft
    objHeader.Add , , "項目名", 2000, lvwColumnLeft
    objHeader.Add , , "タイプ", 600, lvwColumnLeft
    objHeader.Add , , "文章コード", 1000, lvwColumnLeft
    objHeader.Add , , "文章名", 2200, lvwColumnLeft
    objHeader.Add , , "略称", 2000, lvwColumnLeft
    objHeader.Add , , "検査連携用文章", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntItemCd(i) & KEY_SEPARATE & vntItemType(i) & KEY_SEPARATE & vntStcCd(i) _
                                            , vntItemCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntRequestName(i)
            Select Case vntItemType(i)
                Case ITEMTYPE_STANDARD
                    .SubItems(2) = "標準"
                Case ITEMTYPE_BUI
                    .SubItems(2) = "部位"
                Case ITEMTYPE_SHOKEN
                    .SubItems(2) = "所見"
                Case ITEMTYPE_SHOCHI
                    .SubItems(2) = "処置"
                Case Else
                    .SubItems(2) = vntItemType(i)
            End Select
            
            .SubItems(3) = vntStcCd(i)
            .SubItems(4) = vntLongStc(i)
            .SubItems(5) = vntShortStc(i)
            .SubItems(6) = vntInsStc(i)
        End With
    Next i
    
    'オブジェクト廃棄
    Set objSentence = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSentence = Nothing
    
End Sub
'
' 機能　　 : 文章タイプの検査項目一覧表示
'
' 引数　　 : なし
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromSentenceItem(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objSentenceItem As Object           '文章アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    
    Dim vntCd           As Variant          '検査項目コード
    Dim vntSuffix       As Variant          'サフィックス
    Dim vntName         As Variant          '名称
    Dim vntClassCd      As Variant          '検査分類コード
    Dim vntClassName    As Variant          '検査分類名
    
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objSentenceItem = CreateObject("HainsItem.Item")
    lngCount = objSentenceItem.SelectItem_cList(vntClassCd, _
                                                "", _
                                                1, _
                                                vntCd, _
                                                vntSuffix, _
                                                vntName, _
                                                vntClassName, _
                                                RESULTTYPE_SENTENCE)
   
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "項目コード", 1200, lvwColumnLeft
    objHeader.Add , , "項目名", 2000, lvwColumnLeft
    objHeader.Add , , "検査分類名", 1800, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntCd(i) & KEY_SEPARATE & vntSuffix(i), vntCd(i) & "-" & vntSuffix(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntName(i)
            .SubItems(2) = vntClassName(i)
        End With
    Next i
    
    'オブジェクト廃棄
    Set objItem = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItem = Nothing
    
End Sub

'
' 機能　　 : 検査項目一覧表示
'
' 引数　　 : (In)   strItemClassCd      検査分類コード
' 　　　　 : (Out)  lngCount            検索結果件数
' 　　　　 : (In)   vntSearchCode       検索用コード（省略可）
' 　　　　 : (In)   vntSearchString     検索用文字列（省略可）
'
' 戻り値　 :
'
' 備考　　 : 引数で指定された検査分類コードに該当する検査項目を表示する。
'
Private Sub EditListViewFromItem_c(strNodeKey As String, strItemClassCd As String, _
                                   lngCount As Long, _
                                   Optional ByVal vntSearchCode As Variant, _
                                   Optional ByVal vntSearchString As Variant)

On Error GoTo ErrorHandle

    Dim objItem_P       As Object           '検査項目アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    
    Dim vntItemCd       As Variant          '検査項目コード
    Dim vntSuffix       As Variant          'サフィックス
    Dim vntItemName     As Variant          '検査項目名
    Dim vntResultType   As Variant          '結果タイプ
    
    Dim i               As Long             'インデックス
    Dim strFullItemCd   As String
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
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
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "項目コード", 1200, lvwColumnLeft
    objHeader.Add , , "検査項目名", 2000, lvwColumnLeft
    objHeader.Add , , "結果タイプ", 1900, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        strFullItemCd = vntItemCd(i) & KEY_SEPARATE & vntSuffix(i)
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & strFullItemCd, strFullItemCd, , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntItemName(i)
            Select Case vntResultType(i)
        
                Case RESULTTYPE_NUMERIC         '数値
                    .SubItems(2) = "数値タイプ"
                Case RESULTTYPE_TEISEI1         '定性１
                    .SubItems(2) = "定性（標準）"
                Case RESULTTYPE_TEISEI2         '定性２
                    .SubItems(2) = "定性（拡張）"
                Case RESULTTYPE_FREE            'フリー
                    .SubItems(2) = "フリー"
                Case RESULTTYPE_SENTENCE        '文章
                    .SubItems(2) = "文章タイプ"
                Case RESULTTYPE_CALC            '計算
                    .SubItems(2) = "計算タイプ"
                Case RESULTTYPE_DATE            '日付タイプ
                    .SubItems(2) = "日付タイプ"
'### 2003/11/19 Added by Ishihara@FSIT 聖路加版で追加になった
                Case 7                          'メモタイプ
                    .SubItems(2) = "メモタイプ"
                Case 8                          'メモタイプ
                    .SubItems(2) = "符号つき数字タイプ"
'### 2003/11/19 Added End
                Case Else
                    .SubItems(2) = "？"
            End Select
        End With
    
    Next i
    
    'オブジェクト廃棄
    Set objItem_P = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItem_P = Nothing
    
End Sub


'
' 機能　　 : 判定コメント一覧表示
'
' 引数　　 : (In)   strJudClassCd     判定分類コード
' 　　　　 : (Out)  lngCount          検索結果件数
' 　　　　 : (In)   vntSearchCode     検索用コード（省略可）
' 　　　　 : (In)   vntSearchString   検索用文字列（省略可）
'
' 戻り値　 :
'
' 備考　　 : 引数で指定された判定分類コードに該当する判定コメントを表示する。
'
Private Sub EditListViewFromJudCmtStc(strNodeKey As String, _
                                      strJudClassCd As String, _
                                      lngCount As Long, _
                                      Optional ByVal vntSearchCode As Variant, _
                                      Optional ByVal vntSearchString As Variant)

On Error GoTo ErrorHandle

    Dim objJudCmtStc        As Object           '判定コメントアクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntJudCmtCd         As Variant          '判定コメントコード
    Dim vntJudCmtStcName    As Variant          '判定コメント名
    Dim vntDummy(2)         As Variant          'COM+引数用ダミー変数
    
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    
    If (IsMissing(vntSearchCode) = False) Or (IsMissing(vntSearchCode) = False) Then

'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
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
        
'### 2004/1/15 Modified by Ishihara@FSIT　いつのまにか表示モードが追加になっていた。
'        lngCount = objJudCmtStc.SelectJudCmtStcList(IIf(strJudClassCd = TABLE_JUDCMTSTC, "", strJudClassCd), _
                                                    vntDummy(0), _
                                                    1, _
                                                    "", _
                                                    vntJudCmtCd, _
                                                    vntJudCmtStcName, _
                                                    vntDummy(1), _
                                                    vntDummy(2))

'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
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
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "判定コメントコード", 1500, lvwColumnLeft
    objHeader.Add , , "判定コメント", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntJudCmtCd(i), vntJudCmtCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntJudCmtStcName(i)
    Next i
    
    'オブジェクト廃棄
    Set objJudCmtStc = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objJudCmtStc = Nothing
    
End Sub

'
' 機能　　 : WEB用コース設定一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromWeb_Cs(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objWeb_Cs       As Object           'WEB用コースアクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntWeb_CsCd     As Variant          'WEB用コースコード
    Dim vntWeb_CsName   As Variant          'WEB用コース名
    Dim vntWeb_OutLine  As Variant          '検査項目説明
    Dim vntEntryOk      As Variant          '入力完了フラグ
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objWeb_Cs = CreateObject("HainsWeb_Cs.Web_Cs")
    lngCount = objWeb_Cs.SelectWeb_CsList(vntWeb_CsCd, vntWeb_CsName, vntWeb_OutLine)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コースコード", 1500, lvwColumnLeft
    objHeader.Add , , "WEB用コース名", 2000, lvwColumnLeft
    objHeader.Add , , "概略", 5000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntWeb_CsCd(i), vntWeb_CsCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntWeb_CsName(i)
        objItem.SubItems(2) = Replace(vntWeb_OutLine(i), "<BR>", Space(1))
    Next i
    
    'オブジェクト廃棄
    Set objWeb_Cs = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objWeb_Cs = Nothing
    
End Sub

'
' 機能　　 : 進捗管理用分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromProgress(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objProgress         As Object           '進捗管理用判定分類アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntProgressCd       As Variant          '進捗管理用コード
    Dim vntProgressName     As Variant          '進捗管理用名
    Dim vntProgressSName    As Variant          '進捗管理用略称
    Dim vntSeq              As Variant          '表示順番
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objProgress = CreateObject("HainsProgress.Progress")
    lngCount = objProgress.SelectProgressList(vntProgressCd, vntProgressName, vntProgressSName, vntSeq)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    lsvView.ListItems.Clear
    objHeader.Clear
    objHeader.Add , , "進捗分類コード", 1500, lvwColumnLeft
    objHeader.Add , , "進捗管理用名", 2200, lvwColumnLeft
    objHeader.Add , , "略称", 2200, lvwColumnLeft
    objHeader.Add , , "表示順番", 1000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntProgressCd(i), vntProgressCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntProgressName(i)
        objItem.SubItems(2) = vntProgressSName(i)
        objItem.SubItems(3) = vntSeq(i)
    Next i
    
    'オブジェクト廃棄
    Set objProgress = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objProgress = Nothing
    
End Sub

'
' 機能　　 : 端末管理一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromWorkStation(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objWorkStation      As Object           '進捗管理用判定分類アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntIpAddress        As Variant          'IPアドレス
    Dim vntWkStnName        As Variant          '端末名
    Dim vntGrpCd            As Variant          'グループコード
    Dim vntGrpName          As Variant          'グループ名
    Dim vntProgressName     As Variant          '進捗分類名
    Dim vntIsPrintButton    As Variant          '結果入力上のボタン表示
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objWorkStation = CreateObject("HainsWorkStation.WorkStation")
    lngCount = objWorkStation.SelectWorkStationList(vntIpAddress, vntWkStnName, vntGrpCd, vntGrpName, , vntProgressName, vntIsPrintButton)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    lsvView.ListItems.Clear
    objHeader.Clear
    objHeader.Add , , "IPアドレス", 1500, lvwColumnLeft
    objHeader.Add , , "端末名", 2200, lvwColumnLeft
    objHeader.Add , , "グループコード", 1200, lvwColumnLeft
    objHeader.Add , , "グループ名", 1500, lvwColumnLeft
'    objHeader.Add , , "進捗分類名", 1500, lvwColumnLeft
    objHeader.Add , , "結果入力の印刷ボタン", 3000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntIpAddress(i), vntIpAddress(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntWkStnName(i)
        objItem.SubItems(2) = vntGrpCd(i)
        objItem.SubItems(3) = vntGrpName(i)
'        objItem.SubItems(4) = vntProgressName(i)
        Select Case vntIsPrintButton(i)
            Case "1"
                objItem.SubItems(4) = "超音波検査表印刷ボタン表示"
            Case "2"
                objItem.SubItems(4) = "口腔疾患検査結果表印刷ボタン表示"
        End Select
    Next i
    
    'オブジェクト廃棄
    Set objWorkStation = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objWorkStation = Nothing
    
End Sub

'
' 機能　　 : 判定一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromJud(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objJud              As Object           '判定アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntJudCd            As Variant          '判定コード
    Dim vntJudSName         As Variant          '判定略称
    Dim vntJudRName         As Variant          '報告書用判定名
    Dim vntWeight           As Variant          '判定用重み
    Dim vntGovMngJud        As Variant          '政府管掌用コード
    Dim vntGovMngJudName    As Variant          '政府管掌用名称
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objJud = CreateObject("HainsJud.Jud")
    lngCount = objJud.SelectJudList(vntJudCd, vntJudSName, vntJudRName, vntWeight, vntGovMngJud, vntGovMngJudName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コード", 650, lvwColumnLeft
    objHeader.Add , , "略称", 1300, lvwColumnLeft
    objHeader.Add , , "報告書用判定名", 2000, lvwColumnLeft
    objHeader.Add , , "重み", 600, lvwColumnLeft
'#### 2010.07.16 SL-HS-Y0101-001 DEL START ####　COMP-LUKES-0018（非互換検証）
'    objHeader.Add , , "政管用コード", 1200, lvwColumnLeft
'    objHeader.Add , , "政管用名称", 2000, lvwColumnLeft
'#### 2010.07.16 SL-HS-Y0101-001 DEL END 　####　COMP-LUKES-0018（非互換検証）
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntJudCd(i), vntJudCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntJudSName(i)
            .SubItems(2) = vntJudRName(i)
            .SubItems(3) = vntWeight(i)
'#### 2010.07.16 SL-HS-Y0101-001 DEL START ####　COMP-LUKES-0018（非互換検証）
'            .SubItems(4) = vntGovMngJud(i)
'            .SubItems(5) = vntGovMngJudName(i)
'#### 2010.07.16 SL-HS-Y0101-001 DEL END 　####　COMP-LUKES-0018（非互換検証）
        End With
    Next i
    
    'オブジェクト廃棄
    Set objJud = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objJud = Nothing
    
End Sub

'
' 機能　　 : 予約枠一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromRsvFra(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRsvFra           As Object           '予約枠アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntRsvFraCd         As Variant          '予約枠コード
    Dim vntRsvFraName       As Variant          '予約枠名
    Dim vntOverRsv          As Variant          '枠オーバ登録
    Dim vntFraType          As Variant          '枠タイプ
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objRsvFra = CreateObject("HainsSchedule.Schedule")
    lngCount = objRsvFra.SelectRsvFraList(vntRsvFraCd, vntRsvFraName, vntOverRsv, vntFraType)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コード", 750, lvwColumnLeft
    objHeader.Add , , "予約枠名", 3500, lvwColumnLeft
    objHeader.Add , , "枠タイプ", 1200, lvwColumnLeft
    objHeader.Add , , "枠オーバ登録", 1200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRsvFraCd(i), vntRsvFraCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntRsvFraName(i)
        If vntFraType(i) = "1" Then
            objItem.SubItems(2) = "検査項目枠"
        Else
            objItem.SubItems(2) = "コース枠"
        End If
        If vntOverRsv(i) = "1" Then
            objItem.SubItems(3) = "可能"
        End If
    Next i
    
    'オブジェクト廃棄
    Set objRsvFra = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRsvFra = Nothing
    
End Sub

'
' 機能　　 : 予約群一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromRsvGrp(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objRsvGrp           As Object           '予約群アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntRsvGrpCd         As Variant          '予約群コード
    Dim vntRsvGrpName       As Variant          '予約群名称
    Dim vntStrTime          As Variant          '開始時間
    Dim vntEndTime          As Variant          '終了時間
    Dim vntRptEndTime       As Variant          '健診受付終了時間
    Dim vntlead             As Variant          '誘導対象
    Dim vntrsvSetGrpCd      As Variant          '予約時セットグループコード
    Dim i                   As Long             'インデックス
    Dim lngSortOrder        As Long             'ソート順(0:予約群コード順、0以外:開始時間順)
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objRsvGrp = CreateObject("HainsSchedule.Schedule")
    lngCount = objRsvGrp.SelectRsvGrpList(lngSortOrder, vntRsvGrpCd, vntRsvGrpName, vntStrTime, vntEndTime, vntRptEndTime)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コード", 750, lvwColumnLeft
    objHeader.Add , , "予約群名称", 2000, lvwColumnLeft
    objHeader.Add , , "開始時間", 1000, lvwColumnRight
    objHeader.Add , , "終了時間", 1000, lvwColumnRight
    objHeader.Add , , "健診受付終了時間", 1700, lvwColumnRight
    
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntRsvGrpCd(i), vntRsvGrpCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntRsvGrpName(i)
        objItem.SubItems(2) = IIf(vntStrTime(i) > 0, Format(vntStrTime(i), "##:#0"), "　")
        objItem.SubItems(3) = IIf(vntEndTime(i) > 0, Format(vntEndTime(i), "##:#0"), "　")
        objItem.SubItems(4) = IIf(vntRptEndTime(i) > 0, Format(vntRptEndTime(i), "##:#0"), "　")
    Next i
    
    'オブジェクト廃棄
    Set objRsvGrp = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objRsvGrp = Nothing
    
End Sub
'
' 機能　　 : コース受診予約群一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromCourseRsvGrp(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objCrsRsvGrp        As Object           '予約群アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト

    Dim vntCsCd             As Variant          'コースコード
    Dim vntRsvGrpCd         As Variant          '予約群コード
    Dim vntmngGender        As Variant          '男女別枠管理
    Dim vntDefCnt           As Variant          'デフォルト人数（共通）
    Dim vntDefCnt_m         As Variant          'デフォルト人数（男）
    Dim vntDefCnt_f         As Variant          'デフォルト人数（女）
    Dim vntDefCnt_sat       As Variant          'デフォルト人数（土曜共通）
    Dim vntDefCnt_sat_m     As Variant          'デフォルト人数（土曜男）
    Dim vntDefCnt_sat_f     As Variant          'デフォルト人数（土曜女）
    Dim vntRsvGrpName       As Variant          '予約群名称
    Dim vntCsName           As Variant          'コース名称
    Dim i                   As Long             'インデックス

    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objCrsRsvGrp = CreateObject("HainsSchedule.Schedule")
    lngCount = objCrsRsvGrp.SelectCrsRsvGrpList(vntCsCd, vntRsvGrpCd, vntmngGender, vntDefCnt, vntDefCnt_m, vntDefCnt_f, vntDefCnt_sat, vntDefCnt_sat_m, vntDefCnt_sat_f, vntRsvGrpName, vntCsName)
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コースコード", 1000, lvwColumnLeft
    objHeader.Add , , "コース名称", 1800, lvwColumnLeft
    objHeader.Add , , "予約群名称", 1500, lvwColumnLeft
    objHeader.Add , , "男女別枠管理", 1300, lvwColumnLeft
    objHeader.Add , , "デフォルト人数（共通）", 2100, lvwColumnLeft
    objHeader.Add , , "デフォルト人数（男）", 2100, lvwColumnLeft
    objHeader.Add , , "デフォルト人数（女）", 2100, lvwColumnLeft
    objHeader.Add , , "デフォルト人数（土曜共通）", 2100, lvwColumnLeft
    objHeader.Add , , "デフォルト人数（土曜男）", 2100, lvwColumnLeft
    objHeader.Add , , "デフォルト人数（土曜女）", 2100, lvwColumnLeft
    
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntCsCd(i) & KEY_SEPARATE & vntRsvGrpCd(i), vntCsCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntCsName(i)
        objItem.SubItems(2) = vntRsvGrpName(i)
        If vntmngGender(i) = "1" Then
            objItem.SubItems(3) = "する"
        Else
            objItem.SubItems(3) = "しない"
        End If
        objItem.SubItems(4) = vntDefCnt(i) & "人"
        objItem.SubItems(5) = vntDefCnt_m(i) & "人"
        objItem.SubItems(6) = vntDefCnt_f(i) & "人"
        objItem.SubItems(7) = vntDefCnt_sat(i) & "人"
        objItem.SubItems(8) = vntDefCnt_sat_m(i) & "人"
        objItem.SubItems(9) = vntDefCnt_sat_f(i) & "人"
    Next i
    
    'オブジェクト廃棄
    Set objCrsRsvGrp = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objCrsRsvGrp = Nothing
    
End Sub

'
' 機能　　 : 判定分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromJudClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objJudClass     As Object           '結果コメントアクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntJudClassCd   As Variant          '結果コメントコード
    Dim vntJudClassName As Variant          '結果コメント名
    Dim vntAllJudFlg    As Variant          '入力完了フラグ
    Dim vntAfterCareCd  As Variant          'アフターケアコード
    Dim vntIsrOrganDiv  As Variant          '健保用器官区分文字列
    Dim i               As Long             'インデックス
    
'## 2004.02.13 Added 5Lines By H.Ishihara@FSIT 聖路加専用項目の追加
    Dim vntCommentOnly      As Variant      'コメント表示モード
    Dim vntViewOrder        As Variant      '判定分類表示順
    Dim vntResultDispMode   As Variant      '検査結果表示モード（判定リンク用）
    Dim vntNotAutoFlg       As Variant      '自動判定対象外フラグ
    Dim vntNotNormalFlg     As Variant      '通常判定対象外フラグ
'## 2004.02.13 Added End
        
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
'    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName, vntAllJudFlg, vntAfterCareCd, vntIsrOrganDiv)
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName, vntAllJudFlg, _
                                              vntAfterCareCd, vntIsrOrganDiv, _
                                              vntCommentOnly, _
                                              vntViewOrder, _
                                              vntResultDispMode, _
                                              vntNotAutoFlg, _
                                              vntNotNormalFlg)
'## 2004.02.13 Mod End
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "判定分類コード", 1500, lvwColumnLeft
    objHeader.Add , , "判定分類名", 2500, lvwColumnLeft
'    objHeader.Add , , "統計時の判断", 2000, lvwColumnLeft
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
'    objHeader.Add , , "アフターケアコード", 2000, lvwColumnLeft
'    objHeader.Add , , "健保用器官区分文字列", 2000, lvwColumnLeft
    objHeader.Add , , "コメント用", 1000, lvwColumnCenter
    objHeader.Add , , "判定表示順", 1200, lvwColumnRight
    objHeader.Add , , "自動判定対象外", 1500, lvwColumnCenter
    objHeader.Add , , "通常計算対象外", 1500, lvwColumnCenter
'## 2004.02.13 Mod End
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntJudClassCd(i), vntJudClassCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntJudClassName(i)
'        If vntAllJudFlg(i) = 1 Then
'            objItem.SubItems(2) = "総合判定とする"
'        Else
'            objItem.SubItems(2) = ""
'        End If
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
'        objItem.SubItems(2) = vntAfterCareCd(i)
'        objItem.SubItems(3) = vntIsrOrganDiv(i)
        objItem.SubItems(2) = IIf(vntCommentOnly(i) = "1", "○", "")
        objItem.SubItems(3) = vntViewOrder(i)
        objItem.SubItems(4) = IIf(vntNotAutoFlg(i) = "1", "○", "")
        objItem.SubItems(5) = IIf(vntNotNormalFlg(i) = "1", "○", "")
'## 2004.02.13 Mod End
    Next i
    
    'オブジェクト廃棄
    Set objJudClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objJudClass = Nothing
    
End Sub



'
' 機能　　 : 検査分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromItemClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objItemClass        As Object           '検査分類アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntItemClassCd      As Variant          '検査分類コード
    Dim vntItemClassName    As Variant          '検査分類名
'    Dim lngCount            As Long             'レコード数
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objItemClass = CreateObject("HainsItem.Item")
    lngCount = objItemClass.SelectItemClassList(vntItemClassCd, vntItemClassName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "検査分類コード", 1400, lvwColumnLeft
    objHeader.Add , , "検査分類名", 4000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntItemClassCd(i), vntItemClassCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntItemClassName(i)
    Next i
    
    'オブジェクト廃棄
    Set objItemClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItemClass = Nothing
    
End Sub

'
' 機能　　 : セット分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromSetClass(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objSetClass        As Object           '検査分類アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntSetClassCd      As Variant          '検査分類コード
    Dim vntSetClassName    As Variant          '検査分類名
'    Dim lngCount            As Long             'レコード数
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objSetClass = CreateObject("HainsSetClass.SetClass")
    lngCount = objSetClass.SelectSetClassList(vntSetClassCd, vntSetClassName)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "セット分類コード", 1400, lvwColumnLeft
    objHeader.Add , , "セット分類名", 4000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntSetClassCd(i), vntSetClassCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntSetClassName(i)
    Next i
    
    'オブジェクト廃棄
    Set objSetClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSetClass = Nothing
    
End Sub

'
' 機能　　 : グループ一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromGrp(strNodeKey As String, strGrpDiv As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objGrp          As Object           'グループアクセス用
    
'*********************:2004/08/26 FJTH)M,E **********************************************
    Dim objGrp2          As Object           'グループアクセス用
'*********************:2004/08/26 FJTH)M,E **********************************************

    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    Dim vntGrpDiv       As Variant          '検索グループ区分
    Dim vntGrpCd        As Variant          'グループコード
    Dim vntGrpName      As Variant          'グループ名
    Dim vntClassCd      As Variant          '分類コード
    Dim vntClassName    As Variant          '分類名
    Dim vntPrice1       As Variant          '単価１
    Dim vntPrice2       As Variant          '単価２
    Dim i               As Long             'インデックス
    Dim strWorkPrice    As String           '金額の\編集用
'### 2003.2.17 Added by Ishihara@FSIT システム制御用グループ追加
    Dim vntSystemGrp    As Variant          'システム制御用グループ
'### 2003.2.17 Added End
    
    
'### 2006/02/03 Add by 李 ST)  -------->
    Dim vntUseGrp       As Variant
    Dim strUseGrp       As String
'### 2006/02/03 Add by 李 ED)  -------->
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objGrp = CreateObject("HainsGrp.Grp")
    
    'グループ区分による変数ハンドリング
    If strGrpDiv = TABLE_GRP_R Then
        vntGrpDiv = "1"
    Else
        vntGrpDiv = "2"
    End If

 
'*********************:2004/08/26 FJTH)M,E **********************************************
'    '検査分類名あり、検査項目なしでも出力指定で読み込み
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
    '検査分類名あり、検査項目なしでも出力指定で読み込み
    
'## 2006/02/03 Edit by 李 - UseGrp 追加 ST) --------------------------------------------->
'    lngcount = objGrp2.SelectGrp_ORGList_GrpDiv(vntGrpDiv, vntGrpCd, _
                                             vntGrpName, _
                                             vntSystemGrp)

    lngCount = objGrp2.SelectGrp_ORGList_GrpDiv(vntGrpDiv, vntGrpCd, _
                                             vntGrpName, _
                                             vntSystemGrp, _
                                             vntUseGrp)
'## 2006/02/03 Edit by 李 - UseGrp 追加 ED) --------------------------------------------->


Else
    '検査分類名あり、検査項目なしでも出力指定で読み込み
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
    
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コード", 1200, lvwColumnLeft
    objHeader.Add , , "グループ名", 2200, lvwColumnLeft

'*********************:2004/08/26 FJTH)M,E **********************************************
'    objHeader.Add , , "検査分類", 1500, lvwColumnLeft
    If strGrpDiv <> TABLE_ORGGRP Then
        objHeader.Add , , "検査分類", 1500, lvwColumnLeft
    End If
'*********************:2004/08/26 FJTH)M,E **********************************************


'### 2003.2.17 Added by Ishihara@FSIT システム制御用グループ追加
    objHeader.Add , , "システムグループ", 2000, lvwColumnLeft
'### 2003.2.17 Added End
'### 2002.12.22 Deleted by H.Ishihara@FSIT 東急殿はグループに金額がいらない
'    objHeader.Add , , "単価１", 1100, lvwColumnRight
'    objHeader.Add , , "単価２", 1100, lvwColumnRight
'### 2002.12.22 Deleted End
        
'### 2006.02.03 Add by 李  ST) -------------------------------------->
    objHeader.Add , , "使用区分", 1500, lvwColumnLeft
'### 2006.02.03 Add by 李  ED) -------------------------------------->
                
    lsvView.View = lvwReport
    
    'リストの編集
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
                .SubItems(2) = "システム使用グループ"
            Else
                .SubItems(2) = ""
            End If
            
            '2006.02.03 Add by 李：UseGrp追加
            Select Case Format(vntUseGrp(i))
                Case 0
                    strUseGrp = ""
                Case 1
                    strUseGrp = "成績書グループ"
                Case 2
                    strUseGrp = "標準FPDグループ"
                Case 3
                    strUseGrp = "統計グループ"
            End Select
            
            .SubItems(3) = strUseGrp
            
   Else
            If vntSystemGrp(i) = "1" Then
                .SubItems(3) = "システム使用グループ"
            Else
                .SubItems(3) = ""
            End If
   End If
'*********************:2004/08/26 FJTH)M,E -e**********************************************
        
        
'### 2002.12.22 Deleted by H.Ishihara@FSIT 東急殿はグループに金額がいらない
'            '金額は\編集
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
' 機能　　 : コース一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromCourse(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objCourse       As Object               'コースアクセス用
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト
    Dim vntCsCd         As Variant              'コースコード
    Dim vntCsName       As Variant              'コース名
    
    Dim vntMainCsCd     As Variant
    Dim vntMainCsName   As Variant
    Dim vntCsDiv        As Variant
    Dim vntRoundFlg     As Variant
    Dim vntRegularFlg   As Variant
    

    
    Dim i           As Long                 'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName, , , vntMainCsCd, vntMainCsName, vntCsDiv, vntRoundFlg, vntRegularFlg)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コースコード", 1000, lvwColumnLeft
    objHeader.Add , , "コース名", 2500, lvwColumnLeft
    objHeader.Add , , "コース区分", 1000, lvwColumnLeft
    objHeader.Add , , "メインコース", 2000, lvwColumnLeft
    objHeader.Add , , "追加検査", 1200, lvwColumnLeft
    objHeader.Add , , "定期健診フラグ", 1500, lvwColumnLeft
    
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntCsCd(i), vntCsCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntCsName(i)
    
        Select Case vntCsDiv(i)
            Case "0"
                objItem.SubItems(2) = "メイン・サブ"
            Case "1"
                objItem.SubItems(2) = "メイン"
            Case "2"
                objItem.SubItems(2) = "メイン (×)"
            Case "3"
                objItem.SubItems(2) = "サブ"
        End Select
            
        If vntCsCd(i) <> vntMainCsCd(i) Then objItem.SubItems(3) = vntMainCsName(i)
        If vntRoundFlg(i) = "1" Then objItem.SubItems(4) = "金額計上する"
        If vntRegularFlg(i) = "1" Then objItem.SubItems(5) = "定期健診"
        
    Next i
    
    'オブジェクト廃棄
    Set objCourse = Nothing
            
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objCourse = Nothing

End Sub

'
' 機能　　 : 判定分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : 判定分類一覧からノードフォルダを展開する。
'
Private Sub EditTreeViewFromJudClass(strNodeKey As String)

On Error GoTo ErrorHandle

    Dim colNodes        As Nodes            'ノードコレクション
    Dim objNode         As Node             'ノードオブジェクト
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objListItem     As ListItem         'リストアイテムオブジェクト
    Dim objJudClass     As Object           '結果コメントアクセス用
    Dim vntJudClassCd   As Variant          '結果コメントコード
    Dim vntJudClassName As Variant          '結果コメント名
    Dim lngCount        As Long             'レコード数
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    '各ノードの編集
    Set colNodes = trvMaster.Nodes
    
    'オブジェクトのインスタンス作成
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)

    'ノードが判定コメントテーブルの場合、”分類指定なし"ノードを追加
'### 2003.01.17 Modified by H.Ishihara@FSIT 指導文章にも指定なしが必要
'    If strNodeKey = TABLE_JUDCMTSTC Then
    If (strNodeKey = TABLE_JUDCMTSTC) Or (strNodeKey = TABLE_GUIDANCE) Then
        'ノードキーは敢えて繰り返すことによりユニーク化（判定コメントコードは8Byteなので重複することはない）
        colNodes.Add strNodeKey, tvwChild, strNodeKey & strNodeKey, "全て表示", ICON_CLOSED
    End If

    'リストの編集
    For i = 0 To lngCount - 1
        colNodes.Add strNodeKey, tvwChild, strNodeKey & vntJudClassCd(i), vntJudClassName(i), ICON_CLOSED
    Next i
        
    'リストアイテムクリア
    lsvView.ListItems.Clear
    lsvView.View = lvwList
        
    '指定ノードを親にもつノードの内容を編集
    For Each objNode In colNodes
        
        Do
            '親ノードがなければ何もしない
            If objNode.Parent Is Nothing Then
                Exit Do
            End If
        
            '親ノードが指定ノードと一致しない場合は何もしない
            If objNode.Parent.Key <> strNodeKey Then
                Exit Do
            End If
       
            'リストアイテムの編集
            Set objListItem = lsvView.ListItems.Add
            With objListItem
                .Text = objNode.Text
                .Key = objNode.Key
                .SmallIcon = ICON_CLOSED
                .Tag = NODE_TYPEFOLDER        'データとしてのリストアイテムと区別する
            End With
            
            Exit Do
        Loop
    
    Next
    
    'オブジェクト廃棄
    Set objJudClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objJudClass = Nothing
    
End Sub

'
' 機能　　 : 検査分類一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : 検査分類一覧からノードフォルダを展開する。
'
Private Sub EditTreeViewFromItemClass(strNodeKey As String)

On Error GoTo ErrorHandle

    Dim colNodes            As Nodes            'ノードコレクション
    Dim objNode             As Node             'ノードオブジェクト
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objListItem         As ListItem         'リストアイテムオブジェクト
    Dim objItemClass        As Object           '結果コメントアクセス用
    Dim vntItemClassCd      As Variant          '結果コメントコード
    Dim vntItemClassName    As Variant          '結果コメント名
    Dim lngCount            As Long             'レコード数
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    '各ノードの編集
    Set colNodes = trvMaster.Nodes
    
    'オブジェクトのインスタンス作成
    Set objItemClass = CreateObject("HainsItem.Item")
    lngCount = objItemClass.SelectItemClassList(vntItemClassCd, vntItemClassName)

    'リストの編集
    For i = 0 To lngCount - 1
        colNodes.Add strNodeKey, tvwChild, strNodeKey & vntItemClassCd(i), vntItemClassName(i), ICON_CLOSED
    Next i
        
    'リストアイテムクリア
    lsvView.ListItems.Clear
    lsvView.View = lvwList
        
    '指定ノードを親にもつノードの内容を編集
    For Each objNode In colNodes
        
        Do
            '親ノードがなければ何もしない
            If objNode.Parent Is Nothing Then
                Exit Do
            End If
        
            '親ノードが指定ノードと一致しない場合は何もしない
            If objNode.Parent.Key <> strNodeKey Then
                Exit Do
            End If
       
            'リストアイテムの編集
            Set objListItem = lsvView.ListItems.Add
            With objListItem
                .Text = objNode.Text
                .Key = objNode.Key
                .SmallIcon = ICON_CLOSED
                .Tag = NODE_TYPEFOLDER        'データとしてのリストアイテムと区別する
            End With
            
            Exit Do
        Loop
    
    Next
    
    'オブジェクト廃棄
    Set objItemClass = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItemClass = Nothing
    
End Sub

'
' 機能　　 : 食品群別摂取テーブル一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromNutriFoodEnergy(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objNourishment  As Object           'サーバオブジェクトアクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    
    Dim vntEnergy       As Variant          'エネルギー
    Dim vntFoodGrp1     As Variant          '食品群１
    Dim vntFoodGrp2     As Variant          '食品群２
    Dim vntFoodGrp3     As Variant          '食品群３
    Dim vntFoodGrp4     As Variant          '食品群４
    Dim vntFoodGrp5     As Variant          '食品群５
    Dim vntFoodGrp6     As Variant          '食品群６
    Dim vntFoodGrp7     As Variant          '食品群７
    
    Dim i               As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objNourishment = CreateObject("HainsNourishment.Nourishment")
    lngCount = objNourishment.SelectNutriFoodEnergy("", vntEnergy, vntFoodGrp1, vntFoodGrp2, vntFoodGrp3, vntFoodGrp4, vntFoodGrp5, vntFoodGrp6, vntFoodGrp7)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    With objHeader
        .Add , , "エネルギー", 1000, lvwColumnLeft
        .Add , , "食品群１", 1000, lvwColumnRight
        .Add , , "食品群２", 1000, lvwColumnRight
        .Add , , "食品群３", 1000, lvwColumnRight
        .Add , , "食品群４", 1000, lvwColumnRight
        .Add , , "食品群５", 1000, lvwColumnRight
        .Add , , "食品群６", 1000, lvwColumnRight
        .Add , , "食品群７", 1000, lvwColumnRight
    End With
        
    lsvView.View = lvwReport
    
    'リストの編集
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
    
    'オブジェクト廃棄
    Set objNourishment = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNourishment = Nothing
    
End Sub

'
' 機能　　 : 構成食品テーブル一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromNutriCompFood(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objNourishment      As Object           'サーバオブジェクトアクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntComposeFoodCd    As Variant          '構成食品コード
    Dim vntComposeFoodName  As Variant          '構成食品名
    Dim vntFoodClassCd      As Variant          '食品分類
    
    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objNourishment = CreateObject("HainsNourishment.Nourishment")
    lngCount = objNourishment.SelectNutriCompFood("", vntComposeFoodCd, vntComposeFoodName, vntFoodClassCd)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    With objHeader
        .Add , , "構成食品コード", 1500, lvwColumnLeft
        .Add , , "構成食品名", 3500, lvwColumnLeft
        .Add , , "食品分類", 3500, lvwColumnLeft
    End With
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntComposeFoodCd(i), vntComposeFoodCd(i), , "DEFAULTLIST")
        objItem.Tag = strNodeKey
        objItem.SubItems(1) = vntComposeFoodName(i)
        Select Case vntFoodClassCd(i)
            Case "1"
                objItem.SubItems(2) = "1：穀類および芋類"
            Case "2"
                objItem.SubItems(2) = "2：果物"
            Case "3"
                objItem.SubItems(2) = "3：魚介・肉・卵・大豆製品"
            Case "4"
                objItem.SubItems(2) = "4：乳製品"
            Case "5"
                objItem.SubItems(2) = "5：油脂・多脂性食品"
            Case "6"
                objItem.SubItems(2) = "6：野菜"
            Case "7"
                objItem.SubItems(2) = "7：嗜好品（菓子類）"
            Case "8"
                objItem.SubItems(2) = "8：その他"
            Case "9"
                objItem.SubItems(2) = "9：嗜好品（アルコール）"
            Case Else
                objItem.SubItems(2) = "？？？(Value=" & vntFoodClassCd(i) & ")"
        End Select
    Next i
    
    'オブジェクト廃棄
    Set objNourishment = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNourishment = Nothing
    
End Sub

'
' 機能　　 : 栄養計算目標量テーブル一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromNutriTarget(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objNourishment      As Object           'サーバオブジェクトアクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntGender           As Variant          '性別
    Dim vntLowerAge         As Variant          '年齢以上
    Dim vntUpperAge         As Variant          '年齢以下
    Dim vntLowerHeight      As Variant          '身長以上
    Dim vntUpperHeight      As Variant          '身長以下
    Dim vntActStrength      As Variant          '生活活動強度
    Dim vntTotalEnergy      As Variant          '総エネルギー
    Dim vntProtein          As Variant          'たんぱく質
    Dim vntFat              As Variant          '脂質
    Dim vntCarbohydrate     As Variant          '炭水化物
    Dim vntCalcium          As Variant          'カルシウム
    Dim vntIron             As Variant          '鉄
    Dim vntCholesterol      As Variant          'コレステロール
    Dim vntSalt             As Variant          '塩分
    
    Dim i                   As Long             'インデックス
    Dim strGenderName       As String
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objNourishment = CreateObject("HainsNourishment.Nourishment")
    lngCount = objNourishment.SelectNutriTarget("", "", "", "", "", "", "", _
                                                vntGender, vntLowerAge, vntUpperAge, vntLowerHeight, vntUpperHeight, vntActStrength, vntTotalEnergy, _
                                                vntProtein, vntFat, vntCarbohydrate, vntCalcium, vntIron, vntCholesterol, vntSalt)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    With objHeader
        .Add , , "性別", 1000, lvwColumnLeft
        .Add , , "年齢以上", 1000, lvwColumnRight
        .Add , , "年齢以下", 1000, lvwColumnRight
        .Add , , "身長以上", 1000, lvwColumnRight
        .Add , , "身長以下", 1000, lvwColumnRight
        .Add , , "生活活動強度", 1000, lvwColumnRight
        .Add , , "総エネルギー", 1000, lvwColumnRight
        .Add , , "たんぱく質", 1000, lvwColumnRight
        .Add , , "脂質", 1000, lvwColumnRight
        .Add , , "炭水化物", 1000, lvwColumnRight
        .Add , , "カルシウム", 1000, lvwColumnRight
        .Add , , "鉄", 1000, lvwColumnRight
        .Add , , "コレステロール", 1000, lvwColumnRight
        .Add , , "塩分", 1000, lvwColumnRight
    End With
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        
        Select Case vntGender(i)
            Case "1"
                strGenderName = "男性"
            Case "2"
                strGenderName = "女性"
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
    
    'オブジェクト廃棄
    Set objNourishment = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNourishment = Nothing
    
End Sub

'
' 機能　　 : 栄養献立リストテーブル一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromNutriMenuList(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objNourishment      As Object           'サーバオブジェクトアクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntItemCd           As Variant          '検査項目コード
    Dim vntSuffix           As Variant          'サフィックス
    Dim vntItemName         As Variant          '項目名
    Dim vntComposeFoodCd    As Variant          '構成食品コード
    Dim vntComposeFoodName  As Variant          '構成食品名
    Dim vntFoodClassCd      As Variant          '食品分類
    Dim vntTakeAmount       As Variant          '摂取量
    Dim vntTotalEnergy      As Variant          '総エネルギー
    Dim vntProtein          As Variant          '蛋白質
    Dim vntFat              As Variant          '脂質
    Dim vntSugar            As Variant          '糖質
    Dim vntCalcium          As Variant          'カルシウム
    Dim vntIron             As Variant          '鉄
    Dim vntCholesterol      As Variant          'コレステロール
    Dim vntSalt             As Variant          '塩分
    Dim vntLowSaltFlg       As Variant          '減塩フラグ
    
    Dim i                   As Long             'インデックス
    Dim strGenderName       As String
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objNourishment = CreateObject("HainsNourishment.Nourishment")
    lngCount = objNourishment.SelectNutriMenuList("", "", "", _
                                                  vntItemCd, vntSuffix, vntItemName, vntComposeFoodCd, vntComposeFoodName, _
                                                  vntFoodClassCd, vntTakeAmount, vntTotalEnergy, vntProtein, vntFat, _
                                                  vntSugar, vntCalcium, vntIron, vntCholesterol, vntSalt, vntLowSaltFlg)
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    With objHeader
        .Add , , "検査項目コード", 1000, lvwColumnLeft
        .Add , , "サフィックス", 1200, lvwColumnLeft
        .Add , , "項目名", 2500, lvwColumnLeft
        .Add , , "構成食品コード", 1000, lvwColumnLeft
        .Add , , "構成食品名", 2500, lvwColumnLeft
        .Add , , "食品分類", 2000, lvwColumnLeft
        .Add , , "摂取量", 1000, lvwColumnLeft
        .Add , , "総エネルギー", 1000, lvwColumnRight
        .Add , , "蛋白質", 1000, lvwColumnRight
        .Add , , "脂質", 1000, lvwColumnRight
        .Add , , "糖質", 1000, lvwColumnRight
        .Add , , "カルシウム", 1000, lvwColumnRight
        .Add , , "鉄", 1000, lvwColumnRight
        .Add , , "コレステロール", 1000, lvwColumnRight
        .Add , , "塩分", 1000, lvwColumnRight
        .Add , , "減塩フラグ", 1000, lvwColumnLeft
    End With
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        
'        Select Case vntGender(i)
'            Case "1"
'                strGenderName = "男性"
'            Case "2"
'                strGenderName = "女性"
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
                    objItem.SubItems(5) = "1：穀類および芋類"
                Case "2"
                    objItem.SubItems(5) = "2：果物"
                Case "3"
                    objItem.SubItems(5) = "3：魚介・肉・卵・大豆製品"
                Case "4"
                    objItem.SubItems(5) = "4：乳製品"
                Case "5"
                    objItem.SubItems(5) = "5：油脂・多脂性食品"
                Case "6"
                    objItem.SubItems(5) = "6：野菜"
                Case "7"
                    objItem.SubItems(5) = "7：嗜好品（菓子類）"
                Case "8"
                    objItem.SubItems(5) = "8：その他"
                Case "9"
                    objItem.SubItems(5) = "9：嗜好品（アルコール）"
                Case Else
                    objItem.SubItems(5) = "？？？(Value=" & vntFoodClassCd(i) & ")"
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
                .SubItems(15) = "減塩"
            Else
                .SubItems(15) = ""
            End If
        End With
    Next i
    
    'オブジェクト廃棄
    Set objNourishment = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNourishment = Nothing
    
End Sub

'
' 機能　　 : 各種コントロールのサイズ変更
'
' 引数　　 : (In)      x  スプリッターの左側間隔
'
' 戻り値　 :
'
' 備考　　 : ツリービュー・リストビュー・スプリッター・ラベル等のサイズを変更する
'
Private Sub SizeControls(X As Single)
    
    '幅を設定します。
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

    ''上辺を設定します。
    trvMaster.Top = picTitles.Height + tlbMain.Height
    lsvView.Top = trvMaster.Top
    fraSearch.Top = trvMaster.Top - 70
    fraSearch.Left = 0
    
    ''高さを設定します。
    trvMaster.Height = Me.ScaleHeight - (picTitles.Top + picTitles.Height) - stbMain.Height
    fraSearch.Height = trvMaster.Height + 70
    
    lsvView.Height = trvMaster.Height
    imgSplitter.Top = trvMaster.Top
    imgSplitter.Height = trvMaster.Height

End Sub

'
' 機能　　 : キー値の分割
'
' 引数　　 : (In)      strTableName  テーブル名
' 　　　　   (In)      strKey        キー値
'
' 戻り値　 : キー値の配列
'
' 備考　　 :
'
Private Function SplitKey(ByVal strTableName As String, ByVal strKey As String) As Variant

    'キー値未指定時は何もしない
    If strKey = "" Then
        Exit Function
    End If
    
    'キー値を分割
    SplitKey = Split(Right(strKey, Len(strKey) - Len(strTableName)), ",")

End Function

'
' 機能　　 : 検索ボタンクリック
'
' 引数　　 : なし
'
' 戻り値　 : 条件に応じた検索結果を表示する
'
' 備考　　 :
'
Private Sub cmdSearchStart_Click()

    Dim lngCount        As Long
    Dim colNodes        As Nodes    'ノードコレクション

    Screen.MousePointer = vbHourglass
    mstrNowSearchTable = ""
    
    'SEARCHノードを選択済みにする
    trvMaster.Nodes(NODE_SEARCH).Selected = True
    
    Select Case cboTableName.ListIndex
        
        Case 0      '依頼項目テーブル
            Call EditListViewFromItem_p(TABLE_ITEM_P, "", lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_ITEM_P
        
        Case 1      '検査項目テーブル
            Call EditListViewFromItem_c(TABLE_ITEM_C, "", lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_ITEM_C
        
        Case 2      '文章テーブル
            Call EditListViewFromSentence(TABLE_SENTENCE_REC, lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_SENTENCE_REC
        
        Case 3      '定型所見テーブル
            Call EditListViewFromStdJud(TABLE_STDJUD, 0, lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_STDJUD
        
        Case 4      '判定コメントテーブル
            Call EditListViewFromJudCmtStc(TABLE_JUDCMTSTC, "", lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_JUDCMTSTC
        
        Case 5      'ユーザテーブル
            Call EditListViewFromHainsUser(TABLE_HAINSUSER, lngCount, txtSearchCode.Text, txtSearchString.Text)
            mstrNowSearchTable = TABLE_HAINSUSER
    
    End Select
    
    '件数表示
    stbMain.Panels.Item(1).Text = lngCount & " 個のレコードが見つかりました。"
    
    '画面乱れ防止
    lsvView.Refresh

    Screen.MousePointer = vbDefault
    
End Sub

Private Sub Form_Load()

    Screen.MousePointer = vbHourglass
    
    mblnComAccess = False

    'フォーム初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    With cboTableName
        .Clear
        .AddItem "依頼項目テーブル"
        .AddItem "検査項目テーブル"
        .AddItem "文章テーブル"
        .AddItem "定型所見テーブル"
        .AddItem "判定コメントテーブル"
        .AddItem "ユーザテーブル"
        .ListIndex = 0
    End With
    
    'ツリー編集
    Call EditTreeView

    'リストビュー編集表示
    Call EditListView(NODE_ROOT)
        
    'ルートアイコンはマイコンピュータ
    trvMaster.Nodes(NODE_ROOT).Image = ICON_MYCOMPUTER
    trvMaster.Nodes(NODE_SEARCH).Image = ICON_SEARCH
    
    '最大化表示
    Me.WindowState = vbMaximized
    
    'フォルダ表示モード初期化
    Call mnuViewFolder_Click
    
    Screen.MousePointer = vbDefault

End Sub

' @(e)
'
' 機能　　 : 「フォーム」Resize
'
' 機能説明 : 各種コントロールのサイズを変更する。
'
' 備考　　 :
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
' 機能　　 : 「イメージ」MouseDown
'
' 機能説明 :
'
' 備考　　 :
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
' 機能　　 : 「イメージ」MouseDown
'
' 機能説明 :
'
' 備考　　 :
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
    
    'マウスポインタが砂時計のときは入力無視
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

    Dim colNodes    As Nodes    'ノードコレクション
    Dim objNode     As Node     'ノードオブジェクト
    Dim objItem     As ListItem
    Dim Ret         As Boolean
    
    
    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then Exit Sub
    
    '指定座標にリストアイテムが存在しない場合は何もしない
    If lsvView.SelectedItem Is Nothing Then Exit Sub

    'リストビュー上での処理以外は処理終了（メニューからのOpen対応）
    If Me.ActiveControl.Name <> "lsvView" Then Exit Sub

    '処理中の表示
    Screen.MousePointer = vbHourglass

    Set objItem = lsvView.SelectedItem

    'リストビュー表示アイテムがデータならそのアイテムの更新画面表示
    If lsvView.SelectedItem.Tag <> NODE_TYPEFOLDER Then
        
        'メンテナンス画面を開く（親ノードをタグからセットするようにしないとフォルダを+で閉じられると取得できなくなる）
        Ret = ShowEditWindow(objItem.Tag, objItem.Key)
        
        'リストの再編集（フォルダモードかつメンテナンスされた場合のみ）
        If (Ret = True) And (trvMaster.Nodes(NODE_SEARCH).Selected = False) Then
            Call EditListView(objItem.Tag, objItem.Key)
        End If
        
        Screen.MousePointer = vbDefault
        Exit Sub
    
    End If
    
    If trvMaster.Nodes(NODE_SEARCH).Selected = False Then
        
        'フォルダ表示モードの場合
    
        '選択リストアイテムと同一キーのノードを取得
        Set objNode = trvMaster.Nodes(lsvView.SelectedItem.Key)
        
        'ノードを選択状態にする
        objNode.Selected = True
            
        '選択ノードのフォルダのみ開いた状態にする
        Set colNodes = trvMaster.Nodes
        For Each objNode In colNodes
            objNode.Image = IIf(objNode.Selected, ICON_OPEN, ICON_CLOSED)
        Next
            
        'リスト編集
        Call EditListView(trvMaster.SelectedItem.Key)
    
    End If
    
    '## 2005.3.23  Add by 李
    trvMaster.Nodes(NODE_SECURITY_ROOT).Image = SECURITY
    '## 2005.3.23  Add 　End..
    
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub lsvView_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = vbKeyReturn Then
        Call lsvView_DblClick
    End If
    
End Sub


Private Sub lsvView_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    '指定座標にリストアイテムが存在しない場合は何もしない
    If lsvView.HitTest(X, Y) Is Nothing Then
        Set lsvView.SelectedItem = Nothing
    End If

End Sub

Private Sub lsvView_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim objNode     As Node     'ノードオブジェクト
    
    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then Exit Sub

    '右ボタンクリック以外は何もしない
    If Button <> vbRightButton Then Exit Sub
    
    '選択中のノードオブジェクトを取得
    Set objNode = trvMaster.SelectedItem

    'ノード非選択時は処理を行わない
    If objNode Is Nothing Then
        Exit Sub
    End If

    'メニューのイネーブル制御
    
'    If trvMaster.Visible = True Then
    If trvMaster.Nodes(NODE_SEARCH).Selected = False Then
        
        'フォルダ表示モードの場合
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
        
        '検索モードの場合
        mnuPopUpNew.Enabled = True
        mnuFileNew.Enabled = True
        
        mnuPopUpUpdate.Enabled = True
        mnuFileOpen.Enabled = True
        
        mnuPopUpDelete.Enabled = True
        mnuEditDelete.Enabled = True
    End If

'#### 2013.3.4 SL-SN-Y0101-612 DEL START ####
'    'システム環境設定は削除も新規作成もできない
'    mnuPopUpNew.Visible = (objNode.Key <> TABLE_SYSPRO)
'    mnuPopUpBar1.Visible = (objNode.Key <> TABLE_SYSPRO)
'    mnuPopUpDelete.Visible = (objNode.Key <> TABLE_SYSPRO)
'    mnuPopUpBar2.Visible = (objNode.Key <> TABLE_SYSPRO)
'#### 2013.3.4 SL-SN-Y0101-612 DEL END   ####
        
    'ポップアップメニュー表示
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

    'MCH連携（病名マスタ連携）呼び出し
    Call MchByomeiCooperation

End Sub

Private Sub mnuPopUpDelete_Click()

    Dim objItem         As ListItem 'リストアイテムオブジェクト
    Dim lngRet          As Long
    Dim Ret             As Boolean
    Dim strObjNodeKey   As String
    
    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then Exit Sub
    
    '選択リストのオブジェクトを取得
    Set objItem = lsvView.SelectedItem
    
    '選択リストが存在しない場合は何もしない
    If objItem Is Nothing Then Exit Sub
    
    '選択リストがフォルダ（データではない）の場合は何もしない
    If objItem.Tag = NODE_TYPEFOLDER Then Exit Sub
    
    '最終確認
    lngRet = MsgBox("指定されたデータを削除します。よろしいですか？", vbExclamation + vbYesNo + vbDefaultButton2)
    If lngRet = vbNo Then Exit Sub
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '削除処理実行
    strObjNodeKey = objItem.Tag
    Ret = DeleteRecord(objItem.Tag, objItem.Key)
    
    'リストの再編集
    If Ret Then
'### 2003.01.28 Deleted 1Line by Ishihara@FSIT うざいから削除
'        MsgBox "指定されたデータを削除しました", vbInformation
        Call EditListView(strObjNodeKey)
    End If

    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub mnuPopUpNew_Click()

    Dim objNode As Node     'ノードオブジェクト
    Dim objItem As ListItem 'リストアイテムオブジェクト
    Dim Ret     As Boolean
    
    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then Exit Sub
    
    '選択中のノードオブジェクトを取得
    Set objNode = trvMaster.SelectedItem
    
    '選択ノードが存在しない場合は何もしない
    If objNode Is Nothing Then Exit Sub
    
    '子ノードを持つノードの場合は何もしない
    If objNode.Children > 0 Then Exit Sub
    
    If trvMaster.Nodes(NODE_SEARCH).Selected = False Then
    
        'フォルダ表示モードの場合
    
        'メンテナンス画面を開く
        Ret = ShowEditWindow(objNode.Key)
        
        'リストの再編集
        If Ret Then
            Call EditListView(objNode.Key)
        End If
    
    Else
    
        If fraSearch.Visible = True Then
            '検索モードの場合（ノードキーは退避していたものを渡す）
            Ret = ShowEditWindow(mstrNowSearchTable)
        Else
            'フォルダモードの場合、検索モードに移行する
            Call CntlViewMode(False)
        End If
    
    End If

    '処理中の解除
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

    Dim objNode     As Node     'ノードオブジェクト
    Dim strNodeKey  As String

    'ツールボタン制御
    With tlbMain
        If blnFolderMode Then
            .Buttons(BUTTON_KEY_FOLDER).Value = tbrPressed
            .Buttons(BUTTON_KEY_SEARCH).Value = tbrUnpressed
        Else
            .Buttons(BUTTON_KEY_FOLDER).Value = tbrUnpressed
            .Buttons(BUTTON_KEY_SEARCH).Value = tbrPressed
        End If
    End With

    '各モードの画面表示制御
    trvMaster.Visible = blnFolderMode
    fraSearch.Visible = Not blnFolderMode
    
    If blnFolderMode Then
        lblTitle(0).Caption = Space(1) & "フォルダ"
        mnuViewFolder.Checked = vbChecked
        mnuViewSearch.Checked = vbUnchecked
    Else
        lblTitle(0).Caption = Space(1) & "検索"
        mnuViewFolder.Checked = vbUnchecked
        mnuViewSearch.Checked = vbChecked
        
        '選択中のノードオブジェクトを取得
        Set objNode = trvMaster.SelectedItem
        
        'ノード選択時
        If objNode Is Nothing Then
        Else
            
            '選択ノードに対応したテーブルをデフォルト表示
            strNodeKey = objNode.Key
            
            '依頼項目
            If InStr(strNodeKey, TABLE_ITEM_P) > 0 Then
                cboTableName.ListIndex = 0
            End If
        
            '検査項目
            If InStr(strNodeKey, TABLE_ITEM_C) > 0 Then
                cboTableName.ListIndex = 1
            End If
        
            '文章
            If InStr(strNodeKey, "SENTENCE") > 0 Then
                cboTableName.ListIndex = 2
            End If
        
            '定型所見
            If InStr(strNodeKey, TABLE_STDJUD) > 0 Then
                cboTableName.ListIndex = 3
            End If
        
            '判定コメント
            If InStr(strNodeKey, TABLE_JUDCMTSTC) > 0 Then
                cboTableName.ListIndex = 4
            End If
        
            'ユーザ
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
    
    '現時点で選択中のノードキーを退避
    If Not trvMaster.SelectedItem Is Nothing Then
        mstrNodeKey = trvMaster.SelectedItem.Key
    End If
    
End Sub

Private Sub trvMaster_KeyUp(KeyCode As Integer, Shift As Integer)

    Dim colNodes    As Nodes    'ノードコレクション
    Dim objNode     As Node     'ノードオブジェクト
    
    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If

    'ノードコレクションの取得
    Set colNodes = trvMaster.Nodes
    
    '選択中のノードオブジェクトを取得
    Set objNode = trvMaster.SelectedItem

    'ノード非選択時は処理を行わない
    If objNode Is Nothing Then
        Exit Sub
    End If

    'KeyDown時に退避されたノードキーと現在選択中の値が一致する場合は何もしない
    If objNode.Key = mstrNodeKey Then Exit Sub
    
'    'ポップアップキー(?)が押下された場合
'    If KeyCode = 93 Then
'
'        'メニューのイネーブル制御
'        mnuPopUpNew.Enabled = (objNode.Children = 0)
'        mnuPopUpUpdate.Enabled = False
'        mnuPopUpDelete.Enabled = False
'
'        'ポップアップメニュー表示
'        PopupMenu mnuPopUp
'
'        Exit Sub
'    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass

    '選択ノードのフォルダのみ開いた状態にする
    For Each objNode In colNodes
        objNode.Image = IIf(objNode.Selected, ICON_OPEN, ICON_CLOSED)
    Next
    
    'ROOTだけはマイコンピュータアイコン
    trvMaster.Nodes(NODE_ROOT).Image = ICON_MYCOMPUTER
    
    '## 2005.3.23  Add by 李
    trvMaster.Nodes(NODE_SECURITY_ROOT).Image = SECURITY
    '## 2005.3.23  Add 　End..

    'リスト編集
    Call EditListView(trvMaster.SelectedItem.Key)

    '処理中の解除
    Screen.MousePointer = vbDefault

End Sub

Private Sub trvMaster_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

    mstrNodeKey = ""
    
    '現時点で選択中のノードキーを退避
    If Not trvMaster.SelectedItem Is Nothing Then
        mstrNodeKey = trvMaster.SelectedItem.Key
    End If

End Sub

Private Sub trvMaster_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)

    Dim colNodes    As Nodes    'ノードコレクション
    Dim objNode     As Node     'ノードオブジェクト
    
    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If

    'ノードコレクションの取得
    Set colNodes = trvMaster.Nodes
    
    'マウス選択されたノードオブジェクトを取得
    Set objNode = trvMaster.HitTest(X, Y)

    'ノード非選択時は処理を行わない
    If objNode Is Nothing Then
        Exit Sub
    End If

    '右ボタンがクリックされた場合
    If Button = vbRightButton Then
    
        'メニューのイネーブル制御
        mnuPopUpNew.Enabled = (objNode.Children = 0)
        mnuPopUpUpdate.Enabled = False
        mnuPopUpDelete.Enabled = False
        
        'ポップアップメニュー表示
        PopupMenu mnuPopUp
        
        Exit Sub
    End If

    'MouoseDown時に退避されたノードキーと現在選択中の値が一致する場合は何もしない
    If objNode.Key = mstrNodeKey Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass

    '選択ノードのフォルダのみ開いた状態にする
    For Each objNode In colNodes
        objNode.Image = IIf(objNode.Selected, ICON_OPEN, ICON_CLOSED)
    Next
    
    'ROOTだけはマイコンピュータアイコン
    trvMaster.Nodes(NODE_ROOT).Image = ICON_MYCOMPUTER
    
    '## 2005.3.23  Add by 李
    trvMaster.Nodes(NODE_SECURITY_ROOT).Image = SECURITY
    '## 2005.3.23  Add 　End..

    'リスト編集
    Call EditListView(trvMaster.SelectedItem.Key)

    '処理中の解除
    Screen.MousePointer = vbDefault

End Sub



' @(e)
'
' 機能　　 : メッセージ表示
'
' 機能説明 : COMを最初に呼出場合の待ち時間表示
'
' 備考　　 :
'
Private Sub ShowWaitMessage()

    Dim objHeader   As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem     As ListItem             'リストアイテムオブジェクト

    '一度でもCOM+にアクセスしていたらレスポンスは出るので表示不要
    If mblnComAccess = True Then Exit Sub

    With lsvView
        .View = lvwReport
    
        Set objHeader = .ColumnHeaders
        objHeader.Clear
        objHeader.Add , , "設定情報", .Width, lvwColumnLeft
        .ListItems.Clear
        Set objItem = .ListItems.Add(, "MSG", "設定情報を取得しています...")
    
    End With
    
    Me.Refresh
    mblnComAccess = True

End Sub

Private Function ShowItemGuide(strItemCd As String, _
                               strSuffix As String, _
                               Optional strClassCd As String, _
                               Optional vntResultType As Variant) As Boolean
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '項目ガイド表示用
    
    Dim lngItemCount    As Long     '選択項目数
    Dim vntItemCd       As Variant  '選択された項目コード
    Dim vntSuffix       As Variant  '選択されたサフィックス
    
    ShowItemGuide = False

    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
        .MultiSelect = False
        If IsMissing(strClassCd) = False Then .ClassCd = strClassCd
        If IsMissing(vntResultType) = False Then .ResultType = CInt(vntResultType)
    
        'コーステーブルメンテナンス画面を開く
        .Show vbModal
        
        '戻り値としてのプロパティ取得
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
    
    End With
        
    '選択件数が0件以上なら
    If lngItemCount > 0 Then
        strItemCd = vntItemCd(0)
        strSuffix = vntSuffix(0)
        ShowItemGuide = True
    End If

    Set objItemGuide = Nothing

End Function

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
'
' 機能　　 : メール送信設定表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromMailConf(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objHeader   As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem     As ListItem         'リストアイテムオブジェクト
    Dim i           As Long             'インデックス
    
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "名前", 1500, lvwColumnLeft
    objHeader.Add , , "説明", 6200, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & "1", "基本設定", , "DEFAULTLIST")
    objItem.SubItems(1) = "送信メールサーバーの設定、及び署名の登録を行います。"
    objItem.Tag = strNodeKey
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Sub

'#### 2013.3.4 SL-SN-Y0101-612 ADD START ####
'
' 機能　　 : メールテンプレート一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditListViewFromMailTemplate(strNodeKey As String, lngCount As Long)

On Error GoTo ErrorHandle

    Dim objMailTemplate     As Object           '帳票アクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntTemplateCd       As Variant          'テンプレートコード
    Dim vntTemplateName     As Variant          'テンプレート名

    Dim i                   As Long             'インデックス
    
    'COM呼出待ちメッセージ
    Call ShowWaitMessage
    
    'オブジェクトのインスタンス作成
    Set objMailTemplate = CreateObject("HainsMail.Template")
    
    lngCount = objMailTemplate.SelectMailTemplateList(vntTemplateCd, vntTemplateName)
        
    'ヘッダの編集
    lsvView.ListItems.Clear
    Set objHeader = lsvView.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コード", 750, lvwColumnLeft
    objHeader.Add , , "テンプレート名", 2000, lvwColumnLeft
        
    lsvView.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvView.ListItems.Add(, KEY_PREFIX & vntTemplateCd(i), vntTemplateCd(i), , "DEFAULTLIST")
        With objItem
            .Tag = strNodeKey
            .SubItems(1) = vntTemplateName(i)
        End With
    Next i
    
    'オブジェクト廃棄
    Set objMailTemplate = Nothing
    
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
    Set objMailTemplate = Nothing
    
End Sub
