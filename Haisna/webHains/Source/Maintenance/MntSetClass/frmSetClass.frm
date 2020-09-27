VERSION 5.00
Begin VB.Form frmSetClass 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "セット分類テーブルメンテナンス"
   ClientHeight    =   1500
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6570
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmSetClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1500
   ScaleWidth      =   6570
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.TextBox txtSetClassName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1740
      MaxLength       =   60
      TabIndex        =   3
      Text            =   "＠＠＠＠＠＠＠＠＠＠"
      Top             =   480
      Width           =   4635
   End
   Begin VB.TextBox txtSetClassCd 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1740
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   615
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3660
      TabIndex        =   4
      Top             =   1020
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5100
      TabIndex        =   5
      Top             =   1020
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "セット分類名(&N)"
      Height          =   180
      Index           =   1
      Left            =   180
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "セット分類コード(&C)"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmSetClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrSetClassCd  As String   'セット分類コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let SetClassCd(ByVal vntNewValue As Variant)

    mstrSetClassCd = vntNewValue
    
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
        If Trim(txtSetClassCd.Text) = "" Then
            MsgBox "セット分類コードが入力されていません。", vbCritical, App.Title
            txtSetClassCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtSetClassName.Text) = "" Then
            MsgBox "進捗分類名が入力されていません。", vbCritical, App.Title
            txtSetClassName.SetFocus
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
Private Function EditSetClass() As Boolean

    Dim objSetClass         As Object         'セット分類アクセス用
    Dim vntSetClassName     As Variant        'セット分類名
    Dim vntSetClassSName    As Variant        'セット分類略称
    Dim vntSeq              As Variant        '表示順番
    Dim Ret                 As Boolean        '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objSetClass = CreateObject("HainsSetClass.SetClass")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrSetClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        'セット分類テーブルレコード読み込み
        If objSetClass.SelectSetClass(mstrSetClassCd, vntSetClassName) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtSetClassCd.Text = mstrSetClassCd
        txtSetClassName.Text = vntSetClassName
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditSetClass = Ret
    
    Exit Function

ErrorHandle:

    EditSetClass = False
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
Private Function RegistSetClass() As Boolean

On Error GoTo ErrorHandle

    Dim objSetClass     As Object       'セット分類アクセス用
    Dim Ret             As Long
    
    'オブジェクトのインスタンス作成
    Set objSetClass = CreateObject("HainsSetClass.SetClass")
    
    'セット分類テーブルレコードの登録
    Ret = objSetClass.RegistSetClass(IIf(txtSetClassCd.Enabled, "INS", "UPD"), _
                                     Trim(txtSetClassCd.Text), _
                                     Trim(txtSetClassName.Text))

    If Ret = 0 Then
        MsgBox "入力されたセット分類コードは既に存在します。", vbExclamation
        RegistSetClass = False
        Exit Function
    End If
    
    RegistSetClass = True
    
    Set objSetClass = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objSetClass = Nothing
    
    RegistSetClass = False
    
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
        
        'セット分類テーブルの登録
        If RegistSetClass() = False Then
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
        'セット分類情報の編集
        If EditSetClass() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtSetClassCd.Enabled = (txtSetClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

