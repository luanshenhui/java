VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "FailSafe"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession      As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase      'OraDatabaseオブジェクト

Private Const PREFIX_PERID  As String = "ID:"       '検索時の個人ＩＤ指定

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

'
' 機能　　 : 半角数字チェック
'
' 引数　　 : (In)     strItemName    項目名
' 　　　　   (In)     strExpression  文字列式
' 　　　　   (In)     lngLength      桁数
' 　　　　   (In)     lngNecessary   必須かどうか
'
' 戻り値　 : エラーメッセージ(エラーが無い場合は長さ0の文字列)
'
' 備考　　 :
'
Public Function CheckNumeric(ByVal strItemName As String, _
                             ByVal strExpression As String, _
                             ByVal lngLength As Long, _
                             Optional lngNecessary As Long) As String

    Dim strMessage  As String   'エラーメッセージ
    Dim i           As Long     'インデックス
    
    Do
        '未入力チェック
        If Trim(strExpression) = "" Then
            
            '必須の場合のみメッセージを返す
            If lngNecessary = CHECK_NECESSARY Then
                strMessage = strItemName & "を入力して下さい。"
            End If
            
            Exit Do
        End If
        
        '桁数チェック
        If Len(Trim(strExpression)) > lngLength Then
            strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角数字で入力して下さい。"
            Exit Do
        End If
        
        '半角数字チェック
        For i = 1 To Len(Trim(strExpression))
        
            '半角数字以外の文字が現れたらチェックを中止する
            Select Case Asc(Mid(Trim(strExpression), i, 1))
                Case Asc("0") To Asc("9")
                Case Else
                    If i = 1 And Asc(Mid(Trim(strExpression), i, 1)) = Asc("-") Then
                    Else
                        strMessage = strItemName & "は" & CStr(lngLength) & "文字以内の半角数字で入力して下さい。"
                        Exit Do
                    End If
            End Select
            
        Next i
        
        Exit Do
    Loop
    
    CheckNumeric = strMessage
    
End Function
'
' 機能　　 : 指定期間の受診情報を取得する。
'
' 引数　　 : (In)     dtmStrCslDate         開始受診日
' 　　　　   (In)     dtmEndCslDate         終了受診日
' 　　　　   (Out)    vntRsvNo              予約番号
' 　　　　   (Out)    vntCslDate            受診日
' 　　　　   (Out)    vntPerId              個人ID
' 　　　　   (Out)    vntCsCd               コースコード
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntAge                受診時年齢
' 　　　　   (Out)    vntLastName           姓
' 　　　　   (Out)    vntFirstName          名
' 　　　　   (Out)    vntCsName             コース名
' 　　　　   (Out)    vntMOrgCd1            負担元コード１
' 　　　　   (Out)    vntMOrgCd2            負担元コード２
' 　　　　   (Out)    vntMPrice             金額(CONSULT_M)
' 　　　　   (Out)    vntMTax               消費税(CONSULT_M)
' 　　　　   (Out)    vntCPrice             金額(CTRPT_PRICE)
' 　　　　   (Out)    vntCTax               消費税(CTRPT_PRICE)
' 　　　　   (Out)    vntCtrPtCd            契約パターンコード
' 　　　　   (Out)    vntOptCd              オプションコード
' 　　　　   (Out)    vntOptBranchNo        オプション枝番
' 　　　　   (Out)    vntOptName            オプション名
' 　　　　   (Out)    vntOrgSName           団体略称名
' 　　　　   (Out)    vntOptMsg             オプションメッセージ(年:年齢,性:性別,受:受診区分)
' 　　　　   (Out)    vntP_Age              現在の契約からの受診時年齢
' 　　　　   (Out)    vntLimitFlg           限度額フラグ(0:限度額と一致,1:限度額と違う)
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult( _
    ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, _
    Optional ByRef vntRsvNo As Variant, Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntAge As Variant, Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, Optional ByRef vntCsName As Variant, _
    Optional ByRef vntMOrgCd1 As Variant, Optional ByRef vntMOrgCd2 As Variant, _
    Optional ByRef vntMPrice As Variant, Optional ByRef vntMTax As Variant, _
    Optional ByRef vntCPrice As Variant, Optional ByRef vntCTax As Variant, _
    Optional ByRef vntCtrPtCd As Variant, Optional ByRef vntOptCd As Variant, _
    Optional ByRef vntOptBranchNo As Variant, Optional ByRef vntOptName As Variant, _
    Optional ByRef vntOrgSName As Variant, Optional ByRef vntOptMsg As Variant, _
    Optional ByRef vntP_Age As Variant, Optional ByRef vntLimitFlg As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objParaRsvNo            As OraParameter     '予約番号
    Dim objParaOrgcd1           As OraParameter     '団体コード１
    Dim objParaOrgcd2           As OraParameter     '団体コード２
    Dim objParaAge              As OraParameter     '年齢
    Dim objParaCtrPtCd          As OraParameter     '契約パターンコード
    Dim objParaLimitTaxFlg      As OraParameter     '限度額消費税フラグ
    Dim objParaGenDer           As OraParameter     '性別
    Dim objParaCslDivCd         As OraParameter     '受診区分
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraDyna2             As OraDynaset       'ダイナセット２(金額情報)
    Dim objOraDyna3             As OraDynaset       'ダイナセット３(パターン情報)
    Dim objOraDyna4             As OraDynaset       'ダイナセット４(限度額情報)
    Dim objOraDyna5             As OraDynaset       'ダイナセット５(限度額情報[現在のCONSULT_Mの金額])
    Dim strStmt                 As String           'SQLステートメント
    Dim strStmt2                As String           'SQLステートメント(金額情報)
    Dim strStmt3                As String           'SQLステートメント(パターン情報)
    Dim strStmt4                As String           'SQLステートメント(限度額情報)
    Dim strStmt5                As String           'SQLステートメント(限度額情報[現在のCONSULT_Mの金額])
    Dim lngCount                As Long

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objFields2              As OraFields        'フィールドオブジェクト２(金額情報)
    Dim objFields3              As OraFields        'フィールドオブジェクト３(パターン情報)
    Dim objFields4              As OraFields        'フィールドオブジェクト４(限度額情報)
    Dim objFields5              As OraFields        'フィールドオブジェクト５(限度額情報[現在のCONSULT_Mの金額])
    Dim objRsvNo                As Object           '予約番号
    Dim objCslDate              As Object           '受診日
    Dim objPerId                As Object           '個人ID
    Dim objCsCd                 As Object           'コースコード
    Dim objOrgCd1               As Object           '団体コード１
    Dim objOrgCd2               As Object           '団体コード２
    Dim objAge                  As Object           '年齢
    Dim objLastName             As Object           '姓
    Dim objFirstName            As Object           '名
    Dim objCsName               As Object           'コース名
    Dim objMOrgcd1              As Object           '負担元コード１
    Dim objMOrgcd2              As Object           '負担元コード２
    Dim objMPrice               As Object           '金額(CONSULT_M)
    Dim objMTax                 As Object           '消費税(CONSULT_M)
    Dim objCPrice               As Object           '金額(CTRPT_PRICE)
    Dim objCTax                 As Object           '消費税(CTRPT_PRICE)
    Dim objCtrPtCd              As Object           '契約パターンコード
    Dim objOptCd                As Object           'オプションコード
    Dim objOptBranchNo          As Object           'オプション枝番
    Dim objOptName              As Object           'オプション名
    Dim objOrgSName             As Object           '団体略称名
    Dim objOptAgeSeq            As Object           'オプション年齢SEQ
    Dim objOptGender            As Object           'オプション性別
    Dim objOptCslDivCd          As Object           'オプション受診区分
    Dim objP_Age                As Object           '現在の契約からの受診時年齢
    Dim objP_CtrPtCd            As Object           '受診情報の契約パターンコード
    Dim objGenDer               As Object           '性別
    Dim objCslDivCd             As Object           '受診区分

    Dim objLimitRate            As Object           '限度率
    Dim objLimitTaxFlg          As Object           '限度額消費税フラグ
    Dim objLimitPrice           As Object           '上限金額
    Dim vntLimitRate            As Variant          '限度率
    Dim vntLimitTaxFlg          As Variant          '限度額消費税フラグ
    Dim vntLimitPrice           As Variant          '上限金額

    Dim objTotalPrice           As Object           '限度額
    Dim vntTotalPrice           As Variant          '限度額

    Dim objPrice                As Object           '限度額[現在のCONSULT_Mの金額]
    Dim vntPrice                As Variant          '限度額[現在のCONSULT_Mの金額]

    Dim vntArrRsvNo()           As Variant          '予約番号
    Dim vntArrCslDate()         As Variant          '受診日
    Dim vntArrPerId()           As Variant          '個人ID
    Dim vntArrCsCd()            As Variant          'コースコード
    Dim vntArrOrgCd1()          As Variant          '団体コード１
    Dim vntArrOrgCd2()          As Variant          '団体コード２
    Dim vntArrAge()             As Variant          '年齢
    Dim vntArrFirstName()       As Variant          '姓
    Dim vntArrLastName()        As Variant          '姓
    Dim vntArrCsName()          As Variant          'コース名
    Dim vntArrMOrgCd1()         As Variant          '負担元コード１
    Dim vntArrMOrgCd2()         As Variant          '負担元コード２
    Dim vntArrMPrice()          As Variant          '金額(CONSULT_M)
    Dim vntArrMTax()            As Variant          '消費税(CONSULT_M)
    Dim vntArrCPrice()          As Variant          '金額(CTRPT_PRICE)
    Dim vntArrCTax()            As Variant          '消費税(CTRPT_PRICE)
    Dim vntArrCtrPtCd()         As Variant          '契約パターンコード
    Dim vntArrOptCd()           As Variant          'オプションコード
    Dim vntArrOptBranchNo()     As Variant          'オプション枝番
    Dim vntArrOptName()         As Variant          'オプション名
    Dim vntArrOrgSName()        As Variant          '団体略称名
    Dim vntArrOptMsg()          As Variant          'オプションメッセージ(年:年齢,性:性別,受:受診区分)
    Dim vntArrP_Age()           As Variant          '現在の契約からの受診時年齢
    Dim vntArrLimitFlg()        As Variant          '限度額フラグ(0:限度額と一致,1:限度額と違う)

    Dim vntArrMOrgCd12()        As Variant          '負担元コード１
    Dim vntArrMOrgCd22()        As Variant          '負担元コード２
    Dim vntArrMPrice2()         As Variant          '金額(CONSULT_M)
    Dim vntArrMTax2()           As Variant          '消費税(CONSULT_M)
    Dim vntArrCPrice2()         As Variant          '金額(CTRPT_PRICE)
    Dim vntArrCTax2()           As Variant          '消費税(CTRPT_PRICE)
    Dim vntArrCtrPtCd2()        As Variant          '契約パターンコード
    Dim vntArrOptCd2()          As Variant          'オプションコード
    Dim vntArrOptBranchNo2()    As Variant          'オプション枝番
    Dim vntArrOptName2()        As Variant          'オプション名
    Dim vntArrOrgSName2()       As Variant          '団体略称名
    Dim vntArrOptMsg2()         As Variant          'オプションメッセージ(年:年齢,性:性別,受:受診区分)
    Dim lngPriceCount           As Long             '金額件数
    Dim blnLimitFlg             As Boolean          '限度額フラグ

    Dim i                       As Long             'インデックス
    Dim dtmDate                 As Date             '作業用の日付
    Dim blnTargetFlg            As Boolean          '対象フラグ
    Dim strAge                  As Variant          '年齢
    Dim strP_Age                As Variant          '現在の契約からの受診時年齢

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectConsult = -1

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntMOrgCd1) Then vntMOrgCd1 = Empty
    If Not IsMissing(vntMOrgCd2) Then vntMOrgCd2 = Empty
    If Not IsMissing(vntMPrice) Then vntMPrice = Empty
    If Not IsMissing(vntMTax) Then vntMTax = Empty
    If Not IsMissing(vntCPrice) Then vntCPrice = Empty
    If Not IsMissing(vntCTax) Then vntCTax = Empty
    If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = Empty
    If Not IsMissing(vntOptCd) Then vntOptCd = Empty
    If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = Empty
    If Not IsMissing(vntOptName) Then vntOptName = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntOptMsg) Then vntOptMsg = Empty
    If Not IsMissing(vntP_Age) Then vntP_Age = Empty
    If Not IsMissing(vntLimitFlg) Then vntLimitFlg = Empty

    '受診日の設定
    Select Case True

        '双方とも未指定の場合は何もしない
        Case dtmStrCslDate = 0 And dtmEndCslDate = 0

        '一方が未指定の場合、もう一方の値と同値として扱う
        Case dtmStrCslDate > 0 And dtmEndCslDate = 0
            dtmEndCslDate = dtmStrCslDate
        Case dtmStrCslDate = 0 And dtmEndCslDate > 0
            dtmStrCslDate = dtmEndCslDate

        '双方とも指定されている場合、大小逆転時に入れ替えを行う
        Case Else
            If dtmEndCslDate < dtmStrCslDate Then
                dtmDate = dtmStrCslDate
                dtmStrCslDate = dtmEndCslDate
                dtmEndCslDate = dtmDate
            End If

    End Select

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGCD1", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "AGE", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CTRPTCD", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LIMITTAXFLG", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "GENDER", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDIVCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    Set objParaRsvNo = objOraParam("RSVNO")
    Set objParaOrgcd1 = objOraParam("ORGCD1")
    Set objParaOrgcd2 = objOraParam("ORGCD2")
    Set objParaAge = objOraParam("AGE")
    Set objParaCtrPtCd = objOraParam("CTRPTCD")
    Set objParaLimitTaxFlg = objOraParam("LIMITTAXFLG")
    Set objParaGenDer = objOraParam("GENDER")
    Set objParaCslDivCd = objOraParam("CSLDIVCD")

    '検索条件を満たす受診情報のレコードを取得
    strStmt = "SELECT CONSULT.RSVNO, CONSULT.CSLDATE,                               " & vbLf & _
              "       CONSULT.PERID, CONSULT.CSCD,                                  " & vbLf & _
              "       CONSULT.ORGCD1, CONSULT.ORGCD2,                               " & vbLf & _
              "       CONSULT.AGE,                                                  " & vbLf & _
              "       CONSULT.CSLDIVCD, PERSON.GENDER,                              " & vbLf & _
              "       PERSON.FIRSTNAME, PERSON.LASTNAME, COURSE_P.CSNAME,           " & vbLf & _
              "       GETCSLAGE(PERSON.BIRTH, CONSULT.CSLDATE, CTRPT.AGECALC) P_AGE," & vbLf & _
              "       CONSULT.CTRPTCD AS P_CTRPTCD                                  " & vbLf & _
              "  FROM CONSULT, PERSON, COURSE_P, CTRPT                              " & vbLf & _
              " WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE           " & vbLf & _
              "   AND CONSULT.PERID = PERSON.PERID                                  " & vbLf & _
              "   AND CONSULT.CSCD  = COURSE_P.CSCD                                 " & vbLf & _
              "   AND CONSULT.CTRPTCD  = CTRPT.CTRPTCD                              " & vbLf & _
              " ORDER BY CONSULT.CSLDATE, CONSULT.RSVNO                             "

    '受診金額確定と契約の情報を取得するＳＱＬ
    strStmt2 = "SELECT CCON.ORGCD1,CCON.ORGCD2,                                     " & vbLf & _
               "       NVL(CONSULT_M.PRICE, 0) MPRICE, NVL(CONSULT_M.TAXPRICE, 0) MTAX, " & vbLf & _
               "       CCON.CPRICE, CCON.CTAX,                                      " & vbLf & _
               "       CCON.CTRPTCD, CCON.OPTCD, CCON.OPTBRANCHNO,                  " & vbLf & _
               "       CCON.OPTNAME, ORG.ORGSNAME, CCON.OPTAGESEQ,                  " & vbLf & _
               "       CCON.GENDER OPTGENDER, CCON.CSLDIVCD OPTCSLDIVCD             " & vbLf & _
               "  FROM ORG, CONSULT_M,                                              "

    '契約取得
    strStmt2 = strStmt2 & vbLf & _
                "(SELECT NVL(CTRPT_ORG.ORGCD1,:ORGCD1) ORGCD1, NVL(CTRPT_ORG.ORGCD2,:ORGCD2) ORGCD2,        " & vbLf & _
                "        NVL(CTRPT_PRICE.PRICE,0) AS CPRICE, NVL(CTRPT_PRICE.TAX,0) AS CTAX,                " & vbLf & _
                "        CONSULT_O.CTRPTCD, CONSULT_O.OPTCD, CONSULT_O.OPTBRANCHNO,                         " & vbLf & _
                "        CTRPT_OPT.OPTNAME,NVL(CTRPT_OPTAGE.SEQ,'0') OPTAGESEQ,                             " & vbLf & _
                "        CTRPT_OPT.GENDER, CTRPT_OPT.CSLDIVCD, CONSULT_O.RSVNO                              " & vbLf & _
                "   FROM CONSULT_O,CTRPT_OPTAGE,                                                            " & vbLf & _
                "        CTRPT_ORG, CTRPT_OPT, CTRPT_PRICE                                                  "

                
    strStmt2 = strStmt2 & vbLf & _
                " WHERE CTRPT_OPT.CTRPTCD     = CTRPT_PRICE.CTRPTCD                                         " & vbLf & _
                "   AND CTRPT_OPT.OPTCD       = CTRPT_PRICE.OPTCD                                           " & vbLf & _
                "   AND CTRPT_OPT.OPTBRANCHNO = CTRPT_PRICE.OPTBRANCHNO                                     " & vbLf & _
                "   AND CTRPT_PRICE.CTRPTCD   = CTRPT_ORG.CTRPTCD                                           " & vbLf & _
                "   AND CTRPT_PRICE.SEQ       = CTRPT_ORG.SEQ                                               " & vbLf & _
                "   AND CONSULT_O.RSVNO       = :RSVNO                                                      " & vbLf & _
                "   AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD                                           " & vbLf & _
                "   AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD                                             " & vbLf & _
                "   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO                                       " & vbLf & _
                "   AND CONSULT_O.CTRPTCD     = CTRPT_OPTAGE.CTRPTCD(+)                                     " & vbLf & _
                "   AND CONSULT_O.OPTCD       = CTRPT_OPTAGE.OPTCD(+)                                       " & vbLf & _
                "   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPTAGE.OPTBRANCHNO(+)                                 " & vbLf & _
                "   AND TO_CHAR(:AGE,'999') BETWEEN CTRPT_OPTAGE.STRAGE(+)  AND CTRPT_OPTAGE.ENDAGE(+)      " & vbLf & _
                ") CCON                                                                                     "

    strStmt2 = strStmt2 & vbLf & _
                " WHERE CCON.RSVNO                  = CONSULT_M.RSVNO(+)                                    " & vbLf & _
                "   AND CCON.ORGCD1                 = CONSULT_M.ORGCD1(+)                                   " & vbLf & _
                "   AND CCON.ORGCD2                 = CONSULT_M.ORGCD2(+)                                   " & vbLf & _
                "   AND CCON.CTRPTCD                = CONSULT_M.CTRPTCD(+)                                  " & vbLf & _
                "   AND CCON.OPTCD                  = CONSULT_M.OPTCD(+)                                    " & vbLf & _
                "   AND CCON.OPTBRANCHNO            = CONSULT_M.OPTBRANCHNO(+)                              "
    strStmt2 = strStmt2 & vbLf & _
                "   AND (CCON.CPRICE               != NVL((SELECT PRICE FROM CONSULT_M                          " & vbLf & _
                                                     "      WHERE CCON.RSVNO       = CONSULT_M.RSVNO(+)         " & vbLf & _
                                                     "        AND CCON.ORGCD1      = CONSULT_M.ORGCD1(+)        " & vbLf & _
                                                     "        AND CCON.ORGCD2      = CONSULT_M.ORGCD2(+)        " & vbLf & _
                                                     "        AND CCON.CTRPTCD     = CONSULT_M.CTRPTCD(+)       " & vbLf & _
                                                     "        AND CCON.OPTCD       = CONSULT_M.OPTCD(+)         " & vbLf & _
                                                     "        AND CCON.OPTBRANCHNO = CONSULT_M.OPTBRANCHNO(+)   " & vbLf & _
                                                     "    ), 0)                                                 "
    strStmt2 = strStmt2 & vbLf & _
                "    OR  CCON.CTAX                 != NVL((SELECT TAXPRICE FROM CONSULT_M                       " & vbLf & _
                                                     "      WHERE CCON.RSVNO       = CONSULT_M.RSVNO(+)         " & vbLf & _
                                                     "        AND CCON.ORGCD1      = CONSULT_M.ORGCD1(+)        " & vbLf & _
                                                     "        AND CCON.ORGCD2      = CONSULT_M.ORGCD2(+)        " & vbLf & _
                                                     "        AND CCON.CTRPTCD     = CONSULT_M.CTRPTCD(+)       " & vbLf & _
                                                     "        AND CCON.OPTCD       = CONSULT_M.OPTCD(+)         " & vbLf & _
                                                     "        AND CCON.OPTBRANCHNO = CONSULT_M.OPTBRANCHNO(+)   " & vbLf & _
                                                     "    ), 0)                                                 "
    strStmt2 = strStmt2 & vbLf & _
                "    OR  CCON.OPTAGESEQ             = 0                                                     " & vbLf & _
                "    OR (CCON.GENDER               != 0                                                     " & vbLf & _
                "   AND  CCON.GENDER               != :GENDER)                                              " & vbLf & _
                "    OR (CCON.CSLDIVCD             != 'CSLDIV000'                                           " & vbLf & _
                "   AND  CCON.CSLDIVCD             != :CSLDIVCD                                             " & vbLf & _
                "   AND  :CSLDIVCD                 != 'CSLDIV000'))                                         " & vbLf & _
                "   AND CCON.ORGCD1                 = ORG.ORGCD1(+)                                         " & vbLf & _
                "   AND CCON.ORGCD2                 = ORG.ORGCD2(+)                                         " & vbLf & _
                " ORDER BY CCON.ORGCD1, CCON.ORGCD2,                                                        " & vbLf & _
                "          CCON.CTRPTCD, CCON.OPTCD, CCON.OPTBRANCHNO                                       "

    'パターン情報取得
    strStmt3 = strStmt3 & vbLf & _
                "SELECT LIMITRATE, LIMITTAXFLG, LIMITPRICE      " & vbLf & _
                "  FROM CTRPT                                   " & vbLf & _
                " WHERE CTRPTCD = :CTRPTCD                      " & vbLf & _
                "   AND LIMITRATE > 0                           " & vbLf

    '限度額取得
    strStmt4 = strStmt4 & vbLf & _
                "SELECT NVL(TOTALPRICE, 0) TOTALPRICE                                                                           " & vbLf & _
                "  FROM ( SELECT CASE WHEN :LIMITTAXFLG = 0 THEN SUM(CONSULT_M.PRICE + CONSULT_M.EDITPRICE)                     " & vbLf & _
                "                ELSE SUM(CONSULT_M.PRICE + CONSULT_M.EDITPRICE + CONSULT_M.TAXPRICE + CONSULT_M.EDITTAX)       " & vbLf & _
                "                END TOTALPRICE                                                                                 " & vbLf & _
                "           FROM CTRPT_OPT, CONSULT_M,                                                                          " & vbLf & _
                "              ( SELECT DISTINCT NVL(CTRPT_ORG.ORGCD1, :ORGCD1) ORGCD1, NVL(CTRPT_ORG.ORGCD2, :ORGCD2) ORGCD2   " & vbLf & _
                "                  FROM CTRPT_ORG                                                                               " & vbLf & _
                "                 WHERE CTRPT_ORG.CTRPTCD = :CTRPTCD                                                            " & vbLf & _
                "                   AND CTRPT_ORG.LIMITPRICEFLG = 0                                                             " & vbLf & _
                "              ) TARGETORG                                                                                      " & vbLf & _
                "          WHERE CONSULT_M.RSVNO = :RSVNO                                                                       " & vbLf & _
                "            AND CONSULT_M.ORGCD1 = TARGETORG.ORGCD1                                                            " & vbLf & _
                "            AND CONSULT_M.ORGCD2 = TARGETORG.ORGCD2                                                            " & vbLf & _
                "            AND CTRPT_OPT.CTRPTCD = CONSULT_M.CTRPTCD                                                          " & vbLf & _
                "            AND CTRPT_OPT.OPTCD   = CONSULT_M.OPTCD                                                            " & vbLf & _
                "            AND CTRPT_OPT.OPTBRANCHNO = CONSULT_M.OPTBRANCHNO                                                  " & vbLf & _
                "            AND CTRPT_OPT.EXCEPTLIMIT IS NULL                                                                  " & vbLf & _
                "            AND OTHERLINEDIVCD IS NULL                                                                         " & vbLf & _
                "       ) LASTVIEW                                                                                              " & vbLf

    '限度額(現在のCONSULT_Mの金額)取得
    strStmt5 = strStmt5 & vbLf & _
                "SELECT CONSULT_M.PRICE                                                                                 " & vbLf & _
                "  FROM CONSULT_M,                                                                                      " & vbLf & _
                "     ( SELECT DISTINCT NVL(CTRPT_ORG.ORGCD1, :ORGCD1) ORGCD1, NVL(CTRPT_ORG.ORGCD2, :ORGCD2) ORGCD2    " & vbLf & _
                "         FROM CTRPT_ORG                                                                                " & vbLf & _
                "        WHERE CTRPT_ORG.CTRPTCD = :CTRPTCD                                                             " & vbLf & _
                "          AND CTRPT_ORG.LIMITPRICEFLG = 1                                                              " & vbLf & _
                "     ) TARGETORG                                                                                       " & vbLf & _
                " WHERE CONSULT_M.RSVNO = :RSVNO                                                                        " & vbLf & _
                "   AND CONSULT_M.ORGCD1 = TARGETORG.ORGCD1                                                             " & vbLf & _
                "   AND CONSULT_M.ORGCD2 = TARGETORG.ORGCD2                                                             " & vbLf & _
                "   AND CONSULT_M.CTRPTCD = :CTRPTCD                                                                    " & vbLf & _
                "   AND CONSULT_M.OPTCD = '0'                                                                           " & vbLf & _
                "   AND CONSULT_M.OPTBRANCHNO = 0                                                                       " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objPerId = objFields("PERID")
        Set objCsCd = objFields("CSCD")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objAge = objFields("AGE")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastName = objFields("LASTNAME")
        Set objCsName = objFields("CSNAME")
        Set objP_Age = objFields("P_AGE")
        Set objP_CtrPtCd = objFields("P_CTRPTCD")
        Set objGenDer = objFields("GENDER")
        Set objCslDivCd = objFields("CSLDIVCD")

        lngCount = 0

        '配列形式で格納する
        Do Until objOraDyna.EOF

            'キー値の設定
            objParaRsvNo.Value = CLng("0" & objRsvNo.Value)
            objParaOrgcd1.Value = objOrgCd1.Value
            objParaOrgcd2.Value = objOrgCd2.Value
            objParaAge.Value = objAge.Value
            objParaCtrPtCd.Value = objP_CtrPtCd.Value
            objParaGenDer.Value = objGenDer.Value
            objParaCslDivCd.Value = objCslDivCd.Value

            blnTargetFlg = False
            '' 年齢が違う人は対象とする
            If InStr(1, objAge.Value, ".") > 0 Then
                strAge = Mid(objAge.Value, 1, InStr(1, objAge.Value, ".") - 1)
            Else
                strAge = objAge.Value
            End If
            If InStr(1, objP_Age.Value, ".") > 0 Then
                strP_Age = Mid(objP_Age.Value, 1, InStr(1, objP_Age.Value, ".") - 1)
            Else
                strP_Age = objP_Age.Value
            End If
            If strAge <> strP_Age Then
                blnTargetFlg = True
            End If

            '限度額情報の編集
            blnLimitFlg = False
            Do
                '受診情報の存在しない行ならば処理を抜ける
                If objParaRsvNo.Value = 0 Then
                    Exit Do
                End If

                '初めてパターン情報を取得する場合
                If objOraDyna3 Is Nothing Then

                    'ダイナセットを新規作成
                    Set objOraDyna3 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt3), ORADYN_READONLY + ORADYN_NOCACHE)

                '２回目以降はRefreshで対応
                Else
                    objOraDyna3.Refresh
                End If

                If Not objOraDyna3.EOF Then

                    'オブジェクトの参照設定
                    Set objFields3 = objOraDyna3.Fields
                    Set objLimitRate = objFields3("LIMITRATE")
                    Set objLimitTaxFlg = objFields3("LIMITTAXFLG")
                    Set objLimitPrice = objFields3("LIMITPRICE")

                    objParaLimitTaxFlg.Value = objLimitTaxFlg.Value

                    vntLimitRate = CLng(objLimitRate.Value)
                    vntLimitTaxFlg = CLng(objLimitTaxFlg.Value)
                    vntLimitPrice = CLng(objLimitPrice.Value)

                    '初めて限度額情報を取得する場合
                    If objOraDyna4 Is Nothing Then
    
                        'ダイナセットを新規作成
                        Set objOraDyna4 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt4), ORADYN_READONLY + ORADYN_NOCACHE)
    
                    '２回目以降はRefreshで対応
                    Else
                        objOraDyna4.Refresh
                    End If

                    If Not objOraDyna4.EOF Then

                        'オブジェクトの参照設定
                        Set objFields4 = objOraDyna4.Fields
                        Set objTotalPrice = objFields4("TOTALPRICE")

                        vntTotalPrice = CLng(objTotalPrice.Value)
                        '' 負担率を掛ける
                        vntTotalPrice = vntTotalPrice * (vntLimitRate * 0.01)
                    Else
                        vntTotalPrice = 0
                    End If

                    If vntTotalPrice > 0 Then
                    
                        '' 負担金額合計が上限金額よりも大きいなら上限金額をセットする。
                        If vntLimitPrice <> 0 Then
                            If vntTotalPrice > CLng(vntLimitPrice) Then
                                vntTotalPrice = CLng(vntLimitPrice)
                            Else    '10\未満を切り捨て
                                vntTotalPrice = Fix(vntTotalPrice / 10) * 10
                            End If
                        End If

                        '初めて限度額情報[現在のCONSULT_Mの金額]を取得する場合
                        If objOraDyna5 Is Nothing Then
        
                            'ダイナセットを新規作成
                            Set objOraDyna5 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt5), ORADYN_READONLY + ORADYN_NOCACHE)
        
                        '２回目以降はRefreshで対応
                        Else
                            objOraDyna5.Refresh
                        End If

                        If Not objOraDyna5.EOF Then
    
                            'オブジェクトの参照設定
                            Set objFields5 = objOraDyna5.Fields
                            Set objPrice = objFields5("PRICE")
    
                            vntPrice = IIf(Not IsNull(objPrice.Value), CLng(objPrice.Value), 0)
                        Else
                            vntPrice = 0
                        End If

                        '再計算した限度額と現在CONSULT_Mに設定されている限度額を比較して違う場合は対象とする
                        If vntTotalPrice <> vntPrice Then
                            blnLimitFlg = True
                        End If

                    End If

                End If
                '限度額情報が存在する場合は対象とする
                If blnLimitFlg Then
                    blnTargetFlg = True
                End If

                Exit Do

            Loop

            '金額情報の編集
            Do
                '受診情報の存在しない行ならば処理を抜ける
                If objParaRsvNo.Value = 0 Then
                    Exit Do
                End If

                '初めて追加検査を取得する場合
                If objOraDyna2 Is Nothing Then

                    'ダイナセットを新規作成
                    Set objOraDyna2 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt2), ORADYN_READONLY + ORADYN_NOCACHE)

                    'オブジェクトの参照設定
                    Set objFields2 = objOraDyna2.Fields
                    Set objMOrgcd1 = objFields2("ORGCD1")
                    Set objMOrgcd2 = objFields2("ORGCD2")
                    Set objMPrice = objFields2("MPRICE")
                    Set objMTax = objFields2("MTAX")
                    Set objCPrice = objFields2("CPRICE")
                    Set objCTax = objFields2("CTAX")
                    Set objCtrPtCd = objFields2("CTRPTCD")
                    Set objOptCd = objFields2("OPTCD")
                    Set objOptBranchNo = objFields2("OPTBRANCHNO")
                    Set objOptName = objFields2("OPTNAME")
                    Set objOrgSName = objFields2("ORGSNAME")
                    Set objOptAgeSeq = objFields2("OPTAGESEQ")
                    Set objOptGender = objFields2("OPTGENDER")
                    Set objOptCslDivCd = objFields2("OPTCSLDIVCD")

                '２回目以降はRefreshで対応
                Else
                    objOraDyna2.Refresh
                End If

                '配列形式で格納する
                lngPriceCount = 0
                Do Until objOraDyna2.EOF
                    ReDim Preserve vntArrMOrgCd12(lngPriceCount)
                    ReDim Preserve vntArrMOrgCd22(lngPriceCount)
                    ReDim Preserve vntArrMPrice2(lngPriceCount)
                    ReDim Preserve vntArrMTax2(lngPriceCount)
                    ReDim Preserve vntArrCPrice2(lngPriceCount)
                    ReDim Preserve vntArrCTax2(lngPriceCount)
                    ReDim Preserve vntArrCtrPtCd2(lngPriceCount)
                    ReDim Preserve vntArrOptCd2(lngPriceCount)
                    ReDim Preserve vntArrOptBranchNo2(lngPriceCount)
                    ReDim Preserve vntArrOptName2(lngPriceCount)
                    ReDim Preserve vntArrOrgSName2(lngPriceCount)
                    ReDim Preserve vntArrOptMsg2(lngPriceCount)
                    vntArrMOrgCd12(lngPriceCount) = objMOrgcd1.Value
                    vntArrMOrgCd22(lngPriceCount) = objMOrgcd2.Value
                    vntArrMPrice2(lngPriceCount) = objMPrice.Value
                    vntArrMTax2(lngPriceCount) = objMTax.Value
                    vntArrCPrice2(lngPriceCount) = objCPrice.Value
                    vntArrCTax2(lngPriceCount) = objCTax.Value
                    vntArrCtrPtCd2(lngPriceCount) = objCtrPtCd.Value
                    vntArrOptCd2(lngPriceCount) = objOptCd.Value
                    vntArrOptBranchNo2(lngPriceCount) = objOptBranchNo.Value
                    vntArrOptName2(lngPriceCount) = objOptName.Value
                    vntArrOrgSName2(lngPriceCount) = objOrgSName.Value
                    '' 返信メッセージは何が違うかを返す
                    If objOptAgeSeq.Value = 0 Then
                        vntArrOptMsg2(lngPriceCount) = "年"
                    ElseIf objOptGender.Value > 0 And _
                           objOptGender.Value <> objParaGenDer.Value Then
                        vntArrOptMsg2(lngPriceCount) = "性"
                    ElseIf objOptCslDivCd.Value <> "CSLDIV000" _
                       And objParaCslDivCd.Value <> "CSLDIV000" _
                       And objOptCslDivCd.Value <> objParaCslDivCd.Value Then
                        vntArrOptMsg2(lngPriceCount) = "受"
                    Else
                        vntArrOptMsg2(lngPriceCount) = ""
                    End If
                    lngPriceCount = lngPriceCount + 1
                    objOraDyna2.MoveNext
                Loop

                '金額情報が存在する場合は対象とする
                If lngPriceCount > 0 Then
                    blnTargetFlg = True
                End If

                Exit Do

            Loop

            '' 対象者のみ追加
            If blnTargetFlg Then

                ReDim Preserve vntArrRsvNo(lngCount)
                ReDim Preserve vntArrCslDate(lngCount)
                ReDim Preserve vntArrPerId(lngCount)
                ReDim Preserve vntArrCsCd(lngCount)
                ReDim Preserve vntArrOrgCd1(lngCount)
                ReDim Preserve vntArrOrgCd2(lngCount)
                ReDim Preserve vntArrAge(lngCount)
                ReDim Preserve vntArrFirstName(lngCount)
                ReDim Preserve vntArrLastName(lngCount)
                ReDim Preserve vntArrCsName(lngCount)
                ReDim Preserve vntArrMOrgCd1(lngCount)
                ReDim Preserve vntArrMOrgCd2(lngCount)
                ReDim Preserve vntArrMPrice(lngCount)
                ReDim Preserve vntArrMTax(lngCount)
                ReDim Preserve vntArrCPrice(lngCount)
                ReDim Preserve vntArrCTax(lngCount)
                ReDim Preserve vntArrCtrPtCd(lngCount)
                ReDim Preserve vntArrOptCd(lngCount)
                ReDim Preserve vntArrOptBranchNo(lngCount)
                ReDim Preserve vntArrOptName(lngCount)
                ReDim Preserve vntArrOrgSName(lngCount)
                ReDim Preserve vntArrOptMsg(lngCount)
                ReDim Preserve vntArrP_Age(lngCount)
                ReDim Preserve vntArrLimitFlg(lngCount)

                vntArrRsvNo(lngCount) = objRsvNo.Value & ""
                vntArrCslDate(lngCount) = objCslDate.Value & ""
                vntArrPerId(lngCount) = objPerId.Value & ""
                vntArrCsCd(lngCount) = objCsCd.Value & ""
                vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
                vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
                vntArrAge(lngCount) = strAge
                vntArrFirstName(lngCount) = objFirstName.Value & ""
                vntArrLastName(lngCount) = objLastName.Value & ""
                vntArrCsName(lngCount) = objCsName.Value & ""
                vntArrP_Age(lngCount) = strP_Age
                vntArrLimitFlg(lngCount) = IIf(blnLimitFlg, 1, 0)
                '金額情報が存在する場合はカンマ区切りで結合して格納する
                If lngPriceCount > 0 Then
                    vntArrMOrgCd1(lngCount) = Join(vntArrMOrgCd12, ",")
                    vntArrMOrgCd2(lngCount) = Join(vntArrMOrgCd22, ",")
                    vntArrMPrice(lngCount) = Join(vntArrMPrice2, ",")
                    vntArrMTax(lngCount) = Join(vntArrMTax2, ",")
                    vntArrCPrice(lngCount) = Join(vntArrCPrice2, ",")
                    vntArrCTax(lngCount) = Join(vntArrCTax2, ",")
                    vntArrCtrPtCd(lngCount) = Join(vntArrCtrPtCd2, ",")
                    vntArrOptCd(lngCount) = Join(vntArrOptCd2, ",")
                    vntArrOptBranchNo(lngCount) = Join(vntArrOptBranchNo2, ",")
                    vntArrOptName(lngCount) = Join(vntArrOptName2, ",")
                    vntArrOrgSName(lngCount) = Join(vntArrOrgSName2, ",")
                    vntArrOptMsg(lngCount) = Join(vntArrOptMsg2, ",")
                Else
                    vntArrMOrgCd1(lngCount) = ""
                    vntArrMOrgCd2(lngCount) = ""
                    vntArrMPrice(lngCount) = ""
                    vntArrMTax(lngCount) = ""
                    vntArrCPrice(lngCount) = ""
                    vntArrCTax(lngCount) = ""
                    vntArrCtrPtCd(lngCount) = ""
                    vntArrOptCd(lngCount) = ""
                    vntArrOptBranchNo(lngCount) = ""
                    vntArrOptName(lngCount) = ""
                    vntArrOrgSName(lngCount) = ""
                    vntArrOptMsg(lngCount) = ""
                End If

                lngCount = lngCount + 1
            End If

            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntMOrgCd1) Then vntMOrgCd1 = vntArrMOrgCd1
        If Not IsMissing(vntMOrgCd2) Then vntMOrgCd2 = vntArrMOrgCd2
        If Not IsMissing(vntMPrice) Then vntMPrice = vntArrMPrice
        If Not IsMissing(vntMTax) Then vntMTax = vntArrMTax
        If Not IsMissing(vntCPrice) Then vntCPrice = vntArrCPrice
        If Not IsMissing(vntCTax) Then vntCTax = vntArrCTax
        If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = vntArrCtrPtCd
        If Not IsMissing(vntOptCd) Then vntOptCd = vntArrOptCd
        If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = vntArrOptBranchNo
        If Not IsMissing(vntOptName) Then vntOptName = vntArrOptName
        If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
        If Not IsMissing(vntOptMsg) Then vntOptMsg = vntArrOptMsg
        If Not IsMissing(vntP_Age) Then vntP_Age = vntArrP_Age
        If Not IsMissing(vntLimitFlg) Then vntLimitFlg = vntArrLimitFlg

        SelectConsult = lngCount

    Else
        SelectConsult = 0 '件数なし

    End If

    Set objRsvNo = Nothing
    Set objCslDate = Nothing
    Set objPerId = Nothing
    Set objCsCd = Nothing
    Set objOrgCd1 = Nothing
    Set objOrgCd2 = Nothing
    Set objAge = Nothing
    Set objFirstName = Nothing
    Set objLastName = Nothing
    Set objCsName = Nothing
    Set objMOrgcd1 = Nothing
    Set objMOrgcd2 = Nothing
    Set objMPrice = Nothing
    Set objMTax = Nothing
    Set objCPrice = Nothing
    Set objCTax = Nothing
    Set objCtrPtCd = Nothing
    Set objOptCd = Nothing
    Set objOptBranchNo = Nothing
    Set objOptName = Nothing
    Set objOrgSName = Nothing
    Set objOptAgeSeq = Nothing
    Set objOptGender = Nothing
    Set objOptCslDivCd = Nothing
    Set objP_Age = Nothing
    Set objP_CtrPtCd = Nothing
    Set objFields5 = Nothing
    Set objFields4 = Nothing
    Set objFields3 = Nothing
    Set objFields2 = Nothing
    Set objFields = Nothing
    Set objOraDyna5 = Nothing
    Set objOraDyna4 = Nothing
    Set objOraDyna3 = Nothing
    Set objOraDyna2 = Nothing
    Set objOraDyna = Nothing
    Set objParaRsvNo = Nothing
    Set objParaOrgcd1 = Nothing
    Set objParaOrgcd2 = Nothing
    Set objParaAge = Nothing
    Set objParaCtrPtCd = Nothing
    Set objParaLimitTaxFlg = Nothing
    Set objParaGenDer = Nothing
    Set objParaCslDivCd = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "FailSafe.SelectConsult"

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
' 機能　　 : 指定予約番号の受診金額確定を取得する。
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntPrice              金額
' 　　　　   (Out)    vntEditPrice          調整金額
' 　　　　   (Out)    vntTaxPrice           税額
' 　　　　   (Out)    vntEditTax            税調整税額
' 　　　　   (Out)    vntCtrPtCd            契約パターンコード
' 　　　　   (Out)    vntOptCd              オプションコード
' 　　　　   (Out)    vntOptBranchNo        オプション枝番
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult_m( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntOrgCd1 As Variant, _
    Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntPrice As Variant, _
    Optional ByRef vntEditPrice As Variant, _
    Optional ByRef vntTaxPrice As Variant, _
    Optional ByRef vntEditTax As Variant, _
    Optional ByRef vntCtrPtCd As Variant, _
    Optional ByRef vntOptCd As Variant, _
    Optional ByRef vntOptBranchNo As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim lngCount                As Long

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOrgCd1               As Object           '団体コード１
    Dim objOrgCd2               As Object           '団体コード２
    Dim objPrice                As Object           '金額
    Dim objEditPrice            As Object           '調整金額
    Dim objTaxPrice             As Object           '税額
    Dim objEditTax              As Object           '税調整税額
    Dim objCtrPtCd              As Object           '契約パターンコード
    Dim objOptCd                As Object           'オプションコード
    Dim objOptBranchNo          As Object           'オプション枝番

    Dim vntArrOrgCd1()          As Variant          '団体コード１
    Dim vntArrOrgCd2()          As Variant          '団体コード２
    Dim vntArrPrice()           As Variant          '金額
    Dim vntArrEditPrice()       As Variant          '調整金額
    Dim vntArrTaxPrice()        As Variant          '税額
    Dim vntArrEditTax()         As Variant          '税調整税額
    Dim vntArrCtrPtCd()         As Variant          '契約パターンコード
    Dim vntArrOptCd()           As Variant          'オプションコード
    Dim vntArrOptBranchNo()     As Variant          'オプション枝番

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectConsult_m = -1

    '初期処理
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntEditPrice) Then vntEditPrice = Empty
    If Not IsMissing(vntTaxPrice) Then vntTaxPrice = Empty
    If Not IsMissing(vntEditTax) Then vntEditTax = Empty
    If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = Empty
    If Not IsMissing(vntOptCd) Then vntOptCd = Empty
    If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす受診金額確定テーブルのレコードを取得
    strStmt = "SELECT CONSULT_M.ORGCD1, CONSULT_M.ORGCD2,                           " & vbLf & _
              "       CONSULT_M.PRICE, CONSULT_M.EDITPRICE,                         " & vbLf & _
              "       CONSULT_M.TAXPRICE, CONSULT_M.EDITTAX,                        " & vbLf & _
              "       CONSULT_O.CTRPTCD, CONSULT_O.OPTCD, CONSULT_O.OPTBRANCHNO     " & vbLf & _
              "  FROM CONSULT_M,CONSULT_O                                           " & vbLf & _
              " WHERE CONSULT_O.RSVNO       = :RSVNO                                " & vbLf & _
              "   AND CONSULT_O.RSVNO       = CONSULT_M.RSVNO(+)                    " & vbLf & _
              "   AND CONSULT_O.CTRPTCD     = CONSULT_M.CTRPTCD(+)                  " & vbLf & _
              "   AND CONSULT_O.OPTCD       = CONSULT_M.OPTCD(+)                    " & vbLf & _
              "   AND CONSULT_O.OPTBRANCHNO = CONSULT_M.OPTBRANCHNO(+)              " & vbLf & _
              " ORDER BY CONSULT_O.CTRPTCD, CONSULT_O.OPTCD, CONSULT_O.OPTBRANCHNO  "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITTAX")
        Set objCtrPtCd = objFields("CTRPTCD")
        Set objOptCd = objFields("OPTCD")
        Set objOptBranchNo = objFields("OPTBRANCHNO")

        lngCount = 0

        '配列形式で格納する
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrCtrPtCd(lngCount)
            ReDim Preserve vntArrOptCd(lngCount)
            ReDim Preserve vntArrOptBranchNo(lngCount)

            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrEditPrice(lngCount) = objEditPrice.Value & ""
            vntArrTaxPrice(lngCount) = objTaxPrice.Value & ""
            vntArrEditTax(lngCount) = objEditTax.Value & ""
            vntArrCtrPtCd(lngCount) = objCtrPtCd.Value & ""
            vntArrOptCd(lngCount) = objOptCd.Value & ""
            vntArrOptBranchNo(lngCount) = objOptBranchNo.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
        If Not IsMissing(vntPrice) Then vntPrice = vntArrPrice
        If Not IsMissing(vntEditPrice) Then vntEditPrice = vntArrEditPrice
        If Not IsMissing(vntTaxPrice) Then vntTaxPrice = vntArrTaxPrice
        If Not IsMissing(vntEditTax) Then vntEditTax = vntArrEditTax
        If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = vntArrCtrPtCd
        If Not IsMissing(vntOptCd) Then vntOptCd = vntArrOptCd
        If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = vntArrOptBranchNo

        SelectConsult_m = lngCount

    Else
        SelectConsult_m = 0 '件数なし

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
    WriteErrorLog "FailSafe.SelectConsult_m"

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
' 機能　　 : 指定予約番号の受診金額確定を取得する。
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (In)     strOrgCd1             団体コード１
' 　　　　   (In)     strOrgCd2             団体コード２
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntPrice              負担金額
' 　　　　   (Out)    vntTax                消費税
' 　　　　   (Out)    vntCtrPtCd            契約パターンコード
' 　　　　   (Out)    vntOptCd              オプションコード
' 　　　　   (Out)    vntOptBranchNo        オプション枝番
' 　　　　   (Out)    vntOptName            オプション名
'
' 戻り値　 :  >=0   レコード件数
' 　　　　    < 0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrpt_Opt( _
    ByVal lngRsvNo As Long, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    Optional ByRef vntOrgCd1 As Variant, _
    Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntPrice As Variant, _
    Optional ByRef vntTax As Variant, _
    Optional ByRef vntCtrPtCd As Variant, _
    Optional ByRef vntOptCd As Variant, _
    Optional ByRef vntOptBranchNo As Variant, _
    Optional ByRef vntOptName As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim lngCount                As Long

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOrgCd1               As Object           '団体コード１
    Dim objOrgCd2               As Object           '団体コード２
    Dim objPrice                As Object           '金額
    Dim objTax                  As Object           '消費税
    Dim objCtrPtCd              As Object           '契約パターンコード
    Dim objOptCd                As Object           'オプションコード
    Dim objOptBranchNo          As Object           'オプション枝番
    Dim objOptName              As Object           'オプション名

    Dim vntArrOrgCd1()          As Variant          '団体コード１
    Dim vntArrOrgCd2()          As Variant          '団体コード２
    Dim vntArrPrice()           As Variant          '金額
    Dim vntArrTax()             As Variant          '消費税
    Dim vntArrCtrPtCd()         As Variant          '契約パターンコード
    Dim vntArrOptCd()           As Variant          'オプションコード
    Dim vntArrOptBranchNo()     As Variant          'オプション枝番
    Dim vntArrOptName()         As Variant          'オプション名

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    SelectCtrpt_Opt = -1

    '初期処理
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntTax) Then vntTax = Empty
    If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = Empty
    If Not IsMissing(vntOptCd) Then vntOptCd = Empty
    If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = Empty
    If Not IsMissing(vntOptName) Then vntOptName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす受診金額確定テーブルのレコードを取得
    strStmt = "SELECT BASEOPT.ORGCD1, BASEOPT.ORGCD2,                               " & vbLf & _
              "       BASEOPT.PRICE, BASEOPT.TAX,                                   " & vbLf & _
              "       CONSULT_O.CTRPTCD, CONSULT_O.OPTCD, CONSULT_O.OPTBRANCHNO,    " & vbLf & _
              "       BASEOPT.OPTNAME                                               " & vbLf & _
              "  FROM CONSULT_O,                                                    " & vbLf

    strStmt = strStmt & "(SELECT CTRPT_ORG.ORGCD1, CTRPT_ORG.ORGCD2,                            " & vbLf & _
                        "        CTRPT_PRICE.PRICE, CTRPT_PRICE.TAX,                            " & vbLf & _
                        "        CTRPT_OPT.CTRPTCD, CTRPT_OPT.OPTCD, CTRPT_OPT.OPTBRANCHNO,     " & vbLf & _
                        "        CTRPT_OPT.OPTNAME                                              " & vbLf & _
                        "   FROM CTRPT_ORG,CTRPT_OPT,CTRPT_PRICE                                " & vbLf & _
                        "  WHERE CTRPT_OPT.CTRPTCD     = CTRPT_PRICE.CTRPTCD                    " & vbLf & _
                        "    AND CTRPT_OPT.OPTCD       = CTRPT_PRICE.OPTCD                      " & vbLf & _
                        "    AND CTRPT_OPT.OPTBRANCHNO = CTRPT_PRICE.OPTBRANCHNO                " & vbLf & _
                        "    AND CTRPT_PRICE.CTRPTCD   = CTRPT_ORG.CTRPTCD                      " & vbLf & _
                        "    AND CTRPT_PRICE.SEQ       = CTRPT_ORG.SEQ                          " & vbLf & _
                        ") BASEOPT                                                              " & vbLf

    strStmt = strStmt & " WHERE CONSULT_O.RSVNO       = :RSVNO                                  " & vbLf & _
                        "   AND CONSULT_O.CTRPTCD     = BASEOPT.CTRPTCD(+)                      " & vbLf & _
                        "   AND CONSULT_O.OPTCD       = BASEOPT.OPTCD(+)                        " & vbLf & _
                        "   AND CONSULT_O.OPTBRANCHNO = BASEOPT.OPTBRANCHNO(+)                  " & vbLf & _
                        " ORDER BY CONSULT_O.CTRPTCD, CONSULT_O.OPTCD, CONSULT_O.OPTBRANCHNO    "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objPrice = objFields("PRICE")
        Set objTax = objFields("TAX")
        Set objCtrPtCd = objFields("CTRPTCD")
        Set objOptCd = objFields("OPTCD")
        Set objOptBranchNo = objFields("OPTBRANCHNO")
        Set objOptName = objFields("OPTNAME")

        lngCount = 0

        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrCtrPtCd(lngCount)
            ReDim Preserve vntArrOptCd(lngCount)
            ReDim Preserve vntArrOptBranchNo(lngCount)
            ReDim Preserve vntArrOptName(lngCount)

            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrTax(lngCount) = objTax.Value & ""
            vntArrCtrPtCd(lngCount) = objCtrPtCd.Value & ""
            vntArrOptCd(lngCount) = objOptCd.Value & ""
            vntArrOptBranchNo(lngCount) = objOptBranchNo.Value & ""
            vntArrOptName(lngCount) = objOptName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
        If Not IsMissing(vntPrice) Then vntPrice = vntArrPrice
        If Not IsMissing(vntTax) Then vntTax = vntArrTax
        If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = vntArrCtrPtCd
        If Not IsMissing(vntOptCd) Then vntOptCd = vntArrOptCd
        If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = vntArrOptBranchNo
        If Not IsMissing(vntOptName) Then vntOptName = vntArrOptName

        SelectCtrpt_Opt = lngCount

    Else
        SelectCtrpt_Opt = 0 '件数なし

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
    WriteErrorLog "FailSafe.SelectCtrpt_Opt"

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
'
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
