VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmZaimuInfo 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "財務連携明細情報修正"
   ClientHeight    =   6645
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7860
   ControlBox      =   0   'False
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmZaimuInfo.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6645
   ScaleWidth      =   7860
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin TabDlg.SSTab tabMain 
      Height          =   6075
      Left            =   120
      TabIndex        =   37
      Top             =   60
      Width           =   7635
      _ExtentX        =   13467
      _ExtentY        =   10716
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "財務連携情報"
      TabPicture(0)   =   "frmZaimuInfo.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "fraMain(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).ControlCount=   1
      TabCaption(1)   =   "収入日報用補足情報"
      TabPicture(1)   =   "frmZaimuInfo.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraMain(1)"
      Tab(1).ControlCount=   1
      Begin VB.Frame fraMain 
         Caption         =   "収入日報用"
         Height          =   5235
         Index           =   1
         Left            =   -74820
         TabIndex        =   42
         Top             =   540
         Width           =   7215
         Begin VB.TextBox txtCount_NIP 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1500
            MaxLength       =   8
            TabIndex        =   34
            Text            =   "88888888"
            Top             =   1080
            Width           =   915
         End
         Begin VB.TextBox txtTekiyou_NIP 
            Height          =   315
            IMEMode         =   4  '全角ひらがな
            Left            =   1500
            MaxLength       =   120
            TabIndex        =   32
            Text            =   "88888888"
            Top             =   720
            Width           =   5115
         End
         Begin VB.TextBox txtSyubetsu_NIP 
            Height          =   315
            IMEMode         =   4  '全角ひらがな
            Left            =   1500
            MaxLength       =   120
            TabIndex        =   30
            Text            =   "88888888"
            Top             =   360
            Width           =   5115
         End
         Begin VB.Label Label3 
            Caption         =   "件数(&M):"
            Height          =   195
            Index           =   14
            Left            =   240
            TabIndex        =   33
            Top             =   1140
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "摘要(&M):"
            Height          =   195
            Index           =   13
            Left            =   240
            TabIndex        =   31
            Top             =   780
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "種別(&M):"
            Height          =   195
            Index           =   12
            Left            =   240
            TabIndex        =   29
            Top             =   420
            Width           =   1275
         End
      End
      Begin VB.Frame fraMain 
         Caption         =   "連携情報"
         Height          =   5295
         Index           =   0
         Left            =   180
         TabIndex        =   13
         Top             =   540
         Width           =   7215
         Begin VB.CommandButton cmdOrg 
            Caption         =   "請求先団体(&O)..."
            Height          =   315
            Left            =   120
            TabIndex        =   8
            Top             =   1620
            Width           =   1575
         End
         Begin VB.TextBox txtOrgCd 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1800
            MaxLength       =   10
            TabIndex        =   9
            Text            =   "XXXXX"
            Top             =   1620
            Width           =   1395
         End
         Begin VB.TextBox txtOrgName 
            Height          =   315
            IMEMode         =   4  '全角ひらがな
            Left            =   1800
            MaxLength       =   30
            TabIndex        =   11
            Text            =   "富士通株式会社"
            Top             =   2040
            Width           =   5115
         End
         Begin VB.ComboBox cboTekiyou 
            Height          =   300
            Left            =   1800
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   16
            Top             =   2880
            Width           =   5115
         End
         Begin VB.TextBox txtTekiyouName 
            Height          =   315
            IMEMode         =   4  '全角ひらがな
            Left            =   1800
            MaxLength       =   30
            TabIndex        =   18
            Text            =   "富士通太郎　他92名　定健Ａ"
            Top             =   3300
            Width           =   5115
         End
         Begin VB.TextBox txtPrice 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1800
            MaxLength       =   8
            TabIndex        =   24
            Text            =   "88888888"
            Top             =   4620
            Width           =   915
         End
         Begin VB.ComboBox cboShubetsu 
            Height          =   300
            Left            =   1800
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   22
            Top             =   4140
            Width           =   5115
         End
         Begin VB.TextBox txtTaxPrice 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   3720
            MaxLength       =   8
            TabIndex        =   26
            Text            =   "88888888"
            Top             =   4620
            Width           =   915
         End
         Begin VB.TextBox txtTax 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   5700
            MaxLength       =   2
            TabIndex        =   28
            Text            =   "5"
            Top             =   4620
            Width           =   315
         End
         Begin VB.ComboBox cboDay 
            Height          =   300
            ItemData        =   "frmZaimuInfo.frx":0044
            Left            =   3720
            List            =   "frmZaimuInfo.frx":004B
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   5
            Top             =   780
            Width           =   555
         End
         Begin VB.ComboBox cboMonth 
            Height          =   300
            ItemData        =   "frmZaimuInfo.frx":0053
            Left            =   2820
            List            =   "frmZaimuInfo.frx":005A
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   4
            Top             =   780
            Width           =   555
         End
         Begin VB.ComboBox cboYear 
            Height          =   300
            ItemData        =   "frmZaimuInfo.frx":0062
            Left            =   1800
            List            =   "frmZaimuInfo.frx":0069
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   3
            Top             =   780
            Width           =   735
         End
         Begin VB.TextBox txtSysCd 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1800
            MaxLength       =   2
            TabIndex        =   1
            Text            =   "05"
            Top             =   360
            Width           =   315
         End
         Begin VB.ComboBox cboCsCd 
            Height          =   300
            Left            =   1800
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   14
            Top             =   2460
            Width           =   5115
         End
         Begin VB.OptionButton optKanendo 
            Caption         =   "過年度(&N)"
            Height          =   255
            Index           =   1
            Left            =   3360
            TabIndex        =   7
            Top             =   1200
            Width           =   1335
         End
         Begin VB.OptionButton optKanendo 
            Caption         =   "当年度(&T)"
            Height          =   255
            Index           =   0
            Left            =   1800
            TabIndex        =   6
            Top             =   1200
            Value           =   -1  'True
            Width           =   1335
         End
         Begin VB.ComboBox cboKbn 
            Height          =   300
            Left            =   1800
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   20
            Top             =   3720
            Width           =   5115
         End
         Begin VB.Label Label3 
            Caption         =   "請求先名称(&N):"
            Height          =   195
            Index           =   0
            Left            =   300
            TabIndex        =   10
            Top             =   2100
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "適用コード(&T):"
            Height          =   195
            Index           =   1
            Left            =   300
            TabIndex        =   15
            Top             =   2940
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "適用名称(&K):"
            Height          =   195
            Index           =   2
            Left            =   300
            TabIndex        =   17
            Top             =   3360
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "金額(&M):"
            Height          =   195
            Index           =   3
            Left            =   300
            TabIndex        =   23
            Top             =   4680
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "区分:"
            Height          =   195
            Index           =   4
            Left            =   300
            TabIndex        =   19
            Top             =   3780
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "種別(&S):"
            Height          =   195
            Index           =   5
            Left            =   300
            TabIndex        =   21
            Top             =   4200
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "税額(&X):"
            Height          =   195
            Index           =   6
            Left            =   2940
            TabIndex        =   25
            Top             =   4680
            Width           =   735
         End
         Begin VB.Label Label3 
            Caption         =   "税率(&P):"
            Height          =   195
            Index           =   7
            Left            =   4920
            TabIndex        =   27
            Top             =   4680
            Width           =   735
         End
         Begin VB.Label Label3 
            Caption         =   "%"
            Height          =   195
            Index           =   8
            Left            =   6060
            TabIndex        =   41
            Top             =   4680
            Width           =   195
         End
         Begin VB.Label Label8 
            Caption         =   "日"
            Height          =   255
            Index           =   3
            Left            =   4320
            TabIndex        =   40
            Top             =   840
            Width           =   255
         End
         Begin VB.Label Label8 
            Caption         =   "月"
            Height          =   255
            Index           =   1
            Left            =   3420
            TabIndex        =   39
            Top             =   840
            Width           =   255
         End
         Begin VB.Label Label8 
            Caption         =   "年"
            Height          =   255
            Index           =   0
            Left            =   2580
            TabIndex        =   38
            Top             =   840
            Width           =   255
         End
         Begin VB.Label Label3 
            Caption         =   "請求日(&D):"
            Height          =   195
            Index           =   9
            Left            =   300
            TabIndex        =   2
            Top             =   840
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "システム種別(&Y):"
            Height          =   195
            Index           =   10
            Left            =   300
            TabIndex        =   0
            Top             =   420
            Width           =   1275
         End
         Begin VB.Label Label3 
            Caption         =   "コースコード(&C):"
            Height          =   195
            Index           =   11
            Left            =   300
            TabIndex        =   12
            Top             =   2520
            Width           =   1275
         End
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   6420
      TabIndex        =   36
      Top             =   6240
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4980
      TabIndex        =   35
      Top             =   6240
      Width           =   1335
   End
