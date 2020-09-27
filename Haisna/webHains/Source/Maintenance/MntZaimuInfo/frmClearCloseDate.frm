VERSION 5.00
Begin VB.Form frmClearCloseDate 
   BorderStyle     =   1  '固定(実線)
   Caption         =   "締めのやりなおし"
   ClientHeight    =   4455
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8100
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   Icon            =   "frmClearCloseDate.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4455
   ScaleWidth      =   8100
   StartUpPosition =   2  '画面の中央
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmClearCloseDate.frx":000C
      Left            =   3840
      List            =   "frmClearCloseDate.frx":0013
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   21
      Top             =   900
      Width           =   555
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmClearCloseDate.frx":001B
      Left            =   2940
      List            =   "frmClearCloseDate.frx":0022
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   20
      Top             =   900
      Width           =   555
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmClearCloseDate.frx":002A
      Left            =   1920
      List            =   "frmClearCloseDate.frx":0031
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   19
      Top             =   900
      Width           =   735
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   6420
      TabIndex        =   18
      Top             =   3960
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4980
      TabIndex        =   17
      Top             =   3960
      Width           =   1335
   End
   Begin VB.Frame fraOrg 
      Caption         =   "団体請求締めクリア設定"
      Height          =   1875
      Left            =   780
      TabIndex        =   1
      Top             =   1920
      Width           =   6975
      Begin VB.ComboBox cboStrYear 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":003B
         Left            =   1860
         List            =   "frmClearCloseDate.frx":0042
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   7
         Top             =   840
         Width           =   735
      End
      Begin VB.ComboBox cboStrMonth 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":004C
         Left            =   2880
         List            =   "frmClearCloseDate.frx":0053
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   6
         Top             =   840
         Width           =   555
      End
      Begin VB.ComboBox cboStrDay 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":005B
         Left            =   3780
         List            =   "frmClearCloseDate.frx":0062
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   5
         Top             =   840
         Width           =   555
      End
      Begin VB.ComboBox cboEndYear 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":006A
         Left            =   1860
         List            =   "frmClearCloseDate.frx":0071
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   4
         Top             =   1200
         Width           =   735
      End
      Begin VB.ComboBox cboEndMonth 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":007B
         Left            =   2880
         List            =   "frmClearCloseDate.frx":0082
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   3
         Top             =   1200
         Width           =   555
      End
      Begin VB.ComboBox cboEndDay 
         Height          =   300
         ItemData        =   "frmClearCloseDate.frx":008A
         Left            =   3780
         List            =   "frmClearCloseDate.frx":0091
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   2
         Top             =   1200
         Width           =   555
      End
      Begin VB.Label Label8 
         Caption         =   "年"
         Height          =   255
         Index           =   5
         Left            =   2640
         TabIndex        =   16
         Top             =   900
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "月"
         Height          =   255
         Index           =   4
         Left            =   3480
         TabIndex        =   15
         Top             =   900
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "日"
         Height          =   255
         Index           =   2
         Left            =   4380
         TabIndex        =   14
         Top             =   900
         Width           =   255
      End
      Begin VB.Label Label2 
         Caption         =   "開始日付(&S):"
         Height          =   255
         Index           =   0
         Left            =   780
         TabIndex        =   13
         Top             =   900
         Width           =   1095
      End
      Begin VB.Label Label8 
         Caption         =   "年"
         Height          =   255
         Index           =   6
         Left            =   2640
         TabIndex        =   12
         Top             =   1260
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "月"
         Height          =   255
         Index           =   7
         Left            =   3480
         TabIndex        =   11
         Top             =   1260
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "日"
         Height          =   255
         Index           =   8
         Left            =   4380
         TabIndex        =   10
         Top             =   1260
         Width           =   255
      End
      Begin VB.Label Label2 
         Caption         =   "終了日付(&E):"
         Height          =   255
         Index           =   1
         Left            =   780
         TabIndex        =   9
         Top             =   1260
         Width           =   1095
      End
      Begin VB.Label orgLabel 
         Caption         =   "クリアする請求書データ締日範囲を指定してください。"
         Height          =   315
         Left            =   300
         TabIndex        =   8
         Top             =   360
         Width           =   4635
      End
   End
   Begin VB.CheckBox chkOrg 
      Caption         =   "団体請求の財務送信締めもクリアする(&O)"
      Height          =   315
      Left            =   780
      TabIndex        =   0
      Top             =   1500
      Width           =   4335
   End
   Begin VB.Label Label3 
      Caption         =   "指定された日付の締め日をクリアします。"
      Height          =   255
      Left            =   840
      TabIndex        =   26
      Top             =   300
      Width           =   4935
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   300
      Picture         =   "frmClearCloseDate.frx":0099
      Top             =   180
      Width           =   480
   End
   Begin VB.Label Label1 
      Caption         =   "収納日付(&D):"
      Height          =   255
      Left            =   840
      TabIndex        =   25
      Top             =   960
      Width           =   1095
   End
   Begin VB.Label Label8 
      Caption         =   "日作成データの締め情報をクリアします。"
      Height          =   255
      Index           =   3
      Left            =   4440
      TabIndex        =   24
      Top             =   960
      Width           =   3255
   End
   Begin VB.Label Label8 
      Caption         =   "月"
      Height          =   255
      Index           =   1
      Left            =   3540
      TabIndex        =   23
      Top             =   960
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "年"
      Height          =   255
      Index           =   0
      Left            =   2700
      TabIndex        =   22
      Top             =   960
      Width           =   255
   End
