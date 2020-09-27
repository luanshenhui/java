VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmBillClass 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "請求書分類テーブルメンテナンス"
   ClientHeight    =   7095
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7320
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmBillClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7095
   ScaleWidth      =   7320
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin TabDlg.SSTab tabMain 
      Height          =   6435
      Left            =   120
      TabIndex        =   17
      Top             =   120
      Width           =   7095
      _ExtentX        =   12515
      _ExtentY        =   11351
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "基本情報"
      TabPicture(0)   =   "frmBillClass.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Label2(2)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Frame1"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "txtBillTitle"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).ControlCount=   3
      TabCaption(1)   =   "請求対象コース"
      TabPicture(1)   =   "frmBillClass.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraItemMain"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).ControlCount=   1
      Begin VB.TextBox txtBillTitle 
         Height          =   318
         IMEMode         =   4  '全角ひらがな
         Left            =   2700
         MaxLength       =   60
         TabIndex        =   10
         Text            =   "胸部レントゲン"
         Top             =   3300
         Width           =   3915
      End
      Begin VB.Frame fraItemMain 
         Caption         =   "この請求書を作成する時に対象となるコース(&I)"
         Height          =   5595
         Left            =   -74820
         TabIndex        =   11
         Top             =   540
         Width           =   6675
         Begin VB.CommandButton cmdChangeMode 
            Caption         =   "請求対象状態の変更(&A)"
            Height          =   315
            Left            =   4260
            TabIndex        =   13
            Top             =   5040
            Width           =   2175
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   4260
            Left            =   180
            TabIndex        =   12
            Top             =   720
            Width           =   6315
            _ExtentX        =   11139
            _ExtentY        =   7514
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
         Begin VB.Label Label3 
            Caption         =   "項目を選択してボタンを押すと選択、非選択状態が切り替わります。"
            Height          =   255
            Left            =   240
            TabIndex        =   18
            Top             =   360
            Width           =   6075
         End
      End
      Begin VB.Frame Frame1 
         Caption         =   "基本情報(&B)"
         Height          =   2355
         Left            =   180
         TabIndex        =   0
         Top             =   540
         Width           =   6675
         Begin VB.TextBox txtBillClassName 
            Height          =   318
            IMEMode         =   4  '全角ひらがな
            Left            =   1920
            MaxLength       =   15
            TabIndex        =   4
            Text            =   "胸部レントゲン"
            Top             =   660
            Width           =   2775
         End
         Begin VB.TextBox txtBillClassCd 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1920
            MaxLength       =   4
            TabIndex        =   2
            Text            =   "1324"
            Top             =   300
            Width           =   675
         End
         Begin VB.CheckBox chkOtherIncome 
            Caption         =   "この請求書分類は雑収入として扱う(&Z)"
            Height          =   255
            Left            =   1920
            TabIndex        =   5
            Top             =   1140
            Width           =   3195
         End
         Begin VB.CheckBox chkDefCheck 
            Caption         =   "この請求書分類は団体新規登録時にデフォルトでチェック(&O)"
            Height          =   315
            Left            =   1920
            TabIndex        =   6
            Top             =   1380
            Width           =   4575
         End
         Begin VB.TextBox txtCrfFileName 
            Height          =   318
            IMEMode         =   4  '全角ひらがな
            Left            =   1920
            MaxLength       =   15
            TabIndex        =   8
            Text            =   "胸部レントゲン"
            Top             =   1740
            Width           =   2895
         End
         Begin VB.Label Label2 
            Caption         =   "請求書分類名(&N):"
            Height          =   195
            Index           =   0
            Left            =   240
            TabIndex        =   3
            Top             =   720
            Width           =   1455
         End
         Begin VB.Label Label1 
            Caption         =   "請求書分類コード(&C):"
            Height          =   195
            Index           =   2
            Left            =   240
            TabIndex        =   1
            Top             =   360
            Width           =   1635
         End
         Begin VB.Label Label2 
            Caption         =   "帳票ファイル名(&P):"
            Height          =   195
            Index           =   1
            Left            =   240
            TabIndex        =   7
            Top             =   1800
            Width           =   1455
         End
      End
      Begin VB.Label Label2 
         Caption         =   "健保請求内訳書用タイトル(&T):"
         Height          =   195
         Index           =   2
         Left            =   420
         TabIndex        =   9
         Top             =   3360
         Width           =   2235
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4560
      TabIndex        =   15
      Top             =   6660
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3180
      TabIndex        =   14
      Top             =   6660
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
      Height          =   315
      Left            =   5940
      TabIndex        =   16
      Top             =   6660
      Width           =   1275
   End
