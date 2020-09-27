VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "JudCmtStc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrJudCmtStc       As String   '判定分類名
Private mstrJudCmtCd        As String   '判定コメントコード
Private mstrJudClassCd      As String   '判定分類コード
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get JudCmtCd() As Variant

    JudCmtCd = mstrJudCmtCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Property Let JudCmtCd(ByVal vntNewValue As Variant)

    mstrJudCmtCd = vntNewValue
    
End Property
Public Property Let JudClassCd(ByVal vntNewValue As Variant)
        
    mstrJudClassCd = vntNewValue
    
End Property

Public Property Let JudCmtStc(ByVal vntNewValue As String)

    mstrJudCmtStc = vntNewValue
    
End Property


Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmJudCmtStc
    
    '判定コメントテーブルメンテナンス画面をロード
    Set objForm = New frmJudCmtStc
    With objForm
        .JudCmtStc = mstrJudCmtStc
        .JudCmtCd = mstrJudCmtCd
        .JudClassCd = mstrJudClassCd
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
