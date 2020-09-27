VERSION 5.00
Begin VB.Form frmNutriCompFood 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "構成食品テーブルメンテナンス"
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6480
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmNutriCompFood.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2265
   ScaleWidth      =   6480
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboFoodClassCd 
      Height          =   300
      Left            =   2100
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   5
      Top             =   900
      Width           =   3315
   End
   Begin VB.TextBox txtComposeFoodName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   2100
      MaxLength       =   100
      TabIndex        =   3
      Text            =   "＠＠＠＠＠＠＠＠＠＠"
      Top             =   540
      Width           =   4215
   End
   Begin VB.TextBox txtComposeFoodCd 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   2100
      MaxLength       =   5
      TabIndex        =   1
      Text            =   "99999"
      Top             =   180
      Width           =   855
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3540
      TabIndex        =   6
      Top             =   1800
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4980
      TabIndex        =   7
      Top             =   1800
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "食品分類(&B)："
      Height          =   180
      Index           =   2
      Left            =   300
      TabIndex        =   4
      Top             =   960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "構成食品名(&N)："
      Height          =   180
      Index           =   1
      Left            =   300
      TabIndex        =   2
      Top             =   600
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "構成食品コード(&C)："
      Height          =   180
      Index           =   0
      Left            =   300
      TabIndex        =   0
      Top             =   240
      Width           =   1650
   End
End
Attribute VB_Name = "frmNutriCompFood"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrComposeFoodCd  As String   '構成食品コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let ComposeFoodCd(ByVal vntNewValue As Variant)

    mstrComposeFoodCd = vntNewValue
    
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
        If Trim(txtComposeFoodCd.Text) = "" Then
            MsgBox "構成食品コードが入力されていません。", vbCritical, App.Title
            txtComposeFoodCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtComposeFoodName.Text) = "" Then
            MsgBox "構成食品名が入力されていません。", vbCritical, App.Title
            txtComposeFoodName.SetFocus
            Exit Do
        End If
        
        '名称の入力チェック
        If LenB(Trim(txtComposeFoodName.Text)) > 50 Then
            MsgBox "構成食品名が長すぎます", vbCritical, App.Title
            txtComposeFoodName.SetFocus
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
Private Function EditNutriCompFood() As Boolean

    Dim objNutriCompFood        As Object         '構成食品アクセス用
    Dim vntComposeFoodName      As Variant        '構成食品名
    Dim vntFoodClassCd          As Variant        '構成食品略称
    Dim Ret                     As Boolean        '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objNutriCompFood = CreateObject("HainsNourishment.Nourishment")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrComposeFoodCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '構成食品テーブルレコード読み込み
        If objNutriCompFood.SelectNutriCompFood(mstrComposeFoodCd, , vntComposeFoodName, vntFoodClassCd) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtComposeFoodCd.Text = mstrComposeFoodCd
        txtComposeFoodName.Text = vntComposeFoodName(0)
        cboFoodClassCd.ListIndex = CInt(vntFoodClassCd(0)) - 1
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditNutriCompFood = Ret
    
    Exit Function

ErrorHandle:

    EditNutriCompFood = False
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
Private Function RegistNutriCompFood() As Boolean

On Error GoTo ErrorHandle

    Dim objNutriCompFood     As Object       '構成食品アクセス用
    Dim Ret                  As Long
    
    'オブジェクトのインスタンス作成
    Set objNutriCompFood = CreateObject("HainsNourishment.Nourishment")
    
    '構成食品テーブルレコードの登録
    Ret = objNutriCompFood.RegistNutriCompFood(IIf(txtComposeFoodCd.Enabled, "INS", "UPD"), _
                                     Trim(txtComposeFoodCd.Text), _
                                     Trim(txtComposeFoodName.Text), _
                                     cboFoodClassCd.ListIndex + 1)

    If Ret = 0 Then
        MsgBox "入力された構成食品コードは既に存在します。", vbExclamation
        RegistNutriCompFood = False
        Exit Function
    End If
    
    RegistNutriCompFood = True
    
    Set objNutriCompFood = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objNutriCompFood = Nothing
    
    RegistNutriCompFood = False
    
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
        
        '構成食品テーブルの登録
        If RegistNutriCompFood() = False Then
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

    With cboFoodClassCd
        .Clear
        .AddItem "1：穀類および芋類"
        .AddItem "2：果物"
        .AddItem "3：魚介・肉・卵・大豆製品"
        .AddItem "4：乳製品"
        .AddItem "5：油脂・多脂性食品"
        .AddItem "6：野菜"
        .AddItem "7：嗜好品（菓子類）"
        .AddItem "8：その他"
        .AddItem "9：嗜好品（アルコール）"
    End With

    Do
        '構成食品情報の編集
        If EditNutriCompFood() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtComposeFoodCd.Enabled = (txtComposeFoodCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

