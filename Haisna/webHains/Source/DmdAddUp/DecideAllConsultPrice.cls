VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "DecideAllConsultPrice"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession              As OraSession               'OraSessionオブジェクト
Private mobjOraDb                   As OraDatabase              'OraDatabaseオブジェクト

'### 2004.02.13 Updated Function Ishihara@FSIT 団体コードプラスして作りなおしました～
'
' 機能　　 : 指定予約番号の負担金額情報を取得する
'
' 引数　　 : (In)     dtmStrDate        対象受診日開始日
' 　　　　   (In)     dtmEndDate        対象受診日終了日
' 　　　　   (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (In)     vntForceUpdate    1:受診金額を強制的に再作成
' 　　　　   (In)     vntPutLog         0:開始終了のみ、1:エラーのみ、2:全て
'
' 戻り値　 : >=0  処理レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function DecideAllConsultPrice(ByVal dtmStrDate As Date, _
                                      ByVal dtmEndDate As Date, _
                                      ByVal strOrgCd1 As String, _
                                      ByVal strOrgCd2 As String, _
                                      Optional ByVal vntForceUpdate As Variant = 0, _
                                      Optional ByVal vntPutLog As Variant = 0) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objStrDate          As OraField         '開始日
    Dim objEndDate          As OraField         '終了日
    Dim objForceUpdate      As OraField         '強制修正
    Dim objPutLog           As OraField         'ログ出力
    
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '数値でないなら0セット
    If IsNumeric(vntForceUpdate) = False Or Trim(vntForceUpdate) = "" Then vntForceUpdate = 0
    If IsNumeric(vntPutLog) = False Or Trim(vntPutLog) = "" Then vntPutLog = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FORCEUPDATE", CInt(vntForceUpdate), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PUTLOG", CInt(vntPutLog), ORAPARM_INPUT, ORATYPE_NUMBER

    '請求情報ストアドパッケージの関数呼び出し
    strStmt = "BEGIN :RET := DemandPackage.RebuildConsultPrice(:STRDATE, :ENDDATE, :ORGCD1, :ORGCD2, :FORCEUPDATE, :PUTLOG); END;"
    mobjOraDb.ExecuteSQL strStmt
    
    '戻り値の設定
    DecideAllConsultPrice = CLng("0" & objOraParam("RET").Value)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    DecideAllConsultPrice = -1

    'イベントログ書き込み
    WriteErrorLog "Demand.DecideAllConsultPrice"
    
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