End
Attribute VB_Name = "frmBillClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'プロパティ用領域
Private mstrBillClassCd     As String   '請求書分類コード
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnInitialize      As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗

'モジュール固有領域領域
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション
Private mstrClassCd()           As String       '検査分類コード（配列は、コンボボックスと対応）

Const mstrListViewKey   As String = "K"

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property

' @(e)
'
' 機能　　 : 「適用」クリック
'
' 引数　　 : なし
'
' 機能説明 : 入力内容を適用する。画面は閉じない
'
' 備考　　 :
'
Private Sub cmdApply_Click()
    
    'データ適用処理を行う
    Call ApplyData

End Sub


Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : 基本請求書分類情報画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 請求書分類の基本情報を画面に表示する
'
' 備考　　 :
'
Private Function EditBillClass() As Boolean

    Dim objBillClass        As Object       '請求書分類情報アクセス用
    
    Dim vntBillClassName    As Variant
    Dim vntDefCheck         As Variant
    Dim vntOtherIncome      As Variant
    Dim vntCrfFileName      As Variant
    Dim vntBillTitle        As Variant

    Dim vntCsCd             As Variant
    Dim vntCsName           As Variant

    Dim objHeader           As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem             As ListItem             'リストアイテムオブジェクト

    Dim lngCount            As Long                 'レコード数
    Dim Ret                 As Boolean      '戻り値
    Dim i                   As Integer
    
    EditBillClass = False
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objBillClass = CreateObject("HainsDmdClass.DmdClass")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrBillClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '請求書分類テーブルレコード読み込み
        If objBillClass.SelectBillClass(mstrBillClassCd, _
                                        vntBillClassName, _
                                        vntDefCheck, _
                                        vntOtherIncome, _
                                        vntCrfFileName, _
                                        vntBillTitle) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If

        '読み込み内容の編集（コース基本情報）
        txtBillClassCd.Text = mstrBillClassCd
        txtBillClassName.Text = vntBillClassName
        If vntDefCheck = "1" Then chkDefCheck.Value = vbChecked
        If vntOtherIncome = "1" Then chkOtherIncome.Value = vbChecked
        txtCrfFileName.Text = vntCrfFileName
        txtBillTitle.Text = vntBillTitle
        
        '請求書分類管理コースの読み込み
        lngCount = objBillClass.SelectBillClass_cList(mstrBillClassCd, vntCsCd, vntCsName)
    
        '請求対象コースの編集
        For i = 0 To lngCount - 1

            Set objItem = lsvItem.ListItems(mstrListViewKey & vntCsCd(i))
            objItem.SubItems(2) = "請求対象"

        Next i

        '項目が１行以上存在した場合、無条件に先頭が選択されるため解除する。
        If lsvItem.ListItems.Count > 0 Then
            lsvItem.ListItems(1).Selected = False
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditBillClass = Ret
    
    Set objBillClass = Nothing
    Exit Function

ErrorHandle:

    EditBillClass = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub cmdDownItem_Click()
    
    Call MoveListItem(1)

End Sub

' @(e)
'
' 機能　　 : コース管理状態の変更
'
' 引数　 　: TRUE:管理する、FALSE:管理からはずす
'
' 機能説明 : 予約枠内コース項目の管理状態を変更する
'
' 備考　　 :
'
Private Sub ChangeItemMode()

    Dim i As Integer
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvItem.ListItems.Count
        
        'インデックスがリスト項目を越えたら終了
        If i > lsvItem.ListItems.Count Then Exit For
        
        '選択されている項目なら処理
        If lsvItem.ListItems(i).Selected = True Then
            If lsvItem.ListItems(i).SubItems(2) <> "" Then
                lsvItem.ListItems(i).SubItems(2) = ""
            Else
                lsvItem.ListItems(i).SubItems(2) = "請求対象"
            End If
        End If
    
    Next i

End Sub

Private Sub cmdChangeMode_Click()
    
    Call ChangeItemMode

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
    
    'データ適用処理を行う（エラー時は画面を閉じない）
    If ApplyData() = False Then
        Exit Sub
    End If

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
        
        '請求書分類テーブルの登録
        If RegistBillClass() = False Then Exit Do
        
        '更新済みにする
        mblnUpdated = True
        
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
    
    '初期処理
    Ret = False
    
    Do
        
        If Trim(txtBillClassCd.Text) = "" Then
            MsgBox "請求書分類コードが入力されていません。", vbExclamation, App.Title
            txtBillClassCd.SetFocus
            Exit Do
        End If

        If Trim(txtBillClassName.Text) = "" Then
            MsgBox "請求書分類名が入力されていません。", vbExclamation, App.Title
            txtBillClassName.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

