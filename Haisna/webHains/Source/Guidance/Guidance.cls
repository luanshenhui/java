VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Guidance"
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
' 機能　　 : 指導内容の一覧を取得する
'
' 引数　　 : (In)     strJudClassCd     判定分類コード
' 　　　　 : (Out)    vntGuidanceCd     指導内容コード
' 　　　　 : (Out)    vntGuidanceStc    指導内容
' 　　　　 : (Out)    vntJudClassCd     判定分類コード（省略可）
' 　　　　 : (Out)    vntJudClassName   判定分類名（省略可）
' 　　　　 : (In/Out) vntKey            検索キーの集合（省略可）
' 　　　　 : (In)     lngStartPos       開始位置（省略可）
' 　　　　 : (In)     lngGetCount       取得件数（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectGuidanceList(ByVal strJudClassCd As String, _
                                   ByRef vntGuidanceCd As Variant, _
                                   ByRef vntGuidanceStc As Variant, _
                                   Optional ByRef vntJudClassCd As Variant, _
                                   Optional ByRef vntJudClassName As Variant, _
                                   Optional ByVal vntKey As Variant, _
                                   Optional ByVal vntStartPos As Variant, _
                                   Optional ByVal vntGetCount As Variant _
                                   ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objGuidanceCd           As OraField         '指導内容コード
    Dim objGuidanceStc          As OraField         '指導内容名称
    Dim objJudClassName         As OraField         '判定分類名
    
    Dim vntArrGuidanceCd()      As Variant          '指導内容コードの配列
    Dim vntArrGuidanceStc()     As Variant          '指導内容の配列
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim lngCount                As Long             'レコード数
    Dim blnWhereFlg             As Boolean          'SQL条件文にWHERE句を追加したかどうか
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntGuidanceCd = Empty
    vntGuidanceStc = Empty
    SelectGuidanceList = 0
    lngCount = 0
    blnWhereFlg = False
    
    Set objOraParam = mobjOraDb.Parameters
    
    'キー値の設定
    If IsNumeric(strJudClassCd) = True Then
        objOraParam.Add "JUDCLASSCD", CInt(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    If IsNumeric(vntGetCount) Then
        objOraParam.Add "SEQ_FROM", CLng(vntStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_TO", CLng(vntStartPos + CLng(vntGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '指導内容テーブルよりレコードを取得
    strStmt = "SELECT SEQ, JUDCLASSCD, GUIDANCECD, GUIDANCESTC, JUDCLASSNAME" & vbLf & _
              "  FROM ( SELECT ROWNUM SEQ, GUIDANCE.JUDCLASSCD, GUIDANCE.GUIDANCECD, GUIDANCE.GUIDANCESTC, JUDCLASS.JUDCLASSNAME" & vbLf & _
              "           FROM JUDCLASS, GUIDANCE " & vbLf

    '判定分類の指定がある場合は、条件文追加
    If IsNumeric(strJudClassCd) = True Then
'## 2003.02.13 Mod 4Lines By T.Takagi@FSIT 判定分類指定時、判定分類のないコメントも表示
'        strStmt = strStmt & "  WHERE GUIDANCE.JUDCLASSCD = :JUDCLASSCD " & vbLf & _
'                            "    AND GUIDANCE.JUDCLASSCD = JUDCLASS.JUDCLASSCD " & vbLf
        strStmt = strStmt & "  WHERE (GUIDANCE.JUDCLASSCD = :JUDCLASSCD OR GUIDANCE.JUDCLASSCD IS NULL)" & vbLf & _
                            "    AND GUIDANCE.JUDCLASSCD = JUDCLASS.JUDCLASSCD(+) " & vbLf
'## 2003.02.13 Mod End
    Else
'### 2003.01.17 Updated by Ishihara@FSIT 判定分類はNULLあり
'        strStmt = strStmt & "  WHERE GUIDANCE.JUDCLASSCD = JUDCLASS.JUDCLASSCD " & vbLf
        strStmt = strStmt & "  WHERE GUIDANCE.JUDCLASSCD = JUDCLASS.JUDCLASSCD(+) " & vbLf
'### 2003.01.17 Updated End
    End If
    
    '名称指定がある場合は、条件文追加
    If Not IsMissing(vntKey) Then
        If Not IsEmpty(vntKey) Then
            strStmt = strStmt & vbLf & _
                  "              AND " & CreateConditionForGuidanceList(vntKey)
        End If
    End If
    
    strStmt = strStmt & vbLf & _
              " ORDER BY GUIDANCE.GUIDANCECD )"
    
    'ページングナビゲータ用の指定がある場合
    If IsNumeric(vntGetCount) Then
        strStmt = strStmt & vbLf & _
              " WHERE SEQ BETWEEN :SEQ_FROM AND :SEQ_TO "
        blnWhereFlg = True
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGuidanceCd = objFields("GuidanceCD")
        Set objGuidanceStc = objFields("GuidanceStc")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrGuidanceCd(lngCount)
            ReDim Preserve vntArrGuidanceStc(lngCount)
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrJudClassName(lngCount)
            vntArrGuidanceCd(lngCount) = objGuidanceCd.Value & ""
            vntArrGuidanceStc(lngCount) = objGuidanceStc.Value & ""
            vntArrJudClassCd(lngCount) = objJudClassCd.Value & ""
            vntArrJudClassName(lngCount) = objJudClassName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntGuidanceCd = vntArrGuidanceCd
    vntGuidanceStc = vntArrGuidanceStc
    If IsMissing(vntJudClassCd) = False Then vntJudClassCd = vntArrJudClassCd
    If IsMissing(vntJudClassName) = False Then vntJudClassName = vntArrJudClassName
    
    SelectGuidanceList = lngCount
        
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Guidance.SelectGuidanceList"

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
' 機能　　 : 検索条件を満たす指導文章の件数を取得する
'
' 引数　　 : (In/Out) vntKey  検索キーの集合
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Public Function SelectGuidanceListCount(ByVal strJudClassCd As String, ByRef vntKey As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCount        As OraField         '検索件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    If strJudClassCd <> "" Then
        objOraParam.Add "JUDCLASSCD", CStr(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '指導内容テーブルよりレコードを取得
    strStmt = "SELECT COUNT(GUIDANCECD) " & vbLf & _
              "  FROM GUIDANCE" & vbLf

    '判定分類の指定がある場合は、条件文追加
    If IsNumeric(strJudClassCd) = True Then
'## 2003.02.13 Mod 2Lines By T.Takagi@FSIT 判定分類指定時、判定分類のないコメントも表示
'        strStmt = strStmt & "  WHERE GUIDANCE.JUDCLASSCD = :JUDCLASSCD " & vbLf
        strStmt = strStmt & "  WHERE (GUIDANCE.JUDCLASSCD = :JUDCLASSCD OR GUIDANCE.JUDCLASSCD IS NULL)" & vbLf
'## 2003.02.13 Mod End
    End If
    
    '名称指定がある場合は、条件文追加
    If Not IsMissing(vntKey) Then
        
        If Not IsEmpty(vntKey) Then
            
            '判定分類の指定がない場合は、条件文追加
            If IsNumeric(strJudClassCd) = False Then
                strStmt = strStmt & "  WHERE " & vbLf
            Else
                strStmt = strStmt & "  AND " & vbLf
            End If
            
            strStmt = strStmt & vbLf & _
                  "                   " & CreateConditionForGuidanceList(vntKey)
        End If
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合は件数を戻り値として設定
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        SelectGuidanceListCount = objOraDyna.Fields(0).Value
    End If
    
    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

App.LogEvent strStmt


    'イベントログ書き込み
    WriteErrorLog "Guidance.SelectGuidanceListCount"
    
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
' 機能　　 : 指導文章テーブル検索用条件節作成
'
' 引数　　 : (In/Out) vntKey         検索キーの集合
'
' 戻り値　 : 指導文章テーブル検索用の条件節
'
' 備考　　 : 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
' 　　　　   検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Private Function CreateConditionForGuidanceList(ByRef vntKey As Variant) As String

    Dim objCommon       As Common   '共通クラス
    Dim strStmt         As String   'SQLステートメント
    Dim i               As Long     'インデックス
    
    '引数未設定時は何もしない
    If IsEmpty(vntKey) Then Exit Function
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    '検索キー数分の条件節を追加
    For i = 0 To UBound(vntKey)
              
        '2番目以降の条件節はANDで連結
        If i >= 1 Then
            strStmt = strStmt & " AND "
        End If
        
        '検索キー中の半角カナを全角カナに変換する
        vntKey(i) = objCommon.StrConvKanaWide(vntKey(i))
        
'## 2003.02.13 Mod 7Lines By T.Takagi@FSIT ８文字以内なら、コードも検索する。（コードは前方一致で上等）
'        strStmt = strStmt & "GUIDANCE.GUIDANCESTC LIKE '%" & vntKey(i) & "%'"
        If LenB(Trim(vntKey(i))) <= 8 Then
            strStmt = strStmt & "  ( GUIDANCE.GUIDANCESTC LIKE '%" & vntKey(i) & "%'" & _
                                " OR GUIDANCE.GUIDANCECD  LIKE '" & vntKey(i) & "%' )"
        Else
            strStmt = strStmt & "GUIDANCE.GUIDANCESTC LIKE '%" & vntKey(i) & "%'"
        End If
'## 2003.02.13 Mod End

    Next i
    
    CreateConditionForGuidanceList = strStmt
    
End Function

'
' 機能　　 : 指導内容名称を取得する
'
' 引数　　 : (In)   strGuidanceCd       指導内容コード
' 　　　　 : (Out)  vntGuidanceStc      指導内容名称（省略可）
' 　　　　 : (Out)  vntJudClassCd       判定分類コード
' 　　　　 : (Out)  vntJudClassName     判定分類コード
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 :
'
Public Function SelectGuidance(ByVal strGuidanceCd As String, _
                               Optional ByRef vntGuidanceStc As Variant, _
                               Optional ByRef vntJudClassCd As Variant, _
                               Optional ByRef vntJudClassName As Variant _
                               ) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objGuidanceStc      As OraField         '指導内容コード
    Dim objJudClassCd       As OraField         '判定分類コード
    Dim objJudClassName     As OraField         '判定分類名

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GUIDANCECD", Trim(strGuidanceCd), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす指導内容テーブルのレコードを取得
'### 2003.01.17 Updated by Ishihara@FSIT 判定分類はNULLあり
'    strStmt = "SELECT GUIDANCE.GUIDANCESTC, GUIDANCE.JUDCLASSCD, JUDCLASS.JUDCLASSNAME " & vbLf & _
              "  FROM JUDCLASS, GUIDANCE " & vbLf & _
              " WHERE GUIDANCE.GUIDANCECD = :GUIDANCECD " & vbLf & _
              "   AND JUDCLASS.JUDCLASSCD = GUIDANCE.JUDCLASSCD "
    strStmt = "SELECT GUIDANCE.GUIDANCESTC, GUIDANCE.JUDCLASSCD, JUDCLASS.JUDCLASSNAME " & vbLf & _
              "  FROM JUDCLASS, GUIDANCE " & vbLf & _
              " WHERE GUIDANCE.GUIDANCECD = :GUIDANCECD " & vbLf & _
              "   AND GUIDANCE.JUDCLASSCD = JUDCLASS.JUDCLASSCD(+) "
'### 2003.01.17 Updated End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGuidanceStc = objFields("GUIDANCESTC")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")

        If Not IsMissing(vntGuidanceStc) Then vntGuidanceStc = objGuidanceStc.Value & ""
        If Not IsMissing(vntJudClassCd) Then vntJudClassCd = objJudClassCd.Value & ""
        If Not IsMissing(vntJudClassName) Then vntJudClassName = objJudClassName.Value & ""
        
        SelectGuidance = True
    
    Else
        
        If Not IsMissing(vntGuidanceStc) Then vntGuidanceStc = ""
        If Not IsMissing(vntJudClassCd) Then vntJudClassCd = ""
        If Not IsMissing(vntJudClassName) Then vntJudClassName = ""
    
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
    WriteErrorLog "Guidance.SelectGuidance"

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
' 機能　　 : 指導内容テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strGuidanceCd      指導内容コード
' 　　　　   (In)    strGuidanceStc     指導内容名
' 　　　　   (In)    intJudClassCd      判定分類コード
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'### 2003.01.17 Updated by Ishihara@FSIT 判定分類はNULLあり
Public Function RegistGuidance(ByVal strMode As String, _
                               ByVal strGuidanceCd As String, _
                               ByVal strGuidanceStc As String, _
                               ByVal strJudClassCd As String) As Long
'Public Function RegistGuidance(ByVal strMode As String, _
                               ByVal strGuidanceCd As String, _
                               ByVal strGuidanceStc As String, _
                               ByVal intJudClassCd As Integer) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GUIDANCECD", Trim(strGuidanceCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GUIDANCESTC", Trim(strGuidanceStc), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.01.17 Updated by Ishihara@FSIT 判定分類はNULLあり
'    objOraParam.Add "JUDCLASSCD", Trim(intJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "JUDCLASSCD", Trim(strJudClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.01.17 Updated End

    Do
        '指導内容テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE GUIDANCE " & _
                      "   SET GUIDANCESTC = :GUIDANCESTC, " & _
                      "       JUDCLASSCD  = :JUDCLASSCD" & _
                      " WHERE GUIDANCECD  = :GUIDANCECD"
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす指導内容テーブルのレコードを取得
        strStmt = "SELECT GUIDANCECD FROM GUIDANCE WHERE GUIDANCECD = :GUIDANCECD"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO GUIDANCE (GUIDANCECD, GUIDANCESTC, JUDCLASSCD) VALUES (:GUIDANCECD, :GUIDANCESTC, :JUDCLASSCD)"
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
    RegistGuidance = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Guidance.RegistGuidance"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistGuidance = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Guidance.RegistGuidance", Err.Description

End Function
'
' 機能　　 : 指導内容テーブルレコードを削除する
'
' 引数　　 : (In)    strGuidanceCd   指導内容コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteGuidance(ByVal strGuidanceCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GUIDANCECD", Trim(strGuidanceCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指導内容テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE GUIDANCE WHERE GUIDANCECD = :GUIDANCECD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteGuidance = True

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Guidance.DeleteGuidance"

    DeleteGuidance = False

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Guidance.DeleteGuidance", Err.Description

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
