VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmGroup 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "グループテーブルメンテナンス"
   ClientHeight    =   7185
   ClientLeft      =   2040
   ClientTop       =   330
   ClientWidth     =   6225
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmGroup.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7185
   ScaleWidth      =   6225
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.CheckBox chkSystemGrp 
      Caption         =   "このグループは通常業務画面に表示しない(&F):"
      Height          =   195
      Left            =   180
      TabIndex        =   25
      ToolTipText     =   "システム制御用など内部的に使用するグループに定義します。"
      Top             =   6360
      Width           =   4335
   End
   Begin VB.Frame Frame2 
      Caption         =   "検査項目(&I)"
      Height          =   2895
      Left            =   120
      TabIndex        =   14
      Top             =   3360
      Width           =   6015
      Begin VB.CommandButton cmdInsert_Title 
         Caption         =   "新規見出し(&M)..."
         Height          =   315
         Left            =   1620
         TabIndex        =   26
         Top             =   2460
         Width           =   1515
      End
      Begin VB.CommandButton cmdDownItem 
         Caption         =   "↓"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   180
         TabIndex        =   16
         Top             =   1380
         Width           =   315
      End
      Begin VB.CommandButton cmdUpItem 
         Caption         =   "↑"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   180
         TabIndex        =   15
         Top             =   840
         Width           =   315
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "追加(&A)..."
         Height          =   315
         Left            =   3240
         TabIndex        =   18
         Top             =   2460
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "削除(&R)"
         Height          =   315
         Left            =   4620
         TabIndex        =   19
         Top             =   2460
         Width           =   1275
      End
      Begin MSComctlLib.ListView lsvItem 
         Height          =   2100
         Left            =   540
         TabIndex        =   17
         Top             =   300
         Width           =   5355
         _ExtentX        =   9446
         _ExtentY        =   3704
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
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3480
      TabIndex        =   21
      Top             =   6720
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2100
      TabIndex        =   20
      Top             =   6720
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
      Height          =   315
      Left            =   4860
      TabIndex        =   22
      Top             =   6720
      Width           =   1275
   End
   Begin VB.Frame Frame1 
      Caption         =   "基本情報(&B)"
      Height          =   2535
      Left            =   120
      TabIndex        =   0
      Top             =   720
      Width           =   6015
      Begin VB.TextBox txtOldSetCd 
         Enabled         =   0   'False
         Height          =   318
         Left            =   1680
         MaxLength       =   7
         TabIndex        =   28
         Text            =   "1234567"
         Top             =   2100
         Width           =   1155
      End
      Begin VB.ComboBox cboItemClass 
         Height          =   300
         ItemData        =   "frmGroup.frx":000C
         Left            =   1680
         List            =   "frmGroup.frx":002E
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   7
         Top             =   1380
         Width           =   2550
      End
      Begin VB.ComboBox cboSearchChar 
         Height          =   300
         ItemData        =   "frmGroup.frx":0050
         Left            =   1680
         List            =   "frmGroup.frx":0072
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   13
         Top             =   1740
         Width           =   810
      End
      Begin VB.TextBox txtPrice2 
         Height          =   318
         Left            =   4020
         MaxLength       =   7
         TabIndex        =   11
         Text            =   "1234567"
         Top             =   2100
         Visible         =   0   'False
         Width           =   795
      End
      Begin VB.TextBox txtPrice1 
         Height          =   318
         Left            =   4980
         MaxLength       =   7
         TabIndex        =   9
         Text            =   "1234567"
         Top             =   540
         Visible         =   0   'False
         Width           =   795
      End
      Begin VB.TextBox txtGrpCd 
         Height          =   315
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1680
         MaxLength       =   5
         TabIndex        =   2
         Text            =   "1234G"
         Top             =   660
         Width           =   675
      End
      Begin VB.TextBox txtGrpName 
         Height          =   318
         IMEMode         =   4  '全角ひらがな
         Left            =   1680
         MaxLength       =   10
         TabIndex        =   4
         Text            =   "胸部レントゲン"
         Top             =   1020
         Width           =   2055
      End
      Begin VB.Label Label4 
         Caption         =   "旧セットコード(&T):"
         Height          =   195
         Left            =   240
         TabIndex        =   27
         Top             =   2160
         Width           =   1395
      End
      Begin VB.Label lblGrpDiv 
         Caption         =   "依頼項目を管理します"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Left            =   1680
         TabIndex        =   24
         Top             =   360
         Width           =   1875
      End
      Begin VB.Label Label8 
         Caption         =   "検査分類(&K)"
         Height          =   195
         Index           =   1
         Left            =   240
         TabIndex        =   6
         Top             =   1440
         Width           =   1335
      End
      Begin VB.Label LabelPrice2 
         Caption         =   "基本料金２(&T):"
         Height          =   195
         Left            =   2700
         TabIndex        =   10
         Top             =   2160
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.Label Label3 
         Caption         =   "検索用文字列(&C):"
         Height          =   195
         Index           =   2
         Left            =   240
         TabIndex        =   12
         Top             =   1800
         Width           =   1395
      End
      Begin VB.Label LabelPrice1 
         Caption         =   "基本料金１(&T):"
         Height          =   195
         Left            =   3540
         TabIndex        =   8
         Top             =   600
         Visible         =   0   'False
         Width           =   1095
      End
      Begin VB.Label Label8 
         Caption         =   "グループの種類:"
         Height          =   195
         Index           =   0
         Left            =   240
         TabIndex        =   5
         Top             =   360
         Width           =   1395
      End
      Begin VB.Label Label1 
         Caption         =   "グループコード(&C):"
         Height          =   195
         Index           =   2
         Left            =   240
         TabIndex        =   1
         Top             =   720
         Width           =   1275
      End
      Begin VB.Label Label2 
         Caption         =   "グループ名(&N):"
         Height          =   195
         Left            =   240
         TabIndex        =   3
         Top             =   1080
         Width           =   1095
      End
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   0
      Left            =   180
      Picture         =   "frmGroup.frx":0094
      Top             =   180
      Width           =   480
   End
   Begin VB.Label LabelCourseGuide 
      Caption         =   "検査項目をグループとしてとりまとめます。"
      Height          =   255
      Left            =   840
      TabIndex        =   23
      Top             =   300
      Width           =   3915
   End
End
Attribute VB_Name = "frmGroup"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'プロパティ用領域
Private mstrGrpCd       As String   'グループコード
Private mintGrpDiv      As Integer  'グループ区分
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly    As Boolean  'TRUE:データの更新をしない（参照のみ）
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗

'モジュール固有領域領域
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション
Private mstrClassCd()   As String   '検査分類コード（配列は、コンボボックスと対応）

Private Midashicounter As Long
Const mstrListViewKey   As String = "K"


Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property


' @(e)
'
' 機能　　 : 「項目追加」Click
'
' 機能説明 : 指定コース履歴に受診項目を追加する
'
' 備考　　 :
'
Private Sub cmdAddItem_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '項目ガイド表示用
    Dim objItem         As ListItem                 'リストアイテムオブジェクト
    
    Dim i               As Long     'インデックス
    Dim strKey          As String   '重複チェック用のキー
    Dim strItemString   As String
    Dim strItemKey      As String   'リストビュー用アイテムキー
    Dim strItemCdString As String   '表示用キー編集領域
    
    Dim lngItemCount    As Long     '選択項目数
    Dim vntItemCd       As Variant  '選択された項目コード
    Dim vntSuffix       As Variant  '選択されたサフィックス
    Dim vntItemName     As Variant  '選択された項目名
    Dim vntClassName    As Variant  '選択された検査分類名
    
    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = mintGrpDiv
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = mintGrpDiv - 1
    
        'コーステーブルメンテナンス画面を開く
        .Show vbModal
        
        '戻り値としてのプロパティ取得
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
        vntItemName = .ItemName
        vntClassName = .ClassName
    
    End With
        
    Screen.MousePointer = vbHourglass
    Me.Refresh
        
    '選択件数が0件以上なら
    If lngItemCount > 0 Then
    
        'リストの編集
        For i = 0 To lngItemCount - 1
            
            'キー値と表示コードの編集
            If mintGrpDiv = MODE_RESULT Then
                '検査項目の場合
                strItemCdString = vntItemCd(i) & "-" & vntSuffix(i)
                strItemKey = mstrListViewKey & strItemCdString
            Else
                '依頼項目の場合
                strItemCdString = vntItemCd(i)
                strItemKey = mstrListViewKey & strItemCdString
            End If
            
            'リスト上に存在するかチェックする
            If CheckExistsItemCd(lsvItem, strItemKey) = False Then
            
                'なければ追加する
                Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
                objItem.SubItems(1) = vntItemName(i)
                objItem.SubItems(2) = vntClassName(i)
            
            End If
        Next i
    
    End If

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

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
' 機能　　 : フォームコントロールの初期化
'
' 機能説明 : コントロールを初期状態に変更する。
'
' 備考　　 :
'
Private Sub InitializeForm()

    Dim Ctrl        As Object
    Dim i           As Integer
    Dim objHeader   As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objButton   As CommandButton        'コマンドボタンオブジェクト
    
    Call InitFormControls(Me, mcolGotFocusCollection)      '使用コントロール初期化
    
    'オブジェクトのインスタンスの作成
    Set objButton = cmdInsert_Title

    
    'グループの種類
    If mintGrpDiv = MODE_REQUEST Then
        lblGrpDiv.Caption = "依頼項目を管理します"
'##2003.09.11 add T-ISHI@FSIT 新規見出しボタンの非・表示の設定
'        objButton.Visible = False
'##add end
    Else
        lblGrpDiv.Caption = "検査項目を管理します"
        txtPrice1.Enabled = False
        txtPrice2.Enabled = False
        txtPrice1.BackColor = vbButtonFace
        txtPrice2.BackColor = vbButtonFace
        LabelPrice1.ForeColor = vbGrayText
        LabelPrice2.ForeColor = vbGrayText
'##2003.09.11 add T-ISHI@FSIT 新規見出しボタンの非・表示の設定
        objButton.Visible = True
'##add end
    End If
    
    txtPrice1.Text = 0
    txtPrice2.Text = 0
    
    '検索用文字列の種類
    Call InitSearchCharCombo(cboSearchChar)
    
End Sub
' @(e)
'
' 機能　　 : 検査分類データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditItemClass() As Boolean

    Dim objItem         As Object   'コースアクセス用
    
    Dim vntClassCd      As Variant
    Dim vntClassName    As Variant

    Dim lngCount    As Long             'レコード数
    Dim i           As Long             'インデックス
    
    EditItemClass = False
    
    cboItemClass.Clear
    Erase mstrClassCd

    'オブジェクトのインスタンス作成
    Set objItem = CreateObject("HainsItem.Item")
    lngCount = objItem.SelectItemClassList(vntClassCd, vntClassName)
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrClassCd(i)
        mstrClassCd(i) = vntClassCd(i)
        cboItemClass.AddItem vntClassName(i)
    Next i
    
    '履歴データが存在しないなら、エラー
    If lngCount <= 0 Then
        MsgBox "検査分類が存在しません。検査分類データを登録しないとグループの更新を行うことはできません。", vbExclamation
        Exit Function
    End If
    
    '先頭コンボを選択状態にする
    cboItemClass.ListIndex = 0
    EditItemClass = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function


' @(e)
'
' 機能　　 : 基本グループ情報画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : グループの基本情報を画面に表示する
'
' 備考　　 :
'
Private Function EditGrp() As Boolean

    Dim objGrp          As Object     'グループ情報アクセス用
    
    Dim vntGrpName      As Variant
    Dim vntPrice1       As Variant
    Dim vntPrice2       As Variant
    Dim vntClassCd      As Variant
    Dim vntGrpDiv       As Variant
    Dim vntSearchChar   As Variant
    Dim vntSystemGrp    As Variant
    Dim vntOldSetCd     As Variant

    Dim Ret             As Boolean              '戻り値
    Dim i               As Integer
    
    EditGrp = False
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objGrp = CreateObject("HainsGrp.Grp")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrGrpCd = "" Then
            Ret = True
            Exit Do
        End If
        
        'グループテーブルレコード読み込み
        If objGrp.SelectGrp_P(mstrGrpCd, vntGrpName, vntPrice1, _
                              vntPrice2, vntClassCd, vntGrpDiv, vntSearchChar, vntSystemGrp, vntOldSetCd) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If

        '読み込み内容の編集（コース基本情報）
        txtGrpCd.Text = mstrGrpCd
        txtGrpName.Text = vntGrpName
        txtPrice1.Text = vntPrice1
        txtPrice2.Text = vntPrice2
        
        mintGrpDiv = vntGrpDiv
        If mintGrpDiv = MODE_REQUEST Then
            lblGrpDiv.Caption = "依頼項目を管理します"
        Else
            lblGrpDiv.Caption = "検査項目を管理します"
        End If
        
        If vntSystemGrp = GRP_SYSTEMGRP Then
            chkSystemGrp.Value = vbChecked
        Else
            chkSystemGrp.Value = vbUnchecked
        End If
        
        '検査分類コンボの設定
        For i = 0 To cboItemClass.ListCount - 1
            If mstrClassCd(i) = vntClassCd Then
                cboItemClass.ListIndex = i
            End If
        Next i
        
        '検索文字列コンボの設定
        For i = 0 To cboSearchChar.ListCount - 1
            If cboSearchChar.List(i) = vntSearchChar Then
                cboSearchChar.ListIndex = i
            End If
        Next i
    
        txtOldSetCd.Text = vntOldSetCd
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditGrp = Ret
    
    Exit Function

ErrorHandle:

    EditGrp = False
    MsgBox Err.Description, vbCritical
    
End Function
' @(e)
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
'##2003.9.11　add T-ISHI@FSIT　見出しコメントを追加
    Dim vntrslCaption   As Variant              '見出し
'##add end
    EditListItem = False

    'リストアイテムクリア
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    'オブジェクトのインスタンス作成
    Set objGrp = CreateObject("HainsGrp.Grp")
    
    'グループ内検査項目検索
    If mintGrpDiv = MODE_RESULT Then
        '検査項目の場合
'##2003.9.11　add T-ISHI@FSIT　見出しコメントをリストに追加
'        lngCount = objGrp.SelectGrp_I_ItemList_AddCaption(mstrGrpCd, vntItemCd, vntItemSuffix, _
'                                               vntItemName, , , , vntClassName, vntseq)
        lngCount = objGrp.SelectGrp_I_ItemList_AddCaption(mstrGrpCd, vntItemCd, vntItemSuffix, _
                                               vntItemName, , , , vntClassName, vntseq, vntrslCaption)
'##add end
    Else
        '依頼項目の場合
        lngCount = objGrp.SelectGrp_R_ItemList(mstrGrpCd, vntItemCd, vntItemName, vntClassName)
                                               
    End If

    'ヘッダの編集
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "コード", 1000, lvwColumnLeft
        .Add , , "名称", 2000, lvwColumnLeft
        .Add , , "検査分類", 2000, lvwColumnLeft
    End With
        
    lsvItem.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        
        'キー値と表示コードの編集
        If mintGrpDiv = MODE_RESULT Then
            '項目コードに何も入っていない場合
            Midashicounter = Midashicounter + 1
            If IsNull(vntItemCd(i)) Then
                strItemCdString = ""
                strItemKey = mstrListViewKey & Midashicounter
            Else
            '検査項目の場合
                strItemCdString = vntItemCd(i) & "-" & vntItemSuffix(i)
                strItemKey = mstrListViewKey & strItemCdString
            End If
        Else
            '依頼項目の場合
            strItemCdString = vntItemCd(i)
            strItemKey = mstrListViewKey & vntItemCd(i)
        End If
        
        Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
'##2003.09.11 add T-ISHI@FSIT　リストビューに見出しコメント挿入
            If IsNull(vntItemCd(i)) Then
                objItem.SubItems(1) = vntrslCaption(i)
            Else
                objItem.SubItems(1) = vntItemName(i)
                objItem.SubItems(2) = vntClassName(i)
            End If
'##add end
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
        End If
    
    Next i

End Sub


Private Sub cmdDownItem_Click()
    
    Call MoveListItem(1)

End Sub
'##2003.09.11 T-ISHI@FSIT 新規見出しコメントボタン作成
' @(e)
'
' 機能　　 : 「新規見出しコメントの追加」Click
'
' 機能説明 : 見出しを追加する
'
' 備考　　 :
'
Private Sub cmdInsert_Title_Click()


On Error GoTo ErrorHandle

    Dim objItemTitle    As frmMidashi     '見出し表示用
    Dim objItem         As ListItem       'リストアイテムオブジェクト
    

    Dim i               As Long           'インデックス
    Dim strKey          As String         '重複チェック用のキー
    Dim strItemString   As String
    Dim strItemKey      As String         'リストビュー用アイテムキー
    Dim strItemCdString As String         '表示用キー編集領域

    Dim vntrslCaption   As Variant        '記入された見出しコメント
    
    Dim intSelectedIndex    As Integer     '選択した項目のインデックス
    Dim intTargetIndex      As Integer     'ターゲットのインデックス
    Dim intSelectedCount    As Integer     '選択項目数
    
    Dim vntEscKey()         As Variant     '重複チェック用のキー
    Dim vntEscCd()          As Variant     '項目コード
    Dim vntEscName()        As Variant     '項目名称
    Dim vntEscClassName()   As Variant     '検査分類名
    Dim vntEscrslCaption()  As Variant     '見出し項目
    
    '選択項目数の初期設定
    intSelectedCount = 0
   
    'オブジェクトのインスタンス作成
    Set objItemTitle = New frmMidashi
        
    '見出し名称記入画面を開く
    objItemTitle.Show vbModal
    
    
    '戻り値としてのプロパティ取得
    vntrslCaption = objItemTitle.rslCaption

    '戻り値がNULLの場合
    If vntrslCaption = "" Then
        Screen.MousePointer = vbDefault
        Exit Sub
    End If
    
    'キー値と表示コードの編集
    Midashicounter = Midashicounter + 1
    strItemCdString = ""
    strItemKey = mstrListViewKey & Midashicounter
    
    'リスト上に存在するかチェックする
    If CheckExistsItemCd(lsvItem, strItemKey) = False Then

        'なければ追加する
        Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
        
        '選択項目配列作成
        For i = 1 To lsvItem.ListItems.Count

            '選択されている項目なら
            If lsvItem.ListItems(i).Selected = True Then
                intSelectedCount = intSelectedCount + 1
                intSelectedIndex = i
            End If
            
        Next i
        
        '挿入位置が指定されていなかったら
        If intSelectedCount <> 1 Then
            objItem.SubItems(1) = vntrslCaption
        Else
            intTargetIndex = intSelectedIndex
        End If
        
        '全項目配列作成
        For i = 1 To lsvItem.ListItems.Count
            ReDim Preserve vntEscKey(i)
            ReDim Preserve vntEscCd(i)
            ReDim Preserve vntEscName(i)
            ReDim Preserve vntEscClassName(i)
        
            '処理対象配列番号時処理
            If intTargetIndex >= i Then
            
                If intTargetIndex = i Then
                
                    vntEscKey(i) = strItemKey
                    vntEscCd(i) = ""
                    vntEscName(i) = vntrslCaption
                    vntEscClassName(i) = ""

                    i = i + 1
                
                    ReDim Preserve vntEscKey(i)
                    ReDim Preserve vntEscCd(i)
                    ReDim Preserve vntEscName(i)
                    ReDim Preserve vntEscClassName(i)
                
                    vntEscKey(i) = lsvItem.ListItems(intTargetIndex).Key
                    vntEscCd(i) = lsvItem.ListItems(intTargetIndex)
                    vntEscName(i) = lsvItem.ListItems(intTargetIndex).SubItems(1)
                    vntEscClassName(i) = lsvItem.ListItems(intTargetIndex).SubItems(2)
                    
                Else
                
                    vntEscKey(i) = lsvItem.ListItems(i).Key
                    vntEscCd(i) = lsvItem.ListItems(i)
                    vntEscName(i) = lsvItem.ListItems(i).SubItems(1)
                    vntEscClassName(i) = lsvItem.ListItems(i).SubItems(2)
                
                End If
                
            Else
                
                ReDim Preserve vntEscKey(i)
                ReDim Preserve vntEscCd(i)
                ReDim Preserve vntEscName(i)
                ReDim Preserve vntEscClassName(i)

                vntEscKey(i) = lsvItem.ListItems(i - 1).Key
                vntEscCd(i) = lsvItem.ListItems(i - 1)
                vntEscName(i) = lsvItem.ListItems(i - 1).SubItems(1)
                vntEscClassName(i) = lsvItem.ListItems(i - 1).SubItems(2)
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
        For i = 1 To UBound(vntEscKey)
            Set objItem = lsvItem.ListItems.Add(, vntEscKey(i), vntEscCd(i))
            If IsNull(vntEscCd(i)) Then
                objItem.SubItems(1) = vntEscName(i)
            Else
                objItem.SubItems(1) = vntEscName(i)
                objItem.SubItems(2) = vntEscClassName(i)
            End If
        Next i
        
    End If

