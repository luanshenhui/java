VERSION 5.00
Begin VB.Form frmMailTemplate 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "メールテンプレートテーブルメンテナンス"
   ClientHeight    =   9225
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   10350
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMailTemplate.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   9225
   ScaleWidth      =   10350
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.TextBox txtTemplateCd 
      BeginProperty Font 
         Name            =   "ＭＳ ゴシック"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1020
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.TextBox txtSubject 
      BeginProperty Font 
         Name            =   "ＭＳ ゴシック"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1020
      MaxLength       =   50
      TabIndex        =   5
      Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
      Top             =   840
      Width           =   9195
   End
   Begin VB.TextBox txtBody 
      BeginProperty Font 
         Name            =   "ＭＳ ゴシック"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   7500
      IMEMode         =   4  '全角ひらがな
      Left            =   1020
      MultiLine       =   -1  'True
      ScrollBars      =   2  '垂直
      TabIndex        =   7
      Top             =   1200
      Width           =   9195
   End
   Begin VB.TextBox txtTemplateName 
      BeginProperty Font 
         Name            =   "ＭＳ ゴシック"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1020
      MaxLength       =   10
      TabIndex        =   3
      Text            =   "＠＠＠＠＠＠＠＠＠＠"
      Top             =   480
      Width           =   1995
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   7530
      TabIndex        =   9
      Top             =   8790
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   6150
      TabIndex        =   8
      Top             =   8790
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(&A)"
      Height          =   315
      Left            =   8910
      TabIndex        =   10
      Top             =   8790
      Width           =   1275
   End
   Begin VB.Label Label1 
      Caption         =   "コード(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   750
   End
   Begin VB.Label Label1 
      Caption         =   "表題(&S):"
      Height          =   180
      Index           =   3
      Left            =   120
      TabIndex        =   4
      Top             =   900
      Width           =   750
   End
   Begin VB.Label Label1 
      Caption         =   "本文(&B):"
      Height          =   180
      Index           =   4
      Left            =   120
      TabIndex        =   6
      Top             =   1260
      Width           =   750
   End
   Begin VB.Label Label1 
      Caption         =   "名称(&N):"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   750
   End
End
Attribute VB_Name = "frmMailTemplate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.4
'担当者  ：T.Takagi@RD
'修正内容：新規作成

Option Explicit

'プロパティ用領域
Private mstrTemplateCd  As String   'テンプレートコード
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly    As Boolean  'TRUE:データの更新をしない（参照のみ）
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗

'モジュール固有領域領域
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property

' @(e)
'
' 機能　　 : 「適用」クリック
'
' 引数　　 : なし
'
' 機能説明 : 入力内容を適用する。画面は閉じない
'
' 備考　　 :
'
Private Sub cmdApply_Click()
    
    'データ適用処理を行う
    Call ApplyData

End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : フォームコントロールの初期化
'
' 機能説明 : コントロールを初期状態に変更する。
'
' 備考　　 :
'
Private Sub InitializeForm()

    Dim objTxtGotFocus  As TextGotFocus
    Dim i               As Long
    
    Call InitFormControls(Me, mcolGotFocusCollection)      '使用コントロール初期化
    
    'メール本文へのフォーカス時に選択状態になるのを回避するため、インスタンスを解放
    Set mcolGotFocusCollection = Nothing
    
    Set mcolGotFocusCollection = New Collection
    
    Set objTxtGotFocus = New TextGotFocus
    objTxtGotFocus.TargetTextBox = txtTemplateCd
    mcolGotFocusCollection.Add objTxtGotFocus
    
    Set objTxtGotFocus = New TextGotFocus
    objTxtGotFocus.TargetTextBox = txtTemplateName
    mcolGotFocusCollection.Add objTxtGotFocus
    
    Set objTxtGotFocus = New TextGotFocus
    objTxtGotFocus.TargetTextBox = txtSubject
    mcolGotFocusCollection.Add objTxtGotFocus
    
End Sub

' @(e)
'
' 機能　　 : メールテンプレート情報画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : メールテンプレート情報を画面に表示する
'
' 備考　　 :
'
Private Function EditMailTemplate() As Boolean

    Dim objMailTemplate As Object   'メールテンプレート情報アクセス用
    
    Dim vntTemplateName As Variant  'テンプレート名
    Dim vntSubject      As Variant  '表題
    Dim vntBody         As Variant  '本文

    Dim Ret             As Boolean  '戻り値
    
    EditMailTemplate = False
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objMailTemplate = CreateObject("HainsMail.Template")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrTemplateCd = "" Then
            Ret = True
            Exit Do
        End If
        
        'メールテンプレートテーブル読み込み
        If objMailTemplate.SelectMailTemplate(mstrTemplateCd, vntTemplateName, vntSubject, vntBody) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If

        '読み込み内容の編集
        txtTemplateCd.Text = mstrTemplateCd
        txtTemplateName.Text = vntTemplateName
        txtSubject.Text = vntSubject
        txtBody.Text = vntBody

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditMailTemplate = Ret
    
    Exit Function

