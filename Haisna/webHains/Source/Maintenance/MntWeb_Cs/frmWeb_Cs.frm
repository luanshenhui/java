VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form frmWeb_Cs 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "WEBコース設定メンテナンス"
   ClientHeight    =   5115
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8895
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmWeb_Cs.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5115
   ScaleWidth      =   8895
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
      Height          =   315
      Left            =   7560
      TabIndex        =   22
      Top             =   4620
      Width           =   1275
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   6120
      TabIndex        =   15
      Top             =   4620
      Width           =   1335
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   4680
      TabIndex        =   14
      Top             =   4620
      Width           =   1335
   End
   Begin TabDlg.SSTab tabMain 
      Height          =   4275
      Left            =   120
      TabIndex        =   16
      Top             =   120
      Width           =   8655
      _ExtentX        =   15266
      _ExtentY        =   7541
      _Version        =   393216
      Style           =   1
      Tab             =   1
      TabHeight       =   520
      TabCaption(0)   =   "基本情報"
      TabPicture(0)   =   "frmWeb_Cs.frx":000C
      Tab(0).ControlEnabled=   0   'False
      Tab(0).Control(0)=   "Label1(2)"
      Tab(0).Control(1)=   "Label8(0)"
      Tab(0).Control(2)=   "Label1(1)"
      Tab(0).Control(3)=   "Label1(0)"
      Tab(0).Control(4)=   "Label2"
      Tab(0).Control(5)=   "txtItemOutLine"
      Tab(0).Control(6)=   "cboCourse"
      Tab(0).Control(7)=   "txtCsName"
      Tab(0).Control(8)=   "txtOutLine"
      Tab(0).ControlCount=   9
      TabCaption(1)   =   "詳細情報"
      TabPicture(1)   =   "frmWeb_Cs.frx":0028
      Tab(1).ControlEnabled=   -1  'True
      Tab(1).Control(0)=   "lsvCsDetail"
      Tab(1).Control(0).Enabled=   0   'False
      Tab(1).Control(1)=   "cmdEditCsDetail"
      Tab(1).Control(1).Enabled=   0   'False
      Tab(1).Control(2)=   "cmdUpItem"
      Tab(1).Control(2).Enabled=   0   'False
      Tab(1).Control(3)=   "cmdDownItem"
      Tab(1).Control(3).Enabled=   0   'False
      Tab(1).Control(4)=   "cmdDeleteCsDetail"
      Tab(1).Control(4).Enabled=   0   'False
      Tab(1).Control(5)=   "cmdAddCsDetail"
      Tab(1).Control(5).Enabled=   0   'False
      Tab(1).ControlCount=   6
      TabCaption(2)   =   "オプション検査"
      TabPicture(2)   =   "frmWeb_Cs.frx":0044
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "cboCtrMng"
      Tab(2).Control(1)=   "cmdEditOpt"
      Tab(2).Control(2)=   "cmdClearOption"
      Tab(2).Control(3)=   "lsvOption"
      Tab(2).Control(4)=   "Label8(1)"
      Tab(2).ControlCount=   5
      Begin VB.ComboBox cboCtrMng 
         Height          =   300
         ItemData        =   "frmWeb_Cs.frx":0060
         Left            =   -73620
         List            =   "frmWeb_Cs.frx":0082
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   20
         Top             =   480
         Width           =   4650
      End
      Begin VB.CommandButton cmdEditOpt 
         Caption         =   "編集(&E)"
         Height          =   315
         Left            =   -69240
         TabIndex        =   18
         Top             =   3780
         Width           =   1275
      End
      Begin VB.CommandButton cmdClearOption 
         Caption         =   "クリア(&C)"
         Height          =   315
         Left            =   -67860
         TabIndex        =   17
         Top             =   3780
         Width           =   1275
      End
      Begin VB.CommandButton cmdAddCsDetail 
         Caption         =   "追加(&D)..."
         Height          =   315
         Left            =   4380
         TabIndex        =   11
         Top             =   3780
         Width           =   1275
      End
      Begin VB.CommandButton cmdDeleteCsDetail 
         Caption         =   "削除(&R)"
         Height          =   315
         Left            =   7140
         TabIndex        =   13
         Top             =   3780
         Width           =   1275
      End
      Begin VB.CommandButton cmdDownItem 
         Caption         =   "↓"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         TabIndex        =   10
         Top             =   1860
         Width           =   315
      End
      Begin VB.CommandButton cmdUpItem 
         Caption         =   "↑"
         BeginProperty Font 
            Name            =   "MS UI Gothic"
            Size            =   9
            Charset         =   128
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   375
         Left            =   240
         TabIndex        =   9
         Top             =   1320
         Width           =   315
      End
      Begin VB.CommandButton cmdEditCsDetail 
         Caption         =   "編集(&E)"
         Height          =   315
         Left            =   5760
         TabIndex        =   12
         Top             =   3780
         Width           =   1275
      End
      Begin VB.TextBox txtOutLine 
         Height          =   600
         Left            =   -73320
         MaxLength       =   50
         MultiLine       =   -1  'True
         TabIndex        =   5
         Text            =   "frmWeb_Cs.frx":00A4
         Top             =   1500
         Width           =   6675
      End
      Begin VB.TextBox txtCsName 
         Height          =   300
         IMEMode         =   4  '全角ひらがな
         Left            =   -73320
         MaxLength       =   15
         TabIndex        =   3
         Text            =   "＠＠＠＠"
         Top             =   1020
         Width           =   6675
      End
      Begin VB.ComboBox cboCourse 
         Height          =   300
         ItemData        =   "frmWeb_Cs.frx":00A7
         Left            =   -73320
         List            =   "frmWeb_Cs.frx":00C9
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   1
         Top             =   600
         Width           =   4650
      End
      Begin VB.TextBox txtItemOutLine 
         Height          =   1440
         Left            =   -73320
         MaxLength       =   150
         MultiLine       =   -1  'True
         TabIndex        =   7
         Text            =   "frmWeb_Cs.frx":00EB
         Top             =   2220
         Width           =   6675
      End
      Begin MSComctlLib.ListView lsvCsDetail 
         Height          =   3075
         Left            =   660
         TabIndex        =   8
         Top             =   540
         Width           =   7755
         _ExtentX        =   13679
         _ExtentY        =   5424
         LabelEdit       =   1
         MultiSelect     =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         FullRowSelect   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin MSComctlLib.ListView lsvOption 
         Height          =   2775
         Left            =   -74820
         TabIndex        =   19
         Top             =   900
         Width           =   8295
         _ExtentX        =   14631
         _ExtentY        =   4895
         LabelEdit       =   1
         MultiSelect     =   -1  'True
         LabelWrap       =   -1  'True
         HideSelection   =   0   'False
         FullRowSelect   =   -1  'True
         _Version        =   393217
         ForeColor       =   -2147483640
         BackColor       =   -2147483643
         BorderStyle     =   1
         Appearance      =   1
         NumItems        =   0
      End
      Begin VB.Label Label2 
         Caption         =   "コース概略と検査項目説明は改行を入れるとそのままWEBページで表示されます。"
         Height          =   255
         Left            =   -73260
         TabIndex        =   23
         Top             =   3780
         Width           =   6615
      End
      Begin VB.Label Label8 
         Caption         =   "有効期間(&C):"
         Height          =   195
         Index           =   1
         Left            =   -74760
         TabIndex        =   21
         Top             =   540
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "コース概略(&A)"
         Height          =   180
         Index           =   0
         Left            =   -74760
         TabIndex        =   4
         Top             =   1560
         Width           =   1410
      End
      Begin VB.Label Label1 
         Caption         =   "コース名(&N)"
         Height          =   180
         Index           =   1
         Left            =   -74760
         TabIndex        =   2
         Top             =   1080
         Width           =   1410
      End
      Begin VB.Label Label8 
         Caption         =   "コース(&C):"
         Height          =   195
         Index           =   0
         Left            =   -74760
         TabIndex        =   0
         Top             =   660
         Width           =   1095
      End
      Begin VB.Label Label1 
         Caption         =   "検査項目説明(&K)"
         Height          =   180
         Index           =   2
         Left            =   -74760
         TabIndex        =   6
         Top             =   2280
         Width           =   1410
      End
   End
End
Attribute VB_Name = "frmWeb_Cs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mstrCsCd                As String       'WEBコース設定コード
Private mblnInitialize          As Boolean      'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated             As Boolean      'TRUE:更新あり、FALSE:更新なし

Private mstrRootCsCd()          As String       'コンボボックスに対応するコースコードの格納
Private mintCtrPtCd()           As String       'コンボボックスに対応する契約パターンコードの格納

Private mintDetailMaxKey        As Integer      '細情報のリストビューキーをユニークにするために保持
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Private mblnNowEdit             As Boolean      'TRUE:編集処理中、FALSE:処理なし
Private mblnEditData            As Boolean      '基本系のデータ修正（TRUE:更新、FALSE:未更新）
Private mblnEditOptData         As Boolean      '基本系のデータ修正（TRUE:更新、FALSE:未更新）
Private mblnModeNew             As Boolean      'TRUE:新規作成、FALSE:更新

Private mintCtrMngBeforeIndex   As Integer      '履歴コンボ変更キャンセル用の前Index
Private mintCourseBeforeIndex   As Integer      'コースコンボの前Index

Const mstrListViewKey           As String = "K"

Friend Property Let CsCd(ByVal vntNewValue As Variant)

    mstrCsCd = vntNewValue
    
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

        '名称の入力チェック
        If Trim(txtCsName.Text) = "" Then
            MsgBox "コース名が入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtCsName.SetFocus
            Exit Do
        End If

        '概略の入力チェック
        If Trim(txtOutLine.Text) = "" Then
            MsgBox "コース概略が入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtOutLine.SetFocus
            Exit Do
        End If

        '検査項目説明の入力チェック
        If Trim(txtItemOutLine.Text) = "" Then
            MsgBox "検査項目説明が入力されていません。", vbExclamation, App.Title
            tabMain.Tab = 0
            txtItemOutLine.SetFocus
            Exit Do
        End If

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
End Function

' @(e)
'
' 機能　　 : コースデータセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : コースデータをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditCourseConbo() As Boolean

    Dim objCourse       As Object   'コースアクセス用
    Dim vntCsCd         As Variant
    Dim vntCsName       As Variant
    Dim vntWebColor     As Variant
    Dim vntStrDate      As Variant
    Dim vntEndDate      As Variant
    
    Dim lngCount        As Long             'レコード数
    Dim lngTrueCount    As Long             '真のレコード数（契約が存在するもの）
    Dim i               As Long             'インデックス
    Dim j               As Long             'インデックス
'    Dim k               As Long             'インデックス
    
    Dim blnDataExists   As Boolean          'TRUE:既にコースが存在、FALSE=コース未追加
    
    EditCourseConbo = False
    
    cboCourse.Clear
    Erase mstrRootCsCd
    lngTrueCount = 0
'    k = 0

    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsContract.Contract")
    lngCount = objCourse.SelectAllCourseCtrMng("WWWWW", _
                                               "WWWWW", _
                                               vntWebColor, _
                                               vntCsCd, _
                                               vntCsName, _
                                               vntStrDate, _
                                               vntEndDate)
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        If Trim(vntStrDate(i)) <> "" Then
            
            blnDataExists = False
            '既に追加されているかどうかチェックする
            For j = 0 To cboCourse.ListCount - 1
                If mstrRootCsCd(j) = Trim(vntCsCd(i)) Then
                    blnDataExists = True
                    Exit For
                End If
            Next j
            
            'コンボ未追加なら、データ追加
            If blnDataExists = False Then
                ReDim Preserve mstrRootCsCd(lngTrueCount)
                mstrRootCsCd(lngTrueCount) = vntCsCd(i)
                cboCourse.AddItem vntCsName(i)
                lngTrueCount = lngTrueCount + 1
            End If
        
        End If
    Next i
    
    If lngTrueCount <= 0 Then
        'データが存在しないなら、エラー
        MsgBox "WEB用団体(WWWWW-WWWWW)に有効な契約を設定しているコースが存在しません。" & vbLf & _
               "コースデータ、及び契約を登録しないとWEBコース設定を行うことはできません。", vbExclamation
        Exit Function
    
    Else
        'コースコードが指定されているなら、そのコースコードでコンボセット
        If mstrCsCd <> "" Then
            For i = 0 To UBound(mstrRootCsCd)
                If mstrRootCsCd(i) = mstrCsCd Then
                    cboCourse.ListIndex = i
                    Exit For
                End If
            Next i
        Else
            cboCourse.ListIndex = 0
            mstrCsCd = mstrRootCsCd(0)
        End If
    End If
    
    EditCourseConbo = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

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
Private Function EditWeb_Cs() As Boolean

    Dim objWeb_Cs       As Object           'WEBコース設定アクセス用
    Dim vntCsName       As Variant          'WEBコース設定名
    Dim vntOutLine      As Variant          'コース概略
    Dim vntItemOutLine  As Variant          '検査項目説明
    Dim Ret             As Boolean          '戻り値
    Dim i               As Integer
    
    Dim strItemOutLine  As String
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objWeb_Cs = CreateObject("HainsWeb_Cs.Web_Cs")
    
    Do
        '検索条件が指定されていない場合（新規）は何もしない
        If mstrCsCd = "" Then
            
            'コースコンボの先頭を選択状態にする
            cboCourse.ListIndex = 0
            
            Ret = True
            Exit Do
        End If
        
        'WEBコース設定テーブルレコード読み込み
        If objWeb_Cs.SelectWeb_Cs(mstrCsCd, vntCsName, vntOutLine, vntItemOutLine) = False Then
            
            mblnModeNew = True
            txtCsName.Text = ""
            txtOutLine.Text = ""
            txtItemOutLine.Text = ""
                    
            Ret = True
            Exit Do
        End If
    
        mblnModeNew = False
        
        '読み込み内容の編集
        For i = 0 To cboCourse.ListCount - 1
            If mstrRootCsCd(i) = mstrCsCd Then
                cboCourse.ListIndex = i
            End If
        Next i
        
        txtCsName.Text = vntCsName
        'WEB用にタグを改行コードに変換
        txtOutLine.Text = Replace(vntOutLine, "<BR>", vbCrLf)
        txtItemOutLine.Text = Replace(vntItemOutLine, "<BR>", vbCrLf)
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditWeb_Cs = Ret
    
    Exit Function

ErrorHandle:

    EditWeb_Cs = False
    MsgBox Err.Description, vbCritical
    
End Function
' @(e)
'
' 機能　　 : 管理検査項目表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 現在設定されているグループ内検査項目を表示する
'
' 備考　　 :
'
Private Function EditWeb_CsDetail() As Boolean
    
On Error GoTo ErrorHandle

    Dim objWeb_Cs       As Object               'グループアクセス用
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    Dim vntSeq          As Variant              'SEQ
    Dim vntInspect      As Variant              '名称
    Dim vntInsDetail    As Variant              '検査分類名称
    Dim lngCount        As Long                 'レコード数
    
    Dim i               As Long                 'インデックス

    EditWeb_CsDetail = False

    'リストアイテムクリア
    lsvCsDetail.ListItems.Clear
    lsvCsDetail.View = lvwList
    
    'オブジェクトのインスタンス作成
    Set objWeb_Cs = CreateObject("HainsWeb_Cs.Web_Cs")
    
    'グループ内検査項目検索
    lngCount = objWeb_Cs.SelectWeb_CsDetailList(mstrCsCd, vntSeq, vntInspect, vntInsDetail)

    'ヘッダの編集
    Set objHeader = lsvCsDetail.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "検査名", 2000, lvwColumnLeft
        .Add , , "検査説明", 4000, lvwColumnLeft
    End With
        
    lsvCsDetail.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvCsDetail.ListItems.Add(, mstrListViewKey & vntSeq(i), vntInspect(i))
        'WEB用に改行コードをタグに変換
        objItem.SubItems(1) = Replace(vntInsDetail(i), "<BR>", vbCrLf)
    Next i
    
    '項目が１行以上存在した場合、無条件に先頭が選択されるため解除する。
    If lsvCsDetail.ListItems.Count > 0 Then
        lsvCsDetail.ListItems(1).Selected = False
    End If
    
    mintDetailMaxKey = lngCount
    EditWeb_CsDetail = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

'
' 機能　　 : 契約期間コンボ（オプション検査用）セット
'
' 引数　　 :
'
' 戻り値　 : 取得件数
'
' 備考　　 :
'
Private Function SetCtrMng() As Long

On Error GoTo ErrorHandle

    Dim objCtrMng       As Object           '結果コメントアクセス用
    
    Dim vntCtrPtCd      As Variant          '契約パターンコード
    Dim vntStrDate      As Variant          '契約開始日
    Dim vntEndDate      As Variant          '契約終了日

    Dim lngCount        As Long             'レコード数
    Dim i               As Long             'インデックス
    
    SetCtrMng = 0
    
    'オブジェクトのインスタンス作成
    Set objCtrMng = CreateObject("HainsContract.Contract")
    

    lngCount = objCtrMng.SelectCtrMngWithPeriod("WWWWW", _
                                                "WWWWW", _
                                                mstrRootCsCd(cboCourse.ListIndex), _
                                                vntCtrPtCd, _
                                                vntStrDate, _
                                                vntEndDate)
    
    cboCtrMng.Clear
    
    'リストの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mintCtrPtCd(i)
        mintCtrPtCd(i) = CInt(vntCtrPtCd(i))
        cboCtrMng.AddItem vntStrDate(i) & "～" & vntEndDate(i) & "まで有効な契約情報"
    Next i
    
    'オブジェクト廃棄
    Set objCtrMng = Nothing
    
    If lngCount > 0 Then
        cboCtrMng.ListIndex = 0
    End If
    
    SetCtrMng = lngCount
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' 機能　　 : オプション検査表示
'
' 機能説明 : 現在設定されているオプション検査を表示する
'
' 備考　　 :
'
Private Function EditOptList() As Boolean
    
On Error GoTo ErrorHandle

    Dim objOptList      As Object               'オプション検査アクセス用
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    Dim vntOptCd        As Variant              'オプションコード
    Dim vntCtrOptName   As Variant              'オプション検査名（契約上）
    Dim vntOptName      As Variant              'オプション検査名（WEB予約設定値）
    Dim vntOptPurpose   As Variant              'オプション検査目的
    Dim vntOptDetail    As Variant              'オプション検査詳細
    Dim lngCount        As Long                 'レコード数
    
    Dim i               As Long                 'インデックス

    EditOptList = False

    'リストアイテムクリア
    lsvOption.ListItems.Clear
    lsvOption.View = lvwList
    
    'オブジェクトのインスタンス作成
    Set objOptList = CreateObject("HainsWeb_Cs.Web_Cs")
    
    'オプション検査情報取得
    lngCount = objOptList.SelectWeb_OptList(mintCtrPtCd(cboCtrMng.ListIndex), _
                                            vntOptCd, _
                                            vntCtrOptName, _
                                            vntOptName, _
                                            vntOptPurpose, _
                                            vntOptDetail)
    
    'ヘッダの編集
    Set objHeader = lsvOption.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "オプション名", 1800, lvwColumnLeft
        .Add , , "設定名称", 1800, lvwColumnLeft
        .Add , , "検査目的", 2000, lvwColumnLeft
        .Add , , "検査詳細", 3000, lvwColumnLeft
        .Add , , "オプションコード", 2000, lvwColumnLeft
    End With
        
    lsvOption.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvOption.ListItems.Add(, mstrListViewKey & vntOptCd(i), vntCtrOptName(i))
        objItem.SubItems(1) = vntOptName(i)
        objItem.SubItems(2) = vntOptPurpose(i)
        objItem.SubItems(3) = Replace(vntOptDetail(i), "<BR>", vbCrLf)
        objItem.SubItems(4) = vntOptCd(i)
    Next i
    
    EditOptList = True
    Exit Function
    
ErrorHandle:

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
Private Function RegistWeb_Cs() As Boolean

On Error GoTo ErrorHandle

    Dim objWeb_Cs       As Object       'WEBコース設定アクセス用
    Dim Ret             As Long
    Dim i               As Integer
    Dim j               As Integer
    Dim intItemCount    As Integer
    Dim intOptCount    As Integer
    
    Dim vntSeq()        As Variant
    Dim vntInspect()    As Variant
    Dim vntInsDetail()  As Variant
    
    Dim vntOptCd()      As Variant
    Dim vntOptName()    As Variant
    Dim vntOptPurpose() As Variant
    Dim vntOptDetail()  As Variant
    
    intItemCount = 0
    intOptCount = 0
    Erase vntSeq
    Erase vntInspect
    Erase vntInsDetail
    j = 0

    'WEBコース詳細テーブルの格納内容を配列にセット
    For i = 1 To lsvCsDetail.ListItems.Count
        
        ReDim Preserve vntSeq(j)
        ReDim Preserve vntInspect(j)
        ReDim Preserve vntInsDetail(j)
        
        vntSeq(j) = i
        vntInspect(j) = Trim(lsvCsDetail.ListItems(i).Text)
        vntInsDetail(j) = Replace(Trim(lsvCsDetail.ListItems(i).SubItems(1)), vbCrLf, "<BR>")
        
        j = j + 1
        intItemCount = intItemCount + 1
    
    Next i
    
    j = 0
    'WEBオプション検査テーブルの格納内容を配列にセット
    For i = 1 To lsvOption.ListItems.Count
        
        If lsvOption.ListItems(i).SubItems(1) <> "" Then
                
            ReDim Preserve vntOptCd(j)
            ReDim Preserve vntOptName(j)
            ReDim Preserve vntOptPurpose(j)
            ReDim Preserve vntOptDetail(j)
            
            With lsvOption.ListItems(i)
                vntOptCd(j) = Trim(.SubItems(4))
                vntOptName(j) = Trim(.SubItems(1))
                vntOptPurpose(j) = Trim(.SubItems(2))
                vntOptDetail(j) = Replace(Trim(.SubItems(3)), vbCrLf, "<BR>")
            End With
            
            j = j + 1
            intOptCount = intOptCount + 1
    
        End If
    
    Next i
    
    'オブジェクトのインスタンス作成
    Set objWeb_Cs = CreateObject("HainsWeb_Cs.Web_Cs")
    
    'WEBコース設定テーブルレコードの登録
    Ret = objWeb_Cs.RegistWeb_Cs_All(IIf(mblnModeNew, "INS", "UPD"), _
                                     mstrRootCsCd(cboCourse.ListIndex), _
                                     Trim(txtCsName.Text), _
                                     Replace(Trim(txtOutLine.Text), vbCrLf, "<BR>"), _
                                     Replace(Trim(txtItemOutLine.Text), vbCrLf, "<BR>"), _
                                     lsvCsDetail.ListItems.Count, _
                                     vntSeq, _
                                     vntInspect, _
                                     vntInsDetail, _
                                     mintCtrPtCd(cboCtrMng.ListIndex), _
                                     intOptCount, _
                                     vntOptCd, _
                                     vntOptName, _
                                     vntOptPurpose, _
                                     vntOptDetail)
    
    If Ret = 0 Then
        MsgBox "入力されたWEBコース設定コードは既に存在します。", vbExclamation
        RegistWeb_Cs = False
        Exit Function
    End If
    
    RegistWeb_Cs = True
        
    Exit Function
    
ErrorHandle:

    RegistWeb_Cs = False
    MsgBox Err.Description, vbCritical
    
End Function

Private Sub cboCourse_Click()
    
    Dim lngHistoryCount     As Long
    Dim strMsg              As String
    Dim intRet              As Integer
    
    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    '現在の状態が更新されていたら、警告
    If (mblnEditData = True) Or (mblnEditOptData = True) Then
        strMsg = "データが更新されています。選択コースを変更すると入力内容が破棄されます" & vbLf & _
                 "よろしいですか？"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then
            mblnNowEdit = True                              '無限Loop防止のため、処理制御
            cboCourse.ListIndex = mintCourseBeforeIndex     'コンボインデックスを元に戻す
            mblnNowEdit = False                             '処理中解除
            Exit Sub
        End If
    End If

    '処理中にする
    mblnNowEdit = True

    '現在のIndexを保持
    mintCourseBeforeIndex = cboCourse.ListIndex
    mstrCsCd = mstrRootCsCd(mintCourseBeforeIndex)

    'WEBコース設定情報の編集
    Call EditWeb_Cs

    'WEBコース詳細情報の編集
    Call EditWeb_CsDetail
    
    'コース有効契約期間コンボの編集
    lngHistoryCount = SetCtrMng()
    
    'オプション検査情報の編集
    Call EditOptList

    '未更新状態に初期化
    mblnEditData = False
    mblnEditOptData = False
    mblnNowEdit = False
    
End Sub

Private Sub cboCtrMng_Click()

    Dim strMsg      As String
    Dim intRet      As Integer
    
    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    '履歴コンボが一つしかない場合は、処理終了
    If cboCtrMng.ListCount = 1 Then Exit Sub
    
    '現在の状態が更新されていたら、警告
    If mblnEditOptData = True Then
        
        strMsg = "データが更新されています。有効期間データを再表示すると変更内容が破棄されます" & vbLf & _
                 "よろしいですか？"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then
            mblnNowEdit = True                         '無限Loop防止のため、処理制御
            cboCtrMng.ListIndex = mintCtrMngBeforeIndex      'コンボインデックスを元に戻す
            mblnNowEdit = False                        '処理中解除
            Exit Sub
        End If
    End If
    
    'オプション検査情報の編集
    Call EditOptList

    '現在のIndexを保持
    mintCtrMngBeforeIndex = cboCtrMng.ListIndex

    '未更新状態に初期化
    mblnEditOptData = False
    mblnNowEdit = False

End Sub

Private Sub cmdAddCsDetail_Click()

    Dim objItem         As ListItem             'リストアイテムオブジェクト

    If lsvCsDetail.ListItems.Count > 98 Then
        MsgBox "検査項目の説明用設定は９９個以上設定することはできません。", vbInformation
    End If

    With frmWeb_CsDetail
        'プロパティセット
        .Inspect = ""
        .InsDetail = ""
                
        '編集画面表示
        .Show vbModal
    
        '更新されている場合、内容変更
        If .Updated = True Then
            
            mintDetailMaxKey = mintDetailMaxKey + 1
            Set objItem = lsvCsDetail.ListItems.Add(, mstrListViewKey & mintDetailMaxKey, .Inspect)
            objItem.SubItems(1) = .InsDetail
            
            '更新状態を管理
            mblnEditData = True
        
        End If
                
    End With

End Sub


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
    If ApplyData() = True Then
        MsgBox "入力内容を保存しました。", vbInformation
    End If

End Sub

' @(e)
'
' 機能　　 : 「キャンセル」Click
'
' 機能説明 : フォームを閉じる
'
' 備考　　 :
'
Private Sub cmdCancel_Click()

    Unload Me
    
End Sub

Private Sub cmdClearOption_Click()

    Dim i As Integer
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvOption.ListItems.Count
        
        '選択されている項目なら削除
        If lsvOption.ListItems(i).Selected = True Then
            lsvOption.ListItems(i).SubItems(1) = ""
            lsvOption.ListItems(i).SubItems(2) = ""
            lsvOption.ListItems(i).SubItems(3) = ""
        End If
    
    Next i

    '更新状態を管理
    mblnEditData = True
    mblnEditOptData = True

End Sub

' @(e)
'
' 機能　　 : 「項目削除」Click
'
' 機能説明 : 選択された項目をリストから削除する
'
' 備考　　 :
'
Private Sub cmdDeleteCsDetail_Click()

    Dim i As Integer
    
    If lsvCsDetail.ListItems.Count = 0 Then Exit Sub
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvCsDetail.ListItems.Count
        
        'インデックスがリスト項目を越えたら終了
        If i > lsvCsDetail.ListItems.Count Then Exit For
        
        '選択されている項目なら削除
        If lsvCsDetail.ListItems(i).Selected = True Then
            lsvCsDetail.ListItems.Remove (lsvCsDetail.ListItems(i).Key)
            'アイテム数が変わるので-1して再検査
            i = i - 1
        End If
    
    Next i

    mblnEditData = True

End Sub


Private Sub cmdDownItem_Click()

    Call MoveListItem(1)

End Sub

Private Sub cmdEditCsDetail_Click()

    Dim i       As Integer
    Dim objItem As ListItem
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvCsDetail.ListItems.Count
        
        '選択されている項目なら表示
        If lsvCsDetail.ListItems(i).Selected = True Then
            
            Set objItem = lsvCsDetail.ListItems(i)
            
            With frmWeb_CsDetail
                'プロパティセット
                .Inspect = objItem.Text
                .InsDetail = objItem.SubItems(1)
                
                '編集画面表示
                .Show vbModal
            
                '更新されている場合、内容変更
                If .Updated = True Then
                    objItem.Text = .Inspect
                    objItem.SubItems(1) = .InsDetail
                End If
                
                '更新状態を管理
                mblnEditData = True
            
            End With
            
            '1個編集したら十分
            Exit For
        End If
    
    Next i

End Sub

Private Sub cmdEditOpt_Click()

    Dim i       As Integer
    Dim objItem As ListItem
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvOption.ListItems.Count
        
        '選択されている項目なら表示
        If lsvOption.ListItems(i).Selected = True Then
            
            Set objItem = lsvOption.ListItems(i)
            
            With frmWeb_CsOpt
                'プロパティセット
                .CtrOptName = objItem.Text
                .OptName = objItem.SubItems(1)
                .OptPurpose = objItem.SubItems(2)
                .OptDetail = objItem.SubItems(3)
                
                '編集画面表示
                .Show vbModal
            
                '更新されている場合、内容変更
                If .Updated = True Then
                    objItem.SubItems(1) = .OptName
                    objItem.SubItems(2) = .OptPurpose
                    objItem.SubItems(3) = .OptDetail
                
                    '更新状態を管理
                    mblnEditData = True
                    mblnEditOptData = True
                
                End If
            
            End With
            
            '1個編集したら十分
            Exit For
        End If
    
    Next i

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
Private Sub cmdOk_Click()

    'データ適用処理を行う
    If ApplyData() = False Then Exit Sub

    '画面を閉じる
    Unload Me
    
End Sub

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
        
        'WEBコーステーブルの登録
        If RegistWeb_Cs() = False Then Exit Do

        '更新済みフラグをTRUEに
        mblnUpdated = True
        
        'データ更新制御フラグを初期化
        mblnEditData = False
        mblnEditOptData = False
        mblnModeNew = False
        
        ApplyData = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault

End Function

Private Sub cmdUpItem_Click()

    Call MoveListItem(-1)

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
    mblnEditData = False
    mblnEditOptData = False
    mblnModeNew = False
    tabMain.Tab = 0     '先頭タブをActive
    mintDetailMaxKey = 0

    '画面初期化
    Call InitFormControls(Me, mcolGotFocusCollection)

    Do
        'コースコンボの編集
        If EditCourseConbo() = False Then
            Exit Do
        End If
        
        'WEBコース設定情報の編集
        If EditWeb_Cs() = False Then
            Exit Do
        End If
    
        'WEBコース詳細情報の編集
        If EditWeb_CsDetail() = False Then
            Exit Do
        End If
        
        'コース有効契約期間コンボの編集
        If SetCtrMng() > 0 Then
        
            'オプション検査情報の編集
            If EditOptList() = False Then
                Exit Do
            End If
        
        End If
                
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Private Sub lsvCsDetail_DblClick()

    Call cmdEditCsDetail_Click
    
End Sub


' @(e)
'
' 機能　　 : 選択項目の移動
'
' 引数　　 : (In)   intMovePosition 移動方向（-1:一つ上へ、1:一つしたへ）
'
' 機能説明 : リストビュー上の項目を移動させる
'
' 備考　　 :
'
Private Sub MoveListItem(intMovePosition As Integer)

    Dim i                   As Integer
    Dim j                   As Integer
    Dim objItem             As ListItem
    
    Dim intSelectedCount    As Integer
    Dim intSelectedIndex    As Integer
    Dim intTargetIndex      As Integer
    Dim intScrollPoint      As Integer
    
    Dim strEscKey()         As String
    Dim strEscInspect()     As String
    Dim strEscInsDetail()   As String
    
    intSelectedCount = 0

    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvCsDetail.ListItems.Count

        '選択されている項目なら
        If lsvCsDetail.ListItems(i).Selected = True Then
            intSelectedCount = intSelectedCount + 1
            intSelectedIndex = i
        End If

    Next i
    
    '選択項目数が１個以外なら処理しない
    If intSelectedCount <> 1 Then Exit Sub
    
    '項目Up指定かつ、選択項目が先頭なら何もしない
    If (intSelectedIndex = 1) And (intMovePosition = -1) Then Exit Sub
    
    '項目Down指定かつ、選択項目が最終なら何もしない
    If (intSelectedIndex = lsvCsDetail.ListItems.Count) And (intMovePosition = 1) Then Exit Sub
    
    '更新状態を管理
    mblnEditData = True
    
    If intMovePosition = -1 Then
        '項目Upの場合、一つ前の要素をターゲットとする。
        intTargetIndex = intSelectedIndex - 1
    Else
        '項目Downの場合、現在の要素をターゲットとする。
        intTargetIndex = intSelectedIndex
    End If
    
    '現在表示上の先頭Indexを取得
    intScrollPoint = lsvCsDetail.GetFirstVisible.Index
    
    'リストビューをくるくる回して全項目配列作成
    For i = 1 To lsvCsDetail.ListItems.Count
        ReDim Preserve strEscKey(i)
        ReDim Preserve strEscInspect(i)
        ReDim Preserve strEscInsDetail(i)
        
        '処理対象配列番号時処理
        If intTargetIndex = i Then
        
            '項目退避
            strEscKey(i) = lsvCsDetail.ListItems(i + 1).Key
            strEscInspect(i) = lsvCsDetail.ListItems(i + 1).Text
            strEscInsDetail(i) = lsvCsDetail.ListItems(i + 1).SubItems(1)
        
            i = i + 1
        
            ReDim Preserve strEscKey(i)
            ReDim Preserve strEscInspect(i)
            ReDim Preserve strEscInsDetail(i)
        
            strEscKey(i) = lsvCsDetail.ListItems(intTargetIndex).Key
            strEscInspect(i) = lsvCsDetail.ListItems(intTargetIndex).Text
            strEscInsDetail(i) = lsvCsDetail.ListItems(intTargetIndex).SubItems(1)
        
        Else
            strEscKey(i) = lsvCsDetail.ListItems(i).Key
            strEscInspect(i) = lsvCsDetail.ListItems(i).Text
            strEscInsDetail(i) = lsvCsDetail.ListItems(i).SubItems(1)
        
        End If
    
    Next i
    
    lsvCsDetail.ListItems.Clear
    
    'ヘッダの編集
    With lsvCsDetail.ColumnHeaders
        .Clear
        .Add , , "検査名", 2000, lvwColumnLeft
        .Add , , "検査説明", 4000, lvwColumnLeft
    End With
    
    'リストの編集
    For i = 1 To UBound(strEscKey)
        Set objItem = lsvCsDetail.ListItems.Add(, strEscKey(i), strEscInspect(i))
        objItem.SubItems(1) = strEscInsDetail(i)
    Next i

    lsvCsDetail.ListItems(1).Selected = False
    
    '移動した項目を選択させ、移動（スクロール）させる
    If intMovePosition = 1 Then
        lsvCsDetail.ListItems(intTargetIndex + 1).Selected = True
'        lsvCsDetail.ListItems(intTargetIndex).EnsureVisible
    Else
        lsvCsDetail.ListItems(intTargetIndex).Selected = True
'        lsvCsDetail.ListItems(intScrollPoint + 7).EnsureVisible
    End If

    lsvCsDetail.SetFocus

End Sub

Private Sub lsvOption_DblClick()

    Call cmdEditOpt_Click
    
End Sub

Private Sub txtCsName_Change()
    
    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    mblnEditData = True
    
End Sub

Private Sub txtItemOutLine_Change()
    
    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    mblnEditData = True

End Sub

Private Sub txtOutLine_Change()
    
    '編集途中、もしくは処理中の場合は処理しない
    If (mblnNowEdit = True) Or (Screen.MousePointer = vbHourglass) Then
        Exit Sub
    End If
    
    mblnEditData = True

End Sub
