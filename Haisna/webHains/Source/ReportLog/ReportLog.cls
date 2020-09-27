VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "ReportLog"
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

Private mobjContext         As ObjectContext                'オブジェクトコンテキスト
Private mobjOraSession      As OraSessionClass              'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase                  'OraDatabaseオブジェクト

'モジュール名
Private Const MODULE_NAME   As String = "WebHains.ReportLog"

'
' 機能　　 : 指定日以前の印刷ログテーブルレコードを削除する
'
' 引数　　 : (In)     vntPrintDate   印刷開始日時
' 引数　　 : (In)     vntPrintSeq    印刷SEQ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteReportLog(Optional ByVal vntPrintDate As Variant, _
                                Optional ByVal vntPrintSeq As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
'### 2003.03.08 Added by Ishihara@FSIT PrintSeqによる削除対応
    Dim blnDateMode     As Boolean          'TRUE:日付削除モード
    Dim blnSeqMode      As Boolean          'FALSE:SEQ削除モード
'### 2003.03.08 Added End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
'### 2003.03.08 Added by Ishihara@FSIT PrintSeqによる削除対応
    DeleteReportLog = False
    blnDateMode = False
    blnSeqMode = False

    '引数の有効値チェック
    Do
        
        'Seqが有効指定されている場合、日付設定されていても無視
        If IsMissing(vntPrintSeq) = False Then
            If IsNumeric(vntPrintSeq) = True And Trim(vntPrintSeq) <> "" Then
                blnSeqMode = True
                Exit Do
            End If
        End If
        
        '日付がまともな日付なら日付モード
        If IsMissing(vntPrintDate) = False Then
            If Trim(vntPrintDate) <> "" And IsDate(vntPrintDate) = True Then
                blnDateMode = True
            End If
        End If
        
        Exit Do
        
    Loop
    
    '日付もSEQもまともに指定されていないなら処理終了
    If (blnSeqMode = False) And (blnDateMode = False) Then Exit Function
'### 2003.03.08 Added End
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    '指定日以前の印刷ログテーブルレコードを削除
    strStmt = "DELETE REPORTLOG "
    
'### 2003.03.08 Modified by Ishihara@FSIT 完全は日付の場合のみ、有効
'    If vntPrintDate > 0 Then
    If blnDateMode = True Then
'### 2003.03.08 Modified End
        objOraParam.Add "PRINTDATE", CDate(vntPrintDate), ORAPARM_INPUT, ORATYPE_DATE
        strStmt = strStmt & vbLf & _
              " WHERE PRINTDATE < :PRINTDATE "
    End If
    
'### 2003.03.08 Modified by Ishihara@FSIT 完全は日付の場合のみ、有効
'    If vntPrintDate > 0 Then
    If blnSeqMode = True Then
