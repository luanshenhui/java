VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Grp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'固定値の情報
Public Enum mntGrpConstants
    MODE_REQUEST = 1        '依頼モード
    MODE_RESULT = 2         '結果モード
End Enum

Private mstrGrpCd       As String   'グループコード
Private mintGrpDiv      As Integer  'グループ区分
Private mblnUpdated     As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly    As Boolean  'TRUE:データの更新をしない（参照のみ）


Public Property Get GrpCd() As Variant

    GrpCd = mstrGrpCd
    
End Property

Public Property Let GrpCd(ByVal vntNewValue As Variant)

    mstrGrpCd = vntNewValue
    
End Property

Public Property Let ShowOnly(ByVal vntNewValue As Boolean)

    mblnShowOnly = vntNewValue
    
End Property


Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property


Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmGroup
    Dim objButton As CommandButton
    
    'グループテーブルメンテナンス画面をロード
    Set objForm = New frmGroup
    Set objButton = objForm.cmdInsert_Title
    
    With objForm
        .GrpCd = mstrGrpCd
        .GrpDiv = mintGrpDiv
        .ShowOnly = mblnShowOnly
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

Public Property Get GrpDiv() As Integer

    GrpDiv = mintGrpDiv

End Property

Public Property Let GrpDiv(ByVal vNewValue As Integer)

    mintGrpDiv = vNewValue

End Property

