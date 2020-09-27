VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "SetClass"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext      As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : セット分類テーブルレコードを削除する
'
' 引数　　 : (In)    strSetClassCd    セット分類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteSetClass(ByVal strSetClassCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SetClassCD", Trim(strSetClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'セット分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE SetClass WHERE SetClassCD = :SetClassCD"
    
    'バインド変数の削除
    objOraParam.Remove "SetClassCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteSetClass = True

    Exit Function
    
ErrorHandle:

    DeleteSetClass = False

    'イベントログ書き込み
    WriteErrorLog "SetClass.DeleteSetClass"
    
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
' 機能　　 : 進捗管理用分類テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strSetClassCd      進捗管理用分類コード
' 　　　　   (In)    vntSetClassName    進捗管理用分類名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistSetClass(ByVal strMode As String, _
                               ByVal strSetClassCd As String, _
                               ByVal strSetClassName As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SetClassCD", Trim(strSetClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SetClassNAME", Trim(strSetClassName), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '進捗管理用分類テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE SetClass " & _
                      "   SET SetClassNAME  = :SetClassNAME" & _
                      " WHERE SetClassCD    = :SetClassCD"
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす進捗管理用分類テーブルのレコードを取得
        strStmt = "SELECT SetClassCD FROM SetClass WHERE SetClassCD = :SetClassCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO SetClass (SetClassCD, SetClassNAME) VALUES (:SetClassCD, :SetClassNAME)"
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
    RegistSetClass = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistSetClass = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "SetClass.RegistSetClass"
    
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
' 機能　　 : セット分類の一覧を取得する
'
' 引数　　 : (Out)    vntSetClassCd    セット分類コード
' 　　　　   (Out)    vntSetClassName  セット分類名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectSetClassList(ByRef vntSetClassCd As Variant, ByRef vntSetClassName As Variant) As Long

    Dim objOraDyna              As OraDynaset   'ダイナセット
    Dim strStmt                 As String       'SQLステートメント
    
    Dim objFields               As OraFields    'フィールドオブジェクト
    Dim objSetClassCd           As OraField     'セット分類コード
    Dim objSetClassName         As OraField     'セット分類名
    
    Dim vntArrSetClassCd()      As Variant      'セット分類コードの配列
    Dim vntArrSetClassName()    As Variant      'セット分類名の配列
    Dim lngCount                As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntSetClassCd = Empty
    vntSetClassName = Empty
    lngCount = 0
    
    'セット分類テーブル読み込み
    strStmt = "SELECT SETCLASSCD, SETCLASSNAME " & vbLf & _
              "  FROM SETCLASS                 " & vbLf & _
              " ORDER BY SETCLASSCD            "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSetClassCd = objFields("SETCLASSCD")
        Set objSetClassName = objFields("SETCLASSNAME")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrSetClassCd(lngCount)
            ReDim Preserve vntArrSetClassName(lngCount)
            vntArrSetClassCd(lngCount) = objSetClassCd.Value
            vntArrSetClassName(lngCount) = objSetClassName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntSetClassCd = vntArrSetClassCd
        vntSetClassName = vntArrSetClassName
    
    End If
    
    '戻り値の設定
    SelectSetClassList = lngCount
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "SetClass.SelectSetClassList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : セット分類コードに対するセット分類名を取得する
'
' 引数　　 : (In)     strSetClassCd     セット分類コード
' 　　　　 : (Out)    vntSetClassName   セット分類名
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectSetClass(ByVal strSetClassCd As String, _
                               Optional ByRef vntSetClassName As Variant) As Long
                               

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSetClassName     As OraField         'セット分類名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strSetClassCd) = "" Then
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SetClassCD", Trim(strSetClassCd), ORAPARM_INPUT
    
    '検索条件を満たすセット分類テーブルのレコードを取得
    strStmt = "SELECT SetClassNAME FROM SetClass WHERE SetClassCD = :SetClassCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSetClassName = objFields("SetClassNAME")
    
        '戻り値の設定
        If IsMissing(vntSetClassName) = False Then
            vntSetClassName = objSetClassName.Value
        End If
        
        SelectSetClass = True
        
    End If
    
    Set objOraDyna = Nothing
        
    'キー値の解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "SetClass.SelectSetClass"
    
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
