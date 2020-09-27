VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmSecurityPgmGrp2 
   Caption         =   "セキュリティーグループ　プログラム"
   ClientHeight    =   8086
   ClientLeft      =   5317
   ClientTop       =   1521
   ClientWidth     =   6929
   Icon            =   "frmSecurityPgmGrp2.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   8086
   ScaleWidth      =   6929
   Begin VB.Frame Frame4 
      Height          =   559
      Left            =   130
      TabIndex        =   26
      Top             =   7332
      Width           =   6513
      Begin VB.OptionButton optGrant 
         Caption         =   "参照"
         Height          =   247
         Index           =   0
         Left            =   1690
         TabIndex        =   30
         Top             =   208
         Value           =   -1  'True
         Width           =   637
      End
      Begin VB.OptionButton optGrant 
         Caption         =   "登録、修正"
         Height          =   247
         Index           =   1
         Left            =   2652
         TabIndex        =   29
         Top             =   208
         Width           =   1079
      End
      Begin VB.OptionButton optGrant 
         Caption         =   "削除"
         Height          =   247
         Index           =   2
         Left            =   4056
         TabIndex        =   28
         Top             =   208
         Width           =   689
      End
      Begin VB.OptionButton optGrant 
         Caption         =   "すべて"
         Height          =   247
         Index           =   3
         Left            =   5070
         TabIndex        =   27
         Top             =   208
         Width           =   767
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "操作権限区分 ："
         Height          =   169
         Index           =   2
         Left            =   156
         TabIndex        =   31
         Top             =   234
         Width           =   1157
      End
   End
   Begin VB.TextBox txtGrpCd 
      Appearance      =   0  'ﾌﾗｯﾄ
      Height          =   273
      Index           =   1
      Left            =   6318
      TabIndex        =   25
      Top             =   1456
      Visible         =   0   'False
      Width           =   975
   End
   Begin VB.TextBox txtGrpCd 
      Appearance      =   0  'ﾌﾗｯﾄ
      Height          =   273
      Index           =   0
      Left            =   6318
      TabIndex        =   24
      Top             =   1066
      Visible         =   0   'False
      Width           =   975
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
      Height          =   315
      Left            =   5278
      TabIndex        =   15
      Top             =   6890
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2522
      TabIndex        =   14
      Top             =   6890
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3900
      TabIndex        =   13
      Top             =   6890
      Width           =   1275
   End
   Begin VB.Frame Frame2 
      Caption         =   "プルグラムリスト"
      Height          =   4719
      Left            =   130
      TabIndex        =   6
      Top             =   2002
      Width           =   6513
      Begin VB.CommandButton cmdUpdateItem 
         Caption         =   "修正(&U)..."
         Height          =   312
         Left            =   3822
         TabIndex        =   12
         Top             =   4264
         Width           =   1196
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "追加(&A)..."
         Height          =   312
         Left            =   2548
         TabIndex        =   11
         Top             =   4264
         Width           =   1196
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "削除(&R)"
         Height          =   312
         Left            =   5096
         TabIndex        =   10
         Top             =   4264
         Width           =   1196
      End
      Begin VB.CommandButton cmdUpItem 
         Caption         =   "↑"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   8.75
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   182
         TabIndex        =   9
         Top             =   1482
         Width           =   315
      End
      Begin VB.CommandButton cmdDownItem 
         Caption         =   "↓"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   8.75
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   182
         TabIndex        =   8
         Top             =   2028
         Width           =   315
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   3965
         Left            =   572
         TabIndex        =   7
         Top             =   338
         Width           =   6006
         _ExtentX        =   10587
         _ExtentY        =   7003
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "基本情報(&B)"
      Height          =   1131
      Left            =   130
      TabIndex        =   0
      Top             =   780
      Width           =   6513
      Begin VB.TextBox txtUserGrp 
         Appearance      =   0  'ﾌﾗｯﾄ
         Height          =   273
         Index           =   1
         Left            =   2106
         TabIndex        =   23
         Top             =   676
         Visible         =   0   'False
         Width           =   2119
      End
      Begin VB.TextBox txtUserGrp 
         Appearance      =   0  'ﾌﾗｯﾄ
         Height          =   273
         Index           =   0
         Left            =   2106
         TabIndex        =   22
         Top             =   286
         Visible         =   0   'False
         Width           =   2119
      End
      Begin VB.ComboBox cboGrp 
         Height          =   273
         Index           =   1
         Left            =   4498
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   4
         Top             =   676
         Visible         =   0   'False
         Width           =   2145
      End
      Begin VB.ComboBox cboGrp 
         Height          =   273
         Index           =   0
         Left            =   4472
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   3
         Top             =   286
         Visible         =   0   'False
         Width           =   2145
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "セキュリティーグループ"
         Height          =   169
         Index           =   1
         Left            =   208
         TabIndex        =   2
         Top             =   702
         Width           =   1625
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "ユーザーグループ"
         Height          =   169
         Index           =   0
         Left            =   208
         TabIndex        =   1
         Top             =   390
         Width           =   1261
      End
   End
   Begin VB.Frame Frame3 
      Height          =   559
      Left            =   130
      TabIndex        =   16
      Top             =   8710
      Visible         =   0   'False
      Width           =   6513
      Begin VB.CheckBox chkGrant 
         Caption         =   "参照"
         Height          =   273
         Index           =   0
         Left            =   1638
         TabIndex        =   20
         Top             =   182
         Value           =   1  'ﾁｪｯｸ
         Width           =   793
      End
      Begin VB.CheckBox chkGrant 
         Caption         =   "登録、修正"
         Height          =   273
         Index           =   1
         Left            =   2522
         TabIndex        =   19
         Top             =   182
         Width           =   1105
      End
      Begin VB.CheckBox chkGrant 
         Caption         =   "削除"
         Height          =   273
         Index           =   2
         Left            =   3796
         TabIndex        =   18
         Top             =   182
         Width           =   767
      End
      Begin VB.CheckBox chkGrant 
         Caption         =   "ALL"
         Height          =   273
         Index           =   3
         Left            =   4628
         TabIndex        =   17
         Top             =   182
         Width           =   689
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "操作権限区分 ："
         Height          =   169
         Index           =   4
         Left            =   182
         TabIndex        =   21
         Top             =   234
         Width           =   1157
      End
   End
   Begin VB.Label LabelCourseGuide 
      Caption         =   "プログラム使用権限をグループとしてとりまとめます。"
      Height          =   260
      Left            =   871
      TabIndex        =   5
      Top             =   299
      Width           =   3913
   End
   Begin VB.Image Image1 
      Height          =   416
      Index           =   0
      Left            =   208
      Picture         =   "frmSecurityPgmGrp2.frx":000C
      Top             =   182
      Width           =   416
   End
