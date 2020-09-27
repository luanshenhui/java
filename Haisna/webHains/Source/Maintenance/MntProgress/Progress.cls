VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Progress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrProgressCd  As String   '進捗管理用分類コード
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get ProgressCd() As Variant

    ProgressCd = mstrProgressCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Let ProgressCd(ByVal vntNewValue As Variant)

    mstrProgressCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmProgress
    
    '進捗管理用分類テーブルメンテナンス画面をロード
    Set objForm = New frmProgress
    objForm.ProgressCd = mstrProgressCd
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
