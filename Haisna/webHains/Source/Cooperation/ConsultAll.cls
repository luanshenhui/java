VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ConsultAll"
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
' 機能　　 : 指定団体・事業部・室部・所属・契約パターン条件を満たす受診情報の一括削除を行う
'
' 引数　　 : (In)     dtmStrCslDate        開始受診日
' 　　　　   (In)     dtmEndCslDate        終了受診日
' 　　　　   (In)     strOrgCd1            団体コード１
' 　　　　   (In)     strOrgCd2            団体コード２
' 　　　　   (In)     strOrgBsdCd          事業部コード
' 　　　　   (In)     strOrgRoomCd 　      室部コード
' 　　　　   (In)     strStrOrgPostCd      開始所属コード
' 　　　　   (In)     strEndOrgPostCd      終了所属コード
' 　　　　   (In)     lngCtrPtCd           契約パターンコード
' 　　　　   (In)     lngNotFixedOnly      受診日未確定分削除指定(1:受診日未確定分のみを削除)
' 　　　　   (In)     lngNotCancelForce    強制削除可否(1:問診が入力されている受診情報は削除しない)
' 　　　　   (In)     lngNotExistsOptOnly  "1":オプション検査が１つも存在しない受診情報のみ削除
'
' 戻り値　 : 挿入レコード数
'
' 備考　　 :
'
'## 2003.02.15 Mod 25Lines By T.Takagi@FSIT 強制キャンセル機能追加
'Public Function DeleteConsultAll(
'    ByVal dtmStrCslDate As Date,
'    ByVal dtmEndCslDate As Date,
'    ByVal strOrgCd1 As String,
'    ByVal strOrgCd2 As String,
'    ByVal strOrgBsdCd As String,
'    ByVal strOrgRoomCd As String,
'    ByVal strStrOrgPostCd As String,
'    ByVal strEndOrgPostCd As String,
'    ByVal lngCtrPtCd As Long,
'    ByVal lngNotFixedOnly As Long
') As Long
'## 2003.08.22 Mod 27Lines By T.Takagi@FSIT オプション検査を持たない受診情報のみ削除する機能追加
'Public Function DeleteConsultAll(
'    ByVal dtmStrCslDate As Date,
'    ByVal dtmEndCslDate As Date,
'    ByVal strOrgCd1 As String,
'    ByVal strOrgCd2 As String,
'    ByVal strOrgBsdCd As String,
'    ByVal strOrgRoomCd As String,
'    ByVal strStrOrgPostCd As String,
'    ByVal strEndOrgPostCd As String,
'    ByVal lngCtrPtCd As Long,
'    ByVal lngNotFixedOnly As Long,
'    ByVal lngNotCancelForce As Long
') As Long
Public Function DeleteConsultAll( _
    ByVal dtmStrCslDate As Date, _
    ByVal dtmEndCslDate As Date, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strOrgBsdCd As String, _
    ByVal strOrgRoomCd As String, _
    ByVal strStrOrgPostCd As String, _
    ByVal strEndOrgPostCd As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal lngNotFixedOnly As Long, _
    ByVal lngNotCancelForce As Long, _
    ByVal lngNotExistsOptOnly As Long _
) As Long
'## 2003.08.22 Mod End
'## 2003.02.15 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGBSDCD", strOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGROOMCD", strOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRORGPOSTCD", strStrOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENDORGPOSTCD", strEndOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NOTFIXEDONLY", lngNotFixedOnly, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.15 Add 1Line By T.Takagi@FSIT 強制キャンセル機能追加
    objOraParam.Add "CANCELFORCE", IIf(lngNotCancelForce <> 0, 0, 1), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.15 Add End
'## 2003.08.22 Add 1Line By T.Takagi@FSIT オプション検査を持たない受診情報のみ削除する機能追加
    objOraParam.Add "NOTEXISTSOPTONLY", lngNotExistsOptOnly, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.08.22 Add End
    
    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER

    '受診情報登録用ストアドパッケージの関数呼び出し
'## 2003.02.15 Mod 2Lines By T.Takagi@FSIT 強制キャンセル機能追加
'    strStmt = "BEGIN :RET := ConsultAllPackage.DeleteConsultAll(:STRCSLDATE, :ENDCSLDATE, :ORGCD1, :ORGCD2, :ORGBSDCD, :ORGROOMCD, :STRORGPOSTCD, :ENDORGPOSTCD, :CTRPTCD, :NOTFIXEDONLY); END;"
'## 2003.08.22 Mod 2Lines By T.Takagi@FSIT オプション検査を持たない受診情報のみ削除する機能追加
'    strStmt = "BEGIN :RET := ConsultAllPackage.DeleteConsultAll(:STRCSLDATE, :ENDCSLDATE, :ORGCD1, :ORGCD2, :ORGBSDCD, :ORGROOMCD, :STRORGPOSTCD, :ENDORGPOSTCD, :CTRPTCD, :NOTFIXEDONLY, :CANCELFORCE); END;"
    strStmt = "BEGIN :RET := ConsultAllPackage.DeleteConsultAll(:STRCSLDATE, :ENDCSLDATE, :ORGCD1, :ORGCD2, :ORGBSDCD, :ORGROOMCD, :STRORGPOSTCD, :ENDORGPOSTCD, :CTRPTCD, :NOTFIXEDONLY, :CANCELFORCE, :NOTEXISTSOPTONLY); END;"
