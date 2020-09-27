VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "CheckAuthority"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext        'オブジェクトコンテキスト
Private mobjOraSession      As OraSessionClass      'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase          'OraDatabaseオブジェクト

Public CurPageName          As String
Public CurPageAuthority     As Integer

'プログラム操作権限
Public Enum AUTHORITY
    AUTHORITY_NOTING = 0            '権限なし
    AUTHORITY_SELECT = 1            '参照のみ
    AUTHORITY_INSERT = 2            '登録、更新のみ
    AUTHORITY_DELETE = 3            '削除のみ
    AUTHORITY_ALL = 4               'すべて権限
End Enum

Private Const TERM_EXPIRE       As Integer = 90
Private Const TERM_ALERT        As Integer = 14
Private Const MSG_EXPIRE1       As String = "パスワードの有効期間が満了しました。"
Private Const MSG_EXPIRE2       As String = "今パスワードを変更してください。"
Private Const MSG_ALERT1        As String = "現在のパスワードの使用可能期間は"
Private Const MSG_ALERT2        As String = "までです。"



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


' 機能　　 :
' 戻り値　 :
' 備考　　 :
'
Public Function GetAuthority(ByVal strUserID As String, _
                             ByVal strUserGrp As String, _
                             ByVal strFileName As String, _
                             ByRef intPgmGrant As Variant, _
                             ByRef strMessage As Variant _
                             ) As Boolean

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim retBol              As Boolean
    Dim tmpMsg              As String
    Dim retPgmName          As String
    Dim lngFindPos          As Long
    Dim sFindName           As String
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    lngFindPos = InStrRev(Trim$(strFileName), "/", -1, vbBinaryCompare)
    If lngFindPos > 0 Then
        sFindName = Trim$(Mid$(Trim$(strFileName), lngFindPos + 1))
    End If

    If Not CheckPgmInfo(Trim(sFindName), retPgmName) Then
        '## マスターに登録が抜け落ちされた場合には既存と等しい状態を維持する。
        CurPageName = Trim(strFileName)
        CurPageAuthority = 4
        intPgmGrant = 4
        GetAuthority = True
        Exit Function
    End If


    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "USERID", Trim(strUserID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USERGRPCD", Trim(strUserGrp), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PGMFILENAME", Trim(sFindName), ORAPARM_INPUT, ORATYPE_VARCHAR2

    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = " SELECT GPI.USRGRPCD,    GPI.PGMCD,        GPI.PGMGRANT,    " & vbLf & _
              "        PI.PGMNAME,      PI.PGMFILENAME                     " & vbLf & _
              " FROM GRP_PGMINFO GPI, PGMINFO PI                           " & vbLf & _
              " WHERE GPI.USRGRPCD      = :USERGRPCD                       " & vbLf & _
              "     AND GPI.PGMCD       = PI.PGMCD                         " & vbLf & _
              "     AND PI.PGMFILENAME  = :PGMFILENAME                     " & vbLf & _
              "     AND PI.DELFLG       = 0                                "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        CurPageName = objFields("PGMFILENAME")
        CurPageAuthority = objFields("PGMGRANT")
        
        '##プログラム操作権限
        '1:参照、2:登録(変更）、3:削除　、4:すべて
        intPgmGrant = objFields("PGMGRANT")
        retBol = True
    
    Else
        tmpMsg = ""
        tmpMsg = strUserGrp & ": " & sFindName & "【" & retPgmName & "】" & " ごのプログラムの使用権限がありません。"
        strMessage = tmpMsg
        retBol = False
    End If
    
        
    '戻り値の設定
    GetAuthority = retBol
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
    
ErrorHandle:
    'イベントログ書き込み
    WriteErrorLog "CheckAuthority.GetAuthority"
    
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

Private Function CheckPgmInfo(sPgmFileName As String, _
                              ByRef sPgmName As String) As Boolean


    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim retBol              As Boolean
    Dim LogMsg              As String
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PGMFILENAME", Trim(sPgmFileName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = " SELECT PI.PGMCD,   PI.PGMNAME,   PI.PGMFILENAME    " & vbLf & _
              " FROM  PGMINFO PI                                   " & vbLf & _
              " WHERE PI.PGMFILENAME  = :PGMFILENAME               "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        Set objFields = objOraDyna.Fields
        sPgmName = objFields("PGMNAME")
        retBol = True
    Else
'        LogMsg = "プログラム登録情報がありません。--> " & sPgmFileName
'        OutputLog LogMsg
        retBol = False
    End If
    
    
    '戻り値の設定
    CheckPgmInfo = retBol
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
        
ErrorHandle:
    'イベントログ書き込み
    WriteErrorLog "CheckAuthority.CheckPgmInfo"
    
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



Private Function ObjectControl_CanBePooled() As Boolean

End Function

Private Sub ObjectControl_Deactivate()
' 機能　　 : DeaActivateイベント
' 備考　　 : COMオブジェクトが非アクティブ化された時点でデータベースからの切断を行う
'
    'データベース切断
    Set mobjOraSession = Nothing
    Set mobjOraDb = Nothing

    'オブジェクトコンテキストの解放
    Set mobjContext = Nothing

End Sub


''==============================================================================================
Private Sub OutputLog(ByVal pOutLog As String)
    Dim strLog              As String
    Dim strErrInfo          As String
    Dim intFileNumber       As Integer           ''## 正常系ログファイル　ファイル番号
    Dim strErrLogFilePath   As String
    
    strLog = vbNullString
        
    strErrLogFilePath = App.Path & IIf(Right$(Trim$(App.Path), 1) <> "\", "\", vbNullString) & "Authority.log"
        
    ''## ファイルオープン
    intFileNumber = FileOpen(strErrLogFilePath, True)
    If intFileNumber = 0 Then
        Exit Sub
    End If
    
    ''## 日付と時刻の出力
    strLog = "[" & Format$(Now(), "yyyy.mm.dd hh:nn:ss") & "]" & Space$(1)
    
    ''## モジュール名/プロシージャ名/エラーメッセージの出力
    strLog = strLog & Space$(2) & pOutLog
    
    
    ''## ログ内容の出力
    Print #intFileNumber, strLog
    
    ''## ファイルクローズ
    Call FileClose(intFileNumber)
        
    
End Sub

Private Function FileOpen(ByVal strFilePath As String, _
                          ByVal blnAppendMode As Boolean) As Integer
    Dim Result As Integer
    
    Result = 0
    
    Do
        If Trim$(strFilePath) = vbNullString Then
            Exit Do
        End If
        
        Result = FreeFile()
        If blnAppendMode Then
            Open strFilePath For Append Shared As #Result
        Else
            Open strFilePath For Output As #Result
        End If
        
        Exit Do
    Loop
    
    FileOpen = Result
       
End Function

Private Sub FileClose(ByVal intFileNumber As Integer)

    Close #intFileNumber
    
End Sub


' 機能　　 :
' 戻り値　 :
' 備考　　 :
'
Public Function CheckPwdDate(ByVal strUserID As String, _
                             ByRef strMessage As Variant _
                             ) As Long

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim intExpire           As Integer
    Dim intAlert            As Integer
    
    Dim sExpTerm            As String
    Dim sAltTerm            As String
    Dim strExpire1          As String
    Dim strExpire2          As String
    Dim strAlert1           As String
    Dim strAlert2           As String
    Dim lngUse              As Long
    Dim PassDate            As Date
    Dim lngRet              As Long
    Dim ExpDate             As String
    

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    strMessage = ""
    If Not GetExpireInfo(sExpTerm, sAltTerm, strExpire1, strExpire2, strAlert1, strAlert2) Then
        '## Default Setting ##
        intExpire = TERM_EXPIRE
        intAlert = TERM_ALERT
        strExpire1 = MSG_EXPIRE1
        strExpire2 = MSG_EXPIRE2
        strAlert1 = MSG_ALERT1
        strAlert2 = MSG_ALERT2
    Else
        intExpire = CInt(sExpTerm)
        intAlert = CInt(sAltTerm)
    End If


    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "USERID", UCase(Trim(strUserID)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = " SELECT NVL(PWDSETDATE,SYSDATE-" & intExpire + intAlert & ") PWDSETDATE  " & vbCrLf & _
              " FROM HAINSUSER                                                          " & vbCrLf & _
              " WHERE USERID = :USERID                                                  "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        PassDate = objFields("PWDSETDATE")
    End If
    
    lngUse = DateDiff("d", PassDate, Now)

    If lngUse >= intExpire Then
        strMessage = strExpire1 & vbCrLf & strExpire2
        lngRet = 2
        
    ElseIf intExpire - lngUse <= intAlert Then
        ExpDate = CStr(Now + (intExpire - lngUse))
        strMessage = strAlert1 & "【" & Format(ExpDate, "yyyy/mm/dd") & "】" & strAlert2
        lngRet = 1
    End If
    
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    
    '戻り値の設定
    CheckPwdDate = lngRet
    
    Exit Function
    
    
ErrorHandle:
    'イベントログ書き込み
    WriteErrorLog "CheckAuthority.CheckPwdDate"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function


Private Function GetExpireInfo(ByRef sExpTerm As String, ByRef sAltTerm As String, _
                               ByRef strExpire1 As String, ByRef strExpire2 As String, _
                               ByRef strAlert1 As String, ByRef strAlert2 As String) As Boolean
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim retBol              As Boolean

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "FREECD", "PWDSET", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    strStmt = " SELECT FREEFIELD1   ExpTerm            " & vbLf & _
              "        ,FREEFIELD2  AltTerm            " & vbLf & _
              "        ,FREEFIELD3  ExpMsg1            " & vbLf & _
              "        ,FREEFIELD4  ExpMsg2            " & vbLf & _
              "        ,FREEFIELD5  AltMsg1            " & vbLf & _
              "        ,FREEFIELD6  AltMsg2            " & vbLf & _
              " FROM FREE                              " & vbLf & _
              " WHERE FREECD    =    :FREECD           "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        sExpTerm = Format(objFields("ExpTerm"))
        sAltTerm = Format(objFields("AltTerm"))
        strExpire1 = Format(objFields("ExpMsg1"))
        strExpire2 = Format(objFields("ExpMsg2"))
        strAlert1 = Format(objFields("AltMsg1"))
        strAlert2 = Format(objFields("AltMsg2"))
        
        If IsNull(objFields("ExpTerm")) Then sExpTerm = CStr(TERM_EXPIRE)
        If IsNull(objFields("AltTerm")) Then sAltTerm = CStr(TERM_ALERT)
        If IsNull(objFields("ExpMsg1")) Then strExpire1 = MSG_EXPIRE1
        If IsNull(objFields("ExpMsg2")) Then strExpire2 = MSG_EXPIRE2
        If IsNull(objFields("AltMsg1")) Then strAlert1 = MSG_ALERT1
        If IsNull(objFields("AltMsg2")) Then strAlert2 = MSG_ALERT2
        
        retBol = True
    End If
    
    '戻り値の設定
    GetExpireInfo = retBol
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    'イベントログ書き込み
    WriteErrorLog "CheckAuthority.GetExpireInfo"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function