End
Attribute VB_Name = "frmSecurityPgmGrp2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'プロパティ用領域
Public mstrUserGrpCd           As String   '
Public mstrUserGrpName         As String   '
Public mstrSecurityGrpCd       As String   '
Public mstrSecurityGrpName     As String   '
Public iMode                   As Integer
Public mblnInitialize          As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗

Private mblnUpdated             As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly            As Boolean  'TRUE:データの更新をしない（参照のみ）
Private mintPgmGrant        As Integer

'モジュール固有領域領域
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション
Private aryUserGrpCd()          As String       'User Group（配列は、コンボボックスと対応）
Private arySecurityGrpCd()       As String       'Security Group（配列は、コンボボックスと対応）

Const mstrListViewKey   As String = "K"

Private Sub SetListTitle()
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "プログラムコード", 1400, lvwColumnLeft
    objHeader.Add , , "プログラム名", 4000, lvwColumnLeft
    objHeader.Add , , "使用権限", 500, lvwColumnLeft
    
    lsvItem.View = lvwReport

End Sub

Private Sub cboGrp_Click(Index As Integer)
    
    If Index = 0 Then
        txtGrpCd(Index).Text = aryUserGrpCd(cboGrp(Index).ListIndex)
    ElseIf Index = 1 Then
        txtGrpCd(Index).Text = arySecurityGrpCd(cboGrp(Index).ListIndex)
    End If
    
End Sub



Private Sub chkGrant_Click(Index As Integer)
    Dim i   As Integer
    
    Select Case Index
        Case 3
            If chkGrant(Index).Value = 1 Then
                For i = 0 To 2
                    chkGrant(i).Value = 1
                    chkGrant(i).Enabled = False
                Next
            Else
                For i = 0 To 2
                    chkGrant(i).Value = 0
                    chkGrant(i).Enabled = True
                Next
            End If
            
        Case Else
            If chkGrant(3).Value = 1 Then Exit Sub
            If chkGrant(0).Value = 1 And chkGrant(1).Value = 1 And chkGrant(2).Value = 1 Then
                chkGrant(3).Value = 1
                Call chkGrant_Click(3)
            Else
                chkGrant(3).Value = 0
            End If
            
    End Select

