VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmItem_h 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "コース履歴情報"
   ClientHeight    =   5775
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7635
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmItem_h.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5775
   ScaleWidth      =   7635
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin TabDlg.SSTab tabMain 
      Height          =   4575
      Left            =   180
      TabIndex        =   39
      Top             =   660
      Width           =   7335
      _ExtentX        =   12938
      _ExtentY        =   8070
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "基本情報"
      TabPicture(0)   =   "frmItem_h.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "fraBasic(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "fraBasic(1)"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).ControlCount=   2
      TabCaption(1)   =   "他システム連携関連"
      TabPicture(1)   =   "frmItem_h.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraOther(0)"
      Tab(1).Control(1)=   "fraOther(1)"
      Tab(1).Control(2)=   "Image1(0)"
      Tab(1).Control(3)=   "Label5(1)"
      Tab(1).ControlCount=   4
      Begin VB.Frame fraOther 
         Caption         =   "電子カルテシステム連携"
         Height          =   2055
         Index           =   0
         Left            =   -68880
         TabIndex        =   47
         Top             =   2220
         Visible         =   0   'False
         Width           =   1755
         Begin VB.CommandButton cmdDeleteHistory 
            Caption         =   "削除(&D)..."
            Height          =   315
            Left            =   240
            TabIndex        =   38
            Top             =   1320
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditHistory 
            Caption         =   "編集(&E)..."
            Height          =   315
            Left            =   240
            TabIndex        =   37
            Top             =   960
            Width           =   1275
         End
         Begin VB.CommandButton cmdNewHistory 
            Caption         =   "新規(&N)..."
            Height          =   315
            Left            =   240
            TabIndex        =   36
            Top             =   600
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvKarteItem 
            Height          =   615
            Left            =   180
            TabIndex        =   35
            Top             =   300
            Width           =   1155
            _ExtentX        =   2037
            _ExtentY        =   1085
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
      Begin VB.Frame fraOther 
         Caption         =   "検査システム連携"
         Height          =   3075
         Index           =   1
         Left            =   -74820
         TabIndex        =   29
         Top             =   1140
         Width           =   6975
         Begin VB.TextBox txtInsSuffix 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   4860
            MaxLength       =   2
            TabIndex        =   28
            Text            =   "@@"
            Top             =   1440
            Width           =   435
         End
         Begin VB.CheckBox chkSepOrderDiv 
            Caption         =   "通常の検査項目とはオーダを分割して送信する。(&S):"
            Height          =   195
            Left            =   2460
            TabIndex        =   25
            Top             =   900
            Visible         =   0   'False
            Width           =   4335
         End
         Begin VB.TextBox txtReqItemCd 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   2460
            MaxLength       =   17
            TabIndex        =   24
            Text            =   "@@@@@@@@@@@@@@@@@"
            Top             =   480
            Width           =   2175
         End
         Begin VB.TextBox txtinsItemCd 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   2460
            MaxLength       =   17
            TabIndex        =   27
            Text            =   "@@@@@@@@@@@@@@@@@"
            Top             =   1440
            Width           =   2175
         End
         Begin VB.Label Label8 
            Caption         =   "-"
            Height          =   195
            Index           =   17
            Left            =   4680
            TabIndex        =   49
            Top             =   1500
            Width           =   135
         End
         Begin VB.Label Label8 
            Caption         =   "検査依頼用変換コード(&Q):"
            Height          =   195
            Index           =   8
            Left            =   240
            TabIndex        =   23
            Top             =   540
            Width           =   2295
         End
         Begin VB.Label Label8 
            Caption         =   "検査結果用変換コード(&K):"
            Height          =   195
            Index           =   15
            Left            =   240
            TabIndex        =   26
            Top             =   1500
            Width           =   2295
         End
      End
      Begin VB.Frame fraBasic 
         Caption         =   "入力結果定義関連"
         Height          =   1935
         Index           =   1
         Left            =   180
         TabIndex        =   46
         Top             =   1860
         Width           =   6975
         Begin VB.TextBox txtEUnit 
            Height          =   315
            Left            =   5400
            MaxLength       =   12
            TabIndex        =   22
            Text            =   "Text1"
            Top             =   1440
            Width           =   1275
         End
         Begin VB.ComboBox cboFigure1 
            Height          =   300
            ItemData        =   "frmItem_h.frx":0044
            Left            =   1560
            List            =   "frmItem_h.frx":004B
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   8
            Top             =   300
            Width           =   555
         End
         Begin VB.ComboBox cboFigure2 
            Height          =   300
            ItemData        =   "frmItem_h.frx":0053
            Left            =   3540
            List            =   "frmItem_h.frx":005A
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   10
            Top             =   300
            Width           =   555
         End
         Begin VB.TextBox txtMaxValue 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   5400
            MaxLength       =   8
            TabIndex        =   14
            Text            =   "Text1"
            Top             =   720
            Width           =   855
         End
         Begin VB.TextBox txtMinValue 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   2040
            MaxLength       =   8
            TabIndex        =   12
            Text            =   "Text1"
            Top             =   720
            Width           =   855
         End
         Begin VB.TextBox txtDefResult 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   2040
            MaxLength       =   8
            TabIndex        =   16
            Text            =   "Text1"
            Top             =   1080
            Width           =   855
         End
         Begin VB.TextBox txtDefRslCmtCd 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   5400
            MaxLength       =   3
            TabIndex        =   18
            Text            =   "@@"
            Top             =   1080
            Visible         =   0   'False
            Width           =   495
         End
         Begin VB.TextBox txtUnit 
            Height          =   315
            Left            =   2040
            MaxLength       =   12
            TabIndex        =   20
            Text            =   "Text1"
            Top             =   1440
            Width           =   1275
         End
         Begin VB.Label Label8 
            Caption         =   "英語単位(&U):"
            Height          =   195
            Index           =   16
            Left            =   3600
            TabIndex        =   21
            Top             =   1500
            Width           =   1815
         End
         Begin VB.Label Label8 
            Caption         =   "整数部桁数(&S):"
            Height          =   195
            Index           =   9
            Left            =   240
            TabIndex        =   7
            Top             =   360
            Width           =   1215
         End
         Begin VB.Label Label8 
            Caption         =   "小数部桁数(&C):"
            Height          =   195
            Index           =   10
            Left            =   2220
            TabIndex        =   9
            Top             =   360
            Width           =   1215
         End
         Begin VB.Label Label8 
            Caption         =   "入力可能な最大値(&L):"
            Height          =   195
            Index           =   11
            Left            =   3600
            TabIndex        =   13
            Top             =   780
            Width           =   1755
         End
         Begin VB.Label Label8 
            Caption         =   "入力可能な最小値(&M):"
            Height          =   195
            Index           =   12
            Left            =   240
            TabIndex        =   11
            Top             =   780
            Width           =   1815
         End
         Begin VB.Label Label8 
            Caption         =   "省略時検査結果(&R):"
            Height          =   195
            Index           =   2
            Left            =   240
            TabIndex        =   15
            Top             =   1140
            Width           =   1815
         End
         Begin VB.Label Label8 
            Caption         =   "省略時結果コメント(&T):"
            Height          =   195
            Index           =   13
            Left            =   3600
            TabIndex        =   17
            Top             =   1140
            Visible         =   0   'False
            Width           =   1815
         End
         Begin VB.Label Label8 
            Caption         =   "単位(&U):"
            Height          =   195
            Index           =   14
            Left            =   240
            TabIndex        =   19
            Top             =   1500
            Width           =   1815
         End
      End
      Begin VB.Frame fraBasic 
         Caption         =   "基本情報"
         Height          =   1215
         Index           =   0
         Left            =   180
         TabIndex        =   41
         Top             =   480
         Width           =   6975
         Begin VB.ComboBox cboEndDay 
            Height          =   300
            ItemData        =   "frmItem_h.frx":0062
            Left            =   6000
            List            =   "frmItem_h.frx":0069
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   6
            Top             =   720
            Width           =   555
         End
         Begin VB.ComboBox cboEndMonth 
            Height          =   300
            ItemData        =   "frmItem_h.frx":0071
            Left            =   5100
            List            =   "frmItem_h.frx":0078
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   5
            Top             =   720
            Width           =   555
         End
         Begin VB.ComboBox cboEndYear 
            Height          =   300
            ItemData        =   "frmItem_h.frx":0080
            Left            =   4080
            List            =   "frmItem_h.frx":0087
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   4
            Top             =   720
            Width           =   735
         End
         Begin VB.ComboBox cboStrDay 
            Height          =   300
            ItemData        =   "frmItem_h.frx":0091
            Left            =   3060
            List            =   "frmItem_h.frx":0098
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   3
            Top             =   720
            Width           =   555
         End
         Begin VB.ComboBox cboStrMonth 
            Height          =   300
            ItemData        =   "frmItem_h.frx":00A0
            Left            =   2220
            List            =   "frmItem_h.frx":00A7
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   2
            Top             =   720
            Width           =   555
         End
         Begin VB.ComboBox cboStrYear 
            Height          =   300
            ItemData        =   "frmItem_h.frx":00AF
            Left            =   1260
            List            =   "frmItem_h.frx":00B6
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   1
            Top             =   720
            Width           =   735
         End
         Begin VB.Label Label8 
            Caption         =   "日"
            Height          =   255
            Index           =   7
            Left            =   6600
            TabIndex        =   45
            Top             =   780
            Width           =   255
         End
         Begin VB.Label Label8 
            Caption         =   "月"
            Height          =   255
            Index           =   6
            Left            =   5700
            TabIndex        =   34
            Top             =   780
            Width           =   255
         End
         Begin VB.Label Label8 
            Caption         =   "年"
            Height          =   255
            Index           =   5
            Left            =   4860
            TabIndex        =   33
            Top             =   780
            Width           =   255
         End
         Begin VB.Label Label8 
            Caption         =   "日～"
            Height          =   255
            Index           =   3
            Left            =   3660
            TabIndex        =   32
            Top             =   780
            Width           =   435
         End
         Begin VB.Label Label8 
            Caption         =   "月"
            Height          =   255
            Index           =   1
            Left            =   2820
            TabIndex        =   44
            Top             =   780
            Width           =   255
         End
         Begin VB.Label Label8 
            Caption         =   "年"
            Height          =   255
            Index           =   0
            Left            =   2040
            TabIndex        =   43
            Top             =   780
            Width           =   255
         End
         Begin VB.Label Label8 
            Caption         =   "有効期間(&I):"
            Height          =   195
            Index           =   4
            Left            =   180
            TabIndex        =   0
            Top             =   780
            Width           =   1095
         End
         Begin VB.Label lblItemInfo 
            Caption         =   "010100-01：尿ＰＨ"
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
            Left            =   240
            TabIndex        =   42
            Top             =   360
            Width           =   4515
         End
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   0
         Left            =   -74760
         Picture         =   "frmItem_h.frx":00C0
         Top             =   540
         Width           =   480
      End
      Begin VB.Label Label5 
         Caption         =   "他システムとの連携に必要な情報を設定します。"
         Height          =   255
         Index           =   1
         Left            =   -74160
         TabIndex        =   48
         Top             =   660
         Width           =   4275
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4860
      TabIndex        =   30
      Top             =   5340
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   6240
      TabIndex        =   31
      Top             =   5340
      Width           =   1275
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   240
      Top             =   5100
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
            Picture         =   "frmItem_h.frx":0502
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_h.frx":0954
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_h.frx":0DA6
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_h.frx":0F00
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   4
      Left            =   180
      Picture         =   "frmItem_h.frx":105A
      Top             =   120
      Width           =   480
   End
   Begin VB.Label Label5 
      Caption         =   "履歴で管理する情報を設定します。"
      Height          =   255
      Index           =   0
      Left            =   780
      TabIndex        =   40
      Top             =   240
      Width           =   4275
   End
