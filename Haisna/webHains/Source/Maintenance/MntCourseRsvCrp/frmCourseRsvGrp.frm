VERSION 5.00
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Begin VB.Form frmCourseRsvGrp 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "コース受診予約群テーブルメンテナンス"
   ClientHeight    =   5715
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5340
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmCourseRsvGrp.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5715
   ScaleWidth      =   5340
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1200
      TabIndex        =   22
      Top             =   5340
      Width           =   1275
   End
   Begin TabDlg.SSTab tabMain 
      Height          =   5115
      Left            =   120
      TabIndex        =   21
      Top             =   120
      Width           =   5115
      _ExtentX        =   9022
      _ExtentY        =   9022
      _Version        =   393216
      Style           =   1
      Tabs            =   1
      TabHeight       =   520
      TabCaption(0)   =   "基本情報"
      TabPicture(0)   =   "frmCourseRsvGrp.frx":000C
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Image1"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Label1"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Frame1"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "Frame2"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "Frame3"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).ControlCount=   5
      Begin VB.Frame Frame3 
         Caption         =   "枠設定時のデフォルト人数(&D)"
         Height          =   1635
         Left            =   120
         TabIndex        =   8
         Top             =   3360
         Width           =   4875
         Begin VB.TextBox txtDefCnt 
            Height          =   285
            Left            =   1680
            MaxLength       =   3
            TabIndex        =   10
            Text            =   "@@@"
            Top             =   360
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_m 
            Height          =   285
            Left            =   1680
            MaxLength       =   3
            TabIndex        =   14
            Text            =   "@@@"
            Top             =   720
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_f 
            Height          =   285
            Left            =   1680
            MaxLength       =   3
            TabIndex        =   18
            Text            =   "@@@"
            Top             =   1080
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_sat 
            Height          =   285
            Left            =   3960
            MaxLength       =   3
            TabIndex        =   12
            Text            =   "@@@"
            Top             =   360
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_sat_m 
            Height          =   285
            IMEMode         =   2  'ｵﾌ
            Left            =   3960
            MaxLength       =   3
            TabIndex        =   16
            Text            =   "@@@"
            Top             =   720
            Width           =   555
         End
         Begin VB.TextBox txtDefCnt_sat_f 
            Height          =   285
            IMEMode         =   2  'ｵﾌ
            Left            =   3960
            MaxLength       =   3
            TabIndex        =   20
            Text            =   "@@@"
            Top             =   1080
            Width           =   555
         End
         Begin VB.Label Label4 
            AutoSize        =   -1  'True
            Caption         =   "共通(&C):"
            Height          =   180
            Left            =   300
            TabIndex        =   9
            Top             =   420
            Width           =   630
         End
         Begin VB.Label Label5 
            AutoSize        =   -1  'True
            Caption         =   "男性(&M):"
            Height          =   180
            Left            =   300
            TabIndex        =   13
            Top             =   780
            Width           =   645
         End
         Begin VB.Label Label6 
            AutoSize        =   -1  'True
            Caption         =   "女性(&F):"
            Height          =   180
            Left            =   300
            TabIndex        =   17
            Top             =   1140
            Width           =   615
         End
         Begin VB.Label Label7 
            AutoSize        =   -1  'True
            Caption         =   "土曜日共通(&S):"
            Height          =   180
            Left            =   2520
            TabIndex        =   11
            Top             =   420
            Width           =   1155
         End
         Begin VB.Label Label8 
            AutoSize        =   -1  'True
            Caption         =   "土曜日（男性）(&O):"
            Height          =   180
            Left            =   2520
            TabIndex        =   15
            Top             =   780
            Width           =   1350
         End
         Begin VB.Label Label9 
            AutoSize        =   -1  'True
            Caption         =   "土曜日（女性）(&N):"
            Height          =   180
            Left            =   2520
            TabIndex        =   19
            Top             =   1140
            Width           =   1350
         End
      End
      Begin VB.Frame Frame2 
         Caption         =   "男女別枠管理(&G)"
         Height          =   855
         Left            =   120
         TabIndex        =   5
         Top             =   2400
         Width           =   4875
         Begin VB.OptionButton optMngGender 
            Caption         =   "する(&Y)"
            Height          =   255
            Index           =   1
            Left            =   1440
            TabIndex        =   7
            Top             =   360
            Width           =   915
         End
         Begin VB.OptionButton optMngGender 
            Caption         =   "しない(&N)"
            Height          =   255
            Index           =   0
            Left            =   300
            TabIndex        =   6
            Top             =   360
            Value           =   -1  'True
            Width           =   1095
         End
      End
      Begin VB.Frame Frame1 
         Caption         =   "基本情報(&B)"
         Height          =   1215
         Left            =   120
         TabIndex        =   0
         Top             =   1110
         Width           =   4875
         Begin VB.ComboBox cboRsvGrp 
            Height          =   300
            Left            =   1200
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   4
            Top             =   690
            Width           =   2955
         End
         Begin VB.ComboBox cboCourse 
            Height          =   300
            Left            =   1200
            Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
            TabIndex        =   2
            Top             =   330
            Width           =   2955
         End
         Begin VB.Label Label2 
            AutoSize        =   -1  'True
            Caption         =   "予約群(&R):"
            Height          =   180
            Left            =   240
            TabIndex        =   3
            Top             =   720
            Width           =   810
         End
         Begin VB.Label Label3 
            Caption         =   "コース(&C):"
            Height          =   195
            Left            =   240
            TabIndex        =   1
            Top             =   360
            Width           =   1275
         End
      End
      Begin VB.Label Label1 
         Caption         =   "コースごとに管理対象となる予約群を定義します。"
         Height          =   180
         Left            =   960
         TabIndex        =   25
         Top             =   600
         Width           =   3495
      End
      Begin VB.Image Image1 
         Height          =   480
         Left            =   300
         Picture         =   "frmCourseRsvGrp.frx":0028
         Top             =   480
         Width           =   480
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   2580
      TabIndex        =   23
      Top             =   5340
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
      Height          =   315
      Left            =   3960
      TabIndex        =   24
      Top             =   5340
      Width           =   1275
   End
End
Attribute VB_Name = "frmCourseRsvGrp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

'プロパティ用領域
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly        As Boolean  'TRUE:データの更新をしない（参照のみ）
Private mblnInitialize      As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗

Private mstrCsCd            As String   'コースコード（配列は、コンボボックスと対応）
Private mstrRsvGrpCd        As String   '予約群コード（配列は、コンボボックスと対応）

Private mstrArrCsCd()       As String   'コースコードコンボ対応キー格納領域
Private mstrArrRsvGrpCd()   As String   '予約群コードコンボ対応キー格納領域

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
' 機能　　 : 基本予約枠情報画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 予約枠の基本情報を画面に表示する
'
' 備考　　 :
'
Private Function EditCourseRsvGrp() As Boolean

    Dim objSchedule         As Object   'スケジュール情報アクセス用
    
    Dim vntMngGender        As Variant  '男女別枠管理
    Dim vntDefCnt           As Variant  '共通人数
    Dim vntDefCnt_M         As Variant  '男人数
    Dim vntDefCnt_F         As Variant  '女人数
    Dim vntDefCnt_Sat       As Variant  '土曜共通人数
    Dim vntDefCnt_Sat_M     As Variant  '土曜男人数
    Dim vntDefCnt_Sat_F     As Variant  '土曜女人数
    
    Dim Ret                 As Boolean  '関数戻り値
    Dim i                   As Long     'インデックス
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objSchedule = CreateObject("HainsSchedule.Schedule")
    
    Do
        'コース受診予約群レコード読み込み
        If objSchedule.SelectCourseRsvGrp(mstrCsCd, mstrRsvGrpCd, vntMngGender, vntDefCnt, vntDefCnt_M, vntDefCnt_F, vntDefCnt_Sat, vntDefCnt_Sat_M, vntDefCnt_Sat_F) = False Then
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
        
        '読み込み内容の編集
        optMngGender(CLng(vntMngGender)).Value = True
        txtDefCnt.Text = vntDefCnt
        txtDefCnt_m.Text = vntDefCnt_M
        txtDefCnt_f.Text = vntDefCnt_F
        txtDefCnt_sat.Text = vntDefCnt_Sat
        txtDefCnt_sat_m.Text = vntDefCnt_Sat_M
        txtDefCnt_sat_f.Text = vntDefCnt_Sat_F
        
        'コンボボックスの編集
        For i = 0 To UBound(mstrArrCsCd)
            If mstrArrCsCd(i) = mstrCsCd Then
                cboCourse.ListIndex = i + 1
            End If
        Next i
        
        For i = 0 To UBound(mstrArrRsvGrpCd)
            If mstrArrRsvGrpCd(i) = mstrRsvGrpCd Then
                cboRsvGrp.ListIndex = i + 1
            End If
        Next i
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditCourseRsvGrp = Ret
    
    Exit Function

ErrorHandle:

    EditCourseRsvGrp = False
    MsgBox Err.Description, vbCritical
    
End Function

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
        
        'コース受診予約群テーブルの登録
        If RegistCourseRsvGrp() = False Then Exit Do
        
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
' 機能　　 : 予約枠基本情報の保存
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 入力内容を予約枠テーブルに保存する。
'
' 備考　　 :
'
Private Function RegistCourseRsvGrp() As Boolean

    Dim objSchedule     As Object   'スケジュール情報アクセス用
    Dim lngMngGender    As Long     '男女別枠管理
    Dim lngRet          As Long     '関数戻り値
    
    On Error GoTo ErrorHandle
    
    RegistCourseRsvGrp = False

    '男女別枠管理の設定
    Select Case True
        Case optMngGender(0).Value
            lngMngGender = 0
        Case optMngGender(1).Value
            lngMngGender = 1
    End Select

    'オブジェクトのインスタンス作成
    Set objSchedule = CreateObject("HainsSchedule.Schedule")

    'コース受診予約群テーブルレコードの登録
    lngRet = objSchedule.RegistCourseRsvGrp( _
                 IIf(cboCourse.Enabled, "INS", "UPD"), _
                 mstrArrCsCd(cboCourse.ListIndex - 1), _
                 mstrArrRsvGrpCd(cboRsvGrp.ListIndex - 1), _
                 lngMngGender, _
                 IIf(txtDefCnt.Enabled, Trim(txtDefCnt.Text), 0), _
                 IIf(txtDefCnt_m.Enabled, Trim(txtDefCnt_m.Text), 0), _
                 IIf(txtDefCnt_f.Enabled, Trim(txtDefCnt_f.Text), 0), _
                 IIf(txtDefCnt_sat.Enabled, Trim(txtDefCnt_sat.Text), 0), _
                 IIf(txtDefCnt_sat_m.Enabled, Trim(txtDefCnt_sat_m.Text), 0), _
                 IIf(txtDefCnt_sat_f.Enabled, Trim(txtDefCnt_sat_f.Text), 0) _
             )
    
    If lngRet = INSERT_DUPLICATE Then
        MsgBox "入力されたコース受診予約群は既に存在します。", vbExclamation, Me.Caption
        Exit Function
    End If
    
    If lngRet = INSERT_ERROR Then
        MsgBox "テーブル更新時にエラーが発生しました。", vbCritical, Me.Caption
        Exit Function
    End If
        
    mstrCsCd = mstrArrCsCd(cboCourse.ListIndex - 1)
    mstrRsvGrpCd = mstrArrRsvGrpCd(cboRsvGrp.ListIndex - 1)
    cboCourse.Enabled = False
    cboRsvGrp.Enabled = False
    
    RegistCourseRsvGrp = True
    
    Exit Function
    
ErrorHandle:

    RegistCourseRsvGrp = False
    
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
                
        'コースコンボの表示編集
        If EditCourse() = False Then
            Exit Do
        End If
                
        '予約群コンボの表示編集
        If EditRsvGrp() = False Then
            Exit Do
        End If
                
        '予約枠情報の表示編集
        If mstrCsCd <> "" And mstrRsvGrpCd <> "" Then
            If EditCourseRsvGrp() = False Then
                Exit Do
            End If
        End If
        
        'イネーブル設定
        cboCourse.Enabled = (mstrCsCd = "")
        cboRsvGrp.Enabled = (mstrRsvGrpCd = "")
        
        Select Case True
            Case optMngGender(0).Value
                Call EnableControl(0)
            Case optMngGender(1).Value
                Call EnableControl(1)
        End Select
        
        Ret = True
        Exit Do
    
    Loop
    
    '参照専用の場合、登録系コントロールを止める
    If mblnShowOnly = True Then
        
        cboCourse.Enabled = False
        cboRsvGrp.Enabled = False
        
        optMngGender(0).Enabled = False
        optMngGender(1).Enabled = False
        
        txtDefCnt.Enabled = False
        txtDefCnt_m.Enabled = False
        txtDefCnt_f.Enabled = False
        txtDefCnt_sat.Enabled = False
        txtDefCnt_sat_m.Enabled = False
        txtDefCnt_sat_f.Enabled = False
        
        cmdOk.Enabled = False
        cmdApply.Enabled = False
    
    End If
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

Friend Property Get RsvGrpCd() As Variant

    RsvGrpCd = mstrRsvGrpCd
    
End Property

Friend Property Let RsvGrpCd(ByVal vNewValue As Variant)
    
    mstrRsvGrpCd = vNewValue

End Property

Friend Property Get CsCd() As Variant

    CsCd = mstrCsCd
    
End Property

Friend Property Let CsCd(ByVal vNewValue As Variant)
    
    mstrCsCd = vNewValue

End Property

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property

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

    Dim Ret             As Boolean  '関数戻り値
    Dim i               As Integer
    
    '初期処理
    Ret = False
    
    Do
    
        'コース未選択時
        If cboCourse.ListIndex <= 0 Then
            MsgBox "コースを選択してください。", vbExclamation, App.Title
            cboCourse.SetFocus
            Exit Do
        End If
        
        '予約群未選択時
        If cboRsvGrp.ListIndex <= 0 Then
            MsgBox "予約群を選択してください。", vbExclamation, App.Title
            cboRsvGrp.SetFocus
            Exit Do
        End If
        
        'デフォルト値が空白なら０セット
        If Trim(txtDefCnt.Text) = "" Then
            txtDefCnt.Text = 0
        End If
        
        If Trim(txtDefCnt_m.Text) = "" Then
            txtDefCnt_m.Text = 0
        End If
        
        If Trim(txtDefCnt_f.Text) = "" Then
            txtDefCnt_f.Text = 0
        End If
        
        If Trim(txtDefCnt_sat.Text) = "" Then
            txtDefCnt_sat.Text = 0
        End If
        
        If Trim(txtDefCnt_sat_m.Text) = "" Then
            txtDefCnt_sat_m.Text = 0
        End If
        
        If Trim(txtDefCnt_sat_f.Text) = "" Then
            txtDefCnt_sat_f.Text = 0
        End If
        
        '数値チェック
        If txtDefCnt.Enabled Then
            If CheckInteger(txtDefCnt.Text) = False Then
                MsgBox "デフォルト人数には数値をセットしてください", vbExclamation, App.Title
                txtDefCnt.SetFocus
                Exit Do
            End If
        End If
        
        '数値チェック
        If txtDefCnt_m.Enabled Then
            If CheckInteger(txtDefCnt_m.Text) = False Then
                MsgBox "デフォルト人数には数値をセットしてください", vbExclamation, App.Title
                txtDefCnt_m.SetFocus
                Exit Do
            End If
        End If
        
        '数値チェック
        If txtDefCnt_f.Enabled Then
            If CheckInteger(txtDefCnt_f.Text) = False Then
                MsgBox "デフォルト人数には数値をセットしてください", vbExclamation, App.Title
                txtDefCnt_f.SetFocus
                Exit Do
            End If
        End If
        
        '数値チェック
        If txtDefCnt_sat.Enabled Then
            If CheckInteger(txtDefCnt_sat.Text) = False Then
                MsgBox "デフォルト人数には数値をセットしてください", vbExclamation, App.Title
                txtDefCnt_sat.SetFocus
                Exit Do
            End If
        End If
            
        '数値チェック
        If txtDefCnt_sat_m.Enabled Then
            If CheckInteger(txtDefCnt_sat_m.Text) = False Then
                MsgBox "デフォルト人数には数値をセットしてください", vbExclamation, App.Title
                txtDefCnt_sat_m.SetFocus
                Exit Do
            End If
        End If
            
        '数値チェック
        If txtDefCnt_sat_f.Enabled Then
            If CheckInteger(txtDefCnt_sat_f.Text) = False Then
                MsgBox "デフォルト人数には数値をセットしてください", vbExclamation, App.Title
                txtDefCnt_sat_f.SetFocus
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
' 機能　　 : コース名称データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : コース名称データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditCourse() As Boolean

    Dim objCourse       As Object   'コース情報アクセス用
    
    Dim vntCsCd         As Variant  'コースコード
    Dim vntCsName       As Variant  'コース名
    Dim lngCount        As Long     'レコード数
    
    Dim i               As Long     'インデックス
    
    On Error GoTo ErrorHandle
    
    EditCourse = False
    
    cboCourse.Clear
    Erase mstrArrCsCd

    '空のコンボを作成
    cboCourse.AddItem ""

    'オブジェクトのインスタンス作成
    Set objCourse = CreateObject("HainsCourse.Course")
    lngCount = objCourse.SelectCourseList(vntCsCd, vntCsName)
    Set objCourse = Nothing
    
    If lngCount < 0 Then
        MsgBox "コーステーブル読み込み中にシステム的なエラーが発生しました。", vbExclamation, Me.Caption
        Exit Function
    End If
    
    If lngCount = 0 Then
        MsgBox "コースが登録されていません。コースを登録してからコース受診予約群を登録してください。", vbExclamation, Me.Caption
        Exit Function
    End If
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrCsCd(i)
        mstrArrCsCd(i) = vntCsCd(i)
        cboCourse.AddItem vntCsName(i)
    Next i
    
    '先頭コンボを選択状態にする
    cboCourse.ListIndex = 0
    
    EditCourse = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

' @(e)
'
' 機能　　 : 予約群データセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 予約群データをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditRsvGrp() As Boolean

    Dim objSchedule     As Object   'スケジュール情報アクセス用
    
    Dim vntRsvGrpCd     As Variant  '予約群コード
    Dim vntRsvGrpName   As Variant  '予約群名称
    Dim lngCount        As Long     'レコード数
    Dim i               As Long     'インデックス
    
    EditRsvGrp = False
    
    cboRsvGrp.Clear
    Erase mstrArrRsvGrpCd

    '空のコンボを作成
    cboRsvGrp.AddItem ""
    
    'オブジェクトのインスタンス作成
    Set objSchedule = CreateObject("HainsSchedule.Schedule")
    lngCount = objSchedule.SelectRsvGrpList(, vntRsvGrpCd, vntRsvGrpName)
    
    If lngCount < 0 Then
        MsgBox "予約群テーブル読み込み中にシステム的なエラーが発生しました。", vbExclamation, Me.Caption
        Exit Function
    End If
    
    If lngCount = 0 Then
        MsgBox "予約群が登録されていません。予約群を登録してからコース受診予約群を登録してください。", vbExclamation, Me.Caption
        Exit Function
    End If

    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrRsvGrpCd(i)
        mstrArrRsvGrpCd(i) = vntRsvGrpCd(i)
        cboRsvGrp.AddItem vntRsvGrpName(i)
    Next i
    
    '先頭コンボを選択状態にする
    cboRsvGrp.ListIndex = 0
    
    EditRsvGrp = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Private Sub EnableControl(ByRef Index As Integer)

    'イネーブル制御
    txtDefCnt.Enabled = (Index = 0)
    txtDefCnt_m.Enabled = (Index = 1)
    txtDefCnt_f.Enabled = (Index = 1)
    txtDefCnt_sat.Enabled = (Index = 0)
    txtDefCnt_sat_m.Enabled = (Index = 1)
    txtDefCnt_sat_f.Enabled = (Index = 1)

    txtDefCnt.BackColor = IIf(Index = 0, vbWindowBackground, vbButtonFace)
    txtDefCnt_m.BackColor = IIf(Index = 1, vbWindowBackground, vbButtonFace)
    txtDefCnt_f.BackColor = IIf(Index = 1, vbWindowBackground, vbButtonFace)
    txtDefCnt_sat.BackColor = IIf(Index = 0, vbWindowBackground, vbButtonFace)
    txtDefCnt_sat_m.BackColor = IIf(Index = 1, vbWindowBackground, vbButtonFace)
    txtDefCnt_sat_f.BackColor = IIf(Index = 1, vbWindowBackground, vbButtonFace)

End Sub

Private Sub optMngGender_Click(Index As Integer)

    Call EnableControl(Index)

End Sub
