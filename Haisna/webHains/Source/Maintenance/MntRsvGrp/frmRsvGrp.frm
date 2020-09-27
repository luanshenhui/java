VERSION 5.00
Begin VB.Form frmRsvGrp 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "予約群テーブルメンテナンス"
   ClientHeight    =   5175
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
   Icon            =   "frmRsvGrp.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5175
   ScaleWidth      =   5340
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.TextBox txtRptEndTime 
      Height          =   315
      Left            =   2400
      MaxLength       =   4
      TabIndex        =   9
      Text            =   "@@@@"
      Top             =   1980
      Width           =   555
   End
   Begin VB.TextBox txtEndTime 
      Height          =   315
      Left            =   2400
      MaxLength       =   4
      TabIndex        =   7
      Text            =   "@@@@"
      Top             =   1560
      Width           =   555
   End
   Begin VB.Frame Frame1 
      Caption         =   "基本情報"
      Height          =   4575
      Left            =   120
      TabIndex        =   24
      Top             =   120
      Width           =   5115
      Begin VB.CheckBox chkIsOpenGrp 
         Caption         =   "オープン枠予約群とする(&R)"
         Height          =   195
         Left            =   2280
         TabIndex        =   20
         Top             =   3960
         Width           =   2235
      End
      Begin VB.ComboBox cboRsvSetGrp 
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
         Left            =   2280
         Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
         TabIndex        =   18
         Top             =   3480
         Width           =   2535
      End
      Begin VB.TextBox txtEndDayId 
         Height          =   285
         Left            =   2280
         MaxLength       =   4
         TabIndex        =   16
         Text            =   "@@@@"
         Top             =   3090
         Width           =   555
      End
      Begin VB.TextBox txtStrDayId 
         Height          =   285
         Left            =   2280
         MaxLength       =   4
         TabIndex        =   14
         Text            =   "@@@@"
         Top             =   2700
         Width           =   555
      End
      Begin VB.OptionButton optLead 
         Caption         =   "対象(&Y)"
         Height          =   255
         Index           =   1
         Left            =   3480
         TabIndex        =   12
         Top             =   2280
         Width           =   975
      End
      Begin VB.OptionButton optLead 
         Caption         =   "非対象(&N)"
         Height          =   255
         Index           =   0
         Left            =   2280
         TabIndex        =   11
         Top             =   2280
         Value           =   -1  'True
         Width           =   1155
      End
      Begin VB.TextBox txtStrTime 
         Height          =   315
         Left            =   2280
         MaxLength       =   4
         TabIndex        =   5
         Text            =   "@@@@"
         Top             =   1020
         Width           =   555
      End
      Begin VB.TextBox txtRsvGrpName 
         Height          =   318
         IMEMode         =   4  '全角ひらがな
         Left            =   2280
         MaxLength       =   20
         TabIndex        =   3
         Text            =   "群"
         Top             =   660
         Width           =   2055
      End
      Begin VB.TextBox txtRsvGrpCd 
         Height          =   315
         IMEMode         =   3  'ｵﾌ固定
         Left            =   2280
         MaxLength       =   3
         TabIndex        =   1
         Text            =   "@@@"
         Top             =   300
         Width           =   495
      End
      Begin VB.Label Label10 
         AutoSize        =   -1  'True
         Caption         =   "オープン枠(&O):"
         Height          =   180
         Left            =   240
         TabIndex        =   19
         Top             =   3960
         Width           =   1005
      End
      Begin VB.Label Label9 
         Caption         =   "健診受付終了時間(&P):"
         Height          =   285
         Left            =   240
         TabIndex        =   8
         Top             =   1920
         Width           =   1800
      End
      Begin VB.Label Label7 
         Caption         =   "終了時間(&F):"
         Height          =   405
         Left            =   240
         TabIndex        =   6
         Top             =   1500
         Width           =   1365
      End
      Begin VB.Label Label6 
         AutoSize        =   -1  'True
         Caption         =   "予約時の設定グループ(&R):"
         Height          =   180
         Left            =   240
         TabIndex        =   17
         Top             =   3540
         Width           =   1890
      End
      Begin VB.Label Label4 
         AutoSize        =   -1  'True
         Caption         =   "終了当日ID(&E):"
         Height          =   180
         Left            =   240
         TabIndex        =   15
         Top             =   3120
         Width           =   1140
      End
      Begin VB.Label Label3 
         AutoSize        =   -1  'True
         Caption         =   "開始当日ID(&S):"
         Height          =   180
         Left            =   240
         TabIndex        =   13
         Top             =   2730
         Width           =   1140
      End
      Begin VB.Label Label5 
         AutoSize        =   -1  'True
         Caption         =   "誘導(&L):"
         Height          =   180
         Left            =   240
         TabIndex        =   10
         Top             =   2310
         Width           =   600
      End
      Begin VB.Label Label2 
         AutoSize        =   -1  'True
         Caption         =   "予約群名(&G):"
         Height          =   180
         Left            =   240
         TabIndex        =   2
         Top             =   720
         Width           =   990
      End
      Begin VB.Label Label1 
         AutoSize        =   -1  'True
         Caption         =   "予約群コード(&C):"
         Height          =   180
         Left            =   240
         TabIndex        =   0
         Top             =   360
         Width           =   1215
      End
      Begin VB.Label Label8 
         AutoSize        =   -1  'True
         Caption         =   "開始時間(&T):"
         Height          =   180
         Left            =   240
         TabIndex        =   4
         Top             =   1110
         Width           =   975
      End
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   2550
      TabIndex        =   22
      Top             =   4770
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   1170
      TabIndex        =   21
      Top             =   4770
      Width           =   1275
   End
   Begin VB.CommandButton cmdApply 
      Caption         =   "適用(A)"
      Height          =   315
      Left            =   3930
      TabIndex        =   23
      Top             =   4770
      Width           =   1275
   End
End
Attribute VB_Name = "frmRsvGrp"
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
Private mstrRsvGrpCd        As String   '予約群コード
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly        As Boolean  'TRUE:データの更新をしない（参照のみ）
Private mblnInitialize      As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗

Private mstrRsvSetGrpCd()   As String   '予約時セットグループコードコンボ対応キー格納領域

'モジュール固有領域領域
Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Const mstrListViewKey   As String = "K"

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
' 機能　　 : 基本予約群情報画面表示
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 予約枠の基本情報を画面に表示する
'
' 備考　　 :
'
Private Function EditRsvGrp() As Boolean

    Dim objRsvGrp       As Object             '予約枠情報アクセス用
    
    Dim vntRsvGrpName   As Variant            '予約枠名称
    Dim vntStrTime      As Variant            '開始時間
    Dim vntLead         As Variant            '誘導対象
    Dim vntEndTIme      As Variant            '終了時間
    Dim vntRptEndTIme   As Variant            '健診受付終了時間
    Dim vntStrDayId     As Variant            '開始当日ID
    Dim vntEndDayId     As Variant            '終了当日ID
    Dim vntRsvSetGrpCd  As Variant            '終了当日ID
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
    Dim vntIsOpenGrp    As Variant            'オープン枠予約群
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####

    Dim Ret             As Boolean            '戻り値
    Dim i               As Integer
    
    EditRsvGrp = False
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objRsvGrp = CreateObject("HainsSchedule.Schedule")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If mstrRsvGrpCd = "" Then
            Ret = True
            Exit Do
        End If
        
        '予約群テーブル読み込み
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'        If objRsvGrp.SelectRsvGrp(mstrRsvGrpCd, vntRsvGrpName, vntStrTime, vntEndTIme, vntRptEndTIme, vntLead, vntStrDayId, vntEndDayId, vntRsvSetGrpCd) = False Then
        If objRsvGrp.SelectRsvGrp(mstrRsvGrpCd, vntRsvGrpName, vntStrTime, vntEndTIme, vntRptEndTIme, vntLead, vntStrDayId, vntEndDayId, vntRsvSetGrpCd, vntIsOpenGrp) = False Then
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If

        '読み込み内容の編集（コース基本情報）
        txtRsvGrpCd.Text = mstrRsvGrpCd
        txtRsvGrpName.Text = vntRsvGrpName
        txtStrTime.Text = IIf(vntStrTime > 0, Format(vntStrTime, "0000"), "")
        txtEndTime.Text = IIf(vntEndTIme > 0, Format(vntEndTIme, "0000"), "")
        txtRptEndTime.Text = IIf(vntRptEndTIme > 0, vntRptEndTIme, "")
        optLead(CInt(vntLead)).Value = True
        txtStrDayId.Text = vntStrDayId
        txtEndDayId.Text = vntEndDayId
        
        For i = 0 To UBound(mstrRsvSetGrpCd)
            If mstrRsvSetGrpCd(i) = vntRsvSetGrpCd Then
                cboRsvSetGrp.ListIndex = i + 1
            End If
        Next i
        
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
        chkIsOpenGrp.Value = IIf(vntIsOpenGrp > 0, vbChecked, vbUnchecked)
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditRsvGrp = Ret
    
    Exit Function

ErrorHandle:

    EditRsvGrp = False
    MsgBox Err.Description, vbCritical
    
End Function

' @(e)
'
' 機能　　 : 予約時セットグループデータセット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 予約時セットグループデータをコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditRsvSetGrp() As Boolean

    Dim objFree             As Object   '汎用情報アクセス用
    
    Dim vntRsvSetGrpCd      As Variant  '予約時セットグループコード(汎用コード)
    Dim vntRsvSetGrpName    As Variant  '予約時セットグループ名称(汎用フィールド１)
    Dim lngCount            As Long     'レコード数
    Dim i                   As Long     'インデックス
    
    EditRsvSetGrp = False
    
    cboRsvSetGrp.Clear
    Erase mstrRsvSetGrpCd

    '空のコンボを作成
    cboRsvSetGrp.AddItem ""
    
    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")
    lngCount = objFree.SelectFree(1, "RSVSETGRP", vntRsvSetGrpCd, , , vntRsvSetGrpName)
    
    If lngCount < 0 Then
        MsgBox "予約時セットグループテーブル読み込み中にシステム的なエラーが発生しました。", vbExclamation, Me.Caption
        Exit Function
    End If
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrRsvSetGrpCd(i)
        mstrRsvSetGrpCd(i) = vntRsvSetGrpCd(i)
        cboRsvSetGrp.AddItem vntRsvSetGrpName(i)
    Next i
    
    '先頭コンボを選択状態にする
    cboRsvSetGrp.ListIndex = 0
    
    EditRsvSetGrp = True
    
    Exit Function
    
