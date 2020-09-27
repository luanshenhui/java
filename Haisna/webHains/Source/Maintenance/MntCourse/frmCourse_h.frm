VERSION 5.00
Begin VB.Form frmCourse_h 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "コース履歴情報"
   ClientHeight    =   5220
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5505
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmCourse_h.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5220
   ScaleWidth      =   5505
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
      Height          =   315
      Left            =   4080
      TabIndex        =   23
      Top             =   4800
      Width           =   1275
   End
   Begin VB.Frame Frame1 
      Caption         =   "受診検査項目"
      Height          =   1695
      Left            =   120
      TabIndex        =   19
      Top             =   2940
      Visible         =   0   'False
      Width           =   5235
      Begin VB.ComboBox cboHistory 
         BeginProperty Font 
            Name            =   "ＭＳ Ｐゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         ItemData        =   "frmCourse_h.frx":000C
         Left            =   360
         List            =   "frmCourse_h.frx":002E
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   20
         Top             =   1020
         Width           =   4590
      End
      Begin VB.Label LabelItem 
         Caption         =   "新規作成時既存履歴から受診情報をコピーするにはここで選択してください。"
         Height          =   375
         Left            =   840
         TabIndex        =   22
         Top             =   420
         Width           =   4275
      End
      Begin VB.Image Image1 
         Height          =   405
         Index           =   0
         Left            =   300
         Picture         =   "frmCourse_h.frx":0050
         Stretch         =   -1  'True
         Top             =   420
         Width           =   405
      End
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1320
      TabIndex        =   18
      Top             =   4800
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   2700
      TabIndex        =   17
      Top             =   4800
      Width           =   1275
   End
   Begin VB.Frame fraMain 
      Caption         =   "Frame1"
      Height          =   2655
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   5235
      Begin VB.ComboBox cboStrYear 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":0492
         Left            =   2040
         List            =   "frmCourse_h.frx":0499
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   9
         Top             =   1140
         Width           =   735
      End
      Begin VB.ComboBox cboStrMonth 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04A3
         Left            =   3060
         List            =   "frmCourse_h.frx":04AA
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   8
         Top             =   1140
         Width           =   555
      End
      Begin VB.ComboBox cboStrDay 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04B2
         Left            =   3960
         List            =   "frmCourse_h.frx":04B9
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   7
         Top             =   1140
         Width           =   555
      End
      Begin VB.ComboBox cboEndYear 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04C1
         Left            =   2040
         List            =   "frmCourse_h.frx":04C8
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   6
         Top             =   1560
         Width           =   735
      End
      Begin VB.ComboBox cboEndMonth 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04D2
         Left            =   3060
         List            =   "frmCourse_h.frx":04D9
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   5
         Top             =   1560
         Width           =   555
      End
      Begin VB.ComboBox cboEndDay 
         Height          =   300
         ItemData        =   "frmCourse_h.frx":04E1
         Left            =   3960
         List            =   "frmCourse_h.frx":04E8
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   4
         Top             =   1560
         Width           =   555
      End
      Begin VB.CommandButton cmdStrDate 
         Caption         =   "使用開始(&S)..."
         Height          =   315
         Left            =   300
         TabIndex        =   3
         Top             =   1140
         Width           =   1695
      End
      Begin VB.CommandButton cmdEndDate 
         Caption         =   "使用終了(&E)..."
         Height          =   315
         Left            =   300
         TabIndex        =   2
         Top             =   1560
         Width           =   1695
      End
      Begin VB.TextBox txtPrice 
         Height          =   315
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2040
         MaxLength       =   7
         TabIndex        =   1
         Text            =   "Text1"
         Top             =   1980
         Width           =   855
      End
      Begin VB.Label Label5 
         Caption         =   "履歴で管理する情報を設定します。"
         Height          =   255
         Index           =   0
         Left            =   900
         TabIndex        =   21
         Top             =   480
         Width           =   4275
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   4
         Left            =   300
         Picture         =   "frmCourse_h.frx":04F0
         Top             =   360
         Width           =   480
      End
      Begin VB.Label Label8 
         Caption         =   "年"
         Height          =   255
         Index           =   0
         Left            =   2820
         TabIndex        =   16
         Top             =   1200
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "月"
         Height          =   255
         Index           =   1
         Left            =   3660
         TabIndex        =   15
         Top             =   1200
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "日"
         Height          =   255
         Index           =   3
         Left            =   4560
         TabIndex        =   14
         Top             =   1200
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "年"
         Height          =   255
         Index           =   5
         Left            =   2820
         TabIndex        =   13
         Top             =   1620
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "月"
         Height          =   255
         Index           =   6
         Left            =   3660
         TabIndex        =   12
         Top             =   1620
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "日"
         Height          =   255
         Index           =   7
         Left            =   4560
         TabIndex        =   11
         Top             =   1620
         Width           =   255
      End
      Begin VB.Label Label8 
         Caption         =   "コース基本料金(&C):"
         BeginProperty Font 
            Name            =   "ＭＳ Ｐゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Index           =   2
         Left            =   420
         TabIndex        =   10
         Top             =   2040
         Width           =   1575
      End
   End
