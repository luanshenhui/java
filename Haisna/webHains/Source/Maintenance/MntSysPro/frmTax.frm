VERSION 5.00
Begin VB.Form frmTax 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "適用税額の設定"
   ClientHeight    =   1890
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   4695
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmTax.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1890
   ScaleWidth      =   4695
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.TextBox txtTax 
      Alignment       =   1  '右揃え
      Height          =   315
      Index           =   1
      Left            =   3420
      MaxLength       =   6
      TabIndex        =   11
      Text            =   "0.5"
      Top             =   780
      Width           =   615
   End
   Begin VB.TextBox txtTax 
      Alignment       =   1  '右揃え
      Height          =   315
      Index           =   0
      Left            =   1320
      MaxLength       =   6
      TabIndex        =   9
      Text            =   "0.5"
      Top             =   240
      Width           =   615
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmTax.frx":000C
      Left            =   240
      List            =   "frmTax.frx":0013
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   4
      Top             =   780
      Width           =   735
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmTax.frx":001D
      Left            =   1260
      List            =   "frmTax.frx":0024
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   3
      Top             =   780
      Width           =   555
   End
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmTax.frx":002C
      Left            =   2160
      List            =   "frmTax.frx":0033
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   2
      Top             =   780
      Width           =   555
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3180
      TabIndex        =   1
      Top             =   1440
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1740
      TabIndex        =   0
      Top             =   1440
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "％"
      Height          =   180
      Index           =   1
      Left            =   4080
      TabIndex        =   12
      Top             =   840
      Width           =   390
   End
   Begin VB.Label Label1 
      Caption         =   "％"
      Height          =   180
      Index           =   2
      Left            =   1980
      TabIndex        =   10
      Top             =   300
      Width           =   390
   End
   Begin VB.Label Label1 
      Caption         =   "基本税額(&B):"
      Height          =   180
      Index           =   0
      Left            =   240
      TabIndex        =   8
      Top             =   300
      Width           =   1110
   End
   Begin VB.Label Label8 
      Caption         =   "年"
      Height          =   255
      Index           =   0
      Left            =   1020
      TabIndex        =   7
      Top             =   840
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "月"
      Height          =   255
      Index           =   1
      Left            =   1860
      TabIndex        =   6
      Top             =   840
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "日以降"
      Height          =   255
      Index           =   3
      Left            =   2760
      TabIndex        =   5
      Top             =   840
      Width           =   555
   End
End
Attribute VB_Name = "frmTax"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrFreeCd      As String   '都道府県コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnModeNew     As Boolean  'TRUE:新規、FALSE:更新

Private mintField1      As Integer
Private mintField2      As Integer
Private mdtnFreeDate    As Date

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

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

    Dim Ret         As Boolean  '関数戻り値
    Dim blnRet      As Boolean
    Dim i           As Integer
    
    CheckValue = False
    
        
    For i = 0 To 1
    
        'トリミング
        txtTax(i).Text = Trim(txtTax(i).Text)
    
        '空白チェック
        If txtTax(i).Text = "" Then
            MsgBox "税率が入力されていません。", vbCritical, App.Title
            txtTax(i).SetFocus
            Exit Function
        End If
    
        '数値チェック
        If IsNumeric(txtTax(i).Text) = False Then
            MsgBox "税率には数値を入力してください。", vbCritical, App.Title
            txtTax(i).SetFocus
            Exit Function
        End If
    
        '範囲チェック
        If (CDbl(txtTax(i).Text) > 100) Or (CDbl(txtTax(i).Text) < 0) Then
            MsgBox "有効な税率を入力してください。", vbCritical, App.Title
            txtTax(i).SetFocus
            Exit Function
        End If
    
    Next i
        
    
    '戻り値の設定
    CheckValue = True
    
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
    
    mdtnFreeDate = CDate((cboYear.List(cboYear.ListIndex) & "/" & cboMonth.List(cboMonth.ListIndex) & "/" & cboDay.List(cboDay.ListIndex)))
    
    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")

    '汎用テーブルレコードの登録
    If mblnModeNew = True Then
    
        '新規登録
        Ret = objFree.InsertFree(SYSPRO_TAX_KEY, _
                                 SYSPRO_COMMON_CLASS, _
                                 SYSPRO_TAX_NAME, _
                                 mdtnFreeDate, _
                                 (txtTax(0).Text / 100), _
                                 (txtTax(1).Text / 100))
        
    
    Else
    
        '更新
        Ret = objFree.UpdateFree(SYSPRO_TAX_KEY, _
                                 SYSPRO_COMMON_CLASS, _
                                 SYSPRO_TAX_NAME, _
                                 mdtnFreeDate, _
                                 (txtTax(0).Text / 100), _
                                 (txtTax(1).Text / 100))
    
        If Ret = True Then Ret = INSERT_NORMAL
        
    End If

    If Ret <> INSERT_NORMAL Then
        MsgBox "データ更新時にエラーが発生しました。", vbCritical
        RegistFree = False
        Exit Function
    End If

    'データ存在のため、更新モード
    mblnModeNew = False
    
    RegistFree = True
    
    Exit Function
    
ErrorHandle:

    RegistFree = False
    MsgBox Err.Description, vbCritical
    
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
    
    Dim lngMode         As Long
    Dim strFreeCdKey    As String
    Dim vntFreeCd       As Variant
    Dim vntFreeName     As Variant
    Dim vntFreeDate     As Variant
    Dim vntFreeField1   As Variant
    Dim vntFreeField2   As Variant

    Dim Ret             As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")
    
    Do
        
        '消費税額レコード読み込み
        If objFree.SelectFree(0, _
                              SYSPRO_TAX_KEY, _
                              vntFreeCd, _
                              vntFreeName, _
                              vntFreeDate, _
                              vntFreeField1, _
                              vntFreeField2) = False Then
            
            'データなしでも、画面は開く
            Ret = True
            Exit Do
        End If
    
        'データ存在のため、更新モード
        mblnModeNew = False
    
        '読み込み内容の編集
        If IsDate(vntFreeDate) Then
            mdtnFreeDate = vntFreeDate
        End If
        
        If IsNumeric(vntFreeField1) Then
            txtTax(0).Text = vntFreeField1 * 100
        End If

        If IsNumeric(vntFreeField2) Then
            txtTax(1).Text = vntFreeField2 * 100
        End If

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
        
        'データの登録
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
    Dim i   As Integer
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    mblnModeNew = True

    mdtnFreeDate = Now
    mintField1 = 1
    mintField2 = 2
    
    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)
    
    Do
        '汎用テーブルからのデータ編集
        If EditFree() = False Then
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    'コンボボックスに値をセット
    With cboYear
        .Clear
        For i = YEARRANGE_MIN To YEARRANGE_MAX
            .AddItem i
            If (i = Year(mdtnFreeDate)) And _
               (YEARRANGE_MIN <= Year(mdtnFreeDate)) And _
               (YEARRANGE_MAX >= Year(mdtnFreeDate)) Then
                .ListIndex = i - YEARRANGE_MIN
            End If
        Next i
    End With
    
    With cboMonth
        .Clear
        For i = 1 To 12
            .AddItem i
            If i = Month(mdtnFreeDate) Then
                .ListIndex = i - 1
            End If
        Next i
    End With
    
    With cboDay
        .Clear
        For i = 1 To 31
            .AddItem i
            If i = Day(mdtnFreeDate) Then
                .ListIndex = i - 1
            End If
        Next i
    End With
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub


