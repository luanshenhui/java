VERSION 5.00
Begin VB.Form frmStdJud 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "定型所見テーブルメンテナンス"
   ClientHeight    =   1800
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5970
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmStdJud.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1800
   ScaleWidth      =   5970
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboJudClass 
      Height          =   300
      ItemData        =   "frmStdJud.frx":000C
      Left            =   1680
      List            =   "frmStdJud.frx":002E
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   1
      Top             =   120
      Width           =   4050
   End
   Begin VB.TextBox txtStdJudNote 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   25
      TabIndex        =   5
      Text            =   "＠＠＠＠"
      Top             =   840
      Width           =   4035
   End
   Begin VB.TextBox txtStdJudCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   3
      TabIndex        =   3
      Text            =   "@@"
      Top             =   480
      Width           =   435
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2940
      TabIndex        =   6
      Top             =   1260
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4380
      TabIndex        =   7
      Top             =   1260
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "判定分類(&J):"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "定型所見内容(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   4
      Top             =   900
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "定型所見コード(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
End
Attribute VB_Name = "frmStdJud"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mintJudClassCd      As Integer  '判定分類コード
Private mintStdJudCd        As Integer  '定型所見コード

Private mblnInitialize      As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mintArrJudClassCd() As Integer  '判定分類コンボに対応する判定分類コード

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let JudClassCd(ByVal vntNewValue As Integer)

    mintJudClassCd = vntNewValue
    
End Property

Friend Property Let StdJudCd(ByVal vntNewValue As Integer)

    mintStdJudCd = vntNewValue
    
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
        If Trim(txtStdJudCd.Text) = "" Then
            MsgBox "定型所見コードが入力されていません。", vbCritical, App.Title
            txtStdJudCd.SetFocus
            Exit Do
        End If

        'コードの数値チェック
        If IsNumeric(txtStdJudCd.Text) = False Then
            MsgBox "定型所見コードには数値を入力してください。", vbCritical, App.Title
            txtStdJudCd.SetFocus
            Exit Do
        End If

        'コードの数値チェック２
        If CInt(txtStdJudCd.Text) < 1 Then
            MsgBox "定型所見コードには負数、ゼロを指定することはできません。", vbCritical, App.Title
            txtStdJudCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtStdJudNote.Text) = "" Then
            MsgBox "定型所見名が入力されていません。", vbCritical, App.Title
            txtStdJudNote.SetFocus
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
Private Function EditStdJud() As Boolean

    Dim objStdJud       As Object           '定型所見アクセス用
    Dim vntStdJudNote   As Variant          '定型所見名
    Dim vntEntryOk      As Variant          '入力完了フラグ
    Dim Ret             As Boolean          '戻り値
    Dim i               As Integer
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objStdJud = CreateObject("HainsStdJud.StdJud")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mintStdJudCd = 0 Then
            Ret = True
            Exit Do
        End If
        
        '定型所見テーブルレコード読み込み
        If objStdJud.SelectStdJud(mintJudClassCd, mintStdJudCd, vntStdJudNote) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtStdJudCd.Text = mintStdJudCd
        txtStdJudNote.Text = vntStdJudNote
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditStdJud = Ret
    
    Exit Function

ErrorHandle:

    EditStdJud = False
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
Private Function RegistStdJud() As Boolean

On Error GoTo ErrorHandle

    Dim objStdJud   As Object       '定型所見アクセス用
    Dim Ret         As Long
    
    'オブジェクトのインスタンス作成
    Set objStdJud = CreateObject("HainsStdJud.StdJud")
    
    '定型所見テーブルレコードの登録
    Ret = objStdJud.RegistStdJud(IIf(txtStdJudCd.Enabled, "INS", "UPD"), _
                                 mintArrJudClassCd(cboJudClass.ListIndex), _
                                 Trim(txtStdJudCd.Text), _
                                 Trim(txtStdJudNote.Text))

    If Ret = 0 Then
        MsgBox "入力された定型所見コードは既に存在します。", vbExclamation
        RegistStdJud = False
        Exit Function
    End If
    
    RegistStdJud = True
    
    Exit Function
    
ErrorHandle:

    RegistStdJud = False
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
        
        '定型所見テーブルの登録
        If RegistStdJud() = False Then
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
        '判定分類情報の画面セット
        If SetJudClass() < 1 Then
            MsgBox "判定分類が一つも登録されていません。判定分類を登録してから再度この処理を行ってください。", vbExclamation
            cmdOk.Enabled = False
            Exit Do
        End If
        
        '定型所見情報の編集
        If EditStdJud() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtStdJudCd.Enabled = (txtStdJudCd.Text = "")
        cboJudClass.Enabled = (txtStdJudCd.Text = "")
        
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
    
    'リストの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mintArrJudClassCd(i)
        mintArrJudClassCd(i) = vntJudClassCd(i)
        cboJudClass.AddItem vntJudClassName(i)
        If vntJudClassCd(i) = mintJudClassCd Then
            intTargetIndex = i
        End If
    Next i
    
    'オブジェクト廃棄
    Set objJudClass = Nothing
    
    If lngCount > 0 Then
        cboJudClass.ListIndex = intTargetIndex
    End If
    
    SetJudClass = lngCount
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

