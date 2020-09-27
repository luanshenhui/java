VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Item_c"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrItemCd      As String   '検査項目コード
Private mstrSuffix      As String   'サフィックス
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get ItemCd() As Variant

    ItemCd = mstrItemCd
    
End Property

Public Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmItem_c
    
    '検査項目テーブルメンテナンス画面をロード
    Set objForm = New frmItem_c
    
    With objForm
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        Load objForm
    
        Do
            '表示不能時は画面を閉じる
            If .Initialize = False Then
                Unload objForm
                Exit Do
            End If
            
            '画面表示（モーダル以外では機能できない戻り値がとれない）
    '        objForm.Show lngStyle
            .Show vbModal
            mblnUpdated = .Updated
            Exit Do
        Loop
    
    End With
    
    Set objForm = Nothing
    
End Sub

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Get Suffix() As Variant

    Suffix = mstrSuffix

End Property

Public Property Let Suffix(ByVal vNewValue As Variant)

    mstrSuffix = vNewValue

End Property
