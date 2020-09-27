VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ZaimuCsv"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public SysCd        As String
Public ZaimuYY      As String
Public ZaimuMMDD    As String
Public OrgCd        As String
Public OrgName      As String
Public TekiyouCd    As String
Public TekiyouName  As String
Public Price        As String
Public Kubun        As String
Public Shubetsu     As String
Public TaxPrice     As String
Public Tax          As String
Public CsCd         As String
Public Kanendo      As String

Public Syubetsu_NIP As String
Public Tekiyou_NIP  As String
Public Count_NIP    As String

