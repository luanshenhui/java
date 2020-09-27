VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Pref"
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
' 機能　　 : 都道府県テーブルレコードを削除する
'
' 引数　　 : (In)    strPrefCd    都道府県コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeletePref(ByVal strPrefCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PREFCD", Trim(strPrefCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '都道府県テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE PREF WHERE PREFCD = :PREFCD"
    
    'バインド変数の削除
    objOraParam.Remove "PREFCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeletePref = True

    Exit Function
    
ErrorHandle:

    DeletePref = False

    'イベントログ書き込み
    WriteErrorLog "Pref.DeletePref"
    
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
' 機能　　 : 都道府県テーブルレコードを登録する
'
' 引数　　 : (In)    strMode      登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strPrefCd    都道府県コード
' 　　　　   (In)    vntPrefName  都道府県名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistPref(ByVal strMode As String, ByVal strPrefCd As String, ByVal strPrefName As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PREFCD", Trim(strPrefCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PREFNAME", Trim(strPrefName), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '都道府県テーブルレコードの更新
        If strMode = "UPD" Then
            Ret = mobjOraDb.ExecuteSQL("UPDATE PREF SET PREFNAME = :PREFNAME WHERE PREFCD = :PREFCD")
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす都道府県テーブルのレコードを取得
        strStmt = "SELECT PREFNAME FROM PREF WHERE PREFCD = :PREFCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO PREF (PREFCD, PREFNAME) VALUES (:PREFCD, :PREFNAME)"
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    objOraParam.Remove "PREFCD"
    objOraParam.Remove "PREFNAME"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistPref = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistPref = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Pref.RegistPref"
    
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
' 機能　　 : 都道府県コードに対する都道府県名を取得する
'
' 引数　　 : (In)     strPrefCd    都道府県コード
' 　　　　   (Out)    vntPrefName  都道府県名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPref(ByVal strPrefCd As String, ByRef vntPrefName As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objPrefName As OraField         '都道府県名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PREFCD", Trim(strPrefCd), ORAPARM_INPUT
    
    '検索条件を満たす都道府県テーブルのレコードを取得
    strStmt = "SELECT PREFNAME FROM PREF WHERE PREFCD = :PREFCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPrefName = objFields("PREFNAME")
    
        '戻り値の設定
        vntPrefName = objPrefName.Value
        
        SelectPref = True
        
    End If
    
    'バインド変数の削除
    objOraParam.Remove "PREFCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Pref.SelectPref"
    
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
' 機能　　 : 都道府県の一覧を取得する
'
' 引数　　 : (Out)    vntPrefCd    都道府県コード
' 　　　　   (Out)    vntPrefName  都道府県名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectPrefList(ByRef vntPrefCd As Variant, ByRef vntPrefName As Variant) As Long

    Dim objOraDyna          As OraDynaset   'ダイナセット
    Dim strStmt             As String       'SQLステートメント
    
    Dim objFields           As OraFields    'フィールドオブジェクト
    Dim objPrefCd           As OraField     '都道府県コード
    Dim objPrefName         As OraField     '都道府県名
    
    Dim vntArrPrefCd()      As Variant      '都道府県コードの配列
    Dim vntArrPrefName()    As Variant      '都道府県名の配列
    Dim lngCount            As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntPrefCd = Empty
    vntPrefName = Empty
    lngCount = 0
    
    '都道府県テーブルの全レコードを取得
    strStmt = "SELECT PREFCD, PREFNAME " & vbLf & _
              "  FROM PREF             " & vbLf & _
              " ORDER BY PREFCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPrefCd = objFields("PREFCD")
        Set objPrefName = objFields("PREFNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPrefCd(lngCount)
            ReDim Preserve vntArrPrefName(lngCount)
            vntArrPrefCd(lngCount) = objPrefCd.Value
            vntArrPrefName(lngCount) = objPrefName.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntPrefCd = vntArrPrefCd
        vntPrefName = vntArrPrefName
    
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectPrefList = lngCount
        
    Exit Function
    
ErrorHandle:

    SelectPrefList = -1
    
    'イベントログ書き込み
    WriteErrorLog "Pref.SelectPrefList"
    
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