End
Attribute VB_Name = "frmItem_h"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd          As String   '検査項目コード
Private mstrSuffix          As String   'サフィックス

Private mstrItemInfo        As String   '表示用検査項目情報（表示のみ）
Private mintResultType      As Integer  '項目タイプ

Private mstrItemHNo         As String   '検査項目履歴番号(新規作成時を考慮しStringでとる）
Private mstrStrDate         As String   '開始日付
Private mstrEndDate         As String   '終了日付
Private mintFigure1         As Integer  '整数部桁数
Private mintFigure2         As Integer  '小数部桁数
Private mstrMaxValue        As String   '最大値
Private mstrMinValue        As String   '最小値
Private mstrInsItemCd       As String   '検査用項目コード
Private mstrUnit            As String   '単位
Private mstrDefResult       As String   '省略時検査結果
Private mstrDefRslCmtCd     As String   '省略時結果コメントコード
Private mstrReqItemCd       As String   '依頼項目コード
Private mstrSepOrderDiv     As String   'オーダ分割区分

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
Private mstrInsSuffix       As String   '検査用サフィックス
Private mstreUnit           As String   '英語単位
'### 2004/1/15 Added End

Const mstrColKeyPrefix      As String = "K"
Private mintKarteColKey     As Integer      'リストビューキーをユニークにするためのIndex（カルテ用）

Private mcolKarteItem       As Collection   '電子カルテ項目コード変換用データ格納用コレクション

Private mlngPrice           As Long     '検査項目基本料金
Private mblnUpdate          As Boolean  'TRUE:更新しました、FALSE:未更新

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Friend Property Get ReqItemCd() As Variant

    ReqItemCd = mstrReqItemCd

End Property
Friend Property Let ReqItemCd(ByVal vNewValue As Variant)

    mstrReqItemCd = vNewValue
    
End Property

Friend Property Get SepOrderDiv() As Variant

    SepOrderDiv = mstrSepOrderDiv

End Property
Friend Property Let SepOrderDiv(ByVal vNewValue As Variant)

    mstrSepOrderDiv = vNewValue
    
End Property

Friend Property Get strDate() As Variant

    strDate = mstrStrDate

End Property
Friend Property Let strDate(ByVal vNewValue As Variant)

    mstrStrDate = vNewValue
    
End Property

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
Friend Property Get InsSuffix() As Variant

    InsSuffix = mstrInsSuffix

End Property
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
Friend Property Let InsSuffix(ByVal vNewValue As Variant)

    mstrInsSuffix = vNewValue
    
End Property

'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
Friend Property Get eUnit() As Variant

    eUnit = mstreUnit

End Property
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
Friend Property Let eUnit(ByVal vNewValue As Variant)

    mstreUnit = vNewValue
    