End
Attribute VB_Name = "frmClearCloseDate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mblnUpdated         As Boolean      'TRUE:更新あり、FALSE:更新なし
Private mstrInitialDate     As String       '初期表示日付

Private mdtmInsDate         As Date         '収納日付
Private mdtmStrDate         As Date         '団体締め開始日付
Private mdtmEndDate         As Date         '団体締め終了日付
Private mblnCalcOrg         As Boolean      'TRUE:団体請求締め処理実施、FALSE:個人のみ
Private mblnAppendMode      As Boolean      'TRUE:既存データ追加、FALSE:新規作成

Friend Property Let InitialDate(ByVal vNewValue As String)

    mstrInitialDate = vNewValue

End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Friend Property Get CalcOrg() As Boolean

    CalcOrg = mblnCalcOrg

End Property

Friend Property Get AppendMode() As Boolean

    AppendMode = mblnAppendMode

End Property

Friend Property Get InsDate() As Date

    InsDate = mdtmInsDate

End Property

Friend Property Get strDate() As Date

    strDate = mdtmStrDate

End Property

Friend Property Get endDate() As Date

    endDate = mdtmEndDate

End Property

Private Sub chkOrg_Click()

    If chkOrg.Value = vbChecked Then
        fraOrg.Visible = True
    Else
        fraOrg.Visible = False
    End If
    
End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    Dim objZaimu            As Object       '財務連携アクセス用
    Dim strInsDate          As String
    Dim strStrCloseDate     As String
    Dim strEndCloseDate     As String
    Dim blnRet              As Boolean

    '入力値のチェック
    If CheckValue(strInsDate, strStrCloseDate, strEndCloseDate) = False Then Exit Sub
    
    If MsgBox("指定された日付の締めクリアを行います。よろしいですか？", vbQuestion + vbYesNo + vbDefaultButton2) = vbNo Then Exit Sub
    
    'オブジェクトのインスタンス作成
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    '締め情報のクリア
    If chkOrg.Value = vbUnchecked Then
        blnRet = objZaimu.ClearCloseDate(CDate(strInsDate))
    Else
        blnRet = objZaimu.ClearCloseDate(CDate(strInsDate), strStrCloseDate, strEndCloseDate)
    End If
    
    Set objZaimu = Nothing
    
    If blnRet Then
        MsgBox "クリアされました。" & vbLf & "既に作成された財務データも忘れずに削除してください。" & vbLf & "（財務送信データは削除してから一度ＯＫボタンを押さないと消えません）", vbInformation, Me.Caption
        Unload Me
    Else
        MsgBox "クリア処理が異常終了しました。", vbInformation, Me.Caption
    End If
    
End Sub


