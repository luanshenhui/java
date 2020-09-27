VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "StdValue"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'### 2003/05/17 Updated by Ishihara@FSIT 基準値更新処理に検査項目コードの指定を追加
'
' 機能　　 : 基準値テーブルレコード再更新
'
' 引数　　 : (In)    dtmStrDate         開始受診日
' 　　　　   (In)    dtmEndDate         終了受診日
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 : 既に存在する結果に対する基準値コードを現在のマスタ状況に併せて更新
'
Public Function UpdateAllStdValue(ByVal dtmStrDate As Date, _
                                  ByVal dtmEndDate As Date, _
                                  Optional ByVal vntItemCd As Variant, _
                                  Optional ByVal vntSuffix As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    UpdateAllStdValue = INSERT_ERROR
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE

'### 2003/05/17 Updated by Ishihara@FSIT 基準値更新処理に検査項目コードの指定を追加
    '検査項目コードが指定されているなら条件に追加する
    If IsMissing(vntItemCd) = False And IsMissing(vntSuffix) = False Then
        If Trim(vntItemCd) <> "" And Trim(vntSuffix) <> "" Then
            objOraParam.Add "ITEMCD", vntItemCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
            objOraParam.Add "SUFFIX", vntSuffix, ORAPARM_INPUT, ORATYPE_VARCHAR2
        End If
    End If
'### 2003/05/17 Updated End

    Do
        '基準値の再更新
'### 2004/01/05 Updated by Ishihara@FSIT こんな大げさなことしなくてよい（by 高木）
'        strStmt = "UPDATE RSL" & _
                  "   SET STDVALUECD = CheckResultPackage.UpdateStdValue ( RSL.RSVNO, RSL.ITEMCD, RSL.SUFFIX, RSL.RESULT )" & _
                  " WHERE EXISTS ( SELECT CONSULT.RSVNO" & _
                  "                  FROM CONSULT" & _
                  "                 WHERE CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE" & _
                  "                   AND CONSULT.RSVNO   = RSL.RSVNO )"
        strStmt = "UPDATE RSL" & _
                  "   SET RESULT = RESULT" & _
                  " WHERE EXISTS ( SELECT CONSULT.RSVNO" & _
                  "                  FROM CONSULT" & _
                  "                 WHERE CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE" & _
                  "                   AND CONSULT.RSVNO   = RSL.RSVNO )"
'### 2004/01/05 Updated End
        
'### 2003/05/17 Updated by Ishihara@FSIT 基準値更新処理に検査項目コードの指定を追加
        '検査項目コードが指定されているなら条件に追加する
        If IsMissing(vntItemCd) = False And IsMissing(vntSuffix) = False Then
            If Trim(vntItemCd) <> "" And Trim(vntSuffix) <> "" Then
                strStmt = strStmt & vbLf & _
                    " AND RSL.ITEMCD = :ITEMCD " & vbLf & _
                    " AND RSL.SUFFIX = :SUFFIX "

            End If
        End If
'### 2003/05/17 Updated End
        
        
'### 2003/05/17 Updated by Ishihara@FSIT OmitCharSpc指定追加
'        Ret = mobjOraDb.ExecuteSQL(strStmt)
        Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
'### 2003/05/17 Updated End
        
        
'### 2003/11/12 Updated by Takagi@FSIT 更新件数が０件だとエラー扱いにされる
'        If Ret > 0 Then
'            Ret = INSERT_NORMAL
'            Exit Do
'        End If
        Ret = INSERT_NORMAL
'### 2003/11/12 Updated End

        Exit Do

    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    If Ret = INSERT_NORMAL Then
        'トランザクションをコミット
        mobjContext.SetComplete
    Else
        'エラー発生時はRollback
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    UpdateAllStdValue = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    UpdateAllStdValue = INSERT_ERROR
    
    'イベントログ書き込み
    WriteErrorLog "StdValue.UpdateAllStdValue"
    
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
' 機能　　 : 基準値（履歴・親）の一覧を取得する
'
' 引数　　 : (In)     strClassCd        検査分類コード（空白可）
' 　　　　 : (In)     strItemCd         検査項目コード（空白可）
' 　　　　 : (In)     strSuffix         サフィックス（空白可）
' 　　　　 : (Out)    vntStdValueMngCd  基準値管理コード
' 　　　　 : (Out)    vntItemCd         検査項目コード
' 　　　　 : (Out)    vntSuffix         サフィックス
' 　　　　 : (Out)    vntStrDate        使用開始日付
' 　　　　 : (Out)    vntEndDate        使用終了日付
' 　　　　 : (Out)    vntCsCd           対象コースコード
' 　　　　 : (Out)    vntItemName       検査項目名（省略可）
' 　　　　 : (Out)    vntCsName         対象コース名（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 :　検査分類コード、検査項目コード、サフィックスが未指定の場合は全件表示
'
Public Function SelectStdValueList(ByVal strClassCd As String, _
                                   ByVal strItemCd As String, _
                                   ByVal strSuffix As String, _
                                   ByRef vntstdValueMngCd As Variant, _
                                   ByRef vntItemCd As Variant, _
                                   ByRef vntSuffix As Variant, _
                                   ByRef vntStrDate As Variant, _
                                   ByRef vntEndDate As Variant, _
                                   ByRef vntCsCd As Variant, _
                                   Optional ByRef vntItemName As Variant, _
                                   Optional ByRef vntCsName As Variant _
                                  ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objStdValueMngCd        As OraField         '基準値管理コード
    Dim objItemCd               As OraField         '検査項目コード
    Dim objSuffix               As OraField         'サフィックス
    Dim objStrDate              As OraField         '使用開始日付
    Dim objEndDate              As OraField         '使用終了日付
    Dim objCsCd                 As OraField         '対象コースコード
    Dim objItemName             As OraField         '検査項目名
    Dim objCsName               As OraField         '対象コース名
    
    Dim vntArrStdValueMngCd()   As Variant          '基準値管理コード
    Dim vntArrItemCd()          As Variant          '検査項目コード
    Dim vntArrSuffix()          As Variant          'サフィックス
    Dim vntArrStrDate()         As Variant          '使用開始日付
    Dim vntArrEndDate()         As Variant          '使用終了日付
    Dim vntArrCsCd()            As Variant          '対象コースコード
    Dim vntArrItemName()        As Variant          '検査項目名
    Dim vntArrCsName()          As Variant          '対象コース名
    
    Dim blnSelectItem           As Boolean          '検査項目による検索条件指定
    Dim blnSelectClass          As Boolean          '検査分類による検索条件指定
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectStdValueList = 0
    lngCount = 0
    blnSelectItem = False
    blnSelectClass = False
    
    Set objOraParam = mobjOraDb.Parameters
    
    '検査分類コードを指定されている場合はフラグON
    If (Trim(strClassCd) <> "") Then
        blnSelectClass = True
        objOraParam.Add "CLASSCD", Trim(strClassCd), ORAPARM_INPUT
    End If
    
    '検査項目コードとサフィックスを指定されている場合はフラグON
    If (Trim(strItemCd) <> "") And (Trim(strSuffix) <> "") Then
        blnSelectItem = True
        objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT
        objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT
    End If
    
    '基準値テーブルよりレコードを取得
    strStmt = "SELECT STDVALUE.STDVALUEMNGCD, STDVALUE.ITEMCD,  STDVALUE.SUFFIX," & vbLf & _
              "       STDVALUE.STRDATE, STDVALUE.ENDDATE," & vbLf & _
              "       STDVALUE.CSCD, COURSE_P.CSNAME,  ITEM_C.ITEMNAME" & vbLf & _
              "  FROM ITEM_P, ITEM_C, COURSE_P,STDVALUE" & vbLf & _
              " WHERE STDVALUE.CSCD = COURSE_P.CSCD(+)" & vbLf & _
              "   AND ITEM_C.ITEMCD = STDVALUE.ITEMCD" & vbLf & _
              "   AND ITEM_C.SUFFIX = STDVALUE.SUFFIX" & vbLf & _
              "   AND ITEM_P.ITEMCD = STDVALUE.ITEMCD" & vbLf

    '検査分類コードを指定されている場合は検索条件に追加
    If blnSelectClass = True Then
        strStmt = strStmt & "   AND ITEM_P.CLASSCD = :CLASSCD" & vbLf
    End If
    
    '検査項目コードとサフィックスを指定されている場合は検索条件に追加
    If blnSelectItem = True Then
        strStmt = strStmt & "   AND STDVALUE.ITEMCD = :ITEMCD" & vbLf & _
                            "   AND STDVALUE.SUFFIX = :SUFFIX"
    End If
    
    '読み込み順指定
    strStmt = strStmt & " ORDER BY STDVALUE.ITEMCD, STDVALUE.SUFFIX, STDVALUE.ENDDATE DESC, STDVALUE.CSCD ASC"

'### 2003/05/17 Updated by Ishihara@FSIT OmitCharSpc指定追加
'    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
'### 2003/05/17 Updated End
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objStdValueMngCd = objFields("STDVALUEMNGCD")
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objCsCd = objFields("CSCD")
        Set objItemName = objFields("ITEMNAME")
        Set objCsName = objFields("CSNAME")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrStdValueMngCd(lngCount)
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrSuffix(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrItemName(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            
            vntArrStdValueMngCd(lngCount) = objStdValueMngCd.Value & ""
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrSuffix(lngCount) = objSuffix.Value & ""
            vntArrStrDate(lngCount) = objStrDate.Value & ""
            vntArrEndDate(lngCount) = objEndDate.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrItemName(lngCount) = objItemName.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntstdValueMngCd = vntArrStdValueMngCd
    vntItemCd = vntArrItemCd
    vntSuffix = vntArrSuffix
    vntStrDate = vntArrStrDate
    vntEndDate = vntArrEndDate
    vntCsCd = vntArrCsCd
    If IsMissing(vntItemName) = False Then vntItemName = vntArrItemName
    If IsMissing(vntCsName) = False Then vntCsName = vntArrCsName
    
    SelectStdValueList = lngCount
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "StdValue.SelectStdValueList"

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
' 機能　　 : 基準値詳細の一覧を取得する
'
' 引数　　 : (In)     strStdValueMngCd  基準値管理コード
' 　　　　 : (Out)    vntstdValueCd     基準値コード
' 　　　　 : (Out)    vntgender         性別
' 　　　　 : (Out)    vntstrAge         開始年齢
' 　　　　 : (Out)    vntendAge         終了年齢
' 　　　　 : (Out)    vntpriorSeq       適用優先順位番号
' 　　　　 : (Out)    vntLowerValue     基準値（以上）
' 　　　　 : (Out)    vntupperValue     基準値（以下）
' 　　　　 : (Out)    vntstdFlg         基準値フラグ
' 　　　　 : (Out)    vntjudCd          判定コード
' 　　　　 : (Out)    vntjudCmtCd       判定コメントコード
' 　　　　 : (Out)    vnthealthPoint    ヘルスポイント
' 　　　　 : (Out)    vntSentence       文章（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 :　文章は数値だろうが、定性だろうが構わずJOIN。こっちの方が断然早い
'
Public Function SelectStdValue_cList(ByVal strStdValueMngCd As String, _
                                     ByRef vntStdValueCd As Variant, _
                                     ByRef vntGender As Variant, _
                                     ByRef vntStrAge As Variant, _
                                     ByRef vntEndAge As Variant, _
                                     ByRef vntPriorSeq As Variant, _
                                     ByRef vntLowerValue As Variant, _
                                     ByRef vntUpperValue As Variant, _
                                     ByRef vntStdFlg As Variant, _
                                     ByRef vntJudCd As Variant, _
                                     ByRef vntJudCmtCd As Variant, _
                                     ByRef vntHealthPoint As Variant, _
                                     Optional ByRef vntSentence As Variant _
                                    ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim objStdValueCd           As OraField         '基準値コード
    Dim objGender               As OraField         '性別
    Dim objStrAge               As OraField         '開始年齢
    Dim objEndAge               As OraField         '終了年齢
    Dim objPriorSeq             As OraField         '適用優先順位番号
    Dim objLowerValue           As OraField         '基準値（以上）
    Dim objUpperValue           As OraField         '基準値（以下）
    Dim objStdFlg               As OraField         '基準値フラグ
    Dim objJudCd                As OraField         '判定コード
    Dim objJudCmtCd             As OraField         '判定コメントコード
    Dim objHealthPoint          As OraField         'ヘルスポイント
    Dim objSentence             As OraField         '文章（略）
    
    Dim vntArrStdValueCd()      As Variant         '基準値コード
    Dim vntArrGender()          As Variant         '性別
    Dim vntArrStrAge()          As Variant         '開始年齢
    Dim vntArrEndAge()          As Variant         '終了年齢
    Dim vntArrPriorSeq()        As Variant         '適用優先順位番号
    Dim vntArrLowerValue()      As Variant         '基準値（以上）
    Dim vntArrUpperValue()      As Variant         '基準値（以下）
    Dim vntArrStdFlg()          As Variant         '基準値フラグ
    Dim vntArrJudCd()           As Variant         '判定コード
    Dim vntArrJudCmtCd()        As Variant         '判定コメントコード
    Dim vntArrHealthPoint()     As Variant         'ヘルスポイント
    Dim vntArrSentence()        As Variant         '文章（略）
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '主キーが設定されていない場合はエラー
    If Trim(strStdValueMngCd) = "" Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '初期処理
    SelectStdValue_cList = 0
    lngCount = 0
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STDVALUEMNGCD", Trim(strStdValueMngCd), ORAPARM_INPUT
    
    '基準値テーブルよりレコードを取得
'    strStmt = "SELECT STDVALUE_C.STDVALUECD, STDVALUE_C.STDVALUEMNGCD, STDVALUE_C.GENDER, STDVALUE_C.STRAGE," & vbLf & _
              "       STDVALUE_C.ENDAGE, STDVALUE_C.PRIORSEQ, STDVALUE_C.LOWERVALUE, STDVALUE_C.UPPERVALUE," & vbLf & _
              "       STDVALUE_C.STDFLG, STDVALUE_C.JUDCD,STDVALUE_C. JUDCMTCD,STDVALUE_C.HEALTHPOINT," & vbLf & _
              "       JUD.JUDSNAME,JUDCMTSTC.JUDCMTSTC" & vbLf & _
              "  FROM JUDCMTSTC, JUD, STDVALUE_C" & vbLf & _
              " WHERE STDVALUE_C.STDVALUEMNGCD = :STDVALUEMNGCD" & vbLf & _
              "   AND STDVALUE_C.JUDCD = JUD.JUDCD(+)" & vbLf & _
              "   AND STDVALUE_C.JUDCMTCD = JUDCMTSTC.JUDCMTCD(+)" & vbLf & _
              " ORDER BY STDVALUE_C.GENDER,STDVALUE_C.PRIORSEQ"
    strStmt = "SELECT NATIVESTDVALUE.STDVALUECD, SENTENCE.SHORTSTC, NATIVESTDVALUE.STDVALUEMNGCD, NATIVESTDVALUE.GENDER, NATIVESTDVALUE.STRAGE," & vbLf & _
              "       NATIVESTDVALUE.ENDAGE, NATIVESTDVALUE.PRIORSEQ, NATIVESTDVALUE.LOWERVALUE, NATIVESTDVALUE.UPPERVALUE," & vbLf & _
              "       NATIVESTDVALUE.STDFLG, NATIVESTDVALUE.JUDCD, NATIVESTDVALUE.JUDCMTCD,NATIVESTDVALUE.HEALTHPOINT," & vbLf & _
              "       NATIVESTDVALUE.JUDSNAME,NATIVESTDVALUE.JUDCMTSTC" & vbLf & _
              "  FROM SENTENCE," & vbLf & _
              "     (" & vbLf & _
              "     SELECT ITEM_C.STCITEMCD ITEMCD, ITEM_C.ITEMTYPE ITEMTYPE, STDVALUE_C.STDVALUECD, " & vbLf & _
              "            STDVALUE_C.STDVALUEMNGCD, STDVALUE_C.GENDER, STDVALUE_C.STRAGE," & vbLf & _
              "            STDVALUE_C.ENDAGE, STDVALUE_C.PRIORSEQ, STDVALUE_C.LOWERVALUE, STDVALUE_C.UPPERVALUE," & vbLf & _
              "            STDVALUE_C.STDFLG, STDVALUE_C.JUDCD,STDVALUE_C. JUDCMTCD,STDVALUE_C.HEALTHPOINT," & vbLf & _
              "            JUD.JUDSNAME,JUDCMTSTC.JUDCMTSTC" & vbLf & _
              "       FROM STDVALUE, ITEM_C," & vbLf & _
              "            JUDCMTSTC, JUD, STDVALUE_C" & vbLf & _
              "      WHERE STDVALUE_C.STDVALUEMNGCD = :STDVALUEMNGCD" & vbLf & _
              "        AND STDVALUE_C.JUDCD = JUD.JUDCD(+)" & vbLf & _
              "        AND STDVALUE_C.JUDCMTCD = JUDCMTSTC.JUDCMTCD(+)" & vbLf & _
              "        AND STDVALUE.STDVALUEMNGCD = STDVALUE_C.STDVALUEMNGCD" & vbLf & _
              "        AND STDVALUE.ITEMCD = ITEM_C.ITEMCD" & vbLf & _
              "        AND STDVALUE.SUFFIX = ITEM_C.SUFFIX" & vbLf & _
              "     ) NATIVESTDVALUE" & vbLf & _
              " WHERE NATIVESTDVALUE.ITEMCD = SENTENCE.ITEMCD(+)" & vbLf & _
              "   AND NATIVESTDVALUE.ITEMTYPE = SENTENCE.ITEMTYPE(+)" & vbLf & _
              "   AND NATIVESTDVALUE.LOWERVALUE = SENTENCE.STCCD(+)" & vbLf & _
              " ORDER BY NATIVESTDVALUE.GENDER,NATIVESTDVALUE.PRIORSEQ"

'### 2003/05/17 Updated by Ishihara@FSIT OmitCharSpc指定追加
'    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
'### 2003/05/17 Updated End
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objStdValueCd = objFields("STDVALUECD")
        Set objGender = objFields("GENDER")
        Set objStrAge = objFields("STRAGE")
        Set objEndAge = objFields("ENDAGE")
        Set objPriorSeq = objFields("PRIORSEQ")
        Set objLowerValue = objFields("LOWERVALUE")
        Set objUpperValue = objFields("UPPERVALUE")
        Set objStdFlg = objFields("STDFLG")
        Set objJudCd = objFields("JUDCD")
        Set objJudCmtCd = objFields("JUDCMTCD")
        Set objHealthPoint = objFields("HEALTHPOINT")
        Set objSentence = objFields("SHORTSTC")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrStdValueCd(lngCount)
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrStrAge(lngCount)
            ReDim Preserve vntArrEndAge(lngCount)
            ReDim Preserve vntArrPriorSeq(lngCount)
            ReDim Preserve vntArrLowerValue(lngCount)
            ReDim Preserve vntArrUpperValue(lngCount)
            ReDim Preserve vntArrStdFlg(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrJudCmtCd(lngCount)
            ReDim Preserve vntArrHealthPoint(lngCount)
            ReDim Preserve vntArrSentence(lngCount)
            
            vntArrStdValueCd(lngCount) = objStdValueCd.Value & ""
            vntArrGender(lngCount) = objGender.Value & ""
            vntArrStrAge(lngCount) = objStrAge.Value & ""
            vntArrEndAge(lngCount) = objEndAge.Value & ""
            vntArrPriorSeq(lngCount) = objPriorSeq.Value & ""
            vntArrLowerValue(lngCount) = objLowerValue.Value & ""
            vntArrUpperValue(lngCount) = objUpperValue.Value & ""
            vntArrStdFlg(lngCount) = objStdFlg.Value & ""
            vntArrJudCd(lngCount) = objJudCd.Value & ""
            vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
            vntArrHealthPoint(lngCount) = objHealthPoint.Value & ""
            vntArrSentence(lngCount) = objSentence.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntStdValueCd = vntArrStdValueCd
    vntGender = vntArrGender
    vntStrAge = vntArrStrAge
    vntEndAge = vntArrEndAge
    vntPriorSeq = vntArrPriorSeq
    vntLowerValue = vntArrLowerValue
    vntUpperValue = vntArrUpperValue
    vntStdFlg = vntArrStdFlg
    vntJudCd = vntArrJudCd
    vntJudCmtCd = vntArrJudCmtCd
    vntHealthPoint = vntArrHealthPoint
    If IsMissing(vntSentence) = False Then vntSentence = vntArrSentence
    
    SelectStdValue_cList = lngCount
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "StdValue.SelectStdValue_cList"

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
' 機能　　 : 基準値テーブルレコードを登録する
'
' 引数　　 : (In)    lngStdValueMngCd   基準値管理コード
' 　　　　   (In)    strItemCd          検査項目コード
' 　　　　   (In)    strSuffix          サフィックス
' 　　　　   (In)    dtmStrDate         使用開始日付
' 　　　　   (In)    dtmEndDate         使用終了日付
' 　　　　   (In)    strCsCd            対象コースコード
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 : 基準値コードが0の場合は新規挿入とする
'
Public Function RegistStdValue(ByRef lngStdValueMngCd As Long, _
                               ByVal strItemCd As String, _
                               ByVal strSuffix As String, _
                               ByVal dtmStrDate As Date, _
                               ByVal dtmEndDate As Date, _
                               ByVal strCsCd As String _
                               ) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objNewNo    As OraField         '基準値管理コード（次発番用）
    
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    Dim strMode     As String
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    Set objOraParam = mobjOraDb.Parameters
    
    '基準値管理コードが０なら新しい番号を取得
    If lngStdValueMngCd = 0 Then
        
        strMode = "INS"
        objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        '基準値管理番号の取得
        strStmt = "SELECT NVL(MAX(STDVALUEMNGCD) + 1,1) NEWNO FROM STDVALUE"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        Set objFields = objOraDyna.Fields
        Set objNewNo = objFields("NEWNO")
        lngStdValueMngCd = objNewNo.Value
    
    Else
        strMode = "UPD"
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
     
    'キー及び更新値の設定
    objOraParam.Add "STDVALUEMNGCD", Trim(lngStdValueMngCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", Trim(dtmStrDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENDDATE", Trim(dtmEndDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '基準値テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE STDVALUE " & _
                      "   SET ITEMCD  = :ITEMCD," & _
                      "       SUFFIX  = :SUFFIX," & _
                      "       STRDATE = :STRDATE," & _
                      "       ENDDATE = :ENDDATE," & _
                      "       CSCD    = :CSCD" & _
                      " WHERE STDVALUEMNGCD = :STDVALUEMNGCD"
'### 2003/05/17 Updated by Ishihara@FSIT OmitCharSpc指定追加
    '        Ret = mobjOraDb.ExecuteSQL(strStmt)
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
'### 2003/05/17 Updated End
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす基準値テーブルのレコードを取得
        strStmt = "SELECT STDVALUEMNGCD FROM STDVALUE WHERE STDVALUEMNGCD = :STDVALUEMNGCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        strStmt = "INSERT INTO STDVALUE ( STDVALUEMNGCD,  ITEMCD, SUFFIX,  STRDATE, ENDDATE, CSCD)" & vbLf & _
                  "              VALUES (:STDVALUEMNGCD, :ITEMCD,:SUFFIX, :STRDATE,:ENDDATE,:CSCD)"
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
    RegistStdValue = Ret

    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "StdValue.RegistStdValue"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistStdValue = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "StdValue.RegistStdValue", Err.Description

End Function

'
' 機能　　 : 基準値テーブル及び基準値詳細テーブルレコードを登録する
' 　　　　 　（トランザクション対応）
'
' 引数　　 : (In/Out)   lngStdValueMngCd   基準値管理コード
' 　　　　   (In)       strItemCd          検査項目コード
' 　　　　   (In)       strSuffix          サフィックス
' 　　　　   (In)       dtmStrDate         使用開始日付
' 　　　　   (In)       dtmEndDate         使用終了日付
' 　　　　   (In)       strCsCd            対象コースコード
'
' 戻り値　 : INSERT_NORMAL      正常終了
' 　　　　   INSERT_DUPLICATE   同一キーのレコード存在
' 　　　　   INSERT_ERROR       異常終了
' 　　　　   INSERT_FKEYERROR   外部キーエラー
'
' 備考　　 :
'
Public Function RegistStdValue_All(ByRef lngStdValueMngCd As Long, _
                                   ByVal strItemCd As String, _
                                   ByVal strSuffix As String, _
                                   ByVal dtmStrDate As Date, _
                                   ByVal dtmEndDate As Date, _
                                   ByVal strCsCd As String, _
                                   ByVal intItemCount As Integer, _
                                   ByVal vntStdValueCd As Variant, _
                                   ByVal vntGender As Variant, _
                                   ByVal vntStrAge As Variant, _
                                   ByVal vntEndAge As Variant, _
                                   ByVal vntPriorSeq As Variant, _
                                   ByVal vntLowerValue As Variant, _
                                   ByVal vntUpperValue As Variant, _
                                   ByVal vntStdFlg As Variant, _
                                   ByVal vntJudCd As Variant, _
                                   ByVal vntJudCmtCd As Variant, _
                                   ByVal vntHealthPoint As Variant) As Long
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim Ret                 As Long             '関数戻り値
    Dim strErrDescription   As String
    
    Ret = INSERT_ERROR
    
    Do
        
        '基準値テーブルの更新
        Ret = RegistStdValue(lngStdValueMngCd, _
                          strItemCd, _
                          strSuffix, _
                          dtmStrDate, _
                          dtmEndDate, _
                          strCsCd)
        
        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
                         
        '基準値詳細テーブルの更新
        Ret = RegistStdValue_c(intItemCount, _
                            lngStdValueMngCd, _
                            vntStdValueCd, _
                            vntGender, _
                            vntStrAge, _
                            vntEndAge, _
                            vntPriorSeq, _
                            vntLowerValue, _
                            vntUpperValue, _
                            vntStdFlg, _
                            vntJudCd, _
                            vntJudCmtCd, _
                            vntHealthPoint)

        '異常終了なら処理終了
        If Ret <> INSERT_NORMAL Then
            Exit Do
        End If
        
'## 2003.12.16 Del By T.Takagi@FSIT 運用に耐えられないのでやめる
''### 2003/05/17 Updated by Ishihara@FSIT 基準値マスタ更新時に、検査結果テーブルの値も更新
'        '検査結果テーブルの基準値情報更新
'        '（引数の基準値設定範囲日付を渡した方が更新範囲は狭くて済むが、参照先の絶対的な整合性を重視）
'        Ret = UpdateAllStdValue(CDate("1970/1/1"), CDate("2200/12/31"), strItemCd, strSuffix)
''### 2003/05/17 Updated End
'## 2003.12.16 Del End
        
        Exit Do
    Loop
 
    '異常終了ならRollBack
    If Ret <> INSERT_NORMAL Then
        mobjContext.SetAbort
        Exit Function
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
 
    '戻り値の設定
    RegistStdValue_All = Ret

    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "StdValue.RegistStdValue_All"
    strErrDescription = Err.Description

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistStdValue_All = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "StdValue.RegistStdValue_All", Err.Description

End Function

'
' 機能　　 : 基準値詳細テーブルレコードを登録する
'
' 引数　　 : (In)    intItemCount       グループ区分（依頼 or 検査）
' 　　　　   (In)    lngStdValueMngCd   基準値管理コード
' 　　　　   (In)    vntStdValueCd      基準値コード
' 　　　　   (In)    vntGender          性別
' 　　　　   (In)    vntStrAge          開始年齢
' 　　　　   (In)    vntEndAge          終了年齢
' 　　　　   (In)    vntPriorSeq        適用優先順位番号
' 　　　　   (In)    vntLowerValue      基準値（以上）
' 　　　　   (In)    vntUpperValue      基準値（以下）
' 　　　　   (In)    vntStdFlg          基準値フラグ
' 　　　　   (In)    vntJudCd           判定コード
' 　　　　   (In)    vntJudCmtCd        判定コメントコード
' 　　　　   (In)    vntHealthPoint     ヘルスポイント
'
' 戻り値　 : INSERT_NORMAL      正常終了
' 　　　　   INSERT_ERROR       異常終了
'
' 備考　　 :
'
Public Function RegistStdValue_c(ByVal intItemCount As Integer, _
                                 ByVal lngStdValueMngCd As Long, _
                                 ByVal vntStdValueCd As Variant, _
                                 ByVal vntGender As Variant, _
                                 ByVal vntStrAge As Variant, _
                                 ByVal vntEndAge As Variant, _
                                 ByVal vntPriorSeq As Variant, _
                                 ByVal vntLowerValue As Variant, _
                                 ByVal vntUpperValue As Variant, _
                                 ByVal vntStdFlg As Variant, _
                                 ByVal vntJudCd As Variant, _
                                 ByVal vntJudCmtCd As Variant, _
                                 ByVal vntHealthPoint As Variant) As Long
                               
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objNewNo            As OraField         '基準値管理コード（次発番用）
    Dim strStmt             As String           'SQLステートメント

    Dim objStdValueMngCd    As OraParamArray    '基準値管理コード
    Dim objStdValueCd       As OraParamArray    '基準値コード
    Dim objGender           As OraParamArray    '性別
    Dim objStrAge           As OraParamArray    '開始年齢
    Dim objEndAge           As OraParamArray    '終了年齢
    Dim objPriorSeq         As OraParamArray    '適用優先順位番号
    Dim objLowerValue       As OraParamArray    '基準値（以上）
    Dim objUpperValue       As OraParamArray    '基準値（以下）
    Dim objStdFlg           As OraParamArray    '基準値フラグ
    Dim objJudCd            As OraParamArray    '判定コード
    Dim objJudCmtCd         As OraParamArray    '判定コメントコード
    Dim objHealthPoint      As OraParamArray    'ヘルスポイント

    Dim i                   As Integer
    Dim Ret                 As Long             '関数戻り値
    Dim lngNewNo            As Long             '基準値コード（次に発番する最大値）
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR

    '基準値コード最大値の取得
    strStmt = "SELECT NVL(MAX(stdValueCd) + 1,1) NEWNO FROM STDVALUE_C"
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    Set objFields = objOraDyna.Fields
    Set objNewNo = objFields("NEWNO")
    lngNewNo = objNewNo.Value
    
    '対象基準値詳細レコードの削除
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STDVALUEMNGCD", Trim(lngStdValueMngCd), ORAPARM_INPUT, ORATYPE_NUMBER
    mobjOraDb.ExecuteSQL "DELETE STDVALUE_C WHERE STDVALUEMNGCD = :STDVALUEMNGCD"
    objOraParam.Remove "STDVALUEMNGCD"

    'セットデータのチェック
    For i = 0 To intItemCount - 1
        
        '基準値コード未セット（新規）データの検索
        If (vntStdValueCd(i) = "") Or (vntStdValueCd(i) = "0") Then
            '現在の基準値番号の最大値をセット（その後インクリメント）
            vntStdValueCd(i) = lngNewNo
            lngNewNo = lngNewNo + 1
        End If
        
        '万が一年齢がセットされていない場合は、勝手にセットする（下）～両方セットされてないならOracleでBOMB
        If (vntStrAge(i) = "") And (vntEndAge(i) <> "") Then
            vntStrAge(i) = vntEndAge(i)
        End If
        
        '万が一年齢がセットされていない場合は、勝手にセットする（上）～両方セットされてないならOracleでBOMB
        If (vntStrAge(i) <> "") And (vntEndAge(i) = "") Then
            vntEndAge(i) = vntStrAge(i)
        End If
        
        '万が一基準値がセットされていない場合は、勝手にセットする（下）～両方セットされてないならOracleでBOMB
        If (vntLowerValue(i) = "") And (vntUpperValue(i) <> "") Then
            vntLowerValue(i) = vntUpperValue(i)
        End If
        
        '万が一基準値がセットされていない場合は、勝手にセットする（上）～両方セットされてないならOracleでBOMB
        If (vntLowerValue(i) <> "") And (vntUpperValue(i) = "") Then
            vntUpperValue(i) = vntLowerValue(i)
        End If
    
    Next i

    If intItemCount > 0 Then

        'キー及び更新値の設定再割り当て
        objOraParam.AddTable "STDVALUECD", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "STDVALUEMNGCD", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "GENDER", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "STRAGE", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "ENDAGE", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "PRIORSEQ", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount
        objOraParam.AddTable "LOWERVALUE", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_RSL_RESULT
        objOraParam.AddTable "UPPERVALUE", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_RSL_RESULT
        objOraParam.AddTable "STDFLG", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_STDVALUE_C_STDFLG
        objOraParam.AddTable "JUDCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_JUD_JUDCD
        objOraParam.AddTable "JUDCMTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, LENGTH_JUDCMTSTC_JUDCMTCD
        objOraParam.AddTable "HEALTHPOINT", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount

        'OraParameterオブジェクトの参照設定
        Set objStdValueMngCd = objOraParam("STDVALUEMNGCD")
        Set objStdValueCd = objOraParam("STDVALUECD")
        Set objGender = objOraParam("GENDER")
        Set objStrAge = objOraParam("STRAGE")
        Set objEndAge = objOraParam("ENDAGE")
        Set objPriorSeq = objOraParam("PRIORSEQ")
        Set objLowerValue = objOraParam("LOWERVALUE")
        Set objUpperValue = objOraParam("UPPERVALUE")
        Set objStdFlg = objOraParam("STDFLG")
        Set objJudCd = objOraParam("JUDCD")
        Set objJudCmtCd = objOraParam("JUDCMTCD")
        Set objHealthPoint = objOraParam("HEALTHPOINT")

        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objStdValueMngCd(i) = lngStdValueMngCd
            objStdValueCd(i) = vntStdValueCd(i)
            objGender(i) = vntGender(i)
            objStrAge(i) = vntStrAge(i)
            objEndAge(i) = vntEndAge(i)
            objPriorSeq(i) = vntPriorSeq(i)
            objLowerValue(i) = vntLowerValue(i)
            objUpperValue(i) = vntUpperValue(i)
            objStdFlg(i) = vntStdFlg(i)
            objJudCd(i) = vntJudCd(i)
            objJudCmtCd(i) = vntJudCmtCd(i)
            objHealthPoint(i) = vntHealthPoint(i)
        Next i

        '新規挿入
        strStmt = "INSERT INTO STDVALUE_C ( STDVALUECD, STDVALUEMNGCD, GENDER, STRAGE, ENDAGE, PRIORSEQ, LOWERVALUE, UPPERVALUE, STDFLG, JUDCD, JUDCMTCD, HEALTHPOINT)" & _
                  "                VALUES (:STDVALUECD,:STDVALUEMNGCD,:GENDER,:STRAGE,:ENDAGE,:PRIORSEQ,:LOWERVALUE,:UPPERVALUE,:STDFLG,:JUDCD,:JUDCMTCD,:HEALTHPOINT)"

        mobjOraDb.ExecuteSQL strStmt
        Ret = INSERT_NORMAL
    
    Else
        '0件ならそのまま終了
        Ret = INSERT_NORMAL
    End If

    'トランザクションをコミット
    mobjContext.SetComplete

    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistStdValue_c = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "StdValue.RegistStdValue_c"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistStdValue_c = INSERT_ERROR
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Grp.RegistStdValue_c", Err.Description
                               
End Function

'
' 機能　　 : 検査項目の基準値情報を取得する
'
' 引数　　 : (In)   strItemCd           検査項目コード
' 　　　　 : (In)   strSuffix           サフィックス
' 　　　　 : (In)   strCsCd             コースコード
' 　　　　 : (In)   strCslDateYear      受診日（年）
' 　　　　 : (In)   strCslDateMonth     受診日（月）
' 　　　　 : (In)   strCslDateDay       受診日（日）
' 　　　　 : (In)   strAge              年齢
' 　　　　 : (In)   strGender           性別
' 　　　　 : (Out)  vntHistoryCount     該当検査項目・コースの基準値履歴レコード件数
' 　　　　 : (Out)  vntAgeFlg           該当受診日の基準値履歴の年齢管理有無（0:無,1:有）
' 　　　　 : (Out)  vntGenderFlg        該当受診日の基準値履歴の性別管理有無（0:無,1:有）
' 　　　　 : (Out)  vntCsCd             コースコード（配列）
' 　　　　 : (Out)  vntCsName           コース名（配列）
' 　　　　 : (Out)  vntGender           性別（配列）名称変換済み
' 　　　　 : (Out)  vntStrAge           開始年齢（配列）
' 　　　　 : (Out)  vntEndAge           終了年齢（配列）
' 　　　　 : (Out)  vntLowerValue       下限値（配列）
' 　　　　 : (Out)  vntUpperValue       上限値（配列）(文章タイプの場合下限・上限値は等しいのでここに所見文章を設定する)
' 　　　　 : (Out)  vntStdFlg           基準値フラグ（配列）
' 　　　　 : (Out)  vntStdFlgColor      基準値フラグ表示色（配列）
' 　　　　 : (Out)  vntJudCd            判定コード（配列）
' 　　　　 : (Out)  vntHealthPoint      ヘルスポイント（配列）
'
' 戻り値　 : 該当受診日・年齢・性別の基準値情報コース・性別件数（コースコード～ヘルスポイントの配列の数）
'
' 備考　　 :
'
Public Function SelectItemStdValue(ByVal strItemCd As String, _
                                   ByVal strSuffix As String, _
                                   ByVal strCsCd As String, _
                                   ByVal strCslDateYear As String, _
                                   ByVal strCslDateMonth As String, _
                                   ByVal strCslDateDay As String, _
                                   ByVal strAge As String, _
                                   ByVal strGender As String, _
                                   ByRef vntHistoryCount As Variant, _
                                   ByRef vntAgeFlg As Variant, _
                                   ByRef vntGenderFlg As Variant, _
                                   ByRef vntCsCd As Variant, _
                                   ByRef vntCsName As Variant, _
                                   ByRef vntGender As Variant, _
                                   ByRef vntStrAge As Variant, _
                                   ByRef vntEndAge As Variant, _
                                   ByRef vntLowerValue As Variant, _
                                   ByRef vntUpperValue As Variant, _
                                   ByRef vntStdFlg As Variant, _
                                   ByRef vntStdFlgColor As Variant, _
                                   ByRef vntJudCd As Variant, _
                                   ByRef vntHealthPoint As Variant _
                                  ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objHistoryCount         As OraField         '該当検査項目・コースの基準値履歴レコード件数
    Dim objNullFlg              As OraField         'コースコードのNullの有無
    Dim objAgeFlg               As OraField         '該当受診日の基準値履歴の年齢管理有無（0:無,1:有）
    Dim objGenderFlg            As OraField         '該当受診日の基準値履歴の性別管理有無（0:無,1:有）
    Dim objCsCd                 As OraField         'コースコード
    Dim objCsName               As OraField         'コース名
    Dim objGender               As OraField         '性別
    Dim objStrAge               As OraField         '開始年齢
    Dim objEndAge               As OraField         '終了年齢
    Dim objLowerValue           As OraField         '下限値
    Dim objUpperValue           As OraField         '上限値
    Dim objStdFlg               As OraField         '基準値フラグ
    Dim objJudCd                As OraField         '判定コード
    Dim objHealthPoint          As OraField         'ヘルスポイント
    
    Dim objCommon               As Common           '共通クラス
    
    Dim vntNullFlg              As Variant          'コースコードのNullの有無
    
    Dim vntArrCsCd()            As Variant          'コースコードの配列
    Dim vntArrCsName()          As Variant          'コース名の配列
    Dim vntArrGender()          As Variant          '性別の配列
    Dim vntArrStrAge()          As Variant          '開始年齢の配列
    Dim vntArrEndAge()          As Variant          '終了年齢の配列
    Dim vntArrLowerValue()      As Variant          '下限値の配列
    Dim vntArrUpperValue()      As Variant          '上限値の配列
    Dim vntArrStdFlg()          As Variant          '基準値フラグの配列
    Dim vntArrStdFlgColor()     As Variant          '基準値フラグ表示色の配列
    Dim vntArrJudCd()           As Variant          '判定コードの配列
    Dim vntArrHealthPoint()     As Variant          'ヘルスポイントの配列
    
    Dim strDate                 As String           '日付編集用
    Dim strStdFlgColor          As String           '基準値フラグ表示色編集用
    Dim lngCount                As Long             'レコード数
    Dim i, j                    As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntHistoryCount = CLng(0)
    vntAgeFlg = CLng(0)
    vntGenderFlg = CLng(0)
    vntCsCd = Empty
    vntCsName = Empty
    vntGender = Empty
    vntStrAge = Empty
    vntEndAge = Empty
    vntLowerValue = Empty
    vntUpperValue = Empty
    vntStdFlg = Empty
    vntStdFlgColor = Empty
    vntJudCd = Empty
    vntHealthPoint = Empty
    SelectItemStdValue = 0
    lngCount = 0
    
    '検索条件が設定されていない場合はエラー
    If Trim(strItemCd) = "" Or Trim(strSuffix) = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    strDate = Trim(strCslDateYear) & "/" & Trim(strCslDateMonth) & "/" & Trim(strCslDateDay)
    If Not IsDate(strDate) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If strAge <> "" Then
        If Not IsNumeric(strAge) Then
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        Else
            If CLng(strAge) < AGE_MINVALUE Or CLng(strAge) > AGE_MAXVALUE Then
                Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
                Exit Function
            End If
        End If
    End If
    If strGender <> "" Then
        If Not IsNumeric(strGender) Then
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        Else
            If CLng(strGender) <> GENDER_MALE And CLng(strGender) <> GENDER_FEMALE Then
                Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
                Exit Function
            End If
        End If
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ITEMCD", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUFFIX", Trim(strSuffix), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLDATE", strDate, ORAPARM_INPUT, ORATYPE_DATE
    If strAge <> "" Then
        objOraParam.Add "AGE", CDbl(strAge), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "AGE_MIN", AGE_MINVALUE, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AGE_MAX", AGE_MAXVALUE, ORAPARM_INPUT, ORATYPE_NUMBER
    If strGender <> "" Then
        objOraParam.Add "GENDER", CLng(strGender), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "GENDER_M", GENDER_MALE, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "GENDER_F", GENDER_FEMALE, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'コースコード、年齢，性別指定時は履歴数、履歴管理の有無を取得
    If strCsCd <> "" And strAge <> "" And strGender <> "" Then
    
        '該当検査項目・コースの基準値履歴レコード件数を取得
        strStmt = ""
        strStmt = strStmt & _
                  "SELECT DECODE(cs.HISTORYCOUNT,0,nocs.HISTORYCOUNT,cs.HISTORYCOUNT) HISTORYCOUNT, " & vbLf & _
                  "       DECODE(cs.HISTORYCOUNT,0,'1','0') NULLFLG                                 " & vbLf & _
                  "  FROM (SELECT COUNT(*) HISTORYCOUNT                                             " & vbLf & _
                  "          FROM STDVALUE sv                                                       " & vbLf & _
                  "         WHERE sv.ITEMCD = :ITEMCD                                               " & vbLf & _
                  "           AND sv.SUFFIX = :SUFFIX                                               " & vbLf & _
                  "           AND sv.CSCD   = :CSCD) cs,                                            " & vbLf & _
                  "       (SELECT COUNT(*) HISTORYCOUNT                                             " & vbLf & _
                  "          FROM STDVALUE sv1                                                      " & vbLf & _
                  "         WHERE sv1.ITEMCD = :ITEMCD                                              " & vbLf & _
                  "           AND sv1.SUFFIX = :SUFFIX                                              " & vbLf & _
                  "           AND sv1.CSCD IS NULL) nocs                                            "
        
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

        '検索レコードが存在する場合
        '(COUNT関数を発行しているので必ず1レコード返ってくる)
        If Not objOraDyna.EOF Then
        
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objHistoryCount = objFields("HISTORYCOUNT")
            Set objNullFlg = objFields("NULLFLG")
            '戻り値の設定
            vntHistoryCount = CLng(objHistoryCount.Value & "")
            'NULLフラグの設定
            vntNullFlg = CLng(objNullFlg.Value & "")
        
        End If
        
        Set objOraDyna = Nothing
        
        '該当受診日の基準値履歴の年齢管理有無を取得
        strStmt = ""
        strStmt = strStmt & _
                  "SELECT COUNT(*) AGEFLG                     " & vbLf & _
                  "  FROM STDVALUE sv, STDVALUE_C vc          " & vbLf & _
                  " WHERE sv.ITEMCD   = :ITEMCD               " & vbLf & _
                  "   AND sv.SUFFIX   = :SUFFIX               "
        If vntNullFlg = 0 Then
            'コースコードが指定されている時
            strStmt = strStmt & _
                  "   AND sv.CSCD     = :CSCD                 "
        Else
            'コースコードが指定されていない時
            strStmt = strStmt & _
                  "   AND sv.CSCD     IS NULL                 "
        End If
        strStmt = strStmt & _
                  "   AND sv.STRDATE <= :CSLDATE              " & vbLf & _
                  "   AND sv.ENDDATE >= :CSLDATE              " & vbLf & _
                  "   AND sv.STDVALUEMNGCD = vc.STDVALUEMNGCD " & vbLf & _
                  "   AND NOT (vc.STRAGE = :AGE_MIN AND vc.ENDAGE = :AGE_MAX) "
    
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
        '検索レコードが存在する場合
        '(COUNT関数を発行しているので必ず1レコード返ってくる)
        If Not objOraDyna.EOF Then
        
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objAgeFlg = objFields("AGEFLG")
        
            '戻り値の設定
            If objAgeFlg.Value = 0 Then
                vntAgeFlg = CLng(0)
            Else
                vntAgeFlg = CLng(1)
            End If
        
        End If
        
        Set objOraDyna = Nothing
        
        '該当受診日の基準値履歴の性別管理有無を取得
        strStmt = ""
        strStmt = strStmt & _
                  "SELECT COUNT(*) GENDERFLG                           " & vbLf & _
                  "  FROM STDVALUE sv, STDVALUE_C vc                   " & vbLf & _
                  " WHERE sv.ITEMCD   = :ITEMCD                        " & vbLf & _
                  "   AND sv.SUFFIX   = :SUFFIX                        "
        If vntNullFlg = 0 Then
            'コースコードが指定されている時
            strStmt = strStmt & _
                  "   AND sv.CSCD     = :CSCD                          "
        Else
            'コースコードが指定されていない時
            strStmt = strStmt & _
                  "   AND sv.CSCD     IS NULL                          "
        End If
        strStmt = strStmt & _
                  "   AND sv.STRDATE <= :CSLDATE                       " & vbLf & _
                  "   AND sv.ENDDATE >= :CSLDATE                       " & vbLf & _
                  "   AND sv.STDVALUEMNGCD = vc.STDVALUEMNGCD          " & vbLf & _
                  "   AND vc.GENDER   = :GENDER_M                      " & vbLf & _
                  "   AND NOT EXISTS (                                 " & vbLf & _
                  "       SELECT vc2.STDVALUECD                        " & vbLf & _
                  "         FROM STDVALUE sv2, STDVALUE_C vc2          " & vbLf & _
                  "        WHERE sv2.ITEMCD   = :ITEMCD                " & vbLf & _
                  "          AND sv2.SUFFIX   = :SUFFIX                "
        If vntNullFlg = 0 Then
            'コースコードが指定されている時
            strStmt = strStmt & _
                  "          AND sv2.CSCD     = :CSCD                  "
        Else
            'コースコードが指定されていない時
            strStmt = strStmt & _
                  "          AND sv2.CSCD     IS NULL                  "
        End If
        strStmt = strStmt & _
                  "          AND sv2.STRDATE <= :CSLDATE               " & vbLf & _
                  "          AND sv2.ENDDATE >= :CSLDATE               " & vbLf & _
                  "          AND sv2.STDVALUEMNGCD = vc2.STDVALUEMNGCD " & vbLf & _
                  "          AND vc2.GENDER   = :GENDER_F              " & vbLf & _
                  "          AND vc2.STRAGE = vc.STRAGE                " & vbLf & _
                  "          AND vc2.ENDAGE = vc.ENDAGE                " & vbLf & _
                  "          AND NVL(RTRIM(vc2.LOWERVALUE), ' ') = NVL(RTRIM(vc.LOWERVALUE), ' ') " & vbLf & _
                  "          AND NVL(RTRIM(vc2.UPPERVALUE), ' ') = NVL(RTRIM(vc.UPPERVALUE), ' ') " & vbLf & _
                  "       　　　　　　)                                 "
        
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
        '検索レコードが存在する場合
        '(COUNT関数を発行しているので必ず1レコード返ってくる)
        If Not objOraDyna.EOF Then
        
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objGenderFlg = objFields("GENDERFLG")
        
            '戻り値の設定
            If objGenderFlg.Value = 0 Then
                vntGenderFlg = CLng(0)
            Else
                vntGenderFlg = CLng(1)
            End If
        
        End If
        
        Set objOraDyna = Nothing
    
    End If
    
    '該当受診日・年齢・性別の基準値情報を取得
'## 2002.04.18 Mod 106Lines by T.Takagi@FSIT 文章も読み込むよう修正
'    strStmt = "SELECT STDVALUE.CSCD, COURSE_P.CSNAME,                                       " & vbLf & _
'              "       DECODE(STDVALUE_C.GENDER, '1', '男性', '2', '女性', NULL) GENDERNAME, " & vbLf & _
'              "       STDVALUE_C.STRAGE,     STDVALUE_C.ENDAGE, STDVALUE_C.LOWERVALUE,      " & vbLf & _
'              "       STDVALUE_C.UPPERVALUE, STDVALUE_C.STDFLG, STDVALUE_C.JUDCD,           " & vbLf & _
'              "       STDVALUE_C.HEALTHPOINT                                                " & vbLf & _
'              "  FROM STDVALUE, STDVALUE_C, COURSE_P                                        " & vbLf & _
'              " WHERE STDVALUE.ITEMCD         = :ITEMCD                                     " & vbLf & _
'              "   AND STDVALUE.SUFFIX         = :SUFFIX                                     "
'
'    'コースコード指定時(インデックスの配列要素数は1)
'    If Trim(strCsCd) <> "" Then
'
'        'コースコードが指定されている時
'        If vntNullFlg = 0 Then
'            strStmt = strStmt & vbLf & _
'              "   AND STDVALUE.CSCD           = :CSCD "
'
'        'コースコードが指定されていない時
'        Else
'            strStmt = strStmt & vbLf & _
'              "   AND STDVALUE.CSCD          IS NULL "
'        End If
'
'    End If
'
'    strStmt = strStmt & vbLf & _
'              "   AND STDVALUE.CSCD           = COURSE_P.CSCD(+)         " & vbLf & _
'              "   AND STDVALUE.STRDATE       <= :CSLDATE                 " & vbLf & _
'              "   AND STDVALUE.ENDDATE       >= :CSLDATE                 " & vbLf & _
'              "   AND STDVALUE.STDVALUEMNGCD  = STDVALUE_C.STDVALUEMNGCD "
'
'    '性別指定時
'    If strGender <> "" Then
'        strStmt = strStmt & vbLf & _
'              "   AND STDVALUE_C.GENDER       = :GENDER "
'    End If
'
'    '年齢指定時
'    If strAge <> "" Then
'        strStmt = strStmt & vbLf & _
'              "   AND STDVALUE_C.STRAGE      <= :AGE " & vbLf & _
'              "   AND STDVALUE_C.ENDAGE      >= :AGE "
'    End If
'
'    strStmt = strStmt & vbLf & _
'              " ORDER BY CSCD, STDVALUE_C.GENDER, STDVALUE_C.STRAGE, STDVALUE_C.ENDAGE, STDVALUE_C.PRIORSEQ "
    strStmt = "SELECT STDINFO.CSCD, STDINFO.CSNAME, STDINFO.GENDERNAME, STDINFO.STRAGE, STDINFO.ENDAGE, " & vbLf & _
              "       STDINFO.LOWERVALUE,                                                               " & vbLf & _
              "       NVL(SENTENCE.SHORTSTC, STDINFO.UPPERVALUE) UPPERVALUE,                            " & vbLf & _
              "       STDINFO.STDFLG, STDINFO.JUDCD, STDINFO.HEALTHPOINT                                " & vbLf & _
              "  FROM SENTENCE,                                                                         " & vbLf & _
              "       ( SELECT STDVALUE.CSCD, COURSE_P.CSNAME,                                          " & vbLf & _
              "                DECODE(STDVALUE_C.GENDER, '1', '男性', '2', '女性', NULL) GENDERNAME,    " & vbLf & _
              "                STDVALUE_C.STRAGE,     STDVALUE_C.ENDAGE, STDVALUE_C.LOWERVALUE,         " & vbLf & _
              "                STDVALUE_C.UPPERVALUE, STDVALUE_C.STDFLG, STDVALUE_C.JUDCD,              " & vbLf & _
              "                STDVALUE_C.HEALTHPOINT,                                                  " & vbLf & _
              "                ITEM_C.STCITEMCD, ITEM_C.ITEMTYPE                                        " & vbLf & _
              "           FROM ITEM_C, STDVALUE, STDVALUE_C, COURSE_P                                   " & vbLf & _
              "          WHERE STDVALUE.ITEMCD         = :ITEMCD                                        " & vbLf & _
              "            AND STDVALUE.SUFFIX         = :SUFFIX                                        "

    'コースコード指定時(インデックスの配列要素数は1)
    If Trim(strCsCd) <> "" Then
    
        'コースコードが指定されている時
        If vntNullFlg = 0 Then
            strStmt = strStmt & vbLf & _
              "            AND STDVALUE.CSCD           = :CSCD "
        
        'コースコードが指定されていない時
        Else
            strStmt = strStmt & vbLf & _
              "            AND STDVALUE.CSCD          IS NULL "
        End If
    
    End If

    strStmt = strStmt & vbLf & _
              "            AND STDVALUE.CSCD           = COURSE_P.CSCD(+)         " & vbLf & _
              "            AND STDVALUE.STRDATE       <= :CSLDATE                 " & vbLf & _
              "            AND STDVALUE.ENDDATE       >= :CSLDATE                 " & vbLf & _
              "            AND STDVALUE.STDVALUEMNGCD  = STDVALUE_C.STDVALUEMNGCD "

    '性別指定時
    If strGender <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND STDVALUE_C.GENDER       = :GENDER "
    End If
              
    '年齢指定時
    If strAge <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND STDVALUE_C.STRAGE      <= :AGE " & vbLf & _
              "            AND STDVALUE_C.ENDAGE      >= :AGE "
    End If
              
    strStmt = strStmt & vbLf & _
              "            AND STDVALUE.ITEMCD         = ITEM_C.ITEMCD   " & vbLf & _
              "            AND STDVALUE.SUFFIX         = ITEM_C.SUFFIX   " & vbLf & _
              "          ORDER BY STDVALUE.CSCD,      STDVALUE_C.GENDER, " & vbLf & _
              "                   STDVALUE_C.STRAGE,  STDVALUE_C.ENDAGE, " & vbLf & _
              "                   STDVALUE_C.PRIORSEQ                    " & vbLf & _
              "       ) STDINFO                                          " & vbLf & _
              " WHERE STDINFO.STCITEMCD  = SENTENCE.ITEMCD(+)            " & vbLf & _
              "   AND STDINFO.ITEMTYPE   = SENTENCE.ITEMTYPE(+)          " & vbLf & _
              "   AND STDINFO.LOWERVALUE = SENTENCE.STCCD(+)             "
'## 2002.04.18 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        '共通クラスのインスタンス作成
        Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objGender = objFields("GENDERNAME")
        Set objStrAge = objFields("STRAGE")
        Set objEndAge = objFields("ENDAGE")
        Set objLowerValue = objFields("LOWERVALUE")
        Set objUpperValue = objFields("UPPERVALUE")
        Set objStdFlg = objFields("STDFLG")
        Set objJudCd = objFields("JUDCD")
        Set objHealthPoint = objFields("HEALTHPOINT")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrStrAge(lngCount)
            ReDim Preserve vntArrEndAge(lngCount)
            ReDim Preserve vntArrLowerValue(lngCount)
            ReDim Preserve vntArrUpperValue(lngCount)
            ReDim Preserve vntArrStdFlg(lngCount)
            ReDim Preserve vntArrStdFlgColor(lngCount)
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrHealthPoint(lngCount)
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrGender(lngCount) = objGender.Value & ""
            vntArrStrAge(lngCount) = objStrAge.Value & ""
            vntArrEndAge(lngCount) = objEndAge.Value & ""
            vntArrLowerValue(lngCount) = objLowerValue.Value & ""
            vntArrUpperValue(lngCount) = objUpperValue.Value & ""
            vntArrStdFlg(lngCount) = objStdFlg.Value & ""
            objCommon.SelectStdFlgColor RTrim(vntArrStdFlg(lngCount)) & "_COLOR", strStdFlgColor
            vntArrStdFlgColor(lngCount) = strStdFlgColor & ""
            vntArrJudCd(lngCount) = objJudCd.Value & ""
            vntArrHealthPoint(lngCount) = objHealthPoint.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        Set objCommon = Nothing
    
    End If
    
    '戻り値の設定
    vntCsCd = vntArrCsCd
    vntCsName = vntArrCsName
    vntGender = vntArrGender
    vntStrAge = vntArrStrAge
    vntEndAge = vntArrEndAge
    vntLowerValue = vntArrLowerValue
    vntUpperValue = vntArrUpperValue
    vntStdFlg = vntArrStdFlg
    vntStdFlgColor = vntArrStdFlgColor
    vntJudCd = vntArrJudCd
    vntHealthPoint = vntArrHealthPoint
    SelectItemStdValue = lngCount
    
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
    
    'イベントログ書き込み
    WriteErrorLog "StdValue.SelectItemStdValue"

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
' 機能　　 : 基準値テーブルレコードを削除する
'
' 引数　　 : (In)   lngStdValueMngCd    基準値コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteStdValue(ByVal lngStdValueMngCd As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STDVALUEMNGCD", Trim(lngStdValueMngCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '基準値テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE STDVALUE WHERE STDVALUEMNGCD = :STDVALUEMNGCD"
    
    'バインド変数の削除
    objOraParam.Remove "STDVALUEMNGCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteStdValue = True

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "StdValue.DeleteStdValue"

    DeleteStdValue = False

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "StdValue.DeleteStdValue", Err.Description

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
