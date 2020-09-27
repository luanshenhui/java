VERSION 5.00
Begin VB.Form frmPrice 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "適用金額の設定"
   ClientHeight    =   1965
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   5640
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmPrice.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1965
   ScaleWidth      =   5640
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'ｵｰﾅｰ ﾌｫｰﾑの中央
   Begin VB.ComboBox cboDay 
      Height          =   300
      ItemData        =   "frmPrice.frx":000C
      Left            =   2100
      List            =   "frmPrice.frx":0013
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   8
      Top             =   780
      Width           =   555
   End
   Begin VB.ComboBox cboMonth 
      Height          =   300
      ItemData        =   "frmPrice.frx":001B
      Left            =   1200
      List            =   "frmPrice.frx":0022
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   7
      Top             =   780
      Width           =   555
   End
   Begin VB.ComboBox cboYear 
      Height          =   300
      ItemData        =   "frmPrice.frx":002A
      Left            =   180
      List            =   "frmPrice.frx":0031
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   6
      Top             =   780
      Width           =   735
   End
   Begin VB.ComboBox cboPrice 
      Height          =   300
      Index           =   1
      Left            =   3480
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   5
      Top             =   780
      Width           =   1215
   End
   Begin VB.ComboBox cboPrice 
      Height          =   300
      Index           =   0
      Left            =   1260
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   4
      Top             =   240
      Width           =   1215
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   2700
      TabIndex        =   2
      Top             =   1500
      Width           =   1335
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4140
      TabIndex        =   3
      Top             =   1500
      Width           =   1335
   End
   Begin VB.Label Label8 
      Caption         =   "日以降"
      Height          =   255
      Index           =   3
      Left            =   2700
      TabIndex        =   11
      Top             =   840
      Width           =   555
   End
   Begin VB.Label Label8 
      Caption         =   "月"
      Height          =   255
      Index           =   1
      Left            =   1800
      TabIndex        =   10
      Top             =   840
      Width           =   255
   End
   Begin VB.Label Label8 
      Caption         =   "年"
      Height          =   255
      Index           =   0
      Left            =   960
      TabIndex        =   9
      Top             =   840
      Width           =   255
   End
   Begin VB.Label Label1 
      Caption         =   "を適用"
      Height          =   180
      Index           =   1
      Left            =   4800
      TabIndex        =   1
      Top             =   840
      Width           =   630
   End
   Begin VB.Label Label1 
      Caption         =   "基本金額(&B):"
      Height          =   180
      Index           =   0
      Left            =   180
      TabIndex        =   0
      Top             =   300
      Width           =   1110
   End
End
Attribute VB_Name = "frmPrice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mblnInitialize  As Boolean  'TRUE:正常に初期化、FALSE:初期化失敗
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnModeNew     As Boolean  'TRUE:新規、FALSE:更新

Private mintField1      As Integer
Private mintField2      As Integer
Private mdtnFreeDate    As Date

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Get Initialize() As Boolean

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

    Dim Ret         As Boolean  '関数戻り値
    Dim blnRet      As Boolean
    
    Ret = False
    
    Do
        If cboPrice(0).ListIndex = cboPrice(1).ListIndex Then
            blnRet = MsgBox("金額が両方とも同じ内容で設定されています。この内容で保存しますか？", vbExclamation + vbYesNo + vbDefaultButton2, vbQuestion)
            If blnRet = vbNo Then Exit Do
        End If
        
        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    CheckValue = Ret
    
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
Private Function RegistFree() As Boolean

    Dim objFree As Object       '汎用テーブルアクセス用
    Dim Ret     As Long
    
    On Error GoTo ErrorHandle
    
    mdtnFreeDate = CDate((cboYear.List(cboYear.ListIndex) & "/" & cboMonth.List(cboMonth.ListIndex) & "/" & cboDay.List(cboDay.ListIndex)))
    
    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")

    '汎用テーブルレコードの登録
    If mblnModeNew = True Then
    
        '新規登録
        Ret = objFree.InsertFree(SYSPRO_PRICE_KEY, _
                                 SYSPRO_COMMON_CLASS, _
                                 SYSPRO_PRICE_NAME, _
                                 mdtnFreeDate, _
                                 cboPrice(0).ListIndex + 1, _
                                 cboPrice(1).ListIndex + 1)
        
    
    Else
    
        '更新
        Ret = objFree.UpdateFree(SYSPRO_PRICE_KEY, _
                                 SYSPRO_COMMON_CLASS, _
                                 SYSPRO_PRICE_NAME, _
                                 mdtnFreeDate, _
                                 cboPrice(0).ListIndex + 1, _
                                 cboPrice(1).ListIndex + 1)
    
        If Ret = True Then Ret = INSERT_NORMAL
        
    End If

    If Ret <> INSERT_NORMAL Then
        MsgBox "データ更新時にエラーが発生しました。", vbCritical
        RegistFree = False
        Exit Function
    End If

    'データ存在のため、更新モード
    mblnModeNew = False
    
    RegistFree = True
    
    Exit Function
    
ErrorHandle:

    RegistFree = False
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
Private Function EditFree() As Boolean

    Dim objFree         As Object           '汎用テーブルアクセス用
    
    Dim lngMode         As Long
    Dim strFreeCdKey    As String
    Dim vntFreeCd       As Variant
    Dim vntFreeName     As Variant
    Dim vntFreeDate     As Variant
    Dim vntFreeField1   As Variant
    Dim vntFreeField2   As Variant

    Dim Ret             As Boolean          '戻り値
    
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objFree = CreateObject("HainsFree.Free")
    
    Do
        
        '消費税額レコード読み込み
        If objFree.SelectFree(0, _
                              SYSPRO_PRICE_KEY, _
                              vntFreeCd, _
                              vntFreeName, _
                              vntFreeDate, _
                              vntFreeField1, _
                              vntFreeField2) = False Then
            
            'データなしでも、画面は開く
            Ret = True
            Exit Do
        End If
    
        'データ存在のため、更新モード
        mblnModeNew = False
    
        '読み込み内容の編集
        If IsDate(vntFreeDate) Then
            mdtnFreeDate = vntFreeDate
        End If
        
        '
        If IsNumeric(vntFreeField1) Then
            If (CLng(vntFreeField1) >= 1) And (CLng(vntFreeField1) <= 2) Then
                mintField1 = CInt(vntFreeField1)
            End If
        End If

        If IsNumeric(vntFreeField2) Then
            If (CLng(vntFreeField2) >= 1) And (CLng(vntFreeField2) <= 2) Then
                mintField2 = CInt(vntFreeField2)
            End If
        End If

        Ret = True
        Exit Do
    Loop
    
    '戻り値の設定
    EditFree = Ret
    
    Exit Function

ErrorHandle:

    EditFree = False
    
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
        
        'データの登録
        If RegistFree() = False Then
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
    Dim i   As Integer
    
    '処理中の表示
    Screen.MousePointer = vbHourglass
    
    '初期処理
    Ret = False
    mblnUpdated = False
    mblnModeNew = True

    mdtnFreeDate = Now
    mintField1 = 1
    mintField2 = 2
    
    Do
        '汎用テーブルからのデータ編集
        If EditFree() = False Then
            Exit Do
        End If
    
        Ret = True
        Exit Do
    Loop
    
    '金額コンボクリア
    For i = 0 To 1
        With cboPrice(i)
            .Clear
            .AddItem "金額１"
            .AddItem "金額２"
        End With
    Next i
    
    cboPrice(0).ListIndex = mintField1 - 1
    cboPrice(1).ListIndex = mintField2 - 1
    
    
    'コンボボックスに値をセット
    With cboYear
        .Clear
        For i = YEARRANGE_MIN To YEARRANGE_MAX
            .AddItem i
            If (i = Year(mdtnFreeDate)) And _
               (YEARRANGE_MIN <= Year(mdtnFreeDate)) And _
               (YEARRANGE_MAX >= Year(mdtnFreeDate)) Then
                .ListIndex = i - YEARRANGE_MIN
            End If
        Next i
    End With
    
    With cboMonth
        .Clear
        For i = 1 To 12
            .AddItem i
            If i = Month(mdtnFreeDate) Then
                .ListIndex = i - 1
            End If
        Next i
    End With
    
    With cboDay
        .Clear
        For i = 1 To 31
            .AddItem i
            If i = Day(mdtnFreeDate) Then
                .ListIndex = i - 1
            End If
        Next i
    End With
    
    '戻り値の設定
    mblnInitialize = Ret
    
    '処理中の解除
    Screen.MousePointer = vbDefault
    
End Sub
