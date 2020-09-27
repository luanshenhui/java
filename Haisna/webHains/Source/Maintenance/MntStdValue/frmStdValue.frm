VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmStdValue 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "基準値テーブルメンテナンス"
   ClientHeight    =   6855
   ClientLeft      =   1605
   ClientTop       =   1545
   ClientWidth     =   12315
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmStdValue.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6855
   ScaleWidth      =   12315
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.CommandButton cmdOtherItemCopy 
      Caption         =   "他の検査項目から基準値をコピーする(&O)..."
      Height          =   375
      Left            =   180
      TabIndex        =   24
      Top             =   6360
      Width           =   3435
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
      Height          =   315
      Left            =   10740
      TabIndex        =   21
      Top             =   6420
      Width           =   1275
   End
   Begin TabDlg.SSTab TabMain 
      Height          =   5055
      Left            =   120
      TabIndex        =   8
      Top             =   1260
      Width           =   11955
      _ExtentX        =   21087
      _ExtentY        =   8916
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "男性"
      TabPicture(0)   =   "frmStdValue.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Frame1"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "女性"
      TabPicture(1)   =   "frmStdValue.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "cmdEditItem(1)"
      Tab(1).Control(1)=   "cmdAddItem(1)"
      Tab(1).Control(2)=   "cmdDeleteItem(1)"
      Tab(1).Control(3)=   "Frame2"
      Tab(1).ControlCount=   4
      Begin VB.CommandButton cmdEditItem 
         Caption         =   "編集(&E)..."
         Height          =   315
         Index           =   1
         Left            =   -66000
         TabIndex        =   20
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddItem 
         Caption         =   "追加(&I)..."
         Height          =   315
         Index           =   1
         Left            =   -67380
         TabIndex        =   19
         Top             =   4320
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteItem 
         Caption         =   "削除(&R)"
         Height          =   315
         Index           =   1
         Left            =   -64620
         TabIndex        =   18
         Top             =   4320
         Width           =   1275
      End
      Begin VB.Frame Frame2 
         Caption         =   "設定した値(&C)"
         Height          =   4335
         Left            =   -74820
         TabIndex        =   14
         Top             =   480
         Width           =   11595
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
            Height          =   435
            Index           =   1
            Left            =   120
            TabIndex        =   26
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
            Height          =   435
            Index           =   1
            Left            =   120
            TabIndex        =   25
            Top             =   1320
            Width           =   435
         End
         Begin VB.CommandButton cmdItemCopy 
            Caption         =   "男性データからコピー(&C)..."
            Height          =   315
            Index           =   1
            Left            =   660
            TabIndex        =   23
            Top             =   3840
            Width           =   2055
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3495
            Index           =   1
            Left            =   660
            TabIndex        =   15
            Top             =   240
            Width           =   10815
            _ExtentX        =   19076
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
         TabIndex        =   9
         Top             =   480
         Width           =   11595
         Begin VB.CommandButton cmdItemCopy 
            Caption         =   "女性データからコピー(&C)..."
            Height          =   315
            Index           =   0
            Left            =   660
            TabIndex        =   22
            Top             =   3840
            Width           =   2055
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
            Height          =   435
            Index           =   0
            Left            =   120
            TabIndex        =   17
            Top             =   1320
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
            Height          =   435
            Index           =   0
            Left            =   120
            TabIndex        =   16
            Top             =   1980
            Width           =   435
         End
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "削除(&R)"
            Height          =   315
            Index           =   0
            Left            =   10200
            TabIndex        =   12
            Top             =   3840
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "追加(&1)..."
            Height          =   315
            Index           =   0
            Left            =   7440
            TabIndex        =   11
            Top             =   3840
            Width           =   1275
         End
         Begin VB.CommandButton cmdEditItem 
            Caption         =   "編集(&E)..."
            Height          =   315
            Index           =   0
            Left            =   8820
            TabIndex        =   10
            Top             =   3840
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3495
            Index           =   0
            Left            =   660
            TabIndex        =   13
            Top             =   240
            Width           =   10815
            _ExtentX        =   19076
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
   Begin VB.CommandButton cmdDeleteHistory 
      Caption         =   "削除(&D)..."
      Enabled         =   0   'False
      Height          =   315
      Left            =   6060
      TabIndex        =   5
      Top             =   900
      Width           =   1275
   End
   Begin VB.CommandButton cmdEditHistory 
      Caption         =   "編集(&H)..."
      Height          =   315
      Left            =   4680
      TabIndex        =   4
      Top             =   900
      Width           =   1275
   End
   Begin VB.CommandButton cmdNewHistory 
      Caption         =   "新規(&N)..."
      Height          =   315
      Left            =   3300
      TabIndex        =   3
      Top             =   900
      Width           =   1275
   End
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
      ItemData        =   "frmStdValue.frx":0044
      Left            =   1980
      List            =   "frmStdValue.frx":0066
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   2
      Top             =   480
      Width           =   5370
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   7860
      TabIndex        =   0
      Top             =   6420
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   9300
      TabIndex        =   1
      Top             =   6420
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
            Picture         =   "frmStdValue.frx":0088
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmStdValue.frx":04DA
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmStdValue.frx":092C
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmStdValue.frx":0A86
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   120
      Picture         =   "frmStdValue.frx":0BE0
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
      TabIndex        =   7
      Top             =   240
      Width           =   6375
   End
   Begin VB.Label Label8 
      Caption         =   "履歴情報(&H):"
      Height          =   195
      Index           =   0
      Left            =   900
      TabIndex        =   6
      Top             =   540
      Width           =   1095
   End
End
Attribute VB_Name = "frmStdValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================
'管理番号：SL-HS-Y0101-001
'事象番号：COMP-LUKES-0013（非互換検証）
'修正日  ：2010.07.16
'担当者  ：FJTH)KOMURO
'修正内容：ヘルスポイントのコピー漏れ修正
'========================================
Option Explicit

Private mstrStdValueMngCd       As String           '基準値値管理コード
Private mstrItemCd              As String           '検査項目コード
Private mstrSuffix              As String           'サフィックス
Private mintResultType          As String           '結果タイプ
Private mintItemType            As String           '項目タイプ
Private mstrStcItemCd           As String           '文章参照用項目コード

Private mblnInitialize          As Boolean          'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean          'TRUE:更新あり、FALSE:更新なし
Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション

Private mintUniqueKey           As Long             'リストビュー一意キー管理用番号
Private Const KEY_PREFIX        As String = "K"

Private mblnHistoryUpdated      As Boolean          'TRUE:基準値履歴更新あり、FALSE:基準値履歴更新なし
Private mblnItemUpdated         As Boolean          'TRUE:基準値詳細更新あり、FALSE:基準値詳細更新なし

Private mintBeforeIndex         As Integer          '履歴コンボ変更キャンセル用の前Index
Private mblnNowEdit             As Boolean          'TRUE:編集処理中、FALSE:処理なし

Private mstrArrStdValueMngCd()  As String           '基準値管理コード（コンボボックス対応用）
Private mcolStdValueRecord      As Collection       '基準値レコードのコレクション
Private mcolStdValue_cRecord    As Collection       '基準値詳細レコードのコレクション（読み込み直後のみ使用）
Private mcolItemHistory         As Collection       '検査項目履歴レコードのコレクション

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
        
        '# あえて基準値明細の未入力チェックを行わない
        '（ある期間で履歴を作成＋基準値なしならその期間だけ基準値設定をなしにできる）
        '（例えば、基準値を一括してクリアしたい場合など）
        
        '基準値明細（男なし、女あり）の場合
        If (lsvItem(0).ListItems.Count = 0) And (lsvItem(1).ListItems.Count > 0) Then
            strMsg = "男性の基準値が設定されていません。女性の基準値をコピーして格納しますか？"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbYes Then
                Call CopyItem(0, True)
            End If
        End If

        '基準値明細（女なし、男あり）の場合
        If (lsvItem(1).ListItems.Count = 0) And (lsvItem(0).ListItems.Count > 0) Then
            strMsg = "女性の基準値が設定されていません。男性の基準値をコピーして格納しますか？"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbYes Then
                Call CopyItem(1, True)
            End If
        End If

'        'コードの入力チェック
'        If Trim(txtItemCd.Text) = "" Then
'            MsgBox "基準値管理コードが入力されていません。", vbCritical, App.Title
'            txtItemCd.SetFocus
'            Exit Do
'        End If
'
'        '名称の入力チェック
'        If Trim(txtStdValueName.Text) = "" Then
'            MsgBox "基準値管理名が入力されていません。", vbCritical, App.Title
'            txtStdValueName.SetFocus
'            Exit Do
'        End If
'
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
Private Function EditStdValue(strItemCd As String, _
                              strSuffix As String, _
                              blnCopy As Boolean, _
                              Optional colWorkCollection As Collection) As Boolean

    Dim objStdValue         As Object           '基準値管理アクセス用
    Dim vntStdValueMngCd    As Variant          '基準値管理コード
    Dim vntItemCd           As Variant          '検査項目コード
    Dim vntSuffix           As Variant          'サフィックス
    Dim vntStrDate          As Variant          '使用開始日付
    Dim vntEndDate          As Variant          '使用終了日付
    Dim vntCsCd             As Variant          '対象コースコード
    Dim vntItemName         As Variant          '検査項目名
    Dim vntCsName           As Variant          '対象コース名
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Integer
    Dim Ret                 As Boolean          '戻り値
    Dim objStdValue_Record  As StdValue_Record  '基準値レコードオブジェクト
    
    On Error GoTo ErrorHandle
    
    'COPYモードでないなら、コレクション初期化
    If blnCopy = False Then
        Set mcolStdValueRecord = Nothing
        Set mcolStdValueRecord = New Collection
    End If
    
    Do
        '検査項目コード。サフィックス何れかが指定されていない場合は何もしない
'        If (mstrItemCd = "") Or (mstrSuffix = "") Then
        If (strItemCd = "") Or (strSuffix = "") Then
            Ret = True
            Exit Do
        End If
    
        'オブジェクトのインスタンス作成
        Set objStdValue = CreateObject("HainsStdValue.StdValue")
        
        '基準値管理テーブルレコード読み込み
        lngCount = objStdValue.SelectStdValueList("", _
                                                  strItemCd, _
                                                  strSuffix, _
                                                  vntStdValueMngCd, _
                                                  vntItemCd, _
                                                  vntSuffix, _
                                                  vntStrDate, _
                                                  vntEndDate, _
                                                  vntCsCd, _
                                                  vntItemName, _
                                                  vntCsName)
        
        
        If lngCount = 0 Then
            
            If blnCopy = False Then
                'COPYモードでないなら、新規作成
                '基準値管理テーブルが存在しない場合（新規作成モード）
                Call AddNewStdValue
            Else
                'COPYモードなら、COPYできないからエラー
                MsgBox "選択された項目には基準値が設定されていません。", vbExclamation, Me.Caption
                Exit Do
            End If
            
        Else
            
            '基準値管理テーブルが存在する場合（更新モード）
        
            '読み込み内容の編集
            For i = 0 To lngCount - 1
                
                Set objStdValue_Record = Nothing
                Set objStdValue_Record = New StdValue_Record
                
                'オブジェクト作成
                With objStdValue_Record
                    .StdValueMngCd = vntStdValueMngCd(i)
                    .ItemCd = vntItemCd(i)
                    .Suffix = vntSuffix(i)
                    .strDate = vntStrDate(i)
                    .endDate = vntEndDate(i)
                    .CsCd = vntCsCd(i)
                    .CsName = vntCsName(i)
                End With
                
                If blnCopy = False Then
                    'COPYモードでないなら、自データとして格納
                    
                    '配列作成
                    If Trim(vntCsName(i)) = "" Then
                        cboHistory.AddItem CStr(vntStrDate(i)) & "～" & CStr(vntEndDate(i)) & "に適用するデータ"
                    Else
                        cboHistory.AddItem CStr(vntStrDate(i)) & "～" & CStr(vntEndDate(i)) & "（" & vntCsName(i) & "）に適用するデータ"
                    End If
                    
                    'コンボボックス対応配列の作成
                    ReDim Preserve mstrArrStdValueMngCd(i)
                    mstrArrStdValueMngCd(i) = KEY_PREFIX & objStdValue_Record.StdValueMngCd
                    
                    'コレクション追加
                    mcolStdValueRecord.Add objStdValue_Record, KEY_PREFIX & objStdValue_Record.StdValueMngCd
                
                Else
                    'COPYモードなら、引数のコレクションに格納
                    
                    'コレクション追加
                    colWorkCollection.Add objStdValue_Record, KEY_PREFIX & objStdValue_Record.StdValueMngCd
                
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
    Set objStdValue = Nothing
    EditStdValue = Ret
    
    Exit Function

ErrorHandle:

    EditStdValue = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : 基準値詳細情報の取得
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function GetStdValue_c(strStdValueMngCd As String, blnCopy As Boolean) As Boolean

    Dim objStdValue             As Object       '基準値管理アクセス用
    
    Dim vntStdValueCd           As Variant      '基準値コード
    Dim vntGender               As Variant      '性別
    Dim vntStrAge               As Variant      '開始年齢
    Dim vntEndAge               As Variant      '終了年齢
    Dim vntPriorSeq             As Variant      '適用優先順位番号
    Dim vntLowerValue           As Variant      '基準値（以上）
    Dim vntUpperValue           As Variant      '基準値（以下）
    Dim vntStdFlg               As Variant      '基準値フラグ
    Dim vntJudCd                As Variant      '判定コード
    Dim vntJudCmtCd             As Variant      '判定コメントコード
    Dim vntHealthPoint          As Variant      'ヘルスポイント
    Dim vntSentence             As Variant      '文章
    Dim lngCount                As Long         'レコード数
'    Dim strStdValueMngCd        As String
    
    Dim i                       As Integer
    Dim Ret                     As Boolean      '戻り値
    
    Dim objStdValue_C_Record    As StdValue_C_Record    '基準値詳細レコードオブジェクト
    
    On Error GoTo ErrorHandle
        
    '現在表示している値のクリア (COPYモードのときもクリア）
    Set mcolStdValue_cRecord = Nothing
    Set mcolStdValue_cRecord = New Collection

    Do
        '基準値管理コードが指定されていない場合は何もしない
        If (strStdValueMngCd = "") Or (strStdValueMngCd = "0") Then
            Ret = True
            Exit Do
        End If
    
        'オブジェクトのインスタンス作成
        Set objStdValue = CreateObject("HainsStdValue.StdValue")
        
        '基準値管理テーブルレコード読み込み
        lngCount = objStdValue.SelectStdValue_cList(strStdValueMngCd, _
                                                    vntStdValueCd, _
                                                    vntGender, _
                                                    vntStrAge, _
                                                    vntEndAge, _
                                                    vntPriorSeq, _
                                                    vntLowerValue, _
                                                    vntUpperValue, _
                                                    vntStdFlg, _
                                                    vntJudCd, _
                                                    vntJudCmtCd, _
                                                    vntHealthPoint, _
                                                    vntSentence)
        
        '0件でも不思議なし
        If lngCount = 0 Then
            Ret = True
            Exit Do
        End If

        '読み込み内容の編集
        For i = 0 To lngCount - 1
            '読み込み内容をオブジェクトにセット
            Set objStdValue_C_Record = New StdValue_C_Record
            With objStdValue_C_Record
                
                If blnCopy = True Then
                    'Copyモードの場合、基準値管理コードはもとのまま、かつ基準値コードはセットしない（新規イメージ）
                    .StdValueMngCd = mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd
                    .StdValueCd = ""
                Else
                    .StdValueMngCd = strStdValueMngCd
                    .StdValueCd = vntStdValueCd(i)
                End If
                
                .Gender = vntGender(i)
                .StrAge = vntStrAge(i)
                .EndAge = vntEndAge(i)
                .PriorSeq = vntPriorSeq(i)
                .LowerValue = vntLowerValue(i)
                .UpperValue = vntUpperValue(i)
                .StdFlg = vntStdFlg(i)
                .JudCd = vntJudCd(i)
                .JudCmtCd = vntJudCmtCd(i)
                .HealthPoint = vntHealthPoint(i)
                .Sentence = vntSentence(i)
            End With
            
            'コレクションに追加
            mcolStdValue_cRecord.Add objStdValue_C_Record, KEY_PREFIX & vntStdValueCd(i)
            
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    Set objStdValue = Nothing
    
    '戻り値の設定
    GetStdValue_c = Ret
    
    Exit Function

ErrorHandle:

    GetStdValue_c = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : 基準値詳細情報の表示（コレクションから）
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditListViewFromCollection() As Boolean

On Error GoTo ErrorHandle

    Dim objItem     As ListItem             'リストアイテムオブジェクト
    Dim vntCsCd     As Variant              'コースコード
    Dim vntCsName   As Variant              'コース名
    Dim lngCount    As Long                 'レコード数
    Dim i           As Long                 'インデックス
    Dim objStdValue_C_Record    As StdValue_C_Record    '基準値詳細レコードオブジェクト
    
    EditListViewFromCollection = False

    'リストビュー用ヘッダ調整
    For i = 0 To 1
        Call EditListViewHeader(CInt(i))
    Next i
    
    'リストビュー用ユニークキー初期化
    mintUniqueKey = 1
    
    'リストの編集
    For Each objStdValue_C_Record In mcolStdValue_cRecord
        With objStdValue_C_Record
            
            '性別によりセットするリストビューを変更する
            i = .Gender - 1
        
            Set objItem = lsvItem(i).ListItems.Add(, KEY_PREFIX & mintUniqueKey, .StrAge, , "DEFAULTLIST")
            objItem.SubItems(1) = .EndAge
            objItem.SubItems(2) = .LowerValue
            If mintResultType = RESULTTYPE_SENTENCE Then
                objItem.SubItems(3) = .Sentence
            Else
                objItem.SubItems(3) = .UpperValue
            End If
            objItem.SubItems(4) = .StdFlg
            objItem.SubItems(5) = .JudCd
            objItem.SubItems(6) = .JudCmtCd
            objItem.SubItems(7) = .HealthPoint
            objItem.SubItems(8) = .StdValueCd
        
        End With
        mintUniqueKey = mintUniqueKey + 1
    
    Next objStdValue_C_Record
    
    'オブジェクト廃棄
    Set objStdValue_C_Record = Nothing
    
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
    
    Dim Ret         As Boolean              '戻り値
    
    GetItemInfo = False
    
    On Error GoTo ErrorHandle
    
    Do
        '検索条件が指定されていない場合は何もしない
        If (mstrItemCd = "") Or (mstrSuffix = "") Then
            Ret = False
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
                                    vntResultTypeName, , , , vntStcItemCd _
                                    ) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If

        '読み込み内容の編集
        mintResultType = CInt(vntResultType)        '結果タイプの編集
        mintItemType = CInt(vntItemType)            '項目タイプの編集
        mstrStcItemCd = CStr(vntStcItemCd)          '文書参照用コードの編集
        
        lblItemInfo.Caption = mstrItemCd & "-" & mstrSuffix & "：" & vntItemName
        Select Case mintResultType
            Case RESULTTYPE_NUMERIC
                lblItemInfo.Caption = lblItemInfo.Caption & "（数値タイプ）"
            Case RESULTTYPE_TEISEI1
                lblItemInfo.Caption = lblItemInfo.Caption & "（定性１タイプ）"
            Case RESULTTYPE_TEISEI2
                lblItemInfo.Caption = lblItemInfo.Caption & "（定性２タイプ）"
            Case RESULTTYPE_SENTENCE
                lblItemInfo.Caption = lblItemInfo.Caption & "（文章タイプ）"
            Case RESULTTYPE_CALC
                lblItemInfo.Caption = lblItemInfo.Caption & "（計算タイプ）"
            Case RESULTTYPE_DATE
                lblItemInfo.Caption = lblItemInfo.Caption & "（日付タイプ）"
            Case Else
                lblItemInfo.Caption = lblItemInfo.Caption & "（？規定外の結果タイプ）"
        End Select
        
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    GetItemInfo = Ret
    
    Exit Function

ErrorHandle:

    GetItemInfo = False
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
Private Function RegistStdValue() As Boolean

