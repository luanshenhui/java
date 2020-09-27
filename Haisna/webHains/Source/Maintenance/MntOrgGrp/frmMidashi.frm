VERSION 5.00
Begin VB.Form frmMidashi 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "見出しの設定"
   ClientHeight    =   2595
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4680
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2595
   ScaleWidth      =   4680
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.Frame Frame1 
      Caption         =   "見出し項目"
      BeginProperty Font 
         Name            =   "ＭＳ Ｐゴシック"
         Size            =   9
         Charset         =   128
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1215
      Left            =   120
      TabIndex        =   3
      Top             =   840
      Width           =   4455
      Begin VB.TextBox txtMidashi 
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   0
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   855
         IMEMode         =   4  '全角ひらがな
         Left            =   120
         MaxLength       =   100
         MultiLine       =   -1  'True
         ScrollBars      =   2  '垂直
         TabIndex        =   0
         Top             =   240
         Width           =   4215
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      BeginProperty Font 
         Name            =   "MS UI Gothic"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   3240
      TabIndex        =   2
      Top             =   2160
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1850
      TabIndex        =   1
      Top             =   2160
      Width           =   1275
   End
   Begin VB.Image Image1 
      Height          =   480
      Index           =   0
      Left            =   300
      Picture         =   "frmMidashi.frx":0000
      Top             =   180
      Width           =   480
   End
   Begin VB.Label Label1 
      Caption         =   "見出し項目を設定します。"
      Height          =   255
      Left            =   960
      TabIndex        =   4
      Top             =   360
      Width           =   3315
   End
End
Attribute VB_Name = "frmMidashi"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'##2003.09.11 T-ISHI@FSIT 見出しコメント記入用フォーム作成

Option Explicit

Private mstrrslCaption   As String   '記入された見出し名称
Private Sub cmdCancel_Click()

    '画面を閉じる
    Unload Me
    
End Sub
Private Sub cmdOk_Click()

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '見出しコメントを取得する
    mstrrslCaption = txtMidashi.Text
    
    Screen.MousePointer = vbDefault
          
    '画面を閉じる
    Unload Me

End Sub
Public Property Get rslCaption() As Variant

    rslCaption = mstrrslCaption
    
End Property
Public Property Let rslCaption(ByVal vNewValue As Variant)
    
    mstrrslCaption = vNewValue

End Property

Private Sub Form_Load()

    txtMidashi.Text = mstrrslCaption

    Screen.MousePointer = vbDefault
    
End Sub

Private Sub LabelCourseGuide_Click()

End Sub
