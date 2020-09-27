VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 4  'RequiresNewTransaction
END
Attribute VB_Name = "HainsLog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : Hainsログデータを取得する
'
' 引数　　 : (In)    strMode                処理モード(CNT:件数カウント,SRC:検索)
' 　　　　   (In)    vntStartPos            SELECT開始位置
' 　　　　   (In)    vntGetCount            取得件数
' 　　　　   (In)    vntIn_TransactionDiv   表示処理区分
' 　　　　   (In)    vntIn_InformationDiv   表示情報区分
' 　　　　   (In)    vntIn_TransactionID    処理ID
' 　　　　   (In)    vntIn_Message          検索文字列
' 　　　　   (Out)   vntTransactionID       処理ID
' 　　　　   (Out)   vntInsDate             処理日時
' 　　　　   (Out)   vntTransactionDiv      処理区分
' 　　　　   (Out)   vntTransactionDiv      処理名称
' 　　　　   (Out)   vntInformationDiv      情報区分
' 　　　　   (Out)   vntStatementNo         処理行
' 　　　　   (Out)   vntLineNo              対象処理行
' 　　　　   (Out)   vntMessage1            メッセージ１
' 　　　　   (Out)   vntMessage2            メッセージ２
' 　　　　   (In)    vntOrderByOld          1:古いものから順に表示
' 　　　　   (In)    vntIn_InsDate          処理日時
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectHainsLog(ByVal strMode As String, _
                               Optional ByVal vntStartPos As Variant, _
                               Optional ByVal vntGetCount As Variant, _
                               Optional ByVal vntIn_TransactionDiv As Variant, _
                               Optional ByVal vntIn_InformationDiv As Variant, _
                               Optional ByVal vntIn_TransactionID As Variant, _
                               Optional ByVal vntIn_Message As Variant, _
                               Optional ByRef vntTransactionID As Variant, _
                               Optional ByRef vntInsDate As Variant, _
                               Optional ByRef vntTransactionDiv As Variant, _
                               Optional ByRef vntTransactionName As Variant, _
                               Optional ByRef vntInformationDiv As Variant, _
                               Optional ByRef vntStatementNo As Variant, _
                               Optional ByRef vntLineNo As Variant, _
                               Optional ByRef vntMessage1 As Variant, _
                               Optional ByRef vntMessage2 As Variant, _
                               Optional ByVal vntOrderByOld As Variant, _
                               Optional ByVal vntIn_InsDate As Variant) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objTransactionID        As OraField         'トランザクションID
    Dim objInsDate              As OraField         '処理日時
    Dim objTransactionDiv       As OraField         '処理区分
    Dim objTransactionName      As OraField         '処理名称
    Dim objInformationDiv       As OraField         '情報区分
    Dim objStatementNo          As OraField         '処理行
    Dim objLineNo               As OraField         '対象処理行
    Dim objMessage1             As OraField         'メッセージ１
    Dim objMessage2             As OraField         'メッセージ２
    Dim objRecordCount          As OraField
    
    Dim vntArrTransactionID()   As Variant          'トランザクションID
    Dim vntArrInsDate()         As Variant          '処理日時
    Dim vntArrTransactionDiv()  As Variant          '処理区分
    Dim vntArrTransactionName() As Variant          '処理名称
    Dim vntArrInformationDiv()  As Variant          '情報区分
    Dim vntArrStatementNo()     As Variant          '処理行
    Dim vntArrLineNo()          As Variant          '対象処理行
    Dim vntArrMessage1()        As Variant          'メッセージ１
    Dim vntArrMessage2()        As Variant          'メッセージ２
    
    Dim lngCount                As Long             'レコード数
    Dim strOrderby              As String
'### 2003.03.06 Added by Ishihara@FSIT 最新順対応
    Dim strWhereOrAnd           As String
'### 2003.03.06 Added End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    SelectHainsLog = INSERT_ERROR
    
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '取得件数と開始位置が設定されている場合
'### 2003.03.06 Added by Ishihara@FSIT 最新順対応
    If (IsMissing(vntStartPos) = False) And (IsMissing(vntGetCount) = False) Then
'### 2003.03.06 Added End
        If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) Then
            objOraParam.Add "SEQ_F", CLng(vntStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "SEQ_T", (CLng(vntStartPos) + CLng(vntGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    End If
    
'### 2003.03.06 Added by Ishihara@FSIT 最新順対応
    '表示順序制御用文字列
    strOrderby = "DESC"
    If IsMissing(vntOrderByOld) = False Then
        If Trim(vntOrderByOld) = "1" Then strOrderby = "ASC"
    End If
'### 2003.03.06 Added End
    
'### 2003.03.06 Added by Ishihara@FSIT 最新順対応
    strWhereOrAnd = " WHERE "
'### 2003.03.06 Added End
    
    '検索条件を満たすHainsログテーブルのレコードを取得
    
    'SQL文BUILD
    If strMode = "CNT" Then
        strStmt = _
                "SELECT COUNT(LASTVIEW.TRANSACTIONID) RECORDCOUNT " & vbLf
    Else
        
        strStmt = strStmt & _
                  "SELECT LASTVIEW.TRANSACTIONID,   " & vbLf & _
                  "       LASTVIEW.INSDATE,         " & vbLf & _
                  "       LASTVIEW.TRANSACTIONDIV,  " & vbLf & _
                  "       LASTVIEW.TRANSACTIONNAME, " & vbLf & _
                  "       LASTVIEW.INFORMATIONDIV,  " & vbLf & _
                  "       LASTVIEW.STATEMENTNO,     " & vbLf & _
                  "       LASTVIEW.LINENO,          " & vbLf & _
                  "       LASTVIEW.MESSAGE1,        " & vbLf & _
                  "       LASTVIEW.MESSAGE2         " & vbLf
                
    End If
        
    strStmt = strStmt & _
              "  FROM (                        " & vbLf & _
              "SELECT SEQVIEW.TRANSACTIONID,   " & vbLf & _
              "       SEQVIEW.INSDATE,         " & vbLf & _
              "       SEQVIEW.TRANSACTIONDIV,  " & vbLf & _
              "       SEQVIEW.TRANSACTIONNAME, " & vbLf & _
              "       SEQVIEW.INFORMATIONDIV,  " & vbLf & _
              "       SEQVIEW.STATEMENTNO,     " & vbLf & _
              "       SEQVIEW.LINENO,          " & vbLf & _
              "       SEQVIEW.MESSAGE1,        " & vbLf & _
              "       SEQVIEW.MESSAGE2,        " & vbLf & _
              "       SEQVIEW.ROWSEQ           " & vbLf
    
    strStmt = strStmt & _
              "  FROM (                          " & vbLf & _
              "SELECT BASICVIEW.TRANSACTIONID,   " & vbLf & _
              "       BASICVIEW.INSDATE,         " & vbLf & _
              "       BASICVIEW.TRANSACTIONDIV,  " & vbLf & _
              "       BASICVIEW.TRANSACTIONNAME, " & vbLf & _
              "       BASICVIEW.INFORMATIONDIV,  " & vbLf & _
              "       BASICVIEW.STATEMENTNO,     " & vbLf & _
              "       BASICVIEW.LINENO,          " & vbLf & _
              "       BASICVIEW.MESSAGE1,        " & vbLf & _
              "       BASICVIEW.MESSAGE2,        " & vbLf & _
              "       ROWNUM ROWSEQ              " & vbLf & _
              "  FROM (                          " & vbLf

    '処理トランザクション指定の場合
'### 2003.03.06 Updated by Ishihara@FSIT 最新順対応
'    strStmt = strStmt & _
              "SELECT HAINSLOG.TRANSACTIONID,        " & vbLf & _
              "       HAINSLOG.INSDATE,              " & vbLf & _
              "       HAINSLOG.TRANSACTIONDIV,       " & vbLf & _
              "       FREE.FREENAME TRANSACTIONNAME, " & vbLf & _
              "       HAINSLOG.INFORMATIONDIV,       " & vbLf & _
              "       HAINSLOG.STATEMENTNO,          " & vbLf & _
              "       HAINSLOG.LINENO,               " & vbLf & _
              "       HAINSLOG.MESSAGE1,             " & vbLf & _
              "       HAINSLOG.MESSAGE2              " & vbLf & _
              "  FROM FREE, HAINSLOG                 " & vbLf & _
              " WHERE HAINSLOG.TRANSACTIONDIV = FREE.FREECD (+)" & vbLf
    strStmt = strStmt & _
              "SELECT HAINSLOG.TRANSACTIONID,        " & vbLf & _
              "       HAINSLOG.INSDATE,              " & vbLf & _
              "       HAINSLOG.TRANSACTIONDIV,       " & vbLf & _
              "       FREE.FREENAME TRANSACTIONNAME, " & vbLf & _
              "       HAINSLOG.INFORMATIONDIV,       " & vbLf & _
              "       HAINSLOG.STATEMENTNO,          " & vbLf & _
              "       HAINSLOG.LINENO,               " & vbLf & _
              "       HAINSLOG.MESSAGE1,             " & vbLf & _
              "       HAINSLOG.MESSAGE2              " & vbLf
    
    'ORDERVIEW（最新順）の組み立て
    strStmt = strStmt & _
              "  FROM FREE, HAINSLOG,                 " & vbLf & _
              "       ( SELECT TRANSACTIONID, ROWNUM ORDERNO                      " & vbLf & _
              "           FROM ( SELECT TRANSACTIONID, MAX(INSDATE) MAXINSDATE    " & vbLf & _
              "                    FROM HAINSLOG                                  " & vbLf

    '処理トランザクション指定の場合
    If IsMissing(vntIn_TransactionDiv) = False Then
        If Trim(vntIn_TransactionDiv) <> "" Then
            objOraParam.Add "TRANSACTIONDIV", vntIn_TransactionDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
            strStmt = strStmt & strWhereOrAnd & " HAINSLOG.TRANSACTIONDIV = :TRANSACTIONDIV " & vbLf
            strWhereOrAnd = " AND "
        End If
    End If

    '処理日付指定の場合
    If IsMissing(vntIn_InsDate) = False Then
        If IsDate(vntIn_InsDate) Then
            objOraParam.Add "INSDATE", CDate(vntIn_InsDate), ORAPARM_INPUT, ORATYPE_DATE
            strStmt = strStmt & strWhereOrAnd & " TO_DATE(HAINSLOG.INSDATE) = :INSDATE " & vbLf
            strWhereOrAnd = " AND "
        End If
    End If

    '実行状態指定の場合
    If IsMissing(vntIn_InformationDiv) = False Then
        If Trim(vntIn_InformationDiv) <> "" Then
            objOraParam.Add "INFORMATIONDIV", vntIn_InformationDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
            strStmt = strStmt & strWhereOrAnd & " HAINSLOG.INFORMATIONDIV = :INFORMATIONDIV " & vbLf
            strWhereOrAnd = " AND "
        End If
    End If
    
    '処理ID指定の場合
    If IsMissing(vntIn_TransactionID) = False Then
        If (Trim(vntIn_TransactionID) <> "") And (IsNumeric(vntIn_TransactionID)) Then
            objOraParam.Add "TRANSACTIONID", vntIn_TransactionID, ORAPARM_INPUT, ORATYPE_NUMBER
            strStmt = strStmt & strWhereOrAnd & " HAINSLOG.TRANSACTIONID = :TRANSACTIONID " & vbLf
            strWhereOrAnd = " AND "
        End If
    End If

    strStmt = strStmt & _
              "                   GROUP BY TRANSACTIONID                          " & vbLf & _
              "                   ORDER BY MAXINSDATE " & strOrderby & ") BASEORDER ) ORDERVIEW " & vbLf
    
    strStmt = strStmt & _
              " WHERE HAINSLOG.TRANSACTIONDIV = FREE.FREECD (+)         " & vbLf & _
              "   AND HAINSLOG.TRANSACTIONID  = ORDERVIEW.TRANSACTIONID " & vbLf
'### 2003.03.06 Updated End
    
    '処理トランザクション指定の場合
    If IsMissing(vntIn_TransactionDiv) = False Then
        If Trim(vntIn_TransactionDiv) <> "" Then
'### 2003.03.06 Deleted by Ishihara@FSIT 最新順対応
'            objOraParam.Add "TRANSACTIONDIV", vntIn_TransactionDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.03.06 Deleted End
            strStmt = strStmt & " AND HAINSLOG.TRANSACTIONDIV = :TRANSACTIONDIV " & vbLf
        End If
    End If
    
'### 2003.03.06 Added by Ishihara@FSIT 最新順対応
    '処理日付指定の場合
    If IsMissing(vntIn_InsDate) = False Then
        If IsDate(vntIn_InsDate) Then
            strStmt = strStmt & " AND TO_DATE(HAINSLOG.INSDATE) = :INSDATE " & vbLf
        End If
    End If
'### 2003.03.06 Added End
    
    '実行状態指定の場合
    If IsMissing(vntIn_InformationDiv) = False Then
        If Trim(vntIn_InformationDiv) <> "" Then
'### 2003.03.06 Deleted by Ishihara@FSIT 最新順対応
'            objOraParam.Add "INFORMATIONDIV", vntIn_InformationDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.03.06 Deleted End
            strStmt = strStmt & " AND HAINSLOG.INFORMATIONDIV = :INFORMATIONDIV " & vbLf
        End If
    End If
    
    '処理ID指定の場合
    If IsMissing(vntIn_TransactionID) = False Then
        If (Trim(vntIn_TransactionID) <> "") And (IsNumeric(vntIn_TransactionID)) Then
'### 2003.03.06 Deleted by Ishihara@FSIT 最新順対応
'            objOraParam.Add "TRANSACTIONID", vntIn_TransactionID, ORAPARM_INPUT, ORATYPE_NUMBER
'### 2003.03.06 Deleted End
            strStmt = strStmt & " AND HAINSLOG.TRANSACTIONID = :TRANSACTIONID " & vbLf
        End If
    End If
    
    'メッセージ指定の場合
    If IsMissing(vntIn_Message) = False Then
        If Trim(vntIn_Message) <> "" Then
            strStmt = strStmt & " AND (( HAINSLOG.MESSAGE1 LIKE '%" & Trim(vntIn_Message) & "%') OR " & vbLf
            strStmt = strStmt & "      ( HAINSLOG.MESSAGE2 LIKE '%" & Trim(vntIn_Message) & "%'))"
        End If
    End If
    
    'ORDER BY 指定
'### 2003.03.06 Updated by Ishihara@FSIT 最新順対応
'    strStmt = strStmt & " ORDER BY HAINSLOG.TRANSACTIONID, HAINSLOG.STATEMENTNO   " & vbLf
    strStmt = strStmt & " ORDER BY ORDERVIEW.ORDERNO ASC, HAINSLOG.STATEMENTNO ASC " & vbLf
'### 2003.03.06 Updated by Ishihara@FSIT 最新順対応
    strStmt = strStmt & " ) BASICVIEW " & vbLf
    strStmt = strStmt & " ) SEQVIEW "
    
    '取得件数と開始位置が設定されている場合
    If strMode <> "CNT" Then
        If (IsMissing(vntStartPos) = False) And (IsMissing(vntGetCount) = False) Then
            If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) And _
               Trim(vntStartPos) <> "" And Trim(vntGetCount) <> "" Then
                    strStmt = strStmt & vbLf & _
                              "   WHERE SEQVIEW.ROWSEQ BETWEEN :SEQ_F AND :SEQ_T " & vbLf
            End If
        End If
    End If
    
    strStmt = strStmt & _
            "        ) LASTVIEW                                                 "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        If strMode = "CNT" Then
            Set objRecordCount = objFields("RECORDCOUNT")
        Else
            
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objTransactionID = objFields("TRANSACTIONID")
            Set objInsDate = objFields("INSDATE")
            Set objTransactionDiv = objFields("TRANSACTIONDIV")
            Set objTransactionName = objFields("TRANSACTIONNAME")
            Set objInformationDiv = objFields("INFORMATIONDIV")
            Set objStatementNo = objFields("STATEMENTNO")
            Set objLineNo = objFields("LINENO")
            Set objMessage1 = objFields("MESSAGE1")
            Set objMessage2 = objFields("MESSAGE2")
        End If
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
        
            If strMode = "CNT" Then
                'カウントのみの場合は、ここで終了
                lngCount = CLng(objRecordCount.Value & "")
                Exit Do
            Else
        
                '戻り値の設定
                ReDim Preserve vntArrTransactionID(lngCount)
                ReDim Preserve vntArrInsDate(lngCount)
                ReDim Preserve vntArrTransactionDiv(lngCount)
                ReDim Preserve vntArrTransactionName(lngCount)
                ReDim Preserve vntArrInformationDiv(lngCount)
                ReDim Preserve vntArrStatementNo(lngCount)
                ReDim Preserve vntArrLineNo(lngCount)
                ReDim Preserve vntArrMessage1(lngCount)
                ReDim Preserve vntArrMessage2(lngCount)
                
                vntArrTransactionID(lngCount) = objTransactionID.Value & ""
                vntArrInsDate(lngCount) = objInsDate.Value & ""
                vntArrTransactionDiv(lngCount) = objTransactionDiv.Value & ""
                vntArrTransactionName(lngCount) = objTransactionName.Value & ""
                vntArrInformationDiv(lngCount) = objInformationDiv.Value & ""
                vntArrStatementNo(lngCount) = objStatementNo.Value & ""
                vntArrLineNo(lngCount) = objLineNo.Value & ""
                vntArrMessage1(lngCount) = objMessage1.Value & ""
                vntArrMessage2(lngCount) = objMessage2.Value & ""
                
                lngCount = lngCount + 1
                objOraDyna.MoveNext
            End If
        Loop
    
    End If
    
    '戻り値の設定
    If Not IsMissing(vntTransactionID) Then vntTransactionID = vntArrTransactionID
    If Not IsMissing(vntInsDate) Then vntInsDate = vntArrInsDate
    If Not IsMissing(vntTransactionDiv) Then vntTransactionDiv = vntArrTransactionDiv
    If Not IsMissing(vntTransactionName) Then vntTransactionName = vntArrTransactionName
    If Not IsMissing(vntInformationDiv) Then vntInformationDiv = vntArrInformationDiv
    If Not IsMissing(vntStatementNo) Then vntStatementNo = vntArrStatementNo
    If Not IsMissing(vntLineNo) Then vntLineNo = vntArrLineNo
    If Not IsMissing(vntMessage1) Then vntMessage1 = vntArrMessage1
    If Not IsMissing(vntMessage2) Then vntMessage2 = vntArrMessage2
    
    SelectHainsLog = lngCount
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectHainsLog = INSERT_ERROR
    
    'イベントログ書き込み
    WriteErrorLog "IPAddress.SelectHainsLog"
    
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
' 機能　　 : 引数値の配列変換
'
' 引数　　 : (In/Out) vntValue  非変換値
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub ConvArray(ByRef vntValue As Variant)

    Dim vntConvValue    As Variant  '変換後の値
    
    Do
        
        '未設定時は要素数１の空の配列を作成する
        If IsEmpty(vntValue) Then
            vntConvValue = Array("")
            Exit Do
        End If

        '配列形式でない場合は要素数１で要素値が引数値に等しい配列を作成する
        If Not IsArray(vntValue) Then
            vntConvValue = Array(vntValue)
            Exit Do
        End If
        
        'さもなくば変換は不要
        vntConvValue = vntValue
        Exit Do
    Loop
    
    '戻り値の設定
    vntValue = vntConvValue
    
End Sub

'
' 機能　　 : トランザクションＩＤをインクリメントする
'
' 引数　　 :
'
' 戻り値　 : 正の値    トランザクションＩＤ
' 　　　　   上記以外  異常終了
'
' 備考　　 :
'
Public Function IncreaseTransactionId() As Long

    Dim objOraDyna          As OraDynaset   'ダイナセット
    Dim strStmt             As String       'SQLステートメント
    
    Dim objFields           As OraFields    'フィールドオブジェクト
    Dim objTransactionID    As OraField     'トランザクションＩＤ
    
    Dim lngTransactionId    As Long         'トランザクションＩＤ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'Oracle Sequenceをインクリメントし、DUAL表を用いて次のトランザクションＩＤを取得する
    strStmt = "SELECT HAINSLOG_SEQ.NEXTVAL TRANSACTIONID FROM DUAL"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    Do
        'レコードが存在しない場合は処理終了
        If objOraDyna.EOF Then
            Exit Do
        End If
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objTransactionID = objFields("TRANSACTIONID")
        
        'トランザクションＩＤがNULL値の場合は処理終了
        If IsNull(objTransactionID.Value) Then
            Exit Do
        End If
        
        'トランザクションＩＤの取得
        lngTransactionId = CLng(objTransactionID.Value)
        
        Exit Do
    Loop

    '戻り値の設定
    IncreaseTransactionId = lngTransactionId
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    IncreaseTransactionId = 0

    'イベントログ書き込み
    WriteErrorLog "Contract.IncreaseTransactionId"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : ログテーブルレコードを挿入する
'
' 引数　　 : (In)    strTransactionId   トランザクションID
' 　　　　   (In)    strTransactionDiv  処理区分
' 　　　　   (In)    strInformationDiv  情報区分
' 　　　　   (In)    strLineNo          対象処理行
' 　　　　   (In)    vntMessage1        メッセージ１
' 　　　　   (In)    vntMessage2        メッセージ２
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function PutHainsLog( _
    ByVal lngTransactionId As Long, _
    ByVal strTransactionDiv As String, _
    Optional ByVal strInformationDiv As String = "", _
    Optional ByVal strLineNo As String = "", _
    Optional ByVal vntMessage1 As Variant, _
    Optional ByVal vntMessage2 As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSqlStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objMessage1     As OraParameter     'メッセージ１
    Dim objMessage2     As OraParameter     'メッセージ２
    
    Dim vntArrMessage1  As Variant          'メッセージ１
    Dim vntArrMessage2  As Variant          'メッセージ２
    
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    '挿入処理に際し、引数値を配列形式に変換
    If Not IsMissing(vntMessage1) Then
        vntArrMessage1 = vntMessage1
    End If
    
    If Not IsMissing(vntMessage2) Then
        vntArrMessage2 = vntMessage2
    End If
    
    ConvArray vntArrMessage1
    ConvArray vntArrMessage2
    
    '要素数を統一
    If UBound(vntArrMessage1) > UBound(vntArrMessage2) Then
        ReDim Preserve vntArrMessage2(UBound(vntArrMessage1))
    End If
    
    If UBound(vntArrMessage1) < UBound(vntArrMessage2) Then
        ReDim Preserve vntArrMessage1(UBound(vntArrMessage2))
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "TRANSACTIONID", lngTransactionId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TRANSACTIONDIV", strTransactionDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "INFORMATIONDIV", strInformationDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LINENO", strLineNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MESSAGE1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MESSAGE2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    'パラメータの参照設定
    Set objMessage1 = objOraParam("MESSAGE1")
    Set objMessage2 = objOraParam("MESSAGE2")
    objMessage1.MinimumSize = 150
    objMessage2.MinimumSize = 150

    'ログレコード挿入用のSQLステートメント作成
    strStmt = "INSERT INTO HAINSLOG (                            " & vbLf & _
              "                TRANSACTIONID,                    " & vbLf & _
              "                INSDATE,                          " & vbLf & _
              "                TRANSACTIONDIV,                   " & vbLf & _
              "                INFORMATIONDIV,                   " & vbLf & _
              "                STATEMENTNO,                      " & vbLf & _
              "                LINENO,                           " & vbLf & _
              "                MESSAGE1,                         " & vbLf & _
              "                MESSAGE2                          " & vbLf & _
              "            ) VALUES (                            " & vbLf & _
              "                :TRANSACTIONID,                   " & vbLf & _
              "                SYSDATE,                          " & vbLf & _
              "                :TRANSACTIONDIV,                  " & vbLf & _
              "                :INFORMATIONDIV,                  " & vbLf & _
              "                HAINSLOG_STATEMENTNO_SEQ.NEXTVAL, " & vbLf & _
              "                :LINENO,                          " & vbLf & _
              "                :MESSAGE1,                        " & vbLf & _
              "                :MESSAGE2                         " & vbLf & _
              "            )                                     "

    '各配列値の挿入処理
    For i = 0 To UBound(vntArrMessage1)

        '配列値の編集
        objMessage1.Value = CStr(vntArrMessage1(i))
        objMessage2.Value = CStr(vntArrMessage2(i))

        '挿入SQL文の実行
        If objOraSqlStmt Is Nothing Then
            Set objOraSqlStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSqlStmt.Refresh
        End If
    Next i

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    PutHainsLog = INSERT_NORMAL

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    PutHainsLog = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "HainsLog.PutHainsLog"
    
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

End Sub
