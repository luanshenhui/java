VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "OcrGrpI"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public UniqueKey        As String
Public Item             As String   '検査項目コード - サフィックス
Public Seq              As Variant
Public ItemCd           As Variant  '検査項目コード
Public Suffix           As Variant  'サフィックス


Public Index            As Variant  'Index
