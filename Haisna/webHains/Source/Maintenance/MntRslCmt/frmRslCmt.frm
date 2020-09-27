VERSION 5.00
Begin VB.Form frmRslCmt 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "結果コメントテーブルメンテナンス"
   ClientHeight    =   1830
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5805
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRslCmt.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1830
   ScaleWidth      =   5805
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CheckBox chkEntryOk 
      Caption         =   "このコメントがセットされた結果は入力完了とする(&F)"
      Height          =   255
      Left            =   1680
      TabIndex        =   6
      Top             =   900
      Width           =   4035
   End
   Begin VB.TextBox txtRslCmtName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   30
      TabIndex        =   3
      Text            =   "＠＠＠＠"
      Top             =   480
      Width           =   4035
   End
   Begin VB.TextBox txtRslCmtCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2940
      TabIndex        =   4
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4380
      TabIndex        =   5
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "結果コメント名(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "結果コメントコード(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmRslCmt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrRslCmtCd    As String   '結果コメントコード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let RslCmtCd(ByVal vntNewValue As Variant)

    mstrRslCmtCd = vntNewValue
    
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
        If Trim(txtRslCmtCd.Text) = "" Then
            MsgBox "結果コメントコードが入力されていません。", vbCritical, App.Title
            txtRslCmtCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtRslCmtName.Text) = "" Then
            MsgBox "結果コメント名が入力されていません。", vbCritical, App.Title
            txtRslCmtName.SetFocus
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
Private Function EditRslCmt() As Boolean

    Dim objRslCmt       As Object           '結果コメントアクセス用
    Dim vntRslCmtName   As Variant          '結果コメント名
    Dim vntEntryOk      As Variant          '入力完了フラグ
    Dim Ret             As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objRslCmt = CreateObject("HainsRslCmt.RslCmt")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrRslCmtCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '結果コメントテーブルレコード読み込み
        If objRslCmt.SelectRslCmt(mstrRslCmtCd, vntRslCmtName, vntEntryOk) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtRslCmtCd.Text = mstrRslCmtCd
        txtRslCmtName.Text = vntRslCmtName
        If vntEntryOk = "1" Then
            chkEntryOk.Value = vbChecked
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditRslCmt = Ret
    
    Exit Function

ErrorHandle:

    EditRslCmt = False
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
Private Function RegistRslCmt() As Boolean

On Error GoTo ErrorHandle

    Dim objRslCmt   As Object       '結果コメントアクセス用
    Dim Ret         As Long
    
    'オブジェクトのインスタンス作成
    Set objRslCmt = CreateObject("HainsRslCmt.RslCmt")
    
    '結果コメントテーブルレコードの登録
    Ret = objRslCmt.RegistRslCmt(IIf(txtRslCmtCd.Enabled, "INS", "UPD"), _
                                 Trim(txtRslCmtCd.Text), _
                                 Trim(txtRslCmtName.Text), _
                                 IIf(chkEntryOk.Value = vbChecked, 1, 0))

    If Ret = 0 Then
        MsgBox "入力された結果コメントコードは既に存在します。", vbExclamation
        RegistRslCmt = False
        Exit Function
    End If
    
    RegistRslCmt = True
    
    Exit Function
    
ErrorHandle:

    RegistRslCmt = False
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
        
        '結果コメントテーブルの登録
        If RegistRslCmt() = False Then
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
        '結果コメント情報の編集
        If EditRslCmt() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtRslCmtCd.Enabled = (txtRslCmtCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

