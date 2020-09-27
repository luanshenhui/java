VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "StdJud"
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
' 機能　　 : 定型所見の一覧を取得する
'
' 引数　　 : (In)     lngJudClassCd     判定分類コード
' 　　　　 : (Out)    vntStdJudCd       定型所見コード
' 　　　　 : (Out)    vntStdJudNote     定型所見名称
' 　　　　 : (Out)    vntJudClassCd     判定分類コード（省略可）
' 　　　　 : (In)     vntSearchCode     検索用コード（省略可）
' 　　　　 : (In)     vntSearchString   検索用文字列（省略可）
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectStdJudList(ByVal lngJudClassCd As Long, _
                                 ByRef vntStdJudCd As Variant, _
                                 ByRef vntStdJudNote As Variant, _
                                 Optional ByRef vntJudClassCd As Variant, _
                                 Optional ByVal vntSearchCode As Variant, _
                                 Optional ByVal vntSearchString As Variant _
                                 ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objJudClassCd       As OraField         '判定分類コード
    Dim objStdJudCd         As OraField         '定型所見コード
    Dim objStdJudNote       As OraField         '定型所見名称
    
    Dim vntArrJudClassCd()  As Variant          '判定分類コードの配列
    Dim vntArrStdJudCd()    As Variant          '定型所見コードの配列
    Dim vntArrStdJudNote()  As Variant          '定型所見名称の配列
    Dim lngCount            As Long             'レコード数
    Dim blnWhereFlg         As Boolean          'SQL条件文にWHERE句を追加したかどうか
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStdJudCd = Empty
    vntStdJudNote = Empty
    SelectStdJudList = 0
    lngCount = 0
    blnWhereFlg = False
    
    '検索条件が設定されていない場合はエラー
'## 判定分類コードの引数チェックはしない（不正なら検索できないだけ）
'## If lngJudClassCd < JUDCLASSCD_MINVALUE Or lngJudClassCd > JUDCLASSCD_MAXVALUE Then
'##     Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
'##     Exit Function
'## End If
    
    'キー値の設定
    If lngJudClassCd > 0 Then
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "JUDCLASSCD", lngJudClassCd, ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '定型所見テーブルよりレコードを取得
    strStmt = "SELECT JUDCLASSCD, STDJUDCD, STDJUDNOTE " & vbLf & _
              "  FROM STDJUD " & vbLf
    
    If lngJudClassCd > 0 Then
        strStmt = strStmt & "  WHERE JUDCLASSCD = :JUDCLASSCD " & vbLf
        blnWhereFlg = True
    End If
    
    '検索用文字列の設定（マスタメンテ用？）
    If IsMissing(vntSearchCode) = False Then
        If Trim(vntSearchCode) <> "" Then
            If blnWhereFlg = True Then
                strStmt = strStmt & "   AND STDJUD.STDJUDCD LIKE '%" & vntSearchCode & "%'" & vbLf
            Else
                strStmt = strStmt & " WHERE STDJUD.STDJUDCD LIKE '%" & vntSearchCode & "%'" & vbLf
                blnWhereFlg = True
            End If
        End If
    End If
                                 
    If IsMissing(vntSearchString) = False Then
        If Trim(vntSearchString) <> "" Then
            If blnWhereFlg = True Then
                strStmt = strStmt & "   AND STDJUD.STDJUDNOTE LIKE '%" & vntSearchString & "%'" & vbLf
            Else
                strStmt = strStmt & " WHERE STDJUD.STDJUDNOTE LIKE '%" & vntSearchString & "%'" & vbLf
            End If
        End If
    End If
    
    strStmt = strStmt & vbLf & _
              " ORDER BY STDJUDCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objStdJudCd = objFields("STDJUDCD")
        Set objStdJudNote = objFields("STDJUDNOTE")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrJudClassCd(lngCount)
            ReDim Preserve vntArrStdJudCd(lngCount)
            ReDim Preserve vntArrStdJudNote(lngCount)
            vntArrJudClassCd(lngCount) = objJudClassCd.Value & ""
            vntArrStdJudCd(lngCount) = objStdJudCd.Value & ""
            vntArrStdJudNote(lngCount) = objStdJudNote.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    vntStdJudCd = vntArrStdJudCd
    vntStdJudNote = vntArrStdJudNote
    If IsMissing(vntJudClassCd) = False Then vntJudClassCd = vntArrJudClassCd
    
    SelectStdJudList = lngCount
        
    Set objOraDyna = Nothing
    
    If lngJudClassCd > 0 Then
        objOraParam.Remove "JUDCLASSCD"
        Set objOraParam = Nothing
    End If
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "StdJud.SelectStdJudList"

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
' 機能　　 : 定型所見名称を取得する
'
' 引数　　 : (In)     strJudClassCd 判定分類コード
' 　　　　 : (In)     strStdJudCd   定型所見コード
' 　　　　 : (Out)    vntStdJudNote 定型所見名称（省略可）
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 : 定型所見名称を省略可とすることで入力チェックに対応
'
Public Function SelectStdJudNote(ByVal strJudClassCd As String, _
                                 ByVal strStdJudCd As String, _
                                 Optional ByRef vntStdJudNote As Variant _
                                ) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objStdJudNote       As OraField         '定型所見名称

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCLASSCD", Trim(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STDJUDCD", Trim(strStdJudCd), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす定型所見テーブルのレコードを取得
    strStmt = "SELECT SJ.STDJUDNOTE                                     " & vbLf & _
              "  FROM STDJUD SJ                                         " & vbLf & _
              " WHERE SJ.JUDCLASSCD = :JUDCLASSCD                       " & vbLf & _
              "   AND SJ.STDJUDCD   = :STDJUDCD                         "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStdJudNote = objFields("STDJUDNOTE")

        If Not IsMissing(vntStdJudNote) Then
            vntStdJudNote = objStdJudNote.Value
        End If
        
        SelectStdJudNote = True
    Else
        If Not IsMissing(vntStdJudNote) Then
            vntStdJudNote = ""
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
    WriteErrorLog "StdJud.SelectStdJudNote"

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
' 機能　　 : 定型所見名称を取得する
'
' 引数　　 : (In)     strJudClassCd     判定分類コード
' 　　　　 : (In)     strStdJudCd       定型所見コード
' 　　　　 : (Out)    vntStdJudNote     定型所見名称（省略可）
' 　　　　 : (Out)    vntJudClassName   判定分類名称（省略可）
'
' 戻り値　 : True     データあり
' 　　　　 : False    データなし
'
' 備考　　 : 定型所見名称を省略可とすることで入力チェックに対応
'
Public Function SelectStdJud(ByVal strJudClassCd As String, _
                             ByVal strStdJudCd As String, _
                             Optional ByRef vntStdJudNote As Variant, _
                             Optional ByRef vntJudClassName As Variant _
                            ) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objStdJudNote       As OraField         '定型所見名称
    Dim objJudClassName     As OraField         '判定分類名称

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCLASSCD", Trim(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STDJUDCD", Trim(strStdJudCd), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす定型所見テーブルのレコードを取得
    strStmt = "SELECT SJ.STDJUDNOTE, JC.JUDCLASSNAME" & vbLf & _
              "  FROM JUDCLASS JC, STDJUD SJ" & vbLf & _
              " WHERE SJ.JUDCLASSCD = :JUDCLASSCD" & vbLf & _
              "   AND SJ.STDJUDCD   = :STDJUDCD" & vbLf & _
              "   AND SJ.JUDCLASSCD = JC.JUDCLASSCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objStdJudNote = objFields("STDJUDNOTE")
        Set objJudClassName = objFields("JUDCLASSNAME")

        If Not IsMissing(vntStdJudNote) Then
            vntStdJudNote = objStdJudNote.Value
        End If

        If Not IsMissing(vntJudClassName) Then
            vntJudClassName = objJudClassName.Value
        End If
        
        SelectStdJud = True
    Else
        If Not IsMissing(vntStdJudNote) Then
            vntStdJudNote = ""
        End If

        If Not IsMissing(vntJudClassName) Then
            vntJudClassName = ""
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
    WriteErrorLog "StdJud.SelectStdJud"

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
' 機能　　 : 定型所見テーブルレコードを登録する
'
' 引数　　 : (In)    strMode         登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    intJudClassCd   判定分類コード
' 　　　　   (In)    intStdJudCd     定型所見コード
' 　　　　   (In)    vntStdJudNote   定型所見名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistStdJud(ByVal strMode As String, _
                             ByVal intJudClassCd As Integer, _
                             ByVal intStdJudCd As Integer, _
                             ByVal strStdJudNote As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JudClassCd", Trim(intJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "StdJudCD", Trim(intStdJudCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "StdJudNote", Trim(strStdJudNote), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '定型所見テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE STDJUD " & _
                      "   SET STDJUDNOTE = :StdJudNote" & _
                      " WHERE JUDCLASSCD = :JudClassCd" & _
                      "   AND STDJUDCD   = :StdJudCD"
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす定型所見テーブルのレコードを取得
        strStmt = "SELECT STDJUDCD FROM STDJUD WHERE JUDCLASSCD = :JudClassCd AND STDJUDCD = :StdJudCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO STDJUD (JUDCLASSCD, STDJUDCD, STDJUDNOTE) VALUES (:JudClassCd, :StdJudCD, :StdJudNote)"
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
    RegistStdJud = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "StdJud.RegistStdJud"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistStdJud = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "StdJud.RegistStdJud", Err.Description

End Function
'
' 機能　　 : 定型所見テーブルレコードを削除する
'
' 引数　　 : (In)    intJudClassCd   判定分類コード
' 　　　　   (In)    intStdJudCd     定型所見コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteStdJud(ByVal intJudClassCd As Integer, ByVal intStdJudCd As Integer) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JudClassCd", Trim(intJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "StdJudCD", Trim(intStdJudCd), ORAPARM_INPUT, ORATYPE_NUMBER

    '定型所見テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE STDJUD WHERE JUDCLASSCD = :JudClassCd AND STDJUDCD = :StdJudCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteStdJud = True

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "StdJud.DeleteStdJud"

    DeleteStdJud = False

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "StdJud.DeleteStdJud", Err.Description

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
