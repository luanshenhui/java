VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "AbsenceOrgBill"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private Const CNST_FILENAME  As String = "団体請求明細"

'請求書番号MAXLENGTH変更
Private Const LENGTH_BILLNO  As Long = 14    '請求書番号

Private mobjContext          As ObjectContext    'オブジェクトコンテキスト
Private mobjOraSession       As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb            As OraDatabase      'OraDatabaseオブジェ
Private bolDup               As Boolean

' 機能　　 : Activateイベント
'
' 備考　　 :
'
Private Sub ObjectControl_Activate()

    Dim objCommon   As Common   '共通クラス
    
    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()
    
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
    'データベース接続
    Set mobjOraSession = CreateObject("OracleInProcServer.XOraSession")
    Set mobjOraDb = mobjOraSession.OpenDatabase(objCommon.ConnectString, objCommon.UserName & "/" & objCommon.Password, ORADB_ENLIST_IN_MTS)
    
End Sub

Private Function ObjectControl_CanBePooled() As Boolean

End Function

' 機能　　 : DeaActivateイベント
'
' 備考　　 :
'
Private Sub ObjectControl_Deactivate()

    'オブジェクトコンテキストを解放
    Set mobjContext = Nothing

End Sub

'
' 機能　　 : 請求書明細CSV作成
'
' 引数　　 : (In)     strUserId          ユーザＩＤ
' 　　　　   (In)     dtmStrCloseDate    開始締め日
' 　　　　   (In)     dtmEndCloseDate    終了締め日
' 　　　　   (In)     strBillNo          請求書番号
' 　　　　   (In)     strOrgCd1          団体コード１
' 　　　　   (In)     strOrgCd2          団体コード２
'
' 戻り値　 : 印刷ログ情報のプリントSEQ値
'
' 備考　　 :
'
Public Function PrintAbsenceOrgBill(ByVal strUserId As String, _
                                    ByVal dtmStrCloseDate As Date, _
                                    ByVal dtmEndCloseDate As Date, _
                                    Optional ByVal strBillNo As String = "", _
                                    Optional ByVal strOrgCd1 As String = "", _
                                    Optional ByVal strOrgCd2 As String = "" _
                                    ) As Long

    Dim objCommon       As Common   '共通クラス
    Dim objOrganization As Object   '団体情報アクセス用
    Dim objReportLog    As Object   '印刷ログ情報アクセス用
    Dim strOutFile      As String
    Dim lngPrintSeq     As Long     'プリントSEQ
    
    Dim strFilePath     As String   'CSVファイル格納パス
    
    Dim strBaseFileName As String   'ファイル名
    Dim strFileName     As String   '実際に作成されたファイル名
    Dim Ret             As Long     '関数戻り値
    Dim strBuf          As String   'ワーク

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
     
     strOutFile = CNST_FILENAME & ".csv"
    
    'プリントSEQの取得
    Set objReportLog = CreateObject("HainsReportLog.ReportLog")
    lngPrintSeq = objReportLog.GetNextPrintSeq()

    '印刷ログテーブルレコードの挿入(帳票コードは書かない。名前のみ。)
    objReportLog.InsertReportLog2 lngPrintSeq, "", strUserId, strOutFile

    'ドキュメントファイルの格納場所を指定（ドキュメントファイル（出力結果）の位置）
    Set objCommon = CreateObject("HainsCommon.Common")
    strFilePath = objCommon.ReadIniFile("COREPORT", "BILLPATH")