On Error GoTo ErrorHandle

    Dim objStdValue             As Object       '基準値管理アクセス用
    Dim Ret                     As Long
    Dim objCurStdValue_Record   As StdValue_Record
    
    '新規登録時の退避用
    Dim blnNewRecordFlg         As Boolean
    Dim strEscItemCd            As String
    Dim strEscSuffix            As String
    Dim strEscStrDate           As String
    Dim strEscEndDate           As String
    Dim strEscCsCd              As String

    '基準値
    Dim lngStdValueMngCd        As Long

    '基準値詳細の配列関連
    Dim intItemCount            As Integer
    Dim vntStdValueCd           As Variant
    Dim vntGender               As Variant
    Dim vntStrAge               As Variant
    Dim vntEndAge               As Variant
    Dim vntPriorSeq             As Variant
    Dim vntLowerValue           As Variant
    Dim vntUpperValue           As Variant
    Dim vntStdFlg               As Variant
    Dim vntJudCd                As Variant
    Dim vntJudCmtCd             As Variant
    Dim vntHealthPoint          As Variant
    
    Dim blnBeforeUpdatePoint    As Boolean      'TRUE:更新前、FALSE:更新前ではない
    
    blnBeforeUpdatePoint = False
    
    '新規挿入時はフラグ成立
    blnNewRecordFlg = False
    If mstrArrStdValueMngCd(cboHistory.ListIndex) = "K0" Then
        blnNewRecordFlg = True
    End If

    '現在のカレント情報をオブジェクトにセット
    Set objCurStdValue_Record = mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex))
    
    '基準値管理テーブルレコードの登録
    With objCurStdValue_Record
        
        '新規挿入モードの場合、設定内容を退避
        If blnNewRecordFlg = True Then
            strEscItemCd = .ItemCd
            strEscSuffix = .Suffix
            strEscStrDate = .strDate
            strEscEndDate = .endDate
            strEscCsCd = .CsCd
        End If
        
        '基準値管理コードのセット
        lngStdValueMngCd = .StdValueMngCd
        
        '基準値詳細テーブルの配列セット
        Call EditArrayForUpdate(intItemCount, _
                                vntStdValueCd, _
                                vntGender, _
                                vntStrAge, _
                                vntEndAge, _
                                vntPriorSeq, _
                                vntLowerValue, _
                                vntUpperValue, _
                                vntStdFlg, _
                                vntJudCd, _
                                vntJudCmtCd, _
                                vntHealthPoint)
        
        'オブジェクトのインスタンス作成
        Set objStdValue = CreateObject("HainsStdValue.StdValue")
    
        blnBeforeUpdatePoint = True
    
        '基準値データの登録
        Ret = objStdValue.RegistStdValue_All(lngStdValueMngCd, _
                                             .ItemCd, _
                                             .Suffix, _
                                             .strDate, _
                                             .endDate, _
                                             .CsCd, _
                                             intItemCount, _
                                             vntStdValueCd, _
                                             vntGender, _
                                             vntStrAge, _
                                             vntEndAge, _
                                             vntPriorSeq, _
                                             vntLowerValue, _
                                             vntUpperValue, _
                                             vntStdFlg, _
                                             vntJudCd, _
                                             vntJudCmtCd, _
                                             vntHealthPoint)
    End With
    
    blnBeforeUpdatePoint = False
    
    If Ret = INSERT_DUPLICATE Then
        MsgBox "入力された基準値管理コードは既に存在します。", vbExclamation
        RegistStdValue = False
        Exit Function
    End If
'
'    If Ret = INSERT_FKEYERROR Then
'        MsgBox "削除指定された設定基準値は既に検査結果の基準値としてセットされています。" & vbLf & _
'               "コピー機能などを指定して登録した場合は、一つずつの値を設定しなおすか、" & vbLf & _
'               "履歴管理機能を使用して新しい基準値履歴を作成してください。", vbCritical
'        RegistStdValue = False
'        Exit Function
'    End If
    
    If Ret = INSERT_ERROR Then
        MsgBox "テーブル更新時にエラーが発生しました。", vbCritical
        RegistStdValue = False
        Exit Function
    End If
    
    '新規挿入モードの場合、設定内容を退避
    If blnNewRecordFlg = True Then
        
        '新しい基準値履歴オブジェクトを作成
        Set objCurStdValue_Record = Nothing
        Set objCurStdValue_Record = New StdValue_Record
        With objCurStdValue_Record
            .StdValueMngCd = lngStdValueMngCd
            .ItemCd = strEscItemCd
            .Suffix = strEscSuffix
            .strDate = strEscStrDate
            .endDate = strEscEndDate
            .CsCd = strEscCsCd
        End With
        
        '現在の値(0)をコレクションから削除して発番された基準値履歴コードでコレクション追加
        mcolStdValueRecord.Remove (mstrArrStdValueMngCd(cboHistory.ListIndex))
        mcolStdValueRecord.Add objCurStdValue_Record, KEY_PREFIX & lngStdValueMngCd
        
        'コンボボックスの値も変更
        mstrArrStdValueMngCd(cboHistory.ListIndex) = KEY_PREFIX & lngStdValueMngCd

    End If

    'もう新規ではないのでボタン使用可能
    cmdNewHistory.Enabled = True
    
    '更新済みフラグを初期化
    mblnHistoryUpdated = False
    mblnItemUpdated = False
    
    RegistStdValue = True
    
    Exit Function
    
ErrorHandle:

    RegistStdValue = False
    
    If blnBeforeUpdatePoint = True Then
        MsgBox "基準値書き込み処理に失敗しました。原因としては以下の事由が考えられます。" & vbLf & vbLf & _
               "・設定されている基準値を使用している検査結果が存在するにも関わらず、その基準値を削除した。" & vbLf & _
               "・設定されている基準値を使用している検査結果が存在するにも関わらず、男女コピー機能を使用した。" & vbLf & _
               "・設定されている基準値を使用している検査結果が存在するにも関わらず、その他項目コピー機能を使用した。" & vbLf & _
               "・ネットワーク呼び出しエラー、COM+設定エラー等..." & vbLf _
               , vbCritical
    Else
        MsgBox Err.Description, vbCritical
    End If
    
End Function
Private Sub EditArrayForUpdate(intItemCount As Integer, _
                               vntStdValueCd As Variant, _
                               vntGender As Variant, _
                               vntStrAge As Variant, _
                               vntEndAge As Variant, _
                               vntPriorSeq As Variant, _
                               vntLowerValue As Variant, _
                               vntUpperValue As Variant, _
                               vntStdFlg As Variant, _
                               vntJudCd As Variant, _
                               vntJudCmtCd As Variant, _
                               vntHealthPoint As Variant)

    Dim vntArrStdValueCd()      As Variant
    Dim vntArrGender()          As Variant
    Dim vntArrStrAge()          As Variant
    Dim vntArrEndAge()          As Variant
    Dim vntArrPriorSeq()        As Variant
    Dim vntArrLowerValue()      As Variant
    Dim vntArrUpperValue()      As Variant
    Dim vntArrStdFlg()          As Variant
    Dim vntArrJudCd()           As Variant
    Dim vntArrJudCmtCd()        As Variant
    Dim vntArrHealthPoint()     As Variant
    
    Dim i                       As Integer
    Dim intArrCount             As Integer
    Dim intListViewIndex        As Integer
    Dim obTargetListView        As ListView

    intArrCount = 0

    '男女リストビューの中身をセット
    For intListViewIndex = 0 To 1
    
        'クリックされたインデックスで性別を選択
        Set obTargetListView = lsvItem(intListViewIndex)
    
        'リストビューをくるくる回して選択項目配列作成
        For i = 1 To obTargetListView.ListItems.Count
    
            ReDim Preserve vntArrStdValueCd(intArrCount)
            ReDim Preserve vntArrGender(intArrCount)
            ReDim Preserve vntArrStrAge(intArrCount)
            ReDim Preserve vntArrEndAge(intArrCount)
            ReDim Preserve vntArrPriorSeq(intArrCount)
            ReDim Preserve vntArrLowerValue(intArrCount)
            ReDim Preserve vntArrUpperValue(intArrCount)
            ReDim Preserve vntArrStdFlg(intArrCount)
            ReDim Preserve vntArrJudCd(intArrCount)
            ReDim Preserve vntArrJudCmtCd(intArrCount)
            ReDim Preserve vntArrHealthPoint(intArrCount)
    
            With obTargetListView.ListItems(i)
                
                vntArrStdValueCd(intArrCount) = .SubItems(8)
                vntArrGender(intArrCount) = intListViewIndex + 1
                vntArrStrAge(intArrCount) = .Text
                vntArrEndAge(intArrCount) = .SubItems(1)
                vntArrPriorSeq(intArrCount) = i
                vntArrLowerValue(intArrCount) = .SubItems(2)
                
                If (mintResultType = RESULTTYPE_TEISEI1) Or _
                   (mintResultType = RESULTTYPE_TEISEI2) Or _
                   (mintResultType = RESULTTYPE_SENTENCE) Then
                    '文章、定性の場合は、開始値を終了値にもセット
                    vntArrUpperValue(intArrCount) = .SubItems(2)
                Else
                    vntArrUpperValue(intArrCount) = .SubItems(3)
                End If
                
                
                
                vntArrStdFlg(intArrCount) = .SubItems(4)
                vntArrJudCd(intArrCount) = .SubItems(5)
                vntArrJudCmtCd(intArrCount) = .SubItems(6)
                vntArrHealthPoint(intArrCount) = .SubItems(7)
            
            End With
            
            intArrCount = intArrCount + 1
    
        Next i
    
    Next intListViewIndex

    vntStdValueCd = vntArrStdValueCd
    vntGender = vntArrGender
    vntStrAge = vntArrStrAge
    vntEndAge = vntArrEndAge
    vntPriorSeq = vntArrPriorSeq
    vntLowerValue = vntArrLowerValue
    vntUpperValue = vntArrUpperValue
    vntStdFlg = vntArrStdFlg
    vntJudCd = vntArrJudCd
    vntJudCmtCd = vntArrJudCmtCd
    vntHealthPoint = vntArrHealthPoint

    intItemCount = intArrCount

End Sub

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
            strMsg = "基準値の設定内容が更新されています。履歴データを再表示すると変更内容が破棄されます" & vbLf & _
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
        
        '基準値詳細情報の編集
        If GetStdValue_c(mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd, False) = False Then
            Exit Do
        End If
        
        '取得基準値情報のリストビュー格納
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


Private Sub cmdAddItem_Click(Index As Integer)

    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim obTargetListView    As ListView
    Dim i                   As Integer
    
    Dim strStrAge           As String           '開始年齢
    Dim strEndAge           As String           '終了年齢
    Dim strLowerValue       As String           '基準値（以上）
    Dim strUpperValue       As String           '基準値（以下）
    Dim strStdFlg           As String           '基準値フラグ
    Dim strJudCd            As String           '判定コード
    Dim strJudCmtCd         As String           '判定コメントコード
    Dim strHealthPoint      As String           'ヘルスポイント
    
    Dim vntStcCd            As Variant          '基準値用文章コード配列
    Dim vntSentence         As Variant          '文章配列
    Dim intSentenceCount    As Integer          '選択された文章の数
    
    'クリックされたインデックスで性別を選択
    Set obTargetListView = lsvItem(Index)

    With frmEditStdValueItem
        
        .ResultType = mintResultType
        .ItemType = mintItemType
        .StcItemCd = mstrStcItemCd
        .ItemHistory = mcolItemHistory
        
        .Show vbModal
    
        If .Updated = True Then
            
            strStrAge = .StrAge
            strEndAge = .EndAge
            strLowerValue = .LowerValue
            strUpperValue = .UpperValue
            strStdFlg = .StdFlg
            strJudCd = .JudCd
            strJudCmtCd = .JudCmtCd
            strHealthPoint = .HealthPoint
            
            vntStcCd = .StcCd
            vntSentence = .Sentence
            intSentenceCount = .SentenceCount
            
            If mintResultType = RESULTTYPE_SENTENCE Then
                '文章タイプの場合
                For i = 0 To intSentenceCount - 1
                    
                    '更新されているなら、リストビューに追加
                    Set objItem = obTargetListView.ListItems.Add(, KEY_PREFIX & mintUniqueKey, strStrAge, , "DEFAULTLIST")
                    objItem.SubItems(1) = strEndAge
                    objItem.SubItems(2) = vntStcCd(i)
                    objItem.SubItems(3) = vntSentence(i)
                    objItem.SubItems(4) = strStdFlg
                    objItem.SubItems(5) = strJudCd
                    objItem.SubItems(6) = strJudCmtCd
                    objItem.SubItems(7) = strHealthPoint
'#### 2010.07.16 SL-HS-Y0101-001 ADD START ####　COMP-LUKES-0013（非互換検証）
                    objItem.SubItems(8) = ""
'#### 2010.07.16 SL-HS-Y0101-001 ADD END ####　　COMP-LUKES-0013（非互換検証）
                
                    mintUniqueKey = mintUniqueKey + 1
                
                Next i
            
            Else
                '文章タイプ以外の場合
            
                '更新されているなら、リストビューに追加
                Set objItem = obTargetListView.ListItems.Add(, KEY_PREFIX & mintUniqueKey, strStrAge, , "DEFAULTLIST")
                objItem.SubItems(1) = strEndAge
                objItem.SubItems(2) = strLowerValue
                objItem.SubItems(3) = strUpperValue
                objItem.SubItems(4) = strStdFlg
                objItem.SubItems(5) = strJudCd
                objItem.SubItems(6) = strJudCmtCd
                objItem.SubItems(7) = strHealthPoint
'#### 2010.07.16 SL-HS-Y0101-001 ADD START ####　COMP-LUKES-0013（非互換検証）
                objItem.SubItems(8) = ""
