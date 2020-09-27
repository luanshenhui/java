VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Item_P_Price"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrItemCd          As String   '検査項目コード
Private mstrRequestName     As String    '依頼項目名
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
End Property

Public Property Let RequestName(ByVal vntNewValue As Variant)

    mstrRequestName = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmItem_P_Price
    
    '検査項目コード関連が全く設定されていないなら処理終了
    If Trim(mstrItemCd) = "" Then
        MsgBox "検査項目コードが正しく設定されていません" & vbLf & _
               "依頼項目単価を設定することができません", vbExclamation
        Exit Sub
    End If
    
    '検査実施日分類テーブルメンテナンス画面をロード
    Set objForm = New frmItem_P_Price
    With objForm
        .ItemCd = mstrItemCd
        .RequestName = mstrRequestName
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
