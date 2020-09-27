VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "ReqSendCheck"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト
''
'' 機能　　 : 依頼状発送確認テーブルレコードを削除する
''
'' 引数　　 : (In)    strMode        削除モード("DEL")
'' 　　　　 : (In)    lngRsvNo       予約番号
'' 　　　　 : (In)    lngJudClassCd  判定項目
'' 　　　　 : (In)    lngPrtDiv      様式分類
'' 　　　　 : (In)    lngSeq         SEQ
''
'' 戻り値　 : True   正常終了
'' 　　　　   False  異常終了
''
'' 備考　　 :
''
'Public Function DeleteReqSendDate(ByVal strMode As String, _
'                                  ByVal lngRsvNo As Long, _
'                                  ByVal lngJudClassCd As Long, _
'                                  ByVal lngPrtDiv As Long, _
'                                  ByVal lngSeq As Long) As Boolean
'
'    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
'    Dim strStmt             As String           'SQLステートメント
'    Dim strStmt2            As String           'SQLステートメント
'
'    Dim Ret                 As Long             '関数戻り値
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    Ret = False
'
'    'キー及び更新値の設定
'    Set objOraParam = mobjOraDb.Parameters
'
'    '成績書発送確認テーブルレコードの削除
'    If strMode = "DEL" Then
'
'        'バインド変数設定
'         objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'         objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
'         objOraParam.Add "PRTDIV", lngPrtDiv, ORAPARM_INPUT, ORATYPE_NUMBER
'         objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
'
'        '該当依頼状の発送日と発送者情報を削除
'        strStmt = "UPDATE FOLLOW_PRT_H                " & vbLf & _
'                  "   SET PRTSENDDATE = NULL          " & vbLf & _
'                  "      ,SENDUSER = NULL             " & vbLf & _
'                  " WHERE RSVNO       = :RSVNO        " & vbLf & _
'                  "   AND JUDCLASSCD  = :JUDCLASSCD   " & vbLf & _
'                  "   AND PRTDIV      = :PRTDIV       " & vbLf & _
'                  "   AND SEQ         = :SEQ          "
'
'        Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
'
'        If Ret > 0 Then
'            Ret = True
'        End If
'
'    End If
'
'    If Ret = True Then
'        'フォローアップ情報テーブル更新(最終依頼状発送日・発送者)
'        strStmt2 = "UPDATE FOLLOW_INFO                                                                 " & vbLf & _
'                   "   SET (REQSENDDATE, REQSENDUSER) =                                                " & vbLf & _
'                   "                                  (SELECT FINAL.REQSENDDATE                        " & vbLf & _
'                   "                                         ,FINAL.REQSENDUSER                        " & vbLf & _
'                   "                                     FROM (                                        " & vbLf & _
'                   "                                           SELECT PRTSENDDATE    AS REQSENDDATE    " & vbLf & _
'                   "                                                 ,SENDUSER    AS REQSENDUSER       " & vbLf & _
'                   "                                             FROM FOLLOW_PRT_H                     " & vbLf & _
'                   "                                            WHERE RSVNO      = :RSVNO              " & vbLf & _
'                   "                                              AND JUDCLASSCD = :JUDCLASSCD         " & vbLf & _
'                   "                                              AND PRTDIV     = :PRTDIV             " & vbLf & _
'                   "                                              AND PRTSENDDATE IS NOT NULL          " & vbLf & _
'                   "                                            ORDER BY PRTSENDDATE DESC              " & vbLf & _
'                   "                                           ) FINAL                                 " & vbLf & _
'                   "                                     WHERE ROWNUM = 1                              " & vbLf & _
'                   "                                  )                                                " & vbLf & _
'                   " WHERE FOLLOW_INFO.RSVNO      = :RSVNO                                             " & vbLf & _
'                   "   AND FOLLOW_INFO.JUDCLASSCD = :JUDCLASSCD                                        "
'
'        mobjOraDb.ExecuteSQL (OmitCharSpc(strStmt2))
'    End If
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    'トランザクションをコミット
'    mobjContext.SetComplete
'
'    '戻り値の設定
'    DeleteReqSendDate = Ret
'
'    Exit Function
'
'ErrorHandle:
'
'    'その他の戻り値設定
'    DeleteReqSendDate = False
'
'    'イベントログ書き込み
'    WriteErrorLog "ReqSendCheck.DeleteReqSendDate"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

'
' 機能　　 : 依頼状発送確認テーブルレコードを削除する
'
' 引数　　 : (In)    strMode        削除モード("DEL")
' 　　　　 : (In)    vntRsvNo       予約番号
' 　　　　 : (In)    vntJudClassCd  判定分類コード
' 　　　　 : (In)    vntPrtDiv      様式分類
' 　　　　 : (In)    vntSeq         SEQ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
Public Function DeleteReqSendDate(ByVal strMode As String, _
                                  ByVal vntRsvNo As Variant, _
                                  ByVal vntJudClassCd As Variant, _
                                  ByVal vntPrtDiv As Variant, _
                                  ByVal vntSeq As Variant) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim strStmt2            As String           'SQLステートメント
    
    Dim Ret                 As Long             '関数戻り値
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
        Ret = False
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters

    '依頼状発送確認レコードの削除
    If strMode = "DEL" Then
        
        'バインド変数設定
         objOraParam.Add "RSVNO", vntRsvNo(0), ORAPARM_INPUT, ORATYPE_NUMBER
         objOraParam.Add "JUDCLASSCD", vntJudClassCd(0), ORAPARM_INPUT, ORATYPE_NUMBER
         objOraParam.Add "PRTDIV", vntPrtDiv(0), ORAPARM_INPUT, ORATYPE_NUMBER
         objOraParam.Add "SEQ", vntSeq(0), ORAPARM_INPUT, ORATYPE_NUMBER
       
        '該当依頼状の発送日と発送者情報を更新
        strStmt = "UPDATE FOLLOW_PRT_H                " & vbLf & _
                  "   SET PRTSENDDATE = NULL          " & vbLf & _
                  "      ,SENDUSER = NULL             " & vbLf & _
                  " WHERE RSVNO       = :RSVNO        " & vbLf & _
                  "   AND JUDCLASSCD  = :JUDCLASSCD   " & vbLf & _
                  "   AND PRTDIV      = :PRTDIV       " & vbLf & _
                  "   AND SEQ         = :SEQ          "
        Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
    
        If Ret > 0 Then
            Ret = True
        End If
    End If
    
    If Ret = True Then
        'フォローアップ情報テーブル更新(最終依頼状発送日・発送者)
        strStmt2 = "UPDATE FOLLOW_INFO                                                                 " & vbLf & _
                   "   SET (REQSENDDATE, REQSENDUSER) =                                                " & vbLf & _
                   "                                  (SELECT FINAL.REQSENDDATE                        " & vbLf & _
                   "                                         ,FINAL.REQSENDUSER                        " & vbLf & _
                   "                                     FROM (                                        " & vbLf & _
                   "                                           SELECT PRTSENDDATE    AS REQSENDDATE    " & vbLf & _
                   "                                                 ,SENDUSER    AS REQSENDUSER       " & vbLf & _
                   "                                             FROM FOLLOW_PRT_H                     " & vbLf & _
                   "                                            WHERE RSVNO      = :RSVNO              " & vbLf & _
                   "                                              AND JUDCLASSCD = :JUDCLASSCD         " & vbLf & _
                   "                                              AND PRTDIV     = :PRTDIV             " & vbLf & _
                   "                                              AND PRTSENDDATE IS NOT NULL          " & vbLf & _
                   "                                            ORDER BY PRTSENDDATE DESC              " & vbLf & _
                   "                                           ) FINAL                                 " & vbLf & _
                   "                                     WHERE ROWNUM = 1                              " & vbLf & _
                   "                                  )                                                " & vbLf & _
                   " WHERE FOLLOW_INFO.RSVNO      = :RSVNO                                             " & vbLf & _
                   "   AND FOLLOW_INFO.JUDCLASSCD = :JUDCLASSCD                                        "

        mobjOraDb.ExecuteSQL (OmitCharSpc(strStmt2))
    End If

    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteReqSendDate = Ret

    Exit Function
    
ErrorHandle:

    DeleteReqSendDate = False

    'イベントログ書き込み
    WriteErrorLog "ReqSendCheck.DeleteReqSendDate"
    
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
' 機能　　 : 依頼状発送確認を更新
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    lngRsvNo       予約番号
' 　　　　   (In)    lngJudClassCd  判定分類コード
' 　　　　   (In)    lngPrtDiv      様式分類
' 　　　　   (In)    lngSeq         依頼状番号
' 　　　　   (In)    strUpdUser     依頼状発送者
' 　　　　   (In)    strReqSendDate 依頼状発送日

'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :

Public Function UpdateReqSendDate(ByVal strMode As String, _
                                  ByVal lngRsvNo As Long, _
                                  ByVal lngJudClassCd As Long, _
                                  ByVal lngPrtDiv As Long, _
                                  ByVal lngSeq As Long, _
                                  ByVal strUpdUser As String, _
                                  ByVal strSSendDate As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    Dim strStmt2    As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PRTDIV", lngPrtDiv, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REQSENDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REQSENDDATE", Trim(strSSendDate), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '更新モードの場合
    If strMode = "UPD" Then

        strStmt = "UPDATE FOLLOW_PRT_H                " & vbLf & _
                  "   SET PRTSENDDATE = TO_DATE(TO_CHAR(TO_DATE(:REQSENDDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD') || TO_CHAR(SYSDATE, 'HH24MISS'), 'YYYY/MM/DDHH24MISS')     " & vbLf & _
                  "      ,SENDUSER    = :REQSENDUSER  " & vbLf & _
                  " WHERE RSVNO       = :RSVNO        " & vbLf & _
                  "   AND JUDCLASSCD  = :JUDCLASSCD   " & vbLf & _
                  "   AND PRTDIV      = :PRTDIV       " & vbLf & _
                  "   AND SEQ         = :SEQ          "

        Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
        
        If Ret > 0 Then
            Ret = INSERT_NORMAL
        End If
    
    End If
    
    If Ret = INSERT_NORMAL Then

        'フォローアップ情報テーブル更新(最終依頼状発送日・発送者)
        strStmt2 = "UPDATE FOLLOW_INFO                                                                 " & vbLf & _
                   "   SET (REQSENDDATE, REQSENDUSER) =                                                " & vbLf & _
                   "                                  (SELECT FINAL.REQSENDDATE                        " & vbLf & _
                   "                                         ,FINAL.REQSENDUSER                        " & vbLf & _
                   "                                     FROM (                                        " & vbLf & _
                   "                                           SELECT PRTSENDDATE    AS REQSENDDATE    " & vbLf & _
                   "                                                 ,SENDUSER    AS REQSENDUSER       " & vbLf & _
                   "                                             FROM FOLLOW_PRT_H                     " & vbLf & _
                   "                                            WHERE RSVNO      = :RSVNO              " & vbLf & _
                   "                                              AND JUDCLASSCD = :JUDCLASSCD         " & vbLf & _
                   "                                              AND PRTDIV     = :PRTDIV             " & vbLf & _
                   "                                              AND PRTSENDDATE IS NOT NULL          " & vbLf & _
                   "                                            ORDER BY PRTSENDDATE DESC              " & vbLf & _
                   "                                           ) FINAL                                 " & vbLf & _
                   "                                     WHERE ROWNUM = 1                              " & vbLf & _
                   "                                  )                                                " & vbLf & _
                   " WHERE FOLLOW_INFO.RSVNO      = :RSVNO                                             " & vbLf & _
                   "   AND FOLLOW_INFO.JUDCLASSCD = :JUDCLASSCD                                        "

        mobjOraDb.ExecuteSQL (OmitCharSpc(strStmt2))

    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    UpdateReqSendDate = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    UpdateReqSendDate = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "ReqSendCheck.UpdateReqSendDate"
    
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
' 機能　　 : 依頼状発送情報取得
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (In)     lngJudClassCd         判定分類コード
' 　　　　   (In)     lngPrtDiv             様式分類

' 　　　　   (Out)    vntSeq                依頼状番号配列
' 　　　　   (Out)    vntFileName           依頼状ファイル名配列
' 　　　　   (Out)    vntJudClassName       検査項目名配列
' 　　　　   (Out)    vntAddDate            登録日時配列
' 　　　　   (Out)    vntAddUser            登録者配列
' 　　　　   (Out)    vntReqSendDate        依頼状発送日配列
' 　　　　   (Out)    vntReqSendUser        依頼状発送者配列

' 戻り値　 : lngCount   レコード数
'
' 備考　　 :
'
Public Function SelectAll_SendDate(ByVal lngRsvNo As Long, _
                                   ByVal lngJudClassCd As Long, _
                                   ByVal lngPrtDiv As Long, _
                                   Optional ByRef vntSeq As Variant, _
                                   Optional ByRef vntJudClassName As Variant, _
                                   Optional ByRef vntFileName As Variant, _
                                   Optional ByRef vntAddDate As Variant, _
                                   Optional ByRef vntAddUser As Variant, _
                                   Optional ByRef vntReqSendDate As Variant, _
                                   Optional ByRef vntReqSendUser As Variant) As Long
''Public Function SelectAll_SendDate(ByVal lngRsvNo As Long, _
''                                   ByVal lngJudClassCd As Long, _
''                                   ByVal lngPrtDiv As Long, _
''                                   Optional ByRef vntSeq As Variant, _
''                                   Optional ByRef vntJudClassName As Variant, _
''                                   Optional ByRef vntFileName As Variant, _
''                                   Optional ByRef vntAddDate As Variant, _
''                                   Optional ByRef vntAddUser As Variant _
''                                   ) As Long


    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objSeq                  As OraField         '依頼状番号
    Dim objJudClassName         As OraField         '検査項目名
    Dim objFileName             As OraField         '依頼状ファイル名
    Dim objAddDate              As OraField         '登録日時
    Dim objAddUser              As OraField         '登録者
    Dim objReqSendDate          As OraField         '依頼状発送日
    Dim objReqSendUser          As OraField         '依頼状発送者
    
    Dim vntArrSeq()             As Variant          '依頼状番号配列
    Dim vntArrFileName()        As Variant          '依頼状ファイル名配列
    Dim vntArrJudClassName()    As Variant          '依頼状ファイル名配列
    Dim vntArrAddDate()         As Variant          '登録日時配列
    Dim vntArrAddUser()         As Variant          '登録者配列
    Dim vntArrReqSendDate()     As Variant          '依頼状発送日配列
    Dim vntArrReqSendUser()     As Variant          '依頼状発送者配列
    
    Dim lngCount                As Long             '関数戻り値
    Dim i                       As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期値
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntFileName) Then vntFileName = Empty
    If Not IsMissing(vntJudClassName) Then vntJudClassName = Empty
    If Not IsMissing(vntAddDate) Then vntAddDate = Empty
    If Not IsMissing(vntAddUser) Then vntAddUser = Empty
    If Not IsMissing(vntReqSendDate) Then vntReqSendDate = Empty
    If Not IsMissing(vntReqSendUser) Then vntReqSendUser = Empty
    
    lngCount = 0
    
    'キー値の設定
    
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(lngRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", Trim(lngJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PRTDIV", Trim(lngPrtDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たすレコードを取得
    strStmt = "SELECT FOLLOW_PRT_H.SEQ                                    AS SEQ          " & vbLf & _
              "      ,FOLLOW_PRT_H.FILENAME                               AS FILENAME     " & vbLf & _
              "      ,(SELECT JUDCLASSNAME FROM JUDCLASS                                  " & vbLf & _
              "         WHERE JUDCLASS.JUDCLASSCD = :JUDCLASSCD)          AS JUDCLASSNAME " & vbLf & _
              "      ,FOLLOW_PRT_H.ADDDATE                                AS ADDDATE      " & vbLf & _
              "      ,(SELECT HAINSUSER.USERNAME FROM HAINSUSER                           " & vbLf & _
              "         WHERE FOLLOW_PRT_H.ADDUSER = HAINSUSER.USERID)    AS ADDUSER      " & vbLf & _
              "      ,FOLLOW_PRT_H.PRTSENDDATE                            AS REQSENDDATE  " & vbLf & _
              "      ,(SELECT HAINSUSER.USERNAME FROM HAINSUSER                           " & vbLf & _
              "         WHERE FOLLOW_PRT_H.SENDUSER = HAINSUSER.USERID)   AS REQSENDUSER  " & vbLf & _
              "  FROM FOLLOW_PRT_H                                                        " & vbLf & _
              " WHERE FOLLOW_PRT_H.RSVNO = :RSVNO                                         " & vbLf & _
              "   AND FOLLOW_PRT_H.JUDCLASSCD = :JUDCLASSCD                               " & vbLf & _
              "   AND FOLLOW_PRT_H.PRTDIV = :PRTDIV                                       " & vbLf & _
              "   AND (FOLLOW_PRT_H.PRTSENDDATE IS NOT NULL                               " & vbLf & _
              "    OR FOLLOW_PRT_H.SENDUSER IS NOT NULL)                                  "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objSeq = objFields("SEQ")
        Set objFileName = objFields("FILENAME")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objAddDate = objFields("ADDDATE")
        Set objAddUser = objFields("ADDUSER")
        Set objReqSendDate = objFields("REQSENDDATE")
        Set objReqSendUser = objFields("REQSENDUSER")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
        
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrFileName(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrAddDate(lngCount)
            ReDim Preserve vntArrAddUser(lngCount)
            ReDim Preserve vntArrReqSendDate(lngCount)
            ReDim Preserve vntArrReqSendUser(lngCount)
            
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrFileName(lngCount) = objFileName.Value & ""
            vntArrJudClassName(lngCount) = objJudClassName.Value & ""
            vntArrAddDate(lngCount) = objAddDate.Value & ""
            vntArrAddUser(lngCount) = objAddUser.Value & ""
            vntArrReqSendDate(lngCount) = objReqSendDate.Value & ""
            vntArrReqSendUser(lngCount) = objReqSendUser.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
                
        '戻り値の設定
        If IsMissing(vntSeq) = False Then vntSeq = vntArrSeq
        If IsMissing(vntFileName) = False Then vntFileName = vntArrFileName
        If IsMissing(vntJudClassName) = False Then vntJudClassName = vntArrJudClassName
        If IsMissing(vntAddDate) = False Then vntAddDate = vntArrAddDate
        If IsMissing(vntAddUser) = False Then vntAddUser = vntArrAddUser
        If IsMissing(vntReqSendDate) = False Then vntReqSendDate = vntArrReqSendDate
        If IsMissing(vntReqSendUser) = False Then vntReqSendUser = vntArrReqSendUser
        
    End If
    
    Set objSeq = Nothing
    Set objFileName = Nothing
    Set objJudClassName = Nothing
    Set objAddDate = Nothing
    Set objAddUser = Nothing
    Set objReqSendDate = Nothing
    Set objReqSendUser = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値設定
    SelectAll_SendDate = lngCount
    
    Exit Function
    
ErrorHandle:

    SelectAll_SendDate = -1

    'イベントログ書き込み
    WriteErrorLog "ReqSendCheck.SelectAll_SendDate"
    
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
