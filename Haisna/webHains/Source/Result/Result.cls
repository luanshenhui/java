VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Result"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext                 As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession              As OraSession      'OraSessionオブジェクト
Private mobjOraDb                   As OraDatabase     'OraDatabaseオブジェクト

'桁数
Private Const LENGTH_RESULTERR      As Integer = 3      '検査結果エラー
Private Const LENGTH_RSLCMTERR      As Integer = 3      '結果コメントエラー
Private Const LENGTH_RET            As Integer = 3      '結果項目エラー
Private Const LENGTH_INSRESULT      As Long = 14        '検査システムでの検査結果
Private Const LENGTH_INSRSLCMTCD    As Long = 3         '検査システムでの結果コメント

'
' 機能　　 : 検査結果入力チェック
'
' 引数　　 : (In)     vntCslDate       受診日
' 　　　　   (In)     vntItemCd        検査項目コード
' 　　　　   (In)     vntSuffix        サフィックス
' 　　　　   (In/Out) vntResult        検査結果
' 　　　　   (Out)    vntShortStc      文章略称
' 　　　　   (Out)    vntResultError   検査結果エラー
' 　　　　   (In/Out) vntRslCmtCd1     結果コメント１
' 　　　　   (Out)    vntRslCmtName1   結果コメント名称１
' 　　　　   (Out)    vntRslCmtError1  結果コメントエラー１
' 　　　　   (In/Out) vntRslCmtCd2     結果コメント２
' 　　　　   (Out)    vntRslCmtName2   結果コメント名称２
' 　　　　   (Out)    vntRslCmtError2  結果コメントエラー２
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckResult( _
    ByVal dtmCslDate As Date, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntShortStc As Variant, _
    ByRef vntResultError As Variant, _
    Optional ByRef vntRslCmtCd1 As Variant, _
    Optional ByRef vntRslCmtName1 As Variant, _
    Optional ByRef vntRslCmtError1 As Variant, _
    Optional ByRef vntRslCmtCd2 As Variant, _
    Optional ByRef vntRslCmtName2 As Variant, _
    Optional ByRef vntRslCmtError2 As Variant _
) As Variant

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objItemCd               As OraParamArray    '検査項目コード
    Dim objSuffix               As OraParamArray    'サフィックス
    Dim objResult               As OraParamArray    '検査結果
    Dim objShortStc             As OraParamArray    '略文章
    Dim objResultError          As OraParamArray    '結果チェックエラーコード
    Dim objRslCmtCd1            As OraParamArray    '結果コメントコード１
    Dim objRslCmtName1          As OraParamArray    '結果コメント名称１
    Dim objRslCmtError1         As OraParamArray    '結果コメントチェック１エラーコード
    Dim objRslCmtCd2            As OraParamArray    '結果コメントコード２
    Dim objRslCmtName2          As OraParamArray    '結果コメント名称２
    Dim objRslCmtError2         As OraParamArray    '結果コメントチェック２エラーコード
    Dim objMessage              As OraParamArray    'メッセージ
    
    Dim vntArrResult()          As Variant          '検査結果
    Dim vntArrShortStc()        As Variant          '略文章
    Dim vntArrResultError()     As Variant          '結果チェックエラーコード
    Dim vntArrRslCmtCd1()       As Variant          '結果コメントコード１
    Dim vntArrRslCmtName1()     As Variant          '結果コメント名１
    Dim vntArrRslCmtError1()    As Variant          '結果コメント１チェックエラーコード
    Dim vntArrRslCmtCd2()       As Variant          '結果コメントコード２
    Dim vntArrRslCmtName2()     As Variant          '結果コメント名２
    Dim vntArrRslCmtError2()    As Variant          '結果コメント２チェックエラーコード
    Dim lngCount                As Long             'レコード数
    
    Dim vntArrMessage()         As Variant          'メッセージ
    Dim lngMsgCount             As Long             'メッセージ数
    
    Dim lngArraySize            As Long             '配列の要素数
    Dim Ret                     As Long             '関数戻り値
    Dim i                       As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    
    lngArraySize = UBound(vntItemCd) + 1
    objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_P_ITEMCD
    objOraParam.AddTable "SUFFIX", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_C_SUFFIX
'    objOraParam.AddTable "RESULT", ORAPARM_BOTH, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSL_RESULT
    objOraParam.AddTable "RESULT", ORAPARM_BOTH, ORATYPE_VARCHAR2, lngArraySize, 400
    objOraParam.AddTable "SHORTSTC", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_SENTENCE_SHORTSTC
    objOraParam.AddTable "RESULTERROR", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 3
    objOraParam.AddTable "RSLCMTCD1", ORAPARM_BOTH, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "RSLCMTNAME1", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTNAME
    objOraParam.AddTable "RSLCMTERROR1", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 3
    objOraParam.AddTable "RSLCMTCD2", ORAPARM_BOTH, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "RSLCMTNAME2", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTNAME
    objOraParam.AddTable "RSLCMTERROR2", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 3
    objOraParam.AddTable "MESSAGE", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, 100, 256
    
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    'OraParameterオブジェクトの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    Set objSuffix = objOraParam("SUFFIX")
    Set objResult = objOraParam("RESULT")
    Set objShortStc = objOraParam("SHORTSTC")
    Set objResultError = objOraParam("RESULTERROR")
    Set objRslCmtCd1 = objOraParam("RSLCMTCD1")
    Set objRslCmtName1 = objOraParam("RSLCMTNAME1")
    Set objRslCmtError1 = objOraParam("RSLCMTERROR1")
    Set objRslCmtCd2 = objOraParam("RSLCMTCD2")
    Set objRslCmtName2 = objOraParam("RSLCMTNAME2")
    Set objRslCmtError2 = objOraParam("RSLCMTERROR2")
    Set objMessage = objOraParam("MESSAGE")
    
    '引数値の編集
    For i = 0 To lngArraySize - 1
        objItemCd(i) = CStr(vntItemCd(i))
        objSuffix(i) = CStr(vntSuffix(i))
        objResult(i) = CStr(vntResult(i))
        If Not IsMissing(vntRslCmtCd1) Then
            objRslCmtCd1(i) = CStr(vntRslCmtCd1(i))
        End If
        If Not IsMissing(vntRslCmtCd2) Then
            objRslCmtCd2(i) = CStr(vntRslCmtCd2(i))
        End If
    Next i
    
    '結果チェック用ストアド呼び出し
    strStmt = "BEGIN :RET := ResultPackage.CheckResult(:CSLDATE, :ITEMCD, :SUFFIX, :RESULT, :SHORTSTC, :RESULTERROR, :RSLCMTCD1, :RSLCMTNAME1, :RSLCMTERROR1, :RSLCMTCD2, :RSLCMTNAME2, :RSLCMTERROR2, :MESSAGE); END;"
    mobjOraDb.ExecuteSQL strStmt
    
    Ret = CLng(objOraParam("RET").Value)
    
    '呼び出し後の結果を取得
    lngCount = UBound(vntItemCd)
    ReDim Preserve vntArrResult(lngCount)
    ReDim Preserve vntArrShortStc(lngCount)
    ReDim Preserve vntArrResultError(lngCount)
    ReDim Preserve vntArrRslCmtCd1(lngCount)
    ReDim Preserve vntArrRslCmtName1(lngCount)
    ReDim Preserve vntArrRslCmtError1(lngCount)
    ReDim Preserve vntArrRslCmtCd2(lngCount)
    ReDim Preserve vntArrRslCmtName2(lngCount)
    ReDim Preserve vntArrRslCmtError2(lngCount)
    For i = 0 To lngCount
        vntArrResult(i) = CStr(objResult(i) & "")
        vntArrShortStc(i) = CStr(objShortStc(i) & "")
        vntArrResultError(i) = CStr(objResultError(i) & "")
        vntArrRslCmtCd1(i) = CStr(objRslCmtCd1(i) & "")
        vntArrRslCmtName1(i) = CStr(objRslCmtName1(i) & "")
        vntArrRslCmtError1(i) = CStr(objRslCmtError1(i) & "")
        vntArrRslCmtCd2(i) = CStr(objRslCmtCd2(i) & "")
        vntArrRslCmtName2(i) = CStr(objRslCmtName2(i) & "")
        vntArrRslCmtError2(i) = CStr(objRslCmtError2(i) & "")
    Next i
    
    '戻り値の設定(エラーに関わらず戻す値)
    vntResult = vntArrResult
    vntShortStc = vntArrShortStc
    vntResultError = vntArrResultError
    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = vntArrRslCmtCd1
    If Not IsMissing(vntRslCmtName1) Then vntRslCmtName1 = vntArrRslCmtName1
    If Not IsMissing(vntRslCmtError1) Then vntRslCmtError1 = vntArrRslCmtError1
    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = vntArrRslCmtCd2
    If Not IsMissing(vntRslCmtName2) Then vntRslCmtName2 = vntArrRslCmtName2
    If Not IsMissing(vntRslCmtError2) Then vntRslCmtError2 = vntArrRslCmtError2
    
    'チェックエラー時
    If Ret <= 0 Then
    
        'バインド配列内容を検索し、メッセージを取得
        Do Until lngMsgCount >= objMessage.ArraySize
            
            'メッセージが格納されていなければここで終了
            If objMessage(lngMsgCount) = "" Then
                Exit Do
            End If
            
            '配列形式で格納する
            ReDim Preserve vntArrMessage(lngMsgCount)
            vntArrMessage(lngMsgCount) = CStr(objMessage(lngMsgCount))
            lngMsgCount = lngMsgCount + 1
        
        Loop
    
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の編集
    If lngMsgCount > 0 Then
        CheckResult = vntArrMessage
    Else
        CheckResult = Empty
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.CheckResult"
    
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

' 機能　　 : 検査結果入力チェック
'
' 引数　　 : (In)     vntCslDate     受診日
' 　　　　 : (In)     vntItemCd      検査項目コード
' 　　　　 : (In)     vntSuffix      サフィックス
' 　　　　 : (I/O)    vntResult      検査結果
' 　　　　 : (Out)    vntResultErr   検査結果エラー
' 　　　　 : (Out)    vntShortStc    文章略称
' 　　　　 : (I/O)    vntRslCmtCd1   結果コメント１
' 　　　　 : (Out)    vntRslCmtErr1  結果コメントエラー１
' 　　　　 : (Out)    vntRslCmtName1 結果コメント名称１
' 　　　　 : (I/O)    vntRslCmtCd2   結果コメント２
' 　　　　 : (Out)    vntRslCmtErr2  結果コメントエラー２
' 　　　　 : (Out)    vntRslCmtName2 結果コメント名称２
' 　　　　 : (Out)    vntRet         検査項目読み込みエラー
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckRslAllSet1Value(ByVal vntYear As Variant, _
                                     ByVal vntMonth As Variant, _
                                     ByVal vntDay As Variant, _
                                     ByRef vntCslDate As Variant, _
                                     ByRef vntDayIdF As Variant, _
                                     ByRef vntDayIdT As Variant _
                                    ) As Variant

    Dim objCommon               As Common       '共通クラス
    
    Dim vntArrMessage           As Variant      'エラーメッセージの集合
    
    Dim lngDayIdF               As Long         '編集用当日ＩＤ（自）
    Dim lngDayIdT               As Long         '編集用当日ＩＤ（至）
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    With objCommon
        '受診日チェック
        .AppendArray vntArrMessage, .CheckDate("受診日", vntYear, vntMonth, vntDay, vntCslDate, CHECK_NECESSARY)
        '当日ＩＤチェック
        .AppendArray vntArrMessage, .CheckNumeric("当日ＩＤ（自）", vntDayIdF, LENGTH_RECEIPT_DAYID)
        .AppendArray vntArrMessage, .CheckNumeric("当日ＩＤ（至）", vntDayIdT, LENGTH_RECEIPT_DAYID)
    
        '当日ＩＤ範囲チェック
        Do
            'エラーがある場合は何もしない
            If IsArray(vntArrMessage) Then
                Exit Do
            End If

            If vntDayIdF = "" Then
                lngDayIdF = 0
            Else
                lngDayIdF = CLng(vntDayIdF)
            End If
            If vntDayIdT = "" Then
                lngDayIdT = 9999
            Else
                lngDayIdT = CLng(vntDayIdT)
            End If
            
            '大小範囲チェック
            If lngDayIdF > lngDayIdT Then
                .AppendArray vntArrMessage, "当日ＩＤの範囲指定に誤りがあります"
                Exit Do
            End If
            
            If vntDayIdF <> "" Then
                vntDayIdF = Format(lngDayIdF, "0000")
            End If
            If vntDayIdT <> "" Then
                vntDayIdT = Format(lngDayIdT, "0000")
            End If
            
            Exit Do
        Loop
    
    End With
    
    If IsArray(vntArrMessage) Then
        CheckRslAllSet1Value = vntArrMessage
    End If
    
    '共通クラスのインスタンス削除
    Set objCommon = Nothing

End Function

'
' 機能　　 : 検査結果入力チェック
'
' 引数　　 : (In)     vntYear       受診日（年）
' 　　　　 : (In)     vntMonth      受診日（月）
' 　　　　 : (In)     vntDay        受診日（日）
' 　　　　 : (In)     vntDayIdF     表示開始当日ＩＤ
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckRslListSetConditionValue(ByVal vntYear As Variant, _
                                              ByVal vntMonth As Variant, _
                                              ByVal vntDay As Variant, _
                                              ByRef vntCslDate As Variant, _
                                              ByVal vntDayIdF As Variant _
                                             ) As Variant

    Dim objCommon               As Common       '共通クラス
    
    Dim vntArrMessage           As Variant      'エラーメッセージの集合
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    With objCommon
        '受診日チェック
        .AppendArray vntArrMessage, .CheckDate("受診日", vntYear, vntMonth, vntDay, vntCslDate, CHECK_NECESSARY)
        '当日ＩＤチェック
        .AppendArray vntArrMessage, .CheckNumeric("当日ＩＤ", vntDayIdF, LENGTH_RECEIPT_DAYID)
    
    End With
    
    If IsArray(vntArrMessage) Then
        CheckRslListSetConditionValue = vntArrMessage
    End If
    
End Function

'
' 機能　　 : 検査システムから取得した検査結果のチェック
'
' 引数　　 : (In)     lngRsvNo         予約番号
' 　　　　   (In)     lngSepOrderDiv   オーダ分割区分
' 　　　　   (In)     vntInsItemCd     検査用検査項目コード
' 　　　　   (Out)    vntItemCd        検査項目コード
' 　　　　   (Out)    vntSuffix        サフィックス
' 　　　　   (Out)    vntItemName      検査項目名
' 　　　　   (In)     vntInsResult     検査システムでの検査結果
' 　　　　   (Out)    vntResult        検査結果
' 　　　　   (Out)    vntResultErr     検査結果のエラー状態
' 　　　　   (In)     vntInsRslCmtCd1  検査システムでの結果コメント1
' 　　　　   (Out)    vntRslCmtCd1     結果コメント1
' 　　　　   (Out)    vntRslCmtErr1    結果コメント1のエラー状態
' 　　　　   (In)     vntInsRslCmtCd1  検査システムでの結果コメント2
' 　　　　   (Out)    vntRslCmtCd2     結果コメント2
' 　　　　   (Out)    vntRslCmtErr2    結果コメント2のエラー状態
' 　　　　   (Out)    vntRet           検査項目のエラー状態
'
' 戻り値　 :
'
' 備考　　 :
'
'## 2003.01.07 Mod 33Lines By T.Takagi@FSIT 東急対応
'Public Sub CheckRslValueOfInspection(
'    ByVal lngRsvNo As Long,
'    ByVal vntInsItemCd As Variant,
'    ByRef vntItemCd As Variant,
'    ByRef vntSuffix As Variant,
'    ByVal vntInsResult As Variant,
'    ByRef vntResult As Variant,
'    ByRef vntResultErr As Variant,
'    ByVal vntInsRslCmtCd1 As Variant,
'    ByRef vntRslCmtCd1 As Variant,
'    ByRef vntRslCmtErr1 As Variant,
'    ByVal vntInsRslCmtCd2 As Variant,
'    ByRef vntRslCmtCd2 As Variant,
'    ByRef vntRslCmtErr2 As Variant,
'    ByRef vntRet As Variant
')
'## 2003.02.12 Mod 35Lines By T.Takagi@FSIT オーダ分割区分対応
'Public Sub CheckRslValueOfInspection(
'    ByVal lngRsvNo As Long,
'    ByVal vntInsItemCd As Variant,
'    ByRef vntItemCd As Variant,
'    ByRef vntSuffix As Variant,
'    ByRef vntItemName As Variant,
'    ByVal vntInsResult As Variant,
'    ByRef vntResult As Variant,
'    ByRef vntResultErr As Variant,
'    ByVal vntInsRslCmtCd1 As Variant,
'    ByRef vntRslCmtCd1 As Variant,
'    ByRef vntRslCmtErr1 As Variant,
'    ByVal vntInsRslCmtCd2 As Variant,
'    ByRef vntRslCmtCd2 As Variant,
'    ByRef vntRslCmtErr2 As Variant,
'    ByRef vntRet As Variant
')
Public Sub CheckRslValueOfInspection( _
    ByVal lngRsvNo As Long, _
    ByVal lngSepOrderDiv As Long, _
    ByVal vntInsItemCd As Variant, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntItemName As Variant, _
    ByVal vntInsResult As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntResultErr As Variant, _
    ByVal vntInsRslCmtCd1 As Variant, _
    ByRef vntRslCmtCd1 As Variant, _
    ByRef vntRslCmtErr1 As Variant, _
    ByVal vntInsRslCmtCd2 As Variant, _
    ByRef vntRslCmtCd2 As Variant, _
    ByRef vntRslCmtErr2 As Variant, _
    ByRef vntRet As Variant _
)
'## 2003.02.12 Mod End
'## 2003.01.07 Mod End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim vntArrItemCd()      As Variant           '検査項目コード
    Dim vntArrSuffix()      As Variant           'サフィックス
'## 2003.01.07 Add 1Lines By T.Takagi@FSIT 東急対応
    Dim vntArrItemName()    As Variant           '検査項目名
'## 2003.01.07 Add End
    Dim vntArrResult()      As Variant           '検査結果
    Dim vntArrResultErr()   As Variant           '検査結果のエラー状態
    Dim vntArrRslCmtCd1()   As Variant           '結果コメント1
    Dim vntArrRslCmtErr1()  As Variant           '結果コメント1のエラー状態
    Dim vntArrRslCmtCd2()   As Variant           '結果コメント2
    Dim vntArrRslCmtErr2()  As Variant           '結果コメント2のエラー状態
    Dim vntArrRet()         As Variant           '検査項目のエラー状態
    
    Dim objRsvNo            As OraParameter     '予約番号
    Dim objInsItemCd        As OraParamArray    '検査用検査項目コード
    Dim objItemCd           As OraParamArray    '検査項目コード
    Dim objSuffix           As OraParamArray    'サフィックス
'## 2003.01.07 Add 1Lines By T.Takagi@FSIT 東急対応
    Dim objItemName         As OraParamArray    '検査項目名
'## 2003.01.07 Add End
    Dim objInsResult        As OraParamArray    '検査システムでの検査結果
    Dim objResult           As OraParamArray    '検査結果
    Dim objResultErr        As OraParamArray    '検査結果のエラー状態
    Dim objInsRslCmtCd1     As OraParamArray    '検査システムでの結果コメント1
    Dim objRslCmtCd1        As OraParamArray    '結果コメント1
    Dim objRslCmtErr1       As OraParamArray    '結果コメント1のエラー状態
    Dim objInsRslCmtCd2     As OraParamArray    '検査システムでの結果コメント2
    Dim objRslCmtCd2        As OraParamArray    '結果コメント2
    Dim objRslCmtErr2       As OraParamArray    '結果コメント2のエラー状態
    Dim objRet              As OraParamArray    '検査項目のエラー状態
    
    Dim lngArraySize        As Long             '配列数
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntItemCd = Empty
    vntSuffix = Empty
'## 2003.01.07 Add 1Line By T.Takagi@FSIT 東急対応
    vntItemName = Empty
'## 2003.01.07 Add End
    vntResult = Empty
    vntResultErr = Empty
    vntRslCmtCd1 = Empty
    vntRslCmtErr1 = Empty
    vntRslCmtCd2 = Empty
    vntRslCmtErr2 = Empty
    vntRet = Empty

    If Not IsArray(vntInsItemCd) Then
        Exit Sub
    End If
    
    '配列数の設定
    lngArraySize = UBound(vntInsItemCd) + 1
    
    '出力用変数の配列作成
    ReDim Preserve vntArrItemCd(lngArraySize - 1)
    ReDim Preserve vntArrSuffix(lngArraySize - 1)
'## 2003.01.07 Add 1Lines By T.Takagi@FSIT 東急対応
    ReDim Preserve vntArrItemName(lngArraySize - 1)
'## 2003.01.07 Add End
    ReDim Preserve vntArrResult(lngArraySize - 1)
    ReDim Preserve vntArrResultErr(lngArraySize - 1)
    ReDim Preserve vntArrRslCmtCd1(lngArraySize - 1)
    ReDim Preserve vntArrRslCmtErr1(lngArraySize - 1)
    ReDim Preserve vntArrRslCmtCd2(lngArraySize - 1)
    ReDim Preserve vntArrRslCmtErr2(lngArraySize - 1)
    ReDim Preserve vntArrRet(lngArraySize - 1)
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ROWS", lngArraySize, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.12 Add 1Line By T.Takagi@FSIT オーダ分割区分対応
    objOraParam.Add "SEPORDERDIV", lngSepOrderDiv, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.12 Add End
    
    objOraParam.AddTable "INSITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_H_INSITEMCD
    objOraParam.AddTable "ITEMCD", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_P_ITEMCD
    objOraParam.AddTable "SUFFIX", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_C_SUFFIX
'## 2003.01.07 Add 1Lines By T.Takagi@FSIT 東急対応
    objOraParam.AddTable "ITEMNAME", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 20
'## 2003.01.07 Add End
    objOraParam.AddTable "INSRESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_INSRESULT
'    objOraParam.AddTable "RESULT", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSL_RESULT
    objOraParam.AddTable "RESULT", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 400
    objOraParam.AddTable "RESULTERR", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RESULTERR
    objOraParam.AddTable "INSRSLCMTCD1", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_INSRSLCMTCD
    objOraParam.AddTable "RSLCMTCD1", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "RSLCMTERR1", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMTERR
    objOraParam.AddTable "INSRSLCMTCD2", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_INSRSLCMTCD
    objOraParam.AddTable "RSLCMTCD2", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "RSLCMTERR2", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMTERR
    objOraParam.AddTable "RET", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RET

    'OraParameterオブジェクトの参照設定
    Set objRsvNo = objOraParam("RSVNO")
    Set objInsItemCd = objOraParam("INSITEMCD")
    Set objItemCd = objOraParam("ITEMCD")
    Set objSuffix = objOraParam("SUFFIX")
'## 2003.01.07 Add 1Lines By T.Takagi@FSIT 東急対応
    Set objItemName = objOraParam("ITEMNAME")
'## 2003.01.07 Add End
    Set objInsResult = objOraParam("INSRESULT")
    Set objResult = objOraParam("RESULT")
    Set objResultErr = objOraParam("RESULTERR")
    Set objInsRslCmtCd1 = objOraParam("INSRSLCMTCD1")
    Set objRslCmtCd1 = objOraParam("RSLCMTCD1")
    Set objRslCmtErr1 = objOraParam("RSLCMTERR1")
    Set objInsRslCmtCd2 = objOraParam("INSRSLCMTCD2")
    Set objRslCmtCd2 = objOraParam("RSLCMTCD2")
    Set objRslCmtErr2 = objOraParam("RSLCMTERR2")
    Set objRet = objOraParam("RET")
    
    '入力用パラメタ値の編集
    For i = 0 To lngArraySize - 1
        objInsItemCd(i) = vntInsItemCd(i) & ""
        objInsResult(i) = vntInsResult(i) & ""
        objInsRslCmtCd1(i) = vntInsRslCmtCd1(i) & ""
        objInsRslCmtCd2(i) = vntInsRslCmtCd2(i) & ""
    Next i
    
    '結果チェック用ストアドパッケージの関数呼び出し
'## 2003.01.07 Mod 37Lines By T.Takagi@FSIT 東急対応
'    strStmt = "BEGIN CheckResultPackage.CheckResult ( " & vbLf & _
'              "          :RSVNO,                      " & vbLf & _
'              "          :INSITEMCD,                  " & vbLf & _
'              "          :ITEMCD,                     " & vbLf & _
'              "          :SUFFIX,                     " & vbLf & _
'              "          :INSRESULT,                  " & vbLf & _
'              "          :RESULT,                     " & vbLf & _
'              "          :RESULTERR,                  " & vbLf & _
'              "          :INSRSLCMTCD1,               " & vbLf & _
'              "          :RSLCMTCD1,                  " & vbLf & _
'              "          :RSLCMTERR1,                 " & vbLf & _
'              "          :INSRSLCMTCD2,               " & vbLf & _
'              "          :RSLCMTCD2,                  " & vbLf & _
'              "          :RSLCMTERR2,                 " & vbLf & _
'              "          :RET,                        " & vbLf & _
'              "          :ROWS                        " & vbLf & _
'              "      );                               " & vbLf & _
'              "END;                                   "
'## 2003.02.12 Mod 39Lines By T.Takagi@FSIT オーダ分割区分対応
'    strStmt = "BEGIN CheckResultPackage.CheckResult ( " & vbLf & _
'              "          :RSVNO,                      " & vbLf & _
'              "          :INSITEMCD,                  " & vbLf & _
'              "          :ITEMCD,                     " & vbLf & _
'              "          :SUFFIX,                     " & vbLf & _
'              "          :ITEMNAME,                   " & vbLf & _
'              "          :INSRESULT,                  " & vbLf & _
'              "          :RESULT,                     " & vbLf & _
'              "          :RESULTERR,                  " & vbLf & _
'              "          :INSRSLCMTCD1,               " & vbLf & _
'              "          :RSLCMTCD1,                  " & vbLf & _
'              "          :RSLCMTERR1,                 " & vbLf & _
'              "          :INSRSLCMTCD2,               " & vbLf & _
'              "          :RSLCMTCD2,                  " & vbLf & _
'              "          :RSLCMTERR2,                 " & vbLf & _
'              "          :RET,                        " & vbLf & _
'              "          :ROWS                        " & vbLf & _
'              "      );                               " & vbLf & _
'              "END;                                   "
    strStmt = "BEGIN CheckResultPackage.CheckResult ( " & vbLf & _
              "          :RSVNO,                      " & vbLf & _
              "          :SEPORDERDIV,                " & vbLf & _
              "          :INSITEMCD,                  " & vbLf & _
              "          :ITEMCD,                     " & vbLf & _
              "          :SUFFIX,                     " & vbLf & _
              "          :ITEMNAME,                   " & vbLf & _
              "          :INSRESULT,                  " & vbLf & _
              "          :RESULT,                     " & vbLf & _
              "          :RESULTERR,                  " & vbLf & _
              "          :INSRSLCMTCD1,               " & vbLf & _
              "          :RSLCMTCD1,                  " & vbLf & _
              "          :RSLCMTERR1,                 " & vbLf & _
              "          :INSRSLCMTCD2,               " & vbLf & _
              "          :RSLCMTCD2,                  " & vbLf & _
              "          :RSLCMTERR2,                 " & vbLf & _
              "          :RET,                        " & vbLf & _
              "          :ROWS                        " & vbLf & _
              "      );                               " & vbLf & _
              "END;                                   "