End Sub

Private Sub cmdAddItem_Click()
    Dim objItemGuide    As mntPgmInfoGuide.ItemGuide    '項目ガイド表示用
    Dim objItem         As ListItem                     'リストアイテムオブジェクト
    
    Dim i               As Integer
    Dim strKey          As String       '重複チェック用のキー
    Dim strItemString   As String
    Dim strItemKey      As String       'リストビュー用アイテムキー
    Dim strItemCdString As String       '表示用キー編集領域
    
    Dim vntPgmCd       As Variant       '選択された項目コード
    Dim vntPgmName     As Variant       '選択された項目名
    
    Dim lngItemCount    As Long     '選択項目数
    Dim vntItemCd       As Variant  '選択された項目コード
    Dim vntItemName     As Variant  '選択された項目名
    Dim vntItemGrant    As Variant  '選択された検査分類名
    
    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntPgmInfoGuide.ItemGuide
    
    With objItemGuide
        'コーステーブルメンテナンス画面を開く
        .Show vbModal
        
        '戻り値としてのプロパティ取得
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntItemName = .ItemName
        vntItemGrant = .ItemGrant
   
    End With
    
    Screen.MousePointer = vbHourglass
    Me.Refresh
        
    '選択件数が0件以上なら
    If lngItemCount > 0 Then
    
        'リストの編集
        For i = 0 To lngItemCount - 1
            strItemCdString = vntItemCd(i)
            strItemKey = mstrListViewKey & strItemCdString
            
             'リスト上に存在するかチェックする
            If CheckExistsItemCd(lsvItem, strItemKey) = False Then
                'なければ追加する
                Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
                objItem.SubItems(1) = vntItemName(i)
                objItem.SubItems(2) = vntItemGrant(i)
            
            End If
            
            
        Next i
    
    End If

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault
    
End Sub

' 機能　　 : データの保存
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
' 機能説明 : 変更されたデータをテーブルに保存する
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
        
        'グループテーブルの登録
        If RegistGrp() = False Then Exit Do
        
        '更新済みにする
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Function

Private Function CheckValue() As Boolean
    Dim Ret             As Boolean  '関数戻り値
    
    '初期処理
    Ret = False
    
    Do

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function


' 機能　　 :
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容をグループテーブルに保存する。
'
' 備考　　 :
'
Private Function RegistGrp() As Boolean
    On Error GoTo ErrorHandle

    Dim objGrp              As Object     'グループアクセス用
    Dim strSearchChar       As String
    Dim lngRet              As Long
    Dim i                   As Integer
    Dim j                   As Integer
    Dim k                   As Integer
    Dim intItemCount        As Integer
    Dim vntPgmCd()          As Variant           'プログラムコード
    Dim vntGrant()          As Variant           '操作権限
    Dim vntseq()            As Variant          '画面標示順序
    Dim strWorkKey          As String
    Dim strPgmCd            As String
    
    j = 0
    k = 0
    intItemCount = 0
    
    Erase vntPgmCd
    Erase vntGrant
    Erase vntseq
    
    RegistGrp = False

    'グループ項目の配列作成
    For i = 1 To lsvItem.ListItems.Count
        ReDim Preserve vntPgmCd(j)
        ReDim Preserve vntGrant(j)
        ReDim Preserve vntseq(j)

        'リストビュー用のキープリフィックスを削除
        strWorkKey = Mid(lsvItem.ListItems(i).Key, 2, Len(lsvItem.ListItems(i).Key))

        'グループ区分が検査タイプならサフィックスと分割
        vntPgmCd(j) = lsvItem.ListItems(i).Text
        vntGrant(j) = lsvItem.ListItems(i).SubItems(2)
        vntseq(j) = lsvItem.ListItems(i).SubItems(3)
        
        j = j + 1
        intItemCount = intItemCount + 1
    Next i

    'オブジェクトのインスタンス作成
'    Set objGrp = CreateObject("HainsPgmInfo.PgmInfo")
'
'    lngRet = objGrp.RegistGrp_PgmInfo(IIf(cboGrp(1).Enabled, "INS", "UPD"), _
                                mstrSecurityGrpCd, _
                                Trim(txtGrpName.Text), _
                                vntPgmCd, _
                                vntGrant)
    
    If lngRet = 0 Then
        MsgBox "入力されたグループコードは既に存在します。", vbExclamation
        Exit Function
    End If
    
