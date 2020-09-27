VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "StdValue_C_Record"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public StdValueMngCd   As String       '基準値管理コード
Public StdValueCd      As String       '基準値コード
Public Gender          As String       '性別
Public StrAge          As String       '開始年齢
Public EndAge          As String       '終了年齢
Public PriorSeq        As String       '適用優先順位番号
Public LowerValue      As String       '基準値（以上）
Public UpperValue      As String       '基準値（以下）
Public StdFlg          As String       '基準値フラグ
Public JudCd           As String       '判定コード
Public JudCmtCd        As String       '判定コメントコード
Public HealthPoint     As String       'ヘルスポイント
Public Sentence        As String       '文章

