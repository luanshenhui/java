VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmRoundClass 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "まるめ分類テーブルメンテナンス"
   ClientHeight    =   6270
   ClientLeft      =   1605
   ClientTop       =   1545
   ClientWidth     =   6345
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRoundClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6270
   ScaleWidth      =   6345
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.TextBox txtRoundClassName 
      Height          =   318
      IMEMode         =   4  '全角ひらがな
      Left            =   1740
      MaxLength       =   25
      TabIndex        =   3
      Text            =   "人間ドック"
      Top             =   540
      Width           =   4335
   End
   Begin VB.TextBox txtRoundClassCd 
      Height          =   315
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1740
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "123"
      Top             =   180
      Width           =   555
   End
   Begin VB.Frame Frame1 
      Caption         =   "設定した値(&I)"
      Height          =   4335
      Left            =   180
      TabIndex        =   10
      Top             =   960
      Width           =   5955
      Begin VB.CommandButton cmdEditItem 
         Caption         =   "編集(&E)..."
         Height          =   315
         Index           =   0
         Left            =   3060
         TabIndex        =   8
         Top             =   3840
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "追加(&A)..."
         Height          =   315
         Index           =   0
         Left            =   1680
         TabIndex        =   7
         Top             =   3840
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "削除(&D)"
         Height          =   315
         Index           =   0
         Left            =   4440
         TabIndex        =   9
         Top             =   3840
         Width           =   1275
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
         TabIndex        =   5
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
         Index           =   0
         Left            =   180
         TabIndex        =   4
         Top             =   1380
         Width           =   435
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   3495
         Index           =   0
         Left            =   720
         TabIndex        =   6
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
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   3480
      TabIndex        =   11
      Top             =   5820
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4920
      TabIndex        =   12
      Top             =   5820
      Width           =   1335
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   300
      Top             =   5580
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
            Picture         =   "frmRoundClass.frx":000C
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmRoundClass.frx":045E
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmRoundClass.frx":08B0
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmRoundClass.frx":0A0A
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Label Label2 
      Caption         =   "まるめ分類名(&N):"
      Height          =   195
      Index           =   1
      Left            =   180
      TabIndex        =   2
      Top             =   600
      Width           =   1575
   End
   Begin VB.Label Label2 
      Caption         =   "まるめ分類コード(&C):"
      Height          =   195
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   240
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "※年齢範囲が重複した場合、上から順に適用されます"
      Height          =   195
      Left            =   240
      TabIndex        =   13
      Top             =   5460
      Width           =   5955
   End
End
Attribute VB_Name = "frmRoundClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrRoundClassCd              As String           'まるめ分類コード

Private mblnInitialize          As Boolean          'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean          'TRUE:更新あり、FALSE:更新なし
Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション

Private mintUniqueKey           As Long             'リストビュー一意キー管理用番号
Private Const KEY_PREFIX        As String = "K"

Private mblnHistoryUpdated      As Boolean          'TRUE:まるめ分類金額管理履歴更新あり、FALSE:まるめ分類金額管理履歴更新なし
Private mblnItemUpdated         As Boolean          'TRUE:まるめ分類金額管理詳細更新あり、FALSE:まるめ分類金額管理詳細更新なし

Private mintBeforeIndex         As Integer          '履歴コンボ変更キャンセル用の前Index
Private mblnNowEdit             As Boolean          'TRUE:編集処理中、FALSE:処理なし

Private mcolRoundClassPrice_Record As Collection       'まるめ分類金額管理レコードのコレクション

Friend Property Let RoundClassCd(ByVal vntNewValue As Variant)

    mstrRoundClassCd = vntNewValue
    
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
    Dim strMsg      As String
    Dim intRet      As Integer

    Ret = False
    
    Do
        
        'このテーブルメンテナンスでは特にチェックは必要なし
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

'
' 機能　　 : まるめ分類金額管理詳細情報の取得
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function GetRoundClassInfo() As Boolean

    Dim objRoundClass           As Object       'まるめ分類金額管理管理アクセス用
    
    Dim vntRoundClassName       As Variant      'まるめ分類名
    Dim vntSeq                  As Variant      'SEQ
    Dim vntStrCount             As Variant      '開始年齢
    Dim vntEndCount             As Variant      '終了年齢
    Dim vntBsdPrice             As Variant      '団体負担金額
    Dim vntIsrPrice             As Variant      '健保負担金額
    
    Dim lngCount                As Long         'レコード数
    Dim i                       As Integer
    Dim Ret                     As Boolean      '戻り値
    
    Dim objRoundClass_Record  As RoundClassPrice_Record    'まるめ分類金額管理レコードオブジェクト
    
    On Error GoTo ErrorHandle
        
    'コレクションクリア
    Set mcolRoundClassPrice_Record = Nothing
    Set mcolRoundClassPrice_Record = New Collection

    Do
        'まるめ分類コードが指定されていない場合は何もしない
        If mstrRoundClassCd = "" Then
            Ret = True
            Exit Do
        End If
    
        'オブジェクトのインスタンス作成
        Set objRoundClass = CreateObject("HainsRoundClass.RoundClass")
        
        'まるめ分類テーブルレコード読み込み
        If objRoundClass.SelectRoundClass(mstrRoundClassCd, vntRoundClassName) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
        
        txtRoundClassCd.Text = mstrRoundClassCd
        txtRoundClassName.Text = vntRoundClassName
        
        'まるめ分類金額管理テーブルレコード読み込み
        lngCount = objRoundClass.SelectRoundClassPriceList(mstrRoundClassCd, _
                                                           vntSeq, _
                                                           vntStrCount, _
                                                           vntEndCount, _
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
            Set objRoundClass_Record = New RoundClassPrice_Record
            With objRoundClass_Record
                .Key = KEY_PREFIX & vntSeq(i)
                .Seq = vntSeq(i)
                .StrCount = vntStrCount(i)
                .EndCount = vntEndCount(i)
                .BsdPrice = vntBsdPrice(i)
                .IsrPrice = vntIsrPrice(i)
            End With
            
            'コレクションに追加
            mcolRoundClassPrice_Record.Add objRoundClass_Record, KEY_PREFIX & vntSeq(i)
            
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    Set objRoundClass = Nothing
    
    '戻り値の設定
    GetRoundClassInfo = Ret
    
    Exit Function

ErrorHandle:

    GetRoundClassInfo = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : まるめ分類金額管理情報の表示（コレクションから）
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditListViewFromCollection() As Boolean

On Error GoTo ErrorHandle

    Dim objItem                 As ListItem                 'リストアイテムオブジェクト
    Dim vntCsCd                 As Variant                  'コースコード
    Dim vntCsName               As Variant                  'コース名
    Dim lngCount                As Long                     'レコード数
    Dim i                       As Long                     'インデックス
    Dim objRoundClass_Record    As RoundClassPrice_Record   'まるめ分類金額管理レコードオブジェクト
    
    EditListViewFromCollection = False

    'リストビュー用ヘッダ調整
    For i = 0 To 0
        Call EditListViewHeader(CInt(i))
    Next i
    
    'リストビュー用ユニークキー初期化
    mintUniqueKey = 1
    
    'リストの編集
    For Each objRoundClass_Record In mcolRoundClassPrice_Record
        With objRoundClass_Record
            
            'リストビューの配列は無条件に0
            i = 0
        
            Set objItem = lsvItem(i).ListItems.Add(, .Key, .StrCount, , "DEFAULTLIST")
            objItem.SubItems(1) = .EndCount
            objItem.SubItems(2) = .BsdPrice
            objItem.SubItems(3) = .IsrPrice
        
        End With
        mintUniqueKey = mintUniqueKey + 1
    
    Next objRoundClass_Record
    
    'オブジェクト廃棄
    Set objRoundClass_Record = Nothing
    
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
Private Function RegistRoundClass() As Boolean

On Error GoTo ErrorHandle

    Dim objRoundClass           As Object       'まるめ分類金額管理管理アクセス用
    Dim Ret                     As Long
    
    '新規登録時の退避用
    Dim blnNewRecordFlg         As Boolean
    Dim strEscRoundClassCd      As String
    Dim strEscSuffix            As String
    Dim strEscStrDate           As String
    Dim strEscEndDate           As String
    Dim strEscCsCd              As String

    'まるめ分類金額管理
    Dim lngRoundClassPriceMngCd As Long

    'まるめ分類金額管理の配列関連
    Dim intItemCount            As Integer
    Dim vntSeq                  As Variant
    Dim vntStrCount             As Variant
    Dim vntEndCount             As Variant
    Dim vntBsdPrice             As Variant
    Dim vntIsrPrice             As Variant
    
    Dim blnBeforeUpdatePoint    As Boolean      'TRUE:更新前、FALSE:更新前ではない
    
    blnBeforeUpdatePoint = False
    
    'まるめ分類金額管理詳細テーブルの配列セット
    Call EditArrayForUpdate(intItemCount, _
                            vntSeq, _
                            vntStrCount, _
                            vntEndCount, _
                            vntBsdPrice, _
                            vntIsrPrice)
    
    'オブジェクトのインスタンス作成
    Set objRoundClass = CreateObject("HainsRoundClass.RoundClass")

    blnBeforeUpdatePoint = True

    'まるめ分類金額管理データの登録
    Ret = objRoundClass.RegistRoundClass_All(IIf(txtRoundClassCd.Enabled, "INS", "UPD"), _
                                             txtRoundClassCd.Text, _
                                             txtRoundClassName.Text, _
                                             intItemCount, _
                                             vntSeq, _
                                             vntStrCount, _
                                             vntEndCount, _
                                             vntBsdPrice, _
                                             vntIsrPrice)
    
    blnBeforeUpdatePoint = False
    
    If Ret = INSERT_ERROR Then
        MsgBox "テーブル更新時にエラーが発生しました。", vbCritical
        RegistRoundClass = False
        Exit Function
    End If
    
    '更新済みフラグを初期化
    mblnHistoryUpdated = False
    mblnItemUpdated = False
    
    RegistRoundClass = True
    
    Exit Function
    
ErrorHandle:

    RegistRoundClass = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : リストビューデータの配列セット
'
' 引数　　 : (Out)   intItemCount        項目数
' 　　　　   (Out)   vntSeq              Seq
' 　　　　   (Out)   vntStrCount           開始年齢
' 　　　　   (Out)   vntEndCount           終了年齢
' 　　　　   (Out)   vntBsdPrice         団体負担金
' 　　　　   (Out)   vntIsrPrice         健保負担金
'
' 機能説明 : リストビュー上のデータをDB格納用としてVariant配列に編集する
'
' 備考　　 :
'
Private Sub EditArrayForUpdate(intItemCount As Integer, _
                               vntSeq As Variant, _
                               vntStrCount As Variant, _
                               vntEndCount As Variant, _
                               vntBsdPrice As Variant, _
                               vntIsrPrice As Variant)

    Dim vntArrExistsIsr()       As Variant
    Dim vntArrSeq()             As Variant
    Dim vntArrStrCount()        As Variant
    Dim vntArrEndCount()        As Variant
    Dim vntArrbsdPrice()        As Variant
    Dim vntArrisrPrice()        As Variant
    
    Dim i                       As Integer
    Dim intArrCount             As Integer
    Dim intListViewIndex        As Integer
    Dim intSeqCount             As Integer
    Dim obTargetListView        As ListView

    intArrCount = 0

    'リストビューの中身をセット
    '（本来はリストビューを配列にする必要は全くないが、将来的に健保対応を言われた場合の保険）
    For intListViewIndex = 0 To 0
    
        intSeqCount = 1
        Set obTargetListView = lsvItem(intListViewIndex)
    
        'リストビューをくるくる回して選択項目配列作成
        For i = 1 To obTargetListView.ListItems.Count
    
            ReDim Preserve vntArrSeq(intArrCount)
            ReDim Preserve vntArrStrCount(intArrCount)
            ReDim Preserve vntArrEndCount(intArrCount)
            ReDim Preserve vntArrbsdPrice(intArrCount)
            ReDim Preserve vntArrisrPrice(intArrCount)
    
            With obTargetListView.ListItems(i)
                
                vntArrSeq(intArrCount) = intSeqCount
                vntArrStrCount(intArrCount) = .Text
                vntArrEndCount(intArrCount) = .SubItems(1)
                vntArrbsdPrice(intArrCount) = .SubItems(2)
                vntArrisrPrice(intArrCount) = .SubItems(3)
            
            End With
            
            intArrCount = intArrCount + 1
            intSeqCount = intSeqCount + 1
            
        Next i
    
    Next intListViewIndex

    vntSeq = vntArrSeq
    vntStrCount = vntArrStrCount
    vntEndCount = vntArrEndCount
    vntBsdPrice = vntArrbsdPrice
    vntIsrPrice = vntArrisrPrice

    intItemCount = intArrCount

End Sub

Private Sub cmdAddItem_Click(Index As Integer)

    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    
    Dim strStrCount           As String           '開始年齢
    Dim strEndCount           As String           '終了年齢
    Dim strbsdPrice         As String           '団体負担金
    Dim strisrPrice         As String           '健保負担金
    
    'クリックされたインデックスで健保有無を選択
    Set obTargetListView = lsvItem(Index)

    With frmRoundClassPrice
        
        'ガイドに対するプロパティセット
        .StrCount = "0"
        .EndCount = "999.99"
        .BsdPrice = "0"
        .IsrPrice = "0"
    
        .Show vbModal
    
        If .Updated = True Then
            
            strStrCount = .StrCount
            strEndCount = .EndCount
            strbsdPrice = .BsdPrice
            strisrPrice = .IsrPrice
            
            '更新されているなら、リストビューに追加
            Set objItem = obTargetListView.ListItems.Add(, KEY_PREFIX & mintUniqueKey, strStrCount, , "DEFAULTLIST")
            objItem.SubItems(1) = strEndCount
            objItem.SubItems(2) = strbsdPrice
            objItem.SubItems(3) = strisrPrice
        
            mintUniqueKey = mintUniqueKey + 1
            
            'まるめ分類金額管理詳細更新済み
            mblnItemUpdated = True
        
        End If
        
    End With
    
    'オブジェクトの廃棄
    Set frmRoundClassPrice = Nothing
    
End Sub

Private Function ApplyData(blnOkMode As Boolean) As Boolean

    ApplyData = False
    
    '入力チェック
    If CheckValue() = False Then
        Exit Function
    End If
    
    'まるめ分類金額管理管理テーブルの登録
    If RegistRoundClass() = False Then
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
            'まるめ分類金額管理詳細更新済み
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
    
    With frmRoundClassPrice
        
        'ガイドに対するプロパティセット
        .StrCount = obTargetListView.ListItems(intSelectedIndex).Text
        .EndCount = obTargetListView.ListItems(intSelectedIndex).SubItems(1)
        .BsdPrice = obTargetListView.ListItems(intSelectedIndex).SubItems(2)
        .IsrPrice = obTargetListView.ListItems(intSelectedIndex).SubItems(3)
    
        .Show vbModal
    
        If .Updated = True Then
            
            obTargetListView.ListItems(intSelectedIndex).Text = .StrCount
            obTargetListView.ListItems(intSelectedIndex).SubItems(1) = .EndCount
            obTargetListView.ListItems(intSelectedIndex).SubItems(2) = .BsdPrice
            obTargetListView.ListItems(intSelectedIndex).SubItems(3) = .IsrPrice
                
            'まるめ分類金額管理詳細更新済み
            mblnItemUpdated = True
        
        End If
        
    End With

    'オブジェクトの廃棄
    Set frmRoundClassPrice = Nothing

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
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    Do
    
        'まるめ分類情報の取得
        If GetRoundClassInfo() = False Then Exit Do
        
        'まるめ分類金額管理情報のリストビュー格納
        If EditListViewFromCollection() = False Then Exit Do
        
        Ret = True
        Exit Do
    Loop

    txtRoundClassCd.Enabled = (Trim(txtRoundClassCd.Text) = "")

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
        .Add , , "開始個数", 1000, lvwColumnLeft
        .Add , , "終了個数", 1000, lvwColumnLeft
        .Add , , "団体負担金額", 1300, lvwColumnRight
        .Add , , "健保負担金額", 1300, lvwColumnRight
    End With
    objTargetListView.View = lvwReport

End Sub
