VERSION 5.00
Begin VB.Form frmJudCmtStc 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "判定コメントテーブルメンテナンス"
   ClientHeight    =   5685
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   8160
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmJudCmtStc.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5685
   ScaleWidth      =   8160
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboOutPriority 
      Height          =   300
      ItemData        =   "frmJudCmtStc.frx":000C
      Left            =   2040
      List            =   "frmJudCmtStc.frx":000E
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   15
      Top             =   4680
      Width           =   5850
   End
   Begin VB.CheckBox chkHihyouji 
      Caption         =   "このコメントはガイドに表示しない(&S)"
      Height          =   225
      Left            =   3360
      TabIndex        =   2
      Top             =   150
      Width           =   2835
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "レベル５(&5)"
      Height          =   255
      Index           =   4
      Left            =   6840
      TabIndex        =   14
      Top             =   4080
      Width           =   1095
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "レベル４(&4)"
      Height          =   255
      Index           =   3
      Left            =   5640
      TabIndex        =   13
      Top             =   4080
      Width           =   1155
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "レベル３(&3)"
      Height          =   255
      Index           =   2
      Left            =   4440
      TabIndex        =   12
      Top             =   4080
      Width           =   1185
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "レベル２(&2)"
      Height          =   255
      Index           =   1
      Left            =   3240
      TabIndex        =   11
      Top             =   4080
      Width           =   1155
   End
   Begin VB.CheckBox chkRecogLevel 
      Caption         =   "レベル１(&1)"
      Height          =   315
      Index           =   0
      Left            =   2040
      TabIndex        =   10
      Top             =   4050
      Width           =   1155
   End
   Begin VB.TextBox txtJudCmtStc1 
      Height          =   1380
      IMEMode         =   4  '全角ひらがな
      Left            =   2040
      MaxLength       =   500
      MultiLine       =   -1  'True
      TabIndex        =   6
      Top             =   2100
      Width           =   5835
   End
   Begin VB.ComboBox cboJudClass 
      Height          =   300
      ItemData        =   "frmJudCmtStc.frx":0010
      Left            =   2040
      List            =   "frmJudCmtStc.frx":0012
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   8
      Top             =   3570
      Width           =   5850
   End
   Begin VB.TextBox txtJudCmtStc 
      Height          =   1380
      IMEMode         =   4  '全角ひらがな
      Left            =   2040
      MaxLength       =   250
      MultiLine       =   -1  'True
      TabIndex        =   4
      Top             =   540
      Width           =   5835
   End
   Begin VB.TextBox txtJudCmtCd 
      Height          =   300
      Left            =   2040
      MaxLength       =   8
      TabIndex        =   1
      Text            =   "@@@@@@@@"
      Top             =   120
      Width           =   1095
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Height          =   315
      Left            =   5130
      TabIndex        =   16
      Top             =   5280
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   6540
      TabIndex        =   17
      Top             =   5280
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "出力順区分(&S):"
      Height          =   195
      Index           =   1
      Left            =   120
      TabIndex        =   19
      Top             =   4740
      Width           =   1335
   End
   Begin VB.Label Label5 
      Caption         =   "※認識レベルは生活指導コメントにのみ有効です"
      Height          =   195
      Left            =   2040
      TabIndex        =   18
      Top             =   4440
      Width           =   3855
   End
   Begin VB.Label Label2 
      Caption         =   "認識レベル:"
      Height          =   195
      Left            =   120
      TabIndex        =   9
      Top             =   4140
      Width           =   1125
   End
   Begin VB.Label Label1 
      Caption         =   "判定コメント ～英語(&E):"
      Height          =   180
      Index           =   2
      Left            =   120
      TabIndex        =   5
      Top             =   2100
      Width           =   1770
   End
   Begin VB.Label Label8 
      Caption         =   "判定分類(&B):"
      Height          =   195
      Index           =   0
      Left            =   120
      TabIndex        =   7
      Top             =   3630
      Width           =   1095
   End
   Begin VB.Label Label1 
      Caption         =   "判定コメント ～日本語(&J):"
      Height          =   180
      Index           =   1
      Left            =   120
      TabIndex        =   3
      Top             =   600
      Width           =   1890
   End
   Begin VB.Label Label1 
      Caption         =   "判定コメントコード(&C):"
      Height          =   180
      Index           =   0
      Left            =   120
      TabIndex        =   0
      Top             =   180
      Width           =   1590
   End
End
Attribute VB_Name = "frmJudCmtStc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'----------------------------
'修正履歴
'----------------------------
'管理番号: SL-UI-Y0101-105
'修正日  ：2010.06.15
'担当者  ：TCS)田村
'修正内容: 出力順区分を追加

Option Explicit

Private mstrJudCmtCd        As String   '判定コメントコード
Private mstrJudCmtStc       As String   '判定分類名
Private mstrJudClassCd      As String   '判定分類コード

Private mblnInitialize      As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Private mstrArrJudClassCd()    As String
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####
Private mstrOutPriority        As String
Private mstrArrOutPriority()   As String   '出力順区分

Private Const CONST_FREE_OUTPRIORITY As String = "JUDCMTPOT"
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####

Private mcolGotFocusCollection  As Collection   'GotFocus時の文字選択用コレクション

Friend Property Let JudClassCd(ByVal vntNewValue As String)

    mstrJudClassCd = vntNewValue
    
End Property
Friend Property Let JudCmtStc(ByVal vntNewValue As String)

    mstrJudCmtStc = vntNewValue
    
End Property

Friend Property Let JudCmtCd(ByVal vntNewValue As String)

    mstrJudCmtCd = vntNewValue
    
End Property

Friend Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property
Friend Property Get Initialize() As Boolean

    Initialize = mblnInitialize

End Property

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
    
    cboJudClass.Clear
    Erase mstrArrJudClassCd

    'オブジェクトのインスタンス作成
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)
    
    '判定分類は必須になりました。
    If lngCount < 1 Then
        MsgBox "判定分類コードが登録されていません。判定コメントは判定分類を登録してから再度登録してください。", vbExclamation, Me.Caption
        Exit Function
    End If
    
    '判定分類コードは未選択あり→なしに変更
    ReDim Preserve mstrArrJudClassCd(0)
    mstrArrJudClassCd(0) = ""
    cboJudClass.AddItem ""
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrJudClassCd(i + 1)
        mstrArrJudClassCd(i + 1) = vntJudClassCd(i)
        cboJudClass.AddItem vntJudClassName(i)
    Next i
    
    '先頭コンボを選択状態にする（判定分類は未選択あり）
    cboJudClass.ListIndex = 0
    
    'デフォルトセットされた判定分類をセット
    If mstrJudClassCd <> "" Then
        For i = 0 To UBound(mstrArrJudClassCd)
            If mstrArrJudClassCd(i) = mstrJudClassCd Then
                cboJudClass.ListIndex = i
            End If
        Next i
    End If
    
    EditJudClass = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
' @(e)
'
' 機能　　 : 出力順区分セット
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 機能説明 : 出力順区分をコンボボックスにセットする
'
' 備考　　 :
'
Private Function EditOutPriority() As Boolean

    Dim objFree             As Object   '汎用情報アクセス用
    
    Dim vntOutPriority          As Variant  '出力順区分コード(汎用フィールド１)
    Dim vntOutPriorityName      As Variant  '出力順区分名称(汎用フィールド２)
    Dim vntOutPriorityDef       As Variant  '出力順区分デフォルトチェック(汎用フィールド３)
    Dim lngCount            As Long     'レコード数
    Dim i                   As Long     'インデックス
    
    EditOutPriority = False
    
    cboOutPriority.Clear
    Erase mstrArrOutPriority

    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")
    lngCount = objFree.SelectFree(1, CONST_FREE_OUTPRIORITY, , , , vntOutPriority, vntOutPriorityName, vntOutPriorityDef)
    
    If lngCount < 0 Then
        MsgBox "出力順区分読み込み中にシステム的なエラーが発生しました。", vbExclamation, Me.Caption
        Exit Function
    End If
    
    '未選択あり→なしに変更
    ReDim Preserve mstrArrOutPriority(0)
    mstrArrOutPriority(0) = ""
    cboOutPriority.AddItem ""
    
    '先頭コンボを選択状態にする
    cboOutPriority.ListIndex = 0
    
    'コンボボックスの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mstrArrOutPriority(i + 1)
        mstrArrOutPriority(i + 1) = vntOutPriority(i)
        cboOutPriority.AddItem vntOutPriority(i) & ":" & vntOutPriorityName(i)
    
        'デフォルト値の設定があれば、デフォルトをとして設定する
        '       （複数デフォルトが設定されていた場合は後に指定された値が優先される）
        If vntOutPriorityDef(i) <> "" Then
            cboOutPriority.ListIndex = cboOutPriority.ListCount - 1
        End If
    
    Next i
    
    EditOutPriority = True
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'


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
'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
    Dim i               As Long     'カウント
    Dim blnCheckFlg     As Boolean  'チェックフラグ
    Const JUDCLASS_RECOGLEVEL = 50  '判定分類コード
'### 2004/11/15 Add End
    
    Ret = False
    
    Do
        'コードの入力チェック
        If Trim(txtJudCmtCd.Text) = "" Then
            MsgBox "判定コメントコードが入力されていません。", vbExclamation, App.Title
            txtJudCmtCd.SetFocus
            Exit Do
        End If

        '名称の入力チェック
        If Trim(txtJudCmtStc.Text) = "" Then
            MsgBox "判定コメントが入力されていません。", vbExclamation, App.Title
            txtJudCmtStc.SetFocus
            Exit Do
        End If

'        '判定分類選択チェック
'        If cboJudClass.ListIndex < 1 Then
'            MsgBox "判定分類が選択されていません。", vbExclamation, App.Title
'            cboJudClass.SetFocus
'            Exit Do
'        End If

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
Private Function EditJudCmtStc() As Boolean

    Dim objJudCmtStc    As Object           '判定コメントアクセス用
    
    Dim vntJudCmtStc    As Variant          '判定コメント名

' ****************2004/08/24 FJTH)M<E 英語コメント用　追加  - S ****************************
    Dim vntJudCmtStc_e    As Variant          '判定コメント名
' ****************2004/08/24 FJTH)M<E 英語コメント用　追加  - E ****************************
    
    Dim vntJudClassCd   As Variant          '判定分類コード
    
'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
    Dim vntHihyouji         As Variant      '非表示
    Dim vntRecogLevel1      As Variant      '認識レベル１
    Dim vntRecogLevel2      As Variant      '認識レベル２
    Dim vntRecogLevel3      As Variant      '認識レベル３
    Dim vntRecogLevel4      As Variant      '認識レベル４
    Dim vntRecogLevel5      As Variant      '認識レベル５
'### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
    Dim vntOutPriority          As Variant      '出力順区分
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'

    Dim Ret             As Boolean          '戻り値
    Dim i               As Integer
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    
    Do
        '検索条件が指定されていない場合は何もしない
        If Trim(mstrJudCmtCd) = "" Then
            Ret = True
            Exit Do
        End If
        
        '判定コメントテーブルレコード読み込み
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'
''''### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
''''' ****************2004/08/24 FJTH)M<E 英語コメント用　追加  - S ****************************
''''        If objJudCmtStc.SelectJudCmtStcnew(mstrJudCmtCd, _
''''                                        vntJudCmtStc, _
''''                                        vntJudCmtStc_e, _
''''                                        vntJudClassCd) = False Then
'''''        If objJudCmtStc.SelectJudCmtStc(mstrJudCmtCd, _
'''''                                        vntJudCmtStc, _
'''''                                        vntJudClassCd) = False Then
''''' ****************2004/08/24 FJTH)M<E 英語コメント用　追加  - E ****************************
'''        If objJudCmtStc.SelectJudCmtStcnew(mstrJudCmtCd, _
'''                                        vntJudCmtStc, _
'''                                        vntJudCmtStc_e, _
'''                                        vntJudClassCd, _
'''                                        , , , , _
'''                                        vntHihyouji, _
'''                                        vntRecogLevel1, _
'''                                        vntRecogLevel2, _
'''                                        vntRecogLevel3, _
'''                                        vntRecogLevel4, _
'''                                        vntRecogLevel5 _
'''                                        ) = False Then
''''### 2004/11/15 Add End
        If objJudCmtStc.SelectJudCmtStcnew(mstrJudCmtCd _
                                      , vntJudCmtStc _
                                      , vntJudCmtStc_e _
                                      , vntJudClassCd _
                                      , , , , _
                                      , vntHihyouji _
                                      , vntRecogLevel1 _
                                      , vntRecogLevel2 _
                                      , vntRecogLevel3 _
                                      , vntRecogLevel4 _
                                      , vntRecogLevel5 _
                                      , vntOutPriority _
                                        ) = False Then
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'

            MsgBox "条件を満たすレコードが存在しません。", vbCritical, App.Title
            Exit Do
        End If
    
        '読み込み内容の編集
        txtJudCmtCd.Text = mstrJudCmtCd
        txtJudCmtStc.Text = vntJudCmtStc
' ****************2004/08/24 FJTH)M<E 英語コメント用　追加  - S ****************************
        txtJudCmtStc1.Text = vntJudCmtStc_e
' ****************2004/08/24 FJTH)M<E 英語コメント用　追加  - E ****************************

'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
        If vntHihyouji = 1 Then
            chkHihyouji.Value = vbChecked
        End If
        If vntRecogLevel1 = 1 Then
            chkRecogLevel(0).Value = vbChecked
        End If
        If vntRecogLevel2 = 1 Then
            chkRecogLevel(1).Value = vbChecked
        End If
        If vntRecogLevel3 = 1 Then
            chkRecogLevel(2).Value = vbChecked
        End If
        If vntRecogLevel4 = 1 Then
            chkRecogLevel(3).Value = vbChecked
        End If
        If vntRecogLevel5 = 1 Then
            chkRecogLevel(4).Value = vbChecked
        End If
'### 2004/11/15 Add End
        
        '判定分類のセット
        If vntJudClassCd <> "" Then
            '退避配列からキーを検索
            For i = 0 To UBound(mstrArrJudClassCd)
                If mstrArrJudClassCd(i) = vntJudClassCd Then
                    cboJudClass.ListIndex = i
                End If
            Next i
        End If
    
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
        '出力順のセット
        If vntOutPriority <> "" Then
            '退避配列からキーを検索
            For i = 0 To UBound(mstrArrOutPriority)
                If mstrArrOutPriority(i) = vntOutPriority Then
                    cboOutPriority.ListIndex = i
                End If
            Next i
        End If
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
    
    
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditJudCmtStc = Ret
    
    Exit Function

ErrorHandle:

    EditJudCmtStc = False
    MsgBox Err.Description, vbCritical

    Exit Function
    
    Resume
    
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
Private Function RegistJudCmtStc() As Boolean

'On Error GoTo ErrorHandle

    Dim objJudCmtStc    As Object       '判定コメントアクセス用
    Dim Ret             As Long
    
    'オブジェクトのインスタンス作成
    Set objJudCmtStc = CreateObject("HainsJudCmtStc.JudCmtStc")
    
    '判定コメントテーブルレコードの登録
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'
''''### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
'''    '判定コメントテーブルレコードの登録
''''    Ret = objJudCmtStc.RegistJudCmtStc1(IIf(txtJudCmtCd.Enabled, "INS", "UPD"), _
''''                                       Trim(txtJudCmtCd.Text), _
''''                                       Trim(txtJudCmtStc.Text), _
''''                                       Trim(txtJudCmtStc1.Text), _
''''                                       mstrArrJudClassCd(cboJudClass.ListIndex))
'''
'''    Ret = objJudCmtStc.RegistJudCmtStc1(IIf(txtJudCmtCd.Enabled, "INS", "UPD"), _
'''                                       Trim(txtJudCmtCd.Text), _
'''                                       Trim(txtJudCmtStc.Text), _
'''                                       Trim(txtJudCmtStc1.Text), _
'''                                       mstrArrJudClassCd(cboJudClass.ListIndex), _
'''                                       IIf(chkHihyouji.Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(0).Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(1).Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(2).Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(3).Value = vbChecked, 1, ""), _
'''                                       IIf(chkRecogLevel(4).Value = vbChecked, 1, ""))
''''### 2004/11/15 Add End
    Ret = objJudCmtStc.RegistJudCmtStc1(IIf(txtJudCmtCd.Enabled, "INS", "UPD") _
                                     , Trim(txtJudCmtCd.Text) _
                                     , Trim(txtJudCmtStc.Text) _
                                     , Trim(txtJudCmtStc1.Text) _
                                     , mstrArrJudClassCd(cboJudClass.ListIndex) _
                                     , IIf(chkHihyouji.Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(0).Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(1).Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(2).Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(3).Value = vbChecked, 1, "") _
                                     , IIf(chkRecogLevel(4).Value = vbChecked, 1, "") _
                                     , mstrArrOutPriority(cboOutPriority.ListIndex) _
                                     )
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'

    If Ret = 0 Then
        MsgBox "入力された判定コメントコードは既に存在します。", vbExclamation
        RegistJudCmtStc = False
        Exit Function
    End If
    
    RegistJudCmtStc = True
    
    Exit Function
    
'ErrorHandle:
'
'    RegistJudCmtStc = False
'    MsgBox Err.Description, vbCritical
    
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
        
        '判定コメントテーブルの登録
        If RegistJudCmtStc() = False Then
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

    Do
        '判定分類コンボの編集
        If EditJudClass() = False Then
            Exit Do
        End If
        
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
        '出力順区分情報の編集
        If EditOutPriority() = False Then
            Exit Do
        End If
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
        
        '判定コメント情報の編集
        If EditJudCmtStc() = False Then
            Exit Do
        End If
    
        'イネーブル設定
        txtJudCmtCd.Enabled = (txtJudCmtCd.Text = "")
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub

