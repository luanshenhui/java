VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "MngAccuracy"
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
' 機能      : 検索条件を満たすグループの一覧を取得する
'
' 引数　　 : (In)     dtmCslDate
' 　　　　   (In)     lngGenderMode     表示対象性別：1:男、2:女、3:男女別、4:男女マージ
' 　　　　   (Out)    vntSeq
' 　　　　   (Out)    vntItemCd
' 　　　　   (Out)    vntSuffix
' 　　　　   (Out)    vntItemName
' 　　　　   (Out)    vntGender
' 　　　　   (Out)    vntResultCount
' 　　　　   (Out)    vntVal_L
' 　　　　   (Out)    vntVal_S
' 　　　　   (Out)    vntVal_H
' 　　　　   (Out)    vntPercent_L
' 　　　　   (Out)    vntPercent_H
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectMngAccuracy( _
    ByVal dtmCslDate As Date, _
    ByVal lngGenderMode As Long, _
    Optional ByRef vntSeq As Variant, _
    Optional ByRef vntItemCd As Variant, _
    Optional ByRef vntSuffix As Variant, _
    Optional ByRef vntItemName As Variant, _
    Optional ByRef vntGender As Variant, _
    Optional ByRef vntResultCount As Variant, _
    Optional ByRef vntVal_L As Variant, _
    Optional ByRef vntVal_S As Variant, _
    Optional ByRef vntVal_H As Variant, _
    Optional ByRef vntPercent_L As Variant, _
    Optional ByRef vntPercent_H As Variant _
) As Long

    Dim objOraParam                As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                 As OraDynaset       'ダイナセット
    Dim strStmt                    As String           'SQLステートメント

    Dim objFields                  As OraFields        'フィールドオブジェクト
    Dim objSeq                     As OraField
    Dim objItemCd                  As OraField
    Dim objSuffix                  As OraField
    Dim objItemName                As OraField
    Dim objGender                  As OraField
    Dim objResultCount             As OraField
    Dim objVal_L                   As OraField
    Dim objVal_S                   As OraField
    Dim objVal_H                   As OraField
    Dim objPercent_L               As OraField
    Dim objPercent_H               As OraField

    Dim lngCount                   As Long             '関数戻り値

    Dim vntArrSeq()                As Variant
    Dim vntArrItemCd()             As Variant
    Dim vntArrSuffix()             As Variant
    Dim vntArrItemName()           As Variant
    Dim vntArrGender()             As Variant
    Dim vntArrResultCount()        As Variant
    Dim vntArrVal_L()              As Variant
    Dim vntArrVal_S()              As Variant
    Dim vntArrVal_H()              As Variant
    Dim vntArrPercent_L()          As Variant
    Dim vntArrPercent_H()          As Variant

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期値
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntResultCount) Then vntResultCount = Empty
    If Not IsMissing(vntVal_L) Then vntVal_L = Empty
    If Not IsMissing(vntVal_S) Then vntVal_S = Empty
    If Not IsMissing(vntVal_H) Then vntVal_H = Empty
    If Not IsMissing(vntPercent_L) Then vntPercent_L = Empty
    If Not IsMissing(vntPercent_H) Then vntPercent_H = Empty

    lngCount = 0

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "GENDERMODE", lngGenderMode, ORAPARM_INPUT, ORATYPE_NUMBER

    strStmt = strStmt & "SELECT SEQ,   ITEMCD, SUFFIX, ITEMNAME, GENDER, RESULTCOUNT,      " & vbLf
    strStmt = strStmt & "       VAL_L, VAL_S, VAL_H,                                       " & vbLf
    strStmt = strStmt & "       TRUNC(VAL_L / RESULTCOUNT * 100, 1) PERCENT_L,             " & vbLf
    strStmt = strStmt & "       TRUNC(VAL_H / RESULTCOUNT * 100, 1) PERCENT_H              " & vbLf
    strStmt = strStmt & "  FROM                                                            " & vbLf
    strStmt = strStmt & "        (                                                         " & vbLf
    strStmt = strStmt & "            SELECT SEQ, ITEMCD, SUFFIX, ITEMNAME, GENDER,         " & vbLf
    strStmt = strStmt & "                   COUNT(*)        RESULTCOUNT,                   " & vbLf
    strStmt = strStmt & "                   NVL(SUM(VAL_L), 0)      VAL_L,                 " & vbLf
    strStmt = strStmt & "                   NVL(SUM(VAL_S), 0)      VAL_S,                 " & vbLf
    strStmt = strStmt & "                   NVL(SUM(VAL_H), 0)      VAL_H                  " & vbLf
    strStmt = strStmt & "              FROM (                                              " & vbLf
    strStmt = strStmt & "                    SELECT SEQ, ITEMCD, SUFFIX, ITEMNAME, GENDER, " & vbLf
    strStmt = strStmt & "                           DECODE(STDFLG, 'L', 1,                 " & vbLf
    strStmt = strStmt & "                                          'D', 1, NULL) VAL_L,    " & vbLf
    strStmt = strStmt & "                           DECODE(STDFLG, 'S', 1, NULL) VAL_S,    " & vbLf
    strStmt = strStmt & "                           DECODE(STDFLG, 'U', 1,                 " & vbLf
    strStmt = strStmt & "                                          'H', 1,                 " & vbLf
    strStmt = strStmt & "                                          '@', 1,                 " & vbLf
    strStmt = strStmt & "                                          'X', 1,                 " & vbLf
    strStmt = strStmt & "                                          '*', 1, NULL) VAL_H     " & vbLf
    strStmt = strStmt & "                      FROM (                                      " & vbLf
    strStmt = strStmt & "                            SELECT DISTINCT RSL.RSVNO,            " & vbLf
    '男女マージモードの場合、性別を強制的に3にしてサマリ
    strStmt = strStmt & "                                   DECODE(:GENDERMODE, 4, 3,                              " & vbLf
    strStmt = strStmt & "                                                        PERSON.GENDER) GENDER,            " & vbLf
    strStmt = strStmt & "                                   GRPINFO.SEQ, RSL.ITEMCD, RSL.SUFFIX, GRPINFO.ITEMNAME, " & vbLf
    strStmt = strStmt & "                                   GetTrueStdFlg(RSL.STDVALUECD, RSL.ITEMCD, RSL.SUFFIX,  " & vbLf
    strStmt = strStmt & "                                                 RSL.RESULT, PERSON.GENDER, CONSULT.AGE,  " & vbLf
    strStmt = strStmt & "                                                 CONSULT.CSLDATE, CONSULT.CSCD) STDFLG    " & vbLf
    strStmt = strStmt & "                              FROM                                                        " & vbLf
    strStmt = strStmt & "                                   (SELECT GRP_I.ITEMCD, GRP_I.SUFFIX, ITEM_C.ITEMTYPE,   " & vbLf
    strStmt = strStmt & "                                           ITEM_C.ITEMNAME, GRP_I.SEQ                     " & vbLf
    strStmt = strStmt & "                                      FROM ITEM_C, GRP_I                                  " & vbLf
    strStmt = strStmt & "                                     WHERE GRP_I.GRPCD   = 'X070'                         " & vbLf
    strStmt = strStmt & "                                       AND ITEM_C.ITEMCD = GRP_I.ITEMCD                   " & vbLf
    strStmt = strStmt & "                                       AND ITEM_C.SUFFIX = GRP_I.SUFFIX                   " & vbLf
    strStmt = strStmt & "                                       AND ITEM_C.ITEMTYPE IN (0,5)                       " & vbLf
    strStmt = strStmt & "                                   ) GRPINFO,                                             " & vbLf
    strStmt = strStmt & "                                   RSL, PERSON, RECEIPT, CONSULT                          " & vbLf
    strStmt = strStmt & "                             WHERE CONSULT.CSLDATE = :CSLDATE                             " & vbLf
    strStmt = strStmt & "                               AND PERSON.PERID    = CONSULT.PERID                        " & vbLf
    
    '男性のみの場合
    If lngGenderMode = 1 Then
        strStmt = strStmt & "                           AND PERSON.GENDER   = 1             " & vbLf
    End If
    
    '女性のみの場合
    If lngGenderMode = 2 Then
        strStmt = strStmt & "                           AND PERSON.GENDER   = 2             " & vbLf
    End If
    
    strStmt = strStmt & "                               AND RECEIPT.RSVNO   = CONSULT.RSVNO                        " & vbLf
    strStmt = strStmt & "                               AND RECEIPT.COMEDATE IS NOT NULL                           " & vbLf
    strStmt = strStmt & "                               AND RSL.RSVNO   = RECEIPT.RSVNO                            " & vbLf
    strStmt = strStmt & "                               AND RSL.ITEMCD  = GRPINFO.ITEMCD                           " & vbLf
    strStmt = strStmt & "                               AND RSL.SUFFIX  = GRPINFO.SUFFIX                           " & vbLf
    strStmt = strStmt & "                               AND RSL.RESULT IS NOT NULL                                 " & vbLf
    strStmt = strStmt & "                        )                                                                 " & vbLf
    strStmt = strStmt & "                    )                                                                     " & vbLf
    strStmt = strStmt & "            GROUP BY SEQ, ITEMCD, SUFFIX, ITEMNAME, GENDER                                " & vbLf
    strStmt = strStmt & "        )"

    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSeq = objFields("SEQ")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objGender = objFields("GENDER")
        Set objResultCount = objFields("RESULTCOUNT")
        Set objVal_L = objFields("VAL_L")
        Set objVal_S = objFields("VAL_S")
        Set objVal_H = objFields("VAL_H")
        Set objPercent_L = objFields("PERCENT_L")
        Set objPercent_H = objFields("PERCENT_H")

        '配列形式で格納する
        Do Until objOraDyna.EOF

            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrResultCount(lngCount)
            ReDim Preserve vntArrVal_L(lngCount)
            ReDim Preserve vntArrVal_S(lngCount)
            ReDim Preserve vntArrVal_H(lngCount)
            ReDim Preserve vntArrPercent_L(lngCount)
            ReDim Preserve vntArrPercent_H(lngCount)

            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrGender(lngCount) = objGender.Value & ""
            vntArrResultCount(lngCount) = objResultCount.Value & ""
            vntArrVal_L(lngCount) = objVal_L.Value & ""
            vntArrVal_S(lngCount) = objVal_S.Value & ""
            vntArrVal_H(lngCount) = objVal_H.Value & ""
            vntArrPercent_L(lngCount) = objPercent_L.Value & ""
            vntArrPercent_H(lngCount) = objPercent_H.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext

        Loop

        '戻り値の設定
        If Not IsMissing(vntSeq) Then vntSeq = vntArrSeq
        If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
        If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
        If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntResultCount) Then vntResultCount = vntArrResultCount
        If Not IsMissing(vntVal_L) Then vntVal_L = vntArrVal_L
        If Not IsMissing(vntVal_S) Then vntVal_S = vntArrVal_S
        If Not IsMissing(vntVal_H) Then vntVal_H = vntArrVal_H
        If Not IsMissing(vntPercent_L) Then vntPercent_L = vntArrPercent_L
        If Not IsMissing(vntPercent_H) Then vntPercent_H = vntArrPercent_H

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    SelectMngAccuracy = lngCount

    Exit Function

ErrorHandle:

    SelectMngAccuracy = -1

    'イベントログ書き込み
    WriteErrorLog "MngAccuracy.SelectMngAccuracy"

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
