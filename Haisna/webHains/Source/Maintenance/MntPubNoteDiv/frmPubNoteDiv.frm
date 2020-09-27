VERSION 5.00
Begin VB.Form frmPubNoteDiv 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "コメント分類テーブルメンテナンス"
   ClientHeight    =   2265
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6480
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmPubNoteDiv.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2265
   ScaleWidth      =   6480
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboOnlyDispKbn 
      Height          =   300
      Left            =   2100
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   9
      Top             =   1260
      Width           =   3315
   End
   Begin VB.ComboBox cboDefaultDispKbn 
      Height          =   300
      Left            =   2100
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   8
      Top             =   900
      Width           =   3315
   End
   Begin VB.TextBox txtPubNoteDivName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   2100
      MaxLength       =   10
      TabIndex        =   3
      Text            =   "＠＠＠＠＠＠＠＠＠＠"
      Top             =   540
      Width           =   3315
   End
   Begin VB.TextBox txtPubNoteDivCd 
      Height          =   300
      IMEMode         =   3  'ｵﾌ固定
      Left            =   2100
      MaxLength       =   3
      TabIndex        =   1
      Text            =   "@@"
      Top             =   180
      Width           =   555
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3540
      TabIndex        =   6
      Top             =   1800
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4980
      TabIndex        =   7
      Top             =   1800
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "制約(&O)"
      Height          =   180
      Index           =   3
      Left            =   300
      TabIndex        =   5
      Top             =   1320
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "初期値(&R)"
      Height          =   180
      Index           =   2
      Left            =   300
      TabIndex        =   4
      Top             =   960
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "コメント分類名(&N)"
      Height          =   180
      Index           =   1
      Left            =   300
      TabIndex        =   2
      Top             =   600
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "コメント分類コード(&C)"
      Height          =   180
      Index           =   0
      Left            =   300
      TabIndex        =   0
      Top             =   240
      Width           =   1650
   End
End
Attribute VB_Name = "frmPubNoteDiv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'========================================
'管理番号：SL-HS-Y0101-001
'事象番号：COMP-LUKES-0025（非互換検証）
'修正日  ：2010.07.16
'担当者  ：FJTH)KOMURO
'修正内容：コメント分類名の桁数制限変更
'========================================
Option Explicit

Private mstrPubNoteDivCd  As String   'コメント分類コード
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let PubNoteDivCd(ByVal vntNewValue As Variant)

    mstrPubNoteDivCd = vntNewValue
    
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
        If Trim(txtPubNoteDivCd.Text) = "" Then
            MsgBox "コメント分類コードが入力されていません。", vbCritical, App.Title
            txtPubNoteDivCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtPubNoteDivName.Text) = "" Then
            MsgBox "コメント分類名が入力されていません。", vbCritical, App.Title
            txtPubNoteDivName.SetFocus
            Exit Do
        End If

        '整合性チェック１
        If (cboOnlyDispKbn.ListIndex = 1) And (cboDefaultDispKbn.ListIndex = 1) Then
            MsgBox "医療専用コメントにも関わらず、デフォルトが「事務」になっています。", vbCritical, App.Title
            cboOnlyDispKbn.SetFocus
            Exit Do
        End If
        
        '整合性チェック２
        If (cboOnlyDispKbn.ListIndex = 2) And (cboDefaultDispKbn.ListIndex = 0) Then
            MsgBox "事務専用コメントにも関わらず、デフォルトが「医療」になっています。", vbCritical, App.Title
            cboOnlyDispKbn.SetFocus
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
Private Function EditPubNoteDiv() As Boolean

    Dim objPubNoteDiv         As Object         'コメント分類アクセス用
    Dim vntPubNoteDivName     As Variant        'コメント分類名
    Dim vntDefaultDispKbn    As Variant        'コメント分類略称
    Dim vntOnlyDispKbn              As Variant        '表示順番
    Dim Ret                 As Boolean        '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objPubNoteDiv = CreateObject("HainsPubNote.PubNote")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrPubNoteDivCd = "" Then
            Ret = True
            Exit Do
        End If
        
        'コメント分類テーブルレコード読み込み
        If objPubNoteDiv.SelectPubNoteDiv(mstrPubNoteDivCd, vntPubNoteDivName, vntDefaultDispKbn, vntOnlyDispKbn) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtPubNoteDivCd.Text = mstrPubNoteDivCd
        txtPubNoteDivName.Text = vntPubNoteDivName
        cboDefaultDispKbn.ListIndex = CInt(vntDefaultDispKbn) - 1
        
        cboOnlyDispKbn.ListIndex = 0
        
        If IsNumeric(vntOnlyDispKbn) Then
            cboOnlyDispKbn.ListIndex = CInt(vntOnlyDispKbn)
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditPubNoteDiv = Ret
    
    Exit Function

ErrorHandle:

    EditPubNoteDiv = False
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
Private Function RegistPubNoteDiv() As Boolean

On Error GoTo ErrorHandle

    Dim objPubNoteDiv     As Object       'コメント分類アクセス用
    Dim Ret             As Long
    
    'オブジェクトのインスタンス作成
    Set objPubNoteDiv = CreateObject("HainsPubNote.PubNote")
    
    'コメント分類テーブルレコードの登録
    Ret = objPubNoteDiv.RegistPubNoteDiv(IIf(txtPubNoteDivCd.Enabled, "INS", "UPD"), _
                                     Trim(txtPubNoteDivCd.Text), _
                                     Trim(txtPubNoteDivName.Text), _
                                     cboDefaultDispKbn.ListIndex + 1, _
                                     IIf(cboOnlyDispKbn.ListIndex = 0, "", cboOnlyDispKbn.ListIndex))

    If Ret = 0 Then
        MsgBox "入力されたコメント分類コードは既に存在します。", vbExclamation
        RegistPubNoteDiv = False
        Exit Function
    End If
    
    RegistPubNoteDiv = True
    
    Set objPubNoteDiv = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPubNoteDiv = Nothing
    
    RegistPubNoteDiv = False
    
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
        
        'コメント分類テーブルの登録
        If RegistPubNoteDiv() = False Then
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

    With cboDefaultDispKbn
        .Clear
        .AddItem "医療情報を選択状態にします。"
        .AddItem "事務情報を選択状態にします。"
        .AddItem "共通を選択状態にします。"
        .ListIndex = 2
    End With

    With cboOnlyDispKbn
        .Clear
        .AddItem ""
        .AddItem "この分類は医療情報専用です。"
        .AddItem "この分類は事務情報専用です。"
        .ListIndex = 0
    End With

    Do
        'コメント分類情報の編集
        If EditPubNoteDiv() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtPubNoteDivCd.Enabled = (txtPubNoteDivCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