End
Attribute VB_Name = "frmCourse_h"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCsCd        As String   'コースコード
Private mintCsHNo       As Integer  '履歴番号
Private mstrStrDate     As String   '開始日付
Private mstrEndDate     As String   '終了日付
Private mlngPrice       As Long     'コース基本料金
Private mblnUpdate      As Boolean  'TRUE:更新しました、FALSE:未更新

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Private Sub cmdApply_Click()

    'データ適用処理を行う
    Call ApplyData

End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub


Friend Property Let CsCd(ByVal vNewValue As Variant)

    mstrCsCd = vNewValue

End Property

Friend Property Get CsHNo() As Variant

    CsHNo = mintCsHNo

End Property

Friend Property Let CsHNo(ByVal vNewValue As Variant)

    mintCsHNo = vNewValue
    
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

Friend Property Let Price(ByVal vNewValue As Variant)

    mlngPrice = vNewValue
    
End Property

Private Sub cmdOk_Click()

    'データ適用処理を行う（エラー時は画面を閉じない）
    If ApplyData() = False Then
        Exit Sub
    End If

    '画面を閉じる
    Unload Me
    
End Sub

Private Sub Form_Load()

    Dim i As Integer
    
    mblnUpdate = False
    
    '表示用フォーム初期化
    Call InitializeForm

End Sub

' @(e)
'
' 機能　　 : データの保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 変更されたデータをテーブルに保存する
'
' 備考　　 :
'
Private Function ApplyData() As Boolean

    ApplyData = False
    
    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then Exit Function
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    Do
        '入力チェック
        If CheckValue() = False Then Exit Do
        
        'コーステーブルの登録
        If RegistCourse_h() = False Then Exit Do
        
        '更新済みフラグ成立
        mblnUpdate = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    

End Function
' @(e)
'
' 機能　　 : コース基本情報の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容をコーステーブルに保存する。
'
' 備考　　 :
'
Private Function RegistCourse_h() As Boolean

On Error GoTo ErrorHandle

    Dim objCourse       As Object   'コースアクセス用
    Dim lngRet          As Long
    
    RegistCourse_h = False

    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")

    'コース履歴管理テーブルレコードの登録
    lngRet = objCourse.RegistCourse_h(IIf(mintCsHNo = -1, "INS", "UPD"), _
                                      mstrCsCd, _
                                      mintCsHNo, _
                                      CDate(mstrStrDate), _
                                      CDate(mstrEndDate), _
                                      mlngPrice)
    
    If lngRet <> INSERT_NORMAL Then
        
        Select Case lngRet
            
            Case INSERT_DUPLICATE
                MsgBox "履歴番号が最大に達しました。これ以上履歴を管理することができません。", vbExclamation
            
            Case INSERT_HISTORYDUPLICATE
                MsgBox "日付が重複している履歴が存在します。履歴設定を再入力してください。", vbExclamation
            
            Case Else
                MsgBox "テーブル更新時にエラーが発生しました。", vbCritical
    
        End Select
        Exit Function
    End If
    
    
    RegistCourse_h = True
    
    Exit Function
    
ErrorHandle:

    RegistCourse_h = False
    MsgBox Err.Description, vbCritical
    
End Function


' @(e)
'
' 機能　　 : 登録データのチェック
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容の妥当性をチェックする
'
' 備考　　 :
'
Private Function CheckValue() As Boolean

    Dim Ret             As Boolean  '関数戻り値
    Dim strStrDate      As String
    Dim strEndDate      As String
    Dim strWorkDate     As String
    
    '初期処理
    Ret = False
    
    Do

        '余白などを除いて再格納
        txtPrice.Text = Trim(txtPrice.Text)
        
        'コース基本料金が設定されていないなら、\0とする
        If Trim(txtPrice.Text) = "" Then
            txtPrice.Text = 0
        End If

        'コース基本料金の数値チェック
        If IsNumeric(txtPrice.Text) = False Then
            MsgBox "コース基本料金には数値を入力してください", vbExclamation, App.Title
            txtPrice.SetFocus
            Exit Do
        End If

        '小数点は切り捨てる
        txtPrice.Text = Fix(CLng(txtPrice.Text))

        '金額上限チェック
        If CLng(txtPrice.Text) >= 10000000 Then
            MsgBox "コース基本料金には\10,000,000以上の金額を指定することはできません。", vbExclamation, App.Title
            txtPrice.SetFocus
            Exit Do
        End If
        
        strStrDate = cboStrYear.List(cboStrYear.ListIndex) & "/" & _
                     Format(cboStrMonth.List(cboStrMonth.ListIndex), "00") & "/" & _
                     Format(cboStrDay.List(cboStrDay.ListIndex), "00")

        strEndDate = cboEndYear.List(cboEndYear.ListIndex) & "/" & _
                     Format(cboEndMonth.List(cboEndMonth.ListIndex), "00") & "/" & _
                     Format(cboEndDay.List(cboEndDay.ListIndex), "00")

        '日付整合性のチェック
        If IsDate(strStrDate) = False Then
            MsgBox "正しい開始日付を入力してください", vbExclamation, App.Title
            cboStrYear.SetFocus
            Exit Do
        End If
        
        If IsDate(strEndDate) = False Then
            MsgBox "正しい終了日付を入力してください", vbExclamation, App.Title
            cboEndYear.SetFocus
            Exit Do
        End If
        
        '日付の大小チェック
        If CDate(strStrDate) > CDate(strEndDate) Then
            
            If MsgBox("開始終了日付が逆転しています。入れ替えて保存しますか？", vbYesNo + vbQuestion) = vbNo Then
                cboStrYear.SetFocus
                Exit Do
            Else
                '開始終了日付の再セット
                cboStrYear.ListIndex = CLng(Mid(strEndDate, 1, 4)) - YEARRANGE_MIN
                cboStrMonth.ListIndex = CLng(Mid(strEndDate, 6, 2)) - 1
                cboStrDay.ListIndex = CLng(Mid(strEndDate, 9, 2)) - 1
            
                cboEndYear.ListIndex = CLng(Mid(strStrDate, 1, 4)) - YEARRANGE_MIN
                cboEndMonth.ListIndex = CLng(Mid(strStrDate, 6, 2)) - 1
                cboEndDay.ListIndex = CLng(Mid(strStrDate, 9, 2)) - 1
                
                strWorkDate = strStrDate
                strStrDate = strEndDate
                strEndDate = strWorkDate
            
            End If
        
        End If
        
        'モジュールレベル変数へ再格納
        mstrStrDate = strStrDate
        mstrEndDate = strEndDate
        mlngPrice = txtPrice.Text
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function




Private Sub InitializeForm()
    
    Dim i As Integer
    
    'コントロール初期化
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
    
    '更新モード時の日付をセットされている場合、デフォルトセット
    If Trim(mstrStrDate) <> "" Then
        If (CLng(Mid(mstrStrDate, 1, 4)) - YEARRANGE_MIN) >= 0 Then
            cboStrYear.ListIndex = CLng(Mid(mstrStrDate, 1, 4)) - YEARRANGE_MIN
        Else
            cboStrYear.ListIndex = 0
        End If
        cboStrMonth.ListIndex = CLng(Mid(mstrStrDate, 6, 2)) - 1
        cboStrDay.ListIndex = CLng(Mid(mstrStrDate, 9, 2)) - 1
    Else
        cboStrYear.ListIndex = 0
        cboStrMonth.ListIndex = 0
        cboStrDay.ListIndex = 0
    End If

    '更新モード時の日付をセットされている場合、デフォルトセット
    If Trim(mstrEndDate) <> "" Then
        If (CLng(Mid(mstrEndDate, 1, 4)) - YEARRANGE_MIN) >= 0 Then
            cboEndYear.ListIndex = CLng(Mid(mstrEndDate, 1, 4)) - YEARRANGE_MIN
        Else
            cboEndYear.ListIndex = 0
        End If
        cboEndMonth.ListIndex = CLng(Mid(mstrEndDate, 6, 2)) - 1
        cboEndDay.ListIndex = CLng(Mid(mstrEndDate, 9, 2)) - 1
    Else
        cboEndYear.ListIndex = cboEndYear.ListCount - 1
        cboEndMonth.ListIndex = cboEndMonth.ListCount - 1
        cboEndDay.ListIndex = cboEndDay.ListCount - 1
    End If
    
    '金額セット
    txtPrice.Text = mlngPrice

    cboHistory.Clear

    '新規、更新モードに応じて画面制御
    If mintCsHNo = -1 Then
        fraMain.Caption = "新規作成"
    Else
        fraMain.Caption = "履歴No:" & mintCsHNo
        cboHistory.Enabled = False
        LabelItem.ForeColor = vbGrayText
    End If

End Sub

Friend Property Get Updated() As Variant

    Updated = mblnUpdate
    
End Property