End Property

Friend Property Get endDate() As Variant

    endDate = mstrEndDate

End Property

Friend Property Let endDate(ByVal vNewValue As Variant)

    mstrEndDate = vNewValue

End Property

' @(e)
'
' 機能　　 : 電カル項目編集ウインドウ表示
'
' 引数　　 : (In)      modeNew  TRUE:新規モード、FALSE:更新モード
'
' 機能説明 :
'
' 備考　　 :
'
Private Sub ShowKarteItem(modeNew As Boolean)
    
    Dim objKarteItem        As KarteItem
    Dim objListItem         As ListItem
    
    '更新モードの場合、値セット
    If modeNew = False Then

        '選択中のノードオブジェクトを取得
        Set objListItem = lsvKarteItem.SelectedItem
    
        'ノード非選択時は処理を行わない
        If objListItem Is Nothing Then
            Exit Sub
        End If
        
        With frmEditKarteItem
            .KarteDocCd = mcolKarteItem(objListItem.Key).KarteDocCd
            .KarteItemAttr = mcolKarteItem(objListItem.Key).KarteItemAttr
            .KarteItemcd = mcolKarteItem(objListItem.Key).KarteItemcd
            .KarteItemName = mcolKarteItem(objListItem.Key).KarteItemName
            .KarteTagName = mcolKarteItem(objListItem.Key).KarteTagName
        End With
    
    End If
        
    With frmEditKarteItem
        .Show vbModal
    
        'データを更新されたら、画面データ再編集
        If .Updated = True Then
            
            If modeNew = True Then
                '新規モードの場合
                
                '重複チェックがOKなら追加
                If CheckDuplicateError(.KarteDocCd, .KarteItemAttr, .KarteItemcd) = True Then
                
                    '履歴オブジェクト（コレクション）の作成
                    Set objKarteItem = New KarteItem
                    objKarteItem.ItemHNo = mstrItemHNo
                    objKarteItem.KarteDocCd = .KarteDocCd
                    objKarteItem.KarteItemAttr = .KarteItemAttr
                    objKarteItem.KarteItemcd = .KarteItemcd
                    objKarteItem.KarteItemName = .KarteItemName
                    objKarteItem.KarteTagName = .KarteTagName
                    objKarteItem.UniqueKey = mstrColKeyPrefix & mintKarteColKey
                    
                    mcolKarteItem.Add objKarteItem, mstrColKeyPrefix & mintKarteColKey
                    mintKarteColKey = mintKarteColKey + 1
                    
                    Set objListItem = lsvKarteItem.ListItems.Add(, objKarteItem.UniqueKey, objKarteItem.KarteDocCd, , "DEFAULTLIST")
                    objListItem.SubItems(1) = objKarteItem.KarteItemAttr
                    objListItem.SubItems(2) = objKarteItem.KarteItemcd
                    objListItem.SubItems(3) = objKarteItem.KarteItemName
                    objListItem.SubItems(4) = objKarteItem.KarteTagName
                    
                    Set objKarteItem = Nothing
                End If
            
            Else
                
                '更新モードの場合
                objListItem.Text = .KarteDocCd
                objListItem.SubItems(1) = .KarteItemAttr
                objListItem.SubItems(2) = .KarteItemcd
                objListItem.SubItems(3) = .KarteItemName
                objListItem.SubItems(4) = .KarteTagName
            
                mcolKarteItem(objListItem.Key).KarteDocCd = .KarteDocCd
                mcolKarteItem(objListItem.Key).KarteItemAttr = .KarteItemAttr
                mcolKarteItem(objListItem.Key).KarteItemcd = .KarteItemcd
                mcolKarteItem(objListItem.Key).KarteItemName = .KarteItemName
                mcolKarteItem(objListItem.Key).KarteTagName = .KarteTagName
            
            End If

        End If
        
    End With

    Set frmEditKarteItem = Nothing

End Sub

' @(e)
'
' 機能　　 : 電カル項目重複チェック
'
' 引数　　 : (In)      modeNew  TRUE:新規モード、FALSE:更新モード
'
' 戻り値　 : TRUE:重複なし、FALSE:重複あり
'
' 機能説明 :
'
' 備考　　 :
'
Private Function CheckDuplicateError(ByVal strKarteDocCd As String, _
                                     ByVal strKarteItemAttr As String, _
                                     ByVal strKarteItemcd As String _
                                     ) As Boolean

    Dim objListItem         As ListItem
    Dim blnError            As Boolean

    CheckDuplicateError = False
    
    blnError = False
    
    For Each objListItem In lsvKarteItem.ListItems
        
        With objListItem
            
            '存在チェック
            If (.Text = strKarteDocCd) And _
               (.SubItems(1) = strKarteItemAttr) And _
               (.SubItems(2) = strKarteItemcd) Then
                blnError = True
            End If
            
            'エラーが存在したなら処理終了
            If blnError = True Then
                MsgBox "入力されたコードは既に存在します。", vbExclamation, App.Title
                Exit For
            End If
            
        End With
        
    Next objListItem
    
    If blnError = False Then
        CheckDuplicateError = True
        Exit Function
    End If
    
End Function

Private Sub cmdDeleteHistory_Click()

    Dim objListItem             As ListItem

    '選択中のノードオブジェクトを取得
    Set objListItem = lsvKarteItem.SelectedItem

    'ノード非選択時は処理を行わない
    If objListItem Is Nothing Then
        Exit Sub
    End If

    lsvKarteItem.ListItems.Remove objListItem.Key
    mcolKarteItem.Remove objListItem.Key

End Sub

Private Sub cmdEditHistory_Click()

    Call ShowKarteItem(False)

End Sub

Private Sub cmdNewHistory_Click()

    Call ShowKarteItem(True)

End Sub

Private Sub cmdOk_Click()

    'データ適用処理を行う（エラー時は画面を閉じない）
    If ApplyData() = False Then
        Exit Sub
    End If

    '画面を閉じる
    Unload Me
    
End Sub

Private Sub Form_Load()

    Dim i As Integer
    
    mblnUpdate = False
    
    '表示用フォーム初期化
    Call InitializeForm

    'データセット
    Call EditItemHistory
    
    '結果タイプ毎のデフォルトセッティング
    Call SetDefaultSetting
    
    tabMain.Tab = 0
    Call tabMain_Click(0)
    
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
        
        '更新済みフラグ成立
        mblnUpdate = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Function
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
    Dim strStrDate      As String
    Dim strEndDate      As String
    Dim strWorkDate     As String
    Dim strSepOrderDiv  As String
    
    '初期処理
    Ret = False
    
    Do

        '最小値チェック
        If (Trim(txtMinValue.Text) <> "") And (IsNumeric(Trim(txtMinValue.Text)) = False) Then
            tabMain.Tab = 0
            MsgBox "入力可能な最小値には数値を入力してください", vbExclamation, App.Title
            txtMinValue.SetFocus
            Exit Do
        End If

        '最大値チェック
        If (Trim(txtMaxValue.Text) <> "") And (IsNumeric(Trim(txtMaxValue.Text)) = False) Then
            tabMain.Tab = 0
            MsgBox "入力可能な最大値には数値を入力してください", vbExclamation, App.Title
            txtMaxValue.SetFocus
            Exit Do
        End If

        '桁数の制限チェック（両方０）
        If (cboFigure1.ListIndex = 0) And (cboFigure2.ListIndex = 0) Then
            tabMain.Tab = 0
            MsgBox "整数部、小数部両方の桁数を０に指定することはできません。", vbExclamation, App.Title
            cboFigure1.SetFocus
            Exit Do
        End If
        
        '桁数の制限チェック
        If cboFigure2.ListIndex > 0 Then
            '整数部＋小数部＋ピリオド分の桁数が８桁を超えるならエラー
            If (cboFigure1.ListIndex + cboFigure2.ListIndex + 1) > 8 Then
                tabMain.Tab = 0
                MsgBox "検査結果格納領域は８桁です。ご指定の桁数は格納することができません", vbExclamation, App.Title
                cboFigure1.SetFocus
                Exit Do
            End If
        End If
        
        strStrDate = cboStrYear.List(cboStrYear.ListIndex) & "/" & _
                     Format(cboStrMonth.List(cboStrMonth.ListIndex), "00") & "/" & _
                     Format(cboStrDay.List(cboStrDay.ListIndex), "00")

        strEndDate = cboEndYear.List(cboEndYear.ListIndex) & "/" & _
                     Format(cboEndMonth.List(cboEndMonth.ListIndex), "00") & "/" & _
                     Format(cboEndDay.List(cboEndDay.ListIndex), "00")

        '日付整合性のチェック
        If IsDate(strStrDate) = False Then
            tabMain.Tab = 0
            MsgBox "正しい開始日付を入力してください", vbExclamation, App.Title
            cboStrYear.SetFocus
            Exit Do
        End If
        
        If IsDate(strEndDate) = False Then
            tabMain.Tab = 0
            MsgBox "正しい終了日付を入力してください", vbExclamation, App.Title
            cboEndYear.SetFocus
            Exit Do
        End If
        
        '日付の大小チェック
        If CDate(strStrDate) > CDate(strEndDate) Then
            
            If MsgBox("開始終了日付が逆転しています。入れ替えて保存しますか？", vbYesNo + vbQuestion) = vbNo Then
                tabMain.Tab = 0
                cboStrYear.SetFocus
                Exit Do
            Else
                '開始終了日付の再セット
                cboStrYear.ListIndex = CLng(Mid(strEndDate, 1, 4)) - YEARRANGE_MIN
                cboStrMonth.ListIndex = CLng(Mid(strEndDate, 6, 2)) - 1
                cboStrDay.ListIndex = CLng(Mid(strEndDate, 9, 2)) - 1
            
                cboEndYear.ListIndex = CLng(Mid(strStrDate, 1, 4)) - YEARRANGE_MIN
                cboEndMonth.ListIndex = CLng(Mid(strStrDate, 6, 2)) - 1
                cboEndDay.ListIndex = CLng(Mid(strStrDate, 9, 2)) - 1
                
                strWorkDate = strStrDate
                strStrDate = strEndDate
                strEndDate = strWorkDate
            
            End If
        
        End If
        
        '検査用項目コードのチェック
        txtinsItemCd.Text = Trim(txtinsItemCd.Text)
        
        '依頼変換がないのに、オーダ分割ありはなし。
        If (Trim(txtReqItemCd.Text) = "") And (chkSepOrderDiv.Value = vbChecked) Then
            chkSepOrderDiv.Value = vbUnchecked
        End If
        
        'オーダ分割区分を変数にセットする
        strSepOrderDiv = ""
        If chkSepOrderDiv.Value = vbChecked Then
            strSepOrderDiv = "1"
        Else
            If Trim(txtReqItemCd.Text) <> "" Then
                strSepOrderDiv = "0"
            End If
        End If
        
        '検査連携用コードのチェック
        If GetInsItemInfo(mstrItemCd, mstrSuffix, txtinsItemCd.Text, strSepOrderDiv) = False Then
            tabMain.Tab = 1
            txtinsItemCd.SetFocus
            Exit Do
        End If
        
        'プロパティ用に更新値をセット
        mstrStrDate = strStrDate
        mstrEndDate = strEndDate
        mintFigure1 = cboFigure1.ListIndex
        mintFigure2 = cboFigure2.ListIndex
        mstrMaxValue = txtMaxValue.Text
        mstrMinValue = txtMinValue.Text
        mstrInsItemCd = txtinsItemCd.Text
        mstrUnit = txtUnit.Text
        mstrDefResult = txtDefResult.Text
        mstrDefRslCmtCd = txtDefRslCmtCd.Text
        mstrReqItemCd = Trim(txtReqItemCd.Text)
        mstrSepOrderDiv = ""
        If chkSepOrderDiv = vbChecked Then
            mstrSepOrderDiv = "1"
        Else
            If Trim(txtReqItemCd.Text) <> "" Then
                mstrSepOrderDiv = "0"
            End If
        End If
        
