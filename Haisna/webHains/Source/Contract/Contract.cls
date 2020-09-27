VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Contract"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'負担元団体名のデフォルト値
Private Const ORGNAME_PERSON    As String = "個人"
Private Const ORGNAME_MYORG     As String = "契約団体"

'オプション名のデフォルト値
Private Const OPTNAME_COURSE    As String = "基本コース"
Private Const OPTNAME_DELETE    As String = "（削除）"

'
' 機能　　 : 指定契約パターンの契約期間に指定団体の受診情報が存在するかをチェックする
'
' 引数　　 : (In)     lngCtrPtCd     契約パターンコード
' 　　　　   (In)     strOrgCd1      団体コード1
' 　　　　   (In)     strOrgCd2      団体コード2
' 　　　　   (Out)    vntMinCslDate  最小受診日(契約期間に存在する予約情報のうち最も小さい値)
' 　　　　   (Out)    vntMaxCslDate  最大受診日(契約期間に存在する予約情報のうち最も大きい値)
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function CheckConsultIntoContract( _
    ByVal lngCtrPtCd As Long, _
    ByRef vntMinCslDate As Variant, _
    ByRef vntMaxCslDate As Variant, _
    Optional ByVal strOrgCd1 As String, _
    Optional ByVal strOrgCd2 As String _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objMinCslDate   As OraField         '最小受診日
    Dim objMaxCslDate   As OraField         '最大受診日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntMinCslDate = Empty
    vntMaxCslDate = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    If Trim(strOrgCd1) & Trim(strOrgCd2) <> "" Then
        objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '指定契約パターンの契約期間に受診情報が存在するかをチェックし、存在時は受診日の最小・最大値を取得
    strStmt = "SELECT MIN(CONSULT.CSLDATE) MINCSLDATE, " & vbLf & _
              "       MAX(CONSULT.CSLDATE) MAXCSLDATE  " & vbLf & _
              "  FROM CONSULT, CTRPT                   " & vbLf & _
              " WHERE CTRPT.CTRPTCD  = :CTRPTCD        "
              
    '団体指定時は条件節に追加
    If Trim(strOrgCd1) & Trim(strOrgCd2) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.ORGCD1 = :ORGCD1 " & vbLf & _
              "   AND CONSULT.ORGCD2 = :ORGCD2 "
    End If
                  
    strStmt = strStmt & vbLf & _
              "   AND CTRPT.STRDATE <= CONSULT.CSLDATE " & vbLf & _
              "   AND CTRPT.ENDDATE >= CONSULT.CSLDATE " & vbLf & _
              "   AND CTRPT.CTRPTCD  = CONSULT.CTRPTCD "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'オブジェクトの参照設定
    Set objFields = objOraDyna.Fields
    Set objMinCslDate = objFields("MINCSLDATE")
    Set objMaxCslDate = objFields("MAXCSLDATE")
    
    '戻り値の設定
    If Not IsNull(objMinCslDate.Value) Then     '←最小値がNULLでないのに最大値がNULLということは絶対ないので
        vntMinCslDate = CDate(objMinCslDate.Value)
        vntMaxCslDate = CDate(objMaxCslDate.Value)
    End If
    
    '値の有無で戻り値を決定
    CheckConsultIntoContract = Not IsEmpty(vntMinCslDate)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Contract.CheckConsultIntoContract"
    
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

'## 2004.01.27 Add By T.Takagi@FSIT 分割日以降に受付情報があれば分割不可
'
' 機能　　 : 指定期間における、指定契約パターンの受付済み受診情報が存在するかをチェックする
'
' 引数　　 : (In)     lngCtrPtCd     契約パターンコード
' 　　　　   (In)     dtmStrCslDate  開始受診日
' 　　　　   (In)     dtmEndCslDate  終了受診日
'
' 戻り値　 : 1  レコードあり
' 　　　　   0  レコードなし
' 　　　　   -1 異常終了
'
' 備考　　 :
'
Public Function CheckConsultIntoContract_Rpt(ByVal lngCtrPtCd As Long, ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '指定期間における、指定契約パターンの受付済み受診情報が存在するかをチェックする
    strStmt = "SELECT CONSULT.RSVNO                                       " & vbLf & _
              "  FROM RECEIPT, CONSULT                                    " & vbLf & _
              " WHERE CONSULT.CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE " & vbLf & _
              "   AND CONSULT.CTRPTCD = :CTRPTCD                          " & vbLf & _
              "   AND CONSULT.RSVNO   = RECEIPT.RSVNO                     " & vbLf & _
              "   AND CONSULT.CSLDATE = RECEIPT.CSLDATE                   " & vbLf & _
              "   AND ROWNUM          = 1                                 "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '値の有無で戻り値を決定
    CheckConsultIntoContract_Rpt = IIf(objOraDyna.EOF, 0, 1)
    
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    CheckConsultIntoContract_Rpt = -1
    
    'イベントログ書き込み
    WriteErrorLog "Contract.CheckConsultIntoContract_Rpt"
    
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
' 機能　　 : 指定期間において、指定団体・コースの契約情報が存在するかをチェックする
'
' 引数　　 : (In)     strOrgCd1    団体コード1
' 　　　　   (In)     strOrgCd2    団体コード2
' 　　　　   (In)     strCsCd      コースコード
' 　　　　   (In)     lngCtrPtCd   契約パターンコード
' 　　　　   (In)     dtmStrDate   契約開始日
' 　　　　   (In)     dtmEndDate   契約終了日
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 : 契約パターンコード指定時は、チェック時に指定パターンの契約情報を除く
'
Public Function CheckContractPeriod( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCsCd As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal dtmStrDate As Date, _
    ByVal dtmEndDate As Date _
) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '指定期間において、指定団体・コースの契約情報が存在するかをチェックする
    strStmt = "SELECT ORGCD1              " & vbLf & _
              "  FROM CTRMNGWITHPERIOD    " & vbLf & _
              " WHERE ORGCD1   = :ORGCD1  " & vbLf & _
              "   AND ORGCD2   = :ORGCD2  " & vbLf & _
              "   AND CSCD     = :CSCD    " & vbLf & _
              "   AND ENDDATE >= :STRDATE "
    
    '契約終了日指定時は条件節に含める
    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "   AND STRDATE <= :ENDDATE "
    End If
    
    '契約パターンコード指定時はチェック条件から除くよう、条件節に含める
    If lngCtrPtCd > 0 Then
        strStmt = strStmt & vbLf & _
              "   AND CTRPTCD != :CTRPTCD "
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードの有無で戻り値を決定
    CheckContractPeriod = Not objOraDyna.EOF
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Contract.CheckContractPeriod"

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
' 機能　　 : 指定団体・契約パターンの契約情報が他団体から参照されているかをチェックする
'
' 引数　　 : (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function CheckContractReferred(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal lngCtrPtCd As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定団体・契約パターンの契約情報を参照している他の契約情報が存在するかをチェックする(自団体の契約情報は除く)
    strStmt = "SELECT ORGCD1                                         " & vbLf & _
              "  FROM CTRMNG                                         " & vbLf & _
              " WHERE REFORGCD1 = :ORGCD1                            " & vbLf & _
              "   AND REFORGCD2 = :ORGCD2                            " & vbLf & _
              "   AND CTRPTCD   = :CTRPTCD                           " & vbLf & _
              "   AND ( ORGCD1 != REFORGCD1 OR ORGCD2 != REFORGCD2 ) "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードの有無で戻り値を決定
    CheckContractReferred = Not objOraDyna.EOF
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    CheckContractReferred = False

    'イベントログ書き込み
    WriteErrorLog "Contract.CheckContractReferred"

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
' 機能　　 : 負担元情報のチェック
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     vntSeq      SEQ
' 　　　　   (In)     vntOrgCd1   (負担元情報の)団体コード1
' 　　　　   (In)     vntOrgCd2   (負担元情報の)団体コード2
'
' 戻り値　 : True   正常終了
' 　　　　   False  データベース上の負担元情報が引数値と一致しない、または異常終了
'
' 備考　　 :
'
Public Function CheckCtrPtOrg(ByVal lngCtrPtCd As Long, ByRef vntSeq As Variant, ByRef vntOrgCd1 As Variant, ByRef vntOrgCd2 As Variant) As Boolean

    Dim vntCurSeq       As Variant  '(現在の)SEQの配列
    Dim vntCurOrgCd1    As Variant  '(現在の)団体コード1の配列
    Dim vntCurOrgCd2    As Variant  '(現在の)団体コード2の配列
    Dim lngCount        As Long     'レコード数

    Dim Ret             As Boolean  '関数戻り値
    Dim i               As Long     'インデックス
    
    '初期処理
    Ret = False
    
    '現在の契約パターン負担元管理情報を読む
    lngCount = SelectCtrPtOrgPrice(lngCtrPtCd, , , vntCurSeq, , vntCurOrgCd1, vntCurOrgCd2)

    '負担元情報が存在しない場合は処理を終了する
    If lngCount <= 0 Then
        Err.Raise vbObjectError + 513, "", "契約情報が存在しません。"
        Exit Function
    End If

    Do
        '双方の負担元数が一致しない場合はエラー
        If lngCount <> UBound(vntSeq) + 1 Then
            Exit Do
        End If
        
        '双方の同一インデックスの負担元情報を対比してチェックを行う
        For i = 0 To UBound(vntSeq)
        
            'SEQが一致しない場合はエラー
            If CLng(vntCurSeq(i)) <> CLng(vntSeq(i)) Then
                Exit Do
            End If
            
            '団体コードが一致しない場合はエラー
            If Trim(vntCurOrgCd1(i)) <> Trim(vntOrgCd1(i)) Or Trim(vntCurOrgCd2(i)) <> Trim(vntOrgCd2(i)) Then
                Exit Do
            End If
                
        Next i

        Ret = True
        Exit Do
    Loop
    
    CheckCtrPtOrg = Ret
    
End Function

'
' 機能　　 : 指定契約パターンの負担元管理情報に存在する団体がこのパターンを参照しているかをチェックする
'
' 引数　　 : (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (Out)    vntOrgName  団体名称
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function CheckDemandOrgReferred( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long, _
    ByRef vntOrgName As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objOrgName      As OraField         '漢字名称
    
    Dim vntArrOrgName() As Variant          '漢字名称の配列
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntOrgName = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
  
    '指定契約パターンの負担元管理情報に存在する団体がこのパターンを参照しているかをチェックする
    strStmt = "SELECT ORG.ORGNAME                                     " & vbLf & _
              "  FROM ORG, CTRPT_ORG                                  " & vbLf & _
              " WHERE CTRPT_ORG.CTRPTCD = :CTRPTCD                    " & vbLf & _
              "   AND ( CTRPT_ORG.ORGCD1, CTRPT_ORG.ORGCD2 ) IN       " & vbLf & _
              "       ( SELECT ORGCD1, ORGCD2                         " & vbLf & _
              "           FROM CTRMNG                                 " & vbLf & _
              "          WHERE CTRMNG.REFORGCD1 = :ORGCD1             " & vbLf & _
              "            AND CTRMNG.REFORGCD2 = :ORGCD2             " & vbLf & _
              "            AND CTRMNG.CTRPTCD   = CTRPT_ORG.CTRPTCD ) " & vbLf & _
              "   AND CTRPT_ORG.ORGCD1 = ORG.ORGCD1                   " & vbLf & _
              "   AND CTRPT_ORG.ORGCD2 = ORG.ORGCD2                   "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgName = objFields("ORGNAME")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOrgName(lngCount)
            vntArrOrgName(lngCount) = objOrgName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        '戻り値の設定
        vntOrgName = vntArrOrgName
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'レコードの有無で戻り値を決定
    CheckDemandOrgReferred = (lngCount > 0)
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    CheckDemandOrgReferred = False

    'イベントログ書き込み
    WriteErrorLog "Contract.CheckDemandOrgReferred"
    
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
' 機能　　 : 指定契約パターンの契約情報を新契約パターンの契約情報として複写する
'
' 引数　　 : (In)     lngCurCtrPtCd  契約パターンコード
' 　　　　   (In)     lngNewCtrPtCd  新契約パターンコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function Copy(ByVal lngCurCtrPtCd As Long, ByVal lngNewCtrPtCd As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CURCTRPTCD", lngCurCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NEWCTRPTCD", lngNewCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '契約パターン負担元管理テーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_ORG " & vbLf & _
              "            ( CTRPTCD,                   " & vbLf & _
              "              SEQ,                       " & vbLf & _
              "              APDIV,                     " & vbLf & _
              "              ORGCD1,                    " & vbLf & _
              "              ORGCD2,                    " & vbLf & _
              "              NOCTR,                     " & vbLf & _
              "              FRACTION,                  " & vbLf & _
              "              TAXFLG,                    " & vbLf & _
              "              ADDUPFLG,                  " & vbLf & _
              "              LIMITPRICEFLG )            " & vbLf & _
              "            SELECT :NEWCTRPTCD,          " & vbLf & _
              "                   SEQ,                  " & vbLf & _
              "                   APDIV,                " & vbLf & _
              "                   ORGCD1,               " & vbLf & _
              "                   ORGCD2,               " & vbLf & _
              "                   NOCTR,                " & vbLf & _
              "                   FRACTION,             " & vbLf & _
              "                   TAXFLG,               " & vbLf & _
              "                   ADDUPFLG,             " & vbLf & _
              "                   LIMITPRICEFLG         " & vbLf & _
              "              FROM CTRPT_ORG             " & vbLf & _
              "             WHERE CTRPTCD = :CURCTRPTCD "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '契約パターンオプショングループテーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_OPTGRP                 " & vbLf & _
              "            ( CTRPTCD,                   " & vbLf & _
              "              OPTCD,                     " & vbLf & _
              "              ADDCONDITION,              " & vbLf & _
              "              HIDERSVFRA,                " & vbLf & _
              "              HIDERSV,                   " & vbLf & _
              "              HIDERPT,                   " & vbLf & _
              "              HIDEQUESTION )             " & vbLf & _
              "            SELECT :NEWCTRPTCD,          " & vbLf & _
              "                   OPTCD,                " & vbLf & _
              "                   ADDCONDITION,         " & vbLf & _
              "                   HIDERSVFRA,           " & vbLf & _
              "                   HIDERSV,              " & vbLf & _
              "                   HIDERPT,              " & vbLf & _
              "                   HIDEQUESTION          " & vbLf & _
              "              FROM CTRPT_OPTGRP          " & vbLf & _
              "             WHERE CTRPTCD = :CURCTRPTCD "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '契約パターンオプション管理テーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_OPT            " & vbLf & _
              "            ( CTRPTCD,           " & vbLf & _
              "              OPTCD,             " & vbLf & _
              "              OPTBRANCHNO,       " & vbLf & _
              "              OPTNAME,           " & vbLf & _
              "              OPTSNAME,          " & vbLf & _
              "              OPTDIV,            " & vbLf & _
              "              CSCD,              " & vbLf & _
              "              SETCOLOR,          " & vbLf & _
              "              CSLDIVCD,          " & vbLf & _
              "              GENDER,            " & vbLf & _
              "              RSVFRACD,          " & vbLf & _
              "              SETCLASSCD,        " & vbLf & _
              "              LASTREFMONTH,      " & vbLf & _
              "              LASTREFCSCD,       " & vbLf & _
              "              EXCEPTLIMIT )      "

    strStmt = strStmt & vbLf & _
              "            SELECT :NEWCTRPTCD,  " & vbLf & _
              "                   OPTCD,        " & vbLf & _
              "                   OPTBRANCHNO,  " & vbLf & _
              "                   OPTNAME,      " & vbLf & _
              "                   OPTSNAME,     " & vbLf & _
              "                   OPTDIV,       " & vbLf & _
              "                   CSCD,         " & vbLf & _
              "                   SETCOLOR,     " & vbLf & _
              "                   CSLDIVCD,     " & vbLf & _
              "                   GENDER,       " & vbLf & _
              "                   RSVFRACD,     " & vbLf & _
              "                   SETCLASSCD,   " & vbLf & _
              "                   LASTREFMONTH, " & vbLf & _
              "                   LASTREFCSCD,  " & vbLf & _
              "                   EXCEPTLIMIT   "

    strStmt = strStmt & vbLf & _
              "              FROM CTRPT_OPT             " & vbLf & _
              "             WHERE CTRPTCD = :CURCTRPTCD "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '契約パターンオプション年齢条件テーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_OPTAGE                 " & vbLf & _
              "            ( CTRPTCD,                   " & vbLf & _
              "              OPTCD,                     " & vbLf & _
              "              OPTBRANCHNO,               " & vbLf & _
              "              SEQ,                       " & vbLf & _
              "              STRAGE,                    " & vbLf & _
              "              ENDAGE )                   " & vbLf & _
              "            SELECT :NEWCTRPTCD,          " & vbLf & _
              "                   OPTCD,                " & vbLf & _
              "                   OPTBRANCHNO,          " & vbLf & _
              "                   SEQ,                  " & vbLf & _
              "                   STRAGE,               " & vbLf & _
              "                   ENDAGE                " & vbLf & _
              "              FROM CTRPT_OPTAGE          " & vbLf & _
              "             WHERE CTRPTCD = :CURCTRPTCD "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '契約パターン負担金額管理テーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_PRICE                  " & vbLf & _
              "            ( CTRPTCD,                   " & vbLf & _
              "              OPTCD,                     " & vbLf & _
              "              OPTBRANCHNO,               " & vbLf & _
              "              SEQ,                       " & vbLf & _
              "              PRICE,                     " & vbLf & _
              "              ORGDIV,                    " & vbLf & _
              "              TAX,                       " & vbLf & _
              "              BILLPRINTNAME,             " & vbLf & _
              "              BILLPRINTENAME )           " & vbLf & _
              "            SELECT :NEWCTRPTCD,          " & vbLf & _
              "                   OPTCD,                " & vbLf & _
              "                   OPTBRANCHNO,          " & vbLf & _
              "                   SEQ,                  " & vbLf & _
              "                   PRICE,                " & vbLf & _
              "                   ORGDIV,               " & vbLf & _
              "                   TAX,                  " & vbLf & _
              "                   BILLPRINTNAME,        " & vbLf & _
              "                   BILLPRINTENAME        " & vbLf & _
              "              FROM CTRPT_PRICE           " & vbLf & _
              "             WHERE CTRPTCD = :CURCTRPTCD "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '契約パターン内グループテーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_GRP                    " & vbLf & _
              "            ( CTRPTCD,                   " & vbLf & _
              "              OPTCD,                     " & vbLf & _
              "              OPTBRANCHNO,               " & vbLf & _
              "              GRPCD )                    " & vbLf & _
              "            SELECT :NEWCTRPTCD,          " & vbLf & _
              "                   OPTCD,                " & vbLf & _
              "                   OPTBRANCHNO,          " & vbLf & _
              "                   GRPCD                 " & vbLf & _
              "              FROM CTRPT_GRP             " & vbLf & _
              "             WHERE CTRPTCD = :CURCTRPTCD "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '契約パターン内検査項目テーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_ITEM                   " & vbLf & _
              "            ( CTRPTCD,                   " & vbLf & _
              "              OPTCD,                     " & vbLf & _
              "              OPTBRANCHNO,               " & vbLf & _
              "              ITEMCD )                   " & vbLf & _
              "            SELECT :NEWCTRPTCD,          " & vbLf & _
              "                   OPTCD,                " & vbLf & _
              "                   OPTBRANCHNO,          " & vbLf & _
              "                   ITEMCD                " & vbLf & _
              "              FROM CTRPT_ITEM            " & vbLf & _
              "             WHERE CTRPTCD = :CURCTRPTCD "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '契約パターン年齢区分テーブルレコードの挿入
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    strStmt = "INSERT INTO CTRPT_AGE                    " & vbLf & _
'              "            ( CTRPTCD,                   " & vbLf & _
'              "              SEQ,                       " & vbLf & _
'              "              STRAGE,                    " & vbLf & _
'              "              ENDAGE,                    " & vbLf & _
'              "              AGEDIV )                   " & vbLf & _
'              "            SELECT :NEWCTRPTCD,          " & vbLf & _
'              "                   SEQ,                  " & vbLf & _
'              "                   STRAGE,               " & vbLf & _
'              "                   ENDAGE,               " & vbLf & _
'              "                   AGEDIV                " & vbLf & _
'              "              FROM CTRPT_AGE             " & vbLf & _
'              "             WHERE CTRPTCD = :CURCTRPTCD "
'
'    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'
'    'webオプション検査テーブルレコードの挿入
'    strStmt = "INSERT INTO WEB_OPT                      " & vbLf & _
'              "            ( CTRPTCD,                   " & vbLf & _
'              "              OPTCD,                     " & vbLf & _
'              "              OPTNAME,                   " & vbLf & _
'              "              OPTPURPOSE,                " & vbLf & _
'              "              OPTDETAIL )                " & vbLf & _
'              "            SELECT :NEWCTRPTCD,          " & vbLf & _
'              "                   OPTCD,                " & vbLf & _
'              "                   OPTNAME,              " & vbLf & _
'              "                   OPTPURPOSE,           " & vbLf & _
'              "                   OPTDETAIL             " & vbLf & _
'              "              FROM WEB_OPT               " & vbLf & _
'              "             WHERE CTRPTCD = :CURCTRPTCD "
'
'    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'## 2003.11.18 Del End
    
'## 2004.01.27 Add by T.Takagi@FSIT メモコピー追加
    '契約ノートテーブルレコードの挿入
    strStmt = "INSERT INTO CTRPTPUBNOTE                 " & vbLf & _
              "            ( CTRPTCD,                   " & vbLf & _
              "              SEQ,                       " & vbLf & _
              "              PUBNOTEDIVCD,              " & vbLf & _
              "              DISPKBN,                   " & vbLf & _
              "              UPDDATE,                   " & vbLf & _
              "              UPDUSER,                   " & vbLf & _
              "              BOLDFLG,                   " & vbLf & _
              "              PUBNOTE,                   " & vbLf & _
              "              DISPCOLOR,                 " & vbLf & _
              "              DELFLG )                   " & vbLf & _
              "            SELECT :NEWCTRPTCD,          " & vbLf & _
              "                   SEQ,                  " & vbLf & _
              "                   PUBNOTEDIVCD,         " & vbLf & _
              "                   DISPKBN,              " & vbLf & _
              "                   UPDDATE,              " & vbLf & _
              "                   UPDUSER,              " & vbLf & _
              "                   BOLDFLG,              " & vbLf & _
              "                   PUBNOTE,              " & vbLf & _
              "                   DISPCOLOR,            " & vbLf & _
              "                   DELFLG                " & vbLf & _
              "              FROM CTRPTPUBNOTE          " & vbLf & _
              "             WHERE CTRPTCD = :CURCTRPTCD "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'## 2004.01.27 Add End
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    Copy = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    Copy = False

    'イベントログ書き込み
    WriteErrorLog "Contract.Copy"
    
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
' 機能　　 : 契約パターンテーブルレコードを複写する
'
' 引数　　 : (In)     lngCurCtrPtCd  (現)契約パターンコード
' 　　　　   (In)     lngNewCtrPtCd  (新)契約パターンコード
' 　　　　   (In)     dtmStrDate     契約開始年月日
' 　　　　   (In)     dtmEndDate     契約終了年月日
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function CopyCtrPt(ByVal lngCurCtrPtCd As Long, ByVal lngNewCtrPtCd As Long, ByVal dtmStrDate As Date, ByVal dtmEndDate As Date) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CURCTRPTCD", lngCurCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NEWCTRPTCD", lngNewCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '契約パターンテーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT (          " & vbLf & _
              "                CTRPTCD,     " & vbLf & _
              "                STRDATE,     " & vbLf & _
              "                ENDDATE,     " & vbLf & _
              "                AGECALC,     " & vbLf & _
              "                TAXFRACTION, " & vbLf & _
              "                CSNAME,      " & vbLf & _
              "                CSENAME,     " & vbLf & _
              "                CSLMETHOD,   " & vbLf & _
              "                LIMITRATE,   " & vbLf & _
              "                LIMITTAXFLG, " & vbLf & _
              "                LIMITPRICE   " & vbLf & _
              "       ) SELECT :NEWCTRPTCD, "

    '契約開始年月日指定時は指定された日付を更新し、未指定時は現データベース内容をそのまま適用する
    If dtmStrDate > 0 Then
        strStmt = strStmt & vbLf & _
              "                :STRDATE, "
    Else
        strStmt = strStmt & vbLf & _
              "                STRDATE,  "
    End If
              
    '契約終了年月日指定時は指定された日付を更新し、未指定時は現データベース内容をそのまま適用する
    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "                :ENDDATE, "
    Else
        strStmt = strStmt & vbLf & _
              "                ENDDATE,  "
    End If

    strStmt = strStmt & vbLf & _
              "                AGECALC,              " & vbLf & _
              "                TAXFRACTION,          " & vbLf & _
              "                CSNAME,               " & vbLf & _
              "                CSENAME,              " & vbLf & _
              "                CSLMETHOD,            " & vbLf & _
              "                LIMITRATE,            " & vbLf & _
              "                LIMITTAXFLG,          " & vbLf & _
              "                LIMITPRICE            " & vbLf & _
              "           FROM CTRPT                 " & vbLf & _
              "          WHERE CTRPTCD = :CURCTRPTCD "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    CopyCtrPt = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    CopyCtrPt = False

    'イベントログ書き込み
    WriteErrorLog "Contract.CopyCtrPt"
    
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
' 機能　　 : 契約管理テーブルレコードを削除する
'
' 引数　　 : (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteCtrMng(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal lngCtrPtCd As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定団体、パターンの契約管理テーブルレコードを削除
    strStmt = "DELETE CTRMNG             " & vbLf & _
              " WHERE ORGCD1  = :ORGCD1  " & vbLf & _
              "   AND ORGCD2  = :ORGCD2  " & vbLf & _
              "   AND CTRPTCD = :CTRPTCD "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrMng = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteCtrMng = False

    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrMng"
    
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
' 機能　　 : 契約パターンテーブルレコードを削除する
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteCtrPt(ByVal lngCtrPtCd As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER

    '契約パターンテーブルレコードを削除
    strStmt = "DELETE CTRPT              " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrPt = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteCtrPt = False

    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrPt"
    
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

'## 2002.11.05 Add Function By T.Takagi@FSIT 東急対応
'
' 機能　　 : 契約パターン年齢区分テーブルレコードを削除する
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteCtrPtAge(ByVal lngCtrPtCd As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定契約パターンの契約パターン年齢区分テーブルレコードを削除
    strStmt = "DELETE CTRPT_AGE          " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrPtAge = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteCtrPtAge = False

    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrPtAge"
    
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
' 機能　　 : 契約パターン内グループテーブルレコードを削除する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteCtrPtGrp(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定契約パターン、オプションの契約パターン内グループテーブルレコードを削除
    strStmt = "DELETE CTRPT_GRP                  " & vbLf & _
              " WHERE CTRPTCD     = :CTRPTCD     " & vbLf & _
              "   AND OPTCD       = :OPTCD       " & vbLf & _
              "   AND OPTBRANCHNO = :OPTBRANCHNO "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrPtGrp = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteCtrPtGrp = False

    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrPtGrp"
    
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
' 機能　　 : 契約パターン内検査項目テーブルレコードを削除する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteCtrPtItem(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定契約パターン、オプションの契約パターン内検査項目テーブルレコードを削除
    strStmt = "DELETE CTRPT_ITEM                 " & vbLf & _
              " WHERE CTRPTCD     = :CTRPTCD     " & vbLf & _
              "   AND OPTCD       = :OPTCD       " & vbLf & _
              "   AND OPTBRANCHNO = :OPTBRANCHNO "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrPtItem = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteCtrPtItem = False

    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrPtItem"
    
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
' 機能　　 : 契約パターンオプション管理テーブルレコードを削除する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
'
' 戻り値　 : 0   正常終了
' 　　　　   1   受診オプション管理テーブルで参照されているレコードを削除しようとした
' 　　　　   2   追加オプション負担金テーブルで参照されているレコードを削除しようとした
' 　　　　   3   webオプション検査テーブルで参照されているレコードを削除しようとした
' 　　　　   <0  異常終了
'
' 備考　　 :
'
Public Function DeleteCtrPtOpt(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    Dim strMessage  As String           'エラーメッセージ
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '契約パターンオプション管理テーブルレコードの削除
    strStmt = "DELETE CTRPT_OPT                  " & vbLf & _
              " WHERE CTRPTCD     = :CTRPTCD     " & vbLf & _
              "   AND OPTCD       = :OPTCD       " & vbLf & _
              "   AND OPTBRANCHNO = :OPTBRANCHNO "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrPtOpt = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '子レコード存在時はRaise文を使用せず、戻り値を設定して正常終了させる
    Do
        If mobjOraDb.LastServerErr <> 2292 Then
            Exit Do
        End If
        
        'エラーメッセージに含まれるテーブル名の値ごとに戻り値を設定する
        strMessage = mobjOraDb.LastServerErrText
        Select Case True
            Case InStr(1, strMessage, "CONSULT_O", vbTextCompare) > 0
                Ret = 1
            Case InStr(1, strMessage, "OPTPRICE", vbTextCompare) > 0
                Ret = 2
            Case InStr(1, strMessage, "WEB_OPT", vbTextCompare) > 0
                Ret = 3
            Case Else
                Exit Do
        End Select
        
        DeleteCtrPtOpt = Ret
        Exit Function
    Loop
    
    DeleteCtrPtOpt = -1
    
    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrPtOpt"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 契約パターンオプション年齢条件テーブルレコードを削除する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteCtrPtOptAge(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定契約パターンの契約パターンオプション年齢条件テーブルレコードを削除
    strStmt = "DELETE CTRPT_OPTAGE               " & vbLf & _
              " WHERE CTRPTCD     = :CTRPTCD     " & vbLf & _
              "   AND OPTCD       = :OPTCD       " & vbLf & _
              "   AND OPTBRANCHNO = :OPTBRANCHNO "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrPtOptAge = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteCtrPtOptAge = False

    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrPtOptAge"
    
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
' 機能　　 : 契約パターンオプショングループテーブルレコードを削除する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 : 子レコードである契約パターンオプション管理レコードが存在しなくなった場合のみ削除
'
Public Function DeleteCtrPtOptGrp(ByVal lngCtrPtCd As Long, ByVal strOptCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '契約パターンオプショングループテーブルレコードの削除
    strStmt = "DELETE CTRPT_OPTGRP                                       " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD                                 " & vbLf & _
              "   AND OPTCD   = :OPTCD                                   " & vbLf & _
              "   AND NOT EXISTS ( SELECT CTRPTCD                        " & vbLf & _
              "                      FROM CTRPT_OPT                      " & vbLf & _
              "                     WHERE CTRPTCD = CTRPT_OPTGRP.CTRPTCD " & vbLf & _
              "                       AND OPTCD   = CTRPT_OPTGRP.OPTCD ) "


    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrPtOptGrp = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteCtrPtOptGrp = False
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrPtOptGrp"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 契約パターン負担元管理テーブルレコードを削除する
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     lngSeq      SEQ
'
' 戻り値　 : 0   正常終了
' 　　　　   1   契約パターン負担金額管理テーブルで参照されているレコードを削除しようとした
' 　　　　   2   追加グループ負担金テーブルで参照されているレコードを削除しようとした
' 　　　　   3   追加検査項目負担金テーブルで参照されているレコードを削除しようとした
' 　　　　   4   締め管理テーブルで参照されているレコードを削除しようとした
' 　　　　   >0  異常終了
'
' 備考　　 :
'
Public Function DeleteCtrPtOrg(ByVal lngCtrPtCd As Long, ByVal lngSeq As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    Dim strMessage  As String           'エラーメッセージ
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '契約パターン負担元管理テーブルレコードの削除
    strStmt = "DELETE CTRPT_ORG          " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD " & vbLf & _
              "   AND SEQ     = :SEQ     "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrPtOrg = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '子レコード存在時はRaise文を使用せず、戻り値を設定して正常終了させる
    Do
        If mobjOraDb.LastServerErr <> 2292 Then
            Exit Do
        End If
        
        'エラーメッセージに含まれるテーブル名の値ごとに戻り値を設定する
        strMessage = mobjOraDb.LastServerErrText
        Select Case True
            Case InStr(1, strMessage, "CTRPT_PRICE", vbTextCompare) > 0
                Ret = 1
            Case InStr(1, strMessage, "GRPPRICE", vbTextCompare) > 0
                Ret = 2
            Case InStr(1, strMessage, "ITEMPRICE", vbTextCompare) > 0
                Ret = 3
            Case InStr(1, strMessage, "CLOSEMNG", vbTextCompare) > 0
                Ret = 4
            Case Else
                Exit Do
        End Select
        
        DeleteCtrPtOrg = Ret
        Exit Function
    Loop
    
    DeleteCtrPtOrg = -1
    
    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrPtOrg"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'## 2002.10.25 Add Function By T.Takagi@FSIT
'
' 機能　　 : 契約パターン負担金額テーブルレコードを削除する
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     lngSeq      SEQ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteCtrPtPrice(ByVal lngCtrPtCd As Long, ByVal lngSeq As Long) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '契約パターン負担金額テーブルレコード削除のSQLステートメント作成
'## 2003.02.03 Mod 9Lines By T.Takagi@FSIT 消費税対応
'    strStmt = "DELETE CTRPT_PRICE        " & vbLf & _
'              " WHERE CTRPTCD = :CTRPTCD " & vbLf & _
'              "   AND SEQ     = :SEQ     " & vbLf & _
'              "   AND PRICE   = 0        "
    strStmt = "DELETE CTRPT_PRICE        " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD " & vbLf & _
              "   AND SEQ     = :SEQ     " & vbLf & _
              "   AND PRICE   = 0        " & vbLf & _
              "   AND TAX     = 0        "
'## 2003.02.03 Mod End
    
    'SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteCtrPtPrice = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteCtrPtPrice = False

    'イベントログ書き込み
    WriteErrorLog "Contract.DeleteCtrPtPrice"
    
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

'## 2003.11.18 Del Function by T.Takagi@FSIT
'
' 機能　　 : オプション名を編集する
'
' 引数　　 : (In)     strOptName     オプション名
' 　　　　   (In)     lngOptAddMode  オプション追加モード
' 　　　　   (In)     lngGender      受診可能性別
' 　　　　   (In)     strStrAge      受診対象開始年齢
' 　　　　   (In)     strEndAge      受診対象終了年齢
'
' 戻り値　 : 編集後のオプション名
'
' 備考　　 :
'
'Private Function EditOptName( _
'    ByVal strOptName As String, _
'    ByVal lngOptAddMode As Long, _
'    ByVal lngGender As String, _
'    ByVal strStrAge As String, _
'    ByVal strEndAge As String _
') As String
'
'    Dim strEditOptName  As String   '編集後のオプション名
'
'    Dim lngStrAgeInt    As Long     '受診対象開始年齢(年齢)
'    Dim lngStrAgeDec    As Long     '受診対象開始年齢(月齢)
'    Dim lngEndAgeInt    As Long     '受診対象終了年齢(年齢)
'    Dim lngEndAgeDec    As Long     '受診対象終了年齢(月齢)
'
'    'オプション追加モードごとの処理
'    Select Case lngOptAddMode
'
'        '希望者のみの場合
'        Case OPTADDMODE_FREE
'
'            strEditOptName = strOptName & "（希望者のみ）"
'
'        '別途条件指定の場合
'        Case OPTADDMODE_CONDITION
'
'            '受診開始年齢の取得
'            lngStrAgeInt = CLng(Left(strStrAge, InStr(strStrAge, ".") - 1))
'            lngStrAgeDec = CLng(Right(strStrAge, Len(strStrAge) - InStr(strStrAge, ".")))
'
'            '受診開始年齢の編集
'            If lngStrAgeInt > 0 Or lngStrAgeDec > 0 Then
'                strEditOptName = strEditOptName & IIf(lngStrAgeInt > 0, lngStrAgeInt & "歳", "")
'                strEditOptName = strEditOptName & IIf(lngStrAgeDec > 0, lngStrAgeDec & "ヶ月", "")
'                strEditOptName = strEditOptName & "以上"
'            End If
'
'            '受診終了年齢の取得
'            lngEndAgeInt = CLng(Left(strEndAge, InStr(strEndAge, ".") - 1))
'            lngEndAgeDec = CLng(Right(strEndAge, Len(strEndAge) - InStr(strEndAge, ".")))
'
'            '受診開始年齢の編集
'            If (lngEndAgeInt > 0 And lngEndAgeInt < 999) Or (lngEndAgeDec > 0 And lngEndAgeDec < 99) Then
'                strEditOptName = strEditOptName & IIf(lngEndAgeInt > 0, lngEndAgeInt & "歳", "")
'                strEditOptName = strEditOptName & IIf(lngEndAgeDec > 0, lngEndAgeDec & "ヶ月", "")
'                strEditOptName = strEditOptName & "未満"
'            End If
'
'            '年齢条件が編集された場合
'            If strEditOptName <> "" Then
'
'                'すべての性別条件を追加
'                Select Case lngGender
'                    Case GENDER_BOTH
'                        strEditOptName = strEditOptName & "の男女"
'                    Case GENDER_MALE
'                        strEditOptName = strEditOptName & "の男性"
'                    Case GENDER_FEMALE
'                        strEditOptName = strEditOptName & "の女性"
'                End Select
'
'            '年齢条件が編集されていない場合
'            Else
'
'                '男性・女性のみ性別条件を追加
'                Select Case lngGender
'                    Case GENDER_MALE
'                        strEditOptName = "男性のみ"
'                    Case GENDER_FEMALE
'                        strEditOptName = "女性のみ"
'                End Select
'
'            End If
'
'            'ここまで編集した条件をオプション名の後ろに追加
'            If strEditOptName <> "" Then
'                strEditOptName = strOptName & "（" & strEditOptName & "）"
'            Else
'                strEditOptName = strOptName
'            End If
'
'        Case Else
'
'            strEditOptName = strOptName
'
'    End Select
'
'    EditOptName = strEditOptName
'
'End Function

'
' 機能　　 : 契約パターンコードをインクリメントする
'
' 引数　　 : (Out)    vntCtrPtCd  契約パターンコード
'
' 戻り値　 : 正の値    契約パターンコード
' 　　　　   上記以外  異常終了
'
' 備考　　 :
'
Public Function IncreaseCtrPtCd() As Long

    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objCtrPtCd  As OraField         '契約パターンコード
    
    Dim lngCtrPtCd  As Long             '契約パターンコード
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'Oracle Sequenceをインクリメントし、DUAL表を用いて次の契約パターンコードを取得する
    strStmt = "SELECT CTRPTCD_SEQ.NEXTVAL CTRPTCD FROM DUAL"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    Do
        'レコードが存在しない場合は処理終了
        If objOraDyna.EOF Then
            Exit Do
        End If
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCtrPtCd = objFields("CTRPTCD")
        
        '契約パターンコードがNULL値の場合は処理終了
        If IsNull(objCtrPtCd.Value) Then
            Exit Do
        End If
        
        '契約パターンコードの取得
        lngCtrPtCd = CLng(objCtrPtCd.Value)
        
        Exit Do
    Loop

    '戻り値の設定
    IncreaseCtrPtCd = lngCtrPtCd
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    IncreaseCtrPtCd = 0

    'イベントログ書き込み
    WriteErrorLog "Contract.IncreaseCtrPtCd"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 契約管理テーブルレコードを挿入する
'
' 引数　　 : (In)     strOrgCd1     団体コード1
' 　　　　   (In)     strOrgCd2     団体コード2
' 　　　　   (In)     strCsCd       コースコード
' 　　　　   (In)     strRefOrgCd1  参照先団体コード1
' 　　　　   (In)     strRefOrgCd2  参照先団体コード2
' 　　　　   (In)     vntCtrPtCd    契約パターンコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertCtrMng( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCsCd As String, _
    ByVal strRefOrgCd1 As String, _
    ByVal strRefOrgCd2 As String, _
    ByVal lngCtrPtCd As Long _
) As Boolean

    Dim objCommon       As Common           '共通クラス
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim strWebOrgCd1    As String           'Web用団体コード1
    Dim strWebOrgCd2    As String           'Web用団体コード2
    Dim lngWebFlg       As Long             'Web予約適用フラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    strOrgCd1 = Trim(strOrgCd1)
    strOrgCd2 = Trim(strOrgCd2)
    strRefOrgCd1 = Trim(strRefOrgCd1)
    strRefOrgCd2 = Trim(strRefOrgCd2)
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    'web用団体コードの取得
    objCommon.GetOrgCd ORGCD_KEY_WEB, strWebOrgCd1, strWebOrgCd2
    
    '団体コードがweb用であるかによる、Web予約適用フラグ値の設定
    lngWebFlg = IIf(strOrgCd1 = strWebOrgCd1 And strOrgCd2 = strWebOrgCd2, 1, 0)
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REFORGCD1", Trim(strRefOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REFORGCD2", Trim(strRefOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "WEBFLG", lngWebFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '契約管理テーブルレコードの挿入
    strStmt = "INSERT INTO CTRMNG ( " & vbLf & _
              "            ORGCD1,  " & vbLf & _
              "            ORGCD2,  " & vbLf & _
              "            CSCD,    "
              
    '参照先団体指定時の処理
    If strRefOrgCd1 & strRefOrgCd2 <> "" Then
        strStmt = strStmt & vbLf & _
              "            REFORGCD1, " & vbLf & _
              "            REFORGCD2, "
    End If
    
    strStmt = strStmt & vbLf & _
              "            CTRPTCD, " & vbLf & _
              "            WEBFLG   " & vbLf & _
              "       ) VALUES (    " & vbLf & _
              "            :ORGCD1, " & vbLf & _
              "            :ORGCD2, " & vbLf & _
              "            :CSCD,   "
              
    '参照先団体指定時の処理
    If strRefOrgCd1 & strRefOrgCd2 <> "" Then
        strStmt = strStmt & vbLf & _
              "            :REFORGCD1, " & vbLf & _
              "            :REFORGCD2, "
    End If
    
    '契約パターン指定時の処理
    strStmt = strStmt & vbLf & _
              "            :CTRPTCD, " & vbLf & _
              "            :WEBFLG   " & vbLf & _
              "       )              "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertCtrMng = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrMng = False

    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrMng"
    
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
' 機能　　 : 指定参照団体コード、契約パターンの契約情報を参照している全団体に対し、新契約パターンの参照情報を作成する
'
' 引数　　 : (In)     strRefOrgCd1   参照先団体コード1
' 　　　　   (In)     strRefOrgCd2   参照先団体コード2
' 　　　　   (In)     lngCurCtrPtCd  契約パターンコード
' 　　　　   (In)     lngNewCtrPtCd  新契約パターンコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertCtrMngAllRefer( _
    ByVal strRefOrgCd1 As String, _
    ByVal strRefOrgCd2 As String, _
    ByVal lngCurCtrPtCd As Long, _
    ByVal lngNewCtrPtCd As Long _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "REFORGCD1", Trim(strRefOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REFORGCD2", Trim(strRefOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CURCTRPTCD", lngCurCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NEWCTRPTCD", lngNewCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定参照団体コード、契約パターンの契約情報を参照している全団体に対し、新契約パターンの参照情報を作成する
    strStmt = "INSERT INTO CTRMNG (                    " & vbLf & _
              "                ORGCD1,                 " & vbLf & _
              "                ORGCD2,                 " & vbLf & _
              "                CSCD,                   " & vbLf & _
              "                REFORGCD1,              " & vbLf & _
              "                REFORGCD2,              " & vbLf & _
              "                CTRPTCD,                " & vbLf & _
              "                WEBFLG,                 " & vbLf & _
              "                REPORTCD                " & vbLf & _
              "       ) SELECT ORGCD1,                 " & vbLf & _
              "                ORGCD2,                 " & vbLf & _
              "                CSCD,                   " & vbLf & _
              "                REFORGCD1,              " & vbLf & _
              "                REFORGCD2,              " & vbLf & _
              "                :NEWCTRPTCD,            " & vbLf & _
              "                WEBFLG,                 " & vbLf & _
              "                REPORTCD                " & vbLf & _
              "           FROM CTRMNG                  " & vbLf & _
              "          WHERE REFORGCD1 = :REFORGCD1  " & vbLf & _
              "            AND REFORGCD2 = :REFORGCD2  " & vbLf & _
              "            AND CTRPTCD   = :CURCTRPTCD "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertCtrMngAllRefer = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrMngAllRefer = False

    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrMngAllRefer"
    
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
' 機能　　 : 契約管理テーブルレコードを挿入する(契約情報の参照)
'
' 引数　　 : (In)     strOrgCd1     団体コード1
' 　　　　   (In)     strOrgCd2     団体コード2
' 　　　　   (In)     strRefOrgCd1  参照先団体コード1
' 　　　　   (In)     strRefOrgCd2  参照先団体コード2
' 　　　　   (In)     lngCtrPtCd    契約パターンコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertCtrMngRefer( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strRefOrgCd1 As String, _
    ByVal strRefOrgCd2 As String, _
    ByVal lngCtrPtCd As Long _
) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REFORGCD1", Trim(strRefOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REFORGCD2", Trim(strRefOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '契約管理テーブルレコードの挿入
    strStmt = "INSERT INTO CTRMNG ( ORGCD1, ORGCD2, CSCD, REFORGCD1, REFORGCD2, CTRPTCD ) " & vbLf & _
              "            SELECT :ORGCD1, :ORGCD2, CSCD, REFORGCD1, REFORGCD2, CTRPTCD   " & vbLf & _
              "              FROM CTRMNG                                                  " & vbLf & _
              "             WHERE ORGCD1  = :REFORGCD1                                    " & vbLf & _
              "               AND ORGCD2  = :REFORGCD2                                    " & vbLf & _
              "               AND CTRPTCD = :CTRPTCD                                      "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertCtrMngRefer = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrMngRefer = False

    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrMngRefer"
    
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
' 機能　　 : 契約パターンテーブルレコードを挿入する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     dtmStrDate      契約開始日
' 　　　　   (In)     dtmEndDate      契約終了日
' 　　　　   (In)     strAgeCalc      年齢起算日
' 　　　　   (In)     lngTaxFraction  税端数区分
' 　　　　   (In)     strCsName       コース名
'
' 戻り値　 : True  正常終了
' 　　　　   False 異常終了
'
' 備考　　 :
'
Public Function InsertCtrPt( _
    ByVal lngCtrPtCd As Long, _
    ByVal dtmStrDate As Date, _
    ByVal dtmEndDate As Date, _
    ByVal strAgeCalc As String, _
    ByVal lngTaxFraction As Long, _
    ByVal strCsName As String _
) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "AGECALC", strAgeCalc, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TAXFRACTION", lngTaxFraction, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSNAME", strCsName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '契約パターンテーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT (  " & vbLf & _
              "            CTRPTCD  "

    '契約開始日指定時の処理
    If dtmStrDate > 0 Then
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "            STRDATE    "
    End If
              
    '契約終了日指定時の処理
    If dtmEndDate > 0 Then
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "            ENDDATE    "
    End If
              
    '年齢起算日・税端数区分の編集
    strStmt = RTrim(strStmt) & ",       " & vbLf & _
              "            AGECALC,     " & vbLf & _
              "            TAXFRACTION, " & vbLf & _
              "            CSNAME       " & vbLf & _
              "       ) VALUES (        " & vbLf & _
              "            :CTRPTCD     "

    '契約開始日指定時の処理
    If dtmStrDate > 0 Then
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "            :STRDATE   "
    End If
              
    '契約終了日指定時の処理
    If dtmEndDate > 0 Then
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "            :ENDDATE   "
    End If
              
    '年齢起算日・税端数区分の編集
    strStmt = RTrim(strStmt) & ",        " & vbLf & _
              "            :AGECALC,     " & vbLf & _
              "            :TAXFRACTION, " & vbLf & _
              "            :CSNAME       " & vbLf & _
              "       )"
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertCtrPt = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrPt = False
    
    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrPt"
    
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

'## 2002.11.05 Add Function By T.Takagi@FSIT 東急対応
'
' 機能　　 : 契約パターン年齢区分テーブルレコードを挿入する
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     vntStrAge   開始年齢
' 　　　　   (In)     vntEndAge   終了年齢
' 　　　　   (In)     vntAgeDiv   年齢区分
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertCtrPtAge(ByVal lngCtrPtCd As Long, ByRef vntStrAge As Variant, ByRef vntEndAge As Variant, ByRef vntAgeDiv As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objSeq          As OraParameter     'SEQ
    Dim objStrAge       As OraParameter     '開始年齢
    Dim objEndAge       As OraParameter     '終了年齢
    Dim objAgeDiv       As OraParameter     '年齢区分
    
    Dim vntArrStrAge    As Variant          '開始年齢の配列
    Dim vntArrEndAge    As Variant          '終了年齢の配列
    Dim vntArrAgeDiv    As Variant          '年齢区分の配列
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '挿入処理に際し、引数値を配列形式に変換
    If IsArray(vntStrAge) Then
        vntArrStrAge = vntStrAge
        vntArrEndAge = vntEndAge
        vntArrAgeDiv = vntAgeDiv
    Else
        vntArrStrAge = Array(vntStrAge)
        vntArrEndAge = Array(vntEndAge)
        vntArrAgeDiv = Array(vntAgeDiv)
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRAGE", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDAGE", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AGEDIV", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'パラメータの参照設定
    Set objSeq = objOraParam("SEQ")
    Set objStrAge = objOraParam("STRAGE")
    Set objEndAge = objOraParam("ENDAGE")
    Set objAgeDiv = objOraParam("AGEDIV")
    
    '契約パターン年齢区分テーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_AGE ( " & vbLf & _
              "            CTRPTCD,    " & vbLf & _
              "            SEQ,        " & vbLf & _
              "            STRAGE,     " & vbLf & _
              "            ENDAGE,     " & vbLf & _
              "            AGEDIV      " & vbLf & _
              "       ) VALUES (       " & vbLf & _
              "            :CTRPTCD,   " & vbLf & _
              "            :SEQ,       " & vbLf & _
              "            :STRAGE,    " & vbLf & _
              "            :ENDAGE,    " & vbLf & _
              "            :AGEDIV     " & vbLf & _
              "       )                "
              
    '各配列値の挿入処理
    For i = 0 To UBound(vntArrStrAge)
    
        '配列値の編集
        objSeq.Value = i + 1
        objStrAge.Value = CLng(vntArrStrAge(i))
        objEndAge.Value = CLng(vntArrEndAge(i))
        objAgeDiv.Value = Trim(vntArrAgeDiv(i))
    
        'SQL文の実行
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
    
    '戻り値の設定
    InsertCtrPtAge = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrPtAge = False

    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrPtAge"
    
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
' 機能　　 : 契約パターン内グループテーブルレコードを挿入する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
' 　　　　   (In)     vntGrpCd        グループコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertCtrPtGrp(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long, ByRef vntGrpCd As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objGrpCd        As OraParameter     'グループコード
    
    Dim vntArrGrpCd     As Variant          'グループコードの配列
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '挿入処理に際し、引数値を配列形式に変換
    If IsArray(vntGrpCd) Then
        vntArrGrpCd = vntGrpCd
    Else
        vntArrGrpCd = Array(vntGrpCd)
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "GRPCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'パラメータの参照設定
    Set objGrpCd = objOraParam("GRPCD")
    
    '契約パターン内グループテーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_GRP (   " & vbLf & _
              "            CTRPTCD,      " & vbLf & _
              "            OPTCD,        " & vbLf & _
              "            OPTBRANCHNO,  " & vbLf & _
              "            GRPCD         " & vbLf & _
              "       ) VALUES (         " & vbLf & _
              "            :CTRPTCD,     " & vbLf & _
              "            :OPTCD,       " & vbLf & _
              "            :OPTBRANCHNO, " & vbLf & _
              "            :GRPCD        " & vbLf & _
              "       )                  "
              
    '各配列値の挿入処理
    For i = 0 To UBound(vntArrGrpCd)
    
        '配列値の編集
        objGrpCd.Value = Trim(vntArrGrpCd(i))
    
        'SQL文の実行
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
    
    '戻り値の設定
    InsertCtrPtGrp = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrPtGrp = False

    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrPtGrp"
    
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
' 機能　　 : 契約パターン内検査項目テーブルレコードを挿入する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
' 　　　　   (In)     vntItemCd       検査項目コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function InsertCtrPtItem(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long, ByRef vntItemCd As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objItemCd       As OraParameter     '検査項目コード
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'パラメータの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    
    '契約パターン内検査項目テーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_ITEM (  " & vbLf & _
              "            CTRPTCD,      " & vbLf & _
              "            OPTCD,        " & vbLf & _
              "            OPTBRANCHNO,  " & vbLf & _
              "            ITEMCD        " & vbLf & _
              "       ) VALUES (         " & vbLf & _
              "            :CTRPTCD,     " & vbLf & _
              "            :OPTCD,       " & vbLf & _
              "            :OPTBRANCHNO, " & vbLf & _
              "            :ITEMCD       " & vbLf & _
              "       )                  "
              
    '各配列値の挿入処理
    For i = 0 To UBound(vntItemCd)
    
        '配列値の編集
        objItemCd.Value = CStr(vntItemCd(i))
    
        'SQL文の実行
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
    
    '戻り値の設定
    InsertCtrPtItem = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrPtItem = False
    
    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrPtItem"
    
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
' 機能　　 : 契約パターンオプション年齢条件テーブルレコードを挿入する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
' 　　　　   (In)     vntStrAge       受診対象開始年齢
' 　　　　   (In)     vntEndAge       受診対象終了年齢
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertCtrPtOptAge(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long, ByRef vntStrAge As Variant, ByRef vntEndAge As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objSeq          As OraParameter     'SEQ
    Dim objStrAge       As OraParameter     '受診対象開始年齢
    Dim objEndAge       As OraParameter     '受診対象終了年齢
    
    Dim vntArrStrAge    As Variant          '受診対象開始年齢の配列
    Dim vntArrEndAge    As Variant          '受診対象終了年齢の配列
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '挿入処理に際し、引数値を配列形式に変換
    If IsArray(vntStrAge) Then
        vntArrStrAge = vntStrAge
        vntArrEndAge = vntEndAge
    Else
        vntArrStrAge = Array(vntStrAge)
        vntArrEndAge = Array(vntEndAge)
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRAGE", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDAGE", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'パラメータの参照設定
    Set objSeq = objOraParam("SEQ")
    Set objStrAge = objOraParam("STRAGE")
    Set objEndAge = objOraParam("ENDAGE")
    
    '契約パターンオプション年齢条件テーブルレコードの挿入
    strStmt = "INSERT INTO CTRPT_OPTAGE ( " & vbLf & _
              "            CTRPTCD,       " & vbLf & _
              "            OPTCD,         " & vbLf & _
              "            OPTBRANCHNO,   " & vbLf & _
              "            SEQ,           " & vbLf & _
              "            STRAGE,        " & vbLf & _
              "            ENDAGE         " & vbLf & _
              "       ) VALUES (          " & vbLf & _
              "            :CTRPTCD,      " & vbLf & _
              "            :OPTCD,        " & vbLf & _
              "            :OPTBRANCHNO,  " & vbLf & _
              "            :SEQ,          " & vbLf & _
              "            :STRAGE,       " & vbLf & _
              "            :ENDAGE        " & vbLf & _
              "       )                   "
              
    '各配列値の挿入処理
    For i = 0 To UBound(vntArrStrAge)
    
        '配列値の編集
        objSeq.Value = i + 1
        If vntArrStrAge(i) <> "" Then
            objStrAge.Value = CDbl(vntArrStrAge(i))
        Else
            objStrAge.Value = 0
        End If
        If vntArrEndAge(i) <> "" Then
            objEndAge.Value = CDbl(vntArrEndAge(i))
        Else
            objEndAge.Value = 999.99
        End If
        
        'SQL文の実行
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
    
    '戻り値の設定
    InsertCtrPtOptAge = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrPtOptAge = False

    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrPtOptAge"
    
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
' 機能　　 : 契約パターン負担元テーブルレコードを挿入する
'
' 引数　　 : (In)     lngCtrPtCd   契約パターンコード
' 　　　　   (In)     vntSeq       SEQ
' 　　　　   (In)     vntApDiv     適用元区分
' 　　　　   (In)     vntOrgCd1    団体コード１
' 　　　　   (In)     vntOrgCd2    団体コード２
' 　　　　   (In)     vntTaxFlg    消費税負担フラグ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 : 更新値については、単数で渡される場合と配列形式で渡される場合とを想定
'
Public Function InsertCtrPtOrg( _
    ByVal lngCtrPtCd As Long, _
    ByRef vntSeq As Variant, _
    ByRef vntApDiv As Variant, _
    ByRef vntOrgCd1 As Variant, _
    ByRef vntOrgCd2 As Variant, _
    ByRef vntTaxFlg As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objSeq          As OraParameter     'SEQ
    Dim objApDiv        As OraParameter     '適用元区分
    Dim objOrgCd1       As OraParameter     '団体コード1
    Dim objOrgCd2       As OraParameter     '団体コード2
    Dim objTaxFlg       As OraParameter     '消費税負担フラグ
    
    Dim vntArrSeq       As Variant          'SEQの配列
    Dim vntArrApDiv     As Variant          '適用元区分の配列
    Dim vntArrOrgCd1    As Variant          '団体コード1の配列
    Dim vntArrOrgCd2    As Variant          '団体コード2の配列
    Dim vntArrTaxFlg    As Variant          '消費税負担フラグの配列
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '挿入処理に際し、引数値を配列形式に変換
    If IsArray(vntSeq) Then
        vntArrSeq = vntSeq
        vntArrApDiv = vntApDiv
        vntArrOrgCd1 = vntOrgCd1
        vntArrOrgCd2 = vntOrgCd2
        vntArrTaxFlg = vntTaxFlg
    Else
        vntArrSeq = Array(vntSeq)
        vntArrApDiv = Array(vntApDiv)
        vntArrOrgCd1 = Array(vntOrgCd1)
        vntArrOrgCd2 = Array(vntOrgCd2)
        vntArrTaxFlg = Array(vntTaxFlg)
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "APDIV", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGCD1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TAXFLG", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'パラメータの参照設定
    Set objSeq = objOraParam("SEQ")
    Set objApDiv = objOraParam("APDIV")
    Set objOrgCd1 = objOraParam("ORGCD1")
    Set objOrgCd2 = objOraParam("ORGCD2")
    Set objTaxFlg = objOraParam("TAXFLG")
    
    '契約パターン負担元テーブルレコード挿入のSQLステートメント作成
    strStmt = "INSERT INTO CTRPT_ORG ( " & vbLf & _
              "            CTRPTCD,    " & vbLf & _
              "            SEQ,        " & vbLf & _
              "            APDIV,      " & vbLf & _
              "            ORGCD1,     " & vbLf & _
              "            ORGCD2,     " & vbLf & _
              "            TAXFLG      " & vbLf & _
              "       ) VALUES (       " & vbLf & _
              "            :CTRPTCD,   " & vbLf & _
              "            :SEQ,       " & vbLf & _
              "            :APDIV,     " & vbLf & _
              "            :ORGCD1,    " & vbLf & _
              "            :ORGCD2,    " & vbLf & _
              "            :TAXFLG     " & vbLf & _
              "       )                "
              
    '各配列値の挿入処理
    For i = 0 To UBound(vntArrSeq)
    
        '配列値の編集
        objSeq.Value = CLng(vntArrSeq(i))
        objApDiv.Value = CLng(vntArrApDiv(i))
        objOrgCd1.Value = CStr(vntArrOrgCd1(i))
        objOrgCd2.Value = CStr(vntArrOrgCd2(i))
        objTaxFlg.Value = CLng(vntArrTaxFlg(i))
    
        'SQL文の実行
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
    
    '戻り値の設定
    InsertCtrPtOrg = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrPtOrg = False

    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrPtOrg"
    
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
' 機能　　 : 契約パターン負担金額テーブルレコードを挿入する
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     lngSeq      SEQ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 : 現存する全てのオプション検査に対し、指定された契約パターン、SEQの負担金額レコードを作成する。
'
Public Function InsertCtrPtPrice(ByVal lngCtrPtCd As Long, ByVal lngSeq As Long) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '契約パターン負担金額テーブルレコード挿入のSQLステートメント作成
    strStmt = "INSERT INTO CTRPT_PRICE (       " & vbLf & _
              "            CTRPTCD,            " & vbLf & _
              "            SEQ,                " & vbLf & _
              "            OPTCD,              " & vbLf & _
              "            OPTBRANCHNO,        " & vbLf & _
              "            PRICE,              " & vbLf & _
              "            TAX                 " & vbLf & _
              "   ) SELECT CTRPTCD,            " & vbLf & _
              "            :SEQ,               " & vbLf & _
              "            OPTCD,              " & vbLf & _
              "            OPTBRANCHNO,        " & vbLf & _
              "            0,                  " & vbLf & _
              "            0                   " & vbLf & _
              "       FROM CTRPT_OPT           " & vbLf & _
              "      WHERE CTRPTCD  = :CTRPTCD "

    'SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    InsertCtrPtPrice = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    InsertCtrPtPrice = False

    'イベントログ書き込み
    WriteErrorLog "Contract.InsertCtrPtPrice"
    
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
' 機能　　 : 契約パターンのレコードロック
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function LockCtrPt(ByVal lngCtrPtCd As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '契約パターンテーブルレコードを更新し、ロックをかける
    strStmt = "SELECT CTRPTCD FROM CTRPT WHERE CTRPTCD = :CTRPTCD FOR UPDATE"
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '戻り値の設定
    LockCtrPt = Not objOraDyna.EOF
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Contract.LockCtrPt"
    
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
' 機能　　 : 指定団体・契約パターンの契約情報を参照している全ての契約情報を持つ受診情報テーブルレコードのロック
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　   (In)     strOrgCd2       団体コード2
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function LockConsultReferringContract( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long _
) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定団体・契約パターンの契約情報を参照している全ての契約情報を持つ受診情報テーブルレコードのロック
    strStmt = "SELECT ORGCD1                           " & vbLf & _
              "  FROM CONSULT                          " & vbLf & _
              " WHERE ( ORGCD1, ORGCD2, CTRPTCD ) IN   " & vbLf & _
              "       ( SELECT ORGCD1, ORGCD2, CTRPTCD " & vbLf & _
              "           FROM CTRMNG                  " & vbLf & _
              "          WHERE REFORGCD1 = :ORGCD1     " & vbLf & _
              "            AND REFORGCD2 = :ORGCD2     " & vbLf & _
              "            AND CTRPTCD   = :CTRPTCD )  " & vbLf & _
              "   FOR UPDATE                           "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードの有無で戻り値を決定
    LockConsultReferringContract = Not objOraDyna.EOF
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Contract.LockConsultReferringContract"
    
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
' 機能　　 : 指定団体・契約パターンの契約情報を参照している全団体の団体テーブルロック
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　   (In)     strOrgCd2       団体コード2
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function LockOrgReferringContract( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long _
) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定団体・契約パターンの契約情報を参照している全団体の団体テーブルロック
    strStmt = "SELECT ORGCD1                          " & vbLf & _
              "  FROM ORG                             " & vbLf & _
              " WHERE ( ORGCD1, ORGCD2 ) IN           " & vbLf & _
              "       ( SELECT ORGCD1, ORGCD2         " & vbLf & _
              "           FROM CTRMNG                 " & vbLf & _
              "          WHERE REFORGCD1 = :ORGCD1    " & vbLf & _
              "            AND REFORGCD2 = :ORGCD2    " & vbLf & _
              "            AND CTRPTCD   = :CTRPTCD ) " & vbLf & _
              "   FOR UPDATE                          "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードの有無で戻り値を決定
    LockOrgReferringContract = Not objOraDyna.EOF
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Contract.LockOrgReferringContract"
    
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
' 機能　　 : 契約パターンオプショングループテーブルを更新する(レコードが存在しない場合は挿入)
'
' 引数　　 : (In)     lngCtrPtCd       契約パターンコード
' 　　　　   (In)     strOptCd         オプションコード
' 　　　　   (In)     lngAddCondition  追加条件
' 　　　　   (In)     strHideRsvFra    検査結果
' 　　　　   (In)     strHideRsv       検査項目コード
' 　　　　   (In)     strHideRpt       サフィックス
' 　　　　   (In)     strHideQuestion  問診画面非表示
'
' 戻り値　 : エラーメッセージ
'
' 備考　　 :
'
Public Function MergeCtrPtOptGrp( _
    ByVal lngCtrPtCd As Long, _
    ByVal strOptCd As String, _
    ByVal lngAddCondition As Long, _
    ByVal strHideRsvFra As String, _
    ByVal strHideRsv As String, _
    ByVal strHideRpt As String, _
    ByVal strHideQuestion As String _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDCONDITION", lngAddCondition, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "HIDERSVFRA", IIf(strHideRsvFra <> "", CLng("0" & strHideRsvFra), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "HIDERSV", IIf(strHideRsv <> "", CLng("0" & strHideRsv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "HIDERPT", IIf(strHideRpt <> "", CLng("0" & strHideRpt), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "HIDEQUESTION", IIf(strHideQuestion <> "", CLng("0" & strHideQuestion), Null), ORAPARM_INPUT, ORATYPE_NUMBER

    '契約パターンオプショングループレコードの更新
    strStmt = "MERGE INTO CTRPT_OPTGRP                                            " & vbLf & _
              "      USING ( SELECT :CTRPTCD      CTRPTCD,                        " & vbLf & _
              "                     :OPTCD        OPTCD,                          " & vbLf & _
              "                     :ADDCONDITION ADDCONDITION,                   " & vbLf & _
              "                     :HIDERSVFRA   HIDERSVFRA,                     " & vbLf & _
              "                     :HIDERSV      HIDERSV,                        " & vbLf & _
              "                     :HIDERPT      HIDERPT,                        " & vbLf & _
              "                     :HIDEQUESTION HIDEQUESTION                    " & vbLf & _
              "                FROM DUAL                                          " & vbLf & _
              "            ) BASEDCTRPT_OPTGRP                                    " & vbLf & _
              "         ON ( CTRPT_OPTGRP.CTRPTCD = BASEDCTRPT_OPTGRP.CTRPTCD AND " & vbLf & _
              "              CTRPT_OPTGRP.OPTCD   = BASEDCTRPT_OPTGRP.OPTCD )     "

    '更新部
    strStmt = strStmt & vbLf & _
              "       WHEN MATCHED THEN                                                           " & vbLf & _
              "            UPDATE SET CTRPT_OPTGRP.ADDCONDITION = BASEDCTRPT_OPTGRP.ADDCONDITION, " & vbLf & _
              "                       CTRPT_OPTGRP.HIDERSVFRA   = BASEDCTRPT_OPTGRP.HIDERSVFRA,   " & vbLf & _
              "                       CTRPT_OPTGRP.HIDERSV      = BASEDCTRPT_OPTGRP.HIDERSV,      " & vbLf & _
              "                       CTRPT_OPTGRP.HIDERPT      = BASEDCTRPT_OPTGRP.HIDERPT,      " & vbLf & _
              "                       CTRPT_OPTGRP.HIDEQUESTION = BASEDCTRPT_OPTGRP.HIDEQUESTION  "

    '挿入部
    strStmt = strStmt & vbLf & _
              "       WHEN NOT MATCHED THEN                          " & vbLf & _
              "            INSERT ( CTRPT_OPTGRP.CTRPTCD,            " & vbLf & _
              "                     CTRPT_OPTGRP.OPTCD,              " & vbLf & _
              "                     CTRPT_OPTGRP.ADDCONDITION,       " & vbLf & _
              "                     CTRPT_OPTGRP.HIDERSVFRA,         " & vbLf & _
              "                     CTRPT_OPTGRP.HIDERSV,            " & vbLf & _
              "                     CTRPT_OPTGRP.HIDERPT,            " & vbLf & _
              "                     CTRPT_OPTGRP.HIDEQUESTION )      " & vbLf & _
              "            VALUES ( BASEDCTRPT_OPTGRP.CTRPTCD,       " & vbLf & _
              "                     BASEDCTRPT_OPTGRP.OPTCD,         " & vbLf & _
              "                     BASEDCTRPT_OPTGRP.ADDCONDITION,  " & vbLf & _
              "                     BASEDCTRPT_OPTGRP.HIDERSVFRA,    " & vbLf & _
              "                     BASEDCTRPT_OPTGRP.HIDERSV,       " & vbLf & _
              "                     BASEDCTRPT_OPTGRP.HIDERPT,       " & vbLf & _
              "                     BASEDCTRPT_OPTGRP.HIDEQUESTION ) "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    MergeCtrPtOptGrp = True
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Contract.MergeCtrPtOptGrp"
    
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
' 機能　　 : 指定団体の全コースの契約情報をコース昇順、契約期間昇順に取得する
'
' 引数　　 : (In)     strOrgCd1      団体コード1
' 　　　　   (In)     strOrgCd2      団体コード2
' 　　　　   (Out)    vntWebColor    webカラー
' 　　　　   (Out)    vntCsCd        コースコード
' 　　　　   (Out)    vntCsName      コース名
' 　　　　   (Out)    vntStrDate     契約開始日
' 　　　　   (Out)    vntEndDate     契約終了日
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectAllCourseCtrMng( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByRef vntWebColor As Variant, _
    ByRef vntCsCd As Variant, _
    ByRef vntCsName As Variant, _
    ByRef vntStrDate As Variant, _
    ByRef vntEndDate As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objWebColor         As OraField         'webカラー
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objStrDate          As OraField         '契約開始日
    Dim objEndDate          As OraField         '契約終了日
    
    Dim vntArrWebColor()    As Variant          'webカラーの配列
    Dim vntArrCsCd()        As Variant          'コースコードの配列
    Dim vntArrCsName()      As Variant          'コース名の配列
    Dim vntArrStrDate()     As Variant          '契約開始日の配列
    Dim vntArrEndDate()     As Variant          '契約終了日の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntWebColor = Empty
    vntCsCd = Empty
    vntCsName = Empty
    vntStrDate = Empty
    vntEndDate = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '指定団体の全コースの契約情報をコース昇順、契約期間昇順に取得
    strStmt = "SELECT COURSE_P.WEBCOLOR, COURSE_P.CSCD, COURSE_P.CSNAME, " & vbLf & _
              "       MYCTRMNG.STRDATE, MYCTRMNG.ENDDATE                 " & vbLf & _
              "  FROM ( SELECT CTRMNG.CSCD, CTRPT.STRDATE, CTRPT.ENDDATE " & vbLf & _
              "           FROM CTRPT, CTRMNG                             " & vbLf & _
              "          WHERE CTRMNG.ORGCD1 = :ORGCD1                   " & vbLf & _
              "            AND CTRMNG.ORGCD2 = :ORGCD2                   " & vbLf & _
              "            AND CTRMNG.CTRPTCD = CTRPT.CTRPTCD            " & vbLf & _
              "       ) MYCTRMNG, COURSE_P                               " & vbLf & _
              " WHERE COURSE_P.CSCD = MYCTRMNG.CSCD(+)                   " & vbLf & _
              " ORDER BY CSCD, STRDATE                                   "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            vntArrWebColor(lngCount) = objWebColor.Value
            vntArrCsCd(lngCount) = objCsCd.Value
            vntArrCsName(lngCount) = objCsName.Value
            vntArrStrDate(lngCount) = objStrDate.Value & ""
            vntArrEndDate(lngCount) = objEndDate.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntWebColor = vntArrWebColor
        vntCsCd = vntArrCsCd
        vntCsName = vntArrCsName
        vntStrDate = vntArrStrDate
        vntEndDate = vntArrEndDate
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectAllCourseCtrMng = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectAllCourseCtrMng = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectAllCourseCtrMng"
    
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
' 機能　　 : 指定団体の全契約情報(コース・参照先団体・契約期間)をコース昇順、契約期間降順に取得する
'
' 引数　　 : (In)     strOrgCd1      団体コード1
' 　　　　   (In)     strOrgCd2      団体コード2
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (In)     dtmStrDate     開始日付
' 　　　　   (In)     dtmEndDate     終了日付
' 　　　　   (Out)    vntWebColor    webカラー
' 　　　　   (Out)    vntCsCd        コースコード
' 　　　　   (Out)    vntCsName      コース名
' 　　　　   (Out)    vntCtrCsName   (契約パターン上での)コース名
' 　　　　   (Out)    vntRefOrgCd1   参照先団体コード1
' 　　　　   (Out)    vntRefOrgCd2   参照先団体コード2
' 　　　　   (Out)    vntOrgName     団体名称
' 　　　　   (Out)    vntCtrPtCd     契約パターンコード
' 　　　　   (Out)    vntStrDate     契約開始日
' 　　　　   (Out)    vntEndDate     契約終了日
' 　　　　   (Out)    vntAgeCalc     年齢起算日
' 　　　　   (Out)    vntReferred    他団体参照フラグ(他団体から参照されていればTrue)
' 　　　　   (In)     blnFirstCourse True指定時は１次健診コースのみ取得
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectAllCtrMng( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCsCd As String, _
    ByVal dtmStrDate As Date, _
    ByVal dtmEndDate As Date, _
    Optional ByRef vntWebColor As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntCtrCsName As Variant, _
    Optional ByRef vntRefOrgCd1 As Variant, _
    Optional ByRef vntRefOrgCd2 As Variant, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntCtrPtCd As Variant, _
    Optional ByRef vntStrDate As Variant, _
    Optional ByRef vntEndDate As Variant, _
    Optional ByRef vntAgeCalc As Variant, _
    Optional ByRef vntReferred As Variant, _
    Optional ByVal blnFirstCourse As Boolean = False _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objWebColor         As OraField         'webカラー
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objCtrCsName        As OraField         '(契約パターン上での)コース名
    Dim objRefOrgCd1        As OraField         '参照先団体コード1
    Dim objRefOrgCd2        As OraField         '参照先団体コード2
    Dim objOrgName          As OraField         '漢字名称
    Dim objCtrPtCd          As OraField         '契約パターンコード
    Dim objStrDate          As OraField         '契約開始日
    Dim objEndDate          As OraField         '契約終了日
    Dim objAgeCalc          As OraField         '年齢起算日
    Dim objRefCtrPtCd       As OraField         '他団体から参照されている契約パターンのコード
    
    Dim vntArrWebColor()    As Variant          'webカラーの配列
    Dim vntArrCsCd()        As Variant          'コースコードの配列
    Dim vntArrCsName()      As Variant          'コース名の配列
    Dim vntArrCtrCsName()   As Variant          '(契約パターン上での)コース名の配列
    Dim vntArrRefOrgCd1()   As Variant          '参照先団体コード1の配列
    Dim vntArrRefOrgCd2()   As Variant          '参照先団体コード2の配列
    Dim vntArrOrgName()     As Variant          '漢字名称の配列
    Dim vntArrCtrPtCd()     As Variant          '契約パターンコードの配列
    Dim vntArrStrDate()     As Variant          '契約開始日の配列
    Dim vntArrEndDate()     As Variant          '契約終了日の配列
    Dim vntArrReferred()    As Variant          '他団体参照フラグの配列
    Dim vntArrAgeCalc()     As Variant          '年齢起算日の配列
    Dim lngCount            As Long             'レコード数
    
    Dim dtmKeyStrDate       As Date             '契約開始日
    Dim dtmKeyEndDate       As Date             '契約終了日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntCtrCsName) Then vntCtrCsName = Empty
    If Not IsMissing(vntRefOrgCd1) Then vntRefOrgCd1 = Empty
    If Not IsMissing(vntRefOrgCd2) Then vntRefOrgCd2 = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = Empty
    If Not IsMissing(vntStrDate) Then vntStrDate = Empty
    If Not IsMissing(vntEndDate) Then vntEndDate = Empty
    If Not IsMissing(vntAgeCalc) Then vntAgeCalc = Empty
    If Not IsMissing(vntReferred) Then vntReferred = Empty
    lngCount = 0
    
    '契約期間の設定
    If dtmStrDate <= dtmEndDate Then
        dtmKeyStrDate = dtmStrDate
        dtmKeyEndDate = dtmEndDate
    Else
        dtmKeyStrDate = dtmEndDate
        dtmKeyEndDate = dtmStrDate
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", dtmKeyStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmKeyEndDate, ORAPARM_INPUT, ORATYPE_DATE
    
    '指定団体の全契約情報(コース・参照先団体・契約期間・他団体からの参照状態)を取得
    strStmt = "SELECT COURSE_P.WEBCOLOR, CTRMNG.CSCD,         COURSE_P.CSNAME,       " & vbLf & _
              "       CTRMNG.REFORGCD1,  CTRMNG.REFORGCD2,    ORG.ORGNAME,           " & vbLf & _
              "       CTRMNG.CTRPTCD,    CTRPT.STRDATE,       CTRPT.ENDDATE,         " & vbLf & _
              "       CTRPT.AGECALC,     REFERRED.REFCTRPTCD, CTRPT.CSNAME CTRCSNAME "

    '自団体の契約パターンを参照している契約団体の有無を取得する副問い合わせ(自団体の契約情報は除く)
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT DISTINCT CTRPTCD REFCTRPTCD                    " & vbLf & _
              "           FROM CTRMNG                                         " & vbLf & _
              "          WHERE REFORGCD1 = :ORGCD1                            " & vbLf & _
              "            AND REFORGCD2 = :ORGCD2                            " & vbLf & _
              "            AND ( ORGCD1 != REFORGCD1 OR ORGCD2 != REFORGCD2 ) " & vbLf & _
              "       ) REFERRED,                                             "

    '契約管理情報に対し、契約パターン・団体・コース情報を結合
    strStmt = strStmt & vbLf & _
              "       CTRPT, ORG, COURSE_P, CTRMNG " & vbLf & _
              " WHERE CTRMNG.ORGCD1    = :ORGCD1   " & vbLf & _
              "   AND CTRMNG.ORGCD2    = :ORGCD2   "
              
    'コースコード指定時は条件節に加える
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CTRMNG.CSCD      = :CSCD "
    End If
    
    'コース、契約パターン、団体を結合
    strStmt = strStmt & vbLf & _
              "   AND CTRMNG.CSCD      = COURSE_P.CSCD " & vbLf & _
              "   AND CTRMNG.REFORGCD1 = ORG.ORGCD1    " & vbLf & _
              "   AND CTRMNG.REFORGCD2 = ORG.ORGCD2    " & vbLf & _
              "   AND CTRMNG.CTRPTCD   = CTRPT.CTRPTCD "

    '開始日付指定時は条件節に加える
    If dtmStrDate > 0 Then
        strStmt = strStmt & vbLf & _
              "   AND CTRPT.ENDDATE   >= :STRDATE "
    End If
    
    '終了日付指定時は条件節に加える
    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "   AND CTRPT.STRDATE   <= :ENDDATE "
    End If
    
    '自団体の契約パターンを参照している契約団体が存在すればそれを結合(実際は契約パターンコードで結合)
    strStmt = strStmt & vbLf & _
              "   AND CTRMNG.CTRPTCD   = REFERRED.REFCTRPTCD(+) "

    '１次健診のみ指定時は条件節に加える
    If blnFirstCourse Then
        strStmt = strStmt & vbLf & _
              "   AND COURSE_P.SECONDFLG = 0"
    End If

    'コース昇順、契約期間降順に取得する
    strStmt = strStmt & vbLf & _
              " ORDER BY CTRMNG.CSCD, CTRPT.STRDATE DESC "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objCtrCsName = objFields("CTRCSNAME")
        Set objRefOrgCd1 = objFields("REFORGCD1")
        Set objRefOrgCd2 = objFields("REFORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objCtrPtCd = objFields("CTRPTCD")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objAgeCalc = objFields("AGECALC")
        Set objRefCtrPtCd = objFields("REFCTRPTCD")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrCtrCsName(lngCount)
            ReDim Preserve vntArrRefOrgCd1(lngCount)
            ReDim Preserve vntArrRefOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrCtrPtCd(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            ReDim Preserve vntArrAgeCalc(lngCount)
            ReDim Preserve vntArrReferred(lngCount)
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrCtrCsName(lngCount) = objCtrCsName.Value & ""
            vntArrRefOrgCd1(lngCount) = objRefOrgCd1.Value & ""
            vntArrRefOrgCd2(lngCount) = objRefOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrCtrPtCd(lngCount) = objCtrPtCd.Value & ""
            vntArrStrDate(lngCount) = objStrDate.Value & ""
            vntArrEndDate(lngCount) = objEndDate.Value & ""
            vntArrAgeCalc(lngCount) = objAgeCalc.Value & ""
            vntArrReferred(lngCount) = Not IsNull(objRefCtrPtCd.Value)
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntCtrCsName) Then vntCtrCsName = vntArrCtrCsName
        If Not IsMissing(vntRefOrgCd1) Then vntRefOrgCd1 = vntArrRefOrgCd1
        If Not IsMissing(vntRefOrgCd2) Then vntRefOrgCd2 = vntArrRefOrgCd2
        If Not IsMissing(vntOrgName) Then vntOrgName = vntArrOrgName
        If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = vntArrCtrPtCd
        If Not IsMissing(vntStrDate) Then vntStrDate = vntArrStrDate
        If Not IsMissing(vntEndDate) Then vntEndDate = vntArrEndDate
        If Not IsMissing(vntAgeCalc) Then vntAgeCalc = vntArrAgeCalc
        If Not IsMissing(vntReferred) Then vntReferred = vntArrReferred
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectAllCtrMng = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectAllCtrMng = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectAllCtrMng"
    
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
' 機能　　 : 指定団体、コース、日付において有効な全ての受診区分を取得する
'
' 引数　　 : (In)     strOrgCd1      団体コード1
' 　　　　   (In)     strOrgCd2      団体コード2
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (In)     dtmStrDate     開始日付
' 　　　　   (In)     dtmEndDate     終了日付
' 　　　　   (Out)    vntCslDivCd    受診区分コード
' 　　　　   (Out)    vntCslDivName  受診区分名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectAllCslDiv( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCsCd As String, _
    ByVal dtmStrDate As Date, _
    ByVal dtmEndDate As Date, _
    ByRef vntCslDivCd As Variant, _
    ByRef vntCslDivName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCslDivCd         As OraField         '受診区分コード
    Dim objCslDivName       As OraField         '受診区分名
    
    Dim vntArrCslDivCd()    As Variant          '受診区分コードの配列
    Dim vntArrCslDivName()  As Variant          '受診区分名の配列
    Dim lngCount            As Long             'レコード数
    
    Dim dtmKeyStrDate       As Date             '契約開始日
    Dim dtmKeyEndDate       As Date             '契約終了日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCslDivCd = Empty
    vntCslDivName = Empty
    lngCount = 0
    
    '契約期間の設定
    If dtmStrDate <= dtmEndDate Then
        dtmKeyStrDate = dtmStrDate
        dtmKeyEndDate = dtmEndDate
    Else
        dtmKeyStrDate = dtmEndDate
        dtmKeyEndDate = dtmStrDate
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", IIf(strCsCd <> "", strCsCd, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", dtmKeyStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", IIf(dtmKeyEndDate > 0, dtmKeyEndDate, CDate("2200/12/31")), ORAPARM_INPUT, ORATYPE_DATE
    
    '指定団体、コース、日付において有効な全ての受診区分を取得する
'## 2003.11.23 Mod By T.Takagi 「指定なし」を必ず含める
'    strStmt = "SELECT ALLCSLDIV.CSLDIVCD, CSLDIV.CSLDIVNAME              " & vbLf & _
'              "  FROM CSLDIV,                                            " & vbLf & _
'              "       ( SELECT DISTINCT CTRPT_OPT.CSLDIVCD               " & vbLf & _
'              "           FROM CTRPT_OPT, CTRPT, CTRMNG                  " & vbLf & _
'              "          WHERE CTRMNG.ORGCD1   = :ORGCD1                 " & vbLf & _
'              "            AND CTRMNG.ORGCD2   = :ORGCD2                 " & vbLf & _
'              "            AND CTRMNG.CSCD     = NVL(:CSCD, CTRMNG.CSCD) " & vbLf & _
'              "            AND CTRMNG.CTRPTCD  = CTRPT.CTRPTCD           " & vbLf & _
'              "            AND CTRPT.ENDDATE  >= :STRDATE                " & vbLf & _
'              "            AND CTRPT.STRDATE  <= :ENDDATE                " & vbLf & _
'              "            AND CTRMNG.CTRPTCD  = CTRPT_OPT.CTRPTCD       " & vbLf & _
'              "       ) ALLCSLDIV                                        " & vbLf & _
'              " WHERE ALLCSLDIV.CSLDIVCD = CSLDIV.CSLDIVCD               "
    strStmt = "SELECT ALLCSLDIV.CSLDIVCD, CSLDIV.CSLDIVNAME              " & vbLf & _
              "  FROM CSLDIV,                                            " & vbLf & _
              "       ( SELECT CTRPT_OPT.CSLDIVCD                        " & vbLf & _
              "           FROM CTRPT_OPT, CTRPT, CTRMNG                  " & vbLf & _
              "          WHERE CTRMNG.ORGCD1   = :ORGCD1                 " & vbLf & _
              "            AND CTRMNG.ORGCD2   = :ORGCD2                 " & vbLf & _
              "            AND CTRMNG.CSCD     = NVL(:CSCD, CTRMNG.CSCD) " & vbLf & _
              "            AND CTRMNG.CTRPTCD  = CTRPT.CTRPTCD           " & vbLf & _
              "            AND CTRPT.ENDDATE  >= :STRDATE                " & vbLf & _
              "            AND CTRPT.STRDATE  <= :ENDDATE                " & vbLf & _
              "            AND CTRMNG.CTRPTCD  = CTRPT_OPT.CTRPTCD       " & vbLf & _
              "          UNION                                           " & vbLf & _
              "         SELECT 'CSLDIV000' CSLDIVCD                      " & vbLf & _
              "           FROM DUAL                                      " & vbLf & _
              "       ) ALLCSLDIV                                        " & vbLf & _
              " WHERE ALLCSLDIV.CSLDIVCD = CSLDIV.CSLDIVCD               "
'## 2003.11.23 Mod End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDivCd = objFields("CSLDIVCD")
        Set objCslDivName = objFields("CSLDIVNAME")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCslDivCd(lngCount)
            ReDim Preserve vntArrCslDivName(lngCount)
            vntArrCslDivCd(lngCount) = objCslDivCd.Value & ""
            vntArrCslDivName(lngCount) = objCslDivName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntCslDivCd = vntArrCslDivCd
        vntCslDivName = vntArrCslDivName
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectAllCslDiv = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectAllCslDiv = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectAllCslDiv"
    
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
' 機能　　 : 指定団体・コース・契約パターンにおける契約管理情報を取得する
'
' 引数　　 : (In)     strOrgCd1       団体コード１
' 　　　　   (In)     strOrgCd2       団体コード２
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (Out)    vntOrgName      漢字名称
' 　　　　   (Out)    vntCsCd         コースコード
' 　　　　   (Out)    vntCsName       コース名
' 　　　　   (Out)    vntStrDate      契約開始日
' 　　　　   (Out)    vntEndDate      契約終了日
' 　　　　   (Out)    vntTaxFraction  税端数区分
' 　　　　   (Out)    vntReportCd     帳票コード
' 　　　　   (Out)    vntRefOrgCd1    参照先団体コード１
' 　　　　   (Out)    vntRefOrgCd1    参照先団体コード２
' 　　　　   (Out)    vntAgeCalc      年齢起算日
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectCtrMng( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntStrDate As Variant, _
    Optional ByRef vntEndDate As Variant, _
    Optional ByRef vntTaxFraction As Variant, _
    Optional ByRef vntReportCd As Variant, _
    Optional ByRef vntRefOrgCd1 As Variant, _
    Optional ByRef vntRefOrgCd2 As Variant, _
    Optional ByRef vntAgeCalc As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objOrgName      As OraField         '漢字名称
    Dim objCsCd         As OraField         'コースコード
    Dim objCsName       As OraField         'コース名
    Dim objStrDate      As OraField         '契約開始日
    Dim objEndDate      As OraField         '契約終了日
    Dim objTaxFraction  As OraField         '税端数区分
    Dim objReportCd     As OraField         '帳票コード
    Dim objRefOrgCd1    As OraField         '参照先団体コード１
    Dim objRefOrgCd2    As OraField         '参照先団体コード２
    Dim objAgeCalc      As OraField         '年齢起算日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntStrDate) Then vntStrDate = Empty
    If Not IsMissing(vntEndDate) Then vntEndDate = Empty
    If Not IsMissing(vntTaxFraction) Then vntTaxFraction = Empty
    If Not IsMissing(vntReportCd) Then vntReportCd = Empty
    If Not IsMissing(vntRefOrgCd1) Then vntRefOrgCd1 = Empty
    If Not IsMissing(vntRefOrgCd2) Then vntRefOrgCd2 = Empty
    If Not IsMissing(vntAgeCalc) Then vntAgeCalc = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす契約管理テーブルのレコードを取得
    strStmt = "SELECT ORG.ORGNAME,                   " & vbLf & _
              "       CTRMNG.CSCD,                   " & vbLf & _
              "       COURSE_P.CSNAME,               " & vbLf & _
              "       CTRPT.STRDATE,                 " & vbLf & _
              "       CTRPT.ENDDATE,                 " & vbLf & _
              "       CTRPT.AGECALC,                 " & vbLf & _
              "       CTRPT.TAXFRACTION,             " & vbLf & _
              "       CTRMNG.REPORTCD,               " & vbLf & _
              "       CTRMNG.REFORGCD1,              " & vbLf & _
              "       CTRMNG.REFORGCD2               " & vbLf & _
              "  FROM COURSE_P, ORG, CTRPT, CTRMNG   " & vbLf & _
              " WHERE CTRMNG.ORGCD1  = :ORGCD1       " & vbLf & _
              "   AND CTRMNG.ORGCD2  = :ORGCD2       " & vbLf & _
              "   AND CTRMNG.CTRPTCD = :CTRPTCD      " & vbLf & _
              "   AND CTRMNG.CTRPTCD = CTRPT.CTRPTCD " & vbLf & _
              "   AND CTRMNG.ORGCD1  = ORG.ORGCD1    " & vbLf & _
              "   AND CTRMNG.ORGCD2  = ORG.ORGCD2    " & vbLf & _
              "   AND CTRMNG.CSCD    = COURSE_P.CSCD "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgName = objFields("ORGNAME")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objTaxFraction = objFields("TAXFRACTION")
        Set objReportCd = objFields("REPORTCD")
        Set objRefOrgCd1 = objFields("REFORGCD1")
        Set objRefOrgCd2 = objFields("REFORGCD2")
        Set objAgeCalc = objFields("AGECALC")
        
        '戻り値の設定
        If Not IsMissing(vntOrgName) Then vntOrgName = objOrgName.Value & ""
        If Not IsMissing(vntCsCd) Then vntCsCd = objCsCd.Value & ""
        If Not IsMissing(vntCsName) Then vntCsName = objCsName.Value & ""
        If Not IsMissing(vntStrDate) Then vntStrDate = objStrDate.Value & ""
        If Not IsMissing(vntEndDate) Then vntEndDate = objEndDate.Value & ""
        If Not IsMissing(vntTaxFraction) Then vntTaxFraction = objTaxFraction.Value & ""
        If Not IsMissing(vntReportCd) Then vntReportCd = objReportCd.Value & ""
        If Not IsMissing(vntRefOrgCd1) Then vntRefOrgCd1 = objRefOrgCd1.Value & ""
        If Not IsMissing(vntRefOrgCd2) Then vntRefOrgCd2 = objRefOrgCd2.Value & ""
        If Not IsMissing(vntAgeCalc) Then vntAgeCalc = objAgeCalc.Value & ""
        
        SelectCtrMng = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrMng = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrMng"
    
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
' 機能　　 : 指定団体の契約管理情報にて管理する全てのコースを取得する
'
' 引数　　 : (In)     strOrgCd1  団体コード1
' 　　　　   (In)     strOrgCd2  団体コード2
' 　　　　   (Out)    vntCsCd    コースコード
' 　　　　   (Out)    vntCsName  コース名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrMngCourse( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByRef vntCsCd As Variant, _
    ByRef vntCsName As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCsCd         As OraField         'コースコード
    Dim objCsName       As OraField         'コース名
    
    Dim vntArrCsCd()    As Variant          'コースコードの配列
    Dim vntArrCsName()  As Variant          'コース名の配列
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCsCd = Empty
    vntCsName = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '指定団体の契約管理情報にて管理する全てのコースを取得する
    strStmt = "SELECT DISTINCT                      " & vbLf & _
              "       CTRMNG.CSCD, COURSE_P.CSNAME  " & vbLf & _
              "  FROM COURSE_P, CTRMNG              " & vbLf & _
              " WHERE CTRMNG.ORGCD1 = :ORGCD1       " & vbLf & _
              "   AND CTRMNG.ORGCD2 = :ORGCD2       " & vbLf & _
              "   AND CTRMNG.CSCD   = COURSE_P.CSCD "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            vntArrCsCd(lngCount) = objCsCd.Value
            vntArrCsName(lngCount) = objCsName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntCsCd = vntArrCsCd
        vntCsName = vntArrCsName
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrMngCourse = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrMngCourse = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrMngCourse"
    
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
' 機能　　 : 参照先団体の契約情報が参照元団体から参照可能かをチェックし、その状態を返す
'
' 引数　　 : (In)     strOrgCd1     参照元団体コード1
' 　　　　   (In)     strOrgCd2     参照元団体コード2
' 　　　　   (In)     strRefOrgCd1  参照先団体コード1
' 　　　　   (In)     strRefOrgCd2  参照先団体コード2
' 　　　　   (In/Out) vntCsCd       コースコード
' 　　　　   (In/Out) vntCtrPtCd    契約パターンコード
' 　　　　   (Out)    vntStrDate    契約開始日
' 　　　　   (Out)    vntEndDate    契約終了日
' 　　　　   (Out)    vntOrgEquals  参照先団体一致フラグ(参照先団体の参照先が参照元団体と等しい場合にTrue)
' 　　　　   (Out)    vntReferred   参照済みフラグ(参照先団体の契約情報がすでに参照元団体から参照されている場合にTrue)
' 　　　　   (Out)    vntOverlap    契約期間重複フラグ(参照先団体の契約期間が参照元団体のそれと重複する場合にTrue)
' 　　　　   (Out)    vntExistBdn   負担元存在フラグ(参照先団体の負担元として参照元団体が存在する場合にTrue)
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrMngRefer( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strRefOrgCd1 As String, _
    ByVal strRefOrgCd2 As String, _
    ByRef vntCsCd As Variant, _
    ByRef vntCtrPtCd As Variant, _
    ByRef vntStrDate As Variant, _
    ByRef vntEndDate As Variant, _
    ByRef vntOrgEquals As Variant, _
    ByRef vntReferred As Variant, _
    ByRef vntOverlap As Variant, _
    ByRef vntExistBdn As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim strCsCd             As String           'コースコード
    Dim lngCtrPtCd          As Long             '契約パターンコード
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCsCd             As OraField         'コースコード
    Dim objCtrPtCd          As OraField         '契約パターンコード
    Dim objStrDate          As OraField         '契約開始日
    Dim objEndDate          As OraField         '契約終了日
    Dim objOrgEquals        As OraField         '参照先団体一致フラグ
    Dim objReferred         As OraField         '参照済みフラグ
    Dim objOverlap          As OraField         '契約期間重複フラグ
    Dim objExistBdn         As OraField         '負担元存在フラグ
    
    Dim vntArrCsCd()        As Variant          'コースコードの配列
    Dim vntArrCtrPtCd()     As Variant          '契約パターンコードの配列
    Dim vntArrStrDate()     As Variant          '契約開始日の配列
    Dim vntArrEndDate()     As Variant          '契約終了日の配列
    Dim vntArrOrgEquals()   As Variant          '参照先団体一致フラグの配列
    Dim vntArrReferred()    As Variant          '参照済みフラグの配列
    Dim vntArrOverlap()     As Variant          '契約期間重複フラグの配列
    Dim vntArrExistBdn()    As Variant          '負担元存在フラグの配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '引数値の取得
    strCsCd = Trim(vntCsCd)
    If Not IsArray(vntCtrPtCd) Then
        lngCtrPtCd = CLng("0" & Trim(vntCtrPtCd))
    End If
    
    'コース未指定時は戻り値として返すので初期化
    If strCsCd = "" Then
        vntCsCd = Empty
    End If
    
    '契約パターン未指定時は戻り値として返すので初期化
    If lngCtrPtCd = 0 Then
        vntCtrPtCd = Empty
    End If
    
    'その他の初期処理
    vntStrDate = Empty
    vntEndDate = Empty
    vntOrgEquals = Empty
    vntReferred = Empty
    vntOverlap = Empty
    vntExistBdn = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REFORGCD1", Trim(strRefOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REFORGCD2", Trim(strRefOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '参照先団体の契約情報が参照元団体から参照可能かをチェック
    strStmt = "SELECT CTRMNG_AND_ORG.CSCD,    " & vbLf & _
              "       CTRMNG_AND_ORG.CTRPTCD, " & vbLf & _
              "       CTRMNG_AND_ORG.STRDATE, " & vbLf & _
              "       CTRMNG_AND_ORG.ENDDATE, "
              
    '参照先団体の参照先が参照元団体と等しいかチェック
    strStmt = strStmt & vbLf & _
              "       CASE WHEN CTRMNG_AND_ORG.REFREFORGCD1 = CTRMNG_AND_ORG.ORGCD1 " & vbLf & _
              "             AND CTRMNG_AND_ORG.REFREFORGCD2 = CTRMNG_AND_ORG.ORGCD2 " & vbLf & _
              "            THEN 1                                                   " & vbLf & _
              "            ELSE 0                                                   " & vbLf & _
              "       END ORGEQUALS,                                                "
              
    '同一コース内において参照先団体の契約期間と期間が重複する参照元団体の契約情報数をカウント
    strStmt = strStmt & vbLf & _
              "       ( SELECT DECODE(COUNT(*), 0, 0, 1)               " & vbLf & _
              "           FROM CTRPT, CTRMNG                           " & vbLf & _
              "          WHERE CTRMNG.ORGCD1  = CTRMNG_AND_ORG.ORGCD1  " & vbLf & _
              "            AND CTRMNG.ORGCD2  = CTRMNG_AND_ORG.ORGCD2  " & vbLf & _
              "            AND CTRMNG.CSCD    = CTRMNG_AND_ORG.CSCD    " & vbLf & _
              "            AND CTRMNG.CTRPTCD = CTRPT.CTRPTCD          " & vbLf & _
              "            AND CTRPT.ENDDATE >= CTRMNG_AND_ORG.STRDATE " & vbLf & _
              "            AND CTRPT.STRDATE <= CTRMNG_AND_ORG.ENDDATE " & vbLf & _
              "       ) OVERLAP,                                       "
    
    '参照先団体の契約情報の負担元として参照先団体が存在するかをチェック
    strStmt = strStmt & vbLf & _
              "       NVL2(CTRPT_ORG.CTRPTCD, 1, 0) EXISTBDN, "

    '同一契約パターンの契約情報がすでに参照元団体の契約情報として存在するかをチェック
    strStmt = strStmt & vbLf & _
              "       NVL2(CTRMNG.CTRPTCD, 1, 0) REFERRED "

    '参照先団体の全契約情報を基本表とする
    strStmt = strStmt & vbLf & _
              "  FROM CTRMNG, CTRPT_ORG,                      " & vbLf & _
              "       ( SELECT CTRMNG.ORGCD1 REFORGCD1,       " & vbLf & _
              "                CTRMNG.ORGCD2 REFORGCD2,       " & vbLf & _
              "                CTRMNG.CSCD,                   " & vbLf & _
              "                CTRMNG.REFORGCD1 REFREFORGCD1, " & vbLf & _
              "                CTRMNG.REFORGCD2 REFREFORGCD2, " & vbLf & _
              "                CTRMNG.CTRPTCD,                " & vbLf & _
              "                CTRPT.STRDATE,                 " & vbLf & _
              "                CTRPT.ENDDATE,                 " & vbLf & _
              "                :ORGCD1 ORGCD1,                " & vbLf & _
              "                :ORGCD2 ORGCD2                 " & vbLf & _
              "           FROM CTRPT, CTRMNG                  " & vbLf & _
              "          WHERE CTRMNG.ORGCD1  = :REFORGCD1    " & vbLf & _
              "            AND CTRMNG.ORGCD2  = :REFORGCD2    " & vbLf & _
              "            AND CTRMNG.CTRPTCD = CTRPT.CTRPTCD " & vbLf & _
              "       ) CTRMNG_AND_ORG                        "
              
    '参照先団体の契約情報の負担元として参照先団体が存在するかをチェックするため、負担元管理情報との外部結合を行う
    strStmt = strStmt & vbLf & _
              " WHERE CTRMNG_AND_ORG.CTRPTCD = CTRPT_ORG.CTRPTCD(+) " & vbLf & _
              "   AND CTRMNG_AND_ORG.ORGCD1  = CTRPT_ORG.ORGCD1(+)  " & vbLf & _
              "   AND CTRMNG_AND_ORG.ORGCD2  = CTRPT_ORG.ORGCD2(+)  "
              
    '同一契約パターンの契約情報がすでに参照元団体の契約情報として存在するかをチェックするため、契約管理情報との外部結合を行う
    strStmt = strStmt & vbLf & _
              "   AND CTRMNG_AND_ORG.ORGCD1  = CTRMNG.ORGCD1(+)  " & vbLf & _
              "   AND CTRMNG_AND_ORG.ORGCD2  = CTRMNG.ORGCD2(+)  " & vbLf & _
              "   AND CTRMNG_AND_ORG.CTRPTCD = CTRMNG.CTRPTCD(+) "

    'コース指定時は条件節に追加する
    If strCsCd <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CTRMNG_AND_ORG.CSCD    = :CSCD "
    End If
    
    '契約パターン指定時は条件節に追加する
    If lngCtrPtCd > 0 Then
        strStmt = strStmt & vbLf & _
              "   AND CTRMNG_AND_ORG.CTRPTCD = :CTRPTCD "
    End If
    
    'コース、契約開始日の昇順に取得する
    strStmt = strStmt & vbLf & _
              " ORDER BY CSCD, STRDATE "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    Do
        '検索レコードが存在しない場合は何もしない
        If objOraDyna.EOF Then
            Exit Do
        End If
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCd = objFields("CSCD")
        Set objCtrPtCd = objFields("CTRPTCD")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objOrgEquals = objFields("ORGEQUALS")
        Set objReferred = objFields("REFERRED")
        Set objOverlap = objFields("OVERLAP")
        Set objExistBdn = objFields("EXISTBDN")
        
        '契約パターン指定時は単数レコードしか帰らないので、戻り値をそのまま編集
        If lngCtrPtCd > 0 Then
        
            '戻り値の設定
            vntCsCd = objCsCd.Value
            vntStrDate = objStrDate.Value
            vntEndDate = objEndDate.Value
            vntOrgEquals = (CLng(objOrgEquals.Value) = 1)
            vntReferred = (CLng(objReferred.Value) = 1)
            vntOverlap = (CLng(objOverlap.Value) = 1)
            vntExistBdn = (CLng(objExistBdn.Value) = 1)
            lngCount = 1
            
            Exit Do
        End If
        
        'それ以外は複数レコードが帰る場合もあるため、配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCtrPtCd(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            ReDim Preserve vntArrOrgEquals(lngCount)
            ReDim Preserve vntArrReferred(lngCount)
            ReDim Preserve vntArrOverlap(lngCount)
            ReDim Preserve vntArrExistBdn(lngCount)
            vntArrCsCd(lngCount) = objCsCd.Value
            vntArrCtrPtCd(lngCount) = objCtrPtCd.Value
            vntArrStrDate(lngCount) = objStrDate.Value
            vntArrEndDate(lngCount) = objEndDate.Value
            vntArrOrgEquals(lngCount) = (CLng(objOrgEquals.Value) = 1)
            vntArrReferred(lngCount) = (CLng(objReferred.Value) = 1)
            vntArrOverlap(lngCount) = (CLng(objOverlap.Value) = 1)
            vntArrExistBdn(lngCount) = (CLng(objExistBdn.Value) = 1)
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        'コースコード未指定時は配列で返すため、戻り値として編集
        If strCsCd = "" Then
            vntCsCd = vntArrCsCd
        End If
        
        'その他の戻り値の設定
        vntCtrPtCd = vntArrCtrPtCd
        vntStrDate = vntArrStrDate
        vntEndDate = vntArrEndDate
        vntOrgEquals = vntArrOrgEquals
        vntReferred = vntArrReferred
        vntOverlap = vntArrOverlap
        vntExistBdn = vntArrExistBdn
        
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrMngRefer = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrMngRefer = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrMngRefer"
    
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
' 機能　　 : 契約期間付きの契約管理情報を取得する
'
' 引数　　 : (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
' 　　　　   (In)     strCsCd     コースコード
' 　　　　   (Out)    vntCtrPtCd  契約パターンコード
' 　　　　   (Out)    vntStrDate  契約開始日
' 　　　　   (Out)    vntEndDate  契約終了日
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrMngWithPeriod( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCsCd As String, _
    ByRef vntCtrPtCd As Variant, _
    ByRef vntStrDate As Variant, _
    ByRef vntEndDate As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCtrPtCd      As OraField         '契約パターンコード
    Dim objStrDate      As OraField         '契約開始日
    Dim objEndDate      As OraField         '契約終了日
    
    Dim vntArrCtrPtCd() As Variant          '契約パターンコードの配列
    Dim vntArrStrDate() As Variant          '契約開始日の配列
    Dim vntArrEndDate() As Variant          '契約終了日の配列
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCtrPtCd = Empty
    vntStrDate = Empty
    vntEndDate = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '契約期間付きの契約管理情報を取得
    strStmt = "SELECT CTRPTCD, STRDATE, ENDDATE " & vbLf & _
              "  FROM CTRMNGWITHPERIOD          " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1          " & vbLf & _
              "   AND ORGCD2 = :ORGCD2          " & vbLf & _
              "   AND CSCD   = :CSCD            " & vbLf & _
              " ORDER BY STRDATE"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCtrPtCd = objFields("CTRPTCD")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCtrPtCd(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            vntArrCtrPtCd(lngCount) = objCtrPtCd.Value
            vntArrStrDate(lngCount) = objStrDate.Value
            vntArrEndDate(lngCount) = objEndDate.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntCtrPtCd = vntArrCtrPtCd
        vntStrDate = vntArrStrDate
        vntEndDate = vntArrEndDate
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrMngWithPeriod = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrMngWithPeriod = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrMngWithPeriod"
    
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
' 機能　　 : 指定契約パターンの契約期間および年齢起算日を取得する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (Out)    vntStrDate      契約開始日
' 　　　　   (Out)    vntEndDate      契約終了日
' 　　　　   (Out)    vntTaxFraction  税端数区分
' 　　　　   (Out)    vntAgeCalc      年齢起算日
' 　　　　   (Out)    vntCsName       コース名
' 　　　　   (Out)    vntCsEName      英語コース名
' 　　　　   (Out)    vntCslMethod    予約方法
' 　　　　   (Out)    vntLimitRate    限度率
' 　　　　   (Out)    vntLimitTaxFlg  限度額消費税フラグ
' 　　　　   (Out)    vntLimitPrice   上限金額
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし
'
' 備考　　 :
'
Public Function SelectCtrPt( _
    ByVal lngCtrPtCd As Long, _
    Optional ByRef vntStrDate As Variant, _
    Optional ByRef vntEndDate As Variant, _
    Optional ByRef vntAgeCalc As Variant, _
    Optional ByRef vntTaxFraction As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntCsEName As Variant, _
    Optional ByRef vntCslMethod As Variant, _
    Optional ByRef vntLimitRate As Variant, _
    Optional ByRef vntLimitTaxFlg As Variant, _
    Optional ByRef vntLimitPrice As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objStrDate      As OraField         '契約開始日
    Dim objEndDate      As OraField         '契約終了日
    Dim objTaxFraction  As OraField         '税端数区分
    Dim objAgeCalc      As OraField         '年齢起算日
    Dim objCsName       As OraField         'コース名
    Dim objCsEName      As OraField         '英語コース名
    Dim objCslMethod    As OraField         '予約方法
    Dim objLimitRate    As OraField         '限度率
    Dim objLimitTaxFlg  As OraField         '限度額消費税フラグ
    Dim objLimitPrice   As OraField         '上限金額
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntStrDate) Then vntStrDate = Empty
    If Not IsMissing(vntEndDate) Then vntEndDate = Empty
    If Not IsMissing(vntTaxFraction) Then vntTaxFraction = Empty
    If Not IsMissing(vntAgeCalc) Then vntAgeCalc = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntCsEName) Then vntCsEName = Empty
    If Not IsMissing(vntCslMethod) Then vntCslMethod = Empty
    If Not IsMissing(vntLimitRate) Then vntLimitRate = Empty
    If Not IsMissing(vntLimitTaxFlg) Then vntLimitTaxFlg = Empty
    If Not IsMissing(vntLimitPrice) Then vntLimitPrice = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす契約パターンテーブルのレコードを取得
    strStmt = "SELECT STRDATE,   ENDDATE,     AGECALC, TAXFRACTION, " & vbLf & _
              "       CSNAME,    CSENAME,     CSLMETHOD,            " & vbLf & _
              "       LIMITRATE, LIMITTAXFLG, LIMITPRICE            " & vbLf & _
              "  FROM CTRPT                                         " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD                            "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objTaxFraction = objFields("TAXFRACTION")
        Set objAgeCalc = objFields("AGECALC")
        Set objCsName = objFields("CSNAME")
        Set objCsEName = objFields("CSENAME")
        Set objCslMethod = objFields("CSLMETHOD")
        Set objLimitRate = objFields("LIMITRATE")
        Set objLimitTaxFlg = objFields("LIMITTAXFLG")
        Set objLimitPrice = objFields("LIMITPRICE")
        
        '戻り値の設定
        If Not IsMissing(vntStrDate) Then vntStrDate = objStrDate.Value & ""
        If Not IsMissing(vntEndDate) Then vntEndDate = objEndDate.Value & ""
        If Not IsMissing(vntTaxFraction) Then vntTaxFraction = objTaxFraction.Value & ""
        If Not IsMissing(vntAgeCalc) Then vntAgeCalc = objAgeCalc.Value & ""
        If Not IsMissing(vntCsName) Then vntCsName = objCsName.Value & ""
        If Not IsMissing(vntCsEName) Then vntCsEName = objCsEName.Value & ""
        If Not IsMissing(vntCslMethod) Then vntCslMethod = objCslMethod.Value & ""
        If Not IsMissing(vntLimitRate) Then vntLimitRate = objLimitRate.Value & ""
        If Not IsMissing(vntLimitTaxFlg) Then vntLimitTaxFlg = objLimitTaxFlg.Value & ""
        If Not IsMissing(vntLimitPrice) Then vntLimitPrice = objLimitPrice.Value & ""
        
        SelectCtrPt = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPt = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPt"
    
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
' 機能　　 : 受診日、コース、団体の条件に合致する契約パターンを取得する
'
' 引数　　 : (In)     dtmCslDate  受診日
' 　　　　   (In)     strCsCd     コースコード
' 　　　　   (In)     strOrgCd1   団体コード1
' 　　　　   (In)     strOrgCd2   団体コード2
'
' 戻り値　 : >0  契約パターンコード
' 　　　　   0   条件に合致する契約パターンが存在しない
' 　　　　   -1  異常終了、または条件に合致する契約パターンが複数存在
'
' 備考　　 :
'
Public Function SelectCtrPtFromConsult(ByVal dtmCslDate As Date, ByVal strCsCd As String, ByVal strOrgCd1 As String, ByVal strOrgCd2 As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objCtrPtCd  As OraField         '契約パターンコード
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キーおよび戻り値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    '受診情報登録用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN :CTRPTCD := GetCtrPtCdFromConsult(:CSLDATE, :CSCD, :ORGCD1, :ORGCD2); END;"
    
    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
    '戻り値の設定
    SelectCtrPtFromConsult = objOraParam("CTRPTCD").Value
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtFromConsult = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtFromConsult"
    
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

'## 2002.11.05 Add Function By T.Takagi@FSIT 東急対応
'
' 機能　　 : 指定契約パターンおける年齢区分を取得する
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (Out)    vntStrAge   開始年齢
' 　　　　   (Out)    vntEndAge   終了年齢
' 　　　　   (OUt)    vntAgeDiv   年齢区分
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtAge(ByVal lngCtrPtCd As Long, ByRef vntStrAge As Variant, ByRef vntEndAge As Variant, ByRef vntAgeDiv As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objStrAge       As OraField         '開始年齢
    Dim objEndAge       As OraField         '終了年齢
    Dim objAgeDiv       As OraField         '年齢区分
    
    Dim vntArrStrAge()  As Variant          '開始年齢の配列
    Dim vntArrEndAge()  As Variant          '終了年齢の配列
    Dim vntArrAgeDiv()  As Variant          '年齢区分の配列
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStrAge = Empty
    vntAgeDiv = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす契約パターン年齢区分テーブルのレコードを取得
    strStmt = "SELECT STRAGE, ENDAGE, AGEDIV " & vbLf & _
              "  FROM CTRPT_AGE              " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD     " & vbLf & _
              " ORDER BY CTRPTCD, SEQ        "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStrAge = objFields("STRAGE")
        Set objEndAge = objFields("ENDAGE")
        Set objAgeDiv = objFields("AGEDIV")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrStrAge(lngCount)
            ReDim Preserve vntArrEndAge(lngCount)
            ReDim Preserve vntArrAgeDiv(lngCount)
            vntArrStrAge(lngCount) = objStrAge.Value & ""
            vntArrEndAge(lngCount) = objEndAge.Value & ""
            vntArrAgeDiv(lngCount) = objAgeDiv.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntStrAge = vntArrStrAge
        vntEndAge = vntArrEndAge
        vntAgeDiv = vntArrAgeDiv
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrPtAge = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtAge = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtAge"
    
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
' 機能　　 : 指定契約パターン・オプションにおけるグループを取得する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
' 　　　　   (Out)    vntGrpCd        グループコード
' 　　　　   (Out)    vntGrpName      グループ名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtGrp(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long, ByRef vntGrpCd As Variant, ByRef vntGrpName As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objGrpCd        As OraField         'グループコード
    Dim objGrpName      As OraField         'グループ名
    
    Dim vntArrGrpCd()   As Variant          'グループコードの配列
    Dim vntArrGrpName() As Variant          'グループ名の配列
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntGrpCd = Empty
    vntGrpName = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす契約パターン内グループテーブルのレコードを取得
    strStmt = "SELECT CTRPT_GRP.GRPCD, GRP_P.GRPNAME            " & vbLf & _
              "  FROM GRP_P, CTRPT_GRP                          " & vbLf & _
              " WHERE CTRPT_GRP.CTRPTCD     = :CTRPTCD          " & vbLf & _
              "   AND CTRPT_GRP.OPTCD       = :OPTCD            " & vbLf & _
              "   AND CTRPT_GRP.OPTBRANCHNO = :OPTBRANCHNO      " & vbLf & _
              "   AND CTRPT_GRP.GRPCD       = GRP_P.GRPCD       " & vbLf & _
              " ORDER BY CTRPT_GRP.CTRPTCD, CTRPT_GRP.OPTCD,    " & vbLf & _
              "          CTRPT_GRP.OPTBRANCHNO, CTRPT_GRP.GRPCD "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpCd = objFields("GRPCD")
        Set objGrpName = objFields("GRPNAME")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrGrpCd(lngCount)
            ReDim Preserve vntArrGrpName(lngCount)
            vntArrGrpCd(lngCount) = objGrpCd.Value
            vntArrGrpName(lngCount) = objGrpName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntGrpCd = vntArrGrpCd
        vntGrpName = vntArrGrpName
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrPtGrp = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtGrp = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtGrp"
    
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
' 機能　　 : 指定契約パターン・オプションにおける検査項目を取得する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
' 　　　　   (In)     vntItemCd       検査項目コード
' 　　　　   (In)     vntRequestName  依頼項目名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtItem(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long, ByRef vntItemCd As Variant, ByRef vntRequestName As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objRequestName      As OraField         '依頼項目名
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrRequestName() As Variant          '依頼項目名の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntItemCd = Empty
    vntRequestName = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす契約パターン内検査項目テーブルのレコードを取得
    strStmt = "SELECT CTRPT_ITEM.ITEMCD, ITEM_P.REQUESTNAME        " & vbLf & _
              "  FROM ITEM_P, CTRPT_ITEM                           " & vbLf & _
              " WHERE CTRPT_ITEM.CTRPTCD     = :CTRPTCD            " & vbLf & _
              "   AND CTRPT_ITEM.OPTCD       = :OPTCD              " & vbLf & _
              "   AND CTRPT_ITEM.OPTBRANCHNO = :OPTBRANCHNO        " & vbLf & _
              "   AND CTRPT_ITEM.ITEMCD      = ITEM_P.ITEMCD       " & vbLf & _
              " ORDER BY CTRPT_ITEM.CTRPTCD, CTRPT_ITEM.OPTCD,     " & vbLf & _
              "          CTRPT_ITEM.OPTBRANCHNO, CTRPT_ITEM.ITEMCD "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objRequestName = objFields("REQUESTNAME")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrRequestName(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value
            vntArrRequestName(lngCount) = objRequestName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntItemCd = vntArrItemCd
        vntRequestName = vntArrRequestName
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrPtItem = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtItem = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtItem"
    
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
' 機能　　 : 指定契約パターンおよびオプションコードのオプション検査情報を取得する
'
' 引数　　 : (In)     lngCtrPtCd       契約パターンコード
' 　　　　   (In)     strOptCd         オプションコード
' 　　　　   (In)     lngOptBranchNo   オプション枝番
' 　　　　   (Out)    vntOptName       オプション名
' 　　　　   (Out)    vntOptSName      オプション略称
' 　　　　   (Out)    vntCsCd          コースコード
' 　　　　   (Out)    vntSetClassCd    セット分類コード
' 　　　　   (Out)    vntCslDivCd      受診区分コード
' 　　　　   (Out)    vntGender        受診可能性別
' 　　　　   (Out)    vntLastRefMonth  前回値参照用月数
' 　　　　   (Out)    vntLastRefCsCd   前回値参照用コースコード
' 　　　　   (Out)    vntExceptLimit   限度額設定除外
' 　　　　   (Out)    vntAddCondition  追加条件
' 　　　　   (Out)    vntHideRsvFra    予約枠画面非表示
' 　　　　   (Out)    vntHideRsv       予約画面非表示
' 　　　　   (Out)    vntHideRpt       受付画面非表示
' 　　　　   (Out)    vntHideQuestion  問診画面非表示
' 　　　　   (Out)    vntRsvFraCd      予約枠コード
' 　　　　   (Out)    vntSetColor      セットカラー
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtOpt( _
    ByVal lngCtrPtCd As Long, _
    ByVal strOptCd As String, _
    ByVal lngOptBranchNo As Long, _
    Optional ByRef vntOptName As Variant, _
    Optional ByRef vntOptSName As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntSetClassCd As Variant, _
    Optional ByRef vntCslDivCd As Variant, _
    Optional ByRef vntGender As Variant, _
    Optional ByRef vntLastRefMonth As Variant, _
    Optional ByRef vntLastRefCsCd As Variant, _
    Optional ByRef vntExceptLimit As Variant, _
    Optional ByRef vntAddCondition As Variant, _
    Optional ByRef vntHideRsvFra As Variant, _
    Optional ByRef vntHideRsv As Variant, _
    Optional ByRef vntHideRpt As Variant, _
    Optional ByRef vntHideQuestion As Variant, _
    Optional ByRef vntRsvFraCd As Variant, _
    Optional ByRef vntSetColor As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objOptName      As OraField         'オプション名
    Dim objOptSName     As OraField         'オプション略称
    Dim objGender       As OraField         '受診可能性別
    Dim objCsCd         As OraField         'コースコード
    Dim objSetClassCd   As OraField         'セット分類コード
    Dim objCslDivCd     As OraField         '受診区分コード
    Dim objLastRefMonth As OraField         '前回値参照用月数
    Dim objLastRefCsCd  As OraField         '前回値参照用コースコード
    Dim objExceptLimit  As OraField         '限度額設定除外
    Dim objAddCondition As OraField         '追加条件
    Dim objHideRsvFra   As OraField         '予約枠画面非表示
    Dim objHideRsv      As OraField         '予約画面非表示
    Dim objHideRpt      As OraField         '受付画面非表示
    Dim objHideQuestion As OraField         '問診画面非表示
    Dim objRsvFraCd     As OraField         '予約枠コード
    Dim objSetColor     As OraField         'セットカラー
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntOptName) Then vntOptName = Empty
    If Not IsMissing(vntOptSName) Then vntOptSName = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntSetClassCd) Then vntSetClassCd = Empty
    If Not IsMissing(vntCslDivCd) Then vntCslDivCd = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntLastRefMonth) Then vntLastRefMonth = Empty
    If Not IsMissing(vntLastRefCsCd) Then vntLastRefCsCd = Empty
    If Not IsMissing(vntExceptLimit) Then vntExceptLimit = Empty
    If Not IsMissing(vntAddCondition) Then vntAddCondition = Empty
    If Not IsMissing(vntHideRsvFra) Then vntHideRsvFra = Empty
    If Not IsMissing(vntHideRsv) Then vntHideRsv = Empty
    If Not IsMissing(vntHideRpt) Then vntHideRpt = Empty
    If Not IsMissing(vntHideQuestion) Then vntHideQuestion = Empty
    If Not IsMissing(vntRsvFraCd) Then vntRsvFraCd = Empty
    If Not IsMissing(vntSetColor) Then vntSetColor = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす契約パターンオプション管理テーブルのレコードを取得
    strStmt = "SELECT CTRPT_OPT.OPTNAME,         CTRPT_OPT.OPTSNAME,        CTRPT_OPT.CSCD,        " & vbLf & _
              "       CTRPT_OPT.SETCLASSCD,      CTRPT_OPT.CSLDIVCD,        CTRPT_OPT.GENDER,      " & vbLf & _
              "       CTRPT_OPT.LASTREFMONTH,    CTRPT_OPT.LASTREFCSCD,     CTRPT_OPT.EXCEPTLIMIT, " & vbLf & _
              "       CTRPT_OPTGRP.ADDCONDITION, CTRPT_OPTGRP.HIDERSVFRA,   CTRPT_OPTGRP.HIDERSV,  " & vbLf & _
              "       CTRPT_OPTGRP.HIDERPT,      CTRPT_OPTGRP.HIDEQUESTION, CTRPT_OPT.RSVFRACD,    " & vbLf & _
              "       CTRPT_OPT.SETCOLOR                                                           " & vbLf & _
              "  FROM CTRPT_OPTGRP, CTRPT_OPT                                                      "
              
    strStmt = strStmt & vbLf & _
              " WHERE CTRPT_OPT.CTRPTCD     = :CTRPTCD             " & vbLf & _
              "   AND CTRPT_OPT.OPTCD       = :OPTCD               " & vbLf & _
              "   AND CTRPT_OPT.OPTBRANCHNO = :OPTBRANCHNO         " & vbLf & _
              "   AND CTRPT_OPT.CTRPTCD     = CTRPT_OPTGRP.CTRPTCD " & vbLf & _
              "   AND CTRPT_OPT.OPTCD       = CTRPT_OPTGRP.OPTCD   "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOptName = objFields("OPTNAME")
        Set objOptSName = objFields("OPTSNAME")
        Set objCsCd = objFields("CSCD")
        Set objSetClassCd = objFields("SETCLASSCD")
        Set objCslDivCd = objFields("CSLDIVCD")
        Set objGender = objFields("GENDER")
        Set objLastRefMonth = objFields("LASTREFMONTH")
        Set objLastRefCsCd = objFields("LASTREFCSCD")
        Set objExceptLimit = objFields("EXCEPTLIMIT")
        Set objAddCondition = objFields("ADDCONDITION")
        Set objHideRsvFra = objFields("HIDERSVFRA")
        Set objHideRsv = objFields("HIDERSV")
        Set objHideRpt = objFields("HIDERPT")
        Set objHideQuestion = objFields("HIDEQUESTION")
        Set objRsvFraCd = objFields("RSVFRACD")
        Set objSetColor = objFields("SETCOLOR")
        
        '戻り値の設定
        If Not IsMissing(vntOptName) Then vntOptName = objOptName.Value & ""
        If Not IsMissing(vntOptSName) Then vntOptSName = objOptSName.Value & ""
        If Not IsMissing(vntCsCd) Then vntCsCd = objCsCd.Value & ""
        If Not IsMissing(vntSetClassCd) Then vntSetClassCd = objSetClassCd.Value & ""
        If Not IsMissing(vntCslDivCd) Then vntCslDivCd = objCslDivCd.Value & ""
        If Not IsMissing(vntGender) Then vntGender = CLng(objGender.Value)
        If Not IsMissing(vntLastRefMonth) Then vntLastRefMonth = objLastRefMonth.Value & ""
        If Not IsMissing(vntLastRefCsCd) Then vntLastRefCsCd = objLastRefCsCd.Value & ""
        If Not IsMissing(vntExceptLimit) Then vntExceptLimit = objExceptLimit.Value & ""
        If Not IsMissing(vntAddCondition) Then vntAddCondition = CLng(objAddCondition.Value)
        If Not IsMissing(vntHideRsvFra) Then vntHideRsvFra = objHideRsvFra.Value & ""
        If Not IsMissing(vntHideRsv) Then vntHideRsv = objHideRsv.Value & ""
        If Not IsMissing(vntHideRpt) Then vntHideRpt = objHideRpt.Value & ""
        If Not IsMissing(vntHideQuestion) Then vntHideQuestion = objHideQuestion.Value & ""
        If Not IsMissing(vntRsvFraCd) Then vntRsvFraCd = objRsvFraCd.Value & ""
        If Not IsMissing(vntSetColor) Then vntSetColor = objSetColor.Value & ""
        
        SelectCtrPtOpt = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtOpt = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtOpt"
    
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
' 機能　　 : 指定契約パターン、オプションの受診対象年齢条件を読み込む
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
' 　　　　   (Out)    vntStrAge       受診対象開始年齢
' 　　　　   (Out)    vntEndAge       受診対象終了年齢
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtOptAge(ByVal lngCtrPtCd As Long, ByVal strOptCd As String, ByVal lngOptBranchNo As Long, ByRef vntStrAge As Variant, ByRef vntEndAge As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objStrAge       As OraField         '受診対象開始年齢
    Dim objEndAge       As OraField         '受診対象終了年齢
    
    Dim vntArrStrAge()  As Variant          '受診対象開始年齢の配列
    Dim vntArrEndAge()  As Variant          '受診対象終了年齢の配列
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStrAge = Empty
    vntEndAge = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす契約パターンオプション年齢条件テーブルのレコードを取得
    strStmt = "SELECT STRAGE, ENDAGE             " & vbLf & _
              "  FROM CTRPT_OPTAGE               " & vbLf & _
              " WHERE CTRPTCD     = :CTRPTCD     " & vbLf & _
              "   AND OPTCD       = :OPTCD       " & vbLf & _
              "   AND OPTBRANCHNO = :OPTBRANCHNO " & vbLf & _
              " ORDER BY CTRPTCD, OPTCD, SEQ     "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStrAge = objFields("STRAGE")
        Set objEndAge = objFields("ENDAGE")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrStrAge(lngCount)
            ReDim Preserve vntArrEndAge(lngCount)
            vntArrStrAge(lngCount) = objStrAge.Value
            vntArrEndAge(lngCount) = objEndAge.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntStrAge = vntArrStrAge
        vntEndAge = vntArrEndAge
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrPtOptAge = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtOptAge = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtOptAge"
    
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
' 機能　　 : 指定契約パターン・オプションにおける検査項目の説明情報を取得
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
' 　　　　   (Out)    vntItemCd       検査項目コード
' 　　　　   (Out)    vntSuffix       サフィックス
' 　　　　   (Out)    vntITEMNAME     検査項目名
' 　　　　   (Out)    vntExplanation  項目説明
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtOptExplanation( _
    ByVal lngCtrPtCd As Long, _
    ByVal strOptCd As String, _
    ByVal lngOptBranchNo As Long, _
    ByRef vntItemCd As Variant, _
    ByRef vntSuffix As Variant, _
    ByRef vntItemName As Variant, _
    ByRef vntExplanation As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objExplanation      As OraField         '項目説明
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrSuffix()      As Variant          'サフィックスの配列
    Dim vntArrItemName()    As Variant          '検査項目名の配列
    Dim vntArrExplanation() As Variant          '項目説明の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntItemCd = Empty
    vntSuffix = Empty
    vntItemName = Empty
    vntExplanation = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たすレコードを取得
    strStmt = "SELECT ITEM_C.ITEMCD,   ITEM_C.SUFFIX,               " & vbLf & _
              "       ITEM_C.ITEMNAME, ITEM_C.EXPLANATION           " & vbLf & _
              "  FROM ITEM_C,                                       " & vbLf & _
              "       ( SELECT GRP_R.ITEMCD                         " & vbLf & _
              "           FROM GRP_R, CTRPT_GRP                     " & vbLf & _
              "          WHERE CTRPT_GRP.CTRPTCD     = :CTRPTCD     " & vbLf & _
              "            AND CTRPT_GRP.OPTCD       = :OPTCD       " & vbLf & _
              "            AND CTRPT_GRP.OPTBRANCHNO = :OPTBRANCHNO " & vbLf & _
              "            AND CTRPT_GRP.GRPCD       = GRP_R.GRPCD  " & vbLf & _
              "          UNION                                      " & vbLf & _
              "         SELECT ITEMCD                               " & vbLf & _
              "           FROM CTRPT_ITEM                           " & vbLf & _
              "          WHERE CTRPTCD     = :CTRPTCD               " & vbLf & _
              "            AND OPTCD       = :OPTCD                 " & vbLf & _
              "            AND OPTBRANCHNO = :OPTBRANCHNO           " & vbLf & _
              "       ) CTRPTALLITEM                                " & vbLf & _
              " WHERE CTRPTALLITEM.ITEMCD = ITEM_C.ITEMCD           " & vbLf & _
              "   AND ITEM_C.EXPLANATION IS NOT NULL                "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objItemName = objFields("ITEMNAME")
        Set objExplanation = objFields("EXPLANATION")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrExplanation(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrExplanation(lngCount) = objExplanation.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntItemCd = vntArrItemCd
        vntSuffix = vntArrSuffix
        vntItemName = vntArrItemName
        vntExplanation = vntArrExplanation
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrPtOptExplanation = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtOptExplanation = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtOptExplanation"
    
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
' 機能　　 : 指定条件にて受診する際のオプション検査とそのデフォルト受診状態を取得する
'
' 引数　　 : (In)     dtmCslDate        受診日
' 　　　　   (In)     strCslDivCd       受診区分コード
' 　　　　   (In)     lngCtrPtCd        契約パターンコード
' 　　　　   (In)     strPerId          個人ＩＤ
' 　　　　   (In)     lngGender         性別
' 　　　　   (In)     dtmBirth          生年月日
' 　　　　   (In)     strAge            受診時年齢
' 　　　　   (In)     blnExceptNoMatch  性別、受診区分、年齢条件に合致しないセットを取得対象とするか
' 　　　　   (In)     blnIncludeTax     金額に消費税を含むか
' 　　　　   (Out)    vntOptCd          オプションコード
' 　　　　   (Out)    vntOptBranchNo    オプション枝番
' 　　　　   (Out)    vntOptName        オプション名
' 　　　　   (Out)    vntOptSName       オプション略称
' 　　　　   (Out)    vntSetColor       セットカラー
' 　　　　   (Out)    vntSetClassCd     セット分類コード
' 　　　　   (Out)    vntConsults       受診要否("1":受診する)
' 　　　　   (Out)    vntWebColor       webカラー
' 　　　　   (Out)    vntCsSName        コース略称
' 　　　　   (Out)    vntBranchCount    オプション枝番数
' 　　　　   (Out)    vntAddCondition   追加条件
' 　　　　   (Out)    vntHideRsvFra     予約枠画面非表示
' 　　　　   (Out)    vntHideRsv        予約画面非表示
' 　　　　   (Out)    vntHideRpt        受付画面非表示
' 　　　　   (Out)    vntHideQuestion   問診画面非表示
' 　　　　   (Out)    vntPrice          総金額
' 　　　　   (Out)    vntPerPrice       個人負担金額
' 　　　　   (In)     lngMode           0:個人ＩＤ指定時、引数指定された性別・生年月日・年齢を無視し、個人情報から取得
' 　　　　                                個人ＩＤ未指定ならば引数指定された性別・生年月日・年齢を使用
' 　　　　                              1:個人ＩＤの指定に関わらず、引数指定された性別・生年月日・年齢を使用
' 　　　　   (Out)    vntLastRefCsCd    前回値参照用コースコード
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
' 　　　　   (Out)    vntExistsPrice    負担情報の有無("1":あり)
'## 2004.01.04 Add End
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'## 2004.01.04 Mod By T.Takagi@FSIT 負担情報有無の取得
'Public Function SelectCtrPtOptFromConsult(
'    ByVal dtmCslDate As Date,
'    ByVal strCslDivCd As String,
'    ByVal lngCtrPtcd As Long,
'    Optional ByVal strPerId As String,
'    Optional ByVal lngGender As Long,
'    Optional ByVal dtmBirth As Date,
'    Optional ByVal strAge As String,
'    Optional ByVal blnExceptNoMatch As Boolean,
'    Optional ByVal blnIncludeTax As Boolean,
'    Optional ByRef vntOptCd As Variant,
'    Optional ByRef vntOptBranchNo As Variant,
'    Optional ByRef vntOptName As Variant, Optional ByRef vntOptSName As Variant,
'    Optional ByRef vntSetColor As Variant, Optional ByRef vntSetClassCd As Variant,
'    Optional ByRef vntConsults As Variant,
'    Optional ByRef vntWebColor As Variant,
'    Optional ByRef vntCsSName As Variant,
'    Optional ByRef vntBranchCount As Variant,
'    Optional ByRef vntAddCondition As Variant,
'    Optional ByRef vntHideRsvFra As Variant, Optional ByRef vntHideRsv As Variant,
'    Optional ByRef vntHideRpt As Variant, Optional ByRef vntHideQuestion As Variant,
'    Optional ByRef vntPrice As Variant, Optional ByRef vntPerPrice As Variant,
'    Optional ByRef lngMode As Long = 0,
'    Optional ByRef vntLastRefCsCd As Variant
') As Long
Public Function SelectCtrPtOptFromConsult( _
    ByVal dtmCslDate As Date, _
    ByVal strCslDivCd As String, _
    ByVal lngCtrPtCd As Long, _
    Optional ByVal strPerId As String, _
    Optional ByVal lngGender As Long, _
    Optional ByVal dtmBirth As Date, _
    Optional ByVal strAge As String, _
    Optional ByVal blnExceptNoMatch As Boolean, _
    Optional ByVal blnIncludeTax As Boolean, _
    Optional ByRef vntOptCd As Variant, _
    Optional ByRef vntOptBranchNo As Variant, _
    Optional ByRef vntOptName As Variant, Optional ByRef vntOptSName As Variant, _
    Optional ByRef vntSetColor As Variant, Optional ByRef vntSetClassCd As Variant, _
    Optional ByRef vntConsults As Variant, _
    Optional ByRef vntWebColor As Variant, _
    Optional ByRef vntCsSName As Variant, _
    Optional ByRef vntBranchCount As Variant, _
    Optional ByRef vntAddCondition As Variant, _
    Optional ByRef vntHideRsvFra As Variant, Optional ByRef vntHideRsv As Variant, _
    Optional ByRef vntHideRpt As Variant, Optional ByRef vntHideQuestion As Variant, _
    Optional ByRef vntPrice As Variant, Optional ByRef vntPerPrice As Variant, _
    Optional ByRef lngMode As Long = 0, _
    Optional ByRef vntLastRefCsCd As Variant, Optional ByRef vntExistsPrice As Variant _
) As Long
'## 2004.01.04 Mod End

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOptCd                As OraField         'オプションコード
    Dim objOptBranchNo          As OraField         'オプション枝番
    Dim objOptName              As OraField         'オプション名
    Dim objOptSName             As OraField         'オプション略称
    Dim objSetColor             As OraField         'セットカラー
    Dim objSetClassCd           As OraField         'セット分類コード
    Dim objConsults             As OraField         '受診要否
    Dim objWebColor             As OraField         'webカラー
    Dim objCsSName              As OraField         'コース略称
    Dim objBranchCount          As OraField         'オプション枝番数
    Dim objAddCondition         As OraField         '追加条件
    Dim objHideRsvFra           As OraField         '予約枠画面非表示
    Dim objHideRsv              As OraField         '予約画面非表示
    Dim objHideRpt              As OraField         '受付画面非表示
    Dim objHideQuestion         As OraField         '問診画面非表示
    Dim objPrice                As OraField         '総金額
    Dim objPerPrice             As OraField         '個人負担金額
    Dim objLastRefCsCd          As OraField         '前回値参照用コースコード
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
    Dim objExistsPrice          As OraField         '負担情報の有無
'## 2004.01.04 Add End
    
    Dim vntArrOptCd()           As Variant          'オプションコードの配列
    Dim vntArrOptBranchNo()     As Variant          'オプション枝番の配列
    Dim vntArrOptName()         As Variant          'オプション名の配列
    Dim vntArrOptSName()        As Variant          'オプション略称の配列
    Dim vntArrSetColor()        As Variant          'セットカラーの配列
    Dim vntArrSetClassCd()      As Variant          'セット分類コードの配列
    Dim vntArrConsults()        As Variant          '受診要否の配列
    Dim vntArrWebColor()        As Variant          'webカラーの配列
    Dim vntArrCsSName()         As Variant          'コース略称の配列
    Dim vntArrBranchCount()     As Variant          'オプション枝番数の配列
    Dim vntArrAddCondition()    As Variant          '追加条件の配列
    Dim vntArrHideRsvFra()      As Variant          '予約枠画面非表示の配列
    Dim vntArrHideRsv()         As Variant          '予約画面非表示の配列
    Dim vntArrHideRpt()         As Variant          '受付画面非表示の配列
    Dim vntArrHideQuestion()    As Variant          '問診画面非表示の配列
    Dim vntArrPrice()           As Variant          '総金額の配列
    Dim vntArrPerPrice()        As Variant          '個人負担金額の配列
    Dim vntArrLastRefCsCd()     As Variant          '前回値参照用コースコードの配列
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
    Dim vntArrExistsPrice()     As Variant          '負担情報の有無の配列
'## 2004.01.04 Add End
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntOptCd) Then vntOptCd = Empty
    If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = Empty
    If Not IsMissing(vntOptName) Then vntOptName = Empty
    If Not IsMissing(vntOptSName) Then vntOptSName = Empty
    If Not IsMissing(vntSetColor) Then vntSetColor = Empty
    If Not IsMissing(vntSetClassCd) Then vntSetClassCd = Empty
    If Not IsMissing(vntConsults) Then vntConsults = Empty
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntCsSName) Then vntCsSName = Empty
    If Not IsMissing(vntBranchCount) Then vntBranchCount = Empty
    If Not IsMissing(vntAddCondition) Then vntAddCondition = Empty
    If Not IsMissing(vntHideRsvFra) Then vntHideRsvFra = Empty
    If Not IsMissing(vntHideRsv) Then vntHideRsv = Empty
    If Not IsMissing(vntHideRpt) Then vntHideRpt = Empty
    If Not IsMissing(vntHideQuestion) Then vntHideQuestion = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntPerPrice) Then vntPerPrice = Empty
    If Not IsMissing(vntLastRefCsCd) Then vntLastRefCsCd = Empty
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
    If Not IsMissing(vntExistsPrice) Then vntExistsPrice = Empty
'## 2004.01.04 Add End
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSLDIVCD", strCslDivCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GENDER", IIf(lngGender > 0, lngGender, Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BIRTH", IIf(dtmBirth > 0, dtmBirth, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "AGE", IIf(strAge <> "", CDbl("0" & strAge), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EXCEPTNOMATCH", IIf(blnExceptNoMatch, 1, 0), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "INCLUDETAX", IIf(blnIncludeTax, 1, 0), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MODE", lngMode, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '受診情報ストアドパッケージの関数呼び出し
    strStmt = "BEGIN                                              " & vbLf & _
              "    ConsultPackageLukes.SelectCtrPtOptFromConsult( " & vbLf & _
              "        :CSLDATE,                                  " & vbLf & _
              "        :CSLDIVCD,                                 " & vbLf & _
              "        :CTRPTCD,                                  " & vbLf & _
              "        :PERID,                                    " & vbLf & _
              "        :GENDER,                                   " & vbLf & _
              "        :BIRTH,                                    " & vbLf & _
              "        :AGE,                                      " & vbLf & _
              "        :EXCEPTNOMATCH,                            " & vbLf & _
              "        :INCLUDETAX,                               " & vbLf & _
              "        :CtrPtOptInfo,                             " & vbLf & _
              "        :MODE                                      " & vbLf & _
              "    );                                             " & vbLf & _
              "END;                                               "
    
    Set objOraDyna = mobjOraDb.CreatePlsqlDynaset(OmitCharSpc(strStmt), "CtrPtOptInfo", ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOptCd = objFields("OPTCD")
        Set objOptBranchNo = objFields("OPTBRANCHNO")
        Set objOptName = objFields("OPTNAME")
        Set objOptSName = objFields("OPTSNAME")
        Set objSetColor = objFields("SETCOLOR")
        Set objSetClassCd = objFields("SETCLASSCD")
        Set objConsults = objFields("CONSULTS")
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsSName = objFields("CSSNAME")
        Set objBranchCount = objFields("BRANCHCOUNT")
        Set objAddCondition = objFields("ADDCONDITION")
        Set objHideRsvFra = objFields("HIDERSVFRA")
        Set objHideRsv = objFields("HIDERSV")
        Set objHideRpt = objFields("HIDERPT")
        Set objHideQuestion = objFields("HIDEQUESTION")
        Set objPrice = objFields("PRICE")
        Set objPerPrice = objFields("PERPRICE")
        Set objLastRefCsCd = objFields("LASTREFCSCD")
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
        Set objExistsPrice = objFields("EXISTSPRICE")
'## 2004.01.04 Add End
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOptCd(lngCount)
            ReDim Preserve vntArrOptBranchNo(lngCount)
            ReDim Preserve vntArrOptName(lngCount)
            ReDim Preserve vntArrOptSName(lngCount)
            ReDim Preserve vntArrSetColor(lngCount)
            ReDim Preserve vntArrSetClassCd(lngCount)
            ReDim Preserve vntArrConsults(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrCsSName(lngCount)
            ReDim Preserve vntArrBranchCount(lngCount)
            ReDim Preserve vntArrAddCondition(lngCount)
            ReDim Preserve vntArrHideRsvFra(lngCount)
            ReDim Preserve vntArrHideRsv(lngCount)
            ReDim Preserve vntArrHideRpt(lngCount)
            ReDim Preserve vntArrHideQuestion(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrPerPrice(lngCount)
            ReDim Preserve vntArrLastRefCsCd(lngCount)
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
            ReDim Preserve vntArrExistsPrice(lngCount)
'## 2004.01.04 Add End
            vntArrOptCd(lngCount) = objOptCd.Value & ""
            vntArrOptBranchNo(lngCount) = objOptBranchNo.Value & ""
            vntArrOptName(lngCount) = objOptName.Value & ""
            vntArrOptSName(lngCount) = objOptSName.Value & ""
            vntArrSetColor(lngCount) = objSetColor.Value & ""
            vntArrSetClassCd(lngCount) = objSetClassCd.Value & ""
            vntArrConsults(lngCount) = objConsults.Value & ""
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrCsSName(lngCount) = objCsSName.Value & ""
            vntArrBranchCount(lngCount) = objBranchCount.Value & ""
            vntArrAddCondition(lngCount) = objAddCondition.Value & ""
            vntArrHideRsvFra(lngCount) = objHideRsvFra.Value & ""
            vntArrHideRsv(lngCount) = objHideRsv.Value & ""
            vntArrHideRpt(lngCount) = objHideRpt.Value & ""
            vntArrHideQuestion(lngCount) = objHideQuestion.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrPerPrice(lngCount) = objPerPrice.Value & ""
            vntArrLastRefCsCd(lngCount) = objLastRefCsCd.Value & ""
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
            vntArrExistsPrice(lngCount) = objExistsPrice.Value & ""
'## 2004.01.04 Add End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        Set objOptCd = Nothing
        Set objOptBranchNo = Nothing
        Set objOptName = Nothing
        Set objOptSName = Nothing
        Set objSetColor = Nothing
        Set objSetClassCd = Nothing
        Set objConsults = Nothing
        Set objWebColor = Nothing
        Set objCsSName = Nothing
        Set objBranchCount = Nothing
        Set objAddCondition = Nothing
        Set objHideRsvFra = Nothing
        Set objHideRsv = Nothing
        Set objHideRpt = Nothing
        Set objHideQuestion = Nothing
        Set objPrice = Nothing
        Set objPerPrice = Nothing
        Set objLastRefCsCd = Nothing
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
        Set objExistsPrice = Nothing
'## 2004.01.04 Add End
        Set objFields = Nothing
        
        '戻り値の設定
        If Not IsMissing(vntOptCd) Then vntOptCd = vntArrOptCd
        If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = vntArrOptBranchNo
        If Not IsMissing(vntOptName) Then vntOptName = vntArrOptName
        If Not IsMissing(vntOptSName) Then vntOptSName = vntArrOptSName
        If Not IsMissing(vntSetColor) Then vntSetColor = vntArrSetColor
        If Not IsMissing(vntSetClassCd) Then vntSetClassCd = vntArrSetClassCd
        If Not IsMissing(vntConsults) Then vntConsults = vntArrConsults
        If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
        If Not IsMissing(vntCsSName) Then vntCsSName = vntArrCsSName
        If Not IsMissing(vntBranchCount) Then vntBranchCount = vntArrBranchCount
        If Not IsMissing(vntAddCondition) Then vntAddCondition = vntArrAddCondition
        If Not IsMissing(vntHideRsvFra) Then vntHideRsvFra = vntArrHideRsvFra
        If Not IsMissing(vntHideRsv) Then vntHideRsv = vntArrHideRsv
        If Not IsMissing(vntHideRpt) Then vntHideRpt = vntArrHideRpt
        If Not IsMissing(vntHideQuestion) Then vntHideQuestion = vntArrHideQuestion
        If Not IsMissing(vntPrice) Then vntPrice = vntArrPrice
        If Not IsMissing(vntPerPrice) Then vntPerPrice = vntArrPerPrice
        If Not IsMissing(vntLastRefCsCd) Then vntLastRefCsCd = vntArrLastRefCsCd
'## 2004.01.04 Add By T.Takagi@FSIT 負担情報有無の取得
        If Not IsMissing(vntExistsPrice) Then vntExistsPrice = vntArrExistsPrice
'## 2004.01.04 Add End
    
    End If
    
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    '戻り値の設定
    SelectCtrPtOptFromConsult = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtOptFromConsult = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtOptFromConsult"
    
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
' 機能　　 : 指定予約番号の受診情報に対し、指定契約パターン・オプションにおける検査項目の受診状態を取得
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     strOptCd        オプションコード
' 　　　　   (In)     lngOptBranchNo  オプション枝番
' 　　　　   (Out)    vntItemCd       検査項目コード
' 　　　　   (Out)    vntRequestName  依頼項目名
' 　　　　   (Out)    vntConsults     受診状態("1":受診、"0":未受診)
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtOptItem( _
    ByVal lngRsvNo As Long, _
    ByVal lngCtrPtCd As Long, _
    ByVal strOptCd As String, _
    ByVal lngOptBranchNo As Long, _
    ByRef vntItemCd As Variant, _
    ByRef vntRequestName As Variant, _
    ByRef vntConsults As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objRequestName      As OraField         '依頼項目名
    Dim objConsults         As OraField         '受診状態
    
    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrRequestName() As Variant          '依頼項目名の配列
    Dim vntArrConsults()    As Variant          '受診状態の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntItemCd = Empty
    vntRequestName = Empty
    vntConsults = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たすレコードを取得
    strStmt = "SELECT CTRPTALLITEM.ITEMCD, ITEM_P.REQUESTNAME, NVL2(DELITEM.ITEMCD, 0, 1) CONSULTS "

    '受診時追加検査項目テーブルから削除項目を取得
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT ITEMCD           " & vbLf & _
              "           FROM CONSULT_I        " & vbLf & _
              "          WHERE RSVNO   = :RSVNO " & vbLf & _
              "            AND EDITFLG = 2      " & vbLf & _
              "       ) DELITEM, ITEM_P,        "
              
    '指定契約パターン、オプションコード、枝番の受診項目を依頼項目レベルまで展開して取得
    strStmt = strStmt & vbLf & _
              "       ( SELECT GRP_R.ITEMCD                         " & vbLf & _
              "           FROM GRP_R, CTRPT_GRP                     " & vbLf & _
              "          WHERE CTRPT_GRP.CTRPTCD     = :CTRPTCD     " & vbLf & _
              "            AND CTRPT_GRP.OPTCD       = :OPTCD       " & vbLf & _
              "            AND CTRPT_GRP.OPTBRANCHNO = :OPTBRANCHNO " & vbLf & _
              "            AND CTRPT_GRP.GRPCD       = GRP_R.GRPCD  " & vbLf & _
              "          UNION                                      " & vbLf & _
              "         SELECT ITEMCD                               " & vbLf & _
              "           FROM CTRPT_ITEM                           " & vbLf & _
              "          WHERE CTRPTCD     = :CTRPTCD               " & vbLf & _
              "            AND OPTCD       = :OPTCD                 " & vbLf & _
              "            AND OPTBRANCHNO = :OPTBRANCHNO           " & vbLf & _
              "       ) CTRPTALLITEM                                " & vbLf & _
              " WHERE CTRPTALLITEM.ITEMCD = ITEM_P.ITEMCD           "
    
    '削除項目情報と結合し、受診状態を判別
    strStmt = strStmt & vbLf & _
              "   AND CTRPTALLITEM.ITEMCD = DELITEM.ITEMCD(+) "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objRequestName = objFields("REQUESTNAME")
        Set objConsults = objFields("CONSULTS")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrRequestName(lngCount)
            ReDim Preserve vntArrConsults(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrRequestName(lngCount) = objRequestName.Value & ""
            vntArrConsults(lngCount) = objConsults.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntItemCd = vntArrItemCd
        vntRequestName = vntArrRequestName
        vntConsults = vntArrConsults
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrPtOptItem = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtOptItem = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtOptItem"
    
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
' 機能　　 : 指定契約パターンの全オプション検査を取得する
'
' 引数　　 : (In)     lngCtrPtCd       契約パターンコード
' 　　　　   (Out)    vntOptCd         オプションコード
' 　　　　   (Out)    vntOptBranchNo   オプション枝番
' 　　　　   (Out)    vntOptName       オプション名
' 　　　　   (Out)    vntOptSName      オプション略称
' 　　　　   (Out)    vntSetClassCd    セット分類コード
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtOptList( _
    ByVal lngCtrPtCd As Long, _
    Optional ByRef vntOptCd As Variant, _
    Optional ByRef vntOptBranchNo As Variant, _
    Optional ByRef vntOptName As Variant, _
    Optional ByRef vntOptSName As Variant, _
    Optional ByRef vntSetClassCd As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOptCd                As OraField         'オプションコード
    Dim objOptBranchNo          As OraField         'オプション枝番
    Dim objOptName              As OraField         'オプション名
    Dim objOptSName             As OraField         'オプション略称
    Dim objSetClassCd           As OraField         'セット分類コード

    Dim vntArrOptCd()           As Variant          'オプションコードの配列
    Dim vntArrOptBranchNo()     As Variant          'オプション枝番の配列
    Dim vntArrOptName()         As Variant          'オプション名の配列
    Dim vntArrOptSName()        As Variant          'オプション略称の配列
    Dim vntArrSetClassCd()      As Variant          'セット分類コードの配列
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntOptCd) Then vntOptCd = Empty
    If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = Empty
    If Not IsMissing(vntOptName) Then vntOptName = Empty
    If Not IsMissing(vntOptSName) Then vntOptSName = Empty
    If Not IsMissing(vntSetClassCd) Then vntSetClassCd = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定契約パターンの全オプション検査を取得する
    strStmt = "SELECT OPTCD, OPTBRANCHNO, OPTNAME, OPTSNAME, SETCLASSCD " & vbLf & _
              "  FROM CTRPT_OPT                                         " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD                                " & vbLf & _
              " ORDER BY CTRPTCD, OPTCD, OPTBRANCHNO                    "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOptCd = objFields("OPTCD")
        Set objOptBranchNo = objFields("OPTBRANCHNO")
        Set objOptName = objFields("OPTNAME")
        Set objOptSName = objFields("OPTSNAME")
        Set objSetClassCd = objFields("SETCLASSCD")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOptCd(lngCount)
            ReDim Preserve vntArrOptBranchNo(lngCount)
            ReDim Preserve vntArrOptName(lngCount)
            ReDim Preserve vntArrOptSName(lngCount)
            ReDim Preserve vntArrSetClassCd(lngCount)
            vntArrOptCd(lngCount) = objOptCd.Value & ""
            vntArrOptBranchNo(lngCount) = objOptBranchNo.Value & ""
            vntArrOptName(lngCount) = objOptName.Value & ""
            vntArrOptSName(lngCount) = objOptSName.Value & ""
            vntArrSetClassCd(lngCount) = objSetClassCd.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        Set objOptCd = Nothing
        Set objOptBranchNo = Nothing
        Set objOptName = Nothing
        Set objOptSName = Nothing
        Set objSetClassCd = Nothing
        Set objFields = Nothing
        
        '戻り値の設定
        If Not IsMissing(vntOptCd) Then vntOptCd = vntArrOptCd
        If Not IsMissing(vntOptBranchNo) Then vntOptBranchNo = vntArrOptBranchNo
        If Not IsMissing(vntOptName) Then vntOptName = vntArrOptName
        If Not IsMissing(vntOptSName) Then vntOptSName = vntArrOptSName
        If Not IsMissing(vntSetClassCd) Then vntSetClassCd = vntArrSetClassCd
        
    End If
    
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    '戻り値の設定
    SelectCtrPtOptList = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtOptList = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtOptList"
    
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
' 機能　　 : 指定契約パターンの負担元および負担金額情報を取得する
'
' 引数　　 : (In)     lngCtrPtCd         契約パターンコード
' 　　　　   (In)     vntOptCd           オプションコード
' 　　　　   (In)     vntOptBranchNo     オプションコード
' 　　　　   (Out)    vntSeq             SEQ
' 　　　　   (Out)    vntApDiv           適用元区分
' 　　　　   (Out)    vntOrgCd1          団体コード１
' 　　　　   (Out)    vntOrgCd2          団体コード２
' 　　　　   (Out)    vntOrgName         団体名称
' 　　　　   (Out)    vntOrgSName        団体略称
' 　　　　   (Out)    vntPrice           指定オプションコードの負担金額
' 　　　　   (Out)    vntTax             指定オプションコードの消費税
' 　　　　   (Out)    vntBillPrintName   請求書出力名
' 　　　　   (Out)    vntBillPrintEName  請求書英語出力名
' 　　　　   (Out)    vntTaxFlg          消費税負担フラグ
' 　　　　   (Out)    vntNoCtr           契約外項目負担フラグ
' 　　　　   (Out)    vntFraction        契約外項目端数負担フラグ
' 　　　　   (Out)    vntOptBurden       オプション負担対象フラグ
' 　　　　   (Out)    vntOrgDiv          (団体テーブル上の)団体種別
' 　　　　   (Out)    vntCtrOrgDiv       (契約パターン負担金額管理テーブル上の)団体種別
' 　　　　   (Out)    vntLimitPriceFlg   限度額負担フラグ
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtOrgPrice( _
    ByVal lngCtrPtCd As Long, _
    Optional ByVal vntOptCd As Variant, _
    Optional ByVal vntOptBranchNo As Variant, _
    Optional ByRef vntSeq As Variant, _
    Optional ByRef vntApDiv As Variant, _
    Optional ByRef vntOrgCd1 As Variant, _
    Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntPrice As Variant, _
    Optional ByRef vntTax As Variant, _
    Optional ByRef vntBillPrintName As Variant, _
    Optional ByRef vntBillPrintEName As Variant, _
    Optional ByRef vntTaxFlg As Variant, _
    Optional ByRef vntNoCtr As Variant, _
    Optional ByRef vntFraction As Variant, _
    Optional ByRef vntOptBurden As Variant, _
    Optional ByRef vntOrgDiv As Variant, _
    Optional ByRef vntCtrOrgDiv As Variant, _
    Optional ByRef vntLimitPriceFlg As Variant _
) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objSeq                  As OraField         'SEQ
    Dim objApDiv                As OraField         '適用元区分
    Dim objOrgCd1               As OraField         '団体コード1
    Dim objOrgCd2               As OraField         '団体コード2
    Dim objOrgName              As OraField         '団体名称
    Dim objOrgSName             As OraField         '団体略称
    Dim objPrice                As OraField         '負担金額
    Dim objTax                  As OraField         '消費税
    Dim objBillPrintName        As OraField         '請求書出力名
    Dim objBillPrintEName       As OraField         '請求書英語出力名
    Dim objTaxFlg               As OraField         '消費税負担フラグ
    Dim objNoCtr                As OraField         '契約外項目負担フラグ
    Dim objFraction             As OraField         '契約外項目端数負担フラグ
    Dim objOptBurden            As OraField         'オプション負担対象フラグ
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objOrgDiv               As OraField         '(団体テーブル上の)団体種別
'## 2003.11.18 Del End
    Dim objCtrOrgDiv            As OraField         '(契約パターン負担金額管理テーブル上の)団体種別
    Dim objLimitPriceFlg        As OraField         '限度額負担フラグ
    
    Dim vntArrSeq()             As Variant          'SEQの配列
    Dim vntArrApDiv()           As Variant          '適用元区分の配列
    Dim vntArrOrgCd1()          As Variant          '団体コード1の配列
    Dim vntArrOrgCd2()          As Variant          '団体コード2の配列
    Dim vntArrOrgName()         As Variant          '団体名称の配列
    Dim vntArrOrgSName()        As Variant          '団体略称の配列
    Dim vntArrPrice()           As Variant          '負担金額の配列
    Dim vntArrTax()             As Variant          '消費税の配列
    Dim vntArrBillPrintName()   As Variant          '請求書出力名の配列
    Dim vntArrBillPrintEName()  As Variant          '請求書英語出力名の配列
    Dim vntArrTaxFlg()          As Variant          '消費税負担フラグの配列
    Dim vntArrNoCtr()           As Variant          '契約外項目負担フラグの配列
    Dim vntArrFraction()        As Variant          '契約外項目端数負担フラグの配列
    Dim vntArrOptBurden()       As Variant          'オプション負担対象フラグの配列
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim vntArrOrgDiv()          As Variant          '(団体テーブル上の)団体種別の配列
'## 2003.11.18 Del End
    Dim vntArrCtrOrgDiv()       As Variant          '(契約パターン負担金額管理テーブル上の)団体種別の配列
    Dim vntArrLimitPriceFlg()   As Variant          '限度額負担フラグの配列
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntApDiv) Then vntApDiv = Empty
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntPrice) Then vntPrice = Empty
    If Not IsMissing(vntTax) Then vntTax = Empty
    If Not IsMissing(vntBillPrintName) Then vntBillPrintName = Empty
    If Not IsMissing(vntBillPrintEName) Then vntBillPrintEName = Empty
    If Not IsMissing(vntTaxFlg) Then vntTaxFlg = Empty
    If Not IsMissing(vntNoCtr) Then vntNoCtr = Empty
    If Not IsMissing(vntFraction) Then vntFraction = Empty
    If Not IsMissing(vntOptBurden) Then vntOptBurden = Empty
    If Not IsMissing(vntOrgDiv) Then vntOrgDiv = Empty
    If Not IsMissing(vntCtrOrgDiv) Then vntCtrOrgDiv = Empty
    If Not IsMissing(vntLimitPriceFlg) Then vntLimitPriceFlg = Empty
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", Null, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", Null, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'オプションコード指定時はキー値として設定する
    If Not IsMissing(vntOptCd) Then
        objOraParam("OPTCD").Value = CStr(vntOptCd)
        objOraParam("OPTBRANCHNO").Value = CLng(vntOptBranchNo)
    End If
    
    '負担元および負担金額情報の取得
    strStmt = "SELECT CTRPT_ORG.SEQ,    CTRPT_ORG.APDIV,                           " & vbLf & _
              "       CTRPT_ORG.ORGCD1, CTRPT_ORG.ORGCD2,                          " & vbLf & _
              "       DECODE(CTRPT_ORG.APDIV,                                      " & vbLf & _
              "              " & CStr(APDIV_PERSON) & ", '" & ORGNAME_PERSON & "', " & vbLf & _
              "              " & CStr(APDIV_MYORG) & ",  '" & ORGNAME_MYORG & "',  " & vbLf & _
              "              ORG.ORGNAME) ORGNAME,                                 " & vbLf & _
              "       DECODE(CTRPT_ORG.APDIV,                                      " & vbLf & _
              "              " & CStr(APDIV_PERSON) & ", '" & ORGNAME_PERSON & "', " & vbLf & _
              "              " & CStr(APDIV_MYORG) & ",  '" & ORGNAME_MYORG & "',  " & vbLf & _
              "              ORG.ORGSNAME) ORGSNAME,                               "
    
    strStmt = strStmt & vbLf & _
              "       NVL(CTRPT_PRICE.PRICE, 0) PRICE, " & vbLf & _
              "       CTRPT_PRICE.TAX,                 " & vbLf & _
              "       CTRPT_PRICE.BILLPRINTNAME,       " & vbLf & _
              "       CTRPT_PRICE.BILLPRINTENAME,      " & vbLf & _
              "       CTRPT_ORG.TAXFLG,                " & vbLf & _
              "       CTRPT_ORG.NOCTR,                 " & vbLf & _
              "       CTRPT_ORG.FRACTION,              " & vbLf & _
              "       CTRPT_ORG.LIMITPRICEFLG,         "
    
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strStmt = strStmt & vbLf & _
'              "       CTRPT_ORG.ADDUPFLG,           " & vbLf & _
'              "       NVL(ORG.ORGDIV, 0) ORGDIV,    " & vbLf & _
'              "       CTRPT_PRICE.ORGDIV CTRORGDIV, "
    strStmt = strStmt & vbLf & _
              "       CTRPT_ORG.ADDUPFLG,           " & vbLf & _
              "       CTRPT_PRICE.ORGDIV CTRORGDIV, "
'## 2003.11.18 Mod End
    
    'オプションの負担対象有無
    strStmt = strStmt & vbLf & _
              "       ( SELECT DECODE(COUNT(*), 0, 0, 1)                " & vbLf & _
              "           FROM CTRPT_OPT, CTRPT_PRICE                   " & vbLf & _
              "          WHERE CTRPT_PRICE.CTRPTCD = CTRPT_ORG.CTRPTCD  " & vbLf & _
              "            AND CTRPT_PRICE.SEQ     = CTRPT_ORG.SEQ      " & vbLf & _
              "            AND CTRPT_PRICE.PRICE + CTRPT_PRICE.TAX != 0 " & vbLf & _
              "            AND CTRPT_PRICE.CTRPTCD = CTRPT_OPT.CTRPTCD  " & vbLf & _
              "            AND CTRPT_PRICE.OPTCD   = CTRPT_OPT.OPTCD    " & vbLf & _
              "       ) OPTBURDEN                                       "
    
    '団体の結合
    strStmt = strStmt & vbLf & _
              "  FROM CTRPT_PRICE, ORG, CTRPT_ORG       " & vbLf & _
              " WHERE CTRPT_ORG.CTRPTCD = :CTRPTCD      " & vbLf & _
              "   AND CTRPT_ORG.ORGCD1  = ORG.ORGCD1(+) " & vbLf & _
              "   AND CTRPT_ORG.ORGCD2  = ORG.ORGCD2(+) "
    
    'オプション検査の負担金額情報を結合
    strStmt = strStmt & vbLf & _
              "   AND CTRPT_ORG.CTRPTCD = CTRPT_PRICE.CTRPTCD(+)     " & vbLf & _
              "   AND CTRPT_ORG.SEQ     = CTRPT_PRICE.SEQ(+)         " & vbLf & _
              "   AND :OPTCD            = CTRPT_PRICE.OPTCD(+)       " & vbLf & _
              "   AND :OPTBRANCHNO      = CTRPT_PRICE.OPTBRANCHNO(+) "
    
    'SEQ順に取得
    strStmt = strStmt & vbLf & _
              " ORDER BY CTRPT_ORG.CTRPTCD, CTRPT_ORG.SEQ "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSeq = objFields("SEQ")
        Set objApDiv = objFields("APDIV")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgSName = objFields("ORGSNAME")
        Set objPrice = objFields("PRICE")
        Set objTax = objFields("TAX")
        Set objBillPrintName = objFields("BILLPRINTNAME")
        Set objBillPrintEName = objFields("BILLPRINTENAME")
        Set objTaxFlg = objFields("TAXFLG")
        Set objNoCtr = objFields("NOCTR")
        Set objFraction = objFields("FRACTION")
        Set objOptBurden = objFields("OPTBURDEN")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objOrgDiv = objFields("ORGDIV")
'## 2003.11.18 Del End
        Set objCtrOrgDiv = objFields("CTRORGDIV")
        Set objLimitPriceFlg = objFields("LIMITPRICEFLG")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrApDiv(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgSName(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrBillPrintName(lngCount)
            ReDim Preserve vntArrBillPrintEName(lngCount)
            ReDim Preserve vntArrTaxFlg(lngCount)
            ReDim Preserve vntArrNoCtr(lngCount)
            ReDim Preserve vntArrFraction(lngCount)
            ReDim Preserve vntArrOptBurden(lngCount)
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'            ReDim Preserve vntArrOrgDiv(lngCount)
'## 2003.11.18 Del End
            ReDim Preserve vntArrCtrOrgDiv(lngCount)
            ReDim Preserve vntArrLimitPriceFlg(lngCount)
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrApDiv(lngCount) = objApDiv.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgSName(lngCount) = objOrgSName.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrTax(lngCount) = objTax.Value & ""
            vntArrBillPrintName(lngCount) = objBillPrintName.Value & ""
            vntArrBillPrintEName(lngCount) = objBillPrintEName.Value & ""
            vntArrTaxFlg(lngCount) = objTaxFlg.Value & ""
            vntArrNoCtr(lngCount) = objNoCtr.Value & ""
            vntArrFraction(lngCount) = objFraction.Value & ""
            vntArrOptBurden(lngCount) = objOptBurden.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'            vntArrOrgDiv(lngCount) = objOrgDiv.Value & ""
'## 2003.11.18 Del End
            vntArrCtrOrgDiv(lngCount) = objCtrOrgDiv.Value & ""
            vntArrLimitPriceFlg(lngCount) = objLimitPriceFlg.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        If Not IsMissing(vntSeq) Then vntSeq = vntArrSeq
        If Not IsMissing(vntApDiv) Then vntApDiv = vntArrApDiv
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
        If Not IsMissing(vntOrgName) Then vntOrgName = vntArrOrgName
        If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
        If Not IsMissing(vntPrice) Then vntPrice = vntArrPrice
        If Not IsMissing(vntTax) Then vntTax = vntArrTax
        If Not IsMissing(vntBillPrintName) Then vntBillPrintName = vntArrBillPrintName
        If Not IsMissing(vntBillPrintEName) Then vntBillPrintEName = vntArrBillPrintEName
        If Not IsMissing(vntTaxFlg) Then vntTaxFlg = vntArrTaxFlg
        If Not IsMissing(vntNoCtr) Then vntNoCtr = vntArrNoCtr
        If Not IsMissing(vntFraction) Then vntFraction = vntArrFraction
        If Not IsMissing(vntOptBurden) Then vntOptBurden = vntArrOptBurden
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If Not IsMissing(vntOrgDiv) Then vntOrgDiv = vntArrOrgDiv
'## 2003.11.18 Del End
        If Not IsMissing(vntCtrOrgDiv) Then vntCtrOrgDiv = vntArrCtrOrgDiv
        If Not IsMissing(vntLimitPriceFlg) Then vntLimitPriceFlg = vntArrLimitPriceFlg
    
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrPtOrgPrice = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtOrgPrice = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtOrgPrice"
    
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
' 機能　　 : 指定契約パターンにおける指定オプション区分の全負担情報を取得する
'
' 引数　　 : (In)     lngCtrPtCd       契約パターンコード
' 　　　　   (In)     strCsCd          コースコード
' 　　　　   (In)     strSetClassCd    セット分類コード
' 　　　　   (In)     strCslDivCd      受診区分コード
' 　　　　   (In)     lngGender        受診可能性別
' 　　　　   (In)     strStrAge        受診開始年齢
' 　　　　   (In)     strEndAge        受診終了年齢
' 　　　　   (Out)    vntOptCd         オプションコード
' 　　　　   (Out)    vntOptBranchNo   オプション枝番
' 　　　　   (Out)    vntWebColor      webカラー
' 　　　　   (Out)    vntCsName        コース名
' 　　　　   (Out)    vntOptName       オプション名
' 　　　　   (Out)    vntSetColor      セットカラー
' 　　　　   (Out)    vntAgeName       年齢条件
' 　　　　   (Out)    vntAddCondition  追加条件
' 　　　　   (Out)    vntCslDivName    受診区分
' 　　　　   (Out)    vntGender        受診可能性別
' 　　　　   (Out)    vntSetClassName  セット分類名
' 　　　　   (Out)    vntSeq           ＳＥＱ
' 　　　　   (Out)    vntPrice         負担金額
' 　　　　   (Out)    vntOrgDiv        団体種別
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectCtrPtPriceOptAll( _
    ByVal lngCtrPtCd As Long, _
    ByVal strCsCd As String, _
    ByVal strSetClassCd As String, _
    ByVal strCslDivCd As String, _
    ByVal lngGender As Long, _
    ByVal strStrAge As String, _
    ByVal strEndAge As String, _
    ByRef vntOptCd As Variant, _
    ByRef vntOptBranchNo As Variant, _
    ByRef vntWebColor As Variant, _
    ByRef vntCsName As Variant, _
    ByRef vntOptName As Variant, _
    ByRef vntSetColor As Variant, _
    ByRef vntAgeName As Variant, _
    ByRef vntAddCondition As Variant, _
    ByRef vntCslDivName As Variant, _
    ByRef vntGender As Variant, _
    ByRef vntSetClassName As Variant, _
    ByRef vntSeq As Variant, _
    ByRef vntPrice As Variant, _
    ByRef vntOrgDiv As Variant, _
    Optional ByRef vntTax As Variant) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOptCd                As OraField         'オプションコード
    Dim objOptBranchNo          As OraField         'オプション枝番
    Dim objWebColor             As OraField         'webカラー
    Dim objCsName               As OraField         'コース名
    Dim objOptName              As OraField         'オプション名
    Dim objSetColor             As OraField         'セットカラー
    Dim objAgeName              As OraField         '年齢条件
    Dim objAddCondition         As OraField         '追加条件
    Dim objCslDivName           As OraField         '受診区分
    Dim objGender               As OraField         '受診可能性別
    Dim objSetClassName         As OraField         'セット分類名
    Dim objSeq                  As OraField         'ＳＥＱ
    Dim objPrice                As OraField         '負担金額
    Dim objOrgDiv               As OraField         '団体種別
    
    Dim vntArrOptCd()           As Variant          'オプションコードの配列
    Dim vntArrOptBranchNo()     As Variant          'オプション枝番の配列
    Dim vntArrWebColor()        As Variant          'webカラーの配列
    Dim vntArrCsName()          As Variant          'コース名の配列
    Dim vntArrOptName()         As Variant          'オプション名の配列
    Dim vntArrSetColor()        As Variant          'セットカラーの配列
    Dim vntArrAgeName()         As Variant          '年齢条件の配列
    Dim vntArrAddCondition()    As Variant          '追加条件の配列
    Dim vntArrCslDivName()      As Variant          '受診区分の配列
    Dim vntArrGender()          As Variant          '受診可能性別の配列
    Dim vntArrSetClassName()    As Variant          'セット分類名の配列
    Dim vntArrSeq()             As Variant          'ＳＥＱの配列
    Dim vntArrPrice()           As Variant          '負担金額の配列
    Dim vntArrOrgDiv()          As Variant          '団体種別の配列
    Dim lngCount                As Long             'レコード数
    
    Dim strPrevOptCd            As String           '直前のオプションコード
    Dim strPrevOptBranchNo      As String           '直前のオプション枝番
    Dim lngStrAge               As Long             '受診対象開始年齢
    Dim lngEndAge               As Long             '受診対象終了年齢
    Dim lngAge                  As Long             '年齢
    Dim lngBdnCount             As Long             '負担元数
    Dim lngEditBdnCount         As Long             '編集負担元数
    
''## 2005/10/21 Add by 李
    Dim objTax                  As OraField         '消費税
    Dim vntArrTax()             As Variant
''## 2005/10/21 Add　End
    
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntOptCd = Empty
    vntOptBranchNo = Empty
    vntWebColor = Empty
    vntCsName = Empty
    vntOptName = Empty
    vntSetColor = Empty
    vntAgeName = Empty
    vntAddCondition = Empty
    vntCslDivName = Empty
    vntGender = Empty
    vntSetClassName = Empty
    vntSeq = Empty
    vntPrice = Empty
    vntOrgDiv = Empty
    lngCount = 0
    
    '年齢条件の取得
    lngStrAge = IIf(strStrAge = "", AGE_MINVALUE, CLng("0" & strStrAge))
    lngEndAge = IIf(strEndAge = "", AGE_MAXVALUE, CLng("0" & strEndAge))
    If lngStrAge > lngEndAge Then
        lngAge = lngStrAge
        lngStrAge = lngEndAge
        lngEndAge = lngAge
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SETCLASSCD", strSetClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLDIVCD", strCslDivCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GENDER", lngGender, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRAGE", lngStrAge, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDAGE", lngEndAge, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定オプション区分の全オプション検査とその負担金額情報の取得
    strStmt = "SELECT OPTINFO.OPTCD,        OPTINFO.OPTBRANCHNO,  " & vbLf & _
              "       OPTINFO.WEBCOLOR,     OPTINFO.CSNAME,       " & vbLf & _
              "       OPTINFO.OPTNAME,      OPTINFO.SETCOLOR,     " & vbLf & _
              "       OPTINFO.AGENAME,      OPTINFO.ADDCONDITION, " & vbLf & _
              "       OPTINFO.CSLDIVNAME,   OPTINFO.GENDER,       " & vbLf & _
              "       OPTINFO.SETCLASSNAME, OPTINFO.SEQ,          " & vbLf & _
              "       NVL(CTRPT_PRICE.PRICE, 0) PRICE,            " & vbLf & _
              "       CTRPT_PRICE.ORGDIV                          " & vbLf & _
              "       ,NVL(CTRPT_PRICE.TAX, 0) TAX                " & vbLf & _
              "  FROM CTRPT_PRICE,                                "
    
    strStmt = strStmt & vbLf & _
              "       ( SELECT CTRPT_OPT.CTRPTCD,  CTRPT_OPT.OPTCD,    CTRPT_OPT.OPTBRANCHNO, " & vbLf & _
              "                CTRPT_OPT.OPTNAME,  CTRPT_OPT.SETCOLOR, CTRPT_OPT.CSCD,        " & vbLf & _
              "                CTRPT_OPT.CSLDIVCD, CTRPT_OPT.GENDER,   CTRPT_OPT.SETCLASSCD,  " & vbLf & _
              "                CTRPT_OPTGRP.ADDCONDITION,                                     " & vbLf & _
              "                COURSE_P.CSNAME,   COURSE_P.MAINCSCD, COURSE_P.WEBCOLOR,       " & vbLf & _
              "                CSLDIV.CSLDIVNAME, SETCLASS.SETCLASSNAME,                      " & vbLf & _
              "                CTRPT_ORG.SEQ,                                                 "

    strStmt = strStmt & vbLf & _
              "                GetAgeName(CTRPT_OPT.CTRPTCD, CTRPT_OPT.OPTCD, CTRPT_OPT.OPTBRANCHNO) AGENAME "
              
    strStmt = strStmt & vbLf & _
              "           FROM CTRPT_ORG, SETCLASS, CSLDIV,                  " & vbLf & _
              "                COURSE_P, CTRPT_OPTGRP, CTRPT_OPT             " & vbLf & _
              "          WHERE CTRPT_OPT.CTRPTCD    = :CTRPTCD               " & vbLf & _
              "            AND CTRPT_OPT.CTRPTCD    = CTRPT_OPTGRP.CTRPTCD   " & vbLf & _
              "            AND CTRPT_OPT.OPTCD      = CTRPT_OPTGRP.OPTCD     " & vbLf & _
              "            AND CTRPT_OPT.CSCD       = COURSE_P.CSCD          " & vbLf & _
              "            AND CTRPT_OPT.CSLDIVCD   = CSLDIV.CSLDIVCD(+)     " & vbLf & _
              "            AND CTRPT_OPT.SETCLASSCD = SETCLASS.SETCLASSCD(+) " & vbLf & _
              "            AND CTRPT_OPT.CTRPTCD    = CTRPT_ORG.CTRPTCD      "

    'コースコード指定時は条件節に加える
    If strCsCd <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CTRPT_OPT.CSCD = :CSCD "
    End If
              
    'セット分類指定時は条件節に加える
    If strSetClassCd <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CTRPT_OPT.SETCLASSCD = :SETCLASSCD "
    End If
              
    '受診区分指定時は条件節に加える
    If strCslDivCd <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CTRPT_OPT.CSLDIVCD = :CSLDIVCD "
    End If
              
    '性別指定時は条件節に加える
    If lngGender <> GENDER_BOTH Then
        strStmt = strStmt & vbLf & _
              "            AND CTRPT_OPT.GENDER = :GENDER "
    End If
    
    '受診開始終了年齢指定時は条件節に加える
    If strStrAge <> "" Or strEndAge <> "" Then
        
        strStmt = strStmt & vbLf & _
              "            AND ( EXISTS ( SELECT CTRPTCD                             " & vbLf & _
              "                             FROM CTRPT_OPTAGE                        " & vbLf & _
              "                            WHERE CTRPTCD     = CTRPT_OPT.CTRPTCD     " & vbLf & _
              "                              AND OPTCD       = CTRPT_OPT.OPTCD       " & vbLf & _
              "                              AND OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO " & vbLf & _
              "                              AND STRAGE  <= :ENDAGE                  " & vbLf & _
              "                              AND ENDAGE  >= :STRAGE )                "

        strStmt = strStmt & vbLf & _
              "                  OR                                                          " & vbLf & _
              "                  NOT EXISTS ( SELECT CTRPTCD                                 " & vbLf & _
              "                                 FROM CTRPT_OPTAGE                            " & vbLf & _
              "                                WHERE CTRPTCD     = CTRPT_OPT.CTRPTCD         " & vbLf & _
              "                                  AND OPTCD       = CTRPT_OPT.OPTCD           " & vbLf & _
              "                                  AND OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO ) ) "
    End If
              
    strStmt = strStmt & vbLf & _
              "       ) OPTINFO                                          " & vbLf & _
              " WHERE OPTINFO.CTRPTCD     = CTRPT_PRICE.CTRPTCD(+)       " & vbLf & _
              "   AND OPTINFO.OPTCD       = CTRPT_PRICE.OPTCD(+)         " & vbLf & _
              "   AND OPTINFO.OPTBRANCHNO = CTRPT_PRICE.OPTBRANCHNO(+)   " & vbLf & _
              "   AND OPTINFO.SEQ         = CTRPT_PRICE.SEQ(+)           " & vbLf & _
              " ORDER BY OPTINFO.OPTCD, OPTINFO.OPTBRANCHNO, OPTINFO.SEQ "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOptCd = objFields("OPTCD")
        Set objOptBranchNo = objFields("OPTBRANCHNO")
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsName = objFields("CSNAME")
        Set objOptName = objFields("OPTNAME")
        Set objSetColor = objFields("SETCOLOR")
        Set objAgeName = objFields("AGENAME")
        Set objAddCondition = objFields("ADDCONDITION")
        Set objCslDivName = objFields("CSLDIVNAME")
        Set objGender = objFields("GENDER")
        Set objSetClassName = objFields("SETCLASSNAME")
        Set objSeq = objFields("SEQ")
        Set objPrice = objFields("PRICE")
        Set objOrgDiv = objFields("ORGDIV")
        ''## 2005/10/21 Add by 李
        Set objTax = objFields("TAX")
        ''## 2005/10/21 Add End
        
        '最初のオプション検査のみを検索し、負担元数をカウント
        Do Until objOraDyna.EOF
            
            '直前のレコードとオプションコードまたは枝番が異なった時点で検索終了
            If strPrevOptCd <> "" And (objOptCd.Value <> strPrevOptCd Or objOptBranchNo.Value <> strPrevOptBranchNo) Then
                Exit Do
            End If
            
            '直前情報を更新
            strPrevOptCd = objOptCd.Value
            strPrevOptBranchNo = objOptBranchNo.Value
            
            '負担元数をカウント
            lngBdnCount = lngBdnCount + 1
            
            objOraDyna.MoveNext
        Loop
        
        '先頭に戻る
        objOraDyna.MoveFirst

        strPrevOptCd = ""
        strPrevOptBranchNo = ""
        
        Do Until objOraDyna.EOF
            
            '直前のレコードとオプションコードまたは枝番が異なる場合
            If objOptCd.Value <> strPrevOptCd Or objOptBranchNo.Value <> strPrevOptBranchNo Then

                '配列形式で格納する
                ReDim Preserve vntArrOptCd(lngCount)
                ReDim Preserve vntArrOptBranchNo(lngCount)
                ReDim Preserve vntArrWebColor(lngCount)
                ReDim Preserve vntArrCsName(lngCount)
                ReDim Preserve vntArrOptName(lngCount)
                ReDim Preserve vntArrSetColor(lngCount)
                ReDim Preserve vntArrAgeName(lngCount)
                ReDim Preserve vntArrAddCondition(lngCount)
                ReDim Preserve vntArrCslDivName(lngCount)
                ReDim Preserve vntArrGender(lngCount)
                ReDim Preserve vntArrSetClassName(lngCount)
                ReDim Preserve vntArrSeq(lngBdnCount - 1, lngCount)
                ReDim Preserve vntArrPrice(lngBdnCount - 1, lngCount)
                ReDim Preserve vntArrOrgDiv(lngBdnCount - 1, lngCount)
                ''## 2005/10/21 Add by 李
                ReDim Preserve vntArrTax(lngBdnCount - 1, lngCount)
                ''## 2005/10/21 Add　End

                '負担金額情報以外の各項目はここで編集
                vntArrOptCd(lngCount) = objOptCd.Value & ""
                vntArrOptBranchNo(lngCount) = objOptBranchNo.Value & ""
                vntArrWebColor(lngCount) = objWebColor.Value & ""
                vntArrCsName(lngCount) = objCsName.Value & ""
                vntArrOptName(lngCount) = objOptName.Value & ""
                vntArrSetColor(lngCount) = objSetColor.Value & ""
                vntArrAgeName(lngCount) = objAgeName.Value & ""
                vntArrAddCondition(lngCount) = objAddCondition.Value & ""
                vntArrCslDivName(lngCount) = objCslDivName.Value & ""
                vntArrGender(lngCount) = objGender.Value & ""
                vntArrSetClassName(lngCount) = objSetClassName.Value & ""

                lngCount = lngCount + 1
                lngEditBdnCount = 0
            
            End If
            
            '負担情報は毎回編集
            vntArrSeq(lngEditBdnCount, lngCount - 1) = objSeq.Value & ""
            vntArrPrice(lngEditBdnCount, lngCount - 1) = objPrice.Value & ""
            vntArrOrgDiv(lngEditBdnCount, lngCount - 1) = objOrgDiv.Value & ""
            ''## 2005/10/21 Add by 李
            vntArrTax(lngEditBdnCount, lngCount - 1) = objTax.Value & ""
            ''## 2005/10/21 Add　End
            lngEditBdnCount = lngEditBdnCount + 1

            '直前情報を更新
            strPrevOptCd = objOptCd.Value
            strPrevOptBranchNo = objOptBranchNo.Value
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntOptCd = vntArrOptCd
        vntOptBranchNo = vntArrOptBranchNo
        vntWebColor = vntArrWebColor
        vntCsName = vntArrCsName
        vntOptName = vntArrOptName
        vntSetColor = vntArrSetColor
        vntAgeName = vntArrAgeName
        vntAddCondition = vntArrAddCondition
        vntCslDivName = vntArrCslDivName
        vntGender = vntArrGender
        vntSetClassName = vntArrSetClassName
        vntSeq = vntArrSeq
        vntPrice = vntArrPrice
        vntOrgDiv = vntArrOrgDiv
        
        ''## 2005/10/21 Add by 李
        If Not IsMissing(vntTax) Then vntTax = vntArrTax
        ''## 2005/10/21 Add End
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectCtrPtPriceOptAll = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectCtrPtPriceOptAll = -1

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectCtrPtPriceOptAll"
    
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
' 機能　　 : 追加オプション用契約パターンオプション管理テーブルレコードの書き込み処理
'
' 引数　　 : (In)     strMode          処理モード("INS":挿入、"UPD":更新)
' 　　　　   (In)     lngCtrPtCd       契約パターンコード
' 　　　　   (In)     strOptCd         オプションコード
' 　　　　   (In)     lngOptBranchNo   オプション枝番
' 　　　　   (In)     strOptName       オプション名
' 　　　　   (In)     strOptSName      オプション略称
' 　　　　   (In)     strCsCd          コースコード
' 　　　　   (In)     strSetColor      セットカラー
' 　　　　   (In)     strSetClassCd    セット分類コード
' 　　　　   (In)     strRsvFraCd      予約枠コード
' 　　　　   (In)     strCslDivCd      受診区分コード
' 　　　　   (In)     lngGender        受診可能性別
' 　　　　   (In)     strLastRefMonth  前回値参照用月数
' 　　　　   (In)     strLastRefCsCd   前回値参照用コースコード
' 　　　　   (In)     strExceptLimit   限度額設定除外
    
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function SetCtrPtOpt_Add( _
    ByVal strMode As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal strOptCd As String, _
    ByVal lngOptBranchNo As Long, _
    ByVal strOptName As String, _
    ByVal strOptSName As String, _
    ByVal strCsCd As String, _
    ByVal strSetColor As String, _
    ByVal strSetClassCd As String, _
    ByVal strRsvFraCd As String, _
    ByVal strCslDivCd As String, _
    ByVal lngGender As Long, _
    ByVal strLastRefMonth As String, _
    ByVal strLastRefCsCd As String, _
    ByVal strExceptLimit As String _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTNAME", StrConv(strOptName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTSNAME", Trim(IIf(strOptSName <> "", StrConv(strOptSName, vbWide), Left(StrConv(strOptName, vbWide), 10))), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SETCOLOR", strSetColor, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SETCLASSCD", strSetClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVFRACD", strRsvFraCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLDIVCD", strCslDivCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GENDER", lngGender, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LASTREFMONTH", IIf(strLastRefMonth <> "", CLng("0" & strLastRefMonth), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LASTREFCSCD", strLastRefCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EXCEPTLIMIT", IIf(strExceptLimit <> "", CLng("0" & strExceptLimit), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '処理モードごとの処理
    Select Case strMode
    
        '契約パターンオプション管理テーブルレコードの挿入
        Case "INS"
            
            strStmt = "INSERT INTO CTRPT_OPT (   " & vbLf & _
                      "            CTRPTCD,      " & vbLf & _
                      "            OPTCD,        " & vbLf & _
                      "            OPTBRANCHNO,  " & vbLf & _
                      "            OPTNAME,      " & vbLf & _
                      "            OPTSNAME,     " & vbLf & _
                      "            CSCD,         " & vbLf & _
                      "            SETCOLOR,     " & vbLf & _
                      "            SETCLASSCD,   " & vbLf & _
                      "            RSVFRACD,     " & vbLf & _
                      "            CSLDIVCD,     " & vbLf & _
                      "            GENDER,       " & vbLf & _
                      "            LASTREFMONTH, " & vbLf & _
                      "            LASTREFCSCD,  " & vbLf & _
                      "            EXCEPTLIMIT   "

            strStmt = strStmt & vbLf & _
                      "       ) VALUES (          " & vbLf & _
                      "            :CTRPTCD,      " & vbLf & _
                      "            :OPTCD,        " & vbLf & _
                      "            :OPTBRANCHNO,  " & vbLf & _
                      "            :OPTNAME,      " & vbLf & _
                      "            :OPTSNAME,     " & vbLf & _
                      "            :CSCD,         " & vbLf & _
                      "            :SETCOLOR,     " & vbLf & _
                      "            :SETCLASSCD,   " & vbLf & _
                      "            :RSVFRACD,     " & vbLf & _
                      "            :CSLDIVCD,     " & vbLf & _
                      "            :GENDER,       " & vbLf & _
                      "            :LASTREFMONTH, " & vbLf & _
                      "            :LASTREFCSCD,  " & vbLf & _
                      "            :EXCEPTLIMIT   " & vbLf & _
                      "       )                   "

        '契約パターンオプション管理テーブルレコードの更新
        Case "UPD"
            
            strStmt = "UPDATE CTRPT_OPT                     " & vbLf & _
                      "   SET OPTNAME      = :OPTNAME,      " & vbLf & _
                      "       OPTSNAME     = :OPTSNAME,     " & vbLf & _
                      "       CSCD         = :CSCD,         " & vbLf & _
                      "       SETCOLOR     = :SETCOLOR,     " & vbLf & _
                      "       SETCLASSCD   = :SETCLASSCD,   " & vbLf & _
                      "       RSVFRACD     = :RSVFRACD,     " & vbLf & _
                      "       CSLDIVCD     = :CSLDIVCD,     " & vbLf & _
                      "       GENDER       = :GENDER,       " & vbLf & _
                      "       LASTREFMONTH = :LASTREFMONTH, " & vbLf & _
                      "       LASTREFCSCD  = :LASTREFCSCD,  " & vbLf & _
                      "       EXCEPTLIMIT  = :EXCEPTLIMIT   " & vbLf & _
                      " WHERE CTRPTCD      = :CTRPTCD       " & vbLf & _
                      "   AND OPTCD        = :OPTCD         " & vbLf & _
                      "   AND OPTBRANCHNO  = :OPTBRANCHNO   "
    
    End Select
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SetCtrPtOpt_Add = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SetCtrPtOpt_Add = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SetCtrPtOpt_Add"
    
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
' 機能　　 : 契約パターン負担金額管理テーブルレコードの書き込み処理
'
' 引数　　 : (In)     strMode            処理モード("INS":挿入、"UPD":更新、"DEL":削除)
' 　　　　   (In)     lngCtrPtCd         契約パターンコード
' 　　　　   (In)     vntSeq             SEQ
' 　　　　   (In)     strOptCd           オプションコード
' 　　　　   (In)     lngOptBranchNo     オプション枝番
' 　　　　   (In)     vntPrice           負担金額
' 　　　　   (In)     vntOrgDiv          団体種別
' 　　　　   (In)     vntTax             消費税
' 　　　　   (In)     vntBillPrintName   請求書出力名
' 　　　　   (In)     vntBillPrintEName  請求書英語出力名
'
' 戻り値　 : 0   正常終了
' 　　　　   1   追加オプション負担金テーブルで参照されているレコードを削除しようとした
' 　　　　   <0  異常終了
'
' 備考　　 : 更新値については、単数で渡される場合と配列形式で渡される場合とを想定
'
Public Function SetCtrPtPrice( _
    ByVal strMode As String, _
    ByVal lngCtrPtCd As Long, _
    ByRef vntSeq As Variant, _
    ByVal strOptCd As String, _
    ByVal lngOptBranchNo As Long, _
    ByRef vntPrice As Variant, _
    ByRef vntOrgDiv As Variant, _
    ByRef vntTax As Variant, _
    ByRef vntBillPrintName As Variant, _
    ByRef vntBillPrintEName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objInsOraSQLStmt    As OraSqlStmt       '(挿入用の)OraSQLStmtオブジェクト
    Dim objUpdOraSQLStmt    As OraSqlStmt       '(更新用の)OraSQLStmtオブジェクト
    Dim objDelOraSQLStmt    As OraSqlStmt       '(削除用の)OraSQLStmtオブジェクト
    Dim strInsStmt          As String           '(挿入用の)SQLステートメント
    Dim strUpdStmt          As String           '(更新用の)SQLステートメント
    Dim strDelStmt          As String           '(削除用の)SQLステートメント

    Dim objSeq              As OraParameter     'SEQ
    Dim objPrice            As OraParameter     '負担金額
    Dim objOrgDiv           As OraParameter     '団体種別
    Dim objTax              As OraParameter     '消費税
    Dim objBillPrintName    As OraParameter     '請求書出力名
    Dim objBillPrintEName   As OraParameter     '請求書英語出力名
    
    Dim strAction           As String           '1レコード単位の動作モード("INS":挿入、"UPD":更新、"DEL":削除)
    Dim lngRecCount         As Long             '書き込みレコード数
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD", strOptCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OPTBRANCHNO", lngOptBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PRICE", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGDIV", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TAX", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLPRINTNAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BILLPRINTENAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'パラメータの参照設定
    Set objSeq = objOraParam("SEQ")
    Set objPrice = objOraParam("PRICE")
    Set objOrgDiv = objOraParam("ORGDIV")
    Set objTax = objOraParam("TAX")
    Set objBillPrintName = objOraParam("BILLPRINTNAME")
    Set objBillPrintEName = objOraParam("BILLPRINTENAME")
    
    '契約パターン負担金額管理テーブル挿入用のSQLステートメント作成
    strInsStmt = "INSERT INTO CTRPT_PRICE (  " & vbLf & _
                 "            CTRPTCD,       " & vbLf & _
                 "            SEQ,           " & vbLf & _
                 "            OPTCD,         " & vbLf & _
                 "            OPTBRANCHNO,   " & vbLf & _
                 "            PRICE,         " & vbLf & _
                 "            ORGDIV,        " & vbLf & _
                 "            TAX,           " & vbLf & _
                 "            BILLPRINTNAME, " & vbLf & _
                 "            BILLPRINTENAME "

    strInsStmt = strInsStmt & vbLf & _
                 "       ) VALUES (           " & vbLf & _
                 "            :CTRPTCD,       " & vbLf & _
                 "            :SEQ,           " & vbLf & _
                 "            :OPTCD,         " & vbLf & _
                 "            :OPTBRANCHNO,   " & vbLf & _
                 "            :PRICE,         " & vbLf & _
                 "            :ORGDIV,        " & vbLf & _
                 "            :TAX,           " & vbLf & _
                 "            :BILLPRINTNAME, " & vbLf & _
                 "            :BILLPRINTENAME " & vbLf & _
                 "       )                    "

    '契約パターン負担金額管理テーブル更新用のSQLステートメント作成
    strUpdStmt = "UPDATE CTRPT_PRICE                      " & vbLf & _
                 "   SET PRICE          = :PRICE,         " & vbLf & _
                 "       ORGDIV         = :ORGDIV,        " & vbLf & _
                 "       TAX            = :TAX,           " & vbLf & _
                 "       BILLPRINTNAME  = :BILLPRINTNAME, " & vbLf & _
                 "       BILLPRINTENAME = :BILLPRINTENAME " & vbLf & _
                 " WHERE CTRPTCD        = :CTRPTCD        " & vbLf & _
                 "   AND OPTCD          = :OPTCD          " & vbLf & _
                 "   AND OPTBRANCHNO    = :OPTBRANCHNO    " & vbLf & _
                 "   AND SEQ            = :SEQ            "
                 
    '契約パターン負担金額管理テーブル削除用のSQLステートメント作成
    strDelStmt = "DELETE CTRPT_PRICE                " & vbLf & _
                 " WHERE CTRPTCD     = :CTRPTCD     " & vbLf & _
                 "   AND OPTCD       = :OPTCD       " & vbLf & _
                 "   AND OPTBRANCHNO = :OPTBRANCHNO " & vbLf & _
                 "   AND SEQ         = :SEQ         "

    '各配列値の挿入処理
    For i = 0 To UBound(vntSeq)
    
        '配列値の編集
        objSeq.Value = CLng(vntSeq(i))
        If vntPrice(i) <> "" Then
            objPrice.Value = CLng(vntPrice(i))
        Else
            objPrice.Value = 0&
        End If
        objOrgDiv.Value = IIf(vntOrgDiv(i) <> "", CLng("0" & vntOrgDiv(i)), Null)
        If vntTax(i) <> "" Then
            objTax.Value = CLng(vntTax(i))
        Else
            objTax.Value = 0&
        End If
        objBillPrintName.Value = CStr(StrConv(vntBillPrintName(i), vbWide))
        objBillPrintEName.Value = CStr(vntBillPrintEName(i))
        
        '動作モードの決定
        '①処理モードが削除でないが負担金額がZEROの場合は動作モードを削除にする
        '②それ以外は処理モードに準ずる
        strAction = strMode
            
        '動作モードごとの処理
        Select Case strAction
            
            '挿入処理の場合
            Case "INS"
    
                '挿入SQL文の実行
                If objInsOraSQLStmt Is Nothing Then
                    Set objInsOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strInsStmt), ORASQL_FAILEXEC)
                Else
                    objInsOraSQLStmt.Refresh
                End If
        
            '更新処理の場合
            Case "UPD"
        
                '更新SQL文の実行
                If objUpdOraSQLStmt Is Nothing Then
                    lngRecCount = 0
                    Set objUpdOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strUpdStmt), ORASQL_FAILEXEC)
                Else
                    lngRecCount = objUpdOraSQLStmt.RecordCount
                    objUpdOraSQLStmt.Refresh
                End If
        
                '更新レコード件数が増加していない(即ち更新されていない)場合は挿入処理を行う
                If objUpdOraSQLStmt.RecordCount = 0 Then
        
                    '挿入SQL文の実行
                    If objInsOraSQLStmt Is Nothing Then
                        Set objInsOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strInsStmt), ORASQL_FAILEXEC)
                    Else
                        objInsOraSQLStmt.Refresh
                    End If
        
                End If
                    
            '削除処理の場合
            Case "DEL"
                    
                '削除SQL文の実行
                If objDelOraSQLStmt Is Nothing Then
                    Set objDelOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strDelStmt), ORASQL_FAILEXEC)
                Else
                    objDelOraSQLStmt.Refresh
                End If
        
        End Select
        
    Next i
              
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SetCtrPtPrice = 0
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '子レコード存在による削除エラー時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 2292 Then
        SetCtrPtPrice = 1
        Exit Function
    End If
    
    'イベントログ書き込み
    WriteErrorLog "Contract.SetCtrPtPrice"
    
    SetCtrPtPrice = -1

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 受診情報の契約パターンコード付け替え
'
' 引数　　 : (In)     strRefOrgCd1   参照先団体コード1
' 　　　　   (In)     strRefOrgCd2   参照先団体コード2
' 　　　　   (In)     lngCurCtrPtCd  (現)契約パターンコード
' 　　　　   (In)     lngNewCtrPtCd  (新)契約パターンコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateConsultCtrPt( _
    ByVal strRefOrgCd1 As String, _
    ByVal strRefOrgCd2 As String, _
    ByVal lngCurCtrPtCd As Long, _
    ByVal lngNewCtrPtCd As Long _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim vntTableName    As Variant          '更新対象テーブル名の配列
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '更新対象テーブル名の配列を作成
    '(対象は予約番号を主キーに持ち、かつ契約パターンコードを列に持つテーブル)
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    vntTableName = Array("CONSULT_O", "GRPPRICE", "ITEMPRICE", "OPTPRICE", "CONSULT")
    vntTableName = Array("CONSULT_O", "CONSULT")
'## 2003.11.18 Mod End
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "REFORGCD1", Trim(strRefOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REFORGCD2", Trim(strRefOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CURCTRPTCD", lngCurCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NEWCTRPTCD", lngNewCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
'## 2004.01.27 Mod By T.Takagi@FSIT 契約パターン付替時に受診金額情報を再作成
'    '更新対象となる全てのテーブルについて契約パターンコード付け替えを行う
'    For i = 0 To UBound(vntTableName)
'
'        strStmt = "UPDATE " & vntTableName(i) & "                                     " & vbLf & _
'                  "   SET CTRPTCD = :NEWCTRPTCD                                       " & vbLf & _
'                  " WHERE RSVNO IN ( SELECT CONSULT.RSVNO                             " & vbLf & _
'                  "                    FROM CONSULT,                                  " & vbLf & _
'                  "                         ( SELECT CTRMNG.ORGCD1, CTRMNG.ORGCD2,    " & vbLf & _
'                  "                                  CTRMNG.CSCD,   CTRMNG.CTRPTCD,   " & vbLf & _
'                  "                                  CTRPT.STRDATE, CTRPT.ENDDATE     " & vbLf & _
'                  "                             FROM CTRPT, CTRMNG                    " & vbLf & _
'                  "                            WHERE CTRMNG.REFORGCD1 = :REFORGCD1    " & vbLf & _
'                  "                              AND CTRMNG.REFORGCD2 = :REFORGCD2    " & vbLf & _
'                  "                              AND CTRMNG.CTRPTCD   = :NEWCTRPTCD   " & vbLf & _
'                  "                              AND CTRMNG.CTRPTCD   = CTRPT.CTRPTCD " & vbLf & _
'                  "                         ) NEWCTRMNG                               " & vbLf & _
'                  "                   WHERE CONSULT.CSLDATE >= NEWCTRMNG.STRDATE      " & vbLf & _
'                  "                     AND CONSULT.CSLDATE <= NEWCTRMNG.ENDDATE      " & vbLf & _
'                  "                     AND CONSULT.ORGCD1   = NEWCTRMNG.ORGCD1       " & vbLf & _
'                  "                     AND CONSULT.ORGCD2   = NEWCTRMNG.ORGCD2       " & vbLf & _
'                  "                     AND CONSULT.CSCD     = NEWCTRMNG.CSCD )       " & vbLf & _
'                  "   AND CTRPTCD = :CURCTRPTCD                                       "
'
'        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'
'    Next i
    mobjOraDb.ExecuteSQL "BEGIN ContractPackage.UpdateConsultCtrPt(:REFORGCD1, :REFORGCD2, :CURCTRPTCD, :NEWCTRPTCD); END;"
'## 2004.01.27 Mod End

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateConsultCtrPt = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateConsultCtrPt = False

    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateConsultCtrPt"
    
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
' 機能　　 : 契約管理テーブルレコードの帳票コードを更新する
'
' 引数　　 : (In)     strOrgCd1    団体コード1
' 　　　　   (In)     strOrgCd2    団体コード2
' 　　　　   (In)     lngCtrPtCd   契約パターンコード
' 　　　　   (In)     strReportCd  帳票コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Function UpdateCtrMng(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal lngCtrPtCd As Long, ByVal strReportCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPORTCD", strReportCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '契約管理テーブルレコードの更新
    strStmt = "UPDATE CTRMNG               " & vbLf & _
              "   SET REPORTCD = :REPORTCD " & vbLf & _
              " WHERE ORGCD1   = :ORGCD1   " & vbLf & _
              "   AND ORGCD2   = :ORGCD2   " & vbLf & _
              "   AND CTRPTCD  = :CTRPTCD  "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '戻り値の設定
    UpdateCtrMng = True

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateCtrMng = False
    
    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCtrMng"
    
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
' 機能　　 : 契約パターンテーブルレコードの年齢起算日を更新する
'
' 引数　　 : (In)     lngCtrPtcd      契約パターンコード
' 　　　　   (In)     vntStrDate      契約開始日
' 　　　　   (In)     vntEndDate      契約終了日
' 　　　　   (In)     vntTaxFraction  税端数区分
' 　　　　   (In)     vntAgeCalc      年齢起算日
' 　　　　   (In)     vntCsName       コース名
' 　　　　   (In)     vntCsEName      英語コース名
' 　　　　   (In)     vntCslMethod    予約方法
' 　　　　   (In)     vntLimitRate    限度率
' 　　　　   (In)     vntLimitTaxFlg  限度額消費税フラグ
' 　　　　   (In)     vntLimitPrice   上限金額
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Function UpdateCtrPt( _
    ByVal lngCtrPtCd As Long, _
    Optional ByVal vntStrDate As Variant, _
    Optional ByVal vntEndDate As Variant, _
    Optional ByVal vntTaxFraction As Variant, _
    Optional ByVal vntAgeCalc As Variant, _
    Optional ByVal vntCsName As Variant, _
    Optional ByVal vntCsEName As Variant, _
    Optional ByVal vntCslMethod As Variant, _
    Optional ByVal vntLimitRate As Variant, _
    Optional ByVal vntLimitTaxFlg As Variant, _
    Optional ByVal vntLimitPrice As Variant _
) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    Dim blnStrDate      As Boolean      '契約開始日の指定有無
    Dim blnEndDate      As Boolean      '契約終了日の指定有無
    Dim blnTaxFraction  As Boolean      '税端数区分の指定有無
    Dim blnAgeCalc      As Boolean      '年齢起算日の指定有無
    Dim blnCsName       As Boolean      'コース名の指定有無
    Dim blnCsEName      As Boolean      '英語コース名の指定有無
    Dim blnCslMethod    As Boolean      '予約方法の指定有無
    Dim blnLimitRate    As Boolean      '限度率の指定有無
    Dim blnLimitTaxFlg  As Boolean      '限度額消費税フラグの指定有無
    Dim blnLimitPrice   As Boolean      '上限金額の指定有無
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    blnStrDate = Not IsMissing(vntStrDate)
    blnEndDate = Not IsMissing(vntEndDate)
    blnTaxFraction = Not IsMissing(vntTaxFraction)
    blnAgeCalc = Not IsMissing(vntAgeCalc)
    blnCsName = Not IsMissing(vntCsName)
    blnCsEName = Not IsMissing(vntCsEName)
    blnCslMethod = Not IsMissing(vntCslMethod)
    blnLimitRate = Not IsMissing(vntLimitRate)
    blnLimitTaxFlg = Not IsMissing(vntLimitTaxFlg)
    blnLimitPrice = Not IsMissing(vntLimitPrice)
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    If blnStrDate Then objOraParam.Add "STRDATE", CDate(vntStrDate), ORAPARM_INPUT, ORATYPE_DATE
    If blnEndDate Then objOraParam.Add "ENDDATE", CDate(vntEndDate), ORAPARM_INPUT, ORATYPE_DATE
    If blnTaxFraction Then objOraParam.Add "TAXFRACTION", CLng(vntTaxFraction), ORAPARM_INPUT, ORATYPE_NUMBER
    If blnAgeCalc Then objOraParam.Add "AGECALC", CStr(vntAgeCalc), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If blnCsName Then objOraParam.Add "CSNAME", CStr(StrConv(vntCsName, vbWide)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If blnCsEName Then objOraParam.Add "CSENAME", CStr(vntCsEName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If blnCslMethod Then objOraParam.Add "CSLMETHOD", IIf(vntCslMethod <> "", CLng("0" & vntCslMethod), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    If blnLimitRate Then objOraParam.Add "LIMITRATE", IIf(vntLimitRate <> "", CLng("0" & vntLimitRate), 0), ORAPARM_INPUT, ORATYPE_NUMBER
    If blnLimitTaxFlg Then objOraParam.Add "LIMITTAXFLG", CLng(vntLimitTaxFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    If blnLimitPrice Then objOraParam.Add "LIMITPRICE", IIf(vntLimitPrice <> "", CLng("0" & vntLimitPrice), Null), ORAPARM_INPUT, ORATYPE_NUMBER
        
    '契約パターンテーブルレコードの更新
    strStmt = "UPDATE CTRPT                                                          " & vbLf & _
              "   SET STRDATE     = " & IIf(blnStrDate, ":", "") & "STRDATE,         " & vbLf & _
              "       ENDDATE     = " & IIf(blnEndDate, ":", "") & "ENDDATE,         " & vbLf & _
              "       TAXFRACTION = " & IIf(blnTaxFraction, ":", "") & "TAXFRACTION, " & vbLf & _
              "       AGECALC     = " & IIf(blnAgeCalc, ":", "") & "AGECALC,         " & vbLf & _
              "       CSNAME      = " & IIf(blnCsName, ":", "") & "CSNAME,           " & vbLf & _
              "       CSENAME     = " & IIf(blnCsEName, ":", "") & "CSENAME,         " & vbLf & _
              "       CSLMETHOD   = " & IIf(blnCslMethod, ":", "") & "CSLMETHOD,     " & vbLf & _
              "       LIMITRATE   = " & IIf(blnLimitRate, ":", "") & "LIMITRATE,     " & vbLf & _
              "       LIMITTAXFLG = " & IIf(blnLimitTaxFlg, ":", "") & "LIMITTAXFLG, " & vbLf & _
              "       LIMITPRICE  = " & IIf(blnLimitPrice, ":", "") & "LIMITPRICE    " & vbLf & _
              " WHERE CTRPTCD     = :CTRPTCD                                         "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '戻り値の設定
    UpdateCtrPt = True

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateCtrPt = False
    
    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCtrPt"
    
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
' 機能　　 : 契約パターンテーブルレコードの年齢起算日を更新する
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     strAgeCalc  年齢起算日
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Function UpdateCtrPt_AgeCalc(ByVal lngCtrPtCd As Long, ByVal strAgeCalc As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AGECALC", strAgeCalc, ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '契約パターンテーブルレコードの更新
    strStmt = "UPDATE CTRPT              " & vbLf & _
              "   SET AGECALC = :AGECALC " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '戻り値の設定
    UpdateCtrPt_AgeCalc = True

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateCtrPt_AgeCalc = False
    
    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCtrPt_AgeCalc"
    
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
' 機能　　 : 契約パターンテーブルレコードの税端数区分を更新する
'
' 引数　　 : (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     lngTaxFraction  税負担区分
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Function UpdateCtrPt_Fraction(ByVal lngCtrPtCd As Long, ByVal lngTaxFraction As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXFRACTION", lngTaxFraction, ORAPARM_INPUT, ORATYPE_NUMBER
        
    '契約パターンテーブルレコードの更新
    strStmt = "UPDATE CTRPT                      " & vbLf & _
              "   SET TAXFRACTION = :TAXFRACTION " & vbLf & _
              " WHERE CTRPTCD     = :CTRPTCD     "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '戻り値の設定
    UpdateCtrPt_Fraction = True

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateCtrPt_Fraction = False
    
    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCtrPt_Fraction"
    
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
' 機能　　 : 契約パターンテーブルレコードの契約期間を更新する
'
' 引数　　 : (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     vntStrDate  契約開始日
' 　　　　   (In)     vntEndDate  契約終了日
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Function UpdateCtrPt_Period(ByVal lngCtrPtCd As Long, ByVal dtmStrDate As Date, ByVal dtmEndDate As Date) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
        
    '契約パターンテーブルレコードの更新
    strStmt = "UPDATE CTRPT "

    '契約開始年月日指定時は指定された日付を更新し、未指定時は現データベース内容をそのまま適用する
    If dtmStrDate > 0 Then
        strStmt = strStmt & vbLf & _
              "   SET STRDATE = :STRDATE, "
    Else
        strStmt = strStmt & vbLf & _
              "   SET STRDATE = STRDATE,  "
    End If
              
    '契約終了年月日指定時は指定された日付を更新し、未指定時は現データベース内容をそのまま適用する
    If dtmEndDate > 0 Then
        strStmt = strStmt & vbLf & _
              "       ENDDATE = :ENDDATE "
    Else
        strStmt = strStmt & vbLf & _
              "       ENDDATE = ENDDATE  "
    End If
              
    strStmt = strStmt & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD  "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '戻り値の設定
    UpdateCtrPt_Period = True

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateCtrPt_Period = False
    
    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCtrPt_Period"
    
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
' 機能　　 : 契約パターン負担元管理テーブルにおける団体コードの更新
'
' 引数　　 : (In)     lngCtrPtCd   契約パターンコード
' 　　　　   (In)     vntSeq       SEQ
' 　　　　   (In)     vntOrgCd1    団体コード1
' 　　　　   (In)     vntOrgCd2    団体コード2
' 　　　　   (In)     vntTaxFlg    消費税負担フラグ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateCtrPtOrg( _
    ByVal lngCtrPtCd As Long, _
    ByRef vntSeq As Variant, _
    ByRef vntOrgCd1 As Variant, _
    ByRef vntOrgCd2 As Variant, _
    ByRef vntTaxFlg As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objSeq          As OraParameter     'SEQ
    Dim objOrgCd1       As OraParameter     '団体コード1
    Dim objOrgCd2       As OraParameter     '団体コード2
    Dim objTaxFlg       As OraParameter     '消費税負担フラグ
    
    Dim vntArrSeq       As Variant          'SEQの配列
    Dim vntArrOrgCd1    As Variant          '団体コード1の配列
    Dim vntArrOrgCd2    As Variant          '団体コード2の配列
    Dim vntArrTaxFlg    As Variant          '消費税負担フラグの配列
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '挿入処理に際し、引数値を配列形式に変換
    If IsArray(vntSeq) Then
        vntArrSeq = vntSeq
        vntArrOrgCd1 = vntOrgCd1
        vntArrOrgCd2 = vntOrgCd2
        vntArrTaxFlg = vntTaxFlg
    Else
        vntArrSeq = Array(vntSeq)
        vntArrOrgCd1 = Array(vntOrgCd1)
        vntArrOrgCd2 = Array(vntOrgCd2)
        vntArrTaxFlg = Array(vntTaxFlg)
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGCD1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TAXFLG", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'パラメータの参照設定
    Set objSeq = objOraParam("SEQ")
    Set objOrgCd1 = objOraParam("ORGCD1")
    Set objOrgCd2 = objOraParam("ORGCD2")
    Set objTaxFlg = objOraParam("TAXFLG")
    
    '契約パターン負担元管理テーブルレコード更新のSQLステートメント作成
    strStmt = "UPDATE CTRPT_ORG           " & vbLf & _
              "   SET ORGCD1   = :ORGCD1, " & vbLf & _
              "       ORGCD2   = :ORGCD2, " & vbLf & _
              "       TAXFLG   = :TAXFLG  " & vbLf & _
              " WHERE CTRPTCD  = :CTRPTCD " & vbLf & _
              "   AND SEQ      = :SEQ     "
              
    '各配列値の挿入処理
    For i = 0 To UBound(vntArrSeq)
    
        '配列値の編集
        objSeq.Value = CLng(vntArrSeq(i))
        objOrgCd1.Value = CStr(vntArrOrgCd1(i))
        objOrgCd2.Value = CStr(vntArrOrgCd2(i))
        objTaxFlg.Value = CLng(vntArrTaxFlg(i))
    
        'SQL文の実行
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
    
    '戻り値の設定
    UpdateCtrPtOrg = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateCtrPtOrg = False

    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCtrPtOrg"
    
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
' 機能　　 : 契約パターン負担元管理テーブルにおける限度額情報の更新
'
' 引数　　 : (In)     lngCtrPtCd    契約パターンコード
' 　　　　   (In)     strSeqOrg     対象負担元ＳＥＱ
' 　　　　   (In)     strSeqBdnOrg  減算した金額の負担元ＳＥＱ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateCtrPtOrgLimit( _
    ByVal lngCtrPtCd As Long, _
    ByVal strSeqOrg As String, _
    ByVal strSeqBdnOrg As String _
) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び配列パラメータの追加
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGSEQ", IIf(strSeqOrg <> "", CLng("0" & strSeqOrg), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGBDNSEQ", IIf(strSeqBdnOrg <> "", CLng("0" & strSeqBdnOrg), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '契約パターン負担元管理テーブル更新
    strStmt = "UPDATE CTRPT_ORG                                                  " & vbLf & _
              "   SET LIMITPRICEFLG = DECODE(SEQ, :ORGSEQ, 0, :ORGBDNSEQ, 1, '') " & vbLf & _
              " WHERE CTRPTCD       = :CTRPTCD                                   "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    UpdateCtrPtOrgLimit = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateCtrPtOrgLimit = False

    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCtrPtOrgLimit"
    
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
' 機能　　 : 契約パターン負担元管理テーブルにおける契約外負担情報の更新
'
' 引数　　 : (In)     lngCtrPtCd   契約パターンコード
' 　　　　   (In)     vntSeq       SEQ
' 　　　　   (In)     vntNoCtr     契約外項目負担フラグ
' 　　　　   (In)     vntFraction  契約外項目端数負担フラグ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateCtrPtOrgNoCtr( _
    ByVal lngCtrPtCd As Long, _
    ByRef vntSeq As Variant, _
    ByRef vntNoCtr As Variant, _
    ByRef vntFraction As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objSeq          As OraParameter     'SEQ
    Dim objNoCtr        As OraParameter     '契約外項目負担フラグ
    Dim objFraction     As OraParameter     '契約外項目端数負担フラグ
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び配列パラメータの追加
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NOCTR", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FRACTION", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'パラメータの参照設定
    Set objSeq = objOraParam("SEQ")
    Set objNoCtr = objOraParam("NOCTR")
    Set objFraction = objOraParam("FRACTION")
    
    '契約パターン負担元管理テーブル更新
    strStmt = "UPDATE CTRPT_ORG             " & vbLf & _
              "   SET NOCTR    = :NOCTR,    " & vbLf & _
              "       FRACTION = :FRACTION  " & vbLf & _
              " WHERE CTRPTCD  = :CTRPTCD   " & vbLf & _
              "   AND SEQ      = :SEQ       "
    
    '各配列値の挿入処理
    For i = 0 To UBound(vntSeq)
    
        '配列値の編集
        objSeq.Value = CLng("0" & vntSeq(i))
        objNoCtr.Value = CLng("0" & vntNoCtr(i))
        objFraction.Value = CLng("0" & vntFraction(i))
    
        'SQL文の実行
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
    
    UpdateCtrPtOrgNoCtr = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdateCtrPtOrgNoCtr = False

    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCtrPtOrgNoCtr"
    
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
'    Set mobjOraDb = mobjOraSession.OpenDatabase(objCommon.ConnectString, objCommon.UserName & "/" & objCommon.Password, 0)
    
    
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
