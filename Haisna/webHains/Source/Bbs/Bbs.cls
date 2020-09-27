VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Bbs"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト
Private mobjContext      As ObjectContext    'オブジェクトコンテキスト

'
' 機能　　 : ＢＢＳテーブル入力チェック
'
' 引数　　 : (In)     lngStrDateYear        表示開始日付（年）
' 　　　　 : (In)     lngStrDateMonth       表示開始日付（月）
' 　　　　 : (In)     lngStrDateDay         表示開始日付（日）
' 　　　　 : (In)     lngEndDateYear        表示終了日付（年）
' 　　　　 : (In)     lngEndDateMonth       表示終了日付（月）
' 　　　　 : (In)     lngEndDateDay         表示終了日付（日）
' 　　　　 : (In)     strHandle             投稿者
' 　　　　 : (In)     strTitle              タイトル
' 　　　　 : (In)     strMessage            メッセージ
' 　　　　 : (Out)    vntStrDate            表示開始日付
' 　　　　 : (Out)    vntEndDate            表示終了日付
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValue(ByVal lngStrDateYear As String, ByVal lngStrDateMonth As String, ByVal lngStrDateDay As String, _
                           ByVal lngEndDateYear As String, ByVal lngEndDateMonth As String, ByVal lngEndDateDay As String, _
                           ByVal strHandle As String, ByVal strTitle As String, ByVal strMessage As String, _
                           ByRef vntStrDate As Variant, ByRef vntEndDate As Variant) As Variant
                         
    Dim objCommon       As Common   '共通クラス
    
    Dim vntArrMessage   As Variant  'エラーメッセージの集合
    Dim strArrMessage   As String   'エラーメッセージ
    Dim i               As Long     'インデックス
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    '各値チェック処理
    With objCommon
    
        '表示開始日付
        .AppendArray vntArrMessage, .CheckDate("表示開始日付", lngStrDateYear, lngStrDateMonth, lngStrDateDay, vntStrDate)
        
        '表示終了日付
        .AppendArray vntArrMessage, .CheckDate("表示終了日付", lngEndDateYear, lngEndDateMonth, lngEndDateDay, vntEndDate)
        
        '投稿者
        .AppendArray vntArrMessage, .CheckWideValue("投稿者", Trim(strHandle), LENGTH_BBS_HANDLE, CHECK_NECESSARY)
        
        'タイトル
        .AppendArray vntArrMessage, .CheckWideValue("表題", Trim(strTitle), LENGTH_BBS_TITLE, CHECK_NECESSARY)
        
        'メッセージ
        strArrMessage = .CheckWideValue("コメント", Trim(strMessage), LENGTH_BBS_MESSAGE, CHECK_NECESSARY)
        
        '改行文字も1字として含む旨を通達
        If strArrMessage <> "" Then
            .AppendArray vntArrMessage, strArrMessage & "（改行文字も含みます）"
        End If
    
    End With
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If
    
End Function

'
' 機能　　 : 掲示板テーブルに書き込み
'
' 引数　　 : (In)     strStrDate            表示開始日付
' 　　　　 : (In)     strEndDate            表示終了日付
' 　　　　 : (In)     strHandle             投稿者
' 　　　　 : (In)     strTitle              タイトル
' 　　　　 : (In)     strMessage            メッセージ
' 　　　　 : (In)     strUdpUser            投稿ユーザー
'
' 戻り値　 : 0      正常終了
' 　　　　 : 1      ユーザＩＤ不一致
'
' 備考　　 :
'
Public Function InsertBbs(ByVal strStrDate As String, ByVal endEndDate As String, _
                          ByVal strHandle As String, ByVal strTitle As String, ByVal strMessage As String, _
                          ByVal strUpdUser As String _
                         ) As Long
    

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
'    CheckIDandPassword = 9
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRDATE", Trim(strStrDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", Trim(endEndDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "HANDLE", Trim(strHandle), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TITLE", Trim(strTitle), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MESSAGE", Trim(strMessage), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'ＢＢＳテーブル追加処理
    strStmt = "INSERT INTO BBS ( BBSKEY, STRDATE, ENDDATE, HANDLE, TITLE, MESSAGE, UPDDATE, UPDUSER)" & vbLf & _
              " VALUES " & vbLf & _
              "(BBSKEY_SEQ.NEXTVAL, :STRDATE, :ENDDATE, :HANDLE, :TITLE, :MESSAGE, SYSDATE, :UPDUSER)" & vbLf
    
    mobjOraDb.ExecuteSQL strStmt
        
        
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Bbs.InsertBbs"
    
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
' 機能　　 : 掲示板テーブル削除
'
' 引数　　 : (In)     strBbsKey     キー
'
' 戻り値　 : 0  正常終了
'
' 備考　　 :
'
Public Function DeleteBbs(Optional ByVal strBbsKey As String = "") As Long
    
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BBSKEY", Trim(strBbsKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'ＢＢＳテーブル削除
    strStmt = "DELETE BBS "
              
    'キー指定時はキー値で削除し、さもなくば表示終了日付が過去日であるすべてのレコードを削除する
    If strBbsKey <> "" Then
        strStmt = strStmt & vbLf & _
              " WHERE BBSKEY = :BBSKEY "
    Else
        strStmt = strStmt & vbLf & _
              " WHERE TO_CHAR(ENDDATE, 'YYYYMMDD') < TO_CHAR(SYSDATE, 'YYYYMMDD') "
    End If
    
    mobjOraDb.ExecuteSQL strStmt
        
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Bbs.DeleteBbs"
    
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
' 機能　　 : 今日のコメント取得
'
' 引数　　 : (In)     strToDay              今日の日付
' 　　　　 : (Out)    vntBbsKey             キー
' 　　　　 : (Out)    vntStrDate            表示開始日付
' 　　　　 : (Out)    vntEndDate            表示終了日付
' 　　　　 : (Out)    vntHandle             投稿者
' 　　　　 : (Out)    vntTitle              タイトル
' 　　　　 : (Out)    vntMessage            メッセージ
' 　　　　 : (Out)    vntUpdDate            投稿日付
' 　　　　 : (Out)    vntUpdUser            投稿ユーザー
'
' 戻り値　 : 取得件数
'
' 備考　　 :
'
Public Function SelectAllBbs( _
                                ByVal strToDay As String, _
                                ByRef vntBbsKey As Variant, _
                                ByRef vntStrDate As Variant, _
                                ByRef vntEndDate As Variant, _
                                ByRef vntHandle As Variant, _
                                ByRef vntTitle As Variant, _
                                ByRef vntMessage As Variant, _
                                ByRef vntUpdDate As Variant, _
                                ByRef vntUpdUser As Variant _
                            ) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    
    Dim objBbsKey       As OraField         'キー
    Dim objStrDate      As OraField         '表示開始日付
    Dim objEndDate      As OraField         '表示終了日付
    Dim objHandle       As OraField         '投稿者
    Dim objTitle        As OraField         'タイトル
    Dim objMessage      As OraField         'メッセージ
    Dim objUpdDate      As OraField         '投稿日付
    Dim objUpdUser      As OraField         '投稿ユーザー
    
'    Dim objCommon       As Common           '共通クラス
    
    Dim vntArrBbsKey()  As Variant          'キー
    Dim vntArrStrDate() As Variant          '表示開始日付
    Dim vntArrEndDate() As Variant          '表示終了日付
    Dim vntArrHandle()  As Variant          '投稿者
    Dim vntArrTitle()   As Variant          'タイトル
    Dim vntArrMessage() As Variant          'メッセージ
    Dim vntArrUpdDate() As Variant          '投稿日付
    Dim vntArrUpdUser() As Variant          '投稿ユーザー
    
    Dim lngCount        As Long             'レコード数
    
    '初期値
    vntBbsKey = Empty
    vntStrDate = Empty
    vntEndDate = Empty
    vntHandle = Empty
    vntTitle = Empty
    vntMessage = Empty
    vntUpdDate = Empty
    vntUpdUser = Empty
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "TODAY", strToDay, ORAPARM_INPUT, ORATYPE_DATE
    
    'BBSテーブルから取得
'### Updated By FSIT@Ishihara BBSは降順だろ？
'    strStmt = "SELECT BBSKEY, STRDATE, ENDDATE, HANDLE," & vbLf & _
              "       TITLE,  MESSAGE, UPDDATE, UPDUSER " & vbLf & _
              "  FROM BBS " & vbLf & _
              " WHERE STRDATE    <= :TODAY      " & vbLf & _
              "   AND ENDDATE    >= :TODAY      " & vbLf & _
              " ORDER BY UPDDATE  "
    strStmt = "SELECT BBSKEY, STRDATE, ENDDATE, HANDLE," & vbLf & _
              "       TITLE,  MESSAGE, UPDDATE, UPDUSER " & vbLf & _
              "  FROM BBS " & vbLf & _
              " WHERE STRDATE    <= :TODAY      " & vbLf & _
              "   AND ENDDATE    >= :TODAY      " & vbLf & _
              " ORDER BY UPDDATE DESC"
'### Updated By End

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        '共通クラスのインスタンス作成
 '       Set objCommon = mobjcontext.createinstance("HainsCommon.Common")
 
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objBbsKey = objFields("BBSKEY")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objHandle = objFields("HANDLE")
        Set objTitle = objFields("TITLE")
        Set objMessage = objFields("MESSAGE")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
'            objCommon.AppendArray vntArrBbsKey, objBbsKey.Value
'            objCommon.AppendArray vntArrStrDate, objStrDate.Value
'            objCommon.AppendArray vntArrEndDate, objEndDate.Value
'            objCommon.AppendArray vntArrHandle, objHandle.Value
'            objCommon.AppendArray vntArrTitle, objTitle.Value
'            objCommon.AppendArray vntArrMessage, objMessage.Value
'            objCommon.AppendArray vntArrUpdDate, objUpdDate.Value
'            objCommon.AppendArray vntArrUpdUser, objUpdUser.Value
            
            ReDim Preserve vntArrBbsKey(lngCount)
            ReDim Preserve vntArrStrDate(lngCount)
            ReDim Preserve vntArrEndDate(lngCount)
            ReDim Preserve vntArrHandle(lngCount)
            ReDim Preserve vntArrTitle(lngCount)
            ReDim Preserve vntArrMessage(lngCount)
            ReDim Preserve vntArrUpdDate(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)
            
            vntArrBbsKey(lngCount) = objBbsKey.Value & ""
            vntArrStrDate(lngCount) = objStrDate.Value & ""
            vntArrEndDate(lngCount) = objEndDate.Value & ""
            vntArrHandle(lngCount) = objHandle.Value & ""
            vntArrTitle(lngCount) = objTitle.Value & ""
            vntArrMessage(lngCount) = objMessage.Value & ""
            vntArrUpdDate(lngCount) = objUpdDate.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntBbsKey = vntArrBbsKey
    vntStrDate = vntArrStrDate
    vntEndDate = vntArrEndDate
    vntHandle = vntArrHandle
    vntTitle = vntArrTitle
    vntMessage = vntArrMessage
    vntUpdDate = vntArrUpdDate
    vntUpdUser = vntArrUpdUser
    
    SelectAllBbs = lngCount
        
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Bbs.SelectAllBbs"
    
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

    'オブジェクトコンテキストを解放
    Set mobjContext = Nothing

End Sub