'## 2003.02.12 Mod End
'## 2003.01.07 Mod End
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'チェック結果を格納
    For i = 0 To lngArraySize - 1
        vntArrItemCd(i) = objItemCd(i) & ""
        vntArrSuffix(i) = objSuffix(i) & ""
'## 2003.01.07 Add 1Lines By T.Takagi@FSIT 東急対応
        vntArrItemName(i) = objItemName(i) & ""
'## 2003.01.07 Add End
        vntArrResult(i) = objResult(i) & ""
        vntArrResultErr(i) = objResultErr(i) & ""
        vntArrRslCmtCd1(i) = objRslCmtCd1(i) & ""
        vntArrRslCmtErr1(i) = objRslCmtErr1(i) & ""
        vntArrRslCmtCd2(i) = objRslCmtCd2(i) & ""
        vntArrRslCmtErr2(i) = objRslCmtErr2(i) & ""
        vntArrRet(i) = objRet(i) & ""
    Next i
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
'## 2003.01.07 Add 1Lines By T.Takagi@FSIT 東急対応
    vntItemName = vntArrItemName
'## 2003.01.07 Add End
    vntResult = vntArrResult
    vntResultErr = vntArrResultErr
    vntRslCmtCd1 = vntArrRslCmtCd1
    vntRslCmtErr1 = vntArrRslCmtErr1
    vntRslCmtCd2 = vntArrRslCmtCd2
    vntRslCmtErr2 = vntArrRslCmtErr2
    vntRet = vntArrRet
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Sub
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.CheckRslValueOfInspection"
    
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
    
End Sub

