VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "nutritionCalc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext                 As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession              As OraSession      'OraSessionオブジェクト
Private mobjOraDb                   As OraDatabase     'OraDatabaseオブジェクト

'桁数
Private Const LENGTH_RECEIPT_DAYID          As Integer = 4      '当日ＩＤ


'
' 機能　　 : 指定された条件の計算処理を起動する
'
' 引数　　 : (In)     strUpdUser          更新者
' 　　　　   (In)     strIpAddress        ＩＰアドレス
' 　　　　   (In)     strCslDate          受診日
' 　　　　   (In)     lngDayIdFlg         1:ID 範囲指定、2:ID任意指定
' 　　　　   (In)     vntCalcFlg          配列（栄養計算,Ａ型行動パターン,失点判定,ストレス点数)
'                                         0:計算非対象　1:計算対象
' 　　　　   (In)     lngStrDayId         検索開始ＩＤ
' 　　　　   (In)     lngEndDayId         検索終了ＩＤ
' 　　　　   (In)     vntArrDayId         検索ＩＤ（配列）
' 　　　　   (Out)    vntArrMessage       エラーメッセージ（配列）
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function nutritionCalcStart( _
    ByVal strUpdUser As String, _
    ByVal strIpAddress As String, _
    ByVal strCslDate As String, _
    ByVal lngDayIdFlg As Long, _
    ByRef vntCalcFlg As Variant, _
    ByVal lngStrDayId As Variant, _
    ByVal lngEndDayId As Variant, _
    ByRef vntArrDayId As Variant, _
    ByRef vntArrMessage As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objArrDayId         As OraParamArray    '当日ＩＤ
    
    Dim objRet              As OraParameter     '関数復帰値
    
    Dim lngArraySize        As Long             '配列サイズ

    Dim i                   As Long             'ループカウンタ
    
    Dim lngMsgCnt           As Long             'エラーメッセージ件数
    
    Dim Ret                 As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
'MsgBox "nutritionCalcStart!! ==>" & lngDayIdFlg
    
    If lngDayIdFlg = 2 Then
        '配列数
        lngArraySize = UBound(vntArrDayId) + 1
    Else
        lngArraySize = 1
    End If

    Ret = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLDATE", strCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "DAYIDFLG", lngDayIdFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRDAYID", lngStrDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDDAYID", lngEndDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.AddTable "ARRDAYID", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, LENGTH_RECEIPT_DAYID

    If lngDayIdFlg = 2 Then
        Set objArrDayId = objOraParam("ARRDAYID")
    
        'OraParameterオブジェクトの値設定
        For i = 0 To lngArraySize - 1
            objArrDayId(i) = vntArrDayId(i)
        Next i
    End If
    
    For i = 0 To 3
        If vntCalcFlg(i) = 1 Then
            Select Case i
                '栄養計算
                Case 0
                    '栄養計算ストアド呼び出し
                    mobjOraDb.ExecuteSQL "BEGIN :RET := NutritionCalcPackage.NutritionCalc(:UPDUSER, :IPADDRESS, :CSLDATE,:DAYIDFLG,:STRDAYID,:ENDDAYID,:ARRDAYID ); END;"
                'Ａ型行動パターン
                Case 1
                '失点判定
                Case 2
                'ストレス点数
                Case 3
            End Select
        End If
    Next i

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    nutritionCalcStart = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    nutritionCalcStart = -99

    'イベントログ書き込み
    WriteErrorLog "nutritionCalc.nutritionCalcStart"
    
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

    'オブジェクトコンテキストの解放
    Set mobjContext = Nothing

End Sub
