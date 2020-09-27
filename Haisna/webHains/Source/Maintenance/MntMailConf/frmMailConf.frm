VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmMailConf 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "基本設定"
   ClientHeight    =   5880
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8715
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMailConf.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5880
   ScaleWidth      =   8715
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(&A)"
      Height          =   315
      Left            =   7320
      TabIndex        =   18
      Top             =   5460
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4560
      TabIndex        =   16
      Top             =   5460
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5940
      TabIndex        =   17
      Top             =   5460
      Width           =   1275
   End
   Begin TabDlg.SSTab SSTab1 
      Height          =   5220
      Left            =   120
      TabIndex        =   19
      Top             =   120
      Width           =   8505
      _ExtentX        =   15002
      _ExtentY        =   9208
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabsPerRow      =   2
      TabHeight       =   520
      TabCaption(0)   =   "基本"
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Label1(4)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Label1(1)"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Label1(0)"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "Label1(3)"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "txtSignature"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).Control(5)=   "txtBCC"
      Tab(0).Control(5).Enabled=   0   'False
      Tab(0).Control(6)=   "txtCC"
      Tab(0).Control(6).Enabled=   0   'False
      Tab(0).Control(7)=   "txtMailFrom"
      Tab(0).Control(7).Enabled=   0   'False
      Tab(0).ControlCount=   8
      TabCaption(1)   =   "サーバ設定"
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "txtServerName"
      Tab(1).Control(1)=   "txtUserId"
      Tab(1).Control(2)=   "txtPassword"
      Tab(1).Control(3)=   "txtPortNo"
      Tab(1).Control(4)=   "Label1(11)"
      Tab(1).Control(5)=   "Label1(10)"
      Tab(1).Control(6)=   "Label1(9)"
      Tab(1).Control(7)=   "Label1(2)"
      Tab(1).ControlCount=   8
      Begin VB.TextBox txtMailFrom 
         BeginProperty Font 
            Name            =   "ＭＳ ゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1140
         MaxLength       =   40
         TabIndex        =   1
         Text            =   "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
         Top             =   480
         Width           =   4215
      End
      Begin VB.TextBox txtCC 
         BeginProperty Font 
            Name            =   "ＭＳ ゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   840
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1140
         MultiLine       =   -1  'True
         ScrollBars      =   2  '垂直
         TabIndex        =   3
         Top             =   840
         Width           =   4215
      End
      Begin VB.TextBox txtBCC 
         BeginProperty Font 
            Name            =   "ＭＳ ゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   840
         IMEMode         =   3  'ｵﾌ固定
         Left            =   1140
         MultiLine       =   -1  'True
         ScrollBars      =   2  '垂直
         TabIndex        =   5
         Top             =   1740
         Width           =   4215
      End
      Begin VB.TextBox txtSignature 
         BeginProperty Font 
            Name            =   "ＭＳ ゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   2400
         Left            =   1140
         MultiLine       =   -1  'True
         ScrollBars      =   2  '垂直
         TabIndex        =   7
         Top             =   2640
         Width           =   7095
      End
      Begin VB.TextBox txtServerName 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   -73320
         MaxLength       =   100
         TabIndex        =   9
         Text            =   "smtp.test.com"
         Top             =   480
         Width           =   4215
      End
      Begin VB.TextBox txtUserId 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   -73320
         MaxLength       =   100
         TabIndex        =   11
         Text            =   "test"
         Top             =   840
         Width           =   4215
      End
      Begin VB.TextBox txtPassword 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   -73320
         MaxLength       =   100
         PasswordChar    =   "*"
         TabIndex        =   13
         Text            =   "smtp.test.com"
         Top             =   1200
         Width           =   4215
      End
      Begin VB.TextBox txtPortNo 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   -73320
         MaxLength       =   5
         TabIndex        =   15
         Text            =   "99999"
         Top             =   1560
         Width           =   615
      End
      Begin VB.Label Label1 
         Caption         =   "SMTPサーバー(&M):"
         Height          =   180
         Index           =   11
         Left            =   -74760
         TabIndex        =   8
         Top             =   540
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "ユーザー名(&U):"
         Height          =   180
         Index           =   10
         Left            =   -74760
         TabIndex        =   10
         Top             =   900
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "パスワード(&P):"
         Height          =   180
         Index           =   9
         Left            =   -74760
         TabIndex        =   12
         Top             =   1260
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "ポート番号(&N):"
         Height          =   180
         Index           =   2
         Left            =   -74760
         TabIndex        =   14
         Top             =   1620
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "from(&F):"
         Height          =   180
         Index           =   3
         Left            =   240
         TabIndex        =   0
         Top             =   540
         Width           =   750
      End
      Begin VB.Label Label1 
         Caption         =   "cc(&C):"
         Height          =   180
         Index           =   0
         Left            =   240
         TabIndex        =   2
         Top             =   900
         Width           =   750
      End
      Begin VB.Label Label1 
         Caption         =   "bcc(&B):"
         Height          =   180
         Index           =   1
         Left            =   240
         TabIndex        =   4
         Top             =   1800
         Width           =   750
      End
      Begin VB.Label Label1 
         Caption         =   "署名(&S):"
         Height          =   180
         Index           =   4
         Left            =   240
         TabIndex        =   6
         Top             =   2760
         Width           =   750
      End
      Begin VB.Label Label1 
         Caption         =   "SMTPサーバー(&M):"
         Height          =   180
         Index           =   5
         Left            =   -74760
         TabIndex        =   23
         Top             =   540
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "ユーザー名(&U):"
         Height          =   180
         Index           =   6
         Left            =   -74760
         TabIndex        =   22
         Top             =   900
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "パスワード(&P):"
         Height          =   180
         Index           =   7
         Left            =   -74760
         TabIndex        =   21
         Top             =   1260
         Width           =   1530
      End
      Begin VB.Label Label1 
         Caption         =   "ポート番号(&N):"
         Height          =   180
         Index           =   8
         Left            =   -74760
         TabIndex        =   20
         Top             =   1620
         Width           =   1530
      End
   End
