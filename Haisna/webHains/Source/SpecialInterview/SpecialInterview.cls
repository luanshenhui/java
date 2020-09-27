VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "SpecialInterview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext                 As ObjectContext     'オブジェクトコンテキスト

Private mobjOraSession              As OraSession        'OraSessionオブジェクト
Private mobjOraDb                   As OraDatabase       'OraDatabaseオブジェクト
 
Private Const CTRPT_SETCLASSCD      As String = "660"    '契約情報の特定健診セット分類コード

'桁数
Private Const LENGTH_TOTALJUDCMT_RSVNO    As Integer = 9      '予約番号
Private Const LENGTH_TOTALJUDCMT_DISPMODE As Integer = 2      '表示分類
Private Const LENGTH_TOTALJUDCMT_SEQ      As Integer = 3      '表示順
Private Const LENGTH_TOTALJUDCMT_JUDCMTCD As Integer = 8      '判定コメントコード

Private Const FOOD_JUDCLASSCD       As Integer = 51      '食習慣
Private Const MENU_JUDCLASSCD       As Integer = 52      '献立
Private Const LIFE_JUDCLASSCD       As Integer = 50      '生活指導
Private Const SPECIAL_JUDCLASSCD    As Integer = 90      '特定健診

Private Const SHINTAI_GRPCD         As String = "X076"   '身体計測
Private Const KETUATU_GRPCD         As String = "X077"   '血圧
Private Const KETSYUSISITSU_GRPCD   As String = "X078"   '血中脂質
Private Const KANKINOU_GRPCD        As String = "X079"   '肝機能
Private Const KETTOU_GRPCD          As String = "X080"   '唐代謝
Private Const NYOU_GRPCD            As String = "X081"   '血液一般
Private Const SMOKE_GRPCD           As String = "X082"   '喫煙

Private Const SDI_RSLCNT                  As Integer = 33     '多変量解析に必要な検査項目件数
Private Const STATISTICS_GRPCD            As String = "X050"  '多変量解析用検査項目のグループコード

'
' 機能   : 指定予約番号の契約情報の中の特定健診セット情報を取得する
'
' 引数   :  (In)     lngRsvNo       　　予約番号
'           (In)     strSetClassCd  　　契約情報内のセット分類コード
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了

