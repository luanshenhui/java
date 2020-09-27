VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NutriFoodEnergy"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrEnergy      As String   'エネルギー
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get Energy() As Variant

    Energy = mstrEnergy
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Let Energy(ByVal vntNewValue As Variant)

    mstrEnergy = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmNutriFoodEnergy
    
    '食品群別摂取テーブルメンテナンス画面をロード
    Set objForm = New frmNutriFoodEnergy
    objForm.Energy = mstrEnergy
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
