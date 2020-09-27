VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SecondLineDiv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrSecondLineDivCd      As String   'セット外請求明細コード
Private mblnUpdated             As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get SecondLineDivCd() As Variant

    SecondLineDivCd = mstrSecondLineDivCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Let SecondLineDivCd(ByVal vntNewValue As Variant)

    mstrSecondLineDivCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmSecondLineDiv
    
    'セット外請求明細テーブルメンテナンス画面をロード
    Set objForm = New frmSecondLineDiv
    objForm.SecondLineDivCd = mstrSecondLineDivCd
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
