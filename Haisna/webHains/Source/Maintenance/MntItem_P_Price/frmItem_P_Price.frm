VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmItem_P_Price 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "依頼項目単価テーブルメンテナンス"
   ClientHeight    =   6480
   ClientLeft      =   1605
   ClientTop       =   1545
   ClientWidth     =   6555
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmItem_P_Price.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6480
   ScaleWidth      =   6555
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin TabDlg.SSTab TabMain 
      Height          =   5055
      Left            =   120
      TabIndex        =   3
      Top             =   840
      Width           =   6315
      _ExtentX        =   11139
      _ExtentY        =   8916
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "健保なし"
      TabPicture(0)   =   "frmItem_P_Price.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Frame1"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "健保あり"
      TabPicture(1)   =   "frmItem_P_Price.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Frame2"
      Tab(1).Control(1)=   "cmdDeleteItem(1)"
      Tab(1).Control(2)=   "cmdAddItem(1)"
      Tab(1).Control(3)=   "cmdEditItem(1)"
      Tab(1).ControlCount=   4
      Begin VB.CommandButton cmdEditItem 
         Caption         =   "編集(&5)..."
         Height          =   315
         Index           =   1
         Left            =   -71760
         TabIndex        =   15
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "追加(&4)..."
         Height          =   315
         Index           =   1
         Left            =   -73140
         TabIndex        =   14
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "削除(&6)"
         Height          =   315
         Index           =   1
         Left            =   -70380
         TabIndex        =   13
         Top             =   4320
         Width           =   1275
      End
      Begin VB.Frame Frame2 
         Caption         =   "設定した値(&C)"
         Height          =   4335
         Left            =   -74820
         TabIndex        =   9
         Top             =   480
         Width           =   5955
         Begin VB.CommandButton cmdDownItem 
            Caption         =   "▼"
            BeginProperty Font 
               Name            =   "MS UI Gothic"
               Size            =   9.75
               Charset         =   128
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   1
            Left            =   180
            TabIndex        =   17
            Top             =   1980
            Width           =   435
         End
         Begin VB.CommandButton cmdUpItem 
            Caption         =   "▲"
            BeginProperty Font 
               Name            =   "MS UI Gothic"
               Size            =   9.75
               Charset         =   128
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   1
            Left            =   180
            TabIndex        =   16
            Top             =   1380
            Width           =   435
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3495
            Index           =   1
            Left            =   720
            TabIndex        =   10
            Top             =   240
            Width           =   4995
            _ExtentX        =   8811
            _ExtentY        =   6165
            LabelEdit       =   1
            MultiSelect     =   -1  'True
            LabelWrap       =   -1  'True
            HideSelection   =   0   'False
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
      Begin VB.Frame Frame1 
         Caption         =   "設定した値(&C)"
         Height          =   4335
         Left            =   180
         TabIndex        =   4
         Top             =   480
         Width           =   5955
         Begin VB.CommandButton cmdUpItem 
            Caption         =   "▲"
            BeginProperty Font 
               Name            =   "MS UI Gothic"
               Size            =   9.75
               Charset         =   128
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   0
            Left            =   180
            TabIndex        =   12
            Top             =   1380
            Width           =   435
         End
         Begin VB.CommandButton cmdDownItem 
            Caption         =   "▼"
            BeginProperty Font 
               Name            =   "MS UI Gothic"
               Size            =   9.75
               Charset         =   128
               Weight          =   700
               Underline       =   0   'False
               Italic          =   0   'False
               Strikethrough   =   0   'False
            EndProperty
            Height          =   375
            Index           =   0
            Left            =   180
            TabIndex        =   11
            Top             =   1980
            Width           =   435
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "削除(&3)"
            Height          =   315
            Index           =   0
            Left            =   4440
            TabIndex        =   7
            Top             =   3840
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "追加(&1)..."
            Height          =   315
            Index           =   0
            Left            =   1680
            TabIndex        =   6
            Top             =   3840
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditItem 
            Caption         =   "編集(&2)..."
            Height          =   315
            Index           =   0
            Left            =   3060
            TabIndex        =   5
            Top             =   3840
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3495
            Index           =   0
            Left            =   720
            TabIndex        =   8
            Top             =   240
            Width           =   4995
            _ExtentX        =   8811
            _ExtentY        =   6165
            LabelEdit       =   1
            MultiSelect     =   -1  'True
            LabelWrap       =   -1  'True
            HideSelection   =   0   'False
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
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   3660
      TabIndex        =   0
      Top             =   6060
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5100
      TabIndex        =   1
      Top             =   6060
      Width           =   1335
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   240
      Top             =   5760
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
            Picture         =   "frmItem_P_Price.frx":0044
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_P_Price.frx":0496
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_P_Price.frx":08E8
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmItem_P_Price.frx":0A42
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   120
      Picture         =   "frmItem_P_Price.frx":0B9C
      Top             =   120
      Width           =   720
   End
   Begin VB.Label lblItemInfo 
      Caption         =   "000120-00"
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
      Left            =   900
      TabIndex        =   2
      Top             =   240
      Width           =   6375
   End
