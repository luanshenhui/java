VERSION 5.00
Begin VB.Form frmEditCalcItem 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "計算行の編集"
   ClientHeight    =   5385
   ClientLeft      =   225
   ClientTop       =   330
   ClientWidth     =   11265
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditCalcItem.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5385
   ScaleWidth      =   11265
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.Frame Frame2 
      Caption         =   "計算イメージ"
      Height          =   735
      Left            =   180
      TabIndex        =   27
      Top             =   4020
      Width           =   10875
      Begin VB.Label lblCalcImage 
         Caption         =   "（　体脂肪　×　3.2　）　÷　（　4.2　）　＝　計算結果"
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
         TabIndex        =   28
         Top             =   360
         Width           =   10335
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "左辺"
      Height          =   2655
      Index           =   1
      Left            =   6060
      TabIndex        =   23
      Top             =   780
      Width           =   4995
      Begin VB.TextBox txtSuffix 
         Height          =   315
         Index           =   1
         Left            =   1440
         TabIndex        =   15
         Text            =   "88"
         Top             =   1860
         Width           =   315
      End
      Begin VB.TextBox txtItemCd 
         Height          =   315
         Index           =   1
         Left            =   600
         TabIndex        =   14
         Text            =   "888888"
         Top             =   1860
         Width           =   675
      End
      Begin VB.CommandButton cmdItemGuide 
         Caption         =   "参照(&R)..."
         Height          =   315
         Index           =   1
         Left            =   600
         TabIndex        =   16
         Top             =   2220
         Width           =   1155
      End
      Begin VB.TextBox txtConstant 
         Alignment       =   1  '右揃え
         Height          =   330
         Index           =   1
         Left            =   3480
         MaxLength       =   8
         TabIndex        =   18
         Text            =   "@@@@@@@@"
         Top             =   1140
         Width           =   1095
      End
      Begin VB.ComboBox cboBeforeResult 
         Height          =   300
         Index           =   1
         ItemData        =   "frmEditCalcItem.frx":000C
         Left            =   660
         List            =   "frmEditCalcItem.frx":002E
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   12
         Top             =   1140
         Width           =   2370
      End
      Begin VB.OptionButton optRightSelect 
         Caption         =   "定数のみ(&4)"
         Height          =   315
         Index           =   0
         Left            =   360
         TabIndex        =   10
         Top             =   420
         Value           =   -1  'True
         Width           =   1695
      End
      Begin VB.OptionButton optRightSelect 
         Caption         =   "前行の検査結果を指定する(&5)"
         Height          =   315
         Index           =   1
         Left            =   360
         TabIndex        =   11
         Top             =   780
         Width           =   2595
      End
      Begin VB.OptionButton optRightSelect 
         Caption         =   "検査項目を指定する(&6)"
         Height          =   315
         Index           =   2
         Left            =   360
         TabIndex        =   13
         Top             =   1560
         Width           =   2835
      End
      Begin VB.Label Label6 
         Caption         =   "-"
         Height          =   255
         Index           =   1
         Left            =   1320
         TabIndex        =   31
         Top             =   1920
         Width           =   135
      End
      Begin VB.Label lblItemName 
         Caption         =   "体脂肪"
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
         Index           =   1
         Left            =   1860
         TabIndex        =   30
         Top             =   1920
         Width           =   2835
      End
      Begin VB.Label Label4 
         Caption         =   "×"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   18
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   3060
         TabIndex        =   24
         Top             =   1080
         Width           =   375
      End
      Begin VB.Label Label3 
         Caption         =   "定数(&U)"
         Height          =   255
         Left            =   3480
         TabIndex        =   17
         Top             =   840
         Width           =   855
      End
   End
   Begin VB.ComboBox cboOperator 
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   21.75
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   555
      ItemData        =   "frmEditCalcItem.frx":0050
      Left            =   5220
      List            =   "frmEditCalcItem.frx":005A
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   9
      Top             =   1740
      Width           =   810
   End
   Begin VB.Frame Frame1 
      Caption         =   "左辺"
      Height          =   2715
      Index           =   0
      Left            =   180
      TabIndex        =   21
      Top             =   720
      Width           =   4995
      Begin VB.TextBox txtSuffix 
         Height          =   315
         Index           =   0
         Left            =   1440
         TabIndex        =   5
         Text            =   "88"
         Top             =   1860
         Width           =   315
      End
      Begin VB.TextBox txtItemCd 
         Height          =   315
         Index           =   0
         Left            =   600
         TabIndex        =   4
         Text            =   "888888"
         Top             =   1860
         Width           =   675
      End
      Begin VB.TextBox txtConstant 
         Alignment       =   1  '右揃え
         Height          =   330
         Index           =   0
         Left            =   3480
         MaxLength       =   8
         TabIndex        =   8
         Text            =   "@@@@@@@@"
         Top             =   1140
         Width           =   1095
      End
      Begin VB.CommandButton cmdItemGuide 
         Caption         =   "参照(&L)..."
         Height          =   315
         Index           =   0
         Left            =   600
         TabIndex        =   6
         Top             =   2220
         Width           =   1155
      End
      Begin VB.ComboBox cboBeforeResult 
         Height          =   300
         Index           =   0
         ItemData        =   "frmEditCalcItem.frx":0066
         Left            =   600
         List            =   "frmEditCalcItem.frx":0088
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   2
         Top             =   1140
         Width           =   2370
      End
      Begin VB.OptionButton optLeftSelect 
         Caption         =   "検査項目を指定する(&3)"
         Height          =   315
         Index           =   2
         Left            =   360
         TabIndex        =   3
         Top             =   1560
         Width           =   2835
      End
      Begin VB.OptionButton optLeftSelect 
         Caption         =   "前行の検査結果を指定する(&2)"
         Height          =   315
         Index           =   1
         Left            =   360
         TabIndex        =   1
         Top             =   780
         Width           =   2595
      End
      Begin VB.OptionButton optLeftSelect 
         Caption         =   "定数のみ(&1)"
         Height          =   315
         Index           =   0
         Left            =   360
         TabIndex        =   0
         Top             =   420
         Value           =   -1  'True
         Width           =   1695
      End
      Begin VB.Label Label6 
         Caption         =   "-"
         Height          =   255
         Index           =   0
         Left            =   1320
         TabIndex        =   29
         Top             =   1920
         Width           =   135
      End
      Begin VB.Label lblItemName 
         Caption         =   "体脂肪"
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
         Index           =   0
         Left            =   1860
         TabIndex        =   25
         Top             =   1920
         Width           =   2835
      End
      Begin VB.Label Label2 
         Caption         =   "定数(&T)"
         Height          =   255
         Left            =   3480
         TabIndex        =   7
         Top             =   840
         Width           =   855
      End
      Begin VB.Label Label1 
         Caption         =   "×"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   18
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   3060
         TabIndex        =   22
         Top             =   1140
         Width           =   375
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   9720
      TabIndex        =   20
      Top             =   4920
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   8280
      TabIndex        =   19
      Top             =   4920
      Width           =   1335
   End
   Begin VB.Label Label7 
      Caption         =   "計算式を設定してください"
      Height          =   255
      Left            =   780
      TabIndex        =   32
      Top             =   240
      Width           =   6375
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   4
      Left            =   180
      Picture         =   "frmEditCalcItem.frx":00AA
      Top             =   120
      Width           =   480
   End
   Begin VB.Label Label5 
      Caption         =   "※定数は、定数のみ、前行の検査結果、検査項目、いずれを選択しても有効です。（計算します）"
      Height          =   255
      Left            =   240
      TabIndex        =   26
      Top             =   3600
      Width           =   7095
   End
