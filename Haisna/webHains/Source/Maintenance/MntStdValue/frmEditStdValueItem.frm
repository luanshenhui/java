VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmEditStdValueItem 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "基準値設定値の変更"
   ClientHeight    =   6495
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   7275
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmEditStdValueItem.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6495
   ScaleWidth      =   7275
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.Frame Frame3 
      Caption         =   "単位情報"
      Height          =   1335
      Left            =   120
      TabIndex        =   25
      Top             =   1800
      Width           =   6975
      Begin MSComctlLib.ListView lsvUnit 
         Height          =   855
         Left            =   180
         TabIndex        =   26
         Top             =   300
         Width           =   6615
         _ExtentX        =   11668
         _ExtentY        =   1508
         LabelEdit       =   1
         LabelWrap       =   -1  'True
         HideSelection   =   -1  'True
         FullRowSelect   =   -1  'True
         _Version        =   393217
         Icons           =   "imlToolbarIcons"
         SmallIcons      =   "imlToolbarIcons"
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
   End
   Begin VB.Frame Frame2 
      Caption         =   "適用する設定値"
      Height          =   2595
      Left            =   120
      TabIndex        =   20
      Top             =   3240
      Width           =   6975
      Begin VB.TextBox txtJudCmtCd 
         Height          =   270
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2220
         MaxLength       =   8
         TabIndex        =   11
         Text            =   "99999999"
         Top             =   1200
         Width           =   975
      End
      Begin VB.ComboBox cboStdFlg 
         BeginProperty Font 
            Name            =   "ＭＳ Ｐゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         ItemData        =   "frmEditStdValueItem.frx":000C
         Left            =   2220
         List            =   "frmEditStdValueItem.frx":002E
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   7
         Top             =   360
         Width           =   2550
      End
      Begin VB.TextBox txtHealthPoint 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2220
         MaxLength       =   6
         TabIndex        =   14
         Text            =   "@@@@.@"
         Top             =   1980
         Width           =   795
      End
      Begin VB.ComboBox cboJud 
         BeginProperty Font 
            Name            =   "ＭＳ Ｐゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         ItemData        =   "frmEditStdValueItem.frx":0050
         Left            =   2220
         List            =   "frmEditStdValueItem.frx":0072
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   9
         Top             =   780
         Width           =   2550
      End
      Begin VB.CommandButton cmdGuide 
         Caption         =   "参照(&C)..."
         Height          =   315
         Left            =   2220
         TabIndex        =   12
         Top             =   1560
         Width           =   1335
      End
      Begin VB.Label Label1 
         Caption         =   "適用する基準値(&S):"
         Height          =   180
         Index           =   2
         Left            =   180
         TabIndex        =   6
         Top             =   420
         Width           =   1650
      End
      Begin VB.Label Label1 
         Caption         =   "適用する判定コード(&J):"
         Height          =   180
         Index           =   3
         Left            =   180
         TabIndex        =   8
         Top             =   840
         Width           =   1710
      End
      Begin VB.Label Label1 
         Caption         =   "適用する判定コメント(&C):"
         Height          =   180
         Index           =   4
         Left            =   180
         TabIndex        =   10
         Top             =   1260
         Width           =   1830
      End
      Begin VB.Label Label1 
         Caption         =   "ヘルスポイント(&H):"
         Height          =   180
         Index           =   5
         Left            =   180
         TabIndex        =   13
         Top             =   2040
         Width           =   1470
      End
      Begin VB.Label lblJudCmtStc 
         Caption         =   "12345678"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   3300
         TabIndex        =   21
         Top             =   1260
         Width           =   3255
      End
   End
   Begin VB.Frame Frame1 
      Caption         =   "対象となるデータ"
      Height          =   1575
      Left            =   120
      TabIndex        =   17
      Top             =   120
      Width           =   6975
      Begin VB.CommandButton cmdSentence 
         Caption         =   "参照(&B)..."
         Height          =   315
         Left            =   2220
         TabIndex        =   23
         Top             =   1140
         Width           =   1275
      End
      Begin VB.TextBox txtStrAge 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2220
         MaxLength       =   6
         TabIndex        =   1
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.TextBox txtEndAge 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   3180
         MaxLength       =   6
         TabIndex        =   2
         Text            =   "000.00"
         Top             =   360
         Width           =   675
      End
      Begin VB.TextBox txtLowerValue 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2220
         MaxLength       =   8
         TabIndex        =   4
         Text            =   "@@@@@@@@"
         Top             =   780
         Width           =   1095
      End
      Begin VB.TextBox txtUpperValue 
         Height          =   300
         IMEMode         =   3  'ｵﾌ固定
         Left            =   3600
         MaxLength       =   8
         TabIndex        =   5
         Text            =   "@@@@@@@@"
         Top             =   780
         Width           =   1095
      End
      Begin VB.ComboBox cboTeisei 
         BeginProperty Font 
            Name            =   "ＭＳ Ｐゴシック"
            Size            =   9
            Charset         =   128
            Weight          =   400
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   300
         ItemData        =   "frmEditStdValueItem.frx":0094
         Left            =   2220
         List            =   "frmEditStdValueItem.frx":00B6
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   22
         Top             =   780
         Width           =   1470
      End
      Begin VB.Label lblSentence 
         Caption         =   "＠＠＠＠＠＠＠＠＠＠"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   195
         Left            =   3420
         TabIndex        =   24
         Top             =   840
         Width           =   3375
      End
      Begin VB.Label Label1 
         Caption         =   "年齢適用範囲(&A):"
         Height          =   180
         Index           =   0
         Left            =   180
         TabIndex        =   0
         Top             =   420
         Width           =   1470
      End
      Begin VB.Label Label2 
         Caption         =   "～"
         Height          =   255
         Index           =   0
         Left            =   2940
         TabIndex        =   19
         Top             =   420
         Width           =   255
      End
      Begin VB.Label Label1 
         Caption         =   "結果値適用範囲(&R):"
         Height          =   180
         Index           =   1
         Left            =   180
         TabIndex        =   3
         Top             =   840
         Width           =   1650
      End
      Begin VB.Label LabelValue 
         Caption         =   "～"
         Height          =   255
         Left            =   3360
         TabIndex        =   18
         Top             =   840
         Width           =   255
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   5760
      TabIndex        =   16
      Top             =   6000
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   4320
      TabIndex        =   15
      Top             =   6000
      Width           =   1335
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   120
      Top             =   5880
      _ExtentX        =   1005
      _ExtentY        =   1005
      BackColor       =   -2147483643
      ImageWidth      =   16
      ImageHeight     =   16
      MaskColor       =   12632256
      _Version        =   393216
      BeginProperty Images {2C247F25-8591-11D1-B16A-00C0F0283628} 
         NumListImages   =   4
         BeginProperty ListImage1 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmEditStdValueItem.frx":00D8
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmEditStdValueItem.frx":052A
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmEditStdValueItem.frx":097C
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmEditStdValueItem.frx":0AD6
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
End
Attribute VB_Name = "frmEditStdValueItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrResultType          As String           '結果タイプ
Private mstrStrAge              As String           '開始年齢
Private mstrEndAge              As String           '終了年齢
Private mstrLowerValue          As String           '基準値（以上）
Private mstrUpperValue          As String           '基準値（以下）
Private mstrStdFlg              As String           '基準値フラグ
Private mstrJudCd               As String           '判定コード
Private mstrJudCmtCd            As String           '判定コメントコード
Private mstrHealthPoint         As String           'ヘルスポイント
Private mblnMultiSelect         As Boolean          '基準値明細の複数選択

Private mvntStcCode()           As Variant          '基準値用文章コード配列
Private mvntSentence()          As Variant          '文章配列
Private mintSentenceCount       As Integer          '選択された文章の数

'文章タイプのみ使用
Private mintItemType            As String           '項目タイプ
Private mstrStcItemCd           As String           '文章参照用項目コード

Private mblnUpdated             As Boolean          'TRUE:更新あり、FALSE:更新なし
Private mcolGotFocusCollection  As Collection       'GotFocus時の文字選択用コレクション
Private mblnModeNew             As Boolean          'TRUE:新規、FALSE:更新

Private mstrArrStdFlg()         As String           'コンボ対応用基準値フラグ配列
Private mstrArrJudCd()          As String           'コンボ対応用判定コード配列

Private mstrArrTeisei(10)       As String           'コンボ対応用定性１，２配列

Private mcolItemHistory         As Collection       '検査項目履歴レコードのコレクション

Private Const DefaultStrAge As String = "0"
Private Const DefaultEndAge As String = "999.99"

Private Sub cboTeisei_Click()

    txtLowerValue.Text = mstrArrTeisei(cboTeisei.ListIndex)

End Sub

Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : 判定データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 判定データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditJud() As Boolean

    Dim objJud          As Object       '判定分類アクセス用
    Dim vntJudCd        As Variant
    Dim vntJudName      As Variant

    Dim lngCount        As Long         'レコード数
    Dim i               As Long         'インデックス
    
    EditJud = False
    
    cboJud.Clear
    Erase mstrArrJudCd

    'オブジェクトのインスタンス作成
    Set objJud = CreateObject("HainsJud.Jud")
    lngCount = objJud.SelectJudList(vntJudCd, vntJudName)
    
    '判定コードは未選択あり
    ReDim Preserve mstrArrJudCd(0)
    mstrArrJudCd(0) = ""
    cboJud.AddItem ""
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrJudCd(i + 1)
        mstrArrJudCd(i + 1) = vntJudCd(i)
        cboJud.AddItem vntJudCd(i) & ":" & vntJudName(i)
    Next i
    
    '先頭コンボを選択状態にする（判定分類は未選択あり）
    cboJud.ListIndex = 0
    
    EditJud = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub cmdGuide_Click()
    
    Dim objCommonGuide  As mntCommonGuide.CommonGuide   '項目ガイド表示用
    
    Dim lngCount        As Long     'レコード数
    Dim i               As Long     'インデックス
    Dim strKey          As String   '重複チェック用のキー
    Dim strWorkString   As String
    
    'オブジェクトのインスタンス作成
    Set objCommonGuide = New mntCommonGuide.CommonGuide
    
    With objCommonGuide
        .MultiSelect = False
        .TargetTable = getJudCmtStc
    
        'コーステーブルメンテナンス画面を開く
        .Show vbModal
    
        '選択件数が0件以上なら
        If .RecordCount > 0 Then
            
            txtJudCmtCd.Text = .RecordCode(0)
            '要約の為、改行コードを除去してセット
            lblJudCmtStc.Caption = OmitCrLf(CStr(.RecordName(0)))
        
        End If
    
    End With

    Set objCommonGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Function OmitCrLf(strTargetString As String) As String

    Dim strWorkString   As String

    OmitCrLf = strTargetString

    '要約の為、改行コード除去
    strWorkString = Replace(Trim(strTargetString), vbCrLf, "")
    strWorkString = Replace(strWorkString, vbLf, "")
    
    If Len(strWorkString) > 17 Then
        OmitCrLf = Mid(strWorkString, 1, 17) & "..."
    Else
        OmitCrLf = strWorkString
    End If

End Function

Private Sub cmdOk_Click()

    '入力チェック
    If CheckValue() = False Then Exit Sub
    
    'プロパティ値の画面セット
    mstrStrAge = txtStrAge.Text
    mstrEndAge = txtEndAge.Text
    mstrLowerValue = txtLowerValue.Text
    mstrUpperValue = txtUpperValue.Text
    mstrHealthPoint = txtHealthPoint.Text
    mstrStdFlg = mstrArrStdFlg(cboStdFlg.ListIndex)
    mstrJudCd = mstrArrJudCd(cboJud.ListIndex)
    mstrJudCmtCd = txtJudCmtCd.Text

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
' 備考　　 : 「○○が入力されていません」のMSGに飽きたあなたのために勝手につっこむ俺様ロジック
'
Private Function CheckValue() As Boolean

    Dim Ret             As Boolean  '関数戻り値
    Dim strWorkResult   As String
        
    '同一コントロールのSetFocusでは文字列選択が有効にならないのでダミーでとばす
    cmdOk.SetFocus
    
    Ret = False
    
    Do
        '年齢（下）の未入力チェック（勝手につっこむ）
        If Trim(txtStrAge.Text) = "" Then
            txtStrAge.Text = DefaultStrAge
        End If
        
        '年齢（上）の入力チェック（勝手につっこむ）
        If Trim(txtEndAge.Text) = "" Then
            txtEndAge.Text = DefaultEndAge
        End If

        '年齢（下）の数値チェック
        If IsNumeric(txtStrAge.Text) = False Then
            MsgBox "年齢適用範囲には数値を入力してください。", vbExclamation, App.Title
            txtStrAge.SetFocus
            Exit Do
        End If
        
        '年齢（上）の数値チェック
        If IsNumeric(txtEndAge.Text) = False Then
            MsgBox "年齢適用範囲には数値を入力してください。", vbExclamation, App.Title
            txtEndAge.SetFocus
            Exit Do
        End If
        
        txtStrAge.Text = Trim(txtStrAge.Text)
        txtEndAge.Text = Trim(txtEndAge.Text)

        '年齢（上下）が逆のチェック
        If CDbl(txtStrAge.Text) > CDbl(txtEndAge.Text) Then
            '勝手に逆さにします。
            strWorkResult = txtEndAge.Text
            txtEndAge.Text = txtStrAge.Text
            txtStrAge.Text = strWorkResult
        End If

'## 2002.05.02 Added by Ishihara@FSIT 年齢（上）に小数点が指定されていない場合、小数点を追加する
        '年齢（上限）に最大値としての.99を追加
        If (CDbl(txtEndAge.Text) - Int(CDbl(txtEndAge.Text))) = 0 Then
            If Mid(Trim(txtEndAge.Text), Len(Trim(txtEndAge.Text)), 1) = "." Then
                txtEndAge.Text = txtEndAge.Text & "99"
            Else
                txtEndAge.Text = txtEndAge.Text & ".99"
            End If
        End If
'## 2002.05.02 Added End
        
        '基準値のチェック
        If (Trim(txtLowerValue.Text) = "") And (Trim(txtUpperValue.Text) = "") Then
            MsgBox "基準値が入力されていません。", vbExclamation, App.Title
            
            If (mstrResultType = RESULTTYPE_TEISEI1) Or _
               (mstrResultType = RESULTTYPE_TEISEI2) Then
                cboTeisei.SetFocus
            Else
                If txtLowerValue.Visible = True Then txtLowerValue.SetFocus
            End If
            
            Exit Do
        End If
        
        '結果タイプが文章の場合の基準値
        If mstrResultType = RESULTTYPE_SENTENCE Then
            
            If Trim(txtLowerValue.Text) = "" Then
                MsgBox "基準値が入力されていません。", vbExclamation, App.Title
                If txtLowerValue.Visible = True Then txtLowerValue.SetFocus
            End If
            
            txtLowerValue.Text = Trim(txtLowerValue.Text)
            txtUpperValue.Text = txtLowerValue.Text
        
            '文章カウント数がインクリメントされていないなら、直接入力（されているならガイドからの選択。ノーチェック）
            If mintSentenceCount < 1 Then
                            
                '文章コードのチェック
                If EditSentence() = False Then
                    If txtLowerValue.Visible = True Then txtLowerValue.SetFocus
                    lblSentence.Caption = ""
                    Exit Do
                End If
            
                '自力で配列作成
                Erase mvntStcCode
                Erase mvntSentence
                ReDim Preserve mvntStcCode(0)
                ReDim Preserve mvntSentence(0)
                mvntStcCode(0) = txtLowerValue.Text
                mvntSentence(0) = lblSentence.Caption
                mintSentenceCount = 1
            
            End If
                        
        End If

        '基準値の数値チェック（数値タイプ、計算タイプの場合のみ）
        If (mstrResultType = RESULTTYPE_NUMERIC) Or _
           (mstrResultType = RESULTTYPE_CALC) Then
            
            '基準値（下）の入力チェック（勝手につっこむ）
            If Trim(txtLowerValue.Text) = "" Then
                txtLowerValue.Text = -9999999
            End If
                    
            '基準値（上）の入力チェック（勝手につっこむ）
            If Trim(txtUpperValue.Text) = "" Then
                txtUpperValue.Text = 99999999
            End If
                    
            '数値チェック
            If (IsNumeric(txtLowerValue.Text) = False) Or _
               (IsNumeric(txtUpperValue.Text) = False) Then
                MsgBox "基準値には数値を入力してください。", vbExclamation, App.Title
                txtLowerValue.SetFocus
                Exit Do
            End If
                    
            '基準値の上下が逆なら勝手にセットしかえす
            If CDbl(txtUpperValue.Text) < CDbl(txtLowerValue.Text) Then
                strWorkResult = txtUpperValue.Text
                txtUpperValue.Text = txtLowerValue.Text
                txtLowerValue.Text = strWorkResult
            End If
                    
        End If
        
        '結果タイプが定性の場合、基準値（大）に同じものをセット
        If (mstrResultType = RESULTTYPE_TEISEI1) Or _
           (mstrResultType = RESULTTYPE_TEISEI2) Then
            txtUpperValue.Text = txtLowerValue.Text
        End If
        
        '判定コメントコードのチェック
        If EditJudCmtStc() = False Then
            txtJudCmtCd.SetFocus
            lblJudCmtStc.Caption = ""
            Exit Do
        End If
        
        'ヘルスポイントの数値チェック
        If Trim(txtHealthPoint.Text) <> "" Then
            
            If (IsNumeric(txtHealthPoint.Text) = False) Then
                MsgBox "ヘルスポイントには数値を入力してください。", vbExclamation, App.Title
                txtHealthPoint.SetFocus
                Exit Do
            End If
        
            If (CDbl(txtHealthPoint.Text) > 999.9) Or _
               (CDbl(txtHealthPoint.Text) < -999.9) Then
                MsgBox "ヘルスポイントに設定可能な値は-999.9～999.9です。", vbExclamation, App.Title
                txtHealthPoint.SetFocus
                Exit Do
            End If
        
        End If

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

Private Sub cmdSentence_Click()
    
    Dim objCommonGuide  As mntCommonGuide.CommonGuide   '項目ガイド表示用
    Dim i               As Long     'インデックス
    Dim intRecordCount  As Integer
    Dim vntCode         As Variant
    Dim vntName         As Variant
    
    'オブジェクトのインスタンス作成
    Set objCommonGuide = New mntCommonGuide.CommonGuide
    
    With objCommonGuide
        .MultiSelect = mblnModeNew  '複数選択はモードにより可変
        .TargetTable = getSentence
        .ItemType = mintItemType
        .ItemCd = mstrStcItemCd
    
        '文章ガイド画面を開く
        .Show vbModal
    
        intRecordCount = .RecordCount
        vntCode = .RecordCode
        vntName = .RecordName
    
    End With
        
    '選択件数が0件以上なら
    If intRecordCount > 0 Then
    
        '選択レコード数が１個ならテキストボックスにセット
        If intRecordCount = 1 Then
            txtLowerValue.Text = vntCode(0)
            lblSentence.Caption = vntName(0)
        Else
            txtLowerValue.Text = "*"
            lblSentence.Caption = "複数の文章が選択されています。"
        End If
        
        '文章格納用配列に格納
        Erase mvntStcCode
        Erase mvntSentence
        mintSentenceCount = 0

        ReDim Preserve mvntStcCode(intRecordCount)
        ReDim Preserve mvntSentence(intRecordCount)
        
        '配列に格納
        For i = 0 To intRecordCount - 1
            mvntStcCode(i) = vntCode(i)
            mvntSentence(i) = vntName(i)
            mintSentenceCount = mintSentenceCount + 1
        Next i
        
    End If

    Set objCommonGuide = Nothing
    Screen.MousePointer = vbDefault

End Sub

Private Sub Form_Load()

    Dim i       As Integer

    mblnUpdated = False

    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)
    cboTeisei.Clear
    cboTeisei.Visible = False
    cmdSentence.Visible = False

    '検査項目履歴情報の編集
    Call SetItemHistory

    '基準値フラグのコンボセット
    With cboStdFlg
        .Clear
        .AddItem ""
        .AddItem "S:標準"
        .AddItem "X:標準（基準値外）"
        .AddItem "@:定性軽度異常"
        .AddItem "*:定性値異常"
        .AddItem "L:異常（下）"
        .AddItem "D:軽度異常（下）"
        .AddItem "U:軽度異常（上）"
        .AddItem "H:異常（上）"
        .ListIndex = 0
    End With
    
    '基準値フラグのコンボ対応配列
    ReDim Preserve mstrArrStdFlg(8)
    mstrArrStdFlg(0) = ""
    mstrArrStdFlg(1) = "S"
    mstrArrStdFlg(2) = "X"
    mstrArrStdFlg(3) = "@"
    mstrArrStdFlg(4) = "*"
    mstrArrStdFlg(5) = "L"
    mstrArrStdFlg(6) = "D"
    mstrArrStdFlg(7) = "U"
    mstrArrStdFlg(8) = "H"
    
    '判定コンボの編集
    If EditJud() = False Then
        Exit Sub
    End If
    
    'プロパティ値の画面セット
    txtStrAge.Text = mstrStrAge
    txtEndAge.Text = mstrEndAge
    
    '基準値複数選択の場合、値には"0"をセット
    If mblnMultiSelect = True Then
        txtLowerValue.Text = "0"
        txtUpperValue.Text = "0"
    Else
        txtLowerValue.Text = mstrLowerValue
        txtUpperValue.Text = mstrUpperValue
    End If
    
    '基準値（下）がセットされてないということは、新規モード
    If Trim(mstrLowerValue) = "" Then
        mblnModeNew = True
    Else
        mblnModeNew = False
    End If
    
    txtHealthPoint.Text = mstrHealthPoint
    txtJudCmtCd.Text = mstrJudCmtCd
    
    '判定コメント文書の表示
    Call EditJudCmtStc
    
    'デフォルトセットされた基準値セット
    If mstrStdFlg <> "" Then
        For i = 0 To UBound(mstrArrStdFlg)
            If mstrArrStdFlg(i) = mstrStdFlg Then
                cboStdFlg.ListIndex = i
            End If
        Next i
    End If
    
    'デフォルトセットされた判定コードセット
    If mstrJudCd <> "" Then
        For i = 0 To UBound(mstrArrJudCd)
            If mstrArrJudCd(i) = mstrJudCd Then
                cboJud.ListIndex = i
            End If
        Next i
    End If
    
    '年齢がセットされていないなら、勝手にセット（大きなお世話シリーズ）
    If txtStrAge.Text = "" Then txtStrAge.Text = DefaultStrAge
    If txtEndAge.Text = "" Then txtEndAge.Text = DefaultEndAge
    
    Select Case mstrResultType
        
        '定性タイプ１
        Case RESULTTYPE_TEISEI1
            
            '入力用テキストボックス不要
            txtLowerValue.Visible = False
            txtUpperValue.Visible = False
            LabelValue.Visible = False
            cboTeisei.Visible = True
            
            mstrArrTeisei(0) = "-"
            mstrArrTeisei(1) = "+-"
            mstrArrTeisei(2) = "+"
            With cboTeisei
                .AddItem "（－）"
                .AddItem "（＋－）"
                .AddItem "（＋）"
                .ListIndex = 0
            End With
                    
            For i = 0 To 2
                If (mstrArrTeisei(i) = txtLowerValue) Or _
                   (mstrArrTeisei(i) = txtUpperValue) Then
                    cboTeisei.ListIndex = i
                End If
            Next i
        
        '定性タイプ２
        Case RESULTTYPE_TEISEI2
            
            '入力用テキストボックス不要
            txtLowerValue.Visible = False
            txtUpperValue.Visible = False
            LabelValue.Visible = False
            cboTeisei.Visible = True
            
            mstrArrTeisei(0) = "-"
            mstrArrTeisei(1) = "+-"
            With cboTeisei
                .AddItem "（－）"
                .AddItem "（＋－）"
                For i = 1 To 9
'## 2003.02.12 Mod 4Lines By T.Takagi@FSIT 結果入力で「１＋」は入力できない（正解は「＋」）なので合致するよう修正
'                    .AddItem "（" & StrConv(CStr(i), vbWide) & "＋）"
'                    mstrArrTeisei(i + 1) = i & "+"
                    .AddItem "（" & StrConv(IIf(i >= 2, CStr(i), ""), vbWide) & "＋）"
                    mstrArrTeisei(i + 1) = IIf(i >= 2, CStr(i), "") & "+"
'## 2003.02.12 Mod End
                Next i
            End With
                    
            For i = 0 To 10
                If (mstrArrTeisei(i) = txtLowerValue) Or _
                   (mstrArrTeisei(i) = txtUpperValue) Then
                    cboTeisei.ListIndex = i
                End If
            Next i
        
        '文章タイプのセット
        Case RESULTTYPE_SENTENCE
        
            '開始入力用テキストボックス不要
            txtUpperValue.Visible = False
            LabelValue.Visible = False
            cmdSentence.Visible = True
            
            '文章タイプの場合、文章は基準値（上）に格納されている
            lblSentence.Caption = Trim(mstrUpperValue)
        
    End Select
    
    '基準値複数選択の場合、基準値入力関係のコントロールは全部使用不可
    If mblnMultiSelect = True Then
        txtUpperValue.Visible = False
        txtLowerValue.Visible = False
        LabelValue.Visible = False
        cmdSentence.Visible = False
        lblSentence.Visible = False
    
        '文章選択済みのハンドリング
        mintSentenceCount = 1
    End If

End Sub

Private Sub SetItemHistory()

    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim objItemHistory      As ItemHistory
    Dim strDateInterval     As String
    Dim i                   As Long             'インデックス
    
    'ヘッダの編集
    lsvUnit.ListItems.Clear
    Set objHeader = lsvUnit.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "有効期間", 2600, lvwColumnLeft
    objHeader.Add , , "整数部", 800, lvwColumnRight
    objHeader.Add , , "小数部", 800, lvwColumnRight
    objHeader.Add , , "最小値", 900, lvwColumnRight
    objHeader.Add , , "最大値", 900, lvwColumnRight
        
    lsvUnit.View = lvwReport
    
    'リストの編集
    For Each objItemHistory In mcolItemHistory
        With objItemHistory
            strDateInterval = .strDate & "～" & .endDate
            Set objItem = lsvUnit.ListItems.Add(, .UniqueKey, strDateInterval, , "DEFAULTLIST")
            objItem.SubItems(1) = .Figure1
            objItem.SubItems(2) = .Figure2
            objItem.SubItems(3) = .MinValue
            objItem.SubItems(4) = .MaxValue
        End With
    Next objItemHistory
    
    'オブジェクト廃棄
    Set objItemHistory = Nothing

End Sub

'
' 機能　　 : 判定コメント文章編集
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditJudCmtStc() As Boolean

    Dim objJudCmtStc    As Object           '判定コメントアクセス用
    
    Dim vntJudCmtStc    As Variant          '判定コメント名
    Dim vntJudClassCd   As Variant          '判定分類コード
    Dim Ret             As Boolean          '戻り値
    Dim i               As Integer
    
    On Error GoTo ErrorHandle
    
    EditJudCmtStc = False

    'オブジェクトのインスタンス作成
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    
    Do
        '判定コメントコードが指定されていない場合は何もしない
        If Trim(txtJudCmtCd.Text) = "" Then
            Ret = True
            Exit Do
        End If
        
        '判定コメントテーブルレコード読み込み
        If objJudCmtStc.SelectJudCmtStc(Trim(txtJudCmtCd.Text), _
                                        vntJudCmtStc, _
                                        vntJudClassCd) = False Then
            MsgBox "指定された判定コメントコードの条件を満たすレコードが存在しません。", vbExclamation, App.Title
            Exit Do
        End If
    
        '要約の為、改行コードを除去してセット
        lblJudCmtStc.Caption = OmitCrLf(CStr(vntJudCmtStc))
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditJudCmtStc = Ret
    
    Exit Function

ErrorHandle:

    EditJudCmtStc = False
    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : 文章データ編集
'
' 引数　　 : なし
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Private Function EditSentence() As Boolean

    Dim objSentence     As Object           '文章アクセス用
    Dim vntShortStc     As Variant          '略称
    Dim Ret             As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objSentence = CreateObject("HainsSentence.Sentence")
    
    Do
        
        '文章コードが指定されていない場合は何もしない
        If Trim(txtLowerValue.Text) = "" Then
            Ret = False
            Exit Do
        End If
        
        '文章テーブルレコード読み込み
        If objSentence.SelectSentence(mstrStcItemCd, _
                                      mintItemType, _
                                      Trim(txtLowerValue.Text), _
                                      vntShortStc) = False Then
            MsgBox "指定された文章コードの条件を満たすレコードが存在しません。", vbExclamation, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        lblSentence.Caption = vntShortStc
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditSentence = Ret
    
    Exit Function

ErrorHandle:

    EditSentence = False
    MsgBox Err.Description, vbCritical
    
End Function



Friend Property Get ResultType() As Variant
    
    ResultType = mstrResultType

End Property

Friend Property Let ResultType(ByVal vNewValue As Variant)

    mstrResultType = vNewValue

End Property

Friend Property Get StrAge() As Variant
    
    StrAge = mstrStrAge

End Property

Friend Property Let StrAge(ByVal vNewValue As Variant)

    mstrStrAge = vNewValue

End Property

Friend Property Get EndAge() As Variant

    EndAge = mstrEndAge

End Property

Friend Property Let EndAge(ByVal vNewValue As Variant)

    mstrEndAge = vNewValue

End Property

Friend Property Get LowerValue() As Variant

    LowerValue = mstrLowerValue

End Property

Friend Property Let LowerValue(ByVal vNewValue As Variant)

    mstrLowerValue = vNewValue

End Property

Friend Property Get UpperValue() As Variant

    UpperValue = mstrUpperValue

End Property

Friend Property Let UpperValue(ByVal vNewValue As Variant)

    mstrUpperValue = vNewValue
    
End Property

Friend Property Get StdFlg() As Variant

    StdFlg = mstrStdFlg

End Property

Friend Property Let StdFlg(ByVal vNewValue As Variant)

    mstrStdFlg = vNewValue
    
End Property

Friend Property Get JudCd() As Variant

    JudCd = mstrJudCd

End Property

Friend Property Let JudCd(ByVal vNewValue As Variant)

    mstrJudCd = vNewValue

End Property

Friend Property Get JudCmtCd() As Variant

    JudCmtCd = mstrJudCmtCd

End Property

Friend Property Let JudCmtCd(ByVal vNewValue As Variant)

    mstrJudCmtCd = vNewValue

End Property

Friend Property Get HealthPoint() As Variant

    HealthPoint = mstrHealthPoint

End Property

Friend Property Let HealthPoint(ByVal vNewValue As Variant)

    mstrHealthPoint = vNewValue

End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Private Sub txtJudCmtCd_Change()

    lblJudCmtStc.Caption = ""

End Sub

Private Sub txtJudCmtCd_LostFocus()

    If Trim(txtJudCmtCd.Text) = "" Then
        lblJudCmtStc.Caption = ""
    End If

End Sub

Friend Property Let ItemType(ByVal vNewValue As String)

    mintItemType = vNewValue

End Property

Friend Property Let StcItemCd(ByVal vNewValue As String)

    mstrStcItemCd = vNewValue

End Property

Friend Property Let MultiSelect(ByVal vNewValue As Boolean)

    mblnMultiSelect = vNewValue

End Property

Friend Property Get SentenceCount() As Integer

    SentenceCount = mintSentenceCount

End Property

Friend Property Get StcCd() As Variant

    StcCd = mvntStcCode

End Property

Friend Property Get Sentence() As Variant

    Sentence = mvntSentence

End Property

Private Sub txtLowerValue_Change()

    '文章クリア（文章タイプ以外は関係ありませんが）
    lblSentence.Caption = ""

    '文章配列クリア
    Erase mvntStcCode
    Erase mvntSentence
    mintSentenceCount = 0

End Sub

Friend Property Let ItemHistory(ByVal vNewValue As Collection)

    Set mcolItemHistory = vNewValue
    
End Property
