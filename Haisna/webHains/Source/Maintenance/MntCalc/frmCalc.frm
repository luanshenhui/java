VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmCalc 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "計算テーブルメンテナンス"
   ClientHeight    =   7680
   ClientLeft      =   2295
   ClientTop       =   675
   ClientWidth     =   8550
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmCalc.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7680
   ScaleWidth      =   8550
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.Frame Frame1 
      Caption         =   "計算方法"
      Height          =   4335
      Left            =   120
      TabIndex        =   26
      Top             =   2760
      Width           =   8295
      Begin TabDlg.SSTab TabMain 
         Height          =   3795
         Left            =   240
         TabIndex        =   27
         Top             =   360
         Width           =   7815
         _ExtentX        =   13785
         _ExtentY        =   6694
         _Version        =   393216
         Style           =   1
         Tabs            =   2
         TabHeight       =   520
         TabCaption(0)   =   "男性"
         TabPicture(0)   =   "frmCalc.frx":000C
         Tab(0).ControlEnabled=   -1  'True
         Tab(0).Control(0)=   "lsvItem(0)"
         Tab(0).Control(0).Enabled=   0   'False
         Tab(0).Control(1)=   "cmdEditItem(0)"
         Tab(0).Control(1).Enabled=   0   'False
         Tab(0).Control(2)=   "cmdAddItem(0)"
         Tab(0).Control(2).Enabled=   0   'False
         Tab(0).Control(3)=   "cmdDeleteItem(0)"
         Tab(0).Control(3).Enabled=   0   'False
         Tab(0).Control(4)=   "cmdItemCopy(0)"
         Tab(0).Control(4).Enabled=   0   'False
         Tab(0).ControlCount=   5
         TabCaption(1)   =   "女性"
         TabPicture(1)   =   "frmCalc.frx":0028
         Tab(1).ControlEnabled=   0   'False
         Tab(1).Control(0)=   "cmdItemCopy(1)"
         Tab(1).Control(1)=   "cmdEditItem(1)"
         Tab(1).Control(2)=   "cmdAddItem(1)"
         Tab(1).Control(3)=   "cmdDeleteItem(1)"
         Tab(1).Control(4)=   "lsvItem(1)"
         Tab(1).ControlCount=   5
         Begin VB.CommandButton cmdItemCopy 
            Caption         =   "女性データからコピー(&C)..."
            Height          =   315
            Index           =   0
            Left            =   240
            TabIndex        =   6
            Top             =   3240
            Width           =   2055
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "削除(&R)"
            Height          =   315
            Index           =   0
            Left            =   6300
            TabIndex        =   9
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "追加(&W)..."
            Height          =   315
            Index           =   0
            Left            =   3540
            TabIndex        =   7
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditItem 
            Caption         =   "編集(&E)..."
            Height          =   315
            Index           =   0
            Left            =   4920
            TabIndex        =   8
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdItemCopy 
            Caption         =   "男性データからコピー(&C)..."
            Height          =   315
            Index           =   1
            Left            =   -74760
            TabIndex        =   11
            Top             =   3240
            Width           =   2055
         End
         Begin VB.CommandButton cmdEditItem 
            Caption         =   "編集(&E)..."
            Height          =   315
            Index           =   1
            Left            =   -70080
            TabIndex        =   13
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "追加(&W)..."
            Height          =   315
            Index           =   1
            Left            =   -71460
            TabIndex        =   12
            Top             =   3240
            Width           =   1275
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "削除(&R)"
            Height          =   315
            Index           =   1
            Left            =   -68700
            TabIndex        =   14
            Top             =   3240
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   2655
            Index           =   0
            Left            =   180
            TabIndex        =   5
            Top             =   480
            Width           =   7455
            _ExtentX        =   13150
            _ExtentY        =   4683
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
         Begin MSComctlLib.ListView lsvItem 
            Height          =   2655
            Index           =   1
            Left            =   -74820
            TabIndex        =   10
            Top             =   480
            Width           =   7455
            _ExtentX        =   13150
            _ExtentY        =   4683
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
   Begin VB.Frame Frame3 
      Caption         =   "履歴管理情報"
      Height          =   1815
      Left            =   120
      TabIndex        =   18
      Top             =   840
      Width           =   8295
      Begin VB.ComboBox cboHistory 
         BeginProperty Font 
            Name            =   "ＭＳ Ｐゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         ItemData        =   "frmCalc.frx":0044
         Left            =   1440
         List            =   "frmCalc.frx":0066
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   1
         Top             =   300
         Width           =   6570
      End
      Begin VB.CommandButton cmdNewHistory 
         Caption         =   "新規(&N)..."
         Height          =   315
         Left            =   3960
         TabIndex        =   2
         Top             =   660
         Width           =   1275
      End
      Begin VB.CommandButton cmdEditHistory 
         Caption         =   "編集(&H)..."
         Height          =   315
         Left            =   5340
         TabIndex        =   3
         Top             =   660
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteHistory 
         Caption         =   "削除(&D)..."
         Enabled         =   0   'False
         Height          =   315
         Left            =   6720
         TabIndex        =   4
         Top             =   660
         Width           =   1275
      End
      Begin VB.Label lblExplanation 
         Caption         =   "体重×体重×体重"
         Height          =   195
         Left            =   1980
         TabIndex        =   25
         Top             =   1440
         Width           =   6015
      End
      Begin VB.Label lblTiming 
         Caption         =   "計算要素のうち、一つでも値が入った場合"
         Height          =   195
         Left            =   4500
         TabIndex        =   24
         Top             =   1140
         Width           =   3495
      End
      Begin VB.Label lblFraction 
         Caption         =   "四捨五入"
         Height          =   195
         Left            =   2340
         TabIndex        =   23
         Top             =   1140
         Width           =   915
      End
      Begin VB.Label Label1 
         Caption         =   "説明："
         Height          =   255
         Index           =   2
         Left            =   1440
         TabIndex        =   21
         Top             =   1440
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "計算タイミング："
         Height          =   255
         Index           =   1
         Left            =   3360
         TabIndex        =   20
         Top             =   1140
         Width           =   1155
      End
      Begin VB.Label Label1 
         Caption         =   "端数処理："
         Height          =   255
         Index           =   0
         Left            =   1440
         TabIndex        =   19
         Top             =   1140
         Width           =   975
      End
      Begin VB.Label Label8 
         Caption         =   "履歴情報(&J):"
         Height          =   195
         Index           =   0
         Left            =   300
         TabIndex        =   0
         Top             =   360
         Width           =   1095
      End
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(&A)"
      Height          =   315
      Left            =   7140
      TabIndex        =   17
      Top             =   7260
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   4260
      TabIndex        =   15
      Top             =   7260
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5700
      TabIndex        =   16
      Top             =   7260
      Width           =   1335
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   7620
      Top             =   180
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
            Picture         =   "frmCalc.frx":0088
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCalc.frx":04DA
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCalc.frx":092C
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCalc.frx":0A86
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
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
      Left            =   840
      TabIndex        =   22
      Top             =   240
      Width           =   6375
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   4
      Left            =   180
      Picture         =   "frmCalc.frx":0BE0
      Top             =   120
      Width           =   480
   End
End
Attribute VB_Name = "frmCalc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrItemCd              As String           '検査項目コード
Private mstrSuffix              As String           'サフィックス

Private mintBeforeIndex         As Integer          '履歴コンボ変更キャンセル用の前Index
Private mblnNowEdit             As Boolean          'TRUE:編集処理中、FALSE:処理なし

