VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Item_h"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public cboIndex         As Integer  '対応するコンボボックスのインデックス
Public ResultType       As Integer  '
Public ItemType         As Integer  '
Public ItemName         As String   '
Public ItemSName        As String   '
Public ItemRName        As String   '
Public SearchChar       As String   '
Public StcItemCd        As String   '
Public RecentCount      As Integer  '
Public ItemEName        As String   '
Public ItemQName        As String   '
Public CollectCd        As String   '
Public ContractCd       As String   '
Public ContractItemCd   As String   '
Public OldItemCd        As String   '

