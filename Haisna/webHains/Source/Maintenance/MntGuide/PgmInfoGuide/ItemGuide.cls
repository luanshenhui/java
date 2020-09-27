VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ItemGuide"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Private mintMode            As Integer  '依頼結果モード（1:依頼モード、2:結果モード）
Private mblnMultiSelect     As Boolean  'リストビューの複数選択
Private mvntItemCount       As Variant  '選択された項目数
Private mvntItemCd          As Variant  '選択された項目コード
Private mvntItemName        As Variant  '選択された業務名
Private mvntItemFileName    As Variant  '選択されたプログラム名
Private mvntItemGrant       As Variant  '選択された
Private mvntGrantName       As Variant


Public Sub Show(Optional lngStyle As Long)
    Dim objForm As frmPgmInfoGuide
    
    '項目ガイド画面をロード
    Set objForm = New frmPgmInfoGuide
    With objForm
'        .Mode = mintMode
'        .Group = mintGroup
'        .Item = mintItem
'        .Question = mintQuestion
'        .MultiSelect = mblnMultiSelect
''        .ResultType = mintResultType
'        .ResultType = mvntResultType
'        .ClassCd = mstrClassCd
    End With
    
    Load objForm
    
    Do
        '表示不能時は画面を閉じる
        If objForm.Ret = False Then
            Unload objForm
            Exit Do
        End If
        
        With objForm
            '画面表示
            .Show lngStyle
            'プロパティ値を取得
            mvntItemCount = .ItemCount
            mvntItemCd = .ItemCd
            mvntItemName = .ItemName
            mvntItemFileName = .ItemFileName
            mvntItemGrant = .ItemGrant
            mvntGrantName = .GrantName
        End With
        
        Exit Do
    Loop
    
    Set objForm = Nothing
    
End Sub

Public Property Get Mode() As Integer
    Mode = mintMode
End Property

Public Property Let Mode(ByVal vNewValue As Integer)
    mintMode = vNewValue
End Property

Public Property Get ItemCount() As Variant
    ItemCount = mvntItemCount
End Property

Public Property Get ItemName() As Variant
    ItemName = mvntItemName
End Property

Public Property Get ItemFileName() As Variant
    ItemFileName = mvntItemFileName
End Property

Public Property Get ItemCd() As Variant
    ItemCd = mvntItemCd
End Property

Public Property Get ItemGrant() As Variant
    ItemGrant = mvntItemGrant
End Property

Public Property Get ItemGrantName() As Variant
    ItemGrantName = mvntGrantName
End Property

Private Sub Class_Initialize()
    'プロパティ値の初期化
    mblnMultiSelect = True
End Sub

Public Property Let MultiSelect(ByVal vNewValue As Boolean)
    mblnMultiSelect = vNewValue
End Property