End
Attribute VB_Name = "frmItem_P_Price"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd              As String           '検査項目コード
Private mstrRequestName         As String           '依頼項目名

Private mblnInitialize          As Boolean          'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean          'TRUE:更新あり、FALSE:更新なし
Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション

Private mintUniqueKey           As Long             'リストビュー一意キー管理用番号
Private Const KEY_PREFIX        As String = "K"

Private mblnHistoryUpdated      As Boolean          'TRUE:依頼項目単価履歴更新あり、FALSE:依頼項目単価履歴更新なし
Private mblnItemUpdated         As Boolean          'TRUE:依頼項目単価詳細更新あり、FALSE:依頼項目単価詳細更新なし

Private mintBeforeIndex         As Integer          '履歴コンボ変更キャンセル用の前Index
Private mblnNowEdit             As Boolean          'TRUE:編集処理中、FALSE:処理なし

Private mcolItem_P_Price_Record As Collection       '依頼項目単価レコードのコレクション

Friend Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
End Property

Friend Property Let RequestName(ByVal vntNewValue As Variant)

    mstrRequestName = vntNewValue
    
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

    Dim Ret                 As Boolean  '関数戻り値
    Dim strMsg              As String
    Dim intRet              As Integer
    Dim intListViewIndex    As Integer
    Dim i                   As Integer
    Dim j                   As Integer
    Dim curStrAge           As Currency
    Dim curEndAge           As Currency
    Dim obTargetListView    As ListView

    Ret = False
    
    Do
        
        'リストビューの中身をセット
        For intListViewIndex = 0 To 1
        
            Set obTargetListView = lsvItem(intListViewIndex)
        
            'リストビューを回す
            For i = 1 To obTargetListView.ListItems.Count
        
                '現在の開始、終了年齢を退避
                With obTargetListView.ListItems(i)
                    curStrAge = CCur(.Text)
                    curEndAge = CCur(.SubItems(1))
                End With
                
                '年齢ダブリをゆるさない
                j = i
                If j < obTargetListView.ListItems.Count Then
                    For j = (i + 1) To obTargetListView.ListItems.Count
                        If ((curStrAge >= CCur(obTargetListView.ListItems(j).Text)) And _
                            (curStrAge <= CCur(obTargetListView.ListItems(j).SubItems(1)))) Or _
                           ((curEndAge >= CCur(obTargetListView.ListItems(j).Text)) And _
                            (curEndAge <= CCur(obTargetListView.ListItems(j).SubItems(1)))) Then
                            
                            'マルチセレクトを解除して選択状態をクリア。エラー行を選択後マルチセレクトに戻す
                            obTargetListView.MultiSelect = False
                            obTargetListView.ListItems(j).Selected = True
                            obTargetListView.MultiSelect = True
                            
                            TabMain.Tab = intListViewIndex
                            MsgBox "年齢設定範囲が重複しています。設定内容を見直してください。"
                            CheckValue = False
                            Exit Function
                        
                        End If
                    Next j
                End If
                                
            Next i
        
        Next intListViewIndex
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

'
' 機能　　 : 依頼項目単価詳細情報の取得
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function GetItem_P_Price() As Boolean

    Dim objItem_P_Price         As Object       '依頼項目単価管理アクセス用
    
    Dim vntItemCd               As Variant      '検査項目コード
    Dim vntExistsIsr            As Variant      '健保有無区分
    Dim vntSeq                  As Variant      'SEQ
    Dim vntStrAge               As Variant      '開始年齢
    Dim vntEndAge               As Variant      '終了年齢
    Dim vntBsdPrice             As Variant      '団体負担金額
    Dim vntIsrPrice             As Variant      '健保負担金額
    
    Dim lngCount                As Long         'レコード数
    Dim i                       As Integer
    Dim Ret                     As Boolean      '戻り値
    
    Dim objItem_P_Price_Record  As Item_P_Price_Record    '依頼項目単価レコードオブジェクト
    
    On Error GoTo ErrorHandle
        
    'コレクションクリア
    Set mcolItem_P_Price_Record = Nothing
    Set mcolItem_P_Price_Record = New Collection

    Do
        '検査項目コードが指定されていない場合は何もしない
        If mstrItemCd = "" Then
            Ret = True
            Exit Do
        End If
    
        'オブジェクトのインスタンス作成
        Set objItem_P_Price = CreateObject("HainsItem.Item")
        
        '依頼項目単価テーブルレコード読み込み
        lngCount = objItem_P_Price.SelectItem_P_Price(mstrItemCd, _
                                                      vntExistsIsr, _
                                                      vntSeq, _
                                                      vntStrAge, _
                                                      vntEndAge, _
                                                      vntBsdPrice, _
                                                      vntIsrPrice)
        
        '0件でも不思議なし
        If lngCount = 0 Then
            Ret = True
            Exit Do
        End If

        '読み込み内容の編集
        For i = 0 To lngCount - 1
            
            '読み込み内容をオブジェクトにセット
            Set objItem_P_Price_Record = New Item_P_Price_Record
            With objItem_P_Price_Record
                .Key = KEY_PREFIX & vntExistsIsr(i) & vntSeq(i)
                .ExistsIsr = vntExistsIsr(i)
                .Seq = vntSeq(i)
                .StrAge = vntStrAge(i)
                .EndAge = vntEndAge(i)
                .BsdPrice = vntBsdPrice(i)
                .IsrPrice = vntIsrPrice(i)
            End With
            
            'コレクションに追加
            mcolItem_P_Price_Record.Add objItem_P_Price_Record, KEY_PREFIX & vntExistsIsr(i) & vntSeq(i)
            
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    Set objItem_P_Price = Nothing
    
    '戻り値の設定
    GetItem_P_Price = Ret
    
    Exit Function

ErrorHandle:

    GetItem_P_Price = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : 依頼項目単価詳細情報の表示（コレクションから）
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditListViewFromCollection() As Boolean

On Error GoTo ErrorHandle

    Dim objItem                 As ListItem             'リストアイテムオブジェクト
    Dim vntCsCd                 As Variant              'コースコード
    Dim vntCsName               As Variant              'コース名
    Dim lngCount                As Long                 'レコード数
    Dim i                       As Long                 'インデックス
    Dim objItem_P_Price_Record  As Item_P_Price_Record  '依頼項目単価レコードオブジェクト
    
    EditListViewFromCollection = False

    'リストビュー用ヘッダ調整
    For i = 0 To 1
        Call EditListViewHeader(CInt(i))
    Next i
    
    'リストビュー用ユニークキー初期化
    mintUniqueKey = 1
    
    'リストの編集
    For Each objItem_P_Price_Record In mcolItem_P_Price_Record
        With objItem_P_Price_Record
            
            '健保有無区分によりセットするリストビューを変更する
            i = .ExistsIsr
        
            Set objItem = lsvItem(i).ListItems.Add(, .Key, .StrAge, , "DEFAULTLIST")
            objItem.SubItems(1) = .EndAge
            objItem.SubItems(2) = .BsdPrice
            objItem.SubItems(3) = .IsrPrice
        
        End With
        mintUniqueKey = mintUniqueKey + 1
    
    Next objItem_P_Price_Record
    
    'オブジェクト廃棄
    Set objItem_P_Price_Record = Nothing
    
    EditListViewFromCollection = True
    Exit Function
    
ErrorHandle:

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
Private Function RegistItem_P_Price() As Boolean

