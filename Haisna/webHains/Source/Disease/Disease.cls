VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Disease"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'########################################
'管理番号：SL-HS-Y0101-002
'修正日  ：2010.08.30
'担当者  ：FJTH)KOMURO
'作成内容：オラクルセッション対応
'########################################
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession      As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 病名テーブルレコードを削除する
'
' 引数　　 : (In)    strDisCd    病名コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteDisease(ByVal strDisCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DISCD", Trim(strDisCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '病名テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE DISEASE WHERE DISCD = :DISCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteDisease = True

    Exit Function
    
ErrorHandle:

    DeleteDisease = False

    'イベントログ書き込み
    WriteErrorLog "Disease.DeleteDisease"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 病名テーブルレコードを登録する
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strDisCd       病名コード
' 　　　　   (In)    vntDisName     病名名
' 　　　　   (In)    strSearchChar  ガイド検索用文字列
' 　　　　   (In)    strDisDivCd    病類コード
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistDisease(ByVal strMode As String, _
                              ByVal strDisCd As String, _
                              ByVal strDisName As String, _
                              ByVal strSearchChar As String, _
                              ByVal strDisDivCd As String) As Long
                              

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DISCD", Trim(strDisCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISNAME", Trim(strDisName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SEARCHCHAR", Trim(strSearchChar), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISDIVCD", Trim(strDisDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '病名テーブルレコードの更新
        If strMode = "UPD" Then
            Ret = mobjOraDb.ExecuteSQL("UPDATE DISEASE SET DISNAME = :DISNAME, SEARCHCHAR = :SEARCHCHAR, DISDIVCD = :DISDIVCD WHERE DISCD = :DISCD")
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす病名テーブルのレコードを取得
        strStmt = "SELECT DISNAME FROM DISEASE WHERE DISCD = :DISCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO DISEASE (DISCD, DISNAME, SEARCHCHAR, DISDIVCD) VALUES (:DISCD, :DISNAME, :SEARCHCHAR, :DISDIVCD)"
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistDisease = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistDisease = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Disease.RegistDisease"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 病名コードに対する病名名を取得する
'
' 引数　　 : (In)     strDisCd          病名コード
' 　　　　   (Out)    vntDisName        病名名
' 　　　　   (Out)    vntSearchChar     ガイド検索用文字列
' 　　　　   (Out)    vntDisDivCd       病類コード
' 　　　　   (Out)    vntDisDivName     病類名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectDisease(ByVal strDisCd As String, _
                              ByRef vntDisName As Variant, _
                              Optional ByRef vntSearchChar As Variant, _
                              Optional ByRef vntDisDivCd As Variant, _
                              Optional ByRef vntDisDivName As Variant) As Long
                              
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objDisName      As OraField         '病名名
    Dim objSearchChar   As OraField         'ガイド検索用文字列
    Dim objDisDivCd     As OraField         '病類コード
    Dim objDisDivName   As OraField         '病類名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DISCD", Trim(strDisCd), ORAPARM_INPUT
    
    '検索条件を満たす病名テーブルのレコードを取得
    strStmt = "SELECT DISEASE.DISNAME, DISEASE.SEARCHCHAR, DISEASE.DISDIVCD, DISDIV.DISDIVNAME" & _
              "  FROM DISDIV, DISEASE " & _
              " WHERE DISEASE.DISCD = :DISCD AND DISEASE.DISDIVCD = DISDIV.DISDIVCD(+)"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDisName = objFields("DISNAME")
        Set objSearchChar = objFields("SEARCHCHAR")
        Set objDisDivCd = objFields("DISDIVCD")
        Set objDisDivName = objFields("DISDIVNAME")
    
        '戻り値の設定
        vntDisName = objDisName.Value
        
        If IsMissing(vntSearchChar) = False Then vntSearchChar = objSearchChar.Value & ""
        If IsMissing(vntDisDivCd) = False Then vntDisDivCd = objDisDivCd.Value & ""
        If IsMissing(vntDisDivName) = False Then vntDisDivName = objDisDivName.Value & ""
        
        SelectDisease = True
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Disease.SelectDisease"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 病名の一覧を取得する
'
' 引数　　 : (Out)    vntDisCd      病名コード
' 　　　　   (Out)    vntDisName    病名名
' 　　　　   (Out)    vntDisDivName 病類名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectDiseaseItemList(ByRef vntDisCd As Variant, _
                                      ByRef vntDisName As Variant, _
                                      Optional ByRef vntDisDivName As Variant) As Long

    Dim objOraDyna          As OraDynaset   'ダイナセット
    Dim strStmt             As String       'SQLステートメント
    
    Dim objFields           As OraFields    'フィールドオブジェクト
    Dim objDisCd            As OraField     '病名コード
    Dim objDisName          As OraField     '病名名
    Dim objDisDivName       As OraField     '病類名
    
    Dim vntArrDisCd()       As Variant      '病名コードの配列
    Dim vntArrDisName()     As Variant      '病名名の配列
    Dim vntArrDisDivName()  As Variant      '病名名の配列
    Dim lngCount            As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntDisCd = Empty
    vntDisName = Empty
    lngCount = 0
    
    '病名テーブルの全レコードを取得
    strStmt = "SELECT DISEASE.DISCD, DISEASE.DISNAME, DISEASE.SEARCHCHAR, DISEASE.DISDIVCD, DISDIV.DISDIVNAME" & _
              "  FROM DISDIV, DISEASE " & _
              " WHERE DISEASE.DISDIVCD = DISDIV.DISDIVCD(+)" & _
              " ORDER BY DISEASE.DISCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDisCd = objFields("DISCD")
        Set objDisName = objFields("DISNAME")
        Set objDisDivName = objFields("DISDIVNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrDisCd(lngCount)
            ReDim Preserve vntArrDisName(lngCount)
            ReDim Preserve vntArrDisDivName(lngCount)
            vntArrDisCd(lngCount) = objDisCd.Value
            vntArrDisName(lngCount) = objDisName.Value
            vntArrDisDivName(lngCount) = objDisDivName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntDisCd = vntArrDisCd
        vntDisName = vntArrDisName
    
        If IsMissing(vntDisDivName) = False Then vntDisDivName = vntArrDisDivName
        
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectDiseaseItemList = lngCount
        
    Exit Function
    
ErrorHandle:

    SelectDiseaseItemList = -1
    
    'イベントログ書き込み
    WriteErrorLog "Disease.SelectDiseaseItemList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 病類テーブルレコードを削除する
'
' 引数　　 : (In)    strDisDivCd    病類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteDisDiv(ByVal strDisDivCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DISDIVCD", Trim(strDisDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '病類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE DISDIV WHERE DISDIVCD = :DISDIVCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteDisDiv = True

    Exit Function
    
ErrorHandle:

    DeleteDisDiv = False

    'イベントログ書き込み
    WriteErrorLog "Disease.DeleteDisDiv"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 病類テーブルレコードを登録する
'
' 引数　　 : (In)    strMode      登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strDisDivCd    病類コード
' 　　　　   (In)    vntDisDivName  病類名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistDisDiv(ByVal strMode As String, ByVal strDisDivCd As String, ByVal strDisDivName As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DISDIVCD", Trim(strDisDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISDIVNAME", Trim(strDisDivName), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '病類テーブルレコードの更新
        If strMode = "UPD" Then
            Ret = mobjOraDb.ExecuteSQL("UPDATE DISDIV SET DISDIVNAME = :DISDIVNAME WHERE DISDIVCD = :DISDIVCD")
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす病類テーブルのレコードを取得
        strStmt = "SELECT DISDIVNAME FROM DISDIV WHERE DISDIVCD = :DISDIVCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO DISDIV (DISDIVCD, DISDIVNAME) VALUES (:DISDIVCD, :DISDIVNAME)"
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistDisDiv = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistDisDiv = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Disease.RegistDisDiv"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 病類コードに対する病類名を取得する
'
' 引数　　 : (In)     strDisDivCd    病類コード
' 　　　　   (Out)    vntDisDivName  病類名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectDisDiv(ByVal strDisDivCd As String, ByRef vntDisDivName As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objDisDivName As OraField         '病類名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DISDIVCD", Trim(strDisDivCd), ORAPARM_INPUT
    
    '検索条件を満たす病類テーブルのレコードを取得
    strStmt = "SELECT DISDIVNAME FROM DISDIV WHERE DISDIVCD = :DISDIVCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDisDivName = objFields("DISDIVNAME")
    
        '戻り値の設定
        vntDisDivName = objDisDivName.Value
        
        SelectDisDiv = True
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Disease.SelectDisDiv"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 病類の一覧を取得する
'
' 引数　　 : (Out)    vntDisDivCd    病類コード
' 　　　　   (Out)    vntDisDivName  病類名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectDisDivList(ByRef vntDisDivCd As Variant, ByRef vntDisDivName As Variant) As Long

    Dim objOraDyna          As OraDynaset   'ダイナセット
    Dim strStmt             As String       'SQLステートメント
    
    Dim objFields           As OraFields    'フィールドオブジェクト
    Dim objDisDivCd           As OraField     '病類コード
    Dim objDisDivName         As OraField     '病類名
    
    Dim vntArrDisDivCd()      As Variant      '病類コードの配列
    Dim vntArrDisDivName()    As Variant      '病類名の配列
    Dim lngCount            As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntDisDivCd = Empty
    vntDisDivName = Empty
    lngCount = 0
    
    '病類テーブルの全レコードを取得
    strStmt = "SELECT DISDIVCD, DISDIVNAME " & vbLf & _
              "  FROM DISDIV             " & vbLf & _
              " ORDER BY DISDIVCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDisDivCd = objFields("DISDIVCD")
        Set objDisDivName = objFields("DISDIVNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrDisDivCd(lngCount)
            ReDim Preserve vntArrDisDivName(lngCount)
            vntArrDisDivCd(lngCount) = objDisDivCd.Value
            vntArrDisDivName(lngCount) = objDisDivName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntDisDivCd = vntArrDisDivCd
        vntDisDivName = vntArrDisDivName
    
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectDisDivList = lngCount
        
    Exit Function
    
ErrorHandle:

    SelectDisDivList = -1
    
    'イベントログ書き込み
    WriteErrorLog "Disease.SelectDisDivList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 既往歴家族歴テーブルにレコードを挿入する
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (In)     strRelation           続柄
' 　　　　 : (In)     strDisCd              病名コード
' 　　　　 : (In)     strStrDate            発病年月
' 　　　　 : (In)     strEndDate            治癒年月
' 　　　　 : (In)     strCondition          状態
' 　　　　 : (In)     strMedical            医療機関
'
' 戻り値　 : INSERT_NORMAL      正常終了
' 　　　　 : INSERT_DUPLICATE   同一キーのレコード存在
' 　　　　 : ALERT_FKEY2        病名コード整合性違反
' 　　　　 : INSERT_ERROR       異常終了
'
' 備考　　 :
'
Public Function InsertDisHistory(ByVal strPerID As String, _
                                 ByVal strRelation As String, _
                                 ByVal strDisCd As String, _
                                 ByVal strStrDate As Variant, _
                                 ByVal strEndDate As Variant, _
                                 ByVal strCondition As String, _
                                 ByVal strMedical As String _
                                ) As Long
                         
    Dim objCommon               As Common           '共通クラス
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RELATION", Trim(strRelation), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISCD", Trim(strDisCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", strStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", IIf(strEndDate = "", Null, strEndDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CONDITION", IIf(Trim(strCondition) = "", Null, Trim(strCondition)), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MEDICAL", IIf(Trim(strMedical) = "", Null, Trim(strMedical)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '既往歴家族歴テーブルレコードの挿入
    strStmt = "INSERT INTO DISHISTORY ( " & vbLf & _
              "       PERID,            " & vbLf & _
              "       RELATION,         " & vbLf & _
              "       DISCD,            " & vbLf & _
              "       STRDATE,          " & vbLf & _
              "       ENDDATE,          " & vbLf & _
              "       CONDITION,        " & vbLf & _
              "       MEDICAL           "
    strStmt = strStmt & vbLf & _
              "       ) VALUES (        " & vbLf & _
              "       :PERID,           " & vbLf & _
              "       :RELATION,        " & vbLf & _
              "       :DISCD,           " & vbLf & _
              "       :STRDATE,         " & vbLf & _
              "       :ENDDATE,         " & vbLf & _
              "       :CONDITION,       " & vbLf & _
              "       :MEDICAL          " & vbLf & _
              "       )"
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の設定
    InsertDisHistory = INSERT_NORMAL

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'キー重複、整合性違反時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        InsertDisHistory = INSERT_DUPLICATE
        Exit Function
    ElseIf mobjOraDb.LastServerErr = 2291 Then
        InsertDisHistory = objCommon.CheckFkeyErr(mobjOraDb.LastServerErrText)
        Exit Function
    End If
        
    InsertDisHistory = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Disease.InsertDisHistory"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : キー情報をもとに既往歴家族歴テーブルを更新する
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (In)     strRelation           続柄
' 　　　　 : (In)     strDisCd              病名コード
' 　　　　 : (In)     strStrDate            発病年月
' 　　　　 : (In)     strEndDate            治癒年月
' 　　　　 : (In)     strCondition          状態
' 　　　　 : (In)     strMedical            医療機関
'
' 戻り値　 : UPDATE_NORMAL      正常終了
' 　　　　 : UPDATE_NOTFOUND    更新レコードなし
' 　　　　 : ALERT_FKEY2        病名コード整合性違反
' 　　　　 : UPDATE_ERROR       異常終了
'
' 備考　　 :
'
Public Function UpdateDisHistory(ByVal strPerID As String, _
                                 ByVal strRelation As String, _
                                 ByVal strDisCd As String, _
                                 ByVal strStrDate As Variant, _
                                 ByVal strEndDate As Variant, _
                                 ByVal strCondition As String, _
                                 ByVal strMedical As String _
                                ) As Long
 
    Dim objCommon               As Common           '共通クラス
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    Dim lngRet                  As Long             '戻り値
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RELATION", Trim(strRelation), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISCD", Trim(strDisCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", strStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", IIf(strEndDate = "", Null, strEndDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CONDITION", IIf(Trim(strCondition) = "", Null, Trim(strCondition)), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MEDICAL", IIf(Trim(strMedical) = "", Null, Trim(strMedical)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '既往歴家族歴テーブルレコードの更新
    strStmt = "UPDATE DISHISTORY                            " & vbLf & _
              "   SET ENDDATE           = :ENDDATE,         " & vbLf & _
              "       CONDITION         = :CONDITION,       " & vbLf & _
              "       MEDICAL           = :MEDICAL,         " & vbLf & _
              "       UPDDATE           = SYSDATE           "
    
    strStmt = strStmt & vbLf & _
              " WHERE PERID             = :PERID            " & vbLf & _
              "   AND RELATION          = :RELATION         " & vbLf & _
              "   AND DISCD             = :DISCD            " & vbLf & _
              "   AND STRDATE           = :STRDATE          "

    lngRet = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))

    '戻り値の設定
    UpdateDisHistory = IIf(lngRet > 0, UPDATE_NORMAL, UPDATE_NOTFOUND)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '整合性違反時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 2291 Then
        UpdateDisHistory = objCommon.CheckFkeyErr(mobjOraDb.LastServerErrText)
        Exit Function
    End If
    
    UpdateDisHistory = UPDATE_ERROR

    'イベントログ書き込み
    WriteErrorLog "Disease.UpdateDisHistory"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 既往歴家族歴各値の妥当性チェックを行う
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (In)     strRelation           続柄
' 　　　　 : (In)     strDisCd              病名コード
' 　　　　 : (In)     lngStrYear            発病年
' 　　　　 : (In)     lngStrMonth           発病月
' 　　　　 : (In)     lngEndYear            治癒年
' 　　　　 : (In)     lngEndMonth           治癒月
' 　　　　 : (In)     strCondition          状態
' 　　　　 : (In)     strMedical            医療機関
' 　　　　 : (Out)    vntStrDate            発病年月
' 　　　　 : (Out)    vntEndDate            治癒年月
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValue(ByVal strPerID As String, _
                           ByVal strRelation As String, _
                           ByVal strDisCd As String, _
                           ByVal lngStrYear As Long, _
                           ByVal lngStrMonth As Long, _
                           ByVal lngEndYear As Long, _
                           ByVal lngEndMonth As Long, _
                           ByVal strCondition As String, _
                           ByVal strMedical As String, _
                           ByRef vntStrDate As Variant, _
                           ByRef vntEndDate As Variant _
                          ) As Variant
                         
    Dim objCommon       As Common   '共通クラス
    
    Dim vntArrMessage   As Variant  'エラーメッセージの集合
    Dim strMessage      As String   'エラーメッセージ
    Dim i               As Long     'インデックス
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    '初期処理
    vntStrDate = ""
    vntEndDate = ""

    '各値チェック処理
    With objCommon
    
        '続柄
        If strRelation = "" Then
            .AppendArray vntArrMessage, "続柄を入力して下さい。"
        End If
        
        '病名コード
        If strRelation = "0" Then
            .AppendArray vntArrMessage, .CheckAlphabetAndNumeric("既往症", Trim(strDisCd), LENGTH_DISEASE_DISCD, CHECK_NECESSARY)
        Else
            .AppendArray vntArrMessage, .CheckAlphabetAndNumeric("病名", Trim(strDisCd), LENGTH_DISEASE_DISCD, CHECK_NECESSARY)
        End If
        
        '発病年月
        .AppendArray vntArrMessage, .CheckDate("発病年月", lngStrYear, lngStrMonth, 1, vntStrDate)
        
        '治癒年月
        If lngEndYear <> 0 Or lngEndMonth <> 0 Then
            .AppendArray vntArrMessage, .CheckDate("治癒年月", lngEndYear, lngEndMonth, 1, vntEndDate)
        End If
    
    End With
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If
    
End Function

'
' 機能　　 : 既往歴家族歴テーブルレコードを削除する
'
' 引数　　 : (In)     strPerID          個人ＩＤ
' 　　　　 : (In)     strRelation       続柄
' 　　　　 : (In)     strDisCd          病名コード
' 　　　　 : (In)     strStrDate        発病年月
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteDisHistory(ByVal strPerID As String, _
                                 ByVal strRelation As String, _
                                 ByVal strDisCd As String, _
                                 ByVal strStrDate As Variant _
                                ) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strPerID) = "" Or _
       Not IsNumeric(strRelation) Or _
       Trim(strDisCd) = "" Or _
       Not IsDate(strStrDate) Then
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RELATION", Trim(strRelation), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISCD", Trim(strDisCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", strStrDate, ORAPARM_INPUT, ORATYPE_DATE

    '既往歴家族歴テーブルレコードの削除
    strStmt = "DELETE DISHISTORY                            " & vbLf & _
              " WHERE PERID     = :PERID                    " & vbLf & _
              "   AND RELATION  = :RELATION                 " & vbLf & _
              "   AND DISCD     = :DISCD                    " & vbLf & _
              "   AND STRDATE   = :STRDATE                  "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Disease.DeleteDisHistory"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : キー情報をもとに既往歴家族歴テーブルを読み込む
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (In)     strRelation           続柄
' 　　　　 : (In)     strDisCd              病名コード
' 　　　　 : (In)     strStrDate            発病年月
' 　　　　 : (Out)    vntEndYear            治癒年
' 　　　　 : (Out)    vntEndMonth           治癒月
' 　　　　 : (Out)    vntCondition          状態
' 　　　　 : (Out)    vntMedical            医療機関
' 　　　　 : (Out)    vntDisName            病名
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectDisHistory(ByVal strPerID As String, _
                                 ByVal strRelation As String, _
                                 ByVal strDisCd As String, _
                                 ByVal strStrDate As Variant, _
                                 ByRef vntEndYear As Variant, _
                                 ByRef vntEndMonth As Variant, _
                                 ByRef vntCondition As Variant, _
                                 ByRef vntMedical As Variant, _
                                 ByRef vntDisName As Variant _
                                ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim vntEndDate              As Variant          '治癒年月（編集用）
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objEndDate              As OraField         '治癒年月
    Dim objCondition            As OraField         '状態
    Dim objMedical              As OraField         '医療機関
    Dim objDisName              As OraField         '病名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntEndYear = Empty
    vntEndMonth = Empty
    vntCondition = Empty
    vntMedical = Empty
    vntDisName = Empty
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strPerID) = "" Or _
       Not IsNumeric(strRelation) Or _
       Trim(strDisCd) = "" Or _
       Not IsDate(strStrDate) Then
        Exit Function
    End If
        
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RELATION", Trim(strRelation), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISCD", Trim(strDisCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", strStrDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '検索条件を満たす既往歴家族歴テーブルのレコードを取得
    strStmt = "SELECT DH.ENDDATE ENDDATE,     DH.CONDITION CONDITION,     DH.MEDICAL MEDICAL,     D.DISNAME DISNAME " & vbLf & _
              "  FROM DISHISTORY DH, DISEASE D "

    strStmt = strStmt & vbLf & _
              " WHERE DH.PERID     = :PERID                            " & vbLf & _
              "   AND DH.RELATION  = :RELATION                         " & vbLf & _
              "   AND DH.DISCD     = :DISCD                            " & vbLf & _
              "   AND DH.STRDATE   = :STRDATE                          " & vbLf & _
              "   AND DH.DISCD     = D.DISCD                           "
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objEndDate = objFields("ENDDATE")
        Set objCondition = objFields("CONDITION")
        Set objMedical = objFields("MEDICAL")
        Set objDisName = objFields("DISNAME")
        
        '戻り値の設定
        vntEndDate = objEndDate.Value & ""
        If vntEndDate = "" Then
            vntEndYear = 0
            vntEndMonth = 0
        Else
            vntEndYear = Year(vntEndDate)
            vntEndMonth = Month(vntEndDate)
        End If
        vntCondition = objCondition.Value & ""
        vntMedical = objMedical.Value & ""
        vntDisName = objDisName.Value & ""
        
        SelectDisHistory = True
        
    End If

    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Disease.SelectDisHistory"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 個人ＩＤをもとに個人テーブルを読み込む
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (Out)    vntLastName           姓
' 　　　　 : (Out)    vntFirstName          名
' 　　　　 : (Out)    vntLastKName          カナ姓
' 　　　　 : (Out)    vntFirstKName         カナ名
' 　　　　 : (Out)    vntBirth              生年月日
' 　　　　 : (Out)    vntGenderName         性別名
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPerson(ByVal strPerID As String, _
                             ByRef vntLastName As Variant, _
                             ByRef vntFirstName As Variant, _
                             ByRef vntLastKName As Variant, _
                             ByRef vntFirstKName As Variant, _
                             ByRef vntBirth As Variant, _
                             ByRef vntGenderName As Variant _
                            ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objLastName             As OraField         '姓
    Dim objFirstName            As OraField         '名
    Dim objLastKName            As OraField         'カナ姓
    Dim objFirstKName           As OraField         'カナ名
    Dim objBirth                As OraField         '生年月日
    Dim objGenderName           As OraField         '性別名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntLastName = Empty
    vntFirstName = Empty
    vntLastKName = Empty
    vntFirstKName = Empty
    vntBirth = Empty
    vntGenderName = Empty
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strPerID) = "" Then
        Exit Function
    End If
        
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす個人テーブルのレコードを取得
    strStmt = "SELECT LASTNAME,      FIRSTNAME,      LASTKNAME,     FIRSTKNAME,          BIRTH, " & vbLf & _
              "       DECODE(GENDER, '1', '男性', '2', '女性', NULL) GENDERNAME " & vbLf & _
              "  FROM PERSON    "

    strStmt = strStmt & vbLf & _
              " WHERE PERID  = :PERID                            " & vbLf & _
              "   AND DELFLG = " & CStr(DELFLG_USED)
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objGenderName = objFields("GENDERNAME")
        
        '戻り値の設定
        vntLastName = objLastName.Value & ""
        vntFirstName = objFirstName.Value & ""
        vntLastKName = objLastKName.Value & ""
        vntFirstKName = objFirstKName.Value & ""
        vntBirth = objBirth.Value & ""
        vntGenderName = objGenderName.Value & ""
        
        SelectPerson = True
        
    End If

    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Disease.SelectPerson"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 該当個人の既往歴のレコード件数を取得する
'
' 引数　　 : (In)   strPerID        個人ＩＤ
'
' 戻り値　 : 該当個人の既往歴のレコード件数
'
' 備考　　 :
'
Public Function SelectDiseaseListCount(ByVal strPerID As String) As Long

    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCount        As OraField         '検索件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '個人ＩＤが設定されていない場合は処理を終了する
    If Trim(strPerID) = "" Then
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '該当個人の既往歴のレコード件数を取得
    strStmt = "SELECT COUNT(*) " & vbLf & _
              "  FROM DISHISTORY   "

    '条件節を追加
    strStmt = strStmt & vbLf & " WHERE PERID    = :PERID       "
    strStmt = strStmt & vbLf & "   AND RELATION = 0            "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合は件数を戻り値として設定
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        SelectDiseaseListCount = objOraDyna.Fields(0).Value
    End If
    
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Disease.SelectDiseaseListCount"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 該当個人の家族歴のレコード件数を取得する
'
' 引数　　 : (In)   strPerID        個人ＩＤ
'
' 戻り値　 : 該当個人の家族歴のレコード件数
'
' 備考　　 :
'
Public Function SelectFamilyListCount(ByVal strPerID As String) As Long

    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCount        As OraField         '検索件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '個人ＩＤが設定されていない場合は処理を終了する
    If Trim(strPerID) = "" Then
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '該当個人の家族歴のレコード件数を取得
    strStmt = "SELECT COUNT(*) " & vbLf & _
              "  FROM DISHISTORY   "

    '条件節を追加
    strStmt = strStmt & vbLf & " WHERE PERID    =  :PERID       "
    strStmt = strStmt & vbLf & "   AND RELATION != 0            "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合は件数を戻り値として設定
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        SelectFamilyListCount = objOraDyna.Fields(0).Value
    End If
    
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Disease.SelectFamilyListCount"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 条件を満たす個人の既往歴一覧を取得する
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (Out)    vntStrDate            発病年月
' 　　　　 : (Out)    vntDisCd              病名コード
' 　　　　 : (Out)    vntDisName            病名
' 　　　　 : (Out)    vntMedical            医療機関
' 　　　　 : (Out)    vntEndDate            治癒年月
' 　　　　 : (Out)    vntCondition          状態
'
' 戻り値　 : 条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectDiseaseList(ByVal strPerID As String, _
                                  ByRef vntStrDate As Variant, _
                                  ByRef vntDisCd As Variant, _
                                  ByRef vntDisName As Variant, _
                                  ByRef vntMedical As Variant, _
                                  ByRef vntEndDate As Variant, _
                                  ByRef vntCondition As Variant _
                                 ) As Long

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objStrDate          As OraField         '発病年月
    Dim objDisCd            As OraField         '病名コード
    Dim objDisName          As OraField         '病名
    Dim objMedical          As OraField         '医療機関
    Dim objEndDate          As OraField         '治癒年月
    Dim objCondition        As OraField         '状態
    
    Dim vntArrStrDate       As Variant          '発病年月の配列
    Dim vntArrDisCd         As Variant          '病名コードの配列
    Dim vntArrDisName       As Variant          '病名の配列
    Dim vntArrMedical       As Variant          '医療機関の配列
    Dim vntArrEndDate       As Variant          '治癒年月の配列
    Dim vntArrCondition     As Variant          '状態の配列
    Dim lngCount            As Long             'レコード数
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStrDate = Empty
    vntDisCd = Empty
    vntDisName = Empty
    vntMedical = Empty
    vntEndDate = Empty
    vntCondition = Empty
    
    '個人ＩＤが設定されていない場合は処理を終了する
    If Trim(strPerID) = "" Then
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '条件を満たす既往歴家族歴テーブルのレコードを取得
    strStmt = "SELECT DH.DISCD DISCD, DH.STRDATE STRDATE, DH.ENDDATE ENDDATE, DH.CONDITION CONDITION, DH.MEDICAL MEDICAL, D.DISNAME DISNAME " & vbLf & _
              "  FROM DISHISTORY DH, DISEASE D "
              
    strStmt = strStmt & vbLf & " WHERE DH.PERID    = :PERID       "
    strStmt = strStmt & vbLf & "   AND DH.RELATION = 0            "
    strStmt = strStmt & vbLf & "   AND DH.DISCD = D.DISCD"
    
    strStmt = strStmt & vbLf & " ORDER BY DH.STRDATE DESC, DH.ENDDATE DESC"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStrDate = objFields("STRDATE")
        Set objDisCd = objFields("DISCD")
        Set objDisName = objFields("DISNAME")
        Set objMedical = objFields("MEDICAL")
        Set objEndDate = objFields("ENDDATE")
        Set objCondition = objFields("CONDITION")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            '発病年月
            If IsArray(vntArrStrDate) Then
                i = UBound(vntArrStrDate) + 1
                ReDim Preserve vntArrStrDate(i)
                vntArrStrDate(i) = Trim(objStrDate.Value & "")
            Else
                vntArrStrDate = Array(Trim(objStrDate.Value & ""))
            End If
            '病名コード
            If IsArray(vntArrDisCd) Then
                i = UBound(vntArrDisCd) + 1
                ReDim Preserve vntArrDisCd(i)
                vntArrDisCd(i) = Trim(objDisCd.Value & "")
            Else
                vntArrDisCd = Array(Trim(objDisCd.Value & ""))
            End If
            '病名
            If IsArray(vntArrDisName) Then
                i = UBound(vntArrDisName) + 1
                ReDim Preserve vntArrDisName(i)
                vntArrDisName(i) = Trim(objDisName.Value & "")
            Else
                vntArrDisName = Array(Trim(objDisName.Value & ""))
            End If
            '医療機関
            If IsArray(vntArrMedical) Then
                i = UBound(vntArrMedical) + 1
                ReDim Preserve vntArrMedical(i)
                vntArrMedical(i) = Trim(objMedical.Value & "")
            Else
                vntArrMedical = Array(Trim(objMedical.Value & ""))
            End If
            '治癒年月
            If IsArray(vntArrEndDate) Then
                i = UBound(vntArrEndDate) + 1
                ReDim Preserve vntArrEndDate(i)
                vntArrEndDate(i) = Trim(objEndDate.Value & "")
            Else
                vntArrEndDate = Array(Trim(objEndDate.Value & ""))
            End If
            '状態
            If IsArray(vntArrCondition) Then
                i = UBound(vntArrCondition) + 1
                ReDim Preserve vntArrCondition(i)
                vntArrCondition(i) = Trim(objCondition.Value & "")
            Else
                vntArrCondition = Array(Trim(objCondition.Value & ""))
            End If
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntStrDate = vntArrStrDate
    vntDisCd = vntArrDisCd
    vntDisName = vntArrDisName
    vntMedical = vntArrMedical
    vntEndDate = vntArrEndDate
    vntCondition = vntArrCondition
    SelectDiseaseList = lngCount
        
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Disease.SelectDiseaseList"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 条件を満たす個人の家族歴一覧を取得する
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (Out)    vntRelation           続柄
' 　　　　 : (Out)    vntDisCd              病名コード
' 　　　　 : (Out)    vntDisName            病名
' 　　　　 : (Out)    vntStrDate            発病年月
' 　　　　 : (Out)    vntEndDate            治癒年月
' 　　　　 : (Out)    vntCondition          状態
'
' 戻り値　 : 条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectFamilyList(ByVal strPerID As String, _
                                 ByRef vntRelation As Variant, _
                                 ByRef vntDisCd As Variant, _
                                 ByRef vntDisName As Variant, _
                                 ByRef vntStrDate As Variant, _
                                 ByRef vntEndDate As Variant, _
                                 ByRef vntCondition As Variant _
                                ) As Long

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRelation         As OraField         '続柄
    Dim objDisCd            As OraField         '病名コード
    Dim objDisName          As OraField         '病名
    Dim objStrDate          As OraField         '発病年月
    Dim objEndDate          As OraField         '治癒年月
    Dim objCondition        As OraField         '状態
    
    Dim vntArrRelation      As Variant          '続柄の配列
    Dim vntArrDisCd         As Variant          '病名コードの配列
    Dim vntArrDisName       As Variant          '病名の配列
    Dim vntArrStrDate       As Variant          '発病年月の配列
    Dim vntArrEndDate       As Variant          '治癒年月の配列
    Dim vntArrCondition     As Variant          '状態の配列
    Dim lngCount            As Long             'レコード数
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRelation = Empty
    vntDisCd = Empty
    vntDisName = Empty
    vntStrDate = Empty
    vntEndDate = Empty
    vntCondition = Empty
    
    '個人ＩＤが設定されていない場合は処理を終了する
    If Trim(strPerID) = "" Then
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '条件を満たす既往歴家族歴テーブルのレコードを取得
    strStmt = "SELECT DH.RELATION RELATION, DH.DISCD DISCD, DH.STRDATE STRDATE, DH.ENDDATE ENDDATE, DH.CONDITION CONDITION, D.DISNAME DISNAME " & vbLf & _
              "  FROM DISHISTORY DH, DISEASE D "
              
    strStmt = strStmt & vbLf & " WHERE DH.PERID    =  :PERID       "
    strStmt = strStmt & vbLf & "   AND DH.RELATION != 0            "
    strStmt = strStmt & vbLf & "   AND DH.DISCD = D.DISCD"
    
    strStmt = strStmt & vbLf & " ORDER BY DH.RELATION, DH.STRDATE DESC, DH.ENDDATE DESC"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRelation = objFields("RELATION")
        Set objDisCd = objFields("DISCD")
        Set objDisName = objFields("DISNAME")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objCondition = objFields("CONDITION")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            '医療機関
            If IsArray(vntArrRelation) Then
                i = UBound(vntArrRelation) + 1
                ReDim Preserve vntArrRelation(i)
                vntArrRelation(i) = Trim(objRelation.Value & "")
            Else
                vntArrRelation = Array(Trim(objRelation.Value & ""))
            End If
            '病名コード
            If IsArray(vntArrDisCd) Then
                i = UBound(vntArrDisCd) + 1
                ReDim Preserve vntArrDisCd(i)
                vntArrDisCd(i) = Trim(objDisCd.Value & "")
            Else
                vntArrDisCd = Array(Trim(objDisCd.Value & ""))
            End If
            '病名
            If IsArray(vntArrDisName) Then
                i = UBound(vntArrDisName) + 1
                ReDim Preserve vntArrDisName(i)
                vntArrDisName(i) = Trim(objDisName.Value & "")
            Else
                vntArrDisName = Array(Trim(objDisName.Value & ""))
            End If
            '発病年月
            If IsArray(vntArrStrDate) Then
                i = UBound(vntArrStrDate) + 1
                ReDim Preserve vntArrStrDate(i)
                vntArrStrDate(i) = Trim(objStrDate.Value & "")
            Else
                vntArrStrDate = Array(Trim(objStrDate.Value & ""))
            End If
            '治癒年月
            If IsArray(vntArrEndDate) Then
                i = UBound(vntArrEndDate) + 1
                ReDim Preserve vntArrEndDate(i)
                vntArrEndDate(i) = Trim(objEndDate.Value & "")
            Else
                vntArrEndDate = Array(Trim(objEndDate.Value & ""))
            End If
            '状態
            If IsArray(vntArrCondition) Then
                i = UBound(vntArrCondition) + 1
                ReDim Preserve vntArrCondition(i)
                vntArrCondition(i) = Trim(objCondition.Value & "")
            Else
                vntArrCondition = Array(Trim(objCondition.Value & ""))
            End If
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntRelation = vntArrRelation
    vntDisCd = vntArrDisCd
    vntDisName = vntArrDisName
    vntStrDate = vntArrStrDate
    vntEndDate = vntArrEndDate
    vntCondition = vntArrCondition
    SelectFamilyList = lngCount
        
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Disease.SelectFamilyList"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 検索条件を満たす病名の一覧を取得する
'
' 引数　　 : (In/Out) vntKey                検索キーの集合
' 　　　　   (In)     strDisDivCd           病類が指定されている場合は検索検索条件に追加
' 　　　　   (In)     lngStartPos           開始位置
' 　　　　   (In)     lngGetCount           取得件数
' 　　　　   (Out)    vntDisCd              病名コード
' 　　　　   (Out)    vntDisName            病名
' 　　　　   (Out)    vntSearchChar         ガイド検索用文字列
' 　　　　   (Out)    vntDisDivCd           病類コード
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Public Function SelectDisList( _
    ByVal vntKey As Variant, _
    ByVal strDisDivCd As Variant, _
    ByVal lngStartPos As Long, _
    ByVal lngGetCount As Long, _
    ByRef vntDisCd As Variant, _
    ByRef vntDisName As Variant, _
    ByRef vntSearchChar As Variant, _
    ByRef vntDisDivCd As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objDisCd            As OraField         '病名コード
    Dim objDisName          As OraField         '病名
    Dim objSearchChar       As OraField         'ガイド検索用文字列
    Dim objDisDivCd         As OraField         '病類コード
    
    Dim vntArrDisCd()       As Variant          '病名コードの配列
    Dim vntArrDisName()     As Variant          '病名の配列
    Dim vntArrSearchChar()  As Variant          'ガイド検索用文字列の配列
    Dim vntArrDisDivCd()    As Variant          '病類コードの配列
    
    Dim lngCount            As Long             '検索件数カウント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntDisCd = Empty
    vntDisName = Empty
    vntSearchChar = Empty
    vntDisDivCd = Empty
    lngCount = 0
    
'## 2003.02.13 Add 5Lines By T.Takagi@FSIT バインド変数化
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DISDIVCD", Trim(strDisDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDPOS", (lngStartPos + lngGetCount - 1), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.13 Add End
    
    '開始位置から取得件数分のレコードを取得
    strStmt = "SELECT DISCD,      " & vbLf & _
              "       DISNAME,   " & vbLf & _
              "       SEARCHCHAR,  " & vbLf & _
              "       DISDIVCD    "
              
    '検索条件を満たす個人テーブルのレコードを取得
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT ROWNUM SEQ,         " & vbLf & _
              "                DISCD,              " & vbLf & _
              "                DISNAME,            " & vbLf & _
              "                SEARCHCHAR,         " & vbLf & _
              "                DISDIVCD            " & vbLf & _
              "           FROM DISEASE             "
              
    '検索条件(key)が省略されている場合は全件検索とする
    If (Not IsEmpty(vntKey)) Then
    
        '検索条件の追加
        strStmt = strStmt & vbLf & _
                  "          " & CreateConditionForDiseaseList(vntKey)
        
        '病類コードが存在する場合は条件節に追加
        If (strDisDivCd <> "") Then
            strStmt = strStmt & vbLf & _
                       "   AND DISDIVCD = " & Trim(strDisDivCd)
'## 2003.02.13 Mod 4Lines By T.Takagi@FSIT バインド変数化
'            strStmt = strStmt & vbLf & _
'                  "   AND DISDIVCD = " & Trim(strDisDivCd)
            strStmt = strStmt & vbLf & _
                       "   AND DISDIVCD = :DISDIVCD"
'## 2003.02.13 Mod End
        End If

'## 2003.02.13 Add 6Lines By T.Takagi@FSIT 検索文字が無効な場合、病類まで無効になってしまう
    Else
    
        '病類コードが存在する場合は条件節に追加
        If strDisDivCd <> "" Then
            strStmt = strStmt & vbLf & _
                       " WHERE DISDIVCD = :DISDIVCD"
        End If
'## 2003.02.13 Add End

    End If

    '病名の順にソート
    strStmt = strStmt & vbLf & _
              "          ORDER BY DISCD " & vbLf & _
              "       )                                 "
              
    '取得開始・終了位置を条件として追加
'## 2003.02.13 Mod 4Lines By T.Takagi@FSIT バインド変数化
'    strStmt = strStmt & vbLf & _
'              " WHERE SEQ BETWEEN " & CStr(lngStartPos) & " AND " & CStr(lngStartPos + lngGetCount - 1)
    strStmt = strStmt & vbLf & _
              " WHERE SEQ BETWEEN :STARTPOS AND :ENDPOS"
'## 2003.02.13 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDisCd = objFields("DISCD")
        Set objDisName = objFields("DISNAME")
        Set objSearchChar = objFields("SEARCHCHAR")
        Set objDisDivCd = objFields("DISDIVCD")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrDisCd(lngCount)
            ReDim Preserve vntArrDisName(lngCount)
            ReDim Preserve vntArrSearchChar(lngCount)
            ReDim Preserve vntArrDisDivCd(lngCount)
            
            vntArrDisCd(lngCount) = objDisCd.Value
            vntArrDisName(lngCount) = objDisName.Value
            vntArrSearchChar(lngCount) = objSearchChar.Value & ""
            vntArrDisDivCd(lngCount) = objDisDivCd.Value

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntDisCd = vntArrDisCd
        vntDisName = vntArrDisName
        vntSearchChar = vntArrSearchChar
        vntDisDivCd = vntArrDisDivCd
        
    End If
    
'#### 2010.08.30 SL-HS-Y0101-002 ADD START ####
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'#### 2010.08.30 SL-HS-Y0101-002 ADD END ####
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectDisList = lngCount
        
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.SelectDisList"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function
'
' 機能　　 : 検索条件を満たす病名の件数を取得する
'
' 引数　　 : (In/Out) vntKey                検索キーの集合
' 　　　　   (In)     vntDisDivCd           病類が指定されている場合は検索検索条件に追加
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Public Function SelectDisListCount(ByVal vntKey As Variant, ByRef vntDisDivCd As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCount        As OraField         '検索件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
'## 2003.02.13 Add 1Line By T.Takagi@FSIT バインド変数化
    objOraParam.Add "DISDIVCD", Trim(vntDisDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.02.13 Add End
    
    '検索条件を満たす個人テーブルのレコードを取得
    strStmt = "SELECT COUNT(*) " & vbLf & _
              "  FROM DISEASE   "

    If (Not IsEmpty(vntKey)) Then
    
        '検索条件の追加
        strStmt = strStmt & vbLf & _
                  " " & CreateConditionForDiseaseList(vntKey)
        
    
        '病類コードが存在する場合は条件節に追加
        If (vntDisDivCd <> "") Then
'## 2003.02.13 Mod 4Lines By T.Takagi@FSIT バインド変数化
'            strStmt = strStmt & vbLf & _
'                  "   AND DISDIVCD = " & Trim(vntDisDivCd)
            strStmt = strStmt & vbLf & _
                  "   AND DISDIVCD = :DISDIVCD"
'## 2003.02.13 Mod End
        End If

'## 2003.02.13 Add 6Lines By T.Takagi@FSIT 検索文字が無効な場合、病類まで無効になってしまう
    Else
    
        '病類コードが存在する場合は条件節に追加
        If (vntDisDivCd <> "") Then
            strStmt = strStmt & vbLf & "WHERE DISDIVCD = :DISDIVCD"
        End If
'## 2003.02.13 Add End
    
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合は件数を戻り値として設定
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        SelectDisListCount = objOraDyna.Fields(0).Value
    End If
    
'#### 2010.08.30 SL-HS-Y0101-002 ADD START ####
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'#### 2010.08.30 SL-HS-Y0101-002 ADD END ####
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.SelectDisListCount"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 病名テーブル検索用条件節作成
'
' 引数　　 : (In/Out) vntKey  検索キーの集合
'
' 戻り値　 : 個人テーブル検索用の条件節
'
' 備考　　 : 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
' 　　　　   検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Private Function CreateConditionForDiseaseList(ByRef vntKey As Variant) As String

    Dim objCommon       As Common   '共通クラス
    
    Dim strStmt         As String   'SQLステートメント
    Dim strCondition    As String   '検索キー
    Dim blnNarrow       As Boolean  '検索キーが半角文字のみの場合にTrue
    Dim strCheckText    As String   'カナ漢字チェック用変数
    Dim strCheckDate    As String   '日付タイプチェック用
    Dim blnWideChar     As Boolean  'カナ漢字チェック用変数
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    Dim k               As Long     'インデックス
    
    Dim strCheckText2   As String   'カナ漢字チェック用変数
    
'## 2003.02.13 Add 2Lines By T.Takagi@FSIT バインド変数化
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名
'## 2003.02.13 Add End
    
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
'## 2003.02.13 Add 1Line By T.Takagi@FSIT バインド変数化
    Set objOraParam = mobjOraDb.Parameters
'## 2003.02.13 Add End
    
    '最初はWHERE句から開始
    strStmt = "WHERE "
    
    '検索キー数分の条件節を追加
    For i = 0 To UBound(vntKey)
              
        '2番目以降の条件節はANDで連結
        If i >= 1 Then
            strStmt = strStmt & " AND "
        End If
        
        '検索キー中の半角カナを全角カナに変換する
        vntKey(i) = objCommon.StrConvKanaWide(vntKey(i))
        
        '検索キーが半角文字のみかチェック
        blnNarrow = (LenB(StrConv(vntKey(i), vbFromUnicode)) = Len(vntKey(i)))
        
'## 2003.02.13 Mod 4Lines By T.Takagi@FSIT バインド変数化
'        'アプストロフィはOracleの単一引用符と重複するので予め置換
'        strCondition = Replace(vntKey(i), "'", "''")
        strParamName = "KEYWORD" & CStr(i)
        objOraParam.Add strParamName, "%" & Trim(vntKey(i)) & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.02.13 Mod End
        
        If blnNarrow Then
        
'            If Right(strCondition, 1) = "*" Then
            
'                '文字列の末尾が"*"なら部分検索
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT バインド変数化
'                strStmt = strStmt & "DISCD LIKE '%" & strCondition & "%' "
                strStmt = strStmt & "DISCD LIKE :" & strParamName
'## 2003.02.13 Mod End
        
'            End If
'### Updated End
        
            '生年月日による検索もサポート（数値かつ８桁の場合にチェック）
'            If ((IsNumeric(strCondition)) And (Len(strCondition) = 8)) Or (IsDate(strCondition)) Then
'
'                If IsDate(strCondition) And Left(strCondition, 4) <> "0000" Then
'                    '既に日付タイプの場合
'                    strStmt = strStmt & "OR BIRTH = '" & strCondition & "'"
'                Else
'                    strCheckDate = Mid(strCondition, 1, 4) & "/" & Mid(strCondition, 5, 2) & "/" & Mid(strCondition, 7, 2)
'                    '日付タイプの場合、検索条件を追加（個人番号とのOR検索）
'                    If IsDate(strCheckDate) And Left(strCondition, 4) <> "0000" Then
'                        strStmt = strStmt & "OR BIRTH = TO_DATE('" & strCondition & "') "
'                    End If
'                End If
'
'            End If
'## 2003.02.13 Del 32Lines By T.Takagi@FSIT 病名検索に生年月日なんてない
'            Do
'                strCheckDate = ""
'
'                'すでに日付認識可能ならそのまま使用
'                If IsDate(strCondition) Then
'                    strCheckDate = Format(strCondition, "yyyy/mm/dd")
'                    Exit Do
'                End If
'
'                '8桁でなければ何もしない
'                If Len(Trim(strCondition)) <> 8 Then
'                    Exit Do
'                End If
'
'                '半角数字チェック
'                For k = 1 To Len(Trim(strCondition))
'                    Select Case Asc(Mid(Trim(strCondition), k, 1))
'                        Case Asc("0") To Asc("9")
'                        Case Else
'                            Exit Do
'                    End Select
'                Next k
'
'                'チェック正常であれば日付タイプに変換
'                strCheckDate = Format(strCondition, "0000/00/00")
'                Exit Do
'            Loop
'
'            '条件追加(年はOracleでエラーとならない年のみを指定可能とする)
'            If IsDate(strCheckDate) And Left(strCheckDate, 4) <> "0000" Then
'                strStmt = strStmt & "OR BIRTH = TO_DATE('" & strCheckDate & "') "
'            End If
'## 2003.02.13 Del End
                
        Else
        
'## 2003.02.13 Mod 37Lines By T.Takagi@FSIT バインド変数化(searchChar検索はオミット)
'            '半角変換
'            strCheckText = StrConv(strCondition, vbNarrow)
'
'            '全角文字列チェック(漢字・ひらがなは半角変換できない)
'            blnWideChar = False
'            For j = 1 To Len(strCheckText)
'                '全角文字の場合
'                If Asc(Mid(strCheckText, j, 1)) < 0 Then
'                    blnWideChar = True
'                    Exit For
'                End If
'            Next j
'
'            If blnWideChar = True Then
'                '漢字含みの場合
'                strStmt = strStmt & "( DISNAME LIKE '%" & strCondition & "%' OR SEARCHCHAR LIKE '%" & strCondition & "%' ) "
'            Else
'                'カナ名のみの場合
''                strStmt = strStmt & "( LASTKNAME LIKE '" & strCondition & "%' OR FIRSTKNAME LIKE '" & strCondition & "%' ) "
'                strCheckText2 = strCondition
'                strCheckText2 = Replace(strCheckText2, "ァ", "ア")
'                strCheckText2 = Replace(strCheckText2, "ィ", "イ")
'                strCheckText2 = Replace(strCheckText2, "ゥ", "ウ")
'                strCheckText2 = Replace(strCheckText2, "ェ", "エ")
'                strCheckText2 = Replace(strCheckText2, "ォ", "オ")
'                strCheckText2 = Replace(strCheckText2, "ッ", "ツ")
'                strCheckText2 = Replace(strCheckText2, "ャ", "ヤ")
'                strCheckText2 = Replace(strCheckText2, "ュ", "ユ")
'                strCheckText2 = Replace(strCheckText2, "ョ", "ヨ")
''                If strCheckText2 <> strCondition Then
''                    strStmt = strStmt & "( DISNAME LIKE '%" & strCondition & "%' OR SEARCHCHAR LIKE '" & strCondition & "%' OR LASTKNAME LIKE '" & strCheckText2 & "%' OR FIRSTKNAME LIKE '" & strCheckText2 & "%' ) "
''                Else
'                    strStmt = strStmt & "( DISNAME LIKE '%" & strCondition & "%' OR SEARCHCHAR LIKE '%" & strCondition & "%' ) "
''                End If
'
'            End If
            strStmt = strStmt & "DISNAME LIKE :" & strParamName
'## 2003.02.13 Mod End
            
        End If
        
    Next i

    CreateConditionForDiseaseList = strStmt
    
End Function

'
' 機能　　 : Activateイベント
'
' 備考　　 : COMオブジェクトがアクティブ化された時点でデータベースへの接続を行う
'
Private Sub ObjectControl_Activate()

    Dim objCommon   As Common   '共通クラス
    
    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    'データベース接続
    Set mobjOraSession = mobjContext.CreateInstance("OracleInProcServer.XOraSession")
    Set mobjOraDb = mobjOraSession.OpenDatabase(objCommon.ConnectString, objCommon.UserName & "/" & objCommon.Password, ORADB_ENLIST_IN_MTS)
    
End Sub

Private Function ObjectControl_CanBePooled() As Boolean

End Function

'
' 機能　　 : DeaActivateイベント
'
' 備考　　 : COMオブジェクトが非アクティブ化された時点でデータベースからの切断を行う
'
Private Sub ObjectControl_Deactivate()

    'データベース切断
    Set mobjOraSession = Nothing
    Set mobjOraDb = Nothing
    
    'オブジェクトコンテキストの解放
    Set mobjContext = Nothing

End Sub
