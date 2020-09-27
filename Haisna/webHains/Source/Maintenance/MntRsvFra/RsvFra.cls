VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "RsvFra"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'固定値の情報
Public Enum mntRsvFraConstants
    MODE_COURSE = 0     'コース予約枠モード
    MODE_ITEM = 1       '検査項目予約枠モード
End Enum

Private mstrRsvFraCd    As String   '予約枠コード
'Private mintRsvFraDiv   As Integer  '予約枠区分
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly    As Boolean  'TRUE:データの更新をしない（参照のみ）

Public Property Get RsvFraCd() As Variant

    RsvFraCd = mstrRsvFraCd
    
End Property

Public Property Let RsvFraCd(ByVal vntNewValue As Variant)

    mstrRsvFraCd = vntNewValue
    
End Property

Public Property Let ShowOnly(ByVal vntNewValue As Boolean)

    mblnShowOnly = vntNewValue
    
End Property


Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmRsvFra
    
    '予約枠テーブルメンテナンス画面をロード
    Set objForm = New frmRsvFra
    
    With objForm
        .RsvFraCd = mstrRsvFraCd
'        .RsvFraDiv = mintRsvFraDiv
        .ShowOnly = mblnShowOnly
    End With
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