'### 2004/1/15 Added by Ishihara@FSIT 聖路加項目の追加
        mstrInsSuffix = txtInsSuffix.Text
        mstreUnit = txtEUnit.Text
'### 2004/1/15 Added End
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

Private Sub InitializeForm()
    
    Dim i As Integer
    
    'コントロール初期化
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    'コンボボックスに値をセット
    For i = YEARRANGE_MIN To YEARRANGE_MAX
        cboStrYear.AddItem i
        cboEndYear.AddItem i
    Next i
    
    For i = 1 To 12
        cboStrMonth.AddItem i
        cboEndMonth.AddItem i
    Next i
    
    For i = 1 To 31
        cboStrDay.AddItem i
        cboEndDay.AddItem i
    Next i
    
    For i = 0 To 8
        cboFigure1.AddItem i
        cboFigure1.ListIndex = cboFigure1.NewIndex
    Next i
    
    For i = 0 To 6
        cboFigure2.AddItem i
        cboFigure2.ListIndex = 0
    Next i
    
    '更新モード時の日付をセットされている場合、デフォルトセット
    If Trim(mstrStrDate) <> "" Then
'        cboStrYear.ListIndex = CLng(Mid(mstrStrDate, 1, 4)) - YEARRANGE_MIN
        If (CLng(Mid(mstrStrDate, 1, 4)) - YEARRANGE_MIN) >= 0 Then
            cboStrYear.ListIndex = CLng(Mid(mstrStrDate, 1, 4)) - YEARRANGE_MIN
        Else
            cboStrYear.ListIndex = 0
        End If
        cboStrMonth.ListIndex = CLng(Mid(mstrStrDate, 6, 2)) - 1
        cboStrDay.ListIndex = CLng(Mid(mstrStrDate, 9, 2)) - 1
    Else
        cboStrYear.ListIndex = 0
        cboStrMonth.ListIndex = 0
        cboStrDay.ListIndex = 0
    End If

    '更新モード時の日付をセットされている場合、デフォルトセット
    If Trim(mstrEndDate) <> "" Then
'        cboEndYear.ListIndex = CLng(Mid(mstrEndDate, 1, 4)) - YEARRANGE_MIN
        If (CLng(Mid(mstrEndDate, 1, 4)) - YEARRANGE_MIN) >= 0 Then
            cboEndYear.ListIndex = CLng(Mid(mstrEndDate, 1, 4)) - YEARRANGE_MIN
        Else
            cboEndYear.ListIndex = 0
        End If
        cboEndMonth.ListIndex = CLng(Mid(mstrEndDate, 6, 2)) - 1
        cboEndDay.ListIndex = CLng(Mid(mstrEndDate, 9, 2)) - 1
    Else
        cboEndYear.ListIndex = cboEndYear.ListCount - 1
        cboEndMonth.ListIndex = cboEndMonth.ListCount - 1
        cboEndDay.ListIndex = cboEndDay.ListCount - 1
    End If

End Sub

Friend Property Get Updated() As Variant

    Updated = mblnUpdate
    
End Property


Friend Property Get Figure1() As Variant

    Figure1 = mintFigure1

End Property

Friend Property Let Figure1(ByVal vNewValue As Variant)

    mintFigure1 = vNewValue

End Property

Friend Property Get Figure2() As Variant

    Figure2 = mintFigure2

End Property

Friend Property Let Figure2(ByVal vNewValue As Variant)

    mintFigure2 = vNewValue
    
End Property

Friend Property Get MaxValue() As Variant

    MaxValue = mstrMaxValue
    
End Property

Friend Property Let MaxValue(ByVal vNewValue As Variant)

    mstrMaxValue = vNewValue

End Property

Friend Property Get MinValue() As Variant

    MinValue = mstrMinValue
    
End Property

Friend Property Let MinValue(ByVal vNewValue As Variant)

    mstrMinValue = vNewValue

End Property

Friend Property Get InsItemCd() As Variant

    InsItemCd = mstrInsItemCd

End Property

Friend Property Let InsItemCd(ByVal vNewValue As Variant)

    mstrInsItemCd = vNewValue

End Property

Friend Property Get Unit() As Variant

    Unit = mstrUnit
    
End Property

