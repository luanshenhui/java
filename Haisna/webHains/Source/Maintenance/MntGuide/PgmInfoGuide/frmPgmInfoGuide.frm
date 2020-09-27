VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmPgmInfoGuide 
   Caption         =   "プログラム項目ガイド"
   ClientHeight    =   6555
   ClientLeft      =   8010
   ClientTop       =   3765
   ClientWidth     =   5250
   Icon            =   "frmPgmInfoGuide.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   ScaleHeight     =   6555
   ScaleWidth      =   5250
   Begin VB.CheckBox chkGrant 
      Caption         =   "参照"
      Height          =   273
      Index           =   0
      Left            =   390
      TabIndex        =   13
      Top             =   7644
      Visible         =   0   'False
      Width           =   793
   End
   Begin VB.CheckBox chkGrant 
      Caption         =   "登録、修正"
      Height          =   273
      Index           =   1
      Left            =   1196
      TabIndex        =   12
      Top             =   7644
      Visible         =   0   'False
      Width           =   1105
   End
   Begin VB.CheckBox chkGrant 
      Caption         =   "削除"
      Height          =   273
      Index           =   2
      Left            =   2444
      TabIndex        =   11
      Top             =   7644
      Visible         =   0   'False
      Width           =   767
   End
   Begin VB.CheckBox chkGrant 
      Caption         =   "ALL"
      Height          =   273
      Index           =   3
      Left            =   3250
      TabIndex        =   10
      Top             =   7644
      Visible         =   0   'False
      Width           =   689
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3783
      TabIndex        =   7
      Top             =   6110
      Width           =   1313
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2314
      TabIndex        =   6
      Top             =   6110
      Width           =   1313
   End
   Begin VB.Frame Frame2 
      Height          =   611
      Left            =   78
      TabIndex        =   1
      Top             =   598
      Width           =   5083
      Begin VB.ComboBox cboMenu 
         Height          =   273
         Left            =   1404
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   2
         Top             =   208
         Width           =   1937
      End
      Begin VB.OptionButton Option1 
         Caption         =   "Hains"
         Height          =   195
         Index           =   1
         Left            =   1430
         TabIndex        =   3
         Top             =   234
         Value           =   -1  'True
         Visible         =   0   'False
         Width           =   949
      End
      Begin VB.OptionButton Option1 
         Caption         =   "誘導"
         Height          =   195
         Index           =   0
         Left            =   2366
         TabIndex        =   4
         Top             =   234
         Visible         =   0   'False
         Width           =   845
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "メニュー 区分"
         Height          =   169
         Index           =   1
         Left            =   208
         TabIndex        =   5
         Top             =   260
         Width           =   949
      End
   End
   Begin VB.Frame Frame1 
      Height          =   559
      Left            =   78
      TabIndex        =   8
      Top             =   5382
      Width           =   5083
      Begin VB.OptionButton optGrant 
         Caption         =   "●：スーパーユーザ"
         Height          =   247
         Index           =   4
         Left            =   3075
         TabIndex        =   17
         Top             =   208
         Width           =   1845
      End
      Begin VB.OptionButton optGrant 
         Caption         =   "削除"
         Height          =   247
         Index           =   3
         Left            =   3406
         TabIndex        =   16
         Top             =   420
         Visible         =   0   'False
         Width           =   690
      End
      Begin VB.OptionButton optGrant 
         Caption         =   "登録、修正"
         Height          =   247
         Index           =   2
         Left            =   2184
         TabIndex        =   15
         Top             =   420
         Visible         =   0   'False
         Width           =   1140
      End
      Begin VB.OptionButton optGrant 
         Caption         =   "▲：参照のみ"
         Height          =   247
         Index           =   1
         Left            =   1430
         TabIndex        =   14
         Top             =   208
         Width           =   1380
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "操作権限区分 ："
         Height          =   165
         Index           =   4
         Left            =   135
         TabIndex        =   9
         Top             =   240
         Width           =   1155
      End
   End
   Begin MSComctlLib.ListView lsvItem 
      Height          =   4215
      Left            =   60
      TabIndex        =   18
      Top             =   1215
      Width           =   5115
      _ExtentX        =   9022
      _ExtentY        =   7435
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   0
      Picture         =   "frmPgmInfoGuide.frx":000C
      Top             =   0
      Width           =   720
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
Attribute VB_Name = "frmPgmInfoGuide"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'プロパティ用定義領域
Private mblnRet             As Boolean  '戻り値
Private mblnNowEdit         As Boolean  'TRUE:編集中、FALSE:表示用編集可能
Private mblnMultiSelect     As Boolean  'リストビューの複数選択
Private mintItemCount       As Integer  '選択された項目数
Private mstrPgmGrant        As String
Private mintPgmGrant        As Integer

Private aryMenuGrpCd()      As String
Private mvntItemCd()        As Variant  '選択された項目コード
Private mvntItemName()      As Variant  '選択された業務名
Private mvntItemFileName()  As Variant  '選択されたプログラム名
Private mvntItemGrant()     As Variant  '選択された操作権限
Private mvntGrantName()     As Variant

Private Const FORM_WIDTH    As Integer = 5360
Private Const FORM_HEIGHT   As Integer = 6940
Private Const LSVITEM_TOP   As Integer = 1250


Public Property Get Ret() As Variant
    Ret = mblnRet
End Property

Private Sub cboMenu_Click()
    Call EditPgmInfo
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

Private Sub cmdCancel_Click()
    Unload Me
End Sub

Private Sub Form_Load()
    Dim Ret         As Boolean
    
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mintItemCount = 0
    mintPgmGrant = 1
    mblnNowEdit = True
    
    '画面初期化
'    Call InitializeForm
    
    Do
        'セット分類情報の編集
        If EditMenuGrp() = False Then
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnRet = Ret
    
    '処理中の解除
    mblnNowEdit = False
    
    '項目リスト編集（初期表示）
'    Call EditItemList
    
    'リストのマルチセレクトセット
'    lsvItem.MultiSelect = mblnMultiSelect
    Screen.MousePointer = vbDefault

End Sub


'
' 機能　　 : データ表示用編集
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditPgmInfo() As Boolean
    On Error GoTo ErrorHandle

    Dim objPgmInfo          As Object               'グループアクセス用
    Dim objHeader           As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem             As ListItem             'リストアイテムオブジェクト
    
    Dim vntPgmCd            As Variant              'プログラムコード
    Dim vntPgmName          As Variant              'プログラム名称
    Dim vntStartPgm         As Variant              '起動プログラム
    '## 2005.07.26 追加
    Dim vntFilePath         As Variant
    '## 2005.07.26 追加  End.
    Dim vntLinkImage        As Variant              'リンクイメージ
    Dim vntMenuGrpCd        As Variant              'メニューグループコード
    Dim vntPgmDesc          As Variant              'プログラム説明
    Dim vntDelFlag          As Variant              '使用可否フラッグ
    
    Dim lngCount            As Long                 'レコード数
    Dim i                   As Long                 'インデックス
    Dim Ret                 As Boolean
    
    'オブジェクトのインスタンス作成
    Set objPgmInfo = CreateObject("HainsPgmInfo.PgmInfo")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If cboMenu.Text = "" Then
            Ret = True
            Exit Do
        End If
        
        'プログラム情報をコードで読み込み
        lngCount = objPgmInfo.SelectPgmInfo(aryMenuGrpCd(cboMenu.ListIndex), _
                                                1, _
                                                vntPgmCd, _
                                                vntPgmName, _
                                                vntStartPgm, _
                                                vntFilePath, _
                                                vntLinkImage, _
                                                vntMenuGrpCd, _
                                                vntPgmDesc, _
                                                vntDelFlag)
    
        'ヘッダの編集
        Set objHeader = lsvItem.ColumnHeaders
        With objHeader
            .Clear
            .Add , , "コード", 700, lvwColumnLeft
            .Add , , "プログラム名称", 3000, lvwColumnLeft
            .Add , , "起動プログラム", 1500, lvwColumnLeft
            .Add , , "リンクイメージ", 1500, lvwColumnLeft
            .Add , , "プログラム説明", 3500, lvwColumnLeft
        End With
            
        lsvItem.View = lvwReport
        
        lsvItem.ListItems.Clear
    
        '読み込み内容の編集
        If lngCount > 0 Then
             'リストの編集
             For i = 0 To lngCount - 1
                 'キー値と表示コードの編集
                 Set objItem = lsvItem.ListItems.Add(, vntPgmCd(i), vntPgmCd(i))
                 objItem.SubItems(1) = vntPgmName(i)
                 objItem.SubItems(2) = vntStartPgm(i)
                 objItem.SubItems(3) = vntLinkImage(i)
                 objItem.SubItems(4) = vntPgmDesc(i)
             Next i
            
             '項目が１行以上存在した場合、無条件に先頭が選択されるため解除する。
             If lsvItem.ListItems.Count > 0 Then
                 lsvItem.ListItems(1).Selected = False
             End If
        Else
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditPgmInfo = Ret
    
    Exit Function

ErrorHandle:

    EditPgmInfo = False
    MsgBox Err.Description, vbCritical
    
End Function


'
' 機能　　 :
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
' 機能説明 :
' 備考　　 :
'
Private Function EditMenuGrp() As Boolean
    Dim objItem                 As Object           'コースアクセス用
    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'インデックス
    Dim imode                   As Integer
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
    
    EditMenuGrp = False
    cboMenu.Clear
    
    imode = 0
    strKey = "PGM"
    Erase aryMenuGrpCd
        
    'オブジェクトのインスタンス作成
    Set objItem = CreateObject("HainsFree.Free")
    lngCount = objItem.SelectFreeByClassCd(imode, _
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
        MsgBox "メーニューグループが存在しないです。", vbExclamation
        Exit Function
    End If
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve aryMenuGrpCd(i)
        aryMenuGrpCd(i) = vntFreeCd(i)
        cboMenu.AddItem vntFreeField1(i)
    Next i
    
'    cboMenu.ListIndex = 0
    
    '先頭コンボを選択状態にする
    EditMenuGrp = True
    
    Exit Function
    
ErrorHandle:
    MsgBox Err.Description, vbCritical

End Function

Friend Property Let MultiSelect(ByVal vNewValue As Boolean)
    mblnMultiSelect = vNewValue
End Property

Public Property Get ItemName() As Variant
    ItemName = mvntItemName
End Property

Public Property Get ItemFileName() As Variant
    ItemFileName = mvntItemFileName
End Property

Public Property Get ItemCount() As Variant
    ItemCount = mintItemCount
End Property

Public Property Get ItemCd() As Variant
    ItemCd = mvntItemCd
End Property

Public Property Get ItemGrant() As Variant
    ItemGrant = mvntItemGrant
End Property

Public Property Get GrantName() As Variant
    GrantName = mvntGrantName
End Property

Private Sub Form_Resize()
    If Me.WindowState <> vbMinimized Then
        Call SizeControls
    End If
End Sub

' 機能　　 : 各種コントロールのサイズ変更
'
' 引数　　 : なし
'
' 戻り値　 :
'
' 備考　　 : ツリービュー・リストビュー・スプリッター・ラベル等のサイズを変更する
'
Private Sub SizeControls()
    
    '幅変更
    If Me.Width > FORM_WIDTH Then
        lsvItem.Width = Me.Width - 120
        cmdOk.Left = Me.Width - 3040
        cmdCancel.Left = cmdOk.Left + 1460
    End If
    
    '高さ変更
    If Me.Height > FORM_HEIGHT Then
        lsvItem.Height = Me.Height - 2620
        cmdOk.Top = Me.Height - 830
        cmdCancel.Top = cmdOk.Top
        Frame1.Top = cmdOk.Top - 730
    End If

End Sub


Private Sub lsvItem_DblClick()
    Call cmdOK_Click
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

' @(e)
' 機能　　 : 「ＯＫ」クリック
' 機能説明 : 入力内容を適用し、画面を閉じる
' 備考　　 :
Private Sub cmdOK_Click()
    Dim x           As Object
    Dim i           As Integer
    Dim j           As Integer
    Dim strWorkKey  As String
    Dim lngPointer  As Long

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
'    '操作権限区分 チェック
    If Not Validation() Then
        MsgBox "操作権限区分が選択されていません。", vbExclamation
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '変数初期化
    mintItemCount = 0
    j = 0
    Erase mvntItemCd
    Erase mvntItemName
    Erase mvntItemFileName
    Erase mvntItemGrant
    Erase mvntGrantName
    
    Do
        '何も選択されていないならお終い
        If lsvItem.SelectedItem Is Nothing Then
            MsgBox "項目が何も選択されていません。", vbExclamation
            Exit Do
        End If
        
        'リストビューをくるくる回して選択項目配列作成
        For i = 1 To lsvItem.ListItems.Count
            If lsvItem.ListItems(i).Selected = True Then
                
                'カウントアップ
                mintItemCount = mintItemCount + 1
                                
                '配列拡張
                ReDim Preserve mvntItemCd(j)
                ReDim Preserve mvntItemName(j)
                ReDim Preserve mvntItemFileName(j)
                ReDim Preserve mvntItemGrant(j)
                ReDim Preserve mvntGrantName(j)
                
                'リストビュー用のキープリフィックスを削除
                mvntItemCd(j) = lsvItem.ListItems(i).Key
                mvntItemName(j) = lsvItem.ListItems(i).SubItems(1)
                mvntItemFileName(j) = lsvItem.ListItems(i).SubItems(2)
                mvntItemGrant(j) = mintPgmGrant
                mvntGrantName(j) = optGrant(mintPgmGrant).Caption
                j = j + 1
            
            End If
        Next i
            
        '何も選択されていないならお終い
        If mintItemCount = 0 Then
            MsgBox "項目が何も選択されていません。", vbExclamation
            Exit Do
        End If
            
        '画面を閉じる
        Unload Me
        
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Function Validation() As Boolean
    Dim i       As Integer
    Dim bRet    As Boolean
    
    For i = 1 To 4
        If optGrant(i).Value = True Then
            bRet = True
            Exit For
        End If
    Next i
    
    Validation = bRet
End Function

Private Sub optGrant_Click(Index As Integer)
    mintPgmGrant = Index
End Sub