End
Attribute VB_Name = "frmMailConf"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.3
'担当者  ：T.Takagi@RD
'修正内容：新規作成

Option Explicit

'プロパティ用領域
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly    As Boolean  'TRUE:データの更新をしない（参照のみ）
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗

'モジュール固有領域領域
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property

' @(e)
'
' 機能　　 : 「適用」クリック
'
' 引数　　 : なし
'
' 機能説明 : 入力内容を適用する。画面は閉じない
'
' 備考　　 :
'
Private Sub cmdApply_Click()
    
    'データ適用処理を行う
    Call ApplyData

End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : フォームコントロールの初期化
'
' 機能説明 : コントロールを初期状態に変更する。
'
' 備考　　 :
'
Private Sub InitializeForm()

    Call InitFormControls(Me, mcolGotFocusCollection)      '使用コントロール初期化
    
End Sub

' @(e)
'
' 機能　　 : 基本設定画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 予約メール送信基本情報を画面に表示する
'
' 備考　　 :
'
Private Function EditMailConf() As Boolean

    Dim objMailConf     As Object   'メール送信設定アクセス用
    
    Dim vntMailFrom     As Variant  'FROM
    Dim vntCC           As Variant  'CC
    Dim vntBCC          As Variant  'BCC
    Dim vntSignature    As Variant  '署名
    Dim vntServerName   As Variant  'SMTPサーバ名
    Dim vntUserId       As Variant  'ユーザID
    Dim vntPassword     As Variant  'パスワード
    Dim vntPortNo       As Variant  'ポート番号

    EditMailConf = False
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objMailConf = CreateObject("HainsMail.Config")
    
    'メール送信設定テーブル読み込み
    objMailConf.SelectMailConf vntMailFrom, vntCC, vntBCC, vntSignature, vntServerName, vntUserId, vntPassword, vntPortNo

    '読み込み内容の編集
    txtMailFrom.Text = vntMailFrom
    txtCC.Text = vntCC
    txtBCC.Text = vntBCC
    txtSignature.Text = vntSignature
    txtServerName.Text = vntServerName
    txtUserId.Text = vntUserId
    txtPassword.Text = vntPassword
    txtPortNo.Text = vntPortNo
    
    '戻り値の設定
    EditMailConf = True
    
    Exit Function

ErrorHandle:

    EditMailConf = False
    MsgBox Err.Description, vbCritical
    
End Function

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
        
        'メール送信設定テーブルの登録
        If RegistMailConf() = False Then Exit Do
        
        '更新済みにする
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    

End Function

'
' 機能　　 : E-Mail形式チェック
'
' 引数　　 : (In)     strItemName 項目名
' 　　　　   (In)     strEmails   メールアドレス
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 :
'
Private Function CheckEmail(ByVal strItemName As String, ByVal strEmails As String) As String

    Dim objCommon   As Object   '共通クラス
    Dim vntEmails   As Variant  'メールアドレスの配列
    Dim strEmail    As String   'メールアドレス
    Dim strMessage  As String   'メッセージ
    Dim i           As Long     'インデックス
    
    If Trim(strEmails) = "" Then
        Exit Function
    End If
    
    'オブジェクトのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    '改行、カンマで分割
    vntEmails = Split(Replace(strEmails, ",", vbCrLf), vbCrLf)

    '分割にて作成された配列要素をチェック
    For i = 0 To UBound(vntEmails)
        strEmail = Trim(vntEmails(i))
        If strEmail <> "" Then
            strMessage = objCommon.CheckEmail(strItemName, strEmail)
            If strMessage <> "" Then
                CheckEmail = strMessage
                Exit Function
            End If
        End If
    Next i

End Function

'
' 機能　　 : E-Mail文字列変換
'
' 引数　　 : (In)     strEmails   メールアドレス
'
' 戻り値　 : 変換後の値
'
' 備考　　 :
'
Private Function ConvertEmail(ByVal strEmails As String) As String

    Dim vntEmails       As Variant  'メールアドレスの配列
    Dim strArrEmails()  As String   'メールアドレスの配列
    Dim strEmail        As String   'メールアドレス
    Dim lngCount        As Long     '配列の要素数
    Dim i               As Long     'インデックス
    
    '改行、カンマで分割
    vntEmails = Split(Replace(strEmails, ",", vbCrLf), vbCrLf)

    '分割にて作成された配列要素を検索し、要素があれば配列に追加
    For i = 0 To UBound(vntEmails)
        strEmail = Trim(vntEmails(i))
        If strEmail <> "" Then
            ReDim Preserve strArrEmails(lngCount)
            strArrEmails(lngCount) = strEmail
            lngCount = lngCount + 1
        End If
    Next i
    
    '要素があれば改行で連結して返す
    If lngCount > 0 Then
        ConvertEmail = Join(strArrEmails, vbCrLf)
    End If
    
End Function

' @(e)
'
' 機能　　 : 整数のチェック
'
' 戻り値　 : TRUE:正常、FALSE:異常
'
' 機能説明 :
'
' 備考　　 :
'
Private Function CheckInteger(ByRef strExpression As String) As Boolean

    Dim i   As Long
    Dim Ret As Boolean
    
    Ret = True
    
    For i = 1 To Len(strExpression)
        If InStr("0123456789", Mid(strExpression, i, 1)) <= 0 Then
            Ret = False
            Exit For
        End If
    Next i
    
    CheckInteger = Ret
    
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

    Dim strMessage  As String   'メッセージ
    Dim Ret         As Boolean  '関数戻り値
    
    '初期処理
    Ret = False
    
    Do
        
        'FROMメールアドレスのチェック
        strMessage = CheckEmail("from", txtMailFrom.Text)
        If strMessage <> "" Then
            MsgBox strMessage, vbExclamation, App.Title
            txtMailFrom.SetFocus
            Exit Do
        End If
        
        'CCのチェック
        strMessage = CheckEmail("cc", txtCC.Text)
        If strMessage <> "" Then
            MsgBox strMessage, vbExclamation, App.Title
            txtCC.SetFocus
            Exit Do
        End If
        
        'BCCのチェック
        strMessage = CheckEmail("bcc", txtBCC.Text)
        If strMessage <> "" Then
            MsgBox strMessage, vbExclamation, App.Title
            txtBCC.SetFocus
            Exit Do
        End If
        
        'ポート番号のチェック
        If Trim(txtPortNo.Text) <> "" Then
            If CheckInteger(Trim(txtPortNo.Text)) = False Then
                MsgBox "ポート番号には数値を入力してください。", vbExclamation, App.Title
                txtPortNo.SetFocus
                Exit Do
            End If
        End If

        Ret = True
        
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

' @(e)
'
' 機能　　 : メール送信設定の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容をメール送信設定テーブルに保存する。
'
' 備考　　 :
'
Private Function RegistMailConf() As Boolean

    Dim objMailConf     As Object   'メール送信設定アクセス用
    
    Dim lngRet          As Long     '関数戻り値
    
    On Error GoTo ErrorHandle

    RegistMailConf = False

    'オブジェクトのインスタンス作成
    Set objMailConf = CreateObject("HainsMail.Config")

    'メール送信設定テーブルレコードの登録
    lngRet = objMailConf.RegistMailConf( _
        Trim(txtMailFrom.Text), _
        ConvertEmail(txtCC.Text), _
        ConvertEmail(txtBCC.Text), _
        txtSignature.Text, _
        Trim(txtServerName.Text), _
        Trim(txtUserId.Text), _
        Trim(txtPassword.Text), _
        Trim(txtPortNo.Text) _
    )

    If lngRet = INSERT_ERROR Then
        MsgBox "テーブル更新時にエラーが発生しました。", vbCritical
        RegistMailConf = False
        Exit Function
    End If
    
    RegistMailConf = True
    
    Exit Function
    
ErrorHandle:

    RegistMailConf = False
    
    MsgBox Err.Description, vbCritical
    
End Function

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
    
    'データ適用処理を行う（エラー時は画面を閉じない）
    If ApplyData() = False Then
        Exit Sub
    End If

    '画面を閉じる
    Unload Me
    
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
    Call InitializeForm

    Do
        
        'メール送信設定の表示編集
        If EditMailConf() = False Then
            Exit Do
        End If
        
        Ret = True
        Exit Do
    
    Loop
    
    '参照専用の場合、登録系コントロールを止める
    If mblnShowOnly = True Then
        
        txtMailFrom.Enabled = False
        txtCC.Enabled = False
        txtBCC.Enabled = False
        txtSignature.Enabled = False
        txtServerName.Enabled = False
        txtUserId.Enabled = False
        txtPassword.Enabled = False
        txtPortNo.Enabled = False
    
        cmdOk.Enabled = False
        cmdApply.Enabled = False
    
    End If
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property

Private Sub txtBCC_GotFocus()

    cmdOk.Default = False

End Sub

Private Sub txtBCC_LostFocus()

    cmdOk.Default = True

End Sub

Private Sub txtCC_GotFocus()

    cmdOk.Default = False
    
End Sub

Private Sub txtCC_LostFocus()

    cmdOk.Default = True

End Sub

Private Sub txtSignature_GotFocus()

    cmdOk.Default = False

End Sub

Private Sub txtSignature_LostFocus()

    cmdOk.Default = True

End Sub

