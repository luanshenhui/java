VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "PerResult"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext             As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession          As OraSession       'OraSessionオブジェクト
Private mobjOraDb               As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 個人検査項目情報を取得する
'
' 引数　　 : (In)     strPerId        個人ＩＤ
' 　　　　   (Out)    vntItemCd       検査項目コード
' 　　　　   (Out)    vntSuffix       サフィックス
' 　　　　   (Out)    vntItemName     検査項目名
' 　　　　   (Out)    vntResult       検査項目コード
' 　　　　   (Out)    vntResultType   結果タイプ
' 　　　　   (Out)    vntItemType     項目タイプ
' 　　　　   (Out)    vntStcItemCd    文章参照用項目コード
' 　　　　   (Out)    vntShortStc     文章略称
' 　　　　   (Out)    vntIspDate      検査日
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectPerResultList( _
    ByVal strPerId As String, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntItemName As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntResultType As Variant, _
    ByRef vntItemType As Variant, _
    ByRef vntStcItemCd As Variant, _
    ByRef vntShortStc As Variant, _
    ByRef vntIspDate As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objResult           As OraField         '検査結果
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objShortStc         As OraField         '文章略称
    Dim objIspDate          As OraField         '検査日
    
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コードの配列
    Dim vntArrShortStc()    As Variant          '文章略称の配列
    Dim vntArrIspDate()     As Variant          '検査日の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '指定個人の個人検査情報を取得
    strStmt = "SELECT BASEDRESULT.ITEMCD,     " & vbLf & _
              "       BASEDRESULT.SUFFIX,     " & vbLf & _
              "       BASEDRESULT.RESULT,     " & vbLf & _
              "       BASEDRESULT.ISPDATE,    " & vbLf & _
              "       BASEDRESULT.ITEMNAME,   " & vbLf & _
              "       BASEDRESULT.RESULTTYPE, " & vbLf & _
              "       BASEDRESULT.ITEMTYPE,   " & vbLf & _
              "       BASEDRESULT.STCITEMCD,  " & vbLf & _
              "       SENTENCE.SHORTSTC       "
    
    '以下で取得した副問い合わせと文章情報を結合
    strStmt = strStmt & vbLf & _
              "  FROM SENTENCE, "
    
    '以下で取得した副問い合わせと検査項目情報を結合
    strStmt = strStmt & vbLf & _
              "       ( SELECT BASEDITEM.ITEMCD,  " & vbLf & _
              "                BASEDITEM.SUFFIX,  " & vbLf & _
              "                BASEDITEM.RESULT,  " & vbLf & _
              "                BASEDITEM.ISPDATE, " & vbLf & _
              "                ITEM_C.ITEMNAME,   " & vbLf & _
              "                ITEM_C.RESULTTYPE, " & vbLf & _
              "                ITEM_C.ITEMTYPE,   " & vbLf & _
              "                ITEM_C.STCITEMCD   " & vbLf & _
              "           FROM ITEM_C, "
    
    'MAX関数を利用し、重複検査項目をまとめる
    strStmt = strStmt & vbLf & _
              "                ( SELECT ITEMCD,              " & vbLf & _
              "                         SUFFIX,              " & vbLf & _
              "                         MAX(RESULT)  RESULT, " & vbLf & _
              "                         MAX(ISPDATE) ISPDATE "
    
    '現個人検査情報の取得
    strStmt = strStmt & vbLf & _
              "                    FROM ( SELECT ITEMCD,        " & vbLf & _
              "                                  SUFFIX,        " & vbLf & _
              "                                  RESULT,        " & vbLf & _
              "                                  ISPDATE        " & vbLf & _
              "                             FROM PERRESULT      " & vbLf & _
              "                            WHERE PERID = :PERID "
    
    '汎用テーブルで設定されている初期グループをもとに空の個人検査情報レコードを作成し、現個人検査情報と結合
    strStmt = strStmt & vbLf & _
              "                            UNION ALL                             " & vbLf & _
              "                           SELECT GRP_I.ITEMCD,                   " & vbLf & _
              "                                  GRP_I.SUFFIX,                   " & vbLf & _
              "                                  NULL RESULT,                    " & vbLf & _
              "                                  CAST(NULL AS DATE) ISPDATE      " & vbLf & _
              "                             FROM GRP_I, FREE                     " & vbLf & _
              "                            WHERE FREE.FREECD     = 'PERINSPECT'  " & vbLf & _
              "                              AND FREE.FREEFIELD1 = GRP_I.GRPCD ) " & vbLf & _
              "                   GROUP BY ITEMCD, SUFFIX                        " & vbLf & _
              "                ) BASEDITEM                                       "
    
    '検査項目情報との結合部
    strStmt = strStmt & vbLf & _
              "          WHERE BASEDITEM.ITEMCD = ITEM_C.ITEMCD " & vbLf & _
              "            AND BASEDITEM.SUFFIX = ITEM_C.SUFFIX " & vbLf & _
              "       ) BASEDRESULT                             "
    
    '文章情報との結合部
    strStmt = strStmt & vbLf & _
              " WHERE BASEDRESULT.STCITEMCD = SENTENCE.ITEMCD(+)   " & vbLf & _
              "   AND BASEDRESULT.ITEMTYPE  = SENTENCE.ITEMTYPE(+) " & vbLf & _
              "   AND BASEDRESULT.RESULT    = SENTENCE.STCCD(+)    "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objShortStc = objFields("SHORTSTC")
        Set objIspDate = objFields("ISPDATE")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrStcItemCd(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            ReDim Preserve vntArrIspDate(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrResultType(lngCount) = objResultType.Value & ""
            vntArrItemType(lngCount) = objItemType.Value & ""
            vntArrStcItemCd(lngCount) = objStcItemCd.Value & ""
            '文章タイプの場合のみ
            If objResultType.Value = 4 Then
                vntArrShortStc(lngCount) = objShortStc.Value & ""
            End If
            vntArrIspDate(lngCount) = objIspDate.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    vntResult = vntArrResult
    vntResultType = vntArrResultType
    vntItemType = vntArrItemType
    vntStcItemCd = vntArrStcItemCd
    vntShortStc = vntArrShortStc
    vntIspDate = vntArrIspDate
    
    SelectPerResultList = lngCount
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerResult.SelectPerResultList"
    
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

' ## 2003.12.03 add by FFCS
'
' 機能　　 : 指定グループの個人検査項目情報を取得する
'
' 引数　　 : (In)     strPerId        個人ＩＤ
' 　　　　   (In)     strGrpCd        グループコード
' 　　　　   (In)     lngGetSeqMode   取得順 0:グループ内表示順　1:コード＋サフィックス 2:イメージファイル名順
' 　　　　   (In)     lngAllDataMode  全件取得モード（0:検査結果に存在する項目を取得、1:検査結果に存在しなくても全項目取得）
' 　　　　   (Out)    vntItemCd       検査項目コード
' 　　　　   (Out)    vntSuffix       サフィックス
' 　　　　   (Out)    vntItemName     検査項目名
' 　　　　   (Out)    vntResult       検査項目コード
' 　　　　   (Out)    vntResultType   結果タイプ
' 　　　　   (Out)    vntItemType     項目タイプ
' 　　　　   (Out)    vntStcItemCd    文章参照用項目コード
' 　　　　   (Out)    vntShortStc     文章略称
' 　　　　   (Out)    vntIspDate      検査日
' 　　　　   (Out)    vntImageFileName  イメージファイル名
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectPerResultGrpList( _
    ByVal strPerId As String, _
    ByVal strGrpCd As String, _
    ByVal lngGetSeqMode As Long, _
    ByVal lngAllDataMode As Long, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntItemName As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntResultType As Variant, _
    ByRef vntItemType As Variant, _
    ByRef vntStcItemCd As Variant, _
    ByRef vntShortStc As Variant, _
    ByRef vntIspDate As Variant, _
    Optional ByRef vntImageFileName As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objResult           As OraField         '検査結果
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objShortStc         As OraField         '文章略称
    Dim objIspDate          As OraField         '検査日
    Dim objImageFileName    As OraField         'イメージファイル名
    
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コードの配列
    Dim vntArrShortStc()    As Variant          '文章略称の配列
    Dim vntArrIspDate()     As Variant          '検査日の配列
    Dim vntArrImageFileName() As Variant        'イメージファイル名の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntImageFileName) Then vntImageFileName = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '指定個人の個人検査情報を取得
    strStmt = "SELECT BASEDRESULT.ITEMCD,     " & vbLf & _
              "       BASEDRESULT.SUFFIX,     " & vbLf & _
              "       BASEDRESULT.RESULT,     " & vbLf & _
              "       BASEDRESULT.ISPDATE,    " & vbLf & _
              "       BASEDRESULT.ITEMNAME,   " & vbLf & _
              "       BASEDRESULT.RESULTTYPE, " & vbLf & _
              "       BASEDRESULT.ITEMTYPE,   " & vbLf & _
              "       BASEDRESULT.STCITEMCD,  " & vbLf & _
              "       SENTENCE.SHORTSTC,      " & vbLf & _
              "       SENTENCE.IMAGEFILENAME  "

    '以下で取得した副問い合わせと文章情報を結合
    strStmt = strStmt & vbLf & _
              "  FROM SENTENCE, "
    
    '以下で取得した副問い合わせと検査項目情報を結合
    strStmt = strStmt & vbLf & _
              "       ( SELECT BASEDITEM.ITEMCD,  " & vbLf & _
              "                BASEDITEM.SUFFIX,  " & vbLf & _
              "                BASEDITEM.SEQ,     " & vbLf & _
              "                BASEDITEM.RESULT,  " & vbLf & _
              "                BASEDITEM.ISPDATE, " & vbLf & _
              "                ITEM_C.ITEMNAME,   " & vbLf & _
              "                ITEM_C.RESULTTYPE, " & vbLf & _
              "                ITEM_C.ITEMTYPE,   " & vbLf & _
              "                ITEM_C.STCITEMCD   " & vbLf & _
              "           FROM ITEM_C, "
    
    'MAX関数を利用し、重複検査項目をまとめる
    strStmt = strStmt & vbLf & _
              "                ( SELECT ITEMCD,              " & vbLf & _
              "                         SUFFIX,              " & vbLf & _
              "                         MAX(SEQ)     SEQ,    " & vbLf & _
              "                         MAX(RESULT)  RESULT, " & vbLf & _
              "                         MAX(ISPDATE) ISPDATE "
    
    '現個人検査情報の取得
    strStmt = strStmt & vbLf & _
              "                    FROM ( SELECT PERRESULT.ITEMCD,               " & vbLf & _
              "                                  PERRESULT.SUFFIX,               " & vbLf & _
              "                                  GRP_I.SEQ,                      " & vbLf & _
              "                                  PERRESULT.RESULT,               " & vbLf & _
              "                                  PERRESULT.ISPDATE               " & vbLf & _
              "                             FROM PERRESULT, GRP_I                " & vbLf & _
              "                            WHERE PERRESULT.PERID  = :PERID       " & vbLf & _
              "                              AND GRP_I.GRPCD      = :GRPCD       " & vbLf & _
              "                              AND PERRESULT.ITEMCD = GRP_I.ITEMCD " & vbLf & _
              "                              AND PERRESULT.SUFFIX = GRP_I.SUFFIX " & vbLf & _
              "                              AND PERRESULT.RESULT IS NOT NULL    "
    
    '検査結果の無い項目も取得
    If lngAllDataMode = 1 Then
        strStmt = strStmt & vbLf & _
              "                            UNION ALL                             " & vbLf & _
              "                           SELECT GRP_I.ITEMCD,                   " & vbLf & _
              "                                  GRP_I.SUFFIX,                   " & vbLf & _
              "                                  GRP_I.SEQ,                      " & vbLf & _
              "                                  NULL RESULT,                    " & vbLf & _
              "                                  CAST(NULL AS DATE) ISPDATE      " & vbLf & _
              "                             FROM GRP_I                           " & vbLf & _
              "                            WHERE GRP_I.GRPCD = :GRPCD            "
    End If
        
    strStmt = strStmt & vbLf & _
              "                          )                                       " & vbLf & _
              "                   GROUP BY ITEMCD, SUFFIX                        " & vbLf & _
              "                ) BASEDITEM                                       "
    
    '検査項目情報との結合部
    strStmt = strStmt & vbLf & _
              "          WHERE BASEDITEM.ITEMCD = ITEM_C.ITEMCD " & vbLf & _
              "            AND BASEDITEM.SUFFIX = ITEM_C.SUFFIX " & vbLf & _
              "       ) BASEDRESULT                             "
    
    '文章情報との結合部
    strStmt = strStmt & vbLf & _
              " WHERE BASEDRESULT.STCITEMCD = SENTENCE.ITEMCD(+)   " & vbLf & _
              "   AND BASEDRESULT.ITEMTYPE  = SENTENCE.ITEMTYPE(+) " & vbLf & _
              "   AND BASEDRESULT.RESULT    = SENTENCE.STCCD(+)    "
    '並び指定
    Select Case lngGetSeqMode
    Case 0  'グループ内表示順
        strStmt = strStmt & vbLf & _
              " ORDER BY BASEDRESULT.SEQ                            "
    Case 1  'コード＋サフィックス
        strStmt = strStmt & vbLf & _
              " ORDER BY BASEDRESULT.ITEMCD, BASEDRESULT.SUFFIX     "
    Case 2  'イメージファイル名順
        strStmt = strStmt & vbLf & _
              " ORDER BY SENTENCE.IMAGEFILENAME                     "
    End Select

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objShortStc = objFields("SHORTSTC")
        Set objIspDate = objFields("ISPDATE")
        Set objImageFileName = objFields("IMAGEFILENAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrStcItemCd(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            ReDim Preserve vntArrIspDate(lngCount)
            ReDim Preserve vntArrImageFileName(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrResultType(lngCount) = objResultType.Value & ""
            vntArrItemType(lngCount) = objItemType.Value & ""
            vntArrStcItemCd(lngCount) = objStcItemCd.Value & ""
            '文章タイプの場合のみ
            If objResultType.Value = 4 Then
                vntArrShortStc(lngCount) = objShortStc.Value & ""
            End If
            vntArrIspDate(lngCount) = objIspDate.Value & ""
            vntArrImageFileName(lngCount) = objImageFileName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    vntResult = vntArrResult
    vntResultType = vntArrResultType
    vntItemType = vntArrItemType
    vntStcItemCd = vntArrStcItemCd
    vntShortStc = vntArrShortStc
    vntIspDate = vntArrIspDate
    If Not IsMissing(vntImageFileName) Then vntImageFileName = vntArrImageFileName
    
    SelectPerResultGrpList = lngCount
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerResult.SelectPerResultGrpList"
    
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

' ### 既に登録されている個人検査結果データを消さないバージョン 2003.12.07 by FFCS
'
' 機能　　 : 個人検査結果テーブルを登録または更新する
'
' 引数　　 : (In)     vntPerId      個人ＩＤ
' 　　　　   (In)     vntItemCd     検査項目コード
' 　　　　   (In)     vntSuffix     サフィックス
' 　　　　   (In)     vntResult     検査結果
' 　　　　   (In)     vntIspDate    検査日
' 　　　　   (In)     vntUpdDiv     更新区分
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function MergePerResult( _
    ByVal strPerId As String, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntIspDate As Variant, _
    ByRef vntUpdDiv As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objItemCd       As OraParameter     '検査項目コード
    Dim objSuffix       As OraParameter     'サフィックス
    Dim objResult       As OraParameter     '検査結果
    Dim objIspDate      As OraParameter     '検査日
    Dim objUpdDiv       As OraParameter     '更新区分
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RESULT", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISPDATE", Null, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UPDDIV", Null, ORAPARM_INPUT, ORATYPE_NUMBER
        
    'パラメータの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    Set objSuffix = objOraParam("SUFFIX")
    Set objResult = objOraParam("RESULT")
    Set objIspDate = objOraParam("ISPDATE")
    Set objUpdDiv = objOraParam("UPDDIV")
    
    '個人検査結果テーブルマージ用のSQLステートメント作成
    strStmt = "MERGE INTO PERRESULT USING                     " & vbLf & _
              " ( SELECT                                      " & vbLf & _
              "            :PERID    PERID,                   " & vbLf & _
              "            :ITEMCD   ITEMCD,                  " & vbLf & _
              "            :SUFFIX   SUFFIX,                  " & vbLf & _
              "            :UPDDIV   UPDDIV,                  " & vbLf & _
              "            SYSDATE   UPDDATE,                 " & vbLf & _
              "            :RESULT   RESULT,                  " & vbLf & _
              "            :ISPDATE  ISPDATE                  " & vbLf & _
              "     FROM DUAL ) SETDATAVIEW                   " & vbLf & _
              "  ON ( PERRESULT.PERID  = SETDATAVIEW.PERID    " & vbLf & _
              "   AND PERRESULT.ITEMCD = SETDATAVIEW.ITEMCD   " & vbLf & _
              "   AND PERRESULT.SUFFIX = SETDATAVIEW.SUFFIX ) "
              
    '存在する場合、上書き更新
    strStmt = strStmt & vbLf & _
              "WHEN MATCHED THEN                          " & vbLf & _
              "UPDATE SET                                 " & vbLf & _
              "            UPDDIV  = SETDATAVIEW.UPDDIV,  " & vbLf & _
              "            UPDDATE = SETDATAVIEW.UPDDATE, " & vbLf & _
              "            RESULT  = SETDATAVIEW.RESULT,  " & vbLf & _
              "            ISPDATE = SETDATAVIEW.ISPDATE  "
              
    '存在しない場合、新規に登録
    strStmt = strStmt & vbLf & _
              "WHEN NOT MATCHED THEN           " & vbLf & _
              "INSERT (                        " & vbLf & _
              "            PERID,              " & vbLf & _
              "            ITEMCD,             " & vbLf & _
              "            SUFFIX,             " & vbLf & _
              "            UPDDIV,            " & vbLf & _
              "            UPDDATE,            " & vbLf & _
              "            RESULT,             " & vbLf & _
              "            ISPDATE             " & vbLf & _
              "       ) VALUES (               " & vbLf & _
              "            SETDATAVIEW.PERID,  " & vbLf & _
              "            SETDATAVIEW.ITEMCD, " & vbLf & _
              "            SETDATAVIEW.SUFFIX, " & vbLf & _
              "            SETDATAVIEW.UPDDIV, " & vbLf & _
              "            SETDATAVIEW.UPDDATE," & vbLf & _
              "            SETDATAVIEW.RESULT, " & vbLf & _
              "            SETDATAVIEW.ISPDATE " & vbLf & _
              "       )                        "

    '各配列値の挿入処理
    For i = 0 To UBound(vntItemCd)
        
        '配列値の編集
        objItemCd.Value = CStr(vntItemCd(i))
        objSuffix.Value = CStr(vntSuffix(i))
        objResult.Value = CStr(vntResult(i))
        objUpdDiv.Value = CStr(vntUpdDiv(i))
        If vntIspDate(i) <> "" Then
            objIspDate.Value = CDate(vntIspDate(i))
        Else
            objIspDate.Value = Null
        End If
        
        '挿入SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(strStmt, ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
        
    Next i
              
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    MergePerResult = True
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerResult.MergePerResult"
    
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
' 機能　　 : 個人検査結果テーブルを更新する
'
' 引数　　 : (In)     vntPerId      個人ＩＤ
' 　　　　   (In)     vntItemCd     検査項目コード
' 　　　　   (In)     vntSuffix     サフィックス
' 　　　　   (In)     vntResult     検査結果
' 　　　　   (In)     vntIspDate    検査日
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function UpdatePerResult( _
    ByVal strPerId As String, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntIspDate As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objItemCd       As OraParameter     '検査項目コード
    Dim objSuffix       As OraParameter     'サフィックス
    Dim objResult       As OraParameter     '検査結果
    Dim objIspDate      As OraParameter     '検査日
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RESULT", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISPDATE", Null, ORAPARM_INPUT, ORATYPE_DATE
    
    '指定個人の全ての個人検査結果情報を削除する
    mobjOraDb.ExecuteSQL "DELETE PERRESULT WHERE PERID = :PERID"
    
    'パラメータの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    Set objSuffix = objOraParam("SUFFIX")
    Set objResult = objOraParam("RESULT")
    Set objIspDate = objOraParam("ISPDATE")
    
    '個人検査結果テーブル挿入用のSQLステートメント作成
    strStmt = "INSERT INTO PERRESULT ( " & vbLf & _
              "            PERID,      " & vbLf & _
              "            ITEMCD,     " & vbLf & _
              "            SUFFIX,     " & vbLf & _
              "            UPDDATE,    " & vbLf & _
              "            RESULT,     " & vbLf & _
              "            ISPDATE     " & vbLf & _
              "       ) VALUES (       " & vbLf & _
              "            :PERID,     " & vbLf & _
              "            :ITEMCD,    " & vbLf & _
              "            :SUFFIX,    " & vbLf & _
              "            SYSDATE,    " & vbLf & _
              "            :RESULT,    " & vbLf & _
              "            :ISPDATE    " & vbLf & _
              "       )                "

    '各配列値の挿入処理
    For i = 0 To UBound(vntItemCd)
    
        '検査結果が存在する場合
        If vntResult(i) <> "" Then
        
            '配列値の編集
            objItemCd.Value = CStr(vntItemCd(i))
            objSuffix.Value = CStr(vntSuffix(i))
            objResult.Value = CStr(vntResult(i))
            If vntIspDate(i) <> "" Then
                objIspDate.Value = CDate(vntIspDate(i))
            Else
                objIspDate.Value = Null
            End If
        
            '挿入SQL文の実行
            If objOraSQLStmt Is Nothing Then
                Set objOraSQLStmt = mobjOraDb.CreateSql(strStmt, ORASQL_FAILEXEC)
            Else
                objOraSQLStmt.Refresh
            End If
        
        End If
        
    Next i
              
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    UpdatePerResult = True
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerResult.UpdatePerResult"
    
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

' ### 2003.12.08 追加　by FFCS
'
' 機能　　 : 個人検査結果テーブルを削除する
'
' 引数　　 : (In)     vntPerId      個人ＩＤ
' 　　　　   (In)     vntItemCd     検査項目コード
' 　　　　   (In)     vntSuffix     サフィックス
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeletePerResult( _
    ByVal strPerId As String, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objItemCd       As OraParameter     '検査項目コード
    Dim objSuffix       As OraParameter     'サフィックス
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
    'パラメータの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    Set objSuffix = objOraParam("SUFFIX")
    
    '個人検査結果テーブル削除用のSQLステートメント作成
    strStmt = "DELETE PERRESULT        " & vbLf & _
              " WHERE PERID = :PERID      " & vbLf & _
              "   AND ITEMCD = :ITEMCD     " & vbLf & _
              "   AND SUFFIX = :SUFFIX     "

    '各配列値の挿入処理
    For i = 0 To UBound(vntItemCd)
    
        '配列値の編集
        objItemCd.Value = CStr(vntItemCd(i))
        objSuffix.Value = CStr(vntSuffix(i))
        
        '削除SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(strStmt, ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
        
    Next i
              
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeletePerResult = True
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PerResult.DeletePerResult"
    
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