'
' 機能　　 : 検査結果テーブルを更新する(レコードが存在しない場合は挿入)
'
' 引数　　 : (In)     lngRsvNo   予約番号
' 　　　　   (In)     vntItemCd  検査項目コード
' 　　　　   (In)     vntSuffix  サフィックス
' 　　　　   (In)     vntResult  検査結果
'
' 戻り値　 : エラーメッセージ
'
' 備考　　 :
'
Public Function MergeRsl(ByVal lngRsvNo As Long, ByRef vntItemCd As Variant, ByRef vntSuffix As Variant, ByRef vntResult As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objItemCd       As OraParameter     '検査項目コード
    Dim objSuffix       As OraParameter     'サフィックス
    Dim objResult       As OraParameter     '検査結果
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RESULT", "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    'OraParameterオブジェクトの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    Set objSuffix = objOraParam("SUFFIX")
    Set objResult = objOraParam("RESULT")
    
    '検査結果更新用のSQLステートメント作成
    strStmt = "MERGE INTO RSL                                      " & vbLf & _
              "      USING ( SELECT :RSVNO  RSVNO,                 " & vbLf & _
              "                     :ITEMCD ITEMCD,                " & vbLf & _
              "                     :SUFFIX SUFFIX,                " & vbLf & _
              "                     :RESULT RESULT                 " & vbLf & _
              "                FROM DUAL                           " & vbLf & _
              "            ) BASEDRSL                              " & vbLf & _
              "         ON ( RSL.RSVNO  = BASEDRSL.RSVNO  AND      " & vbLf & _
              "              RSL.ITEMCD = BASEDRSL.ITEMCD AND      " & vbLf & _
              "              RSL.SUFFIX = BASEDRSL.SUFFIX )        " & vbLf & _
              "       WHEN MATCHED THEN                            " & vbLf & _
              "            UPDATE SET RSL.RESULT = BASEDRSL.RESULT " & vbLf & _
              "       WHEN NOT MATCHED THEN                        " & vbLf & _
              "            INSERT ( RSL.RSVNO,                     " & vbLf & _
              "                     RSL.ITEMCD,                    " & vbLf & _
              "                     RSL.SUFFIX,                    " & vbLf & _
              "                     RSL.RESULT )                   " & vbLf & _
              "            VALUES ( BASEDRSL.RSVNO,                " & vbLf & _
              "                     BASEDRSL.ITEMCD,               " & vbLf & _
              "                     BASEDRSL.SUFFIX,               " & vbLf & _
              "                     BASEDRSL.RESULT )              "
    
    '各配列値の更新処理
    For i = 0 To UBound(vntItemCd)
        
        '配列値の編集
        objItemCd.Value = CStr(vntItemCd(i))
        objSuffix.Value = CStr(vntSuffix(i))
        objResult.Value = CStr(vntResult(i))
    
        '更新SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
    
    Next i

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    MergeRsl = True
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.MergeRsl"
    
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
' 機能　　 : 個人ＩＤの検査項目情報を取得する
'
' 引数　　 : (In)     strPerId        個人ＩＤ
' 　　　　 : (In)     strCslDate      指定受診日（以前）
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntSuffix       サフィックス
' 　　　　 : (Out)    vntItemName     検査項目名
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 指定受診日以前の検査項目コード・サフィックスをすべて返す
'
Public Function SelectHistoryAllItemList(ByVal strPerId As String, _
                                         ByVal strCslDate As String, _
                                         ByRef vntItemCd As Variant, _
                                         ByRef vntSuffix As Variant, _
                                         ByRef vntItemName As Variant _
                                        ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    
    Dim lngCount            As Long             'レコード数
    
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '個人ＩＤ・受診日が設定されていない場合はエラー
    If IsEmpty(strPerId) Or IsEmpty(strCslDate) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLDATE", Trim(strCslDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CANCELFLG", CStr(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす受診歴情報のレコードを取得
    strStmt = "SELECT R.ITEMCD, R.SUFFIX, IC.ITEMNAME   " & vbLf & _
              "  FROM CONSULT C, RSL R, ITEM_C IC       " & vbLf & _
              " WHERE C.PERID     =  :PERID             " & vbLf & _
              "   AND C.CSLDATE   <= :CSLDATE           " & vbLf & _
              "   AND C.CANCELFLG =  :CANCELFLG         " & vbLf & _
              "   AND C.RSVNO     =  R.RSVNO            " & vbLf & _
              "   AND R.ITEMCD    =  IC.ITEMCD          " & vbLf & _
              "   AND R.SUFFIX    =  IC.SUFFIX          " & vbLf & _
              " GROUP BY R.ITEMCD, R.SUFFIX, IC.ITEMNAME"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrSuffix(lngCount) = objSuffix.Value
            vntArrItemName(lngCount) = objItemName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    
    SelectHistoryAllItemList = lngCount
    
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
    WriteErrorLog "Result.SelectHistoryAllItemList"
    
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
' 機能　　 : 個人ＩＤ・検査項目と合致する検査結果情報を取得する
'
' 引数　　 : (In)     strPerId        個人ＩＤ
' 　　　　 : (In)     vntCslDate      受診日（配列可）
' 　　　　 : (In)     vntItemCd       検査項目コード
' 　　　　 : (In)     vntSuffix       サフィックス
' 　　　　 : (Out)    vntResult       検査結果
' 　　　　 : (Out)    vntColor        色
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 指定受診日／検査項目コード・サフィックスの検査結果を返す
'
Public Function SelectHistoryItemResultList( _
    ByVal vntRsvNo As Variant, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntColor As Variant _
) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objCommon           As Common           '共通クラス
    
    Dim objParamItemCd      As OraParamArray    '検査項目コード
    Dim objParamSuffix      As OraParamArray    'サフィックス
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objResult           As OraField         '検査結果
    Dim objResultType       As OraField         '結果タイプ
    Dim objShortStc         As OraField         '略文章
    Dim objStdFlg           As OraField         '基準値フラグ
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrColor()       As Variant          '色の配列
    
    Dim lngCount            As Long             'レコード数
    Dim lngArraySize        As Long             '検索レコード配列数
    
    Dim blnEmptyFlg         As Boolean          '配列空フラグ
    
    Dim i                   As Long             'インデックス
    Dim j                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    '予約番号が配列の場合
    If IsArray(vntRsvNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '検査項目が配列の場合
    If IsArray(vntItemCd) Then
        'サフィックスが配列でない場合は処理終了
        If Not IsArray(vntSuffix) Then
            Err.Raise 9     '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        '検査項目・サフィックスの配列サイズが一致しない場合は処理終了
        If UBound(vntItemCd) <> UBound(vntSuffix) Then
            Err.Raise 9     '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        vntArrItemCd = vntItemCd
        vntArrSuffix = vntSuffix
    Else
        'サフィックスが配列の場合は処理終了
        If IsArray(vntSuffix) Then
            Err.Raise 9     '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        vntArrItemCd = Array(vntItemCd)
        vntArrSuffix = Array(vntSuffix)
    End If
    
    '配列数
    lngArraySize = UBound(vntArrItemCd) + 1

    '検査結果・色配列作成
    ReDim vntArrResult(UBound(vntArrItemCd))
    ReDim vntArrColor(UBound(vntArrItemCd))
    
    lngCount = 0
        
        'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(vntRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす検査結果情報のレコードを取得
    strStmt = "SELECT BASEDRSL.RSVNO,  BASEDRSL.ITEMCD,              " & vbLf & _
              "       BASEDRSL.SUFFIX, BASEDRSL.RESULT,              " & vbLf & _
              "       BASEDRSL.RESULTTYPE,                           " & vbLf & _
              "       SENTENCE.SHORTSTC, STDVALUE_C.STDFLG           " & vbLf & _
              "  FROM STDVALUE_C, SENTENCE,                          " & vbLf & _
              "       ( SELECT RSL.RSVNO,  RSL.ITEMCD,               " & vbLf & _
              "                RSL.SUFFIX, RSL.RESULT,               " & vbLf & _
              "                RSL.STDVALUECD,                       " & vbLf & _
              "                ITEM_C.ITEMTYPE, ITEM_C.STCITEMCD,    " & vbLf & _
              "                ITEM_C.RESULTTYPE                     " & vbLf & _
              "           FROM RSL, ITEM_C                           " & vbLf & _
              "          WHERE RSL.RSVNO  = :RSVNO                   " & vbLf & _
              "            AND RSL.ITEMCD = ITEM_C.ITEMCD            " & vbLf & _
              "            AND RSL.SUFFIX = ITEM_C.SUFFIX            " & vbLf & _
              "       ) BASEDRSL                                     " & vbLf & _
              " WHERE BASEDRSL.STCITEMCD  = SENTENCE.ITEMCD(+)       " & vbLf & _
              "   AND BASEDRSL.ITEMTYPE   = SENTENCE.ITEMTYPE(+)     " & vbLf & _
              "   AND BASEDRSL.RESULT     = SENTENCE.STCCD(+)        " & vbLf & _
              "   AND BASEDRSL.STDVALUECD = STDVALUE_C.STDVALUECD(+) "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objResult = objFields("RESULT")
        Set objResultType = objFields("RESULTTYPE")
        Set objShortStc = objFields("SHORTSTC")
        Set objStdFlg = objFields("STDFLG")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            '配列上の位置を求める
            For i = 0 To UBound(vntArrItemCd)
                If vntArrItemCd(i) = objItemCd.Value And vntArrSuffix(i) = objSuffix.Value Then
                    If objResultType.Value = RESULTTYPE_SENTENCE And Not IsNull(objShortStc.Value) Then
                        vntArrResult(i) = objShortStc.Value
                    Else
                        vntArrResult(i) = objResult.Value & ""
                    End If
                    objCommon.SelectStdFlgColor objStdFlg.Value & "_COLOR", vntArrColor(i)
                    lngCount = lngCount + 1
                    Exit For
                End If
            Next i
            objOraDyna.MoveNext
        Loop
    End If
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
        
    '戻り値の設定
    vntResult = vntArrResult
    vntColor = vntArrColor
    SelectHistoryItemResultList = lngCount
    
    Set objCommon = Nothing
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.SelectHistoryItemResultList"
    
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
' 機能　　 : 検索条件を満たす検査項目の一覧を取得する
'
' 引数　　 : (In)     vntMode           入力対象モード
' 　　　　   (In)     vntRsvNo          予約番号
' 　　　　   (In)     vntCode           入力対象コード
' 　　　　   (Out)    vntUpdItemCount   更新可能項目数
' 　　　　   (Out)    vntSeq            表示行位置
' 　　　　   (Out)    vntItemCd         検査項目コード
' 　　　　   (Out)    vntSuffix         サフィックス
' 　　　　   (Out)    vntItemName       検査項目名称
' 　　　　   (Out)    vntResult         検査結果
' 　　　　   (Out)    vntResultType     結果タイプ
' 　　　　   (Out)    vntItemType       項目タイプ
' 　　　　   (Out)    vntStcItemCd      文章参照用項目コード
' 　　　　   (Out)    vntShortStc       文章略称
' 　　　　   (Out)    vntRslCmtCd1      結果コメントコード１
' 　　　　   (Out)    vntRslCmtName1    結果コメント名称１
' 　　　　   (Out)    vntRslCmtCd2      結果コメントコード２
' 　　　　   (Out)    vntRslCmtName2    結果コメント名称２
' 　　　　   (Out)    vntStdFlg         基準値フラグ
' 　　　　   (Out)    vntDefResult      省略時検査結果
' 　　　　   (Out)    vntDefShortStc    省略時文章略称
' 　　　　   (Out)    vntDefRslCmtCd    省略時結果コメントコード
' 　　　　   (Out)    vntDefRslCmtName  省略時結果コメント名称
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
'## 2003.01.04 Mod 47Lines By T.Takagi@FSIT 東急対応
'Public Function SelectRslList(ByVal vntMode As Variant,
'                              ByVal vntRsvNo As Variant,
'                              ByVal vntCode As Variant,
'                              ByRef vntUpdItemCount As Variant,
'                              ByRef vntSeq As Variant,
'                              ByRef vntConsultFlg As Variant,
'                              ByRef vntItemCd As Variant,
'                              ByRef vntSuffix As Variant,
'                              ByRef vntItemName As Variant,
'                              ByRef vntResult As Variant,
'                              ByRef vntResultType As Variant,
'                              ByRef vntItemType As Variant,
'                              ByRef vntStcItemCd As Variant,
'                              ByRef vntShortStc As Variant,
'                              ByRef vntRslCmtCd1 As Variant,
'                              ByRef vntRslCmtName1 As Variant,
'                              ByRef vntRslCmtCd2 As Variant,
'                              ByRef vntRslCmtName2 As Variant,
'                              ByRef vntBefResult As Variant,
'                              ByRef vntBefShortStc As Variant,
'                              Optional ByRef vntStdFlg As Variant
'                             ) As Long
'## 2003.03.03 Mod 50Lines By T.Takagi@FSIT 前回予約番号取得
'Public Function SelectRslList(
'    ByVal vntMode As Variant,
'    ByVal vntRsvNo As Variant,
'    ByVal vntCode As Variant,
'    ByRef vntUpdItemCount As Variant,
'    ByRef vntSeq As Variant,
'    ByRef vntConsultFlg As Variant,
'    ByRef vntItemCd As Variant,
'    ByRef vntSuffix As Variant,
'    ByRef vntItemName As Variant,
'    ByRef vntResult As Variant,
'    ByRef vntResultType As Variant,
'    ByRef vntItemType As Variant,
'    ByRef vntStcItemCd As Variant,
'    ByRef vntShortStc As Variant,
'    ByRef vntRslCmtCd1 As Variant,
'    ByRef vntRslCmtName1 As Variant,
'    ByRef vntRslCmtCd2 As Variant,
'    ByRef vntRslCmtName2 As Variant,
'    ByRef vntBefResult As Variant,
'    ByRef vntBefShortStc As Variant,
'    Optional ByRef vntStdFlg As Variant,
'    Optional ByRef vntDefResult As Variant, Optional ByRef vntDefShortStc As Variant,
'    Optional ByRef vntDefRslCmtCd As Variant, Optional ByRef vntDefRslCmtName As Variant
') As Long
Public Function SelectRslList( _
    ByVal vntMode As Variant, _
    ByVal vntRsvNo As Variant, _
    ByVal vntCode As Variant, _
    ByRef vntUpdItemCount As Variant, _
    ByRef vntSeq As Variant, _
    ByRef vntConsultFlg As Variant, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntItemName As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntResultType As Variant, _
    ByRef vntItemType As Variant, _
    ByRef vntStcItemCd As Variant, _
    ByRef vntShortStc As Variant, _
    ByRef vntRslCmtCd1 As Variant, _
    ByRef vntRslCmtName1 As Variant, _
    ByRef vntRslCmtCd2 As Variant, _
    ByRef vntRslCmtName2 As Variant, _
    ByRef vntBefResult As Variant, ByRef vntBefShortStc As Variant, _
    Optional ByRef vntStdFlg As Variant, _
    Optional ByRef vntDefResult As Variant, Optional ByRef vntDefShortStc As Variant, _
    Optional ByRef vntDefRslCmtCd As Variant, Optional ByRef vntDefRslCmtName As Variant, _
    Optional ByRef vntLastRsvNo As Variant _
) As Long
'## 2003.03.03 Mod End
'## 2003.01.04 Mod End

'## 2003.01.04 Add 14Lines By T.Takagi@FSIT 東急対応
    Dim vntArrStdFlg        As Variant  '基準値フラグ
    Dim vntArrDefResult     As Variant  '省略時検査結果
    Dim vntArrDefShortStc   As Variant  '省略時文章略称
    Dim vntArrDefRslCmtCd   As Variant  '省略時結果コメントコード
    Dim vntArrDefRslCmtName As Variant  '省略時結果コメント名称
    
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
    Dim vntArrLastRsvNo     As Variant  '前回予約番号
'## 2003.03.03 Add End
    
    Dim Ret                 As Long     '関数戻り値
    
    '初期処理
    If Not IsMissing(vntStdFlg) Then vntStdFlg = Empty
    If Not IsMissing(vntDefResult) Then vntDefResult = Empty
    If Not IsMissing(vntDefShortStc) Then vntDefShortStc = Empty
    If Not IsMissing(vntDefRslCmtCd) Then vntDefRslCmtCd = Empty
    If Not IsMissing(vntDefRslCmtName) Then vntDefRslCmtName = Empty
'## 2003.01.04 Add End
    
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
    If Not IsMissing(vntLastRsvNo) Then vntLastRsvNo = Empty
'## 2003.03.03 Add End
    
'## 2003.01.04 Mod 62Lines By T.Takagi@FSIT 東急対応
'    Select Case vntMode
'
'        '判定分類
'        Case RSLMODE_JUDCLASS
'
'            SelectRslList = SelectRslJudClassList(vntRsvNo, vntCode, vntUpdItemCount, vntSeq, vntConsultFlg, vntItemCd, vntSuffix, _
'                                                  vntItemName, vntResult, vntResultType, vntItemType, _
'                                                  vntStcItemCd, vntShortStc, vntRslCmtCd1, vntRslCmtName1, _
'                                                  vntRslCmtCd2, vntRslCmtName2, vntBefResult, vntBefShortStc, vntArrStdFlg)
'
'        '進捗分類
'        Case RSLMODE_PROGRESS
'
'            SelectRslList = SelectRslProgressList(vntRsvNo, vntCode, vntUpdItemCount, vntSeq, vntConsultFlg, vntItemCd, vntSuffix, _
'                                                  vntItemName, vntResult, vntResultType, vntItemType, _
'                                                  vntStcItemCd, vntShortStc, vntRslCmtCd1, vntRslCmtName1, _
'                                                  vntRslCmtCd2, vntRslCmtName2, vntBefResult, vntBefShortStc, vntArrStdFlg)
'
'        '検査グループ
'        Case Empty, ""
'
'            If vntCode = "all" Then
'
'                '全検査項目
'                SelectRslList = SelectRslAllList(vntRsvNo, vntUpdItemCount, vntSeq, vntConsultFlg, vntItemCd, vntSuffix, _
'                                                 vntItemName, vntResult, vntResultType, vntItemType, _
'                                                 vntStcItemCd, vntShortStc, vntRslCmtCd1, vntRslCmtName1, _
'                                                 vntRslCmtCd2, vntRslCmtName2, vntBefResult, vntBefShortStc, vntArrStdFlg)
'            Else
'
'                '検査グループ指定
'                SelectRslList = SelectRslGrpList(vntRsvNo, vntCode, vntUpdItemCount, vntSeq, vntConsultFlg, vntItemCd, vntSuffix, _
'                                                 vntItemName, vntResult, vntResultType, vntItemType, _
'                                                 vntStcItemCd, vntShortStc, vntRslCmtCd1, vntRslCmtName1, _
'                                                 vntRslCmtCd2, vntRslCmtName2, vntBefResult, vntBefShortStc, vntArrStdFlg)
'
'            End If
'
'        Case Else
'
'            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
'            Exit Function
'
'    End Select
    '全項目指定かコード指定かで振り分け
    If vntCode = "all" Then
    
'## 2003.03.03 Mod 10Lines By T.Takagi@FSIT 前回予約番号取得
'        Ret = SelectRslAllList(vntRsvNo, vntUpdItemCount, vntSeq, vntConsultFlg, vntItemCd, vntSuffix, _
'                               vntItemName, vntResult, vntResultType, vntItemType, _
'                               vntStcItemCd, vntShortStc, vntRslCmtCd1, vntRslCmtName1, _
'                               vntRslCmtCd2, vntRslCmtName2, vntBefResult, vntBefShortStc, vntArrStdFlg, _
'                               vntArrDefResult, vntArrDefShortStc, vntArrDefRslCmtCd, vntArrDefRslCmtName)
        Ret = SelectRslAllList(vntRsvNo, vntUpdItemCount, vntSeq, vntConsultFlg, vntItemCd, vntSuffix, _
                               vntItemName, vntResult, vntResultType, vntItemType, _
                               vntStcItemCd, vntShortStc, vntRslCmtCd1, vntRslCmtName1, _
                               vntRslCmtCd2, vntRslCmtName2, vntBefResult, vntBefShortStc, vntArrStdFlg, _
                               vntArrDefResult, vntArrDefShortStc, vntArrDefRslCmtCd, vntArrDefRslCmtName, vntArrLastRsvNo)
'## 2003.03.03 Mod End
                
    Else
        
'## 2003.03.03 Mod 10Lines By T.Takagi@FSIT 前回予約番号取得
'        Ret = SelectRslGrpList(CLng("0" & vntMode), vntRsvNo, vntCode, vntUpdItemCount, vntSeq, vntConsultFlg, vntItemCd, vntSuffix, _
'                               vntItemName, vntResult, vntResultType, vntItemType, _
'                               vntStcItemCd, vntShortStc, vntRslCmtCd1, vntRslCmtName1, _
'                               vntRslCmtCd2, vntRslCmtName2, vntBefResult, vntBefShortStc, vntArrStdFlg, _
'                               vntArrDefResult, vntArrDefShortStc, vntArrDefRslCmtCd, vntArrDefRslCmtName)
        Ret = SelectRslGrpList(CLng("0" & vntMode), vntRsvNo, vntCode, vntUpdItemCount, vntSeq, vntConsultFlg, vntItemCd, vntSuffix, _
                               vntItemName, vntResult, vntResultType, vntItemType, _
                               vntStcItemCd, vntShortStc, vntRslCmtCd1, vntRslCmtName1, _
                               vntRslCmtCd2, vntRslCmtName2, vntBefResult, vntBefShortStc, vntArrStdFlg, _
                               vntArrDefResult, vntArrDefShortStc, vntArrDefRslCmtCd, vntArrDefRslCmtName, vntArrLastRsvNo)
'## 2003.03.03 Mod End
        
    End If
'## 2003.01.04 Mod End
    
    '引数指定時のみ基準値を返す
    If Not IsMissing(vntStdFlg) Then vntStdFlg = vntArrStdFlg
    
'## 2003.01.04 Add 6Lines By T.Takagi@FSIT 東急対応
    If Not IsMissing(vntDefResult) Then vntDefResult = vntArrDefResult
    If Not IsMissing(vntDefShortStc) Then vntDefShortStc = vntArrDefShortStc
    If Not IsMissing(vntDefRslCmtCd) Then vntDefRslCmtCd = vntArrDefRslCmtCd
    If Not IsMissing(vntDefRslCmtName) Then vntDefRslCmtName = vntArrDefRslCmtName

'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
    If Not IsMissing(vntLastRsvNo) Then vntLastRsvNo = vntArrLastRsvNo
'## 2003.03.03 Add End

    SelectRslList = Ret
'## 2003.01.04 Add End
    
End Function

'
' 機能　　 : 指定対象受診者・各種項目の検査結果を取得する
'
' 引数　　 : (In)     lngMode           入力対象モード
' 　　　　   (In)     lngRsvNo          予約番号
' 　　　　   (In)     strCode           コード(グループ、進捗分類、判定分類)
' 　　　　   (Out)    vntUpdItemCount   更新可能項目数
' 　　　　   (Out)    vntSeq            表示行位置
' 　　　　   (Out)    vntConsultFlg     受診項目フラグ
' 　　　　   (Out)    vntItemCd         検査項目コード
' 　　　　   (Out)    vntSuffix         サフィックス
' 　　　　   (Out)    vntItemName       検査項目名称
' 　　　　   (Out)    vntResult         検査結果
' 　　　　   (Out)    vntResultType     結果タイプ
' 　　　　   (Out)    vntItemType       項目タイプ
' 　　　　   (Out)    vntStcItemCd      文章参照用項目コード
' 　　　　   (Out)    vntShortStc       文章略称
' 　　　　   (Out)    vntRslCmtCd1      結果コメントコード１
' 　　　　   (Out)    vntRslCmtName1    結果コメント名称１
' 　　　　   (Out)    vntRslCmtCd2      結果コメントコード２
' 　　　　   (Out)    vntRslCmtName2    結果コメント名称２
' 　　　　   (Out)    vntBefResult      前回値・検査結果
' 　　　　   (Out)    vntBefShortStc    前回値・文章略称
' 　　　　   (Out)    vntStdFlg         基準値フラグ
' 　　　　   (Out)    vntDefResult      省略時検査結果
' 　　　　   (Out)    vntDefShortStc    省略時文章略称
' 　　　　   (Out)    vntDefRslCmtCd    省略時結果コメントコード
' 　　　　   (Out)    vntDefRslCmtName  省略時結果コメント名称
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 問診項目は検査結果に存在しなくても対象の全項目を取得する
'
'## 2003.01.05 Mod 46Lines By T.Takagi@FSIT 東急対応
'Private Function SelectRslGrpList(ByVal vntRsvNo As Variant,
'                                  ByVal vntGrpCd As Variant,
'                                  ByRef vntUpdItemCount As Variant,
'                                  ByRef vntSeq As Variant,
'                                  ByRef vntConsultFlg As Variant,
'                                  ByRef vntItemCd As Variant,
'                                  ByRef vntSuffix As Variant,
'                                  ByRef vntItemName As Variant,
'                                  ByRef vntResult As Variant,
'                                  ByRef vntResultType As Variant,
'                                  ByRef vntItemType As Variant,
'                                  ByRef vntStcItemCd As Variant,
'                                  ByRef vntShortStc As Variant,
'                                  ByRef vntRslCmtCd1 As Variant,
'                                  ByRef vntRslCmtName1 As Variant,
'                                  ByRef vntRslCmtCd2 As Variant,
'                                  ByRef vntRslCmtName2 As Variant,
'                                  ByRef vntBefResult As Variant,
'                                  ByRef vntBefShortStc As Variant,
'                                  Optional ByRef vntStdFlg As Variant
'                                 ) As Long
'## 2003.03.03 Mod 50Lines By T.Takagi@FSIT 前回予約番号取得
'Private Function SelectRslGrpList(
'    ByVal lngMode As Long,
'    ByVal lngRsvNo As Long,
'    ByVal strCode As String,
'    ByRef vntUpdItemCount As Variant,
'    ByRef vntSeq As Variant,
'    ByRef vntConsultFlg As Variant,
'    ByRef vntItemCd As Variant,
'    ByRef vntSuffix As Variant,
'    ByRef vntItemName As Variant,
'    ByRef vntResult As Variant,
'    ByRef vntResultType As Variant,
'    ByRef vntItemType As Variant,
'    ByRef vntStcItemCd As Variant,
'    ByRef vntShortStc As Variant,
'    ByRef vntRslCmtCd1 As Variant,
'    ByRef vntRslCmtName1 As Variant,
'    ByRef vntRslCmtCd2 As Variant,
'    ByRef vntRslCmtName2 As Variant,
'    ByRef vntBefResult As Variant,
'    ByRef vntBefShortStc As Variant,
'    Optional ByRef vntStdFlg As Variant,
'    Optional ByRef vntDefResult As Variant, Optional ByRef vntDefShortStc As Variant,
'    Optional ByRef vntDefRslCmtCd As Variant, Optional ByRef vntDefRslCmtName As Variant
') As Long
Private Function SelectRslGrpList( _
    ByVal lngMode As Long, _
    ByVal lngRsvNo As Long, _
    ByVal strCode As String, _
    ByRef vntUpdItemCount As Variant, _
    ByRef vntSeq As Variant, _
    ByRef vntConsultFlg As Variant, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntItemName As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntResultType As Variant, _
    ByRef vntItemType As Variant, _
    ByRef vntStcItemCd As Variant, _
    ByRef vntShortStc As Variant, _
    ByRef vntRslCmtCd1 As Variant, _
    ByRef vntRslCmtName1 As Variant, _
    ByRef vntRslCmtCd2 As Variant, _
    ByRef vntRslCmtName2 As Variant, _
    ByRef vntBefResult As Variant, ByRef vntBefShortStc As Variant, _
    Optional ByRef vntStdFlg As Variant, _
    Optional ByRef vntDefResult As Variant, Optional ByRef vntDefShortStc As Variant, _
    Optional ByRef vntDefRslCmtCd As Variant, Optional ByRef vntDefRslCmtName As Variant, _
    Optional ByRef vntLastRsvNo As Variant _
) As Long
'## 2003.03.03 Mod End
'## 2003.01.05 Mod End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSeq              As OraField         '表示行位置
    Dim objConsultFlg       As OraField         '受診項目フラグ(1:受診 2:非受診)
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objResult           As OraField         '検査結果
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objShortStc         As OraField         '略文章
    Dim objRslCmtCd1        As OraField         '結果コメント１
    Dim objRslCmtName1      As OraField         '結果コメント名１
    Dim objRslCmtCd2        As OraField         '結果コメント２
    Dim objRslCmtName2      As OraField         '結果コメント名２
    Dim objBefResult        As OraField         '前回値・検査結果
    Dim objBefShortStc      As OraField         '前回値・略文章
    Dim objStdFlg           As OraField         '基準値フラグ
'## 2003.01.05 Add 4Lines By T.Takagi@FSIT 東急対応
    Dim objDefResult        As OraField         '省略時検査結果
    Dim objDefShortStc      As OraField         '省略時文章略称
    Dim objDefRslCmtCd      As OraField         '省略時結果コメントコード
    Dim objDefRslCmtName    As OraField         '省略時結果コメント名称
'## 2003.01.05 Add End
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
    Dim objLastRsvNo        As OraField         '前回予約番号
'## 2003.03.03 Add End

    Dim objCommon           As Common           '共通クラス
    
    Dim vntArrSeq()         As Variant          '表示行位置の配列
    Dim vntArrConsultFlg()  As Variant          '受診項目フラグの配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コードの配列
    Dim vntArrShortStc()    As Variant          '略文章の配列
    Dim vntArrRslCmtCd1()   As Variant          '結果コメント１の配列
    Dim vntArrRslCmtName1() As Variant          '結果コメント名１の配列
    Dim vntArrRslCmtCd2()   As Variant          '結果コメント２の配列
    Dim vntArrRslCmtName2() As Variant          '結果コメント名２の配列
    Dim vntArrBefResult()   As Variant          '前回値・検査結果の配列
    Dim vntArrBefShortStc() As Variant          '前回値・略文章の配列
    Dim vntArrStdFlg()      As Variant          '基準値フラグの配列
'## 2003.01.05 Add 4Lines By T.Takagi@FSIT 東急対応
    Dim vntArrDefResult()       As Variant      '省略時検査結果の配列
    Dim vntArrDefShortStc()     As Variant      '省略時文章略称の配列
    Dim vntArrDefRslCmtCd()     As Variant      '省略時結果コメントコードの配列
    Dim vntArrDefRslCmtName()   As Variant      '省略時結果コメント名称の配列
'## 2003.01.05 Add End
    
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
    Dim vntArrLastRsvNo     As Variant          '前回予約番号の配列
'## 2003.03.03 Add End
    
    Dim lngCount            As Long             'レコード数
    Dim lngUpdItemCount     As Long             '更新可能レコード数
    Dim lngCourseFlg        As Long             'コース選択
    Dim lngSecondFlg        As Long             '２次検査コース選択
    
'## 2003.01.05 Del 1Line By T.Takagi@FSIT 東急対応
'    Dim blnAllSeqZero       As Boolean          'SEQ設定フラグ
'## 2003.01.05 Del End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期設定
    lngUpdItemCount = 0

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
    '前回値表示条件取得
    lngCourseFlg = objCommon.SelectRslCourseFlg
    lngSecondFlg = objCommon.SelectRslSecondFlg
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
'## 2003.01.05 Mod 327Lines By T.Takagi@FSIT 東急対応
'    objOraParam.Add "RSVNO", Trim(vntRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "GRPCD", Trim(vntGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "GRPDIV", CStr(GRPDIV_I), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "RSLQUE_R", CStr(RSLQUE_R), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "RSLQUE_Q", CStr(RSLQUE_Q), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "CONSULT_ITEM_T", CStr(CONSULT_ITEM_T), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "CONSULT_ITEM_F", CStr(CONSULT_ITEM_F), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "CANCELFLG", Trim(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
'    If lngSecondFlg = RSLSECOND_NONE Then
'        objOraParam.Add "SECONDFLG", Trim(COURSE_FIRST), ORAPARM_INPUT, ORATYPE_NUMBER
'    End If
'
'    '検索条件を満たす検査結果情報のレコードを取得
'    strStmt = "SELECT CURRSL.SEQ, CURRSL.CONSULTFLG, CURRSL.ITEMCD, CURRSL.SUFFIX, CURRSL.ITEMNAME, CURRSL.RESULT,  " & vbLf & _
'              "       CURRSL.RESULTTYPE, CURRSL.ITEMTYPE, CURRSL.STCITEMCD, S.SHORTSTC, CURRSL.RSLCMTCD1,           " & vbLf & _
'              "       CURRSL.RSLCMTNAME1, CURRSL.RSLCMTCD2, CURRSL.RSLCMTNAME2, BEFRSL.RESULT BEFRESULT,            " & vbLf & _
'              "       CURRSL.STDFLG,                                                                                " & vbLf & _
'              "       BEFRSL.SHORTSTC BEFSHORTSTC                                                                   " & vbLf & _
'              "  FROM ( SELECT QI.SEQ, QI.CONSULTFLG, QI.ITEMCD, QI.SUFFIX, QI.ITEMNAME, QR.RESULT,                 " & vbLf & _
'              "                QI.RESULTTYPE, QI.ITEMTYPE, QI.STCITEMCD, QR.RSLCMTCD1,                              " & vbLf & _
'              "                RC1.RSLCMTNAME RSLCMTNAME1, QR.RSLCMTCD2, RC2.RSLCMTNAME RSLCMTNAME2,                " & vbLf & _
'              "                STDVALUE_C.STDFLG                                                                    "
'    '検査グループ内の全検査項目で、対象受診者の検査項目を取得する
'    strStmt = strStmt & vbLf & _
'              "           FROM ( SELECT SEQ, CONSULTFLG, ITEMCD, SUFFIX, ITEMNAME, RESULTTYPE, ITEMTYPE,            " & vbLf & _
'              "                         STCITEMCD                                                                   "
'    '対象受診者の受診項目
'    strStmt = strStmt & vbLf & _
'              "                    FROM ( SELECT :CONSULT_ITEM_T CONSULTFLG, GI.SEQ, GI.ITEMCD, GI.SUFFIX,          " & vbLf & _
'              "                                  IC.ITEMNAME, IC.RESULTTYPE, IC.ITEMTYPE, IC.STCITEMCD              " & vbLf & _
'              "                             FROM GRP_P GP, GRP_I GI, ITEM_P IP, ITEM_C IC, RSL R                    " & vbLf & _
'              "                            WHERE GP.GRPCD  = :GRPCD                                                 " & vbLf & _
'              "                              AND GP.GRPDIV = :GRPDIV                                                " & vbLf & _
'              "                              AND IP.RSLQUE = :RSLQUE_R                                              " & vbLf & _
'              "                              AND R.RSVNO   = :RSVNO                                                 " & vbLf & _
'              "                              AND GP.GRPCD  = GI.GRPCD                                               " & vbLf & _
'              "                              AND GI.ITEMCD = IP.ITEMCD                                              " & vbLf & _
'              "                              AND GI.ITEMCD = R.ITEMCD                                               " & vbLf & _
'              "                              AND GI.SUFFIX = R.SUFFIX                                               " & vbLf & _
'              "                              AND GI.ITEMCD = IC.ITEMCD                                              " & vbLf & _
'              "                              AND GI.SUFFIX = IC.SUFFIX                                              " & vbLf & _
'              "                           UNION                                                                     "
'    '対象受診者の非受診項目
'    strStmt = strStmt & vbLf & _
'              "                           SELECT :CONSULT_ITEM_F CONSULTFLG, GI.SEQ, GI.ITEMCD, GI.SUFFIX,          " & vbLf & _
'              "                                  IC.ITEMNAME, IC.RESULTTYPE, IC.ITEMTYPE, IC.STCITEMCD              " & vbLf & _
'              "                             FROM GRP_P GP, GRP_I GI, ITEM_P IP, ITEM_C IC                           " & vbLf & _
'              "                            WHERE GP.GRPCD  = :GRPCD                                                 " & vbLf & _
'              "                              AND GP.GRPDIV = :GRPDIV                                                " & vbLf & _
'              "                              AND IP.RSLQUE = :RSLQUE_R                                              " & vbLf & _
'              "                              AND GP.GRPCD  = GI.GRPCD                                               " & vbLf & _
'              "                              AND GI.ITEMCD = IP.ITEMCD                                              " & vbLf & _
'              "                              AND GI.ITEMCD = IC.ITEMCD                                              " & vbLf & _
'              "                              AND GI.SUFFIX = IC.SUFFIX                                              " & vbLf & _
'              "                              AND NOT EXISTS ( SELECT R.ITEMCD                                       " & vbLf & _
'              "                                                 FROM RSL R                                          " & vbLf & _
'              "                                                WHERE R.RSVNO  = :RSVNO                              " & vbLf & _
'              "                                                  AND R.ITEMCD = GI.ITEMCD                           " & vbLf & _
'              "                                                  AND R.SUFFIX = GI.SUFFIX                           " & vbLf & _
'              "                                             )                                                       " & vbLf & _
'              "                         )                                                                           "
'    '検査グループ内の全問診項目を取得する
'    strStmt = strStmt & vbLf & _
'              "                  UNION                                                                              " & vbLf & _
'              "                  SELECT GI.SEQ, :CONSULT_ITEM_T CONSULTFLG, GI.ITEMCD, GI.SUFFIX, IC.ITEMNAME,      " & vbLf & _
'              "                         IC.RESULTTYPE, IC.ITEMTYPE, IC.STCITEMCD                                    " & vbLf & _
'              "                    FROM GRP_P GP, GRP_I GI, ITEM_P IP, ITEM_C IC                                    " & vbLf & _
'              "                   WHERE GP.GRPCD  = :GRPCD                                                          " & vbLf & _
'              "                     AND GP.GRPDIV = :GRPDIV                                                         " & vbLf & _
'              "                     AND IP.RSLQUE = :RSLQUE_Q                                                       " & vbLf & _
'              "                     AND GP.GRPCD  = GI.GRPCD                                                        " & vbLf & _
'              "                     AND GI.ITEMCD = IP.ITEMCD                                                       " & vbLf & _
'              "                     AND GI.ITEMCD = IC.ITEMCD                                                       " & vbLf & _
'              "                     AND GI.SUFFIX = IC.SUFFIX                                                       " & vbLf & _
'              "                ) QI,                                                                                "
'    '対象受診者の全検査項目を取得する
'    strStmt = strStmt & vbLf & _
'              "                ( SELECT R.ITEMCD, R.SUFFIX, R.RESULT, R.RSLCMTCD1, R.RSLCMTCD2, R.STDVALUECD        " & vbLf & _
'              "                    FROM RSL R                                                                       " & vbLf & _
'              "                   WHERE RSVNO = :RSVNO                                                              "
'    strStmt = strStmt & vbLf & _
'              "                ) QR,                                                                                " & vbLf & _
'              "                RSLCMT RC1, RSLCMT RC2, STDVALUE_C                                                   " & vbLf & _
'              "          WHERE QI.ITEMCD     = QR.ITEMCD(+)                                                         " & vbLf & _
'              "            AND QI.SUFFIX     = QR.SUFFIX(+)                                                         " & vbLf & _
'              "            AND QR.RSLCMTCD1  = RC1.RSLCMTCD(+)                                                      " & vbLf & _
'              "            AND QR.RSLCMTCD2  = RC2.RSLCMTCD(+)                                                      " & vbLf & _
'              "            AND QR.STDVALUECD = STDVALUE_C.STDVALUECD(+)                                             " & vbLf & _
'              "       ) CURRSL, SENTENCE S,                                                                         "
'    '前回値
'    strStmt = strStmt & vbLf & _
'              "       ( SELECT B.ITEMCD, B.SUFFIX, B.RESULT, B.RESULTTYPE, S.SHORTSTC                       " & vbLf & _
'              "           FROM ( SELECT BC.RSVNO, R.ITEMCD, R.SUFFIX, R.RESULT, IC.RESULTTYPE, IC.ITEMTYPE, " & vbLf & _
'              "                         IC.STCITEMCD                                                        " & vbLf & _
'              "                    FROM ( SELECT RSVNO                                                      " & vbLf & _
'              "                             FROM ( SELECT CN.CSLDATE, CN.RSVNO                              " & vbLf & _
'              "                                      FROM CONSULT CN, RECEIPT RC, COURSE_P CP,              " & vbLf & _
'              "                                           ( SELECT CN.PERID, CN.CSLDATE, CN.CSCD            " & vbLf & _
'              "                                               FROM CONSULT CN                               " & vbLf & _
'              "                                              WHERE CN.RSVNO     = :RSVNO                    " & vbLf & _
'              "                                                AND CN.CANCELFLG = :CANCELFLG                " & vbLf & _
'              "                                           ) CUR                                             " & vbLf & _
'              "                                     WHERE CN.PERID     = CUR.PERID                          " & vbLf & _
'              "                                       AND CN.CSLDATE   < CUR.CSLDATE                        " & vbLf & _
'              "                                       AND CN.CSCD      = CP.CSCD                            "
'    '同一コースのみ対象とする
'    If lngCourseFlg = RSLCOURSE_SAME Then
'        strStmt = strStmt & vbLf & _
'              "                                       AND CN.CSCD      = CUR.CSCD                           "
'    End If
'    '２次検査コースを対象としない
'    If lngSecondFlg = RSLSECOND_NONE Then
'        strStmt = strStmt & vbLf & _
'              "                                       AND CP.SECONDFLG = :SECONDFLG                         "
'    End If
'    strStmt = strStmt & vbLf & _
'              "                                       AND CN.RSVNO     = RC.RSVNO                           " & vbLf & _
'              "                                       AND CN.CSLDATE   = RC.CSLDATE                         " & vbLf & _
'              "                                     ORDER BY CN.CSLDATE DESC, CN.RSVNO                      " & vbLf & _
'              "                                  )                                                          " & vbLf & _
'              "                            WHERE ROWNUM = 1                                                 " & vbLf & _
'              "                         ) BC, RSL R, ITEM_C IC                                              "
'    strStmt = strStmt & vbLf & _
'              "                   WHERE R.RSVNO  = BC.RSVNO                                                 " & vbLf & _
'              "                     AND R.ITEMCD = IC.ITEMCD                                                " & vbLf & _
'              "                     AND R.SUFFIX = IC.SUFFIX                                                " & vbLf & _
'              "                ) B, SENTENCE S                                                              " & vbLf & _
'              "          WHERE B.STCITEMCD = S.ITEMCD(+)                                                    " & vbLf & _
'              "            AND B.ITEMTYPE  = S.ITEMTYPE(+)                                                  " & vbLf & _
'              "            AND B.RESULT    = S.STCCD(+)                                                     " & vbLf & _
'              "       ) BEFRSL                                                                              " & vbLf & _
'              " WHERE CURRSL.STCITEMCD = S.ITEMCD(+)                                                        " & vbLf & _
'              "   AND CURRSL.ITEMTYPE  = S.ITEMTYPE(+)                                                      " & vbLf & _
'              "   AND CURRSL.RESULT    = S.STCCD(+)                                                         " & vbLf & _
'              "   AND CURRSL.ITEMCD    = BEFRSL.ITEMCD(+)                                                   " & vbLf & _
'              "   AND CURRSL.SUFFIX    = BEFRSL.SUFFIX(+)                                                   " & vbLf & _
'              " ORDER BY CURRSL.SEQ                                                                         "
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CODE", strCode, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号、各種コード内検査項目の検査結果情報を取得
'## 2003.03.03 Mod 35Lines By T.Takagi@FSIT 前回予約番号取得
'    strStmt = "SELECT FINALRSL.SEQ,         FINALRSL.CONSULTFLG,                   " & vbLf & _
'              "       FINALRSL.ITEMCD,      FINALRSL.SUFFIX, FINALRSL.ITEMNAME,    " & vbLf & _
'              "       FINALRSL.RESULT,      CURRENTSENTENCE.SHORTSTC,              " & vbLf & _
'              "       FINALRSL.RSLCMTCD1,   RSLCMT1.RSLCMTNAME RSLCMTNAME1,        " & vbLf & _
'              "       FINALRSL.RSLCMTCD2,   RSLCMT2.RSLCMTNAME RSLCMTNAME2,        " & vbLf & _
'              "       FINALRSL.BEFRESULT,   BEFSENTENCE.SHORTSTC BEFSHORTSTC,      " & vbLf & _
'              "       FINALRSL.RESULTTYPE,  FINALRSL.ITEMTYPE, FINALRSL.STCITEMCD, " & vbLf & _
'              "       STDVALUE_C.STDFLG,                                           " & vbLf & _
'              "       FINALRSL.DEFRESULT,   DEFSENTENCE.SHORTSTC DEFSHORTSTC,      " & vbLf & _
'              "       FINALRSL.DEFRSLCMTCD, DEFRSLCMT.RSLCMTNAME DEFRSLCMTNAME     " & vbLf & _
'              "  FROM STDVALUE_C,                                                  " & vbLf & _
'              "       RSLCMT RSLCMT1,                                              " & vbLf & _
'              "       RSLCMT RSLCMT2,                                              " & vbLf & _
'              "       RSLCMT DEFRSLCMT,                                            " & vbLf & _
'              "       SENTENCE BEFSENTENCE,                                        " & vbLf & _
'              "       SENTENCE CURRENTSENTENCE,                                    " & vbLf & _
'              "       SENTENCE DEFSENTENCE,                                        "
    strStmt = "SELECT FINALRSL.SEQ,         FINALRSL.CONSULTFLG,                   " & vbLf & _
              "       FINALRSL.ITEMCD,      FINALRSL.SUFFIX, FINALRSL.ITEMNAME,    " & vbLf & _
              "       FINALRSL.RESULT,      CURRENTSENTENCE.SHORTSTC,              " & vbLf & _
              "       FINALRSL.RSLCMTCD1,   RSLCMT1.RSLCMTNAME RSLCMTNAME1,        " & vbLf & _
              "       FINALRSL.RSLCMTCD2,   RSLCMT2.RSLCMTNAME RSLCMTNAME2,        " & vbLf & _
              "       FINALRSL.BEFRESULT,   BEFSENTENCE.SHORTSTC BEFSHORTSTC,      " & vbLf & _
              "       FINALRSL.RESULTTYPE,  FINALRSL.ITEMTYPE, FINALRSL.STCITEMCD, " & vbLf & _
              "       STDVALUE_C.STDFLG,                                           " & vbLf & _
              "       FINALRSL.DEFRESULT,   DEFSENTENCE.SHORTSTC DEFSHORTSTC,      " & vbLf & _
              "       FINALRSL.DEFRSLCMTCD, DEFRSLCMT.RSLCMTNAME DEFRSLCMTNAME,    " & vbLf & _
              "       FINALRSL.LASTRSVNO                                           " & vbLf & _
              "  FROM STDVALUE_C,                                                  " & vbLf & _
              "       RSLCMT RSLCMT1,                                              " & vbLf & _
              "       RSLCMT RSLCMT2,                                              " & vbLf & _
              "       RSLCMT DEFRSLCMT,                                            " & vbLf & _
              "       SENTENCE BEFSENTENCE,                                        " & vbLf & _
              "       SENTENCE CURRENTSENTENCE,                                    " & vbLf & _
              "       SENTENCE DEFSENTENCE,                                        "
'## 2003.03.03 Mod End

    '基本表その２に前回検査結果、検査項目履歴情報を結合
'## 2003.03.03 Mod 16Lines By T.Takagi@FSIT 前回予約番号取得
'    strStmt = strStmt & vbLf & _
'              "       ( SELECT BASEDRSL2.RESULT,     BASEDRSL2.RSLCMTCD1, BASEDRSL2.RSLCMTCD2,  " & vbLf & _
'              "                BASEDRSL2.STDVALUECD, BASEDRSL2.SEQ,       BASEDRSL2.ITEMCD,     " & vbLf & _
'              "                BASEDRSL2.SUFFIX,     BASEDRSL2.ITEMNAME,  BASEDRSL2.RESULTTYPE, " & vbLf & _
'              "                BASEDRSL2.ITEMTYPE,   BASEDRSL2.STCITEMCD, BASEDRSL2.CONSULTFLG, " & vbLf & _
'              "                RSL.RESULT BEFRESULT,                                            " & vbLf & _
'              "                ITEM_H.DEFRESULT, ITEM_H.DEFRSLCMTCD                             " & vbLf & _
'              "           FROM ITEM_H, CONSULT, RSL,                                            "
    strStmt = strStmt & vbLf & _
              "       ( SELECT BASEDRSL2.RESULT,     BASEDRSL2.RSLCMTCD1, BASEDRSL2.RSLCMTCD2,  " & vbLf & _
              "                BASEDRSL2.STDVALUECD, BASEDRSL2.SEQ,       BASEDRSL2.ITEMCD,     " & vbLf & _
              "                BASEDRSL2.SUFFIX,     BASEDRSL2.ITEMNAME,  BASEDRSL2.RESULTTYPE, " & vbLf & _
              "                BASEDRSL2.ITEMTYPE,   BASEDRSL2.STCITEMCD, BASEDRSL2.CONSULTFLG, " & vbLf & _
              "                BASEDRSL2.LASTRSVNO,  RSL.RESULT BEFRESULT,                      " & vbLf & _
              "                ITEM_H.DEFRESULT, ITEM_H.DEFRSLCMTCD                             " & vbLf & _
              "           FROM ITEM_H, CONSULT, RSL,                                            "
'## 2003.03.03 Mod End

    '基本表に項目情報、そして前回予約番号を追加した表を基本表その２とする
    strStmt = strStmt & vbLf & _
              "                ( SELECT NVL(BASEDRSL.RSVNO, :RSVNO) RSVNO,                         " & vbLf & _
              "                         BASEDRSL.RESULT,    BASEDRSL.RSLCMTCD1,                    " & vbLf & _
              "                         BASEDRSL.RSLCMTCD2, BASEDRSL.STDVALUECD,                   " & vbLf & _
              "                         GRPITEM.SEQ,        GRPITEM.ITEMCD,      GRPITEM.SUFFIX,   " & vbLf & _
              "                         GRPITEM.ITEMNAME,   GRPITEM.RESULTTYPE,  GRPITEM.ITEMTYPE, " & vbLf & _
              "                         GRPITEM.STCITEMCD,                                         "

    '今回の受診項目かを判断するためのDECODE句(問診項目なら無条件受診)
    strStmt = strStmt & vbLf & _
              "                         DECODE(                             " & vbLf & _
              "                             GRPITEM.RSLQUE,                 " & vbLf & _
              "                             0, NVL2(BASEDRSL.ITEMCD, 1, 2), " & vbLf & _
              "                             1                               " & vbLf & _
              "                         ) CONSULTFLG,                         "

    '個人ＩＤ、受診日降順で１件だけ前回受診情報を取得
    strStmt = strStmt & vbLf & _
              "                         ( SELECT /*+ INDEX_DESC(CONSULT CONSULT_INDEX4) */ " & vbLf & _
              "                                  CONSULT.RSVNO                             " & vbLf & _
              "                             FROM COURSE_P, RECEIPT, CONSULT,               "

    'もともとの受診情報
    strStmt = strStmt & vbLf & _
              "                                  ( SELECT CSLDATE, PERID, CSCD " & vbLf & _
              "                                      FROM CONSULT              " & vbLf & _
              "                                     WHERE RSVNO = :RSVNO       " & vbLf & _
              "                                  ) CURRENTCONSULT              "

    '過去歴検索のための条件節
    strStmt = strStmt & vbLf & _
              "                            WHERE CONSULT.PERID      = CURRENTCONSULT.PERID   " & vbLf & _
              "                              AND CONSULT.CSLDATE    < CURRENTCONSULT.CSLDATE " & vbLf & _
              "                              AND CONSULT.RSVNO      = RECEIPT.RSVNO          " & vbLf & _
              "                              AND CONSULT.CSLDATE    = RECEIPT.CSLDATE        " & vbLf & _
              "                              AND CONSULT.CSCD       = COURSE_P.CSCD          "

    '今回コースと同一コースのみ対象とする条件
    If lngCourseFlg = RSLCOURSE_SAME Then
        strStmt = strStmt & vbLf & _
              "                              AND CONSULT.CSCD       = CURRENTCONSULT.CSCD "
    End If
    
    '２次検査コースを対象としない条件
    If lngSecondFlg = RSLSECOND_NONE Then
        strStmt = strStmt & vbLf & _
              "                              AND COURSE_P.SECONDFLG = 0 "
    End If

'## 2003.03.03 Add 31Lines By T.Takagi@FSIT 過去結果は依頼の有無を見つつさかのぼる
    Select Case lngMode
    
        Case RSLMODE_JUDCLASS   '判定分類の場合

            '指定判定分類内依頼項目の依頼がある(レコードが存在する)受診情報のみを対象とする
            strStmt = strStmt & vbLf & "     AND EXISTS ( SELECT RSL.RSVNO                           " & vbLf & _
                                       "                    FROM ITEM_JUD, RSL                       " & vbLf & _
                                       "                   WHERE RSL.RSVNO           = CONSULT.RSVNO " & vbLf & _
                                       "                     AND ITEM_JUD.JUDCLASSCD = :CODE         " & vbLf & _
                                       "                     AND ITEM_JUD.ITEMCD     = RSL.ITEMCD )  "

        Case RSLMODE_PROGRESS   '進捗分類の場合
    
            '指定進捗分類内依頼項目の依頼がある(レコードが存在する)受診情報のみを対象とする
            strStmt = strStmt & vbLf & "     AND EXISTS ( SELECT RSL.RSVNO                         " & vbLf & _
                                       "                    FROM ITEM_P, RSL                       " & vbLf & _
                                       "                   WHERE RSL.RSVNO         = CONSULT.RSVNO " & vbLf & _
                                       "                     AND ITEM_P.PROGRESSCD = :CODE         " & vbLf & _
                                       "                     AND ITEM_P.ITEMCD     = RSL.ITEMCD )  "
    
        Case Else               'それ以外は検査項目グループ
        
            '指定グループ内検査項目の依頼がある(レコードが存在する)受診情報のみを対象とする
            strStmt = strStmt & vbLf & "     AND EXISTS ( SELECT RSL.RSVNO                   " & vbLf & _
                                       "                    FROM GRP_I, RSL                  " & vbLf & _
                                       "                   WHERE RSL.RSVNO   = CONSULT.RSVNO " & vbLf & _
                                       "                     AND GRP_I.GRPCD = :CODE         " & vbLf & _
                                       "                     AND GRP_I.ITEMCD = RSL.ITEMCD   " & vbLf & _
                                       "                     AND GRP_I.SUFFIX = RSL.SUFFIX ) "

    End Select
'## 2003.03.03 Add End

    strStmt = strStmt & vbLf & _
              "                              AND ROWNUM = 1 " & vbLf & _
              "                         ) LASTRSVNO         "

    '今回の全検査結果を基本表とする
    strStmt = strStmt & vbLf & _
              "                    FROM ( SELECT RSL.RSVNO,     RSL.ITEMCD,    RSL.SUFFIX,    RSL.RESULT, " & vbLf & _
              "                                  RSL.RSLCMTCD1, RSL.RSLCMTCD2, RSL.STDVALUECD             " & vbLf & _
              "                             FROM RSL                                                      " & vbLf & _
              "                            WHERE RSVNO = :RSVNO                                           " & vbLf & _
              "                         ) BASEDRSL,                                                       "

    '項目情報を作成する
    Select Case lngMode
    
        Case RSLMODE_JUDCLASS   '判定分類の場合

            strStmt = strStmt & vbLf & _
              "                         ( SELECT ROWNUM SEQ,         BASEDITEM.ITEMCD,        " & vbLf & _
              "                                  BASEDITEM.SUFFIX,   BASEDITEM.RSLQUE,        " & vbLf & _
              "                                  BASEDITEM.ITEMNAME, BASEDITEM.RESULTTYPE,    " & vbLf & _
              "                                  BASEDITEM.ITEMTYPE, BASEDITEM.STCITEMCD      " & vbLf & _
              "                             FROM ( SELECT ITEM_JUD.ITEMCD, ITEM_C.SUFFIX,     " & vbLf & _
              "                                           ITEM_P.RSLQUE,                      " & vbLf & _
              "                                           ITEM_C.ITEMNAME, ITEM_C.RESULTTYPE, " & vbLf & _
              "                                           ITEM_C.ITEMTYPE, ITEM_C.STCITEMCD   " & vbLf & _
              "                                      FROM ITEM_C, ITEM_P, ITEM_JUD            " & vbLf & _
              "                                     WHERE ITEM_JUD.JUDCLASSCD = :CODE         " & vbLf & _
              "                                       AND ITEM_JUD.ITEMCD     = ITEM_P.ITEMCD " & vbLf & _
              "                                       AND ITEM_JUD.ITEMCD     = ITEM_C.ITEMCD " & vbLf & _
              "                                     ORDER BY ITEM_JUD.ITEMCD, ITEM_C.SUFFIX   " & vbLf & _
              "                                   ) BASEDITEM                                 " & vbLf & _
              "                         ) GRPITEM                                             "

        Case RSLMODE_PROGRESS   '進捗分類の場合
    
            strStmt = strStmt & vbLf & _
              "                         ( SELECT ROWNUM SEQ,         BASEDITEM.ITEMCD,        " & vbLf & _
              "                                  BASEDITEM.SUFFIX,   BASEDITEM.RSLQUE,        " & vbLf & _
              "                                  BASEDITEM.ITEMNAME, BASEDITEM.RESULTTYPE,    " & vbLf & _
              "                                  BASEDITEM.ITEMTYPE, BASEDITEM.STCITEMCD      " & vbLf & _
              "                             FROM ( SELECT ITEM_P.ITEMCD, ITEM_C.SUFFIX,       " & vbLf & _
              "                                           ITEM_P.RSLQUE,                      " & vbLf & _
              "                                           ITEM_C.ITEMNAME, ITEM_C.RESULTTYPE, " & vbLf & _
              "                                           ITEM_C.ITEMTYPE, ITEM_C.STCITEMCD   " & vbLf & _
              "                                      FROM ITEM_C, ITEM_P                      " & vbLf & _
              "                                     WHERE ITEM_P.PROGRESSCD = :CODE           " & vbLf & _
              "                                       AND ITEM_P.ITEMCD     = ITEM_C.ITEMCD   " & vbLf & _
              "                                     ORDER BY ITEM_P.ITEMCD, ITEM_C.SUFFIX     " & vbLf & _
              "                                   ) BASEDITEM                                 " & vbLf & _
              "                         ) GRPITEM                                             "
    
        Case Else               'それ以外は検査項目グループ
        
            strStmt = strStmt & vbLf & _
              "                         ( SELECT GRP_I.SEQ,       GRP_I.ITEMCD,      " & vbLf & _
              "                                  GRP_I.SUFFIX,    ITEM_P.RSLQUE,     " & vbLf & _
              "                                  ITEM_C.ITEMNAME, ITEM_C.RESULTTYPE, " & vbLf & _
              "                                  ITEM_C.ITEMTYPE, ITEM_C.STCITEMCD   " & vbLf & _
              "                             FROM ITEM_C, ITEM_P, GRP_I               " & vbLf & _
              "                            WHERE GRP_I.GRPCD  = :CODE                " & vbLf & _
              "                              AND GRP_I.ITEMCD = ITEM_P.ITEMCD        " & vbLf & _
              "                              AND GRP_I.ITEMCD = ITEM_C.ITEMCD        " & vbLf & _
              "                              AND GRP_I.SUFFIX = ITEM_C.SUFFIX        " & vbLf & _
              "                         ) GRPITEM                                    "

    End Select
    
    '基本表と項目情報とを結合
    strStmt = strStmt & vbLf & _
              "                   WHERE GRPITEM.ITEMCD = BASEDRSL.ITEMCD(+) " & vbLf & _
              "                     AND GRPITEM.SUFFIX = BASEDRSL.SUFFIX(+) " & vbLf & _
              "                ) BASEDRSL2                                  "

    '前回検査結果を結合
    strStmt = strStmt & vbLf & _
              "          WHERE BASEDRSL2.LASTRSVNO = RSL.RSVNO(+)  " & vbLf & _
              "            AND BASEDRSL2.ITEMCD    = RSL.ITEMCD(+) " & vbLf & _
              "            AND BASEDRSL2.SUFFIX    = RSL.SUFFIX(+) "

    '履歴取得に際し、受診日を取得
    strStmt = strStmt & vbLf & _
              "            AND BASEDRSL2.RSVNO     = CONSULT.RSVNO "

    '履歴は必ずただ１件存在するものと信じ、結合を行う
    strStmt = strStmt & vbLf & _
              "            AND BASEDRSL2.ITEMCD    = ITEM_H.ITEMCD  " & vbLf & _
              "            AND BASEDRSL2.SUFFIX    = ITEM_H.SUFFIX  " & vbLf & _
              "            AND CONSULT.CSLDATE    >= ITEM_H.STRDATE " & vbLf & _
              "            AND CONSULT.CSLDATE    <= ITEM_H.ENDDATE " & vbLf & _
              "       ) FINALRSL                                    "

    '文章、コメントを結合し、SEQ順指定
    strStmt = strStmt & vbLf & _
              " WHERE FINALRSL.STCITEMCD   = CURRENTSENTENCE.ITEMCD(+)   " & vbLf & _
              "   AND FINALRSL.ITEMTYPE    = CURRENTSENTENCE.ITEMTYPE(+) " & vbLf & _
              "   AND FINALRSL.RESULT      = CURRENTSENTENCE.STCCD(+)    " & vbLf & _
              "   AND FINALRSL.STCITEMCD   = BEFSENTENCE.ITEMCD(+)       " & vbLf & _
              "   AND FINALRSL.ITEMTYPE    = BEFSENTENCE.ITEMTYPE(+)     " & vbLf & _
              "   AND FINALRSL.BEFRESULT   = BEFSENTENCE.STCCD(+)        " & vbLf & _
              "   AND FINALRSL.STCITEMCD   = DEFSENTENCE.ITEMCD(+)       " & vbLf & _
              "   AND FINALRSL.ITEMTYPE    = DEFSENTENCE.ITEMTYPE(+)     " & vbLf & _
              "   AND FINALRSL.DEFRESULT   = DEFSENTENCE.STCCD(+)        " & vbLf & _
              "   AND FINALRSL.RSLCMTCD1   = RSLCMT1.RSLCMTCD(+)         " & vbLf & _
              "   AND FINALRSL.RSLCMTCD2   = RSLCMT2.RSLCMTCD(+)         " & vbLf & _
              "   AND FINALRSL.DEFRSLCMTCD = DEFRSLCMT.RSLCMTCD(+)       " & vbLf & _
              "   AND FINALRSL.STDVALUECD  = STDVALUE_C.STDVALUECD(+)    " & vbLf & _
              " ORDER BY FINALRSL.SEQ                                    "
'## 2003.01.05 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSeq = objFields("SEQ")
        Set objConsultFlg = objFields("CONSULTFLG")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objShortStc = objFields("SHORTSTC")
        Set objRslCmtCd1 = objFields("RSLCMTCD1")
        Set objRslCmtName1 = objFields("RSLCMTNAME1")
        Set objRslCmtCd2 = objFields("RSLCMTCD2")
        Set objRslCmtName2 = objFields("RSLCMTNAME2")
        Set objBefResult = objFields("BEFRESULT")
        Set objBefShortStc = objFields("BEFSHORTSTC")
        Set objStdFlg = objFields("STDFLG")
'## 2003.01.05 Add 4Lines By T.Takagi@FSIT 東急対応
        Set objDefResult = objFields("DEFRESULT")
        Set objDefShortStc = objFields("DEFSHORTSTC")
        Set objDefRslCmtCd = objFields("DEFRSLCMTCD")
        Set objDefRslCmtName = objFields("DEFRSLCMTNAME")
'## 2003.01.05 Add End
        
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
        Set objLastRsvNo = objFields("LASTRSVNO")
'## 2003.03.03 Add End
        
'## 2003.01.05 Del 1Line By T.Takagi@FSIT 東急対応
'        blnAllSeqZero = (CLng(objSeq.Value) = 0)
'## 2003.01.05 Del End
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
'## 2003.01.05 Del 3Lines By T.Takagi@FSIT 東急対応
'            If Not blnAllSeqZero Then
'                lngCount = CLng(objSeq.Value) - 1
'            End If
'## 2003.01.05 Del End
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrConsultFlg(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrStcItemCd(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            ReDim Preserve vntArrRslCmtCd1(lngCount)
            ReDim Preserve vntArrRslCmtName1(lngCount)
            ReDim Preserve vntArrRslCmtCd2(lngCount)
            ReDim Preserve vntArrRslCmtName2(lngCount)
            ReDim Preserve vntArrBefResult(lngCount)
            ReDim Preserve vntArrBefShortStc(lngCount)
            ReDim Preserve vntArrStdFlg(lngCount)
'## 2003.01.05 Add 4Lines By T.Takagi@FSIT 東急対応
            ReDim Preserve vntArrDefResult(lngCount)
            ReDim Preserve vntArrDefShortStc(lngCount)
            ReDim Preserve vntArrDefRslCmtCd(lngCount)
            ReDim Preserve vntArrDefRslCmtName(lngCount)
'## 2003.01.05 Add End
            vntArrSeq(lngCount) = CLng(objSeq.Value)
            vntArrConsultFlg(lngCount) = objConsultFlg.Value
            If CLng(objConsultFlg.Value) = CONSULT_ITEM_T Then          '更新可能項目数カウント
                lngUpdItemCount = lngUpdItemCount + 1
            End If
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrSuffix(lngCount) = objSuffix.Value
            vntArrItemName(lngCount) = objItemName.Value
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrResultType(lngCount) = objResultType.Value
            vntArrItemType(lngCount) = objItemType.Value
            vntArrStcItemCd(lngCount) = objStcItemCd.Value
            If vntArrResultType(lngCount) = RESULTTYPE_SENTENCE Then    '文章タイプのときのみ略称セット
                vntArrShortStc(lngCount) = objShortStc.Value & ""
            Else
                vntArrShortStc(lngCount) = ""
            End If
            vntArrRslCmtCd1(lngCount) = objRslCmtCd1.Value & ""
            vntArrRslCmtName1(lngCount) = objRslCmtName1.Value & ""
            vntArrRslCmtCd2(lngCount) = objRslCmtCd2.Value & ""
            vntArrRslCmtName2(lngCount) = objRslCmtName2.Value & ""
            vntArrBefResult(lngCount) = objBefResult.Value & ""
            If vntArrResultType(lngCount) = RESULTTYPE_SENTENCE Then    '文章タイプのときのみ略称セット
                vntArrBefShortStc(lngCount) = objBefShortStc.Value & ""
            Else
                vntArrBefShortStc(lngCount) = ""
            End If
            vntArrStdFlg(lngCount) = objStdFlg.Value & ""
'## 2003.01.05 Add 8Lines By T.Takagi@FSIT 東急対応
            vntArrDefResult(lngCount) = objDefResult.Value & ""
            If vntArrResultType(lngCount) = RESULTTYPE_SENTENCE Then    '文章タイプのときのみ略称セット
                vntArrDefShortStc(lngCount) = objDefShortStc.Value & ""
            Else
                vntArrDefShortStc(lngCount) = ""
            End If
            vntArrDefRslCmtCd(lngCount) = objDefRslCmtCd.Value & ""
            vntArrDefRslCmtName(lngCount) = objDefRslCmtName.Value & ""
'## 2003.01.05 Add End
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
            vntArrLastRsvNo = objLastRsvNo.Value & ""
'## 2003.03.03 Add End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
'## 2003.01.05 Del 3Lines By T.Takagi@FSIT 東急対応
'        If Not blnAllSeqZero Then
'            lngCount = UBound(vntArrSeq) + 1
'        End If
'## 2003.01.05 Del End
    
    End If
    
    '戻り値の設定
    vntUpdItemCount = lngUpdItemCount
    vntSeq = vntArrSeq
    vntConsultFlg = vntArrConsultFlg
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    vntResult = vntArrResult
    vntResultType = vntArrResultType
    vntItemType = vntArrItemType
    vntStcItemCd = vntArrStcItemCd
    vntShortStc = vntArrShortStc
    vntRslCmtCd1 = vntArrRslCmtCd1
    vntRslCmtName1 = vntArrRslCmtName1
    vntRslCmtCd2 = vntArrRslCmtCd2
    vntRslCmtName2 = vntArrRslCmtName2
    vntBefResult = vntArrBefResult
    vntBefShortStc = vntArrBefShortStc
    
    If Not IsMissing(vntStdFlg) Then vntStdFlg = vntArrStdFlg
'## 2003.01.05 Add 4Lines By T.Takagi@FSIT 東急対応
    If Not IsMissing(vntDefResult) Then vntDefResult = vntArrDefResult
    If Not IsMissing(vntDefShortStc) Then vntDefShortStc = vntArrDefShortStc
    If Not IsMissing(vntDefRslCmtCd) Then vntDefRslCmtCd = vntArrDefRslCmtCd
    If Not IsMissing(vntDefRslCmtName) Then vntDefRslCmtName = vntArrDefRslCmtName
'## 2003.01.05 Add End
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
    If Not IsMissing(vntLastRsvNo) Then vntLastRsvNo = vntArrLastRsvNo
'## 2003.03.03 Add End
    
    SelectRslGrpList = lngCount
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objCommon = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.SelectRslGrpList"
    
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
' 機能　　 : 指定個人の指定グループ内検査項目結果を取得
'
' 引数　　 : (In)     strPerId       個人ID
' 　　　　   (In)     strGrpCd       グループコード
' 　　　　   (In)     blnAllGrpItem  True:全てのグループ内検査項目を対象とする、False:検査項目の設定されていないレコードは非対象
' 　　　　   (Out)    vntSeq         SEQ
' 　　　　   (Out)    vntItemCd      検査項目コード
' 　　　　   (Out)    vntSuffix      サフィックス
' 　　　　   (Out)    vntItemName    検査項目名
' 　　　　   (Out)    vntCslDate     受診日
' 　　　　   (Out)    vntCsName      コース名
' 　　　　   (Out)    vntResult      検査結果
' 　　　　   (Out)    vntStdFlg      基準値フラグ
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectRslHistory( _
    ByVal strPerId As String, _
    ByVal strGrpCd As String, _
    Optional ByVal blnAllGrpItem As Boolean = True, _
    Optional ByRef vntSeq As Variant, _
    Optional ByRef vntItemCd As Variant, _
    Optional ByRef vntSuffix As Variant, _
    Optional ByRef vntItemName As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntResult As Variant, _
    Optional ByRef vntStdFlg As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSeq              As OraField         'SEQ
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objCslDate          As OraField         '受診日
    Dim objCsName           As OraField         'コース名
    Dim objResult           As OraField         '検査結果
    Dim objStdFlg           As OraField         '基準値フラグ

    Dim vntArrSeq()         As Variant          'SEQの配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrCsName()      As Variant          'コース名の配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrStdFlg()      As Variant          '基準値フラグの配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntSeq = Empty
    vntItemCd = Empty
    vntSuffix = Empty
    vntItemName = Empty
    vntCslDate = Empty
    vntCsName = Empty
    vntResult = Empty
    vntStdFlg = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定個人の指定グループ内検査項目結果を取得
    strStmt = "SELECT GRPITEMHISTROY.SEQ,     " & vbLf & _
              "       GRPITEMHISTROY.ITEMCD,  " & vbLf & _
              "       GRPITEMHISTROY.SUFFIX,  " & vbLf & _
              "       ITEM_C.ITEMNAME,        " & vbLf & _
              "       GRPITEMHISTROY.CSLDATE, " & vbLf & _
              "       COURSE_P.CSNAME,        " & vbLf & _
              "       RSL.RESULT,             " & vbLf & _
              "       STDVALUE_C.STDFLG       " & vbLf & _
              "  FROM STDVALUE_C,             " & vbLf & _
              "       RSL,                    " & vbLf & _
              "       COURSE_P,               " & vbLf & _
              "       ITEM_C,                 "
    
    '指定個人の全受診情報と指定グループ内全検査項目との内部結合を実施した表を基本表とする
    strStmt = strStmt & vbLf & _
              "       ( SELECT GRP_I.SEQ,                           " & vbLf & _
              "                GRP_I.ITEMCD,                        " & vbLf & _
              "                GRP_I.SUFFIX,                        " & vbLf & _
              "                CONSULT.RSVNO,                       " & vbLf & _
              "                CONSULT.CSLDATE,                     " & vbLf & _
              "                CONSULT.CSCD                         " & vbLf & _
              "           FROM RECEIPT, CONSULT, GRP_I              " & vbLf & _
              "          WHERE GRP_I.GRPCD     = :GRPCD             "
              
    '検査項目の設定されていないレコードを非対象とする場合の条件追加
    If Not blnAllGrpItem Then
        strStmt = strStmt & vbLf & _
              "            AND GRP_I.ITEMCD   IS NOT NULL " & vbLf & _
              "            AND GRP_I.SUFFIX   IS NOT NULL "
    End If
    
    '指定個人IDの受診情報を取得するための結合
'## 2002.03.28 Mod By H.Ishihara@FSIT キャンセルフラグの制御がない
'    strStmt = strStmt & vbLf & _
              "            AND CONSULT.PERID   = :PERID             " & vbLf & _
              "            AND CONSULT.RSVNO   = RECEIPT.RSVNO(+)   " & vbLf & _
              "            AND CONSULT.CSLDATE = RECEIPT.CSLDATE(+) "
    strStmt = strStmt & vbLf & _
              "            AND CONSULT.PERID     = :PERID             " & vbLf & _
              "            AND CONSULT.CANCELFLG = '0'                " & vbLf & _
              "            AND CONSULT.RSVNO     = RECEIPT.RSVNO(+)   " & vbLf & _
              "            AND CONSULT.CSLDATE   = RECEIPT.CSLDATE(+) "
              
              
    'ORDER BY句の指定
    strStmt = strStmt & vbLf & _
              "          ORDER BY GRP_I.SEQ,                     " & vbLf & _
              "                   GRP_I.ITEMCD,                  " & vbLf & _
              "                   GRP_I.SUFFIX,                  " & vbLf & _
              "                   CONSULT.CSLDATE DESC,          " & vbLf & _
              "                   RECEIPT.DAYID DESC NULLS LAST, " & vbLf & _
              "                   CONSULT.CSCD                   " & vbLf & _
              "       ) GRPITEMHISTROY                           "
    
    '基本表に各テーブル内容を結合
    strStmt = strStmt & vbLf & _
              " WHERE GRPITEMHISTROY.ITEMCD = ITEM_C.ITEMCD(+)         " & vbLf & _
              "   AND GRPITEMHISTROY.SUFFIX = ITEM_C.SUFFIX(+)         " & vbLf & _
              "   AND GRPITEMHISTROY.CSCD   = COURSE_P.CSCD            " & vbLf & _
              "   AND GRPITEMHISTROY.RSVNO  = RSL.RSVNO(+)             " & vbLf & _
              "   AND GRPITEMHISTROY.ITEMCD = RSL.ITEMCD(+)            " & vbLf & _
              "   AND GRPITEMHISTROY.SUFFIX = RSL.SUFFIX(+)            " & vbLf & _
              "   AND RSL.STDVALUECD        = STDVALUE_C.STDVALUECD(+) "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSeq = objFields("SEQ")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objCslDate = objFields("CSLDATE")
        Set objCsName = objFields("CSNAME")
        Set objResult = objFields("RESULT")
        Set objStdFlg = objFields("STDFLG")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrStdFlg(lngCount)
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrStdFlg(lngCount) = objStdFlg.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntSeq = vntArrSeq
        vntItemCd = vntArrItemCd
        vntSuffix = vntArrSuffix
        vntItemName = vntArrItemName
        vntCslDate = vntArrCslDate
        vntCsName = vntArrCsName
        vntResult = vntArrResult
        vntStdFlg = vntArrStdFlg

    End If

    'バインド変数の削除
    objOraParam.Remove "PERID"
    objOraParam.Remove "GRPCD"

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    SelectRslHistory = lngCount

    Exit Function

ErrorHandle:

    SelectRslHistory = -1

    'イベントログ書き込み
    WriteErrorLog "Result.SelectRslHistory"
    
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
' 機能　　 : 指定対象受診者の検査結果を取得する
'
' 引数　　 : (In)     strRsvNo        予約番号
' 　　　　 : (Out)    vntItemName     検査項目名称
' 　　　　 : (Out)    vntResult       検査結果
' 　　　　 : (Out)    vntResultType   結果タイプ
' 　　　　 : (Out)    vntShortStc     文章略称
' 　　　　 : (Out)    vntStdFlgColor  基準値フラグ表示色
' 　　　　 : (Out)    vntRslCmtName1  結果コメント名称１
' 　　　　 : (Out)    vntRslCmtName2  結果コメント名称２
' 　　　　 : (In)     vntClassName    検査分類名
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectInquiryRslList(ByVal strRsvNo As String, _
                                     ByVal strRslQue As String, _
                                     ByRef vntItemName As Variant, _
                                     ByRef vntResult As Variant, _
                                     ByRef vntResultType As Variant, _
                                     ByRef vntShortStc As Variant, _
                                     ByRef vntStdFlgColor As Variant, _
                                     ByRef vntRslCmtName1 As Variant, _
                                     ByRef vntRslCmtName2 As Variant, _
                                     Optional ByRef vntClassName As Variant _
                                     ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objCommon           As Common           '共通クラス
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemName         As OraField         '検査項目名
    Dim objResult           As OraField         '検査結果
    Dim objResultType       As OraField         '結果タイプ
    Dim objShortStc         As OraField         '略文章
    Dim objStdFlg           As OraField         '基準値フラグ
    Dim objRslCmtName1      As OraField         '結果コメント名称１
    Dim objRslCmtName2      As OraField         '結果コメント名称２
    Dim objClassName        As OraField         '検査分類名

    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrShortStc()    As Variant          '略文章の配列
    Dim vntArrStdFlgColor() As Variant          '基準値フラグ表示色の配列
    Dim vntArrRslCmtName1() As Variant          '結果コメント名称１の配列
    Dim vntArrRslCmtName2() As Variant          '結果コメント名称２の配列
    Dim vntArrClassName()   As Variant          '検査分類名
    
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合はエラー
    If IsEmpty(strRsvNo) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    Select Case strRslQue
        Case RSLQUE_R, RSLQUE_Q
        Case Else
            Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(strRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSLQUE", Trim(strRslQue), ORAPARM_INPUT, ORATYPE_NUMBER
    
'## 2002.03.29 Modified By H.Ishihara@FSIT 検査分類をプラス
    '検索条件を満たす検査結果情報のレコードを取得
'    strStmt = "SELECT RL.ITEMNAME, RL.RESULT, RL.RESULTTYPE, SC.SHORTSTC, RL.STDFLG,    " & vbLf & _
              "       RL.RSLCMTNAME1, RL.RSLCMTNAME2                                    " & vbLf & _
              "  FROM ( SELECT IC.ITEMNAME,  RS.RESULT, IC.RESULTTYPE, IC.ITEMTYPE,     " & vbLf & _
              "                IC.STCITEMCD, SV.STDFLG, R1.RSLCMTNAME  RSLCMTNAME1,     " & vbLf & _
              "                R2.RSLCMTNAME RSLCMTNAME2                                " & vbLf & _
              "           FROM RSL RS, ITEM_C IC, ITEM_P IP, STDVALUE_C SV, RSLCMT R1,  " & vbLf & _
              "                RSLCMT R2                                                " & vbLf & _
              "          WHERE RS.RSVNO      = :RSVNO                                   " & vbLf & _
              "            AND IP.RSLQUE     = :RSLQUE                                  " & vbLf & _
              "            AND RS.ITEMCD     = IP.ITEMCD                                " & vbLf & _
              "            AND RS.ITEMCD     = IC.ITEMCD                                " & vbLf & _
              "            AND RS.SUFFIX     = IC.SUFFIX                                " & vbLf & _
              "            AND RS.STDVALUECD = SV.STDVALUECD(+)                         " & vbLf & _
              "            AND RS.RSLCMTCD1  = R1.RSLCMTCD(+)                           " & vbLf & _
              "            AND RS.RSLCMTCD2  = R2.RSLCMTCD(+)                           " & vbLf & _
              "          ORDER BY RS.ITEMCD, RS.SUFFIX                                  " & vbLf & _
              "       ) RL, SENTENCE SC                                                 " & vbLf & _
              " WHERE RL.STCITEMCD = SC.ITEMCD(+)                                       " & vbLf & _
              "   AND RL.ITEMTYPE  = SC.ITEMTYPE(+)                                     " & vbLf & _
              "   AND RL.RESULT    = SC.STCCD(+)                                        "
    strStmt = "SELECT MASTERRESULT.ITEMNAME,    MASTERRESULT.RESULT,      MASTERRESULT.RESULTTYPE, " & vbLf & _
              "       SENTENCE.SHORTSTC,        MASTERRESULT.STDFLG,      ITEMCLASS.CLASSCD,       " & vbLf & _
              "       MASTERRESULT.RSLCMTNAME1, MASTERRESULT.RSLCMTNAME2, ITEMCLASS.CLASSNAME,     " & vbLf & _
              "       MASTERRESULT.ITEMCD,      MASTERRESULT.SUFFIX " & vbLf & _
              "  FROM SENTENCE SENTENCE, ITEMCLASS ITEMCLASS,       " & vbLf & _
              "     ( SELECT ITEM_C.ITEMNAME,   RSL.RESULT,        ITEM_C.RESULTTYPE,  ITEM_C.ITEMTYPE,    " & vbLf & _
              "              ITEM_C.STCITEMCD,  STDVALUE_C.STDFLG, RSLCMT1.RSLCMTNAME  RSLCMTNAME1,        " & vbLf & _
              "              RSLCMT2.RSLCMTNAME RSLCMTNAME2,       ITEM_P.CLASSCD,     ITEM_C.ITEMCD,      " & vbLf & _
              "              ITEM_C.SUFFIX" & vbLf & _
              "         FROM RSL RSL, ITEM_C ITEM_C, ITEM_P ITEM_P, STDVALUE_C STDVALUE_C, RSLCMT RSLCMT1, " & vbLf & _
              "              RSLCMT RSLCMT2                            " & vbLf & _
              "        WHERE RSL.RSVNO      = :RSVNO                   " & vbLf & _
              "          AND ITEM_P.RSLQUE  = :RSLQUE                  " & vbLf & _
              "          AND RSL.ITEMCD     = ITEM_P.ITEMCD            " & vbLf & _
              "          AND RSL.ITEMCD     = ITEM_C.ITEMCD            " & vbLf & _
              "          AND RSL.SUFFIX     = ITEM_C.SUFFIX            " & vbLf & _
              "          AND RSL.STDVALUECD = STDVALUE_C.STDVALUECD(+) " & vbLf & _
              "          AND RSL.RSLCMTCD1  = RSLCMT1.RSLCMTCD(+)      " & vbLf & _
              "          AND RSL.RSLCMTCD2  = RSLCMT2.RSLCMTCD(+)      " & vbLf & _
              "       ) MASTERRESULT                                   " & vbLf & _
              " WHERE MASTERRESULT.STCITEMCD = SENTENCE.ITEMCD(+)      " & vbLf & _
              "   AND MASTERRESULT.ITEMTYPE  = SENTENCE.ITEMTYPE(+)    " & vbLf & _
              "   AND MASTERRESULT.RESULT    = SENTENCE.STCCD(+)       " & vbLf & _
              "   AND ITEMCLASS.CLASSCD      = MASTERRESULT.CLASSCD    " & vbLf & _
              " ORDER BY ITEMCLASS.CLASSCD, MASTERRESULT.ITEMCD, MASTERRESULT.SUFFIX"
'## 2002.03.29 Modified End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        '共通クラスのインスタンス作成
        Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objResultType = objFields("RESULTTYPE")
        Set objShortStc = objFields("SHORTSTC")
        Set objStdFlg = objFields("STDFLG")
        Set objRslCmtName1 = objFields("RSLCMTNAME1")
        Set objRslCmtName2 = objFields("RSLCMTNAME2")
        Set objClassName = objFields("CLASSNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            ReDim Preserve vntArrStdFlgColor(lngCount)
            ReDim Preserve vntArrRslCmtName1(lngCount)
            ReDim Preserve vntArrRslCmtName2(lngCount)
            ReDim Preserve vntArrClassName(lngCount)
            vntArrItemName(lngCount) = objItemName.Value
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrResultType(lngCount) = objResultType.Value
            If vntArrResultType(lngCount) = RESULTTYPE_SENTENCE Then    '文章タイプのときのみ略称セット
                vntArrShortStc(lngCount) = objShortStc.Value & ""
            Else
                vntArrShortStc(lngCount) = ""
            End If
            objCommon.SelectStdFlgColor objStdFlg.Value & "_COLOR", vntArrStdFlgColor(lngCount)
            vntArrRslCmtName1(lngCount) = objRslCmtName1.Value & ""
            vntArrRslCmtName2(lngCount) = objRslCmtName2.Value & ""
            vntArrClassName(lngCount) = objClassName.Value
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemName = vntArrItemName
    vntResult = vntArrResult
    vntResultType = vntArrResultType
    vntShortStc = vntArrShortStc
    vntStdFlgColor = vntArrStdFlgColor
    vntRslCmtName1 = vntArrRslCmtName1
    vntRslCmtName2 = vntArrRslCmtName2
    If IsMissing(vntClassName) = False Then vntClassName = vntArrClassName
    
    SelectInquiryRslList = lngCount
        
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
    WriteErrorLog "Result.SelectInquiryRslList"
    
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
' 機能　　 : 指定条件を満たす検査結果レコードの検査結果を取得
'
' 引数　　 : (In)     lngRsvNo   予約番号
' 　　　　   (In)     strItemCd  検査項目コード
' 　　　　   (In)     strSuffix  サフィックス
' 　　　　   (Out)    vntResult  検査結果
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectRsl(ByVal lngRsvNo As Long, ByVal strItemCd As String, ByVal strSuffix As String, ByRef vntResult As Variant) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objResult   As OraField         '検査結果

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntResult = Empty

    'キー値の設定(UpdateRsl_tkメソッドから呼ばれる場合に対応するため、バインド変数名が重複しないようにしている)
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO2", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMCD2", strItemCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX2", strSuffix, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定条件を満たす検査結果レコードの検査結果を取得
    strStmt = "SELECT RESULT FROM RSL WHERE RSVNO=:RSVNO2 AND ITEMCD=:ITEMCD2 AND SUFFIX=:SUFFIX2"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objResult = objFields("RESULT")
        
        '戻り値の設定
        If Not IsNull(objResult.Value) Then
            vntResult = objResult.Value
        End If
        
        SelectRsl = True
        
    End If

    'バインド変数の削除
    '(Doループで削除するとUpdateRsl_tkメソッド(親)から呼ばれた場合親メソッド自体のバインド変数も削除されてしまうので個別に指定)
    objOraParam.Remove "RSVNO2"
    objOraParam.Remove "ITEMCD2"
    objOraParam.Remove "SUFFIX2"
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.SelectRsl"
    
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
' 機能　　 : 指定対象受診者・検査グループの検査項目を取得する
'
' 引数　　 : (In)     vntRsvNo          予約番号
' 　　　　   (Out)    vntUpdItemCount   更新可能項目数
' 　　　　   (Out)    vntSeq            表示行位置
' 　　　　   (Out)    vntConsultFlg     受診項目フラグ
' 　　　　   (Out)    vntItemCd         検査項目コード
' 　　　　   (Out)    vntSuffix         サフィックス
' 　　　　   (Out)    vntItemName       検査項目名称
' 　　　　   (Out)    vntResult         検査結果
' 　　　　   (Out)    vntResultType     結果タイプ
' 　　　　   (Out)    vntItemType       項目タイプ
' 　　　　   (Out)    vntStcItemCd      文章参照用項目コード
' 　　　　   (Out)    vntShortStc       文章略称
' 　　　　   (Out)    vntRslCmtCd1      結果コメントコード１
' 　　　　   (Out)    vntRslCmtName1    結果コメント名称１
' 　　　　   (Out)    vntRslCmtCd2      結果コメントコード２
' 　　　　   (Out)    vntRslCmtName2    結果コメント名称２
' 　　　　   (Out)    vntBefResult      前回値・検査結果
' 　　　　   (Out)    vntBefShortStc    前回値・文章略称
' 　　　　   (Out)    vntStdFlg         基準値フラグ
' 　　　　   (Out)    vntDefResult      省略時検査結果
' 　　　　   (Out)    vntDefShortStc    省略時文章略称
' 　　　　   (Out)    vntDefRslCmtCd    省略時結果コメントコード
' 　　　　   (Out)    vntDefRslCmtName  省略時結果コメント名称
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
'## 2003.01.04 Mod 43Lines By T.Takagi@FSIT 東急対応
'Private Function SelectRslAllList(ByVal vntRsvNo As Variant,
'                                  ByRef vntUpdItemCount As Variant,
'                                  ByRef vntSeq As Variant,
'                                  ByRef vntConsultFlg As Variant,
'                                  ByRef vntItemCd As Variant,
'                                  ByRef vntSuffix As Variant,
'                                  ByRef vntItemName As Variant,
'                                  ByRef vntResult As Variant,
'                                  ByRef vntResultType As Variant,
'                                  ByRef vntItemType As Variant,
'                                  ByRef vntStcItemCd As Variant,
'                                  ByRef vntShortStc As Variant,
'                                  ByRef vntRslCmtCd1 As Variant,
'                                  ByRef vntRslCmtName1 As Variant,
'                                  ByRef vntRslCmtCd2 As Variant,
'                                  ByRef vntRslCmtName2 As Variant,
'                                  ByRef vntBefResult As Variant,
'                                  ByRef vntBefShortStc As Variant,
'                                  Optional ByRef vntStdFlg As Variant
'                                 ) As Long
'## 2003.03.03 Mod 46Lines By T.Takagi@FSIT 前回予約番号取得
'Private Function SelectRslAllList(
'    ByVal vntRsvNo As Variant,
'    ByRef vntUpdItemCount As Variant,
'    ByRef vntSeq As Variant,
'    ByRef vntConsultFlg As Variant,
'    ByRef vntItemCd As Variant,
'    ByRef vntSuffix As Variant,
'    ByRef vntItemName As Variant,
'    ByRef vntResult As Variant,
'    ByRef vntResultType As Variant,
'    ByRef vntItemType As Variant,
'    ByRef vntStcItemCd As Variant,
'    ByRef vntShortStc As Variant,
'    ByRef vntRslCmtCd1 As Variant,
'    ByRef vntRslCmtName1 As Variant,
'    ByRef vntRslCmtCd2 As Variant,
'    ByRef vntRslCmtName2 As Variant,
'    ByRef vntBefResult As Variant,
'    ByRef vntBefShortStc As Variant,
'    Optional ByRef vntStdFlg As Variant,
'    Optional ByRef vntDefResult As Variant, Optional ByRef vntDefShortStc As Variant,
'    Optional ByRef vntDefRslCmtCd As Variant, Optional ByRef vntDefRslCmtName As Variant
') As Long
Private Function SelectRslAllList( _
    ByVal vntRsvNo As Variant, _
    ByRef vntUpdItemCount As Variant, _
    ByRef vntSeq As Variant, _
    ByRef vntConsultFlg As Variant, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntItemName As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntResultType As Variant, _
    ByRef vntItemType As Variant, _
    ByRef vntStcItemCd As Variant, _
    ByRef vntShortStc As Variant, _
    ByRef vntRslCmtCd1 As Variant, _
    ByRef vntRslCmtName1 As Variant, _
    ByRef vntRslCmtCd2 As Variant, _
    ByRef vntRslCmtName2 As Variant, _
    ByRef vntBefResult As Variant, ByRef vntBefShortStc As Variant, _
    Optional ByRef vntStdFlg As Variant, _
    Optional ByRef vntDefResult As Variant, Optional ByRef vntDefShortStc As Variant, _
    Optional ByRef vntDefRslCmtCd As Variant, Optional ByRef vntDefRslCmtName As Variant, _
    Optional ByRef vntLastRsvNo As Variant _
) As Long
'## 2003.03.03 Mod End
'## 2003.01.04 Mod End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
'## 2003.01.04 Del 1Line By T.Takagi@FSIT 東急対応
'    Dim objSeq              As OraField         '表示行位置
'## 2003.01.04 Del End
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objResult           As OraField         '検査結果
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objShortStc         As OraField         '略文章
    Dim objRslCmtCd1        As OraField         '結果コメント１
    Dim objRslCmtName1      As OraField         '結果コメント名１
    Dim objRslCmtCd2        As OraField         '結果コメント２
    Dim objRslCmtName2      As OraField         '結果コメント名２
    Dim objBefResult        As OraField         '前回値・検査結果
    Dim objBefShortStc      As OraField         '前回値・略文章
    Dim objStdFlg           As OraField         '基準値フラグ
'## 2003.01.04 Add 4Lines By T.Takagi@FSIT 東急対応
    Dim objDefResult        As OraField         '省略時検査結果
    Dim objDefShortStc      As OraField         '省略時文章略称
    Dim objDefRslCmtCd      As OraField         '省略時結果コメントコード
    Dim objDefRslCmtName    As OraField         '省略時結果コメント名称
'## 2003.01.04 Add End
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
    Dim objLastRsvNo        As OraField         '前回予約番号
'## 2003.03.03 Add End

    Dim objCommon           As Common           '共通クラス
    
    Dim vntArrSeq()         As Variant          '表示行位置の配列
    Dim vntArrConsultFlg()  As Variant          '受診項目フラグの配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コードの配列
    Dim vntArrShortStc()    As Variant          '略文章の配列
    Dim vntArrRslCmtCd1()   As Variant          '結果コメント１の配列
    Dim vntArrRslCmtName1() As Variant          '結果コメント名１の配列
    Dim vntArrRslCmtCd2()   As Variant          '結果コメント２の配列
    Dim vntArrRslCmtName2() As Variant          '結果コメント名２の配列
    Dim vntArrBefResult()   As Variant          '前回値・検査結果の配列
    Dim vntArrBefShortStc() As Variant          '前回値・略文章の配列
    Dim vntArrStdFlg()      As Variant          '基準値フラグの配列
'## 2003.01.04 Add 4Lines By T.Takagi@FSIT 東急対応
    Dim vntArrDefResult()       As Variant      '省略時検査結果の配列
    Dim vntArrDefShortStc()     As Variant      '省略時文章略称の配列
    Dim vntArrDefRslCmtCd()     As Variant      '省略時結果コメントコードの配列
    Dim vntArrDefRslCmtName()   As Variant      '省略時結果コメント名称の配列
'## 2003.01.04 Add End
    
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
    Dim vntArrLastRsvNo     As Variant          '前回予約番号の配列
'## 2003.03.03 Add End
    
    Dim lngCourseFlg        As Long             'コース選択
    Dim lngSecondFlg        As Long             '２次検査コース選択
    
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
    '前回値表示条件取得
    lngCourseFlg = objCommon.SelectRslCourseFlg
    lngSecondFlg = objCommon.SelectRslSecondFlg
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
'## 2003.01.04 Mod 194Lines By T.Takagi@FSIT 東急対応
'    objOraParam.Add "RSVNO", Trim(vntRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "CANCELFLG", Trim(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
'    If lngSecondFlg = RSLSECOND_NONE Then
'        objOraParam.Add "SECONDFLG", Trim(COURSE_FIRST), ORAPARM_INPUT, ORATYPE_NUMBER
'    End If
'
'    '検索条件を満たす検査結果情報のレコードを取得
'    strStmt = "SELECT ROWNUM SEQ, CURRSL.ITEMCD, CURRSL.SUFFIX, CURRSL.ITEMNAME, CURRSL.RESULT,             " & vbLf & _
'              "       CURRSL.RESULTTYPE, CURRSL.ITEMTYPE, CURRSL.STCITEMCD, CURRSL.SHORTSTC,                " & vbLf & _
'              "       CURRSL.RSLCMTCD1, CURRSL.RSLCMTNAME1, CURRSL.RSLCMTCD2, CURRSL.RSLCMTNAME2,           " & vbLf & _
'              "       BEFRSL.RESULT BEFRESULT, BEFRSL.SHORTSTC BEFSHORTSTC, CURRSL.STDFLG                   "
'    strStmt = strStmt & vbLf & _
'              "  FROM ( SELECT Q.ITEMCD, Q.SUFFIX, Q.ITEMNAME, Q.RESULT, Q.RESULTTYPE," & vbLf & _
'              "                Q.ITEMTYPE, Q.STCITEMCD, S.SHORTSTC, Q.RSLCMTCD1, Q.RSLCMTNAME1, Q.RSLCMTCD2," & vbLf & _
'              "                Q.RSLCMTNAME2, Q.STDFLG                                                      " & vbLf & _
'              "           FROM ( SELECT R.ITEMCD, R.SUFFIX, IC.ITEMNAME, R.RESULT, IC.RESULTTYPE,           " & vbLf & _
'              "                         IC.ITEMTYPE, IC.STCITEMCD, R.RSLCMTCD1, RC1.RSLCMTNAME RSLCMTNAME1, " & vbLf & _
'              "                         R.RSLCMTCD2, RC2.RSLCMTNAME RSLCMTNAME2,                            " & vbLf & _
'              "                         STDVALUE_C.STDFLG                                                   " & vbLf & _
'              "                    FROM STDVALUE_C, RSL R, ITEM_C IC, RSLCMT RC1, RSLCMT RC2                " & vbLf & _
'              "                   WHERE R.RSVNO      = :RSVNO                                               " & vbLf & _
'              "                     AND R.ITEMCD     = IC.ITEMCD                                            " & vbLf & _
'              "                     AND R.SUFFIX     = IC.SUFFIX                                            " & vbLf & _
'              "                     AND R.RSLCMTCD1  = RC1.RSLCMTCD(+)                                      " & vbLf & _
'              "                     AND R.RSLCMTCD2  = RC2.RSLCMTCD(+)                                      " & vbLf & _
'              "                     AND R.STDVALUECD = STDVALUE_C.STDVALUECD(+)                             " & vbLf & _
'              "                ) Q, SENTENCE S                                                              " & vbLf & _
'              "          WHERE Q.STCITEMCD = S.ITEMCD(+)                                                    " & vbLf & _
'              "            AND Q.ITEMTYPE  = S.ITEMTYPE(+)                                                  " & vbLf & _
'              "            AND Q.RESULT    = S.STCCD(+)                                                     " & vbLf & _
'              "          ORDER BY Q.ITEMCD, Q.SUFFIX                                                        " & vbLf & _
'              "       ) CURRSL,                                                                             "
'    strStmt = strStmt & vbLf & _
'              "       ( SELECT B.ITEMCD, B.SUFFIX, B.RESULT, B.RESULTTYPE, S.SHORTSTC                       " & vbLf & _
'              "           FROM ( SELECT BC.RSVNO, R.ITEMCD, R.SUFFIX, R.RESULT, IC.RESULTTYPE, IC.ITEMTYPE, " & vbLf & _
'              "                         IC.STCITEMCD                                                        " & vbLf & _
'              "                    FROM ( SELECT RSVNO                                                      " & vbLf & _
'              "                             FROM ( SELECT CN.CSLDATE, CN.RSVNO                              " & vbLf & _
'              "                                      FROM CONSULT CN, RECEIPT RC, COURSE_P CP,              " & vbLf & _
'              "                                           ( SELECT CN.PERID, CN.CSLDATE, CN.CSCD            " & vbLf & _
'              "                                               FROM CONSULT CN                               " & vbLf & _
'              "                                              WHERE CN.RSVNO     = :RSVNO                    " & vbLf & _
'              "                                                AND CN.CANCELFLG = :CANCELFLG                " & vbLf & _
'              "                                           ) CUR                                             " & vbLf & _
'              "                                     WHERE CN.PERID     = CUR.PERID                          " & vbLf & _
'              "                                       AND CN.CSLDATE   < CUR.CSLDATE                        " & vbLf & _
'              "                                       AND CN.CSCD      = CP.CSCD                            "
'    '同一コースのみ対象とする
'    If lngCourseFlg = RSLCOURSE_SAME Then
'        strStmt = strStmt & vbLf & _
'              "                                       AND CN.CSCD      = CUR.CSCD                           "
'    End If
'    '２次検査コースを対象としない
'    If lngSecondFlg = RSLSECOND_NONE Then
'        strStmt = strStmt & vbLf & _
'    "                                                 AND CP.SECONDFLG = :SECONDFLG                         "
'    End If
'    strStmt = strStmt & vbLf & _
'              "                                       AND CN.RSVNO     = RC.RSVNO                           " & vbLf & _
'              "                                       AND CN.CSLDATE   = RC.CSLDATE                         " & vbLf & _
'              "                                     ORDER BY CN.CSLDATE DESC, CN.RSVNO                      " & vbLf & _
'              "                                  )                                                          " & vbLf & _
'              "                            WHERE ROWNUM = 1                                                 " & vbLf & _
'              "                         ) BC, RSL R, ITEM_C IC                                              "
'    strStmt = strStmt & vbLf & _
'              "                   WHERE R.RSVNO  = BC.RSVNO                                                 " & vbLf & _
'              "                     AND R.ITEMCD = IC.ITEMCD                                                " & vbLf & _
'              "                     AND R.SUFFIX = IC.SUFFIX                                                " & vbLf & _
'              "                ) B, SENTENCE S                                                              " & vbLf & _
'              "          WHERE B.STCITEMCD = S.ITEMCD(+)                                                    " & vbLf & _
'              "            AND B.ITEMTYPE  = S.ITEMTYPE(+)                                                  " & vbLf & _
'              "            AND B.RESULT    = S.STCCD(+)                                                     " & vbLf & _
'              "       ) BEFRSL                                                                              " & vbLf & _
'              " WHERE CURRSL.ITEMCD = BEFRSL.ITEMCD(+)                                                      " & vbLf & _
'              "   AND CURRSL.SUFFIX = BEFRSL.SUFFIX(+)                                                      "
    
    objOraParam.Add "RSVNO", CLng(vntRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定予約番号の全検査結果情報を取得
'## 2003.03.03 Mod 32Lines By T.Takagi@FSIT 前回予約番号取得
'    strStmt = "SELECT FINALRSL.ITEMCD,      FINALRSL.SUFFIX, FINALRSL.ITEMNAME,    " & vbLf & _
'              "       FINALRSL.RESULT,      CURRENTSENTENCE.SHORTSTC,              " & vbLf & _
'              "       FINALRSL.RSLCMTCD1,   RSLCMT1.RSLCMTNAME RSLCMTNAME1,        " & vbLf & _
'              "       FINALRSL.RSLCMTCD2,   RSLCMT2.RSLCMTNAME RSLCMTNAME2,        " & vbLf & _
'              "       FINALRSL.BEFRESULT,   LASTSENTENCE.SHORTSTC BEFSHORTSTC,     " & vbLf & _
'              "       FINALRSL.RESULTTYPE,  FINALRSL.ITEMTYPE, FINALRSL.STCITEMCD, " & vbLf & _
'              "       STDVALUE_C.STDFLG,                                           " & vbLf & _
'              "       FINALRSL.DEFRESULT,   DEFSENTENCE.SHORTSTC DEFSHORTSTC,      " & vbLf & _
'              "       FINALRSL.DEFRSLCMTCD, DEFRSLCMT.RSLCMTNAME DEFRSLCMTNAME     " & vbLf & _
'              "  FROM STDVALUE_C,                                                  " & vbLf & _
'              "       RSLCMT RSLCMT1,                                              " & vbLf & _
'              "       RSLCMT RSLCMT2,                                              " & vbLf & _
'              "       RSLCMT DEFRSLCMT,                                            " & vbLf & _
'              "       SENTENCE LASTSENTENCE,                                       " & vbLf & _
'              "       SENTENCE CURRENTSENTENCE,                                    " & vbLf & _
'              "       SENTENCE DEFSENTENCE,                                        "
    strStmt = "SELECT FINALRSL.ITEMCD,      FINALRSL.SUFFIX, FINALRSL.ITEMNAME,    " & vbLf & _
              "       FINALRSL.RESULT,      CURRENTSENTENCE.SHORTSTC,              " & vbLf & _
              "       FINALRSL.RSLCMTCD1,   RSLCMT1.RSLCMTNAME RSLCMTNAME1,        " & vbLf & _
              "       FINALRSL.RSLCMTCD2,   RSLCMT2.RSLCMTNAME RSLCMTNAME2,        " & vbLf & _
              "       FINALRSL.BEFRESULT,   LASTSENTENCE.SHORTSTC BEFSHORTSTC,     " & vbLf & _
              "       FINALRSL.RESULTTYPE,  FINALRSL.ITEMTYPE, FINALRSL.STCITEMCD, " & vbLf & _
              "       STDVALUE_C.STDFLG,    FINALRSL.LASTRSVNO,                    " & vbLf & _
              "       FINALRSL.DEFRESULT,   DEFSENTENCE.SHORTSTC DEFSHORTSTC,      " & vbLf & _
              "       FINALRSL.DEFRSLCMTCD, DEFRSLCMT.RSLCMTNAME DEFRSLCMTNAME     " & vbLf & _
              "  FROM STDVALUE_C,                                                  " & vbLf & _
              "       RSLCMT RSLCMT1,                                              " & vbLf & _
              "       RSLCMT RSLCMT2,                                              " & vbLf & _
              "       RSLCMT DEFRSLCMT,                                            " & vbLf & _
              "       SENTENCE LASTSENTENCE,                                       " & vbLf & _
              "       SENTENCE CURRENTSENTENCE,                                    " & vbLf & _
              "       SENTENCE DEFSENTENCE,                                        "
'## 2003.03.03 Mod End
    
    '基本表に前回検査結果、検査項目および履歴情報を結合
'## 2003.03.03 Mod 24Lines By T.Takagi@FSIT 前回予約番号取得
'    strStmt = strStmt & vbLf & _
'              "       ( SELECT BASEDRSL.RSVNO,     BASEDRSL.ITEMCD,    " & vbLf & _
'              "                BASEDRSL.SUFFIX,    BASEDRSL.RESULT,    " & vbLf & _
'              "                BASEDRSL.RSLCMTCD1, BASEDRSL.RSLCMTCD2, " & vbLf & _
'              "                BASEDRSL.STDVALUECD,                    " & vbLf & _
'              "                ITEM_C.ITEMNAME,  ITEM_C.RESULTTYPE,    " & vbLf & _
'              "                ITEM_C.ITEMTYPE,  ITEM_C.STCITEMCD,     " & vbLf & _
'              "                RSL.RESULT BEFRESULT,                   " & vbLf & _
'              "                ITEM_H.DEFRESULT, ITEM_H.DEFRSLCMTCD    " & vbLf & _
'              "           FROM ITEM_H, CONSULT,                        " & vbLf & _
'              "                ITEM_C,                                 " & vbLf & _
'              "                RSL,                                    "
    strStmt = strStmt & vbLf & _
              "       ( SELECT BASEDRSL.RSVNO,      BASEDRSL.ITEMCD,    " & vbLf & _
              "                BASEDRSL.SUFFIX,     BASEDRSL.RESULT,    " & vbLf & _
              "                BASEDRSL.RSLCMTCD1,  BASEDRSL.RSLCMTCD2, " & vbLf & _
              "                BASEDRSL.STDVALUECD, BASEDRSL.LASTRSVNO, " & vbLf & _
              "                ITEM_C.ITEMNAME,  ITEM_C.RESULTTYPE,     " & vbLf & _
              "                ITEM_C.ITEMTYPE,  ITEM_C.STCITEMCD,      " & vbLf & _
              "                RSL.RESULT BEFRESULT,                    " & vbLf & _
              "                ITEM_H.DEFRESULT, ITEM_H.DEFRSLCMTCD     " & vbLf & _
              "           FROM ITEM_H, CONSULT,                         " & vbLf & _
              "                ITEM_C,                                  " & vbLf & _
              "                RSL,                                     "
'## 2003.03.03 Mod End
    
    '今回結果と受診日、そして前回予約番号で構成される基本表
    strStmt = strStmt & vbLf & _
              "                ( SELECT RSL.RSVNO,     RSL.ITEMCD,    RSL.SUFFIX,     RSL.RESULT, " & vbLf & _
              "                         RSL.RSLCMTCD1, RSL.RSLCMTCD2, RSL.STDVALUECD,             "
    
    '個人ＩＤ、受診日降順で１件だけ前回受診情報を取得
    strStmt = strStmt & vbLf & _
              "                         ( SELECT /*+ INDEX_DESC(CONSULT CONSULT_INDEX4) */ " & vbLf & _
              "                                  CONSULT.RSVNO                             " & vbLf & _
              "                             FROM COURSE_P, RECEIPT, CONSULT,               "
    
    'もともとの受診情報
    strStmt = strStmt & vbLf & _
              "                                  ( SELECT CSLDATE, PERID, CSCD " & vbLf & _
              "                                      FROM CONSULT              " & vbLf & _
              "                                     WHERE RSVNO = :RSVNO       " & vbLf & _
              "                                  ) CURRENTCONSULT              "
    
    '過去歴検索のための条件節
    strStmt = strStmt & vbLf & _
              "                            WHERE CONSULT.PERID      = CURRENTCONSULT.PERID   " & vbLf & _
              "                              AND CONSULT.CSLDATE    < CURRENTCONSULT.CSLDATE " & vbLf & _
              "                              AND CONSULT.RSVNO      = RECEIPT.RSVNO          " & vbLf & _
              "                              AND CONSULT.CSLDATE    = RECEIPT.CSLDATE        " & vbLf & _
              "                              AND CONSULT.CSCD       = COURSE_P.CSCD          "

    '今回コースと同一コースのみ対象とする条件
    If lngCourseFlg = RSLCOURSE_SAME Then
        strStmt = strStmt & vbLf & _
              "                              AND CONSULT.CSCD       = CURRENTCONSULT.CSCD "
    End If
    
    '２次検査コースを対象としない条件
    If lngSecondFlg = RSLSECOND_NONE Then
        strStmt = strStmt & vbLf & _
              "                              AND COURSE_P.SECONDFLG = 0 "
    End If
              
    strStmt = strStmt & vbLf & _
              "                              AND ROWNUM             = 1 " & vbLf & _
              "                         ) LASTRSVNO                     " & vbLf & _
              "                    FROM RSL                             " & vbLf & _
              "                   WHERE RSL.RSVNO = :RSVNO              " & vbLf & _
              "                ) BASEDRSL                               "
    
    '前回検査結果を結合
    strStmt = strStmt & vbLf & _
              "          WHERE BASEDRSL.LASTRSVNO = RSL.RSVNO(+)  " & vbLf & _
              "            AND BASEDRSL.ITEMCD    = RSL.ITEMCD(+) " & vbLf & _
              "            AND BASEDRSL.SUFFIX    = RSL.SUFFIX(+) "
    
    '検査項目情報を結合
    strStmt = strStmt & vbLf & _
              "            AND BASEDRSL.ITEMCD    = ITEM_C.ITEMCD " & vbLf & _
              "            AND BASEDRSL.SUFFIX    = ITEM_C.SUFFIX "
    
    '履歴取得に際し、受診日を取得
    strStmt = strStmt & vbLf & _
              "            AND BASEDRSL.RSVNO     = CONSULT.RSVNO "
    
    '履歴は必ずただ１件存在するものと信じ、結合を行う
    strStmt = strStmt & vbLf & _
              "            AND BASEDRSL.ITEMCD    = ITEM_H.ITEMCD  " & vbLf & _
              "            AND BASEDRSL.SUFFIX    = ITEM_H.SUFFIX  " & vbLf & _
              "            AND CONSULT.CSLDATE   >= ITEM_H.STRDATE " & vbLf & _
              "            AND CONSULT.CSLDATE   <= ITEM_H.ENDDATE " & vbLf & _
              "       ) FINALRSL                                   "
    
    '文章、コメントを結合し、検査項目昇順指定
    strStmt = strStmt & vbLf & _
              " WHERE FINALRSL.STCITEMCD   = CURRENTSENTENCE.ITEMCD(+)   " & vbLf & _
              "   AND FINALRSL.ITEMTYPE    = CURRENTSENTENCE.ITEMTYPE(+) " & vbLf & _
              "   AND FINALRSL.RESULT      = CURRENTSENTENCE.STCCD(+)    " & vbLf & _
              "   AND FINALRSL.STCITEMCD   = LASTSENTENCE.ITEMCD(+)      " & vbLf & _
              "   AND FINALRSL.ITEMTYPE    = LASTSENTENCE.ITEMTYPE(+)    " & vbLf & _
              "   AND FINALRSL.BEFRESULT   = LASTSENTENCE.STCCD(+)       " & vbLf & _
              "   AND FINALRSL.STCITEMCD   = DEFSENTENCE.ITEMCD(+)       " & vbLf & _
              "   AND FINALRSL.ITEMTYPE    = DEFSENTENCE.ITEMTYPE(+)     " & vbLf & _
              "   AND FINALRSL.DEFRESULT   = DEFSENTENCE.STCCD(+)        " & vbLf & _
              "   AND FINALRSL.RSLCMTCD1   = RSLCMT1.RSLCMTCD(+)         " & vbLf & _
              "   AND FINALRSL.RSLCMTCD2   = RSLCMT2.RSLCMTCD(+)         " & vbLf & _
              "   AND FINALRSL.DEFRSLCMTCD = DEFRSLCMT.RSLCMTCD(+)       " & vbLf & _
              "   AND FINALRSL.STDVALUECD  = STDVALUE_C.STDVALUECD(+)    " & vbLf & _
              " ORDER BY FINALRSL.ITEMCD, FINALRSL.SUFFIX                "
'## 2003.01.04 Mod End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
'## 2003.01.04 Del 1Line By T.Takagi@FSIT 東急対応
'        Set objSeq = objFields("SEQ")
'## 2003.01.04 Del End
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objShortStc = objFields("SHORTSTC")
        Set objRslCmtCd1 = objFields("RSLCMTCD1")
        Set objRslCmtName1 = objFields("RSLCMTNAME1")
        Set objRslCmtCd2 = objFields("RSLCMTCD2")
        Set objRslCmtName2 = objFields("RSLCMTNAME2")
        Set objBefResult = objFields("BEFRESULT")
        Set objBefShortStc = objFields("BEFSHORTSTC")
        Set objStdFlg = objFields("STDFLG")
'## 2003.01.04 Add 4Lines By T.Takagi@FSIT 東急対応
        Set objDefResult = objFields("DEFRESULT")
        Set objDefShortStc = objFields("DEFSHORTSTC")
        Set objDefRslCmtCd = objFields("DEFRSLCMTCD")
        Set objDefRslCmtName = objFields("DEFRSLCMTNAME")
'## 2003.01.04 Add End
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
        Set objLastRsvNo = objFields("LASTRSVNO")
'## 2003.03.03 Add End
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrConsultFlg(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrStcItemCd(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            ReDim Preserve vntArrRslCmtCd1(lngCount)
            ReDim Preserve vntArrRslCmtName1(lngCount)
            ReDim Preserve vntArrRslCmtCd2(lngCount)
            ReDim Preserve vntArrRslCmtName2(lngCount)
            ReDim Preserve vntArrBefResult(lngCount)
            ReDim Preserve vntArrBefShortStc(lngCount)
            ReDim Preserve vntArrStdFlg(lngCount)
'## 2003.01.04 Mod 5Lines By T.Takagi@FSIT 東急対応
'            vntArrSeq(lngCount) = CLng(objSeq.Value)
            ReDim Preserve vntArrDefResult(lngCount)
            ReDim Preserve vntArrDefShortStc(lngCount)
            ReDim Preserve vntArrDefRslCmtCd(lngCount)
            ReDim Preserve vntArrDefRslCmtName(lngCount)
            vntArrSeq(lngCount) = lngCount + 1
'## 2003.01.04 Mod End
            vntArrConsultFlg(lngCount) = CONSULT_ITEM_T
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrSuffix(lngCount) = objSuffix.Value
            vntArrItemName(lngCount) = objItemName.Value
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrResultType(lngCount) = objResultType.Value
            vntArrItemType(lngCount) = objItemType.Value
            vntArrStcItemCd(lngCount) = objStcItemCd.Value
            If vntArrResultType(lngCount) = RESULTTYPE_SENTENCE Then    '文章タイプのときのみ略称セット
                vntArrShortStc(lngCount) = objShortStc.Value & ""
            Else
                vntArrShortStc(lngCount) = ""
            End If
            vntArrRslCmtCd1(lngCount) = objRslCmtCd1.Value & ""
            vntArrRslCmtName1(lngCount) = objRslCmtName1.Value & ""
            vntArrRslCmtCd2(lngCount) = objRslCmtCd2.Value & ""
            vntArrRslCmtName2(lngCount) = objRslCmtName2.Value & ""
            vntArrBefResult(lngCount) = objBefResult.Value & ""
            If vntArrResultType(lngCount) = RESULTTYPE_SENTENCE Then    '文章タイプのときのみ略称セット
                vntArrBefShortStc(lngCount) = objBefShortStc.Value & ""
            Else
                vntArrBefShortStc(lngCount) = ""
            End If
            vntArrStdFlg(lngCount) = objStdFlg.Value & ""
'## 2003.01.04 Add 8Lines By T.Takagi@FSIT 東急対応
            vntArrDefResult(lngCount) = objDefResult.Value & ""
            If vntArrResultType(lngCount) = RESULTTYPE_SENTENCE Then    '文章タイプのときのみ略称セット
                vntArrDefShortStc(lngCount) = objDefShortStc.Value & ""
            Else
                vntArrDefShortStc(lngCount) = ""
            End If
            vntArrDefRslCmtCd(lngCount) = objDefRslCmtCd.Value & ""
            vntArrDefRslCmtName(lngCount) = objDefRslCmtName.Value & ""
'## 2003.01.04 Add End
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
            vntArrLastRsvNo = objLastRsvNo.Value & ""
'## 2003.03.03 Add End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntUpdItemCount = lngCount
    vntSeq = vntArrSeq
    vntConsultFlg = vntArrConsultFlg
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    vntResult = vntArrResult
    vntResultType = vntArrResultType
    vntItemType = vntArrItemType
    vntStcItemCd = vntArrStcItemCd
    vntShortStc = vntArrShortStc
    vntRslCmtCd1 = vntArrRslCmtCd1
    vntRslCmtName1 = vntArrRslCmtName1
    vntRslCmtCd2 = vntArrRslCmtCd2
    vntRslCmtName2 = vntArrRslCmtName2
    vntBefResult = vntArrBefResult
    vntBefShortStc = vntArrBefShortStc
    
    If Not IsMissing(vntStdFlg) Then vntStdFlg = vntArrStdFlg
'## 2003.01.04 Add 4Lines By T.Takagi@FSIT 東急対応
    If Not IsMissing(vntDefResult) Then vntDefResult = vntArrDefResult
    If Not IsMissing(vntDefShortStc) Then vntDefShortStc = vntArrDefShortStc
    If Not IsMissing(vntDefRslCmtCd) Then vntDefRslCmtCd = vntArrDefRslCmtCd
    If Not IsMissing(vntDefRslCmtName) Then vntDefRslCmtName = vntArrDefRslCmtName
'## 2003.01.04 Add End
'## 2003.03.03 Add 1Line By T.Takagi@FSIT 前回予約番号取得
    If Not IsMissing(vntLastRsvNo) Then vntLastRsvNo = vntArrLastRsvNo
'## 2003.03.03 Add End
    
    SelectRslAllList = lngCount
        
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objCommon = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.SelectRslAllList"
    
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
' 機能　　 : 指定対象受診者の受診グループ内検査項目を取得する
'
' 引数　　 : (In)     strPerId        個人ＩＤ
' 　　　　 : (In)     strHisCount     表示歴数
' 　　　　 : (In)     strGrpCd        グループコード
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntSuffix       サフィックス
' 　　　　 : (Out)    vntItemName     検査項目名称
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectInqHistoryItemList(ByVal strPerId As String, _
                                         ByVal strHisCount As String, _
                                         ByVal strGrpCd As String, _
                                         ByRef vntItemCd As Variant, _
                                         ByRef vntSuffix As Variant, _
                                         ByRef vntItemName As Variant _
                                        ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名称
    
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名称の配列
    
    Dim lngCount            As Long             'レコード数
    Dim lngHistoryCount     As Long             '表示歴数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '個人ＩＤが設定されていない場合はエラー
    If IsEmpty(strPerId) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
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
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CANCELFLG", CStr(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
    If lngHistoryCount > 0 Then
        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす検査結果情報のレコードを取得
    strStmt = "SELECT DISTINCT RS.ITEMCD, RS.SUFFIX, IC.ITEMNAME    " & vbLf & _
              "  FROM ( SELECT RSVNO                                " & vbLf & _
              "           FROM ( SELECT CN.RSVNO                    " & vbLf & _
              "                    FROM CONSULT CN                  " & vbLf & _
              "                   WHERE CN.PERID     = :PERID       " & vbLf & _
              "                     AND CN.CANCELFLG = :CANCELFLG   " & vbLf & _
              "                   ORDER BY CN.CSLDATE               " & vbLf & _
              "                )"
    If lngHistoryCount > 0 Then
        strStmt = strStmt & vbLf & _
              "          WHERE ROWNUM BETWEEN 1 AND :HISCOUNT       "
    End If
    strStmt = strStmt & vbLf & _
              "       ) CL, RSL RS, ITEM_C IC                       " & vbLf & _
              " WHERE CL.RSVNO = RS.RSVNO                           " & vbLf & _
              "   AND EXISTS ( SELECT GP.ITEMCD                     " & vbLf & _
              "                  FROM GRP_I GP                      " & vbLf & _
              "                 WHERE GP.GRPCD  = :GRPCD            " & vbLf & _
              "                   AND GP.ITEMCD = RS.ITEMCD         " & vbLf & _
              "                   AND GP.SUFFIX = RS.SUFFIX         " & vbLf & _
              "              )                                      " & vbLf & _
              "   AND RS.ITEMCD = IC.ITEMCD                         " & vbLf & _
              "   AND RS.SUFFIX = IC.SUFFIX                         " & vbLf & _
              " ORDER BY RS.ITEMCD, RS.SUFFIX                       "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrSuffix(lngCount) = objSuffix.Value
            vntArrItemName(lngCount) = objItemName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    
    SelectInqHistoryItemList = lngCount
        
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
    WriteErrorLog "Result.SelectInqHistoryItemList"
    
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
' 機能　　 : 指定対象受診者の検査結果を取得する
'
' 引数　　 : (In)     strPerId     個人ＩＤ
' 　　　　   (In)     dtmCslDate   受診日
' 　　　　   (In)     strHisCount  表示歴数
' 　　　　   (In)     strGrpCd     グループコード
' 　　　　   (Out)    vntRsvNo     予約番号
' 　　　　   (Out)    vntItemCd    検査項目コード
' 　　　　   (Out)    vntSuffix    サフィックス
' 　　　　   (Out)    vntResult    検査結果
' 　　　　   (Out)    vntStdFlg    基準値フラグ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
'## 2003.01.22 Mod 21Lines By T.Takagi 東急対応
'Public Function SelectInqHistoryRslList(
'    ByVal strPerId As String,
'    ByVal strHisCount As String,
'    ByVal strGrpCd As String,
'    ByRef vntRsvNo As Variant,
'    ByRef vntItemCd As Variant,
'    ByRef vntSuffix As Variant,
'    ByRef vntResult As Variant,
'    ByRef vntStdFlg As Variant
') As Long
Public Function SelectInqHistoryRslList( _
    ByVal strPerId As String, _
    ByVal dtmCslDate As Date, _
    ByVal strHisCount As String, _
    ByVal strGrpCd As String, _
    ByRef vntRsvNo As Variant, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntStdFlg As Variant _
) As Long
'## 2003.01.22 Mod End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objResult           As OraField         '検査結果
    Dim objStdFlg           As OraField         '基準値フラグ
    
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrStdFlg()      As Variant          '基準値フラグの配列
    
    Dim lngCount            As Long             'レコード数
    Dim lngHistoryCount     As Long             '表示歴数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '個人ＩＤが設定されていない場合はエラー
    If IsEmpty(strPerId) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
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
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CANCELFLG", CStr(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
    If lngHistoryCount > 0 Then
        objOraParam.Add "HISCOUNT", CStr(lngHistoryCount), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.01.22 Add 1Line By T.Takagi 東急対応
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
'## 2003.01.22 Add End
    
    '検索条件を満たす検査結果情報のレコードを取得
'    strStmt = "SELECT RSVNO, ITEMCD, SUFFIX, RESULT, STDFLG                                     " & vbLf & _
'              "  FROM ( SELECT CN.CSLDATE, CN.RSVNO, RS.ITEMCD, RS.SUFFIX, RS.RESULT, SC.STDFLG " & vbLf & _
'              "           FROM ( SELECT ROWNUM SEQ, CSLDATE, RSVNO                              " & vbLf & _
'              "                    FROM ( SELECT CN.CSLDATE, CN.RSVNO                           " & vbLf & _
'              "                             FROM CONSULT CN                                     " & vbLf & _
'              "                            WHERE CN.PERID     = :PERID                          " & vbLf & _
'              "                              AND CN.CANCELFLG = :CANCELFLG                      " & vbLf & _
'              "                            ORDER BY CN.CSLDATE DESC                             " & vbLf & _
'              "                         )                                                       " & vbLf & _
'              "                ) CN, RSL RS, STDVALUE_C SC                                      " & vbLf & _
'              "          WHERE CN.RSVNO     = RS.RSVNO                                          "
'    If lngHistoryCount > 0 Then
'        strStmt = strStmt & vbLf & _
'              "            AND CN.SEQ BETWEEN 1 AND :HISCOUNT                                   "
'    End If
'    strStmt = strStmt & vbLf & _
'              "            AND EXISTS ( SELECT GP.ITEMCD                                        " & vbLf & _
'              "                           FROM GRP_I GP                                         " & vbLf & _
'              "                          WHERE GP.GRPCD  = :GRPCD                               " & vbLf & _
'              "                            AND GP.ITEMCD = RS.ITEMCD                            " & vbLf & _
'              "                            AND GP.SUFFIX = RS.SUFFIX                            " & vbLf & _
'              "                       )                                                         " & vbLf & _
'              "            AND RS.STDVALUECD = SC.STDVALUECD(+)                                 " & vbLf & _
'              "       )                                                                         " & vbLf & _
'              " ORDER BY ITEMCD, SUFFIX, CSLDATE DESC                                           "

'## 2003.01.22 Mod 31Lines By T.Takagi 東急対応
'    strStmt = "SELECT FINALRSL.RSVNO, FINALRSL.ITEMCD, FINALRSL.SUFFIX,    " & vbLf & _
'              "       NVL(SENTENCE.SHORTSTC, FINALRSL.RESULT) RESULT,      " & vbLf & _
'              "       FINALRSL.STDFLG                                      " & vbLf & _
'              "  FROM SENTENCE,                                            " & vbLf & _
'              "       ( SELECT CN.CSLDATE, CN.RSVNO,                       " & vbLf & _
'              "                RS.ITEMCD, RS.SUFFIX, RS.RESULT, SC.STDFLG, " & vbLf & _
'              "                ITEM_C.STCITEMCD, ITEM_C.ITEMTYPE           " & vbLf & _
'              "           FROM ( SELECT ROWNUM SEQ, CSLDATE, RSVNO         " & vbLf & _
'              "                    FROM ( SELECT CN.CSLDATE, CN.RSVNO      " & vbLf & _
'              "                             FROM CONSULT CN                " & vbLf & _
'              "                            WHERE CN.PERID     = :PERID     " & vbLf & _
'              "                              AND CN.CANCELFLG = :CANCELFLG " & vbLf & _
'              "                            ORDER BY CN.CSLDATE DESC )      " & vbLf & _
'              "                ) CN, RSL RS, STDVALUE_C SC, ITEM_C         " & vbLf & _
'              "          WHERE CN.RSVNO = RS.RSVNO                         "
    strStmt = "SELECT FINALRSL.RSVNO, FINALRSL.ITEMCD, FINALRSL.SUFFIX,    " & vbLf & _
              "       NVL(SENTENCE.SHORTSTC, FINALRSL.RESULT) RESULT,      " & vbLf & _
              "       FINALRSL.STDFLG                                      " & vbLf & _
              "  FROM SENTENCE,                                            " & vbLf & _
              "       ( SELECT CN.CSLDATE, CN.RSVNO,                       " & vbLf & _
              "                RS.ITEMCD, RS.SUFFIX, RS.RESULT, SC.STDFLG, " & vbLf & _
              "                ITEM_C.STCITEMCD, ITEM_C.ITEMTYPE           " & vbLf & _
              "           FROM ( SELECT ROWNUM SEQ, CSLDATE, RSVNO         " & vbLf & _
              "                    FROM ( SELECT CN.CSLDATE, CN.RSVNO      " & vbLf & _
              "                             FROM CONSULT CN                " & vbLf & _
              "                            WHERE CN.PERID     = :PERID     " & vbLf & _
              "                              AND CN.CSLDATE  <= :CSLDATE   " & vbLf & _
              "                              AND CN.CANCELFLG = :CANCELFLG " & vbLf & _
              "                            ORDER BY CN.CSLDATE DESC )      " & vbLf & _
              "                ) CN, RSL RS, STDVALUE_C SC, ITEM_C         " & vbLf & _
              "          WHERE CN.RSVNO = RS.RSVNO                         "
    
    If lngHistoryCount > 0 Then
        strStmt = strStmt & vbLf & _
              "            AND CN.SEQ BETWEEN 1 AND :HISCOUNT "
    End If
    
    strStmt = strStmt & vbLf & _
              "            AND EXISTS ( SELECT GP.ITEMCD                " & vbLf & _
              "                           FROM GRP_I GP                 " & vbLf & _
              "                          WHERE GP.GRPCD  = :GRPCD       " & vbLf & _
              "                            AND GP.ITEMCD = RS.ITEMCD    " & vbLf & _
              "                            AND GP.SUFFIX = RS.SUFFIX )  " & vbLf & _
              "            AND RS.STDVALUECD = SC.STDVALUECD(+)         " & vbLf & _
              "            AND RS.ITEMCD = ITEM_C.ITEMCD                " & vbLf & _
              "            AND RS.SUFFIX = ITEM_C.SUFFIX                " & vbLf & _
              "       ) FINALRSL                                        " & vbLf & _
              " WHERE FINALRSL.STCITEMCD = SENTENCE.ITEMCD(+)           " & vbLf & _
              "   AND FINALRSL.ITEMTYPE  = SENTENCE.ITEMTYPE(+)         " & vbLf & _
              "   AND FINALRSL.RESULT    = SENTENCE.STCCD(+)            " & vbLf & _
              " ORDER BY FINALRSL.ITEMCD, FINALRSL.SUFFIX,              " & vbLf & _
              "          FINALRSL.CSLDATE DESC                          "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objResult = objFields("RESULT")
        Set objStdFlg = objFields("STDFLG")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrStdFlg(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrSuffix(lngCount) = objSuffix.Value
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrStdFlg(lngCount) = objStdFlg.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntRsvNo = vntArrRsvNo
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntResult = vntArrResult
    vntStdFlg = vntArrStdFlg
    
    SelectInqHistoryRslList = lngCount
        
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
    WriteErrorLog "Result.SelectInqHistoryRslList"
    
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
' 機能　　 : 指定対象受診者・検査グループの検査項目を取得する
'
' 引数　　 : (In)     vntRsvNo        予約番号
' 　　　　 : (In)     vntGrpCd        グループ（検査項目）
' 　　　　 : (Out)    vntConsultFlg   受診項目フラグ
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntSuffix       サフィックス
' 　　　　 : (Out)    vntItemName     検査項目名称
' 　　　　 : (Out)    vntResult       検査結果
' 　　　　 : (Out)    vntResultType   結果タイプ
' 　　　　 : (Out)    vntItemType     項目タイプ
' 　　　　 : (Out)    vntStcItemCd    文章参照用項目コード
' 　　　　 : (Out)    vntShortStc     文章略称
' 　　　　 : (Out)    vntStdFlg       基準値フラグ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 問診項目は検査結果に存在しなくても対象の全項目を取得する
'
Public Function SelectRslAllSetList(ByVal vntRsvNo As Variant, _
                                    ByVal vntGrpCd As Variant, _
                                    ByRef vntConsultFlg As Variant, _
                                    ByRef vntItemCd As Variant, _
                                    ByRef vntSuffix As Variant, _
                                    ByRef vntItemName As Variant, _
                                    ByRef vntResult As Variant, _
                                    ByRef vntResultType As Variant, _
                                    ByRef vntItemType As Variant, _
                                    ByRef vntStcItemCd As Variant, _
                                    ByRef vntShortStc As Variant, _
                                    Optional ByRef vntStdFlg As Variant _
                                   ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objConsultFlg       As OraField         '受診項目フラグ
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objResult           As OraField         '検査結果
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objStcItemCd        As OraField         '文章参照用項目コード
    Dim objShortStc         As OraField         '略文章
    Dim objStdFlg           As OraField         '基準値フラグ

    Dim vntArrConsultFlg()  As Variant          '受診項目フラグの配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrStcItemCd()   As Variant          '文章参照用項目コードの配列
    Dim vntArrShortStc()    As Variant          '略文章の配列
    Dim vntArrStdFlg()      As Variant          '基準値フラグの配列
    
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合はエラー
    If IsEmpty(vntRsvNo) Or IsEmpty(vntGrpCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(vntRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "GRPCD", Trim(vntGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GRPDIV", CStr(GRPDIV_I), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSLQUE_R", CStr(RSLQUE_R), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSLQUE_Q", CStr(RSLQUE_Q), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CONSULT_ITEM_T", CStr(CONSULT_ITEM_T), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CONSULT_ITEM_F", CStr(CONSULT_ITEM_F), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす検査結果情報のレコードを取得
    strStmt = "SELECT RS.CONSULTFLG, RS.ITEMCD, RS.SUFFIX, RS.ITEMNAME, RS.RESULT,              " & vbLf & _
              "       RS.RESULTTYPE, RS.ITEMTYPE, RS.STCITEMCD, SC.SHORTSTC,                    " & vbLf & _
              "       STDVALUE_C.STDFLG                                                         " & vbLf & _
              "  FROM ( SELECT IL.SEQ, IL.CONSULTFLG, IL.ITEMCD, IL.SUFFIX, IL.ITEMNAME,        " & vbLf & _
              "                RL.RESULT, IL.RESULTTYPE, IL.ITEMTYPE, IL.STCITEMCD,             " & vbLf & _
              "                RL.STDVALUECD                                                    "
    
    '検査グループ内の全検査項目で、対象受診者の検査項目を取得する
    strStmt = strStmt & vbLf & _
              "           FROM ( SELECT :CONSULT_ITEM_T CONSULTFLG, GI.SEQ, GI.ITEMCD,          " & vbLf & _
              "                          GI.SUFFIX, IC.ITEMNAME,IC.RESULTTYPE, IC.ITEMTYPE,     " & vbLf & _
              "                          IC.STCITEMCD                                           " & vbLf & _
              "                    FROM GRP_P GP, GRP_I GI, ITEM_P IP, ITEM_C IC, RSL RS        " & vbLf & _
              "                   WHERE GP.GRPCD  = :GRPCD                                      " & vbLf & _
              "                     AND GP.GRPDIV = :GRPDIV                                     " & vbLf & _
              "                     AND IP.RSLQUE = :RSLQUE_R                                   " & vbLf & _
              "                     AND RS.RSVNO  = :RSVNO                                      " & vbLf & _
              "                     AND GP.GRPCD  = GI.GRPCD                                    " & vbLf & _
              "                     AND GI.ITEMCD = IP.ITEMCD                                   " & vbLf & _
              "                     AND GI.ITEMCD = RS.ITEMCD                                   " & vbLf & _
              "                     AND GI.SUFFIX = RS.SUFFIX                                   " & vbLf & _
              "                     AND GI.ITEMCD = IC.ITEMCD                                   " & vbLf & _
              "                     AND GI.SUFFIX = IC.SUFFIX                                   " & vbLf & _
              "                  UNION                                                          "
    strStmt = strStmt & vbLf & _
              "                  SELECT :CONSULT_ITEM_F CONSULTFLG, GI.SEQ, GI.ITEMCD,          " & vbLf & _
              "                          GI.SUFFIX, IC.ITEMNAME,IC.RESULTTYPE, IC.ITEMTYPE,     " & vbLf & _
              "                          IC.STCITEMCD                                           " & vbLf & _
              "                    FROM GRP_P GP, GRP_I GI, ITEM_P IP, ITEM_C IC                " & vbLf & _
              "                   WHERE GP.GRPCD  = :GRPCD                                      " & vbLf & _
              "                     AND GP.GRPDIV = :GRPDIV                                     " & vbLf & _
              "                     AND IP.RSLQUE = :RSLQUE_R                                   " & vbLf & _
              "                     AND GP.GRPCD  = GI.GRPCD                                    " & vbLf & _
              "                     AND GI.ITEMCD = IP.ITEMCD                                   " & vbLf & _
              "                     AND GI.ITEMCD = IC.ITEMCD                                   " & vbLf & _
              "                     AND GI.SUFFIX = IC.SUFFIX                                   " & vbLf & _
              "                     AND NOT EXISTS ( SELECT RS.ITEMCD                           " & vbLf & _
              "                                        FROM RSL RS                              " & vbLf & _
              "                                       WHERE RS.RSVNO  = :RSVNO                  " & vbLf & _
              "                                         AND RS.ITEMCD = IC.ITEMCD               " & vbLf & _
              "                                         AND RS.SUFFIX = IC.SUFFIX               " & vbLf & _
              "                                    )                                            " & vbLf & _
              "                  UNION                                                          "
    '検査グループ内の全問診項目を取得する
    strStmt = strStmt & vbLf & _
              "                  SELECT :CONSULT_ITEM_T CONSULTFLG, GI.SEQ, GI.ITEMCD,          " & vbLf & _
              "                          GI.SUFFIX, IC.ITEMNAME,IC.RESULTTYPE, IC.ITEMTYPE,     " & vbLf & _
              "                          IC.STCITEMCD                                           " & vbLf & _
              "                    FROM GRP_P GP, GRP_I GI, ITEM_P IP, ITEM_C IC                " & vbLf & _
              "                   WHERE GP.GRPCD  = :GRPCD                                      " & vbLf & _
              "                     AND GP.GRPDIV = :GRPDIV                                     " & vbLf & _
              "                     AND IP.RSLQUE = :RSLQUE_Q                                   " & vbLf & _
              "                     AND GP.GRPCD  = GI.GRPCD                                    " & vbLf & _
              "                     AND GI.ITEMCD = IP.ITEMCD                                   " & vbLf & _
              "                     AND GI.ITEMCD = IC.ITEMCD                                   " & vbLf & _
              "                     AND GI.SUFFIX = IC.SUFFIX                                   " & vbLf & _
              "                ) IL,"
    '対象受診者の全検査項目を取得する
    strStmt = strStmt & vbLf & _
              "                ( SELECT RS.ITEMCD, RS.SUFFIX, RS.RESULT, RS.STDVALUECD          " & vbLf & _
              "                    FROM RSL RS                                                  " & vbLf & _
              "                   WHERE RS.RSVNO = :RSVNO                                       " & vbLf & _
              "                ) RL                                                             "
    strStmt = strStmt & vbLf & _
              "          WHERE IL.ITEMCD = RL.ITEMCD(+)                                         " & vbLf & _
              "            AND IL.SUFFIX = RL.SUFFIX(+)                                         " & vbLf & _
              "       ) RS, SENTENCE SC, STDVALUE_C                                             " & vbLf & _
              " WHERE RS.STCITEMCD  = SC.ITEMCD(+)                                              " & vbLf & _
              "   AND RS.ITEMTYPE   = SC.ITEMTYPE(+)                                            " & vbLf & _
              "   AND RS.RESULT     = SC.STCCD(+)                                               " & vbLf & _
              "   AND RS.STDVALUECD = STDVALUE_C.STDVALUECD(+)                                  " & vbLf & _
              " ORDER BY RS.SEQ                                                                 "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objConsultFlg = objFields("CONSULTFLG")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objResult = objFields("RESULT")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objStcItemCd = objFields("STCITEMCD")
        Set objShortStc = objFields("SHORTSTC")
        Set objStdFlg = objFields("STDFLG")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrConsultFlg(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrStcItemCd(lngCount)
            ReDim Preserve vntArrShortStc(lngCount)
            ReDim Preserve vntArrStdFlg(lngCount)
            vntArrConsultFlg(lngCount) = CLng(objConsultFlg.Value)
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrSuffix(lngCount) = objSuffix.Value
            vntArrItemName(lngCount) = objItemName.Value
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrResultType(lngCount) = objResultType.Value
            vntArrItemType(lngCount) = objItemType.Value
            vntArrStcItemCd(lngCount) = objStcItemCd.Value
            If vntArrResultType(lngCount) = RESULTTYPE_SENTENCE Then    '文章タイプのときのみ略称セット
                vntArrShortStc(lngCount) = objShortStc.Value & ""
            Else
                vntArrShortStc(lngCount) = ""
            End If
            vntArrStdFlg(lngCount) = objStdFlg.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntConsultFlg = vntArrConsultFlg
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    vntResult = vntArrResult
    vntResultType = vntArrResultType
    vntItemType = vntArrItemType
    vntStcItemCd = vntArrStcItemCd
    vntShortStc = vntArrShortStc
    
    If Not IsMissing(vntStdFlg) Then
        vntStdFlg = vntArrStdFlg
    End If
    
    SelectRslAllSetList = lngCount
        
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
    WriteErrorLog "Result.SelectRslAllSetList"
    
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
' 機能　　 : 指定対象受診者・検査グループの検査項目を取得する
'
' 引数　　 : (In)     vntRsvNo        予約番号
' 　　　　 : (In)     vntGrpCd        グループ（検査項目）
' 　　　　 : (Out)    vntRslRsvNo     検査結果予約番号（検査項目ごと）
' 　　　　 : (Out)    vntItemCd       検査項目コード
' 　　　　 : (Out)    vntSuffix       サフィックス
' 　　　　 : (Out)    vntItemName     検査項目名称
' 　　　　 : (Out)    vntResult       検査結果
' 　　　　 : (Out)    vntStdFlg       基準値フラグ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 問診項目は検査結果に存在しなくても対象の全項目を取得する
'
Public Function SelectRslListSet(ByVal vntRsvNo As Variant, _
                                 ByVal vntLastName As Variant, _
                                 ByVal vntFirstName As Variant, _
                                 ByVal strGrpCd As String, _
                                 ByRef vntUpdItemCount As Variant, _
                                 ByRef vntRslRsvNo As Variant, _
                                 ByRef vntRslLastName As Variant, _
                                 ByRef vntRslFirstName As Variant, _
                                 ByRef vntConsultFlg As Variant, _
                                 ByRef vntItemCd As Variant, _
                                 ByRef vntSuffix As Variant, _
                                 ByRef vntItemName As Variant, _
                                 ByRef vntResult As Variant, _
                                 ByRef vntResultType As Variant, _
                                 Optional ByRef vntStdFlg As Variant _
                                ) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objConsultFlg           As OraField         '受診項目フラグ
    Dim objItemCd               As OraField         '検査項目コード
    Dim objSuffix               As OraField         'サフィックス
    Dim objItemName             As OraField         '検査項目名
    Dim objResult               As OraField         '検査結果
    Dim objResultType           As OraField         '結果タイプ
    Dim objStdFlg               As OraField         '基準値フラグ

    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrLastName()        As Variant          '姓の配列
    Dim vntArrFirstName()       As Variant          '名の配列
    Dim vntArrRslRsvNo()        As Variant          '検査結果・予約番号の配列
    Dim vntArrRslLastName()     As Variant          '検査結果・姓の配列
    Dim vntArrRslFirstName()    As Variant          '検査結果・名の配列
    Dim vntArrConsultFlg()      As Variant          '受診項目フラグの配列
    Dim vntArrItemCd()          As Variant          '検査項目コードの配列
    Dim vntArrSuffix()          As Variant          'サフィックスの配列
    Dim vntArrItemName()        As Variant          '検査項目名の配列
    Dim vntArrResult()          As Variant          '検査結果の配列
    Dim vntArrResultType()      As Variant          '結果タイプの配列
    Dim vntArrStdFlg()          As Variant          '基準値フラグの配列
    
    Dim lngArraySize            As Long             '配列数
    
    Dim lngCount                As Long             'レコード数
    Dim lngUpdItemCount         As Long             '更新項目件数
    
    Dim i                       As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合はエラー
    If IsEmpty(vntRsvNo) Or IsEmpty(strGrpCd) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    '予約番号が配列の場合
    If IsArray(vntRsvNo) Then
        '姓・名が配列でない場合は処理終了
        If Not IsArray(vntLastName) Or _
           Not IsArray(vntFirstName) Then
            Err.Raise 9 '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        '予約番号・姓・名のサイズが一致しない場合は処理終了
        If UBound(vntRsvNo) <> UBound(vntLastName) Or _
           UBound(vntRsvNo) <> UBound(vntFirstName) Then
            Err.Raise 9 '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        vntArrRsvNo = vntRsvNo
        vntArrLastName = vntLastName
        vntArrFirstName = vntFirstName
    Else
        '姓・名が配列の場合は処理終了
        If IsArray(vntLastName) Or _
           IsArray(vntFirstName) Then
            Err.Raise 9 '「インデックスが有効範囲にありません。」
            Exit Function
        End If
        vntArrRsvNo = Array(vntRsvNo)
        vntArrLastName = Array(vntLastName)
        vntArrFirstName = Array(vntFirstName)
    End If
    
    '配列数
    lngArraySize = UBound(vntArrRsvNo) + 1
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GRPCD", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GRPDIV", CStr(GRPDIV_I), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSLQUE_R", CStr(RSLQUE_R), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSLQUE_Q", CStr(RSLQUE_Q), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CONSULT_ITEM_T", CStr(CONSULT_ITEM_T), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CONSULT_ITEM_F", CStr(CONSULT_ITEM_F), ORAPARM_INPUT, ORATYPE_NUMBER
    
    lngCount = 0
    For i = 0 To lngArraySize - 1
        'キー値の設定
        objOraParam.Add "RSVNO", Trim(vntArrRsvNo(i)), ORAPARM_INPUT, ORATYPE_NUMBER
    
'        '検索条件を満たす検査結果情報のレコードを取得
'        strStmt = "SELECT ITEMCD, SUFFIX, ITEMNAME, RESULT, RESULTTYPE                  "
'        '検査グループ内の全検査項目で、対象受診者の検査項目を取得する
'        '受診項目
'        strStmt = strStmt & vbLf & _
'                  "  FROM ( SELECT GP.SEQ, RS.ITEMCD, RS.SUFFIX, IC.ITEMNAME, RS.RESULT," & vbLf & _
'                  "                IC.RESULTTYPE                                        " & vbLf & _
'                  "           FROM RSL RS, GRP_I GP, ITEM_P IP, ITEM_C IC               " & vbLf & _
'                  "          WHERE GP.GRPCD  = :GRPCD                                   " & vbLf & _
'                  "            AND IP.RSLQUE = :RSLQUE_R                                " & vbLf & _
'                  "            AND RS.RSVNO  = :RSVNO                                   " & vbLf & _
'                  "            AND RS.ITEMCD = GP.ITEMCD                                " & vbLf & _
'                  "            AND RS.SUFFIX = GP.SUFFIX                                " & vbLf & _
'                  "            AND GP.ITEMCD = IP.ITEMCD                                " & vbLf & _
'                  "            AND GP.ITEMCD = IC.ITEMCD                                " & vbLf & _
'                  "            AND GP.SUFFIX = IC.SUFFIX                                " & vbLf & _
'                  "         UNION                                                       "
'        '非受診項目
'        strStmt = strStmt & vbLf & _
'                  "         SELECT GP.SEQ, RS.ITEMCD, RS.SUFFIX, IC.ITEMNAME, RS.RESULT," & vbLf & _
'                  "                IC.RESULTTYPE                                        " & vbLf & _
'                  "           FROM RSL RS, GRP_I GP, ITEM_P IP, ITEM_C IC               " & vbLf & _
'                  "          WHERE GP.GRPCD  = :GRPCD                                   " & vbLf & _
'                  "            AND IP.RSLQUE = :RSLQUE_R                                " & vbLf & _
'                  "            AND RS.RSVNO  = :RSVNO                                   " & vbLf & _
'                  "            AND RS.ITEMCD = GP.ITEMCD                                " & vbLf & _
'                  "            AND RS.SUFFIX = GP.SUFFIX                                " & vbLf & _
'                  "            AND GP.ITEMCD = IP.ITEMCD                                " & vbLf & _
'                  "            AND GP.ITEMCD = IC.ITEMCD                                " & vbLf & _
'                  "            AND GP.SUFFIX = IC.SUFFIX                                " & vbLf & _
'                  "         UNION                                                       "
'        '検査グループ内の全問診項目を取得する
'        strStmt = strStmt & vbLf & _
'                  "         SELECT GP.SEQ, GP.ITEMCD, GP.SUFFIX, IC.ITEMNAME, RS.RESULT," & vbLf & _
'                  "                IC.RESULTTYPE                                        " & vbLf & _
'                  "           FROM ( SELECT RL.RSVNO, RL.ITEMCD, RL.SUFFIX, RL.RESULT   " & vbLf & _
'                  "                    FROM RSL RL                                      " & vbLf & _
'                  "                   WHERE RL.RSVNO = :RSVNO                           " & vbLf & _
'                  "                ) RS, GRP_I GP, ITEM_P IP, ITEM_C IC                 " & vbLf & _
'                  "          WHERE GP.GRPCD  = :GRPCD                                   " & vbLf & _
'                  "            AND IP.RSLQUE = :RSLQUE_Q                                " & vbLf & _
'                  "            AND GP.ITEMCD = IP.ITEMCD                                " & vbLf & _
'                  "            AND GP.ITEMCD = IC.ITEMCD                                " & vbLf & _
'                  "            AND GP.SUFFIX = IC.SUFFIX                                " & vbLf & _
'                  "            AND IC.ITEMCD = RS.ITEMCD(+)                             " & vbLf & _
'                  "            AND IC.SUFFIX = RS.SUFFIX(+)                             " & vbLf & _
'                  "       )                                                             " & vbLf & _
'                  " ORDER BY SEQ                                                        "

        '検索条件を満たす検査結果情報のレコードを取得
        strStmt = "SELECT IL.CONSULTFLG, IL.ITEMCD, IL.SUFFIX, IL.ITEMNAME,         " & vbLf & _
                  "       RL.RESULT, IL.RESULTTYPE, RL.STDFLG                       "
        '検査グループ内の全検査項目で、対象受診者の検査項目を取得する
        '（受診項目）
        strStmt = strStmt & vbLf & _
                  "  FROM ( SELECT :CONSULT_ITEM_T CONSULTFLG, GI.SEQ, GI.ITEMCD,   " & vbLf & _
                  "                GI.SUFFIX, IC.ITEMNAME, IC.RESULTTYPE            " & vbLf & _
                  "           FROM GRP_P GP, GRP_I GI, ITEM_P IP, ITEM_C IC, RSL RS " & vbLf & _
                  "          WHERE GP.GRPCD  = :GRPCD                               " & vbLf & _
                  "            AND GP.GRPDIV = :GRPDIV                              " & vbLf & _
                  "            AND IP.RSLQUE = :RSLQUE_R                            " & vbLf & _
                  "            AND RS.RSVNO  = :RSVNO                               " & vbLf & _
                  "            AND GP.GRPCD  = GI.GRPCD                             " & vbLf & _
                  "            AND GI.ITEMCD = IP.ITEMCD                            " & vbLf & _
                  "            AND GI.ITEMCD = RS.ITEMCD                            " & vbLf & _
                  "            AND GI.SUFFIX = RS.SUFFIX                            " & vbLf & _
                  "            AND GI.ITEMCD = IC.ITEMCD                            " & vbLf & _
                  "            AND GI.SUFFIX = IC.SUFFIX                            " & vbLf & _
                  "         UNION                                                   "
        strStmt = strStmt & vbLf & _
                  "         SELECT :CONSULT_ITEM_F CONSULTFLG, GI.SEQ, GI.ITEMCD,   " & vbLf & _
                  "                GI.SUFFIX, IC.ITEMNAME, IC.RESULTTYPE            " & vbLf & _
                  "           FROM GRP_P GP, GRP_I GI, ITEM_P IP, ITEM_C IC         " & vbLf & _
                  "          WHERE GP.GRPCD  = :GRPCD                               " & vbLf & _
                  "            AND GP.GRPDIV = :GRPDIV                              " & vbLf & _
                  "            AND IP.RSLQUE = :RSLQUE_R                            " & vbLf & _
                  "            AND GP.GRPCD  = GI.GRPCD                             " & vbLf & _
                  "            AND GI.ITEMCD = IP.ITEMCD                            " & vbLf & _
                  "            AND GI.ITEMCD = IC.ITEMCD                            " & vbLf & _
                  "            AND GI.SUFFIX = IC.SUFFIX                            " & vbLf & _
                  "            AND NOT EXISTS ( SELECT RS.ITEMCD                    " & vbLf & _
                  "                               FROM RSL RS                       " & vbLf & _
                  "                              WHERE RS.RSVNO  = :RSVNO           " & vbLf & _
                  "                                AND RS.ITEMCD = IC.ITEMCD        " & vbLf & _
                  "                                AND RS.SUFFIX = IC.SUFFIX        " & vbLf & _
                  "                           )                                     " & vbLf & _
                  "         UNION                                                   "
        '検査グループ内の全問診項目を取得する
        strStmt = strStmt & vbLf & _
                  "         SELECT :CONSULT_ITEM_T CONSULTFLG, GI.SEQ, GI.ITEMCD,   " & vbLf & _
                  "                GI.SUFFIX, IC.ITEMNAME, IC.RESULTTYPE            " & vbLf & _
                  "           FROM GRP_P GP, GRP_I GI, ITEM_P IP, ITEM_C IC         " & vbLf & _
                  "          WHERE GP.GRPCD  = :GRPCD                               " & vbLf & _
                  "            AND GP.GRPDIV = :GRPDIV                              " & vbLf & _
                  "            AND IP.RSLQUE = :RSLQUE_Q                            " & vbLf & _
                  "            AND GP.GRPCD  = GI.GRPCD                             " & vbLf & _
                  "            AND GI.ITEMCD = IP.ITEMCD                            " & vbLf & _
                  "            AND GI.ITEMCD = IC.ITEMCD                            " & vbLf & _
                  "            AND GI.SUFFIX = IC.SUFFIX                            " & vbLf & _
                  "       ) IL,                                                     "
        '対象受診者の全検査項目を取得する
        strStmt = strStmt & vbLf & _
                  "       ( SELECT RS.ITEMCD, RS.SUFFIX, RS.RESULT,                 " & vbLf & _
                  "                STDVALUE_C.STDFLG                                " & vbLf & _
                  "           FROM STDVALUE_C, RSL RS                               " & vbLf & _
                  "          WHERE RS.RSVNO      = :RSVNO                           " & vbLf & _
                  "            AND RS.STDVALUECD = STDVALUE_C.STDVALUECD(+)         " & vbLf & _
                  "       ) RL                                                      "
        strStmt = strStmt & vbLf & _
                  " WHERE IL.ITEMCD = RL.ITEMCD(+)                                  " & vbLf & _
                  "   AND IL.SUFFIX = RL.SUFFIX(+)                                  " & vbLf & _
                  " ORDER BY IL.SEQ, IL.ITEMCD, IL.SUFFIX                           "
        
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
        '検索レコードが存在する場合
        If Not objOraDyna.EOF Then
        
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objConsultFlg = objFields("CONSULTFLG")
            Set objItemCd = objFields("ITEMCD")
            Set objSuffix = objFields("SUFFIX")
            Set objItemName = objFields("ITEMNAME")
            Set objResult = objFields("RESULT")
            Set objResultType = objFields("RESULTTYPE")
            Set objStdFlg = objFields("STDFLG")
        
            '配列形式で格納する
            Do Until objOraDyna.EOF
                ReDim Preserve vntArrRslRsvNo(lngCount)
                ReDim Preserve vntArrRslLastName(lngCount)
                ReDim Preserve vntArrRslFirstName(lngCount)
                ReDim Preserve vntArrConsultFlg(lngCount)
                ReDim Preserve vntArrItemCd(lngCount)
                ReDim Preserve vntArrSuffix(lngCount)
                ReDim Preserve vntArrItemName(lngCount)
                ReDim Preserve vntArrResult(lngCount)
                ReDim Preserve vntArrResultType(lngCount)
                ReDim Preserve vntArrStdFlg(lngCount)
                vntArrRslRsvNo(lngCount) = vntArrRsvNo(i)
                vntArrRslLastName(lngCount) = vntArrLastName(i)
                vntArrRslFirstName(lngCount) = vntArrFirstName(i)
                vntArrConsultFlg(lngCount) = CLng(objConsultFlg.Value)
                If CLng(objConsultFlg.Value) = CONSULT_ITEM_T Then  '更新可能項目数カウント
                    lngUpdItemCount = lngUpdItemCount + 1
                End If
                vntArrItemCd(lngCount) = objItemCd.Value
                vntArrSuffix(lngCount) = objSuffix.Value
                vntArrItemName(lngCount) = objItemName.Value
                vntArrResult(lngCount) = objResult.Value & ""
                vntArrResultType(lngCount) = objResultType.Value
                vntArrStdFlg(lngCount) = objStdFlg.Value & ""
                objOraDyna.MoveNext
                lngCount = lngCount + 1
            Loop
        
        End If
    
        Set objOraDyna = Nothing
        
        'キー値の設定解除
        objOraParam.Remove "RSVNO"
    
    Next i
    
    '戻り値の設定
    vntUpdItemCount = lngUpdItemCount
    vntRslRsvNo = vntArrRslRsvNo
    vntRslLastName = vntArrRslLastName
    vntRslFirstName = vntArrRslFirstName
    vntConsultFlg = vntArrConsultFlg
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntItemName = vntArrItemName
    vntResult = vntArrResult
    vntResultType = vntArrResultType
    
    If Not IsMissing(vntStdFlg) Then
        vntStdFlg = vntArrStdFlg
    End If
    
    SelectRslListSet = lngCount
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.SelectRslListSet"
    
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
' 機能　　 : 結果一括更新
'
' 引数　　 : (In)     strUpdUser         更新者
' 　　　　   (In)     strIpAddress       ＩＰアドレス
' 　　　　   (In)     strAllResultClear  全ての結果をクリア
' 　　　　   (In)     strOverWrite       結果を上書き
' 　　　　   (In)     vntRsvNo           予約番号
' 　　　　   (In)     vntItemCd          検査項目コード
' 　　　　   (In)     vntSuffix          サフィックス
' 　　　　   (In)     vntResult          検査結果
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub UpdateResultAll( _
    ByVal strUpdUser As String, _
    ByVal strIpAddress As String, _
    ByVal strAllResultClear As String, _
    ByVal strOverWrite As String, _
    ByRef vntRsvNo As Variant, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant _
)

    Dim objConsult      As Object           '受診情報アクセス用
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objItemCd       As OraParamArray    '検査項目コード
    Dim objSuffix       As OraParamArray    'サフィックス
    Dim objResult       As OraParamArray    '検査結果
    Dim objRsvNo        As OraParamArray    '予約番号
    
    Dim vntArrItemCd()  As Variant          '検査項目コード
    Dim vntArrSuffix()  As Variant          'サフィックス
    Dim vntArrResult()  As Variant          '検査結果
    Dim lngUpdCount     As Long             '更新項目数

    Dim blnOverWrite    As Boolean          '上書きフラグ
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '結果クリアを行わない場合
    If strAllResultClear = "" Then

        '結果の存在する項目のみを更新対象とする
        For i = 0 To UBound(vntItemCd)
            If vntItemCd(i) <> "" Then
                ReDim Preserve vntArrItemCd(lngUpdCount)
                ReDim Preserve vntArrSuffix(lngUpdCount)
                ReDim Preserve vntArrResult(lngUpdCount)
                vntArrItemCd(lngUpdCount) = vntItemCd(i)
                vntArrSuffix(lngUpdCount) = vntSuffix(i)
                vntArrResult(lngUpdCount) = vntResult(i)
                lngUpdCount = lngUpdCount + 1
            End If
        Next i

        '上書きフラグの設定
        blnOverWrite = (strOverWrite <> "")
        
    '結果クリアを行う場合
    Else
            
        '検査項目コードは引数値をそのまま使用する
        vntArrItemCd = vntItemCd
        vntArrSuffix = vntSuffix
        lngUpdCount = UBound(vntArrItemCd) + 1
            
        '検査結果は検査項目コードと同一要素数の空の配列を作成する
        ReDim Preserve vntArrResult(lngUpdCount - 1)
        
        '上書きフラグは常に上書きとする
        blnOverWrite = True
        
    End If
        
    Do
        
        '更新項目が存在しなければ何もしない
        If lngUpdCount <= 0 Then
            Exit Do
        End If
    
        'バインド配列の定義
        objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngUpdCount, LENGTH_ITEM_P_ITEMCD
        objOraParam.AddTable "SUFFIX", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngUpdCount, LENGTH_ITEM_C_SUFFIX
'        objOraParam.AddTable "RESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngUpdCount, LENGTH_RSL_RESULT
        objOraParam.AddTable "RESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngUpdCount, 400
    
        'OraParameterオブジェクトの参照設定
        Set objItemCd = objOraParam("ITEMCD")
        Set objSuffix = objOraParam("SUFFIX")
        Set objResult = objOraParam("RESULT")
    
        '更新値の編集
        For i = 0 To lngUpdCount - 1
            objItemCd(i) = CStr(vntArrItemCd(i))
            objSuffix(i) = CStr(vntArrSuffix(i))
            objResult(i) = CStr(vntArrResult(i))
        Next i
    
        'バインド配列の定義
        objOraParam.AddTable "RSVNO", ORAPARM_INPUT, ORATYPE_NUMBER, UBound(vntRsvNo) + 1
        
        'OraParameterオブジェクトの参照設定
        Set objRsvNo = objOraParam("RSVNO")
        
        '更新値の編集
        For i = 0 To UBound(vntRsvNo)
            objRsvNo(i) = CLng(vntRsvNo(i))
        Next i
        
        '上書きフラグの設定
        objOraParam.Add "OVERWRITE", IIf(blnOverWrite, 1, 0), ORAPARM_INPUT, ORATYPE_NUMBER
        
        '結果更新用ストアド呼び出し
        strStmt = "BEGIN ResultPackage.UpdateResultAll(:RSVNO, :IPADDRESS, :UPDUSER, :ITEMCD, :SUFFIX, :RESULT, :OVERWRITE); END;"
        mobjOraDb.ExecuteSQL strStmt
        
        Exit Do
    Loop
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Sub
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.UpdateResultAll"
    
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
    
End Sub

'
' 機能　　 : 検査結果テーブルを更新する
'
' 引数　　 : (In)     lngRsvNo      予約番号
' 　　　　   (In)     strIpAddress  ＩＰアドレス
' 　　　　   (In)     strUpdUser    更新者
' 　　　　   (In)     vntItemCd     検査項目コード
' 　　　　   (In)     vntSuffix     サフィックス
' 　　　　   (In)     vntResult     検査結果
' 　　　　   (In)     vntRslCmtCd1  結果コメント１
' 　　　　   (In)     vntRslCmtCd2  結果コメント２
' 　　　　   (Out)    vntMessage    メッセージ
' 　　　　   (In)     vntStopFlg    検査中止フラグ
' 　　　　   (In)     blnSkipNoRec  真の場合は依頼のない検査項目をスキップ(中止フラグつき更新のみ有効)
'
' 戻り値　 : True   正常終了
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Public Function UpdateResult( _
    ByVal lngRsvNo As Long, _
    ByVal strIpAddress As String, _
    ByVal strUpdUser As String, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    Optional ByRef vntResult As Variant, _
    Optional ByRef vntRslCmtCd1 As Variant, _
    Optional ByRef vntRslCmtCd2 As Variant, _
    Optional ByRef vntMessage As Variant, _
    Optional ByRef vntStopFlg As Variant, _
    Optional ByVal blnSkipNoRec As Boolean = False _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objItemCd           As OraParamArray    '検査項目コード
    Dim objSuffix           As OraParamArray    'サフィックス
    Dim objResult           As OraParamArray    '検査結果
    Dim objRslCmtCd1        As OraParamArray    '結果コメントコード１
    Dim objRslCmtCd2        As OraParamArray    '結果コメントコード２
    Dim objStopFlg          As OraParamArray    '検査中止フラグ
    Dim objMessage          As OraParamArray    'メッセージ
    
    Dim vntArrMessage()     As Variant          'メッセージ
    Dim lngMsgCount         As Long             'メッセージ数
    
    Dim lngArraySize        As Long             '配列の要素数
    Dim Ret                 As Boolean          '関数戻り値
    Dim Ret2                As Long             '関数戻り値
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntMessage) Then vntMessage = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    lngArraySize = UBound(vntItemCd) + 1
    objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_P_ITEMCD
    objOraParam.AddTable "SUFFIX", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_C_SUFFIX
'    objOraParam.AddTable "RESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSL_RESULT
    objOraParam.AddTable "RESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 400
    objOraParam.AddTable "RSLCMTCD1", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "RSLCMTCD2", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "STOPFLG", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 1
    objOraParam.AddTable "MESSAGE", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, 100, 256
    
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    'OraParameterオブジェクトの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    Set objSuffix = objOraParam("SUFFIX")
    Set objResult = objOraParam("RESULT")
    Set objRslCmtCd1 = objOraParam("RSLCMTCD1")
    Set objRslCmtCd2 = objOraParam("RSLCMTCD2")
    Set objStopFlg = objOraParam("STOPFLG")
    Set objMessage = objOraParam("MESSAGE")
    
    '更新値の編集
    For i = 0 To lngArraySize - 1
        
        objItemCd(i) = CStr(vntItemCd(i))
        objSuffix(i) = CStr(vntSuffix(i))
        
        If Not IsMissing(vntResult) Then
            objResult(i) = CStr(vntResult(i))
        Else
            objResult(i) = ""
        End If
        
        If Not IsMissing(vntRslCmtCd1) Then
            objRslCmtCd1(i) = CStr(vntRslCmtCd1(i))
        Else
            objRslCmtCd1(i) = ""
        End If
        
        If Not IsMissing(vntRslCmtCd2) Then
            objRslCmtCd2(i) = CStr(vntRslCmtCd2(i))
        Else
            objRslCmtCd2(i) = ""
        End If
        
        If Not IsMissing(vntStopFlg) Then
            objStopFlg(i) = CStr(vntStopFlg(i))
        Else
            objStopFlg(i) = ""
        End If
        
    Next i
    
    '結果更新用ストアド呼び出し
    
    If IsMissing(vntStopFlg) Then
    
        '検査中止フラグ未指定時は通常の更新ストアドを呼び出す
        strStmt = "BEGIN :RET := ResultPackage.UpdateResult(:RSVNO, :IPADDRESS, :UPDUSER, :ITEMCD, :SUFFIX, :RESULT, :RSLCMTCD1, :RSLCMTCD2, :MESSAGE); END;"
    
    '検査中止フラグ指定時
    Else
    
        '各項目の更新要否等を設定
        objOraParam.Add "UPDRESULT", IIf(IsMissing(vntResult), 0, 1), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "UPDRSLCMT1", IIf(IsMissing(vntRslCmtCd1), 0, 1), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "UPDRSLCMT2", IIf(IsMissing(vntRslCmtCd2), 0, 1), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SKIPNOREC", IIf(blnSkipNoRec, 1, 0), ORAPARM_INPUT, ORATYPE_NUMBER
        
        '検査中止フラグ付き結果更新ストアド呼び出し
        strStmt = "BEGIN :RET := ResultPackage.UpdateResultForStop(:RSVNO, :IPADDRESS, :UPDUSER, :ITEMCD, :SUFFIX, :RESULT, :RSLCMTCD1, :RSLCMTCD2, :STOPFLG, :MESSAGE, :UPDRESULT, :UPDRSLCMT1, :UPDRSLCMT2, :SKIPNOREC); END;"
    
    End If
    
    mobjOraDb.ExecuteSQL strStmt
    
    '戻り値の取得
    Ret2 = CLng(objOraParam("RET").Value)
    
    Ret = True
        
    'チェックエラー時
    If Ret2 <= 0 Then
    
        If Not IsMissing(vntMessage) Then
        
            'バインド配列内容を検索し、メッセージを取得
            Do Until lngMsgCount >= objMessage.ArraySize
                
                'メッセージが格納されていなければここで終了
                If objMessage(lngMsgCount) = "" Then
                    Exit Do
                End If
                
                '配列形式で格納する
                ReDim Preserve vntArrMessage(lngMsgCount)
                vntArrMessage(lngMsgCount) = CStr(objMessage(lngMsgCount))
                lngMsgCount = lngMsgCount + 1
            
            Loop
        
            '戻り値の設定(エラー時のメッセージ)
            vntMessage = vntArrMessage
        
        End If
        
        Ret = False
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateResult = Ret
    
    'トランザクション制御
    If Ret Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    Exit Function
    
ErrorHandle:

    UpdateResult = False
    
    'イベントログ書き込み
    WriteErrorLog "Result.UpdateResult"
    
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
' 機能　　 : 検査結果テーブルを更新する
'
' 引数　　 : (In)     lngRsvNo         予約番号
' 　　　　   (In)     strIpAddress     ＩＰアドレス
' 　　　　   (In)     strUpdUser       更新者
' 　　　　   (In)     vntItemCd        検査項目コード
' 　　　　   (In)     vntSuffix        サフィックス
' 　　　　   (In/Out) vntResult        検査結果
' 　　　　   (Out)    vntShortStc      略文章
' 　　　　   (Out)    vntResultError   結果チェックエラーコード
' 　　　　   (In/Out) vntRslCmtCd1     結果コメント１
' 　　　　   (Out)    vntRslCmtName1   結果コメント名１
' 　　　　   (Out)    vntRslCmtError1  結果コメント１チェックエラーコード
' 　　　　   (In/Out) vntRslCmtCd2     結果コメント２
' 　　　　   (Out)    vntRslCmtName2   結果コメント名２
' 　　　　   (Out)    vntRslCmtError2  結果コメント２チェックエラーコード
' 　　　　   (Out)    vntMessage       メッセージ
'
' 戻り値　 : True   正常終了
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Public Function UpdateResultForDetail( _
    ByVal lngRsvNo As Long, _
    ByVal strIpAddress As String, _
    ByVal strUpdUser As String, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntShortStc As Variant, _
    ByRef vntResultError As Variant, _
    ByRef vntRslCmtCd1 As Variant, _
    ByRef vntRslCmtName1 As Variant, _
    ByRef vntRslCmtError1 As Variant, _
    ByRef vntRslCmtCd2 As Variant, _
    ByRef vntRslCmtName2 As Variant, _
    ByRef vntRslCmtError2 As Variant, _
    ByRef vntMessage As Variant _
) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objItemCd               As OraParamArray    '検査項目コード
    Dim objSuffix               As OraParamArray    'サフィックス
    Dim objResult               As OraParamArray    '検査結果
    Dim objShortStc             As OraParamArray    '略文章
    Dim objResultError          As OraParamArray    '結果チェックエラーコード
    Dim objRslCmtCd1            As OraParamArray    '結果コメントコード１
    Dim objRslCmtName1          As OraParamArray    '結果コメント名称１
    Dim objRslCmtError1         As OraParamArray    '結果コメントチェック１エラーコード
    Dim objRslCmtCd2            As OraParamArray    '結果コメントコード２
    Dim objRslCmtName2          As OraParamArray    '結果コメント名称２
    Dim objRslCmtError2         As OraParamArray    '結果コメントチェック２エラーコード
    Dim objMessage              As OraParamArray    'メッセージ
    
    Dim vntArrResult()          As Variant          '検査結果
    Dim vntArrShortStc()        As Variant          '略文章
    Dim vntArrResultError()     As Variant          '結果チェックエラーコード
    Dim vntArrRslCmtCd1()       As Variant          '結果コメントコード１
    Dim vntArrRslCmtName1()     As Variant          '結果コメント名１
    Dim vntArrRslCmtError1()    As Variant          '結果コメント１チェックエラーコード
    Dim vntArrRslCmtCd2()       As Variant          '結果コメントコード２
    Dim vntArrRslCmtName2()     As Variant          '結果コメント名２
    Dim vntArrRslCmtError2()    As Variant          '結果コメント２チェックエラーコード
    Dim lngCount                As Long             'レコード数
    
    Dim vntArrMessage()         As Variant          'メッセージ
    Dim lngMsgCount             As Long             'メッセージ数
    
    Dim lngArraySize            As Long             '配列の要素数
    Dim Ret                     As Boolean          '関数戻り値
    Dim Ret2                    As Long             '関数戻り値
    Dim i                       As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntShortStc = Empty
    vntResultError = Empty
    vntRslCmtName1 = Empty
    vntRslCmtError1 = Empty
    vntRslCmtName2 = Empty
    vntRslCmtError2 = Empty
    vntMessage = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    lngArraySize = UBound(vntItemCd) + 1
    objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_P_ITEMCD
    objOraParam.AddTable "SUFFIX", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_C_SUFFIX
'    objOraParam.AddTable "RESULT", ORAPARM_BOTH, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSL_RESULT
    objOraParam.AddTable "RESULT", ORAPARM_BOTH, ORATYPE_VARCHAR2, lngArraySize, 400
    objOraParam.AddTable "SHORTSTC", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_SENTENCE_SHORTSTC
    objOraParam.AddTable "RESULTERROR", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 3
    objOraParam.AddTable "RSLCMTCD1", ORAPARM_BOTH, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "RSLCMTNAME1", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTNAME
    objOraParam.AddTable "RSLCMTERROR1", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 3
    objOraParam.AddTable "RSLCMTCD2", ORAPARM_BOTH, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "RSLCMTNAME2", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTNAME
    objOraParam.AddTable "RSLCMTERROR2", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 3
    objOraParam.AddTable "MESSAGE", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, 100, 256
    
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    'OraParameterオブジェクトの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    Set objSuffix = objOraParam("SUFFIX")
    Set objResult = objOraParam("RESULT")
    Set objShortStc = objOraParam("SHORTSTC")
    Set objResultError = objOraParam("RESULTERROR")
    Set objRslCmtCd1 = objOraParam("RSLCMTCD1")
    Set objRslCmtName1 = objOraParam("RSLCMTNAME1")
    Set objRslCmtError1 = objOraParam("RSLCMTERROR1")
    Set objRslCmtCd2 = objOraParam("RSLCMTCD2")
    Set objRslCmtName2 = objOraParam("RSLCMTNAME2")
    Set objRslCmtError2 = objOraParam("RSLCMTERROR2")
    Set objMessage = objOraParam("MESSAGE")
    
    '更新値の編集
    For i = 0 To lngArraySize - 1
        objItemCd(i) = CStr(vntItemCd(i))
        objSuffix(i) = CStr(vntSuffix(i))
        objResult(i) = CStr(vntResult(i))
        objRslCmtCd1(i) = CStr(vntRslCmtCd1(i))
        objRslCmtCd2(i) = CStr(vntRslCmtCd2(i))
    Next i
    
    '結果更新用ストアド呼び出し
    strStmt = "BEGIN :RET := ResultPackage.UpdateResultForDetail(:RSVNO, :IPADDRESS, :UPDUSER, :ITEMCD, :SUFFIX, :RESULT, :SHORTSTC, :RESULTERROR, :RSLCMTCD1, :RSLCMTNAME1, :RSLCMTERROR1, :RSLCMTCD2, :RSLCMTNAME2, :RSLCMTERROR2, :MESSAGE); END;"
    mobjOraDb.ExecuteSQL strStmt
    
    '戻り値の取得
    Ret2 = CLng(objOraParam("RET").Value)
    
    '呼び出し後の結果を取得
    lngCount = UBound(vntItemCd)
    ReDim Preserve vntArrResult(lngCount)
    ReDim Preserve vntArrShortStc(lngCount)
    ReDim Preserve vntArrResultError(lngCount)
    ReDim Preserve vntArrRslCmtCd1(lngCount)
    ReDim Preserve vntArrRslCmtName1(lngCount)
    ReDim Preserve vntArrRslCmtError1(lngCount)
    ReDim Preserve vntArrRslCmtCd2(lngCount)
    ReDim Preserve vntArrRslCmtName2(lngCount)
    ReDim Preserve vntArrRslCmtError2(lngCount)
    For i = 0 To lngCount
        vntArrResult(i) = CStr(objResult(i) & "")
        vntArrShortStc(i) = CStr(objShortStc(i) & "")
        vntArrResultError(i) = CStr(objResultError(i) & "")
        vntArrRslCmtCd1(i) = CStr(objRslCmtCd1(i) & "")
        vntArrRslCmtName1(i) = CStr(objRslCmtName1(i) & "")
        vntArrRslCmtError1(i) = CStr(objRslCmtError1(i) & "")
        vntArrRslCmtCd2(i) = CStr(objRslCmtCd2(i) & "")
        vntArrRslCmtName2(i) = CStr(objRslCmtName2(i) & "")
        vntArrRslCmtError2(i) = CStr(objRslCmtError2(i) & "")
    Next i
    
    '戻り値の設定(エラーに関わらず戻す値)
    vntResult = vntArrResult
    vntShortStc = vntArrShortStc
    vntResultError = vntArrResultError
    vntRslCmtCd1 = vntArrRslCmtCd1
    vntRslCmtName1 = vntArrRslCmtName1
    vntRslCmtError1 = vntArrRslCmtError1
    vntRslCmtCd2 = vntArrRslCmtCd2
    vntRslCmtName2 = vntArrRslCmtName2
    vntRslCmtError2 = vntArrRslCmtError2
    
    Ret = True
        
    'チェックエラー時
    If Ret2 <= 0 Then
    
        'バインド配列内容を検索し、メッセージを取得
        Do Until lngMsgCount >= objMessage.ArraySize
            
            'メッセージが格納されていなければここで終了
            If objMessage(lngMsgCount) = "" Then
                Exit Do
            End If
            
            '配列形式で格納する
            ReDim Preserve vntArrMessage(lngMsgCount)
            vntArrMessage(lngMsgCount) = CStr(objMessage(lngMsgCount))
            lngMsgCount = lngMsgCount + 1
        
        Loop
    
        '戻り値の設定(エラー時のメッセージ)
        vntMessage = vntArrMessage
        
        Ret = False
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateResultForDetail = Ret
    
    'トランザクション制御
    If Ret Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    Exit Function
    
ErrorHandle:

    UpdateResultForDetail = False
    
    'イベントログ書き込み
    WriteErrorLog "Result.UpdateResultForDetail"
    
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

'## 2003.12.12 Add Function By T.Takagi@FSIT
'
' 機能　　 : 検査結果テーブルのコメントと中止フラグを更新する
'
' 引数　　 : (In)     lngRsvNo      予約番号
' 　　　　   (In)     strIpAddress  ＩＰアドレス
' 　　　　   (In)     strUpdUser    更新者
' 　　　　   (In)     vntGrpCd      グループコード
' 　　　　   (In)     vntRslCmtCd2  結果コメント２
' 　　　　   (Out)    vntMessage    メッセージ
'
' 戻り値　 : True   正常終了
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Public Function UpdateResultForChangeSet( _
    ByVal lngRsvNo As Long, _
    ByVal strIpAddress As String, _
    ByVal strUpdUser As String, _
    ByRef vntGrpCd As Variant, _
    ByRef vntRslCmtCd2 As Variant, _
    ByRef vntMessage As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    
    Dim objGrpCd            As OraParamArray    'グループコード
    Dim objRslCmtCd2        As OraParamArray    '結果コメントコード２
    Dim objMessage          As OraParamArray    'メッセージ
    
    Dim vntArrMessage()     As Variant          'メッセージ
    Dim lngMsgCount         As Long             'メッセージ数
    
    Dim lngArraySize        As Long             '配列の要素数
    Dim Ret                 As Boolean          '関数戻り値
    Dim Ret2                As Long             '関数戻り値
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntMessage) Then vntMessage = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    lngArraySize = UBound(vntGrpCd) + 1
    objOraParam.AddTable "GRPCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_GRP_P_GRPCD
    objOraParam.AddTable "RSLCMTCD2", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "MESSAGE", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, 100, 256
    
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    'OraParameterオブジェクトの参照設定
    Set objGrpCd = objOraParam("GRPCD")
    Set objRslCmtCd2 = objOraParam("RSLCMTCD2")
    Set objMessage = objOraParam("MESSAGE")
    
    '更新値の編集
    For i = 0 To lngArraySize - 1
        objGrpCd(i) = CStr(vntGrpCd(i))
        objRslCmtCd2(i) = CStr(vntRslCmtCd2(i))
    Next i
    
    '結果更新用ストアド呼び出し
    strStmt = "BEGIN :RET := ResultPackage.UpdateResultForChangeSet(:RSVNO, :IPADDRESS, :UPDUSER, :GRPCD, :RSLCMTCD2, :MESSAGE); END;"
    mobjOraDb.ExecuteSQL strStmt
    
    '戻り値の取得
    Ret2 = CLng(objOraParam("RET").Value)
    
    Ret = True
        
    'チェックエラー時
    If Ret2 <= 0 Then
    
        If Not IsMissing(vntMessage) Then
        
            'バインド配列内容を検索し、メッセージを取得
            Do Until lngMsgCount >= objMessage.ArraySize
                
                'メッセージが格納されていなければここで終了
                If objMessage(lngMsgCount) = "" Then
                    Exit Do
                End If
                
                '配列形式で格納する
                ReDim Preserve vntArrMessage(lngMsgCount)
                vntArrMessage(lngMsgCount) = CStr(objMessage(lngMsgCount))
                lngMsgCount = lngMsgCount + 1
            
            Loop
        
            '戻り値の設定(エラー時のメッセージ)
            vntMessage = vntArrMessage
        
        End If
        
        Ret = False
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateResultForChangeSet = Ret
    
    'トランザクション制御
    If Ret Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    Exit Function
    
ErrorHandle:

    UpdateResultForChangeSet = False
    
    'イベントログ書き込み
    WriteErrorLog "Result.UpdateResultForChangeSet"
    
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
' 機能　　 : 検査結果テーブルを更新する(一覧入力、例外者入力用)
'
' 引数　　 : (In)     strUpdUser    更新者
' 　　　　   (In)     strIpAddress  ＩＰアドレス
' 　　　　   (In)     vntRsvNo      予約番号
' 　　　　   (In)     vntItemCd     検査項目コード
' 　　　　   (In)     vntSuffix     サフィックス
' 　　　　   (In)     vntResult     検査結果
'
' 戻り値　 : エラーメッセージ
'
' 備考　　 :
'
Public Function UpdateResultList( _
    ByVal strUpdUser As String, _
    ByVal strIpAddress As String, _
    ByRef vntRsvNo As Variant, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant _
) As Variant

    Dim vntArrItemCd()  As Variant  '検査項目コードの配列
    Dim vntArrSuffix()  As Variant  'サフィックスの配列
    Dim vntArrResult()  As Variant  '検査結果の配列
    Dim lngCount        As Long     '１受診情報当たりの更新項目数

    Dim lngPrevRsvNo    As Long     '直前の予約番号
    
    Dim vntMessage      As Variant  'メッセージ
    Dim i               As Long     'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    For i = 0 To UBound(vntRsvNo)
    
        '直前の検査結果情報と予約番号が異なる場合
        If lngPrevRsvNo <> 0 And CLng(vntRsvNo(i)) <> lngPrevRsvNo Then
    
            '検査結果レコードの更新
            If UpdateResultNoCmt(lngPrevRsvNo, strIpAddress, strUpdUser, vntArrItemCd, vntArrSuffix, vntArrResult, vntMessage) = False Then
                Exit For
            End If
            
            '配列の初期化
            Erase vntArrItemCd
            Erase vntArrSuffix
            Erase vntArrResult
            lngCount = 0
    
        End If
    
        '更新情報をスタック
        ReDim Preserve vntArrItemCd(lngCount)
        ReDim Preserve vntArrSuffix(lngCount)
        ReDim Preserve vntArrResult(lngCount)
        vntArrItemCd(lngCount) = vntItemCd(i)
        vntArrSuffix(lngCount) = vntSuffix(i)
        vntArrResult(lngCount) = vntResult(i)
        lngCount = lngCount + 1
    
        '現在の予約番号を退避
        lngPrevRsvNo = vntRsvNo(i)
    
    Next i
    
    'エラーなく、かつスタックされた更新情報が存在する場合は検査結果レコードを更新する
    If IsEmpty(vntMessage) And lngCount > 0 Then
        UpdateResultNoCmt lngPrevRsvNo, strIpAddress, strUpdUser, vntArrItemCd, vntArrSuffix, vntArrResult, vntMessage
    End If
   
    '戻り値の設定
    UpdateResultList = vntMessage
    
    'メッセージの有無によるトランザクション制御
    If IsEmpty(vntMessage) Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Result.UpdateResultList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 検査結果テーブルを更新する(コメント更新なし)
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (In)     strIpAddress    ＩＰアドレス
' 　　　　   (In)     strUpdUser      更新者
' 　　　　   (In)     vntItemCd       検査項目コード
' 　　　　   (In)     vntSuffix       サフィックス
' 　　　　   (In)     vntResult       検査結果
' 　　　　   (Out)    vntMessage      メッセージ
' 　　　　   (In)     blnCheckResult  True時は検査結果のチェックを行う
'
' 戻り値　 : True   正常終了
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Public Function UpdateResultNoCmt( _
    ByVal lngRsvNo As Long, _
    ByVal strIpAddress As String, _
    ByVal strUpdUser As String, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant, _
    Optional ByRef vntMessage As Variant, _
    Optional ByVal blnCheckResult As Boolean = False _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objItemCd       As OraParamArray    '検査項目コード
    Dim objSuffix       As OraParamArray    'サフィックス
    Dim objResult       As OraParamArray    '検査結果
    Dim objMessage      As OraParamArray    'メッセージ
    
    Dim vntArrMessage() As Variant          'メッセージ
    Dim lngMsgCount     As Long             'メッセージ数
    
    Dim lngArraySize    As Long             '配列の要素数
    Dim Ret             As Boolean          '関数戻り値
    Dim Ret2            As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntMessage) Then vntMessage = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHECKRESULT", IIf(blnCheckResult, 1, 0), ORAPARM_INPUT, ORATYPE_NUMBER
    
    lngArraySize = UBound(vntItemCd) + 1
    objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_P_ITEMCD
    objOraParam.AddTable "SUFFIX", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ITEM_C_SUFFIX
'    objOraParam.AddTable "RESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSL_RESULT
    objOraParam.AddTable "RESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 400
    objOraParam.AddTable "MESSAGE", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, 100, 256
    
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    'OraParameterオブジェクトの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    Set objSuffix = objOraParam("SUFFIX")
    Set objResult = objOraParam("RESULT")
    Set objMessage = objOraParam("MESSAGE")
    
    '更新値の編集
    For i = 0 To lngArraySize - 1
        objItemCd(i) = CStr(vntItemCd(i))
        objSuffix(i) = CStr(vntSuffix(i))
        objResult(i) = CStr(vntResult(i))
    Next i
    
    '結果更新用ストアド呼び出し
    strStmt = "BEGIN :RET := ResultPackage.UpdateResult(:RSVNO, :IPADDRESS, :UPDUSER, :ITEMCD, :SUFFIX, :RESULT, :MESSAGE, :CHECKRESULT); END;"
    mobjOraDb.ExecuteSQL strStmt
    
    '戻り値の取得
    Ret2 = CLng(objOraParam("RET").Value)
    
    Ret = True
        
    'チェックエラー時
    If Ret2 <= 0 Then
    
        If Not IsMissing(vntMessage) Then
        
            'バインド配列内容を検索し、メッセージを取得
            Do Until lngMsgCount >= objMessage.ArraySize
                
                'メッセージが格納されていなければここで終了
                If objMessage(lngMsgCount) = "" Then
                    Exit Do
                End If
                
                '配列形式で格納する
                ReDim Preserve vntArrMessage(lngMsgCount)
                vntArrMessage(lngMsgCount) = CStr(objMessage(lngMsgCount))
                lngMsgCount = lngMsgCount + 1
            
            Loop
        
            '戻り値の設定(エラー時のメッセージ)
            vntMessage = vntArrMessage
        
        End If
        
        Ret = False
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateResultNoCmt = Ret
    
    'トランザクション制御
    If Ret Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    Exit Function
    
ErrorHandle:

    UpdateResultNoCmt = False
    
    'イベントログ書き込み
    WriteErrorLog "Result.UpdateResultNoCmt"
    
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
' 機能　　 : 検査結果テーブルを更新する(コメント更新なし)
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (In)     strUpdUser      更新者
' 　　　　   (Out)    vntMessage      メッセージ
'
' 戻り値　 : True   正常終了
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Public Function UpdateYudo( _
    ByVal lngRsvNo As Long, _
    ByVal strUpdUser As String, _
    Optional ByRef vntMessage As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objMessage      As OraParamArray    'メッセージ
    
    Dim vntArrMessage() As Variant          'メッセージ
    Dim lngMsgCount     As Long             'メッセージ数
    
    Dim lngArraySize    As Long             '配列の要素数
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MESSAGE", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
    
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    '結果更新用ストアド呼び出し
    strStmt = "BEGIN :RET := OrderPackage.UpdateYudo(:RSVNO, :UPDUSER, :MESSAGE); END;"
    mobjOraDb.ExecuteSQL strStmt
    
    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateYudo = Ret
    
    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    Exit Function
    
ErrorHandle:

    UpdateYudo = -1
    
    'イベントログ書き込み
    WriteErrorLog "Result.UpdateYudo"
    
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


Public Function UpdateRsl_tk( _
    ByVal strUpdUser As String, _
    ByVal strIpAddress As String, _
    ByVal lngRsvNo As Long, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant, _
    ByRef vntRslCmtCd1 As Variant, _
    ByRef vntRslCmtCd2 As Variant, _
    Optional ByVal blnOverWrite As Boolean = True _
) As Variant

    Err.Raise 1000, , "このメソッドは使用禁止です。UpdateResultメソッドを使用してください。"
    
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
