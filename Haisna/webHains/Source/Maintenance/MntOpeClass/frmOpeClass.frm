VERSION 5.00
Begin VB.Form frmOpeClass 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "検査実施日分類テーブルメンテナンス"
   ClientHeight    =   1830
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5805
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmOpeClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1830
   ScaleWidth      =   5805
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.TextBox txtOrderCntl 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   2220
      MaxLength       =   12
      TabIndex        =   5
      Text            =   "123456789012"
      Top             =   840
      Width           =   1215
   End
   Begin VB.TextBox txtOpeClassName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   2220
      MaxLength       =   15
      TabIndex        =   3
      Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
      Top             =   480
      Width           =   3075
   End
   Begin VB.TextBox txtOpeClassCd 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   2220
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@@"
      Top             =   120
      Width           =   495
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2940
      TabIndex        =   6
      Top             =   1320
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4380
      TabIndex        =   7
      Top             =   1320
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "オーダ制御用番号(&O)"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   4
      Top             =   900
      Width           =   1770
   End
   Begin VB.Label Label1 
      Caption         =   "検査実施日分類名(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1770
   End
   Begin VB.Label Label1 
      Caption         =   "検査実施日分類コード(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   2010
   End
End
Attribute VB_Name = "frmOpeClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrOpeClassCd  As String   '検査実施日分類コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let OpeClassCd(ByVal vntNewValue As Variant)

    mstrOpeClassCd = vntNewValue
    
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
        If Trim(txtOpeClassCd.Text) = "" Then
            MsgBox "検査実施日分類コードが入力されていません。", vbCritical, App.Title
            txtOpeClassCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtOpeClassName.Text) = "" Then
            MsgBox "検査実施日分類名が入力されていません。", vbCritical, App.Title
            txtOpeClassName.SetFocus
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
Private Function EditOpeClass() As Boolean

    Dim objOpeClass     As Object           '検査実施日分類アクセス用
    Dim vntOpeClassName As Variant          '検査実施日分類名
    Dim vntOrderCntl    As Variant          'オーダ制御用番号
    Dim Ret             As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objOpeClass = CreateObject("HainsOpeClass.OpeClass")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrOpeClassCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '検査実施日分類テーブルレコード読み込み
        If objOpeClass.SelectOpeClass(mstrOpeClassCd, vntOpeClassName, vntOrderCntl) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtOpeClassCd.Text = mstrOpeClassCd
        txtOpeClassName.Text = vntOpeClassName
        txtOrderCntl.Text = vntOrderCntl
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditOpeClass = Ret
    
    Exit Function

ErrorHandle:

    EditOpeClass = False
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
Private Function RegistOpeClass() As Boolean

On Error GoTo ErrorHandle

    Dim objOpeClass As Object       '検査実施日分類アクセス用
    Dim Ret         As Long
    
    'オブジェクトのインスタンス作成
    Set objOpeClass = CreateObject("HainsOpeClass.OpeClass")
    
    '検査実施日分類テーブルレコードの登録
    Ret = objOpeClass.RegistOpeClass(IIf(txtOpeClassCd.Enabled, "INS", "UPD"), _
                                     Trim(txtOpeClassCd.Text), _
                                     Trim(txtOpeClassName.Text), _
                                     Trim(txtOrderCntl.Text))

    If Ret = 0 Then
        MsgBox "入力された検査実施日分類コードは既に存在します。", vbExclamation
        RegistOpeClass = False
        Exit Function
    End If
    
    RegistOpeClass = True
    
    Exit Function
    
ErrorHandle:

    RegistOpeClass = False
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
        
        '検査実施日分類テーブルの登録
        If RegistOpeClass() = False Then
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
        '検査実施日分類情報の編集
        If EditOpeClass() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtOpeClassCd.Enabled = (txtOpeClassCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

