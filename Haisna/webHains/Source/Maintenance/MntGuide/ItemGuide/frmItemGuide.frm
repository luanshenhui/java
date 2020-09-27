VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmItemGuide 
   Caption         =   "項目ガイド"
   ClientHeight    =   6555
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5115
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmItemGuide.frx":0000
   LinkTopic       =   "Form1"
   MinButton       =   0   'False
   ScaleHeight     =   6555
   ScaleWidth      =   5115
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboResultType 
      Height          =   300
      ItemData        =   "frmItemGuide.frx":0442
      Left            =   1620
      List            =   "frmItemGuide.frx":0464
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   10
      Top             =   1440
      Width           =   3450
   End
   Begin VB.OptionButton optDiv 
      Caption         =   "検査項目(&I)"
      Height          =   255
      Index           =   1
      Left            =   3120
      TabIndex        =   8
      Top             =   780
      Width           =   1515
   End
   Begin VB.OptionButton optDiv 
      Caption         =   "グループ(&G)"
      Height          =   255
      Index           =   0
      Left            =   1620
      TabIndex        =   7
      Top             =   780
      Width           =   1515
   End
   Begin VB.ComboBox cboItemClass 
      Height          =   300
      ItemData        =   "frmItemGuide.frx":0486
      Left            =   1620
      List            =   "frmItemGuide.frx":04A8
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   3
      Top             =   1080
      Width           =   3450
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2280
      TabIndex        =   0
      Top             =   6180
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3720
      TabIndex        =   1
      Top             =   6180
      Width           =   1335
   End
   Begin MSComctlLib.ListView lsvItem 
      Height          =   4215
      Left            =   120
      TabIndex        =   2
      Top             =   1860
      Width           =   4935
      _ExtentX        =   8705
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
   Begin VB.Label Label8 
      Caption         =   "結果タイプ(&T):"
      Height          =   195
      Index           =   0
      Left            =   180
      TabIndex        =   9
      Top             =   1500
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "表示項目(&P):"
      Height          =   195
      Index           =   2
      Left            =   180
      TabIndex        =   6
      Top             =   780
      Width           =   1335
   End
   Begin VB.Label LabelTitle 
      Caption         =   "項目を選択してください"
      Height          =   375
      Left            =   780
      TabIndex        =   5
      Top             =   240
      Width           =   4275
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   0
      Picture         =   "frmItemGuide.frx":04CA
      Top             =   60
      Width           =   720
   End
   Begin VB.Label Label8 
      Caption         =   "検査項目分類(&C):"
      Height          =   195
      Index           =   1
      Left            =   180
      TabIndex        =   4
      Top             =   1140
      Width           =   1455
   End
End
Attribute VB_Name = "frmItemGuide"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'プロパティ用定義領域
Private mblnRet         As Boolean  '戻り値

Private mintMode        As Integer  '依頼結果モード（1:依頼モード、2:結果モード）
Private mintGroup       As Integer  'グループ項目表示有無
Private mintItem        As Integer  '検査項目表示有無
'Private mintResultType  As Integer  '結果タイプ
Private mvntResultType  As Variant  '結果タイプ（配列）
Private mintQuestion    As Integer  '問診項目表示有無
Private mblnNowEdit     As Boolean  'TRUE:編集中、FALSE:表示用編集可能
Private mblnMultiSelect As Boolean  'リストビューの複数選択
Private mstrClassCd     As String   '検査分類コード

Private mstrArrResultType() As String  '結果タイプコンボ対応キー格納領域

Private mintItemCount   As Integer  '選択された項目数
Private mstrItemDiv     As String   '選択されたモード（G:グループ,I:検査項目）
Private mvntItemCd()    As Variant  '選択された項目コード
Private mvntSuffix()    As Variant  '選択された項目コード
Private mvntItemName()  As Variant  '選択された項目名
Private mvntClassName() As Variant  '選択された項目の分類名称

'モジュールレベル変数
Private mstrArrClassCd()   As String   '検査分類コード

'固定コード管理
Const mstrGrpName       As String = "グループ"
Const mstrItemName      As String = "検査項目"
Const mstrListViewKey   As String = "K"

Const GRPDIV_ITEM       As String = "I"
Const GRPDIV_GRP        As String = "G"

Public Property Get Ret() As Variant

    Ret = mblnRet

End Property

' @(e)
'
' 機能　　 : 項目リスト編集
'
' 機能説明 : コンボボックスで指定された内容の項目一覧を表示する。
'
' 備考　　 :
'
Private Sub EditItemList()

On Error GoTo ErrorHandle

    Dim objItem         As Object           '検査項目アクセス用
    Dim objGrp          As Object           'グループアクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objListItem     As ListItem         'リストアイテムオブジェクト

    Dim Ret             As Boolean          '戻り値
    Dim dtmStrDate      As Date
    Dim dtmEndDate      As Date

    Dim vntCd           As Variant          '検査項目コード
    Dim vntSuffix       As Variant          'サフィックス
    Dim vntName         As Variant          '名称
    Dim vntClassCd      As Variant          '検査分類コード
    Dim vntClassName    As Variant          '検査分類名
    Dim strItemCd       As String
    
    Dim lngCount    As Long                 'レコード数
    Dim i           As Long                 'インデックス

    Screen.MousePointer = vbHourglass
    
    mblnNowEdit = True
    
    'リストアイテムクリア
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    vntClassCd = mstrArrClassCd(cboItemClass.ListIndex)
    
    '表示項目がグループの場合
    If optDiv(0).Value = True Then
        Set objGrp = CreateObject("HainsGrp.Grp")
        lngCount = objGrp.SelectGrp_IList_GrpDiv(mintMode, vntCd, vntName, vntClassCd, , , vntClassName, True)
                                                 
    End If
    
    '表示項目が検査項目（依頼項目）の場合
    If optDiv(1).Value = True And _
       (mintMode = MODE_REQUEST) Then
        Set objItem = CreateObject("HainsItem.Item")
        lngCount = objItem.SelectItem_pList(vntClassCd, "", mintQuestion, vntCd, vntSuffix, vntName, , vntClassName)
                                           
    End If
    
    '表示項目が検査項目（検査項目）の場合
    If optDiv(1).Value = True And _
       (mintMode = MODE_RESULT) Then
        
        Set objItem = CreateObject("HainsItem.Item")
        
        '結果タイプが指定されている場合と呼出方をわける
'        If mintResultType <> -1 Then
        If Trim(mstrArrResultType(cboResultType.ListIndex)) <> "" Then
            lngCount = objItem.SelectItem_cList(vntClassCd, "", mintQuestion, vntCd, vntSuffix, vntName, vntClassName, mstrArrResultType(cboResultType.ListIndex))
        Else
            lngCount = objItem.SelectItem_cList(vntClassCd, "", mintQuestion, vntCd, vntSuffix, vntName, vntClassName)
        End If
                                           
    End If
    
    'ヘッダの編集
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コード", 1000, lvwColumnLeft
    objHeader.Add , , "名称", 1800, lvwColumnLeft
    objHeader.Add , , "検査分類", 1500, lvwColumnLeft
    lsvItem.View = lvwReport
    
    '項目リストの編集
    For i = 0 To lngCount - 1
                
        '検査項目（結果）の場合は、サフィックスを編集して表示
        If optDiv(1).Value = True And _
           (mintMode = MODE_RESULT) Then
            strItemCd = vntCd(i) & "-" & vntSuffix(i)
        Else
            strItemCd = vntCd(i)
        End If
                
        Set objListItem = lsvItem.ListItems.Add(, mstrListViewKey & strItemCd, strItemCd)
        objListItem.SubItems(1) = vntName(i)
        objListItem.SubItems(2) = vntClassName(i)
    
    Next i
    
    '項目が１行以上存在した場合、無条件に先頭が選択されるため解除する。
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    Set objItem = Nothing
    Set objGrp = Nothing
    Screen.MousePointer = vbDefault
    mblnNowEdit = False
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objItem = Nothing
    Set objGrp = Nothing
    Screen.MousePointer = vbDefault
    mblnNowEdit = False
    
End Sub
' @(e)
'
' 機能　　 : 「検査分類コンボ」Click
'
' 機能説明 : 検査分類コンボ内容を変更された時に、検査項目表示内容を変更する。
'
' 備考　　 :
'
Private Sub cboItemClass_Click()

    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '項目リスト編集
    Call EditItemList

End Sub


Private Sub cboResultType_Click()

    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '項目リスト編集
    Call EditItemList

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

    mintItemCount = 0
    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : 「ＯＫ」クリック
