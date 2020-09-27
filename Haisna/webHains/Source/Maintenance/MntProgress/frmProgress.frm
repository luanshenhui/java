VERSION 5.00
Begin VB.Form frmProgress 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "進捗管理用分類テーブルメンテナンス"
   ClientHeight    =   2415
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4140
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmProgress.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2415
   ScaleWidth      =   4140
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.TextBox txtSeq 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1860
      MaxLength       =   2
      TabIndex        =   7
      Text            =   "@@"
      Top             =   1260
      Width           =   375
   End
   Begin VB.TextBox txtProgressSName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1860
      MaxLength       =   2
      TabIndex        =   5
      Text            =   "＠＠"
      Top             =   900
      Width           =   495
   End
   Begin VB.TextBox txtProgressName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1860
      MaxLength       =   10
      TabIndex        =   3
      Text            =   "＠＠＠＠＠＠＠＠＠＠"
      Top             =   540
      Width           =   1935
   End
   Begin VB.TextBox txtProgressCd 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1860
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   180
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1140
      TabIndex        =   8
      Top             =   1980
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   2580
      TabIndex        =   9
      Top             =   1980
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "表示順番(&O)"
      Height          =   180
      Index           =   3
      Left            =   300
      TabIndex        =   6
      Top             =   1320
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "進捗分類略称(&R)"
      Height          =   180
      Index           =   2
      Left            =   300
      TabIndex        =   4
      Top             =   960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "進捗分類名(&N)"
      Height          =   180
      Index           =   1
      Left            =   300
      TabIndex        =   2
      Top             =   600
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "進捗分類コード(&C)"
      Height          =   180
      Index           =   0
      Left            =   300
      TabIndex        =   0
      Top             =   240
      Width           =   1410
   End
End
Attribute VB_Name = "frmProgress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrProgressCd  As String   '進捗管理用分類コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let ProgressCd(ByVal vntNewValue As Variant)

    mstrProgressCd = vntNewValue
    
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
        If Trim(txtProgressCd.Text) = "" Then
            MsgBox "進捗管理用分類コードが入力されていません。", vbCritical, App.Title
            txtProgressCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtProgressName.Text) = "" Then
            MsgBox "進捗分類名が入力されていません。", vbCritical, App.Title
            txtProgressName.SetFocus
            Exit Do
        End If

        '略称の入力チェック
        If Trim(txtProgressSName.Text) = "" Then
            MsgBox "進捗分類略称が入力されていません。", vbCritical, App.Title
            txtProgressSName.SetFocus
            Exit Do
        End If

        '表示順番の入力チェック
        If Trim(txtSeq.Text) = "" Then
            MsgBox "表示順番が入力されていません。", vbCritical, App.Title
            txtSeq.SetFocus
            Exit Do
        End If
        
        '表示順番の数値チェック
        If IsNumeric(txtSeq.Text) = False Then
            MsgBox "表示順番には数値を入力してください。", vbCritical, App.Title
            txtSeq.SetFocus
            Exit Do
        End If
        
        '表示順番の数値チェック２
        If CInt(txtSeq.Text) < 1 Then
            MsgBox "表示順番には正の値を入力してください。", vbCritical, App.Title
            txtSeq.SetFocus
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
Private Function EditProgress() As Boolean

    Dim objProgress         As Object         '進捗管理用分類アクセス用
    Dim vntProgressName     As Variant        '進捗管理用分類名
    Dim vntProgressSName    As Variant        '進捗管理用分類略称
    Dim vntSeq              As Variant        '表示順番
    Dim Ret                 As Boolean        '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objProgress = CreateObject("HainsProgress.Progress")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrProgressCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '進捗管理用分類テーブルレコード読み込み
        If objProgress.SelectProgress(mstrProgressCd, vntProgressName, vntProgressSName, vntSeq) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtProgressCd.Text = mstrProgressCd
        txtProgressName.Text = vntProgressName
        txtProgressSName.Text = vntProgressSName
        txtSeq.Text = vntSeq
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditProgress = Ret
    
    Exit Function

ErrorHandle:

    EditProgress = False
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
Private Function RegistProgress() As Boolean

On Error GoTo ErrorHandle

    Dim objProgress     As Object       '進捗管理用分類アクセス用
    Dim Ret             As Long
    
    'オブジェクトのインスタンス作成
    Set objProgress = CreateObject("HainsProgress.Progress")
    
    '進捗管理用分類テーブルレコードの登録
    Ret = objProgress.RegistProgress(IIf(txtProgressCd.Enabled, "INS", "UPD"), _
                                     Trim(txtProgressCd.Text), _
                                     Trim(txtProgressName.Text), _
                                     Trim(txtProgressSName.Text), _
                                     Trim(txtSeq.Text))

    If Ret = 0 Then
        MsgBox "入力された進捗管理用分類コードは既に存在します。", vbExclamation
        RegistProgress = False
        Exit Function
    End If
    
    RegistProgress = True
    
    Set objProgress = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objProgress = Nothing
    
    RegistProgress = False
    
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
        
        '進捗管理用分類テーブルの登録
        If RegistProgress() = False Then
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
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    
    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    Do
        '進捗管理用分類情報の編集
        If EditProgress() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtProgressCd.Enabled = (txtProgressCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

