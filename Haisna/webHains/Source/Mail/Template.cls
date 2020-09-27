VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Template"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.6
'担当者  ：T.Takagi@RD
'修正内容：新規作成

Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : メールテンプレートの一覧を取得する
'
' 引数　　 : (Out)    vntTemplateCd   テンプレートコード
' 　　　　 : (Out)    vntTemplateName テンプレート名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectMailTemplateList(ByRef vntTemplateCd As Variant, ByRef vntTemplateName As Variant) As Long

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objTemplateCd           As OraField         'テンプレートコード
    Dim objTemplateName         As OraField         'テンプレート名

    Dim vntArrTemplateCd()      As Variant          'テンプレートコードの配列
    Dim vntArrTemplateName()    As Variant          'テンプレート名の配列
    Dim lngCount                As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntTemplateCd = Empty
    vntTemplateName = Empty
    SelectMailTemplateList = 0
    lngCount = 0

    'テンプレートテーブルよりレコードを取得
    strStmt = "SELECT TEMPLATECD, TEMPLATENAME " & vbLf & _
              "  FROM MAILTEMPLATE             " & vbLf & _
              " ORDER BY TEMPLATECD            "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objTemplateCd = objFields("TEMPLATECD")
        Set objTemplateName = objFields("TEMPLATENAME")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrTemplateCd(lngCount)
            ReDim Preserve vntArrTemplateName(lngCount)
            vntArrTemplateCd(lngCount) = objTemplateCd.Value & ""
            vntArrTemplateName(lngCount) = objTemplateName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

    End If

    '戻り値の設定
    vntTemplateCd = vntArrTemplateCd
    vntTemplateName = vntArrTemplateName

    SelectMailTemplateList = lngCount

    Set objOraDyna = Nothing

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Template.SelectMailTemplateList"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : メールテンプレートデータを取得する
'
' 引数　　 : (In)     strTemplateCd    テンプレートコード
' 　　　　   (Out)    vntTemplateName  テンプレート名
' 　　　　   (Out)    vntSubject       表題
' 　　　　   (Out)    vntBody          本文
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectMailTemplate( _
    ByVal strTemplateCd As String, _
    ByRef vntTemplateName As Variant, _
    ByRef vntSubject As Variant, _
    ByRef vntBody As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objTemplateName As OraField         'テンプレート名
    Dim objSubject      As OraField         '表題
    Dim objBody         As OraField         '本文

    Dim objCLob         As OraClob          'OraCLobオブジェクト
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "TEMPLATECD", Trim(strTemplateCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たすメールテンプレートテーブルのレコードを取得
    strStmt = "SELECT TEMPLATENAME, SUBJECT, BODY " & vbLf & _
              "  FROM MAILTEMPLATE                " & vbLf & _
              " WHERE TEMPLATECD = :TEMPLATECD    "

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objTemplateName = objFields("TEMPLATENAME")
        Set objSubject = objFields("SUBJECT")
        Set objBody = objFields("BODY")

        '戻り値の設定
        vntTemplateName = objTemplateName.Value
        vntSubject = objSubject.Value

        Set objCLob = objBody.Value
        objCLob.Read vntBody

        SelectMailTemplate = True

    End If

    'バインド変数の削除
    objOraParam.Remove "TEMPLATECD"

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Template.SelectMailTemplate"

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : メールテンプレートテーブルレコードを登録する
'
' 引数　　 : (In)    strMode         登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strTemplateCd   テンプレートコード
' 　　　　   (In)    strTemplateName テンプレート名
' 　　　　   (In)    strSubject      表題
' 　　　　   (In)    strBody         本文
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistMailTemplate( _
    ByVal strMode As String, _
    ByVal strTemplateCd As String, _
    ByVal strTemplateName As String, _
    ByVal strSubject As String, _
    ByVal strBody As String _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim objCLob     As OraClob          'OraCLobオブジェクト
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    Ret = INSERT_ERROR

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "TEMPLATECD", Trim(strTemplateCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TEMPLATENAME", Trim(strTemplateName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SUBJECT", Trim(strSubject), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BODY", Null, ORAPARM_INPUT, ORATYPE_CLOB

    Set objCLob = mobjOraDb.CreateTempClob
    objCLob.Write strBody
    mobjOraDb.Parameters("BODY").Value = objCLob
    
    Do
        
        'メールテンプレートテーブルレコードの更新
        If strMode = "UPD" Then
            
            strStmt = "UPDATE MAILTEMPLATE                  " & vbLf & _
                      "   SET TEMPLATENAME = :TEMPLATENAME, " & vbLf & _
                      "       SUBJECT      = :SUBJECT,      " & vbLf & _
                      "       BODY         = :BODY          " & vbLf & _
                      " WHERE TEMPLATECD   = :TEMPLATECD    "
            
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        
        End If

        '検索条件を満たすメールテンプレートテーブルのレコードを取得
        strStmt = "SELECT TEMPLATECD               " & vbLf & _
                  "  FROM MAILTEMPLATE             " & vbLf & _
                  " WHERE TEMPLATECD = :TEMPLATECD "
        
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO MAILTEMPLATE ( " & vbLf & _
                             "       TEMPLATECD,         " & vbLf & _
                             "       TEMPLATENAME,       " & vbLf & _
                             "       SUBJECT,            " & vbLf & _
                             "       BODY                " & vbLf & _
                             ") VALUES (                 " & vbLf & _
                             "       :TEMPLATECD,        " & vbLf & _
                             "       :TEMPLATENAME,      " & vbLf & _
                             "       :SUBJECT,           " & vbLf & _
                             "       :BODY               " & vbLf & _
                             ")                          "
        
        Ret = INSERT_NORMAL

        Exit Do
    Loop

    'バインド変数の削除
    objOraParam.Remove "TEMPLATECD"
    objOraParam.Remove "TEMPLATENAME"
    objOraParam.Remove "SUBJECT"
    objOraParam.Remove "BODY"

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    RegistMailTemplate = Ret

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Template.RegistMailTemplate"

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'その他の戻り値設定
    RegistMailTemplate = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : メールテンプレートテーブルレコードを削除する
'
' 引数　　 : (In)    strTemplateCd テンプレートコード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteMailTemplate(ByVal strTemplateCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "TEMPLATECD", Trim(strTemplateCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'メールテンプレートテーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE MAILTEMPLATE WHERE TEMPLATECD = :TEMPLATECD"

    'バインド変数の削除
    objOraParam.Remove "TEMPLATECD"

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    DeleteMailTemplate = True

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Template.DeleteMailTemplate"

    DeleteMailTemplate = False

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

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
