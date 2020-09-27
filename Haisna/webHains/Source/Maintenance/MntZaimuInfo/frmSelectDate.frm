VERSION 5.00
Begin VB.Form frmSelectDate 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "処理対象日付を指定してください。"
   ClientHeight    =   1905
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5190
   Icon            =   "frmSelectDate.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1905
   ScaleWidth      =   5190
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmSelectDate.frx":000C
      Left            =   3420
      List            =   "frmSelectDate.frx":0013
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   4
      Top             =   420
      Width           =   555
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmSelectDate.frx":001B
      Left            =   2520
      List            =   "frmSelectDate.frx":0022
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   3
      Top             =   420
      Width           =   555
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmSelectDate.frx":002A
      Left            =   1500
      List            =   "frmSelectDate.frx":0031
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   2
      Top             =   420
      Width           =   735
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3420
      TabIndex        =   1
      Top             =   1380
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1980
      TabIndex        =   0
      Top             =   1380
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "処理日付(&D):"
      Height          =   255
      Left            =   420
      TabIndex        =   8
      Top             =   480
      Width           =   1095
   End
   Begin VB.Label Label8 
      Caption         =   "日"
      Height          =   255
      Index           =   3
      Left            =   4020
      TabIndex        =   7
      Top             =   480
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "月"
      Height          =   255
      Index           =   1
      Left            =   3120
      TabIndex        =   6
      Top             =   480
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "年"
      Height          =   255
      Index           =   0
      Left            =   2280
      TabIndex        =   5
      Top             =   480
      Width           =   255
   End
End
Attribute VB_Name = "frmSelectDate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mstrZaimuDate   As String   '財務情報日付

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Friend Property Get ZaimuDate() As String

    ZaimuDate = mstrZaimuDate

End Property

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    Dim strYY       As String
    Dim strMM       As String
    Dim strDD       As String
    
    strYY = cboYear.ListIndex + 2002
    strMM = Format((cboMonth.ListIndex + 1), "00")
    strDD = Format((cboDay.ListIndex + 1), "00")
        
    If IsDate(strYY & "/" & strMM & "/" & strDD) = False Then
        MsgBox "正しい日付を指定してください。", vbExclamation, Me.Caption
        mstrZaimuDate = ""
        Exit Sub
    End If
    
    mstrZaimuDate = strYY & strMM & strDD
    mblnUpdated = True
    Unload Me

End Sub

Private Sub Form_Load()

    Dim i As Integer

    'コンボボックスに値をセット
    cboYear.Clear
    For i = 2002 To YEARRANGE_MAX
        cboYear.AddItem i
    Next i
    cboYear.ListIndex = Year(Now) - 2002
    
    cboMonth.Clear
    For i = 1 To 12
        cboMonth.AddItem i
    Next i
    cboMonth.ListIndex = Month(Now) - 1
    
    cboDay.Clear
    For i = 1 To 31
        cboDay.AddItem i
    Next i
    cboDay.ListIndex = Day(Now) - 1

    mblnUpdated = False
    
End Sub
