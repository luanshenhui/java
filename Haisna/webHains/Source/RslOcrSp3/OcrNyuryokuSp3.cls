VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "OcrNyuryokuSp3"
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
    
    Dim objRslOcrSp         As RslOcrSp3
    
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
    Dim vntArrSeq               As Variant      'SEQの配列
    
    Dim vntArrGrpSeq            As Variant      '検査グループ　順序の配列
    Dim vntArrGrpItemCd         As Variant      '検査グループ　検査項目コードの配列
    Dim vntArrGrpSuffix         As Variant      '検査グループ　サフィックスの配列
    
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
                            vntArrLstRslCmtCd1, vntArrLstRslCmtName1, vntArrLstRslCmtCd2, vntArrLstRslCmtName2, vntArrSeq _
                            )
    If lngCount > 0 Then
       'コレクション作成
        Set mcolOcrNyuryoku = Nothing
        Set mcolOcrNyuryoku = New Collection

        For i = 0 To lngCount - 1
            '新規レコード作成
            Set objRslOcrSp = New RslOcrSp3
            
            With objRslOcrSp
'                .UniqueKey = vntArrItemCd(i) & "-" & vntArrSuffix(i)
                .UniqueKey = vntArrSeq(i)
                
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
'            strUniqueKey = vntArrItemCd(i) & "-" & vntArrSuffix(i)
            strUniqueKey = vntArrSeq(i)
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
    
    Exit Function
    
    Resume
    
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
    
    Dim objRslOcrSp         As RslOcrSp3
    
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
    Dim vntArrSeq               As Variant      'SEQの配列
    
    Dim vntArrGrpSeq            As Variant      '検査グループ　順序の配列
    Dim vntArrGrpItemCd         As Variant      '検査グループ　検査項目コードの配列
    Dim vntArrGrpSuffix         As Variant      '検査グループ　サフィックスの配列
    
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
                            vntArrLstRslCmtCd1, vntArrLstRslCmtName1, vntArrLstRslCmtCd2, vntArrLstRslCmtName2, vntArrSeq _
                            )
    
      
    
    
    Do
        If lngCount = 0 Then Exit Do
       
       'コレクション作成
        Set mcolOcrNyuryoku = Nothing
        Set mcolOcrNyuryoku = New Collection

        For i = 0 To lngCount - 1
            '新規レコード作成
            Set objRslOcrSp = New RslOcrSp3
            
            With objRslOcrSp