On Error GoTo ErrorHandle

    Dim objItem_P_Price         As Object       '依頼項目単価管理アクセス用
    Dim Ret                     As Long
    
    '新規登録時の退避用
    Dim blnNewRecordFlg         As Boolean
    Dim strEscItemCd            As String
    Dim strEscSuffix            As String
    Dim strEscStrDate           As String
    Dim strEscEndDate           As String
    Dim strEscCsCd              As String

    '依頼項目単価
    Dim lngItem_P_PriceMngCd        As Long

    '依頼項目単価の配列関連
    Dim intItemCount            As Integer
    Dim vntExistsIsr            As Variant
    Dim vntSeq                  As Variant
    Dim vntStrAge               As Variant
    Dim vntEndAge               As Variant
    Dim vntBsdPrice             As Variant
    Dim vntIsrPrice             As Variant
    
    Dim blnBeforeUpdatePoint    As Boolean      'TRUE:更新前、FALSE:更新前ではない
    
    blnBeforeUpdatePoint = False
    
    '依頼項目単価詳細テーブルの配列セット
    Call EditArrayForUpdate(intItemCount, _
                            vntExistsIsr, _
                            vntSeq, _
                            vntStrAge, _
                            vntEndAge, _
                            vntBsdPrice, _
                            vntIsrPrice)
    
    'オブジェクトのインスタンス作成
    Set objItem_P_Price = CreateObject("HainsItem.Item")

    blnBeforeUpdatePoint = True

    '依頼項目単価データの登録
    Ret = objItem_P_Price.RegistItem_P_Price(mstrItemCd, _
                                            intItemCount, _
                                            vntExistsIsr, _
                                            vntSeq, _
                                            vntStrAge, _
                                            vntEndAge, _
                                            vntBsdPrice, _
                                            vntIsrPrice)
    
    blnBeforeUpdatePoint = False
    
    If Ret = INSERT_ERROR Then
        MsgBox "テーブル更新時にエラーが発生しました。", vbCritical
        RegistItem_P_Price = False
        Exit Function
    End If
    
    '更新済みフラグを初期化
    mblnHistoryUpdated = False
    mblnItemUpdated = False
    
    RegistItem_P_Price = True
    
    Exit Function
    
ErrorHandle:

    RegistItem_P_Price = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : リストビューデータの配列セット
'
' 引数　　 : (Out)   intItemCount        項目数
' 　　　　   (Out)   vntExistsIsr        健保有無区分
' 　　　　   (Out)   vntSeq              Seq
' 　　　　   (Out)   vntStrAge           開始年齢
' 　　　　   (Out)   vntEndAge           終了年齢
' 　　　　   (Out)   vntBsdPrice         団体負担金
' 　　　　   (Out)   vntIsrPrice         健保負担金
'
' 機能説明 : リストビュー上のデータをDB格納用としてVariant配列に編集する
'
' 備考　　 :
'
Private Sub EditArrayForUpdate(intItemCount As Integer, _
                               vntExistsIsr As Variant, _
                               vntSeq As Variant, _
                               vntStrAge As Variant, _
                               vntEndAge As Variant, _
                               vntBsdPrice As Variant, _
                               vntIsrPrice As Variant)

    Dim vntArrExistsIsr()       As Variant
    Dim vntArrSeq()             As Variant
    Dim vntArrStrAge()          As Variant
    Dim vntArrEndAge()          As Variant
    Dim vntArrbsdPrice()        As Variant
    Dim vntArrisrPrice()        As Variant
    
    Dim i                       As Integer
    Dim intArrCount             As Integer
    Dim intListViewIndex        As Integer
    Dim intSeqCount             As Integer
    Dim obTargetListView        As ListView

    intArrCount = 0

    'リストビューの中身をセット
    For intListViewIndex = 0 To 1
    
        intSeqCount = 1
        Set obTargetListView = lsvItem(intListViewIndex)
    
        'リストビューをくるくる回して選択項目配列作成
        For i = 1 To obTargetListView.ListItems.Count
    
            ReDim Preserve vntArrExistsIsr(intArrCount)
            ReDim Preserve vntArrSeq(intArrCount)
            ReDim Preserve vntArrStrAge(intArrCount)
            ReDim Preserve vntArrEndAge(intArrCount)
            ReDim Preserve vntArrbsdPrice(intArrCount)
            ReDim Preserve vntArrisrPrice(intArrCount)
    
            With obTargetListView.ListItems(i)
                
                vntArrExistsIsr(intArrCount) = intListViewIndex
                vntArrSeq(intArrCount) = intSeqCount
                vntArrStrAge(intArrCount) = .Text
                vntArrEndAge(intArrCount) = .SubItems(1)
                vntArrbsdPrice(intArrCount) = .SubItems(2)
                vntArrisrPrice(intArrCount) = .SubItems(3)
            
            End With
            
            intArrCount = intArrCount + 1
            intSeqCount = intSeqCount + 1
            
        Next i
    
    Next intListViewIndex

    vntExistsIsr = vntArrExistsIsr
    vntSeq = vntArrSeq
    vntStrAge = vntArrStrAge
    vntEndAge = vntArrEndAge
    vntBsdPrice = vntArrbsdPrice
    vntIsrPrice = vntArrisrPrice

    intItemCount = intArrCount

