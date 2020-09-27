VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Bill"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト
Private mobjContext      As ObjectContext    'オブジェクトコンテキスト
Private Const ITEMCNT = 4

'
' 機能　　 : 請求書テーブルからレコードを取得する。
'
' 引数　　 : (In)     strBillNo             請求書番号
' 　　　　 : (In)     strStartCloseDate     締め日（開始日）
' 　　　　 : (In)     strEndCloseDate       締め日（終了日）
' 　　　　 : (In)     strOrgCd1             団体コード１
' 　　　　 : (In)     strOrgCd2             団体コード２
' 　　　　 : (In)     strBillClassCd        請求書分類コード
' 　　　　 : (In)     strOutPutCls          出力対象区分
' 　　　　 : (Out)    vntbillNo             請求書Ｎｏ
' 　　　　 : (Out)    vntCloseDate          締め日
' 　　　　 : (Out)    vntOrgCd1             団体コード１
' 　　　　 : (Out)    vntOrgCd2             団体コード２
' 　　　　 : (Out)    vntBillClassCd        請求書分類コード
' 　　　　 : (Out)    vntMethod             作成方法
' 　　　　 : (Out)    vntTaxRates           適用税率
' 　　　　 : (Out)    vntPrtDate            請求書出力日
' 　　　　 : (Out)    vntOrgName            団体名称
' 　　　　 : (Out)    vntOrgBillName        請求書用名称
' 　　　　 : (Out)    vntChageName          担当者名
' 　　　　 : (Out)    vntOrgDiv             団体種別
' 　　　　 : (Out)    vntBillClassName      請求書分類名
'
' 戻り値　 : 取得件数
'
' 備考　　 :
'
Public Function SelectPrintBill( _
    ByVal strBillNo As String, _
    ByVal strStartCloseDate As String, _
    ByVal strEndCloseDate As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strBillClassCd As String, _
    ByVal strOutPutCls As String, _
    Optional ByRef vntBillNo As Variant, _
    Optional ByRef vntCloseDate As Variant, _
    Optional ByRef vntOrgCd1 As Variant, _
    Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntBillClassCd As Variant, _
    Optional ByRef vntMethod As Variant, _
    Optional ByRef vntTaxRates As Variant, _
    Optional ByRef vntPrtDate As Variant = "0", _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntOrgBillName As Variant, _
    Optional ByRef vntChageName As Variant, _
    Optional ByRef vntOrgDiv As Variant, _
    Optional ByRef vntBillClassName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objBillNo           As OraField         '請求書ＮＯ
    Dim objCloseDate        As OraField         '締め日
    Dim objOrgCd1           As OraField         '団体コード１
    Dim objOrgCd2           As OraField         '団体コード２
    Dim objBillClassCd      As OraField         '請求書分類コード
    Dim objMethod           As OraField         '作成方法
    Dim objTaxRates         As OraField         '適用税率
    Dim objPrtDate          As OraField         '請求書出力日
    Dim objOrgName          As OraField         '団体名称
    Dim objOrgBillName      As OraField         '請求書用名称
    Dim objChageName        As OraField         '担当者名
    Dim objOrgDiv           As OraField         '団体種別
    Dim objBillClassName    As OraField         '請求書分類名
    
    Dim vntArrBillNo()      As Variant          '請求書ＮＯ
    Dim vntArrCloseDate()   As Variant          '締め日
    Dim vntArrOrgCd1()      As Variant          '団体コード１
    Dim vntArrOrgCd2()      As Variant          '団体コード２
    Dim vntArrBillClassCd() As Variant          '請求書分類コード
    Dim vntArrMethod()      As Variant          '作成方法
    Dim vntArrTaxRates()    As Variant          '適用税率
    Dim vntArrPrtDate()     As Variant          '請求書出力日
    Dim vntArrOrgName()     As Variant          '団体名称
    Dim vntArrOrgBillName() As Variant          '請求書用名称
    Dim vntArrChageName()   As Variant          '担当者名
    Dim vntArrOrgDiv()      As Variant          '団体種別
    Dim vntArrBillClassName()      As Variant          '請求書分類名
    
    Dim conditionStr        As String           '
    Dim lngCount            As Long             'レコード数
    
    '初期値
    If Not IsMissing(vntBillNo) Then vntBillNo = Empty
    If Not IsMissing(vntCloseDate) Then vntCloseDate = Empty
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntBillClassCd) Then vntBillClassCd = Empty
    If Not IsMissing(vntMethod) Then vntMethod = Empty
    If Not IsMissing(vntTaxRates) Then vntTaxRates = Empty
    If Not IsMissing(vntPrtDate) Then vntPrtDate = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntOrgBillName) Then vntOrgBillName = Empty
    If Not IsMissing(vntChageName) Then vntChageName = Empty
    If Not IsMissing(vntOrgDiv) Then vntOrgDiv = Empty
    If Not IsMissing(vntBillClassName) Then vntBillClassName = Empty
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期設定
    conditionStr = "  WHERE  "
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strBillNo <> "") Then objOraParam.Add "BILLNO", strBillNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strStartCloseDate <> "") Then objOraParam.Add "STARTCLOSEDATE", strStartCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strEndCloseDate <> "") Then objOraParam.Add "ENDCLOSEDATE", strEndCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strOrgCd1 <> "") Then objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd2 <> "") Then objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strBillClassCd <> "") Then objOraParam.Add "BILLCLASSCD", strBillClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '請求書テーブルから取得
    strStmt = "SELECT BILL.BILLNO, BILL.CLOSEDATE, BILL.ORGCD1, BILL.ORGCD2,        " & vbLf & _
              "       BILL.BILLCLASSCD,  BILL.METHOD, BILL.TAXRATES, BILL.PRTDATE,  " & vbLf & _
              "       ORG.ORGNAME, ORG.ORGBILLNAME, ORG.CHARGENAME,ORG.ORGDIV,       " & vbLf & _
              "       BILLCLASS.BILLCLASSNAME                                       " & vbLf & _
              "  FROM BILL , ORG ,BILLCLASS " & vbLf
                  
    If ((strBillNo <> "") Or (strStartCloseDate <> "") _
        Or (strEndCloseDate <> "") Or (strOrgCd1 <> "") _
        Or (strOrgCd2 <> "") Or (strBillClassCd <> "")) Then
            
        '請求書番号
        If (strBillNo <> "") Then
            strStmt = strStmt & conditionStr & " BILL.BILLNO    = :BILLNO      " & vbLf
            conditionStr = "  AND "
'### 2003.02.22 Updated by Ishihara@FSIT 請求書Noが指定された場合、他のパラメタを有効にすると使えない。
'        End If
'
'        '締め日（開始日）
'        If (strStartCloseDate <> "") Then
'            strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    >= :STARTCLOSEDATE      " & vbLf
'            conditionStr = "  AND "
'        End If
'
'        '締め日（終了日）
'        If (strEndCloseDate <> "") Then
'            strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    <= :ENDCLOSEDATE      " & vbLf
'            conditionStr = "  AND "
'        End If
'
'        '団体コード１
'        If (strOrgCd1 <> "") Then
'            strStmt = strStmt & conditionStr & " BILL.ORGCD1    = :ORGCD1      " & vbLf
'            conditionStr = "  AND "
'        End If
'
'        '団体コード２
'        If (strOrgCd2 <> "") Then
'            strStmt = strStmt & conditionStr & " BILL.ORGCD2    = :ORGCD2      " & vbLf
'            conditionStr = "  AND "
'        End If
'
'        '請求書分類コード
'        If (strBillClassCd <> "") Then
'            strStmt = strStmt & conditionStr & " BILL.BILLCLASSCD    = :BILLCLASSCD      " & vbLf
'            conditionStr = "  AND "
'        End If
        Else
            
            '締め日（開始日）
            If (strStartCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    >= :STARTCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
    
            '締め日（終了日）
            If (strEndCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    <= :ENDCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
    
            '団体コード１
            If (strOrgCd1 <> "") Then
                strStmt = strStmt & conditionStr & " BILL.ORGCD1    = :ORGCD1      " & vbLf
                conditionStr = "  AND "
            End If
    
            '団体コード２
            If (strOrgCd2 <> "") Then
                strStmt = strStmt & conditionStr & " BILL.ORGCD2    = :ORGCD2      " & vbLf
                conditionStr = "  AND "
            End If
    
            '請求書分類コード
            If (strBillClassCd <> "") Then
                strStmt = strStmt & conditionStr & " BILL.BILLCLASSCD    = :BILLCLASSCD      " & vbLf
                conditionStr = "  AND "
            End If
        
        End If
'### 2003.02.22 Updated End
    
    End If
    
    '出力条件の設定
    Select Case strOutPutCls
        Case "1":
            strStmt = strStmt & conditionStr & "  BILL.PRTDATE IS NULL       " & vbLf
            conditionStr = "  AND "

        Case "2":
            strStmt = strStmt & conditionStr & "  BILL.PRTDATE IS NOT NULL       " & vbLf
            conditionStr = "  AND "
    End Select
    
    strStmt = strStmt & conditionStr & "  BILL.ORGCD1   = ORG.ORGCD1      " & vbLf & _
                                       "   AND   BILL.ORGCD2   = ORG.ORGCD2      " & vbLf & _
                                       "   AND   BILL.BILLCLASSCD   = BILLCLASS.BILLCLASSCD      " & vbLf
   
    strStmt = strStmt & " ORDER BY BILL.BILLNO "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objBillNo = objFields("BILLNO")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objBillClassCd = objFields("BILLCLASSCD")
        Set objMethod = objFields("METHOD")
        Set objTaxRates = objFields("TAXRATES")
        Set objPrtDate = objFields("PRTDATE")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgBillName = objFields("ORGBILLNAME")
        Set objChageName = objFields("CHARGENAME")
        Set objOrgDiv = objFields("ORGDIV")
        Set objBillClassName = objFields("BILLCLASSNAME")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrBillClassCd(lngCount)
            ReDim Preserve vntArrMethod(lngCount)
            ReDim Preserve vntArrTaxRates(lngCount)
            ReDim Preserve vntArrPrtDate(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgBillName(lngCount)
            ReDim Preserve vntArrChageName(lngCount)
            ReDim Preserve vntArrOrgDiv(lngCount)
            ReDim Preserve vntArrBillClassName(lngCount)
            
            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrBillClassCd(lngCount) = objBillClassCd.Value & ""
            vntArrMethod(lngCount) = objMethod.Value & ""
            vntArrTaxRates(lngCount) = objTaxRates.Value & ""
            vntArrPrtDate(lngCount) = objPrtDate.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgBillName(lngCount) = objOrgBillName.Value & ""
            vntArrChageName(lngCount) = objChageName.Value & ""
            vntArrOrgDiv(lngCount) = objOrgDiv.Value & ""
            vntArrBillClassName(lngCount) = objBillClassName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntBillNo = vntArrBillNo
        vntCloseDate = vntArrCloseDate
        vntOrgCd1 = vntArrOrgCd1
        vntOrgCd2 = vntArrOrgCd2
        vntBillClassCd = vntArrBillClassCd
        vntMethod = vntArrMethod
        vntTaxRates = vntArrTaxRates
        vntPrtDate = vntArrPrtDate
        vntOrgName = vntArrOrgName
        vntOrgBillName = vntArrOrgBillName
        vntChageName = vntArrChageName
        vntOrgDiv = vntArrOrgDiv
        vntBillClassName = vntArrBillClassName
    
    End If
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectPrintBill = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPrintBill = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectPrintBill"
    
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
' 機能　　 : 請求書団体別コース管理テーブルからレコードを取得する。
'
' 引数　　 : (In)     strBillNo             請求書番号
' 　　　　 : (In)     strSeq                ＳＥＱ
' 　　　　 : (In)     strCsSeq              コースＳＥＱ
' 　　　　 : (In)     strLineNo             明細Ｎｏ
' 　　　　 : (Out)    vntBillNo             請求書番号
' 　　　　 : (Out)    vntSeq                ＳＥＱ
' 　　　　 : (Out)    vntCsSeq              コースＳＥＱ
' 　　　　 : (Out)    vntCsCd               コースコード
' 　　　　 : (Out)    vntStrDate            開始受診日
' 　　　　 : (Out)    vntEndDate            終了受診日
' 　　　　 : (Out)    vntCslCnt             受診人数
' 　　　　 : (Out)    vntCsName             コース名
'
'
' 戻り値　 : 取得件数
'
' 備考　　 :
'
Public Function SelectPrintBillOrg( _
    ByVal strBillNo As String, _
    ByVal strSeq As String, _
    ByVal strCsSeq As String, _
    ByVal strLineNo As String, _
    Optional ByRef vntBillNo As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntStrDate As Variant, _
    Optional ByRef vntEndDate As Variant, _
    Optional ByRef vntCslCnt As Variant, _
    Optional ByRef vntCsName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objBillNo           As OraField         '請求書番号
    Dim objCsCd             As OraField         'コースコード
    Dim objStrDate          As OraField         '開始受診日
    Dim objEndDate          As OraField         '終了受診日
    Dim objCslCnt           As OraField         '受診人数
    Dim objCsName           As OraField         'コース名
    
    Dim vntArrBillNo()      As Variant          '請求書番号
    Dim vntArrCsCd()        As Variant          'コースコード
    Dim vntArrStrDate()     As Variant          '開始受診日
    Dim vntArrEndDate()     As Variant          '終了受診日
    Dim vntArrCslCnt()      As Variant          '受診人数
    Dim vntArrCsName()      As Variant          'コース名
    
    Dim conditionStr        As String
    Dim i                   As Long             'ループカウント
    Dim lngCount            As Long             'レコード数
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期設定
    conditionStr = "  WHERE  "
    
    '初期値
    If Not IsMissing(vntBillNo) Then vntBillNo = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntStrDate) Then vntStrDate = Empty
    If Not IsMissing(vntEndDate) Then vntEndDate = Empty
    If Not IsMissing(vntCslCnt) Then vntCslCnt = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strBillNo <> "") Then objOraParam.Add "BILLNO", strBillNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strSeq <> "") Then objOraParam.Add "SEQ", strSeq, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strCsSeq <> "") Then objOraParam.Add "CSSEQ", strCsSeq, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strLineNo <> "") Then objOraParam.Add "LINENO", strLineNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '請求書明細テーブルから取得
    strStmt = "  SELECT  BILL_COURSE.BILLNO,BILL_COURSE.CSCD, " & vbLf & _
              "          MIN(BILL_COURSE.STRDATE) STRDATE,MAX(BILL_COURSE.ENDDATE) ENDDATE,SUM(BILL_COURSE.CSLCNT) CSLCNT, " & vbLf & _
              "          (SELECT COURSE_P.CSNAME FROM COURSE_P WHERE BILL_COURSE.CSCD = COURSE_P.CSCD ) CSNAME  " & vbLf & _
              "    FROM  BILL_COURSE " & vbLf
    
    If ((strBillNo <> "") Or (strSeq <> "") _
        Or (strCsSeq <> "")) Then
        
        '請求書番号
        If (strBillNo <> "") Then
            strStmt = strStmt & conditionStr & " BILLNO    = :BILLNO      " & vbLf
            conditionStr = "  AND "
        End If

        'ＳＥＱ
        If (strSeq <> "") Then
            strStmt = strStmt & conditionStr & " SEQ    = :SEQ      " & vbLf
            conditionStr = "  AND "
        End If

        'コースＳＥＱ
        If (strCsSeq <> "") Then
            strStmt = strStmt & conditionStr & " CSSEQ    = :CSSEQ      " & vbLf
            conditionStr = "  AND "
        End If

    End If
    
    'グルーピングの設定
    strStmt = strStmt & "  GROUP BY  BILLNO,CSCD " & vbLf
    
    strStmt = strStmt & "  ORDER BY  BILLNO,CSCD " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objBillNo = objFields("BILLNO")
        Set objCsCd = objFields("CSCD")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objCslCnt = objFields("CSLCNT")
        Set objCsName = objFields("CSNAME")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            ReDim Preserve vntArrCslCnt(lngCount)
            ReDim Preserve vntArrCsName(lngCount)

            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrStrDate(lngCount) = objStrDate.Value & ""
            vntArrEndDate(lngCount) = objEndDate.Value & ""
            vntArrCslCnt(lngCount) = objCslCnt.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntBillNo = vntArrBillNo
        vntCsCd = vntArrCsCd
        vntStrDate = vntArrStrDate
        vntEndDate = vntArrEndDate
        vntCslCnt = vntArrCslCnt
        vntCsName = vntArrCsName

    End If
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectPrintBillOrg = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectPrintBillOrg"
    
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
' 機能　　 : 請求書明細テーブルの金額，消費税，合計の総和を取得する。
'
' 引数　　 : (In)     strBillNo             請求書番号
' 　　　　 : (In)     strSeq                ＳＥＱ
' 　　　　 : (In)     strCsSeq              コースＳＥＱ
' 　　　　 : (In)     strLineNo             明細Ｎｏ
' 　　　　 : (In)     strGroupCls           合計分類
' 　　　　 : (Out)    vntBillNo             請求書番号
' 　　　　 : (Out)    vntSeq                ＳＥＱ
' 　　　　 : (Out)    vntCsSeq              コースＳＥＱ
' 　　　　 : (Out)    vntLineNo             明細番号
' 　　　　 : (Out)    vntTotalCnt           合計人数
' 　　　　 : (Out)    vntSubTotal           金額
' 　　　　 : (Out)    vntTax                消費税
' 　　　　 : (Out)    vntDiscount           値引き
' 　　　　 : (Out)    vntTotal              合計
'
' 戻り値　 : 取得件数
'
' 備考　　 :
'
Public Function SelectSumBillDetail( _
    ByVal strBillNo As String, _
    ByVal strSeq As String, _
    ByVal strCsSeq As String, _
    ByVal strLineNo As String, _
    ByVal strGroupCls As Long, _
    Optional ByRef vntBillNo As Variant, _
    Optional ByRef vntSeq As Variant, _
    Optional ByRef vntCsSeq As Variant, _
    Optional ByRef vntLineNo As Variant, _
    Optional ByRef vntTotalCnt As Variant, _
    Optional ByRef vntSubTotal As Variant, _
    Optional ByRef vntTax As Variant, _
    Optional ByRef vntDiscount As Variant, _
    Optional ByRef vntTotal As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objBillNo           As OraField         '請求書番号
    Dim objSeq              As OraField         'ＳＥＱ
    Dim objCsSeq            As OraField         'ＣＳＳＥＱ
    Dim objLineNo           As OraField         '明細番号
    Dim objTotalCnt         As OraField         '合計人数
    Dim objSubTotal         As OraField         '金額
    Dim objTax              As OraField         '消費税
    Dim objDiscount         As OraField         '値引き
    Dim objTotal            As OraField         '合計
    
    Dim vntArrBillNo()      As Variant          '請求書番号
    Dim vntArrSeq()         As Variant          'ＳＥＱ
    Dim vntArrCsSeq()       As Variant          'ＣＳＳＥＱ
    Dim vntArrLineNo()      As Variant          '明細番号
    Dim vntArrTotalCnt()    As Variant          '合計人数
    Dim vntArrSubTotal()    As Variant          '金額
    Dim vntArrTax()         As Variant          '消費税
    Dim vntArrDiscount()    As Variant          '値引き
    Dim vntArrTotal()       As Variant          '合計
    
    Dim conditionStr        As String           '
    Dim strClm              As String           '
    Dim i                   As Long             'ループカウント
    Dim lngCount            As Long             'レコード数
    Dim lngItemCount        As Long             '項目数カウント
    
    Dim strArrClmName(ITEMCNT - 1)    As String
    
    '
    If (strGroupCls > CLng(ITEMCNT) Or strGroupCls < 1) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    '初期値
    If Not IsMissing(vntBillNo) Then vntBillNo = Empty
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntCsSeq) Then vntCsSeq = Empty
    If Not IsMissing(vntLineNo) Then vntLineNo = Empty
    If Not IsMissing(vntTotalCnt) Then vntTotalCnt = Empty
    If Not IsMissing(vntSubTotal) Then vntSubTotal = Empty
    If Not IsMissing(vntTax) Then vntTax = Empty
    If Not IsMissing(vntDiscount) Then vntDiscount = Empty
    If Not IsMissing(vntTotal) Then vntTotal = Empty

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期設定
    conditionStr = "  WHERE  "
    strArrClmName(0) = "BILLNO"
    strArrClmName(1) = "SEQ"
    strArrClmName(2) = "CSSEQ"
    strArrClmName(3) = "LINENO"
    strClm = ""
    lngItemCount = 0

    For i = 0 To (strGroupCls - 1)
        If (i = 0) Then
            strClm = strClm & strArrClmName(i) & vbLf
        Else
            strClm = strClm & "," & strArrClmName(i) & vbLf
        End If
    Next

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strBillNo <> "") Then objOraParam.Add "BILLNO", strBillNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strSeq <> "") Then objOraParam.Add "SEQ", strSeq, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strCsSeq <> "") Then objOraParam.Add "CSSEQ", strCsSeq, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strLineNo <> "") Then objOraParam.Add "LINENO", strLineNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '請求書明細テーブルから取得
    strStmt = "  SELECT " & strClm
    
    strStmt = strStmt & ",SUM(TOTALCNT) TOTALCNT,SUM(SUBTOTAL) SUBTOTAL,SUM(TAX) TAX,SUM(DISCOUNT) DISCOUNT ,SUM(TOTAL) TOTAL " & vbLf & _
                        " FROM BILLDETAIL " & vbLf
    
    If ((strBillNo <> "") Or (strSeq <> "") _
        Or (strCsSeq <> "") Or (strLineNo <> "")) Then
        
        '請求書番号
        If (strBillNo <> "") Then
            strStmt = strStmt & conditionStr & " BILLNO    = :BILLNO      " & vbLf
            conditionStr = "  AND "
        End If

        'ＳＥＱ
        If (strSeq <> "") Then
            strStmt = strStmt & conditionStr & " SEQ    = :SEQ      " & vbLf
            conditionStr = "  AND "
        End If

        'コースＳＥＱ
        If (strCsSeq <> "") Then
            strStmt = strStmt & conditionStr & " CSSEQ    = :CSSEQ      " & vbLf
            conditionStr = "  AND "
        End If

        '明細番号
        If (strLineNo <> "") Then
            strStmt = strStmt & conditionStr & " LINENO    = :LINENO      " & vbLf
            conditionStr = "  AND "
        End If

    End If
    
    'グルーピングの設定
    strStmt = strStmt & "  GROUP BY  " & strClm
    
    strStmt = strStmt & "  ORDER BY  " & strClm

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        If (lngItemCount < strGroupCls) Then
            Set objBillNo = objFields("BILLNO")
            lngItemCount = lngItemCount + 1
        End If
        
        If (lngItemCount < strGroupCls) Then
            Set objSeq = objFields("SEQ")
            lngItemCount = lngItemCount + 1
        End If
        
        If (lngItemCount < strGroupCls) Then
            Set objCsSeq = objFields("CSSEQ")
            lngItemCount = lngItemCount + 1
        End If
        
        If (lngItemCount < strGroupCls) Then
            Set objLineNo = objFields("LINENO")
            lngItemCount = lngItemCount + 1
        End If

        Set objTotalCnt = objFields("TOTALCNT")
        Set objSubTotal = objFields("SUBTOTAL")
        Set objTax = objFields("TAX")
        Set objDiscount = objFields("DISCOUNT")
        Set objTotal = objFields("TOTAL")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrCsSeq(lngCount)
            ReDim Preserve vntArrLineNo(lngCount)
            ReDim Preserve vntArrTotalCnt(lngCount)
            ReDim Preserve vntArrSubTotal(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrDiscount(lngCount)
            ReDim Preserve vntArrTotal(lngCount)

            If (lngItemCount < strGroupCls - 1) Then vntArrBillNo(lngCount) = objBillNo.Value & ""
            If (lngItemCount < strGroupCls - 1) Then vntArrSeq(lngCount) = objSeq.Value & ""
            If (lngItemCount < strGroupCls - 1) Then vntArrCsSeq(lngCount) = objCsSeq.Value & ""
            If (lngItemCount < strGroupCls - 1) Then vntArrLineNo(lngCount) = objLineNo.Value & ""
            vntArrTotalCnt(lngCount) = objTotalCnt.Value & ""
            vntArrSubTotal(lngCount) = objSubTotal.Value & ""
            vntArrTax(lngCount) = objTax.Value & ""
            vntArrDiscount(lngCount) = objDiscount.Value & ""
            vntArrTotal(lngCount) = objTotal.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntBillNo = vntArrBillNo
        vntSeq = vntArrSeq
        vntCsSeq = vntArrCsSeq
        vntLineNo = vntArrLineNo
        vntTotalCnt = vntArrTotalCnt
        vntSubTotal = vntArrSubTotal
        vntTax = vntArrTax
        vntDiscount = vntArrDiscount
        vntTotal = vntArrTotal

    End If
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectSumBillDetail = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectSumBillDetail"
    
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
' 機能　　 : 請求書団体別コース管理テーブルからレコードを取得する。
'
' 引数　　 : (In)     strGroup              グルーピング文字列（集計処理したい項目をカンマ区切りで設定）
' 　　　　 : (In)     strBillNo             請求書番号
' 　　　　 : (In)     strSeq                ＳＥＱ
' 　　　　 : (In)     strCsSeq              コースＳＥＱ
' 　　　　 : (In)     strLineNo             明細Ｎｏ
' 　　　　 : (Out)    vntBillNo             請求書番号
' 　　　　 : (Out)    vntSeq                ＳＥＱ
' 　　　　 : (Out)    vntCsSeq              コースＳＥＱ
' 　　　　 : (Out)    vntCsCd               コースコード
' 　　　　 : (Out)    vntStrDate            開始受診日
' 　　　　 : (Out)    vntEndDate            終了受診日
' 　　　　 : (Out)    vntCslCnt             受診人数
' 　　　　 : (Out)    vntCsName             コース名
'
'
' 戻り値　 : 取得件数
'
' 備考　　 :
'
Public Function SelectPrintBillCourse( _
    ByVal strSumCls As String, _
    ByVal strBillNo As String, _
    ByVal strSeq As String, _
    ByVal strCsSeq As String, _
    ByVal strLineNo As String, _
    Optional ByRef vntBillNo As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntStrDate As Variant, _
    Optional ByRef vntEndDate As Variant, _
    Optional ByRef vntCslCnt As Variant, _
    Optional ByRef vntCsName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objBillNo           As OraField         '請求書番号
    Dim objCsCd             As OraField         'コースコード
    Dim objStrDate          As OraField         '開始受診日
    Dim objEndDate          As OraField         '終了受診日
    Dim objCslCnt           As OraField         '受診人数
    Dim objCsName           As OraField         'コース名
    
    Dim vntArrBillNo()      As Variant          '請求書番号
    Dim vntArrCsCd()        As Variant          'コースコード
    Dim vntArrStrDate()     As Variant          '開始受診日
    Dim vntArrEndDate()     As Variant          '終了受診日
    Dim vntArrCslCnt()      As Variant          '受診人数
    Dim vntArrCsName()      As Variant          'コース名
    
    Dim conditionStr        As String
    Dim strGroup            As String
    Dim i                   As Long             'ループカウント
    Dim lngCount            As Long             'レコード数
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期設定
    conditionStr = "  WHERE  "
    
    '初期値
    If Not IsMissing(vntBillNo) Then vntBillNo = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntStrDate) Then vntStrDate = Empty
    If Not IsMissing(vntEndDate) Then vntEndDate = Empty
    If Not IsMissing(vntCslCnt) Then vntCslCnt = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty

    Select Case strSumCls
        Case "1":
            strGroup = " BILL_COURSE.BILLNO,BILL_COURSE.CSCD "
        Case "2":
            strGroup = " BILL_COURSE.BILLNO,BILL_COURSE.SEQ "
        Case Else:
            strGroup = " BILL_COURSE.BILLNO,BILL_COURSE.SEQ, BILL_COURSE.CSSEQ "
    End Select
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strBillNo <> "") Then objOraParam.Add "BILLNO", strBillNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strSeq <> "") Then objOraParam.Add "SEQ", strSeq, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strCsSeq <> "") Then objOraParam.Add "CSSEQ", strCsSeq, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strLineNo <> "") Then objOraParam.Add "LINENO", strLineNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '請求書明細テーブルから取得
    strStmt = "  SELECT  " & strGroup & " ,  " & vbLf & _
              "          MIN(BILL_COURSE.STRDATE) STRDATE,MAX(BILL_COURSE.ENDDATE) ENDDATE,SUM(BILL_COURSE.CSLCNT) CSLCNT " & vbLf
    
    If (strSumCls = 1) Then
        strStmt = strStmt & "         , (SELECT COURSE_P.CSNAME FROM COURSE_P WHERE BILL_COURSE.CSCD = COURSE_P.CSCD ) CSNAME  " & vbLf
    End If
    
    strStmt = strStmt & "    FROM  BILL_COURSE " & vbLf
    
    If ((strBillNo <> "") Or (strSeq <> "") _
        Or (strCsSeq <> "")) Then
        
        '請求書番号
        If (strBillNo <> "") Then
            strStmt = strStmt & conditionStr & " BILLNO    = :BILLNO      " & vbLf
            conditionStr = "  AND "
        End If

        'ＳＥＱ
        If (strSeq <> "") Then
            strStmt = strStmt & conditionStr & " SEQ    = :SEQ      " & vbLf
            conditionStr = "  AND "
        End If

        'コースＳＥＱ
        If (strCsSeq <> "") Then
            strStmt = strStmt & conditionStr & " CSSEQ    = :CSSEQ      " & vbLf
            conditionStr = "  AND "
        End If

    End If

    '*****  コースに関係ない請求はコースコードがNULLとなるため、CSCDがNULLのレコードは対象外とする
    strStmt = strStmt & "   AND  CSCD  IS NOT  NULL      " & vbLf

    'グルーピングの設定
    strStmt = strStmt & "  GROUP BY  " & strGroup & vbLf
    
    strStmt = strStmt & "  ORDER BY  " & strGroup & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objBillNo = objFields("BILLNO")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objCslCnt = objFields("CSLCNT")
        If (strSumCls = "1") Then
            Set objCsCd = objFields("CSCD")
            Set objCsName = objFields("CSNAME")
        End If
        

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            ReDim Preserve vntArrCslCnt(lngCount)

            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrStrDate(lngCount) = objStrDate.Value & ""
            vntArrEndDate(lngCount) = objEndDate.Value & ""
            vntArrCslCnt(lngCount) = objCslCnt.Value & ""
            If (strSumCls = "1") Then
                ReDim Preserve vntArrCsCd(lngCount)
                ReDim Preserve vntArrCsName(lngCount)
                vntArrCsCd(lngCount) = objCsCd.Value & ""
                vntArrCsName(lngCount) = objCsName.Value & ""
            End If

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntBillNo = vntArrBillNo
        vntStrDate = vntArrStrDate
        vntEndDate = vntArrEndDate
        vntCslCnt = vntArrCslCnt
        If (strSumCls = "1") Then
            vntCsCd = vntArrCsCd
            vntCsName = vntArrCsName
        End If
        
    End If

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectPrintBillCourse = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPrintBillCourse = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectPrintBillCourse"
    
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
' 機能　　 : 請求書明細テーブルからレコードを取得する。
'
' 引数　　 : (In)     strBillNo             請求書番号
' 　　　　 : (In)     strSeq                ＳＥＱ
' 　　　　 : (In)     strCsSeq              コースＳＥＱ
' 　　　　 : (In)     strLineNo             明細Ｎｏ
' 　　　　 : (Out)    vntBillNo             請求書番号
' 　　　　 : (Out)    vntSeq                ＳＥＱ
' 　　　　 : (Out)    vntCsSeq              コースＳＥＱ
' 　　　　 : (Out)    vntLineNo             明細番号
' 　　　　 : (Out)    vntDmdLineClassCd     請求書明細分類コード
' 　　　　 : (Out)    vntNoPrint            請求書未出力フラグ
' 　　　　 : (Out)    vntDetailName         名称
' 　　　　 : (Out)    vntAgeDiv             年齢区分
' 　　　　 : (Out)    vntExistsIsr          健保有無区分
' 　　　　 : (Out)    vntTotalCnt           合計人数
' 　　　　 : (Out)    vntSubTotal           金額
' 　　　　 : (Out)    vntTax                消費税
' 　　　　 : (Out)    vntDiscount           値引き
' 　　　　 : (Out)    vntTotal              合計
' 　　　　 : (Out)    vntCsCd               コースコード
' 　　　　 : (Out)    vntCsName             コース名
'
'
' 戻り値　 : 取得件数
'
' 備考　　 :
'
Public Function SelectPrintBillDetail( _
    ByVal strBillNo As String, _
    ByVal strSeq As String, _
    ByVal strCsSeq As String, _
    ByVal strLineNo As String, _
    Optional ByRef vntBillNo As Variant, _
    Optional ByRef vntSeq As Variant, _
    Optional ByRef vntCsSeq As Variant, _
    Optional ByRef vntLineNo As Variant, _
    Optional ByRef vntDmdLineClassCd As Variant, _
    Optional ByRef vntNoPrint As Variant, _
    Optional ByRef vntDetailName As Variant, _
    Optional ByRef vntAgeDiv As Variant, _
    Optional ByRef vntExistsIsr As Variant, _
    Optional ByRef vntPrice As Variant, _
    Optional ByRef vntTotalCnt As Variant, _
    Optional ByRef vntSubTotal As Variant, _
    Optional ByRef vntTax As Variant, _
    Optional ByRef vntDiscount As Variant, _
    Optional ByRef vntTotal As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objBillNo           As OraField         '請求書番号
    Dim objSeq              As OraField         'ＳＥＱ
    Dim objCsSeq            As OraField         'ＣＳＳＥＱ
    Dim objLineNo           As OraField         '明細番号
    Dim objDmdLineClassCd   As OraField         '請求書分類コード
    Dim objNoPrint          As OraField         '請求書未出力フラグ
    Dim objDetailName       As OraField         '名称
    Dim objAgeDiv           As OraField         '年齢区分
    Dim objExistsIsr        As OraField         '健保有無区分
    Dim objPrice            As OraField         '負担元単価
    Dim objTotalCnt         As OraField         '合計人数
    Dim objSubTotal         As OraField         '金額
    Dim objTax              As OraField         '消費税
    Dim objDiscount         As OraField         '値引き
    Dim objTotal            As OraField         '合計
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名称

    Dim vntArrBillNo()      As Variant          '請求書番号
    Dim vntArrSeq()         As Variant          'ＳＥＱ
    Dim vntArrCsSeq()       As Variant          'ＣＳＳＥＱ
    Dim vntArrLineNo()      As Variant          '明細番号
    Dim vntArrDmdLineClassCd()   As Variant           '請求書分類コード
    Dim vntArrNoPrint()     As Variant          '請求書未出力フラグ
    Dim vntArrDetailName()  As Variant          '名称
    Dim vntArrAgeDiv()      As Variant          '年齢区分
    Dim vntArrExistsIsr()   As Variant          '健保有無区分
    Dim vntArrPrice()       As Variant          '負担元単価
    Dim vntArrTotalCnt()    As Variant          '合計人数
    Dim vntArrSubTotal()    As Variant          '金額
    Dim vntArrTax()         As Variant          '消費税
    Dim vntArrDiscount()    As Variant          '値引き
    Dim vntArrTotal()       As Variant          '合計
    Dim vntArrCsCd()        As Variant          'コースコード
    Dim vntArrCsName()      As Variant          'コース名称
    
    Dim conditionStr        As String           '
    Dim i                   As Long             'ループカウント
    Dim lngCount            As Long             'レコード数
    Dim lngItemCount        As Long             '項目数カウント
    
    '初期値
    If Not IsMissing(vntBillNo) Then vntBillNo = Empty
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntCsSeq) Then vntCsSeq = Empty
    If Not IsMissing(vntLineNo) Then vntLineNo = Empty
    If Not IsMissing(vntDmdLineClassCd) Then vntDmdLineClassCd = Empty
    If Not IsMissing(vntNoPrint) Then vntNoPrint = Empty
    If Not IsMissing(vntDetailName) Then vntDetailName = Empty
    If Not IsMissing(vntAgeDiv) Then vntAgeDiv = Empty
    If Not IsMissing(vntExistsIsr) Then vntExistsIsr = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntTotalCnt) Then vntTotalCnt = Empty
    If Not IsMissing(vntSubTotal) Then vntSubTotal = Empty
    If Not IsMissing(vntTax) Then vntTax = Empty
    If Not IsMissing(vntDiscount) Then vntDiscount = Empty
    If Not IsMissing(vntTotal) Then vntTotal = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合はエラー
    If Not IsNumeric(strBillNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '初期設定
    conditionStr = "  WHERE  "
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strBillNo <> "") Then objOraParam.Add "BILLNO", strBillNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strSeq <> "") Then objOraParam.Add "SEQ", strSeq, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strCsSeq <> "") Then objOraParam.Add "CSSEQ", strCsSeq, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strLineNo <> "") Then objOraParam.Add "LINENO", strLineNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす請求書団体管理情報のレコードを取得
    strStmt = "SELECT BILLDETAIL.BILLNO,    BILLDETAIL.SEQ,        BILLDETAIL.CSSEQ,    " & vbLf & _
              "       BILLDETAIL.LINENO,    BILLDETAIL.DMDLINECLASSCD,                  " & vbLf & _
              "       BILLDETAIL.NOPRINT,   BILLDETAIL.DETAILNAME, BILLDETAIL.AGEDIV,   " & vbLf & _
              "       BILLDETAIL.EXISTSISR, BILLDETAIL.PRICE,      BILLDETAIL.TOTALCNT, " & vbLf & _
              "       BILLDETAIL.SUBTOTAL,  BILLDETAIL.TAX,        BILLDETAIL.DISCOUNT, " & vbLf & _
              "       BILLDETAIL.TOTAL,                                                 " & vbLf & _
              "       BILL_COURSE.CSCD,                                                 " & vbLf & _
              "       ( SELECT CSNAME FROM COURSE_P WHERE  BILL_COURSE.CSCD =  COURSE_P.CSCD )  CSNAME  " & vbLf & _
              "  FROM BILLDETAIL, BILL_COURSE                                           " & vbLf
    
    If ((strBillNo <> "") Or (strSeq <> "") _
        And (strCsSeq <> "") Or (strLineNo <> "")) Then

        '請求書番号
        If (strBillNo <> "") Then
            strStmt = strStmt & conditionStr & " BILLDETAIL.BILLNO    = :BILLNO      " & vbLf
            conditionStr = "  AND "
        End If

        'ＳＥＱ
        If (strSeq <> "") Then
            strStmt = strStmt & conditionStr & " BILLDETAIL.SEQ    = :SEQ      " & vbLf
            conditionStr = "  AND "
        End If

        'コースＳＥＱ
        If (strCsSeq <> "") Then
            strStmt = strStmt & conditionStr & " BILLDETAIL.CSSEQ    = :CSSEQ      " & vbLf
            conditionStr = "  AND "
        End If

        '明細番号
        If (strLineNo <> "") Then
            strStmt = strStmt & conditionStr & " BILLDETAIL.LINENO    = :LINENO      " & vbLf
            conditionStr = "  AND "
        End If

    End If
    
    strStmt = strStmt & "  AND BILLDETAIL.NOPRINT   = 0                    " & vbLf & _
                        "  AND BILLDETAIL.BILLNO    = BILL_COURSE.BILLNO   " & vbLf & _
                        "  AND BILLDETAIL.SEQ       = BILL_COURSE.SEQ      " & vbLf & _
                        "  AND BILLDETAIL.CSSEQ     = BILL_COURSE.CSSEQ    " & vbLf

    strStmt = strStmt & "  ORDER BY BILLDETAIL.BILLNO,BILLDETAIL.SEQ,BILLDETAIL.CSSEQ,BILLDETAIL.LINENO " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objBillNo = objFields("BILLNO")
        Set objSeq = objFields("SEQ")
        Set objCsSeq = objFields("CSSEQ")
        Set objLineNo = objFields("LINENO")
        Set objDmdLineClassCd = objFields("DMDLINECLASSCD")
        Set objNoPrint = objFields("NOPRINT")
        Set objDetailName = objFields("DETAILNAME")
        Set objAgeDiv = objFields("AGEDIV")
        Set objExistsIsr = objFields("EXISTSISR")
        Set objPrice = objFields("PRICE")
        Set objTotalCnt = objFields("TOTALCNT")
        Set objSubTotal = objFields("SUBTOTAL")
        Set objTax = objFields("TAX")
        Set objDiscount = objFields("DISCOUNT")
        Set objTotal = objFields("TOTAL")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrCsSeq(lngCount)
            ReDim Preserve vntArrLineNo(lngCount)
            ReDim Preserve vntArrDmdLineClassCd(lngCount)
            ReDim Preserve vntArrNoPrint(lngCount)
            ReDim Preserve vntArrDetailName(lngCount)
            ReDim Preserve vntArrAgeDiv(lngCount)
            ReDim Preserve vntArrExistsIsr(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrTotalCnt(lngCount)
            ReDim Preserve vntArrSubTotal(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrDiscount(lngCount)
            ReDim Preserve vntArrTotal(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)

            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrCsSeq(lngCount) = objCsSeq.Value & ""
            vntArrLineNo(lngCount) = objLineNo.Value & ""
            vntArrDmdLineClassCd(lngCount) = objDmdLineClassCd.Value & ""
            vntArrNoPrint(lngCount) = objNoPrint.Value & ""
            vntArrDetailName(lngCount) = objDetailName.Value & ""
            vntArrAgeDiv(lngCount) = objAgeDiv.Value & ""
            vntArrExistsIsr(lngCount) = objExistsIsr.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrTotalCnt(lngCount) = objTotalCnt.Value & ""
            vntArrSubTotal(lngCount) = objSubTotal.Value & ""
            vntArrTax(lngCount) = objTax.Value & ""
            vntArrDiscount(lngCount) = objDiscount.Value & ""
            vntArrTotal(lngCount) = objTotal.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntBillNo = vntArrBillNo
        vntSeq = vntArrSeq
        vntCsSeq = vntArrCsSeq
        vntLineNo = vntArrLineNo
        vntDmdLineClassCd = vntArrDmdLineClassCd
        vntNoPrint = vntArrNoPrint
        vntDetailName = vntArrDetailName
        vntAgeDiv = vntArrAgeDiv
        vntExistsIsr = vntArrExistsIsr
        vntPrice = vntArrPrice
        vntTotalCnt = vntArrTotalCnt
        vntSubTotal = vntArrSubTotal
        vntTax = vntArrTax
        vntDiscount = vntArrDiscount
        vntTotal = vntArrTotal
        vntCsCd = vntArrCsCd
        vntCsName = vntArrCsName

    End If
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectPrintBillDetail = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPrintBillDetail = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectPrintBillDetail"
    
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
' 機能　　 : 請求書テーブルからレコードを取得する。
'
' 引数　　 : (In)     strBillNo             請求書番号
' 　　　　 : (In)     strStartCloseDate     締め日（開始日）
' 　　　　 : (In)     strEndCloseDate       締め日（終了日）
' 　　　　 : (In)     strOrgCd1             団体コード１
' 　　　　 : (In)     strOrgCd2             団体コード２
' 　　　　 : (In)     strBillClassCd        請求書分類コード
'
' 戻り値　 : 取得件数
'
' 備考　　 :
'
Public Function UpdateBillPrtDate( _
    ByVal strBillNo As String, _
    ByVal strStartCloseDate As String, _
    ByVal strEndCloseDate As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strBillClassCd As String _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim conditionStr        As String           '
    Dim Ret                 As Long             '関数戻り値
    
    '初期値
   
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期設定
    conditionStr = "  WHERE  "
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strBillNo <> "") Then objOraParam.Add "BILLNO", strBillNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strStartCloseDate <> "") Then objOraParam.Add "STARTCLOSEDATE", strStartCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strEndCloseDate <> "") Then objOraParam.Add "ENDCLOSEDATE", strEndCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strOrgCd1 <> "") Then objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd2 <> "") Then objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strBillClassCd <> "") Then objOraParam.Add "BILLCLASSCD", strBillClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '請求書テーブルから取得
    strStmt = "UPDATE BILL                  " & vbLf & _
              "   SET PRTDATE = SYSDATE     " & vbLf
              
    If ((strBillNo <> "") Or (strStartCloseDate <> "") _
        Or (strEndCloseDate <> "") Or (strOrgCd1 <> "") _
        Or (strOrgCd2 <> "") Or (strBillClassCd <> "")) Then
        
        '請求書番号
        If (strBillNo <> "") Then
            strStmt = strStmt & conditionStr & " BILL.BILLNO    = :BILLNO      " & vbLf
            conditionStr = "  AND "
        End If

        '締め日（開始日）
        If (strStartCloseDate <> "") Then
            strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    >= :STARTCLOSEDATE      " & vbLf
            conditionStr = "  AND "
        End If

        '締め日（終了日）
        If (strEndCloseDate <> "") Then
            strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    <= :ENDCLOSEDATE      " & vbLf
            conditionStr = "  AND "
        End If

        '団体コード１
        If (strOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD1    = :ORGCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '団体コード２
        If (strOrgCd2 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD2    = :ORGCD2      " & vbLf
            conditionStr = "  AND "
        End If

        '請求書分類コード
        If (strBillClassCd <> "") Then
            strStmt = strStmt & conditionStr & " BILL.BILLCLASSCD    = :BILLCLASSCD      " & vbLf
            conditionStr = "  AND "
        End If
    
    End If
    
    '出力条件の設定
    strStmt = strStmt & conditionStr & "  BILL.PRTDATE IS NULL       " & vbLf
    
    Ret = mobjOraDb.ExecuteSQL(strStmt)
        
    If Ret < 0 Then
        Ret = INSERT_DUPLICATE
    End If
    
    UpdateBillPrtDate = Ret
        
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateBillPrtDate = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.UpdateBillPrtDate"
    
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
' 機能　　 : 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
'
' 引数　　 : (In)     strSortFlg            ソートフラグ
' 　　　　   (In)     strStrCloseDate       締め日（開始日）
' 　　　　   (In)     strEndCloseDate       締め日（終了日）
' 　　　　   (In)     strIsrOrgCd1          健保団体コード１
' 　　　　   (In)     strIsrOrgCd2          健保団体コード２
' 　　　　   (In)     strOrgDiv             団体分類
' 　　　　   (In)     strOrgCd1             団体コード１
' 　　　　   (In)     strOrgCd2             団体コード２
' 　　　　   (In)     strIsrSign            健保記号
' 　　　　   (In)     strBillNo             請求書番号
' 　　　　   (In)     strBillClassCd        請求書分類コード
' 　　　　   (Out)    vntBillNo             請求書番号
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntCloseDate          締め日
' 　　　　   (Out)    vntBillTitol          請求書用タイトル
' 　　　　   (Out)    vntBillClassCd        請求書分類コード
' 　　　　   (Out)    vntBillClassCd        請求書分類名
' 　　　　   (Out)    vntOrgName            団体名称
' 　　　　   (Out)    vntSeq                ＳＥＱ
' 　　　　   (Out)    vntCslOrgCd1          受診団体コード１
' 　　　　   (Out)    vntCslOrgCd2          受診団体コード２
' 　　　　   (Out)    vntIsrSign            健保記号
' 　　　　   (Out)    vntCslOrgName         受診団体名称
' 　　　　   (Out)    vntChargeName         担当者名
' 　　　　   (Out)    vntOrgBillName        団体請求名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectDemandDetailList( _
                                    ByVal strSortFlg As String, _
                                    ByVal strStrCloseDate As String, ByVal strEndCloseDate As String, _
                                    ByVal strIsrOrgCd1 As String, ByVal strIsrOrgCd2 As String, _
                                    ByVal strOrgDiv As String, _
                                    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
                                    ByVal strIsrSign As String, _
                                    ByVal strBillNo As String, _
                                    ByVal strBillClassCd As String, _
                                    Optional ByRef vntBillNo As Variant, _
                                    Optional ByRef vntOrgCd1 As Variant, _
                                    Optional ByRef vntOrgCd2 As Variant, _
                                    Optional ByRef vntCloseDate As Variant, _
                                    Optional ByRef vntBillTitol As Variant, _
                                    Optional ByRef vntBillClassCd As Variant, _
                                    Optional ByRef vntBillClassName As Variant, _
                                    Optional ByRef vntOrgName As Variant, _
                                    Optional ByRef vntSeq As Variant, _
                                    Optional ByRef vntCslOrgCd1 As Variant, _
                                    Optional ByRef vntCslOrgCd2 As Variant, _
                                    Optional ByRef vntIsrSign As Variant, _
                                    Optional ByRef vntCslOrgName As Variant, _
                                    Optional ByRef vntChargeName As Variant, _
                                    Optional ByRef vntOrgBillName As Variant _
) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objBillNo                   As OraField         '請求書番号
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objCloseDate                As OraField         '締め日
    Dim objBillTitol                As OraField         '請求書用タイトル
    Dim objBillClassCd              As OraField         '請求書分類番号
    Dim objBillClassName            As OraField         '請求書分類名称
    Dim objOrgName                  As OraField         '団体名称
    Dim objSeq                      As OraField         '請求書ＳＥＱ
    Dim objCslOrgCd1                As OraField         '受診団体コード１
    Dim objCslOrgCd2                As OraField         '受診団体コード２
    Dim objIsrSign                  As OraField         '健保記号
    Dim objCslOrgName               As OraField         '団体名称（負担元）
    Dim objChargeName               As OraField         '担当者
    Dim objOrgBillName              As OraField         '請求書用名称
    
    Dim vntArrBillNo()              As Variant          '請求書番号
    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrBillTitol()           As Variant          '請求書用タイトル
    Dim vntArrBillClassCd()         As Variant          '請求書分類番号
    Dim vntArrBillClassName()       As Variant          '請求書分類名称
    Dim vntArrOrgName()             As Variant          '団体名称
    Dim vntArrSeq()                 As Variant          '請求書ＳＥＱ
    Dim vntArrCslOrgCd1()           As Variant          '受診団体コード１
    Dim vntArrCslOrgCd2()           As Variant          '受診団体コード２
    Dim vntArrIsrSign()             As Variant          '健保記号
    Dim vntArrCslOrgName()          As Variant          '団体名称（負担元）
    Dim vntArrChargeName()          As Variant          '担当者
    Dim vntArrOrgBillName()         As Variant          '請求書用名称
    
    Dim conditionStr                As String           'SQL編集用ワーク
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期設定
    conditionStr = "  WHERE  "
    SelectDemandDetailList = 0

    If IsMissing(vntBillNo) Then vntBillNo = Empty
    If IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If IsMissing(vntCloseDate) Then vntCloseDate = Empty
    If IsMissing(vntBillTitol) Then vntBillTitol = Empty
    If IsMissing(vntBillClassCd) Then vntBillClassCd = Empty
    If IsMissing(vntBillClassName) Then vntBillClassName = Empty
    If IsMissing(vntOrgName) Then vntOrgName = Empty
    If IsMissing(vntSeq) Then vntSeq = Empty
    If IsMissing(vntCslOrgCd1) Then vntCslOrgCd1 = Empty
    If IsMissing(vntCslOrgCd2) Then vntCslOrgCd2 = Empty
    If IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If IsMissing(vntCslOrgName) Then vntCslOrgName = Empty
    If IsMissing(vntChargeName) Then vntChargeName = Empty
    If IsMissing(vntOrgBillName) Then vntOrgBillName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strStrCloseDate <> "") Then objOraParam.Add "STRCLOSEDATE", strStrCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strEndCloseDate <> "") Then objOraParam.Add "ENDCLOSEDATE", strEndCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strIsrOrgCd1 <> "") Then objOraParam.Add "ISRORGCD1", strIsrOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strIsrOrgCd2 <> "") Then objOraParam.Add "ISRORGCD2", strIsrOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgDiv <> "") Then objOraParam.Add "ORGDIV", strOrgDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd1 <> "") Then objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd2 <> "") Then objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strIsrSign <> "") Then objOraParam.Add "ISRSIGN", strIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strBillNo <> "") Then objOraParam.Add "BILLNO", strBillNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strBillClassCd <> "") Then objOraParam.Add "BILLCLASSCD", strBillClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    strStmt = "  SELECT  BILLTBL.BILLNO BILLNO, BILLTBL.ORGCD1 ORGCD1 ,             " & vbLf & _
              "          BILLTBL.ORGCD2 ORGCD2, BILLTBL.BILLCLASSCD BILLCLASSCD,    " & vbLf & _
              "          BILLTBL.CLOSEDATE CLOSEDATE,                               " & vbLf & _
              "          BILLTBL.BILLTITLE BILLTITLE,                               " & vbLf & _
              "          BILLTBL.ORGNAME ORGNAME,                                   " & vbLf & _
              "          BILLTBL.BILLCLASSNAME BILLCLASSNAME,                       " & vbLf & _
              "          BILLORGTBL.SEQ SEQ,                                        " & vbLf & _
              "          BILLORGTBL.CSLORGCD1 CSLORGCD1, BILLORGTBL.CSLORGCD2 CSLORGCD2,    " & vbLf & _
              "          BILLORGTBL.ISRSIGN ISRSIGN, BILLORGTBL.ORGNAME CSLORGNAME,    " & vbLf & _
              "          BILLORGTBL.CHARGENAME CHARGENAME, BILLORGTBL.ORGBILLNAME ORGBILLNAME " & vbLf & _
              "    FROM   " & vbLf
    
    '請求書テーブルからデータを取得
'*****  2003/02/19  EDIT  START  E.Yamamoto
'    strStmt = strStmt & " ( SELECT BILL.BILLNO, BILL.ORGCD1, BILL.ORGCD2,           " & vbLf & _
'                        "          BILL.BILLCLASSCD,BILL.CLOSEDATE,                 " & vbLf & _
'                        "          BILL.BILLTITLE,                                  " & vbLf & _
'                        "          BILL.BILLCLASSNAME,                              " & vbLf & _
'                        "          ORG.ORGNAME                                      " & vbLf & _
'                        "     FROM BILL, ORG, BILLCLASS                             " & vbLf
    strStmt = strStmt & " ( SELECT BILL.BILLNO, BILL.ORGCD1, BILL.ORGCD2,           " & vbLf & _
                        "          BILL.BILLCLASSCD,BILL.CLOSEDATE,                 " & vbLf & _
                        "          BILLCLASS.BILLTITLE,                                  " & vbLf & _
                        "          BILLCLASS.BILLCLASSNAME,                         " & vbLf & _
                        "          ORG.ORGNAME                                      " & vbLf & _
                        "     FROM BILL, ORG, BILLCLASS                             " & vbLf
'*****  2003/02/19  EDIT  END  E.Yamamoto

    If ((strBillNo <> "") Or (strStrCloseDate <> "") Or (strEndCloseDate <> "") _
        Or (strIsrOrgCd1 <> "") Or (strIsrOrgCd2 <> "") _
        Or (strBillClassCd <> "")) Then

        '請求書番号
        If (strBillNo <> "") Then
            strStmt = strStmt & conditionStr & " BILL.BILLNO    = :BILLNO      " & vbLf
            conditionStr = "  AND "
        End If

        '健保団体１
        If (strIsrOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD1    = :ISRORGCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '健保団体２
        If (strIsrOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD2    = :ISRORGCD2     " & vbLf
            conditionStr = "  AND "
        End If

        If (strStrCloseDate <> "" And strEndCloseDate <> "") Then

            '締め日（開始日）
            If (strStrCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    >= :STRCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
            '締め日（終了日）
            If (strEndCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    <= :ENDCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
        Else
            '締め日（開始日）
            If (strStrCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    = :STRCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
            '締め日（終了日）
            If (strEndCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    = :ENDCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If

        End If

        '請求書分類コード
        If (strBillClassCd <> "") Then
            strStmt = strStmt & conditionStr & " BILL.BILLCLASSCD    = :BILLCLASSCD      " & vbLf
            conditionStr = "  AND "
        End If
    
    End If

    strStmt = strStmt & conditionStr & "     BILL.ORGCD1   =  ORG.ORGCD1        " & vbLf & _
                        " AND   BILL.ORGCD2   =  ORG.ORGCD2                     " & vbLf
    If (strOrgDiv <> "") Then
         strStmt = strStmt & " AND   ORG.ORGDIV    =  :ORGDIV              " & vbLf
     End If
     
    strStmt = strStmt & " AND   BILL.BILLCLASSCD = BILLCLASS.BILLCLASSCD        " & vbLf & _
                        " )  BILLTBL ,   " & vbLf

    '請求書団体テーブルからデータを取得
    conditionStr = "  WHERE  "
    strStmt = strStmt & " ( SELECT BILL_ORG.BILLNO, BILL_ORG.SEQ, BILL_ORG.CSLORGCD1,   " & vbLf & _
                        "          BILL_ORG.CSLORGCD2,BILL_ORG.ISRSIGN,                 " & vbLf & _
                        "          ORG.ORGNAME,ORG.CHARGENAME,                          " & vbLf & _
                        "          ORG.ORGBILLNAME                                      " & vbLf & _
                        "     FROM BILL_ORG, ORG  " & vbLf


    If ((strOrgCd1 <> "") Or (strOrgCd2 <> "")) Then
        
        '団体コード１
        If (strOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL_ORG.CSLORGCD1    = :ORGCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '団体コード２
        If (strOrgCd2 <> "") Then
            strStmt = strStmt & conditionStr & " BILL_ORG.CSLORGCD2    = :ORGCD2      " & vbLf
            conditionStr = "  AND "
        End If

    End If

    strStmt = strStmt & conditionStr & "  BILL_ORG.CSLORGCD1  =  ORG.ORGCD1   " & vbLf & _
                                       "  AND  BILL_ORG.CSLORGCD2  =  ORG.ORGCD2   " & vbLf & _
                                       " )  BILLORGTBL    " & vbLf

    strStmt = strStmt & " WHERE  BILLTBL.BILLNO    = BILLORGTBL.BILLNO   " & vbLf

    Select Case strSortFlg
        Case "1":
            strStmt = strStmt & " ORDER BY  ORGCD1,ORGCD2,BILLCLASSCD,CLOSEDATE, " & vbLf _
                              & "           ISRSIGN,CSLORGCD1,CSLORGCD2   " & vbLf
        Case Else:
            strStmt = strStmt & " ORDER BY  BILLNO, SEQ " & vbLf
    End Select

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objBillNo = objFields("BILLNO")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objBillTitol = objFields("BILLTITLE")
        Set objBillClassCd = objFields("BILLCLASSCD")
        Set objBillClassName = objFields("BILLCLASSNAME")
        Set objOrgName = objFields("ORGNAME")
        Set objSeq = objFields("SEQ")
        Set objCslOrgCd1 = objFields("CSLORGCD1")
        Set objCslOrgCd2 = objFields("CSLORGCD2")
        Set objIsrSign = objFields("ISRSIGN")
        Set objCslOrgName = objFields("CSLORGNAME")
        Set objChargeName = objFields("CHARGENAME")
        Set objOrgBillName = objFields("ORGBILLNAME")

        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrBillTitol(lngCount)
            ReDim Preserve vntArrBillClassCd(lngCount)
            ReDim Preserve vntArrBillClassName(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrCslOrgCd1(lngCount)
            ReDim Preserve vntArrCslOrgCd2(lngCount)
            ReDim Preserve vntArrIsrSign(lngCount)
            ReDim Preserve vntArrCslOrgName(lngCount)
            ReDim Preserve vntArrChargeName(lngCount)
            ReDim Preserve vntArrOrgBillName(lngCount)
            
            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrBillTitol(lngCount) = objBillTitol.Value & ""
            vntArrBillClassCd(lngCount) = objBillClassCd.Value & ""
            vntArrBillClassName(lngCount) = objBillClassName.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrCslOrgCd1(lngCount) = objCslOrgCd1.Value & ""
            vntArrCslOrgCd2(lngCount) = objCslOrgCd2.Value & ""
            vntArrIsrSign(lngCount) = objIsrSign.Value & ""
            vntArrCslOrgName(lngCount) = objCslOrgName.Value & ""
            vntArrChargeName(lngCount) = objChargeName.Value & ""
            vntArrOrgBillName(lngCount) = objOrgBillName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        vntBillNo = vntArrBillNo
        vntOrgCd1 = vntArrOrgCd1
        vntOrgCd2 = vntArrOrgCd2
        vntCloseDate = vntArrCloseDate
        vntBillTitol = vntArrBillTitol
        vntBillClassCd = vntArrBillClassCd
        vntBillClassName = vntArrBillClassName
        vntOrgName = vntArrOrgName
        vntSeq = vntArrSeq
        vntCslOrgCd1 = vntArrCslOrgCd1
        vntCslOrgCd2 = vntArrCslOrgCd2
        vntIsrSign = vntArrIsrSign
        vntCslOrgName = vntArrCslOrgName
        vntChargeName = vntArrChargeName
        vntOrgBillName = vntArrOrgBillName

    End If

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectDemandDetailList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    SelectDemandDetailList = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectDemandList"
    
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

Public Function SelectFirstDemandList( _
                                    ByVal strSumCls As String, _
                                    ByVal strStrCloseDate As String, _
                                    ByVal strEndCloseDate As String, _
                                    ByVal strIsrOrgCd1 As String, _
                                    ByVal strIsrOrgCd2 As String, _
                                    ByVal strBillClassCd As String, _
                                    Optional ByRef vntOrgCd1 As Variant, _
                                    Optional ByRef vntOrgCd2 As Variant, _
                                    Optional ByRef vntBillClassCd As Variant, _
                                    Optional ByRef vntCloseDate As Variant, _
                                    Optional ByRef vntCslOrgCd1 As Variant, _
                                    Optional ByRef vntCslOrgCd2 As Variant, _
                                    Optional ByRef vntIsrSign As Variant, _
                                    Optional ByRef vntTotalCnt As Variant, _
                                    Optional ByRef vntSubTotal As Variant, _
                                    Optional ByRef vntTax As Variant, _
                                    Optional ByRef vntTotal As Variant, _
                                    Optional ByRef vntStrDate As Variant, _
                                    Optional ByRef vntEndDate As Variant, _
                                    Optional ByRef vntCslCnt As Variant, _
                                    Optional ByRef vntCslOrgName As Variant _
) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objBillClassCd              As OraField         '請求書分類コード
    Dim objCloseDate                As OraField         '締め日
    Dim objCslOrgCd1                As OraField         '受診団体コード１
    Dim objCslOrgCd2                As OraField         '受診団体コード２
    Dim objIsrSign                  As OraField         '健保記号
    Dim objTotalCnt                 As OraField         '人数
    Dim objSubTotal                 As OraField         '金額
    Dim objTax                      As OraField         '消費税
    Dim objTotal                    As OraField         '金額合計
    Dim objStrDate                  As OraField         '受診開始日
    Dim objEndDate                  As OraField         '受診終了日
    Dim objCslCnt                   As OraField         '受診人数
    Dim objCslOrgName               As OraField         '受診団体名称
    
    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrBillClassCd()         As Variant          '請求書分類コード
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrCslOrgCd1()           As Variant          '受診団体コード１
    Dim vntArrCslOrgCd2()           As Variant          '受診団体コード２
    Dim vntArrIsrSign()             As Variant          '健保記号
    Dim vntArrTotalCnt()            As Variant          '人数
    Dim vntArrSubTotal()            As Variant          '金額
    Dim vntArrTax()                 As Variant          '消費税
    Dim vntArrTotal()               As Variant          '金額合計
    Dim vntArrStrDate()             As Variant          '受診開始日
    Dim vntArrEndDate()             As Variant          '受診終了日
    Dim vntArrCslCnt()              As Variant          '受診人数
    Dim vntArrCslOrgName()          As Variant          '受診団体名称
    
    Dim conditionStr                As String           'SQL編集用ワーク

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期設定
    conditionStr = "  WHERE  "
    SelectFirstDemandList = 0

    If IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If IsMissing(vntBillClassCd) Then vntBillClassCd = Empty
    If IsMissing(vntCloseDate) Then vntCloseDate = Empty
    If IsMissing(vntCslOrgCd1) Then vntCslOrgCd1 = Empty
    If IsMissing(vntCslOrgCd2) Then vntCslOrgCd2 = Empty
    If IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If IsMissing(vntTotalCnt) Then vntTotalCnt = Empty
    If IsMissing(vntSubTotal) Then vntSubTotal = Empty
    If IsMissing(vntTax) Then vntTax = Empty
    If IsMissing(vntTotal) Then vntTotal = Empty
    If IsMissing(vntStrDate) Then vntStrDate = Empty
    If IsMissing(vntEndDate) Then vntEndDate = Empty
    If IsMissing(vntCslCnt) Then vntCslCnt = Empty
    If IsMissing(vntCslOrgName) Then vntCslOrgName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strStrCloseDate <> "") Then objOraParam.Add "STRCLOSEDATE", strStrCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strEndCloseDate <> "") Then objOraParam.Add "ENDCLOSEDATE", strEndCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strIsrOrgCd1 <> "") Then objOraParam.Add "ISRORGCD1", strIsrOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strIsrOrgCd2 <> "") Then objOraParam.Add "ISRORGCD2", strIsrOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strBillClassCd <> "") Then objOraParam.Add "BILLCLASSCD", strBillClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    Select Case strSumCls
        Case "1":
        
            strStmt = "  SELECT  VIEWBILL.ORGCD1,VIEWBILL.ORGCD2,VIEWBILL.BILLCLASSCD,VIEWBILL.CLOSEDATE,   " & vbLf _
                    & "          VIEWBILL.ISRSIGN,VIEWBILL.CSLORGCD1,VIEWBILL.CSLORGCD2,    " & vbLf _
                    & "          SUM(VIEWBILL.TOTALCNT) TOTALCNT,SUM(VIEWBILL.SUBTOTAL) SUBTOTAL, " & vbLf _
                    & "          SUM(VIEWBILL.TAX) TAX , SUM(VIEWBILL.TOTAL) TOTAL,     " & vbLf _
                    & "          MIN(VIEWBILL.STRDATE) STRDATE,MAX(VIEWBILL.ENDDATE) ENDDATE,SUM(VIEWBILL.CSLCNT) CSLCNT, " & vbLf _
                    & "          ( SELECT  ORGNAME FROM ORG WHERE VIEWBILL.CSLORGCD1 = ORG.ORGCD1 " & vbLf _
                    & "                                       AND VIEWBILL.CSLORGCD2 = ORG.ORGCD2 ) CSLORGNAME  " & vbLf _
                    & "    FROM   "
        Case Else:
            strStmt = "  SELECT  VIEWBILL.ORGCD1,VIEWBILL.ORGCD2,VIEWBILL.BILLCLASSCD,VIEWBILL.CLOSEDATE,   " & vbLf _
                    & "          SUM(VIEWBILL.TOTALCNT) TOTALCNT,SUM(VIEWBILL.SUBTOTAL) SUBTOTAL, " & vbLf _
                    & "          SUM(VIEWBILL.TAX) TAX , SUM(VIEWBILL.TOTAL) TOTAL,     " & vbLf _
                    & "          MIN(VIEWBILL.STRDATE) STRDATE,MAX(VIEWBILL.ENDDATE) ENDDATE,SUM(VIEWBILL.CSLCNT) CSLCNT " & vbLf _
                    & "    FROM   "
    End Select

    strStmt = strStmt & "( SELECT  BILL.ORGCD1,BILL.ORGCD2,BILL.BILLCLASSCD,TO_CHAR(BILL.CLOSEDATE ,'yyyy/mm') CLOSEDATE ,   " & vbLf _
            & "          BILL_ORG.ISRSIGN,BILL_ORG.CSLORGCD1,BILL_ORG.CSLORGCD2,    " & vbLf _
            & "          BILLDETAIL.TOTALCNT TOTALCNT,BILLDETAIL.SUBTOTAL SUBTOTAL, " & vbLf _
            & "          BILLDETAIL.TAX TAX , BILLDETAIL.TOTAL TOTAL,     " & vbLf _
            & "          BILL_COURSE.STRDATE STRDATE,BILL_COURSE.ENDDATE ENDDATE, BILL_COURSE.CSLCNT CSLCNT " & vbLf _
            & "    FROM  BILL,BILL_ORG,BILL_COURSE,BILLDETAIL " & vbLf

    If ((strStrCloseDate <> "") Or (strEndCloseDate <> "") _
        Or (strIsrOrgCd1 <> "") Or (strIsrOrgCd2 <> "") _
        Or (strBillClassCd <> "")) Then

        '健保団体１
        If (strIsrOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD1    = :ISRORGCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '健保団体２
        If (strIsrOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD2    = :ISRORGCD2     " & vbLf
            conditionStr = "  AND "
        End If

        If (strStrCloseDate <> "" And strEndCloseDate <> "") Then

            '締め日（開始日）
            If (strStrCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    >= :STRCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
            '締め日（終了日）
            If (strEndCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    <= :ENDCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
        Else
            '締め日（開始日）
            If (strStrCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    = :STRCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
            '締め日（終了日）
            If (strEndCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    = :ENDCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If

        End If

        '請求書分類コード
        If (strBillClassCd <> "") Then
            strStmt = strStmt & conditionStr & " BILL.BILLCLASSCD    = :BILLCLASSCD      " & vbLf
            conditionStr = "  AND "
        End If
    
    End If

    strStmt = strStmt & conditionStr & " BILL.BILLNO        =  BILL_ORG.BILLNO " & vbLf _
            & "  AND BILL_ORG.BILLNO    =  BILL_COURSE.BILLNO   " & vbLf _
            & "  AND BILL_ORG.SEQ       =  BILL_COURSE.SEQ      " & vbLf _
            & "  AND BILL_COURSE.BILLNO =  BILLDETAIL.BILLNO    " & vbLf _
            & "  AND BILL_COURSE.SEQ    =  BILLDETAIL.SEQ       " & vbLf _
            & "  AND BILL_COURSE.CSSEQ  =  BILLDETAIL.CSSEQ     " & vbLf

    Select Case strSumCls
        Case "1":
        
            strStmt = strStmt & " ) VIEWBILL " & vbLf _
                    & " GROUP BY  VIEWBILL.ORGCD1,VIEWBILL.ORGCD2,VIEWBILL.BILLCLASSCD,VIEWBILL.CLOSEDATE," & vbLf _
                    & "           VIEWBILL.ISRSIGN , VIEWBILL.CSLORGCD1, VIEWBILL.CSLORGCD2"
            strStmt = strStmt & " ORDER BY  VIEWBILL.ORGCD1,VIEWBILL.ORGCD2,VIEWBILL.BILLCLASSCD,VIEWBILL.CLOSEDATE," & vbLf _
                    & "           VIEWBILL.ISRSIGN , VIEWBILL.CSLORGCD1, VIEWBILL.CSLORGCD2"
        Case Else:
            strStmt = strStmt & " ) VIEWBILL " & vbLf _
                    & " GROUP BY  VIEWBILL.ORGCD1,VIEWBILL.ORGCD2,VIEWBILL.BILLCLASSCD,VIEWBILL.CLOSEDATE  " & vbLf
            strStmt = strStmt & " ORDER BY  VIEWBILL.ORGCD1,VIEWBILL.ORGCD2,VIEWBILL.BILLCLASSCD,VIEWBILL.CLOSEDATE  " & vbLf
        
    End Select

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        If (strSumCls = "1") Then
            Set objOrgCd1 = objFields("ORGCD1")
            Set objOrgCd2 = objFields("ORGCD2")
            Set objBillClassCd = objFields("BILLCLASSCD")
            Set objCloseDate = objFields("CLOSEDATE")
            Set objCslOrgCd1 = objFields("CSLORGCD1")
            Set objCslOrgCd2 = objFields("CSLORGCD2")
            Set objIsrSign = objFields("ISRSIGN")
            Set objCslOrgName = objFields("CSLORGNAME")
        End If
        
        Set objTotalCnt = objFields("TOTALCNT")
        Set objSubTotal = objFields("SUBTOTAL")
        Set objTax = objFields("TAX")
        Set objTotal = objFields("TOTAL")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objCslCnt = objFields("CSLCNT")

        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrTotalCnt(lngCount)
            ReDim Preserve vntArrSubTotal(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrTotal(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            ReDim Preserve vntArrCslCnt(lngCount)
            
            vntArrTotalCnt(lngCount) = objTotalCnt.Value & ""
            vntArrSubTotal(lngCount) = objSubTotal.Value & ""
            vntArrTax(lngCount) = objTax.Value & ""
            vntArrTotal(lngCount) = objTotal.Value & ""
            vntArrStrDate(lngCount) = objStrDate.Value & ""
            vntArrEndDate(lngCount) = objEndDate.Value & ""
            vntArrCslCnt(lngCount) = objCslCnt.Value & ""

            If (strSumCls = "1") Then
                ReDim Preserve vntArrOrgCd1(lngCount)
                ReDim Preserve vntArrOrgCd2(lngCount)
                ReDim Preserve vntArrBillClassCd(lngCount)
                ReDim Preserve vntArrCloseDate(lngCount)
                
                ReDim Preserve vntArrCslOrgCd1(lngCount)
                ReDim Preserve vntArrCslOrgCd2(lngCount)
                ReDim Preserve vntArrIsrSign(lngCount)
                ReDim Preserve vntArrCslOrgName(lngCount)
                
                vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
                vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
                vntArrBillClassCd(lngCount) = objBillClassCd.Value & ""
                vntArrCloseDate(lngCount) = objCloseDate.Value & ""
                
                vntArrCslOrgCd1(lngCount) = objCslOrgCd1.Value & ""
                vntArrCslOrgCd2(lngCount) = objCslOrgCd2.Value & ""
                vntArrIsrSign(lngCount) = objIsrSign.Value & ""
                vntArrCslOrgName(lngCount) = objCslOrgName.Value & ""
            End If
        

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        vntOrgCd1 = vntArrOrgCd1
        vntOrgCd2 = vntArrOrgCd2
        vntBillClassCd = vntArrBillClassCd
        vntCloseDate = vntArrCloseDate
        vntCslOrgCd1 = vntArrCslOrgCd1
        vntCslOrgCd2 = vntArrCslOrgCd2
        vntIsrSign = vntArrIsrSign
        vntTotalCnt = vntArrTotalCnt
        vntSubTotal = vntArrSubTotal
        vntTax = vntArrTax
        vntTotal = vntArrTotal
        vntStrDate = vntArrStrDate
        vntEndDate = vntArrEndDate
        vntCslCnt = vntArrCslCnt
        vntCslOrgName = vntArrCslOrgName

    End If

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectFirstDemandList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    SelectFirstDemandList = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectFirstDemandList"
    
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
' 機能　　 : 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
'
' 引数　　 : (In)     strSortFlg            ソートフラグ
' 　　　　   (In)     strCloseDate          締め日
' 　　　　   (In)     strIsrOrgCd1          健保団体コード１
' 　　　　   (In)     strIsrOrgCd2          健保団体コード２
' 　　　　   (In)     strOrgDiv             団体分類
' 　　　　   (In)     strOrgCd1             団体コード１
' 　　　　   (In)     strOrgCd2             団体コード２
' 　　　　   (In)     strIsrSign            健保記号
' 　　　　   (In)     strBillNo             請求書番号
' 　　　　   (In)     strBillClassCd        請求書分類コード
' 　　　　   (In)     strOtherInCome        雑収入扱い
' 　　　　   (Out)    vntBillNo             請求書番号
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntCloseDate          締め日
' 　　　　   (Out)    vntBillTitol          請求書用タイトル
' 　　　　   (Out)    vntBillClassCd        請求書分類コード
' 　　　　   (Out)    vntBillClassCd        請求書分類名
' 　　　　   (Out)    vntOrgName            団体名称
' 　　　　   (Out)    vntSeq                ＳＥＱ
' 　　　　   (Out)    vntCslOrgCd1          受診団体コード１
' 　　　　   (Out)    vntCslOrgCd2          受診団体コード２
' 　　　　   (Out)    vntIsrSign            健保記号
' 　　　　   (Out)    vntCslOrgName         受診団体名称
' 　　　　   (Out)    vntChargeName         担当者名
' 　　　　   (Out)    vntOrgBillName        団体請求名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectDemandDetailList2( _
    ByVal strSortFlg As String, ByVal strSumFlg As String, _
    ByVal strStrCloseDate As String, ByVal strEndCloseDate As String, _
    ByVal strIsrOrgCd1 As String, ByVal strIsrOrgCd2 As String, _
    ByVal strOrgDiv As String, _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    ByVal strIsrSign As String, _
    ByVal strBillNo As String, _
    ByVal strBillClassCd As String, _
    ByVal strOtherInCome As String, _
    Optional ByRef vntBillNo As Variant, _
    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntCloseDate As Variant, Optional ByRef vntBillTitol As Variant, _
    Optional ByRef vntBillClassCd As Variant, Optional ByRef vntBillClassName As Variant, _
    Optional ByRef vntOrgName As Variant, Optional ByRef vntSeq As Variant, _
    Optional ByRef vntCslOrgCd1 As Variant, Optional ByRef vntCslOrgCd2 As Variant, _
    Optional ByRef vntIsrSign As Variant, _
    Optional ByRef vntCslOrgName As Variant, _
    Optional ByRef vntChargeName As Variant, _
    Optional ByRef vntOrgBillName As Variant, _
    Optional ByRef vntPrice As Variant, Optional ByRef vntTotalCnt As Variant, _
    Optional ByRef vntSubTotal As Variant, Optional ByRef vntTax As Variant, _
    Optional ByRef vntDiscount As Variant, Optional ByRef vntTotal As Variant _
) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objBillNo                   As OraField         '請求書番号
    Dim objSeq                      As OraField         'ＳＥＱ
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objBillClassCd              As OraField         '請求書分類番号
    Dim objCloseDate                As OraField         '締め日
    Dim objOrgName                  As OraField         '団体名称
    Dim objBillClassName            As OraField         '請求書分類名称
    Dim objBillTitol                As OraField         '請求書用タイトル
    Dim objCslOrgCd1                As OraField         '受診団体コード１
    Dim objCslOrgCd2                As OraField         '受診団体コード２
    Dim objIsrSign                  As OraField         '健保記号
    Dim objCslOrgName               As OraField         '団体名称（負担元）
    Dim objChargeName               As OraField         '担当者
    Dim objOrgBillName              As OraField         '請求書用名称
    Dim objPrice                    As OraField         '単価
    Dim objTotalCnt                 As OraField         '人数
    Dim objSubTotal                 As OraField         '金額
    Dim objTax                      As OraField         '消費税
    Dim objDiscount                 As OraField         '値引き
    Dim objTotal                    As OraField         '合計

    Dim vntArrBillNo()              As Variant          '請求書番号
    Dim vntArrSeq()                 As Variant          '請求書ＳＥＱ
    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrBillClassCd()         As Variant          '請求書分類番号
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrOrgName()             As Variant          '団体名称
    Dim vntArrBillClassName()       As Variant          '請求書分類名称
    Dim vntArrBillTitol()           As Variant          '請求書用タイトル
    Dim vntArrCslOrgCd1()           As Variant          '受診団体コード１
    Dim vntArrCslOrgCd2()           As Variant          '受診団体コード２
    Dim vntArrIsrSign()             As Variant          '健保記号
    Dim vntArrCslOrgName()          As Variant          '団体名称（負担元）
    Dim vntArrChargeName()          As Variant          '担当者
    Dim vntArrOrgBillName()         As Variant          '請求書用名称
    Dim vntArrPrice()               As Variant          '単価
    Dim vntArrTotalCnt()            As Variant          '人数
    Dim vntArrSubTotal()            As Variant          '金額
    Dim vntArrTax()                 As Variant          '消費税
    Dim vntArrDiscount()            As Variant          '値引き
    Dim vntArrTotal()               As Variant          '合計

    Dim conditionStr                As String           'SQL編集用ワーク
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期設定
    conditionStr = "  WHERE  "
    SelectDemandDetailList2 = 0

    If IsMissing(vntBillNo) Then vntBillNo = Empty
    If IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If IsMissing(vntCloseDate) Then vntCloseDate = Empty
    If IsMissing(vntBillTitol) Then vntBillTitol = Empty
    If IsMissing(vntBillClassCd) Then vntBillClassCd = Empty
    If IsMissing(vntBillClassName) Then vntBillClassName = Empty
    If IsMissing(vntOrgName) Then vntOrgName = Empty
    If IsMissing(vntSeq) Then vntSeq = Empty
    If IsMissing(vntCslOrgCd1) Then vntCslOrgCd1 = Empty
    If IsMissing(vntCslOrgCd2) Then vntCslOrgCd2 = Empty
    If IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If IsMissing(vntCslOrgName) Then vntCslOrgName = Empty
    If IsMissing(vntChargeName) Then vntChargeName = Empty
    If IsMissing(vntOrgBillName) Then vntOrgBillName = Empty
    If IsMissing(vntPrice) Then vntPrice = Empty
    If IsMissing(vntTotalCnt) Then vntTotalCnt = Empty
    If IsMissing(vntSubTotal) Then vntSubTotal = Empty
    If IsMissing(vntTax) Then vntTax = Empty
    If IsMissing(vntTotal) Then vntTotal = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strStrCloseDate <> "") Then objOraParam.Add "STRCLOSEDATE", strStrCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strEndCloseDate <> "") Then objOraParam.Add "ENDCLOSEDATE", strEndCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strIsrOrgCd1 <> "") Then objOraParam.Add "ISRORGCD1", strIsrOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strIsrOrgCd2 <> "") Then objOraParam.Add "ISRORGCD2", strIsrOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgDiv <> "") Then objOraParam.Add "ORGDIV", strOrgDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd1 <> "") Then objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd2 <> "") Then objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strIsrSign <> "") Then objOraParam.Add "ISRSIGN", strIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strBillNo <> "") Then objOraParam.Add "BILLNO", strBillNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strBillClassCd <> "") Then objOraParam.Add "BILLCLASSCD", strBillClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOtherInCome <> "") Then objOraParam.Add "OTHERINCOME", strOtherInCome, ORAPARM_INPUT, ORATYPE_NUMBER

    strStmt = " SELECT  BILLTBL.BILLNO BILLNO, BILLORGTBL.SEQ SEQ " & vbLf _
            & "       , BILLTBL.ORGCD1 ORGCD1 ,BILLTBL.ORGCD2 ORGCD2 " & vbLf _
            & "       , BILLTBL.ORGNAME ORGNAME " & vbLf _
            & "       , BILLTBL.BILLCLASSCD BILLCLASSCD " & vbLf _
            & "       , BILLTBL.BILLCLASSNAME BILLCLASSNAME " & vbLf _
            & "       , BILLTBL.CLOSEDATE CLOSEDATE " & vbLf _
            & "       , BILLTBL.BILLTITLE BILLTITLE " & vbLf _
            & "       , BILLORGTBL.CSLORGCD1 CSLORGCD1, BILLORGTBL.CSLORGCD2 CSLORGCD2 " & vbLf _
            & "       , BILLORGTBL.ORGNAME CSLORGNAME " & vbLf _
            & "       , BILLORGTBL.ISRSIGN ISRSIGN " & vbLf _
            & "       , BILLORGTBL.CHARGENAME CHARGENAME, BILLORGTBL.ORGBILLNAME ORGBILLNAME " & vbLf _
            & "       , BILLDETAILTBL.PRICE,BILLDETAILTBL.TOTALCNT, BILLDETAILTBL.SUBTOTAL, BILLDETAILTBL.TAX " & vbLf _
            & "       , BILLDETAILTBL.DISCOUNT, BILLDETAILTBL.TOTAL " & vbLf _
            & "  FROM  " & vbLf

    '請求書テーブルからデータを取得
'*****  2003/02/19  EDIT  START  E.Yamamoto
'    strStmt = strStmt & " ( SELECT  BILL.BILLNO, BILL.ORGCD1, BILL.ORGCD2 " & vbLf & _
'                        "         , BILL.BILLCLASSCD,TO_CHAR(BILL.CLOSEDATE,'yyyy/mm') CLOSEDATE       " & vbLf & _
'                        "         , BILL.BILLTITLE                        " & vbLf & _
'                        "         , ORG.ORGNAME                           " & vbLf & _
'                        "         , BILLCLASS.BILLCLASSNAME                " & vbLf & _
'                        "     FROM BILL,ORG,BILLCLASS                     " & vbLf
    strStmt = strStmt & " ( SELECT  BILL.BILLNO, BILL.ORGCD1, BILL.ORGCD2 " & vbLf & _
                        "         , BILL.BILLCLASSCD,TO_CHAR(BILL.CLOSEDATE,'yyyy/mm') CLOSEDATE       " & vbLf & _
                        "         , BILLCLASS.BILLTITLE                        " & vbLf & _
                        "         , ORG.ORGNAME                           " & vbLf & _
                        "         , BILLCLASS.BILLCLASSNAME                " & vbLf & _
                        "     FROM BILL,ORG,BILLCLASS                     " & vbLf
'*****  2003/02/19  EDIT  END  E.Yamamoto

    If ((strBillNo <> "") Or (strStrCloseDate <> "") Or (strEndCloseDate <> "") _
        Or (strIsrOrgCd1 <> "") Or (strIsrOrgCd2 <> "") _
        Or (strBillClassCd <> "") Or (strOtherInCome <> "")) Then

        '請求書番号
        If (strBillNo <> "") Then
            strStmt = strStmt & conditionStr & " BILL.BILLNO    = :BILLNO      " & vbLf
            conditionStr = "  AND "
        End If

        '健保団体１
        If (strIsrOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD1    = :ISRORGCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '健保団体２
        If (strIsrOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD2    = :ISRORGCD2     " & vbLf
            conditionStr = "  AND "
        End If

        If (strStrCloseDate <> "" And strEndCloseDate <> "") Then

            '締め日（開始日）
            If (strStrCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    >= :STRCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
            '締め日（終了日）
            If (strEndCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    <= :ENDCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
        Else
            '締め日（開始日）
            If (strStrCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    = :STRCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
            '締め日（終了日）
            If (strEndCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    = :ENDCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If

        End If

        '請求書分類コード
        If (strBillClassCd <> "") Then
            strStmt = strStmt & conditionStr & " BILL.BILLCLASSCD    = :BILLCLASSCD      " & vbLf
            conditionStr = "  AND "
        End If
        
        '雑収入扱い
        If (strOtherInCome <> "") Then
            strStmt = strStmt & conditionStr & " BILLCLASS.OTHERINCOME    = :OTHERINCOME      " & vbLf
            conditionStr = "  AND "
        End If
    
    End If

    strStmt = strStmt & conditionStr & "     BILL.ORGCD1   =  ORG.ORGCD1        " & vbLf _
                      & "    AND   BILL.ORGCD2   =  ORG.ORGCD2                     " & vbLf
    If (strOrgDiv <> "") Then
         strStmt = strStmt & "    AND   ORG.ORGDIV    =  :ORGDIV              " & vbLf
     End If
     
    strStmt = strStmt & " AND   BILL.BILLCLASSCD = BILLCLASS.BILLCLASSCD        " & vbLf & _
                        " )  BILLTBL " & vbLf

    '請求書団体テーブルからデータを取得
    conditionStr = "  WHERE  "
    strStmt = strStmt & " , ( SELECT  BILL_ORG.BILLNO, BILL_ORG.SEQ, BILL_ORG.CSLORGCD1 " & vbLf & _
                        "           , BILL_ORG.CSLORGCD2,BILL_ORG.ISRSIGN               " & vbLf & _
                        "           , ORG.ORGNAME,ORG.CHARGENAME               " & vbLf & _
                        "           , ORG.ORGBILLNAME               " & vbLf & _
                        "       FROM  BILL_ORG,ORG " & vbLf


    If ((strOrgCd1 <> "") Or (strOrgCd2 <> "")) Then
        
        '団体コード１
        If (strOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL_ORG.CSLORGCD1    = :ORGCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '団体コード２
        If (strOrgCd2 <> "") Then
            strStmt = strStmt & conditionStr & " BILL_ORG.CSLORGCD2    = :ORGCD2      " & vbLf
            conditionStr = "  AND "
        End If

    End If

    strStmt = strStmt & conditionStr & "     BILL_ORG.CSLORGCD1   =  ORG.ORGCD1        " & vbLf _
                      & "    AND   BILL_ORG.CSLORGCD2   =  ORG.ORGCD2                     " & vbLf _
                      & " )  BILLORGTBL" & vbLf
    
    
    '請求書明細テーブルからデータを取得
    Select Case strSumFlg
        Case "":
            strStmt = strStmt & " , ( SELECT  BILLDETAIL.BILLNO,BILLDETAIL.SEQ    " & vbLf _
                              & "           , BILLDETAIL.PRICE,BILLDETAIL.TOTALCNT    " & vbLf _
                              & "           , BILLDETAIL.SUBTOTAL, BILLDETAIL.TAX     " & vbLf _
                              & "           , BILLDETAIL.DISCOUNT, BILLDETAIL.TOTAL   " & vbLf _
                              & "       FROM  BILLDETAIL  " & vbLf
        Case Else:
            strStmt = strStmt & " , ( SELECT  BILLDETAIL.BILLNO,BILLDETAIL.SEQ    " & vbLf _
                              & "           , SUM(BILLDETAIL.PRICE) PRICE,SUM(BILLDETAIL.TOTALCNT) TOTALCNT     " & vbLf _
                              & "           , SUM(BILLDETAIL.SUBTOTAL) SUBTOTAL, SUM(BILLDETAIL.TAX) TAX        " & vbLf _
                              & "           , SUM(BILLDETAIL.DISCOUNT) DISCOUNT, SUM(BILLDETAIL.TOTAL) TOTAL    " & vbLf _
                              & "       FROM  BILLDETAIL  " & vbLf _
                              & "      GROUP BY  BILLDETAIL.BILLNO,BILLDETAIL.SEQ  " & vbLf
    End Select
              
    strStmt = strStmt & " )  BILLDETAILTBL  " & vbLf
    
    
    '請求書関連テーブルの結合条件
    strStmt = strStmt & " WHERE  BILLTBL.BILLNO      = BILLORGTBL.BILLNO        " & vbLf _
                      & "   AND  BILLORGTBL.BILLNO   = BILLDETAILTBL.BILLNO     " & vbLf _
                      & "   AND  BILLORGTBL.SEQ      = BILLDETAILTBL.SEQ        " & vbLf

    Select Case strSortFlg
        Case "1":
            strStmt = strStmt & " ORDER BY  ORGCD1,ORGCD2,BILLCLASSCD,CLOSEDATE, " & vbLf _
                              & "           ISRSIGN,CSLORGCD1,CSLORGCD2   " & vbLf
        Case "2":
            strStmt = strStmt & " ORDER BY  CLOSEDATE, ORGCD1,ORGCD2, BILLCLASSCD  " & vbLf
        Case Else:
            strStmt = strStmt & " ORDER BY  BILLNO, SEQ  " & vbLf
    End Select

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objBillNo = objFields("BILLNO")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objBillTitol = objFields("BILLTITLE")
        Set objBillClassCd = objFields("BILLCLASSCD")
        Set objBillClassName = objFields("BILLCLASSNAME")
        Set objOrgName = objFields("ORGNAME")
        Set objSeq = objFields("SEQ")
        Set objCslOrgCd1 = objFields("CSLORGCD1")
        Set objCslOrgCd2 = objFields("CSLORGCD2")
        Set objIsrSign = objFields("ISRSIGN")
        Set objCslOrgName = objFields("CSLORGNAME")
        Set objChargeName = objFields("CHARGENAME")
        Set objOrgBillName = objFields("ORGBILLNAME")
        Set objPrice = objFields("PRICE")
        Set objTotalCnt = objFields("TOTALCNT")
        Set objSubTotal = objFields("SUBTOTAL")
        Set objTax = objFields("TAX")
        Set objDiscount = objFields("DISCOUNT")
        Set objTotal = objFields("TOTAL")

        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrBillTitol(lngCount)
            ReDim Preserve vntArrBillClassCd(lngCount)
            ReDim Preserve vntArrBillClassName(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrCslOrgCd1(lngCount)
            ReDim Preserve vntArrCslOrgCd2(lngCount)
            ReDim Preserve vntArrIsrSign(lngCount)
            ReDim Preserve vntArrCslOrgName(lngCount)
            ReDim Preserve vntArrChargeName(lngCount)
            ReDim Preserve vntArrOrgBillName(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrTotalCnt(lngCount)
            ReDim Preserve vntArrSubTotal(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrDiscount(lngCount)
            ReDim Preserve vntArrTotal(lngCount)

            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrBillTitol(lngCount) = objBillTitol.Value & ""
            vntArrBillClassCd(lngCount) = objBillClassCd.Value & ""
            vntArrBillClassName(lngCount) = objBillClassName.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrCslOrgCd1(lngCount) = objCslOrgCd1.Value & ""
            vntArrCslOrgCd2(lngCount) = objCslOrgCd2.Value & ""
            vntArrIsrSign(lngCount) = objIsrSign.Value & ""
            vntArrCslOrgName(lngCount) = objCslOrgName.Value & ""
            vntArrChargeName(lngCount) = objChargeName.Value & ""
            vntArrOrgBillName(lngCount) = objOrgBillName.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrTotalCnt(lngCount) = objTotalCnt.Value & ""
            vntArrSubTotal(lngCount) = objSubTotal.Value & ""
            vntArrTax(lngCount) = objTax.Value & ""
            vntArrDiscount(lngCount) = objDiscount.Value & ""
            vntArrTotal(lngCount) = objTotal.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        vntBillNo = vntArrBillNo
        vntOrgCd1 = vntArrOrgCd1
        vntOrgCd2 = vntArrOrgCd2
        vntCloseDate = vntArrCloseDate
        vntBillTitol = vntArrBillTitol
        vntBillClassCd = vntArrBillClassCd
        vntBillClassName = vntArrBillClassName
        vntOrgName = vntArrOrgName
        vntSeq = vntArrSeq
        vntCslOrgCd1 = vntArrCslOrgCd1
        vntCslOrgCd2 = vntArrCslOrgCd2
        vntIsrSign = vntArrIsrSign
        vntCslOrgName = vntArrCslOrgName
        vntChargeName = vntArrChargeName
        vntOrgBillName = vntArrOrgBillName
        vntPrice = vntArrPrice
        vntTotalCnt = vntArrTotalCnt
        vntSubTotal = vntArrSubTotal
        vntTax = vntArrTax
        vntDiscount = vntArrDiscount
        vntTotal = vntArrTotal

    End If

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectDemandDetailList2 = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    SelectDemandDetailList2 = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectDemandDetailList2"
    
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
' 機能　　 : 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
'
' 引数　　 : (In)     strSortFlg            ソートフラグ
' 　　　　   (In)     strCloseDate          締め日
' 　　　　   (In)     strOrgCd1          健保団体コード１
' 　　　　   (In)     strOrgCd2          健保団体コード２
' 　　　　   (In)     strOrgDiv             団体分類
' 　　　　   (In)     strOrgCd1             団体コード１
' 　　　　   (In)     strOrgCd2             団体コード２
' 　　　　   (In)     strIsrSign            健保記号
' 　　　　   (In)     strBillNo             請求書番号
' 　　　　   (In)     strBillClassCd        請求書分類コード
' 　　　　   (In)     strOtherInCome        雑収入扱い
' 　　　　   (Out)    vntBillNo             請求書番号
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntCloseDate          締め日
' 　　　　   (Out)    vntBillTitol          請求書用タイトル
' 　　　　   (Out)    vntBillClassCd        請求書分類コード
' 　　　　   (Out)    vntBillClassCd        請求書分類名
' 　　　　   (Out)    vntOrgName            団体名称
' 　　　　   (Out)    vntSeq                ＳＥＱ
' 　　　　   (Out)    vntCslOrgCd1          受診団体コード１
' 　　　　   (Out)    vntCslOrgCd2          受診団体コード２
' 　　　　   (Out)    vntIsrSign            健保記号
' 　　　　   (Out)    vntCslOrgName         受診団体名称
' 　　　　   (Out)    vntChargeName         担当者名
' 　　　　   (Out)    vntOrgBillName        団体請求名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectBsdDemandList( _
    ByVal strSumFlg As String, _
    ByVal strStrCloseDate As String, ByVal strEndCloseDate As String, _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    ByVal strOtherInCome As String, _
    ByVal strCsCd As Variant, _
    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntCloseDate As Variant, Optional ByRef vntBillTitol As Variant, _
    Optional ByRef vntOtherInCome As Variant, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntStrDate As Variant, Optional ByRef vntEndDate As Variant, _
    Optional ByRef vntCsName As Variant, Optional ByRef vntCslCnt As Variant, _
    Optional ByRef vntPrice As Variant, _
    Optional ByRef vntSubTotal As Variant, Optional ByRef vntTax As Variant, _
    Optional ByRef vntDiscount As Variant, Optional ByRef vntTotal As Variant _
) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objCloseDate                As OraField         '締め日
    Dim objOrgName                  As OraField         '団体名称
    Dim objOtherInCome              As OraField         '雑収入扱い
    Dim objBillTitol                As OraField         '請求書用タイトル
    Dim objCsCd                     As OraField         'コースコード
    Dim objStrDate                  As OraField         '開始年月日
    Dim objEndDate                  As OraField         '終了年月日
    Dim objCsName                   As OraField         'コース名
    Dim objPrice                    As OraField         '単価
    Dim objCslCnt                   As OraField         '人数
    Dim objSubTotal                 As OraField         '金額
    Dim objTax                      As OraField         '消費税
    Dim objDiscount                 As OraField         '値引き
    Dim objTotal                    As OraField         '合計

    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrOrgName()             As Variant          '団体名称
    Dim vntArrOtherInCome()         As Variant          '雑収入扱い
    Dim vntArrBillTitol()           As Variant          '請求書用タイトル
    Dim vntArrCsCd()                As Variant          'コースコード
    Dim vntArrStrDate()             As Variant          '開始年月日
    Dim vntArrEndDate()             As Variant          '終了年月日
    Dim vntArrCsName()              As Variant          'コース名
    Dim vntArrCslCnt()              As Variant          '人数
    Dim vntArrPrice()               As Variant          '単価
    Dim vntArrSubTotal()            As Variant          '金額
    Dim vntArrTax()                 As Variant          '消費税
    Dim vntArrDiscount()            As Variant          '値引き
    Dim vntArrTotal()               As Variant          '合計

    Dim conditionStr                As String           'SQL編集用ワーク
    Dim i                           As Long             'ループカウント
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期設定
    conditionStr = "  WHERE  "
    SelectBsdDemandList = 0

    If IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If IsMissing(vntCloseDate) Then vntCloseDate = Empty
    If IsMissing(vntBillTitol) Then vntBillTitol = Empty
    If IsMissing(vntOtherInCome) Then vntOtherInCome = Empty
    If IsMissing(vntOrgName) Then vntOrgName = Empty
    If IsMissing(vntCsCd) Then vntCsCd = Empty
    If IsMissing(vntStrDate) Then vntStrDate = Empty
    If IsMissing(vntEndDate) Then vntEndDate = Empty
    If IsMissing(vntCsName) Then vntCsName = Empty
    If IsMissing(vntPrice) Then vntPrice = Empty
    If IsMissing(vntCslCnt) Then vntCslCnt = Empty
    If IsMissing(vntSubTotal) Then vntSubTotal = Empty
    If IsMissing(vntTax) Then vntTax = Empty
    If IsMissing(vntTotal) Then vntTotal = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strStrCloseDate <> "") Then objOraParam.Add "STRCLOSEDATE", strStrCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strEndCloseDate <> "") Then objOraParam.Add "ENDCLOSEDATE", strEndCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strOrgCd1 <> "") Then objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd2 <> "") Then objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOtherInCome <> "") Then objOraParam.Add "OTHERINCOME", strOtherInCome, ORAPARM_INPUT, ORATYPE_NUMBER

    If (strSumFlg = "") Then
'*****  2003/02/19  EDIT  START  E.Yamamoto
'        strStmt = " SELECT  TO_CHAR(BILL.CLOSEDATE,'yyyy/mm') CLOSEDATE " & vbLf _
'                & "       , BILL.ORGCD1 ORGCD1, BILL.ORGCD2 ORGCD2 " & vbLf _
'                & "       , BILLCLASS.OTHERINCOME OTHERINCOME " & vbLf _
'                & "       , BILL.BILLTITLE BILLTITLE, BILL_COURSE.CSCD CSCD " & vbLf _
'                & "       , COURSE_P.CSNAME CSNAME " & vbLf _
'                & "       , BILL_COURSE.CSLCNT CSLCNT, BILL_COURSE.STRDATE STRDATE " & vbLf _
'                & "       , BILL_COURSE.ENDDATE ENDDATE, SUM(BILLDETAIL.PRICE) PRICE " & vbLf _
'                & "       , SUM(BILLDETAIL.TOTALCNT) TOTALCNT, SUM(BILLDETAIL.SUBTOTAL) SUBTOTAL " & vbLf _
'                & "       , SUM(BILLDETAIL.TAX) TAX, SUM(BILLDETAIL.DISCOUNT) DISCOUNT " & vbLf _
'                & "       , SUM(BILLDETAIL.TOTAL) TOTAL " & vbLf _
'                & "       , ( SELECT  ORGNAME  FROM  ORG  WHERE BILL.ORGCD1 = ORG.ORGCD1 AND BILL.ORGCD2 = ORG.ORGCD2 ) ORGNAME " & vbLf _
'                & "  FROM BILL, BILL_COURSE, BILLCLASS, BILLDETAIL,COURSE_P  " & vbLf
        strStmt = " SELECT  TO_CHAR(BILL.CLOSEDATE,'yyyy/mm') CLOSEDATE " & vbLf _
                & "       , BILL.ORGCD1 ORGCD1, BILL.ORGCD2 ORGCD2 " & vbLf _
                & "       , BILLCLASS.OTHERINCOME OTHERINCOME " & vbLf _
                & "       , BILLCLASS.BILLTITLE BILLTITLE, BILL_COURSE.CSCD CSCD " & vbLf _
                & "       , COURSE_P.CSNAME CSNAME " & vbLf _
                & "       , BILL_COURSE.CSLCNT CSLCNT, BILL_COURSE.STRDATE STRDATE " & vbLf _
                & "       , BILL_COURSE.ENDDATE ENDDATE, SUM(BILLDETAIL.PRICE) PRICE " & vbLf _
                & "       , SUM(BILLDETAIL.TOTALCNT) TOTALCNT, SUM(BILLDETAIL.SUBTOTAL) SUBTOTAL " & vbLf _
                & "       , SUM(BILLDETAIL.TAX) TAX, SUM(BILLDETAIL.DISCOUNT) DISCOUNT " & vbLf _
                & "       , SUM(BILLDETAIL.TOTAL) TOTAL " & vbLf _
                & "       , ( SELECT  ORGNAME  FROM  ORG  WHERE BILL.ORGCD1 = ORG.ORGCD1 AND BILL.ORGCD2 = ORG.ORGCD2 ) ORGNAME " & vbLf _
                & "  FROM BILL, BILL_COURSE, BILLCLASS, BILLDETAIL,COURSE_P  " & vbLf
'*****  2003/02/19  EDIT  END    E.Yamamoto
    Else
        strStmt = " SELECT  TO_CHAR(BILL.CLOSEDATE,'yyyy/mm') CLOSEDATE " & vbLf _
                & "       , BILL.ORGCD1 ORGCD1, BILL.ORGCD2 ORGCD2 " & vbLf _
                & "       , BILL_COURSE.CSCD CSCD " & vbLf _
                & "       , COURSE_P.CSNAME CSNAME " & vbLf _
                & "       , SUM(BILL_COURSE.CSLCNT) CSLCNT " & vbLf _
                & "       , SUM(BILLDETAIL.PRICE) PRICE " & vbLf _
                & "       , SUM(BILLDETAIL.TOTALCNT) TOTALCNT, SUM(BILLDETAIL.SUBTOTAL) SUBTOTAL " & vbLf _
                & "       , SUM(BILLDETAIL.TAX) TAX, SUM(BILLDETAIL.DISCOUNT) DISCOUNT " & vbLf _
                & "       , SUM(BILLDETAIL.TOTAL) TOTAL " & vbLf _
                & "       , ( SELECT  ORGNAME  FROM  ORG  WHERE BILL.ORGCD1 = ORG.ORGCD1 AND BILL.ORGCD2 = ORG.ORGCD2 ) ORGNAME " & vbLf _
                & "  FROM BILL, BILL_COURSE, BILLCLASS, BILLDETAIL,COURSE_P  " & vbLf
    End If

    If ((strStrCloseDate <> "") Or (strEndCloseDate <> "") _
        Or (strOrgCd1 <> "") Or (strOrgCd2 <> "") Or (strOtherInCome <> "")) Then

        '団体１
        If (strOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD1    = :ORGCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '団体２
        If (strOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD2    = :ORGCD2     " & vbLf
            conditionStr = "  AND "
        End If

        If (strStrCloseDate <> "" And strEndCloseDate <> "") Then

            '締め日（開始日）
            If (strStrCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    >= :STRCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
            '締め日（終了日）
            If (strEndCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    <= :ENDCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
        Else
            '締め日（開始日）
            If (strStrCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    = :STRCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If
            '締め日（終了日）
            If (strEndCloseDate <> "") Then
                strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    = :ENDCLOSEDATE      " & vbLf
                conditionStr = "  AND "
            End If

        End If

        '雑収入扱い
        If (strOtherInCome <> "") Then
            strStmt = strStmt & conditionStr & " BILLCLASS.OTHERINCOME    = :OTHERINCOME      " & vbLf
            conditionStr = "  AND "
        End If
    
    End If

    'コースコード条件設定
    If (Not IsEmpty(strCsCd)) Then
        If (IsArray(strCsCd)) Then
            strStmt = strStmt & conditionStr & "  ( BILL_COURSE.CSCD = '" & strCsCd(0) & "' " & vbLf
            conditionStr = "    AND  "
            For i = 1 To UBound(strCsCd)
                If (strCsCd(i) <> "") Then
                    strStmt = strStmt & "    OR  BILL_COURSE.CSCD = '" & strCsCd(i) & "' " & vbLf
                End If
            Next i
            strStmt = strStmt & " ) " & vbLf
        Else
            If (strCsCd <> "") Then
                strStmt = strStmt & conditionStr & "  BILL_COURSE.CSCD = '" & strCsCd & "' " & vbLf
                conditionStr = "    AND  "
            End If
        End If
    End If


    '請求書関連テーブルＪＯＩＮ条件の設定
    strStmt = strStmt & conditionStr & " Bill.BILLNO = BILL_COURSE.BILLNO " & vbLf _
                      & " AND  BILL_COURSE.BILLNO = BILLDETAIL.BILLNO " & vbLf _
                      & " AND  BILL_COURSE.SEQ    = BILLDETAIL.SEQ " & vbLf _
                      & " AND  BILL_COURSE.CSSEQ  = BILLDETAIL.CSSEQ " & vbLf _
                      & " AND  BILL.BILLCLASSCD   = BILLCLASS.BILLCLASSCD " & vbLf _
                      & " AND  BILL_COURSE.CSCD   = COURSE_P.CSCD " & vbLf

    If (strSumFlg = "") Then
'*****  2003/02/19  EDIT  START  E.Yamamoto
'        strStmt = strStmt & " GROUP BY BILL.CLOSEDATE, BILL.ORGCD1, BILL.ORGCD2 " & vbLf _
'                          & " , BILLCLASS.OTHERINCOME , BILL.BILLTITLE, BILL_COURSE.CSCD,COURSE_P.CSNAME " & vbLf _
'                          & " , BILL_COURSE.CSLCNT, BILL_COURSE.STRDATE , BILL_COURSE.ENDDATE " & vbLf _
'                          & " ORDER BY  CLOSEDATE, ORGCD1,ORGCD2, CSCD  " & vbLf
        strStmt = strStmt & " GROUP BY BILL.CLOSEDATE, BILL.ORGCD1, BILL.ORGCD2 " & vbLf _
                          & " , BILLCLASS.OTHERINCOME , BILLCLASS.BILLTITLE, BILL_COURSE.CSCD,COURSE_P.CSNAME " & vbLf _
                          & " , BILL_COURSE.CSLCNT, BILL_COURSE.STRDATE , BILL_COURSE.ENDDATE " & vbLf _
                          & " ORDER BY  CLOSEDATE, ORGCD1,ORGCD2, CSCD  " & vbLf
'*****  2003/02/19  EDIT  END    E.Yamamoto
    Else
        strStmt = strStmt & " GROUP BY BILL.CLOSEDATE, BILL.ORGCD1, BILL.ORGCD2 " & vbLf _
                          & " , BILL_COURSE.CSCD,COURSE_P.CSNAME " & vbLf _
                          & " ORDER BY  CLOSEDATE, ORGCD1,ORGCD2, CSCD  " & vbLf
    End If

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objOrgName = objFields("ORGNAME")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objPrice = objFields("PRICE")
        Set objCslCnt = objFields("CSLCNT")
        Set objSubTotal = objFields("SUBTOTAL")
        Set objTax = objFields("TAX")
        Set objDiscount = objFields("DISCOUNT")
        Set objTotal = objFields("TOTAL")
        
        If (strSumFlg = "") Then
            Set objBillTitol = objFields("BILLTITLE")
            Set objOtherInCome = objFields("OTHERINCOME")
            Set objStrDate = objFields("STRDATE")
            Set objEndDate = objFields("ENDDATE")
        End If
        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrCslCnt(lngCount)
            ReDim Preserve vntArrSubTotal(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrDiscount(lngCount)
            ReDim Preserve vntArrTotal(lngCount)
            
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrCslCnt(lngCount) = objCslCnt.Value & ""
            vntArrSubTotal(lngCount) = objSubTotal.Value & ""
            vntArrTax(lngCount) = objTax.Value & ""
            vntArrDiscount(lngCount) = objDiscount.Value & ""
            vntArrTotal(lngCount) = objTotal.Value & ""

            If (strSumFlg = "") Then
                ReDim Preserve vntArrBillTitol(lngCount)
                ReDim Preserve vntArrOtherInCome(lngCount)
                ReDim Preserve vntArrStrDate(lngCount)
                ReDim Preserve vntArrEndDate(lngCount)
                
                vntArrBillTitol(lngCount) = objBillTitol.Value & ""
                vntArrOtherInCome(lngCount) = objOtherInCome.Value & ""
                vntArrStrDate(lngCount) = objStrDate.Value & ""
                vntArrEndDate(lngCount) = objEndDate.Value & ""
            End If
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        vntOrgCd1 = vntArrOrgCd1
        vntOrgCd2 = vntArrOrgCd2
        vntCloseDate = vntArrCloseDate
        vntBillTitol = vntArrBillTitol
        vntOtherInCome = vntArrOtherInCome
        vntOrgName = vntArrOrgName
        vntCsCd = vntArrCsCd
        vntStrDate = vntArrStrDate
        vntEndDate = vntArrEndDate
        vntCsName = vntArrCsName
        vntPrice = vntArrPrice
        vntCslCnt = vntArrCslCnt
        vntSubTotal = vntArrSubTotal
        vntTax = vntArrTax
        vntDiscount = vntArrDiscount
        vntTotal = vntArrTotal

    End If

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectBsdDemandList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    SelectBsdDemandList = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectBsdDemandList"
    
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
' 機能　　 : 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
'
' 引数　　 : (In)     strCloseDate          締め日
' 　　　　   (In)     strOrgCd1             団体コード１
' 　　　　   (In)     strOrgCd2             団体コード２
' 　　　　   (In)     strOrgBsdCd           事業所コード
' 　　　　   (In)     strOrgRoomCd          室部コード
' 　　　　   (In)     strOrgPostCd1         所属コード１
' 　　　　   (In)     strOrgPostCd2         所属コード２
' 　　　　   (In)     strPerId              個人ＩＤ
' 　　　　   (In)     strCsCd               コースコード
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntCloseDate          締め日
' 　　　　   (Out)    vntRsvNo              予約番号
' 　　　　   (Out)    vntCsCd               コースコード
' 　　　　   (Out)    vntEmpNo              従業員番号
' 　　　　   (Out)    vntCslDate            受診日
' 　　　　   (Out)    vntOrgBsdName         所属名
' 　　　　   (Out)    vntPrice              金額
' 　　　　   (Out)    vntEditPrice          調整金額
' 　　　　   (Out)    vntTaxPrice           消費税
' 　　　　   (Out)    vntEditTax            調整消費税
' 　　　　   (Out)    vntOrgName            団体名称
' 　　　　   (Out)    vntCsName             コース名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectPostDemandList( _
    ByVal strMode As String, _
    ByVal strStrCloseDate As String, ByVal strEndCloseDate As String, _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    ByVal strOrgBsdCd As String, _
    ByVal strOrgRoomCd As String, _
    ByVal strOrgPostCd1 As String, _
    ByVal strOrgPostCd2 As String, _
    ByVal strBillClassCd As String, _
    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntCloseDate As Variant, Optional ByRef vntOrgPostCd As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntMinCslDate As Variant, Optional ByRef vntMaxCslDate As Variant, _
    Optional ByRef vntPrice As Variant, Optional ByRef vntEditPrice As Variant, _
    Optional ByRef vntTaxPrice As Variant, Optional ByRef vntEditTax As Variant, _
    Optional ByRef vntTotalCnt As Variant, Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntOrgPostName As Variant, Optional ByRef vntCsName As Variant _
) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objCloseDate                As OraField         '締め日
    Dim objOrgPostCd                As OraField         '所属コード
    Dim objCsCd                     As OraField         'コースコード
    Dim objMinCslDate               As OraField         '受診日（最小値）
    Dim objMaxCslDate               As OraField         '受診日（最大値）
    Dim objPrice                    As OraField         '金額
    Dim objEditPrice                As OraField         '調整金額
    Dim objTaxPrice                 As OraField         '消費税
    Dim objEditTax                  As OraField         '調整消費税
    Dim objTotalCnt                 As OraField         '受診人数
    Dim objOrgName                  As OraField         '団体名
    Dim objOrgPostName              As OraField         '所属名
    Dim objCsName                   As OraField         'コース名

    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrOrgPostCd()           As Variant          '所属コード
    Dim vntArrCsCd()                As Variant          'コースコード
    Dim vntArrMinCslDate()          As Variant          '受診日（最小値）
    Dim vntArrMaxCslDate()          As Variant          '受診日（最大値）
    Dim vntArrPrice()               As Variant          '金額
    Dim vntArrEditPrice()           As Variant          '調整金額
    Dim vntArrTaxPrice()            As Variant          '消費税
    Dim vntArrEditTax()             As Variant          '調整消費税
    Dim vntArrTotalCnt()            As Variant          '受診人数
    Dim vntArrOrgName()             As Variant          '団体名
    Dim vntArrOrgPostName()         As Variant          '所属名
    Dim vntArrCsName()              As Variant          'コース名

    Dim conditionStr                As String           'SQL編集用ワーク
    Dim i                           As Long             'ループカウント
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期設定
    conditionStr = "  WHERE  "
    SelectPostDemandList = 0

    If IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If IsMissing(vntCloseDate) Then vntCloseDate = Empty
    If IsMissing(vntOrgPostCd) Then vntOrgPostCd = Empty
    If IsMissing(vntCsCd) Then vntCsCd = Empty
    If IsMissing(vntMinCslDate) Then vntMinCslDate = Empty
    If IsMissing(vntMaxCslDate) Then vntMaxCslDate = Empty
    If IsMissing(vntPrice) Then vntPrice = Empty
    If IsMissing(vntEditPrice) Then vntEditPrice = Empty
    If IsMissing(vntTaxPrice) Then vntTaxPrice = Empty
    If IsMissing(vntEditTax) Then vntEditTax = Empty
    If IsMissing(vntOrgName) Then vntOrgName = Empty
    If IsMissing(vntOrgPostName) Then vntOrgPostName = Empty
    If IsMissing(vntCsName) Then vntCsName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strStrCloseDate <> "") Then objOraParam.Add "STRCLOSEDATE", strStrCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strEndCloseDate <> "") Then objOraParam.Add "ENDCLOSEDATE", strEndCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strOrgCd1 <> "") Then objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd2 <> "") Then objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgBsdCd <> "") Then objOraParam.Add "ORGBSDCD", strOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgRoomCd <> "") Then objOraParam.Add "ORGROOMCD", strOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgPostCd1 <> "") Then objOraParam.Add "ORGPOSTCD1", strOrgPostCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgPostCd2 <> "") Then objOraParam.Add "ORGPOSTCD2", strOrgPostCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strBillClassCd <> "") Then objOraParam.Add "BILLCLASSCD", strBillClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2


    If (strMode <> "SUM") Then
        strStmt = " SELECT  BILL.ORGCD1 ORGCD1                  " & vbLf _
                & "       , BILL.ORGCD2 ORGCD2                  " & vbLf _
                & "       , TO_CHAR( BILL.CLOSEDATE ,'yyyy/mm')  CLOSEDATE       " & vbLf _
                & "       , CONSULT.ORGBSDCD ORGBSDCD           " & vbLf _
                & "       , CONSULT.ORGROOMCD ORGROOMCD         " & vbLf _
                & "       , CONSULT.ORGPOSTCD ORGPOSTCD         " & vbLf _
                & "       , CLOSEMNG.CSCD CSCD         " & vbLf _
                & "       , MIN(CONSULT.CSLDATE) MINCSLDATE  " & vbLf _
                & "       , MAX(CONSULT.CSLDATE) MAXCSLDATE  " & vbLf _
                & "       , SUM(CONSULT_M.PRICE) PRICE             " & vbLf _
                & "       , SUM(CONSULT_M.EDITPRICE) EDITPRICE     " & vbLf _
                & "       , SUM(CONSULT_M.TAXPRICE) TAXPRICE         " & vbLf _
                & "       , SUM(CONSULT_M.EDITTAX) EDITTAX         " & vbLf _
                & "       , COUNT(DISTINCT CONSULT.RSVNO)  TOTALCNT      " & vbLf _
                & "       , ( SELECT ORGNAME FROM ORG WHERE ORG.ORGCD1 = BILL.ORGCD1  AND  ORG.ORGCD2 = BILL.ORGCD2 ) ORGNAME    " & vbLf _
                & "       , ( SELECT ORGPOSTNAME FROM ORGPOST  WHERE ORGPOST.ORGCD1 = BILL.ORGCD1 AND ORGPOST.ORGCD2 = BILL.ORGCD2 " _
                & "              AND ORGPOST.ORGBSDCD = CONSULT.ORGBSDCD AND  ORGPOST.ORGROOMCD = CONSULT.ORGROOMCD           " _
                & "              AND ORGPOST.ORGPOSTCD = CONSULT.ORGPOSTCD ) ORGPOSTNAME    " & vbLf _
                & "       , ( SELECT CSNAME FROM COURSE_P WHERE COURSE_P.CSCD = CLOSEMNG.CSCD ) CSNAME " & vbLf _
                & "   FROM  BILL, CONSULT, CONSULT_M, CLOSEMNG   " & vbLf
    Else
        strStmt = " SELECT  BILL.ORGCD1 ORGCD1                  " & vbLf _
                & "       , BILL.ORGCD2 ORGCD2                  " & vbLf _
                & "       , TO_CHAR( BILL.CLOSEDATE ,'yyyy/mm')  CLOSEDATE " & vbLf _
                & "       , CLOSEMNG.CSCD CSCD         " & vbLf _
                & "       , SUM(CONSULT_M.PRICE) PRICE             " & vbLf _
                & "       , SUM(CONSULT_M.EDITPRICE) EDITPRICE     " & vbLf _
                & "       , SUM(CONSULT_M.TAXPRICE) TAXPRICE         " & vbLf _
                & "       , SUM(CONSULT_M.EDITTAX) EDITTAX         " & vbLf _
                & "       , COUNT(DISTINCT CONSULT.RSVNO)  TOTALCNT      " & vbLf _
                & "       , ( SELECT CSNAME FROM COURSE_P WHERE COURSE_P.CSCD = CLOSEMNG.CSCD ) CSNAME " & vbLf _
                & "   FROM  BILL, CONSULT, CONSULT_M, CLOSEMNG   " & vbLf
    
    End If

    '請求書テーブルからデータを取得
    If ((strStrCloseDate <> "") Or (strEndCloseDate <> "") _
        Or (strOrgCd1 <> "") Or (strOrgCd2 <> "") Or (strBillClassCd <> "") _
        Or (strOrgBsdCd <> "") Or (strOrgRoomCd <> "") _
        Or (strOrgPostCd1 <> "") Or (strOrgPostCd2 <> "")) Then

        '団体１
        If (strOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD1    = :ORGCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '団体２
        If (strOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD2    = :ORGCD2     " & vbLf
            conditionStr = "  AND "
        End If

        '締め日（開始日）
        If (strStrCloseDate <> "") Then
            strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    >= :STRCLOSEDATE      " & vbLf
            conditionStr = "  AND "
        End If
        '締め日（終了日）
        If (strEndCloseDate <> "") Then
            strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    <= :ENDCLOSEDATE      " & vbLf
            conditionStr = "  AND "
        End If
        
        '請求書分類コード
        If (strBillClassCd <> "") Then
            strStmt = strStmt & conditionStr & " BILL.BILLCLASSCD    = :BILLCLASSCD     " & vbLf
            conditionStr = "  AND "
        End If

        '事業所コード
        If (strOrgBsdCd <> "") Then
            strStmt = strStmt & conditionStr & " CONSULT.ORGBSDCD    = :ORGBSDCD   " & vbLf
            conditionStr = "  AND "
        End If

        '室部
        If (strOrgRoomCd <> "") Then
            strStmt = strStmt & conditionStr & " CONSULT.ORGROOMCD    = :ORGROOMCD " & vbLf
            conditionStr = "  AND "
        End If


        '所属１
        If (strOrgPostCd1 <> "") Then
            strStmt = strStmt & conditionStr & " CONSULT.ORGPOSTCD    >= :ORGPOSTCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '所属２
        If (strOrgPostCd2 <> "") Then
            strStmt = strStmt & conditionStr & " CONSULT.ORGPOSTCD    <= :ORGPOSTCD2      " & vbLf
            conditionStr = "  AND "
        End If

    End If

    strStmt = strStmt & conditionStr & " BILL.BILLNO       = CLOSEMNG.BILLNO    " & vbLf _
                      & "   AND  BILL.ORGCD1       = CONSULT.ORGCD1     " & vbLf _
                      & "   AND  BILL.ORGCD2       = CONSULT.ORGCD2     " & vbLf _
                      & "   AND  CONSULT.RSVNO     = CONSULT_M.RSVNO    " & vbLf _
                      & "   AND  CONSULT.CSCD      = CONSULT_M.CSCD     " & vbLf _
                      & "   AND  CONSULT.RSVNO     = CLOSEMNG.RSVNO     " & vbLf _
                      & "   AND  CONSULT.ORGCD1    = CLOSEMNG.ORGCD1    " & vbLf _
                      & "   AND  CONSULT.ORGCD2    = CLOSEMNG.ORGCD2    " & vbLf _
                      & "   AND  CONSULT.CSCD      = CLOSEMNG.CSCD      " & vbLf
    
    If (strMode <> "SUM") Then
        strStmt = strStmt & " GROUP BY BILL.ORGCD1, BILL.ORGCD2, BILL.CLOSEDATE, CONSULT.ORGBSDCD, CONSULT.ORGROOMCD, CONSULT.ORGPOSTCD, CLOSEMNG.CSCD " _
                          & " ORDER BY BILL.ORGCD1, BILL.ORGCD2, BILL.CLOSEDATE, CONSULT.ORGBSDCD, CONSULT.ORGROOMCD, CONSULT.ORGPOSTCD, CLOSEMNG.CSCD "
    Else
        strStmt = strStmt & " GROUP BY BILL.ORGCD1, BILL.ORGCD2, BILL.CLOSEDATE, CLOSEMNG.CSCD " _
                          & " ORDER BY BILL.ORGCD1, BILL.ORGCD2, BILL.CLOSEDATE, CLOSEMNG.CSCD "
    End If

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objCsCd = objFields("CSCD")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITTAX")
        Set objTotalCnt = objFields("TOTALCNT")
        Set objCsName = objFields("CSNAME")

        If (strMode <> "SUM") Then
            Set objOrgPostCd = objFields("ORGPOSTCD")
            Set objMinCslDate = objFields("MINCSLDATE")
            Set objMaxCslDate = objFields("MAXCSLDATE")
            Set objOrgName = objFields("ORGNAME")
            Set objOrgPostName = objFields("ORGPOSTNAME")
        End If
        
        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrTotalCnt(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrEditPrice(lngCount) = objEditPrice.Value & ""
            vntArrTaxPrice(lngCount) = objTaxPrice.Value & ""
            vntArrEditTax(lngCount) = objEditTax.Value & ""
            vntArrTotalCnt(lngCount) = objTotalCnt.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""

            If (strMode <> "SUM") Then
                ReDim Preserve vntArrOrgPostCd(lngCount)
                ReDim Preserve vntArrMinCslDate(lngCount)
                ReDim Preserve vntArrMaxCslDate(lngCount)
                ReDim Preserve vntArrOrgName(lngCount)
                ReDim Preserve vntArrOrgPostName(lngCount)
                
                vntArrOrgPostCd(lngCount) = objOrgPostCd.Value & ""
                vntArrMinCslDate(lngCount) = objMinCslDate.Value & ""
                vntArrMaxCslDate(lngCount) = objMaxCslDate.Value & ""
                vntArrOrgName(lngCount) = objOrgName.Value & ""
                vntArrOrgPostName(lngCount) = objOrgPostName.Value & ""
                
            End If

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        vntOrgCd1 = vntArrOrgCd1
        vntOrgCd2 = vntArrOrgCd2
        vntCloseDate = vntArrCloseDate
        vntOrgPostCd = vntArrOrgPostCd
        vntCsCd = vntArrCsCd
        vntMinCslDate = vntArrMinCslDate
        vntMaxCslDate = vntArrMaxCslDate
        vntPrice = vntArrPrice
        vntEditPrice = vntArrEditPrice
        vntTaxPrice = vntArrTaxPrice
        vntEditTax = vntArrEditTax
        vntTotalCnt = vntArrTotalCnt
        vntOrgName = vntArrOrgName
        vntOrgPostName = vntArrOrgPostName
        vntCsName = vntArrCsName

    End If

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectPostDemandList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    SelectPostDemandList = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectPostDemandList"
    
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
' 機能　　 : 入力条件に合致する請求書，請求書団体管理テーブルのデータを取得する
'
' 引数　　 : (In)     strCloseDate          締め日
' 　　　　   (In)     strOrgCd1             団体コード１
' 　　　　   (In)     strOrgCd2             団体コード２
' 　　　　   (In)     strOrgBsdCd           事業所コード
' 　　　　   (In)     strOrgRoomCd          室部コード
' 　　　　   (In)     strOrgPostCd1         所属コード１
' 　　　　   (In)     strOrgPostCd2         所属コード２
' 　　　　   (In)     strPerId              個人ＩＤ
' 　　　　   (In)     strCsCd               コースコード
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntCloseDate          締め日
' 　　　　   (Out)    vntRsvNo              予約番号
' 　　　　   (Out)    vntCsCd               コースコード
' 　　　　   (Out)    vntEmpNo              従業員番号
' 　　　　   (Out)    vntCslDate            受診日
' 　　　　   (Out)    vntOrgBsdName         所属名
' 　　　　   (Out)    vntPrice              金額
' 　　　　   (Out)    vntEditPrice          調整金額
' 　　　　   (Out)    vntTaxPrice           消費税
' 　　　　   (Out)    vntEditTax            調整消費税
' 　　　　   (Out)    vntOrgName            団体名称
' 　　　　   (Out)    vntCsName             コース名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectPersonDemandList( _
    ByVal strStrCloseDate As String, ByVal strEndCloseDate As String, _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    ByVal strPerId As String, _
    ByVal strCsCd As Variant, _
    ByRef vntOrgCd1 As Variant, ByRef vntOrgCd2 As Variant, _
    ByRef vntCloseDate As Variant, ByRef vntRsvNo As Variant, _
    ByRef vntCsCd As Variant, ByRef vntEmpNo As Variant, _
    ByRef vntIsrSign As Variant, ByRef vntIsrNo As Variant, _
    ByRef vntCslDate As Variant, ByRef vntOrgPostCd As Variant, _
    ByRef vntOrgPostName As Variant, _
    ByRef vntPrice As Variant, ByRef vntEditPrice As Variant, _
    ByRef vntTaxPrice As Variant, ByRef vntEditTax As Variant, _
    ByRef vntOrgName As Variant, ByRef vntCsName As Variant, _
    ByRef vntLastName As Variant, ByRef vntFirstName As Variant _
) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objCloseDate                As OraField         '締め日
    Dim objRsvNo                    As OraField         '予約番号
    Dim objCsCd                     As OraField         'コースコード
    Dim objEmpNo                    As OraField         '従業員番号
    Dim objIsrSign                  As OraField         '健保記号
    Dim objIsrNo                    As OraField         '健保番号
    Dim objCslDate                  As OraField         '受診日
    Dim objOrgPostCd                As OraField         '所属コード
    Dim objOrgPostName              As OraField         '所属名
    Dim objPrice                    As OraField         '金額
    Dim objEditPrice                As OraField         '調整金額
    Dim objTaxPrice                 As OraField         '消費税
    Dim objEditTax                  As OraField         '調整消費税
    Dim objOrgName                  As OraField         '団体名
    Dim objCsName                   As OraField         'コース名
    Dim objLastName                 As OraField         '名
    Dim objFirstName                As OraField         '姓

    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrRsvNo()               As Variant          '予約番号
    Dim vntArrCsCd()                As Variant          'コースコード
    Dim vntArrEmpNo()               As Variant          '従業員番号
    Dim vntArrIsrSign()             As Variant          '健保記号
    Dim vntArrIsrNo()               As Variant          '健保番号
    Dim vntArrCslDate()             As Variant          '受診日
    Dim vntArrOrgPostCd()           As Variant          '所属コード
    Dim vntArrOrgPostName()         As Variant          '所属名
    Dim vntArrPrice()               As Variant          '金額
    Dim vntArrEditPrice()           As Variant          '調整金額
    Dim vntArrTaxPrice()            As Variant          '消費税
    Dim vntArrEditTax()             As Variant          '調整消費税
    Dim vntArrOrgName()             As Variant          '団体名
    Dim vntArrCsName()              As Variant          'コース名
    Dim vntArrLastName()            As Variant          '名
    Dim vntArrFirstName()           As Variant          '姓

    Dim conditionStr                As String           'SQL編集用ワーク
    Dim i                           As Long             'ループカウント
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期設定
    conditionStr = "  WHERE  "
    SelectPersonDemandList = 0

    If IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If IsMissing(vntCloseDate) Then vntCloseDate = Empty
    If IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If IsMissing(vntCsCd) Then vntCsCd = Empty
    If IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If IsMissing(vntIsrNo) Then vntIsrNo = Empty
    If IsMissing(vntEmpNo) Then vntEmpNo = Empty
    If IsMissing(vntCslDate) Then vntCslDate = Empty
    If IsMissing(vntOrgPostCd) Then vntOrgPostName = Empty
    If IsMissing(vntOrgPostName) Then vntOrgPostName = Empty
    If IsMissing(vntPrice) Then vntPrice = Empty
    If IsMissing(vntEditPrice) Then vntEditPrice = Empty
    If IsMissing(vntTaxPrice) Then vntTaxPrice = Empty
    If IsMissing(vntEditTax) Then vntEditTax = Empty
    If IsMissing(vntOrgName) Then vntOrgName = Empty
    If IsMissing(vntCsName) Then vntCsName = Empty
    If IsMissing(vntLastName) Then vntLastName = Empty
    If IsMissing(vntFirstName) Then vntFirstName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If (strStrCloseDate <> "") Then objOraParam.Add "STRCLOSEDATE", strStrCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strEndCloseDate <> "") Then objOraParam.Add "ENDCLOSEDATE", strEndCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    If (strOrgCd1 <> "") Then objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strOrgCd2 <> "") Then objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If (strPerId <> "") Then objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2

    strStmt = " SELECT  BILLTBL.ORGCD1 ORGCD1               " & vbLf _
            & "       , BILLTBL.ORGCD2 ORGCD2               " & vbLf _
            & "       , BILLTBL.CLOSEDATE CLOSEDATE         " & vbLf _
            & "       , BILLTBL.RSVNO RSVNO                 " & vbLf _
            & "       , BILLTBL.CSCD CSCD                   " & vbLf _
            & "       , CONSULTTBL.ORGBSDCD ORGBSDCD        " & vbLf _
            & "       , CONSULTTBL.ORGROOMCD ORGROOMCD      " & vbLf _
            & "       , CONSULTTBL.ORGPOSTCD ORGPOSTCD      " & vbLf _
            & "       , CONSULTTBL.EMPNO EMPNO              " & vbLf _
            & "       , CONSULTTBL.ISRSIGN ISRSIGN          " & vbLf _
            & "       , CONSULTTBL.ISRNO ISRNO              " & vbLf _
            & "       , CONSULTTBL.CSLDATE CSLDATE          " & vbLf _
            & "       , CONSULTTBL.ORGPOSTNAME ORGPOSTNAME  " & vbLf _
            & "       , CONSULTMTBL.PRICE PRICE             " & vbLf _
            & "       , CONSULTMTBL.EDITPRICE EDITPRICE     " & vbLf _
            & "       , CONSULTMTBL.TAXPRICE TAXPRICE       " & vbLf _
            & "       , CONSULTMTBL.EDITTAX EDITTAX         " & vbLf _
            & "       , BILLTBL.ORGNAME ORGNAME             " & vbLf _
            & "       , CONSULTMTBL.CSNAME CSNAME           " & vbLf _
            & "       , CONSULTTBL.LASTNAME LASTNAME        " & vbLf _
            & "       , CONSULTTBL.FIRSTNAME FIRSTNAME      " & vbLf _
            & "  FROM  " & vbLf

    '請求書テーブルからデータを取得
    strStmt = strStmt & " ( SELECT  BILL.BILLNO, BILL.ORGCD1, BILL.ORGCD2 " & vbLf & _
                        "         , BILL.CLOSEDATE       " & vbLf & _
                        "         , CLOSEMNG.RSVNO                           " & vbLf & _
                        "         , CLOSEMNG.CSCD              " & vbLf & _
                        "         , ORG.ORGNAME              " & vbLf & _
                        "     FROM BILL,CLOSEMNG,ORG                          " & vbLf

    If ((strStrCloseDate <> "") Or (strEndCloseDate <> "") _
        Or (strOrgCd1 <> "") Or (strOrgCd2 <> "")) Then

        '団体１
        If (strOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD1    = :ORGCD1      " & vbLf
            conditionStr = "  AND "
        End If

        '団体２
        If (strOrgCd1 <> "") Then
            strStmt = strStmt & conditionStr & " BILL.ORGCD2    = :ORGCD2     " & vbLf
            conditionStr = "  AND "
        End If

        '締め日（開始日）
        If (strStrCloseDate <> "") Then
            strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    >= :STRCLOSEDATE      " & vbLf
            conditionStr = "  AND "
        End If
        '締め日（終了日）
        If (strEndCloseDate <> "") Then
            strStmt = strStmt & conditionStr & " BILL.CLOSEDATE    <= :ENDCLOSEDATE      " & vbLf
            conditionStr = "  AND "
        End If
        
    End If

    strStmt = strStmt & conditionStr & "       BILL.BILLNO     =  CLOSEMNG.BILLNO   " & vbLf _
                                     & "  AND  BILL.ORGCD1     =  ORG.ORGCD1        " & vbLf _
                                     & "  AND  BILL.ORGCD2     =  ORG.ORGCD2        " & vbLf
    conditionStr = "    AND  "
    'コースコード条件設定
    If (Not IsEmpty(strCsCd)) Then
        If (IsArray(strCsCd)) Then
            strStmt = strStmt & conditionStr & "  ( CLOSEMNG.CSCD = '" & strCsCd(0) & "' " & vbLf
            conditionStr = "    AND  "
            For i = 1 To UBound(strCsCd)
                If (strCsCd(i) <> "") Then
                    strStmt = strStmt & "    OR  CLOSEMNG.CSCD = '" & strCsCd(i) & "' " & vbLf
                End If
            Next i
            strStmt = strStmt & " ) " & vbLf
        Else
            If (strCsCd <> "") Then
                strStmt = strStmt & conditionStr & "  CLOSEMNG.CSCD = '" & strCsCd & "' " & vbLf
                conditionStr = "    AND  "
            End If
        End If
    End If

    strStmt = strStmt & " )  BILLTBL  " & vbLf

    '受診情報，個人テーブルからデータを取得
    conditionStr = "  WHERE  "
    strStmt = strStmt & " , ( SELECT  CONSULT.RSVNO             " & vbLf & _
                        "           , CONSULT.ORGBSDCD          " & vbLf & _
                        "           , CONSULT.ORGROOMCD         " & vbLf & _
                        "           , CONSULT.ORGPOSTCD         " & vbLf & _
                        "           , CONSULT.CSLDATE           " & vbLf & _
                        "           , PERSON.EMPNO              " & vbLf & _
                        "           , PERSON.LASTNAME           " & vbLf & _
                        "           , PERSON.FIRSTNAME          " & vbLf & _
                        "           , PERSON.ISRSIGN            " & vbLf & _
                        "           , PERSON.ISRNO              " & vbLf & _
                        "           , ORGPOST.ORGPOSTNAME       " & vbLf & _
                        "       FROM  CONSULT,PERSON,ORGPOST    " & vbLf


    '個人ＩＤ
    If (strPerId <> "") Then
        strStmt = strStmt & conditionStr & " CONSULT.PERID    = :PERID      " & vbLf
        conditionStr = "  AND "
    End If


    strStmt = strStmt & conditionStr & "       CONSULT.PERID      =  PERSON.PERID        " & vbLf _
                                     & "  AND  CONSULT.ORGCD1     =  ORGPOST.ORGCD1      " & vbLf _
                                     & "  AND  CONSULT.ORGCD2     =  ORGPOST.ORGCD2      " & vbLf _
                                     & "  AND  CONSULT.ORGBSDCD   =  ORGPOST.ORGBSDCD    " & vbLf _
                                     & "  AND  CONSULT.ORGROOMCD  =  ORGPOST.ORGROOMCD   " & vbLf _
                                     & "  AND  CONSULT.ORGPOSTCD  =  ORGPOST.ORGPOSTCD   " & vbLf

    strStmt = strStmt & " )  CONSULTTBL  " & vbLf


    '受診金額確定テーブルからデータを取得
    conditionStr = "  WHERE  "
    strStmt = strStmt & " , ( SELECT  CONSULT_M.RSVNO                       " & vbLf _
                      & "           , COURSE_P.CSCD                         " & vbLf _
                      & "           , COURSE_P.CSNAME                       " & vbLf _
                      & "           , SUM(CONSULT_M.PRICE) PRICE            " & vbLf _
                      & "           , SUM(CONSULT_M.EDITPRICE) EDITPRICE    " & vbLf _
                      & "           , SUM(CONSULT_M.TAXPRICE) TAXPRICE      " & vbLf _
                      & "           , SUM(CONSULT_M.EDITTAX) EDITTAX        " & vbLf _
                      & "       FROM  CONSULT_M,COURSE_P           " & vbLf
             
    strStmt = strStmt & conditionStr & "       CONSULT_M.CSCD    =  COURSE_P.CSCD       " & vbLf
    
    strStmt = strStmt & "  GROUP BY CONSULT_M.RSVNO, COURSE_P.CSCD, COURSE_P.CSNAME     " & vbLf
    
    strStmt = strStmt & " )  CONSULTMTBL  " & vbLf

    '請求書関連テーブルの結合条件
    strStmt = strStmt & " WHERE  BILLTBL.RSVNO       = CONSULTTBL.RSVNO    " & vbLf _
                      & "   AND  CONSULTTBL.RSVNO    = CONSULTMTBL.RSVNO    " & vbLf _
                      & "   AND  BILLTBL.CSCD        = CONSULTMTBL.CSCD     " & vbLf

    strStmt = strStmt & " ORDER BY  ORGCD1,ORGCD2,CLOSEDATE,ORGBSDCD,ORGROOMCD,ORGPOSTCD,EMPNO,CSLDATE,CSCD  " & vbLf

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objRsvNo = objFields("RSVNO")
        Set objCsCd = objFields("CSCD")
        Set objEmpNo = objFields("EMPNO")
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrNo = objFields("ISRNO")
        Set objCslDate = objFields("CSLDATE")
        Set objOrgPostCd = objFields("ORGPOSTCD")
        Set objOrgPostName = objFields("ORGPOSTNAME")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITPRICE")
        Set objOrgName = objFields("ORGNAME")
        Set objCsName = objFields("CSNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")

        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrEmpNo(lngCount)
            ReDim Preserve vntArrIsrSign(lngCount)
            ReDim Preserve vntArrIsrNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrOrgPostCd(lngCount)
            ReDim Preserve vntArrOrgPostName(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrEmpNo(lngCount) = objEmpNo.Value & ""
            vntArrIsrSign(lngCount) = objIsrSign.Value & ""
            vntArrIsrNo(lngCount) = objIsrNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrOrgPostCd(lngCount) = objOrgPostCd.Value & ""
            vntArrOrgPostName(lngCount) = objOrgPostName.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrEditPrice(lngCount) = objEditPrice.Value & ""
            vntArrTaxPrice(lngCount) = objTaxPrice.Value & ""
            vntArrEditTax(lngCount) = objEditTax.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        vntOrgCd1 = vntArrOrgCd1
        vntOrgCd2 = vntArrOrgCd2
        vntCloseDate = vntArrCloseDate
        vntRsvNo = vntArrRsvNo
        vntCsCd = vntArrCsCd
        vntEmpNo = vntArrEmpNo
        vntIsrSign = vntArrIsrSign
        vntIsrNo = vntArrIsrNo
        vntCslDate = vntArrCslDate
        vntOrgPostCd = vntArrOrgPostCd
        vntOrgPostName = vntArrOrgPostName
        vntPrice = vntArrPrice
        vntEditPrice = vntArrEditPrice
        vntTaxPrice = vntArrTaxPrice
        vntEditTax = vntArrEditTax
        vntOrgName = vntArrOrgName
        vntCsName = vntArrCsName
        vntLastName = vntArrLastName
        vntFirstName = vntArrFirstName

    End If

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectPersonDemandList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    SelectPersonDemandList = -1

    'イベントログ書き込み
    WriteErrorLog "Bill.SelectPersonDemandList"
    
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

    'オブジェクトコンテキストを解放
    Set mobjContext = Nothing

End Sub




