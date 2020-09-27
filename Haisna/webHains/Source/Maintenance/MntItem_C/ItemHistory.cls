VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ItemHistory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Public UniqueKey        As String   '
Public ItemHNo          As String   '
Public strDate          As String   '
Public endDate          As String   '
Public Figure1          As String   '
Public Figure2          As String   '
Public MaxValue         As String   '
Public MinValue         As String   '
Public InsItemCd        As String   '
'Public KarteItemcd      As String   '
'Public KarteItemName    As String   '
'Public KarteItemAttr    As String   '
'Public KarteDocCd       As String   '
Public Unit             As String   '
Public DefResult        As String   '
Public DefRslCmtCd      As String   '
Public ReqItemCd        As String
Public SepOrderDiv      As String
'### 2004/1/15 Added by Ishihara@FSIT êπòHâ¡çÄñ⁄ÇÃí«â¡
Public InsSuffix        As String
Public eUnit            As String
'### 2004/1/15 Added End