'
' 機能説明 : 入力内容を適用し、画面を閉じる
'
' 備考　　 :
'
Private Sub CMDok_Click()

    Dim x           As Object
    Dim i           As Integer
    Dim j           As Integer
    Dim strWorkKey  As String
    Dim lngPointer  As Long

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '変数初期化
    mintItemCount = 0
    j = 0
    Erase mvntItemCd
    Erase mvntItemName
    
    '現在表示中の項目分類（グループor単項目）
    If optDiv(0).Value = True Then
        mstrItemDiv = GRPDIV_GRP
    Else
        mstrItemDiv = GRPDIV_ITEM
    End If

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
                ReDim Preserve mvntSuffix(j)
                ReDim Preserve mvntItemName(j)
                ReDim Preserve mvntClassName(j)
                
                'リストビュー用のキープリフィックスを削除
                strWorkKey = Mid(lsvItem.ListItems(i).Key, 2, Len(lsvItem.ListItems(i).Key))
                lngPointer = InStr(strWorkKey, "-")
                If lngPointer <> 0 Then
                    mvntItemCd(j) = Mid(strWorkKey, 1, lngPointer - 1)
                    mvntSuffix(j) = Mid(strWorkKey, lngPointer + 1, Len(strWorkKey))
                Else
                    mvntItemCd(j) = strWorkKey
                    mvntSuffix(j) = ""
                End If
                
                mvntItemName(j) = lsvItem.ListItems(i).SubItems(1)
                mvntClassName(j) = lsvItem.ListItems(i).SubItems(2)
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
    mintItemCount = 0
    mblnNowEdit = True

    Do

        'グループ、単項目どっちも非表示ならおしまい
        If (mintGroup = GROUP_OFF) And (mintItem = ITEM_OFF) Then
            MsgBox "グループ、単項目どちらも非表示に設定されています。設定プロパティを見直してください。", vbCritical, "項目ガイド"
            Exit Do
        End If
        
        'オブションボタンの初期化
        optDiv(0).Value = True
        
        'グループ表示不可なら、グループオプションボタン使用不可
        If mintGroup = GROUP_OFF Then
            optDiv(0).Enabled = False
            optDiv(1).Value = True
        End If
        
        '単項目表示不可なら、オプションボタン使用不可
        If mintItem = ITEM_OFF Then
            optDiv(1).Enabled = False
            optDiv(0).Value = True
        End If

        '検査分類コンボセット
        If EditItemClassCombo() = False Then
            Exit Do
        End If
    
        '結果タイプコンボの編集
        Call EditResultType
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnRet = Ret
    
    '処理中の解除
    mblnNowEdit = False
    
    '項目リスト編集（初期表示）
    Call EditItemList
    
    'リストのマルチセレクトセット
    lsvItem.MultiSelect = mblnMultiSelect
    
    Screen.MousePointer = vbDefault

End Sub

