VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SecurityPgm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mstrUserGrpCd         As String   '
Private mstrUserGrpName       As String   '
Private mstrSecurityGrpCd     As String   '
Private mstrSecurityGrpName   As String   '
Private iMode                 As Integer
Private mblnUpdated         As Boolean  'TRUE:更新あり、FALSE:更新なし

Public Property Let SetMode(ByVal vntNewValue As Variant)
    iMode = vntNewValue
End Property

Public Property Get Updated() As Boolean
    Updated = mblnUpdated
End Property

Public Property Let SetUserGrpCd(ByVal vntNewValue As Variant)
    mstrUserGrpCd = vntNewValue
End Property

Public Property Get SetUserGrpCd() As Variant
    SetUserGrpCd = mstrUserGrpCd
End Property

Public Property Let SetSecurityGrpCd(ByVal vntNewValue As Variant)
    mstrSecurityGrpCd = vntNewValue
End Property

Public Property Get SetSecurityGrpCd() As Variant
    SetSecurityGrpCd = mstrSecurityGrpCd
End Property

'''''''''''''''
Public Property Let SetUserGrpName(ByVal vntNewValue As Variant)
    mstrUserGrpName = vntNewValue
End Property

Public Property Get SetUserGrpName() As Variant
    SetUserGrpName = mstrUserGrpName
End Property

Public Property Let SetSecurityGrpName(ByVal vntNewValue As Variant)
    mstrSecurityGrpName = vntNewValue
End Property

Public Property Get SetSecurityGrpName() As Variant
    SetSecurityGrpName = mstrSecurityGrpName
End Property


Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmSecurityPgmGrp
    
    'セット分類テーブルメンテナンス画面をロード
    Set objForm = New frmSecurityPgmGrp
    
    With objForm
        .iMode = iMode                          '0:開く , 1:新規
        .mstrUserGrpCd = mstrUserGrpCd
        .mstrUserGrpName = mstrUserGrpName
        .mstrSecurityGrpCd = mstrSecurityGrpCd
        .mstrSecurityGrpName = mstrSecurityGrpName
        .iMode = iMode
    End With
    Load objForm
    
    Do
        '表示不能時は画面を閉じる
        If objForm.mblnInitialize = False Then
            Unload objForm
            Exit Do
        End If
        
        '画面表示
        objForm.Show lngStyle
'        mblnUpdated = objForm.Updated
        Exit Do
    Loop
    
    Set objForm = Nothing
    
End Sub