'### 2003.03.08 Modified End
        objOraParam.Add "PRINTSEQ", CLng(Trim(vntPrintSeq)), ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
              " WHERE PRINTSEQ = :PRINTSEQ "
    End If
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteReportLog = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteReportLog = False

    'イベントログ書き込み
    WriteErrorLog "ReportLog.DeleteReportLog"
    
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
' 機能　　 : 帳票ログデータを取得する
'
' 引数　　 : (In)    vntInPrintDate         出力日時
' 　　　　   (In)    vntInReportCd          帳票コード
' 　　　　   (In)    vntSortOld             TRUE:古い順に表示（省略時は最新順）
' 　　　　   (In)    vntPrtStatus           ステータス
' 　　　　   (Out)   vntPrintSeq            プリントＳＥＱ
' 　　　　   (Out)   vntPrintDate           印刷開始日時
' 　　　　   (Out)   vntReportCd            帳票コード
' 　　　　   (Out)   vntReportName          帳票名
' 　　　　   (Out)   vntUserId              ユーザＩＤ
' 　　　　   (Out)   vntUserName            ユーザ名
' 　　　　   (Out)   vntStatus              ステータス
' 　　　　   (Out)   vntReportTempID        帳票一時ファイル名
' 　　　　   (Out)   vntEndDate             印刷終了時間
' 　　　　   (Out)   vntCount               出力枚数
' 　　　　   (In)    vntInUserID            出力ユーザ
' 　　　　   (In)    vntTempPath            帳票一時ファイル出力パス
' 　　　　   (Out)   vntTempExists          TRUE:帳票一時ファイルが存在
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectReportLog(Optional ByVal vntInPrintDate As Variant, _
                                Optional ByVal vntInReportCd As Variant, _
                                Optional ByVal vntSortOld As Variant, _
                                Optional ByVal vntPrtStatus As Variant, _
                                Optional ByRef vntPrintSeq As Variant, _
                                Optional ByRef vntPrintDate As Variant, _
                                Optional ByRef vntReportCd As Variant, _
                                Optional ByRef vntReportName As Variant, _
                                Optional ByRef vntUserId As Variant, _
                                Optional ByRef vntUserName As Variant, _
                                Optional ByRef vntStatus As Variant, _
                                Optional ByRef vntReportTempId As Variant, _
                                Optional ByRef vntEndDate As Variant, _
                                Optional ByRef vntCount As Variant, _
                                Optional ByVal vntInUserID As Variant) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPrintSeq             As OraField         'プリントＳＥＱ
    Dim objPrintDate            As OraField         '印刷開始日時
    Dim objReportCd             As OraField         '帳票コード
    Dim objReportName           As OraField         '帳票名
    Dim objUserId               As OraField         'ユーザＩＤ
    Dim objUserName             As OraField         'ユーザ名
    Dim objStatus               As OraField         'ステータス
    Dim objReportTempId         As OraField         '帳票一時ファイル名
    Dim objEndDate              As OraField         '印刷終了時間
    Dim objCount                As OraField         '出力枚数
    
    Dim vntArrPrintSeq()        As Variant          'プリントＳＥＱ
    Dim vntArrPrintDate()       As Variant          '印刷開始日時
    Dim vntArrReportCd()        As Variant          '帳票コード
    Dim vntArrReportName()      As Variant          '帳票名
    Dim vntArrUserId()          As Variant          'ユーザＩＤ
    Dim vntArrUserName()        As Variant          'ユーザ名
    Dim vntArrStatus()          As Variant          'ステータス
    Dim vntArrReportTempID()    As Variant          '帳票一時ファイル名
    Dim vntArrEndDate()         As Variant          '印刷終了時間
    Dim vntArrCount()           As Variant          '出力枚数
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    SelectReportLog = INSERT_ERROR
    
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '検索条件を満たす端末通過情報テーブルのレコードを取得
    strStmt = "SELECT REPORTLOG.PRINTSEQ, REPORTLOG.PRINTDATE, REPORTLOG.REPORTCD, NVL(REPORTLOG.REPORTNAME, REPORT.REPORTNAME) REPORTNAME, " & _
              "       REPORTLOG.USERID,   HAINSUSER.USERNAME,  REPORTLOG.STATUS,   REPORTLOG.REPORTTEMPID, " & _
              "       REPORTLOG.ENDDATE,  REPORTLOG.COUNT " & _
              "  FROM REPORT REPORT, HAINSUSER HAINSUSER, REPORTLOG REPORTLOG " & _
              " WHERE REPORTLOG.USERID  = HAINSUSER.USERID " & _
              "   AND REPORTLOG.REPORTCD = REPORT.REPORTCD(+) "
    
    '出力日時指定の場合
    If IsMissing(vntInPrintDate) = False Then
        objOraParam.Add "PRINTDATE", Trim(vntInPrintDate), ORAPARM_INPUT, ORATYPE_DATE
        strStmt = strStmt & " AND REPORTLOG.PRINTDATE >= :PRINTDATE"
    End If
    
    '帳票コード指定の場合
    If IsMissing(vntInReportCd) = False Then
        objOraParam.Add "REPORTCD", Trim(vntInReportCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & " AND REPORTLOG.REPORTCD = :REPORTCD"
    End If
    
'### 2002.04.07 Added By H.Ishihara@FSIT 出力ユーザ指定オプション追加
    '出力ユーザ指定の場合
    If IsMissing(vntInUserID) = False Then
        If Trim(vntInUserID) <> "" Then
            objOraParam.Add "USERID", Trim(vntInUserID), ORAPARM_INPUT, ORATYPE_VARCHAR2
            strStmt = strStmt & " AND REPORTLOG.USERID = :USERID"
        End If
    End If
'### 2002.04.07 Added End
    
    'ステータス指定の場合
    If IsMissing(vntPrtStatus) = False Then
        If (IsNumeric(vntPrtStatus) = True) And (Trim(vntPrtStatus) <> "") Then
            If CLng(vntPrtStatus) < 3 Then
                objOraParam.Add "STATUS", Trim(vntPrtStatus), ORAPARM_INPUT, ORATYPE_NUMBER
                strStmt = strStmt & " AND REPORTLOG.STATUS = :STATUS"
            End If
        End If
    End If
    
    'ソート順指定の場合
    If IsMissing(vntSortOld) = False Then
        If vntSortOld = True Then
            strStmt = strStmt & " ORDER BY REPORTLOG.PRINTDATE ASC"
        Else
            strStmt = strStmt & " ORDER BY REPORTLOG.PRINTDATE DESC"
        End If
    Else
        strStmt = strStmt & " ORDER BY REPORTLOG.PRINTDATE DESC"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    Do Until objOraDyna.EOF
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPrintSeq = objFields("PRINTSEQ")
        Set objPrintDate = objFields("PRINTDATE")
        Set objReportCd = objFields("REPORTCD")
        Set objReportName = objFields("REPORTNAME")
        Set objUserId = objFields("USERID")
        Set objUserName = objFields("USERNAME")
        Set objStatus = objFields("STATUS")
        Set objReportTempId = objFields("REPORTTEMPID")
        Set objEndDate = objFields("ENDDATE")
        Set objCount = objFields("COUNT")
    
        '戻り値の設定
        ReDim Preserve vntArrPrintSeq(lngCount)
        ReDim Preserve vntArrPrintDate(lngCount)
        ReDim Preserve vntArrReportCd(lngCount)
        ReDim Preserve vntArrReportName(lngCount)
        ReDim Preserve vntArrUserId(lngCount)
        ReDim Preserve vntArrUserName(lngCount)
        ReDim Preserve vntArrStatus(lngCount)
        ReDim Preserve vntArrReportTempID(lngCount)
        ReDim Preserve vntArrEndDate(lngCount)
        ReDim Preserve vntArrCount(lngCount)
        
        vntArrPrintSeq(lngCount) = objPrintSeq.Value & ""
        vntArrPrintDate(lngCount) = objPrintDate.Value & ""
        vntArrReportCd(lngCount) = objReportCd.Value & ""
        vntArrReportName(lngCount) = objReportName.Value & ""
        vntArrUserId(lngCount) = objUserId.Value & ""
        vntArrUserName(lngCount) = objUserName.Value & ""
        vntArrStatus(lngCount) = objStatus.Value & ""
        vntArrReportTempID(lngCount) = objReportTempId.Value & ""
        vntArrEndDate(lngCount) = objEndDate.Value & ""
        vntArrCount(lngCount) = objCount.Value & ""
        lngCount = lngCount + 1
        objOraDyna.MoveNext
        
    Loop
    
    '戻り値の設定
    If Not IsMissing(vntPrintSeq) Then vntPrintSeq = vntArrPrintSeq
    If Not IsMissing(vntPrintDate) Then vntPrintDate = vntArrPrintDate
    If Not IsMissing(vntReportCd) Then vntReportCd = vntArrReportCd
    If Not IsMissing(vntReportName) Then vntReportName = vntArrReportName
    If Not IsMissing(vntUserId) Then vntUserId = vntArrUserId
    If Not IsMissing(vntUserName) Then vntUserName = vntArrUserName
    If Not IsMissing(vntStatus) Then vntStatus = vntArrStatus
    If Not IsMissing(vntReportTempId) Then vntReportTempId = vntArrReportTempID
    If Not IsMissing(vntEndDate) Then vntEndDate = vntArrEndDate
    If Not IsMissing(vntCount) Then vntCount = vntArrCount
    
    SelectReportLog = lngCount
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectReportLog = INSERT_ERROR
    
    'イベントログ書き込み
    WriteErrorLog "IPAddress.SelectReportLog"
    
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
' 機能　　 : 印刷ログテーブルに書き込み
'
' 引数　　 : (In)     lngPrintSeq               プリントＳＥＱ
' 　　　　 : (In)     strReportCd               帳票コード
' 　　　　 : (In)     strUserId                 ユーザＩＤ
' 　　　　 : (In)     lngStatus                 ステータス
' 　　　　 : (In)     strReportTmpID            帳票一時ファイル名
' 　　　　 : (In)     lngCount                  出力枚数
' 　　　　 : (Out)    vntPrintSeq               プリントＳＥＱ
'
' 戻り値　 : 0      正常終了
' 　　　　 : 9      異常終了
'
' 備考　　 :(IN)strPrintSeqが０の場合、　　印刷開始　(Out)vntPrintSeqにＳＥＱを返す
' 　　　　  (IN)strPrintSeqが０以外の場合、印刷終了
'
Public Function InsertReportLog(ByVal lngPrintSeq As Long, ByVal strReportCd As String, _
                          ByVal strUserId As String, ByVal lngStatus As Long, _
                          ByVal strReportTmpID As String, ByVal lngCount As Long, _
                          ByRef vntPrintSeq As Variant _
                         ) As Long
    

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト

    Dim objPrintSeq             As OraField         'キー
    
    Dim lngOutPrintSeq          As Long
    
    InsertReportLog = True

     'エラーハンドラの設定
    On Error GoTo ErrorHandle

    If lngPrintSeq = 0 Then
        ''追加処理
        
        'プリントＳＥＱ取得処理
        strStmt = "SELECT PRINTSEQ_SEQ.NEXTVAL AS PRINTSEQ FROM DUAL"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

        '検索レコードが存在する場合
        If Not objOraDyna.EOF Then
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objPrintSeq = objFields("PRINTSEQ")
            
            lngOutPrintSeq = CLng("0" & objPrintSeq.Value)
            vntPrintSeq = lngOutPrintSeq
        
        End If
        Set objOraDyna = Nothing

        'キー値の設定
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "PRINTSEQ", CLng(lngOutPrintSeq), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "REPORTCD", Trim(strReportCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "USERID", Trim(strUserId), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "STATUS", CLng(lngStatus), ORAPARM_INPUT, ORATYPE_NUMBER

        '印刷ログテーブル追加処理
        strStmt = "INSERT INTO REPORTLOG ( PRINTSEQ, PRINTDATE, REPORTCD, USERID, STATUS)" & vbLf & _
                  " VALUES " & vbLf & _
                  "( :PRINTSEQ, SYSDATE, :REPORTCD, :USERID, :STATUS)" & vbLf

    Else
        'キー値の設定
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "PRINTSEQ", Trim(lngPrintSeq), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "STATUS", CLng(lngStatus), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "REPORTTEMPID", Trim(strReportTmpID), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "COUNT", CLng(lngCount), ORAPARM_INPUT, ORATYPE_NUMBER

        '印刷ログテーブル更新処理
        strStmt = "UPDATE REPORTLOG SET " & _
                  "       STATUS       = :STATUS" & vbLf & _
                  "      ,REPORTTEMPID = :REPORTTEMPID" & vbLf & _
                  "      ,ENDDATE      = SYSDATE" & vbLf & _
                  "      ,COUNT        = :COUNT" & vbLf & _
                  " WHERE PRINTSEQ     = :PRINTSEQ"
    
    End If

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "ReportLog.InsertReportLog"
    
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
    
    InsertReportLog = False

End Function

'
' 機能　　 : 次プリントSEQの取得
'
' 引数　　 :
'
' 戻り値　 : 次に発番するプリントSEQ
'
' 備考　　 :
'
Public Function GetNextPrintSeq() As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objPrintSeq     As OraField         'プリントSEQ

    Dim Ret             As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    Ret = -1

    'Oracle Sequence取得
    strStmt = "SELECT PRINTSEQ_SEQ.NEXTVAL PRINTSEQ FROM DUAL"

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPrintSeq = objFields("PRINTSEQ")

        '戻り値の設定
        Ret = CLng(objPrintSeq.Value)

    End If

    '戻り値の設定
    GetNextPrintSeq = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    GetNextPrintSeq = -1

    'イベントログ書き込み
    WriteErrorLog "ReportLog.GetNextPrintSeq"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 印刷ログテーブルレコードの新規作成
'
' 引数　　 : (In)     lngPrintSeq  プリントSEQ
' 　　　　   (In)     strReportCd  帳票コード
' 　　　　   (In)     strUserId    ユーザID
'
' 戻り値　 : True   正常終了
'          : False  異常終了
'
' 備考　　 :
'
Public Function InsertReportLog2(ByVal lngPrintSeq As Long, ByVal strReportCd As String, ByVal strUserId As String, Optional ByVal strReportName As String) As Boolean
    
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

     'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'パラメータの設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PRINTSEQ", lngPrintSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPORTCD", strReportCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USERID", strUserId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REPORTNAME", strReportName, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '印刷ログテーブルレコードの挿入
    strStmt = "INSERT INTO REPORTLOG (  " & vbLf & _
              "            PRINTSEQ,    " & vbLf & _
              "            PRINTDATE,   " & vbLf & _
              "            REPORTCD,    " & vbLf & _
              "            REPORTNAME,  " & vbLf & _
              "            USERID,      " & vbLf & _
              "            STATUS       " & vbLf & _
              "       ) VALUES (        " & vbLf & _
              "            :PRINTSEQ,   " & vbLf & _
              "            SYSDATE,     " & vbLf & _
              "            :REPORTCD,   " & vbLf & _
              "            :REPORTNAME, " & vbLf & _
              "            :USERID,     " & vbLf & _
              "            0            " & vbLf & _
              "       )                 "

    'SQL実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

'#### 2010.08.30 SL-HS-Y0101-002 ADD START ####
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'#### 2010.08.30 SL-HS-Y0101-002 ADD END ####
    
    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    InsertReportLog2 = True

    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "ReportLog.InsertReportLog2"
    
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
' 機能　　 : 印刷ログテーブルレコードの読み込み
'
' 引数　　 : (In)     lngPrintSeq      プリントSEQ
' 　　　　   (Out)    vntReportTempId  帳票一時ファイル名
' 　　　　   (Out)    vntReportCd      帳票コード
'
' 戻り値　 : True   正常終了
'            False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectReportLog2(ByVal lngPrintSeq As Long, ByRef vntReportTempId As Variant, Optional ByRef vntReportCd As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objReportTempId As OraField         '帳票一時ファイル名
    Dim objReportCd     As OraField         '帳票コード
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntReportTempId = Empty
    If Not IsMissing(vntReportCd) Then vntReportCd = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PRINTSEQ", lngPrintSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定プリントSEQの印刷ログ情報を取得
    strStmt = "SELECT REPORTTEMPID, REPORTCD " & vbLf & _
              "  FROM REPORTLOG              " & vbLf & _
              " WHERE PRINTSEQ = :PRINTSEQ   "

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objReportTempId = objFields("REPORTTEMPID")
        Set objReportCd = objFields("REPORTCD")
        
        '戻り値の設定
        vntReportTempId = objReportTempId.Value
        If Not IsMissing(vntReportCd) Then vntReportCd = objReportCd.Value & ""
        
        SelectReportLog2 = True
        
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
    WriteErrorLog "ReportLog.SelectReportLog2"
    
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
' 機能　　 : 印刷ログテーブルレコードの更新
'
' 引数　　 : (In)     lngPrintSeq      プリントSEQ
' 　　　　   (In)     lngStatus        ステータス
' 　　　　   (In)     strReportTempId  帳票一時ファイル名
'
' 戻り値　 : True   正常終了
'          : False  異常終了
'
' 備考　　 :
'
Public Function UpdateReportLog2(ByVal lngPrintSeq As Long, ByVal lngStatus As Long, ByVal strReportTempId As String) As Boolean
    
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

     'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'パラメータの設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PRINTSEQ", lngPrintSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STATUS", lngStatus, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPORTTEMPID", strReportTempId, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '印刷ログテーブルレコードの更新
    strStmt = "UPDATE REPORTLOG                     " & vbLf & _
              "   SET STATUS       = :STATUS,       " & vbLf & _
              "       REPORTTEMPID = :REPORTTEMPID, " & vbLf & _
              "       ENDDATE      = SYSDATE        " & vbLf & _
              " WHERE PRINTSEQ     = :PRINTSEQ      "

    'SQL実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

'#### 2010.08.30 SL-HS-Y0101-002 ADD START ####
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'#### 2010.08.30 SL-HS-Y0101-002 ADD END ####
    
    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    UpdateReportLog2 = True

    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "ReportLog.UpdateReportLog2"
    
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
    
    '共通クラスのインスタンス作成
    Set objCommon = New Common
     
     'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()
  
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

     'オブジェクトコンテキストを解放
    Set mobjContext = Nothing

End Sub