End
Attribute VB_Name = "frmEditCalcItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd              As String           '検査項目コード
Private mstrSuffix              As String           'サフィックス

Private mstrVariable1           As String
Private mstrCalcItemCd1         As String
Private mstrCalcSuffix1         As String
Private mstrCalcItemName1       As String
Private mstrConstant1           As String
Private mstrOperator            As String
Private mstrVariable2           As String
Private mstrCalcItemCd2         As String
Private mstrCalcSuffix2         As String
Private mstrCalcItemName2       As String
Private mstrConstant2           As String
Private mintCalcLine            As Integer

Private mblnUpdated             As Boolean          'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション
Private mblnModeNew             As Boolean          'TRUE:新規、FALSE:更新

Private Sub cboBeforeResult_Click(Index As Integer)
    
    '計算イメージの表示
    Call EditCalcString

End Sub

Private Sub cboOperator_Click()
    
    Call EditCalcString
    
End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdItemGuide_Click(Index As Integer)
    
    Dim objItemGuide        As mntItemGuide.ItemGuide   '項目ガイド表示用
    Dim objItem             As ListItem                 'リストアイテムオブジェクト
    
    Dim i                   As Long     'インデックス
    Dim strKey              As String   '重複チェック用のキー
    Dim strItemString       As String
    Dim strItemKey          As String   'リストビュー用アイテムキー
    Dim strItemCdString     As String   '表示用キー編集領域
    
    Dim lngItemCount        As Long     '選択項目数
    Dim vntItemCd           As Variant  '選択された項目コード
    Dim vntSuffix           As Variant  '選択されたサフィックス
    Dim vntItemName         As Variant  '選択された項目名
    Dim vntClassName        As Variant  '選択された検査分類名
    Dim vntResultType(2)    As Variant  '結果タイプ
    
    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
        vntResultType(0) = RESULTTYPE_NUMERIC
        vntResultType(1) = RESULTTYPE_CALC
        '文章項目も計算対象に含める
        vntResultType(2) = RESULTTYPE_SENTENCE
        .ResultType = vntResultType
        .MultiSelect = False
    
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
        
        If (vntItemCd(i) = mstrItemCd) And (vntSuffix(i) = mstrSuffix) Then
            '選択検索項目が自分自身と同じ場合、リカーシブルになるのでとめる
            MsgBox "自分自身を計算項目に含めることはできません", vbExclamation, Me.Caption
        Else
            txtItemCd(Index).Text = vntItemCd(i)
            txtSuffix(Index).Text = vntSuffix(i)
            lblItemName(Index).Caption = vntItemName(i)
        End If
        
    End If

    '計算イメージの表示
    Call EditCalcString

    Set objItemGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Sub cmdOk_Click()

    '入力チェック
    If CheckValue() = False Then Exit Sub
    
    'プロパティ値の画面セット
    Call SetProperty

    mblnUpdated = True
    Unload Me
    
