VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Screening"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSession       'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : スクリーニング
'
' 引数　　 : (In)     dtmStrCslDate  開始受診日
' 　　　　   (In)     dtmEndCslDate  終了受診日
' 　　　　   (In)     strStrDayId    開始当日ＩＤ
' 　　　　   (In)     strEndDayId    終了当日ＩＤ
' 　　　　   (In)     strCsCd        コースコード
' 　　　　   (In)     strJudClassCd  判定分類コード
' 　　　　   (In)     lngReJudge     再判定フラグ
' 　　　　   (In)     lngEntryCheck  未入力チェックフラグ
'
' 戻り値　 : スクリーニングを実施した受診情報数
'
' 備考　　 : トランザクション制御はストアドプロシージャにて行うため、
' 　　　　   MTSTransactionModeプロパティ値がNotAnMTSObjectである新規クラスを作成し、
' 　　　　   既存クラスとの干渉を回避
'
Public Function Screening( _
    ByVal dtmStrCslDate As Date, _
    ByVal dtmEndCslDate As Date, _
    ByVal strStrDayId As String, _
    ByVal strEndDayId As String, _
    ByVal strCsCd As String, _
    ByVal strJudClassCd As String, _
    ByVal strPerId As String, _
    ByVal lngReJudge As Long, _
    ByVal lngEntryCheck As Long _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objOptCd        As OraParamArray    'オプションコード
    Dim objGrpCd        As OraParamArray    'グループコード
    Dim objEditFlg_G    As OraParamArray    'グループの修正区分
    Dim objItemCd       As OraParamArray    '検査項目コード
    Dim objEditFlg_I    As OraParamArray    '検査項目の修正区分

    Dim lngArraySize    As Long             'オプション検査数
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "STRDAYID", IIf(strStrDayId <> "", CLng("0" & strStrDayId), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDDAYID", IIf(strEndDayId <> "", CLng("0" & strEndDayId), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JUDCLASSCD", strJudClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PERID", IIf(strPerId <> "", strPerId, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "REJUDGE", lngReJudge, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENTRYCHECK", lngEntryCheck, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER

    'スクリーニング用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN                                   " & vbLf & _
              "    :RET := JudgementPackage.Screening( " & vbLf & _
              "                :STRCSLDATE,            " & vbLf & _
              "                :ENDCSLDATE,            " & vbLf & _
              "                :STRDAYID,              " & vbLf & _
              "                :ENDDAYID,              " & vbLf & _
              "                :CSCD,                  " & vbLf & _
              "                :JUDCLASSCD,            " & vbLf & _
              "                :PERID,                 " & vbLf & _
              "                :ENTRYCHECK,            " & vbLf & _
              "                :REJUDGE                " & vbLf & _
              "           );                           " & vbLf & _
              "END;                                    "

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objOraParam("RET").Value

    '戻り値の設定
    Screening = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Screening.Screening"
    
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

