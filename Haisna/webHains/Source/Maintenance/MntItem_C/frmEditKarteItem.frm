VERSION 5.00
Begin VB.Form frmEditKarteItem 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "電子カルテ連携項目コードの編集"
   ClientHeight    =   2730
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6660
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditKarteItem.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2730
   ScaleWidth      =   6660
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.TextBox txtKarteTagName 
      Height          =   315
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1680
      MaxLength       =   20
      TabIndex        =   9
      Text            =   "@@@@@@@@@@@@@@@@@@@@"
      Top             =   1620
      Width           =   2595
   End
   Begin VB.TextBox txtKarteItemcd 
      Height          =   315
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1680
      MaxLength       =   8
      TabIndex        =   5
      Text            =   "@@@@@@@@"
      Top             =   900
      Width           =   1095
   End
   Begin VB.TextBox txtKarteItemName 
      Height          =   315
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   50
      TabIndex        =   7
      Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
      Top             =   1260
      Width           =   4695
   End
   Begin VB.TextBox txtKarteItemAttr 
      Height          =   315
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   3
      Text            =   "@@@"
      Top             =   540
      Width           =   555
   End
   Begin VB.TextBox txtKarteDocCd 
      Height          =   315
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1680
      MaxLength       =   4
      TabIndex        =   1
      Text            =   "@@@@"
      Top             =   180
      Width           =   615
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5220
      TabIndex        =   11
      Top             =   2280
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3840
      TabIndex        =   10
      Top             =   2280
      Width           =   1275
   End
   Begin VB.Label Label8 
      Caption         =   "タグ名(&T):"
      Height          =   195
      Index           =   0
      Left            =   180
      TabIndex        =   8
      Top             =   1680
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "変換コード(&C):"
      Height          =   195
      Index           =   16
      Left            =   180
      TabIndex        =   4
      Top             =   960
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "項目名(&N):"
      Height          =   195
      Index           =   17
      Left            =   180
      TabIndex        =   6
      Top             =   1320
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "項目属性(&A):"
      Height          =   195
      Index           =   18
      Left            =   180
      TabIndex        =   2
      Top             =   600
      Width           =   1455
   End
   Begin VB.Label Label8 
      Caption         =   "文書種別コード(&B):"
      Height          =   195
      Index           =   19
      Left            =   180
      TabIndex        =   0
      Top             =   240
      Width           =   1515
   End
End
Attribute VB_Name = "frmEditKarteItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim mblnUpdated         As Boolean      'TRUE:更新済み、FALSE:更新なし

Dim mstrKarteDocCd      As String
Dim mstrKarteItemAttr   As String
Dim mstrKarteItemcd     As String
Dim mstrKarteItemName   As String
Dim mstrKarteTagName    As String

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Friend Property Get KarteDocCd() As String

    KarteDocCd = mstrKarteDocCd

End Property

Friend Property Let KarteDocCd(ByVal vNewValue As String)

    mstrKarteDocCd = vNewValue

End Property

Friend Property Get KarteItemAttr() As String

    KarteItemAttr = mstrKarteItemAttr

End Property

Friend Property Let KarteItemAttr(ByVal vNewValue As String)

    mstrKarteItemAttr = vNewValue
    
End Property

Friend Property Get KarteItemcd() As String

    KarteItemcd = mstrKarteItemcd

End Property

Friend Property Let KarteItemcd(ByVal vNewValue As String)

    mstrKarteItemcd = vNewValue

End Property

Friend Property Get KarteItemName() As String

    KarteItemName = mstrKarteItemName

End Property

Friend Property Let KarteItemName(ByVal vNewValue As String)

    mstrKarteItemName = vNewValue
    
End Property

Friend Property Get KarteTagName() As String

    KarteTagName = mstrKarteTagName

End Property

Friend Property Let KarteTagName(ByVal vNewValue As String)

    mstrKarteTagName = vNewValue
    
End Property

Private Sub cmdOk_Click()

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    'データ保存
    If ApplyData() = True Then
    
        '更新済みフラグをTrueに
        mblnUpdated = True
        
        '画面を閉じる
        Unload Me
    End If
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Sub

Private Function ApplyData() As Boolean

    ApplyData = False
    
    '更新済みフラグをfalseに
    mblnUpdated = False
    
    '入力チェック
    If CheckValue() = False Then
        Exit Function
    End If
    
    'データセット
    mstrKarteDocCd = Trim(txtKarteDocCd.Text)
    mstrKarteItemAttr = Trim(txtKarteItemAttr.Text)
    mstrKarteItemcd = Trim(txtKarteItemcd.Text)
    mstrKarteItemName = Trim(txtKarteItemName.Text)
    mstrKarteTagName = Trim(txtKarteTagName.Text)
    
    ApplyData = True
    
End Function

Private Function CheckValue() As Boolean

    CheckValue = False
    
    '文書種別コードの未入力チェック
    If Trim(txtKarteDocCd) = "" Then
        MsgBox "文書種別コードが入力されていません。", vbExclamation, App.Title
        txtKarteDocCd.SetFocus
        Exit Function
    End If
    
    '項目属性の未入力チェック
    If Trim(txtKarteItemAttr) = "" Then
        MsgBox "項目属性が入力されていません。", vbExclamation, App.Title
        txtKarteItemAttr.SetFocus
        Exit Function
    End If
    
    '変換コードの未入力チェック
    If Trim(txtKarteItemcd) = "" Then
        MsgBox "変換コードが入力されていません。", vbExclamation, App.Title
        txtKarteItemcd.SetFocus
        Exit Function
    End If
    
    '項目名の未入力チェック
    If Trim(txtKarteItemName) = "" Then
        MsgBox "項目名が入力されていません。", vbExclamation, App.Title
        txtKarteItemName.SetFocus
        Exit Function
    End If
    
    CheckValue = True
    
End Function

Private Sub Form_Load()

    Call InitFormControls(Me, mcolGotFocusCollection)

    mblnUpdated = False
    
    txtKarteDocCd.Text = mstrKarteDocCd
    txtKarteItemAttr.Text = mstrKarteItemAttr
    txtKarteItemcd.Text = mstrKarteItemcd
    txtKarteItemName.Text = mstrKarteItemName
    txtKarteTagName.Text = mstrKarteTagName

End Sub

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated
    
End Property
