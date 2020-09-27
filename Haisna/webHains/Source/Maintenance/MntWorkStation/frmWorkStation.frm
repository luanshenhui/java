VERSION 5.00
Begin VB.Form frmWorkStation 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "端末管理テーブルメンテナンス"
   ClientHeight    =   2730
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6255
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmWorkStation.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2730
   ScaleWidth      =   6255
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboIsPrintButton 
      Height          =   300
      ItemData        =   "frmWorkStation.frx":000C
      Left            =   1860
      List            =   "frmWorkStation.frx":002E
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   18
      Top             =   1440
      Width           =   4110
   End
   Begin VB.ComboBox cboProgress 
      Height          =   300
      ItemData        =   "frmWorkStation.frx":0050
      Left            =   1860
      List            =   "frmWorkStation.frx":0072
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   15
      Top             =   1800
      Visible         =   0   'False
      Width           =   4110
   End
   Begin VB.TextBox txtIP 
      Height          =   315
      Index           =   3
      Left            =   3660
      MaxLength       =   3
      TabIndex        =   4
      Text            =   "255"
      Top             =   180
      Width           =   435
   End
   Begin VB.TextBox txtIP 
      Height          =   315
      Index           =   2
      Left            =   3060
      MaxLength       =   3
      TabIndex        =   3
      Text            =   "255"
      Top             =   180
      Width           =   435
   End
   Begin VB.TextBox txtIP 
      Height          =   315
      Index           =   1
      Left            =   2460
      MaxLength       =   3
      TabIndex        =   2
      Text            =   "255"
      Top             =   180
      Width           =   435
   End
   Begin VB.TextBox txtIP 
      Height          =   315
      Index           =   0
      Left            =   1860
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "255"
      Top             =   180
      Width           =   435
   End
   Begin VB.CommandButton cmdGrp 
      Caption         =   "グループコード(&G)..."
      Height          =   315
      Left            =   120
      TabIndex        =   8
      Top             =   1020
      Width           =   1635
   End
   Begin VB.TextBox txtGrpCd 
      Height          =   300
      Left            =   1860
      MaxLength       =   5
      TabIndex        =   7
      Text            =   "@@@@@"
      Top             =   1020
      Width           =   795
   End
   Begin VB.TextBox txtWkStnName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1860
      MaxLength       =   15
      TabIndex        =   6
      Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
      Top             =   600
      Width           =   2895
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3240
      TabIndex        =   9
      Top             =   2220
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4680
      TabIndex        =   10
      Top             =   2220
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "進捗分類(&P):"
      Height          =   180
      Index           =   2
      Left            =   240
      TabIndex        =   17
      Top             =   1860
      Visible         =   0   'False
      Width           =   1350
   End
   Begin VB.Label Label1 
      Caption         =   "印刷ボタン表示(&P):"
      Height          =   180
      Index           =   5
      Left            =   240
      TabIndex        =   16
      Top             =   1500
      Width           =   1530
   End
   Begin VB.Label Label2 
      Caption         =   "．"
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
      Index           =   2
      Left            =   3540
      TabIndex        =   14
      Top             =   240
      Width           =   195
   End
   Begin VB.Label Label2 
      Caption         =   "．"
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
      Index           =   1
      Left            =   2940
      TabIndex        =   13
      Top             =   240
      Width           =   195
   End
   Begin VB.Label Label2 
      Caption         =   "．"
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
      Index           =   0
      Left            =   2340
      TabIndex        =   12
      Top             =   240
      Width           =   195
   End
   Begin VB.Label lblGrpName 
      Caption         =   "Label2"
      Height          =   195
      Left            =   2760
      TabIndex        =   11
      Top             =   1080
      Width           =   3135
   End
   Begin VB.Label Label1 
      Caption         =   "端末名(&N):"
      Height          =   180
      Index           =   1
      Left            =   240
      TabIndex        =   5
      Top             =   660
      Width           =   990
   End
   Begin VB.Label Label1 
      Caption         =   "IPアドレス(&I):"
      Height          =   180
      Index           =   0
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   1050
   End
End
Attribute VB_Name = "frmWorkStation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrIpAddress           As String   'IPアドレス

Private mblnInitialize          As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mstrRootProgressCd()    As String   'コンボボックスに対応する進捗分類コードの格納

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let IpAddress(ByVal vntNewValue As String)

    mstrIpAddress = vntNewValue
    
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
    Dim i   As Integer
    
    Ret = False
    
    Do
        
        For i = 0 To 3
        
            'IPアドレスの入力チェック
            If Trim(txtIP(i).Text) = "" Then
                MsgBox "IPアドレスが入力されていません。", vbCritical, App.Title
                txtIP(i).SetFocus
                Exit Do
            End If
        
            'IPアドレスの数値チェック
            If IsNumeric(txtIP(i).Text) = False Then
                MsgBox "IPアドレスは数値を入力してください。", vbCritical, App.Title
                txtIP(i).SetFocus
                Exit Do
            End If
        
            'IPアドレスの数値チェック
            If (CLng(txtIP(i).Text) > 255) Or (CLng(txtIP(i).Text) < 0) Then
                MsgBox "有効なIPアドレスを入力してください。", vbCritical, App.Title
                txtIP(i).SetFocus
                Exit Do
            End If
        
        Next i
        

        mstrIpAddress = ""
        For i = 0 To 2
            mstrIpAddress = mstrIpAddress & txtIP(i).Text & "."
        Next i
        
        mstrIpAddress = mstrIpAddress & txtIP(3).Text
        
        '名称の入力チェック
        If Trim(txtWkStnName.Text) = "" Then
            MsgBox "端末名が入力されていません。", vbCritical, App.Title
            txtWkStnName.SetFocus
            Exit Do
        End If

        'グループコードの入力チェック
        If CheckGrpExists() = False Then
            txtGrpCd.SetFocus
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
' 機能　　 : グループ存在チェック
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力されたグループコードの存在チェックを行う
'
' 備考　　 :
'
Private Function CheckGrpExists() As Boolean

    Dim objGrp          As Object     'グループ情報アクセス用
    Dim vntGrpName      As Variant

    Dim Ret             As Boolean              '戻り値
    Dim i               As Integer
    
    CheckGrpExists = False
    
    On Error GoTo ErrorHandle
    
    txtGrpCd.Text = Trim(txtGrpCd.Text)
    
    'オブジェクトのインスタンス作成
    Set objGrp = CreateObject("HainsGrp.Grp")
    
    Do
        '未設定なら処理終了
        If txtGrpCd.Text = "" Then
            Ret = True
            Exit Do
        End If
        
        'コーステーブルレコード読み込み
        If objGrp.SelectGrp_P(txtGrpCd.Text, vntGrpName) = False Then
            MsgBox "入力されたグループコードは存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        lblGrpName.Caption = vntGrpName
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckGrpExists = Ret
    
    Exit Function

ErrorHandle:

    CheckGrpExists = False
    MsgBox Err.Description, vbCritical
    
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
Private Function EditWorkStation() As Boolean

    Dim objWorkStation      As Object           '端末名アクセス用
    
    Dim vntWkStnName        As Variant          '端末名
    Dim vntGrpCd            As Variant          'グループコード
    Dim vntGrpName          As Variant          'グループ名
    Dim vntProgressCd       As Variant          '進捗分類コード
    Dim vntIsPrintButton    As Variant          '印刷ボタン表示
    Dim Ret                 As Boolean          '戻り値
    Dim i                   As Integer
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objWorkStation = CreateObject("HainsWorkStation.WorkStation")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If Trim(mstrIpAddress) = "" Then
            Ret = True
            Exit Do
        End If
        
        '端末名テーブルレコード読み込み
        If objWorkStation.SelectWorkStation(mstrIpAddress, _
                                            vntWkStnName, _
                                            vntGrpCd, _
                                            vntGrpName, _
                                            vntProgressCd, _
                                            vntIsPrintButton) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        Call SeparateIPAddress(mstrIpAddress)
        txtWkStnName.Text = vntWkStnName
        txtGrpCd.Text = vntGrpCd
        lblGrpName.Caption = vntGrpName
    
        '進捗分類設定
        If Trim(vntProgressCd) <> "" Then
            For i = 0 To UBound(mstrRootProgressCd)
                If mstrRootProgressCd(i) = vntProgressCd Then
                    cboProgress.ListIndex = i
                    Exit For
                End If
            Next i
        End If
    
        '結果入力印刷ボタン表示追加
        If Trim(vntIsPrintButton) <> "" And IsNumeric(vntIsPrintButton) = True Then
            cboIsPrintButton.ListIndex = CInt(vntIsPrintButton)
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditWorkStation = Ret
    
    Exit Function

ErrorHandle:

    EditWorkStation = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub SeparateIPAddress(strIPAddress As String)

    Dim intPointer      As Integer
    Dim intNowPointer   As Integer
    Dim strWorkString   As String
    Dim i               As Integer
    
    strWorkString = strIPAddress
    
    intNowPointer = 1
        
    For i = 0 To 3
        intPointer = InStr(1, strWorkString, ".")
        If intPointer > 0 Then
            txtIP(i).Text = Mid(strWorkString, 1, intPointer - 1)
        Else
            txtIP(i).Text = strWorkString
            Exit For
        End If
        
        strWorkString = Mid(strWorkString, intPointer + 1, Len(strWorkString))
    Next i

