VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmCommonGuide 
   Caption         =   "項目ガイド"
   ClientHeight    =   5940
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5205
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmCommonGuide.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   5940
   ScaleWidth      =   5205
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CommandButton cmdSearch 
      Caption         =   "検索(&F)"
      Height          =   315
      Left            =   3840
      TabIndex        =   1
      Top             =   600
      Width           =   1215
   End
   Begin VB.TextBox txtOrgName 
      Height          =   315
      Left            =   780
      TabIndex        =   0
      Top             =   600
      Visible         =   0   'False
      Width           =   3015
   End
   Begin VB.ComboBox cboAnyClass 
      Height          =   300
      ItemData        =   "frmCommonGuide.frx":0442
      Left            =   780
      List            =   "frmCommonGuide.frx":0464
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   2
      Top             =   600
      Width           =   4290
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2340
      TabIndex        =   4
      Top             =   5520
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3780
      TabIndex        =   5
      Top             =   5520
      Width           =   1335
   End
   Begin MSComctlLib.ListView lsvItem 
      Height          =   4275
      Left            =   120
      TabIndex        =   3
      Top             =   1080
      Width           =   4995
      _ExtentX        =   8811
      _ExtentY        =   7541
      LabelEdit       =   1
      MultiSelect     =   -1  'True
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      _Version        =   393217
      Icons           =   "imlToolbarIcons"
      SmallIcons      =   "imlToolbarIcons"
      ColHdrIcons     =   "imlToolbarIcons"
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   0
   End
   Begin MSComctlLib.ImageList imlToolbarIcons 
      Left            =   180
      Top             =   5340
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
            Picture         =   "frmCommonGuide.frx":0486
            Key             =   "CLOSED"
         EndProperty
         BeginProperty ListImage2 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCommonGuide.frx":08D8
            Key             =   "OPEN"
         EndProperty
         BeginProperty ListImage3 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCommonGuide.frx":0D2A
            Key             =   "MYCOMP"
         EndProperty
         BeginProperty ListImage4 {2C247F27-8591-11D1-B16A-00C0F0283628} 
            Picture         =   "frmCommonGuide.frx":0E84
            Key             =   "DEFAULTLIST"
         EndProperty
      EndProperty
   End
   Begin VB.Label Label5 
      Caption         =   "項目を選択してください"
      Height          =   255
      Left            =   780
      TabIndex        =   6
      Top             =   300
      Width           =   4275
   End
   Begin VB.Image Image1 
      Height          =   720
      Index           =   4
      Left            =   0
      Picture         =   "frmCommonGuide.frx":0FDE
      Top             =   60
      Width           =   720
   End
End
Attribute VB_Name = "frmCommonGuide"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'プロパティ用定義領域
Private mblnRet             As Boolean  '戻り値

Private mintTargetTable     As Integer  '読み込みテーブル種類
Private mblnMultiSelect     As Boolean  'リストビューの複数選択

Private mstrItemCd          As String   '検査項目コード（文章ガイドで使用）
Private mstrItemType        As String   '項目タイプ（文章ガイドで使用）

Private mblnNowEdit         As Boolean  'TRUE:編集中、FALSE:表示用編集可能

Private mintRecordCount     As Integer  '選択された項目数
Private mvntRecordCode()    As Variant  '選択された項目コード
Private mvntRecordName()    As Variant  '選択された項目名

Private mstrClassCd()       As String   'コンボボックスに対応する分類コード

'固定コード管理
Const KEY_PREFIX            As String = "K"

Public Property Get Ret() As Variant

    Ret = mblnRet

End Property

' @(e)
'
' 機能　　 : 「検査分類コンボ」Click
'
' 機能説明 : 検査分類コンボ内容を変更された時に、検査項目表示内容を変更する。
'
' 備考　　 :
'
Private Sub cboAnyClass_Click()

    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If

    '項目リスト編集
    Call SetListViewData

End Sub

' @(e)
'
' 機能　　 : 「キャンセル」Click
'
' 機能説明 : フォームを閉じる
'
' 備考　　 :
'
Private Sub CMDcancel_Click()

    mintRecordCount = 0
    Unload Me
    
End Sub

' @(e)
'
' 機能　　 : 「ＯＫ」クリック
'
' 機能説明 : 入力内容を適用し、画面を閉じる
'
' 備考　　 :
'
Private Sub CMDok_Click()

    Dim X           As Object
    Dim i           As Integer
    Dim j           As Integer
    Dim strWorkKey  As String
    Dim lngPointer  As Long

    '処理中の場合は何もしない
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '変数初期化
    mintRecordCount = 0
    j = 0
    Erase mvntRecordCode
    Erase mvntRecordName

    Do
    
        '何も選択されていないならお終い
        If lsvItem.SelectedItem Is Nothing Then
            MsgBox "項目が何も選択されていません。", vbExclamation
            Exit Do
        End If
        
        'リストビューをくるくる回して選択項目配列作成
        For i = 1 To lsvItem.ListItems.Count
            If lsvItem.ListItems(i).Selected = True Then
                
                'カウントアップ
                mintRecordCount = mintRecordCount + 1
                                
                '配列拡張
                ReDim Preserve mvntRecordCode(j)
                ReDim Preserve mvntRecordName(j)
                
                'リストビュー用のキープリフィックスを削除
                strWorkKey = Mid(lsvItem.ListItems(i).Key, 2, Len(lsvItem.ListItems(i).Key))
'                lngPointer = InStr(strWorkKey, "-")
'                If lngPointer <> 0 Then
'                    mvntRecordCode(j) = Mid(strWorkKey, 1, lngPointer - 1)
'                Else
                    mvntRecordCode(j) = strWorkKey
'                End If
                
                mvntRecordName(j) = lsvItem.ListItems(i).SubItems(1)
                j = j + 1
            
            End If
        Next i
            
        '何も選択されていないならお終い
        If mintRecordCount = 0 Then
            MsgBox "項目が何も選択されていません。", vbExclamation
            Exit Do
        End If
            
        '画面を閉じる
        Unload Me
        
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub cmdSearch_Click()

    Call EditListViewFromOrg

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
    mintRecordCount = 0
    mblnNowEdit = True
    lsvItem.MultiSelect = mblnMultiSelect

    Do

        '分類用コンボボックスのセット
        If SetConboData = False Then Exit Do
    
        '指定リストビューのセット
        If SetListViewData = False Then Exit Do
    
        Ret = True
        Exit Do
    
    Loop
    
    '戻り値の設定
    mblnRet = Ret
    
    '処理中の解除
    mblnNowEdit = False
    
    Screen.MousePointer = vbDefault

End Sub

Private Sub Form_Resize()
    
    If Me.WindowState <> vbMinimized Then
        Call SizeControls
    End If

End Sub

'
' 機能　　 : 各種コントロールのサイズ変更
'
' 引数　　 : なし
'
' 戻り値　 :
'
' 備考　　 : ツリービュー・リストビュー・スプリッター・ラベル等のサイズを変更する
'
Private Sub SizeControls()
    
    '幅変更
    If Me.Width > 4546 Then
        lsvItem.Width = Me.Width - 320
        cmdOk.Left = Me.Width - 3015
        cmdCancel.Left = cmdOk.Left + 1440
    End If
    
    '高さ変更
    If Me.Height > 3000 Then
        lsvItem.Height = Me.Height - 2000
        cmdOk.Top = Me.Height - 795
        cmdCancel.Top = cmdOk.Top
    End If

End Sub

Private Sub lsvItem_DblClick()

    Call CMDok_Click
    
End Sub

Public Property Get RecordName() As Variant

    RecordName = mvntRecordName

End Property
Public Property Get RecordCount() As Variant

    RecordCount = mintRecordCount

End Property

Public Property Get RecordCode() As Variant

    RecordCode = mvntRecordCode
    
End Property

Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)

    Dim i As Long

    'CTRL+Aを押下された場合、項目を全て選択する
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem.ListItems.Count
            lsvItem.ListItems(i).Selected = True
        Next i
    End If
    
End Sub

Friend Property Let MultiSelect(ByVal vNewValue As Boolean)

    mblnMultiSelect = vNewValue

End Property

Friend Property Let TargetTable(ByVal vNewValue As Integer)

    mintTargetTable = vNewValue

End Property

Private Function SetConboData() As Boolean

    SetConboData = False
    
    Select Case mintTargetTable
        
        Case getSentence        '文章ガイド
            cboAnyClass.Visible = False
            
        Case getJudCmtStc       '判定コメント
                
            '判定分類コンボセット
            If EditJudClass() = False Then
                Exit Function
            End If
        
        Case getZaimu           '財務適用コードガイド
            cboAnyClass.Visible = False
        
        Case getZaimuOrg        '財務連携用団体コードガイド
            cboAnyClass.Visible = False
            txtOrgName.Visible = True
            cmdSearch.Visible = True
            cmdOk.Default = False
        
        Case Else
            Exit Function
    End Select
    
    SetConboData = True
    
End Function

Private Function SetListViewData() As Boolean

    SetListViewData = False
    
    Select Case mintTargetTable
        Case getSentence        '文章
                
            '文章テーブルセット
            If EditListViewFromSentence() = False Then
                Exit Function
            End If
        
        Case getJudCmtStc       '判定コメント
                
            '判定コメントセット
            If EditListViewFromJudCmtStc() = False Then
                Exit Function
            End If
        
        Case getZaimu           '財務適用コード
                
            '財務適用コードセット
            If EditListViewFromZaimu() = False Then
                Exit Function
            End If
        
        Case getZaimuOrg        '財務用団体コード
                
            '財務適用コードセット
'            If EditListViewFromZaimu() = False Then
'                Exit Function
'            End If
        
        Case Else
            Exit Function
    End Select
    
    SetListViewData = True
    
End Function

'
' 機能　　 : 財務用団体コード一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : コンボで指定された判定分類コードに該当する判定コメントを表示する。
'
Private Function EditListViewFromOrg() As Boolean

On Error GoTo ErrorHandle

    Dim objOrg              As Object           '判定コメントアクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntOrgCd1           As Variant          '団体コード１
    Dim vntOrgCd2           As Variant          '団体コード２
    Dim vntOrgName          As Variant          '団体名
    Dim vntOrgSName         As Variant          '略称
    Dim vntOrgKName         As Variant          'カナ名称
    
    Dim i                   As Long             'インデックス
    Dim lngCount            As Long
    Dim strArrKey           As Variant
    
    EditListViewFromOrg = False

    'オブジェクトのインスタンス作成
    Set objOrg = CreateObject("HainsOrganization.Organization")
    
    '検索キーを空白で分割する
    strArrKey = SplitByBlank(txtOrgName.Text)
    lngCount = objOrg.SelectOrgList(strArrKey, _
                                    1, _
                                    30000, _
                                    vntOrgCd1, _
                                    vntOrgCd2, _
                                    vntOrgName, _
                                    vntOrgSName, _
                                    vntOrgKName)
    
    'ヘッダの編集
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "団体コード", 1300, lvwColumnLeft
    objHeader.Add , , "団体名", 5000, lvwColumnLeft
    objHeader.Add , , "団体カナ名", 5000, lvwColumnLeft
        
    lsvItem.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & vntOrgCd1(i) & vntOrgCd2(i), vntOrgCd1(i) & vntOrgCd2(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntOrgName(i)
        objItem.SubItems(2) = vntOrgKName(i)
    Next i
    
    'オブジェクト廃棄
    Set objOrg = Nothing
    
    EditListViewFromOrg = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 空白による文字列の分割
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : 分割された文字列の配列
'
' 備考　　 : 通常のSplit関数では空白文字が複数並んだ場合に対応できないため作成
'
'-------------------------------------------------------------------------------
Private Function SplitByBlank(strExpression As String) As Variant

    Dim strBuffer  As String '変換処理後の文字列バッファ

    If Trim(strExpression) = "" Then
        SplitByBlank = Empty
        Exit Function
    End If

    '全角空白を半角空白に置換する
    strBuffer = Replace(Trim(strExpression), "　", " ")

    '2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
    Do Until InStr(1, strBuffer, "  ") = 0
        strBuffer = Replace(strBuffer, "  ", " ")
    Loop

    '1バイト半角空白をデリミタとして配列を作成
    SplitByBlank = Split(strBuffer, " ")

End Function

' @(e)
'
' 機能　　 : 判定分類データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 判定分類データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditJudClass() As Boolean

    Dim objJudClass         As Object       '判定分類アクセス用
    Dim vntJudClassCd       As Variant
    Dim vntJudClassName     As Variant

    Dim lngCount    As Long             'レコード数
    Dim i           As Long             'インデックス
    
    EditJudClass = False
    
    cboAnyClass.Clear
    Erase mstrClassCd

    'オブジェクトのインスタンス作成
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)
    
    '判定分類コードは未選択あり
    ReDim Preserve mstrClassCd(0)
    mstrClassCd(0) = ""
    cboAnyClass.AddItem ""
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrClassCd(i + 1)
        mstrClassCd(i + 1) = vntJudClassCd(i)
        cboAnyClass.AddItem vntJudClassName(i)
    Next i
    
    '先頭コンボを選択状態にする（判定分類は未選択あり）
    cboAnyClass.ListIndex = 0
    
    EditJudClass = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

'
' 機能　　 : 判定コメント一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 : コンボで指定された判定分類コードに該当する判定コメントを表示する。
'
Private Function EditListViewFromJudCmtStc() As Boolean

On Error GoTo ErrorHandle

    Dim objJudCmtStc        As Object           '判定コメントアクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    
    Dim vntJudCmtCd         As Variant          '判定コメントコード
    Dim vntJudCmtStcName    As Variant          '判定コメント名
    Dim vntDummy(2)         As Variant          'COM+引数用ダミー変数
    
    Dim i                   As Long             'インデックス
    Dim lngCount            As Long
    
    EditListViewFromJudCmtStc = False

    'オブジェクトのインスタンス作成
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    lngCount = objJudCmtStc.SelectJudCmtStcList(mstrClassCd(cboAnyClass.ListIndex), _
                                                vntDummy(0), _
                                                1, _
                                                "", _
                                                vntJudCmtCd, _
                                                vntJudCmtStcName, _
                                                vntDummy(1), _
                                                vntDummy(2))
    
    'ヘッダの編集
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "コード", 1300, lvwColumnLeft
    objHeader.Add , , "判定コメント", 5000, lvwColumnLeft
        
    lsvItem.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & vntJudCmtCd(i), vntJudCmtCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntJudCmtStcName(i)
    Next i
    
    'オブジェクト廃棄
    Set objJudCmtStc = Nothing
    
    EditListViewFromJudCmtStc = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : 財務適用コード一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
Private Function EditListViewFromZaimu() As Boolean

On Error GoTo ErrorHandle

    Dim objZaimu            As Object           '財務適用コードアクセス用
    Dim objHeader           As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem             As ListItem         'リストアイテムオブジェクト
    Dim vntZaimuCd          As Variant          '財務コードコード
    Dim vntZaimuName        As Variant            '財務適用名
    Dim vntZaimuDiv         As Variant          '財務種別
    Dim vntZaimuClass       As Variant          '財務分類
    Dim i                   As Long             'インデックス
    Dim strZaimuClassName   As String
    Dim strZaimuDivName     As String
    Dim lngCount            As Long
    
    EditListViewFromZaimu = False
    
    'オブジェクトのインスタンス作成
    Set objZaimu = CreateObject("HainsZaimu.Zaimu")
    lngCount = objZaimu.SelectZaimuList(vntZaimuCd, vntZaimuName, vntZaimuDiv, vntZaimuClass)
    
    'ヘッダの編集
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "財務適用コード", 1500, lvwColumnLeft
    objHeader.Add , , "財務適用名", 3300, lvwColumnLeft
    objHeader.Add , , "財務種別", 1500, lvwColumnLeft
    objHeader.Add , , "財務分類", 1300, lvwColumnLeft
        
    lsvItem.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Select Case vntZaimuClass(i)
            Case 0
                strZaimuClassName = "未分類"
            Case 1
                strZaimuClassName = "個人"
            Case 2
                strZaimuClassName = "団体"
            Case 3
                strZaimuClassName = "電話料金"
            Case 4
                strZaimuClassName = "文書作成"
            Case 5
                strZaimuClassName = "その他収入"
            Case Else
                strZaimuClassName = vntZaimuClass(i)
        End Select
        
        Select Case vntZaimuDiv(i)
            Case 1
                strZaimuDivName = "未収"
            Case 2
                strZaimuDivName = "入金"
            Case 3
                strZaimuDivName = "過去未収金"
            Case 4
                strZaimuDivName = "還付"
            Case 5
                strZaimuDivName = "還付未払"
            Case Else
                strZaimuDivName = vntZaimuDiv(i)
        End Select
        
        Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & vntZaimuCd(i), vntZaimuCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntZaimuName(i)
        objItem.SubItems(2) = strZaimuDivName
        objItem.SubItems(3) = strZaimuClassName
    
    Next i
    
    'オブジェクト廃棄
    Set objZaimu = Nothing
    
    EditListViewFromZaimu = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function

'
' 機能　　 : 文章一覧表示
'
' 引数　　 : なし
'
' 戻り値　 :
'
' 備考　　 :
'
Private Function EditListViewFromSentence() As Boolean

On Error GoTo ErrorHandle

    Dim objSentence     As Object           '文章アクセス用
    Dim objHeader       As ColumnHeaders    'カラムヘッダオブジェクト
    Dim objItem         As ListItem         'リストアイテムオブジェクト
    
    Dim vntItemCd       As Variant          '検査項目コード
    Dim vntItemType     As Variant          '項目タイプ
    Dim vntStcCd        As Variant          '文章コード
    Dim vntShortStc     As Variant          '略称
    Dim lngCount        As Long
    
    Dim i               As Long             'インデックス
    
    EditListViewFromSentence = False

    '検査項目コードと項目タイプが指定されていないなら文章ガイドは表示できませ～ん
    If (Trim(mstrItemCd) = "") Or (Trim(mstrItemType) = "") Then
        MsgBox "検査項目コード、もしくは項目タイプが指定されていません。" & vbLf & _
               "項目ガイドは表示できません。" & vbLf & vbLf & _
               "検査項目コード：" & mstrItemCd & vbLf & _
               "項目タイプ：" & mstrItemType, vbCritical, Me.Caption
        Exit Function
    End If
    
    'オブジェクトのインスタンス作成
    Set objSentence = CreateObject("HainsSentence.Sentence")
    lngCount = objSentence.SelectSentenceList(mstrItemCd, _
                                              mstrItemType, _
                                              vntStcCd, _
                                              vntShortStc)
    
    'レコード件数が１件もないならガイド表示する意味なし
    If lngCount < 1 Then
        MsgBox "文章結果が１件も登録されていません", vbExclamation, Me.Caption
        Exit Function
    End If
    
    'ヘッダの編集
    lsvItem.ListItems.Clear
    Set objHeader = lsvItem.ColumnHeaders
    objHeader.Clear
    objHeader.Add , , "項目コード", 1000, lvwColumnLeft
    objHeader.Add , , "文章名", 2200, lvwColumnLeft
        
    lsvItem.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, KEY_PREFIX & vntStcCd(i), vntStcCd(i), , "DEFAULTLIST")
        objItem.SubItems(1) = vntShortStc(i)
    Next i
    
    'オブジェクト廃棄
    Set objSentence = Nothing
    
    EditListViewFromSentence = True
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical
    
End Function

Public Property Let ItemCd(ByVal vNewValue As String)

    mstrItemCd = vNewValue

End Property

Public Property Let ItemType(ByVal vNewValue As String)

    mstrItemType = vNewValue

End Property

Private Sub txtOrgName_GotFocus()
    
    With txtOrgName
        .SelStart = 0
        .SelLength = Len(.Text)
    End With

End Sub

Private Sub txtOrgName_KeyDown(KeyCode As Integer, Shift As Integer)

    If KeyCode = vbKeyReturn Then
        Call cmdSearch_Click
    End If
    
End Sub