End Sub

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

    Dim Ret             As Boolean  '関数戻り値
    Dim strWorkResult   As String
    Dim strItemName     As String
        
    '同一コントロールのSetFocusでは文字列選択が有効にならないのでダミーでとばす
    cmdOk.SetFocus
    
    Ret = False
    
    Do

        '左辺 -------------------------------------------------------------------------------
        '定数（左辺）が未入力なら１セット
        If Trim(txtConstant(0).Text) = "" Then
            txtConstant(0).Text = 1
        End If

        '定数（左辺）の数値チェック
        If IsNumeric(txtConstant(0).Text) = False Then
            MsgBox "定数には数値を入力してください。", vbExclamation, App.Title
            txtConstant(0).SetFocus
            Exit Do
        End If

        '前行結果指定時のチェック
        If optLeftSelect(1).Value = True Then
            If cboBeforeResult(0).ListIndex < 0 Then
                MsgBox "計算対象となる検査結果行が指定されていません。", vbExclamation, App.Title
                cboBeforeResult(0).SetFocus
                Exit Do
            End If
        End If

        '検査項目指定時のチェック
        If optLeftSelect(2).Value = True Then
            If Trim(lblItemName(0).Caption) = "" Then
                If GetItemInfo(txtItemCd(0).Text, txtSuffix(0).Text, strItemName) = False Then
                    txtItemCd(0).SetFocus
                    Exit Do
                Else
                lblItemName(0).Caption = strItemName
                End If
            End If
        End If

        '右辺 -------------------------------------------------------------------------------
        '定数（右辺）が未入力なら１セット
        If Trim(txtConstant(1).Text) = "" Then
            txtConstant(1).Text = 1
        End If

        '定数（右辺）の数値チェック
        If IsNumeric(txtConstant(1).Text) = False Then
            MsgBox "定数には数値を入力してください。", vbExclamation, App.Title
            txtConstant(1).SetFocus
            Exit Do
        End If

        '前行結果指定時のチェック
        If optRightSelect(1).Value = True Then
            If cboBeforeResult(1).ListIndex < 0 Then
                MsgBox "計算対象となる検査結果行が指定されていません。", vbExclamation, App.Title
                cboBeforeResult(1).SetFocus
                Exit Do
            End If
        End If

        '検査項目指定時のチェック
        If optRightSelect(2).Value = True Then
            If Trim(lblItemName(1).Caption) = "" Then
                If GetItemInfo(txtItemCd(1).Text, txtSuffix(1).Text, strItemName) = False Then
                    txtItemCd(1).SetFocus
                    Exit Do
                Else
                lblItemName(1).Caption = strItemName
                End If
            End If
        End If
        
        '0ディバイドのチェック
        If (cboOperator.ListIndex = 3) And _
           (optRightSelect(0).Value = True) And _
           (CDbl(txtConstant(1).Text) = 0) Then
            MsgBox "０で除算することは許されません。", vbExclamation, App.Title
            txtConstant(1).SetFocus
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
' 機能　　 : 検査項目情報取得
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査項目の基本情報を取得する
'
' 備考　　 :
'
Private Function GetItemInfo(strItemCd As String, _
                             strSuffix As String, _
                             strItemName As String) As Boolean