'                .UniqueKey = vntArrItemCd(i) & "-" & vntArrSuffix(i)
                .UniqueKey = vntArrSeq(i)
                
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
'            strUniqueKey = vntItemCd(i) & "-" & vntSuffix(i)
            strUniqueKey = vntArrSeq(i)
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
            If mcolOcrNyuryoku(OCR_ITEM139).Index <= i And i <= mcolOcrNyuryoku(OCR_ITEM149).Index Then
                mcolOcrNyuryoku(i).StopFlg = IIf(mcolOcrNyuryoku(OCR_ITEM138).Result = "1", "S", "")
            End If
        
            '最近１ヶ月の状態の未回答
            If mcolOcrNyuryoku(OCR_ITEM151).Index <= i And i <= mcolOcrNyuryoku(OCR_ITEM159).Index Then
                mcolOcrNyuryoku(i).StopFlg = IIf(mcolOcrNyuryoku(OCR_ITEM150).Result = "1", "S", "")
            End If
        
            '食習慣問診の未回答
            If mcolOcrNyuryoku(OCR_ITEM275).Index <= i And i <= mcolOcrNyuryoku(OCR_ITEM295).Index Then
                mcolOcrNyuryoku(i).StopFlg = IIf(mcolOcrNyuryoku(OCR_ITEM274).Result = "1", "S", "")
            End If
        
        Next
        
        '入力チェックのときに修正された検査結果を戻す
        For i = 0 To UBound(vntItemCd)
            strUniqueKey = vntArrSeq(i)
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
    
    Exit Function
    
    Resume
    
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
' 　　　　   (Out)    vntSeq            SEQ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Private Function SelectRslOcr( _
    ByVal lngRsvNo As Long _
  , ByVal strGrpCd As String _
  , ByVal lngLastDspMode As Long _
  , ByVal vntCsGrp As Variant _
  , ByVal lngOcrCheck As Long _
  , Optional ByRef vntPerId As Variant, Optional ByRef vntCslDate As Variant _
  , Optional ByRef vntRsvNo As Variant _
  , Optional ByRef vntItemCd As Variant, Optional ByRef vntSuffix As Variant _
  , Optional ByRef vntResultType As Variant, Optional ByRef vntItemType As Variant _
  , Optional ByRef vntItemName As Variant _
  , Optional ByRef vntFigure1 As Variant, Optional ByRef vntFigure2 As Variant _
  , Optional ByRef vntMaxValue As Variant, Optional ByRef vntMinValue As Variant _
  , Optional ByRef vntUnit As Variant _
  , Optional ByRef vntRslFlg As Variant, Optional ByRef vntResult As Variant, Optional ByRef vntStopFlg As Variant _
  , Optional ByRef vntRslCmtCd1 As Variant, Optional ByRef vntRslCmtName1 As Variant _
  , Optional ByRef vntRslCmtCd2 As Variant, Optional ByRef vntRslCmtName2 As Variant _
  , Optional ByRef vntLstCslDate As Variant, Optional ByRef vntLstRsvNo As Variant _
  , Optional ByRef vntLstRslFlg As Variant, Optional ByRef vntLstResult As Variant, Optional ByRef vntLstStopFlg As Variant _
  , Optional ByRef vntLstRslCmtCd1 As Variant, Optional ByRef vntLstRslCmtName1 As Variant _
  , Optional ByRef vntLstRslCmtCd2 As Variant, Optional ByRef vntLstRslCmtName2 As Variant _
  , Optional ByRef vntSeq As Variant _
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
    Dim objSeq            As OraField           'SEQ
   
    
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
    Dim vntArrSeq()            As Variant       'SEQ
    
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
    If Not IsMissing(vntSeq) Then vntSeq = Empty
   
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", IIf(vntCsGrp = Null, "", Trim(vntCsGrp)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GRPCD", IIf(strGrpCd = Null, "", Trim(strGrpCd)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    strStmt = _
        "SELECT FINALRSL.PERID, FINALRSL.CSLDATE       " & vbLf & _
        "      ,FINALRSL.RSVNO, FINALRSL.SEQ            " & vbLf & _
        "      ,FINALRSL.ITEMCD, FINALRSL.SUFFIX        " & vbLf & _
        "      ,ITEM_C.RESULTTYPE, ITEM_C.ITEMTYPE      " & vbLf & _
        "      ,ITEM_C.ITEMNAME                         " & vbLf & _
        "      ,ITEM_H.FIGURE1, ITEM_H.FIGURE2          " & vbLf & _
        "      ,ITEM_H.MAXVALUE, ITEM_H.MINVALUE        " & vbLf & _
        "      ,ITEM_H.UNIT                             " & vbLf
    '今回値
    strStmt = strStmt & _
        "      ,FINALRSL.RSLFLG RSLFLG                 " & vbLf & _
        "      ,FINALRSL.RESULT RESULT                 " & vbLf & _
        "      ,FINALRSL.STOPFLG STOPFLG               " & vbLf & _
        "      ,FINALRSL.RSLCMTCD1 RSLCMTCD1           " & vbLf
    If Not IsMissing(vntRslCmtName1) Then   '結果コメント要
        strStmt = strStmt & _
        "      ,(SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
        "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD1) RSLCMTNAME1    " & vbLf
    Else
        strStmt = strStmt & _
        "      ,NULL RSLCMTNAME1                        " & vbLf
    End If
    
    strStmt = strStmt & _
        "      ,FINALRSL.RSLCMTCD2 RSLCMTCD2            " & vbLf
    If Not IsMissing(vntRslCmtName2) Then   '結果コメント要
        strStmt = strStmt & _
        "      ,(SELECT RSLCMTNAME FROM RSLCMT                        " & vbLf & _
        "         WHERE RSLCMTCD = FINALRSL.RSLCMTCD2) RSLCMTNAME2    " & vbLf
    Else
        strStmt = strStmt & _
        "      , NULL RSLCMTNAME2                       " & vbLf
    End If
    '前回値
    strStmt = strStmt & _
        "     , LASTRSL.CSLDATE LSTCSLDATE             " & vbLf & _
        "     , LASTRSL.RSVNO LSTRSVNO                 " & vbLf & _
        "     , LASTRSL.RSLFLG LSTRSLFLG               " & vbLf & _
        "     , LASTRSL.RESULT LSTRESULT               " & vbLf & _
        "     , LASTRSL.STOPFLG LSTSTOPFLG             " & vbLf & _
        "     , LASTRSL.RSLCMTCD1 LSTRSLCMTCD1         " & vbLf
    If Not IsMissing(vntLstRslCmtName1) Then   '結果コメント要
        strStmt = strStmt & _
        "      ,(SELECT RSLCMTNAME FROM RSLCMT                          " & vbLf & _
        "         WHERE RSLCMTCD = LASTRSL.RSLCMTCD1) LSTRSLCMTNAME1   " & vbLf
    Else
        strStmt = strStmt & _
        "      , NULL LSTRSLCMTNAME1                    " & vbLf
    End If
    
    strStmt = strStmt & _
        "     , LASTRSL.RSLCMTCD2 LSTRSLCMTCD2         " & vbLf
    If Not IsMissing(vntLstRslCmtName2) Then   '結果コメント要
        strStmt = strStmt & _
        "     , (SELECT RSLCMTNAME FROM RSLCMT                          " & vbLf & _
        "         WHERE RSLCMTCD = LASTRSL.RSLCMTCD2) LSTRSLCMTNAME2    " & vbLf
    Else
        strStmt = strStmt & _
        "     , NULL LSTRSLCMTNAME2                     " & vbLf
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
    strStmt = strStmt & _
        "              (                                   " & vbLf & _
        "              SELECT NULL ITEMCD,  NULL SUFFIX,   " & vbLf & _
        "                     NULL SEQ, NULL RESULT,       " & vbLf & _
        "                     2 RSLFLG                     " & vbLf & _
        "                FROM DUAL                         " & vbLf & _
        "               WHERE 1 = 2                        " & vbLf & _
        "              ) PERRSLVIEW                        "

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
        Set objSeq = objFields("SEQ")
        
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
            ReDim Preserve vntArrSeq(lngCount)
            
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
            vntArrSeq(lngCount) = objSeq.Value & ""
            
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
    If Not IsMissing(vntSeq) Then vntSeq = vntArrSeq
    
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
    
    Exit Function
    
    Resume
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
    Dim chkSeq              As Variant      'SEQ
    
    Dim lngItemCnt          As Long         '検査項目数
    
    Dim objRslOcrSp         As RslOcrSp3
    Dim ArrItem1            As Variant
    Dim ArrItem2            As Variant
    Dim ArrItem3            As Variant
    Dim ArrItem4            As Variant
    Dim ArrItem5            As Variant
    
    Dim strUniqueKey        As String       'コレクションの対象キー
    Dim vntPerId            As Variant      '個人ID
    Dim vntCslDate          As Variant      '受診日
    Dim vntResult           As Variant      '検査結果
    Dim i                   As Long         'ループカウンタ
    Dim blnZero             As Boolean      '０記入チェック結果
    
    Dim blnCheckErrFlg      As Boolean
    
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

'胃Ｘ線の依頼があればブスコパンのチェックを行う
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
    chkSeq = Array()

    For Each objRslOcrSp In mcolOcrNyuryoku
        ReDim Preserve chkItemCd(lngItemCnt)
        ReDim Preserve chkSuffix(lngItemCnt)
        ReDim Preserve chkResult(lngItemCnt)
        ReDim Preserve chkResultErr(lngItemCnt)
        ReDim Preserve chkShortStc(lngItemCnt)
        ReDim Preserve chkSeq(lngItemCnt)

        With objRslOcrSp
            chkItemCd(lngItemCnt) = .ItemCd
            chkSuffix(lngItemCnt) = .Suffix
            chkResult(lngItemCnt) = .Result
            chkSeq(lngItemCnt) = .UniqueKey
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
            strUniqueKey = chkSeq(i)
            Call EditOcrError(chkSeq(i), OCR_ERRSTAT_ERROR, chkResultErr(i), mcolOcrNyuryoku(strUniqueKey).ItemName)
        End If
    Next

    '***************************************************************************************
    '現病歴・既往歴問診票
    '***************************************************************************************

    'センター使用欄：同意書（ドック全体）の入力必須チェック
    If mcolOcrNyuryoku(OCR_ITEM001).Result = "" Then
        Call EditOcrError(OCR_ITEM001, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM001).ItemName)
    End If
    
    '胃Ｘ線の依頼があればブスコパンのチェックを行う
    '胃Ｘ線の依頼があるときだけ入力チェック
    If blnStomachFlg = True Then
        '--------------------------------------------
        'ブスコパン可否
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM004).Result = "" Then

            Call EditOcrError(OCR_ITEM004, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM004).ItemName)
        End If
    End If

    '--------------------------------------------
    '現病歴
    '--------------------------------------------
    ArrItem1 = Array(OCR_ITEM006, OCR_ITEM009, OCR_ITEM012, OCR_ITEM015, OCR_ITEM018, OCR_ITEM021)
    ArrItem2 = Array(OCR_ITEM007, OCR_ITEM010, OCR_ITEM013, OCR_ITEM016, OCR_ITEM019, OCR_ITEM022)
    ArrItem3 = Array(OCR_ITEM008, OCR_ITEM011, OCR_ITEM014, OCR_ITEM017, OCR_ITEM020, OCR_ITEM023)
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
    ArrItem1 = Array(OCR_ITEM024, OCR_ITEM027, OCR_ITEM030, OCR_ITEM033, OCR_ITEM036, OCR_ITEM039)
    ArrItem2 = Array(OCR_ITEM025, OCR_ITEM028, OCR_ITEM031, OCR_ITEM034, OCR_ITEM037, OCR_ITEM040)
    ArrItem3 = Array(OCR_ITEM026, OCR_ITEM029, OCR_ITEM032, OCR_ITEM035, OCR_ITEM038, OCR_ITEM041)
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
    ArrItem1 = Array(OCR_ITEM042, OCR_ITEM045, OCR_ITEM048, OCR_ITEM051, OCR_ITEM054, OCR_ITEM057)
    ArrItem2 = Array(OCR_ITEM043, OCR_ITEM046, OCR_ITEM049, OCR_ITEM052, OCR_ITEM055, OCR_ITEM058)
    ArrItem3 = Array(OCR_ITEM044, OCR_ITEM047, OCR_ITEM050, OCR_ITEM053, OCR_ITEM056, OCR_ITEM059)
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
    If vntGender = "1" And mcolOcrNyuryoku(OCR_ITEM090).Result <> "" Then
        Call EditOcrError(OCR_ITEM090, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_006, mcolOcrNyuryoku(OCR_ITEM090).ItemName, "男性")
    End If

    '***************************************************************************************
    '生活習慣病問診票（１）
    '***************************************************************************************
    '--------------------------------------------
    '体重変化値
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM091).Result = "" Then
        Call EditOcrError(OCR_ITEM091, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM091).ItemName)
    End If

    '--------------------------------------------
    '直近体重変動
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM092).Result = "" Then
        Call EditOcrError(OCR_ITEM092, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM092).ItemName)
    End If

    '--------------------------------------------
    '飲酒１（飲酒習慣）
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM093).Result = "" Then

        '「回数」に記入がない場合
        If mcolOcrNyuryoku(OCR_ITEM094).Result = "" Then
            Call EditOcrError(OCR_ITEM093, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM093).ItemName, "飲まない")
            mcolOcrNyuryoku(OCR_ITEM093).Result = "3"   '「飲まない」を登録
        Else
            Call EditOcrError(OCR_ITEM093, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM093).ItemName, "習慣的に飲む")
            mcolOcrNyuryoku(OCR_ITEM093).Result = "1"   '「習慣的に飲む」を登録
        End If
    
    End If

    '--------------------------------------------
    '現在飲酒回数
    '--------------------------------------------
    '「習慣的に飲む」に記入があり、「回数」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM094).Result = "" And mcolOcrNyuryoku(OCR_ITEM093).Result = "1" Then
        Call EditOcrError(OCR_ITEM094, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM094).ItemName)
    End If
    
    '「ときどき飲む」に記入があり、「回数」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM094).Result = "" And mcolOcrNyuryoku(OCR_ITEM093).Result = "2" Then
        Call EditOcrError(OCR_ITEM094, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM094).ItemName)
    End If

    '「飲まない」に記入があり、「回数」に記入がある場合
    If mcolOcrNyuryoku(OCR_ITEM094).Result <> "" And mcolOcrNyuryoku(OCR_ITEM093).Result = "3" Then
        Call EditOcrError(OCR_ITEM094, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_005, mcolOcrNyuryoku(OCR_ITEM094).ItemName)
    End If

    '--------------------------------------------
    'ビール大瓶～その他
    '--------------------------------------------
    '「習慣的に飲む」に記入があり、飲酒量（「ビール大瓶」～「その他」）に記入がない場合
    If (mcolOcrNyuryoku(OCR_ITEM093).Result = "1") And _
           (mcolOcrNyuryoku(OCR_ITEM095).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM096).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM097).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM098).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM099).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM100).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM101).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM102).Result = "") Then
        Call EditOcrError(OCR_ITEM093, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_101, mcolOcrNyuryoku(OCR_ITEM093).ItemName)
    End If
    
    '「ときどき飲む」に記入があり、飲酒量（「ビール大瓶」～「その他」）に記入がない場合
    If (mcolOcrNyuryoku(OCR_ITEM093).Result = "2") And _
           (mcolOcrNyuryoku(OCR_ITEM095).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM096).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM097).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM098).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM099).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM100).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM101).Result = "") And _
           (mcolOcrNyuryoku(OCR_ITEM102).Result = "") Then
        Call EditOcrError(OCR_ITEM093, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_102, mcolOcrNyuryoku(OCR_ITEM093).ItemName)
    End If

    '--------------------------------------------
    '喫煙
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM103).Result = "" Then
        Call EditOcrError(OCR_ITEM103, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM103).ItemName, "吸わない")
        mcolOcrNyuryoku(OCR_ITEM103).Result = "2"   '「吸わない」を登録
    End If

    '--------------------------------------------
    '喫煙開始年齢
    '--------------------------------------------
    '「吸わない」が記入されているのに年齢が記入されている場合
    If mcolOcrNyuryoku(OCR_ITEM104).Result <> "" And mcolOcrNyuryoku(OCR_ITEM103).Result = "2" Then
        Call EditOcrError(OCR_ITEM104, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, mcolOcrNyuryoku(OCR_ITEM104).ItemName)
    End If

    '「吸っている」「過去に吸っていた」に記入があり、「喫煙開始年齢」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM104).Result = "" And (mcolOcrNyuryoku(OCR_ITEM103).Result = "1" Or mcolOcrNyuryoku(OCR_ITEM103).Result = "3") Then
        Call EditOcrError(OCR_ITEM104, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM104).ItemName)
    End If

    '--------------------------------------------
    '喫煙終了年齢
    '--------------------------------------------
    '「吸わない」が記入されているのに年齢が記入されている場合
    If mcolOcrNyuryoku(OCR_ITEM105).Result <> "" And mcolOcrNyuryoku(OCR_ITEM103).Result = "2" Then
        Call EditOcrError(OCR_ITEM105, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, mcolOcrNyuryoku(OCR_ITEM105).ItemName)
    End If

    '「過去に吸っていた」に記入があり、「喫煙終了年齢」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM105).Result = "" And mcolOcrNyuryoku(OCR_ITEM103).Result = "3" Then
        Call EditOcrError(OCR_ITEM105, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM105).ItemName)
    End If

    '--------------------------------------------
    '現在喫煙本数
    '--------------------------------------------
    '「吸わない」が記入されているのに喫煙本数が記入されている場合
    If mcolOcrNyuryoku(OCR_ITEM106).Result <> "" And mcolOcrNyuryoku(OCR_ITEM103).Result = "2" Then
        Call EditOcrError(OCR_ITEM106, OCR_ERRSTAT_WARNING, OCR_ERRMSGNO_005, mcolOcrNyuryoku(OCR_ITEM106).ItemName)
    End If

    '「吸っている」「過去に吸っていた」に記入があり、「喫煙本数」に記入がない場合
    If mcolOcrNyuryoku(OCR_ITEM106).Result = "" And (mcolOcrNyuryoku(OCR_ITEM103).Result = "1" Or mcolOcrNyuryoku(OCR_ITEM103).Result = "3") Then
        Call EditOcrError(OCR_ITEM106, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM106).ItemName)
    End If

    '--------------------------------------------
    '身体行動
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM109).Result = "" Then
        Call EditOcrError(OCR_ITEM109, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM109).ItemName, "普通に動いている")
        mcolOcrNyuryoku(OCR_ITEM109).Result = "2"   '「普通に動いている」を登録
    End If

    '--------------------------------------------
    '軽い運動
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM110).Result = "" Then
        Call EditOcrError(OCR_ITEM110, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM110).ItemName, "週1～2日以内")
        mcolOcrNyuryoku(OCR_ITEM110).Result = "3"    '「週1～2日以内」を登録
    End If

    '--------------------------------------------
    '自覚症状
    '--------------------------------------------
    ArrItem1 = Array(OCR_ITEM114, OCR_ITEM118, OCR_ITEM122, OCR_ITEM126, OCR_ITEM130, OCR_ITEM134)
    ArrItem2 = Array(OCR_ITEM115, OCR_ITEM119, OCR_ITEM123, OCR_ITEM127, OCR_ITEM131, OCR_ITEM135)
    ArrItem3 = Array(OCR_ITEM116, OCR_ITEM120, OCR_ITEM124, OCR_ITEM128, OCR_ITEM132, OCR_ITEM136)
    ArrItem4 = Array(OCR_ITEM117, OCR_ITEM121, OCR_ITEM125, OCR_ITEM129, OCR_ITEM133, OCR_ITEM137)
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
    If mcolOcrNyuryoku(OCR_ITEM138).Result <> "1" Then
        
        '--------------------------------------------
        'Ａ型行動パターン・テスト
        '--------------------------------------------
        ArrItem1 = Array(OCR_ITEM139, OCR_ITEM140, OCR_ITEM141, OCR_ITEM142, OCR_ITEM143, OCR_ITEM144, OCR_ITEM145, OCR_ITEM146, OCR_ITEM147, OCR_ITEM148, OCR_ITEM149)
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
    If mcolOcrNyuryoku(OCR_ITEM150).Result <> "1" Then
    
        '--------------------------------------------
        '最近１ヶ月の状態
        '--------------------------------------------
        ArrItem1 = Array(OCR_ITEM151, OCR_ITEM152, OCR_ITEM153, OCR_ITEM154, OCR_ITEM155, OCR_ITEM156, OCR_ITEM157, OCR_ITEM158, OCR_ITEM159)
        For i = 0 To UBound(ArrItem1)
            '未記入の場合
            If mcolOcrNyuryoku(ArrItem1(i)).Result = "" Then
                Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(ArrItem1(i)).ItemName, "ほとんどなかった")
                mcolOcrNyuryoku(ArrItem1(i)).Result = "1"    '一番左を登録
            End If
        Next i
    
    End If

    '***************************************************************************************
    '婦人科問診票
    '***************************************************************************************
    '女性のとき（かつ婦人科の依頼があるとき）だけ入力チェック
    If vntGender = "2" And blnFujinkaFlg = True Then
        
        '--------------------------------------------
        '1.子宮がん検診の受診経験がある
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM160).Result = "" Then
            Call EditOcrError(OCR_ITEM160, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM160).ItemName)
        End If

        '「1.子宮がん検診経験(OCR_ITEM160)」なしで、「2.検診の結果、異型上皮のクラス」・「3.検診を受けた施設は」が記入されている場合
        If mcolOcrNyuryoku(OCR_ITEM160).Result = "5" Then
            ''1.子宮がん検診経験＝”受けたことなし”
            If mcolOcrNyuryoku(OCR_ITEM161).Result <> "" Or mcolOcrNyuryoku(OCR_ITEM162).Result <> "" Or mcolOcrNyuryoku(OCR_ITEM163).Result <> "" Then
                Call EditOcrError(OCR_ITEM160, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_015, mcolOcrNyuryoku(OCR_ITEM160).ItemName, "受けたことなし")
            End If
        End If

        '「4.過去の子宮頸がん検査で異常は(OCR_ITEM164)」記入無又は「いいえ」で、結果(OCR_ITEM165)・異型上皮クラス(OCR_ITEM166)、時期(OCR_ITEM167)、場所(OCR_ITEM168)が記入されている場合
        If mcolOcrNyuryoku(OCR_ITEM165).Result <> "" Or mcolOcrNyuryoku(OCR_ITEM166).Result <> "" Or mcolOcrNyuryoku(OCR_ITEM167).Result <> "" Or mcolOcrNyuryoku(OCR_ITEM168).Result <> "" Then
            Select Case mcolOcrNyuryoku(OCR_ITEM164).Result
                Case ""     ''記入無
                    Call EditOcrError(OCR_ITEM164, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM164).ItemName)
                Case "1"    ''いいえ
                    Call EditOcrError(OCR_ITEM164, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_015, mcolOcrNyuryoku(OCR_ITEM164).ItemName, "いいえ")
            End Select
        End If

        '------------------------------------------------------
        '5.HPV検査を受けたことがありますか
        '------------------------------------------------------
        'HPV検査(OCR_ITEM169)が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM169).Result = "" Then
            Call EditOcrError(OCR_ITEM169, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM169).ItemName)
        End If

        '「5.ＨＰＶ検査を受けたことは(OCR_ITEM169)」で「受けたことなし」で、結果(OCR_ITEM170)、時期(OCR_ITEM171)、施設(OCR_ITEM172)が記入されている場合
        If mcolOcrNyuryoku(OCR_ITEM169).Result = "1" Then
            If mcolOcrNyuryoku(OCR_ITEM170).Result <> "" Or mcolOcrNyuryoku(OCR_ITEM171).Result <> "" Or mcolOcrNyuryoku(OCR_ITEM172).Result <> "" Then
                Call EditOcrError(OCR_ITEM169, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_015, mcolOcrNyuryoku(OCR_ITEM169).ItemName, "受けたことなし")
            End If
        End If

        '------------------------------------------------------
        '6.過去に子宮体がん検査を受けたことがありますか
        '------------------------------------------------------
        '子宮体がん検査受診(OCR_ITEM173)が未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM173).Result = "" Then
            Call EditOcrError(OCR_ITEM173, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM173).ItemName)
        End If
        
        '「6.子宮体がん検診経験(OCR_ITEM173)」が「いいえ」で、結果(OCR_ITEM174)、擬陽性(OCR_ITEM175)、時期(OCR_ITEM176)、施設(OCR_ITEM177)が記入されている場合
        If mcolOcrNyuryoku(OCR_ITEM173).Result = "1" Then
            ''1.子宮体がん検診経験＝”いいえ”
            If mcolOcrNyuryoku(OCR_ITEM174).Result <> "" Or mcolOcrNyuryoku(OCR_ITEM175).Result <> "" Or mcolOcrNyuryoku(OCR_ITEM176).Result <> "" Then
                Call EditOcrError(OCR_ITEM173, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_015, mcolOcrNyuryoku(OCR_ITEM173).ItemName, "いいえ")
            End If
        End If

        '------------------------------------------------------
        '7.今までに下記の病気になったことがありますか
        '------------------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM178).Result = "" Then
    
            'すべての項目が未記入の場合
            If mcolOcrNyuryoku(OCR_ITEM179).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM180).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM181).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM182).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM183).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM184).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM185).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM186).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM187).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM188).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM189).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM190).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM191).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM192).Result = "" And _
                    mcolOcrNyuryoku(OCR_ITEM193).Result = "" Then
                Call EditOcrError(OCR_ITEM178, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM178).ItemName, "ない")
                mcolOcrNyuryoku(OCR_ITEM178).Result = "1"   '「ない」を登録
            End If
        End If

        '「ない」と重複回答の場合
        '（病気経験(OCR_ITEM178)が「ない」場合に、症状の選択がある場合）
        If mcolOcrNyuryoku(OCR_ITEM178).Result = "1" Then
            ArrItem1 = Array(OCR_ITEM179, OCR_ITEM180, OCR_ITEM181, OCR_ITEM182, OCR_ITEM183 _
                           , OCR_ITEM184, OCR_ITEM185, OCR_ITEM186, OCR_ITEM187, OCR_ITEM188 _
                           , OCR_ITEM189, OCR_ITEM190, OCR_ITEM191, OCR_ITEM192, OCR_ITEM193)
            For i = 0 To UBound(ArrItem1)
                If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
        End If

        '--------------------------------------------
        '8.ホルモン治療を受けたことがある
        '--------------------------------------------
        'ホルモン治療が未記入で「ﾎﾙﾓﾝ療法、何歳から」～「ﾎﾙﾓﾝ療法、何年間」が記入ありの場合
        If mcolOcrNyuryoku(OCR_ITEM194).Result = "" And mcolOcrNyuryoku(OCR_ITEM195).Result <> "" And mcolOcrNyuryoku(OCR_ITEM196).Result <> "" Then
            Call EditOcrError(OCR_ITEM194, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM194).ItemName, "ない")
            mcolOcrNyuryoku(OCR_ITEM194).Result = "1"   '「ない」を登録
        End If

        'ﾎﾙﾓﾝ療法、何歳から
        '--------------------------------------------
        '「ある」に記入し、年齢(OCR_ITEM195)未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM195).Result = "" And mcolOcrNyuryoku(OCR_ITEM194).Result = "2" Then
            Call EditOcrError(OCR_ITEM195, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM195).ItemName)
        End If

        'ﾎﾙﾓﾝ療法、何年間
        '--------------------------------------------
        '「ある」に記入し、期間(OCR_ITEM196)未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM196).Result = "" And mcolOcrNyuryoku(OCR_ITEM194).Result = "2" Then
            Call EditOcrError(OCR_ITEM196, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM196).ItemName)
        End If

        '-------------------------------------------------
        ' 9.今までに婦人科の検査を受けたことがありますか
        '-------------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM198).Result = "" Then
            Call EditOcrError(OCR_ITEM198, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM198).ItemName, "受けたことなし")
            mcolOcrNyuryoku(OCR_ITEM198).Result = "1"    '「受けたことなし」を登録
        End If

        '「受けたことなし」と重複回答の場合
        '（病気経験(OCR_ITEM198)が「受けたことなし」場合に、症状の選択がある場合）
        If mcolOcrNyuryoku(OCR_ITEM198).Result = "1" Then
            ArrItem1 = Array(OCR_ITEM199, OCR_ITEM204, OCR_ITEM209, OCR_ITEM213, OCR_ITEM216, OCR_ITEM219, OCR_ITEM222, OCR_ITEM225)
            For i = 0 To UBound(ArrItem1)
                If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then

                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
        End If
        
        '右卵巣(OCR_ITEM199)～左卵巣(OCR_ITEM208)
        '-------------------------------------------------
        ArrItem1 = Array(OCR_ITEM199, OCR_ITEM204)
        ArrItem2 = Array(OCR_ITEM200, OCR_ITEM205)
        ArrItem3 = Array(OCR_ITEM201, OCR_ITEM206)
        ArrItem4 = Array(OCR_ITEM202, OCR_ITEM207)
        ArrItem5 = Array(OCR_ITEM203, OCR_ITEM208)
        For i = 0 To UBound(ArrItem1)
            '「結果」「部位」「年齢」「施設」のいずれかに記入があり、「病名」未記入の場合
            If mcolOcrNyuryoku(ArrItem1(i)).Result = "" And (mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem4(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem5(i)).Result <> "") Then
                Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
            End If
        Next

        '子宮全摘術(OCR_ITEM209～OCR_ITEM212)
        '-------------------------------------------------
        ArrItem1 = Array(OCR_ITEM209)
        ArrItem2 = Array(OCR_ITEM210)
        ArrItem3 = Array(OCR_ITEM211)
        ArrItem4 = Array(OCR_ITEM212)
        For i = 0 To UBound(ArrItem1)
            '「結果」「年齢」「施設」のいずれかに記入があり、「病名」未記入の場合
            If mcolOcrNyuryoku(ArrItem1(i)).Result = "" And (mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem4(i)).Result <> "") Then
                Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
            End If
        Next

        '広範囲(OCR_ITEM213)～その他(OCR_ITEM227)
        ArrItem1 = Array(OCR_ITEM213, OCR_ITEM216, OCR_ITEM219, OCR_ITEM222, OCR_ITEM225)
        ArrItem2 = Array(OCR_ITEM214, OCR_ITEM217, OCR_ITEM220, OCR_ITEM223, OCR_ITEM226)
        ArrItem3 = Array(OCR_ITEM215, OCR_ITEM218, OCR_ITEM221, OCR_ITEM224, OCR_ITEM227)
        For i = 0 To UBound(ArrItem1)
            '「年齢」又は「施設」に記入があり、「病名」未記入の場合
            If mcolOcrNyuryoku(ArrItem1(i)).Result = "" And (mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Or mcolOcrNyuryoku(ArrItem3(i)).Result <> "") Then
                Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
            End If
        Next

        '--------------------------------------------
        '12.妊娠回数
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM230).Result = "" Then
            Call EditOcrError(OCR_ITEM230, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM230).ItemName)
        End If

        '出産回数
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM231).Result = "" Then
            Call EditOcrError(OCR_ITEM231, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM231).ItemName)
        End If

        '--------------------------------------------
        '13.閉経
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM233).Result = "" Then
            Call EditOcrError(OCR_ITEM233, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM233).ItemName)
        End If
        
        '--------------------------------------------
        '14.月経
        '--------------------------------------------
        '閉経「いいえ」に記入
        If mcolOcrNyuryoku(OCR_ITEM233).Result = "1" Then
            '--------------------------------------------
            '①最終月経　②その前の月経　③出血量　④月経痛
            '--------------------------------------------
            ArrItem1 = Array(OCR_ITEM235, OCR_ITEM236, OCR_ITEM237, OCR_ITEM238, OCR_ITEM239, OCR_ITEM240, OCR_ITEM241, OCR_ITEM242, OCR_ITEM243, OCR_ITEM244, OCR_ITEM245, OCR_ITEM246)
            For i = 0 To UBound(ArrItem1)
                '未記入の場合
                If mcolOcrNyuryoku(ArrItem1(i)).Result = "" Then
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
        End If

        '--------------------------------------------
        '15.月経以外に出血したことがある
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM247).Result = "" Then
            Call EditOcrError(OCR_ITEM247, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM247).ItemName, "ない")
            mcolOcrNyuryoku(OCR_ITEM247).Result = "1"   '「ない」を登録
        End If

        '出血の理由の未記入チェック
        If mcolOcrNyuryoku(OCR_ITEM247).Result = "4" Then
            If mcolOcrNyuryoku(OCR_ITEM248).Result = "" Then
                Call EditOcrError(OCR_ITEM248, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM248).ItemName)
            End If
        End If

        '「ない」と重複回答の場合
        '（気掛かり症状(OCR_ITEM247)が「ない」場合に、出血の選択がある場合）
        If mcolOcrNyuryoku(OCR_ITEM247).Result = "1" Then
            If mcolOcrNyuryoku(OCR_ITEM248).Result <> "" Then
                Call EditOcrError(OCR_ITEM248, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, mcolOcrNyuryoku(OCR_ITEM248).ItemName)
            End If
        End If

        '--------------------------------------------
        '16.下記の症状はありますか（気掛り症状ない）
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM249).Result = "" Then
            Call EditOcrError(OCR_ITEM249, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM249).ItemName, "ない")
            mcolOcrNyuryoku(OCR_ITEM249).Result = "1"   '「ない」を登録
        End If
        
        '「ない」と重複回答の場合
        '（気掛かり症状(OCR_ITEM249)が「ない」場合に、症状の選択がある場合）
        If mcolOcrNyuryoku(OCR_ITEM249).Result = "1" Then
            ArrItem1 = Array(OCR_ITEM250, OCR_ITEM251, OCR_ITEM252)
            For i = 0 To UBound(ArrItem1)
                If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_008, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            Next
        End If

        '--------------------------------------------
        '17.家族で婦人科系がんいない
        '--------------------------------------------
        '未記入の場合
        If mcolOcrNyuryoku(OCR_ITEM253).Result = "" Then
            Call EditOcrError(OCR_ITEM253, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_002, mcolOcrNyuryoku(OCR_ITEM253).ItemName, "いない")
            mcolOcrNyuryoku(OCR_ITEM253).Result = "1"   '「いない」を登録
        End If

        ArrItem1 = Array(OCR_ITEM254, OCR_ITEM258, OCR_ITEM262, OCR_ITEM266, OCR_ITEM270)
        ArrItem2 = Array(OCR_ITEM255, OCR_ITEM259, OCR_ITEM263, OCR_ITEM267, OCR_ITEM271)
        ArrItem3 = Array(OCR_ITEM256, OCR_ITEM260, OCR_ITEM264, OCR_ITEM268, OCR_ITEM272)
        ArrItem4 = Array(OCR_ITEM257, OCR_ITEM261, OCR_ITEM265, OCR_ITEM269, OCR_ITEM273)

        'いない、の場合に何らかの入力がある場合　重複回答
        blnCheckErrFlg = False
        If mcolOcrNyuryoku(OCR_ITEM253).Result = "1" Then
            Do
                For i = 0 To UBound(ArrItem1)
                    If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then
                        '入力がある場合　エラー
                        Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                        blnCheckErrFlg = True
                    End If
                Next
                If blnCheckErrFlg Then
                    Exit Do
                End If
                For i = 0 To UBound(ArrItem2)
                    If mcolOcrNyuryoku(ArrItem2(i)).Result <> "" Then
                        '入力がある場合　エラー
                        Call EditOcrError(ArrItem2(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, mcolOcrNyuryoku(ArrItem2(i)).ItemName)
                        blnCheckErrFlg = True
                    End If
                Next
                If blnCheckErrFlg Then
                    Exit Do
                End If
                For i = 0 To UBound(ArrItem3)
                    If mcolOcrNyuryoku(ArrItem3(i)).Result <> "" Then
                        '入力がある場合　エラー
                        Call EditOcrError(ArrItem3(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, mcolOcrNyuryoku(ArrItem3(i)).ItemName)
                        blnCheckErrFlg = True
                    End If
                Next
                If blnCheckErrFlg Then
                    Exit Do
                End If
                For i = 0 To UBound(ArrItem4)
                    If mcolOcrNyuryoku(ArrItem4(i)).Result <> "" Then
                        '入力がある場合　エラー
                        Call EditOcrError(ArrItem4(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_009, mcolOcrNyuryoku(ArrItem4(i)).ItemName)
                        blnCheckErrFlg = True
                    End If
                Next
                If blnCheckErrFlg Then
                    Exit Do
                End If
                
                Exit Do
            Loop
        End If

        '家族の記入があり、対応するがんが未記入の場合
        For i = 0 To UBound(ArrItem1)
            If (mcolOcrNyuryoku(ArrItem2(i)).Result <> "") _
             Or (mcolOcrNyuryoku(ArrItem3(i)).Result <> "") _
             Or (mcolOcrNyuryoku(ArrItem4(i)).Result <> "") Then
                If mcolOcrNyuryoku(ArrItem1(i)).Result = "" Then
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_010, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            End If
        Next

        'がんの記入があり、対応する家族が未記入の場合
        For i = 0 To UBound(ArrItem1)
            If mcolOcrNyuryoku(ArrItem1(i)).Result <> "" Then
                If (mcolOcrNyuryoku(ArrItem2(i)).Result = "") _
                 And (mcolOcrNyuryoku(ArrItem3(i)).Result = "") _
                 And (mcolOcrNyuryoku(ArrItem4(i)).Result = "") Then
                    Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_011, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
                End If
            End If
        Next

    Else
        If vntGender = "1" Then
            '--------------------------------------------
            '男性の場合は全てクリア
            '--------------------------------------------
            For i = mcolOcrNyuryoku(OCR_ITEM160).Index To mcolOcrNyuryoku(OCR_ITEM273).Index
                mcolOcrNyuryoku(i).Result = ""   '未記入とする
            Next
        End If
    End If

    '***************************************************************************************
    '食習慣問診票
    '***************************************************************************************
    '「本人希望により未回答」のときは入力チェックしない
    If mcolOcrNyuryoku(OCR_ITEM274).Result <> "1" Then

        ArrItem1 = Array( _
            OCR_ITEM275, OCR_ITEM276, OCR_ITEM277, OCR_ITEM278, _
            OCR_ITEM279, OCR_ITEM280, OCR_ITEM281, OCR_ITEM282, OCR_ITEM283, OCR_ITEM284, OCR_ITEM285, _
            OCR_ITEM286, OCR_ITEM287, OCR_ITEM288, OCR_ITEM289, OCR_ITEM290, OCR_ITEM291, OCR_ITEM292, OCR_ITEM293, OCR_ITEM294, _
            OCR_ITEM295 _
        )
        
        For i = 0 To UBound(ArrItem1)
            '未記入の場合
            If mcolOcrNyuryoku(ArrItem1(i)).Result = "" Then
                Call EditOcrError(ArrItem1(i), OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(ArrItem1(i)).ItemName)
            End If
        Next i

    End If

    '--------------------------------------------
    '生活習慣改善意志
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM296).Result = "" Then
        Call EditOcrError(OCR_ITEM296, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM296).ItemName)
    End If

    '--------------------------------------------
    '生活指導利用
    '--------------------------------------------
    '未記入の場合
    If mcolOcrNyuryoku(OCR_ITEM297).Result = "" Then
        Call EditOcrError(OCR_ITEM297, OCR_ERRSTAT_ERROR, OCR_ERRMSGNO_001, mcolOcrNyuryoku(OCR_ITEM297).ItemName)
    End If

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
    
    Exit Function
    
    Resume
    
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
    
    Case OCR_ERRMSGNO_015       '「？？」と重複する場合のエラー
        If Trim(strComment) = "" Then
            strErrMsg = "「" & strItemName & "」が重複回答です。"
        Else
            strErrMsg = "「" & strItemName & "」が「" & strComment & "」と重複回答です。"
        End If
    
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


