VERSION 5.00
Begin VB.Form frmRoundClassPrice 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "まるめ項目数別単価の設定"
   ClientHeight    =   2535
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6840
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRoundClassPrice.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2535
   ScaleWidth      =   6840
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.Frame Frame1 
      Caption         =   "対象となるデータ"
      Height          =   1815
      Left            =   60
      TabIndex        =   8
      Top             =   120
      Width           =   6615
      Begin VB.TextBox txtisrPrice 
         Height          =   270
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2040
         MaxLength       =   8
         TabIndex        =   7
         Text            =   "99999999"
         Top             =   1200
         Width           =   975
      End
      Begin VB.TextBox txtbsdPrice 
         Height          =   270
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2040
         MaxLength       =   8
         TabIndex        =   5
         Text            =   "99999999"
         Top             =   780
         Width           =   975
      End
      Begin VB.TextBox txtStrCount 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2040
         MaxLength       =   6
         TabIndex        =   1
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.TextBox txtEndCount 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   3000
         MaxLength       =   6
         TabIndex        =   3
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.Label Label1 
         Caption         =   "団体負担金額(&O):"
         Height          =   180
         Index           =   6
         Left            =   180
         TabIndex        =   4
         Top             =   840
         Width           =   1650
      End
      Begin VB.Label Label1 
         Caption         =   "項目数適用範囲(&A):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   420
         Width           =   1710
      End
      Begin VB.Label Label2 
         Caption         =   "～"
         Height          =   255
         Index           =   0
         Left            =   2760
         TabIndex        =   2
         Top             =   420
         Width           =   255
      End
      Begin VB.Label Label1 
         Caption         =   "健保負担金額(&K):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   6
         Top             =   1260
         Width           =   1650
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5340
      TabIndex        =   10
      Top             =   2100
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3900
      TabIndex        =   9
      Top             =   2100
      Width           =   1335
   End
End
Attribute VB_Name = "frmRoundClassPrice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrStrCount              As String           '開始項目数
Private mstrEndCount              As String           '終了項目数
Private mstrbsdPrice            As String           'まるめ分類金額管理（以上）
Private mstrisrPrice            As String           'まるめ分類金額管理（以下）

Private mblnUpdated             As Boolean          'TRUE:更新あり、FALSE:更新なし
Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション
Private mblnModeNew             As Boolean          'TRUE:新規、FALSE:更新

Private Const DefaultStrCount As String = "0"
Private Const DefaultEndCount As String = "999999"

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    '入力チェック
    If CheckValue() = False Then Exit Sub
    
    'プロパティ値の画面セット
    mstrStrCount = txtStrCount.Text
    mstrEndCount = txtEndCount.Text
    mstrbsdPrice = CLng(txtbsdPrice.Text)
    mstrisrPrice = CLng(txtisrPrice.Text)

    mblnUpdated = True
    Unload Me
    
End Sub

'
' 機能　　 : 入力データチェック
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常データ、FALSE:異常データあり
'
' 備考　　 : 「○○が入力されていません」のMSGに飽きたあなたのために勝手につっこむ俺様ロジック
'
Private Function CheckValue() As Boolean

    Dim Ret             As Boolean  '関数戻り値
    Dim strWorkResult   As String
        
    '同一コントロールのSetFocusでは文字列選択が有効にならないのでダミーでとばす
    cmdOk.SetFocus
    
    Ret = False
    
    Do
        '項目数（下）の未入力チェック（勝手につっこむ）
        If Trim(txtStrCount.Text) = "" Then
            txtStrCount.Text = DefaultStrCount
        End If
        
        '項目数（上）の入力チェック（勝手につっこむ）
        If Trim(txtEndCount.Text) = "" Then
            txtEndCount.Text = DefaultEndCount
        End If

        '項目数（下）の数値チェック
        If IsNumeric(txtStrCount.Text) = False Then
            MsgBox "項目数適用範囲には数値を入力してください。", vbExclamation, App.Title
            txtStrCount.SetFocus
            Exit Do
        End If
        
        '項目数（上）の数値チェック
        If IsNumeric(txtEndCount.Text) = False Then
            MsgBox "項目数適用範囲には数値を入力してください。", vbExclamation, App.Title
            txtEndCount.SetFocus
            Exit Do
        End If
        
        txtStrCount.Text = Abs(Trim(txtStrCount.Text))
        txtEndCount.Text = Abs(Trim(txtEndCount.Text))

        '項目数（上下）が逆のチェック
        If CDbl(txtStrCount.Text) > CDbl(txtEndCount.Text) Then
            '勝手に逆さにします。
            strWorkResult = txtEndCount.Text
            txtEndCount.Text = txtStrCount.Text
            txtStrCount.Text = strWorkResult
        End If

        '項目数（上限）に最大値としての.99を追加
'        If (CDbl(txtEndCount.Text) - Int(CDbl(txtEndCount.Text))) = 0 Then
'            If Mid(Trim(txtEndCount.Text), Len(Trim(txtEndCount.Text)), 1) = "." Then
'                txtEndCount.Text = txtEndCount.Text & "99"
'            Else
'                txtEndCount.Text = txtEndCount.Text & ".99"
'            End If
'        End If
        
        '金額未入力欄はゼロセット
        If Trim(txtbsdPrice.Text) = "" Then txtbsdPrice.Text = 0
        If Trim(txtisrPrice.Text) = "" Then txtisrPrice.Text = 0
        
        '金額の整合性チェック
        If (IsNumeric(txtbsdPrice.Text) = False) Or (IsNumeric(txtisrPrice.Text) = False) Then
            MsgBox "金額には数値を入力してください。", vbExclamation, App.Title
            txtbsdPrice.SetFocus
            Exit Do
        End If
        
        '金額のマイナスチェック
        If (CLng(txtbsdPrice.Text) < 0) Or (CLng(txtisrPrice.Text) < 0) Then
            MsgBox "金額にマイナス値を指定することはできません。", vbExclamation, App.Title
            txtbsdPrice.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

Private Sub Form_Load()

    Dim i       As Integer

    mblnUpdated = False

    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    'プロパティ値の画面セット
    txtStrCount.Text = mstrStrCount
    txtEndCount.Text = mstrEndCount
    txtbsdPrice.Text = mstrbsdPrice
    txtisrPrice.Text = mstrisrPrice
    
    '項目数がセットされていないなら、勝手にセット（大きなお世話シリーズ）
    If txtStrCount.Text = "" Then txtStrCount.Text = DefaultStrCount
    If txtEndCount.Text = "" Then txtEndCount.Text = DefaultEndCount
    
End Sub

Friend Property Get StrCount() As Variant
    
    StrCount = mstrStrCount

End Property

Friend Property Let StrCount(ByVal vNewValue As Variant)

    mstrStrCount = vNewValue

End Property

Friend Property Get EndCount() As Variant

    EndCount = mstrEndCount

End Property

Friend Property Let EndCount(ByVal vNewValue As Variant)

    mstrEndCount = vNewValue

End Property

Friend Property Get BsdPrice() As Variant

    BsdPrice = mstrbsdPrice

End Property

Friend Property Let BsdPrice(ByVal vNewValue As Variant)

    mstrbsdPrice = vNewValue

End Property

Friend Property Get IsrPrice() As Variant

    IsrPrice = mstrisrPrice

End Property

Friend Property Let IsrPrice(ByVal vNewValue As Variant)

    mstrisrPrice = vNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
