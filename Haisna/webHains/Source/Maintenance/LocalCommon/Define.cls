VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Define"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'グループ内検査項目検索
Public Enum GRPDIV
    GRPDIV_R = 1            '依頼項目
    GRPDIV_I = 2            '検査結果
End Enum

Public Enum ITEM_ENABLED
    ITEM_NOTDISP = 0        '表示しない
    ITEM_DISP = 1           '表示する
End Enum

Public Enum RSLQUE
    RSLQUE_R = 0            '検査結果
    RSLQUE_Q = 1            '問診結果
End Enum

'結果タイプ定数
Public Enum RESULTTYPE
    RESULTTYPE_NUMERIC = 1                  '数値
    RESULTTYPE_TEISEI1 = 2                  '定性１
    RESULTTYPE_TEISEI2 = 3                  '定性２
    RESULTTYPE_SENTENCE = 4                 '文章
    RESULTTYPE_CALC = 5                     '計算
    RESULTTYPE_DATE = 6                     '日付タイプ
End Enum

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
        strLastMessage = strLastMessage & strMsg
    End If
    
    GetHainsMsg = strLastMessage
    
End Function

