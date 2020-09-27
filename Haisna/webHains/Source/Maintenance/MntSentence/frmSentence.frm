VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmSentence 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "文章テーブルメンテナンス"
   ClientHeight    =   7710
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7485
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmSentence.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7710
   ScaleWidth      =   7485
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4560
      TabIndex        =   29
      Top             =   7260
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   6000
      TabIndex        =   30
      Top             =   7260
      Width           =   1335
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   7095
      Left            =   60
      TabIndex        =   31
      Top             =   60
      Width           =   7305
      _ExtentX        =   12885
      _ExtentY        =   12515
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "メイン"
      TabPicture(0)   =   "frmSentence.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Frame2"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Frame1"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).ControlCount=   2
      TabCaption(1)   =   "表示制御"
      TabPicture(1)   =   "frmSentence.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Frame4"
      Tab(1).Control(1)=   "Frame3"
      Tab(1).ControlCount=   2
      Begin VB.Frame Frame4 
         Caption         =   "報告書用文章"
         Height          =   1875
         Left            =   -74880
         TabIndex        =   18
         Top             =   540
         Width           =   6975
         Begin VB.TextBox txtReptStc 
            Height          =   900
            IMEMode         =   4  '全角ひらがな
            Left            =   1920
            MaxLength       =   200
            TabIndex        =   17
            Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
            Top             =   420
            Width           =   4875
         End
         Begin VB.Label Label1 
            Caption         =   "報告書用文章(&P)："
            Height          =   180
            Index           =   11
            Left            =   180
            TabIndex        =   16
            Top             =   480
            Width           =   1590
         End
      End
      Begin VB.Frame Frame3 
         Caption         =   "表示用制御"
         Height          =   2955
         Left            =   -74880
         TabIndex        =   19
         Top             =   2520
         Width           =   6975
         Begin VB.TextBox txtImageFileName 
            Height          =   300
            IMEMode         =   3  'ｵﾌ固定
            Left            =   2640
            MaxLength       =   30
            TabIndex        =   28
            Text            =   "hogehoge.gif"
            Top             =   2220
            Width           =   3435
         End
         Begin VB.CheckBox chkDelFlg 
            Caption         =   "この文章は結果入力ガイドに表示しない(&D):"
            Height          =   255
            Left            =   360
            TabIndex        =   20
            Top             =   420
            Width           =   4095
         End
         Begin VB.TextBox txtQuestionRank 
            Height          =   300
            IMEMode         =   3  'ｵﾌ固定
            Left            =   2640
            MaxLength       =   1
            TabIndex        =   26
            Text            =   "@"
            Top             =   1620
            Width           =   315
         End
         Begin VB.TextBox txtPrintOrder 
            Height          =   300
            IMEMode         =   3  'ｵﾌ固定
            Left            =   2640
            MaxLength       =   5
            TabIndex        =   24
            Text            =   "@@@@@"
            Top             =   1260
            Width           =   735
         End
         Begin VB.TextBox txtViewOrder 
            Height          =   300
            IMEMode         =   3  'ｵﾌ固定
            Left            =   2640
            MaxLength       =   5
            TabIndex        =   22
            Text            =   "@@@@@"
            Top             =   900
            Width           =   735
         End
         Begin VB.Label Label1 
            Caption         =   "文章対応イメージファイル名(&I):"
            Height          =   180
            Index           =   10
            Left            =   360
            TabIndex        =   27
            Top             =   2280
            Width           =   2730
         End
         Begin VB.Label Label1 
            Caption         =   "面接支援問診表示ランク(&Q):"
            Height          =   180
            Index           =   9
            Left            =   360
            TabIndex        =   25
            Top             =   1680
            Width           =   2250
         End
         Begin VB.Label Label1 
            Caption         =   "成績書出力順(&R):"
            Height          =   180
            Index           =   8
            Left            =   360
            TabIndex        =   23
            Top             =   1320
            Width           =   1470
         End
         Begin VB.Label Label1 
            Caption         =   "ガイド表示順番(&G):"
            Height          =   180
            Index           =   7
            Left            =   360
            TabIndex        =   21
            Top             =   960
            Width           =   1470
         End
      End
      Begin VB.Frame Frame1 
         Caption         =   "コード"
         Height          =   3015
         Left            =   120
         TabIndex        =   32
         Top             =   360
         Width           =   7035
         Begin VB.CommandButton cmdItemGuide 
            Caption         =   "検査項目コード(&C)"
            Height          =   315
            Left            =   180
            TabIndex        =   0
            Top             =   360
            Width           =   1635
         End
         Begin VB.ComboBox cboItemType 
            Height          =   300
            ItemData        =   "frmSentence.frx":0044
            Left            =   1380
            List            =   "frmSentence.frx":0066
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   2
            Top             =   1020
            Width           =   3750
         End
         Begin VB.TextBox txtStcCd 
            Height          =   300
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1380
            MaxLength       =   8
            TabIndex        =   4
            Text            =   "@@@@@@@@"
            Top             =   1380
            Width           =   1095
         End
         Begin VB.ComboBox cboStcClass 
            Height          =   300
            ItemData        =   "frmSentence.frx":0088
            Left            =   1380
            List            =   "frmSentence.frx":00AA
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   6
            Top             =   1740
            Width           =   3750
         End
         Begin VB.Label lblstcItem 
            Caption         =   "（この項目は、001230：尿ＰＨ＠＠＠＠＠の文章を参照しています）"
            Height          =   675
            Left            =   1380
            TabIndex        =   36
            Top             =   2220
            Width           =   5535
         End
         Begin VB.Label lblItemName 
            Caption         =   "お酒飲みます。そう、飲みます"
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
            Left            =   2760
            TabIndex        =   35
            Top             =   420
            Width           =   2775
         End
         Begin VB.Label lblItemCd 
            Caption         =   "000120"
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
            Left            =   1920
            TabIndex        =   34
            Top             =   420
            Width           =   735
         End
         Begin VB.Label Label1 
            Caption         =   "項目タイプ(&T):"
            Height          =   180
            Index           =   3
            Left            =   240
            TabIndex        =   1
            Top             =   1080
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "文章コード(&B):"
            Height          =   180
            Index           =   0
            Left            =   240
            TabIndex        =   3
            Top             =   1440
            Width           =   1410
         End
         Begin VB.Image imgWarning 
            Height          =   480
            Left            =   780
            Picture         =   "frmSentence.frx":00CC
            Top             =   2160
            Visible         =   0   'False
            Width           =   480
         End
         Begin VB.Label lblItemDetail 
            Caption         =   "（検査項目　123456-02：尿PHPHPHPHPH）"
            Height          =   195
            Left            =   1920
            TabIndex        =   33
            Top             =   660
            Width           =   4455
         End
         Begin VB.Label Label1 
            Caption         =   "文章分類(&S):"
            Height          =   180
            Index           =   2
            Left            =   240
            TabIndex        =   5
            Top             =   1800
            Width           =   1410
         End
      End
      Begin VB.Frame Frame2 
         Caption         =   "文章設定情報"
         Height          =   3495
         Left            =   120
         TabIndex        =   15
         Top             =   3420
         Width           =   7035
         Begin VB.TextBox txtEngStc 
            Height          =   1140
            IMEMode         =   2  'ｵﾌ
            Left            =   1380
            MaxLength       =   200
            TabIndex        =   12
            Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
            Top             =   1680
            Width           =   5535
         End
         Begin VB.TextBox txtLongStc 
            Height          =   900
            IMEMode         =   4  '全角ひらがな
            Left            =   1380
            MaxLength       =   200
            TabIndex        =   10
            Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
            Top             =   720
            Width           =   5535
         End
         Begin VB.TextBox txtShortStc 
            Height          =   300
            IMEMode         =   4  '全角ひらがな
            Left            =   1380
            MaxLength       =   50
            TabIndex        =   8
            Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
            Top             =   360
            Width           =   5535
         End
         Begin VB.TextBox txtInsStc 
            Height          =   300
            IMEMode         =   4  '全角ひらがな
            Left            =   2160
            MaxLength       =   16
            TabIndex        =   14
            Text            =   "＠＠＠＠＠＠＠＠"
            Top             =   2940
            Width           =   4695
         End
         Begin VB.Label Label1 
            Caption         =   "英語文章(&E)"
            Height          =   180
            Index           =   5
            Left            =   180
            TabIndex        =   11
            Top             =   1740
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "正式文章(&F)"
            Height          =   180
            Index           =   4
            Left            =   180
            TabIndex        =   9
            Top             =   780
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "略文章(&R)"
            Height          =   180
            Index           =   1
            Left            =   180
            TabIndex        =   7
            Top             =   420
            Width           =   1410
         End
         Begin VB.Label Label1 
            Caption         =   "検査連携用変換文章(&K):"
            Height          =   180
            Index           =   6
            Left            =   180
            TabIndex        =   13
            Top             =   3000
            Width           =   2010
         End
      End
   End