Friend Property Let Unit(ByVal vNewValue As Variant)

    mstrUnit = vNewValue

End Property

Friend Property Get DefResult() As Variant

    DefResult = mstrDefResult
    
End Property

Friend Property Let DefResult(ByVal vNewValue As Variant)

    mstrDefResult = vNewValue

End Property

Friend Property Get DefRslCmtCd() As Variant

    DefRslCmtCd = mstrDefRslCmtCd
    
End Property

Friend Property Let DefRslCmtCd(ByVal vNewValue As Variant)

    mstrDefRslCmtCd = vNewValue

End Property

Private Sub EditItemHistory()

    Dim objKarteItem        As KarteItem        '電カル変換用データ格納用オブジェクト
    Dim objItem             As ListItem

    '履歴データのセット
    cboFigure1.ListIndex = mintFigure1
    cboFigure2.ListIndex = mintFigure2

    txtMaxValue.Text = mstrMaxValue
    txtMinValue.Text = mstrMinValue
    txtinsItemCd.Text = mstrInsItemCd
    txtUnit.Text = mstrUnit
    txtDefResult.Text = mstrDefResult
    txtDefRslCmtCd.Text = mstrDefRslCmtCd
    
    txtReqItemCd = mstrReqItemCd
    If mstrSepOrderDiv = "1" Then chkSepOrderDiv.Value = vbChecked
    
    txtInsSuffix.Text = mstrInsSuffix
    txtEUnit.Text = mstreUnit
    
    '電カル変換項目リストビュー設定
    lsvKarteItem.ListItems.Clear
    
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
'        If objKarteItem.ItemHNo = mstrItemHNo Then
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

Friend Property Get ResultType() As Integer

    ResultType = mintResultType

End Property

Friend Property Let ResultType(ByVal vNewValue As Integer)

    mintResultType = vNewValue

End Property

Private Sub SetDefaultSetting()

    If (mintResultType = RESULTTYPE_TEISEI1) Or _
       (mintResultType = RESULTTYPE_TEISEI2) Or _
       (mintResultType = RESULTTYPE_SENTENCE) Then
            
        cboFigure1.ListIndex = 8
        cboFigure2.ListIndex = 0
        cboFigure1.Enabled = False
        cboFigure2.Enabled = False
        
        txtMinValue.Enabled = False
        txtMaxValue.Enabled = False
        txtMinValue.Text = ""
        txtMaxValue.Text = ""
    
    End If
    
    If mintResultType = RESULTTYPE_DATE Then
        cboFigure2.ListIndex = 0
        cboFigure2.Enabled = False
    End If
    
End Sub

Friend Property Get ItemInfo() As String

    ItemInfo = mstrItemInfo

End Property

Friend Property Let ItemInfo(ByVal vNewValue As String)

    mstrItemInfo = vNewValue

End Property

Friend Property Get KarteItem() As Collection

    Set KarteItem = mcolKarteItem

End Property

Friend Property Let KarteItem(ByVal vNewValue As Collection)

    Dim objKarteItem As KarteItem
    
    'コレクション再セットを行わないと参照渡しになる
    Set mcolKarteItem = New Collection
    
    For Each objKarteItem In vNewValue
        mcolKarteItem.Add objKarteItem, objKarteItem.UniqueKey
        Set objKarteItem = Nothing
    Next objKarteItem

End Property

Friend Property Get ItemHNo() As String

    ItemHNo = mstrItemHNo

End Property

Friend Property Let ItemHNo(ByVal vNewValue As String)

    mstrItemHNo = vNewValue

End Property

Friend Property Get KarteColKey() As Integer

    KarteColKey = mintKarteColKey
    
End Property

Friend Property Let KarteColKey(ByVal vNewValue As Integer)

    mintKarteColKey = vNewValue

End Property

Private Sub lsvKarteItem_DblClick()
    
    Call ShowKarteItem(False)

End Sub

Private Sub tabMain_Click(PreviousTab As Integer)

    Dim i               As Integer
    Dim blnNowMode      As Boolean
    
    blnNowMode = (tabMain.Tab = 0)
    
    For i = 0 To 1
        fraBasic(i).Enabled = blnNowMode
        fraOther(i).Enabled = Not blnNowMode
    Next i
    
End Sub

Friend Property Let ItemCd(ByVal vNewValue As String)

    mstrItemCd = vNewValue
    
End Property

Friend Property Let Suffix(ByVal vNewValue As String)
    
    mstrSuffix = vNewValue

End Property

