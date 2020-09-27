VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Jud"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrJudCd    As String   '判定コード
Private mblnUpdated  As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get JudCd() As Variant

    JudCd = mstrJudCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Let JudCd(ByVal vntNewValue As Variant)

    mstrJudCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmJud
    
    '判定テーブルメンテナンス画面をロード
    Set objForm = New frmJud
    objForm.JudCd = mstrJudCd
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
