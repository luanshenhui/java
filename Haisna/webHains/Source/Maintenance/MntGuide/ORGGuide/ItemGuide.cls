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

'固定値の情報
Public Enum ItemGuideConstants
    MODE_REQUEST = 1        '依頼モード
    MODE_RESULT = 2         '結果モード
    GROUP_OFF = 0           'グループ項目非表示
    GROUP_SHOW = 1          'グループ項目表示
    ITEM_OFF = 0            '検査項目非表示
    ITEM_SHOW = 1           '検査項目表示
    QUESTION_OFF = 0        '問診項目非表示
    QUESTION_SHOW = 1       '問診項目表示
End Enum

Private mintMode        As Integer  '依頼結果モード（1:依頼モード、2:結果モード）
Private mintGroup       As Integer  'グループ項目表示有無
Private mintItem        As Integer  '検査項目表示有無
'Private mintResultType  As Integer  '検査結果タイプ
Private mvntResultType  As Variant  '検査結果タイプ（配列あり）
Private mintQuestion    As Integer  '問診項目表示有無
Private mblnMultiSelect As Boolean  'リストビューの複数選択
Private mstrClassCd     As String   '検査分類コード

Private mvntItemCount   As Variant  '選択された項目数
Private mvntItemdiv     As Variant  '選択されたモード（G:グループ,I:検査項目）
Private mvntItemCd      As Variant  '選択された項目コード
Private mvntSuffix      As Variant  '選択されたサフィックス
Private mvntItemName    As Variant  '選択された項目名
Private mvntClassName   As Variant  '選択された検査分類名


Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmItemGuide
    
    '項目ガイド画面をロード
    Set objForm = New frmItemGuide
    With objForm
        .Mode = mintMode
        .Group = mintGroup
        .Item = mintItem
        .Question = mintQuestion
        .MultiSelect = mblnMultiSelect
'        .ResultType = mintResultType
        .ResultType = mvntResultType
        .ClassCd = mstrClassCd
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
            mvntItemdiv = .ItemDiv
            mvntItemCd = .ItemCd
            mvntSuffix = .Suffix
            mvntItemName = .ItemName
            mvntClassName = .ClassName
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

Public Property Get Group() As Integer
    
    Group = mintGroup

End Property

Public Property Let Group(ByVal vNewValue As Integer)

    mintGroup = vNewValue
    
End Property

Public Property Get Item() As Integer

    Item = mintItem
    
End Property

Public Property Let Item(ByVal vNewValue As Integer)

    mintItem = vNewValue

End Property

Public Property Get Question() As Integer

    Question = mintQuestion
    
End Property

Public Property Let Question(ByVal vNewValue As Integer)

    mintQuestion = vNewValue

End Property

Public Property Get ItemCount() As Variant

    ItemCount = mvntItemCount
    
End Property

Public Property Get ItemName() As Variant

    ItemName = mvntItemName
    
End Property

Public Property Get ItemCd() As Variant

    ItemCd = mvntItemCd
    
End Property

Public Property Get ClassName() As Variant

    ClassName = mvntClassName
    
End Property


Public Property Get Suffix() As Variant

    Suffix = mvntSuffix
    
End Property


Public Property Get ItemDiv() As Variant

    ItemDiv = mvntItemdiv
    
End Property

Private Sub Class_Initialize()

    'プロパティ値の初期化
    mblnMultiSelect = True
    mvntResultType = ""

End Sub

Public Property Let MultiSelect(ByVal vNewValue As Boolean)

    mblnMultiSelect = vNewValue
    
End Property

Public Property Let ResultType(ByVal vNewValue As Variant)

'    mintResultType = vNewValue
    mvntResultType = vNewValue

End Property

Public Property Let ClassCd(ByVal vNewValue As String)

    mstrClassCd = vNewValue

End Property