Private Sub EditResultType()

    Dim i   As Integer

    '結果タイプコンボ初期化
    With cboResultType
        .Clear
    End With

    '検査項目非表示時は、結果タイプコンボ使用不可
    If mintItem = ITEM_OFF Then
        cboResultType.Enabled = False
        Exit Sub
    End If

    'コンボ対応配列初期化
    Erase mstrArrResultType
    
    '結果タイプの引数値をチェック
    If IsArray(mvntResultType) Then
        
        '配列指定の場合
        For i = 0 To UBound(mvntResultType)
            ReDim Preserve mstrArrResultType(i)
            mstrArrResultType(i) = mvntResultType(i)
        
            Select Case mvntResultType(i)
                Case RESULTTYPE_NUMERIC         '数値
                    cboResultType.AddItem "0:数値を格納します"
                Case RESULTTYPE_TEISEI1         '定性１
                    cboResultType.AddItem "1:定性（標準：-,+-,+）を格納します"
                Case RESULTTYPE_TEISEI2         '定性２
                    cboResultType.AddItem "2:定性（拡張：-,+-,1+～9+）を格納します"
                Case RESULTTYPE_FREE            'フリー
                    cboResultType.AddItem "3:結果内容を固定しません（フリー）"
                Case RESULTTYPE_SENTENCE        '文章
                    cboResultType.AddItem "4:文章結果を格納します"
                Case RESULTTYPE_CALC            '計算
                    cboResultType.AddItem "5:計算項目です"
                Case RESULTTYPE_DATE            '日付タイプ
                    cboResultType.AddItem "6:日付を格納します"
            End Select
        
        Next i
        cboResultType.ListIndex = 0
    
    Else
        '単数指定の場合
        
        'とりあえず１回セット
        With cboResultType
            .AddItem ""
            .AddItem "0:数値を格納します"
            .AddItem "1:定性（標準：-,+-,+）を格納します"
            .AddItem "2:定性（拡張：-,+-,1+～9+）を格納します"
            .AddItem "3:結果内容を固定しません（フリー）"
            .AddItem "4:文章結果を格納します"
            .AddItem "5:計算項目です"
            .AddItem "6:日付を格納します"
            .ListIndex = 0
        End With
        
        ReDim Preserve mstrArrResultType(7)
        mstrArrResultType(1) = RESULTTYPE_NUMERIC
        mstrArrResultType(2) = RESULTTYPE_TEISEI1
        mstrArrResultType(3) = RESULTTYPE_TEISEI2
        mstrArrResultType(4) = RESULTTYPE_FREE
        mstrArrResultType(5) = RESULTTYPE_SENTENCE
        mstrArrResultType(6) = RESULTTYPE_CALC
        mstrArrResultType(7) = RESULTTYPE_DATE
        
        '数値かつ、有効な結果タイプを指定されている場合それだけセット
        If IsNumeric(mvntResultType) Then
            If (CLng(mvntResultType) >= RESULTTYPE_NUMERIC) And (CLng(mvntResultType) <= RESULTTYPE_DATE) Then
                
                cboResultType.Clear
                Erase mstrArrResultType
                ReDim Preserve mstrArrResultType(0)
                Select Case mvntResultType
                    Case RESULTTYPE_NUMERIC         '数値
                        cboResultType.AddItem "0:数値を格納します"
                        mstrArrResultType(0) = RESULTTYPE_NUMERIC
                    Case RESULTTYPE_TEISEI1         '定性１
                        cboResultType.AddItem "1:定性（標準：-,+-,+）を格納します"
                        mstrArrResultType(0) = RESULTTYPE_TEISEI1
                    Case RESULTTYPE_TEISEI2         '定性２
                        cboResultType.AddItem "2:定性（拡張：-,+-,1+～9+）を格納します"
                        mstrArrResultType(0) = RESULTTYPE_TEISEI2
                    Case RESULTTYPE_FREE            'フリー
                        cboResultType.AddItem "3:結果内容を固定しません（フリー）"
                        mstrArrResultType(0) = RESULTTYPE_FREE
                    Case RESULTTYPE_SENTENCE        '文章
                        cboResultType.AddItem "4:文章結果を格納します"
                        mstrArrResultType(0) = RESULTTYPE_SENTENCE
                    Case RESULTTYPE_CALC            '計算
                        cboResultType.AddItem "5:計算項目です"
                        mstrArrResultType(0) = RESULTTYPE_CALC
                    Case RESULTTYPE_DATE            '日付タイプ
                        cboResultType.AddItem "6:日付を格納します"
                        mstrArrResultType(0) = RESULTTYPE_DATE
                End Select
                
                cboResultType.ListIndex = 0
                
            End If
        End If
    End If
    
    '結果タイプコンボの使用可否
    If mintMode = MODE_REQUEST Then
        cboResultType.Enabled = False
    Else
        cboResultType.Enabled = (optDiv(1).Value = True)
    End If

End Sub
Friend Property Let Mode(ByVal vNewValue As Integer)

    mintMode = vNewValue
    
End Property
Friend Property Let Group(ByVal vNewValue As Integer)

    mintGroup = vNewValue
    
End Property

Friend Property Let Item(ByVal vNewValue As Integer)

    mintItem = vNewValue
    
End Property

Friend Property Let Question(ByVal vNewValue As Integer)

    mintQuestion = vNewValue
    
End Property



