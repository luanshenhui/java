VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "DmdAddUp"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 請求締め処理入力値の妥当性チェックを行う
'
' 引数　　 : (In)   lngCloseYear    締め日(年)
' 　　　　 : (In)   lngCloseMonth   締め日(月)
' 　　　　 : (In)   lngCloseDay     締め日(日)
' 　　　　 : (In)   lngStrYear      開始受診日(年)
' 　　　　 : (In)   lngStrMonth     開始受診日(月)
' 　　　　 : (In)   lngStrDay       開始受診日(日)
' 　　　　 : (In)   lngEndYear      終了受診日(年)
' 　　　　 : (In)   lngEndMonth     終了受診日(月)
' 　　　　 : (In)   lngEndDay       終了受診日(日)
' 　　　　 : (In)   strOrgCd1       団体コード１
' 　　　　 : (In)   strOrgCd2       団体コード２
'' 　　　　 : (In)   strCsCd         コースコード
'' 　　　　 : (In)   strStaDiv       統計区分
' 　　　　 : (Out)  vntCloseDate    締め日
' 　　　　 : (Out)  vntStrDate      開始受診日
' 　　　　 : (Out)  vntEndDate      終了受診日
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueDmdAddUp(ByVal lngCloseYear As Long, _
                                   ByVal lngCloseMonth As Long, _
                                   ByVal lngCloseDay As Long, _
                                   ByVal lngStrYear As Long, _
                                   ByVal lngStrMonth As Long, _
                                   ByVal lngStrDay As Long, _
                                   ByVal lngEndYear As Long, _
                                   ByVal lngEndMonth As Long, _
                                   ByVal lngEndDay As Long, _
                                   ByVal strOrgCd1 As String, _
                                   ByVal strOrgCd2 As String, _
                                   ByRef vntCloseDate As Variant, _
                                   ByRef vntStrDate As Variant, _
                                   ByRef vntEndDate As Variant _
                                  ) As Variant
    
'    Dim objCommon               As Common           '共通クラス
    Dim objCommon               As Object           '共通クラス
    Dim vntArrMessage           As Variant          'エラーメッセージの集合
    Dim vntWorkDate             As Variant
    Dim strCloseDate            As String
    Dim strStrDate              As String
    Dim strEndDate              As String
'    Dim fileno
'    Dim filename                As String
'    Dim strMsg                  As String
    
'    filename = "c:\temp\aoyagi.debug"
'    fileno = FreeFile
'
'    Open filename For Output As #fileno
'    Write #fileno, "***** start ***** "
'
'    Write #fileno, "Param:" & Str(lngCloseYear) & "," & Str(lngCloseMonth) & "," & Str(lngCloseDay)
'    Write #fileno, "Param:" & Str(lngStrYear) & "," & Str(lngStrMonth) & "," & Str(lngStrDay)
'    Write #fileno, "Param:" & Str(lngEndYear) & "," & Str(lngEndMonth) & "," & Str(lngEndDay)
'    Write #fileno, "Param:" & strOrgCd1 & "," & strOrgCd2
'
'On Error GoTo Err
    
    '初期処理
    CheckValueDmdAddUp = Empty
    vntArrMessage = Empty


    '共通クラスのインスタンス作成
'    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    Set objCommon = CreateObject("HainsCommon.Common")

    '各値チェック処理
    With objCommon

    Do
            '締め日
            .AppendArray vntArrMessage, .CheckDate("締め日", lngCloseYear, lngCloseMonth, lngCloseDay, vntCloseDate, CHECK_NECESSARY)

            '開始受診日
            .AppendArray vntArrMessage, .CheckDate("開始受診日", lngStrYear, lngStrMonth, lngStrDay, vntStrDate, CHECK_NECESSARY)

            '終了受診日
            .AppendArray vntArrMessage, .CheckDate("終了受診日", lngEndYear, lngEndMonth, lngEndDay, vntEndDate, CHECK_NECESSARY)


            '開始受診日・終了受診日の大小
            strStrDate = Str(lngStrYear) & "/" & Str(lngStrMonth) & "/" & Str(lngStrDay)
            strEndDate = Str(lngEndYear) & "/" & Str(lngEndMonth) & "/" & Str(lngEndDay)
            If IsDate(strStrDate) And IsDate(strEndDate) Then
                If DateDiff("d", CDate(strStrDate), CDate(strEndDate)) < 0 Then
'### 2002.12.26 Modified by Ishihara@FSIT 大小逆なら入れ替えてあげればいいじゃん
'                    .AppendArray vntArrMessage, "受診日の入力範囲が正しくありません。"
                    vntWorkDate = vntEndDate
                    vntEndDate = vntStrDate
                    vntStrDate = vntWorkDate
'### 2002.12.26 Modified End
                End If
            End If

'### 2002.12.26 Deleted by Ishihara@FSIT 東急締め処理には不要ざます
'            '団体コード
'            If Trim(strOrgCd1) = "" And Trim(strOrgCd2) <> "" Then
'                .AppendArray vntArrMessage, "団体コードが不正です。"
'            End If
'
'            'コースコード・統計区分
'            If Trim(strCsCd) <> "" And Trim(strStaDiv) <> "" Then
'                .AppendArray vntArrMessage, "コースコードと統計区分は、どちらか一方のみ指定可能です。"
'            End If
'
'            '統計区分
'            If Trim(strStaDiv) <> "" Then
'                .AppendArray vntArrMessage, .CheckNumeric("統計区分", strStaDiv, LENGTH_STADIV)
'            End If
'### 2002.12.26 Deleted End
        Exit Do
        Loop
    End With
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueDmdAddUp = vntArrMessage
    End If
    
    Set objCommon = Nothing
'    Write #fileno, "***** end(normal) ***** "
'    Close #fileno
    
    Exit Function

'Err:
'    Write #fileno, Err.Number & ":" & Err.Description
'
'    CheckValueDmdAddUp = "失敗"
'
'    Write #fileno, "***** end(abort) ***** "
'    Close #fileno
'    Set objCommon = Nothing
    
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
