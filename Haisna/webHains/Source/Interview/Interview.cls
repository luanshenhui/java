VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Interview"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号: SL-UI-Y0101-101
'修正日  ：2010.07.23
'担当者  ：TCS)田村
'修正内容: 総合コメント並び替え追加

'管理番号: SL-HS-Y0101-003
'修正日  ：2011.01.20
'担当者  ：FJTH)村田
'修正内容: 連携先サーバ変更に伴う修正（RayPax⇒横河）

'管理番号: SL-SN-Y0101-006
'修正日  ：2011.11.17
'担当者  ：FJTH)村田
'修正内容: ソートの修正


Option Explicit

Implements ObjectControl

Private mobjContext                 As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession              As OraSession      'OraSessionオブジェクト
Private mobjOraDb                   As OraDatabase     'OraDatabaseオブジェクト

'桁数
Private Const LENGTH_TOTALJUDCMT_RSVNO    As Integer = 9      '予約番号
Private Const LENGTH_TOTALJUDCMT_DISPMODE As Integer = 2      '表示分類
Private Const LENGTH_TOTALJUDCMT_SEQ      As Integer = 3      '表示順
Private Const LENGTH_TOTALJUDCMT_JUDCMTCD As Integer = 8      '判定コメントコード

Private Const FOOD_JUDCLASSCD As Integer = 51                   '食習慣
Private Const MENU_JUDCLASSCD As Integer = 52                   '献立
Private Const LIFE_JUDCLASSCD As Integer = 50                   '生活指導

Private Const NYUBOU_JUDCLASSCD As Integer = 24                 '乳房
Private Const NYUSYOKU_JUDCLASSCD As Integer = 54               '乳房触診
Private Const NYUXSEN_JUDCLASSCD As Integer = 55                '乳房Ｘ線
Private Const NYUCHOU_JUDCLASSCD As Integer = 56                '乳房超音波

Private Const SDI_RSLCNT                  As Integer = 33     '多変量解析に必要な検査項目件数
Private Const STATISTICS_GRPCD            As String = "X050"  '多変量解析用検査項目のグループコード


