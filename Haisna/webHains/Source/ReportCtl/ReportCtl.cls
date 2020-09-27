VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "ReportCtl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext                'オブジェクトコンテキスト
Private mobjOraSession      As OraSessionClass              'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase                  'OraDatabaseオブジェクト


'
' 機能　　 : Activateイベント
'
' 備考　　 : COMオブジェクトがアクティブ化された時点でデータベースへの接続を行う
'
Private Sub ObjectControl_Activate()

    Dim objCommon   As Common   '共通クラス
    
    '共通クラスのインスタンス作成
    Set objCommon = New Common
     
     'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()
  
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
'
' 機能　　 : 帳票パラメータ管理テーブルレコードの読み込み
'
' 引数　　 : (In)     strReportCd      帳票コード
' 　　　　   (Out)    vntCslDate       受信日
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectReportCtl(ByVal strReportCd As String, ByRef vntCslDate As Variant) As Long

    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCslDate      As OraField         '受信日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCslDate = Empty
    SelectReportCtl = 0
    
    '指定帳票コードの受信日を取得する
    strStmt = "SELECT CSLDATE    " & vbLf & _
              "  FROM REPORTCTL  " & vbLf & _
              " WHERE REPORTCD = '" & strReportCd & "' "

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        
        '戻り値の設定
        vntCslDate = Format(CDate(objCslDate.Value), "YYYYMMDD")
        
        SelectReportCtl = 1
        
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "ReportCtl.SelectReportCtl"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'
' 機能　　 : 帳票パラメータ管理テーブルに書き込み
'
' 引数　　 : (In)     strReportCd               帳票コード
' 　　　　 : (In)     vntCslDate                受信日
' 　　　　 : (In)     vntUpdUser                更新ユーザ
'
' 戻り値　 : 0      正常終了
' 　　　　 : 9      異常終了
'
' 備考　　 :
'
Public Function InsertReportCtl(ByVal strReportCd As String, ByVal vntCslDate As Variant, _
                          ByVal vntUpdUser As Variant) As Long

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPrintSeq             As OraField         'キー
    Dim blnRecFlg               As Boolean          'レコード有無フラグ（true:有、false:無）
    
    InsertReportCtl = 9

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '変数初期化
    blnRecFlg = False
    
    '帳票コードに該当するレコードの存在チェック
    strStmt = "SELECT CSLDATE    " & vbLf & _
              "  FROM REPORTCTL  " & vbLf & _
              " WHERE REPORTCD = '" & strReportCd & "' "

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    If Not objOraDyna.EOF Then
        'レコード有
        blnRecFlg = True
    End If

    Set objOraDyna = Nothing
    
    'レコード無の場合Insert。有の場合Update
    If blnRecFlg = False Then
        'レコード無し
        '帳票パラメータ管理テーブル追加処理
        strStmt = "INSERT INTO REPORTCTL ( REPORTCD, CSLDATE, UPDUSER, UPDDATE)" & vbLf & _
                  " VALUES " & vbLf & _
                  "( '" & strReportCd & "', '" & vntCslDate & "', '" & vntUpdUser & "', SYSDATE)"
    Else
        'レコード有り
        strStmt = "UPDATE REPORTCTL SET " & _
                  "       CSLDATE      = '" & vntCslDate & "' " & vbLf & _
                  "      ,UPDUSER      = '" & vntUpdUser & "' " & vbLf & _
                  "      ,UPDDATE      = SYSDATE" & vbLf & _
                  " WHERE REPORTCD     = '" & strReportCd & "' "
    End If
    
    mobjOraDb.ExecuteSQL strStmt

    'トランザクションをコミット
    mobjContext.SetComplete

    InsertReportCtl = 0
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "ReportCtl.InsertReportCtl"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function


