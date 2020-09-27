VERSION 5.00
Begin VB.Form frmAddJudClass 
   BorderStyle     =   3  '固定ﾀﾞｲｱﾛｸﾞ
   Caption         =   "判定分類の追加"
   ClientHeight    =   1680
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6195
   BeginProperty Font 
      Name            =   "MS UI Gothic"
      Size            =   9
      Charset         =   128
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmAddJudClass.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1680
   ScaleWidth      =   6195
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '画面の中央
   Begin VB.CheckBox chkNoReason 
      Caption         =   "この判定分類は受診検査項目の内容に関わらず展開する(&C)"
      Height          =   375
      Left            =   1260
      TabIndex        =   4
      Top             =   540
      Width           =   4695
   End
   Begin VB.CommandButton cmdCancel 
      Cancel          =   -1  'True
      Caption         =   "キャンセル"
      Height          =   315
      Left            =   4740
      TabIndex        =   3
      Top             =   1200
      Width           =   1275
   End
   Begin VB.CommandButton cmdOk 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   315
      Left            =   3360
      TabIndex        =   2
      Top             =   1200
      Width           =   1275
   End
   Begin VB.ComboBox cboJudClass 
      Height          =   300
      ItemData        =   "frmAddJudClass.frx":000C
      Left            =   1260
      List            =   "frmAddJudClass.frx":002E
      Style           =   2  'ﾄﾞﾛｯﾌﾟﾀﾞｳﾝ ﾘｽﾄ
      TabIndex        =   0
      Top             =   180
      Width           =   4770
   End
   Begin VB.Label Label8 
      Caption         =   "判定分類(&J):"
      Height          =   195
      Index           =   0
      Left            =   180
      TabIndex        =   1
      Top             =   240
      Width           =   1095
   End
End
Attribute VB_Name = "frmAddJudClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private mblnUpdate          As Boolean  'TRUE:更新しました、FALSE:未更新
Private mintJudClassCd      As Integer  '判定分類コード
Private mstrJudClassName    As String   '判定分類名
Private mintNoReason        As Integer  '無条件展開フラグ（0:展開しない、1:展開する）

'判定分類コンボ対応データ退避用
Private mintArrJudClassCd() As Integer  '判定分類コンボに対応する判定分類コード

Friend Property Get Updated() As Variant

    Updated = mblnUpdate
    
End Property


Private Sub cmdCancel_Click()

    Unload Me

End Sub


Private Sub cmdOk_Click()

    '現在の値状態をセット
    mintJudClassCd = mintArrJudClassCd(cboJudClass.ListIndex)
    mstrJudClassName = cboJudClass.List(cboJudClass.ListIndex)
    mintNoReason = IIf(chkNoReason.Value = vbChecked, 1, 0)
    
    '更新状態とする
    mblnUpdate = True
    
    Unload Me

End Sub

Private Sub Form_Load()

    '変数初期化
    cboJudClass.Clear
    chkNoReason.Value = vbUnchecked
    mblnUpdate = False
    

    '判定分類情報の画面セット
    If SetJudClass() < 1 Then
        MsgBox "判定分類が一つも登録されていません。判定分類を登録してから再度この処理を行ってください。", vbExclamation
        cmdOk.Enabled = False
    End If
    
    '無条件展開フラグのセット
    If mintNoReason = 1 Then
        chkNoReason.Value = vbChecked
    End If
    
End Sub



'
' 機能　　 : 判定分類コンボセット
'
' 引数　　 :
'
' 戻り値　 : 判定分類登録数
'
' 備考　　 :
'
Private Function SetJudClass() As Long

On Error GoTo ErrorHandle

    Dim objJudClass     As Object           '結果コメントアクセス用
    Dim vntJudClassCd   As Variant          '結果コメントコード
    Dim vntJudClassName As Variant          '結果コメント名
    Dim lngCount        As Long             'レコード数
    Dim i               As Long             'インデックス
    Dim intTargetIndex  As Integer
    
    SetJudClass = 0
    intTargetIndex = 0
    
    'オブジェクトのインスタンス作成
    Set objJudClass = CreateObject("HainsJudClass.JudClass")
    lngCount = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)
    
    cboJudClass.Clear
    
    'リストの編集
    For i = 0 To lngCount - 1
        ReDim Preserve mintArrJudClassCd(i)
        mintArrJudClassCd(i) = vntJudClassCd(i)
        cboJudClass.AddItem vntJudClassName(i)
        If vntJudClassCd(i) = mintJudClassCd Then
            intTargetIndex = i
        End If
    Next i
    
    'オブジェクト廃棄
    Set objJudClass = Nothing
    
    If lngCount > 0 Then
        cboJudClass.ListIndex = intTargetIndex
    End If
    
    SetJudClass = lngCount
    
    Exit Function
    
ErrorHandle:

    MsgBox Err.Description, vbCritical

End Function

Friend Property Get NoReason() As Integer

    NoReason = mintNoReason

End Property
Friend Property Let NoReason(ByVal vNewValue As Integer)

    mintNoReason = vNewValue
    
End Property

Friend Property Get JudClassCd() As Integer

    JudClassCd = mintJudClassCd
    
End Property

Friend Property Let JudClassCd(ByVal vNewValue As Integer)

    mintJudClassCd = vNewValue
    
End Property

Friend Property Get JudClassName() As Variant

    JudClassName = mstrJudClassName

End Property


