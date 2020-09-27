VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SysPro"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'処理対象設定画面
Public Enum TargetSystemPropertyConstants
    TARGETSYSPRO_FREE = 0               '汎用テーブル
    
    TARGETSYSPRO_PRICE = 1              '適用金額
    TARGETSYSPRO_TAX = 2                '適用税額
    TARGETSYSPRO_COURSEFRA = 3          'コース予約枠
    TARGETSYSPRO_BILLNO = 4             '請求書番号
    TARGETSYSPRO_DAYID = 5              '当日ID
'    TARGETSYSPRO_RSVMARK = 6            '空き枠状態の表示用マーク
'    TARGETSYSPRO_RSVMARK = 6            '空き枠状態の表示用マーク
End Enum

Private mlngTargetSysPro    As Long     '処理対象設定画面
Private mstrFreeCd          As String   '汎用コード
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Let TargetSysPro(ByVal vntNewValue As Long)

    mlngTargetSysPro = vntNewValue
    
End Property

Public Property Let FreeCd(ByVal vntNewValue As String)

    mstrFreeCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As Form
    
    Select Case mlngTargetSysPro
        
        Case TARGETSYSPRO_FREE              '汎用テーブル
            Set objForm = New frmFree
            objForm.FreeCd = mstrFreeCd
        
        Case TARGETSYSPRO_PRICE             '適用金額
            Set objForm = New frmPrice
        
        Case TARGETSYSPRO_TAX               '適用税額
            Set objForm = New frmTax
    
    End Select
    
    Load objForm
    
    Do
        
        '表示不能時は画面を閉じる
        If objForm.Initialize = False Then
            Unload objForm
            Exit Do
        End If
        
        '画面表示
        objForm.Show lngStyle
        mblnUpdated = objForm.Updated
        
        Exit Do
    Loop
    
    Set objForm = Nothing
    
End Sub
