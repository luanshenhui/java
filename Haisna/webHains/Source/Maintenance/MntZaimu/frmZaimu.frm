VERSION 5.00
Begin VB.Form frmZaimu 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "財務適用コードテーブルメンテナンス"
   ClientHeight    =   2700
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6945
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmZaimu.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2700
   ScaleWidth      =   6945
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CheckBox chkDisabled 
      Caption         =   "このコードを個人入金処理時に表示しない(&D)"
      Height          =   255
      Left            =   1740
      TabIndex        =   10
      Top             =   1680
      Width           =   4395
   End
   Begin VB.ComboBox cboZaimuClass 
      Height          =   300
      Left            =   1680
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   3
      Top             =   540
      Width           =   3375
   End
   Begin VB.ComboBox cboZaimuDiv 
      Height          =   300
      Left            =   1680
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   7
      Top             =   1260
      Width           =   3375
   End
   Begin VB.TextBox txtZaimuName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   60
      TabIndex        =   5
      Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
      Top             =   900
      Width           =   5115
   End
   Begin VB.TextBox txtZaimuCd 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1680
      MaxLength       =   5
      TabIndex        =   1
      Text            =   "@@@@@"
      Top             =   180
      Width           =   675
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4020
      TabIndex        =   8
      Top             =   2220
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5460
      TabIndex        =   9
      Top             =   2220
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "財務分類(&B):"
      Height          =   180
      Index           =   3
      Left            =   180
      TabIndex        =   2
      Top             =   600
      Width           =   1110
   End
   Begin VB.Label Label1 
      Caption         =   "財務種別(&S):"
      Height          =   180
      Index           =   2
      Left            =   180
      TabIndex        =   6
      Top             =   1320
      Width           =   1170
   End
   Begin VB.Label Label1 
      Caption         =   "財務適用名(&N):"
      Height          =   180
      Index           =   1
      Left            =   180
      TabIndex        =   4
      Top             =   960
      Width           =   1350
   End
   Begin VB.Label Label1 
      Caption         =   "財務適用コード(&C):"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   240
      Width           =   1530
   End
End
Attribute VB_Name = "frmZaimu"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrZaimuCd     As String   '財務コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let ZaimuCd(ByVal vntNewValue As Variant)

    mstrZaimuCd = vntNewValue
    
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
        If Trim(txtZaimuCd.Text) = "" Then
            MsgBox "財務コードが入力されていません。", vbCritical, App.Title
            txtZaimuCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtZaimuName.Text) = "" Then
            MsgBox "財務適用名が入力されていません。", vbCritical, App.Title
            txtZaimuName.SetFocus
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
Private Function EditZaimu() As Boolean

    Dim objZaimu        As Object           '財務アクセス用
    Dim vntZaimuName    As Variant          '財務名
    Dim vntZaimuDiv     As Variant          '財務種別
    Dim vntZaimuClass   As Variant          '財務分類
    Dim vntDisabled     As Variant          '未使用フラグ
    Dim Ret             As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrZaimuCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '財務テーブルレコード読み込み
        If objZaimu.SelectZaimu(mstrZaimuCd, vntZaimuName, vntZaimuDiv, vntZaimuClass, vntDisabled) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtZaimuCd.Text = mstrZaimuCd
        txtZaimuName.Text = vntZaimuName
        cboZaimuDiv.ListIndex = CInt(vntZaimuDiv) - 1
        cboZaimuClass.ListIndex = CInt(vntZaimuClass) - 1
        chkDisabled.Value = IIf(vntDisabled = "1", vbChecked, vbUnchecked)
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditZaimu = Ret
    
    Exit Function

ErrorHandle:

    EditZaimu = False
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
Private Function RegistZaimu() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu    As Object       '財務アクセス用
    Dim Ret         As Long
    
    'オブジェクトのインスタンス作成
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    
    '財務テーブルレコードの登録
    Ret = objZaimu.RegistZaimu(IIf(txtZaimuCd.Enabled, "INS", "UPD"), _
                                     Trim(txtZaimuCd.Text), _
                                     Trim(txtZaimuName.Text), _
                                     cboZaimuDiv.ListIndex + 1, _
                                     cboZaimuClass.ListIndex + 1, _
                                     IIf(chkDisabled.Value = vbChecked, "1", "0"))

    If Ret = 0 Then
        MsgBox "入力された財務適用コードは既に存在します。", vbExclamation
        RegistZaimu = False
        Exit Function
    End If
    
    RegistZaimu = True
    
    Exit Function
    
ErrorHandle:

    RegistZaimu = False
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
        
        '財務テーブルの登録
        If RegistZaimu() = False Then
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
    
    With cboZaimuClass
        .Clear
        .AddItem "個人"
        .AddItem "団体"
        .AddItem "電話料金"
        .AddItem "文書作成"
        .AddItem "その他収入"
        .ListIndex = 0
    End With

    With cboZaimuDiv
        .Clear
        .AddItem "未収"
        .AddItem "入金"
        .AddItem "過去未収金"
        .AddItem "還付"
        .AddItem "還付未払"
        .ListIndex = 0
    End With

    Do
        '財務情報の編集
        If EditZaimu() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtZaimuCd.Enabled = (txtZaimuCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

