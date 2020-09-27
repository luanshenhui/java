VERSION 5.00
Begin VB.Form frmGuidance 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "指導内容テーブルメンテナンス"
   ClientHeight    =   2895
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7500
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmGuidance.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2895
   ScaleWidth      =   7500
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboJudClass 
      Height          =   300
      ItemData        =   "frmGuidance.frx":000C
      Left            =   1680
      List            =   "frmGuidance.frx":002E
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   5
      Top             =   1980
      Width           =   4050
   End
   Begin VB.TextBox txtGuidanceStc 
      Height          =   1440
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   250
      MultiLine       =   -1  'True
      TabIndex        =   3
      Text            =   "frmGuidance.frx":0050
      Top             =   480
      Width           =   5715
   End
   Begin VB.TextBox txtGuidanceCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   8
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   1455
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4620
      TabIndex        =   6
      Top             =   2460
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   6060
      TabIndex        =   7
      Top             =   2460
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "判定分類(&J):"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   4
      Top             =   2040
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "指導内容(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "指導内容コード(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmGuidance"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrJudClassCd      As String  '判定分類コード
Private mstrGuidanceCd      As String   '指導内容コード

Private mblnInitialize      As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mstrArrJudClassCd() As String  '判定分類コンボに対応する判定分類コード

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let JudClassCd(ByVal vntNewValue As Integer)

    mstrJudClassCd = vntNewValue
    
End Property

Friend Property Let GuidanceCd(ByVal vntNewValue As String)

    mstrGuidanceCd = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

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
        'コードの入力チェック
        If Trim(txtGuidanceCd.Text) = "" Then
            MsgBox "指導内容コードが入力されていません。", vbCritical, App.Title
            txtGuidanceCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtGuidanceStc.Text) = "" Then
            MsgBox "指導内容名が入力されていません。", vbCritical, App.Title
            txtGuidanceStc.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

'
' 機能　　 : データ表示用編集
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditGuidance() As Boolean

    Dim objGuidance         As Object           '指導内容アクセス用
    Dim vntGuidanceStc      As Variant          '指導内容名
    Dim vntJudClassCd       As Variant          '指導内容名
    Dim vntEntryOk          As Variant          '入力完了フラグ
    Dim Ret                 As Boolean          '戻り値
    Dim i                   As Integer
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objGuidance = CreateObject("HainsGuidance.Guidance")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If Trim(mstrGuidanceCd) = "" Then
            Ret = True
            Exit Do
        End If
        
        '指導内容テーブルレコード読み込み
'### 2003.01.17 Updated by Ishihara@FSIT 判定分類はNULLあり
'        If objGuidance.SelectGuidance(mstrGuidanceCd, vntGuidanceStc, CInt(vntJudClassCd)) = False Then
        If objGuidance.SelectGuidance(mstrGuidanceCd, vntGuidanceStc, vntJudClassCd) = False Then
'### 2003.01.17 Updated End
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtGuidanceCd.Text = mstrGuidanceCd
        txtGuidanceStc.Text = vntGuidanceStc
'### 2003.01.17 Updated by Ishihara@FSIT 判定分類はNULLあり
'        mstrJudClassCd = CInt(vntJudClassCd)
        mstrJudClassCd = vntJudClassCd
'### 2003.01.17 Updated End
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditGuidance = Ret
    
    Exit Function

ErrorHandle:

    EditGuidance = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : データ登録
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function RegistGuidance() As Boolean

On Error GoTo ErrorHandle

    Dim objGuidance   As Object       '指導内容アクセス用
    Dim Ret         As Long
    
    'オブジェクトのインスタンス作成
    Set objGuidance = CreateObject("HainsGuidance.Guidance")
    
    '指導内容テーブルレコードの登録
    Ret = objGuidance.RegistGuidance(IIf(txtGuidanceCd.Enabled, "INS", "UPD"), _
                                 Trim(txtGuidanceCd.Text), _
                                 Trim(txtGuidanceStc.Text), _
                                 mstrArrJudClassCd(cboJudClass.ListIndex))

    If Ret = 0 Then
        MsgBox "入力された指導内容コードは既に存在します。", vbExclamation
        RegistGuidance = False
        Exit Function
    End If
    
    RegistGuidance = True
    
    Exit Function
    
ErrorHandle:

    RegistGuidance = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : 「キャンセル」Click
'
' 機能説明 : フォームを閉じる
'
' 備考　　 :
'
Private Sub CMDcancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : 「ＯＫ」クリック
'
' 引数　　 : なし
'
' 機能説明 : 入力内容を適用し、画面を閉じる
'
' 備考　　 :
'
Private Sub CMDok_Click()

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    Do
        '入力チェック
        If CheckValue() = False Then
            Exit Do
        End If
        
        '指導内容テーブルの登録
        If RegistGuidance() = False Then
            Exit Do
        End If
            
        '更新済みフラグをTRUEに
        mblnUpdated = True
    
        '画面を閉じる
        Unload Me
        
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

' @(e)
'
' 機能　　 : 「フォーム」Load
'
' 機能説明 : フォームの初期表示を行う
'
' 備考　　 :
'
Private Sub Form_Load()

    Dim Ret As Boolean  '戻り値
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    
    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    Do
        
        '指導内容情報の編集
        If EditGuidance() = False Then
            Exit Do
        End If
    
        '判定分類情報の画面セット
        If SetJudClass() < 1 Then
            MsgBox "判定分類が一つも登録されていません。判定分類を登録してから再度この処理を行ってください。", vbExclamation
            cmdOk.Enabled = False
            Exit Do
        End If
    
        'イネーブル設定
        txtGuidanceCd.Enabled = (txtGuidanceCd.Text = "")
'        cboJudClass.Enabled = (txtGuidanceCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

'
' 機能　　 : 判定分類コンボセット
'
' 引数　　 :
'
' 戻り値　 : 判定分類登録数
'
' 備考　　 :
'
Private Function SetJudClass() As Long

On Error GoTo ErrorHandle

    Dim objJudClass     As Object           '結果コメントアクセス用
    Dim vntJudClassCd   As Variant          '結果コメントコード
    Dim vntJudClassName As Variant          '結果コメント名
    Dim lngCount        As Long             'レコード数
    Dim i               As Long             'インデックス
    Dim intTargetIndex  As Integer
    
    SetJudClass = 0
    intTargetIndex = 0
    
    'オブジェクトのインスタンス作成
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)
    
    cboJudClass.Clear
    
'### 2003.01.17 Updated by Ishihara@FSIT 判定分類はNULLあり
    '判定分類はNullあり
    i = 0
    ReDim Preserve mstrArrJudClassCd(i)
    mstrArrJudClassCd(i) = ""
    cboJudClass.AddItem ""
'### 2003.01.17 Updated End
    
    'リストの編集
    For i = 1 To lngCount - 1
        ReDim Preserve mstrArrJudClassCd(i)
        mstrArrJudClassCd(i) = vntJudClassCd(i)
        cboJudClass.AddItem vntJudClassName(i)
        If vntJudClassCd(i) = mstrJudClassCd Then
            intTargetIndex = i
        End If
    Next i
    
    'オブジェクト廃棄
    Set objJudClass = Nothing
    
    If lngCount > 1 Then
        cboJudClass.ListIndex = intTargetIndex
    End If
    
    SetJudClass = lngCount
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