'#### 2010.07.16 SL-HS-Y0101-001 ADD END ####　　COMP-LUKES-0013（非互換検証）
            
                mintUniqueKey = mintUniqueKey + 1
            End If
            
            '基準値詳細更新済み
            mblnItemUpdated = True
        
        End If
        
    End With
    
    'オブジェクトの廃棄
    Set frmEditStdValueItem = Nothing
    
End Sub

Private Sub cmdApply_Click()

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    'データの保存
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
    
    '基準値管理テーブルの登録
    If RegistStdValue() = False Then
        Exit Function
    End If
    
    '更新済みフラグをTRUEに
    mblnUpdated = True
        
    'OKボタン押下時をここで終了
    If blnOkMode = True Then
        ApplyData = True
        Exit Function
    End If
        
    MsgBox "入力された内容を保存しました。", vbInformation

    '基準値詳細情報の編集（画面再表示を行うことにより基準値コードを再取得）
    If GetStdValue_c(mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd, False) = False Then
        Exit Function
    End If
    
    '取得基準値情報のリストビュー格納
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
            '基準値詳細更新済み
            mblnItemUpdated = True
        
        End If
    
    Next i

End Sub

Private Sub cmdDownItem_Click(Index As Integer)
    
    Call MoveListItem(1, Index)

End Sub

Private Sub cmdEditHistory_Click()

    Dim objCurStdValue_Record As StdValue_Record
    Set objCurStdValue_Record = mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex))

    With frmEditStdValueHistory
        
        'プロパティセット
        .strDate = objCurStdValue_Record.strDate
        .endDate = objCurStdValue_Record.endDate
        .CsCd = objCurStdValue_Record.CsCd
        
        '画面表示
        .Show vbModal
    
        '更新されている場合、現在のオブジェクト状態を更新
        If .Updated = True Then
        
            'オブジェクト内容を更新
            objCurStdValue_Record.strDate = .strDate
            objCurStdValue_Record.endDate = .endDate
            objCurStdValue_Record.CsCd = .CsCd
            
            'コンボボックスの表示内容を変更
            If Trim(.CsCd) = "" Then
                cboHistory.List(cboHistory.ListIndex) = .strDate & "～" & .endDate & "に適用するデータ"
            Else
                cboHistory.List(cboHistory.ListIndex) = .strDate & "～" & .endDate & "（" & .CsName & "）に適用するデータ"
            End If
            
            '更新されたモード
            mblnHistoryUpdated = True
        
        End If
        
    End With

End Sub

Private Sub cmdEditItem_Click(Index As Integer)

    Dim i                       As Integer
    Dim strTargetKey            As String
    Dim strTargetDiv            As String
    Dim strTargetCd             As String
    Dim obTargetListView        As ListView
    
    Dim intArrSelectedIndex()   As Integer
    Dim intSelectedCount        As Integer
    
    'クリックされたインデックスで性別を選択
    Set obTargetListView = lsvItem(Index)
    
    'リストビュー上の選択項目数をカウント
    intSelectedCount = 0
    With obTargetListView
        For i = 1 To .ListItems.Count
            If .ListItems(i).Selected = True Then
                ReDim Preserve intArrSelectedIndex(intSelectedCount)
                intArrSelectedIndex(intSelectedCount) = i
                intSelectedCount = intSelectedCount + 1
            End If
        Next i
    End With
    
    '何も選択されていないなら処理終了
    If intSelectedCount = 0 Then Exit Sub
    
    '複数選択状態なら一応１回聞いてあげる
    If intSelectedCount > 1 Then
        If MsgBox("項目が複数選択されています。選択された項目全てに同じ設定を適用する処理を行いますか？", vbYesNo + vbDefaultButton2 + vbQuestion, Me.Caption) = vbNo Then
            Exit Sub
        End If
    End If
    
    With frmEditStdValueItem
        
        'ガイドに対するプロパティセット（複数選択の場合はとりあえず先頭をセット）
        .ResultType = mintResultType
        .ItemType = mintItemType
        .StcItemCd = mstrStcItemCd
        
        .StrAge = obTargetListView.ListItems(intArrSelectedIndex(0)).Text
        .EndAge = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(1)
        .LowerValue = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(2)
        .UpperValue = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(3)
        .StdFlg = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(4)
        .JudCd = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(5)
        .JudCmtCd = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(6)
        .HealthPoint = obTargetListView.ListItems(intArrSelectedIndex(0)).SubItems(7)
        If intSelectedCount > 1 Then
            .MultiSelect = True
        Else
            .MultiSelect = False
        End If
        .ItemHistory = mcolItemHistory
    
        .Show vbModal
    
        If .Updated = True Then
            
            For i = 0 To UBound(intArrSelectedIndex)
            
                obTargetListView.ListItems(intArrSelectedIndex(i)).Text = .StrAge
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(1) = .EndAge
                
                If intSelectedCount = 1 Then
                    
                    If mintResultType = RESULTTYPE_SENTENCE Then
                        obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(2) = .StcCd(0)
                        obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(3) = .Sentence(0)
                    Else
                        obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(2) = .LowerValue
                        obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(3) = .UpperValue
                    End If
                                    
                End If
                
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(4) = .StdFlg
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(5) = .JudCd
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(6) = .JudCmtCd
                obTargetListView.ListItems(intArrSelectedIndex(i)).SubItems(7) = .HealthPoint
            
            Next i
        
            '基準値詳細更新済み
            mblnItemUpdated = True
        
        End If
        
        'オブジェクトの廃棄
        Set frmEditStdValueItem = Nothing
        
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
            strMsg = "基準値の設定内容が更新されています。履歴データを再表示すると変更内容が破棄されます" & vbLf & _
                     "よろしいですか？"
            intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
            If intRet = vbNo Then Exit Sub
        End If
        
        '新規ダミーレコードの作成
        Call AddNewStdValue
        
        '基準値詳細情報の編集（新規なので本来不要だが先頭でメモリクリアしておしまい）
        If GetStdValue_c(mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd, False) = False Then
            Exit Do
        End If
        
        '取得基準値情報のリストビュー格納（新規なので本来不要だが先頭でメモリクリアしておしまい）
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        '全て未更新状態に戻す
        mblnHistoryUpdated = False
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
    
    'データの保存
    If ApplyData(True) = True Then
        '画面を閉じる
        Unload Me
    End If
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub cmdOtherItemCopy_Click()
    
    Dim objItemGuide        As mntItemGuide.ItemGuide   '項目ガイド表示用
    
    Dim lngItemCount        As Long     '選択項目数
    Dim vntItemCd           As Variant  '選択された項目コード
    Dim vntSuffix           As Variant  '選択されたサフィックス
    Dim i                   As Integer
    Dim blnUpdated          As Boolean
    Dim strMsg              As String
    Dim colWorkCollection   As Collection
    
    '基準値データを１つでも設定されている場合にアラート
    If (lsvItem(0).ListItems.Count > 0) Or (lsvItem(0).ListItems.Count > 0) Then
        strMsg = "他のデータからコピーを行うと現在設定されている基準値はクリアーされます。よろしいですか？" & vbLf & vbLf & _
                 "また、現在設定されている基準値コードを使用している検査項目が存在している場合、保存時に参照エラーで失敗する場合があります。"
        If MsgBox(strMsg, vbQuestion + vbYesNo + vbDefaultButton2, Me.Caption) = vbNo Then
            Exit Sub
        End If
    End If
    
    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
        .Group = GROUP_OFF
        .Item = ITEM_SHOW
        .Question = QUESTION_SHOW
        .ResultType = mintResultType
        .MultiSelect = False
    
        'コーステーブルメンテナンス画面を開く
        .Show vbModal
        
        '戻り値としてのプロパティ取得
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntSuffix = .Suffix
    
    End With

    Set objItemGuide = Nothing
        
    '選択件数が0件以上なら
    If lngItemCount > 0 Then

        Set colWorkCollection = Nothing
        Set colWorkCollection = New Collection

        '基準値履歴管理情報の編集
        If EditStdValue(CStr(vntItemCd(0)), CStr(vntSuffix(0)), True, colWorkCollection) = False Then
            Exit Sub
        End If

        '履歴数が１つ以上ある場合、選択ダイアログ表示
