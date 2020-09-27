VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "OcrNyuryokuSp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext                 As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession              As OraSession      'OraSessionオブジェクト
Private mobjOraDb                   As OraDatabase     'OraDatabaseオブジェクト

Private mcolOcrNyuryoku             As Collection       'OCR入力結果レコードのコレクション

Private lngOcrErrCnt                As Long             'エラー数
Private vntOcrErrNo                 As Variant          'エラーNo
Private vntOcrErrState              As Variant          'エラー状態
Private vntOcrErrMsg                As Variant          'エラーメッセージ

Private blnFujinkaFlg               As Boolean          '婦人科の依頼フラグ
Private blnStomachFlg               As Boolean          '胃Ｘ線の依頼フラグ

'
' 機能　　 : OCR内容確認修正日時を取得する
'
' 引数　　 : (In)     lngRsvNo       予約番号
' 　　　　   (Out)    vntEditOcrDate OCR内容確認修正日時
'
' 戻り値　 : True   正常終了
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Public Function SelectEditOcrDate( _
    ByVal lngRsvNo As Long, _
    ByRef vntEditOcrDate As Variant _
) As Boolean
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
   
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objEditOcrDate      As OraField         'OCR内容確認修正日時


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '-------------------------------------------------------------------------------
    'OCR内容確認修正日時を取得する
    '-------------------------------------------------------------------------------
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = _
        "SELECT EDITOCRDATE     " & vbLf & _
        "  FROM RECEIPT         " & vbLf & _
        " WHERE RSVNO = :RSVNO  "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objEditOcrDate = objFields("EDITOCRDATE")
        
         '戻り値の設定
        vntEditOcrDate = objEditOcrDate.Value & ""
    End If
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    SelectEditOcrDate = True
    Exit Function
    