'    mstrGrpCd = Trim(txtGrpCd.Text)
'    txtGrpCd.Enabled = (txtGrpCd.Text = "")
    
'    Set objGrp = Nothing
    RegistGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objGrp = Nothing
    RegistGrp = False
    
End Function



Private Sub cmdApply_Click()
    'データ適用処理を行う
    Call ApplyData
    Call InitFormControlsPos("O")
End Sub

Private Sub cmdCancel_Click()
    Unload Me
End Sub

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
        End If
    
    Next i
End Sub

Private Sub cmdDownItem_Click()
    Call MoveListItem(1)
End Sub

Private Sub cmdOk_Click()
    'データ適用処理を行う（エラー時は画面を閉じない）
    If ApplyData() = False Then
        Exit Sub
    End If

    Call InitFormControlsPos("O")
    
    '画面を閉じる
    Unload Me
    
End Sub

Private Sub cmdUpdateItem_Click()
    Call InitFormControlsPos("U")

End Sub

Private Sub cmdUpItem_Click()
    Call MoveListItem(-1)
End Sub

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
    
    If lsvItem.ListItems.Count = 0 Then Exit Sub
    
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
        .Add , , "名称", 2500, lvwColumnLeft
        .Add , , "操作権限", 300, lvwColumnLeft
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


Private Sub Form_Load()
    Dim Ret         As Boolean              '戻り値
    Dim objButton   As CommandButton        'コマンドボタンオブジェクト
    
    'オブジェクトのインスタンスの作成
'    Set objButton = cmdInsert_Title

    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    
    '画面初期化
    Call InitializeForm
    
    If iMode = 0 Then                       '開く
        txtUserGrp(0).Text = mstrUserGrpName
        txtUserGrp(1).Text = mstrSecurityGrpName
        txtUserGrp(0).Enabled = (txtUserGrp(0).Text = "")
        txtUserGrp(1).Enabled = (txtUserGrp(1).Text = "")
        Ret = True
    Else                                    '新規
        txtUserGrp(0).Visible = False
        txtUserGrp(1).Visible = False
        cboGrp(0).Visible = True
        cboGrp(1).Visible = True
    
        Do
            If EditUserGrp(0) = False Then
                Exit Do
            End If
                    
            Ret = True
            Exit Do
        Loop
    End If
    
    
    '参照専用の場合、登録系コントロールを止める
    If mblnShowOnly = True Then

    End If
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

'
' 機能　　 :
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
' 機能説明 :
' 備考　　 :
'
Private Function EditUserGrp(idx As Integer) As Boolean
    Dim objItem                 As Object           'コースアクセス用
    Dim vntUserGrpCd            As Variant
    Dim vntUserGrpName          As Variant
    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'インデックス
    Dim iMode                   As Integer
    Dim strKey                  As String
    
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
    
    EditUserGrp = False
    cboGrp(idx).Clear
    
    Select Case idx
        Case 0                   'ユーザーグループ
            iMode = 0
            strKey = "UGR"
            Erase aryUserGrpCd
            
        Case 1                  'セキュリティーグループ
            iMode = 1
            strKey = aryUserGrpCd(cboGrp(0).ListIndex)
            Erase arySecurityGrpCd
        
    End Select
        
    'オブジェクトのインスタンス作成
    Set objItem = CreateObject("HainsFree.Free")
    lngCount = objItem.SelectFreeByClassCd(iMode, _
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
    
    '履歴データが存在しないなら、エラー
    If lngCount <= 0 Then
        MsgBox "ユーザーグループが存在しないです。", vbExclamation
        Exit Function
    End If
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        If idx = 0 Then
            ReDim Preserve aryUserGrpCd(i)
            aryUserGrpCd(i) = vntFreeCd(i)
        ElseIf idx = 1 Then
            ReDim Preserve arySecurityGrpCd(i)
            arySecurityGrpCd(i) = vntFreeCd(i)
        End If
        cboGrp(idx).AddItem vntFreeField1(i)
    Next i
    
'    cboGrp(idx).ListIndex = 0
    
    '先頭コンボを選択状態にする
    
    EditUserGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub InitializeForm()
    cboGrp(0).Visible = False
    cboGrp(1).Visible = False
    txtUserGrp(0).Visible = True
    txtUserGrp(1).Visible = True
    
    cboGrp(0).Left = txtUserGrp(0).Left
    cboGrp(0).Top = txtUserGrp(0).Top
    cboGrp(1).Left = txtUserGrp(1).Left
    cboGrp(1).Top = txtUserGrp(1).Top
    
    Call InitFormControls(Me, mcolGotFocusCollection)      '使用コントロール初期化
    Call InitFormControlsPos("O")
    
End Sub

Private Sub InitFormControlsPos(HType As String)

    Select Case HType
        Case "U"
            Frame4.Top = Frame2.Top + Frame2.Height + 20
            Frame4.Visible = True
            cmdOk.Top = Frame4.Top + Frame4.Height + 120
            cmdCancel.Top = cmdOk.Top
            cmdApply.Top = cmdOk.Top
            cmdAddItem.Enabled = False
            cmdDeleteItem.Enabled = False
        
        Case "O"
            Frame4.Visible = False
            cmdAddItem.Enabled = True
            cmdDeleteItem.Enabled = True
            cmdOk.Top = Frame2.Top + Frame2.Height + 100
            cmdCancel.Top = cmdOk.Top
            cmdApply.Top = cmdOk.Top
    End Select
    
'    Select Case HType
'        Case "U"
'            Frame3.Top = Frame2.Top + Frame2.Height + 20
'            Frame3.Visible = True
'            cmdOk.Top = Frame3.Top + Frame3.Height + 120
'            cmdCancel.Top = cmdOk.Top
'            cmdApply.Top = cmdOk.Top
'            cmdAddItem.Enabled = False
'            cmdDeleteItem.Enabled = False
'
'        Case "O"
'            Frame3.Visible = False
'            cmdAddItem.Enabled = True
'            cmdDeleteItem.Enabled = True
'            cmdOk.Top = Frame2.Top + Frame2.Height + 100
'            cmdCancel.Top = cmdOk.Top
'            cmdApply.Top = cmdOk.Top
'    End Select
    
    Me.Width = Frame1.Left + Frame1.Width + 200
    Me.Height = cmdOk.Top + cmdOk.Height + 520
    
End Sub

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

Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)
    Dim i As Long

    'CTRL+Aを押下された場合、項目を全て選択する
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem.ListItems.Count
            lsvItem.ListItems(i).Selected = True
        Next i
    End If
End Sub

Private Sub optGrant_Click(Index As Integer)
    mintPgmGrant = Index
End Sub

Private Sub txtGrpCd_Change(Index As Integer)
    
    If Index = 0 Then           'ユーザーグループ
        '' 権限グループリストを読んで来る
        If EditUserGrp(1) = False Then Exit Sub
        
    ElseIf Index = 1 Then       'セキュリティーグループ
        '' 該当の権限グループの使用可能プログラムリストを読んで来る
    
    End If

End Sub


'
' 機能　　 : 管理検査項目表示
'
' 機能説明 : 現在設定されているグループ内検査項目を表示する
'
' 備考　　 :
'
Private Function EditListItem() As Boolean
    On Error GoTo ErrorHandle

    Dim objGrp          As Object               'グループアクセス用
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    Dim vntClassName    As Variant              '検査分類名称
    Dim vntItemDiv      As Variant              '項目区分
    Dim vntItemCd       As Variant              'コード
    Dim vntItemSuffix   As Variant              'サフィックス
    Dim vntItemName     As Variant              '名称
    Dim vntseq          As Variant              'SEQ
    Dim lngCount        As Long                 'レコード数
    Dim strItemKey      As String               'リストビュー用アイテムキー
    Dim strItemCdString As String               '表示用キー編集領域
    Dim i               As Long                 'インデックス

    EditListItem = False

    'リストアイテムクリア
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    'オブジェクトのインスタンス作成
'    Set objGrp = CreateObject("HainsGrp.Grp")
'    lngCount = objGrp.SelectGrp_R_ItemList(mstrGrpCd, vntItemCd, vntItemName, vntClassName)


    'ヘッダの編集
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "コード", 1500, lvwColumnLeft
        .Add , , "プログラム名称", 3000, lvwColumnLeft
        .Add , , "操作権限", 1000, lvwColumnLeft
    End With
        
    lsvItem.View = lvwReport
    
    
    'リストの編集
    For i = 0 To lngCount - 1
        'キー値と表示コードの編集
        strItemCdString = vntItemCd(i)
        strItemKey = mstrListViewKey & vntItemCd(i)
        
        Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
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



