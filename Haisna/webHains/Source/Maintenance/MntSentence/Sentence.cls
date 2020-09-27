VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Sentence"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrItemCd      As String   '検査項目コード
Private mstrSuffix      As String   'サフィックス
Private mstrItemName    As String   '項目名称
Private mintItemType    As Integer  '項目タイプ
Private mstrStcCd       As String   '文章コード

Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get StcCd() As Variant

    StcCd = mstrStcCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Let StcCd(ByVal vntNewValue As Variant)

    mstrStcCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmSentence
    
    '文章テーブルメンテナンス画面をロード
    Set objForm = New frmSentence
    
    With objForm
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
        .ItemName = mstrItemName
        .ItemType = mintItemType
        .StcCd = mstrStcCd
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

Public Property Get ItemCd() As Variant

    ItemCd = mstrItemCd

End Property

Public Property Let ItemCd(ByVal vNewValue As Variant)

    mstrItemCd = vNewValue

End Property

Public Property Get ItemType() As Integer

    ItemType = mintItemType

End Property

Public Property Let ItemType(ByVal vNewValue As Integer)

    mintItemType = vNewValue

End Property

Public Property Let ItemName(ByVal vNewValue As Variant)

    mstrItemName = vNewValue

End Property

Public Property Get Suffix() As String

    Suffix = mstrSuffix
    
End Property

Public Property Let Suffix(ByVal vNewValue As String)

    mstrSuffix = vNewValue

End Property