Private mblnInitialize          As Boolean          'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean          'TRUE:更新あり、FALSE:更新なし
Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション

Private mintUniqueKey           As Long             'リストビュー一意キー管理用番号
Private Const KEY_PREFIX        As String = "K"

Private mblnHistoryUpdated      As Boolean          'TRUE:計算履歴更新あり、FALSE:計算履歴更新なし
Private mblnItemUpdated         As Boolean          'TRUE:計算詳細更新あり、FALSE:計算詳細更新なし
Private mblnNewRecordFlg        As Boolean          'TRUE:新規作成、FALSE:更新モード

Private mstrArrCalcHNo()        As String           '計算管理コード（コンボボックス対応用）
Private mcolCalcRecord          As Collection       '計算レコードのコレクション
Private mcolCalc_cRecord        As Collection       '計算詳細レコードのコレクション（読み込み直後のみ使用）

Friend Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
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
        
        '計算明細がどちらも未入力ならエラー
        If (lsvItem(0).ListItems.Count = 0) And (lsvItem(1).ListItems.Count = 0) Then
            MsgBox "計算方法が入力されていません。", vbExclamation, App.Title
            TabMain.Tab = 0
            lsvItem(0).SetFocus
            Exit Do
        End If
        
        '変数の整合性チェック
        If CheckVariable() = False Then Exit Do
        
        '計算明細（男なし、女あり）の場合
        If (lsvItem(0).ListItems.Count = 0) And (lsvItem(1).ListItems.Count > 0) Then
            strMsg = "男性の計算が設定されていません。女性の計算をコピーして格納しますか？"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbYes Then
                Call CopyItem(0, True)
            End If
        End If

        '計算明細（女なし、男あり）の場合
        If (lsvItem(1).ListItems.Count = 0) And (lsvItem(0).ListItems.Count > 0) Then
            strMsg = "女性の計算が設定されていません。男性の計算をコピーして格納しますか？"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbYes Then
                Call CopyItem(1, True)
            End If
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function
Private Function CheckVariable() As Boolean

    Dim objCalc_C_Record    As Calc_C_Record
    Dim intListViewIndex    As Integer
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    Dim Ret                 As Boolean

    CheckVariable = False
    
    Ret = True
    
    '男女リストビューの中身をセット
    For intListViewIndex = 0 To 1
    
        Set obTargetListView = lsvItem(intListViewIndex)
    
        'マルチセレクト状態を一時的に解除し、全項目を未選択状態にする
        obTargetListView.MultiSelect = False
        
        '完全身選択状態もありうるので、On Error Resume Next
        On Error Resume Next
        obTargetListView.SelectedItem.Selected = False
        On Error GoTo 0
    
        '全行チェック
        For i = 1 To obTargetListView.ListItems.Count
    
            'リストビューと対応するコレクションをゲット
            Set objCalc_C_Record = mcolCalc_cRecord(obTargetListView.ListItems(i).Key)
            
            With objCalc_C_Record
                
                If IsNumeric(.Variable1) Then
                    If CInt(.Variable1) >= i Then
                        MsgBox "計算結果を取得するには、処理行よりも前に計算されている必要があります。正しい行数を設定してください。", vbExclamation
                        TabMain.Tab = intListViewIndex
                        obTargetListView.ListItems(i).Selected = True
                        Ret = False
                        Exit For
                    End If
                End If
                
                If IsNumeric(.Variable2) Then
                    If CInt(.Variable2) >= i Then
                        MsgBox "計算結果を取得するには、処理行よりも前に計算されている必要があります。正しい行数を設定してください。", vbExclamation
                        TabMain.Tab = intListViewIndex
                        obTargetListView.ListItems(i).Selected = True
                        Ret = False
                        Exit For
                    End If
                End If
                
            End With
    
        Next i
    
        If Ret = False Then Exit For
        
    Next intListViewIndex
    
    'マルチセレクトに再設定
    obTargetListView.MultiSelect = True
    
    'エラーが存在するなら処理終了
    If Ret = False Then Exit Function
    
    CheckVariable = True
    
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
Private Function EditCalc(strItemCd As String, _
                          strSuffix As String, _
                          blnCopy As Boolean) As Boolean

    Dim objCalc             As Object           '計算管理アクセス用
    
    Dim vntItemCd           As Variant
    Dim vntSuffix           As Variant
    Dim vntItemName         As Variant
    Dim vntCalcHNo          As Variant
    Dim vntStrDate          As Variant
    Dim vntEndDate          As Variant
    Dim vntFraction         As Variant
    Dim vntTiming           As Variant
    Dim vntExplanation      As Variant
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Integer
    Dim Ret                 As Boolean          '戻り値
    Dim objCalc_Record      As Calc_Record      '計算レコードオブジェクト
    
    On Error GoTo ErrorHandle
    
    'COPYモードでないなら、コレクション等メモリ領域初期化
    If blnCopy = False Then
        Set mcolCalcRecord = Nothing
        Set mcolCalcRecord = New Collection
        Erase mstrArrCalcHNo
        cboHistory.Clear
    End If
    
    Do
        '検査項目コード。サフィックス何れかが指定されていない場合は何もしない
        If (strItemCd = "") Or (strSuffix = "") Then
            Ret = True
            Exit Do
        End If
    
        'オブジェクトのインスタンス作成
        Set objCalc = CreateObject("HainsCalc.Calc")
        
        '計算管理テーブルレコード読み込み
        lngCount = objCalc.SelectCalcList(False, _
                                          strItemCd, _
                                          strSuffix, _
                                          vntItemCd, _
                                          vntSuffix, _
                                          vntItemName, _
                                          vntCalcHNo, _
                                          vntStrDate, _
                                          vntEndDate, _
                                          vntFraction, _
                                          vntTiming, _
                                          vntExplanation)
        
        If lngCount = 0 Then
            
            'COPYモードでないなら、新規作成
            If blnCopy = False Then
                '計算管理テーブルが存在しない場合（新規作成モード）
                Call AddNewCalc
            End If
            
        Else
            
            '計算管理テーブルが存在する場合（更新モード）
        
            '読み込み内容の編集
            For i = 0 To lngCount - 1
                
                Set objCalc_Record = Nothing
                Set objCalc_Record = New Calc_Record
                
                'オブジェクト作成
                With objCalc_Record
                    .ItemCd = vntItemCd(i)
                    .Suffix = vntSuffix(i)
                    .CalcHNo = vntCalcHNo(i)
                    .StrDate = vntStrDate(i)
                    .EndDate = vntEndDate(i)
                    .Fraction = vntFraction(i)
                    .Timing = vntTiming(i)
                    .Explanation = vntExplanation(i)
                End With
                
                'COPYモードでないなら、自データとして格納
                If blnCopy = False Then
                    
                    '配列作成
                    cboHistory.AddItem CStr(vntStrDate(i)) & "～" & CStr(vntEndDate(i)) & "に適用するデータ"
                    
                    'コンボボックス対応配列の作成
                    ReDim Preserve mstrArrCalcHNo(i)
                    mstrArrCalcHNo(i) = KEY_PREFIX & objCalc_Record.CalcHNo
                    
                    'コレクション追加
                    mcolCalcRecord.Add objCalc_Record, KEY_PREFIX & objCalc_Record.CalcHNo
                
                End If
                
            Next i
        
        End If
    
        Ret = True
        Exit Do
    Loop
    
    'COPYモードでないなら、コンボの使用可否の設定
    If blnCopy = False Then
        
        '履歴コンボが１個しかないなら削除ボタンは使用不可
        If cboHistory.ListCount <= 1 Then
            cmdDeleteHistory.Enabled = False
        Else
            cmdDeleteHistory.Enabled = True
        End If
    
    End If
    
    '戻り値の設定
    Set objCalc = Nothing
    EditCalc = Ret
    
    Exit Function

ErrorHandle:

    EditCalc = False
    MsgBox Err.Description, vbCritical
    Set objCalc = Nothing
    
End Function

'
' 機能　　 : 計算詳細情報の取得
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function GetCalc_c(strCalcHNo As String, blnCopy As Boolean) As Boolean

    Dim objCalc             As Object       '計算管理アクセス用
    
    Dim vntGender           As Variant      '性別
    Dim vntSeq              As Variant      '計算順
    Dim vntVariable1        As Variant      '変数１
    Dim vntCalcItemCd1      As Variant      '計算項目コード１
    Dim vntCalcSuffix1      As Variant      '計算サフィックス１
    Dim vntCalcItemName1    As Variant      '計算項目名１
    Dim vntConstant1        As Variant      '定数１
    Dim vntOperator         As Variant      '演算記号
    Dim vntVariable2        As Variant      '変数２
    Dim vntCalcItemCd2      As Variant      '計算項目コード２
    Dim vntCalcSuffix2      As Variant      '計算サフィックス２
    Dim vntCalcItemName2    As Variant      '計算項目名２
    Dim vntConstant2        As Variant      '定数２
    Dim vntCalcResult       As Variant      '計算結果
    
    Dim lngCount            As Long         'レコード数
    Dim i                   As Integer
    Dim Ret                 As Boolean      '戻り値
    
    Dim objCalc_C_Record    As Calc_C_Record    '計算詳細レコードオブジェクト
    
    On Error GoTo ErrorHandle
    
    If blnCopy = True Then
    
    Else
        '現在表示している値のクリア
        Set mcolCalc_cRecord = Nothing
        Set mcolCalc_cRecord = New Collection
    End If

    Do
'        '計算管理コードが指定されていない場合は何もしない
'        If (strCalcHNo = "") Or (strCalcHNo = "0") Then
'            Ret = True
'            Exit Do
'        End If
        '計算管理コードが指定されていない場合は何もしない
        If strCalcHNo = "" Then
            Ret = True
            Exit Do
        End If
    
        'オブジェクトのインスタンス作成
        Set objCalc = CreateObject("HainsCalc.Calc")
        
        '計算管理テーブルレコード読み込み
        lngCount = objCalc.SelectCalc_cList(mstrItemCd, _
                                            mstrSuffix, _
                                            CInt(strCalcHNo), _
                                            vntGender, _
                                            vntSeq, _
                                            vntVariable1, _
                                            vntCalcItemCd1, _
                                            vntCalcSuffix1, _
                                            vntCalcItemName1, _
                                            vntConstant1, _
                                            vntOperator, _
                                            vntVariable2, _
                                            vntCalcItemCd2, _
                                            vntCalcSuffix2, _
                                            vntCalcItemName2, _
                                            vntConstant2, _
                                            vntCalcResult)

        '0件でも不思議なし
        If lngCount = 0 Then
            
            If blnCopy = True Then
                Ret = False
            Else
                Ret = True
            End If
            
            Exit Do
        End If

        '読み込み内容の編集
        For i = 0 To lngCount - 1
            '読み込み内容をオブジェクトにセット
            Set objCalc_C_Record = New Calc_C_Record
            With objCalc_C_Record
'                .CalcHNo = strCalcHNo
                .Gender = vntGender(i)
                .Variable1 = vntVariable1(i)
                .CalcItemCd1 = vntCalcItemCd1(i)
                .CalcSuffix1 = vntCalcSuffix1(i)
                .CalcItemName1 = vntCalcItemName1(i)
                .Constant1 = vntConstant1(i)
                .Operator = vntOperator(i)
                .Variable2 = vntVariable2(i)
                .CalcItemCd2 = vntCalcItemCd2(i)
                .CalcSuffix2 = vntCalcSuffix2(i)
                .CalcItemName2 = vntCalcItemName2(i)
                .Constant2 = vntConstant2(i)
                .CalcResult = vntCalcResult(i)
                .Key = KEY_PREFIX & mintUniqueKey
            End With
            
            If blnCopy = True Then
            
            Else
                'コレクションに追加
                mcolCalc_cRecord.Add objCalc_C_Record, KEY_PREFIX & mintUniqueKey
                mintUniqueKey = mintUniqueKey + 1
            End If
            
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    Set objCalc = Nothing
    
    '戻り値の設定
    GetCalc_c = Ret
    
    Exit Function

ErrorHandle:

    GetCalc_c = False
    MsgBox Err.Description, vbCritical
    Set objCalc = Nothing
    
End Function

'
' 機能　　 : 計算詳細情報の表示（コレクションから）
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditListViewFromCollection() As Boolean

On Error GoTo ErrorHandle

    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntFraction         As Variant          'コースコード
    Dim vntCsName           As Variant          'コース名
    Dim lngCount            As Long             'レコード数
    Dim i                   As Long             'インデックス
    Dim objCalc_C_Record    As Calc_C_Record    '計算詳細レコードオブジェクト
    
    EditListViewFromCollection = False

    'リストビュー用ヘッダ調整（男女分）
    For i = 0 To 1
        Call EditListViewHeader(CInt(i))
    Next i
    
    'リストの編集
    For Each objCalc_C_Record In mcolCalc_cRecord
        
        'リストビューセット
        Call SetCalcListForListView(objCalc_C_Record.Key, True)
    
    Next objCalc_C_Record
    
    'オブジェクト廃棄
    Set objCalc_C_Record = Nothing
    
    EditListViewFromCollection = True
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
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
    Dim Ret                 As Boolean              '戻り値
    
    GetItemInfo = False
    
    On Error GoTo ErrorHandle
    
    Ret = False
    Do
        
        '検索条件が指定されていない場合は何もしない
        If (mstrItemCd = "") Or (mstrSuffix = "") Then
            MsgBox "検査項目コードが指定されていません。", vbCritical, App.Title
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
                                    vntResultTypeName) = False Then
            
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        
        End If

        '結果タイプをチェック
        If CInt(vntResultType) <> RESULTTYPE_CALC Then
            MsgBox "指定された項目" & vntItemName & "は計算タイプの項目ではありません。", vbCritical, App.Title
            Exit Do
        End If
        
        '読み込み内容の編集
        lblItemInfo.Caption = mstrItemCd & "-" & mstrSuffix & "：「" & vntItemName & "」"
        lblItemInfo.Caption = lblItemInfo.Caption & "の計算方法を登録します。"
        
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

'
' 機能　　 : データ登録
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function RegistCalc() As Boolean

