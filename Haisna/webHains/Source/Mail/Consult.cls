VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Consult"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.6
'担当者  ：T.Takagi@RD
'修正内容：新規作成

Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const ORGCD1_PERSON     As String = "XXXXX"         '個人受診
Private Const ORGCD2_PERSON     As String = "XXXXX"         '個人受診

Private Const RSVGRPCD_KIGYO1   As Long = 50                '企業健診判定のための予約群コード1
Private Const RSVGRPCD_KIGYO2   As Long = 51                '企業健診判定のための予約群コード2
Private Const OPTCD_KIGYO1      As String = "1000"          '企業健診のコース名となる契約オプションのコード1
Private Const OPTCD_KIGYO2      As String = "1001"          '企業健診のコース名となる契約オプションのコード2

Private Const GRPCD_STOMAC      As String = "X502"          '胃部受診項目判定用グループコード
Private Const FREECD_OPTIONS    As String = "LST000021%"    'オプション検査名称取得用汎用テーブルレコードキー
Private Const FREECD_STOMAC     As String = "LST000022%"    '胃部受診項目名称取得用汎用テーブルレコードキー

'
' 機能　　 : 受診情報を取得する
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (Out)    vntCslDate      受診日
' 　　　　   (Out)    vntCsName       コース名
' 　　　　   (Out)    vntCsEName      英語コース名
' 　　　　   (Out)    vntStrTime      開始時間
' 　　　　   (Out)    vntEndTime      終了時間
' 　　　　   (Out)    vntPerId        個人ID
' 　　　　   (Out)    vntLastName     姓
' 　　　　   (Out)    vntFirstName    名
' 　　　　   (Out)    vntLastKName    カナ姓
' 　　　　   (Out)    vntFirstKName   カナ名
' 　　　　   (Out)    vntRomeName     ローマ字名
' 　　　　   (Out)    vntGender       性別
' 　　　　   (Out)    vntBirth        生年月日
' 　　　　   (Out)    vntOrgName      団体名称
' 　　　　   (Out)    vntOrgEName     団体英語名称
' 　　　　   (Out)    vntSendMailDiv  予約確認メール送信先
' 　　　　   (Out)    vntEmail        e-Mail
' 　　　　   (Out)    vntPerPrice     個人負担金額
' 　　　　   (Out)    vntPrice        受診金額
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectConsult( _
    ByVal lngRsvNo As String, _
    ByRef vntCslDate As Variant, _
    ByRef vntCsName As Variant, ByRef vntCsEName As Variant, _
    ByRef vntStrTime As Variant, ByRef vntEndTime As Variant, _
    ByRef vntPerId As Variant, _
    ByRef vntLastName As Variant, ByRef vntFirstName As Variant, _
    ByRef vntLastKName As Variant, ByRef vntFirstKName As Variant, _
    ByRef vntRomeName As Variant, _
    ByRef vntGender As Variant, _
    ByRef vntBirth As Variant, _
    ByRef vntOrgName As Variant, ByRef vntOrgEName As Variant, _
    ByRef vntSendMailDiv As Variant, _
    ByRef vntEmail As Variant, _
    ByRef vntPerPrice As Variant, ByRef vntPrice As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCslDate      As OraField         '受診日
    Dim objCsName       As OraField         'コース名
    Dim objCsEName      As OraField         '英語コース名
    Dim objStrTime      As OraField         '開始時間
    Dim objEndTime      As OraField         '終了時間
    Dim objPerId        As OraField         '個人ID
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    Dim objRomeName     As OraField         'ローマ字名
    Dim objGender       As OraField         '性別
    Dim objBirth        As OraField         '生年月日
    Dim objOrgName      As OraField         '団体名称
    Dim objOrgEName     As OraField         '団体英語名称
    Dim objSendMailDiv  As OraField         '予約確認メール送信先
    Dim objEmail        As OraField         'e-Mail
    Dim objPerPrice     As OraField         '個人負担金額
    Dim objPrice        As OraField         '受診金額
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntCslDate = Empty
    vntCsName = Empty
    vntCsEName = Empty
    vntStrTime = Empty
    vntEndTime = Empty
    vntPerId = Empty
    vntLastName = Empty
    vntFirstName = Empty
    vntLastKName = Empty
    vntFirstKName = Empty
    vntRomeName = Empty
    vntGender = Empty
    vntBirth = Empty
    vntOrgName = Empty
    vntOrgEName = Empty
    vntSendMailDiv = Empty
    vntEmail = Empty
    vntPerPrice = Empty
    vntPrice = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGCD1_PERSON", ORGCD1_PERSON, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2_PERSON", ORGCD2_PERSON, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD_KIGYO1", RSVGRPCD_KIGYO1, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVGRPCD_KIGYO2", RSVGRPCD_KIGYO2, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD_KIGYO1", OPTCD_KIGYO1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTCD_KIGYO2", OPTCD_KIGYO2, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号の受診情報を取得
    strStmt = "SELECT CONSULT.RSVNO,                            " & vbLf & _
              "       CONSULT.CSLDATE,                          " & vbLf & _
              "       CONSULT.PERID,                            " & vbLf & _
              "       CONSULT.SENDMAILDIV,                      " & vbLf & _
              "       ORG.ORGNAME,                              " & vbLf & _
              "       NVL(ORG.ORGENAME, ORG.ORGNAME) ORGENAME,  " & vbLf & _
              "       PERSON.LASTNAME,  PERSON.FIRSTNAME,       " & vbLf & _
              "       PERSON.LASTKNAME, PERSON.FIRSTKNAME,      " & vbLf & _
              "       PERSON.ROMENAME,                          " & vbLf & _
              "       PERSON.GENDER,                            " & vbLf & _
              "       PERSON.BIRTH,                             " & vbLf & _
              "       PERADDR.EMAIL,                            " & vbLf & _
              "       RSVGRP.STRTIME,                           " & vbLf & _
              "       RSVGRP.ENDTIME,                           "
              
    'コース名の取得
    '・予約群コードが50, 51(企業健診用の予約群)の場合、受診オプションのうちオプションコードが1000または1001のものを検索し、その名称を採用
    '・それ以外は契約パターンのコース名を採用
    '(はがき、ご案内書のコース名取得処理と同一仕様)
    strStmt = strStmt & vbLf & _
              "       CASE                                                                           " & vbLf & _
              "           WHEN CONSULT.RSVGRPCD IN (:RSVGRPCD_KIGYO1, :RSVGRPCD_KIGYO2) THEN         " & vbLf & _
              "               (SELECT OPTNAME                                                        " & vbLf & _
              "                  FROM (SELECT CTRPT_OPT.OPTNAME                                      " & vbLf & _
              "                          FROM CTRPT_OPT, CONSULT_O                                   " & vbLf & _
              "                         WHERE CONSULT_O.RSVNO       = :RSVNO                         " & vbLf & _
              "                           AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD              " & vbLf & _
              "                           AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD                " & vbLf & _
              "                           AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO          " & vbLf & _
              "                           AND CTRPT_OPT.OPTCD      IN (:OPTCD_KIGYO1, :OPTCD_KIGYO2) " & vbLf & _
              "                         ORDER BY CTRPT_OPT.CTRPTCD,                                  " & vbLf & _
              "                                  CTRPT_OPT.OPTCD,                                    " & vbLf & _
              "                                  CTRPT_OPT.OPTBRANCHNO                               " & vbLf & _
              "                       ) OPTIONS                                                      " & vbLf & _
              "                 WHERE ROWNUM = 1)                                                    " & vbLf & _
              "           ELSE                                                                       " & vbLf & _
              "               CTRPT.CSNAME                                                           " & vbLf & _
              "       END CSNAME,                                                                    "

    '英語コース名の取得(契約パターンテーブルより取得)
    strStmt = strStmt & vbLf & _
              "       NVL(CTRPT.CSENAME, CTRPT.CSNAME) CSENAME, "
              
    '個人負担金額
    strStmt = strStmt & vbLf & _
              "       (SELECT NVL(SUM(PRICE + EDITPRICE + TAXPRICE + EDITTAX), 0) " & vbLf & _
              "          FROM CONSULT_M                                           " & vbLf & _
              "         WHERE RSVNO  = CONSULT.RSVNO                              " & vbLf & _
              "           AND ORGCD1 = :ORGCD1_PERSON                             " & vbLf & _
              "           AND ORGCD2 = :ORGCD2_PERSON                             " & vbLf & _
              "       ) PERPRICE,                                                 "
    
    '受診金額
    strStmt = strStmt & vbLf & _
              "       (SELECT NVL(SUM(PRICE + EDITPRICE + TAXPRICE + EDITTAX), 0) " & vbLf & _
              "          FROM CONSULT_M                                           " & vbLf & _
              "         WHERE RSVNO  = CONSULT.RSVNO                              " & vbLf & _
              "       ) PRICE                                                     "
              
    strStmt = strStmt & vbLf & _
              "  FROM CTRPT,    " & vbLf & _
              "       RSVGRP,   " & vbLf & _
              "       ORG,      " & vbLf & _
              "       PERADDR,  " & vbLf & _
              "       PERSON,   " & vbLf & _
              "       CONSULT   "
              
    strStmt = strStmt & vbLf & _
              " WHERE CONSULT.RSVNO       = :RSVNO             " & vbLf & _
              "   AND CONSULT.PERID       = PERSON.PERID       " & vbLf & _
              "   AND CONSULT.PERID       = PERADDR.PERID(+)   " & vbLf & _
              "   AND CONSULT.SENDMAILDIV = PERADDR.ADDRDIV(+) " & vbLf & _
              "   AND CONSULT.ORGCD1      = ORG.ORGCD1         " & vbLf & _
              "   AND CONSULT.ORGCD2      = ORG.ORGCD2         " & vbLf & _
              "   AND CONSULT.RSVGRPCD    = RSVGRP.RSVGRPCD    " & vbLf & _
              "   AND CONSULT.CTRPTCD     = CTRPT.CTRPTCD      "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objCsName = objFields("CSNAME")
        Set objCsEName = objFields("CSENAME")
        Set objStrTime = objFields("STRTIME")
        Set objEndTime = objFields("ENDTIME")
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objRomeName = objFields("ROMENAME")
        Set objGender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgEName = objFields("ORGENAME")
        Set objSendMailDiv = objFields("SENDMAILDIV")
        Set objEmail = objFields("EMAIL")
        Set objPerPrice = objFields("PERPRICE")
        Set objPrice = objFields("PRICE")

        '戻り値の設定
        vntCslDate = objCslDate.Value & ""
        vntCsName = objCsName.Value & ""
        vntCsEName = objCsEName.Value & ""
        vntStrTime = objStrTime.Value & ""
        vntEndTime = objEndTime.Value & ""
        vntPerId = objPerId.Value & ""
        vntLastName = objLastName.Value & ""
        vntFirstName = objFirstName.Value & ""
        vntLastKName = objLastKName.Value & ""
        vntFirstKName = objFirstKName.Value & ""
        vntRomeName = objRomeName.Value & ""
        vntGender = objGender.Value & ""
        vntBirth = objBirth.Value & ""
        vntOrgName = objOrgName.Value & ""
        vntOrgEName = objOrgEName.Value & ""
        vntSendMailDiv = objSendMailDiv.Value & ""
        vntEmail = objEmail.Value & ""
        vntPerPrice = objPerPrice.Value & ""
        vntPrice = objPrice.Value & ""

        SelectConsult = True

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
    WriteErrorLog "Consult.SelectConsult"

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 検索条件を満たす受診者の一覧を取得する(予約確認メール送信用受診者検索)
'
' 引数　　 : (In)     dtmStrCslDate   開始受診日
' 　　　　   (In)     dtmEndCslDate   終了受診日
' 　　　　   (In)     strCsCd         コースコード
' 　　　　   (In)     strOrgCd1       団体コード1
' 　　　　   (In)     strOrgCd2       団体コード2
' 　　　　   (In)     strPerId        個人ID
' 　　　　   (In)     lngStatus       状態(1:未送信、2:送信済み)
' 　　　　   (Out)    vntRsvNo        予約番号
' 　　　　   (Out)    vntCslDate      受診日
' 　　　　   (Out)    vntCsName       コース名
' 　　　　   (Out)    vntWebColor     webカラー
' 　　　　   (Out)    vntRsvGrpName   予約群名称
' 　　　　   (Out)    vntPerId        個人ID
' 　　　　   (Out)    vntLastName     姓
' 　　　　   (Out)    vntFirstName    名
' 　　　　   (Out)    vntLastKName    カナ姓
' 　　　　   (Out)    vntFirstKName   カナ名
' 　　　　   (Out)    vntGender       性別
' 　　　　   (Out)    vntBirth        生年月日
' 　　　　   (Out)    vntAge          受診時年齢
' 　　　　   (Out)    vntOrgSName     団体略称
' 　　　　   (Out)    vntSendMailDiv  予約確認メール送信先
' 　　　　   (Out)    vntEmail        e-Mail
' 　　　　   (Out)    vntSendMailDate 予約確認メール送信日時
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsultList( _
    ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, _
    ByVal strCsCd As String, _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    ByVal strPerId As String, _
    ByVal lngStatus As Long, _
    ByRef vntRsvNo As Variant, _
    ByRef vntCslDate As Variant, _
    ByRef vntCsName As Variant, _
    ByRef vntWebColor As Variant, _
    ByRef vntRsvGrpName As Variant, _
    ByRef vntPerId As Variant, _
    ByRef vntLastName As Variant, ByRef vntFirstName As Variant, _
    ByRef vntLastKName As Variant, ByRef vntFirstKName As Variant, _
    ByRef vntGender As Variant, _
    ByRef vntBirth As Variant, _
    ByRef vntAge As Variant, _
    ByRef vntOrgSName As Variant, _
    ByRef vntSendMailDiv As Variant, _
    ByRef vntEmail As Variant, _
    ByRef vntSendMailDate As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objRsvNo                As OraField         '予約番号
    Dim objCslDate              As OraField         '受診日
    Dim objCsName               As OraField         'コース名
    Dim objWebColor             As OraField         'webカラー
    Dim objRsvGrpName           As OraField         '予約群名称
    Dim objPerId                As OraField         '個人ID
    Dim objLastName             As OraField         '姓
    Dim objFirstName            As OraField         '名
    Dim objLastKName            As OraField         'カナ姓
    Dim objFirstKName           As OraField         'カナ名
    Dim objGender               As OraField         '性別
    Dim objBirth                As OraField         '生年月日
    Dim objAge                  As OraField         '受診時年齢
    Dim objOrgSName             As OraField         '団体略称
    Dim objSendMailDiv          As OraField         '予約確認メール送信先
    Dim objEmail                As OraField         'e-Mail
    Dim objSendMailDate         As OraField         '予約確認メール送信日時

    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrCslDate()         As Variant          '受診日の配列
    Dim vntArrCsName()          As Variant          'コース名の配列
    Dim vntArrWebColor()        As Variant          'webカラーの配列
    Dim vntArrRsvGrpName()      As Variant          '予約群名称の配列
    Dim vntArrPerId()           As Variant          '個人IDの配列
    Dim vntArrLastName()        As Variant          '姓の配列
    Dim vntArrFirstName()       As Variant          '名の配列
    Dim vntArrLastKName()       As Variant          'カナ姓の配列
    Dim vntArrFirstKName()      As Variant          'カナ名の配列
    Dim vntArrGender()          As Variant          '性別の配列
    Dim vntArrBirth()           As Variant          '生年月日の配列
    Dim vntArrAge()             As Variant          '受診時年齢の配列
    Dim vntArrOrgSName()        As Variant          '団体略称の配列
    Dim vntArrSendMailDiv()     As Variant          '予約確認メール送信先の配列
    Dim vntArrEmail()           As Variant          'e-Mailの配列
    Dim vntArrSendMailDate()    As Variant          '予約確認メール送信日時の配列
    Dim lngCount                As Long             'レコード数

    Dim dtmDate                 As Date             '作業用の日付

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntRsvNo = Empty
    vntCslDate = Empty
    vntCsName = Empty
    vntWebColor = Empty
    vntRsvGrpName = Empty
    vntPerId = Empty
    vntLastName = Empty
    vntFirstName = Empty
    vntLastKName = Empty
    vntFirstKName = Empty
    vntGender = Empty
    vntBirth = Empty
    vntAge = Empty
    vntOrgSName = Empty
    vntSendMailDiv = Empty
    vntEmail = Empty
    vntSendMailDate = Empty
    lngCount = 0

    '受診日の設定（大小逆転時に入れ替えを行う）
    If dtmEndCslDate < dtmStrCslDate Then
        dtmDate = dtmStrCslDate
        dtmStrCslDate = dtmEndCslDate
        dtmEndCslDate = dtmDate
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", IIf(strCsCd <> "", strCsCd, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", IIf(strOrgCd1 <> "", strOrgCd1, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", IIf(strOrgCd2 <> "", strOrgCd2, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PERID", IIf(strPerId <> "", strPerId, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定条件を満たす受診情報を取得する
    strStmt = "SELECT CONSULT.RSVNO,                            " & vbLf & _
              "       CONSULT.CSLDATE,                          " & vbLf & _
              "       CONSULT.PERID,                            " & vbLf & _
              "       TRIM(TO_CHAR(CONSULT.AGE, '999.99')) AGE, " & vbLf & _
              "       CONSULT.SENDMAILDIV,                      " & vbLf & _
              "       CONSULT.SENDMAILDATE,                     " & vbLf & _
              "       ORG.ORGSNAME,                             " & vbLf & _
              "       PERSON.LASTNAME,  PERSON.FIRSTNAME,       " & vbLf & _
              "       PERSON.LASTKNAME, PERSON.FIRSTKNAME,      " & vbLf & _
              "       PERSON.GENDER,                            " & vbLf & _
              "       PERSON.BIRTH,                             " & vbLf & _
              "       PERADDR.EMAIL,                            " & vbLf & _
              "       COURSE_P.WEBCOLOR,                        " & vbLf & _
              "       COURSE_P.CSNAME,                          " & vbLf & _
              "       RSVGRP.RSVGRPNAME                         "
              
    strStmt = strStmt & vbLf & _
              "  FROM RSVGRP,   " & vbLf & _
              "       COURSE_P, " & vbLf & _
              "       ORG,      " & vbLf & _
              "       PERADDR,  " & vbLf & _
              "       PERSON,   " & vbLf & _
              "       CONSULT   "
              
    strStmt = strStmt & vbLf & _
              " WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE " & vbLf & _
              "   AND CONSULT.CSCD        = NVL(:CSCD,   CONSULT.CSCD)    " & vbLf & _
              "   AND CONSULT.ORGCD1      = NVL(:ORGCD1, CONSULT.ORGCD1)  " & vbLf & _
              "   AND CONSULT.ORGCD2      = NVL(:ORGCD2, CONSULT.ORGCD2)  " & vbLf & _
              "   AND CONSULT.PERID       = NVL(:PERID,  CONSULT.PERID)   " & vbLf & _
              "   AND CONSULT.PERID       = PERSON.PERID                  " & vbLf & _
              "   AND CONSULT.PERID       = PERADDR.PERID(+)              " & vbLf & _
              "   AND CONSULT.SENDMAILDIV = PERADDR.ADDRDIV(+)            " & vbLf & _
              "   AND CONSULT.ORGCD1      = ORG.ORGCD1                    " & vbLf & _
              "   AND CONSULT.ORGCD2      = ORG.ORGCD2                    " & vbLf & _
              "   AND CONSULT.CSCD        = COURSE_P.CSCD                 " & vbLf & _
              "   AND CONSULT.RSVGRPCD    = RSVGRP.RSVGRPCD               "

    '状態による条件指定
    Select Case lngStatus
        Case 1
            strStmt = strStmt & vbLf & _
              "   AND CONSULT.SENDMAILDATE IS NULL"
        Case 2
            strStmt = strStmt & vbLf & _
              "   AND CONSULT.SENDMAILDATE IS NOT NULL"
    End Select

    strStmt = strStmt & vbLf & _
              " ORDER BY CONSULT.CSLDATE,  " & vbLf & _
              "          CONSULT.CSCD,     " & vbLf & _
              "          CONSULT.RSVGRPCD, " & vbLf & _
              "          CONSULT.PERID,    " & vbLf & _
              "          CONSULT.RSVNO     "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objCsName = objFields("CSNAME")
        Set objWebColor = objFields("WEBCOLOR")
        Set objRsvGrpName = objFields("RSVGRPNAME")
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objGender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objAge = objFields("AGE")
        Set objOrgSName = objFields("ORGSNAME")
        Set objSendMailDiv = objFields("SENDMAILDIV")
        Set objEmail = objFields("EMAIL")
        Set objSendMailDate = objFields("SENDMAILDATE")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrRsvGrpName(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrBirth(lngCount)
            ReDim Preserve vntArrAge(lngCount)
            ReDim Preserve vntArrOrgSName(lngCount)
            ReDim Preserve vntArrSendMailDiv(lngCount)
            ReDim Preserve vntArrEmail(lngCount)
            ReDim Preserve vntArrSendMailDate(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrGender(lngCount) = objGender.Value & ""
            vntArrBirth(lngCount) = objBirth.Value & ""
            vntArrAge(lngCount) = objAge.Value & ""
            vntArrOrgSName(lngCount) = objOrgSName.Value & ""
            vntArrSendMailDiv(lngCount) = objSendMailDiv.Value & ""
            vntArrEmail(lngCount) = objEmail.Value & ""
            vntArrSendMailDate(lngCount) = objSendMailDate.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntRsvNo = vntArrRsvNo
        vntCslDate = vntArrCslDate
        vntCsName = vntArrCsName
        vntWebColor = vntArrWebColor
        vntRsvGrpName = vntArrRsvGrpName
        vntPerId = vntArrPerId
        vntLastName = vntArrLastName
        vntFirstName = vntArrFirstName
        vntLastKName = vntArrLastKName
        vntFirstKName = vntArrFirstKName
        vntGender = vntArrGender
        vntBirth = vntArrBirth
        vntAge = vntArrAge
        vntOrgSName = vntArrOrgSName
        vntSendMailDiv = vntArrSendMailDiv
        vntEmail = vntArrEmail
        vntSendMailDate = vntArrSendMailDate
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectConsultList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsultList = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsultList"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : オプション検査名称を取得する
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (Out)    vntOptionName   オプション名称
' 　　　　   (Out)    vntOptionEName  オプション英語名称
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectOptionNameList(ByVal lngRsvNo As String, ByRef vntOptionName As Variant, ByRef vntOptionEName As Variant) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objOptionName       As OraField         'オプション名称
    Dim objOptionEName      As OraField         'オプション英語名称
    
    Dim vntArrOptionName()  As Variant          'オプション名称の配列
    Dim vntArrOptionEName() As Variant          'オプション英語名称の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntOptionName = Empty
    vntOptionEName = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FREECD_OPTIONS", FREECD_OPTIONS, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号の受診オプション情報を読み、かつ汎用テーブルからオプション検査名称を取得
    strStmt = "SELECT OPTIONNAME, OPTIONENAME                                         " & vbLf & _
              "  FROM (SELECT NVL(FREE.FREEFIELD2, SETCLASS.SETCLASSNAME) OPTIONNAME, " & vbLf & _
              "               NVL(FREE.FREEFIELD3, SETCLASS.SETCLASSNAME) OPTIONENAME " & vbLf & _
              "          FROM SETCLASS, FREE,                                         " & vbLf & _
              "               (SELECT DISTINCT CTRPT_OPT.SETCLASSCD                   " & vbLf & _
              "                  FROM CTRPT_OPT, CONSULT_O                            " & vbLf & _
              "                 WHERE CONSULT_O.RSVNO       = :RSVNO                  " & vbLf & _
              "                   AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD       " & vbLf & _
              "                   AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD         " & vbLf & _
              "                   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO   " & vbLf & _
              "               ) SETCLASSES                                            " & vbLf & _
              "         WHERE FREE.FREECD      LIKE :FREECD_OPTIONS                   " & vbLf & _
              "           AND SETCLASSES.SETCLASSCD = FREE.FREEFIELD1                 " & vbLf & _
              "           AND SETCLASSES.SETCLASSCD = SETCLASS.SETCLASSCD             " & vbLf & _
              "       ) OPTIONNAMES                                                   " & vbLf & _
              " ORDER BY OPTIONNAME, OPTIONENAME                                      "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOptionName = objFields("OPTIONNAME")
        Set objOptionEName = objFields("OPTIONENAME")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOptionName(lngCount)
            ReDim Preserve vntArrOptionEName(lngCount)
            vntArrOptionName(lngCount) = objOptionName.Value & ""
            vntArrOptionEName(lngCount) = objOptionEName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntOptionName = vntArrOptionName
        vntOptionEName = vntArrOptionEName
        
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
    WriteErrorLog "Consult.SelectOptionNameList"

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 胃部受診情報を取得する
'
' 引数　　 : (In)     lngRsvNo         予約番号
' 　　　　   (Out)    vntConsultName   受診名称
' 　　　　   (Out)    vntConsultEName  受診英語名称
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectStomacConsultInfo(ByVal lngRsvNo As String, ByRef vntConsultName As Variant, ByRef vntConsultEName As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objConsultName  As OraField         '受診名称
    Dim objConsultEName As OraField         '受診英語名称
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntConsultName = Empty
    vntConsultEName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "GRPCD_STOMAC", GRPCD_STOMAC, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FREECD_STOMAC", FREECD_STOMAC, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号の胃部受診情報を取得
    strStmt = "SELECT FREE.FREEFIELD3, FREE.FREEFIELD4         " & vbLf & _
              "  FROM FREE, GRP_I, CONSULTITEMLIST             " & vbLf & _
              " WHERE CONSULTITEMLIST.RSVNO  = :RSVNO          " & vbLf & _
              "   AND GRP_I.GRPCD            = :GRPCD_STOMAC   " & vbLf & _
              "   AND FREE.FREECD         LIKE :FREECD_STOMAC  " & vbLf & _
              "   AND CONSULTITEMLIST.ITEMCD = GRP_I.ITEMCD    " & vbLf & _
              "   AND GRP_I.GRPCD            = FREE.FREEFIELD1 " & vbLf & _
              "   AND GRP_I.SEQ              = FREE.FREEFIELD2 " & vbLf & _
              " ORDER BY FREE.FREECD                           "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objConsultName = objFields("FREEFIELD3")
        Set objConsultEName = objFields("FREEFIELD4")
        
        '戻り値の設定
        vntConsultName = objConsultName.Value & ""
        vntConsultEName = objConsultEName.Value & ""

        SelectStomacConsultInfo = True

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
    WriteErrorLog "Consult.SelectStomacConsultInfo"

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 送信日時、送信者を更新する
'
' 引数   　: (In)     lngRsvNo   予約番号
'     　　 : (In)     strUserId  ユーザID
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateConsult(ByVal lngRsvNo As Long, ByVal strUserId As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
 
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SENDMAILUSER", strUserId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '送信日時、送信者の更新
    strStmt = "UPDATE CONSULT                      " & vbLf & _
              "   SET SENDMAILDATE = SYSDATE,      " & vbLf & _
              "       SENDMAILUSER = :SENDMAILUSER " & vbLf & _
              " WHERE RSVNO        = :RSVNO        "
          
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
   
   '戻り値の設定
    UpdateConsult = True
    
    Exit Function

ErrorHandle:

    UpdateConsult = False

    'イベントログ書き込み
    WriteErrorLog "Consult.UpdateConsult"

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

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