'
' 機能　　 : 指定された予約番号の個人ＩＤの受診歴一覧を取得する
'
' 引数　　 : (In)     lngRsvNo            予約番号（今回分）
' 　　　　   (In)     blnReceptOnly       True指定時は受付済み受診情報のみを取得対象とする
' 　　　　   (In)     lngLastDspMode      前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
' 　　　　   (In)     vntCsGrp            前回歴表示モード＝0のとき、null
' 　　　　                                               ＝1のとき、コースコード
' 　　　　                                               ＝2のとき、コースグループコード
' 　　　　   (In)     lngGetRowCount      取得件数(未指定時は全件)
' 　　　　   (In)     lngSelectMode       データ取得モード（0:今回分含む、1:前回分以前）
' 　　　　   (Out)    vntPerId            個人ＩＤ
' 　　　　   (Out)    vntRsvNo            予約番号
' 　　　　   (Out)    vntCslDate          受診日
' 　　　　   (Out)    vntCsCd             コースコード
' 　　　　   (Out)    vntCsName           コース名
' 　　　　   (Out)    vntCsSName          コース略称
' 　　　　   (In)     lngDateSort    日付順(0:今回が先頭、1:今回が最後)
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsultHistory( _
    ByVal lngRsvNo As Long, _
    Optional ByVal blnReceptOnly As Boolean = False, _
    Optional ByVal lngLastDspMode As Long, _
    Optional ByVal vntCsGrp As Variant, _
    Optional ByVal lngGetRowCount As Long = 0, _
    Optional ByVal lngSelectMode As Long = 0, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntCsSName As Variant, _
    Optional ByVal lngDateSort As Long = 0 _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objRsvNo            As OraField         '予約番号
    Dim objCslDate          As OraField         '受診日
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objCsSName          As OraField         'コース略称

    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrCsCd()        As Variant          'コースコードの配列
    Dim vntArrCsName()      As Variant          'コース名の配列
    Dim vntArrCsSName()     As Variant          'コース略称の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    

    
    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntCsSName) Then vntCsSName = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHECKDAYID", IIf(blnReceptOnly, 0, -1), ORAPARM_INPUT, ORATYPE_NUMBER

    '指定された個人ＩＤの受診歴一覧を取得する
    strStmt = "SELECT HISTORY.PERID,                                        " & vbLf & _
              "       HISTORY.RSVNO,    HISTORY.CSLDATE,   HISTORY.CSCD,    " & vbLf & _
              "       HISTORY.CSNAME,    HISTORY.CSSNAME                    " & vbLf & _
              "  FROM                                                       " & vbLf & _
              "       ( SELECT CONSULT.PERID,     CONSULT.RSVNO,            " & vbLf & _
              "                CONSULT.CSLDATE,   CONSULT.CSCD,             " & vbLf & _
              "                COURSE_P.CSNAME,   COURSE_P.CSSNAME,         " & vbLf & _
              "                RECEIPT.DAYID,                               " & vbLf & _
              "                NVL(RECEIPT.DAYID, 0) CHECKDAYID             " & vbLf & _
              "           FROM RECEIPT, COURSE_P, CONSULT                   "
              
    
    strStmt = strStmt & vbLf & _
              "          WHERE CONSULT.PERID     =                          " & vbLf & _
              "                                  (SELECT DISTINCT PERID     " & vbLf & _
              "                                     FROM CONSULT            " & vbLf & _
              "                                    WHERE RSVNO = :RSVNO)    " & vbLf & _
              "            AND CONSULT.CANCELFLG = 0                        "
    
    Select Case lngLastDspMode
    Case 1
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD = :CSCD                         "
    Case 2
        strStmt = strStmt & vbLf & _
              "        AND CONSULT.CSCD                                     " & vbLf & _
              "                          IN (SELECT FREEFIELD1 CSCD         " & vbLf & _
              "                                FROM FREE                    " & vbLf & _
              "                           WHERE FREECD LIKE :CSCD||'%')     "
    End Select
    
    strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD      = COURSE_P.CSCD            " & vbLf & _
              "            AND CONSULT.RSVNO     = RECEIPT.RSVNO(+)         " & vbLf & _
              "            AND CONSULT.CSLDATE   = RECEIPT.CSLDATE(+)       " & vbLf & _
              "         ORDER BY CONSULT.CSLDATE DESC                       " & vbLf & _
              "       ) HISTORY                                             "

    '条件節
    strStmt = strStmt & vbLf & _
              " WHERE HISTORY.CSLDATE                                       "
    '今回分含む？
    If lngSelectMode = 0 Then
        strStmt = strStmt & " <= "
    Else
        strStmt = strStmt & " <  "
    End If
    strStmt = strStmt & vbLf & _
              "                                  (SELECT DISTINCT CSLDATE   " & vbLf & _
              "                                     FROM CONSULT            " & vbLf & _
              "                                    WHERE RSVNO = :RSVNO)    " & vbLf & _
              "   AND HISTORY.CHECKDAYID  > :CHECKDAYID                     "
              
    '今回が最後？
    If lngDateSort = 1 Then
         '取得件数指定時
        If lngGetRowCount > 0 Then
            strStmt = strStmt & vbLf & _
                       "   AND ROWNUM <= " & lngGetRowCount
        End If
    End If
    
    '受診日の降順、当日ＩＤの降順、コースコードの昇順に取得
    strStmt = strStmt & vbLf & _
              " ORDER BY HISTORY.PERID,                 " & vbLf & _
              "          HISTORY.CSLDATE " & IIf(lngDateSort = 0, " DESC", "") & ", " & vbLf & _
              "          HISTORY.DAYID DESC NULLS LAST, " & vbLf & _
              "          HISTORY.CSCD                   "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objCsSName = objFields("CSSNAME")

        'レコードの検索
        Do Until objOraDyna.EOF

            '配列形式で格納する
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrCsSName(lngCount)
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrCsSName(lngCount) = objCsSName.Value & ""
            lngCount = lngCount + 1

            '取得件数指定時、要取得件数に達した場合はレコード検索を終了する
            If lngGetRowCount > 0 And lngCount >= lngGetRowCount Then
                Exit Do
            End If

            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntCsSName) Then vntCsSName = vntArrCsSName
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectConsultHistory = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsultHistory = -1

    'イベントログ書き込み ## クラス名修正　2004.01.13
    WriteErrorLog "Interview.SelectConsultHistory"
    
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
' 機能　　 : 面接支援画面表示用のオプション検査名を取得する
'
' 引数　　 : (In)     lngRsvNo       予約番号
' 　　　　   (Out)    vntOptName     オプション検査名称
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectInteviewOptItem( _
    ByVal lngRsvNo As Long, _
    ByRef vntOptName As Variant, _
    Optional ByVal blnReceptOnly As Boolean = False _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objOptName          As OraField         'オプション検査名称

    Dim vntArrOptName()     As Variant          'オプション検査名称の配列

    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    strStmt = strStmt & vbLf & _
                "SELECT DISTINCT FINALRSL.SEQ,                        " & vbLf & _
                "                FINALRSL.OPTNAME                     " & vbLf & _
                "  FROM (SELECT RSL.ITEMCD, RSL.SUFFIX,               " & vbLf & _
                "                OPTVIEW.SEQ, OPTVIEW.OPTNAME,        " & vbLf & _
                "                OPTVIEW.GRPCD                        " & vbLf & _
                "           FROM RSL, GRP_I,                          " & vbLf & _
                "                (SELECT FREECD     OPTCD,            " & vbLf & _
                "                        FREEFIELD1 SEQ,              " & vbLf & _
                "                        FREEFIELD2 OPTNAME,          " & vbLf & _
                "                        FREEFIELD3 GRPCD             " & vbLf & _
                "                   FROM FREE                         " & vbLf & _
                "                  WHERE FREECD LIKE 'OPT%' ) OPTVIEW " & vbLf & _
                "          WHERE RSL.RSVNO = :RSVNO                   " & vbLf & _
                "            AND GRP_I.GRPCD = OPTVIEW.GRPCD          " & vbLf & _
                "            AND GRP_I.ITEMCD = RSL.ITEMCD            " & vbLf & _
                "            AND GRP_I.SUFFIX = RSL.SUFFIX            " & vbLf & _
                "            AND RSL.STOPFLG IS NULL )FINALRSL        " & vbLf & _
                " ORDER BY FINALRSL.SEQ                               "
                
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOptName = objFields("OPTNAME")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOptName(lngCount)
            vntArrOptName(lngCount) = objOptName.Value & ""
            lngCount = lngCount + 1


            objOraDyna.MoveNext
        Loop
    End If
    
    vntOptName = vntArrOptName
    
    SelectInteviewOptItem = lngCount
        
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectInteviewOptItem = -1

    'イベントログ書き込み ## クラス名修正 2004.01.13
    WriteErrorLog "Interview.SelectInteviewOptItem"
    
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
'' 機能　　 : 予約番号をキーに指定対象受診者の検査結果歴を取得する
''
'' 引数　　 : (In)     lngRsvNo       予約番号（今回分）
'' 　　　　   (In)     strHisCount    表示歴数
'' 　　　　   (In)     strGrpCd       グループコード
'' 　　　　   (In)     lngLastDspMode 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
'' 　　　　   (In)     vntCsGrp       前回歴表示モード＝0のとき、null
'' 　　　　                                          ＝1のとき、コースコード
'' 　　　　                                          ＝2のとき、コースグループコード
'' 　　　　   (In)     lngGetSeqMode  取得順 0:グループ内表示順＋日付　1:日付＋コード＋サフィックス　2:日付＋グループ内表示順
'' 　　　　   (In)     lngSelectMode  データ取得モード（0:今回分含む、1:前回分以前）
'' 　　　　   (In)     lngAllDataMode 全件取得モード（0:検査結果に存在する項目を取得、1:検査結果に存在しなくても全項目取得）
'' 　　　　   (Out)    vntPerId       個人ＩＤ
'' 　　　　   (Out)    vntCslDate     受診日
'' 　　　　   (Out)    vntHisNo       履歴No.
'' 　　　　   (Out)    vntRsvNo       予約番号
'' 　　　　   (Out)    vntItemCd      検査項目コード
'' 　　　　   (Out)    vntSuffix      サフィックス
'' 　　　　   (Out)    vntResultType  結果タイプ
'' 　　　　   (Out)    vntItemType    項目タイプ
'' 　　　　   (Out)    vntItemName    検査項目名称
'' 　　　　   (Out)    vntResult      検査結果(数値タイプはそのまま、文章タイプは文章を返す)
'' 　　　　   (Out)    vntRslValue    検査結果(数値タイプ、文章タイプにかかわらずそのまま返す)
'' 　　　　   (Out)    vntStdFlg      基準値フラグ
'' 　　　　   (Out)    vntRslCmtCd1   結果コメント１
'' 　　　　   (Out)    vntRslCmtName1 結果コメント名１
'' 　　　　   (Out)    vntRslCmtCd2   結果コメント２
'' 　　　　   (Out)    vntRslCmtName2 結果コメント名２
'' 　　　　   (Out)    vntUnit        単位
'' 　　　　   (Out)    vntLowerValue  基準値（最低）
'' 　　　　   (Out)    vntUpperValue  基準値（最高）
'' 　　　　   (Out)    vntCUTargetFlg CU経年変化表示対象
'' 　　　　   (Out)    vntQuestionRank 問診表示ランク
'' 　　　　   (Out)    vntClassName   検査分類名称
'' 　　　　   (Out)    vntItemQName   問診文章
'' 　　　　   (Out)    vntGrpSeq      表示順番
'' 　　　　   (Out)    vntRslFlg      検査結果存在フラグ(1:検査結果に存在する、0:検査結果に存在しない）
'' 　　　　   (Out)    vntHideInterview 面接支援非表示フラグ
'' 　　　　   (Out)    vntMinValue    最小値
'' 　　　　   (Out)    vntMaxValue    最大値
'' 　　　　   (In)     lngDateSort    日付順(0:今回が先頭、1:今回が最後)
''
'' 戻り値　 : 検索条件を満たすレコード件数
''
'' 備考　　 :
''
'Public Function SelectHistoryRslList( _
'    ByVal lngRsvNo As Long, _
'    ByVal strHisCount As String, _
'    ByVal strGrpCd As String, _
'    ByVal lngLastDspMode As Long, _
'    ByVal vntCsGrp As Variant, _
'    ByVal lngGetSeqMode As Long, _
'    Optional ByVal lngSelectMode As Long = 0, _
'    Optional ByVal lngAllDataMode As Long = 0, _
'    Optional ByRef vntPerId As Variant, Optional ByRef vntCslDate As Variant, _
'    Optional ByRef vntHisNo As Variant, Optional ByRef vntRsvNo As Variant, _
'    Optional ByRef vntItemCd As Variant, Optional ByRef vntSuffix As Variant, _
'    Optional ByRef vntResultType As Variant, Optional ByRef vntItemType As Variant, _
'    Optional ByRef vntItemName As Variant, Optional ByRef vntResult As Variant, _
'    Optional ByRef vntRslValue As Variant, Optional ByRef vntStdFlg As Variant, _
'    Optional ByRef vntRslCmtCd1 As Variant, Optional ByRef vntRslCmtName1 As Variant, _
'    Optional ByRef vntRslCmtCd2 As Variant, Optional ByRef vntRslCmtName2 As Variant, _
'    Optional ByRef vntUnit As Variant, Optional ByRef vntLowerValue As Variant, Optional ByRef vntUpperValue As Variant, _
'    Optional ByRef vntCUTargetFlg As Variant, Optional ByRef vntQuestionRank As Variant, _
'    Optional ByRef vntClassName As Variant, Optional ByRef vntItemQName As Variant, _
'    Optional ByRef vntGrpSeq As Variant, Optional ByRef vntRslFlg As Variant, _
'    Optional ByRef vntHideInterview As Variant, Optional ByRef vntMinValue As Variant, Optional ByRef vntMaxValue As Variant, _
'    Optional ByVal lngDateSort As Long = 0 _
') As Long
'
'    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
'    Dim objOraDyna          As OraDynaset       'ダイナセット
'    Dim strStmt             As String           'SQLステートメント
'    Dim strStmtView         As String           'SQLステートメント
'
'    Dim objFields           As OraFields        'フィールドオブジェクト
'    Dim objPerId            As OraField         '個人ＩＤ
'    Dim objCslDate          As OraField         '受診日
'    Dim objHisNo            As OraField         '履歴No.
'    Dim objRsvNo            As OraField         '予約番号
'    Dim objItemCd           As OraField         '検査項目コード
'    Dim objSuffix           As OraField         'サフィックス
'    Dim objResultType       As OraField         '結果タイプ
'    Dim objItemType         As OraField         '項目タイプ
'    Dim objItemName         As OraField         '検査項目名称
'    Dim objResult           As OraField         '検査結果
'    Dim objRslValue         As OraField         '検査結果
'    Dim objStdFlg           As OraField         '基準値フラグ
'    Dim objRslCmtCd1        As OraField         '結果コメント１
'    Dim objRslCmtName1      As OraField         '結果コメント名１
'    Dim objRslCmtCd2        As OraField         '結果コメント２
'    Dim objRslCmtName2      As OraField         '結果コメント名２
'    Dim objUnit             As OraField         '単位
'    Dim objLowerValue       As OraField         '基準値（最低）
'    Dim objUpperValue       As OraField         '基準値（最高）
'    Dim objCUTargetFlg      As OraField         'CU経年変化表示対象
'    Dim objQuestionRank     As OraField         '問診表示ランク
'    Dim objClassName        As OraField         '検査分類名称
'    Dim objItemQName        As OraField         '問診文章
'    Dim objGrpSeq           As OraField         '表示順番
'    Dim objRslFlg           As OraField         '検査結果存在フラグ
'    Dim objHideInterview    As OraField         '面接支援非表示フラグ
'    Dim objMinValue         As OraField         '最小値
'    Dim objMaxValue         As OraField         '最大値
'
'    Dim vntArrHisNo()       As Variant          '履歴No.の配列
'    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
'    Dim vntArrCslDate()     As Variant          '受診日の配列
'    Dim vntArrRsvNo()       As Variant          '予約番号の配列
'    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
'    Dim vntArrSuffix()      As Variant          'サフィックスの配列
'    Dim vntArrResultType()  As Variant          '結果タイプの配列
'    Dim vntArrItemType()    As Variant          '項目タイプの配列
'    Dim vntArrItemName()    As Variant          '検査項目名称の配列
'    Dim vntArrResult()      As Variant          '検査結果の配列
'    Dim vntArrRslValue()    As Variant          '検査結果の配列
'    Dim vntArrStdFlg()      As Variant          '基準値フラグの配列
'    Dim vntArrRslCmtCd1()   As Variant          '結果コメント１の配列
'    Dim vntArrRslCmtName1() As Variant          '結果コメント名１の配列
'    Dim vntArrRslCmtCd2()   As Variant          '結果コメント２の配列
'    Dim vntArrRslCmtName2() As Variant          '結果コメント名２の配列
'    Dim vntArrUnit()        As Variant          '単位の配列
'    Dim vntArrLowerValue()  As Variant          '基準値（最低）の配列
'    Dim vntArrUpperValue()  As Variant          '基準値（最高）の配列
'    Dim vntArrCUTargetFlg() As Variant          'CU経年変化表示対象の配列
'    Dim vntArrQuestionRank() As Variant          '問診表示ランクの配列
'    Dim vntArrClassName()   As Variant          '検査分類の配列
'    Dim vntArrItemQName()   As Variant          '問診文章の配列
'    Dim vntArrGrpSeq()      As Variant          '表示順番の配列
'    Dim vntArrRslFlg()      As Variant          '検査結果存在フラグの配列
'    Dim vntArrHideInterview() As Variant          '面接支援非表示フラグの配列
'    Dim vntArrMinValue()    As Variant          '最小値の配列
'    Dim vntArrMaxValue()    As Variant          '最大値の配列
'
'    Dim lngCount            As Long             'レコード数
'    Dim lngHistoryCount     As Long             '表示歴数
'
'    Dim blnStdValueFlg      As Boolean          '基準値が複数レコードある:True
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    '初期処理
'    If Not IsMissing(vntPerId) Then vntPerId = Empty
'    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
'    If Not IsMissing(vntHisNo) Then vntHisNo = Empty
'    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
'    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
'    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
'    If Not IsMissing(vntResultType) Then vntResultType = Empty
'    If Not IsMissing(vntItemType) Then vntItemType = Empty
'    If Not IsMissing(vntItemName) Then vntItemName = Empty
'    If Not IsMissing(vntResult) Then vntResult = Empty
'    If Not IsMissing(vntRslValue) Then vntRslValue = Empty
'    If Not IsMissing(vntStdFlg) Then vntStdFlg = Empty
'    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = Empty
'    If Not IsMissing(vntRslCmtName1) Then vntRslCmtName1 = Empty
'    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = Empty
'    If Not IsMissing(vntRslCmtName2) Then vntRslCmtName2 = Empty
'    If Not IsMissing(vntUnit) Then vntUnit = Empty
'    If Not IsMissing(vntLowerValue) Then vntLowerValue = Empty
'    If Not IsMissing(vntUpperValue) Then vntUpperValue = Empty
'    If Not IsMissing(vntCUTargetFlg) Then vntCUTargetFlg = Empty
'    If Not IsMissing(vntQuestionRank) Then vntQuestionRank = Empty
'    If Not IsMissing(vntClassName) Then vntClassName = Empty
'    If Not IsMissing(vntItemQName) Then vntItemQName = Empty
'    If Not IsMissing(vntGrpSeq) Then vntGrpSeq = Empty
'    If Not IsMissing(vntRslFlg) Then vntRslFlg = Empty
'    If Not IsMissing(vntHideInterview) Then vntHideInterview = Empty
'    If Not IsMissing(vntMinValue) Then vntMinValue = Empty
'    If Not IsMissing(vntMaxValue) Then vntMaxValue = Empty
'
'    '表示歴数が「全件」以外で、数値でない場合はエラー
'    If strHisCount <> "*" Then
'        If Not IsNumeric(strHisCount) Then
'            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
'            Exit Function
'        End If
'        lngHistoryCount = CLng(strHisCount)
'    Else
'        lngHistoryCount = 0
'    End If
'
'    'キー及び更新値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    If lngHistoryCount > 0 Then
'        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
'    End If
'    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "GRPCD", IIf(strGrpCd = Null, "", Trim(strGrpCd)), ORAPARM_INPUT, ORATYPE_VARCHAR2
'
'
'    strStmt = "SELECT FINALRSL.PERID, FINALRSL.CSLDATE,                     " & vbLf & _
'              "       FINALRSL.HISNO, FINALRSL.RSVNO,                       " & vbLf & _
'              "       FINALRSL.SEQ, FINALRSL.RSLFLG,                        " & vbLf & _
'              "       FINALRSL.ITEMCD, FINALRSL.SUFFIX,                     " & vbLf & _
'              "       FINALRSL.RESULTTYPE, FINALRSL.ITEMTYPE,               " & vbLf & _
'              "       FINALRSL.ITEMNAME,     FINALRSL.ITEMQNAME,            " & vbLf & _
'              "       FINALRSL.RESULT RSLVALUE, FINALRSL.STDFLG,            " & vbLf & _
'              "       SENTENCE.QUESTIONRANK, FINALRSL.CLASSNAME,            " & vbLf
'    '検査結果のメモタイプ対応
'    strStmt = strStmt & _
'              "       CASE WHEN FINALRSL.RESULTTYPE = 7 THEN                " & vbLf & _
'              "         (SELECT RSLMEMOSTR FROM RSLMEMO                     " & vbLf & _
'              "           WHERE RSVNO  = FINALRSL.RSVNO                     " & vbLf & _
'              "             AND ITEMCD = FINALRSL.ITEMCD                    " & vbLf & _
'              "             AND SUFFIX = FINALRSL.SUFFIX)                   " & vbLf & _
'              "       ELSE                                                  " & vbLf & _
'              "         NVL(SENTENCE.SHORTSTC, FINALRSL.RESULT)             " & vbLf & _
'              "       END RESULT,                                           " & vbLf
'
'    '基準値要
'    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
''        strStmt = strStmt & _
''              "       STDVALUEVIEW.LOWERVALUE,                              " & vbLf & _
''              "       STDVALUEVIEW.UPPERVALUE,                              " & vbLf
'        '基準値の文章タイプ（本来は定性タイプの検査項目）対応
'        strStmt = strStmt & _
'              "       CASE WHEN FINALRSL.RESULTTYPE = 4 THEN                " & vbLf & _
'              "         (SELECT SHORTSTC FROM SENTENCE                      " & vbLf & _
'              "           WHERE ITEMCD = FINALRSL.ITEMCD                    " & vbLf & _
'              "             AND ITEMTYPE = FINALRSL.ITEMTYPE                " & vbLf & _
'              "             AND STCCD = STDVALUEVIEW.LOWERVALUE)            " & vbLf & _
'              "       ELSE                                                  " & vbLf & _
'              "         STDVALUEVIEW.LOWERVALUE                             " & vbLf & _
'              "       END LOWERVALUE,                                       " & vbLf & _
'              "       CASE WHEN FINALRSL.RESULTTYPE = 4 THEN                " & vbLf & _
'              "         (SELECT SHORTSTC FROM SENTENCE                      " & vbLf & _
'              "           WHERE ITEMCD = FINALRSL.ITEMCD                    " & vbLf & _
'              "             AND ITEMTYPE = FINALRSL.ITEMTYPE                " & vbLf & _
'              "             AND STCCD = STDVALUEVIEW.UPPERVALUE)            " & vbLf & _
'              "       ELSE                                                  " & vbLf & _
'              "         STDVALUEVIEW.UPPERVALUE                             " & vbLf & _
'              "       END UPPERVALUE,                                       " & vbLf
'    Else
'        strStmt = strStmt & _
'              "       NULL LOWERVALUE,                                      " & vbLf & _
'              "       NULL UPPERVALUE,                                      " & vbLf
'    End If
'    strStmt = strStmt & _
'              "       FINALRSL.RSLCMTCD1,                                   " & vbLf
'
'    '結果コメント要
'    If Not IsMissing(vntRslCmtName1) Then
'        strStmt = strStmt & _
'              "       (SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
'              "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD1) RSLCMTNAME1,   " & vbLf
'    Else
'        strStmt = strStmt & _
'              "       NULL RSLCMTNAME1,                                     " & vbLf
'    End If
'
'    strStmt = strStmt & _
'              "       FINALRSL.RSLCMTCD2,                                   " & vbLf
'
'    '結果コメント要
'    If Not IsMissing(vntRslCmtName2) Then
'        strStmt = strStmt & _
'              "       (SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
'              "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD2) RSLCMTNAME2,   " & vbLf
'    Else
'        strStmt = strStmt & _
'              "       NULL RSLCMTNAME2,                                     " & vbLf
'    End If
'
'    strStmt = strStmt & _
'              "       FINALRSL.MINVALUE, FINALRSL.MAXVALUE,                 " & vbLf & _
'              "       FINALRSL.UNIT, FINALRSL.CUTARGETFLG,                  " & vbLf & _
'              "       FINALRSL.HIDEINTERVIEW                                " & vbLf & _
'              "  FROM SENTENCE,                                             "
'
'    '検査結果View（検査結果が存在しない場合の対応）
'    strStmt = strStmt & _
'              "       ( SELECT BASERSL.HISNO,                           " & vbLf & _
'              "                BASERSL.CSLDATE, BASERSL.RSVNO,          " & vbLf & _
'              "                BASERSL.PERID, BASERSL.SEQ,              " & vbLf & _
'              "                BASERSL.ITEMCD, BASERSL.SUFFIX,          " & vbLf & _
'              "                BASERSL.RESULT, BASERSL.RSLFLG,          " & vbLf & _
'              "                BASERSL.RSLCMTCD1, BASERSL.RSLCMTCD2,    " & vbLf & _
'              "                STDVALUE_C.STDFLG, ITEMCLASS.CLASSNAME,  " & vbLf & _
'              "                ITEM_C.RESULTTYPE, ITEM_C.ITEMTYPE,      " & vbLf & _
'              "                ITEM_C.ITEMNAME, ITEM_C.STCITEMCD,       " & vbLf & _
'              "                ITEM_C.ITEMQNAME,ITEM_C.CUTARGETFLG,     " & vbLf & _
'              "                ITEM_H.MINVALUE,ITEM_H.MAXVALUE,         " & vbLf & _
'              "                ITEM_H.UNIT,ITEM_C.HIDEINTERVIEW         " & vbLf & _
'              "           FROM                                          "
'
'    '検査結果に存在しない項目を取得のため、検査項目の空レコードと結合
'    strStmt = strStmt & _
'              "                ( SELECT HISNO, CSLDATE, RSVNO, PERID,   " & vbLf & _
'              "                         SEQ, ITEMCD, SUFFIX,            " & vbLf & _
'              "                         MAX(RESULT) RESULT,             " & vbLf & _
'              "                         MAX(STDVALUECD) STDVALUECD,     " & vbLf & _
'              "                         MAX(RSLCMTCD1) RSLCMTCD1,       " & vbLf & _
'              "                         MAX(RSLCMTCD2) RSLCMTCD2,       " & vbLf & _
'              "                         MAX(RSLFLG) RSLFLG              " & vbLf & _
'              "                    FROM 　                              "
'    '検査結果に存在するレコード
'    strStmt = strStmt & _
'              "                         ( SELECT CONSULTVIEW.SEQ HISNO,                     " & vbLf & _
'              "                                  CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,    " & vbLf & _
'              "                                  CONSULTVIEW.PERID, GRP_I.SEQ,              " & vbLf & _
'              "                                  RSL.ITEMCD, RSL.SUFFIX,                    " & vbLf & _
'              "                                  RSL.RESULT, RSL.STDVALUECD,                " & vbLf & _
'              "                                  RSL.RSLCMTCD1, RSL.RSLCMTCD2,              " & vbLf & _
'              "                                  1 RSLFLG                                   " & vbLf & _
'              "                             FROM ( "
'
''受診履歴View --------------------Start
'    'このViewを２回呼び出すため別変数にセットしておく
'    strStmtView = _
'              "    SELECT ROWNUM SEQ, CSLDATE, RSVNO, PERID     " & vbLf & _
'              "      FROM ( SELECT CONSULT.CSLDATE,             " & vbLf & _
'              "                    CONSULT.RSVNO,               " & vbLf & _
'              "                    CONSULT.PERID                " & vbLf & _
'              "               FROM CONSULT                      " & vbLf & _
'              "              WHERE CONSULT.PERID     =          " & vbLf & _
'              "                    (SELECT DISTINCT PERID       " & vbLf & _
'              "                       FROM CONSULT              " & vbLf & _
'              "                      WHERE RSVNO = :RSVNO)      "
'    '今回分を含む？
'    strStmtView = strStmtView & vbLf & _
'              "                AND CONSULT.CSLDATE " & IIf(lngSelectMode = 0, "<= ", "< ") & vbLf & _
'              "                    (SELECT DISTINCT CSLDATE     " & vbLf & _
'              "                       FROM CONSULT              " & vbLf & _
'              "                      WHERE RSVNO = :RSVNO)      "
'
'    'コース指定
'    Select Case lngLastDspMode
'        Case 1
'            strStmtView = strStmtView & vbLf & _
'              "                AND CONSULT.CSCD = :CSCD         "
'        Case 2
'            strStmtView = strStmtView & vbLf & _
'              "                AND CONSULT.CSCD                 " & vbLf & _
'              "                    IN (SELECT FREEFIELD1 CSCD   " & vbLf & _
'              "                          FROM FREE              " & vbLf & _
'              "                         WHERE FREECD LIKE :CSCD||'%') "
'    End Select
'    strStmtView = strStmtView & vbLf & _
'              "                AND CONSULT.CANCELFLG = 0        " & vbLf & _
'              "           ORDER BY CONSULT.CSLDATE DESC )       "
''受診履歴View --------------------End
'
'    strStmt = strStmt & vbLf & strStmtView      '受診履歴View
'    strStmt = strStmt & vbLf & _
'              "                                  ) CONSULTVIEW, RSL, GRP_I                  " & vbLf & _
'              "                              WHERE CONSULTVIEW.RSVNO = RSL.RSVNO            "
'    If lngHistoryCount > 0 Then
'        strStmt = strStmt & vbLf & _
'              "                                AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
'    End If
'    strStmt = strStmt & vbLf & _
'              "                                AND RSL.STOPFLG IS NULL                      " & vbLf & _
'              "                                AND GRP_I.GRPCD = :GRPCD                     " & vbLf & _
'              "                                AND GRP_I.ITEMCD = RSL.ITEMCD                " & vbLf & _
'              "                                AND GRP_I.SUFFIX = RSL.SUFFIX                "
'
'    '検査項目が存在しない項目も取得？
'    If lngAllDataMode = 1 Then
'        '検査結果項目の空レコード
'        strStmt = strStmt & _
'              "                         UNION ALL                                           " & vbLf & _
'              "                           SELECT CONSULTVIEW.SEQ HISNO,                     " & vbLf & _
'              "                                  CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,    " & vbLf & _
'              "                                  CONSULTVIEW.PERID, GRP_I.SEQ,              " & vbLf & _
'              "                                  GRP_I.ITEMCD, GRP_I.SUFFIX,                " & vbLf & _
'              "                                  NULL RESULT, NULL STDVALUECD,              " & vbLf & _
'              "                                  NULL RSLCMTCD1, NULL RSLCMTCD2,            " & vbLf & _
'              "                                  0 RSLFLG                                   " & vbLf & _
'              "                             FROM ( "
'        strStmt = strStmt & vbLf & strStmtView      '受診履歴View
'        strStmt = strStmt & vbLf & _
'              "                                  ) CONSULTVIEW, GRP_I                       " & vbLf & _
'              "                              WHERE GRP_I.GRPCD = :GRPCD                     "
'        If lngHistoryCount > 0 Then
'            strStmt = strStmt & vbLf & _
'              "                                AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
'        End If
'    End If
'
'    strStmt = strStmt & _
'              "                         )                               " & vbLf & _
'              "                GROUP BY HISNO, CSLDATE, RSVNO, PERID,   " & vbLf & _
'              "                         SEQ, ITEMCD, SUFFIX             "
'
'    strStmt = strStmt & vbLf & _
'              "                ) BASERSL, STDVALUE_C, ITEM_C, ITEM_H,           " & vbLf & _
'              "                ITEM_P, ITEMCLASS                                " & vbLf & _
'              "          WHERE BASERSL.STDVALUECD = STDVALUE_C.STDVALUECD(+)    " & vbLf & _
'              "            AND BASERSL.ITEMCD = ITEM_C.ITEMCD                   " & vbLf & _
'              "            AND BASERSL.SUFFIX = ITEM_C.SUFFIX                   " & vbLf & _
'              "            AND BASERSL.ITEMCD = ITEM_H.ITEMCD                   " & vbLf & _
'              "            AND BASERSL.SUFFIX = ITEM_H.SUFFIX                   " & vbLf & _
'              "            AND BASERSL.CSLDATE BETWEEN ITEM_H.STRDATE           " & vbLf & _
'              "                                    AND ITEM_H.ENDDATE           " & vbLf & _
'              "            AND ITEM_C.ITEMCD = ITEM_P.ITEMCD                    " & vbLf & _
'              "            AND ITEM_P.CLASSCD = ITEMCLASS.CLASSCD               " & vbLf & _
'              "       ) FINALRSL                                                " & vbLf
'
'
'    '基準値要
'    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
'        '基準値取得View
'        strStmt = strStmt & _
'              "     , (SELECT ITEMCD, SUFFIX, RESULT,                             " & vbLf & _
'              "               PRIORSEQ,                                           " & vbLf & _
'              "               LOWERVALUE, UPPERVALUE                              " & vbLf & _
'              "          FROM ( SELECT RSL.ITEMCD, RSL.SUFFIX, RSL.RESULT,        " & vbLf & _
'              "                        RSLSTDVALUE.CSRANK, RSLSTDVALUE.CSCD,      " & vbLf & _
'              "                        RSLSTDVALUE.PRIORSEQ, RSLSTDVALUE.STDFLG,  " & vbLf & _
'              "                        RSLSTDVALUE.LOWERVALUE,                    " & vbLf & _
'              "                        RSLSTDVALUE.UPPERVALUE,                    " & vbLf
'              '管理コースの所在によっては複数ヒットすることもあるため､重みつけを行う(最も重いものに若い値)
'        strStmt = strStmt & _
'              "                        RANK() OVER (PARTITION BY RSLSTDVALUE.ITEMCD, RSLSTDVALUE.SUFFIX  " & vbLf & _
'              "                                     ORDER BY RSLSTDVALUE.CSRANK, RSLSTDVALUE.CSCD) STDRANK  " & vbLf
'        'ビュー"RSLSTDVALUE"は値を直接指定しないとFULL SCANになるのでまず内部ビューで(アスタリスク指定で一寸手抜き)
'        '基準値のない検査結果もあるので(+)指定
'        '標準の基準値のみ取得する(NULL指定することで基準値のない検査項目も対象となる)
'        '最も重い値、即ち若い値で絞り込み
''2003/12/11 STDFLGがNULLのものは含まない
''        strStmt = strStmt & _
''              "                   FROM                                                     " & vbLf & _
''              "                        ( SELECT *                                          " & vbLf & _
''              "                            FROM RSLSTDVALUE                                " & vbLf & _
''              "                           WHERE RSVNO = :RSVNO ) RSLSTDVALUE,              " & vbLf & _
''              "                         RSL                                                " & vbLf & _
''              "                  WHERE RSL.RSVNO  = :RSVNO                                 " & vbLf & _
''              "                    AND RSL.ITEMCD = RSLSTDVALUE.ITEMCD(+)                  " & vbLf & _
''              "                    AND RSL.SUFFIX = RSLSTDVALUE.SUFFIX(+)                  " & vbLf & _
''              "                    AND ( RSLSTDVALUE.STDFLG IS NULL OR RSLSTDVALUE.STDFLG = 'S' )  " & vbLf & _
''              "                  )                                                         " & vbLf & _
''              "         WHERE STDRANK = 1                                                  " & vbLf & _
''              "         ) STDVALUEVIEW                                                     "
'        strStmt = strStmt & _
'              "                   FROM                                                     " & vbLf & _
'              "                        ( SELECT *                                          " & vbLf & _
'              "                            FROM RSLSTDVALUE                                " & vbLf & _
'              "                           WHERE RSVNO = :RSVNO ) RSLSTDVALUE,              " & vbLf & _
'              "                         RSL                                                " & vbLf & _
'              "                  WHERE RSL.RSVNO  = :RSVNO                                 " & vbLf & _
'              "                    AND RSL.ITEMCD = RSLSTDVALUE.ITEMCD(+)                  " & vbLf & _
'              "                    AND RSL.SUFFIX = RSLSTDVALUE.SUFFIX(+)                  " & vbLf & _
'              "                    AND RSLSTDVALUE.STDFLG = 'S'                            " & vbLf & _
'              "                  )                                                         " & vbLf & _
'              "         WHERE STDRANK = 1                                                  " & vbLf & _
'              "         ) STDVALUEVIEW                                                     "
'    End If
'
'    strStmt = strStmt & vbLf & _
'              " WHERE FINALRSL.STCITEMCD = SENTENCE.ITEMCD(+)           " & vbLf & _
'              "   AND FINALRSL.ITEMTYPE  = SENTENCE.ITEMTYPE(+)         " & vbLf & _
'              "   AND FINALRSL.RESULT    = SENTENCE.STCCD(+)            "
'    '基準値要
'    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
'        strStmt = strStmt & vbLf & _
'                  "   AND FINALRSL.ITEMCD    = STDVALUEVIEW.ITEMCD(+)       " & vbLf & _
'                  "   AND FINALRSL.SUFFIX    = STDVALUEVIEW.SUFFIX(+)       "
'    End If
'
'    Select Case lngGetSeqMode
'    Case 0
'        strStmt = strStmt & vbLf & _
'              " ORDER BY FINALRSL.SEQ,                                  " & vbLf & _
'              "          FINALRSL.CSLDATE" & IIf(lngDateSort = 0, " DESC ", "")
'    Case 1
'        strStmt = strStmt & vbLf & _
'              " ORDER BY FINALRSL.CSLDATE" & IIf(lngDateSort = 0, " DESC, ", ", ") & vbLf & _
'              "          FINALRSL.ITEMCD, FINALRSL.SUFFIX               "
'    Case 2
'        strStmt = strStmt & vbLf & _
'              " ORDER BY FINALRSL.CSLDATE" & IIf(lngDateSort = 0, " DESC, ", ", ") & vbLf & _
'              "          FINALRSL.SEQ                                   "
'    End Select
'    '基準値要
'    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
'        strStmt = strStmt & vbLf & _
'              "          , STDVALUEVIEW.PRIORSEQ                        "
'    End If
'
'    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
'
'    '検索レコードが存在する場合
'    If Not objOraDyna.EOF Then
'
'        'オブジェクトの参照設定
'        Set objFields = objOraDyna.Fields
'        Set objPerId = objFields("PERID")
'        Set objCslDate = objFields("CSLDATE")
'        Set objHisNo = objFields("HISNO")
'        Set objRsvNo = objFields("RSVNO")
'        Set objItemCd = objFields("ITEMCD")
'        Set objSuffix = objFields("SUFFIX")
'        Set objResultType = objFields("RESULTTYPE")
'        Set objItemType = objFields("ITEMTYPE")
'        Set objItemName = objFields("ITEMNAME")
'        Set objResult = objFields("RESULT")
'        Set objRslValue = objFields("RSLVALUE")
'        Set objStdFlg = objFields("STDFLG")
'        Set objRslCmtCd1 = objFields("RSLCMTCD1")
'        Set objRslCmtName1 = objFields("RSLCMTNAME1")
'        Set objRslCmtCd2 = objFields("RSLCMTCD2")
'        Set objRslCmtName2 = objFields("RSLCMTNAME1")
'        Set objUnit = objFields("UNIT")
'        Set objLowerValue = objFields("LOWERVALUE")
'        Set objUpperValue = objFields("UPPERVALUE")
'        Set objCUTargetFlg = objFields("CUTARGETFLG")
'        Set objQuestionRank = objFields("QUESTIONRANK")
'        Set objClassName = objFields("CLASSNAME")
'        Set objItemQName = objFields("ITEMQNAME")
'        Set objGrpSeq = objFields("SEQ")
'        Set objRslFlg = objFields("RSLFLG")
'        Set objHideInterview = objFields("HIDEINTERVIEW")
'        Set objMinValue = objFields("MINVALUE")
'        Set objMaxValue = objFields("MAXVALUE")
'
'        '配列形式で格納する
'        lngCount = 0
'        Do Until objOraDyna.EOF
'
'            blnStdValueFlg = False
'            '基準値が複数レコードあるか？
'            If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
'                If lngCount > 0 Then
'                    If vntArrRsvNo(lngCount - 1) = (objRsvNo.Value & "") And _
'                       vntArrItemCd(lngCount - 1) = (objItemCd.Value & "") And _
'                       vntArrSuffix(lngCount - 1) = (objSuffix.Value & "") Then
'
'                        blnStdValueFlg = True
'                    End If
'                End If
'            End If
'            If blnStdValueFlg Then
'                '結果タイプが文章のとき特殊処理
'                If vntArrResultType(lngCount - 1) = 4 Then
'                    vntArrUpperValue(lngCount - 1) = vntArrUpperValue(lngCount - 1) & "," & objUpperValue.Value & ""
'                Else
'                    '前のレコードの基準値（最大値）のみを書き換える
'                    vntArrUpperValue(lngCount - 1) = objUpperValue.Value & ""
'                End If
'            Else
'                ReDim Preserve vntArrPerId(lngCount)
'                ReDim Preserve vntArrCslDate(lngCount)
'                ReDim Preserve vntArrHisNo(lngCount)
'                ReDim Preserve vntArrRsvNo(lngCount)
'                ReDim Preserve vntArrItemCd(lngCount)
'                ReDim Preserve vntArrSuffix(lngCount)
'                ReDim Preserve vntArrResultType(lngCount)
'                ReDim Preserve vntArrItemType(lngCount)
'                ReDim Preserve vntArrItemName(lngCount)
'                ReDim Preserve vntArrResult(lngCount)
'                ReDim Preserve vntArrRslValue(lngCount)
'                ReDim Preserve vntArrStdFlg(lngCount)
'                ReDim Preserve vntArrRslCmtCd1(lngCount)
'                ReDim Preserve vntArrRslCmtName1(lngCount)
'                ReDim Preserve vntArrRslCmtCd2(lngCount)
'                ReDim Preserve vntArrRslCmtName2(lngCount)
'                ReDim Preserve vntArrUnit(lngCount)
'                ReDim Preserve vntArrLowerValue(lngCount)
'                ReDim Preserve vntArrUpperValue(lngCount)
'                ReDim Preserve vntArrCUTargetFlg(lngCount)
'                ReDim Preserve vntArrQuestionRank(lngCount)
'                ReDim Preserve vntArrClassName(lngCount)
'                ReDim Preserve vntArrItemQName(lngCount)
'                ReDim Preserve vntArrGrpSeq(lngCount)
'                ReDim Preserve vntArrRslFlg(lngCount)
'                ReDim Preserve vntArrHideInterview(lngCount)
'                ReDim Preserve vntArrMinValue(lngCount)
'                ReDim Preserve vntArrMaxValue(lngCount)
'                vntArrPerId(lngCount) = objPerId.Value & ""
'                vntArrCslDate(lngCount) = objCslDate.Value & ""
'                vntArrHisNo(lngCount) = objHisNo.Value & ""
'                vntArrRsvNo(lngCount) = objRsvNo.Value & ""
'                vntArrItemCd(lngCount) = objItemCd.Value & ""
'                vntArrSuffix(lngCount) = objSuffix.Value & ""
'                vntArrResultType(lngCount) = objResultType.Value & ""
'                vntArrItemType(lngCount) = objItemType.Value & ""
'                vntArrItemName(lngCount) = objItemName.Value & ""
'                vntArrResult(lngCount) = objResult.Value & ""
'                vntArrRslValue(lngCount) = objRslValue.Value & ""
'                vntArrStdFlg(lngCount) = objStdFlg.Value & ""
'                vntArrRslCmtCd1(lngCount) = objRslCmtCd1.Value & ""
'                vntArrRslCmtName1(lngCount) = objRslCmtName1.Value & ""
'                vntArrRslCmtCd2(lngCount) = objRslCmtCd2.Value & ""
'                vntArrRslCmtName2(lngCount) = objRslCmtName2.Value & ""
'                vntArrUnit(lngCount) = objUnit.Value & ""
'                vntArrLowerValue(lngCount) = objLowerValue.Value & ""
'                vntArrUpperValue(lngCount) = objUpperValue.Value & ""
'                vntArrCUTargetFlg(lngCount) = objCUTargetFlg.Value & ""
'                vntArrQuestionRank(lngCount) = objQuestionRank.Value & ""
'                vntArrClassName(lngCount) = objClassName.Value & ""
'                vntArrItemQName(lngCount) = objItemQName.Value & ""
'                vntArrGrpSeq(lngCount) = objGrpSeq.Value & ""
'                vntArrRslFlg(lngCount) = objRslFlg.Value & ""
'                vntArrHideInterview(lngCount) = objHideInterview.Value & ""
'                vntArrMinValue(lngCount) = objMinValue.Value & ""
'                vntArrMaxValue(lngCount) = objMaxValue.Value & ""
'                lngCount = lngCount + 1
'            End If
'            objOraDyna.MoveNext
'        Loop
'
'    End If
'
'    '戻り値の設定
'    If Not IsMissing(vntHisNo) Then vntHisNo = vntArrHisNo
'    If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
'    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
'    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
'    If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
'    If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
'    If Not IsMissing(vntResultType) Then vntResultType = vntArrResultType
'    If Not IsMissing(vntItemType) Then vntItemType = vntArrItemType
'    If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
'    If Not IsMissing(vntResult) Then vntResult = vntArrResult
'    If Not IsMissing(vntRslValue) Then vntRslValue = vntArrRslValue
'    If Not IsMissing(vntStdFlg) Then vntStdFlg = vntArrStdFlg
'    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = vntArrRslCmtCd1
'    If Not IsMissing(vntRslCmtName1) Then vntRslCmtName1 = vntArrRslCmtName1
'    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = vntArrRslCmtCd2
'    If Not IsMissing(vntRslCmtName2) Then vntRslCmtName2 = vntArrRslCmtName2
'    If Not IsMissing(vntUnit) Then vntUnit = vntArrUnit
'    If Not IsMissing(vntLowerValue) Then vntLowerValue = vntArrLowerValue
'    If Not IsMissing(vntUpperValue) Then vntUpperValue = vntArrUpperValue
'    If Not IsMissing(vntCUTargetFlg) Then vntCUTargetFlg = vntArrCUTargetFlg
'    If Not IsMissing(vntQuestionRank) Then vntQuestionRank = vntArrQuestionRank
'    If Not IsMissing(vntClassName) Then vntClassName = vntArrClassName
'    If Not IsMissing(vntItemQName) Then vntItemQName = vntArrItemQName
'    If Not IsMissing(vntGrpSeq) Then vntGrpSeq = vntArrGrpSeq
'    If Not IsMissing(vntRslFlg) Then vntRslFlg = vntArrRslFlg
'    If Not IsMissing(vntHideInterview) Then vntHideInterview = vntArrHideInterview
'    If Not IsMissing(vntMinValue) Then vntMinValue = vntArrMinValue
'    If Not IsMissing(vntMaxValue) Then vntMaxValue = vntArrMaxValue
'
'    SelectHistoryRslList = lngCount
'
'    Set objOraDyna = Nothing
'
'    'キー及び更新値の設定解除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    'トランザクションをコミット
'    mobjContext.SetComplete
'
'    Exit Function
'
'ErrorHandle:
'
'    'イベントログ書き込み ## クラス名修正　2004.01.13
'    WriteErrorLog "Interview.SelectHistoryRslList"
'
''### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
''### 2010.10.06 SL-HS-Y0101-002 ADD END ###
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function



'#### 2012/09/20 張 2012/10/1日からの問診票改訂関連仕様変更（ヘルスポイント項目追加モジュール追加）Start ###
'
' 機能　　 : 予約番号をキーに指定対象受診者の検査結果歴を取得する
'
' 引数　　 : (In)     lngRsvNo       予約番号（今回分）
' 　　　　   (In)     strHisCount    表示歴数
' 　　　　   (In)     strGrpCd       グループコード
' 　　　　   (In)     lngLastDspMode 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
' 　　　　   (In)     vntCsGrp       前回歴表示モード＝0のとき、null
' 　　　　                                          ＝1のとき、コースコード
' 　　　　                                          ＝2のとき、コースグループコード
' 　　　　   (In)     lngGetSeqMode  取得順 0:グループ内表示順＋日付　1:日付＋コード＋サフィックス　2:日付＋グループ内表示順
' 　　　　   (In)     lngSelectMode  データ取得モード（0:今回分含む、1:前回分以前）
' 　　　　   (In)     lngAllDataMode 全件取得モード（0:検査結果に存在する項目を取得、1:検査結果に存在しなくても全項目取得）
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntCslDate     受診日
' 　　　　   (Out)    vntHisNo       履歴No.
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntItemCd      検査項目コード
' 　　　　   (Out)    vntSuffix      サフィックス
' 　　　　   (Out)    vntResultType  結果タイプ
' 　　　　   (Out)    vntItemType    項目タイプ
' 　　　　   (Out)    vntItemName    検査項目名称
' 　　　　   (Out)    vntResult      検査結果(数値タイプはそのまま、文章タイプは文章を返す)
' 　　　　   (Out)    vntRslValue    検査結果(数値タイプ、文章タイプにかかわらずそのまま返す)
' 　　　　   (Out)    vntStdFlg      基準値フラグ
' 　　　　   (Out)    vntRslCmtCd1   結果コメント１
' 　　　　   (Out)    vntRslCmtName1 結果コメント名１
' 　　　　   (Out)    vntRslCmtCd2   結果コメント２
' 　　　　   (Out)    vntRslCmtName2 結果コメント名２
' 　　　　   (Out)    vntUnit        単位
' 　　　　   (Out)    vntLowerValue  基準値（最低）
' 　　　　   (Out)    vntUpperValue  基準値（最高）
' 　　　　   (Out)    vntCUTargetFlg CU経年変化表示対象
' 　　　　   (Out)    vntQuestionRank 問診表示ランク
' 　　　　   (Out)    vntClassName   検査分類名称
' 　　　　   (Out)    vntItemQName   問診文章
' 　　　　   (Out)    vntGrpSeq      表示順番
' 　　　　   (Out)    vntRslFlg      検査結果存在フラグ(1:検査結果に存在する、0:検査結果に存在しない）
' 　　　　   (Out)    vntHideInterview 面接支援非表示フラグ
' 　　　　   (Out)    vntMinValue    最小値
' 　　　　   (Out)    vntMaxValue    最大値
' 　　　　   (In)     lngDateSort    日付順(0:今回が先頭、1:今回が最後)
' 　　　　   (Out)    vntHealthPoint ヘルスポイント
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectHistoryRslList( _
    ByVal lngRsvNo As Long, _
    ByVal strHisCount As String, _
    ByVal strGrpCd As String, _
    ByVal lngLastDspMode As Long, _
    ByVal vntCsGrp As Variant, _
    ByVal lngGetSeqMode As Long, _
    Optional ByVal lngSelectMode As Long = 0, _
    Optional ByVal lngAllDataMode As Long = 0, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntHisNo As Variant, Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntItemCd As Variant, Optional ByRef vntSuffix As Variant, _
    Optional ByRef vntResultType As Variant, Optional ByRef vntItemType As Variant, _
    Optional ByRef vntItemName As Variant, Optional ByRef vntResult As Variant, _
    Optional ByRef vntRslValue As Variant, Optional ByRef vntStdFlg As Variant, _
    Optional ByRef vntRslCmtCd1 As Variant, Optional ByRef vntRslCmtName1 As Variant, _
    Optional ByRef vntRslCmtCd2 As Variant, Optional ByRef vntRslCmtName2 As Variant, _
    Optional ByRef vntUnit As Variant, Optional ByRef vntLowerValue As Variant, Optional ByRef vntUpperValue As Variant, _
    Optional ByRef vntCUTargetFlg As Variant, Optional ByRef vntQuestionRank As Variant, _
    Optional ByRef vntClassName As Variant, Optional ByRef vntItemQName As Variant, _
    Optional ByRef vntGrpSeq As Variant, Optional ByRef vntRslFlg As Variant, _
    Optional ByRef vntHideInterview As Variant, Optional ByRef vntMinValue As Variant, Optional ByRef vntMaxValue As Variant, _
    Optional ByVal lngDateSort As Long = 0, _
    Optional ByRef vntHealthPoint As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    Dim strStmtView         As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objCslDate          As OraField         '受診日
    Dim objHisNo            As OraField         '履歴No.
    Dim objRsvNo            As OraField         '予約番号
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objItemName         As OraField         '検査項目名称
    Dim objResult           As OraField         '検査結果
    Dim objRslValue         As OraField         '検査結果
    Dim objStdFlg           As OraField         '基準値フラグ
    Dim objRslCmtCd1        As OraField         '結果コメント１
    Dim objRslCmtName1      As OraField         '結果コメント名１
    Dim objRslCmtCd2        As OraField         '結果コメント２
    Dim objRslCmtName2      As OraField         '結果コメント名２
    Dim objUnit             As OraField         '単位
    Dim objLowerValue       As OraField         '基準値（最低）
    Dim objUpperValue       As OraField         '基準値（最高）
    Dim objCUTargetFlg      As OraField         'CU経年変化表示対象
    Dim objQuestionRank     As OraField         '問診表示ランク
    Dim objClassName        As OraField         '検査分類名称
    Dim objItemQName        As OraField         '問診文章
    Dim objGrpSeq           As OraField         '表示順番
    Dim objRslFlg           As OraField         '検査結果存在フラグ
    Dim objHideInterview    As OraField         '面接支援非表示フラグ
    Dim objMinValue         As OraField         '最小値
    Dim objMaxValue         As OraField         '最大値
    Dim objHealthPoint      As OraField         'ヘルスポイント
    
    Dim vntArrHisNo()       As Variant          '履歴No.の配列
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrItemName()    As Variant          '検査項目名称の配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrRslValue()    As Variant          '検査結果の配列
    Dim vntArrStdFlg()      As Variant          '基準値フラグの配列
    Dim vntArrRslCmtCd1()   As Variant          '結果コメント１の配列
    Dim vntArrRslCmtName1() As Variant          '結果コメント名１の配列
    Dim vntArrRslCmtCd2()   As Variant          '結果コメント２の配列
    Dim vntArrRslCmtName2() As Variant          '結果コメント名２の配列
    Dim vntArrUnit()        As Variant          '単位の配列
    Dim vntArrLowerValue()  As Variant          '基準値（最低）の配列
    Dim vntArrUpperValue()  As Variant          '基準値（最高）の配列
    Dim vntArrCUTargetFlg() As Variant          'CU経年変化表示対象の配列
    Dim vntArrQuestionRank() As Variant          '問診表示ランクの配列
    Dim vntArrClassName()   As Variant          '検査分類の配列
    Dim vntArrItemQName()   As Variant          '問診文章の配列
    Dim vntArrGrpSeq()      As Variant          '表示順番の配列
    Dim vntArrRslFlg()      As Variant          '検査結果存在フラグの配列
    Dim vntArrHideInterview() As Variant        '面接支援非表示フラグの配列
    Dim vntArrMinValue()    As Variant          '最小値の配列
    Dim vntArrMaxValue()    As Variant          '最大値の配列
    Dim vntArrHealthPoint() As Variant          '最大値の配列
    
    Dim lngCount            As Long             'レコード数
    Dim lngHistoryCount     As Long             '表示歴数
    
    Dim blnStdValueFlg      As Boolean          '基準値が複数レコードある:True
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntHisNo) Then vntHisNo = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntResultType) Then vntResultType = Empty
    If Not IsMissing(vntItemType) Then vntItemType = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntResult) Then vntResult = Empty
    If Not IsMissing(vntRslValue) Then vntRslValue = Empty
    If Not IsMissing(vntStdFlg) Then vntStdFlg = Empty
    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = Empty
    If Not IsMissing(vntRslCmtName1) Then vntRslCmtName1 = Empty
    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = Empty
    If Not IsMissing(vntRslCmtName2) Then vntRslCmtName2 = Empty
    If Not IsMissing(vntUnit) Then vntUnit = Empty
    If Not IsMissing(vntLowerValue) Then vntLowerValue = Empty
    If Not IsMissing(vntUpperValue) Then vntUpperValue = Empty
    If Not IsMissing(vntCUTargetFlg) Then vntCUTargetFlg = Empty
    If Not IsMissing(vntQuestionRank) Then vntQuestionRank = Empty
    If Not IsMissing(vntClassName) Then vntClassName = Empty
    If Not IsMissing(vntItemQName) Then vntItemQName = Empty
    If Not IsMissing(vntGrpSeq) Then vntGrpSeq = Empty
    If Not IsMissing(vntRslFlg) Then vntRslFlg = Empty
    If Not IsMissing(vntHideInterview) Then vntHideInterview = Empty
    If Not IsMissing(vntMinValue) Then vntMinValue = Empty
    If Not IsMissing(vntMaxValue) Then vntMaxValue = Empty
    If Not IsMissing(vntHealthPoint) Then vntHealthPoint = Empty
   
    '表示歴数が「全件」以外で、数値でない場合はエラー
    If strHisCount <> "*" Then
        If Not IsNumeric(strHisCount) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        lngHistoryCount = CLng(strHisCount)
    Else
        lngHistoryCount = 0
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngHistoryCount > 0 Then
        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GRPCD", IIf(strGrpCd = Null, "", Trim(strGrpCd)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
    strStmt = "SELECT FINALRSL.PERID, FINALRSL.CSLDATE,                     " & vbLf & _
              "       FINALRSL.HISNO, FINALRSL.RSVNO,                       " & vbLf & _
              "       FINALRSL.SEQ, FINALRSL.RSLFLG,                        " & vbLf & _
              "       FINALRSL.ITEMCD, FINALRSL.SUFFIX,                     " & vbLf & _
              "       FINALRSL.RESULTTYPE, FINALRSL.ITEMTYPE,               " & vbLf & _
              "       FINALRSL.ITEMNAME,     FINALRSL.ITEMQNAME,            " & vbLf & _
              "       FINALRSL.RESULT RSLVALUE, FINALRSL.STDFLG,            " & vbLf & _
              "       SENTENCE.QUESTIONRANK, FINALRSL.CLASSNAME,            " & vbLf
    '検査結果のメモタイプ対応
    strStmt = strStmt & _
              "       CASE WHEN FINALRSL.RESULTTYPE = 7 THEN                " & vbLf & _
              "         (SELECT RSLMEMOSTR FROM RSLMEMO                     " & vbLf & _
              "           WHERE RSVNO  = FINALRSL.RSVNO                     " & vbLf & _
              "             AND ITEMCD = FINALRSL.ITEMCD                    " & vbLf & _
              "             AND SUFFIX = FINALRSL.SUFFIX)                   " & vbLf & _
              "       ELSE                                                  " & vbLf & _
              "         NVL(SENTENCE.SHORTSTC, FINALRSL.RESULT)             " & vbLf & _
              "       END RESULT,                                           " & vbLf
    
    '基準値要
    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