'◆ここからのCSVファイル名定義ロジックについて、特に規約はありませんが、帳票内容にそぐった任意の命名をお願いします。
    'ファイル名の作成
    strBaseFileName = strFilePath & IIf(Right(strFilePath, 1) <> "\", "\", "") & strOutFile
    
    strFileName = SelectAbsenceListFile(strBaseFileName, dtmStrCloseDate, dtmEndCloseDate, strBillNo, strOrgCd1, strOrgCd2)

    '戻り値の設定
    If strFileName <> "" Then
        '印刷ログテーブルレコードの更新
        objReportLog.UpdateReportLog2 lngPrintSeq, 1, strFileName
        PrintAbsenceOrgBill = lngPrintSeq
    Else
        '印刷ログテーブルレコードの削除
        objReportLog.DeleteReportLog , lngPrintSeq
        
        '戻り値の設定
        PrintAbsenceOrgBill = "0"

    End If
    
    Exit Function
    
ErrorHandle:

    PrintAbsenceOrgBill = -1

    'イベントログ書き込み
    WriteErrorLog "HainsAbsenceOrgBill.PrintAbsenceOrgBill"

    'エラーをもう一回引き起こす

    Err.Raise Err.Number, Err.Source, Err.Description

End Function

' 機能　　 : 請求書明細CSV作成
'
' 引数　　 : (In)     strFileName        ファイル名
'       　   (In)     strUserId          ユーザＩＤ
' 　　　　   (In)     dtmStrCloseDate    開始締め日
' 　　　　   (In)     dtmEndCloseDate    終了締め日
' 　　　　   (In)     strBillNo          請求書番号
' 　　　　   (In)     strOrgCd1          団体コード１
' 　　　　   (In)     strOrgCd2          団体コード２
'
' 戻り値　 : 実際に作成されたCSVファイル名
'
' 備考　　 :
'
Public Function SelectAbsenceListFile(ByVal strFileName As String, _
                                      ByVal dtmStrCloseDate As Date, _
                                      ByVal dtmEndCloseDate As Date, _
                                      Optional ByVal strBillNo As String, _
                                      Optional ByVal strOrgCd1 As String, _
                                      Optional ByVal strOrgCd2 As String _
                                      ) As String

    Dim objCreateCsv        As Object           'CSVファイル作成用コンポーネント
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
   
    Dim strStmt             As String           'SQLステートメント
    
    Dim strOrgPostCd        As String           '所属コード
    Dim strCsvFileName      As String           '作成されたファイル名
    Dim lngPos              As Long             '文字列検索用
    
    Dim strBuf              As String
    Dim dtmBuf              As Date
    Dim strInput            As String           '抽出条件
    
    Dim vntOrgCd1()         As Variant          '団体コード１
    Dim vntOrgCd2()         As Variant          '団体コード2
    
    Dim i                   As Long
    
    Dim strCloseDate        As String           '締め日
    Dim lngBillSeq          As Long             '請求書Seq
    Dim lngBranchNo         As Long             '請求書枝番
    Dim blnIsBillNo         As Boolean          'TRUE:請求書番号が指定されている
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期設定
    blnIsBillNo = False
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    With objOraParam
        
        If (Trim(strBillNo) <> "") And IsNumeric(strBillNo) Then
            '請求書番号の妥当性チェック
            blnIsBillNo = False
            If CDbl(strBillNo) > 0 Then
                If (Len(strBillNo) = 14) Then
                    '請求書番号を分解
                    strCloseDate = Mid(strBillNo, 1, 4) & "/" & Mid(strBillNo, 5, 2) & "/" & Mid(strBillNo, 7, 2)
                    lngBillSeq = CLng(Mid(strBillNo, 9, 5))
                    lngBranchNo = CLng(Mid(strBillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
            '' 正しい請求書番号が入力されていない場合はNULLで検索をかける。
            If blnIsBillNo Then
                objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
                objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
                objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
            Else
                objOraParam.Add "CLOSEDATE", Null, ORAPARM_INPUT, ORATYPE_DATE
                objOraParam.Add "BILLSEQ", Null, ORAPARM_INPUT, ORATYPE_NUMBER
                objOraParam.Add "BRANCHNO", Null, ORAPARM_INPUT, ORATYPE_NUMBER
            End If
        Else
            '締め日範囲指定
            .Add "STRCloseDate", dtmStrCloseDate, ORAPARM_INPUT, ORATYPE_DATE
            .Add "ENDCloseDate", dtmEndCloseDate, ORAPARM_INPUT, ORATYPE_DATE
        
            '負担元指定
            If (Trim(strOrgCd1) <> "") And (Trim(strOrgCd2) <> "") Then
                .Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
                .Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
            End If
        
        End If
    End With
    
    
    strStmt = ""
    strStmt = strStmt & "SELECT BILL.ORGCD1                                          AS ORGCD1        "
    strStmt = strStmt & vbLf & "      ,BILL.ORGCD2                                          AS ORGCD2           "
    strStmt = strStmt & vbLf & "      ,BILL.PRTDATE                                         AS PRTDATE          "
    strStmt = strStmt & vbLf & "      ,BILL.CLOSEDATE                                       AS CLOSEDATE        "
    strStmt = strStmt & vbLf & "      ,BILL.BILLSEQ                                         AS BILLSEQ          "
    strStmt = strStmt & vbLf & "      ,BILL.BRANCHNO                                        AS BRANCHNO         "
    strStmt = strStmt & vbLf & "      ,BILLDETAIL.LASTNAME || '　' || BILLDETAIL.FIRSTNAME  AS NAME             "
    strStmt = strStmt & vbLf & "      ,BILLDETAIL.DETAILNAME                                AS DETAILNAME       "
    strStmt = strStmt & vbLf & "      ,INSTR(BILLDETAIL.DETAILNAME,'１日ドック')            AS STCOURSE         " '基本セットチェック（1:基本セット、0：オプションセット）
    strStmt = strStmt & vbLf & "      ,SUBSTR(BILLDETAIL.DETAILNAME, 0, LENGTH(BILLDETAIL.DETAILNAME)-1 )   AS DETAILHEADER     "
    strStmt = strStmt & vbLf & "      ,SUBSTR(BILLDETAIL.DETAILNAME, LENGTH(BILLDETAIL.DETAILNAME) )        AS DETAILFOOTER     "
    strStmt = strStmt & vbLf & "      ,(BILLDETAIL.PRICE    + BILLDETAIL.EDITPRICE)         AS PRICE            "
    strStmt = strStmt & vbLf & "      ,(BILLDETAIL.TAXPRICE + BILLDETAIL.EDITTAX)           AS TAX              "

    strStmt = strStmt & vbLf & "      ,BILLDETAIL.CSLDATE                                   AS CSLDATE          "
    strStmt = strStmt & vbLf & "      ,BILLDETAIL.DAYID                                     AS DAYID            "
    strStmt = strStmt & vbLf & "      ,BILLDETAIL.RSVNO                                     AS RSVNO            "

    strStmt = strStmt & vbLf & "      ,ORG.BILLCSLDIV                                       AS BILLCSLDIV       "   '請求書本人家族区分出力（1：出力）
    strStmt = strStmt & vbLf & "      ,ORG.BILLINS                                          AS BILLINS          "   '請求書保険証（記号・番号）情報出力（1：出力）
    strStmt = strStmt & vbLf & "      ,ORG.BILLEMPNO                                        AS BILLEMPNO        "   '請求書社員番号出力（1：出力）
    strStmt = strStmt & vbLf & "      ,ORG.BILLAGE                                          AS BILLAGE          "   '請求書年齢出力（1：出力）

    strStmt = strStmt & vbLf & "      ,CONSULT.ISRSIGN                                      AS ISRSIGN          "
    strStmt = strStmt & vbLf & "      ,CONSULT.ISRNO                                        AS ISRNO            "
    strStmt = strStmt & vbLf & "      ,CONSULT.EMPNO                                        AS EMPNO            "

    strStmt = strStmt & vbLf & "      ,TRUNC(CONSULT.AGE)                                   AS AGE              "
    strStmt = strStmt & vbLf & "      ,BILLDETAIL.PERID                                     AS PERID            "
    strStmt = strStmt & vbLf & "      ,BILLDETAIL.LINENO                                    AS LINENO           "
    strStmt = strStmt & vbLf & "      ,BILL.SECONDFLG                                       AS SECONDFLG        "    '二次検査フラグ（1：二次検査）
    strStmt = strStmt & vbLf & "      ,CONSULT.BILLPRINT                                    AS BILLPRINT        "
    strStmt = strStmt & vbLf & "      ,DECODE(CONSULT.BILLPRINT, 1, '本人', 2, '家族', '')  AS BILLPRINTNAME    "
    strStmt = strStmt & vbLf & "      ,DECODE(FREE.FREEFIELD1, NULL, '0', FREE.FREEFIELD1)  AS LIMITPRICE       "    '限度額負担金内訳印刷団体チェック

    strStmt = strStmt & vbLf & "      ,(                                                                        "
    strStmt = strStmt & vbLf & "        SELECT BD.DETAILNAME     AS DETAILNAME                                  "
    strStmt = strStmt & vbLf & "          FROM BILLDETAIL BD                                                    "
    strStmt = strStmt & vbLf & "         WHERE BD.RSVNO          = BILLDETAIL.RSVNO                             "
    strStmt = strStmt & vbLf & "           AND BD.CLOSEDATE      = BILLDETAIL.CLOSEDATE                         "
    strStmt = strStmt & vbLf & "           AND BD.BILLSEQ        = BILLDETAIL.BILLSEQ                           "
    strStmt = strStmt & vbLf & "           AND BD.BRANCHNO       = BILLDETAIL.BRANCHNO                          "
    strStmt = strStmt & vbLf & "           AND BD.DETAILNAME     IN ('乳房Ｘ線','乳房超音波','乳房Ｘ線・乳房超音波')    "
    strStmt = strStmt & vbLf & "       ) AS BREAST_NAME                                                         "

    strStmt = strStmt & vbLf & "      ,(                                                                        "
    strStmt = strStmt & vbLf & "        SELECT (BD.PRICE + BD.EDITPRICE)  AS PRICE                              "
    strStmt = strStmt & vbLf & "          FROM BILLDETAIL BD                                                    "
    strStmt = strStmt & vbLf & "         WHERE BD.RSVNO          = BILLDETAIL.RSVNO                             "
    strStmt = strStmt & vbLf & "           AND BD.CLOSEDATE      = BILLDETAIL.CLOSEDATE                         "
    strStmt = strStmt & vbLf & "           AND BD.BILLSEQ        = BILLDETAIL.BILLSEQ                           "
    strStmt = strStmt & vbLf & "           AND BD.BRANCHNO       = BILLDETAIL.BRANCHNO                          "
    strStmt = strStmt & vbLf & "           AND BD.DETAILNAME     IN ('乳房Ｘ線','乳房超音波','乳房Ｘ線・乳房超音波')    "
    strStmt = strStmt & vbLf & "       ) AS BREAST_PRICE                                                        "

    strStmt = strStmt & vbLf & "      ,(                                                                        "
    strStmt = strStmt & vbLf & "        SELECT (BD.TAXPRICE + BD.EDITTAX) AS TAX                                "
    strStmt = strStmt & vbLf & "          FROM BILLDETAIL BD                                                    "
    strStmt = strStmt & vbLf & "         WHERE BD.RSVNO          = BILLDETAIL.RSVNO                             "
    strStmt = strStmt & vbLf & "           AND BD.CLOSEDATE      = BILLDETAIL.CLOSEDATE                         "
    strStmt = strStmt & vbLf & "           AND BD.BILLSEQ        = BILLDETAIL.BILLSEQ                           "
    strStmt = strStmt & vbLf & "           AND BD.BRANCHNO       = BILLDETAIL.BRANCHNO                          "
    strStmt = strStmt & vbLf & "           AND BD.DETAILNAME     IN ('乳房Ｘ線','乳房超音波','乳房Ｘ線・乳房超音波')    "
    strStmt = strStmt & vbLf & "       ) AS BREAST_TAX                                                          "

    strStmt = strStmt & vbLf & "  FROM BILL                                 "
    strStmt = strStmt & vbLf & "      ,BILLDETAIL                           "
    strStmt = strStmt & vbLf & "      ,ORG                                  "
    strStmt = strStmt & vbLf & "      ,CONSULT                              "
    strStmt = strStmt & vbLf & "      ,FREE                                 "


    If (Trim(strBillNo) <> "") And IsNumeric(strBillNo) Then

        strStmt = strStmt & vbLf & " WHERE BILL.CLOSEDATE = :CLOSEDATE                                  "
        strStmt = strStmt & vbLf & "   AND BILL.BILLSEQ   = :BILLSEQ                                    "
        strStmt = strStmt & vbLf & "   AND BILL.BRANCHNO  = :BRANCHNO                                   "

    Else
        strStmt = strStmt & vbLf & " WHERE BILL.CLOSEDATE BETWEEN :STRCloseDate AND :ENDCloseDate       "

        '負担元指定
        If (Trim(strOrgCd1) <> "") And (Trim(strOrgCd2) <> "") Then
            strStmt = strStmt & vbLf & " AND BILL.ORGCD1 = :ORGCD1                                      "
            strStmt = strStmt & vbLf & " AND BILL.ORGCD2 = :ORGCD2                                      "
        End If

    End If

    strStmt = strStmt & vbLf & "   AND BILL.ORGCD1      = ORG.ORGCD1                            "
    strStmt = strStmt & vbLf & "   AND BILL.ORGCD2      = ORG.ORGCD2                            "
    strStmt = strStmt & vbLf & "   AND 'LO' || ORG.ORGCD1 || ORG.ORGCD2 = FREE.FREECD(+)        "
    strStmt = strStmt & vbLf & "   AND BILL.CLOSEDATE   = BILLDETAIL.CLOSEDATE                  "
    strStmt = strStmt & vbLf & "   AND BILL.BILLSEQ     = BILLDETAIL.BILLSEQ                    "
    strStmt = strStmt & vbLf & "   AND BILL.BRANCHNO    = BILLDETAIL.BRANCHNO                   "
    strStmt = strStmt & vbLf & "   AND BILLDETAIL.RSVNO = CONSULT.RSVNO(+)                      "
    strStmt = strStmt & vbLf & "   AND BILL.DELFLG      = 0                                     "   '取消（削除）明細は出力対象外
    strStmt = strStmt & vbLf & "   AND BILLDETAIL.PRICE > 0                                     "   '返金等の△金額の明細は出力対象外

    strStmt = strStmt & vbLf & " ORDER BY BILL.ORGCD1, BILL.ORGCD2, BILL.CLOSEDATE, BILL.BILLSEQ, BILL.BRANCHNO, BILLDETAIL.CSLDATE ,BILLDETAIL.DAYID, BILLDETAIL.LINENO    "

    ''-----------------------------------------------------------------------------------------------------------
    
    '検索条件を満たすレコードを取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY)
    
    'レコード存在時
    If Not objOraDyna.EOF Then
        objOraDyna.MoveFirst
        'ダイナセットからCSVファイルを作成
        Set objCreateCsv = CreateObject("HainsCreateCsvOrgBill.CreateCsvOrgBill")
        strCsvFileName = objCreateCsv.CreateCsvFile(objOraDyna, strFileName)
    
        '戻り値用としてドキュメントファイルのファイル名部分だけを抽出
        lngPos = InStrRev(strCsvFileName, "\")
        If lngPos <> 0 Then
            strCsvFileName = Mid(strCsvFileName, lngPos + 1)
        End If
    
    End If

    
    '戻り値の設定
    SelectAbsenceListFile = strCsvFileName
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
'◆ここまで
    
ErrorHandle:

'    'イベントログ書き込み
    WriteErrorLog "HainsAbsenceOrgBill.SelectAbsenceListFile"
'
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

'    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