On Error GoTo ErrorHandle

    Dim objCalc                 As Object       '計算管理アクセス用
    Dim Ret                     As Long
    Dim objCurCalc_Record       As Calc_Record
    
    '新規登録時の退避用
    Dim strEscItemCd            As String
    Dim strEscSuffix            As String
    Dim strEscCalcHNo           As String
    Dim strEscStrDate           As String
    Dim strEscEndDate           As String
    Dim strEscFraction          As String
    Dim strEscTiming            As String
    Dim strEscExplanation       As String

    '計算履歴No
    Dim intCalcHNo              As Integer

    '計算詳細の配列関連
    Dim intItemCount            As Integer
    Dim vntGender               As Variant
    Dim vntSeq                  As Variant
    Dim vntVariable1            As Variant
    Dim vntCalcItemCd1          As Variant
    Dim vntCalcSuffix1          As Variant
    Dim vntConstant1            As Variant
    Dim vntOperator             As Variant
    Dim vntVariable2            As Variant
    Dim vntCalcItemCd2          As Variant
    Dim vntCalcSuffix2          As Variant
    Dim vntConstant2            As Variant
    Dim vntCalcResult           As Variant

    '現在のカレント情報をオブジェクトにセット
    Set objCurCalc_Record = mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex))
    
    
    '計算管理テーブルレコードの登録
    With objCurCalc_Record

        '新規挿入モードの場合､設定内容を退避
        If mblnNewRecordFlg = True Then
            strEscItemCd = .ItemCd
            strEscSuffix = .Suffix
            strEscCalcHNo = .CalcHNo
            strEscStrDate = .StrDate
            strEscEndDate = .EndDate
            strEscFraction = .Fraction
            strEscTiming = .Timing
            strEscExplanation = .Explanation
        End If
        
        '計算詳細テーブルの配列セット
        Call EditArrayForUpdate(intItemCount, _
                                vntGender, _
                                vntSeq, _
                                vntVariable1, _
                                vntCalcItemCd1, _
                                vntCalcSuffix1, _
                                vntConstant1, _
                                vntOperator, _
                                vntVariable2, _
                                vntCalcItemCd2, _
                                vntCalcSuffix2, _
                                vntConstant2, _
                                vntCalcResult)
    
        '計算履歴Noのセット
        intCalcHNo = .CalcHNo
    
        'オブジェクトのインスタンス作成
        Set objCalc = CreateObject("HainsCalc.Calc")
    
        '計算データの登録
        Ret = objCalc.RegistCalc_All(IIf(mblnNewRecordFlg = True, "INS", "UPD"), _
                                     mstrItemCd, _
                                     mstrSuffix, _
                                     intCalcHNo, _
                                     .StrDate, _
                                     .EndDate, _
                                     .Fraction, _
                                     .Timing, _
                                     .Explanation, _
                                     intItemCount, _
                                     vntGender, _
                                     vntSeq, _
                                     vntVariable1, _
                                     vntCalcItemCd1, _
                                     vntCalcSuffix1, _
                                     vntConstant1, _
                                     vntOperator, _
                                     vntVariable2, _
                                     vntCalcItemCd2, _
                                     vntCalcSuffix2, _
                                     vntConstant2, _
                                     vntCalcResult)
    
    End With
    
    If Ret <> INSERT_NORMAL Then
        
        Select Case Ret
            
            Case INSERT_DUPLICATE
                MsgBox "入力された計算管理コードは既に存在します。", vbExclamation
            
            Case INSERT_HISTORYDUPLICATE
                MsgBox "日付が重複している履歴が存在します。履歴設定を再入力してください。", vbExclamation
            
            Case Else
                MsgBox "テーブル更新時にエラーが発生しました。", vbCritical
    
        End Select
        RegistCalc = False
        Exit Function
    End If
    
    '新規挿入モードの場合、設定内容を退避
    If mblnNewRecordFlg = True Then

        '新しい計算履歴オブジェクトを作成
        Set objCurCalc_Record = Nothing
        Set objCurCalc_Record = New Calc_Record
        With objCurCalc_Record
            .ItemCd = strEscItemCd
            .Suffix = strEscSuffix
            .CalcHNo = intCalcHNo
            .StrDate = strEscStrDate
            .EndDate = strEscEndDate
            .Fraction = strEscFraction
            .Timing = strEscTiming
            .Explanation = strEscExplanation
        End With

        '旧の値をコレクションから削除して発番された計算履歴Noでコレクション追加
        mcolCalcRecord.Remove KEY_PREFIX & strEscCalcHNo
        mcolCalcRecord.Add objCurCalc_Record, KEY_PREFIX & intCalcHNo

        'コンボボックスの値も変更
        mstrArrCalcHNo(cboHistory.ListIndex) = KEY_PREFIX & intCalcHNo

    End If

    'もう新規ではないのでボタン使用可能
    cmdNewHistory.Enabled = True
    mblnNewRecordFlg = False
    
    '更新済みフラグを初期化
    mblnHistoryUpdated = False
    mblnItemUpdated = False
    
    Set objCalc = Nothing
    RegistCalc = True
    
    Exit Function
    
ErrorHandle:

    RegistCalc = False
    MsgBox Err.Description, vbCritical
    Set objCalc = Nothing
    
End Function

' @(e)
'
' 機能　　 : 更新用配列作成
'
' 引数　　 : たくさん
'
' 戻り値　 : なし
'
' 機能説明 : データ更新用のVariant配列をリストビュー及びコレクションから作成
'
' 備考　　 :
'
Private Sub EditArrayForUpdate(intItemCount As Integer, _
                                vntGender As Variant, _
                                vntSeq As Variant, _
                                vntVariable1 As Variant, _
                                vntCalcItemCd1 As Variant, _
                                vntCalcSuffix1 As Variant, _
                                vntConstant1 As Variant, _
                                vntOperator As Variant, _
                                vntVariable2 As Variant, _
                                vntCalcItemCd2 As Variant, _
                                vntCalcSuffix2 As Variant, _
                                vntConstant2 As Variant, _
                                vntCalcResult As Variant)

    Dim vntArrGender()          As Variant
    Dim vntArrSeq()             As Variant
    Dim vntArrVariable1()       As Variant
    Dim vntArrCalcItemCd1()     As Variant
    Dim vntArrCalcSuffix1()     As Variant
    Dim vntArrConstant1()       As Variant
    Dim vntArrOperator()        As Variant
    Dim vntArrVariable2()       As Variant
    Dim vntArrCalcItemCd2()     As Variant
    Dim vntArrCalcSuffix2()     As Variant
    Dim vntArrConstant2()       As Variant
    Dim vntArrCalcResult()      As Variant
    
    Dim i                       As Integer
    Dim intArrCount             As Integer
    Dim intListViewIndex        As Integer
    Dim obTargetListView        As ListView
    Dim objCalc_C_Record        As Calc_C_Record

    intArrCount = 0

    '男女リストビューの中身をセット
    For intListViewIndex = 0 To 1
    
        Set obTargetListView = lsvItem(intListViewIndex)
    
        'リストビューをくるくる回して選択項目配列作成
        For i = 1 To obTargetListView.ListItems.Count
    
            ReDim Preserve vntArrGender(intArrCount)
            ReDim Preserve vntArrSeq(intArrCount)
            ReDim Preserve vntArrVariable1(intArrCount)
            ReDim Preserve vntArrCalcItemCd1(intArrCount)
            ReDim Preserve vntArrCalcSuffix1(intArrCount)
            ReDim Preserve vntArrConstant1(intArrCount)
            ReDim Preserve vntArrOperator(intArrCount)
            ReDim Preserve vntArrVariable2(intArrCount)
            ReDim Preserve vntArrCalcItemCd2(intArrCount)
            ReDim Preserve vntArrCalcSuffix2(intArrCount)
            ReDim Preserve vntArrConstant2(intArrCount)
            ReDim Preserve vntArrCalcResult(intArrCount)
    
            'リストビューと対応するコレクションをゲット
            Set objCalc_C_Record = mcolCalc_cRecord(obTargetListView.ListItems(i).Key)
            
            With objCalc_C_Record
                
                vntArrGender(intArrCount) = .Gender
                vntArrSeq(intArrCount) = i
                vntArrVariable1(intArrCount) = .Variable1
                vntArrCalcItemCd1(intArrCount) = .CalcItemCd1
                vntArrCalcSuffix1(intArrCount) = .CalcSuffix1
                vntArrConstant1(intArrCount) = .Constant1
                vntArrOperator(intArrCount) = .Operator
                vntArrVariable2(intArrCount) = .Variable2
                vntArrCalcItemCd2(intArrCount) = .CalcItemCd2
                vntArrCalcSuffix2(intArrCount) = .CalcSuffix2
                vntArrConstant2(intArrCount) = .Constant2
                
                '計算最終行はNullセット
                If i = obTargetListView.ListItems.Count Then
                    vntArrCalcResult(intArrCount) = ""
                Else
                    vntArrCalcResult(intArrCount) = i
                End If
                
            End With
            
            intArrCount = intArrCount + 1
    
        Next i
    
    Next intListViewIndex

    vntGender = vntArrGender
    vntSeq = vntArrSeq
    vntVariable1 = vntArrVariable1
    vntCalcItemCd1 = vntArrCalcItemCd1
    vntCalcSuffix1 = vntArrCalcSuffix1
    vntConstant1 = vntArrConstant1
    vntOperator = vntArrOperator
    vntVariable2 = vntArrVariable2
    vntCalcItemCd2 = vntArrCalcItemCd2
    vntCalcSuffix2 = vntArrCalcSuffix2
    vntConstant2 = vntArrConstant2
    vntCalcResult = vntArrCalcResult

    intItemCount = intArrCount

