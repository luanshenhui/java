VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "BillClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrBillClassCd     As String   '請求書分類コード
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly        As Boolean  'TRUE:データの更新をしない（参照のみ）

Public Property Get BillClassCd() As Variant

    BillClassCd = mstrBillClassCd
    
End Property

Public Property Let BillClassCd(ByVal vntNewValue As Variant)

    mstrBillClassCd = vntNewValue
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmBillClass
    
    '請求書分類テーブルメンテナンス画面をロード
    Set objForm = New frmBillClass
    
    With objForm
        .BillClassCd = mstrBillClassCd
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