'        If colWorkCollection.Count > 1 Then
        If colWorkCollection.Count > 0 Then
            With frmSelectCopyStdValue
                .HistoryCollection = colWorkCollection
                .Show vbModal
                blnUpdated = .Updated
                i = .Index
            End With
        
            'キャンセルされたら更新なし
            If blnUpdated = False Then
                MsgBox "処理がキャンセルされました。", vbInformation, Me.Caption
                Exit Sub
            End If
        Else
            'コレクションは無条件で１
            i = 1
        End If

        '基準値詳細情報の編集
        If GetStdValue_c(colWorkCollection(i).StdValueMngCd, True) = False Then
            Exit Sub
        End If

        '取得基準値情報のリストビュー格納
        If EditListViewFromCollection() = False Then
            Exit Sub
        End If
    
    End If

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
        '検査項目基本情報の取得
        If GetItemInfo() = False Then
            Exit Do
        End If
        
        '検査項目履歴情報の取得
        If GetItemHistory() = False Then
            Exit Do
        End If

        '基準値履歴管理情報の編集
        If EditStdValue(mstrItemCd, mstrSuffix, False) = False Then
            Exit Do
        End If
    
        cboHistory.ListIndex = 0
    
        '基準値管理コードが設定されている場合、その値でコンボ初期表示
        If mstrStdValueMngCd <> "" Then
            
            For i = 0 To UBound(mstrArrStdValueMngCd)
                If mstrArrStdValueMngCd(i) = KEY_PREFIX & mstrStdValueMngCd Then
                    cboHistory.ListIndex = i
                End If
            Next i
        
        End If
    
        '基準値詳細情報の編集
        If GetStdValue_c(mcolStdValueRecord(mstrArrStdValueMngCd(cboHistory.ListIndex)).StdValueMngCd, False) = False Then
            Exit Do
        End If
        
        '取得基準値情報のリストビュー格納
        If EditListViewFromCollection() = False Then
            Exit Do
        End If
        
        'イネーブル設定
'        txtItemCd.Enabled = (txtItemCd.Text = "")
        
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
' 機能　　 : 検査項目履歴データ取得
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査項目に存在する履歴データを表示する
'
' 備考　　 :
'
Private Function GetItemHistory() As Boolean

    Dim objItem_c           As Object           '検査項目アクセス用
    Dim objItemHistory      As ItemHistory
    
    Dim vntHistoryCount     As Variant  '
    Dim vntUnit             As Variant  '
    Dim vntFigure1          As Variant  '
    Dim vntFigure2          As Variant  '
    Dim vntMaxValue         As Variant  '
    Dim vntMinValue         As Variant  '
    Dim vntItemHNo          As Variant  '
    Dim vntStrDate          As Variant  '
    Dim vntEndDate          As Variant  '
    Dim vntInsItemCd        As Variant  '
    Dim vntKarteItemcd      As Variant  '
    Dim vntKarteItemName    As Variant  '
    Dim vntKarteItemAttr    As Variant  '
    Dim vntKarteDocCd       As Variant  '
    Dim vntDefResult        As Variant  '
    Dim vntDefRslCmtCd      As Variant  '

    Dim i           As Long             'インデックス
    Dim Ret         As Boolean
    
    GetItemHistory = False

    '新規作成時は処理終了
    If (mstrItemCd = "") Or (mstrSuffix = "") Then
        Exit Function
    End If
    
    'オブジェクトのインスタンス作成
    Set objItem_c = CreateObject("HainsItem.Item")
    Ret = objItem_c.SelectItemHistory(mstrItemCd, _
                                      mstrSuffix, _
                                      "", _
                                      "", _
                                      "", _
                                      vntHistoryCount, _
                                      vntUnit, _
                                      vntFigure1, _
                                      vntFigure2, _
                                      vntMaxValue, _
                                      vntMinValue, _
                                      vntItemHNo, _
                                      vntStrDate, _
                                      vntEndDate, _
                                      vntInsItemCd, _
                                      vntDefResult, _
                                      vntDefRslCmtCd)
                                      
'                                      vntKarteItemcd, _
'                                      vntKarteItemName, _
'                                      vntKarteItemAttr, _
'                                      vntKarteDocCd, _

    'コレクション作成
    Set mcolItemHistory = New Collection
    
    For i = 0 To CInt(vntHistoryCount) - 1
        
        '履歴オブジェクト（コレクション）の作成
        Set objItemHistory = New ItemHistory
        With objItemHistory
            .Unit = vntUnit(i)
            .Figure1 = vntFigure1(i)
            .Figure2 = vntFigure2(i)
            .MaxValue = vntMaxValue(i)
            .MinValue = vntMinValue(i)
            .ItemHNo = vntItemHNo(i)
            .strDate = vntStrDate(i)
            .endDate = vntEndDate(i)
            .InsItemCd = vntInsItemCd(i)
'            .KarteItemcd = vntKarteItemcd(i)
'            .KarteItemName = vntKarteItemName(i)
'            .KarteItemAttr = vntKarteItemAttr(i)
'            .KarteDocCd = vntKarteDocCd(i)
            .DefResult = vntDefResult(i)
            .DefRslCmtCd = vntDefRslCmtCd(i)
            .UniqueKey = KEY_PREFIX & vntItemHNo(i)
        
        End With

        mcolItemHistory.Add objItemHistory, KEY_PREFIX & vntItemHNo(i)
        Set objItemHistory = Nothing

'
'        'コンボの名称追加
'        cboHistory.AddItem CStr(vntStrDate(i)) & "～" & CStr(vntEndDate(i)) & "に適用するデータ"
    
    Next i
        
    'データが取得できたなら処理終了
    If CInt(vntHistoryCount) >= 1 Then
        GetItemHistory = True
    Else
        MsgBox "検査項目履歴情報が存在しません。", vbCritical
    End If
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

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

'    obTargetListView.ListItems.Clear
'
'    'ヘッダの編集
'    With obTargetListView.ColumnHeaders
'        .Clear
'        .Add , , "開始年齢", 900, lvwColumnLeft
'        .Add , , "終了年齢", 900, lvwColumnLeft
'        .Add , , "基準値（以下）", 1400, lvwColumnLeft
'        .Add , , "基準値（以上）", 1400, lvwColumnLeft
'        .Add , , "基準値フラグ", 1200, lvwColumnLeft
'        .Add , , "判定コード", 1200, lvwColumnLeft
'        .Add , , "判定コメントコード", 1200, lvwColumnLeft
'        .Add , , "ヘルスポイント", 1200, lvwColumnLeft
'        .Add , , "基準値コード", 1200, lvwColumnLeft
'    End With
    
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


Friend Property Get StdValueMngCd() As String

    StdValueMngCd = mstrStdValueMngCd

End Property

Friend Property Let StdValueMngCd(ByVal vNewValue As String)

    mstrStdValueMngCd = vNewValue

End Property


Friend Property Let Suffix(ByVal vNewValue As Variant)

    mstrSuffix = vNewValue

End Property

Private Sub lsvItem_DblClick(Index As Integer)

    Call cmdEditItem_Click(Index)

End Sub

' @(e)
'
' 機能　　 : 基準値履歴データの新規作成
'
' 引数　　 : なし
'
' 機能説明 : 新規作成時に基準値履歴データをデフォルト作成する
'
' 備考　　 :
'
Private Sub AddNewStdValue()
    
    Dim objStdValue_Record  As StdValue_Record  '基準値レコードオブジェクト
    Dim intArrCount         As Integer
    
    '配列数の取得
    intArrCount = mcolStdValueRecord.Count
    
    '配列を拡張（コレクションの数で作成すると必然的に+1になる）
    ReDim Preserve mstrArrStdValueMngCd(intArrCount)
    
    Set objStdValue_Record = New StdValue_Record
    With objStdValue_Record
        .StdValueMngCd = "0"
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        .strDate = YEARRANGE_MIN & "/01/01"
        .endDate = YEARRANGE_MAX & "/12/31"
        .CsCd = ""
        cboHistory.AddItem .strDate & "～" & .endDate & "に適用するデータ"
        cboHistory.ListIndex = cboHistory.NewIndex
    End With
    
    '配列に退避
    mstrArrStdValueMngCd(intArrCount) = KEY_PREFIX & objStdValue_Record.StdValueMngCd
    
    'コレクション追加
    mcolStdValueRecord.Add objStdValue_Record, KEY_PREFIX & objStdValue_Record.StdValueMngCd

    '捏造したので更新されたモード
    mblnHistoryUpdated = True

    '今新規なのに新規ボタン不要だろ制御
    cmdNewHistory.Enabled = False
    
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
    

    '自性別と逆のインデックスを求める
    intOtherIndex = 1 Xor Index
    
    If Index = 0 Then
        strCurrName = "男性基準値設定欄"
        strOtherName = "女性基準値設定欄"
    Else
        strCurrName = "女性基準値設定欄"
        strOtherName = "男性基準値設定欄"
    End If
    
    'コピー元のアイテム数確認
    If (lsvItem(intOtherIndex).ListItems.Count = 0) And (Cancel = False) Then
        MsgBox strOtherName & "に項目が何も設定されていません", vbInformation
        Exit Sub
    End If
    
    '自項目のアイテム確認
    If (lsvItem(Index).ListItems.Count > 0) And (Cancel = False) Then
    
        strMsg = strCurrName & "に項目が設定されています。既にある項目に追加しますか？" & vbLf & vbLf & _
                 "いいえを選択するとクリアしてから追加します。" & vbLf & vbLf & _
                 "また、現在設定されている基準値コードを使用している検査項目が存在している場合、保存時に参照エラーで失敗する場合があります。"
        intRet = MsgBox(strMsg, vbYesNoCancel + vbDefaultButton3 + vbExclamation)
        
        'キャンセル押下で処理終了
        If intRet = vbCancel Then Exit Sub
    
        'いいえなら１回クリア
        If intRet = vbNo Then
            lsvItem(Index).ListItems.Clear
        End If
    
    End If
    
    'サブアイテムの数を取得
    intEscFieldCount = lsvItem(intOtherIndex).ListItems(1).ListSubItems.Count
    
    'とりゃ！項目コピー
    For i = 1 To lsvItem(intOtherIndex).ListItems.Count
        Set objItem = lsvItem(Index).ListItems.Add(, KEY_PREFIX & mintUniqueKey, _
                                                   lsvItem(intOtherIndex).ListItems(i), , "DEFAULTLIST")
        'アイテムコピー（基準値コード設定欄はコピーしちゃだめ）
        For j = 1 To intEscFieldCount - 1
            objItem.SubItems(j) = lsvItem(intOtherIndex).ListItems(i).SubItems(j)
        Next j
        
        '基準値コード設定欄は空白セット
        objItem.SubItems(j) = ""
        mintUniqueKey = mintUniqueKey + 1
    Next i

    '画面が乱れるので再描画
    lsvItem(Index).Refresh
    
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
    
'    Dim i           As Long                 'インデックス
    
    'ヘッダの編集
'    For i = 0 To 1
    
    Set objTargetListView = lsvItem(intListViewIndex)
    objTargetListView.ListItems.Clear
    Set objHeader = objTargetListView.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "開始年齢", 900, lvwColumnLeft
        .Add , , "終了年齢", 900, lvwColumnLeft
        
        Select Case mintResultType
            '定性タイプの場合
            Case RESULTTYPE_TEISEI1, RESULTTYPE_TEISEI2
                .Add , , "定性値", 1400, lvwColumnLeft
                .Add , , "", 0, lvwColumnLeft
            
            '文章タイプの場合
            Case RESULTTYPE_SENTENCE
                .Add , , "文章コード", 1000, lvwColumnLeft
                .Add , , "文章", 1800, lvwColumnLeft
            
            'それ以外のタイプ
            Case Else
                .Add , , "基準値（以下）", 1400, lvwColumnLeft
                .Add , , "基準値（以上）", 1400, lvwColumnLeft
        End Select
        
        .Add , , "基準値フラグ", 1200, lvwColumnLeft
        .Add , , "判定コード", 1200, lvwColumnLeft
        .Add , , "判定コメントコード", 1200, lvwColumnLeft
        .Add , , "ヘルスポイント", 1200, lvwColumnLeft
        .Add , , "基準値コード", 800, lvwColumnLeft
    End With
    objTargetListView.View = lvwReport
    
'    Next i

End Sub
