VERSION 5.00
Begin VB.Form frmWeb_CsDetail 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "WEBコース検査項目説明"
   ClientHeight    =   4470
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
   Icon            =   "frmWeb_CsDetail.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4470
   ScaleWidth      =   6105
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.TextBox txtInspect 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   180
      MaxLength       =   30
      TabIndex        =   1
      Text            =   "@@"
      Top             =   420
      Width           =   5775
   End
   Begin VB.TextBox txtInsDetail 
      Height          =   2865
      IMEMode         =   4  '全角ひらがな
      Left            =   180
      MaxLength       =   300
      MultiLine       =   -1  'True
      ScrollBars      =   2  '垂直
      TabIndex        =   3
      Text            =   "frmWeb_CsDetail.frx":000C
      Top             =   1080
      Width           =   5775
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4620
      TabIndex        =   5
      Top             =   4020
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   3180
      TabIndex        =   4
      Top             =   4020
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "検査名(&A)"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "検査説明(&K)"
      Height          =   180
      Index           =   2
      Left            =   180
      TabIndex        =   2
      Top             =   840
      Width           =   1410
   End
End
Attribute VB_Name = "frmWeb_CsDetail"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCsCd        As String   'コースコード
Private mintSeq         As Integer  '表示順
Private mstrInspect     As String   '検査名
Private mstrInsDetail   As String   '検査説明

Private mblnUpdate      As Boolean  'TRUE:更新しました、FALSE:未更新
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Friend Property Get Inspect() As Variant

    Inspect = mstrInspect

End Property

Friend Property Let Inspect(ByVal vNewValue As Variant)

    mstrInspect = vNewValue
    
End Property

Friend Property Get InsDetail() As Variant

    InsDetail = mstrInsDetail

End Property

Friend Property Let InsDetail(ByVal vNewValue As Variant)

    mstrInsDetail = vNewValue
    
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

    mstrInspect = txtInspect.Text
    mstrInsDetail = txtInsDetail.Text
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

        '検査名の入力チェック
        If Trim(txtInspect.Text) = "" Then
            MsgBox "検査名が入力されていません。", vbCritical, App.Title
            txtInspect.SetFocus
            Exit Do
        End If

        '検査説明の入力チェック
        If Trim(txtInsDetail.Text) = "" Then
            MsgBox "検査説明が入力されていません。", vbCritical, App.Title
            txtInsDetail.SetFocus
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
    
    txtInspect.Text = mstrInspect
    txtInsDetail.Text = mstrInsDetail
    
End Sub



Public Property Get Updated() As Variant

    Updated = mblnUpdate
    
End Property