'        strStmt = strStmt & _
'              "       STDVALUEVIEW.LOWERVALUE,                              " & vbLf & _
'              "       STDVALUEVIEW.UPPERVALUE,                              " & vbLf
        '基準値の文章タイプ（本来は定性タイプの検査項目）対応
        strStmt = strStmt & _
              "       CASE WHEN FINALRSL.RESULTTYPE = 4 THEN                " & vbLf & _
              "         (SELECT SHORTSTC FROM SENTENCE                      " & vbLf & _
              "           WHERE ITEMCD = FINALRSL.ITEMCD                    " & vbLf & _
              "             AND ITEMTYPE = FINALRSL.ITEMTYPE                " & vbLf & _
              "             AND STCCD = STDVALUEVIEW.LOWERVALUE)            " & vbLf & _
              "       ELSE                                                  " & vbLf & _
              "         STDVALUEVIEW.LOWERVALUE                             " & vbLf & _
              "       END LOWERVALUE,                                       " & vbLf & _
              "       CASE WHEN FINALRSL.RESULTTYPE = 4 THEN                " & vbLf & _
              "         (SELECT SHORTSTC FROM SENTENCE                      " & vbLf & _
              "           WHERE ITEMCD = FINALRSL.ITEMCD                    " & vbLf & _
              "             AND ITEMTYPE = FINALRSL.ITEMTYPE                " & vbLf & _
              "             AND STCCD = STDVALUEVIEW.UPPERVALUE)            " & vbLf & _
              "       ELSE                                                  " & vbLf & _
              "         STDVALUEVIEW.UPPERVALUE                             " & vbLf & _
              "       END UPPERVALUE,                                       " & vbLf
    Else
        strStmt = strStmt & _
              "       NULL LOWERVALUE,                                      " & vbLf & _
              "       NULL UPPERVALUE,                                      " & vbLf
    End If
    strStmt = strStmt & _
              "       FINALRSL.RSLCMTCD1,                                   " & vbLf

    '結果コメント要
    If Not IsMissing(vntRslCmtName1) Then
        strStmt = strStmt & _
              "       (SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
              "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD1) RSLCMTNAME1,   " & vbLf
    Else
        strStmt = strStmt & _
              "       NULL RSLCMTNAME1,                                     " & vbLf
    End If
    
    strStmt = strStmt & _
              "       FINALRSL.RSLCMTCD2,                                   " & vbLf
              
    '結果コメント要
    If Not IsMissing(vntRslCmtName2) Then
        strStmt = strStmt & _
              "       (SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
              "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD2) RSLCMTNAME2,   " & vbLf
    Else
        strStmt = strStmt & _
              "       NULL RSLCMTNAME2,                                     " & vbLf
    End If

    strStmt = strStmt & _
              "       FINALRSL.MINVALUE, FINALRSL.MAXVALUE,                 " & vbLf & _
              "       FINALRSL.HEALTHPOINT,                                 " & vbLf & _
              "       FINALRSL.UNIT, FINALRSL.CUTARGETFLG,                  " & vbLf & _
              "       FINALRSL.HIDEINTERVIEW                                " & vbLf & _
              "  FROM SENTENCE,                                             "

    '検査結果View（検査結果が存在しない場合の対応）
    strStmt = strStmt & _
              "       ( SELECT BASERSL.HISNO,                           " & vbLf & _
              "                BASERSL.CSLDATE, BASERSL.RSVNO,          " & vbLf & _
              "                BASERSL.PERID, BASERSL.SEQ,              " & vbLf & _
              "                BASERSL.ITEMCD, BASERSL.SUFFIX,          " & vbLf & _
              "                BASERSL.RESULT, BASERSL.RSLFLG,          " & vbLf & _
              "                BASERSL.RSLCMTCD1, BASERSL.RSLCMTCD2,    " & vbLf & _
              "                STDVALUE_C.STDFLG, STDVALUE_C.HEALTHPOINT,     " & vbLf & _
              "                ITEMCLASS.CLASSNAME,                     " & vbLf & _
              "                ITEM_C.RESULTTYPE, ITEM_C.ITEMTYPE,      " & vbLf & _
              "                ITEM_C.ITEMNAME, ITEM_C.STCITEMCD,       " & vbLf & _
              "                ITEM_C.ITEMQNAME,ITEM_C.CUTARGETFLG,     " & vbLf & _
              "                ITEM_H.MINVALUE,ITEM_H.MAXVALUE,         " & vbLf & _
              "                ITEM_H.UNIT,ITEM_C.HIDEINTERVIEW         " & vbLf & _
              "           FROM                                          "
    
    '検査結果に存在しない項目を取得のため、検査項目の空レコードと結合
    strStmt = strStmt & _
              "                ( SELECT HISNO, CSLDATE, RSVNO, PERID,   " & vbLf & _
              "                         SEQ, ITEMCD, SUFFIX,            " & vbLf & _
              "                         MAX(RESULT) RESULT,             " & vbLf & _
              "                         MAX(STDVALUECD) STDVALUECD,     " & vbLf & _
              "                         MAX(RSLCMTCD1) RSLCMTCD1,       " & vbLf & _
              "                         MAX(RSLCMTCD2) RSLCMTCD2,       " & vbLf & _
              "                         MAX(RSLFLG) RSLFLG              " & vbLf & _
              "                    FROM 　                              "
    '検査結果に存在するレコード
    strStmt = strStmt & _
              "                         ( SELECT CONSULTVIEW.SEQ HISNO,                     " & vbLf & _
              "                                  CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,    " & vbLf & _
              "                                  CONSULTVIEW.PERID, GRP_I.SEQ,              " & vbLf & _
              "                                  RSL.ITEMCD, RSL.SUFFIX,                    " & vbLf & _
              "                                  RSL.RESULT, RSL.STDVALUECD,                " & vbLf & _
              "                                  RSL.RSLCMTCD1, RSL.RSLCMTCD2,              " & vbLf & _
              "                                  1 RSLFLG                                   " & vbLf & _
              "                             FROM ( "
        
'受診履歴View --------------------Start
    'このViewを２回呼び出すため別変数にセットしておく
    strStmtView = _
              "    SELECT ROWNUM SEQ, CSLDATE, RSVNO, PERID     " & vbLf & _
              "      FROM ( SELECT CONSULT.CSLDATE,             " & vbLf & _
              "                    CONSULT.RSVNO,               " & vbLf & _
              "                    CONSULT.PERID                " & vbLf & _
              "               FROM CONSULT                      " & vbLf & _
              "              WHERE CONSULT.PERID     =          " & vbLf & _
              "                    (SELECT DISTINCT PERID       " & vbLf & _
              "                       FROM CONSULT              " & vbLf & _
              "                      WHERE RSVNO = :RSVNO)      "
    '今回分を含む？
    strStmtView = strStmtView & vbLf & _
              "                AND CONSULT.CSLDATE " & IIf(lngSelectMode = 0, "<= ", "< ") & vbLf & _
              "                    (SELECT DISTINCT CSLDATE     " & vbLf & _
              "                       FROM CONSULT              " & vbLf & _
              "                      WHERE RSVNO = :RSVNO)      "
    
    'コース指定
    Select Case lngLastDspMode
        Case 1
            strStmtView = strStmtView & vbLf & _
              "                AND CONSULT.CSCD = :CSCD         "
        Case 2
            strStmtView = strStmtView & vbLf & _
              "                AND CONSULT.CSCD                 " & vbLf & _
              "                    IN (SELECT FREEFIELD1 CSCD   " & vbLf & _
              "                          FROM FREE              " & vbLf & _
              "                         WHERE FREECD LIKE :CSCD||'%') "
    End Select
    strStmtView = strStmtView & vbLf & _
              "                AND CONSULT.CANCELFLG = 0        " & vbLf & _
              "           ORDER BY CONSULT.CSLDATE DESC )       "
'受診履歴View --------------------End
    
    strStmt = strStmt & vbLf & strStmtView      '受診履歴View
    strStmt = strStmt & vbLf & _
              "                                  ) CONSULTVIEW, RSL, GRP_I                  " & vbLf & _
              "                              WHERE CONSULTVIEW.RSVNO = RSL.RSVNO            "
    If lngHistoryCount > 0 Then
        strStmt = strStmt & vbLf & _
              "                                AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
    End If
    strStmt = strStmt & vbLf & _
              "                                AND RSL.STOPFLG IS NULL                      " & vbLf & _
              "                                AND GRP_I.GRPCD = :GRPCD                     " & vbLf & _
              "                                AND GRP_I.ITEMCD = RSL.ITEMCD                " & vbLf & _
              "                                AND GRP_I.SUFFIX = RSL.SUFFIX                "

    '検査項目が存在しない項目も取得？
    If lngAllDataMode = 1 Then
        '検査結果項目の空レコード
        strStmt = strStmt & _
              "                         UNION ALL                                           " & vbLf & _
              "                           SELECT CONSULTVIEW.SEQ HISNO,                     " & vbLf & _
              "                                  CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,    " & vbLf & _
              "                                  CONSULTVIEW.PERID, GRP_I.SEQ,              " & vbLf & _
              "                                  GRP_I.ITEMCD, GRP_I.SUFFIX,                " & vbLf & _
              "                                  NULL RESULT, NULL STDVALUECD,              " & vbLf & _
              "                                  NULL RSLCMTCD1, NULL RSLCMTCD2,            " & vbLf & _
              "                                  0 RSLFLG                                   " & vbLf & _
              "                             FROM ( "
        strStmt = strStmt & vbLf & strStmtView      '受診履歴View
        strStmt = strStmt & vbLf & _
              "                                  ) CONSULTVIEW, GRP_I                       " & vbLf & _
              "                              WHERE GRP_I.GRPCD = :GRPCD                     "
        If lngHistoryCount > 0 Then
            strStmt = strStmt & vbLf & _
              "                                AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
        End If
    End If
    
    strStmt = strStmt & _
              "                         )                               " & vbLf & _
              "                GROUP BY HISNO, CSLDATE, RSVNO, PERID,   " & vbLf & _
              "                         SEQ, ITEMCD, SUFFIX             "

    strStmt = strStmt & vbLf & _
              "                ) BASERSL, STDVALUE_C, ITEM_C, ITEM_H,           " & vbLf & _
              "                ITEM_P, ITEMCLASS                                " & vbLf & _
              "          WHERE BASERSL.STDVALUECD = STDVALUE_C.STDVALUECD(+)    " & vbLf & _
              "            AND BASERSL.ITEMCD = ITEM_C.ITEMCD                   " & vbLf & _
              "            AND BASERSL.SUFFIX = ITEM_C.SUFFIX                   " & vbLf & _
              "            AND BASERSL.ITEMCD = ITEM_H.ITEMCD                   " & vbLf & _
              "            AND BASERSL.SUFFIX = ITEM_H.SUFFIX                   " & vbLf & _
              "            AND BASERSL.CSLDATE BETWEEN ITEM_H.STRDATE           " & vbLf & _
              "                                    AND ITEM_H.ENDDATE           " & vbLf & _
              "            AND ITEM_C.ITEMCD = ITEM_P.ITEMCD                    " & vbLf & _
              "            AND ITEM_P.CLASSCD = ITEMCLASS.CLASSCD               " & vbLf & _
              "       ) FINALRSL                                                " & vbLf
              
              
    '基準値要
    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
        '基準値取得View
        strStmt = strStmt & _
              "     , (SELECT ITEMCD, SUFFIX, RESULT,                             " & vbLf & _
              "               PRIORSEQ,                                           " & vbLf & _
              "               LOWERVALUE, UPPERVALUE                              " & vbLf & _
              "          FROM ( SELECT RSL.ITEMCD, RSL.SUFFIX, RSL.RESULT,        " & vbLf & _
              "                        RSLSTDVALUE.CSRANK, RSLSTDVALUE.CSCD,      " & vbLf & _
              "                        RSLSTDVALUE.PRIORSEQ, RSLSTDVALUE.STDFLG,  " & vbLf & _
              "                        RSLSTDVALUE.LOWERVALUE,                    " & vbLf & _
              "                        RSLSTDVALUE.UPPERVALUE,                    " & vbLf
              '管理コースの所在によっては複数ヒットすることもあるため､重みつけを行う(最も重いものに若い値)
        strStmt = strStmt & _
              "                        RANK() OVER (PARTITION BY RSLSTDVALUE.ITEMCD, RSLSTDVALUE.SUFFIX  " & vbLf & _
              "                                     ORDER BY RSLSTDVALUE.CSRANK, RSLSTDVALUE.CSCD) STDRANK  " & vbLf
        'ビュー"RSLSTDVALUE"は値を直接指定しないとFULL SCANになるのでまず内部ビューで(アスタリスク指定で一寸手抜き)
        '基準値のない検査結果もあるので(+)指定
        '標準の基準値のみ取得する(NULL指定することで基準値のない検査項目も対象となる)
        '最も重い値、即ち若い値で絞り込み
'2003/12/11 STDFLGがNULLのものは含まない
'        strStmt = strStmt & _
'              "                   FROM                                                     " & vbLf & _
'              "                        ( SELECT *                                          " & vbLf & _
'              "                            FROM RSLSTDVALUE                                " & vbLf & _
'              "                           WHERE RSVNO = :RSVNO ) RSLSTDVALUE,              " & vbLf & _
'              "                         RSL                                                " & vbLf & _
'              "                  WHERE RSL.RSVNO  = :RSVNO                                 " & vbLf & _
'              "                    AND RSL.ITEMCD = RSLSTDVALUE.ITEMCD(+)                  " & vbLf & _
'              "                    AND RSL.SUFFIX = RSLSTDVALUE.SUFFIX(+)                  " & vbLf & _
'              "                    AND ( RSLSTDVALUE.STDFLG IS NULL OR RSLSTDVALUE.STDFLG = 'S' )  " & vbLf & _
'              "                  )                                                         " & vbLf & _
'              "         WHERE STDRANK = 1                                                  " & vbLf & _
'              "         ) STDVALUEVIEW                                                     "
        strStmt = strStmt & _
              "                   FROM                                                     " & vbLf & _
              "                        ( SELECT *                                          " & vbLf & _
              "                            FROM RSLSTDVALUE                                " & vbLf & _
              "                           WHERE RSVNO = :RSVNO ) RSLSTDVALUE,              " & vbLf & _
              "                         RSL                                                " & vbLf & _
              "                  WHERE RSL.RSVNO  = :RSVNO                                 " & vbLf & _
              "                    AND RSL.ITEMCD = RSLSTDVALUE.ITEMCD(+)                  " & vbLf & _
              "                    AND RSL.SUFFIX = RSLSTDVALUE.SUFFIX(+)                  " & vbLf & _
              "                    AND RSLSTDVALUE.STDFLG = 'S'                            " & vbLf & _
              "                  )                                                         " & vbLf & _
              "         WHERE STDRANK = 1                                                  " & vbLf & _
              "         ) STDVALUEVIEW                                                     "
    End If
    
    strStmt = strStmt & vbLf & _
              " WHERE FINALRSL.STCITEMCD = SENTENCE.ITEMCD(+)           " & vbLf & _
              "   AND FINALRSL.ITEMTYPE  = SENTENCE.ITEMTYPE(+)         " & vbLf & _
              "   AND FINALRSL.RESULT    = SENTENCE.STCCD(+)            "
    '基準値要
    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
        strStmt = strStmt & vbLf & _
                  "   AND FINALRSL.ITEMCD    = STDVALUEVIEW.ITEMCD(+)       " & vbLf & _
                  "   AND FINALRSL.SUFFIX    = STDVALUEVIEW.SUFFIX(+)       "
    End If
    
    Select Case lngGetSeqMode
    Case 0
        strStmt = strStmt & vbLf & _
              " ORDER BY FINALRSL.SEQ,                                  " & vbLf & _
              "          FINALRSL.CSLDATE" & IIf(lngDateSort = 0, " DESC ", "")
    Case 1
        strStmt = strStmt & vbLf & _
              " ORDER BY FINALRSL.CSLDATE" & IIf(lngDateSort = 0, " DESC, ", ", ") & vbLf & _
              "          FINALRSL.ITEMCD, FINALRSL.SUFFIX               "
    Case 2
        strStmt = strStmt & vbLf & _
              " ORDER BY FINALRSL.CSLDATE" & IIf(lngDateSort = 0, " DESC, ", ", ") & vbLf & _
              "          FINALRSL.SEQ                                   "
    End Select
    '基準値要
    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
        strStmt = strStmt & vbLf & _
              "          , STDVALUEVIEW.PRIORSEQ                        "
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objCslDate = objFields("CSLDATE")
        Set objHisNo = objFields("HISNO")
        Set objRsvNo = objFields("RSVNO")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objRslValue = objFields("RSLVALUE")
        Set objStdFlg = objFields("STDFLG")
        Set objRslCmtCd1 = objFields("RSLCMTCD1")
        Set objRslCmtName1 = objFields("RSLCMTNAME1")
        Set objRslCmtCd2 = objFields("RSLCMTCD2")
        Set objRslCmtName2 = objFields("RSLCMTNAME1")
        Set objUnit = objFields("UNIT")
        Set objLowerValue = objFields("LOWERVALUE")
        Set objUpperValue = objFields("UPPERVALUE")
        Set objCUTargetFlg = objFields("CUTARGETFLG")
        Set objQuestionRank = objFields("QUESTIONRANK")
        Set objClassName = objFields("CLASSNAME")
        Set objItemQName = objFields("ITEMQNAME")
        Set objGrpSeq = objFields("SEQ")
        Set objRslFlg = objFields("RSLFLG")
        Set objHideInterview = objFields("HIDEINTERVIEW")
        Set objMinValue = objFields("MINVALUE")
        Set objMaxValue = objFields("MAXVALUE")
        Set objHealthPoint = objFields("HEALTHPOINT")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
        
            blnStdValueFlg = False
            '基準値が複数レコードあるか？
            If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
                If lngCount > 0 Then
                    If vntArrRsvNo(lngCount - 1) = (objRsvNo.Value & "") And _
                       vntArrItemCd(lngCount - 1) = (objItemCd.Value & "") And _
                       vntArrSuffix(lngCount - 1) = (objSuffix.Value & "") Then
                       
                        blnStdValueFlg = True
                    End If
                End If
            End If
            If blnStdValueFlg Then
                '結果タイプが文章のとき特殊処理
                If vntArrResultType(lngCount - 1) = 4 Then
                    vntArrUpperValue(lngCount - 1) = vntArrUpperValue(lngCount - 1) & "," & objUpperValue.Value & ""
                Else
                    '前のレコードの基準値（最大値）のみを書き換える
                    vntArrUpperValue(lngCount - 1) = objUpperValue.Value & ""
                End If
            Else
                ReDim Preserve vntArrPerId(lngCount)
                ReDim Preserve vntArrCslDate(lngCount)
                ReDim Preserve vntArrHisNo(lngCount)
                ReDim Preserve vntArrRsvNo(lngCount)
                ReDim Preserve vntArrItemCd(lngCount)
                ReDim Preserve vntArrSuffix(lngCount)
                ReDim Preserve vntArrResultType(lngCount)
                ReDim Preserve vntArrItemType(lngCount)
                ReDim Preserve vntArrItemName(lngCount)
                ReDim Preserve vntArrResult(lngCount)
                ReDim Preserve vntArrRslValue(lngCount)
                ReDim Preserve vntArrStdFlg(lngCount)
                ReDim Preserve vntArrRslCmtCd1(lngCount)
                ReDim Preserve vntArrRslCmtName1(lngCount)
                ReDim Preserve vntArrRslCmtCd2(lngCount)
                ReDim Preserve vntArrRslCmtName2(lngCount)
                ReDim Preserve vntArrUnit(lngCount)
                ReDim Preserve vntArrLowerValue(lngCount)
                ReDim Preserve vntArrUpperValue(lngCount)
                ReDim Preserve vntArrCUTargetFlg(lngCount)
                ReDim Preserve vntArrQuestionRank(lngCount)
                ReDim Preserve vntArrClassName(lngCount)
                ReDim Preserve vntArrItemQName(lngCount)
                ReDim Preserve vntArrGrpSeq(lngCount)
                ReDim Preserve vntArrRslFlg(lngCount)
                ReDim Preserve vntArrHideInterview(lngCount)
                ReDim Preserve vntArrMinValue(lngCount)
                ReDim Preserve vntArrMaxValue(lngCount)
                ReDim Preserve vntArrHealthPoint(lngCount)
                vntArrPerId(lngCount) = objPerId.Value & ""
                vntArrCslDate(lngCount) = objCslDate.Value & ""
                vntArrHisNo(lngCount) = objHisNo.Value & ""
                vntArrRsvNo(lngCount) = objRsvNo.Value & ""
                vntArrItemCd(lngCount) = objItemCd.Value & ""
                vntArrSuffix(lngCount) = objSuffix.Value & ""
                vntArrResultType(lngCount) = objResultType.Value & ""
                vntArrItemType(lngCount) = objItemType.Value & ""
                vntArrItemName(lngCount) = objItemName.Value & ""
                vntArrResult(lngCount) = objResult.Value & ""
                vntArrRslValue(lngCount) = objRslValue.Value & ""
                vntArrStdFlg(lngCount) = objStdFlg.Value & ""
                vntArrRslCmtCd1(lngCount) = objRslCmtCd1.Value & ""
                vntArrRslCmtName1(lngCount) = objRslCmtName1.Value & ""
                vntArrRslCmtCd2(lngCount) = objRslCmtCd2.Value & ""
                vntArrRslCmtName2(lngCount) = objRslCmtName2.Value & ""
                vntArrUnit(lngCount) = objUnit.Value & ""
                vntArrLowerValue(lngCount) = objLowerValue.Value & ""
                vntArrUpperValue(lngCount) = objUpperValue.Value & ""
                vntArrCUTargetFlg(lngCount) = objCUTargetFlg.Value & ""
                vntArrQuestionRank(lngCount) = objQuestionRank.Value & ""
                vntArrClassName(lngCount) = objClassName.Value & ""
                vntArrItemQName(lngCount) = objItemQName.Value & ""
                vntArrGrpSeq(lngCount) = objGrpSeq.Value & ""
                vntArrRslFlg(lngCount) = objRslFlg.Value & ""
                vntArrHideInterview(lngCount) = objHideInterview.Value & ""
                vntArrMinValue(lngCount) = objMinValue.Value & ""
                vntArrMaxValue(lngCount) = objMaxValue.Value & ""
                vntArrHealthPoint(lngCount) = objHealthPoint.Value & ""
                lngCount = lngCount + 1
            End If
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    If Not IsMissing(vntHisNo) Then vntHisNo = vntArrHisNo
    If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
    If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
    If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
    If Not IsMissing(vntResultType) Then vntResultType = vntArrResultType
    If Not IsMissing(vntItemType) Then vntItemType = vntArrItemType
    If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
    If Not IsMissing(vntResult) Then vntResult = vntArrResult
    If Not IsMissing(vntRslValue) Then vntRslValue = vntArrRslValue
    If Not IsMissing(vntStdFlg) Then vntStdFlg = vntArrStdFlg
    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = vntArrRslCmtCd1
    If Not IsMissing(vntRslCmtName1) Then vntRslCmtName1 = vntArrRslCmtName1
    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = vntArrRslCmtCd2
    If Not IsMissing(vntRslCmtName2) Then vntRslCmtName2 = vntArrRslCmtName2
    If Not IsMissing(vntUnit) Then vntUnit = vntArrUnit
    If Not IsMissing(vntLowerValue) Then vntLowerValue = vntArrLowerValue
    If Not IsMissing(vntUpperValue) Then vntUpperValue = vntArrUpperValue
    If Not IsMissing(vntCUTargetFlg) Then vntCUTargetFlg = vntArrCUTargetFlg
    If Not IsMissing(vntQuestionRank) Then vntQuestionRank = vntArrQuestionRank
    If Not IsMissing(vntClassName) Then vntClassName = vntArrClassName
    If Not IsMissing(vntItemQName) Then vntItemQName = vntArrItemQName
    If Not IsMissing(vntGrpSeq) Then vntGrpSeq = vntArrGrpSeq
    If Not IsMissing(vntRslFlg) Then vntRslFlg = vntArrRslFlg
    If Not IsMissing(vntHideInterview) Then vntHideInterview = vntArrHideInterview
    If Not IsMissing(vntMinValue) Then vntMinValue = vntArrMinValue
    If Not IsMissing(vntMaxValue) Then vntMaxValue = vntArrMaxValue
    If Not IsMissing(vntHealthPoint) Then vntHealthPoint = vntArrHealthPoint
    
    SelectHistoryRslList = lngCount
        
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み ## クラス名修正　2004.01.13
    WriteErrorLog "Interview.SelectHistoryRslList"
    
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
'#### 2012/09/20 張 2012/10/1日からの問診票改訂関連仕様変更（ヘルスポイント項目追加モジュール追加）End   ###