End Sub

Private Sub cmdAddItem_Click(Index As Integer)

    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    
    Dim strStrAge           As String           '開始年齢
    Dim strEndAge           As String           '終了年齢
    Dim strbsdPrice         As String           '団体負担金
    Dim strisrPrice         As String           '健保負担金
    
    'クリックされたインデックスで健保有無を選択
    Set obTargetListView = lsvItem(Index)

    With frmEditItem_P_Price
        
        'ガイドに対するプロパティセット
        .ExistsIsr = Index
        .StrAge = "0"
        .EndAge = "999.99"
        .BsdPrice = "0"
        .IsrPrice = "0"
    
        .Show vbModal
    
        If .Updated = True Then
            
            strStrAge = .StrAge
            strEndAge = .EndAge
            strbsdPrice = .BsdPrice
            strisrPrice = .IsrPrice
            
            '更新されているなら、リストビューに追加
            Set objItem = obTargetListView.ListItems.Add(, KEY_PREFIX & mintUniqueKey, strStrAge, , "DEFAULTLIST")
            objItem.SubItems(1) = strEndAge
            objItem.SubItems(2) = strbsdPrice
            objItem.SubItems(3) = strisrPrice
        
            mintUniqueKey = mintUniqueKey + 1
            
            '依頼項目単価詳細更新済み
            mblnItemUpdated = True
        
        End If
        
    End With
    
    'オブジェクトの廃棄
    Set frmEditItem_P_Price = Nothing
    
End Sub

Private Function ApplyData(blnOkMode As Boolean) As Boolean

    ApplyData = False
    
    '入力チェック
    If CheckValue() = False Then
        Exit Function
    End If
    
    '依頼項目単価管理テーブルの登録
    If RegistItem_P_Price() = False Then
        Exit Function
    End If
    
    '更新済みフラグをTRUEに
    mblnUpdated = True
        
    'OKボタン押下時はここで終了
    If blnOkMode = True Then
        ApplyData = True
        Exit Function
    End If

    ApplyData = True

End Function

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

Private Sub cmdDeleteItem_Click(Index As Integer)

    Dim i                   As Integer
    Dim obTargetListView    As ListView
    
    'クリックされたインデックスで性別を選択
    Set obTargetListView = lsvItem(Index)
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To obTargetListView.ListItems.Count
        
        'インデックスがリスト項目を越えたら終了
        If i > obTargetListView.ListItems.Count Then Exit For
        
        '選択されている項目なら削除
        If obTargetListView.ListItems(i).Selected = True Then
            obTargetListView.ListItems.Remove (obTargetListView.ListItems(i).Key)
            'アイテム数が変わるので-1して再検査
            i = i - 1
            '依頼項目単価詳細更新済み
            mblnItemUpdated = True
        
        End If
    
    Next i

End Sub

Private Sub cmdDownItem_Click(Index As Integer)
    
    Call MoveListItem(1, Index)

End Sub

Private Sub cmdEditItem_Click(Index As Integer)

    Dim i                       As Integer
    Dim strTargetKey            As String
    Dim strTargetDiv            As String
    Dim strTargetCd             As String
    Dim obTargetListView        As ListView
    
    Dim intSelectedIndex        As Integer
    Dim intSelectedCount        As Integer
    
    'クリックされたインデックスで健保有無を選択
    Set obTargetListView = lsvItem(Index)
    
    'リストビュー上の選択項目数をカウント
    intSelectedIndex = 0
    intSelectedCount = 0
    With obTargetListView
        For i = 1 To .ListItems.Count
            If .ListItems(i).Selected = True Then
                intSelectedIndex = i
                intSelectedCount = intSelectedCount + 1
            End If
        Next i
    End With
    
    '何も選択されていないなら処理終了
    If intSelectedCount = 0 Then Exit Sub
    
    '複数選択状態ならエラー
    If intSelectedCount > 1 Then
        MsgBox "項目が複数選択されています。情報を修正する場合は、一つだけ選択してください。", vbExclamation, Me.Caption
        Exit Sub
    End If
    
    With frmEditItem_P_Price
        
        'ガイドに対するプロパティセット
        .ExistsIsr = Index
        .StrAge = obTargetListView.ListItems(intSelectedIndex).Text
        .EndAge = obTargetListView.ListItems(intSelectedIndex).SubItems(1)
        .BsdPrice = obTargetListView.ListItems(intSelectedIndex).SubItems(2)
        .IsrPrice = obTargetListView.ListItems(intSelectedIndex).SubItems(3)
    
        .Show vbModal
    
        If .Updated = True Then
            
            obTargetListView.ListItems(intSelectedIndex).Text = .StrAge
            obTargetListView.ListItems(intSelectedIndex).SubItems(1) = .EndAge
            obTargetListView.ListItems(intSelectedIndex).SubItems(2) = .BsdPrice
            obTargetListView.ListItems(intSelectedIndex).SubItems(3) = .IsrPrice
                
            '依頼項目単価詳細更新済み
            mblnItemUpdated = True
        
        End If
        
    End With

    'オブジェクトの廃棄
    Set frmEditItem_P_Price = Nothing

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

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    'データの保存
    If ApplyData(True) = True Then
        '画面を閉じる
        Unload Me
    End If
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub cmdUpItem_Click(Index As Integer)

    Call MoveListItem(-1, Index)
    
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
    Dim i   As Integer
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    mblnItemUpdated = False
    
    '画面初期化
    TabMain.Tab = 0                 '先頭タブをActive
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    Do
    
        '依頼項目名称の表示
        lblItemInfo.Caption = mstrItemCd & "：" & mstrRequestName
    
        '依頼項目単価情報の取得
        If GetItem_P_Price() = False Then Exit Do
        
        '依頼項目単価情報のリストビュー格納
        If EditListViewFromCollection() = False Then Exit Do
        
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
' 機能　　 : 選択項目の移動
'
' 引数　　 : (In)   intMovePosition 移動方向（-1:一つ上へ、1:一つしたへ）
'
' 機能説明 : リストビュー上の項目を移動させる
'
' 備考　　 :
'
Private Sub MoveListItem(intMovePosition As Integer, intListViewIndex As Integer)

    Dim i                   As Integer
    Dim j                   As Integer
    Dim objItem             As ListItem
    
    Dim intSelectedCount    As Integer      '現在選択されている項目数
    Dim intSelectedIndex    As Integer      '現在選択されている行
    Dim intTargetIndex      As Integer      '+-で増減した処理対象行
    
    Dim intScrollPoint      As Integer
    
    Dim strEscField()       As String       'リストビューの項目を退避するための２次元配列
    Dim intEscFieldCount    As Integer      'リストビュー１行のサブアイテム数
    
    Dim obTargetListView    As ListView
    
    'クリックされたインデックスで性別を選択
    Set obTargetListView = lsvItem(intListViewIndex)
    
    intSelectedCount = 0

    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To obTargetListView.ListItems.Count

        '選択されている項目なら
        If obTargetListView.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '選択項目数が１個以外なら処理しない
    If intSelectedCount = 0 Then Exit Sub
    
    '選択項目数が１個以上なら泣きメッセージ
    If intSelectedCount > 1 Then
        MsgBox "複数選択した項目の優先順位変更はできません。", vbExclamation, Me.Caption
        Exit Sub
    End If
    
    '項目Up指定かつ、選択項目が先頭なら何もしない
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '項目Down指定かつ、選択項目が最終なら何もしない
    If (intSelectedIndex = obTargetListView.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    If intMovePosition = -1 Then
        '項目Upの場合、一つ前の要素をターゲットとする。
        intTargetIndex = intSelectedIndex - 1
    Else
        '項目Downの場合、現在の要素をターゲットとする。
        intTargetIndex = intSelectedIndex
    End If
    
    '現在表示上の先頭Indexを取得
    intScrollPoint = obTargetListView.GetFirstVisible.Index
    
    'リストビューをくるくる回して全項目配列作成
    For i = 1 To obTargetListView.ListItems.Count
        
        'サブアイテムの数を取得
        intEscFieldCount = obTargetListView.ListItems(i).ListSubItems.Count
'        intEscFieldCount = obTargetListView.ListItems(i).ListSubItems.Count + 2
        
        'サブアイテム＋キー＋テキスト、行数で配列拡張
        ReDim Preserve strEscField(intEscFieldCount + 2, i)
'        ReDim Preserve strEscField(intEscFieldCount, i)
        
        '処理対象配列番号時処理
        If intTargetIndex = i Then
        
            '項目退避
            strEscField(0, i) = obTargetListView.ListItems(i + 1).Key
            strEscField(1, i) = obTargetListView.ListItems(i + 1)
            For j = 1 To intEscFieldCount
                strEscField(j + 1, i) = obTargetListView.ListItems(i + 1).SubItems(j)
            Next j
        
            i = i + 1
        
            'サブアイテム＋キー＋テキスト、行数で配列拡張
'            ReDim Preserve strEscField(10, i)
            ReDim Preserve strEscField(intEscFieldCount + 2, i)
        
            strEscField(0, i) = obTargetListView.ListItems(intTargetIndex).Key
            strEscField(1, i) = obTargetListView.ListItems(intTargetIndex)
            For j = 1 To intEscFieldCount
                strEscField(j + 1, i) = obTargetListView.ListItems(intTargetIndex).SubItems(j)
            Next j
        
        Else
            strEscField(0, i) = obTargetListView.ListItems(i).Key
            strEscField(1, i) = obTargetListView.ListItems(i)
            For j = 1 To intEscFieldCount
                strEscField(j + 1, i) = obTargetListView.ListItems(i).SubItems(j)
            Next j
        
        End If
    
    Next i
    
    'リストビュー用ヘッダ調整
    Call EditListViewHeader(intListViewIndex)
    
    'リストの編集
    For i = 1 To UBound(strEscField, 2)
        Set objItem = obTargetListView.ListItems.Add(, strEscField(0, i), strEscField(1, i), , "DEFAULTLIST")
        For j = 1 To intEscFieldCount
            objItem.SubItems(j) = strEscField(j + 1, i)
        Next j
    Next i

    obTargetListView.ListItems(1).Selected = False
    
    '移動した項目を選択させ、移動（スクロール）させる
    If intMovePosition = 1 Then
        obTargetListView.ListItems(intTargetIndex + 1).Selected = True
    Else
        obTargetListView.ListItems(intTargetIndex).Selected = True
    End If

    '選択されている項目を表示する
    obTargetListView.SelectedItem.EnsureVisible

    obTargetListView.SetFocus

End Sub

Private Sub lsvItem_DblClick(Index As Integer)

    Call cmdEditItem_Click(Index)

End Sub

Private Sub lsvItem_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)

    Dim i As Long

    'CTRL+Aを押下された場合、項目を全て選択する
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem(Index).ListItems.Count
            lsvItem(Index).ListItems(i).Selected = True
        Next i
    End If

End Sub

Private Sub EditListViewHeader(intListViewIndex As Integer)
    
    Dim objHeader           As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objTargetListView   As ListView
    
    Set objTargetListView = lsvItem(intListViewIndex)
    objTargetListView.ListItems.Clear
    Set objHeader = objTargetListView.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "開始年齢", 1000, lvwColumnLeft
        .Add , , "終了年齢", 1000, lvwColumnLeft
        .Add , , "団体負担金額", 1300, lvwColumnRight
        .Add , , "健保負担金額", 1300, lvwColumnRight
    End With
    objTargetListView.View = lvwReport

End Sub