'## 2003.08.22 Mod End
'## 2003.02.15 Mod End

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objOraParam("RET").Value

    'トランザクション制御
    'mobjContext.SetComplete

    '戻り値の設定
    DeleteConsultAll = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ConsultAll.DeleteConsultAll"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 指定個人の受診情報を作成する
'
' 引数　　 : (In)     strUpdUser         更新者
' 　　　　   (In)     strOrgCd1          団体コード１
' 　　　　   (In)     strOrgCd2          団体コード２
' 　　　　   (In)     strPerId           個人ＩＤ
' 　　　　   (In)     lngCtrPtCd         契約パターンコード
' 　　　　   (In)     dtmCslDate         受診希望日
' 　　　　   (Out)    vntMessage1        メッセージ１
' 　　　　   (Out)    vntMessage2        メッセージ２
' 　　　　   (In)     lngTransactionId   トランザクションＩＤ
' 　　　　   (In)     strTransactionDiv  トランザクション区分
'
' 戻り値　 : >0   予約番号
' 　　　　   -1   同一受診日、受診者、コースの受診情報がすでに存在
' 　　　　   -2   契約情報が存在しない
' 　　　　   -3   オプション検査情報が存在しない
' 　　　　   -4   登録しようとしたオプションが削除オプションだった
' 　　　　   -5   枠溢れ
' 　　　　   -6   すでに受付済みである
' 　　　　   -7   すでに使用されている当日IDで発番しようとした
' 　　　　   -8   規定外の当日IDが指定された
' 　　　　   -9   発番可能な最大番号数を超えた
' 　　　　   -10  個人情報が存在しない
' 　　　　   -11  指定個人の団体情報が存在しない
' 　　　　   -12  指定された契約パターンの受診情報がすでに存在
'
' 備考　　 :
'
'## 2003.05.17 Mod 22Lines By T.Takagi@FSIT ログ強化
'Public Function InsertConsultFromPerId(
'    ByVal strUpdUser As String,
'    ByVal strOrgCd1 As String,
'    ByVal strOrgCd2 As String,
'    ByVal strPerId As String,
'    ByVal lngCtrPtCd As Long,
'    ByVal dtmCslDate As Date,
'    ByRef vntMessage1 As Variant,
'    ByRef vntMessage2 As Variant
') As Long
Public Function InsertConsultFromPerId( _
    ByVal strUpdUser As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strPerId As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal dtmCslDate As Date, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant, _
    ByVal lngTransactionId As Long, _
    ByVal strTransactionDiv As String _
) As Long
'## 2003.05.17 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntMessage1 = Empty
    vntMessage2 = Empty
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDATE", IIf(dtmCslDate > 0, dtmCslDate, Null), ORAPARM_INPUT, ORATYPE_DATE
'## 2003.05.17 Add 2Lines By T.Takagi@FSIT ログ強化
    objOraParam.Add "TRANSID", lngTransactionId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TRANSDIV", strTransactionDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.05.17 Add End
    
    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE1", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MESSAGE2", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    '受診情報登録用ストアドパッケージの関数呼び出し
'## 2003.05.17 Mod 2Lines By T.Takagi@FSIT ログ強化
'    strStmt = "BEGIN :RET := ConsultAllPackage.InsertConsultFromPerId(:UPDUSER, :ORGCD1, :ORGCD2, :PERID, :CTRPTCD, :CSLDATE, :MESSAGE1, :MESSAGE2); END;"
    strStmt = "BEGIN :RET := ConsultAllPackage.InsertConsultFromPerId(:UPDUSER, :ORGCD1, :ORGCD2, :PERID, :CTRPTCD, :CSLDATE, :MESSAGE1, :MESSAGE2, :TRANSID, :TRANSDIV); END;"
'## 2003.05.17 Mod End

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage1 = objOraParam("MESSAGE1").Value & ""
    vntMessage2 = objOraParam("MESSAGE2").Value & ""
    
    Ret = objOraParam("RET").Value

    'トランザクション制御
    'mobjContext.SetComplete

    '戻り値の設定
    InsertConsultFromPerId = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ConsultAll.InsertConsultFromPerId"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 指定団体・事業部・室部・所属条件を満たす個人の一括予約を行う