End Sub

'
' 機能　　 : データ登録
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function RegistWorkStation() As Boolean

On Error GoTo ErrorHandle

    Dim objWorkStation      As Object       '端末名アクセス用
    Dim Ret                 As Long
    Dim strIsPrintButton    As String
    
    '印刷ボタン状態をセット
    strIsPrintButton = ""
    If cboIsPrintButton.ListIndex > 0 Then
        strIsPrintButton = cboIsPrintButton.ListIndex
    End If
    
    'オブジェクトのインスタンス作成
    Set objWorkStation = CreateObject("HainsWorkStation.WorkStation")
    
    '端末名テーブルレコードの登録
    Ret = objWorkStation.RegistWorkStation(IIf(txtIP(0).Enabled, "INS", "UPD"), _
                                           mstrIpAddress, _
                                           Trim(txtWkStnName.Text), _
                                           Trim(txtGrpCd.Text), _
                                           mstrRootProgressCd(cboProgress.ListIndex), _
                                           strIsPrintButton)

    If Ret = 0 Then
        MsgBox "入力されたIPアドレスは既に存在します。", vbExclamation
        RegistWorkStation = False
        Exit Function
    End If
    
    RegistWorkStation = True
    
    Exit Function
    
ErrorHandle:

    RegistWorkStation = False
    MsgBox Err.Description, vbCritical
    
End Function

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

Private Sub cmdGrp_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '項目ガイド表示用
    
    Dim lngItemCount    As Long     '選択項目数
    Dim vntItemCd       As Variant  '選択された項目コード
    Dim vntItemName     As Variant  '選択された項目名

    lngItemCount = 0

    'オブジェクトのインスタンス作成
    Set objItemGuide = New mntItemGuide.ItemGuide
    
    With objItemGuide
        .Mode = MODE_RESULT
        .Group = GROUP_SHOW
        .Item = ITEM_OFF
        .Question = QUESTION_OFF
        .MultiSelect = False
    
        'コーステーブルメンテナンス画面を開く
        .Show vbModal
            
        '戻り値としてのプロパティ取得
        lngItemCount = .ItemCount
        vntItemCd = .ItemCd
        vntItemName = .ItemName
    
    End With

    If lngItemCount > 0 Then
        txtGrpCd.Text = vntItemCd(0)
        lblGrpName.Caption = vntItemName(0)
    End If
    
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
        If CheckValue() = False Then
            Exit Do
        End If
        
        '端末名テーブルの登録
        If RegistWorkStation() = False Then
            Exit Do
        End If
            
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
    Dim i As Integer
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    
    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    Do
        
        '進捗分類コンボの編集
        If EditProgressConbo() = False Then
            Exit Do
        End If
        
        '結果入力上の印刷ボタン表示追加
        cboIsPrintButton.Clear
        cboIsPrintButton.AddItem ""
        cboIsPrintButton.AddItem "超音波検査表印刷ボタン表示"
        cboIsPrintButton.AddItem "口腔疾患検査結果表印刷ボタン表示"
        
        '端末情報の編集
        If EditWorkStation() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        For i = 0 To 3
            txtIP(i).Enabled = (mstrIpAddress = "")
        Next i
        
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
' 機能　　 : 進捗分類データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 進捗分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditProgressConbo() As Boolean

    Dim objProgress     As Object   '進捗分類アクセス用
    Dim vntProgressCd   As Variant
    Dim vntProgressName As Variant
    Dim lngCount        As Long     'レコード数
    Dim i               As Long     'インデックス
    
    EditProgressConbo = False
    
    cboProgress.Clear
    Erase mstrRootProgressCd

    'オブジェクトのインスタンス作成
    Set objProgress = CreateObject("HainsProgress.Progress")
    lngCount = objProgress.SelectProgressList(vntProgressCd, vntProgressName)
    
    '進捗分類は空設定あり
    ReDim Preserve mstrRootProgressCd(0)
    mstrRootProgressCd(0) = ""
    cboProgress.AddItem ""
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootProgressCd(i + 1)
        mstrRootProgressCd(i + 1) = vntProgressCd(i)
        cboProgress.AddItem vntProgressName(i)
    Next i
    
    '先頭コンボを選択状態にする
    cboProgress.ListIndex = 0
    EditProgressConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub txtGrpCd_Change()

    lblGrpName.Caption = ""
    
End Sub

Private Sub txtIP_GotFocus(Index As Integer)

    With txtIP(Index)
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub
