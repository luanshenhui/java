VERSION 5.00
Begin VB.Form frmFree 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "汎用テーブルメンテナンス"
   ClientHeight    =   6045
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6405
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmFree.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6045
   ScaleWidth      =   6405
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.TextBox txtFreeField7 
      Height          =   480
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   26
      Text            =   "frmFree.frx":000C
      Top             =   4980
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField6 
      Height          =   480
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   24
      Text            =   "frmFree.frx":003F
      Top             =   4440
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField5 
      Height          =   480
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   22
      Text            =   "frmFree.frx":0072
      Top             =   3900
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField4 
      Height          =   480
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   20
      Text            =   "frmFree.frx":00A5
      Top             =   3360
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField3 
      Height          =   480
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   18
      Text            =   "frmFree.frx":00D8
      Top             =   2820
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField2 
      Height          =   480
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   16
      Text            =   "frmFree.frx":010B
      Top             =   2280
      Width           =   4635
   End
   Begin VB.TextBox txtFreeField1 
      Height          =   480
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   300
      MultiLine       =   -1  'True
      TabIndex        =   14
      Text            =   "frmFree.frx":013E
      Top             =   1740
      Width           =   4635
   End
   Begin VB.TextBox txtFreeClassCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   3
      Text            =   "@@@"
      Top             =   480
      Width           =   555
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmFree.frx":0171
      Left            =   1680
      List            =   "frmFree.frx":0178
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   7
      Top             =   1260
      Width           =   735
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmFree.frx":0182
      Left            =   2700
      List            =   "frmFree.frx":0189
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   9
      Top             =   1260
      Width           =   555
   End
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmFree.frx":0191
      Left            =   3600
      List            =   "frmFree.frx":0198
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   11
      Top             =   1260
      Width           =   555
   End
   Begin VB.TextBox txtFreeName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   25
      TabIndex        =   5
      Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
      Top             =   900
      Width           =   4635
   End
   Begin VB.TextBox txtFreeCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   12
      TabIndex        =   1
      Text            =   "@@@@@@@@@@@@"
      Top             =   120
      Width           =   1635
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3540
      TabIndex        =   27
      Top             =   5640
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4980
      TabIndex        =   28
      Top             =   5640
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "汎用フィールド７(&7):"
      Height          =   240
      Index           =   10
      Left            =   120
      TabIndex        =   25
      Top             =   5040
      Width           =   1470
   End
   Begin VB.Label Label1 
      Caption         =   "汎用フィールド６(&6):"
      Height          =   240
      Index           =   9
      Left            =   120
      TabIndex        =   23
      Top             =   4500
      Width           =   1470
   End
   Begin VB.Label Label1 
      Caption         =   "汎用フィールド５(&5):"
      Height          =   240
      Index           =   8
      Left            =   120
      TabIndex        =   21
      Top             =   3960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "汎用フィールド４(&4):"
      Height          =   240
      Index           =   7
      Left            =   120
      TabIndex        =   19
      Top             =   3420
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "汎用フィールド３(&3):"
      Height          =   240
      Index           =   6
      Left            =   120
      TabIndex        =   17
      Top             =   2880
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "汎用フィールド２(&2):"
      Height          =   240
      Index           =   5
      Left            =   120
      TabIndex        =   15
      Top             =   2340
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "汎用分類コード(&B):"
      Height          =   180
      Index           =   4
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "汎用フィールド１(&1):"
      Height          =   240
      Index           =   3
      Left            =   120
      TabIndex        =   13
      Top             =   1800
      Width           =   1410
   End
   Begin VB.Label Label8 
      Caption         =   "年"
      Height          =   255
      Index           =   0
      Left            =   2460
      TabIndex        =   8
      Top             =   1320
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "月"
      Height          =   255
      Index           =   1
      Left            =   3300
      TabIndex        =   10
      Top             =   1320
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "日"
      Height          =   255
      Index           =   3
      Left            =   4200
      TabIndex        =   12
      Top             =   1320
      Width           =   555
   End
   Begin VB.Label Label1 
      Caption         =   "汎用日付(&D):"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   6
      Top             =   1320
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "汎用名(&N):"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   4
      Top             =   960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "汎用コード(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmFree"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrFreeCd              As String       '汎用コード
Private mblnInitialize          As Boolean      'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean      'TRUE:更新あり、FALSE:更新なし

Private mstrFreeDate            As String       '汎用日付

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Public Property Let FreeCd(ByVal vntNewValue As Variant)

    mstrFreeCd = vntNewValue

End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Get Initialize() As Boolean

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

    Dim Ret         As Boolean      '関数戻り値
    Dim strDate     As String       '日付チェック用文字列
    
    Ret = False
    
    Do
        'コードの入力チェック
        If Trim(txtFreeCd.Text) = "" Then
            MsgBox "汎用コードが入力されていません。", vbCritical, App.Title
            txtFreeCd.SetFocus
            Exit Do
        End If

        '汎用分類コードの入力チェック
        If Trim(txtFreeClassCd.Text) = "" Then
            MsgBox "汎用分類コードが入力されていません。(不明な場合は""XXX""をセットしてください)", vbCritical, App.Title
            txtFreeClassCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtFreeName.Text) = "" Then
            MsgBox "汎用名が入力されていません。", vbCritical, App.Title
            txtFreeName.SetFocus
            Exit Do
        End If

        '日付コンボがどれかひとつでも選択されている場合
        If (cboYear.ListIndex > 0) Or _
           (cboMonth.ListIndex > 0) Or _
           (cboDay.ListIndex > 0) Then
        
            strDate = cboYear.List(cboYear.ListIndex) & "/" & _
                      Format(cboMonth.List(cboMonth.ListIndex), "00") & "/" & _
                      Format(cboDay.List(cboDay.ListIndex), "00")
    
            '日付整合性のチェック
            If IsDate(strDate) = False Then
                MsgBox "正しい日付を入力してください", vbExclamation, App.Title
                cboMonth.SetFocus
                Exit Do
            End If
        
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
Private Function EditFree() As Boolean

    Dim objFree         As Object           '汎用テーブルアクセス用

    Dim vntFreeCd       As Variant
    Dim vntFreeClassCd  As Variant
    Dim vntFreeName     As Variant
    Dim vntFreeDate     As Variant
    Dim vntFreeField1   As Variant
    Dim vntFreeField2   As Variant
    Dim vntFreeField3   As Variant
    Dim vntFreeField4   As Variant
    Dim vntFreeField5   As Variant
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
    Dim vntFreeField6   As Variant
    Dim vntFreeField7   As Variant
'### 2003.02.15 Added End
    
    Dim Ret         As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrFreeCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '汎用テーブルレコード読み込み
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
'        If objFree.SelectFree(0, _
                              mstrFreeCd, _
                              vntFreeCd, _
                              vntFreeName, _
                              vntFreeDate, _
                              vntFreeField1, _
                              vntFreeField2, _
                              vntFreeField3, _
                              vntFreeField4, _
                              vntFreeField5, _
                              , _
                              vntFreeClassCd) = False Then
        If objFree.SelectFree(0, _
                              mstrFreeCd, _
                              vntFreeCd, _
                              vntFreeName, _
                              vntFreeDate, _
                              vntFreeField1, _
                              vntFreeField2, _
                              vntFreeField3, _
                              vntFreeField4, _
                              vntFreeField5, _
                              , _
                              vntFreeClassCd, _
                              vntFreeField6, _
                              vntFreeField7) = False Then
'### 2003.02.15 Added End
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtFreeCd.Text = mstrFreeCd
        txtFreeClassCd.Text = vntFreeClassCd
        txtFreeName.Text = vntFreeName
        mstrFreeDate = vntFreeDate
        txtFreeField1.Text = vntFreeField1
        txtFreeField2.Text = vntFreeField2
        txtFreeField3.Text = vntFreeField3
        txtFreeField4.Text = vntFreeField4
        txtFreeField5.Text = vntFreeField5
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
        txtFreeField6.Text = vntFreeField6
        txtFreeField7.Text = vntFreeField7
'### 2003.02.15 Added End
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditFree = Ret
    
    Exit Function