ErrorHandle:

    SelectEditOcrDate = False
    
    'イベントログ書き込み
    WriteErrorLog "RslOcrSp.SelectEditOcrDate"
    
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
' 機能　　 : 婦人科の依頼があるかチェックする
'
' 引数　　 : (In)     lngRsvNo       予約番号
'
' 戻り値　 :  1:婦人科の依頼あり
' 　　　　    0:婦人科の依頼なし
' 　　　　   -1:エラーあり
'
' 備考　　 :
'
Public Function CheckFujinka( _
    ByVal lngRsvNo As Long _
) As Long
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '-------------------------------------------------------------------------------
    '婦人科の依頼項目を取得する
    '-------------------------------------------------------------------------------
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = _
        "SELECT RSL.RESULT                  " & vbLf & _
        "  FROM RSL, GRP_R                  " & vbLf & _
        " WHERE RSL.RSVNO    = :RSVNO       " & vbLf & _
        "   AND RSL.STOPFLG IS NULL         " & vbLf & _
        "   AND GRP_R.GRPCD  = 'K0590'      " & vbLf & _
        "   AND GRP_R.ITEMCD = RSL.ITEMCD   "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        CheckFujinka = 1     '依頼あり
    Else
        CheckFujinka = 0     '依頼なし
    End If
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    CheckFujinka = -1

    'イベントログ書き込み
    WriteErrorLog "RslOcrSp.CheckFujinka"
    
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
' 機能　　 : 胃Ｘ線の依頼があるかチェックする
'
' 引数　　 : (In)     lngRsvNo       予約番号
'
' 戻り値　 :  1:胃Ｘ線の依頼あり
' 　　　　    0:胃Ｘ線の依頼なし
' 　　　　   -1:エラーあり
'
' 備考　　 :
'
Public Function CheckStomach( _
    ByVal lngRsvNo As Long _
) As Long
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '-------------------------------------------------------------------------------
    '胃Ｘ線の依頼項目を取得する
    '-------------------------------------------------------------------------------
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = _
        "SELECT RSL.RESULT                  " & vbLf & _
        "  FROM RSL, GRP_R                  " & vbLf & _
        " WHERE RSL.RSVNO    = :RSVNO       " & vbLf & _
        "   AND RSL.STOPFLG IS NULL         " & vbLf & _
        "   AND GRP_R.GRPCD  = 'K0160'      " & vbLf & _
        "   AND GRP_R.ITEMCD = RSL.ITEMCD   "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        CheckStomach = 1     '依頼あり
    Else
        CheckStomach = 0     '依頼なし
    End If
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    CheckStomach = -1

    'イベントログ書き込み
    WriteErrorLog "RslOcrSp.CheckStomach"
    
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
' 機能　　 : 胃内視鏡の依頼があるかチェックする
' 　　　　   依頼がある場合は内視鏡チェックリストが保存されているかをチェックする
'
' 引数　　 : (In)     lngRsvNo       予約番号
' 　　　　   (Out)    vntGFCheckList 内視鏡チェックリスト(0:未保存、1:保存済み)
'
' 戻り値　 :  1:胃内視鏡の依頼あり
' 　　　　    0:胃内視鏡の依頼なし
' 　　　　   -1:エラーあり
'
' 備考　　 :
'
Public Function CheckGF( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntGFCheckList As Variant _
) As Long
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '-------------------------------------------------------------------------------
    '胃内視鏡の依頼項目を取得する
    '-------------------------------------------------------------------------------
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = _
        "SELECT RSL.RESULT                  " & vbLf & _
        "  FROM RSL, GRP_R                  " & vbLf & _
        " WHERE RSL.RSVNO    = :RSVNO       " & vbLf & _
        "   AND RSL.STOPFLG IS NULL         " & vbLf & _
        "   AND GRP_R.GRPCD  = 'K0180'      " & vbLf & _
        "   AND GRP_R.ITEMCD = RSL.ITEMCD   "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        CheckGF = 1     '保存済み
    Else
        CheckGF = 0     '未保存
    End If
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '内視鏡チェックリストの保存チェック
    If Not IsMissing(vntGFCheckList) Then
        '胃内視鏡の依頼あり
        If CheckGF = 1 Then
            '-------------------------------------------------------------------------------
            '内視鏡チェックリストの内容を取得する
            '-------------------------------------------------------------------------------
            'キー及び更新値の設定
            Set objOraParam = mobjOraDb.Parameters
            objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
            
            strStmt = _
                "SELECT RSL.RESULT                  " & vbLf & _
                "  FROM RSL, GRP_I                  " & vbLf & _
                " WHERE RSL.RSVNO    = :RSVNO       " & vbLf & _
                "   AND RSL.STOPFLG IS NULL         " & vbLf & _
                "   AND GRP_I.GRPCD  = 'X024'       " & vbLf & _
                "   AND GRP_I.ITEMCD = RSL.ITEMCD   " & vbLf & _
                "   AND GRP_I.SUFFIX = RSL.SUFFIX   "
        
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
                
            '検索レコードが存在する場合
            If Not objOraDyna.EOF Then
                vntGFCheckList = "1"    '依頼あり
            Else
                vntGFCheckList = "0"    '依頼なし
            End If
            
            Set objOraDyna = Nothing
                
            'キー及び更新値の設定解除
            Do Until objOraParam.Count <= 0
                objOraParam.Remove (objOraParam.Count - 1)
            Loop
        Else
            vntGFCheckList = ""
        End If
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    CheckGF = -1

    'イベントログ書き込み
    WriteErrorLog "RslOcrSp.CheckGF"
    
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
' 機能　　 : 該当受診者の受診日チェック
'
' 引数　　 : (In)     lngRsvNo       予約番号
'
' 戻り値　 :  受診日
'             コースコード
'
' 備考　　 :
'
Public Function CheckCSLDATE( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntCSCD As Variant _
) As String
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCslDate          As OraField         '受診日
    Dim objCSCD             As OraField         'コースコード

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '-------------------------------------------------------------------------------
    '予約情報から受診日取得
    '-------------------------------------------------------------------------------
    
    '初期化
    CheckCSLDATE = ""
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = "SELECT TO_CHAR(CONSULT.CSLDATE,'YYYY/MM/DD') AS CSLDATE  " & vbLf & _
              "      ,CONSULT.CSCD       AS CSCD                        " & vbLf & _
              "  FROM CONSULT                                           " & vbLf & _
              " WHERE CONSULT.RSVNO  = :RSVNO                           "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objCSCD = objFields("CSCD")
        
        CheckCSLDATE = objCslDate.Value & ""
        vntCSCD = objCSCD.Value & ""
    
    End If
    
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
    WriteErrorLog "RslOcrSp.CheckCslDate"
    
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
' 機能　　 : ＯＣＲ入力結果を取得する
'
' 引数　　 : (In)     lngRsvNo       予約番号（今回分）
' 　　　　   (In)     strGrpCd       グループコード
' 　　　　   (In)     lngLastDspMode 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
' 　　　　   (In)     vntCsGrp       前回歴表示モード＝0のとき、null
' 　　　　                                          ＝1のとき、コースコード
' 　　　　                                          ＝2のとき、コースグループコード
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntCslDate     受診日
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntItemCd      検査項目コード
' 　　　　   (Out)    vntSuffix      サフィックス
' 　　　　   (Out)    vntItemName    検査項目名称
' 　　　　   (Out)    vntRslFlg      検査結果存在フラグ(1:検査結果に存在する、0:検査結果に存在しない）
' 　　　　   (Out)    vntResult      検査結果
' 　　　　   (Out)    vntStopFlg     検査中止フラグ
' 　　　　   (Out)    vntLstCslDate  前回受診日
' 　　　　   (Out)    vntLstRsvNo    前回予約番号
' 　　　　   (Out)    vntLstRslFlg   前回検査結果存在フラグ(2:個人検査結果に存在する、1:検査結果に存在する、0:検査結果に存在しない）
' 　　　　   (Out)    vntLstResult   前回検査結果
' 　　　　   (Out)    vntLstStopFlg  前回検査中止フラグ
' 　　　　   (Out)    vntErrCount    エラー数
' 　　　　   (Out)    vntErrNo       エラーNo
' 　　　　   (Out)    vntErrState    エラー状態
' 　　　　   (Out)    vntErrMsg      エラーメッセージ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectOcrNyuryoku( _
    ByVal lngRsvNo As Long, _
    ByVal strGrpCd As String, _
    ByVal lngLastDspMode As Long, _
    ByVal vntCsGrp As Variant, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntItemCd As Variant, Optional ByRef vntSuffix As Variant, _
    Optional ByRef vntItemName As Variant, _
    Optional ByRef vntRslFlg As Variant, Optional ByRef vntResult As Variant, Optional ByRef vntStopFlg As Variant, _
    Optional ByRef vntLstCslDate As Variant, Optional ByRef vntLstRsvNo As Variant, _
    Optional ByRef vntLstRslFlg As Variant, Optional ByRef vntLstResult As Variant, Optional ByRef vntLstStopFlg As Variant, _
    Optional ByRef vntErrCount As Variant, Optional ByRef vntErrNo As Variant, _
    Optional ByRef vntErrState As Variant, Optional ByRef vntErrMsg As Variant _
) As Long
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
   
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objEditOcrDate      As OraField         'OCR内容確認修正日時
    Dim vntEditOcrDate      As Variant
    
    Dim objRslOcrSp         As RslOcrSp
    
    Dim vntArrPerId         As Variant          '個人ＩＤの配列
    Dim vntArrCslDate       As Variant          '受診日の配列
    Dim vntArrRsvNo         As Variant          '予約番号の配列
    Dim vntArrItemCd        As Variant          '検査項目コードの配列
    Dim vntArrSuffix        As Variant          'サフィックスの配列
    Dim vntArrResultType    As Variant          '結果タイプの配列
    Dim vntArrItemType      As Variant          '項目タイプの配列
    Dim vntArrItemName      As Variant          '検査項目名称の配列
    Dim vntArrFigure1       As Variant          '整数部桁数の配列
    Dim vntArrFigure2       As Variant          '小数部桁数の配列
    Dim vntArrMaxValue      As Variant          '最大値の配列
    Dim vntArrMinValue      As Variant          '最小値の配列
    Dim vntArrUnit          As Variant          '単位の配列
    Dim vntArrRslFlg        As Variant          '検査結果存在フラグの配列
    Dim vntArrResult        As Variant          '検査結果の配列
    Dim vntArrStopFlg       As Variant          '検査中止フラグの配列
    Dim vntArrRslCmtCd1     As Variant          '結果コメント１の配列
    Dim vntArrRslCmtName1   As Variant          '結果コメント名１の配列
    Dim vntArrRslCmtCd2     As Variant          '結果コメント２の配列
    Dim vntArrRslCmtName2   As Variant          '結果コメント名２の配列
    Dim vntArrLstCslDate        As Variant      '前回受診日の配列
    Dim vntArrLstRsvNo          As Variant      '前回予約番号の配列
    Dim vntArrLstRslFlg         As Variant      '前回検査結果存在フラグの配列
    Dim vntArrLstResult         As Variant      '前回検査結果の配列
    Dim vntArrLstStopFlg        As Variant      '前回検査中止フラグの配列
    Dim vntArrLstRslCmtCd1      As Variant      '前回結果コメント１の配列
    Dim vntArrLstRslCmtName1    As Variant      '前回結果コメント名１の配列
    Dim vntArrLstRslCmtCd2      As Variant      '前回結果コメント２の配列
    Dim vntArrLstRslCmtName2    As Variant      '前回結果コメント名２の配列
    
    Dim vntArrErrNo()       As Variant          'エラーNoの配列
    Dim vntArrErrState()    As Variant          'エラー状態の配列
    Dim vntArrErrMsg()      As Variant          'エラーメッセージの配列
    
    Dim strUniqueKey        As String           'コレクションの対象キー
    
    Dim lngOcrCheck         As Long             'OCRチェック（0:OCR未チェック、1:OCRチェック済）
    Dim blnRet              As Boolean          '復帰値
    
    Dim lngCount            As Long             'レコード数
    Dim lngErrCount         As Long             'エラー数
    Dim i                   As Long


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntRslFlg) Then vntRslFlg = Empty
    If Not IsMissing(vntResult) Then vntResult = Empty
    If Not IsMissing(vntStopFlg) Then vntStopFlg = Empty
    If Not IsMissing(vntLstCslDate) Then vntLstCslDate = Empty
    If Not IsMissing(vntLstRsvNo) Then vntLstRsvNo = Empty
    If Not IsMissing(vntLstRslFlg) Then vntLstRslFlg = Empty
    If Not IsMissing(vntLstResult) Then vntLstResult = Empty
    If Not IsMissing(vntLstStopFlg) Then vntLstStopFlg = Empty
    If Not IsMissing(vntErrCount) Then vntErrCount = Empty
    If Not IsMissing(vntErrNo) Then vntErrNo = Empty
    If Not IsMissing(vntErrState) Then vntErrState = Empty
    If Not IsMissing(vntErrMsg) Then vntErrMsg = Empty
    
    '-------------------------------------------------------------------------------
    'OCR内容確認修正日時を取得する
    '-------------------------------------------------------------------------------
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = _
        "SELECT EDITOCRDATE     " & vbLf & _
        "  FROM RECEIPT         " & vbLf & _
        " WHERE RSVNO = :RSVNO  "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objEditOcrDate = objFields("EDITOCRDATE")
        
        vntEditOcrDate = objEditOcrDate.Value & ""
    End If
    
    Set objOraDyna = Nothing
        
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    'OCRチェック(OCR内容確認修正日時が入っていないときはOCR未チェック)
    lngOcrCheck = IIf(vntEditOcrDate = "", 0, 1)

    '-------------------------------------------------------------------------------
    'ＯＣＲ入力結果を取得する
    '-------------------------------------------------------------------------------
    lngCount = SelectRslOcr( _
                            lngRsvNo, _
                            strGrpCd, _
                            lngLastDspMode, _
                            vntCsGrp, _
                            lngOcrCheck, _
                            vntArrPerId, _
                            vntArrCslDate, _
                            vntArrRsvNo, _
                            vntArrItemCd, _
                            vntArrSuffix, _
                            vntArrResultType, _
                            vntArrItemType, _
                            vntArrItemName, _
                            vntArrFigure1, _
                            vntArrFigure2, _
                            vntArrMaxValue, _
                            vntArrMinValue, _
                            vntArrUnit, _
                            vntArrRslFlg, vntArrResult, vntArrStopFlg, _
                            vntArrRslCmtCd1, vntArrRslCmtName1, vntArrRslCmtCd2, vntArrRslCmtName2, _
                            vntArrLstCslDate, vntArrLstRsvNo, _
                            vntArrLstRslFlg, vntArrLstResult, vntArrLstStopFlg, _
                            vntArrLstRslCmtCd1, vntArrLstRslCmtName1, vntArrLstRslCmtCd2, vntArrLstRslCmtName2 _
                            )
    If lngCount > 0 Then
       'コレクション作成
        Set mcolOcrNyuryoku = Nothing
        Set mcolOcrNyuryoku = New Collection

        For i = 0 To lngCount - 1
            '新規レコード作成
            Set objRslOcrSp = New RslOcrSp
            
            With objRslOcrSp
                .UniqueKey = vntArrItemCd(i) & "-" & vntArrSuffix(i)
                .PerId = vntArrPerId(i)
                .CslDate = vntArrCslDate(i)
                .RsvNo = vntArrRsvNo(i)
                .ItemCd = vntArrItemCd(i)
                .Suffix = vntArrSuffix(i)
                .ResultType = vntArrResultType(i)
                .ItemType = vntArrItemType(i)
                .ItemName = vntArrItemName(i)
                .Figure1 = vntArrFigure1(i)
                .Figure2 = vntArrFigure2(i)
                .MaxValue = vntArrMaxValue(i)
                .MinValue = vntArrMinValue(i)
                .Unit = vntArrUnit(i)
                .RslFlg = vntArrRslFlg(i)
                .Result = vntArrResult(i)
                .StopFlg = vntArrStopFlg(i)
                .RslCmtCd1 = vntArrRslCmtCd1(i)
                .RslCmtName1 = vntArrRslCmtName1(i)
                .RslCmtCd2 = vntArrRslCmtCd2(i)
                .RslCmtName2 = vntArrRslCmtName2(i)
                .LstCslDate = vntArrLstCslDate(i)
                .LstRsvNo = vntArrLstRsvNo(i)
                .LstRslFlg = vntArrLstRslFlg(i)
                .LstResult = vntArrLstResult(i)
                .LstStopFlg = vntArrLstStopFlg(i)
                .LstRslCmtCd1 = vntArrLstRslCmtCd1(i)
                .LstRslCmtName1 = vntArrLstRslCmtName1(i)
                .LstRslCmtCd2 = vntArrLstRslCmtCd2(i)
                .LstRslCmtName2 = vntArrLstRslCmtName2(i)
                .Index = i + 1
            End With
            
            mcolOcrNyuryoku.Add objRslOcrSp, objRslOcrSp.UniqueKey
            Set objRslOcrSp = Nothing
        Next
        
        '-------------------------------------------------------------------------------
        'ＯＣＲ入力結果の入力チェック
        '-------------------------------------------------------------------------------
        lngErrCount = CheckRslOcr(lngRsvNo, vntArrErrNo, vntArrErrState, vntArrErrMsg)
    
        '入力チェックのときに修正された検査結果を戻す
        For i = 0 To UBound(vntArrItemCd)
            strUniqueKey = vntArrItemCd(i) & "-" & vntArrSuffix(i)
            If strUniqueKey <> "-" Then
                Set objRslOcrSp = mcolOcrNyuryoku(strUniqueKey)
                With objRslOcrSp
                    vntArrResult(i) = .Result
                End With
            End If
        Next
    End If
    
    '戻り値の設定
    If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
    If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
    If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
    If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
    If Not IsMissing(vntRslFlg) Then vntRslFlg = vntArrRslFlg
    If Not IsMissing(vntStopFlg) Then vntStopFlg = vntArrStopFlg
    If Not IsMissing(vntResult) Then vntResult = vntArrResult
    If Not IsMissing(vntLstCslDate) Then vntLstCslDate = vntArrLstCslDate
    If Not IsMissing(vntLstRsvNo) Then vntLstRsvNo = vntArrLstRsvNo
    If Not IsMissing(vntLstRslFlg) Then vntLstRslFlg = vntArrLstRslFlg
    If Not IsMissing(vntLstResult) Then vntLstResult = vntArrLstResult
    If Not IsMissing(vntLstStopFlg) Then vntLstStopFlg = vntArrLstStopFlg
    If Not IsMissing(vntErrCount) Then vntErrCount = lngErrCount
    If Not IsMissing(vntErrNo) Then vntErrNo = vntArrErrNo
    If Not IsMissing(vntErrState) Then vntErrState = vntArrErrState
    If Not IsMissing(vntErrMsg) Then vntErrMsg = vntArrErrMsg
    
    SelectOcrNyuryoku = lngCount
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RslOcrSp.SelectOcrNyuryoku"
    
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
' 機能　　 : ＯＣＲ入力結果の入力チェック
'
' 引数　　 : (In)     lngRsvNo       予約番号（今回分）
' 　　　　   (In)     strGrpCd       グループコード
' 　　　　   (In)     lngLastDspMode 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
' 　　　　   (In)     vntCsGrp       前回歴表示モード＝0のとき、null
' 　　　　                                          ＝1のとき、コースコード
' 　　　　                                          ＝2のとき、コースグループコード
' 　　　　   (In/Out) vntItemCd      検査項目コード
' 　　　　   (In/Out) vntSuffix      サフィックス
' 　　　　   (In/Out) vntResult      検査結果
' 　　　　   (In/Out) vntStopFlg     検査中止フラグ
' 　　　　   (Out)    vntErrCount    エラー数
' 　　　　   (Out)    vntErrNo       エラーNo
' 　　　　   (Out)    vntErrState    エラー状態
' 　　　　   (Out)    vntErrMsg      エラーメッセージ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function CheckOcrNyuryoku( _
    ByVal lngRsvNo As Long, _
    ByVal strGrpCd As String, _
    ByVal lngLastDspMode As Long, _
    ByVal vntCsGrp As Variant, _
    ByRef vntItemCd As Variant, ByRef vntSuffix As Variant, _
    ByRef vntResult As Variant, ByRef vntStopFlg As Variant, _
    Optional ByRef vntErrCount As Variant, Optional ByRef vntErrNo As Variant, _
    Optional ByRef vntErrState As Variant, Optional ByRef vntErrMsg As Variant _
) As Long
    
    Dim objRslOcrSp         As RslOcrSp
    
    Dim vntArrPerId         As Variant          '個人ＩＤの配列
    Dim vntArrCslDate       As Variant          '受診日の配列
    Dim vntArrRsvNo         As Variant          '予約番号の配列
    Dim vntArrItemCd        As Variant          '検査項目コードの配列
    Dim vntArrSuffix        As Variant          'サフィックスの配列
    Dim vntArrResultType    As Variant          '結果タイプの配列
    Dim vntArrItemType      As Variant          '項目タイプの配列
    Dim vntArrItemName      As Variant          '検査項目名称の配列
    Dim vntArrFigure1       As Variant          '整数部桁数の配列
    Dim vntArrFigure2       As Variant          '小数部桁数の配列
    Dim vntArrMaxValue      As Variant          '最大値の配列
    Dim vntArrMinValue      As Variant          '最小値の配列
    Dim vntArrUnit          As Variant          '単位の配列
    Dim vntArrRslFlg        As Variant          '検査結果存在フラグの配列
    Dim vntArrResult        As Variant          '検査結果の配列
    Dim vntArrStopFlg       As Variant          '検査中止フラグの配列
    Dim vntArrRslCmtCd1     As Variant          '結果コメント１の配列
    Dim vntArrRslCmtName1   As Variant          '結果コメント名１の配列
    Dim vntArrRslCmtCd2     As Variant          '結果コメント２の配列
    Dim vntArrRslCmtName2   As Variant          '結果コメント名２の配列
    Dim vntArrLstCslDate        As Variant      '前回受診日の配列
    Dim vntArrLstRsvNo          As Variant      '前回予約番号の配列
    Dim vntArrLstRslFlg         As Variant      '前回検査結果存在フラグの配列
    Dim vntArrLstResult         As Variant      '前回検査結果の配列
    Dim vntArrLstStopFlg        As Variant      '前回検査中止フラグの配列
    Dim vntArrLstRslCmtCd1      As Variant      '前回結果コメント１の配列
    Dim vntArrLstRslCmtName1    As Variant      '前回結果コメント名１の配列
    Dim vntArrLstRslCmtCd2      As Variant      '前回結果コメント２の配列
    Dim vntArrLstRslCmtName2    As Variant      '前回結果コメント名２の配列
    
    Dim vntArrErrNo()       As Variant          'エラーNoの配列
    Dim vntArrErrState()    As Variant          'エラー状態の配列
    Dim vntArrErrMsg()      As Variant          'エラーメッセージの配列
    
    Dim strUniqueKey        As String           'コレクションの対象キー
    
    Dim lngCount            As Long             'レコード数
    Dim lngErrCount         As Long             'エラー数
    Dim i                   As Long


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntErrCount) Then vntErrCount = Empty
    If Not IsMissing(vntErrNo) Then vntErrNo = Empty
    If Not IsMissing(vntErrState) Then vntErrState = Empty
    If Not IsMissing(vntErrMsg) Then vntErrMsg = Empty
    
    '-------------------------------------------------------------------------------
    'ＯＣＲ入力結果を取得する
    '-------------------------------------------------------------------------------
    lngCount = SelectRslOcr( _
                            lngRsvNo, _
                            strGrpCd, _
                            lngLastDspMode, _
                            vntCsGrp, _
                            1, _
                            vntArrPerId, _
                            vntArrCslDate, _
                            vntArrRsvNo, _
                            vntArrItemCd, _
                            vntArrSuffix, _
                            vntArrResultType, _
                            vntArrItemType, _
                            vntArrItemName, _
                            vntArrFigure1, _
                            vntArrFigure2, _
                            vntArrMaxValue, _
                            vntArrMinValue, _
                            vntArrUnit, _
                            vntArrRslFlg, vntArrResult, vntArrStopFlg, _
                            vntArrRslCmtCd1, vntArrRslCmtName1, vntArrRslCmtCd2, vntArrRslCmtName2, _
                            vntArrLstCslDate, vntArrLstRsvNo, _
                            vntArrLstRslFlg, vntArrLstResult, vntArrLstStopFlg, _
                            vntArrLstRslCmtCd1, vntArrLstRslCmtName1, vntArrLstRslCmtCd2, vntArrLstRslCmtName2 _
                            )
    Do
        If lngCount = 0 Then Exit Do
       
       'コレクション作成
        Set mcolOcrNyuryoku = Nothing
        Set mcolOcrNyuryoku = New Collection

        For i = 0 To lngCount - 1
            '新規レコード作成
            Set objRslOcrSp = New RslOcrSp
            
            With objRslOcrSp
                .UniqueKey = vntArrItemCd(i) & "-" & vntArrSuffix(i)
                .PerId = vntArrPerId(i)
                .CslDate = vntArrCslDate(i)
                .RsvNo = vntArrRsvNo(i)
                .ItemCd = vntArrItemCd(i)
                .Suffix = vntArrSuffix(i)
                .ResultType = vntArrResultType(i)
                .ItemType = vntArrItemType(i)
                .ItemName = vntArrItemName(i)
                .Figure1 = vntArrFigure1(i)
                .Figure2 = vntArrFigure2(i)
                .MaxValue = vntArrMaxValue(i)
                .MinValue = vntArrMinValue(i)
                .Unit = vntArrUnit(i)
                .RslFlg = vntArrRslFlg(i)
                .RslCmtCd1 = vntArrRslCmtCd1(i)
                .RslCmtName1 = vntArrRslCmtName1(i)
                .RslCmtCd2 = vntArrRslCmtCd2(i)
                .RslCmtName2 = vntArrRslCmtName2(i)
                .LstCslDate = vntArrLstCslDate(i)
                .LstRsvNo = vntArrLstRsvNo(i)
                .LstRslFlg = vntArrLstRslFlg(i)
                .LstResult = vntArrLstResult(i)
                .LstStopFlg = vntArrLstStopFlg(i)
                .LstRslCmtCd1 = vntArrLstRslCmtCd1(i)
                .LstRslCmtName1 = vntArrLstRslCmtName1(i)
                .LstRslCmtCd2 = vntArrLstRslCmtCd2(i)
                .LstRslCmtName2 = vntArrLstRslCmtName2(i)
                .Index = i + 1
            End With
            
            mcolOcrNyuryoku.Add objRslOcrSp, objRslOcrSp.UniqueKey
            Set objRslOcrSp = Nothing
        Next
        
        '渡された検査結果と検査中止フラグをセット
        For i = 0 To UBound(vntResult)
            strUniqueKey = vntItemCd(i) & "-" & vntSuffix(i)
            If strUniqueKey <> "-" Then
                Set objRslOcrSp = mcolOcrNyuryoku(strUniqueKey)
                With objRslOcrSp
                    .Result = vntResult(i)
                    .StopFlg = vntStopFlg(i)
                End With
            End If
        Next
        
        '-------------------------------------------------------------------------------
        '婦人科の依頼があるかチェック（依頼なしのときは、婦人科問診の入力チェックをしない）
        '-------------------------------------------------------------------------------
        If CheckFujinka(lngRsvNo) = 1 Then
            blnFujinkaFlg = True
        Else
            blnFujinkaFlg = False
        End If
        
        '-------------------------------------------------------------------------------
        'ＯＣＲ入力結果の入力チェック
        '-------------------------------------------------------------------------------
        lngErrCount = CheckRslOcr(lngRsvNo, vntArrErrNo, vntArrErrState, vntArrErrMsg)
        
        '-------------------------------------------------------------------------------
        '検査中止フラグのセット
        '-------------------------------------------------------------------------------
        For i = 1 To mcolOcrNyuryoku.Count
            'Ａ型行動パターン・テストの未回答
            If mcolOcrNyuryoku(OCR_ITEM151).Index <= i And i <= mcolOcrNyuryoku(OCR_ITEM161).Index Then
                mcolOcrNyuryoku(i).StopFlg = IIf(mcolOcrNyuryoku(OCR_ITEM150).Result = "1", "S", "")
            End If
        
            'ストレス・コーピングテストの未回答
            If mcolOcrNyuryoku(OCR_ITEM163).Index <= i And i <= mcolOcrNyuryoku(OCR_ITEM174).Index Then
                mcolOcrNyuryoku(i).StopFlg = IIf(mcolOcrNyuryoku(OCR_ITEM162).Result = "1", "S", "")
            End If
        
            '食習慣問診の未回答
            If mcolOcrNyuryoku(OCR_ITEM241).Index <= i And i <= mcolOcrNyuryoku(OCR_ITEM524).Index Then
                mcolOcrNyuryoku(i).StopFlg = IIf(mcolOcrNyuryoku(OCR_ITEM240).Result = "1", "S", "")
            End If
        Next
        
        '入力チェックのときに修正された検査結果を戻す
        For i = 0 To UBound(vntItemCd)
            strUniqueKey = vntItemCd(i) & "-" & vntSuffix(i)
            If strUniqueKey <> "-" Then
                Set objRslOcrSp = mcolOcrNyuryoku(strUniqueKey)
                With objRslOcrSp
                    vntResult(i) = .Result
                    vntStopFlg(i) = .StopFlg
                End With
            End If
        Next
        Exit Do
    Loop
    
    '戻り値の設定
    If Not IsMissing(vntErrCount) Then vntErrCount = lngErrCount
    If Not IsMissing(vntErrNo) Then vntErrNo = vntArrErrNo
    If Not IsMissing(vntErrState) Then vntErrState = vntArrErrState
    If Not IsMissing(vntErrMsg) Then vntErrMsg = vntArrErrMsg
    
    CheckOcrNyuryoku = lngCount
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RslOcrSp.CheckOcrNyuryoku"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 備考　　 :
'
'
' 機能　　 : ＯＣＲ入力結果を更新する
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
Public Function UpdateOcrNyuryoku( _
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
    objOraParam.AddTable "RESULT", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSL_RESULT
    objOraParam.AddTable "RSLCMTCD1", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "RSLCMTCD2", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_RSLCMT_RSLCMTCD
    objOraParam.AddTable "STOPFLG", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 1
'### 2004/06/04 Updated by Ishihara@FSIT 配列数が固定になっている
'    objOraParam.AddTable "MESSAGE", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, 100, 256
    objOraParam.AddTable "MESSAGE", ORAPARM_OUTPUT, ORATYPE_VARCHAR2, lngArraySize, 256
'### 2004/06/04 Updated End
    
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
    
    If Ret Then
        '-------------------------------------------------------------------------------
        'OCR内容確認修正日時を更新
        '-------------------------------------------------------------------------------
        'キー値及び更新値の設定
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "RSVNO", Trim(lngRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
        
        strStmt = "UPDATE RECEIPT               " & vbLf & _
              "   SET EDITOCRDATE = SYSDATE     " & vbLf & _
              " WHERE RSVNO           = :RSVNO  "
        
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
        'バインド変数の削除
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
    End If
    
    
    '戻り値の設定
    UpdateOcrNyuryoku = Ret
    
    'トランザクション制御
    If Ret Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    Exit Function
    
ErrorHandle:

    UpdateOcrNyuryoku = False
    
    'イベントログ書き込み
    WriteErrorLog "RslOcrSp.UpdateOcrNyuryoku"
    
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
' 機能　　 : 予約番号をキーに指定対象受診者のＯＣＲ入力結果を取得する
'
' 引数　　 : (In)     lngRsvNo       予約番号（今回分）
' 　　　　   (In)     strGrpCd       グループコード
' 　　　　   (In)     lngLastDspMode 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
' 　　　　   (In)     vntCsGrp       前回歴表示モード＝0のとき、null
' 　　　　                                          ＝1のとき、コースコード
' 　　　　                                          ＝2のとき、コースグループコード
' 　　　　   (In)     lngOcrCheck    OCRチェック（0:OCR未チェック、1:OCRチェック済）
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntCslDate     受診日
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntItemCd      検査項目コード
' 　　　　   (Out)    vntSuffix      サフィックス
' 　　　　   (Out)    vntResultType  結果タイプ
' 　　　　   (Out)    vntItemType    項目タイプ
' 　　　　   (Out)    vntItemName    検査項目名称
' 　　　　   (Out)    vntFigure1     整数部桁数
' 　　　　   (Out)    vntFigure2     小数部桁数
' 　　　　   (Out)    vntMaxValue    最大値
' 　　　　   (Out)    vntMinValue    最小値
' 　　　　   (Out)    vntUnit        単位
' 　　　　   (Out)    vntRslFlg      検査結果存在フラグ(1:検査結果に存在する、0:検査結果に存在しない）
' 　　　　   (Out)    vntRslValue    検査結果
' 　　　　   (Out)    vntStopFlg     検査中止フラグ
' 　　　　   (Out)    vntRslCmtCd1   結果コメント１
' 　　　　   (Out)    vntRslCmtName1 結果コメント名１
' 　　　　   (Out)    vntRslCmtCd2   結果コメント２
' 　　　　   (Out)    vntRslCmtName2 結果コメント名２
' 　　　　   (Out)    vntLstCslDate     前回受診日
' 　　　　   (Out)    vntLstRsvNo       前回予約番号
' 　　　　   (Out)    vntLstRslFlg      前回検査結果存在フラグ(2:個人検査結果に存在する、1:検査結果に存在する、0:検査結果に存在しない）
' 　　　　   (Out)    vntLstRslValue    前回検査結果
' 　　　　   (Out)    vntLstStopFlg     前回検査中止フラグ
' 　　　　   (Out)    vntLstRslCmtCd1   前回結果コメント１
' 　　　　   (Out)    vntLstRslCmtName1 前回結果コメント名１
' 　　　　   (Out)    vntLstRslCmtCd2   前回結果コメント２
' 　　　　   (Out)    vntLstRslCmtName2 前回結果コメント名２
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Private Function SelectRslOcr( _
    ByVal lngRsvNo As Long, _
    ByVal strGrpCd As String, _
    ByVal lngLastDspMode As Long, _
    ByVal vntCsGrp As Variant, _
    ByVal lngOcrCheck As Long, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntItemCd As Variant, Optional ByRef vntSuffix As Variant, _
    Optional ByRef vntResultType As Variant, Optional ByRef vntItemType As Variant, _
    Optional ByRef vntItemName As Variant, _
    Optional ByRef vntFigure1 As Variant, Optional ByRef vntFigure2 As Variant, _
    Optional ByRef vntMaxValue As Variant, Optional ByRef vntMinValue As Variant, _
    Optional ByRef vntUnit As Variant, _
    Optional ByRef vntRslFlg As Variant, Optional ByRef vntResult As Variant, Optional ByRef vntStopFlg As Variant, _
    Optional ByRef vntRslCmtCd1 As Variant, Optional ByRef vntRslCmtName1 As Variant, _
    Optional ByRef vntRslCmtCd2 As Variant, Optional ByRef vntRslCmtName2 As Variant, _
    Optional ByRef vntLstCslDate As Variant, Optional ByRef vntLstRsvNo As Variant, _
    Optional ByRef vntLstRslFlg As Variant, Optional ByRef vntLstResult As Variant, Optional ByRef vntLstStopFlg As Variant, _
    Optional ByRef vntLstRslCmtCd1 As Variant, Optional ByRef vntLstRslCmtName1 As Variant, _
    Optional ByRef vntLstRslCmtCd2 As Variant, Optional ByRef vntLstRslCmtName2 As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objCslDate          As OraField         '受診日
    Dim objRsvNo            As OraField         '予約番号
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objResultType       As OraField         '結果タイプ
    Dim objItemType         As OraField         '項目タイプ
    Dim objItemName         As OraField         '検査項目名称
    Dim objFigure1          As OraField         '整数部桁数
    Dim objFigure2          As OraField         '小数部桁数
    Dim objMaxValue         As OraField         '最大値
    Dim objMinValue         As OraField         '最小値
    Dim objUnit             As OraField         '単位
    Dim objRslFlg           As OraField         '検査結果存在フラグ
    Dim objResult           As OraField         '検査結果
    Dim objStopFlg          As OraField         '検査中止フラグ
    Dim objRslCmtCd1        As OraField         '結果コメント１
    Dim objRslCmtName1      As OraField         '結果コメント名１
    Dim objRslCmtCd2        As OraField         '結果コメント２
    Dim objRslCmtName2      As OraField         '結果コメント名２
    Dim objLstCslDate          As OraField      '前回受診日
    Dim objLstRsvNo            As OraField      '前回予約番号
    Dim objLstRslFlg           As OraField      '前回検査結果存在フラグ
    Dim objLstResult           As OraField      '前回検査結果
    Dim objLstStopFlg          As OraField      '前回検査中止フラグ
    Dim objLstRslCmtCd1        As OraField      '前回結果コメント１
    Dim objLstRslCmtName1      As OraField      '前回結果コメント名１
    Dim objLstRslCmtCd2        As OraField      '前回結果コメント２
    Dim objLstRslCmtName2      As OraField      '前回結果コメント名２
    
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrResultType()  As Variant          '結果タイプの配列
    Dim vntArrItemType()    As Variant          '項目タイプの配列
    Dim vntArrItemName()    As Variant          '検査項目名称の配列
    Dim vntArrFigure1()     As Variant          '整数部桁数の配列
    Dim vntArrFigure2()     As Variant          '小数部桁数の配列
    Dim vntArrMaxValue()    As Variant          '最大値の配列
    Dim vntArrMinValue()    As Variant          '最小値の配列
    Dim vntArrUnit()        As Variant          '単位の配列
    Dim vntArrRslFlg()      As Variant          '検査結果存在フラグの配列
    Dim vntArrResult()      As Variant          '検査結果の配列
    Dim vntArrStopFlg()     As Variant          '検査中止フラグの配列
    Dim vntArrRslCmtCd1()   As Variant          '結果コメント１の配列
    Dim vntArrRslCmtName1() As Variant          '結果コメント名１の配列
    Dim vntArrRslCmtCd2()   As Variant          '結果コメント２の配列
    Dim vntArrRslCmtName2() As Variant          '結果コメント名２の配列
    Dim vntArrLstCslDate()     As Variant       '前回受診日の配列
    Dim vntArrLstRsvNo()       As Variant       '前回予約番号の配列
    Dim vntArrLstRslFlg()      As Variant       '前回検査結果存在フラグの配列
    Dim vntArrLstResult()      As Variant       '前回検査結果の配列
    Dim vntArrLstStopFlg()     As Variant       '前回検査中止フラグの配列
    Dim vntArrLstRslCmtCd1()   As Variant       '前回結果コメント１の配列
    Dim vntArrLstRslCmtName1() As Variant       '前回結果コメント名１の配列
    Dim vntArrLstRslCmtCd2()   As Variant       '前回結果コメント２の配列
    Dim vntArrLstRslCmtName2() As Variant       '前回結果コメント名２の配列
    
    Dim lngCount            As Long             'レコード数
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
   
    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntItemCd) Then vntItemCd = Empty
    If Not IsMissing(vntSuffix) Then vntSuffix = Empty
    If Not IsMissing(vntResultType) Then vntResultType = Empty
    If Not IsMissing(vntItemType) Then vntItemType = Empty
    If Not IsMissing(vntItemName) Then vntItemName = Empty
    If Not IsMissing(vntFigure1) Then vntFigure1 = Empty
    If Not IsMissing(vntFigure2) Then vntFigure2 = Empty
    If Not IsMissing(vntMaxValue) Then vntMaxValue = Empty
    If Not IsMissing(vntMinValue) Then vntMinValue = Empty
    If Not IsMissing(vntUnit) Then vntUnit = Empty
    If Not IsMissing(vntRslFlg) Then vntRslFlg = Empty
    If Not IsMissing(vntResult) Then vntResult = Empty
    If Not IsMissing(vntStopFlg) Then vntStopFlg = Empty
    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = Empty
    If Not IsMissing(vntRslCmtName1) Then vntRslCmtName1 = Empty
    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = Empty
    If Not IsMissing(vntRslCmtName2) Then vntRslCmtName2 = Empty
    If Not IsMissing(vntLstCslDate) Then vntLstCslDate = Empty
    If Not IsMissing(vntLstRsvNo) Then vntLstRsvNo = Empty
    If Not IsMissing(vntLstRslFlg) Then vntLstRslFlg = Empty
    If Not IsMissing(vntLstResult) Then vntLstResult = Empty
    If Not IsMissing(vntLstStopFlg) Then vntLstStopFlg = Empty
    If Not IsMissing(vntLstRslCmtCd1) Then vntLstRslCmtCd1 = Empty
    If Not IsMissing(vntLstRslCmtName1) Then vntLstRslCmtName1 = Empty
    If Not IsMissing(vntLstRslCmtCd2) Then vntLstRslCmtCd2 = Empty
    If Not IsMissing(vntLstRslCmtName2) Then vntLstRslCmtName2 = Empty
   
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GRPCD", IIf(strGrpCd = Null, "", Trim(strGrpCd)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    strStmt = _
        "SELECT FINALRSL.PERID, FINALRSL.CSLDATE,       " & vbLf & _
        "       FINALRSL.RSVNO, FINALRSL.SEQ,           " & vbLf & _
        "       FINALRSL.ITEMCD, FINALRSL.SUFFIX,       " & vbLf & _
        "       ITEM_C.RESULTTYPE, ITEM_C.ITEMTYPE,     " & vbLf & _
        "       ITEM_C.ITEMNAME,                        " & vbLf & _
        "       ITEM_H.FIGURE1, ITEM_H.FIGURE2,         " & vbLf & _
        "       ITEM_H.MAXVALUE, ITEM_H.MINVALUE,       " & vbLf & _
        "       ITEM_H.UNIT,                            " & vbLf
    '今回値
    strStmt = strStmt & _
        "       FINALRSL.RSLFLG RSLFLG,                 " & vbLf & _
        "       FINALRSL.RESULT RESULT,                 " & vbLf & _
        "       FINALRSL.STOPFLG STOPFLG,               " & vbLf & _
        "       FINALRSL.RSLCMTCD1 RSLCMTCD1,           " & vbLf
    If Not IsMissing(vntRslCmtName1) Then   '結果コメント要
        strStmt = strStmt & _
        "       (SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
        "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD1) RSLCMTNAME1,   " & vbLf
    Else
        strStmt = strStmt & _
        "       NULL RSLCMTNAME1,                       " & vbLf
    End If
    
    strStmt = strStmt & _
        "       FINALRSL.RSLCMTCD2 RSLCMTCD2,           " & vbLf
    If Not IsMissing(vntRslCmtName2) Then   '結果コメント要
        strStmt = strStmt & _
        "       (SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
        "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD2) RSLCMTNAME2,   " & vbLf
    Else
        strStmt = strStmt & _
        "       NULL RSLCMTNAME2,                       " & vbLf
    End If
    '前回値
    strStmt = strStmt & _
        "       LASTRSL.CSLDATE LSTCSLDATE,             " & vbLf & _
        "       LASTRSL.RSVNO LSTRSVNO,                 " & vbLf & _
        "       LASTRSL.RSLFLG LSTRSLFLG,               " & vbLf & _
        "       LASTRSL.RESULT LSTRESULT,               " & vbLf & _
        "       LASTRSL.STOPFLG LSTSTOPFLG,             " & vbLf & _
        "       LASTRSL.RSLCMTCD1 LSTRSLCMTCD1,         " & vbLf
    If Not IsMissing(vntLstRslCmtName1) Then   '結果コメント要
        strStmt = strStmt & _
        "       (SELECT RSLCMTNAME FROM RSLCMT                          " & vbLf & _
        "         WHERE RSLCMTCD = LASTRSL.RSLCMTCD1) LSTRSLCMTNAME1,   " & vbLf
    Else
        strStmt = strStmt & _
        "       NULL LSTRSLCMTNAME1,                    " & vbLf
    End If
    
    strStmt = strStmt & _
        "       LASTRSL.RSLCMTCD2 LSTRSLCMTCD2,         " & vbLf
    If Not IsMissing(vntLstRslCmtName2) Then   '結果コメント要
        strStmt = strStmt & _
        "       (SELECT RSLCMTNAME FROM RSLCMT                          " & vbLf & _
        "         WHERE RSLCMTCD = LASTRSL.RSLCMTCD2) LSTRSLCMTNAME2    " & vbLf
    Else
        strStmt = strStmt & _
        "       NULL LSTRSLCMTNAME2                     " & vbLf
    End If

    '-------------------------------------------------------------------------------
    '検査結果View（検査結果が存在しない場合の対応）
    '-------------------------------------------------------------------------------
    strStmt = strStmt & _
        "  FROM (                                                       " & vbLf & _
        "       SELECT CSLDATE, RSVNO, PERID,                           " & vbLf & _
        "              SEQ, ITEMCD, SUFFIX,                             " & vbLf & _
        "              MAX(RESULT) RESULT,                              " & vbLf & _
        "              MAX(STDVALUECD) STDVALUECD,                      " & vbLf & _
        "              MAX(RSLCMTCD1) RSLCMTCD1,                        " & vbLf & _
        "              MAX(RSLCMTCD2) RSLCMTCD2,                        " & vbLf & _
        "              MAX(STOPFLG) STOPFLG,                            " & vbLf & _
        "              MAX(RSLFLG) RSLFLG                               " & vbLf & _
        "         FROM (                                                "
    '検査結果に存在するレコード(OCR未チェックのときはRSLOCR、OCRチェック済のときはRSLより読込)
    strStmt = strStmt & _
        "              SELECT CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,   " & vbLf & _
        "                     CONSULTVIEW.PERID, GRP_I.SEQ,             " & vbLf & _
        "                     RSL.ITEMCD, RSL.SUFFIX,                   " & vbLf & _
        "                     RSL.RESULT, RSL.STDVALUECD,               " & vbLf & _
        "                     RSL.RSLCMTCD1, RSL.RSLCMTCD2,             " & vbLf & _
        "                     RSL.STOPFLG,                              " & vbLf & _
        "                     1 RSLFLG                                  " & vbLf & _
        "                FROM (                                         " & vbLf & _
        "                     SELECT CONSULT.CSLDATE,                   " & vbLf & _
        "                            CONSULT.RSVNO,                     " & vbLf & _
        "                            CONSULT.PERID                      " & vbLf & _
        "                       FROM CONSULT                            " & vbLf & _
        "                      WHERE CONSULT.RSVNO = :RSVNO             " & vbLf & _
        "                        AND CONSULT.CANCELFLG = 0              " & vbLf & _
        "                     ) CONSULTVIEW, GRP_I,                     " & vbLf & _
        IIf(lngOcrCheck = 0, "RSLOCR", "RSL") & " RSL                   " & vbLf & _
        "               WHERE CONSULTVIEW.RSVNO = RSL.RSVNO             " & vbLf & _
        "                 AND GRP_I.GRPCD = :GRPCD                      " & vbLf & _
        "                 AND GRP_I.ITEMCD = RSL.ITEMCD                 " & vbLf & _
        "                 AND GRP_I.SUFFIX = RSL.SUFFIX                 "
    
    '検査結果項目の空レコード
    strStmt = strStmt & _
        "              UNION ALL                                        " & vbLf & _
        "              SELECT CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,   " & vbLf & _
        "                     CONSULTVIEW.PERID, GRP_I.SEQ,             " & vbLf & _
        "                     GRP_I.ITEMCD, GRP_I.SUFFIX,               " & vbLf & _
        "                     NULL RESULT, NULL STDVALUECD,             " & vbLf & _
        "                     NULL RSLCMTCD1, NULL RSLCMTCD2,           " & vbLf & _
        "                     NULL STOPFLG,                             " & vbLf & _
        "                     0 RSLFLG                                  " & vbLf & _
        "                FROM (                                         " & vbLf & _
        "                     SELECT CONSULT.CSLDATE,                   " & vbLf & _
        "                            CONSULT.RSVNO,                     " & vbLf & _
        "                            CONSULT.PERID                      " & vbLf & _
        "                       FROM CONSULT                            " & vbLf & _
        "                      WHERE CONSULT.RSVNO = :RSVNO             " & vbLf & _
        "                        AND CONSULT.CANCELFLG = 0              " & vbLf & _
        "                     ) CONSULTVIEW, GRP_I                      " & vbLf & _
        "               WHERE GRP_I.GRPCD = :GRPCD                      "

    strStmt = strStmt & _
        "              )                                                " & vbLf & _
        "       GROUP BY CSLDATE, RSVNO, PERID, SEQ, ITEMCD, SUFFIX     " & vbLf & _
        "       ) FINALRSL,                                             "

    '-------------------------------------------------------------------------------
    '前回検査結果View（前回検査結果＋個人検査結果、検査結果が存在しない場合の対応）
    '-------------------------------------------------------------------------------
    strStmt = strStmt & _
        "       (                                                               " & vbLf & _
        "       SELECT RSLVIEW.CSLDATE, RSLVIEW.RSVNO, RSLVIEW.PERID,           " & vbLf & _
        "              RSLVIEW.SEQ, RSLVIEW.ITEMCD, RSLVIEW.SUFFIX,             " & vbLf & _
        "              NVL(PERRSLVIEW.RESULT, RSLVIEW.RESULT) RESULT,           " & vbLf & _
        "              RSLVIEW.STDVALUECD,                                      " & vbLf & _
        "              RSLVIEW.RSLCMTCD1,                                       " & vbLf & _
        "              RSLVIEW.RSLCMTCD2,                                       " & vbLf & _
        "              RSLVIEW.STOPFLG,                                         " & vbLf & _
        "              NVL(PERRSLVIEW.RSLFLG, RSLVIEW.RSLFLG) RSLFLG            " & vbLf & _
        "         FROM (                                                        "
    
    strStmt = strStmt & _
        "              SELECT CSLDATE, RSVNO, PERID,                            " & vbLf & _
        "                     SEQ, ITEMCD, SUFFIX,                              " & vbLf & _
        "                     MAX(RESULT) RESULT,                               " & vbLf & _
        "                     MAX(STDVALUECD) STDVALUECD,                       " & vbLf & _
        "                     MAX(RSLCMTCD1) RSLCMTCD1,                         " & vbLf & _
        "                     MAX(RSLCMTCD2) RSLCMTCD2,                         " & vbLf & _
        "                     MAX(STOPFLG) STOPFLG,                             " & vbLf & _
        "                     MAX(RSLFLG) RSLFLG                                " & vbLf & _
        "                FROM (                                                 "
    '検査結果に存在するレコード
    strStmt = strStmt & _
        "                     SELECT CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,    " & vbLf & _
        "                            CONSULTVIEW.PERID, GRP_I.SEQ,              " & vbLf & _
        "                            RSL.ITEMCD, RSL.SUFFIX,                    " & vbLf & _
        "                            RSL.RESULT, RSL.STDVALUECD,                " & vbLf & _
        "                            RSL.RSLCMTCD1, RSL.RSLCMTCD2,              " & vbLf & _
        "                            RSL.STOPFLG,                               " & vbLf & _
        "                            1 RSLFLG                                   " & vbLf & _
        "                       FROM (                                          " & vbLf & _
        "                            SELECT /*+ INDEX_DESC(CONSULT CONSULT_INDEX4) */ CONSULT.CSLDATE,  " & vbLf & _
        "                                   CONSULT.RSVNO,                      " & vbLf & _
        "                                   CONSULT.PERID                       " & vbLf & _
        "                              FROM CONSULT                             " & vbLf & _
        "                             WHERE CONSULT.PERID =                     " & vbLf & _
        "                                   (SELECT DISTINCT PERID              " & vbLf & _
        "                                      FROM CONSULT                     " & vbLf & _
        "                                     WHERE RSVNO = :RSVNO)             " & vbLf & _
        "                               AND CONSULT.CSLDATE <                   " & vbLf & _
        "                                   (SELECT DISTINCT CSLDATE            " & vbLf & _
        "                                      FROM CONSULT                     " & vbLf & _
        "                                     WHERE RSVNO = :RSVNO)             "
    'コース指定
    Select Case lngLastDspMode
        Case 1
            strStmt = strStmt & vbLf & _
        "                               AND CONSULT.CSCD = :CSCD                "
        Case 2
            strStmt = strStmt & vbLf & _
        "                               AND CONSULT.CSCD                        " & vbLf & _
        "                                   IN (SELECT FREEFIELD1 CSCD          " & vbLf & _
        "                                         FROM FREE                     " & vbLf & _
        "                                        WHERE FREECD LIKE :CSCD||'%')  "
    End Select
    strStmt = strStmt & _
        "                               AND CONSULT.CANCELFLG = 0               " & vbLf & _
        "                               AND ROWNUM = 1                          " & vbLf & _
        "                            ) CONSULTVIEW, RSL, GRP_I                  " & vbLf & _
        "                      WHERE CONSULTVIEW.RSVNO = RSL.RSVNO              " & vbLf & _
        "                        AND GRP_I.GRPCD = :GRPCD                       " & vbLf & _
        "                        AND GRP_I.ITEMCD = RSL.ITEMCD                  " & vbLf & _
        "                        AND GRP_I.SUFFIX = RSL.SUFFIX                  "
    
    '検査結果項目の空レコード
    strStmt = strStmt & _
        "                     UNION ALL                                         " & vbLf & _
        "                     SELECT CONSULTVIEW.CSLDATE, CONSULTVIEW.RSVNO,    " & vbLf & _
        "                            CONSULTVIEW.PERID, GRP_I.SEQ,              " & vbLf & _
        "                            GRP_I.ITEMCD, GRP_I.SUFFIX,                " & vbLf & _
        "                            NULL RESULT, NULL STDVALUECD,              " & vbLf & _
        "                            NULL RSLCMTCD1, NULL RSLCMTCD2,            " & vbLf & _
        "                            NULL STOPFLG,                              " & vbLf & _
        "                            0 RSLFLG                                   " & vbLf & _
        "                       FROM (                                          " & vbLf & _
        "                            SELECT /*+ INDEX_DESC(CONSULT CONSULT_INDEX4) */ CONSULT.CSLDATE,  " & vbLf & _
        "                                   CONSULT.RSVNO,                      " & vbLf & _
        "                                   CONSULT.PERID                       " & vbLf & _
        "                              FROM CONSULT                             " & vbLf & _
        "                             WHERE CONSULT.PERID =                     " & vbLf & _
        "                                   (SELECT DISTINCT PERID              " & vbLf & _
        "                                      FROM CONSULT                     " & vbLf & _
        "                                     WHERE RSVNO = :RSVNO)             " & vbLf & _
        "                               AND CONSULT.CSLDATE <                   " & vbLf & _
        "                                   (SELECT DISTINCT CSLDATE            " & vbLf & _
        "                                      FROM CONSULT                     " & vbLf & _
        "                                     WHERE RSVNO = :RSVNO)             "
    'コース指定
    Select Case lngLastDspMode
        Case 1
            strStmt = strStmt & vbLf & _
        "                               AND CONSULT.CSCD = :CSCD                "
        Case 2
            strStmt = strStmt & vbLf & _
        "                               AND CONSULT.CSCD                        " & vbLf & _
        "                                   IN (SELECT FREEFIELD1 CSCD          " & vbLf & _
        "                                         FROM FREE                     " & vbLf & _
        "                                        WHERE FREECD LIKE :CSCD||'%')  "
    End Select
    strStmt = strStmt & _
        "                               AND CONSULT.CANCELFLG = 0               " & vbLf & _
        "                               AND ROWNUM = 1                          " & vbLf & _
        "                            ) CONSULTVIEW, GRP_I                       " & vbLf & _
        "                      WHERE GRP_I.GRPCD = :GRPCD                       "
      
    strStmt = strStmt & _
        "                      )                                                " & vbLf & _
        "              GROUP BY CSLDATE, RSVNO, PERID, SEQ, ITEMCD, SUFFIX      " & vbLf & _
        "              ) RSLVIEW,                                               "
    
    '個人検査結果View
'### 2004/06/28 Updated by Ishihara@FSIT 個人検査結果は参照しない（かなり強引な修正ですが勘弁してください）
'    strStmt = strStmt & _
        "              (                                                        " & vbLf & _
        "              SELECT PERRESULT.ITEMCD, PERRESULT.SUFFIX,               " & vbLf & _
        "                     GRP_I.SEQ, PERRESULT.RESULT,                      " & vbLf & _
        "                     2 RSLFLG                                          " & vbLf & _
        "                FROM (                                                 " & vbLf & _
        "                     SELECT CONSULT.CSLDATE,                           " & vbLf & _
        "                            CONSULT.RSVNO,                             " & vbLf & _
        "                            CONSULT.PERID                              " & vbLf & _
        "                       FROM CONSULT                                    " & vbLf & _
        "                      WHERE CONSULT.RSVNO = :RSVNO                     " & vbLf & _
        "                        AND CONSULT.CANCELFLG = 0                      " & vbLf & _
        "                     ) CONSULTVIEW, PERRESULT, GRP_I                   " & vbLf & _
        "               WHERE CONSULTVIEW.PERID = PERRESULT.PERID               " & vbLf & _
        "                 AND GRP_I.GRPCD = :GRPCD                              " & vbLf & _
        "                 AND GRP_I.ITEMCD = PERRESULT.ITEMCD                   " & vbLf & _
        "                 AND GRP_I.SUFFIX = PERRESULT.SUFFIX                   " & vbLf & _
        "              ) PERRSLVIEW                                             "
    strStmt = strStmt & _
        "              (                                   " & vbLf & _
        "              SELECT NULL ITEMCD,  NULL SUFFIX,   " & vbLf & _
        "                     NULL SEQ, NULL RESULT,       " & vbLf & _
        "                     2 RSLFLG                     " & vbLf & _
        "                FROM DUAL                         " & vbLf & _
        "               WHERE 1 = 2                        " & vbLf & _
        "              ) PERRSLVIEW                        "
'### 2004/06/28 Updated End

    strStmt = strStmt & _
        "        WHERE RSLVIEW.ITEMCD = PERRSLVIEW.ITEMCD(+)                    " & vbLf & _
        "          AND RSLVIEW.SUFFIX = PERRSLVIEW.SUFFIX(+)                    " & vbLf & _
        "       ) LASTRSL,                                                      "
    
    strStmt = strStmt & vbLf & _
        "       ITEM_C, ITEM_H                                                  "
    
    strStmt = strStmt & vbLf & _
        " WHERE FINALRSL.ITEMCD = ITEM_C.ITEMCD                         " & vbLf & _
        "   AND FINALRSL.SUFFIX = ITEM_C.SUFFIX                         " & vbLf & _
        "   AND FINALRSL.ITEMCD = ITEM_H.ITEMCD　                       " & vbLf & _
        "   AND FINALRSL.SUFFIX = ITEM_H.SUFFIX　                       " & vbLf & _
        "   AND FINALRSL.CSLDATE BETWEEN ITEM_H.STRDATE                 " & vbLf & _
        "                            AND ITEM_H.ENDDATE                 " & vbLf & _
        "   AND FINALRSL.ITEMCD = LASTRSL.ITEMCD(+)                     " & vbLf & _
        "   AND FINALRSL.SUFFIX = LASTRSL.SUFFIX(+)                     "

    strStmt = strStmt & vbLf & _
        " ORDER BY FINALRSL.SEQ,                                        " & vbLf & _
        "          FINALRSL.CSLDATE DESC                                "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objCslDate = objFields("CSLDATE")
        Set objRsvNo = objFields("RSVNO")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objResultType = objFields("RESULTTYPE")
        Set objItemType = objFields("ITEMTYPE")
        Set objItemName = objFields("ITEMNAME")
        Set objFigure1 = objFields("FIGURE1")
        Set objFigure2 = objFields("FIGURE2")
        Set objMaxValue = objFields("MAXVALUE")
        Set objMinValue = objFields("MINVALUE")
        Set objUnit = objFields("UNIT")
        Set objRslFlg = objFields("RSLFLG")
        Set objResult = objFields("RESULT")
        Set objStopFlg = objFields("STOPFLG")
        Set objRslCmtCd1 = objFields("RSLCMTCD1")
        Set objRslCmtName1 = objFields("RSLCMTNAME1")
        Set objRslCmtCd2 = objFields("RSLCMTCD2")
        Set objRslCmtName2 = objFields("RSLCMTNAME1")
        Set objLstCslDate = objFields("LSTCSLDATE")
        Set objLstRsvNo = objFields("LSTRSVNO")
        Set objLstRslFlg = objFields("LSTRSLFLG")
        Set objLstResult = objFields("LSTRESULT")
        Set objLstStopFlg = objFields("LSTSTOPFLG")
        Set objLstRslCmtCd1 = objFields("LSTRSLCMTCD1")
        Set objLstRslCmtName1 = objFields("LSTRSLCMTNAME1")
        Set objLstRslCmtCd2 = objFields("LSTRSLCMTCD2")
        Set objLstRslCmtName2 = objFields("LSTRSLCMTNAME1")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
        
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrResultType(lngCount)
            ReDim Preserve vntArrItemType(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrFigure1(lngCount)
            ReDim Preserve vntArrFigure2(lngCount)
            ReDim Preserve vntArrMaxValue(lngCount)
            ReDim Preserve vntArrMinValue(lngCount)
            ReDim Preserve vntArrUnit(lngCount)
            ReDim Preserve vntArrRslFlg(lngCount)
            ReDim Preserve vntArrResult(lngCount)
            ReDim Preserve vntArrStopFlg(lngCount)
            ReDim Preserve vntArrRslCmtCd1(lngCount)
            ReDim Preserve vntArrRslCmtName1(lngCount)
            ReDim Preserve vntArrRslCmtCd2(lngCount)
            ReDim Preserve vntArrRslCmtName2(lngCount)
            ReDim Preserve vntArrLstCslDate(lngCount)
            ReDim Preserve vntArrLstRsvNo(lngCount)
            ReDim Preserve vntArrLstRslFlg(lngCount)
            ReDim Preserve vntArrLstResult(lngCount)
            ReDim Preserve vntArrLstStopFlg(lngCount)
            ReDim Preserve vntArrLstRslCmtCd1(lngCount)
            ReDim Preserve vntArrLstRslCmtName1(lngCount)
            ReDim Preserve vntArrLstRslCmtCd2(lngCount)
            ReDim Preserve vntArrLstRslCmtName2(lngCount)
            
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrResultType(lngCount) = objResultType.Value & ""
            vntArrItemType(lngCount) = objItemType.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrFigure1(lngCount) = objFigure1.Value & ""
            vntArrFigure2(lngCount) = objFigure2.Value & ""
            vntArrMaxValue(lngCount) = objMaxValue.Value & ""
            vntArrMinValue(lngCount) = objMinValue.Value & ""
            vntArrUnit(lngCount) = objUnit.Value & ""
            vntArrRslFlg(lngCount) = objRslFlg.Value & ""
            vntArrResult(lngCount) = objResult.Value & ""
            vntArrStopFlg(lngCount) = objStopFlg.Value & ""
            vntArrRslCmtCd1(lngCount) = objRslCmtCd1.Value & ""
            vntArrRslCmtName1(lngCount) = objRslCmtName1.Value & ""
            vntArrRslCmtCd2(lngCount) = objRslCmtCd2.Value & ""
            vntArrRslCmtName2(lngCount) = objRslCmtName2.Value & ""
            vntArrLstCslDate(lngCount) = objLstCslDate.Value & ""
            vntArrLstRsvNo(lngCount) = objLstRsvNo.Value & ""
            vntArrLstRslFlg(lngCount) = objLstRslFlg.Value & ""
            vntArrLstResult(lngCount) = objLstResult.Value & ""
            vntArrLstStopFlg(lngCount) = objLstStopFlg.Value & ""
            vntArrLstRslCmtCd1(lngCount) = objLstRslCmtCd1.Value & ""
            vntArrLstRslCmtName1(lngCount) = objLstRslCmtName1.Value & ""
            vntArrLstRslCmtCd2(lngCount) = objLstRslCmtCd2.Value & ""
            vntArrLstRslCmtName2(lngCount) = objLstRslCmtName2.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
    If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
    If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
    If Not IsMissing(vntItemCd) Then vntItemCd = vntArrItemCd
    If Not IsMissing(vntSuffix) Then vntSuffix = vntArrSuffix
    If Not IsMissing(vntResultType) Then vntResultType = vntArrResultType
    If Not IsMissing(vntItemType) Then vntItemType = vntArrItemType
    If Not IsMissing(vntItemName) Then vntItemName = vntArrItemName
    If Not IsMissing(vntFigure1) Then vntFigure1 = vntArrFigure1
    If Not IsMissing(vntFigure2) Then vntFigure2 = vntArrFigure2
    If Not IsMissing(vntMaxValue) Then vntMaxValue = vntArrMaxValue
    If Not IsMissing(vntMinValue) Then vntMinValue = vntArrMinValue
    If Not IsMissing(vntUnit) Then vntUnit = vntArrUnit
    If Not IsMissing(vntRslFlg) Then vntRslFlg = vntArrRslFlg
    If Not IsMissing(vntResult) Then vntResult = vntArrResult
    If Not IsMissing(vntStopFlg) Then vntStopFlg = vntArrStopFlg
    If Not IsMissing(vntRslCmtCd1) Then vntRslCmtCd1 = vntArrRslCmtCd1
    If Not IsMissing(vntRslCmtName1) Then vntRslCmtName1 = vntArrRslCmtName1
    If Not IsMissing(vntRslCmtCd2) Then vntRslCmtCd2 = vntArrRslCmtCd2
    If Not IsMissing(vntRslCmtName2) Then vntRslCmtName2 = vntArrRslCmtName2
    If Not IsMissing(vntLstCslDate) Then vntLstCslDate = vntArrLstCslDate
    If Not IsMissing(vntLstRsvNo) Then vntLstRsvNo = vntArrLstRsvNo
    If Not IsMissing(vntLstRslFlg) Then vntLstRslFlg = vntArrLstRslFlg
    If Not IsMissing(vntLstResult) Then vntLstResult = vntArrLstResult
    If Not IsMissing(vntLstStopFlg) Then vntLstStopFlg = vntArrLstStopFlg
    If Not IsMissing(vntLstRslCmtCd1) Then vntLstRslCmtCd1 = vntArrLstRslCmtCd1
    If Not IsMissing(vntLstRslCmtName1) Then vntLstRslCmtName1 = vntArrLstRslCmtName1
    If Not IsMissing(vntLstRslCmtCd2) Then vntLstRslCmtCd2 = vntArrLstRslCmtCd2
    If Not IsMissing(vntLstRslCmtName2) Then vntLstRslCmtName2 = vntArrLstRslCmtName2
    
    SelectRslOcr = lngCount
        
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
    WriteErrorLog "RslOcrSp.SelectRslOcr"
    
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
' 機能　　 : ＯＣＲ入力結果の入力チェック
'
' 引数　　 : (In)     lngRsvNo       予約番号
' 　　　　   (Out)    vntErrNo       エラーNo
' 　　　　   (Out)    vntErrState    エラー状態
' 　　　　   (Out)    vntErrMsg      エラーメッセージ
'
' 戻り値　 : エラー件数
'
' 備考　　 :
'
Private Function CheckRslOcr( _
    ByVal lngRsvNo As Long, _
    ByRef vntErrNo As Variant, _
    ByRef vntErrState As Variant, _
    ByRef vntErrMsg As Variant _
) As Long
    
    Dim objPerson           As Object       '個人情報アクセス用
    Dim vntGender           As Variant      '性別
    
    Dim objResult           As Object       '検査結果アクセス用
    Dim chkItemCd           As Variant      '検査項目コード
    Dim chkSuffix           As Variant      'サフィックス
    Dim chkResult           As Variant      '検査結果
    Dim chkResultErr        As Variant      '検査結果エラー
    Dim chkShortStc         As Variant      '文章略称
    Dim lngItemCnt          As Long         '検査項目数
    
    Dim objRslOcrSp         As RslOcrSp
    Dim ArrItem1            As Variant
    Dim ArrItem2            As Variant
    Dim ArrItem3            As Variant
    Dim ArrItem4            As Variant
    
    Dim strUniqueKey        As String       'コレクションの対象キー
    Dim vntPerId            As Variant      '個人ID
    Dim vntCslDate          As Variant      '受診日
    Dim vntResult           As Variant      '検査結果
    Dim i                   As Long         'ループカウンタ
    Dim blnZero             As Boolean      '０記入チェック結果
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
      
    'エラー情報の初期化
    lngOcrErrCnt = 0
    If Not IsArray(vntOcrErrNo) Then vntOcrErrNo = Array()
    If Not IsArray(vntOcrErrState) Then vntOcrErrState = Array()
    If Not IsArray(vntOcrErrMsg) Then vntOcrErrMsg = Array()
        
    vntPerId = mcolOcrNyuryoku(OCR_ITEM001).PerId
    vntCslDate = mcolOcrNyuryoku(OCR_ITEM001).CslDate
    
    '個人情報を取得する
    Set objPerson = CreateObject("HainsPerson.Person")
    objPerson.SelectPerson_lukes vntPerId, , , , , , , vntGender
    Set objPerson = Nothing

'胃Ｘ線の依頼があればブスコパンのチェックを行う   2004/01/19
    '-------------------------------------------------------------------------------
    '胃Ｘ線の依頼があるかチェック（依頼なしのときは、ブスコパンの入力チェックをしない）
    '-------------------------------------------------------------------------------
    If CheckStomach(lngRsvNo) = 1 Then
        blnStomachFlg = True
    Else
        blnStomachFlg = False
    End If
    
    '-------------------------------------------------------------------------------
    '婦人科の依頼があるかチェック（依頼なしのときは、婦人科問診の入力チェックをしない）
    '-------------------------------------------------------------------------------
    If CheckFujinka(lngRsvNo) = 1 Then
        blnFujinkaFlg = True
    Else
        blnFujinkaFlg = False
    End If
    
    '***************************************************************************************
    '単体の入力チェック
    '***************************************************************************************
    lngItemCnt = 0
    chkItemCd = Array()
    chkSuffix = Array()
    chkResult = Array()
    chkResultErr = Array()
    chkShortStc = Array()
    
    For Each objRslOcrSp In mcolOcrNyuryoku
        ReDim Preserve chkItemCd(lngItemCnt)
        ReDim Preserve chkSuffix(lngItemCnt)
        ReDim Preserve chkResult(lngItemCnt)
        ReDim Preserve chkResultErr(lngItemCnt)
        ReDim Preserve chkShortStc(lngItemCnt)
        
        With objRslOcrSp
            chkItemCd(lngItemCnt) = .ItemCd
            chkSuffix(lngItemCnt) = .Suffix
            chkResult(lngItemCnt) = .Result
        End With
        
        lngItemCnt = lngItemCnt + 1
    Next objRslOcrSp
        
    '検査結果入力チェック
    Set objResult = CreateObject("HainsResult.Result")
    objResult.CheckResult vntCslDate, chkItemCd, chkSuffix, chkResult, chkShortStc, chkResultErr
    Set objResult = Nothing
    For i = 0 To lngItemCnt - 1
        'エラーあり？
        If chkResultErr(i) <> "" Then
            strUniqueKey = chkItemCd(i) & "-" & chkSuffix(i)
            Call EditOcrError(strUniqueKey, OCR_ERRSTAT_ERROR, chkResultErr(i), mcolOcrNyuryoku(strUniqueKey).ItemName)
        End If
    Next

    
    '***************************************************************************************
    '現病歴・既往歴問診票
    '***************************************************************************************
'胃Ｘ線の依頼があればブスコパンのチェックを行う   2004/01/19
    '胃Ｘ線の依頼があるときだけ入力チェック
    If blnStomachFlg = True Then
        '--------------------------------------------
        'ブスコパン可否
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM001).Result = "" Then
            
            Call EditOcrError(OCR_ITEM001, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM001).ItemName)
        End If
    End If
    
    '--------------------------------------------
    '現病歴
    '--------------------------------------------
    ArrItem1 = Array(OCR_ITEM003, OCR_ITEM006, OCR_ITEM009, OCR_ITEM012, OCR_ITEM015, OCR_ITEM018)
    ArrItem2 = Array(OCR_ITEM004, OCR_ITEM007, OCR_ITEM010, OCR_ITEM013, OCR_ITEM016, OCR_ITEM019)
    ArrItem3 = Array(OCR_ITEM005, OCR_ITEM008, OCR_ITEM011, OCR_ITEM014, OCR_ITEM017, OCR_ITEM020)
    For i = 0 To UBound(ArrItem1)
        '「発症年齢」又は「治療状況」に記入があり、「病名」未記入の場合
        If mcolOcrNyuryoku(ArrItem1(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
        End If
        '「病名」又は「治療状況」に記入があり、「発症年齢」未記入の場合
        If mcolOcrNyuryoku(ArrItem2(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem2(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem2(i)).ItemName)
        End If
        '「病名」又は「発症年齢」に記入があり、「治療状況」未記入の場合
        If mcolOcrNyuryoku(ArrItem3(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem2(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem3(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem3(i)).ItemName)
        End If
    Next
    
    '--------------------------------------------
    '既往歴
    '--------------------------------------------
    ArrItem1 = Array(OCR_ITEM021, OCR_ITEM024, OCR_ITEM027, OCR_ITEM030, OCR_ITEM033, OCR_ITEM036)
    ArrItem2 = Array(OCR_ITEM022, OCR_ITEM025, OCR_ITEM028, OCR_ITEM031, OCR_ITEM034, OCR_ITEM037)
    ArrItem3 = Array(OCR_ITEM023, OCR_ITEM026, OCR_ITEM029, OCR_ITEM032, OCR_ITEM035, OCR_ITEM038)
    For i = 0 To UBound(ArrItem1)
        '「発症年齢」又は「治療状況」に記入があり、「病名」未記入の場合
        If mcolOcrNyuryoku(ArrItem1(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
        End If
        '「病名」又は「治療状況」に記入があり、「発症年齢」未記入の場合
        If mcolOcrNyuryoku(ArrItem2(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem2(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem2(i)).ItemName)
        End If
        '「病名」又は「発症年齢」に記入があり、「治療状況」未記入の場合
        If mcolOcrNyuryoku(ArrItem3(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem2(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem3(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem3(i)).ItemName)
        End If
    Next
    
    '--------------------------------------------
    '家族歴
    '--------------------------------------------
    ArrItem1 = Array(OCR_ITEM039, OCR_ITEM042, OCR_ITEM045, OCR_ITEM048, OCR_ITEM051, OCR_ITEM054)
    ArrItem2 = Array(OCR_ITEM040, OCR_ITEM043, OCR_ITEM046, OCR_ITEM049, OCR_ITEM052, OCR_ITEM055)
    ArrItem3 = Array(OCR_ITEM041, OCR_ITEM044, OCR_ITEM047, OCR_ITEM050, OCR_ITEM053, OCR_ITEM056)
    For i = 0 To UBound(ArrItem1)
        '「発症年齢」又は「治療状況」に記入があり、「病名」未記入の場合
        If mcolOcrNyuryoku(ArrItem1(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
        End If
        '「病名」又は「発症年齢」に記入があり、「治療状況」未記入の場合
        If mcolOcrNyuryoku(ArrItem3(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem2(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem3(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem3(i)).ItemName)
        End If
    Next
   
    '--------------------------------------------
    '妊娠
    '--------------------------------------------
    '男性で「はい」または「いいえ」にﾁｪｯｸがある場合
    If vntGender = "1" And mcolOcrNyuryoku(OCR_ITEM058).Result <> "" Then
        
        Call EditOcrError(OCR_ITEM058, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_006, mcolOcrNyuryoku(OCR_ITEM058).ItemName, "男性")
    End If
    
    '***************************************************************************************
    '生活習慣病問診票（１）
    '***************************************************************************************
    '--------------------------------------------
    '体重変化値
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM087).Result = "" Then
        
        Call EditOcrError(OCR_ITEM087, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM087).ItemName)
    End If
    
    '--------------------------------------------
    '直近体重変動
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM088).Result = "" Then
        
        Call EditOcrError(OCR_ITEM088, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM088).ItemName)
    End If
   
    '--------------------------------------------
    '飲酒１（飲酒習慣）
    '--------------------------------------------
'    End If
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM089).Result = "" Then
        
        '「回数」に記入がない場合
        If mcolOcrNyuryoku(OCR_ITEM090).Result = "" Then
            Call EditOcrError(OCR_ITEM089, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM089).ItemName, "飲まない")
            mcolOcrNyuryoku(OCR_ITEM089).Result = "3"   '「飲まない」を登録
        Else
            Call EditOcrError(OCR_ITEM089, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM089).ItemName, "習慣的に飲む")
            mcolOcrNyuryoku(OCR_ITEM089).Result = "1"   '「習慣的に飲む」を登録
        End If
    End If
    
    '--------------------------------------------
    '現在飲酒回数
    '--------------------------------------------
    '「習慣的に飲む」に記入があり、「回数」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM090).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM089).Result = "1" Then
            
        Call EditOcrError(OCR_ITEM090, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM090).ItemName)
    End If
    '「ときどき飲む」に記入があり、「回数」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM090).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM089).Result = "2" Then
                
        Call EditOcrError(OCR_ITEM090, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM090).ItemName)
    End If
    
    '「飲まない」に記入があり、「回数」に記入がある場合
    If mcolOcrNyuryoku(OCR_ITEM090).Result <> "" And _
            mcolOcrNyuryoku(OCR_ITEM089).Result = "3" Then
        
        Call EditOcrError(OCR_ITEM090, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_005, mcolOcrNyuryoku(OCR_ITEM090).ItemName)
    End If
    
    '--------------------------------------------
    'ビール大瓶～その他
    '--------------------------------------------
    '「習慣的に飲む」に記入があり、飲酒量（「ビール大瓶」～「その他」）に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM089).Result = "1" And _
            mcolOcrNyuryoku(OCR_ITEM091).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM092).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM093).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM094).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM095).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM096).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM097).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM098).Result = "" Then
            
        Call EditOcrError(OCR_ITEM089, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_101, mcolOcrNyuryoku(OCR_ITEM089).ItemName)
    End If
    '「ときどき飲む」と「回数」に記入があり、飲酒量（「ビール大瓶」～「その他」）に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM089).Result = "2" And _
            mcolOcrNyuryoku(OCR_ITEM091).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM092).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM093).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM094).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM095).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM096).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM097).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM098).Result = "" Then
            
        Call EditOcrError(OCR_ITEM089, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_102, mcolOcrNyuryoku(OCR_ITEM089).ItemName)
    End If

    '--------------------------------------------
    '喫煙
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM099).Result = "" Then
        
        Call EditOcrError(OCR_ITEM099, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM099).ItemName, "吸わない")
        mcolOcrNyuryoku(OCR_ITEM099).Result = "2"   '「吸わない」を登録
    End If

    '--------------------------------------------
    '喫煙開始年齢
    '--------------------------------------------
    '「吸わない」が記入されているのに年齢が記入されている場合
    If mcolOcrNyuryoku(OCR_ITEM100).Result <> "" And _
            mcolOcrNyuryoku(OCR_ITEM099).Result = "2" Then
        
        Call EditOcrError(OCR_ITEM100, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, mcolOcrNyuryoku(OCR_ITEM100).ItemName)
    End If
    
    '「吸っている」「過去に吸っていた」に記入があり、「喫煙開始年齢」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM100).Result = "" And _
            (mcolOcrNyuryoku(OCR_ITEM099).Result = "1" Or _
             mcolOcrNyuryoku(OCR_ITEM099).Result = "3") Then
        
        Call EditOcrError(OCR_ITEM100, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM100).ItemName)
    End If

    '--------------------------------------------
    '喫煙終了年齢
    '--------------------------------------------
    '「吸わない」が記入されているのに年齢が記入されている場合
    If mcolOcrNyuryoku(OCR_ITEM101).Result <> "" And _
            mcolOcrNyuryoku(OCR_ITEM099).Result = "2" Then
        
        Call EditOcrError(OCR_ITEM101, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, mcolOcrNyuryoku(OCR_ITEM101).ItemName)
    End If

    '「過去に吸っていた」に記入があり、「喫煙終了年齢」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM101).Result = "" And _
            mcolOcrNyuryoku(OCR_ITEM099).Result = "3" Then
        
        Call EditOcrError(OCR_ITEM101, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM101).ItemName)
    End If

    '--------------------------------------------
    '現在喫煙本数
    '--------------------------------------------
    '「吸わない」が記入されているのに喫煙本数が記入されている場合
    If mcolOcrNyuryoku(OCR_ITEM102).Result <> "" And _
            mcolOcrNyuryoku(OCR_ITEM099).Result = "2" Then
        
        Call EditOcrError(OCR_ITEM102, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, mcolOcrNyuryoku(OCR_ITEM102).ItemName)
    End If

    '「吸っている」「過去に吸っていた」に記入があり、「喫煙本数」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM102).Result = "" And _
            (mcolOcrNyuryoku(OCR_ITEM099).Result = "1" Or _
             mcolOcrNyuryoku(OCR_ITEM099).Result = "3") Then
        
        Call EditOcrError(OCR_ITEM102, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM102).ItemName)
    End If

    '--------------------------------------------
    '身体行動
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM105).Result = "" Then
        
        Call EditOcrError(OCR_ITEM105, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM105).ItemName, "普通に動いている")
        mcolOcrNyuryoku(OCR_ITEM105).Result = "2"   '「普通に動いている」を登録
    End If

    '--------------------------------------------
    '軽い運動
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM106).Result = "" Then
        
        Call EditOcrError(OCR_ITEM106, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM106).ItemName, "週1～2日以内")
        mcolOcrNyuryoku(OCR_ITEM106).Result = "3"    '「週1～2日以内」を登録
    End If

    '--------------------------------------------
    '自覚症状
    '--------------------------------------------
    ArrItem1 = Array(OCR_ITEM126, OCR_ITEM130, OCR_ITEM134, OCR_ITEM138, OCR_ITEM142, OCR_ITEM146)
    ArrItem2 = Array(OCR_ITEM127, OCR_ITEM131, OCR_ITEM135, OCR_ITEM139, OCR_ITEM143, OCR_ITEM147)
    ArrItem3 = Array(OCR_ITEM128, OCR_ITEM132, OCR_ITEM136, OCR_ITEM140, OCR_ITEM144, OCR_ITEM148)
    ArrItem4 = Array(OCR_ITEM129, OCR_ITEM133, OCR_ITEM137, OCR_ITEM141, OCR_ITEM145, OCR_ITEM149)
    For i = 0 To UBound(ArrItem1)
        '「数値」、「単位」又は「受診」に記入があり、「自覚症状内容」未記入の場合
        If mcolOcrNyuryoku(ArrItem1(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem4(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
        End If
        '「自覚症状内容」、「単位」又は「受診」に記入があり、「数値」未記入の場合
        If mcolOcrNyuryoku(ArrItem2(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem4(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem2(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem2(i)).ItemName)
        End If
        '「自覚症状内容」、「数値」又は「受診」に記入があり、「単位」未記入の場合
        If mcolOcrNyuryoku(ArrItem3(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem4(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem3(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem3(i)).ItemName)
        End If
        '「自覚症状内容」、「数値」又は「単位」に記入があり、「受診」未記入の場合
        If mcolOcrNyuryoku(ArrItem4(i)).Result = "" And _
                (mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "") Then
            
            Call EditOcrError(ArrItem4(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem4(i)).ItemName)
        End If
    Next
    
    '***************************************************************************************
    '生活習慣病問診票（２）
    '***************************************************************************************
    '「本人希望により未回答」のときは入力チェックしない
    If mcolOcrNyuryoku(OCR_ITEM150).Result <> "1" Then
        '--------------------------------------------
        'Ａ型行動パターン・テスト
        '--------------------------------------------
        ArrItem1 = Array(OCR_ITEM151, OCR_ITEM152, OCR_ITEM153, OCR_ITEM154, OCR_ITEM155, OCR_ITEM156, OCR_ITEM157, OCR_ITEM158, OCR_ITEM159, OCR_ITEM160, OCR_ITEM161)
        ArrItem2 = Array("全くない", "穏やかな方", "全くない", "全くない", "全くない", "よく遅れる", "全くない", "成り行き任せ", "気が楽だと思う", "マイペース", "すぐになれる")
        For i = 0 To UBound(ArrItem1)
            '未記入の場合
            If mcolOcrNyuryoku(ArrItem1(i)).Result = "" Then
                
                Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(ArrItem1(i)).ItemName, ArrItem2(i))
                mcolOcrNyuryoku(ArrItem1(i)).Result = "1"    '一番左を登録
            End If
        Next
    End If

    '「本人希望により未回答」のときは入力チェックしない
    If mcolOcrNyuryoku(OCR_ITEM162).Result <> "1" Then
        '--------------------------------------------
        'ストレス・コーピングテスト
        '--------------------------------------------
        ArrItem1 = Array(OCR_ITEM163, OCR_ITEM164, OCR_ITEM165, OCR_ITEM166, OCR_ITEM167, OCR_ITEM168, OCR_ITEM169, OCR_ITEM170, OCR_ITEM171, OCR_ITEM172, OCR_ITEM173, OCR_ITEM174)
        For i = 0 To UBound(ArrItem1)
            '未記入の場合
            If mcolOcrNyuryoku(ArrItem1(i)).Result = "" Then
                
                Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(ArrItem1(i)).ItemName, "全くしない")
                mcolOcrNyuryoku(ArrItem1(i)).Result = "1"    '一番左を登録
            End If
        Next
    End If

    '***************************************************************************************
    '婦人科問診票
    '***************************************************************************************
    '女性のとき（かつ婦人科の依頼があるとき）だけ入力チェック
    If vntGender = "2" And blnFujinkaFlg = True Then
        '--------------------------------------------
        '子宮がん検診の受診経験がある
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM175).Result = "" Then
            
            Call EditOcrError(OCR_ITEM175, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM175).ItemName)
        End If
    
        '--------------------------------------------
        '検診を受けた施設は
        '--------------------------------------------
        '子宮がん検診経験ありで、施設が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM176).Result = "" And _
                (mcolOcrNyuryoku(OCR_ITEM175).Result >= "1" And mcolOcrNyuryoku(OCR_ITEM175).Result <= "4") Then
            
            Call EditOcrError(OCR_ITEM176, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM176).ItemName)
        End If
    
        '--------------------------------------------
        '検診の結果は
        '--------------------------------------------
        '子宮がん検診経験ありで、検診結果が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM177).Result = "" And _
                (mcolOcrNyuryoku(OCR_ITEM175).Result >= "1" And mcolOcrNyuryoku(OCR_ITEM175).Result <= "4") Then
            
            Call EditOcrError(OCR_ITEM177, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM177).ItemName)
        End If
        
        '--------------------------------------------
        '婦人科病気経験ない
        '--------------------------------------------
        'すべての項目が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM178).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM179).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM180).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM181).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM182).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM183).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM184).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM185).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM186).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM187).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM188).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM189).Result = "" Then
            
            Call EditOcrError(OCR_ITEM178, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM178).ItemName, "ない")
            mcolOcrNyuryoku(OCR_ITEM178).Result = "1"   '「ない」を登録
        End If
        '「ない」と重複回答の場合
        If mcolOcrNyuryoku(OCR_ITEM178).Result = "1" Then
            ArrItem1 = Array(OCR_ITEM179, OCR_ITEM180, OCR_ITEM181, OCR_ITEM182, OCR_ITEM183, OCR_ITEM184, OCR_ITEM185, OCR_ITEM186, OCR_ITEM187, OCR_ITEM188, OCR_ITEM189)
            For i = 0 To UBound(ArrItem1)
                If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then
                
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
        End If
    
        '--------------------------------------------
        'ホルモン治療を受けたことがある
        '--------------------------------------------
        'ホルモン治療が未記入で「ﾎﾙﾓﾝ療法、何歳から」～「ﾎﾙﾓﾝ療法、何年間」が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM190).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM191).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM192).Result = "" Then
            
            Call EditOcrError(OCR_ITEM190, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM190).ItemName, "ない")
            mcolOcrNyuryoku(OCR_ITEM190).Result = "1"   '「ない」を登録
        End If
        
        '--------------------------------------------
        'ﾎﾙﾓﾝ療法、何歳から
        '--------------------------------------------
        '「ある」に記入し、年齢未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM191).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM190).Result = "2" Then
            
            Call EditOcrError(OCR_ITEM191, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM191).ItemName)
        End If
        
        '--------------------------------------------
        'ﾎﾙﾓﾝ療法、何年間
        '--------------------------------------------
        '「ある」に記入し、期間未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM192).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM190).Result = "2" Then
            
            Call EditOcrError(OCR_ITEM192, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM192).ItemName)
        End If
    
    
        '--------------------------------------------
        '婦人科手術経験
        '--------------------------------------------
        'すべての項目が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM193).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM194).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM195).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM196).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM197).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM198).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM199).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM200).Result = "" Then
            
            Call EditOcrError(OCR_ITEM193, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM193).ItemName, "ない")
            mcolOcrNyuryoku(OCR_ITEM193).Result = "1"   '「ない」を登録
        End If
        '「ある」に記入があり、各項目が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM193).Result = "2" And _
                mcolOcrNyuryoku(OCR_ITEM194).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM195).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM196).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM197).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM198).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM199).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM200).Result = "" Then
            
            Call EditOcrError(OCR_ITEM193, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM193).ItemName)
        End If
        '「ない」と重複回答の場合
        If mcolOcrNyuryoku(OCR_ITEM193).Result = "1" Then
            ArrItem1 = Array(OCR_ITEM194, OCR_ITEM195, OCR_ITEM196, OCR_ITEM197, OCR_ITEM198, OCR_ITEM199, OCR_ITEM200)
            For i = 0 To UBound(ArrItem1)
                If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then
                
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
        End If
    
        '--------------------------------------------
        '妊娠回数
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM201).Result = "" Then
            
            Call EditOcrError(OCR_ITEM201, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM201).ItemName)
        End If
    
        '--------------------------------------------
        '出産回数
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM202).Result = "" Then
            
            Call EditOcrError(OCR_ITEM202, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM202).ItemName)
        End If
    
        '--------------------------------------------
        '閉経
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM205).Result = "" Then
            
            Call EditOcrError(OCR_ITEM205, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM205).ItemName)
        End If
        '閉経「いいえ」に記入
        If mcolOcrNyuryoku(OCR_ITEM205).Result = "1" Then
            '--------------------------------------------
            '11-1．最終月経 ～ 11-6．月経時、下腹部や腰部に痛み
            '--------------------------------------------
            ArrItem1 = Array(OCR_ITEM207, OCR_ITEM208, OCR_ITEM209, OCR_ITEM210, OCR_ITEM211, OCR_ITEM212, OCR_ITEM213, OCR_ITEM214, OCR_ITEM215, OCR_ITEM216, OCR_ITEM221, OCR_ITEM222)
            For i = 0 To UBound(ArrItem1)
                '未記入の場合
                If mcolOcrNyuryoku(ArrItem1(i)).Result = "" Then
                    
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
            
            '--------------------------------------------
            '11-3．月経周期(日か不規則のいづれか入力)
            '--------------------------------------------
            '未記入の場合
            If mcolOcrNyuryoku(OCR_ITEM217).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM218).Result = "" Then
                
                Call EditOcrError(OCR_ITEM217, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM217).ItemName)
            End If
            
            '--------------------------------------------
            '11-4．月経期間(日か不規則のいづれか入力)
            '--------------------------------------------
            '未記入の場合
            If mcolOcrNyuryoku(OCR_ITEM219).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM220).Result = "" Then
                
                Call EditOcrError(OCR_ITEM219, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM219).ItemName)
            End If
        End If
    
        '--------------------------------------------
        '月経以外に出血したことがある
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM223).Result = "" Then
            
            Call EditOcrError(OCR_ITEM223, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM223).ItemName, "ない")
            mcolOcrNyuryoku(OCR_ITEM223).Result = "1"   '「ない」を登録
        End If
    
        '--------------------------------------------
        '気掛り症状ない
        '--------------------------------------------
        'すべての項目が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM224).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM225).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM226).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM227).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM228).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM229).Result = "" Then
            
            Call EditOcrError(OCR_ITEM224, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM224).ItemName, "ない")
            mcolOcrNyuryoku(OCR_ITEM224).Result = "1"   '「ない」を登録
        End If
        '「ない」と重複回答の場合
        If mcolOcrNyuryoku(OCR_ITEM224).Result = "1" Then
            ArrItem1 = Array(OCR_ITEM225, OCR_ITEM226, OCR_ITEM227, OCR_ITEM228, OCR_ITEM229)
            For i = 0 To UBound(ArrItem1)
                If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then
                
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
        End If
    
        '--------------------------------------------
        '家族で婦人科系がんいない
        '--------------------------------------------
        '「家族で婦人科系がん実母」～「その他」の項目が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM231).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM232).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM233).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM234).Result = "" Then
            
            Call EditOcrError(OCR_ITEM231, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM231).ItemName, "いない")
            mcolOcrNyuryoku(OCR_ITEM231).Result = "1"   '「いない」を登録
        End If
        '「いない」と重複回答の場合
        If mcolOcrNyuryoku(OCR_ITEM231).Result = "1" Then
            ArrItem1 = Array(OCR_ITEM232, OCR_ITEM233, OCR_ITEM234)
            For i = 0 To UBound(ArrItem1)
                If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then
                
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
        End If
        '「家族で婦人科系がん実母」～「その他」に記入があり、がんの記入がない
        If (mcolOcrNyuryoku(OCR_ITEM232).Result <> "" Or _
                mcolOcrNyuryoku(OCR_ITEM233).Result <> "" Or _
                mcolOcrNyuryoku(OCR_ITEM234).Result <> "") And _
                (mcolOcrNyuryoku(OCR_ITEM235).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM236).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM237).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM238).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM239).Result = "") Then
            
            Call EditOcrError(OCR_ITEM232, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_010, mcolOcrNyuryoku(OCR_ITEM232).ItemName)
        End If
        '「いない」と重複回答の場合
        If mcolOcrNyuryoku(OCR_ITEM231).Result = "1" Then
            ArrItem1 = Array(OCR_ITEM235, OCR_ITEM236, OCR_ITEM237, OCR_ITEM238, OCR_ITEM239)
            For i = 0 To UBound(ArrItem1)
                If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then
                
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
        End If
        'がんに記入があり、「家族で婦人科系がん実母」～「その他」に記入がない。
        If (mcolOcrNyuryoku(OCR_ITEM235).Result <> "" Or _
                mcolOcrNyuryoku(OCR_ITEM236).Result <> "" Or _
                mcolOcrNyuryoku(OCR_ITEM237).Result <> "" Or _
                mcolOcrNyuryoku(OCR_ITEM238).Result <> "" Or _
                mcolOcrNyuryoku(OCR_ITEM239).Result <> "") And _
                (mcolOcrNyuryoku(OCR_ITEM232).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM233).Result = "" And _
                mcolOcrNyuryoku(OCR_ITEM234).Result = "") Then
            
            Call EditOcrError(OCR_ITEM235, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_011, mcolOcrNyuryoku(OCR_ITEM235).ItemName)
            mcolOcrNyuryoku(OCR_ITEM231).Result = "1"   '「いない」を登録
        End If
    Else
        If vntGender = "1" Then
            '--------------------------------------------
            '男性の場合は全てクリア
            '--------------------------------------------
            For i = mcolOcrNyuryoku(OCR_ITEM175).Index To mcolOcrNyuryoku(OCR_ITEM239).Index
                mcolOcrNyuryoku(i).Result = ""   '未記入とする
            Next
        End If
    End If

    '***************************************************************************************
    '食習慣問診票
    '***************************************************************************************
    '「本人希望により未回答」のときは入力チェックしない
    If mcolOcrNyuryoku(OCR_ITEM240).Result <> "1" Then
        '--------------------------------------------
        'カロリー制限有無
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM241).Result = "" And _
                 mcolOcrNyuryoku(OCR_ITEM242).Result = "" Then
            
            Call EditOcrError(OCR_ITEM241, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM241).ItemName, "いいえ")
            mcolOcrNyuryoku(OCR_ITEM241).Result = "2"   '「いいえ」を登録
        End If
        '未記入でカロリー制限量の記入がある場合
        If mcolOcrNyuryoku(OCR_ITEM241).Result = "" And _
                 mcolOcrNyuryoku(OCR_ITEM242).Result <> "" Then
            
            Call EditOcrError(OCR_ITEM241, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM241).ItemName, "はい")
            mcolOcrNyuryoku(OCR_ITEM241).Result = "1"   '「はい」を登録
        End If
    
        '--------------------------------------------
        'カロリー制限量
        '--------------------------------------------
        'カロリー制限有無が「はい」に記入があり、未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM242).Result = "" And _
                 mcolOcrNyuryoku(OCR_ITEM241).Result = "1" Then
            
            Call EditOcrError(OCR_ITEM242, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM242).ItemName)
        End If
    
        '--------------------------------------------
        '食事の速さ～脂肪分摂取習慣
        '--------------------------------------------
        ArrItem1 = Array(OCR_ITEM243, OCR_ITEM244, OCR_ITEM245, OCR_ITEM247, OCR_ITEM248, OCR_ITEM249)
        For i = 0 To UBound(ArrItem1)
            '未記入の場合
            If mcolOcrNyuryoku(ArrItem1(i)).Result = "" Then
                
                Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(ArrItem1(i)).ItemName, "それほどでもない")
                mcolOcrNyuryoku(ArrItem1(i)).Result = "2"    '「それほどでもない」を登録
            End If
        Next
    
        '--------------------------------------------
        '塩分摂取習慣
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM250).Result = "" Then
            
            Call EditOcrError(OCR_ITEM250, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM250).ItemName, "ふつう")
            mcolOcrNyuryoku(OCR_ITEM250).Result = "2"    '「ふつう」を登録
        End If
    
        '--------------------------------------------
        '間食の有無
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM251).Result = "" Then
            
            Call EditOcrError(OCR_ITEM251, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM251).ItemName, "食べない")
            mcolOcrNyuryoku(OCR_ITEM251).Result = "1"    '「食べない」を登録
        End If
    
        '--------------------------------------------
        '減塩醤油使用の有無
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM253).Result = "" Then
            
            Call EditOcrError(OCR_ITEM253, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM253).ItemName, "使っていない")
            mcolOcrNyuryoku(OCR_ITEM253).Result = "2"    '「使っていない」を登録
        End If
    
        '--------------------------------------------
        'コーヒー・紅茶～せんべい（あられ）
        '--------------------------------------------
        For i = mcolOcrNyuryoku(OCR_ITEM254).Index To mcolOcrNyuryoku(OCR_ITEM271).Index
            '０記入エラー？
            If IsZero(mcolOcrNyuryoku(i).Result) = True Then
                Call EditOcrError(mcolOcrNyuryoku(i).UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, mcolOcrNyuryoku(i).ItemName)
                mcolOcrNyuryoku(i).Result = ""   '未記入とする
            End If
        Next
        
        '--------------------------------------------
        'コーヒー・紅茶
        '--------------------------------------------
        '未記入で「砂糖」または「ミルク」に記入があるの場合
        If mcolOcrNyuryoku(OCR_ITEM254).Result = "" And _
                (mcolOcrNyuryoku(OCR_ITEM255).Result <> "" Or _
                mcolOcrNyuryoku(OCR_ITEM256).Result <> "") Then
            
            Call EditOcrError(OCR_ITEM254, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM254).ItemName, "1.0杯")
            mcolOcrNyuryoku(OCR_ITEM254).Result = "1.0"    '「1.0杯」を登録
        End If
        
        '--------------------------------------------
        '普通牛乳～低脂肪ヨーグルト
        '--------------------------------------------
        For i = mcolOcrNyuryoku(OCR_ITEM272).Index To mcolOcrNyuryoku(OCR_ITEM275).Index
            '０記入エラー？
            If IsZero(mcolOcrNyuryoku(i).Result) = True Then
                Call EditOcrError(mcolOcrNyuryoku(i).UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, mcolOcrNyuryoku(i).ItemName)
                mcolOcrNyuryoku(i).Result = ""   '未記入とする
            End If
        Next
        
        '--------------------------------------------
        '朝食摂取習慣
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM276).Result = "" Then
            
            Call EditOcrError(OCR_ITEM276, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM276).ItemName, "食べる")
            mcolOcrNyuryoku(OCR_ITEM276).Result = "1"    '「食べる」を登録
        End If
    
        '--------------------------------------------
        '朝食：ご飯（女性用茶碗）～お漬物
        '--------------------------------------------
        For i = mcolOcrNyuryoku(OCR_ITEM277).Index To mcolOcrNyuryoku(OCR_ITEM358).Index
            '０記入エラー？
            If IsZero(mcolOcrNyuryoku(i).Result) = True Then
                Call EditOcrError(mcolOcrNyuryoku(i).UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, mcolOcrNyuryoku(i).ItemName)
                mcolOcrNyuryoku(i).Result = ""   '未記入とする
            End If
        Next
        
        '--------------------------------------------
        '昼食摂取習慣
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM359).Result = "" Then
            
            Call EditOcrError(OCR_ITEM359, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM359).ItemName, "食べる")
            mcolOcrNyuryoku(OCR_ITEM359).Result = "1"    '「食べる」を登録
        End If
    
        '--------------------------------------------
        '昼食：ご飯（女性用茶碗）～お漬物
        '--------------------------------------------
        For i = mcolOcrNyuryoku(OCR_ITEM360).Index To mcolOcrNyuryoku(OCR_ITEM441).Index
            '０記入エラー？
            If IsZero(mcolOcrNyuryoku(i).Result) = True Then
                Call EditOcrError(mcolOcrNyuryoku(i).UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, mcolOcrNyuryoku(i).ItemName)
                mcolOcrNyuryoku(i).Result = ""   '未記入とする
            End If
        Next
        
        '--------------------------------------------
        '夕食摂取習慣
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM442).Result = "" Then
            
            Call EditOcrError(OCR_ITEM442, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM442).ItemName, "食べる")
            mcolOcrNyuryoku(OCR_ITEM442).Result = "1"    '「食べる」を登録
        End If
        
        '--------------------------------------------
        '夕食：ご飯（女性用茶碗）～お漬物
        '--------------------------------------------
        For i = mcolOcrNyuryoku(OCR_ITEM443).Index To mcolOcrNyuryoku(OCR_ITEM524).Index
            '０記入エラー？
            If IsZero(mcolOcrNyuryoku(i).Result) = True Then
                Call EditOcrError(mcolOcrNyuryoku(i).UniqueKey, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_007, mcolOcrNyuryoku(i).ItemName)
                mcolOcrNyuryoku(i).Result = ""   '未記入とする
            End If
        Next
    End If

    
    '### 2008.03.25 張 特定健診関連項目追加 Start ##########################################
    '--------------------------------------------
    '生活習慣改善意志
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM525).Result = "" Then
        
        Call EditOcrError(OCR_ITEM525, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM525).ItemName)
    End If

    '--------------------------------------------
    '生活指導利用
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM526).Result = "" Then
        
        Call EditOcrError(OCR_ITEM526, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM526).ItemName)
    End If
    '### 2008.03.25 張 特定健診関連項目追加 End   ##########################################
   
    
    '復帰値の格納
    vntErrNo = vntOcrErrNo
    vntErrState = vntOcrErrState
    vntErrMsg = vntOcrErrMsg
    CheckRslOcr = lngOcrErrCnt
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "RslOcrSp.CheckRslOcr"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : ＯＣＲ入力結果のエラー情報編集
'
' 引数　　 : (In)     strUniqueKey       コレクションの対象キー
' 　　　　   (In)     strErrState        エラー状態
' 　　　　   (In)     strErrMsgNo        エラーメッセージNo
' 　　　　   (In)     strItemName        エラーメッセージの項目名
' 　　　　   (In)     strErrMsgCmt       エラーメッセージの追加コメント
'
' 戻り値　 : エラーメッセージ
'
' 備考　　 :
'
Private Sub EditOcrError( _
    ByVal strUniqueKey As String, _
    ByVal strErrState As String, _
    ByVal strErrMsgNo As String, _
    ByVal strItemName As String, _
    Optional ByVal strErrMsgCmt As String _
)
    
    Dim strErrMsg           As String           'エラーメッセージ
    Dim strComment          As String           '追加コメント
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    strErrMsg = ""
    If Not IsEmpty(strErrMsgCmt) Then
        strComment = strErrMsgCmt
    Else
        strComment = ""
    End If
     
    'エラーメッセージ編集
    Select Case strErrMsgNo
    Case OCR_ERRMSGNO_001       '未記入エラー
        strErrMsg = "「" & strItemName & "」が、未記入です。"
        
    Case OCR_ERRMSGNO_002       '未記入エラー（タイトルを登録する場合）
        strErrMsg = "「" & strItemName & "」が、未記入だった為、「" & strComment & "」とします。"
        
    Case OCR_ERRMSGNO_003       '正常値範囲外エラー
        strErrMsg = "「" & strItemName & "」に、「数値」が記入されています。"
        
    Case OCR_ERRMSGNO_004       '重複エラー
        strErrMsg = "「" & strItemName & "」が、複数チェックされている為「" & strComment & "」とします。"
    
    Case OCR_ERRMSGNO_005       '記入されないはずの項目が記入されている場合のエラー
        strErrMsg = "「" & strItemName & "」は、記入されないはずです。"
    
    Case OCR_ERRMSGNO_006       '異性が記入している場合のエラー
        strErrMsg = "「" & strItemName & "」に、「" & strComment & "」が記入しています。"
    
    Case OCR_ERRMSGNO_007       '0記入エラー
        strErrMsg = "「" & strItemName & "」に、「0」が記入されている為、未記入とします。"
    
    Case OCR_ERRMSGNO_008       '「ない」と重複する場合のエラー
        strErrMsg = "「" & strItemName & "」が「ない」と重複回答です。"
    
    Case OCR_ERRMSGNO_009       '「いない」と重複する場合のエラー
        strErrMsg = "「" & strItemName & "」が「いない」と重複回答です。"
    
    Case OCR_ERRMSGNO_010       'がんの記入がない場合のエラー
        strErrMsg = "「" & strItemName & "」と対応する「がん」が未記入です。"
    
    Case OCR_ERRMSGNO_011       '家族に記入がない場合のエラー
        strErrMsg = "「" & strItemName & "」と対応する「家族」が未記入です。"
    
    Case OCR_ERRMSGNO_012       '未記入時に数値を登録する場合のエラー
        strErrMsg = "「" & strItemName & "」が未記入ですが、数値の記入があるので登録します。"
    
    Case OCR_ERRMSGNO_013       '他業務登録エラー
        strErrMsg = "「" & strItemName & "」は、他の業務で登録されている為、OCR読込で登録できません。"
    
    Case OCR_ERRMSGNO_014       '未記入時にﾃﾞﾌｫﾙﾄ値を登録
        strErrMsg = "「" & strItemName & "」に記入がありますが、数値の記入がないので「数値」を登録します。"

    '--- これより今回追加した入力チェック結果 ---
    Case OCR_ERRMSGNO_101       '飲酒量に記入がない場合のエラー
        strErrMsg = "「" & strItemName & "」が「習慣的に飲む」ですが、飲酒量が未記入です。"
    
    Case OCR_ERRMSGNO_102       '飲酒量に記入がない場合のエラー
        strErrMsg = "「" & strItemName & "」が「ときどき飲む」ですが、飲酒量が未記入です。"
        
        
    '--- これよりResultPackage.CheckResultの入力チェック結果 ---
    Case "E01"
        strErrMsg = "「" & strItemName & "」には数値を入力してください。"
    Case "E02"
        strErrMsg = "「" & strItemName & "」の桁数に誤りがあります。"
    Case "E03"
        strErrMsg = "「" & strItemName & "」は８桁以内で入力してください。"
    Case "E04"
        strErrMsg = "「" & strItemName & "」の数値範囲に誤りがあります。"
    Case "E11"
        strErrMsg = "「" & strItemName & "」には-,+-,+のいずれかを入力してください。"
    Case "E21"
        strErrMsg = "「" & strItemName & "」には-,+-,+,2+～9+のいずれかを入力してください。"
    Case "E41"
        strErrMsg = "「" & strItemName & "」は登録されていない文章コードです。"
    Case "E6"
        strErrMsg = "「" & strItemName & "」検査項目テーブルの日付桁数に誤りがあります。"
    Case "E61"
        strErrMsg = "「" & strItemName & "」の桁数に誤りがあります。検査項目テーブルの整数桁数で入力してください。"
    Case "E62"
        strErrMsg = "「" & strItemName & "」は西暦４桁の年月日を入力してください。"
    Case "E63"
        strErrMsg = "「" & strItemName & "」は西暦４桁の年月を入力してください。"
    Case "E64"
        strErrMsg = "「" & strItemName & "」は月日を入力してください。"
    Case "E65"
        strErrMsg = "「" & strItemName & "」は日を入力してください。"

    End Select

       
ErrorHandle:

    'エラー情報の追加
    ReDim Preserve vntOcrErrNo(lngOcrErrCnt)
    ReDim Preserve vntOcrErrState(lngOcrErrCnt)
    ReDim Preserve vntOcrErrMsg(lngOcrErrCnt)
    
    vntOcrErrNo(lngOcrErrCnt) = GetOcrErrNo(strUniqueKey)
    vntOcrErrState(lngOcrErrCnt) = strErrState
    vntOcrErrMsg(lngOcrErrCnt) = strErrMsg
    
    lngOcrErrCnt = lngOcrErrCnt + 1
    
End Sub

'
' 機能　　 : ０記入チェック
'
' 引数　　 : (In)     strResult          検査項目
'
' 戻り値　 :
'
' 備考　　 :
'
Public Function IsZero(ByVal strResult As String) As Long
    
    IsZero = False
    
    If IsNumeric(strResult) Then
        If CDbl(strResult) = 0# Then
            IsZero = True
        End If
    End If

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

