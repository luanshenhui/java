VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SpStdValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrSpStdValueMngCd As String   '特定健診用基準値値管理コード
Private mstrItemCd          As String   '検査項目コード
Private mstrSuffix          As String   'サフィックス

Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get ItemCd() As Variant

    ItemCd = mstrItemCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Let ItemCd(ByVal vntNewValue As Variant)

    mstrItemCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmSpStdValue
    
    '検査項目コード関連が全く設定されていないなら処理終了
    If (Trim(mstrItemCd) = "") Or (Trim(mstrSuffix) = "") Then
        MsgBox "検査項目コード、サフィックスが正しく設定されていません" & vbLf & _
               "基準値を設定することができません", vbExclamation
        Exit Sub
    End If
    
    '検査実施日分類テーブルメンテナンス画面をロード
    Set objForm = New frmSpStdValue
    With objForm
        .SpStdValueMngCd = mstrSpStdValueMngCd
        .ItemCd = mstrItemCd
        .Suffix = mstrSuffix
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

Public Property Get SpStdValueMngCd() As String

    SpStdValueMngCd = mstrSpStdValueMngCd

End Property

Public Property Let SpStdValueMngCd(ByVal vNewValue As String)

    mstrSpStdValueMngCd = vNewValue

End Property

Public Property Get Suffix() As Variant

    Suffix = mstrSuffix

End Property

Public Property Let Suffix(ByVal vNewValue As Variant)
    
    mstrSuffix = vNewValue

End Property
