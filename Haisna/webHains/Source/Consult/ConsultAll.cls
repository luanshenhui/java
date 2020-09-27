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

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更
'
' 機能　　 : 一括受診日変更
'
' 引数　　 : (In)     strMode       検索モード
' 　　　　   (In)     strUserId     ユーザＩＤ
' 　　　　   (In)     lngIgnoreFlg  予約枠無視フラグ
' 　　　　   (In)     dtmCslDate    受診日
' 　　　　   (In)     vntRsvNo      予約番号
' 　　　　   (In)     vntRsvGrpCd   予約群コード
' 　　　　   (Out)    vntMessage    メッセージ
'
' 戻り値　 : 予約件数
'
' 備考　　 :
'
Public Function ChangeDate( _
    ByVal strMode As String, _
    ByVal strUserId As String, _
    ByVal lngIgnoreFlg As Long, _
    ByVal dtmCslDate As Date, _
    ByRef vntRsvNo As Variant, _
    ByRef vntRsvGrpCd As Variant, _
    ByRef vntMessage As Variant _
) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objRsvNo        As OraParamArray    '予約番号
    Dim objRsvGrpCd     As OraParamArray    '予約群コード
    Dim lngArraySize    As Long             '配列のサイズ
    
    Dim objStrRsvNo     As OraParameter     '開始予約番号
    Dim objEndRsvNo     As OraParameter     '終了予約番号
    Dim objMessage      As OraParameter     'メッセージ
    Dim objRet          As OraParameter     '戻り値

    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntMessage = Empty

    'バインド変数の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "MODE", strMode, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "USERID", strUserId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "IGNOREFLG", lngIgnoreFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE

    '戻り値の仮の配列として予約番号の配列サイズを指定
    lngArraySize = UBound(vntRsvNo) + 1

    'バインド配列(引数)の設定
    objOraParam.AddTable "RSVNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.AddTable "RSVGRPCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize

    'バインド変数(戻り値)の設定
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", Null, ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    'オブジェクトの参照設定
    Set objRsvNo = objOraParam("RSVNO")
    Set objRsvGrpCd = objOraParam("RSVGRPCD")
    Set objMessage = objOraParam("MESSAGE")
    Set objRet = objOraParam("RET")

    '引数値の値設定
    For i = 0 To lngArraySize - 1
        objRsvNo(i) = CLng(vntRsvNo(i))
        objRsvGrpCd(i) = IIf(vntRsvGrpCd(i) <> "", CLng("0" & vntRsvGrpCd(i)), Null)
    Next i

    '受診情報登録用ストアドパッケージのSQLステートメント作成
    strStmt = "BEGIN                                     " & vbLf & _
              "    :RET := ConsultAllPackage.ChangeDate( " & vbLf & _
              "                :MODE,                    " & vbLf & _
              "                :USERID,                  " & vbLf & _
              "                :IGNOREFLG,               " & vbLf & _
              "                :CSLDATE,                 " & vbLf & _
              "                :RSVNO,                   " & vbLf & _
              "                :RSVGRPCD,                " & vbLf & _
              "                :MESSAGE                  " & vbLf & _
              "            );                            " & vbLf & _
              "END;                                      "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objRet.Value
    
    '戻り値の設定
    If Ret < 0 Then
        vntMessage = CStr(objMessage.Value & "")
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    ChangeDate = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "ConsultAll.ChangeDate"
    
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
' 機能　　 : 予約枠検索からの予約
'
' 引数　　 : (In)     strMode         検索モード
' 　　　　   (In)     lngIgnoreFlg    予約枠無視フラグ
' 　　　　   (In)     strUserId       ユーザＩＤ
' 　　　　   (In)     dtmCslDate      受診日
' 　　　　   (In)     vntPerId        個人ＩＤ
' 　　　　   (In)     vntManCnt       人数
' 　　　　   (In)     vntGender       性別
' 　　　　   (In)     vntBirth        生年月日
' 　　　　   (In)     vntAge          受診時年齢
' 　　　　   (In)     vntRomeName     ローマ字名
' 　　　　   (In)     vntOrgCd1       団体コード１
' 　　　　   (In)     vntOrgCd2       団体コード２
' 　　　　   (In)     vntCslDivCd     受診区分コード
' 　　　　   (In)     vntCsCd         コースコード
' 　　　　   (In)     vntRsvGrpCd     予約群コード
' 　　　　   (In)     vntCtrPtCd      契約パターンコード
' 　　　　   (In)     vntRsvNo        継承すべき受診情報の予約番号
' 　　　　   (In)     vntOptCd        オプションコード
' 　　　　   (In)     vntOptBranchNo  オプション枝番
' 　　　　   (Out)    vntStrRsvNo     開始予約番号
' 　　　　   (Out)    vntEndRsvNo     終了予約番号
' 　　　　   (Out)    vntMessage      メッセージ
'
' 戻り値　 : 予約件数
'
' 備考　　 :
'
Public Function ReserveFromFrameReserve( _
    ByVal strMode As String, _
    ByVal strUserId As String, _
    ByVal lngIgnoreFlg As Long, _
    ByVal dtmCslDate As Date, _
    ByRef vntPerId As Variant, _
    ByRef vntManCnt As Variant, _
    ByRef vntGender As Variant, _
    ByRef vntBirth As Variant, _
    ByRef vntAge As Variant, _
    ByRef vntRomeName As Variant, _
    ByRef vntOrgCd1 As Variant, _
    ByRef vntOrgCd2 As Variant, _
    ByRef vntCsCd As Variant, _
    ByRef vntCslDivCd As Variant, _
    ByRef vntRsvGrpCd As Variant, _
    ByRef vntCtrPtCd As Variant, _
    ByRef vntRsvNo As Variant, _
    ByRef vntOptCd As Variant, _
    ByRef vntOptBranchNo As Variant, _
    ByRef vntStrRsvNo As Variant, _
    ByRef vntEndRsvNo As Variant, _
    ByRef vntMessage As Variant _
) As Long
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objPerId        As OraParamArray    '個人ＩＤ
    Dim objManCnt       As OraParamArray    '人数
    Dim objGender       As OraParamArray    '性別
    Dim objBirth        As OraParamArray    '生年月日
    Dim objAge          As OraParamArray    '受診時年齢
    Dim objRomeName     As OraParamArray    'ローマ字名
    Dim objOrgCd1       As OraParamArray    '団体コード１
    Dim objOrgCd2       As OraParamArray    '団体コード２
    Dim objCslDivCd     As OraParamArray    '受診区分コード
    Dim objCsCd         As OraParamArray    'コースコード
    Dim objRsvGrpCd     As OraParamArray    '予約群コード
    Dim objCtrPtCd      As OraParamArray    '契約パターンコード
    Dim objRsvNo        As OraParamArray    '継承すべき受診情報の予約番号
    Dim objOptCd        As OraParamArray    'オプションコード
    Dim objOptBranchNo  As OraParamArray    'オプション枝番
    Dim lngArraySize    As Long             '配列のサイズ
    
    Dim objStrRsvNo     As OraParameter     '開始予約番号
    Dim objEndRsvNo     As OraParameter     '終了予約番号
    Dim objMessage      As OraParameter     'メッセージ
    Dim objRet          As OraParameter     '戻り値

    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntStrRsvNo = Empty
    vntEndRsvNo = Empty
    vntMessage = Empty

    'バインド変数の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "MODE", strMode, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "USERID", strUserId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "IGNOREFLG", lngIgnoreFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE

    '戻り値の仮の配列として個人ＩＤの配列サイズを指定
    lngArraySize = UBound(vntPerId) + 1

    'バインド配列(引数)の設定
    objOraParam.AddTable "PERID", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_PERSON_PERID
    objOraParam.AddTable "MANCNT", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.AddTable "GENDER", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.AddTable "BIRTH", ORAPARM_INPUT, ORATYPE_DATE, lngArraySize
    objOraParam.AddTable "AGE", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.AddTable "ROMENAME", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 60
    objOraParam.AddTable "ORGCD1", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ORG_ORGCD1
    objOraParam.AddTable "ORGCD2", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_ORG_ORGCD2
    objOraParam.AddTable "CSLDIVCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 12
    objOraParam.AddTable "CSCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, LENGTH_COURSE_CSCD
    objOraParam.AddTable "RSVGRPCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.AddTable "CTRPTCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.AddTable "RSVNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize
    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 500
    objOraParam.AddTable "OPTBRANCHNO", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 300

    'バインド変数(戻り値)の設定
    objOraParam.Add "STRRSVNO", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDRSVNO", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", Null, ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    'オブジェクトの参照設定
    Set objPerId = objOraParam("PERID")
    Set objManCnt = objOraParam("MANCNT")
    Set objGender = objOraParam("GENDER")
    Set objBirth = objOraParam("BIRTH")
    Set objAge = objOraParam("AGE")
    Set objRomeName = objOraParam("ROMENAME")
    Set objOrgCd1 = objOraParam("ORGCD1")
    Set objOrgCd2 = objOraParam("ORGCD2")
    Set objCslDivCd = objOraParam("CSLDIVCD")
    Set objCsCd = objOraParam("CSCD")
    Set objRsvGrpCd = objOraParam("RSVGRPCD")
    Set objCtrPtCd = objOraParam("CTRPTCD")
    Set objRsvNo = objOraParam("RSVNO")
    Set objOptCd = objOraParam("OPTCD")
    Set objOptBranchNo = objOraParam("OPTBRANCHNO")
    Set objStrRsvNo = objOraParam("STRRSVNO")
    Set objEndRsvNo = objOraParam("ENDRSVNO")
    Set objMessage = objOraParam("MESSAGE")
    Set objRet = objOraParam("RET")

    '引数値の値設定
    For i = 0 To lngArraySize - 1
        objPerId(i) = CStr(vntPerId(i))
        objManCnt(i) = IIf(vntManCnt(i) <> "", CLng("0" & vntManCnt(i)), Null)
        objGender(i) = IIf(vntGender(i) <> "", CLng("0" & vntGender(i)), Null)
        objBirth(i) = IIf(vntBirth(i) <> "", CDate("0" & vntBirth(i)), Null)
        objAge(i) = IIf(vntAge(i) <> "", CLng("0" & vntAge(i)), Null)
        objRomeName(i) = CStr(vntRomeName(i))
        objOrgCd1(i) = CStr(vntOrgCd1(i))
        objOrgCd2(i) = CStr(vntOrgCd2(i))
        objCslDivCd(i) = CStr(vntCslDivCd(i))
        objCsCd(i) = CStr(vntCsCd(i))
        objRsvGrpCd(i) = IIf(vntRsvGrpCd(i) <> "", CLng("0" & vntRsvGrpCd(i)), Null)
        objCtrPtCd(i) = CLng(vntCtrPtCd(i))
        objRsvNo(i) = IIf(vntRsvNo(i) <> "", CLng("0" & vntRsvNo(i)), Null)
        objOptCd(i) = CStr(vntOptCd(i))
        objOptBranchNo(i) = CStr(vntOptBranchNo(i))
    Next i

    '受診情報登録用ストアドパッケージのSQLステートメント作成
    strStmt = "BEGIN                                       " & vbLf & _
              "    :RET := ConsultAllPackage.MultiReserve( " & vbLf & _
              "                :MODE,                      " & vbLf & _
              "                :USERID,                    " & vbLf & _
              "                :IGNOREFLG,                 " & vbLf & _
              "                :CSLDATE,                   " & vbLf & _
              "                :PERID,                     " & vbLf & _
              "                :MANCNT,                    " & vbLf & _
              "                :GENDER,                    " & vbLf & _
              "                :BIRTH,                     " & vbLf & _
              "                :AGE,                       " & vbLf & _
              "                :ROMENAME,                  "
              
    strStmt = strStmt & vbLf & _
              "                :ORGCD1,                    " & vbLf & _
              "                :ORGCD2,                    " & vbLf & _
              "                :CSLDIVCD,                  " & vbLf & _
              "                :CSCD,                      " & vbLf & _
              "                :RSVGRPCD,                  " & vbLf & _
              "                :CTRPTCD,                   " & vbLf & _
              "                :RSVNO,                     " & vbLf & _
              "                :OPTCD,                     " & vbLf & _
              "                :OPTBRANCHNO,               " & vbLf & _
              "                :STRRSVNO,                  " & vbLf & _
              "                :ENDRSVNO,                  " & vbLf & _
              "                :MESSAGE                    " & vbLf & _
              "            );                              " & vbLf & _
              "END;                                        "

    mobjOraDb.ExecuteSQL strStmt

    '戻り値の取得
    Ret = CLng("0" & objRet.Value)
    
    '戻り値の設定
    If Ret > 0 Then
        vntStrRsvNo = CLng(objStrRsvNo.Value)
        vntEndRsvNo = CLng(objEndRsvNo.Value)
    Else
        vntMessage = CStr(objMessage.Value & "")
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    ReserveFromFrameReserve = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
'## 2004/04/20 Mod By T.Takagi@FSIT メッセージ間違い
'    WriteErrorLog "Calendar.ReserveFromFrameReserve"
    WriteErrorLog "ConsultAll.ReserveFromFrameReserve"
'## 2004/04/20 Mod End
    
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

