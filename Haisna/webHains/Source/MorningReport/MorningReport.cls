VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "MorningReport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext                 As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession              As OraSession      'OraSessionオブジェクト
Private mobjOraDb                   As OraDatabase     'OraDatabaseオブジェクト


'
' 機能　　 : 指定日の時間帯別受診者情報を取得する
'
' 引数　　 : (In)     lngCslYear   　   受診年
' 　　　　   (In)     lngCslMonth   　  受診月
' 　　　　   (In)     lngCslDay         受診日
' 　　　　   (In)     strCsCd           コースコード
' 　　　　   (In)     blnNeedUnReceipt  未受付者取得フラグ
' 　　　　   (Out)    vntRsvGrpName     予約群名称
' 　　　　   (Out)    vntMaleCount      男性人数
' 　　　　   (Out)    vntFemaleCount    女性人数
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectRsvFraDaily( _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByVal lngCslDay As Long, _
    Optional ByVal strCsCd As String = "", _
    Optional ByVal blnNeedUnReceipt As Boolean = False, _
    Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntMaleCount As Variant, _
    Optional ByRef vntFemaleCount As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvGrpName          As OraField      '予約群名称
    Dim objMaleCount        As OraField         '男性人数
    Dim objFemaleCount      As OraField         '女性人数
    
    Dim vntArrRsvGrpName()     As Variant       '予約群名称の配列
    Dim vntArrMaleCount()   As Variant          '男性人数の配列
    Dim vntArrFemaleCount()   As Variant        '女性人数の配列
    Dim lngCount            As Long             'レコード数
    
    Dim dtmCslDate          As Date             '受診年月日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
    If Not IsMissing(vntMaleCount) Then vntMaleCount = Empty
    If Not IsMissing(vntFemaleCount) Then vntFemaleCount = Empty
    lngCount = 0
    
    '受診年月日の編集
    dtmCslDate = CDate(CStr(lngCslYear) & "/" & CStr(lngCslMonth) & "/" & CStr(lngCslDay))
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Trim(dtmCslDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '時間帯別受診者情報を取得
    strStmt = "SELECT (SELECT RSVGRPNAME                                    " & vbLf & _
              "          FROM RSVGRP                                        " & vbLf & _
              "         WHERE RSVGRPCD = CONSULTLIST.RSVGRPCD) RSVGRPNAME,  " & vbLf & _
              "       MAX(CONSULTLIST.MALECOUNT) MALECOUNT,                 " & vbLf & _
              "       MAX(CONSULTLIST.FEMALECOUNT) FEMALECOUNT              "
    
    strStmt = strStmt & vbLf & _
              "  FROM (                                                     " & vbLf & _
              "         SELECT RSVGRPCD,                                    " & vbLf & _
              "                DECODE(GENDER, 1, COUNT(*), 0) MALECOUNT,    " & vbLf & _
              "                DECODE(GENDER, 2, COUNT(*), 0) FEMALECOUNT   " & vbLf & _
              "           FROM (                                            " & vbLf & _
              "                  SELECT RSVGRP.RSVGRPCD,                    " & vbLf & _
              "                         PERSON.GENDER,                      " & vbLf & _
              "                         NVL(RECEIPT.DAYID, 0) CHECKDAYID    " & vbLf & _
              "                    FROM RSVGRP,                             " & vbLf & _
              "                         PERSON,                             " & vbLf & _
              "                         RECEIPT,                            " & vbLf & _
              "                         CONSULT                             " & vbLf & _
              "                   WHERE CONSULT.CSLDATE   = :CSLDATE        "
    'コースコードの指定あり
    If strCsCd <> "" Then
        strStmt = strStmt & vbLf & _
              "                     AND CONSULT.CSCD = :CSCD                "
    End If
    strStmt = strStmt & vbLf & _
              "                     AND CONSULT.CANCELFLG = '0'                 " & vbLf & _
              "                     AND CONSULT.PERID     = PERSON.PERID        " & vbLf & _
              "                     AND CONSULT.RSVGRPCD  = RSVGRP.RSVGRPCD     " & vbLf & _
              "                     AND CONSULT.CSLDATE   = RECEIPT.CSLDATE(+)  " & vbLf & _
              "                     AND CONSULT.RSVNO     = RECEIPT.RSVNO(+)    " & vbLf & _
              "                ) "
    '未受付者を除く
    If blnNeedUnReceipt = False Then
        strStmt = strStmt & vbLf & _
              "          WHERE CHECKDAYID > 0                               "
    End If
    strStmt = strStmt & vbLf & _
              "         GROUP BY RSVGRPCD, GENDER                           "
    
    '予約群テーブルをもとに空の時間帯別受診者情報を作成し、結合
    strStmt = strStmt & vbLf & _
              "         UNION ALL                           " & vbLf & _
              "         SELECT RSVGRP.RSVGRPCD,             " & vbLf & _
              "                0 MALECOUNT,                 " & vbLf & _
              "                0 FEMALECOUNT                " & vbLf & _
              "          FROM  RSVGRP                       " & vbLf & _
              "       ) CONSULTLIST"
    
    strStmt = strStmt & vbLf & _
              "GROUP BY RSVGRPCD                            " & vbLf & _
              "ORDER BY RSVGRPCD                            "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvGrpName = objFields("RSVGRPNAME")
        Set objMaleCount = objFields("MALECOUNT")
        Set objFemaleCount = objFields("FEMALECOUNT")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvGrpName(lngCount)
            ReDim Preserve vntArrMaleCount(lngCount)
            ReDim Preserve vntArrFemaleCount(lngCount)
            
            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
            vntArrMaleCount(lngCount) = objMaleCount.Value & ""
            vntArrFemaleCount(lngCount) = objFemaleCount.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
        If Not IsMissing(vntMaleCount) Then vntMaleCount = vntArrMaleCount
        If Not IsMissing(vntFemaleCount) Then vntFemaleCount = vntArrFemaleCount
        
    End If
    
    SelectRsvFraDaily = lngCount
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectRsvFraDaily = -1
    
    'イベントログ書き込み
    WriteErrorLog "MorningReport.SelectRsvFraDaily"
    
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
' 機能　　 : 指定日の同伴者（お連れ様）受診者情報を取得する
'
' 引数　　 : (In)     lngCslYear   　   受診年
' 　　　　   (In)     lngCslMonth   　  受診月
' 　　　　   (In)     lngCslDay         受診日
' 　　　　   (In)     strCsCd           コースコード
' 　　　　   (In)     blnNeedUnReceipt  未受付者取得フラグ
' 　　　　   (Out)    vntRsvNo          予約番号
' 　　　　   (Out)    vntDayID          当日ＩＤ
' 　　　　   (Out)    vntPerID          個人ＩＤ
' 　　　　   (Out)    vntLastName       姓
' 　　　　   (Out)    vntFirstName      名
' 　　　　   (Out)    vntCompFlag       同伴者フラグ（1:同伴者, 2:お連れ様）
' 　　　　   (Out)    vntCompRsvNo      予約番号（同伴者またはお連れ様）
' 　　　　   (Out)    vntCompDayID      当日ＩＤ（同伴者またはお連れ様）
' 　　　　   (Out)    vntCompPerID      個人ＩＤ（同伴者またはお連れ様）
' 　　　　   (Out)    vntCompLastName   姓（同伴者またはお連れ様）
' 　　　　   (Out)    vntCompFirstName  名（同伴者またはお連れ様）
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectFriendsDaily( _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByVal lngCslDay As Long, _
    Optional ByVal strCsCd As String = "", _
    Optional ByVal blnNeedUnReceipt As Boolean = False, _
    Optional ByRef vntRsvNo As Variant, Optional ByRef vntDayID As Variant, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntCompFlag As Variant, _
    Optional ByRef vntCompRsvNo As Variant, Optional ByRef vntCompDayId As Variant, _
    Optional ByRef vntCompPerId As Variant, Optional ByRef vntCompLastName As Variant, Optional ByRef vntCompFirstName As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    Dim strStmtList         As String           'SQLステートメント(お連れ様リスト)
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objDayID            As OraField         '当日ＩＤ
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    Dim objCompFlag         As OraField         '同伴者フラグ
    Dim objCompRsvNo        As OraField         '予約番号（同伴者またはお連れ様）
    Dim objCompDayId        As OraField         '当日ＩＤ（同伴者またはお連れ様）
    Dim objCompPerId        As OraField         '個人ＩＤ（同伴者またはお連れ様）
    Dim objCompLastName     As OraField         '姓（同伴者またはお連れ様）
    Dim objCompFirstName    As OraField         '名（同伴者またはお連れ様）
    
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrDayID()       As Variant          '当日ＩＤの配列
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrLastName()    As Variant          '姓の配列
    Dim vntArrFirstName()   As Variant          '名の配列
    Dim vntArrCompFlag()    As Variant          '同伴者フラグの配列
    Dim vntArrCompRsvNo()   As Variant          '予約番号（同伴者またはお連れ様）の配列
    Dim vntArrCompDayId()   As Variant          '当日ＩＤ（同伴者またはお連れ様）の配列
    Dim vntArrCompPerId()   As Variant          '個人ＩＤ（同伴者またはお連れ様）の配列
    Dim vntArrCompLastName()    As Variant      '姓（同伴者またはお連れ様）の配列
    Dim vntArrCompFirstName()   As Variant      '名（同伴者またはお連れ様）の配列
    Dim lngCount            As Long             'レコード数
    
    Dim dtmCslDate          As Date             '受診年月日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntDayID) Then vntDayID = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntCompFlag) Then vntCompFlag = Empty
    If Not IsMissing(vntCompRsvNo) Then vntCompRsvNo = Empty
    If Not IsMissing(vntCompDayId) Then vntCompDayId = Empty
    If Not IsMissing(vntCompPerId) Then vntCompPerId = Empty
    If Not IsMissing(vntCompLastName) Then vntCompLastName = Empty
    If Not IsMissing(vntCompFirstName) Then vntCompFirstName = Empty
    lngCount = 0
    
    '受診年月日の編集
    dtmCslDate = CDate(CStr(lngCslYear) & "/" & CStr(lngCslMonth) & "/" & CStr(lngCslDay))
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Trim(dtmCslDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '同伴者（お連れ様）受診者情報を取得
    strStmt = "SELECT FRIENDLIST1.RSVNO RSVNO,              " & vbLf & _
              "       FRIENDLIST1.DAYID DAYID,              " & vbLf & _
              "       FRIENDLIST1.PERID PERID,              " & vbLf & _
              "       FRIENDLIST1.LASTNAME LASTNAME,        " & vbLf & _
              "       FRIENDLIST1.FIRSTNAME FIRSTNAME,      " & vbLf & _
              "       NVL2(FRIENDLIST1.COMPPERID,           " & vbLf & _
              "            DECODE(FRIENDLIST1.COMPPERID, NVL(FRIENDLIST2.PERID,0), '1', '2'),   " & vbLf & _
              "            '2') COMPFLAG,                   " & vbLf & _
              "       FRIENDLIST2.RSVNO COMPRSVNO,          " & vbLf & _
              "       FRIENDLIST2.DAYID COMPDAYID,          " & vbLf & _
              "       FRIENDLIST2.PERID COMPPERID,          " & vbLf & _
              "       FRIENDLIST2.LASTNAME COMPLASTNAME,    " & vbLf & _
              "       FRIENDLIST2.FIRSTNAME COMPFIRSTNAME   " & vbLf & _
              "  FROM                                       "


    'お連れ様を取得 ****************************************************Start
    strStmtList = _
             " SELECT FRIENDS.CSLDATE,                      " & vbLf & _
             "        FRIENDS.SEQ,                          " & vbLf & _
             "        FRIENDS.RSVNO,                        " & vbLf & _
             "        RECEIPT.DAYID,                        " & vbLf & _
             "        PERSON.PERID,                         " & vbLf & _
             "        PERSON.LASTNAME,                      " & vbLf & _
             "        PERSON.FIRSTNAME,                     " & vbLf & _
             "        PERSON.COMPPERID                      " & vbLf & _
             "   FROM FRIENDS,                              " & vbLf & _
             "        CONSULT, RECEIPT, PERSON              " & vbLf & _
             "  WHERE FRIENDS.CSLDATE = :CSLDATE            " & vbLf & _
             "    AND FRIENDS.RSVNO   = CONSULT.RSVNO       " & vbLf & _
             "    AND CONSULT.CANCELFLG = '0'               " & vbLf & _
             "    AND CONSULT.CSLDATE = RECEIPT.CSLDATE(+)  " & vbLf & _
             "    AND CONSULT.RSVNO   = RECEIPT.RSVNO(+)    " & vbLf & _
             "    AND CONSULT.PERID   = PERSON.PERID        "
    'コースコードの指定あり
    If strCsCd <> "" Then
        strStmtList = strStmtList & vbLf & _
             "   AND CONSULT.CSCD      = :CSCD              "
    End If
    '未受付者を除く
    If blnNeedUnReceipt = False Then
        strStmtList = strStmtList & vbLf & _
             "   AND RECEIPT.DAYID IS NOT NULL              "
    End If
    'お連れ様を取得 ****************************************************End
    
    strStmt = strStmt & vbLf & _
             "       (                                      " & vbLf & _
             strStmtList & _
             "       ) FRIENDLIST1,                         " & vbLf & _
             "       (                                      " & vbLf & _
             strStmtList & _
             "       ) FRIENDLIST2                          "

    '同伴者情報
    strStmt = strStmt & vbLf & _
             " WHERE FRIENDLIST1.CSLDATE = FRIENDLIST2.CSLDATE  " & vbLf & _
             "   AND FRIENDLIST1.SEQ     = FRIENDLIST2.SEQ      " & vbLf & _
             "   AND FRIENDLIST1.RSVNO  <> FRIENDLIST2.RSVNO    "
    strStmt = strStmt & vbLf & _
             "ORDER BY DAYID NULLS LAST,                    " & vbLf & _
             "         COMPFLAG, COMPDAYID NULLS LAST,      " & vbLf & _
             "         PERID, COMPPERID                     "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objDayID = objFields("DAYID")
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objCompFlag = objFields("COMPFLAG")
        Set objCompRsvNo = objFields("COMPRSVNO")
        Set objCompDayId = objFields("COMPDAYID")
        Set objCompPerId = objFields("COMPPERID")
        Set objCompLastName = objFields("COMPLASTNAME")
        Set objCompFirstName = objFields("COMPFIRSTNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrDayID(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrCompFlag(lngCount)
            ReDim Preserve vntArrCompRsvNo(lngCount)
            ReDim Preserve vntArrCompDayId(lngCount)
            ReDim Preserve vntArrCompPerId(lngCount)
            ReDim Preserve vntArrCompLastName(lngCount)
            ReDim Preserve vntArrCompFirstName(lngCount)
            
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrDayID(lngCount) = objDayID.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrCompFlag(lngCount) = objCompFlag.Value & ""
            vntArrCompRsvNo(lngCount) = objCompRsvNo.Value & ""
            vntArrCompDayId(lngCount) = objCompDayId.Value & ""
            vntArrCompPerId(lngCount) = objCompPerId.Value & ""
            vntArrCompLastName(lngCount) = objCompLastName.Value & ""
            vntArrCompFirstName(lngCount) = objCompFirstName.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntDayID) Then vntDayID = vntArrDayID
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntCompFlag) Then vntCompFlag = vntArrCompFlag
        If Not IsMissing(vntCompRsvNo) Then vntCompRsvNo = vntArrCompRsvNo
        If Not IsMissing(vntCompDayId) Then vntCompDayId = vntArrCompDayId
        If Not IsMissing(vntCompPerId) Then vntCompPerId = vntArrCompPerId
        If Not IsMissing(vntCompLastName) Then vntCompLastName = vntArrCompLastName
        If Not IsMissing(vntCompFirstName) Then vntCompFirstName = vntArrCompFirstName
    End If
    
    SelectFriendsDaily = lngCount
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectFriendsDaily = -1
    
    'イベントログ書き込み
    WriteErrorLog "MorningReport.SelectFriendsDaily"
    
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
' 機能　　 : 指定日の同姓受診者情報を取得する
'
' 引数　　 : (In)     lngCslYear   　   受診年
' 　　　　   (In)     lngCslMonth   　  受診月
' 　　　　   (In)     lngCslDay         受診日
' 　　　　   (In)     strCsCd           コースコード
' 　　　　   (In)     blnNeedUnReceipt  未受付者取得フラグ
' 　　　　   (Out)    vntPerID          個人ＩＤ
' 　　　　   (Out)    vntDayID          当日ＩＤ
' 　　　　   (Out)    vntLastName       姓
' 　　　　   (Out)    vntFirstName      名
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectSameNameDaily( _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByVal lngCslDay As Long, _
    Optional ByVal strCsCd As String = "", _
    Optional ByVal blnNeedUnReceipt As Boolean = False, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntDayID As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objDayID            As OraField         '当日ＩＤ
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrDayID()       As Variant          '当日ＩＤの配列
    Dim vntArrLastName()    As Variant          '姓の配列
    Dim vntArrFirstName()   As Variant          '名の配列
    Dim lngCount            As Long             'レコード数
    
    Dim dtmCslDate          As Date             '受診年月日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntDayID) Then vntDayID = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    lngCount = 0
    
    '受診年月日の編集
    dtmCslDate = CDate(CStr(lngCslYear) & "/" & CStr(lngCslMonth) & "/" & CStr(lngCslDay))
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Trim(dtmCslDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '同姓受診者情報を取得
    strStmt = "SELECT PER1.PERID     PERID,             " & vbLf & _
              "       PER1.DAYID     DAYID,             " & vbLf & _
              "       PER1.LASTNAME  LASTNAME,          " & vbLf & _
              "       PER1.FIRSTNAME FIRSTNAME          " & vbLf & _
              "  FROM                                   "
    
    strStmt = strStmt & vbLf & _
              "       (SELECT PERID,                                        " & vbLf & _
              "               DAYID,                                        " & vbLf & _
              "               LASTNAME,                                     " & vbLf & _
              "               FIRSTNAME,                                    " & vbLf & _
              "               LASTKNAME,                                    " & vbLf & _
              "               FIRSTKNAME                                    " & vbLf & _
              "          FROM (SELECT CONSULT.PERID,                        " & vbLf & _
              "                       RECEIPT.DAYID,                        " & vbLf & _
              "                       PERSON.LASTNAME,                      " & vbLf & _
              "                       PERSON.FIRSTNAME,                     " & vbLf & _
              "                       PERSON.LASTKNAME,                     " & vbLf & _
              "                       PERSON.FIRSTKNAME,                    " & vbLf & _
              "                       NVL(RECEIPT.DAYID, 0) CHECKDAYID      " & vbLf & _
              "                  FROM PERSON,                               " & vbLf & _
              "                       RECEIPT,                              " & vbLf & _
              "                       CONSULT                               " & vbLf & _
              "                 WHERE CONSULT.CSLDATE   = :CSLDATE          "
    'コースコードの指定あり
    If strCsCd <> "" Then
        strStmt = strStmt & vbLf & _
              "                   AND CONSULT.CSCD      = :CSCD             "
    End If
    strStmt = strStmt & vbLf & _
              "                   AND CONSULT.CANCELFLG = '0'               " & vbLf & _
              "                   AND CONSULT.PERID     = PERSON.PERID      " & vbLf & _
              "                   AND CONSULT.CSLDATE   = RECEIPT.CSLDATE(+)" & vbLf & _
              "                   AND CONSULT.RSVNO     = RECEIPT.RSVNO(+)  " & vbLf & _
              "               )"
    '未受付者を除く
    If blnNeedUnReceipt = False Then
        strStmt = strStmt & vbLf & _
              "         WHERE CHECKDAYID > 0                                "
    End If
    strStmt = strStmt & vbLf & _
              "       ) PER1                                                "
    
    '同姓のチェック
    strStmt = strStmt & vbLf & _
              " WHERE EXISTS       " & vbLf & _
              "       (SELECT CONSULT.PERID                         " & vbLf & _
              "          FROM PERSON,                               " & vbLf & _
              "               RECEIPT,                              " & vbLf & _
              "               CONSULT                               " & vbLf & _
              "         WHERE CONSULT.CSLDATE   = :CSLDATE          "
    'コースコードの指定あり
    If strCsCd <> "" Then
        strStmt = strStmt & vbLf & _
              "           AND CONSULT.CSCD      = :CSCD             "
    End If
    strStmt = strStmt & vbLf & _
              "           AND CONSULT.CANCELFLG = '0'               " & vbLf & _
              "           AND CONSULT.PERID     = PERSON.PERID      " & vbLf & _
              "           AND CONSULT.CSLDATE   = RECEIPT.CSLDATE(+)" & vbLf & _
              "           AND CONSULT.RSVNO     = RECEIPT.RSVNO(+)  " & vbLf & _
              "           AND PERSON.PERID     <> PER1.PERID        " & vbLf & _
              "           AND PERSON.LASTKNAME  = PER1.LASTKNAME    " & vbLf & _
              "           AND PERSON.FIRSTKNAME = PER1.FIRSTKNAME   " & vbLf & _
              "       )"

    'ソート順（名前順）の指定
    strStmt = strStmt & vbLf & _
              " ORDER BY PER1.LASTKNAME, PER1.FIRSTKNAME,   " & vbLf & _
              "          PER1.DAYID NULLS LAST, PER1.PERID  "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objDayID = objFields("DAYID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrDayID(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrDayID(lngCount) = objDayID.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntDayID) Then vntDayID = vntArrDayID
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
    End If
    
    SelectSameNameDaily = lngCount
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectSameNameDaily = -1
    
    'イベントログ書き込み
    WriteErrorLog "MorningReport.SelectSameNameDaily"
    
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
' 機能　　 : 指定日のセット別受診者情報を取得する
'
' 引数　　 : (In)     lngCslYear   　   受診年
' 　　　　   (In)     lngCslMonth   　  受診月
' 　　　　   (In)     lngCslDay         受診日
' 　　　　   (In)     strCsCd           コースコード
' 　　　　   (In)     blnNeedUnReceipt  未受付者取得フラグ
' 　　　　   (Out)    vntSetName        セット名
' 　　　　   (Out)    vntMaleCount      男性人数
' 　　　　   (Out)    vntFemaleCount    女性人数
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectSetCountDaily( _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByVal lngCslDay As Long, _
    Optional ByVal strCsCd As String = "", _
    Optional ByVal blnNeedUnReceipt As Boolean = False, _
    Optional ByRef vntSetName As Variant, _
    Optional ByRef vntMaleCount As Variant, _
    Optional ByRef vntFemaleCount As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSetName          As OraField         '開始時間
    Dim objMaleCount        As OraField         '男性人数
    Dim objFemaleCount      As OraField         '女性人数
    
    Dim vntArrSetName()     As Variant          '開始時間の配列
    Dim vntArrMaleCount()   As Variant          '男性人数の配列
    Dim vntArrFemaleCount() As Variant          '女性人数の配列
    Dim lngCount            As Long             'レコード数
    
    Dim dtmCslDate          As Date             '受診年月日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntSetName) Then vntSetName = Empty
    If Not IsMissing(vntMaleCount) Then vntMaleCount = Empty
    If Not IsMissing(vntFemaleCount) Then vntFemaleCount = Empty
    lngCount = 0
    
    '受診年月日の編集
    dtmCslDate = CDate(CStr(lngCslYear) & "/" & CStr(lngCslMonth) & "/" & CStr(lngCslDay))
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Trim(dtmCslDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'セット別受診者情報を取得
    strStmt = "SELECT SETNAME,                                                  " & vbLf & _
              "       MAX(MALECOUNT) MALECOUNT,                                 " & vbLf & _
              "       MAX(FEMALECOUNT) FEMALECOUNT                              "
    
    strStmt = strStmt & vbLf & _
              "  FROM (                                                         " & vbLf & _
              "         SELECT SORTKEY,                                         " & vbLf & _
              "                SETNAME,                                         " & vbLf & _
              "                DECODE(GENDER, 1, COUNT(*), 0) MALECOUNT,        " & vbLf & _
              "                DECODE(GENDER, 2, COUNT(*), 0) FEMALECOUNT       " & vbLf & _
              "           FROM (                                                "
    strStmt = strStmt & vbLf & _
              "                  SELECT DISTINCT                                        " & vbLf & _
              "                         SETGRP.SORTKEY,                                 " & vbLf & _
              "                         SETGRP.SETNAME,                                 " & vbLf & _
              "                         CONSULTVIEW.PERID,                              " & vbLf & _
              "                         CONSULTVIEW.GENDER                              " & vbLf & _
              "                    FROM (                                               " & vbLf & _
              "                           SELECT PERSON.PERID,                          " & vbLf & _
              "                                  PERSON.GENDER,                         " & vbLf & _
              "                                  CONSULTITEMLIST.ITEMCD,                " & vbLf & _
              "                                  NVL(RECEIPT.DAYID, 0) CHECKDAYID       " & vbLf & _
              "                             FROM PERSON,                                " & vbLf & _
              "                                  RECEIPT,                               " & vbLf & _
              "                                  CONSULTITEMLIST                        " & vbLf & _
              "                            WHERE CONSULTITEMLIST.CSLDATE   = :CSLDATE   "
    'コースコードの指定あり
    If strCsCd <> "" Then
        strStmt = strStmt & vbLf & _
              "                              AND CONSULTITEMLIST.CSCD      = :CSCD      "
    End If
    strStmt = strStmt & vbLf & _
              "                              AND CONSULTITEMLIST.CANCELFLG = '0'                " & vbLf & _
              "                              AND CONSULTITEMLIST.PERID     = PERSON.PERID       " & vbLf & _
              "                              AND CONSULTITEMLIST.CSLDATE   = RECEIPT.CSLDATE(+) " & vbLf & _
              "                              AND CONSULTITEMLIST.RSVNO     = RECEIPT.RSVNO(+)   " & vbLf & _
              "                         ) CONSULTVIEW, "
     strStmt = strStmt & vbLf & _
              "                         ( SELECT FREE.FREEFIELD1 SORTKEY,               " & vbLf & _
              "                                  FREE.FREEFIELD2 SETNAME,               " & vbLf & _
              "                                  GRP_R.ITEMCD                           " & vbLf & _
              "                             FROM GRP_R,                                 " & vbLf & _
              "                                  FREE                                   " & vbLf & _
              "                            WHERE FREE.FREECD   LIKE 'MORSETGRP%'        " & vbLf & _
              "                              AND FREE.FREEFIELD3  = GRP_R.GRPCD         " & vbLf & _
              "                         ) SETGRP " & vbLf & _
              "                   WHERE CONSULTVIEW.ITEMCD     = SETGRP.ITEMCD  "
    '未受付者を除く
    If blnNeedUnReceipt = False Then
        strStmt = strStmt & vbLf & _
              "                     AND CONSULTVIEW.CHECKDAYID > 0              "
    End If
    strStmt = strStmt & vbLf & _
              "                ) " & vbLf & _
              "         GROUP BY SORTKEY, SETNAME, GENDER                       "
    
    '空のセット別受診者情報を作成し、結合
    strStmt = strStmt & vbLf & _
              "         UNION ALL                                               " & vbLf & _
              "         SELECT FREE.FREEFIELD1 SORTKEY,                         " & vbLf & _
              "                FREE.FREEFIELD2 SETNAME,                         " & vbLf & _
              "                0 MALECOUNT,                                     " & vbLf & _
              "                0 FEMALECOUNT                                    " & vbLf & _
              "           FROM FREE                                             " & vbLf & _
              "          WHERE FREE.FREECD   LIKE 'MORSETGRP%'                  " & vbLf & _
              "       ) "
    
    strStmt = strStmt & vbLf & _
              "GROUP BY SORTKEY, SETNAME                                        " & vbLf & _
              "ORDER BY SORTKEY, SETNAME "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSetName = objFields("SETNAME")
        Set objMaleCount = objFields("MALECOUNT")
        Set objFemaleCount = objFields("FEMALECOUNT")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrSetName(lngCount)
            ReDim Preserve vntArrMaleCount(lngCount)
            ReDim Preserve vntArrFemaleCount(lngCount)
            
            vntArrSetName(lngCount) = objSetName.Value & ""
            vntArrMaleCount(lngCount) = objMaleCount.Value & ""
            vntArrFemaleCount(lngCount) = objFemaleCount.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        If Not IsMissing(vntSetName) Then vntSetName = vntArrSetName
        If Not IsMissing(vntMaleCount) Then vntMaleCount = vntArrMaleCount
        If Not IsMissing(vntFemaleCount) Then vntFemaleCount = vntArrFemaleCount
        
    End If
    
    SelectSetCountDaily = lngCount
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectSetCountDaily = -1
    
    'イベントログ書き込み
    WriteErrorLog "MorningReport.SelectSetCountDaily"
    
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
' 機能　　 : 指定日のコメント情報を取得する
'
' 引数　　 : (In)     lngCslYear   　     受診年
' 　　　　   (In)     lngCslMonth   　    受診月
' 　　　　   (In)     lngCslDay           受診日
' 　　　　   (In)     strCsCd             コースコード
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn          表示対象
' 　　　　   (In)     strUserId           ユーザＩＤ
' 　　　　   (Out)    vntRsvNo            予約番号
' 　　　　   (Out)    vntSortNo           表示順（1:個人、2:受診情報）
' 　　　　   (Out)    vntSeq              seq
' 　　　　   (Out)    vntPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (Out)    vntPubNoteDivName   受診情報ノート分類名称
' 　　　　   (Out)    vntDefaultDispKbn   表示対象区分初期値
' 　　　　   (Out)    vntOnlyDispKbn      表示対象区分しばり
' 　　　　   (Out)    vntDispKbn       　 表示対象区分
' 　　　　   (Out)    vntUpdDate       　 登録日時
' 　　　　   (Out)    vntUpdUser       　 登録者
' 　　　　   (Out)    vntUserName      　 登録者名
' 　　　　   (Out)    vntBoldFlg        　太字区分
' 　　　　   (Out)    vntPubNote        　ノート
' 　　　　   (Out)    vntDispColor        表示色
' 　　　　   (Out)    vntCslDate          受診日
' 　　　　   (Out)    vntCsName           コース名
' 　　　　   (Out)    vntDayID            当日ＩＤ
' 　　　　   (Out)    vntLastName         姓
' 　　　　   (Out)    vntFirstName        名
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectPubNoteDaily( _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByVal lngCslDay As Long, _
    ByVal strCsCd As String, _
    ByVal blnNeedUnReceipt As Boolean, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUserId As String, _
    ByRef vntRsvNo As Variant, ByRef vntSortNo As Variant, _
    ByRef vntSeq As Variant, ByRef vntPubNoteDivCd As Variant, ByRef vntPubNoteDivName As Variant, _
    ByRef vntDefaultDispKbn As Variant, ByRef vntOnlyDispKbn As Variant, ByRef vntDispKbn As Variant, _
    ByRef vntUpdDate As Variant, ByRef vntUpdUser As Variant, ByRef vntUserName As Variant, _
    ByRef vntBoldFlg As Variant, ByRef vntPubNote As Variant, ByRef vntDispColor As Variant, _
    ByRef vntCslDate As Variant, ByRef vntCsName As Variant, ByRef vntDayID As Variant, _
    ByRef vntLastName As Variant, ByRef vntFirstName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objSortNo           As OraField         '表示順
    Dim objSeq              As OraField         'seq
    Dim objPubNoteDivCd     As OraField         '受診情報ノート分類コード
    Dim objPubNoteDivName   As OraField         '受診情報ノート分類名称
    Dim objDefaultDispKbn   As OraField         '表示対象区分初期値
    Dim objOnlyDispKbn      As OraField         '表示対象区分しばり
    Dim objDispKbn          As OraField         '表示対象区分
    Dim objUpdDate          As OraField         '登録日時
    Dim objUpdUser          As OraField         '登録者
    Dim objUserName         As OraField         '登録者名
    Dim objBoldFlg          As OraField         '太字区分
    Dim objPubNote          As OraField         'ノート
    Dim objDispColor        As OraField         '表示色
    Dim objCslDate          As OraField         '受診日
    Dim objCsName           As OraField         'コース名
    Dim objDayID            As OraField         '当日ID
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名

    Dim vntArrRsvNo()           As Variant      '予約番号
    Dim vntArrSortNo()         As Variant      '表示順
    Dim vntArrSeq()             As Variant      'seq
    Dim vntArrPubNoteDivCd()    As Variant      '受診情報ノート分類コード
    Dim vntArrPubNoteDivName()  As Variant      '受診情報ノート分類名称
    Dim vntArrDefaultDispKbn()  As Variant      '表示対象区分初期値
    Dim vntArrOnlyDispKbn()     As Variant      '表示対象区分しばり
    Dim vntArrDispKbn()         As Variant      '表示対象区分
    Dim vntArrUpdDate()         As Variant      '登録日時
    Dim vntArrUpdUser()         As Variant      '登録者
    Dim vntArrUserName()        As Variant      '登録者名
    Dim vntArrBoldFlg()         As Variant      '太字区分
    Dim vntArrPubNote()         As Variant      'ノート
    Dim vntArrDispColor()       As Variant      '表示色
    Dim vntArrCslDate()         As Variant      '受診日
    Dim vntArrCsName()          As Variant      'コース名
    Dim vntArrDayID()           As Variant      '当日ID
    Dim vntArrLastName()        As Variant      '性
    Dim vntArrFirstName()       As Variant      '名
    
    Dim dtmCslDate          As Date             '受診年月日
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    lngCount = 0
       
    '受診年月日の編集
    dtmCslDate = CDate(CStr(lngCslYear) & "/" & CStr(lngCslMonth) & "/" & CStr(lngCslDay))
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Trim(dtmCslDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USERID", Trim(strUserId), ORAPARM_INPUT, ORATYPE_VARCHAR2
 
    'ノートを一括取得
    strStmt = "SELECT PUBNOTE.RSVNO,                        " & vbLf & _
              "       PUBNOTE.SORTNO,                       " & vbLf & _
              "       PUBNOTE.SEQ,                          " & vbLf & _
              "       PUBNOTE.PUBNOTEDIVCD,                 " & vbLf & _
              "       PUBNOTEDIVVIEW.PUBNOTEDIVNAME,        " & vbLf & _
              "       PUBNOTEDIVVIEW.DEFAULTDISPKBN,        " & vbLf & _
              "       PUBNOTEDIVVIEW.ONLYDISPKBN,           " & vbLf & _
              "       PUBNOTE.DISPKBN,                      " & vbLf & _
              "       PUBNOTE.UPDDATE,                      " & vbLf & _
              "       PUBNOTE.UPDUSER,                      " & vbLf & _
              "       HAINSUSER.USERNAME,                   " & vbLf & _
              "       PUBNOTE.BOLDFLG,                      " & vbLf & _
              "       PUBNOTE.PUBNOTE,                      " & vbLf & _
              "       PUBNOTE.DISPCOLOR,                    " & vbLf & _
              "       PUBNOTE.CSLDATE,                      " & vbLf & _
              "       RECEIPT.DAYID,                        " & vbLf & _
              "       COURSE_P.CSNAME,                      " & vbLf & _
              "       PERSON.LASTNAME,                      " & vbLf & _
              "       PERSON.FIRSTNAME                      " & vbLf & _
              "  FROM HAINSUSER,                            " & vbLf & _
              "       RECEIPT,                              " & vbLf & _
              "       COURSE_P,                             " & vbLf & _
              "       PERSON,                               " & vbLf & _
              "       (                                     "
    
    '個人ノートを取得 ****************************************************Start
    strStmt = strStmt & vbLf & _
              "         SELECT 1 SORTNO,                    " & vbLf & _
              "                CONSULT.RSVNO,               " & vbLf & _
              "                CONSULT.PERID,               " & vbLf & _
              "                CONSULT.CSLDATE,             " & vbLf & _
              "                CONSULT.CSCD,                " & vbLf & _
              "                PERPUBNOTE.SEQ,              " & vbLf & _
              "                PERPUBNOTE.PUBNOTEDIVCD,     " & vbLf & _
              "                PERPUBNOTE.DISPKBN,          " & vbLf & _
              "                PERPUBNOTE.UPDDATE,          " & vbLf & _
              "                PERPUBNOTE.UPDUSER,          " & vbLf & _
              "                PERPUBNOTE.BOLDFLG,          " & vbLf & _
              "                PERPUBNOTE.PUBNOTE,          " & vbLf & _
              "                PERPUBNOTE.DISPCOLOR         "
    strStmt = strStmt & vbLf & _
              "           FROM CONSULT,                     " & vbLf & _
              "                PERPUBNOTE                   "
    strStmt = strStmt & vbLf & _
              "          WHERE CONSULT.CSLDATE = :CSLDATE       " & vbLf & _
              "            AND CONSULT.PERID = PERPUBNOTE.PERID " & vbLf & _
              "            AND PERPUBNOTE.DELFLG IS NULL        "

    '個人ノートを取得 ****************************************************End
    
    strStmt = strStmt & vbLf & _
              "         UNION ALL                           "
    
    '受診情報ノートを取得 ************************************************Start
    strStmt = strStmt & vbLf & _
              "         SELECT 2 SORTNO ,                   " & vbLf & _
              "                CONSULT.RSVNO,               " & vbLf & _
              "                CONSULT.PERID,               " & vbLf & _
              "                CONSULT.CSLDATE,             " & vbLf & _
              "                CONSULT.CSCD,                " & vbLf & _
              "                CSLPUBNOTE.SEQ,              " & vbLf & _
              "                CSLPUBNOTE.PUBNOTEDIVCD,     " & vbLf & _
              "                CSLPUBNOTE.DISPKBN,          " & vbLf & _
              "                CSLPUBNOTE.UPDDATE,          " & vbLf & _
              "                CSLPUBNOTE.UPDUSER,          " & vbLf & _
              "                CSLPUBNOTE.BOLDFLG,          " & vbLf & _
              "                CSLPUBNOTE.PUBNOTE,          " & vbLf & _
              "                CSLPUBNOTE.DISPCOLOR         "
    strStmt = strStmt & vbLf & _
              "           FROM CONSULT,                     " & vbLf & _
              "                CSLPUBNOTE                   "
    strStmt = strStmt & vbLf & _
              "          WHERE CONSULT.CSLDATE = :CSLDATE       " & vbLf & _
              "            AND CONSULT.RSVNO = CSLPUBNOTE.RSVNO " & vbLf & _
              "            AND CSLPUBNOTE.DELFLG IS NULL        "
    '受診情報ノートを取得 ************************************************End
    
    strStmt = strStmt & vbLf & _
              "       ) PUBNOTE,                                            "
    
    strStmt = strStmt & vbLf & _
              "       ( SELECT PUBNOTEDIVCD,                                " & vbLf & _
              "                PUBNOTEDIVNAME,                              " & vbLf & _
              "                DECODE(DEFAULTDISPKBN, AUTHNOTE,             " & vbLf & _
              "                             DEFAULTDISPKBN,                 " & vbLf & _
              "                             DEFNOTEDISPKBN ) DEFAULTDISPKBN," & vbLf & _
              "                ONLYDISPKBN                                  " & vbLf & _
              "           FROM (SELECT PUBNOTEDIV.PUBNOTEDIVCD,             " & vbLf & _
              "                        PUBNOTEDIV.PUBNOTEDIVNAME,           " & vbLf & _
              "                        NVL(PUBNOTEDIV.DEFAULTDISPKBN, USERVIEW.DEFNOTEDISPKBN) DEFAULTDISPKBN,  " & vbLf & _
              "                        PUBNOTEDIV.ONLYDISPKBN,              " & vbLf & _
              "                        USERVIEW.AUTHNOTE,                   " & vbLf & _
              "                        USERVIEW.DEFNOTEDISPKBN              " & vbLf & _
              "                   FROM PUBNOTEDIV,                          " & vbLf & _
              "                        (SELECT AUTHNOTE, DEFNOTEDISPKBN     " & vbLf & _
              "                           FROM HAINSUSER                    " & vbLf & _
              "                          WHERE USERID= :USERID) USERVIEW    " & vbLf & _
              "                  WHERE (USERVIEW.AUTHNOTE = 1 AND (PUBNOTEDIV.ONLYDISPKBN = 1 OR PUBNOTEDIV.ONLYDISPKBN IS NULL)) " & vbLf & _
              "                     OR (USERVIEW.AUTHNOTE = 2 AND (PUBNOTEDIV.ONLYDISPKBN = 2 OR PUBNOTEDIV.ONLYDISPKBN IS NULL)) " & vbLf & _
              "                     OR (USERVIEW.AUTHNOTE = 3 )             " & vbLf & _
              "                 )                                           " & vbLf & _
              "       ) PUBNOTEDIVVIEW                                      "

    strStmt = strStmt & vbLf & _
              " WHERE PUBNOTE.PUBNOTEDIVCD = PUBNOTEDIVVIEW.PUBNOTEDIVCD    " & vbLf & _
              "   AND PUBNOTE.UPDUSER      = HAINSUSER.USERID               " & vbLf & _
              "   AND PUBNOTE.CSLDATE      = RECEIPT.CSLDATE(+)             " & vbLf & _
              "   AND PUBNOTE.RSVNO        = RECEIPT.RSVNO(+)               " & vbLf & _
              "   AND PUBNOTE.CSCD         = COURSE_P.CSCD(+)               " & vbLf & _
              "   AND PUBNOTE.PERID        = PERSON.PERID                   "
    
    'コースコードの指定あり
    If strCsCd <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND PUBNOTE.CSCD = :CSCD                  "
    End If
    
    '未受付者を除く
    If blnNeedUnReceipt = False Then
        strStmt = strStmt & vbLf & _
              "   AND RECEIPT.DAYID IS NOT NULL             "
    End If
    
    '受診情報ノート分類コード指定あり？
    If strPubNoteDivCd <> "" Then
        'キー値の設定
        objOraParam.Add "PUBNOTEDIV", strPubNoteDivCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
              "   AND PUBNOTE.PUBNOTEDIVCD = :PUBNOTEDIV    "
    End If
    
    '表示対象指定あり？
    If lngDispKbn <> 0 Then
        'キー値の設定
        objOraParam.Add "DISPKBN", lngDispKbn, ORAPARM_INPUT, ORATYPE_NUMBER
        '表示対象=3は「共通」なので検索条件に含む
        strStmt = strStmt & vbLf & _
              "   AND ( PUBNOTE.DISPKBN = :DISPKBN          " & vbLf & _
              "      OR PUBNOTE.DISPKBN = 3 )               "
    End If

    strStmt = strStmt & vbLf & _
              " ORDER BY RECEIPT.DAYID NULLS LAST, PERSON.PERID,    " & vbLf & _
              "          PUBNOTE.SORTNO, PUBNOTE.SEQ                "
    
    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objSortNo = objFields("SORTNO")
        Set objSeq = objFields("SEQ")
        Set objPubNoteDivCd = objFields("PUBNOTEDIVCD")
        Set objPubNoteDivName = objFields("PUBNOTEDIVNAME")
        Set objDefaultDispKbn = objFields("DEFAULTDISPKBN")
        Set objOnlyDispKbn = objFields("ONLYDISPKBN")
        Set objDispKbn = objFields("DISPKBN")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objBoldFlg = objFields("BOLDFLG")
        Set objPubNote = objFields("PUBNOTE")
        Set objDispColor = objFields("DISPCOLOR")
        Set objCslDate = objFields("CSLDATE")
        Set objCsName = objFields("CSNAME")
        Set objDayID = objFields("DAYID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrSortNo(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrPubNoteDivCd(lngCount)
            ReDim Preserve vntArrPubNoteDivName(lngCount)
            ReDim Preserve vntArrDefaultDispKbn(lngCount)
            ReDim Preserve vntArrOnlyDispKbn(lngCount)
            ReDim Preserve vntArrDispKbn(lngCount)
            ReDim Preserve vntArrUpdDate(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)
            ReDim Preserve vntArrUserName(lngCount)
            ReDim Preserve vntArrBoldFlg(lngCount)
            ReDim Preserve vntArrPubNote(lngCount)
            ReDim Preserve vntArrDispColor(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrDayID(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
           
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrSortNo(lngCount) = objSortNo.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrPubNoteDivCd(lngCount) = objPubNoteDivCd.Value & ""
            vntArrPubNoteDivName(lngCount) = objPubNoteDivName.Value & ""
            vntArrDefaultDispKbn(lngCount) = objDefaultDispKbn.Value & ""
            vntArrOnlyDispKbn(lngCount) = objOnlyDispKbn.Value & ""
            vntArrDispKbn(lngCount) = objDispKbn.Value & ""
            vntArrUpdDate(lngCount) = objUpdDate.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""
            vntArrUserName(lngCount) = objUserName.Value & ""
            vntArrBoldFlg(lngCount) = objBoldFlg.Value & ""
            vntArrPubNote(lngCount) = objPubNote.Value & ""
            vntArrDispColor(lngCount) = objDispColor.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrDayID(lngCount) = objDayID.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntRsvNo = vntArrRsvNo
        vntSortNo = vntArrSortNo
        vntSeq = vntArrSeq
        vntPubNoteDivCd = vntArrPubNoteDivCd
        vntPubNoteDivName = vntArrPubNoteDivName
        vntDefaultDispKbn = vntArrDefaultDispKbn
        vntOnlyDispKbn = vntArrOnlyDispKbn
        vntDispKbn = vntArrDispKbn
        vntUpdDate = vntArrUpdDate
        vntUpdUser = vntArrUpdUser
        vntUserName = vntArrUserName
        vntBoldFlg = vntArrBoldFlg
        vntPubNote = vntArrPubNote
        vntDispColor = vntArrDispColor
        vntCslDate = vntArrCslDate
        vntCsName = vntArrCsName
        vntDayID = vntArrDayID
        vntLastName = vntArrLastName
        vntFirstName = vntArrFirstName
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectPubNoteDaily = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectPubNoteDaily = -1

    'イベントログ書き込み
    WriteErrorLog "MorningReport.SelectPubNoteDaily"
    
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
