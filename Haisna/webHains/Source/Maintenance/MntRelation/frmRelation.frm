VERSION 5.00
Begin VB.Form frmRelation 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "続柄テーブルメンテナンス"
   ClientHeight    =   1365
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4380
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRelation.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1365
   ScaleWidth      =   4380
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.TextBox txtRelationName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1320
      MaxLength       =   10
      TabIndex        =   3
      Text            =   "＠＠＠＠"
      Top             =   480
      Width           =   2235
   End
   Begin VB.TextBox txtRelationCd 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1320
      MaxLength       =   2
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1440
      TabIndex        =   4
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   2880
      TabIndex        =   5
      Top             =   960
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "続柄名(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "続柄コード(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmRelation"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrRelationCd As String   '続柄コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let RelationCd(ByVal vntNewValue As Variant)

    mstrRelationCd = vntNewValue
    
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
        If Trim(txtRelationCd.Text) = "" Then
            MsgBox "続柄コードが入力されていません。", vbCritical, App.Title
            txtRelationCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtRelationName.Text) = "" Then
            MsgBox "続柄名が入力されていません。", vbCritical, App.Title
            txtRelationName.SetFocus
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
Private Function EditRelation() As Boolean

    Dim objRelation        As Object           '続柄アクセス用
    Dim vntRelationName    As Variant          '続柄名
    Dim Ret                 As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objRelation = CreateObject("HainsPerson.Person")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrRelationCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '続柄テーブルレコード読み込み
        If objRelation.SelectRelation(mstrRelationCd, vntRelationName) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtRelationCd.Text = mstrRelationCd
        txtRelationName.Text = vntRelationName
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditRelation = Ret
    
    Exit Function

ErrorHandle:

    EditRelation = False
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
Private Function RegistRelation() As Boolean

    Dim objRelation    As Object       '続柄アクセス用
    Dim Ret             As Long
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objRelation = CreateObject("HainsPerson.Person")
    
    '続柄テーブルレコードの登録
    Ret = objRelation.RegistRelation(IIf(txtRelationCd.Enabled, "INS", "UPD"), Trim(txtRelationCd.Text), Trim(txtRelationName.Text))
    If Ret = 0 Then
        MsgBox "入力された続柄コードは既に存在します。", vbExclamation
        RegistRelation = False
        Exit Function
    End If
    
    RegistRelation = True
    
    Exit Function
    
ErrorHandle:

    RegistRelation = False
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
        
        '続柄テーブルの登録
        If RegistRelation() = False Then
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
        '続柄情報の編集
        If EditRelation() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtRelationCd.Enabled = (txtRelationCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub
