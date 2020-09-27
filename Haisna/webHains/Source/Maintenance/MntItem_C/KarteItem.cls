VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "KarteItem"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public UniqueKey        As String   'キー
Public ItemHNo          As String   '検査項目履歴Ｎｏ
Public KarteDocCd       As String   '電カル用文書種別コード
Public KarteItemAttr    As String   '電カル用項目属性
Public KarteItemcd      As String   '電カル用項目コード
Public KarteItemName    As String   '電カル用項目名
Public KarteTagName     As String   '電カル用タグ名称