ErrorHandle:

    EditFree = False
    
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
Private Function RegistFree() As Boolean

    Dim objFree As Object       '汎用テーブルアクセス用
    Dim Ret     As Long
    
    On Error GoTo ErrorHandle
    
    If cboYear.ListIndex > 0 Then
        mstrFreeDate = CDate((cboYear.List(cboYear.ListIndex) & "/" & cboMonth.List(cboMonth.ListIndex) & "/" & cboDay.List(cboDay.ListIndex)))
    Else
        mstrFreeDate = ""
    End If
    
    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")

    '汎用テーブルレコードの登録
    If txtFreeCd.Enabled = True Then
    
        '新規登録
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
'        Ret = objFree.InsertFree(txtFreeCd.Text, _
                                 txtFreeClassCd.Text, _
                                 txtFreeName.Text, _
                                 mstrFreeDate, _
                                 txtFreeField1.Text, _
                                 txtFreeField2.Text, _
                                 txtFreeField3.Text, _
                                 txtFreeField4.Text, _
                                 txtFreeField5.Text)
        Ret = objFree.InsertFree(txtFreeCd.Text, _
                                 txtFreeClassCd.Text, _
                                 txtFreeName.Text, _
                                 mstrFreeDate, _
                                 txtFreeField1.Text, _
                                 txtFreeField2.Text, _
                                 txtFreeField3.Text, _
                                 txtFreeField4.Text, _
                                 txtFreeField5.Text, _
                                 txtFreeField6.Text, _
                                 txtFreeField7.Text)
'### 2003.02.15 Added End
    Else
    
        '更新
'### 2003.02.15 Added by Ishihara@FSIT フィールド追加
'        Ret = objFree.UpdateFree(txtFreeCd.Text, _
                                 txtFreeClassCd.Text, _
                                 txtFreeName.Text, _
                                 mstrFreeDate, _
                                 txtFreeField1.Text, _
                                 txtFreeField2.Text, _
                                 txtFreeField3.Text, _
                                 txtFreeField4.Text, _
                                 txtFreeField5.Text)
        Ret = objFree.UpdateFree(txtFreeCd.Text, _
                                 txtFreeClassCd.Text, _
                                 txtFreeName.Text, _
                                 mstrFreeDate, _
                                 txtFreeField1.Text, _
                                 txtFreeField2.Text, _
                                 txtFreeField3.Text, _
                                 txtFreeField4.Text, _
                                 txtFreeField5.Text, _
                                 txtFreeField6.Text, _
                                 txtFreeField7.Text)
'### 2003.02.15 Added End
    
        If Ret = True Then Ret = INSERT_NORMAL
        
    End If

    If Ret <> INSERT_NORMAL Then
        MsgBox "データ更新時にエラーが発生しました。", vbCritical
        RegistFree = False
        Exit Function
    End If

    '更新したため、コード入力欄は使用不可能
    txtFreeCd.Enabled = False
    
    RegistFree = True
    
    Exit Function
    
ErrorHandle:

    RegistFree = False
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
        
        '汎用テーブルの登録
        If RegistFree() = False Then
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
        '汎用情報の編集
        If EditFree() = False Then
            Exit Do
        End If
    
        '日付コンボ設定
        Call SetDayCombo
    
        'イネーブル設定
        txtFreeCd.Enabled = (txtFreeCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub SetDayCombo()

    Dim i       As Integer

    'コンボボックスに値をセット
    With cboYear
        .Clear
        .AddItem ""
        For i = YEARRANGE_MIN To YEARRANGE_MAX
            .AddItem i
            
            If mstrFreeDate <> "" Then
                If (i = Year(mstrFreeDate)) And _
                   (YEARRANGE_MIN <= Year(mstrFreeDate)) And _
                   (YEARRANGE_MAX >= Year(mstrFreeDate)) Then
                    .ListIndex = i - YEARRANGE_MIN + 1
                End If
            End If
        
        Next i
    End With
    
    With cboMonth
        .Clear
        .AddItem ""
        For i = 1 To 12
            .AddItem i
            If mstrFreeDate <> "" Then
                If i = Month(mstrFreeDate) Then
                    .ListIndex = i - 1 + 1
                End If
            End If
        Next i
    End With
    
    With cboDay
        .Clear
        .AddItem ""
        For i = 1 To 31
            .AddItem i
            If mstrFreeDate <> "" Then
                If i = Day(mstrFreeDate) Then
                    .ListIndex = i - 1 + 1
                End If
            End If
        Next i
    End With

End Sub
