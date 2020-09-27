Attribute VB_Name = "Item_cBas"
Option Explicit


'
' 機能　　 : 検査用項目コードの存在チェック
'
' 引数　　 : (In)   strItemCd       検査項目コード
' 　　　　 : (In)   strSuffix       サフィックス
' 　　　　 : (In)   strInsItemCd    検査連携用項目コード
' 　　　　 : (In)   vntSepOrderDiv  オーダ分割区分
'
' 戻り値　 : TRUE:正常終了、FALSE:異常終了
'
' 備考　　 :
'
Public Function GetInsItemInfo(strItemCd As String, _
                               strSuffix As String, _
                               strInsItemCd As String, _
                               Optional vntSepOrderDiv As Variant _
                               ) As Boolean

    Dim objItem         As Object           '検査項目アクセス用
    
    Dim strMsg          As String
    Dim vntItemCd       As Variant          '検査項目名
    Dim vntSuffix       As Variant          '検査項目名
    Dim vntItemName     As Variant          '検査項目名
    Dim lngCount        As Long             '存在件数
    
    On Error GoTo ErrorHandle
    
    GetInsItemInfo = False
    
    'オブジェクトのインスタンス作成
    Set objItem = CreateObject("HainsItem.Item")
    
    '検査用項目コードが指定されていないなら正常終了
    If Trim(strInsItemCd) = "" Then
        GetInsItemInfo = True
        Exit Function
    End If
        
    '検査項目テーブルレコード読み込み
'### 2004/1/15 Modified by Ishihara@FSIT 聖路加ではvntSepOrderDivはないため、不要。
'    If IsMissing(vntSepOrderDiv) Then
'
'        lngCount = objItem.SelectInsItemInfo(strItemCd, _
'                                             strSuffix, _
'                                             strInsItemCd, _
'                                             vntItemCd, _
'                                             vntSuffix, _
'                                             vntItemName)
'
'    Else
'
'        lngCount = objItem.SelectInsItemInfo(strItemCd, _
'                                             strSuffix, _
'                                             strInsItemCd, _
'                                             vntItemCd, _
'                                             vntSuffix, _
'                                             vntItemName, _
'                                             vntSepOrderDiv)
'
'    End If
    lngCount = 0
'### 2004/1/15 Modified End
            
    'レコードが存在するなら
    If lngCount >= 1 Then
        strMsg = "入力された検査項目コードは既に使用されています。" & vbLf & vbLf & _
                "（" & vntItemCd & "-" & vntSuffix & ":" & vntItemName & "　にて使用中）"
                
        MsgBox strMsg, vbExclamation, App.Title
        Exit Function
                
    End If
    
    If lngCount < 0 Then Exit Function
    
    '戻り値の設定
    GetInsItemInfo = True
    
    Exit Function

ErrorHandle:

    GetInsItemInfo = False
    
    MsgBox Err.Description, vbCritical
    
End Function