Private Function CheckValue(strInsDate As String, _
                            strStrCloseDate As String, _
                            strEndCloseDate As String) As Boolean

    Dim strTargetDate   As String

    CheckValue = False
    
    '日付の整合性チェック
    strTargetDate = cboYear.ListIndex + 2002
    strTargetDate = strTargetDate & "/" & Format((cboMonth.ListIndex + 1), "00")
    strTargetDate = strTargetDate & "/" & Format((cboDay.ListIndex + 1), "00")
    
    If IsDate(strTargetDate) = False Then
        MsgBox "正しい日付を指定してください。", vbExclamation, Me.Caption
        cboDay.SetFocus
        Exit Function
    End If
    
    '引数に値セット
    strInsDate = strTargetDate

    '団体締め処理が対象でないなら、処理終了
    If chkOrg.Value = vbUnchecked Then
        CheckValue = True
        Exit Function
    End If
    
    '開始日付（団体締め処理）の整合性チェック
    strTargetDate = cboStrYear.ListIndex + 2002
    strTargetDate = strTargetDate & "/" & Format((cboStrMonth.ListIndex + 1), "00")
    strTargetDate = strTargetDate & "/" & Format((cboStrDay.ListIndex + 1), "00")
    
    If IsDate(strTargetDate) = False Then
        MsgBox "正しい開始日付を指定してください。", vbExclamation, Me.Caption
        cboStrDay.SetFocus
        Exit Function
    End If
    
    '引数に値セット
    strStrCloseDate = strTargetDate
    
    '終了日付（団体締め処理）の整合性チェック
    strTargetDate = cboEndYear.ListIndex + 2002
    strTargetDate = strTargetDate & "/" & Format((cboEndMonth.ListIndex + 1), "00")
    strTargetDate = strTargetDate & "/" & Format((cboEndDay.ListIndex + 1), "00")
    
    If IsDate(strTargetDate) = False Then
        MsgBox "正しい終了日付を指定してください。", vbExclamation, Me.Caption
        cboEndDay.SetFocus
        Exit Function
    End If
    
    '引数に値セット
    strEndCloseDate = strTargetDate
    
    CheckValue = True
    
End Function

Private Sub Form_Load()
    
    Dim i               As Integer
    Dim strWorkDate     As String
    Dim lngYear         As Long
    Dim lngMonth        As Long
    Dim lngDay          As Long

    lngYear = Year(Now)
    lngMonth = Month(Now)
    lngDay = Day(Now)

    'デフォルト日付をセットされている場合は、セット用に分割
    If Len(Trim(mstrInitialDate)) = 8 Then
        strWorkDate = Mid(mstrInitialDate, 1, 4) & "/" & Mid(mstrInitialDate, 5, 2) & "/" & Mid(mstrInitialDate, 7, 2)
        If IsDate(strWorkDate) = True Then
            lngYear = CLng(Mid(mstrInitialDate, 1, 4))
            lngMonth = CLng(Mid(mstrInitialDate, 5, 2))
            lngDay = CLng(Mid(mstrInitialDate, 7, 2))
        End If
    End If

    'コンボボックスに値をセット
    cboYear.Clear
    cboStrYear.Clear
    cboEndYear.Clear
    For i = 2002 To YEARRANGE_MAX
        cboYear.AddItem i
        cboStrYear.AddItem i
        cboEndYear.AddItem i
    Next i
    cboYear.ListIndex = lngYear - 2002
    cboStrYear.ListIndex = lngYear - 2002
    cboEndYear.ListIndex = lngYear - 2002
    
    cboMonth.Clear
    cboStrMonth.Clear
    cboEndMonth.Clear
    For i = 1 To 12
        cboMonth.AddItem i
        cboStrMonth.AddItem i
        cboEndMonth.AddItem i
    Next i
    cboMonth.ListIndex = lngMonth - 1
    cboStrMonth.ListIndex = lngMonth - 1
    cboEndMonth.ListIndex = lngMonth - 1
    
    cboDay.Clear
    cboStrDay.Clear
    cboEndDay.Clear
    For i = 1 To 31
        cboDay.AddItem i
        cboStrDay.AddItem i
        cboEndDay.AddItem i
    Next i
    cboDay.ListIndex = lngDay - 1
    cboStrDay.ListIndex = lngDay - 1
    cboEndDay.ListIndex = lngDay - 1

    Call chkOrg_Click
    
    mblnUpdated = False

End Sub