' @(e)
'
' 機能　　 : 請求書分類基本情報の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容を請求書分類テーブルに保存する。
'
' 備考　　 :
'
Private Function RegistBillClass() As Boolean

On Error GoTo ErrorHandle

    Dim objBillClass    As Object     '請求書分類アクセス用
    Dim strCrfFileName  As String
    Dim lngRet          As Long
    
    Dim i               As Integer
    Dim j               As Integer
    Dim k               As Integer
    Dim intItemCount    As Integer
    
    Dim vntCsCd()       As Variant
    
    Dim strWorkKey      As String
    Dim strCsCd         As String
    Dim strSuffix       As String
    
    RegistBillClass = False

    intItemCount = 0
    Erase vntCsCd
    j = 0

    '請求書分類内検査項目の配列作成
    For i = 1 To lsvItem.ListItems.Count
        
        If lsvItem.ListItems(i).SubItems(2) <> "" Then
            ReDim Preserve vntCsCd(j)
            vntCsCd(j) = lsvItem.ListItems(i).Text
            intItemCount = intItemCount + 1
            j = j + 1
        End If
    
    Next i

    'オブジェクトのインスタンス作成
    Set objBillClass = CreateObject("HainsDmdClass.DmdClass")

    '請求書分類テーブルレコードの登録
    lngRet = objBillClass.RegistBillClass_All(IIf(txtBillClassCd.Enabled, "INS", "UPD"), _
                                              Trim(txtBillClassCd.Text), _
                                              Trim(txtBillClassName.Text), _
                                              IIf(chkDefCheck.Value = vbChecked, 1, 0), _
                                              IIf(chkOtherIncome.Value = vbChecked, 1, 0), _
                                              Trim(txtCrfFileName.Text), _
                                              intItemCount, _
                                              vntCsCd, _
                                              Trim(txtBillTitle.Text))
    
    If lngRet = 0 Then
        MsgBox "入力された請求書分類コードは既に存在します。", vbExclamation
        Exit Function
    End If
    
    mstrBillClassCd = Trim(txtBillClassCd.Text)
    txtBillClassCd.Enabled = (txtBillClassCd.Text = "")
    
    Set objBillClass = Nothing
    RegistBillClass = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objBillClass = Nothing
    RegistBillClass = False
    
End Function

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
    Call InitFormControls(Me, mcolGotFocusCollection)      '使用コントロール初期化

    tabMain.Tab = 0
    
    Do
        'コース一覧の編集
        If EditCourseItem() = False Then
            Exit Do
        End If
        
        '請求書分類情報の表示編集
        If EditBillClass() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtBillClassCd.Enabled = (txtBillClassCd.Text = "")
        
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
' 機能　　 : コース一覧表示
'
' 機能説明 : コースを表示する。
'
' 備考　　 :
'
Private Function EditCourseItem() As Boolean
    
On Error GoTo ErrorHandle

    Dim objCourse       As Object               '
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    Dim vntCsCd         As Variant              'コースコード
    Dim vntCsName       As Variant              'コース名
    Dim lngCount        As Long                 'レコード数
    Dim strItemKey      As String               'リストビュー用アイテムキー
    Dim strItemCodeString As String             '表示用キー編集領域
    
    Dim i               As Long                 'インデックス

    EditCourseItem = False

    'リストアイテムクリア
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
    
    'コース一覧取得（メインのみ）
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName, , 3)

    'ヘッダの編集
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "コースコード", 1000, lvwColumnLeft
        .Add , , "コース名称", 2000, lvwColumnLeft
        .Add , , "請求対象", 2000, lvwColumnLeft
    End With
        
    lsvItem.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, mstrListViewKey & vntCsCd(i), vntCsCd(i))
        objItem.SubItems(1) = vntCsName(i)
        objItem.SubItems(2) = ""
    Next i
    
    '項目が１行以上存在した場合、無条件に先頭が選択されるため解除する。
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    EditCourseItem = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Friend Property Get BillClassCd() As Variant

    BillClassCd = mstrBillClassCd
    
End Property

Friend Property Let BillClassCd(ByVal vNewValue As Variant)
    
    mstrBillClassCd = vNewValue

End Property

' @(e)
'
' 機能　　 : 受診項目一覧カラムクリック
'
' 機能説明 : クリックされたカラム項目でSortを行う
'
' 備考　　 :
'
Private Sub lsvItem_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    
    'マウスポインタが砂時計のときは入力無視
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    With lsvItem
        .SortKey = ColumnHeader.Index - 1
        .Sorted = True
        .SortOrder = IIf(.SortOrder = lvwAscending, lvwDescending, lvwAscending)
    End With

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
Private Sub MoveListItem(intMovePosition As Integer)

    Dim i                   As Integer
    Dim j                   As Integer
    Dim objItem             As ListItem
    
    Dim intSelectedCount    As Integer
    Dim intSelectedIndex    As Integer
    Dim intTargetIndex      As Integer
    Dim intScrollPoint      As Integer
    
    Dim strEscKey()         As String
    Dim strEscCd()          As String
    Dim strEscName()        As String
    Dim strEscClassName()   As String
    
    intSelectedCount = 0

    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvItem.ListItems.Count

        '選択されている項目なら
        If lsvItem.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '選択項目数が１個以外なら処理しない
    If intSelectedCount <> 1 Then Exit Sub
    
    '項目Up指定かつ、選択項目が先頭なら何もしない
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '項目Down指定かつ、選択項目が最終なら何もしない
    If (intSelectedIndex = lsvItem.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    If intMovePosition = -1 Then
        '項目Upの場合、一つ前の要素をターゲットとする。
        intTargetIndex = intSelectedIndex - 1
    Else
        '項目Downの場合、現在の要素をターゲットとする。
        intTargetIndex = intSelectedIndex
    End If
    
    '現在表示上の先頭Indexを取得
    intScrollPoint = lsvItem.GetFirstVisible.Index
    
    'リストビューをくるくる回して全項目配列作成
    For i = 1 To lsvItem.ListItems.Count
        ReDim Preserve strEscKey(i)
        ReDim Preserve strEscCd(i)
        ReDim Preserve strEscName(i)
        ReDim Preserve strEscClassName(i)
        
        '処理対象配列番号時処理
        If intTargetIndex = i Then
        
            '項目退避
            strEscKey(i) = lsvItem.ListItems(i + 1).Key
            strEscCd(i) = lsvItem.ListItems(i + 1)
            strEscName(i) = lsvItem.ListItems(i + 1).SubItems(1)
            strEscClassName(i) = lsvItem.ListItems(i + 1).SubItems(2)
        
            i = i + 1
        
            ReDim Preserve strEscKey(i)
            ReDim Preserve strEscCd(i)
            ReDim Preserve strEscName(i)
            ReDim Preserve strEscClassName(i)
        
            strEscKey(i) = lsvItem.ListItems(intTargetIndex).Key
            strEscCd(i) = lsvItem.ListItems(intTargetIndex)
            strEscName(i) = lsvItem.ListItems(intTargetIndex).SubItems(1)
            strEscClassName(i) = lsvItem.ListItems(intTargetIndex).SubItems(2)
        
        Else
            strEscKey(i) = lsvItem.ListItems(i).Key
            strEscCd(i) = lsvItem.ListItems(i)
            strEscName(i) = lsvItem.ListItems(i).SubItems(1)
            strEscClassName(i) = lsvItem.ListItems(i).SubItems(2)
        
        End If
    
    Next i
    
    lsvItem.ListItems.Clear
    
    'ヘッダの編集
    With lsvItem.ColumnHeaders
        .Clear
        .Add , , "コード", 1000, lvwColumnLeft
        .Add , , "名称", 2000, lvwColumnLeft
        .Add , , "検査分類", 1200, lvwColumnLeft
    End With
    
    'リストの編集
    For i = 1 To UBound(strEscKey)
        Set objItem = lsvItem.ListItems.Add(, strEscKey(i), strEscCd(i))
        objItem.SubItems(1) = strEscName(i)
        objItem.SubItems(2) = strEscClassName(i)
    Next i

    lsvItem.ListItems(1).Selected = False
    
    '移動した項目を選択させ、移動（スクロール）させる
    If intMovePosition = 1 Then
        lsvItem.ListItems(intTargetIndex + 1).Selected = True
    Else
        lsvItem.ListItems(intTargetIndex).Selected = True
    End If

    '選択されている項目を表示する
    lsvItem.SelectedItem.EnsureVisible

    lsvItem.SetFocus

End Sub

Private Sub lsvItem_DblClick()

    Call ChangeItemMode

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


Private Sub TabStrip1_Click()

End Sub

