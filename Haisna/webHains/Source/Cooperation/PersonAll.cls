VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "PersonAll"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSession       'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const TRANSACTIONDIV_UPDSTA As String = "LOGUPDSTA" '使用状態更新用のログ処理ＩＤ

'
' 機能　　 : 個人テーブルレコードの使用中フラグを更新する
'
' 引数　　 : (In)     strPerId   個人ＩＤ
' 　　　　   (In)     lngDelFlg  使用中フラグ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Private Function UpdatePerson(ByVal strPerId As String, ByRef lngDelFlg As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DELFLG", lngDelFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        
    '個人テーブルレコードの更新
'### 2003/06/25 Updated by Ishihara@FSIT おいおい
'    mobjOraDb.ExecuteSQL "UPDATE PERSON SET DELFLG = DELFLG WHERE PERID = :PERID"
    mobjOraDb.ExecuteSQL "UPDATE PERSON SET DELFLG = :DELFLG WHERE PERID = :PERID"
'### 2003/06/25 Updated End
    
    '戻り値の設定
    UpdatePerson = True

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    UpdatePerson = False
    
    'イベントログ書き込み
    WriteErrorLog "PersonAll.UpdatePerson"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 長期未受診者の使用中フラグを更新する
'
' 引数　　 : (In)     strOrgCd1      団体コード１
' 　　　　   (In)     strOrgCd2      団体コード２
' 　　　　   (In)     dtmStrCslDate  開始受診日
' 　　　　   (In)     dtmEndCslDate  終了受診日
' 　　　　   (In)     lngDelFlg      使用中フラグ
'
' 戻り値　 : 更新レコード数
'
' 備考　　 :
'
Public Function UpdateStatus(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, ByVal lngDelFlg As Long) As Long

    Dim objHainsLog         As Object       'ログ情報アクセス用
    Dim objOrganization     As Object       '団体情報アクセス用
    Dim objRegistPerson     As RegistPerson '個人情報登録用
    
    Dim lngTransactionId    As Long         'トランザクションＩＤ
    
    Dim vntOrgSName         As Variant      '団体略称
    Dim strDelFlg           As String       '使用中フラグの名称
    
    Dim vntPerId            As Variant      '個人ＩＤ
    Dim vntLastName         As Variant      '姓
    Dim vntFirstName        As Variant      '名
    Dim lngReadCount        As Long         '読み込みレコード数
    Dim lngPerCount         As Long         '更新された個人情報数
    
    Dim strMessage          As String       'メッセージ１
    Dim Ret                 As Boolean      '関数戻り値
    Dim i                   As Long         'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    Set objRegistPerson = CreateObject("HainsCooperation.RegistPerson")
    
    'トランザクションＩＤ・区分・表題の取得
    lngTransactionId = objHainsLog.IncreaseTransactionId()
    Set objHainsLog = Nothing
    
    '開始ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_UPDSTA, "I", "", "長期未受診者の使用状態更新処理を開始します。", ""
    
    '指定されたパラメータ情報を編集する
    Do
    
        '団体略称の取得
        Set objOrganization = CreateObject("HainsOrganization.Organization")
        If objOrganization.SelectOrg(strOrgCd1, strOrgCd2, , , , vntOrgSName) = False Then
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_UPDSTA, "E", "", "団体情報が存在しません。", "団体コード=" & strOrgCd1 & "-" & strOrgCd2
            Exit Do
        End If
        
        Set objOrganization = Nothing
        
        'ログ発行
        PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_UPDSTA, "I", "", "■次の団体が指定されました。", "団体=" & vntOrgSName & "（" & strOrgCd1 & "-" & strOrgCd2 & "）"
        PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_UPDSTA, "I", "", "■次の受診期間が指定されました。", "受診期間=" & Format(dtmStrCslDate, "yyyy/m/d") & "～" & Format(dtmEndCslDate, "yyyy/m/d")
        
        Select Case lngDelFlg
            Case 0
                strDelFlg = "使用中"
            Case 1
                strDelFlg = "削除済（退職扱い）"
            Case 2
                strDelFlg = "休職中"
            Case Else
                strDelFlg = "？？？"
        End Select
        PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_UPDSTA, "I", "", "■次の使用状態が指定されました。", "使用状態=" & strDelFlg & "（" & lngDelFlg & "）"
    
        '指定団体の指定期間における未受診者を取得
        lngReadCount = objRegistPerson.SelectPersonNotConsult(strOrgCd1, strOrgCd2, dtmStrCslDate, dtmEndCslDate, vntPerId, vntLastName, vntFirstName)
        If lngReadCount <= 0 Then
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_UPDSTA, "I", "", "更新対象となる個人情報は存在しませんました。", ""
            Exit Do
        End If
        
        For i = 0 To lngReadCount - 1
                
            '個人情報の使用中フラグを更新
            UpdatePerson vntPerId(i), lngDelFlg
            
            'ログ発行
            strMessage = "氏名=" & Trim(vntLastName(i) & "　" & vntFirstName(i)) & "（" & vntPerId(i) & "）"
            PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_UPDSTA, "I", "", "個人情報が更新されました。", strMessage

            '更新個人情報数のインクリメント
            lngPerCount = lngPerCount + 1
    
        Next i
        
        Exit Do
    Loop

    '終了ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, TRANSACTIONDIV_UPDSTA, "I", "", "長期未受診者の使用状態更新処理を終了します。", ""

    '戻り値の設定
    UpdateStatus = lngPerCount
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PersonAll.UpdateStatus"
    
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