ErrorHandle:

    EditMailTemplate = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : データの保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 変更されたデータをテーブルに保存する
'
' 備考　　 :
'
Private Function ApplyData() As Boolean

    ApplyData = False
    
    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then Exit Function
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    Do
        '入力チェック
        If CheckValue() = False Then Exit Do
        
        'メールテンプレートテーブルの登録
        If RegistMailTemplate() = False Then Exit Do
        
        '更新済みにする
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    

End Function

' @(e)
'
' 機能　　 : 登録データのチェック
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容の妥当性をチェックする
'
' 備考　　 :
'
Private Function CheckValue() As Boolean

    Dim Ret As Boolean  '関数戻り値
    
    '初期処理
    Ret = False
    
    Do
        
        If Trim(txtTemplateCd.Text) = "" Then
            MsgBox "コードが入力されていません。", vbExclamation, App.Title
            txtTemplateCd.SetFocus
            Exit Do
        End If

        If Trim(txtTemplateName.Text) = "" Then
            MsgBox "名称が入力されていません。", vbExclamation, App.Title
            txtTemplateName.SetFocus
            Exit Do
        End If
        
        If Trim(txtSubject.Text) = "" Then
            MsgBox "表題が入力されていません。", vbExclamation, App.Title
            txtSubject.SetFocus
            Exit Do
        End If
        
        If txtBody.Text = "" Then
            MsgBox "本文が入力されていません。", vbExclamation, App.Title
            txtBody.SetFocus
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
' 機能　　 : メールテンプレート情報の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容をメールテンプレートテーブルに保存する。
'
' 備考　　 :
'
Private Function RegistMailTemplate() As Boolean

    Dim objMailTemplate As Object   'メールテンプレート情報アクセス用
    Dim lngRet          As Long     '関数戻り値
    
    On Error GoTo ErrorHandle

    RegistMailTemplate = False

    'オブジェクトのインスタンス作成
    Set objMailTemplate = CreateObject("HainsMail.Template")

    'メールテンプレートテーブルレコードの登録
    lngRet = objMailTemplate.RegistMailTemplate(IIf(txtTemplateCd.Enabled, "INS", "UPD"), Trim(txtTemplateCd.Text), Trim(txtTemplateName.Text), Trim(txtSubject.Text), txtBody.Text)

    If lngRet = INSERT_DUPLICATE Then
        MsgBox "入力されたコードは既に存在します。", vbExclamation
        RegistMailTemplate = False
        Exit Function
    End If
    
    If lngRet = INSERT_ERROR Then
        MsgBox "テーブル更新時にエラーが発生しました。", vbCritical
        RegistMailTemplate = False
        Exit Function
    End If
    
    mstrTemplateCd = Trim(txtTemplateCd.Text)
    txtTemplateCd.Enabled = (txtTemplateCd.Text = "")
    
    RegistMailTemplate = True
    
    Exit Function
    
ErrorHandle:

    RegistMailTemplate = False
    
    MsgBox Err.Description, vbCritical
    
End Function

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
    
    'データ適用処理を行う（エラー時は画面を閉じない）
    If ApplyData() = False Then
        Exit Sub
    End If

    '画面を閉じる
    Unload Me
    
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
    Call InitializeForm

    Do
        
        'メールテンプレート情報の表示編集
        If EditMailTemplate() = False Then
            Exit Do
        End If
        
        'イネーブル設定
        txtTemplateCd.Enabled = (txtTemplateCd.Text = "")
        
        Ret = True
        Exit Do
    
    Loop
    
    '参照専用の場合、登録系コントロールを止める
    If mblnShowOnly = True Then
        
        txtTemplateCd.Enabled = False
        txtTemplateName.Enabled = False
        txtSubject.Enabled = False
        txtBody.Enabled = False
    
        cmdOk.Enabled = False
        cmdApply.Enabled = False
    
    End If
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Friend Property Get TemplateCd() As Variant

    TemplateCd = mstrTemplateCd
    
End Property

Friend Property Let TemplateCd(ByVal vNewValue As Variant)
    
    mstrTemplateCd = vNewValue

End Property

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property

Private Sub txtBody_GotFocus()

    cmdOk.Default = False
    
End Sub

Private Sub txtBody_LostFocus()

    cmdOk.Default = True

End Sub

