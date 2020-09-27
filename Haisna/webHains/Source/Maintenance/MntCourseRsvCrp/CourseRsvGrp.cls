VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CourseRsvGrp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'固定値の情報
Public Enum mntRsvFraConstants
    MODE_COURSE = 0     'コース予約枠モード
    MODE_ITEM = 1       '検査項目予約枠モード
End Enum

Private mstrRsvGrpCd     As Variant   '予約群コード
Private mstrCsCd         As Variant   'コースコード
'Private mintRsvFraDiv   As Integer  '予約枠区分
Private mblnUpdated      As Boolean  'TRUE:更新あり、FALSE:更新なし
Private mblnShowOnly     As Boolean  'TRUE:データの更新をしない（参照のみ）

Public Property Get RsvGrpCd() As Variant

    RsvGrpCd = mstrRsvGrpCd
    
End Property
Public Property Get CsCd() As Variant

    CsCd = mstrCsCd
    
End Property

Public Property Let RsvGrpCd(ByVal vntNewValue As Variant)

    mstrRsvGrpCd = vntNewValue
    
End Property

Public Property Let CsCd(ByVal vntNewValue As Variant)

    mstrCsCd = vntNewValue
    
End Property

Public Property Let ShowOnly(ByVal vntNewValue As Boolean)

    mblnShowOnly = vntNewValue
    
End Property


Public Property Get Updated() As Boolean

    Updated = mblnUpdated

End Property

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmCourseRsvGrp
    
    'コース受診予約群テーブルメンテナンス画面をロード
    Set objForm = New frmCourseRsvGrp
    
    With objForm
        .CsCd = mstrCsCd
        .RsvGrpCd = mstrRsvGrpCd
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

