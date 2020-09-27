VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "PubNotediv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrPubNoteDivCd  As String   'コメント分類コード
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get PubNoteDivCd() As Variant

    PubNoteDivCd = mstrPubNoteDivCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Let PubNoteDivCd(ByVal vntNewValue As Variant)

    mstrPubNoteDivCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmPubNoteDiv
    
    'コメント分類テーブルメンテナンス画面をロード
    Set objForm = New frmPubNoteDiv
    objForm.PubNoteDivCd = mstrPubNoteDivCd
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