' @(e)
'
' 機能　　 : 検査分類コンボ編集
'
' 機能説明 : 検査分類テーブルに設定されている内容を、検査分類コンボに設定
'
' 備考　　 :
'
Private Function EditItemClassCombo()
    
    Dim objItemClass    As Object           '検査項目分類アクセス用
    Dim vntClassCd      As Variant          '検査分類名称
    Dim vntClassName    As Variant          '検査分類名称
    Dim lngCount        As Long             'レコード数
    Dim i               As Long             'インデックス
    
    EditItemClassCombo = False
    cboItemClass.Clear
    Erase mstrArrClassCd
    
    'オブジェクトのインスタンス作成
    Set objItemClass = CreateObject("HainsItem.Item")
    lngCount = objItemClass.SelectItemClassList(vntClassCd, vntClassName)
    
    '全てはデフォルトとして追加
    cboItemClass.AddItem "全て"
    cboItemClass.ListIndex = 0
    ReDim Preserve mstrArrClassCd(0)
    mstrArrClassCd(0) = ""
    
    'コンボリストの編集
    For i = 0 To lngCount - 1
        cboItemClass.AddItem vntClassName(i)
        ReDim Preserve mstrArrClassCd(i + 1)
        mstrArrClassCd(i + 1) = CStr(vntClassCd(i))
    
        '検査分類コードを指定されている場合、その分類をデフォルトとする
        If (mstrClassCd <> "") And (CStr(vntClassCd(i)) = mstrClassCd) Then
            cboItemClass.ListIndex = i + 1
        End If
        
    Next i
    
    EditItemClassCombo = True
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    EditItemClassCombo = False

End Function

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, x As Single, Y As Single)
    
    Dim strMsg  As String

    'Shiftを押しながらFormをクリックすると、現在の設定を表示（デバッグ用）
    If Shift Then
    
        strMsg = "現在の表示モード" & vbLf & vbLf
        strMsg = strMsg & "表示モード：" & IIf(mintMode = MODE_REQUEST, "依頼項目を表示します", "検査項目を表示します") & vbLf
        strMsg = strMsg & "グループ：" & IIf(mintGroup = GROUP_OFF, "表示しません", "表示します") & vbLf
        strMsg = strMsg & "検査項目：" & IIf(mintItem = ITEM_OFF, "表示しません", "表示します") & vbLf
        strMsg = strMsg & "問診項目：" & IIf(mintQuestion = QUESTION_OFF, "表示しません", "表示します") & vbLf
        
        MsgBox strMsg, vbInformation
    
    End If

End Sub

Private Sub Form_Resize()
    
    If Me.WindowState <> vbMinimized Then
        Call SizeControls
    End If

End Sub

'
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
    If Me.Width > 4546 Then
        lsvItem.Width = Me.Width - 320
        cmdOk.Left = Me.Width - 3015
        cmdCancel.Left = cmdOk.Left + 1440
    End If
    
    '高さ変更
    If Me.Height > 3000 Then
        lsvItem.Height = Me.Height - 2750
        cmdOk.Top = Me.Height - 795
        cmdCancel.Top = cmdOk.Top
    End If

End Sub

Private Sub lsvItem_DblClick()

    Call CMDok_Click
    
End Sub


' @(e)
'
' 機能　　 : 「ステータスバー」Click
'
' 機能説明 : 現在の表示モードを表示する
'
' 備考　　 :
'
Private Sub stbMain_PanelClick(ByVal Panel As MSComctlLib.Panel)
    
End Sub

Public Property Get ItemName() As Variant

    ItemName = mvntItemName

End Property
Public Property Get ItemCount() As Variant

    ItemCount = mintItemCount

End Property

Public Property Get ItemCd() As Variant

    ItemCd = mvntItemCd
    
End Property

Public Property Get ClassName() As Variant

    ClassName = mvntClassName
    
End Property


Public Property Get Suffix() As Variant

    Suffix = mvntSuffix
    
End Property


Public Property Get ItemDiv() As Variant

    ItemDiv = mstrItemDiv
    
End Property

Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)

    Dim i As Long

    'CTRL+Aを押下された場合、項目を全て選択する
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem.ListItems.Count
            lsvItem.ListItems(i).Selected = True
        Next i
    End If
    
End Sub



Friend Property Let MultiSelect(ByVal vNewValue As Boolean)

    mblnMultiSelect = vNewValue

End Property

Friend Property Let ResultType(ByVal vNewValue As Variant)

'    mintResultType = vNewValue
    mvntResultType = vNewValue
    
End Property

Private Sub optDiv_Click(Index As Integer)

    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '結果タイプコンボの使用可否
    If mintMode = MODE_REQUEST Then
        cboResultType.Enabled = False
    Else
        cboResultType.Enabled = (Index = 1)
    End If

    '項目リスト編集
    Call EditItemList

End Sub

Friend Property Let ClassCd(ByVal vNewValue As String)

    mstrClassCd = vNewValue
    
End Property
