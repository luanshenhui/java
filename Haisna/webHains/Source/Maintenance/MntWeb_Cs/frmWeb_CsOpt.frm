VERSION 5.00
Begin VB.Form frmWeb_CsOpt 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "WEBコースオプション検査説明"
   ClientHeight    =   6045
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6105
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmWeb_CsOpt.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6045
   ScaleWidth      =   6105
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.TextBox txtOptPurpose 
      Height          =   600
      IMEMode         =   4  '全角ひらがな
      Left            =   180
      MaxLength       =   50
      MultiLine       =   -1  'True
      ScrollBars      =   2  '垂直
      TabIndex        =   3
      Text            =   "frmWeb_CsOpt.frx":000C
      Top             =   1560
      Width           =   5775
   End
   Begin VB.TextBox txtOptName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   180
      MaxLength       =   30
      TabIndex        =   1
      Text            =   "@@"
      Top             =   840
      Width           =   5775
   End
   Begin VB.TextBox txtOptDetail 
      Height          =   2865
      IMEMode         =   4  '全角ひらがな
      Left            =   180
      MaxLength       =   300
      MultiLine       =   -1  'True
      ScrollBars      =   2  '垂直
      TabIndex        =   5
      Text            =   "frmWeb_CsOpt.frx":000F
      Top             =   2640
      Width           =   5775
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4620
      TabIndex        =   7
      Top             =   5640
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   3180
      TabIndex        =   6
      Top             =   5640
      Width           =   1335
   End
   Begin VB.Label lblCtrOptName 
      Caption         =   "感染症オプションの説明"
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   180
      TabIndex        =   8
      Top             =   180
      Width           =   3375
   End
   Begin VB.Label Label1 
      Caption         =   "オプション検査の目的(&A)"
      Height          =   180
      Index           =   1
      Left            =   180
      TabIndex        =   2
      Top             =   1260
      Width           =   3150
   End
   Begin VB.Label Label1 
      Caption         =   "オプション検査名(&A)"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   600
      Width           =   3090
   End
   Begin VB.Label Label1 
      Caption         =   "オプション検査の詳細説明(&K)"
      Height          =   180
      Index           =   2
      Left            =   180
      TabIndex        =   4
      Top             =   2340
      Width           =   4290
   End
End
Attribute VB_Name = "frmWeb_CsOpt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCtrOptName  As String   '検査名
Private mstrOptName     As String   '検査名
Private mstrOptPurpose  As String   '検査目的
Private mstrOptDetail   As String   '検査説明

Private mblnUpdate      As Boolean  'TRUE:更新しました、FALSE:未更新
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Friend Property Let CtrOptName(ByVal vNewValue As String)

    mstrCtrOptName = vNewValue
    
End Property

Friend Property Get OptName() As String

    OptName = mstrOptName

End Property

Friend Property Let OptName(ByVal vNewValue As String)

    mstrOptName = vNewValue
    
End Property

Friend Property Get OptDetail() As String

    OptDetail = mstrOptDetail

End Property

Friend Property Let OptDetail(ByVal vNewValue As String)

    mstrOptDetail = vNewValue
    
End Property

Private Sub cmdOk_Click()

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass

    '入力チェック
    If CheckValue() = False Then
        '処理中の解除
        Screen.MousePointer = vbDefault
        Exit Sub
    End If

    mstrOptName = txtOptName.Text
    mstrOptPurpose = txtOptPurpose.Text
    mstrOptDetail = txtOptDetail.Text
    mblnUpdate = True
    Unload Me

    '処理中の解除
    Screen.MousePointer = vbDefault

End Sub

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

        'オプション検査名の入力チェック
        If Trim(txtOptName.Text) = "" Then
            MsgBox "オプション検査名が入力されていません。", vbCritical, App.Title
            txtOptName.SetFocus
            Exit Do
        End If

        '検査説明の入力チェック
        If Trim(txtOptPurpose.Text) = "" Then
            MsgBox "検査目的が入力されていません。", vbCritical, App.Title
            txtOptPurpose.SetFocus
            Exit Do
        End If

        'オプション検査詳細説明の入力チェック
        If Trim(txtOptDetail.Text) = "" Then
            MsgBox "詳細説明が入力されていません。", vbCritical, App.Title
            txtOptDetail.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function


Private Sub Form_Load()

    mblnUpdate = False
    
    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    lblCtrOptName.Caption = mstrCtrOptName & "の説明"

    txtOptName.Text = mstrOptName
    
    '新規入力時などはオプション検査名をデフォルト表示する
    If Trim(txtOptName.Text) = "" Then
        txtOptName.Text = mstrCtrOptName
    End If
    
    txtOptPurpose.Text = mstrOptPurpose
    txtOptDetail.Text = mstrOptDetail
    
End Sub

Public Property Get Updated() As Variant

    Updated = mblnUpdate
    
End Property

Friend Property Get OptPurpose() As String

    OptPurpose = mstrOptPurpose

End Property

Friend Property Let OptPurpose(ByVal vNewValue As String)

    mstrOptPurpose = vNewValue

End Property
