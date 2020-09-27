VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StdJud"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mintJudClassCd      As Integer  '判定分類コード
Private mintStdJudCd        As Integer  '定型所見コード
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Get StdJudCd() As String

    StdJudCd = mintStdJudCd
    
End Property

Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Property Let StdJudCd(ByVal vntNewValue As String)

    If IsNumeric(vntNewValue) = False Then
        mintStdJudCd = 0
    Else
        mintStdJudCd = vntNewValue
    End If
    
End Property

Public Property Let JudClassCd(ByVal vntNewValue As String)

    If IsNumeric(vntNewValue) = False Then
        mintJudClassCd = 0
    Else
        mintJudClassCd = vntNewValue
    End If
    
End Property


Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmStdJud
    
    '定型所見テーブルメンテナンス画面をロード
    Set objForm = New frmStdJud
    With objForm
        .JudClassCd = mintJudClassCd
        .StdJudCd = mintStdJudCd
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
