VERSION 5.00
Begin VB.Form frmDmdLineClass 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "請求明細分類テーブルメンテナンス"
   ClientHeight    =   3600
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6690
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmDmdLineClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3600
   ScaleWidth      =   6690
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.Frame Frame1 
      Caption         =   "基本情報"
      Height          =   2775
      Index           =   0
      Left            =   120
      TabIndex        =   7
      Top             =   180
      Width           =   6315
      Begin VB.ComboBox cboMakeBillLine 
         Height          =   300
         ItemData        =   "frmDmdLineClass.frx":000C
         Left            =   2040
         List            =   "frmDmdLineClass.frx":002E
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   11
         Top             =   1800
         Width           =   4110
      End
      Begin VB.ComboBox cboIsrFlg 
         Height          =   300
         ItemData        =   "frmDmdLineClass.frx":0050
         Left            =   2040
         List            =   "frmDmdLineClass.frx":0072
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   9
         Top             =   1380
         Width           =   4110
      End
      Begin VB.CheckBox chkSumDetails 
         Caption         =   "健診基本料としてまとめる(&R)"
         Height          =   255
         Left            =   2040
         TabIndex        =   8
         Top             =   960
         Width           =   2655
      End
      Begin VB.TextBox txtDmdLineClassName 
         Height          =   300
         IMEMode         =   4  '全角ひらがな
         Left            =   2040
         MaxLength       =   15
         TabIndex        =   3
         Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
         Top             =   600
         Width           =   3075
      End
      Begin VB.TextBox txtDmdLineClassCd 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2040
         MaxLength       =   3
         TabIndex        =   1
         Text            =   "@@"
         Top             =   240
         Width           =   495
      End
      Begin VB.Label Label1 
         Caption         =   "請求書明細作成(&S):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   10
         Top             =   1860
         Width           =   1710
      End
      Begin VB.Label Label1 
         Caption         =   "健保使用分類(&W):"
         Height          =   180
         Index           =   3
         Left            =   180
         TabIndex        =   4
         Top             =   1440
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "請求明細分類名(&N):"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   2
         Top             =   660
         Width           =   1590
      End
      Begin VB.Label Label1 
         Caption         =   "請求明細分類コード(&C):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   300
         Width           =   1830
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3780
      TabIndex        =   5
      Top             =   3120
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5220
      TabIndex        =   6
      Top             =   3120
      Width           =   1335
   End
End
Attribute VB_Name = "frmDmdLineClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrDmdLineClassCd      As String   '請求明細分類コード
Private mblnInitialize          As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let DmdLineClassCd(ByVal vntNewValue As Variant)

    mstrDmdLineClassCd = vntNewValue
    
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
        If Trim(txtDmdLineClassCd.Text) = "" Then
            MsgBox "請求明細分類コードが入力されていません。", vbCritical, App.Title
            txtDmdLineClassCd.SetFocus
            Exit Do
        End If

        '報告書用請求明細分類名の入力チェック
        If Trim(txtDmdLineClassName.Text) = "" Then
            MsgBox "報告書用請求明細分類名が入力されていません。", vbCritical, App.Title
            txtDmdLineClassName.SetFocus
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
Private Function EditDmdLineClass() As Boolean

    Dim objDmdLineClass         As Object   '請求明細分類アクセス用
    Dim vntDmdLineClassName     As Variant  '報告書用請求明細分類名
    Dim vntSumDetails           As Variant  '請求明細分類用健診基本料集計フラグ
    Dim vntIsrFlg               As Variant  '健保使用フラグ
    Dim vntMakeBillLine         As Variant  '請求書明細作成フラグ
    Dim Ret                     As Boolean  '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objDmdLineClass = CreateObject("HainsDmdClass.DmdClass")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrDmdLineClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '請求明細分類テーブルレコード読み込み
        If objDmdLineClass.SelectDmdLineClass(mstrDmdLineClassCd, vntDmdLineClassName, vntSumDetails, vntIsrFlg, vntMakeBillLine) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtDmdLineClassCd.Text = mstrDmdLineClassCd
        txtDmdLineClassName.Text = vntDmdLineClassName
        If vntSumDetails = "1" Then
            chkSumDetails.Value = vbChecked
        End If
        
        Select Case Trim(vntIsrFlg)
            Case ""
                cboIsrFlg.ListIndex = 0
            Case "0"
                cboIsrFlg.ListIndex = 1
            Case "1"
                cboIsrFlg.ListIndex = 2
        End Select
        
        cboMakeBillLine.ListIndex = CInt(vntMakeBillLine)
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditDmdLineClass = Ret
    
    Exit Function

ErrorHandle:

    EditDmdLineClass = False
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
Private Function RegistDmdLineClass() As Boolean

On Error GoTo ErrorHandle

    Dim objDmdLineClass     As Object       '請求明細分類アクセス用
    Dim Ret                 As Long
    Dim strWkIsrFlg         As String
    
    If cboIsrFlg.ListIndex = 0 Then
        strWkIsrFlg = ""
    Else
        strWkIsrFlg = cboIsrFlg.ListIndex - 1
    End If
    

    'オブジェクトのインスタンス作成
    Set objDmdLineClass = CreateObject("HainsDmdClass.DmdClass")
    
    '請求明細分類テーブルレコードの登録
    Ret = objDmdLineClass.RegistDmdLineClass(IIf(txtDmdLineClassCd.Enabled, "INS", "UPD"), _
                                             Trim(txtDmdLineClassCd.Text), _
                                             Trim(txtDmdLineClassName.Text), _
                                             IIf(chkSumDetails.Value = vbChecked, "1", ""), _
                                             strWkIsrFlg, _
                                             cboMakeBillLine.ListIndex)

    If Ret = 0 Then
        MsgBox "入力された請求明細分類コードは既に存在します。", vbExclamation
        RegistDmdLineClass = False
        Exit Function
    End If
    
    RegistDmdLineClass = True
    
    Exit Function
    
ErrorHandle:

    RegistDmdLineClass = False
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
        
        '請求明細分類テーブルの登録
        If RegistDmdLineClass() = False Then
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

    Dim Ret     As Boolean  '戻り値
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    
    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    cboIsrFlg.Clear
    cboIsrFlg.AddItem "当分類は、健保でも一般団体でも使用する"
    cboIsrFlg.AddItem "当分類は、一般団体のみ使用する"
    cboIsrFlg.AddItem "当分類は、健保のみ使用する"
    cboIsrFlg.ListIndex = 0
    
    cboMakeBillLine.Clear
    cboMakeBillLine.AddItem "当分類で請求書明細を作成する"
    cboMakeBillLine.AddItem "当分類で請求書明細を作成しない"
    cboMakeBillLine.ListIndex = 0

    Do
        '請求明細分類情報の編集
        If EditDmdLineClass() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtDmdLineClassCd.Enabled = (txtDmdLineClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub
