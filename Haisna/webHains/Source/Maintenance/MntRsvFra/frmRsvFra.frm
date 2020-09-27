VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmRsvFra 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "予約枠テーブルメンテナンス"
   ClientHeight    =   7620
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6720
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmRsvFra.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7620
   ScaleWidth      =   6720
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin TabDlg.SSTab tabMain 
      Height          =   6975
      Left            =   120
      TabIndex        =   41
      Top             =   120
      Width           =   6495
      _ExtentX        =   11456
      _ExtentY        =   12303
      _Version        =   393216
      Style           =   1
      Tabs            =   2
      TabHeight       =   520
      TabCaption(0)   =   "基本情報"
      TabPicture(0)   =   "frmRsvFra.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Image1(0)"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "LabelCourseGuide"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Frame1"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "Frame3(0)"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "Frame3(1)"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).ControlCount=   5
      TabCaption(1)   =   "枠管理する項目"
      TabPicture(1)   =   "frmRsvFra.frx":0028
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "fraItemMain"
      Tab(1).ControlCount=   1
      Begin VB.Frame Frame3 
         Caption         =   "枠設定時のデフォルト人数"
         Height          =   2355
         Index           =   1
         Left            =   300
         TabIndex        =   13
         Top             =   4320
         Visible         =   0   'False
         Width           =   6015
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   9
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   33
            Text            =   "Text1"
            Top             =   1800
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   8
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   29
            Text            =   "Text1"
            Top             =   1440
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   7
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   25
            Text            =   "Text1"
            Top             =   1080
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   6
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   21
            Text            =   "Text1"
            Top             =   720
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   5
            Left            =   3540
            MaxLength       =   3
            TabIndex        =   17
            Text            =   "@@@"
            Top             =   360
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   4
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   31
            Text            =   "Text1"
            Top             =   1800
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   3
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   27
            Text            =   "Text1"
            Top             =   1440
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   2
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   23
            Text            =   "Text1"
            Top             =   1080
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   1
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   19
            Text            =   "Text1"
            Top             =   720
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Index           =   0
            Left            =   1500
            MaxLength       =   3
            TabIndex        =   15
            Text            =   "@@@"
            Top             =   360
            Width           =   555
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   9
            Left            =   2340
            TabIndex        =   32
            Top             =   1860
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   8
            Left            =   2340
            TabIndex        =   28
            Top             =   1500
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   7
            Left            =   2340
            TabIndex        =   24
            Top             =   1140
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   6
            Left            =   2340
            TabIndex        =   20
            Top             =   780
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   5
            Left            =   2340
            TabIndex        =   16
            Top             =   420
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   4
            Left            =   300
            TabIndex        =   30
            Top             =   1860
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   3
            Left            =   300
            TabIndex        =   26
            Top             =   1500
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   2
            Left            =   300
            TabIndex        =   22
            Top             =   1140
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   1
            Left            =   300
            TabIndex        =   18
            Top             =   780
            Width           =   1395
         End
         Begin VB.Label lblDefCnt 
            Caption         =   "時間帯枠１(&1):"
            Height          =   195
            Index           =   0
            Left            =   300
            TabIndex        =   14
            Top             =   420
            Width           =   1395
         End
      End
      Begin VB.Frame Frame3 
         Caption         =   "枠人数のオーバー登録"
         Height          =   1095
         Index           =   0
         Left            =   300
         TabIndex        =   10
         Top             =   3120
         Visible         =   0   'False
         Width           =   6015
         Begin VB.OptionButton optOverRsv 
            Caption         =   "枠人数を越えた予約を許す(&T)"
            Height          =   255
            Index           =   1
            Left            =   300
            TabIndex        =   12
            Top             =   660
            Width           =   4095
         End
         Begin VB.OptionButton optOverRsv 
            Caption         =   "枠人数を越えた予約は許さない(&F)"
            Height          =   255
            Index           =   0
            Left            =   300
            TabIndex        =   11
            Top             =   360
            Value           =   -1  'True
            Width           =   4095
         End
      End
      Begin VB.Frame fraItemMain 
         Caption         =   "検査項目(&I)"
         Height          =   4395
         Left            =   -74820
         TabIndex        =   34
         Top             =   480
         Width           =   6075
         Begin VB.CommandButton cmdDeleteItem 
            Caption         =   "削除(&R)"
            Height          =   315
            Left            =   4620
            TabIndex        =   37
            Top             =   3900
            Width           =   1275
         End
         Begin VB.CommandButton cmdAddItem 
            Caption         =   "追加(&A)..."
            Height          =   315
            Left            =   3240
            TabIndex        =   36
            Top             =   3900
            Width           =   1275
         End
         Begin MSComctlLib.ListView lsvItem 
            Height          =   3480
            Left            =   180
            TabIndex        =   35
            Top             =   300
            Width           =   5715
            _ExtentX        =   10081
            _ExtentY        =   6138
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
      End
      Begin VB.Frame Frame1 
         Caption         =   "基本情報(&B)"
         Height          =   1935
         Left            =   300
         TabIndex        =   0
         Top             =   1080
         Width           =   6015
         Begin VB.CheckBox chkIncOpenGrp 
            Caption         =   "オープン枠予約群存在時は検索に含める(&E)"
            Height          =   180
            Left            =   1680
            TabIndex        =   9
            Top             =   1500
            Width           =   3495
         End
         Begin VB.OptionButton optFraType 
            Caption         =   "検査項目予約枠(&R)"
            Height          =   255
            Index           =   1
            Left            =   3420
            TabIndex        =   7
            Top             =   1080
            Value           =   -1  'True
            Visible         =   0   'False
            Width           =   2055
         End
         Begin VB.OptionButton optFraType 
            Caption         =   "コース予約枠(&R)"
            Height          =   255
            Index           =   0
            Left            =   1680
            TabIndex        =   6
            Top             =   1080
            Width           =   1575
         End
         Begin VB.TextBox txtRsvFraName 
            Height          =   318
            IMEMode         =   4  '全角ひらがな
            Left            =   1680
            MaxLength       =   10
            TabIndex        =   4
            Text            =   "胸部レントゲン"
            Top             =   660
            Width           =   2055
         End
         Begin VB.TextBox txtRsvFraCd 
            Height          =   315
            IMEMode         =   3  'ｵﾌ固定
            Left            =   1680
            MaxLength       =   3
            TabIndex        =   2
            Text            =   "@@@"
            Top             =   300
            Width           =   495
         End
         Begin VB.Label Label8 
            Caption         =   "オープン枠(&O):"
            Height          =   195
            Index           =   1
            Left            =   240
            TabIndex        =   8
            Top             =   1500
            Width           =   1395
         End
         Begin VB.Label Label2 
            Caption         =   "予約枠名(&N):"
            Height          =   195
            Left            =   240
            TabIndex        =   3
            Top             =   720
            Width           =   1095
         End
         Begin VB.Label Label1 
            Caption         =   "予約枠コード(&C):"
            Height          =   195
            Index           =   2
            Left            =   240
            TabIndex        =   1
            Top             =   360
            Width           =   1275
         End
         Begin VB.Label Label8 
            Caption         =   "予約枠の種類(&K):"
            Height          =   195
            Index           =   0
            Left            =   240
            TabIndex        =   5
            Top             =   1125
            Width           =   1395
         End
      End
      Begin VB.Label LabelCourseGuide 
         Caption         =   "予約内容の種類によって人数制限する内容を設定します。"
         Height          =   255
         Left            =   960
         TabIndex        =   42
         Top             =   600
         Width           =   5055
      End
      Begin VB.Image Image1 
         Height          =   480
         Index           =   0
         Left            =   300
         Picture         =   "frmRsvFra.frx":0044
         Top             =   480
         Width           =   480
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   3960
      TabIndex        =   39
      Top             =   7200
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2580
      TabIndex        =   38
      Top             =   7200
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
      Height          =   315
      Left            =   5340
      TabIndex        =   40
      Top             =   7200
      Width           =   1275
   End
End
Attribute VB_Name = "frmRsvFra"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.2.25
'担当者  ：T.Takagi@RD
'修正内容：オープン枠予約群を追加

Option Explicit

'プロパティ用領域
Private mstrRsvFraCd    As String   '予約枠コード
Private mintFraType     As Integer  '枠管理タイプ
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly    As Boolean  'TRUE:データの更新をしない（参照のみ）
Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗

'モジュール固有領域領域
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Private mstrClassCd()   As String   '検査分類コード（配列は、コンボボックスと対応）

Const mstrListViewKey   As String = "K"

Friend Property Get Initialize() As Variant

    Initialize = mblnInitialize

End Property

Friend Property Get Updated() As Variant

    Updated = mblnUpdated

End Property


' @(e)
'
' 機能　　 : 「項目追加」Click
'
' 機能説明 : ①コースの場合～管理するコースを追加する
' 　　　　 : ②検査項目の場合～管理する項目を追加する
'
' 備考　　 :
'
Private Sub cmdAddItem_Click()
    
    Dim objItemGuide    As mntItemGuide.ItemGuide   '項目ガイド表示用
    Dim objItem         As ListItem                 'リストアイテムオブジェクト
    
    Dim i               As Long     'インデックス
    Dim strKey          As String   '重複チェック用のキー
    Dim strItemString   As String
    Dim strItemKey      As String   'リストビュー用アイテムキー
    Dim strItemCdString As String   '表示用キー編集領域
    
    Dim lngItemCount    As Long     '選択項目数
    Dim vntItemCd       As Variant  '選択された項目コード
    Dim vntItemName     As Variant  '選択された項目名
    
    If mintFraType = 0 Then
        
        '枠管理タイプがコースなら、リストビュー上の管理、非管理を変更する
        Call ChangeItemMode(True)
    
    Else
        '枠管理タイプが検査項目なら、ガイドを表示する
        
        'オブジェクトのインスタンス作成
        Set objItemGuide = New mntItemGuide.ItemGuide
        
        With objItemGuide
            .Mode = MODE_REQUEST
            .Group = GROUP_OFF
            .Item = ITEM_SHOW
            .Question = QUESTION_SHOW
        
            '検査項目ガイドを開く
            .Show vbModal
            
            '戻り値としてのプロパティ取得
            lngItemCount = .ItemCount
            vntItemCd = .ItemCd
            vntItemName = .ItemName
        
        End With
    
        Screen.MousePointer = vbHourglass
        Me.Refresh
            
        '選択件数が0件以上なら
        If lngItemCount > 0 Then
        
            'リストの編集
            For i = 0 To lngItemCount - 1
                
                '依頼項目の場合
                strItemCdString = vntItemCd(i)
                strItemKey = mstrListViewKey & strItemCdString
                
                'リスト上に存在するかチェックする
                If CheckExistsItemCd(lsvItem, strItemKey) = False Then
                
                    'なければ追加する
                    Set objItem = lsvItem.ListItems.Add(, strItemKey, strItemCdString)
                    objItem.SubItems(1) = vntItemName(i)
                
                End If
            Next i
        
        End If
    
        Set objItemGuide = Nothing
    
    End If
    Screen.MousePointer = vbDefault

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

    Dim Ctrl        As Object
    Dim i           As Integer
    Dim objHeader   As ColumnHeaders        'カラムヘッダオブジェクト
    
        
'★なんで！配列があるテキストボックスで対応できない！
'    Call InitFormControls(Me, mcolGotFocusCollection)      '使用コントロール初期化
        
    ''各コントロールの設定値をクリアする
    For Each Ctrl In Me
        
        '''テキストボックス
        If TypeOf Ctrl Is TextBox Then
            Ctrl.Text = Empty
            Ctrl.ToolTipText = Empty
            Ctrl.BackColor = vbWindowBackground
        
        End If
    
    Next Ctrl
    
    '読み込み内容の編集
    For i = 0 To 9
        lblDefCnt(i).Visible = False
        txtDefCnt(i).Visible = False
    Next i
    
    tabMain.Tab = 0
    optFraType(0).Value = True
    
End Sub

' @(e)
'
' 機能　　 : 基本予約枠情報画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 予約枠の基本情報を画面に表示する
'
' 備考　　 :
'
Private Function EditTimeFra() As Boolean

    Dim objCommon           As Object     '予約枠情報アクセス用
    
    Dim vntArrTimeFra       As Variant
    Dim vntArrTimeFraName   As Variant

    Dim lngRet          As Long
    Dim i               As Integer
    
    EditTimeFra = False
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
    Do
        
        '時間枠情報読み込み
        lngRet = objCommon.SelectTimeFraList(vntArrTimeFra, vntArrTimeFraName)

        '読み込み内容の編集
        For i = 0 To lngRet - 1
            lblDefCnt(i).Caption = CStr(vntArrTimeFraName(i))
            lblDefCnt(i).Visible = True
            txtDefCnt(i).Visible = True
        Next i
        
        Exit Do
    Loop
    
    '戻り値の設定
    EditTimeFra = True
    
    Exit Function

ErrorHandle:

    EditTimeFra = False
    MsgBox Err.Description, vbCritical
    
End Function


' @(e)
'
' 機能　　 : 基本予約枠情報画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 予約枠の基本情報を画面に表示する
'
' 備考　　 :
'
Private Function EditRsvFra_p() As Boolean

    Dim objRsvFra       As Object     '予約枠情報アクセス用
    
    Dim vntRsvFraName   As Variant
    Dim vntOverRsv      As Variant
    Dim vntFraType      As Variant
    Dim vntDefCnt(9)    As Variant
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
    Dim vntIncOpenGrp   As Variant  'オープン枠予約群検索
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####

    Dim Ret             As Boolean              '戻り値
    Dim i               As Integer
    
    EditRsvFra_p = False
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objRsvFra = CreateObject("HainsSchedule.Schedule")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrRsvFraCd = "" Then
            Ret = True
            Exit Do
        End If
        
        'コーステーブルレコード読み込み
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'        If objRsvFra.SelectRsvFra(mstrRsvFraCd, _
'                                  vntRsvFraName, _
'                                  vntOverRsv, _
'                                  vntFraType, _
'                                  vntDefCnt(0), _
'                                  vntDefCnt(1), _
'                                  vntDefCnt(2), _
'                                  vntDefCnt(3), _
'                                  vntDefCnt(4), _
'                                  vntDefCnt(5), _
'                                  vntDefCnt(6), _
'                                  vntDefCnt(7), _
'                                  vntDefCnt(8), _
'                                  vntDefCnt(9)) = False Then
        If objRsvFra.SelectRsvFra(mstrRsvFraCd, _
                                  vntRsvFraName, _
                                  vntOverRsv, _
                                  vntFraType, _
                                  vntDefCnt(0), _
                                  vntDefCnt(1), _
                                  vntDefCnt(2), _
                                  vntDefCnt(3), _
                                  vntDefCnt(4), _
                                  vntDefCnt(5), _
                                  vntDefCnt(6), _
                                  vntDefCnt(7), _
                                  vntDefCnt(8), _
                                  vntDefCnt(9), _
                                  vntIncOpenGrp) = False Then
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If

        '読み込み内容の編集（コース基本情報）
        txtRsvFraCd.Text = mstrRsvFraCd
        txtRsvFraName.Text = vntRsvFraName
        mintFraType = CInt(vntFraType)
        optFraType(CInt(vntFraType)).Value = True
        optOverRsv(CInt(vntOverRsv)).Value = True
    
        For i = 0 To 9
            txtDefCnt(i).Text = CStr(vntDefCnt(i))
        Next i
        
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
        chkIncOpenGrp.Value = IIf(vntIncOpenGrp > 0, vbChecked, vbUnchecked)
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditRsvFra_p = Ret
    
    Exit Function

ErrorHandle:

    EditRsvFra_p = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : 予約枠管理項目表示
'
' 機能説明 : 現在設定されている予約枠内管理項目（コースor検査項目）を表示する
'
' 備考　　 :
'
Private Function EditRsvFraItem() As Boolean
    
On Error GoTo ErrorHandle

    Dim objRsvFra       As Object               '予約枠アクセス用
    Dim objHeader       As ColumnHeaders        'カラムヘッダオブジェクト
    Dim objItem         As ListItem             'リストアイテムオブジェクト

    Dim vntClassName    As Variant              '検査分類名称
    Dim vntItemCode     As Variant              'コード
    Dim vntItemName     As Variant              '名称
    Dim vntCsCd         As Variant              'コースコード
    Dim lngCount        As Long                 'レコード数
    Dim strItemKey      As String               'リストビュー用アイテムキー
    Dim strItemCodeString As String             '表示用キー編集領域
    
    Dim i               As Long                 'インデックス

    EditRsvFraItem = False

    'リストアイテムクリア
    lsvItem.ListItems.Clear
    lsvItem.View = lvwList
    
    'オブジェクトのインスタンス作成
    Set objRsvFra = CreateObject("HainsSchedule.Schedule")
    
    lngCount = objRsvFra.SelectRsvFraItemList(mstrRsvFraCd, _
                                              mintFraType, _
                                              vntItemCode, _
                                              vntItemName, _
                                              vntCsCd)

    'ヘッダの編集
    Set objHeader = lsvItem.ColumnHeaders
    With objHeader
        .Clear
        .Add , , "コード", 1000, lvwColumnLeft
        If mintFraType = 0 Then
            .Add , , "コース名称", 2000, lvwColumnLeft
            .Add , , "管理対象", 2000, lvwColumnLeft
        Else
            .Add , , "検査項目名称", 2000, lvwColumnLeft
        End If
    End With
        
    lsvItem.View = lvwReport
    
    'リストの編集
    For i = 0 To lngCount - 1
        Set objItem = lsvItem.ListItems.Add(, mstrListViewKey & vntItemCode(i), vntItemCode(i))
        objItem.SubItems(1) = vntItemName(i)
        If (mintFraType = 0) And (vntCsCd(i) <> "") Then
            objItem.SubItems(2) = "枠管理対象"
        End If
    Next i
    
    '項目が１行以上存在した場合、無条件に先頭が選択されるため解除する。
    If lsvItem.ListItems.Count > 0 Then
        lsvItem.ListItems(1).Selected = False
    End If
    
    '枠管理タイプによってボタン名称を変更
    If mintFraType = 0 Then
        fraItemMain.Caption = "管理するコース"
        cmdAddItem.Caption = "管理する(&A)"
        cmdDeleteItem.Caption = "管理しない(&R)"
    Else
        fraItemMain.Caption = "管理する検査項目"
        cmdAddItem.Caption = "追加(&A)..."
        cmdDeleteItem.Caption = "削除(&R)"
    End If
    
    EditRsvFraItem = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' 機能　　 : 「項目削除」Click
'
' 機能説明 : 選択された項目をリストから削除する
'
' 備考　　 :
'
Private Sub cmdDeleteItem_Click()

    Dim i As Integer
    
    If mintFraType = 0 Then
        
        '枠管理タイプがコースなら、リストビュー上の管理、非管理を変更する
        Call ChangeItemMode(False)
        
    Else
        
        '枠管理タイプが検査項目なら、アイテム削除を行う
        
        'リストビューをくるくる回して選択項目配列作成
        For i = 1 To lsvItem.ListItems.Count
            
            'インデックスがリスト項目を越えたら終了
            If i > lsvItem.ListItems.Count Then Exit For
            
            '選択されている項目なら削除
            If lsvItem.ListItems(i).Selected = True Then
                lsvItem.ListItems.Remove (lsvItem.ListItems(i).Key)
                'アイテム数が変わるので-1して再検査
                i = i - 1
            End If
        
        Next i

    End If
    
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
    
    'データ適用処理を行う（エラー時は画面を閉じない）
    If ApplyData() = False Then
        Exit Sub
    End If

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
        
        '予約枠テーブルの登録
        If RegistRsvFra() = False Then Exit Do
        
        '更新済みにする
        mblnUpdated = True
        
        ApplyData = True
        Exit Do
    Loop
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    

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

    Dim Ret             As Boolean  '関数戻り値
    Dim i               As Integer
    
    '初期処理
    Ret = False
    
    Do
        
        If Trim(txtRsvFraCd.Text) = "" Then
            MsgBox "予約枠コードが入力されていません。", vbExclamation, App.Title
            txtRsvFraCd.SetFocus
            Exit Do
        End If

        If Trim(txtRsvFraName.Text) = "" Then
            MsgBox "予約枠名が入力されていません。", vbExclamation, App.Title
            txtRsvFraName.SetFocus
            Exit Do
        End If

        For i = 0 To 9
            
            'デフォルト値が空白なら０セット
            If Trim(txtDefCnt(i).Text) = "" Then
                txtDefCnt(i).Text = 0
            End If
            
            '数値チェック
            If IsNumeric(txtDefCnt(i).Text) = False Then
                MsgBox "デフォルト人数には数値をセットしてください", vbExclamation, App.Title
                txtDefCnt(i).SetFocus
                Exit Do
            End If
                    
        Next i

        '管理項目数のチェック
        If CheckItemSelect = False Then
            MsgBox "管理する項目が１つも登録されていません。", vbExclamation, App.Title
            tabMain.Tab = 1
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
' 機能　　 : 予約枠基本情報の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容を予約枠テーブルに保存する。
'
' 備考　　 :
'
Private Function RegistRsvFra() As Boolean

On Error GoTo ErrorHandle

    Dim objRsvFra       As Object     '予約枠アクセス用
    Dim lngRet          As Long
    Dim intOverRsv      As Integer
    Dim i               As Integer
    Dim j               As Integer
    Dim intItemCount    As Integer
    Dim vntItemCode()   As Variant
    
    RegistRsvFra = False
    intItemCount = 0
    Erase vntItemCode
    j = 0

    '枠人数オーバ登録の設定
    intOverRsv = 0
    If optOverRsv(1).Value = True Then intOverRsv = 1

    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvItem.ListItems.Count
        
        If mintFraType = 0 Then
            
            'コースの場合、管理対象のもののみセット
            If Trim(lsvItem.ListItems(i).SubItems(2)) <> "" Then
                ReDim Preserve vntItemCode(j)
                vntItemCode(j) = lsvItem.ListItems(i).Text
                j = j + 1
                intItemCount = intItemCount + 1
            End If
        
        Else
            '検査項目の場合、コードをそのままセット
            ReDim Preserve vntItemCode(j)
            vntItemCode(j) = lsvItem.ListItems(i).Text
            j = j + 1
            intItemCount = intItemCount + 1
        End If
    
    Next i

    'オブジェクトのインスタンス作成
    Set objRsvFra = CreateObject("HainsSchedule.Schedule")

    '予約枠テーブルレコードの登録
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'    lngRet = objRsvFra.RegistRsvFra_All(IIf(txtRsvFraCd.Enabled, "INS", "UPD"), _
'                                        Trim(txtRsvFraCd.Text), _
'                                        Trim(txtRsvFraName.Text), _
'                                        intOverRsv, _
'                                        mintFraType, _
'                                        Trim(txtDefCnt(0).Text), _
'                                        Trim(txtDefCnt(1).Text), _
'                                        Trim(txtDefCnt(2).Text), _
'                                        Trim(txtDefCnt(3).Text), _
'                                        Trim(txtDefCnt(4).Text), _
'                                        Trim(txtDefCnt(5).Text), _
'                                        Trim(txtDefCnt(6).Text), _
'                                        Trim(txtDefCnt(7).Text), _
'                                        Trim(txtDefCnt(8).Text), _
'                                        Trim(txtDefCnt(9).Text), _
'                                        intItemCount, _
'                                        vntItemCode)
    lngRet = objRsvFra.RegistRsvFra_All( _
        IIf(txtRsvFraCd.Enabled, "INS", "UPD"), _
        Trim(txtRsvFraCd.Text), _
        Trim(txtRsvFraName.Text), _
        intOverRsv, _
        mintFraType, _
        Trim(txtDefCnt(0).Text), _
        Trim(txtDefCnt(1).Text), _
        Trim(txtDefCnt(2).Text), _
        Trim(txtDefCnt(3).Text), _
        Trim(txtDefCnt(4).Text), _
        Trim(txtDefCnt(5).Text), _
        Trim(txtDefCnt(6).Text), _
        Trim(txtDefCnt(7).Text), _
        Trim(txtDefCnt(8).Text), _
        Trim(txtDefCnt(9).Text), _
        intItemCount, _
        vntItemCode, _
        IIf(chkIncOpenGrp.Value = vbUnchecked, 0, 1) _
    )
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
    If lngRet = INSERT_DUPLICATE Then
        MsgBox "入力された基準値管理コードは既に存在します。", vbExclamation
        RegistRsvFra = False
        Exit Function
    End If
    
    If lngRet = INSERT_ERROR Then
        MsgBox "テーブル更新時にエラーが発生しました。", vbCritical
        RegistRsvFra = False
        Exit Function
    End If
    
    mstrRsvFraCd = Trim(txtRsvFraCd.Text)
    txtRsvFraCd.Enabled = (txtRsvFraCd.Text = "")
    
    RegistRsvFra = True
    
    Exit Function
    
ErrorHandle:

    RegistRsvFra = False
    
    MsgBox Err.Description, vbCritical
    
End Function

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
        
        '時間枠情報の表示編集
        If EditTimeFra() = False Then
            Exit Do
        End If
        
        '予約枠情報の表示編集
        If EditRsvFra_p() = False Then
            Exit Do
        End If
    
        '予約枠内項目の編集
        If EditRsvFraItem() = False Then
            Exit Do
        End If
        
        'イネーブル設定
        txtRsvFraCd.Enabled = (txtRsvFraCd.Text = "")
'        cboRsvFraDiv.Enabled = txtRsvFraCd.Enabled
        
        Ret = True
        Exit Do
    
    Loop
    
    '参照専用の場合、登録系コントロールを止める
    If mblnShowOnly = True Then
        LabelCourseGuide.Caption = txtRsvFraName.Text & "のプロパティ"
        
        txtRsvFraCd.Enabled = False
        txtRsvFraName.Enabled = False
        
        cmdOk.Enabled = False
        cmdApply.Enabled = False
        cmdAddItem.Enabled = False
        cmdDeleteItem.Enabled = False
    End If
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub
Friend Property Get RsvFraCd() As Variant

    RsvFraCd = mstrRsvFraCd
    
End Property

Friend Property Let RsvFraCd(ByVal vNewValue As Variant)
    
    mstrRsvFraCd = vNewValue

End Property

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property

' @(e)
'
' 機能　　 : 受診項目一覧カラムクリック
'
' 機能説明 : クリックされたカラム項目でSortを行う
'
' 備考　　 :
'
Private Sub lsvItem_ColumnClick(ByVal ColumnHeader As MSComctlLib.ColumnHeader)
    
    'マウスポインタが砂時計のときは入力無視
    If Screen.MousePointer = vbHourglass Then
        Exit Sub
    End If
    
    '予約枠区分が検査項目の場合、処理しない（順番がめちゃくちゃになるから）
    If mintFraType = MODE_ITEM Then Exit Sub
    
    With lsvItem
        .SortKey = ColumnHeader.Index - 1
        .Sorted = True
        .SortOrder = IIf(.SortOrder = lvwAscending, lvwDescending, lvwAscending)
    End With

End Sub

Private Sub lsvItem_KeyDown(KeyCode As Integer, Shift As Integer)
    
    Dim i As Long

    'CTRL+Aを押下された場合、項目を全て選択する
    If (KeyCode = vbKeyA) And (Shift = vbCtrlMask) Then
        For i = 1 To lsvItem.ListItems.Count
            lsvItem.ListItems(i).Selected = True
        Next i
    End If

End Sub

' @(e)
'
' 機能　　 : 枠管理オプションボタンクリック
'
' 機能説明 : 枠管理状態が変更された場合の対処を行う
'
' 備考　　 :
'
Private Sub optFraType_Click(Index As Integer)

    Dim strMsg      As String
    Dim intRet      As Integer
    
    'クリックされたタイプが現在のものと異なる、かつ項目が選択済みならメッセージ
    If (mintFraType <> Index) And (CheckItemSelect = True) Then
        strMsg = "現在表示している枠管理タイプと異なるものが選択されました。" & vbLf & _
                 "現在選択されている項目は全てクリアされます。" & vbLf & _
                 "よろしいですか？"
        intRet = MsgBox(strMsg, vbYesNo + vbDefaultButton2 + vbExclamation)
        If intRet = vbNo Then Exit Sub
    End If

    '現在の枠管理タイプを変更
    mintFraType = Index
    
    '予約枠内項目の編集
    If EditRsvFraItem() = False Then
        Exit Sub
    End If

End Sub

' @(e)
'
' 機能　　 : コース管理状態の変更
'
' 引数　 　: TRUE:管理する、FALSE:管理からはずす
'
' 機能説明 : 予約枠内コース項目の管理状態を変更する
'
' 備考　　 :
'
Private Sub ChangeItemMode(blnMode As Boolean)

    Dim i As Integer
    
    'リストビューをくるくる回して選択項目配列作成
    For i = 1 To lsvItem.ListItems.Count
        
        'インデックスがリスト項目を越えたら終了
        If i > lsvItem.ListItems.Count Then Exit For
        
        '選択されている項目なら処理
        If lsvItem.ListItems(i).Selected = True Then
            If blnMode = True Then
                lsvItem.ListItems(i).SubItems(2) = "枠管理対象"
            Else
                lsvItem.ListItems(i).SubItems(2) = ""
            End If
        End If
    
    Next i

End Sub

' @(e)
'
' 機能　　 : 管理項目有無チェック
'
' 戻り値　 : TRUE:あり、FALSE:なし
'
' 機能説明 : 予約枠内の管理項目をユーザが登録済みかどうかチェックする
'
' 備考　　 :
'
Private Function CheckItemSelect() As Boolean

    Dim i As Integer

    CheckItemSelect = False

    If mintFraType = FRA_TYPE_ITEM Then
        
        '現在のモードが検査項目枠ならリストビューの項目数をチェック
        If lsvItem.ListItems.Count > 0 Then CheckItemSelect = True
    
    Else
        
        '現在のモードがコース枠の場合、リストビューの管理状態をチェック
    
        'リストビューをくるくる回す
        For i = 1 To lsvItem.ListItems.Count
            
            'インデックスがリスト項目を越えたら終了
            If i > lsvItem.ListItems.Count Then Exit For
            
            '選択されている項目なら処理
            If lsvItem.ListItems(i).SubItems(2) <> "" Then
                CheckItemSelect = True
                Exit For
            End If
        Next i
    End If
    
End Function

