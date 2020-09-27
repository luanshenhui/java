VERSION 5.00
Begin VB.Form frmSecondLineDiv 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "２次請求明細テーブルメンテナンス"
   ClientHeight    =   2910
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6900
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmSecondLineDiv.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2910
   ScaleWidth      =   6900
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.Frame Frame1 
      Caption         =   "基本情報"
      Height          =   2175
      Index           =   0
      Left            =   60
      TabIndex        =   8
      Top             =   120
      Width           =   6735
      Begin VB.TextBox txtStdTax 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2340
         MaxLength       =   7
         TabIndex        =   7
         Text            =   "9999999"
         Top             =   1440
         Width           =   855
      End
      Begin VB.TextBox txtStdPrice 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2340
         MaxLength       =   7
         TabIndex        =   5
         Text            =   "9999999"
         Top             =   1020
         Width           =   855
      End
      Begin VB.TextBox txtSecondLineDivName 
         Height          =   300
         IMEMode         =   4  '全角ひらがな
         Left            =   2340
         MaxLength       =   40
         TabIndex        =   3
         Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
         Top             =   600
         Width           =   4035
      End
      Begin VB.TextBox txtSecondLineDivCd 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2340
         MaxLength       =   5
         TabIndex        =   1
         Text            =   "@@"
         Top             =   240
         Width           =   795
      End
      Begin VB.Label Label1 
         Caption         =   "標準税額(&T):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   6
         Top             =   1500
         Width           =   1710
      End
      Begin VB.Label Label1 
         Caption         =   "標準単価(&P):"
         Height          =   180
         Index           =   3
         Left            =   180
         TabIndex        =   4
         Top             =   1080
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "２次請求明細名(&N):"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   2
         Top             =   660
         Width           =   1950
      End
      Begin VB.Label Label1 
         Caption         =   "２次請求明細コード(&C):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   300
         Width           =   1950
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4020
      TabIndex        =   9
      Top             =   2460
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5460
      TabIndex        =   10
      Top             =   2460
      Width           =   1335
   End
End
Attribute VB_Name = "frmSecondLineDiv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrSecondLineDivCd      As String   'セット外請求明細コード
Private mblnInitialize          As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let SecondLineDivCd(ByVal vntNewValue As Variant)

    mstrSecondLineDivCd = vntNewValue
    
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
        If Trim(txtSecondLineDivCd.Text) = "" Then
            MsgBox "２次請求明細コードが入力されていません。", vbCritical, App.Title
            txtSecondLineDivCd.SetFocus
            Exit Do
        End If

        '２次求明細名の入力チェック
        If Trim(txtSecondLineDivName.Text) = "" Then
            MsgBox "２次請求明細名が入力されていません。", vbCritical, App.Title
            txtSecondLineDivName.SetFocus
            Exit Do
        End If

        '金額情報編集
        If Trim(txtStdPrice.Text) = "" Then txtStdPrice.Text = "0"
        If Trim(txtStdTax.Text) = "" Then txtStdTax.Text = "0"

        If IsNumeric(Trim(txtStdPrice.Text)) = False Then
            MsgBox "標準金額には数値をセットしてください。", vbCritical, App.Title
            txtStdPrice.SetFocus
            Exit Do
        End If

        If IsNumeric(Trim(txtStdTax.Text)) = False Then
            MsgBox "標準金額には数値をセットしてください。", vbCritical, App.Title
            txtStdTax.SetFocus
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
Private Function EditSecondLineDiv() As Boolean

    Dim objSecondLineDiv         As Object   'セット外請求明細アクセス用
    Dim vntSecondLineDivName     As Variant  'セット外請求明細名
    Dim vntStdPrice             As Variant  '標準単価
    Dim vntStdTax               As Variant  '標準税額
    Dim Ret                     As Boolean  '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objSecondLineDiv = CreateObject("HainsSecondBill.SecondBill")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrSecondLineDivCd = "" Then
            Ret = True
            Exit Do
        End If
        
        'セット外請求明細テーブルレコード読み込み
        If objSecondLineDiv.SelectSecondLineDivFromCode(mstrSecondLineDivCd, vntSecondLineDivName, vntStdPrice, vntStdTax) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtSecondLineDivCd.Text = mstrSecondLineDivCd
        txtSecondLineDivName.Text = vntSecondLineDivName
        txtStdPrice.Text = vntStdPrice
        txtStdTax.Text = vntStdTax
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditSecondLineDiv = Ret
    
    Exit Function

ErrorHandle:

    EditSecondLineDiv = False
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
Private Function RegistSecondLineDiv() As Boolean

On Error GoTo ErrorHandle

    Dim objSecondLineDiv     As Object       'セット外請求明細アクセス用
    Dim Ret                 As Long
    Dim strWkStdTax         As String
    
    'オブジェクトのインスタンス作成
    Set objSecondLineDiv = CreateObject("HainsSecondBill.SecondBill")
    
    'セット外請求明細テーブルレコードの登録
    Ret = objSecondLineDiv.RegistSecondLineDiv(IIf(txtSecondLineDivCd.Enabled, "INS", "UPD"), _
                                             Trim(txtSecondLineDivCd.Text), _
                                             Trim(txtSecondLineDivName.Text), _
                                             Trim(txtStdPrice.Text), _
                                             Trim(txtStdTax.Text))

    If Ret = 0 Then
        MsgBox "入力されたセット外請求明細コードは既に存在します。", vbExclamation
        RegistSecondLineDiv = False
        Exit Function
    End If
    
    RegistSecondLineDiv = True
    
    Exit Function
    
ErrorHandle:

    RegistSecondLineDiv = False
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
        
        'セット外請求明細テーブルの登録
        If RegistSecondLineDiv() = False Then
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
        'セット外請求明細情報の編集
        If EditSecondLineDiv() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtSecondLineDivCd.Enabled = (txtSecondLineDivCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