ErrorHandle:

    '一行目のフォーカスをはずす
    lsvItem.ListItems(1).Selected = False
    
    If intSelectedCount <> 1 Then
        lsvItem.ListItems(lsvItem.ListItems.Count).Selected = True
    Else
        lsvItem.ListItems(intTargetIndex).Selected = True
    End If
    
    '選択されている項目を表示する
    lsvItem.SelectedItem.EnsureVisible

    lsvItem.SetFocus

    Set objItemTitle = Nothing
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
Private Sub cmdOk_Click()
    
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
        
        If Trim(txtGrpCd.Text) = "" Then
            MsgBox "グループコードが入力されていません。", vbExclamation, App.Title
            txtGrpCd.SetFocus
            Exit Do
        End If

        If Trim(txtGrpName.Text) = "" Then
            MsgBox "グループ名が入力されていません。", vbExclamation, App.Title
            txtGrpName.SetFocus
            Exit Do
        End If

        If Trim(txtPrice1.Text) = "" Then
            txtPrice1.Text = 0
        End If

        If Trim(txtPrice2.Text) = "" Then
            txtPrice2.Text = 0
        End If

        If (Trim(txtPrice1.Text) <> "") And (IsNumeric(Trim(txtPrice1.Text)) = False) Then
            MsgBox "基本料金には数値を入力してください", vbExclamation, App.Title
            txtPrice1.SetFocus
            Exit Do
        End If

        If (Trim(txtPrice2.Text) <> "") And (IsNumeric(Trim(txtPrice2.Text)) = False) Then
            MsgBox "基本料金には数値を入力してください", vbExclamation, App.Title
            txtPrice2.SetFocus
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
' 機能　　 : グループ基本情報の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容をグループテーブルに保存する。
'
' 備考　　 :
'
Private Function RegistGrp() As Boolean

On Error GoTo ErrorHandle

    Dim objGrp          As Object     'グループアクセス用
    Dim strSearchChar   As String
    Dim lngRet          As Long
    
    Dim i               As Integer
    Dim j               As Integer
    Dim k               As Integer
    Dim intItemCount    As Integer
    
    Dim vntItemCd()     As Variant
    Dim vntSuffix()     As Variant
    Dim vntseq()        As Variant
'##2003.09.11 add T-ISHI@FSIT 見出しの配列を追加
    Dim vntrslCaption() As Variant
'##add end
    Dim strWorkKey      As String
    Dim strItemCd       As String
    Dim strSuffix       As String
    
    RegistGrp = False

    intItemCount = 0
    Erase vntItemCd
    Erase vntSuffix
    Erase vntseq
'##2003.09.11 add T-ISHI@FSIT 見出しの初期設定を追加
    Erase vntrslCaption
'##add end
    j = 0
    k = 0

    'ガイド検索文字列の再編集
    strSearchChar = cboSearchChar.List(cboSearchChar.ListIndex)
    If strSearchChar = "その他" Then
        strSearchChar = "*"
    End If

    'グループ内検査項目の配列作成
    For i = 1 To lsvItem.ListItems.Count
        
        ReDim Preserve vntItemCd(j)
        ReDim Preserve vntSuffix(j)
        ReDim Preserve vntseq(j)
'##2003.09.11 add T-ISHI@FSIT 配列に見出しを追加
        ReDim Preserve vntrslCaption(j)
'##end add
        'リストビュー用のキープリフィックスを削除
        strWorkKey = Mid(lsvItem.ListItems(i).Key, 2, Len(lsvItem.ListItems(i).Key))
        
        'グループ区分が検査タイプならサフィックスと分割
        If mintGrpDiv = MODE_RESULT Then
            Call SplitItemAndSuffix(strWorkKey, strItemCd, strSuffix)
            If strItemCd = "" And strSuffix = "" Then
                vntItemCd(j) = strItemCd
                vntSuffix(j) = strSuffix
                vntseq(j) = i
'##2003.09.11 add T-ISHI@FSIT 見出しの戻り値を追加
                vntrslCaption(j) = Mid(lsvItem.ListItems(i).SubItems(1), 1, Len(lsvItem.ListItems(i).SubItems(1)))
'##add end
            Else
                vntItemCd(j) = strItemCd
                vntSuffix(j) = strSuffix
                vntseq(j) = i
 '##2003.09.11 add T-ISHI@FSIT 見出しの戻り値を追加
                vntrslCaption(j) = ""
'##add end
            End If
        Else
            vntItemCd(j) = strWorkKey
        End If
        
        j = j + 1
        intItemCount = intItemCount + 1
    
    Next i

    'オブジェクトのインスタンス作成
    Set objGrp = CreateObject("HainsGrp.Grp")

    'グループテーブルレコードの登録
'##2003.09.11 add T-ISHI@FSIT 見出しを追加
''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT システム制御グループフラグの追加
''    lngRet = objGrp.RegistGrp_All(IIf(txtGrpCd.Enabled, "INS", "UPD"), _
'                                Trim(txtGrpCd.Text), _
'                                mstrClassCd(cboItemClass.ListIndex), _
'                                Trim(txtGrpName.Text), _
'                                Trim(txtPrice1.Text), _
'                                Trim(txtPrice2.Text), _
'                                mintGrpDiv, _
'                                strSearchChar, _
'                                intItemCount, _
'                                vntItemCd, _
'                                vntSuffix, _
'                                vntSeq)
'    lngRet = objGrp.RegistGrp_All(IIf(txtGrpCd.Enabled, "INS", "UPD"), _
                                Trim(txtGrpCd.Text), _
                                mstrClassCd(cboItemClass.ListIndex), _
                                Trim(txtGrpName.Text), _
                                Trim(txtPrice1.Text), _
                                Trim(txtPrice2.Text), _
                                mintGrpDiv, _
                                strSearchChar, _
                                IIf(chkSystemGrp.Value = vbChecked, "1", ""), _
                                intItemCount, _
                                vntItemCd, _
                                vntSuffix, _
                                vntseq)
'## 2002.11.10 Mod End
    lngRet = objGrp.RegistGrp_All(IIf(txtGrpCd.Enabled, "INS", "UPD"), _
                                Trim(txtGrpCd.Text), _
                                mstrClassCd(cboItemClass.ListIndex), _
                                Trim(txtGrpName.Text), _
                                Trim(txtPrice1.Text), _
                                Trim(txtPrice2.Text), _
                                mintGrpDiv, _
                                strSearchChar, _
                                IIf(chkSystemGrp.Value = vbChecked, "1", ""), _
                                intItemCount, _
                                vntItemCd, _
                                vntSuffix, _
                                vntseq, _
                                vntrslCaption)
'##add end
    
    If lngRet = 0 Then
        MsgBox "入力されたグループコードは既に存在します。", vbExclamation
        Exit Function
    End If
    
    mstrGrpCd = Trim(txtGrpCd.Text)
    txtGrpCd.Enabled = (txtGrpCd.Text = "")
    
    Set objGrp = Nothing
    RegistGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objGrp = Nothing
    RegistGrp = False
    
End Function

Private Sub Command1_Click()

End Sub

