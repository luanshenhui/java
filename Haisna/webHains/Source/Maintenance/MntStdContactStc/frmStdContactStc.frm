VERSION 5.00
Begin VB.Form frmStdContactStc 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "定型面接文章テーブルメンテナンス"
   ClientHeight    =   2085
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6960
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmStdContactStc.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2085
   ScaleWidth      =   6960
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboGuidanceDiv 
      Height          =   300
      ItemData        =   "frmStdContactStc.frx":000C
      Left            =   1920
      List            =   "frmStdContactStc.frx":002E
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   1
      Top             =   240
      Width           =   4110
   End
   Begin VB.TextBox txtContactStc 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1920
      MaxLength       =   25
      TabIndex        =   5
      Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
      Top             =   960
      Width           =   4755
   End
   Begin VB.TextBox txtStdContactStcCd 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1920
      MaxLength       =   4
      TabIndex        =   3
      Text            =   "@@@@"
      Top             =   600
      Width           =   555
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3960
      TabIndex        =   6
      Top             =   1620
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5400
      TabIndex        =   7
      Top             =   1620
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "指導内容区分(&D):"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   0
      Top             =   300
      Width           =   1950
   End
   Begin VB.Label Label1 
      Caption         =   "面接文章(&N):"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   4
      Top             =   1020
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "定型面接文章コード(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   2
      Top             =   660
      Width           =   1950
   End
End
Attribute VB_Name = "frmStdContactStc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrGuidanceDiv         As String   '指導内容区分
Private mstrStdContactStcCd     As String   '定型面接文章コード
Private mblnInitialize          As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let GuidanceDiv(ByVal vntNewValue As Variant)

    mstrGuidanceDiv = vntNewValue
    
End Property

Friend Property Let StdContactStcCd(ByVal vntNewValue As Variant)

    mstrStdContactStcCd = vntNewValue
    
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
        If Trim(txtStdContactStcCd.Text) = "" Then
            MsgBox "定型面接文章コードが入力されていません。", vbCritical, App.Title
            txtStdContactStcCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtContactStc.Text) = "" Then
            MsgBox "定型面接文章名が入力されていません。", vbCritical, App.Title
            txtContactStc.SetFocus
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
Private Function EditStdContactStc() As Boolean

    Dim objStdContactStc        As Object           '定型面接文章アクセス用
    Dim vntContactStc           As Variant          '定型面接文章名
    Dim Ret                     As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objStdContactStc = CreateObject("HainsStdContactStc.StdContactStc")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If (mstrStdContactStcCd = "") Or (IsNumeric(mstrGuidanceDiv) = False) Then
            Ret = True
            Exit Do
        End If
        
        '定型面接文章テーブルレコード読み込み
        If objStdContactStc.SelectStdContactStc(CInt(mstrGuidanceDiv), mstrStdContactStcCd, vntContactStc) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        cboGuidanceDiv.ListIndex = CInt(mstrGuidanceDiv) - 1
        txtStdContactStcCd.Text = mstrStdContactStcCd
        txtContactStc.Text = vntContactStc
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditStdContactStc = Ret
    
    Exit Function

ErrorHandle:

    EditStdContactStc = False
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
Private Function RegistStdContactStc() As Boolean

    Dim objStdContactStc    As Object       '定型面接文章アクセス用
    Dim Ret             As Long
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objStdContactStc = CreateObject("HainsStdContactStc.StdContactStc")
    
    '定型面接文章テーブルレコードの登録
    Ret = objStdContactStc.RegistStdContactStc(IIf(txtStdContactStcCd.Enabled, "INS", "UPD"), _
                                               cboGuidanceDiv.ListIndex + 1, _
                                               Trim(txtStdContactStcCd.Text), _
                                               Trim(txtContactStc.Text))
    If Ret = 0 Then
        MsgBox "入力された定型面接文章コードは既に存在します。", vbExclamation
        RegistStdContactStc = False
        Exit Function
    End If
    
    RegistStdContactStc = True
    
    Exit Function
    
ErrorHandle:

    RegistStdContactStc = False
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
        
        '定型面接文章テーブルの登録
        If RegistStdContactStc() = False Then
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

    cboGuidanceDiv.Clear
    cboGuidanceDiv.AddItem "所見の説明"
    cboGuidanceDiv.AddItem "生活・食事指導"
    cboGuidanceDiv.AddItem "経過追跡"
    cboGuidanceDiv.AddItem "要精密検査"
    cboGuidanceDiv.AddItem "要治療"
    cboGuidanceDiv.AddItem "受診のすすめ"
    cboGuidanceDiv.AddItem "運動指導"
    cboGuidanceDiv.AddItem "心理相談"
    cboGuidanceDiv.ListIndex = 0

    Do
        '定型面接文章情報の編集
        If EditStdContactStc() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        cboGuidanceDiv.Enabled = (txtStdContactStcCd.Text = "")
        txtStdContactStcCd.Enabled = (txtStdContactStcCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub
