VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "NutriCompFood"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrComposeFoodCd   As String   '構成食品コード
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get ComposeFoodCd() As Variant

    ComposeFoodCd = mstrComposeFoodCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Let ComposeFoodCd(ByVal vntNewValue As Variant)

    mstrComposeFoodCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmNutriCompFood
    
    '構成食品テーブルメンテナンス画面をロード
    Set objForm = New frmNutriCompFood
    objForm.ComposeFoodCd = mstrComposeFoodCd
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
