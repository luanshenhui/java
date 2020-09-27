VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "JudClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext      As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト

'#### コメント表示モード追加 2003.11.25 FFCS
'
' 機能　　 : 検索条件を満たす判定分類の一覧を取得する
'
' 引数　　 : (Out)    vntJudClassCd     判定分類コード
' 　　　　 : (Out)    vntJudClassName   判定分類名称
' 　　　　 : (Out)    vntAllJudFlg      統計用総合判定フラグ
' 　　　　 : (Out)    vntAfterCareCd    アフターケアコード
' 　　　　 : (Out)    vntIsrOrganDiv    健保用器官区分文字列
' 　　　　 : (Out)    vntCommentOnly    コメント表示モード
' 　　　　 : (Out)    vntViewOrder      判定分類表示順
' 　　　　 : (Out)    vntResultDispMode 検査結果表示モード（判定リンク用）
' 　　　　 : (Out)    vntNotAutoFlg     自動判定対象外フラグ
' 　　　　 : (Out)    vntNotNormalFlg   通常判定対象外フラグ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectJudClassList(ByRef vntJudClassCd As Variant, _
                                   ByRef vntJudClassName As Variant, _
                                   Optional ByRef vntAllJudFlg As Variant, _
                                   Optional ByRef vntAfterCareCd As Variant, _
                                   Optional ByRef vntIsrOrganDiv As Variant, _
                                   Optional ByRef vntCommentOnly As Variant, _
                                   Optional ByRef vntViewOrder As Variant, _
                                   Optional ByRef vntResultDispMode As Variant, _
                                   Optional ByRef vntNotAutoFlg As Variant, _
                                   Optional ByRef vntNotNormalFlg As Variant _
                                  ) As Long

    Dim objOraDyna              As OraDynaset   'ダイナセット
    Dim strStmt                 As String       'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    Dim objJudClassCd           As OraField     'グループ区分
    Dim objJudClassName         As OraField     'グループコード
    Dim objAllJudFlg            As OraField     '統計用総合判定フラグ
'## 2003.11.23 Del By T.Takagi@FSIT 聖路加不要項目削除
''## 2002.12.27 Add 1Line By H.Ishihara@FSIT アフターケアコードの追加
'    Dim objAfterCareCd          As OraField     'アフターケアコード
''## 2002.12.27 Add End
'    Dim objIsrOrganDiv          As OraField     '健保用器官区分文字列
'## 2003.11.23 Del End
    Dim objCommentOnly          As OraField     'コメント表示モード

'## 2004.02.13 Added 4Lines By H.Ishihara@FSIT 聖路加専用項目の追加
    Dim objViewOrder            As OraField      '判定分類表示順
    Dim objResultDispMode       As OraField      '検査結果表示モード（判定リンク用）
    Dim objNotAutoFlg           As OraField      '自動判定対象外フラグ
    Dim objNotNormalFlg         As OraField      '通常判定対象外フラグ
'## 2004.02.13 Added End

    Dim vntArrJudClassCd()      As Variant      '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant      '判定分類名称の配列
    Dim vntArrAllJudFlg()       As Variant      '統計用総合判定フラグの配列
'## 2002.12.27 Add 1Line By H.Ishihara@FSIT アフターケアコードの追加
    Dim vntArrAfterCareCd()     As Variant      'アフターケアコードの配列
'## 2002.12.27 Add End
    Dim vntArrIsrOrganDiv()     As Variant      '健保用器官区分文字列の配列
    Dim vntArrCommentOnly()     As Variant      'コメント表示モードの配列
    Dim lngCount                As Long         'レコード数
    
'## 2004.02.13 Added 4Lines By H.Ishihara@FSIT 聖路加専用項目の追加
    Dim vntArrViewOrder()       As Variant      '判定分類表示順の配列
    Dim vntArrResultDispMode()  As Variant      '検査結果表示モード（判定リンク用）の配列
    Dim vntArrNotAutoFlg()      As Variant      '自動判定対象外フラグの配列
    Dim vntArrNotNormalFlg()    As Variant      '通常判定対象外フラグの配列
'## 2004.02.13 Added End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件を満たす判定分類テーブルのレコードを取得
'## 2002.12.27 Mod 1Line By H.Ishihara@FSIT アフターケアコードの追加
'    strStmt = "SELECT JC.JUDCLASSCD, JC.JUDCLASSNAME, JC.ALLJUDFLG" & vbLf & _
              "  FROM JUDCLASS JC" & vbLf & _
              " ORDER BY JC.JUDCLASSCD"
'## 2003.11.23 Mod By T.Takagi@FSIT 聖路加不要項目削除
'    strStmt = "SELECT JC.JUDCLASSCD, JC.JUDCLASSNAME, JC.ALLJUDFLG, JC.AFTERCARECD, JC.ISRORGANDIV" & vbLf & _
              "  FROM JUDCLASS JC" & vbLf & _
              " ORDER BY JC.JUDCLASSCD"
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
    strStmt = "SELECT JC.JUDCLASSCD, JC.JUDCLASSNAME,   JC.ALLJUDFLG,  JC.COMMENTONLY," & vbLf & _
              "       JC.VIEWORDER,  JC.RESULTDISPMODE, JC.NOTAUTOFLG, JC.NOTNORMALFLG" & vbLf & _
              "  FROM JUDCLASS JC" & vbLf & _
              " ORDER BY JC.JUDCLASSCD"
'## 2004.02.13 Mod End
'## 2003.11.23 Mod End
'## 2002.12.27 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objAllJudFlg = objFields("ALLJUDFLG")
'## 2003.11.23 Del By T.Takagi@FSIT 聖路加不要項目削除
'        Set objAfterCareCd = objFields("AFTERCARECD")
'        Set objIsrOrganDiv = objFields("ISRORGANDIV")
'## 2003.11.23 Del End
        Set objCommentOnly = objFields("COMMENTONLY")
    
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
        Set objViewOrder = objFields("VIEWORDER")
        Set objResultDispMode = objFields("RESULTDISPMODE")
        Set objNotAutoFlg = objFields("NOTAUTOFLG")
        Set objNotNormalFlg = objFields("NOTNORMALFLG")
'## 2004.02.13 Mod End
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrAllJudFlg(lngCount)
            ReDim Preserve vntArrAfterCareCd(lngCount)
            ReDim Preserve vntArrIsrOrganDiv(lngCount)
            ReDim Preserve vntArrCommentOnly(lngCount)
'## 2004.02.13 Added By H.Ishihara@FSIT 聖路加専用項目の追加
            ReDim Preserve vntArrViewOrder(lngCount)
            ReDim Preserve vntArrResultDispMode(lngCount)
            ReDim Preserve vntArrNotAutoFlg(lngCount)
            ReDim Preserve vntArrNotNormalFlg(lngCount)
'## 2004.02.13 Added End
            
            vntArrJudClassCd(lngCount) = objJudClassCd.Value
            vntArrJudClassName(lngCount) = objJudClassName.Value
            vntArrAllJudFlg(lngCount) = objAllJudFlg.Value
'## 2003.11.23 Mod By T.Takagi@FSIT 聖路加不要項目削除
'            vntArrAfterCareCd(lngCount) = objAfterCareCd.Value & ""
'            vntArrIsrOrganDiv(lngCount) = objIsrOrganDiv.Value & ""
            vntArrAfterCareCd(lngCount) = ""
            vntArrIsrOrganDiv(lngCount) = ""
'## 2003.11.23 Mod End
            vntArrCommentOnly(lngCount) = objCommentOnly.Value & ""
            
'## 2004.02.13 Added By H.Ishihara@FSIT 聖路加専用項目の追加
            vntArrViewOrder(lngCount) = objViewOrder.Value & ""
            vntArrResultDispMode(lngCount) = objResultDispMode.Value & ""
            vntArrNotAutoFlg(lngCount) = objNotAutoFlg.Value & ""
            vntArrNotNormalFlg(lngCount) = objNotNormalFlg.Value & ""
'## 2004.02.13 Added End
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
    End If
    
    '戻り値の設定
    vntJudClassCd = vntArrJudClassCd
    vntJudClassName = vntArrJudClassName
    If IsMissing(vntAllJudFlg) = False Then vntAllJudFlg = vntArrAllJudFlg
    If IsMissing(vntAfterCareCd) = False Then vntAfterCareCd = vntArrAfterCareCd
    If IsMissing(vntIsrOrganDiv) = False Then vntIsrOrganDiv = vntArrIsrOrganDiv
    If IsMissing(vntCommentOnly) = False Then vntCommentOnly = vntArrCommentOnly
    
'## 2004.02.13 Added By H.Ishihara@FSIT 聖路加専用項目の追加
    If IsMissing(vntViewOrder) = False Then vntViewOrder = vntArrViewOrder
    If IsMissing(vntResultDispMode) = False Then vntResultDispMode = vntArrResultDispMode
    If IsMissing(vntNotAutoFlg) = False Then vntNotAutoFlg = vntArrNotAutoFlg
    If IsMissing(vntNotNormalFlg) = False Then vntNotNormalFlg = vntArrNotNormalFlg
'## 2004.02.13 Added End
    
    SelectJudClassList = lngCount
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudClass.SelectJudClassList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 判定分類コードに対する判定分類名を取得する
'
' 引数　　 : (In)     strJudClassCd    判定分類コード
' 　　　　 : (Out)    vntJudClassName  判定分類名
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectJudClassName(ByVal strJudClassCd As String, ByRef vntJudClassName As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objJudClassName As OraField         '判定分類名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strJudClassCd) = "" Then
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCLASSCD", Trim(strJudClassCd), ORAPARM_INPUT
    
    '検索条件を満たす判定分類テーブルのレコードを取得
    strStmt = "SELECT JUDCLASSNAME FROM JUDCLASS WHERE JUDCLASSCD = :JUDCLASSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassName = objFields("JUDCLASSNAME")
    
        '戻り値の設定
        vntJudClassName = objJudClassName.Value & ""
        
        SelectJudClassName = True
        
    End If
    
    Set objOraDyna = Nothing
        
    'キー値の解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudClass.SelectJudClassName"
    
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
' 機能　　 : 判定分類コードに対する情報を取得する
'
' 引数　　 : (In)     strJudClassCd    判定分類コード
' 　　　　 : (Out)    vntJudClassName  判定分類名
' 　　　　 : (Out)    vntAllJudFlg     統計用総合判定フラグ（省略可）
' 　　　　 : (Out)    vntAfterCareCd   アフターケアコード
' 　　　　 : (Out)    vntCommentOnly    コメント表示モード
' 　　　　 : (Out)    vntViewOrder      判定分類表示順
' 　　　　 : (Out)    vntResultDispMode 検査結果表示モード（判定リンク用）
' 　　　　 : (Out)    vntNotAutoFlg     自動判定対象外フラグ
' 　　　　 : (Out)    vntNotNormalFlg   通常判定対象外フラグ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectJudClass(ByVal strJudClassCd As String, _
                               ByRef vntJudClassName As Variant, _
                               Optional ByRef vntAllJudFlg As Variant, _
                               Optional ByRef vntAfterCareCd As Variant, _
                               Optional ByRef vntIsrOrganDiv As Variant, _
                               Optional ByRef vntCommentOnly As Variant, _
                               Optional ByRef vntViewOrder As Variant, _
                               Optional ByRef vntResultDispMode As Variant, _
                               Optional ByRef vntNotAutoFlg As Variant, _
                               Optional ByRef vntNotNormalFlg As Variant _
                               ) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objJudClassName As OraField         '判定分類名
    Dim objAllJudFlg    As OraField         '統計用総合判定フラグ
'## 2003.11.25 Del By T.Takagi@FSIT 聖路加不要項目削除
''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT アフターケアコードの追加
'    Dim objAfterCareCd  As OraField         'アフターケアコード
''## 2002.11.10 Mod End
'    Dim objIsrOrganDiv  As OraField         '健保用器官区分文字列
'## 2003.11.25 Del End
    
'## 2004.02.13 Added 4Lines By H.Ishihara@FSIT 聖路加専用項目の追加
    Dim objCommentOnly          As OraField     'コメント表示モード
    Dim objViewOrder            As OraField      '判定分類表示順
    Dim objResultDispMode       As OraField      '検査結果表示モード（判定リンク用）
    Dim objNotAutoFlg           As OraField      '自動判定対象外フラグ
    Dim objNotNormalFlg         As OraField      '通常判定対象外フラグ
'## 2004.02.13 Added End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strJudClassCd) = "" Then
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCLASSCD", Trim(strJudClassCd), ORAPARM_INPUT
    
    '検索条件を満たす判定分類テーブルのレコードを取得
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT アフターケアコードの追加
'    strStmt = "SELECT JUDCLASSNAME, ALLJUDFLG FROM JUDCLASS WHERE JUDCLASSCD = :JUDCLASSCD"
'## 2003.11.25 Mod By T.Takagi@FSIT 聖路加不要項目削除
'    strStmt = "SELECT JUDCLASSNAME, ALLJUDFLG, AFTERCARECD, ISRORGANDIV FROM JUDCLASS WHERE JUDCLASSCD = :JUDCLASSCD"
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
'    strStmt = "SELECT JUDCLASSNAME, ALLJUDFLG FROM JUDCLASS WHERE JUDCLASSCD = :JUDCLASSCD"
    strStmt = "SELECT JC.JUDCLASSCD, JC.JUDCLASSNAME,   JC.ALLJUDFLG,  JC.COMMENTONLY," & vbLf & _
              "       JC.VIEWORDER,  JC.RESULTDISPMODE, JC.NOTAUTOFLG, JC.NOTNORMALFLG" & vbLf & _
              "  FROM JUDCLASS JC" & vbLf & _
              "  WHERE JUDCLASSCD = :JUDCLASSCD"
'## 2004.02.13 Mod End
'## 2003.11.25 Mod End
'## 2002.11.10 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objAllJudFlg = objFields("ALLJUDFLG")
'## 2003.11.25 Del By T.Takagi@FSIT 聖路加不要項目削除
'        Set objIsrOrganDiv = objFields("ISRORGANDIV")
'## 2003.11.25 Del End

'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
        Set objCommentOnly = objFields("COMMENTONLY")
        Set objViewOrder = objFields("VIEWORDER")
        Set objResultDispMode = objFields("RESULTDISPMODE")
        Set objNotAutoFlg = objFields("NOTAUTOFLG")
        Set objNotNormalFlg = objFields("NOTNORMALFLG")
'## 2004.02.13 Mod End
    
        '戻り値の設定
        vntJudClassName = objJudClassName.Value & ""
        If IsMissing(vntAllJudFlg) = False Then vntAllJudFlg = objAllJudFlg.Value & ""
'## 2003.11.25 Del By T.Takagi@FSIT 聖路加不要項目削除
''## 2002.11.10 Add 1Line By H.Ishihara@FSIT アフターケアコードの追加
'        If IsMissing(vntAfterCareCd) = False Then vntAfterCareCd = objFields("AFTERCARECD") & ""
''## 2002.11.10 Add End
'        If IsMissing(vntIsrOrganDiv) = False Then vntIsrOrganDiv = objFields("ISRORGANDIV") & ""
'## 2003.11.25 Del End
        
'## 2004.02.13 Added By H.Ishihara@FSIT 聖路加専用項目の追加
    If IsMissing(vntCommentOnly) = False Then vntCommentOnly = objCommentOnly.Value & ""
    If IsMissing(vntViewOrder) = False Then vntViewOrder = objViewOrder.Value & ""
    If IsMissing(vntResultDispMode) = False Then vntResultDispMode = objResultDispMode.Value & ""
    If IsMissing(vntNotAutoFlg) = False Then vntNotAutoFlg = objNotAutoFlg.Value & ""
    If IsMissing(vntNotNormalFlg) = False Then vntNotNormalFlg = objNotNormalFlg.Value & ""
'## 2004.02.13 Added End
        
        SelectJudClass = True
        
    End If
    
    Set objOraDyna = Nothing
        
    'キー値の解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudClass.SelectJudClass"
    
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
' 機能　　 : 判定分類レコードを登録する（トランザクション対応）
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    intJudClassCd      判定分類コード
' 　　　　   (In)    strJudClassName    判定分類名
' 　　　　   (In)    intAllJudFlg       統計用総合判定フラグ
' 　　　　   (In)    strAfterCareCd     アフターケアコード
' 　　　　   (In)    intItemCount       更新検査項目数
' 　　　　   (In)    vntItemCd          検査項目コード
' 　　　　   (In)    strCommentOnly     コメント表示モード
' 　　　　   (In)    strViewOrder       判定分類表示順
' 　　　　   (In)    strResultDispMode  検査結果表示モード（判定リンク用）
' 　　　　   (In)    strNotAutoFlg      自動判定対象外フラグ
' 　　　　   (In)    strNotNormalFlg    通常判定対象外フラグ
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :　コーステーブルとコース内項目テーブルを１回で登録しちゃうよ
'
Public Function RegistJudClass_All(ByVal strMode As String, _
                                   ByVal intJudClassCd As Integer, _
                                   ByVal strJudClassName As String, _
                                   ByVal intAllJudFlg As Integer, _
                                   ByVal strAfterCareCd As String, _
                                   ByVal intItemCount As Integer, _
                                   ByVal vntItemCd As Variant, _
                                   ByVal strIsrOrganDiv As String, _
                                   ByVal strCommentOnly As String, _
                                   ByVal strViewOrder As String, _
                                   ByVal strResultDispMode As String, _
                                   ByVal strNotAutoFlg As String, _
                                   ByVal strNotNormalFlg As String _
                                   ) As Long
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim Ret         As Long             '関数戻り値
    
    Ret = INSERT_ERROR
    
    Do
        
        '判定分類テーブルの更新
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT アフターケアコードの追加
'        Ret = RegistJudClass(strMode, _
                             intJudClassCd, _
                             strJudClassName, _
                             intAllJudFlg)
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
'        Ret = RegistJudClass(strMode, _
                             intJudClassCd, _
                             strJudClassName, _
                             intAllJudFlg, _
                             strAfterCareCd, _
                             strIsrOrganDiv)
        Ret = RegistJudClass(strMode, _
                             intJudClassCd, _
                             strJudClassName, _
                             intAllJudFlg, _
                             strAfterCareCd, _
                             strIsrOrganDiv, _
                             strCommentOnly, _
                             strViewOrder, _
                             strResultDispMode, _
                             strNotAutoFlg, _
                             strNotNormalFlg)
'## 2004.02.13 Mod End
'## 2002.11.10 Mod End

        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
                         
        '判定分類検査項目テーブルの更新
        Ret = RegistJudClass_Item(intJudClassCd, _
                                  intItemCount, _
                                  vntItemCd)
        
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
    RegistJudClass_All = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistJudClass_All = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "JudClass.RegistJudClass_All"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 判定分類テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    intJudClassCd      判定分類コード
' 　　　　   (In)    strJudClassName    判定分類名
' 　　　　   (In)    intAllJudFlg       統計用総合判定フラグ
' 　　　　   (In)    strAfterCareFlg    アフターケアフラグ
' 　　　　   (In)    strCommentOnly     コメント表示モード
' 　　　　   (In)    strViewOrder       判定分類表示順
' 　　　　   (In)    strResultDispMode  検査結果表示モード（判定リンク用）
' 　　　　   (In)    strNotAutoFlg      自動判定対象外フラグ
' 　　　　   (In)    strNotNormalFlg    通常判定対象外フラグ
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistJudClass(ByVal strMode As String, _
                               ByVal intJudClassCd As Integer, _
                               ByVal strJudClassName As String, _
                               ByVal intAllJudFlg As Integer, _
                               ByVal strAfterCareCd As String, _
                               ByVal strIsrOrganDiv As String, _
                               ByVal strCommentOnly As String, _
                               ByVal strViewOrder As String, _
                               ByVal strResultDispMode As String, _
                               ByVal strNotAutoFlg As String, _
                               ByVal strNotNormalFlg As String _
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
    objOraParam.Add "JudClassCD", Trim(intJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JudClassNAME", Trim(strJudClassName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "AllJudFlg", Trim(intAllJudFlg), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.11.25 Del By T.Takagi@FSIT 聖路加不要項目削除
''## 2002.11.10 Add 1Line By H.Ishihara@FSIT アフターケアコードの追加
'    objOraParam.Add "AfterCareCd", Trim(strAfterCareCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
''## 2002.11.10 Add End
'    objOraParam.Add "IsrOrganDiv", Trim(strIsrOrganDiv), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.11.25 Del By T.Takagi@FSIT 聖路加不要項目削除

'## 2004.02.13 Add By H.Ishihara@FSIT 聖路加専用項目の追加
    objOraParam.Add "COMMENTONLY", Trim(strCommentOnly), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "VIEWORDER", Trim(strViewOrder), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RESULTDISPMODE", Trim(strResultDispMode), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NOTAUTOFLG", Trim(strNotAutoFlg), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NOTNORMALFLG", Trim(strNotNormalFlg), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.02.13 Add End

    Do
        '判定分類テーブルレコードの更新
        If strMode = "UPD" Then
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT アフターケアコードの追加
'            strStmt = "UPDATE JUDCLASS " & _
                      "   SET JUDCLASSNAME = :JudClassNAME," & _
                      "       ALLJUDFLG    = :AllJudFlg" & _
                      " WHERE JUDCLASSCD   = :JudClassCD"
'## 2003.11.25 Mod By T.Takagi@FSIT 聖路加不要項目削除
'            strStmt = "UPDATE JUDCLASS " & _
'                      "   SET JUDCLASSNAME = :JudClassNAME," & _
'                      "       ALLJUDFLG    = :AllJudFlg," & _
'                      "       AFTERCARECD  = :AfterCareCd," & _
'                      "       ISRORGANDIV  = :IsrOrganDiv" & _
'                      " WHERE JUDCLASSCD   = :JudClassCD"
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
'            strStmt = "UPDATE JUDCLASS " & _
                      "   SET JUDCLASSNAME = :JudClassNAME, " & _
                      "       ALLJUDFLG    = :AllJudFlg     " & _
                      " WHERE JUDCLASSCD   = :JudClassCD    "
            strStmt = "UPDATE JUDCLASS " & _
                      "   SET JUDCLASSNAME   = :JudClassNAME,  " & _
                      "       ALLJUDFLG      = :AllJudFlg,     " & _
                      "       COMMENTONLY    = :COMMENTONLY,   " & _
                      "       VIEWORDER      = :VIEWORDER,     " & _
                      "       RESULTDISPMODE = :RESULTDISPMODE," & _
                      "       NOTAUTOFLG     = :NOTAUTOFLG,    " & _
                      "       NOTNORMALFLG   = :NOTNORMALFLG      " & _
                      " WHERE JUDCLASSCD   = :JudClassCD       "
'## 2004.02.13 Mod End
'## 2003.11.25 Mod End
'## 2002.11.10 Mod End
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす判定分類テーブルのレコードを取得
        strStmt = "SELECT JUDCLASSCD FROM JUDCLASS WHERE JUDCLASSCD = :JudClassCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT アフターケアコードの追加
'        mobjOraDb.ExecuteSQL "INSERT INTO JUDCLASS (JUDCLASSCD, JUDCLASSNAME, ALLJUDFLG) VALUES (:JudClassCD, :JudClassNAME, :AllJudFlg)"
'## 2003.11.25 Mod By T.Takagi@FSIT 聖路加不要項目削除
'        mobjOraDb.ExecuteSQL "INSERT INTO JUDCLASS (JUDCLASSCD, JUDCLASSNAME, ALLJUDFLG, AFTERCARECD, ISRORGANDIV) VALUES (:JudClassCD, :JudClassNAME, :AllJudFlg, :AFTERCARECD, :ISRORGANDIV)"
'## 2004.02.13 Mod By H.Ishihara@FSIT 聖路加専用項目の追加
'        mobjOraDb.ExecuteSQL "INSERT INTO JUDCLASS (JUDCLASSCD, JUDCLASSNAME, ALLJUDFLG ) VALUES (:JudClassCD, :JudClassNAME, :AllJudFlg)"
        mobjOraDb.ExecuteSQL "INSERT INTO JUDCLASS (JUDCLASSCD, JUDCLASSNAME, ALLJUDFLG, COMMENTONLY, VIEWORDER, RESULTDISPMODE, NOTAUTOFLG, NOTNORMALFLG ) VALUES (:JudClassCD, :JudClassNAME, :AllJudFlg, :COMMENTONLY, :VIEWORDER, :RESULTDISPMODE, :NOTAUTOFLG, :NOTNORMALFLG)"
'## 2004.02.13 Mod End
'## 2003.11.25 Mod End
'## 2002.11.10 Mod End
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistJudClass = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistJudClass = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "JudClass.RegistJudClass"
    
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
' 機能　　 : 判定分類内検査項目を登録する
'
' 引数　　 : (In)    intJudClassCd  判定分類コード
' 　　　　   (In)    intItemCount   更新検査項目数
' 　　　　   (In)    vntItemCd      検査項目コード
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 : # 本来は依頼項目管轄だが、判定分類からの更新もサポート
'
Public Function RegistJudClass_Item(ByVal intJudClassCd As Integer, _
                                    ByVal intItemCount As Integer, _
                                    ByVal vntItemCd As Variant) As Long
                               
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    Dim objJudClassCd   As OraParamArray    '判定分類コード
    Dim objItemCd       As OraParamArray    '検査項目コード
    Dim i               As Integer
    Dim Ret             As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JudClassCd", Trim(intJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '判定分類内検査項目レコードの削除
    mobjOraDb.ExecuteSQL "DELETE ITEM_JUD WHERE JUDCLASSCD = :JudClassCd"
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "JudClassCd"
        objOraParam.AddTable "JudClassCd", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, LENGTH_JUDCLASS_JUDCLASSCD
        objOraParam.AddTable "ItemCd", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        
        'OraParameterオブジェクトの参照設定
        Set objJudClassCd = objOraParam("JudClassCd")
        Set objItemCd = objOraParam("ItemCd")
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objJudClassCd(i) = intJudClassCd
            objItemCd(i) = vntItemCd(i)
        Next i
        
        '新規挿入
        strStmt = ""
        strStmt = strStmt & "INSERT INTO ITEM_JUD (ItemCd, JudClassCd) VALUES (:ITEMCD, :JudClassCd)"
    
        mobjOraDb.ExecuteSQL strStmt
    
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Ret = INSERT_NORMAL
    
    '戻り値の設定
    RegistJudClass_Item = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistJudClass_Item = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "JudClass.RegistJudClass_Item"
    
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
' 機能　　 : 判定分類テーブルレコードを削除する
'
' 引数　　 : (In)    intJudClassCd    判定分類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteJudClass(ByVal intJudClassCd As Integer) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JudClassCD", Trim(intJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER

    '判定分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE JUDCLASS WHERE JUDCLASSCD = :JudClassCD"
    
    'バインド変数の削除
    objOraParam.Remove "JudClassCD"
    
    '戻り値の設定
    DeleteJudClass = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteJudClass = False

    'イベントログ書き込み
    WriteErrorLog "JudClass.DeleteJudClass"
    
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
' 機能　　 : 判定分類に合致する検査項目の一覧を取得する
'
' 引数　　 : (In)     vntJudClassCd   判定分類コード
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntSuffix       サフィックス（省略可能）
' 　　　　 : (Out)    vntItemName     検査項目名（省略可能）
' 　　　　 : (Out)    vntClassName    検査分類名（省略可能）
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :　サフィックスが指定されていない場合は、依頼項目ベースで返す
'
Public Function SelectJudClassItemList(ByVal vntJudClassCd As Variant, _
                                       ByRef vntItemCd As Variant, _
                                       Optional ByRef vntSuffix As Variant, _
                                       Optional ByRef vntItemName As Variant, _
                                       Optional ByRef vntClassName As Variant _
                                      ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'グループコード
    Dim objItemName         As OraField         'グループコード
    Dim objClassName        As OraField         '検査分類名
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrClassName()   As Variant          '検査分類名の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCLASSCD", Trim(vntJudClassCd), ORAPARM_INPUT
    
    '検索条件を満たす検査項目テーブルのレコードを取得
'    strStmt = "SELECT IC.ITEMCD, IC.SUFFIX, IC.ITEMNAME " & vbLf & _
              "  FROM ITEM_JUD IJ, ITEM_C IC            " & vbLf & _
              " WHERE IJ.JUDCLASSCD = :JUDCLASSCD       " & vbLf & _
              "   AND IJ.ITEMCD     = IC.ITEMCD         " & vbLf & _
              " ORDER BY IC.ITEMCD, IC.SUFFIX           "
    
    If IsMissing(vntSuffix) = True Then
        
        '依頼項目で検索する場合
        
        If IsMissing(vntClassName) = True Then
            '検査分類名の指定がない場合
            strStmt = "SELECT IC.ITEMCD, IC.REQUESTNAME ITEMNAME" & vbLf & _
                      "  FROM ITEM_JUD IJ, ITEM_P IC" & vbLf & _
                      " WHERE IJ.JUDCLASSCD = :JUDCLASSCD" & vbLf & _
                      "   AND IJ.ITEMCD     = IC.ITEMCD" & vbLf & _
                      " ORDER BY IC.ITEMCD"
        Else
            '検査分類名の指定がある場合
            strStmt = "SELECT IC.ITEMCD, IC.REQUESTNAME ITEMNAME, CS.CLASSNAME" & vbLf & _
                      "  FROM ITEMCLASS CS, ITEM_JUD IJ, ITEM_P IC" & vbLf & _
                      " WHERE IJ.JUDCLASSCD = :JUDCLASSCD" & vbLf & _
                      "   AND IJ.ITEMCD     = IC.ITEMCD" & vbLf & _
                      "   AND CS.CLASSCD    = IC.CLASSCD" & vbLf & _
                      " ORDER BY IC.ITEMCD"
        End If
    
    Else
        '検査項目で検索する場合
        
        If IsMissing(vntClassName) = True Then
        
            '検査分類名の指定がない場合
            strStmt = "SELECT IC.ITEMCD, IC.SUFFIX, IC.ITEMNAME" & vbLf & _
                      "  FROM ITEM_JUD IJ, ITEM_C IC" & vbLf & _
                      " WHERE IJ.JUDCLASSCD = :JUDCLASSCD" & vbLf & _
                      "   AND IJ.ITEMCD     = IC.ITEMCD" & vbLf & _
                      " ORDER BY IC.ITEMCD, IC.SUFFIX"
        Else
        
            '検査分類名の指定がある場合
            strStmt = "SELECT IC.ITEMCD, IC.SUFFIX, IC.ITEMNAME, CS.CLASSNAME" & vbLf & _
                      "  FROM ITEMCLASS CS, ITEM_JUD IJ, ITEM_C IC" & vbLf & _
                      " WHERE IJ.JUDCLASSCD = :JUDCLASSCD" & vbLf & _
                      "   AND IJ.ITEMCD     = IC.ITEMCD" & vbLf & _
                      "   AND CS.CLASSCD    = IC.CLASSCD" & vbLf & _
                      " ORDER BY IC.ITEMCD, IC.SUFFIX"
        
        End If
        
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objItemName = objFields("ITEMNAME")
        
        If IsMissing(vntSuffix) = False Then
            Set objSuffix = objFields("SUFFIX")
        End If
        If IsMissing(vntClassName) = False Then
            Set objClassName = objFields("CLASSNAME")
        End If
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            '配列拡張
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            If IsMissing(vntSuffix) = False Then
                ReDim Preserve vntArrSuffix(lngCount)
            End If
            If IsMissing(vntClassName) = False Then
                ReDim Preserve vntArrClassName(lngCount)
            End If
            
            '値セット
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrItemName(lngCount) = objItemName.Value
            If IsMissing(vntSuffix) = False Then
                vntArrSuffix(lngCount) = objSuffix.Value
            End If
            If IsMissing(vntClassName) = False Then
                vntArrClassName(lngCount) = objClassName.Value
            End If
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntItemName = vntArrItemName
    If IsMissing(vntSuffix) = False Then
        vntSuffix = vntArrSuffix
    End If
    If IsMissing(vntClassName) = False Then
        vntClassName = vntArrClassName
    End If
    
    SelectJudClassItemList = lngCount
    
    'バインド変数の削除
    objOraParam.Remove "JudClassCD"
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudClass.SelectJudClassItemList"
    
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
' 機能　　 : 指定の予約番号リストから総合判定件数の最大値を取得する
'
' 引数　　 : (In)     vntArrRsvNo           予約番号リスト
'
' 戻り値　 : 総合判定件数の最大値
'
' 備考　　 :
'

Public Function SelectJudClassMaxCount(ByRef vntArrRsvNo As Variant) As Long

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objMaxCount         As OraField         '検索結果
    
    Dim objCommon           As Common           '共通クラス
    
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '予約番号リストがEmptyの場合は処理を終了する
    If IsEmpty(vntArrRsvNo) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'SQL文の編集
    strStmt = "SELECT MAX(CNT)                                                         " & vbLf & _
              "  FROM ( SELECT J.RSVNO, COUNT(*) CNT                                   " & vbLf & _
              "           FROM JUDRSL J                                                "
    'WHERE句の作成
    If UBound(vntArrRsvNo) = 0 Then
        '1件のみの検索
        strStmt = strStmt & vbLf & _
              "          WHERE J.RSVNO = " & vntArrRsvNo(0)
    Else
        strStmt = strStmt & vbLf & _
              "          WHERE J.RSVNO IN ("
        '複数件の検索
        For i = 0 To UBound(vntArrRsvNo)
            If i > 0 Then
                strStmt = strStmt & ","
            End If
            strStmt = strStmt & vntArrRsvNo(i)
        Next
        strStmt = strStmt & ")"
    End If
    strStmt = strStmt & vbLf & _
              "          GROUP BY J.RSVNO                                              " & vbLf & _
              "       )                                                                "
    
    '検索条件を満たす判定結果テーブルのレコードを取得
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合は件数を戻り値として設定
    '(MAX関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        SelectJudClassMaxCount = IIf(IsNull(objOraDyna.Fields(0).Value), 0, objOraDyna.Fields(0).Value)
    End If
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudClass.SelectJudClassMaxCount"
    
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
