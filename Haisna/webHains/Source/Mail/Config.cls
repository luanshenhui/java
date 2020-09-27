VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Config"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.3
'担当者  ：T.Takagi@RD
'修正内容：新規作成

Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const MAILCONF_ID   As Long = 1     'メール送信設定レコードのID値（"1"で固定）

'
' 機能　　 : メール送信設定を取得する
'
' 引数　　 : (Out)    vntMailFrom   FROM
' 　　　　   (Out)    vntCC         CC
' 　　　　   (Out)    vntBCC        BCC
' 　　　　   (Out)    vntSignature  署名
' 　　　　   (Out)    vntServerName SMTPサーバ名
' 　　　　   (Out)    vntUserId     ユーザID
' 　　　　   (Out)    vntPassword   パスワード
' 　　　　   (Out)    vntPortNo     ポート番号
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectMailConf( _
    ByRef vntMailFrom As Variant, _
    ByRef vntCC As Variant, _
    ByRef vntBCC As Variant, _
    ByRef vntSignature As Variant, _
    ByRef vntServerName As Variant, _
    ByRef vntUserId As Variant, _
    ByRef vntPassword As Variant, _
    ByRef vntPortNo As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objMailFrom     As OraField         'FROM
    Dim objCC           As OraField         'CC
    Dim objBCC          As OraField         'BCC
    Dim objSignature    As OraField         '署名
    Dim objServerName   As OraField         'SMPサーバ名
    Dim objUserId       As OraField         'ユーザID
    Dim objPassword     As OraField         'パスワード
    Dim objPortNo       As OraField         'ポート番号

    Dim objCLob         As OraClob          'OraCLobオブジェクト

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntMailFrom = Empty
    vntCC = Empty
    vntBCC = Empty
    vntSignature = Empty
    vntServerName = Empty
    vntUserId = Empty
    vntPassword = Empty
    vntPortNo = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ID", MAILCONF_ID, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たすレコードを取得
    strStmt = "SELECT MAILFROM, CC, BCC, SIGNATURE, SERVERNAME, USERID, PASSWORD, PORTNO " & vbLf & _
              "  FROM MAILCONF                                                           " & vbLf & _
              " WHERE ID = :ID                                                           "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objMailFrom = objFields("MAILFROM")
        Set objCC = objFields("CC")
        Set objBCC = objFields("BCC")
        Set objSignature = objFields("SIGNATURE")
        Set objServerName = objFields("SERVERNAME")
        Set objUserId = objFields("USERID")
        Set objPassword = objFields("PASSWORD")
        Set objPortNo = objFields("PORTNO")

        '戻り値の設定
        vntMailFrom = objMailFrom.Value & ""

        Set objCLob = objCC.Value
        If Not objCLob.IsNull Then
            objCLob.Read vntCC
        End If
        
        Set objCLob = objBCC.Value
        If Not objCLob.IsNull Then
            objCLob.Read vntBCC
        End If

        Set objCLob = objSignature.Value
        If Not objCLob.IsNull Then
            objCLob.Read vntSignature
        End If

        vntServerName = objServerName.Value & ""
        vntUserId = objUserId.Value & ""
        vntPassword = objPassword.Value & ""
        vntPortNo = objPortNo.Value & ""

        SelectMailConf = True

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
    WriteErrorLog "Config.SelectMailConf"

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : メール送信設定を登録する
'
' 引数　　 : (In)    strMode         登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strMailConfCd     結果コメントコード
' 　　　　   (In)    vntMailConfName   結果コメント名
' 　　　　   (In)    vntEntryOk      入力完了フラグ
'
' 戻り値　 : INSERT_NORMAL  正常終了
' 　　　　   INSERT_ERROR   異常終了
'
' 備考　　 :
'
Public Function RegistMailConf( _
    ByVal strMailFrom As String, _
    ByVal strCC As String, _
    ByVal strBCC As String, _
    ByVal strSignature As String, _
    ByVal strServerName As String, _
    ByVal strUserId As String, _
    ByVal strPassword As String, _
    ByVal strPortNo As String _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    
    Dim objCC           As OraClob          'CC
    Dim objBCC          As OraClob          'BCC
    Dim objSignature    As OraClob          '署名
    
    Dim strStmt         As String           'SQLステートメント
    Dim Ret             As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    Ret = INSERT_ERROR

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ID", MAILCONF_ID, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MAILFROM", Trim(strMailFrom), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CC", Null, ORAPARM_INPUT, ORATYPE_CLOB
    objOraParam.Add "BCC", Null, ORAPARM_INPUT, ORATYPE_CLOB
    objOraParam.Add "SIGNATURE", Null, ORAPARM_INPUT, ORATYPE_CLOB
    objOraParam.Add "SERVERNAME", Trim(strServerName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USERID", Trim(strUserId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PASSWORD", Trim(strPassword), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PORTNO", IIf(strPortNo <> "", CLng("0" & strPortNo), Null), ORAPARM_INPUT, ORATYPE_NUMBER

    strCC = Trim(strCC)
    If strCC <> "" Then
        Set objCC = mobjOraDb.CreateTempClob
        objCC.Write Trim(strCC)
        mobjOraDb.Parameters("CC").Value = objCC
    End If
    
    strBCC = Trim(strBCC)
    If strBCC <> "" Then
        Set objBCC = mobjOraDb.CreateTempClob
        objBCC.Write Trim(strBCC)
        mobjOraDb.Parameters("BCC").Value = objBCC
    End If
    
    If strSignature <> "" Then
        Set objSignature = mobjOraDb.CreateTempClob
        objSignature.Write strSignature
        mobjOraDb.Parameters("SIGNATURE").Value = objSignature
    End If
    
    'SQLステートメントの定義
    strStmt = "MERGE INTO MAILCONF                           " & vbLf & _
              "      USING (SELECT :ID         ID,           " & vbLf & _
              "                    :MAILFROM   MAILFROM,     " & vbLf & _
              "                    :CC         CC,           " & vbLf & _
              "                    :BCC        BCC,          " & vbLf & _
              "                    :SIGNATURE  SIGNATURE,    " & vbLf & _
              "                    :SERVERNAME SERVERNAME,   " & vbLf & _
              "                    :USERID     USERID,       " & vbLf & _
              "                    :PASSWORD   PASSWORD,     " & vbLf & _
              "                    :PORTNO     PORTNO        " & vbLf & _
              "               FROM DUAL                      " & vbLf & _
              "            ) BASEDMAILCONF                   " & vbLf & _
              "         ON (MAILCONF.ID = BASEDMAILCONF.ID ) "
          
    'レコード存在時は上書き
    strStmt = strStmt & vbLf & _
              "       WHEN MATCHED THEN                                               " & vbLf & _
              "            UPDATE SET MAILCONF.MAILFROM   = BASEDMAILCONF.MAILFROM,   " & vbLf & _
              "                       MAILCONF.CC         = BASEDMAILCONF.CC,         " & vbLf & _
              "                       MAILCONF.BCC        = BASEDMAILCONF.BCC,        " & vbLf & _
              "                       MAILCONF.SIGNATURE  = BASEDMAILCONF.SIGNATURE,  " & vbLf & _
              "                       MAILCONF.SERVERNAME = BASEDMAILCONF.SERVERNAME, " & vbLf & _
              "                       MAILCONF.USERID     = BASEDMAILCONF.USERID,     " & vbLf & _
              "                       MAILCONF.PASSWORD   = BASEDMAILCONF.PASSWORD,   " & vbLf & _
              "                       MAILCONF.PORTNO     = BASEDMAILCONF.PORTNO      "

    'レコード非存在時は挿入
    strStmt = strStmt & vbLf & _
              "       WHEN NOT MATCHED THEN         " & vbLf & _
              "            INSERT (                 " & vbLf & _
              "                MAILCONF.ID,         " & vbLf & _
              "                MAILCONF.MAILFROM,   " & vbLf & _
              "                MAILCONF.CC,         " & vbLf & _
              "                MAILCONF.BCC,        " & vbLf & _
              "                MAILCONF.SIGNATURE,  " & vbLf & _
              "                MAILCONF.SERVERNAME, " & vbLf & _
              "                MAILCONF.USERID,     " & vbLf & _
              "                MAILCONF.PASSWORD,   " & vbLf & _
              "                MAILCONF.PORTNO      "
    
    strStmt = strStmt & vbLf & _
              "            ) VALUES (                    " & vbLf & _
              "                BASEDMAILCONF.ID,         " & vbLf & _
              "                BASEDMAILCONF.MAILFROM,   " & vbLf & _
              "                BASEDMAILCONF.CC,         " & vbLf & _
              "                BASEDMAILCONF.BCC,        " & vbLf & _
              "                BASEDMAILCONF.SIGNATURE,  " & vbLf & _
              "                BASEDMAILCONF.SERVERNAME, " & vbLf & _
              "                BASEDMAILCONF.USERID,     " & vbLf & _
              "                BASEDMAILCONF.PASSWORD,   " & vbLf & _
              "                BASEDMAILCONF.PORTNO      " & vbLf & _
              "            )                             "

    'SQLステートメントの実行
    If mobjOraDb.ExecuteSQL(strStmt) > 0 Then
        Ret = INSERT_NORMAL
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    RegistMailConf = Ret

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Config.RegistMailConf"

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'その他の戻り値設定
    RegistMailConf = INSERT_ERROR

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
