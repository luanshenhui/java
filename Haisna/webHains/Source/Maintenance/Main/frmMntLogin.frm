VERSION 5.00
Begin VB.Form frmMntLogin 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "ログイン情報"
   ClientHeight    =   2310
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6015
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMntLogin.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2310
   ScaleWidth      =   6015
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.TextBox txtPassword 
      Height          =   315
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1980
      MaxLength       =   64
      PasswordChar    =   "*"
      TabIndex        =   3
      Text            =   "Text1"
      Top             =   1140
      Width           =   3615
   End
   Begin VB.TextBox txtUserName 
      Height          =   315
      IMEMode         =   3  'ｵﾌ固定
      Left            =   1980
      MaxLength       =   20
      TabIndex        =   1
      Text            =   "Text1"
      Top             =   720
      Width           =   3615
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4320
      TabIndex        =   5
      Top             =   1800
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2880
      TabIndex        =   4
      Top             =   1800
      Width           =   1335
   End
   Begin VB.Label Label3 
      Caption         =   "ユーザ名とパスワードを入力してください。"
      Height          =   195
      Left            =   960
      TabIndex        =   6
      Top             =   240
      Width           =   3735
   End
   Begin VB.Image Image1 
      Height          =   480
      Left            =   240
      Picture         =   "frmMntLogin.frx":000C
      Top             =   180
      Width           =   480
   End
   Begin VB.Label Label2 
      Caption         =   "パスワード(&P):"
      Height          =   195
      Left            =   960
      TabIndex        =   2
      Top             =   1200
      Width           =   1035
   End
   Begin VB.Label Label1 
      Caption         =   "ユーザ名(&U):"
      Height          =   195
      Left            =   960
      TabIndex        =   0
      Top             =   780
      Width           =   1035
   End
End
Attribute VB_Name = "frmMntLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private blnCertification    As Boolean

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Private Sub cmdCancel_Click()

    Unload Me

End Sub

Private Sub cmdOk_Click()

    Dim strMessage As String
    Dim Ret             As Boolean

    Screen.MousePointer = vbHourglass
    Ret = False
    
    Do
        'ダミーセットフォーカス
        cmdOk.SetFocus
        
        '未入力チェック
        If (Trim(txtUserName.Text) = "") Or (Trim(txtPassword.Text) = "") Then
            strMessage = "ログインできません。ユーザ名とパスワードを確認して、もう一度パスワードを入力してください。"
            txtUserName.SetFocus
            Exit Do
        End If
            
        'ユーザＩＤ、パスワードのチェック
        If CheckCertification(strMessage) = False Then
            Exit Do
        End If
        
        Ret = True
        
        Exit Do
    Loop
    
    Screen.MousePointer = vbDefault
    
    If Ret = False Then
        MsgBox strMessage, vbExclamation, App.Title
        Exit Sub
    End If
    
    blnCertification = True
    Unload Me

End Sub

'
' 機能　　 : ユーザＩＤ、パスワードのチェック
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Function CheckCertification(strMessage As String) As Boolean

On Error GoTo ErrorHandle

    Dim objLogin    As Object           'HainsUserアクセス用
    
    Dim lngErrNo        As Long
    Dim vntUserName     As Variant
    Dim vntAuthTblMnt   As Variant
    Dim vntAuthRsv      As Variant
    Dim vntAuthRsl      As Variant
    Dim vntAuthJud      As Variant
    Dim vntAuthPrn      As Variant
    Dim vntAuthDmd      As Variant
'## 2004.12.22 ADD ST FJTH)C.M マスタメンテナンス権限
    Dim vntAuthExt1     As Variant
'## 2004.12.22 ADD ED

    CheckCertification = False
    lngErrNo = -1
    
    'オブジェクトのインスタンス作成
    Set objLogin = CreateObject("HainsHainsUser.HainsUser")
    
    'ユーザＩＤ、パスワードチェック
'## 2004.12.22 UPD ST FJTH)C.M マスタメンテナンス権限
'    lngErrNo = objLogin.CheckIDandPassword(Trim(txtUserName.Text), _
'                                           Trim(txtPassword.Text), _
'                                           vntUserName, _
'                                           vntAuthTblMnt, _
'                                           vntAuthRsv, _
'                                           vntAuthRsl, _
'                                           vntAuthJud, _
'                                           vntAuthPrn, _
'                                           vntAuthDmd)
    lngErrNo = objLogin.CheckIDandPassword(Trim(txtUserName.Text), _
                                           Trim(txtPassword.Text), _
                                           vntUserName, _
                                           vntAuthTblMnt, _
                                           vntAuthRsv, _
                                           vntAuthRsl, _
                                           vntAuthJud, _
                                           vntAuthPrn, _
                                           vntAuthDmd, , , _
                                           vntAuthExt1)
'## 2004.12.22 UPD ED
    
    'デフォルトセットフォーカス
    txtUserName.SetFocus
    
    Select Case lngErrNo
        Case 0
'## 2004.12.22 UPD ST FJTH)C.M
'            If IsNumeric(vntAuthTblMnt) = True Then
'                If vntAuthTblMnt = AUTHORITY_FULL Then
            If IsNumeric(vntAuthExt1) = True Then
                If vntAuthExt1 = AUTHORITY_FULL Then
'## 2004.12.22 UPD ED
                    CheckCertification = True
                Else
                    strMessage = "入力されたユーザＩＤでは環境設定を行う為の権限が不足しています。"
                End If
            Else
                strMessage = "入力されたユーザＩＤでは環境設定を行う為の権限が不足しています。"
            End If
        Case 1
            strMessage = "入力されたユーザＩＤは存在しません。"
        Case 2
            strMessage = "パスワードが正しくありません。"
            txtPassword.Text = ""
            txtPassword.SetFocus
        Case 3
            strMessage = "webHainsを使用する権限がありません。"
        Case 9
            strMessage = "ユーザＩＤとパスワードを入力して下さい。"
        Case Else
            strMessage = "認証中にエラーが発生しました。戻り値=" & lngErrNo
    End Select
    
    'オブジェクト廃棄
    Set objLogin = Nothing
    
    Exit Function
    
ErrorHandle:

'    MsgBox Err.Description, vbCritical
    strMessage = Err.Description & vbLf & "(ErrNo:" & Err.Number & ")"
    Set objLogin = Nothing
    CheckCertification = False
    
End Function

Private Sub Form_Load()

    blnCertification = False
    
    Call InitFormControls(Me, mcolGotFocusCollection)

End Sub

Friend Property Get Certification() As Variant
    
    Certification = blnCertification

End Property