Public Function SelectSetClassCd(ByVal lngRsvNo As Long _
                                ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    SelectSetClassCd = False

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SETCLASSCD", CTRPT_SETCLASSCD, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号の契約情報の中の特定健診セット情報を取得する
    strStmt = "SELECT CTRPT_OPT.SETCLASSCD                                " & vbLf & _
              "  FROM CONSULT,                                            " & vbLf & _
              "       RECEIPT,                                            " & vbLf & _
              "       CONSULT_O,                                          " & vbLf & _
              "       CTRPT_OPT                                           "
    strStmt = strStmt & _
              " WHERE CONSULT.RSVNO   = :RSVNO                            " & vbLf & _
              "   AND CONSULT.RSVNO   = RECEIPT.RSVNO                     " & vbLf & _
              "   AND CONSULT.CANCELFLG = 0                               " & vbLf & _
              "   AND CONSULT.RSVNO = CONSULT_O.RSVNO                     " & vbLf & _
              "   AND CONSULT_O.CTRPTCD = CTRPT_OPT.CTRPTCD               " & vbLf & _
              "   AND CONSULT_O.OPTCD = CTRPT_OPT.OPTCD                   " & vbLf & _
              "   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO       " & vbLf & _
              "   AND CTRPT_OPT.SETCLASSCD = :SETCLASSCD                  "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        SelectSetClassCd = True

    End If

    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectSetClassCd = False

    'イベントログ書き込み
    WriteErrorLog "SpecialInterview.SelectSetClassCd"

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
' 機能   : 指定予約番号の契約情報の中の特定健診セット情報を取得する
'
' 引数   :  (In)     lngRsvNo       　　予約番号
'           (In)     strSetClassCd  　　契約情報内のセット分類コード
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了

Public Function CheckSetClassCd(ByVal lngRsvNo As Long, _
                                ByVal strSetClassCd As String _
                                ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    CheckSetClassCd = False

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SETCLASSCD", strSetClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号の契約情報の中の特定健診セット情報を取得する
    strStmt = "SELECT CTRPT_OPT.SETCLASSCD                                " & vbLf & _
              "  FROM CONSULT,                                            " & vbLf & _
              "       RECEIPT,                                            " & vbLf & _
              "       CONSULT_O,                                          " & vbLf & _
              "       CTRPT_OPT                                           "
    strStmt = strStmt & _
              " WHERE CONSULT.RSVNO   = :RSVNO                            " & vbLf & _
              "   AND CONSULT.RSVNO   = RECEIPT.RSVNO                     " & vbLf & _
              "   AND CONSULT.CANCELFLG = 0                               " & vbLf & _
              "   AND CONSULT.RSVNO = CONSULT_O.RSVNO                     " & vbLf & _
              "   AND CONSULT_O.CTRPTCD = CTRPT_OPT.CTRPTCD               " & vbLf & _
              "   AND CONSULT_O.OPTCD = CTRPT_OPT.OPTCD                   " & vbLf & _
              "   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO       " & vbLf & _
              "   AND CTRPT_OPT.SETCLASSCD = :SETCLASSCD                  "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        CheckSetClassCd = True

    End If

    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    CheckSetClassCd = False

    'イベントログ書き込み
    WriteErrorLog "SpecialInterview.CheckSetClassCd"

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

'### 2013.03.26 特定保健指導対象者チェックの為追加　Start ###
Public Function CheckSpecialTarget(ByVal lngRsvNo As Long) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    CheckSpecialTarget = -1

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SETCLASSCD", CTRPT_SETCLASSCD, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号の契約情報の中の「特定健診階層化」セットがチェックされ、団体別対象年齢に当てはまる受診者チェック

    strStmt = "SELECT CONSULT.RSVNO                                    " & vbLf & _
              "  FROM CONSULT                                          " & vbLf & _
              "      ,RECEIPT                                          " & vbLf & _
              "      ,CONSULT_O                                        " & vbLf & _
              "      ,CTRPT_OPT                                        " & vbLf & _
              "      ,FREE                                             "

'### 2015.03.23 特定保健指導対象者チェックロジック変更（該当団体、契約期間、対象年齢チェック）Start ###
'    strStmt = strStmt & _
'              " WHERE CONSULT.RSVNO        = :RSVNO                    " & vbLf & _
'              "   AND CONSULT.RSVNO        = RECEIPT.RSVNO             " & vbLf & _
'              "   AND CONSULT.CANCELFLG    = 0                         " & vbLf & _
'              "   AND CONSULT.RSVNO        = CONSULT_O.RSVNO           " & vbLf & _
'              "   AND CONSULT_O.CTRPTCD    = CTRPT_OPT.CTRPTCD         " & vbLf & _
'              "   AND CONSULT_O.OPTCD      = CTRPT_OPT.OPTCD           " & vbLf & _
'              "   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO    " & vbLf & _
'              "   AND CTRPT_OPT.SETCLASSCD = :SETCLASSCD               " & vbLf & _
'              "   AND FREE.FREECD          LIKE 'SPC%'                 " & vbLf & _
'              "   AND CONSULT.ORGCD1       = FREE.FREEFIELD1           " & vbLf & _
'              "   AND CONSULT.ORGCD2       = FREE.FREEFIELD2           " & vbLf & _
'              "   AND TRUNC(CONSULT.AGE) BETWEEN TO_NUMBER(FREE.FREEFIELD3) AND TO_NUMBER(FREE.FREEFIELD4)  "

    strStmt = strStmt & _
              " WHERE CONSULT.RSVNO        = :RSVNO                    " & vbLf & _
              "   AND CONSULT.RSVNO        = RECEIPT.RSVNO             " & vbLf & _
              "   AND CONSULT.CANCELFLG    = 0                         " & vbLf & _
              "   AND CONSULT.RSVNO        = CONSULT_O.RSVNO           " & vbLf & _
              "   AND CONSULT_O.CTRPTCD    = CTRPT_OPT.CTRPTCD         " & vbLf & _
              "   AND CONSULT_O.OPTCD      = CTRPT_OPT.OPTCD           " & vbLf & _
              "   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO    " & vbLf & _
              "   AND CTRPT_OPT.SETCLASSCD = :SETCLASSCD               " & vbLf & _
              "   AND FREE.FREECD          LIKE 'SPC%'                 " & vbLf & _
              "   AND CONSULT.ORGCD1       = FREE.FREEFIELD1           " & vbLf & _
              "   AND CONSULT.ORGCD2       = FREE.FREEFIELD2           " & vbLf & _
              "   AND TRUNC(CONSULT.AGE)   BETWEEN TO_NUMBER(FREE.FREEFIELD3) AND TO_NUMBER(FREE.FREEFIELD4)  " & vbLf & _
              "   AND CONSULT.CSLDATE      BETWEEN TO_DATE(FREE.FREEFIELD5, 'YYYY/MM/DD') AND TO_DATE(FREE.FREEFIELD6, 'YYYY/MM/DD')  "

'### 2015.03.23 特定保健指導対象者チェックロジック変更（該当団体、契約期間、対象年齢チェック）End   ###

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        CheckSpecialTarget = 1

    End If

    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    CheckSpecialTarget = -1

    'イベントログ書き込み
    WriteErrorLog "SpecialInterview.CheckSpecialTarget"

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
'### 2013.03.26 特定保健指導対象者チェックの為追加　End   ###


'
' 機能   : 予約番号をキーに指定対象受診者の検査結果を取得する
'
' 引数   :   (In)     lngRsvNo       予約番号（今回分）
'
'           (Out)    vntGrpCd       グループコード
'           (Out)    vntGrpName     グループ名称
'           (Out)    vntItemCd      検査項目コード
'           (Out)    vntSuffix      サフィックス
'           (Out)    vntItemName    検査項目名称
'           (Out)    vntResult      検査結果
'           (Out)    vntGrpSeq      表示順番
'           (Out)    vntStopFlg     検査中止フラグ
'           (Out)    vntRslCmtCd1   コメント1
'           (Out)    vntRslCmtCd2   コメント2
'           (Out)    vntHpoint      ヘルスポイント
'           (Out)    vntStdLead     保健指導対象基準値
'           (Out)    vntStdCare     受診勧奨対象基準値
'           (Out)    vntGrpCount    グループコード数
'           (Out)    lngCount       レコード数

' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了

Public Function SelectSpecialRslView( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntGrpCd As Variant, Optional ByRef vntGrpName As Variant, _
    Optional ByRef vntItemCd As Variant, Optional ByRef vntSuffix As Variant, _
    Optional ByRef vntItemName As Variant, Optional ByRef vntResult As Variant, _
    Optional ByRef vntGrpSeq As Variant, Optional ByRef vntStopFlg As Variant, _
    Optional ByRef vntRslCmtCd1 As Variant, Optional ByRef vntRslCmtCd2 As Variant, _
    Optional ByRef vntHpoint As Variant, Optional ByRef vntStdLead As Variant, _
    Optional ByRef vntStdCare As Variant, Optional ByRef vntGrpCount As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    Dim strStmtView         As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objGrpCd            As OraField         'グループコード
    Dim objGrpName          As OraField         'グループ名称
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名称
    Dim objResult           As OraField         '検査結果
    Dim objGrpSeq           As OraField         '表示順番
    Dim objStopFlg          As OraField         '検査中止フラグ
    Dim objRslCmtCd1        As OraField         'コメント1
    Dim objRslCmtCd2        As OraField         'コメント2
    Dim objHpoint           As OraField         'ヘルスポイント
    Dim objStdLead          As OraField         '保健指導対象基準値
    Dim objStdCare          As OraField         '受診勧奨対象基準値
    Dim objGrpCount         As OraField         'グループコード数

    Dim vntArrGrpCd()       As Variant         'グループコード配列
    Dim vntArrGrpName()     As Variant         'グループ名称配列
    Dim vntArrItemCd()      As Variant         '検査項目コード配列
    Dim vntArrSuffix()      As Variant         'サフィックス配列
    Dim vntArrItemName()    As Variant         '検査項目名称配列
    Dim vntArrResult()      As Variant         '検査結果配列
    Dim vntArrGrpSeq()      As Variant         '表示順番配列
    Dim vntArrStopFlg()     As Variant         '検査中止フラグ配列
    Dim vntArrRslCmtCd1()   As Variant         'コメント1配列
    Dim vntArrRslCmtCd2()   As Variant         'コメント2配列
    Dim vntArrHpoint()      As Variant         'ヘルスポイント配列
    Dim vntArrStdLead()     As Variant         '保健指導対象基準値配列
    Dim vntArrStdCare()     As Variant         '受診勧奨対象基準値配列
    Dim vntArrGrpCount()    As Variant         'グループコード数配列
    
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntGrpCd) Then vntGrpCd = Empty
    If Not IsMissing(vntGrpName) Then vntGrpName = Empty
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntResult) Then vntResult = Empty
    If Not IsMissing(vntGrpSeq) Then vntGrpSeq = Empty
    If Not IsMissing(vntStopFlg) Then vntStopFlg = Empty
    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = Empty
    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = Empty
    If Not IsMissing(vntHpoint) Then vntHpoint = Empty
    If Not IsMissing(vntStdLead) Then vntStdLead = Empty
    If Not IsMissing(vntStdCare) Then vntStdCare = Empty
    If Not IsMissing(vntGrpCount) Then vntGrpCount = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SHINTAI", SHINTAI_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "KETSU", KETUATU_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SISITSU", KETSYUSISITSU_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "KANKINOU", KANKINOU_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "KETTOU", KETTOU_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NYOU", NYOU_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SMOKE", SMOKE_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '特定面接画面に表示するための検査名や項目名、指定予約番号の結果情報を取得
    strStmt = " SELECT GRP.GRPCD                AS GRPCD,                               " & vbLf & _
              "        GRP.SEQ                  AS SEQ,                                 " & vbLf & _
              "        GRP.GRPNAME              AS GRPNAME,                             " & vbLf & _
              "        GRP.ITEMCD               AS ITEMCD,                              " & vbLf & _
              "        GRP.SUFFIX               AS SUFFIX,                              " & vbLf & _
              "        GRP.ITEMNAME             AS ITEMNAME,                            " & vbLf & _
              "        DECODE(RESULT.STOPFLG, 'S', '***', RESULT.RESULT)  AS RESULT,    " & vbLf & _
              "        RESULT.STOPFLG                                     AS STOPFLG,   "
 
    strStmt = strStmt & _
              "        RESULT.RSLCMTCD1                          AS RSLCMTCD1,        " & vbLf & _
              "        RESULT.RSLCMTCD2                          AS RSLCMTCD2,        " & vbLf & _
              "        NVL(RESULT.HPOINT,0)                      AS HPOINT,           " & vbLf & _
              "        GRP.STDLEAD                               AS STDLEAD,          " & vbLf & _
              "        GRP.STDCARE                               AS STDCARE,          " & vbLf & _
              "        ( SELECT COUNT (GRP_I.GRPCD)                                   " & vbLf & _
              "            FROM GRP_I                                                 " & vbLf & _
              "           WHERE GRP_I.GRPCD = GRP.GRPCD )        AS GRPCOUNT          "
    
    strStmt = strStmt & _
              "  FROM                                                                                      " & vbLf & _
              "        ( SELECT GRP_I.GRPCD      AS GRPCD,                                                 " & vbLf & _
              "                 GRP_I.SEQ        AS SEQ,                                                   " & vbLf & _
              "                 GRP_P.GRPNAME    AS GRPNAME,                                               " & vbLf & _
              "                 GRP_I.ITEMCD     AS ITEMCD,                                                " & vbLf & _
              "                 GRP_I.SUFFIX     AS SUFFIX,                                                " & vbLf & _
              "                 ITEM_C.ITEMNAME  AS ITEMNAME,                                              " & vbLf & _
              "                 FT_GET_SP_STANDARD(:RSVNO, GRP_I.ITEMCD, GRP_I.SUFFIX, 1)    AS STDLEAD,   " & vbLf & _
              "                 FT_GET_SP_STANDARD(:RSVNO, GRP_I.ITEMCD, GRP_I.SUFFIX, 2)    AS STDCARE    "

'### 2008.04.03 李（珍）質問事項の喫煙歴表示のため修正（Dr.諏訪からの依頼）Start ###
'    strStmt = strStmt & _
'              "            FROM GRP_I,                                                                       " & vbLf & _
'              "                 GRP_P,                                                                       " & vbLf & _
'              "                 ITEM_C                                                                       " & vbLf & _
'              "           WHERE GRP_I.GRPCD IN (:SHINTAI,:KETSU,:SISITSU,:KANKINOU,:KETTOU,:NYOU)            " & vbLf & _
'              "             AND GRP_I.ITEMCD = ITEM_C.ITEMCD                                                 " & vbLf & _
'              "             AND GRP_I.SUFFIX = ITEM_C.SUFFIX                                                 " & vbLf & _
'              "             AND GRP_I.GRPCD  = GRP_P.GRPCD                                                   " & vbLf & _
'              "        ) GRP,                                                                                "
    strStmt = strStmt & _
              "            FROM GRP_I,                                                                       " & vbLf & _
              "                 GRP_P,                                                                       " & vbLf & _
              "                 ITEM_C                                                                       " & vbLf & _
              "           WHERE GRP_I.GRPCD IN (:SHINTAI,:KETSU,:SISITSU,:KANKINOU,:KETTOU,:NYOU,:SMOKE)     " & vbLf & _
              "             AND GRP_I.ITEMCD = ITEM_C.ITEMCD                                                 " & vbLf & _
              "             AND GRP_I.SUFFIX = ITEM_C.SUFFIX                                                 " & vbLf & _
              "             AND GRP_I.GRPCD  = GRP_P.GRPCD                                                   " & vbLf & _
              "        ) GRP,                                                                                "

'    strStmt = strStmt & _
'              "        ( SELECT RSLVIEW.RSVNO                AS RSVNO,                                        " & vbLf & _
'              "                 RSLVIEW.ITEMCD               AS ITEMCD,                                       " & vbLf & _
'              "                 RSLVIEW.SUFFIX               AS SUFFIX,                                       " & vbLf & _
'              "                 DECODE(SENTENCE.LONGSTC, NULL, RSLVIEW.RESULT, SENTENCE.LONGSTC) AS RESULT,   " & vbLf & _
'              "                 RSLVIEW.STOPFLG              AS STOPFLG,                                      " & vbLf & _
'              "                 RSLVIEW.RSLCMTCD1            AS RSLCMTCD1,                                    " & vbLf & _
'              "                 RSLVIEW.RSLCMTCD2            AS RSLCMTCD2,                                    " & vbLf & _
'              "                 RSLVIEW.HPOINT               AS HPOINT                                        "
    strStmt = strStmt & _
              "        ( SELECT RSLVIEW.RSVNO                AS RSVNO,                                        " & vbLf & _
              "                 RSLVIEW.ITEMCD               AS ITEMCD,                                       " & vbLf & _
              "                 RSLVIEW.SUFFIX               AS SUFFIX,                                       " & vbLf & _
              "                 DECODE(SENTENCE.LONGSTC, NULL, RSLVIEW.RESULT,                                " & vbLf & _
              "                        DECODE(RSLVIEW.ITEMCD,'63070',DECODE(RSLVIEW.RESULT,'1','あり','なし')  " & vbLf & _
              "                        ,SENTENCE.LONGSTC) )  AS RESULT,                                       " & vbLf & _
              "                 RSLVIEW.STOPFLG              AS STOPFLG,                                      " & vbLf & _
              "                 RSLVIEW.RSLCMTCD1            AS RSLCMTCD1,                                    " & vbLf & _
              "                 RSLVIEW.RSLCMTCD2            AS RSLCMTCD2,                                    " & vbLf & _
              "                 RSLVIEW.HPOINT               AS HPOINT                                        "
'### 2008.04.03 李（珍）質問事項の喫煙歴表示のため修正（Dr.諏訪からの依頼）End   ###
 
    strStmt = strStmt & _
              "            FROM ( SELECT RSL.RSVNO            AS RSVNO,                                                    " & vbLf & _
              "                          RSL.ITEMCD           AS ITEMCD,                                                   " & vbLf & _
              "                          RSL.SUFFIX           AS SUFFIX,                                                   " & vbLf & _
              "                          RSL.RESULT           AS RESULT,                                                   " & vbLf & _
              "                          RSL.STOPFLG          AS STOPFLG,                                                  " & vbLf & _
              "                          RSL.RSLCMTCD1        AS RSLCMTCD1,                                                " & vbLf & _
              "                          RSL.RSLCMTCD2        AS RSLCMTCD2,                                                " & vbLf & _
              "                          FT_GET_SP_HEALTHPOINT(RSL.RSVNO, RSL.ITEMCD, RSL.SUFFIX, RSL.RESULT) AS HPOINT,   "
 
    strStmt = strStmt & _
              "                          ITEM_C.STCITEMCD     AS STCITEMCD,       " & vbLf & _
              "                          ITEM_C.ITEMTYPE      AS ITEMTYPE         " & vbLf & _
              "                     FROM RSL,                                     " & vbLf & _
              "                          GRP_I,                                   " & vbLf & _
              "                          ITEM_C                                   " & vbLf & _
              "                    WHERE RSL.RSVNO = :RSVNO                      "
 

'### 2008.04.03 李（珍）質問事項の喫煙歴表示のため修正（Dr.諏訪からの依頼）Start ###
'    strStmt = strStmt & _
'              "                      AND GRP_I.GRPCD IN (:SHINTAI,:KETSU,:SISITSU,:KANKINOU,:KETTOU,:NYOU)         " & vbLf & _
'              "                      AND GRP_I.ITEMCD = RSL.ITEMCD                                                 " & vbLf & _
'              "                      AND GRP_I.SUFFIX = RSL.SUFFIX                                                 " & vbLf & _
'              "                      AND RSL.ITEMCD   = ITEM_C.ITEMCD                                              " & vbLf & _
'              "                      AND RSL.SUFFIX   = ITEM_C.SUFFIX                                              " & vbLf & _
'              "                 ) RSLVIEW,                                                                         " & vbLf & _
'              "                   SENTENCE                                                                         "
    strStmt = strStmt & _
              "                      AND GRP_I.GRPCD IN (:SHINTAI,:KETSU,:SISITSU,:KANKINOU,:KETTOU,:NYOU,:SMOKE)  " & vbLf & _
              "                      AND GRP_I.ITEMCD = RSL.ITEMCD                                                 " & vbLf & _
              "                      AND GRP_I.SUFFIX = RSL.SUFFIX                                                 " & vbLf & _
              "                      AND RSL.ITEMCD   = ITEM_C.ITEMCD                                              " & vbLf & _
              "                      AND RSL.SUFFIX   = ITEM_C.SUFFIX                                              " & vbLf & _
              "                 ) RSLVIEW,                                                                         " & vbLf & _
              "                   SENTENCE                                                                         "
'### 2008.04.03 李（珍）質問事項の喫煙歴表示のため修正（Dr.諏訪からの依頼）End   ###

    strStmt = strStmt & _
              "           WHERE RSLVIEW.STCITEMCD = SENTENCE.ITEMCD(+)      " & vbLf & _
              "             AND RSLVIEW.ITEMTYPE  = SENTENCE.ITEMTYPE(+)    " & vbLf & _
              "             AND RSLVIEW.RESULT    = SENTENCE.STCCD(+)       " & vbLf & _
              "        ) RESULT                                             " & vbLf & _
              "  WHERE GRP.ITEMCD = RESULT.ITEMCD(+)                        " & vbLf & _
              "    AND GRP.SUFFIX = RESULT.SUFFIX(+)                        " & vbLf & _
              "  ORDER BY GRP.GRPCD, GRP.SEQ                                "



    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpCd = objFields("GRPCD")
        Set objGrpName = objFields("GRPNAME")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objGrpSeq = objFields("SEQ")
        Set objStopFlg = objFields("STOPFLG")
        Set objRslCmtCd1 = objFields("RSLCMTCD1")
        Set objRslCmtCd2 = objFields("RSLCMTCD2")
        Set objHpoint = objFields("HPOINT")
        Set objStdLead = objFields("STDLEAD")
        Set objStdCare = objFields("STDCARE")
        Set objGrpCount = objFields("GRPCOUNT")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF

                ReDim Preserve vntArrGrpCd(lngCount)
                ReDim Preserve vntArrGrpName(lngCount)
                ReDim Preserve vntArrItemCd(lngCount)
                ReDim Preserve vntArrSuffix(lngCount)
                ReDim Preserve vntArrItemName(lngCount)
                ReDim Preserve vntArrResult(lngCount)
                ReDim Preserve vntArrGrpSeq(lngCount)
                ReDim Preserve vntArrStopFlg(lngCount)
                ReDim Preserve vntArrRslCmtCd1(lngCount)
                ReDim Preserve vntArrRslCmtCd2(lngCount)
                ReDim Preserve vntArrHpoint(lngCount)
                ReDim Preserve vntArrStdLead(lngCount)
                ReDim Preserve vntArrStdCare(lngCount)
                ReDim Preserve vntArrGrpCount(lngCount)
                vntArrGrpCd(lngCount) = objGrpCd.Value & ""
                vntArrGrpName(lngCount) = objGrpName.Value & ""
                vntArrItemCd(lngCount) = objItemCd.Value & ""
                vntArrSuffix(lngCount) = objSuffix.Value & ""
                vntArrItemName(lngCount) = objItemName.Value & ""
                vntArrResult(lngCount) = objResult.Value & ""
                vntArrGrpSeq(lngCount) = objGrpSeq.Value & ""
                vntArrStopFlg(lngCount) = objStopFlg.Value & ""
                vntArrRslCmtCd1(lngCount) = objRslCmtCd1.Value & ""
                vntArrRslCmtCd2(lngCount) = objRslCmtCd2.Value & ""
                vntArrHpoint(lngCount) = objHpoint.Value & ""
                vntArrStdLead(lngCount) = objStdLead.Value & ""
                vntArrStdCare(lngCount) = objStdCare.Value & ""
                vntArrGrpCount(lngCount) = objGrpCount.Value & ""
                lngCount = lngCount + 1

            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntGrpCd) Then vntGrpCd = vntArrGrpCd
        If Not IsMissing(vntGrpName) Then vntGrpName = vntArrGrpName
        If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
        If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
        If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
        If Not IsMissing(vntResult) Then vntResult = vntArrResult
        If Not IsMissing(vntGrpSeq) Then vntGrpSeq = vntArrGrpSeq
        If Not IsMissing(vntStopFlg) Then vntStopFlg = vntArrStopFlg
        If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = vntArrRslCmtCd1
        If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = vntArrRslCmtCd2
        If Not IsMissing(vntHpoint) Then vntHpoint = vntArrHpoint
        If Not IsMissing(vntStdLead) Then vntStdLead = vntArrStdLead
        If Not IsMissing(vntStdCare) Then vntStdCare = vntArrStdCare
        If Not IsMissing(vntGrpCount) Then vntGrpCount = vntArrGrpCount

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectSpecialRslView = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectSpecialRslView = -1

    'イベントログ書き込み
    WriteErrorLog "SpecialInterview.SelectSpecialRslView"

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

