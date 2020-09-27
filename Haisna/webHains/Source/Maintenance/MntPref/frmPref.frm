VERSION 5.00
Begin VB.Form frmPref 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "都道府県テーブルメンテナンス"
   ClientHeight    =   1380
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5100
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmPref.frx":0000
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1380
   ScaleWidth      =   5100
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.TextBox txtPrefName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   3
      Text            =   "＠＠＠＠"
      Top             =   480
      Width           =   855
   End
   Begin VB.TextBox txtPrefCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   2
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   375
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2220
      TabIndex        =   4
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3660
      TabIndex        =   5
      Top             =   960
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "都道府県名(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "都道府県コード(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmPref"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrPrefCd      As String   '都道府県コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Friend Property Let PrefCd(ByVal vntNewValue As Variant)

    mstrPrefCd = vntNewValue
    
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
        If Trim(txtPrefCd.Text) = "" Then
            MsgBox "都道府県コードが入力されていません。", vbCritical, App.Title
            txtPrefCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtPrefName.Text) = "" Then
            MsgBox "都道府県名が入力されていません。", vbCritical, App.Title
            txtPrefName.SetFocus
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
Private Function EditPref() As Boolean

    Dim objPref     As Object           '都道府県アクセス用
    Dim vntPrefName As Variant          '都道府県名
    Dim Ret         As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objPref = CreateObject("HainsPref.Pref")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrPrefCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '都道府県テーブルレコード読み込み
        If objPref.SelectPref(mstrPrefCd, vntPrefName) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtPrefCd.Text = mstrPrefCd
        txtPrefName.Text = vntPrefName
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditPref = Ret
    
    Exit Function

ErrorHandle:

    EditPref = False
    
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
Private Function RegistPref() As Boolean

    Dim objPref As Object       '都道府県アクセス用
    Dim Ret     As Long
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objPref = CreateObject("HainsPref.Pref")
    
    '都道府県テーブルレコードの登録
    Ret = objPref.RegistPref(IIf(txtPrefCd.Enabled, "INS", "UPD"), Trim(txtPrefCd.Text), Trim(txtPrefName.Text))
    If Ret = 0 Then
        MsgBox "入力された都道府県コードは既に存在します。", vbExclamation
        RegistPref = False
        Exit Function
    End If
    
    RegistPref = True
    
    Exit Function
    
ErrorHandle:

    RegistPref = False
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
        
        '都道府県テーブルの登録
        If RegistPref() = False Then
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
    txtPrefCd.Text = ""
    txtPrefName.Text = ""

    Do
        '都道府県情報の編集
        If EditPref() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtPrefCd.Enabled = (txtPrefCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub
