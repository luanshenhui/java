VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "PgmInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrPgmCd  As String   'セット分類コード
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get PgmInfoCd() As Variant
    PgmInfoCd = mstrPgmCd
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Let PgmInfoCd(ByVal vntNewValue As Variant)

    mstrPgmCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmPgmInfo
    
    'セット分類テーブルメンテナンス画面をロード
    Set objForm = New frmPgmInfo
    objForm.SetPgmInfoCd = mstrPgmCd
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
'        objForm.txtPgmCd.SetFocus
        Exit Do
    Loop
    
    Set objForm = Nothing
    
End Sub

