VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Sentence"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 文章分類テーブルレコードを削除する
'
' 引数　　 : (In)    strStcClassCd    文章分類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteStcClass(ByVal strStcClassCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STCCLASSCD", Trim(strStcClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '文章分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE STCCLASS WHERE STCCLASSCD = :STCCLASSCD"
    
    'バインド変数の削除
    objOraParam.Remove "STCCLASSCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteStcClass = True

    Exit Function
    
ErrorHandle:

    DeleteStcClass = False

    'イベントログ書き込み
    WriteErrorLog "StcClass.DeleteStcClass"
    
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
' 機能　　 : 文章分類テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strStcClassCd      文章分類コード
' 　　　　   (In)    strStcClassName    文章分類名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistStcClass(ByVal strMode As String, _
                               ByVal strStcClassCd As String, _
                               ByVal strStcClassName As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STCCLASSCD", Trim(strStcClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STCCLASSNAME", Trim(strStcClassName), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '文章分類テーブルレコードの更新
        If strMode = "UPD" Then
            Ret = mobjOraDb.ExecuteSQL("UPDATE STCCLASS SET STCCLASSNAME = :STCCLASSNAME WHERE STCCLASSCD = :STCCLASSCD")
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす文章分類テーブルのレコードを取得
        strStmt = "SELECT STCCLASSNAME FROM STCCLASS WHERE STCCLASSCD = :STCCLASSCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO STCCLASS (STCCLASSCD, STCCLASSNAME) VALUES (:STCCLASSCD, :STCCLASSNAME)"
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    objOraParam.Remove "STCCLASSCD"
    objOraParam.Remove "STCCLASSNAME"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistStcClass = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistStcClass = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "StcClass.RegistStcClass"
    
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
' 機能　　 : 文章分類コードに対する文章分類名を取得する
'
' 引数　　 : (In)     strStcClassCd    文章分類コード
' 　　　　   (Out)    vntStcClassName  文章分類名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectStcClass(ByVal strStcClassCd As String, ByRef vntStcClassName As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objStcClassName As OraField         '文章分類名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STCCLASSCD", Trim(strStcClassCd), ORAPARM_INPUT
    
    '検索条件を満たす文章分類テーブルのレコードを取得
    strStmt = "SELECT STCCLASSNAME FROM STCCLASS WHERE STCCLASSCD = :STCCLASSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStcClassName = objFields("STCCLASSNAME")
    
        '戻り値の設定
        vntStcClassName = objStcClassName.Value
        
        SelectStcClass = True
        
    End If
    
    'バインド変数の削除
    objOraParam.Remove "STCCLASSCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "StcClass.SelectStcClass"
    
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
' 機能　　 : 文章分類の一覧を取得する
'
' 引数　　 : (Out)    vntStcClassCd    文章分類コード
' 　　　　   (Out)    vntStcClassName  文章分類名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectStcClassItemList(ByRef vntStcClassCd As Variant, ByRef vntStcClassName As Variant) As Long

    Dim objOraDyna              As OraDynaset   'ダイナセット
    Dim strStmt                 As String       'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    Dim objStcClassCd           As OraField     '文章分類コード
    Dim objStcClassName         As OraField     '文章分類名
    
    Dim vntArrStcClassCd()      As Variant      '文章分類コードの配列
    Dim vntArrStcClassName()    As Variant      '文章分類名の配列
    Dim lngCount                As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStcClassCd = Empty
    vntStcClassName = Empty
    lngCount = 0
    
    '文章分類テーブルの全レコードを取得
    strStmt = "SELECT STCCLASSCD, STCCLASSNAME " & vbLf & _
              "  FROM STCCLASS             " & vbLf & _
              " ORDER BY STCCLASSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStcClassCd = objFields("STCCLASSCD")
        Set objStcClassName = objFields("STCCLASSNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrStcClassCd(lngCount)
            ReDim Preserve vntArrStcClassName(lngCount)
            vntArrStcClassCd(lngCount) = objStcClassCd.Value
            vntArrStcClassName(lngCount) = objStcClassName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntStcClassCd = vntArrStcClassCd
        vntStcClassName = vntArrStcClassName
    
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectStcClassItemList = lngCount
        
    Exit Function
    
ErrorHandle:

    SelectStcClassItemList = -1
    
    'イベントログ書き込み
    WriteErrorLog "StcClass.SelectStcClassItemList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 最近使った文章の一覧を取得する
'
' 引数　　 : (In)     strItemCd   検査項目コード
' 　　　　 : (In)     lngItemType 項目タイプ
' 　　　　 : (Out)    vntStcCd    文章コード
' 　　　　 : (Out)    vntShortStc 略文章
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectRecentSentenceList(ByVal strItemCd As String, _
                                         ByVal lngItemType As Long, _
                                         ByRef vntStcCd As Variant, _
                                         ByRef vntShortStc As Variant _
                                        ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objStcCd            As OraField         '文章コード
    Dim objShortStc         As OraField         '略文章
    
    Dim vntArrStcCd()       As Variant          '文章コードの配列
    Dim vntArrShortStc()    As Variant          '略文章の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStcCd = Empty
    vntShortStc = Empty
    SelectRecentSentenceList = 0
    lngCount = 0
    
    '検索条件が設定されていない場合はエラー
    If Trim(strItemCd) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
'## 項目タイプの引数チェックはしない（不正なら検索できないだけ）
'## If lngItemType < ITEMTYPE_MINVALUE Or lngItemType > ITEMTYPE_MAXVALUE Then
'##     Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
'##     Exit Function
'## End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMTYPE", lngItemType, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '文章テーブルよりレコードを取得
    strStmt = "SELECT DISTINCT rs.STCCD, st.SHORTSTC, " & vbLf & _
              "                rs.ALWAYSUSE           " & vbLf & _
              "  FROM RECENT_SENTENCE rs, SENTENCE st " & vbLf & _
              "  WHERE rs.ITEMCD   = :ITEMCD          " & vbLf & _
              "    AND rs.ITEMTYPE = :ITEMTYPE        " & vbLf & _
              "    AND rs.ITEMCD   = st.ITEMCD        " & vbLf & _
              "    AND rs.ITEMTYPE = st.ITEMTYPE      " & vbLf & _
              "    AND rs.STCCD    = st.STCCD         " & vbLf & _
              "  ORDER BY rs.ALWAYSUSE DESC, rs.STCCD "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStcCd = objFields("STCCD")
        Set objShortStc = objFields("SHORTSTC")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrStcCd(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            vntArrStcCd(lngCount) = objStcCd.Value & ""
            vntArrShortStc(lngCount) = objShortStc.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntStcCd = vntArrStcCd
    vntShortStc = vntArrShortStc
    SelectRecentSentenceList = lngCount
        
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Sentence.SelectRecentSentenceList"

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
' 機能　　 : 文章の一覧を取得する
'
' 引数　　 : (In)     strItemCd         検査項目コード
' 　　　　 : (In)     lngItemType       項目タイプ
' 　　　　 : (In)     vntStcCd          文章コード
' 　　　　 : (Out)    vntShortStc       略文章
' 　　　　 : (Out)    vntLongStc        文章（省略可）
' 　　　　 : (Out)    vntEngStc         英語文章（省略可）
' 　　　　 : (Out)    vntStcClassCd     文章分類コード
' 　　　　 : (Out)    vntInsStc         検査連携用変換文章
' 　　　　 : (Out)    vntViewOrder      表示順番
' 　　　　 : (Out)    vntPrintOrder     成績書出力順番
' 　　　　 : (Out)    vntImageFileName  イメージファイル名
' 　　　　 : (Out)    vntQuestionRank   問診表示ランク
' 　　　　 : (Out)    vntDelFlg         未使用フラグ
' #### 2004.01.02 add start
' 　　　　 : (In)     vntSearchMode     デフォルト＝０：引数の検査項目コードで取得
'                                                   １：文章参照コードで取得
' 　　　　 : (In)     vntSuffix         サフィックス
' #### 2004.01.02 add end
'### 2004/01/15 Added by Ishihara@FSIT 報告書用文章追加
' 　　　　 : (Out)    vntReptStc        報告書用文章
'### 2004/01/15 Added End
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectSentence(ByVal strItemCd As String, _
                               ByVal lngItemType As Long, _
                               ByVal strStcCd As String, _
                               ByRef vntShortStc As Variant, _
                               Optional ByRef vntLongStc As Variant, _
                               Optional ByRef vntEngStc As Variant, _
                               Optional ByRef vntStcClassCd As Variant, _
                               Optional ByRef vntInsStc As Variant, _
                               Optional ByRef vntViewOrder As Variant, _
                               Optional ByRef vntPrintOrder As Variant, _
                               Optional ByRef vntImageFileName As Variant, _
                               Optional ByRef vntQuestionRank As Variant, _
                               Optional ByRef vntDelFlg As Variant, _
                               Optional ByVal vntSearchMode As Variant = 0, _
                               Optional ByVal vntSuffix As Variant, _
                               Optional ByRef vntReptStc As Variant _
                              ) As Boolean
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objShortStc         As OraField         '略文章
    Dim objLongStc          As OraField         '文章
    Dim objEngStc           As OraField         '英語文章
    Dim objStcClassCd       As OraField         '文章分類コード
    Dim objInsStc           As OraField         '検査連携用変換文章
    Dim objViewOrder        As OraField         '表示順番
    Dim objPrintOrder       As OraField         '成績書出力順番
    Dim objImageFileName    As OraField         'イメージファイル名
    Dim objQuestionRank     As OraField         '問診表示ランク
    Dim objDelFlg           As OraField         '未使用フラグ
'### 2004/01/15 Added by Ishihara@FSIT 報告書用文章追加
    Dim objReptStc          As OraField         '報告書用文章
'### 2004/01/15 Added by Ishihara@FSIT 報告書用文章追加
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合はエラー
    If Trim(strItemCd) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMTYPE", lngItemType, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STCCD", Trim(strStcCd), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '文章テーブルよりレコードを取得
    ' #### 2004.01.02 modify start
'    strStmt = "SELECT SHORTSTC, LONGSTC, ENGSTC, STCCLASSCD, INSSTC,             " & vbLf & _
'              "       VIEWORDER, PRINTORDER, IMAGEFILENAME, QUESTIONRANK, DELFLG " & vbLf & _
'              "  FROM SENTENCE                  " & vbLf & _
'              "  WHERE ITEMCD   = :ITEMCD       " & vbLf & _
'              "    AND ITEMTYPE = :ITEMTYPE     " & vbLf & _
'              "    AND STCCD    = :STCCD        "
'### 2004/01/15 Modified by Ishihara@FSIT 報告書用文章追加
'    strStmt = "SELECT SENTENCE.SHORTSTC, SENTENCE.LONGSTC, SENTENCE.ENGSTC, " & vbLf & _
              "       SENTENCE.STCCLASSCD, SENTENCE.INSSTC,                 " & vbLf & _
              "       SENTENCE.VIEWORDER, SENTENCE.PRINTORDER,              " & vbLf & _
              "       SENTENCE.IMAGEFILENAME, SENTENCE.QUESTIONRANK,        " & vbLf & _
              "       SENTENCE.DELFLG                                       "
    strStmt = "SELECT SENTENCE.SHORTSTC, SENTENCE.LONGSTC, SENTENCE.ENGSTC, " & vbLf & _
              "       SENTENCE.STCCLASSCD, SENTENCE.INSSTC,                 " & vbLf & _
              "       SENTENCE.VIEWORDER, SENTENCE.PRINTORDER,              " & vbLf & _
              "       SENTENCE.IMAGEFILENAME, SENTENCE.QUESTIONRANK,        " & vbLf & _
              "       SENTENCE.DELFLG, SENTENCE.REPTSTC                     "
'### 2004/01/15 Modified End
    
    '引数の検査項目で検索
    If vntSearchMode = 0 Then
        strStmt = strStmt & vbLf & _
              "  FROM SENTENCE                  " & vbLf & _
              "  WHERE ITEMCD   = :ITEMCD       " & vbLf & _
              "    AND ITEMTYPE = :ITEMTYPE     " & vbLf & _
              "    AND STCCD    = :STCCD        "
    Else
        If Trim(vntSuffix) = "" Then
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        objOraParam.Add "SUFFIX", Trim(vntSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
              "  FROM SENTENCE, ITEM_C                       " & vbLf & _
              "  WHERE ITEM_C.ITEMCD     = :ITEMCD           " & vbLf & _
              "    AND ITEM_C.SUFFIX     = :SUFFIX           " & vbLf & _
              "    AND SENTENCE.ITEMCD   = ITEM_C.STCITEMCD  " & vbLf & _
              "    AND SENTENCE.ITEMTYPE = :ITEMTYPE         " & vbLf & _
              "    AND SENTENCE.STCCD    = :STCCD            "
    End If
    
    ' #### 2004.01.02 modify end
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objShortStc = objFields("SHORTSTC")
        Set objLongStc = objFields("LONGSTC")
        Set objEngStc = objFields("ENGSTC")
        Set objStcClassCd = objFields("STCCLASSCD")
        Set objInsStc = objFields("INSSTC")
        Set objViewOrder = objFields("VIEWORDER")
        Set objPrintOrder = objFields("PRINTORDER")
        Set objImageFileName = objFields("IMAGEFILENAME")
        Set objQuestionRank = objFields("QUESTIONRANK")
        Set objDelFlg = objFields("DELFLG")
'### 2004/01/15 Added by Ishihara@FSIT 報告書用文章追加
        Set objReptStc = objFields("REPTSTC")
'### 2004/01/15 Added End
    
        '戻り値の設定
        vntShortStc = objShortStc.Value
        If Not IsMissing(vntLongStc) Then vntLongStc = objLongStc.Value
        If Not IsMissing(vntEngStc) Then vntEngStc = objEngStc.Value & ""
        If Not IsMissing(vntStcClassCd) Then vntStcClassCd = objStcClassCd.Value & ""
        If Not IsMissing(vntInsStc) Then vntInsStc = objInsStc.Value & ""
        
        If Not IsMissing(vntViewOrder) Then vntViewOrder = objViewOrder.Value & ""
        If Not IsMissing(vntPrintOrder) Then vntPrintOrder = objPrintOrder.Value & ""
        If Not IsMissing(vntImageFileName) Then vntImageFileName = objImageFileName.Value & ""
        If Not IsMissing(vntQuestionRank) Then vntQuestionRank = objQuestionRank.Value & ""
        If Not IsMissing(vntDelFlg) Then vntDelFlg = objDelFlg.Value & ""
'### 2004/01/15 Added by Ishihara@FSIT 報告書用文章追加
        If Not IsMissing(vntReptStc) Then vntReptStc = objReptStc.Value & ""
'### 2004/01/15 Added End
        
        SelectSentence = True
        
    End If
    
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
        'イベントログ書き込み
    WriteErrorLog "Sentence.SelectSentence"

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
' 機能　　 : 文章テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strItemCd          検査項目コード
' 　　　　   (In)    intItemType        検査項目タイプ
' 　　　　   (In)    strStcCd           文章コード
' 　　　　   (In)    strShortStc        略文章
' 　　　　   (In)    strLongStc         文章
' 　　　　   (In)    strEngStc          英語文章
' 　　　　   (In)    strStcClassCd      文章分類コード
' 　　　　   (In)    strInsStc          検査連携用変換文章
' 　　　　   (In)    strViewOrder       表示順番
' 　　　　   (In)    strPrintOrder      成績書出力順番
' 　　　　   (In)    strImageFileName   イメージファイル名
' 　　　　   (In)    strQuestionRank    問診表示ランク
' 　　　　   (In)    strDelFlg          未使用フラグ
'### 2004/01/15 Added by Ishihara@FSIT 報告書用文章追加
' 　　　　   (In)    strReptStc         報告書用文章
'### 2004/01/15 Added End
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistSentence(ByVal strMode As String, _
                               ByVal strItemCd As String, _
                               ByVal intItemType As Integer, _
                               ByVal strStcCd As String, _
                               ByVal strShortStc As String, _
                               ByVal strLongStc As String, _
                               ByVal strEngStc As String, _
                               ByVal strStcClassCd As String, _
                               ByVal strInsStc As String, _
                               ByVal strViewOrder As String, _
                               ByVal strPrintOrder As String, _
                               ByVal strImageFileName As String, _
                               ByVal strQuestionRank As String, _
                               ByVal strDelFlg As String, _
                               ByVal strReptStc As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMTYPE", Trim(intItemType), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STCCD", Trim(strStcCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SHORTSTC", Trim(strShortStc), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LONGSTC", Trim(strLongStc), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENGSTC", Trim(strEngStc), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STCCLASSCD", Trim(strStcClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "INSSTC", Trim(strInsStc), ORAPARM_INPUT, ORATYPE_VARCHAR2

    objOraParam.Add "VIEWORDER", Trim(strViewOrder), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PRINTORDER", Trim(strPrintOrder), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "IMAGEFILENAME", Trim(strImageFileName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "QUESTIONRANK", Trim(strQuestionRank), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DELFLG", Trim(strDelFlg), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004/01/15 Added by Ishihara@FSIT 報告書用文章追加
    objOraParam.Add "REPTSTC", Trim(strReptStc), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004/01/15 Added End

    Do
        '文章テーブルレコードの更新
        If strMode = "UPD" Then
'### 2004/01/15 Modified by Ishihara@FSIT 報告書用文章追加
'            strStmt = "UPDATE SENTENCE " & _
                      "   SET SHORTSTC   = :SHORTSTC," & _
                      "       LONGSTC    = :LONGSTC," & _
                      "       ENGSTC     = :ENGSTC," & _
                      "       STCCLASSCD = :STCCLASSCD," & _
                      "       INSSTC     = :INSSTC," & _
                      "       VIEWORDER     = :VIEWORDER," & _
                      "       PRINTORDER    = :PRINTORDER," & _
                      "       IMAGEFILENAME = :IMAGEFILENAME," & _
                      "       QUESTIONRANK  = :QUESTIONRANK," & _
                      "       DELFLG        = :DELFLG" & _
                      " WHERE ITEMCD     = :ITEMCD" & _
                      "   AND ITEMTYPE   = :ITEMTYPE" & _
                      "   AND STCCD      = :STCCD"
            strStmt = "UPDATE SENTENCE " & _
                      "   SET SHORTSTC      = :SHORTSTC,      " & _
                      "       LONGSTC       = :LONGSTC,       " & _
                      "       ENGSTC        = :ENGSTC,        " & _
                      "       STCCLASSCD    = :STCCLASSCD,    " & _
                      "       INSSTC        = :INSSTC,        " & _
                      "       VIEWORDER     = :VIEWORDER,     " & _
                      "       PRINTORDER    = :PRINTORDER,    " & _
                      "       IMAGEFILENAME = :IMAGEFILENAME, " & _
                      "       QUESTIONRANK  = :QUESTIONRANK,  " & _
                      "       DELFLG        = :DELFLG,        " & _
                      "       REPTSTC       = :REPTSTC        " & _
                      " WHERE ITEMCD     = :ITEMCD            " & _
                      "   AND ITEMTYPE   = :ITEMTYPE          " & _
                      "   AND STCCD      = :STCCD "
'### 2004/01/15 Modified End
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす文章テーブルのレコードを取得
        strStmt = "SELECT ITEMCD FROM SENTENCE WHERE ITEMCD = :ITEMCD AND ITEMTYPE = :ITEMTYPE AND STCCD = :STCCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'### 2004/01/15 Modified by Ishihara@FSIT 報告書用文章追加
'        mobjOraDb.ExecuteSQL "INSERT INTO SENTENCE (ITEMCD, ITEMTYPE, STCCD, SHORTSTC, LONGSTC, ENGSTC, STCCLASSCD, INSSTC, VIEWORDER, PRINTORDER, IMAGEFILENAME, QUESTIONRANK, DELFLG) VALUES (:ITEMCD, :ITEMTYPE, :STCCD, :SHORTSTC, :LONGSTC, :ENGSTC, :STCCLASSCD, :INSSTC, :VIEWORDER, :PRINTORDER, :IMAGEFILENAME, :QUESTIONRANK, :DELFLG)"
        mobjOraDb.ExecuteSQL "INSERT INTO SENTENCE (ITEMCD, ITEMTYPE, STCCD, SHORTSTC, LONGSTC, ENGSTC, STCCLASSCD, INSSTC, VIEWORDER, PRINTORDER, IMAGEFILENAME, QUESTIONRANK, DELFLG, REPTSTC) VALUES (:ITEMCD, :ITEMTYPE, :STCCD, :SHORTSTC, :LONGSTC, :ENGSTC, :STCCLASSCD, :INSSTC, :VIEWORDER, :PRINTORDER, :IMAGEFILENAME, :QUESTIONRANK, :DELFLG, :REPTSTC)"
'### 2004/01/15 Modified End
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
    RegistSentence = Ret

    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Sentence.SelectSentence"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistSentence = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Sentence.RegistSentence", Err.Description

End Function

'
' 機能　　 : 文章テーブルレコードを削除する
'
' 引数　　 : (In)    strItemCd      検査項目コード
' 引数　　 : (In)    intItemType    検査項目タイプ
' 引数　　 : (In)    strStcCd       文章コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteSentence(ByVal strItemCd As String, _
                               ByVal intItemType As Integer, _
                               ByVal strStcCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMTYPE", Trim(intItemType), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STCCD", Trim(strStcCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '文章テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE SENTENCE WHERE ITEMCD = :ITEMCD AND ITEMTYPE = :ITEMTYPE AND STCCD = :STCCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteSentence = True

    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Sentence.DeleteSentence"

    DeleteSentence = False

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Sentence.DeleteSentence", Err.Description

End Function

'
' 機能　　 : 文章の一覧を取得する
'
' 引数　　 : (In)     strItemCd        検査項目コード
' 　　　　 : (In)     lngItemType      項目タイプ
' 　　　　 : (Out)    vntStcCd         文章コード
' 　　　　 : (Out)    vntShortStc      略文章
'
' 　　　　 : ここから下は省略可能
' 　　　　 : (Out)    vntItemCd        検査項目コード（strItemCd未指定時には配列として返す）
' 　　　　 : (Out)    vntItemType      項目タイプ（lngItemType未指定時には配列として返す）
' 　　　　 : (Out)    vntLongStc       正式文章
' 　　　　 : (Out)    vntRequestName   依頼項目名
' 　　　　 : (In)     vntSearchCode    検索用コード（省略可）
' 　　　　 : (In)     vntSearchString  検索用文字列（省略可）
' 　　　　 : (In)     strStcClassCd    文章分類コード
' 　　　　 : (Out)    vntInsStc        検査連携用変換文章
' 　　　　 : (In)     lngSelectMode    選択モード(0:全て、1:表示順番、未使用フラグ対応）
'
' 戻り値　 : レコード件数
'
' 備考　　 :　Inパラメタ未指定時は全部返す。
'
Public Function SelectSentenceList( _
    ByVal strItemCd As String, _
    ByVal lngItemType As Long, _
    ByRef vntStcCd As Variant, _
    ByRef vntShortStc As Variant, _
    Optional ByRef vntItemCd As Variant, _
    Optional ByRef vntItemType As Variant, _
    Optional ByRef vntLongStc As Variant, _
    Optional ByRef vntRequestName As Variant, _
    Optional ByVal vntSearchCode As Variant, _
    Optional ByVal vntSearchString As Variant, _
    Optional ByVal strStcClassCd As String, _
    Optional ByRef vntInsStc As Variant, _
    Optional ByVal lngSelectMode As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objStcCd            As OraField         '文章コード
    Dim objShortStc         As OraField         '略文章
    Dim objItemCd           As OraField         '検査項目コード
    Dim objItemType         As OraField         '項目タイプ
    Dim objLongStc          As OraField         '正式文章
    Dim objRequestName      As OraField         '依頼項目名
    Dim objInsStc           As OraField         '検査連携用変換文章
    
    Dim vntArrStcCd()       As Variant          '文章コードの配列
    Dim vntArrShortStc()    As Variant          '略文章の配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrLongStc()     As Variant          '正式文章の配列
    Dim vntArrRequestName() As Variant          '依頼項目名の配列
    Dim vntArrInsStc()      As Variant          '検査連携用変換文章の配列
    
    Dim lngCount            As Long             'レコード数
    Dim blnItemSelect       As Boolean          '検査項目指定の抽出有無
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStcCd = Empty
    vntShortStc = Empty
    SelectSentenceList = 0
    lngCount = 0
    blnItemSelect = False
    
    '検査項目コードを指定されている場合フラグ成立
    If Trim(strItemCd) <> "" Then
        blnItemSelect = True
    End If
    
    'キー値の設定（条件指定されている場合のみ）
    If blnItemSelect = True Then
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ITEMTYPE", lngItemType, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "STCCLASSCD", strStcClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '文章テーブルよりレコードを取得
    strStmt = "SELECT SENTENCE.ITEMCD, ITEM_P.REQUESTNAME, SENTENCE.ITEMTYPE,                 " & vbLf & _
              "       SENTENCE.STCCD,  SENTENCE.SHORTSTC,  SENTENCE.LONGSTC,  SENTENCE.INSSTC " & vbLf & _
              "  FROM ITEM_P, SENTENCE                                        " & vbLf & _
              " WHERE ITEM_P.ITEMCD = SENTENCE.ITEMCD                         " & vbLf
'## 2003.12.30 Add by K.Kagawa@FFCS 未使用フラグ対応
    If IsMissing(lngSelectMode) = False Then
        If lngSelectMode = 1 Then
            strStmt = strStmt & " AND SENTENCE.DELFLG IS NULL"
        End If
    End If
'## 2003.12.30 Add End
    
    '条件指定されているときはWHERE句追加
    If blnItemSelect = True Then
        strStmt = strStmt & " AND SENTENCE.ITEMCD = :ITEMCD AND SENTENCE.ITEMTYPE = :ITEMTYPE"
    End If
    
    '検索用文字列の設定（マスタメンテ用？）
    If IsMissing(vntSearchCode) = False Then
        If Trim(vntSearchCode) <> "" Then
            strStmt = strStmt & " AND ( SENTENCE.ITEMCD LIKE '%" & vntSearchCode & "%'" & vbLf
            strStmt = strStmt & "       OR SENTENCE.STCCD LIKE '%" & vntSearchCode & "%')" & vbLf
        End If
    End If
                                 
    If IsMissing(vntSearchString) = False Then
        If Trim(vntSearchString) <> "" Then
            strStmt = strStmt & " AND SENTENCE.LONGSTC LIKE '%" & vntSearchString & "%'" & vbLf
        End If
    End If
    
    '文章分類コード指定時の条件節
    If strStcClassCd <> "" Then
        strStmt = strStmt & " AND SENTENCE.STCCLASSCD = :STCCLASSCD" & vbLf
    End If
    
    strStmt = strStmt & " ORDER BY SENTENCE.ITEMCD, SENTENCE.ITEMTYPE"
'## 2003.12.30 Add by K.Kagawa@FFCS 表示順番対応
    If IsMissing(lngSelectMode) = False Then
        If lngSelectMode = 1 Then
            strStmt = strStmt & ", SENTENCE.VIEWORDER NULLS LAST, SENTENCE.STCCD"
        End If
    End If
'## 2003.12.30 Add End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStcCd = objFields("STCCD")
        Set objShortStc = objFields("SHORTSTC")
        Set objItemCd = objFields("ITEMCD")
        Set objItemType = objFields("ITEMTYPE")
        Set objLongStc = objFields("LONGSTC")
        Set objRequestName = objFields("REQUESTNAME")
        Set objInsStc = objFields("INSSTC")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrStcCd(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrLongStc(lngCount)
            ReDim Preserve vntArrRequestName(lngCount)
            ReDim Preserve vntArrInsStc(lngCount)
            
            vntArrStcCd(lngCount) = objStcCd.Value & ""
            vntArrShortStc(lngCount) = objShortStc.Value & ""
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrItemType(lngCount) = objItemType.Value & ""
            vntArrLongStc(lngCount) = objLongStc.Value & ""
            vntArrRequestName(lngCount) = objRequestName.Value & ""
            vntArrInsStc(lngCount) = objInsStc.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntStcCd = vntArrStcCd
    vntShortStc = vntArrShortStc
    If IsMissing(vntItemCd) = False Then vntItemCd = vntArrItemCd
    If IsMissing(vntItemType) = False Then vntItemType = vntArrItemType
    If IsMissing(vntLongStc) = False Then vntLongStc = vntArrLongStc
    If IsMissing(vntRequestName) = False Then vntRequestName = vntArrRequestName
    If IsMissing(vntInsStc) = False Then vntInsStc = vntArrInsStc
    
    SelectSentenceList = lngCount
        
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    If blnItemSelect = True Then
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Sentence.SelectSentenceList"

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
' 機能　　 : 文章分類の一覧を取得する
'
' 引数　　 : (In)     strItemCd        検査項目コード
' 　　　　   (In)     lngItemType      項目タイプ
'     　　   (Out)    vntStcClassCd    文章分類コード
' 　　　　   (Out)    vntStcClassName  文章分類名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectStcClassList( _
    ByVal strItemCd As String, _
    ByVal lngItemType As Long, _
    ByRef vntStcClassCd As Variant, _
    ByRef vntStcClassName As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objStcClassCd           As OraField         '文章分類コード
    Dim objStcClassName         As OraField         '文章分類名
    
    Dim vntArrStcClassCd()      As Variant          '文章分類コードの配列
    Dim vntArrStcClassName()    As Variant          '文章分類名の配列
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStcClassCd = Empty
    vntStcClassName = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", strItemCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMTYPE", lngItemType, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '文章分類テーブルの全レコードを取得
    strStmt = "SELECT SUBSENTENCE.STCCLASSCD, STCCLASS.STCCLASSNAME " & vbLf & _
              "  FROM STCCLASS,                                     " & vbLf & _
              "       ( SELECT DISTINCT STCCLASSCD                  " & vbLf & _
              "           FROM SENTENCE                             " & vbLf & _
              "          WHERE ITEMCD   = :ITEMCD                   " & vbLf & _
              "            AND ITEMTYPE = :ITEMTYPE                 " & vbLf & _
              "       ) SUBSENTENCE                                 " & vbLf & _
              " WHERE SUBSENTENCE.STCCLASSCD = STCCLASS.STCCLASSCD  "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStcClassCd = objFields("STCCLASSCD")
        Set objStcClassName = objFields("STCCLASSNAME")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrStcClassCd(lngCount)
            ReDim Preserve vntArrStcClassName(lngCount)
            vntArrStcClassCd(lngCount) = objStcClassCd.Value
            vntArrStcClassName(lngCount) = objStcClassName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntStcClassCd = vntArrStcClassCd
        vntStcClassName = vntArrStcClassName
    
    End If
    
    '戻り値の設定
    SelectStcClassList = lngCount
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    'オブジェクトの解放
    Set objStcClassCd = Nothing
    Set objStcClassName = Nothing
    Set objFields = Nothing
    Set objOraDyna = Nothing
    Set objOraParam = Nothing
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Sentence.SelectStcClassList"

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
