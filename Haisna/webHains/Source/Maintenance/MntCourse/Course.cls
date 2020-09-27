VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Course"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrCsCd    As String   'コースコード
Private mblnUpdated As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get CsCd() As Variant

    CsCd = mstrCsCd
    
End Property

Public Property Let CsCd(ByVal vntNewValue As Variant)

    mstrCsCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmCourse
    
    'コーステーブルメンテナンス画面をロード
    Set objForm = New frmCourse
    objForm.CsCd = mstrCsCd
    Load objForm
    
    Do
        '表示不能時は画面を閉じる
        If objForm.Initialize = False Then
            Unload objForm
            Exit Do
        End If
        
        '画面表示（モーダル以外では機能できない戻り値がとれない）
'        objForm.Show lngStyle
        objForm.Show vbModal
        mblnUpdated = objForm.Updated
        Exit Do
    Loop
    
    Set objForm = Nothing
    
End Sub

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