'
' 機能　　 : 予約番号をキーに指定対象受診者の検査結果歴を取得する（検査項目指定）
'
' 引数　　 : (In)     lngRsvNo       予約番号（今回分）
' 　　　　   (In)     strHisCount    表示歴数
' 　　　　   (In)     vntSelectItemCd 検査項目コード（配列）
' 　　　　   (In)     vntSelectSuffix サフィックス（配列）
' 　　　　   (In)     lngLastDspMode 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
' 　　　　   (In)     vntCsGrp       前回歴表示モード＝0のとき、null
' 　　　　                                          ＝1のとき、コースコード
' 　　　　                                          ＝2のとき、コースグループコード
' 　　　　   (In)     lngGetSeqMode  取得順 0:コード＋サフィックス＋日付　1:日付＋コード＋サフィックス
' 　　　　   (In)     lngSelectMode  データ取得モード（0:今回分含む、1:前回分以前）
' 　　　　   (In)     lngAllDataMode 全件取得モード（0:検査結果に存在する項目を取得、1:検査結果に存在しなくても全項目取得）
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntCslDate     受診日
' 　　　　   (Out)    vntHisNo       履歴No.
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntItemCd      検査項目コード
' 　　　　   (Out)    vntSuffix      サフィックス
' 　　　　   (Out)    vntResultType  結果タイプ
' 　　　　   (Out)    vntItemType    項目タイプ
' 　　　　   (Out)    vntClassName   検査分類名称
' 　　　　   (Out)    vntItemName    検査項目名称
' 　　　　   (Out)    vntRslFlg      検査結果存在フラグ(1:検査結果に存在する、0:検査結果に存在しない）
' 　　　　   (Out)    vntResult      検査結果(数値タイプはそのまま、文章タイプは文章を返す)
' 　　　　   (Out)    vntRslValue    検査結果(数値タイプ、文章タイプにかかわらずそのまま返す)
' 　　　　   (Out)    vntUnit        単位
' 　　　　   (Out)    vntLowerValue  基準値（最低）
' 　　　　   (Out)    vntUpperValue  基準値（最高）
' 　　　　   (Out)    vntStdFlg      基準値フラグ
' 　　　　   (Out)    vntCUTargetFlg CU経年変化表示対象
' 　　　　   (Out)    vntRslCmtCd1   結果コメント１
' 　　　　   (Out)    vntRslCmtName1 結果コメント名１
' 　　　　   (Out)    vntRslCmtCd2   結果コメント２
' 　　　　   (Out)    vntRslCmtName2 結果コメント名２
' 　　　　   (In)     lngDateSort    日付順(0:今回が先頭、1:今回が最後)
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectHistoryRslList_Item( _
    ByVal lngRsvNo As Long, _
    ByVal strHisCount As String, _
    ByRef vntSelectItemCd As Variant, _
    ByRef vntSelectSuffix As Variant, _
    ByVal lngLastDspMode As Long, _
    ByVal vntCsGrp As Variant, _
    ByVal lngGetSeqMode As Long, _
    Optional ByVal lngSelectMode As Long = 0, _
    Optional ByVal lngAllDataMode As Long = 0, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntHisNo As Variant, Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntItemCd As Variant, Optional ByRef vntSuffix As Variant, _
    Optional ByRef vntResultType As Variant, Optional ByRef vntItemType As Variant, _
    Optional ByRef vntClassName As Variant, Optional ByRef vntItemName As Variant, _
    Optional ByRef vntRslFlg As Variant, Optional ByRef vntResult As Variant, _
    Optional ByRef vntRslValue As Variant, Optional ByRef vntUnit As Variant, _
    Optional ByRef vntLowerValue As Variant, Optional ByRef vntUpperValue As Variant, _
    Optional ByRef vntStdFlg As Variant, Optional ByRef vntCUTargetFlg As Variant, _
    Optional ByRef vntRslCmtCd1 As Variant, Optional ByRef vntRslCmtName1 As Variant, _
    Optional ByRef vntRslCmtCd2 As Variant, Optional ByRef vntRslCmtName2 As Variant, _
    Optional ByVal lngDateSort As Long = 0 _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    Dim strStmtView         As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objCslDate          As OraField         '受診日
    Dim objHisNo            As OraField         '履歴No.
    Dim objRsvNo            As OraField         '予約番号
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objClassName        As OraField         '検査分類名称
    Dim objItemName         As OraField         '検査項目名称
    Dim objRslFlg           As OraField         '検査結果存在フラグ
    Dim objResult           As OraField         '検査結果
    Dim objRslValue         As OraField         '検査結果
    Dim objUnit             As OraField         '単位
    Dim objLowerValue       As OraField         '基準値（最低）
    Dim objUpperValue       As OraField         '基準値（最高）
    Dim objStdFlg           As OraField         '基準値フラグ
    Dim objCUTargetFlg      As OraField         'CU経年変化表示対象
    Dim objRslCmtCd1        As OraField         '結果コメント１
    Dim objRslCmtName1      As OraField         '結果コメント名１
    Dim objRslCmtCd2        As OraField         '結果コメント２
    Dim objRslCmtName2      As OraField         '結果コメント名２
    
    Dim vntArrHisNo()       As Variant          '履歴No.の配列
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrClassName()   As Variant          '検査分類の配列
    Dim vntArrItemName()    As Variant          '検査項目名称の配列
    Dim vntArrRslFlg()      As Variant          '検査結果存在フラグの配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrRslValue()    As Variant          '検査結果の配列
    Dim vntArrUnit()        As Variant          '単位の配列
    Dim vntArrLowerValue()  As Variant          '基準値（最低）の配列
    Dim vntArrUpperValue()  As Variant          '基準値（最高）の配列
    Dim vntArrStdFlg()      As Variant          '基準値フラグの配列
    Dim vntArrCUTargetFlg() As Variant          'CU経年変化表示対象の配列
    Dim vntArrRslCmtCd1()   As Variant          '結果コメント１の配列
    Dim vntArrRslCmtName1() As Variant          '結果コメント名１の配列
    Dim vntArrRslCmtCd2()   As Variant          '結果コメント２の配列
    Dim vntArrRslCmtName2() As Variant          '結果コメント名２の配列
    
    Dim lngCount            As Long             'レコード数
    Dim lngHistoryCount     As Long             '表示歴数
    
    Dim blnStdValueFlg      As Boolean          '基準値が複数レコードある:True
        
    Dim strStmtSelectItem   As String           'SQLステートメント（検査項目の指定）
    Dim i                   As Long             'ループカウンタ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntHisNo) Then vntHisNo = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntResultType) Then vntResultType = Empty
    If Not IsMissing(vntItemType) Then vntItemType = Empty
    If Not IsMissing(vntClassName) Then vntClassName = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntRslFlg) Then vntRslFlg = Empty
    If Not IsMissing(vntResult) Then vntResult = Empty
    If Not IsMissing(vntRslValue) Then vntRslValue = Empty
    If Not IsMissing(vntUnit) Then vntUnit = Empty
    If Not IsMissing(vntLowerValue) Then vntLowerValue = Empty
    If Not IsMissing(vntUpperValue) Then vntUpperValue = Empty
    If Not IsMissing(vntStdFlg) Then vntStdFlg = Empty
    If Not IsMissing(vntCUTargetFlg) Then vntCUTargetFlg = Empty
    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = Empty
    If Not IsMissing(vntRslCmtName1) Then vntRslCmtName1 = Empty
    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = Empty
    If Not IsMissing(vntRslCmtName2) Then vntRslCmtName2 = Empty
   
    '表示歴数が「全件」以外で、数値でない場合はエラー
    If strHisCount <> "*" Then
        If Not IsNumeric(strHisCount) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        lngHistoryCount = CLng(strHisCount)
    Else
        lngHistoryCount = 0
    End If
    
    '指定された検査項目コードとサフィックスの数が異なる場合はエラー
    If IsArray(vntSelectItemCd) Then
        If Not IsArray(vntSelectSuffix) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        If UBound(vntSelectItemCd) <> UBound(vntSelectSuffix) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        strStmtSelectItem = " IN ( "
        For i = 0 To UBound(vntSelectItemCd)
            strStmtSelectItem = strStmtSelectItem & IIf(i = 0, "", ",") & _
                                "'" & vntSelectItemCd(i) & "-" & vntSelectSuffix(i) & "'"
        Next
        strStmtSelectItem = strStmtSelectItem & " ) "
    Else
        If IsArray(vntSelectSuffix) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        strStmtSelectItem = " = '" & vntSelectItemCd & "-" & vntSelectSuffix & "' "
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngHistoryCount > 0 Then
        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
    strStmt = "SELECT FINALRSL.HISNO, FINALRSL.PERID,                       " & vbLf & _
              "       FINALRSL.CSLDATE, FINALRSL.RSVNO,                     " & vbLf & _
              "       FINALRSL.ITEMCD, FINALRSL.SUFFIX,                     " & vbLf & _
              "       FINALRSL.RESULTTYPE, FINALRSL.ITEMTYPE,               " & vbLf & _
              "       FINALRSL.CLASSNAME, FINALRSL.ITEMNAME,                " & vbLf & _
              "       FINALRSL.RSLFLG,                                      " & vbLf & _
              "       FINALRSL.RESULT RSLVALUE, FINALRSL.STDFLG,            " & vbLf
    '検査結果のメモタイプ対応
    strStmt = strStmt & _
              "       CASE WHEN FINALRSL.RESULTTYPE = 7 THEN                " & vbLf & _
              "         (SELECT RSLMEMOSTR FROM RSLMEMO                     " & vbLf & _
              "           WHERE RSVNO  = FINALRSL.RSVNO                     " & vbLf & _
              "             AND ITEMCD = FINALRSL.ITEMCD                    " & vbLf & _
              "             AND SUFFIX = FINALRSL.SUFFIX)                   " & vbLf & _
              "       ELSE                                                  " & vbLf & _
              "         NVL(SENTENCE.SHORTSTC, FINALRSL.RESULT)             " & vbLf & _
              "       END RESULT,                                           " & vbLf
    
    '基準値要
    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
        
'### 2004/07/15 Updated by Ishihara@FSIT 受診日毎の正しい基準値がとれない
'        '基準値の文章タイプ（本来は定性タイプの検査項目）対応
'        strStmt = strStmt & _
'              "       CASE WHEN FINALRSL.RESULTTYPE = 4 THEN                " & vbLf & _
'              "         (SELECT SHORTSTC FROM SENTENCE                      " & vbLf & _
'              "           WHERE ITEMCD = FINALRSL.ITEMCD                    " & vbLf & _
'              "             AND ITEMTYPE = FINALRSL.ITEMTYPE                " & vbLf & _
'              "             AND STCCD = STDVALUEVIEW.LOWERVALUE)            " & vbLf & _
'              "       ELSE                                                  " & vbLf & _
'              "         STDVALUEVIEW.LOWERVALUE                             " & vbLf & _
'              "       END LOWERVALUE,                                       " & vbLf & _
'              "       CASE WHEN FINALRSL.RESULTTYPE = 4 THEN                " & vbLf & _
'              "         (SELECT SHORTSTC FROM SENTENCE                      " & vbLf & _
'              "           WHERE ITEMCD = FINALRSL.ITEMCD                    " & vbLf & _
'              "             AND ITEMTYPE = FINALRSL.ITEMTYPE                " & vbLf & _
'              "             AND STCCD = STDVALUEVIEW.UPPERVALUE)            " & vbLf & _
'              "       ELSE                                                  " & vbLf & _
'              "         STDVALUEVIEW.UPPERVALUE                             " & vbLf & _
'              "       END UPPERVALUE,                                       " & vbLf
        strStmt = strStmt & _
              "       GETSTANDARDRANGE('L', FINALRSL.RSVNO, FINALRSL.ITEMCD, FINALRSL.SUFFIX) LOWERVALUE, " & vbLf & _
              "       GETSTANDARDRANGE('U', FINALRSL.RSVNO, FINALRSL.ITEMCD, FINALRSL.SUFFIX) UPPERVALUE, " & vbLf
'### 2004/07/15 Updated End
    
    Else
        strStmt = strStmt & _
              "       NULL LOWERVALUE,                                      " & vbLf & _
              "       NULL UPPERVALUE,                                      " & vbLf
    End If
    strStmt = strStmt & _
              "       FINALRSL.RSLCMTCD1,                                   " & vbLf

    '結果コメント要
    If Not IsMissing(vntRslCmtName1) Then
        strStmt = strStmt & _
                  "       (SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
                  "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD1) RSLCMTNAME1,   " & vbLf
    Else
        strStmt = strStmt & _
                  "       NULL RSLCMTNAME1,                       " & vbLf
    End If
    
    strStmt = strStmt & _
              "       FINALRSL.RSLCMTCD2,                                   " & vbLf
              
    '結果コメント要
    If Not IsMissing(vntRslCmtName2) Then
        strStmt = strStmt & _
                  "       (SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
                  "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD2) RSLCMTNAME2,   " & vbLf
    Else
        strStmt = strStmt & _
                  "       NULL RSLCMTNAME2,                       " & vbLf
    End If

    strStmt = strStmt & _
              "       FINALRSL.UNIT, FINALRSL.CUTARGETFLG                   " & vbLf & _
              "  FROM SENTENCE,                                             "

    '検査結果View（検査結果が存在しない場合の対応）
    strStmt = strStmt & _
              "       ( SELECT BASERSL.HISNO, BASERSL.PERID,            " & vbLf & _
              "                BASERSL.CSLDATE, BASERSL.RSVNO,          " & vbLf & _
              "                BASERSL.ITEMCD, BASERSL.SUFFIX,          " & vbLf & _
              "                BASERSL.RESULT, BASERSL.RSLFLG,          " & vbLf & _
              "                BASERSL.RSLCMTCD1, BASERSL.RSLCMTCD2,    " & vbLf & _
              "                STDVALUE_C.STDFLG, ITEMCLASS.CLASSNAME,  " & vbLf & _
              "                ITEM_C.RESULTTYPE, ITEM_C.ITEMTYPE,      " & vbLf & _
              "                ITEM_C.ITEMNAME, ITEM_C.STCITEMCD,       " & vbLf & _
              "                ITEM_C.CUTARGETFLG, ITEM_H.UNIT          " & vbLf & _
              "           FROM                                          "
    
    '検査結果に存在しない項目を取得のため、検査項目の空レコードと結合
    strStmt = strStmt & _
              "                ( SELECT HISNO, CSLDATE, RSVNO, PERID,   " & vbLf & _
              "                         ITEMCD, SUFFIX,                 " & vbLf & _
              "                         MAX(RESULT) RESULT,             " & vbLf & _
              "                         MAX(STDVALUECD) STDVALUECD,     " & vbLf & _
              "                         MAX(RSLCMTCD1) RSLCMTCD1,       " & vbLf & _
              "                         MAX(RSLCMTCD2) RSLCMTCD2,       " & vbLf & _
              "                         MAX(RSLFLG) RSLFLG              " & vbLf & _
              "                    FROM 　                              "
    '検査結果に存在するレコード
    strStmt = strStmt & _
              "                         ( SELECT CONSULTVIEW.SEQ HISNO,                     " & vbLf & _
              "                                  CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,    " & vbLf & _
              "                                  CONSULTVIEW.PERID,                         " & vbLf & _
              "                                  RSL.ITEMCD, RSL.SUFFIX,                    " & vbLf & _
              "                                  RSL.RESULT, RSL.STDVALUECD,                " & vbLf & _
              "                                  RSL.RSLCMTCD1, RSL.RSLCMTCD2,              " & vbLf & _
              "                                  1 RSLFLG                                   " & vbLf & _
              "                             FROM ( "
        
'受診履歴View --------------------Start
    'このViewを２回呼び出すため別変数にセットしておく
    strStmtView = _
              "    SELECT ROWNUM SEQ, CSLDATE, RSVNO, PERID     " & vbLf & _
              "      FROM ( SELECT CONSULT.CSLDATE,             " & vbLf & _
              "                    CONSULT.RSVNO,               " & vbLf & _
              "                    CONSULT.PERID                " & vbLf & _
              "               FROM CONSULT                      " & vbLf & _
              "              WHERE CONSULT.PERID     =          " & vbLf & _
              "                    (SELECT DISTINCT PERID       " & vbLf & _
              "                       FROM CONSULT              " & vbLf & _
              "                      WHERE RSVNO = :RSVNO)      "
    '今回分を含む？
    strStmtView = strStmtView & vbLf & _
              "                AND CONSULT.CSLDATE " & IIf(lngSelectMode = 0, "<= ", "< ") & vbLf & _
              "                    (SELECT DISTINCT CSLDATE     " & vbLf & _
              "                       FROM CONSULT              " & vbLf & _
              "                      WHERE RSVNO = :RSVNO)      "
    
    'コース指定
    Select Case lngLastDspMode
        Case 1
            strStmtView = strStmtView & vbLf & _
              "                AND CONSULT.CSCD = :CSCD         "
        Case 2
            strStmtView = strStmtView & vbLf & _
              "                AND CONSULT.CSCD                 " & vbLf & _
              "                    IN (SELECT FREEFIELD1 CSCD   " & vbLf & _
              "                          FROM FREE              " & vbLf & _
              "                         WHERE FREECD LIKE :CSCD||'%') "
    End Select
    strStmtView = strStmtView & vbLf & _
              "                AND CONSULT.CANCELFLG = 0        " & vbLf & _
              "           ORDER BY CONSULT.CSLDATE DESC )       "
'受診履歴View --------------------End
    
    strStmt = strStmt & vbLf & strStmtView      '受診履歴View
    strStmt = strStmt & vbLf & _
              "                                  ) CONSULTVIEW, RSL                         " & vbLf & _
              "                              WHERE CONSULTVIEW.RSVNO = RSL.RSVNO            "
    If lngHistoryCount > 0 Then
        strStmt = strStmt & vbLf & _
              "                                AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
    End If
    strStmt = strStmt & vbLf & _
              "                                AND RSL.ITEMCD || '-' || RSL.SUFFIX          " & vbLf & _
              "                                " & strStmtSelectItem & vbLf & _
              "                                AND RSL.STOPFLG IS NULL                      "
    
    '検査項目が存在しない項目も取得？
    If lngAllDataMode = 1 Then
        '検査結果項目の空レコード
        strStmt = strStmt & _
              "                         UNION ALL                                           " & vbLf & _
              "                           SELECT CONSULTVIEW.SEQ HISNO,                     " & vbLf & _
              "                                  CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,    " & vbLf & _
              "                                  CONSULTVIEW.PERID,                         " & vbLf & _
              "                                  ITEM_C.ITEMCD, ITEM_C.SUFFIX,              " & vbLf & _
              "                                  NULL RESULT, NULL STDVALUECD,              " & vbLf & _
              "                                  NULL RSLCMTCD1, NULL RSLCMTCD2,            " & vbLf & _
              "                                  0 RSLFLG                                   " & vbLf & _
              "                             FROM ( "
        strStmt = strStmt & vbLf & strStmtView      '受診履歴View
        strStmt = strStmt & vbLf & _
              "                                  ) CONSULTVIEW, ITEM_C                      " & vbLf & _
              "                              WHERE ITEM_C.ITEMCD || '-' || ITEM_C.SUFFIX    " & vbLf & _
              "                                " & strStmtSelectItem & vbLf
        If lngHistoryCount > 0 Then
            strStmt = strStmt & vbLf & _
              "                                AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
        End If
    End If
    
    strStmt = strStmt & _
              "                         )                               " & vbLf & _
              "                GROUP BY HISNO, PERID, CSLDATE, RSVNO,   " & vbLf & _
              "                         ITEMCD, SUFFIX                  "

    strStmt = strStmt & vbLf & _
              "                ) BASERSL, STDVALUE_C, ITEM_C, ITEM_H,           " & vbLf & _
              "                ITEM_P, ITEMCLASS                                " & vbLf & _
              "          WHERE BASERSL.STDVALUECD = STDVALUE_C.STDVALUECD(+)    " & vbLf & _
              "            AND BASERSL.ITEMCD = ITEM_C.ITEMCD                   " & vbLf & _
              "            AND BASERSL.SUFFIX = ITEM_C.SUFFIX                   " & vbLf & _
              "            AND BASERSL.ITEMCD = ITEM_H.ITEMCD                   " & vbLf & _
              "            AND BASERSL.SUFFIX = ITEM_H.SUFFIX                   " & vbLf & _
              "            AND BASERSL.CSLDATE BETWEEN ITEM_H.STRDATE           " & vbLf & _
              "                                    AND ITEM_H.ENDDATE           " & vbLf & _
              "            AND ITEM_C.ITEMCD = ITEM_P.ITEMCD                    " & vbLf & _
              "            AND ITEM_P.CLASSCD = ITEMCLASS.CLASSCD               " & vbLf & _
              "       ) FINALRSL                                                " & vbLf
              
              
'### 2004/07/15 Deleted by Ishihara@FSIT 受診日毎の正しい基準値がとれない（ストアド化したため、不要）
'    '基準値要
'    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
'        '基準値取得View
'        strStmt = strStmt & _
'              "     , (SELECT ITEMCD, SUFFIX, RESULT,                             " & vbLf & _
'              "               PRIORSEQ,                                           " & vbLf & _
'              "               LOWERVALUE, UPPERVALUE                              " & vbLf & _
'              "          FROM ( SELECT RSL.ITEMCD, RSL.SUFFIX, RSL.RESULT,        " & vbLf & _
'              "                        RSLSTDVALUE.CSRANK, RSLSTDVALUE.CSCD,      " & vbLf & _
'              "                        RSLSTDVALUE.PRIORSEQ, RSLSTDVALUE.STDFLG,  " & vbLf & _
'              "                        RSLSTDVALUE.LOWERVALUE,                    " & vbLf & _
'              "                        RSLSTDVALUE.UPPERVALUE,                    " & vbLf
'              '管理コースの所在によっては複数ヒットすることもあるため､重みつけを行う(最も重いものに若い値)
'        strStmt = strStmt & _
'              "                        RANK() OVER (PARTITION BY RSLSTDVALUE.ITEMCD, RSLSTDVALUE.SUFFIX  " & vbLf & _
'              "                                     ORDER BY RSLSTDVALUE.CSRANK, RSLSTDVALUE.CSCD) STDRANK  " & vbLf
'        'ビュー"RSLSTDVALUE"は値を直接指定しないとFULL SCANになるのでまず内部ビューで(アスタリスク指定で一寸手抜き)
'        '基準値のない検査結果もあるので(+)指定
'        '標準の基準値のみ取得する(NULL指定することで基準値のない検査項目も対象となる)
'        '最も重い値、即ち若い値で絞り込み
'        strStmt = strStmt & _
'              "                   FROM                                                     " & vbLf & _
'              "                        ( SELECT *                                          " & vbLf & _
'              "                            FROM RSLSTDVALUE                                " & vbLf & _
'              "                           WHERE RSVNO = :RSVNO ) RSLSTDVALUE,              " & vbLf & _
'              "                         RSL                                                " & vbLf & _
'              "                  WHERE RSL.RSVNO  = :RSVNO                                 " & vbLf & _
'              "                    AND RSL.ITEMCD = RSLSTDVALUE.ITEMCD(+)                  " & vbLf & _
'              "                    AND RSL.SUFFIX = RSLSTDVALUE.SUFFIX(+)                  " & vbLf & _
'              "                    AND RSLSTDVALUE.STDFLG = 'S'                            " & vbLf & _
'              "                  )                                                         " & vbLf & _
'              "         WHERE STDRANK = 1                                                  " & vbLf & _
'              "         ) STDVALUEVIEW                                                     "
'    End If
'### 2004/07/15 Deleted End
    
    strStmt = strStmt & vbLf & _
              " WHERE FINALRSL.STCITEMCD = SENTENCE.ITEMCD(+)           " & vbLf & _
              "   AND FINALRSL.ITEMTYPE  = SENTENCE.ITEMTYPE(+)         " & vbLf & _
              "   AND FINALRSL.RESULT    = SENTENCE.STCCD(+)            "
'### 2004/07/15 Deleted by Ishihara@FSIT 受診日毎の正しい基準値がとれない（ストアド化したため、不要）
'    '基準値要
'    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
'        strStmt = strStmt & vbLf & _
'                  "   AND FINALRSL.ITEMCD    = STDVALUEVIEW.ITEMCD(+)       " & vbLf & _
'                  "   AND FINALRSL.SUFFIX    = STDVALUEVIEW.SUFFIX(+)       "
'    End If
'### 2004/07/15 Deleted End
    
    If lngGetSeqMode = 0 Then
        strStmt = strStmt & vbLf & _
              " ORDER BY FINALRSL.ITEMCD, FINALRSL.SUFFIX,              " & vbLf & _
              "          FINALRSL.CSLDATE" & IIf(lngDateSort = 0, " DESC", "")
    Else
        strStmt = strStmt & vbLf & _
              " ORDER BY FINALRSL.CSLDATE" & IIf(lngDateSort = 0, " DESC, ", ", ") & vbLf & _
              "          FINALRSL.ITEMCD, FINALRSL.SUFFIX               "
    End If
    
