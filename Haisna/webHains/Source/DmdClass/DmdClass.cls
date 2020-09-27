VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "DmdClass"
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

Private mobjContext      As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト
'
' 機能　　 : 請求書分類レコードを登録する（トランザクション対応）
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strBillClassCd         請求書分類コード
' 　　　　   (In)    strBillClassName       請求書分類名
' 　　　　   (In)    lngDefCheck            デフォルトチェック
' 　　　　   (In)    lngOtherIncome         雑収入扱い
' 　　　　   (In)    strCrfFileName         出力ファイル名
' 　　　　   (In)    vntCsCd                コースコード
' 　　　　   (In)    vntBillTitle           請求内訳書用タイトル
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistBillClass_All(ByVal strMode As String, _
                                    ByVal strBillClassCd As String, _
                                    ByVal strBillClassName As String, _
                                    ByVal lngDefCheck As Long, _
                                    ByVal lngOtherIncome As Long, _
                                    ByVal strCrfFileName As String, _
                                    ByVal intItemCount As Integer, _
                                    ByVal vntCsCd As Variant, _
                                    ByVal vntBillTitle As Variant) As Long
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim Ret         As Long             '関数戻り値
    
    Ret = INSERT_ERROR
    
    Do
        
        '請求書分類テーブルの更新
        Ret = RegistBillClass(strMode, _
                              strBillClassCd, _
                              strBillClassName, _
                              lngDefCheck, _
                              lngOtherIncome, _
                              strCrfFileName, _
                              vntBillTitle)

        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
                         
        '請求書分類内項目テーブルの更新
        Ret = RegistBillClass_C(strBillClassCd, _
                             intItemCount, _
                             vntCsCd)
        
        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
        
        Exit Do
    Loop
 
    If Ret = INSERT_NORMAL Then
        mobjContext.SetComplete
    Else
        '異常終了ならRollBack
        mobjContext.SetAbort
    End If
 
    '戻り値の設定
    RegistBillClass_All = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistBillClass_All = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "BillClass.RegistBillClass_All"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 請求書分類内コースを登録する
'
' 引数　　 : (In)    strBillClassCd     請求書分類コード
' 　　　　   (In)    intItemCount       更新コースコード数
' 　　　　   (In)    vntCsCd            コースコード
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistBillClass_C(ByVal strBillClassCd As String, _
                                  ByVal intItemCount As Integer, _
                                  ByVal vntCsCd As Variant) As Long
                               
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objBillClassCd      As OraParamArray    '請求書分類コード
    Dim objCsCd             As OraParamArray    'コースコード

    Dim i                   As Integer
    Dim Ret                 As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLCLASSCD", Trim(strBillClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '請求書分類内コースレコードの削除
    mobjOraDb.ExecuteSQL "DELETE BILLCLASS_C WHERE BILLCLASSCD = :BILLCLASSCD"
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "BILLCLASSCD"
        objOraParam.AddTable "BILLCLASSCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 4
        objOraParam.AddTable "CSCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_COURSE_CSCD
        
        'OraParameterオブジェクトの参照設定
        Set objBillClassCd = objOraParam("BILLCLASSCD")
        Set objCsCd = objOraParam("CSCD")
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objBillClassCd(i) = strBillClassCd
            objCsCd(i) = vntCsCd(i)
        Next i
        
        '新規挿入
        strStmt = ""
        strStmt = strStmt & "INSERT INTO BILLCLASS_C (BILLCLASSCD, CSCD) VALUES (:BILLCLASSCD, :CSCD)"
        mobjOraDb.ExecuteSQL strStmt
    
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Ret = INSERT_NORMAL
    
    '戻り値の設定
    RegistBillClass_C = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistBillClass_C = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "BillClass.RegistBillClass_C"
    
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
' 機能　　 : 請求書分類の一覧を取得する
'
' 引数　　 : (Out)    vntBillClassCd    請求書分類コード
' 　　　　 : (Out)    vntBillClassName  請求書分類名称（省略可）
' 　　　　 : (Out)    vntDefCheck       デフォルトチェック
' 　　　　 : (Out)    vntOtherIncome    雑収入扱い
' 　　　　 : (Out)    vntCrfFileName    出力ファイル名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectBillClassList(ByRef vntBillClassCd As Variant, _
                                    Optional ByRef vntBillClassName As Variant, _
                                    Optional ByRef vntDefCheck As Variant, _
                                    Optional ByRef vntOtherIncome As Variant, _
                                    Optional ByRef vntCrfFileName As Variant _
                                    ) As Long

    Dim objOraDyna              As OraDynaset   'ダイナセット
    Dim strStmt                 As String       'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    Dim objBillClassCd          As OraField     '請求書分類コード
    Dim objBillClassName        As OraField     '請求書分類名称
    Dim objDefCheck             As OraField     'デフォルトチェック
    Dim objOtherIncome          As OraField     '雑収入扱い
    Dim objCrfFileName          As OraField     '出力ファイル名
    
    Dim vntArrBillClassCd()     As Variant      '請求書分類コードの配列
    Dim vntArrBillClassName()   As Variant      '請求書分類名称の配列
    Dim vntArrDefCheck()        As Variant      'デフォルトチェックの配列
    Dim vntArrOtherIncome()     As Variant      '雑収入扱いの配列
    Dim vntArrCrfFileName()     As Variant      '出力ファイル名の配列
    
    Dim lngCount                As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件を満たす請求書分類分類テーブルのレコードを取得
    strStmt = "SELECT BILLCLASSCD, BILLCLASSNAME, " & vbLf & _
              "       DEFCHECK, OTHERINCOME, CRFFILENAME " & vbLf & _
              "  FROM BILLCLASS" & vbLf & _
              " ORDER BY BILLCLASSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objBillClassCd = objFields("BILLCLASSCD")
        Set objBillClassName = objFields("BILLCLASSNAME")
        Set objDefCheck = objFields("DEFCHECK")
        Set objOtherIncome = objFields("OTHERINCOME")
        Set objCrfFileName = objFields("CRFFILENAME")
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrBillClassCd(lngCount)
            ReDim Preserve vntArrBillClassName(lngCount)
            ReDim Preserve vntArrDefCheck(lngCount)
            ReDim Preserve vntArrOtherIncome(lngCount)
            ReDim Preserve vntArrCrfFileName(lngCount)
            
            vntArrBillClassCd(lngCount) = objBillClassCd.Value
            vntArrBillClassName(lngCount) = objBillClassName.Value
            vntArrDefCheck(lngCount) = objDefCheck.Value
            vntArrOtherIncome(lngCount) = objOtherIncome.Value & ""
            vntArrCrfFileName(lngCount) = objCrfFileName.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntBillClassCd = vntArrBillClassCd
    If IsMissing(vntBillClassName) = False Then vntBillClassName = vntArrBillClassName
    If IsMissing(vntDefCheck) = False Then vntDefCheck = vntArrDefCheck
    If IsMissing(vntOtherIncome) = False Then vntOtherIncome = vntArrOtherIncome
    If IsMissing(vntCrfFileName) = False Then vntCrfFileName = vntArrCrfFileName
    
    SelectBillClassList = lngCount
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "BillClass.SelectBillClassList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 請求書分類管理コースの一覧を取得する
'
' 引数　　 : (In)     strBillClassCd    請求書分類コード
' 　　　　 : (Out)    vntCsCd           コースコード
' 　　　　 : (Out)    vntCsName         コース名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectBillClass_cList(ByVal strBillClassCd As String, _
                                      ByRef vntCsCd As Variant, _
                                      Optional ByRef vntCsName As Variant) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset   'ダイナセット
    Dim strStmt                 As String       'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    Dim objBillClassCd          As OraField     '請求書分類コード
    Dim objCsCd                 As OraField     'コースコード
    Dim objCsName               As OraField     'コース名
    
    Dim vntArrCsCd()            As Variant      'コースコードの配列
    Dim vntArrCsName()          As Variant      'コース名の配列
    
    Dim lngCount                As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLCLASSCD", Trim(strBillClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす請求書分類分類テーブルのレコードを取得
    strStmt = "SELECT BILLCLASS_C.CSCD, COURSE_P.CSNAME" & vbLf & _
              "  FROM COURSE_P,　BILLCLASS_C" & vbLf & _
              " WHERE BILLCLASS_C.BILLCLASSCD = :BILLCLASSCD" & vbLf & _
              "   AND COURSE_P.CSCD           = BILLCLASS_C.CSCD " & vbLf & _
              " ORDER BY BILLCLASS_C.CSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            
            vntArrCsCd(lngCount) = objCsCd.Value
            vntArrCsName(lngCount) = objCsName.Value
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntCsCd = vntArrCsCd
    If IsMissing(vntCsName) = False Then vntCsName = vntArrCsName
    
    SelectBillClass_cList = lngCount
    
    Set objOraDyna = Nothing
        
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
    WriteErrorLog "BillClass.SelectBillClass_cList"
    
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
' 機能　　 : 請求書分類情報を取得する
'
' 引数　　 : (In)     strBillClassCd     請求書分類コード
' 　　　　 : (Out)    vntBillClassName   請求書分類名称（省略可）
' 　　　　 : (Out)    vntDefCheck        デフォルトチェック（省略可）
' 　　　　 : (Out)    vntOtherIncome     雑収入扱い（省略可）
' 　　　　 : (Out)    vntCrfFileName     出力ファイル名（省略可）
' 　　　　 : (Out)    vntBillTitle       請求内訳書用タイトル（省略可）
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 :
'
Public Function SelectBillClass(ByVal strBillClassCd As String, _
                                Optional ByRef vntBillClassName As Variant, _
                                Optional ByRef vntDefCheck As Variant, _
                                Optional ByRef vntOtherIncome As Variant, _
                                Optional ByRef vntCrfFileName As Variant, _
                                Optional ByRef vntBillTitle As Variant _
                                ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objBillClassName        As OraField         '請求書分類名称
    Dim objDefCheck             As OraField         'デフォルトチェック
    Dim objOtherIncome          As OraField         '雑収入扱い
    Dim objCrfFileName          As OraField         '出力ファイル名
'### 2003.02.19 Updated by Ishihara@FSIT 請求内訳書用タイトル追加
    Dim objBillTitle            As OraField         '請求内訳書用タイトル
'### 2003.02.19 Updated End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLCLASSCD", Trim(strBillClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす請求書分類テーブルのレコードを取得
'### 2003.02.19 Updated by Ishihara@FSIT 請求内訳書用タイトル追加
'    strStmt = "SELECT BILLCLASSNAME, DEFCHECK, OTHERINCOME, CRFFILENAME" & vbLf & _
              "  FROM BILLCLASS " & vbLf & _
              " WHERE BILLCLASSCD = :BILLCLASSCD"
    strStmt = "SELECT BILLCLASSNAME, DEFCHECK, OTHERINCOME, CRFFILENAME, BILLTITLE" & vbLf & _
              "  FROM BILLCLASS " & vbLf & _
              " WHERE BILLCLASSCD = :BILLCLASSCD"
'### 2003.02.19 Updated End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objBillClassName = objFields("BILLCLASSNAME")
        Set objDefCheck = objFields("DEFCHECK")
        Set objOtherIncome = objFields("OTHERINCOME")
        Set objCrfFileName = objFields("CRFFILENAME")
'### 2003.02.19 Updated by Ishihara@FSIT 請求内訳書用タイトル追加
        Set vntBillTitle = objFields("BILLTITLE")
'### 2003.02.19 Updated End

        If Not IsMissing(vntBillClassName) Then vntBillClassName = objBillClassName.Value
        If IsMissing(vntBillClassName) = False Then vntBillClassName = objBillClassName.Value
        If IsMissing(vntDefCheck) = False Then vntDefCheck = objDefCheck.Value
        If IsMissing(vntOtherIncome) = False Then vntOtherIncome = objOtherIncome.Value & ""
        If IsMissing(vntCrfFileName) = False Then vntCrfFileName = objCrfFileName.Value & ""
'### 2003.02.19 Updated by Ishihara@FSIT 請求内訳書用タイトル追加
        If IsMissing(vntBillTitle) = False Then vntBillTitle = vntBillTitle.Value & ""
'### 2003.02.19 Updated End
        
        SelectBillClass = True
    
    Else
        
        If Not IsMissing(vntBillClassName) Then vntBillClassName = ""
    
    End If

    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "BillClass.SelectBillClass"
    
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
' 機能　　 : 請求書分類テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strBillClassCd     請求書分類コード
' 　　　　 : (In)    vntBillClassName   請求書分類名称
' 　　　　 : (In)    strDefCheck        デフォルトチェック
' 　　　　 : (In)    vntOtherIncome     雑収入扱い
' 　　　　 : (In)    vntCrfFileName     出力ファイル名
' 　　　　 : (In)    vntBillTitle       請求内訳書用タイトル
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistBillClass(ByVal strMode As String, _
                                ByVal strBillClassCd As String, _
                                ByVal strBillClassName As String, _
                                ByVal strDefCheck As String, _
                                ByVal strOtherIncome As String, _
                                ByVal strCrfFileName As String, _
                                ByVal vntBillTitle As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLCLASSCD", Trim(strBillClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BILLCLASSNAME", Trim(strBillClassName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DEFCHECK", Trim(strDefCheck), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OTHERINCOME", Trim(strOtherIncome), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CRFFILENAME", Trim(strCrfFileName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.02.19 Updated by Ishihara@FSIT 請求内訳書用タイトル追加
    objOraParam.Add "BILLTITLE", Trim(vntBillTitle), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.02.19 Updated End

    Do
        '請求書分類テーブルレコードの更新
        If strMode = "UPD" Then
'### 2003.02.19 Updated by Ishihara@FSIT 請求内訳書用タイトル追加
'            strStmt = "UPDATE BILLCLASS " & _
                      "   SET BILLCLASSNAME = :BILLCLASSNAME, " & _
                      "       DEFCHECK      = :DEFCHECK, " & _
                      "       OTHERINCOME   = :OTHERINCOME, " & _
                      "       CRFFILENAME   = :CRFFILENAME " & _
                      " WHERE BILLCLASSCD   = :BILLCLASSCD"
            strStmt = "UPDATE BILLCLASS " & _
                      "   SET BILLCLASSNAME = :BILLCLASSNAME, " & _
                      "       DEFCHECK      = :DEFCHECK, " & _
                      "       OTHERINCOME   = :OTHERINCOME, " & _
                      "       CRFFILENAME   = :CRFFILENAME, " & _
                      "       BILLTITLE     = :BILLTITLE " & _
                      " WHERE BILLCLASSCD   = :BILLCLASSCD"
'### 2003.02.19 Updated End
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす請求書分類テーブルのレコードを取得
        strStmt = "SELECT BILLCLASSCD FROM BILLCLASS WHERE BILLCLASSCD = :BILLCLASSCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'### 2003.02.19 Updated by Ishihara@FSIT 請求内訳書用タイトル追加
'        strStmt = "INSERT INTO BILLCLASS ( BILLCLASSCD,  BILLCLASSNAME,  DEFCHECK,  OTHERINCOME,  CRFFILENAME)" & _
                  "               VALUES (:BILLCLASSCD, :BILLCLASSNAME, :DEFCHECK, :OTHERINCOME, :CRFFILENAME)"
        strStmt = "INSERT INTO BILLCLASS ( BILLCLASSCD,  BILLCLASSNAME,  DEFCHECK,  OTHERINCOME,  CRFFILENAME,  BILLTITLE)" & _
                  "               VALUES (:BILLCLASSCD, :BILLCLASSNAME, :DEFCHECK, :OTHERINCOME, :CRFFILENAME, :BILLTITLE)"
'### 2003.02.19 Updated End
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistBillClass = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistBillClass = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "BillClass.RegistBillClass"
    
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
' 機能　　 : 請求書分類テーブルレコードを削除する
'
' 引数　　 : (In)   strBillClassCd    請求書分類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteBillClass(ByVal strBillClassCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLCLASSCD", Trim(strBillClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '請求書分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE BILLCLASS WHERE BILLCLASSCD = :BILLCLASSCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteBillClass = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteBillClass = False

    'イベントログ書き込み
    WriteErrorLog "BillClass.DeleteBillClass"
    
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
'## 2002.11.07 Add Function By T.Takagi@FSIT 東急対応
'
' 機能　　 : 請求明細分類の一覧を取得する
'
' 引数　　 : (Out)    vntDmdLineClassCd    請求明細分類コード
' 　　　　   (Out)    vntDmdLineClassName  請求明細分類名
' 　　　　   (In)     lngMode              取得モード（0:すべて、1:一般で使用する請求明細分類のみ、2:健保で使用する請求明細分類のみ）
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectDmdLineClassList(ByRef vntDmdLineClassCd As Variant, ByRef vntDmdLineClassName As Variant, Optional ByVal lngMode As Long = 0) As Long

    Dim objOraDyna                  As OraDynaset   'ダイナセット
    Dim strStmt                     As String       'SQLステートメント
    
    Dim objFields                   As OraFields    'フィールドオブジェクト
    Dim objDmdLineClassCd           As OraField     '請求明細分類コード
    Dim objDmdLineClassName         As OraField     '請求明細分類名
    
    Dim vntArrDmdLineClassCd()      As Variant      '請求明細分類コードの配列
    Dim vntArrDmdLineClassName()    As Variant      '請求明細分類名の配列
    Dim lngCount                    As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntDmdLineClassCd = Empty
    vntDmdLineClassName = Empty
    lngCount = 0
    
    '請求明細分類テーブル読み込み
    strStmt = "SELECT DMDLINECLASSCD, DMDLINECLASSNAME " & vbLf & _
              "  FROM DMDLINECLASS                     "
              
    '一般で使用する請求明細分類のみ取得する場合の条件を追加
    If lngMode = 1 Then
        strStmt = strStmt & vbLf & _
              " WHERE ISRFLG IS NULL " & vbLf & _
              "    OR ISRFLG  = 0    "
    End If
    
    '健保で使用する請求明細分類のみ取得する場合の条件を追加
    If lngMode = 2 Then
        strStmt = strStmt & vbLf & _
              " WHERE ISRFLG IS NULL " & vbLf & _
              "    OR ISRFLG  = 1    "
    End If
    
    strStmt = strStmt & vbLf & _
              " ORDER BY DMDLINECLASSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDmdLineClassCd = objFields("DMDLINECLASSCD")
        Set objDmdLineClassName = objFields("DMDLINECLASSNAME")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrDmdLineClassCd(lngCount)
            ReDim Preserve vntArrDmdLineClassName(lngCount)
            vntArrDmdLineClassCd(lngCount) = objDmdLineClassCd.Value
            vntArrDmdLineClassName(lngCount) = objDmdLineClassName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntDmdLineClassCd = vntArrDmdLineClassCd
        vntDmdLineClassName = vntArrDmdLineClassName
    
    End If
    
    '戻り値の設定
    SelectDmdLineClassList = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Course.SelectDmdLineClassList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 請求明細分類の一覧を取得する
'
' 引数　　 : (Out)    vntdmdLineClassCd     請求明細分類コード
' 　　　　 : (Out)    vntdmdLineClassName   請求明細分類名称（省略可）
' 　　　　 : (Out)    vntSumDetails         健診基本料集計フラグ
' 　　　　 : (Out)    vntIsrFlg             健保使用フラグ
' 　　　　 : (Out)    vntMakeBillLine       請求書明細作成フラグ
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectDmdLineClassItemList(ByRef vntDmdLineClassCd As Variant, _
                                           Optional ByRef vntDmdLineClassName As Variant, _
                                           Optional ByRef vntSumDetails As Variant, _
                                           Optional ByRef vntIsrFlg As Variant, _
                                           Optional ByRef vntMakeBillLine As Variant _
                                           ) As Long

    Dim objOraDyna                  As OraDynaset   'ダイナセット
    Dim strStmt                     As String       'SQLステートメント
    
    Dim objFields                   As OraFields    'フィールドオブジェクト
    Dim objDmdLineClassCd           As OraField     '請求明細分類コード
    Dim objDmdLineClassName         As OraField     '請求明細分類名称
    Dim objSumDetails               As OraField     '健診基本料集計フラグ
    Dim objIsrFlg                   As OraField     '健保使用フラグ
    Dim objMakeBillLine             As OraField     '請求書明細作成フラグ
    
    Dim vntArrDmdLineClassCd()      As Variant      '請求明細分類コードの配列
    Dim vntArrDmdLineClassName()    As Variant      '請求明細分類名称の配列
    Dim vntArrSumDetails()          As Variant      '健診基本料集計フラグの配列
    Dim vntArrIsrFlg()              As Variant      '健保使用フラグの配列
    Dim vntArrMakeBillLine()        As Variant      '請求書明細作成フラグの配列
    
    Dim lngCount                    As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件を満たす請求明細分類分類テーブルのレコードを取得
    strStmt = "SELECT DMDLINECLASSCD, DMDLINECLASSNAME, " & vbLf & _
              "       SUMDETAILS, ISRFLG, MAKEBILLLINE " & vbLf & _
              "  FROM DMDLINECLASS" & vbLf & _
              " ORDER BY DMDLINECLASSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDmdLineClassCd = objFields("dmdLineClassCD")
        Set objDmdLineClassName = objFields("dmdLineClassName")
        Set objSumDetails = objFields("SumDetails")
        Set objIsrFlg = objFields("IsrFlg")
        Set objMakeBillLine = objFields("MakeBillLine")
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrDmdLineClassCd(lngCount)
            ReDim Preserve vntArrDmdLineClassName(lngCount)
            ReDim Preserve vntArrSumDetails(lngCount)
            ReDim Preserve vntArrIsrFlg(lngCount)
            ReDim Preserve vntArrMakeBillLine(lngCount)
            
            vntArrDmdLineClassCd(lngCount) = objDmdLineClassCd.Value
            vntArrDmdLineClassName(lngCount) = objDmdLineClassName.Value
            vntArrSumDetails(lngCount) = objSumDetails.Value
            vntArrIsrFlg(lngCount) = objIsrFlg.Value & ""
            vntArrMakeBillLine(lngCount) = objMakeBillLine.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntDmdLineClassCd = vntArrDmdLineClassCd
    If IsMissing(vntDmdLineClassName) = False Then vntDmdLineClassName = vntArrDmdLineClassName
    If IsMissing(vntSumDetails) = False Then vntSumDetails = vntArrSumDetails
    If IsMissing(vntIsrFlg) = False Then vntIsrFlg = vntArrIsrFlg
    If IsMissing(vntMakeBillLine) = False Then vntMakeBillLine = vntArrMakeBillLine
    
    SelectDmdLineClassItemList = lngCount
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "dmdLineClass.SelectDmdLineClassItemList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 請求明細分類情報を取得する
'
' 引数　　 : (In)     strdmdLineClassCd     請求明細分類コード
' 　　　　 : (Out)    vntdmdLineClassName   請求明細分類名称（省略可）
' 　　　　 : (Out)    vntSumDetails         健診基本料集計フラグ（省略可）
' 　　　　 : (Out)    vntIsrFlg             健保使用フラグ（省略可）
' 　　　　 : (Out)    vntMakeBillLine       請求書明細作成フラグ（省略可）
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 : 請求明細分類略称を省略可とすることで、入力チェックにも対応
'
Public Function SelectDmdLineClass(ByVal strdmdLineClassCd As String, _
                                   Optional ByRef vntDmdLineClassName As Variant, _
                                   Optional ByRef vntSumDetails As Variant, _
                                   Optional ByRef vntIsrFlg As Variant, _
                                   Optional ByRef vntMakeBillLine As Variant _
                                   ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objDmdLineClassName     As OraField         '請求明細分類名称
    Dim objSumDetails           As OraField         '健診基本料集計フラグ
    Dim objIsrFlg               As OraField         '健保使用フラグ
    Dim objMakeBillLine         As OraField         '請求書明細作成フラグ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "dmdLineClassCD", Trim(strdmdLineClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす請求明細分類テーブルのレコードを取得
    strStmt = "SELECT DMDLINECLASSNAME, SUMDETAILS, ISRFLG, MAKEBILLLINE" & vbLf & _
              "  FROM DMDLINECLASS " & vbLf & _
              " WHERE DMDLINECLASSCD = :DMDLINECLASSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDmdLineClassName = objFields("dmdLineClassName")
        Set objSumDetails = objFields("SumDetails")
        Set objIsrFlg = objFields("IsrFlg")
        Set objMakeBillLine = objFields("MakeBillLine")

        If Not IsMissing(vntDmdLineClassName) Then vntDmdLineClassName = objDmdLineClassName.Value
        If IsMissing(vntDmdLineClassName) = False Then vntDmdLineClassName = objDmdLineClassName.Value
        If IsMissing(vntSumDetails) = False Then vntSumDetails = objSumDetails.Value
        If IsMissing(vntIsrFlg) = False Then vntIsrFlg = objIsrFlg.Value & ""
        If IsMissing(vntMakeBillLine) = False Then vntMakeBillLine = objMakeBillLine.Value & ""
        
        SelectDmdLineClass = True
    
    Else
        
        If Not IsMissing(vntDmdLineClassName) Then vntDmdLineClassName = ""
    
    End If

    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "dmdLineClass.SelectdmdLineClass"
    
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
' 機能　　 : 請求明細分類テーブルレコードを登録する
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strdmdLineClassCd      請求明細分類コード
' 　　　　 : (In)    vntdmdLineClassName    請求明細分類名称
' 　　　　 : (In)    strSumDetails          健診基本料集計フラグ
' 　　　　 : (In)    vntIsrFlg              健保使用フラグ
' 　　　　 : (In)    vntMakeBillLine        請求書明細作成フラグ
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistdmdLineClass(ByVal strMode As String, _
                                   ByVal strdmdLineClassCd As String, _
                                   ByVal strdmdLineClassName As String, _
                                   ByVal strSumDetails As String, _
                                   ByVal strIsrFlg As String, _
                                   ByVal strMakeBillLine As String _
                                   ) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDLINECLASSCD", Trim(strdmdLineClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DMDLINECLASSNAME", Trim(strdmdLineClassName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUMDETAILS", Trim(strSumDetails), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRFLG", Trim(strIsrFlg), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MAKEBILLLINE", Trim(strMakeBillLine), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '請求明細分類テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE DMDLINECLASS " & _
                      "   SET DMDLINECLASSNAME = :DMDLINECLASSNAME, " & _
                      "       SUMDETAILS       = :SUMDETAILS, " & _
                      "       ISRFLG           = :ISRFLG, " & _
                      "       MAKEBILLLINE     = :MAKEBILLLINE " & _
                      " WHERE DMDLINECLASSCD   = :DMDLINECLASSCD"
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす請求明細分類テーブルのレコードを取得
        strStmt = "SELECT DMDLINECLASSCD FROM DMDLINECLASS WHERE DMDLINECLASSCD = :DMDLINECLASSCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        strStmt = "INSERT INTO DMDLINECLASS ( DMDLINECLASSCD,  DMDLINECLASSNAME,  SUMDETAILS,  ISRFLG,  MAKEBILLLINE)" & _
                  "                  VALUES (:DMDLINECLASSCD, :DMDLINECLASSNAME, :SUMDETAILS, :ISRFLG, :MAKEBILLLINE)"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistdmdLineClass = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistdmdLineClass = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "dmdLineClass.RegistdmdLineClass"
    
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
' 機能　　 : 請求明細分類テーブルレコードを削除する
'
' 引数　　 : (In)   strdmdLineClassCd    請求明細分類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteDmdLineClass(ByVal strdmdLineClassCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DMDLINECLASSCD", Trim(strdmdLineClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '請求明細分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE DMDLINECLASS WHERE DMDLINECLASSCD = :DMDLINECLASSCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteDmdLineClass = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteDmdLineClass = False

    'イベントログ書き込み
    WriteErrorLog "dmdLineClass.DeletedmdLineClass"
    
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
