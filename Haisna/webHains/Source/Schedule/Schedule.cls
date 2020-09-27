VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Schedule"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.2.25
'担当者  ：T.Takagi@RD
'修正内容：オープン枠予約群を追加

Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 予約枠を削除する際の、予約の存在チェックを行う
'
' 引数　　 : (In)   strDate             チェック対象日付
' 　　　　 : (In)   lngTimeFra          時間枠
' 　　　　 : (In)   strRsvFraCd         予約枠コード
' 　　　　 : (In)   lngFraType          枠管理タイプ
'
' 戻り値　 : 予約が存在する場合、メッセージを返す
'
' 備考　　 :
'
Private Function CheckDeleteSchedule(ByVal strDate As String, _
                                     ByVal lngTimeFra As Long, _
                                     ByVal strRsvFraCd As String, _
                                     ByVal lngFraType As Long _
                                    ) As String
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCount        As OraField         'カウント
    
    Dim lngCount1       As Long             'カウント
    Dim lngCount2       As Long             'カウント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    CheckDeleteSchedule = ""
    lngCount1 = 0
    lngCount2 = 0
    
    '条件が設定されていない場合はエラー
    If Not IsDate(Trim(strDate)) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If Trim(strRsvFraCd) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If lngFraType <> FRA_TYPE_CS And _
       lngFraType <> FRA_TYPE_ITEM Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Trim(strDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TIMEFRA", lngTimeFra, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVFRACD", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USED", CONSULT_USED, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'コース枠管理の場合
    If lngFraType = FRA_TYPE_CS Then
    
        '検索条件を満たす受診情報のレコード件数を取得
        strStmt = "SELECT COUNT(*) RECCOUNT         " & vbLf & _
                  "  FROM CONSULT csl, RSVFRA_C rfc " & vbLf & _
                  " WHERE csl.CSLDATE   = :CSLDATE  " & vbLf & _
                  "   AND csl.TIMEFRA   = :TIMEFRA  " & vbLf & _
                  "   AND csl.CANCELFLG = :USED     " & vbLf & _
                  "   AND csl.CSCD      = rfc.CSCD  " & vbLf & _
                  "   AND rfc.RSVFRACD  = :RSVFRACD "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
        '検索レコードが存在する場合
        '(COUNT関数を発行しているので必ず1レコード返ってくる)
        If Not objOraDyna.EOF Then
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objCount = objFields("RECCOUNT")
            'レコード件数の取得
            lngCount1 = CLng(objCount.Value & "")
        End If
    
        Set objOraDyna = Nothing
    
        '検索条件を満たす団体予約人数のレコード件数を取得
        strStmt = "SELECT COUNT(*) RECCOUNT        " & vbLf & _
                  "  FROM ORGRSV ors, RSVFRA_C rfc " & vbLf & _
                  " WHERE ors.CSLDATE  = :CSLDATE  " & vbLf & _
                  "   AND ors.TIMEFRA  = :TIMEFRA  " & vbLf & _
                  "   AND ors.CSCD     = rfc.CSCD  " & vbLf & _
                  "   AND rfc.RSVFRACD = :RSVFRACD "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
        '検索レコードが存在する場合
        '(COUNT関数を発行しているので必ず1レコード返ってくる)
        If Not objOraDyna.EOF Then
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objCount = objFields("RECCOUNT")
            'レコード件数の取得
            lngCount2 = CLng(objCount.Value & "")
        End If
    
        Set objOraDyna = Nothing
    
    '検査項目枠管理の場合
    Else
    
        '検索条件を満たす予約スケジュールの予約済み人数を取得
        '（検査項目枠管理の場合、時間枠は終日固定なので、実際は１レコードしかない）
        strStmt = "SELECT NVL(SUM(RSVCOUNT), 0) RSVCOUNT " & vbLf & _
                  "  FROM SCHEDULE                       " & vbLf & _
                  " WHERE CSLDATE  = :CSLDATE            " & vbLf & _
                  "   AND RSVFRACD = :RSVFRACD           "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
        '検索レコードが存在する場合
        '(SUM関数を発行しているので必ず1レコード返ってくる)
        If Not objOraDyna.EOF Then
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objCount = objFields("RSVCOUNT")
            '予約済み人数の取得
            lngCount1 = CLng(objCount.Value & "")
        End If
    
        Set objOraDyna = Nothing
    
        '検索条件を満たす団体予約検査項目枠の予約済み人数を取得
        strStmt = "SELECT NVL(SUM(RSVCOUNT), 0) RSVCOUNT " & vbLf & _
                  "  FROM ORGRSV_IFRA                    " & vbLf & _
                  " WHERE CSLDATE  = :CSLDATE            " & vbLf & _
                  "   AND RSVFRACD = :RSVFRACD           "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
        '検索レコードが存在する場合
        '(SUM関数を発行しているので必ず1レコード返ってくる)
        If Not objOraDyna.EOF Then
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objCount = objFields("RSVCOUNT")
            '予約済み人数の取得
            lngCount2 = CLng(objCount.Value & "")
        End If
    
        Set objOraDyna = Nothing
    
    End If
    
    
'### 2003.02.05 Modified by Ishihara@FSIT あぶなっかしい削除
'    objOraParam.Remove "CSLDATE"
'    objOraParam.Remove "TIMEFRA"
'    objOraParam.Remove "RSVFRACD"
'    objOraParam.Remove "USED"
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2003.02.05 Modified End
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '予約が存在する場合、メッセージを戻り値として設定
    If lngCount2 > 0 Then
        CheckDeleteSchedule = Day(Trim(strDate)) & "日に団体予約が登録されている為、削除できません。"
    ElseIf lngCount1 > 0 Then
        CheckDeleteSchedule = Day(Trim(strDate)) & "日に予約が登録されている為、削除できません。"
    End If
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.CheckDeleteSchedule"
    
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
' 機能　　 : 休日・祝日に対する予約の存在チェックを行う
'
' 引数　　 : (In)   strDate             チェック対象日付
'
' 戻り値　 : 予約が存在する場合、メッセージを返す
'
' 備考　　 :
'
Private Function CheckHolidayReserve(ByVal strDate As String _
                                    ) As String
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCount        As OraField         '検索件数
    
    Dim lngCount1       As Long             '予約スケジュールのレコード件数
    Dim lngCount2       As Long             '受診情報のレコード件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    CheckHolidayReserve = ""
    lngCount1 = 0
    lngCount2 = 0
    
    '条件が設定されていない場合はエラー
    If Not IsDate(Trim(strDate)) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DATE1", Trim(strDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USED", CONSULT_USED, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす予約スケジュールのレコード件数を取得
    strStmt = "SELECT COUNT(*) RECCOUNT " & vbLf & _
              "  FROM SCHEDULE          " & vbLf & _
              " WHERE CSLDATE = :DATE1  "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCount = objFields("RECCOUNT")
        'レコード件数の取得
        lngCount1 = CLng(objCount.Value & "")
    End If
    
    Set objOraDyna = Nothing
    
    '検索条件を満たす受診情報のレコード件数を取得
    strStmt = "SELECT COUNT(*) RECCOUNT  " & vbLf & _
              "  FROM CONSULT            " & vbLf & _
              " WHERE CSLDATE   = :DATE1 " & vbLf & _
              "   AND CANCELFLG = :USED  "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCount = objFields("RECCOUNT")
        'レコード件数の取得
        lngCount2 = CLng(objCount.Value & "")
    End If
    
    Set objOraDyna = Nothing
    objOraParam.Remove "DATE1"
    objOraParam.Remove "USED"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '予約が存在する場合、メッセージを戻り値として設定
    If lngCount1 > 0 And lngCount2 > 0 Then
        CheckHolidayReserve = Day(Trim(strDate)) & "日に予約枠が設定され、予約が登録されています。"
    ElseIf lngCount1 > 0 And lngCount2 <= 0 Then
        CheckHolidayReserve = Day(Trim(strDate)) & "日に予約枠が設定されています。"
    ElseIf lngCount1 <= 0 And lngCount2 > 0 Then
        CheckHolidayReserve = Day(Trim(strDate)) & "日に予約が登録されています。"
    End If
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.CheckHolidayReserve"
    
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
' 機能　　 : 団体予約検査項目枠が必要か否か、チェックを行う
'
' 引数　　 : (In)   strDate             チェック対象日付
' 　　　　 : (In)   strCsCd             コースコード
' 　　　　 : (In)   strOrgCd1           団体コード1
' 　　　　 : (In)   strOrgCd2           団体コード2
' 　　　　 : (In)   strRsvFraCd         予約枠コード
'
' 戻り値　 : True   団体予約検査項目枠が必要
' 　　　　 : False  団体予約検査項目枠は不要
'
' 備考　　 :
'
Private Function CheckOrgRsv_iFra(ByVal strDate As String, _
                                  ByVal strCsCd As String, _
                                  ByVal strOrgCd1 As String, _
                                  ByVal strOrgCd2 As String, _
                                  ByVal strRsvFraCd As String _
                                 ) As Boolean
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    CheckOrgRsv_iFra = False
    
    '条件が設定されていない場合はエラー
    If Not IsDate(Trim(strDate)) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If Trim(strCsCd) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If Trim(strOrgCd1) = "" Or Trim(strOrgCd2) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If Trim(strRsvFraCd) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE2", Trim(strDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD2", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD12", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD22", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVFRACD2", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす団体検査項目リストビューのレコードを取得
    strStmt = "SELECT DISTINCT lst.ITEMCD                                    " & vbLf & _
              "  FROM ORGCONSULTITEMLIST lst, RSVFRA_I rfi                   " & vbLf & _
              " WHERE TO_DATE(:CSLDATE2) BETWEEN lst.STRDATE AND lst.ENDDATE " & vbLf & _
              "   AND lst.CSCD     = :CSCD2                                  " & vbLf & _
              "   AND lst.ORGCD1   = :ORGCD12                                " & vbLf & _
              "   AND lst.ORGCD2   = :ORGCD22                                " & vbLf & _
              "   AND lst.ITEMCD   = rfi.ITEMCD                              " & vbLf & _
              "   AND rfi.RSVFRACD = :RSVFRACD2                              "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        '戻り値の設定
        CheckOrgRsv_iFra = True
    End If
    
    Set objOraDyna = Nothing
    objOraParam.Remove "CSLDATE2"
    objOraParam.Remove "CSCD2"
    objOraParam.Remove "ORGCD12"
    objOraParam.Remove "ORGCD22"
    objOraParam.Remove "RSVFRACD2"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.CheckOrgRsv_iFra"
    
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
' 機能　　 : カレンダー表示時の入力チェック
'
' 引数　　 : (In)     strOrgCd2             団体コード１
' 　　　　 : (In)     strOrgCd2             団体コード２
' 　　　　 : (In)     strCsCd               コースコード
' 　　　　 : (In)     strPerId              個人ＩＤ
' 　　　　 : (In)     lngYear               受診希望日（年）
' 　　　　 : (In)     lngMonth              受診希望日（月）
' 　　　　 : (In)     lngDay                受診希望日（日）
' 　　　　 : (In)     strTimeFra            時間枠
' 　　　　 : (Out)    vntBirthDay           表示開始日付
' 　　　　 : (Out)    vntDate               表示終了日付
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueCalendar( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCsCd As String, _
    ByRef strPerId As Variant, _
    ByVal lngYear As String, _
    ByVal lngMonth As String, _
    ByVal lngDay As String, _
    ByRef strTimeFra As Variant, _
    ByRef vntBirthDate As Variant, _
    ByRef vntDate As Variant _
) As Variant

    Dim objCommon       As Common   '共通クラス

    Dim vntArrMessage   As Variant  'エラーメッセージの集合
    Dim strArrMessage   As String   'エラーメッセージ

    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

''必須入力チェック
    '団体コード
    If strOrgCd1 = "" Or strOrgCd2 = "" Then
        objCommon.AppendArray vntArrMessage, "団体が入力されていません。"
    End If

    'コースコード
    If strCsCd = "" Then
        objCommon.AppendArray vntArrMessage, "コースが入力されていません。"
    End If
    
    '個人ID
    If strPerId = "" Then
        objCommon.AppendArray vntArrMessage, "個人ＩＤが入力されていません。"
    End If
    
    '受診希望日
    objCommon.AppendArray vntArrMessage, objCommon.CheckDate("受診希望日", lngYear, lngMonth, lngDay, vntDate)

''受診希望日は過去日付エラー
    If Trim(vntDate) <> "" Then
        If DateValue(vntDate) < DateValue(Now) Then
            objCommon.AppendArray vntArrMessage, "受診希望日は過去日付エラーです。"
        End If
    End If
    
    'エラー確認
    If IsArray(vntArrMessage) Then
        CheckValueCalendar = vntArrMessage
    End If

    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Schedule.CheckValueCalendar"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 予約スケジューリング入力値の妥当性チェックを行う
'
' 引数　　 : (In)   strStrDate          月始日付
' 　　　　 : (In)   strEndDate          月末日付
' 　　　　 : (In)   lngTimeFra          時間枠
' 　　　　 : (In)   strRsvFraCd         予約枠コード
' 　　　　 : (In)   strArrEmptyCount    月始日付～月末日付の設定値（"hidden":非表示，"":未設定，"0":予約不可，"1"～"999":予約可能）
' 　　　　 : (Out)  vntArrWarning       警告メッセージ
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueSchedule(ByVal strStrDate As String, _
                                   ByVal strEndDate As String, _
                                   ByVal lngTimeFra As Long, _
                                   ByVal strRsvFraCd As String, _
                                   ByVal strArrEmptyCount As Variant, _
                                   ByRef vntArrWarning As Variant _
                                  ) As Variant
    
    Dim objCommon       As Common   '共通クラス
    
    Dim vntArrMessage   As Variant  'エラーメッセージの集合
    Dim vntArrMessage2  As Variant  '警告メッセージの集合
    Dim strMessage      As String   'エラーメッセージ
    Dim vntRsvFraName   As Variant  '予約枠情報（予約枠名称）
    Dim vntOverRsv      As Variant  '予約枠情報（枠人数オーバー登録）
    Dim vntFraType      As Variant  '予約枠情報（枠管理タイプ）
    Dim vntDefCnt0      As Variant  '予約枠情報（デフォルト人数（時間帯枠０））
    Dim vntDefCnt1      As Variant  '予約枠情報（デフォルト人数（時間帯枠１））
    Dim vntDefCnt2      As Variant  '予約枠情報（デフォルト人数（時間帯枠２））
    Dim vntDefCnt3      As Variant  '予約枠情報（デフォルト人数（時間帯枠３））
    Dim vntDefCnt4      As Variant  '予約枠情報（デフォルト人数（時間帯枠４））
    Dim vntDefCnt5      As Variant  '予約枠情報（デフォルト人数（時間帯枠５））
    Dim vntDefCnt6      As Variant  '予約枠情報（デフォルト人数（時間帯枠６））
    Dim vntDefCnt7      As Variant  '予約枠情報（デフォルト人数（時間帯枠７））
    Dim vntDefCnt8      As Variant  '予約枠情報（デフォルト人数（時間帯枠８））
    Dim vntDefCnt9      As Variant  '予約枠情報（デフォルト人数（時間帯枠９））
    Dim vntCslDate      As Variant  '予約スケジューリング情報（受診日）
    Dim vntTimeFra      As Variant  '予約スケジューリング情報（時間枠）
    Dim vntRsvFraCd     As Variant  '予約スケジューリング情報（予約枠コード）
    Dim vntEmptyCount   As Variant  '予約スケジューリング情報（予約可能人数）
    Dim vntRsvCount     As Variant  '予約スケジューリング情報（予約済み人数）
    Dim strRsvCount     As String   '予約済み人数（"":レコードなし，"0"～"999":設定値）
    Dim lngRsvCount     As Long     '予約済み人数（カウント値）
    Dim strCheckType    As String   '時間枠管理されているか否かの判定（"":未設定，"0":終日管理，"1":時間枠管理）
    Dim strEditDate     As String   '日付編集用
    Dim lngCount        As Long     'レコード数
    Dim Ret             As Boolean  'リターンコード
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
    '初期処理
    vntArrWarning = Empty
    CheckValueSchedule = Empty
    vntArrMessage = Empty
    vntArrMessage2 = Empty
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    Do
        '各値チェック処理
        With objCommon
    
            '月始日付
            If Not IsDate(Trim(strStrDate)) Then
                .AppendArray vntArrMessage, "月始日付が不正です。"
            End If
    
            '月末日付
            If Not IsDate(Trim(strEndDate)) Then
                .AppendArray vntArrMessage, "月末日付が不正です。"
            End If
    
            '設定値の配列
            If Not IsArray(strArrEmptyCount) Then
                .AppendArray vntArrMessage, "設定値の配列が不正です。"
            End If
    
            '月始／月末日付と設定値の配列の妥当性
            If IsDate(Trim(strStrDate)) And IsDate(Trim(strEndDate)) And IsArray(strArrEmptyCount) Then
                If DateDiff("d", CDate((Trim(strStrDate))), CDate((Trim(strEndDate)))) <> UBound(strArrEmptyCount) Then
                    .AppendArray vntArrMessage, "月始／月末日付に対する設定値の配列の数が矛盾しています。"
                End If
            End If
    
            '指定予約枠コードの予約枠情報を取得
            Ret = SelectRsvFra(Trim(strRsvFraCd), vntRsvFraName, vntOverRsv, vntFraType, vntDefCnt0, vntDefCnt1, vntDefCnt2, vntDefCnt3, vntDefCnt4, vntDefCnt5, vntDefCnt6, vntDefCnt7, vntDefCnt8, vntDefCnt9)
            If Ret <> True Then
                .AppendArray vntArrMessage, "予約枠コードが不正です。"
            End If
    
        End With
    
        'エラーがある時、以降のチェックは不要
        If IsArray(vntArrMessage) Then
            Exit Do
        End If
    
        '各値チェック処理
        With objCommon
    
            '指定期間の該当予約枠コードの予約スケジューリング情報を取得（時間枠の指定はせず、すべての時間枠を抽出）
            lngCount = SelectSchedule(Trim(strStrDate), Trim(strEndDate), "", Trim(strRsvFraCd), vntCslDate, vntTimeFra, vntRsvFraCd, vntEmptyCount, vntRsvCount)
    
            'チェック対象日付
            strEditDate = Trim(strStrDate)
    
            '１日ごとにチェック
            j = 0
            For i = 0 To UBound(strArrEmptyCount)
    
                'その日の予約スケジューリングの設定を把握する
                strRsvCount = ""
                strCheckType = ""
                If j < lngCount Then
                    Do While DateValue(vntCslDate(j)) = DateValue(CStr(Year(Trim(strStrDate))) & "/" & CStr(Month(Trim(strStrDate))) & "/" & CStr(i + 1))
                        '該当時間枠の予約済み人数設定値
                        If vntTimeFra(j) = lngTimeFra Then
                            strRsvCount = vntRsvCount(j)
                        End If
                        '時間枠管理されているか否かの判定
                        If vntTimeFra(j) = TIME_FRA_NON Then
                            strCheckType = "0"
                        Else
                            strCheckType = "1"
                        End If
                        j = j + 1
                        If j >= lngCount Then
                            Exit Do
                        End If
                    Loop
                End If
    
                '終日の入力時、時間枠管理されている場合、非表示以外はエラー
                If lngTimeFra = TIME_FRA_NON And strCheckType = "1" And Trim(strArrEmptyCount(i)) <> "hidden" Then
                    .AppendArray vntArrMessage, CStr(i + 1) & "日に時間枠管理の予約枠がすでに設定されています。終日管理できません。もう一度やり直して下さい。"
                End If
    
                '指定時間枠の入力時、終日管理されている場合、非表示以外はエラー
                If lngTimeFra <> TIME_FRA_NON And strCheckType = "0" And Trim(strArrEmptyCount(i)) <> "hidden" Then
                    .AppendArray vntArrMessage, CStr(i + 1) & "日に終日管理の予約枠がすでに設定されています。時間枠管理できません。もう一度やり直して下さい。"
                End If
    
                '非表示，未設定でない時、数値（０～９９９）以外エラー
                If Trim(strArrEmptyCount(i)) <> "hidden" And _
                   Trim(strArrEmptyCount(i)) <> "" Then
                    strMessage = .CheckNumeric((CStr(i + 1) & "日"), Trim(strArrEmptyCount(i)), LENGTH_SCHEDULE_EMPTYCOUNT)
                    If strMessage <> "" Then
                        .AppendArray vntArrMessage, strMessage
                    End If
                End If
    
                '削除時のチェック
                If Trim(strArrEmptyCount(i)) = "" Then
'### 2002.05.27 Modified by Ishihara@FSIT 削除時は無条件で削除させる
'                    .AppendArray vntArrMessage, CheckDeleteSchedule(strEditDate, lngTimeFra, Trim(strRsvFraCd), CLng(vntFraType))
                    .AppendArray vntArrMessage, ""
'### 2002.05.27 Modified End
                End If
    
                '保存時のチェック（数値チェックＯＫの時のみ）
                If Trim(strArrEmptyCount(i)) <> "hidden" And Trim(strArrEmptyCount(i)) <> "" And strMessage = "" Then
    
                    '該当日に予約枠データが一切なく、終日以外の時間枠を登録する際、すでに予約が登録されていればエラー
                    '（予約枠データが一切ない時点で登録された予約は、時間枠が終日で登録されている）
                    If strCheckType = "" And lngTimeFra <> TIME_FRA_NON And CheckDeleteSchedule(strEditDate, TIME_FRA_NON, Trim(strRsvFraCd), CLng(vntFraType)) <> "" Then
                        
                        .AppendArray vntArrMessage, CStr(i + 1) & "日に終日管理の予約がすでに登録されています。時間枠管理では設定できません。"
    
'## 2003.01.16 Del 22Lines By T.Takagi@FSIT 東急対応(この部分は更新後コミット前に実施するよう変更。本ロジックではサブコース枠に対応できない。)
'                    '以外の時
'                    Else
'
'                        'すでに登録されている予約済み人数をカウント（団体枠もカウントするモード）
'                        lngRsvCount = GetRsvCount(strEditDate, lngTimeFra, Trim(strRsvFraCd), CLng(vntFraType), True)
'
'                        '予約可能人数が予約済み人数を下回る場合
'                        If CLng(Trim(strArrEmptyCount(i))) < lngRsvCount Then
'                            '枠を越えた人数の予約を許さない設定の場合
'                            If CLng(vntOverRsv) = OVER_RSV_DENY Then
'                                '新規挿入時
'                                If strRsvCount = "" Then
'                                    .AppendArray vntArrMessage, CStr(i + 1) & "日にすでに" & CStr(lngRsvCount) & "人の予約が登録されています。指定内容で設定できません。"
'                                '更新時
'                                Else
'                                    .AppendArray vntArrMessage, CStr(i + 1) & "日にすでに" & CStr(lngRsvCount) & "人の予約が登録されています。指定内容には変更できません。"
'                                End If
'                            '枠を越えた人数の予約を許す設定の場合
'                            Else
'                                .AppendArray vntArrMessage2, CStr(i + 1) & "日にすでに" & CStr(lngRsvCount) & "人の予約が登録されています。"
'                            End If
'                        End If
'## 2003.01.16 Del End
    
                    End If
                
                End If
    
                'チェック対象日付を１日進める
                strEditDate = Format(DateAdd("d", 1, strEditDate), "yyyy/m/d")
    
            Next i
    
            '警告メッセージの編集
            If IsArray(vntArrMessage2) Then
                vntArrWarning = vntArrMessage2
            End If
    
        End With
    
        Exit Do
    Loop
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueSchedule = vntArrMessage
    End If
    
    Set objCommon = Nothing
    
End Function

'
' 機能　　 : 病院スケジューリング入力値の妥当性チェックを行う
'
' 引数　　 : (In)   strStrDate          月始日付
' 　　　　 : (In)   strEndDate          月末日付
' 　　　　 : (In)   lngArrHoliday       月始日付～月末日付の設定値（0:未設定，1:休診日，2:祝日）
' 　　　　 : (Out)  vntArrWarning       警告メッセージ
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueSchedule_h(ByVal strStrDate As String, _
                                     ByVal strEndDate As String, _
                                     ByVal lngArrHoliday As Variant, _
                                     ByRef vntArrWarning As Variant _
                                    ) As Variant
    
    Dim objCommon       As Common   '共通クラス
    
    Dim vntArrMessage   As Variant  'エラーメッセージの集合
    Dim vntArrMessage2  As Variant  '警告メッセージの集合
    Dim strHolidayFlg   As String   '休日・祝日に対する予約の許可
    Dim strEditDate     As String   '日付編集用
    Dim i               As Long     'インデックス
    
    '初期処理
    vntArrWarning = Empty
    CheckValueSchedule_h = Empty
    vntArrMessage = Empty
    vntArrMessage2 = Empty
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    Do
        '各値チェック処理
        With objCommon
    
            '月始日付
            If Not IsDate(Trim(strStrDate)) Then
                .AppendArray vntArrMessage, "月始日付が不正です。"
            End If
    
            '月末日付
            If Not IsDate(Trim(strEndDate)) Then
                .AppendArray vntArrMessage, "月末日付が不正です。"
            End If
    
            '設定値の配列
            If Not IsArray(lngArrHoliday) Then
                .AppendArray vntArrMessage, "設定値の配列が不正です。"
            End If
    
            '月始／月末日付と設定値の配列の妥当性
            If IsDate(Trim(strStrDate)) And IsDate(Trim(strEndDate)) And IsArray(lngArrHoliday) Then
                If DateDiff("d", CDate((Trim(strStrDate))), CDate((Trim(strEndDate)))) <> UBound(lngArrHoliday) Then
                    .AppendArray vntArrMessage, "月始／月末日付に対する設定値の配列の数が矛盾しています。"
                End If
            End If
    
        End With
    
        'エラーがある時、以降のチェックは不要
        If IsArray(vntArrMessage) Then
            Exit Do
        End If
    
        '各値チェック処理
        With objCommon
    
            'iniファイル読み込み（休日・祝日に対する予約の許可）
            strHolidayFlg = .SelectHolidayFlg
    
            'チェック対象日付
            strEditDate = Trim(strStrDate)
    
            '１日ごとにチェック
            For i = 0 To UBound(lngArrHoliday)
    
                'ＶＡＬＵＥチェック（０，１，２以外エラー）
                If lngArrHoliday(i) <> HOLIDAY_NON And _
                   lngArrHoliday(i) <> HOLIDAY_CLS And _
                   lngArrHoliday(i) <> HOLIDAY_HOL Then
                    .AppendArray vntArrMessage, CStr(i + 1) & "日の設定値が不正です。"
                End If
    
                '休日・祝日に対する予約チェック
                If lngArrHoliday(i) = HOLIDAY_CLS Or _
                   lngArrHoliday(i) = HOLIDAY_HOL Then
                    '休日・祝日に対する予約を許さない設定の場合
                    If strHolidayFlg = HOLIDAYFLG_DENY Then
                        .AppendArray vntArrMessage, CheckHolidayReserve(strEditDate)
                    '休日・祝日に対する予約を許す設定の場合
                    Else
                        .AppendArray vntArrMessage2, CheckHolidayReserve(strEditDate)
                    End If
                End If
    
                'チェック対象日付を１日進める
                strEditDate = Format(DateAdd("d", 1, strEditDate), "yyyy/m/d")
    
            Next i
    
            '警告メッセージの編集
            If IsArray(vntArrMessage2) Then
                vntArrWarning = vntArrMessage2
            End If
    
        End With
    
        Exit Do
    Loop
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueSchedule_h = vntArrMessage
    End If
    
    Set objCommon = Nothing
    
End Function

'
' 機能　　 : 空き状況の入力チェック（Step1～Step2）
'
' 引数　　 : (In)     strOrgCd2             団体コード１
' 　　　　 : (In)     strOrgCd2             団体コード２
' 　　　　 : (In)     strCsCd               コースコード
' 　　　　 : (In)     strGender             性別
' 　　　　 : (In)     lngBirthYear          生年月日（年）
' 　　　　 : (In)     lngBirthMonth         生年月日（月）
' 　　　　 : (In)     lngBirthDay           生年月日（日）
' 　　　　 : (In)     strPerId              個人ＩＤ
' 　　　　 : (In)     lngYear               受診希望日（年）
' 　　　　 : (In)     lngMonth              受診希望日（月）
' 　　　　 : (In)     lngDay                受診希望日（日）
' 　　　　 : (In)     strTimeFra            時間枠
' 　　　　 : (Out)    vntBirthDay           表示開始日付
' 　　　　 : (Out)    vntDate               表示終了日付
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueSearchStep1(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal strCsCd As String, ByVal strGender As String, _
                                    ByVal lngBirthYear As String, ByVal lngBirthMonth As String, ByVal lngBirthDay As String, _
                                    ByRef strPerId As Variant, _
                                    ByVal lngYear As String, ByVal lngMonth As String, ByVal lngDay As String, _
                                    ByRef strTimeFra As Variant, _
                                    ByRef vntBirthDate As Variant, ByRef vntDate As Variant _
                                    ) As Variant

    Dim objCommon       As Common   '共通クラス

    Dim vntArrMessage   As Variant  'エラーメッセージの集合
    Dim strArrMessage   As String   'エラーメッセージ

    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

''必須入力チェック
    '団体コード
    If strOrgCd1 = "" Or strOrgCd2 = "" Then
        objCommon.AppendArray vntArrMessage, "団体が入力されていません。"
    End If

    'コースコード
    If strCsCd = "" Then
        objCommon.AppendArray vntArrMessage, "コースが入力されていません。"
    End If
    
    '個人IDが入力されていない場合は　性別、生年月日　が入力されている
    If strPerId = "" Then
        If strGender = "" Then
            objCommon.AppendArray vntArrMessage, "性別が入力されていません。"
        End If
        
        objCommon.AppendArray vntArrMessage, objCommon.CheckDate("生年月日", lngBirthYear, lngBirthMonth, lngBirthDay, vntBirthDate, CHECK_NECESSARY)
'    Else
'        objCommon.AppendArray vntArrMessage, "個人ＩＤが入力されていません。"
    End If
    
    '受診希望日
    objCommon.AppendArray vntArrMessage, objCommon.CheckDate("受診希望日", lngYear, lngMonth, lngDay, vntDate, CHECK_NECESSARY)

''受診希望日は過去日付エラー
    If Trim(vntDate) <> "" Then
        If DateValue(vntDate) < DateValue(Now) Then
            objCommon.AppendArray vntArrMessage, "受診希望日は過去日付エラーです。"
        End If
    End If
    
    'エラー確認
    If IsArray(vntArrMessage) Then
        CheckValueSearchStep1 = vntArrMessage
    End If

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Schedule.CheckValueSearchStep1"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 予約枠テーブルレコードを削除する
'
' 引数　　 : (In)    strRsvFraCd    予約枠コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteRsvFra(ByVal strRsvFraCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVFRACD", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '予約枠テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE RSVFRA_P WHERE RSVFRACD = :RSVFRACD"
    
    'バインド変数の削除
    objOraParam.Remove "RSVFRACD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteRsvFra = True

    Exit Function
    
ErrorHandle:

    DeleteRsvFra = False

    'イベントログ書き込み
    WriteErrorLog "Schedule.DeleteRsvFra"
    
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
' 機能　　 : 予約群テーブルレコードを削除する
'
' 引数　　 : (In)    strRsvGrpCd    予約枠コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteRsvGrp(ByVal strRsvGrpCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVGRPCD", Trim(strRsvGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '予約群テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE RSVGRP WHERE RSVGRPCD = :RSVGRPCD"
    
    'バインド変数の削除
    objOraParam.Remove "RSVGRPCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteRsvGrp = True

    Exit Function
    
ErrorHandle:

    DeleteRsvGrp = False

    'イベントログ書き込み
    WriteErrorLog "Schedule.DeleteRsvGrp"
    
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

'## 2004.03.11 Add By T.Takagi@FSIT 枠コピー機能
'
' 機能　　 : 予約人数管理情報のコピーを行う
'
' 引数　　 : (In)     dtmCslDate     コピー元受診日
' 　　　　   (In)     strCsCd        コピー元コースコード
' 　　　　   (In)     strRsvGrpCd    コピー元予約群コード
' 　　　　   (In)     dtmStrCslDate  コピー先開始受診日
' 　　　　   (In)     dtmEndCslDate  コピー先終了受診日
' 　　　　   (In)     vntArrWeekday  コピー先受診日範囲において対象となる曜日の配列(添字の０番目から月、火、･･･の順。各要素値がvbNullString値以外の場合に対象)
' 　　　　   (In)     blnUpdate      True指定時、コピー先受診日に同一キーの予約人数情報が存在する場合は上書きする
'
' 戻り値　 : 作成／更新レコード数
'
' 備考　　 :
'
Public Function CopyRsvFraMng( _
    ByVal dtmCslDate As Date, _
    ByVal strCsCd As String, _
    ByVal strRsvGrpCd As String, _
    ByVal dtmStrCslDate As String, _
    ByVal dtmEndCslDate As String, _
    ByVal vntArrWeekday As Variant, _
    ByVal blnUpdate As Boolean _
) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim objNewCslDate   As OraParameter     'コピー先受診日
    Dim strStmt         As String           'SQLステートメント
    Dim strBasedStmt    As String           '枠コピー用基本表SQLステートメント

    Dim dtmWkCslDate    As Date             '受診日
    Dim blnAct          As Boolean          'コピー実施要否
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '開始、終了受診日の大小が逆転している場合は値を交換する
    If dtmStrCslDate > dtmEndCslDate Then
        dtmWkCslDate = dtmStrCslDate
        dtmStrCslDate = dtmEndCslDate
        dtmEndCslDate = dtmWkCslDate
    End If
    
    'バインド変数の定義
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", IIf(strCsCd <> "", strCsCd, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", IIf(strRsvGrpCd <> "", CLng("0" & strRsvGrpCd), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NEWCSLDATE", Null, ORAPARM_INPUT, ORATYPE_DATE
    
    'オブジェクトの参照設定
    Set objNewCslDate = objOraParam("NEWCSLDATE")
    
    '枠コピー用基本表SQLの編集
    strBasedStmt = _
              "SELECT :NEWCSLDATE CSLDATE,                                         " & vbLf & _
              "       RSVFRAMNG.CSCD,    RSVFRAMNG.RSVGRPCD,                       " & vbLf & _
              "       RSVFRAMNG.MAXCNT,  RSVFRAMNG.MAXCNT_M,  RSVFRAMNG.MAXCNT_F,  " & vbLf & _
              "       RSVFRAMNG.OVERCNT, RSVFRAMNG.OVERCNT_M, RSVFRAMNG.OVERCNT_F, "
              
    'webHains本体とweb予約からそれぞれ求まる、コピー先受診日の予約人数を合算(存在しない場合は０とする)
    strBasedStmt = strBasedStmt & vbLf & _
              "       NVL(REALRSVFRAMNG.RSVCNT_M, 0) + NVL(WEB_RSVFRAMNG.RSVCNT_M, 0) RSVCNT_M, " & vbLf & _
              "       NVL(REALRSVFRAMNG.RSVCNT_F, 0) + NVL(WEB_RSVFRAMNG.RSVCNT_F, 0) RSVCNT_F  "

    'コピー先受診日のweb予約から得られる予約人数情報
    strBasedStmt = strBasedStmt & vbLf & _
              "  FROM ( SELECT WEB_RSVFRAMNG.CSLDATE, WEB_RSVFRAMNG.CSCD, WEB_RSVFRAMNG.RSVGRPCD, "

    'NULL値がカウントされない性質を利用し、性別による振り分けを行う
'#### 2013.2.28 SL-SN-Y0101-612 UPD START ####
'    strBasedStmt = strBasedStmt & vbLf & _
'              "                COUNT(DECODE(WEB_YOYAKU.SEXFLG, 1, WEB_YOYAKU.WEBNO, NULL)) RSVCNT_M, " & vbLf & _
'              "                COUNT(DECODE(WEB_YOYAKU.SEXFLG, 2, WEB_YOYAKU.WEBNO, NULL)) RSVCNT_F  " & vbLf & _
'              "           FROM HAINSNET.WEB_YOYAKU, HAINSNET.WEB_RSVFRAMNG                           " & vbLf & _
'              "          WHERE WEB_RSVFRAMNG.CSLDATE = :NEWCSLDATE                                   " & vbLf & _
'              "            AND WEB_RSVFRAMNG.WEBNO   = WEB_YOYAKU.WEBNO                              "
'
'    'webHains本体に本登録されている情報はカウントしない
'    strBasedStmt = strBasedStmt & vbLf & _
'              "            AND WEB_YOYAKU.YKBN      != 2                                            " & vbLf & _
'              "          GROUP BY WEB_RSVFRAMNG.CSLDATE, WEB_RSVFRAMNG.CSCD, WEB_RSVFRAMNG.RSVGRPCD " & vbLf & _
'              "       ) WEB_RSVFRAMNG,                                                              "
    strBasedStmt = strBasedStmt & vbLf & _
              "                COUNT(DECODE(V_WEB_YOYAKU.SEXFLG, 1, V_WEB_YOYAKU.WEBNO, NULL)) RSVCNT_M, " & vbLf & _
              "                COUNT(DECODE(V_WEB_YOYAKU.SEXFLG, 2, V_WEB_YOYAKU.WEBNO, NULL)) RSVCNT_F  " & vbLf & _
              "           FROM WEBRESERVE.V_WEB_YOYAKU, WEBRESERVE.WEB_RSVFRAMNG                         " & vbLf & _
              "          WHERE WEB_RSVFRAMNG.CSLDATE = :NEWCSLDATE                                       " & vbLf & _
              "            AND WEB_RSVFRAMNG.CSLDATE = V_WEB_YOYAKU.JDATE                                " & vbLf & _
              "            AND WEB_RSVFRAMNG.WEBNO   = V_WEB_YOYAKU.WEBNO                                "

    'webHains本体に本登録されている情報はカウントしない
    strBasedStmt = strBasedStmt & vbLf & _
              "            AND V_WEB_YOYAKU.YKBN    != 2                                            " & vbLf & _
              "          GROUP BY WEB_RSVFRAMNG.CSLDATE, WEB_RSVFRAMNG.CSCD, WEB_RSVFRAMNG.RSVGRPCD " & vbLf & _
              "       ) WEB_RSVFRAMNG,                                                              "
'#### 2013.2.28 SL-SN-Y0101-612 UPD END   ####
              
    'コピー先受診日の受診情報から得られる予約人数情報
    strBasedStmt = strBasedStmt & vbLf & _
              "       ( SELECT SUBQUERY.CSLDATE, SUBQUERY.CSCD, SUBQUERY.RSVGRPCD, "
              
    '先にUNION ALLで指定しているため、同一予約番号にて複数存在するコース、予約群に関しては重複を１つとしてカウント
    'かつNULL値がカウントされない性質を利用し、性別による振り分けを行う
    strBasedStmt = strBasedStmt & vbLf & _
              "                COUNT(DISTINCT DECODE(PERSON.GENDER, 1, SUBQUERY.RSVNO, NULL)) RSVCNT_M, " & vbLf & _
              "                COUNT(DISTINCT DECODE(PERSON.GENDER, 2, SUBQUERY.RSVNO, NULL)) RSVCNT_F  " & vbLf & _
              "           FROM PERSON,                                                                  "

    '受診情報本体から、枠管理されるコース・予約群を取得
    strBasedStmt = strBasedStmt & vbLf & _
              "                ( SELECT CONSULT.RSVNO,    CONSULT.CSLDATE, CONSULT.CSCD,     " & vbLf & _
              "                         CONSULT.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
              "                    FROM CONSULT                                              "

    '後で重複は除きつつカウントするためここではUNION ALL指定(２回ソート処理が走るのは嫌)
    strBasedStmt = strBasedStmt & vbLf & _
              "                   UNION ALL "

    'セット情報から枠管理されるコース、予約群を取得
'#### 2013.2.28 SL-SN-Y0101-612 UPD START ####
'    strBasedStmt = strBasedStmt & vbLf & _
'              "                  SELECT CONSULT.RSVNO,    CONSULT.CSLDATE, RSVFRA_C.CSCD,    " & vbLf & _
'              "                         CONSULT.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
'              "                    FROM RSVFRA_C, CTRPT_OPT, CONSULT_O, CONSULT              " & vbLf & _
'              "                   WHERE CONSULT.RSVNO         = CONSULT_O.RSVNO              " & vbLf & _
'              "                     AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD            " & vbLf & _
'              "                     AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD              " & vbLf & _
'              "                     AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO        " & vbLf & _
'              "                     AND CTRPT_OPT.RSVFRACD    = RSVFRA_C.RSVFRACD            " & vbLf & _
'              "                ) SUBQUERY                                                    "
    strBasedStmt = strBasedStmt & vbLf & _
              "                  SELECT CONSULT.RSVNO,    CONSULT.CSLDATE, RSVFRA_C.CSCD,    " & vbLf & _
              "                         CONSULT.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
              "                    FROM RSVFRA_C, CTRPT_OPT, CONSULT_O, CONSULT              " & vbLf & _
              "                   WHERE CONSULT.RSVNO         = CONSULT_O.RSVNO              " & vbLf & _
              "                     AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD            " & vbLf & _
              "                     AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD              " & vbLf & _
              "                     AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO        " & vbLf & _
              "                     AND CTRPT_OPT.RSVFRACD    = RSVFRA_C.RSVFRACD            "
              
    'ここも先と同様、UNION ALL指定
    strBasedStmt = strBasedStmt & vbLf & _
              "                   UNION ALL "
              
    'セット情報から枠管理されるコースと、そのオープン枠予約群を取得
    strBasedStmt = strBasedStmt & vbLf & _
              "                  SELECT CONSULT.RSVNO,          CONSULT.CSLDATE, RSVFRA_C.CSCD,    " & vbLf & _
              "                         OPENGRPCOURSE.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
              "                    FROM RSVFRA_C, RSVFRA_P, CTRPT_OPT, CONSULT_O, CONSULT,         "

    'コピー元の予約人数管理情報を検索し、うちオープン枠予約群検索対象であるコースと、その予約群とを取得
    strBasedStmt = strBasedStmt & vbLf & _
              "                         (SELECT RSVFRAMNG.CSCD, RSVFRAMNG.RSVGRPCD                      " & vbLf & _
              "                            FROM RSVGRP, RSVFRAMNG                                       " & vbLf & _
              "                           WHERE RSVFRAMNG.CSLDATE  = :CSLDATE                           " & vbLf & _
              "                             AND RSVFRAMNG.CSCD     = NVL(:CSCD,     RSVFRAMNG.CSCD)     " & vbLf & _
              "                             AND RSVFRAMNG.RSVGRPCD = NVL(:RSVGRPCD, RSVFRAMNG.RSVGRPCD) " & vbLf & _
              "                             AND RSVFRAMNG.RSVGRPCD = RSVGRP.RSVGRPCD                    " & vbLf & _
              "                             AND RSVGRP.ISOPENGRP   > 0                                  " & vbLf & _
              "                         ) OPENGRPCOURSE                                                       "

    strBasedStmt = strBasedStmt & vbLf & _
              "                   WHERE CONSULT.RSVNO         = CONSULT_O.RSVNO       " & vbLf & _
              "                     AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD     " & vbLf & _
              "                     AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD       " & vbLf & _
              "                     AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO "

    '予約枠テーブルを結合し、オープン枠予約群検索対象であるもののみ取得
    strBasedStmt = strBasedStmt & vbLf & _
              "                     AND CTRPT_OPT.RSVFRACD    = RSVFRA_P.RSVFRACD " & vbLf & _
              "                     AND RSVFRA_P.INCOPENGRP   > 0                 "

    'オープン枠予約群検索対象である予約枠のコースを取得
    strBasedStmt = strBasedStmt & vbLf & _
              "                     AND CTRPT_OPT.RSVFRACD    = RSVFRA_C.RSVFRACD "

    'うち、先に取得したコピー元のオープン枠予約群検索対象コースのみを取得
    strBasedStmt = strBasedStmt & vbLf & _
              "                     AND RSVFRA_C.CSCD         = OPENGRPCOURSE.CSCD "

    strBasedStmt = strBasedStmt & vbLf & _
              "                ) SUBQUERY "
'#### 2013.2.28 SL-SN-Y0101-612 UPD END   ####
              
    'ここでキャンセル者は除きつつ、かつ性別ごとの件数を取得するため個人情報を結合
    strBasedStmt = strBasedStmt & vbLf & _
              "          WHERE SUBQUERY.CSLDATE   = :NEWCSLDATE                      " & vbLf & _
              "            AND SUBQUERY.CANCELFLG = 0                                " & vbLf & _
              "            AND SUBQUERY.PERID     = PERSON.PERID                     " & vbLf & _
              "          GROUP BY SUBQUERY.CSLDATE, SUBQUERY.CSCD, SUBQUERY.RSVGRPCD " & vbLf & _
              "       ) REALRSVFRAMNG,                                               "

    'コピー元の予約枠
    strBasedStmt = strBasedStmt & vbLf & _
              "       RSVFRAMNG                                               " & vbLf & _
              " WHERE RSVFRAMNG.CSLDATE  = :CSLDATE                           " & vbLf & _
              "   AND RSVFRAMNG.CSCD     = NVL(:CSCD,     RSVFRAMNG.CSCD)     " & vbLf & _
              "   AND RSVFRAMNG.RSVGRPCD = NVL(:RSVGRPCD, RSVFRAMNG.RSVGRPCD) "
              
    'これにコピー先受診日の受診情報から得られる予約人数情報を結合(コピー先に受診情報がない場合もあり)
    strBasedStmt = strBasedStmt & vbLf & _
              "   AND RSVFRAMNG.CSCD     = REALRSVFRAMNG.CSCD(+)     " & vbLf & _
              "   AND RSVFRAMNG.RSVGRPCD = REALRSVFRAMNG.RSVGRPCD(+) "

    '更にコピー先受診日のweb予約から得られる予約人数情報を結合(コピー先にweb予約情報がない場合もあり)
    strBasedStmt = strBasedStmt & vbLf & _
              "   AND RSVFRAMNG.CSCD     = WEB_RSVFRAMNG.CSCD(+)     " & vbLf & _
              "   AND RSVFRAMNG.RSVGRPCD = WEB_RSVFRAMNG.RSVGRPCD(+) "

    'コピー先受診日に同一コース・予約群の予約人数存在時は上書きしない場合
    If Not blnUpdate Then

        'INSERT文作成開始
        strStmt = _
              "INSERT INTO RSVFRAMNG ( CSLDATE, CSCD, RSVGRPCD, MAXCNT, MAXCNT_M, MAXCNT_F, OVERCNT, OVERCNT_M, OVERCNT_F, RSVCNT_M, RSVCNT_F ) "

        '挿入するレコードの基本表は先に作成したそれ
        strStmt = strStmt & vbLf & strBasedStmt

        'これに対し、すでに存在するコピー先受診日・コース・予約群の予約人数情報を除外
        strStmt = strStmt & vbLf & _
              "   AND NOT EXISTS ( SELECT *                                               " & vbLf & _
              "                      FROM RSVFRAMNG EXISTSRSVFRAMNG                       " & vbLf & _
              "                     WHERE EXISTSRSVFRAMNG.CSLDATE  = :NEWCSLDATE          " & vbLf & _
              "                       AND EXISTSRSVFRAMNG.CSCD     = RSVFRAMNG.CSCD       " & vbLf & _
              "                       AND EXISTSRSVFRAMNG.RSVGRPCD = RSVFRAMNG.RSVGRPCD ) "

    '上書きする場合
    Else
    
        '先に作成した基本表をもとにMERGE文を作成
        strStmt = _
              "MERGE INTO RSVFRAMNG                                          " & vbLf & _
              "      USING ( " & strBasedStmt & " ) BASEDRSVFRAMNG           " & vbLf & _
              "         ON ( RSVFRAMNG.CSLDATE  = BASEDRSVFRAMNG.CSLDATE AND " & vbLf & _
              "              RSVFRAMNG.CSCD     = BASEDRSVFRAMNG.CSCD    AND " & vbLf & _
              "              RSVFRAMNG.RSVGRPCD = BASEDRSVFRAMNG.RSVGRPCD )  "
              
        'レコード存在時は上書き
        strStmt = strStmt & vbLf & _
              "       WHEN MATCHED THEN                                               " & vbLf & _
              "            UPDATE SET RSVFRAMNG.MAXCNT    = BASEDRSVFRAMNG.MAXCNT,    " & vbLf & _
              "                       RSVFRAMNG.MAXCNT_M  = BASEDRSVFRAMNG.MAXCNT_M,  " & vbLf & _
              "                       RSVFRAMNG.MAXCNT_F  = BASEDRSVFRAMNG.MAXCNT_F,  " & vbLf & _
              "                       RSVFRAMNG.OVERCNT   = BASEDRSVFRAMNG.OVERCNT,   " & vbLf & _
              "                       RSVFRAMNG.OVERCNT_M = BASEDRSVFRAMNG.OVERCNT_M, " & vbLf & _
              "                       RSVFRAMNG.OVERCNT_F = BASEDRSVFRAMNG.OVERCNT_F, " & vbLf & _
              "                       RSVFRAMNG.RSVCNT_M  = BASEDRSVFRAMNG.RSVCNT_M,  " & vbLf & _
              "                       RSVFRAMNG.RSVCNT_F  = BASEDRSVFRAMNG.RSVCNT_F   "

        'レコード非存在時は挿入
        strStmt = strStmt & vbLf & _
              "       WHEN NOT MATCHED THEN         " & vbLf & _
              "            INSERT (                 " & vbLf & _
              "                RSVFRAMNG.CSLDATE,   " & vbLf & _
              "                RSVFRAMNG.CSCD,      " & vbLf & _
              "                RSVFRAMNG.RSVGRPCD,  " & vbLf & _
              "                RSVFRAMNG.MAXCNT,    " & vbLf & _
              "                RSVFRAMNG.MAXCNT_M,  " & vbLf & _
              "                RSVFRAMNG.MAXCNT_F,  " & vbLf & _
              "                RSVFRAMNG.OVERCNT,   " & vbLf & _
              "                RSVFRAMNG.OVERCNT_M, " & vbLf & _
              "                RSVFRAMNG.OVERCNT_F, " & vbLf & _
              "                RSVFRAMNG.RSVCNT_M,  " & vbLf & _
              "                RSVFRAMNG.RSVCNT_F   "
        
        strStmt = strStmt & vbLf & _
              "            ) VALUES (                    " & vbLf & _
              "                BASEDRSVFRAMNG.CSLDATE,   " & vbLf & _
              "                BASEDRSVFRAMNG.CSCD,      " & vbLf & _
              "                BASEDRSVFRAMNG.RSVGRPCD,  " & vbLf & _
              "                BASEDRSVFRAMNG.MAXCNT,    " & vbLf & _
              "                BASEDRSVFRAMNG.MAXCNT_M,  " & vbLf & _
              "                BASEDRSVFRAMNG.MAXCNT_F,  " & vbLf & _
              "                BASEDRSVFRAMNG.OVERCNT,   " & vbLf & _
              "                BASEDRSVFRAMNG.OVERCNT_M, " & vbLf & _
              "                BASEDRSVFRAMNG.OVERCNT_F, " & vbLf & _
              "                BASEDRSVFRAMNG.RSVCNT_M,  " & vbLf & _
              "                BASEDRSVFRAMNG.RSVCNT_F   " & vbLf & _
              "            )                             "

    End If

    'コピー先受診日範囲の検索
    dtmWkCslDate = dtmStrCslDate
    Do Until dtmWkCslDate > dtmEndCslDate
    
        '受診日が範囲指定の場合はWeekday関数にて求まる曜日値に対してコピー対象であるかを判断し、単一日指定の場合は無条件で対象とする
        If dtmStrCslDate <> dtmEndCslDate Then
            blnAct = (vntArrWeekday((Weekday(dtmWkCslDate) + 5) Mod 7) <> "")
        Else
            blnAct = True
        End If
        
        'コピー先受診日の設定
        objNewCslDate.Value = dtmWkCslDate
        
        'ここまでの時点でコピー対象の場合
        If blnAct Then
        
            '休日判定
            If objOraDyna Is Nothing Then
                Set objOraDyna = mobjOraDb.CreateDynaset("SELECT CSLDATE FROM SCHEDULE_H WHERE CSLDATE = :NEWCSLDATE", ORADYN_READONLY + ORADYN_NOCACHE)
            Else
                objOraDyna.Refresh
            End If
            
            'レコードが存在する場合は休診日のため非対象とする
            If Not objOraDyna.EOF Then
                blnAct = False
            End If
            
        End If
            
        'コピー対象の場合
        If blnAct Then
    
            'SQLステートメントの実行
            If objOraSQLStmt Is Nothing Then
                Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
            Else
                objOraSQLStmt.Refresh
            End If
    
        End If
    
        dtmWkCslDate = dtmWkCslDate + 1
    Loop
    
    '作成／更新レコード件数の取得
    Ret = objOraSQLStmt.RecordCount
    
    Set objNewCslDate = Nothing
    Set objOraSQLStmt = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    '戻り値の設定
    CopyRsvFraMng = Ret
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Schedule.CopyRsvFraMng"

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
' 機能　　 : コース受診予約群テーブルレコードを削除する
'
' 引数　　 : (In)   strCsCd      コースコード
' 　　　　   (In)   lngRsvGrpCd  予約群コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteCourseRsvGrp(ByVal strCsCd As String, ByVal lngRsvGrpCd As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", lngRsvGrpCd, ORAPARM_INPUT, ORATYPE_NUMBER

    'コース受診予約群テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE COURSE_RSVGRP WHERE CSCD = :CSCD AND RSVGRPCD = :RSVGRPCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteCourseRsvGrp = True

    Exit Function
    
ErrorHandle:

    DeleteCourseRsvGrp = False

    'イベントログ書き込み
    WriteErrorLog "Schedule.DeleteCourseRsvGrp"
    
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
' 機能　　 : 予約空き状況の取得
'
' 引数　　 : (In)     strStrCslDate  開始受診日
' 　　　　 : (In)     strEndCslDate  終了受診日
' 　　　　 : (In)     strCsCd        コースコード
' 　　　　 : (In)     strCtrPtCd     契約パターンコード
' 　　　　 : (In)     strTimeFra     時間枠
' 　　　　 : (In)     strBirth       生年月日
' 　　　　 : (In)     strGender      性別
' 　　　　 : (In)     vntOptCd       オプションコード
' 　　　　 : (In)     lngOptCount    オプション数
' 　　　　 : (Out)    vntCslDate     受診日
' 　　　　 : (Out)    vntEmptyCount  空き人数
' 　　　　 : (Out)    vntMark        マーク
' 　　　　 : (Out)    vntEnabled     アンカー表示の有無
' 　　　　 : (Out)    vntCslCount    検索レコード数
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function GetEmptyCalender( _
    ByVal strStrCslDate As String, _
    ByVal strEndCslDate As String, _
    ByVal strCsCd As String, _
    ByVal strCtrPtCd As String, _
    ByVal strTimeFra As String, _
    ByVal strBirth As String, _
    ByVal strGender As String, _
    ByVal vntOptCd As Variant, _
    ByVal lngOptCount As Long, _
    ByRef vntCslDate As Variant, _
    ByRef vntEmptyCount As Variant, _
    ByRef vntMark As Variant, _
    ByRef vntEnabled As Variant, _
    ByRef vntCslCount As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objStrCslDate   As OraParamArray    '検索対象開始日付
    Dim objEndCslDate   As OraParamArray    '検索対象終了日付
    Dim objCsCd         As OraParamArray    'コースコース
    Dim objCtrPtCd      As OraParamArray    '契約パターンコード
    Dim objTimeFra      As OraParamArray    '時間枠
    Dim objBirth        As OraParamArray    '生年月日
    Dim objGender       As OraParamArray    '性別
    Dim objOptCd        As OraParamArray    'オプションコード
    Dim objOptCount     As OraParamArray    'オプションコード数
    Dim objCslDate      As OraParamArray    '受診日
    Dim objEmptyCount   As OraParamArray    '空き人数
    Dim objMark         As OraParamArray    'マーク
    Dim objEnabled      As OraParamArray    'アンカー　表示の有無
    Dim objCslCount     As OraParameter     '検索レコード数
    
    Dim objRet          As OraParameter     'エラーコード（０以上が正常）
    
    Dim lngArraySize        As Long
    Dim lngArrayOptCdSize   As Long
    
    Dim i                   As Long
    
    Dim vntArrMessage       As Variant          'エラーメッセージの集合
    
    Dim vntArrCslDate() As Variant
    Dim vntArrEmptyCount() As Variant
    Dim vntArrMark() As Variant
    Dim vntArrEnabled() As Variant


    '戻り値の仮の配列として１００とっておく
    lngArraySize = 100
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", strStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", strEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", strCtrPtCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TIMEFRA", strTimeFra, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BIRTH", strBirth, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "GENDER", strGender, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_NUMBER, IIf(lngOptCount = 0, 1, lngOptCount)
    objOraParam.Add "OPTCOUNT", lngOptCount, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.AddTable "CSLDATE", ORAPARM_OUTPUT, ORATYPE_DATE, lngArraySize
    objOraParam.AddTable "EMPTYCOUNT", ORAPARM_OUTPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.AddTable "CHARMARK", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 2
    objOraParam.AddTable "ENABLED", ORAPARM_OUTPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.Add "CSLCOUNT", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER

    'OraParameterオブジェクトの参照設定
    Set objOptCd = objOraParam("OPTCD")             'オプションコード
    Set objCslDate = objOraParam("CSLDATE")         '受診日
    Set objEmptyCount = objOraParam("EMPTYCOUNT")   '空き人数
    Set objMark = objOraParam("CHARMARK")           'マーク
    Set objEnabled = objOraParam("ENABLED")         'アンカー表示の有無
    Set objCslCount = objOraParam("CSLCOUNT")       '検索レコード数
    Set objRet = objOraParam("RET")                 'エラーコード
    
    'オプションコードの編集
    If IsArray(vntOptCd) Then
        For i = 0 To lngOptCount - 1
            objOptCd(i) = vntOptCd(i)
        Next i
    Else
        objCslDate(0) = vntOptCd
    End If
    
    'ストアド呼び出し
    strStmt = "BEGIN :Ret := SchedulePackage.GetEmptyCalender(:strCslDate,:endCslDate,:CsCd,:CtrPtCd,:TimeFra,:Birth,:Gender,:OptCd,:OptCount,:CslDate,:EmptyCount,:CharMark,:Enabled,:CslCount); END;"

    mobjOraDb.ExecuteSQL strStmt

    vntCslCount = CLng(0 & objCslCount)
    
    For i = 0 To vntCslCount - 1
        ReDim Preserve vntArrCslDate(i)
        ReDim Preserve vntArrEmptyCount(i)
        ReDim Preserve vntArrMark(i)
        ReDim Preserve vntArrEnabled(i)
        vntArrCslDate(i) = objCslDate(i) & ""
        vntArrEmptyCount(i) = objEmptyCount(i) & ""
        vntArrMark(i) = objMark(i) & ""
        vntArrEnabled(i) = objEnabled(i) & ""
    Next i
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    vntCslDate = vntArrCslDate
    vntEmptyCount = vntArrEmptyCount
    vntMark = vntArrMark
    vntEnabled = vntArrEnabled
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        GetEmptyCalender = vntArrMessage
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Schedule.GetEmptyCalender"
    
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
' 機能　　 : すでに登録されている予約済み人数をカウントする
'
' 引数　　 : (In)   strDate             処理対象日付
' 　　　　 : (In)   lngTimeFra          時間枠
' 　　　　 : (In)   strRsvFraCd         予約枠コード
' 　　　　 : (In)   lngFraType          枠管理タイプ
' 　　　　 : (In)   blnOrgCount         団体カウントモード（True:団体枠もカウントする，False:受診情報のみカウント）
'
' 戻り値　 : カウント数
'
' 備考　　 :
'
Private Function GetRsvCount(ByVal strDate As String, _
                             ByVal lngTimeFra As Long, _
                             ByVal strRsvFraCd As String, _
                             ByVal lngFraType As Long, _
                             ByVal blnOrgCount As Boolean _
                            ) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    Dim strStmt2        As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCount1       As OraField         '受診情報の予約済み人数
    Dim objCount2       As OraField         '団体の受診予定人数
    Dim objCount3       As OraField         '団体の予約済み人数
    Dim objCsCd         As OraField         'コースコード
    Dim objOrgCd1       As OraField         '団体コード1
    Dim objOrgCd2       As OraField         '団体コード2
    Dim objCslCount     As OraField         '予約済み人数
    Dim objRsvNo        As OraField         '予約番号
    
    Dim lngCount1       As Long             '受診情報の予約済み人数
    Dim lngCount2       As Long             '団体の受診予定人数
    Dim lngCount3       As Long             '団体の予約済み人数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    GetRsvCount = 0
    lngCount1 = 0
    lngCount2 = 0
    lngCount3 = 0
    
    '条件が設定されていない場合はエラー
    If Not IsDate(Trim(strDate)) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If Trim(strRsvFraCd) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If lngFraType <> FRA_TYPE_CS And _
       lngFraType <> FRA_TYPE_ITEM Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE1", Trim(strDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TIMEFRA1", lngTimeFra, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVFRACD1", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USED1", CONSULT_USED, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'コース枠管理の場合
    If lngFraType = FRA_TYPE_CS Then
    
        '検索条件を満たす受診情報のレコード件数を取得
        strStmt = "SELECT COUNT(*) RECCOUNT          " & vbLf & _
                  "  FROM CONSULT csl, RSVFRA_C rfc  " & vbLf & _
                  " WHERE csl.CSLDATE   = :CSLDATE1  " & vbLf & _
                  "   AND csl.TIMEFRA   = :TIMEFRA1  " & vbLf & _
                  "   AND csl.CANCELFLG = :USED1     " & vbLf & _
                  "   AND csl.CSCD      = rfc.CSCD   " & vbLf & _
                  "   AND rfc.RSVFRACD  = :RSVFRACD1 "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
        '検索レコードが存在する場合
        '(COUNT関数を発行しているので必ず1レコード返ってくる)
        If Not objOraDyna.EOF Then
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objCount1 = objFields("RECCOUNT")
            '受診情報の予約済み人数
            lngCount1 = CLng(objCount1.Value & "")
        End If
    
        Set objOraDyna = Nothing
    
        '受診情報のみカウントするモードの場合
        If blnOrgCount = False Then
    
            '戻り値の設定（受診情報の予約済み人数）
            GetRsvCount = lngCount1
    
        '団体枠もカウントするモードの場合
        Else
    
            '検索条件を満たす団体予約人数の受診予定人数と予約済み人数を取得
            strStmt = "SELECT NVL(SUM(ors.CSLCOUNT), 0) CSLCOUNT, " & vbLf & _
                      "       NVL(SUM(ors.RSVCOUNT), 0) RSVCOUNT  " & vbLf & _
                      "  FROM ORGRSV ors, RSVFRA_C rfc            " & vbLf & _
                      " WHERE ors.CSLDATE  = :CSLDATE1            " & vbLf & _
                      "   AND ors.TIMEFRA  = :TIMEFRA1            " & vbLf & _
                      "   AND ors.CSCD     = rfc.CSCD             " & vbLf & _
                      "   AND rfc.RSVFRACD = :RSVFRACD1           "
    
            Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
            '検索レコードが存在する場合
            '(SUM関数を発行しているので必ず1レコード返ってくる)
            If Not objOraDyna.EOF Then
                'オブジェクトの参照設定
                Set objFields = objOraDyna.Fields
                Set objCount2 = objFields("CSLCOUNT")
                Set objCount3 = objFields("RSVCOUNT")
                '団体の受診予定人数
                lngCount2 = CLng(objCount2.Value & "")
                '団体の予約済み人数
                lngCount3 = CLng(objCount3.Value & "")
            End If
    
            Set objOraDyna = Nothing
    
            '戻り値の設定（団体の受診予定人数　＋　受診情報の予約済み人数　－　団体の予約済み人数）
            GetRsvCount = lngCount2 + lngCount1 - lngCount3
    
        End If
    
    '検査項目枠管理の場合
    Else
    
'#################################################################################
'#「CONSULTITEMLIST」を使用した検索に時間がかかるので、とりあえず動くようにしています。
'#↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
'#
'#        '検索条件を満たす受診情報のレコード件数を取得（時間枠は指定してはならない）
'#        strStmt = "SELECT DISTINCT COUNT(tgt.RSVNO) RECCOUNT       " & vbLf & _
'#                  "  FROM (                                        " & vbLf & _
'#                  "        SELECT lst.RSVNO, lst.ITEMCD            " & vbLf & _
'#                  "          FROM CONSULT csl, CONSULTITEMLIST lst " & vbLf & _
'#                  "         WHERE lst.RSVNO     = csl.RSVNO        " & vbLf & _
'#                  "           AND csl.CSLDATE   = :CSLDATE1        " & vbLf & _
'#                  "           AND csl.CANCELFLG = :USED1           " & vbLf & _
'#                  "       ) tgt,                                   " & vbLf & _
'#                  "       (                                        " & vbLf & _
'#                  "        SELECT ITEMCD                           " & vbLf & _
'#                  "          FROM RSVFRA_I                         " & vbLf & _
'#                  "         WHERE RSVFRACD = :RSVFRACD1            " & vbLf & _
'#                  "       ) chk                                    " & vbLf & _
'#                  " WHERE tgt.ITEMCD = chk.ITEMCD                  "
'#
'#        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
'#
'#        '検索レコードが存在する場合
'#        '(COUNT関数を発行しているので必ず1レコード返ってくる)
'#        If Not objOraDyna.EOF Then
'#            'オブジェクトの参照設定
'#            Set objFields = objOraDyna.Fields
'#            Set objCount1 = objFields("RECCOUNT")
'#            '受診情報の予約済み人数
'#            lngCount1 = CLng(objCount1.Value & "")
'#        End If
'#
'#        Set objOraDyna = Nothing
    
        '受診情報より該当日の予約番号を取得（時間枠は指定してはならない）
        strStmt = "SELECT RSVNO                 " & vbLf & _
                  "  FROM CONSULT               " & vbLf & _
                  " WHERE CSLDATE   = :CSLDATE1 " & vbLf & _
                  "   AND CANCELFLG = :USED1    "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
        '検索レコードが存在する場合
        If Not objOraDyna.EOF Then
    
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objRsvNo = objFields("RSVNO")
    
            '予約番号の条件を編集
            strStmt2 = objRsvNo.Value & ""
            objOraDyna.MoveNext
    
            '予約番号すべてについて条件を編集する
            Do Until objOraDyna.EOF
                strStmt2 = strStmt2 & "," & vbLf & objRsvNo.Value & ""
                objOraDyna.MoveNext
            Loop
    
            Set objOraDyna = Nothing
    
            '上で求めた予約番号について、該当検査項目を含む受診情報のレコード件数を取得
            strStmt = "SELECT COUNT(DISTINCT lst.RSVNO) RECCOUNT              " & vbLf & _
                      "  FROM CONSULTITEMLIST lst                             " & vbLf & _
                      " WHERE lst.RSVNO  IN (                                 " & vbLf & _
                      strStmt2 & vbLf & _
                      "                     )                                 " & vbLf & _
                      "   AND lst.ITEMCD IN (                                 " & vbLf & _
                      "                      SELECT rfi.ITEMCD                " & vbLf & _
                      "                        FROM RSVFRA_I rfi              " & vbLf & _
                      "                       WHERE rfi.RSVFRACD = :RSVFRACD1 " & vbLf & _
                      "                     )                    "
    
            Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
            '検索レコードが存在する場合
            '(COUNT関数を発行しているので必ず1レコード返ってくる)
            If Not objOraDyna.EOF Then
                'オブジェクトの参照設定
                Set objFields = objOraDyna.Fields
                Set objCount1 = objFields("RECCOUNT")
                '受診情報の予約済み人数
                lngCount1 = CLng(objCount1.Value & "")
            End If
    
        End If
    
        Set objOraDyna = Nothing
    
'#↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
'#ここまで
'#################################################################################
    
        '受診情報のみカウントするモードの場合
        If blnOrgCount = False Then
    
            '戻り値の設定（受診情報の予約済み人数）
            GetRsvCount = lngCount1
    
        '団体枠もカウントするモードの場合
        Else
    
            '検索条件を満たす団体予約人数のレコードを取得（時間枠はサマリーする）
            strStmt = "SELECT CSCD, ORGCD1, ORGCD2, SUM(CSLCOUNT) CSLCOUNT " & vbLf & _
                      "  FROM ORGRSV                                       " & vbLf & _
                      " WHERE CSLDATE = :CSLDATE1                          " & vbLf & _
                      " GROUP BY CSCD, ORGCD1, ORGCD2                      "
    
            Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
            '検索レコードが存在する場合
            If Not objOraDyna.EOF Then
    
                'オブジェクトの参照設定
                Set objFields = objOraDyna.Fields
                Set objCsCd = objFields("CSCD")
                Set objOrgCd1 = objFields("ORGCD1")
                Set objOrgCd2 = objFields("ORGCD2")
                Set objCslCount = objFields("CSLCOUNT")
    
                '団体予約人数１レコードごとに処理する
                Do Until objOraDyna.EOF
                    '団体予約検査項目枠が必要な場合
                    If CheckOrgRsv_iFra(Trim(strDate), (objCsCd.Value & ""), (objOrgCd1.Value & ""), (objOrgCd2.Value & ""), Trim(strRsvFraCd)) = True Then
                        '団体の受診予定人数
                        lngCount2 = lngCount2 + CLng(objCslCount.Value & "")
                        '団体の予約済み人数
                        lngCount3 = lngCount3 + GetRsvCount_iFra(Trim(strDate), (objCsCd.Value & ""), (objOrgCd1.Value & ""), (objOrgCd2.Value & ""))
                    End If
                    objOraDyna.MoveNext
                Loop
    
            End If
    
            Set objOraDyna = Nothing
    
            '戻り値の設定（団体の受診予定人数　＋　受診情報の予約済み人数　－　団体の予約済み人数）
            GetRsvCount = lngCount2 + lngCount1 - lngCount3
    
        End If
    
    End If
    
    objOraParam.Remove "CSLDATE1"
    objOraParam.Remove "TIMEFRA1"
    objOraParam.Remove "RSVFRACD1"
    objOraParam.Remove "USED1"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.GetRsvCount"
    
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
' 機能　　 : すでに登録されている予約済み人数をカウントする（団体予約検査項目枠）
'
' 引数　　 : (In)   strDate             処理対象日付
' 　　　　 : (In)   strCsCd             コースコード
' 　　　　 : (In)   strOrgCd1           団体コード1
' 　　　　 : (In)   strOrgCd2           団体コード2
'
' 戻り値　 : カウント数
'
' 備考　　 :
'
Private Function GetRsvCount_iFra(ByVal strDate As String, _
                                  ByVal strCsCd As String, _
                                  ByVal strOrgCd1 As String, _
                                  ByVal strOrgCd2 As String _
                                 ) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCount        As OraField         'カウント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    GetRsvCount_iFra = 0
    
    '条件が設定されていない場合はエラー
    If Not IsDate(Trim(strDate)) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If Trim(strCsCd) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If Trim(strOrgCd1) = "" Or Trim(strOrgCd2) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE2", Trim(strDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD2", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD12", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD22", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USED2", CONSULT_USED, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす受診情報のレコード件数を取得（時間枠は指定してはならない）
    strStmt = "SELECT COUNT(*) RECCOUNT     " & vbLf & _
              "  FROM CONSULT               " & vbLf & _
              " WHERE CSLDATE   = :CSLDATE2 " & vbLf & _
              "   AND CSCD      = :CSCD2    " & vbLf & _
              "   AND ORGCD1    = :ORGCD12  " & vbLf & _
              "   AND ORGCD2    = :ORGCD22  " & vbLf & _
              "   AND CANCELFLG = :USED2    "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCount = objFields("RECCOUNT")
        '戻り値の設定
        GetRsvCount_iFra = CLng(objCount.Value & "")
    End If
    
    Set objOraDyna = Nothing
    objOraParam.Remove "CSLDATE2"
    objOraParam.Remove "CSCD2"
    objOraParam.Remove "ORGCD12"
    objOraParam.Remove "ORGCD22"
    objOraParam.Remove "USED2"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.GetRsvCount_iFra"
    
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
' 機能　　 : 予約枠レコード及び予約枠が管理する項目を登録する
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strRsvFraCd    予約枠コード
' 　　　　   (In)    strRsvFraName  予約枠名称
' 　　　　   (In)    intOverRsv     枠人数オーバー登録
' 　　　　   (In)    intFraType     枠管理タイプ
' 　　　　   (In)    intDefCnt0     デフォルト人数（時間帯枠０）
' 　　　　   (In)    intDefCnt1     デフォルト人数（時間帯枠１）
' 　　　　   (In)    intDefCnt2     デフォルト人数（時間帯枠２）
' 　　　　   (In)    intDefCnt3     デフォルト人数（時間帯枠３）
' 　　　　   (In)    intDefCnt4     デフォルト人数（時間帯枠４）
' 　　　　   (In)    intDefCnt5     デフォルト人数（時間帯枠５）
' 　　　　   (In)    intDefCnt6     デフォルト人数（時間帯枠６）
' 　　　　   (In)    intDefCnt7     デフォルト人数（時間帯枠７）
' 　　　　   (In)    intDefCnt8     デフォルト人数（時間帯枠８）
' 　　　　   (In)    intDefCnt9     デフォルト人数（時間帯枠９）
' 　　　　   (In)    lngIncOpenGrp  オープン枠予約群検索
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'Public Function RegistRsvFra_All(ByVal strMode As String,
'                                 ByVal strRsvFraCd As String,
'                                 ByVal strRsvFraName As String,
'                                 ByVal intOverRsv As Integer,
'                                 ByVal intFraType As Integer,
'                                 ByVal intDefCnt0 As Integer,
'                                 ByVal intDefCnt1 As Integer,
'                                 ByVal intDefCnt2 As Integer,
'                                 ByVal intDefCnt3 As Integer,
'                                 ByVal intDefCnt4 As Integer,
'                                 ByVal intDefCnt5 As Integer,
'                                 ByVal intDefCnt6 As Integer,
'                                 ByVal intDefCnt7 As Integer,
'                                 ByVal intDefCnt8 As Integer,
'                                 ByVal intDefCnt9 As Integer,
'                                 ByVal intItemCount As Integer,
'                                 ByVal vntItemCode As Variant) As Long
Public Function RegistRsvFra_All( _
    ByVal strMode As String, _
    ByVal strRsvFraCd As String, _
    ByVal strRsvFraName As String, _
    ByVal intOverRsv As Integer, _
    ByVal intFraType As Integer, _
    ByVal intDefCnt0 As Integer, _
    ByVal intDefCnt1 As Integer, _
    ByVal intDefCnt2 As Integer, _
    ByVal intDefCnt3 As Integer, _
    ByVal intDefCnt4 As Integer, _
    ByVal intDefCnt5 As Integer, _
    ByVal intDefCnt6 As Integer, _
    ByVal intDefCnt7 As Integer, _
    ByVal intDefCnt8 As Integer, _
    ByVal intDefCnt9 As Integer, _
    ByVal intItemCount As Integer, _
    ByVal vntItemCode As Variant, _
    ByVal lngIncOpenGrp As Long _
) As Long
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim Ret         As Long             '関数戻り値
    
    Ret = INSERT_ERROR
    
    Do
        
        '予約枠テーブルの更新
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'        Ret = RegistRsvFra_p(strMode, _
'                             strRsvFraCd, _
'                             strRsvFraName, _
'                             intOverRsv, _
'                             intFraType, _
'                             intDefCnt0, _
'                             intDefCnt1, _
'                             intDefCnt2, _
'                             intDefCnt3, _
'                             intDefCnt4, _
'                             intDefCnt5, _
'                             intDefCnt6, _
'                             intDefCnt7, _
'                             intDefCnt8, _
'                             intDefCnt9)
        Ret = RegistRsvFra_p(strMode, _
                             strRsvFraCd, _
                             strRsvFraName, _
                             intOverRsv, _
                             intFraType, _
                             intDefCnt0, _
                             intDefCnt1, _
                             intDefCnt2, _
                             intDefCnt3, _
                             intDefCnt4, _
                             intDefCnt5, _
                             intDefCnt6, _
                             intDefCnt7, _
                             intDefCnt8, _
                             intDefCnt9, _
                             lngIncOpenGrp)
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####

        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
                         
        '予約枠管理テーブルの更新
        Ret = RegistRsvFra_Item(intFraType, _
                                strRsvFraCd, _
                                intItemCount, _
                                vntItemCode)

        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
        
        Exit Do
    Loop
 
    '異常終了ならRollBack
    If Ret <> INSERT_NORMAL Then
        mobjContext.SetAbort
    End If
 
    '戻り値の設定
    RegistRsvFra_All = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistRsvFra_All = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Schedule.RegistRsvFra_All"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 予約枠内受診項目を登録する
'
' 引数　　 : (In)    intFraType     枠管理タイプ（依頼 or 検査）
' 　　　　   (In)    strRsvFraCd    予約枠コード
' 　　　　   (In)    intItemCount   予約枠内項目数
' 　　　　   (In)    vntItemCode    項目コード（コースコード or 検査項目コード）
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistRsvFra_Item(ByVal intFraType As Integer, _
                                  ByVal strRsvFraCd As String, _
                                  ByVal intItemCount As Integer, _
                                  ByVal vntItemCode As Variant) As Long
                               
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim objRsvFraCd As OraParamArray    '予約枠コード
    Dim objItemCode As OraParamArray    '検査項目コード

    Dim i           As Integer
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVFRACD", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '予約枠内項目レコードの削除（関係なくても両方削除しておく～ゴミ帽子じゃなくて防止）
    mobjOraDb.ExecuteSQL "DELETE RSVFRA_C WHERE RSVFRACD = :RSVFRACD"
'## 2003.11.19 Del by T.Takagi@FSIT 不要項目削除
'    mobjOraDb.ExecuteSQL "DELETE RSVFRA_I WHERE RSVFRACD = :RSVFRACD"
'## 2003.11.19 Del End
    
    If intItemCount > 0 Then
    
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "RSVFRACD"
        objOraParam.AddTable "RSVFRACD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_RSVFRA_P_RSVFRACD
        objOraParam.AddTable "ITEMCODE", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_ITEM_P_ITEMCD
        
        'OraParameterオブジェクトの参照設定
        Set objRsvFraCd = objOraParam("RSVFRACD")
        Set objItemCode = objOraParam("ITEMCODE")
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objRsvFraCd(i) = strRsvFraCd
            objItemCode(i) = vntItemCode(i)
        Next i
        
        '新規挿入
        If intFraType = FRA_TYPE_CS Then
            '枠管理タイプがコースの場合
            strStmt = strStmt & "INSERT INTO RSVFRA_C (RSVFRACD, CSCD) VALUES (:RSVFRACD, :ITEMCODE)"
'## 2003.11.19 Del by T.Takagi@FSIT 不要項目削除
'        Else
'           '枠管理タイプが検査項目の場合
'            strStmt = strStmt & "INSERT INTO RSVFRA_I (RSVFRACD, ITEMCD) VALUES (:RSVFRACD, :ITEMCODE)"
'## 2003.11.19 Del End
        End If
    
        mobjOraDb.ExecuteSQL strStmt
    
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Ret = INSERT_NORMAL
    
    '戻り値の設定
    RegistRsvFra_Item = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistRsvFra_Item = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Schedule.RegistRsvFra_Item"
    
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
' 機能　　 : 予約枠レコードを登録する
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strRsvFraCd    予約枠コード
' 　　　　   (In)    strRsvFraName  予約枠名称
' 　　　　   (In)    intOverRsv     枠人数オーバー登録
' 　　　　   (In)    intFraType     枠管理タイプ
' 　　　　   (In)    intDefCnt0     デフォルト人数（時間帯枠０）
' 　　　　   (In)    intDefCnt1     デフォルト人数（時間帯枠１）
' 　　　　   (In)    intDefCnt2     デフォルト人数（時間帯枠２）
' 　　　　   (In)    intDefCnt3     デフォルト人数（時間帯枠３）
' 　　　　   (In)    intDefCnt4     デフォルト人数（時間帯枠４）
' 　　　　   (In)    intDefCnt5     デフォルト人数（時間帯枠５）
' 　　　　   (In)    intDefCnt6     デフォルト人数（時間帯枠６）
' 　　　　   (In)    intDefCnt7     デフォルト人数（時間帯枠７）
' 　　　　   (In)    intDefCnt8     デフォルト人数（時間帯枠８）
' 　　　　   (In)    intDefCnt9     デフォルト人数（時間帯枠９）
' 　　　　   (In)    lngIncOpenGrp  オープン枠予約群検索
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'Public Function RegistRsvFra_p(ByVal strMode As String,
'                               ByVal strRsvFraCd As String,
'                               ByVal strRsvFraName As String,
'                               ByVal intOverRsv As Integer,
'                               ByVal intFraType As Integer,
'                               ByVal intDefCnt0 As Integer,
'                               ByVal intDefCnt1 As Integer,
'                               ByVal intDefCnt2 As Integer,
'                               ByVal intDefCnt3 As Integer,
'                               ByVal intDefCnt4 As Integer,
'                               ByVal intDefCnt5 As Integer,
'                               ByVal intDefCnt6 As Integer,
'                               ByVal intDefCnt7 As Integer,
'                               ByVal intDefCnt8 As Integer,
'                               ByVal intDefCnt9 As Integer) As Long
Public Function RegistRsvFra_p( _
    ByVal strMode As String, _
    ByVal strRsvFraCd As String, _
    ByVal strRsvFraName As String, _
    ByVal intOverRsv As Integer, _
    ByVal intFraType As Integer, _
    ByVal intDefCnt0 As Integer, _
    ByVal intDefCnt1 As Integer, _
    ByVal intDefCnt2 As Integer, _
    ByVal intDefCnt3 As Integer, _
    ByVal intDefCnt4 As Integer, _
    ByVal intDefCnt5 As Integer, _
    ByVal intDefCnt6 As Integer, _
    ByVal intDefCnt7 As Integer, _
    ByVal intDefCnt8 As Integer, _
    ByVal intDefCnt9 As Integer, _
    ByVal lngIncOpenGrp As Long _
) As Long
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVFRACD", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVFRANAME", Trim(strRsvFraName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.11.19 Del by T.Takagi@FSIT 不要項目削除
'    objOraParam.Add "OVERRSV", Trim(intOverRsv), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "FRATYPE", Trim(intFraType), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT0", Trim(intDefCnt0), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT1", Trim(intDefCnt1), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT2", Trim(intDefCnt2), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT3", Trim(intDefCnt3), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT4", Trim(intDefCnt4), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT5", Trim(intDefCnt5), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT6", Trim(intDefCnt6), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT7", Trim(intDefCnt7), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT8", Trim(intDefCnt8), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DEFCNT9", Trim(intDefCnt9), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.11.19 Del End
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
    objOraParam.Add "INCOPENGRP", lngIncOpenGrp, ORAPARM_INPUT, ORATYPE_NUMBER
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####

    Do
        '予約枠テーブルレコードの更新
        If strMode = "UPD" Then
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
''## 2003.11.19 Mod by T.Takagi@FSIT 不要項目削除
''            strStmt = "UPDATE RSVFRA_P " & vbLf & _
''                      "   SET RSVFRANAME = :RSVFRANAME, " & vbLf & _
''                      "       OVERRSV = :OVERRSV, FRATYPE = :FRATYPE," & vbLf & _
''                      "       DEFCNT0 = :DEFCNT0, DEFCNT1 = :DEFCNT1, DEFCNT2 = :DEFCNT2," & vbLf & _
''                      "       DEFCNT3 = :DEFCNT3, DEFCNT4 = :DEFCNT4, DEFCNT5 = :DEFCNT5," & vbLf & _
''                      "       DEFCNT6 = :DEFCNT6, DEFCNT7 = :DEFCNT7, DEFCNT8 = :DEFCNT8," & vbLf & _
''                      "       DEFCNT9 = :DEFCNT9" & vbLf & _
''                      " WHERE RSVFRACD = :RSVFRACD"
'            strStmt = "UPDATE RSVFRA_P                 " & vbLf & _
'                      "   SET RSVFRANAME = :RSVFRANAME " & vbLf & _
'                      " WHERE RSVFRACD   = :RSVFRACD   "
''## 2003.11.19 Mod End
            strStmt = "UPDATE RSVFRA_P                  " & vbLf & _
                      "   SET RSVFRANAME = :RSVFRANAME, " & vbLf & _
                      "       INCOPENGRP = :INCOPENGRP  " & vbLf & _
                      " WHERE RSVFRACD   = :RSVFRACD    "
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
            
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす予約枠テーブルのレコードを取得
        strStmt = "SELECT RSVFRACD FROM RSVFRA_P WHERE RSVFRACD = :RSVFRACD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        '存在した場合、新規挿入不可
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '新規挿入
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
''## 2003.11.19 Mod by T.Takagi@FSIT 不要項目削除
''        strStmt = "INSERT INTO RSVFRA_P ( RSVFRACD, RSVFRANAME, OVERRSV, FRATYPE, DEFCNT0, DEFCNT1, DEFCNT2, DEFCNT3, DEFCNT4, DEFCNT5, DEFCNT6, DEFCNT7, DEFCNT8, DEFCNT9)" & vbLf & _
''                  "              VALUES (:RSVFRACD,:RSVFRANAME,:OVERRSV,:FRATYPE,:DEFCNT0,:DEFCNT1,:DEFCNT2,:DEFCNT3,:DEFCNT4,:DEFCNT5,:DEFCNT6,:DEFCNT7,:DEFCNT8,:DEFCNT9)"
'        strStmt = "INSERT INTO RSVFRA_P ( RSVFRACD, RSVFRANAME ) VALUES ( :RSVFRACD, :RSVFRANAME )"
''## 2003.11.19 Mod End
        strStmt = "INSERT INTO RSVFRA_P ( RSVFRACD, RSVFRANAME, INCOPENGRP ) VALUES ( :RSVFRACD, :RSVFRANAME, :INCOPENGRP )"
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
        mobjOraDb.ExecuteSQL strStmt
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistRsvFra_p = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistRsvFra_p = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Schedule.RegistRsvFra_p"
    
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
' 機能　　 : 予約群レコードを登録する
'
' 引数　　 : (In)    strMode         登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    lngRsvGrpCd     予約群コード
' 　　　　   (In)    strRsvGrpName   予約群名称
' 　　　　   (In)    lngStrTime      開始時間
' 　　　　   (In)    lngEndTime      終了時間
' 　　　　   (In)    lngRptEndTime   健診受付終了時間
' 　　　　   (In)    lngLead         誘導対象
' 　　　　   (In)    lngStrDayId     開始当日ID
' 　　　　   (In)    lngStrDayId     終了当日ID
' 　　　　   (In)    strRsvSetGrpCd  予約時セットグループコード
' 　　　　   (In)    lngIsOpenGrp    オープン枠予約群
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'Public Function RegistRsvGrp(
'    ByVal strMode As String,
'    ByVal lngRsvGrpCd As Long,
'    ByVal strRsvGrpName As String,
'    ByVal lngStrTime As Long,
'    ByVal lngEndTime As Long,
'    ByVal lngRptEndTime As Long,
'    ByVal lngLead As Long,
'    ByVal lngStrDayId As Long,
'    ByVal lngEndDayId As Long,
'    ByVal strRsvSetGrpCd As String
') As Long
Public Function RegistRsvGrp( _
    ByVal strMode As String, _
    ByVal lngRsvGrpCd As Long, _
    ByVal strRsvGrpName As String, _
    ByVal lngStrTime As Long, _
    ByVal lngEndTime As Long, _
    ByVal lngRptEndTime As Long, _
    ByVal lngLead As Long, _
    ByVal lngStrDayId As Long, _
    ByVal lngEndDayId As Long, _
    ByVal strRsvSetGrpCd As String, _
    ByVal lngIsOpenGrp As Long _
) As Long
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVGRPCD", lngRsvGrpCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVGRPNAME", strRsvGrpName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRTIME", lngStrTime, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDTIME", lngEndTime, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RPTENDTIME", lngRptEndTime, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LEAD", lngLead, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVSETGRPCD", strRsvSetGrpCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
    objOraParam.Add "ISOPENGRP", lngIsOpenGrp, ORAPARM_INPUT, ORATYPE_NUMBER
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####
    
    Do
        '予約枠テーブルレコードの更新
        If strMode = "UPD" Then
            
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'            strStmt = "UPDATE RSVGRP                         " & vbLf & _
'                      "   SET RSVGRPNAME  = :RSVGRPNAME,     " & vbLf & _
'                      "       STRTIME     = :STRTIME,        " & vbLf & _
'                      "       ENDTIME     = :ENDTIME,        " & vbLf & _
'                      "       RPTENDTIME  = :RPTENDTIME,     " & vbLf & _
'                      "       LEAD        = :LEAD,           " & vbLf & _
'                      "       STRDAYID    = :STRDAYID,       " & vbLf & _
'                      "       ENDDAYID    = :ENDDAYID,       " & vbLf & _
'                      "       RSVSETGRPCD = :RSVSETGRPCD     " & vbLf & _
'                      " WHERE RSVGRPCD    = :RSVGRPCD        "
            strStmt = "UPDATE RSVGRP                         " & vbLf & _
                      "   SET RSVGRPNAME  = :RSVGRPNAME,     " & vbLf & _
                      "       STRTIME     = :STRTIME,        " & vbLf & _
                      "       ENDTIME     = :ENDTIME,        " & vbLf & _
                      "       RPTENDTIME  = :RPTENDTIME,     " & vbLf & _
                      "       LEAD        = :LEAD,           " & vbLf & _
                      "       STRDAYID    = :STRDAYID,       " & vbLf & _
                      "       ENDDAYID    = :ENDDAYID,       " & vbLf & _
                      "       RSVSETGRPCD = :RSVSETGRPCD,    " & vbLf & _
                      "       ISOPENGRP   = :ISOPENGRP       " & vbLf & _
                      " WHERE RSVGRPCD    = :RSVGRPCD        "
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす予約枠テーブルのレコードを取得
        strStmt = "SELECT RSVGRPCD FROM RSVGRP WHERE RSVGRPCD = :RSVGRPCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        '存在した場合、新規挿入不可
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '新規挿入
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'        strStmt = "INSERT INTO RSVGRP ( RSVGRPCD, RSVGRPNAME, STRTIME, ENDTIME, RPTENDTIME, LEAD, STRDAYID, ENDDAYID, RSVSETGRPCD)" & vbLf & _
'                  "              VALUES (:RSVGRPCD, :RSVGRPNAME, :STRTIME, :ENDTIME, :RPTENDTIME, :LEAD, :STRDAYID, :ENDDAYID, :RSVSETGRPCD)"
        strStmt = "INSERT INTO RSVGRP ( RSVGRPCD, RSVGRPNAME, STRTIME, ENDTIME, RPTENDTIME, LEAD, STRDAYID, ENDDAYID, RSVSETGRPCD, ISOPENGRP)" & vbLf & _
                  "            VALUES (:RSVGRPCD, :RSVGRPNAME, :STRTIME, :ENDTIME, :RPTENDTIME, :LEAD, :STRDAYID, :ENDDAYID, :RSVSETGRPCD, :ISOPENGRP)"
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
        mobjOraDb.ExecuteSQL strStmt
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistRsvGrp = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistRsvGrp = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Schedule.RegistRsvFra_p"
    
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
' 機能　　 : 予約群レコードを登録する
'
' 引数　　 : (In)    strMode        　登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strCsCd        　予約群コード
' 　　　　   (In)    lngRsvGrpCd    　予約群コード
' 　　　　   (In)    lngMngGender   　男女別枠管理
' 　　　　   (In)    lngDefCnt      　共通人数
' 　　　　   (In)    lngDefCnt_m    　男人数
' 　　　　   (In)    lngDefCnt_f    　女人数
' 　　　　   (In)    lngDefCnt_sat  　土曜共通人数
' 　　　　   (In)    lngDefCnt_sat_m　土曜男人数
' 　　　　   (In)    lngDefCnt_sat_f　土曜女人数
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistCourseRsvGrp( _
    ByVal strMode As String, _
    ByVal strCsCd As String, _
    ByVal lngRsvGrpCd As Long, _
    ByVal lngMngGender As Long, _
    ByVal lngDefCnt As Long, _
    ByVal lngDefCnt_M As Long, _
    ByVal lngDefCnt_F As Long, _
    ByVal lngDefCnt_Sat As Long, _
    ByVal lngDefCnt_Sat_M As Long, _
    ByVal lngDefCnt_Sat_F As Long _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", lngRsvGrpCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MNGGENDER", lngMngGender, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DEFCNT", lngDefCnt, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DEFCNT_M", lngDefCnt_M, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DEFCNT_F", lngDefCnt_F, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DEFCNT_SAT", lngDefCnt_Sat, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DEFCNT_SAT_M", lngDefCnt_Sat_M, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DEFCNT_SAT_F", lngDefCnt_Sat_F, ORAPARM_INPUT, ORATYPE_NUMBER
    
    Do
        'コース受診予約群テーブルレコードの更新
        If strMode = "UPD" Then
            
            strStmt = "UPDATE COURSE_RSVGRP                 " & vbLf & _
                      "   SET MNGGENDER    = :MNGGENDER,    " & vbLf & _
                      "       DEFCNT       = :DEFCNT,       " & vbLf & _
                      "       DEFCNT_M     = :DEFCNT_M,     " & vbLf & _
                      "       DEFCNT_F     = :DEFCNT_F,     " & vbLf & _
                      "       DEFCNT_SAT   = :DEFCNT_SAT,   " & vbLf & _
                      "       DEFCNT_SAT_M = :DEFCNT_SAT_M, " & vbLf & _
                      "       DEFCNT_SAT_F = :DEFCNT_SAT_F  " & vbLf & _
                      " WHERE CSCD         = :CSCD          " & vbLf & _
                      "   AND RSVGRPCD     = :RSVGRPCD      "
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        
        End If

        '検索条件を満たすコース受診予約群テーブルのレコードを取得
        strStmt = "SELECT RSVGRPCD FROM COURSE_RSVGRP WHERE CSCD = :CSCD AND RSVGRPCD = :RSVGRPCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        '存在した場合、新規挿入不可
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '新規挿入
        strStmt = "INSERT INTO COURSE_RSVGRP (    " & vbLf & _
                  "                CSCD,          " & vbLf & _
                  "                RSVGRPCD,      " & vbLf & _
                  "                MNGGENDER,     " & vbLf & _
                  "                DEFCNT,        " & vbLf & _
                  "                DEFCNT_M,      " & vbLf & _
                  "                DEFCNT_F,      " & vbLf & _
                  "                DEFCNT_SAT,    " & vbLf & _
                  "                DEFCNT_SAT_M,  " & vbLf & _
                  "                DEFCNT_SAT_F   " & vbLf & _
                  "            ) VALUES (         " & vbLf & _
                  "                :CSCD,         " & vbLf & _
                  "                :RSVGRPCD,     " & vbLf & _
                  "                :MNGGENDER,    " & vbLf & _
                  "                :DEFCNT,       " & vbLf & _
                  "                :DEFCNT_M,     " & vbLf & _
                  "                :DEFCNT_F,     " & vbLf & _
                  "                :DEFCNT_SAT,   " & vbLf & _
                  "                :DEFCNT_SAT_M, " & vbLf & _
                  "                :DEFCNT_SAT_F  " & vbLf & _
                  "            )                  "
        
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistCourseRsvGrp = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistCourseRsvGrp = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Schedule.RegistCourseRsvGrp"
    
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
' 機能　　 : 指定受診日のコース別・団体別受診者数を取得する
'
' 引数　　 : (In)     lngMode      取得モード(0:コース別、1:団体別、2:コース・団体別、3:団体・コース別)
' 　　　　   (In)     dtmCslDate   受診日
' 　　　　   (Out)    vntCsCd      コースコード
' 　　　　   (Out)    vntCsName    コース名
' 　　　　   (Out)    vntWebColor  webカラー
' 　　　　   (Out)    vntOrgCd1    団体コード1
' 　　　　   (Out)    vntOrgCd2    団体コード2
' 　　　　   (Out)    vntOrgName   団体名称
' 　　　　   (Out)    vntCslCount  受診者数
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsultSchedule( _
    ByVal lngMode As Long, _
    ByVal dtmCslDate As Date, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntWebColor As Variant, _
    Optional ByRef vntOrgCd1 As Variant, _
    Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntCslCount As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objWebColor         As OraField         'webカラー
    Dim objOrgCd1           As OraField         '団体コード1
    Dim objOrgCd2           As OraField         '団体コード2
    Dim objOrgName          As OraField         '団体名称
    Dim objCslCount         As OraField         '受診者数

    Dim vntArrCsCd()        As Variant          'コースコードの配列
    Dim vntArrCsName()      As Variant          'コース名の配列
    Dim vntArrWebColor()    As Variant          'webカラーの配列
    Dim vntArrOrgCd1()      As Variant          '団体コード1の配列
    Dim vntArrOrgCd2()      As Variant          '団体コード2の配列
    Dim vntArrOrgName()     As Variant          '団体名称の配列
    Dim vntArrCslCount()    As Variant          '受診者数の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntCsCd) Then
        vntCsCd = Empty
    End If
    
    If Not IsMissing(vntCsName) Then
        vntCsName = Empty
    End If
    
    If Not IsMissing(vntWebColor) Then
        vntWebColor = Empty
    End If
    
    If Not IsMissing(vntOrgCd1) Then
        vntOrgCd1 = Empty
    End If
    
    If Not IsMissing(vntOrgCd2) Then
        vntOrgCd2 = Empty
    End If
    
    If Not IsMissing(vntOrgName) Then
        vntOrgName = Empty
    End If
    
    If Not IsMissing(vntCslCount) Then
        vntCslCount = Empty
    End If
    
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE

    '指定受診日のコース別・団体別受診者数を取得する
    strStmt = "SELECT BASECOUNT.CSCD,                                      " & vbLf & _
              "       COURSE_P.CSNAME,                                     " & vbLf & _
              "       COURSE_P.WEBCOLOR,                                   " & vbLf & _
              "       BASECOUNT.ORGCD1,                                    " & vbLf & _
              "       BASECOUNT.ORGCD2,                                    " & vbLf & _
              "       ORG.ORGNAME,                                         " & vbLf & _
              "       BASECOUNT.CSLCOUNT                                   " & vbLf & _
              "  FROM ORG, COURSE_P,                                       " & vbLf & _
              "       ( SELECT CSCD, ORGCD1, ORGCD2, COUNT(RSVNO) CSLCOUNT " & vbLf & _
              "           FROM CONSULT                                     " & vbLf & _
              "          WHERE CSLDATE = :CSLDATE                          " & vbLf & _
              "          GROUP BY CUBE(CSCD, ORGCD1, ORGCD2)               " & vbLf & _
              "       ) BASECOUNT                                          "
              
    'CUBE関数で取得したデータのうち、取得モードに応じたレコードのみを取得
    Select Case lngMode
    
        Case 1      '団体別
            strStmt = strStmt & vbLf & _
              " WHERE BASECOUNT.ORGCD1 IS NOT NULL " & vbLf & _
              "   AND BASECOUNT.ORGCD2 IS NOT NULL " & vbLf & _
              "   AND BASECOUNT.CSCD   IS NULL     "
        
        Case 2, 3   'コース・団体別、団体・コース別
            strStmt = strStmt & vbLf & _
              " WHERE BASECOUNT.ORGCD1 IS NOT NULL " & vbLf & _
              "   AND BASECOUNT.ORGCD2 IS NOT NULL " & vbLf & _
              "   AND BASECOUNT.CSCD   IS NOT NULL "

        Case Else   'コース別
            strStmt = strStmt & vbLf & _
              " WHERE BASECOUNT.ORGCD1 IS NULL     " & vbLf & _
              "   AND BASECOUNT.ORGCD2 IS NULL     " & vbLf & _
              "   AND BASECOUNT.CSCD   IS NOT NULL "
        
    End Select
    
    'コース・団体の結合
    strStmt = strStmt & vbLf & _
              "   AND BASECOUNT.CSCD    = COURSE_P.CSCD(+) " & vbLf & _
              "   AND BASECOUNT.ORGCD1  = ORG.ORGCD1(+)    " & vbLf & _
              "   AND BASECOUNT.ORGCD2  = ORG.ORGCD2(+)    "
    
    'ORDER BY句の指定
    Select Case lngMode
    
        Case 3      '団体・コース別
            strStmt = strStmt & vbLf & _
              " ORDER BY BASECOUNT.ORGCD1, BASECOUNT.ORGCD2, BASECOUNT.CSCD "
        
        Case Else   'コース別、団体別、コース・団体別
            strStmt = strStmt & vbLf & _
              " ORDER BY BASECOUNT.CSCD, BASECOUNT.ORGCD1, BASECOUNT.ORGCD2"
            
    End Select
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objWebColor = objFields("WEBCOLOR")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objCslCount = objFields("CSLCOUNT")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrCslCount(lngCount)
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrCslCount(lngCount) = objCslCount.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
        If Not IsMissing(vntOrgName) Then vntOrgName = vntArrOrgName
        If Not IsMissing(vntCslCount) Then vntCslCount = vntArrCslCount
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectConsultSchedule = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectConsultSchedule = -1

    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectConsultSchedule"
    
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

'## 2003.12.09 Add Function By T.Takagi@FSIT
'
' 機能　　 : コース受診予約群をもつコースのみを取得
'
' 引数　　 : (Out)    vntCsCd     コースコード
' 　　　　   (Out)    vntCsName   コース名
' 　　　　   (Out)    vntCsSName  コース略称
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectCourseListRsvGrpManaged(ByRef vntCsCd As Variant, Optional ByRef vntCsName As Variant, Optional ByRef vntCsSName As Variant) As Long

    Dim objOraDyna      As OraDynaset   'ダイナセット
    Dim strStmt         As String       'SQLステートメント

    Dim objFields       As OraFields    'フィールドオブジェクト
    Dim objCsCd         As OraField     'コースコード
    Dim objCsName       As OraField     'コース名
    Dim objCsSName      As OraField     'コース略称
    
    Dim vntArrCsCd()    As Variant      'コースコードの配列
    Dim vntArrCsName()  As Variant      'コース名の配列
    Dim vntArrCsSName() As Variant      'コース略称の配列
    Dim lngCount        As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntCsSName) Then vntCsSName = Empty
    
    'コース受診予約群を持つコースのみを取得
    strStmt = "SELECT COURSE_P.CSCD, COURSE_P.CSNAME, COURSE_P.CSSNAME     " & vbLf & _
              "  FROM COURSE_P                                             " & vbLf & _
              " WHERE EXISTS ( SELECT COURSE_RSVGRP.CSCD                   " & vbLf & _
              "                  FROM COURSE_RSVGRP                        " & vbLf & _
              "                 WHERE COURSE_RSVGRP.CSCD = COURSE_P.CSCD ) " & vbLf & _
              " ORDER BY COURSE_P.CSCD                                     "

    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objCsSName = objFields("CSSNAME")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrCsSName(lngCount)
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrCsSName(lngCount) = objCsSName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntCsSName) Then vntCsSName = vntArrCsSName
    
    End If

    Set objCsCd = Nothing
    Set objCsName = Nothing
    Set objCsSName = Nothing
    Set objFields = Nothing
    Set objOraDyna = Nothing

    '戻り値の設定
    SelectCourseListRsvGrpManaged = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectCourseListRsvGrpManaged = -1

    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectCourseListRsvGrpManaged"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 指定コースの予約群を取得する
'
' 引数　　 : (In)     strCsCd        　コースコード
' 　　　　   (Out)    lngRsvGrpCd    　予約群コード
' 　　　　   (Out)    vntMngGender   　男女別枠管理
' 　　　　   (Out)    vntDefCnt      　共通人数
' 　　　　   (Out)    vntDefCnt_M    　男人数
' 　　　　   (Out)    vntDefCnt_F    　女人数
' 　　　　   (Out)    vntDefCnt_Sat  　土曜共通人数
' 　　　　   (Out)    vntDefCnt_Sat_M　土曜男人数
' 　　　　   (Out)    vntDefCnt_Sat_F  土曜女人数
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectCourseRsvGrp( _
    ByVal strCsCd As String, _
    ByVal lngRsvGrpCd As Long, _
    Optional ByRef vntMngGender As Variant, _
    Optional ByRef vntDefCnt As Variant, _
    Optional ByRef vntDefCnt_M As Variant, _
    Optional ByRef vntDefCnt_F As Variant, _
    Optional ByRef vntDefCnt_Sat As Variant, _
    Optional ByRef vntDefCnt_Sat_M As Variant, _
    Optional ByRef vntDefCnt_Sat_F As Variant _
) As Boolean
    
    Dim objOraParam          As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna           As OraDynaset       'ダイナセット
    Dim strStmt              As String           'SQLステートメント

    Dim objFields            As OraFields        'フィールドオブジェクト
    Dim objMngGender         As OraField         '男女別枠管理
    Dim objDefCnt            As OraField         '共通人数
    Dim objDefCnt_M          As OraField         '男人数
    Dim objDefCnt_F          As OraField         '女人数
    Dim objDefCnt_Sat        As OraField         '土曜共通人数
    Dim objDefCnt_Sat_M      As OraField         '土曜男人数
    Dim objDefCnt_Sat_F      As OraField         '土曜女人数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntMngGender) Then vntMngGender = Empty
    If Not IsMissing(vntDefCnt) Then vntDefCnt = Empty
    If Not IsMissing(vntDefCnt_M) Then vntDefCnt_M = Empty
    If Not IsMissing(vntDefCnt_F) Then vntDefCnt_F = Empty
    If Not IsMissing(vntDefCnt_Sat) Then vntDefCnt_Sat = Empty
    If Not IsMissing(vntDefCnt_Sat_M) Then vntDefCnt_Sat_M = Empty
    If Not IsMissing(vntDefCnt_Sat_F) Then vntDefCnt_Sat_F = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", lngRsvGrpCd, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定コースの予約群をコース受診予約群テーブルから取得
    strStmt = "SELECT COURSE_RSVGRP.RSVGRPCD,   COURSE_RSVGRP.CSCD,     COURSE_RSVGRP.MNGGENDER,       " & vbLf & _
              "       COURSE_RSVGRP.DEFCNT,     COURSE_RSVGRP.DEFCNT_M, COURSE_RSVGRP.DEFCNT_F,        " & vbLf & _
              "       COURSE_RSVGRP.DEFCNT_SAT, COURSE_RSVGRP.DEFCNT_SAT_M, COURSE_RSVGRP.DEFCNT_SAT_F " & vbLf & _
              "  FROM COURSE_RSVGRP                                                                    " & vbLf & _
              " WHERE COURSE_RSVGRP.CSCD     = :CSCD                                                   " & vbLf & _
              "   AND COURSE_RSVGRP.RSVGRPCD = :RSVGRPCD                                               "

    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    SelectCourseRsvGrp = False
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objMngGender = objFields("MNGGENDER")
        Set objDefCnt = objFields("DEFCNT")
        Set objDefCnt_M = objFields("DEFCNT_M")
        Set objDefCnt_F = objFields("DEFCNT_F")
        Set objDefCnt_Sat = objFields("DEFCNT_SAT")
        Set objDefCnt_Sat_M = objFields("DEFCNT_SAT_M")
        Set objDefCnt_Sat_F = objFields("DEFCNT_SAT_F")

        '戻り値の設定
        If Not IsMissing(vntMngGender) Then vntMngGender = objMngGender
        If Not IsMissing(vntDefCnt) Then vntDefCnt = objDefCnt.Value & ""
        If Not IsMissing(vntDefCnt_M) Then vntDefCnt_M = objDefCnt_M.Value & ""
        If Not IsMissing(vntDefCnt_F) Then vntDefCnt_F = objDefCnt_F.Value & ""
        If Not IsMissing(vntDefCnt_Sat) Then vntDefCnt_Sat = objDefCnt_Sat.Value & ""
        If Not IsMissing(vntDefCnt_Sat_M) Then vntDefCnt_Sat_M = objDefCnt_Sat_M.Value & ""
        If Not IsMissing(vntDefCnt_Sat_F) Then vntDefCnt_Sat_F = objDefCnt_Sat_F.Value & ""
    
        SelectCourseRsvGrp = True
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
'    SelectCourseRsvGrp = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectCourseRsvGrp = False

    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectCourseRsvGrp"

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
' 機能　　 : 指定コースの予約群を取得する
'
' 引数　　 : (In)     strCsCd        コースコード
' 　　　　   (In)     lngSortOrder   ソート順(0:予約群コード順、0以外:開始時間順)
' 　　　　   (Out)    vntRsvGrpCd    予約群コード
' 　　　　   (Out)    vntRsvGrpName  予約群名称
' 　　　　   (Out)    vntStrTime     開始時間
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCourseRsvGrpListSelCourse( _
    ByVal strCsCd As String, _
    Optional ByVal lngSortOrder As Long, _
    Optional ByRef vntRsvGrpCd As Variant, _
    Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntStrTime As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvGrpCd         As OraField         '予約群コード
    Dim objRsvGrpName       As OraField         '予約群名称
    Dim objStrTime          As OraField         '開始時間

    Dim vntArrRsvGrpCd()    As Variant          '予約群コードの配列
    Dim vntArrRsvGrpName()  As Variant          '予約群名称の配列
    Dim vntArrStrTime()     As Variant          '開始時間の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
    If Not IsMissing(vntStrTime) Then vntStrTime = Empty
    lngCount = 0

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定コースの予約群をコース受診予約群テーブルから取得
    strStmt = "SELECT COURSE_RSVGRP.RSVGRPCD, RSVGRP.RSVGRPNAME, RSVGRP.STRTIME " & vbLf & _
              "  FROM RSVGRP, COURSE_RSVGRP                                     " & vbLf & _
              " WHERE COURSE_RSVGRP.CSCD     = :CSCD                            " & vbLf & _
              "   AND COURSE_RSVGRP.RSVGRPCD = RSVGRP.RSVGRPCD                  "

    If lngSortOrder = 0 Then
        strStmt = strStmt & vbLf & _
              " ORDER BY COURSE_RSVGRP.CSCD, COURSE_RSVGRP.RSVGRPCD "
    Else
        strStmt = strStmt & vbLf & _
              " ORDER BY COURSE_RSVGRP.CSCD, RSVGRP.STRTIME, COURSE_RSVGRP.RSVGRPCD "
    End If

    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvGrpCd = objFields("RSVGRPCD")
        Set objRsvGrpName = objFields("RSVGRPNAME")
        Set objStrTime = objFields("STRTIME")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvGrpCd(lngCount)
            ReDim Preserve vntArrRsvGrpName(lngCount)
            ReDim Preserve vntArrStrTime(lngCount)
            vntArrRsvGrpCd(lngCount) = objRsvGrpCd.Value & ""
            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
            vntArrStrTime(lngCount) = objStrTime.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = vntArrRsvGrpCd
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
        If Not IsMissing(vntStrTime) Then vntStrTime = vntArrStrTime

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectCourseRsvGrpListSelCourse = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectCourseRsvGrpListSelCourse = -1

    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectCourseRsvGrpListSelCourse"

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
' 機能　　 : 指定予約枠コードの予約枠情報を取得する
'
' 引数　　 : (In)   strRsvFraCd 　      予約枠コード
' 　　　　 : (Out)  vntRsvFraName       予約枠名称
' 　　　　 : (Out)  vntOverRsv          枠人数オーバー登録
' 　　　　 : (Out)  vntFraType          枠管理タイプ
' 　　　　 : (Out)  vntDefCnt0          デフォルト人数（時間帯枠０）
' 　　　　 : (Out)  vntDefCnt1          デフォルト人数（時間帯枠１）
' 　　　　 : (Out)  vntDefCnt2          デフォルト人数（時間帯枠２）
' 　　　　 : (Out)  vntDefCnt3          デフォルト人数（時間帯枠３）
' 　　　　 : (Out)  vntDefCnt4          デフォルト人数（時間帯枠４）
' 　　　　 : (Out)  vntDefCnt5          デフォルト人数（時間帯枠５）
' 　　　　 : (Out)  vntDefCnt6          デフォルト人数（時間帯枠６）
' 　　　　 : (Out)  vntDefCnt7          デフォルト人数（時間帯枠７）
' 　　　　 : (Out)  vntDefCnt8          デフォルト人数（時間帯枠８）
' 　　　　 : (Out)  vntDefCnt9          デフォルト人数（時間帯枠９）
' 　　　　 : (Out)  vntIncOpenGrp       オープン予約群検索
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'Public Function SelectRsvFra(ByVal strRsvFraCd As String,
'                             ByRef vntRsvFraName As Variant,
'                             ByRef vntOverRsv As Variant,
'                             ByRef vntFraType As Variant,
'                             ByRef vntDefCnt0 As Variant,
'                             ByRef vntDefCnt1 As Variant,
'                             ByRef vntDefCnt2 As Variant,
'                             ByRef vntDefCnt3 As Variant,
'                             ByRef vntDefCnt4 As Variant,
'                             ByRef vntDefCnt5 As Variant,
'                             ByRef vntDefCnt6 As Variant,
'                             ByRef vntDefCnt7 As Variant,
'                             ByRef vntDefCnt8 As Variant,
'                             ByRef vntDefCnt9 As Variant
'                            ) As Boolean
Public Function SelectRsvFra( _
    ByVal strRsvFraCd As String, _
    Optional ByRef vntRsvFraName As Variant, _
    Optional ByRef vntOverRsv As Variant, _
    Optional ByRef vntFraType As Variant, _
    Optional ByRef vntDefCnt0 As Variant, _
    Optional ByRef vntDefCnt1 As Variant, _
    Optional ByRef vntDefCnt2 As Variant, _
    Optional ByRef vntDefCnt3 As Variant, _
    Optional ByRef vntDefCnt4 As Variant, _
    Optional ByRef vntDefCnt5 As Variant, _
    Optional ByRef vntDefCnt6 As Variant, _
    Optional ByRef vntDefCnt7 As Variant, _
    Optional ByRef vntDefCnt8 As Variant, _
    Optional ByRef vntDefCnt9 As Variant, _
    Optional ByRef vntIncOpenGrp As Variant _
) As Boolean
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvFraName       As OraField         '予約枠名称
'## 2003.11.19 Del by T.Takagi@FSIT 不要項目削除
'    Dim objOverRsv          As OraField         '枠人数オーバー登録
'    Dim objFraType          As OraField         '枠管理タイプ
'    Dim objDefCnt0          As OraField         'デフォルト人数（時間帯枠０）
'    Dim objDefCnt1          As OraField         'デフォルト人数（時間帯枠１）
'    Dim objDefCnt2          As OraField         'デフォルト人数（時間帯枠２）
'    Dim objDefCnt3          As OraField         'デフォルト人数（時間帯枠３）
'    Dim objDefCnt4          As OraField         'デフォルト人数（時間帯枠４）
'    Dim objDefCnt5          As OraField         'デフォルト人数（時間帯枠５）
'    Dim objDefCnt6          As OraField         'デフォルト人数（時間帯枠６）
'    Dim objDefCnt7          As OraField         'デフォルト人数（時間帯枠７）
'    Dim objDefCnt8          As OraField         'デフォルト人数（時間帯枠８）
'    Dim objDefCnt9          As OraField         'デフォルト人数（時間帯枠９）
'## 2003.11.19 Del End
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
    Dim objIncOpenGrp       As OraField         'オープン枠予約群検索
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'    vntRsvFraName = Empty
'    vntOverRsv = Empty
'    vntFraType = Empty
'    vntDefCnt0 = Empty
'    vntDefCnt1 = Empty
'    vntDefCnt2 = Empty
'    vntDefCnt3 = Empty
'    vntDefCnt4 = Empty
'    vntDefCnt5 = Empty
'    vntDefCnt6 = Empty
'    vntDefCnt7 = Empty
'    vntDefCnt8 = Empty
'    vntDefCnt9 = Empty
    If Not IsMissing(vntRsvFraName) Then vntRsvFraName = Empty
    If Not IsMissing(vntOverRsv) Then vntOverRsv = Empty
    If Not IsMissing(vntFraType) Then vntFraType = Empty
    If Not IsMissing(vntDefCnt0) Then vntDefCnt0 = Empty
    If Not IsMissing(vntDefCnt1) Then vntDefCnt1 = Empty
    If Not IsMissing(vntDefCnt2) Then vntDefCnt2 = Empty
    If Not IsMissing(vntDefCnt3) Then vntDefCnt3 = Empty
    If Not IsMissing(vntDefCnt4) Then vntDefCnt4 = Empty
    If Not IsMissing(vntDefCnt5) Then vntDefCnt5 = Empty
    If Not IsMissing(vntDefCnt6) Then vntDefCnt6 = Empty
    If Not IsMissing(vntDefCnt7) Then vntDefCnt7 = Empty
    If Not IsMissing(vntDefCnt8) Then vntDefCnt8 = Empty
    If Not IsMissing(vntDefCnt9) Then vntDefCnt9 = Empty
    If Not IsMissing(vntIncOpenGrp) Then vntIncOpenGrp = Empty
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
    '検索条件が設定されていない場合はエラー
    If Trim(strRsvFraCd) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVFRACD", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす予約枠テーブルのレコードを取得
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
''## 2003.11.19 Mod by T.Takagi@FSIT 不要項目削除
''    strStmt = "SELECT RSVFRANAME, OVERRSV,    FRATYPE,    DEFCNT0," & vbLf & _
''              "       DEFCNT1,    DEFCNT2,    DEFCNT3,    DEFCNT4, " & vbLf & _
''              "       DEFCNT5,    DEFCNT6,    DEFCNT7,    DEFCNT8, " & vbLf & _
''              "       DEFCNT9                                      " & vbLf & _
''              "  FROM RSVFRA_P                                     " & vbLf & _
''              " WHERE RSVFRACD = :RSVFRACD                         "
'    strStmt = "SELECT RSVFRANAME           " & vbLf & _
'              "  FROM RSVFRA_P             " & vbLf & _
'              " WHERE RSVFRACD = :RSVFRACD "
''## 2003.11.19 Mod End
    strStmt = "SELECT RSVFRANAME, INCOPENGRP " & vbLf & _
              "  FROM RSVFRA_P               " & vbLf & _
              " WHERE RSVFRACD = :RSVFRACD   "
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvFraName = objFields("RSVFRANAME")
'## 2003.11.19 Del by T.Takagi@FSIT 不要項目削除
'        Set objOverRsv = objFields("OVERRSV")
'        Set objFraType = objFields("FRATYPE")
'        Set objDefCnt0 = objFields("DEFCNT0")
'        Set objDefCnt1 = objFields("DEFCNT1")
'        Set objDefCnt2 = objFields("DEFCNT2")
'        Set objDefCnt3 = objFields("DEFCNT3")
'        Set objDefCnt4 = objFields("DEFCNT4")
'        Set objDefCnt5 = objFields("DEFCNT5")
'        Set objDefCnt6 = objFields("DEFCNT6")
'        Set objDefCnt7 = objFields("DEFCNT7")
'        Set objDefCnt8 = objFields("DEFCNT8")
'        Set objDefCnt9 = objFields("DEFCNT9")
'## 2003.11.19 Del End
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
        Set objIncOpenGrp = objFields("INCOPENGRP")
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####
    
        '戻り値の設定
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'        vntRsvFraName = objRsvFraName.Value & ""
''## 2003.11.19 Del by T.Takagi@FSIT 不要項目削除
''        vntOverRsv = CLng(objOverRsv.Value & "")
''        vntFraType = CLng(objFraType.Value & "")
''        vntDefCnt0 = CLng(objDefCnt0.Value & "")
''        vntDefCnt1 = CLng(objDefCnt1.Value & "")
''        vntDefCnt2 = CLng(objDefCnt2.Value & "")
''        vntDefCnt3 = CLng(objDefCnt3.Value & "")
''        vntDefCnt4 = CLng(objDefCnt4.Value & "")
''        vntDefCnt5 = CLng(objDefCnt5.Value & "")
''        vntDefCnt6 = CLng(objDefCnt6.Value & "")
''        vntDefCnt7 = CLng(objDefCnt7.Value & "")
''        vntDefCnt8 = CLng(objDefCnt8.Value & "")
''        vntDefCnt9 = CLng(objDefCnt9.Value & "")
''## 2003.11.19 Del End
        If Not IsMissing(vntRsvFraName) Then vntRsvFraName = objRsvFraName.Value & ""
        If Not IsMissing(vntIncOpenGrp) Then vntIncOpenGrp = objIncOpenGrp.Value & ""
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
        SelectRsvFra = True
    
    End If
    
    Set objOraDyna = Nothing
    objOraParam.Remove "RSVFRACD"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectRsvFra"
    
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
' 機能　　 : 指定予約群コードの予約群情報を取得する
'
' 引数　　 : (In)   strRsvGrpCd 　      予約群コード
' 　　　　 : (Out)  vntRsvGrpName       予約群名称
' 　　　　 : (Out)  vntStrTime          開始時間
' 　　　　 : (Out)  vntEndTime          終了時間
' 　　　　 : (Out)  vntRptEndTime       健診受付終了時間
' 　　　　 : (Out)  vntLead　           誘導対象
' 　　　　 : (Out)  vntStrDayId         当日開始ID
' 　　　　 : (Out)  vntEndDayId         当日終了ID
' 　　　　 : (Out)  vntIsOpenGrp        オープン枠予約群
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'Public Function SelectRsvGrp(
'    ByVal strRsvGrpCd As String,
'    ByRef vntRsvGrpName As Variant,
'    ByRef vntStrTime As Variant,
'    ByRef vntEndTime As Variant,
'    ByRef vntRptEndTime As Variant,
'    ByRef vntLead As Variant,
'    ByRef vntStrDayId As Variant,
'    ByRef vntEndDayId As Variant,
'    ByRef vntRsvSetGrpCd As Variant
') As Boolean
Public Function SelectRsvGrp( _
    ByVal strRsvGrpCd As String, _
    Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntStrTime As Variant, _
    Optional ByRef vntEndTime As Variant, _
    Optional ByRef vntRptEndTime As Variant, _
    Optional ByRef vntLead As Variant, _
    Optional ByRef vntStrDayId As Variant, _
    Optional ByRef vntEndDayId As Variant, _
    Optional ByRef vntRsvSetGrpCd As Variant, _
    Optional ByRef vntIsOpenGrp As Variant _
) As Boolean
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvGrpName       As OraField         '予約群名称
    Dim objStrTime          As OraField         '開始時間
    Dim objEndTime          As OraField         '終了時間
    Dim objRptEndTime       As OraField         '健診受付終了時間
    Dim objLead             As OraField         '誘導対象
    Dim objStrDayId         As OraField         '当日開始ID
    Dim objEndDayId         As OraField         '当日終了ID
    Dim objRsvSetGrpCd      As OraField         '
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
    Dim objIsOpenGrp        As OraField         'オープン枠予約群
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'    vntRsvGrpName = Empty
'    vntStrTime = Empty
'    vntEndTime = Empty
'    vntRptEndTime = Empty
'    vntLead = Empty
'    vntStrDayId = Empty
'    vntEndDayId = Empty
'    vntRsvSetGrpCd = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
    If Not IsMissing(vntStrTime) Then vntStrTime = Empty
    If Not IsMissing(vntEndTime) Then vntEndTime = Empty
    If Not IsMissing(vntRptEndTime) Then vntRptEndTime = Empty
    If Not IsMissing(vntLead) Then vntLead = Empty
    If Not IsMissing(vntStrDayId) Then vntStrDayId = Empty
    If Not IsMissing(vntEndDayId) Then vntEndDayId = Empty
    If Not IsMissing(vntRsvSetGrpCd) Then vntRsvSetGrpCd = Empty
    If Not IsMissing(vntIsOpenGrp) Then vntIsOpenGrp = Empty
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
    '検索条件が設定されていない場合はエラー
    If Trim(strRsvGrpCd) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVGRPCD", Trim(strRsvGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす予約群テーブルのレコードを取得
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'    strStmt = "SELECT RSVGRPNAME, STRTIME, ENDTIME, RPTENDTIME, LEAD, STRDAYID, ENDDAYID, RSVSETGRPCD" & vbLf & _
'              "  FROM RSVGRP                                                                         " & vbLf & _
'              " WHERE RSVGRPCD = :RSVGRPCD                                                           "
    strStmt = "SELECT RSVGRPNAME, STRTIME, ENDTIME, RPTENDTIME, LEAD, STRDAYID, ENDDAYID, RSVSETGRPCD, ISOPENGRP " & vbLf & _
              "  FROM RSVGRP                                                                                     " & vbLf & _
              " WHERE RSVGRPCD = :RSVGRPCD                                                                       "
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvGrpName = objFields("RSVGRPNAME")
        Set objStrTime = objFields("STRTIME")
        Set objEndTime = objFields("ENDTIME")
        Set objRptEndTime = objFields("RPTENDTIME")
        Set objLead = objFields("LEAD")
        Set objStrDayId = objFields("STRDAYID")
        Set objEndDayId = objFields("ENDDAYID")
        Set objRsvSetGrpCd = objFields("RSVSETGRPCD")
'#### 2013.2.25 SL-SN-Y0101-612 ADD START ####
        Set objIsOpenGrp = objFields("ISOPENGRP")
'#### 2013.2.25 SL-SN-Y0101-612 ADD END   ####
    
        '戻り値の設定
'#### 2013.2.25 SL-SN-Y0101-612 UPD START ####
'        vntRsvGrpName = objRsvGrpName.Value & ""
'        vntStrTime = objStrTime.Value & ""
'        vntEndTime = objEndTime.Value & ""
'        vntRptEndTime = objRptEndTime.Value & ""
'        vntLead = objLead.Value & ""
'        vntStrDayId = objStrDayId.Value & ""
'        vntEndDayId = objEndDayId.Value & ""
'        vntRsvSetGrpCd = objRsvSetGrpCd.Value & ""
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = objRsvGrpName.Value & ""
        If Not IsMissing(vntStrTime) Then vntStrTime = objStrTime.Value & ""
        If Not IsMissing(vntEndTime) Then vntEndTime = objEndTime.Value & ""
        If Not IsMissing(vntRptEndTime) Then vntRptEndTime = objRptEndTime.Value & ""
        If Not IsMissing(vntLead) Then vntLead = objLead.Value & ""
        If Not IsMissing(vntStrDayId) Then vntStrDayId = objStrDayId.Value & ""
        If Not IsMissing(vntEndDayId) Then vntEndDayId = objEndDayId.Value & ""
        If Not IsMissing(vntRsvSetGrpCd) Then vntRsvSetGrpCd = objRsvSetGrpCd.Value & ""
        If Not IsMissing(vntIsOpenGrp) Then vntIsOpenGrp = objIsOpenGrp.Value & ""
'#### 2013.2.25 SL-SN-Y0101-612 UPD END   ####
        
        SelectRsvGrp = True
    
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
    WriteErrorLog "Schedule.SelectRsvGrp"
    
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
' 機能　　 : 予約枠の一覧を取得する
'
' 引数　　 : (In)   strRsvFraCd 　      予約枠コード
' 　　　　 : (In)   intFraType          枠管理タイプ（0:コース、1:検査項目）
' 　　　　 : (Out)  vntItemCode         項目コード（コースコード or 検査項目コード）
' 　　　　 : (Out)  vntItemName         項目名（コース名 or 依頼項目名）
' 　　　　 : (Out)  vntCsCd             枠管理対象コースコード（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 : コース枠の場合、枠管理対象コースコードに対象コースコードをセットする
' 　　　　   （コース枠の場合、駆動表がコーステーブルになる）
'
Public Function SelectRsvFraItemList(ByVal strRsvFraCd As String, _
                                     ByVal intFraType As Integer, _
                                     ByRef vntItemCode As Variant, _
                                     ByRef vntItemName As Variant, _
                                     ByRef vntCsCd As Variant _
                                    ) As Long
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objItemCode         As OraField         '項目コード
    Dim objItemName         As OraField         '項目名
    Dim objCsCd             As OraField         'コースコード
    
    Dim vntArrItemCode()    As Variant          '項目コードの配列
    Dim vntArrItemName()    As Variant          '項目名称の配列
    Dim vntArrCsCd()        As Variant          'コースコードの配列
    
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectRsvFraItemList = 0
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVFRACD", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '枠タイプによりSQL変更
    If intFraType = FRA_TYPE_CS Then
        'コース枠管理の場合
'### 2003.02.17 Updated by Ishihara@FSIT 並びがむちゃくちゃ
'        strStmt = "SELECT COURSE_P.CSCD ITEMCODE, COURSE_P.CSNAME ITEMNAME, TARGETRSVFRA_C.CSCD CSCD" & vbLf & _
                  "  FROM COURSE_P, " & vbLf & _
                  "       (SELECT CSCD FROM RSVFRA_C WHERE RSVFRA_C.RSVFRACD = :RSVFRACD) TARGETRSVFRA_C" & vbLf & _
                  " WHERE COURSE_P.CSCD = TARGETRSVFRA_C.CSCD(+)"
        strStmt = "SELECT COURSE_P.CSCD ITEMCODE, COURSE_P.CSNAME ITEMNAME, TARGETRSVFRA_C.CSCD CSCD" & vbLf & _
                  "  FROM COURSE_P, " & vbLf & _
                  "       (SELECT CSCD FROM RSVFRA_C WHERE RSVFRA_C.RSVFRACD = :RSVFRACD) TARGETRSVFRA_C" & vbLf & _
                  " WHERE COURSE_P.CSCD = TARGETRSVFRA_C.CSCD(+)" & vbLf & _
                  " ORDER BY COURSE_P.CSCD"
'### 2003.02.17 Updated End
    Else
        '検査項目枠管理の場合
        strStmt = "SELECT RSVFRA_I.ITEMCD ITEMCODE, ITEM_P.REQUESTNAME ITEMNAME, '' CSCD" & vbLf & _
                  "  FROM ITEM_P, RSVFRA_I" & vbLf & _
                  " WHERE RSVFRA_I.RSVFRACD = :RSVFRACD" & vbLf & _
                  "   AND RSVFRA_I.ITEMCD   = ITEM_P.ITEMCD"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCode = objFields("ITEMCODE")
        Set objItemName = objFields("ITEMNAME")
        Set objCsCd = objFields("CSCD")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCode(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            
            vntArrItemCode(lngCount) = objItemCode.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntItemCode = vntArrItemCode
    vntItemName = vntArrItemName
    vntCsCd = vntArrCsCd
    SelectRsvFraItemList = lngCount
    
'### 2003.02.05 Added by Ishihara@FSIT バインド変数そのまま放置
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2003.02.05 Added End
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectRsvFraItemList"
    
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
' 機能　　 : 予約枠の一覧を取得する
'
' 引数　　 : (Out)    vntRsvFraCd 　 予約枠コード
' 　　　　   (Out)    vntRsvFraName  予約枠名称
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectRsvFraList(ByRef vntRsvFraCd As Variant, ByRef vntRsvFraName As Variant, Optional ByRef vntOverRsv As Variant, Optional ByRef vntFraType As Variant) As Long
    
    Dim objOraDyna          As OraDynaset   'ダイナセット
    Dim strStmt             As String       'SQLステートメント
    
    Dim objFields           As OraFields    'フィールドオブジェクト
    Dim objRsvFraCd         As OraField     '予約枠コード
    Dim objRsvFraName       As OraField     '予約枠名称
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objOverRsv          As OraField     '枠人数オーバー登録
'    Dim objFraType          As OraField     '枠管理タイプ
''## 2003.11.18 Del End
    
    Dim vntArrRsvFraCd()    As Variant      '予約枠コードの配列
    Dim vntArrRsvFraName()  As Variant      '予約枠名称の配列
    Dim vntArrOverRsv()     As Variant      '枠人数オーバー登録の配列
    Dim vntArrFraType()     As Variant      '枠管理タイプの配列
    Dim lngCount            As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntRsvFraCd) Then vntRsvFraCd = Empty
    If Not IsMissing(vntRsvFraName) Then vntRsvFraName = Empty
    If Not IsMissing(vntOverRsv) Then vntOverRsv = Empty
    If Not IsMissing(vntFraType) Then vntFraType = Empty
    lngCount = 0
    
    '予約枠テーブルの全レコードを取得
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'   strStmt = "SELECT RSVFRACD, RSVFRANAME, OVERRSV, FRATYPE " & vbLf & _
'              "  FROM RSVFRA_P                               " & vbLf & _
'              " ORDER BY RSVFRACD                            "
   strStmt = "SELECT RSVFRACD, RSVFRANAME FROM RSVFRA_P ORDER BY RSVFRACD"
'## 2003.11.18 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvFraCd = objFields("RSVFRACD")
        Set objRsvFraName = objFields("RSVFRANAME")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objOverRsv = objFields("OVERRSV")
'        Set objFraType = objFields("FRATYPE")
'## 2003.11.18 Del End
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvFraCd(lngCount)
            ReDim Preserve vntArrRsvFraName(lngCount)
            ReDim Preserve vntArrOverRsv(lngCount)
            ReDim Preserve vntArrFraType(lngCount)
            vntArrRsvFraCd(lngCount) = objRsvFraCd.Value & ""
            vntArrRsvFraName(lngCount) = objRsvFraName.Value & ""
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'            vntArrOverRsv(lngCount) = objOverRsv.Value & ""
'            vntArrFraType(lngCount) = objFraType.Value & ""
            vntArrOverRsv(lngCount) = ""
            vntArrFraType(lngCount) = ""
'## 2003.11.18 Mod End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        If Not IsMissing(vntRsvFraCd) Then vntRsvFraCd = vntArrRsvFraCd
        If Not IsMissing(vntRsvFraName) Then vntRsvFraName = vntArrRsvFraName
        If Not IsMissing(vntOverRsv) Then vntOverRsv = vntArrOverRsv
        If Not IsMissing(vntFraType) Then vntFraType = vntArrFraType
    
    End If
    
    '戻り値の設定
    SelectRsvFraList = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    SelectRsvFraList = -1
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectRsvFraList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'## 2003.09.29 Add By T.Takagi
'
' 機能　　 : すべての予約群を取得する
'
' 引数　　 : (In)     lngSortOrder   ソート順(0:予約群コード順、0以外:開始時間順)
' 　　　　   (Out)    vntRsvGrpCd    予約群コード
' 　　　　   (Out)    vntRsvGrpName  予約群名称
' 　　　　   (Out)    vntStrTime     開始時間
' 　　　　   (Out)    vntEndTime     終了時間
' 　　　　   (Out)    vntRptEndTime  健診受付時間
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectRsvGrpList( _
    Optional ByVal lngSortOrder As Long, _
    Optional ByRef vntRsvGrpCd As Variant, _
    Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntStrTime As Variant, _
    Optional ByRef vntEndTime As Variant, _
    Optional ByRef vntRptEndTime As Variant _
) As Long
    
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvGrpCd         As OraField         '予約群コード
    Dim objRsvGrpName       As OraField         '予約群名称
    Dim objStrTime          As OraField         '開始時間
    Dim objEndTime          As OraField         '終了時間
    Dim objRptEndTime       As OraField         '健診受付終了時間

    Dim vntArrRsvGrpCd()    As Variant          '予約群コードの配列
    Dim vntArrRsvGrpName()  As Variant          '予約群名称の配列
    Dim vntArrStrTime()     As Variant          '開始時間の配列
    Dim vntArrEndTime()     As Variant          '終了時間の配列
    Dim vntArrRptEndTime()  As Variant          '健診受付終了時間の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
    If Not IsMissing(vntStrTime) Then vntStrTime = Empty
    If Not IsMissing(vntEndTime) Then vntEndTime = Empty
    If Not IsMissing(vntRptEndTime) Then vntRptEndTime = Empty
    lngCount = 0

    '予約群テーブルのすべてのレコードを取得
    strStmt = "SELECT RSVGRPCD, RSVGRPNAME, STRTIME, ENDTIME, RPTENDTIME " & vbLf & _
              "  FROM RSVGRP                                             "

    If lngSortOrder = 0 Then
        strStmt = strStmt & vbLf & _
              " ORDER BY RSVGRPCD "
    Else
        strStmt = strStmt & vbLf & _
              " ORDER BY STRTIME, RSVGRPCD "
    End If

    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvGrpCd = objFields("RSVGRPCD")
        Set objRsvGrpName = objFields("RSVGRPNAME")
        Set objStrTime = objFields("STRTIME")
        Set objEndTime = objFields("ENDTIME")
        Set objRptEndTime = objFields("RPTENDTIME")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvGrpCd(lngCount)
            ReDim Preserve vntArrRsvGrpName(lngCount)
            ReDim Preserve vntArrStrTime(lngCount)
            ReDim Preserve vntArrEndTime(lngCount)
            ReDim Preserve vntArrRptEndTime(lngCount)
            
            vntArrRsvGrpCd(lngCount) = objRsvGrpCd.Value & ""
            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
            vntArrStrTime(lngCount) = objStrTime.Value & ""
            vntArrEndTime(lngCount) = objEndTime.Value & ""
            vntArrRptEndTime(lngCount) = objRptEndTime.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = vntArrRsvGrpCd
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
        If Not IsMissing(vntStrTime) Then vntStrTime = vntArrStrTime
        If Not IsMissing(vntEndTime) Then vntEndTime = vntArrEndTime
        If Not IsMissing(vntRptEndTime) Then vntRptEndTime = vntArrRptEndTime

    End If

    '戻り値の設定
    SelectRsvGrpList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectRsvGrpList = -1

    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectRsvGrpList"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'## 2003.09.29 Add By T.Takagi
'
' 機能　　 : すべてのコース予約群を取得する
'
'         : (In)     lngSortOrder   ソート順(0:予約群コード順、0以外:コースコード順)
' 引数　　   (Out)    vntRsvGrpCd    予約群コード
' 　　　　   (Out)    vntmngGender   男女別枠管理
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCrsRsvGrpList( _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntRsvGrpCd As Variant, _
    Optional ByRef vntMngGender As Variant, _
    Optional ByRef vntDefCnt As Variant, _
    Optional ByRef vntDefCnt_M As Variant, _
    Optional ByRef vntDefCnt_F As Variant, _
    Optional ByRef vntDefCnt_Sat As Variant, _
    Optional ByRef vntDefCnt_Sat_M As Variant, _
    Optional ByRef vntDefCnt_Sat_F As Variant, _
    Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntCsName As Variant _
) As Long
    
    Dim objOraDyna           As OraDynaset       'ダイナセット
    Dim strStmt              As String           'SQLステートメント

    Dim objFields            As OraFields        'フィールドオブジェクト
    Dim objRsvGrpCd          As OraField         '予約群コード
    Dim objCsCd              As OraField         'コースコード
    Dim objMngGender         As OraField         '男女別枠管理
    
    Dim objDefCnt            As OraField         'デフォルト人数（共通）
    Dim objDefCnt_M          As OraField         'デフォルト人数（男）
    Dim objDefCnt_F          As OraField         'デフォルト人数（女）
    Dim objDefCnt_Sat        As OraField         'デフォルト人数（土曜共通）
    Dim objDefCnt_Sat_M      As OraField         'デフォルト人数（土曜男）
    Dim objDefCnt_Sat_F      As OraField         'デフォルト人数（土曜女）
    Dim objRsvGrpName        As OraField         '予約群名称
    Dim objCsName            As OraField         'コース名称
    
    Dim vntArrDefCnt()       As Variant          'デフォルト人数（共通）
    Dim vntArrDefCnt_M()     As Variant          'デフォルト人数（男）
    Dim vntArrDefCnt_F()     As Variant          'デフォルト人数（女）
    Dim vntArrDefCnt_Sat()   As Variant          'デフォルト人数（土曜共通）
    Dim vntArrDefCnt_Sat_M() As Variant          'デフォルト人数（土曜男）
    Dim vntArrDefCnt_Sat_F() As Variant          'デフォルト人数（土曜女）
    Dim vntArrRsvGrpCd()     As Variant          '予約群コードの配列
    Dim vntArrCsCd()         As Variant          'コースコードの配列
    Dim vntArrMngGender()    As Variant          '男女別枠管理の配列
    Dim vntArrRsvGrpName()   As Variant          '予約群名称の配列
    Dim vntArrCsName()       As Variant          'コース名称の配列
    Dim lngCount             As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntMngGender) Then vntMngGender = Empty
    If Not IsMissing(vntDefCnt) Then vntDefCnt = Empty
    If Not IsMissing(vntDefCnt_M) Then vntDefCnt_M = Empty
    If Not IsMissing(vntDefCnt_F) Then vntDefCnt_F = Empty
    If Not IsMissing(vntDefCnt_Sat) Then vntDefCnt_Sat = Empty
    If Not IsMissing(vntDefCnt_Sat_M) Then vntDefCnt_Sat_M = Empty
    If Not IsMissing(vntDefCnt_Sat_F) Then vntDefCnt_Sat_F = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    lngCount = 0

    '予約群テーブルのすべてのレコードを取得
    strStmt = "SELECT COURSE_RSVGRP.RSVGRPCD RSVGRPCD, COURSE_RSVGRP.CSCD CSCD, COURSE_RSVGRP.MNGGENDER MNGGENDER, " & vbLf & _
              "       COURSE_RSVGRP.DEFCNT DEFCNT,COURSE_RSVGRP.DEFCNT_M DEFCNT_M,COURSE_RSVGRP.DEFCNT_F DEFCNT_F, " & vbLf & _
              "       COURSE_RSVGRP.DEFCNT_SAT DEFCNT_SAT,COURSE_RSVGRP.DEFCNT_SAT_M DEFCNT_SAT_M,                 " & vbLf & _
              "       COURSE_RSVGRP.DEFCNT_SAT_F DEFCNT_SAT_F, RSVGRP.RSVGRPNAME RSVGRPNAME, COURSE_P.CSNAME CSNAME" & vbLf & _
              "  FROM COURSE_RSVGRP ,RSVGRP,COURSE_P                                                               " & vbLf & _
              " WHERE COURSE_RSVGRP.RSVGRPCD=RSVGRP.RSVGRPCD                                                       " & vbLf & _
              "   AND COURSE_RSVGRP.CSCD=COURSE_P.CSCD                                                             " & vbLf & _
              " ORDER BY COURSE_RSVGRP.CSCD,COURSE_RSVGRP.RSVGRPCD"
    
    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objRsvGrpCd = objFields("RSVGRPCD")
            Set objCsCd = objFields("CSCD")
            Set objMngGender = objFields("MNGGENDER")
            Set objDefCnt = objFields("DEFCNT")
            Set objDefCnt_M = objFields("DEFCNT_M")
            Set objDefCnt_F = objFields("DEFCNT_F")
            Set objDefCnt_Sat = objFields("DEFCNT_SAT")
            Set objDefCnt_Sat_M = objFields("DEFCNT_SAT_M")
            Set objDefCnt_Sat_F = objFields("DEFCNT_SAT_F")
            Set objRsvGrpName = objFields("RSVGRPNAME")
            Set objCsName = objFields("CSNAME")
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvGrpCd(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrMngGender(lngCount)
            ReDim Preserve vntArrDefCnt(lngCount)
            ReDim Preserve vntArrDefCnt_M(lngCount)
            ReDim Preserve vntArrDefCnt_F(lngCount)
            ReDim Preserve vntArrDefCnt_Sat(lngCount)
            ReDim Preserve vntArrDefCnt_Sat_M(lngCount)
            ReDim Preserve vntArrDefCnt_Sat_F(lngCount)
            ReDim Preserve vntArrRsvGrpName(lngCount)
            ReDim Preserve vntArrCsName(lngCount)

            vntArrRsvGrpCd(lngCount) = objRsvGrpCd.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrMngGender(lngCount) = objMngGender.Value & ""
            vntArrDefCnt(lngCount) = objDefCnt.Value & ""
            vntArrDefCnt_M(lngCount) = objDefCnt_M.Value & ""
            vntArrDefCnt_F(lngCount) = objDefCnt_F.Value & ""
            vntArrDefCnt_Sat(lngCount) = objDefCnt_Sat.Value & ""
            vntArrDefCnt_Sat_M(lngCount) = objDefCnt_Sat_M.Value & ""
            vntArrDefCnt_Sat_F(lngCount) = objDefCnt_Sat_F.Value & ""
            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = vntArrRsvGrpCd
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntMngGender) Then vntMngGender = vntArrMngGender
        If Not IsMissing(vntDefCnt) Then vntDefCnt = vntArrDefCnt
        If Not IsMissing(vntDefCnt_M) Then vntDefCnt_M = vntArrDefCnt_M
        If Not IsMissing(vntDefCnt_F) Then vntDefCnt_F = vntArrDefCnt_F
        If Not IsMissing(vntDefCnt_Sat) Then vntDefCnt_Sat = vntArrDefCnt_Sat
        If Not IsMissing(vntDefCnt_Sat_M) Then vntDefCnt_Sat_M = vntArrDefCnt_Sat_M
        If Not IsMissing(vntDefCnt_Sat_F) Then vntDefCnt_Sat_F = vntArrDefCnt_Sat_F
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
    End If

    '戻り値の設定
    SelectCrsRsvGrpList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectCrsRsvGrpList = -1

    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectCrsRsvGrpList"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'## 2003.11.21 Add By K.Fujii
'
' 機能　　 : 検索条件に従って予約人数管理情報の一覧を取得する
'
' 引数　　 : (In)     vntStartCslDate     検索条件受診日（開始）
' 　　　　   (In)     vntEndCslDate       検索条件受診日（終了）
' 　　　　   (In)     vntSearchCsCd       検索条件コースコード
' 　　　　   (In)     vntSearchRsvGrp     検索条件予約群
' 　　　　   (Out)    vntCslDate          受診日
' 　　　　   (Out)    vntCsCd             コースコード
' 　　　　   (Out)    vntCsName           コース名
' 　　　　   (Out)    vntWebColor         コース色
' 　　　　   (Out)    vntRsvGrpCd         予約群コード
' 　　　　   (Out)    vntRsvGrpName       予約群名称
' 　　　　   (Out)    vntMngGender        男女別枠管理
' 　　　　   (Out)    vntMaxCnt           予約可能人数（共通）
' 　　　　   (Out)    vntMaxCnt_M         予約可能人数（男）
' 　　　　   (Out)    vntMaxCnt_F         予約可能人数（女）
' 　　　　   (Out)    vntOverCnt          オーバ可能人数（共通）
' 　　　　   (Out)    vntOverCnt_M        オーバ可能人数（男）
' 　　　　   (Out)    vntOverCnt_F        オーバ可能人数（女）
' 　　　　   (Out)    vntRsvCnt_M         予約済み人数（男）
' 　　　　   (Out)    vntRsvCnt_F         予約済み人数（女）
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectRsvFraMngList( _
    ByVal vntStartCslDate As Variant, ByVal vntEndCslDate As Variant, _
    ByVal vntSearchCsCd As Variant, ByVal vntSearchRsvGrp As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntWebColor As Variant, _
    Optional ByRef vntRsvGrpCd As Variant, _
    Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntMngGender As Variant, _
    Optional ByRef vntMaxCnt As Variant, _
    Optional ByRef vntMaxCnt_M As Variant, _
    Optional ByRef vntMaxCnt_F As Variant, _
    Optional ByRef vntOverCnt As Variant, _
    Optional ByRef vntOverCnt_M As Variant, _
    Optional ByRef vntOverCnt_F As Variant, _
    Optional ByRef vntRsvCnt_M As Variant, _
    Optional ByRef vntRsvCnt_F As Variant _
) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna           As OraDynaset       'ダイナセット
    Dim strStmt              As String           'SQLステートメント

    Dim objFields            As OraFields        'フィールドオブジェクト
    Dim objCslDate           As OraField         '受診日
    Dim objCsCd              As OraField         'コースコード
    Dim objCsName            As OraField         'コース名
    Dim objWebColor          As OraField         'コース色
    Dim objRsvGrpCd          As OraField         '予約群コード
    Dim objRsvGrpName        As OraField         '予約群名称
    Dim objMngGender         As OraField         '男女別枠管理
    Dim objMaxCnt            As OraField         '予約可能人数（共通）
    Dim objMaxCnt_M          As OraField         '予約可能人数（男）
    Dim objMaxCnt_F          As OraField         '予約可能人数（女）
    Dim objOverCnt           As OraField         'オーバ可能人数（共通）
    Dim objOverCnt_M         As OraField         'オーバ可能人数（男）
    Dim objOverCnt_F         As OraField         'オーバ可能人数（女）
    Dim objRsvCnt_M          As OraField         '予約済み人数（男）
    Dim objRsvCnt_F          As OraField         '予約済み人数（女）
        
    Dim vntArrCslDate()          As Variant          '受診日
    Dim vntArrCsCd()             As Variant          'コースコード
    Dim vntArrCsName()           As Variant          'コース名
    Dim vntArrWebColor()         As Variant          'コース色
    Dim vntArrRsvGrpCd()         As Variant          '予約群コード
    Dim vntArrRsvGrpName()       As Variant          '予約群名称
    Dim vntArrMngGender()        As Variant          '男女別枠管理
    Dim vntArrMaxCnt()           As Variant          '予約可能人数（共通）
    Dim vntArrMaxCnt_M()         As Variant          '予約可能人数（男）
    Dim vntArrMaxCnt_F()         As Variant          '予約可能人数（女）
    Dim vntArrOverCnt()          As Variant          'オーバ可能人数（共通）
    Dim vntArrOverCnt_M()        As Variant          'オーバ可能人数（男）
    Dim vntArrOverCnt_F()        As Variant          'オーバ可能人数（女）
    Dim vntArrRsvCnt_M()         As Variant          '予約済み人数（男）
    Dim vntArrRsvCnt_F()         As Variant          '予約済み人数（女）
    
    Dim lngCount             As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
    If Not IsMissing(vntMngGender) Then vntMngGender = Empty
    If Not IsMissing(vntMaxCnt) Then vntMaxCnt = Empty
    If Not IsMissing(vntMaxCnt_M) Then vntMaxCnt_M = Empty
    If Not IsMissing(vntMaxCnt_F) Then vntMaxCnt_F = Empty
    If Not IsMissing(vntOverCnt) Then vntOverCnt = Empty
    If Not IsMissing(vntOverCnt_M) Then vntOverCnt_M = Empty
    If Not IsMissing(vntOverCnt_F) Then vntOverCnt_F = Empty
    If Not IsMissing(vntRsvCnt_M) Then vntRsvCnt_M = Empty
    If Not IsMissing(vntRsvCnt_F) Then vntRsvCnt_F = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    If vntStartCslDate <= vntEndCslDate Then
        objOraParam.Add "SCSLDATE", Format(Trim(vntStartCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "ECSLDATE", Format(Trim(vntEndCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    Else
        objOraParam.Add "SCSLDATE", Format(Trim(vntEndCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "ECSLDATE", Format(Trim(vntStartCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    End If


    '検索条件のレコードを取得
    strStmt = "SELECT RSVFRAMNG.CSLDATE,       RSVFRAMNG.CSCD,      " & vbLf & _
              "       COURSE_P.CSNAME,         COURSE_P.WEBCOLOR,   " & vbLf & _
              "       RSVFRAMNG.RSVGRPCD,      RSVGRP.RSVGRPNAME,   " & vbLf & _
              "       COURSE_RSVGRP.MNGGENDER,                      " & vbLf & _
              "       RSVFRAMNG.MAXCNT,                             " & vbLf & _
              "       RSVFRAMNG.MAXCNT_M,      RSVFRAMNG.MAXCNT_F,  " & vbLf & _
              "       RSVFRAMNG.OVERCNT,                            " & vbLf & _
              "       RSVFRAMNG.OVERCNT_M,     RSVFRAMNG.OVERCNT_F, " & vbLf & _
              "       RSVFRAMNG.RSVCNT_M,      RSVFRAMNG.RSVCNT_F   " & vbLf & _
              "  FROM RSVFRAMNG, COURSE_P, RSVGRP, COURSE_RSVGRP    " & vbLf & _
              " WHERE RSVFRAMNG.CSLDATE >= :SCSLDATE                " & vbLf & _
              "   AND RSVFRAMNG.CSLDATE <= :ECSLDATE                "
              
    'コース指定あり？
    If vntSearchCsCd <> "" Then
        objOraParam.Add "CSCD", Trim(vntSearchCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
              "   AND RSVFRAMNG.CSCD     = :CSCD "
    End If
    
    '予約群指定あり？
    If vntSearchRsvGrp <> "" Then
        objOraParam.Add "RSVGRPCD", Trim(vntSearchRsvGrp), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
              "   AND RSVFRAMNG.RSVGRPCD = :RSVGRPCD "
    End If
    
    strStmt = strStmt & vbLf & _
              "   AND COURSE_P.CSCD(+)   = RSVFRAMNG.CSCD           " & vbLf & _
              "   AND RSVGRP.RSVGRPCD(+) = RSVFRAMNG.RSVGRPCD       " & vbLf & _
              "   AND COURSE_RSVGRP.CSCD = RSVFRAMNG.CSCD           " & vbLf & _
              "   AND COURSE_RSVGRP.RSVGRPCD = RSVFRAMNG.RSVGRPCD   "

'#### 2013.2.28 SL-SN-Y0101-612 ADD START ####
    strStmt = strStmt & vbLf & _
              " ORDER BY RSVFRAMNG.CSLDATE, RSVFRAMNG.CSCD, RSVFRAMNG.RSVGRPCD"
'#### 2013.2.28 SL-SN-Y0101-612 ADD END   ####
    
    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objCslDate = objFields("CSLDATE")
            Set objCsCd = objFields("CSCD")
            Set objCsName = objFields("CSNAME")
            Set objWebColor = objFields("WEBCOLOR")
            Set objRsvGrpCd = objFields("RSVGRPCD")
            Set objRsvGrpName = objFields("RSVGRPNAME")
            Set objMngGender = objFields("MNGGENDER")
            Set objMaxCnt = objFields("MAXCNT")
            Set objMaxCnt_M = objFields("MAXCNT_M")
            Set objMaxCnt_F = objFields("MAXCNT_F")
            Set objOverCnt = objFields("OVERCNT")
            Set objOverCnt_M = objFields("OVERCNT_M")
            Set objOverCnt_F = objFields("OVERCNT_F")
            Set objRsvCnt_M = objFields("RSVCNT_M")
            Set objRsvCnt_F = objFields("RSVCNT_F")
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrRsvGrpCd(lngCount)
            ReDim Preserve vntArrRsvGrpName(lngCount)
            ReDim Preserve vntArrMngGender(lngCount)
            ReDim Preserve vntArrMaxCnt(lngCount)
            ReDim Preserve vntArrMaxCnt_M(lngCount)
            ReDim Preserve vntArrMaxCnt_F(lngCount)
            ReDim Preserve vntArrOverCnt(lngCount)
            ReDim Preserve vntArrOverCnt_M(lngCount)
            ReDim Preserve vntArrOverCnt_F(lngCount)
            ReDim Preserve vntArrRsvCnt_M(lngCount)
            ReDim Preserve vntArrRsvCnt_F(lngCount)

            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrRsvGrpCd(lngCount) = objRsvGrpCd.Value & ""
            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
            vntArrMngGender(lngCount) = objMngGender.Value & ""
            vntArrMaxCnt(lngCount) = objMaxCnt.Value & ""
            vntArrMaxCnt_M(lngCount) = objMaxCnt_M.Value & ""
            vntArrMaxCnt_F(lngCount) = objMaxCnt_F.Value & ""
            vntArrOverCnt(lngCount) = objOverCnt.Value & ""
            vntArrOverCnt_M(lngCount) = objOverCnt_M.Value & ""
            vntArrOverCnt_F(lngCount) = objOverCnt_F.Value & ""
            vntArrRsvCnt_M(lngCount) = objRsvCnt_M.Value & ""
            vntArrRsvCnt_F(lngCount) = objRsvCnt_F.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = vntArrRsvGrpCd
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
        If Not IsMissing(vntMngGender) Then vntMngGender = vntArrMngGender
        If Not IsMissing(vntMaxCnt) Then vntMaxCnt = vntArrMaxCnt
        If Not IsMissing(vntMaxCnt_M) Then vntMaxCnt_M = vntArrMaxCnt_M
        If Not IsMissing(vntMaxCnt_F) Then vntMaxCnt_F = vntArrMaxCnt_F
        If Not IsMissing(vntOverCnt) Then vntOverCnt = vntArrOverCnt
        If Not IsMissing(vntOverCnt_M) Then vntOverCnt_M = vntArrOverCnt_M
        If Not IsMissing(vntOverCnt_F) Then vntOverCnt_F = vntArrOverCnt_F
        If Not IsMissing(vntRsvCnt_M) Then vntRsvCnt_M = vntArrRsvCnt_M
        If Not IsMissing(vntRsvCnt_F) Then vntRsvCnt_F = vntArrRsvCnt_F
    End If

'### 2003.02.05 Added by Ishihara@FSIT バインド変数そのまま放置
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2003.02.05 Added End

    '戻り値の設定
    SelectRsvFraMngList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectRsvFraMngList = -1

    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectRsvFraMngList"

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

'## 2003.11.30 Add By T.Takagi@FSIT
'
' 機能　　 : 検索条件に従って予約人数管理情報の一覧を取得する
'
' 引数　　 : (In)     dtmStrCslDate  開始受診日
' 　　　　   (In)     dtmEndCslDate  終了受診日
' 　　　　   (In)     vntSelCsCd     コースコード
' 　　　　   (In)     strRsvGrpCd    予約群コード
' 　　　　   (Out)    vntCslDate     受診日
' 　　　　   (Out)    vntHoliday     休診日
' 　　　　   (Out)    vntRsvGrpCd    予約群コード
' 　　　　   (Out)    vntRsvGrpName  予約群名称
' 　　　　   (Out)    vntStrTime     開始時間
' 　　　　   (Out)    vntCsCd        コースコード
' 　　　　   (Out)    vntCsName      コース名
' 　　　　   (Out)    vntCsSName     コース略称
' 　　　　   (Out)    vntWebColor    webカラー
' 　　　　   (Out)    vntMngGender   男女別枠管理
' 　　　　   (Out)    vntMaxCnt      予約可能人数（共通）
' 　　　　   (Out)    vntMaxCnt_M    予約可能人数（男）
' 　　　　   (Out)    vntMaxCnt_F    予約可能人数（女）
' 　　　　   (Out)    vntOverCnt     オーバ可能人数（共通）
' 　　　　   (Out)    vntOverCnt_M   オーバ可能人数（男）
' 　　　　   (Out)    vntOverCnt_F   オーバ可能人数（女）
' 　　　　   (Out)    vntRsvCnt_M    予約済み人数（男）
' 　　　　   (Out)    vntRsvCnt_F    予約済み人数（女）
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'## 2003.12.09 Mod By T.Takagi@FSIT コース複数選択
'Public Function SelectRsvFraMngList_Capacity(
'    ByVal dtmStrCslDate As Date,
'    ByVal dtmEndCslDate As Date,
'    ByVal strCsCd As String,
'    Optional ByVal strRsvGrpCd As String,
'    Optional ByRef vntCslDate As Variant,
'    Optional ByRef vntHoliday As Variant,
'    Optional ByRef vntRsvGrpCd As Variant,
'    Optional ByRef vntRsvGrpName As Variant,
'    Optional ByRef vntStrTime As Variant,
'    Optional ByRef vntCsCd As Variant,
'    Optional ByRef vntCsName As Variant,
'    Optional ByRef vntCsSName As Variant,
'    Optional ByRef vntWebColor As Variant,
'    Optional ByRef vntMngGender As Variant,
'    Optional ByRef vntMaxCnt As Variant,
'    Optional ByRef vntMaxCnt_M As Variant,
'    Optional ByRef vntMaxCnt_F As Variant,
'    Optional ByRef vntOverCnt As Variant,
'    Optional ByRef vntOverCnt_M As Variant,
'    Optional ByRef vntOverCnt_F As Variant,
'    Optional ByRef vntRsvCnt_M As Variant,
'    Optional ByRef vntRsvCnt_F As Variant
') As Long
Public Function SelectRsvFraMngList_Capacity( _
    ByVal dtmStrCslDate As Date, _
    ByVal dtmEndCslDate As Date, _
    ByRef vntSelCsCd As Variant, _
    Optional ByVal strRsvGrpCd As String, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntHoliday As Variant, _
    Optional ByRef vntRsvGrpCd As Variant, _
    Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntStrTime As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntCsSName As Variant, _
    Optional ByRef vntWebColor As Variant, _
    Optional ByRef vntMngGender As Variant, _
    Optional ByRef vntMaxCnt As Variant, _
    Optional ByRef vntMaxCnt_M As Variant, _
    Optional ByRef vntMaxCnt_F As Variant, _
    Optional ByRef vntOverCnt As Variant, _
    Optional ByRef vntOverCnt_M As Variant, _
    Optional ByRef vntOverCnt_F As Variant, _
    Optional ByRef vntRsvCnt_M As Variant, _
    Optional ByRef vntRsvCnt_F As Variant _
) As Long
'## 2003.12.09 Mod End
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objParaCslDate      As OraParamArray    '受診日
    
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCslDate          As OraField         '受診日
    Dim objHoliday          As OraField         '休診日
    Dim objRsvGrpCd         As OraField         '予約群コード
    Dim objRsvGrpName       As OraField         '予約群名称
    Dim objStrTime          As OraField         '開始時間
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objCsSName          As OraField         'コース略称
    Dim objWebColor         As OraField         'webカラー
    Dim objMngGender        As OraField         '男女別枠管理
    Dim objMaxCnt           As OraField         '予約可能人数（共通）
    Dim objMaxCnt_M         As OraField         '予約可能人数（男）
    Dim objMaxCnt_F         As OraField         '予約可能人数（女）
    Dim objOverCnt          As OraField         'オーバ可能人数（共通）
    Dim objOverCnt_M        As OraField         'オーバ可能人数（男）
    Dim objOverCnt_F        As OraField         'オーバ可能人数（女）
    Dim objRsvCnt_M         As OraField         '予約済み人数（男）
    Dim objRsvCnt_F         As OraField         '予約済み人数（女）
        
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrHoliday()     As Variant          '休診日の配列
    Dim vntArrRsvGrpCd()    As Variant          '予約群コードの配列
    Dim vntArrRsvGrpName()  As Variant          '予約群名称の配列
    Dim vntArrStrTime()     As Variant          '開始時間の配列
    Dim vntArrCsCd()        As Variant          'コースコードの配列
    Dim vntArrCsName()      As Variant          'コース名の配列
    Dim vntArrCsSName()     As Variant          'コース略称の配列
    Dim vntArrWebColor()    As Variant          'webカラーの配列
    Dim vntArrMngGender()   As Variant          '男女別枠管理の配列
    Dim vntArrMaxCnt()      As Variant          '予約可能人数（共通）の配列
    Dim vntArrMaxCnt_M()    As Variant          '予約可能人数（男）の配列
    Dim vntArrMaxCnt_F()    As Variant          '予約可能人数（女）の配列
    Dim vntArrOverCnt()     As Variant          'オーバ可能人数（共通）の配列
    Dim vntArrOverCnt_M()   As Variant          'オーバ可能人数（男）の配列
    Dim vntArrOverCnt_F()   As Variant          'オーバ可能人数（女）の配列
    Dim vntArrRsvCnt_M()    As Variant          '予約済み人数（男）の配列
    Dim vntArrRsvCnt_F()    As Variant          '予約済み人数（女）の配列
    Dim lngCount            As Long             'レコード数

    Dim dtmCslDate          As Date             '受診日
    Dim lngArraySize        As Long             '配列の要素数
    Dim i                   As Long             'インデックス
    
'## 2003.12.09 Add By T.Takagi@FSIT コース複数選択
    Dim blnExists           As Boolean          '存在フラグ
'## 2003.12.09 Add End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntHoliday) Then vntHoliday = Empty
    If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
    If Not IsMissing(vntStrTime) Then vntStrTime = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntCsSName) Then vntCsSName = Empty
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntMngGender) Then vntMngGender = Empty
    If Not IsMissing(vntMaxCnt) Then vntMaxCnt = Empty
    If Not IsMissing(vntMaxCnt_M) Then vntMaxCnt_M = Empty
    If Not IsMissing(vntMaxCnt_F) Then vntMaxCnt_F = Empty
    If Not IsMissing(vntOverCnt) Then vntOverCnt = Empty
    If Not IsMissing(vntOverCnt_M) Then vntOverCnt_M = Empty
    If Not IsMissing(vntOverCnt_F) Then vntOverCnt_F = Empty
    If Not IsMissing(vntRsvCnt_M) Then vntRsvCnt_M = Empty
    If Not IsMissing(vntRsvCnt_F) Then vntRsvCnt_F = Empty
    lngCount = 0

    'パラメータの設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "TRANSNO", Null, ORAPARM_BOTH, ORATYPE_NUMBER

    'トランザクション番号の取得
    mobjOraDb.ExecuteSQL "BEGIN :TRANSNO := ContractPackage.GetTransNo; END;"

    '受診日の大小を比較し、逆転時は入れ替える
    If dtmEndCslDate < dtmStrCslDate Then
        dtmCslDate = dtmEndCslDate
        dtmEndCslDate = dtmStrCslDate
        dtmStrCslDate = dtmCslDate
    End If
    
    '配列の要素数を計算
    lngArraySize = dtmEndCslDate - dtmStrCslDate + 1
    
    'パラメータ配列の定義
    objOraParam.AddTable "CSLDATE", ORAPARM_INPUT, ORATYPE_DATE, lngArraySize
    Set objParaCslDate = objOraParam("CSLDATE")
    
    '引数値の値設定
    i = 0
    dtmCslDate = dtmStrCslDate
    Do Until dtmCslDate > dtmEndCslDate
        objParaCslDate(i) = dtmCslDate
        dtmCslDate = dtmCslDate + 1
        i = i + 1
    Loop

    '受診日一時表の作成
    mobjOraDb.ExecuteSQL "BEGIN ContractPackage.CreateCslDate(:TRANSNO, :CSLDATE); END;"

    '条件値の設定
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
'## 2003.12.09 Del By T.Takagi@FSIT コース複数選択
'    objOraParam.Add "CSCD", IIf(strCsCd <> "", strCsCd, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.09 Del End

    strStmt = " SELECT BASEINFO.CSLDATE,    SCHEDULE_H.HOLIDAY,  BASEINFO.RSVGRPCD,   " & vbLf & _
              "        BASEINFO.RSVGRPNAME, BASEINFO.STRTIME,    BASEINFO.CSCD,       " & vbLf & _
              "        COURSE_P.CSNAME,     COURSE_P.CSSNAME,    COURSE_P.WEBCOLOR,   " & vbLf & _
              "        COURSE_RSVGRP.MNGGENDER,                                       " & vbLf & _
              "        RSVFRAMNG.MAXCNT,    RSVFRAMNG.MAXCNT_M,  RSVFRAMNG.MAXCNT_F,  " & vbLf & _
              "        RSVFRAMNG.OVERCNT,   RSVFRAMNG.OVERCNT_M, RSVFRAMNG.OVERCNT_F, " & vbLf & _
              "        RSVFRAMNG.RSVCNT_M,  RSVFRAMNG.RSVCNT_F                        "

    strStmt = strStmt & vbLf & _
              "   FROM RSVFRAMNG,                                                    " & vbLf & _
              "        COURSE_RSVGRP, COURSE_P, SCHEDULE_H,                          " & vbLf & _
              "        ( SELECT CSLDATE_TEMP.CSLDATE,                                " & vbLf & _
              "                 RSVGRP.RSVGRPCD, RSVGRP.RSVGRPNAME, RSVGRP.STRTIME,  " & vbLf & _
              "                 MNGCOURSE.CSCD                                       " & vbLf & _
              "            FROM RSVGRP,                                              " & vbLf & _
              "                 ( SELECT CSCD                                        " & vbLf & _
              "                     FROM COURSE_RSVGRP                               " & vbLf & _
              "                    UNION                                             " & vbLf & _
              "                   SELECT CSCD                                        " & vbLf & _
              "                     FROM RSVFRAMNG                                   " & vbLf & _
              "                    WHERE CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE " & vbLf & _
              "                 ) MNGCOURSE,                                         " & vbLf & _
              "                 CSLDATE_TEMP                                         " & vbLf & _
              "           WHERE CSLDATE_TEMP.TRANSNO = :TRANSNO                      " & vbLf & _
              "        ) BASEINFO                                                    "

'## 2003.12.09 Mod By T.Takagi@FSIT コース複数選択
'    strStmt = strStmt & vbLf & _
'              "  WHERE BASEINFO.CSLDATE  = SCHEDULE_H.CSLDATE(+)             " & vbLf & _
'              "    AND BASEINFO.CSCD     = NVL(:CSCD, BASEINFO.CSCD)         " & vbLf & _
'              "    AND BASEINFO.CSCD     = COURSE_P.CSCD                     " & vbLf & _
'              "    AND BASEINFO.CSCD     = COURSE_RSVGRP.CSCD(+)             " & vbLf & _
'              "    AND BASEINFO.RSVGRPCD = COURSE_RSVGRP.RSVGRPCD(+)         " & vbLf & _
'              "    AND BASEINFO.CSLDATE  = RSVFRAMNG.CSLDATE(+)              " & vbLf & _
'              "    AND BASEINFO.CSCD     = RSVFRAMNG.CSCD(+)                 " & vbLf & _
'              "    AND BASEINFO.RSVGRPCD = RSVFRAMNG.RSVGRPCD(+)             " & vbLf & _
'              "  ORDER BY BASEINFO.CSLDATE, BASEINFO.RSVGRPCD, BASEINFO.CSCD "
    strStmt = strStmt & vbLf & _
              "  WHERE BASEINFO.CSLDATE  = SCHEDULE_H.CSLDATE(+)             " & vbLf & _
              "    AND BASEINFO.CSCD     = COURSE_P.CSCD                     " & vbLf & _
              "    AND BASEINFO.CSCD     = COURSE_RSVGRP.CSCD(+)             " & vbLf & _
              "    AND BASEINFO.RSVGRPCD = COURSE_RSVGRP.RSVGRPCD(+)         " & vbLf & _
              "    AND BASEINFO.CSLDATE  = RSVFRAMNG.CSLDATE(+)              " & vbLf & _
              "    AND BASEINFO.CSCD     = RSVFRAMNG.CSCD(+)                 " & vbLf & _
              "    AND BASEINFO.RSVGRPCD = RSVFRAMNG.RSVGRPCD(+)             " & vbLf & _
              "  ORDER BY BASEINFO.CSLDATE, BASEINFO.RSVGRPCD, BASEINFO.CSCD "
'## 2003.12.09 Mod End
    
    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objHoliday = objFields("HOLIDAY")
        Set objRsvGrpCd = objFields("RSVGRPCD")
        Set objRsvGrpName = objFields("RSVGRPNAME")
        Set objStrTime = objFields("STRTIME")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objCsSName = objFields("CSSNAME")
        Set objWebColor = objFields("WEBCOLOR")
        Set objMngGender = objFields("MNGGENDER")
        Set objMaxCnt = objFields("MAXCNT")
        Set objMaxCnt_M = objFields("MAXCNT_M")
        Set objMaxCnt_F = objFields("MAXCNT_F")
        Set objOverCnt = objFields("OVERCNT")
        Set objOverCnt_M = objFields("OVERCNT_M")
        Set objOverCnt_F = objFields("OVERCNT_F")
        Set objRsvCnt_M = objFields("RSVCNT_M")
        Set objRsvCnt_F = objFields("RSVCNT_F")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
'## 2003.12.09 Mod By T.Takagi@FSIT コース複数選択
'            ReDim Preserve vntArrCslDate(lngCount)
'            ReDim Preserve vntArrHoliday(lngCount)
'            ReDim Preserve vntArrRsvGrpCd(lngCount)
'            ReDim Preserve vntArrRsvGrpName(lngCount)
'            ReDim Preserve vntArrStrTime(lngCount)
'            ReDim Preserve vntArrCsCd(lngCount)
'            ReDim Preserve vntArrCsName(lngCount)
'            ReDim Preserve vntArrCsSName(lngCount)
'            ReDim Preserve vntArrWebColor(lngCount)
'            ReDim Preserve vntArrMngGender(lngCount)
'            ReDim Preserve vntArrMaxCnt(lngCount)
'            ReDim Preserve vntArrMaxCnt_M(lngCount)
'            ReDim Preserve vntArrMaxCnt_F(lngCount)
'            ReDim Preserve vntArrOverCnt(lngCount)
'            ReDim Preserve vntArrOverCnt_M(lngCount)
'            ReDim Preserve vntArrOverCnt_F(lngCount)
'            ReDim Preserve vntArrRsvCnt_M(lngCount)
'            ReDim Preserve vntArrRsvCnt_F(lngCount)
'            vntArrCslDate(lngCount) = objCslDate.Value & ""
'            vntArrHoliday(lngCount) = objHoliday.Value & ""
'            vntArrRsvGrpCd(lngCount) = objRsvGrpCd.Value & ""
'            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
'            vntArrStrTime(lngCount) = objStrTime.Value & ""
'            vntArrCsCd(lngCount) = objCsCd.Value & ""
'            vntArrCsName(lngCount) = objCsName.Value & ""
'            vntArrCsSName(lngCount) = objCsSName.Value & ""
'            vntArrWebColor(lngCount) = objWebColor.Value & ""
'            vntArrMngGender(lngCount) = objMngGender.Value & ""
'            vntArrMaxCnt(lngCount) = objMaxCnt.Value & ""
'            vntArrMaxCnt_M(lngCount) = objMaxCnt_M.Value & ""
'            vntArrMaxCnt_F(lngCount) = objMaxCnt_F.Value & ""
'            vntArrOverCnt(lngCount) = objOverCnt.Value & ""
'            vntArrOverCnt_M(lngCount) = objOverCnt_M.Value & ""
'            vntArrOverCnt_F(lngCount) = objOverCnt_F.Value & ""
'            vntArrRsvCnt_M(lngCount) = objRsvCnt_M.Value & ""
'            vntArrRsvCnt_F(lngCount) = objRsvCnt_F.Value & ""
'            lngCount = lngCount + 1
            Do
            
                blnExists = False
                
                '配列でコースが渡されていない場合は対象としない
                If Not IsArray(vntSelCsCd) Then
                    Exit Do
                End If
                
                '現レコードのコースが引数指定されたそれに含まれるかを検索
                For i = 0 To UBound(vntSelCsCd)
                    If CStr(objCsCd.Value & "") = CStr(vntSelCsCd(i)) Then
                        blnExists = True
                        Exit For
                    End If
                Next i
                        
                '含まれない場合はスキップ
                If Not blnExists Then
                    Exit Do
                End If
            
                ReDim Preserve vntArrCslDate(lngCount)
                ReDim Preserve vntArrHoliday(lngCount)
                ReDim Preserve vntArrRsvGrpCd(lngCount)
                ReDim Preserve vntArrRsvGrpName(lngCount)
                ReDim Preserve vntArrStrTime(lngCount)
                ReDim Preserve vntArrCsCd(lngCount)
                ReDim Preserve vntArrCsName(lngCount)
                ReDim Preserve vntArrCsSName(lngCount)
                ReDim Preserve vntArrWebColor(lngCount)
                ReDim Preserve vntArrMngGender(lngCount)
                ReDim Preserve vntArrMaxCnt(lngCount)
                ReDim Preserve vntArrMaxCnt_M(lngCount)
                ReDim Preserve vntArrMaxCnt_F(lngCount)
                ReDim Preserve vntArrOverCnt(lngCount)
                ReDim Preserve vntArrOverCnt_M(lngCount)
                ReDim Preserve vntArrOverCnt_F(lngCount)
                ReDim Preserve vntArrRsvCnt_M(lngCount)
                ReDim Preserve vntArrRsvCnt_F(lngCount)
                vntArrCslDate(lngCount) = objCslDate.Value & ""
                vntArrHoliday(lngCount) = objHoliday.Value & ""
                vntArrRsvGrpCd(lngCount) = objRsvGrpCd.Value & ""
                vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
                vntArrStrTime(lngCount) = objStrTime.Value & ""
                vntArrCsCd(lngCount) = objCsCd.Value & ""
                vntArrCsName(lngCount) = objCsName.Value & ""
                vntArrCsSName(lngCount) = objCsSName.Value & ""
                vntArrWebColor(lngCount) = objWebColor.Value & ""
                vntArrMngGender(lngCount) = objMngGender.Value & ""
                vntArrMaxCnt(lngCount) = objMaxCnt.Value & ""
                vntArrMaxCnt_M(lngCount) = objMaxCnt_M.Value & ""
                vntArrMaxCnt_F(lngCount) = objMaxCnt_F.Value & ""
                vntArrOverCnt(lngCount) = objOverCnt.Value & ""
                vntArrOverCnt_M(lngCount) = objOverCnt_M.Value & ""
                vntArrOverCnt_F(lngCount) = objOverCnt_F.Value & ""
                vntArrRsvCnt_M(lngCount) = objRsvCnt_M.Value & ""
                vntArrRsvCnt_F(lngCount) = objRsvCnt_F.Value & ""
                lngCount = lngCount + 1
            
                Exit Do
            Loop
            
            objOraDyna.MoveNext
        Loop

        Set objCslDate = Nothing
        Set objHoliday = Nothing
        Set objRsvGrpCd = Nothing
        Set objRsvGrpName = Nothing
        Set objStrTime = Nothing
        Set objCsCd = Nothing
        Set objCsName = Nothing
        Set objCsSName = Nothing
        Set objWebColor = Nothing
        Set objMngGender = Nothing
        Set objMaxCnt = Nothing
        Set objMaxCnt_M = Nothing
        Set objMaxCnt_F = Nothing
        Set objOverCnt = Nothing
        Set objOverCnt_M = Nothing
        Set objOverCnt_F = Nothing
        Set objRsvCnt_M = Nothing
        Set objRsvCnt_F = Nothing
        Set objFields = Nothing

        '戻り値の設定
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntHoliday) Then vntHoliday = vntArrHoliday
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = vntArrRsvGrpCd
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
        If Not IsMissing(vntStrTime) Then vntStrTime = vntArrStrTime
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntCsSName) Then vntCsSName = vntArrCsSName
        If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
        If Not IsMissing(vntMngGender) Then vntMngGender = vntArrMngGender
        If Not IsMissing(vntMaxCnt) Then vntMaxCnt = vntArrMaxCnt
        If Not IsMissing(vntMaxCnt_M) Then vntMaxCnt_M = vntArrMaxCnt_M
        If Not IsMissing(vntMaxCnt_F) Then vntMaxCnt_F = vntArrMaxCnt_F
        If Not IsMissing(vntOverCnt) Then vntOverCnt = vntArrOverCnt
        If Not IsMissing(vntOverCnt_M) Then vntOverCnt_M = vntArrOverCnt_M
        If Not IsMissing(vntOverCnt_F) Then vntOverCnt_F = vntArrOverCnt_F
        If Not IsMissing(vntRsvCnt_M) Then vntRsvCnt_M = vntArrRsvCnt_M
        If Not IsMissing(vntRsvCnt_F) Then vntRsvCnt_F = vntArrRsvCnt_F
    
    End If

    Set objOraDyna = Nothing
    
    '受診日一時表のクリア
    mobjOraDb.ExecuteSQL "BEGIN ContractPackage.Clear(:TRANSNO); END;"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    '戻り値の設定
    SelectRsvFraMngList_Capacity = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectRsvFraMngList_Capacity = -1

    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectRsvFraMngList_Capacity"

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

'## 2003.11.21 Add By K.Fujii
'
' 機能　　 : 予約人数管理情報を登録する
'
' 引数　　 : (In)    strMode            モード insert:新規、update:修正
' 　　　　   (In)    strCslDate         受診日
' 　　　　   (In)    strCsCd            コースコード
' 　　　　   (In)    lngRsvGrpCd        予約群コード
' 　　　　   (In)    lngMaxCnt          予約可能人数（共通）
' 　　　　   (In)    lngMaxCnt_M        予約可能人数（男）
' 　　　　   (In)    lngMaxCnt_F        予約可能人数（女）
' 　　　　   (In)    lngOverCnt         オーバ可能人数（共通）
' 　　　　   (In)    lngOverCnt_M       オーバ可能人数（男）
' 　　　　   (In)    lngOverCnt_F       オーバ可能人数（女）
'以下は画面からは渡さないことにする　2003.12.16 by FFCS
' 　　　　   (In)    lngRsvCnt_M        予約済み人数（男）
' 　　　　   (In)    lngRsvCnt_F        予約済み人数（女）
'
' 戻り値　 : エラーメッセージ
'
'
' 備考　　 :
'
Public Function UpdateRsvFraMngInfo( _
    ByVal strMode As String, _
    ByVal strCslDate As String, _
    ByVal strCsCd As String, _
    ByVal lngRsvGrpCd As Long, _
    ByVal lngMaxCnt As Long, _
    ByVal lngMaxCnt_M As Long, _
    ByVal lngMaxCnt_F As Long, _
    ByVal lngOverCnt As Long, _
    ByVal lngOverCnt_M As Long, _
    ByVal lngOverCnt_F As Long _
) As Variant
'''## パラメータから削除 2003.12.16
'    ByVal lngRsvCnt_M As Long, _
'    ByVal lngRsvCnt_F As Long _

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

'## 2004.03.12 Del By T.Takagi@FSIT 未使用変数
'    Dim objFields       As OraFields        'フィールドオブジェクト
'    Dim objMngGender    As OraField         '男女別枠管理
'
'    Dim vntMngGender    As Variant          '男女別枠管理
'## 2004.03.12 Del End
    
'''## 変数として定義　2003.12.16
    Dim lngRsvCnt_M As Long                 '予約済み人数（男）
    Dim lngRsvCnt_F As Long                 '予約済み人数（女）

    Dim lngRet          As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    UpdateRsvFraMngInfo = Empty
    
        'モードにより処理判断
    Select Case strMode
        Case "insert"
            lngRet = InsertRsvFraMng(strCslDate, strCsCd, lngRsvGrpCd, _
                                      lngMaxCnt, lngMaxCnt_M, lngMaxCnt_F, _
                                      lngOverCnt, lngOverCnt_M, lngOverCnt_F, _
                                      lngRsvCnt_M, lngRsvCnt_F)
        Case "update"
            lngRet = UpdateRsvFraMng(strCslDate, strCsCd, lngRsvGrpCd, _
                                      lngMaxCnt, lngMaxCnt_M, lngMaxCnt_F, _
                                      lngOverCnt, lngOverCnt_M, lngOverCnt_F, _
                                      lngRsvCnt_M, lngRsvCnt_F)
        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
    
    Select Case lngRet
        Case -1
            UpdateRsvFraMngInfo = Array("指定のコース、予約群の組み合わせは存在しません。")
'### 2004/2/5 Modified by Ishihara@FSIT Insert前に存在チェックし、メッセージもイマイチ
'        Case -2
'            UpdateRsvFraMngInfo = Array("共通の人数は入力できません。")
'        Case -3
'            UpdateRsvFraMngInfo = Array("男女別の人数は入力できません。")
'        Case Else
        Case -2
            UpdateRsvFraMngInfo = Array("共通人数は入力できません。コース受診予約群マスタの設定を確認してください。")
        Case -3
            UpdateRsvFraMngInfo = Array("男女別人数は入力できません。コース受診予約群マスタの設定を確認してください。")
        Case -4
            UpdateRsvFraMngInfo = Array("入力された受診日、コース、予約群はすでに枠設定されています。")
        Case Else
'### 2004/2/5 Modified End
    End Select

'## 2004.03.12 Add By T.Takagi@FSIT 実績人数更新(ここに追加するということが登録時にSQLが２回呼ばれることになるが、実績人数取得用のSQLが難解なものであるため一元管理する)
    If IsEmpty(UpdateRsvFraMngInfo) Then
    
        'バインド変数の定義
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "CSLDATE", CDate(strCslDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "RSVGRPCD", lngRsvGrpCd, ORAPARM_INPUT, ORATYPE_NUMBER

'#### 2013.2.28 SL-SN-Y0101-612 UPD START ####
''## 2005.03.16 Mod By T.Takagi@FSIT 受診情報から得られる予約人数がなく、かつweb予約情報が存在する場合、web予約の人数がカウントできない
''        '予約人数を計算(存在しない場合は０)
''        strStmt = "SELECT NVL(REALRSVFRAMNG.RSVCNT_M, 0) + NVL(WEB_RSVFRAMNG.RSVCNT_M, 0) RSVCNT_M, " & vbLf & _
''                  "       NVL(REALRSVFRAMNG.RSVCNT_F, 0) + NVL(WEB_RSVFRAMNG.RSVCNT_F, 0) RSVCNT_F  "
''
''        'web予約から得られる予約人数情報
''        strStmt = strStmt & vbLf & _
''                  "  FROM ( SELECT WEB_RSVFRAMNG.CSLDATE, WEB_RSVFRAMNG.CSCD, WEB_RSVFRAMNG.RSVGRPCD,    " & vbLf & _
''                  "                COUNT(DECODE(WEB_YOYAKU.SEXFLG, 1, WEB_YOYAKU.WEBNO, NULL)) RSVCNT_M, " & vbLf & _
''                  "                COUNT(DECODE(WEB_YOYAKU.SEXFLG, 2, WEB_YOYAKU.WEBNO, NULL)) RSVCNT_F  " & vbLf & _
''                  "           FROM HAINSNET.WEB_YOYAKU, HAINSNET.WEB_RSVFRAMNG                           " & vbLf & _
''                  "          WHERE WEB_RSVFRAMNG.CSLDATE = :CSLDATE                                      " & vbLf & _
''                  "            AND WEB_RSVFRAMNG.WEBNO   = WEB_YOYAKU.WEBNO                              " & vbLf & _
''                  "            AND WEB_YOYAKU.YKBN      != 2                                             " & vbLf & _
''                  "          GROUP BY WEB_RSVFRAMNG.CSLDATE, WEB_RSVFRAMNG.CSCD, WEB_RSVFRAMNG.RSVGRPCD  " & vbLf & _
''                  "       ) WEB_RSVFRAMNG,                                                               "
''
''        '受診情報から得られる予約人数情報
''        strStmt = strStmt & vbLf & _
''                  "       ( SELECT SUBQUERY.CSLDATE, SUBQUERY.CSCD, SUBQUERY.RSVGRPCD, "
''
''        '先にUNION ALLで指定しているため、同一予約番号にて複数存在するコース、予約群に関しては重複を１つとしてカウント
''        'かつNULL値がカウントされない性質を利用し、性別による振り分けを行う
''        strStmt = strStmt & vbLf & _
''                  "                COUNT(DISTINCT DECODE(PERSON.GENDER, 1, SUBQUERY.RSVNO, NULL)) RSVCNT_M, " & vbLf & _
''                  "                COUNT(DISTINCT DECODE(PERSON.GENDER, 2, SUBQUERY.RSVNO, NULL)) RSVCNT_F  " & vbLf & _
''                  "           FROM PERSON,                                                                  "
''
''        '受診情報本体から枠管理されるコース、予約群を取得
''        strStmt = strStmt & vbLf & _
''                  "                ( SELECT CONSULT.RSVNO,    CONSULT.CSLDATE, CONSULT.CSCD,     " & vbLf & _
''                  "                         CONSULT.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
''                  "                    FROM CONSULT                                              "
''
''
''        '後で重複は除きつつカウントするためここではUNION ALL指定(２回ソート処理が走るのは嫌)
''        strStmt = strStmt & vbLf & _
''                  "                   UNION ALL "
''
''        'セット情報から枠管理されるコース、予約群を取得
''        strStmt = strStmt & vbLf & _
''                  "                  SELECT CONSULT.RSVNO,    CONSULT.CSLDATE, RSVFRA_C.CSCD,    " & vbLf & _
''                  "                         CONSULT.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
''                  "                    FROM RSVFRA_C, CTRPT_OPT, CONSULT_O, CONSULT              " & vbLf & _
''                  "                   WHERE CONSULT.RSVNO         = CONSULT_O.RSVNO              " & vbLf & _
''                  "                     AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD            " & vbLf & _
''                  "                     AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD              " & vbLf & _
''                  "                     AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO        " & vbLf & _
''                  "                     AND CTRPT_OPT.RSVFRACD    = RSVFRA_C.RSVFRACD            " & vbLf & _
''                  "                ) SUBQUERY                                                    "
''
''        'ここでキャンセル者は除きつつ､性別ごとの件数を取得するため個人情報を結合
''        strStmt = strStmt & vbLf & _
''                  "          WHERE SUBQUERY.CSLDATE   = :CSLDATE                         " & vbLf & _
''                  "            AND SUBQUERY.CANCELFLG = 0                                " & vbLf & _
''                  "            AND SUBQUERY.PERID     = PERSON.PERID                     " & vbLf & _
''                  "          GROUP BY SUBQUERY.CSLDATE, SUBQUERY.CSCD, SUBQUERY.RSVGRPCD " & vbLf & _
''                  "       ) REALRSVFRAMNG                                                " & vbLf & _
''                  " WHERE REALRSVFRAMNG.CSCD     = :CSCD                                 " & vbLf & _
''                  "   AND REALRSVFRAMNG.RSVGRPCD = :RSVGRPCD                             " & vbLf & _
''                  "   AND REALRSVFRAMNG.CSCD     = WEB_RSVFRAMNG.CSCD(+)                 " & vbLf & _
''                  "   AND REALRSVFRAMNG.RSVGRPCD = WEB_RSVFRAMNG.RSVGRPCD(+)             " & vbLf & _
''                  "                                                                      "
'
'        '予約人数を計算(存在しない場合は０)
'        strStmt = "SELECT NVL(SUM(REALRSVFRAMNG.RSVCNT_M), 0) RSVCNT_M, " & vbLf & _
'                  "       NVL(SUM(REALRSVFRAMNG.RSVCNT_F), 0) RSVCNT_F  "
'
'        'web予約から得られる予約人数情報
'        strStmt = strStmt & vbLf & _
'                  "  FROM ( SELECT WEB_RSVFRAMNG.CSLDATE, WEB_RSVFRAMNG.CSCD, WEB_RSVFRAMNG.RSVGRPCD,    " & vbLf & _
'                  "                COUNT(DECODE(WEB_YOYAKU.SEXFLG, 1, WEB_YOYAKU.WEBNO, NULL)) RSVCNT_M, " & vbLf & _
'                  "                COUNT(DECODE(WEB_YOYAKU.SEXFLG, 2, WEB_YOYAKU.WEBNO, NULL)) RSVCNT_F  " & vbLf & _
'                  "           FROM HAINSNET.WEB_YOYAKU, HAINSNET.WEB_RSVFRAMNG                           " & vbLf & _
'                  "          WHERE WEB_RSVFRAMNG.CSLDATE = :CSLDATE                                      " & vbLf & _
'                  "            AND WEB_RSVFRAMNG.WEBNO   = WEB_YOYAKU.WEBNO                              " & vbLf & _
'                  "            AND WEB_YOYAKU.YKBN      != 2                                             " & vbLf & _
'                  "          GROUP BY WEB_RSVFRAMNG.CSLDATE, WEB_RSVFRAMNG.CSCD, WEB_RSVFRAMNG.RSVGRPCD  "
'
'        'web予約から得られる予約人数情報と受診情報から得られる予約人数情報とをUNION ALL結合(最後にSUM関数で和をとる)
'        strStmt = strStmt & vbLf & _
'                  "          UNION ALL "
'
'        '受診情報から得られる予約人数情報
'        strStmt = strStmt & vbLf & _
'                  "         SELECT SUBQUERY.CSLDATE, SUBQUERY.CSCD, SUBQUERY.RSVGRPCD, "
'
'        '先にUNION ALLで指定しているため、同一予約番号にて複数存在するコース、予約群に関しては重複を１つとしてカウント
'        'かつNULL値がカウントされない性質を利用し、性別による振り分けを行う
'        strStmt = strStmt & vbLf & _
'                  "                COUNT(DISTINCT DECODE(PERSON.GENDER, 1, SUBQUERY.RSVNO, NULL)) RSVCNT_M, " & vbLf & _
'                  "                COUNT(DISTINCT DECODE(PERSON.GENDER, 2, SUBQUERY.RSVNO, NULL)) RSVCNT_F  " & vbLf & _
'                  "           FROM PERSON,                                                                  "
'
'
'        '受診情報本体から枠管理されるコース、予約群を取得
'        strStmt = strStmt & vbLf & _
'                  "                ( SELECT CONSULT.RSVNO,    CONSULT.CSLDATE, CONSULT.CSCD,     " & vbLf & _
'                  "                         CONSULT.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
'                  "                    FROM CONSULT                                              "
'
'        '後で重複は除きつつカウントするためここではUNION ALL指定(２回ソート処理が走るのは嫌)
'        strStmt = strStmt & vbLf & _
'                  "                   UNION ALL "
'
'        'セット情報から枠管理されるコース、予約群を取得
'        strStmt = strStmt & vbLf & _
'                  "                  SELECT CONSULT.RSVNO,    CONSULT.CSLDATE, RSVFRA_C.CSCD,    " & vbLf & _
'                  "                         CONSULT.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
'                  "                    FROM RSVFRA_C, CTRPT_OPT, CONSULT_O, CONSULT              " & vbLf & _
'                  "                   WHERE CONSULT.RSVNO         = CONSULT_O.RSVNO              " & vbLf & _
'                  "                     AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD            " & vbLf & _
'                  "                     AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD              " & vbLf & _
'                  "                     AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO        " & vbLf & _
'                  "                     AND CTRPT_OPT.RSVFRACD    = RSVFRA_C.RSVFRACD            " & vbLf & _
'                  "                ) SUBQUERY                                                    "
'
'
'        'ここでキャンセル者は除きつつ､性別ごとの件数を取得するため個人情報を結合
'        strStmt = strStmt & vbLf & _
'                  "          WHERE SUBQUERY.CSLDATE   = :CSLDATE                         " & vbLf & _
'                  "            AND SUBQUERY.CANCELFLG = 0                                " & vbLf & _
'                  "            AND SUBQUERY.PERID     = PERSON.PERID                     " & vbLf & _
'                  "          GROUP BY SUBQUERY.CSLDATE, SUBQUERY.CSCD, SUBQUERY.RSVGRPCD "
'
'        '指定コース、予約群のweb予約・受診情報の予約人数の和をとる
'        strStmt = strStmt & vbLf & _
'                  "       ) REALRSVFRAMNG                    " & vbLf & _
'                  " WHERE REALRSVFRAMNG.CSCD     = :CSCD     " & vbLf & _
'                  "   AND REALRSVFRAMNG.RSVGRPCD = :RSVGRPCD "
''## 2005.03.16 Mod End

        '予約人数を計算(存在しない場合は０)
        strStmt = "SELECT NVL(SUM(REALRSVFRAMNG.RSVCNT_M), 0) RSVCNT_M, " & vbLf & _
                  "       NVL(SUM(REALRSVFRAMNG.RSVCNT_F), 0) RSVCNT_F  "
                  
        'web予約から得られる予約人数情報
        strStmt = strStmt & vbLf & _
                  "  FROM ( SELECT WEB_RSVFRAMNG.CSLDATE, WEB_RSVFRAMNG.CSCD, WEB_RSVFRAMNG.RSVGRPCD,        " & vbLf & _
                  "                COUNT(DECODE(V_WEB_YOYAKU.SEXFLG, 1, V_WEB_YOYAKU.WEBNO, NULL)) RSVCNT_M, " & vbLf & _
                  "                COUNT(DECODE(V_WEB_YOYAKU.SEXFLG, 2, V_WEB_YOYAKU.WEBNO, NULL)) RSVCNT_F  " & vbLf & _
                  "           FROM WEBRESERVE.V_WEB_YOYAKU, WEBRESERVE.WEB_RSVFRAMNG                         " & vbLf & _
                  "          WHERE WEB_RSVFRAMNG.CSLDATE = :CSLDATE                                          " & vbLf & _
                  "            AND WEB_RSVFRAMNG.CSLDATE = V_WEB_YOYAKU.JDATE                                " & vbLf & _
                  "            AND WEB_RSVFRAMNG.WEBNO   = V_WEB_YOYAKU.WEBNO                                " & vbLf & _
                  "            AND V_WEB_YOYAKU.YKBN    != 2                                                 " & vbLf & _
                  "          GROUP BY WEB_RSVFRAMNG.CSLDATE, WEB_RSVFRAMNG.CSCD, WEB_RSVFRAMNG.RSVGRPCD      "
                  
        'web予約から得られる予約人数情報と受診情報から得られる予約人数情報とをUNION ALL結合(最後にSUM関数で和をとる)
        strStmt = strStmt & vbLf & _
                  "          UNION ALL "
                  
        '受診情報から得られる予約人数情報
        strStmt = strStmt & vbLf & _
                  "         SELECT SUBQUERY.CSLDATE, SUBQUERY.CSCD, SUBQUERY.RSVGRPCD, "
                  
        '先にUNION ALLで指定しているため、同一予約番号にて複数存在するコース、予約群に関しては重複を１つとしてカウント
        'かつNULL値がカウントされない性質を利用し、性別による振り分けを行う
        strStmt = strStmt & vbLf & _
                  "                COUNT(DISTINCT DECODE(PERSON.GENDER, 1, SUBQUERY.RSVNO, NULL)) RSVCNT_M, " & vbLf & _
                  "                COUNT(DISTINCT DECODE(PERSON.GENDER, 2, SUBQUERY.RSVNO, NULL)) RSVCNT_F  " & vbLf & _
                  "           FROM PERSON, "

        '受診情報本体から枠管理されるコース、予約群を取得
        strStmt = strStmt & vbLf & _
                  "                ( SELECT CONSULT.RSVNO,    CONSULT.CSLDATE, CONSULT.CSCD,     " & vbLf & _
                  "                         CONSULT.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
                  "                    FROM CONSULT                                              "

        '後で重複は除きつつカウントするためここではUNION ALL指定(２回ソート処理が走るのは嫌)
        strStmt = strStmt & vbLf & _
                  "                   UNION ALL "

        'セット情報から枠管理されるコース、予約群を取得
        strStmt = strStmt & vbLf & _
                  "                  SELECT CONSULT.RSVNO,    CONSULT.CSLDATE, RSVFRA_C.CSCD,    " & vbLf & _
                  "                         CONSULT.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG " & vbLf & _
                  "                    FROM RSVFRA_C, CTRPT_OPT, CONSULT_O, CONSULT              " & vbLf & _
                  "                   WHERE CONSULT.RSVNO         = CONSULT_O.RSVNO              " & vbLf & _
                  "                     AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD            " & vbLf & _
                  "                     AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD              " & vbLf & _
                  "                     AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO        " & vbLf & _
                  "                     AND CTRPT_OPT.RSVFRACD    = RSVFRA_C.RSVFRACD            "

        'ここも先と同様、UNION ALL指定
        strStmt = strStmt & vbLf & _
                  "                   UNION ALL "
                  
        'セット情報から枠管理されるコースと、そのオープン枠予約群を取得
        strStmt = strStmt & vbLf & _
                  "                  SELECT CONSULT.RSVNO,   CONSULT.CSLDATE, RSVFRA_C.CSCD,                     " & vbLf & _
                  "                         RSVGRP.RSVGRPCD, CONSULT.PERID,   CONSULT.CANCELFLG                  " & vbLf & _
                  "                    FROM RSVGRP, RSVFRAMNG, RSVFRA_C, RSVFRA_P, CTRPT_OPT, CONSULT_O, CONSULT " & vbLf & _
                  "                   WHERE CONSULT.RSVNO          = CONSULT_O.RSVNO                             " & vbLf & _
                  "                     AND CONSULT_O.CTRPTCD      = CTRPT_OPT.CTRPTCD                           " & vbLf & _
                  "                     AND CONSULT_O.OPTCD        = CTRPT_OPT.OPTCD                             " & vbLf & _
                  "                     AND CONSULT_O.OPTBRANCHNO  = CTRPT_OPT.OPTBRANCHNO                       "

        '予約枠テーブルを結合し、オープン枠予約群検索対象であるもののみ取得
        strStmt = strStmt & vbLf & _
                  "                     AND CTRPT_OPT.RSVFRACD     = RSVFRA_P.RSVFRACD " & vbLf & _
                  "                     AND RSVFRA_P.INCOPENGRP    > 0                 "

        'オープン枠予約群検索対象である予約枠のコースを取得
        strStmt = strStmt & vbLf & _
                  "                     AND CTRPT_OPT.RSVFRACD     = RSVFRA_C.RSVFRACD "

        'オープン枠予約群検索対象コースの、予約人数管理情報に登録されている全予約群を取得
        strStmt = strStmt & vbLf & _
                  "                     AND CONSULT.CSLDATE        = RSVFRAMNG.CSLDATE " & vbLf & _
                  "                     AND RSVFRA_C.CSCD          = RSVFRAMNG.CSCD    "

        'オープン枠予約群検索対象コースの予約群のうち、オープン枠予約群のみを取得
        '(オープン枠予約群である予約人数管理レコードが存在しない場合は枠管理対象としない)
        strStmt = strStmt & vbLf & _
                  "                     AND RSVFRAMNG.RSVGRPCD     = RSVGRP.RSVGRPCD " & vbLf & _
                  "                     AND RSVGRP.ISOPENGRP       > 0               " & vbLf & _
                  "                ) SUBQUERY                                        "

        'ここでキャンセル者は除きつつ､性別ごとの件数を取得するため個人情報を結合
        strStmt = strStmt & vbLf & _
                  "          WHERE SUBQUERY.CSLDATE   = :CSLDATE                         " & vbLf & _
                  "            AND SUBQUERY.CANCELFLG = " & CONSULT_USED & "             " & vbLf & _
                  "            AND SUBQUERY.PERID     = PERSON.PERID                     " & vbLf & _
                  "          GROUP BY SUBQUERY.CSLDATE, SUBQUERY.CSCD, SUBQUERY.RSVGRPCD "

        '指定コース、予約群のweb予約・受診情報の予約人数の和をとる
        strStmt = strStmt & vbLf & _
                  "       ) REALRSVFRAMNG                    " & vbLf & _
                  " WHERE REALRSVFRAMNG.CSCD     = :CSCD     " & vbLf & _
                  "   AND REALRSVFRAMNG.RSVGRPCD = :RSVGRPCD "
'#### 2013.2.28 SL-SN-Y0101-612 UPD END   ####
    
        'SQL文の実行
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
        '検索レコードが存在する場合
        If Not objOraDyna.EOF Then
            lngRsvCnt_M = objOraDyna.Fields("RSVCNT_M").Value
            lngRsvCnt_F = objOraDyna.Fields("RSVCNT_F").Value
        Else
            lngRsvCnt_M = 0
            lngRsvCnt_F = 0
        End If
    
        'バインド変数の定義
        objOraParam.Add "RSVCNT_M", lngRsvCnt_M, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "RSVCNT_F", lngRsvCnt_F, ORAPARM_INPUT, ORATYPE_NUMBER
    
        '実績人数の更新
        strStmt = "UPDATE RSVFRAMNG             " & vbLf & _
                  "   SET RSVCNT_M = :RSVCNT_M, " & vbLf & _
                  "       RSVCNT_F = :RSVCNT_F  " & vbLf & _
                  " WHERE CSLDATE  = :CSLDATE   " & vbLf & _
                  "   AND CSCD     = :CSCD      " & vbLf & _
                  "   AND RSVGRPCD = :RSVGRPCD  "
    
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    
    End If
'## 2004.03.12 Add End
    
'## 2004.03.12 Mod By T.Takagi@FSIT エラーなのにコミットされているのな精神衛生的に・・・
'    'トランザクションをコミット
'    mobjContext.SetComplete
    If IsEmpty(UpdateRsvFraMngInfo) Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
'## 2004.03.12 Mod End
    
    Exit Function

ErrorHandle:


    'イベントログ書き込み
    WriteErrorLog "Schedule.UpdateRsvFraMngInfo"

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

'## 2003.11.21 Add By K.Fujii
'
' 機能　　 : 予約人数管理情報を更新する
'
' 引数　　 : (In)    strCslDate         受診日
' 　　　　   (In)    strCsCd            コースコード
' 　　　　   (In)    lngRsvGrpCd        予約群コード
' 　　　　   (In)    lngMaxCnt          予約可能人数（共通）
' 　　　　   (In)    lngMaxCnt_M        予約可能人数（男）
' 　　　　   (In)    lngMaxCnt_F        予約可能人数（女）
' 　　　　   (In)    lngOverCnt         オーバ可能人数（共通）
' 　　　　   (In)    lngOverCnt_M       オーバ可能人数（男）
' 　　　　   (In)    lngOverCnt_F       オーバ可能人数（女）
' 　　　　   (In)    lngRsvCnt_M        予約済み人数（男）
' 　　　　   (In)    lngRsvCnt_F        予約済み人数（女）
'
' 戻り値　 : 0=正常
'
'
' 備考　　 :
'
Public Function UpdateRsvFraMng( _
    ByVal strCslDate As String, _
    ByVal strCsCd As String, _
    ByVal lngRsvGrpCd As Long, _
    ByVal lngMaxCnt As Long, _
    ByVal lngMaxCnt_M As Long, _
    ByVal lngMaxCnt_F As Long, _
    ByVal lngOverCnt As Long, _
    ByVal lngOverCnt_M As Long, _
    ByVal lngOverCnt_F As Long, _
    ByVal lngRsvCnt_M As Long, _
    ByVal lngRsvCnt_F As Long _
) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    
    Dim lngRet          As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Format(Trim(strCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", Trim(lngRsvGrpCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MAXCNT", Trim(lngMaxCnt), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MAXCNT_M", Trim(lngMaxCnt_M), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MAXCNT_F", Trim(lngMaxCnt_F), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OVERCNT", Trim(lngOverCnt), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OVERCNT_M", Trim(lngOverCnt_M), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OVERCNT_F", Trim(lngOverCnt_F), ORAPARM_INPUT, ORATYPE_NUMBER
'### 2004/2/5 Deleted by Ishihara@FSIT 実績人数は絶対に更新してはダメ
'    objOraParam.Add "RSVCNT_M", Trim(lngRsvCnt_M), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "RSVCNT_F", Trim(lngRsvCnt_F), ORAPARM_INPUT, ORATYPE_NUMBER
'### 2004/2/5 Deleted End
    
    'データ更新
'### 2004/2/5 Modified by Ishihara@FSIT 実績人数は絶対に更新してはダメ
'    strStmt = "UPDATE RSVFRAMNG                           " & vbLf & _
              "   SET RSVFRAMNG.MAXCNT    = :MAXCNT   ,   " & vbLf & _
              "       RSVFRAMNG.MAXCNT_M  = :MAXCNT_M ,   " & vbLf & _
              "       RSVFRAMNG.MAXCNT_F  = :MAXCNT_F ,   " & vbLf & _
              "       RSVFRAMNG.OVERCNT   = :OVERCNT  ,   " & vbLf & _
              "       RSVFRAMNG.OVERCNT_M = :OVERCNT_M,   " & vbLf & _
              "       RSVFRAMNG.OVERCNT_F = :OVERCNT_F,   " & vbLf & _
              "       RSVFRAMNG.RSVCNT_M  = :RSVCNT_M ,   " & vbLf & _
              "       RSVFRAMNG.RSVCNT_F  = :RSVCNT_F     " & vbLf & _
              " WHERE RSVFRAMNG.CSLDATE   = :CSLDATE      " & vbLf & _
              "   AND RSVFRAMNG.CSCD      = :CSCD         " & vbLf & _
              "   AND RSVFRAMNG.RSVGRPCD  = :RSVGRPCD     "
    strStmt = "UPDATE RSVFRAMNG                           " & vbLf & _
              "   SET RSVFRAMNG.MAXCNT    = :MAXCNT   ,   " & vbLf & _
              "       RSVFRAMNG.MAXCNT_M  = :MAXCNT_M ,   " & vbLf & _
              "       RSVFRAMNG.MAXCNT_F  = :MAXCNT_F ,   " & vbLf & _
              "       RSVFRAMNG.OVERCNT   = :OVERCNT  ,   " & vbLf & _
              "       RSVFRAMNG.OVERCNT_M = :OVERCNT_M,   " & vbLf & _
              "       RSVFRAMNG.OVERCNT_F = :OVERCNT_F    " & vbLf & _
              " WHERE RSVFRAMNG.CSLDATE   = :CSLDATE      " & vbLf & _
              "   AND RSVFRAMNG.CSCD      = :CSCD         " & vbLf & _
              "   AND RSVFRAMNG.RSVGRPCD  = :RSVGRPCD     "
'### 2004/2/5 Modified End
    
'### 2004/2/5 Modified by Ishihara@FSIT OmitCharSpc対応
'    mobjOraDb.ExecuteSQL strStmt
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'### 2004/2/5 Modified End
    
'### 2003.02.05 Added by Ishihara@FSIT バインド変数そのまま放置
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2003.02.05 Added End
    
    UpdateRsvFraMng = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    UpdateRsvFraMng = -99

    'イベントログ書き込み
    WriteErrorLog "Schedule.UpdateRsvFraMng"

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

'## 2003.11.21 Add By K.Fujii
'
' 機能　　 : 予約人数管理情報を挿入する
'
' 引数　　 : (In)    strCslDate         受診日
' 　　　　   (In)    strCsCd            コースコード
' 　　　　   (In)    lngRsvGrpCd        予約群コード
' 　　　　   (In)    lngMaxCnt          予約可能人数（共通）
' 　　　　   (In)    lngMaxCnt_M        予約可能人数（男）
' 　　　　   (In)    lngMaxCnt_F        予約可能人数（女）
' 　　　　   (In)    lngOverCnt         オーバ可能人数（共通）
' 　　　　   (In)    lngOverCnt_M       オーバ可能人数（男）
' 　　　　   (In)    lngOverCnt_F       オーバ可能人数（女）
' 　　　　   (In)    lngRsvCnt_M        予約済み人数（男）
' 　　　　   (In)    lngRsvCnt_F        予約済み人数（女）
'
' 戻り値　 : 0=正常
'
'
' 備考　　 :
'
Public Function InsertRsvFraMng( _
    ByVal strCslDate As String, _
    ByVal strCsCd As String, _
    ByVal lngRsvGrpCd As Long, _
    ByVal lngMaxCnt As Long, _
    ByVal lngMaxCnt_M As Long, _
    ByVal lngMaxCnt_F As Long, _
    ByVal lngOverCnt As Long, _
    ByVal lngOverCnt_M As Long, _
    ByVal lngOverCnt_F As Long, _
    ByVal lngRsvCnt_M As Long, _
    ByVal lngRsvCnt_F As Long _
) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim vntMngGender    As Variant          '男女別枠管理
    
    Dim blnRet          As Boolean          '復帰値

'### 2004/2/5 Added by Ishihara@FSIT Insert前に存在チェック
    Dim lngExistsCnt    As Long
'### 2004/2/5 Added End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
   'コース、予約群の組み合わせの存在有無チェック
    blnRet = SelectCourseRsvGrp(strCsCd, lngRsvGrpCd, vntMngGender)
    
    If blnRet = False Then
        InsertRsvFraMng = -1
        Exit Function
    End If
    
    '男女別管理する？
    If vntMngGender = 1 Then
        If lngMaxCnt > 0 Or lngOverCnt > 0 Then
            InsertRsvFraMng = -2
            Exit Function
        End If
    Else
        If lngMaxCnt_M > 0 Or lngMaxCnt_F > 0 Or lngOverCnt_M > 0 Or lngOverCnt_F > 0 Then
            InsertRsvFraMng = -3
            Exit Function
        End If
    End If
    
'### 2004/2/5 Added by Ishihara@FSIT Insert前に存在チェック
    If SelectRsvFraMngList(strCslDate, strCslDate, Trim(strCsCd), lngRsvGrpCd) > 0 Then
        InsertRsvFraMng = -4
        Exit Function
    End If
'### 2004/2/5 Added End
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Format(Trim(strCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", Trim(lngRsvGrpCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MAXCNT", Trim(lngMaxCnt), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MAXCNT_M", Trim(lngMaxCnt_M), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MAXCNT_F", Trim(lngMaxCnt_F), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OVERCNT", Trim(lngOverCnt), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OVERCNT_M", Trim(lngOverCnt_M), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OVERCNT_F", Trim(lngOverCnt_F), ORAPARM_INPUT, ORATYPE_NUMBER
'### 2004/2/5 Deleted by Ishihara@FSIT 実績人数は絶対に更新してはダメ
'    objOraParam.Add "RSVCNT_M", Trim(lngRsvCnt_M), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "RSVCNT_F", Trim(lngRsvCnt_F), ORAPARM_INPUT, ORATYPE_NUMBER
'### 2004/2/5 Deleted End
    
    'データ登録
'### 2004/2/5 Modified by Ishihara@FSIT 実績人数は絶対に更新してはダメ
'    strStmt = "   MERGE INTO  RSVFRAMNG                      " & vbLf & _
'              "         USING ( SELECT :CSLDATE   CSLDATE,   " & vbLf & _
'              "                        :CSCD      CSCD,      " & vbLf & _
'              "                        :RSVGRPCD  RSVGRPCD,  " & vbLf & _
'              "                        :MAXCNT    MAXCNT,    " & vbLf & _
'              "                        :MAXCNT_M  MAXCNT_M,  " & vbLf & _
'              "                        :MAXCNT_F  MAXCNT_F,  " & vbLf & _
'              "                        :OVERCNT   OVERCNT,   " & vbLf & _
'              "                        :OVERCNT_M OVERCNT_M, " & vbLf & _
'              "                        :OVERCNT_F OVERCNT_F, " & vbLf & _
'              "                        :RSVCNT_M  RSVCNT_M,  " & vbLf & _
'              "                        :RSVCNT_F  RSVCNT_F   " & vbLf & _
'              "                   FROM DUAL  ) BASEDRSVFRAMNG                 " & vbLf & _
'              "            ON ( RSVFRAMNG.CSLDATE  = BASEDRSVFRAMNG.CSLDATE   " & vbLf & _
'              "             AND RSVFRAMNG.CSCD     = BASEDRSVFRAMNG.CSCD      " & vbLf & _
'              "             AND RSVFRAMNG.RSVGRPCD = BASEDRSVFRAMNG.RSVGRPCD )"
'
'    strStmt = strStmt & vbLf & _
'              "WHEN MATCHED THEN                                        " & vbLf & _
'              "UPDATE                                                   " & vbLf & _
'              "   SET RSVFRAMNG.MAXCNT    = BASEDRSVFRAMNG.MAXCNT   ,   " & vbLf & _
'              "       RSVFRAMNG.MAXCNT_M  = BASEDRSVFRAMNG.MAXCNT_M ,   " & vbLf & _
'              "       RSVFRAMNG.MAXCNT_F  = BASEDRSVFRAMNG.MAXCNT_F ,   " & vbLf & _
'              "       RSVFRAMNG.OVERCNT   = BASEDRSVFRAMNG.OVERCNT  ,   " & vbLf & _
'              "       RSVFRAMNG.OVERCNT_M = BASEDRSVFRAMNG.OVERCNT_M,   " & vbLf & _
'              "       RSVFRAMNG.OVERCNT_F = BASEDRSVFRAMNG.OVERCNT_F,   " & vbLf & _
'              "       RSVFRAMNG.RSVCNT_M  = BASEDRSVFRAMNG.RSVCNT_M ,   " & vbLf & _
'              "       RSVFRAMNG.RSVCNT_F  = BASEDRSVFRAMNG.RSVCNT_F     "
'
'    strStmt = strStmt & vbLf & _
'              "WHEN NOT MATCHED THEN           " & vbLf & _
'              "    INSERT  (                   " & vbLf & _
'              "                 CSLDATE  ,     " & vbLf & _
'              "                 CSCD     ,     " & vbLf & _
'              "                 RSVGRPCD ,     " & vbLf & _
'              "                 MAXCNT   ,     " & vbLf & _
'              "                 MAXCNT_M ,     " & vbLf & _
'              "                 MAXCNT_F ,     " & vbLf & _
'              "                 OVERCNT  ,     " & vbLf & _
'              "                 OVERCNT_M,     " & vbLf & _
'              "                 OVERCNT_F,     " & vbLf & _
'              "                 RSVCNT_M ,     " & vbLf & _
'              "                 RSVCNT_F  ) VALUES (      " & vbLf & _
'              "                 BASEDRSVFRAMNG.CSLDATE,      " & vbLf & _
'              "                 BASEDRSVFRAMNG.CSCD    ,     " & vbLf & _
'              "                 BASEDRSVFRAMNG.RSVGRPCD ,    " & vbLf & _
'              "                 BASEDRSVFRAMNG.MAXCNT   ,    " & vbLf & _
'              "                 BASEDRSVFRAMNG.MAXCNT_M ,    " & vbLf & _
'              "                 BASEDRSVFRAMNG.MAXCNT_F ,    " & vbLf & _
'              "                 BASEDRSVFRAMNG.OVERCNT  ,    " & vbLf & _
'              "                 BASEDRSVFRAMNG.OVERCNT_M,    " & vbLf & _
'              "                 BASEDRSVFRAMNG.OVERCNT_F,    " & vbLf & _
'              "                 BASEDRSVFRAMNG.RSVCNT_M ,    " & vbLf & _
'              "                 BASEDRSVFRAMNG.RSVCNT_F   )  "
    '実績人数更新されるぐらいなら、挿入時の絶妙タイミング他端末から挿入されてOracleErrorでこけた方がマシ
    strStmt = "INSERT INTO RSVFRAMNG ( CSLDATE,  CSCD,  RSVGRPCD,  MAXCNT,  MAXCNT_M,  MAXCNT_F,  OVERCNT,  OVERCNT_M,  OVERCNT_F) " & vbLf & _
              "               VALUES (:CSLDATE, :CSCD, :RSVGRPCD, :MAXCNT, :MAXCNT_M, :MAXCNT_F, :OVERCNT, :OVERCNT_M, :OVERCNT_F) "
'### 2004/2/5 Modified End
    
'### 2004/2/5 Modified by Ishihara@FSIT OmitCharSpc対応
'    mobjOraDb.ExecuteSQL strStmt
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'### 2004/2/5 Modified End
    
'### 2003.02.05 Added by Ishihara@FSIT バインド変数そのまま放置
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2003.02.05 Added End
    
    InsertRsvFraMng = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    InsertRsvFraMng = -99

    'イベントログ書き込み
    WriteErrorLog "Schedule.InsertRsvFraMng"

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

'## 2003.11.21 Add By K.Fujii
'
' 機能　　 : 予約人数管理情報を削除する
'
' 引数　　 : (In)    strCslDate         受診日
' 　　　　   (In)    strCsCd            コースコード
' 　　　　   (In)    lngRsvGrpCd        予約群コード
'
' 戻り値　 : True = 正常
'            False = 異常
'
' 備考　　 :
'
Public Function DeleteRsvFraMng( _
    ByVal strCslDate As String, _
    ByVal strCsCd As String, _
    ByVal lngRsvGrpCd As Long _
) As Boolean
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    
    Dim lngRet          As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Format(Trim(strCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", Trim(lngRsvGrpCd), ORAPARM_INPUT, ORATYPE_NUMBER
    
    
    'データ更新
    strStmt = "DELETE RSVFRAMNG                           " & vbLf & _
              " WHERE RSVFRAMNG.CSLDATE   = :CSLDATE      " & vbLf & _
              "   AND RSVFRAMNG.CSCD      = :CSCD         " & vbLf & _
              "   AND RSVFRAMNG.RSVGRPCD  = :RSVGRPCD     "
    
    mobjOraDb.ExecuteSQL strStmt
    
'### 2003.02.05 Added by Ishihara@FSIT バインド変数そのまま放置
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2003.02.05 Added End
    
    DeleteRsvFraMng = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    DeleteRsvFraMng = False

    'イベントログ書き込み
    WriteErrorLog "Schedule.DeleteRsvFraMng"

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
' 機能　　 : 指定期間の予約スケジューリング情報を取得する
'
' 引数　　 : (In)   strStrDate     読み込み開始日付
' 　　　　   (In)   strEndDate     読み込み終了日付
' 　　　　   (In)   strTimeFra     時間枠
' 　　　　   (In)   strRsvFraCd    予約枠コード
' 　　　　   (Out)  vntCslDate     受診日
' 　　　　   (Out)  vntTimeFra     時間枠
' 　　　　   (Out)  vntRsvFraCd    予約枠コード
' 　　　　   (Out)  vntEmptyCount  予約可能人数
' 　　　　   (Out)  vntRsvCount    予約済み人数
'
' 戻り値　 : レコード件数
'
' 備考　　 : 時間枠と予約枠コードの指定は必須でない
'
Public Function SelectSchedule( _
    ByVal strStrDate As String, _
    ByVal strEndDate As String, _
    ByVal strTimeFra As String, _
    ByVal strRsvFraCd As String, _
    ByRef vntCslDate As Variant, _
    ByRef vntTimeFra As Variant, _
    ByRef vntRsvFraCd As Variant, _
    ByRef vntEmptyCount As Variant, _
    ByRef vntRsvCount As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCslDate          As OraField         '受診日
    Dim objTimeFra          As OraField         '時間枠
    Dim objRsvFraCd         As OraField         '予約枠コード
    Dim objEmptyCount       As OraField         '予約可能人数
    Dim objRsvCount         As OraField         '予約済み人数
    
    Dim vntArrCslDate()     As Variant          '受診日
    Dim vntArrTimeFra()     As Variant          '時間枠
    Dim vntArrRsvFraCd()    As Variant          '予約枠コード
    Dim vntArrEmptyCount()  As Variant          '予約可能人数
    Dim vntArrRsvCount()    As Variant          '予約済み人数
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCslDate = Empty
    vntTimeFra = Empty
    vntRsvFraCd = Empty
    vntEmptyCount = Empty
    vntRsvCount = Empty
    SelectSchedule = 0
    lngCount = 0
    
    '検索条件が設定されていない場合はエラー
    If Not (IsDate(Trim(strStrDate)) And IsDate(Trim(strEndDate))) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRDATE", Trim(strStrDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENDDATE", Trim(strEndDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If Trim(strTimeFra) <> "" Then          '時間枠指定あり
        objOraParam.Add "TIMEFRA", CLng(Trim(strTimeFra)), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    If Trim(strRsvFraCd) <> "" Then         '予約枠コード指定あり
        objOraParam.Add "RSVFRACD", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '検索条件を満たす予約スケジュールのレコードを取得
    strStmt = "SELECT TO_CHAR(CSLDATE, 'YYYY/MM/DD') CSLDATE, " & vbLf & _
              "       TIMEFRA, RSVFRACD, EMPTYCOUNT, RSVCOUNT " & vbLf & _
              "  FROM SCHEDULE                                " & vbLf & _
              " WHERE CSLDATE  >= :STRDATE                    " & vbLf & _
              "   AND CSLDATE  <= :ENDDATE                    "
    
    '条件節・ソート順を追加
    If Trim(strTimeFra) <> "" Then          '時間枠指定あり
        If Trim(strRsvFraCd) <> "" Then         '予約枠コード指定あり
            strStmt = strStmt & vbLf & _
              "   AND TIMEFRA   = :TIMEFRA                    " & vbLf & _
              "   AND RSVFRACD  = :RSVFRACD                   " & vbLf & _
              " ORDER BY CSLDATE                              "
        Else                                    '予約枠コード指定なし
            strStmt = strStmt & vbLf & _
              "   AND TIMEFRA   = :TIMEFRA                    " & vbLf & _
              " ORDER BY CSLDATE, RSVFRACD                    "
        End If
    Else                                    '時間枠指定なし
        If Trim(strRsvFraCd) <> "" Then         '予約枠コード指定あり
            strStmt = strStmt & vbLf & _
              "   AND RSVFRACD  = :RSVFRACD                   " & vbLf & _
              " ORDER BY CSLDATE, TIMEFRA                     "
        Else                                    '予約枠コード指定なし
            strStmt = strStmt & vbLf & _
              " ORDER BY CSLDATE, TIMEFRA, RSVFRACD           "
        End If
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objTimeFra = objFields("TIMEFRA")
        Set objRsvFraCd = objFields("RSVFRACD")
        Set objEmptyCount = objFields("EMPTYCOUNT")
        Set objRsvCount = objFields("RSVCOUNT")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrTimeFra(lngCount)
            ReDim Preserve vntArrRsvFraCd(lngCount)
            ReDim Preserve vntArrEmptyCount(lngCount)
            ReDim Preserve vntArrRsvCount(lngCount)
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrTimeFra(lngCount) = CLng(objTimeFra.Value & "")
            vntArrRsvFraCd(lngCount) = objRsvFraCd.Value & ""
            vntArrEmptyCount(lngCount) = CLng(objEmptyCount.Value & "")
            vntArrRsvCount(lngCount) = CLng(objRsvCount.Value & "")
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntCslDate = vntArrCslDate
        vntTimeFra = vntArrTimeFra
        vntRsvFraCd = vntArrRsvFraCd
        vntEmptyCount = vntArrEmptyCount
        vntRsvCount = vntArrRsvCount
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectSchedule = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    SelectSchedule = -1
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectSchedule"
    
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
' 機能　　 : 指定期間の病院スケジューリング情報を取得する
'
' 引数　　 : (In)     strStrDate  読み込み開始日付
' 　　　　   (In)     strEndDate  読み込み終了日付
' 　　　　   (Out)    vntCslDate  受診日
' 　　　　   (Out)    vntHoliday  休診日（１：休診日，２：祝日）
'
' 戻り値　 : レコード件数
'
' 備考　　 : 休診または祝日が設定された日しかレコードは存在しない
'
Public Function SelectSchedule_h(ByVal strStrDate As String, ByVal strEndDate As String, ByRef vntCslDate As Variant, ByRef vntHoliday As Variant) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCslDate      As OraField         '受診日
    Dim objHoliday      As OraField         '休診日
    
    Dim vntArrCslDate() As Variant          '受診日
    Dim vntArrHoliday() As Variant          '休診日
    
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCslDate = Empty
    vntHoliday = Empty
    lngCount = 0
    
    '検索条件が設定されていない場合はエラー
    If Not (IsDate(Trim(strStrDate)) And IsDate(Trim(strEndDate))) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRDATE", CDate(strStrDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", CDate(strEndDate), ORAPARM_INPUT, ORATYPE_DATE
    
    '検索条件を満たす病院スケジュールのレコードを取得
    strStmt = "SELECT CSLDATE, HOLIDAY    " & vbLf & _
              "  FROM SCHEDULE_H          " & vbLf & _
              " WHERE CSLDATE >= :STRDATE " & vbLf & _
              "   AND CSLDATE <= :ENDDATE " & vbLf & _
              " ORDER BY CSLDATE          "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objHoliday = objFields("HOLIDAY")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrHoliday(lngCount)
            vntArrCslDate(lngCount) = Format(objCslDate.Value, "YYYY/MM/DD")
            vntArrHoliday(lngCount) = CLng(objHoliday.Value & "")
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntCslDate = vntArrCslDate
        vntHoliday = vntArrHoliday
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectSchedule_h = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    SelectSchedule_h = -1
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.SelectSchedule_h"
    
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
' 機能　　 : ひと月分の該当時間枠・該当予約枠の予約スケジューリングを一括更新する
'
' 引数　　 : (In)   strStrDate          月始日付
' 　　　　 : (In)   strEndDate          月末日付
' 　　　　 : (In)   lngTimeFra          時間枠
' 　　　　 : (In)   strRsvFraCd         予約枠コード
' 　　　　 : (In)   strArrEmptyCount    月始日付～月末日付の設定値（"hidden":非表示，"":未設定，"0":予約不可，"1"～"999":予約可能）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateSchedule(ByVal strStrDate As String, ByVal strEndDate As String, ByVal lngTimeFra As Long, ByVal strRsvFraCd As String, ByVal strArrEmptyCount As Variant) As Boolean
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim objOraDyna2     As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCsCd         As OraField         'コースコード
    Dim objOrgCd1       As OraField         '団体コード1
    Dim objOrgCd2       As OraField         '団体コード2
    Dim objCslCount     As OraField         '予約済み人数
    
    Dim vntRsvFraName   As Variant          '予約枠情報（予約枠名称）
    Dim vntOverRsv      As Variant          '予約枠情報（枠人数オーバー登録）
    Dim vntFraType      As Variant          '予約枠情報（枠管理タイプ）
    Dim vntDefCnt0      As Variant          '予約枠情報（デフォルト人数（時間帯枠０））
    Dim vntDefCnt1      As Variant          '予約枠情報（デフォルト人数（時間帯枠１））
    Dim vntDefCnt2      As Variant          '予約枠情報（デフォルト人数（時間帯枠２））
    Dim vntDefCnt3      As Variant          '予約枠情報（デフォルト人数（時間帯枠３））
    Dim vntDefCnt4      As Variant          '予約枠情報（デフォルト人数（時間帯枠４））
    Dim vntDefCnt5      As Variant          '予約枠情報（デフォルト人数（時間帯枠５））
    Dim vntDefCnt6      As Variant          '予約枠情報（デフォルト人数（時間帯枠６））
    Dim vntDefCnt7      As Variant          '予約枠情報（デフォルト人数（時間帯枠７））
    Dim vntDefCnt8      As Variant          '予約枠情報（デフォルト人数（時間帯枠８））
    Dim vntDefCnt9      As Variant          '予約枠情報（デフォルト人数（時間帯枠９））
    Dim lngRsvCount     As Long             '予約済み人数（カウント値）
    Dim strEditDate     As String           '日付編集用
    Dim Ret             As Boolean          'リターンコード
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '引数が正しく設定されていない場合はエラー
    If Not (IsDate(Trim(strStrDate)) And IsDate(Trim(strEndDate))) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If Not IsArray(strArrEmptyCount) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If DateDiff("d", CDate((Trim(strStrDate))), CDate((Trim(strEndDate)))) <> UBound(strArrEmptyCount) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '指定予約枠コードの予約枠情報を取得
    Ret = SelectRsvFra(Trim(strRsvFraCd), vntRsvFraName, vntOverRsv, vntFraType, vntDefCnt0, vntDefCnt1, vntDefCnt2, vntDefCnt3, vntDefCnt4, vntDefCnt5, vntDefCnt6, vntDefCnt7, vntDefCnt8, vntDefCnt9)
    If Ret <> True Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Trim(strStrDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TIMEFRA", lngTimeFra, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVFRACD", Trim(strRsvFraCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMPTYCOUNT", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVCOUNT", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", " ", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", " ", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", " ", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCSLCOUNT", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGRSVCOUNT", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '処理対象日付
    strEditDate = Trim(strStrDate)
    
    '１日ごとに処理する
    For i = 0 To UBound(strArrEmptyCount)
    
        '削除時
        If Trim(strArrEmptyCount(i)) = "" Then
    
            'キー値の設定
            objOraParam("CSLDATE").Value = strEditDate
    
            '該当日・該当時間枠・該当予約枠の予約スケジューリングを削除
            strStmt = "DELETE                      " & vbLf & _
                      "  FROM SCHEDULE             " & vbLf & _
                      " WHERE CSLDATE  = :CSLDATE  " & vbLf & _
                      "   AND TIMEFRA  = :TIMEFRA  " & vbLf & _
                      "   AND RSVFRACD = :RSVFRACD "
            mobjOraDb.ExecuteSQL strStmt
    
            '検査項目枠管理の場合
            If CLng(vntFraType) <> FRA_TYPE_CS Then
                '該当日・該当予約枠の団体予約検査項目枠も合わせて削除
                strStmt = "DELETE                      " & vbLf & _
                          "  FROM ORGRSV_IFRA             " & vbLf & _
                          " WHERE CSLDATE  = :CSLDATE  " & vbLf & _
                          "   AND RSVFRACD = :RSVFRACD "
                mobjOraDb.ExecuteSQL strStmt
            End If
    
        End If
    
        '保存時
        If Trim(strArrEmptyCount(i)) <> "hidden" And _
           Trim(strArrEmptyCount(i)) <> "" Then
    
            'キー値の設定
            objOraParam("CSLDATE").Value = strEditDate
    
            '該当日・該当時間枠・該当予約枠の予約スケジューリングを検索（レコードロック）
            strStmt = "SELECT *                    " & vbLf & _
                      "  FROM SCHEDULE             " & vbLf & _
                      " WHERE CSLDATE  = :CSLDATE  " & vbLf & _
                      "   AND TIMEFRA  = :TIMEFRA  " & vbLf & _
                      "   AND RSVFRACD = :RSVFRACD " & vbLf & _
                      "   FOR UPDATE               "
            Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
            '検索レコードが存在する場合（更新）
            If Not objOraDyna.EOF Then
    
                'キー値の設定
                objOraParam("EMPTYCOUNT").Value = CLng(Trim(strArrEmptyCount(i)))
    
                '該当日・該当時間枠・該当予約枠の予約スケジューリングを更新（予約可能人数）
                strStmt = "UPDATE SCHEDULE                 " & vbLf & _
                          "   SET EMPTYCOUNT = :EMPTYCOUNT " & vbLf & _
                          " WHERE CSLDATE  = :CSLDATE      " & vbLf & _
                          "   AND TIMEFRA  = :TIMEFRA      " & vbLf & _
                          "   AND RSVFRACD = :RSVFRACD     "
                mobjOraDb.ExecuteSQL strStmt
    
            '検索レコードが存在しない場合（新規挿入）
            Else
    
                'すでに登録されている予約済み人数をカウント（受診情報のみカウントするモード）
                lngRsvCount = GetRsvCount(strEditDate, lngTimeFra, Trim(strRsvFraCd), CLng(vntFraType), False)
    
                'キー値の設定
                objOraParam("EMPTYCOUNT").Value = CLng(Trim(strArrEmptyCount(i)))
                objOraParam("RSVCOUNT").Value = lngRsvCount
    
                '該当日・該当時間枠・該当予約枠の予約スケジューリングを登録（新規挿入）
                strStmt = "INSERT INTO SCHEDULE (   " & vbLf & _
                          "            CSLDATE,     " & vbLf & _
                          "            TIMEFRA,     " & vbLf & _
                          "            RSVFRACD,    " & vbLf & _
                          "            EMPTYCOUNT,  " & vbLf & _
                          "            RSVCOUNT     " & vbLf & _
                          "       ) VALUES (        " & vbLf & _
                          "            :CSLDATE,    " & vbLf & _
                          "            :TIMEFRA,    " & vbLf & _
                          "            :RSVFRACD,   " & vbLf & _
                          "            :EMPTYCOUNT, " & vbLf & _
                          "            :RSVCOUNT    " & vbLf & _
                          "       )                 "
                mobjOraDb.ExecuteSQL strStmt
    
                '検査項目枠管理の場合
                If CLng(vntFraType) <> FRA_TYPE_CS Then
    
                    '検索条件を満たす団体予約人数のレコードを取得（時間枠はサマリーする）
                    strStmt = "SELECT CSCD, ORGCD1, ORGCD2, SUM(CSLCOUNT) CSLCOUNT " & vbLf & _
                              "  FROM ORGRSV                                       " & vbLf & _
                              " WHERE CSLDATE = :CSLDATE                           " & vbLf & _
                              " GROUP BY CSCD, ORGCD1, ORGCD2                      "
    
                    Set objOraDyna2 = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
                    '検索レコードが存在する場合
                    If Not objOraDyna2.EOF Then
    
                        'オブジェクトの参照設定
                        Set objFields = objOraDyna2.Fields
                        Set objCsCd = objFields("CSCD")
                        Set objOrgCd1 = objFields("ORGCD1")
                        Set objOrgCd2 = objFields("ORGCD2")
                        Set objCslCount = objFields("CSLCOUNT")
    
                        '団体予約人数（時間枠はサマリー）１レコードごとに処理する
                        Do Until objOraDyna2.EOF
                            '団体予約検査項目枠が必要な場合
                            If CheckOrgRsv_iFra(strEditDate, (objCsCd.Value & ""), (objOrgCd1.Value & ""), (objOrgCd2.Value & ""), Trim(strRsvFraCd)) = True Then
                                'キー値の設定
                                objOraParam("CSCD").Value = objCsCd.Value & ""
                                objOraParam("ORGCD1").Value = objOrgCd1.Value & ""
                                objOraParam("ORGCD2").Value = objOrgCd2.Value & ""
                                objOraParam("ORGCSLCOUNT").Value = CLng(objCslCount.Value & "")
                                objOraParam("ORGRSVCOUNT").Value = GetRsvCount_iFra(strEditDate, (objCsCd.Value & ""), (objOrgCd1.Value & ""), (objOrgCd2.Value & ""))
                                '該当日・該当予約枠の団体予約検査項目枠を登録（新規挿入）
                                strStmt = "INSERT INTO ORGRSV_IFRA ( " & vbLf & _
                                          "            CSLDATE,      " & vbLf & _
                                          "            CSCD,         " & vbLf & _
                                          "            ORGCD1,       " & vbLf & _
                                          "            ORGCD2,       " & vbLf & _
                                          "            RSVFRACD,     " & vbLf & _
                                          "            CSLCOUNT,     " & vbLf & _
                                          "            RSVCOUNT      " & vbLf & _
                                          "       ) VALUES (         " & vbLf & _
                                          "            :CSLDATE,     " & vbLf & _
                                          "            :CSCD,        " & vbLf & _
                                          "            :ORGCD1,      " & vbLf & _
                                          "            :ORGCD2,      " & vbLf & _
                                          "            :RSVFRACD,    " & vbLf & _
                                          "            :ORGCSLCOUNT, " & vbLf & _
                                          "            :ORGRSVCOUNT  " & vbLf & _
                                          "       )                  "
                                mobjOraDb.ExecuteSQL strStmt
                            End If
                            objOraDyna2.MoveNext
                        Loop
    
                    End If
    
                    Set objOraDyna2 = Nothing
    
                End If
    
            End If
    
            Set objOraDyna = Nothing
    
        End If
    
        '処理対象日付を１日進める
        strEditDate = Format(DateAdd("d", 1, strEditDate), "yyyy/m/d")
    
    Next i
    
    '戻り値の設定
    UpdateSchedule = True
    
    objOraParam.Remove "CSLDATE"
    objOraParam.Remove "TIMEFRA"
    objOraParam.Remove "RSVFRACD"
    objOraParam.Remove "EMPTYCOUNT"
    objOraParam.Remove "RSVCOUNT"
    objOraParam.Remove "CSCD"
    objOraParam.Remove "ORGCD1"
    objOraParam.Remove "ORGCD2"
    objOraParam.Remove "ORGCSLCOUNT"
    objOraParam.Remove "ORGRSVCOUNT"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.UpdateSchedule"
    
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
' 機能　　 : ひと月分の病院スケジューリングを一括更新する
'
' 引数　　 : (In)     strStrDate  月始日付
' 　　　　   (In)     strEndDate  月末日付
' 　　　　   (In)     vntHoliday  月始日付～月末日付の設定値（0:未設定，1:休診日，2:祝日）
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function UpdateSchedule_h(ByVal strStrDate As String, ByVal strEndDate As String, ByVal vntHoliday As Variant) As Boolean
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim strEditDate     As String           '日付編集用
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '引数が正しく設定されていない場合はエラー
    If Not (IsDate(Trim(strStrDate)) And IsDate(Trim(strEndDate))) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    If Not IsArray(vntHoliday) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    If DateDiff("d", CDate((Trim(strStrDate))), CDate((Trim(strEndDate)))) <> UBound(vntHoliday) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "DATE1", Trim(strStrDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DATE2", Trim(strEndDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "HOLIDAY", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '該当月の病院スケジュールを全件削除
    strStmt = "DELETE                   " & vbLf & _
              "  FROM SCHEDULE_H        " & vbLf & _
              " WHERE CSLDATE >= :DATE1 " & vbLf & _
              "   AND CSLDATE <= :DATE2 "
    
    mobjOraDb.ExecuteSQL strStmt
    
    '処理対象日付
    strEditDate = Trim(strStrDate)
    
    '１日ごとに処理する
    For i = 0 To UBound(vntHoliday)
    
        '休日・祝日が設定された場合
        If vntHoliday(i) = HOLIDAY_CLS Or vntHoliday(i) = HOLIDAY_HOL Then
    
            'キー値の設定
            objOraParam("DATE1").Value = strEditDate
            objOraParam("HOLIDAY").Value = vntHoliday(i)
    
            '該当日の病院スケジュールを登録
            strStmt = "INSERT INTO SCHEDULE_H ( " & vbLf & _
                      "            CSLDATE,     " & vbLf & _
                      "            HOLIDAY      " & vbLf & _
                      "       ) VALUES (        " & vbLf & _
                      "            :DATE1,      " & vbLf & _
                      "            :HOLIDAY     " & vbLf & _
                      "       )                 "
    
            mobjOraDb.ExecuteSQL strStmt
    
        End If
    
        '処理対象日付を１日進める
        strEditDate = Format(DateAdd("d", 1, strEditDate), "yyyy/m/d")
    
    Next i
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateSchedule_h = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    UpdateSchedule_h = False
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.UpdateSchedule_h"
    
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
' 機能　　 : ひと月分の該当時間枠・該当予約枠の予約スケジューリングを一括更新する
'
' 引数　　 : (In)     dtmStrCslDate     月始日付
' 　　　　   (In)     dtmEndCslDate     月末日付
' 　　　　   (In)     lngTimeFra        時間枠
' 　　　　   (In)     strRsvFraCd       予約枠コード
' 　　　　   (In)     vntArrEmptyCount  月始日付～月末日付の設定値（"hidden":非表示，"":未設定，"0":予約不可，"1"～"999":予約可能）
' 　　　　   (Out)    vntMessage        メッセージ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 : 団体枠、検査項目枠の連動を一切行わない東急版
'
Public Function UpdateSchedule_tk(ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, ByVal lngTimeFra As Long, ByVal strRsvFraCd As String, ByVal vntEmptyCount As Variant, ByRef vntMessage As Variant) As Boolean
    
    Dim objCommon       As Common           '共通クラス
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objCslDate      As OraParameter     '受診日
    Dim objEmptyCount   As OraParameter     '予約可能人数
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCslDate2     As OraField         '受診日
    Dim objRsvCount     As OraField         '予約済み人数
    
    Dim dtmCslDate      As Date             '受診日
    
    Dim vntRsvFraName   As Variant          '予約枠情報（予約枠名称）
    Dim vntOverRsv      As Variant          '予約枠情報（枠人数オーバー登録）
    Dim vntFraType      As Variant          '予約枠情報（枠管理タイプ）
    Dim vntDefCnt0      As Variant          '予約枠情報（デフォルト人数（時間帯枠０））
    Dim vntDefCnt1      As Variant          '予約枠情報（デフォルト人数（時間帯枠１））
    Dim vntDefCnt2      As Variant          '予約枠情報（デフォルト人数（時間帯枠２））
    Dim vntDefCnt3      As Variant          '予約枠情報（デフォルト人数（時間帯枠３））
    Dim vntDefCnt4      As Variant          '予約枠情報（デフォルト人数（時間帯枠４））
    Dim vntDefCnt5      As Variant          '予約枠情報（デフォルト人数（時間帯枠５））
    Dim vntDefCnt6      As Variant          '予約枠情報（デフォルト人数（時間帯枠６））
    Dim vntDefCnt7      As Variant          '予約枠情報（デフォルト人数（時間帯枠７））
    Dim vntDefCnt8      As Variant          '予約枠情報（デフォルト人数（時間帯枠８））
    Dim vntDefCnt9      As Variant          '予約枠情報（デフォルト人数（時間帯枠９））
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntMessage = Empty
    
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
    '指定予約枠コードの予約枠情報を取得
    SelectRsvFra strRsvFraCd, vntRsvFraName, vntOverRsv, vntFraType, vntDefCnt0, vntDefCnt1, vntDefCnt2, vntDefCnt3, vntDefCnt4, vntDefCnt5, vntDefCnt6, vntDefCnt7, vntDefCnt8, vntDefCnt9
    
    'キーおよび更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "TIMEFRA", lngTimeFra, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVFRACD", strRsvFraCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    objOraParam.Add "CSLDATE", 0, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "EMPTYCOUNT", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'パラメータの参照設定
    Set objCslDate = objOraParam("CSLDATE")
    Set objEmptyCount = objOraParam("EMPTYCOUNT")
    
    '指定期間、時間枠の予約枠レコードを削除
    mobjOraDb.ExecuteSQL "DELETE SCHEDULE WHERE CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE AND TIMEFRA=:TIMEFRA AND RSVFRACD=:RSVFRACD"
    
    '該当日・該当時間枠・該当予約枠の予約スケジューリングを挿入するSQLステートメント編集
    strStmt = "INSERT INTO SCHEDULE (       " & vbLf & _
              "                CSLDATE,     " & vbLf & _
              "                TIMEFRA,     " & vbLf & _
              "                RSVFRACD,    " & vbLf & _
              "                EMPTYCOUNT,  " & vbLf & _
              "                RSVCOUNT     " & vbLf & _
              "            ) VALUES (       " & vbLf & _
              "                :CSLDATE,    " & vbLf & _
              "                :TIMEFRA,    " & vbLf & _
              "                :RSVFRACD,   " & vbLf & _
              "                :EMPTYCOUNT, "

    strStmt = strStmt & vbLf & _
              "                ( SELECT COUNT(DISTINCT RSVNO)  " & vbLf & _
              "                    FROM GETTARGETRSVFRACD      " & vbLf & _
              "                   WHERE CSLDATE   = :CSLDATE   " & vbLf & _
              "                     AND TIMEFRA   = :TIMEFRA   " & vbLf & _
              "                     AND RSVFRACD  = :RSVFRACD  " & vbLf & _
              "                     AND CANCELFLG = 0          " & vbLf & _
              "                )                               "
          
    strStmt = strStmt & vbLf & _
              "            ) "

    '予約可能人数を検索
    For i = 0 To UBound(vntEmptyCount)
    
        '更新対象となる受診日を求める
        dtmCslDate = dtmStrCslDate + i
        If dtmCslDate > dtmEndCslDate Then
            Exit For
        End If
        
        '予約可能人数の設定値ごとの処理
        Select Case vntEmptyCount(i)
    
            Case ""         '未設定時は何もしない
            Case "hidden"   '非表示時は何もしない
    
            Case Else       '上記以外
    
                '可変値の編集
                objCslDate.Value = dtmCslDate
                objEmptyCount = CLng(vntEmptyCount(i))
    
                '挿入SQL文の実行
                If objOraSQLStmt Is Nothing Then
                    Set objOraSQLStmt = mobjOraDb.CreateSql(strStmt, ORASQL_FAILEXEC)
                Else
                    objOraSQLStmt.Refresh
                End If
    
        End Select
    
    Next i
    
    Do
    
        '枠を越えた人数の予約を許さない場合、以下でコミット前に本状態が発生しているかをチェックする
        If CLng(vntOverRsv) <> OVER_RSV_DENY Then
            Exit Do
        End If
    
        '予約可能人数より予約済み人数が上回るレコードを取得
        strStmt = "SELECT CSLDATE, RSVCOUNT                           " & vbLf & _
                  "  FROM SCHEDULE                                    " & vbLf & _
                  " WHERE CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE " & vbLf & _
                  "   AND TIMEFRA    = :TIMEFRA                       " & vbLf & _
                  "   AND RSVFRACD   = :RSVFRACD                      " & vbLf & _
                  "   AND EMPTYCOUNT < RSVCOUNT                       " & vbLf & _
                  " ORDER BY CSLDATE, TIMEFRA, RSVFRACD               "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

        '検索レコードが存在しない場合は正常
        If objOraDyna.EOF Then
            Exit Do
        End If
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate2 = objFields("CSLDATE")
        Set objRsvCount = objFields("RSVCOUNT")
    
        'レコードを検索し、メッセージを編集
        Do Until objOraDyna.EOF
            objCommon.AppendArray vntMessage, Day(objCslDate2.Value) & "日にすでに" & objRsvCount.Value & "人の受診対象者が存在します。指定内容で設定できません。"
            objOraDyna.MoveNext
        Loop
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateSchedule_tk = True
    
    'トランザクションをコミット
    If IsEmpty(vntMessage) Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Schedule.UpdateSchedule_tk"
    
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
    Set objCommon = CreateObject("HainsCommon.Common")
    
    'データベース接続
    Set mobjOraSession = CreateObject("OracleInProcServer.XOraSession")
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