'************************************************************************************************************
' Created  :  2009/03/24   by
'
' 機能　　 : 予約番号をもって検査結果を取得
'
' 引数   :  (In)     lngRsvNo       予約番号
'           (In)     strGRPCD       検査項目グループコード
'           (Out)    vntItemCd      検査項目コード
'           (Out)    vntSuffix      サフィックス
'           (Out)    vntItemName    検査項目名称
'           (Out)    vntResult      検査結果
'           (Out)    vntLongStc     文章
' 備考　　 :
'************************************************************************************************************
Public Function SelectSpecialResult( _
    ByVal lngRsvNo As Long, ByVal strGRPCD As String, _
    Optional ByRef vntItemCd As Variant, Optional ByRef vntSuffix As Variant, _
    Optional ByRef vntItemName As Variant, Optional ByRef vntResult As Variant, _
    Optional ByRef vntLongStc As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    Dim strStmtView         As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名称
    Dim objResult           As OraField         '検査結果
    Dim objLongStc          As OraField         'コメント2

    Dim vntArrItemCd()      As Variant         '検査項目コード配列
    Dim vntArrSuffix()      As Variant         'サフィックス配列
    Dim vntArrItemName()    As Variant         '検査項目名称配列
    Dim vntArrResult()      As Variant         '検査結果配列
    Dim vntArrLongStc()     As Variant         'コメント1配列
    
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntResult) Then vntResult = Empty
    If Not IsMissing(vntLongStc) Then vntLongStc = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "GRPCD", strGRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2

    strStmt = ""
    strStmt = strStmt & " SELECT PERRSL.ITEMCD          ITEMCD        　　　" & vbCrLf
    strStmt = strStmt & "       ,PERRSL.SUFFIX          SUFFIX        　　　" & vbCrLf
    strStmt = strStmt & "       ,PERRSL.ITEMNAME        ITEMNAME      　　　" & vbCrLf
    strStmt = strStmt & "       ,PERRSL.RESULT          RESULT        　　　" & vbCrLf
    strStmt = strStmt & "       ,SENTENCE.LONGSTC       LONGSTC       　　　" & vbCrLf

    strStmt = strStmt & "   FROM (                                          " & vbCrLf
    strStmt = strStmt & "         SELECT ITEM_C.ITEMCD      ITEMCD          " & vbCrLf
    strStmt = strStmt & "               ,ITEM_C.SUFFIX      SUFFIX          " & vbCrLf
    strStmt = strStmt & "               ,ITEM_C.STCITEMCD   STCITEMCD       " & vbCrLf
    strStmt = strStmt & "               ,ITEM_C.ITEMNAME    ITEMNAME        " & vbCrLf
    strStmt = strStmt & "               ,ITEM_C.ITEMTYPE    ITEMTYPE        " & vbCrLf
    strStmt = strStmt & "               ,ITEM_C.RESULTTYPE  RESULTTYPE      " & vbCrLf
    strStmt = strStmt & "               ,RSL.RESULT         RESULT          " & vbCrLf

    strStmt = strStmt & "           FROM RSL                                " & vbCrLf
    strStmt = strStmt & "               ,GRP_I                              " & vbCrLf
    strStmt = strStmt & "               ,ITEM_C                             " & vbCrLf
    strStmt = strStmt & "          WHERE RSL.RSVNO = :RSVNO                 " & vbCrLf
    strStmt = strStmt & "            AND GRP_I.GRPCD = :GRPCD               " & vbCrLf

    strStmt = strStmt & "            AND RSL.RESULT IS NOT NULL             " & vbCrLf
    strStmt = strStmt & "            AND RSL.ITEMCD = GRP_I.ITEMCD          " & vbCrLf
    strStmt = strStmt & "            AND RSL.SUFFIX = GRP_I.SUFFIX          " & vbCrLf
    strStmt = strStmt & "            AND RSL.ITEMCD = ITEM_C.ITEMCD         " & vbCrLf
    strStmt = strStmt & "            AND RSL.SUFFIX = ITEM_C.SUFFIX         " & vbCrLf
    strStmt = strStmt & "        ) PERRSL                                   " & vbCrLf
    strStmt = strStmt & "       ,SENTENCE                                   " & vbCrLf

    strStmt = strStmt & "  WHERE PERRSL.STCITEMCD  = SENTENCE.ITEMCD(+)     " & vbCrLf
    strStmt = strStmt & "    AND PERRSL.ITEMTYPE   = SENTENCE.ITEMTYPE(+)   " & vbCrLf
    strStmt = strStmt & "    AND PERRSL.RESULT     = SENTENCE.STCCD(+)    　" & vbCrLf
    strStmt = strStmt & "  ORDER BY PERRSL.ITEMCD, PERRSL.SUFFIX            "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objLongStc = objFields("LONGSTC")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF

                ReDim Preserve vntArrItemCd(lngCount)
                ReDim Preserve vntArrSuffix(lngCount)
                ReDim Preserve vntArrItemName(lngCount)
                ReDim Preserve vntArrResult(lngCount)
                ReDim Preserve vntArrLongStc(lngCount)
                vntArrItemCd(lngCount) = objItemCd.Value & ""
                vntArrSuffix(lngCount) = objSuffix.Value & ""
                vntArrItemName(lngCount) = objItemName.Value & ""
                vntArrResult(lngCount) = objResult.Value & ""
                vntArrLongStc(lngCount) = objLongStc.Value & ""
                lngCount = lngCount + 1

            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
        If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
        If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
        If Not IsMissing(vntResult) Then vntResult = vntArrResult
        If Not IsMissing(vntLongStc) Then vntLongStc = vntArrLongStc

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectSpecialResult = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectSpecialResult = -1

    'イベントログ書き込み
    WriteErrorLog "SpecialInterview.SelectSpecialResult"

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
' 機能　　 : 指定された予約番号の階層化コメントを取得する
'
' 引数　　 : (In)     lngRsvNo       予約番号
' 　　　　   (In)     lngDispMode     表示分類（1:総合コメント、2:生活指導コメント、3:食習慣コメント、4:献立コメント、5：特定健診）
' 　　　　   (Out)    vntJudCmtSeq    表示順
' 　　　　   (Out)    vntJudCmtCd     判定コメントコード
' 　　　　   (Out)    vntJudCmtStc    判定コメント文章
' 　　　　   (Out)    vntJudClassCd   判定分類コード
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectSpecialJudCmt( _
    ByVal lngRsvNo As Long, _
    ByVal lngDispMode As Long, _
    Optional ByRef vntJudCmtSeq As Variant, _
    Optional ByRef vntJudCmtCd As Variant, _
    Optional ByRef vntJudCmtStc As Variant, _
    Optional ByRef vntJudClassCd As Variant _
    ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objJudCmtSeq        As OraField         '表示順
    Dim objJudCmtCd         As OraField         '判定コメントコード
    Dim objJudCmtstc        As OraField         '判定コメント文章
    Dim objJudClassCd       As OraField         '判定分類コード

    Dim vntArrJudCmtSeq()   As Variant          '表示順の配列
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコードの配列
    Dim vntArrJudCmtstc()   As Variant          '判定コメント文章の配列
    Dim vntArrJudClassCd()  As Variant          '判定分類コードの配列
 
    Dim lngCmtCount         As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntJudCmtSeq) Then vntJudCmtSeq = Empty
    If Not IsMissing(vntJudCmtCd) Then vntJudCmtCd = Empty
    If Not IsMissing(vntJudCmtStc) Then vntJudCmtStc = Empty
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = Empty
    lngCmtCount = 0

    '表示歴数が「全件」以外で、数値でない場合はエラー
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISPMODE", lngDispMode, ORAPARM_INPUT, ORATYPE_NUMBER
    '指定された予約番号の階層化コメントを取得する
    strStmt = "SELECT TOTALJUDCMT.RSVNO        AS RSVNO,          " & vbLf & _
              "       TOTALJUDCMT.SEQ          AS JUDCMTSEQ,      " & vbLf & _
              "       TOTALJUDCMT.JUDCMTCD     AS JUDCMTCD,       " & vbLf & _
              "       JUDCMTSTC.JUDCMTSTC      AS JUDCMTSTC,      " & vbLf & _
              "       JUDCLASS.JUDCLASSCD      AS JUDCLASSCD      "
    strStmt = strStmt & _
              "  FROM TOTALJUDCMT,                                " & vbLf & _
              "       JUDCMTSTC,                                  " & vbLf & _
              "       JUDCLASS                                    " & vbLf & _
              " WHERE TOTALJUDCMT.RSVNO = :RSVNO                  " & vbLf & _
              "   AND TOTALJUDCMT.DISPMODE = :DISPMODE            " & vbLf & _
              "   AND TOTALJUDCMT.JUDCMTCD = JUDCMTSTC.JUDCMTCD   " & vbLf & _
              "   AND JUDCMTSTC.JUDCLASSCD = JUDCLASS.JUDCLASSCD  "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudCmtSeq = objFields("JUDCMTSEQ")
        Set objJudCmtCd = objFields("JUDCMTCD")
        Set objJudCmtstc = objFields("JUDCMTSTC")
        Set objJudClassCd = objFields("JUDCLASSCD")
        'レコードの検索
        Do Until objOraDyna.EOF

            '配列形式で格納する
            ReDim Preserve vntArrJudCmtSeq(lngCmtCount)
            ReDim Preserve vntArrJudCmtCd(lngCmtCount)
            ReDim Preserve vntArrJudCmtstc(lngCmtCount)
            ReDim Preserve vntArrJudClassCd(lngCmtCount)
            vntArrJudCmtSeq(lngCmtCount) = objJudCmtSeq.Value & ""
            vntArrJudCmtCd(lngCmtCount) = objJudCmtCd.Value & ""
            vntArrJudCmtstc(lngCmtCount) = objJudCmtstc.Value & ""
            vntArrJudClassCd(lngCmtCount) = objJudClassCd.Value & ""
            lngCmtCount = lngCmtCount + 1

            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntJudCmtSeq) Then vntJudCmtSeq = vntArrJudCmtSeq
        If Not IsMissing(vntJudCmtCd) Then vntJudCmtCd = vntArrJudCmtCd
        If Not IsMissing(vntJudCmtStc) Then vntJudCmtStc = vntArrJudCmtstc
        If Not IsMissing(vntJudClassCd) Then vntJudClassCd = vntArrJudClassCd
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectSpecialJudCmt = lngCmtCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectSpecialJudCmt = -1

    'イベントログ書き込み
    WriteErrorLog "Interview.SelectSpecialJudCmt"
    
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
' 機能　　 : 指定された予約番号の階層化コメントを更新する
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (In)     lngDispMode         表示分類
' 　　　　   (In)     vntJudCmtSeq        表示順
' 　　　　   (In)     vntJudCmtCd         判定コメントコード
' 　　　　   (In)     vntJudCmtCdStc      判定コメント
' 　　　　   (In)     vntUpdUser          更新者
'
' 戻り値　 : True    正常終了
' 　　　　   False   異常終了
'
' 備考　　 :
'
Public Function UpdateSpecialJudCmt( _
    ByVal lngRsvNo As Long, _
    ByVal lngDispMode As Long, _
    Optional ByVal vntJudCmtSeq As Variant, _
    Optional ByVal vntJudCmtCd As Variant, _
    Optional ByVal vntJudCmtStc As Variant, _
    Optional ByVal vntUpdUser As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim lngArraySize        As Long             '更新レコード配列数
    
    Dim objRsvNo            As OraParamArray    '予約番号
    Dim objDispMode         As OraParamArray    '表示分類
    Dim objJudCmtSeq              As OraParamArray    '表示順
    Dim objJudCmtCd         As OraParamArray    '判定コメントコード
    
    '変更履歴書き込み用
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim vntBakJudCmtSeq         As Variant          '表示順の配列
    Dim vntBakJudCmtCd    As Variant          '判定コメントコードの配列
    Dim vntBakJudCmtstc   As Variant          '判定コメント文章の配列
    Dim vntBakJudClassCd  As Variant          '判定分類コードの配列
    
    Dim lngBakCnt         As Long             '件数
    
    Dim vntArrLogUpdClass()           As Variant  '更新分類
    Dim vntArrLogUpdDiv()             As Variant  '処理区分
    Dim vntArrLogRsvNo()              As Variant  '予約番号
    Dim vntArrLogRsvDate()            As Variant  '予約日
    Dim vntArrLogJudClassCd()         As Variant  '判定分類コード
    Dim vntArrLogBeforeResult()       As Variant  '更新前値
    Dim vntArrLogAfterResult()        As Variant  '更新後値
    
    Dim lngChkFlg                     As Long     'チェックフラグ
    Dim lngLogCnt                     As Long     '変更履歴件数
    
    Dim strRsvDate                    As String   '予約日
    '変更履歴書き込み用
    
    Dim lngUpdFlg                     As Long     '更新有無フラグ
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

'MsgBox "UpdateSpecialJudCmt:配列数=" & UBound(vntJudCmtSeq)
    '配列数
    lngArraySize = UBound(vntJudCmtSeq) + 1
    
    
    '## 変更履歴更新用
    ' 現状を退避
    lngBakCnt = SelectSpecialJudCmt(lngRsvNo, _
                                   lngDispMode, _
                                   vntBakJudCmtSeq, _
                                   vntBakJudCmtCd, _
                                   vntBakJudCmtstc, _
                                   vntBakJudClassCd _
                                   )
    
    '予約日取得
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "LOGRSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc("SELECT RSVDATE FROM CONSULT WHERE RSVNO = :LOGRSVNO"), ORADYN_READONLY + ORADYN_NOCACHE)
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
    
        strRsvDate = objFields("RSVDATE").Value & ""
    Else
        Err.Raise 5 '「予約日がありません」
        Exit Function
    End If
    
'MsgBox "UpdateSpecialJudCmt:lngBakCnt=" & lngBakCnt
    lngLogCnt = 0
    '削除の有無確認
    For i = 0 To lngBakCnt - 1
        lngChkFlg = 0
        For j = 0 To lngArraySize - 1
            '更新後もあり？
            If vntBakJudCmtCd(i) = vntJudCmtCd(j) Then
                lngChkFlg = 1
                Exit For
            End If
        Next j
        '削除された
        If lngChkFlg = 0 Then
            ReDim Preserve vntArrLogUpdClass(lngLogCnt)
            ReDim Preserve vntArrLogUpdDiv(lngLogCnt)
            ReDim Preserve vntArrLogRsvNo(lngLogCnt)
            ReDim Preserve vntArrLogRsvDate(lngLogCnt)
            ReDim Preserve vntArrLogJudClassCd(lngLogCnt)
            ReDim Preserve vntArrLogBeforeResult(lngLogCnt)
            ReDim Preserve vntArrLogAfterResult(lngLogCnt)
            vntArrLogUpdClass(lngLogCnt) = 3
            vntArrLogUpdDiv(lngLogCnt) = "D"
            vntArrLogRsvNo(lngLogCnt) = lngRsvNo
            vntArrLogRsvDate(lngLogCnt) = strRsvDate
            Select Case lngDispMode
            '総合コメント
            Case 1
                vntArrLogJudClassCd(lngLogCnt) = ""
            Case 2
                vntArrLogJudClassCd(lngLogCnt) = LIFE_JUDCLASSCD
            Case 3
                vntArrLogJudClassCd(lngLogCnt) = FOOD_JUDCLASSCD
            Case 4
                vntArrLogJudClassCd(lngLogCnt) = MENU_JUDCLASSCD
            Case 5
                vntArrLogJudClassCd(lngLogCnt) = SPECIAL_JUDCLASSCD
            Case Else
                vntArrLogJudClassCd(lngLogCnt) = ""
            End Select
            vntArrLogBeforeResult(lngLogCnt) = vntBakJudCmtstc(i)
            vntArrLogAfterResult(lngLogCnt) = ""
            lngLogCnt = lngLogCnt + 1
        End If
    Next i
    
    '追加の有無確認
    For i = 0 To lngArraySize - 1
        lngChkFlg = 0
        For j = 0 To lngBakCnt - 1
    '###　2004.02.13 Add start バグ修正　by Fujii
            '表示順が数字で無いものは無視
            If Not IsNumeric(vntJudCmtSeq(i)) Then
                lngChkFlg = 1
                Exit For
            End If
            'コメントコードブランクは無視
            If CLng(vntJudCmtSeq(i)) <= 0 Or vntJudCmtCd(i) = "" Then
                lngChkFlg = 1
                Exit For
            End If
    '###　2004.02.13 Add end バグ修正　by Fujii
            '修正前もあり？
            If vntJudCmtCd(i) = vntBakJudCmtCd(j) Then
                lngChkFlg = 1
                Exit For
            End If
        Next j
        '追加された
        If lngChkFlg = 0 Then
            ReDim Preserve vntArrLogUpdClass(lngLogCnt)
            ReDim Preserve vntArrLogUpdDiv(lngLogCnt)
            ReDim Preserve vntArrLogRsvNo(lngLogCnt)
            ReDim Preserve vntArrLogRsvDate(lngLogCnt)
            ReDim Preserve vntArrLogJudClassCd(lngLogCnt)
            ReDim Preserve vntArrLogBeforeResult(lngLogCnt)
            ReDim Preserve vntArrLogAfterResult(lngLogCnt)
            vntArrLogUpdClass(lngLogCnt) = 3
            vntArrLogUpdDiv(lngLogCnt) = "I"
            vntArrLogRsvNo(lngLogCnt) = lngRsvNo
            vntArrLogRsvDate(lngLogCnt) = strRsvDate
            Select Case lngDispMode
            '総合コメント
            Case 1
                vntArrLogJudClassCd(lngLogCnt) = ""
            Case 2
                vntArrLogJudClassCd(lngLogCnt) = LIFE_JUDCLASSCD
            Case 3
                vntArrLogJudClassCd(lngLogCnt) = FOOD_JUDCLASSCD
            Case 4
                vntArrLogJudClassCd(lngLogCnt) = MENU_JUDCLASSCD
            Case 5
                vntArrLogJudClassCd(lngLogCnt) = SPECIAL_JUDCLASSCD
            Case Else
                vntArrLogJudClassCd(lngLogCnt) = ""
            End Select
            vntArrLogBeforeResult(lngLogCnt) = ""
            vntArrLogAfterResult(lngLogCnt) = vntJudCmtStc(i)
            lngLogCnt = lngLogCnt + 1
        End If
    Next i
    
'MsgBox "UpdateSpecialJudCmt:lngLogCnt=" & lngLogCnt
    '変更履歴登録あり
    If lngLogCnt > 0 Then
        UpdateLogSpecialJudCmt _
                        vntUpdUser, _
                        vntArrLogUpdClass, _
                        vntArrLogUpdDiv, _
                        vntArrLogRsvNo, _
                        vntArrLogRsvDate, _
                        vntArrLogJudClassCd, _
                        vntArrLogBeforeResult, _
                        vntArrLogAfterResult
    End If
    ' 変更履歴更新用
    
    'キー値の設定
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISPMODE", lngDispMode, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定された予約番号の総合コメントをすべて削除する
    strStmt = "DELETE TOTALJUDCMT                       " & vbLf & _
              " WHERE TOTALJUDCMT.RSVNO    = :RSVNO     " & vbLf & _
              "   AND TOTALJUDCMT.DISPMODE = :DISPMODE  "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    If lngArraySize > 0 Then
        objOraParam.AddTable "RSVNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_TOTALJUDCMT_RSVNO
        objOraParam.AddTable "DISPMODE", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_TOTALJUDCMT_DISPMODE
        objOraParam.AddTable "SEQ", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_TOTALJUDCMT_SEQ
        objOraParam.AddTable "JUDCMTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_TOTALJUDCMT_JUDCMTCD
        
    
        'OraParameterオブジェクトの参照設定
        Set objRsvNo = objOraParam("RSVNO")
        Set objDispMode = objOraParam("DISPMODE")
        Set objJudCmtSeq = objOraParam("SEQ")
        Set objJudCmtCd = objOraParam("JUDCMTCD")
        
        lngUpdFlg = 0
        'OraParameterオブジェクトの値設定
        For i = 0 To lngArraySize - 1
'            objRsvNo(i) = lngRsvNo
'            objDispMode(i) = lngDispMode
'            objSeq(i) = vntJudCmtSeq(i)
'            objJudCmtCd(i) = vntJudCmtCd(i)
            '表示順が数字
            If IsNumeric(vntJudCmtSeq(i)) Then
                If CLng(vntJudCmtSeq(i)) > 0 And vntJudCmtCd(i) <> "" Then
                    objRsvNo(i) = lngRsvNo
                    objDispMode(i) = lngDispMode
                    objJudCmtSeq(i) = vntJudCmtSeq(i)
                    objJudCmtCd(i) = vntJudCmtCd(i)
                    lngUpdFlg = 1
                End If
            End If
        Next i
        
        '検査結果更新
'        strStmt = "INSERT INTO TOTALJUDCMT  " & vbLf & _
'                  "VALUES (                 " & vbLf & _
'                  "  :RSVNO,                " & vbLf & _
'                  "  :DISPMODE,             " & vbLf & _
'                  "  :SEQ,                  " & vbLf & _
'                  "  :JUDCMTCD )            "
        '更新あり？
        If lngUpdFlg = 1 Then
            strStmt = "INSERT INTO TOTALJUDCMT  " & vbLf & _
                      "VALUES (                 " & vbLf & _
                      "  :RSVNO,                " & vbLf & _
                      "  :DISPMODE,             " & vbLf & _
                      "  :SEQ,                  " & vbLf & _
                      "  :JUDCMTCD )            "
        End If
    
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    '戻り値の設定
    UpdateSpecialJudCmt = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    UpdateSpecialJudCmt = False

    'イベントログ書き込み
    WriteErrorLog "Interview.UpdateSpecialJudCmt"
    
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
' 機能　　 : 階層化コメント更新履歴をセットする
'
' 引数　　 : (In)   vntUpdUser              更新者
' 　　　　   (In)   vntUpdClass()           更新分類
' 　　　　   (In)   vntUpdDiv()             処理区分
' 　　　　   (In)   vntRsvNo()              予約番号
' 　　　　   (In)   vntRsvDate()            予約日
' 　　　　   (In)   vntJudClassCd()         判定分類コード
' 　　　　   (In)   vntBeforeResult()       更新前値
' 　　　　   (In)   vntAfterResult()        更新後値
'
' 戻り値　 : True    正常終了
' 　　　　   False   異常終了
'
' 備考　　 :
'
Public Function UpdateLogSpecialJudCmt( _
    ByVal strUpdUser As String, _
    Optional ByRef vntUpdClass As Variant, _
    Optional ByRef vntUpdDiv As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntRsvDate As Variant, _
    Optional ByRef vntJudClassCd As Variant, _
    Optional ByRef vntBeforeResult As Variant, _
    Optional ByRef vntAfterResult As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント

    Dim lngArraySize        As Long             '更新レコード配列数
    
    Dim objUpdClass         As OraParamArray    '更新分類
    Dim objUpdDiv           As OraParamArray    '処理区分
    Dim objRsvNo            As OraParamArray    '予約番号
    Dim objRsvDate          As OraParamArray    '予約日
    Dim objJudClassCd       As OraParamArray    '判定分類コード
    Dim objBeforeResult     As OraParamArray    '更新前値
    Dim objAfterResult      As OraParamArray    '更新後値
    
    Dim i                   As Long             'ループカウンタ
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '配列数
    lngArraySize = UBound(vntUpdClass) + 1
    

    'キー値の設定
    
    If lngArraySize > 0 Then
        Set objOraParam = mobjOraDb.Parameters
        
        For i = 0 To lngArraySize - 1
            objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR
            objOraParam.Add "UPDCLASS", CLng(Trim(vntUpdClass(i))), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "UPDDIV", Trim(vntUpdDiv(i)), ORAPARM_INPUT, ORATYPE_VARCHAR2
            objOraParam.Add "RSVNO", CLng(Trim(vntRsvNo(i))), ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "RSVDATE", CDate(Trim(vntRsvDate(i))), ORAPARM_INPUT, ORATYPE_DATE
            objOraParam.Add "JUDCLASSCD", Trim(vntJudClassCd(i)), ORAPARM_INPUT, ORATYPE_VARCHAR2
            objOraParam.Add "BEFORERESULT", Trim(vntBeforeResult(i)), ORAPARM_INPUT, ORATYPE_VARCHAR2
            objOraParam.Add "AFTERRESULT", Trim(vntAfterResult(i)), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    
        
            '検査結果更新
            strStmt = "INSERT INTO UPDATELOG  " & vbLf & _
                      " ( UPDDATE,            " & vbLf & _
                      "   UPDUSER,            " & vbLf & _
                      "   UPDCLASS,           " & vbLf & _
                      "   UPDDIV,             " & vbLf & _
                      "   RSVNO,              " & vbLf & _
                      "   RSVDATE             "
                strStmt = strStmt & vbLf & _
                      "  , JUDCLASSCD         "
            If vntBeforeResult(i) <> "" Then
                strStmt = strStmt & vbLf & _
                      "  , BEFORERESULT       "
            End If
            If vntAfterResult(i) <> "" Then
                strStmt = strStmt & vbLf & _
                      "  , AFTERRESULT        "
            End If
            strStmt = strStmt & " )        "
                      
            strStmt = strStmt & vbLf & _
                      "VALUES (               " & vbLf & _
                      "  SYSDATE,             " & vbLf & _
                      "  :UPDUSER,            " & vbLf & _
                      "  :UPDCLASS,           " & vbLf & _
                      "  :UPDDIV,             " & vbLf & _
                      "  :RSVNO,              " & vbLf & _
                      "  :RSVDATE             "
            If vntJudClassCd(i) <> "" Then
                strStmt = strStmt & vbLf & _
                      "  , :JUDCLASSCD         "
            Else
                strStmt = strStmt & vbLf & _
                      "  , NULL                "
            End If
            If vntBeforeResult(i) <> "" Then
                strStmt = strStmt & vbLf & _
                      "  , :BEFORERESULT       "
            End If
            If vntAfterResult(i) <> "" Then
                strStmt = strStmt & vbLf & _
                      "  , :AFTERRESULT        "
            End If
            strStmt = strStmt & " )        "

            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
            'バインド変数の削除
            Do Until objOraParam.Count <= 0
                objOraParam.Remove (objOraParam.Count - 1)
            Loop
        Next i
    End If
    
    '戻り値の設定
    UpdateLogSpecialJudCmt = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    UpdateLogSpecialJudCmt = False

    'イベントログ書き込み
    WriteErrorLog "Interview.UpdateLogSpecialJudCmt"
    
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
