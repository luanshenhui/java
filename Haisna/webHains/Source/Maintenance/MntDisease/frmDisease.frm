VERSION 5.00
Begin VB.Form frmDisease 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "病名テーブルメンテナンス"
   ClientHeight    =   2340
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6885
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmDisease.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2340
   ScaleWidth      =   6885
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboDisDiv 
      Height          =   300
      ItemData        =   "frmDisease.frx":000C
      Left            =   1680
      List            =   "frmDisease.frx":002E
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   7
      Top             =   1200
      Width           =   4665
   End
   Begin VB.ComboBox cboSearchChar 
      Height          =   300
      ItemData        =   "frmDisease.frx":0050
      Left            =   1680
      List            =   "frmDisease.frx":0072
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   5
      Top             =   840
      Width           =   810
   End
   Begin VB.TextBox txtDisName 
      Height          =   300
      IMEMode         =   4  '全角ひらがな
      Left            =   1680
      MaxLength       =   25
      TabIndex        =   3
      Text            =   "＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠＠"
      Top             =   480
      Width           =   4875
   End
   Begin VB.TextBox txtDisCd 
      Height          =   300
      Left            =   1680
      MaxLength       =   9
      TabIndex        =   1
      Text            =   "@@"
      Top             =   120
      Width           =   1035
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3840
      TabIndex        =   8
      Top             =   1860
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5280
      TabIndex        =   9
      Top             =   1860
      Width           =   1335
   End
   Begin VB.Label Label1 
      Caption         =   "病類(&R):"
      Height          =   180
      Index           =   4
      Left            =   120
      TabIndex        =   6
      Top             =   1260
      Width           =   1350
   End
   Begin VB.Label Label3 
      Caption         =   "検索用文字列(&S):"
      Height          =   195
      Index           =   2
      Left            =   120
      TabIndex        =   4
      Top             =   900
      Width           =   1395
   End
   Begin VB.Label Label1 
      Caption         =   "病名(&N)"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   2
      Top             =   540
      Width           =   1410
   End
   Begin VB.Label Label1 
      Caption         =   "病名コード(&C)"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1410
   End
End
Attribute VB_Name = "frmDisease"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrDisCd           As String   '病名コード
Private mblnInitialize      As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mstrDisDivCd()      As String   'コンボボックスに対応する病類コードの格納

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let DisCd(ByVal vntNewValue As Variant)

    mstrDisCd = vntNewValue
    
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
        If Trim(txtDisCd.Text) = "" Then
            MsgBox "病名コードが入力されていません。", vbCritical, App.Title
            txtDisCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtDisName.Text) = "" Then
            MsgBox "病名名が入力されていません。", vbCritical, App.Title
            txtDisName.SetFocus
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
Private Function EditDisDiv() As Boolean

    Dim objDisease      As Object           '病名アクセス用
    Dim vntDisName      As Variant          '病名
    Dim vntSearchChar   As Variant          'ガイド検索用文字列
    Dim vntDisDivCd     As Variant          '病類コード
    Dim Ret             As Boolean          '戻り値
    Dim i               As Integer
    
    Dim lngCount        As Long
    Dim vntDisDivCdList As Variant          '病類コード
    Dim vntDisDivName   As Variant          '病類名
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objDisease = CreateObject("HainsDisease.Disease")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrDisCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '病名テーブルレコード読み込み
        If objDisease.SelectDisease(mstrDisCd, vntDisName, vntSearchChar, vntDisDivCd) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtDisCd.Text = mstrDisCd
        txtDisName.Text = vntDisName
    
        '検索文字列コンボの設定
        For i = 0 To cboSearchChar.ListCount - 1
            If cboSearchChar.List(i) = vntSearchChar Then
                cboSearchChar.ListIndex = i
            End If
        Next i
    
        Ret = True
        Exit Do
    Loop
    
    cboDisDiv.Clear
    Erase mstrDisDivCd

    'オブジェクトのインスタンス作成
    lngCount = objDisease.SelectDisDivList(vntDisDivCdList, vntDisDivName)
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrDisDivCd(i)
        mstrDisDivCd(i) = vntDisDivCdList(i)
        cboDisDiv.AddItem vntDisDivName(i)
        If vntDisDivCd = vntDisDivCdList(i) Then
            cboDisDiv.ListIndex = i
        End If
    Next i
    
    'データが存在しないなら、エラー
    If lngCount <= 0 Then
        MsgBox "病類が存在しません。病類データを登録しないと病名設定を行うことはできません。", vbExclamation
        Exit Function
    End If
    
    '戻り値の設定
    EditDisDiv = Ret
    
    Exit Function

ErrorHandle:

    EditDisDiv = False
    
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
Private Function RegistDisDiv() As Boolean

    Dim objDisease       As Object       '病名アクセス用
    Dim Ret             As Long
    Dim strSearchChar   As String
    
    On Error GoTo ErrorHandle
    
    'ガイド検索文字列の再編集
    strSearchChar = cboSearchChar.List(cboSearchChar.ListIndex)
    If strSearchChar = "その他" Then
        strSearchChar = "*"
    End If
    
    'オブジェクトのインスタンス作成
    Set objDisease = CreateObject("HainsDisease.Disease")
    
    '病名テーブルレコードの登録
    Ret = objDisease.RegistDisease(IIf(txtDisCd.Enabled, "INS", "UPD"), _
                                   Trim(txtDisCd.Text), _
                                   Trim(txtDisName.Text), _
                                   strSearchChar, _
                                   mstrDisDivCd(cboDisDiv.ListIndex))
    
    If Ret = 0 Then
        MsgBox "入力された病名コードは既に存在します。", vbExclamation
        RegistDisDiv = False
        Exit Function
    End If
    
    RegistDisDiv = True
    
    Exit Function
    
ErrorHandle:

    RegistDisDiv = False
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
        
        '病名テーブルの登録
        If RegistDisDiv() = False Then
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

    '検索文字列コンボ初期化
    Call InitSearchCharCombo(cboSearchChar)

    Do
        '病名情報の編集
        If EditDisDiv() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtDisCd.Enabled = (txtDisCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub
