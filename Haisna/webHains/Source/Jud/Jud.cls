VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Jud"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'========================================
'管理番号：SL-HS-Y0101-001
'事象番号：COMP-LUKES-0018（非互換検証）
'修正日  ：2010.07.16
'担当者  ：FJTH)KOMURO
'修正内容：テーブルレイアウトの同期
'========================================
'========================================
'管理番号：SL-HS-Y0101-001
'事象番号：COMP-LUKES-0019（非互換検証）
'修正日  ：2010.07.16
'担当者  ：FJTH)KOMURO
'修正内容：テーブルレイアウトの同期
'========================================
'========================================
'管理番号：SL-HS-Y0101-001
'事象番号：COMP-LUKES-0020（非互換検証）
'修正日  ：2010.07.16
'担当者  ：FJTH)KOMURO
'修正内容：テーブルレイアウトの同期
'========================================
Option Explicit

Implements ObjectControl

Private mobjContext      As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 最も軽い判定を取得する
'
' 引数　　 : (Out)    vntJudCd   判定コード
' 　　　　 : (Out)    vntWeight  判定用重み
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectJudLightest(ByRef vntJudCd As Variant, ByRef vntWeight As Variant) As Boolean

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudCd                As OraField         '判定コード
    Dim objWeight               As OraField         '判定用重み
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntJudCd = Empty
    vntWeight = Empty
    
    '判定テーブルの全レコードを重み、判定コードの昇順に取得
    strStmt = "SELECT JUDCD, WEIGHT    " & vbLf & _
              "  FROM JUD              " & vbLf & _
              " ORDER BY WEIGHT, JUDCD "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudCd = objFields("JUDCD")
        Set objWeight = objFields("WEIGHT")
    
        '戻り値の設定
        vntJudCd = objJudCd.Value & ""
        vntWeight = CLng("0" & objWeight.Value)
    
        SelectJudLightest = True
        
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Jud.SelectJudLightest"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 判定の一覧を取得する
'
' 引数　　 : (Out)    vntJudCd          判定コード
' 　　　　 : (Out)    vntJudSName       判定略称（省略可）
' 　　　　 : (Out)    vntJudRName       報告書用判定名称（省略可）
' 　　　　 : (Out)    vntWeight         判定用重み（省略可）
' 　　　　 : (Out)    vntGovMngJud      政府管掌用コード（省略可）
' 　　　　 : (Out)    vntGovMngJudName  政府管掌用名称（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectJudList(ByRef vntJudCd As Variant, _
                              Optional ByRef vntJudSName As Variant, _
                              Optional ByRef vntJudRName As Variant, _
                              Optional ByRef vntWeight As Variant, _
                              Optional ByRef vntGovMngJud As Variant, _
                              Optional ByRef vntGovMngJudName As Variant _
                             ) As Long

    Dim objOraDyna              As OraDynaset   'ダイナセット
    Dim strStmt                 As String       'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    Dim objJudCd                As OraField     '判定コード
    Dim objJudSName             As OraField     '略称
    Dim objJudRName             As OraField     '報告書用判定名称
    Dim objWeight               As OraField     '判定用重み
'## 2003.11.23 Del By T.Takagi@FSIT 聖路加不要項目削除
'    Dim objGovMngJud            As OraField     '政府管掌用コード
'    Dim objGovMngJudName        As OraField     '政府管掌用名称
'## 2003.11.23 Del End
    
    Dim vntArrJudCd()           As Variant      '判定コードの配列
    Dim vntArrJudSName()        As Variant      '略称の配列
    Dim vntArrJudRName()        As Variant      '報告書用判定名称の配列
    Dim vntArrWeight()          As Variant      '判定用重みの配列
    Dim vntArrGovMngJud()       As Variant      '政府管掌用コードの配列
    Dim vntArrGovMngJudName()   As Variant      '政府管掌用名称の配列
    
    Dim lngCount                As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件を満たす判定分類テーブルのレコードを取得
'## 2003.11.23 Mod By T.Takagi@FSIT 聖路加不要項目削除
'    strStmt = "SELECT J.JUDCD, J.JUDSNAME, J.JUDRNAME, " & vbLf & _
'              "       J.WEIGHT, J.GOVMNGJUD, J.GOVMNGJUDNAME" & vbLf & _
'              "  FROM JUD J" & vbLf & _
'              " ORDER BY J.JUDCD"
    strStmt = "SELECT J.JUDCD, J.JUDSNAME, J.JUDRNAME, J.WEIGHT " & vbLf & _
              "  FROM JUD J" & vbLf & _
              " ORDER BY J.JUDCD"
'## 2003.11.23 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudCd = objFields("JUDCD")
        Set objJudSName = objFields("JUDSNAME")
        Set objJudRName = objFields("JUDRNAME")
        Set objWeight = objFields("WEIGHT")
'## 2003.11.23 Del By T.Takagi@FSIT 聖路加不要項目削除
'        Set objGovMngJud = objFields("GOVMNGJUD")
'        Set objGovMngJudName = objFields("GOVMNGJUDNAME")
'## 2003.11.23 Del End
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrJudSName(lngCount)
            ReDim Preserve vntArrJudRName(lngCount)
            ReDim Preserve vntArrWeight(lngCount)
            ReDim Preserve vntArrGovMngJud(lngCount)
            ReDim Preserve vntArrGovMngJudName(lngCount)
            
            vntArrJudCd(lngCount) = objJudCd.Value
            vntArrJudSName(lngCount) = objJudSName.Value
            vntArrJudRName(lngCount) = objJudRName.Value
            vntArrWeight(lngCount) = objWeight.Value
'## 2003.11.23 Mod By T.Takagi@FSIT 聖路加不要項目削除
'            vntArrGovMngJud(lngCount) = objGovMngJud.Value & ""
'            vntArrGovMngJudName(lngCount) = objGovMngJudName.Value & ""
            vntArrGovMngJud(lngCount) = ""
            vntArrGovMngJudName(lngCount) = ""
'## 2003.11.23 Mod End
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntJudCd = vntArrJudCd
    
    If IsMissing(vntJudSName) = False Then
        vntJudSName = vntArrJudSName
    End If
    If IsMissing(vntJudRName) = False Then
        vntJudRName = vntArrJudRName
    End If
    If IsMissing(vntWeight) = False Then
        vntWeight = vntArrWeight
    End If
    If IsMissing(vntGovMngJud) = False Then
        vntGovMngJud = vntArrGovMngJud
    End If
    If IsMissing(vntGovMngJudName) = False Then
        vntGovMngJudName = vntArrGovMngJudName
    End If
    
    SelectJudList = lngCount
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Jud.SelectJudList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 判定情報を取得する
'
' 引数　　 : (In)     strJudCd          判定コード
' 　　　　 : (Out)    vntJudSName       判定略称（省略可）
' 　　　　 : (Out)    vntJudRName       報告書用判定名称（省略可）
' 　　　　 : (Out)    vntWeight         判定用重み（省略可）
' 　　　　 : (Out)    vntGovMngJud      政府管掌用コード（省略可）
' 　　　　 : (Out)    vntGovMngJudName  政府管掌用名称（省略可）
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 : 判定略称を省略可とすることで、入力チェックにも対応
'
Public Function SelectJud(ByVal strJudCd As String, _
                          Optional ByRef vntJudSName As Variant, _
                          Optional ByRef vntJudRName As Variant, _
                          Optional ByRef vntWeight As Variant, _
                          Optional ByRef vntGovMngJud As Variant, _
                          Optional ByRef vntGovMngJudName As Variant _
                          ) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objJudSName         As OraField         '略称
    Dim objJudRName         As OraField         '報告書用判定名称
    Dim objWeight           As OraField         '判定用重み
    Dim objGovMngJud        As OraField         '政府管掌用コード
    Dim objGovMngJudName    As OraField         '政府管掌用名称

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCD", Trim(strJudCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす判定テーブルのレコードを取得
'#### 2010.07.16 SL-HS-Y0101-001 MOD START ####　COMP-LUKES-0019（非互換検証）
'    strStmt = "SELECT J.JUDSNAME, J.JUDRNAME, " & vbLf & _
'              "       J.WEIGHT, J.GOVMNGJUD, J.GOVMNGJUDNAME" & vbLf & _
'              "  FROM JUD J" & vbLf & _
'              " WHERE J.JUDCD = :JUDCD"
    strStmt = "SELECT J.JUDSNAME, J.JUDRNAME, J.WEIGHT" & vbLf & _
              "  FROM JUD J" & vbLf & _
              " WHERE J.JUDCD = :JUDCD"
'#### 2010.07.16 SL-HS-Y0101-001 MOD END ####　　COMP-LUKES-0019（非互換検証）
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudSName = objFields("JUDSNAME")
        Set objJudRName = objFields("JUDRNAME")
        Set objWeight = objFields("WEIGHT")
'#### 2010.07.16 SL-HS-Y0101-001 DEL START ####　COMP-LUKES-0019（非互換検証）
'        Set objGovMngJud = objFields("GOVMNGJUD")
'        Set objGovMngJudName = objFields("GOVMNGJUDNAME")
'#### 2010.07.16 SL-HS-Y0101-001 DEL END ####　　COMP-LUKES-0019（非互換検証）

        If Not IsMissing(vntJudSName) Then
            vntJudSName = objJudSName.Value
        End If
        If IsMissing(vntJudRName) = False Then
            vntJudRName = objJudRName.Value
        End If
        If IsMissing(vntWeight) = False Then
            vntWeight = objWeight.Value
        End If
        If IsMissing(vntGovMngJud) = False Then
'#### 2010.07.16 SL-HS-Y0101-001 MOD START ####　COMP-LUKES-0019（非互換検証）
'            vntGovMngJud = objGovMngJud.Value & ""
            vntGovMngJud = ""
'#### 2010.07.16 SL-HS-Y0101-001 MOD END ####　　COMP-LUKES-0019（非互換検証）
        End If
        If IsMissing(vntGovMngJudName) = False Then
'#### 2010.07.16 SL-HS-Y0101-001 MOD START ####　COMP-LUKES-0019（非互換検証）
'            vntGovMngJudName = objGovMngJudName.Value & ""
            vntGovMngJudName = ""
'#### 2010.07.16 SL-HS-Y0101-001 MOD END ####　　COMP-LUKES-0019（非互換検証）
        End If
        
        SelectJud = True
    Else
        If Not IsMissing(vntJudSName) Then
            vntJudSName = ""
        End If
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
    WriteErrorLog "Jud.SelectJud"
    
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
' 機能　　 : 判定テーブルレコードを登録する
'
' 引数　　 : (In)    strMode           登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strJudCd          判定コード
' 　　　　 : (In)    vntJudSName       判定略称
' 　　　　 : (In)    vntJudRName       報告書用判定名称
' 　　　　 : (In)    vntWeight         判定用重み
' 　　　　 : (In)    vntGovMngJud      政府管掌用コード
' 　　　　 : (In)    vntGovMngJudName  政府管掌用名称
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistJud(ByVal strMode As String, _
                          ByVal strJudCd As String, _
                          ByVal strJudSName As String, _
                          ByVal strJudRName As String, _
                          ByVal intWeight As Integer, _
                          ByVal strGovMngJud As String, _
                          ByVal strGovMngJudName As String _
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
    objOraParam.Add "JudCD", Trim(strJudCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JudSName", Trim(strJudSName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JudRName", Trim(strJudRName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "Weight", Trim(intWeight), ORAPARM_INPUT, ORATYPE_NUMBER
'#### 2010.07.16 SL-HS-Y0101-001 DEL START ####　COMP-LUKES-0018（非互換検証）
'    objOraParam.Add "GovMngJud", Trim(strGovMngJud), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "GovMngJudName", Trim(strGovMngJudName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'#### 2010.07.16 SL-HS-Y0101-001 DEL END   ####　COMP-LUKES-0018（非互換検証）

    Do
        '判定テーブルレコードの更新
        If strMode = "UPD" Then
'#### 2010.07.16 SL-HS-Y0101-001 MOD START ####　COMP-LUKES-0020（非互換検証）
'            strStmt = "UPDATE Jud " & _
'                      "   SET JUDSNAME      = :JudSName, " & _
'                      "       JUDRNAME      = :JudRName, " & _
'                      "       WEIGHT        = :Weight, " & _
'                      "       GOVMNGJUD     = :GovMngJud, " & _
'                      "       GOVMNGJUDNAME = :GovMngJudName " & _
'                      " WHERE JUDCD = :JudCD"
            strStmt = "UPDATE Jud " & _
                      "   SET JUDSNAME      = :JudSName, " & _
                      "       JUDRNAME      = :JudRName, " & _
                      "       WEIGHT        = :Weight " & _
                      " WHERE JUDCD = :JudCD"
'#### 2010.07.16 SL-HS-Y0101-001 MOD END   ####　COMP-LUKES-0020（非互換検証）
            
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす判定テーブルのレコードを取得
        strStmt = "SELECT JUDCD FROM JUD WHERE JUDCD = :JudCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'#### 2010.07.16 SL-HS-Y0101-001 MOD START ####　COMP-LUKES-0018（非互換検証）
'        strStmt = "INSERT INTO Jud (JUDCD,  JUDSNAME, JUDRNAME, WEIGHT, GOVMNGJUD, GOVMNGJUDNAME)" & _
'                  "         VALUES (:JudCD, :JudSName, :JudRName, :Weight, :GovmngJud, :GovMngJudName)"
        strStmt = "INSERT INTO Jud (JUDCD,  JUDSNAME, JUDRNAME, WEIGHT)" & _
                  "         VALUES (:JudCD, :JudSName, :JudRName, :Weight)"
'#### 2010.07.16 SL-HS-Y0101-001 MOD END   ####　COMP-LUKES-0018（非互換検証）
        mobjOraDb.ExecuteSQL strStmt
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistJud = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistJud = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Jud.RegistJud"
    
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
' 機能　　 : 判定テーブルレコードを削除する
'
' 引数　　 : (In)   strJudCd    判定コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteJud(ByVal strJudCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JudCD", Trim(strJudCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '判定テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE Jud WHERE JUDCD = :JudCD"
    
    'バインド変数の削除
    objOraParam.Remove "JudCD"
    
    '戻り値の設定
    DeleteJud = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    DeleteJud = False

    'イベントログ書き込み
    WriteErrorLog "Jud.DeleteJud"
    
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
' 機能　　 : 判定略称を取得する
'
' 引数　　 : (In)     strJudCd      判定コード
' 　　　　 : (Out)    vntJudSName   判定略称
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 : 判定略称を省略可とすることで、入力チェックにも対応
'
Public Function SelectJudSName(ByVal strJudCd As String, _
                               Optional ByRef vntJudSName As Variant _
                              ) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objJudSName         As OraField         '略称

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCD", Trim(strJudCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす判定分類テーブルのレコードを取得
    strStmt = "SELECT J.JUDSNAME                                        " & vbLf & _
              "  FROM JUD J                                             " & vbLf & _
              " WHERE J.JUDCD = :JUDCD                                  "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudSName = objFields("JUDSNAME")

        If Not IsMissing(vntJudSName) Then
            vntJudSName = objJudSName.Value
        End If
        
        SelectJudSName = True
    Else
        If Not IsMissing(vntJudSName) Then
            vntJudSName = ""
        End If
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
    WriteErrorLog "Jud.SelectJudSName"
    
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
' 機能　　 : 判定コードおよび判定用重みのリストを取得する
'
' 引数　　 : (Out)    vntJudCd         判定コード
' 　　　　 : (Out)    vntWeight        判定用重み
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectJudWeightList(ByRef vntJudCd As Variant, _
                                    ByRef vntWeight As Variant _
                                   ) As Long

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudCd                As OraField         '判定コード
    Dim objWeight               As OraField         '判定用重み
    
    Dim vntArrJudCd()           As Variant          '判定コード
    Dim vntArrWeight()          As Variant          '判定用重み
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '判定テーブルの全レコードを取得
    strStmt = "SELECT JUDCD,    WEIGHT " & vbLf & _
              "  FROM JUD              " & vbLf & _
              " ORDER BY JUDCD         "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudCd = objFields("JUDCD")
        Set objWeight = objFields("WEIGHT")
    
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            '配列宣言
            ReDim Preserve vntArrJudCd(lngCount)
            ReDim Preserve vntArrWeight(lngCount)
            'データ格納
            vntArrJudCd(lngCount) = objJudCd.Value & ""
            vntArrWeight(lngCount) = CLng(objWeight.Value & "")
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntJudCd = vntArrJudCd
    vntWeight = vntArrWeight
    SelectJudWeightList = lngCount
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Jud.SelectJudWeightList"
    
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