'
' 引数　　 : (In)     strUpdUser       更新者
' 　　　　   (In)     strOrgCd1        団体コード１
' 　　　　   (In)     strOrgCd2        団体コード２
' 　　　　   (In)     strOrgBsdCd      事業部コード
' 　　　　   (In)     strOrgRoomCd 　  室部コード
' 　　　　   (In)     strStrOrgPostCd  開始所属コード
' 　　　　   (In)     strEndOrgPostCd  終了所属コード
' 　　　　   (In)     lngCtrPtCd       契約パターンコード
' 　　　　   (In)     dtmCslDate       受診日
' 　　　　   (In)     lngOpMode        (同一契約パターン未受付受診情報存在時の)処理モード(0:何もしない、1:キャンセル、2:削除)
'
' 戻り値　 : 挿入レコード数
'
' 備考　　 :
'
Public Function InsertConsultFromPerson( _
    ByVal strUpdUser As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strOrgBsdCd As String, _
    ByVal strOrgRoomCd As String, _
    ByVal strStrOrgPostCd As String, _
    ByVal strEndOrgPostCd As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal dtmCslDate As Date, _
    ByVal lngOpMode As Long _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGBSDCD", strOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGROOMCD", strOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRORGPOSTCD", strStrOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENDORGPOSTCD", strEndOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDATE", IIf(dtmCslDate > 0, dtmCslDate, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "OPMODE", lngOpMode, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER

    '受診情報登録用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN                                                  " & vbLf & _
              "    :RET := ConsultAllPackage.InsertConsultFromPerson( " & vbLf & _
              "                :UPDUSER,                              " & vbLf & _
              "                :ORGCD1,                               " & vbLf & _
              "                :ORGCD2,                               " & vbLf & _
              "                :ORGBSDCD,                             " & vbLf & _
              "                :ORGROOMCD,                            " & vbLf & _
              "                :STRORGPOSTCD,                         " & vbLf & _
              "                :ENDORGPOSTCD,                         " & vbLf & _
              "                :CTRPTCD,                              " & vbLf & _
              "                :OPMODE,                               " & vbLf & _
              "                :CSLDATE                               " & vbLf & _
              "            );                                         " & vbLf & _
              "END;                                                   "
    
    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objOraParam("RET").Value

    'トランザクション制御
    'mobjContext.SetComplete

    '戻り値の設定
    InsertConsultFromPerson = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ConsultAll.InsertConsultFromPerson"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 指定受診日範囲、コース、団体・事業部・室部・所属条件を満たす個人の一括予約を行う
'
' 引数　　 : (In)     strUpdUser        更新者
' 　　　　   (In)     dtmStrCslDate     開始受診日
' 　　　　   (In)     dtmEndCslDate     終了受診日
' 　　　　   (In)     vntCsCd           コースコード
' 　　　　   (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (In)     strOrgBsdCd       事業部コード
' 　　　　   (In)     strOrgRoomCd 　   室部コード
' 　　　　   (In)     strStrOrgPostCd   開始所属コード
' 　　　　   (In)     strEndOrgPostCd   終了所属コード
' 　　　　   (In)     lngCtrPtCd        契約パターンコード
' 　　　　   (In)     dtmSecStrCslDate  割り当て開始日
' 　　　　   (In)     dtmSecEndCslDate  割り当て終了日
'
' 戻り値　 : 挿入レコード数
'
' 備考　　 :
'
'## 2003.02.20 Mod 29Lines By T.Takagi@FSIT ２次受診日を割り当て期間に変更
'Public Function InsertConsultFromResult(
'    ByVal strUpdUser As String,
'    ByVal dtmStrCslDate As Date,
'    ByVal dtmEndCslDate As Date,
'    ByVal vntCsCd As Variant,
'    ByVal strOrgCd1 As String,
'    ByVal strOrgCd2 As String,
'    ByVal strOrgBsdCd As String,
'    ByVal strOrgRoomCd As String,
'    ByVal strStrOrgPostCd As String,
'    ByVal strEndOrgPostCd As String,
'    ByVal lngCtrPtCd As Long,
'    ByVal dtmSecCslDate As Date
') As Long
Public Function InsertConsultFromResult( _
    ByVal strUpdUser As String, _
    ByVal dtmStrCslDate As Date, _
    ByVal dtmEndCslDate As Date, _
    ByVal vntCsCd As Variant, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strOrgBsdCd As String, _
    ByVal strOrgRoomCd As String, _
    ByVal strStrOrgPostCd As String, _
    ByVal strEndOrgPostCd As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal dtmSecStrCslDate As Date, _
    ByVal dtmSecEndCslDate As Date _
) As Long
'## 2003.02.20 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim objCsCd     As OraParamArray    'コースコード
    
    Dim Ret         As Long             '関数戻り値
    Dim i           As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGBSDCD", strOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGROOMCD", strOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRORGPOSTCD", strStrOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENDORGPOSTCD", strEndOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.02.20 Mod 3Lines By T.Takagi@FSIT ２次受診日を割り当て期間に変更
'    objOraParam.Add "SECCSLDATE", dtmSecCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "SECSTRCSLDATE", dtmSecStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "SECENDCSLDATE", dtmSecEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
'## 2003.02.20 Mod End
    
    'コースコードのバインド配列定義
    objOraParam.AddTable "CSCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, UBound(vntCsCd) + 1, LENGTH_COURSE_CSCD
    
    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER

    'オブジェクトの参照設定
    Set objCsCd = objOraParam("CSCD")
    
    'コースコードの編集
    For i = 0 To UBound(vntCsCd)
        objCsCd.put_Value CStr(vntCsCd(i)), i
    Next i
    
    '受診情報登録用ストアドパッケージの関数呼び出し
'## 2003.02.20 Mod 33Lines By T.Takagi@FSIT ２次受診日を割り当て期間に変更
'    strStmt = "BEGIN                                                  " & vbLf & _
'              "    :RET := ConsultAllPackage.InsertConsultFromResult( " & vbLf & _
'              "                :UPDUSER,                              " & vbLf & _
'              "                :STRCSLDATE,                           " & vbLf & _
'              "                :ENDCSLDATE,                           " & vbLf & _
'              "                :CSCD,                                 " & vbLf & _
'              "                :ORGCD1,                               " & vbLf & _
'              "                :ORGCD2,                               " & vbLf & _
'              "                :ORGBSDCD,                             " & vbLf & _
'              "                :ORGROOMCD,                            " & vbLf & _
'              "                :STRORGPOSTCD,                         " & vbLf & _
'              "                :ENDORGPOSTCD,                         " & vbLf & _
'              "                :CTRPTCD,                              " & vbLf & _
'              "                :SECCSLDATE                            " & vbLf & _
'              "            );                                         " & vbLf & _
'              "END;                                                   "
    strStmt = "BEGIN                                                  " & vbLf & _
              "    :RET := ConsultAllPackage.InsertConsultFromResult( " & vbLf & _
              "                :UPDUSER,                              " & vbLf & _
              "                :STRCSLDATE,                           " & vbLf & _
              "                :ENDCSLDATE,                           " & vbLf & _
              "                :CSCD,                                 " & vbLf & _
              "                :ORGCD1,                               " & vbLf & _
              "                :ORGCD2,                               " & vbLf & _
              "                :ORGBSDCD,                             " & vbLf & _
              "                :ORGROOMCD,                            " & vbLf & _
              "                :STRORGPOSTCD,                         " & vbLf & _
              "                :ENDORGPOSTCD,                         " & vbLf & _
              "                :CTRPTCD,                              " & vbLf & _
              "                :SECSTRCSLDATE,                        " & vbLf & _
              "                :SECENDCSLDATE                         " & vbLf & _
              "            );                                         " & vbLf & _
              "END;                                                   "
'## 2003.02.20 Mod End

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objOraParam("RET").Value

    '戻り値の設定
    InsertConsultFromResult = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ConsultAll.InsertConsultFromResult"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'## 2003.03.25 Add Function By T.Takagi@FSIT
'
' 機能　　 : 指定条件を満たす受診情報のオプション検査を年齢・性別等にて決定する標準オプションに更新する
'
' 引数　　 : (In)     dtmStrCslDate      開始受診日
' 　　　　   (In)     dtmEndCslDate      終了受診日
' 　　　　   (In)     strOrgCd1          団体コード１
' 　　　　   (In)     strOrgCd2          団体コード２
' 　　　　   (In)     lngCtrPtCd         契約パターンコード
' 　　　　   (In)     strReCreatePrice   "1"ならば受診金額を再作成
'
' 戻り値　 : 更新受診情報数
'
' 備考　　 :
'
Public Function UpdateOption( _
    ByVal dtmStrCslDate As Date, _
    ByVal dtmEndCslDate As Date, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal strReCreatePrice As String _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RECREATEPRICE", IIf(strReCreatePrice <> "", 1, 0), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER

    '受診情報登録用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN :RET := ConsultAllPackage.UpdateOption(:STRCSLDATE, :ENDCSLDATE, :ORGCD1, :ORGCD2, :CTRPTCD, :RECREATEPRICE); END;"

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objOraParam("RET").Value

    '戻り値の設定
    UpdateOption = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ConsultAll.UpdateOption"
    
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
    Set objCommon = CreateObject("HainsCommon.Common")

    'データベース接続
    Set mobjOraSession = CreateObject("OracleInProcServer.XOraSession")
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
