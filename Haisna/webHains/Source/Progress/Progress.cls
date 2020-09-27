VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Progress"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext      As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 進捗分類テーブルレコードを削除する
'
' 引数　　 : (In)    strProgressCd    進捗分類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteProgress(ByVal strProgressCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ProgressCD", Trim(strProgressCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '進捗分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE PROGRESS WHERE PROGRESSCD = :ProgressCD"
    
    'バインド変数の削除
    objOraParam.Remove "ProgressCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteProgress = True

    Exit Function
    
ErrorHandle:

    DeleteProgress = False

    'イベントログ書き込み
    WriteErrorLog "Progress.DeleteProgress"
    
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
' 機能　　 : 進捗管理用分類テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strProgressCd      進捗管理用分類コード
' 　　　　   (In)    vntProgressName    進捗管理用分類名
' 　　　　   (In)    vntProgressSName   進捗管理用分類略称
' 　　　　   (In)    intSeq             表示順番
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistProgress(ByVal strMode As String, _
                               ByVal strProgressCd As String, _
                               ByVal strProgressName As String, _
                               ByVal strProgressSName As String, _
                               ByVal intSeq As Integer) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ProgressCD", Trim(strProgressCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ProgressNAME", Trim(strProgressName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ProgressSNAME", Trim(strProgressSName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "Seq", Trim(intSeq), ORAPARM_INPUT, ORATYPE_NUMBER

    Do
        '進捗管理用分類テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE PROGRESS " & _
                      "   SET PROGRESSNAME  = :ProgressNAME," & _
                      "       PROGRESSSNAME = :ProgressSNAME," & _
                      "       Seq           = :Seq" & _
                      " WHERE ProgressCD    = :ProgressCD"
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす進捗管理用分類テーブルのレコードを取得
        strStmt = "SELECT PROGRESSCD FROM PROGRESS WHERE PROGRESSCD = :ProgressCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO PROGRESS (PROGRESSCD, PROGRESSNAME, PROGRESSSNAME, SEQ) VALUES (:ProgressCD, :ProgressNAME, :ProgressSNAME, :Seq)"
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
    RegistProgress = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistProgress = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Progress.RegistProgress"
    
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
' 機能　　 : 進捗分類の一覧を取得する
'
' 引数　　 : (Out)    vntProgressCd     進捗分類コード
' 　　　　 : (Out)    vntProgressName   進捗分類名称（省略可）
' 　　　　 : (Out)    vntProgressSName  進捗分類略称（省略可）
' 　　　　 : (Out)    vntSeq            表示順番（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectProgressList(ByRef vntProgressCd As Variant, _
                                   Optional ByRef vntProgressName As Variant, _
                                   Optional ByRef vntProgressSName As Variant, _
                                   Optional ByRef vntSeq As Variant _
                                  ) As Long

    Dim objOraDyna              As OraDynaset   'ダイナセット
    Dim strStmt                 As String       'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    Dim objProgressCd           As OraField     '進捗分類コード
    Dim objProgressName         As OraField     '進捗分類名称
    Dim objProgressSName        As OraField     '進捗分類略称
    Dim objSeq                  As OraField     '表示順番
    
    Dim vntArrProgressCd()      As Variant      '進捗分類コードの配列
    Dim vntArrProgressName()    As Variant      '進捗分類名称の配列
    Dim vntArrProgressSName()   As Variant      '進捗分類略称の配列
    Dim vntArrSeq()             As Variant      '表示順番の配列
    Dim lngCount                As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件を満たす進捗分類テーブルのレコードを取得
    strStmt = "SELECT PG.PROGRESSCD, PG.PROGRESSNAME, PG.PROGRESSSNAME, PG.SEQ" & vbLf & _
              "  FROM PROGRESS PG" & vbLf & _
              " ORDER BY PG.SEQ"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objProgressCd = objFields("PROGRESSCD")
        Set objProgressName = objFields("PROGRESSNAME")
        Set objProgressSName = objFields("PROGRESSSNAME")
        Set objSeq = objFields("SEQ")
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrProgressCd(lngCount)
            ReDim Preserve vntArrProgressName(lngCount)
            ReDim Preserve vntArrProgressSName(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            
            vntArrProgressCd(lngCount) = objProgressCd.Value
            vntArrProgressName(lngCount) = objProgressName.Value
            vntArrProgressSName(lngCount) = objProgressSName.Value
            vntArrSeq(lngCount) = objSeq.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
    End If
    
    '戻り値の設定
    vntProgressCd = vntArrProgressCd
    If IsMissing(vntProgressName) = False Then
        vntProgressName = vntArrProgressName
    End If
    If IsMissing(vntProgressSName) = False Then
        vntProgressSName = vntArrProgressSName
    End If
    If IsMissing(vntSeq) = False Then
        vntSeq = vntArrSeq
    End If
    
    SelectProgressList = lngCount
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Progress.SelectProgressList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 進捗分類コードに対する進捗分類名を取得する
'
' 引数　　 : (In)     strProgressCd     進捗分類コード
' 　　　　 : (Out)    vntProgressName   進捗分類名
' 　　　　 : (Out)    vntProgressSName  進捗分類略称
' 　　　　 : (Out)    vntSeq            表示用順番
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectProgress(ByVal strProgressCd As String, _
                               Optional ByRef vntProgressName As Variant, _
                               Optional ByRef vntProgressSName As Variant, _
                               Optional ByRef vntSeq As Variant _
                               ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objProgressName     As OraField         '進捗分類名
    Dim objProgressSName    As OraField         '進捗分類略称
    Dim objSeq              As OraField         '表示順番
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strProgressCd) = "" Then
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PROGRESSCD", Trim(strProgressCd), ORAPARM_INPUT
    
    '検索条件を満たす進捗分類テーブルのレコードを取得
    strStmt = "SELECT PROGRESSNAME, PROGRESSSNAME, SEQ FROM PROGRESS WHERE PROGRESSCD = :PROGRESSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objProgressName = objFields("PROGRESSNAME")
        Set objProgressSName = objFields("PROGRESSSNAME")
        Set objSeq = objFields("SEQ")
    
        '戻り値の設定
        If IsMissing(vntProgressName) = False Then
            vntProgressName = objProgressName.Value
        End If
        If IsMissing(vntProgressSName) = False Then
            vntProgressSName = objProgressSName.Value
        End If
        If IsMissing(vntSeq) = False Then
            vntSeq = objSeq.Value
        End If
        
        SelectProgress = True
        
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
    WriteErrorLog "Progress.SelectProgress"
    
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
' 機能　　 : 指定予約番号の検査結果に対し、進捗分類ごとの入力状態を取得
'
' 引数　　 : (In)     lngRsvNo       予約番号
' 　　　　   (Out)    vntProgressCd  進捗分類コード
' 　　　　   (Out)    vntStatus      入力状態("2":入力完了、"1":未入力、"0":依頼なし、"3":未入力だが端末は通過)
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'## 2003.01.19 Mod 8Lines by T.Takagi@FSIT 東急対応・・・というかパワーアップ版
'Public Function SelectProgressRsl(
'    ByVal dtmCslDate As Long,
'    ByVal lngCntlNo As Long,
'    ByVal lngDayId As Long,
'    ByRef vntProgressCd As Variant,
'    ByRef vntStatus As Variant
') As Long
Public Function SelectProgressRsl(ByVal lngRsvNo As Long, ByRef vntProgressCd As Variant, ByRef vntStatus As Variant) As Long
'## 2003.01.19 Mod End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objProgressCd       As OraField         '進捗分類コード
'## 2003.01.19 Mod 2Lines by T.Takagi@FSIT 東急対応・・・というかパワーアップ版
'    Dim objConsults         As OraField         '受診状態
    Dim objEntry            As OraField         '入力状態
'## 2003.01.19 Mod End
    Dim objNotEntry         As OraField         '未入力状態
'## 2003.01.19 Del 3Lines by T.Takagi@FSIT 東急対応・・・というかパワーアップ版
''## 2002.04.12 Add 1Line by T.Takagi@FSIT
'    Dim objPassed           As OraField         '端末通過状態
''## 2002.04.12 Add End
'## 2003.01.19 Del End

'## 2003.03.24 Add 1Line by Ishihara@FSIT ひとつも入力されていない進捗は必ず▲にする。
    Dim objInputCount       As OraField         '進捗分類内入力項目数
'## 2003.03.24 Add End

    Dim vntArrProgressCd()  As Variant          '進捗分類コードの配列
    Dim vntArrStatus()      As Variant          '入力状態の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntProgressCd = Empty
    vntStatus = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
'## 2003.01.19 Mod 90Lines by T.Takagi@FSIT 東急対応・・・というかパワーアップ版
'    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
'    objOraParam.Add "CNTLNO", lngCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DAYID", lngDayId, ORAPARM_INPUT, ORATYPE_NUMBER

'    '指定予約番号の検査結果に対し、進捗分類ごとの入力状態を取得
'    strStmt = "SELECT BASEDPROGRESS.PROGRESSCD, "
'
'    '依頼有無のチェック
'    strStmt = strStmt & vbLf & _
'              "       ( SELECT 1                                            " & vbLf & _
'              "           FROM ITEM_P, RSL                                  " & vbLf & _
'              "          WHERE RSL.RSVNO         = BASEDPROGRESS.RSVNO      " & vbLf & _
'              "            AND RSL.ITEMCD        = ITEM_P.ITEMCD            " & vbLf & _
'              "            AND ITEM_P.PROGRESSCD = BASEDPROGRESS.PROGRESSCD " & vbLf & _
'              "            AND ROWNUM            = 1                        " & vbLf & _
'              "       ) CONSULTS,                                           "
'
''## 2002.04.12 Add 12Lines by T.Takagi@FSIT
'    '端末通過チェック
'    strStmt = strStmt & vbLf & _
'              "       ( SELECT 1                                                 " & vbLf & _
'              "           FROM WORKSTATION, PASSEDINFO, RECEIPT                  " & vbLf & _
'              "          WHERE RECEIPT.RSVNO          = BASEDPROGRESS.RSVNO      " & vbLf & _
'              "            AND RECEIPT.CSLDATE        = PASSEDINFO.CSLDATE       " & vbLf & _
'              "            AND RECEIPT.CNTLNO         = PASSEDINFO.CNTLNO        " & vbLf & _
'              "            AND RECEIPT.DAYID          = PASSEDINFO.DAYID         " & vbLf & _
'              "            AND PASSEDINFO.IPADDRESS   = WORKSTATION.IPADDRESS    " & vbLf & _
'              "            AND WORKSTATION.PROGRESSCD = BASEDPROGRESS.PROGRESSCD " & vbLf & _
'              "            AND ROWNUM                 = 1                        " & vbLf & _
'              "       ) PASSED,                                                  "
''## 2002.04.12 Add End
'
'    '未入力チェック
'    strStmt = strStmt & vbLf & _
'              "       ( SELECT 1                                            " & vbLf & _
'              "           FROM ITEM_P, RSL BASEDRSL                         " & vbLf & _
'              "          WHERE BASEDRSL.RSVNO    = BASEDPROGRESS.RSVNO      " & vbLf & _
'              "            AND BASEDRSL.ITEMCD   = ITEM_P.ITEMCD            " & vbLf & _
'              "            AND ITEM_P.PROGRESSCD = BASEDPROGRESS.PROGRESSCD "
'
'    '「分画項目が１つでも入力されていれば検査完了」の場合、同一依頼項目で入力済みの検査結果が１つも存在しなければ未入力とみなす
'    strStmt = strStmt & vbLf & _
'              "            AND ( ( ITEM_P.ENTRYOK = 0                                      " & vbLf & _
'              "                    AND                                                     " & vbLf & _
'              "                    NOT EXISTS ( SELECT RSL.RSVNO                           " & vbLf & _
'              "                                   FROM RSLCMT RSLCMT1,                     " & vbLf & _
'              "                                        RSLCMT RSLCMT2,                     " & vbLf & _
'              "                                        RSL                                 " & vbLf & _
'              "                                  WHERE RSL.RSVNO     = BASEDRSL.RSVNO      " & vbLf & _
'              "                                    AND RSL.ITEMCD    = BASEDRSL.ITEMCD     " & vbLf & _
'              "                                    AND RSL.RSLCMTCD1 = RSLCMT1.RSLCMTCD(+) " & vbLf & _
'              "                                    AND RSL.RSLCMTCD2 = RSLCMT2.RSLCMTCD(+) " & vbLf & _
'              "                                    AND ( RSL.RESULT IS NOT NULL OR         " & vbLf & _
'              "                                          RSLCMT1.ENTRYOK = 1    OR         " & vbLf & _
'              "                                          RSLCMT2.ENTRYOK = 1        ) ) )  "
'
'    '「全ての分画項目が入力されれば検査完了」の場合、同一依頼項目で未入力の検査結果が１つでも存在すれば未入力とみなす
'    strStmt = strStmt & vbLf & _
'              "                  OR                                                    " & vbLf & _
'              "                  ( ITEM_P.ENTRYOK = 1                                  " & vbLf & _
'              "                    AND                                                 " & vbLf & _
'              "                    EXISTS ( SELECT RSL.RSVNO                           " & vbLf & _
'              "                               FROM RSLCMT RSLCMT1,                     " & vbLf & _
'              "                                    RSLCMT RSLCMT2,                     " & vbLf & _
'              "                                    RSL                                 " & vbLf & _
'              "                              WHERE RSL.RSVNO     = BASEDRSL.RSVNO      " & vbLf & _
'              "                                AND RSL.ITEMCD    = BASEDRSL.ITEMCD     " & vbLf & _
'              "                                AND RSL.RSLCMTCD1 = RSLCMT1.RSLCMTCD(+) " & vbLf & _
'              "                                AND RSL.RSLCMTCD2 = RSLCMT2.RSLCMTCD(+) " & vbLf & _
'              "                                AND RSL.RESULT IS NULL                  " & vbLf & _
'              "                                AND NVL(RSLCMT1.ENTRYOK, 0) = 0         " & vbLf & _
'              "                                AND NVL(RSLCMT2.ENTRYOK, 0) = 0 ) )     " & vbLf & _
'              "                )                                                       " & vbLf & _
'              "            AND ROWNUM = 1                                              " & vbLf & _
'              "       ) NOTENTRY                                                       "
'
'    strStmt = strStmt & vbLf & _
'              "  FROM ( SELECT RECEIPT.RSVNO,             " & vbLf & _
'              "                PROGRESS.SEQ,              " & vbLf & _
'              "                PROGRESS.PROGRESSCD        " & vbLf & _
'              "           FROM PROGRESS, RECEIPT          " & vbLf & _
'              "          WHERE RECEIPT.CSLDATE = :CSLDATE " & vbLf & _
'              "            AND RECEIPT.CNTLNO  = :CNTLNO  " & vbLf & _
'              "            AND RECEIPT.DAYID   = :DAYID   " & vbLf & _
'              "          ORDER BY RSVNO, SEQ              " & vbLf & _
'              "       ) BASEDPROGRESS                     "
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号の健診結果に対する入力状態を読み込む
'## 2003.03.24 Mod 1Line by Ishihara@FSIT ひとつも入力されていない進捗は必ず▲にする。
'    strStmt = "SELECT PROGRESSCD, ENTRY, NOTENTRY FROM CHECKENTRY WHERE RSVNO=:RSVNO"
    strStmt = "SELECT PROGRESSCD, ENTRY, NOTENTRY, INPUTCOUNT FROM CHECKENTRY WHERE RSVNO=:RSVNO"
'## 2003.03.24 Mod End
'## 2003.01.19 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objProgressCd = objFields("PROGRESSCD")
'## 2003.01.19 Mod 2Lines by T.Takagi@FSIT 東急対応・・・というかパワーアップ版
'        Set objConsults = objFields("CONSULTS")
        Set objEntry = objFields("ENTRY")
'## 2003.01.19 Mod End
        Set objNotEntry = objFields("NOTENTRY")
'## 2003.01.19 Del 3Lines by T.Takagi@FSIT 東急対応・・・というかパワーアップ版
''## 2002.04.12 Add 1Line by T.Takagi@FSIT
'        Set objPassed = objFields("PASSED")
''## 2002.04.12 Add End
'## 2003.01.19 Del End
'## 2003.03.24 Add 1Line by Ishihara@FSIT ひとつも入力されていない進捗は必ず▲にする。
        Set objInputCount = objFields("INPUTCOUNT")
'## 2003.03.24 Add End


        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrProgressCd(lngCount)
            ReDim Preserve vntArrStatus(lngCount)
            vntArrProgressCd(lngCount) = objProgressCd.Value
            
            '入力状態の設定
            Do
                
'## 2003.01.19 Mod 37Lines by T.Takagi@FSIT 東急対応・・・というかパワーアップ版
'                '未受診の場合
'                If objConsults.Value & "" = "" Then
'                    vntArrStatus(lngCount) = "0"
'                    Exit Do
'                End If
'
'                '未入力でない場合
'                If objNotEntry.Value & "" = "" Then
'                    vntArrStatus(lngCount) = "2"
'                    Exit Do
'                End If
'
''## 2002.04.12 Add 5Lines by T.Takagi@FSIT
'                '未入力だが端末通過している場合
'                If objPassed.Value & "" <> "" Then
'                    vntArrStatus(lngCount) = "3"
'                    Exit Do
'                End If
''## 2002.04.12 Add End
'
'                'さもなくば未入力である
'                vntArrStatus(lngCount) = "1"
                
'## 2003.03.24 Add 1Line by Ishihara@FSIT ひとつも入力されていない進捗は必ず▲にする。
                '入力数が0の場合
                If CLng("0" & objInputCount.Value) = 0 Then
                    vntArrStatus(lngCount) = "1"
                    Exit Do
                End If
'## 2003.03.24 Add End
                
                '入力数が０の場合
                If CLng("0" & objEntry.Value) = 0 Then
                    vntArrStatus(lngCount) = "1"
                    Exit Do
                End If
                
                '入力はされているが入力未完了の場合
                If CLng("0" & objNotEntry.Value) = 1 Then
                    vntArrStatus(lngCount) = "3"
                    Exit Do
                End If
                
                'さもなくば入力済みである
                vntArrStatus(lngCount) = "2"
'## 2003.01.19 Mod End
                Exit Do
            Loop
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntProgressCd = vntArrProgressCd
        vntStatus = vntArrStatus

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    SelectProgressRsl = lngCount

    Exit Function

ErrorHandle:

    SelectProgressRsl = -1

    'イベントログ書き込み
    WriteErrorLog "Progress.SelectProgressRsl"
    
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
