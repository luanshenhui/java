VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ErrMessage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

' @(e)
'
' 機能　　 : エラーメッセージ再編集
'
' 引数　　 : (In)      strMsg  エラーメッセージ（基本的にはErr.Description)
'
' 機能説明 : エラーメッセージの内容から整合性エラー等を検出した場合、再度メッセージ編集
'
' 備考　　 :
'
Public Function GetHainsMsg(strMsg As String) As String

    Dim strLastMessage  As String
    
    GetHainsMsg = strMsg
    strLastMessage = strMsg
    
    '整合性エラー（子テーブルあり）の検出
    If InStr(strMsg, "ORA-02292") > 0 Then
        strLastMessage = "このデータを使用しているデータが存在します。削除できません。" & vbLf & vbLf
    End If
    
    GetHainsMsg = strLastMessage
    
End Function

