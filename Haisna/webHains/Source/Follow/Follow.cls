VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Follow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext             As ObjectContext            'オブジェクトコンテキスト

Private mobjOraSession          As OraSession               'OraSessionオブジェクト
Private mobjOraDb               As OraDatabase              'OraDatabaseオブジェクト

Private Const KYOUBU_GRPCD As String = "X881"               '胸部・甲状腺関連検査項目グループコード
Private Const HUKUBU_GRPCD As String = "X882"               '腹部関連検査項目グループコード
Private Const SYOUKA_GRPCD As String = "X883"               '消化管関連検査項目グループコード

'### 2016.09.07 張 婦人科関連項目追加 #######################################################
Private Const FUJIN_GRPCD  As String = "X884"               '婦人科関連検査項目グループコード

'コンピュータ名を取得する関数の宣言
Private Declare Function GetComputerName Lib "kernel32.dll" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
'
' 機能　　 : フォロー対象検査項目を取得する
'
' 引数　　 : (Out)    vntItemName     検査項目（判定分類）名称
'
' 戻り値　 : フォロー対象検査項目レコード件数
'
' 備考　　 :
'
Public Function SelectFollowItem(ByRef vntItemCd As Variant, ByRef vntItemName As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         'フォロー対象検査項目コード
    Dim objItemName         As OraField         'フォロー対象検査項目名称

    Dim vntArrItemCd()      As Variant          'フォロー対象検査項目コードの配列
    Dim vntArrItemName()    As Variant          'フォロー対象検査項目名称の配列

    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
   
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "FOLJUDCLCD", "FOLJUDCL%", ORAPARM_INPUT, ORATYPE_VARCHAR2

    strStmt = strStmt & vbLf & _
              "SELECT FREE.FREEFIELD1     AS ITEMCD       " & vbLf & _
              "      ,FREE.FREEFIELD3     AS ITEMNAME     " & vbLf & _
              "  FROM FREE                                " & vbLf & _
              " WHERE FREE.FREECD LIKE :FOLJUDCLCD        " & vbLf & _
              " ORDER BY TO_NUMBER(FREE.FREEFIELD2)       "
                
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objItemName = objFields("ITEMNAME")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            lngCount = lngCount + 1

            objOraDyna.MoveNext
        Loop
    
        If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
        If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
    
    End If
    
'    vntItemCd = vntArrItemCd
'    vntItemName = vntArrItemName
    
    SelectFollowItem = lngCount
        
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectFollowItem = -1

    'イベントログ書き込み ## クラス名修正 2004.01.13
    WriteErrorLog "Follow.SelectFollowItem"
    
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
' 機能　　 : 指定予約番号の直前のフォロー情報を取得する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (Out)    vntRsvNo          前回予約番号
' 　　　　   (Out)    vntCslDate        前回受診日
' 　　　　   (Out)    vntCsCd           前回コースコード
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 : 前回は１日人間ドックOr企業健診
'
Public Function SelectFollow_Before(ByVal lngRsvNo As Long, ByRef vntRsvNo As Variant, _
                                    ByRef vntCsldate As Variant, ByRef vntCscd As Variant) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objRsvNo                As OraField         '前回予約番号
    Dim objCslDate              As OraField         '前回受診日
    Dim objCscd                 As OraField         '前回コースコード

    Dim lngCount                As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCsldate) Then vntCsldate = Empty
    If Not IsMissing(vntCscd) Then vntCscd = Empty

    SelectFollow_Before = False

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FREECD", "CSC01%", ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号のフォロー情報を取得する
    strStmt = ""
    strStmt = strStmt & vbLf & "SELECT FOLLOW_INFO.RSVNO, LASTCONSULT.CSLDATE,          "
    strStmt = strStmt & vbLf & "       LASTCONSULT.CSCD                                 "
    strStmt = strStmt & vbLf & "  FROM FOLLOW_INFO,                                     "
    strStmt = strStmt & vbLf & "    (SELECT RSVNO, CSLDATE, CSCD FROM                   "
    strStmt = strStmt & vbLf & "       (SELECT B.RSVNO RSVNO, B.CSLDATE CSLDATE,        "
    strStmt = strStmt & vbLf & "               B.CSCD CSCD                              "
    strStmt = strStmt & vbLf & "          FROM CONSULT A, CONSULT B                     "
    strStmt = strStmt & vbLf & "         WHERE A.RSVNO = :RSVNO                         "
    strStmt = strStmt & vbLf & "           AND A.PERID           = B.PERID              "
    strStmt = strStmt & vbLf & "           AND A.CSLDATE         > B.CSLDATE            "
    strStmt = strStmt & vbLf & "           AND B.CSCD IN (                              "
    strStmt = strStmt & vbLf & "                          SELECT FREEFIELD1 FROM FREE   "
    strStmt = strStmt & vbLf & "                           WHERE FREECD LIKE :FREECD    "
    strStmt = strStmt & vbLf & "                         )                              "
    strStmt = strStmt & vbLf & "         ORDER BY B.CSLDATE DESC)                       "
    strStmt = strStmt & vbLf & "      WHERE ROWNUM = 1) LASTCONSULT                     "
    strStmt = strStmt & vbLf & " WHERE FOLLOW_INFO.RSVNO = LASTCONSULT.RSVNO            "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objCscd = objFields("CSCD")

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = objRsvNo.Value & ""
        If Not IsMissing(vntCsldate) Then vntCsldate = objCslDate.Value & ""
        If Not IsMissing(vntCscd) Then vntCscd = objCscd.Value & ""
        SelectFollow_Before = True

    End If

    Set objRsvNo = Nothing
    Set objCslDate = Nothing
    Set objCscd = Nothing
    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectFollow_Before = False

    'イベントログ書き込み
    WriteErrorLog "Follow.SelectFollow_Before"

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
' 機能　　 : 指定個人IDのフォロー情報の受診歴一覧を取得する
'
' 引数　　 : (In)     strPerId          個人ID
' 　　　　   (In)     lngRsvNo          予約番号
' 　　　　   (Out)    vntRsvNo          予約番号
' 　　　　   (Out)    vntCslDate        受診日
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectFollowHistory(ByVal strPerId As String, ByVal lngRsvNo As Long, _
                                    Optional ByRef vntRsvNo As Variant, Optional ByRef vntCsldate As Variant) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objRsvNo                As OraField         '予約番号
    Dim objCslDate              As OraField         '受診日

    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrCsldate()         As Variant          '受診日の配列

    Dim lngCount                As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCsldate) Then vntCsldate = Empty
    SelectFollowHistory = False
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号のフォロー情報を取得する
    strStmt = "SELECT DISTINCT HISTORY.RSVNO, HISTORY.CSLDATE               " & vbLf & _
              "  FROM ( SELECT CONSULT.CSLDATE,  CONSULT.RSVNO              " & vbLf & _
              "           FROM CONSULT                                      " & vbLf & _
              "               ,RECEIPT                                      " & vbLf & _
              "               ,FOLLOW_INFO                                  " & vbLf & _
              "          WHERE CONSULT.PERID    = :PERID                    " & vbLf & _
              "            AND CONSULT.CSLDATE <=                           " & vbLf & _
              "                (SELECT CSLDATE FROM CONSULT                 " & vbLf & _
              "                  WHERE RSVNO = :RSVNO)                      " & vbLf & _
              "            AND CONSULT.CANCELFLG = 0                        " & vbLf & _
              "            AND CONSULT.RSVNO    = RECEIPT.RSVNO             " & vbLf & _
              "            AND RECEIPT.COMEDATE IS NOT NULL                 " & vbLf & _
              "            AND CONSULT.RSVNO    = FOLLOW_INFO.RSVNO         " & vbLf & _
              "          UNION                                              " & vbLf & _
              "         SELECT CONSULT.CSLDATE,  CONSULT.RSVNO              " & vbLf & _
              "           FROM CONSULT                                      " & vbLf & _
              "          WHERE CONSULT.RSVNO     = :RSVNO                   " & vbLf & _
              "            AND CONSULT.CANCELFLG = 0                        " & vbLf & _
              "       ) HISTORY                                             " & vbLf & _
              " ORDER BY HISTORY.CSLDATE DESC                               "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")

        'レコードの検索
        Do Until objOraDyna.EOF

            '配列形式で格納する
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCsldate(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCsldate(lngCount) = objCslDate.Value & ""
            
            lngCount = lngCount + 1

            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCsldate) Then vntCsldate = vntArrCsldate
        SelectFollowHistory = lngCount

    End If

    Set objRsvNo = Nothing
    Set objCslDate = Nothing
    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectFollowHistory = -1

    'イベントログ書き込み
    WriteErrorLog "Follow.SelectFollowHistory"

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
' 機能　　 : 指定予約番号のフォロー状況管理情報を取得する
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (In)     lngJudClassCd         判定分類コード
' 　　　　   (Out)    vntJudClassCd         判定分類コード
' 　　　　   (Out)    vntJudClassName       判定分類名
' 　　　　   (Out)    vntJudCd              判定コード（フォロー確定時判定結果）
' 　　　　   (Out)    vntRslJudCd           判定コード（カレント（現在）判定結果）
' 　　　　   (Out)    vntSecEquipDiv        二次検査実施（施設）区分
' 　　　　   (Out)    vntUpdDate            更新日時
' 　　　　   (Out)    vntUpdUser            更新者ID
' 　　　　   (Out)    vntUpdUserName        更新者氏名
' 　　　　   (Out)    vntStatusCd           ステータス
' 　　　　   (Out)    vntSecEquipName       病医院名
' 　　　　   (Out)    vntSecEquipCourse     診療科
' 　　　　   (Out)    vntSecDoctor          担当医師
' 　　　　   (Out)    vntSecEquipAddr       病医院住所
' 　　　　   (Out)    vntSecEquipTel        病医院電話番号
' 　　　　   (Out)    vntSecPlanDate        二次検査予定日
' 　　　　   (Out)    vntReqSendDate        依頼状発送日
' 　　　　   (Out)    vntReqSendUser        依頼状発送者ID
' 　　　　   (Out)    vntReqSendUserName    依頼状発送者氏名
' 　　　　   (Out)    vntReqCheckDate1      第一勧奨日
' 　　　　   (Out)    vntReqCheckDate2      第二勧奨日
' 　　　　   (Out)    vntReqCheckDate3      第三勧奨日（予備）
' 　　　　   (Out)    vntReqCancelDate      勧奨中止日
' 　　　　   (Out)    vntReqConfirmDate     結果承認日
' 　　　　   (Out)    vntReqConfirmUser     結果承認者ID
' 　　　　   (Out)    vntReqConfirmUserName 結果承認者氏名
' 　　　　   (Out)    vntSecRemark          備考
'　　　      (Out)    vntRsvTestName        二次検査予定項目
' 　　　　   (Out)    vntRsvTestUS          二次検査予約項目 US
' 　　　　   (Out)    vntRsvTestCT          二次検査予約項目 CT
' 　　　　   (Out)    vntRsvTestMRI         二次検査予約項目 MRI
' 　　　　   (Out)    vntRsvTestBF          二次検査予約項目 BF
' 　　　　   (Out)    vntRsvTestGF          二次検査予約項目 GF
' 　　　　   (Out)    vntRsvTestCF          二次検査予約項目 CF
' 　　　　   (Out)    vntRsvTestEM          二次検査予約項目 注腸
' 　　　　   (Out)    vntRsvTestTM          二次検査予約項目 腫瘍マーカー
' 　　　　   (Out)    vntRsvTestEtc         二次検査予約項目 その他
' 　　　　   (Out)    vntRsvTestRemark      二次検査予約項目 その他コメント
' 　　　　   (Out)    vntRsvTestRefer       二次検査予約項目 リファー
' 　　　　   (Out)    vntRsvTestReferText   二次検査予約項目 リファー科

' 　　　　   (Out)    vntAddDate            登録日時
' 　　　　   (Out)    vntAddUser            登録者ID
' 　　　　   (Out)    vntAddUserName        登録者氏名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectFollow_Info(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, _
                                  Optional ByRef vntJudClassName As Variant, _
                                  Optional ByRef vntJudCd As Variant, Optional ByRef vntRslJudCd As Variant, _
                                  Optional ByRef vntSecEquipDiv As Variant, Optional ByRef vntUpdDate As Variant, _
                                  Optional ByRef vntUpdUser As Variant, Optional ByRef vntUpdUserName As Variant, _
                                  Optional ByRef vntStatusCd As Variant, Optional ByRef vntSecEquipName As Variant, _
                                  Optional ByRef vntSecEquipCourse As Variant, _
                                  Optional ByRef vntSecDoctor As Variant, Optional ByRef vntSecEquipAddr As Variant, _
                                  Optional ByRef vntSecEquipTel As Variant, Optional ByRef vntSecPlanDate As Variant, _
                                  Optional ByRef vntReqSendDate As Variant, Optional ByRef vntReqSendUser As Variant, _
                                  Optional ByRef vntReqSendUserName As Variant, Optional ByRef vntReqCheckDate1 As Variant, _
                                  Optional ByRef vntReqCheckDate2 As Variant, Optional ByRef vntReqCheckDate3 As Variant, _
                                  Optional ByRef vntReqCancelDate As Variant, Optional ByRef vntReqConfirmDate As Variant, _
                                  Optional ByRef vntReqConfirmUser As Variant, Optional ByRef vntReqConfirmUserName As Variant, _
                                  Optional ByRef vntSecRemark As Variant, _
                                  Optional ByRef vntRsvTestName As Variant, _
                                  Optional ByRef vntRsvTestUS As Variant, Optional ByRef vntRsvTestCT As Variant, _
                                  Optional ByRef vntRsvTestMRI As Variant, Optional ByRef vntRsvTestBF As Variant, _
                                  Optional ByRef vntRsvTestGF As Variant, Optional ByRef vntRsvTestCF As Variant, _
                                  Optional ByRef vntRsvTestEM As Variant, Optional ByRef vntRsvTestTM As Variant, _
                                  Optional ByRef vntRsvTestEtc As Variant, Optional ByRef vntRsvTestRemark As Variant, _
                                  Optional ByRef vntRsvTestRefer As Variant, Optional ByRef vntRsvTestReferText As Variant, _
                                  Optional ByRef vntAddDate As Variant, _
                                  Optional ByRef vntAddUser As Variant, Optional ByRef vntAddUserName As Variant _
                                 ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名
    Dim objJudCd                As OraField         '判定コード（フォロー確定時判定結果）
    Dim objRslJudCd             As OraField         '判定コード（カレント（現在）判定結果）
    Dim objSecEquipDiv          As OraField         '二次検査実施（施設）区分
    Dim objAddDate              As OraField         '登録日時
    Dim objAddUser              As OraField         '登録者ID
    Dim objAddUserName          As OraField         '登録者氏名
    Dim objUpdDate              As OraField         '更新日時
    Dim objUpdUser              As OraField         '更新者ID
    Dim objUpdUserName          As OraField         '更新者氏名
    Dim objStatusCd             As OraField         'ステータス
    Dim objSecEquipName         As OraField         '病医院名
    Dim objSecEquipCourse       As OraField         '診療科
    Dim objSecDoctor            As OraField         '担当医師
    Dim objSecEquipAddr         As OraField         '病医院住所
    Dim objSecEquipTel          As OraField         '病医院電話番号
    Dim objSecPlanDate          As OraField         '二次検査予定日
    ' 2009/12/24 二次検査予約項目追加　：yhlee -----------------------------------
    Dim objRsvTestUS               As OraField         '検査項目US
    Dim objRsvTestCT               As OraField         '検査項目CT
    Dim objRsvTestMRI              As OraField         '検査項目MRI
    Dim objRsvTestBF               As OraField         '検査項目BF
    Dim objRsvTestGF               As OraField         '検査項目GF
    Dim objRsvTestCF               As OraField         '検査項目CF
    Dim objRsvTestEM               As OraField         '検査項目注腸
    Dim objRsvTestTM               As OraField         '検査項目腫瘍マーカー
    Dim objRsvTestEtc              As OraField         '検査項目その他
    Dim objRsvTestRemark           As OraField         '検査項目その他内容
    Dim objRsvTestRefer            As OraField         '検査項目リファー
    Dim objRsvTestReferText        As OraField         '検査項目リファー科
    Dim objRsvTestName             As OraField         '二次検査予定項目
    ' 2009/12/24 二次検査予約項目追加　(End) -----------------------------------
    
    Dim objReqSendDate          As OraField         '依頼状発送日
    Dim objReqSendUser          As OraField         '依頼状発送者ID
    Dim objReqSendUserName      As OraField         '依頼状発送者氏名
    Dim objReqCheckDate1        As OraField         '第一勧奨日
    Dim objReqCheckDate2        As OraField         '第二勧奨日
    Dim objReqCheckDate3        As OraField         '第三勧奨日（予備）
    Dim objReqCancelDate        As OraField         '勧奨中止日
    Dim objReqConfirmDate       As OraField         '結果承認日
    Dim objReqConfirmUser       As OraField         '結果承認者ID
    Dim objReqConfirmUserName   As OraField         '結果承認者氏名
    Dim objSecRemark            As OraField         '備考
    
    Dim lngCount                As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntJudClassName) Then vntJudClassName = Empty
    If Not IsMissing(vntJudCd) Then vntJudCd = Empty
    If Not IsMissing(vntRslJudCd) Then vntRslJudCd = Empty
    If Not IsMissing(vntSecEquipDiv) Then vntSecEquipDiv = Empty
    If Not IsMissing(vntAddDate) Then vntAddDate = Empty
    If Not IsMissing(vntAddUser) Then vntAddUser = Empty
    If Not IsMissing(vntAddUserName) Then vntAddUserName = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUpdUserName) Then vntUpdUserName = Empty
    If Not IsMissing(vntStatusCd) Then vntStatusCd = Empty
    If Not IsMissing(vntSecEquipName) Then vntSecEquipName = Empty
    If Not IsMissing(vntSecEquipCourse) Then vntSecEquipCourse = Empty
    If Not IsMissing(vntSecDoctor) Then vntSecDoctor = Empty
    If Not IsMissing(vntSecEquipAddr) Then vntSecEquipAddr = Empty
    If Not IsMissing(vntSecEquipTel) Then vntSecEquipTel = Empty
    If Not IsMissing(vntSecPlanDate) Then vntSecPlanDate = Empty
    ' 2009/12/24 二次検査予約項目追加　：yhlee -----------------
    If Not IsMissing(vntRsvTestUS) Then vntRsvTestUS = Empty
    If Not IsMissing(vntRsvTestCT) Then vntRsvTestCT = Empty
    If Not IsMissing(vntRsvTestMRI) Then vntRsvTestMRI = Empty
    If Not IsMissing(vntRsvTestBF) Then vntRsvTestBF = Empty
    If Not IsMissing(vntRsvTestGF) Then vntRsvTestGF = Empty
    If Not IsMissing(vntRsvTestCF) Then vntRsvTestCF = Empty
    If Not IsMissing(vntRsvTestEM) Then vntRsvTestEM = Empty
    If Not IsMissing(vntRsvTestTM) Then vntRsvTestTM = Empty
    If Not IsMissing(vntRsvTestEtc) Then vntRsvTestEtc = Empty
    If Not IsMissing(vntRsvTestRemark) Then vntRsvTestRemark = Empty
    If Not IsMissing(vntRsvTestRefer) Then vntRsvTestRefer = Empty
    If Not IsMissing(vntRsvTestReferText) Then vntRsvTestReferText = Empty
    If Not IsMissing(vntRsvTestName) Then vntRsvTestName = Empty
    ' 2009/12/24 二次検査予約項目追加　(End) ------------------
    If Not IsMissing(vntReqSendDate) Then vntReqSendDate = Empty
    If Not IsMissing(vntReqSendUser) Then vntReqSendUser = Empty
    If Not IsMissing(vntReqSendUserName) Then vntReqSendUserName = Empty
    If Not IsMissing(vntReqCheckDate1) Then vntReqCheckDate1 = Empty
    If Not IsMissing(vntReqCheckDate2) Then vntReqCheckDate2 = Empty
    If Not IsMissing(vntReqCheckDate3) Then vntReqCheckDate3 = Empty
    If Not IsMissing(vntReqCancelDate) Then vntReqCancelDate = Empty
    If Not IsMissing(vntReqConfirmDate) Then vntReqConfirmDate = Empty
    If Not IsMissing(vntReqConfirmUser) Then vntReqConfirmUser = Empty
    If Not IsMissing(vntReqConfirmUserName) Then vntReqConfirmUserName = Empty
    If Not IsMissing(vntSecRemark) Then vntSecRemark = Empty
    
    SelectFollow_Info = False
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号と検査項目（判定分類）のフォロー情報を取得する
    strStmt = ""
    strStmt = "SELECT FOLLOW_INFO.SECEQUIPDIV,                              "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.ADDDATE,         FOLLOW_INFO.ADDUSER,        "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.UPDDATE,         FOLLOW_INFO.UPDUSER,        "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.JUDCD,           FOLLOW_INFO.STATUSCD,       "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.SECEQUIPNAME,    FOLLOW_INFO.SECEQUIPCOURSE, "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.SECDOCTOR,                                   "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.SECEQUIPADDR,    FOLLOW_INFO.SECEQUIPTEL,    "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.SECPLANDATE,     FOLLOW_INFO.REQSENDDATE,    "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.REQSENDUSER,                                 "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.REQCHECKDATE1,   FOLLOW_INFO.REQCHECKDATE2,  "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.REQCHECKDATE3,   FOLLOW_INFO.REQCANCELDATE,  "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.REQCONFIRMDATE,  FOLLOW_INFO.REQCONFIRMUSER, "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.SECREMARK,                                   "
    ' 2009/12/24 二次検査予約項目追加　：yhlee -----------------
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.RSVTESTUS,       FOLLOW_INFO.RSVTESTCT,          "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.RSVTESTMRI,      FOLLOW_INFO.RSVTESTBF,          "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.RSVTESTGF,       FOLLOW_INFO.RSVTESTCF,          "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.RSVTESTEM,       FOLLOW_INFO.RSVTESTTM,          "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.RSVTESTETC,      FOLLOW_INFO.RSVTESTREMARK,      "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.RSVTESTREFER,    FOLLOW_INFO.RSVTESTREFERTEXT,   "
    strStmt = strStmt & vbLf & "       FOL_GET_SecRsvExam(FOLLOW_INFO.RSVNO,FOLLOW_INFO.JUDCLASSCD) AS RSVTESTNAME,   "
    ' 2009/12/24 二次検査予約項目追加　(End) ------------------
    strStmt = strStmt & vbLf & "       HAINSUSER.USERNAME,          JUDRSL.JUDCD  RSLJUDCD,     "
    strStmt = strStmt & vbLf & "       FOLLOW_INFO.JUDCLASSCD,      JUDCLASS.JUDCLASSNAME,      "
    strStmt = strStmt & vbLf & "       (SELECT HUSER.USERNAME  FROM HAINSUSER HUSER             "
    strStmt = strStmt & vbLf & "         WHERE HUSER.USERID = FOLLOW_INFO.REQCONFIRMUSER        "
    strStmt = strStmt & vbLf & "       ) AS REQCONFIRMUSERNAME,                                 "
    strStmt = strStmt & vbLf & "       (SELECT HUSER2.USERNAME  FROM HAINSUSER HUSER2           "
    strStmt = strStmt & vbLf & "         WHERE HUSER2.USERID = FOLLOW_INFO.REQSENDUSER          "
    strStmt = strStmt & vbLf & "       ) AS REQSENDUSERNAME,                                    "
    strStmt = strStmt & vbLf & "       (SELECT HUSER3.USERNAME  FROM HAINSUSER HUSER3           "
    strStmt = strStmt & vbLf & "         WHERE HUSER3.USERID = FOLLOW_INFO.ADDUSER              "
    strStmt = strStmt & vbLf & "       ) AS ADDUSERNAME                                         "
    strStmt = strStmt & vbLf & "  FROM FOLLOW_INFO, JUDRSL, HAINSUSER, JUDCLASS                 "
    strStmt = strStmt & vbLf & " WHERE FOLLOW_INFO.RSVNO      = :RSVNO                          "
    '### 判定分類コード（パラメータ）が「999」の場合、予約情報（予約番号）別フォローアップ情報取得
    If lngJudClassCd <> 999 Then
        strStmt = strStmt & vbLf & "   AND FOLLOW_INFO.JUDCLASSCD = :JUDCLASSCD                     "
    End If
    strStmt = strStmt & vbLf & "   AND FOLLOW_INFO.RSVNO      = JUDRSL.RSVNO(+)                 "
    strStmt = strStmt & vbLf & "   AND FOLLOW_INFO.JUDCLASSCD = JUDRSL.JUDCLASSCD(+)            "
    strStmt = strStmt & vbLf & "   AND FOLLOW_INFO.UPDUSER    = HAINSUSER.USERID(+)             "
    strStmt = strStmt & vbLf & "   AND FOLLOW_INFO.JUDCLASSCD = JUDCLASS.JUDCLASSCD(+)          "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objJudCd = objFields("JUDCD")
        Set objRslJudCd = objFields("RSLJUDCD")
        Set objSecEquipDiv = objFields("SECEQUIPDIV")
        Set objAddDate = objFields("ADDDATE")
        Set objAddUser = objFields("ADDUSER")
        Set objAddUserName = objFields("ADDUSERNAME")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUpdUserName = objFields("USERNAME")
        Set objStatusCd = objFields("STATUSCD")
        Set objSecEquipName = objFields("SECEQUIPNAME")
        Set objSecEquipCourse = objFields("SECEQUIPCOURSE")
        Set objSecDoctor = objFields("SECDOCTOR")
        Set objSecEquipAddr = objFields("SECEQUIPADDR")
        Set objSecEquipTel = objFields("SECEQUIPTEL")
        Set objSecPlanDate = objFields("SECPLANDATE")
        ' 2009/12/24 二次検査予約項目追加　：yhlee -----------------
        Set objRsvTestUS = objFields("RSVTESTUS")
        Set objRsvTestCT = objFields("RSVTESTCT")
        Set objRsvTestMRI = objFields("RSVTESTMRI")
        Set objRsvTestBF = objFields("RSVTESTBF")
        Set objRsvTestGF = objFields("RSVTESTGF")
        Set objRsvTestCF = objFields("RSVTESTCF")
        Set objRsvTestEM = objFields("RSVTESTEM")
        Set objRsvTestTM = objFields("RSVTESTTM")
        Set objRsvTestEtc = objFields("RSVTESTETC")
        Set objRsvTestRemark = objFields("RSVTESTREMARK")
        Set objRsvTestRefer = objFields("RSVTESTREFER")
        Set objRsvTestReferText = objFields("RSVTESTREFERTEXT")
        Set objRsvTestName = objFields("RSVTESTNAME")
        ' 2009/12/24 二次検査予約項目追加　(End) ------------------
        Set objReqSendDate = objFields("REQSENDDATE")
        Set objReqSendUser = objFields("REQSENDUSER")
        Set objReqSendUserName = objFields("REQSENDUSERNAME")
        Set objReqCheckDate1 = objFields("REQCHECKDATE1")
        Set objReqCheckDate2 = objFields("REQCHECKDATE2")
        Set objReqCheckDate3 = objFields("REQCHECKDATE3")
        Set objReqCancelDate = objFields("REQCANCELDATE")
        Set objReqConfirmDate = objFields("REQCONFIRMDATE")
        Set objReqConfirmUser = objFields("REQCONFIRMUSER")
        Set objReqConfirmUserName = objFields("REQCONFIRMUSERNAME")
        Set objSecRemark = objFields("SECREMARK")

        '戻り値の設定
        If Not IsMissing(vntJudClassName) Then vntJudClassName = objJudClassName.Value & ""
        If Not IsMissing(vntJudCd) Then vntJudCd = objJudCd.Value & ""
        If Not IsMissing(vntRslJudCd) Then vntRslJudCd = objRslJudCd.Value & ""
        If Not IsMissing(vntSecEquipDiv) Then vntSecEquipDiv = objSecEquipDiv.Value & ""
        If Not IsMissing(vntAddDate) Then vntAddDate = objAddDate.Value & ""
        If Not IsMissing(vntAddUser) Then vntAddUser = objAddUser.Value & ""
        If Not IsMissing(vntAddUserName) Then vntAddUserName = objAddUserName.Value & ""
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntUpdUser) Then vntUpdUser = objUpdUser.Value & ""
        If Not IsMissing(vntUpdUserName) Then vntUpdUserName = objUpdUserName.Value & ""
        If Not IsMissing(vntStatusCd) Then vntStatusCd = objStatusCd.Value & ""
        If Not IsMissing(vntSecEquipName) Then vntSecEquipName = objSecEquipName.Value & ""
        If Not IsMissing(vntSecEquipCourse) Then vntSecEquipCourse = objSecEquipCourse.Value & ""
        If Not IsMissing(vntSecDoctor) Then vntSecDoctor = objSecDoctor.Value & ""
        If Not IsMissing(vntSecEquipAddr) Then vntSecEquipAddr = objSecEquipAddr.Value & ""
        If Not IsMissing(vntSecEquipTel) Then vntSecEquipTel = objSecEquipTel.Value & ""
        If Not IsMissing(vntSecPlanDate) Then vntSecPlanDate = objSecPlanDate.Value & ""
        ' 2009/12/24 二次検査予約項目追加　(End) ------------------
        If Not IsMissing(vntRsvTestUS) Then vntRsvTestUS = objRsvTestUS.Value & ""
        If Not IsMissing(vntRsvTestCT) Then vntRsvTestCT = objRsvTestCT.Value & ""
        If Not IsMissing(vntRsvTestMRI) Then vntRsvTestMRI = objRsvTestMRI.Value & ""
        If Not IsMissing(vntRsvTestBF) Then vntRsvTestBF = objRsvTestBF.Value & ""
        If Not IsMissing(vntRsvTestGF) Then vntRsvTestGF = objRsvTestGF.Value & ""
        If Not IsMissing(vntRsvTestCF) Then vntRsvTestCF = objRsvTestCF.Value & ""
        If Not IsMissing(vntRsvTestEM) Then vntRsvTestEM = objRsvTestEM.Value & ""
        If Not IsMissing(vntRsvTestTM) Then vntRsvTestTM = objRsvTestTM.Value & ""
        If Not IsMissing(vntRsvTestEtc) Then vntRsvTestEtc = objRsvTestEtc.Value & ""
        If Not IsMissing(vntRsvTestRemark) Then vntRsvTestRemark = objRsvTestRemark.Value & ""
        If Not IsMissing(vntRsvTestRefer) Then vntRsvTestRefer = objRsvTestRefer.Value & ""
        If Not IsMissing(vntRsvTestReferText) Then vntRsvTestReferText = objRsvTestReferText.Value & ""
        If Not IsMissing(vntRsvTestName) Then vntRsvTestName = objRsvTestName.Value & ""
        ' 2009/12/24 二次検査予約項目追加　(End) ------------------
        If Not IsMissing(vntReqSendDate) Then vntReqSendDate = objReqSendDate.Value & ""
        If Not IsMissing(vntReqSendUser) Then vntReqSendUser = objReqSendUser.Value & ""
        If Not IsMissing(vntReqSendUserName) Then vntReqSendUserName = objReqSendUserName.Value & ""
        If Not IsMissing(vntReqCheckDate1) Then vntReqCheckDate1 = objReqCheckDate1.Value & ""
        If Not IsMissing(vntReqCheckDate2) Then vntReqCheckDate2 = objReqCheckDate2.Value & ""
        If Not IsMissing(vntReqCheckDate3) Then vntReqCheckDate3 = objReqCheckDate3.Value & ""
        If Not IsMissing(vntReqCancelDate) Then vntReqCancelDate = objReqCancelDate.Value & ""
        If Not IsMissing(vntReqConfirmDate) Then vntReqConfirmDate = objReqConfirmDate.Value & ""
        If Not IsMissing(vntReqConfirmUser) Then vntReqConfirmUser = objReqConfirmUser.Value & ""
        If Not IsMissing(vntReqConfirmUserName) Then vntReqConfirmUserName = objReqConfirmUserName.Value & ""
        If Not IsMissing(vntSecRemark) Then vntSecRemark = objSecRemark.Value & ""
        
        SelectFollow_Info = True
    
    End If

    Set objJudClassCd = Nothing
    Set objJudClassName = Nothing
    Set objJudCd = Nothing
    Set objRslJudCd = Nothing
    Set objSecEquipDiv = Nothing
    Set objAddDate = Nothing
    Set objAddUser = Nothing
    Set objAddUserName = Nothing
    Set objUpdDate = Nothing
    Set objUpdUser = Nothing
    Set objUpdUserName = Nothing
    Set objStatusCd = Nothing
    Set objSecEquipName = Nothing
    Set objSecEquipCourse = Nothing
    Set objSecDoctor = Nothing
    Set objSecEquipAddr = Nothing
    Set objSecEquipTel = Nothing
    Set objSecPlanDate = Nothing
    ' 2009/12/24 二次検査予約項目追加　：yhlee -------
    Set objRsvTestUS = Nothing
    Set objRsvTestCT = Nothing
    Set objRsvTestMRI = Nothing
    Set objRsvTestBF = Nothing
    Set objRsvTestGF = Nothing
    Set objRsvTestCF = Nothing
    Set objRsvTestEM = Nothing
    Set objRsvTestTM = Nothing
    Set objRsvTestEtc = Nothing
    Set objRsvTestRemark = Nothing
    Set objRsvTestRefer = Nothing
    Set objRsvTestReferText = Nothing
    Set objRsvTestName = Nothing
    ' 2009/12/24 二次検査予約項目追加　(End) --------
    Set objReqSendDate = Nothing
    Set objReqSendUser = Nothing
    Set objReqSendUserName = Nothing
    Set objReqCheckDate1 = Nothing
    Set objReqCheckDate2 = Nothing
    Set objReqCheckDate3 = Nothing
    Set objReqCancelDate = Nothing
    Set objReqConfirmDate = Nothing
    Set objReqConfirmUser = Nothing
    Set objReqConfirmUserName = Nothing
    Set objSecRemark = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectFollow_Info = False

    'イベントログ書き込み
    WriteErrorLog "Follow.SelectFollow_Info"

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
' 機能　　 : フォローアップ結果情報を取得する（受診者・判定分類別特定結果情報）
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (In)     lngJudClassCd         判定分類コード
' 　　　　   (In)     lngSEQ                一連番号
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectFollow_Rsl(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, ByVal lngSeq As Long, _
                                 Optional ByRef vntSecCslDate As Variant, Optional ByRef vntUpdDate As Variant, _
                                 Optional ByRef vntUpdUser As Variant, Optional ByRef vntUpdUserName As Variant, _
                                 Optional ByRef vntTestUS As Variant, Optional ByRef vntTestCT As Variant, _
                                 Optional ByRef vntTestMRI As Variant, Optional ByRef vntTestBF As Variant, _
                                 Optional ByRef vntTestGF As Variant, Optional ByRef vntTestCF As Variant, _
                                 Optional ByRef vntTestEM As Variant, Optional ByRef vntTestTM As Variant, _
                                 Optional ByRef vntTestEtc As Variant, Optional ByRef vntTestRemark As Variant, _
                                 Optional ByRef vntTestRefer As Variant, Optional ByRef vntTestReferText As Variant, _
                                 Optional ByRef vntResultDiv As Variant, Optional ByRef vntDisRemark As Variant, _
                                 Optional ByRef vntPolWithout As Variant, Optional ByRef vntPolFollowup As Variant, _
                                 Optional ByRef vntPolMonth As Variant, Optional ByRef vntPolReExam As Variant, _
                                 Optional ByRef vntPolDiagSt As Variant, Optional ByRef vntPolDiag As Variant, Optional ByRef vntPolEtc1 As Variant, _
                                 Optional ByRef vntPolRemark1 As Variant, Optional ByRef vntPolSugery As Variant, _
                                 Optional ByRef vntPolEndoscope As Variant, Optional ByRef vntPolChemical As Variant, _
                                 Optional ByRef vntPolRadiation As Variant, Optional ByRef vntPolReferSt As Variant, Optional ByRef vntPolRefer As Variant, _
                                 Optional ByRef vntPolEtc2 As Variant, Optional ByRef vntPolRemark2 As Variant _
                                ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objSecCslDate           As OraField         '二次検査実施日
    Dim objUpdDate              As OraField         '更新日時
    Dim objUpdUser              As OraField         '更新者ID
    Dim objUpdUserName          As OraField         '更新者氏名
    Dim objTestUS               As OraField         '検査項目US
    Dim objTestCT               As OraField         '検査項目CT
    Dim objTestMRI              As OraField         '検査項目MRI
    Dim objTestBF               As OraField         '検査項目BF
    Dim objTestGF               As OraField         '検査項目GF
    Dim objTestCF               As OraField         '検査項目CF
    Dim objTestEM               As OraField         '検査項目注腸
    Dim objTestTM               As OraField         '検査項目腫瘍マーカー
    Dim objTestEtc              As OraField         '検査項目その他
    Dim objTestRemark           As OraField         '検査項目その他内容
    Dim objTestRefer            As OraField         '検査項目リファー
    Dim objTestReferText        As OraField         '検査項目リファー科
    Dim objResultDiv            As OraField         '二次検査結果区分
    Dim objDisRemark            As OraField         'その他疾患
    Dim objPolWithout           As OraField         '処置不要
    Dim objPolFollowup          As OraField         '経過観察
    Dim objPolMonth             As OraField         '経過観察期間（ヶ月）
    Dim objPolReExam            As OraField         '一年後健診
    Dim objPolDiagSt            As OraField         '本院紹介（精査）
    Dim objPolDiag              As OraField         '他院紹介（精査）
    Dim objPolEtc1              As OraField         '治療なしその他
    Dim objPolRemark1           As OraField         '治療なしその他コメント
    Dim objPolSugery            As OraField         '外科治療
    Dim objPolEndoscope         As OraField         '内視鏡的治療
    Dim objPolChemical          As OraField         '化学療法
    Dim objPolRadiation         As OraField         '放射線治療
    Dim objPolReferSt           As OraField         '本院紹介（治療）
    Dim objPolRefer             As OraField         '他院紹介（治療）
    Dim objPolEtc2              As OraField         '治療ありその他
    Dim objPolRemark2           As OraField         '治療ありその他コメント
    
    Dim lngCount                As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntSecCslDate) Then vntSecCslDate = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUpdUserName) Then vntUpdUserName = Empty
    If Not IsMissing(vntTestUS) Then vntTestUS = Empty
    If Not IsMissing(vntTestCT) Then vntTestCT = Empty
    If Not IsMissing(vntTestMRI) Then vntTestMRI = Empty
    If Not IsMissing(vntTestBF) Then vntTestBF = Empty
    If Not IsMissing(vntTestGF) Then vntTestGF = Empty
    If Not IsMissing(vntTestCF) Then vntTestCF = Empty
    If Not IsMissing(vntTestEM) Then vntTestEM = Empty
    If Not IsMissing(vntTestTM) Then vntTestTM = Empty
    If Not IsMissing(vntTestEtc) Then vntTestEtc = Empty
    If Not IsMissing(vntTestRemark) Then vntTestRemark = Empty
    If Not IsMissing(vntTestRefer) Then vntTestRefer = Empty
    If Not IsMissing(vntTestReferText) Then vntTestReferText = Empty
    If Not IsMissing(vntResultDiv) Then vntResultDiv = Empty
    If Not IsMissing(vntDisRemark) Then vntDisRemark = Empty
    If Not IsMissing(vntPolWithout) Then vntPolWithout = Empty
    If Not IsMissing(vntPolFollowup) Then vntPolFollowup = Empty
    If Not IsMissing(vntPolMonth) Then vntPolMonth = Empty
    If Not IsMissing(vntPolReExam) Then vntPolReExam = Empty
    If Not IsMissing(vntPolDiagSt) Then vntPolDiagSt = Empty
    If Not IsMissing(vntPolDiag) Then vntPolDiag = Empty
    If Not IsMissing(vntPolEtc1) Then vntPolEtc1 = Empty
    If Not IsMissing(vntPolRemark1) Then vntPolRemark1 = Empty
    If Not IsMissing(vntPolSugery) Then vntPolSugery = Empty
    If Not IsMissing(vntPolEndoscope) Then vntPolEndoscope = Empty
    If Not IsMissing(vntPolChemical) Then vntPolChemical = Empty
    If Not IsMissing(vntPolRadiation) Then vntPolRadiation = Empty
    If Not IsMissing(vntPolReferSt) Then vntPolReferSt = Empty
    If Not IsMissing(vntPolRefer) Then vntPolRefer = Empty
    If Not IsMissing(vntPolEtc2) Then vntPolEtc2 = Empty
    If Not IsMissing(vntPolRemark2) Then vntPolRemark2 = Empty
    
    SelectFollow_Rsl = False
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RESULT", "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号と検査項目（判定分類）のフォロー情報を取得する
    strStmt = ""
    strStmt = "SELECT FOLLOW_RSL.SECCSLDATE,                              "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.UPDDATE,      FOLLOW_RSL.UPDUSER,         "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTUS,       FOLLOW_RSL.TESTCT,          "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTMRI,      FOLLOW_RSL.TESTBF,          "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTGF,       FOLLOW_RSL.TESTCF,          "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTEM,       FOLLOW_RSL.TESTTM,          "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTETC,      FOLLOW_RSL.TESTREMARK,      "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTREFER,    FOLLOW_RSL.TESTREFERTEXT,   "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.RESULTDIV,    FOLLOW_RSL.DISREMARK,       "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLWITHOUT,   FOLLOW_RSL.POLFOLLOWUP,     "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLMONTH,     FOLLOW_RSL.POLREEXAM,       "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLDIAGST,    FOLLOW_RSL.POLDIAG,      FOLLOW_RSL.POLETC1,     "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLREMARK1,   FOLLOW_RSL.POLSUGERY,       "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLENDOSCOPE, FOLLOW_RSL.POLCHEMICAL,     "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLRADIATION, FOLLOW_RSL.POLREFERST,   FOLLOW_RSL.POLREFER,    "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLETC2,      FOLLOW_RSL.POLREMARK2,      "
    strStmt = strStmt & vbLf & "       HAINSUSER.USERNAME                                   "
    strStmt = strStmt & vbLf & "  FROM FOLLOW_RSL, HAINSUSER                                "
    strStmt = strStmt & vbLf & " WHERE FOLLOW_RSL.RSVNO      = :RSVNO                       "
    strStmt = strStmt & vbLf & "   AND FOLLOW_RSL.JUDCLASSCD = :JUDCLASSCD                  "
    strStmt = strStmt & vbLf & "   AND FOLLOW_RSL.SEQ        = :SEQ                         "
    strStmt = strStmt & vbLf & "   AND FOLLOW_RSL.UPDUSER    = HAINSUSER.USERID             "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objSecCslDate = objFields("SECCSLDATE")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUpdUserName = objFields("USERNAME")
        Set objTestUS = objFields("TESTUS")
        Set objTestCT = objFields("TESTCT")
        Set objTestMRI = objFields("TESTMRI")
        Set objTestBF = objFields("TESTBF")
        Set objTestGF = objFields("TESTGF")
        Set objTestCF = objFields("TESTCF")
        Set objTestEM = objFields("TESTEM")
        Set objTestTM = objFields("TESTTM")
        Set objTestEtc = objFields("TESTETC")
        Set objTestRemark = objFields("TESTREMARK")
        Set objTestRefer = objFields("TESTREFER")
        Set objTestReferText = objFields("TESTREFERTEXT")
        Set objResultDiv = objFields("RESULTDIV")
        Set objDisRemark = objFields("DISREMARK")
        Set objPolWithout = objFields("POLWITHOUT")
        Set objPolFollowup = objFields("POLFOLLOWUP")
        Set objPolMonth = objFields("POLMONTH")
        Set objPolReExam = objFields("POLREEXAM")
        Set objPolDiagSt = objFields("POLDIAGST")
        Set objPolDiag = objFields("POLDIAG")
        Set objPolEtc1 = objFields("POLETC1")
        Set objPolRemark1 = objFields("POLREMARK1")
        Set objPolSugery = objFields("POLSUGERY")
        Set objPolEndoscope = objFields("POLENDOSCOPE")
        Set objPolChemical = objFields("POLCHEMICAL")
        Set objPolRadiation = objFields("POLRADIATION")
        Set objPolRefer = objFields("POLREFER")
        Set objPolReferSt = objFields("POLREFERST")
        Set objPolEtc2 = objFields("POLETC2")
        Set objPolRemark2 = objFields("POLREMARK2")
        
        '戻り値の設定
        If Not IsMissing(vntSecCslDate) Then vntSecCslDate = objSecCslDate.Value & ""
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntUpdUser) Then vntUpdUser = objUpdUser.Value & ""
        If Not IsMissing(vntUpdUserName) Then vntUpdUserName = objUpdUserName.Value & ""
        If Not IsMissing(vntTestUS) Then vntTestUS = objTestUS.Value & ""
        If Not IsMissing(vntTestCT) Then vntTestCT = objTestCT.Value & ""
        If Not IsMissing(vntTestMRI) Then vntTestMRI = objTestMRI.Value & ""
        If Not IsMissing(vntTestBF) Then vntTestBF = objTestBF.Value & ""
        If Not IsMissing(vntTestGF) Then vntTestGF = objTestGF.Value & ""
        If Not IsMissing(vntTestCF) Then vntTestCF = objTestCF.Value & ""
        If Not IsMissing(vntTestEM) Then vntTestEM = objTestEM.Value & ""
        If Not IsMissing(vntTestTM) Then vntTestTM = objTestTM.Value & ""
        If Not IsMissing(vntTestEtc) Then vntTestEtc = objTestEtc.Value & ""
        If Not IsMissing(vntTestRemark) Then vntTestRemark = objTestRemark.Value & ""
        If Not IsMissing(vntTestRefer) Then vntTestRefer = objTestRefer.Value & ""
        If Not IsMissing(vntTestReferText) Then vntTestReferText = objTestReferText.Value & ""
        If Not IsMissing(vntResultDiv) Then vntResultDiv = objResultDiv.Value & ""
        If Not IsMissing(vntDisRemark) Then vntDisRemark = objDisRemark.Value & ""
        If Not IsMissing(vntPolWithout) Then vntPolWithout = objPolWithout.Value & ""
        If Not IsMissing(vntPolFollowup) Then vntPolFollowup = objPolFollowup.Value & ""
        If Not IsMissing(vntPolMonth) Then vntPolMonth = objPolMonth.Value & ""
        If Not IsMissing(vntPolReExam) Then vntPolReExam = objPolReExam.Value & ""
        If Not IsMissing(vntPolDiagSt) Then vntPolDiagSt = objPolDiagSt.Value & ""
        If Not IsMissing(vntPolDiag) Then vntPolDiag = objPolDiag.Value & ""
        If Not IsMissing(vntPolEtc1) Then vntPolEtc1 = objPolEtc1.Value & ""
        If Not IsMissing(vntPolRemark1) Then vntPolRemark1 = objPolRemark1.Value & ""
        If Not IsMissing(vntPolSugery) Then vntPolSugery = objPolSugery.Value & ""
        If Not IsMissing(vntPolEndoscope) Then vntPolEndoscope = objPolEndoscope.Value & ""
        If Not IsMissing(vntPolChemical) Then vntPolChemical = objPolChemical.Value & ""
        If Not IsMissing(vntPolRadiation) Then vntPolRadiation = objPolRadiation.Value & ""
        If Not IsMissing(vntPolReferSt) Then vntPolReferSt = objPolReferSt.Value & ""
        If Not IsMissing(vntPolRefer) Then vntPolRefer = objPolRefer.Value & ""
        If Not IsMissing(vntPolEtc2) Then vntPolEtc2 = objPolEtc2.Value & ""
        If Not IsMissing(vntPolRemark2) Then vntPolRemark2 = objPolRemark2.Value & ""
        
        SelectFollow_Rsl = True
    
    End If

    Set objSecCslDate = Nothing
    Set objUpdDate = Nothing
    Set objUpdUser = Nothing
    Set objUpdUserName = Nothing
    Set objTestUS = Nothing
    Set objTestCT = Nothing
    Set objTestMRI = Nothing
    Set objTestBF = Nothing
    Set objTestGF = Nothing
    Set objTestCF = Nothing
    Set objTestEM = Nothing
    Set objTestTM = Nothing
    Set objTestEtc = Nothing
    Set objTestRemark = Nothing
    Set objTestRefer = Nothing
    Set objTestReferText = Nothing
    Set objResultDiv = Nothing
    Set objDisRemark = Nothing
    Set objPolWithout = Nothing
    Set objPolFollowup = Nothing
    Set objPolMonth = Nothing
    Set objPolReExam = Nothing
    Set objPolDiag = Nothing
    Set objPolDiagSt = Nothing
    Set objPolEtc1 = Nothing
    Set objPolRemark1 = Nothing
    Set objPolSugery = Nothing
    Set objPolEndoscope = Nothing
    Set objPolChemical = Nothing
    Set objPolRadiation = Nothing
    Set objPolReferSt = Nothing
    Set objPolRefer = Nothing
    Set objPolEtc2 = Nothing
    Set objPolRemark2 = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectFollow_Rsl = False

    'イベントログ書き込み
    WriteErrorLog "Follow.SelectFollow_Rsl"

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

' 張
' 機能　　 : 結果情報の診断名を取得（すべての臓器（検査項目）情報を基に結果を取得）
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (In)     lngJudClassCd         判定分類コード
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectFollowRslList(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, _
                                    Optional ByRef vntRsvNo As Variant, Optional ByRef vntJudClassCd As Variant, _
                                    Optional ByRef vntSeq As Variant, Optional ByRef vntSecCslDate As Variant, _
                                    Optional ByRef vntTestUS As Variant, Optional ByRef vntTestCT As Variant, _
                                    Optional ByRef vntTestMRI As Variant, Optional ByRef vntTestBF As Variant, _
                                    Optional ByRef vntTestGF As Variant, Optional ByRef vntTestCF As Variant, _
                                    Optional ByRef vntTestEM As Variant, Optional ByRef vntTestTM As Variant, _
                                    Optional ByRef vntTestRefer As Variant, Optional ByRef vntTestReferText As Variant, _
                                    Optional ByRef vntTestEtc As Variant, Optional ByRef vntTestRemark As Variant, _
                                    Optional ByRef vntResultDiv As Variant, Optional ByRef vntDisRemark As Variant, _
                                    Optional ByRef vntPolWithout As Variant, Optional ByRef vntPolFollowup As Variant, _
                                    Optional ByRef vntPolMonth As Variant, Optional ByRef vntPolReExam As Variant, _
                                    Optional ByRef vntPolDiagSt As Variant, Optional ByRef vntPolDiag As Variant, Optional ByRef vntPolEtc1 As Variant, _
                                    Optional ByRef vntPolRemark1 As Variant, Optional ByRef vntPolSugery As Variant, _
                                    Optional ByRef vntPolEndoscope As Variant, Optional ByRef vntPolChemical As Variant, _
                                    Optional ByRef vntPolRadiation As Variant, Optional ByRef vntPolReferSt As Variant, Optional ByRef vntPolRefer As Variant, _
                                    Optional ByRef vntPolEtc2 As Variant, Optional ByRef vntPolRemark2 As Variant, _
                                    Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, _
                                    Optional ByRef vntUpdUserName As Variant _
                                   ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objRsvNo                As OraField         '予約番号
    Dim objJudClassCd           As OraField         '検査項目（判定分類）
    Dim objSeq                  As OraField         '一連番号
    Dim objSecCslDate           As OraField         '二次検査実施日
    Dim objUpdDate              As OraField         '更新日時
    Dim objUpdUser              As OraField         '更新者ID
    Dim objUpdUserName          As OraField         '更新者氏名
    Dim objTestUS               As OraField         '検査項目US
    Dim objTestCT               As OraField         '検査項目CT
    Dim objTestMRI              As OraField         '検査項目MRI
    Dim objTestBF               As OraField         '検査項目BF
    Dim objTestGF               As OraField         '検査項目GF
    Dim objTestCF               As OraField         '検査項目CF
    Dim objTestEM               As OraField         '検査項目注腸
    Dim objTestTM               As OraField         '検査項目腫瘍マーカー
    Dim objTestRefer            As OraField         '検査項目リファー
    Dim objTestReferText        As OraField         '検査項目リファー科
    Dim objTestEtc              As OraField         '検査項目その他
    Dim objTestRemark           As OraField         '検査項目その他内容
    
    Dim objResultDiv            As OraField         '二次検査結果区分
    Dim objDisRemark            As OraField         'その他疾患
    Dim objPolWithout           As OraField         '処置不要
    Dim objPolFollowup          As OraField         '経過観察
    Dim objPolMonth             As OraField         '経過観察期間（ヶ月）
    Dim objPolReExam            As OraField         '一年後健診
    Dim objPolDiagSt            As OraField         '本院紹介（精査）
    Dim objPolDiag              As OraField         '他院紹介（精査）
    Dim objPolEtc1              As OraField         '治療なしその他
    Dim objPolRemark1           As OraField         '治療なしその他コメント
    Dim objPolSugery            As OraField         '外科治療
    Dim objPolEndoscope         As OraField         '内視鏡的治療
    Dim objPolChemical          As OraField         '化学療法
    Dim objPolRadiation         As OraField         '放射線治療
    Dim objPolReferSt           As OraField         '本院紹介（治療）
    Dim objPolRefer             As OraField         '他院紹介（治療）
    Dim objPolEtc2              As OraField         '治療ありその他
    Dim objPolRemark2           As OraField         '治療ありその他コメント

    Dim vntArrRsvNo()           As Variant         '予約番号の配列
    Dim vntArrJudClassCd()      As Variant         '検査項目（判定分類）の配列
    Dim vntArrSeq()             As Variant         '一連番号の配列
    Dim vntArrSecCslDate()      As Variant         '二次検査実施日の配列
    Dim vntArrUpdDate()         As Variant         '更新日時の配列
    Dim vntArrUpdUser()         As Variant         '更新者IDの配列
    Dim vntArrUpdUserName()     As Variant         '更新者氏名の配列
    Dim vntArrTestUS()          As Variant         '検査項目USの配列
    Dim vntArrTestCT()          As Variant         '検査項目CTの配列
    Dim vntArrTestMRI()         As Variant         '検査項目MRIの配列
    Dim vntArrTestBF()          As Variant         '検査項目BFの配列
    Dim vntArrTestGF()          As Variant         '検査項目GFの配列
    Dim vntArrTestCF()          As Variant         '検査項目CFの配列
    Dim vntArrTestEM()          As Variant         '検査項目注腸の配列
    Dim vntArrTestTM()          As Variant         '検査項目腫瘍マーカーの配列
    Dim vntArrTestRefer()       As Variant         '検査項目リファーの配列
    Dim vntArrTestReferText()   As Variant         '検査項目リファー科の配列
    Dim vntArrTestEtc()         As Variant         '検査項目その他の配列
    Dim vntArrTestRemark()      As Variant         '検査項目その他内容の配列
    
    Dim vntArrResultDiv()       As Variant         '二次検査結果区分の配列
    Dim vntArrDisRemark()       As Variant         'その他疾患の配列
    Dim vntArrPolWithout()      As Variant         '処置不要の配列
    Dim vntArrPolFollowup()     As Variant         '経過観察の配列
    Dim vntArrPolMonth()        As Variant         '経過観察期間（ヶ月）の配列
    Dim vntArrPolReExam()       As Variant         '一年後健診の配列
    Dim vntArrPolDiagSt()       As Variant         '本院紹介（精査）の配列
    Dim vntArrPolDiag()         As Variant         '他院紹介（精査）の配列
    Dim vntArrPolEtc1()         As Variant         '治療なしその他の配列
    Dim vntArrPolRemark1()      As Variant         '治療なしその他コメントの配列
    Dim vntArrPolSugery()       As Variant         '外科治療の配列
    Dim vntArrPolEndoscope()    As Variant         '内視鏡的治療の配列
    Dim vntArrPolChemical()     As Variant         '化学療法の配列
    Dim vntArrPolRadiation()    As Variant         '放射線治療の配列
    Dim vntArrPolReferSt()      As Variant         '本院紹介（治療）の配列
    Dim vntArrPolRefer()        As Variant         '他院紹介（治療）の配列
    Dim vntArrPolEtc2()         As Variant         '治療ありその他の配列
    Dim vntArrPolRemark2()      As Variant         '治療ありその他コメントの配列

    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'ｲﾝﾃﾞｯｸｽ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = Empty
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntSecCslDate) Then vntSecCslDate = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUpdUserName) Then vntUpdUserName = Empty
    If Not IsMissing(vntTestUS) Then vntTestUS = Empty
    If Not IsMissing(vntTestCT) Then vntTestCT = Empty
    If Not IsMissing(vntTestMRI) Then vntTestMRI = Empty
    If Not IsMissing(vntTestBF) Then vntTestBF = Empty
    If Not IsMissing(vntTestGF) Then vntTestGF = Empty
    If Not IsMissing(vntTestCF) Then vntTestCF = Empty
    If Not IsMissing(vntTestEM) Then vntTestEM = Empty
    If Not IsMissing(vntTestTM) Then vntTestTM = Empty
    If Not IsMissing(vntTestRefer) Then vntTestRefer = Empty
    If Not IsMissing(vntTestReferText) Then vntTestReferText = Empty
    If Not IsMissing(vntTestEtc) Then vntTestEtc = Empty
    If Not IsMissing(vntTestRemark) Then vntTestRemark = Empty
    
    If Not IsMissing(vntResultDiv) Then vntResultDiv = Empty
    If Not IsMissing(vntDisRemark) Then vntDisRemark = Empty
    If Not IsMissing(vntPolWithout) Then vntPolWithout = Empty
    If Not IsMissing(vntPolFollowup) Then vntPolFollowup = Empty
    If Not IsMissing(vntPolMonth) Then vntPolMonth = Empty
    If Not IsMissing(vntPolReExam) Then vntPolReExam = Empty
    If Not IsMissing(vntPolDiag) Then vntPolDiag = Empty
    If Not IsMissing(vntPolDiagSt) Then vntPolDiagSt = Empty
    If Not IsMissing(vntPolEtc1) Then vntPolEtc1 = Empty
    If Not IsMissing(vntPolRemark1) Then vntPolRemark1 = Empty
    If Not IsMissing(vntPolSugery) Then vntPolSugery = Empty
    If Not IsMissing(vntPolEndoscope) Then vntPolEndoscope = Empty
    If Not IsMissing(vntPolChemical) Then vntPolChemical = Empty
    If Not IsMissing(vntPolRadiation) Then vntPolRadiation = Empty
    If Not IsMissing(vntPolReferSt) Then vntPolReferSt = Empty
    If Not IsMissing(vntPolRefer) Then vntPolRefer = Empty
    If Not IsMissing(vntPolEtc2) Then vntPolEtc2 = Empty
    If Not IsMissing(vntPolRemark2) Then vntPolRemark2 = Empty
    
    SelectFollowRslList = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定検索条件の二次検査結果情報リストを取得する
    strStmt = ""
    strStmt = "SELECT FOLLOW_RSL.RSVNO,  FOLLOW_RSL.JUDCLASSCD,         "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.SEQ,          FOLLOW_RSL.SECCSLDATE,  "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.UPDDATE,      FOLLOW_RSL.UPDUSER,     "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTUS,       FOLLOW_RSL.TESTCT,      "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTMRI,      FOLLOW_RSL.TESTBF,      "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTGF,       FOLLOW_RSL.TESTCF,      "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTEM,       FOLLOW_RSL.TESTTM,      "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTREFER,    FOLLOW_RSL.TESTREFERTEXT,  "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.TESTETC,      FOLLOW_RSL.TESTREMARK,  "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.RESULTDIV,    FOLLOW_RSL.DISREMARK,   "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLWITHOUT,   FOLLOW_RSL.POLFOLLOWUP, "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLMONTH,     FOLLOW_RSL.POLREEXAM,   "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLDIAGST,    FOLLOW_RSL.POLDIAG,     FOLLOW_RSL.POLETC1,     "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLREMARK1,   FOLLOW_RSL.POLSUGERY,   "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLENDOSCOPE, FOLLOW_RSL.POLCHEMICAL, "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLRADIATION, FOLLOW_RSL.POLREFERST,  FOLLOW_RSL.POLREFER,    "
    strStmt = strStmt & vbLf & "       FOLLOW_RSL.POLETC2,      FOLLOW_RSL.POLREMARK2,  "
    strStmt = strStmt & vbLf & "       HAINSUSER.USERNAME                               "
    strStmt = strStmt & vbLf & "  FROM FOLLOW_RSL, HAINSUSER                            "
    strStmt = strStmt & vbLf & " WHERE FOLLOW_RSL.RSVNO      = :RSVNO                   "
    strStmt = strStmt & vbLf & "   AND FOLLOW_RSL.JUDCLASSCD = :JUDCLASSCD              "
    strStmt = strStmt & vbLf & "   AND FOLLOW_RSL.UPDUSER    = HAINSUSER.USERID         "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objRsvNo = objFields("RSVNO")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objSeq = objFields("SEQ")
        Set objSecCslDate = objFields("SECCSLDATE")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUpdUserName = objFields("USERNAME")
        Set objTestUS = objFields("TESTUS")
        Set objTestCT = objFields("TESTCT")
        Set objTestMRI = objFields("TESTMRI")
        Set objTestBF = objFields("TESTBF")
        Set objTestGF = objFields("TESTGF")
        Set objTestCF = objFields("TESTCF")
        Set objTestEM = objFields("TESTEM")
        Set objTestTM = objFields("TESTTM")
        Set objTestRefer = objFields("TESTREFER")
        Set objTestReferText = objFields("TESTREFERTEXT")
        Set objTestEtc = objFields("TESTETC")
        Set objTestRemark = objFields("TESTREMARK")
        Set objResultDiv = objFields("RESULTDIV")
        Set objDisRemark = objFields("DISREMARK")
        Set objPolWithout = objFields("POLWITHOUT")
        Set objPolFollowup = objFields("POLFOLLOWUP")
        Set objPolMonth = objFields("POLMONTH")
        Set objPolReExam = objFields("POLREEXAM")
        Set objPolDiagSt = objFields("POLDIAGST")
        Set objPolDiag = objFields("POLDIAG")
        Set objPolEtc1 = objFields("POLETC1")
        Set objPolRemark1 = objFields("POLREMARK1")
        Set objPolSugery = objFields("POLSUGERY")
        Set objPolEndoscope = objFields("POLENDOSCOPE")
        Set objPolChemical = objFields("POLCHEMICAL")
        Set objPolRadiation = objFields("POLRADIATION")
        Set objPolReferSt = objFields("POLREFERST")
        Set objPolRefer = objFields("POLREFER")
        Set objPolEtc2 = objFields("POLETC2")
        Set objPolRemark2 = objFields("POLREMARK2")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrSecCslDate(lngCount)
            ReDim Preserve vntArrUpdDate(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)
            ReDim Preserve vntArrUpdUserName(lngCount)
            ReDim Preserve vntArrTestUS(lngCount)
            ReDim Preserve vntArrTestCT(lngCount)
            ReDim Preserve vntArrTestMRI(lngCount)
            ReDim Preserve vntArrTestBF(lngCount)
            ReDim Preserve vntArrTestGF(lngCount)
            ReDim Preserve vntArrTestCF(lngCount)
            ReDim Preserve vntArrTestEM(lngCount)
            ReDim Preserve vntArrTestTM(lngCount)
            ReDim Preserve vntArrTestRefer(lngCount)
            ReDim Preserve vntArrTestReferText(lngCount)
            ReDim Preserve vntArrTestEtc(lngCount)
            ReDim Preserve vntArrTestRemark(lngCount)
            ReDim Preserve vntArrResultDiv(lngCount)
            ReDim Preserve vntArrDisRemark(lngCount)
            ReDim Preserve vntArrPolWithout(lngCount)
            ReDim Preserve vntArrPolFollowup(lngCount)
            ReDim Preserve vntArrPolMonth(lngCount)
            ReDim Preserve vntArrPolReExam(lngCount)
            ReDim Preserve vntArrPolDiagSt(lngCount)
            ReDim Preserve vntArrPolDiag(lngCount)
            ReDim Preserve vntArrPolEtc1(lngCount)
            ReDim Preserve vntArrPolRemark1(lngCount)
            ReDim Preserve vntArrPolSugery(lngCount)
            ReDim Preserve vntArrPolEndoscope(lngCount)
            ReDim Preserve vntArrPolChemical(lngCount)
            ReDim Preserve vntArrPolRadiation(lngCount)
            ReDim Preserve vntArrPolReferSt(lngCount)
            ReDim Preserve vntArrPolRefer(lngCount)
            ReDim Preserve vntArrPolEtc2(lngCount)
            ReDim Preserve vntArrPolRemark2(lngCount)
            
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrJudClassCd(lngCount) = objJudClassCd.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrSecCslDate(lngCount) = objSecCslDate.Value & ""
            vntArrUpdDate(lngCount) = objUpdDate.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""
            vntArrUpdUserName(lngCount) = objUpdUserName.Value & ""
            vntArrTestUS(lngCount) = objTestUS.Value & ""
            vntArrTestCT(lngCount) = objTestCT.Value & ""
            vntArrTestMRI(lngCount) = objTestMRI.Value & ""
            vntArrTestBF(lngCount) = objTestBF.Value & ""
            vntArrTestGF(lngCount) = objTestGF.Value & ""
            vntArrTestCF(lngCount) = objTestCF.Value & ""
            vntArrTestEM(lngCount) = objTestEM.Value & ""
            vntArrTestTM(lngCount) = objTestTM.Value & ""
            vntArrTestRefer(lngCount) = objTestRefer.Value & ""
            vntArrTestReferText(lngCount) = objTestReferText.Value & ""
            vntArrTestEtc(lngCount) = objTestEtc.Value & ""
            vntArrTestRemark(lngCount) = objTestRemark.Value & ""
            
            vntArrResultDiv(lngCount) = objResultDiv.Value & ""
            vntArrDisRemark(lngCount) = objDisRemark.Value & ""
            vntArrPolWithout(lngCount) = objPolWithout.Value & ""
            vntArrPolFollowup(lngCount) = objPolFollowup.Value & ""
            vntArrPolMonth(lngCount) = objPolMonth.Value & ""
            vntArrPolReExam(lngCount) = objPolReExam.Value & ""
            vntArrPolDiagSt(lngCount) = objPolDiagSt.Value & ""
            vntArrPolDiag(lngCount) = objPolDiag.Value & ""
            vntArrPolEtc1(lngCount) = objPolEtc1.Value & ""
            vntArrPolRemark1(lngCount) = objPolRemark1.Value & ""
            vntArrPolSugery(lngCount) = objPolSugery.Value & ""
            vntArrPolEndoscope(lngCount) = objPolEndoscope.Value & ""
            vntArrPolChemical(lngCount) = objPolChemical.Value & ""
            vntArrPolRadiation(lngCount) = objPolRadiation.Value & ""
            vntArrPolReferSt(lngCount) = objPolReferSt.Value & ""
            vntArrPolRefer(lngCount) = objPolRefer.Value & ""
            vntArrPolEtc2(lngCount) = objPolEtc2.Value & ""
            vntArrPolRemark2(lngCount) = objPolRemark2.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntJudClassCd) Then vntJudClassCd = vntArrJudClassCd
        If Not IsMissing(vntSeq) Then vntSeq = vntArrSeq
        If Not IsMissing(vntSecCslDate) Then vntSecCslDate = vntArrSecCslDate
        If Not IsMissing(vntUpdDate) Then vntUpdDate = vntArrUpdDate
        If Not IsMissing(vntUpdUser) Then vntUpdUser = vntArrUpdUser
        If Not IsMissing(vntUpdUserName) Then vntUpdUserName = vntArrUpdUserName
        If Not IsMissing(vntTestUS) Then vntTestUS = vntArrTestUS
        If Not IsMissing(vntTestCT) Then vntTestCT = vntArrTestCT
        If Not IsMissing(vntTestMRI) Then vntTestMRI = vntArrTestMRI
        If Not IsMissing(vntTestBF) Then vntTestBF = vntArrTestBF
        If Not IsMissing(vntTestGF) Then vntTestGF = vntArrTestGF
        If Not IsMissing(vntTestCF) Then vntTestCF = vntArrTestCF
        If Not IsMissing(vntTestEM) Then vntTestEM = vntArrTestEM
        If Not IsMissing(vntTestTM) Then vntTestTM = vntArrTestTM
        If Not IsMissing(vntTestRefer) Then vntTestRefer = vntArrTestRefer
        If Not IsMissing(vntTestReferText) Then vntTestReferText = vntArrTestReferText
        If Not IsMissing(vntTestEtc) Then vntTestEtc = vntArrTestEtc
        If Not IsMissing(vntTestRemark) Then vntTestRemark = vntArrTestRemark
        
        If Not IsMissing(vntResultDiv) Then vntResultDiv = vntArrResultDiv
        If Not IsMissing(vntDisRemark) Then vntDisRemark = vntArrDisRemark
        If Not IsMissing(vntPolWithout) Then vntPolWithout = vntArrPolWithout
        If Not IsMissing(vntPolFollowup) Then vntPolFollowup = vntArrPolFollowup
        If Not IsMissing(vntPolMonth) Then vntPolMonth = vntArrPolMonth
        If Not IsMissing(vntPolReExam) Then vntPolReExam = vntArrPolReExam
        If Not IsMissing(vntPolDiagSt) Then vntPolDiagSt = vntArrPolDiagSt
        If Not IsMissing(vntPolDiag) Then vntPolDiag = vntArrPolDiag
        If Not IsMissing(vntPolEtc1) Then vntPolEtc1 = vntArrPolEtc1
        If Not IsMissing(vntPolRemark1) Then vntPolRemark1 = vntArrPolRemark1
        If Not IsMissing(vntPolSugery) Then vntPolSugery = vntArrPolSugery
        If Not IsMissing(vntPolEndoscope) Then vntPolEndoscope = vntArrPolEndoscope
        If Not IsMissing(vntPolChemical) Then vntPolChemical = vntArrPolChemical
        If Not IsMissing(vntPolRadiation) Then vntPolRadiation = vntArrPolRadiation
        If Not IsMissing(vntPolReferSt) Then vntPolReferSt = vntArrPolReferSt
        If Not IsMissing(vntPolRefer) Then vntPolRefer = vntArrPolRefer
        If Not IsMissing(vntPolEtc2) Then vntPolEtc2 = vntArrPolEtc2
        If Not IsMissing(vntPolRemark2) Then vntPolRemark2 = vntArrPolRemark2

    End If


    Set objRsvNo = Nothing
    Set objJudClassCd = Nothing
    Set objSeq = Nothing
    Set objSecCslDate = Nothing
    Set objUpdDate = Nothing
    Set objUpdUser = Nothing
    Set objUpdUserName = Nothing
    Set objTestUS = Nothing
    Set objTestCT = Nothing
    Set objTestMRI = Nothing
    Set objTestBF = Nothing
    Set objTestGF = Nothing
    Set objTestCF = Nothing
    Set objTestEM = Nothing
    Set objTestTM = Nothing
    Set objTestRefer = Nothing
    Set objTestReferText = Nothing
    Set objTestEtc = Nothing
    Set objTestRemark = Nothing
    
    Set objResultDiv = Nothing
    Set objDisRemark = Nothing
    Set objPolWithout = Nothing
    Set objPolFollowup = Nothing
    Set objPolMonth = Nothing
    Set objPolReExam = Nothing
    Set objPolDiagSt = Nothing
    Set objPolDiag = Nothing
    Set objPolEtc1 = Nothing
    Set objPolRemark1 = Nothing
    Set objPolSugery = Nothing
    Set objPolEndoscope = Nothing
    Set objPolChemical = Nothing
    Set objPolRadiation = Nothing
    Set objPolReferSt = Nothing
    Set objPolRefer = Nothing
    Set objPolEtc2 = Nothing
    Set objPolRemark2 = Nothing

    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectFollowRslList = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectFollowRslList = -1

    'イベントログ書き込み
    WriteErrorLog "Follow.SelectFollowRslList"

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


' 張
' 機能　　 : 結果情報の診断名を取得（すべての臓器（検査項目）情報を基に結果を取得或いは登録されている情報のみ取得）
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (In)     lngJudClassCd         判定分類コード
' 　　　　   (In)     lngSEQ                一連番号
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectFollowRslItemList(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, ByVal lngSeq As Long, _
                                        Optional ByRef vntGrpName As Variant, Optional ByRef vntItemCd As Variant, _
                                        Optional ByRef vntSuffix As Variant, Optional ByRef vntItemName As Variant, _
                                        Optional ByRef vntResult As Variant, Optional ByRef vntShortStc As Variant, _
                                        Optional ByRef blnRslFlg As Boolean = False _
                                       ) As Long

    
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objGrpName              As OraField         '検査項目グループ名称（種別）
    Dim objItemCd               As OraField         '検査項目コード
    Dim objSuffix               As OraField         'サフィクス
    Dim objItemName             As OraField         '検査項目名（臓器或は部位）
    Dim objResult               As OraField         '疾患コード（文章コード）
    Dim objShortStc             As OraField         '疾患名（文章名称）

    Dim vntArrGrpName()         As Variant          '検査項目グループ名称（種別）の配列
    Dim vntArrItemCd()          As Variant          '検査項目コードの配列
    Dim vntArrSuffix()          As Variant          'サフィクスの配列
    Dim vntArrItemName()        As Variant          '検査項目名（臓器或は部位）の配列
    Dim vntArrResult()          As Variant          '疾患コード（文章コード）の配列
    Dim vntArrShortStc()        As Variant          '疾患名（文章名称）の配列

    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'ｲﾝﾃﾞｯｸｽ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntGrpName) Then vntGrpName = Empty
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntResult) Then vntResult = Empty
    If Not IsMissing(vntShortStc) Then vntShortStc = Empty
    
    SelectFollowRslItemList = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "KYOUBU", KYOUBU_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "HUKUBU", HUKUBU_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SYOUKA", SYOUKA_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2016.09.07 張 婦人科関連検査項目追加　############################
    objOraParam.Add "FUJIN", FUJIN_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2


    '指定検索条件の臓器ごとの疾患リストを取得する
    strStmt = ""
    strStmt = "SELECT LASTVIEW.GRPNAME                      "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.ITEMCD          AS ITEMCD                   "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.SUFFIX          AS SUFFIX                   "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.ITEMNAME        AS ITEMNAME                 "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.RESULT          AS RESULT                   "
    strStmt = strStmt & vbLf & "      ,NVL(SENTENCE.SHORTSTC,LASTVIEW.RESULT)   AS SHORTSTC "
    strStmt = strStmt & vbLf & "  FROM (                                                    "
    strStmt = strStmt & vbLf & "        SELECT GRP_I.GRPCD                                  "
    strStmt = strStmt & vbLf & "              ,GRP_P.GRPNAME                                "
    strStmt = strStmt & vbLf & "              ,ITEM_C.ITEMCD                                "
    strStmt = strStmt & vbLf & "              ,ITEM_C.SUFFIX                                "
    strStmt = strStmt & vbLf & "              ,ITEM_C.ITEMTYPE                              "
    strStmt = strStmt & vbLf & "              ,ITEM_C.ITEMNAME                              "
    strStmt = strStmt & vbLf & "              ,ITEM_C.STCITEMCD                             "
    strStmt = strStmt & vbLf & "              ,FOLLOW_I.RESULT                              "
    strStmt = strStmt & vbLf & "          FROM GRP_I                                        "
    strStmt = strStmt & vbLf & "              ,GRP_P                                        "
    strStmt = strStmt & vbLf & "              ,ITEM_C                                       "
    strStmt = strStmt & vbLf & "              ,(SELECT FOLLOW_RSL_I.ITEMCD                  "
    strStmt = strStmt & vbLf & "                      ,FOLLOW_RSL_I.SUFFIX                  "
    strStmt = strStmt & vbLf & "                      ,FOLLOW_RSL_I.RESULT                  "
    strStmt = strStmt & vbLf & "                  FROM FOLLOW_RSL_I                         "
    strStmt = strStmt & vbLf & "                 WHERE FOLLOW_RSL_I.RSVNO      = :RSVNO         "
    strStmt = strStmt & vbLf & "                   AND FOLLOW_RSL_I.JUDCLASSCD = :JUDCLASSCD    "
    strStmt = strStmt & vbLf & "                   AND FOLLOW_RSL_I.SEQ        = :SEQ           "
    strStmt = strStmt & vbLf & "               ) FOLLOW_I                                   "
'### 2016.09.07 張 婦人科関連検査項目追加 STR ###############################################
'    strStmt = strStmt & vbLf & "         WHERE GRP_I.GRPCD IN (:KYOUBU, :HUKUBU, :SYOUKA)   "
    strStmt = strStmt & vbLf & "         WHERE GRP_I.GRPCD IN (:KYOUBU, :HUKUBU, :SYOUKA, :FUJIN)   "
'### 2016.09.07 張 婦人科関連検査項目追加 END ###############################################
    
    strStmt = strStmt & vbLf & "           AND GRP_I.ITEMCD = ITEM_C.ITEMCD                 "
    strStmt = strStmt & vbLf & "           AND GRP_I.SUFFIX = ITEM_C.SUFFIX                 "
    
    '結果抽出区分が「True」の場合は登録されている結果のみ取得し、「Fasle」の場合は対象全項目を取得
    If blnRslFlg Then
        strStmt = strStmt & vbLf & "           AND ITEM_C.ITEMCD = FOLLOW_I.ITEMCD              "
        strStmt = strStmt & vbLf & "           AND ITEM_C.SUFFIX = FOLLOW_I.SUFFIX              "
    Else
        strStmt = strStmt & vbLf & "           AND ITEM_C.ITEMCD = FOLLOW_I.ITEMCD(+)           "
        strStmt = strStmt & vbLf & "           AND ITEM_C.SUFFIX = FOLLOW_I.SUFFIX(+)           "
    End If
    
    strStmt = strStmt & vbLf & "           AND GRP_I.GRPCD = GRP_P.GRPCD                    "
    strStmt = strStmt & vbLf & "       ) LASTVIEW                                           "
    strStmt = strStmt & vbLf & "      ,SENTENCE                                             "
    strStmt = strStmt & vbLf & " WHERE LASTVIEW.STCITEMCD = SENTENCE.ITEMCD(+)              "
    strStmt = strStmt & vbLf & "   AND LASTVIEW.ITEMTYPE  = SENTENCE.ITEMTYPE(+)            "
    strStmt = strStmt & vbLf & "   AND LASTVIEW.RESULT    = SENTENCE.STCCD(+)               "
    strStmt = strStmt & vbLf & " ORDER BY LASTVIEW.GRPCD, LASTVIEW.ITEMCD, LASTVIEW.RESULT  "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objGrpName = objFields("GRPNAME")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objShortStc = objFields("SHORTSTC")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrGrpName(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            
            vntArrGrpName(lngCount) = objGrpName.Value & ""
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrShortStc(lngCount) = objShortStc.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        
        If Not IsMissing(vntGrpName) Then vntGrpName = vntArrGrpName
        If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
        If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
        If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
        If Not IsMissing(vntResult) Then vntResult = vntArrResult
        If Not IsMissing(vntShortStc) Then vntShortStc = vntArrShortStc

    End If


    Set objGrpName = Nothing
    Set objItemCd = Nothing
    Set objSuffix = Nothing
    Set objItemName = Nothing
    Set objResult = Nothing
    Set objShortStc = Nothing

    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectFollowRslItemList = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectFollowRslItemList = -1

    'イベントログ書き込み
    WriteErrorLog "Follow.SelectFollowRslItemList"

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
' 機能　　 : 指定予約番号の基準値以上判定情報（フォロー対象情報）を取得する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (Out)    vntRsvNo          受診番号
' 　　　　   (Out)    vntCslDate        受診日
' 　　　　   (Out)    vntDayId          当日ID
' 　　　　   (Out)    vntPerId          個人ID
' 　　　　   (Out)    vntAge            年齢
' 　　　　   (Out)    vntGender         性別
' 　　　　   (Out)    vntBirth          生年月日
' 　　　　   (Out)    vntJudCd          フォロー情報として登録された判定結果
' 　　　　   (Out)    vntRslJudCd       抽出時の判定結果
' 　　　　   (Out)    vntJudClassName   判定分類名
' 　　　　   (Out)    vntJudClassCd     判定分コード
' 　　　　   (Out)    vntResultDispMode 検査結果表示モード
' 　　　　   (Out)    vntCsCd           コースコード
' 　　　　   (Out)    vntEquipDiv       二次検査実施区分
' 　　　　   (Out)    vntStatusCd       フォローアップステータス
' 　　　　   (Out)    vntReqConfirmDate 二次検査結果承認日時
' 　　　　   (Out)    vntReqConfirmUser 二次検査結果承認者
' 　　　　   (Out)    vntPrtSeq         依頼状印刷回数
' 　　　　   (Out)    vntFileName       依頼状ファイル名
' 　　　　   (Out)    vntPrtDate        依頼状最終作成日
' 　　　　   (Out)    vntPrtUser        依頼状作成者氏名
' 　　　　   (Out)    vntAddUser        フォローアップ初期登録者氏名
' 　　　　   (Out)    vntDocJud         判定医氏名
' 　　　　   (Out)    vntDocGf          上部内視鏡医氏名
' 　　　　   (Out)    vntDocCf          下部内視鏡医氏名
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
' 　　　　   (Out)    vntDocGyne        婦人科診察医氏名
' 　　　　   (Out)    vntDocGyneJud     婦人科判定医氏名
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
' 　　　　   (In)     blnCountFlg       集計フラグ(True:予約番号が重複しない件数,False:ﾚｺｰﾄﾞ件数)
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ############################################
'Public Function SelectTargetFollow(ByVal lngRsvNo As Long, _
'                                   Optional ByRef vntRsvNo As Variant, Optional ByRef vntCsldate As Variant, _
'                                   Optional ByRef vntDayId As Variant, Optional ByRef vntPerId As Variant, _
'                                   Optional ByRef vntPerKname As Variant, Optional ByRef vntPerName As Variant, _
'                                   Optional ByRef vntAge As Variant, Optional ByRef vntGender As Variant, _
'                                   Optional ByRef vntBirth As Variant, Optional ByRef vntJudCd As Variant, _
'                                   Optional ByRef vntRslJudCd As Variant, Optional ByRef vntJudClassName As Variant, _
'                                   Optional ByRef vntJudClassCd As Variant, Optional ByRef vntResultDispMode As Variant, _
'                                   Optional ByRef vntCscd As Variant, Optional ByRef vntEquipDiv As Variant, Optional ByRef vntStatusCd As Variant, _
'                                   Optional ByRef vntReqConfirmDate As Variant, Optional ByRef vntReqConfirmUser As Variant, _
'                                   Optional ByRef vntPrtSeq As Variant, Optional ByRef vntFileName As Variant, _
'                                   Optional ByRef vntPrtDate As Variant, Optional ByRef vntPrtUser As Variant, Optional ByRef vntAddUser As Variant, _
'                                   Optional ByRef vntDocJud As Variant, Optional ByRef vntDocGf As Variant, _
'                                   Optional ByRef vntDocCf As Variant, Optional ByRef blnJudFlg As Boolean = False, _
'                                   Optional ByRef vntUpdUser As Variant _
'                                  ) As Long

Public Function SelectTargetFollow(ByVal lngRsvNo As Long, _
                                   Optional ByRef vntRsvNo As Variant, Optional ByRef vntCsldate As Variant, _
                                   Optional ByRef vntDayId As Variant, Optional ByRef vntPerId As Variant, _
                                   Optional ByRef vntPerKname As Variant, Optional ByRef vntPerName As Variant, _
                                   Optional ByRef vntAge As Variant, Optional ByRef vntGender As Variant, _
                                   Optional ByRef vntBirth As Variant, Optional ByRef vntJudCd As Variant, _
                                   Optional ByRef vntRslJudCd As Variant, Optional ByRef vntJudClassName As Variant, _
                                   Optional ByRef vntJudClassCd As Variant, Optional ByRef vntResultDispMode As Variant, _
                                   Optional ByRef vntCscd As Variant, Optional ByRef vntEquipDiv As Variant, Optional ByRef vntStatusCd As Variant, _
                                   Optional ByRef vntReqConfirmDate As Variant, Optional ByRef vntReqConfirmUser As Variant, _
                                   Optional ByRef vntPrtSeq As Variant, Optional ByRef vntFileName As Variant, _
                                   Optional ByRef vntPrtDate As Variant, Optional ByRef vntPrtUser As Variant, Optional ByRef vntAddUser As Variant, _
                                   Optional ByRef vntDocJud As Variant, Optional ByRef vntDocGf As Variant, Optional ByRef vntDocCf As Variant, _
                                   Optional ByRef vntDocGyne As Variant, Optional ByRef vntDocGyneJud As Variant, _
                                   Optional ByRef blnJudFlg As Boolean = False, Optional ByRef vntUpdUser As Variant _
                                  ) As Long
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ############################################

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim strStmt2                As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objRsvNo                As OraField         '予約番号
    Dim objCslDate              As OraField         '受診日
    Dim objDayId                As OraField         '当日ID
    Dim objPerId                As OraField         '個人ID
    Dim objPerKname             As OraField         'カナ氏名
    Dim objPerName              As OraField         '氏名
    Dim objAge                  As OraField         '年齢
    Dim objGender               As OraField         '性別
    Dim objBirth                As OraField         '生年月日
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名称
    Dim objJudCd                As OraField         '判定コード（フォロー確定時判定結果）
    Dim objRslJudCd             As OraField         '判定コード（カレント（現在）判定結果）
    Dim objCscd                 As OraField         'コースコード
    Dim objResultDispMode       As OraField         '検査結果表示モード
    Dim objEquipDiv             As OraField         '二次検査実施区分
    Dim objStatusCd             As OraField         'ステータス
    Dim objReqConfirmDate       As OraField         '結果承認日
    Dim objReqConfirmUser       As OraField         '結果承認者
    Dim objPrtSeq               As OraField         '依頼状印刷回数
    Dim objFileName             As OraField         '依頼状ファイル名
    Dim objDocJud               As OraField         '判定医
    Dim objDocGf                As OraField         '上部消化管内視鏡実施医
    Dim objDocCf                As OraField         '大腸内視鏡実施医
    Dim objPrtDate              As OraField         '依頼状印刷日時
    Dim objPrtUser              As OraField         '依頼状印刷者
    Dim objAddUser              As OraField         'フォローアップ最初登録者
    Dim objUpdUser              As OraField         '更新者

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    Dim objDocGyne              As OraField         '婦人科診察医
    Dim objDocGyneJud           As OraField         '婦人科判定医
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrCsldate()         As Variant          '受診日の配列
    Dim vntArrDayId()           As Variant          '当日IDの配列
    Dim vntArrPerId()           As Variant          '個人IDの配列
    Dim vntArrPerKName()        As Variant          'カナ氏名の配列
    Dim vntArrPerName()         As Variant          '氏名の配列
    Dim vntArrAge()             As Variant          '年齢の配列
    Dim vntArrGender()          As Variant          '性別の配列
    Dim vntArrBirth()           As Variant          '生年月日の配列
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim vntArrJudCd()           As Variant          '判定コード（フォロー確定時判定結果）の配列
    Dim vntArrRslJudCd()        As Variant          '判定コード（カレント（現在）判定結果）の配列
    Dim vntArrCscd()            As Variant          'コースコードの配列
    Dim vntArrResultDispMode()  As Variant          '検査結果表示モードの配列
    Dim vntArrEquipDiv()        As Variant          '二次検査実施区分の配列
    Dim vntArrStatusCd()        As Variant          'ステータスの配列
    Dim vntArrReqConfirmDate()  As Variant          '結果承認日の配列
    Dim vntArrReqConfirmUser()  As Variant          '結果承認者の配列
    Dim vntArrPrtSeq()          As Variant          '依頼状印刷回数の配列
    Dim vntArrFileName()        As Variant          '依頼状ファイル名の配列
    Dim vntArrDocJud()          As Variant          '判定医の配列
    Dim vntArrDocGf()           As Variant          '上部消化管内視鏡実施医の配列
    Dim vntArrDocCf()           As Variant          '大腸内視鏡実施医の配列
    Dim vntArrPrtDate()         As Variant          '依頼状印刷日時の配列
    Dim vntArrPrtUser()         As Variant          '依頼状印刷者の配列
    Dim vntArrAddUser()         As Variant          'フォローアップ最初登録者の配列
    Dim vntArrUpdUser()         As Variant          '更新者の配列

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    Dim vntArrDocGyne()         As Variant          '婦人科診察医
    Dim vntArrDocGyneJud()      As Variant          '婦人科判定医
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
    
    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'ｲﾝﾃﾞｯｸｽ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCsldate) Then vntCsldate = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntPerKname) Then vntPerKname = Empty
    If Not IsMissing(vntPerName) Then vntPerName = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = Empty
    If Not IsMissing(vntJudClassName) Then vntJudClassName = Empty
    If Not IsMissing(vntJudCd) Then vntJudCd = Empty
    If Not IsMissing(vntRslJudCd) Then vntRslJudCd = Empty
    If Not IsMissing(vntCscd) Then vntCscd = Empty
    If Not IsMissing(vntResultDispMode) Then vntResultDispMode = Empty
    If Not IsMissing(vntEquipDiv) Then vntEquipDiv = Empty
    If Not IsMissing(vntStatusCd) Then vntStatusCd = Empty
    If Not IsMissing(vntReqConfirmDate) Then vntReqConfirmDate = Empty
    If Not IsMissing(vntReqConfirmUser) Then vntReqConfirmUser = Empty
    If Not IsMissing(vntPrtSeq) Then vntPrtSeq = Empty
    If Not IsMissing(vntFileName) Then vntFileName = Empty
    If Not IsMissing(vntDocJud) Then vntDocJud = Empty
    If Not IsMissing(vntDocGf) Then vntDocGf = Empty
    If Not IsMissing(vntDocCf) Then vntDocCf = Empty
    If Not IsMissing(vntPrtDate) Then vntPrtDate = Empty
    If Not IsMissing(vntPrtUser) Then vntPrtUser = Empty
    If Not IsMissing(vntAddUser) Then vntAddUser = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    If Not IsMissing(vntDocGyne) Then vntDocGyne = Empty
    If Not IsMissing(vntDocGyneJud) Then vntDocGyneJud = Empty
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
    
    SelectTargetFollow = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FOLJUDCLCD", "FOLJUDCL%", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FOLJUDCD", "FOLJUD00%", ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号のフォロー情報を取得する
    strStmt = ""
    strStmt = "SELECT ROWNUM SEQ    "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.CSLDATE                                 AS CSLDATE                      "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.DAYID                                   AS DAYID                        "
    strStmt = strStmt & vbLf & "      ,PERSON.LASTKNAME || '　' || PERSON.FIRSTKNAME    AS PERKNAME                     "
    strStmt = strStmt & vbLf & "      ,PERSON.LASTNAME || '　' || PERSON.FIRSTNAME      AS PERNAME                      "
    strStmt = strStmt & vbLf & "      ,TRUNC(LASTVIEW.AGE)                              AS AGE                          "
    strStmt = strStmt & vbLf & "      ,DECODE(PERSON.GENDER,1 ,'男' ,2 ,'女')           AS GENDER                       "
    strStmt = strStmt & vbLf & "      ,TO_CHAR(PERSON.BIRTH,'EYY.mm.dd','NLS_CALENDAR=''Japanese Imperial''')  AS BIRTH "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.RSVNO                                   AS RSVNO                        "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.PERID                                   AS PERID                        "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.JUDCLASSCD                              AS JUDCLASSCD                   "
    strStmt = strStmt & vbLf & "      ,JUDCLASS.JUDCLASSNAME                            AS JUDCLASSNAME                 "
    strStmt = strStmt & vbLf & "      ,JUDCLASS.RESULTDISPMODE                          AS RESULTDISPMODE               "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.JUDCD                                   AS JUDCD                        "
    strStmt = strStmt & vbLf & "      ,(SELECT JUDRSL.JUDCD  FROM JUDRSL                                                "
    strStmt = strStmt & vbLf & "         WHERE JUDRSL.RSVNO = LASTVIEW.RSVNO                                            "
    strStmt = strStmt & vbLf & "           AND JUDRSL.JUDCLASSCD = LASTVIEW.JUDCLASSCD) AS RSLJUDCD                     "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.CSCD                                    AS CSCD                         "
    strStmt = strStmt & vbLf & "      ,NVL(LASTVIEW.EQUIPDIV,'')                        AS EQUIPDIV                     "
    strStmt = strStmt & vbLf & "      ,NVL(LASTVIEW.STATUSCD,'')                        AS STATUSCD                     "
    strStmt = strStmt & vbLf & "      ,NVL(LASTVIEW.REQCONFIRMDATE,'')                  AS REQCONFIRMDATE               "
    strStmt = strStmt & vbLf & "      ,(SELECT USERNAME  FROM HAINSUSER                                                 "
    strStmt = strStmt & vbLf & "         WHERE HAINSUSER.USERID = LASTVIEW.REQCONFIRMUSER) AS REQCONFIRMUSER            "
    strStmt = strStmt & vbLf & "      ,LASTVIEW.PRTSEQ                                  AS PRTSEQ                       "
    strStmt = strStmt & vbLf & "      ,NVL(FOLLOW_PRT_H.FILENAME,'')                    AS FILENAME                     "
    strStmt = strStmt & vbLf & "      ,DECODE(FOLLOW_PRT_H.ADDDATE,NULL,'',TO_CHAR(FOLLOW_PRT_H.ADDDATE,'YYYY/MM/DD HH24:MI'))   AS PRTDATE "
    strStmt = strStmt & vbLf & "      ,(SELECT USERNAME  FROM HAINSUSER                                                 "
    strStmt = strStmt & vbLf & "         WHERE HAINSUSER.USERID = FOLLOW_PRT_H.ADDUSER) AS PRTUSER                      "
    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'30910' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'30910' ,'00'))  AS DOC_JUD  "
    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'23320' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'23320' ,'00'))  AS DOC_GF   "
    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'23550' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'23550' ,'00'))  AS DOC_CF   "
    strStmt = strStmt & vbLf & "      ,(SELECT USERNAME  FROM HAINSUSER                                                 "
    strStmt = strStmt & vbLf & "         WHERE HAINSUSER.USERID = LASTVIEW.ADDUSER)     AS ADDUSER                      "
    
    strStmt = strStmt & vbLf & "      ,(SELECT USERNAME  FROM HAINSUSER                                                 "
    strStmt = strStmt & vbLf & "         WHERE HAINSUSER.USERID = LASTVIEW.UPDUSER)     AS UPDUSER                      "
    
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'30980' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'30980' ,'00'))  AS DOC_GYNE    "
    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'30981' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'30981' ,'00'))  AS DOC_GYNEJUD "
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
    
    strStmt = strStmt & vbLf & "  FROM (                                                                                "
    strStmt = strStmt & vbLf & "           (                                                                            "
    strStmt = strStmt & vbLf & "               (                                                                            "
    strStmt = strStmt & vbLf & "                SELECT CONSULT.CSLDATE         AS CSLDATE                                   "
    strStmt = strStmt & vbLf & "                      ,RECEIPT.DAYID           AS DAYID                                     "
    strStmt = strStmt & vbLf & "                      ,CONSULT.RSVNO           AS RSVNO                                     "
    strStmt = strStmt & vbLf & "                      ,CONSULT.PERID           AS PERID                                     "
    strStmt = strStmt & vbLf & "                      ,CONSULT.AGE             AS AGE                                       "
    strStmt = strStmt & vbLf & "                      ,CONSULT.CSCD            AS CSCD                                      "
    strStmt = strStmt & vbLf & "                      ,JUDRSL.JUDCLASSCD       AS JUDCLASSCD                                "
    strStmt = strStmt & vbLf & "                      ,NULL                    AS JUDCD                                     "
    strStmt = strStmt & vbLf & "                      ,NULL                    AS EQUIPDIV                                  "
    strStmt = strStmt & vbLf & "                      ,NULL                    AS PRTSEQ                                    "
    strStmt = strStmt & vbLf & "                      ,NULL                    AS STATUSCD                                  "
    strStmt = strStmt & vbLf & "                      ,NULL                    AS REQCONFIRMDATE                            "
    strStmt = strStmt & vbLf & "                      ,NULL                    AS REQCONFIRMUSER                            "
    strStmt = strStmt & vbLf & "                      ,NULL                    AS ADDUSER                                   "
    strStmt = strStmt & vbLf & "                      ,NULL                    AS UPDUSER                                   "
    strStmt = strStmt & vbLf & "                  FROM CONSULT                                                              "
    strStmt = strStmt & vbLf & "                      ,RECEIPT                                                              "
    strStmt = strStmt & vbLf & "                      ,JUDRSL                                                               "
    strStmt = strStmt & vbLf & "                 WHERE CONSULT.RSVNO = :RSVNO                                               "
    strStmt = strStmt & vbLf & "                   AND CONSULT.CANCELFLG = 0                                                "
    strStmt = strStmt & vbLf & "                   AND CONSULT.RSVNO   = RECEIPT.RSVNO                                      "
    strStmt = strStmt & vbLf & "                   AND RECEIPT.COMEDATE IS NOT NULL                                         "
    strStmt = strStmt & vbLf & "                   AND CONSULT.RSVNO   = JUDRSL.RSVNO                                       "
    strStmt = strStmt & vbLf & "                   AND JUDRSL.JUDCLASSCD IN (SELECT FREE.FREEFIELD1                         "
    strStmt = strStmt & vbLf & "                                               FROM FREE                                    "
    strStmt = strStmt & vbLf & "                                              WHERE FREE.FREECD LIKE :FOLJUDCLCD)           "
    strStmt = strStmt & vbLf & "                   AND JUDRSL.JUDCD      IN (SELECT FREE1.FREEFIELD1 JUDCD                  "
    strStmt = strStmt & vbLf & "                                               FROM FREE                                    "
    strStmt = strStmt & vbLf & "                                                   ,FREE FREE1                              "
    strStmt = strStmt & vbLf & "                                              WHERE FREE.FREECD LIKE :FOLJUDCLCD            "
    strStmt = strStmt & vbLf & "                                                AND FREE.FREEFIELD1 = JUDRSL.JUDCLASSCD     "
    strStmt = strStmt & vbLf & "                                                AND FREE.FREECLASSCD = FREE1.FREECLASSCD    "
    strStmt = strStmt & vbLf & "                                                AND FREE1.FREECD LIKE :FOLJUDCD)            "
    
    '表示区分が「True」の場合は判定結果が登録されていない検査項目も強制的に表示
    If blnJudFlg Then
        strStmt = strStmt & vbLf & "                UNION                                                                         "
        strStmt = strStmt & vbLf & "                SELECT CONSULT.CSLDATE         AS CSLDATE                                     "
        strStmt = strStmt & vbLf & "                      ,RECEIPT.DAYID           AS DAYID                                       "
        strStmt = strStmt & vbLf & "                      ,CONSULT.RSVNO           AS RSVNO                                       "
        strStmt = strStmt & vbLf & "                      ,CONSULT.PERID           AS PERID                                       "
        strStmt = strStmt & vbLf & "                      ,CONSULT.AGE             AS AGE                                         "
        strStmt = strStmt & vbLf & "                      ,CONSULT.CSCD            AS CSCD                                        "
        strStmt = strStmt & vbLf & "                      ,JUDVIEW.JUDCLASSCD      AS JUDCLASSCD                                  "
        strStmt = strStmt & vbLf & "                      ,NULL                    AS JUDCD                                       "
        strStmt = strStmt & vbLf & "                      ,NULL                    AS EQUIPDIV                                    "
        strStmt = strStmt & vbLf & "                      ,NULL                    AS PRTSEQ                                      "
        strStmt = strStmt & vbLf & "                      ,NULL                    AS STATUSCD                                    "
        strStmt = strStmt & vbLf & "                      ,NULL                    AS REQCONFIRMDATE                              "
        strStmt = strStmt & vbLf & "                      ,NULL                    AS REQCONFIRMUSER                              "
        strStmt = strStmt & vbLf & "                      ,NULL                    AS ADDUSER                                     "
        strStmt = strStmt & vbLf & "                      ,NULL                    AS UPDUSER                                     "
        strStmt = strStmt & vbLf & "                  FROM CONSULT                                                                "
        strStmt = strStmt & vbLf & "                      ,RECEIPT                                                                "
        strStmt = strStmt & vbLf & "                      ,(                                                                      "
        strStmt = strStmt & vbLf & "                        SELECT RSL.RSVNO            AS RSVNO                                  "
        strStmt = strStmt & vbLf & "                              ,ITEM_JUD.JUDCLASSCD  AS JUDCLASSCD                             "
        strStmt = strStmt & vbLf & "                          FROM RSL                                                            "
        strStmt = strStmt & vbLf & "                              ,ITEM_JUD                                                       "
        strStmt = strStmt & vbLf & "                         WHERE RSL.RSVNO = :RSVNO                                             "
        strStmt = strStmt & vbLf & "                           AND RSL.STOPFLG IS NULL                                            "
        strStmt = strStmt & vbLf & "                           AND RSL.ITEMCD = ITEM_JUD.ITEMCD                                   "
        strStmt = strStmt & vbLf & "                           AND ITEM_JUD.JUDCLASSCD IN (SELECT FREE.FREEFIELD1                 "
        strStmt = strStmt & vbLf & "                                                         FROM FREE                            "
        strStmt = strStmt & vbLf & "                                                        WHERE FREE.FREECD LIKE :FOLJUDCLCD)   "
        strStmt = strStmt & vbLf & "                         GROUP BY RSL.RSVNO, ITEM_JUD.JUDCLASSCD                              "
        strStmt = strStmt & vbLf & "                       ) JUDVIEW                                                              "
        strStmt = strStmt & vbLf & "                      ,JUDRSL                                                                 "
        strStmt = strStmt & vbLf & "                 WHERE CONSULT.RSVNO = :RSVNO                                                 "
        strStmt = strStmt & vbLf & "                   AND CONSULT.CANCELFLG = 0                                                  "
        strStmt = strStmt & vbLf & "                   AND CONSULT.RSVNO = RECEIPT.RSVNO                                          "
        strStmt = strStmt & vbLf & "                   AND RECEIPT.COMEDATE IS NOT NULL                                           "
        strStmt = strStmt & vbLf & "                   AND CONSULT.RSVNO = JUDVIEW.RSVNO                                          "
        strStmt = strStmt & vbLf & "                   AND JUDVIEW.RSVNO = JUDRSL.RSVNO(+)                                        "
        strStmt = strStmt & vbLf & "                   AND JUDVIEW.JUDCLASSCD = JUDRSL.JUDCLASSCD(+)                              "
        strStmt = strStmt & vbLf & "                   AND JUDRSL.JUDCD IS NULL                                                   "
    End If
    
    strStmt = strStmt & vbLf & "               )                                                                        "
    strStmt = strStmt & vbLf & "            MINUS                                                                       "
    strStmt = strStmt & vbLf & "            SELECT CONSULT.CSLDATE         AS CSLDATE                                   "
    strStmt = strStmt & vbLf & "                  ,RECEIPT.DAYID           AS DAYID                                     "
    strStmt = strStmt & vbLf & "                  ,CONSULT.RSVNO           AS RSVNO                                     "
    strStmt = strStmt & vbLf & "                  ,CONSULT.PERID           AS PERID                                     "
    strStmt = strStmt & vbLf & "                  ,CONSULT.AGE             AS AGE                                       "
    strStmt = strStmt & vbLf & "                  ,CONSULT.CSCD            AS CSCD                                      "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.JUDCLASSCD  AS JUDCLASSCD                                "
    strStmt = strStmt & vbLf & "                  ,NULL                    AS JUDCD                                     "
    strStmt = strStmt & vbLf & "                  ,NULL                    AS EQUIPDIV                                  "
    strStmt = strStmt & vbLf & "                  ,NULL                    AS PRTSEQ                                    "
    strStmt = strStmt & vbLf & "                  ,NULL                    AS STATUSCD                                  "
    strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMDATE                            "
    strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMUSER                            "
    strStmt = strStmt & vbLf & "                  ,NULL                    AS ADDUSER                                   "
    strStmt = strStmt & vbLf & "                  ,NULL                    AS UPDUSER                                   "
    strStmt = strStmt & vbLf & "              FROM CONSULT                                                              "
    strStmt = strStmt & vbLf & "                  ,RECEIPT                                                              "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO                                                          "
    strStmt = strStmt & vbLf & "             WHERE CONSULT.RSVNO = :RSVNO                                               "
    strStmt = strStmt & vbLf & "               AND CONSULT.CANCELFLG = 0                                                "
    strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = RECEIPT.RSVNO                                      "
    strStmt = strStmt & vbLf & "               AND RECEIPT.COMEDATE IS NOT NULL                                         "
    strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = FOLLOW_INFO.RSVNO                                  "
    strStmt = strStmt & vbLf & "           )                                                                            "
    strStmt = strStmt & vbLf & "        UNION                                                                           "
    strStmt = strStmt & vbLf & "            SELECT CONSULT.CSLDATE              AS CSLDATE                              "
    strStmt = strStmt & vbLf & "                  ,RECEIPT.DAYID                AS DAYID                                "
    strStmt = strStmt & vbLf & "                  ,CONSULT.RSVNO                AS RSVNO                                "
    strStmt = strStmt & vbLf & "                  ,CONSULT.PERID                AS PERID                                "
    strStmt = strStmt & vbLf & "                  ,CONSULT.AGE                  AS AGE                                  "
    strStmt = strStmt & vbLf & "                  ,CONSULT.CSCD                 AS CSCD                                 "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.JUDCLASSCD       AS JUDCLASSCD                           "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.JUDCD            AS JUDCD                                "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.SECEQUIPDIV      AS EQUIPDIV                             "
    strStmt = strStmt & vbLf & "                  ,(SELECT MAX(SEQ) FROM FOLLOW_PRT_H                                   "
    strStmt = strStmt & vbLf & "                     WHERE RSVNO      = FOLLOW_INFO.RSVNO                               "
    strStmt = strStmt & vbLf & "                       AND JUDCLASSCD = FOLLOW_INFO.JUDCLASSCD                          "
    strStmt = strStmt & vbLf & "                       AND PRTDIV     = 1                                               "
    strStmt = strStmt & vbLf & "                   ) AS PRTSEQ                                                          "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.STATUSCD       AS STATUSCD                               "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.REQCONFIRMDATE AS REQCONFIRMDATE                         "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.REQCONFIRMUSER AS REQCONFIRMUSER                         "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.ADDUSER        AS ADDUSER                                "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.UPDUSER        AS UPDUSER                                "
    
    strStmt = strStmt & vbLf & "              FROM CONSULT                                                              "
    strStmt = strStmt & vbLf & "                  ,RECEIPT                                                              "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO                                                          "
    strStmt = strStmt & vbLf & "             WHERE CONSULT.RSVNO = :RSVNO                                               "
    strStmt = strStmt & vbLf & "               AND CONSULT.CANCELFLG = 0                                                "
    strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = RECEIPT.RSVNO                                      "
    strStmt = strStmt & vbLf & "               AND RECEIPT.COMEDATE IS NOT NULL                                         "
    strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = FOLLOW_INFO.RSVNO                                  "
    strStmt = strStmt & vbLf & "       ) LASTVIEW                                                                       "
    strStmt = strStmt & vbLf & "      ,JUDCLASS                                                                         "
    strStmt = strStmt & vbLf & "      ,PERSON                                                                           "
    strStmt = strStmt & vbLf & "      ,FOLLOW_PRT_H                                                                     "
    strStmt = strStmt & vbLf & " WHERE LASTVIEW.JUDCLASSCD      = JUDCLASS.JUDCLASSCD                                   "
    strStmt = strStmt & vbLf & "   AND JUDCLASS.COMMENTONLY     IS NULL                                                 "
    strStmt = strStmt & vbLf & "   AND LASTVIEW.PERID           = PERSON.PERID                                          "
    strStmt = strStmt & vbLf & "   AND LASTVIEW.RSVNO           = FOLLOW_PRT_H.RSVNO(+)                                 "
    strStmt = strStmt & vbLf & "   AND LASTVIEW.JUDCLASSCD      = FOLLOW_PRT_H.JUDCLASSCD(+)                            "
    strStmt = strStmt & vbLf & "   AND 1                        = FOLLOW_PRT_H.PRTDIV(+)                                "
    strStmt = strStmt & vbLf & "   AND LASTVIEW.PRTSEQ          = FOLLOW_PRT_H.SEQ(+)                                   "
    strStmt = strStmt & vbLf & " ORDER BY LASTVIEW.CSLDATE, LASTVIEW.DAYID, LASTVIEW.JUDCLASSCD                         "

    ''最初にﾚｺｰﾄﾞ件数だけ取得
    strStmt2 = "SELECT COUNT(*) FROM (" & strStmt & ")"
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt2), ORADYN_READONLY + ORADYN_NOCACHE)
    lngCount = objOraDyna.Fields(0).Value

    ''フォローアップ情報取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objDayId = objFields("DAYID")
        Set objPerId = objFields("PERID")
        Set objPerKname = objFields("PERKNAME")
        Set objPerName = objFields("PERNAME")
        Set objAge = objFields("AGE")
        Set objGender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objJudCd = objFields("JUDCD")
        Set objRslJudCd = objFields("RSLJUDCD")
        
        Set objCscd = objFields("CSCD")
        Set objResultDispMode = objFields("RESULTDISPMODE")
        
        Set objEquipDiv = objFields("EQUIPDIV")
        Set objStatusCd = objFields("STATUSCD")
        Set objReqConfirmDate = objFields("REQCONFIRMDATE")
        Set objReqConfirmUser = objFields("REQCONFIRMUSER")
        Set objPrtSeq = objFields("PRTSEQ")
        Set objFileName = objFields("FILENAME")
        Set objDocJud = objFields("DOC_JUD")
        Set objDocGf = objFields("DOC_GF")
        Set objDocCf = objFields("DOC_CF")
        Set objPrtDate = objFields("PRTDATE")
        Set objPrtUser = objFields("PRTUSER")
        Set objAddUser = objFields("ADDUSER")
        Set objUpdUser = objFields("UPDUSER")

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
        Set objDocGyne = objFields("DOC_GYNE")
        Set objDocGyneJud = objFields("DOC_GYNEJUD")
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

        '配列形式で格納する
        i = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(i)
            ReDim Preserve vntArrCsldate(i)
            ReDim Preserve vntArrDayId(i)
            ReDim Preserve vntArrPerId(i)
            ReDim Preserve vntArrPerKName(i)
            ReDim Preserve vntArrPerName(i)
            ReDim Preserve vntArrAge(i)
            ReDim Preserve vntArrGender(i)
            ReDim Preserve vntArrBirth(i)
            ReDim Preserve vntArrJudClassCd(i)
            ReDim Preserve vntArrJudClassName(i)
            ReDim Preserve vntArrJudCd(i)
            ReDim Preserve vntArrRslJudCd(i)
            
            ReDim Preserve vntArrCscd(i)
            ReDim Preserve vntArrResultDispMode(i)
            
            ReDim Preserve vntArrEquipDiv(i)
            ReDim Preserve vntArrStatusCd(i)
            ReDim Preserve vntArrReqConfirmDate(i)
            ReDim Preserve vntArrReqConfirmUser(i)
            ReDim Preserve vntArrPrtSeq(i)
            ReDim Preserve vntArrFileName(i)
            ReDim Preserve vntArrDocJud(i)
            ReDim Preserve vntArrDocGf(i)
            ReDim Preserve vntArrDocCf(i)
            
            ReDim Preserve vntArrPrtDate(i)
            ReDim Preserve vntArrPrtUser(i)
            ReDim Preserve vntArrAddUser(i)
            ReDim Preserve vntArrUpdUser(i)
            
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
            ReDim Preserve vntArrDocGyne(i)
            ReDim Preserve vntArrDocGyneJud(i)
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
            
            vntArrRsvNo(i) = objRsvNo.Value & ""
            vntArrCsldate(i) = objCslDate.Value & ""
            vntArrDayId(i) = objDayId.Value & ""
            vntArrPerId(i) = objPerId.Value & ""
            vntArrPerKName(i) = objPerKname.Value & ""
            vntArrPerName(i) = objPerName.Value & ""
            vntArrAge(i) = objAge.Value & ""
            vntArrGender(i) = objGender.Value & ""
            vntArrBirth(i) = objBirth.Value & ""
            vntArrJudClassCd(i) = objJudClassCd.Value & ""
            vntArrJudClassName(i) = objJudClassName.Value & ""
            
            vntArrJudCd(i) = objJudCd.Value & ""
            vntArrRslJudCd(i) = objRslJudCd.Value & ""
            
            vntArrCscd(i) = objCscd.Value & ""
            vntArrResultDispMode(i) = objResultDispMode.Value & ""
            
            vntArrEquipDiv(i) = objEquipDiv.Value & ""
            vntArrStatusCd(i) = objStatusCd.Value & ""
            vntArrReqConfirmDate(i) = objReqConfirmDate.Value & ""
            vntArrReqConfirmUser(i) = objReqConfirmUser.Value & ""
            vntArrPrtSeq(i) = objPrtSeq.Value & ""
            vntArrFileName(i) = objFileName.Value & ""
            vntArrDocJud(i) = objDocJud.Value & ""
            vntArrDocGf(i) = objDocGf.Value & ""
            vntArrDocCf(i) = objDocCf.Value & ""
            
            vntArrPrtDate(i) = objPrtDate.Value & ""
            vntArrPrtUser(i) = objPrtUser.Value & ""
            vntArrAddUser(i) = objAddUser.Value & ""
            vntArrUpdUser(i) = objUpdUser.Value & ""
            
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
            vntArrDocGyne(i) = objDocGyne.Value & ""
            vntArrDocGyneJud(i) = objDocGyneJud.Value & ""
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
            
            i = i + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCsldate) Then vntCsldate = vntArrCsldate
        If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntPerKname) Then vntPerKname = vntArrPerKName
        If Not IsMissing(vntPerName) Then vntPerName = vntArrPerName
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntBirth) Then vntBirth = vntArrBirth
        If Not IsMissing(vntJudClassCd) Then vntJudClassCd = vntArrJudClassCd
        If Not IsMissing(vntJudClassName) Then vntJudClassName = vntArrJudClassName
        If Not IsMissing(vntJudCd) Then vntJudCd = vntArrJudCd
        If Not IsMissing(vntRslJudCd) Then vntRslJudCd = vntArrRslJudCd
        
        If Not IsMissing(vntCscd) Then vntCscd = vntArrCscd
        If Not IsMissing(vntResultDispMode) Then vntResultDispMode = vntArrResultDispMode
        
        If Not IsMissing(vntEquipDiv) Then vntEquipDiv = vntArrEquipDiv
        If Not IsMissing(vntStatusCd) Then vntStatusCd = vntArrStatusCd
        If Not IsMissing(vntReqConfirmDate) Then vntReqConfirmDate = vntArrReqConfirmDate
        If Not IsMissing(vntReqConfirmUser) Then vntReqConfirmUser = vntArrReqConfirmUser
        If Not IsMissing(vntPrtSeq) Then vntPrtSeq = vntArrPrtSeq
        If Not IsMissing(vntFileName) Then vntFileName = vntArrFileName
        If Not IsMissing(vntDocJud) Then vntDocJud = vntArrDocJud
        If Not IsMissing(vntDocGf) Then vntDocGf = vntArrDocGf
        If Not IsMissing(vntDocCf) Then vntDocCf = vntArrDocCf
        
        If Not IsMissing(vntPrtDate) Then vntPrtDate = vntArrPrtDate
        If Not IsMissing(vntPrtUser) Then vntPrtUser = vntArrPrtUser
        If Not IsMissing(vntAddUser) Then vntAddUser = vntArrAddUser
        If Not IsMissing(vntUpdUser) Then vntUpdUser = vntArrUpdUser
        
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
        If Not IsMissing(vntDocGyne) Then vntDocGyne = vntArrDocGyne
        If Not IsMissing(vntDocGyneJud) Then vntDocGyneJud = vntArrDocGyneJud
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
        
    End If

    Set objRsvNo = Nothing
    Set objCslDate = Nothing
    Set objDayId = Nothing
    Set objPerId = Nothing
    Set objPerKname = Nothing
    Set objPerName = Nothing
    Set objAge = Nothing
    Set objGender = Nothing
    Set objBirth = Nothing
    Set objJudClassCd = Nothing
    Set objJudClassName = Nothing
    Set objJudCd = Nothing
    Set objRslJudCd = Nothing
    
    Set objCscd = Nothing
    Set objResultDispMode = Nothing
    
    Set objEquipDiv = Nothing
    Set objStatusCd = Nothing
    Set objReqConfirmDate = Nothing
    Set objReqConfirmUser = Nothing
    Set objPrtSeq = Nothing
    Set objFileName = Nothing
    Set objDocJud = Nothing
    Set objDocGf = Nothing
    Set objDocCf = Nothing

    Set objPrtDate = Nothing
    Set objPrtUser = Nothing
    Set objAddUser = Nothing
    Set objUpdUser = Nothing

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    Set objDocGyne = Nothing
    Set objDocGyneJud = Nothing
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    SelectTargetFollow = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectTargetFollow = -1

    'イベントログ書き込み
    WriteErrorLog "Follow.SelectTargetFollow"

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

' 張
' 機能　　 : 指定日付（受診日）範囲のフォローアップ対象者及び選択者を取得する
'
' 引数　　 : (In)     dtmStrCslDate     開始受診日
' 　　　　   (In)     dtmEndCslDate     終了受診日
' 　　　　   (In)     strPerId          患者ID
' 　　　　   (In)     strJudClassCd     判定分類コード
' 　　　　   (In)     strEquipDiv       フォロー（二次検査施設）区分
' 　　　　   (In)     strConfirmDiv     二次検査結果承認区分
' 　　　　   (In)     strAddUser        フォローアップ初期登録者ID
' 　　　　   (In)     lngPageMaxLine    １ページ表示ＭＡＸ行
' 　　　　   (In)     lngStartPos       表示開始位置
' 　　　　   (Out)    vntRsvNo          受診番号
' 　　　　   (Out)    vntCslDate        受診日
' 　　　　   (Out)    vntDayId          当日ID
' 　　　　   (Out)    vntPerId          個人ID
' 　　　　   (Out)    vntAge            年齢
' 　　　　   (Out)    vntGender         性別
' 　　　　   (Out)    vntBirth          生年月日
' 　　　　   (Out)    vntJudCd          フォロー情報として登録された判定結果
' 　　　　   (Out)    vntRslJudCd       抽出時の判定結果
' 　　　　   (Out)    vntJudClassName   判定分類名
' 　　　　   (Out)    vntJudClassCd     判定分コード
' 　　　　   (Out)    vntResultDispMode 検査結果表示モード
' 　　　　   (Out)    vntCsCd           コースコード
' 　　　　   (Out)    vntEquipDiv       二次検査実施区分
' 　　　　   (Out)    vntStatusCd       フォローアップステータス
' 　　　　   (Out)    vntReqConfirmDate 二次検査結果承認日時
' 　　　　   (Out)    vntReqConfirmUser 二次検査結果承認者
' 　　　　   (Out)    vntPrtSeq         依頼状印刷回数
' 　　　　   (Out)    vntFileName       依頼状ファイル名
' 　　　　   (Out)    vntPrtDate        依頼状最終作成日
' 　　　　   (Out)    vntPrtUser        依頼状作成者氏名
' 　　　　   (Out)    vntAddUser        フォローアップ初期登録者氏名
' 　　　　   (Out)    vntDocJud         判定医氏名
' 　　　　   (Out)    vntDocGf          上部内視鏡医氏名
' 　　　　   (Out)    vntDocCf          下部内視鏡医氏名
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
' 　　　　   (Out)    vntDocGyne        婦人科診察医氏名
' 　　　　   (Out)    vntDocGyneJud     婦人科判定医氏名
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
' 　　　　   (In)     blnCountFlg       集計フラグ(True:予約番号が重複しない件数,False:ﾚｺｰﾄﾞ件数)
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ############################################

'Public Function SelectTargetFollowList(ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, ByVal strPerId As String, _
'                                       ByVal strJudClassCd As String, ByVal strEquipDiv As String, ByVal strConfirmDiv As String, ByVal strAddUser As String, _
'                                       ByVal lngPageMaxLine As Long, ByVal lngStartPos As Long, _
'                                       Optional ByRef vntRsvNo As Variant, Optional ByRef vntCsldate As Variant, _
'                                       Optional ByRef vntDayId As Variant, Optional ByRef vntPerId As Variant, _
'                                       Optional ByRef vntPerKname As Variant, Optional ByRef vntPerName As Variant, _
'                                       Optional ByRef vntAge As Variant, Optional ByRef vntGender As Variant, _
'                                       Optional ByRef vntBirth As Variant, Optional ByRef vntJudCd As Variant, _
'                                       Optional ByRef vntRslJudCd As Variant, Optional ByRef vntJudClassName As Variant, _
'                                       Optional ByRef vntJudClassCd As Variant, Optional ByRef vntResultDispMode As Variant, _
'                                       Optional ByRef vntCscd As Variant, Optional ByRef vntEquipDiv As Variant, Optional ByRef vntStatusCd As Variant, _
'                                       Optional ByRef vntReqConfirmDate As Variant, Optional ByRef vntReqConfirmUser As Variant, _
'                                       Optional ByRef vntPrtSeq As Variant, Optional ByRef vntFileName As Variant, _
'                                       Optional ByRef vntPrtDate As Variant, Optional ByRef vntPrtUser As Variant, Optional ByRef vntAddUser As Variant, _
'                                       Optional ByRef vntDocJud As Variant, Optional ByRef vntDocGf As Variant, _
'                                       Optional ByRef vntDocCf As Variant, Optional ByRef blnCountFlg As Boolean = False _
'                                      ) As Long

Public Function SelectTargetFollowList(ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, ByVal strPerId As String, _
                                       ByVal strJudClassCd As String, ByVal strEquipDiv As String, ByVal strConfirmDiv As String, ByVal strAddUser As String, _
                                       ByVal lngPageMaxLine As Long, ByVal lngStartPos As Long, _
                                       Optional ByRef vntRsvNo As Variant, Optional ByRef vntCsldate As Variant, _
                                       Optional ByRef vntDayId As Variant, Optional ByRef vntPerId As Variant, _
                                       Optional ByRef vntPerKname As Variant, Optional ByRef vntPerName As Variant, _
                                       Optional ByRef vntAge As Variant, Optional ByRef vntGender As Variant, _
                                       Optional ByRef vntBirth As Variant, Optional ByRef vntJudCd As Variant, _
                                       Optional ByRef vntRslJudCd As Variant, Optional ByRef vntJudClassName As Variant, _
                                       Optional ByRef vntJudClassCd As Variant, Optional ByRef vntResultDispMode As Variant, _
                                       Optional ByRef vntCscd As Variant, Optional ByRef vntEquipDiv As Variant, Optional ByRef vntStatusCd As Variant, _
                                       Optional ByRef vntReqConfirmDate As Variant, Optional ByRef vntReqConfirmUser As Variant, _
                                       Optional ByRef vntPrtSeq As Variant, Optional ByRef vntFileName As Variant, _
                                       Optional ByRef vntPrtDate As Variant, Optional ByRef vntPrtUser As Variant, Optional ByRef vntAddUser As Variant, _
                                       Optional ByRef vntDocJud As Variant, Optional ByRef vntDocGf As Variant, Optional ByRef vntDocCf As Variant, _
                                       Optional ByRef vntDocGyne As Variant, Optional ByRef vntDocGyneJud As Variant, _
                                       Optional ByRef blnCountFlg As Boolean = False _
                                      ) As Long

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ############################################
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim strStmt2                As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objUpdDate              As OraField         '更新日時
    Dim objUpdUser              As OraField         '更新者
    Dim objUpdUserName          As OraField         '更新者名

    Dim objRsvNo                As OraField         '予約番号
    Dim objCslDate              As OraField         '受診日
    Dim objDayId                As OraField         '当日ID
    Dim objPerId                As OraField         '個人ID
    Dim objPerKname             As OraField         'カナ氏名
    Dim objPerName              As OraField         '氏名
    Dim objAge                  As OraField         '年齢
    Dim objGender               As OraField         '性別
    Dim objBirth                As OraField         '生年月日
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名称
    Dim objJudCd                As OraField         '判定コード（フォロー確定時判定結果）
    Dim objRslJudCd             As OraField         '判定コード（カレント（現在）判定結果）
    Dim objCscd                 As OraField         'コースコード
    Dim objResultDispMode       As OraField         '検査結果表示モード
    Dim objEquipDiv             As OraField         '二次検査実施区分
    Dim objStatusCd             As OraField         'ステータス
    Dim objReqConfirmDate       As OraField         '結果承認日
    Dim objReqConfirmUser       As OraField         '結果承認者
    Dim objPrtSeq               As OraField         '依頼状印刷回数
    Dim objFileName             As OraField         '依頼状ファイル名
    Dim objDocJud               As OraField         '判定医
    Dim objDocGf                As OraField         '上部消化管内視鏡実施医
    Dim objDocCf                As OraField         '大腸内視鏡実施医
    Dim objPrtDate              As OraField         '依頼状印刷日時
    Dim objPrtUser              As OraField         '依頼状印刷者
    Dim objAddUser              As OraField         '登録者者

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    Dim objDocGyne              As OraField         '婦人科診察医
    Dim objDocGyneJud           As OraField         '婦人科判定医
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrCsldate()         As Variant          '受診日の配列
    Dim vntArrDayId()           As Variant          '当日IDの配列
    Dim vntArrPerId()           As Variant          '個人IDの配列
    Dim vntArrPerKName()        As Variant          'カナ氏名の配列
    Dim vntArrPerName()         As Variant          '氏名の配列
    Dim vntArrAge()             As Variant          '年齢の配列
    Dim vntArrGender()          As Variant          '性別の配列
    Dim vntArrBirth()           As Variant          '生年月日の配列
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim vntArrJudCd()           As Variant          '判定コード（フォロー確定時判定結果）の配列
    Dim vntArrRslJudCd()        As Variant          '判定コード（カレント（現在）判定結果）の配列
    Dim vntArrCscd()            As Variant          'コースコードの配列
    Dim vntArrResultDispMode()  As Variant          '検査結果表示モードの配列
    Dim vntArrEquipDiv()        As Variant          '二次検査実施区分の配列
    Dim vntArrStatusCd()        As Variant          'ステータスの配列
    Dim vntArrReqConfirmDate()  As Variant          '結果承認日の配列
    Dim vntArrReqConfirmUser()  As Variant          '結果承認者の配列
    Dim vntArrPrtSeq()          As Variant          '依頼状印刷回数の配列
    Dim vntArrFileName()        As Variant          '依頼状ファイル名の配列
    Dim vntArrDocJud()          As Variant          '判定医の配列
    Dim vntArrDocGf()           As Variant          '上部消化管内視鏡実施医の配列
    Dim vntArrDocCf()           As Variant          '大腸内視鏡実施医の配列
    Dim vntArrPrtDate()         As Variant          '依頼状印刷日時の配列
    Dim vntArrPrtUser()         As Variant          '依頼状印刷者の配列
    Dim vntArrAddUser()         As Variant          '登録者の配列

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    Dim vntArrDocGyne()         As Variant          '婦人科診察医
    Dim vntArrDocGyneJud()      As Variant          '婦人科判定医
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

    Dim dtmDate                 As Date             '作業用の日付
    Dim lngMaxRow               As Long             '最大行数
    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'ｲﾝﾃﾞｯｸｽ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCsldate) Then vntCsldate = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntPerKname) Then vntPerKname = Empty
    If Not IsMissing(vntPerName) Then vntPerName = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = Empty
    If Not IsMissing(vntJudClassName) Then vntJudClassName = Empty
    If Not IsMissing(vntJudCd) Then vntJudCd = Empty
    If Not IsMissing(vntRslJudCd) Then vntRslJudCd = Empty
    If Not IsMissing(vntCscd) Then vntCscd = Empty
    If Not IsMissing(vntResultDispMode) Then vntResultDispMode = Empty
    If Not IsMissing(vntEquipDiv) Then vntEquipDiv = Empty
    If Not IsMissing(vntStatusCd) Then vntStatusCd = Empty
    If Not IsMissing(vntReqConfirmDate) Then vntReqConfirmDate = Empty
    If Not IsMissing(vntReqConfirmUser) Then vntReqConfirmUser = Empty
    If Not IsMissing(vntPrtSeq) Then vntPrtSeq = Empty
    If Not IsMissing(vntFileName) Then vntFileName = Empty
    If Not IsMissing(vntDocJud) Then vntDocJud = Empty
    If Not IsMissing(vntDocGf) Then vntDocGf = Empty
    If Not IsMissing(vntDocCf) Then vntDocCf = Empty
    If Not IsMissing(vntPrtDate) Then vntPrtDate = Empty
    If Not IsMissing(vntPrtUser) Then vntPrtUser = Empty
    If Not IsMissing(vntAddUser) Then vntPrtUser = Empty
    
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    If Not IsMissing(vntDocGyne) Then vntDocGyne = Empty
    If Not IsMissing(vntDocGyneJud) Then vntDocGyneJud = Empty
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
    
    lngCount = 0
    lngMaxRow = lngPageMaxLine + lngStartPos - 1
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
    
    SelectTargetFollowList = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", IIf(dtmStrCslDate = 0, Null, dtmStrCslDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", IIf(dtmEndCslDate = 0, Null, dtmEndCslDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "STRPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDPOS", lngMaxRow, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FOLJUDCLCD", "FOLJUDCL%", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FOLJUDCD", "FOLJUD00%", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PERID", Trim$(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD", strJudClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EQUIPDIV", strEquipDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDUSER", Trim$(strAddUser), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定検索条件のフォロー対象者リストを取得する
'### 2016.02.18 張 受診者リスト並び順を受診日、当日ID、判定分類順に正しき表示できるように修正 STR ############################################
''    strStmt = ""
''    strStmt = "SELECT ROWNUM SEQ    "
''    strStmt = strStmt & vbLf & "      ,LASTVIEW.CSLDATE                                 AS CSLDATE                      "
''    strStmt = strStmt & vbLf & "      ,LASTVIEW.DAYID                                   AS DAYID                        "
''    strStmt = strStmt & vbLf & "      ,PERSON.LASTKNAME || '　' || PERSON.FIRSTKNAME    AS PERKNAME                     "
''    strStmt = strStmt & vbLf & "      ,PERSON.LASTNAME || '　' || PERSON.FIRSTNAME      AS PERNAME                      "
''    strStmt = strStmt & vbLf & "      ,TRUNC(LASTVIEW.AGE)                              AS AGE                          "
''    strStmt = strStmt & vbLf & "      ,DECODE(PERSON.GENDER,1 ,'男' ,2 ,'女')           AS GENDER                       "
''    strStmt = strStmt & vbLf & "      ,TO_CHAR(PERSON.BIRTH,'EYY.mm.dd','NLS_CALENDAR=''Japanese Imperial''') AS BIRTH  "
''    strStmt = strStmt & vbLf & "      ,LASTVIEW.RSVNO                                   AS RSVNO                        "
''    strStmt = strStmt & vbLf & "      ,LASTVIEW.PERID                                   AS PERID                        "
''    strStmt = strStmt & vbLf & "      ,LASTVIEW.JUDCLASSCD                              AS JUDCLASSCD                   "
''    strStmt = strStmt & vbLf & "      ,JUDCLASS.JUDCLASSNAME                            AS JUDCLASSNAME                 "
''    strStmt = strStmt & vbLf & "      ,JUDCLASS.RESULTDISPMODE                          AS RESULTDISPMODE               "
''    strStmt = strStmt & vbLf & "      ,LASTVIEW.JUDCD                                   AS JUDCD                        "
''    strStmt = strStmt & vbLf & "      ,(SELECT JUDRSL.JUDCD  FROM JUDRSL                                                "
''    strStmt = strStmt & vbLf & "         WHERE JUDRSL.RSVNO = LASTVIEW.RSVNO                                            "
''    strStmt = strStmt & vbLf & "           AND JUDRSL.JUDCLASSCD = LASTVIEW.JUDCLASSCD) AS RSLJUDCD                     "
''    strStmt = strStmt & vbLf & "      ,LASTVIEW.CSCD                                    AS CSCD                         "
''    strStmt = strStmt & vbLf & "      ,NVL(LASTVIEW.EQUIPDIV,'')                        AS EQUIPDIV                     "
''    strStmt = strStmt & vbLf & "      ,NVL(LASTVIEW.STATUSCD,'')                        AS STATUSCD                     "
''    strStmt = strStmt & vbLf & "      ,NVL(LASTVIEW.REQCONFIRMDATE,'')                  AS REQCONFIRMDATE               "
''    strStmt = strStmt & vbLf & "      ,(SELECT USERNAME  FROM HAINSUSER                                                 "
''    strStmt = strStmt & vbLf & "         WHERE HAINSUSER.USERID = LASTVIEW.REQCONFIRMUSER) AS REQCONFIRMUSER            "
''    strStmt = strStmt & vbLf & "      ,LASTVIEW.PRTSEQ                                  AS PRTSEQ                       "
''    strStmt = strStmt & vbLf & "      ,NVL(FOLLOW_PRT_H.FILENAME,'')                    AS FILENAME                     "
''    strStmt = strStmt & vbLf & "      ,DECODE(FOLLOW_PRT_H.ADDDATE,NULL,'',TO_CHAR(FOLLOW_PRT_H.ADDDATE,'YYYY/MM/DD HH24:MI'))   AS PRTDATE     "
''    strStmt = strStmt & vbLf & "      ,(SELECT USERNAME  FROM HAINSUSER                                                 "
''    strStmt = strStmt & vbLf & "         WHERE HAINSUSER.USERID = FOLLOW_PRT_H.ADDUSER) AS PRTUSER                      "
''    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'30910' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'30910' ,'00'))  AS DOC_JUD  "
''    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'23320' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'23320' ,'00'))  AS DOC_GF   "
''    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'23550' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'23550' ,'00'))  AS DOC_CF   "
''    strStmt = strStmt & vbLf & "      ,(SELECT USERNAME  FROM HAINSUSER                                                 "
''    strStmt = strStmt & vbLf & "         WHERE HAINSUSER.USERID = LASTVIEW.ADDUSER)     AS ADDUSER                      "
''
'''### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
''    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'30980' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'30980' ,'00'))  AS DOC_GYNE    "
''    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'30981' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'30981' ,'00'))  AS DOC_GYNEJUD "
'''### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
''
''    strStmt = strStmt & vbLf & "  FROM (                                                                                "
''
''    '検索条件として登録者が指定されている場合、登録済のフォローアップ情報のみ検索する
''    If Trim$(strAddUser) = "" Then
''
''        strStmt = strStmt & vbLf & "           (                                                                            "
''        strStmt = strStmt & vbLf & "            SELECT CONSULT.CSLDATE         AS CSLDATE                                   "
''        strStmt = strStmt & vbLf & "                  ,RECEIPT.DAYID           AS DAYID                                     "
''        strStmt = strStmt & vbLf & "                  ,CONSULT.RSVNO           AS RSVNO                                     "
''        strStmt = strStmt & vbLf & "                  ,CONSULT.PERID           AS PERID                                     "
''        strStmt = strStmt & vbLf & "                  ,CONSULT.AGE             AS AGE                                       "
''        strStmt = strStmt & vbLf & "                  ,CONSULT.CSCD            AS CSCD                                      "
''        strStmt = strStmt & vbLf & "                  ,JUDRSL.JUDCLASSCD       AS JUDCLASSCD                                "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS JUDCD                                     "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS EQUIPDIV                                  "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS PRTSEQ                                    "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS STATUSCD                                  "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMDATE                            "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMUSER                            "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS ADDUSER                                   "
''        strStmt = strStmt & vbLf & "              FROM CONSULT                                                              "
''        strStmt = strStmt & vbLf & "                  ,RECEIPT                                                              "
''        strStmt = strStmt & vbLf & "                  ,JUDRSL                                                               "
''        strStmt = strStmt & vbLf & "             WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE                  "
''        strStmt = strStmt & vbLf & "               AND CONSULT.CANCELFLG = 0                                                "
''
''        If Trim$(strPerId) <> "" Then
''            strStmt = strStmt & vbLf & "               AND CONSULT.PERID = :PERID                                               "
''        End If
''
''        strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = RECEIPT.RSVNO                                      "
''        strStmt = strStmt & vbLf & "               AND RECEIPT.COMEDATE IS NOT NULL                                         "
''        strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = JUDRSL.RSVNO                                       "
''        strStmt = strStmt & vbLf & "               AND JUDRSL.JUDCLASSCD IN (SELECT FREE.FREEFIELD1                         "
''        strStmt = strStmt & vbLf & "                                           FROM FREE                                    "
''        strStmt = strStmt & vbLf & "                                          WHERE FREE.FREECD LIKE :FOLJUDCLCD)           "
''        strStmt = strStmt & vbLf & "               AND JUDRSL.JUDCD      IN (SELECT FREE1.FREEFIELD1 JUDCD                  "
''        strStmt = strStmt & vbLf & "                                           FROM FREE                                    "
''        strStmt = strStmt & vbLf & "                                               ,FREE FREE1                              "
''        strStmt = strStmt & vbLf & "                                          WHERE FREE.FREECD LIKE :FOLJUDCLCD            "
''        strStmt = strStmt & vbLf & "                                            AND FREE.FREEFIELD1 = JUDRSL.JUDCLASSCD     "
''        strStmt = strStmt & vbLf & "                                            AND FREE.FREECLASSCD = FREE1.FREECLASSCD    "
''        strStmt = strStmt & vbLf & "                                            AND FREE1.FREECD LIKE :FOLJUDCD)            "
''        strStmt = strStmt & vbLf & "            MINUS                                                                       "
''        strStmt = strStmt & vbLf & "            SELECT CONSULT.CSLDATE         AS CSLDATE                                   "
''        strStmt = strStmt & vbLf & "                  ,RECEIPT.DAYID           AS DAYID                                     "
''        strStmt = strStmt & vbLf & "                  ,CONSULT.RSVNO           AS RSVNO                                     "
''        strStmt = strStmt & vbLf & "                  ,CONSULT.PERID           AS PERID                                     "
''        strStmt = strStmt & vbLf & "                  ,CONSULT.AGE             AS AGE                                       "
''        strStmt = strStmt & vbLf & "                  ,CONSULT.CSCD            AS CSCD                                      "
''        strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.JUDCLASSCD  AS JUDCLASSCD                                "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS JUDCD                                     "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS EQUIPDIV                                  "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS PRTSEQ                                    "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS STATUSCD                                  "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMDATE                            "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMUSER                            "
''        strStmt = strStmt & vbLf & "                  ,NULL                    AS ADDUSER                                   "
''        strStmt = strStmt & vbLf & "              FROM CONSULT                                                              "
''        strStmt = strStmt & vbLf & "                  ,RECEIPT                                                              "
''        strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO                                                          "
''        strStmt = strStmt & vbLf & "             WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE                  "
''        strStmt = strStmt & vbLf & "               AND CONSULT.CANCELFLG = 0                                                "
''
''        If Trim$(strPerId) <> "" Then
''            strStmt = strStmt & vbLf & "               AND CONSULT.PERID = :PERID                                               "
''        End If
''
''        strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = RECEIPT.RSVNO                                      "
''        strStmt = strStmt & vbLf & "               AND RECEIPT.COMEDATE IS NOT NULL                                         "
''        strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = FOLLOW_INFO.RSVNO                                  "
''        strStmt = strStmt & vbLf & "           )                                                                            "
''        strStmt = strStmt & vbLf & "        UNION                                                                           "
''
''    End If
''
''    strStmt = strStmt & vbLf & "            SELECT CONSULT.CSLDATE         AS CSLDATE                                   "
''    strStmt = strStmt & vbLf & "                  ,RECEIPT.DAYID           AS DAYID                                     "
''    strStmt = strStmt & vbLf & "                  ,CONSULT.RSVNO           AS RSVNO                                     "
''    strStmt = strStmt & vbLf & "                  ,CONSULT.PERID           AS PERID                                     "
''    strStmt = strStmt & vbLf & "                  ,CONSULT.AGE             AS AGE                                       "
''    strStmt = strStmt & vbLf & "                  ,CONSULT.CSCD            AS CSCD                                      "
''    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.JUDCLASSCD  AS JUDCLASSCD                                "
''    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.JUDCD       AS JUDCD                                     "
''    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.SECEQUIPDIV AS EQUIPDIV                                  "
''    strStmt = strStmt & vbLf & "                  ,(SELECT MAX(SEQ) FROM FOLLOW_PRT_H                                   "
''    strStmt = strStmt & vbLf & "                     WHERE RSVNO      = FOLLOW_INFO.RSVNO                               "
''    strStmt = strStmt & vbLf & "                       AND JUDCLASSCD = FOLLOW_INFO.JUDCLASSCD                          "
''    strStmt = strStmt & vbLf & "                       AND PRTDIV     = 1                                               "
''    strStmt = strStmt & vbLf & "                   ) AS PRTSEQ                                                          "
''    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.STATUSCD    AS STATUSCD                                  "
''    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.REQCONFIRMDATE AS REQCONFIRMDATE                         "
''    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.REQCONFIRMUSER AS REQCONFIRMUSER                         "
''    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.ADDUSER     AS ADDUSER                                   "
''    strStmt = strStmt & vbLf & "              FROM CONSULT                                                              "
''    strStmt = strStmt & vbLf & "                  ,RECEIPT                                                              "
''    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO                                                          "
''    strStmt = strStmt & vbLf & "             WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE                  "
''    strStmt = strStmt & vbLf & "               AND CONSULT.CANCELFLG = 0                                                "
''
''    If Trim$(strPerId) <> "" Then
''        strStmt = strStmt & vbLf & "               AND CONSULT.PERID = :PERID                                               "
''    End If
''
''    strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = RECEIPT.RSVNO                                      "
''    strStmt = strStmt & vbLf & "               AND RECEIPT.COMEDATE IS NOT NULL                                         "
''    strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = FOLLOW_INFO.RSVNO                                  "
''
''    If Trim$(strAddUser) <> "" Then
''        strStmt = strStmt & vbLf & "               AND FOLLOW_INFO.ADDUSER = :ADDUSER                                       "
''    End If
''
''    strStmt = strStmt & vbLf & "       ) LASTVIEW                                                                       "
''    strStmt = strStmt & vbLf & "      ,JUDCLASS                                                                         "
''    strStmt = strStmt & vbLf & "      ,PERSON                                                                           "
''    strStmt = strStmt & vbLf & "      ,FOLLOW_PRT_H                                                                     "
''    strStmt = strStmt & vbLf & " WHERE LASTVIEW.JUDCLASSCD      = JUDCLASS.JUDCLASSCD                                   "
''    strStmt = strStmt & vbLf & "   AND JUDCLASS.COMMENTONLY     IS NULL                                                 "
''    strStmt = strStmt & vbLf & "   AND LASTVIEW.PERID           = PERSON.PERID                                          "
''    strStmt = strStmt & vbLf & "   AND LASTVIEW.RSVNO           = FOLLOW_PRT_H.RSVNO(+)                                 "
''    strStmt = strStmt & vbLf & "   AND LASTVIEW.JUDCLASSCD      = FOLLOW_PRT_H.JUDCLASSCD(+)                            "
''    strStmt = strStmt & vbLf & "   AND 1                        = FOLLOW_PRT_H.PRTDIV(+)                                "
''    strStmt = strStmt & vbLf & "   AND LASTVIEW.PRTSEQ          = FOLLOW_PRT_H.SEQ(+)                                   "
''
''    ''検査項目条件チェック
''    If Trim$(strJudClassCd) <> "" Then
''        strStmt = strStmt & vbLf & "   AND LASTVIEW.JUDCLASSCD      = :ITEMCD                                           "
''    End If
''
''    ''二次検査施設区分条件チェック
''    If Trim$(strEquipDiv) <> "" Then
''        If Trim$(strEquipDiv) <> "999" Then
''            strStmt = strStmt & vbLf & "   AND LASTVIEW.EQUIPDIV        = :EQUIPDIV                                     "
''        Else
''            strStmt = strStmt & vbLf & "   AND LASTVIEW.EQUIPDIV        IS NULL                                         "
''        End If
''    End If
''
''    ''結果承認有無条件チェック
''    If Trim$(strConfirmDiv) = "1" Then
''        strStmt = strStmt & vbLf & "   AND LASTVIEW.REQCONFIRMDATE  IS NOT NULL                                         "
''    Else
''        If Trim$(strConfirmDiv) = "0" Then
''            strStmt = strStmt & vbLf & "   AND LASTVIEW.REQCONFIRMDATE  IS NULL                                         "
''        End If
''    End If
''
''    strStmt = strStmt & vbLf & " ORDER BY LASTVIEW.CSLDATE, LASTVIEW.DAYID, LASTVIEW.JUDCLASSCD                         "
    
    strStmt = ""
    strStmt = "SELECT ROWNUM SEQ    "
    strStmt = strStmt & vbLf & "      ,FINAL.* "
    strStmt = strStmt & vbLf & "  FROM ( "
    
    strStmt = strStmt & vbLf & "        SELECT LASTVIEW.CSLDATE                                 AS CSLDATE                      "
    strStmt = strStmt & vbLf & "              ,LASTVIEW.DAYID                                   AS DAYID                        "
    strStmt = strStmt & vbLf & "              ,PERSON.LASTKNAME || '　' || PERSON.FIRSTKNAME    AS PERKNAME                     "
    strStmt = strStmt & vbLf & "              ,PERSON.LASTNAME || '　' || PERSON.FIRSTNAME      AS PERNAME                      "
    strStmt = strStmt & vbLf & "              ,TRUNC(LASTVIEW.AGE)                              AS AGE                          "
    strStmt = strStmt & vbLf & "              ,DECODE(PERSON.GENDER,1 ,'男' ,2 ,'女')           AS GENDER                       "
    strStmt = strStmt & vbLf & "              ,TO_CHAR(PERSON.BIRTH,'EYY.mm.dd','NLS_CALENDAR=''Japanese Imperial''') AS BIRTH  "
    strStmt = strStmt & vbLf & "              ,LASTVIEW.RSVNO                                   AS RSVNO                        "
    strStmt = strStmt & vbLf & "              ,LASTVIEW.PERID                                   AS PERID                        "
    strStmt = strStmt & vbLf & "              ,LASTVIEW.JUDCLASSCD                              AS JUDCLASSCD                   "
    strStmt = strStmt & vbLf & "              ,JUDCLASS.JUDCLASSNAME                            AS JUDCLASSNAME                 "
    strStmt = strStmt & vbLf & "              ,JUDCLASS.RESULTDISPMODE                          AS RESULTDISPMODE               "
    strStmt = strStmt & vbLf & "              ,LASTVIEW.JUDCD                                   AS JUDCD                        "
    strStmt = strStmt & vbLf & "              ,(SELECT JUDRSL.JUDCD  FROM JUDRSL                                                "
    strStmt = strStmt & vbLf & "                 WHERE JUDRSL.RSVNO = LASTVIEW.RSVNO                                            "
    strStmt = strStmt & vbLf & "                   AND JUDRSL.JUDCLASSCD = LASTVIEW.JUDCLASSCD) AS RSLJUDCD                     "
    strStmt = strStmt & vbLf & "              ,LASTVIEW.CSCD                                    AS CSCD                         "
    strStmt = strStmt & vbLf & "              ,NVL(LASTVIEW.EQUIPDIV,'')                        AS EQUIPDIV                     "
    strStmt = strStmt & vbLf & "              ,NVL(LASTVIEW.STATUSCD,'')                        AS STATUSCD                     "
    strStmt = strStmt & vbLf & "              ,NVL(LASTVIEW.REQCONFIRMDATE,'')                  AS REQCONFIRMDATE               "
    strStmt = strStmt & vbLf & "              ,(SELECT USERNAME  FROM HAINSUSER                                                 "
    strStmt = strStmt & vbLf & "                 WHERE HAINSUSER.USERID = LASTVIEW.REQCONFIRMUSER) AS REQCONFIRMUSER            "
    strStmt = strStmt & vbLf & "              ,LASTVIEW.PRTSEQ                                  AS PRTSEQ                       "
    strStmt = strStmt & vbLf & "              ,NVL(FOLLOW_PRT_H.FILENAME,'')                    AS FILENAME                     "
    strStmt = strStmt & vbLf & "              ,DECODE(FOLLOW_PRT_H.ADDDATE,NULL,'',TO_CHAR(FOLLOW_PRT_H.ADDDATE,'YYYY/MM/DD HH24:MI'))   AS PRTDATE     "
    strStmt = strStmt & vbLf & "              ,(SELECT USERNAME  FROM HAINSUSER                                                 "
    strStmt = strStmt & vbLf & "                 WHERE HAINSUSER.USERID = FOLLOW_PRT_H.ADDUSER) AS PRTUSER                      "
    strStmt = strStmt & vbLf & "              ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'30910' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'30910' ,'00'))  AS DOC_JUD  "
    strStmt = strStmt & vbLf & "              ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'23320' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'23320' ,'00'))  AS DOC_GF   "
    strStmt = strStmt & vbLf & "              ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'23550' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'23550' ,'00'))  AS DOC_CF   "
    strStmt = strStmt & vbLf & "              ,(SELECT USERNAME  FROM HAINSUSER                                                 "
    strStmt = strStmt & vbLf & "                 WHERE HAINSUSER.USERID = LASTVIEW.ADDUSER)     AS ADDUSER                      "
    
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    strStmt = strStmt & vbLf & "              ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'30980' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'30980' ,'00'))  AS DOC_GYNE    "
    strStmt = strStmt & vbLf & "              ,DECODE(FC_GET_RESULT(LASTVIEW.RSVNO,'30981' ,'00'),NULL,'-','','-',FC_GET_RESULT(LASTVIEW.RSVNO,'30981' ,'00'))  AS DOC_GYNEJUD "
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###
    
    strStmt = strStmt & vbLf & "        FROM (                                                                                "
    
    '検索条件として登録者が指定されている場合、登録済のフォローアップ情報のみ検索する
    If Trim$(strAddUser) = "" Then
        
        strStmt = strStmt & vbLf & "           (                                                                            "
        strStmt = strStmt & vbLf & "            SELECT CONSULT.CSLDATE         AS CSLDATE                                   "
        strStmt = strStmt & vbLf & "                  ,RECEIPT.DAYID           AS DAYID                                     "
        strStmt = strStmt & vbLf & "                  ,CONSULT.RSVNO           AS RSVNO                                     "
        strStmt = strStmt & vbLf & "                  ,CONSULT.PERID           AS PERID                                     "
        strStmt = strStmt & vbLf & "                  ,CONSULT.AGE             AS AGE                                       "
        strStmt = strStmt & vbLf & "                  ,CONSULT.CSCD            AS CSCD                                      "
        strStmt = strStmt & vbLf & "                  ,JUDRSL.JUDCLASSCD       AS JUDCLASSCD                                "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS JUDCD                                     "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS EQUIPDIV                                  "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS PRTSEQ                                    "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS STATUSCD                                  "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMDATE                            "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMUSER                            "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS ADDUSER                                   "
        strStmt = strStmt & vbLf & "              FROM CONSULT                                                              "
        strStmt = strStmt & vbLf & "                  ,RECEIPT                                                              "
        strStmt = strStmt & vbLf & "                  ,JUDRSL                                                               "
        strStmt = strStmt & vbLf & "             WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE                  "
        strStmt = strStmt & vbLf & "               AND CONSULT.CANCELFLG = 0                                                "
        
        If Trim$(strPerId) <> "" Then
            strStmt = strStmt & vbLf & "               AND CONSULT.PERID = :PERID                                               "
        End If
        
        strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = RECEIPT.RSVNO                                      "
        strStmt = strStmt & vbLf & "               AND RECEIPT.COMEDATE IS NOT NULL                                         "
        strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = JUDRSL.RSVNO                                       "
        strStmt = strStmt & vbLf & "               AND JUDRSL.JUDCLASSCD IN (SELECT FREE.FREEFIELD1                         "
        strStmt = strStmt & vbLf & "                                           FROM FREE                                    "
        strStmt = strStmt & vbLf & "                                          WHERE FREE.FREECD LIKE :FOLJUDCLCD)           "
        strStmt = strStmt & vbLf & "               AND JUDRSL.JUDCD      IN (SELECT FREE1.FREEFIELD1 JUDCD                  "
        strStmt = strStmt & vbLf & "                                           FROM FREE                                    "
        strStmt = strStmt & vbLf & "                                               ,FREE FREE1                              "
        strStmt = strStmt & vbLf & "                                          WHERE FREE.FREECD LIKE :FOLJUDCLCD            "
        strStmt = strStmt & vbLf & "                                            AND FREE.FREEFIELD1 = JUDRSL.JUDCLASSCD     "
        strStmt = strStmt & vbLf & "                                            AND FREE.FREECLASSCD = FREE1.FREECLASSCD    "
        strStmt = strStmt & vbLf & "                                            AND FREE1.FREECD LIKE :FOLJUDCD)            "
        strStmt = strStmt & vbLf & "            MINUS                                                                       "
        strStmt = strStmt & vbLf & "            SELECT CONSULT.CSLDATE         AS CSLDATE                                   "
        strStmt = strStmt & vbLf & "                  ,RECEIPT.DAYID           AS DAYID                                     "
        strStmt = strStmt & vbLf & "                  ,CONSULT.RSVNO           AS RSVNO                                     "
        strStmt = strStmt & vbLf & "                  ,CONSULT.PERID           AS PERID                                     "
        strStmt = strStmt & vbLf & "                  ,CONSULT.AGE             AS AGE                                       "
        strStmt = strStmt & vbLf & "                  ,CONSULT.CSCD            AS CSCD                                      "
        strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.JUDCLASSCD  AS JUDCLASSCD                                "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS JUDCD                                     "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS EQUIPDIV                                  "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS PRTSEQ                                    "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS STATUSCD                                  "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMDATE                            "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS REQCONFIRMUSER                            "
        strStmt = strStmt & vbLf & "                  ,NULL                    AS ADDUSER                                   "
        strStmt = strStmt & vbLf & "              FROM CONSULT                                                              "
        strStmt = strStmt & vbLf & "                  ,RECEIPT                                                              "
        strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO                                                          "
        strStmt = strStmt & vbLf & "             WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE                  "
        strStmt = strStmt & vbLf & "               AND CONSULT.CANCELFLG = 0                                                "
        
        If Trim$(strPerId) <> "" Then
            strStmt = strStmt & vbLf & "               AND CONSULT.PERID = :PERID                                               "
        End If
        
        strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = RECEIPT.RSVNO                                      "
        strStmt = strStmt & vbLf & "               AND RECEIPT.COMEDATE IS NOT NULL                                         "
        strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = FOLLOW_INFO.RSVNO                                  "
        strStmt = strStmt & vbLf & "           )                                                                            "
        strStmt = strStmt & vbLf & "        UNION                                                                           "
    
    End If
    
    strStmt = strStmt & vbLf & "            SELECT CONSULT.CSLDATE         AS CSLDATE                                   "
    strStmt = strStmt & vbLf & "                  ,RECEIPT.DAYID           AS DAYID                                     "
    strStmt = strStmt & vbLf & "                  ,CONSULT.RSVNO           AS RSVNO                                     "
    strStmt = strStmt & vbLf & "                  ,CONSULT.PERID           AS PERID                                     "
    strStmt = strStmt & vbLf & "                  ,CONSULT.AGE             AS AGE                                       "
    strStmt = strStmt & vbLf & "                  ,CONSULT.CSCD            AS CSCD                                      "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.JUDCLASSCD  AS JUDCLASSCD                                "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.JUDCD       AS JUDCD                                     "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.SECEQUIPDIV AS EQUIPDIV                                  "
    strStmt = strStmt & vbLf & "                  ,(SELECT MAX(SEQ) FROM FOLLOW_PRT_H                                   "
    strStmt = strStmt & vbLf & "                     WHERE RSVNO      = FOLLOW_INFO.RSVNO                               "
    strStmt = strStmt & vbLf & "                       AND JUDCLASSCD = FOLLOW_INFO.JUDCLASSCD                          "
    strStmt = strStmt & vbLf & "                       AND PRTDIV     = 1                                               "
    strStmt = strStmt & vbLf & "                   ) AS PRTSEQ                                                          "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.STATUSCD    AS STATUSCD                                  "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.REQCONFIRMDATE AS REQCONFIRMDATE                         "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.REQCONFIRMUSER AS REQCONFIRMUSER                         "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO.ADDUSER     AS ADDUSER                                   "
    strStmt = strStmt & vbLf & "              FROM CONSULT                                                              "
    strStmt = strStmt & vbLf & "                  ,RECEIPT                                                              "
    strStmt = strStmt & vbLf & "                  ,FOLLOW_INFO                                                          "
    strStmt = strStmt & vbLf & "             WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE                  "
    strStmt = strStmt & vbLf & "               AND CONSULT.CANCELFLG = 0                                                "
    
    If Trim$(strPerId) <> "" Then
        strStmt = strStmt & vbLf & "               AND CONSULT.PERID = :PERID                                               "
    End If
    
    strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = RECEIPT.RSVNO                                      "
    strStmt = strStmt & vbLf & "               AND RECEIPT.COMEDATE IS NOT NULL                                         "
    strStmt = strStmt & vbLf & "               AND CONSULT.RSVNO   = FOLLOW_INFO.RSVNO                                  "
    
    If Trim$(strAddUser) <> "" Then
        strStmt = strStmt & vbLf & "               AND FOLLOW_INFO.ADDUSER = :ADDUSER                                       "
    End If
    
    strStmt = strStmt & vbLf & "            ) LASTVIEW                                                                       "
    strStmt = strStmt & vbLf & "           ,JUDCLASS                                                                         "
    strStmt = strStmt & vbLf & "           ,PERSON                                                                           "
    strStmt = strStmt & vbLf & "           ,FOLLOW_PRT_H                                                                     "
    strStmt = strStmt & vbLf & "      WHERE LASTVIEW.JUDCLASSCD      = JUDCLASS.JUDCLASSCD                                   "
    strStmt = strStmt & vbLf & "        AND JUDCLASS.COMMENTONLY     IS NULL                                                 "
    strStmt = strStmt & vbLf & "        AND LASTVIEW.PERID           = PERSON.PERID                                          "
    strStmt = strStmt & vbLf & "        AND LASTVIEW.RSVNO           = FOLLOW_PRT_H.RSVNO(+)                                 "
    strStmt = strStmt & vbLf & "        AND LASTVIEW.JUDCLASSCD      = FOLLOW_PRT_H.JUDCLASSCD(+)                            "
    strStmt = strStmt & vbLf & "        AND 1                        = FOLLOW_PRT_H.PRTDIV(+)                                "
    strStmt = strStmt & vbLf & "        AND LASTVIEW.PRTSEQ          = FOLLOW_PRT_H.SEQ(+)                                   "
    
    ''検査項目条件チェック
    If Trim$(strJudClassCd) <> "" Then
        strStmt = strStmt & vbLf & "        AND LASTVIEW.JUDCLASSCD      = :ITEMCD                                           "
    End If
    
    ''二次検査施設区分条件チェック
    If Trim$(strEquipDiv) <> "" Then
        If Trim$(strEquipDiv) <> "999" Then
            strStmt = strStmt & vbLf & "        AND LASTVIEW.EQUIPDIV        = :EQUIPDIV                                     "
        Else
            strStmt = strStmt & vbLf & "        AND LASTVIEW.EQUIPDIV        IS NULL                                         "
        End If
    End If
    
    ''結果承認有無条件チェック
    If Trim$(strConfirmDiv) = "1" Then
        strStmt = strStmt & vbLf & "        AND LASTVIEW.REQCONFIRMDATE  IS NOT NULL                                         "
    Else
        If Trim$(strConfirmDiv) = "0" Then
            strStmt = strStmt & vbLf & "        AND LASTVIEW.REQCONFIRMDATE  IS NULL                                         "
        End If
    End If
    
    strStmt = strStmt & vbLf & "      ORDER BY LASTVIEW.CSLDATE, LASTVIEW.DAYID, LASTVIEW.JUDCLASSCD                         "
    strStmt = strStmt & vbLf & "     ) FINAL "
    
'### 2016.02.18 張 受診者リスト並び順を受診日、当日ID、判定分類順に正しき表示できるように修正 END ############################################
    
    
    
    ''最初にﾚｺｰﾄﾞ件数だけ取得
    If blnCountFlg Then
        strStmt2 = "SELECT COUNT(DISTINCT RSVNO) FROM (" & strStmt & ")"
    Else
        strStmt2 = "SELECT COUNT(*) FROM (" & strStmt & ")"
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt2), ORADYN_READONLY + ORADYN_NOCACHE)
    lngCount = objOraDyna.Fields(0).Value

    strStmt = "SELECT * FROM (" & strStmt & ")" & vbLf
    strStmt = strStmt & vbLf & "WHERE SEQ BETWEEN :STRPOS AND :ENDPOS                               "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objDayId = objFields("DAYID")
        Set objPerId = objFields("PERID")
        Set objPerKname = objFields("PERKNAME")
        Set objPerName = objFields("PERNAME")
        Set objAge = objFields("AGE")
        Set objGender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objJudCd = objFields("JUDCD")
        Set objRslJudCd = objFields("RSLJUDCD")
        
        Set objCscd = objFields("CSCD")
        Set objResultDispMode = objFields("RESULTDISPMODE")
        
        Set objEquipDiv = objFields("EQUIPDIV")
        Set objStatusCd = objFields("STATUSCD")
        Set objReqConfirmDate = objFields("REQCONFIRMDATE")
        Set objReqConfirmUser = objFields("REQCONFIRMUSER")
        Set objPrtSeq = objFields("PRTSEQ")
        Set objFileName = objFields("FILENAME")
        Set objDocJud = objFields("DOC_JUD")
        Set objDocGf = objFields("DOC_GF")
        Set objDocCf = objFields("DOC_CF")
        Set objPrtDate = objFields("PRTDATE")
        Set objPrtUser = objFields("PRTUSER")
        Set objAddUser = objFields("ADDUSER")

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
        Set objDocGyne = objFields("DOC_GYNE")
        Set objDocGyneJud = objFields("DOC_GYNEJUD")
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

        '配列形式で格納する
        i = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrRsvNo(i)
            ReDim Preserve vntArrCsldate(i)
            ReDim Preserve vntArrDayId(i)
            ReDim Preserve vntArrPerId(i)
            ReDim Preserve vntArrPerKName(i)
            ReDim Preserve vntArrPerName(i)
            ReDim Preserve vntArrAge(i)
            ReDim Preserve vntArrGender(i)
            ReDim Preserve vntArrBirth(i)
            ReDim Preserve vntArrJudClassCd(i)
            ReDim Preserve vntArrJudClassName(i)
            ReDim Preserve vntArrJudCd(i)
            ReDim Preserve vntArrRslJudCd(i)
            
            ReDim Preserve vntArrCscd(i)
            ReDim Preserve vntArrResultDispMode(i)
            
            ReDim Preserve vntArrEquipDiv(i)
            ReDim Preserve vntArrStatusCd(i)
            ReDim Preserve vntArrReqConfirmDate(i)
            ReDim Preserve vntArrReqConfirmUser(i)
            ReDim Preserve vntArrPrtSeq(i)
            ReDim Preserve vntArrFileName(i)
            ReDim Preserve vntArrDocJud(i)
            ReDim Preserve vntArrDocGf(i)
            ReDim Preserve vntArrDocCf(i)

            ReDim Preserve vntArrPrtDate(i)
            ReDim Preserve vntArrPrtUser(i)

            ReDim Preserve vntArrAddUser(i)

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
            ReDim Preserve vntArrDocGyne(i)
            ReDim Preserve vntArrDocGyneJud(i)
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

            vntArrRsvNo(i) = objRsvNo.Value & ""
            vntArrCsldate(i) = objCslDate.Value & ""
            vntArrDayId(i) = objDayId.Value & ""
            vntArrPerId(i) = objPerId.Value & ""
            vntArrPerKName(i) = objPerKname.Value & ""
            vntArrPerName(i) = objPerName.Value & ""
            vntArrAge(i) = objAge.Value & ""
            vntArrGender(i) = objGender.Value & ""
            vntArrBirth(i) = objBirth.Value & ""
            vntArrJudClassCd(i) = objJudClassCd.Value & ""
            vntArrJudClassName(i) = objJudClassName.Value & ""

            vntArrJudCd(i) = objJudCd.Value & ""
            vntArrRslJudCd(i) = objRslJudCd.Value & ""

            vntArrCscd(i) = objCscd.Value & ""
            vntArrResultDispMode(i) = objResultDispMode.Value & ""

            vntArrEquipDiv(i) = objEquipDiv.Value & ""
            vntArrStatusCd(i) = objStatusCd.Value & ""
            vntArrReqConfirmDate(i) = objReqConfirmDate.Value & ""
            vntArrReqConfirmUser(i) = objReqConfirmUser.Value & ""
            vntArrPrtSeq(i) = objPrtSeq.Value & ""
            vntArrFileName(i) = objFileName.Value & ""
            vntArrDocJud(i) = objDocJud.Value & ""
            vntArrDocGf(i) = objDocGf.Value & ""
            vntArrDocCf(i) = objDocCf.Value & ""

            vntArrPrtDate(i) = objPrtDate.Value & ""
            vntArrPrtUser(i) = objPrtUser.Value & ""

            vntArrAddUser(i) = objAddUser.Value & ""

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
            vntArrDocGyne(i) = objDocGyne.Value & ""
            vntArrDocGyneJud(i) = objDocGyneJud.Value & ""
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

            i = i + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCsldate) Then vntCsldate = vntArrCsldate
        If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntPerKname) Then vntPerKname = vntArrPerKName
        If Not IsMissing(vntPerName) Then vntPerName = vntArrPerName
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntBirth) Then vntBirth = vntArrBirth
        If Not IsMissing(vntJudClassCd) Then vntJudClassCd = vntArrJudClassCd
        If Not IsMissing(vntJudClassName) Then vntJudClassName = vntArrJudClassName
        If Not IsMissing(vntJudCd) Then vntJudCd = vntArrJudCd
        If Not IsMissing(vntRslJudCd) Then vntRslJudCd = vntArrRslJudCd
        
        If Not IsMissing(vntCscd) Then vntCscd = vntArrCscd
        If Not IsMissing(vntResultDispMode) Then vntResultDispMode = vntArrResultDispMode
        
        If Not IsMissing(vntEquipDiv) Then vntEquipDiv = vntArrEquipDiv
        If Not IsMissing(vntStatusCd) Then vntStatusCd = vntArrStatusCd
        If Not IsMissing(vntReqConfirmDate) Then vntReqConfirmDate = vntArrReqConfirmDate
        If Not IsMissing(vntReqConfirmUser) Then vntReqConfirmUser = vntArrReqConfirmUser
        If Not IsMissing(vntPrtSeq) Then vntPrtSeq = vntArrPrtSeq
        If Not IsMissing(vntFileName) Then vntFileName = vntArrFileName
        If Not IsMissing(vntDocJud) Then vntDocJud = vntArrDocJud
        If Not IsMissing(vntDocGf) Then vntDocGf = vntArrDocGf
        If Not IsMissing(vntDocCf) Then vntDocCf = vntArrDocCf
        
        If Not IsMissing(vntPrtDate) Then vntPrtDate = vntArrPrtDate
        If Not IsMissing(vntPrtUser) Then vntPrtUser = vntArrPrtUser
        
        If Not IsMissing(vntAddUser) Then vntAddUser = vntArrAddUser

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
        If Not IsMissing(vntDocGyne) Then vntDocGyne = vntArrDocGyne
        If Not IsMissing(vntDocGyneJud) Then vntDocGyneJud = vntArrDocGyneJud
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

    End If


    Set objRsvNo = Nothing
    Set objCslDate = Nothing
    Set objDayId = Nothing
    Set objPerId = Nothing
    Set objPerKname = Nothing
    Set objPerName = Nothing
    Set objAge = Nothing
    Set objGender = Nothing
    Set objBirth = Nothing
    Set objJudClassCd = Nothing
    Set objJudClassName = Nothing
    Set objJudCd = Nothing
    Set objRslJudCd = Nothing
    
    Set objCscd = Nothing
    Set objResultDispMode = Nothing
    
    Set objEquipDiv = Nothing
    Set objStatusCd = Nothing
    Set objReqConfirmDate = Nothing
    Set objReqConfirmUser = Nothing
    Set objFileName = Nothing
    Set objPrtSeq = Nothing
    Set objDocJud = Nothing
    Set objDocGf = Nothing
    Set objDocCf = Nothing

    Set objPrtDate = Nothing
    Set objPrtUser = Nothing

    Set objAddUser = Nothing

'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 STR ###
    Set objDocGyne = Nothing
    Set objDocGyneJud = Nothing
'### 2016.01.21 張 婦人科診察フォローアップ追加によって追加 END ###

    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectTargetFollowList = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectTargetFollowList = -1

    'イベントログ書き込み
    WriteErrorLog "Follow.SelectTargetFollowList"

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


' 機能　　 : 指定予約番号のフォロー状況管理情報を取得する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     lngJudClassCd     判定分類コード
' 　　　　   (In)     lngSeq            二次検査一連番号
'
'
'
'
'
'
'
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function UpdateFollow_Rsl(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, ByVal lngSeq As Long, _
                                 ByVal strSecCslDate As String, ByVal strUpdUser As String, _
                                 ByVal strTestUS As String, ByVal strTestCT As String, _
                                 ByVal strTestMRI As String, ByVal strTestBF As String, _
                                 ByVal strTestGF As String, ByVal strTestCF As String, _
                                 ByVal strTestEM As String, ByVal strTestTM As String, _
                                 ByVal strTestEtc As String, ByVal strTestRemark As String, _
                                 ByVal strTestRefer As String, ByVal strTestReferText As String, _
                                 ByVal strResultDiv As String, ByVal strDisRemark As String, _
                                 ByVal strPolWithout As String, ByVal strPolFollowup As String, _
                                 ByVal strPolMonth As String, ByVal strPolReExam As String, _
                                 ByVal strPolDiagSt As String, ByVal strPolDiag As String, ByVal strPolEtc1 As String, _
                                 ByVal strPolRemark1 As String, ByVal strPolSugery As String, _
                                 ByVal strPolEndoscope As String, ByVal strPolChemical As String, _
                                 ByVal strPolRadiation As String, ByVal strPolReferSt As String, ByVal strPolRefer As String, _
                                 ByVal strPolEtc2 As String, ByVal strPolRemark2 As String, _
                                 ByVal vntItemCd As Variant, ByVal vntSuffix As Variant, ByVal vntResult As Variant, _
                                 Optional ByRef lngNewSeq As Variant _
                                ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    
    Dim objParaSeq              As OraParameter     '一連番号
    Dim objParaItemCd           As OraParameter     '検査項目コード
    Dim objParaSuffix           As OraParameter     'サフィクス
    Dim objParaResult           As OraParameter     '疾患コード
    
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraDyna2             As OraDynaset       'ダイナセット２
    Dim objOraDyna3             As OraDynaset       'ダイナセット３
    Dim objOraDyna4             As OraDynaset       'ダイナセット４
    
    Dim strStmt                 As String           'SQLステートメント
    Dim strStmt2                As String           'SQLステートメント２
    Dim strStmt3                As String           'SQLステートメント３
    Dim strStmt4                As String           'SQLステートメント４

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objFields2              As OraFields        'フィールドオブジェクト２
    Dim objFields3              As OraFields        'フィールドオブジェクト３
    Dim objFields4              As OraFields        'フィールドオブジェクト４
    
    Dim objSecCslDate           As OraField         '
    Dim objTestUS               As OraField         '
    Dim objTestCT               As OraField         '
    Dim objTestMRI              As OraField         '
    Dim objTestBF               As OraField         '
    Dim objTestGF               As OraField         '
    Dim objTestCF               As OraField         '
    Dim objTestEM               As OraField         '
    Dim objTestTM               As OraField         '
    Dim objTestEtc              As OraField         '
    Dim objTestRemark           As OraField         '
    '2009/12/28 Add by yhlee ----------------------------------
    Dim objTestRefer            As OraField         'リファー
    Dim objTestReferText        As OraField         'リファー科
    '2009/12/28 (End) -----------------------------------------
    Dim objResultDiv            As OraField         '
    Dim objDisRemark            As OraField         '
    Dim objPolWithout           As OraField         '
    Dim objPolFollowup          As OraField         '
    Dim objPolMonth             As OraField         '
    Dim objPolReExam            As OraField         '
    Dim objPolDiagSt            As OraField         '
    Dim objPolDiag              As OraField         '
    Dim objPolEtc1              As OraField         '
    Dim objPolRemark1           As OraField         '
    Dim objPolSugery            As OraField         '
    Dim objPolEndoscope         As OraField         '
    Dim objPolChemical          As OraField         '
    Dim objPolRadiation         As OraField         '
    Dim objPolReferSt           As OraField         '
    Dim objPolRefer             As OraField         '
    Dim objPolEtc2              As OraField         '
    Dim objPolRemark2           As OraField         '
    Dim objItemCd               As OraField         '項目コード
    Dim objSuffix               As OraField         '文章コード
    Dim objResult               As OraField         '略称
    Dim objNewSeq               As OraField         '結果情報一連番号取得用

    Dim strBSecCslDate          As String           '
    Dim strBTestUS              As String           '
    Dim strBTestCT              As String           '
    Dim strBTestMRI             As String           '
    Dim strBTestBF              As String           '
    Dim strBTestGF              As String           '
    Dim strBTestCF              As String           '
    Dim strBTestEM              As String           '
    Dim strBTestTM              As String           '
    Dim strBTestEtc             As String           '
    Dim strBTestRemark          As String           '
    '2009/12/28 Add by yhlee ----------------------------------
    Dim strBTestRefer           As String           '
    Dim strBTestReferText       As String           '
    '2009/12/28 Add by (End) ----------------------------------
    Dim strBResultDiv           As String           '
    Dim strBResultDivName       As String           '
    Dim strBDisRemark           As String           '
    Dim strBPolWithout          As String           '
    Dim strBPolFollowup         As String           '
    Dim strBPolMonth            As String           '
    Dim strBPolReExam           As String           '
    Dim strBPolDiagSt           As String           '
    Dim strBPolDiag             As String           '
    Dim strBPolEtc1             As String           '
    Dim strBPolRemark1          As String           '
    Dim strBPolSugery           As String           '
    Dim strBPolEndoscope        As String           '
    Dim strBPolChemical         As String           '
    Dim strBPolRadiation        As String           '
    Dim strBPolReferSt          As String           '
    Dim strBPolRefer            As String           '
    Dim strBPolEtc2             As String           '
    Dim strBPolRemark2          As String           '
    
    Dim strItemName             As String           '変更履歴項目名
    Dim strResultDivName        As String
    
    Dim vntBItemCd()            As Variant          '変更前検査項目
    Dim vntBSuffix()            As Variant          '変更前サフィックス
    Dim vntBResult()            As Variant          '変更前結果（疾患）
    
    Dim vntAItemCd()            As Variant          '変更後検査項目
    Dim vntASuffix()            As Variant          '変更後サフィックス
    Dim vntAResult()            As Variant          '変更後結果（疾患）

    Dim i                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim j                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim k                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim lngCount                As Long             'レコード数
    Dim lngBeforeCnt            As Long             '変更前疾患カウント
    Dim lngAfterCnt             As Long             '変更後疾患カウント
    Dim Ret                     As Boolean          '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    UpdateFollow_Rsl = False
    lngCount = UBound(vntItemCd)

    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "SECCSLDATE", IIf(Not IsDate(strSecCslDate), Null, Format$(strSecCslDate, "yyyy/mm/dd")), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTUS", strTestUS, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTCT", strTestCT, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTMRI", strTestMRI, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTBF", strTestBF, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTGF", strTestGF, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTCF", strTestCF, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTEM", strTestEM, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTTM", strTestTM, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTETC", strTestEtc, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTREMARK", strTestRemark, ORAPARM_INPUT, ORATYPE_VARCHAR2
    '2009/12/28 Add by yhlee ----------------------------------
    objOraParam.Add "TESTREFER", strTestRefer, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TESTREFERTEXT", strTestReferText, ORAPARM_INPUT, ORATYPE_VARCHAR2
    '2009/12/28 Add by (End) ----------------------------------
    objOraParam.Add "RESULTDIV", strResultDiv, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISREMARK", strDisRemark, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "POLWITHOUT", strPolWithout, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLFOLLOWUP", strPolFollowup, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLMONTH", strPolMonth, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLREEXAM", strPolReExam, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLDIAGST", strPolDiagSt, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLDIAG", strPolDiag, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLETC1", strPolEtc1, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLREMARK1", strPolRemark1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "POLSUGERY", strPolSugery, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLENDOSCOPE", strPolEndoscope, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLCHEMICAL", strPolChemical, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLRADIATION", strPolRadiation, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLREFERST", strPolReferSt, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLREFER", strPolRefer, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLETC2", strPolEtc2, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POLREMARK2", strPolRemark2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    objOraParam.Add "ITEMCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RESULT", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    objOraParam("SEQ").Value = lngSeq
    '結果変更の場合：受け取った一連番号、新規登録の場合：付番している新しい一連番号を返す
    lngNewSeq = lngSeq

    '指定予約番号・検査項目（判定分類）のフォロー情報を取得する
    strStmt = ""
    strStmt = "SELECT FOLLOW_RSL.SECCSLDATE,      FOLLOW_RSL.TESTUS,            " & vbLf & _
              "       FOLLOW_RSL.TESTCT,          FOLLOW_RSL.TESTMRI,           " & vbLf & _
              "       FOLLOW_RSL.TESTBF,          FOLLOW_RSL.TESTGF,            " & vbLf & _
              "       FOLLOW_RSL.TESTCF,          FOLLOW_RSL.TESTEM,            " & vbLf & _
              "       FOLLOW_RSL.TESTTM,          FOLLOW_RSL.TESTETC,           " & vbLf & _
              "       FOLLOW_RSL.TESTREMARK,      FOLLOW_RSL.RESULTDIV,         " & vbLf & _
              "       FOLLOW_RSL.TESTREFER,       FOLLOW_RSL.TESTREFERTEXT,     " & vbLf & _
              "       FOLLOW_RSL.DISREMARK,       FOLLOW_RSL.POLWITHOUT,        " & vbLf & _
              "       FOLLOW_RSL.POLFOLLOWUP,     FOLLOW_RSL.POLMONTH,          " & vbLf & _
              "       FOLLOW_RSL.POLREEXAM,       FOLLOW_RSL.POLDIAGST,         FOLLOW_RSL.POLDIAG,           " & vbLf & _
              "       FOLLOW_RSL.POLETC1,         FOLLOW_RSL.POLREMARK1,        " & vbLf & _
              "       FOLLOW_RSL.POLSUGERY,       FOLLOW_RSL.POLENDOSCOPE,      " & vbLf & _
              "       FOLLOW_RSL.POLCHEMICAL,     FOLLOW_RSL.POLRADIATION,      " & vbLf & _
              "       FOLLOW_RSL.POLREFER,        FOLLOW_RSL.POLREFERST,        FOLLOW_RSL.POLETC2,           " & vbLf & _
              "       FOLLOW_RSL.POLREMARK2                                     " & vbLf & _
              "  FROM FOLLOW_RSL                                                " & vbLf & _
              " WHERE FOLLOW_RSL.RSVNO      = :RSVNO                            " & vbLf & _
              "   AND FOLLOW_RSL.JUDCLASSCD = :JUDCLASSCD                       " & vbLf & _
              "   AND FOLLOW_RSL.SEQ        = :SEQ                              " & vbLf & _
              "   FOR UPDATE                                                    "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


    If objOraDyna.EOF Then
        
            '### 該当フォローアップ結果情報すべてのレコードロック ###
            strStmt4 = "SELECT FOLLOW_RSL.SEQ                                " & vbLf & _
                       "  FROM FOLLOW_RSL                                    " & vbLf & _
                       " WHERE FOLLOW_RSL.RSVNO      = :RSVNO                " & vbLf & _
                       "   AND FOLLOW_RSL.JUDCLASSCD = :JUDCLASSCD           " & vbLf & _
                       "   FOR UPDATE                                        "
            Set objOraDyna4 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt4), ORADYN_READONLY + ORADYN_NOCACHE)

            '### フォローアップ結果情報一連番号取得 ###
            strStmt2 = "SELECT NVL(MAX(FOLLOW_RSL.SEQ),0)+1 AS NEWSEQ        " & vbLf & _
                       "  FROM FOLLOW_RSL                                    " & vbLf & _
                       " WHERE FOLLOW_RSL.RSVNO      = :RSVNO                " & vbLf & _
                       "   AND FOLLOW_RSL.JUDCLASSCD = :JUDCLASSCD           "
    
            Set objOraDyna2 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt2), ORADYN_READONLY + ORADYN_NOCACHE)

            If Not objOraDyna2.EOF Then
                Set objFields2 = objOraDyna2.Fields
                Set objNewSeq = objFields2("NEWSEQ")
                lngNewSeq = objNewSeq.Value
            Else
                lngNewSeq = 1
            End If
            objOraParam("SEQ").Value = lngNewSeq
        
        
            strStmt = "INSERT INTO FOLLOW_RSL  (        " & vbLf & _
                      "             RSVNO,              " & vbLf & _
                      "             JUDCLASSCD,         " & vbLf & _
                      "             SEQ,                " & vbLf & _
                      "             SECCSLDATE,         " & vbLf & _
                      "             ADDDATE,            " & vbLf & _
                      "             ADDUSER,            " & vbLf & _
                      "             UPDDATE,            " & vbLf & _
                      "             UPDUSER,            " & vbLf & _
                      "             TESTUS,             " & vbLf & _
                      "             TESTCT,             " & vbLf & _
                      "             TESTMRI,            " & vbLf & _
                      "             TESTBF,             " & vbLf & _
                      "             TESTGF,             " & vbLf & _
                      "             TESTCF,             " & vbLf & _
                      "             TESTEM,             " & vbLf & _
                      "             TESTTM,             " & vbLf & _
                      "             TESTETC,            " & vbLf & _
                      "             TESTREMARK,         " & vbLf & _
                      "             TESTREFER,          " & vbLf & _
                      "             TESTREFERTEXT,      "
            strStmt = strStmt & vbLf & _
                      "             RESULTDIV,          " & vbLf & _
                      "             DISREMARK,          " & vbLf & _
                      "             POLWITHOUT,         " & vbLf & _
                      "             POLFOLLOWUP,        " & vbLf & _
                      "             POLMONTH,           " & vbLf & _
                      "             POLREEXAM,          " & vbLf & _
                      "             POLDIAGST,          " & vbLf & _
                      "             POLDIAG,            " & vbLf & _
                      "             POLETC1,            " & vbLf & _
                      "             POLREMARK1,         " & vbLf & _
                      "             POLSUGERY,          " & vbLf & _
                      "             POLENDOSCOPE,       " & vbLf & _
                      "             POLCHEMICAL,        " & vbLf & _
                      "             POLRADIATION,       " & vbLf & _
                      "             POLREFERST,         " & vbLf & _
                      "             POLREFER,           " & vbLf & _
                      "             POLETC2,            " & vbLf & _
                      "             POLREMARK2          "
            strStmt = strStmt & vbLf & _
                      "         ) VALUES (              " & vbLf & _
                      "             :RSVNO,             " & vbLf & _
                      "             :JUDCLASSCD,        " & vbLf & _
                      "             :SEQ,               " & vbLf & _
                      "             :SECCSLDATE,        " & vbLf & _
                      "             SYSDATE,            " & vbLf & _
                      "             :UPDUSER,           " & vbLf & _
                      "             SYSDATE,            " & vbLf & _
                      "             :UPDUSER,           " & vbLf & _
                      "             :TESTUS,            " & vbLf & _
                      "             :TEStCT,            " & vbLf & _
                      "             :TESTMRI,           " & vbLf & _
                      "             :TESTBF,            " & vbLf & _
                      "             :TESTGF,            " & vbLf & _
                      "             :TESTCF,            " & vbLf & _
                      "             :TESTEM,            " & vbLf & _
                      "             :TESTTM,            " & vbLf & _
                      "             :TESTETC,           " & vbLf & _
                      "             :TESTREMARK,        " & vbLf & _
                      "             :TESTREFER,         " & vbLf & _
                      "             :TESTREFERTEXT,     "
            strStmt = strStmt & vbLf & _
                      "             :RESULTDIV,         " & vbLf & _
                      "             :DISREMARK,         " & vbLf & _
                      "             :POLWITHOUT,        " & vbLf & _
                      "             :POLFOLLOWUP,       " & vbLf & _
                      "             :POLMONTH,          " & vbLf & _
                      "             :POLREEXAM,         " & vbLf & _
                      "             :POLDIAGST,         " & vbLf & _
                      "             :POLDIAG,           " & vbLf & _
                      "             :POLETC1,           " & vbLf & _
                      "             :POLREMARK1,        " & vbLf & _
                      "             :POLSUGERY,         " & vbLf & _
                      "             :POLENDOSCOPE,      " & vbLf & _
                      "             :POLCHEMICAL,       " & vbLf & _
                      "             :POLRADIATION,      " & vbLf & _
                      "             :POLREFERST,        " & vbLf & _
                      "             :POLREFER,          " & vbLf & _
                      "             :POLETC2,           " & vbLf & _
                      "             :POLREMARK2         " & vbLf & _
                      "         )                       "
    
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    
            '#### 疾患（診断名）新規挿入
            j = 0
            lngAfterCnt = 0
            Do Until j > UBound(vntItemCd)
    
                If vntResult(j) <> "" Then
                    
                    ReDim Preserve vntAItemCd(j)
                    ReDim Preserve vntASuffix(j)
                    ReDim Preserve vntAResult(j)

                    vntAItemCd(j) = Trim$(vntItemCd(j))
                    vntASuffix(j) = Trim$(vntSuffix(j))
                    
                    objOraParam("ITEMCD").Value = Trim$(vntItemCd(j))
                    objOraParam("SUFFIX").Value = Trim$(vntSuffix(j))
                    objOraParam("RESULT").Value = Trim$(vntResult(j))
                    
                    strStmt3 = "SELECT ITEM_C.ITEMCD        AS ITEMCD           " & vbLf & _
                               "      ,ITEM_C.SUFFIX        AS SUFFIX           " & vbLf & _
                               "      ,ITEM_C.ITEMNAME      AS ITEMNAME         " & vbLf & _
                               "      ,SENTENCE.LONGSTC     AS LONGSTC          " & vbLf & _
                               "  FROM ITEM_C                                   " & vbLf & _
                               "      ,SENTENCE                                 " & vbLf & _
                               " WHERE ITEM_C.ITEMCD    = :ITEMCD               " & vbLf & _
                               "   AND ITEM_C.SUFFIX    = :SUFFIX               " & vbLf & _
                               "   AND ITEM_C.STCITEMCD = SENTENCE.ITEMCD       " & vbLf & _
                               "   AND ITEM_C.ITEMTYPE  = SENTENCE.ITEMTYPE     " & vbLf & _
                               "   AND SENTENCE.STCCD   = :RESULT               "
                    
                    Set objOraDyna3 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt3), ORADYN_READONLY + ORADYN_NOCACHE)

                    '検索レコードが存在する場合
                    If Not objOraDyna3.EOF Then

                        'オブジェクトの参照設定
                        Set objFields3 = objOraDyna3.Fields
                        Set objResult = objFields3("LONGSTC")

                        vntAResult(j) = objResult.Value & ""
                    Else
                        vntAResult(j) = ""
                    End If
                    
                    strStmt3 = "INSERT INTO FOLLOW_RSL_I (      " & vbLf & _
                               "             RSVNO,             " & vbLf & _
                               "             JUDCLASSCD,        " & vbLf & _
                               "             SEQ,               " & vbLf & _
                               "             ITEMCD,            " & vbLf & _
                               "             SUFFIX,            " & vbLf & _
                               "             RESULT             " & vbLf & _
                               "         ) VALUES (             " & vbLf & _
                               "             :RSVNO,            " & vbLf & _
                               "             :JUDCLASSCD,       " & vbLf & _
                               "             :SEQ,              " & vbLf & _
                               "             :ITEMCD,           " & vbLf & _
                               "             :SUFFIX,           " & vbLf & _
                               "             :RESULT            " & vbLf & _
                               "         )                      "
        
                    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt3)
                    lngAfterCnt = lngAfterCnt + 1
                End If
                j = j + 1
            Loop
    
            ''###フォローアップ情報の更新日、更新者変更 Start #################################################
            strStmt4 = "UPDATE FOLLOW_INFO SET                    " & vbLf & _
                      "       UPDDATE       = SYSDATE,           " & vbLf & _
                      "       UPDUSER       = :UPDUSER           " & vbLf & _
                      " WHERE RSVNO         = :RSVNO             " & vbLf & _
                      "   AND JUDCLASSCD    = :JUDCLASSCD        "

            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt4)
            ''###フォローアップ情報の更新日、更新者変更 End   #################################################
    
    
            ''### 新規登録の場合はLOG出力 Start ##############################################################
            strItemName = "二次検査年月日"
            If strSecCslDate <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strSecCslDate)
            End If
            '''検査方法登録履歴 Start
            strItemName = "検査方法"
            If strTestUS <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "US")
            End If

            If strTestCT <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "CT")
            End If
            If strTestMRI <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "MRI")
            End If
            If strTestBF <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "BF")
            End If
            If strTestGF <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "GF")
            End If
            If strTestCF <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "CF")
            End If
            If strTestEM <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "注腸")
            End If
            If strTestTM <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "腫瘍マーカー")
            End If
            If strTestEtc <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "その他")
            End If
            If strTestRemark <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strTestRemark)
            End If
            If strTestRefer <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "リファー")
            End If
            If strTestReferText <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strTestReferText)
            End If
                        
            '''検査方法登録履歴 End
            
            '''二次検査結果区分登録履歴 Start
            strItemName = "二次検査結果"
            strResultDivName = ""
            If strResultDiv <> "" Then
                Select Case strResultDiv
                   Case 1
                        strResultDivName = "異常なし"
                   Case 2
                        strResultDivName = "不明"
                   Case 3
                        strResultDivName = "所見あり"
                End Select
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strResultDivName)
            End If
            '''二次検査結果区分登録履歴 End

            strItemName = "その他疾患"
            If strDisRemark <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strDisRemark)
            End If

            '''二次検査方針登録履歴 Start
            strItemName = "方針（治療なし）"
            If strPolWithout <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "処置不要")
            End If
            If strPolFollowup <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "経過観察")
            End If
            If strPolMonth <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strPolMonth)
            End If
            If strPolReExam <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "１年後健診")
            End If
            If strPolDiagSt <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "本院紹介（精査）")
            End If
            If strPolDiag <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "他院紹介（精査）")
            End If
            If strPolEtc1 <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "その他（治療なし）")
            End If
            If strPolRemark1 <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strPolRemark1)
            End If

            strItemName = "方針（治療あり）"
            If strPolSugery <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "外科治療")
            End If
            If strPolEndoscope <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "内視鏡的治療")
            End If
            If strPolChemical <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "化学療法")
            End If
            If strPolRadiation <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "放射線治療")
            End If
            If strPolReferSt <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "本院紹介（治療）")
            End If
            If strPolRefer <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "他院紹介（治療）")
            End If
            If strPolEtc2 <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "その他（治療あり）")
            End If
            If strPolRemark2 <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strPolRemark2)
            End If
            '''二次検査方針登録履歴 End

            '''二次検査診断名（疾患）登録履歴 Start
            strItemName = "診断名（疾患）"
            k = 0
            If lngAfterCnt > 0 Then
                Do Until k > UBound(vntAItemCd)
                    If vntAResult(k) <> "" Then
                        Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, vntAItemCd(k), vntASuffix(k), "", vntAResult(k))
                    End If
                    k = k + 1
                Loop
            End If
            '''二次検査診断名（疾患）登録履歴 End

            ''### 新規登録の場合はLOG出力 End   ##############################################################
    
    Else
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
    
            Set objSecCslDate = objFields("SECCSLDATE")
            Set objTestUS = objFields("TESTUS")
            Set objTestCT = objFields("TESTCT")
            Set objTestMRI = objFields("TESTMRI")
            Set objTestBF = objFields("TESTBF")
            Set objTestGF = objFields("TESTGF")
            Set objTestCF = objFields("TESTCF")
            Set objTestEM = objFields("TESTEM")
            Set objTestTM = objFields("TESTTM")
            Set objTestEtc = objFields("TESTETC")
            Set objTestRemark = objFields("TESTREMARK")
            ' 2009.12.21 リファー追加 :yhlee -------------
            Set objTestRefer = objFields("TESTREFER")
            Set objTestReferText = objFields("TESTREFERTEXT")
            ' 2009.12.21 リファー追加 (End) -------------
            Set objResultDiv = objFields("RESULTDIV")
            Set objDisRemark = objFields("DISREMARK")
            Set objPolWithout = objFields("POLWITHOUT")
            Set objPolFollowup = objFields("POLFOLLOWUP")
            Set objPolMonth = objFields("POLMONTH")
            Set objPolReExam = objFields("POLREEXAM")
            Set objPolDiagSt = objFields("POLDIAGST")
            Set objPolDiag = objFields("POLDIAG")
            Set objPolEtc1 = objFields("POLETC1")
            Set objPolRemark1 = objFields("POLREMARK1")
            Set objPolSugery = objFields("POLSUGERY")
            Set objPolEndoscope = objFields("POLENDOSCOPE")
            Set objPolChemical = objFields("POLCHEMICAL")
            Set objPolRadiation = objFields("POLRADIATION")
            Set objPolReferSt = objFields("POLREFERST")
            Set objPolRefer = objFields("POLREFER")
            Set objPolEtc2 = objFields("POLETC2")
            Set objPolRemark2 = objFields("POLREMARK2")
    
            strBSecCslDate = IIf(IsNull(objSecCslDate.Value), "", objSecCslDate.Value)
            strBTestUS = IIf(IsNull(objTestUS.Value), "", objTestUS.Value)
            strBTestCT = IIf(IsNull(objTestCT.Value), "", objTestCT.Value)
            strBTestMRI = IIf(IsNull(objTestMRI.Value), "", objTestMRI.Value)
            strBTestBF = IIf(IsNull(objTestBF.Value), "", objTestBF.Value)
            strBTestGF = IIf(IsNull(objTestGF.Value), "", objTestGF.Value)
            strBTestCF = IIf(IsNull(objTestCF.Value), "", objTestCF.Value)
            strBTestEM = IIf(IsNull(objTestEM.Value), "", objTestEM.Value)
            strBTestTM = IIf(IsNull(objTestTM.Value), "", objTestTM.Value)
            strBTestEtc = IIf(IsNull(objTestEtc.Value), "", objTestEtc.Value)
            strBTestRemark = IIf(IsNull(objTestRemark.Value), "", objTestRemark.Value)
            
            strBTestRefer = IIf(IsNull(objTestRefer.Value), "", objTestRefer.Value)
            strBTestReferText = IIf(IsNull(objTestReferText.Value), "", objTestReferText.Value)
            
            strBResultDiv = IIf(IsNull(objResultDiv.Value), "", objResultDiv.Value)
            strBDisRemark = IIf(IsNull(objDisRemark.Value), "", objDisRemark.Value)
            strBPolWithout = IIf(IsNull(objPolWithout.Value), "", objPolWithout.Value)
            strBPolFollowup = IIf(IsNull(objPolFollowup.Value), "", objPolFollowup.Value)
            strBPolMonth = IIf(IsNull(objPolMonth.Value), "", objPolMonth.Value)
            strBPolReExam = IIf(IsNull(objPolReExam.Value), "", objPolReExam.Value)
            strBPolDiagSt = IIf(IsNull(objPolDiagSt.Value), "", objPolDiagSt.Value)
            strBPolDiag = IIf(IsNull(objPolDiag.Value), "", objPolDiag.Value)
            strBPolEtc1 = IIf(IsNull(objPolEtc1.Value), "", objPolEtc1.Value)
            strBPolRemark1 = IIf(IsNull(objPolRemark1.Value), "", objPolRemark1.Value)
            strBPolSugery = IIf(IsNull(objPolSugery.Value), "", objPolSugery.Value)
            strBPolEndoscope = IIf(IsNull(objPolEndoscope.Value), "", objPolEndoscope.Value)
            strBPolChemical = IIf(IsNull(objPolChemical.Value), "", objPolChemical.Value)
            strBPolRadiation = IIf(IsNull(objPolRadiation.Value), "", objPolRadiation.Value)
            strBPolReferSt = IIf(IsNull(objPolReferSt.Value), "", objPolReferSt.Value)
            strBPolRefer = IIf(IsNull(objPolRefer.Value), "", objPolRefer.Value)
            strBPolEtc2 = IIf(IsNull(objPolEtc2.Value), "", objPolEtc2.Value)
            strBPolRemark2 = IIf(IsNull(objPolRemark2.Value), "", objPolRemark2.Value)


            strStmt = "UPDATE FOLLOW_RSL SET                     " & vbLf & _
                      "       SECCSLDATE    = :SECCSLDATE,       " & vbLf & _
                      "       UPDDATE       = SYSDATE,           " & vbLf & _
                      "       UPDUSER       = :UPDUSER,          " & vbLf & _
                      "       TESTUS        = :TESTUS,           " & vbLf & _
                      "       TESTCT        = :TESTCT,           " & vbLf & _
                      "       TESTMRI       = :TESTMRI,          " & vbLf & _
                      "       TESTBF        = :TESTBF,           " & vbLf & _
                      "       TESTGF        = :TESTGF,           " & vbLf & _
                      "       TESTCF        = :TESTCF,           " & vbLf & _
                      "       TESTEM        = :TESTEM,           " & vbLf & _
                      "       TESTTM        = :TESTTM,           " & vbLf & _
                      "       TESTETC       = :TESTETC,          " & vbLf & _
                      "       TESTREMARK    = :TESTREMARK,       " & vbLf & _
                      "       TESTREFER     = :TESTREFER,        " & vbLf & _
                      "       TESTREFERTEXT = :TESTREFERTEXT,    "
            strStmt = strStmt & vbLf & _
                      "       RESULTDIV     = :RESULTDIV,        " & vbLf & _
                      "       DISREMARK     = :DISREMARK,        " & vbLf & _
                      "       POLWITHOUT    = :POLWITHOUT,       " & vbLf & _
                      "       POLFOLLOWUP   = :POLFOLLOWUP,      " & vbLf & _
                      "       POLMONTH      = :POLMONTH,         " & vbLf & _
                      "       POLREEXAM     = :POLREEXAM,        " & vbLf & _
                      "       POLDIAGST     = :POLDIAGST,        " & vbLf & _
                      "       POLDIAG       = :POLDIAG,          " & vbLf & _
                      "       POLETC1       = :POLETC1,          " & vbLf & _
                      "       POLREMARK1    = :POLREMARK1,       " & vbLf & _
                      "       POLSUGERY     = :POLSUGERY,        " & vbLf & _
                      "       POLENDOSCOPE  = :POLENDOSCOPE,     " & vbLf & _
                      "       POLCHEMICAL   = :POLCHEMICAL,      " & vbLf & _
                      "       POLRADIATION  = :POLRADIATION,     " & vbLf & _
                      "       POLREFERST    = :POLREFERST,       " & vbLf & _
                      "       POLREFER      = :POLREFER,         " & vbLf & _
                      "       POLETC2       = :POLETC2,          " & vbLf & _
                      "       POLREMARK2    = :POLREMARK2        "
            strStmt = strStmt & vbLf & _
                      " WHERE RSVNO         = :RSVNO             " & vbLf & _
                      "   AND JUDCLASSCD    = :JUDCLASSCD        " & vbLf & _
                      "   AND SEQ           = :SEQ               "
    
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
            
            
            ''###疾患（診断名）情報削除前変更履歴登録のため結果取得 Start ########################################
            strStmt3 = "SELECT LAST.RSVNO           AS RSVNO                        " & vbLf & _
                       "      ,LAST.JUDCLASSCD      AS JUDCLASSCD                   " & vbLf & _
                       "      ,LAST.ITEMCD          AS ITEMCD                       " & vbLf & _
                       "      ,LAST.SUFFIX          AS SUFFIX                       " & vbLf & _
                       "      ,LAST.ITEMNAME        AS ITEMCDNAME                   " & vbLf & _
                       "      ,SENTENCE.LONGSTC     AS LONGSTC                      " & vbLf & _
                       "  FROM (                                                    " & vbLf & _
                       "        SELECT FOLLOW_RSL_I.RSVNO       AS RSVNO            " & vbLf & _
                       "              ,FOLLOW_RSL_I.JUDCLASSCD  AS JUDCLASSCD       " & vbLf & _
                       "              ,FOLLOW_RSL_I.ITEMCD      AS ITEMCD           " & vbLf & _
                       "              ,FOLLOW_RSL_I.SUFFIX      AS SUFFIX           " & vbLf & _
                       "              ,ITEM_C.ITEMTYPE          AS ITEMTYPE         " & vbLf & _
                       "              ,ITEM_C.STCITEMCD         AS STCITEMCD        " & vbLf & _
                       "              ,FOLLOW_RSL_I.RESULT      AS RESULT           " & vbLf & _
                       "              ,ITEM_C.ITEMNAME          AS ITEMNAME         "
            strStmt3 = strStmt3 & vbLf & _
                       "          FROM FOLLOW_RSL_I                                 " & vbLf & _
                       "              ,ITEM_C                                       " & vbLf & _
                       "         WHERE FOLLOW_RSL_I.RSVNO       = :RSVNO            " & vbLf & _
                       "           AND FOLLOW_RSL_I.JUDCLASSCD  = :JUDCLASSCD       " & vbLf & _
                       "           AND FOLLOW_RSL_I.SEQ         = :SEQ              " & vbLf & _
                       "           AND FOLLOW_RSL_I.ITEMCD = ITEM_C.ITEMCD          " & vbLf & _
                       "           AND FOLLOW_RSL_I.SUFFIX = ITEM_C.SUFFIX          " & vbLf & _
                       "       ) LAST                                               " & vbLf & _
                       "      ,SENTENCE                                             " & vbLf & _
                       " WHERE LAST.STCITEMCD = SENTENCE.ITEMCD(+)                  " & vbLf & _
                       "   AND LAST.ITEMTYPE  = SENTENCE.ITEMTYPE(+)                " & vbLf & _
                       "   AND LAST.RESULT    = SENTENCE.STCCD(+)                   "
            
            
            Set objOraDyna3 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt3), ORADYN_READONLY + ORADYN_NOCACHE)

            '検索レコードが存在する場合
            If Not objOraDyna3.EOF Then

                'オブジェクトの参照設定
                Set objFields3 = objOraDyna3.Fields
                Set objItemCd = objFields3("ITEMCD")
                Set objSuffix = objFields3("SUFFIX")
                Set objResult = objFields3("LONGSTC")

                '配列形式で格納する
                lngBeforeCnt = 0
                Do Until objOraDyna3.EOF
                    ReDim Preserve vntBItemCd(lngBeforeCnt)
                    ReDim Preserve vntBSuffix(lngBeforeCnt)
                    ReDim Preserve vntBResult(lngBeforeCnt)

                    vntBItemCd(lngBeforeCnt) = objItemCd.Value & ""
                    vntBSuffix(lngBeforeCnt) = objSuffix.Value & ""
                    vntBResult(lngBeforeCnt) = objResult.Value & ""

                    lngBeforeCnt = lngBeforeCnt + 1
                    objOraDyna3.MoveNext
                Loop

            End If
            
            ''###疾患（診断名）情報はすべて削除してから挿入 Start #############################################
            strStmt3 = "DELETE FROM FOLLOW_RSL_I                " & vbLf & _
                       " WHERE RSVNO        = :RSVNO            " & vbLf & _
                       "   AND JUDCLASSCD   = :JUDCLASSCD       " & vbLf & _
                       "   AND SEQ          = :SEQ              "
    
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt3)
    
            j = 0
            lngAfterCnt = 0
            Do Until j > UBound(vntItemCd)
    
                If vntResult(j) <> "" Then
                    
                    ReDim Preserve vntAItemCd(j)
                    ReDim Preserve vntASuffix(j)
                    ReDim Preserve vntAResult(j)

                    vntAItemCd(j) = Trim$(vntItemCd(j))
                    vntASuffix(j) = Trim$(vntSuffix(j))
                    
                    objOraParam("ITEMCD").Value = Trim$(vntItemCd(j))
                    objOraParam("SUFFIX").Value = Trim$(vntSuffix(j))
                    objOraParam("RESULT").Value = Trim$(vntResult(j))
                    
                    strStmt3 = "SELECT ITEM_C.ITEMCD        AS ITEMCD           " & vbLf & _
                               "      ,ITEM_C.SUFFIX        AS SUFFIX           " & vbLf & _
                               "      ,ITEM_C.ITEMNAME      AS ITEMNAME         " & vbLf & _
                               "      ,SENTENCE.LONGSTC     AS LONGSTC          " & vbLf & _
                               "  FROM ITEM_C                                   " & vbLf & _
                               "      ,SENTENCE                                 " & vbLf & _
                               " WHERE ITEM_C.ITEMCD    = :ITEMCD               " & vbLf & _
                               "   AND ITEM_C.SUFFIX    = :SUFFIX               " & vbLf & _
                               "   AND ITEM_C.STCITEMCD = SENTENCE.ITEMCD       " & vbLf & _
                               "   AND ITEM_C.ITEMTYPE  = SENTENCE.ITEMTYPE     " & vbLf & _
                               "   AND SENTENCE.STCCD   = :RESULT               "
                    
                    Set objOraDyna3 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt3), ORADYN_READONLY + ORADYN_NOCACHE)

                    '検索レコードが存在する場合
                    If Not objOraDyna3.EOF Then

                        'オブジェクトの参照設定
                        Set objFields3 = objOraDyna3.Fields
                        Set objResult = objFields3("LONGSTC")

                        vntAResult(j) = objResult.Value & ""
                    Else
                        vntAResult(j) = ""
                    End If
                    
                    
                    strStmt3 = "INSERT INTO FOLLOW_RSL_I (      " & vbLf & _
                               "             RSVNO,             " & vbLf & _
                               "             JUDCLASSCD,        " & vbLf & _
                               "             SEQ,               " & vbLf & _
                               "             ITEMCD,            " & vbLf & _
                               "             SUFFIX,            " & vbLf & _
                               "             RESULT             " & vbLf & _
                               "         ) VALUES (             " & vbLf & _
                               "             :RSVNO,            " & vbLf & _
                               "             :JUDCLASSCD,       " & vbLf & _
                               "             :SEQ,              " & vbLf & _
                               "             :ITEMCD,           " & vbLf & _
                               "             :SUFFIX,           " & vbLf & _
                               "             :RESULT            " & vbLf & _
                               "         )                      "
        
                    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt3)
                    lngAfterCnt = lngAfterCnt + 1
                End If
                j = j + 1
            Loop
            ''###疾患（診断名）情報はすべて削除してから挿入 End   #############################################

            ''###フォローアップ情報の更新日、更新者変更 Start #################################################
            strStmt4 = "UPDATE FOLLOW_INFO SET                    " & vbLf & _
                      "       UPDDATE       = SYSDATE,           " & vbLf & _
                      "       UPDUSER       = :UPDUSER           " & vbLf & _
                      " WHERE RSVNO         = :RSVNO             " & vbLf & _
                      "   AND JUDCLASSCD    = :JUDCLASSCD        "
        
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt4)
            ''###フォローアップ情報の更新日、更新者変更 End   #################################################


            '''二次検査診断名（疾患）変更履歴（変更前） Start
            strItemName = "診断名（疾患）"
            k = 0
            If lngBeforeCnt > 0 Then
                Do Until k > UBound(vntBItemCd)
                    Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, vntBItemCd(k), vntBSuffix(k), vntBResult(k), "")
                    k = k + 1
                Loop
            End If
            '''二次検査診断名（疾患）変更履歴（変更前） End
            
            ''### 変更LOG出力 Start #########################################################################
            strItemName = "二次検査年月日"
            If strBSecCslDate <> strSecCslDate Then
                Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecCslDate, strSecCslDate)
            End If
            strItemName = "検査方法"
            If strBTestUS <> strTestUS Then
                If strBTestUS <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "US", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "US")
                End If
            End If
            If strBTestCT <> strTestCT Then
                If strBTestCT <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "CT", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "CT")
                End If
            End If
            If strBTestMRI <> strTestMRI Then
                If strBTestMRI <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "MRI", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "MRI")
                End If
            End If
            If strBTestBF <> strTestBF Then
                If strBTestBF <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "BF", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "BF")
                End If
            End If
            If strBTestGF <> strTestGF Then
                If strBTestGF <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "GF", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "GF")
                End If
            End If
            If strBTestCF <> strTestCF Then
                If strBTestCF <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "CF", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "CF")
                End If
            End If
            If strBTestEM <> strTestEM Then
                If strBTestEM <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "注腸", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "注腸")
                End If
            End If
            If strBTestTM <> strTestTM Then
                If strBTestTM <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "腫瘍マーカー", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "腫瘍マーカー")
                End If
            End If
            If strBTestEtc <> strTestEtc Then
                If strBTestEtc <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "その他", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "その他")
                End If
            End If
            If strBTestRemark <> strTestRemark Then
                If strBTestRemark <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strTestRemark, "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strTestRemark)
                End If
            End If


            If strBTestRefer <> strTestRefer Then
                If strBTestRefer <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "リファー", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "リファー")
                End If
            End If
            If strBTestReferText <> strTestReferText Then
                If strBTestReferText <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBTestReferText, strTestReferText)
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strTestReferText)
                End If
            End If



            '''二次検査結果区分変更履歴登録 Start
            strItemName = "二次検査結果"
            strBResultDivName = ""
            strResultDivName = ""
            If strBResultDiv <> strResultDiv Then
                Select Case strBResultDiv
                   Case 1
                        strBResultDivName = "異常なし"
                   Case 2
                        strBResultDivName = "不明"
                   Case 3
                        strBResultDivName = "所見あり"
                End Select
                Select Case strResultDiv
                   Case 1
                        strResultDivName = "異常なし"
                   Case 2
                        strResultDivName = "不明"
                   Case 3
                        strResultDivName = "所見あり"
                End Select
                Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBResultDivName, strResultDivName)
            End If
            '''二次検査結果区分登録履歴 End

            '''疾患その他変更履歴登録
            strItemName = "その他疾患"
            If strBDisRemark <> strDisRemark Then
                Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBDisRemark, strDisRemark)
            End If

            '''二次検査方針変更履歴登録 Start
            strItemName = "方針（治療なし）"
            If strBPolWithout <> strPolWithout Then
                If strBPolWithout <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "処置不要", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "処置不要")
                End If
            End If
            If strBPolFollowup <> strPolFollowup Then
                If strPolFollowup <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "経過観察", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "経過観察")
                End If
            End If
            If strBPolMonth <> strPolMonth Then
                Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBPolMonth, strPolMonth)
            End If
            If strBPolReExam <> strPolReExam Then
                If strBPolReExam <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "１年後健診", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "１年後健診")
                End If
            End If
            If strBPolDiagSt <> strPolDiagSt Then
                If strBPolDiagSt <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "本院紹介（精査）", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "本院紹介（精査）")
                End If
            End If
            If strBPolDiag <> strPolDiag Then
                If strBPolDiag <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "他院紹介（精査）", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "他院紹介（精査）")
                End If
            End If
            If strBPolEtc1 <> strPolEtc1 Then
                If strBPolEtc1 <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "その他（治療なし）", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "その他（治療なし）")
                End If
            End If
            If strBPolRemark1 <> strPolRemark1 Then
                Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBPolRemark1, strPolRemark1)
            End If

            strItemName = "方針（治療あり）"
            If strBPolSugery <> strPolSugery Then
                If strBPolSugery <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "外科治療", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "外科治療")
                End If
            End If
            If strBPolEndoscope <> strPolEndoscope Then
                If strBPolEndoscope <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "内視鏡的治療", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "内視鏡的治療")
                End If
            End If
            If strBPolChemical <> strPolChemical Then
                If strBPolChemical <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "化学療法", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "化学療法")
                End If
            End If
            If strBPolRadiation <> strPolRadiation Then
                If strBPolRadiation <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "放射線治療", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "放射線治療")
                End If
            End If
            If strBPolReferSt <> strPolReferSt Then
                If strBPolReferSt <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "本院紹介（治療）", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "本院紹介（治療）")
                End If
            End If
            If strBPolRefer <> strPolRefer Then
                If strBPolRefer <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "他院紹介（治療）", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "他院紹介（治療）")
                End If
            End If
            If strBPolEtc2 <> strPolEtc2 Then
                If strBPolEtc2 <> "" Then
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "その他（治療あり）", "")
                Else
                    Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "その他（治療あり）")
                End If
            End If
            If strBPolRemark2 <> strPolRemark2 Then
                Ret = InsertFollow_Log(strUpdUser, 2, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBPolRemark2, strPolRemark2)
            End If
            '''二次検査方針変更履歴登録 End
            
            '''二次検査診断名（疾患）変更履歴（変更後） Start
            strItemName = "診断名（疾患）"
            k = 0
            If lngAfterCnt > 0 Then
                Do Until k > UBound(vntAItemCd)
                    If vntAResult(k) <> "" Then
                        Ret = InsertFollow_Log(strUpdUser, 2, "I", lngRsvNo, lngJudClassCd, strItemName, vntAItemCd(k), vntASuffix(k), "", vntAResult(k))
                    End If
                    k = k + 1
                Loop
            End If
            '''二次検査診断名（疾患）変更履歴（変更後） End
            
            ''### 変更LOG出力 End   #########################################################################


    End If


    UpdateFollow_Rsl = True

    Set objSecCslDate = Nothing
    Set objTestUS = Nothing
    Set objTestCT = Nothing
    Set objTestMRI = Nothing
    Set objTestBF = Nothing
    Set objTestGF = Nothing
    Set objTestCF = Nothing
    Set objTestEM = Nothing
    Set objTestTM = Nothing
    Set objTestEtc = Nothing
    Set objTestRemark = Nothing
    Set objTestRefer = Nothing
    Set objTestReferText = Nothing
    Set objResultDiv = Nothing
    Set objDisRemark = Nothing
    Set objPolWithout = Nothing
    Set objPolFollowup = Nothing
    Set objPolMonth = Nothing
    Set objPolReExam = Nothing
    Set objPolDiagSt = Nothing
    Set objPolDiag = Nothing
    Set objPolEtc1 = Nothing
    Set objPolRemark1 = Nothing
    Set objPolSugery = Nothing
    Set objPolEndoscope = Nothing
    Set objPolChemical = Nothing
    Set objPolRadiation = Nothing
    Set objPolReferSt = Nothing
    Set objPolRefer = Nothing
    Set objPolEtc2 = Nothing
    Set objPolRemark2 = Nothing
    
    Set objItemCd = Nothing
    Set objSuffix = Nothing
    Set objResult = Nothing
    
    Set objFields = Nothing
    Set objFields2 = Nothing
    Set objFields3 = Nothing
    Set objOraDyna = Nothing
    Set objOraDyna2 = Nothing
    Set objOraDyna3 = Nothing
    Set objOraDyna4 = Nothing
    

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    UpdateFollow_Rsl = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    UpdateFollow_Rsl = False

    'イベントログ書き込み
    WriteErrorLog "Follow.UpdateFollow_Rsl"

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
' 機能　　 : 指定予約番号のフォロー対象管理情報を削除する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     vntJudClassCd     判定分類コード
' 　　　　   (In)     vntSeq            削除対象検査コード
'
' 戻り値　 : True   削除成功
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteFollow_Rsl(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, ByVal lngSeq As Long, ByVal strUpdUser As String) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraDyna2             As OraDynaset       'ダイナセット２
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objFields2              As OraFields        'フィールドオブジェクト２
    
    Dim strStmt                 As String           'SQLステートメント
    Dim strStmt2                As String           'SQLステートメント２
    Dim strStmt3                As String           'SQLステートメント３

    Dim objSecCslDate           As OraField         '
    Dim objTestUS               As OraField         '
    Dim objTestCT               As OraField         '
    Dim objTestMRI              As OraField         '
    Dim objTestBF               As OraField         '
    Dim objTestGF               As OraField         '
    Dim objTestCF               As OraField         '
    Dim objTestEM               As OraField         '
    Dim objTestTM               As OraField         '
    Dim objTestEtc              As OraField         '
    Dim objTestRemark           As OraField         '
    '2009/12/28 Add by yhlee ----------------------------------
    Dim objTestRefer            As OraField         'リファー
    Dim objTestReferText        As OraField         'リファー科
    '2009/12/28 (End) -----------------------------------------
    Dim objResultDiv            As OraField         '
    Dim objDisRemark            As OraField         '
    Dim objPolWithout           As OraField         '
    Dim objPolFollowup          As OraField         '
    Dim objPolMonth             As OraField         '
    Dim objPolReExam            As OraField         '
    Dim objPolDiagSt            As OraField         '
    Dim objPolDiag              As OraField         '
    Dim objPolEtc1              As OraField         '
    Dim objPolRemark1           As OraField         '
    Dim objPolSugery            As OraField         '
    Dim objPolEndoscope         As OraField         '
    Dim objPolChemical          As OraField         '
    Dim objPolRadiation         As OraField         '
    Dim objPolReferSt           As OraField         '
    Dim objPolRefer             As OraField         '
    Dim objPolEtc2              As OraField         '
    Dim objPolRemark2           As OraField         '
    Dim objItemCd               As OraField         '項目コード
    Dim objSuffix               As OraField         '文章コード
    Dim objResult               As OraField         '略称

    Dim strBSecCslDate          As String           '
    Dim strBTestUS              As String           '
    Dim strBTestCT              As String           '
    Dim strBTestMRI             As String           '
    Dim strBTestBF              As String           '
    Dim strBTestGF              As String           '
    Dim strBTestCF              As String           '
    Dim strBTestEM              As String           '
    Dim strBTestTM              As String           '
    Dim strBTestEtc             As String           '
    Dim strBTestRemark          As String           '
    '2009/12/28 Add by yhlee ----------------------------------
    Dim strBTestRefer           As String           '
    Dim strBTestReferText       As String           '
    '2009/12/28 Add by (End) ----------------------------------
    
    Dim strBResultDiv           As String           '
    Dim strBResultDivName       As String           '
    Dim strBDisRemark           As String           '
    Dim strBPolWithout          As String           '
    Dim strBPolFollowup         As String           '
    Dim strBPolMonth            As String           '
    Dim strBPolReExam           As String           '
    Dim strBPolDiagSt           As String           '
    Dim strBPolDiag             As String           '
    Dim strBPolEtc1             As String           '
    Dim strBPolRemark1          As String           '
    Dim strBPolSugery           As String           '
    Dim strBPolEndoscope        As String           '
    Dim strBPolChemical         As String           '
    Dim strBPolRadiation        As String           '
    Dim strBPolReferSt          As String           '
    Dim strBPolRefer            As String           '
    Dim strBPolEtc2             As String           '
    Dim strBPolRemark2          As String           '
    
    Dim strItemName             As String           '変更履歴項目名
    Dim strResultDivName        As String
    
    Dim vntBItemCd()            As Variant          '変更前検査項目
    Dim vntBSuffix()            As Variant          '変更前サフィックス
    Dim vntBResult()            As Variant          '変更前結果（疾患）


    Dim i                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim j                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim k                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim lngCount                As Long             'ｲﾝﾃﾞｯｸｽ
    Dim Ret                     As Boolean          '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    DeleteFollow_Rsl = True

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2


    '指定予約番号・検査項目（判定分類）のフォロー情報を取得する
    strStmt = ""
'    strStmt = "SELECT FOLLOW_RSL.SECCSLDATE,      FOLLOW_RSL.TESTUS,            " & vbLf & _
'              "       FOLLOW_RSL.TESTCT,          FOLLOW_RSL.TESTMRI,           " & vbLf & _
'              "       FOLLOW_RSL.TESTBF,          FOLLOW_RSL.TESTGF,            " & vbLf & _
'              "       FOLLOW_RSL.TESTCF,          FOLLOW_RSL.TESTEM,            " & vbLf & _
'              "       FOLLOW_RSL.TESTTM,          FOLLOW_RSL.TESTETC,           " & vbLf & _
'              "       FOLLOW_RSL.TESTREMARK,      FOLLOW_RSL.RESULTDIV,         " & vbLf & _
'              "       FOLLOW_RSL.DISREMARK,       FOLLOW_RSL.POLWITHOUT,        " & vbLf & _
'              "       FOLLOW_RSL.POLFOLLOWUP,     FOLLOW_RSL.POLMONTH,          " & vbLf & _
'              "       FOLLOW_RSL.POLREEXAM,       FOLLOW_RSL.POLDIAG,           " & vbLf & _
'              "       FOLLOW_RSL.POLETC1,         FOLLOW_RSL.POLREMARK1,        " & vbLf & _
'              "       FOLLOW_RSL.POLSUGERY,       FOLLOW_RSL.POLENDOSCOPE,      " & vbLf & _
'              "       FOLLOW_RSL.POLCHEMICAL,     FOLLOW_RSL.POLRADIATION,      " & vbLf & _
'              "       FOLLOW_RSL.POLREFER,        FOLLOW_RSL.POLETC2,           " & vbLf & _
'              "       FOLLOW_RSL.POLREMARK2                                     " & vbLf & _
'              "  FROM FOLLOW_RSL                                                " & vbLf & _
'              " WHERE FOLLOW_RSL.RSVNO      = :RSVNO                            " & vbLf & _
'              "   AND FOLLOW_RSL.JUDCLASSCD = :JUDCLASSCD                       " & vbLf & _
'              "   AND FOLLOW_RSL.SEQ        = :SEQ                              " & vbLf & _
'              "   FOR UPDATE                                                    "
    
    strStmt = "SELECT FOLLOW_RSL.SECCSLDATE,      FOLLOW_RSL.TESTUS,            " & vbLf & _
              "       FOLLOW_RSL.TESTCT,          FOLLOW_RSL.TESTMRI,           " & vbLf & _
              "       FOLLOW_RSL.TESTBF,          FOLLOW_RSL.TESTGF,            " & vbLf & _
              "       FOLLOW_RSL.TESTCF,          FOLLOW_RSL.TESTEM,            " & vbLf & _
              "       FOLLOW_RSL.TESTTM,          FOLLOW_RSL.TESTETC,           " & vbLf & _
              "       FOLLOW_RSL.TESTREMARK,      FOLLOW_RSL.RESULTDIV,         " & vbLf & _
              "       FOLLOW_RSL.DISREMARK,       FOLLOW_RSL.POLWITHOUT,        " & vbLf & _
              "       FOLLOW_RSL.POLFOLLOWUP,     FOLLOW_RSL.POLMONTH,          " & vbLf & _
              "       FOLLOW_RSL.POLREEXAM,       FOLLOW_RSL.POLDIAGST,     FOLLOW_RSL.POLDIAG,        " & vbLf & _
              "       FOLLOW_RSL.POLETC1,         FOLLOW_RSL.POLREMARK1,        " & vbLf & _
              "       FOLLOW_RSL.POLSUGERY,       FOLLOW_RSL.POLENDOSCOPE,      " & vbLf & _
              "       FOLLOW_RSL.POLCHEMICAL,     FOLLOW_RSL.POLRADIATION,      " & vbLf & _
              "       FOLLOW_RSL.POLREFERST,      FOLLOW_RSL.POLREFER,      FOLLOW_RSL.POLETC2,           " & vbLf & _
              "       FOLLOW_RSL.TESTREFER,       FOLLOW_RSL.TESTREFERTEXT,     " & vbLf & _
              "       FOLLOW_RSL.POLREMARK2                                     " & vbLf & _
              "  FROM FOLLOW_RSL                                                " & vbLf & _
              " WHERE FOLLOW_RSL.RSVNO      = :RSVNO                            " & vbLf & _
              "   AND FOLLOW_RSL.JUDCLASSCD = :JUDCLASSCD                       " & vbLf & _
              "   AND FOLLOW_RSL.SEQ        = :SEQ                              " & vbLf & _
              "   FOR UPDATE                                                    "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objSecCslDate = objFields("SECCSLDATE")
        Set objTestUS = objFields("TESTUS")
        Set objTestCT = objFields("TESTCT")
        Set objTestMRI = objFields("TESTMRI")
        Set objTestBF = objFields("TESTBF")
        Set objTestGF = objFields("TESTGF")
        Set objTestCF = objFields("TESTCF")
        Set objTestEM = objFields("TESTEM")
        Set objTestTM = objFields("TESTTM")
        Set objTestEtc = objFields("TESTETC")
        Set objTestRemark = objFields("TESTREMARK")
        
        Set objTestRefer = objFields("TESTREFER")
        Set objTestReferText = objFields("TESTREFERTEXT")
        
        Set objResultDiv = objFields("RESULTDIV")
        Set objDisRemark = objFields("DISREMARK")
        Set objPolWithout = objFields("POLWITHOUT")
        Set objPolFollowup = objFields("POLFOLLOWUP")
        Set objPolMonth = objFields("POLMONTH")
        Set objPolReExam = objFields("POLREEXAM")
        Set objPolDiagSt = objFields("POLDIAGST")
        Set objPolDiag = objFields("POLDIAG")
        Set objPolEtc1 = objFields("POLETC1")
        Set objPolRemark1 = objFields("POLREMARK1")
        Set objPolSugery = objFields("POLSUGERY")
        Set objPolEndoscope = objFields("POLENDOSCOPE")
        Set objPolChemical = objFields("POLCHEMICAL")
        Set objPolRadiation = objFields("POLRADIATION")
        Set objPolReferSt = objFields("POLREFERST")
        Set objPolRefer = objFields("POLREFER")
        Set objPolEtc2 = objFields("POLETC2")
        Set objPolRemark2 = objFields("POLREMARK2")

        strBSecCslDate = IIf(IsNull(objSecCslDate.Value), "", objSecCslDate.Value)
        strBTestUS = IIf(IsNull(objTestUS.Value), "", objTestUS.Value)
        strBTestCT = IIf(IsNull(objTestCT.Value), "", objTestCT.Value)
        strBTestMRI = IIf(IsNull(objTestMRI.Value), "", objTestMRI.Value)
        strBTestBF = IIf(IsNull(objTestBF.Value), "", objTestBF.Value)
        strBTestGF = IIf(IsNull(objTestGF.Value), "", objTestGF.Value)
        strBTestCF = IIf(IsNull(objTestCF.Value), "", objTestCF.Value)
        strBTestEM = IIf(IsNull(objTestEM.Value), "", objTestEM.Value)
        strBTestTM = IIf(IsNull(objTestTM.Value), "", objTestTM.Value)
        strBTestEtc = IIf(IsNull(objTestEtc.Value), "", objTestEtc.Value)
        strBTestRemark = IIf(IsNull(objTestRemark.Value), "", objTestRemark.Value)
        
        strBTestRefer = IIf(IsNull(objTestRefer.Value), "", objTestRefer.Value)
        strBTestReferText = IIf(IsNull(objTestReferText.Value), "", objTestReferText.Value)
        
        strBResultDiv = IIf(IsNull(objResultDiv.Value), "", objResultDiv.Value)
        strBDisRemark = IIf(IsNull(objDisRemark.Value), "", objDisRemark.Value)
        strBPolWithout = IIf(IsNull(objPolWithout.Value), "", objPolWithout.Value)
        strBPolFollowup = IIf(IsNull(objPolFollowup.Value), "", objPolFollowup.Value)
        strBPolMonth = IIf(IsNull(objPolMonth.Value), "", objPolMonth.Value)
        strBPolReExam = IIf(IsNull(objPolReExam.Value), "", objPolReExam.Value)
        strBPolDiagSt = IIf(IsNull(objPolDiagSt.Value), "", objPolDiagSt.Value)
        strBPolDiag = IIf(IsNull(objPolDiag.Value), "", objPolDiag.Value)
        strBPolEtc1 = IIf(IsNull(objPolEtc1.Value), "", objPolEtc1.Value)
        strBPolRemark1 = IIf(IsNull(objPolRemark1.Value), "", objPolRemark1.Value)
        strBPolSugery = IIf(IsNull(objPolSugery.Value), "", objPolSugery.Value)
        strBPolEndoscope = IIf(IsNull(objPolEndoscope.Value), "", objPolEndoscope.Value)
        strBPolChemical = IIf(IsNull(objPolChemical.Value), "", objPolChemical.Value)
        strBPolRadiation = IIf(IsNull(objPolRadiation.Value), "", objPolRadiation.Value)
        strBPolReferSt = IIf(IsNull(objPolReferSt.Value), "", objPolReferSt.Value)
        strBPolRefer = IIf(IsNull(objPolRefer.Value), "", objPolRefer.Value)
        strBPolEtc2 = IIf(IsNull(objPolEtc2.Value), "", objPolEtc2.Value)
        strBPolRemark2 = IIf(IsNull(objPolRemark2.Value), "", objPolRemark2.Value)
    
    
        ''###疾患（診断名）情報削除前変更履歴登録のため結果取得 Start ########################################
        strStmt2 = "SELECT LAST.RSVNO           AS RSVNO                        " & vbLf & _
                   "      ,LAST.JUDCLASSCD      AS JUDCLASSCD                   " & vbLf & _
                   "      ,LAST.ITEMCD          AS ITEMCD                       " & vbLf & _
                   "      ,LAST.SUFFIX          AS SUFFIX                       " & vbLf & _
                   "      ,LAST.ITEMNAME        AS ITEMCDNAME                   " & vbLf & _
                   "      ,SENTENCE.LONGSTC     AS LONGSTC                      " & vbLf & _
                   "  FROM (                                                    " & vbLf & _
                   "        SELECT FOLLOW_RSL_I.RSVNO       AS RSVNO            " & vbLf & _
                   "              ,FOLLOW_RSL_I.JUDCLASSCD  AS JUDCLASSCD       " & vbLf & _
                   "              ,FOLLOW_RSL_I.ITEMCD      AS ITEMCD           " & vbLf & _
                   "              ,FOLLOW_RSL_I.SUFFIX      AS SUFFIX           " & vbLf & _
                   "              ,ITEM_C.ITEMTYPE          AS ITEMTYPE         " & vbLf & _
                   "              ,ITEM_C.STCITEMCD         AS STCITEMCD        " & vbLf & _
                   "              ,FOLLOW_RSL_I.RESULT      AS RESULT           " & vbLf & _
                   "              ,ITEM_C.ITEMNAME          AS ITEMNAME         "
        strStmt2 = strStmt2 & vbLf & _
                   "          FROM FOLLOW_RSL_I                                 " & vbLf & _
                   "              ,ITEM_C                                       " & vbLf & _
                   "         WHERE FOLLOW_RSL_I.RSVNO       = :RSVNO            " & vbLf & _
                   "           AND FOLLOW_RSL_I.JUDCLASSCD  = :JUDCLASSCD       " & vbLf & _
                   "           AND FOLLOW_RSL_I.SEQ         = :SEQ              " & vbLf & _
                   "           AND FOLLOW_RSL_I.ITEMCD = ITEM_C.ITEMCD          " & vbLf & _
                   "           AND FOLLOW_RSL_I.SUFFIX = ITEM_C.SUFFIX          " & vbLf & _
                   "       ) LAST                                               " & vbLf & _
                   "      ,SENTENCE                                             " & vbLf & _
                   " WHERE LAST.STCITEMCD = SENTENCE.ITEMCD(+)                  " & vbLf & _
                   "   AND LAST.ITEMTYPE  = SENTENCE.ITEMTYPE(+)                " & vbLf & _
                   "   AND LAST.RESULT    = SENTENCE.STCCD(+)                   "
        
        
        Set objOraDyna2 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt2), ORADYN_READONLY + ORADYN_NOCACHE)

        '検索レコードが存在する場合
        If Not objOraDyna2.EOF Then

            'オブジェクトの参照設定
            Set objFields2 = objOraDyna2.Fields
            Set objItemCd = objFields2("ITEMCD")
            Set objSuffix = objFields2("SUFFIX")
            Set objResult = objFields2("LONGSTC")

            '配列形式で格納する
            lngCount = 0
            Do Until objOraDyna2.EOF
                ReDim Preserve vntBItemCd(lngCount)
                ReDim Preserve vntBSuffix(lngCount)
                ReDim Preserve vntBResult(lngCount)

                vntBItemCd(lngCount) = objItemCd.Value & ""
                vntBSuffix(lngCount) = objSuffix.Value & ""
                vntBResult(lngCount) = objResult.Value & ""

                lngCount = lngCount + 1
                objOraDyna2.MoveNext
            Loop

        End If
    
    End If
    
    Set objSecCslDate = Nothing
    Set objTestUS = Nothing
    Set objTestCT = Nothing
    Set objTestMRI = Nothing
    Set objTestBF = Nothing
    Set objTestGF = Nothing
    Set objTestCF = Nothing
    Set objTestEM = Nothing
    Set objTestTM = Nothing
    Set objTestEtc = Nothing
    Set objTestRemark = Nothing
    
    Set objTestRefer = Nothing
    Set objTestReferText = Nothing
    
    Set objResultDiv = Nothing
    Set objDisRemark = Nothing
    Set objPolWithout = Nothing
    Set objPolFollowup = Nothing
    Set objPolMonth = Nothing
    Set objPolReExam = Nothing
    Set objPolDiagSt = Nothing
    Set objPolDiag = Nothing
    Set objPolEtc1 = Nothing
    Set objPolRemark1 = Nothing
    Set objPolSugery = Nothing
    Set objPolEndoscope = Nothing
    Set objPolChemical = Nothing
    Set objPolRadiation = Nothing
    Set objPolRefer = Nothing
    Set objPolReferSt = Nothing
    Set objPolEtc2 = Nothing
    Set objPolRemark2 = Nothing
    
    Set objItemCd = Nothing
    Set objSuffix = Nothing
    Set objResult = Nothing
    
    Set objFields = Nothing
    Set objFields2 = Nothing
    Set objOraDyna = Nothing
    Set objOraDyna2 = Nothing
    
    
    '二次検査結果別疾患情報削除
    strStmt = "DELETE FROM FOLLOW_RSL_I            " & vbLf & _
              " WHERE RSVNO      = :RSVNO          " & vbLf & _
              "   AND JUDCLASSCD = :JUDCLASSCD     " & vbLf & _
              "   AND SEQ        = :SEQ            "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '二次検査結果情報削除
    strStmt2 = "DELETE FROM FOLLOW_RSL              " & vbLf & _
              " WHERE RSVNO      = :RSVNO          " & vbLf & _
              "   AND JUDCLASSCD = :JUDCLASSCD     " & vbLf & _
              "   AND SEQ        = :SEQ            "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt2)

    'フォローアップ情報の更新日、更新者変更
    strStmt3 = "UPDATE FOLLOW_INFO SET                    " & vbLf & _
              "       UPDDATE       = SYSDATE,           " & vbLf & _
              "       UPDUSER       = :UPDUSER           " & vbLf & _
              " WHERE RSVNO         = :RSVNO             " & vbLf & _
              "   AND JUDCLASSCD    = :JUDCLASSCD        "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt3)
    
    
    ''### 新規登録の場合はLOG出力 Start ##############################################################

    strItemName = "二次検査年月日"
    If strBSecCslDate <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecCslDate, "")
    End If
    '''検査方法登録履歴 Start
    strItemName = "検査方法"
    If strBTestUS <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "US", "")
    End If

    If strBTestCT <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "CT", "")
    End If
    If strBTestMRI <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "MRI", "")
    End If
    If strBTestBF <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "BF", "")
    End If
    If strBTestGF <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "GF", "")
    End If
    If strBTestCF <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "CF", "")
    End If
    If strBTestEM <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "注腸", "")
    End If
    If strBTestTM <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "腫瘍マーカー", "")
    End If
    If strBTestEtc <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "その他", "")
    End If
    If strBTestRemark <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBTestRemark, "")
    End If
    
    If strBTestRefer <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "リファー", "")
    End If
    If strBTestReferText <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBTestReferText, "")
    End If
    
    '''検査方法登録履歴 End
    
    '''二次検査結果区分登録履歴 Start
    strItemName = "二次検査結果"
    strResultDivName = ""
    If strBResultDiv <> "" Then
        Select Case strBResultDiv
           Case 1
                strResultDivName = "異常なし"
           Case 2
                strResultDivName = "不明"
           Case 3
                strResultDivName = "所見あり"
        End Select
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strResultDivName, "")
    End If
    '''二次検査結果区分登録履歴 End

    strItemName = "その他疾患"
    If strBDisRemark <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBDisRemark, "")
    End If

    '''二次検査方針登録履歴 Start
    strItemName = "方針（治療なし）"
    If strBPolWithout <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "処置不要", "")
    End If
    If strBPolFollowup <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "経過観察", "")
    End If
    If strBPolMonth <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBPolMonth, "")
    End If
    If strBPolReExam <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "１年後健診", "")
    End If
    If strBPolDiagSt <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "本院紹介（精査）", "")
    End If
    If strBPolDiag <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "他院紹介（精査）", "")
    End If
    If strBPolEtc1 <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "その他（治療なし）", "")
    End If
    If strBPolRemark1 <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBPolRemark1, "")
    End If

    strItemName = "方針（治療あり）"
    If strBPolSugery <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "外科治療", "")
    End If
    If strBPolEndoscope <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "内視鏡的治療", "")
    End If
    If strBPolChemical <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "化学療法", "")
    End If
    If strBPolRadiation <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "放射線治療", "")
    End If
    If strBPolReferSt <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "本院紹介（治療）", "")
    End If
    If strBPolRefer <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "他院紹介（治療）", "")
    End If
    If strBPolEtc2 <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "その他（治療あり）", "")
    End If
    If strBPolRemark2 <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBPolRemark2, "")
    End If
    '''二次検査方針登録履歴 End

    '''二次検査診断名（疾患）登録履歴 Start
    strItemName = "診断名（疾患）"
    k = 0
    If lngCount > 0 Then
        Do Until k > UBound(vntBItemCd)
            If vntBResult(k) <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, vntBItemCd(k), vntBSuffix(k), vntBResult(k), "")
            End If
            k = k + 1
        Loop
    End If
    '''二次検査診断名（疾患）登録履歴 End
    
    ''### 新規登録の場合はLOG出力 End   ##############################################################
    
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    DeleteFollow_Rsl = False

    'イベントログ書き込み
    WriteErrorLog "Follow.DeleteFollow_Rsl"

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
' 機能　　 : 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録・変更
'
' 引数　　 : (In)     vntRsvNo          予約番号
' 　　　　   (In)     vntJudClassCd     検査項目（判定分類）
' 　　　　   (In)     vntSecEquipDiv    二次検査実施区分（医療施設区分）
' 　　　　   (In)     vntJudCd          判定結果
' 　　　　   (In)     strUpdUser        更新者
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function InsertFollow_Info(ByVal vntRsvNo As Variant, ByVal vntJudClassCd As Variant, _
                                  ByVal vntSecEquipDiv As Variant, ByVal vntJudCd As Variant, _
                                  ByVal strUpdUser As String _
                                ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim strStmt2                As String           'SQLステートメント
    Dim strStmt3                As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト

    Dim objRsvNo                As OraField         '予約番号
    Dim objJudClassCd           As OraField         '検査項目（判定分類）
    Dim objSecEquipDiv          As OraField         '二次検査実施区分
    Dim objJudCd                As OraField         '判定コード

    Dim strItemName             As String           '変更履歴項目名
    
    '## 更新前のデータ保存用変数設定
    Dim lngBSecEquipdiv         As Long             '二次検査実施区分
    Dim strBSecEquipDivName     As String           '二次検査実施区分(名称)
    Dim strBJudCd               As String           '判定コード

    '## 更新後のデータ保存用
    Dim strSecEquipDivName      As String           '二次検査実施区分(名称)

    Dim i                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim j                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim k                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim lngCount                As Long             'レコード数
    Dim Ret                     As Boolean          '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    InsertFollow_Info = False

    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SECEQUIPDIV", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号の判定分類(検査項目)別フォロー情報を取得する
    strStmt = "SELECT RSVNO                       " & vbLf & _
              "      ,JUDCLASSCD                  " & vbLf & _
              "      ,SECEQUIPDIV                 " & vbLf & _
              "      ,JUDCD                       " & vbLf & _
              "  FROM FOLLOW_INFO                 " & vbLf & _
              " WHERE RSVNO      = :RSVNO         " & vbLf & _
              "   AND JUDCLASSCD = :JUDCLASSCD    "


    '指定予約番号の判定分類(検査項目)別フォロー情報と判定結果を挿入
    strStmt2 = "INSERT INTO FOLLOW_INFO (          " & vbLf & _
              "             RSVNO,                " & vbLf & _
              "             JUDCLASSCD,           " & vbLf & _
              "             SECEQUIPDIV,          " & vbLf & _
              "             ADDUSER,              " & vbLf & _
              "             UPDUSER,              " & vbLf & _
              "             JUDCD                 " & vbLf & _
              "         ) VALUES (                " & vbLf & _
              "             :RSVNO,               " & vbLf & _
              "             :JUDCLASSCD,          " & vbLf & _
              "             :SECEQUIPDIV,         " & vbLf & _
              "             :UPDUSER,             " & vbLf & _
              "             :UPDUSER,             " & vbLf & _
              "             :JUDCD                " & vbLf & _
              "         )                         "

    '指定予約番号の判定分類(検査項目)別フォロー情報と判定結果を更新
    strStmt3 = "UPDATE FOLLOW_INFO SET                   " & vbLf & _
              "     SECEQUIPDIV     = :SECEQUIPDIV,     " & vbLf & _
              "     JUDCD           = :JUDCD,           " & vbLf & _
              "     UPDUSER         = :UPDUSER          " & vbLf & _
              " WHERE RSVNO         = :RSVNO            " & vbLf & _
              "   AND JUDCLASSCD    = :JUDCLASSCD       "

    '件数ループ
    For i = 0 To UBound(vntRsvNo)
        If vntSecEquipDiv(i) = 0 Or vntSecEquipDiv(i) = 1 Or vntSecEquipDiv(i) = 2 Or vntSecEquipDiv(i) = 3 Or vntSecEquipDiv(i) = 9 Then

            objOraParam("RSVNO").Value = vntRsvNo(i)
            objOraParam("JUDCLASSCD").Value = vntJudClassCd(i)
            objOraParam("SECEQUIPDIV").Value = vntSecEquipDiv(i)
            objOraParam("JUDCD").Value = vntJudCd(i)

            '## 指定予約番号の判定分類別フォロー情報登録有無チェック
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


            If objOraDyna.EOF Then
                'フォロー情報と判定結果を挿入
                mobjOraDb.ExecuteSQL OmitCharSpc(strStmt2)
            
                ''### 挿入の場合はLOG出力 Start ###############################################################################
                strItemName = "二次検査施設区分"
                strBSecEquipDivName = ""
                strSecEquipDivName = ""
                Select Case vntSecEquipDiv(i)
                   Case 0
                        strSecEquipDivName = "二次検査場所未定"
                   Case 1
                        strSecEquipDivName = "当センター"
                   Case 2
                        strSecEquipDivName = "本院"
                   Case 3
                        strSecEquipDivName = "他院"
                   Case 9
                        strSecEquipDivName = "対象外"
                End Select
                Ret = InsertFollow_Log(strUpdUser, 1, "I", vntRsvNo(i), vntJudClassCd(i), strItemName, "", "", strBSecEquipDivName, strSecEquipDivName)
            
                strItemName = "判定分類"
                strBJudCd = ""
                Ret = InsertFollow_Log(strUpdUser, 1, "I", vntRsvNo(i), vntJudClassCd(i), strItemName, "", "", strBJudCd, vntJudCd(i))
                ''### 挿入の場合はLOG出力 End   ###############################################################################
            Else
                '変更ログ記録の為変更前データ取得
                Set objFields = objOraDyna.Fields
                Set objSecEquipDiv = objFields("SECEQUIPDIV")
                Set objJudCd = objFields("JUDCD")
                lngBSecEquipdiv = objSecEquipDiv.Value
                strBJudCd = objJudCd.Value

                'フォロー情報と判定結果を更新
                mobjOraDb.ExecuteSQL OmitCharSpc(strStmt3)

                ''### 更新前と更新後で値が違う場合はLOG出力 Start ##############################################################
                strItemName = "二次検査施設区分"
                strBSecEquipDivName = ""
                strSecEquipDivName = ""
                If lngBSecEquipdiv <> vntSecEquipDiv(i) Then
                    Select Case lngBSecEquipdiv
                       Case 0
                            strBSecEquipDivName = "二次検査場所未定"
                       Case 1
                            strBSecEquipDivName = "当センター"
                       Case 2
                            strBSecEquipDivName = "本院"
                       Case 3
                            strBSecEquipDivName = "他院"
                       Case 9
                            strBSecEquipDivName = "対象外"
                    End Select

                    Select Case vntSecEquipDiv(i)
                       Case 0
                            strSecEquipDivName = "二次検査場所未定"
                       Case 1
                            strSecEquipDivName = "当センター"
                       Case 2
                            strSecEquipDivName = "本院"
                       Case 3
                            strSecEquipDivName = "他院"
                       Case 9
                            strSecEquipDivName = "対象外"
                    End Select
                    Ret = InsertFollow_Log(strUpdUser, 1, "U", vntRsvNo(i), vntJudClassCd(i), strItemName, "", "", strBSecEquipDivName, strSecEquipDivName)
                End If
                ''### 更新前と更新後で値が違う場合はLOG出力 End   ##############################################################
            End If
            objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "JUDCLASSCD", 0, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "SECEQUIPDIV", 0, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "JUDCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
            objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

        End If

    Next i

    InsertFollow_Info = True

    Set objSecEquipDiv = Nothing
    Set objJudCd = Nothing

    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    InsertFollow_Info = False

    'イベントログ書き込み
    WriteErrorLog "Follow.InsertFollow_Info"

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
' 機能　　 : 指定予約番号のフォロー情報を取得する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     lngFollowUpFlg    フォロー対象フラグ
' 　　　　   (In)     lngFollowCardFlg  はがき出力フラグ
' 　　　　   (In)     strUpdUser        更新者
' 　　　　   (Out)    blnFolMode        モード（更新、新規)
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function UpdateFollow_Info(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, _
                                  ByVal strSecEquipDiv As String, ByVal strUpdUser As String, _
                                  ByVal strJudCd As String, ByVal strStatusCd As String, _
                                  ByVal strSecEquipName As String, ByVal strSecEquipCourse As String, ByVal strSecDoctor As String, _
                                  ByVal strSecEquipAddr As String, ByVal strSecEquipTel As String, _
                                  ByVal strSecPlanDate As String, _
                                  ByVal strRsvTestUS As String, ByVal strRsvTestCT As String, _
                                  ByVal strRsvTestMRI As String, ByVal strRsvTestBF As String, _
                                  ByVal strRsvTestGF As String, ByVal strRsvTestCF As String, _
                                  ByVal strRsvTestEM As String, ByVal strRsvTestTM As String, _
                                  ByVal strRsvTestEtc As String, ByVal strRsvTestRemark As String, _
                                  ByVal strRsvTestRefer As String, ByVal strRsvTestReferText As String, _
                                  ByVal strSecRemark As String _
                                 ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objSecEquipDiv          As OraField         '
    Dim objJudCd                As OraField         '
    Dim objStatusCd             As OraField         '
    Dim objSecEquipName         As OraField         '
    Dim objSecEquipCourse       As OraField         '
    Dim objSecDoctor            As OraField         '
    Dim objSecEquipAddr         As OraField         '
    Dim objSecEquipTel          As OraField         '
    Dim objSecPlanDate          As OraField         '
    '2009/12/28 予約検査予約項目追加 by yhlee -----------
    Dim objRsvTestUS            As OraField         '
    Dim objRsvTestCT            As OraField         '
    Dim objRsvTestMRI           As OraField         '
    Dim objRsvTestBF            As OraField         '
    Dim objRsvTestGF            As OraField         '
    Dim objRsvTestCF            As OraField         '
    Dim objRsvTestEM            As OraField         '
    Dim objRsvTestTM            As OraField         '
    Dim objRsvTestEtc           As OraField         '
    Dim objRsvTestRemark        As OraField         '
    Dim objRsvTestRefer         As OraField         '
    Dim objRsvTestReferText     As OraField         '
    '2009/12/28 予約検査予約項目追加 (End) --------------
    
    Dim objSecRemark            As OraField         '
    Dim strItemName             As String           '変更履歴項目名
    Dim strBSecEquipdiv         As String           '
    Dim strBSecEquipDivName     As String           '二次検査実施区分(名称)
    Dim strBJudCd               As String           '
    Dim strBStatusCd            As String           '
    Dim strBStatusName          As String           '
    Dim strBSecEquipName        As String           '
    Dim strBSecEquipCourse      As String           '
    Dim strBSecDoctor           As String           '
    Dim strBSecEquipAddr        As String           '
    Dim strBSecEquipTel         As String           '
    Dim strBSecPlanDate         As String           '
    Dim strBSecRemark           As String           '
    '2009/12/28 二次検査予約項目追加 by yhlee -----------
    Dim strBRsvTestUS              As String           '
    Dim strBRsvTestCT              As String           '
    Dim strBRsvTestMRI             As String           '
    Dim strBRsvTestBF              As String           '
    Dim strBRsvTestGF              As String           '
    Dim strBRsvTestCF              As String           '
    Dim strBRsvTestEM              As String           '
    Dim strBRsvTestTM              As String           '
    Dim strBRsvTestEtc             As String           '
    Dim strBRsvTestRemark          As String           '
    Dim strBRsvTestRefer           As String           '
    Dim strBRsvTestReferText       As String           '
    '2009/12/28 Add by (End) -----------------------
    
    '## 更新後のデータ保存用
    Dim strSecEquipDivName      As String           '二次検査実施区分(名称)
    Dim strStatusName           As String           '二次検査ステータス(名称)
    Dim Ret                     As Boolean          '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    UpdateFollow_Info = False

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SECEQUIPDIV", strSecEquipDiv, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JUDCD", strJudCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STATUSCD", strStatusCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SECEQUIPNAME", strSecEquipName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SECEQUIPCOURSE", strSecEquipCourse, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SECDOCTOR", strSecDoctor, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SECEQUIPADDR", strSecEquipAddr, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SECEQUIPTEL", strSecEquipTel, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SECPLANDATE", IIf(Not IsDate(strSecPlanDate), Null, Format$(strSecPlanDate, "yyyy/mm/dd")), ORAPARM_INPUT, ORATYPE_DATE
    '2009/12/28 予約検査項目追加 by yhlee ----------------------------------
    objOraParam.Add "RSVTESTUS", strRsvTestUS, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTCT", strRsvTestCT, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTMRI", strRsvTestMRI, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTBF", strRsvTestBF, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTGF", strRsvTestGF, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTCF", strRsvTestCF, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTEM", strRsvTestEM, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTTM", strRsvTestTM, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTETC", strRsvTestEtc, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTREMARK", strRsvTestRemark, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVTESTREFER", strRsvTestRefer, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVTESTREFERTEXT", strRsvTestReferText, ORAPARM_INPUT, ORATYPE_VARCHAR2
    '2009/12/28 Add by (End) -------------------------------------------------
    
    objOraParam.Add "SECREMARK", strSecRemark, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号・検査項目（判定分類）のフォロー情報を取得する
    strStmt = ""
    strStmt = "SELECT FOLLOW_INFO.SECEQUIPDIV,                                      " & vbLf & _
              "       FOLLOW_INFO.JUDCD,           FOLLOW_INFO.STATUSCD,            " & vbLf & _
              "       FOLLOW_INFO.SECEQUIPNAME,    FOLLOW_INFO.SECEQUIPCOURSE,      " & vbLf & _
              "       FOLLOW_INFO.SECDOCTOR,                                        " & vbLf & _
              "       FOLLOW_INFO.SECEQUIPADDR,    FOLLOW_INFO.SECEQUIPTEL,         " & vbLf & _
              "       FOLLOW_INFO.SECPLANDATE,     FOLLOW_INFO.SECREMARK,            " & vbLf & _
              "       FOLLOW_INFO.RSVTESTUS,       FOLLOW_INFO.RSVTESTCT,           " & vbLf & _
              "       FOLLOW_INFO.RSVTESTMRI,      FOLLOW_INFO.RSVTESTBF,           " & vbLf & _
              "       FOLLOW_INFO.RSVTESTGF,       FOLLOW_INFO.RSVTESTCF,           " & vbLf & _
              "       FOLLOW_INFO.RSVTESTEM,       FOLLOW_INFO.RSVTESTTM,           " & vbLf & _
              "       FOLLOW_INFO.RSVTESTETC,      FOLLOW_INFO.RSVTESTREMARK,       " & vbLf & _
              "       FOLLOW_INFO.RSVTESTREFER,    FOLLOW_INFO.RSVTESTREFERTEXT     " & vbLf & _
              "  FROM FOLLOW_INFO                                                   " & vbLf & _
              " WHERE FOLLOW_INFO.RSVNO      = :RSVNO                               " & vbLf & _
              "   AND FOLLOW_INFO.JUDCLASSCD = :JUDCLASSCD                          "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    If objOraDyna.EOF Then
        strStmt = "INSERT INTO FOLLOW_INFO (        " & vbLf & _
                  "             RSVNO,              " & vbLf & _
                  "             JUDCLASSCD,         " & vbLf & _
                  "             SECEQUIPDIV,        " & vbLf & _
                  "             ADDDATE,            " & vbLf & _
                  "             ADDUSER,            " & vbLf & _
                  "             UPDDATE,            " & vbLf & _
                  "             UPDUSER,            " & vbLf & _
                  "             JUDCD,              " & vbLf & _
                  "             STATUSCD,           " & vbLf & _
                  "             SECEQUIPNAME,       " & vbLf & _
                  "             SECEQUIPCOURSE,     " & vbLf & _
                  "             SECDOCTOR,          " & vbLf & _
                  "             SECEQUIPADDR,       " & vbLf & _
                  "             SECEQUIPTEL,        " & vbLf & _
                  "             SECPLANDATE,        "

        strStmt = strStmt & vbLf & _
                  "             RSVTESTUS,             " & vbLf & _
                  "             RSVTESTCT,             " & vbLf & _
                  "             RSVTESTMRI,            " & vbLf & _
                  "             RSVTESTBF,             " & vbLf & _
                  "             RSVTESTGF,             " & vbLf & _
                  "             RSVTESTCF,             " & vbLf & _
                  "             RSVTESTEM,             " & vbLf & _
                  "             RSVTESTTM,             " & vbLf & _
                  "             RSVTESTETC,            " & vbLf & _
                  "             RSVTESTREMARK,         " & vbLf & _
                  "             RSVTESTREFER,          " & vbLf & _
                  "             RSVTESTREFERTEXT,      " & vbLf & _
                  "             SECREMARK              "
                  
        strStmt = strStmt & vbLf & _
                  "         ) VALUES (                 " & vbLf & _
                  "             :RSVNO,                " & vbLf & _
                  "             :JUDCLASSCD,           " & vbLf & _
                  "             :SECEQUIPDIV,          " & vbLf & _
                  "             SYSDATE,               " & vbLf & _
                  "             :UPDUSER,              " & vbLf & _
                  "             SYSDATE,               " & vbLf & _
                  "             :UPDUSER,              " & vbLf & _
                  "             :JUDCD,                " & vbLf & _
                  "             :STATUSCD,             " & vbLf & _
                  "             :SECEQUIPNAME,         " & vbLf & _
                  "             :SECEQUIPCOURSE,       " & vbLf & _
                  "             :SECDOCTOR,            " & vbLf & _
                  "             :SECEQUIPADDR,         " & vbLf & _
                  "             :SECEQUIPTEL,          " & vbLf & _
                  "             :SECPLANDATE,          "

        strStmt = strStmt & vbLf & _
                  "             :RSVTESTUS,             " & vbLf & _
                  "             :RSVTESTCT,             " & vbLf & _
                  "             :RSVTESTMRI,            " & vbLf & _
                  "             :RSVTESTBF,             " & vbLf & _
                  "             :RSVTESTGF,             " & vbLf & _
                  "             :RSVTESTCF,             " & vbLf & _
                  "             :RSVTESTEM,             " & vbLf & _
                  "             :RSVTESTTM,             " & vbLf & _
                  "             :RSVTESTETC,            " & vbLf & _
                  "             :RSVTESTREMARK,         " & vbLf & _
                  "             :RSVTESTREFER,          " & vbLf & _
                  "             :RSVTESTREFERTEXT,      " & vbLf & _
                  "             :SECREMARK              " & vbLf & _
                  "         )                           "

        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    Else
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSecEquipDiv = objFields("SECEQUIPDIV")
        Set objJudCd = objFields("JUDCD")
        Set objStatusCd = objFields("STATUSCD")
        Set objSecEquipName = objFields("SECEQUIPNAME")
        Set objSecEquipCourse = objFields("SECEQUIPCOURSE")
        Set objSecDoctor = objFields("SECDOCTOR")
        Set objSecEquipAddr = objFields("SECEQUIPADDR")
        Set objSecEquipTel = objFields("SECEQUIPTEL")
        Set objSecPlanDate = objFields("SECPLANDATE")
        
        '2009/12/28 二次検査予約項目追加 by yhlee -----------
        Set objRsvTestUS = objFields("RSVTESTUS")
        Set objRsvTestCT = objFields("RSVTESTCT")
        Set objRsvTestMRI = objFields("RSVTESTMRI")
        Set objRsvTestBF = objFields("RSVTESTBF")
        Set objRsvTestGF = objFields("RSVTESTGF")
        Set objRsvTestCF = objFields("RSVTESTCF")
        Set objRsvTestEM = objFields("RSVTESTEM")
        Set objRsvTestTM = objFields("RSVTESTTM")
        Set objRsvTestEtc = objFields("RSVTESTETC")
        Set objRsvTestRemark = objFields("RSVTESTREMARK")
        Set objRsvTestRefer = objFields("RSVTESTREFER")
        Set objRsvTestReferText = objFields("RSVTESTREFERTEXT")
        '2009/12/28 (End)----------------------------------
        Set objSecRemark = objFields("SECREMARK")

        strBSecEquipdiv = objSecEquipDiv.Value
        strBJudCd = IIf(IsNull(objJudCd.Value), "", objJudCd.Value)
        strBStatusCd = IIf(IsNull(objStatusCd.Value), "", objStatusCd.Value)
        strBSecEquipName = IIf(IsNull(objSecEquipName.Value), "", objSecEquipName.Value)
        strBSecEquipCourse = IIf(IsNull(objSecEquipCourse.Value), "", objSecEquipCourse.Value)
        strBSecDoctor = IIf(IsNull(objSecDoctor.Value), "", objSecDoctor.Value)
        strBSecEquipAddr = IIf(IsNull(objSecEquipAddr.Value), "", objSecEquipAddr.Value)
        strBSecEquipTel = IIf(IsNull(objSecEquipTel.Value), "", objSecEquipTel.Value)
        strBSecPlanDate = IIf(IsNull(objSecPlanDate.Value), "", objSecPlanDate.Value)
        strBSecRemark = IIf(IsNull(objSecRemark.Value), "", objSecRemark.Value)
        
        strBRsvTestUS = IIf(IsNull(objRsvTestUS.Value), "", objRsvTestUS.Value)
        strBRsvTestCT = IIf(IsNull(objRsvTestCT.Value), "", objRsvTestCT.Value)
        strBRsvTestMRI = IIf(IsNull(objRsvTestMRI.Value), "", objRsvTestMRI.Value)
        strBRsvTestBF = IIf(IsNull(objRsvTestBF.Value), "", objRsvTestBF.Value)
        strBRsvTestGF = IIf(IsNull(objRsvTestGF.Value), "", objRsvTestGF.Value)
        strBRsvTestCF = IIf(IsNull(objRsvTestCF.Value), "", objRsvTestCF.Value)
        strBRsvTestEM = IIf(IsNull(objRsvTestEM.Value), "", objRsvTestEM.Value)
        strBRsvTestTM = IIf(IsNull(objRsvTestTM.Value), "", objRsvTestTM.Value)
        strBRsvTestEtc = IIf(IsNull(objRsvTestEtc.Value), "", objRsvTestEtc.Value)
        strBRsvTestRemark = IIf(IsNull(objRsvTestRemark.Value), "", objRsvTestRemark.Value)
        strBRsvTestRefer = IIf(IsNull(objRsvTestRefer.Value), "", objRsvTestRefer.Value)
        strBRsvTestReferText = IIf(IsNull(objRsvTestReferText.Value), "", objRsvTestReferText.Value)
        

        strStmt = "UPDATE FOLLOW_INFO SET                    " & vbLf & _
                  "       SECEQUIPDIV   = :SECEQUIPDIV,      " & vbLf & _
                  "       JUDCD         = :JUDCD,            " & vbLf & _
                  "       STATUSCD      = :STATUSCD,         " & vbLf & _
                  "       SECEQUIPNAME  = :SECEQUIPNAME,     " & vbLf & _
                  "       SECEQUIPCOURSE  = :SECEQUIPCOURSE, " & vbLf & _
                  "       SECDOCTOR     = :SECDOCTOR,        " & vbLf & _
                  "       SECEQUIPADDR  = :SECEQUIPADDR,     " & vbLf & _
                  "       SECEQUIPTEL   = :SECEQUIPTEL,      " & vbLf & _
                  "       SECPLANDATE   = :SECPLANDATE,      "
                  
        strStmt = strStmt & vbLf & _
                  "       RSVTESTUS         = :RSVTESTUS,           " & vbLf & _
                  "       RSVTESTCT         = :RSVTESTCT,           " & vbLf & _
                  "       RSVTESTMRI        = :RSVTESTMRI,          " & vbLf & _
                  "       RSVTESTBF         = :RSVTESTBF,           " & vbLf & _
                  "       RSVTESTGF         = :RSVTESTGF,           " & vbLf & _
                  "       RSVTESTCF         = :RSVTESTCF,           " & vbLf & _
                  "       RSVTESTEM         = :RSVTESTEM,           " & vbLf & _
                  "       RSVTESTTM         = :RSVTESTTM,           " & vbLf & _
                  "       RSVTESTETC        = :RSVTESTETC,          " & vbLf & _
                  "       RSVTESTREMARK     = :RSVTESTREMARK,       " & vbLf & _
                  "       RSVTESTREFER      = :RSVTESTREFER,        " & vbLf & _
                  "       RSVTESTREFERTEXT  = :RSVTESTREFERTEXT,    " & vbLf & _
                  "       SECREMARK         = :SECREMARK,           " & vbLf & _
                  "       UPDDATE           = SYSDATE,              " & vbLf & _
                  "       UPDUSER           = :UPDUSER              " & vbLf & _
                  " WHERE RSVNO             = :RSVNO                " & vbLf & _
                  "   AND JUDCLASSCD        = :JUDCLASSCD           "

        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

        ''### 更新前と更新後で値が違う場合はLOG出力 Start ##############################################################
        If strBSecEquipdiv <> strSecEquipDiv Then
            
            strItemName = "二次検査施設区分"
            strBSecEquipDivName = ""
            strSecEquipDivName = ""
            
            Select Case strBSecEquipdiv
               Case 0
                    strBSecEquipDivName = "二次検査場所未定"
               Case 1
                    strBSecEquipDivName = "当センター"
               Case 2
                    strBSecEquipDivName = "本院"
               Case 3
                    strBSecEquipDivName = "他院"
               Case 9
                    strBSecEquipDivName = "対象外"
            End Select

            Select Case strSecEquipDiv
               Case 0
                    strSecEquipDivName = "二次検査場所未定"
               Case 1
                    strSecEquipDivName = "当センター"
               Case 2
                    strSecEquipDivName = "本院"
               Case 3
                    strSecEquipDivName = "他院"
               Case 9
                    strSecEquipDivName = "対象外"
            End Select
            
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipDivName, strSecEquipDivName)
        End If
        
        '' 判定結果
        If strBJudCd <> strJudCd Then
            strItemName = "判定結果"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBJudCd, strJudCd)
        End If

        '' 二次検査ステータス
        If strBStatusCd <> strStatusCd Then
            
            strItemName = "二次検査ステータス"
            strBStatusName = ""
            strStatusName = ""
            
'            Select Case strBStatusCd
'               Case 1
'                    strBStatusName = "異常なし"
'               Case 2
'                    strBStatusName = "異常あり（フォローなし）"
'               Case 3
'                    strBStatusName = "異常あり（継続フォロー）"
'               Case 4
'                    strBStatusName = "その他終了（連絡とれず）"
'            End Select
'
'            Select Case strStatusCd
'               Case 1
'                    strStatusName = "異常なし"
'               Case 2
'                    strStatusName = "異常あり（フォローなし）"
'               Case 3
'                    strStatusName = "異常あり（継続フォロー）"
'               Case 4
'                    strStatusName = "その他終了（連絡とれず）"
'            End Select
            
            Select Case strBStatusCd
               Case 11
                    strBStatusName = "診断確定：異常なし"
               Case 12
                    strBStatusName = "診断確定：異常あり"
               Case 21
                    strBStatusName = "診断未確定(受診施設)：センター"
               Case 22
                    strBStatusName = "診断未確定(受診施設)：本院"
               Case 23
                    strBStatusName = "診断未確定(受診施設)：他院"
               Case 29
                    strBStatusName = "診断未確定(受診施設)：その他（未定・不明）"
               Case 99
                    strBStatusName = "その他(フォローアップ登録終了)"
            End Select
            
            Select Case strStatusCd
               Case 11
                    strStatusName = "診断確定：異常なし"
               Case 12
                    strStatusName = "診断確定：異常あり"
               Case 21
                    strStatusName = "診断未確定(受診施設)：センター"
               Case 22
                    strStatusName = "診断未確定(受診施設)：本院"
               Case 23
                    strStatusName = "診断未確定(受診施設)：他院"
               Case 29
                    strStatusName = "診断未確定(受診施設)：その他（未定・不明）"
               Case 99
                    strStatusName = "その他(フォローアップ登録終了)"
            End Select
            
            
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBStatusName, strStatusName)
        End If

        '' 二次検査予定日
        If strBSecPlanDate <> strSecPlanDate Then
            strItemName = "二次検査予定日"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecPlanDate, strSecPlanDate)
        End If
        
        
        ' 2009/12/24 二次検査予定項目追加　：yhlee  ------------------------------------------------------------------
        strItemName = "検査方法"
        If strBRsvTestUS <> strRsvTestUS Then
            If strBRsvTestUS <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "US", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "US")
            End If
        End If
        If strBRsvTestCT <> strRsvTestCT Then
            If strBRsvTestCT <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "CT", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "CT")
            End If
        End If
        If strBRsvTestMRI <> strRsvTestMRI Then
            If strBRsvTestMRI <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "MRI", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "MRI")
            End If
        End If
        If strBRsvTestBF <> strRsvTestBF Then
            If strBRsvTestBF <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "BF", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "BF")
            End If
        End If
        If strBRsvTestGF <> strRsvTestGF Then
            If strBRsvTestGF <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "GF", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "GF")
            End If
        End If
        If strBRsvTestCF <> strRsvTestCF Then
            If strBRsvTestCF <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "CF", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "CF")
            End If
        End If
        If strBRsvTestEM <> strRsvTestEM Then
            If strBRsvTestEM <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "注腸", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "注腸")
            End If
        End If
        If strBRsvTestTM <> strRsvTestTM Then
            If strBRsvTestTM <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "腫瘍マーカー", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "腫瘍マーカー")
            End If
        End If
        If strBRsvTestEtc <> strRsvTestEtc Then
            If strBRsvTestEtc <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "その他", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "その他")
            End If
        End If
        If strBRsvTestRemark <> strRsvTestRemark Then
            If strBRsvTestRemark <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBRsvTestRemark, strRsvTestRemark)
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strRsvTestRemark)
            End If
        End If

        If strBRsvTestRefer <> strRsvTestRefer Then
            If strBRsvTestRefer <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "リファー", "")
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "リファー")
            End If
        End If
        If strBRsvTestReferText <> strRsvTestReferText Then
            If strBRsvTestReferText <> "" Then
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBRsvTestReferText, strRsvTestReferText)
            Else
                Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", strRsvTestReferText)
            End If
        End If
        ' 2009/12/24 二次検査予定項目追加　(End)------------------------------------------------------------------
            
        
        '' 病医院名
        If strBSecEquipName <> strSecEquipName Then
            strItemName = "病医院名"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipName, strSecEquipName)
        End If
        '' 診療科
        If strBSecEquipCourse <> strSecEquipCourse Then
            strItemName = "診療科"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipCourse, strSecEquipCourse)
        End If
        '' 担当医師
        If strBSecDoctor <> strSecDoctor Then
            strItemName = "医療機関担当医師"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecDoctor, strSecDoctor)
        End If
        '' 住所
        If strBSecEquipAddr <> strSecEquipAddr Then
            strItemName = "医療機関住所"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipAddr, strSecEquipAddr)
        End If
        '' 電話番号
        If strBSecEquipTel <> strSecEquipTel Then
            strItemName = "医療機関電話番号"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipTel, strSecEquipTel)
        End If
        '' 備考
        If strBSecRemark <> strSecRemark Then
            strItemName = "備考"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecRemark, strSecRemark)
        End If
        
        ''### 更新前と更新後で値が違う場合はLOG出力 End   ##############################################################


    End If

    UpdateFollow_Info = True

    Set objSecEquipDiv = Nothing
    Set objJudCd = Nothing
    Set objStatusCd = Nothing
    Set objSecEquipName = Nothing
    Set objSecEquipCourse = Nothing
    Set objSecDoctor = Nothing
    Set objSecEquipAddr = Nothing
    Set objSecEquipTel = Nothing
    Set objSecPlanDate = Nothing
    Set objSecRemark = Nothing
    '2009/12/28 予約検査予約項目追加 by yhlee -----------
    Set objRsvTestUS = Nothing
    Set objRsvTestCT = Nothing
    Set objRsvTestMRI = Nothing
    Set objRsvTestBF = Nothing
    Set objRsvTestGF = Nothing
    Set objRsvTestCF = Nothing
    Set objRsvTestEM = Nothing
    Set objRsvTestTM = Nothing
    Set objRsvTestEtc = Nothing
    Set objRsvTestRemark = Nothing
    Set objRsvTestRefer = Nothing
    Set objRsvTestReferText = Nothing
    '2009/12/28 予約検査予約項目追加 (End) --------------
    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    UpdateFollow_Info = False

    'イベントログ書き込み
    WriteErrorLog "Follow.UpdateFollow_Info"

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
' 機能　　 : 指定予約番号のフォロー情報を取得する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     lngJudClassCd     検査項目（判定分類）
' 　　　　   (In)     strReqConfirmDate 承認日付（承認解除の場合、空白（Null））
' 　　　　   (In)     strUpdUser        承認者
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function UpdateFollow_Info_Confirm(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, _
                                          ByVal strReqConfirmFlg As String, ByVal strUpdUser As String _
                                         ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objReqConfirmDate       As OraField         '
    Dim objReqConfirmUser       As OraField         '
    
    Dim strBReqConfirmDate      As String           '
    Dim strBReqConfirmUser      As String           '
    
    Dim strItemName             As String           '変更履歴項目名
    
    Dim Ret                     As Boolean          '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    UpdateFollow_Info_Confirm = False

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REQCONFIRMDATE", Null, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "REQCONFIRMUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号・フォロー情報（承認日）を取得する（変更履歴のため）
    strStmt = ""
    strStmt = "SELECT FOLLOW_INFO.REQCONFIRMDATE,  FOLLOW_INFO.REQCONFIRMUSER  " & vbLf & _
              "  FROM FOLLOW_INFO                                              " & vbLf & _
              " WHERE FOLLOW_INFO.RSVNO      = :RSVNO                          " & vbLf & _
              "   AND FOLLOW_INFO.JUDCLASSCD = :JUDCLASSCD                     "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    If Not objOraDyna.EOF Then

        strStmt = "UPDATE FOLLOW_INFO SET    "
        If strReqConfirmFlg = "0" Then
            strStmt = strStmt & vbLf & "       REQCONFIRMDATE    = NULL,             "
            strStmt = strStmt & vbLf & "       REQCONFIRMUSER    = NULL             "
        Else
            strStmt = strStmt & vbLf & "       REQCONFIRMDATE    = SYSDATE,          "
            strStmt = strStmt & vbLf & "       REQCONFIRMUSER    = :REQCONFIRMUSER   "
        End If
        strStmt = strStmt & vbLf & " WHERE RSVNO             = :RSVNO            "
        strStmt = strStmt & vbLf & "   AND JUDCLASSCD        = :JUDCLASSCD       "


        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

        '' 更新前と更新後で値が違う場合はLOG出力
        If strReqConfirmFlg = "0" Then
            strItemName = "承認取消"
        Else
            strItemName = "結果承認"
        End If
        ''## 承認処理については「結果承認」と「承認解除」のみ記録
        Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", "", "")

    End If

    UpdateFollow_Info_Confirm = True

'    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    UpdateFollow_Info_Confirm = False

    'イベントログ書き込み
    WriteErrorLog "Follow.UpdateFollow_Info_Confirm"

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
' 機能　　 : 指定予約番号のフォロー情報の勧奨日を更新する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     lngJudClassCd     検査項目（判定分類）
' 　　　　   (In)     strCheckDate      勧奨日
' 　　　　   (In)     intReqCheckSeq    勧奨日区分（1:1次勧奨、2:2次勧奨）
' 　　　　   (In)     lntReqCheckMode   勧奨日登録モード（1:勧奨、2:未勧奨）
' 　　　　   (In)     strUpdUser        更新者
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function UpdateFollow_Info_Kansho(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, _
                                          ByVal strCheckDate As String, ByVal intReqCheckSeq As Integer, _
                                          ByVal lntReqCheckMode As Integer, ByVal strUpdUser As String _
                                         ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objReqCheckDate         As OraField         '勧奨日
    Dim objReqCheckDate1       As OraField         '第一勧奨日
    Dim objReqCheckDate2       As OraField         '第二勧奨日
    
    Dim strReqCheckDate         As String           '勧奨日
    Dim strBReqCheckDate1       As String           '第一勧奨日
    Dim strBReqCheckDate2       As String           '第二勧奨日
    Dim strItemName             As String           '変更履歴項目名
    Dim Ret                     As Boolean          '復帰値
    Dim strStmt                 As String
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    UpdateFollow_Info_Kansho = False
    
    If lntReqCheckMode = 1 Then             '勧奨
        strReqCheckDate = strCheckDate
    ElseIf intReqCheckSeq = 2 Then          '未勧奨
        strReqCheckDate = ""
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REQCHECKDATE", IIf(Not IsDate(strReqCheckDate), Null, Format$(strReqCheckDate, "yyyy/mm/dd")), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号・フォロー情報（承認日）を取得する（変更履歴のため）
    strStmt = ""
    strStmt = "SELECT FOLLOW_INFO.REQCHECKDATE1, FOLLOW_INFO.REQCHECKDATE2     " & vbLf & _
              "  FROM FOLLOW_INFO                                              " & vbLf & _
              " WHERE FOLLOW_INFO.RSVNO      = :RSVNO                          " & vbLf & _
              "   AND FOLLOW_INFO.JUDCLASSCD = :JUDCLASSCD                     "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    If Not objOraDyna.EOF Then
        strStmt = "UPDATE FOLLOW_INFO SET    "
        If intReqCheckSeq = 1 Then
            strStmt = strStmt & vbLf & "  REQCHECKDATE1 = :REQCHECKDATE ,   "
        ElseIf intReqCheckSeq = 2 Then
            strStmt = strStmt & vbLf & "  REQCHECKDATE2 = :REQCHECKDATE ,   "
        End If
        
        strStmt = strStmt & vbLf & "       UPDUSER           = :UPDUSER ,        "
        strStmt = strStmt & vbLf & "       UPDDATE           = SYSDATE           "
        strStmt = strStmt & vbLf & " WHERE RSVNO             = :RSVNO            "
        strStmt = strStmt & vbLf & "   AND JUDCLASSCD        = :JUDCLASSCD       "
        
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
        Set objFields = objOraDyna.Fields
        Set objReqCheckDate1 = objFields("REQCHECKDATE1")
        Set objReqCheckDate2 = objFields("REQCHECKDATE2")
        strBReqCheckDate1 = IIf(IsNull(objReqCheckDate1.Value), "", objReqCheckDate1.Value)
        strBReqCheckDate2 = IIf(IsNull(objReqCheckDate2.Value), "", objReqCheckDate2.Value)
        
        '' 勧奨日Log登録
        If (intReqCheckSeq = 1) And (strBReqCheckDate1 <> strReqCheckDate) Then
            strItemName = "一次勧奨日"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBReqCheckDate1, strReqCheckDate)
        End If
        
        If (intReqCheckSeq = 2) And (strBReqCheckDate2 <> strReqCheckDate) Then
            strItemName = "二次勧奨日"
            Ret = InsertFollow_Log(strUpdUser, 1, "U", lngRsvNo, lngJudClassCd, strItemName, "", "", strBReqCheckDate2, strReqCheckDate)
        End If

    End If

ExitHandle:
    UpdateFollow_Info_Kansho = True

'    Set objFields = Nothing
    Set objOraDyna = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    UpdateFollow_Info_Kansho = False

    'イベントログ書き込み
    WriteErrorLog "Follow.UpdateFollow_Info_Kansho"

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
' 機能　　 : 指定予約番号のフォロー対象管理情報を削除する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     vntJudClassCd     判定分類コード
' 　　　　   (In)     vntSeq            削除対象検査コード
'
' 戻り値　 : True   削除成功
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteFollow_Info(ByVal lngRsvNo As Long, ByVal lngJudClassCd As Long, ByVal strUpdUser As String) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraDyna2             As OraDynaset       'ダイナセット
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objFields2              As OraFields        'フィールドオブジェクト
    
    Dim strStmt                 As String           'SQLステートメント
    Dim strStmt2                As String           'SQLステートメント２(フォロー対象検査管理)
    Dim strStmt3                As String           'SQLステートメント３
    
    Dim objRsvNo                As OraField         '予約番号
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objSeq                  As OraField         '一連番号
    
    Dim objSecEquipDiv          As OraField         '
    Dim objJudCd                As OraField         '
    Dim objStatusCd             As OraField         '
    Dim objSecEquipName         As OraField         '
    Dim objSecEquipCourse       As OraField         '
    Dim objSecDoctor            As OraField         '
    Dim objSecEquipAddr         As OraField         '
    Dim objSecEquipTel          As OraField         '
    Dim objSecPlanDate          As OraField         '
    Dim objSecRemark            As OraField         '
    
    '2009/12/28 予約検査予約項目追加 by yhlee -----------
    Dim objRsvTestUS            As OraField         '
    Dim objRsvTestCT            As OraField         '
    Dim objRsvTestMRI           As OraField         '
    Dim objRsvTestBF            As OraField         '
    Dim objRsvTestGF            As OraField         '
    Dim objRsvTestCF            As OraField         '
    Dim objRsvTestEM            As OraField         '
    Dim objRsvTestTM            As OraField         '
    Dim objRsvTestEtc           As OraField         '
    Dim objRsvTestRemark        As OraField         '
    Dim objRsvTestRefer         As OraField         '
    Dim objRsvTestReferText     As OraField         '
    '2009/12/28 予約検査予約項目追加 (End) --------------
    
    Dim strItemName             As String           '変更履歴項目名
    Dim strBSecEquipdiv         As String           '
    Dim strBSecEquipDivName     As String           '二次検査実施区分(名称)
    Dim strBJudCd               As String           '
    Dim strBStatusCd            As String           '
    Dim strBStatusName          As String           '
    Dim strBSecEquipName        As String           '
    Dim strBSecEquipCourse      As String           '
    Dim strBSecDoctor           As String           '
    Dim strBSecEquipAddr        As String           '
    Dim strBSecEquipTel         As String           '
    Dim strBSecPlanDate         As String           '
    Dim strBSecRemark           As String           '
    
    '2009/12/28 二次検査予約項目追加 by yhlee -----------
    Dim strBRsvTestUS              As String           '
    Dim strBRsvTestCT              As String           '
    Dim strBRsvTestMRI             As String           '
    Dim strBRsvTestBF              As String           '
    Dim strBRsvTestGF              As String           '
    Dim strBRsvTestCF              As String           '
    Dim strBRsvTestEM              As String           '
    Dim strBRsvTestTM              As String           '
    Dim strBRsvTestEtc             As String           '
    Dim strBRsvTestRemark          As String           '
    Dim strBRsvTestRefer           As String           '
    Dim strBRsvTestReferText       As String           '
    '2009/12/28 Add by (End) -----------------------
    
    Dim i                       As Long             'ｲﾝﾃﾞｯｸｽ
    Dim j                       As Long             'ｲﾝﾃﾞｯｸｽ

    Dim Ret                     As Boolean             '

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    DeleteFollow_Info = True

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "IRSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IJUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ISEQ", 0, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号・検査項目（判定分類）のフォロー情報を取得する
'    strStmt = "SELECT FOLLOW_INFO.SECEQUIPDIV,                                 " & vbLf & _
'              "       FOLLOW_INFO.JUDCD,           FOLLOW_INFO.STATUSCD,       " & vbLf & _
'              "       FOLLOW_INFO.SECEQUIPNAME,    FOLLOW_INFO.SECDOCTOR,      " & vbLf & _
'              "       FOLLOW_INFO.SECEQUIPADDR,    FOLLOW_INFO.SECEQUIPTEL,    " & vbLf & _
'              "       FOLLOW_INFO.SECPLANDATE,     FOLLOW_INFO.SECREMARK       " & vbLf & _
'              "  FROM FOLLOW_INFO                                              " & vbLf & _
'              " WHERE FOLLOW_INFO.RSVNO      = :IRSVNO                         " & vbLf & _
'              "   AND FOLLOW_INFO.JUDCLASSCD = :IJUDCLASSCD                    "
    
'    strStmt = "SELECT FOLLOW_INFO.SECEQUIPDIV,                                 " & vbLf & _
'              "       FOLLOW_INFO.JUDCD,           FOLLOW_INFO.STATUSCD,       " & vbLf & _
'              "       FOLLOW_INFO.SECEQUIPNAME,    FOLLOW_INFO.SECEQUIPCOURSE,  FOLLOW_INFO.SECDOCTOR,      " & vbLf & _
'              "       FOLLOW_INFO.SECEQUIPADDR,    FOLLOW_INFO.SECEQUIPTEL,    " & vbLf & _
'              "       FOLLOW_INFO.SECPLANDATE,     FOLLOW_INFO.SECREMARK       " & vbLf & _
'              "  FROM FOLLOW_INFO                                              " & vbLf & _
'              " WHERE FOLLOW_INFO.RSVNO      = :IRSVNO                         " & vbLf & _
'              "   AND FOLLOW_INFO.JUDCLASSCD = :IJUDCLASSCD                    "
              
    ' 2009/12/28 二次検査予定項目追加
    strStmt = "SELECT FOLLOW_INFO.SECEQUIPDIV,                                      " & vbLf & _
              "       FOLLOW_INFO.JUDCD,           FOLLOW_INFO.STATUSCD,            " & vbLf & _
              "       FOLLOW_INFO.SECEQUIPNAME,    FOLLOW_INFO.SECEQUIPCOURSE,  FOLLOW_INFO.SECDOCTOR,      " & vbLf & _
              "       FOLLOW_INFO.SECEQUIPADDR,    FOLLOW_INFO.SECEQUIPTEL,         " & vbLf & _
              "       FOLLOW_INFO.SECPLANDATE,     FOLLOW_INFO.SECREMARK,           " & vbLf & _
              "       FOLLOW_INFO.RSVTESTUS,       FOLLOW_INFO.RSVTESTCT,           " & vbLf & _
              "       FOLLOW_INFO.RSVTESTMRI,      FOLLOW_INFO.RSVTESTBF,           " & vbLf & _
              "       FOLLOW_INFO.RSVTESTGF,       FOLLOW_INFO.RSVTESTCF,           " & vbLf & _
              "       FOLLOW_INFO.RSVTESTEM,       FOLLOW_INFO.RSVTESTTM,           " & vbLf & _
              "       FOLLOW_INFO.RSVTESTETC,      FOLLOW_INFO.RSVTESTREMARK,       " & vbLf & _
              "       FOLLOW_INFO.RSVTESTREFER,    FOLLOW_INFO.RSVTESTREFERTEXT     " & vbLf & _
              "  FROM FOLLOW_INFO                                                   " & vbLf & _
              " WHERE FOLLOW_INFO.RSVNO      = :IRSVNO                              " & vbLf & _
              "   AND FOLLOW_INFO.JUDCLASSCD = :IJUDCLASSCD                         "
              
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSecEquipDiv = objFields("SECEQUIPDIV")
        Set objJudCd = objFields("JUDCD")
        Set objStatusCd = objFields("STATUSCD")
        Set objSecEquipName = objFields("SECEQUIPNAME")
        Set objSecEquipCourse = objFields("SECEQUIPCOURSE")
        Set objSecDoctor = objFields("SECDOCTOR")
        Set objSecEquipAddr = objFields("SECEQUIPADDR")
        Set objSecEquipTel = objFields("SECEQUIPTEL")
        Set objSecPlanDate = objFields("SECPLANDATE")
        Set objSecRemark = objFields("SECREMARK")

        '2009/12/28 二次検査予約項目追加 by yhlee -----------
        Set objRsvTestUS = objFields("RSVTESTUS")
        Set objRsvTestCT = objFields("RSVTESTCT")
        Set objRsvTestMRI = objFields("RSVTESTMRI")
        Set objRsvTestBF = objFields("RSVTESTBF")
        Set objRsvTestGF = objFields("RSVTESTGF")
        Set objRsvTestCF = objFields("RSVTESTCF")
        Set objRsvTestEM = objFields("RSVTESTEM")
        Set objRsvTestTM = objFields("RSVTESTTM")
        Set objRsvTestEtc = objFields("RSVTESTETC")
        Set objRsvTestRemark = objFields("RSVTESTREMARK")
        Set objRsvTestRefer = objFields("RSVTESTREFER")
        Set objRsvTestReferText = objFields("RSVTESTREFERTEXT")
        '2009/12/28 (End)----------------------------------

        strBSecEquipdiv = objSecEquipDiv.Value
        strBJudCd = IIf(IsNull(objJudCd.Value), "", objJudCd.Value)
        strBStatusCd = IIf(IsNull(objStatusCd.Value), "", objStatusCd.Value)
        strBSecEquipName = IIf(IsNull(objSecEquipName.Value), "", objSecEquipName.Value)
        strBSecEquipCourse = IIf(IsNull(objSecEquipCourse.Value), "", objSecEquipCourse.Value)
        strBSecDoctor = IIf(IsNull(objSecDoctor.Value), "", objSecDoctor.Value)
        strBSecEquipAddr = IIf(IsNull(objSecEquipAddr.Value), "", objSecEquipAddr.Value)
        strBSecEquipTel = IIf(IsNull(objSecEquipTel.Value), "", objSecEquipTel.Value)
        strBSecPlanDate = IIf(IsNull(objSecPlanDate.Value), "", objSecPlanDate.Value)
        strBSecRemark = IIf(IsNull(objSecRemark.Value), "", objSecRemark.Value)
    
        strBRsvTestUS = IIf(IsNull(objRsvTestUS.Value), "", objRsvTestUS.Value)
        strBRsvTestCT = IIf(IsNull(objRsvTestCT.Value), "", objRsvTestCT.Value)
        strBRsvTestMRI = IIf(IsNull(objRsvTestMRI.Value), "", objRsvTestMRI.Value)
        strBRsvTestBF = IIf(IsNull(objRsvTestBF.Value), "", objRsvTestBF.Value)
        strBRsvTestGF = IIf(IsNull(objRsvTestGF.Value), "", objRsvTestGF.Value)
        strBRsvTestCF = IIf(IsNull(objRsvTestCF.Value), "", objRsvTestCF.Value)
        strBRsvTestEM = IIf(IsNull(objRsvTestEM.Value), "", objRsvTestEM.Value)
        strBRsvTestTM = IIf(IsNull(objRsvTestTM.Value), "", objRsvTestTM.Value)
        strBRsvTestEtc = IIf(IsNull(objRsvTestEtc.Value), "", objRsvTestEtc.Value)
        strBRsvTestRemark = IIf(IsNull(objRsvTestRemark.Value), "", objRsvTestRemark.Value)
        strBRsvTestRefer = IIf(IsNull(objRsvTestRefer.Value), "", objRsvTestRefer.Value)
        strBRsvTestReferText = IIf(IsNull(objRsvTestReferText.Value), "", objRsvTestReferText.Value)
    
        
        '''二次検査結果データ取得及び削除
        strStmt = "SELECT FOLLOW_RSL.RSVNO,                         " & vbLf & _
                  "       FOLLOW_RSL.JUDCLASSCD,                    " & vbLf & _
                  "       FOLLOW_RSL.SEQ                            " & vbLf & _
                  "  FROM FOLLOW_RSL                                " & vbLf & _
                  " WHERE FOLLOW_RSL.RSVNO      = :IRSVNO            " & vbLf & _
                  "   AND FOLLOW_RSL.JUDCLASSCD = :IJUDCLASSCD       "
        
        Set objOraDyna2 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
        If Not objOraDyna2.EOF Then
            'オブジェクトの参照設定
            Set objFields2 = objOraDyna2.Fields
            Set objRsvNo = objFields2("RSVNO")
            Set objJudClassCd = objFields2("JUDCLASSCD")
            Set objSeq = objFields2("SEQ")
        
            Do Until objOraDyna2.EOF
        
                '変更履歴を残す為、二次検査結果情報削除モジュールを1件ずつ呼び出して削除処理
                Ret = DeleteFollow_Rsl(objRsvNo.Value, objJudClassCd.Value, objSeq.Value, strUpdUser)
            
                objOraDyna2.MoveNext
            Loop
            
            'キー値の再設定（変更履歴登録時バインド解除）
            objOraParam.Add "IRSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
            objOraParam.Add "IJUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
        
        End If
    
    End If
    
    Set objRsvNo = Nothing
    Set objJudClassCd = Nothing
    Set objSeq = Nothing

    Set objSecEquipDiv = Nothing
    Set objJudCd = Nothing
    Set objStatusCd = Nothing
    Set objSecEquipName = Nothing
    Set objSecEquipCourse = Nothing
    Set objSecDoctor = Nothing
    Set objSecEquipAddr = Nothing
    Set objSecEquipTel = Nothing
    Set objSecPlanDate = Nothing
    Set objSecRemark = Nothing
    '2009/12/28 予約検査予約項目追加 by yhlee -----------
    Set objRsvTestUS = Nothing
    Set objRsvTestCT = Nothing
    Set objRsvTestMRI = Nothing
    Set objRsvTestBF = Nothing
    Set objRsvTestGF = Nothing
    Set objRsvTestCF = Nothing
    Set objRsvTestEM = Nothing
    Set objRsvTestTM = Nothing
    Set objRsvTestEtc = Nothing
    Set objRsvTestRemark = Nothing
    Set objRsvTestRefer = Nothing
    Set objRsvTestReferText = Nothing
    '2009/12/28 予約検査予約項目追加 (End) --------------

    Set objFields = Nothing
    Set objFields2 = Nothing
    Set objOraDyna = Nothing
    Set objOraDyna2 = Nothing
    
    
    'フォローアップ情報削除
    strStmt2 = "DELETE FROM FOLLOW_INFO             " & vbLf & _
               " WHERE RSVNO      = :IRSVNO          " & vbLf & _
               "   AND JUDCLASSCD = :IJUDCLASSCD     "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt2)


    ''### 値が登録されている場合はLOG出力 Start ##############################################################
    If strBSecEquipdiv <> "" Then
        
        strItemName = "二次検査施設区分"
        strBSecEquipDivName = ""
        
        Select Case strBSecEquipdiv
           Case 0
                strBSecEquipDivName = "二次検査場所未定"
           Case 1
                strBSecEquipDivName = "当センター"
           Case 2
                strBSecEquipDivName = "本院"
           Case 3
                strBSecEquipDivName = "他院"
           Case 9
                strBSecEquipDivName = "対象外"
        End Select
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipDivName, "")
    End If
    
    '' 判定結果
    If strBJudCd <> "" Then
        strItemName = "判定結果"
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBJudCd, "")
    End If

    '' 二次検査ステータス
    If strBStatusCd <> "" Then
        
        strItemName = "二次検査ステータス"
        strBStatusName = ""
        
'        Select Case strBStatusCd
'           Case 1
'                strBStatusName = "異常なし"
'           Case 2
'                strBStatusName = "異常あり（フォローなし）"
'           Case 3
'                strBStatusName = "異常あり（継続フォロー）"
'           Case 4
'                strBStatusName = "その他終了（連絡とれず）"
'        End Select
        
        Select Case strBStatusCd
           Case 11
                strBStatusName = "診断確定：異常なし"
           Case 12
                strBStatusName = "診断確定：異常あり"
           Case 21
                strBStatusName = "診断未確定(受診施設)：センター"
           Case 22
                strBStatusName = "診断未確定(受診施設)：本院"
           Case 23
                strBStatusName = "診断未確定(受診施設)：他院"
           Case 29
                strBStatusName = "診断未確定(受診施設)：その他（未定・不明）"
           Case 99
                strBStatusName = "その他(フォローアップ登録終了)"
        End Select
        
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBStatusName, "")
    End If

    '' 二次検査予定日
    If strBSecPlanDate <> "" Then
        strItemName = "二次検査予定日"
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecPlanDate, "")
    End If
    
    '''二次検査予定項目削除履歴 Start
    strItemName = "二次検査予定項目"
    If strBRsvTestUS <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "US", "")
    End If
    If strBRsvTestCT <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "CT", "")
    End If
    If strBRsvTestMRI <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "MRI", "")
    End If
    If strBRsvTestBF <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "BF", "")
    End If
    If strBRsvTestGF <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "GF", "")
    End If
    If strBRsvTestCF <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "CF", "")
    End If
    If strBRsvTestEM <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "注腸", "")
    End If
    If strBRsvTestTM <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "腫瘍マーカー", "")
    End If
    If strBRsvTestEtc <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "その他", "")
    End If
    If strBRsvTestRemark <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBRsvTestRemark, "")
    End If
    If strBRsvTestRefer <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", "リファー", "")
    End If
    If strBRsvTestReferText <> "" Then
        Ret = InsertFollow_Log(strUpdUser, 2, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBRsvTestReferText, "")
    End If
    
    '' 病医院名
    If strBSecEquipName <> "" Then
        strItemName = "病医院名"
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipName, "")
    End If
    '' 診療科
    If strBSecEquipCourse <> "" Then
        strItemName = "診療科"
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipCourse, "")
    End If
    '' 担当医師
    If strBSecDoctor <> "" Then
        strItemName = "医療機関担当医師"
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecDoctor, "")
    End If
    '' 住所
    If strBSecEquipAddr <> "" Then
        strItemName = "医療機関住所"
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipAddr, "")
    End If
    '' 電話番号
    If strBSecEquipTel <> "" Then
        strItemName = "医療機関電話番号"
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecEquipTel, "")
    End If
    '' 備考
    If strBSecRemark <> "" Then
        strItemName = "備考"
        Ret = InsertFollow_Log(strUpdUser, 1, "D", lngRsvNo, lngJudClassCd, strItemName, "", "", strBSecRemark, "")
    End If
    
    ''### 値が登録されている場合はLOG出力 End   ##############################################################

    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    DeleteFollow_Info = False

    'イベントログ書き込み
    WriteErrorLog "Follow.DeleteFollow_Info"

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

' 機能　　 : 指定予約番号のフォロー情報を取得する
'
' 引数　　 : (In)     strUpdUser        更新者
' 　　　　   (In)     lngUpdClass       更新分類
' 　　　　   (In)     strUpdDiv         処理区分
' 　　　　   (In)     lngRsvNo          予約番号
' 　　　　   (In)     lngJudClassCd     判定分類コード
' 　　　　   (In)     strItemName       変更項目名称
' 　　　　   (In)     strItemcd         変更項目コード
' 　　　　   (In)     strSuffix         変更サフィックス
' 　　　　   (In)     strBefor          変更前
' 　　　　   (In)     strAfter          変更後
'
' 戻り値　 : True   挿入成功
' 　　　　   False  挿入失敗、または異常終了
'
' 備考　　 :
'
Public Function InsertFollow_Log(ByVal strUpdUser As String, ByVal lngUpdClass As Long, _
                                 ByVal strUpdDiv As String, ByVal lngRsvNo As Long, _
                                 ByVal lngJudClassCd As Long, ByVal strItemName As String, _
                                 ByVal strItemCd As String, ByVal strSuffix As String, _
                                 ByVal strBefore As String, ByVal strAfter As String) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    InsertFollow_Log = False

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "LUPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LUPDCLASS", lngUpdClass, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LUPDDIV", strUpdDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LRSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LJUDCLASSCD", IIf(lngJudClassCd = 0, Null, lngJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LITEMCD", strItemCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LSUFFIX", strSuffix, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LITEMNAME", strItemName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LBEFORE", strBefore, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LAFTER", strAfter, ORAPARM_INPUT, ORATYPE_VARCHAR2

    strStmt = "INSERT INTO FOLLOW_UPDATE_LOG (  " & vbLf & _
              "             UPDDATE,            " & vbLf & _
              "             UPDUSER,            " & vbLf & _
              "             UPDCLASS,           " & vbLf & _
              "             UPDDIV,             " & vbLf & _
              "             RSVNO,              " & vbLf & _
              "             JUDCLASSCD,         " & vbLf & _
              "             ITEMCD,             " & vbLf & _
              "             SUFFIX,             " & vbLf & _
              "             ITEMNAME,           " & vbLf & _
              "             BEFORE,             " & vbLf & _
              "             AFTER               " & vbLf & _
              "         ) VALUES (              " & vbLf & _
              "             SYSDATE,            " & vbLf & _
              "             :LUPDUSER,          " & vbLf & _
              "             :LUPDCLASS,         " & vbLf & _
              "             :LUPDDIV,           " & vbLf & _
              "             :LRSVNO,            " & vbLf & _
              "             :LJUDCLASSCD,       " & vbLf & _
              "             :LITEMCD,           " & vbLf & _
              "             :LSUFFIX,           " & vbLf & _
              "             :LITEMNAME,         " & vbLf & _
              "             :LBEFORE,           " & vbLf & _
              "             :LAFTER             " & vbLf & _
              "         )                       "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    InsertFollow_Log = True

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    InsertFollow_Log = False

    'イベントログ書き込み
    WriteErrorLog "FollowUp.InsertFollow_Log"

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
' 機能　　 : 指定検索条件の変更履歴を取得する。
'
'
' 引数　　 : (In)     strStartUpdDate       検索条件：更新日（開始）
' 　　　　   (In)     strEndUpdDate         検索条件：更新日（終了）
' 　　　　   (In)     strSearchUpdUser      検索条件：更新者
' 　　　　   (In)     lngSearchUpdClass     検索条件：更新分類（０：すべて）
' 　　　　   (In)     lngOrderbyItem        並べ替え項目(0:更新日,1:更新者,2:分類・項目）
' 　　　　   (In)     lngOrderbyMode        並べ替え方法(0:昇順,1:降順)
' 　　　　   (In)     lngStartPos           取得開始位置
' 　　　　   (In)     lngPageMaxLine        １ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）
' 　　　　   (In)     lngRsvNo              予約番号
' 　　　　   (Out)    vntUpdDate            更新日時
' 　　　　   (Out)    vntUpdUser            更新者
' 　　　　   (Out)    vntUpdUserName        更新者氏名
' 　　　　   (Out)    vntUpdClass           更新分類
' 　　　　   (Out)    vntUpdDiv             処理区分
' 　　　　   (Out)    vntRsvNo              予約番号
' 　　　　   (Out)    vntJudClassCd         判定分類コード
' 　　　　   (Out)    vntItemCd             検査項目コード
' 　　　　   (Out)    vntSuffix             サフィックス
' 　　　　   (Out)    vntItemCdName         検査項目名称
' 　　　　   (Out)    vntJudClassName       判定分類名称
' 　　　　   (Out)    vntItemName           変更項目名称
' 　　　　   (Out)    vntBefore             更新前値
' 　　　　   (Out)    vntAfter              更新後値
'
' 戻り値　 : 検索条件を満たすレコード件数（取得開始位置当に関わらず全件数）
'            COnsult SelectDailyList を参考にしましょう。
'
' 備考　　 :
'
Public Function SelectFollowLogList( _
        ByVal strStartUpdDate As String, _
        ByVal strEndUpdDate As String, _
        ByVal strSearchUpdUser As String, _
        ByVal lngSearchUpdClass As String, _
        ByVal lngOrderbyItem As Long, _
        ByVal lngOrderbyMode As Long, _
        ByVal lngStartPos As Long, _
        ByVal lngPageMaxLine As Long, _
        Optional ByRef lngRsvNo As Variant, _
        Optional ByRef vntUpdDate As Variant, _
        Optional ByRef vntUpdUser As Variant, Optional ByRef vntUpdUserName As Variant, _
        Optional ByRef vntUpdClass As Variant, _
        Optional ByRef vntUpdDiv As Variant, _
        Optional ByRef vntRsvNo As Variant, _
        Optional ByRef vntJudClassCd As Variant, Optional ByRef vntJudClassName As Variant, _
        Optional ByRef vntItemCd As Variant, Optional ByRef vntSuffix As Variant, _
        Optional ByRef vntItemCdName As Variant, Optional ByRef vntItemName As Variant, _
        Optional ByRef vntBefore As Variant, _
        Optional ByRef vntAfter As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim strStmt2                As String           'SQLステートメント
    Dim strStmt_count           As String           'SQLステートメント
    Dim strStmt_data            As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト

    Dim objUpdDate              As OraField         '更新日時
    Dim objUpdUser              As OraField         '更新者
    Dim objUpdUserName          As OraField         '更新者氏名
    Dim objUpdClass             As OraField         '更新分類
    Dim objUpdDiv               As OraField         '処理区分
    Dim objRsvNo                As OraField         '予約番号
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名称
    Dim objItemName             As OraField         '変更項目名称
    Dim objItemCd               As OraField         '変更項目コード
    Dim objSuffix               As OraField         '変更サフィックス
    Dim objItemCdName           As OraField         '変更項目名称
    Dim objBefore               As OraField         '更新前値
    Dim objAfter                As OraField         '更新後値

    Dim vntArrUpdDate()         As Variant          '更新日時の配列
    Dim vntArrUpdUser()         As Variant          '更新者の配列
    Dim vntArrUpdUserName()     As Variant          '更新者氏名の配列
    Dim vntArrUpdClass()        As Variant          '更新分類の配列
    Dim vntArrUpdDiv()          As Variant          '処理区分の配列
    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim vntArrItemName()        As Variant          '変更項目名称の配列
    Dim vntArrItemCd()          As Variant          '変更項目コードの配列
    Dim vntArrSuffix()          As Variant          '変更サフィックスの配列
    Dim vntArrItemCdName()      As Variant          '変更項目名称の配列
    Dim vntArrBefore()          As Variant          '更新前値の配列
    Dim vntArrAfter()           As Variant          '更新後値の配列
    
    Dim lngAllCount             As Long             '全件数
    Dim lngCount                As Long             'レコード数
    
    Dim lngWhereFlg             As Long             'Where句開始有無フラグ
    
    Dim strBakDate              As String           '日付比較時退避用
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUpdUserName) Then vntUpdUserName = Empty
    If Not IsMissing(vntUpdClass) Then vntUpdClass = Empty
    If Not IsMissing(vntUpdDiv) Then vntUpdDiv = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = Empty
    If Not IsMissing(vntJudClassName) Then vntJudClassName = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntItemCdName) Then vntItemCdName = Empty
    If Not IsMissing(vntBefore) Then vntBefore = Empty
    If Not IsMissing(vntAfter) Then vntAfter = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    '日付未指定の場合、当日日付をセット　（aspの処理とつじつまを合わせるため）
    If strStartUpdDate = "" Or IsDate(strStartUpdDate) = False Then
        strStartUpdDate = Format(Date, "yyyy/mm/dd")
    End If
    If strEndUpdDate = "" Or IsDate(strEndUpdDate) = False Then
        strEndUpdDate = Format(Date, "yyyy/mm/dd")
    End If
    
    '更新日　開始終了あり で開始終了逆？
    If strStartUpdDate <> "" And IsDate(strStartUpdDate) = True And _
        strEndUpdDate <> "" And IsDate(strEndUpdDate) = True Then
        If CDate(strStartUpdDate) > CDate(strEndUpdDate) Then
            strBakDate = strStartUpdDate
            strStartUpdDate = strEndUpdDate
            strEndUpdDate = strBakDate
        End If
    End If
    
    If strStartUpdDate <> "" And IsDate(strStartUpdDate) = True Then
        objOraParam.Add "SUPDDATE", Trim(strStartUpdDate), ORAPARM_INPUT, ORATYPE_DATE
    End If
    If strEndUpdDate <> "" And IsDate(strEndUpdDate) = True Then
        objOraParam.Add "EUPDDATE", DateAdd("d", 1, Trim(strEndUpdDate)), ORAPARM_INPUT, ORATYPE_DATE
    End If
    
    '検索条件の更新者設定有無チェック
    If strSearchUpdUser <> "" And IsEmpty(strSearchUpdUser) = False Then
        objOraParam.Add "SRCUPDUSER", Trim(strSearchUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '検索条件の更新分類設定チェック
    If lngSearchUpdClass = "" Or lngSearchUpdClass = "X" Or IsEmpty(lngSearchUpdClass) = True Then
        lngSearchUpdClass = 999
    End If

    objOraParam.Add "SRCUPDCLASS", lngSearchUpdClass, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngPageMaxLine > 0 Then
        objOraParam.Add "ENDPOS", (lngStartPos + lngPageMaxLine - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    strStmt_count = " SELECT COUNT(*)   "
    strStmt_data = _
              " SELECT LOGVIEW.UPDDATE,   LOGVIEW.UPDUSER,                               " & vbLf & _
              "        LOGVIEW.UPDUSERNAME,                                              " & vbLf & _
              "        LOGVIEW.UPDCLASS,  LOGVIEW.UPDDIV,                                " & vbLf & _
              "        LOGVIEW.RSVNO,     LOGVIEW.JUDCLASSCD,                            " & vbLf & _
              "        NVL( LOGVIEW.JUDCLASSNAME, LOGVIEW.JUDCLASSCD ) JUDCLASSNAME,     " & vbLf & _
              "        LOGVIEW.ITEMNAME,  LOGVIEW.ITEMCD,                                " & vbLf & _
              "        LOGVIEW.SUFFIX,    LOGVIEW.ITEMCDNAME,                            " & vbLf & _
              "        LOGVIEW.BEFORE,    LOGVIEW.AFTER                                  "
          
    strStmt = "   FROM (SELECT ROWNUM SEQ,                                               " & vbLf & _
              "                UPDATELOGVIEW.UPDDATE,   UPDATELOGVIEW.UPDUSER,           " & vbLf & _
              "                HAINSUSER.USERNAME UPDUSERNAME,                           " & vbLf & _
              "                UPDATELOGVIEW.UPDCLASS,  UPDATELOGVIEW.UPDDIV,            " & vbLf & _
              "                UPDATELOGVIEW.RSVNO,     UPDATELOGVIEW.JUDCLASSCD,        " & vbLf & _
              "                UPDATELOGVIEW.ITEMCD,    UPDATELOGVIEW.SUFFIX,            " & vbLf & _
              "                JUDCLASS.JUDCLASSNAME,   UPDATELOGVIEW.ITEMNAME,          " & vbLf & _
              "                UPDATELOGVIEW.BEFORE,    UPDATELOGVIEW.AFTER,             " & vbLf & _
              "                UPDATELOGVIEW.ITEMCDNAME                                  "

    strStmt = strStmt & vbLf & _
              "           FROM (SELECT FOLLOW_UPDATE_LOG.UPDDATE,   FOLLOW_UPDATE_LOG.UPDUSER,      " & vbLf & _
              "                        FOLLOW_UPDATE_LOG.UPDCLASS,  FOLLOW_UPDATE_LOG.UPDDIV,       " & vbLf & _
              "                        FOLLOW_UPDATE_LOG.RSVNO,     FOLLOW_UPDATE_LOG.JUDCLASSCD,   " & vbLf & _
              "                        FOLLOW_UPDATE_LOG.ITEMNAME,                                  " & vbLf & _
              "                        FOLLOW_UPDATE_LOG.ITEMCD,    FOLLOW_UPDATE_LOG.SUFFIX,       " & vbLf & _
              "                        FOLLOW_UPDATE_LOG.BEFORE,    FOLLOW_UPDATE_LOG.AFTER,        " & vbLf & _
              "                        NVL(ITEM_C.ITEMNAME,'') AS ITEMCDNAME                        " & vbLf & _
              "                   FROM FOLLOW_UPDATE_LOG, ITEM_C                                    "
    lngWhereFlg = 0

    strStmt = strStmt & vbLf & _
             "                   WHERE FOLLOW_UPDATE_LOG.UPDDATE BETWEEN :SUPDDATE AND :EUPDDATE    " & vbLf & _
             "                     AND FOLLOW_UPDATE_LOG.ITEMCD = ITEM_C.ITEMCD(+)                  " & vbLf & _
             "                     AND FOLLOW_UPDATE_LOG.SUFFIX = ITEM_C.SUFFIX(+)                  "
    lngWhereFlg = 1
    
    '検索条件の更新者チェック
    If strSearchUpdUser <> "" And IsEmpty(strSearchUpdUser) = False Then
        If lngWhereFlg = 0 Then
            strStmt = strStmt & vbLf & " WHERE "
        Else
            strStmt = strStmt & vbLf & " AND "
        End If
        strStmt = strStmt & vbLf & _
              "                        FOLLOW_UPDATE_LOG.UPDUSER = :SRCUPDUSER  "
        lngWhereFlg = 1
    End If
    
     '検索条件の更新分類チェック
    If lngSearchUpdClass <> 999 Then
        If lngWhereFlg = 0 Then
            strStmt = strStmt & vbLf & " WHERE "
        Else
            strStmt = strStmt & vbLf & " AND "
        End If
        strStmt = strStmt & vbLf & _
              "                        FOLLOW_UPDATE_LOG.UPDCLASS = :SRCUPDCLASS  "
        lngWhereFlg = 1
    End If

    '検索条件の予約番号予約番号
    If Not IsMissing(lngRsvNo) Then
        objOraParam.Add "SRCRSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
        If lngWhereFlg = 0 Then
            strStmt = strStmt & vbLf & " WHERE "
        Else
            strStmt = strStmt & vbLf & " AND "
        End If
        strStmt = strStmt & vbLf & _
              "                        FOLLOW_UPDATE_LOG.RSVNO = :SRCRSVNO  "
        lngWhereFlg = 1
    End If

    '降順？
    If lngOrderbyMode = 1 Then
        strStmt2 = " DESC, FOLLOW_UPDATE_LOG.UPDCLASS"
    Else
        strStmt2 = " ASC, FOLLOW_UPDATE_LOG.UPDCLASS"
    End If
    
    '並び替えの指定
    strStmt = strStmt & vbLf & _
            " ORDER BY "
    Select Case lngOrderbyItem
    '更新日
    Case 0
        strStmt = strStmt & " FOLLOW_UPDATE_LOG.UPDDATE " & strStmt2
    '更新者
    Case 1
        strStmt = strStmt & " FOLLOW_UPDATE_LOG.UPDUSER " & strStmt2
    '分類・項目
    Case 2
        '### 2004.01.13 JUDCLASSCD 追加 分類判定のときの並び替えができていない
        strStmt = strStmt & " FOLLOW_UPDATE_LOG.UPDCLASS     " & strStmt2 & _
                            " ,FOLLOW_UPDATE_LOG.JUDCLASSCD  " & strStmt2
    Case Else
        strStmt = strStmt & " FOLLOW_UPDATE_LOG.UPDDATE " & strStmt2
    End Select
    
    strStmt = strStmt & vbLf & _
              "                ) UPDATELOGVIEW,                                          " & vbLf & _
              "                JUDCLASS, HAINSUSER                               " & vbLf & _
              "          WHERE UPDATELOGVIEW.JUDCLASSCD  = JUDCLASS.JUDCLASSCD(+)        " & vbLf & _
              "            AND UPDATELOGVIEW.UPDUSER     = HAINSUSER.USERID(+)           " & vbLf & _
              "        ) LOGVIEW                                                         "
   
    '全件数取得
    strStmt_count = strStmt_count & strStmt
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt_count), ORADYN_READONLY + ORADYN_NOCACHE)
        
    lngAllCount = objOraDyna.Fields(0).Value
    
    '取得件数で絞込み
    strStmt = strStmt & vbLf & _
              "  WHERE LOGVIEW.SEQ >= :STARTPOS "
    If lngPageMaxLine > 0 Then
        strStmt = strStmt & vbLf & _
              "    AND LOGVIEW.SEQ <= :ENDPOS "
    End If

    'データ取得
    strStmt_data = strStmt_data & strStmt
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt_data), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUpdUserName = objFields("UPDUSERNAME")
        Set objUpdClass = objFields("UPDCLASS")
        Set objUpdDiv = objFields("UPDDIV")
        Set objRsvNo = objFields("RSVNO")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemCdName = objFields("ITEMCDNAME")
        Set objItemName = objFields("ITEMNAME")
        Set objBefore = objFields("BEFORE")
        Set objAfter = objFields("AFTER")
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrUpdDate(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)
            ReDim Preserve vntArrUpdUserName(lngCount)
            ReDim Preserve vntArrUpdClass(lngCount)
            ReDim Preserve vntArrUpdDiv(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemCdName(lngCount)
            ReDim Preserve vntArrBefore(lngCount)
            ReDim Preserve vntArrAfter(lngCount)
            
            vntArrUpdDate(lngCount) = objUpdDate.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""
            vntArrUpdUserName(lngCount) = objUpdUserName.Value & ""
            vntArrUpdClass(lngCount) = objUpdClass.Value & ""
            vntArrUpdDiv(lngCount) = objUpdDiv.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrJudClassCd(lngCount) = objJudClassCd.Value & ""
            vntArrJudClassName(lngCount) = objJudClassName.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemCdName(lngCount) = objItemCdName.Value & ""
            vntArrBefore(lngCount) = objBefore.Value & ""
            vntArrAfter(lngCount) = objAfter.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    SelectFollowLogList = lngAllCount
    
    '戻り値の設定
    If Not IsMissing(vntUpdDate) Then vntUpdDate = vntArrUpdDate
    If Not IsMissing(vntUpdUser) Then vntUpdUser = vntArrUpdUser
    If Not IsMissing(vntUpdUserName) Then vntUpdUserName = vntArrUpdUserName
    If Not IsMissing(vntUpdClass) Then vntUpdClass = vntArrUpdClass
    If Not IsMissing(vntUpdDiv) Then vntUpdDiv = vntArrUpdDiv
    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = vntArrJudClassCd
    If Not IsMissing(vntJudClassName) Then vntJudClassName = vntArrJudClassName
    If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
    If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
    If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
    If Not IsMissing(vntItemCdName) Then vntItemCdName = vntArrItemCdName
    If Not IsMissing(vntBefore) Then vntBefore = vntArrBefore
    If Not IsMissing(vntAfter) Then vntAfter = vntArrAfter
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectFollowLogList = -1
    
    'イベントログ書き込み
    WriteErrorLog "FollowUp.SelectFollowLogList"
    
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

' 李
' 機能　　 : 指定日付（受診日）範囲の勧奨対象者リスト取得する
'
' 引数　　 : (In)     strStartCslDate       開始受診日
' 　　　　   (In)     strEndCslDate         終了受診日
' 　　　　   (In)     strItemCd             検査項目
' 　　　　   (In)     strUpdUser            フォロー登録者
' 　　　　   (In)     lngPastMonth          経過月数
' 　　　　   (In)     lngStartPos           表示開始位置
' 　　　　   (In)     lngPageMaxLine        １ページ表示ＭＡＸ行
' 　　　　   (Out)    vntCslDate            受診日
' 　　　　   (Out)    vntRsvNo              受診番号
' 　　　　   (Out)    vntPerId              個人ID
' 　　　　   (Out)    vntDayId              当日ID
' 　　　　   (Out)    vntPerKname           カナ名
' 　　　　   (Out)    vntPerName            名前
' 　　　　   (Out)    vntGender             性別
' 　　　　   (Out)    vntAge                年齢
' 　　　　   (Out)    vntBirth              生年月日
' 　　　　   (Out)    vntCscd               コースコード
' 　　　　   (Out)    vntJudClassCd         判定分コード
' 　　　　   (Out)    vntJudClassName       判定分類名
' 　　　　   (Out)    vntJudCd              フォロー情報として登録された判定結果
' 　　　　   (Out)    vntRslJudCd           健診判定結果
' 　　　　   (Out)    vntEquipDiv           二次検査実施区分
' 　　　　   (Out)    vntAddUser            フォローアップ初期登録者氏名
' 　　　　   (Out)    vntDocJud             判定医氏名
' 　　　　   (Out)    vntDocGf              上部内視鏡医氏名
' 　　　　   (Out)    vntDocCf              下部内視鏡医氏名
' 　　　　   (In)     blnCountFlg           集計フラグ(True:予約番号が重複しない件数,False:ﾚｺｰﾄﾞ件数)
' 　　　　   (Out)    vntSecPlanDate        二次検査予定日
' 　　　　   (Out)    vntReqCheckDate1      第一勧奨日
' 　　　　   (Out)    vntReqCheckDate2      第二勧奨日
' 　　　　   (Out)    vntSecTestName        二次検査予定項目名

'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectExhortList( _
                ByVal strStartCslDate As Date, ByVal strEndCslDate As Date, _
                ByVal strJudClassCd As String, ByVal strUpdUser As String, _
                ByVal lngPastMonth As Long, ByVal lngStartPos As Long, _
                ByVal lngPageMaxLine As Long, _
                ByVal strCheckDateStat As String, _
                Optional ByRef vntCsldate As Variant, _
                Optional ByRef vntRsvNo As Variant, Optional ByRef vntPerId As Variant, _
                Optional ByRef vntDayId As Variant, Optional ByRef vntPerKname As Variant, _
                Optional ByRef vntPerName As Variant, Optional ByRef vntGender As Variant, _
                Optional ByRef vntAge As Variant, Optional ByRef vntBirth As Variant, _
                Optional ByRef vntCscd As Variant, Optional ByRef vntJudClassCd As Variant, _
                Optional ByRef vntJudClassName As Variant, Optional ByRef vntJudCd As Variant, _
                Optional ByRef vntRslJudCd As Variant, Optional ByRef vntResultDispMode As Variant, _
                Optional ByRef vntEquipDiv As Variant, Optional ByRef vntAddUser As Variant, _
                Optional ByRef vntDocJud As Variant, Optional ByRef vntDocGf As Variant, _
                Optional ByRef vntDocCf As Variant, Optional ByRef blnCountFlg As Boolean = False, _
                Optional ByRef vntSecPlanDate As Variant, Optional ByRef vntReqCheckDate1 As Variant, _
                Optional ByRef vntReqCheckDate2 As Variant, Optional ByRef vntSecTestName As Variant _
                ) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim strStmt2                As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objCslDate              As OraField         '受診日
    Dim objRsvNo                As OraField         '予約番号
    Dim objPerId                As OraField         '当日ID
    Dim objDayId                As OraField         '個人ID
    Dim objPerKname             As OraField         'カナ氏名
    Dim objPerName              As OraField         '氏名
    Dim objGender               As OraField         '性別
    Dim objAge                  As OraField         '生年月日
    Dim objBirth                As OraField         '生年月日
    Dim objCscd                 As OraField         'コースコード
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名称
    Dim objJudCd                As OraField         '判定コード（フォロー確定時判定結果）
    Dim objRslJudCd             As OraField         '判定コード（健診判定結果）
    Dim objResultDispMode       As OraField         '検査結果表示モード
    Dim objEquipDiv             As OraField         '二次検査実施区分
    Dim objAddUser              As OraField         'フォーロ登録者
    Dim objDocJud               As OraField         '判定医
    Dim objDocGf                As OraField         '上部消化管内視鏡実施医
    Dim objDocCf                As OraField         '大腸内視鏡実施医

    Dim objSecPlanDate          As OraField         '二次検査予定日
    Dim objReqCheckDate1        As OraField         '第一勧奨日
    Dim objReqCheckDate2        As OraField         '第二勧奨日
    Dim objSecTestName          As OraField         '二次検査予定項目

    Dim vntArrCsldate()         As Variant          '受診日の配列
    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrPerId()           As Variant          '個人IDの配列
    Dim vntArrDayId()           As Variant          '当日IDの配列
    Dim vntArrPerKName()        As Variant          'カナ氏名の配列
    Dim vntArrPerName()         As Variant          '氏名の配列
    Dim vntArrGender()          As Variant          '性別の配列
    Dim vntArrAge()             As Variant          '年齢の配列
    Dim vntArrBirth()           As Variant          '生年月日の配列
    Dim vntArrCscd()            As Variant          'コースコードの配列
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim vntArrJudCd()           As Variant          '判定コード（フォロー確定時判定結果）の配列
    Dim vntArrRslJudCd()        As Variant          '判定コード（健診判定結果）の配列
    Dim vntArrResultDispMode()  As Variant          '検査結果表示モードの配列
    Dim vntArrEquipDiv()        As Variant          '二次検査実施区分の配列
    Dim vntArrAddUser()         As Variant          'フォーロ登録者の配列
    Dim vntArrDocJud()          As Variant          '判定医の配列
    Dim vntArrDocGf()           As Variant          '上部消化管内視鏡実施医の配列
    Dim vntArrDocCf()           As Variant          '大腸内視鏡実施医の配列

    Dim vntArrSecPlanDate()     As Variant          '二次検査予定日の配列
    Dim vntArrReqCheckDate1()   As Variant          '第一勧奨日の配列
    Dim vntArrReqCheckDate2()   As Variant          '第二勧奨日の配列
    Dim vntArrsetTestName()     As Variant          '二次検査予定項目の配列

    Dim dtmDate                 As Date             '作業用の日付
    Dim lngMaxRow               As Long             '最大行数
    Dim lngCount                As Long             'レコード数
    Dim i                       As Long             'ｲﾝﾃﾞｯｸｽ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntCsldate) Then vntCsldate = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntPerKname) Then vntPerKname = Empty
    If Not IsMissing(vntPerName) Then vntPerName = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntCscd) Then vntCscd = Empty
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = Empty
    If Not IsMissing(vntJudClassName) Then vntJudClassName = Empty
    If Not IsMissing(vntJudCd) Then vntJudCd = Empty
    If Not IsMissing(vntRslJudCd) Then vntRslJudCd = Empty
    If Not IsMissing(vntResultDispMode) Then vntResultDispMode = Empty
    If Not IsMissing(vntEquipDiv) Then vntEquipDiv = Empty
    If Not IsMissing(vntAddUser) Then vntAddUser = Empty
    If Not IsMissing(vntDocJud) Then vntDocJud = Empty
    If Not IsMissing(vntDocGf) Then vntDocGf = Empty
    If Not IsMissing(vntDocCf) Then vntDocCf = Empty
    
    If Not IsMissing(vntSecPlanDate) Then vntSecPlanDate = Empty
    If Not IsMissing(vntReqCheckDate1) Then vntReqCheckDate1 = Empty
    If Not IsMissing(vntReqCheckDate2) Then vntReqCheckDate2 = Empty
    If Not IsMissing(vntSecTestName) Then vntSecTestName = Empty

    lngCount = 0
    lngMaxRow = lngPageMaxLine + lngStartPos - 1
    
    '受診日の設定
    Select Case True
        '双方とも未指定の場合は何もしない
        Case strStartCslDate = 0 And strEndCslDate = 0
        
        '一方が未指定の場合、もう一方の値と同値として扱う
        Case strStartCslDate > 0 And strEndCslDate = 0
            strEndCslDate = strStartCslDate
        
        Case strStartCslDate = 0 And strEndCslDate > 0
            strStartCslDate = strEndCslDate
        
        '双方とも指定されている場合、大小逆転時に入れ替えを行う
        Case Else
            If strEndCslDate < strStartCslDate Then
                dtmDate = strStartCslDate
                strStartCslDate = strEndCslDate
                strEndCslDate = dtmDate
            End If
    End Select
    
    SelectExhortList = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", IIf(strStartCslDate = 0, Null, strStartCslDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", IIf(strEndCslDate = 0, Null, strEndCslDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "STRPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDPOS", lngMaxRow, ORAPARM_INPUT, ORATYPE_NUMBER
    
    If strJudClassCd <> "" Then
        objOraParam.Add "ITEMCD", strJudClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    objOraParam.Add "MONTH", lngPastMonth, ORAPARM_INPUT, ORATYPE_NUMBER
    If strUpdUser <> "" Then
        objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If

    '指定検索条件のフォロー対象者リストを取得する
    strStmt = ""
    strStmt = strStmt & vbLf & "SELECT ROWNUM SEQ                                                                               "
    strStmt = strStmt & vbLf & "      ,FINAL.CSLDATE                                                            AS CSLDATE      "
    strStmt = strStmt & vbLf & "      ,FINAL.RSVNO                                                              AS RSVNO        "
    strStmt = strStmt & vbLf & "      ,FINAL.PERID                                                              AS PERID        "
    strStmt = strStmt & vbLf & "      ,FINAL.DAYID                                                              AS DAYID        "
    strStmt = strStmt & vbLf & "      ,PERSON.LASTKNAME ||'　'|| PERSON.FIRSTKNAME                              AS PERKNAME     "
    strStmt = strStmt & vbLf & "      ,PERSON.LASTNAME ||'　'|| PERSON.FIRSTNAME                                AS PERNAME      "
    strStmt = strStmt & vbLf & "      ,DECODE(PERSON.GENDER,1,'男',2,'女')                                      AS GENDER       "
    strStmt = strStmt & vbLf & "      ,TRUNC(FINAL.AGE)                                                         AS AGE          "
    strStmt = strStmt & vbLf & "      ,TO_CHAR(PERSON.BIRTH,'EYY.mm.dd','NLS_CALENDAR=''Japanese Imperial''')   AS BIRTH        "
    strStmt = strStmt & vbLf & "      ,FINAL.CSCD                                                               AS CSCD         "
    strStmt = strStmt & vbLf & "      ,FINAL.JUDCLASSCD                                                         AS JUDCLASSCD   "
    strStmt = strStmt & vbLf & "      ,JUDCLASS.JUDCLASSNAME                                                    AS JUDCLASSNAME "
    strStmt = strStmt & vbLf & "      ,FINAL.JUDCD                                                              AS JUDCD        "
    strStmt = strStmt & vbLf & "      ,FINAL.RSLJUDCD                                                           AS RSLJUDCD     "
    strStmt = strStmt & vbLf & "      ,JUDCLASS.RESULTDISPMODE                          　　　　　　　　　　　　　AS RESULTDISPMODE  "
    strStmt = strStmt & vbLf & "      ,NVL(FINAL.SECEQUIPDIV,'')                                                AS SECEQUIPDIV  "
    
    strStmt = strStmt & vbLf & "      ,NVL(FINAL.SECPLANDATE,'')                                                AS SECPLANDATE    "
    strStmt = strStmt & vbLf & "      ,NVL(FINAL.REQCHECKDATE1,'')                                              AS REQCHECKDATE1  "
    strStmt = strStmt & vbLf & "      ,NVL(FINAL.REQCHECKDATE2,'')                                              AS REQCHECKDATE2  "
    strStmt = strStmt & vbLf & "      ,FOL_GET_SecRsvExam(FINAL.RSVNO,FINAL.JUDCLASSCD)                         AS SECTESTNAME  "
    
    strStmt = strStmt & vbLf & "      ,(SELECT USERNAME  FROM HAINSUSER                                                         "
    strStmt = strStmt & vbLf & "         WHERE HAINSUSER.USERID = FINAL.ADDUSER)                                AS ADDUSER      "
    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(FINAL.RSVNO,'30910' ,'00'),NULL,'-','','-',FC_GET_RESULT(FINAL.RSVNO,'30910' ,'00'))      AS DOC_JUD   "
    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(FINAL.RSVNO,'23320' ,'00'),NULL,'-','','-',FC_GET_RESULT(FINAL.RSVNO,'23320' ,'00'))      AS DOC_GF    "
    strStmt = strStmt & vbLf & "      ,DECODE(FC_GET_RESULT(FINAL.RSVNO,'23550' ,'00'),NULL,'-','','-',FC_GET_RESULT(FINAL.RSVNO,'23550' ,'00'))      AS DOC_CF    "
    
    strStmt = strStmt & vbLf & "  FROM (                                                                   "
    strStmt = strStmt & vbLf & "        SELECT CONSULT.CSLDATE                         AS CSLDATE          "
    strStmt = strStmt & vbLf & "              ,CONSULT.RSVNO                           AS RSVNO            "
    strStmt = strStmt & vbLf & "              ,CONSULT.PERID                           AS PERID            "
    strStmt = strStmt & vbLf & "              ,CONSULT.AGE                             AS AGE              "
    strStmt = strStmt & vbLf & "              ,CONSULT.CSCD                            AS CSCD             "
    strStmt = strStmt & vbLf & "              ,RECEIPT.DAYID                           AS DAYID            "
    strStmt = strStmt & vbLf & "              ,FOLLOW_INFO.JUDCLASSCD                  AS JUDCLASSCD       "
    strStmt = strStmt & vbLf & "              ,FOLLOW_INFO.JUDCD                       AS JUDCD            "
    strStmt = strStmt & vbLf & "              ,(SELECT JUDRSL.JUDCD  FROM JUDRSL                           "
    strStmt = strStmt & vbLf & "                 WHERE JUDRSL.RSVNO = FOLLOW_INFO.RSVNO                    "
    strStmt = strStmt & vbLf & "                   AND JUDRSL.JUDCLASSCD = FOLLOW_INFO.JUDCLASSCD          "
    strStmt = strStmt & vbLf & "               ) AS RSLJUDCD                                               "
    strStmt = strStmt & vbLf & "              ,FOLLOW_INFO.SECEQUIPDIV                 AS SECEQUIPDIV      "
    
    strStmt = strStmt & vbLf & "              ,FOLLOW_INFO.SECPLANDATE                 AS SECPLANDATE      "
    strStmt = strStmt & vbLf & "              ,FOLLOW_INFO.REQCHECKDATE1               AS REQCHECKDATE1    "
    strStmt = strStmt & vbLf & "              ,FOLLOW_INFO.REQCHECKDATE2               AS REQCHECKDATE2    "
    
    strStmt = strStmt & vbLf & "              ,FOLLOW_INFO.ADDUSER                     AS ADDUSER          "
    strStmt = strStmt & vbLf & "              ,(SELECT COUNT(FOLLOW_RSL.RSVNO)                             "
    strStmt = strStmt & vbLf & "                  FROM FOLLOW_RSL                                          "
    strStmt = strStmt & vbLf & "                 WHERE FOLLOW_RSL.RSVNO      = FOLLOW_INFO.RSVNO           "
    strStmt = strStmt & vbLf & "                   AND FOLLOW_RSL.JUDCLASSCD = FOLLOW_INFO.JUDCLASSCD      "
    strStmt = strStmt & vbLf & "               ) AS CNTRSVNO                                               "
    strStmt = strStmt & vbLf & "          FROM CONSULT                                                     "
    strStmt = strStmt & vbLf & "              ,RECEIPT                                                     "
    strStmt = strStmt & vbLf & "              ,FOLLOW_INFO                                                 "
    strStmt = strStmt & vbLf & "         WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE         "
    strStmt = strStmt & vbLf & "          AND CONSULT.CANCELFLG = 0                                        "
    strStmt = strStmt & vbLf & "          AND CONSULT.RSVNO = RECEIPT.RSVNO                                "
    strStmt = strStmt & vbLf & "          AND CONSULT.RSVNO = FOLLOW_INFO.RSVNO                            "
'    strStmt = strStmt & vbLf & "          AND TO_DATE(TO_CHAR(SYSDATE,'YYYYMMDD'),'YYYYMMDD') > ADD_MONTHS(CONSULT.CSLDATE,:MONTH) "
    strStmt = strStmt & vbLf & "          AND FOLLOW_INFO.SECEQUIPDIV < 9                              "
    strStmt = strStmt & vbLf & "          AND FOLLOW_INFO.ReqConfirmDate IS NULL                       "
    
    If strJudClassCd <> "" Then
        strStmt = strStmt & vbLf & "  AND FOLLOW_INFO.JUDCLASSCD = :ITEMCD                         "
    End If

    If strUpdUser <> "" Then
        strStmt = strStmt & vbLf & "  AND FOLLOW_INFO.ADDUSER = :UPDUSER                           "
    End If
    
    ''勧奨日条件チェック
    If Trim$(strCheckDateStat) = "0" Then           '未勧奨
        strStmt = strStmt & vbLf & "   AND FOLLOW_INFO.REQCHECKDATE1  IS NULL        "
        strStmt = strStmt & vbLf & "   AND FOLLOW_INFO.REQCHECKDATE2  IS NULL        "
    ElseIf Trim$(strCheckDateStat) = "1" Then       '1次勧奨
            strStmt = strStmt & vbLf & "   AND FOLLOW_INFO.REQCHECKDATE1  IS NOT NULL    "
    ElseIf Trim$(strCheckDateStat) = "2" Then       '2次勧奨
            strStmt = strStmt & vbLf & "   AND FOLLOW_INFO.REQCHECKDATE2  IS NOT NULL    "
    End If
    
    strStmt = strStmt & vbLf & "       ORDER BY CONSULT.CSLDATE, RECEIPT.DAYID, FOLLOW_INFO.JUDCLASSCD  "
    strStmt = strStmt & vbLf & "       ) FINAL                                                          "
    strStmt = strStmt & vbLf & "       ,PERSON                                                          "
    strStmt = strStmt & vbLf & "       ,JUDCLASS                                                        "
    strStmt = strStmt & vbLf & " WHERE FINAL.CNTRSVNO = 0                                               "
    strStmt = strStmt & vbLf & "   AND FINAL.PERID = PERSON.PERID                                       "
    strStmt = strStmt & vbLf & "   AND FINAL.JUDCLASSCD = JUDCLASS.JUDCLASSCD                           "
    
    strStmt = strStmt & vbLf & " ORDER BY FINAL.CSLDATE, FINAL.DAYID, FINAL.JUDCLASSCD"
    
    ''最初にﾚｺｰﾄﾞ件数だけ取得
    If blnCountFlg Then
        strStmt2 = "SELECT COUNT(DISTINCT RSVNO) FROM (" & strStmt & ")"
    Else
        strStmt2 = "SELECT COUNT(*) FROM (" & strStmt & ")"
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt2), ORADYN_READONLY + ORADYN_NOCACHE)
    lngCount = objOraDyna.Fields(0).Value

    strStmt = "SELECT * FROM (" & strStmt & ")" & vbLf
    strStmt = strStmt & vbLf & "WHERE SEQ BETWEEN :STRPOS AND :ENDPOS                               "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objCslDate = objFields("CSLDATE")
        Set objRsvNo = objFields("RSVNO")
        Set objPerId = objFields("PERID")
        Set objDayId = objFields("DAYID")
        Set objPerKname = objFields("PERKNAME")
        Set objPerName = objFields("PERNAME")
        Set objGender = objFields("GENDER")
        Set objAge = objFields("AGE")
        Set objBirth = objFields("BIRTH")
        Set objCscd = objFields("CSCD")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objJudCd = objFields("JUDCD")
        Set objRslJudCd = objFields("RSLJUDCD")
        Set objResultDispMode = objFields("RESULTDISPMODE")
        Set objEquipDiv = objFields("SECEQUIPDIV")
        Set objAddUser = objFields("ADDUSER")
        Set objDocJud = objFields("DOC_JUD")
        Set objDocGf = objFields("DOC_GF")
        Set objDocCf = objFields("DOC_CF")
        
        Set objSecPlanDate = objFields("SECPLANDATE")
        Set objReqCheckDate1 = objFields("REQCHECKDATE1")
        Set objReqCheckDate2 = objFields("REQCHECKDATE2")
        Set objSecTestName = objFields("SECTESTNAME")
        
        '配列形式で格納する
        i = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCsldate(i)
            ReDim Preserve vntArrRsvNo(i)
            ReDim Preserve vntArrPerId(i)
            ReDim Preserve vntArrDayId(i)
            ReDim Preserve vntArrPerKName(i)
            ReDim Preserve vntArrPerName(i)
            ReDim Preserve vntArrGender(i)
            ReDim Preserve vntArrAge(i)
            ReDim Preserve vntArrBirth(i)
            ReDim Preserve vntArrCscd(i)
            ReDim Preserve vntArrJudClassCd(i)
            ReDim Preserve vntArrJudClassName(i)
            ReDim Preserve vntArrJudCd(i)
            ReDim Preserve vntArrRslJudCd(i)
            ReDim Preserve vntArrResultDispMode(i)
            ReDim Preserve vntArrEquipDiv(i)
            ReDim Preserve vntArrAddUser(i)
            ReDim Preserve vntArrDocJud(i)
            ReDim Preserve vntArrDocGf(i)
            ReDim Preserve vntArrDocCf(i)
            
            ReDim Preserve vntArrSecPlanDate(i)
            ReDim Preserve vntArrReqCheckDate1(i)
            ReDim Preserve vntArrReqCheckDate2(i)
            ReDim Preserve vntArrsetTestName(i)
            
            vntArrCsldate(i) = objCslDate.Value & ""
            vntArrRsvNo(i) = objRsvNo.Value & ""
            vntArrPerId(i) = objPerId.Value & ""
            vntArrDayId(i) = objDayId.Value & ""
            vntArrPerKName(i) = objPerKname.Value & ""
            vntArrPerName(i) = objPerName.Value & ""
            vntArrGender(i) = objGender.Value & ""
            vntArrAge(i) = objAge.Value & ""
            vntArrBirth(i) = objBirth.Value & ""
            vntArrCscd(i) = objCscd.Value & ""
            vntArrJudClassCd(i) = objJudClassCd.Value & ""
            vntArrJudClassName(i) = objJudClassName.Value & ""
            vntArrJudCd(i) = objJudCd.Value & ""
            vntArrRslJudCd(i) = objRslJudCd.Value & ""
            vntArrResultDispMode(i) = objResultDispMode.Value & ""
            vntArrEquipDiv(i) = objEquipDiv.Value & ""
            vntArrAddUser(i) = objAddUser.Value & ""
            vntArrDocJud(i) = objDocJud.Value & ""
            vntArrDocGf(i) = objDocGf.Value & ""
            vntArrDocCf(i) = objDocCf.Value & ""
            
            vntArrSecPlanDate(i) = objSecPlanDate.Value & ""
            vntArrReqCheckDate1(i) = objReqCheckDate1.Value & ""
            vntArrReqCheckDate2(i) = objReqCheckDate2.Value & ""
            vntArrsetTestName(i) = objSecTestName.Value & ""
            
            i = i + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        
        If Not IsMissing(vntCsldate) Then vntCsldate = vntArrCsldate
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
        If Not IsMissing(vntPerKname) Then vntPerKname = vntArrPerKName
        If Not IsMissing(vntPerName) Then vntPerName = vntArrPerName
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntBirth) Then vntBirth = vntArrBirth
        If Not IsMissing(vntCscd) Then vntCscd = vntArrCscd
        If Not IsMissing(vntJudClassCd) Then vntJudClassCd = vntArrJudClassCd
        If Not IsMissing(vntJudClassName) Then vntJudClassName = vntArrJudClassName
        If Not IsMissing(vntJudCd) Then vntJudCd = vntArrJudCd
        If Not IsMissing(vntRslJudCd) Then vntRslJudCd = vntArrRslJudCd
        If Not IsMissing(vntResultDispMode) Then vntResultDispMode = vntArrResultDispMode
        If Not IsMissing(vntEquipDiv) Then vntEquipDiv = vntArrEquipDiv
        If Not IsMissing(vntAddUser) Then vntAddUser = vntArrAddUser
        If Not IsMissing(vntDocJud) Then vntDocJud = vntArrDocJud
        If Not IsMissing(vntDocGf) Then vntDocGf = vntArrDocGf
        If Not IsMissing(vntDocCf) Then vntDocCf = vntArrDocCf
        
        If Not IsMissing(vntSecPlanDate) Then vntSecPlanDate = vntArrSecPlanDate
        If Not IsMissing(vntReqCheckDate1) Then vntReqCheckDate1 = vntArrReqCheckDate1
        If Not IsMissing(vntReqCheckDate2) Then vntReqCheckDate2 = vntArrReqCheckDate2
        If Not IsMissing(vntSecTestName) Then vntSecTestName = vntArrsetTestName
        
    End If
    
    Set objCslDate = Nothing
    Set objRsvNo = Nothing
    Set objPerId = Nothing
    Set objDayId = Nothing
    Set objPerKname = Nothing
    Set objPerName = Nothing
    Set objGender = Nothing
    Set objAge = Nothing
    Set objBirth = Nothing
    Set objCscd = Nothing
    Set objJudClassCd = Nothing
    Set objJudClassName = Nothing
    Set objJudCd = Nothing
    Set objRslJudCd = Nothing
    Set objResultDispMode = Nothing
    Set objEquipDiv = Nothing
    Set objAddUser = Nothing
    Set objDocJud = Nothing
    Set objDocGf = Nothing
    Set objDocCf = Nothing
    
    Set objSecPlanDate = Nothing
    Set objReqCheckDate1 = Nothing
    Set objReqCheckDate2 = Nothing
    Set objSecTestName = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectExhortList = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectExhortList = -1

    'イベントログ書き込み
    WriteErrorLog "Follow.SelectExhortList"

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

' 機能　　 : 受診者別検査項目別結果データ取得
'
' 引数　　 : (In)     strRsvNo              予約番号
' 　　　　   (In)     strItemCd             検査項目コード
'
' 戻り値　 : 予約番号（RsvNo）＋検査項目（ItemCd）別結果値
'
' 備考　　 :
'
Public Function GetResult(ByVal lngRsvNo As Long, ByVal strItemCd As String) As String

    Dim objOraDyna          As OraDynaset           '## ダイナセット
    Dim objOraParam         As OraParameters        '## OraParametersオブジェクト
    Dim objFields           As OraFields            '## フィールドコレクション
    Dim strSql              As String
    
    Dim strRet              As String
    Dim i                   As Integer
    Dim lngCount            As Long
    
    strRet = ""
    
    '## エラーハンドラの設定
    On Error GoTo ErrorHandle

    '## キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    With objOraParam
        .Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "ITEMCD", strItemCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    End With

'### 検査項目別検査結果抽出
    strSql = ""
'### 2016.09.13 張 結果表記を成績書標記に合わせて印刷できるように修正 STR ###
'    strSql = strSql & " SELECT NVL(SENTENCE.LONGSTC, NVL(PERRSL.RESULT,'')) RESULT  " & vbCrLf
    strSql = strSql & " SELECT NVL(SENTENCE.REPTSTC, '') RESULT             " & vbCrLf
'### 2016.09.13 張 結果表記を成績書標記に合わせて印刷できるように修正 END ###
    strSql = strSql & "       ,PERRSL.RSLCMTNAME         RSLCMTNAME         " & vbCrLf
    strSql = strSql & "   FROM (                                            " & vbCrLf
    strSql = strSql & "         SELECT ITEM_C.ITEMCD        ITEMCD          " & vbCrLf
    strSql = strSql & "               ,ITEM_C.SUFFIX        SUFFIX          " & vbCrLf
    strSql = strSql & "               ,ITEM_C.STCITEMCD     STCITEMCD       " & vbCrLf
    strSql = strSql & "               ,ITEM_C.ITEMNAME      ITEMNAME        " & vbCrLf
    strSql = strSql & "               ,ITEM_C.ITEMTYPE      ITEMTYPE        " & vbCrLf
    strSql = strSql & "               ,ITEM_C.RESULTTYPE    RESULTTYPE      " & vbCrLf
    strSql = strSql & "               ,RSL.RESULT           RESULT          " & vbCrLf
    strSql = strSql & "               ,RSLCMT.RSLCMTNAME    RSLCMTNAME      " & vbCrLf
    strSql = strSql & "           FROM RSL                                  " & vbCrLf
    strSql = strSql & "               ,ITEM_C                               " & vbCrLf
    strSql = strSql & "               ,RSLCMT                               " & vbCrLf
    strSql = strSql & "          WHERE RSL.RSVNO    = :RSVNO                " & vbCrLf
    strSql = strSql & "            AND RSL.ITEMCD   = :ITEMCD               " & vbCrLf
    strSql = strSql & "            AND RSL.ITEMCD   = ITEM_C.ITEMCD         " & vbCrLf
    strSql = strSql & "            AND RSL.SUFFIX   = ITEM_C.SUFFIX         " & vbCrLf
    strSql = strSql & "            AND RSL.RSLCMTCD1= RSLCMT.RSLCMTCD(+)    " & vbCrLf
    strSql = strSql & "        ) PERRSL                                     " & vbCrLf
    strSql = strSql & "       ,SENTENCE                                     " & vbCrLf
    strSql = strSql & "  WHERE PERRSL.STCITEMCD  = SENTENCE.ITEMCD(+)       " & vbCrLf
    strSql = strSql & "    AND PERRSL.ITEMTYPE   = SENTENCE.ITEMTYPE(+)     " & vbCrLf
    strSql = strSql & "    AND PERRSL.RESULT     = SENTENCE.STCCD(+)        "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strSql), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        '配列形式で格納する
        lngCount = 0
        Set objFields = objOraDyna.Fields
        
        Do Until objOraDyna.EOF

            If Trim(objFields("RESULT").Value) <> "" Then
                If lngCount > 0 Then
                    strRet = strRet & "、" & Trim(objFields("RESULT").Value)
                Else
                    strRet = strRet & Trim(objFields("RESULT").Value)
                End If
            End If
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
        Set objFields = Nothing
    
    Else
        strRet = "未検査"
        
    End If
    

    '## バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    Set objOraDyna = Nothing
    
    GetResult = strRet
    
    Exit Function
    
ErrorHandle:

    GetResult = strRet

    'イベントログ書き込み
    WriteErrorLog "Follow.GetResult"

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

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
