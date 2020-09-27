VERSION 5.00
Begin VB.Form frmEditCalcHistory 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "計算項目履歴情報の設定"
   ClientHeight    =   2805
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7380
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditCalcHistory.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2805
   ScaleWidth      =   7380
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.TextBox txtExplanation 
      Height          =   735
      Left            =   1560
      MaxLength       =   30
      TabIndex        =   12
      Text            =   "Text1"
      Top             =   1500
      Width           =   5595
   End
   Begin VB.ComboBox cboTiming 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":000C
      Left            =   1560
      List            =   "frmEditCalcHistory.frx":002E
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   10
      Top             =   1080
      Width           =   5610
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4440
      TabIndex        =   13
      Top             =   2400
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5880
      TabIndex        =   14
      Top             =   2400
      Width           =   1335
   End
   Begin VB.ComboBox cboFraction 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":0050
      Left            =   1560
      List            =   "frmEditCalcHistory.frx":0072
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   8
      Top             =   660
      Width           =   2670
   End
   Begin VB.ComboBox cboEndDay 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":0094
      Left            =   6420
      List            =   "frmEditCalcHistory.frx":009B
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   6
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboEndMonth 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00A3
      Left            =   5520
      List            =   "frmEditCalcHistory.frx":00AA
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   5
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboEndYear 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00B2
      Left            =   4500
      List            =   "frmEditCalcHistory.frx":00B9
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   4
      Top             =   240
      Width           =   735
   End
   Begin VB.ComboBox cboStrDay 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00C3
      Left            =   3480
      List            =   "frmEditCalcHistory.frx":00CA
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   3
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboStrMonth 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00D2
      Left            =   2580
      List            =   "frmEditCalcHistory.frx":00D9
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   2
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboStrYear 
      Height          =   300
      ItemData        =   "frmEditCalcHistory.frx":00E1
      Left            =   1560
      List            =   "frmEditCalcHistory.frx":00E8
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   1
      Top             =   240
      Width           =   735
   End
   Begin VB.Label Label8 
      Caption         =   "説明(&E):"
      Height          =   195
      Index           =   8
      Left            =   180
      TabIndex        =   11
      Top             =   1560
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "計算タイミング(&T):"
      Height          =   195
      Index           =   4
      Left            =   180
      TabIndex        =   9
      Top             =   1140
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "端数処理(&H):"
      Height          =   195
      Index           =   2
      Left            =   180
      TabIndex        =   7
      Top             =   720
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "有効期間(&D):"
      Height          =   255
      Left            =   180
      TabIndex        =   0
      Top             =   300
      Width           =   1155
   End
   Begin VB.Label Label8 
      Caption         =   "日"
      Height          =   255
      Index           =   7
      Left            =   7020
      TabIndex        =   20
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "月"
      Height          =   255
      Index           =   6
      Left            =   6120
      TabIndex        =   19
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "年"
      Height          =   255
      Index           =   5
      Left            =   5280
      TabIndex        =   18
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "日～"
      Height          =   255
      Index           =   3
      Left            =   4080
      TabIndex        =   17
      Top             =   300
      Width           =   435
   End
   Begin VB.Label Label8 
      Caption         =   "月"
      Height          =   255
      Index           =   1
      Left            =   3180
      TabIndex        =   16
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "年"
      Height          =   255
      Index           =   0
      Left            =   2340
      TabIndex        =   15
      Top             =   300
      Width           =   255
   End
End
Attribute VB_Name = "frmEditCalcHistory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrStrDate             As String   '開始日付
Private mstrEndDate             As String   '終了日付
Private mintFraction            As Integer  '端数処理
Private mintTiming              As Integer  '計算タイミング
Private mstrExplanation         As String   '説明

Private mblnUpdated             As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mstrRootFraction()      As String   'コンボボックスに対応するコースコードの格納
Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()

    Dim strStrDate As String
    Dim strEndDate As String

    '入力チェック
    If CheckValue(strStrDate, strEndDate) = False Then Exit Sub
    
    'プロパティ値の画面セット
    mstrStrDate = strStrDate
    mstrEndDate = strEndDate
    mintFraction = cboFraction.ListIndex
    mintTiming = cboTiming.ListIndex
    mstrExplanation = Trim(txtExplanation.Text)

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
' 備考　　 :
'
Private Function CheckValue(strStrDate As String, strEndDate As String) As Boolean

    Dim Ret             As Boolean  '関数戻り値
    Dim strWorkResult   As String
        
    '同一コントロールのSetFocusでは文字列選択が有効にならないのでダミーでとばす
    cmdOk.SetFocus
    
    Ret = False
    
    Do
        
        '開始日付チェック
        strStrDate = cboStrYear.Text & "/" & _
                     Format(cboStrMonth.Text, "00") & "/" & _
                     Format(cboStrDay.Text, "00")

        If IsDate(strStrDate) = False Then
            MsgBox "正しい開始日付を入力してください。", vbExclamation, App.Title
            cboStrYear.SetFocus
            Exit Do
        End If

        '終了日付チェック
        strEndDate = cboEndYear.Text & "/" & _
                     Format(cboEndMonth.Text, "00") & "/" & _
                     Format(cboEndDay.Text, "00")

        If IsDate(strEndDate) = False Then
            MsgBox "正しい終了日付を入力してください。", vbExclamation, App.Title
            cboEndYear.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

Private Sub Form_Load()

    Dim Ret             As Boolean  '戻り値
    Dim i               As Integer
    Dim intWorkYear     As Integer
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False

    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    'コンボボックスに値をセット
    For i = YEARRANGE_MIN To YEARRANGE_MAX
        cboStrYear.AddItem i
        cboEndYear.AddItem i
    Next i
    
    For i = 1 To 12
        cboStrMonth.AddItem i
        cboEndMonth.AddItem i
    Next i
    
    For i = 1 To 31
        cboStrDay.AddItem i
        cboEndDay.AddItem i
    Next i

    '開始日の設定
    If IsDate(mstrStrDate) = True Then
        intWorkYear = CInt(Format(CDate(mstrStrDate), "YYYY"))
        If intWorkYear >= YEARRANGE_MIN Then
            cboStrYear.ListIndex = intWorkYear - YEARRANGE_MIN
        End If
        cboStrMonth.ListIndex = CInt(Format(CDate(mstrStrDate), "MM")) - 1
        cboStrDay.ListIndex = CInt(Format(CDate(mstrStrDate), "DD")) - 1
    End If

    '終了日の設定
    If IsDate(mstrEndDate) = True Then
        intWorkYear = CInt(Format(CDate(mstrEndDate), "YYYY"))
        If intWorkYear >= YEARRANGE_MIN Then
            cboEndYear.ListIndex = intWorkYear - YEARRANGE_MIN
        End If
        cboEndMonth.ListIndex = CInt(Format(CDate(mstrEndDate), "MM")) - 1
        cboEndDay.ListIndex = CInt(Format(CDate(mstrEndDate), "DD")) - 1
    End If

    With cboFraction
        .Clear
        .AddItem "0:四捨五入"
        .AddItem "1:切り上げ"
        .AddItem "2:切り捨て"
        .ListIndex = mintFraction
    End With
    
    With cboTiming
        .Clear
        .AddItem "0:全ての値が揃ったときに計算し、結果を格納"
        .AddItem "1:計算要素のうち、一つでも値が入った場合に、計算を実行"
        .ListIndex = mintTiming
    End With
    
    txtExplanation.Text = mstrExplanation

    Ret = True
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Sub

Friend Property Get Fraction() As Integer

    Fraction = mintFraction

End Property

Friend Property Let Fraction(ByVal vNewValue As Integer)

    mintFraction = vNewValue

End Property

Friend Property Get Timing() As Integer

    Timing = mintTiming

End Property

Friend Property Let Timing(ByVal vNewValue As Integer)

    mintTiming = vNewValue

End Property

Friend Property Get Explanation() As String

    Explanation = mstrExplanation

End Property

Friend Property Let Explanation(ByVal vNewValue As String)

    mstrExplanation = vNewValue

End Property

Friend Property Get StrDate() As Variant

    StrDate = mstrStrDate

End Property

Friend Property Let StrDate(ByVal vNewValue As Variant)

    mstrStrDate = vNewValue

End Property

Friend Property Get EndDate() As Variant

    EndDate = mstrEndDate

End Property

Friend Property Let EndDate(ByVal vNewValue As Variant)

    mstrEndDate = vNewValue

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property
