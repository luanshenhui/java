VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ZaimuInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrZaimuDate   As String   '財務データ日付
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get ZaimuDate() As String

    ZaimuDate = mstrZaimuDate
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Let ZaimuDate(ByVal vntNewValue As String)

    mstrZaimuDate = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm         As frmZaimu
    Dim objDateForm     As frmSelectDate
    
    Do
        
        '財務連携情報日付選択画面をロード
        Set objDateForm = New frmSelectDate
        objDateForm.Show vbModal
        If objDateForm.Updated = False Then Exit Do
        
        '財務連携情報メンテナンス画面をロード
        Set objForm = New frmZaimu
        objForm.ZaimuDate = objDateForm.ZaimuDate
        Load objForm
        
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
    Set objDateForm = Nothing
    
End Sub