End
Attribute VB_Name = "frmSentence"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd              As String   '検査項目コード
Private mstrSuffix              As String   'サフィックス
Private mstrItemName            As String   '項目名称
Private mintItemType            As Integer  '項目タイプ
Private mstrStcCd               As String   '文章コード

Private mstrStcItemCd           As String   '文章参照用検査項目コード
Private mstrStcItemName         As String   '文章参照用検査項目名称

Private mblnInitialize          As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mstrStcClassCd()        As String   'コンボボックスに対応する文章分類コードの格納

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let StcCd(ByVal vntNewValue As Variant)

    mstrStcCd = vntNewValue
    
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
        If Trim(mstrItemCd) = "" Then
            MsgBox "検査項目が設定されていません。", vbCritical, App.Title
            cmdItemGuide.SetFocus
            Exit Do
        End If
        
        'コードの入力チェック
        If Trim(txtStcCd.Text) = "" Then
            MsgBox "文章コードが入力されていません。", vbCritical, App.Title
            txtStcCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If (Trim(txtShortStc.Text) = "") And (Trim(txtLongStc.Text) = "") Then
            MsgBox "文章名が入力されていません。", vbCritical, App.Title
            txtShortStc.SetFocus
            Exit Do
        End If

'        '名称の入力チェック
'        If LenB(Trim(txtShortStc.Text)) > 50 Then
'            MsgBox "設定された名称が長すぎます。", vbCritical, App.Title
'            txtShortStc.SetFocus
'            Exit Do
'        End If

        'どちらか片方が名称未入力なら勝手にセットする
        If Trim(txtShortStc.Text) = "" Then
            Trim(txtShortStc.Text) = Trim(txtLongStc.Text)
        End If

        If Trim(txtLongStc.Text) = "" Then
            txtLongStc.Text = Trim(txtShortStc.Text)
        End If

        '検査連携用文章は必ず全角に変換
        txtInsStc.Text = StrConv(Trim(txtInsStc.Text), vbWide)

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
Private Function EditSentence() As Boolean

    Dim objSentence         As Object           '文章アクセス用
    Dim vntShortStc         As Variant          '略称
    Dim vntLongStc          As Variant          '文章名
    Dim vntEngStc           As Variant          '文章名
    Dim vntStcClassCd       As Variant          '文章分類コード
    Dim vntInsStc           As Variant          '検査連携用変換文章
    Dim Ret                 As Boolean          '戻り値
    
    Dim vntStcClassCdList   As Variant
    Dim vntStcClassName     As Variant
    Dim lngCount            As Long
    Dim i                   As Integer
    
    Dim vntViewOrder        As Variant
    Dim vntPrintOrder       As Variant
    Dim vntImageFileName    As Variant
    Dim vntQuestionRank     As Variant
    Dim vntDelFlg           As Variant
'### 2004/01/15 Added by Ishihara@FSIT 報告書用文章追加
    Dim vntReptStc          As Variant
'### 2004/01/15 Added End
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objSentence = CreateObject("HainsSentence.Sentence")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If (mstrItemCd = "") Or (mstrStcCd = "") Then
            Ret = True
            Exit Do
        End If
        
        '文章テーブルレコード読み込み
'### 2004/01/15 Modified by Ishihara@FSIT 報告書用文章追加
'        If objSentence.SelectSentence(mstrItemCd, _
                                      mintItemType, _
                                      mstrStcCd, _
                                      vntShortStc, _
                                      vntLongStc, _
                                      vntEngStc, _
                                      vntStcClassCd, _
                                      vntInsStc, _
                                      vntViewOrder, _
                                      vntPrintOrder, _
                                      vntImageFileName, _
                                      vntQuestionRank, _
                                      vntDelFlg) = False Then
        If objSentence.SelectSentence(mstrItemCd, _
                                      mintItemType, _
                                      mstrStcCd, _
                                      vntShortStc, _
                                      vntLongStc, _
                                      vntEngStc, _
                                      vntStcClassCd, _
                                      vntInsStc, _
                                      vntViewOrder, _
                                      vntPrintOrder, _
                                      vntImageFileName, _
                                      vntQuestionRank, _
                                      vntDelFlg, , , _
                                      vntReptStc) = False Then
'### 2004/01/15 Modified End
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        
        txtShortStc.Text = vntShortStc
        txtLongStc.Text = vntLongStc
        txtEngStc.Text = vntEngStc
        txtInsStc.Text = vntInsStc
        
        txtViewOrder.Text = vntViewOrder
        txtPrintOrder.Text = vntPrintOrder
        txtImageFileName.Text = vntImageFileName
        txtQuestionRank.Text = vntQuestionRank
'### 2004/01/15 Added by Ishihara@FSIT 報告書用文章追加
        txtReptStc.Text = vntReptStc
'### 2004/01/15 Added End
    
        If vntDelFlg = "1" Then
            chkDelFlg.Value = vbChecked
        End If
    
        Ret = True
        Exit Do
    Loop
    
    'インスタンス作成ついでに文章分類コンボを設定
    cboStcClass.Clear
    Erase mstrStcClassCd
    
    'コース一覧取得（メインのみ）
    lngCount = objSentence.SelectStcClassItemList(vntStcClassCdList, vntStcClassName)
    
    'コースは未指定あり
    ReDim Preserve mstrStcClassCd(0)
    mstrStcClassCd(0) = ""
    cboStcClass.AddItem ""
    cboStcClass.ListIndex = 0
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrStcClassCd(i + 1)
        mstrStcClassCd(i + 1) = vntStcClassCdList(i)
        cboStcClass.AddItem vntStcClassName(i)
        If vntStcClassCdList(i) = vntStcClassCd Then
            cboStcClass.ListIndex = i + 1
        End If
    Next i
    
    '戻り値の設定
    EditSentence = Ret
    
    Exit Function

ErrorHandle:

    EditSentence = False
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
Private Function RegistSentence() As Boolean

    Dim objSentence    As Object       '文章アクセス用
    Dim Ret             As Long
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objSentence = CreateObject("HainsSentence.Sentence")
    
    '文章テーブルレコードの登録
'### 2004/01/15 Modified by Ishihara@FSIT 報告書用文章追加
'    Ret = objSentence.RegistSentence(IIf(txtStcCd.Enabled, "INS", "UPD"), _
                                     mstrStcItemCd, _
                                     cboItemType.ListIndex, _
                                     Trim(txtStcCd.Text), _
                                     Trim(txtShortStc.Text), _
                                     Trim(txtLongStc.Text), _
                                     Trim(txtEngStc.Text), _
                                     mstrStcClassCd(cboStcClass.ListIndex), _
                                     Trim(txtInsStc.Text), _
                                     Trim(txtViewOrder.Text), _
                                     Trim(txtPrintOrder.Text), _
                                     Trim(txtImageFileName.Text), _
                                     Trim(txtQuestionRank.Text), _
                                     IIf(chkDelFlg.Value = vbChecked, "1", ""))
    Ret = objSentence.RegistSentence(IIf(txtStcCd.Enabled, "INS", "UPD"), _
                                     mstrStcItemCd, _
                                     cboItemType.ListIndex, _
                                     Trim(txtStcCd.Text), _
                                     Trim(txtShortStc.Text), _
                                     Trim(txtLongStc.Text), _
                                     Trim(txtEngStc.Text), _
                                     mstrStcClassCd(cboStcClass.ListIndex), _
                                     Trim(txtInsStc.Text), _
                                     Trim(txtViewOrder.Text), _
                                     Trim(txtPrintOrder.Text), _
                                     Trim(txtImageFileName.Text), _
                                     Trim(txtQuestionRank.Text), _
                                     IIf(chkDelFlg.Value = vbChecked, "1", ""), _
                                     Trim(txtReptStc.Text))
'### 2004/01/15 Modified End

    If Ret = 0 Then
        MsgBox "入力された文章コードは既に存在します。", vbExclamation
        RegistSentence = False
        Exit Function
    End If
    
    RegistSentence = True
    
    Exit Function
    
ErrorHandle:

    RegistSentence = False
    MsgBox Err.Description, vbCritical
    
End Function

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

Private Sub cmdItemGuide_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '項目ガイド表示用
    
    Dim lngItemCount    As Long     '選択項目数
    Dim vntItemCd       As Variant  '選択された項目コード
    Dim vntSuffix       As Variant  '選択されたサフィックス
    Dim vntItemName     As Variant  '選択された項目名
    
    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
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
        vntSuffix = .Suffix
        vntItemName = .ItemName
    
    End With
        
    Screen.MousePointer = vbHourglass
    Me.Refresh
        
    '選択件数が0件以上なら
    If lngItemCount > 0 Then
        
        mstrItemCd = vntItemCd(0)
        mstrSuffix = vntSuffix(0)
            
        '検査項目情報の編集（検査項目コード、サフィックスを指定された場合）
        If GetItemInfo() = False Then
            MsgBox "ガイド参照後の検査項目情報取得に失敗しました。画面を閉じてください。", vbCritical
        End If
        
        lblItemCd.Caption = vntItemCd(0)
        lblItemName.Caption = vntItemName(0)
    End If

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault

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

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    Do
        '入力チェック
        If CheckValue() = False Then
            Exit Do
        End If
        
        '文章テーブルの登録
        If RegistSentence() = False Then
            Exit Do
        End If
            
        '更新済みフラグをTRUEに
        mblnUpdated = True
    
        '画面を閉じる
        Unload Me
        
        Exit Do
    Loop
    
    '処理中の解除
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
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    SSTab1.Tab = 0
    
    With cboItemType
        .AddItem "0:標準"
        .AddItem "1:この文章は「部位」の為の文章結果です"
        .AddItem "2:この文章は「所見」の為の文章結果です"
        .AddItem "3:この文章は「処置」の為の文章結果です"
        .ListIndex = 0
    End With

    mstrStcItemCd = mstrItemCd
    mstrStcItemName = mstrItemName

    Do
        '検査項目情報の編集（検査項目コード、サフィックスを指定された場合）
        If GetItemInfo() = False Then
            Exit Do
        End If
        
        '文章情報の編集
        If EditSentence() = False Then
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop

    '表示項目設定
    lblItemCd.Caption = mstrItemCd
    lblItemName.Caption = mstrItemName
    txtStcCd.Text = mstrStcCd
    cboItemType.ListIndex = mintItemType
    
    'イネーブル設定
    cmdItemGuide.Enabled = (txtStcCd.Text = "")
    txtStcCd.Enabled = (txtStcCd.Text = "")
    cboItemType.Enabled = (txtStcCd.Text = "")
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' 機能　　 : 検査項目情報取得
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査項目の基本情報を取得する
'
' 備考　　 : 欲しい情報は文章参照用項目コード
'
Private Function GetItemInfo() As Boolean

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
    Dim vntStcItemCd        As Variant              '
    Dim vntStcItemName      As Variant
    Dim vntRequestName      As Variant

    Dim Ret         As Boolean              '戻り値
    
    GetItemInfo = False
    
    On Error GoTo ErrorHandle
    
    Do
        '検索条件が指定されていない場合は何もしない
        If (mstrItemCd = "") Or (mstrSuffix = "") Then
            Ret = True
            Exit Do
        End If
    
        'オブジェクトのインスタンス作成
        Set objItem = CreateObject("HainsItem.Item")
        
        '検査項目テーブルレコード読み込み
        If objItem.SelectItemHeader(mstrItemCd, _
                                    mstrSuffix, _
                                    vntItemName, _
                                    vntitemEName, _
                                    vntClassName, _
                                    vntRslQue, _
                                    vntRslqueName, _
                                    vntItemType, _
                                    vntItemTypeName, _
                                    vntResultType, _
                                    vntResultTypeName, , , , vntStcItemCd, vntStcItemName, , , , , , , vntRequestName _
                                    ) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If

        '名称の再編集
        mstrItemName = vntRequestName

        '文章参照用項目コードの取得
        mstrStcItemCd = vntStcItemCd
        mstrStcItemName = vntStcItemName
        
        'ヘッダ情報の編集
        lblItemDetail.Caption = "（検査項目　" & mstrItemCd & "-" & mstrSuffix & "：" & vntItemName & "）"

        '項目コードの比較
        If mstrStcItemCd <> mstrItemCd Then
            lblstcItem.Caption = "この項目は、" & mstrStcItemCd & "：" & mstrStcItemName & "の文章を参照しています。" & vbLf & _
                                 "データの更新処理を行った場合、「" & mstrStcItemName & "」" & vbLf & "に対する文章として登録されます。"
            imgWarning.Visible = True
        Else
            lblstcItem.Caption = ""
            imgWarning.Visible = False
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    GetItemInfo = Ret
    
    Exit Function

ErrorHandle:

    GetItemInfo = False
    MsgBox Err.Description, vbCritical
    
End Function

Friend Property Get ItemCd() As Variant

    ItemCd = mstrItemCd

End Property

Friend Property Let ItemCd(ByVal vNewValue As Variant)

    mstrItemCd = vNewValue

End Property

Friend Property Get ItemType() As Integer

    ItemType = mintItemType

End Property

Friend Property Let ItemType(ByVal vNewValue As Integer)

    mintItemType = vNewValue

End Property

Friend Property Let ItemName(ByVal vNewValue As Variant)

    mstrItemName = vNewValue
    
End Property

Friend Property Get Suffix() As String

    Suffix = mstrSuffix
    
End Property

Friend Property Let Suffix(ByVal vNewValue As String)

    mstrSuffix = vNewValue
    
End Property

