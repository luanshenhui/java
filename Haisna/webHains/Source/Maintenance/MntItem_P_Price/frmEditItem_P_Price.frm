VERSION 5.00
Begin VB.Form frmEditItem_P_Price 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "依頼項目単価の設定"
   ClientHeight    =   2985
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
   Icon            =   "frmEditItem_P_Price.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2985
   ScaleWidth      =   6840
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.Frame Frame1 
      Caption         =   "対象となるデータ"
      Height          =   1815
      Left            =   120
      TabIndex        =   9
      Top             =   600
      Width           =   6615
      Begin VB.TextBox txtisrPrice 
         Height          =   270
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1800
         MaxLength       =   7
         TabIndex        =   6
         Text            =   "99999999"
         Top             =   1200
         Width           =   975
      End
      Begin VB.TextBox txtbsdPrice 
         Height          =   270
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1800
         MaxLength       =   7
         TabIndex        =   4
         Text            =   "99999999"
         Top             =   780
         Width           =   975
      End
      Begin VB.TextBox txtStrAge 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1800
         MaxLength       =   6
         TabIndex        =   1
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.TextBox txtEndAge 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2760
         MaxLength       =   6
         TabIndex        =   2
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.Label Label1 
         Caption         =   "団体負担金額(&O):"
         Height          =   180
         Index           =   6
         Left            =   180
         TabIndex        =   3
         Top             =   840
         Width           =   1650
      End
      Begin VB.Label Label1 
         Caption         =   "年齢適用範囲(&A):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   420
         Width           =   1470
      End
      Begin VB.Label Label2 
         Caption         =   "～"
         Height          =   255
         Index           =   0
         Left            =   2520
         TabIndex        =   10
         Top             =   420
         Width           =   255
      End
      Begin VB.Label Label1 
         Caption         =   "健保負担金額(&K):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   5
         Top             =   1260
         Width           =   1650
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5400
      TabIndex        =   8
      Top             =   2580
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3960
      TabIndex        =   7
      Top             =   2580
      Width           =   1335
   End
   Begin VB.Label lblMode 
      Caption         =   "健保ありデータ設定"
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   195
      Left            =   180
      TabIndex        =   11
      Top             =   180
      Width           =   6075
   End
End
Attribute VB_Name = "frmEditItem_P_Price"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mintExistsIsr           As Integer          '健保有無区分
Private mstrStrAge              As String           '開始年齢
Private mstrEndAge              As String           '終了年齢
Private mstrbsdPrice            As String           '依頼項目単価（以上）
Private mstrisrPrice            As String           '依頼項目単価（以下）

Private mblnUpdated             As Boolean          'TRUE:更新あり、FALSE:更新なし
Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション
Private mblnModeNew             As Boolean          'TRUE:新規、FALSE:更新

Private Const DefaultStrAge As String = "0"
Private Const DefaultEndAge As String = "999.99"

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    '入力チェック
    If CheckValue() = False Then Exit Sub
    
    'プロパティ値の画面セット
    mstrStrAge = txtStrAge.Text
    mstrEndAge = txtEndAge.Text
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
        '年齢（下）の未入力チェック（勝手につっこむ）
        If Trim(txtStrAge.Text) = "" Then
            txtStrAge.Text = DefaultStrAge
        End If
        
        '年齢（上）の入力チェック（勝手につっこむ）
        If Trim(txtEndAge.Text) = "" Then
            txtEndAge.Text = DefaultEndAge
        End If

        '年齢（下）の数値チェック
        If IsNumeric(txtStrAge.Text) = False Then
            MsgBox "年齢適用範囲には数値を入力してください。", vbExclamation, App.Title
            txtStrAge.SetFocus
            Exit Do
        End If
        
        '年齢（上）の数値チェック
        If IsNumeric(txtEndAge.Text) = False Then
            MsgBox "年齢適用範囲には数値を入力してください。", vbExclamation, App.Title
            txtEndAge.SetFocus
            Exit Do
        End If
        
        txtStrAge.Text = Abs(Trim(txtStrAge.Text))
        txtEndAge.Text = Abs(Trim(txtEndAge.Text))

        '年齢（上下）が逆のチェック
        If CDbl(txtStrAge.Text) > CDbl(txtEndAge.Text) Then
            '勝手に逆さにします。
            strWorkResult = txtEndAge.Text
            txtEndAge.Text = txtStrAge.Text
            txtStrAge.Text = strWorkResult
        End If

        '年齢の上下限チェック
        If CDbl(txtStrAge.Text) < 0 Then
            MsgBox "年齢の下限は0です。", vbExclamation, App.Title
            txtStrAge.SetFocus
            Exit Do
        End If
        
        If CDbl(txtEndAge.Text) > 999.99 Then
            MsgBox "年齢の上限は999.99です。", vbExclamation, App.Title
            txtEndAge.SetFocus
            Exit Do
        End If
        

        '年齢（上限）に最大値としての.99を追加
        If (CDbl(txtEndAge.Text) - Int(CDbl(txtEndAge.Text))) = 0 Then
            If Mid(Trim(txtEndAge.Text), Len(Trim(txtEndAge.Text)), 1) = "." Then
                txtEndAge.Text = txtEndAge.Text & "99"
            Else
                txtEndAge.Text = txtEndAge.Text & ".99"
            End If
        End If
        
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
    txtStrAge.Text = mstrStrAge
    txtEndAge.Text = mstrEndAge
    txtbsdPrice.Text = mstrbsdPrice
    txtisrPrice.Text = mstrisrPrice
    
    '年齢がセットされていないなら、勝手にセット（大きなお世話シリーズ）
    If txtStrAge.Text = "" Then txtStrAge.Text = DefaultStrAge
    If txtEndAge.Text = "" Then txtEndAge.Text = DefaultEndAge
    
    '健保有無による画面制御モード
    If mintExistsIsr = 0 Then
        lblMode.Caption = "健保なしデータ設定（健保なしの場合、健保負担金額は設定できません）"
        txtisrPrice.Text = 0
        txtisrPrice.Visible = False
        Label1(1).Visible = False
    Else
        lblMode.Caption = "健保ありデータ設定"
    End If

    
End Sub

Friend Property Get ExistsIsr() As Integer
    
    ExistsIsr = mintExistsIsr

End Property

Friend Property Let ExistsIsr(ByVal vNewValue As Integer)

    mintExistsIsr = vNewValue

End Property

Friend Property Get StrAge() As Variant
    
    StrAge = mstrStrAge

End Property

Friend Property Let StrAge(ByVal vNewValue As Variant)

    mstrStrAge = vNewValue

End Property

Friend Property Get EndAge() As Variant

    EndAge = mstrEndAge

End Property

Friend Property Let EndAge(ByVal vNewValue As Variant)

    mstrEndAge = vNewValue

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
