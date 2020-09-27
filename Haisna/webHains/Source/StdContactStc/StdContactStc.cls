VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "StdContactStc"
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
' 機能　　 : 定型面接文章テーブルレコードを削除する
'
' 引数　　 : (In)    intGuidanceDiv         指導内容区分
' 　　　　 : (In)    strStdContactStcCd     定型面接文章コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteStdContactStc(ByVal intGuidanceDiv As Integer, _
                                    ByVal strStdContactStcCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GuidanceDiv", intGuidanceDiv, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "StdContactStcCD", Trim(strStdContactStcCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '定型面接文章テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE STDCONTACTSTC WHERE GUIDANCEDIV = :GUIDANCEDIV AND STDCONTACTSTCCD = :STDCONTACTSTCCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteStdContactStc = True

    Exit Function
    
ErrorHandle:

    DeleteStdContactStc = False

    'イベントログ書き込み
    WriteErrorLog "StdContactStc.DeleteStdContactStc"
    
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
' 機能　　 : 定型面接文章テーブルレコードを登録する
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    intGuidanceDiv         指導内容区分
' 　　　　   (In)    strStdContactStcCd     定型面接文章コード
' 　　　　   (In)    strContactStc          面接文章
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistStdContactStc(ByVal strMode As String, _
                                    ByVal intGuidanceDiv As Integer, _
                                    ByVal strStdContactStcCd As String, _
                                    ByVal strContactStc As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GUIDANCEDIV", Trim(intGuidanceDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STDCONTACTSTCCD", Trim(strStdContactStcCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CONTACTSTC", Trim(strContactStc), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '定型面接文章テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE STDCONTACTSTC SET CONTACTSTC = :CONTACTSTC WHERE GUIDANCEDIV = :GUIDANCEDIV AND STDCONTACTSTCCD = :STDCONTACTSTCCD"
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす定型面接文章テーブルのレコードを取得
        strStmt = "SELECT GUIDANCEDIV FROM STDCONTACTSTC WHERE GUIDANCEDIV = :GUIDANCEDIV AND STDCONTACTSTCCD = :STDCONTACTSTCCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO StdContactStc (GUIDANCEDIV, STDCONTACTSTCCD, CONTACTSTC) VALUES (:GUIDANCEDIV, :STDCONTACTSTCCD, :CONTACTSTC)"
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
    RegistStdContactStc = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistStdContactStc = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "StdContactStc.RegistStdContactStc"
    
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
' 機能　　 : 定型面接文章コードに対する定型面接文章名を取得する
'
' 引数　　 : (In)     intGuidanceDiv        指導内容区分
' 　　　　   (In)     strStdContactStcCd    定型面接文章コード
' 　　　　   (Out)    vntContactStc         面接文章
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectStdContactStc(ByVal intGuidanceDiv As Integer, _
                                    ByVal strStdContactStcCd As String, _
                                    ByRef vntContactStc As Variant) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objContactStc           As OraField         '定型面接文章名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "GUIDANCEDIV", Trim(intGuidanceDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STDCONTACTSTCCD", Trim(strStdContactStcCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす定型面接文章テーブルのレコードを取得
    strStmt = "SELECT CONTACTSTC FROM STDCONTACTSTC WHERE GUIDANCEDIV = :GUIDANCEDIV AND STDCONTACTSTCCD = :STDCONTACTSTCCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objContactStc = objFields("CONTACTSTC")
    
        '戻り値の設定
        vntContactStc = objContactStc.Value
        
        SelectStdContactStc = True
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "StdContactStc.SelectStdContactStc"
    
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
' 機能　　 : 定型面接文章の一覧を取得する
'
' 引数　　 : (Out)    vntGuidanceDiv        指導内容区分
' 　　　　   (Out)    vntStdContactStcCd    定型面接文章コード
' 　　　　   (Out)    vntContactStc         面接文章
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectStdContactStcList(ByRef vntGuidanceDiv As Variant, _
                                        ByRef vntStdContactStcCd As Variant, _
                                        ByRef vntContactStc As Variant) As Long

    Dim objOraDyna                  As OraDynaset   'ダイナセット
    Dim strStmt                     As String       'SQLステートメント
    
    Dim objFields                   As OraFields    'フィールドオブジェクト
    Dim objGuidanceDiv              As OraField     '指導内容区分
    Dim objStdContactStcCd          As OraField     '定型面接文章コード
    Dim objContactStc               As OraField     '面接文章
    
    Dim vntArrGuidanceDiv()         As Variant      '指導内容区分の配列
    Dim vntArrStdContactStcCd()     As Variant      '定型面接文章コードの配列
    Dim vntArrContactStc()          As Variant      '定型面接文章名の配列
    Dim lngCount                    As Long         'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntStdContactStcCd = Empty
    vntContactStc = Empty
    lngCount = 0
    
    '定型面接文章テーブルの全レコードを取得
    strStmt = "SELECT GUIDANCEDIV, STDCONTACTSTCCD, CONTACTSTC " & vbLf & _
              "  FROM STDCONTACTSTC " & vbLf & _
              " ORDER BY GUIDANCEDIV, STDCONTACTSTCCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGuidanceDiv = objFields("GUIDANCEDIV")
        Set objStdContactStcCd = objFields("STDCONTACTSTCCD")
        Set objContactStc = objFields("CONTACTSTC")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrGuidanceDiv(lngCount)
            ReDim Preserve vntArrStdContactStcCd(lngCount)
            ReDim Preserve vntArrContactStc(lngCount)
            vntArrGuidanceDiv(lngCount) = objGuidanceDiv.Value
            vntArrStdContactStcCd(lngCount) = objStdContactStcCd.Value
            vntArrContactStc(lngCount) = objContactStc.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntGuidanceDiv = vntArrGuidanceDiv
        vntStdContactStcCd = vntArrStdContactStcCd
        vntContactStc = vntArrContactStc
    
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectStdContactStcList = lngCount
        
    Exit Function
    
ErrorHandle:

    SelectStdContactStcList = -1
    
    'イベントログ書き込み
    WriteErrorLog "StdContactStc.SelectStdContactStcList"
    
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
