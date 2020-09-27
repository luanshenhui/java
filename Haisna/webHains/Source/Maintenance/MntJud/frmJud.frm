VERSION 5.00
Begin VB.Form frmJud 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "判定テーブルメンテナンス"
   ClientHeight    =   4305
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7170
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmJud.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4305
   ScaleWidth      =   7170
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.Frame Frame1 
      Caption         =   "政府管掌"
      Height          =   1275
      Index           =   1
      Left            =   120
      TabIndex        =   15
      Top             =   2400
      Visible         =   0   'False
      Width           =   6915
      Begin VB.TextBox txtGovMngJudName 
         Height          =   300
         IMEMode         =   4  '全角ひらがな
         Left            =   1860
         MaxLength       =   30
         TabIndex        =   11
         Text            =   "＠＠＠＠"
         Top             =   660
         Width           =   4875
      End
      Begin VB.TextBox txtGovMngjud 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1860
         MaxLength       =   2
         TabIndex        =   9
         Text            =   "@@"
         Top             =   300
         Width           =   375
      End
      Begin VB.Label Label1 
         Caption         =   "政府管掌用名(&K)"
         Height          =   180
         Index           =   5
         Left            =   180
         TabIndex        =   10
         Top             =   720
         Width           =   1590
      End
      Begin VB.Label Label1 
         Caption         =   "政府管掌用コード(&G)"
         Height          =   180
         Index           =   4
         Left            =   180
         TabIndex        =   8
         Top             =   360
         Width           =   1770
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "基本情報"
      Height          =   2115
      Index           =   0
      Left            =   120
      TabIndex        =   14
      Top             =   180
      Width           =   6915
      Begin VB.TextBox txtWeight 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1860
         MaxLength       =   2
         TabIndex        =   7
         Text            =   "@@"
         Top             =   1380
         Width           =   375
      End
      Begin VB.TextBox txtJudRName 
         Height          =   300
         IMEMode         =   4  '全角ひらがな
         Left            =   1860
         MaxLength       =   30
         TabIndex        =   5
         Text            =   "＠＠＠＠"
         Top             =   960
         Width           =   4875
      End
      Begin VB.TextBox txtJudCd 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1860
         MaxLength       =   2
         TabIndex        =   1
         Text            =   "@@"
         Top             =   240
         Width           =   375
      End
      Begin VB.TextBox txtJudSName 
         Height          =   300
         IMEMode         =   4  '全角ひらがな
         Left            =   1860
         MaxLength       =   6
         TabIndex        =   3
         Text            =   "＠＠＠＠"
         Top             =   600
         Width           =   1215
      End
      Begin VB.Label Label2 
         Caption         =   "※設定した数字が大きい程、異常判定の度合いが高くなります。"
         Height          =   255
         Left            =   1860
         TabIndex        =   16
         Top             =   1740
         Width           =   4635
      End
      Begin VB.Label Label1 
         Caption         =   "判定用重み(&W)"
         Height          =   180
         Index           =   3
         Left            =   180
         TabIndex        =   6
         Top             =   1440
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "報告書用判定名(&R)"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   4
         Top             =   1020
         Width           =   1590
      End
      Begin VB.Label Label1 
         Caption         =   "判定コード(&C)"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   300
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "判定略称(&N)"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   2
         Top             =   660
         Width           =   1410
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4260
      TabIndex        =   12
      Top             =   3840
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5700
      TabIndex        =   13
      Top             =   3840
      Width           =   1335
   End
End
Attribute VB_Name = "frmJud"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrJudCd       As String   '判定コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let JudCd(ByVal vntNewValue As Variant)

    mstrJudCd = vntNewValue
    
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
        If Trim(txtJudCd.Text) = "" Then
            MsgBox "判定コードが入力されていません。", vbCritical, App.Title
            txtJudCd.SetFocus
            Exit Do
        End If

        '略称の入力チェック
        If Trim(txtJudSName.Text) = "" Then
            MsgBox "判定略称が入力されていません。", vbCritical, App.Title
            txtJudSName.SetFocus
            Exit Do
        End If

        '報告書用判定名の入力チェック
        If Trim(txtJudRName.Text) = "" Then
            MsgBox "報告書用判定名が入力されていません。", vbCritical, App.Title
            txtJudRName.SetFocus
            Exit Do
        End If

        '重みの入力チェック
        If Trim(txtWeight.Text) = "" Then
            MsgBox "判定用重みが入力されていません。", vbCritical, App.Title
            txtWeight.SetFocus
            Exit Do
        End If
        
        '重みの入力チェック
        If IsNumeric(Trim(txtWeight.Text)) = False Then
            MsgBox "判定用重みには数値を入力してください。", vbCritical, App.Title
            txtWeight.SetFocus
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
Private Function EditJud() As Boolean

    Dim objJud              As Object   '判定アクセス用
    Dim vntJudSName         As Variant  '判定略称
    Dim vntJudRName         As Variant  '報告書用判定名
    Dim vntWeight           As Variant  '判定用重み
    Dim vntGovMngJud        As Variant  '政府管掌用コード
    Dim vntGovMngJudName    As Variant  '政府管掌用名称
    Dim Ret                 As Boolean  '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objJud = CreateObject("HainsJud.Jud")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrJudCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '判定テーブルレコード読み込み
        If objJud.SelectJud(mstrJudCd, vntJudSName, vntJudRName, vntWeight, vntGovMngJud, vntGovMngJudName) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtJudCd.Text = mstrJudCd
        txtJudSName.Text = vntJudSName
        txtJudRName.Text = vntJudRName
        txtWeight.Text = vntWeight
        txtGovMngjud.Text = vntGovMngJud
        txtGovMngJudName.Text = vntGovMngJudName
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditJud = Ret
    
    Exit Function

ErrorHandle:

    EditJud = False
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
Private Function RegistJud() As Boolean

On Error GoTo ErrorHandle

    Dim objJud   As Object       '判定アクセス用
    Dim Ret         As Long
    
    'オブジェクトのインスタンス作成
    Set objJud = CreateObject("HainsJud.Jud")
    
    '判定テーブルレコードの登録
    Ret = objJud.RegistJud(IIf(txtJudCd.Enabled, "INS", "UPD"), _
                           Trim(txtJudCd.Text), _
                           Trim(txtJudSName.Text), _
                           Trim(txtJudRName.Text), _
                           Trim(txtWeight.Text), _
                           Trim(txtGovMngjud.Text), _
                           Trim(txtGovMngJudName.Text))

    If Ret = 0 Then
        MsgBox "入力された判定コードは既に存在します。", vbExclamation
        RegistJud = False
        Exit Function
    End If
    
    RegistJud = True
    
    Exit Function
    
ErrorHandle:

    RegistJud = False
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
        
        '判定テーブルの登録
        If RegistJud() = False Then
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

    Do
        '判定情報の編集
        If EditJud() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtJudCd.Enabled = (txtJudCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub Text3_Change()

End Sub