End Sub

' @(e)
'
' 機能　　 : 履歴コンボクリック
'
' 引数　　 : なし
'
' 戻り値　 : なし
'
' 機能説明 : コンボクリックによるデータ変更状態の抑制
'
' 備考　　 :
'
Private Sub cboHistory_Click()

    Dim strMsg      As String
    Dim intRet      As Integer
        
    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '履歴コンボが一つしかない場合は、処理終了
    If cboHistory.ListCount = 1 Then Exit Sub

    Do
        
        '詳細項目が更新されている場合は、警告メッセージ
        If (mblnItemUpdated = True) Or (mblnHistoryUpdated = True) Then
            strMsg = "計算の設定内容が更新されています。履歴データを再表示すると変更内容が破棄されます" & vbLf & _
                     "よろしいですか？"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbNo Then
                mblnNowEdit = True                          '無限Loop防止のため、処理制御
                cboHistory.ListIndex = mintBeforeIndex      'コンボインデックスを元に戻す
                mblnNowEdit = False                         '処理中解除
                Exit Sub
            End If
        End If
        
        Screen.MousePointer = vbHourglass
        
        mblnNowEdit = True

        '新規状態の場合、メモリから削除
        If mblnNewRecordFlg = True Then
            Call RemoveNewCalc
        End If
        
        'ヘッダ情報の編集
        Call EditHeaderExplain
        
        '計算詳細情報の編集
        If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
            Exit Do
        End If
        
        '取得計算情報のリストビュー格納
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        '全て未更新状態に戻す
        mblnHistoryUpdated = False
        mblnItemUpdated = False
        
        Exit Do
    Loop
    
    '現在のIndexを保持
    mintBeforeIndex = cboHistory.ListIndex
    
    mblnNowEdit = False
    Screen.MousePointer = vbDefault

End Sub

' @(e)
'
' 機能　　 : 計算方法追加ボタンクリック
'
' 引数　　 : (In)   Index    対象ボタン（性別毎）
'
' 戻り値　 : なし
'
' 機能説明 : 計算行の編集ダイアログを表示し、新規に追加する
'
' 備考　　 :
'
Private Sub cmdAddItem_Click(Index As Integer)

    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    
    Dim strStrAge           As String           '開始年齢
    Dim strEndAge           As String           '終了年齢
    Dim strLowerValue       As String           '計算（以上）
    Dim strUpperValue       As String           '計算（以下）
    Dim strStdFlg           As String           '計算フラグ
    Dim strJudCd            As String           '判定コード
    Dim strJudCmtCd         As String           '判定コメントコード
    Dim strHealthPoint      As String           'ヘルスポイント
    
    Dim objCalc_C_Record    As Calc_C_Record
    
    'クリックされたインデックスで性別を選択
    Set obTargetListView = lsvItem(Index)

    With frmEditCalcItem
        
        '現在設定されている計算行をセット
        .CalcLine = obTargetListView.ListItems.Count
        
        '現在の検査項目コードをセット（リカーシブル予防）
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        
        '計算行編集フォーム表示
        .Show vbModal
    
        If .Updated = True Then
            
            '更新されている場合は、オブジェクト作成
            Set objCalc_C_Record = New Calc_C_Record
            
'            objCalc_C_Record.ItemCd = mstrItemCd
'            objCalc_C_Record.Suffix = mstrSuffix
'            objCalc_C_Record.CalcHNo = mstrCalcHNo
            objCalc_C_Record.Gender = Index + 1
'            objCalc_C_Record.Seq = obTargetListView.ListItems.Count + 1
            objCalc_C_Record.Variable1 = .Variable1
            objCalc_C_Record.CalcItemCd1 = .CalcItemCd1
            objCalc_C_Record.CalcSuffix1 = .CalcSuffix1
            objCalc_C_Record.CalcItemName1 = .CalcItemName1
            objCalc_C_Record.Constant1 = .Constant1
            objCalc_C_Record.Operator = .Operator
            objCalc_C_Record.Variable2 = .Variable2
            objCalc_C_Record.CalcItemCd2 = .CalcItemCd2
            objCalc_C_Record.CalcSuffix2 = .CalcSuffix2
            objCalc_C_Record.CalcItemName2 = .CalcItemName2
            objCalc_C_Record.Constant2 = .Constant2
            
            mcolCalc_cRecord.Add objCalc_C_Record, KEY_PREFIX & mintUniqueKey
            Call SetCalcListForListView(KEY_PREFIX & mintUniqueKey, True)
            mintUniqueKey = mintUniqueKey + 1
            
            '計算詳細更新済み
            mblnItemUpdated = True
        
        End If
        
    End With
    
    'オブジェクトの廃棄
    Set frmEditCalcItem = Nothing
    
End Sub

' @(e)
'
' 機能　　 : リストビューへのデータセット
'
' 引数　　 : (In)   strTargetKey    コレクション内の表示対象キー
' 　　　　 : (In)   blnModeNew      TRUE:新規追加、FALSE:既表示行更新
'
' 戻り値　 : なし
'
' 機能説明 : 自コレクションのデータをリストビューに表示する
'
' 備考　　 :
'
Private Sub SetCalcListForListView(strTargetKey As String, blnModeNew As Boolean)

    Dim objItem             As ListItem             'リストアイテムオブジェクト
    Dim objCalc_C_Record    As Calc_C_Record
    Dim obTargetListView    As ListView
    Dim strLeftString       As String
    Dim strRightString      As String
    Dim strOperator         As String

    'コレクションから対象オブジェクトのセット
    Set objCalc_C_Record = mcolCalc_cRecord(strTargetKey)
    
    'セット先リストビューのセット
    Set obTargetListView = lsvItem(CInt(objCalc_C_Record.Gender) - 1)
    
    '左辺、右辺の表示文字列編集
    Call EditCalcString(objCalc_C_Record, strLeftString, strRightString)
    
    '演算子を２バイト文字に編集
    Select Case objCalc_C_Record.Operator
        Case "+"
            strOperator = "＋"
        Case "-"
            strOperator = "－"
        Case "*"
            strOperator = "×"
        Case "/"
            strOperator = "÷"
        Case "^"
            strOperator = "＾"
    End Select
        
    If blnModeNew = True Then
        '新規追加モードの場合
        Set objItem = obTargetListView.ListItems.Add(, strTargetKey, strLeftString, , "DEFAULTLIST")
        objItem.SubItems(1) = strOperator
        objItem.SubItems(2) = strRightString
    Else
        '更新モードの場合
        obTargetListView.ListItems(strTargetKey).Text = strLeftString
        obTargetListView.ListItems(strTargetKey).SubItems(1) = strOperator
        obTargetListView.ListItems(strTargetKey).SubItems(2) = strRightString
    End If

End Sub

' @(e)
'
' 機能　　 : 計算式の編集
'
' 引数　　 : (In)   objTargetList   計算方法レコードオブジェクト
' 　　　　 : (Out)  strLeftString   計算式（左辺）
' 　　　　 : (Out)  strRightString  計算式（右辺）
'
' 戻り値　 : 引数
'
' 機能説明 : 表示用に計算データを再編集する
'
' 備考　　 :
'
Private Sub EditCalcString(objTargetList As Calc_C_Record, _
                           strLeftString As String, _
                           strRightString As String)

    With objTargetList
        
        '左辺
        
        '変数がセットされている場合の処理
        If Trim(.Variable1) <> "" Then
            strLeftString = .Variable1 & "行目の結果"
        End If
        
        '検査項目コードがセットされている場合の処理
        If Trim(.CalcItemCd1) <> "" Then
            strLeftString = .CalcItemName1
        End If
    
        '変数、もしくは検査項目コードがセットされている場合の定数表示
        If (Trim(.Variable1) <> "") Or (Trim(.CalcItemCd1) <> "") Then
            
            If IsNumeric(Trim(.Constant1)) Then
                '定数が１ではない場合に、式を編集
                If CDbl(Trim(.Constant1)) <> 1 Then
                    strLeftString = "( " & strLeftString & "× " & .Constant1 & " )"
                End If
            End If
        Else
            '定数のみの場合は、そのままセット
            strLeftString = .Constant1
        End If
        
        '右辺
        
        '変数がセットされている場合の処理
        If Trim(.Variable2) <> "" Then
            strRightString = .Variable2 & "行目の結果"
        End If
        
        '検査項目コードがセットされている場合の処理
        If Trim(.CalcItemCd2) <> "" Then
            strRightString = .CalcItemName2
        End If
    
        '変数、もしくは検査項目コードがセットされている場合の定数表示
        If (Trim(.Variable2) <> "") Or (Trim(.CalcItemCd2) <> "") Then
            If IsNumeric(Trim(.Constant2)) Then
                '定数が１ではない場合に、式を編集
                If CDbl(Trim(.Constant2)) <> 1 Then
                    strRightString = "( " & strRightString & "× " & .Constant2 & " )"
                End If
            End If
        Else
            '定数のみの場合は、そのままセット
            strRightString = .Constant2
        End If
    
    End With
    
End Sub

' @(e)
'
' 機能　　 : 適用ボタンクリック
'
' 引数　　 : なし
'
' 戻り値　 : なし
'
' 機能説明 : 入力データを保存する
'
' 備考　　 :
'
Private Sub cmdApply_Click()

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then Exit Sub
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '保存処理
    Call ApplyData(False)
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Sub
Private Function ApplyData(blnOkMode As Boolean) As Boolean

    ApplyData = False
    
    '入力チェック
    If CheckValue() = False Then
        Exit Function
    End If
    
    '計算管理テーブルの登録
    If RegistCalc() = False Then
        Exit Function
    End If
    
    '更新済みフラグをTRUEに
    mblnUpdated = True
        
    'OKボタン押下時は余計な処理をしない
    If blnOkMode = True Then
        ApplyData = True
        Exit Function
    End If
    
    MsgBox "入力された内容を保存しました。", vbInformation

    '計算詳細情報の編集（画面再表示を行うことにより計算コードを再取得）
    If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
        Exit Function
    End If
    
    '取得計算情報のリストビュー格納
    If EditListViewFromCollection() = False Then
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

Private Sub cmdDeleteHistory_Click()

    Dim objCalc     As Object           '計算管理アクセス用
    Dim strMsg      As String
    Dim intRet      As Integer
        
    '処理中なら処理終了
    If Screen.MousePointer = vbHourglass Then Exit Sub
    Screen.MousePointer = vbHourglass

    Do
        
        strMsg = "指定された履歴データを削除します。" & vbLf & vbLf & _
                 "履歴データを削除するとその履歴で登録している計算方法も削除されます。" & vbLf & _
                 "この操作はキャンセルできません。よろしいですか？"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then Exit Do
        
        'データを削除する(COM+)
        Set objCalc = CreateObject("HainsCalc.Calc")
        objCalc.DeleteCalc mstrItemCd, mstrSuffix, mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo
        Set objCalc = Nothing   'CommitさせるためにNothing
        
        'もう１回最初から読み直し（面倒くさいんです。すいません）
        
        '計算履歴管理情報の編集
        If EditCalc(mstrItemCd, mstrSuffix, False) = False Then
            Exit Do
        End If

        cboHistory.ListIndex = 0

        'ヘッダ情報の編集
        Call EditHeaderExplain

        '計算詳細情報の編集
        If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
            Exit Do
        End If

        '取得計算情報のリストビュー格納
        If EditListViewFromCollection() = False Then
            Exit Do
        End If

        '全て未更新状態に戻す
        mblnHistoryUpdated = False
        mblnItemUpdated = False
        
        Exit Do
    Loop
    
    Set objCalc = Nothing
    Screen.MousePointer = vbDefault

End Sub

' @(e)
'
' 機能　　 : 式の削除
'
' 引数　　 : (In)   Index    処理対象Index
'
' 戻り値　 : なし
'
' 機能説明 : 選択された式をリストビューとコレクションから削除する
'
' 備考　　 :
'
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
            
            'オブジェクト削除
            mcolCalc_cRecord.Remove obTargetListView.ListItems(i).Key
            obTargetListView.ListItems.Remove (obTargetListView.ListItems(i).Key)
            
            'アイテム数が変わるので-1して再検査
            i = i - 1
            
            '計算詳細更新済み
            mblnItemUpdated = True
        
        End If
    
    Next i

End Sub

Private Sub cmdEditHistory_Click()

    Dim objCurCalc_Record As Calc_Record
    
    Set objCurCalc_Record = mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex))

    With frmEditCalcHistory
        
        'プロパティセット
        .StrDate = objCurCalc_Record.StrDate
        .EndDate = objCurCalc_Record.EndDate
        .Fraction = objCurCalc_Record.Fraction
        .Timing = objCurCalc_Record.Timing
        .Explanation = objCurCalc_Record.Explanation
        
        '画面表示
        .Show vbModal
    
        '更新されている場合、現在のオブジェクト状態を更新
        If .Updated = True Then
        
            'オブジェクト内容を更新
            objCurCalc_Record.StrDate = .StrDate
            objCurCalc_Record.EndDate = .EndDate
            objCurCalc_Record.Fraction = .Fraction
            objCurCalc_Record.Timing = .Timing
            objCurCalc_Record.Explanation = .Explanation
            
            cboHistory.List(cboHistory.ListIndex) = .StrDate & "～" & .EndDate & "に適用するデータ"
            
            '更新されたモード
            mblnHistoryUpdated = True
        
            'ヘッダ説明文を更新
            Call EditHeaderExplain
        End If
        
    End With

End Sub

Private Sub cmdEditItem_Click(Index As Integer)

    Dim i                       As Integer
    Dim objTargetListView       As ListView
    Dim objTargetListItem       As ListItem
    Dim objCalc_C_Record        As Calc_C_Record
    Dim strTargetKey            As String
    
    'クリックされたインデックスで性別を選択
    Set objTargetListView = lsvItem(Index)
    
    '指定座標にリストアイテムが存在しない場合は何もしない
    If objTargetListView.SelectedItem Is Nothing Then
        Exit Sub
    End If
    
    'リストビューに適合するデータをコレクションからゲット
    strTargetKey = objTargetListView.SelectedItem.Key
    Set objCalc_C_Record = mcolCalc_cRecord(strTargetKey)
    
    With frmEditCalcItem
        
        '現在の検査項目コードをセット（リカーシブル予防）
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        
        'ガイドに対するプロパティセット
        .Variable1 = objCalc_C_Record.Variable1
        .CalcItemCd1 = objCalc_C_Record.CalcItemCd1
        .CalcSuffix1 = objCalc_C_Record.CalcSuffix1
        .CalcItemName1 = objCalc_C_Record.CalcItemName1
        .Constant1 = objCalc_C_Record.Constant1
        .Operator = objCalc_C_Record.Operator
        .Variable2 = objCalc_C_Record.Variable2
        .CalcItemCd2 = objCalc_C_Record.CalcItemCd2
        .CalcSuffix2 = objCalc_C_Record.CalcSuffix2
        .CalcItemName2 = objCalc_C_Record.CalcItemName2
        .Constant2 = objCalc_C_Record.Constant2
        .CalcLine = objTargetListView.SelectedItem.Index - 1
        
        .Show vbModal
    
        If .Updated = True Then
            
            '更新されているなら内容を格納
            objCalc_C_Record.Variable1 = .Variable1
            objCalc_C_Record.CalcItemCd1 = .CalcItemCd1
            objCalc_C_Record.CalcSuffix1 = .CalcSuffix1
            objCalc_C_Record.CalcItemName1 = .CalcItemName1
            objCalc_C_Record.Constant1 = .Constant1
            objCalc_C_Record.Operator = .Operator
            objCalc_C_Record.Variable2 = .Variable2
            objCalc_C_Record.CalcItemCd2 = .CalcItemCd2
            objCalc_C_Record.CalcSuffix2 = .CalcSuffix2
            objCalc_C_Record.CalcItemName2 = .CalcItemName2
            objCalc_C_Record.Constant2 = .Constant2
        
            'リストビュー再表示
            Call SetCalcListForListView(strTargetKey, False)
        
            '計算詳細更新済み
            mblnItemUpdated = True
        
        End If
        
        'オブジェクトの廃棄
        Set frmEditCalcItem = Nothing
        
    End With

End Sub

Private Sub cmdItemCopy_Click(Index As Integer)
    
    Call CopyItem(Index, False)
    
End Sub

Private Sub cmdNewHistory_Click()

    Dim strMsg      As String
    Dim intRet      As Integer

    If Screen.MousePointer = vbHourglass Then Exit Sub
    Screen.MousePointer = vbHourglass

    Do
        
        '項目が更新されている場合は、警告メッセージ
        If (mblnItemUpdated = True) Or (mblnHistoryUpdated = True) Then
            strMsg = "データが更新されています。履歴データを再表示すると変更内容が破棄されます" & vbLf & _
                     "よろしいですか？"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbNo Then Exit Do
        End If
        
        '新規ダミーレコードの作成
        Call AddNewCalc
        
        '計算詳細情報の編集（新規なので本来不要だが先頭でメモリクリアしておしまい）
        If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
            Exit Do
        End If
        
        '取得計算情報のリストビュー格納（新規なので本来不要だが先頭でメモリクリアしておしまい）
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        '全て未更新状態に戻す
'        mblnHistoryUpdated = False
        mblnHistoryUpdated = True       '新規は更新だろ？
        mblnItemUpdated = False
        
        Exit Do
    Loop
    
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

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    'データ保存
    If ApplyData(True) = True Then
        '画面を閉じる
        Unload Me
    End If
    
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
    Dim i   As Integer
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    mblnItemUpdated = False
    mblnNewRecordFlg = False
    
    '画面初期化
    TabMain.Tab = 0                 '先頭タブをActive
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    Do
        '検査項目基本情報の取得
        If GetItemInfo() = False Then
            Exit Do
        End If
        
        '計算履歴管理情報の編集
        If EditCalc(mstrItemCd, mstrSuffix, False) = False Then
            Exit Do
        End If

        cboHistory.ListIndex = 0

        'ヘッダ情報の編集
        Call EditHeaderExplain

        '計算詳細情報の編集
        If GetCalc_c(mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex)).CalcHNo, False) = False Then
            Exit Do
        End If

        '取得計算情報のリストビュー格納
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop

    'アクセスキーのためにタブクリックを一度呼ぶ
    Call TabMain_Click(0)

    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub



Friend Property Let Suffix(ByVal vNewValue As Variant)

    mstrSuffix = vNewValue

End Property

Private Sub lsvItem_DblClick(Index As Integer)

    Call cmdEditItem_Click(Index)

End Sub

' @(e)
'
' 機能　　 : 計算履歴データの新規作成
'
' 引数　　 : なし
'
' 機能説明 : 新規作成時に計算履歴データをデフォルト作成する
'
' 備考　　 :
'
Private Sub AddNewCalc()
    
    Dim objCalc_Record      As Calc_Record  '計算レコードオブジェクト
    Dim intArrCount         As Integer
    
    '配列数の取得
    intArrCount = mcolCalcRecord.Count
    
    '配列を拡張（コレクションの数で作成すると必然的に+1になる）
    ReDim Preserve mstrArrCalcHNo(intArrCount)
    
    Set objCalc_Record = New Calc_Record
    With objCalc_Record
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        .CalcHNo = 100              '履歴番号は２桁なのでありえない番号で新規作成
        .StrDate = YEARRANGE_MIN & "/01/01"
        .EndDate = YEARRANGE_MAX & "/12/31"
        .Fraction = 0
        .Timing = 0
        cboHistory.AddItem .StrDate & "～" & .EndDate & "に適用するデータ"
        cboHistory.ListIndex = cboHistory.NewIndex
    End With
    
    '配列に退避
    mstrArrCalcHNo(intArrCount) = KEY_PREFIX & objCalc_Record.CalcHNo
    
    'コレクション追加
    mcolCalcRecord.Add objCalc_Record, KEY_PREFIX & objCalc_Record.CalcHNo

    '捏造したので更新されたモード
    mblnHistoryUpdated = True

    '新規作成モード
    mblnNewRecordFlg = True

    '今新規なのに新規ボタン不要だろ制御
    cmdNewHistory.Enabled = False
    
    'ヘッダ情報の編集
    Call EditHeaderExplain
    
End Sub

' @(e)
'
' 機能　　 : 新規計算履歴データのメモリ削除
'
' 引数　　 : なし
'
' 機能説明 : デフォルト作成した計算履歴データをメモリから削除する
'
' 備考　　 :
'
Private Sub RemoveNewCalc()
    
    Dim objCalc_Record      As Calc_Record  '計算レコードオブジェクト
    Dim intArrCount         As Integer
    Dim intListIndex        As Integer
    
    '配列数の取得
    intArrCount = mcolCalcRecord.Count
    
    '配列を縮小
    ReDim Preserve mstrArrCalcHNo(intArrCount - 2)
    
    'コレクションから削除
    mcolCalcRecord.Remove KEY_PREFIX & "100"

    'コンボから削除
    intListIndex = cboHistory.NewIndex
    cboHistory.RemoveItem intListIndex
    If (intListIndex - 1) < 0 Then
        cboHistory.ListIndex = 0
    Else
        cboHistory.ListIndex = (intListIndex - 1)
    End If

    mblnHistoryUpdated = False
    mblnNewRecordFlg = False
    cmdNewHistory.Enabled = True
    
    'ヘッダ情報の編集
    Call EditHeaderExplain
    
End Sub

Private Sub CopyItem(Index As Integer, Cancel As Boolean)

    Dim intOtherIndex       As Integer
    Dim strMsg              As String
    Dim intRet              As Integer
    
    Dim strCurrName         As String
    Dim strOtherName        As String
    
    Dim objItem             As ListItem
    Dim i                   As Integer
    Dim j                   As Integer
    Dim intEscFieldCount    As Integer      'リストビュー１行のサブアイテム数
    Dim strTargetKey        As String
    Dim objCalc_C_Record    As Calc_C_Record

    '自性別と逆のインデックスを求める
    intOtherIndex = 1 Xor Index
    
    If Index = 0 Then
        strCurrName = "男性計算設定欄"
        strOtherName = "女性計算設定欄"
    Else
        strCurrName = "女性計算設定欄"
        strOtherName = "男性計算設定欄"
    End If
    
    'コピー元のアイテム数確認
    If (lsvItem(intOtherIndex).ListItems.Count = 0) And (Cancel = False) Then
        MsgBox strOtherName & "に項目が何も設定されていません", vbInformation
        Exit Sub
    End If
    
    '自項目のアイテム確認
    If (lsvItem(Index).ListItems.Count > 0) And (Cancel = False) Then
    
        strMsg = strCurrName & "に項目が設定されています。既にある項目に追加しますか？" & vbLf & vbLf & _
                 "いいえを選択するとクリアしてから追加します。"
        intRet = MsgBox(strMsg, vbYesNoCancel + vbDefaultButton3 + vbExclamation)
        
        'キャンセル押下で処理終了
        If intRet = vbCancel Then Exit Sub
    
        'いいえなら１回クリア
        If intRet = vbNo Then
            lsvItem(Index).ListItems.Clear
        End If
    
    End If
    
    'とりゃ！項目コピー
    For i = 1 To lsvItem(intOtherIndex).ListItems.Count
        'キー値の取得
        strTargetKey = lsvItem(intOtherIndex).ListItems(i).Key
        
        Set objCalc_C_Record = New Calc_C_Record
        
        With objCalc_C_Record
'            .ItemCd = mcolCalc_cRecord(strTargetKey).ItemCd
'            .Suffix = mcolCalc_cRecord(strTargetKey).Suffix
            
            .Gender = Index + 1
            
'            .Seq = mcolCalc_cRecord(strTargetKey).Seq
            .Variable1 = mcolCalc_cRecord(strTargetKey).Variable1
            .CalcItemCd1 = mcolCalc_cRecord(strTargetKey).CalcItemCd1
            .CalcSuffix1 = mcolCalc_cRecord(strTargetKey).CalcSuffix1
            .CalcItemName1 = mcolCalc_cRecord(strTargetKey).CalcItemName1
            .Constant1 = mcolCalc_cRecord(strTargetKey).Constant1
            .Operator = mcolCalc_cRecord(strTargetKey).Operator
            .Variable2 = mcolCalc_cRecord(strTargetKey).Variable2
            .CalcItemCd2 = mcolCalc_cRecord(strTargetKey).CalcItemCd2
            .CalcSuffix2 = mcolCalc_cRecord(strTargetKey).CalcSuffix2
            .CalcItemName2 = mcolCalc_cRecord(strTargetKey).CalcItemName2
            .Constant2 = mcolCalc_cRecord(strTargetKey).Constant2
        End With
    
        mcolCalc_cRecord.Add objCalc_C_Record, KEY_PREFIX & mintUniqueKey
        Call SetCalcListForListView(KEY_PREFIX & mintUniqueKey, True)
        mintUniqueKey = mintUniqueKey + 1
    
    Next i

    '画面が乱れるので再描画
    lsvItem(Index).Refresh
    
End Sub

Private Sub lsvItem_KeyDown(Index As Integer, KeyCode As Integer, Shift As Integer)

    Dim i As Long

    'CTRL+Aを押下された場合、項目を全て選択する
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        
        With lsvItem(Index)
            For i = 1 To .ListItems.Count
                .ListItems(i).Selected = True
            Next i
        End With
    
    End If

End Sub

' @(e)
'
' 機能　　 : リストビューヘッダ編集
'
' 引数　　 : (In)   intListViewIndex    セットするリストビューのインデックス
'
' 戻り値　 : なし
'
' 機能説明 : ヘッダ情報の編集
'
' 備考　　 :
'
Private Sub EditListViewHeader(intListViewIndex As Integer)
    
    Dim objHeader           As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objTargetListView   As ListView
    
    Set objTargetListView = lsvItem(intListViewIndex)
    objTargetListView.ListItems.Clear
    Set objHeader = objTargetListView.ColumnHeaders
    
    With objHeader
        .Clear
        .Add , , "左辺", 3200, lvwColumnLeft
        .Add , , "演算子", 750, lvwColumnCenter
        .Add , , "右辺", 3200, lvwColumnLeft
    End With
    
    objTargetListView.View = lvwReport

End Sub

Private Sub EditHeaderExplain()
    
    Dim objCurCalc_Record       As Calc_Record
    
    '現在のカレント情報をオブジェクトにセット
    Set objCurCalc_Record = mcolCalcRecord(mstrArrCalcHNo(cboHistory.ListIndex))
    
    With objCurCalc_Record
        
        '端数処理
        Select Case .Fraction
            Case 0
                lblFraction.Caption = "四捨五入"
            Case 1
                lblFraction.Caption = "切り上げ"
            Case 2
                lblFraction.Caption = "切り捨て"
        End Select
    
        '計算タイミング
        Select Case .Timing
            Case 0
                lblTiming.Caption = "全ての値が揃ったときに計算"
            Case 1
                lblTiming.Caption = "計算要素のうち、一つでも値が入った場合"
        End Select
        
        '説明
        lblExplanation.Caption = .Explanation
    
    End With

    Set objCurCalc_Record = Nothing

End Sub

Private Sub TabMain_Click(PreviousTab As Integer)
    
    Dim i As Integer
    
    'アクティブタブインデックスと同じならコントロールは使用可能
    For i = 0 To 1
        lsvItem(i).Enabled = TabMain.Tab = i
        cmdItemCopy(i).Enabled = TabMain.Tab = i
        cmdAddItem(i).Enabled = TabMain.Tab = i
        cmdEditItem(i).Enabled = TabMain.Tab = i
        cmdDeleteItem(i).Enabled = TabMain.Tab = i
    Next i
    
End Sub
