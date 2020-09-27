VERSION 5.00
Begin VB.Form frmPgmInfo 
   Caption         =   "プログラム情報管理"
   ClientHeight    =   6285
   ClientLeft      =   4785
   ClientTop       =   1440
   ClientWidth     =   7695
   LinkTopic       =   "Form1"
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6285
   ScaleWidth      =   7695
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      BeginProperty Font 
         Name            =   "ＭＳ Ｐゴシック"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   364
      Left            =   5967
      TabIndex        =   20
      Top             =   5790
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      BeginProperty Font 
         Name            =   "ＭＳ Ｐゴシック"
         Size            =   9
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   364
      Left            =   4472
      TabIndex        =   13
      Top             =   5790
      Width           =   1335
   End
   Begin VB.Frame Frame1 
      Height          =   429
      Left            =   600
      TabIndex        =   15
      Top             =   5760
      Visible         =   0   'False
      Width           =   1963
      Begin VB.OptionButton Option1 
         Caption         =   "Hains"
         Height          =   195
         Index           =   1
         Left            =   156
         TabIndex        =   17
         Top             =   156
         Value           =   -1  'True
         Width           =   949
      End
      Begin VB.OptionButton Option1 
         Caption         =   "誘導"
         Height          =   195
         Index           =   0
         Left            =   1066
         TabIndex        =   16
         Top             =   156
         Width           =   845
      End
   End
   Begin VB.Frame Frame2 
      Height          =   5145
      Left            =   78
      TabIndex        =   0
      Top             =   520
      Width           =   7530
      Begin VB.TextBox txtYobi2 
         Height          =   325
         Left            =   2220
         MaxLength       =   250
         TabIndex        =   28
         Top             =   4125
         Width           =   5070
      End
      Begin VB.TextBox txtYudo 
         Height          =   325
         Left            =   2220
         MaxLength       =   6
         TabIndex        =   25
         Top             =   3360
         Width           =   2795
      End
      Begin VB.TextBox txtYobi1 
         Height          =   325
         Left            =   2220
         MaxLength       =   250
         TabIndex        =   24
         Top             =   3750
         Width           =   5070
      End
      Begin VB.TextBox txtFilePath 
         Height          =   325
         Left            =   2220
         MaxLength       =   250
         TabIndex        =   21
         Top             =   1378
         Width           =   5031
      End
      Begin VB.TextBox txtMenuGrp 
         Appearance      =   0  'ﾌﾗｯﾄ
         Height          =   273
         Left            =   4966
         TabIndex        =   19
         Top             =   2262
         Visible         =   0   'False
         Width           =   2301
      End
      Begin VB.CheckBox chkDelFlg 
         Caption         =   "このプログラムを無効にする(&D)"
         Height          =   255
         Left            =   156
         TabIndex        =   14
         Top             =   4695
         Width           =   2760
      End
      Begin VB.TextBox txtPgmDesc 
         Height          =   689
         Left            =   2220
         MultiLine       =   -1  'True
         TabIndex        =   12
         Top             =   2600
         Width           =   5031
      End
      Begin VB.ComboBox cboMenu 
         Height          =   300
         Left            =   2220
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   11
         Top             =   2236
         Width           =   2301
      End
      Begin VB.TextBox txtLinkImage 
         Height          =   325
         Left            =   2220
         MaxLength       =   250
         TabIndex        =   10
         Top             =   1794
         Width           =   5031
      End
      Begin VB.TextBox txtStartPgm 
         Height          =   325
         Left            =   2220
         MaxLength       =   50
         TabIndex        =   9
         Top             =   988
         Width           =   2795
      End
      Begin VB.TextBox txtPgmName 
         Height          =   325
         Left            =   2220
         MaxLength       =   50
         TabIndex        =   8
         Top             =   598
         Width           =   2795
      End
      Begin VB.TextBox txtPgmCd 
         Height          =   325
         Left            =   2220
         MaxLength       =   12
         TabIndex        =   7
         Top             =   208
         Width           =   2795
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "予備２"
         Height          =   180
         Index           =   10
         Left            =   135
         TabIndex        =   29
         Top             =   4215
         Width           =   480
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "誘導検査分類"
         Height          =   180
         Index           =   9
         Left            =   135
         TabIndex        =   27
         Top             =   3435
         Width           =   1080
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "予備１"
         Height          =   180
         Index           =   8
         Left            =   135
         TabIndex        =   26
         Top             =   3840
         Width           =   480
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "プログラムファイル経路"
         Height          =   169
         Index           =   7
         Left            =   182
         TabIndex        =   22
         Top             =   1456
         Width           =   1625
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "プログラム説明"
         Height          =   169
         Index           =   6
         Left            =   130
         TabIndex        =   6
         Top             =   2730
         Width           =   1079
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "メニュー 区分"
         Height          =   169
         Index           =   4
         Left            =   130
         TabIndex        =   5
         Top             =   2314
         Width           =   949
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "リンクイメージ（経路包含）"
         Height          =   169
         Index           =   3
         Left            =   182
         TabIndex        =   4
         Top             =   1872
         Width           =   1820
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "起動プログラムファイル名"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   3
         Top             =   1065
         Width           =   1965
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "プログラム　メニュー名"
         Height          =   169
         Index           =   1
         Left            =   182
         TabIndex        =   2
         Top             =   676
         Width           =   1586
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "プログラムコード"
         Height          =   169
         Index           =   0
         Left            =   182
         TabIndex        =   1
         Top             =   286
         Width           =   1144
      End
   End
   Begin VB.Label lblMenu 
      AutoSize        =   -1  'True
      BeginProperty Font 
         Name            =   "ＭＳ Ｐゴシック"
         Size            =   12
         Charset         =   128
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   3780
      TabIndex        =   23
      Top             =   165
      Width           =   90
   End
   Begin VB.Label LabelTitle 
      Caption         =   "プログラム情報を登録してください"
      Height          =   375
      Left            =   855
      TabIndex        =   18
      Top             =   165
      Width           =   2655
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   75
      Picture         =   "frmPgmInfo.frx":0000
      Top             =   -30
      Width           =   720
   End
End
Attribute VB_Name = "frmPgmInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public mstrMenuGrpCd        As String
Public mstrPgmCd        As String   'セット分類コード
Public imode                As Integer

Private mblnInitialize      As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし
Private aryMenuGrpCd()       As String
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション


Friend Property Let SetPgmInfoCd(ByVal vntNewValue As Variant)

    mstrPgmCd = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

Private Sub cmdCancel_Click()
    Unload Me
End Sub

'
' 機能　　 : 「ＯＫ」クリック
'
' 引数　　 : なし
'
' 機能説明 : 入力内容を適用し、画面を閉じる
'
' 備考　　 :
'
Private Sub cmdOk_Click()

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
        
        'プログラム情報テーブルの登録
        If RegistPgmInfo() = False Then
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

Private Function RegistPgmInfo() As Boolean
    On Error GoTo ErrorHandle

    Dim objPgmInfo     As Object       'セット分類アクセス用
    Dim Ret             As Long
    
    'オブジェクトのインスタンス作成
    Set objPgmInfo = CreateObject("HainsPgmInfo.PgmInfo")
    
    'プログラム情報テーブルの登録
    Ret = objPgmInfo.RegistPgmInfo(IIf(txtPgmCd.Enabled, "INS", "UPD"), _
                                     Trim(txtPgmCd.Text), _
                                     Trim(txtPgmName.Text), _
                                     Trim(txtStartPgm.Text), _
                                     Trim(txtFilePath.Text), _
                                     Trim(txtLinkImage.Text), _
                                     Trim(aryMenuGrpCd(cboMenu.ListIndex)), _
                                     Trim(txtPgmDesc.Text), _
                                     chkDelFlg.Value, _
                                     Trim(txtYudo.Text), _
                                     Trim(txtYobi1.Text), _
                                     Trim(txtYobi2.Text))

    If Ret = 0 Then
        MsgBox "入力されたプログラム情報は既に存在します。", vbExclamation
        RegistPgmInfo = False
        Exit Function
    End If
    
    RegistPgmInfo = True
    
    Set objPgmInfo = Nothing
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    Set objPgmInfo = Nothing
    
    RegistPgmInfo = False
    
End Function


Private Function CheckValue() As Boolean
    Dim Ret             As Boolean  '関数戻り値
    
    '初期処理
    Ret = False
    
    Do
        If Trim(txtPgmCd.Text) = "" Then
            MsgBox "プログラムコードが入力されていません。", vbCritical, App.Title
            txtPgmCd.SetFocus
            Exit Do
        End If

        If Trim(txtPgmName.Text) = "" Then
            MsgBox "プログラム名称が入力されていません。", vbCritical, App.Title
            txtPgmName.SetFocus
            Exit Do
        End If
        
        If Trim(txtStartPgm.Text) = "" Then
'            MsgBox "起動プログラムが入力されていません。", vbCritical, App.Title
            MsgBox "起動プログラムのファイル名を入力してください。", vbCritical, App.Title
            txtStartPgm.SetFocus
            Exit Do
        End If
        
        If Trim(txtFilePath.Text) = "" Then
'            MsgBox "起動プログラムが入力されていません。", vbCritical, App.Title
            MsgBox "起動プログラムのファイル経路を入力してください。", vbCritical, App.Title
            txtStartPgm.SetFocus
            Exit Do
        End If
        
        
        If Trim(cboMenu.Text) = "" Then
            MsgBox "メニューグループが入力されていません。", vbCritical, App.Title
            txtStartPgm.SetFocus
            Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

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
        'セット分類情報の編集
        If EditMenuGrp() = False Then
            Exit Do
        End If
    
        If EditPgmInfo() = False Then
            Exit Do
        End If
        
        'イネーブル設定
        txtPgmCd.Enabled = (txtPgmCd.Text = "")
        
        Ret = True
        
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Sub

'
' 機能　　 : データ表示用編集
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditPgmInfo() As Boolean
    On Error GoTo ErrorHandle

    Dim objPgmInfo          As Object               'グループアクセス用
    
    Dim vntPgmCd            As Variant              'プログラムコード
    Dim vntPgmName          As Variant              'プログラム名称
    Dim vntStartPgm         As Variant              '起動プログラム (File名）
    '##2005.07.25　追加　Add　By　李　--->　ST
    Dim vntFilePath         As Variant              'プログラムファイル経路
    '##2005.07.25　追加　Add　By　李　--->　ED
    Dim vntLinkImage        As Variant              'リンクイメージ(経路包含）
    Dim vntMenuGrpCd        As Variant              'メニューグループコード
    Dim vntPgmDesc          As Variant              'プログラム説明
    Dim vntDelFlag          As Variant              '使用可否フラッグ
    '##2005.08.12　追加　Add　By　李　--->　ST
    Dim vntMenuName         As Variant
    Dim vntYudoBunrui       As Variant              '誘導検査分類
    Dim vntYobi1            As Variant              '予備1
    Dim vntYobi2            As Variant              '予備2
    '##2005.08.12　追加　Add　By　李　--->　ED
    
    Dim lngCount            As Long                 'レコード数
    Dim i                   As Long                 'インデックス
    Dim Ret                 As Boolean
    
    'オブジェクトのインスタンス作成
    Set objPgmInfo = CreateObject("HainsPgmInfo.PgmInfo")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrPgmCd = "" Then
            Ret = True
            Exit Do
        End If
        
        'プログラム情報をコードで読み込み
        lngCount = objPgmInfo.SelectPgmInfo(mstrPgmCd, _
                                                0, _
                                                vntPgmCd, _
                                                vntPgmName, _
                                                vntStartPgm, _
                                                vntFilePath, _
                                                vntLinkImage, _
                                                vntMenuGrpCd, _
                                                vntPgmDesc, _
                                                vntDelFlag, _
                                                vntMenuName, _
                                                vntYudoBunrui, _
                                                vntYobi1, _
                                                vntYobi2)
    
        '読み込み内容の編集
        If lngCount > 0 Then
            txtPgmCd.Text = vntPgmCd(0)
            txtPgmName.Text = vntPgmName(0)
            txtStartPgm.Text = vntStartPgm(0)
            txtFilePath.Text = vntFilePath(0)
            txtLinkImage.Text = vntLinkImage(0)
            cboMenu.ListIndex = SetMenuGrpIndex(CStr(vntMenuGrpCd(0)))
            txtPgmDesc.Text = vntPgmDesc(0)
            chkDelFlg.Value = CInt(vntDelFlag(0))
            txtYudo.Text = vntYudoBunrui(0)
            txtYobi1 = vntYobi1(0)
            txtYobi2 = vntYobi2(0)
        
        Else
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditPgmInfo = Ret
    
    Exit Function

ErrorHandle:

    EditPgmInfo = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Function SetMenuGrpIndex(GrpCd As String) As Integer
    Dim i       As Integer
    
    For i = 0 To UBound(aryMenuGrpCd())
        If Trim(aryMenuGrpCd(i)) = Trim(GrpCd) Then
            SetMenuGrpIndex = i
            Exit For
        End If
    Next i

End Function



Private Sub InitializeForm()
    cboMenu.Visible = True
    txtMenuGrp.Visible = False

    txtMenuGrp.Left = cboMenu.Left
    txtMenuGrp.Top = cboMenu.Top
    
    Call InitFormControls(Me, mcolGotFocusCollection)      '使用コントロール初期化
    
End Sub


'
' 機能　　 :
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
' 機能説明 :
' 備考　　 :
'
Private Function EditMenuGrp() As Boolean
    Dim objItem                 As Object           'コースアクセス用
    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'インデックス
    Dim imode                   As Integer
    Dim strKey                  As String
    
    Dim vntFreeCd               As Variant          'コード
    Dim vntFreeName             As Variant          'コード名
    Dim vntFreeDate             As Variant
    Dim vntFreeField1           As Variant
    Dim vntFreeField2           As Variant
    Dim vntFreeField3           As Variant
    Dim vntFreeField4           As Variant
    Dim vntFreeField5           As Variant
    Dim vntFreeField6           As Variant
    Dim vntFreeField7           As Variant
    Dim vntFreeClassCd          As Variant
    
    EditMenuGrp = False
    cboMenu.Clear
    
    imode = 0
    strKey = "PGM"
    Erase aryMenuGrpCd
        
    'オブジェクトのインスタンス作成
    Set objItem = CreateObject("HainsFree.Free")
    lngCount = objItem.SelectFreeByClassCd(imode, _
                                          strKey, _
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
                                          vntFreeField7)
    
    '履歴データが存在しないなら、エラー
    If lngCount <= 0 Then
        MsgBox "メーニューグループが存在しないです。", vbExclamation
        Exit Function
    End If
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve aryMenuGrpCd(i)
        aryMenuGrpCd(i) = vntFreeCd(i)
        cboMenu.AddItem vntFreeField1(i)
    Next i
    
'    cboMenu.ListIndex = 0
    
    '先頭コンボを選択状態にする
    EditMenuGrp = True
    
    Exit Function
    
ErrorHandle:
    MsgBox Err.Description, vbCritical

End Function

Private Sub txtLinkImage_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub

Private Sub txtPgmCd_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub


Private Sub txtPgmDesc_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub

Private Sub txtPgmName_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub

Private Sub txtStartPgm_KeyDown(KeyCode As Integer, Shift As Integer)
    If KeyCode = 13 Then
        SendKeys "{TAB}"
    End If
End Sub