End
Attribute VB_Name = "frmZaimuInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Const CSVFILENAME       As String = "tekiyoDB.csv"
Private Const KEY_PREFIX        As String = "K"         'コレクション用キープリフィックス

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション
Private mcolTekiyouCollection   As Collection   '適用コードのコレクション
Private mobjZaimuCsv            As ZaimuCsv
Private mstrInitialDate         As String       '初期表示日付
Private mblnUpdated             As Boolean
Private mblnModeNew             As Boolean
Private mstrCsCd()              As String

Friend Property Let InitialDate(ByVal vNewValue As String)

    mstrInitialDate = vNewValue

End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Friend Property Let ParaZaimuCsv(ByVal vntNewValue As Object)

    Set mobjZaimuCsv = vntNewValue
    
End Property

Friend Property Let TekiyouCollection(ByVal vntNewValue As Collection)

    Set mcolTekiyouCollection = vntNewValue
    
End Property

Friend Property Get ParaZaimuCsv() As Object

    Set ParaZaimuCsv = mobjZaimuCsv

End Property

Friend Property Let Mode(ByVal vntNewValue As Boolean)

    mblnModeNew = vntNewValue
    
End Property

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdOk_Click()
    
    If Screen.MousePointer <> vbDefault Then Exit Sub
    Screen.MousePointer = vbHourglass
    
    '入力チェック
    If CheckValue() = False Then
        Screen.MousePointer = vbDefault
        Exit Sub
    End If
    
    'データセット
    Call SetDataToObject

    Screen.MousePointer = vbDefault
    mblnUpdated = True
    Unload Me
        
End Sub

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

    Dim strYY       As String
    Dim strMM       As String
    Dim strDD       As String
    
    CheckValue = False
    
    strYY = cboYear.ListIndex + 2002
    strMM = Format((cboMonth.ListIndex + 1), "00")
    strDD = Format((cboDay.ListIndex + 1), "00")
        
    If Trim(txtSysCd) = "" Then
        MsgBox "システム種別コードを指定してください。", vbExclamation, Me.Caption
        txtSysCd.SetFocus
        Exit Function
    End If
        
    If Trim(txtSysCd) <> "05" Then
        MsgBox "システム種別コードは""05""固定です。。", vbExclamation, Me.Caption
        txtSysCd.SetFocus
        Exit Function
    End If
        
    If IsDate(strYY & "/" & strMM & "/" & strDD) = False Then
        MsgBox "正しい日付を指定してください。", vbExclamation, Me.Caption
        cboYear.SetFocus
        Exit Function
    End If
    
    If Trim(txtOrgCd.Text) = "" Then
        MsgBox "団体コードを指定してください。", vbExclamation, Me.Caption
        txtOrgCd.SetFocus
        Exit Function
    End If
    
    If Trim(txtOrgName.Text) = "" Then
        MsgBox "請求先名称を指定してください。", vbExclamation, Me.Caption
        txtOrgName.SetFocus
        Exit Function
    End If
    
    If Trim(txtTekiyouName.Text) = "" Then
        MsgBox "適用名称を指定してください。", vbExclamation, Me.Caption
        txtTekiyouName.SetFocus
        Exit Function
    End If
    
    If Trim(txtPrice.Text) = "" Then
        MsgBox "金額を指定してください。", vbExclamation, Me.Caption
        txtPrice.SetFocus
        Exit Function
    End If
    
    If IsNumeric(txtPrice.Text) = False Then
        MsgBox "金額には数値を指定してください。", vbExclamation, Me.Caption
        txtPrice.SetFocus
        Exit Function
    End If
    
    If Trim(txtTaxPrice.Text) = "" Then
        MsgBox "税額を指定してください。", vbExclamation, Me.Caption
        txtTaxPrice.SetFocus
        Exit Function
    End If
    
    If IsNumeric(txtTaxPrice.Text) = False Then
        MsgBox "税額には数値を指定してください。", vbExclamation, Me.Caption
        txtTaxPrice.SetFocus
        Exit Function
    End If
    
    If Trim(txtTax.Text) = "" Then
        MsgBox "税率を指定してください。", vbExclamation, Me.Caption
        txtTax.SetFocus
        Exit Function
    End If
    
    If IsNumeric(txtTax.Text) = False Then
        MsgBox "税率には数値を指定してください。", vbExclamation, Me.Caption
        txtTax.SetFocus
        Exit Function
    End If
    
    CheckValue = True
    
End Function

Private Sub cmdOrg_Click()

    Dim objCommonGuide  As mntCommonGuide.CommonGuide   '項目ガイド表示用
    Dim i               As Long     'インデックス
    Dim intRecordCount  As Integer
    Dim vntCode         As Variant
    Dim vntName         As Variant
    
    'オブジェクトのインスタンス作成
    Set objCommonGuide = New mntCommonGuide.CommonGuide
    
    With objCommonGuide
        .MultiSelect = False
        .TargetTable = getZaimuOrg
    
        '財務適用コードガイド画面を開く
        .Show vbModal
    
        intRecordCount = .RecordCount
        vntCode = .RecordCode
        vntName = .RecordName
    
    End With

    '選択件数が0件以上なら
    If intRecordCount > 0 Then
    
        txtOrgCd.Text = vntCode(0)
        txtOrgName.Text = vntName(0)
    
    End If

    Set objCommonGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Sub Form_Load()

    Dim intListIndex    As Integer
    Dim i               As Integer

    'フォーム初期化
    Call InitializeForm
    
    '更新モードの場合、データセット
    If mblnModeNew = False Then
    
        With mobjZaimuCsv
            
            txtSysCd.Text = .SysCd
            cboYear.ListIndex = CLng(.ZaimuYY) - 2002
            cboMonth.ListIndex = CLng(Mid(.ZaimuMMDD, 1, 2)) - 1
            cboDay.ListIndex = CLng(Mid(.ZaimuMMDD, 3, 2)) - 1
            
            optKanendo(CInt(.Kanendo)).Value = True
            
            txtOrgCd.Text = .OrgCd
            txtOrgName.Text = .OrgName
            
            For i = 0 To UBound(mstrCsCd)
                If mstrCsCd(i) = .CsCd Then
                    cboCsCd.ListIndex = i
                    Exit For
                End If
            Next i
            
            intListIndex = GetListIndexFromTekiyouCollection(.TekiyouCd)
            If intListIndex > -1 Then
                cboTekiyou.ListIndex = intListIndex
            End If
            
            txtTekiyouName.Text = .TekiyouName
            txtPrice.Text = .Price
            cboKbn.ListIndex = .Kubun - 1

            cboShubetsu.ListIndex = .Shubetsu - 1
            
            txtTaxPrice.Text = .TaxPrice
            txtTax = .Tax
        
            txtSyubetsu_NIP = .Syubetsu_NIP
            txtTekiyou_NIP = .Tekiyou_NIP
            txtCount_NIP = .Count_NIP
        
        End With
    
    End If
    
    tabMain.Tab = 0
    Call tabMain_Click(1)
    
End Sub

Private Function GetListIndexFromTekiyouCollection(strTekiyouCd As String) As Integer

    Dim objTekiyouClass     As TekiyouClass
    
    GetListIndexFromTekiyouCollection = -1
    GetListIndexFromTekiyouCollection = mcolTekiyouCollection(KEY_PREFIX & strTekiyouCd).ListIndex

End Function

'
' 機能　　 : フォーム初期化
'
' 備考　　 :
'
Private Sub InitializeForm()
    
    Dim objTekiyouClass     As TekiyouClass
    Dim i                   As Integer
    Dim lngYear             As Long
    Dim lngMonth            As Long
    Dim lngDay              As Long
    Dim strWorkDate         As String
    
    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    lngYear = Year(Now)
    lngMonth = Month(Now)
    lngDay = Day(Now)

    'デフォルト日付をセットされている場合は、セット用に分割
    If Len(Trim(mstrInitialDate)) = 8 Then
        strWorkDate = Mid(mstrInitialDate, 1, 4) & "/" & Mid(mstrInitialDate, 5, 2) & "/" & Mid(mstrInitialDate, 7, 2)
        If IsDate(strWorkDate) = True Then
            lngYear = CLng(Mid(mstrInitialDate, 1, 4))
            lngMonth = CLng(Mid(mstrInitialDate, 5, 2))
            lngDay = CLng(Mid(mstrInitialDate, 7, 2))
        End If
    End If

    '日付コンボボックスに値をセット
    cboYear.Clear
    For i = 2002 To YEARRANGE_MAX
        cboYear.AddItem i
    Next i
    cboYear.ListIndex = lngYear - 2002
    
    cboMonth.Clear
    For i = 1 To 12
        cboMonth.AddItem i
    Next i
    cboMonth.ListIndex = lngMonth - 1
    
    cboDay.Clear
    For i = 1 To 31
        cboDay.AddItem i
    Next i
    cboDay.ListIndex = lngDay - 1

    'コースコードセット
    Call EditComboFromCourse

    '種別のセット
    With cboShubetsu
        .Clear
        .AddItem "未収"
        .AddItem "入金"
        .AddItem "過去未収金"
        .AddItem "還付"
        .AddItem "還付未払い"
        .ListIndex = 0
    End With

    'システム種別コードは05セット
    txtSysCd.Text = "05"

    '適用コードをコレクションからセット
    cboTekiyou.Clear
    For Each objTekiyouClass In mcolTekiyouCollection
        cboTekiyou.AddItem objTekiyouClass.TekiyouName
        objTekiyouClass.ListIndex = cboTekiyou.NewIndex
    Next objTekiyouClass
    cboTekiyou.ListIndex = 0

    '区分セット
    With cboKbn
        .Clear
        .AddItem "窓口個人"
        .AddItem "団体請求"
        .AddItem "電話料金"
        .AddItem "文書料"
        .AddItem "雑収入"
    End With
    
End Sub

'
' 機能　　 : コース一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditComboFromCourse()

On Error GoTo ErrorHandle

    Dim objCourse   As Object               'コースアクセス用
    Dim vntCsCd     As Variant              'コースコード
    Dim vntCsName   As Variant              'コース名
    Dim i           As Long                 'インデックス
    Dim lngCount    As Long
    
    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName)
    
    cboCsCd.Clear
    Erase mstrCsCd
    
    'リストの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrCsCd(i)
        
        mstrCsCd(i) = vntCsCd(i)
        cboCsCd.AddItem vntCsName(i)
        
    Next i
    
    If lngCount > 0 Then
        cboCsCd.ListIndex = 0
    End If
    
    'オブジェクト廃棄
    Set objCourse = Nothing
            
    Exit Sub
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Sub

'
' 機能　　 : データ確定時のオブジェクトセット
'
' 備考　　 :
'
Private Sub SetDataToObject()

    Dim objTekiyouClass As TekiyouClass

    If mobjZaimuCsv Is Nothing Then
        Set mobjZaimuCsv = New ZaimuCsv
    End If

    With mobjZaimuCsv
        .SysCd = txtSysCd.Text
        .ZaimuYY = cboYear.ListIndex + 2002
        .ZaimuMMDD = Format((cboMonth.ListIndex + 1), "00") & Format((cboDay.ListIndex + 1), "00")
        .OrgCd = Trim(txtOrgCd.Text)
        .OrgName = Trim(txtOrgName.Text)
        For Each objTekiyouClass In mcolTekiyouCollection
            If objTekiyouClass.ListIndex = cboTekiyou.ListIndex Then
                .TekiyouCd = objTekiyouClass.TekiyouCd
                Exit For
            End If
        Next objTekiyouClass
        .TekiyouName = Trim(txtTekiyouName.Text)
        .Price = Trim(txtPrice.Text)
        .Kubun = cboKbn.ListIndex + 1
        .Shubetsu = cboShubetsu.ListIndex + 1
        .TaxPrice = Trim(txtTaxPrice.Text)
        .Tax = Trim(txtTax.Text)
        .CsCd = mstrCsCd(cboCsCd.ListIndex)
        .Kanendo = IIf(optKanendo(0).Value = True, 0, 1)
        .Syubetsu_NIP = Trim(txtSyubetsu_NIP.Text)
        .Tekiyou_NIP = Trim(txtTekiyou_NIP)
        .Count_NIP = Trim(txtCount_NIP)
    
    End With
    
End Sub

Private Sub tabMain_Click(PreviousTab As Integer)
    
    fraMain(PreviousTab).Enabled = False
    fraMain(tabMain.Tab).Enabled = True
    
End Sub
