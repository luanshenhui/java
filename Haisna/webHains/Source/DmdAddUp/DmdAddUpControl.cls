VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "DmdAddUpControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession              As OraSession               'OraSessionオブジェクト
Private mobjOraDb                   As OraDatabase              'OraDatabaseオブジェクト

'### 2002.12.26 Modified by Ishihara@FSIT 締め処理ストアド化（東急版）
'
' 機能　　 : 請求締め処理を起動する
'
' 引数　　 : (In)   strCloseDate    締め日
' 　　　　 : (In)   strStrDate      開始受診日
' 　　　　 : (In)   strEndDate      終了受診日
' 　　　　 : (In)   strOrgCd1       団体コード１
' 　　　　 : (In)   strOrgCd2       団体コード２
' 　　　　 : (In)   strCourseCd     コースコード
' 　　　　 : (In)   strUserID       ユーザＩＤ
'' 　　　　 : (In)   strNoCheck      1:結果、判定の未入力チェックを行わない。
'
' 戻り値　 : エラー時、エラーメッセージの配列を返す
'
' 備考　　 :
'
' Public Function ExecuteDmdAddUp(ByVal dtmCloseDate As Date,
'                                ByVal dtmStrDate As Date,
'                                ByVal dtmEndDate As Date,
'                                ByVal strOrgCd1 As String,
'                                ByVal strOrgCd2 As String,
'                                ByVal strBillClassCd As String,
'                                ByVal strUserID As String,
'                                ByVal strNoCheck As String
'                               ) As Variant
'
'
Public Function ExecuteDmdAddUp(ByVal dtmCloseDate As Date, _
                                ByVal dtmStrDate As Date, _
                                ByVal dtmEndDate As Date, _
                                ByVal strOrgCd1 As String, _
                                ByVal strOrgCd2 As String, _
                                ByVal strCourseCd As String, _
                                ByVal strUserID As String _
                               ) As Variant
    
    Dim vntArrMessage           As Variant          'エラーメッセージの集合
    
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BURDENORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BURDENORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", strCourseCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.03.28 Added by Ishihara@FSIT 締め処理は結果、判定未入力チェックを行わないモード追加
'### 2004.01.13 Added by C's 聖路加版は不要
'objOraParam.Add "NOCHECK", strNoCheck, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2003.03.28 Added End

    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    '締め処理用ストアドパッケージの関数呼び出し
'### 2003.03.28 Added by Ishihara@FSIT 締め処理は結果、判定未入力チェックを行わないモード追加
'    strStmt = "BEGIN :RET := DemandPackage.CreateBill(:CLOSEDATE, :STRDATE, :ENDDATE, :BURDENORGCD1, :BURDENORGCD2, :BILLCLASSCD); END;"
'    strStmt = "BEGIN :RET := DemandPackage.CreateBill(:CLOSEDATE, :STRDATE, :ENDDATE, :BURDENORGCD1, :BURDENORGCD2, :BILLCLASSCD, :NOCHECK); END;"
'### 2003.03.28 Added End
    strStmt = "BEGIN :RET := DemandPackage.CreateBill(:CLOSEDATE, :STRDATE, :ENDDATE, :BURDENORGCD1, :BURDENORGCD2, :CSCD); END;"


    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL strStmt

    '戻り値の取得
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    ExecuteDmdAddUp = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Demand.ExecuteDmdAddUp"
    
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


'### 2002.12.26 Modified End
    
End Function

'
' 機能　　 : Activateイベント
'
' 備考　　 : COMオブジェクトがアクティブ化された時点でデータベースへの接続を行う
'
Private Sub ObjectControl_Activate()

'    Dim objCommon   As Common   '共通クラス
    Dim objCommon   As Object   '共通クラス

    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()

    '共通クラスのインスタンス作成
'    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    Set objCommon = CreateObject("HainsCommon.Common")

    'データベース接続
'    Set mobjOraSession = mobjContext.CreateInstance("OracleInProcServer.XOraSession")
    Set mobjOraSession = CreateObject("OracleInProcServer.XOraSession")

    Set mobjOraDb = mobjOraSession.OpenDatabase(objCommon.ConnectString, objCommon.UserName & "/" & objCommon.Password, ORADB_ENLIST_IN_MTS)

End Sub

Private Function ObjectControl_CanBePooled() As Boolean

End Function

'
' 機能　　 : Deactivateイベント
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