Private Sub cmdUpItem_Click()

    Call MoveListItem(-1)

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
    Dim objButton   As CommandButton        'コマンドボタンオブジェクト
    
    'オブジェクトのインスタンスの作成
    Set objButton = cmdInsert_Title

    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    
    '画面初期化
    Call InitializeForm

    Do
        '検査分類コンボの編集
        If EditItemClass() = False Then
            Exit Do
        End If
        
        'グループ情報の表示編集
        If EditGrp() = False Then
            Exit Do
        End If
    
        'グループ内検査項目の編集
        If EditListItem() = False Then
            Exit Do
        End If
        
'### 2003/11/23 Added by Ishihara@FSIT 非表示
objButton.Visible = False
        
        If mintGrpDiv = MODE_REQUEST Then
'            lblGrpDiv.Caption = "依頼項目を管理します"
    '##2003.09.11 add T-ISHI@FSIT 新規見出しボタンの非・表示の設定
'            objButton.Visible = False
    '##add end
'### 2003/11/23 Added by Ishihara@FSIT 非表示
            cmdUpItem.Visible = False
            cmdDownItem.Visible = False
'### 2003/11/23 Added End
        End If
        
        'イネーブル設定
        txtGrpCd.Enabled = (txtGrpCd.Text = "")
'        cboGrpDiv.Enabled = txtGrpCd.Enabled
        
        Ret = True
        Exit Do
    
    Loop
    
    '参照専用の場合、登録系コントロールを止める
    If mblnShowOnly = True Then
        LabelCourseGuide.Caption = txtGrpName.Text & "のプロパティ"
        
        txtGrpCd.Enabled = False
        txtGrpName.Enabled = False
        cboItemClass.Enabled = False
        txtPrice1.Enabled = False
        txtPrice2.Enabled = False
        cboSearchChar.Enabled = False
        
        cmdOk.Enabled = False
        cmdApply.Enabled = False
        cmdAddItem.Enabled = False
        cmdDeleteItem.Enabled = False
        cmdUpItem.Enabled = False
        cmdDownItem.Enabled = False
    End If
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub
Friend Property Get GrpCd() As Variant

    GrpCd = mstrGrpCd
    
End Property

Friend Property Let GrpCd(ByVal vNewValue As Variant)
    
    mstrGrpCd = vNewValue

End Property

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property
Public Property Get GrpDiv() As Variant
    
    GrpDiv = mintGrpDiv

End Property

Public Property Let GrpDiv(ByVal vNewValue As Variant)

    mintGrpDiv = vNewValue

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
    
    'グループ区分が検査項目の場合、処理しない（順番がめちゃくちゃになるから）
    If mintGrpDiv = MODE_RESULT Then Exit Sub
    
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
'##2003.09.11  T-ISHI@FSIT 見出しコメント修正
Private Sub lsvItem_DblClick()

On Error GoTo ErrorHandle


    Dim objItemTitle    As frmMidashi     '見出し表示用
    Dim objItem         As ListItem       'リストアイテムオブジェクト
    Dim i               As Long           'インデックス
    Dim vntrslCaption   As Variant        '記入された見出しコメント
    Dim strKey          As String         '重複チェック用のキー
    Dim strItemString   As String
    Dim strItemKey      As String         'リストビュー用アイテムキー
    Dim strItemCdString As String         '表示用キー編集領域
        
        
    Set objItemTitle = frmMidashi

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then Exit Sub

    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '配列を確認
    For i = 1 To lsvItem.ListItems.Count
            '選択した項目だったら
            If lsvItem.ListItems(i).Selected = True Then
                If lsvItem.ListItems(i).SubItems(2) = "" Then
                    objItemTitle.rslCaption = lsvItem.ListItems(i).SubItems(1)
                
                    '見出し記入画面表示
                    objItemTitle.Show vbModal
                    
                    '戻り値としてのプロパティ取得
                    vntrslCaption = objItemTitle.rslCaption
                    
                    '戻り値がNULLの場合
                    If vntrslCaption = "" Then
                        Screen.MousePointer = vbDefault
                        Exit Sub
                    End If
                    
                    lsvItem.ListItems(i).SubItems(1) = vntrslCaption
                Else
'                    MsgBox "選択した項目は変更出来ません。", vbExclamation
                    Screen.MousePointer = vbDefault
                    Exit Sub
                End If
            End If
    Next i
    
ErrorHandle:

    Set objItemTitle = Nothing
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


