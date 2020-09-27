VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmJudClass 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "判定分類テーブルメンテナンス"
   ClientHeight    =   6945
   ClientLeft      =   45
   ClientTop       =   330
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
   Icon            =   "frmJudClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6945
   ScaleWidth      =   6555
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboResultDispMode 
      Height          =   300
      Left            =   1980
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   7
      ToolTipText     =   "面接支援画面にて、判定名称をクリックした場合の検査結果画面を指定します"
      Top             =   1200
      Width           =   3855
   End
   Begin VB.CheckBox chkNotNormalFlg 
      Caption         =   "この判定分類は自動判定処理時に特殊計算を行う(&S)"
      Height          =   255
      Left            =   540
      TabIndex        =   15
      Top             =   5580
      Width           =   4335
   End
   Begin VB.CheckBox chkNotAutoFlg 
      Caption         =   "この判定分類は自動判定処理の対象としない(&O)"
      Height          =   255
      Left            =   240
      TabIndex        =   14
      Top             =   5280
      Width           =   4335
   End
   Begin VB.CheckBox chkCommentOnly 
      Caption         =   "この判定分類はコメントを管理するためのダミー分類(&D)"
      Height          =   255
      Left            =   240
      TabIndex        =   13
      Top             =   4980
      Width           =   4335
   End
   Begin VB.TextBox txtIsrOrganDiv 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   8220
      MaxLength       =   8
      TabIndex        =   20
      Text            =   "@@,@@,@@"
      Top             =   4500
      Width           =   1035
   End
   Begin VB.TextBox txtViewOrder 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1980
      MaxLength       =   3
      TabIndex        =   5
      Text            =   "@@"
      ToolTipText     =   "面接支援画面にて、表示する順番を指定します"
      Top             =   840
      Width           =   495
   End
   Begin VB.Frame Frame2 
      Caption         =   "この判定分類に含まれる検査項目(&I)"
      Height          =   3135
      Left            =   180
      TabIndex        =   8
      Top             =   1680
      Width           =   6255
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "追加(&A)..."
         Height          =   315
         Left            =   3360
         TabIndex        =   11
         Top             =   2700
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "削除(&R)"
         Height          =   315
         Left            =   4740
         TabIndex        =   12
         Top             =   2700
         Width           =   1275
      End
      Begin VB.CommandButton cmdItemProperty 
         Caption         =   "プロパティ(&P)"
         Height          =   315
         Left            =   1980
         TabIndex        =   10
         Top             =   2700
         Visible         =   0   'False
         Width           =   1275
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   2295
         Left            =   120
         TabIndex        =   9
         Top             =   300
         Width           =   5955
         _ExtentX        =   10504
         _ExtentY        =   4048
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
   Begin VB.CheckBox chkAllJudFlg 
      Caption         =   "統計時に総合判定の対象としてカウントする(&T)"
      Height          =   255
      Left            =   240
      TabIndex        =   18
      Top             =   5880
      Width           =   4035
   End
   Begin VB.TextBox txtJudClassName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1980
      MaxLength       =   25
      TabIndex        =   3
      Text            =   "＠＠＠＠"
      Top             =   480
      Width           =   3735
   End
   Begin VB.TextBox txtJudClassCd 
      Height          =   300
      Left            =   1980
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3600
      TabIndex        =   16
      Top             =   6420
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5040
      TabIndex        =   17
      Top             =   6420
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "面接支援からのリンク(&L):"
      Height          =   180
      Index           =   4
      Left            =   180
      TabIndex        =   6
      ToolTipText     =   "面接支援画面にて、判定名称をクリックした場合の検査結果画面を指定します"
      Top             =   1260
      Width           =   1830
   End
   Begin VB.Label Label1 
      Caption         =   "器官区分コード(&K):"
      Height          =   180
      Index           =   3
      Left            =   6660
      TabIndex        =   19
      Top             =   4560
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "判定分類表示順(&J):"
      Height          =   180
      Index           =   2
      Left            =   180
      TabIndex        =   4
      ToolTipText     =   "面接支援画面にて、表示する順番を指定します"
      Top             =   900
      Width           =   1590
   End
   Begin VB.Label Label1 
      Caption         =   "判定分類名(&N):"
      Height          =   180
      Index           =   1
      Left            =   180
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "判定分類コード(&C):"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmJudClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrJudClassCd  As String   '判定分類コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mblnEditItem    As Boolean  '管轄検査項目の更新管理、TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Const mstrListViewKey   As String = "K"

