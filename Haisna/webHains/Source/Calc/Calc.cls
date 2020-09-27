VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Calc"
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
' 機能　　 : 計算（履歴・親）の一覧を取得する
'
' 引数　　 : (In)     blnSummary        TRUE:検査項目コード、サフィックスでGROUP BY
' 　　　　 : (In)     strItemCd         検査項目コード（空白可）
' 　　　　 : (In)     strSuffix         サフィックス（空白可）
' 　　　　 : (Out)    vntItemCd         検査項目コード
' 　　　　 : (Out)    vntSuffix         サフィックス
' 　　　　 : -------------------------- 以降全て省略可能
' 　　　　 : (Out)    vntItemName       検査項目名
' 　　　　 : (Out)    vntCalcHNo        計算履歴Ｎｏ（blnSummary=Trueのとき）
' 　　　　 :                            計算履歴管理数（blnSummary=Falseのとき）
' 　　　　 : (Out)    vntStrDate        使用開始日付（blnSummary=Falseのときは返しません）
' 　　　　 : (Out)    vntEndDate        使用終了日付（blnSummary=Falseのときは返しません）
' 　　　　 : (Out)    vntFraction       端数処理（blnSummary=Falseのときは返しません）
' 　　　　 : (Out)    vntTiming         計算タイミング（blnSummary=Falseのときは返しません）
' 　　　　 : (Out)    vntExplanation    説明（blnSummary=Falseのときは返しません）
'
' 戻り値　 : レコード件数
'
' 備考　　 : 検査項目コード、サフィックスが未指定の場合は全件表示
'
Public Function SelectCalcList(ByVal blnSummary As Boolean, _
                               ByVal strItemCd As String, _
                               ByVal strSuffix As String, _
                               ByRef vntItemCd As Variant, _
                               ByRef vntSuffix As Variant, _
                               Optional ByRef vntItemName As Variant, _
                               Optional ByRef vntCalcHNo As Variant, _
                               Optional ByRef vntStrDate As Variant, _
                               Optional ByRef vntEndDate As Variant, _
                               Optional ByRef vntFraction As Variant, _
                               Optional ByRef vntTiming As Variant, _
                               Optional ByRef vntExplanation As Variant _
                               ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objItemCd               As OraField         '検査項目コード
    Dim objSuffix               As OraField         'サフィックス
    Dim objItemName             As OraField         '検査項目名
    Dim objCalcHNo              As OraField         '計算履歴Ｎｏ
    Dim objStrDate              As OraField         '使用開始日付
    Dim objEndDate              As OraField         '使用終了日付
    Dim objFraction             As OraField         '対象コースコード
    Dim objTiming               As OraField         '検査項目名
    Dim objExplanation          As OraField         '対象コース名
    
    Dim vntArrItemCd()          As Variant          '検査項目コード
    Dim vntArrSuffix()          As Variant          'サフィックス
    Dim vntArrItemName()        As Variant          '検査項目名
    Dim vntArrCalcHNo()         As Variant          '計算履歴Ｎｏ
    Dim vntArrStrDate()         As Variant          '使用開始日付
    Dim vntArrEndDate()         As Variant          '使用終了日付
    Dim vntArrFraction()        As Variant          '対象コースコード
    Dim vntArrTiming()          As Variant          '検査項目名
    Dim vntArrExplanation()     As Variant          '対象コース名
    
    Dim blnSelectItem           As Boolean          '検査項目による検索条件指定
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectCalcList = 0
    lngCount = 0
    blnSelectItem = False
    
    Set objOraParam = mobjOraDb.Parameters
    
    '検査項目コードとサフィックスを指定されている場合はフラグON
    If (Trim(strItemCd) <> "") And (Trim(strSuffix) <> "") Then
        blnSelectItem = True
        objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT
        objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT
    End If
    
    'SQL Build
    If blnSummary = True Then
        
        '検査項目コード、サフィックスでサマリする場合
        strStmt = "SELECT TARGETCALC.ITEMCD, TARGETCALC.SUFFIX, ITEM_C.ITEMNAME, TARGETCALC.CALCHNO" & vbLf & _
                  "  FROM ITEM_C, (SELECT ITEMCD, SUFFIX, COUNT(CALCHNO) CALCHNO" & vbLf & _
                  "                  FROM CALC " & vbLf & _
                  "                 GROUP BY ITEMCD, SUFFIX) TARGETCALC" & vbLf & _
                  " WHERE TARGETCALC.ITEMCD = ITEM_C.ITEMCD" & vbLf & _
                  "   AND TARGETCALC.SUFFIX = ITEM_C.SUFFIX" & vbLf
    
        '検査項目コードとサフィックスを指定されている場合は検索条件に追加
        If blnSelectItem = True Then
            strStmt = strStmt & "   AND TARGETCALC.ITEMCD = :ITEMCD" & vbLf & _
                                "   AND TARGETCALC.SUFFIX = :SUFFIX" & vbLf
        End If
        
        '読み込み順指定
        strStmt = strStmt & " ORDER BY TARGETCALC.ITEMCD, TARGETCALC.SUFFIX"
    
    Else
        
        '履歴を全て取得する場合
        strStmt = "SELECT CALC.ITEMCD,  CALC.SUFFIX,   ITEM_C.ITEMNAME, CALC.CALCHNO, CALC.STRDATE," & vbLf & _
                  "       CALC.ENDDATE, CALC.FRACTION, CALC.TIMING,     CALC.EXPLANATION" & vbLf & _
                  "  FROM ITEM_C, CALC" & vbLf & _
                  " WHERE CALC.ITEMCD = ITEM_C.ITEMCD" & vbLf & _
                  "   AND CALC.SUFFIX = ITEM_C.SUFFIX" & vbLf
        
        '検査項目コードとサフィックスを指定されている場合は検索条件に追加
        If blnSelectItem = True Then
            strStmt = strStmt & "   AND CALC.ITEMCD = :ITEMCD" & vbLf & _
                                "   AND CALC.SUFFIX = :SUFFIX" & vbLf
        End If
        
        '読み込み順指定
        strStmt = strStmt & " ORDER BY CALC.ITEMCD, CALC.SUFFIX, CALC.ENDDATE DESC"
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objCalcHNo = objFields("CALCHNO")
        
        If blnSummary = False Then
            Set objStrDate = objFields("STRDATE")
            Set objEndDate = objFields("ENDDATE")
            Set objFraction = objFields("FRACTION")
            Set objTiming = objFields("TIMING")
            Set objExplanation = objFields("EXPLANATION")
        End If
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrCalcHNo(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrCalcHNo(lngCount) = objCalcHNo.Value & ""
            
            If blnSummary = False Then
                ReDim Preserve vntArrStrDate(lngCount)
                ReDim Preserve vntArrEndDate(lngCount)
                ReDim Preserve vntArrFraction(lngCount)
                ReDim Preserve vntArrTiming(lngCount)
                ReDim Preserve vntArrExplanation(lngCount)
                vntArrStrDate(lngCount) = objStrDate.Value & ""
                vntArrEndDate(lngCount) = objEndDate.Value & ""
                vntArrFraction(lngCount) = objFraction.Value & ""
                vntArrTiming(lngCount) = objTiming.Value & ""
                vntArrExplanation(lngCount) = objExplanation.Value & ""
            End If
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    If IsMissing(vntItemName) = False Then vntItemName = vntArrItemName
    If IsMissing(vntCalcHNo) = False Then vntCalcHNo = vntArrCalcHNo
    If IsMissing(vntStrDate) = False Then vntStrDate = vntArrStrDate
    If IsMissing(vntEndDate) = False Then vntEndDate = vntArrEndDate
    If IsMissing(vntFraction) = False Then vntFraction = vntArrFraction
    If IsMissing(vntTiming) = False Then vntTiming = vntArrTiming
    If IsMissing(vntExplanation) = False Then vntExplanation = vntArrExplanation
    
    SelectCalcList = lngCount
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Calc.SelectCalcList"
    
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
' 機能　　 : 計算詳細の一覧を取得する
'
' 引数　　 : (In)     strItemCd         検査項目コード
' 　　　　 : (In)     strSuffix         サフィックス
' 　　　　 : (In)     intCalcHNo        計算履歴No
' 　　　　 : (Out)    vntgender         性別
' 　　　　 : (Out)    vntSeq            計算順
' 　　　　 : (Out)    vntVariable1      変数１
' 　　　　 : (Out)    vntCalcItemCd1    計算項目コード１
' 　　　　 : (Out)    vntCalcSuffix1    計算サフィックス１
' 　　　　 : (Out)    vntCalcItemName1  項目名１
' 　　　　 : (Out)    vntConstant1      定数１
' 　　　　 : (Out)    vntOperator       演算記号
' 　　　　 : (Out)    vntVariable2      変数２
' 　　　　 : (Out)    vntCalcItemCd2    計算項目コード２
' 　　　　 : (Out)    vntCalcSuffix2    計算サフィックス２
' 　　　　 : (Out)    vntCalcItemName2  項目名２
' 　　　　 : (Out)    vntConstant2      定数２
' 　　　　 : (Out)    vntCalcResult     計算結果
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectCalc_cList(ByVal strItemCd As String, _
                                 ByVal strSuffix As String, _
                                 ByVal intCalcHNo As Integer, _
                                 ByRef vntGender As Variant, _
                                 ByRef vntSeq As Variant, _
                                 ByRef vntVariable1 As Variant, _
                                 ByRef vntCalcItemCd1 As Variant, _
                                 ByRef vntCalcSuffix1 As Variant, _
                                 ByRef vntCalcItemName1 As Variant, _
                                 ByRef vntConstant1 As Variant, _
                                 ByRef vntOperator As Variant, _
                                 ByRef vntVariable2 As Variant, _
                                 ByRef vntCalcItemCd2 As Variant, _
                                 ByRef vntCalcSuffix2 As Variant, _
                                 ByRef vntCalcItemName2 As Variant, _
                                 ByRef vntConstant2 As Variant, _
                                 ByRef vntCalcResult As Variant _
                                ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objGender               As OraField         '性別
    Dim objSeq                  As OraField         '計算順
    Dim objVariable1            As OraField         '変数１
    Dim objCalcItemCd1          As OraField         '計算項目コード１
    Dim objCalcSuffix1          As OraField         '計算サフィックス１
    Dim objCalcItemName1        As OraField         '検査項目名１
    Dim objConstant1            As OraField         '定数１
    Dim objOperator             As OraField         '演算記号
    Dim objVariable2            As OraField         '変数２
    Dim objCalcItemCd2          As OraField         '計算項目コード２
    Dim objCalcSuffix2          As OraField         '計算サフィックス２
    Dim objCalcItemName2        As OraField         '検査項目名２
    Dim objConstant2            As OraField         '定数２
    Dim objCalcResult           As OraField         '計算結果
    
    Dim vntArrGender()          As Variant          '性別
    Dim vntArrSeq()             As Variant          '計算順
    Dim vntArrVariable1()       As Variant          '変数１
    Dim vntArrCalcItemCd1()     As Variant          '計算項目コード１
    Dim vntArrCalcSuffix1()     As Variant          '計算サフィックス１
    Dim vntArrCalcItemName1()   As Variant          '検査項目名１
    Dim vntArrConstant1()       As Variant          '定数１
    Dim vntArrOperator()        As Variant          '演算記号
    Dim vntArrVariable2()       As Variant          '変数２
    Dim vntArrCalcItemCd2()     As Variant          '計算項目コード２
    Dim vntArrCalcSuffix2()     As Variant          '計算サフィックス２
    Dim vntArrCalcItemName2()   As Variant          '検査項目名２
    Dim vntArrConstant2()       As Variant          '定数２
    Dim vntArrCalcResult()      As Variant          '計算結果
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '主キーが設定されていない場合はエラー
    If (Trim(strItemCd) = "") Or (Trim(strSuffix) = "") Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '初期処理
    SelectCalc_cList = 0
    lngCount = 0
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT
    objOraParam.Add "CALCHNO", Trim(intCalcHNo), ORAPARM_INPUT
    
    '計算テーブルよりレコードを取得
    strStmt = "SELECT CALC_C.GENDER, CALC_C.SEQ, " & vbLf & _
              "       CALC_C.VARIABLE1, CALC_C.CALCITEMCD1, CALC_C.CALCSUFFIX1, ITEM1.ITEMNAME ITEMNAME1, CALC_C.CONSTANT1, CALC_C.OPERATOR, " & vbLf & _
              "       CALC_C.VARIABLE2, CALC_C.CALCITEMCD2, CALC_C.CALCSUFFIX2, ITEM2.ITEMNAME ITEMNAME2, CALC_C.CONSTANT2, CALC_C.CALCRESULT" & vbLf & _
              "  FROM ITEM_C ITEM1, ITEM_C ITEM2, CALC_C CALC_C" & vbLf & _
              " WHERE CALC_C.ITEMCD  = :ITEMCD" & vbLf & _
              "   AND CALC_C.SUFFIX  = :SUFFIX" & vbLf & _
              "   AND CALC_C.CALCHNO = :CALCHNO" & vbLf & _
              "   AND CALC_C.CALCITEMCD1  = ITEM1.ITEMCD(+)" & vbLf & _
              "   AND CALC_C.CALCSUFFIX1  = ITEM1.SUFFIX(+)" & vbLf & _
              "   AND CALC_C.CALCITEMCD2  = ITEM2.ITEMCD(+)" & vbLf & _
              "   AND CALC_C.CALCSUFFIX2  = ITEM2.SUFFIX(+)" & vbLf & _
              " ORDER BY CALC_C.GENDER, CALC_C.SEQ"

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objGender = objFields("GENDER")
        Set objSeq = objFields("SEQ")
        Set objVariable1 = objFields("VARIABLE1")
        Set objCalcItemCd1 = objFields("CALCITEMCD1")
        Set objCalcSuffix1 = objFields("CALCSUFFIX1")
        Set objCalcItemName1 = objFields("ITEMNAME1")
        Set objConstant1 = objFields("CONSTANT1")
        Set objOperator = objFields("OPERATOR")
        Set objVariable2 = objFields("VARIABLE2")
        Set objCalcItemCd2 = objFields("CALCITEMCD2")
        Set objCalcSuffix2 = objFields("CALCSUFFIX2")
        Set objCalcItemName2 = objFields("ITEMNAME2")
        Set objConstant2 = objFields("CONSTANT2")
        Set objCalcResult = objFields("CALCRESULT")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrVariable1(lngCount)
            ReDim Preserve vntArrCalcItemCd1(lngCount)
            ReDim Preserve vntArrCalcSuffix1(lngCount)
            ReDim Preserve vntArrCalcItemName1(lngCount)
            ReDim Preserve vntArrConstant1(lngCount)
            ReDim Preserve vntArrOperator(lngCount)
            ReDim Preserve vntArrVariable2(lngCount)
            ReDim Preserve vntArrCalcItemCd2(lngCount)
            ReDim Preserve vntArrCalcSuffix2(lngCount)
            ReDim Preserve vntArrCalcItemName2(lngCount)
            ReDim Preserve vntArrConstant2(lngCount)
            ReDim Preserve vntArrCalcResult(lngCount)
            
            vntArrGender(lngCount) = objGender.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrVariable1(lngCount) = objVariable1.Value & ""
            vntArrCalcItemCd1(lngCount) = objCalcItemCd1.Value & ""
            vntArrCalcSuffix1(lngCount) = objCalcSuffix1.Value & ""
            vntArrCalcItemName1(lngCount) = objCalcItemName1.Value & ""
            vntArrConstant1(lngCount) = objConstant1.Value & ""
            vntArrOperator(lngCount) = objOperator.Value & ""
            vntArrVariable2(lngCount) = objVariable2.Value & ""
            vntArrCalcItemCd2(lngCount) = objCalcItemCd2.Value & ""
            vntArrCalcSuffix2(lngCount) = objCalcSuffix2.Value & ""
            vntArrCalcItemName2(lngCount) = objCalcItemName2.Value & ""
            vntArrConstant2(lngCount) = objConstant2.Value & ""
            vntArrCalcResult(lngCount) = objCalcResult.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntGender = vntArrGender
    vntSeq = vntArrSeq
    vntVariable1 = vntArrVariable1
    vntCalcItemCd1 = vntArrCalcItemCd1
    vntCalcSuffix1 = vntArrCalcSuffix1
    vntCalcItemName1 = vntArrCalcItemName1
    vntConstant1 = vntArrConstant1
    vntOperator = vntArrOperator
    vntVariable2 = vntArrVariable2
    vntCalcItemCd2 = vntArrCalcItemCd2
    vntCalcSuffix2 = vntArrCalcSuffix2
    vntCalcItemName2 = vntArrCalcItemName2
    vntConstant2 = vntArrConstant2
    vntCalcResult = vntArrCalcResult
    
    SelectCalc_cList = lngCount
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Calc.SelectCalc_cList"
    
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
' 機能　　 : 計算テーブルレコードを登録する
'
' 引数　　 : (In)       strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)       strItemCd          検査項目コード
' 　　　　   (In)       strSuffix          サフィックス
' 　　　　   (In/Out)   intCalcHNo         計算履歴Ｎｏ
' 　　　　   (In)       dtmStrDate         使用開始日付
' 　　　　   (In)       dtmEndDate         使用終了日付
' 　　　　   (In)       intFraction        端数処理
' 　　　　   (In)       intTiming          計算タイミング
' 　　　　   (In)       strExplanation     説明
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistCalc(ByVal strMode As String, _
                           ByVal strItemCd As String, _
                           ByVal strSuffix As String, _
                           ByRef intCalcHNo As Integer, _
                           ByVal dtmStrDate As Date, _
                           ByVal dtmEndDate As Date, _
                           ByVal intFraction As Integer, _
                           ByVal intTiming As Integer, _
                           ByVal strExplanation As String _
                           ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objNewNo            As OraField         '計算管理コード（次発番用）
    Dim strStmt             As String           'SQLステートメント
    
    Dim Ret                 As Long             '関数戻り値
    Dim intTargetCalcHNo    As Integer
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    intTargetCalcHNo = intCalcHNo
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '履歴データの重複チェック
    If strMode = "INS" Then
        strStmt = "SELECT ITEMCD FROM CALC" & vbLf & _
                  " WHERE ITEMCD = :ITEMCD" & vbLf & _
                  "   AND SUFFIX = :SUFFIX" & vbLf & _
                  "   AND (    :STRDATE BETWEEN  STRDATE AND ENDDATE " & vbLf & _
                  "         OR :ENDDATE BETWEEN  STRDATE AND ENDDATE )"
    Else
        objOraParam.Add "CALCHNO", Trim(intTargetCalcHNo), ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = "SELECT ITEMCD FROM CALC" & vbLf & _
                  " WHERE ITEMCD  = :ITEMCD" & vbLf & _
                  "   AND SUFFIX  = :SUFFIX" & vbLf & _
                  "   AND CALCHNO != :CALCHNO" & vbLf & _
                  "   AND (    :STRDATE BETWEEN  STRDATE AND ENDDATE " & vbLf & _
                  "         OR :ENDDATE BETWEEN  STRDATE AND ENDDATE )"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        RegistCalc = INSERT_HISTORYDUPLICATE
        Exit Function
    End If
    
    If strMode = "INS" Then
        
        '新規登録モード
        
        '計算履歴Ｎｏの取得
        strStmt = "SELECT NVL(MAX(CALCHNO) + 1,0) NEWNO FROM CALC WHERE ITEMCD = :ITEMCD AND SUFFIX = :SUFFIX"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        Set objFields = objOraDyna.Fields
        Set objNewNo = objFields("NEWNO")
        intTargetCalcHNo = objNewNo.Value
        
        objOraParam.Add "CALCHNO", Trim(intTargetCalcHNo), ORAPARM_INPUT, ORATYPE_NUMBER
        
    End If

'    objOraParam.Add "STRDATE", Trim(dtmStrDate), ORAPARM_INPUT, ORATYPE_DATE
'    objOraParam.Add "ENDDATE", Trim(dtmEndDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "FRACTION", Trim(intFraction), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TIMING", Trim(intTiming), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EXPLANATION", Trim(strExplanation), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '計算テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE CALC " & _
                      "   SET STRDATE      = :STRDATE," & _
                      "       ENDDATE      = :ENDDATE," & _
                      "       FRACTION     = :FRACTION," & _
                      "       TIMING       = :TIMING," & _
                      "       EXPLANATION  = :EXPLANATION" & _
                      " WHERE CALC.ITEMCD  = :ITEMCD" & _
                      "   AND CALC.SUFFIX  = :SUFFIX" & _
                      "   AND CALC.CALCHNO = :CALCHNO"

            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        
        End If
'
'        '検索条件を満たす計算テーブルのレコードを取得
'        strStmt = "SELECT CalcMNGCD FROM Calc WHERE CalcMNGCD = :CalcMNGCD"
'        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
'
'        If Not objOraDyna.EOF Then
'            Ret = INSERT_DUPLICATE
'            Exit Do
'        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        strStmt = "INSERT INTO CALC ( ITEMCD, SUFFIX, CALCHNO, STRDATE, ENDDATE, FRACTION, TIMING, EXPLANATION)" & vbLf & _
                  "          VALUES (:ITEMCD,:SUFFIX,:CALCHNO,:STRDATE,:ENDDATE,:FRACTION,:TIMING,:EXPLANATION)"
        mobjOraDb.ExecuteSQL strStmt
        
        '履歴番号を戻す
        intCalcHNo = intTargetCalcHNo
        
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistCalc = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCalc = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Calc.RegistCalc"
    
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
' 機能　　 : 計算テーブル及び計算詳細テーブルレコードを登録する
' 　　　　 　（トランザクション対応）
'
' 引数　　 : (In)       strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)       strItemCd          検査項目コード
' 　　　　   (In)       strSuffix          サフィックス
' 　　　　   (In/Out)   intCalcHNo         計算履歴Ｎｏ
' 　　　　   (In)       dtmStrDate         使用開始日付
' 　　　　   (In)       dtmEndDate         使用終了日付
' 　　　　   (In)       intFraction        端数処理
' 　　　　   (In)       intTiming          計算タイミング
' 　　　　   (In)       strExplanation     説明
' 　　　　   (In)       intItemCount       計算式の明細行数
' 　　　　   (In)       vntGender          性別
' 　　　　   (In)       vntSeq             計算順
' 　　　　   (In)       vntVariable1       変数１
' 　　　　   (In)       vntCalcItemCd1     計算項目コード１
' 　　　　   (In)       vntCalcSuffix1     計算サフィックス１
' 　　　　   (In)       vntConstant1       定数１
' 　　　　   (In)       vntOperator        演算記号
' 　　　　   (In)       vntVariable2       変数２
' 　　　　   (In)       vntCalcItemCd2     計算項目コード２
' 　　　　   (In)       vntCalcSuffix2     計算サフィックス２
' 　　　　   (In)       vntConstant2       定数２
' 　　　　   (In)       vntCalcResult      計算結果
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistCalc_All(ByVal strMode As String, ByVal strItemCd As String, _
                               ByVal strSuffix As String, ByRef intCalcHNo As Integer, _
                               ByVal dtmStrDate As Date, ByVal dtmEndDate As Date, _
                               ByVal intFraction As Integer, ByVal intTiming As Integer, _
                               ByVal strExplanation As String, _
                               ByVal intItemCount As Integer, _
                               ByVal vntGender As Variant, ByVal vntSeq As Variant, _
                               ByVal vntVariable1 As Variant, ByVal vntCalcItemCd1 As Variant, _
                               ByVal vntCalcSuffix1 As Variant, ByVal vntConstant1 As Variant, _
                               ByVal vntOperator As Variant, ByVal vntVariable2 As Variant, _
                               ByVal vntCalcItemCd2 As Variant, ByVal vntCalcSuffix2 As Variant, _
                               ByVal vntConstant2 As Variant, ByVal vntCalcResult As Variant _
                               ) As Long
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim Ret         As Long             '関数戻り値
    
    RegistCalc_All = INSERT_ERROR
    Ret = INSERT_ERROR
    
    Do
        
        '計算テーブルの更新
        Ret = RegistCalc(strMode, _
                         strItemCd, _
                         strSuffix, _
                         intCalcHNo, _
                         dtmStrDate, _
                         dtmEndDate, _
                         intFraction, _
                         intTiming, _
                         strExplanation)
        
        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
                         
        '計算詳細テーブルの更新
        Ret = RegistCalc_c(intItemCount, _
                           strItemCd, _
                           strSuffix, _
                           intCalcHNo, _
                           vntGender, _
                           vntSeq, _
                           vntVariable1, _
                           vntCalcItemCd1, _
                           vntCalcSuffix1, _
                           vntConstant1, _
                           vntOperator, _
                           vntVariable2, _
                           vntCalcItemCd2, _
                           vntCalcSuffix2, _
                           vntConstant2, _
                           vntCalcResult)
        
        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
        
        Exit Do
    Loop
 
    If Ret = INSERT_NORMAL Then
        '正常ならCommit これはRootトランザクションなのでCommit
        mobjContext.SetComplete
    Else
        '異常終了ならRollBack
        mobjContext.SetAbort
    End If
 
    '戻り値の設定
    RegistCalc_All = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCalc_All = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Calc.RegistCalc_All"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 計算詳細テーブルレコードを登録する
'
' 引数　　 : (In)    intItemCount       計算式の明細行数
' 　　　　   (In)    strItemCd          検査項目コード
' 　　　　   (In)    strSuffix          サフィックス
' 　　　　   (In)    intCalcHNo         計算履歴No
' 　　　　   (In)    vntGender          性別
' 　　　　   (In)    vntSeq             計算順
' 　　　　   (In)    vntVariable1       変数１
' 　　　　   (In)    vntCalcItemCd1     計算項目コード１
' 　　　　   (In)    vntCalcSuffix1     計算サフィックス１
' 　　　　   (In)    vntConstant1       定数１
' 　　　　   (In)    vntOperator        演算記号
' 　　　　   (In)    vntVariable2       変数２
' 　　　　   (In)    vntCalcItemCd2     計算項目コード２
' 　　　　   (In)    vntCalcSuffix2     計算サフィックス２
' 　　　　   (In)    vntConstant2       定数２
' 　　　　   (In)    vntCalcResult      計算結果
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistCalc_c(ByVal intItemCount As Integer, _
                             ByVal strItemCd As String, _
                             ByVal strSuffix As String, _
                             ByVal intCalcHNo As Integer, _
                             ByVal vntGender As Variant, _
                             ByVal vntSeq As Variant, _
                             ByVal vntVariable1 As Variant, _
                             ByVal vntCalcItemCd1 As Variant, _
                             ByVal vntCalcSuffix1 As Variant, _
                             ByVal vntConstant1 As Variant, _
                             ByVal vntOperator As Variant, _
                             ByVal vntVariable2 As Variant, _
                             ByVal vntCalcItemCd2 As Variant, _
                             ByVal vntCalcSuffix2 As Variant, _
                             ByVal vntConstant2 As Variant, _
                             ByVal vntCalcResult As Variant _
                             ) As Long
                               
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim strStmt             As String           'SQLステートメント

    Dim objItemCd           As OraParamArray    '検査項目コード
    Dim objSuffix           As OraParamArray    'サフィックス
    Dim objCalcHNo          As OraParamArray    '計算履歴No
    Dim objGender           As OraParamArray    '性別
    Dim objSeq              As OraParamArray    '計算順
    Dim objVariable1        As OraParamArray    '変数１
    Dim objCalcItemCd1      As OraParamArray    '計算項目コード１
    Dim objCalcSuffix1      As OraParamArray    '計算サフィックス１
    Dim objConstant1        As OraParamArray    '定数１
    Dim objOperator         As OraParamArray    '演算記号
    Dim objVariable2        As OraParamArray    '変数２
    Dim objCalcItemCd2      As OraParamArray    '計算項目コード２
    Dim objCalcSuffix2      As OraParamArray    '計算サフィックス２
    Dim objConstant2        As OraParamArray    '定数２
    Dim objCalcResult       As OraParamArray    '計算結果

    Dim i                   As Integer
    Dim Ret                 As Long             '関数戻り値
    Dim lngNewNo            As Long             'サフィックス（次に発番する最大値）
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    RegistCalc_c = INSERT_ERROR
    Ret = INSERT_ERROR
    
    '対象計算詳細レコードの削除
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CALCHNO", Trim(intCalcHNo), ORAPARM_INPUT, ORATYPE_NUMBER
    mobjOraDb.ExecuteSQL "DELETE CALC_C WHERE ITEMCD = :ITEMCD AND SUFFIX = :SUFFIX AND CALCHNO = :CALCHNO"
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'セットデータのチェック
    For i = 0 To intItemCount - 1
        
        '定数がセットされていないなら、強制的に１をセット
        If Trim(vntConstant1(i)) = "" Then vntConstant1(i) = "1"
        If Trim(vntConstant2(i)) = "" Then vntConstant2(i) = "1"
        
    Next i

    If intItemCount > 0 Then

        'キー及び更新値の設定再割り当て
        objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        objOraParam.AddTable "SUFFIX", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_C_SUFFIX
        objOraParam.AddTable "CALCHNO", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "GENDER", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "SEQ", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "VARIABLE1", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_CALC_C_CALCRESULT
        objOraParam.AddTable "CALCITEMCD1", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        objOraParam.AddTable "CALCSUFFIX1", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_C_SUFFIX
        objOraParam.AddTable "CONSTANT1", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_RSL_RESULT
        objOraParam.AddTable "OPERATOR", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_CALC_C_OPERATOR
        objOraParam.AddTable "VARIABLE2", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_CALC_C_CALCRESULT
        objOraParam.AddTable "CALCITEMCD2", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        objOraParam.AddTable "CALCSUFFIX2", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_C_SUFFIX
        objOraParam.AddTable "CONSTANT2", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_RSL_RESULT
        objOraParam.AddTable "CALCRESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_CALC_C_CALCRESULT

        'OraParameterオブジェクトの参照設定
        Set objItemCd = objOraParam("ITEMCD")
        Set objSuffix = objOraParam("SUFFIX")
        Set objCalcHNo = objOraParam("CALCHNO")
        Set objGender = objOraParam("GENDER")
        Set objSeq = objOraParam("SEQ")
        Set objVariable1 = objOraParam("VARIABLE1")
        Set objCalcItemCd1 = objOraParam("CALCITEMCD1")
        Set objCalcSuffix1 = objOraParam("CALCSUFFIX1")
        Set objConstant1 = objOraParam("CONSTANT1")
        Set objOperator = objOraParam("OPERATOR")
        Set objVariable2 = objOraParam("VARIABLE2")
        Set objCalcItemCd2 = objOraParam("CALCITEMCD2")
        Set objCalcSuffix2 = objOraParam("CALCSUFFIX2")
        Set objConstant2 = objOraParam("CONSTANT2")
        Set objCalcResult = objOraParam("CALCRESULT")

        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objItemCd(i) = strItemCd
            objSuffix(i) = strSuffix
            objCalcHNo(i) = intCalcHNo
            objGender(i) = vntGender(i)
            objSeq(i) = vntSeq(i)
            objVariable1(i) = vntVariable1(i)
            objCalcItemCd1(i) = vntCalcItemCd1(i)
            objCalcSuffix1(i) = vntCalcSuffix1(i)
            objConstant1(i) = vntConstant1(i)
            objOperator(i) = vntOperator(i)
            objVariable2(i) = vntVariable2(i)
            objCalcItemCd2(i) = vntCalcItemCd2(i)
            objCalcSuffix2(i) = vntCalcSuffix2(i)
            objConstant2(i) = vntConstant2(i)
            objCalcResult(i) = vntCalcResult(i)
        Next i

        '新規挿入
        strStmt = "INSERT INTO CALC_C ( ITEMCD, SUFFIX, CALCHNO, GENDER, SEQ, VARIABLE1, CALCITEMCD1, CALCSUFFIX1, CONSTANT1, OPERATOR, VARIABLE2, CALCITEMCD2, CALCSUFFIX2, CONSTANT2, CALCRESULT)" & _
                  "            VALUES (:ITEMCD,:SUFFIX,:CALCHNO,:GENDER,:SEQ,:VARIABLE1,:CALCITEMCD1,:CALCSUFFIX1,:CONSTANT1,:OPERATOR,:VARIABLE2,:CALCITEMCD2,:CALCSUFFIX2,:CONSTANT2,:CALCRESULT)"

        mobjOraDb.ExecuteSQL strStmt
        Ret = INSERT_NORMAL
    
    Else
        '0件ならそのまま終了
        Ret = INSERT_NORMAL
    End If

    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistCalc_c = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCalc_c = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Calc.RegistCalc_c"
    
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
' 機能　　 : 計算テーブルレコードを削除する
'
' 引数　　 : (In)    strItemCd          検査項目コード
' 　　　　   (In)    strSuffix          サフィックス
' 　　　　   (In)    intCalcHNo         計算履歴No（省略可）
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 : 計算履歴No未指定時は、対象検査項目の計算式すべてを削除
'
Public Function DeleteCalc(ByVal strItemCd As String, _
                           ByVal strSuffix As String, _
                           Optional ByVal vntCalcHNo As Variant _
                           ) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If IsMissing(vntCalcHNo) = False Then
        objOraParam.Add "CALCHNO", Trim(vntCalcHNo), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If

    'SQL Build
    strStmt = "DELETE CALC WHERE ITEMCD = :ITEMCD AND SUFFIX = :SUFFIX"
    If IsMissing(vntCalcHNo) = False Then
        strStmt = strStmt & " AND CALCHNO = :CALCHNO"
    End If
    
    '計算テーブルレコードの削除
    mobjOraDb.ExecuteSQL strStmt
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCalc = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteCalc = False

    'イベントログ書き込み
    WriteErrorLog "Calc.DeleteCalc"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Calc.DeleteCalc", Err.Description

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
