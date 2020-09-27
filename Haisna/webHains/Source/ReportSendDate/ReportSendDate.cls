VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "ReportSendDate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト
    
Private Const mstrItemCdForGFFlg    As String = "23160"     '後日内視鏡判断用検査項目コード
Private Const mstrSuffixForGFFlg    As String = "00"        '後日内視鏡判断用サフィックス

Private Const mstrItemCdForCFFlg    As String = "23712"     '後日大腸内視鏡判断用検査項目コード
Private Const mstrSuffixForCFFlg    As String = "00"        '後日大腸内視鏡判断用サフィックス

'
' 機能　　 : 成績書発送確認テーブルレコードを削除する
'
' 引数　　 : (In)    strMode        削除モード("MAX":最大SEQを削除、"SEL":KEY指定)
' 　　　　 : (In)    vntRsvNo       予約番号
' 　　　　 : (In)    vntSeq         SEQ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteConsult_ReptSend(ByVal strMode As String, _
                                       ByVal vntRsvNo As Variant, _
                                       ByVal vntSeq As Variant) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim objRsvNo            As OraParamArray    '予約番号
    Dim objSeq              As OraParamArray    'ＳＥＱ
    Dim lngArraySize        As Long
    Dim i                   As Long

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    lngArraySize = UBound(vntRsvNo) + 1
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters

    '成績書発送確認テーブルレコードの削除
    If strMode = "MAX" Then
        
        'バインド変数設定
         objOraParam.Add "RSVNO", vntRsvNo(0), ORAPARM_INPUT, ORATYPE_NUMBER
       
        '最大SEQを予約番号指定で消す
        strStmt = "DELETE CONSULT_REPSEND                            " & vbLf & _
                  " WHERE ( RSVNO, SEQ ) IN ( SELECT RSVNO, MAX(SEQ) " & vbLf & _
                  "                             FROM CONSULT_REPSEND " & vbLf & _
                  "                            WHERE RSVNO = :RSVNO  " & vbLf & _
                  "                            GROUP BY RSVNO )      "
    
    Else
    
        'バインド変数設定
        objOraParam.AddTable "ARR_RSVNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
        objOraParam.AddTable "ARR_SEQ", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
    
        Set objRsvNo = objOraParam("ARR_RSVNO")
        Set objSeq = objOraParam("ARR_SEQ")
    
        '配列のバインド変数に値をセット
        For i = 0 To lngArraySize - 1
            objRsvNo(i) = vntRsvNo(i)
            objSeq(i) = vntSeq(i)
        Next i
    
        strStmt = "DELETE CONSULT_REPSEND WHERE RSVNO = :ARR_RSVNO AND SEQ = :ARR_SEQ"
    
    End If
    
    mobjOraDb.ExecuteSQL (OmitCharSpc(strStmt))
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteConsult_ReptSend = True

    Exit Function
    
ErrorHandle:

    DeleteConsult_ReptSend = False

    'イベントログ書き込み
    WriteErrorLog "ReportSendDate.DeleteConsult_ReptSend"
    
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
' 機能　　 : 成績書発送確認を更新する
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    lngRsvNo       予約番号
' 　　　　   (In)    strChargeUser  発送担当ユーザ
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
'Public Function UpdateReportSendDate(ByVal strMode As String, _
'                                     ByVal lngRsvNo As Long, _
'                                     ByVal strChargeUser As String) As Long
Public Function UpdateReportSendDate(ByVal strMode As String, _
                                     ByVal lngRsvNo As Long, _
                                     ByVal strChargeUser As String, _
                                     ByVal strSSendDate As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CHARGEUSER", Trim(strChargeUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
    objOraParam.Add "SENDDATE", Trim(strSSendDate), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '更新モードの場合
    If strMode = "UPD" Then
        
'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
'        strStmt = "UPDATE CONSULT_REPSEND               " & vbLf & _
'                  "   SET REPORTSENDDATE = SYSDATE,     " & vbLf & _
'                  "       CHARGEUSER     = :CHARGEUSER  " & vbLf & _
'                  " WHERE ( RSVNO, SEQ ) IN             " & vbLf & _
'                  "       (SELECT RSVNO, MAX(SEQ)       " & vbLf & _
'                  "          FROM CONSULT_REPSEND       " & vbLf & _
'                  "         WHERE RSVNO = :RSVNO        " & vbLf & _
'                  "         GROUP BY RSVNO)             "
        
        strStmt = "UPDATE CONSULT_REPSEND               " & vbLf & _
                  "   SET REPORTSENDDATE = TO_DATE( to_char(to_date(:SENDDATE,'YYYY/MM/DD' ),'YYYY/MM/DD') || TO_CHAR(SYSDATE,'HH24MISS'),'YYYY/MM/DDHH24MISS'),     " & vbLf & _
                  "       CHARGEUSER     = :CHARGEUSER  " & vbLf & _
                  " WHERE ( RSVNO, SEQ ) IN             " & vbLf & _
                  "       (SELECT RSVNO, MAX(SEQ)       " & vbLf & _
                  "          FROM CONSULT_REPSEND       " & vbLf & _
                  "         WHERE RSVNO = :RSVNO        " & vbLf & _
                  "         GROUP BY RSVNO)             "
        
        
        Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
        
        If Ret > 0 Then
            Ret = INSERT_NORMAL
        End If
    
    Else
    
        '挿入モードの場合
'### 2005.08.05 張 成績書発送日指定して処理できるように引数追加
'        strStmt = "INSERT INTO CONSULT_REPSEND (RSVNO, SEQ, INSDATE, INSUSER, REPORTSENDDATE, CHARGEUSER)     " & vbLf & _
'                  "       SELECT :RSVNO RSVNO,                                                                " & vbLf & _
'                  "              (SELECT NVL(MAX(SEQ), 0) + 1 FROM CONSULT_REPSEND WHERE RSVNO = :RSVNO) SEQ, " & vbLf & _
'                  "              SYSDATE,                                                                     " & vbLf & _
'                  "              :CHARGEUSER,                                                                 " & vbLf & _
'                  "              SYSDATE,                                                                     " & vbLf & _
'                  "              :CHARGEUSER                                                                  " & vbLf & _
'                  "         FROM DUAL                                                                         "
    
        strStmt = "INSERT INTO CONSULT_REPSEND (RSVNO, SEQ, INSDATE, INSUSER, REPORTSENDDATE, CHARGEUSER)     " & vbLf & _
                  "       SELECT :RSVNO RSVNO,                                                                " & vbLf & _
                  "              (SELECT NVL(MAX(SEQ), 0) + 1 FROM CONSULT_REPSEND WHERE RSVNO = :RSVNO) SEQ, " & vbLf & _
                  "              SYSDATE,                                                                     " & vbLf & _
                  "              :CHARGEUSER,                                                                 " & vbLf & _
                  "              TO_DATE( to_char(to_date(:SENDDATE,'YYYY/MM/DD' ),'YYYY/MM/DD') || TO_CHAR(SYSDATE,'HH24MISS'),'YYYY/MM/DDHH24MISS'),  " & vbLf & _
                  "              :CHARGEUSER                                                                  " & vbLf & _
                  "         FROM DUAL                                                                         "
    
    
    
        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL

    End If
    
    '## 2004/05/18 ADD ST FAS)C.M
    If Ret = INSERT_NORMAL Then
        
        '検索条件を満たす受診情報テーブルのレコードを取得
        strStmt = "SELECT CSCD FROM CONSULT                                                  " & vbLf & _
                  " WHERE RSVNO = :RSVNO                                                     " & vbLf & _
                  "   AND CSCD IN (SELECT FREEFIELD1 FROM FREE WHERE FREECD LIKE 'RPTSEND%') "
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        '存在した場合、新規挿入する
        If Not objOraDyna.EOF Then
        
            strStmt = "INSERT INTO ORDER_JNL (RSVNO, TSKDATE, ODRDIV, TSKDIV, SENDDIV)      " & vbLf & _
                      "       SELECT :RSVNO RSVNO,                                          " & vbLf & _
                      "               SYSDATE,                                              " & vbLf & _
                      "               '2', '5', '0'                                         " & vbLf & _
                      "         FROM DUAL                                                   "
    
            'オーダージャーナルを挿入する
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
            Ret = INSERT_NORMAL
    
        End If
    End If
    '## 2004/05/18 ADD ED
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    UpdateReportSendDate = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    UpdateReportSendDate = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "ReportSendDate.UpdateReportSendDate"
    
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
' 機能　　 : 予約番号を指定して最新の成績書出力情報を取得する
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (Out)    vntSeq                SEQ
' 　　　　   (Out)    vntInsDate            登録日時
' 　　　　   (Out)    vntInsUser            登録ユーザ
' 　　　　   (Out)    vntInsUserName        登録ユーザ名
' 　　　　   (Out)    vntReportSendDate     成績書発送日
' 　　　　   (Out)    vntChargeUser         成績書発送ユーザ
' 　　　　   (Out)    vntChargeUserName     成績書発送ユーザ名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectConsult_ReptSendLast(ByVal lngRsvNo As String, _
                                           Optional ByRef vntSeq As Variant, _
                                           Optional ByRef vntInsDate As Variant, _
                                           Optional ByRef vntInsUser As Variant, _
                                           Optional ByRef vntInsUserName As Variant, _
                                           Optional ByRef vntReportSendDate As Variant, _
                                           Optional ByRef vntChargeUser As Variant, _
                                           Optional ByRef vntChargeUserName As Variant) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSeq              As OraField         'SEQ
    Dim objInsDate          As OraField         '登録日時
    Dim objInsUser          As OraField         '登録ユーザ
    Dim objInsUserName      As OraField         '登録ユーザ名
    Dim objReportSendDate   As OraField         '成績書発送日
    Dim objChargeUser       As OraField         '成績書発送ユーザ
    Dim objChargeUserName   As OraField         '成績書発送ユーザ名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    SelectConsult_ReptSendLast = False
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(lngRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たすレコードを取得
    strStmt = "SELECT MAINVIEW.RSVNO,                          " & vbLf & _
              "       MAINVIEW.SEQ,                            " & vbLf & _
              "       MAINVIEW.INSDATE,                        " & vbLf & _
              "       MAINVIEW.INSUSER,                        " & vbLf & _
              "       USER1.USERNAME INSUSERNAME,              " & vbLf & _
              "       MAINVIEW.REPORTSENDDATE,                 " & vbLf & _
              "       MAINVIEW.CHARGEUSER,                     " & vbLf & _
              "       USER2.USERNAME CHARGEUSERNAME            " & vbLf & _
              "  FROM HAINSUSER USER1, HAINSUSER USER2,        " & vbLf & _
              "       (                                        " & vbLf & _
              "         SELECT CONSULT_REPSEND.RSVNO,          " & vbLf & _
              "                CONSULT_REPSEND.SEQ,            " & vbLf & _
              "                CONSULT_REPSEND.INSDATE,        " & vbLf & _
              "                CONSULT_REPSEND.INSUSER,        " & vbLf & _
              "                CONSULT_REPSEND.REPORTSENDDATE, " & vbLf & _
              "                CONSULT_REPSEND.CHARGEUSER      " & vbLf & _
              "           FROM CONSULT_REPSEND                 " & vbLf & _
              "          WHERE CONSULT_REPSEND.RSVNO = :RSVNO  " & vbLf & _
              "          ORDER BY SEQ DESC                     " & vbLf & _
              "       ) MAINVIEW                               " & vbLf & _
              " WHERE MAINVIEW.INSUSER    = USER1.USERID       " & vbLf & _
              "   AND MAINVIEW.CHARGEUSER = USER2.USERID(+)    " & vbLf & _
              "   AND ROWNUM = 1                               "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSeq = objFields("SEQ")
        Set objInsDate = objFields("INSDATE")
        Set objInsUser = objFields("INSUSER")
        Set objInsUserName = objFields("INSUSERNAME")
        Set objReportSendDate = objFields("REPORTSENDDATE")
        Set objChargeUser = objFields("CHARGEUSER")
        Set objChargeUserName = objFields("CHARGEUSERNAME")
    
        '戻り値の設定
        If IsMissing(vntSeq) = False Then vntSeq = objSeq.Value & ""
        If IsMissing(vntInsDate) = False Then vntInsDate = objInsDate.Value & ""
        If IsMissing(vntInsUser) = False Then vntInsUser = objInsUser.Value & ""
        If IsMissing(vntInsUserName) = False Then vntInsUserName = objInsUserName.Value & ""
        If IsMissing(vntReportSendDate) = False Then vntReportSendDate = objReportSendDate.Value & ""
        If IsMissing(vntChargeUser) = False Then vntChargeUser = objChargeUser.Value & ""
        If IsMissing(vntChargeUserName) = False Then vntChargeUserName = objChargeUserName.Value & ""
        
        SelectConsult_ReptSendLast = True
        
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
    WriteErrorLog "ReportSendDate.SelectConsult_ReptSendLast"
    
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
' 機能　　 : 検索条件を満たす成績書作成情報の一覧を取得する
'
' 引数　　 : (In)     strMode               モード　CNT:件数をカウントのみ、NULL:データ取得
' 　　　　   (In)     strKey                検索キー
' 　　　　   (In)     vntStartCslDate       受診日（開始）
' 　　　　   (In)     vntEndCslDate         受診日（終了）
' 　　　　   (In)     strSearchCsCd         コースコード
' 　　　　   (In)     strSearchOrgCd1       団体コード１
' 　　　　   (In)     strSearchOrgCd2       団体コード２
' 　　　　   (In)     strSearchOrgGrpCd     団体グループコード
' 　　　　   (In)     lngSendMode           発送状態（0:全て、1:発送済み、2:未発送）
' 　　　　   (In)     lngStartPos           取得開始位置
' 　　　　   (In)     lngPageMaxLine        １ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）
' 　　　　   (Out)    vntRsvNo              予約番号
' 　　　　   (Out)    vntCslDate            受診日
' 　　　　   (Out)    vntDayId              当日ID
' 　　　　   (Out)    vntPerId              個人ID
' 　　　　   (Out)    vntCsCd               コースコード
' 　　　　   (Out)    vntCsName             コース名
' 　　　　   (Out)    vntwebColor           コース用カラー
' 　　　　   (Out)    vntLastName           漢字名（性）
' 　　　　   (Out)    vntFirstName          漢字名（名）
' 　　　　   (Out)    vntLastkName          カナ名（性）
' 　　　　   (Out)    vntFirstkName         カナ名（名）
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntOrgName            団体名
' 　　　　   (Out)    vntSendCount          発送確認履歴数
' 　　　　   (Out)    vntGfFlg              後日GF対象フラグ
' 　　　　   (Out)    vntCfFlg              後日CF対象フラグ
' 　　　　   (Out)    vntSeq                発送確認SEQ
' 　　　　   (Out)    vntInsDate            発送確認登録日
' 　　　　   (Out)    vntReportSendDate     発送確認日
' 　　　　   (Out)    vntInsUserName        発送確認登録者名
' 　　　　   (Out)    vntChargeUserName     発送確認者名
' 　　　　   (Out)    vntPubNote            コメント
' 　　　　   (Out)    vntReportOurEng       英文出力
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectReportSendDateList( _
    ByVal strMode As String, ByVal strKey As String, ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, ByVal strSearchCsCd As String, _
    ByVal strSearchOrgCd1 As String, ByVal strSearchOrgCd2 As String, ByVal strSearchOrgGrpCd As String, _
    ByVal lngSendMode As Long, _
    Optional ByVal lngStartPos As Long = 1, _
    Optional ByVal lngPageMaxLine As Long = 0, _
    Optional ByRef vntRsvNo As Variant, Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntDayId As Variant, Optional ByRef vntPerId As Variant, _
    Optional ByRef vntCsCd As Variant, Optional ByRef vntCsName As Variant, Optional ByRef vntwebColor As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastkName As Variant, Optional ByRef vntFirstkName As Variant, _
    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntSendCount As Variant, _
    Optional ByRef vntGfFlg As Variant, _
    Optional ByRef vntCfFlg As Variant, _
    Optional ByRef vntSeq As Variant, _
    Optional ByRef vntInsDate As Variant, _
    Optional ByRef vntReportSendDate As Variant, _
    Optional ByRef vntInsUserName As Variant, _
    Optional ByRef vntChargeUserName As Variant, _
    Optional ByRef vntPubNote As Variant, _
    Optional ByRef vntReportOurEng As Variant _
) As Long

    Dim objOraParam                As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                 As OraDynaset       'ダイナセット
    Dim strStmt                    As String           'SQLステートメント

    Dim objFields                  As OraFields        'フィールドオブジェクト
    
    Dim objRsvNo                   As OraField
    Dim objCslDate                 As OraField
    Dim objDayId                   As OraField
    Dim objPerId                   As OraField
    Dim objCsCd                    As OraField
    Dim objCsName                  As OraField
    Dim objwebColor                As OraField
    Dim objLastName                As OraField
    Dim objFirstName               As OraField
    Dim objLastkName               As OraField
    Dim objFirstkName              As OraField
    Dim objOrgCd1                  As OraField
    Dim objOrgCd2                  As OraField
    Dim objOrgName                 As OraField
    Dim objSendCount               As OraField
    Dim objGfFlg                   As OraField
    Dim objCfFlg                   As OraField
    Dim objChkCount                As OraField
    Dim objSeq                     As OraField
    Dim objInsDate                 As OraField
    Dim objInsUser                 As OraField
    Dim objReportSendDate          As OraField
    Dim objChargeUser              As OraField
    Dim objInsUserName             As OraField
    Dim objChargeUserName          As OraField
    Dim objPubNote                 As OraField
    Dim objReportOurEng            As OraField

    Dim lngCount                   As Long             '関数戻り値

    Dim vntArrRsvNo()              As Variant
    Dim vntArrCslDate()            As Variant
    Dim vntArrDayId()              As Variant
    Dim vntArrPerId()              As Variant
    Dim vntArrCsCd()               As Variant
    Dim vntArrCsName()             As Variant
    Dim vntArrwebColor()           As Variant
    Dim vntArrLastName()           As Variant
    Dim vntArrFirstName()          As Variant
    Dim vntArrLastkName()          As Variant
    Dim vntArrFirstkName()         As Variant
    Dim vntArrOrgCd1()             As Variant
    Dim vntArrOrgCd2()             As Variant
    Dim vntArrOrgName()            As Variant
    Dim vntArrSendCount()          As Variant
    Dim vntArrGfFlg()              As Variant
    Dim vntArrCfFlg()              As Variant
    Dim vntArrChkCount()           As Variant
    Dim vntArrSeq()                As Variant
    Dim vntArrInsDate()            As Variant
    Dim vntArrInsUser()            As Variant
    Dim vntArrReportSendDate()     As Variant
    Dim vntArrChargeUser()         As Variant
    Dim vntArrInsUserName()        As Variant
    Dim vntArrChargeUserName()     As Variant
    Dim vntArrPubNote()            As Variant
    Dim vntArrReportOurEng()       As Variant

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期値
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntwebColor) Then vntwebColor = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastkName) Then vntLastkName = Empty
    If Not IsMissing(vntFirstkName) Then vntFirstkName = Empty
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntSendCount) Then vntSendCount = Empty
    If Not IsMissing(vntGfFlg) Then vntGfFlg = Empty
    If Not IsMissing(vntCfFlg) Then vntCfFlg = Empty
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntInsDate) Then vntInsDate = Empty
    If Not IsMissing(vntReportSendDate) Then vntReportSendDate = Empty
    If Not IsMissing(vntInsUserName) Then vntInsUserName = Empty
    If Not IsMissing(vntChargeUserName) Then vntChargeUserName = Empty
    If Not IsMissing(vntPubNote) Then vntPubNote = Empty
    If Not IsMissing(vntReportOurEng) Then vntReportOurEng = Empty

    lngCount = 0

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngPageMaxLine > 0 Then
        objOraParam.Add "ENDPOS", (CLng(lngStartPos) + CLng(lngPageMaxLine) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    objOraParam.Add "STRDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE

    '検索条件を満たすレコードを取得
    If strMode = "CNT" Then
        '件数モードの場合
        strStmt = "SELECT COUNT(*) RECCOUNT" & vbLf
    Else
        'データ明細取得モードの場合
        strStmt = "SELECT MAINVIEW.*,                          " & vbLf & _
                  "       CONSULT_REPSEND.SEQ,                 " & vbLf & _
                  "       CONSULT_REPSEND.INSDATE,             " & vbLf & _
                  "       CONSULT_REPSEND.INSUSER,             " & vbLf & _
                  "       CONSULT_REPSEND.REPORTSENDDATE,      " & vbLf & _
                  "       CONSULT_REPSEND.CHARGEUSER,          " & vbLf & _
                  "       USER1.USERNAME INSUSERNAME,                                                   " & vbLf & _
                  "       USER2.USERNAME CHARGEUSERNAME,                                                " & vbLf & _
                  "       COURSE_P.CSNAME, COURSE_P.WEBCOLOR,                                           " & vbLf & _
                  "       PUBNOTEPACKAGE.EDITCSLPUBNOTEONELINE(MAINVIEW.RSVNO, NULL, 2) PUBNOTE         " & vbLf & _
                  "  FROM COURSE_P, HAINSUSER USER1, HAINSUSER USER2, CONSULT_REPSEND,                  " & vbLf & _
                  "       (                                                                             " & vbLf & _
                  "        SELECT NATIVEVIEW.*, ROWNUM CHKCOUNT                                         " & vbLf
    End If

    '-------------------------------------------------------------------------------------------------------------------------
    '   ちょっと反則コメントだが、ここから下がカウント、件数ともに共通のもの
    '-------------------------------------------------------------------------------------------------------------------------
    strStmt = strStmt & _
              "          FROM                                                                       " & vbLf & _
              "              (                                                                      " & vbLf & _
              "                SELECT RECEIPT.RSVNO, RECEIPT.CSLDATE, RECEIPT.DAYID, CONSULT.PERID,                  " & vbLf & _
              "                       PERSON.LASTNAME, PERSON.FIRSTNAME, CONSULT.CSCD,                               " & vbLf & _
              "                       PERSON.LASTKNAME, PERSON.FIRSTKNAME, ORG.ORGCD1, ORG.ORGCD2, ORG.ORGSNAME,     " & vbLf & _
              "                       CONSULT.REPORTOURENG,                                                          " & vbLf & _
              "                       (SELECT COUNT(CONSULT_REPSEND.RSVNO) FROM CONSULT_REPSEND WHERE CONSULT_REPSEND.RSVNO = RECEIPT.RSVNO) SENDCOUNT, " & vbLf & _
              "                       (SELECT COUNT(RSL.RSVNO) FROM RSL WHERE RSL.RSVNO = CONSULT.RSVNO AND ITEMCD = '" & mstrItemCdForGFFlg & "' AND SUFFIX = '" & mstrSuffixForGFFlg & "') GFFLG,  " & vbLf & _
              "                       (SELECT COUNT(RSL.RSVNO) FROM RSL WHERE RSL.RSVNO = CONSULT.RSVNO AND ITEMCD = '" & mstrItemCdForCFFlg & "' AND SUFFIX = '" & mstrSuffixForCFFlg & "') CFFLG   " & vbLf & _
              "                  FROM                                                                       " & vbLf

    '団体グループコードが指定されている場合
    If Trim(strSearchOrgGrpCd) <> "" Then
        objOraParam.Add "ORGGRPCD", strSearchOrgGrpCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & _
                  "                       (SELECT ORGCD1, ORGCD2 FROM ORGGRP_I WHERE ORGGRPCD = :ORGGRPCD) ORGGRP,  " & vbLf
    End If

   '※CONSULTにも日付しばりがあった方がレスポンスがよい
    strStmt = strStmt & _
              "                       ORG, PERSON, CONSULT, RECEIPT                                         " & vbLf & _
              "                 WHERE RECEIPT.CSLDATE BETWEEN :STRDATE AND :ENDDATE                         " & vbLf & _
              "                   AND CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE                         " & vbLf & _
              "                   AND CONSULT.RSVNO = RECEIPT.RSVNO                                         " & vbLf & _
              "                   AND RECEIPT.COMEDATE IS NOT NULL                                          " & vbLf & _
              "                   AND PERSON.PERID = CONSULT.PERID                                          " & vbLf & _
              "                   AND ORG.ORGCD1 = CONSULT.ORGCD1                                           " & vbLf & _
              "                   AND ORG.ORGCD2 = CONSULT.ORGCD2                                           " & vbLf
    
    'コースコードが指定されている場合
    If Trim(strSearchCsCd) <> "" Then
        objOraParam.Add "CSCD", strSearchCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & _
                  "                   AND CONSULT.CSCD = :CSCD                                              " & vbLf
    End If
    
    '個人IDが指定されている場合
    If Trim(strKey) <> "" Then
        objOraParam.Add "PERID", strKey, ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & _
                  "                   AND CONSULT.PERID = :PERID                                            " & vbLf
    End If
    
    '団体コードが指定されている場合
    If Trim(strSearchOrgCd1) <> "" And Trim(strSearchOrgCd2) <> "" Then
        objOraParam.Add "ORGCD1", strSearchOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", strSearchOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & _
                  "                   AND CONSULT.ORGCD1 = :ORGCD1                                          " & vbLf & _
                  "                   AND CONSULT.ORGCD2 = :ORGCD2                                          " & vbLf
    End If

    '団体グループコードが指定されている場合
    If Trim(strSearchOrgGrpCd) <> "" Then
        strStmt = strStmt & _
                  "                   AND CONSULT.ORGCD1 = ORGGRP.ORGCD1                                    " & vbLf & _
                  "                   AND CONSULT.ORGCD2 = ORGGRP.ORGCD2                                    " & vbLf
    End If

    strStmt = strStmt & _
              "              ORDER BY CSLDATE , DAYID   ) NATIVEVIEW                                           " & vbLf

    '発送済みの指定がある場合
    If lngSendMode = 1 Then
        strStmt = strStmt & _
                  "        WHERE SENDCOUNT > 0                                                              " & vbLf
    End If

    '未発送の指定がある場合
    If lngSendMode = 2 Then
        strStmt = strStmt & _
                  "        WHERE SENDCOUNT = 0                                                              " & vbLf
    End If

    '-------------------------------------------------------------------------------------------------------------------------
    If strMode = "" Then
        
        '明細モードの場合
        strStmt = strStmt & _
                  "        ORDER BY NATIVEVIEW.CSLDATE, NATIVEVIEW.DAYID                                        " & vbLf & _
                  "       ) MAINVIEW                                                                            " & vbLf
    
        strStmt = strStmt & _
                  " WHERE MAINVIEW.RSVNO             = CONSULT_REPSEND.RSVNO(+)                                 " & vbLf & _
                  "   AND MAINVIEW.CSCD              = COURSE_P.CSCD                                            " & vbLf & _
                  "   AND CONSULT_REPSEND.INSUSER    = USER1.USERID(+)                                          " & vbLf & _
                  "   AND CONSULT_REPSEND.CHARGEUSER = USER2.USERID(+)                                          "
    
         '取得件数で絞込み
        strStmt = strStmt & vbLf & _
                  "   AND CHKCOUNT >= :STARTPOS "
        
        If lngPageMaxLine > 0 Then
            strStmt = strStmt & vbLf & _
                  "   AND CHKCOUNT <= :ENDPOS "
        End If
                 
        strStmt = strStmt & _
                  " ORDER BY MAINVIEW.CSLDATE, MAINVIEW.DAYID, CHKCOUNT, SEQ                                                                      "
    
    End If

    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    If strMode = "CNT" Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        lngCount = objFields("RECCOUNT").Value
    End If

    '検索レコードが存在し、かつ全件モードの場合
    If Not objOraDyna.EOF And strMode = "" Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objDayId = objFields("DAYID")
        Set objPerId = objFields("PERID")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objwebColor = objFields("WEBCOLOR")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastkName = objFields("LASTKNAME")
        Set objFirstkName = objFields("FIRSTKNAME")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGSNAME")
        Set objSendCount = objFields("SENDCOUNT")
        Set objGfFlg = objFields("GFFLG")
        Set objCfFlg = objFields("CFFLG")
        Set objChkCount = objFields("CHKCOUNT")
        Set objSeq = objFields("SEQ")
        Set objInsDate = objFields("INSDATE")
        Set objInsUser = objFields("INSUSER")
        Set objReportSendDate = objFields("REPORTSENDDATE")
        Set objChargeUser = objFields("CHARGEUSER")
        Set objInsUserName = objFields("INSUSERNAME")
        Set objChargeUserName = objFields("CHARGEUSERNAME")
        Set objPubNote = objFields("PUBNOTE")
        Set objReportOurEng = objFields("REPORTOURENG")

        '配列形式で格納する
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrDayId(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrwebColor(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastkName(lngCount)
            ReDim Preserve vntArrFirstkName(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrSendCount(lngCount)
            ReDim Preserve vntArrGfFlg(lngCount)
            ReDim Preserve vntArrCfFlg(lngCount)
            ReDim Preserve vntArrChkCount(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrInsDate(lngCount)
            ReDim Preserve vntArrInsUser(lngCount)
            ReDim Preserve vntArrReportSendDate(lngCount)
            ReDim Preserve vntArrChargeUser(lngCount)
            ReDim Preserve vntArrInsUserName(lngCount)
            ReDim Preserve vntArrChargeUserName(lngCount)
            ReDim Preserve vntArrPubNote(lngCount)
            ReDim Preserve vntArrReportOurEng(lngCount)

            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrDayId(lngCount) = objDayId.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrwebColor(lngCount) = objwebColor.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastkName(lngCount) = objLastkName.Value & ""
            vntArrFirstkName(lngCount) = objFirstkName.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrSendCount(lngCount) = objSendCount.Value & ""
            vntArrGfFlg(lngCount) = objGfFlg.Value & ""
            vntArrCfFlg(lngCount) = objCfFlg.Value & ""
            vntArrChkCount(lngCount) = objChkCount.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrInsDate(lngCount) = objInsDate.Value & ""
            vntArrInsUser(lngCount) = objInsUser.Value & ""
            vntArrReportSendDate(lngCount) = objReportSendDate.Value & ""
            vntArrChargeUser(lngCount) = objChargeUser.Value & ""
            vntArrInsUserName(lngCount) = objInsUserName.Value & ""
            vntArrChargeUserName(lngCount) = objChargeUserName.Value & ""
            vntArrPubNote(lngCount) = objPubNote.Value & ""
            vntArrReportOurEng(lngCount) = objReportOurEng.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntwebColor) Then vntwebColor = vntArrwebColor
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastkName) Then vntLastkName = vntArrLastkName
        If Not IsMissing(vntFirstkName) Then vntFirstkName = vntArrFirstkName
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
        If Not IsMissing(vntOrgName) Then vntOrgName = vntArrOrgName
        If Not IsMissing(vntSendCount) Then vntSendCount = vntArrSendCount
        If Not IsMissing(vntGfFlg) Then vntGfFlg = vntArrGfFlg
        If Not IsMissing(vntCfFlg) Then vntCfFlg = vntArrCfFlg
        If Not IsMissing(vntSeq) Then vntSeq = vntArrSeq
        If Not IsMissing(vntInsDate) Then vntInsDate = vntArrInsDate
        If Not IsMissing(vntReportSendDate) Then vntReportSendDate = vntArrReportSendDate
        If Not IsMissing(vntInsUserName) Then vntInsUserName = vntArrInsUserName
        If Not IsMissing(vntChargeUserName) Then vntChargeUserName = vntArrChargeUserName
        If Not IsMissing(vntPubNote) Then vntPubNote = vntArrPubNote
        If Not IsMissing(vntReportOurEng) Then vntReportOurEng = vntArrReportOurEng

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    SelectReportSendDateList = lngCount

    Exit Function

ErrorHandle:

    SelectReportSendDateList = -1

    'イベントログ書き込み
    WriteErrorLog "ReportSendDate.SelectReportSendDateList"

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