Friend Property Let JudClassCd(ByVal vntNewValue As Variant)

    mstrJudClassCd = vntNewValue
    
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
        If Trim(txtJudClassCd.Text) = "" Then
            MsgBox "判定分類コードが入力されていません。", vbCritical, App.Title
            txtJudClassCd.SetFocus
            Exit Do
        End If

        'コードの数値チェック
        If IsNumeric(txtJudClassCd.Text) = False Then
            MsgBox "判定分類コードは数値で入力してください。", vbCritical, App.Title
            txtJudClassCd.SetFocus
            Exit Do
        End If

        'コードの数値チェック２
        If CInt(txtJudClassCd.Text) < 1 Then
            MsgBox "判定分類コードには負数、ゼロを指定することはできません。", vbCritical, App.Title
            txtJudClassCd.SetFocus
            Exit Do
        End If

        '--------------------------------------------------------------------------------------------
        '判定分類表示順の入力チェック
        If Trim(txtViewOrder.Text) = "" Then txtViewOrder.Text = "999"

        '判定分類表示順の数値チェック
        If IsNumeric(txtViewOrder.Text) = False Then
            MsgBox "判定分類表示順は数値で入力してください。", vbCritical, App.Title
            txtViewOrder.SetFocus
            Exit Do
        End If

        '判定分類表示順の数値チェック２
        If CInt(txtViewOrder.Text) < 1 Then
            MsgBox "判定分類表示順には負数、ゼロを指定することはできません。", vbCritical, App.Title
            txtViewOrder.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtJudClassName.Text) = "" Then
            MsgBox "判定分類名が入力されていません。", vbCritical, App.Title
            txtJudClassName.SetFocus
            Exit Do
        End If

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
Private Function EditJudClass() As Boolean

    Dim objJudClass     As Object           '判定分類アクセス用
    Dim vntJudClassName As Variant          '判定分類名
    Dim vntAlljudFlg    As Variant          '統計用総合判定フラグ
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT アフターケアコードの追加
    Dim vntAfterCareCd  As Variant          'アフターケアコード
'## 2002.11.10 Add End
    Dim vntIsrOrganDiv  As Variant          '器官区分コード
    Dim Ret             As Boolean          '戻り値
    
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
    Dim vntCommentOnly      As Variant      'コメント表示モード
    Dim vntViewOrder        As Variant      '判定分類表示順
    Dim vntResultDispMode   As Variant      '検査結果表示モード（判定リンク用）
    Dim vntNotAutoFlg       As Variant      '自動判定対象外フラグ
    Dim vntNotNormalFlg     As Variant      '通常判定対象外フラグ
'## 2004.02.13 Mod End
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrJudClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '判定分類テーブルレコード読み込み
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT アフターケアコードの追加
'        If objJudClass.SelectJudClass(mstrJudClassCd, vntJudClassName, vntAlljudFlg) = False Then
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
'        If objJudClass.SelectJudClass(mstrJudClassCd, vntJudClassName, vntAlljudFlg, vntAfterCareCd, vntIsrOrganDiv) = False Then
        If objJudClass.SelectJudClass(mstrJudClassCd, vntJudClassName, vntAlljudFlg, vntAfterCareCd, vntIsrOrganDiv, vntCommentOnly, vntViewOrder, vntResultDispMode, vntNotAutoFlg, vntNotNormalFlg) = False Then
'## 2004.02.13 Mod End
'## 2002.11.10 Mod End
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtJudClassCd.Text = mstrJudClassCd
        txtJudClassName.Text = vntJudClassName
        If vntAlljudFlg = "1" Then
            chkAllJudFlg.Value = vbChecked
        End If
        txtIsrOrganDiv.Text = vntIsrOrganDiv
        
'## 2004.02.13 Add By H.Ishihara@FSIT 聖路加専用項目の追加
        txtViewOrder.Text = vntViewOrder
        If vntCommentOnly = "1" Then chkCommentOnly.Value = vbChecked
        If vntNotAutoFlg = "1" Then chkNotAutoFlg.Value = vbChecked
        If vntNotNormalFlg = "1" Then chkNotNormalFlg.Value = vbChecked
        If IsNumeric(vntResultDispMode) Then
            If CInt(vntResultDispMode) <= cboResultDispMode.ListCount Then
                cboResultDispMode.ListIndex = CInt(vntResultDispMode)
            End If
        End If
'## 2004.02.13 Add End
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditJudClass = Ret
    
    Exit Function

ErrorHandle:

    EditJudClass = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : 判定分類管轄の検査項目表示
'
' 機能説明 : 現在設定されている判定分類内検査項目を表示する
'
' 備考　　 :
'
Private Function EditListItem() As Boolean
    
On Error GoTo ErrorHandle

    Dim objJudClass     As Object               '判定分類項目アクセス用
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    Dim vntItemCd       As Variant              'コード
    Dim vntItemName     As Variant              '名称
    Dim vntClassName    As Variant              '検査分類名称
    
    Dim vntSuffix       As Variant              '項目区分
    Dim lngCount        As Long                 'レコード数
    
    Dim i               As Long                 'インデックス

    EditListItem = False

    'リストアイテムクリア
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    'オブジェクトのインスタンス作成
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    
    '判定分類管轄検査項目検索（開始、終了日は履歴番号を指定しているため、不要）
    lngCount = objJudClass.SelectJudClassItemList(mstrJudClassCd, _
                                                  vntItemCd, _
                                                  , _
                                                  vntItemName, _
                                                  vntClassName)
    
    'ヘッダの編集
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "コード", 1000, lvwColumnLeft
        .Add , , "名称", 2800, lvwColumnLeft
        .Add , , "検査分類", 1200, lvwColumnLeft
    End With
        
    lsvItem.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, mstrListViewKey & vntItemCd(i), vntItemCd(i))
        objItem.SubItems(1) = vntItemName(i)
        objItem.SubItems(2) = vntClassName(i)
    Next i
    
    '項目が１行以上存在した場合、無条件に先頭が選択されるため解除する。
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    EditListItem = True
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
Private Function RegistJudClass() As Boolean

On Error GoTo ErrorHandle

    Dim objJudClass     As Object       '判定分類アクセス用
    Dim Ret             As Long
    Dim i               As Integer
    Dim j               As Integer
    Dim intItemCount    As Integer
    Dim vntItemCd()     As Variant
    
    RegistJudClass = False

    intItemCount = 0
    Erase vntItemCd
    j = 0

    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvItem.ListItems.Count
        
        ReDim Preserve vntItemCd(j)
        vntItemCd(j) = lsvItem.ListItems.Item(i).Text
        
        j = j + 1
        intItemCount = intItemCount + 1
    
    Next i

    'オブジェクトのインスタンス作成
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    
    '判定分類テーブルレコードの登録
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT アフターケアコードの追加
'    Ret = objJudClass.RegistJudClass_All(IIf(txtJudClassCd.Enabled, "INS", "UPD"), _
                                         Trim(txtJudClassCd.Text), _
                                         Trim(txtJudClassName.Text), _
                                         IIf(chkAllJudFlg.Value = vbChecked, 1, 0), _
                                         intItemCount, _
                                         vntItemCd)
    Ret = objJudClass.RegistJudClass_All(IIf(txtJudClassCd.Enabled, "INS", "UPD"), _
                                         Trim(txtJudClassCd.Text), _
                                         Trim(txtJudClassName.Text), _
                                         IIf(chkAllJudFlg.Value = vbChecked, 1, 0), _
                                         Trim(txtViewOrder.Text), _
                                         intItemCount, _
                                         vntItemCd, _
                                         Trim(txtIsrOrganDiv.Text), _
                                         IIf(chkCommentOnly.Value = vbChecked, 1, ""), _
                                         CInt(Trim(txtViewOrder.Text)), _
                                         IIf(cboResultDispMode.ListIndex = 0, "", cboResultDispMode.ListIndex), _
                                         IIf(chkNotAutoFlg.Value = vbChecked, 1, ""), _
                                         IIf(chkNotNormalFlg.Value = vbChecked, 1, ""))
'## 2002.11.10 Mod End

    If Ret = 0 Then
        MsgBox "入力された判定分類コードは既に存在します。", vbExclamation
        RegistJudClass = False
        Exit Function
    End If
    
    '登録済み判定分類コードとしてセット（新規＋検査項目登録用）
    mstrJudClassCd = Trim(txtJudClassCd.Text)
    RegistJudClass = True
    
    Exit Function
    
ErrorHandle:

    RegistJudClass = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub chkCommentOnly_Click()

    chkNotAutoFlg.Enabled = True
    
    If chkCommentOnly.Value = vbChecked Then
        chkNotAutoFlg.Value = vbChecked
        chkNotAutoFlg.Enabled = False
    End If

End Sub

Private Sub chkNotAutoFlg_Click()

    chkNotNormalFlg.Enabled = True
    
    If chkNotAutoFlg.Value = vbChecked Then
        chkNotNormalFlg.Value = vbUnchecked
        chkNotNormalFlg.Enabled = False
    End If
    
End Sub

Private Sub cmdAddItem_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '項目ガイド表示用
    Dim objItem         As ListItem                 'リストアイテムオブジェクト
    
    Dim lngCount        As Long     'レコード数
    Dim i               As Long     'インデックス
    Dim strKey          As String   '重複チェック用のキー
    
    Dim lngItemCount    As Long     '選択項目数
    Dim vntItemCd       As Variant  '選択された項目コード
    Dim vntItemName     As Variant  '選択された項目名
    Dim vntClassName    As Variant  '選択された検査分類名
    
    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_REQUEST
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
    
        'コーステーブルメンテナンス画面を開く
        .Show vbModal
        
        '戻り値としてのプロパティ取得
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
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
            strKey = mstrListViewKey & vntItemCd(i)
            If CheckExistsItemCd(lsvItem, strKey) = False Then
            
                'なければ追加する
                Set objItem = lsvItem.ListItems.Add(, strKey, vntItemCd(i))
                objItem.SubItems(1) = vntItemName(i)
                objItem.SubItems(2) = vntClassName(i)
            
                '更新状態を管理
                mblnEditItem = True
            
            End If
        Next i
    
    End If

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault

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
        If CheckValue() = False Then Exit Do
        
        '判定分類テーブルの登録
        If RegistJudClass() = False Then Exit Do
            
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
    mblnEditItem = False

    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    With cboResultDispMode
        .Clear
        .AddItem ""
        .AddItem "診察、体格、血圧・心拍数"
        .AddItem "心電図"
        .AddItem "胸部X線"
        .AddItem "上部消化管・便潜血　検査結果表示"
        .AddItem "上腹部超音波"
        .AddItem "血液"
        .AddItem "糖代謝・脂質代謝"
        .AddItem "尿酸・肝機能・腎機能"
        .AddItem "電解質・血清・尿検査・前立腺"
        .AddItem "視力・眼底・聴力・骨密度"
        .AddItem "乳房・婦人科"
        .AddItem "大腸内視鏡"
        .AddItem "胸部CT"
'#### 2011.07.07 SL-SN-Y0101-305 ADD START ####
        .AddItem ""
        .AddItem "大腸３Ｄ－ＣＴ"
        .AddItem "頸動脈超音波"
        .AddItem "動脈硬化"
        .AddItem "内臓脂肪面積"
        .AddItem "心不全スクリーニング"
'#### 2011.07.07 SL-SN-Y0101-305 ADD END ####
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
        .AddItem "婦人科超音波"
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
    End With

    Do
        '判定分類情報の編集
        If EditJudClass() = False Then
            Exit Do
        End If
    
        '判定分類管轄の検査項目編集
        If EditListItem() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtJudClassCd.Enabled = (txtJudClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
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