'### 2004/07/15 Deleted by Ishihara@FSIT 受診日毎の正しい基準値がとれない（ストアド化したため、不要）
'    '基準値要
'    If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
'        strStmt = strStmt & vbLf & _
'              "          , STDVALUEVIEW.PRIORSEQ                        "
'    End If
'### 2004/07/15 Deleted End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objHisNo = objFields("HISNO")
        Set objPerId = objFields("PERID")
        Set objCslDate = objFields("CSLDATE")
        Set objRsvNo = objFields("RSVNO")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objClassName = objFields("CLASSNAME")
        Set objItemName = objFields("ITEMNAME")
        Set objRslFlg = objFields("RSLFLG")
        Set objResult = objFields("RESULT")
        Set objRslValue = objFields("RSLVALUE")
        Set objUnit = objFields("UNIT")
        Set objLowerValue = objFields("LOWERVALUE")
        Set objUpperValue = objFields("UPPERVALUE")
        Set objStdFlg = objFields("STDFLG")
        Set objCUTargetFlg = objFields("CUTARGETFLG")
        Set objRslCmtCd1 = objFields("RSLCMTCD1")
        Set objRslCmtName1 = objFields("RSLCMTNAME1")
        Set objRslCmtCd2 = objFields("RSLCMTCD2")
        Set objRslCmtName2 = objFields("RSLCMTNAME1")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
        
            blnStdValueFlg = False
            '基準値が複数レコードあるか？
            If Not IsMissing(vntLowerValue) Or Not IsMissing(vntUpperValue) Then
                If lngCount > 0 Then
                    If vntArrRsvNo(lngCount - 1) = (objRsvNo.Value & "") And _
                       vntArrItemCd(lngCount - 1) = (objItemCd.Value & "") And _
                       vntArrSuffix(lngCount - 1) = (objSuffix.Value & "") Then
                       
                        blnStdValueFlg = True
                    End If
                End If
            End If
            If blnStdValueFlg Then
                '結果タイプが文章のとき特殊処理
                If vntArrResultType(lngCount - 1) = 4 Then
                    vntArrUpperValue(lngCount - 1) = vntArrUpperValue(lngCount - 1) & "," & objUpperValue.Value & ""
                Else
                    '前のレコードの基準値（最大値）のみを書き換える
                    vntArrUpperValue(lngCount - 1) = objUpperValue.Value & ""
                End If
            Else
                ReDim Preserve vntArrHisNo(lngCount)
                ReDim Preserve vntArrPerId(lngCount)
                ReDim Preserve vntArrCslDate(lngCount)
                ReDim Preserve vntArrRsvNo(lngCount)
                ReDim Preserve vntArrItemCd(lngCount)
                ReDim Preserve vntArrSuffix(lngCount)
                ReDim Preserve vntArrResultType(lngCount)
                ReDim Preserve vntArrItemType(lngCount)
                ReDim Preserve vntArrClassName(lngCount)
                ReDim Preserve vntArrItemName(lngCount)
                ReDim Preserve vntArrRslFlg(lngCount)
                ReDim Preserve vntArrResult(lngCount)
                ReDim Preserve vntArrRslValue(lngCount)
                ReDim Preserve vntArrUnit(lngCount)
                ReDim Preserve vntArrLowerValue(lngCount)
                ReDim Preserve vntArrUpperValue(lngCount)
                ReDim Preserve vntArrStdFlg(lngCount)
                ReDim Preserve vntArrCUTargetFlg(lngCount)
                ReDim Preserve vntArrRslCmtCd1(lngCount)
                ReDim Preserve vntArrRslCmtName1(lngCount)
                ReDim Preserve vntArrRslCmtCd2(lngCount)
                ReDim Preserve vntArrRslCmtName2(lngCount)
                vntArrHisNo(lngCount) = objHisNo.Value & ""
                vntArrPerId(lngCount) = objPerId.Value & ""
                vntArrCslDate(lngCount) = objCslDate.Value & ""
                vntArrRsvNo(lngCount) = objRsvNo.Value & ""
                vntArrItemCd(lngCount) = objItemCd.Value & ""
                vntArrSuffix(lngCount) = objSuffix.Value & ""
                vntArrResultType(lngCount) = objResultType.Value & ""
                vntArrItemType(lngCount) = objItemType.Value & ""
                vntArrClassName(lngCount) = objClassName.Value & ""
                vntArrItemName(lngCount) = objItemName.Value & ""
                vntArrRslFlg(lngCount) = objRslFlg.Value & ""
                vntArrResult(lngCount) = objResult.Value & ""
                vntArrRslValue(lngCount) = objRslValue.Value & ""
                vntArrUnit(lngCount) = objUnit.Value & ""
                vntArrLowerValue(lngCount) = objLowerValue.Value & ""
                vntArrUpperValue(lngCount) = objUpperValue.Value & ""
                vntArrStdFlg(lngCount) = objStdFlg.Value & ""
                vntArrCUTargetFlg(lngCount) = objCUTargetFlg.Value & ""
                vntArrRslCmtCd1(lngCount) = objRslCmtCd1.Value & ""
                vntArrRslCmtName1(lngCount) = objRslCmtName1.Value & ""
                vntArrRslCmtCd2(lngCount) = objRslCmtCd2.Value & ""
                vntArrRslCmtName2(lngCount) = objRslCmtName2.Value & ""
                lngCount = lngCount + 1
            End If
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    If Not IsMissing(vntHisNo) Then vntHisNo = vntArrHisNo
    If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
    If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
    If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
    If Not IsMissing(vntResultType) Then vntResultType = vntArrResultType
    If Not IsMissing(vntItemType) Then vntItemType = vntArrItemType
    If Not IsMissing(vntClassName) Then vntClassName = vntArrClassName
    If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
    If Not IsMissing(vntRslFlg) Then vntRslFlg = vntArrRslFlg
    If Not IsMissing(vntResult) Then vntResult = vntArrResult
    If Not IsMissing(vntRslValue) Then vntRslValue = vntArrRslValue
    If Not IsMissing(vntUnit) Then vntUnit = vntArrUnit
    If Not IsMissing(vntLowerValue) Then vntLowerValue = vntArrLowerValue
    If Not IsMissing(vntUpperValue) Then vntUpperValue = vntArrUpperValue
    If Not IsMissing(vntStdFlg) Then vntStdFlg = vntArrStdFlg
    If Not IsMissing(vntCUTargetFlg) Then vntCUTargetFlg = vntArrCUTargetFlg
    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = vntArrRslCmtCd1
    If Not IsMissing(vntRslCmtName1) Then vntRslCmtName1 = vntArrRslCmtName1
    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = vntArrRslCmtCd2
    If Not IsMissing(vntRslCmtName2) Then vntRslCmtName2 = vntArrRslCmtName2
    
    SelectHistoryRslList_Item = lngCount
        
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Interview.SelectHistoryRslList_Item"
    
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
' 機能　　 : 指定対象受診者の判定結果を取得する
'
' 引数　　 : (In)     lngRsvNo     　予約番号
' 　　　　   (In)     dtmCslDate   　受診日
' 　　　　   (In)     strHisCount  　表示歴数
' 　　　　   (In)     lngLastDspMode 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
' 　　　　   (In)     vntCsGrp       前回歴表示モード＝0のとき、null
' 　　　　                                          ＝1のとき、コースコード
' 　　　　                                          ＝2のとき、コースグループコード
' 　　　　   (In)     lngGetSeqMode  取得順 0:表示順＋日付　1:日付＋表示順
' 　　　　   (In)     vntPerId     　個人ＩＤ
' 　　　　   (In)     vntCslDate   　受診日
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntSeq         表示位置
' 　　　　   (Out)    vntJudClassCd  判定分類コード
' 　　　　   (Out)    vntJudClassName判定分類名称
' 　　　　   (Out)    vntJudCd       判定コード
' 　　　　   (Out)    vntJudSName    判定略称
' 　　　　   (Out)    vntWeight      判定の重み
' 　　　　   (Out)    vntUpdUser     更新者
' 　　　　   (Out)    vntJudCmtCd    判定コメントコード
' 　　　　   (Out)    vntJudCmtstc   判定コメント文章
' 　　　　   (Out)    vntGuidanceCd  指導内容コード　＝＝＞不要項目削除(2003.12.03)
' 　　　　   (Out)    vntGuidanceStc 指導内容　　　　＝＝＞不要項目削除(2003.12.03)
' 　　　　   (Out)    vntResultDispMode 検査結果表示モード
' 　　　　   (Out)    vntUpdFlg      更新フラグ     2003.12.26 add
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectJudHistoryRslList( _
    ByVal lngRsvNo As Long, _
    ByVal strHisCount As String, _
    ByVal lngLastDspMode As Long, _
    ByVal vntCsGrp As Variant, _
    ByVal lngGetSeqMode As Long, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntSeq As Variant, _
    Optional ByRef vntJudClassCd As Variant, _
    Optional ByRef vntJudClassName As Variant, _
    Optional ByRef vntJudCd As Variant, _
    Optional ByRef vntJudSName As Variant, _
    Optional ByRef vntWeight As Variant, _
    Optional ByRef vntUpdUser As Variant, _
    Optional ByRef vntJudCmtCd As Variant, _
    Optional ByRef vntJudCmtStc As Variant, _
    Optional ByRef vntResultDispMode As Variant, _
    Optional ByRef vntUpdFlg As Variant _
) As Long

'''' 不要項目削除 (2003.12.03)
'Public Function SelectJudHistoryRslList( _
'    ByVal lngRsvNo As Long, _
'    ByVal strHisCount As String, _
'    ByVal lngLastDspMode As Long, _
'    ByVal vntCsGrp As Variant, _
'    ByVal lngGetSeqMode As Long, _
'    Optional ByRef vntPerId As Variant, _
'    Optional ByRef vntCslDate As Variant, _
'    Optional ByRef vntRsvNo As Variant, _
'    Optional ByRef vntSeq As Variant, _
'    Optional ByRef vntJudClassCd As Variant, _
'    Optional ByRef vntJudClassName As Variant, _
'    Optional ByRef vntJudCd As Variant, _
'    Optional ByRef vntJudSName As Variant, _
'    Optional ByRef vntWeight As Variant, _
'    Optional ByRef vntUpdUser As Variant, _
'    Optional ByRef vntJudCmtCd As Variant, _
'    Optional ByRef vntJudCmtstc As Variant, _
'    Optional ByRef vntGuidanceCd As Variant, _
'    Optional ByRef vntGuidanceStc As Variant, _
'    Optional ByRef vntResultDispMode As Variant _
') As Long
'
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objCslDate          As OraField         '受診日
    Dim objRsvNo            As OraField         '予約番号
    Dim objSeq              As OraField         '表示位置
    Dim objJudClassCd       As OraField         '判定分類コード
    Dim objJudClassName     As OraField         '判定分類名称
    Dim objJudCd            As OraField         '判定コード
    Dim objJudSName         As OraField         '判定略称
    Dim objWeight           As OraField         '判定の重み
    Dim objUpdUser          As OraField         '更新者
    Dim objJudCmtCd         As OraField         '判定コメントコード
    Dim objJudCmtstc        As OraField         '判定コメント文章
' ## 不要項目削除 2003.12.03 start
'    Dim objGuidanceCd       As OraField         '指導内容コード
'    Dim objGuidanceStc      As OraField         '指導内容
' ## 不要項目削除 2003.12.03 end
    Dim objResultDispMode   As OraField         '検査結果表示モード
    Dim objUpdFlg           As OraField         '更新フラグ
    
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrSeq()         As Variant          '表示位置の配列
    Dim vntArrJudClassCd()  As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()  As Variant        '判定分類名称の配列
    Dim vntArrJudCd()       As Variant          '判定コードの配列
    Dim vntArrJudSName()    As Variant          '判定略称の配列
    Dim vntArrWeight()      As Variant          '判定重みの配列
    Dim vntArrUpdUser()     As Variant          '更新者の配列
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコードの配列
    Dim vntArrJudCmtstc()   As Variant          '判定コメント文章の配列
' ## 不要項目削除 2003.12.03 start
'    Dim vntArrGuidanceCd()  As Variant          '指導内容コードの配列
'    Dim vntArrGuidanceStc() As Variant          '指導内容の配列
' ## 不要項目削除 2003.12.03 end
    Dim vntArrResultDispMode() As Variant       '検査結果表示モードの配列
    Dim vntArrUpdFlg()         As Variant       '更新フラグの配列
    
    Dim lngCount            As Long             'レコード数
    Dim lngHisCnt           As Long             '履歴番号
    Dim lngHistoryCount     As Long             '表示歴数
    
    Dim i                   As Long             'ループカウンタ
    
    Dim lngBakJudClassCd    As Long             '判定分類コード（退避用）
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = Empty
    If Not IsMissing(vntJudClassName) Then vntJudClassName = Empty
    If Not IsMissing(vntJudCd) Then vntJudCd = Empty
    If Not IsMissing(vntJudSName) Then vntJudSName = Empty
    If Not IsMissing(vntWeight) Then vntWeight = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntJudCmtCd) Then vntPerId = Empty
    If Not IsMissing(vntJudCmtStc) Then vntJudCmtStc = Empty
' ## 不要項目削除 2003.12.03 start
'    If Not IsMissing(vntGuidanceCd) Then vntGuidanceCd = Empty
'    If Not IsMissing(vntGuidanceStc) Then vntGuidanceStc = Empty
' ## 不要項目削除 2003.12.03 end
    If Not IsMissing(vntResultDispMode) Then vntResultDispMode = Empty
    If Not IsMissing(vntUpdFlg) Then vntUpdFlg = Empty
    
    '表示歴数が「全件」以外で、数値でない場合はエラー
    If strHisCount <> "*" Then
        If Not IsNumeric(strHisCount) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        lngHistoryCount = CLng(strHisCount)
    Else
        lngHistoryCount = 0
    End If


    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngHistoryCount > 0 Then
        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '乳房特殊処理用判定分類コード 2004.01.07 add
    objOraParam.Add "NYUJUDCLASSCD", NYUBOU_JUDCLASSCD, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SYOKUJUDCLASSCD", NYUSYOKU_JUDCLASSCD, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "XSENJUDCLASSCD", NYUXSEN_JUDCLASSCD, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CHOUJUDCLASSCD", NYUCHOU_JUDCLASSCD, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = "SELECT FINALRSL.PERID, FINALRSL.CSLDATE,                     " & vbLf & _
              "       FINALRSL.RSVNO, NVL( FINALRSL.SEQ, 1 ) SEQ,           " & vbLf & _
              "       JUDCLASS.JUDCLASSCD, JUDCLASS.JUDCLASSNAME,           " & vbLf & _
              "       JUDCLASS.RESULTDISPMODE,                              " & vbLf & _
              "       FINALRSL.JUDCD, JUD.JUDSNAME, JUD.WEIGHT,             " & vbLf & _
              "       FINALRSL.UPDUSER,   FINALRSL.UPDFLG,                  " & vbLf & _
              "       FINALRSL.JUDCMTCD, JUDCMTSTC.JUDCMTSTC                "
' ## 不要項目削除 2003.12.03 start
'              "       FINALRSL.GUIDANCECD, GUIDANCE.GUIDANCESTC             " & vbLf & _
'              "  FROM JUD, JUDCMTSTC,  GUIDANCE, JUDCLASS,                  " & vbLf & _
' ## 不要項目削除 2003.12.03 end
    strStmt = strStmt & vbLf & _
              "  FROM JUD, JUDCMTSTC,  JUDCLASS,                            " & vbLf & _
              "       ( SELECT JUDCLASSVIEW.CSLDATE, JUDCLASSVIEW.RSVNO,    " & vbLf & _
              "                JUDCLASSVIEW.PERID,   JUDCLASSVIEW.SEQ,      " & vbLf & _
              "                JUDCLASSVIEW.JUDCLASSCD,                     " & vbLf & _
              "                JUDRSL.JUDCD,                                " & vbLf & _
              "                JUDRSL.UPDUSER, JUDRSL.UPDFLG,               " & vbLf & _
              "                JUDRSL.JUDCMTCD                              "
' ## 不要項目削除 2003.12.03 start
'              "                JUDRSL.JUDCMTCD,   JUDRSL.GUIDANCECD         "
' ## 不要項目削除 2003.12.03 end
    
    '予約ごとに入力の必要な判定分類を取得
    strStmt = strStmt & vbLf & _
              "           FROM (SELECT FINALCONSULT.CSLDATE, FINALCONSULT.RSVNO,            " & vbLf & _
              "                        FINALCONSULT.PERID,   FINALCONSULT.SEQ,              " & vbLf & _
              "                        FINALCONSULT.CSCD,                                   " & vbLf & _
              "                        COURSE_JUD.JUDCLASSCD                                " & vbLf & _
              "                   FROM (SELECT CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,      " & vbLf & _
              "                                CONSULTVIEW.PERID,   CONSULTVIEW.SEQ,        " & vbLf & _
              "                                CONSULTVIEW.CSCD                             " & vbLf & _
              "                           FROM ( SELECT ROWNUM SEQ, CSLDATE, RSVNO,         " & vbLf & _
              "                                         PERID, CSCD                         " & vbLf & _
              "                                    FROM ( SELECT CONSULT.CSLDATE,           " & vbLf & _
              "                                                  CONSULT.RSVNO,             " & vbLf & _
              "                                                  CONSULT.PERID,             " & vbLf & _
              "                                                  CONSULT.CSCD               " & vbLf & _
              "                                             FROM CONSULT                    "
    strStmt = strStmt & vbLf & _
              "                                            WHERE CONSULT.PERID     =        " & vbLf & _
              "                                                  (SELECT DISTINCT PERID     " & vbLf & _
              "                                                     FROM CONSULT            " & vbLf & _
              "                                                    WHERE RSVNO = :RSVNO)    "
    'コース指定
    Select Case lngLastDspMode
    Case 1
        strStmt = strStmt & vbLf & _
              "                                              AND CONSULT.CSCD = :CSCD       "
    Case 2
        strStmt = strStmt & vbLf & _
              "                                              AND CONSULT.CSCD               " & vbLf & _
              "                                                  IN (SELECT FREEFIELD1 CSCD " & vbLf & _
              "                                                        FROM FREE            " & vbLf & _
              "                                                       WHERE FREECD LIKE :CSCD||'%') "
    End Select
'** #### 2011.11.17 SL-SN-Y0101-006 MOD START #### **
'    strStmt = strStmt & vbLf & _
'              "                                              AND CONSULT.CSLDATE  <=        " & vbLf & _
'              "                                                  (SELECT DISTINCT CSLDATE   " & vbLf & _
'              "                                                     FROM CONSULT            " & vbLf & _
'              "                                                    WHERE RSVNO = :RSVNO)    " & vbLf & _
'              "                                              AND CONSULT.CANCELFLG = 0      " & vbLf & _
'              "                                            ORDER BY CONSULT.CSLDATE DESC )  " & vbLf & _
'              "                                 ) CONSULTVIEW                               "
    strStmt = strStmt & vbLf & _
              "                                              AND CONSULT.CSLDATE  <=        " & vbLf & _
              "                                                  (SELECT DISTINCT CSLDATE   " & vbLf & _
              "                                                     FROM CONSULT            " & vbLf & _
              "                                                    WHERE RSVNO = :RSVNO)    " & vbLf & _
              "                                              AND CONSULT.CANCELFLG = 0      " & vbLf & _
              "                                            ORDER BY CONSULT.CSLDATE DESC, CONSULT.CSCD DESC )  " & vbLf & _
              "                                 ) CONSULTVIEW                               "
'** #### 2011.11.17 SL-SN-Y0101-006 MOD END #### **
    '履歴指定？
    If lngHistoryCount > 0 Then
        strStmt = strStmt & vbLf & _
              "                           WHERE CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT "
    End If
    
    '判定の必要な判定分類コードを検索
    '自動展開フラグが立っている、或いは判定分類内の検査項目が健診結果に存在するかを判定
    '### 中止フラグ(STOPFLG)がたっていないかも見る　2004.01.03
    strStmt = strStmt & vbLf & _
              "                         ) FINALCONSULT, COURSE_JUD                       " & vbLf & _
              "                   WHERE FINALCONSULT.CSCD    = COURSE_JUD.CSCD           " & vbLf & _
              "                     AND ( COURSE_JUD.NOREASON = 1                                       " & vbLf & _
              "                           OR                                                              " & vbLf & _
              "                           EXISTS ( SELECT RSL.RSVNO                                       " & vbLf & _
              "                                      FROM ITEM_JUD, RSL                                   " & vbLf & _
              "                                     WHERE RSL.RSVNO           = FINALCONSULT.RSVNO        " & vbLf & _
              "                                       AND RSL.ITEMCD          = ITEM_JUD.ITEMCD           " & vbLf & _
              "                                       AND RSL.STOPFLG IS NULL                             " & vbLf & _
              "                                       AND ITEM_JUD.JUDCLASSCD = COURSE_JUD.JUDCLASSCD )   "
'### Updated by Ishihara@FSIT 過去歴において判定が存在する場合、無条件に表示する。
'    '### 乳房特殊処理 2004.01.07 add start
'    '### 乳房は触診、Ｘ線、超音波のいずれかの依頼があれば対象となる
'    strStmt = strStmt & vbLf & _
'              "                           OR                                                              " & vbLf & _
'              "                           (EXISTS ( SELECT RSL.RSVNO                                      " & vbLf & _
'              "                                      FROM ITEM_JUD, RSL                                   " & vbLf & _
'              "                                     WHERE RSL.RSVNO           = FINALCONSULT.RSVNO        " & vbLf & _
'              "                                       AND RSL.ITEMCD          = ITEM_JUD.ITEMCD           " & vbLf & _
'              "                                       AND RSL.STOPFLG IS NULL                             " & vbLf & _
'              "                                       AND ITEM_JUD.JUDCLASSCD                             " & vbLf & _
'              "                                           IN (:SYOKUJUDCLASSCD, :XSENJUDCLASSCD, :CHOUJUDCLASSCD ) )  " & vbLf & _
'              "                             AND COURSE_JUD.JUDCLASSCD = :NYUJUDCLASSCD ))                 "
    
    strStmt = strStmt & vbLf & _
              "                           OR                                                              " & vbLf & _
              "                           (EXISTS ( SELECT RSL.RSVNO                                      " & vbLf & _
              "                                      FROM ITEM_JUD, RSL                                   " & vbLf & _
              "                                     WHERE RSL.RSVNO           = FINALCONSULT.RSVNO        " & vbLf & _
              "                                       AND RSL.ITEMCD          = ITEM_JUD.ITEMCD           " & vbLf & _
              "                                       AND RSL.STOPFLG IS NULL                             " & vbLf & _
              "                                       AND ITEM_JUD.JUDCLASSCD                             " & vbLf & _
              "                                           IN (:SYOKUJUDCLASSCD, :XSENJUDCLASSCD, :CHOUJUDCLASSCD ) )  " & vbLf & _
              "                             AND COURSE_JUD.JUDCLASSCD = :NYUJUDCLASSCD )                  " & vbLf & _
              "                           OR                                                              " & vbLf & _
              "                           (EXISTS ( SELECT JUDRSL.JUDCLASSCD                              " & vbLf & _
              "                                       FROM JUDRSL                                         " & vbLf & _
              "                                      WHERE JUDRSL.RSVNO = FINALCONSULT.RSVNO              " & vbLf & _
              "                                        AND JUDRSL.JUDCLASSCD = COURSE_JUD.JUDCLASSCD      " & vbLf & _
              "                                        AND JUDRSL.JUDCD IS NOT NULL )))                   "
'### Updated End
    
    '### 乳房特殊処理 2004.01.07 add end
    '判定結果が入力されていなくても取得
    strStmt = strStmt & vbLf & _
              "                ) JUDCLASSVIEW, JUDRSL                           " & vbLf & _
              "          WHERE JUDCLASSVIEW.RSVNO      = JUDRSL.RSVNO(+)        " & vbLf & _
              "            AND  JUDCLASSVIEW.JUDCLASSCD = JUDRSL.JUDCLASSCD(+)  "
    
    
    strStmt = strStmt & vbLf & _
              "       ) FINALRSL                                         " & vbLf & _
              " WHERE FINALRSL.JUDCD         = JUD.JUDCD(+)              " & vbLf & _
              "   AND FINALRSL.JUDCLASSCD(+) = JUDCLASS.JUDCLASSCD       " & vbLf & _
              "   AND JUDCLASS.COMMENTONLY  IS NULL                      " & vbLf & _
              "   AND FINALRSL.JUDCMTCD      = JUDCMTSTC.JUDCMTCD(+)     "
' ## 不要項目削除 2003.12.03 start
'              "   AND FINALRSL.GUIDANCECD    = GUIDANCE.GUIDANCECD(+)    "
' ## 不要項目削除 2003.12.03 end
    If lngGetSeqMode = 0 Then
        strStmt = strStmt & vbLf & _
              " ORDER BY FINALRSL.CSLDATE DESC,        " & vbLf & _
              "          JUDCLASS.VIEWORDER            "
    Else
        strStmt = strStmt & vbLf & _
              " ORDER BY JUDCLASS.VIEWORDER ,          " & vbLf & _
              "          FINALRSL.CSLDATE DESC         "
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objSeq = objFields("SEQ")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objJudCd = objFields("JUDCD")
        Set objJudSName = objFields("JUDSNAME")
        Set objWeight = objFields("WEIGHT")
        Set objUpdUser = objFields("UPDUSER")
        Set objJudCmtCd = objFields("JUDCMTCD")
        Set objJudCmtstc = objFields("JUDCMTSTC")
' ## 不要項目削除 2003.12.03 start
'        Set objGuidanceCd = objFields("GUIDANCECD")
'        Set objGuidanceStc = objFields("GUIDANCESTC")
' ## 不要項目削除 2003.12.03 end
        Set objResultDispMode = objFields("RESULTDISPMODE")
        Set objUpdFlg = objFields("UPDFLG")
        
        '配列形式で格納する
        lngCount = 0
        lngBakJudClassCd = 0
        Do Until objOraDyna.EOF
        
            lngBakJudClassCd = objJudClassCd.Value
            
            
            '該当履歴番号が無ければ空データを作る
            For lngHisCnt = 1 To lngHistoryCount
                    
                If objOraDyna.EOF = True Then Exit For
                
                ReDim Preserve vntArrRsvNo(lngCount)
                ReDim Preserve vntArrSeq(lngCount)
                ReDim Preserve vntArrJudClassCd(lngCount)
                ReDim Preserve vntArrJudClassName(lngCount)
                ReDim Preserve vntArrJudCd(lngCount)
                ReDim Preserve vntArrJudSName(lngCount)
                ReDim Preserve vntArrWeight(lngCount)
                ReDim Preserve vntArrUpdUser(lngCount)
                ReDim Preserve vntArrJudCmtCd(lngCount)
                ReDim Preserve vntArrJudCmtstc(lngCount)
' ## 不要項目削除 2003.12.03 start
'                ReDim Preserve vntArrGuidanceCd(lngCount)
'                ReDim Preserve vntArrGuidanceStc(lngCount)
' ## 不要項目削除 2003.12.03 end
                ReDim Preserve vntArrResultDispMode(lngCount)
                ReDim Preserve vntArrUpdFlg(lngCount)
                
                '前の分類コードとちがう
                If lngBakJudClassCd <> objJudClassCd.Value Then
                    vntArrRsvNo(lngCount) = ""
                    vntArrSeq(lngCount) = lngHisCnt
                    If lngHisCnt = 1 Then
                        vntArrJudClassCd(lngCount) = objJudClassCd.Value
                        vntArrJudClassName(lngCount) = objJudClassName.Value
                        vntArrResultDispMode(lngCount) = objResultDispMode.Value & ""
                    Else
                        vntArrJudClassCd(lngCount) = vntArrJudClassCd(lngCount - 1)
                        vntArrJudClassName(lngCount) = vntArrJudClassName(lngCount - 1)
                        vntArrResultDispMode(lngCount) = vntArrResultDispMode(lngCount - 1)
                    End If
                    vntArrJudCd(lngCount) = ""
                    vntArrJudSName(lngCount) = ""
                    vntArrWeight(lngCount) = ""
                    vntArrUpdUser(lngCount) = ""
                    vntArrUpdFlg(lngCount) = ""
                    vntArrJudCmtCd(lngCount) = ""
                    vntArrJudCmtstc(lngCount) = ""
' ## 不要項目削除 2003.12.03 start
'                    vntArrGuidanceCd(lngCount) = ""
'                    vntArrGuidanceStc(lngCount) = ""
' ## 不要項目削除 2003.12.03 end
                    lngCount = lngCount + 1
                Else
                    If CLng(objSeq.Value) <> lngHisCnt Then
                        vntArrRsvNo(lngCount) = ""
                        vntArrSeq(lngCount) = lngHisCnt
                        If lngHisCnt = 1 Then
                            vntArrJudClassCd(lngCount) = objJudClassCd.Value
                            vntArrJudClassName(lngCount) = objJudClassName.Value
                            vntArrResultDispMode(lngCount) = objResultDispMode.Value & ""
                        Else
                            vntArrJudClassCd(lngCount) = vntArrJudClassCd(lngCount - 1)
                            vntArrJudClassName(lngCount) = vntArrJudClassName(lngCount - 1)
                            vntArrResultDispMode(lngCount) = vntArrResultDispMode(lngCount - 1)
                        End If
                        vntArrJudCd(lngCount) = ""
                        vntArrJudSName(lngCount) = ""
                        vntArrWeight(lngCount) = ""
                        vntArrUpdUser(lngCount) = ""
                        vntArrUpdFlg(lngCount) = ""
                        vntArrJudCmtCd(lngCount) = ""
                        vntArrJudCmtstc(lngCount) = ""
' ## 不要項目削除 2003.12.03 start
'                        vntArrGuidanceCd(lngCount) = ""
'                        vntArrGuidanceStc(lngCount) = ""
' ## 不要項目削除 2003.12.03 end
                    Else
                        vntArrRsvNo(lngCount) = objRsvNo.Value & ""
                        vntArrSeq(lngCount) = objSeq.Value
                        vntArrJudClassCd(lngCount) = objJudClassCd.Value
                        vntArrJudClassName(lngCount) = objJudClassName.Value
                        vntArrJudCd(lngCount) = objJudCd.Value & ""
                        vntArrJudSName(lngCount) = objJudSName.Value & ""
                        vntArrWeight(lngCount) = objWeight.Value & ""
                        vntArrUpdUser(lngCount) = objUpdUser.Value & ""
                        vntArrUpdFlg(lngCount) = objUpdFlg.Value & ""
                        vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
                        vntArrJudCmtstc(lngCount) = objJudCmtstc.Value & ""
' ## 不要項目削除 2003.12.03 start
'                        vntArrGuidanceCd(lngCount) = objGuidanceCd.Value & ""
'                        vntArrGuidanceStc(lngCount) = objGuidanceStc.Value & ""
' ## 不要項目削除 2003.12.03 end
                        vntArrResultDispMode(lngCount) = objResultDispMode.Value & ""
                        objOraDyna.MoveNext
                    End If
                    lngCount = lngCount + 1
                End If
            Next lngHisCnt
        Loop
        
    End If
    
    If lngHisCnt < lngHistoryCount Then
        For i = lngHisCnt To lngHistoryCount
                
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrJudSName(lngCount)
            ReDim Preserve vntArrWeight(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            ReDim Preserve vntArrJudCmtstc(lngCount)
' ## 不要項目削除 2003.12.03 start
'            ReDim Preserve vntArrGuidanceCd(lngCount)
'            ReDim Preserve vntArrGuidanceStc(lngCount)
' ## 不要項目削除 2003.12.03 end
            ReDim Preserve vntArrResultDispMode(lngCount)
            ReDim Preserve vntArrUpdFlg(lngCount)
                
            vntArrRsvNo(lngCount) = ""
            vntArrSeq(lngCount) = lngHisCnt
            vntArrJudClassCd(lngCount) = vntArrJudClassCd(lngCount - 1)
            vntArrJudClassName(lngCount) = vntArrJudClassName(lngCount - 1)
            vntArrJudCd(lngCount) = ""
            vntArrJudSName(lngCount) = ""
            vntArrWeight(lngCount) = ""
            vntArrUpdUser(lngCount) = ""
            vntArrUpdFlg(lngCount) = ""
            vntArrJudCmtCd(lngCount) = ""
            vntArrJudCmtstc(lngCount) = ""
' ## 不要項目削除 2003.12.03 end
'            vntArrGuidanceCd(lngCount) = ""
'            vntArrGuidanceStc(lngCount) = ""
' ## 不要項目削除 2003.12.03 start
            vntArrResultDispMode(lngCount) = vntArrResultDispMode(lngCount - 1)
            
            lngCount = lngCount + 1
        Next i
    End If
    
    '戻り値の設定
    vntRsvNo = vntArrRsvNo
    vntSeq = vntArrSeq
    vntJudClassCd = vntArrJudClassCd
    vntJudClassName = vntArrJudClassName
    vntJudCd = vntArrJudCd
    vntJudSName = vntArrJudSName
    vntWeight = vntArrWeight
    vntUpdUser = vntArrUpdUser
    vntJudCmtCd = vntArrJudCmtCd
    vntJudCmtStc = vntArrJudCmtstc
' ## 不要項目削除 2003.12.03 start
'    vntGuidanceCd = vntArrGuidanceCd
'    vntGuidanceStc = vntArrGuidanceStc
' ## 不要項目削除 2003.12.03 end
    vntResultDispMode = vntArrResultDispMode
    vntUpdFlg = vntArrUpdFlg
    
    SelectJudHistoryRslList = lngCount
        
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み  ## クラス名修正　2004.01.13
    WriteErrorLog "Interview.SelectJudHistoryRslList"
    
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
' 機能　　 : 指定された予約番号の総合コメントを取得する
'
' 引数　　 : (In)     lngRsvNo       予約番号
' 　　　　   (In)     lngDispMode    表示分類（1:総合コメント、2:生活指導コメント、3:食習慣コメント、4:献立コメント）
' 　　　　   (In)     strHisCount    表示歴数
' 　　　　   (In)     lngLastDspMode 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
' 　　　　   (In)     vntCsGrp       前回歴表示モード＝0のとき、null
' 　　　　                                          ＝1のとき、コースコード
' 　　　　                                          ＝2のとき、コースグループコード
' 　　　　   (In)     lngSelectMode  データ取得モード（0:今回分含む、1:前回分以前）
' 　　　　   (Out)    vntSeq         表示順
' 　　　　   (Out)    vntJudCmtCd    判定コメントコード
' 　　　　   (Out)    vntJudCmtstc   判定コメント文章
' 　　　　   (Out)    vntJudClassCd  判定分類コード
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntCslDate     受診日
' 　　　　   (Out)    vntCsCd        コースコード
' 　　　　   (Out)    vntCsName      コース名
' 　　　　   (Out)    vntJudCd       判定コード
' 　　　　   (Out)    vntWeight      判定重み
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectTotalJudCmt( _
    ByVal lngRsvNo As Long, _
    ByVal lngDispMode As Long, _
    ByVal strHisCount As String, _
    Optional ByVal lngLastDspMode As Long = 0, _
    Optional ByVal vntCsGrp As Variant, _
    Optional ByVal lngSelectMode As Long = 0, _
    Optional ByRef vntSeq As Variant, _
    Optional ByRef vntJudCmtCd As Variant, _
    Optional ByRef vntJudCmtStc As Variant, _
    Optional ByRef vntJudClassCd As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntJudCd As Variant, _
    Optional ByRef vntWeight As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSeq              As OraField         '表示順
    Dim objJudCmtCd         As OraField         '判定コメントコード
    Dim objJudCmtstc        As OraField         '判定コメント文章
    Dim objJudClassCd       As OraField         '判定分類コード
    Dim objRsvNo            As OraField         '予約番号
    Dim objCslDate          As OraField         '受診日
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objJudCd            As OraField         '判定コード
    Dim objWeight           As OraField         '判定重み

    Dim vntArrSeq()         As Variant          '表示順の配列
    Dim vntArrJudCmtCd()    As Variant          '判定コメントコードの配列
    Dim vntArrJudCmtstc()   As Variant          '判定コメント文章の配列
    Dim vntArrJudClassCd()  As Variant          '判定分類コードの配列
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrCsCd()        As Variant          'コースコードの配列
    Dim vntArrCsName()      As Variant          'コース名の配列
    Dim vntArrJudCd()       As Variant          '判定コードの配列
    Dim vntArrWeight()      As Variant          '判定重みの配列

    Dim lngCount            As Long             'レコード数
    Dim lngHistoryCount     As Long             '表示歴数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntJudCmtCd) Then vntJudCmtCd = Empty
    If Not IsMissing(vntJudCmtStc) Then vntJudCmtStc = Empty
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntJudCd) Then vntJudCd = Empty
    If Not IsMissing(vntWeight) Then vntWeight = Empty
    lngCount = 0

    '表示歴数が「全件」以外で、数値でない場合はエラー
    If strHisCount <> "*" Then
        If Not IsNumeric(strHisCount) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        lngHistoryCount = CLng(strHisCount)
    Else
        lngHistoryCount = 0
    End If
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISPMODE", lngDispMode, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngHistoryCount > 0 Then
        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
    End If

    '指定された予約番号の総合コメントを指定表示暦数分取得する
    strStmt = "SELECT CONSULTVIEW.RSVNO, CONSULTVIEW.CSLDATE,      " & vbLf & _
              "       CONSULTVIEW.CSCD,  COURSE_P.CSNAME,          " & vbLf & _
              "       TOTALJUDCMT.SEQ,                             " & vbLf & _
              "       TOTALJUDCMT.JUDCMTCD,                        " & vbLf & _
              "       JUDCMTSTC.JUDCMTSTC,   JUDCMTSTC.JUDCLASSCD, " & vbLf & _
              "       JUDCMTSTC.JUDCD,       JUD.WEIGHT            " & vbLf & _
              "  FROM TOTALJUDCMT, JUDCMTSTC, COURSE_P, JUD,       " & vbLf & _
              "       ( SELECT ROWNUM SEQ, CSLDATE, RSVNO,         " & vbLf & _
              "                PERID, CSCD                         " & vbLf & _
              "           FROM ( SELECT CONSULT.CSLDATE,           " & vbLf & _
              "                         CONSULT.RSVNO,             " & vbLf & _
              "                         CONSULT.PERID,             " & vbLf & _
              "                         CONSULT.CSCD               " & vbLf & _
              "                    FROM CONSULT                    "
    
    strStmt = strStmt & vbLf & _
              "                   WHERE CONSULT.PERID     =        " & vbLf & _
              "                         (SELECT DISTINCT PERID     " & vbLf & _
              "                            FROM CONSULT            " & vbLf & _
              "                           WHERE RSVNO = :RSVNO)    "
    
    strStmt = strStmt & vbLf & _
              "                     AND CONSULT.CSLDATE            "
    
    '今回分含む？
    If lngSelectMode = 0 Then
        strStmt = strStmt & " <= "
    Else
        strStmt = strStmt & " <  "
    End If
    
    strStmt = strStmt & _
              "                         (SELECT DISTINCT CSLDATE   " & vbLf & _
              "                            FROM CONSULT            " & vbLf & _
              "                           WHERE RSVNO = :RSVNO)    "
    
    
    'コース指定
    Select Case lngLastDspMode
        Case 1
            objOraParam.Add "CSCD", Trim(vntCsGrp), ORAPARM_INPUT, ORATYPE_NUMBER
            strStmt = strStmt & vbLf & _
                  "                 AND CONSULT.CSCD = :CSCD       "
        Case 2
            objOraParam.Add "CSCD", Trim(vntCsGrp), ORAPARM_INPUT, ORATYPE_NUMBER
            strStmt = strStmt & vbLf & _
                  "                 AND CONSULT.CSCD               " & vbLf & _
                  "                     IN (SELECT FREEFIELD1 CSCD " & vbLf & _
                  "                           FROM FREE            " & vbLf & _
                  "                          WHERE FREECD LIKE :CSCD||'%') "
    End Select

    strStmt = strStmt & vbLf & _
              "                     AND CONSULT.CANCELFLG = 0      " & vbLf & _
              "                   ORDER BY CONSULT.CSLDATE DESC )  " & vbLf & _
              "        ) CONSULTVIEW                               " & vbLf & _
              " WHERE CONSULTVIEW.RSVNO    = TOTALJUDCMT.RSVNO     " & vbLf & _
              "   AND TOTALJUDCMT.DISPMODE = :DISPMODE             "

    If lngHistoryCount > 0 Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT      "
    End If
        
    strStmt = strStmt & vbLf & _
              "   AND TOTALJUDCMT.JUDCMTCD = JUDCMTSTC.JUDCMTCD    " & vbLf & _
              "   AND JUD.JUDCD(+)         = JUDCMTSTC.JUDCD       " & vbLf & _
              "   AND CONSULTVIEW.CSCD(+)  = COURSE_P.CSCD         " & vbLf & _
              " ORDER BY CONSULTVIEW.CSLDATE,                      " & vbLf & _
              "          CONSULTVIEW.RSVNO,   TOTALJUDCMT.SEQ      "
              

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objSeq = objFields("SEQ")
        Set objJudCmtCd = objFields("JUDCMTCD")
        Set objJudCmtstc = objFields("JUDCMTSTC")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudCd = objFields("JUDCD")
        Set objWeight = objFields("WEIGHT")

        'レコードの検索
        Do Until objOraDyna.EOF

            '配列形式で格納する
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            ReDim Preserve vntArrJudCmtstc(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrWeight(lngCount)
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            vntArrJudCmtstc(lngCount) = objJudCmtstc.Value & ""
            vntArrJudClassCd(lngCount) = objJudClassCd.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrJudCd(lngCount) = objJudCd.Value & ""
            vntArrWeight(lngCount) = objWeight.Value & ""
            lngCount = lngCount + 1

            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntSeq) Then vntSeq = vntArrSeq
        If Not IsMissing(vntJudCmtCd) Then vntJudCmtCd = vntArrJudCmtCd
        If Not IsMissing(vntJudCmtStc) Then vntJudCmtStc = vntArrJudCmtstc
        If Not IsMissing(vntJudClassCd) Then vntJudClassCd = vntArrJudClassCd
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntJudCd) Then vntJudCd = vntArrJudCd
        If Not IsMissing(vntWeight) Then vntWeight = vntArrWeight
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectTotalJudCmt = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectTotalJudCmt = -1

    'イベントログ書き込み
    WriteErrorLog "Interview.SelectTotalJudCmt"
    
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
' 機能　　 : 指定された予約番号の総合コメントを更新する
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (In)     lngDispMode         表示分類
' 　　　　   (In)     vntSeq              表示順
' 　　　　   (In)     vntJudCmtCd         判定コメントコード
'### 2004.01.07 add start
' 　　　　   (In)     vntJudCmtCdStc      判定コメント
' 　　　　   (In)     vntUpdUser          更新者
'
' 戻り値　 : True    正常終了
' 　　　　   False   異常終了
'
' 備考　　 :
'
Public Function UpdateTotalJudCmt( _
    ByVal lngRsvNo As Long, _
    ByVal lngDispMode As Long, _
    Optional ByVal vntSeq As Variant, _
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
    Dim objSeq              As OraParamArray    '表示順
    Dim objJudCmtCd         As OraParamArray    '判定コメントコード
    
    '変更履歴書き込み用　2004.01.07 start
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim vntBakSeq         As Variant          '表示順の配列
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
    '変更履歴書き込み用　2004.01.07 end
    
    '###　2004.02.13 Add start バグ修正　by Fujii
    Dim lngUpdFlg                     As Long     '更新有無フラグ
    '###　2004.02.13 Add end バグ修正　by Fujii
    
    Dim i                   As Long             'ループカウンタ
    Dim j                   As Long             'ループカウンタ
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

'MsgBox "UpdateTotalJudCmt:配列数=" & UBound(vntSeq)
    '配列数
    lngArraySize = UBound(vntSeq) + 1
    
    
    '## 変更履歴更新用 2004.01.07 add start
    ' 現状を退避
    lngBakCnt = SelectTotalJudCmt(lngRsvNo, lngDispMode, _
                                  1, 0, , 0, _
                                  vntBakSeq, _
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
    
'MsgBox "UpdateTotalJudCmt:lngBakCnt=" & lngBakCnt
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
            If Not IsNumeric(vntSeq(i)) Then
                lngChkFlg = 1
                Exit For
            End If
            'コメントコードブランクは無視
            If CLng(vntSeq(i)) <= 0 Or vntJudCmtCd(i) = "" Then
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
            Case Else
                vntArrLogJudClassCd(lngLogCnt) = ""
            End Select
            vntArrLogBeforeResult(lngLogCnt) = ""
            vntArrLogAfterResult(lngLogCnt) = vntJudCmtStc(i)
            lngLogCnt = lngLogCnt + 1
        End If
    Next i
    
'MsgBox "UpdateTotalJudCmt:lngLogCnt=" & lngLogCnt
    '変更履歴登録あり
    If lngLogCnt > 0 Then
        UpdateLogTotalJudCmt _
                        vntUpdUser, _
                        vntArrLogUpdClass, _
                        vntArrLogUpdDiv, _
                        vntArrLogRsvNo, _
                        vntArrLogRsvDate, _
                        vntArrLogJudClassCd, _
                        vntArrLogBeforeResult, _
                        vntArrLogAfterResult
    End If
    '## 変更履歴更新用 2004.01.07 add start
    
    

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
        Set objSeq = objOraParam("SEQ")
        Set objJudCmtCd = objOraParam("JUDCMTCD")
        
'###　2004.02.13 Add start バグ修正　by Fujii
        lngUpdFlg = 0
'###　2004.02.13 Add end バグ修正　by Fujii
        
        'OraParameterオブジェクトの値設定
        For i = 0 To lngArraySize - 1
'###　2004.02.13 Mod start バグ修正　by Fujii
'            objRsvNo(i) = lngRsvNo
'            objDispMode(i) = lngDispMode
'            objSeq(i) = vntSeq(i)
'            objJudCmtCd(i) = vntJudCmtCd(i)
            '表示順が数字
            If IsNumeric(vntSeq(i)) Then
                If CLng(vntSeq(i)) > 0 And vntJudCmtCd(i) <> "" Then
                    objRsvNo(i) = lngRsvNo
                    objDispMode(i) = lngDispMode
                    objSeq(i) = vntSeq(i)
                    objJudCmtCd(i) = vntJudCmtCd(i)
                    lngUpdFlg = 1
                End If
            End If
'###　2004.02.13 Mod end バグ修正　by Fujii
        Next i
        
        '検査結果更新
'###　2004.02.13 Mod start バグ修正　by Fujii
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
'###　2004.02.13 Mod end バグ修正　by Fujii
    
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop

'#### 2010.07.23 SL-UI-Y0101-101 ADD START ####　総合コメント並び替え関数追加'
        If Not fncSortTotalJudCmt(lngRsvNo, lngDispMode) Then
            Err.Raise 5
            Exit Function
        End If
        
'#### 2010.07.23 SL-UI-Y0101-101 ADD END ####　'

    End If
    
    '戻り値の設定
    UpdateTotalJudCmt = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    UpdateTotalJudCmt = False

    'イベントログ書き込み
    WriteErrorLog "Interview.UpdateTotalJudCmt"
    
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
'### 2004.01.07 add
'
' 機能　　 : 総合コメント更新履歴をセットする
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
Public Function UpdateLogTotalJudCmt( _
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
'MsgBox vntUpdClass(i) & " " & vntUpdDiv(i) & " " & vntRsvNo(i) & " " & _
       vntRsvDate(i) & " " & vntJudClassCd(i) & " " & vntBeforeResult(i) & " " & vntAfterResult(i)
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
'            If vntJudClassCd(i) <> "" Then
                strStmt = strStmt & vbLf & _
                      "  , JUDCLASSCD         "
'            End If
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
    UpdateLogTotalJudCmt = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    UpdateLogTotalJudCmt = False

    'イベントログ書き込み
    WriteErrorLog "Interview.UpdateLogTotalJudCmt"
    
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
' 機能　　 : 指定された予約番号と同一のコースを含むコースグループを取得する
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (Out)    vntCsGrpCd          コースグループコード
' 　　　　   (Out)    vntCsGrpName        コースグループ名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCsGrp( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntCsGrpCd As Variant, _
    Optional ByRef vntCsGrpName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCsGrpCd          As OraField         'コースグループコード
    Dim objCsGrpName        As OraField         'コースグループ名

    Dim vntArrCsGrpCd()     As Variant          'コースグループコードの配列
    Dim vntArrCsGrpName()   As Variant          'コースグループ名の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntCsGrpCd) Then vntCsGrpCd = Empty
    If Not IsMissing(vntCsGrpName) Then vntCsGrpName = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定された予約番号と同一のコースを含むコースグループを取得する
    strStmt = "SELECT CSPVIEW.CSGRPCD, CSPVIEW.CSGRPNAME                                " & vbLf & _
              "  FROM FREE,                                                             " & vbLf & _
              "       (SELECT FREEFIELD1 CSGRPNAME, FREEFIELD2 CSGRPCD                  " & vbLf & _
              "          FROM FREE                                                      " & vbLf & _
              "         WHERE FREECD LIKE 'CSP%' ) CSPVIEW                              " & vbLf & _
              " WHERE FREE.FREECD LIKE CSPVIEW.CSGRPCD||'%'                             " & vbLf & _
              "   AND FREE.FREEFIELD1 = (SELECT CSCD FROM CONSULT WHERE RSVNO = :RSVNO) "
              

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsGrpCd = objFields("CSGRPCD")
        Set objCsGrpName = objFields("CSGRPNAME")

        'レコードの検索
        Do Until objOraDyna.EOF

            '配列形式で格納する
            ReDim Preserve vntArrCsGrpCd(lngCount)
            ReDim Preserve vntArrCsGrpName(lngCount)
            vntArrCsGrpCd(lngCount) = objCsGrpCd.Value & ""
            vntArrCsGrpName(lngCount) = objCsGrpName.Value & ""
            lngCount = lngCount + 1

            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntCsGrpCd) Then vntCsGrpCd = vntArrCsGrpCd
        If Not IsMissing(vntCsGrpName) Then vntCsGrpName = vntArrCsGrpName
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectCsGrp = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectCsGrp = -1

    'イベントログ書き込み
    WriteErrorLog "Interview.SelectCsGrp"
    
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
' 　　　　   (In)     lngRsvNo              予約番号       '2004.01.07 追加
' 　　　　   (Out)    vntUpdDate            更新日時
' 　　　　   (Out)    vntUpdUser            更新者
' 　　　　   (Out)    vntUpdUserName        更新者氏名
' 　　　　   (Out)    vntUpdClass           更新分類
' 　　　　   (Out)    vntUpdDiv             処理区分
' 　　　　   (Out)    vntRsvNo              予約番号
' 　　　　   (Out)    vntRsvDate            予約日
' 　　　　   (Out)    vntItemCd             更新項目コード
' 　　　　   (Out)    vntSuffix             サフィックス
' 　　　　   (Out)    vntItemName           更新項目名称
' 　　　　   (Out)    vntJudClassCd         判定分類コード
' 　　　　   (Out)    vntJudClassName       判定分類名称
' 　　　　   (Out)    vntBeforeResult       更新前値
' 　　　　   (Out)    vntAfterResult        更新後値
'
' 戻り値　 : 検索条件を満たすレコード件数（取得開始位置当に関わらず全件数）
'            COnsult SelectDailyList を参考にしましょう。
'
' 備考　　 :
'
Public Function SelectUpdateLogList( _
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
        Optional ByRef vntRsvDate As Variant, _
        Optional ByRef vntItemCd As Variant, _
        Optional ByRef vntSuffix As Variant, _
        Optional ByRef vntItemName As Variant, _
        Optional ByRef vntJudClassCd As Variant, Optional ByRef vntJudClassName As Variant, _
        Optional ByRef vntBeforeResult As Variant, _
        Optional ByRef vntAfterResult As Variant _
) As Long

    Dim objOraParam           As OraParameters  'OraParametersオブジェクト
    Dim objOraDyna            As OraDynaset     'ダイナセット
    Dim strStmt               As String         'SQLステートメント
    Dim strStmt2              As String         'SQLステートメント
    Dim strStmt_count         As String         'SQLステートメント
    Dim strStmt_data          As String         'SQLステートメント
    
    Dim objFields             As OraFields      'フィールドオブジェクト

    Dim objUpdDate            As OraField     '更新日時
    Dim objUpdUser            As OraField     '更新者
    Dim objUpdUserName        As OraField     '更新者氏名
    Dim objUpdClass           As OraField     '更新分類
    Dim objUpdDiv             As OraField     '処理区分
    Dim objRsvNo              As OraField     '予約番号
    Dim objRsvDate            As OraField     '予約日
    Dim objItemCd             As OraField     '更新項目コード
    Dim objSuffix             As OraField     'サフィックス
    Dim objItemName           As OraField     '更新項目名称
    Dim objJudClassCd         As OraField     '判定分類コード
    Dim objJudClassName       As OraField     '判定分類名称
    Dim objBeforeResult       As OraField     '更新前値
    Dim objAfterResult        As OraField     '更新後値

    Dim vntArrUpdDate()          As Variant     '更新日時の配列
    Dim vntArrUpdUser()          As Variant     '更新者の配列
    Dim vntArrUpdUserName()      As Variant     '更新者氏名の配列
    Dim vntArrUpdClass()         As Variant     '更新分類の配列
    Dim vntArrUpdDiv()           As Variant     '処理区分の配列
    Dim vntArrRsvNo()            As Variant     '予約番号の配列
    Dim vntArrRsvDate()          As Variant     '予約日の配列
    Dim vntArrItemCd()           As Variant     '更新項目コーの配列ド
    Dim vntArrSuffix()           As Variant     'サフィックスの配列
    Dim vntArrItemName()         As Variant     '更新項目名称の配列
    Dim vntArrJudClassCd()       As Variant     '判定分類コードの配列
    Dim vntArrJudClassName()     As Variant     '判定分類名称の配列
    Dim vntArrBeforeResult()     As Variant     '更新前値の配列
    Dim vntArrAfterResult()      As Variant     '更新後値の配列
    
    Dim lngAllCount              As Long           '全件数
    Dim lngCount                 As Long           'レコード数
    
    Dim lngWhereFlg              As Long         'Where句開始有無フラグ
    
    '### 2004.01.13 add start
    Dim strBakDate               As String      '日付比較時退避用
    '### 2004.01.13 add end
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUpdUserName) Then vntUpdUserName = Empty
    If Not IsMissing(vntUpdClass) Then vntUpdClass = Empty
    If Not IsMissing(vntUpdDiv) Then vntUpdDiv = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntRsvDate) Then vntRsvDate = Empty
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = Empty
    If Not IsMissing(vntJudClassName) Then vntJudClassName = Empty
    If Not IsMissing(vntBeforeResult) Then vntBeforeResult = Empty
    If Not IsMissing(vntAfterResult) Then vntAfterResult = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    '### 2004.01.13 add start  日付比較バグ修正　by K.Fujii
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
    '### 2004.01.13 add end    日付比較バグ修正　by K.Fujii
    '検索条件に更新日あり？
    '### 2004.01.13 modify    条件文不適切により修正　1Line　by K.Fujii
'    If strStartUpdDate <> "" And IsEmpty(strStartUpdDate) = False Then
    If strStartUpdDate <> "" And IsDate(strStartUpdDate) = True Then
        objOraParam.Add "SUPDDATE", Trim(strStartUpdDate), ORAPARM_INPUT, ORATYPE_DATE
    End If
    '### 2004.01.13 modify    条件文不適切により修正　1Line　by K.Fujii
'    If strEndUpdDate <> "" And IsEmpty(strEndUpdDate) = False Then
    If strEndUpdDate <> "" And IsDate(strEndUpdDate) = True Then
        objOraParam.Add "EUPDDATE", DateAdd("d", 1, Trim(strEndUpdDate)), ORAPARM_INPUT, ORATYPE_DATE
    End If
    '### 2004.01.13 delete　4Line　by K.Fujii
'   If strStartUpdDate <> "" And IsEmpty(strStartUpdDate) = False And _
'        strEndUpdDate = "" Or IsEmpty(strEndUpdDate) Then
'        objOraParam.Add "EUPDDATE", DateAdd("d", 1, Trim(strStartUpdDate)), ORAPARM_INPUT, ORATYPE_DATE
'    End If
    
    '検索条件に更新者あり？
    If strSearchUpdUser <> "" And IsEmpty(strSearchUpdUser) = False Then
        objOraParam.Add "SRCUPDUSER", Trim(strSearchUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '検索条件に更新分類あり？
    If lngSearchUpdClass = "" Or IsEmpty(lngSearchUpdClass) = True Then
        lngSearchUpdClass = 0
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
              "        LOGVIEW.RSVNO,     LOGVIEW.RSVDATE,                               " & vbLf & _
              "        LOGVIEW.ITEMCD,    LOGVIEW.SUFFIX,                                " & vbLf & _
              "        NVL(LOGVIEW.ITEMNAME, LOGVIEW.ITEMCD || LOGVIEW.SUFFIX) ITEMNAME, " & vbLf & _
              "        LOGVIEW.JUDCLASSCD,                                               " & vbLf & _
              "        NVL( LOGVIEW.JUDCLASSNAME, LOGVIEW.JUDCLASSCD ) JUDCLASSNAME,     " & vbLf & _
              "        LOGVIEW.BEFORERESULT,                                             " & vbLf & _
              "        LOGVIEW.AFTERRESULT                                               "
          
    strStmt = "   FROM (SELECT ROWNUM SEQ,                                               " & vbLf & _
              "                UPDATELOGVIEW.UPDDATE,   UPDATELOGVIEW.UPDUSER,           " & vbLf & _
              "                HAINSUSER.USERNAME UPDUSERNAME,                           " & vbLf & _
              "                UPDATELOGVIEW.UPDCLASS,  UPDATELOGVIEW.UPDDIV,            " & vbLf & _
              "                UPDATELOGVIEW.RSVNO,     UPDATELOGVIEW.RSVDATE,           " & vbLf & _
              "                UPDATELOGVIEW.ITEMCD,    UPDATELOGVIEW.SUFFIX,            " & vbLf & _
              "                ITEM_C.ITEMNAME,                                          " & vbLf & _
              "                UPDATELOGVIEW.JUDCLASSCD,                                 " & vbLf & _
              "                JUDCLASS.JUDCLASSNAME,                                    " & vbLf & _
              "                UPDATELOGVIEW.BEFORERESULT,                               " & vbLf & _
              "                UPDATELOGVIEW.AFTERRESULT                                 "

    strStmt = strStmt & vbLf & _
              "           FROM (SELECT UPDATELOG.UPDDATE,   UPDATELOG.UPDUSER,           " & vbLf & _
              "                        UPDATELOG.UPDCLASS,  UPDATELOG.UPDDIV,            " & vbLf & _
              "                        UPDATELOG.RSVNO,     UPDATELOG.RSVDATE,           " & vbLf & _
              "                        UPDATELOG.ITEMCD,    UPDATELOG.SUFFIX,            " & vbLf & _
              "                        UPDATELOG.JUDCLASSCD,                             " & vbLf & _
              "                        UPDATELOG.BEFORERESULT,                           " & vbLf & _
              "                        UPDATELOG.AFTERRESULT                             " & vbLf & _
              "                   FROM UPDATELOG                                         "
    lngWhereFlg = 0

    '### 2004.01.13 日付比較バグ修正　by K.Fujii 条件delete 上で必ず更新日をセットしている
    '検索条件に更新日 開始あり？
'    If strStartUpdDate <> "" And IsEmpty(strStartUpdDate) = False Then
'        If strStartUpdDate > strEndUpdDate And strEndUpdDate <> "" Then
'            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
'            Exit Function
'        End If
    '### 2004.01.13 end
        strStmt = strStmt & vbLf & _
              "                  WHERE UPDATELOG.UPDDATE BETWEEN :SUPDDATE AND :EUPDDATE"
        lngWhereFlg = 1
    '### 2004.01.13 日付比較バグ修正　by K.Fujii 条件delete 上で必ず更新日をセットしている
'    Else
'        If strStartUpdDate <> "" And IsEmpty(strStartUpdDate) = False And _
'           strEndUpdDate = "" Or IsEmpty(strEndUpdDate) = True Then
'            strStmt = strStmt & vbLf & _
'              "                  WHERE UPDATELOG.UPDDATE = :SUPDDATE  "
'          lngWhereFlg = 1
'        End If
'    End If
    '### 2004.01.13 end
    
    '検索条件に更新者あり？
    If strSearchUpdUser <> "" And IsEmpty(strSearchUpdUser) = False Then
        If lngWhereFlg = 0 Then
            strStmt = strStmt & vbLf & " WHERE "
        Else
            strStmt = strStmt & vbLf & " AND "
        End If
        strStmt = strStmt & vbLf & _
              "                        UPDATELOG.UPDUSER = :SRCUPDUSER  "
        lngWhereFlg = 1
    End If
    
     '検索条件に更新分類あり？
    If lngSearchUpdClass <> 0 Then
        If lngWhereFlg = 0 Then
            strStmt = strStmt & vbLf & " WHERE "
        Else
            strStmt = strStmt & vbLf & " AND "
        End If
        strStmt = strStmt & vbLf & _
              "                        UPDATELOG.UPDCLASS = :SRCUPDCLASS  "
        lngWhereFlg = 1
    End If
    
    '## 2004.01.07 add start
    '検索条件に予約番号あり？
    If Not IsMissing(lngRsvNo) Then
        objOraParam.Add "SRCRSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
        If lngWhereFlg = 0 Then
            strStmt = strStmt & vbLf & " WHERE "
        Else
            strStmt = strStmt & vbLf & " AND "
        End If
        strStmt = strStmt & vbLf & _
              "                        UPDATELOG.RSVNO = :SRCRSVNO  "
        lngWhereFlg = 1
    End If
    '## 2004.01.07 add end
    
    '降順？
    If lngOrderbyMode = 1 Then
        strStmt2 = " DESC"
    Else
        strStmt2 = " ASC"
    End If
    
    '並び替えの指定
    strStmt = strStmt & vbLf & _
            " ORDER BY "
    Select Case lngOrderbyItem
    '更新日
    Case 0
        strStmt = strStmt & " UPDATELOG.UPDDATE " & strStmt2
    '更新者
    Case 1
        strStmt = strStmt & " UPDATELOG.UPDUSER " & strStmt2
    '分類・項目
    Case 2
        '### 2004.01.13 JUDCLASSCD 追加 分類判定のときの並び替えができていない
        strStmt = strStmt & " UPDATELOG.UPDCLASS     " & strStmt2 & _
                            " ,UPDATELOG.ITEMCD      " & strStmt2 & _
                            " ,UPDATELOG.SUFFIX      " & strStmt2 & _
                            " ,UPDATELOG.JUDCLASSCD  " & strStmt2
    Case Else
        strStmt = strStmt & " UPDATELOG.UPDDATE " & strStmt2
    End Select
    
    strStmt = strStmt & vbLf & _
              "                ) UPDATELOGVIEW,                                          " & vbLf & _
              "                ITEM_C, JUDCLASS, HAINSUSER                               " & vbLf & _
              "          WHERE UPDATELOGVIEW.ITEMCD      = ITEM_C.ITEMCD(+)              " & vbLf & _
              "            AND UPDATELOGVIEW.SUFFIX      = ITEM_C.SUFFIX(+)              " & vbLf & _
              "            AND UPDATELOGVIEW.JUDCLASSCD  = JUDCLASS.JUDCLASSCD(+)        " & vbLf & _
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
        Set objRsvDate = objFields("RSVDATE")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objBeforeResult = objFields("BEFORERESULT")
        Set objAfterResult = objFields("AFTERRESULT")
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrUpdDate(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)
            ReDim Preserve vntArrUpdUserName(lngCount)
            ReDim Preserve vntArrUpdClass(lngCount)
            ReDim Preserve vntArrUpdDiv(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrRsvDate(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            ReDim Preserve vntArrBeforeResult(lngCount)
            ReDim Preserve vntArrAfterResult(lngCount)
            
            vntArrUpdDate(lngCount) = objUpdDate.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""
            vntArrUpdUserName(lngCount) = objUpdUserName.Value & ""
            vntArrUpdClass(lngCount) = objUpdClass.Value & ""
            vntArrUpdDiv(lngCount) = objUpdDiv.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrRsvDate(lngCount) = objRsvDate.Value & ""
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrJudClassCd(lngCount) = objJudClassCd.Value & ""
            vntArrJudClassName(lngCount) = objJudClassName.Value & ""
            vntArrBeforeResult(lngCount) = objBeforeResult.Value & ""
            vntArrAfterResult(lngCount) = objAfterResult.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    SelectUpdateLogList = lngAllCount
    
    '戻り値の設定
    If Not IsMissing(vntUpdDate) Then vntUpdDate = vntArrUpdDate
    If Not IsMissing(vntUpdUser) Then vntUpdUser = vntArrUpdUser
    If Not IsMissing(vntUpdUserName) Then vntUpdUserName = vntArrUpdUserName
    If Not IsMissing(vntUpdClass) Then vntUpdClass = vntArrUpdClass
    If Not IsMissing(vntUpdDiv) Then vntUpdDiv = vntArrUpdDiv
    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
    If Not IsMissing(vntRsvDate) Then vntRsvDate = vntArrRsvDate
    If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
    If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
    If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
    If Not IsMissing(vntJudClassCd) Then vntJudClassCd = vntArrJudClassCd
    If Not IsMissing(vntJudClassName) Then vntJudClassName = vntArrJudClassName
    If Not IsMissing(vntBeforeResult) Then vntBeforeResult = vntArrBeforeResult
    If Not IsMissing(vntAfterResult) Then vntAfterResult = vntArrAfterResult
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectUpdateLogList = -1
    
    'イベントログ書き込み ## クラス名修正　2004.01.13
    WriteErrorLog "Interview.SelectUpdateLogList"
    
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
' 機能　　 : 指定された予約番号のオーダ番号、送信日を取得する
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (In)     strOrderDiv         オーダ種別
' 　　　　   (Out)    vntOrderNo          オーダ番号
' 　　　　   (Out)    vntSendDate         送信日
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
'Public Function SelectOrderNo(
'    ByVal lngRsvNo As Long,
'    ByVal strOrderDiv As String,
'    Optional ByRef vntOrderNo As Variant
') As Boolean
Public Function SelectOrderNo( _
    ByVal lngRsvNo As Long, _
    ByVal strOrderDiv As String, _
    Optional ByRef vntOrderNo As Variant, _
    Optional ByRef vntSendDate As Variant _
) As Boolean
'#### 2011.01.20 SL-HS-Y0101-003 MOD END ####

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objOrderNo          As OraField         'オーダ番号
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
    Dim objSendDate         As OraField         '送信日
'#### 2011.01.20 SL-HS-Y0101-003 MOD END ####

    'エラーハンドラの設定
    On Error GoTo ErrorHandle


    SelectOrderNo = False

    '初期処理
    If Not IsMissing(vntOrderNo) Then vntOrderNo = Empty
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
    If Not IsMissing(vntSendDate) Then vntSendDate = Empty
'#### 2011.01.20 SL-HS-Y0101-003 MOD END ####

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORDERDIV", strOrderDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定された予約番号と同一のコースを含むコースグループを取得する
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
'    strStmt = "SELECT DISTINCT ORDERNO      " & vbLf & _
'              "  FROM ORDEREDDOC            " & vbLf & _
'              " WHERE RSVNO    = :RSVNO     " & vbLf & _
'              "   AND ORDERDIV = :ORDERDIV  "
    strStmt = "SELECT DISTINCT ORDERNO, SENDDATE      " & vbLf & _
              "  FROM ORDEREDDOC            " & vbLf & _
              " WHERE RSVNO    = :RSVNO     " & vbLf & _
              "   AND ORDERDIV = :ORDERDIV  "
'#### 2011.01.20 SL-HS-Y0101-003 MOD END ####
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrderNo = objFields("ORDERNO")
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
        Set objSendDate = objFields("SENDDATE")
'#### 2011.01.20 SL-HS-Y0101-003 MOD END ####

        '戻り値の設定
        If Not IsMissing(vntOrderNo) Then vntOrderNo = objOrderNo.Value & ""
'#### 2011.01.20 SL-HS-Y0101-003 MOD START ####
        If Not IsMissing(vntSendDate) Then vntSendDate = objSendDate.Value & ""
'#### 2011.01.20 SL-HS-Y0101-003 MOD END ####
    
         '戻り値の設定
        SelectOrderNo = True
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectOrderNo = False

    'イベントログ書き込み
    WriteErrorLog "Interview.SelectOrderNo"
    
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
'#### 2006.02.03 追加　by 張
'
' 機能　　 : 健診が終わった後受診者の個人IDを変更した場合、変更前のIDと変更後のIDを取得
'            RayPax画像参リングなどに利用する為(変更個人ID追跡)
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (Out)    vntPerIdBefore      変更前個人ID
' 　　　　   (Out)    vntPerIdAfter       変更後個人ID
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectChangePerId( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntPerIdBefore As Variant, _
    Optional ByRef vntPerIdAfter As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerIdBefore      As OraField         '変更前個人ID
    Dim objPerIdAfter       As OraField         '変更後個人ID

    'エラーハンドラの設定
    On Error GoTo ErrorHandle


    SelectChangePerId = False

    '初期処理
    If Not IsMissing(vntPerIdBefore) Then vntPerIdBefore = Empty
    If Not IsMissing(vntPerIdAfter) Then vntPerIdAfter = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = "SELECT FREECD,     FREENAME,   FREEDATE,   FREEFIELD1,              " & vbLf & _
              "       FREEFIELD2, FREEFIELD3, FREEFIELD4, FREEFIELD5, FREECLASSCD, " & vbLf & _
              "       FREEFIELD6, FREEFIELD7                                       " & vbLf & _
              "  FROM FREE                                                         " & vbLf & _
              " WHERE FREECD LIKE 'CHGPERID%'                                      " & vbLf & _
              "   AND FREEFIELD1 = :RSVNO                                          "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerIdBefore = objFields("FREEFIELD2")
        Set objPerIdAfter = objFields("FREEFIELD3")

        '戻り値の設定
        If Not IsMissing(vntPerIdBefore) Then vntPerIdBefore = objPerIdBefore.Value & ""
        If Not IsMissing(vntPerIdAfter) Then vntPerIdAfter = objPerIdAfter.Value & ""
    
         '戻り値の設定
        SelectChangePerId = True
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectChangePerId = False

    'イベントログ書き込み
    WriteErrorLog "Interview.SelectChangePerId"
    
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

'#### 2006.03.23 EGFR結果表示用　追加　by 張
'
' 機能　　 : eGFR計算結果を履歴として取得
'
'
' 引数　　 : (In)     lngRsvNo              検索条件：予約番号
' 　　　　   (In)     strHisCount           表示歴数
' 　　　　   (In)     vntCsGrp              前回歴表示モード＝0のとき、null
' 　　　　                                                  ＝1のとき、コースコード
' 　　　　                                                  ＝2のとき、コースグループコード
' 　　　　   (Out)    vntHisNo              履歴No.
' 　　　　   (Out)    vntCslDate            来院日
' 　　　　   (Out)    vntEGFR               eGFR計算結果
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectEGFRHistory( _
        ByVal lngRsvNo As Long, _
        ByVal strHisCount As String, _
        ByVal vntCsGrp As Variant, _
        ByRef vntHisNo As Variant, _
        ByRef vntCslDate As Variant, _
        ByRef vntEGFR As Variant _
) As Long

    Dim objOraParam           As OraParameters  'OraParametersオブジェクト
    Dim objOraDyna            As OraDynaset     'ダイナセット
    Dim strStmt               As String         'SQLステートメント
    
    Dim objFields             As OraFields      'フィールドオブジェクト

    Dim objHisNo              As OraField       '履歴No.
    Dim objCslDate            As OraField       '来院日
    Dim objEGFR               As OraField       'eGFR計算結果

    Dim vntArrHisNo()         As Variant        '履歴No.の配列
    Dim vntArrCslDate()       As Variant        '来院日の配列
    Dim vntArrEGFR()          As Variant        'eGFR計算結果の配列
    
    Dim lngCount              As Long           'レコード数
    Dim lngHistoryCount       As Long           '表示歴数
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntHisNo) Then vntHisNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntEGFR) Then vntEGFR = Empty
    
    '表示歴数が「全件」以外で、数値でない場合はエラー
    If strHisCount <> "*" Then
        If Not IsNumeric(strHisCount) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        lngHistoryCount = CLng(strHisCount)
    Else
        lngHistoryCount = 0
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngHistoryCount > 0 Then
        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
       
    strStmt = "SELECT FINALRSL.HISNO      HISNO                             " & vbLf & _
              "     ,FINALRSL.CSLDATE     CSLDATE                           " & vbLf & _
              "     ,MAX(FINALRSL.eGFR)   EGFR                              " & vbLf & _
              " FROM (                                                      " & vbLf & _
              "       SELECT CONSULTVIEW.SEQ      HISNO                     " & vbLf & _
              "             ,CONSULTVIEW.CSLDATE  CSLDATE                   " & vbLf & _
              "             ,DECODE(PERSON.GENDER,1 , (ROUND(  ( (140 - TRUNC(Getcslage(PERSON.BIRTH, CONSULTVIEW.CSLDATE, TO_CHAR(CONSULTVIEW.CSLDATE,('YYYYMMDD')))))             " & vbLf & _
              "                                                 * (SELECT TO_NUMBER(result) FROM rsl WHERE rsvno = CONSULTVIEW.RSVNO                                                " & vbLf & _
              "                                                                                        AND itemcd = '10021'                                                         " & vbLf & _
              "                                                                                        AND suffix = '00') )                                                         " & vbLf & _
              "                                                  / (TO_NUMBER(RSL.RESULT) * 72),  1))                                                                               " & vbLf & _
              "                                     , (ROUND(  ( ((140 - TRUNC(Getcslage(PERSON.BIRTH, CONSULTVIEW.CSLDATE, TO_CHAR(CONSULTVIEW.CSLDATE,('YYYYMMDD')))))            " & vbLf & _
              "                                                 * (SELECT TO_NUMBER(result) FROM rsl WHERE rsvno = CONSULTVIEW.RSVNO                                                " & vbLf & _
              "                                                                                        AND itemcd = '10021'                                                         " & vbLf & _
              "                                                                                        AND suffix = '00') )                                                         " & vbLf & _
              "                                                  / (TO_NUMBER(RSL.RESULT) * 72)) * 0.85,  1) )                                                                      " & vbLf & _
              "              ) eGFR                                         "
    strStmt = strStmt & _
              "         FROM (                                              " & vbLf & _
              "               SELECT ROWNUM SEQ                             " & vbLf & _
              "                     ,CSLDATE                                " & vbLf & _
              "                     ,RSVNO                                  " & vbLf & _
              "                     ,PERID                                  " & vbLf & _
              "                 FROM ( SELECT CONSULT.CSLDATE               " & vbLf & _
              "                              ,CONSULT.RSVNO                 " & vbLf & _
              "                              ,CONSULT.PERID                 " & vbLf & _
              "                          FROM CONSULT                       " & vbLf & _
              "                         WHERE CONSULT.PERID     = (SELECT DISTINCT PERID            " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           "
    strStmt = strStmt & _
              "                           AND CONSULT.CSLDATE  <= (SELECT DISTINCT CSLDATE          " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           " & vbLf & _
              "                           AND CONSULT.CSCD     IN (SELECT FREEFIELD1 CSCD           " & vbLf & _
              "                                                      FROM FREE                      " & vbLf & _
              "                                                     WHERE FREECD LIKE :CSCD||'%')   " & vbLf & _
              "                           AND CONSULT.CANCELFLG = 0                                 " & vbLf & _
              "                         ORDER BY CONSULT.CSLDATE DESC )                             " & vbLf & _
              "              ) CONSULTVIEW                                                          " & vbLf & _
              "             ,PERSON                                                                 " & vbLf & _
              "             ,RSL                                                                    " & vbLf & _
              "        WHERE CONSULTVIEW.RSVNO    = RSL.RSVNO                                       "
        If lngHistoryCount > 0 Then
            strStmt = strStmt & vbLf & _
              "          AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
        End If

    strStmt = strStmt & _
              "          AND RSL.STOPFLG IS NULL                                                    " & vbLf & _
              "          AND CONSULTVIEW.PERID    = PERSON.PERID                                    " & vbLf & _
              "          AND CONSULTVIEW.RSVNO    = RSL.RSVNO                                       " & vbLf & _
              "          AND RSL.ITEMCD           = '17221'                                         " & vbLf & _
              "          AND RSL.SUFFIX           = '00'                                            "

    strStmt = strStmt & vbLf & _
              "    UNION ALL                                                                        " & vbLf & _
              "       SELECT CONSULTVIEW.SEQ      HISNO                                             " & vbLf & _
              "             ,CONSULTVIEW.CSLDATE  CSLDATE                                           " & vbLf & _
              "             ,NULL                 eGFR                                              " & vbLf & _
              "         FROM (                                                                      " & vbLf & _
              "               SELECT ROWNUM SEQ                                                     " & vbLf & _
              "                     ,CSLDATE                                                        " & vbLf & _
              "                     ,RSVNO                                                          " & vbLf & _
              "                     ,PERID                                                          "
    strStmt = strStmt & _
              "                 FROM ( SELECT CONSULT.CSLDATE                                       " & vbLf & _
              "                              ,CONSULT.RSVNO                                         " & vbLf & _
              "                              ,CONSULT.PERID                                         " & vbLf & _
              "                          FROM CONSULT                                               " & vbLf & _
              "                         WHERE CONSULT.PERID     = (SELECT DISTINCT PERID            " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           " & vbLf & _
              "                           AND CONSULT.CSLDATE  <= (SELECT DISTINCT CSLDATE          " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           " & vbLf & _
              "                           AND CONSULT.CSCD     IN (SELECT FREEFIELD1 CSCD           " & vbLf & _
              "                                                      FROM FREE                      " & vbLf & _
              "                                                     WHERE FREECD LIKE :CSCD||'%')   " & vbLf & _
              "                           AND CONSULT.CANCELFLG = 0                                 " & vbLf & _
              "                         ORDER BY CONSULT.CSLDATE DESC )                             " & vbLf & _
              "              ) CONSULTVIEW                                                          "
        If lngHistoryCount > 0 Then
            strStmt = strStmt & vbLf & _
              "        WHERE CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
        End If

    strStmt = strStmt & _
              "      ) FINALRSL                                                                     " & vbLf & _
              "GROUP BY FINALRSL.HISNO, FINALRSL.CSLDATE                                            "
    
    'データ取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    lngCount = 0
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objHisNo = objFields("HISNO")
        Set objCslDate = objFields("CSLDATE")
        Set objEGFR = objFields("EGFR")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrHisNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrEGFR(lngCount)
            
            vntArrHisNo(lngCount) = objHisNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrEGFR(lngCount) = objEGFR.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    SelectEGFRHistory = lngCount
    
    '戻り値の設定
    If Not IsMissing(vntHisNo) Then vntHisNo = vntArrHisNo
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntEGFR) Then vntEGFR = vntArrEGFR
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectEGFRHistory = -1
    
    'イベントログ書き込み
    WriteErrorLog "Interview.SelectEGFRHistory"
    
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
'#### 2007.03.22 EGFR結果表示用　追加　by 張
'
' 機能　　 : eGFR(MDRD)計算結果を履歴として取得
'
'
' 引数　　 : (In)     lngRsvNo              検索条件：予約番号
' 　　　　   (In)     strHisCount           表示歴数
' 　　　　   (In)     vntCsGrp              前回歴表示モード＝0のとき、null
' 　　　　                                                  ＝1のとき、コースコード
' 　　　　                                                  ＝2のとき、コースグループコード
' 　　　　   (Out)    vntHisNo              履歴No.
' 　　　　   (Out)    vntCslDate            来院日
' 　　　　   (Out)    vntEGFR               eGFR(MDRD)計算結果
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectMDRDHistory( _
        ByVal lngRsvNo As Long, _
        ByVal strHisCount As String, _
        ByVal vntCsGrp As Variant, _
        ByRef vntHisNo As Variant, _
        ByRef vntCslDate As Variant, _
        ByRef vntEGFR As Variant _
) As Long

    Dim objOraParam           As OraParameters  'OraParametersオブジェクト
    Dim objOraDyna            As OraDynaset     'ダイナセット
    Dim strStmt               As String         'SQLステートメント
    
    Dim objFields             As OraFields      'フィールドオブジェクト

    Dim objHisNo              As OraField       '履歴No.
    Dim objCslDate            As OraField       '来院日
    Dim objEGFR               As OraField       'eGFR(MDRD)計算結果

    Dim vntArrHisNo()         As Variant        '履歴No.の配列
    Dim vntArrCslDate()       As Variant        '来院日の配列
    Dim vntArrEGFR()          As Variant        'eGFR(MDRD)計算結果の配列
    
    Dim lngCount              As Long           'レコード数
    Dim lngHistoryCount       As Long           '表示歴数
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntHisNo) Then vntHisNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntEGFR) Then vntEGFR = Empty
    
    '表示歴数が「全件」以外で、数値でない場合はエラー
    If strHisCount <> "*" Then
        If Not IsNumeric(strHisCount) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        lngHistoryCount = CLng(strHisCount)
    Else
        lngHistoryCount = 0
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngHistoryCount > 0 Then
        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
       
    strStmt = "SELECT FINALRSL.HISNO      HISNO                             " & vbLf & _
              "     ,FINALRSL.CSLDATE     CSLDATE                           " & vbLf & _
              "     ,MAX(FINALRSL.eGFR)   EGFR                              " & vbLf & _
              " FROM (                                                      " & vbLf & _
              "       SELECT CONSULTVIEW.SEQ      HISNO                     " & vbLf & _
              "             ,CONSULTVIEW.CSLDATE  CSLDATE                   " & vbLf & _
              "             ,DECODE (PERSON.GENDER, 1, ROUND( (186.3 * POWER (TO_NUMBER(RSL.RESULT) , -1.154)                                                                            " & vbLf & _
              "                                                    * POWER (TRUNC(Getcslage(PERSON.BIRTH, CONSULTVIEW.CSLDATE, TO_CHAR(CONSULTVIEW.CSLDATE,('YYYYMMDD')))) , -0.203))    " & vbLf & _
              "                                                    * 0.881, 1) ,                                                                                                         " & vbLf & _
              "                                     2, ROUND( ((186.3 * POWER (TO_NUMBER(RSL.RESULT) , -1.154)                                                                           " & vbLf & _
              "                                                    * POWER (TRUNC(Getcslage(PERSON.BIRTH, CONSULTVIEW.CSLDATE, TO_CHAR(CONSULTVIEW.CSLDATE,('YYYYMMDD')))) , -0.203) )   " & vbLf & _
              "                                                    * 0.881 ) * 0.746, 1)                                                                                                 " & vbLf & _
              "                            ) eGFR                           "
    strStmt = strStmt & _
              "         FROM (                                              " & vbLf & _
              "               SELECT ROWNUM SEQ                             " & vbLf & _
              "                     ,CSLDATE                                " & vbLf & _
              "                     ,RSVNO                                  " & vbLf & _
              "                     ,PERID                                  " & vbLf & _
              "                 FROM ( SELECT CONSULT.CSLDATE               " & vbLf & _
              "                              ,CONSULT.RSVNO                 " & vbLf & _
              "                              ,CONSULT.PERID                 " & vbLf & _
              "                          FROM CONSULT                       " & vbLf & _
              "                         WHERE CONSULT.PERID     = (SELECT DISTINCT PERID            " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           "
    strStmt = strStmt & _
              "                           AND CONSULT.CSLDATE  <= (SELECT DISTINCT CSLDATE          " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           " & vbLf & _
              "                           AND CONSULT.CSCD     IN (SELECT FREEFIELD1 CSCD           " & vbLf & _
              "                                                      FROM FREE                      " & vbLf & _
              "                                                     WHERE FREECD LIKE :CSCD||'%')   " & vbLf & _
              "                           AND CONSULT.CANCELFLG = 0                                 " & vbLf & _
              "                         ORDER BY CONSULT.CSLDATE DESC )                             " & vbLf & _
              "              ) CONSULTVIEW                                                          " & vbLf & _
              "             ,PERSON                                                                 " & vbLf & _
              "             ,RSL                                                                    " & vbLf & _
              "        WHERE CONSULTVIEW.RSVNO    = RSL.RSVNO                                       "
        If lngHistoryCount > 0 Then
            strStmt = strStmt & vbLf & _
              "          AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
        End If

    strStmt = strStmt & _
              "          AND RSL.STOPFLG IS NULL                                                    " & vbLf & _
              "          AND CONSULTVIEW.PERID    = PERSON.PERID                                    " & vbLf & _
              "          AND CONSULTVIEW.RSVNO    = RSL.RSVNO                                       " & vbLf & _
              "          AND RSL.ITEMCD           = '17221'                                         " & vbLf & _
              "          AND RSL.SUFFIX           = '00'                                            "

    strStmt = strStmt & vbLf & _
              "    UNION ALL                                                                        " & vbLf & _
              "       SELECT CONSULTVIEW.SEQ      HISNO                                             " & vbLf & _
              "             ,CONSULTVIEW.CSLDATE  CSLDATE                                           " & vbLf & _
              "             ,NULL                 eGFR                                              " & vbLf & _
              "         FROM (                                                                      " & vbLf & _
              "               SELECT ROWNUM SEQ                                                     " & vbLf & _
              "                     ,CSLDATE                                                        " & vbLf & _
              "                     ,RSVNO                                                          " & vbLf & _
              "                     ,PERID                                                          "
    strStmt = strStmt & _
              "                 FROM ( SELECT CONSULT.CSLDATE                                       " & vbLf & _
              "                              ,CONSULT.RSVNO                                         " & vbLf & _
              "                              ,CONSULT.PERID                                         " & vbLf & _
              "                          FROM CONSULT                                               " & vbLf & _
              "                         WHERE CONSULT.PERID     = (SELECT DISTINCT PERID            " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           " & vbLf & _
              "                           AND CONSULT.CSLDATE  <= (SELECT DISTINCT CSLDATE          " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           " & vbLf & _
              "                           AND CONSULT.CSCD     IN (SELECT FREEFIELD1 CSCD           " & vbLf & _
              "                                                      FROM FREE                      " & vbLf & _
              "                                                     WHERE FREECD LIKE :CSCD||'%')   " & vbLf & _
              "                           AND CONSULT.CANCELFLG = 0                                 " & vbLf & _
              "                         ORDER BY CONSULT.CSLDATE DESC )                             " & vbLf & _
              "              ) CONSULTVIEW                                                          "
        If lngHistoryCount > 0 Then
            strStmt = strStmt & vbLf & _
              "        WHERE CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
        End If

    strStmt = strStmt & _
              "      ) FINALRSL                                                                     " & vbLf & _
              "GROUP BY FINALRSL.HISNO, FINALRSL.CSLDATE                                            "
    
    'データ取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    lngCount = 0
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objHisNo = objFields("HISNO")
        Set objCslDate = objFields("CSLDATE")
        Set objEGFR = objFields("EGFR")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrHisNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrEGFR(lngCount)
            
            vntArrHisNo(lngCount) = objHisNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrEGFR(lngCount) = objEGFR.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    SelectMDRDHistory = lngCount
    
    '戻り値の設定
    If Not IsMissing(vntHisNo) Then vntHisNo = vntArrHisNo
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntEGFR) Then vntEGFR = vntArrEGFR
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectMDRDHistory = -1
    
    'イベントログ書き込み
    WriteErrorLog "Interview.SelectMDRDHistory"
    
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

'#### 2008.07.01 新しいGFR結果表示用　追加　by 張
'
' 機能　　 : GFR(新しい日本人の推算式)計算結果を履歴として取得
'
'
' 引数　　 : (In)     lngRsvNo              検索条件：予約番号
' 　　　　   (In)     strHisCount           表示歴数
' 　　　　   (In)     vntCsGrp              前回歴表示モード＝0のとき、null
' 　　　　                                                  ＝1のとき、コースコード
' 　　　　                                                  ＝2のとき、コースグループコード
' 　　　　   (Out)    vntHisNo              履歴No.
' 　　　　   (Out)    vntCslDate            来院日
' 　　　　   (Out)    vntEGFR               GFR計算結果
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectNewGFRHistory( _
        ByVal lngRsvNo As Long, _
        ByVal strHisCount As String, _
        ByVal vntCsGrp As Variant, _
        ByRef vntHisNo As Variant, _
        ByRef vntCslDate As Variant, _
        ByRef vntGFR As Variant _
) As Long

    Dim objOraParam           As OraParameters  'OraParametersオブジェクト
    Dim objOraDyna            As OraDynaset     'ダイナセット
    Dim strStmt               As String         'SQLステートメント
    
    Dim objFields             As OraFields      'フィールドオブジェクト

    Dim objHisNo              As OraField       '履歴No.
    Dim objCslDate            As OraField       '来院日
    Dim objGFR                As OraField       'GFR(新しい日本人の推算式)計算結果

    Dim vntArrHisNo()         As Variant        '履歴No.の配列
    Dim vntArrCslDate()       As Variant        '来院日の配列
    Dim vntArrGFR()           As Variant        'GFR(新しい日本人の推算式)計算結果の配列
    
    Dim lngCount              As Long           'レコード数
    Dim lngHistoryCount       As Long           '表示歴数
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntHisNo) Then vntHisNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntGFR) Then vntGFR = Empty
    
    '表示歴数が「全件」以外で、数値でない場合はエラー
    If strHisCount <> "*" Then
        If Not IsNumeric(strHisCount) Then
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
        lngHistoryCount = CLng(strHisCount)
    Else
        lngHistoryCount = 0
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngHistoryCount > 0 Then
        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
       
    strStmt = "SELECT FINALRSL.HISNO      HISNO                             " & vbLf & _
              "     ,FINALRSL.CSLDATE     CSLDATE                           " & vbLf & _
              "     ,MAX(FINALRSL.GFR)    GFR                               " & vbLf & _
              " FROM (                                                      " & vbLf & _
              "       SELECT CONSULTVIEW.SEQ      HISNO                     " & vbLf & _
              "             ,CONSULTVIEW.CSLDATE  CSLDATE                   " & vbLf & _
              "             ,DECODE (PERSON.GENDER, 1, ROUND( (194 * POWER (TO_NUMBER(RSL.RESULT) , -1.094)                                                                               " & vbLf & _
              "                                                    * POWER (TRUNC(Getcslage(PERSON.BIRTH, CONSULTVIEW.CSLDATE, TO_CHAR(CONSULTVIEW.CSLDATE,('YYYYMMDD')))) , -0.287))     " & vbLf & _
              "                                                    , 1) ,                                                                                                                 " & vbLf & _
              "                                     2, ROUND( ((194 * POWER (TO_NUMBER(RSL.RESULT) , -1.094)                                                                              " & vbLf & _
              "                                                    * POWER (TRUNC(Getcslage(PERSON.BIRTH, CONSULTVIEW.CSLDATE, TO_CHAR(CONSULTVIEW.CSLDATE,('YYYYMMDD')))) , -0.287)) )   " & vbLf & _
              "                                                    * 0.739, 1)                                                                                                          " & vbLf & _
              "                            ) GFR                            "
    strStmt = strStmt & _
              "         FROM (                                              " & vbLf & _
              "               SELECT ROWNUM SEQ                             " & vbLf & _
              "                     ,CSLDATE                                " & vbLf & _
              "                     ,RSVNO                                  " & vbLf & _
              "                     ,PERID                                  " & vbLf & _
              "                 FROM ( SELECT CONSULT.CSLDATE               " & vbLf & _
              "                              ,CONSULT.RSVNO                 " & vbLf & _
              "                              ,CONSULT.PERID                 " & vbLf & _
              "                          FROM CONSULT                       " & vbLf & _
              "                         WHERE CONSULT.PERID     = (SELECT DISTINCT PERID            " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           "
    strStmt = strStmt & _
              "                           AND CONSULT.CSLDATE  <= (SELECT DISTINCT CSLDATE          " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           " & vbLf & _
              "                           AND CONSULT.CSCD     IN (SELECT FREEFIELD1 CSCD           " & vbLf & _
              "                                                      FROM FREE                      " & vbLf & _
              "                                                     WHERE FREECD LIKE :CSCD||'%')   " & vbLf & _
              "                           AND CONSULT.CANCELFLG = 0                                 " & vbLf & _
              "                         ORDER BY CONSULT.CSLDATE DESC )                             " & vbLf & _
              "              ) CONSULTVIEW                                                          " & vbLf & _
              "             ,PERSON                                                                 " & vbLf & _
              "             ,RSL                                                                    " & vbLf & _
              "        WHERE CONSULTVIEW.RSVNO    = RSL.RSVNO                                       "
        If lngHistoryCount > 0 Then
            strStmt = strStmt & vbLf & _
              "          AND CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
        End If

    strStmt = strStmt & _
              "          AND RSL.STOPFLG IS NULL                                                    " & vbLf & _
              "          AND CONSULTVIEW.PERID    = PERSON.PERID                                    " & vbLf & _
              "          AND CONSULTVIEW.RSVNO    = RSL.RSVNO                                       " & vbLf & _
              "          AND RSL.ITEMCD           = '17221'                                         " & vbLf & _
              "          AND RSL.SUFFIX           = '00'                                            "

    strStmt = strStmt & vbLf & _
              "    UNION ALL                                                                        " & vbLf & _
              "       SELECT CONSULTVIEW.SEQ      HISNO                                             " & vbLf & _
              "             ,CONSULTVIEW.CSLDATE  CSLDATE                                           " & vbLf & _
              "             ,NULL                 GFR                                               " & vbLf & _
              "         FROM (                                                                      " & vbLf & _
              "               SELECT ROWNUM SEQ                                                     " & vbLf & _
              "                     ,CSLDATE                                                        " & vbLf & _
              "                     ,RSVNO                                                          " & vbLf & _
              "                     ,PERID                                                          "
    strStmt = strStmt & _
              "                 FROM ( SELECT CONSULT.CSLDATE                                       " & vbLf & _
              "                              ,CONSULT.RSVNO                                         " & vbLf & _
              "                              ,CONSULT.PERID                                         " & vbLf & _
              "                          FROM CONSULT                                               " & vbLf & _
              "                         WHERE CONSULT.PERID     = (SELECT DISTINCT PERID            " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           " & vbLf & _
              "                           AND CONSULT.CSLDATE  <= (SELECT DISTINCT CSLDATE          " & vbLf & _
              "                                                      FROM CONSULT                   " & vbLf & _
              "                                                     WHERE RSVNO = :RSVNO)           " & vbLf & _
              "                           AND CONSULT.CSCD     IN (SELECT FREEFIELD1 CSCD           " & vbLf & _
              "                                                      FROM FREE                      " & vbLf & _
              "                                                     WHERE FREECD LIKE :CSCD||'%')   " & vbLf & _
              "                           AND CONSULT.CANCELFLG = 0                                 " & vbLf & _
              "                         ORDER BY CONSULT.CSLDATE DESC )                             " & vbLf & _
              "              ) CONSULTVIEW                                                          "
        If lngHistoryCount > 0 Then
            strStmt = strStmt & vbLf & _
              "        WHERE CONSULTVIEW.SEQ BETWEEN 1 AND :HISCOUNT  "
        End If

    strStmt = strStmt & _
              "      ) FINALRSL                                                                     " & vbLf & _
              "GROUP BY FINALRSL.HISNO, FINALRSL.CSLDATE                                            "
    
    'データ取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    lngCount = 0
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objHisNo = objFields("HISNO")
        Set objCslDate = objFields("CSLDATE")
        Set objGFR = objFields("GFR")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrHisNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrGFR(lngCount)
            
            vntArrHisNo(lngCount) = objHisNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrGFR(lngCount) = objGFR.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    SelectNewGFRHistory = lngCount
    
    '戻り値の設定
    If Not IsMissing(vntHisNo) Then vntHisNo = vntArrHisNo
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntGFR) Then vntGFR = vntArrGFR
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectNewGFRHistory = -1
    
    'イベントログ書き込み
    WriteErrorLog "Interview.SelectNewGFRHistory"
    
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



'#### 2003.12.16 追加　by FFCS
'
' 機能　　 : 指定された予約番号の多変量解析を行いＸ座標、Ｙ座標を求める
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (Out)    vntValueX           Ｘ座標
' 　　　　   (Out)    vntValueY           Ｙ座標
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function StatisticsCalc( _
    ByVal lngRsvNo As Long, _
    ByRef vntValueX As Variant, _
    ByRef vntValueY As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    Dim strStmt2            As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objResult           As OraField         '検査結果
    Dim objMethodNo         As OraField         '変換方法
    Dim objAverage          As OraField         '平均値
    Dim objDeviation        As OraField         '標準偏差
    Dim objCan1             As OraField         '第１正準変量
    Dim objCan2             As OraField         '第２正準変量

    Dim dblResult           As Double           '検査結果
    Dim lngMethodNo         As Double           '変換方法
    Dim dblAverage          As Double           '平均値
    Dim dblDeviation        As Double           '標準偏差
    Dim dblCan1             As Double           '第１正準変量
    Dim dblCan2             As Double           '第２正準変量
    
    Dim dblConvert          As Double           '変換値
    Dim dblSDI              As Double           'SDI値
    
    Dim dblValueX           As Double           'Ｘ座標
    Dim dblValueY           As Double           'Ｙ座標
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle


    StatisticsCalc = False
    dblValueX = 0
    dblValueY = 0
    vntValueX = dblValueX
    vntValueY = dblValueY

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "GRPCD", STATISTICS_GRPCD, ORAPARM_INPUT, ORATYPE_VARCHAR2

    ' 計算対象となる検査結果の件数取得
    strStmt = "SELECT COUNT(*) RSLCNT       " & vbLf & _
              "  FROM CONSULT, GRP_I, RSL   "
     
    ' 検査結果取得条件
    strStmt2 = "         WHERE CONSULT.RSVNO  = :RSVNO           " & vbLf & _
              "           AND GRP_I.GRPCD     = :GRPCD           " & vbLf & _
              "           AND RSL.RSVNO       = CONSULT.RSVNO    " & vbLf & _
              "           AND RSL.ITEMCD      = GRP_I.ITEMCD     " & vbLf & _
              "           AND RSL.SUFFIX      = GRP_I.SUFFIX     " & vbLf & _
              "           AND RSL.RESULT IS NOT NULL             " & vbLf & _
              "           AND RSL.STOPFLG IS NULL                "
    
    strStmt = strStmt & vbLf & strStmt2
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    'オブジェクトの参照設定
    Set objFields = objOraDyna.Fields
    
    '計算に必要な検査項目がそろっていない
    If objFields("RSLCNT").Value <> SDI_RSLCNT Then
        'トランザクションをコミット
        mobjContext.SetComplete
'MsgBox "検査項目が足りない=> " & objFields("RSLCNT").Value
        Exit Function
    End If
    
    ' 検査結果毎のSDI算出用基礎データを取得する
    strStmt = "SELECT RSLVIEW.RESULT,            " & vbLf & _
              "       RSLVIEW.ITEMCD,            " & vbLf & _
              "       RSLVIEW.SUFFIX,            " & vbLf & _
              "       FREE.FREEFIELD1 METHODNO,  " & vbLf & _
              "       FREE.FREEFIELD2 AVERAGE,   " & vbLf & _
              "       FREE.FREEFIELD3 DEVIATION, " & vbLf & _
              "       FREE.FREEFIELD4 CAN1,      " & vbLf & _
              "       FREE.FREEFIELD5 CAN2       " & vbLf & _
              "  FROM FREE,                      " & vbLf & _
              "       (                          "
    ' 年齢
    strStmt = strStmt & vbLf & _
              "       (SELECT NULL ITEMCD, NULL SUFFIX,      " & vbLf & _
              "               TO_CHAR(CONSULT.AGE) RESULT,   " & vbLf & _
              "               PERSON.GENDER                  " & vbLf & _
              "          FROM CONSULT, PERSON                " & vbLf & _
              "         WHERE CONSULT.RSVNO   = :RSVNO       " & vbLf & _
              "           AND CONSULT.PERID   = PERSON.PERID " & vbLf & _
              "       ) UNION                                "
    ' 検査結果取得
    strStmt = strStmt & vbLf & _
              "       (SELECT RSL.ITEMCD, RSL.SUFFIX,            " & vbLf & _
              "               RSL.RESULT,                        " & vbLf & _
              "               PERSON.GENDER                      " & vbLf & _
              "          FROM RSL, CONSULT, GRP_I, PERSON        "
              
    strStmt = strStmt & vbLf & strStmt2

     
    strStmt = strStmt & vbLf & _
              "           AND CONSULT.PERID   = PERSON.PERID     " & vbLf & _
              "        ) ) RSLVIEW                               " & vbLf & _
              " WHERE FREE.FREECD = 'SDI' || RSLVIEW.ITEMCD || RSLVIEW.SUFFIX || RSLVIEW.GENDER "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objResult = objFields("RESULT")
        Set objMethodNo = objFields("METHODNO")
        Set objAverage = objFields("AVERAGE")
        Set objDeviation = objFields("DEVIATION")
        Set objCan1 = objFields("CAN1")
        Set objCan2 = objFields("CAN2")

                
        Do Until objOraDyna.EOF
            
            dblResult = CDbl(objResult.Value & "")
            lngMethodNo = CLng(objMethodNo.Value & "")
            dblAverage = CDbl(objAverage.Value & "")
            dblDeviation = CDbl(objDeviation.Value & "")
            dblCan1 = CDbl(objCan1.Value & "")
            dblCan2 = CDbl(objCan2.Value & "")
 
'MsgBox objItemCd.Value & " " & _
       objSuffix.Value & " " & _
       dblResult & " " & _
       lngMethodNo & " " & _
       dblAverage & " " & _
       dblDeviation & " " & _
       dblCan1 & " " & _
       dblCan2
       
            '変換方法
            Select Case lngMethodNo
            Case 0
                dblConvert = dblResult
            Case 1
                dblConvert = Log(dblResult) / Log(10)
            Case 2
                dblConvert = dblResult * dblResult
            Case 3
                dblConvert = dblResult * dblResult * dblResult
            Case 4
                dblConvert = dblResult ^ (1 / 2)
            Case 5
                dblConvert = dblResult ^ (1 / 3)
            Case 6
                dblConvert = dblResult ^ (1 / 4)
            Case Else
                dblConvert = dblResult
            End Select
            
            dblSDI = (dblConvert - dblAverage) / dblDeviation
            
            dblValueX = dblValueX + (dblSDI * dblCan1)
            dblValueY = dblValueY + (dblSDI * dblCan2)
'MsgBox dblValueX & " " & dblValueY
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntValueX = dblValueX
        vntValueY = dblValueY
        StatisticsCalc = True
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    StatisticsCalc = False

    'イベントログ書き込み
    WriteErrorLog "Interview.StatisticsCalc"
    
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

'#### 2003.12.22 病歴情報用　追加　by FFCS
'
' 機能　　 : 指定検索条件の入院・外来歴を取得する。
'
'
' 引数　　 : (In)     lngRsvNo              検索条件：予約番号
' 　　　　   (Out)    vntKbn                入外区分（1:外来、2:入院）
' 　　　　   (Out)    vntCslDate            来院日
' 　　　　   (Out)    vntDeptName           科名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectPatientHistory( _
        ByVal lngRsvNo As Long, _
        ByRef vntKbn As Variant, _
        ByRef vntCslDate As Variant, _
        ByRef vntDeptName As Variant _
) As Long

    Dim objOraParam           As OraParameters  'OraParametersオブジェクト
    Dim objOraDyna            As OraDynaset     'ダイナセット
    Dim strStmt               As String         'SQLステートメント
    
    Dim objFields             As OraFields      'フィールドオブジェクト

    Dim objKbn                As OraField     '入外区分
    Dim objCslDate            As OraField     '来院日
    Dim objDeptName           As OraField     '科名

    Dim vntArrKbn()           As Variant     '入外区分の配列
    Dim vntArrCslDate()       As Variant     '来院日の配列
    Dim vntArrDeptName()      As Variant     '科名の配列
    
    Dim lngCount              As Long           'レコード数
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntKbn) Then vntKbn = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntDeptName) Then vntDeptName = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = "SELECT PATIENTVIEW.KBN,                           " & vbLf & _
              "       PATIENTVIEW.CSLDATE, PATIENTVIEW.DEPTNAME  " & vbLf & _
              "  FROM (                                          "
    '外来歴
    strStmt = strStmt & vbLf & _
             "       (SELECT 1 KBN,                                                               " & vbLf & _
              "            OUTPATIENT.CSLDATE,                                                    " & vbLf & _
              "               NVL( SMILEDEPT.DEPTNAME, OUTPATIENT.DEPTCD) DEPTNAME                " & vbLf & _
              "          FROM OUTPATIENT, SMILEDEPT                                               " & vbLf & _
              "         WHERE OUTPATIENT.PERID = (SELECT PERID FROM CONSULT WHERE RSVNO = :RSVNO) " & vbLf & _
              "           AND SMILEDEPT.DEPTCD(+) = OUTPATIENT.DEPTCD                             " & vbLf & _
              "    ) UNION                                                                        "
    '入院歴
    strStmt = strStmt & vbLf & _
              "    (SELECT 2 KBN,                                                                 " & vbLf & _
              "            INPATIENT.INDATE CSLDATE,                                              " & vbLf & _
              "               NVL( SMILEDEPT.DEPTNAME, INPATIENT.DEPTCD) DEPTNAME                 " & vbLf & _
              "       FROM INPATIENT,  SMILEDEPT                                                  " & vbLf & _
              "         WHERE INPATIENT.PERID = (SELECT PERID FROM CONSULT WHERE RSVNO = :RSVNO)  " & vbLf & _
              "           AND SMILEDEPT.DEPTCD(+) = INPATIENT.DEPTCD                              " & vbLf & _
              "       )                                                                           " & vbLf & _
              "       ) PATIENTVIEW                                                               "
    '新しい順
    strStmt = strStmt & vbLf & _
              " ORDER BY PATIENTVIEW.CSLDATE DESC "
       
    'データ取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    lngCount = 0
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objKbn = objFields("KBN")
        Set objCslDate = objFields("CSLDATE")
        Set objDeptName = objFields("DEPTNAME")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrKbn(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrDeptName(lngCount)
            
            vntArrKbn(lngCount) = objKbn.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrDeptName(lngCount) = objDeptName.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    SelectPatientHistory = lngCount
    
    '戻り値の設定
    If Not IsMissing(vntKbn) Then vntKbn = vntArrKbn
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntDeptName) Then vntDeptName = vntArrDeptName
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPatientHistory = -1
    
    'イベントログ書き込み
    WriteErrorLog "Interview.SelectPatientHistory"
    
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

'#### 2003.12.22 病歴情報用　追加　by FFCS
'
' 機能　　 : 指定検索条件の病歴を取得する。
'
'
' 引数　　 : (In)     lngRsvNo              検索条件：予約番号
' 　　　　   (Out)    vntInDate             入院日
' 　　　　   (Out)    vntDisName            病名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectDiseaseHistory( _
        ByVal lngRsvNo As Long, _
        ByRef vntInDate As Variant, _
        ByRef vntDisName As Variant _
) As Long

    Dim objOraParam           As OraParameters  'OraParametersオブジェクト
    Dim objOraDyna            As OraDynaset     'ダイナセット
    Dim strStmt               As String         'SQLステートメント
    
    Dim objFields             As OraFields      'フィールドオブジェクト

    Dim objInDate             As OraField     '入院日
    Dim objDisName            As OraField     '病名

    Dim vntArrInDate()        As Variant     '入院日の配列
    Dim vntArrDisName()       As Variant     '病名の配列
    
    Dim lngCount              As Long           'レコード数
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntInDate) Then vntInDate = Empty
    If Not IsMissing(vntDisName) Then vntDisName = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = "SELECT INPATIENT.INDATE,                                                  " & vbLf & _
              "       NVL( DISEASE.DISNAME, INPATIENT.DISCD) DISNAME                     " & vbLf & _
              "  FROM INPATIENT,  DISEASE                                                " & vbLf & _
              " WHERE INPATIENT.PERID = (SELECT PERID FROM CONSULT WHERE RSVNO = :RSVNO) " & vbLf & _
              "   AND DISEASE.DISCD(+) = INPATIENT.DISCD                                 " & vbLf & _
              " ORDER BY INPATIENT.INDATE DESC "
       
    'データ取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    lngCount = 0
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objInDate = objFields("INDATE")
        Set objDisName = objFields("DISNAME")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrInDate(lngCount)
            ReDim Preserve vntArrDisName(lngCount)
            
            vntArrInDate(lngCount) = objInDate.Value & ""
            vntArrDisName(lngCount) = objDisName.Value & ""
 
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    SelectDiseaseHistory = lngCount
    
    '戻り値の設定
    If Not IsMissing(vntInDate) Then vntInDate = vntArrInDate
    If Not IsMissing(vntDisName) Then vntDisName = vntArrDisName
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectDiseaseHistory = -1
    
    'イベントログ書き込み
    WriteErrorLog "Interview.SelectDiseaseHistory"
    
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

'#### 2010.07.23 SL-UI-Y0101-101 ADD START ####　総合コメント並び替え関数追加'
'
' 機能　　 : 総合判定コメントの並び替え（ＳＥＱ再設定）
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (In)     lngDispMode         表示分類
' 戻り値　 : True     正常終了
' 　　　　 : False    異常終了
'
' 備考　　 :
'
Public Function fncSortTotalJudCmt(ByVal lngRsvNo As Long _
                                 , ByVal lngDispMode As Long _
                                ) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim blnRet      As Boolean

On Error GoTo ErrorProc

    blnRet = False

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISPMODE", lngDispMode, ORAPARM_INPUT, ORATYPE_NUMBER

    '並び替え実行
    mobjOraDb.ExecuteSQL "BEGIN :RET := SpecialJudCalcPackage.SortTotalJudCmt(:RSVNO, :DISPMODE); END;"

    blnRet = True

ExitProc:

    If Err.Number <> 0 Then
        Err.Clear
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    fncSortTotalJudCmt = blnRet

    Exit Function

ErrorProc:
    blnRet = False

    GoTo ExitProc

End Function
'#### 2010.07.23 SL-UI-Y0101-101 ADD END ####'

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