On Error GoTo ErrorHandle

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
    Dim Ret                 As Boolean              '戻り値
    
    GetItemInfo = False
    
    Ret = False
    
    Do
        
        '検索条件が指定されていない場合は何もしない
        If (strItemCd = "") Or (strSuffix = "") Then
            MsgBox "正しい検査項目コードを入力してください。", vbExclamation, App.Title
            Exit Do
        End If
        
        'オブジェクトのインスタンス作成
        Set objItem = CreateObject("HainsItem.Item")
        
        '検査項目テーブルレコード読み込み
        If objItem.SelectItemHeader(strItemCd, _
                                    strSuffix, _
                                    vntItemName, _
                                    vntitemEName, _
                                    vntClassName, _
                                    vntRslQue, _
                                    vntRslqueName, _
                                    vntItemType, _
                                    vntItemTypeName, _
                                    vntResultType, _
                                    vntResultTypeName) = False Then
            
            MsgBox "入力された検査項目コードは存在しません。", vbExclamation, App.Title
            Exit Do
        
        End If

        '結果タイプをチェック（数値、計算、文章）
'        If CInt(vntResultType) <> RESULTTYPE_NUMERIC Then
        If (CInt(vntResultType) <> RESULTTYPE_NUMERIC) And _
           (CInt(vntResultType) <> RESULTTYPE_CALC) And _
           (CInt(vntResultType) <> RESULTTYPE_SENTENCE) Then

            MsgBox "指定された項目「" & vntItemName & "」は計算対象として有効な結果タイプではありません。", vbExclamation, App.Title
            Exit Do
        End If
        
        strItemName = vntItemName
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    GetItemInfo = Ret
    Set objItem = Nothing
    
    Exit Function

ErrorHandle:

    GetItemInfo = False
    MsgBox Err.Description, vbCritical
    Set objItem = Nothing
    
End Function

Private Sub Form_Load()

    Dim i       As Integer

    mblnUpdated = False

    '画面初期化
    Call InitializeForm

    '計算状態のセット
    Call SetCalcListItem

End Sub

Private Sub InitializeForm()

    Dim i   As Integer

    '共通モジュールでのコントロール初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    '演算記号のコンボセット
    With cboOperator
        .Clear
        .AddItem "＋"
        .AddItem "－"
        .AddItem "×"
        .AddItem "÷"
        .AddItem "＾"
        .ListIndex = 0
    End With

    'コンボクリックから初期化処理を行う
    Call optLeftSelect_Click(0)
    Call optRightSelect_Click(0)

    '定数初期化
    txtConstant(0).Text = 1
    txtConstant(1).Text = 1

    For i = 0 To mintCalcLine - 1
        cboBeforeResult(0).AddItem i + 1 & "行目の計算結果"
        cboBeforeResult(1).AddItem i + 1 & "行目の計算結果"
    Next i

End Sub

Private Sub SetCalcListItem()

    '演算子のセット
    Select Case mstrOperator
        Case "+"
            cboOperator.ListIndex = 0
        Case "-"
            cboOperator.ListIndex = 1
        Case "*"
            cboOperator.ListIndex = 2
        Case "/"
            cboOperator.ListIndex = 3
        Case "^"
            cboOperator.ListIndex = 4
    End Select

    '定数のセット
    txtConstant(0).Text = mstrConstant1
    txtConstant(1).Text = mstrConstant2

    '前行の検査結果設定の場合
    If IsNumeric(mstrVariable1) Then
        If CInt(mstrVariable1) < (cboBeforeResult(0).ListCount + 1) Then
            optLeftSelect(1).Value = True
            cboBeforeResult(0).ListIndex = CInt(mstrVariable1) - 1
        End If
    End If
    
    '検査項目指定の場合
    If (mstrCalcItemCd1 <> "") And (mstrCalcSuffix1 <> "") Then
        optLeftSelect(2).Value = True
        txtItemCd(0).Text = mstrCalcItemCd1
        txtSuffix(0).Text = mstrCalcSuffix1
        lblItemName(0).Caption = mstrCalcItemName1
    End If

    '前行の検査結果設定の場合
    If IsNumeric(mstrVariable2) Then
        If CInt(mstrVariable2) < (cboBeforeResult(1).ListCount + 1) Then
            optRightSelect(1).Value = True
            cboBeforeResult(1).ListIndex = CInt(mstrVariable2) - 1
        End If
    End If
    
    '検査項目指定の場合
    If (mstrCalcItemCd2 <> "") And (mstrCalcSuffix2 <> "") Then
        optRightSelect(2).Value = True
        txtItemCd(1).Text = mstrCalcItemCd2
        txtSuffix(1).Text = mstrCalcSuffix2
        lblItemName(1).Caption = mstrCalcItemName2
    End If

    '計算イメージの表示
    Call EditCalcString
    
End Sub
Private Sub optLeftSelect_Click(Index As Integer)

    Call CntlCalcOption(Index, 0)
    
End Sub

Private Sub optRightSelect_Click(Index As Integer)
    
    Call CntlCalcOption(Index, 1)

End Sub

Public Sub CntlCalcOption(Index As Integer, intSide As Integer)

    '計算行が１行目なら、前行選択コンボは使用不可
    If mintCalcLine < 1 Then
        optLeftSelect(1).Enabled = False
        optRightSelect(1).Enabled = False
    End If

    'セレクトされたオプションボタンに応じ、処理制御を行う
    Select Case Index
        
        Case 0      '定数のみ
            cboBeforeResult(intSide).Enabled = False
            
            cmdItemGuide(intSide).Enabled = False
            txtItemCd(intSide).Enabled = False
            txtSuffix(intSide).Enabled = False
            
            txtItemCd(intSide).BackColor = vbButtonFace
            txtSuffix(intSide).BackColor = vbButtonFace
            lblItemName(intSide).ForeColor = vbGrayText
            
        Case 1      '前行の検査結果を指定する
            cboBeforeResult(intSide).Enabled = True
            
            cmdItemGuide(intSide).Enabled = False
            txtItemCd(intSide).Enabled = False
            txtSuffix(intSide).Enabled = False
            txtItemCd(intSide).BackColor = vbButtonFace
            txtSuffix(intSide).BackColor = vbButtonFace
            lblItemName(intSide).ForeColor = vbGrayText
        
        Case 2      '検査項目を指定する
            cboBeforeResult(intSide).Enabled = False
            
            cmdItemGuide(intSide).Enabled = True
            txtItemCd(intSide).Enabled = True
            txtSuffix(intSide).Enabled = True
            txtItemCd(intSide).BackColor = vbWindowBackground
            txtSuffix(intSide).BackColor = vbWindowBackground
            lblItemName(intSide).ForeColor = vbButtonText
    
    End Select
    
    '計算イメージの表示
    Call EditCalcString
    
End Sub

Private Sub txtConstant_GotFocus(Index As Integer)

    With txtConstant(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub

Friend Property Get Variable1() As String

    Variable1 = mstrVariable1
    
End Property

Friend Property Let Variable1(ByVal vNewValue As String)

    mstrVariable1 = vNewValue

End Property

Friend Property Get CalcItemCd1() As String

    CalcItemCd1 = mstrCalcItemCd1
    
End Property

Friend Property Let CalcItemCd1(ByVal vNewValue As String)

    mstrCalcItemCd1 = vNewValue

End Property

Friend Property Get CalcItemName1() As String

    CalcItemName1 = mstrCalcItemName1
    
End Property

Friend Property Let CalcItemName1(ByVal vNewValue As String)

    mstrCalcItemName1 = vNewValue

End Property

Friend Property Get CalcSuffix1() As String

    CalcSuffix1 = mstrCalcSuffix1
    
End Property

Friend Property Let CalcSuffix1(ByVal vNewValue As String)

    mstrCalcSuffix1 = vNewValue

End Property

Friend Property Get Constant1() As String

    Constant1 = mstrConstant1
    
End Property

Friend Property Let Constant1(ByVal vNewValue As String)

    mstrConstant1 = vNewValue

End Property

Friend Property Get Operator() As String

    Operator = mstrOperator
    
End Property

Friend Property Let Operator(ByVal vNewValue As String)

    mstrOperator = vNewValue

End Property

Friend Property Get Variable2() As String

    Variable2 = mstrVariable2
    
End Property

Friend Property Let Variable2(ByVal vNewValue As String)

    mstrVariable2 = vNewValue

End Property

Friend Property Get CalcItemCd2() As String

    CalcItemCd2 = mstrCalcItemCd2
    
End Property

Friend Property Let CalcItemCd2(ByVal vNewValue As String)

    mstrCalcItemCd2 = vNewValue

End Property

Friend Property Get CalcSuffix2() As String

    CalcSuffix2 = mstrCalcSuffix2
    
End Property

Friend Property Let CalcSuffix2(ByVal vNewValue As String)

    mstrCalcSuffix2 = vNewValue

End Property

Friend Property Get CalcItemName2() As String

    CalcItemName2 = mstrCalcItemName2
    
End Property

Friend Property Let CalcItemName2(ByVal vNewValue As String)

    mstrCalcItemName2 = vNewValue

End Property

Friend Property Get Constant2() As String

    Constant2 = mstrConstant2
    
End Property

Friend Property Let Constant2(ByVal vNewValue As String)

    mstrConstant2 = vNewValue

End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Private Sub txtConstant_LostFocus(Index As Integer)

    '計算イメージの表示
    Call EditCalcString

End Sub

Private Sub txtItemCd_Change(Index As Integer)
        
    lblItemName(Index).Caption = ""

End Sub

Private Sub txtItemCd_GotFocus(Index As Integer)

    With txtItemCd(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub

Private Sub txtItemCd_LostFocus(Index As Integer)

    'コードがセットされていないなら、名称をクリア
    If Trim(txtItemCd(Index).Text) = "" Then
        lblItemName(Index).Caption = ""
    End If

    '計算イメージの表示
    Call EditCalcString

End Sub

Private Sub txtSuffix_Change(Index As Integer)
    
    lblItemName(Index).Caption = ""

End Sub

Private Sub txtSuffix_GotFocus(Index As Integer)

    With txtSuffix(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub

Private Sub txtSuffix_LostFocus(Index As Integer)

    'コードをセットされていないなら、名称クリア
    If Trim(txtSuffix(Index).Text) = "" Then
        lblItemName(Index).Caption = ""
    End If

    '計算イメージの表示
    Call EditCalcString

End Sub

Public Property Let CalcLine(ByVal vNewValue As Integer)

    mintCalcLine = vNewValue

End Property

Private Sub SetProperty()

    mstrVariable1 = ""
    mstrCalcItemCd1 = ""
    mstrCalcSuffix1 = ""
    mstrCalcItemName1 = ""
    mstrConstant1 = ""
    mstrOperator = ""
    mstrVariable2 = ""
    mstrCalcItemCd2 = ""
    mstrCalcSuffix2 = ""
    mstrCalcItemName2 = ""
    mstrConstant2 = ""

    '左辺の編集
    mstrConstant1 = txtConstant(0).Text
    Select Case True
        '前行の検査結果を指定する
        Case optLeftSelect(1).Value
            mstrVariable1 = cboBeforeResult(0).ListIndex + 1
        '検査項目を指定する
        Case optLeftSelect(2).Value
            mstrCalcItemCd1 = txtItemCd(0).Text
            mstrCalcSuffix1 = txtSuffix(0).Text
            mstrCalcItemName1 = lblItemName(0)
    End Select
        
    Select Case cboOperator.ListIndex
        Case 0
            mstrOperator = "+"
        Case 1
            mstrOperator = "-"
        Case 2
            mstrOperator = "*"
        Case 3
            mstrOperator = "/"
        Case 4
            mstrOperator = "^"
    End Select
        
    '右辺の編集
    mstrConstant2 = txtConstant(1).Text
    Select Case True
        '前行の検査結果を指定する
        Case optRightSelect(1).Value
            mstrVariable2 = cboBeforeResult(1).ListIndex + 1
        '検査項目を指定する
        Case optRightSelect(2).Value
            mstrCalcItemCd2 = txtItemCd(1).Text
            mstrCalcSuffix2 = txtSuffix(1).Text
            mstrCalcItemName2 = lblItemName(1)
    End Select

End Sub

' @(e)
'
' 機能　　 : 計算式の編集
'
' 引数　　 : なし
'
' 戻り値　 : なし
'
' 機能説明 : 表示用に計算データを再編集する
'
' 備考　　 :
'
Private Sub EditCalcString()

    Dim strCalcString       As String
    Dim strWorkString       As String
        
    strCalcString = ""
    
    '左辺 ---------------------------------------------------------------------
    strWorkString = ""
    
    '変数がセットされている場合の処理
    If optLeftSelect(1).Value = True Then
        strWorkString = cboBeforeResult(0).Text
    End If
    
    '検査項目コードがセットされている場合の処理
    If optLeftSelect(2).Value = True Then
        
        If Trim(lblItemName(0).Caption) = "" Then
            strWorkString = "？？？"
        Else
            strWorkString = lblItemName(0).Caption
        End If
    
    End If

    '変数、もしくは検査項目コードがセットされている場合の定数表示
    If (optLeftSelect(1).Value = True) Or (optLeftSelect(2).Value = True) Then
        
        If IsNumeric(Trim(txtConstant(0).Text)) Then
            '定数が１ではない場合に、式を編集
            If CDbl(Trim(txtConstant(0).Text)) <> 1 Then
                strWorkString = "( " & strWorkString & "× " & Trim(txtConstant(0).Text) & " )"
            End If
        End If
    Else
        '定数のみの場合は、そのままセット
        strWorkString = Trim(txtConstant(0).Text)
    End If
    
    '演算子 -------------------------------------------------------------------
    strCalcString = strWorkString & "　" & cboOperator.Text & "　"
    
    '右辺 ---------------------------------------------------------------------
    strWorkString = ""
    
    '変数がセットされている場合の処理
    If optRightSelect(1).Value = True Then
        strWorkString = cboBeforeResult(1).Text
    End If
    
    '検査項目コードがセットされている場合の処理
    If optRightSelect(2).Value = True Then
        If Trim(lblItemName(1).Caption) = "" Then
            strWorkString = "？？？"
        Else
            strWorkString = lblItemName(1).Caption
        End If
    End If

    '変数、もしくは検査項目コードがセットされている場合の定数表示
    If (optRightSelect(1).Value = True) Or (optRightSelect(2).Value = True) Then
        
        If IsNumeric(Trim(txtConstant(1).Text)) Then
            '定数が１ではない場合に、式を編集
            If CDbl(Trim(txtConstant(1).Text)) <> 1 Then
                strWorkString = "( " & strWorkString & "× " & Trim(txtConstant(1).Text) & " )"
            End If
        End If
    Else
        '定数のみの場合は、そのままセット
        strWorkString = Trim(txtConstant(1).Text)
    End If
    
    lblCalcImage.Caption = strCalcString & strWorkString
    
End Sub

Friend Property Let ItemCd(ByVal vNewValue As String)

    mstrItemCd = vNewValue
    
End Property

Friend Property Let Suffix(ByVal vNewValue As String)

    mstrSuffix = vNewValue
    
End Property