ErrorHandle:

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
        
        '予約群テーブルの登録
        If RegistRsvGrp() = False Then Exit Do
        
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
        
        If Trim(txtRsvGrpCd.Text) = "" Then
            MsgBox "予約群コードが入力されていません。", vbExclamation, App.Title
            txtRsvGrpCd.SetFocus
            Exit Do
        End If

        If CheckInteger(txtRsvGrpCd.Text) = False Then
            MsgBox "予約群コードには数値を入力してください。", vbExclamation, App.Title
            txtRsvGrpCd.SetFocus
            Exit Do
        End If

        If Trim(txtRsvGrpName.Text) = "" Then
            MsgBox "予約群名称が入力されていません。", vbExclamation, App.Title
            txtRsvGrpName.SetFocus
            Exit Do
        End If
        
        '開始時間チェック
        If Trim(txtStrTime.Text) <> "" Then

            '数値タイプチェック
            If CheckInteger(txtStrTime.Text) = False Then
                MsgBox "開始時間には数値（時分の４桁）を入力してください。", vbExclamation, App.Title
                txtStrTime.SetFocus
                Exit Do
            End If
    
            If CLng(txtStrTime.Text) <> 0 Then
            
                'チェック用に４桁変換
                txtStrTime.Text = Format(Trim(txtStrTime.Text), "0000")
            
                If CInt(Mid((Trim(txtStrTime.Text)), 1, 2)) > 23 Then
                    MsgBox "正しい時間をセットしてください。", vbExclamation, App.Title
                    txtStrTime.SetFocus
                    Exit Do
                End If
            
                If CInt(Mid((Trim(txtStrTime.Text)), 3, 2)) > 59 Then
                    MsgBox "正しい時間をセットしてください。", vbExclamation, App.Title
                    txtStrTime.SetFocus
                    Exit Do
                End If

            Else
                txtStrTime.Text = ""
            End If
            
        End If
        
        '終了時間チェック
        If Trim(txtEndTime.Text) <> "" Then

            '数値タイプチェック
            If CheckInteger(txtEndTime.Text) = False Then
                MsgBox "終了時間には数値（時分の４桁）を入力してください。", vbExclamation, App.Title
                txtEndTime.SetFocus
                Exit Do
            End If
    
            If CLng(txtEndTime.Text) <> 0 Then
            
                'チェック用に４桁変換
                txtEndTime.Text = Format(Trim(txtEndTime.Text), "0000")
            
                If CInt(Mid((Trim(txtEndTime.Text)), 1, 2)) > 23 Then
                    MsgBox "正しい時間をセットしてください。", vbExclamation, App.Title
                    txtEndTime.SetFocus
                    Exit Do
                End If
            
                If CInt(Mid((Trim(txtEndTime.Text)), 3, 2)) > 59 Then
                    MsgBox "正しい時間をセットしてください。", vbExclamation, App.Title
                    txtEndTime.SetFocus
                    Exit Do
                End If

            Else
                txtEndTime.Text = ""
            End If
            
        End If
        
        If CLng("0" & txtStrTime.Text) <> 0 And Trim("0" & txtEndTime.Text) <> 0 Then
            If CLng("0" & txtStrTime.Text) > CLng("0" & txtEndTime.Text) Then
                MsgBox "受付時間の大小関係に誤りがあります。", vbExclamation, App.Title
                txtStrTime.SetFocus
                Exit Do
            End If
        End If
        
        '健診受付終了時間チェック
        If Trim(txtRptEndTime.Text) <> "" Then

            '数値タイプチェック
            If CheckInteger(txtRptEndTime.Text) = False Then
                MsgBox "健診受付終了時間には数値（時分の４桁）を入力してください。", vbExclamation, App.Title
                txtRptEndTime.SetFocus
                Exit Do
            End If
    
            If CLng(txtRptEndTime.Text) <> 0 Then
            
                'チェック用に４桁変換
                txtRptEndTime.Text = Format(Trim(txtRptEndTime.Text), "0000")
            
                If CInt(Mid((Trim(txtRptEndTime.Text)), 1, 2)) > 23 Then
                    MsgBox "正しい時間をセットしてください。", vbExclamation, App.Title
                    txtRptEndTime.SetFocus
                    Exit Do
                End If
            
                If CInt(Mid((Trim(txtRptEndTime.Text)), 3, 2)) > 59 Then
                    MsgBox "正しい時間をセットしてください。", vbExclamation, App.Title
                    txtRptEndTime.SetFocus
                    Exit Do
                End If
            
            Else
                txtRptEndTime.Text = ""
            End If
            
        End If
        
        '開始当日ＩＤチェック
        If Trim(txtStrDayId.Text) <> "" Then
            
            If CheckInteger(txtStrDayId.Text) = False Then
                MsgBox "開始当日IDには数値(1～9999)を入力してください。", vbExclamation, App.Title
                txtStrDayId.SetFocus
                Exit Do
            End If
            
            If CLng(txtStrDayId.Text) <= 0 Then
                MsgBox "開始当日IDには数値(1～9999)を入力してください。", vbExclamation, App.Title
                txtStrDayId.SetFocus
                Exit Do
            End If
            
        End If

        '終了当日ＩＤチェック
        If Trim(txtEndDayId.Text) <> "" Then
            
            '数値タイプチェック
            If CheckInteger(txtEndDayId.Text) = False Then
                MsgBox "終了当日IDには数値(1～9999)を入力してください。", vbExclamation, App.Title
                txtEndDayId.SetFocus
                Exit Do
            End If
            
            If CLng(txtEndDayId.Text) <= 0 Then
                MsgBox "開始当日IDには数値(1～9999)を入力してください。", vbExclamation, App.Title
                txtEndDayId.SetFocus
                Exit Do
            End If
            
        End If
        
        If Trim(txtStrDayId.Text) <> "" And Trim(txtEndDayId.Text) <> "" Then
            If CLng(txtStrDayId.Text) > CLng(txtEndDayId.Text) Then
                MsgBox "当日IDの大小関係に誤りがあります。", vbExclamation, App.Title
                txtStrDayId.SetFocus
                Exit Do
            End If
        End If
        
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
        If cboRsvSetGrp.ListIndex <= 0 Then
            MsgBox "予約時の設定グループを選択してください。", vbExclamation, App.Title
            cboRsvSetGrp.SetFocus
            Exit Do
        End If
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####
        
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
Private Function RegistRsvGrp() As Boolean

    Dim objSchedule     As Object   'スケジュール情報アクセス用
    Dim lngLead         As Long     '誘導対象
    Dim strRsvSetGrpCd  As String   '予約時セットグループコード
    Dim lngRet          As Long     '関数戻り値
    
    On Error GoTo ErrorHandle

    RegistRsvGrp = False

    '誘導対象情報の設定
    lngLead = 0
    If optLead(1).Value = True Then lngLead = 1

    If cboRsvSetGrp.ListIndex > 0 Then
        strRsvSetGrpCd = mstrRsvSetGrpCd(cboRsvSetGrp.ListIndex - 1)
    End If

    'オブジェクトのインスタンス作成
    Set objSchedule = CreateObject("HainsSchedule.Schedule")

    '予約群テーブルレコードの登録
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'    lngRet = objSchedule.RegistRsvGrp( _
'                 IIf(txtRsvGrpCd.Enabled, "INS", "UPD"), _
'                 Trim(txtRsvGrpCd.Text), _
'                 Trim(txtRsvGrpName.Text), _
'                 IIf(Trim(txtStrTime.Text) <> "", Trim(txtStrTime.Text), 0), _
'                 IIf(Trim(txtEndTime.Text) <> "", Trim(txtEndTime.Text), 0), _
'                 IIf(Trim(txtRptEndTime.Text) <> "", Trim(txtRptEndTime.Text), 0), _
'                 lngLead, _
'                 IIf(Trim(txtStrDayId.Text) <> "", Trim(txtStrDayId.Text), 1), _
'                 IIf(Trim(txtEndDayId.Text) <> "", Trim(txtEndDayId.Text), 9999), _
'                 strRsvSetGrpCd _
'             )
    lngRet = objSchedule.RegistRsvGrp( _
                 IIf(txtRsvGrpCd.Enabled, "INS", "UPD"), _
                 Trim(txtRsvGrpCd.Text), _
                 Trim(txtRsvGrpName.Text), _
                 IIf(Trim(txtStrTime.Text) <> "", Trim(txtStrTime.Text), 0), _
                 IIf(Trim(txtEndTime.Text) <> "", Trim(txtEndTime.Text), 0), _
                 IIf(Trim(txtRptEndTime.Text) <> "", Trim(txtRptEndTime.Text), 0), _
                 lngLead, _
                 IIf(Trim(txtStrDayId.Text) <> "", Trim(txtStrDayId.Text), 1), _
                 IIf(Trim(txtEndDayId.Text) <> "", Trim(txtEndDayId.Text), 9999), _
                 strRsvSetGrpCd, _
                 IIf(chkIsOpenGrp.Value = vbUnchecked, 0, 1) _
             )
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####

    If lngRet = INSERT_DUPLICATE Then
        MsgBox "入力された予約群コードは既に存在します。", vbExclamation
        RegistRsvGrp = False
        Exit Function
    End If
    
    If lngRet = INSERT_ERROR Then
        MsgBox "テーブル更新時にエラーが発生しました。", vbCritical
        RegistRsvGrp = False
        Exit Function
    End If
    
    mstrRsvGrpCd = Trim(txtRsvGrpCd.Text)
    txtRsvGrpCd.Enabled = (txtRsvGrpCd.Text = "")
    
    RegistRsvGrp = True
    
    Exit Function
    
ErrorHandle:

    RegistRsvGrp = False
    
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
        
        '予約枠セットグループの表示編集
        If EditRsvSetGrp() = False Then
            Exit Do
        End If
        
        '予約枠情報の表示編集
        If EditRsvGrp() = False Then
            Exit Do
        End If
        
        'イネーブル設定
        txtRsvGrpCd.Enabled = (txtRsvGrpCd.Text = "")
        
        Ret = True
        Exit Do
    
    Loop
    
    '参照専用の場合、登録系コントロールを止める
    If mblnShowOnly = True Then
        
        txtRsvGrpCd.Enabled = False
        txtRsvGrpName.Enabled = False
        txtStrTime.Enabled = False
        txtEndTime.Enabled = False
        txtRptEndTime.Enabled = False
        optLead(0).Enabled = False
        optLead(1).Enabled = False
        txtStrDayId.Enabled = False
        txtEndDayId.Enabled = False
        cboRsvSetGrp.Enabled = False
    
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

Friend Property Let ShowOnly(ByVal vNewValue As Variant)
    
    mblnShowOnly = vNewValue

End Property

