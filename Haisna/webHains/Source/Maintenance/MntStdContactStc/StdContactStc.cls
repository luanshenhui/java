VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StdContactStc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrGuidanceDiv         As String   '指導内容区分
Private mstrStdContactStcCd     As String   '定型面接文章コード
Private mblnUpdated             As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get GuidanceDiv() As Variant

    GuidanceDiv = mstrGuidanceDiv
    
End Property

Public Property Get StdContactStcCd() As Variant

    StdContactStcCd = mstrStdContactStcCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Let GuidanceDiv(ByVal vntNewValue As Variant)

    mstrGuidanceDiv = vntNewValue
    
End Property

Public Property Let StdContactStcCd(ByVal vntNewValue As Variant)

    mstrStdContactStcCd = vntNewValue
    
End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmStdContactStc
    
    '定型面接文章テーブルメンテナンス画面をロード
    Set objForm = New frmStdContactStc
    With objForm
        .StdContactStcCd = mstrStdContactStcCd
        .GuidanceDiv = mstrGuidanceDiv
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
