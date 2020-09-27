VERSION 5.00
Begin VB.Form frmEditStdValueHistory 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "基準値履歴情報の設定"
   ClientHeight    =   1245
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7185
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditStdValueHistory.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1245
   ScaleWidth      =   7185
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4260
      TabIndex        =   16
      Top             =   840
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5700
      TabIndex        =   15
      Top             =   840
      Width           =   1335
   End
   Begin VB.ComboBox cboCourse 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":000C
      Left            =   1380
      List            =   "frmEditStdValueHistory.frx":002E
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   13
      Top             =   600
      Visible         =   0   'False
      Width           =   5610
   End
   Begin VB.ComboBox cboEndDay 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":0050
      Left            =   6240
      List            =   "frmEditStdValueHistory.frx":0057
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   5
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboEndMonth 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":005F
      Left            =   5340
      List            =   "frmEditStdValueHistory.frx":0066
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   4
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboEndYear 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":006E
      Left            =   4320
      List            =   "frmEditStdValueHistory.frx":0075
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   3
      Top             =   240
      Width           =   735
   End
   Begin VB.ComboBox cboStrDay 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":007F
      Left            =   3300
      List            =   "frmEditStdValueHistory.frx":0086
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   2
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboStrMonth 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":008E
      Left            =   2400
      List            =   "frmEditStdValueHistory.frx":0095
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   1
      Top             =   240
      Width           =   555
   End
   Begin VB.ComboBox cboStrYear 
      Height          =   300
      ItemData        =   "frmEditStdValueHistory.frx":009D
      Left            =   1380
      List            =   "frmEditStdValueHistory.frx":00A4
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   0
      Top             =   240
      Width           =   735
   End
   Begin VB.Label Label8 
      Caption         =   "コース(&C):"
      Height          =   195
      Index           =   2
      Left            =   180
      TabIndex        =   14
      Top             =   660
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "有効期間(&D):"
      Height          =   255
      Left            =   180
      TabIndex        =   12
      Top             =   300
      Width           =   1155
   End
   Begin VB.Label Label8 
      Caption         =   "日"
      Height          =   255
      Index           =   7
      Left            =   6840
      TabIndex        =   11
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "月"
      Height          =   255
      Index           =   6
      Left            =   5940
      TabIndex        =   10
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "年"
      Height          =   255
      Index           =   5
      Left            =   5100
      TabIndex        =   9
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "日～"
      Height          =   255
      Index           =   3
      Left            =   3900
      TabIndex        =   8
      Top             =   300
      Width           =   435
   End
   Begin VB.Label Label8 
      Caption         =   "月"
      Height          =   255
      Index           =   1
      Left            =   3000
      TabIndex        =   7
      Top             =   300
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "年"
      Height          =   255
      Index           =   0
      Left            =   2160
      TabIndex        =   6
      Top             =   300
      Width           =   255
   End
End
Attribute VB_Name = "frmEditStdValueHistory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCsCd       As String   'コースコード
Private mstrCsName     As String   'コース名
Private mstrStrDate    As String   '開始日付
Private mstrEndDate    As String   '開始日付

Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mstrRootCsCd()  As String   'コンボボックスに対応するコースコードの格納
Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション



Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : コースデータセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 検査分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditCourseConbo() As Boolean

    Dim objCourse       As Object   'コースアクセス用
    Dim vntCsCd         As Variant
    Dim vntCsName       As Variant
    Dim lngCount        As Long             'レコード数
    Dim i               As Long             'インデックス
    
    EditCourseConbo = False
    
    cboCourse.Clear
    Erase mstrRootCsCd

    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
'### 2002.12.22 Modified by H.Ishihara@FSIT 選択可能なコースはメインコースのみ
'    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName)
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName, , 3)
'### 2002.12.22 Modified End
    
    'コースは未指定あり
    ReDim Preserve mstrRootCsCd(0)
    mstrRootCsCd(0) = ""
    cboCourse.AddItem ""
    cboCourse.ListIndex = 0
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRootCsCd(i + 1)
        mstrRootCsCd(i + 1) = vntCsCd(i)
        cboCourse.AddItem vntCsName(i)
        If vntCsCd(i) = mstrCsCd Then
            cboCourse.ListIndex = i + 1
        End If
    Next i
    
    '先頭コンボを選択状態にする
'    cboCourse.ListIndex = 0
    EditCourseConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub cmdOk_Click()

    Dim strStrDate As String
    Dim strEndDate As String

    '入力チェック
    If CheckValue(strStrDate, strEndDate) = False Then Exit Sub
    
    'プロパティ値の画面セット
    mstrStrDate = strStrDate
    mstrEndDate = strEndDate
    mstrCsCd = mstrRootCsCd(cboCourse.ListIndex)
    mstrCsName = cboCourse.Text

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

    Do
        'コースコンボの編集
        If EditCourseConbo() = False Then
            Exit Do
        End If
                
        Ret = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Sub



Friend Property Get CsCd() As Variant

    CsCd = mstrCsCd

End Property

Friend Property Let CsCd(ByVal vNewValue As Variant)

    mstrCsCd = vNewValue

End Property

Friend Property Get strDate() As Variant

    strDate = mstrStrDate

End Property

Friend Property Let strDate(ByVal vNewValue As Variant)

    mstrStrDate = vNewValue

End Property

Friend Property Get endDate() As Variant

    endDate = mstrEndDate

End Property

Friend Property Let endDate(ByVal vNewValue As Variant)

    mstrEndDate = vNewValue

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property

Friend Property Let Updated(ByVal vNewValue As Variant)

    mblnUpdated = vNewValue
    
End Property

Friend Property Get CsName() As Variant

    CsName = mstrCsName
    
End Property

