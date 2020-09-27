VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CommonGuide"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'固定値の情報
Public Enum ItemGuideConstants
    getSentence = 1
    getJudCmtStc = 2
    getZaimu = 3
    getZaimuOrg = 4
End Enum

'IN側プロパティ用
Private mblnMultiSelect     As Boolean  'リストビューの複数選択
Private mintTargetTable     As Integer  '読み込みテーブル種類

Private mstrItemCd          As String   '検査項目コード（文章ガイドで使用）
Private mstrItemType        As String   '項目タイプ（文章ガイドで使用）

'OUT側プロパティ用
Private mvntRecordCount     As Variant  '選択された項目数
Private mvntRecordCode      As Variant  '選択された項目コード
Private mvntRecordName      As Variant  '選択された項目名

Public Sub Show(Optional lngStyle As Long)

    Dim objForm As frmCommonGuide
    
    '項目ガイド画面をロード
    Set objForm = New frmCommonGuide
    With objForm
        .TargetTable = mintTargetTable
        .MultiSelect = mblnMultiSelect
        .ItemCd = mstrItemCd
        .ItemType = mstrItemType
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
            mvntRecordCount = .RecordCount
            mvntRecordCode = .RecordCode
            mvntRecordName = .RecordName
        End With
        
        Exit Do
    Loop
    
    Set objForm = Nothing
    
End Sub

Public Property Get RecordCount() As Variant

    RecordCount = mvntRecordCount
    
End Property

Public Property Get RecordName() As Variant

    RecordName = mvntRecordName
    
End Property

Public Property Get RecordCode() As Variant

    RecordCode = mvntRecordCode
    
End Property

Public Property Let TargetTable(ByVal vNewValue As Integer)

    mintTargetTable = vNewValue
    
End Property

Public Property Let MultiSelect(ByVal vNewValue As Boolean)

    mblnMultiSelect = vNewValue
    
End Property

Public Property Let ItemCd(ByVal vNewValue As String)

    mstrItemCd = vNewValue

End Property

Public Property Let ItemType(ByVal vNewValue As String)

    mstrItemType = vNewValue

End Property
