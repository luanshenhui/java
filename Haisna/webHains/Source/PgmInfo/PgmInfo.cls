VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "PgmInfo"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext      As ObjectContext      'オブジェクトコンテキスト

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト


'
' 機能　　 : プログラム情報テーブルレコードを削除する
' 引数　　 : (In)    strPgmCd    プログラムコード
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
' 備考　　 :
'
Public Function DeletePgmInfo(ByVal strPgmCd As String) As Boolean
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PGMCD", Trim(strPgmCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'セット分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE PGMINFO WHERE PGMCD = :PGMCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeletePgmInfo = True

    Exit Function
    
ErrorHandle:

    DeletePgmInfo = False

    'イベントログ書き込み
    WriteErrorLog "PgmInfo.DeletePgmInfo"
    
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
' 機能　　 : ユーザーグループ別プログラム情報テーブルレコードを削除する
' 引数　　 : (In)    strUsrGrpCd    ユーザーグループコード
'            (In)    strPgmCd       プログラムコード
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
' 備考　　 :
'
Public Function DeleteGrp_PgmInfo(ByVal strUsrGrpCd As String, _
                                  ByVal strPgmCd As String _
                                  ) As Boolean
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "USRGRPCD", Trim(strUsrGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PGMCD", Trim(strPgmCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'セット分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE GRP_PGMINFO WHERE USRGRPCD = :USRGRPCD AND PGMCD = :PGMCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteGrp_PgmInfo = True

    Exit Function
    
ErrorHandle:

    DeleteGrp_PgmInfo = False

    'イベントログ書き込み
    WriteErrorLog "PgmInfo.DeleteGrp_PgmInfo"
    
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
'    Set mobjOraDb = mobjOraSession.OpenDatabase(objCommon.ConnectString, objCommon.UserName & "/" & objCommon.Password, 0)
    
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

'
' 機能　　 : 検索条件を満たす依頼項目名の一覧を取得する
'
' 引数　　 : (In)     strSelectKey            検索条件キー
' 　　　　 : (In)     intSelectMode           検索条件
'          　(0:PgmCdで検索  , 1:メニューグループコードで  , 2:すべて )
' 　　　　 : (Out)    vntPgmCd                プログラムコード
' 　　　　 : (Out)    vntPgmName              プログラム名
' 　　　　 : (Out)    vntStartPgm             起動プログラム
' 　　　　 : (Out)    vntFilePath
' 　　　　 : (Out)    vntLinkImage            リンクイメージ
' 　　　　 : (Out)    vntMenuGrpCd            メニューグループコード
' 　　　　 : (Out)    vntPgmDesc              プログラム説明
' 　　　　 : (Out)    vntDelFlag            　使用可否フラッグ
' 　　　　 : (Out)    vntDispSeq            　画面標示順序
'
' 戻り値　 : 検索条件を満たすレコード件数
' 備考　　 :
'
Public Function SelectPgmInfo(ByVal strSelectKey As String, _
                                 ByVal intSelectMode As Integer, _
                                 ByRef vntPgmCd As Variant, _
                                 ByRef vntPgmName As Variant, _
                                 ByRef vntStartPgm As Variant, _
                                 ByRef vntFilePath As Variant, _
                                 ByRef vntLinkImage As Variant, _
                                 ByRef vntMenuGrpCd As Variant, _
                                 ByRef vntPgmDesc As Variant, _
                                 ByRef vntDelFlag As Variant, _
                                 Optional ByRef vntMenuName As Variant, _
                                 Optional ByRef vntYudoBunrui As Variant, _
                                 Optional ByRef vntYobi1 As Variant, _
                                 Optional ByRef vntYobi2 As Variant _
                                 ) As Long

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPgmCd                As OraField         'プログラムコード
    Dim objPgmName              As OraField         'プログラム名
    Dim objStartPgm             As OraField         '起動プログラム(File名)
    Dim objFilePath             As OraField         'プログラムファイル経路
    Dim objLinkImage            As OraField         'リンクイメージ
    Dim objMenuGrpCd            As OraField         'メニューグループコード
    Dim objPgmDesc              As OraField         'プログラム説明
    Dim objDelFlag              As OraField         '使用可否フラッグ
    Dim objDispSeq              As OraField         '画面標示順序
    Dim objMenuName             As OraField
    Dim objYudoBunrui           As OraField
    Dim objYobi1                As OraField
    Dim objYobi2                As OraField
    
    Dim vntArrPgmCd()           As Variant          'プログラムコードの配列
    Dim vntArrPgmName()         As Variant          'プログラム名の配列
    Dim vntArrStartPgm()        As Variant          '起動プログラム名の配列
    Dim vntArrFilePath()        As Variant          'プログラムファイル経路の配列
    Dim vntArrLinkImage()       As Variant          'リンクイメージの配列
    Dim vntArrMenuGrpCd()       As Variant          'メニューグループコードの配列
    Dim vntArrPgmDesc()         As Variant          'プログラム説明
    Dim vntArrDelFlag()         As Variant          '使用可否フラッグ
    Dim vntArrDispSeq()         As Variant          '画面標示順序
    Dim vntArrMenuName()        As Variant
    Dim vntArrYudoBunrui()      As Variant
    Dim vntArrYobi1()           As Variant
    Dim vntArrYobi2()           As Variant

    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntPgmCd = Empty
    vntPgmName = Empty
    vntStartPgm = Empty
    vntFilePath = Empty
    vntMenuGrpCd = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    Select Case intSelectMode
        Case 0
            objOraParam.Add "PGMCODE", Trim(strSelectKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
        Case 1, 2
            objOraParam.Add "MENUGRPCD", Trim(strSelectKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End Select
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = "SELECT PgmCd,      PgmName,      PgmFileName,    PgmFilePath,    " & vbLf & _
              "       LinkImage,  MenuGrpCd,    PgmDesc,        delFlg,         " & vbLf & _
              "       YudoBunrui, Yobi1,        Yobi2                          " & vbLf & _
              "       ,FREE.FREEFIELD1 MenuName                                 " & vbLf & _
              "  FROM PGMINFO,  FREE                                                   "

    Select Case CInt(intSelectMode)
        Case 0
            strStmt = strStmt & vbLf & _
                      " WHERE PgmCd    = :PGMCODE           " & vbLf & _
                      "     AND FREE.FREECLASSCD = 'PGM'    " & vbLf & _
                      "     AND MENUGRPCD =  FREE.FREECD    "
        Case 1
            strStmt = strStmt & vbLf & _
                      " WHERE MenuGrpCd  = :MENUGRPCD       " & vbLf & _
                      "     AND PGMINFO.DELFLG = 0          " & vbLf & _
                      "     AND FREE.FREECLASSCD = 'PGM'    " & vbLf & _
                      "     AND MENUGRPCD =  FREE.FREECD    "
        Case 2
            strStmt = strStmt & vbLf & _
                      " WHERE MenuGrpCd  = :MENUGRPCD       " & vbLf & _
                      "     AND FREE.FREECLASSCD = 'PGM'    " & vbLf & _
                      "     AND MENUGRPCD =  FREE.FREECD    "
                      
    End Select
              
    strStmt = strStmt & vbLf & _
              " ORDER BY PgmCd"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPgmCd = objFields("PGMCD")
        Set objPgmName = objFields("PGMNAME")
        Set objStartPgm = objFields("PGMFILENAME")
        Set objFilePath = objFields("PGMFILEPATH")
        Set objLinkImage = objFields("LINKIMAGE")
        Set objMenuGrpCd = objFields("MENUGRPCD")
        Set objPgmDesc = objFields("PGMDESC")
        Set objDelFlag = objFields("DELFLG")
        Set objMenuName = objFields("MENUNAME")
        Set objYudoBunrui = objFields("YudoBunrui")
        Set objYobi1 = objFields("Yobi1")
        Set objYobi2 = objFields("Yobi2")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPgmCd(lngCount)
            ReDim Preserve vntArrPgmName(lngCount)
            ReDim Preserve vntArrStartPgm(lngCount)
            ReDim Preserve vntArrFilePath(lngCount)
            ReDim Preserve vntArrLinkImage(lngCount)
            ReDim Preserve vntArrMenuGrpCd(lngCount)
            ReDim Preserve vntArrPgmDesc(lngCount)
            ReDim Preserve vntArrDelFlag(lngCount)
            ReDim Preserve vntArrMenuName(lngCount)
            ReDim Preserve vntArrYudoBunrui(lngCount)
            ReDim Preserve vntArrYobi1(lngCount)
            ReDim Preserve vntArrYobi2(lngCount)
            
            vntArrPgmCd(lngCount) = objPgmCd.Value & ""
            vntArrPgmName(lngCount) = objPgmName.Value & ""
            vntArrStartPgm(lngCount) = objStartPgm.Value & ""
            vntArrFilePath(lngCount) = objFilePath.Value & ""
            vntArrLinkImage(lngCount) = objLinkImage.Value & ""
            vntArrMenuGrpCd(lngCount) = objMenuGrpCd.Value & ""
            vntArrPgmDesc(lngCount) = objPgmDesc.Value & ""
            vntArrDelFlag(lngCount) = objDelFlag.Value & ""
            vntArrMenuName(lngCount) = objMenuName.Value & ""
            vntArrYudoBunrui(lngCount) = objYudoBunrui.Value & ""
            vntArrYobi1(lngCount) = objYobi1.Value & ""
            vntArrYobi2(lngCount) = objYobi2.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntPgmCd = vntArrPgmCd
    vntPgmName = vntArrPgmName
    vntStartPgm = vntArrStartPgm
    If IsMissing(vntFilePath) = False Then vntFilePath = vntArrFilePath
    If IsMissing(vntLinkImage) = False Then vntLinkImage = vntArrLinkImage
    vntMenuGrpCd = vntArrMenuGrpCd
    If IsMissing(vntPgmDesc) = False Then vntPgmDesc = vntArrPgmDesc
    If IsMissing(vntDelFlag) = False Then vntDelFlag = vntArrDelFlag
    If IsMissing(vntMenuName) = False Then vntMenuName = vntArrMenuName
    
    If IsMissing(vntYudoBunrui) = False Then vntYudoBunrui = vntArrYudoBunrui
    If IsMissing(vntYobi1) = False Then vntYobi1 = vntArrYobi1
    If IsMissing(vntYobi2) = False Then vntYobi2 = vntArrYobi2

    SelectPgmInfo = lngCount
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "PgmInfo.SelectPgmInfo"
    
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
' 機能　　 : プログラム情報レコードを登録する
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　 : (In)    strPgmCd               プログラムコード
' 　　　　 : (In)    strPgmName             プログラム名
' 　　　　 : (In)    strStartPgm            起動プログラム
' 　　　　 : (In)    strFilePath
' 　　　　 : (In)    strLinkImage           リンクイメージ
' 　　　　 : (In)    strMenuGrpCd           メニューグループコード
' 　　　　 : (In)    strPgmDesc             プログラム説明
' 　　　　 : (In)    intDelFlag             使用可否フラッグ
' 　　　　 : (In)    intDispSeq             画面標示順序
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistPgmInfo(ByVal strMode As String, _
                            ByVal strPgmCd As String, _
                            ByVal strPgmName As String, _
                            ByVal strStartPgm As String, _
                            ByVal strFilePath As String, _
                            ByVal strLinkImage As String, _
                            ByVal strMenuGrpCd As String, _
                            ByVal strPgmDesc As String, _
                            ByVal intDelFlag As Integer, _
                            ByVal strYudoBunrui As String, _
                            ByVal strYobi1 As String, _
                            ByVal strYobi2 As String _
                            ) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PGMCD", Trim(strPgmCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PGMNAME", Trim(strPgmName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STARTPGM", Trim(strStartPgm), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FILEPATH", Trim(strFilePath), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LINKIMAGE", Trim(strLinkImage), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MENUGRPCD", Trim(strMenuGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PGMDESC", Trim(strPgmDesc), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DELFLAG", intDelFlag, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "YUDOBUNRUI", Trim(strYudoBunrui), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "YOBI1", Trim(strYobi1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "YOBI2", Trim(strYobi2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    Do
        'コーステーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = ""
            strStmt = " UPDATE PGMINFO                                                 " & vbCrLf & _
                        " SET PGMNAME     = :PGMNAME,     PGMFILENAME = :STARTPGM,     " & vbCrLf & _
                        "     PGMFILEPATH = :FILEPATH,                                 " & vbCrLf & _
                        "     LINKIMAGE   = :LINKIMAGE,   MENUGRPCD   = :MENUGRPCD,    " & vbCrLf & _
                        "     PGMDESC     = :PGMDESC,     DELFLG      = :DELFLAG,      " & vbCrLf & _
                        "     YUDOBUNRUI  = :YUDOBUNRUI,                               " & vbCrLf & _
                        "     YOBI1       = :YOBI1,       YOBI2       = :YOBI2         " & vbCrLf & _
                        " WHERE PGMCD   = :PGMCD                                       "
            
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たすコーステーブルのレコードを取得
        strStmt = "SELECT PGMCD FROM PGMINFO WHERE PGMCD = :PGMCD "
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        '存在した場合、新規挿入不可
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '新規挿入
        strStmt = ""
        strStmt = " INSERT INTO PGMINFO (PGMCD,       PGMNAME,   PGMFILENAME,  PGMFILEPATH,   " & vbLf & _
                  "                      LINKIMAGE,   MENUGRPCD, PGMDESC,   DELFLG,           " & vbLf & _
                  "                      YUDOBUNRUI,  YOBI1,     YOBI2                    )   " & vbLf & _
                  "              VALUES (:PGMCD,      :PGMNAME,    :STARTPGM,  :FILEPATH,     " & vbLf & _
                  "                      :LINKIMAGE,  :MENUGRPCD,  :PGMDESC,   :DELFLAG,      " & vbLf & _
                  "                      :YUDOBUNRUI, :YOBI1,      :YOBI2  )                  "
                  
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    RegistPgmInfo = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistPgmInfo = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "PgmInfo.RegistPgmInfo"
    
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
' 機能　　 : ユーザーグループ別プログラム情報レコードを登録する
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　 : (In)    strUsrGrpCd            ユーザーグループ
' 　　　　 : (In)    strPgmCd               プログラムコード
' 　　　　 : (In)    strPgmGrant            プログラム操作権限
' 　　　　 : (In)    intDispSeq             画面標示順序
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistGrp_PgmInfo(ByVal strMode As String, _
                            ByVal strUsrGrpCd As String, _
                            ByVal vntPgmCd As Variant, _
                            ByVal vntPgmGrant As Variant, _
                            ByVal vntDispSeq As Variant, _
                            ByVal intItemCount As Integer) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    
    Dim objUsrGrpCd     As OraParamArray    'ユーザーグループコード
    Dim objPgmCd        As OraParamArray    'プログラムコード
    Dim objPgmGrant     As OraParamArray    'プログラム操作権限
    Dim objDispSeq      As OraParamArray    '画面標示順序
    
    Dim strStmt         As String           'SQLステートメント
    Dim Ret             As Long             '関数戻り値
    Dim i               As Integer
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "USRGRPCD", Trim(strUsrGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'グループ内プログラム項目レコードの削除
    mobjOraDb.ExecuteSQL "DELETE GRP_PGMINFO WHERE USRGRPCD = :USRGRPCD"


    If intItemCount > 0 Then
        'キー及び更新値の設定再割り当て
        objOraParam.Remove "USRGRPCD"
        objOraParam.AddTable "USRGRPCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 12
        objOraParam.AddTable "PGMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, intItemCount, 12
        objOraParam.AddTable "PGMGRANT", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, 1
        objOraParam.AddTable "DISPSEQ", ORAPARM_INPUT, ORATYPE_NUMBER, intItemCount, 3
    
        Set objUsrGrpCd = objOraParam("USRGRPCD")
        Set objPgmCd = objOraParam("PGMCD")
        Set objPgmGrant = objOraParam("PGMGRANT")
        Set objDispSeq = objOraParam("DISPSEQ")
        
        'OraParameterオブジェクトの値設定
        For i = 0 To intItemCount - 1
            objUsrGrpCd(i) = strUsrGrpCd
            objPgmCd(i) = vntPgmCd(i)
            objPgmGrant(i) = vntPgmGrant(i)
            objDispSeq(i) = vntDispSeq(i)
        Next i
    
    
        '新規挿入
        strStmt = ""
        strStmt = " INSERT INTO GRP_PGMINFO (USRGRPCD,  PGMCD, PGMGRANT, DISPSEQ )  " & vbLf & _
                  " VALUES (:USRGRPCD, :PGMCD, :PGMGRANT, :DISPSEQ )"
        
        mobjOraDb.ExecuteSQL strStmt
    
    End If
    
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    Ret = INSERT_NORMAL
    RegistGrp_PgmInfo = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:
    'その他の戻り値設定
    RegistGrp_PgmInfo = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "PgmInfo.RegistGrp_PgmInfo"
    
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
' 機能　　 : 検索条件を満たす依頼項目名の一覧を取得する
'
' 引数　　 : (In)     strSelectKey            検索条件キー
' 　　　　 : (In)     intSelectMode           検索条件     (1:ユーザーグループで検索  )
' 　　　　 : (Out)    vntUsrGrpCd             ユーザーグループ
' 　　　　 : (Out)    vntPgmCd                プログラムコード
' 　　　　 : (Out)    vntPgmName              プログラム名称
' 　　　　 : (Out)    vntPgmGrant             プログラム操作権限フラグ
'         : (Out)    vntGrantName             プログラム操作権限名
' 　　　　 : (Out)    vntDispSeq              画面表示順序
'
' 戻り値　 : 検索条件を満たすレコード件数
' 備考　　 :
'
Public Function SelectGrp_PgmInfoList(ByVal strSelectKey As String, _
                                 ByVal intSelectMode As Integer, _
                                 ByRef vntUsrGrpCd As Variant, _
                                 ByRef vntPgmCd As Variant, _
                                 ByRef vntPgmName As Variant, _
                                 ByRef vntPgmFileName As Variant, _
                                 ByRef vntPgmGrant As Variant, _
                                 ByRef vntGrantName As Variant, _
                                 ByRef vntDispSeq As Variant, _
                                 Optional ByRef vntDelFlg As Variant, _
                                 Optional ByRef vntMenuName As Variant _
                                 ) As Long

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objUsrGrpCd             As OraField         'ユーザーグループ
    Dim objPgmCd                As OraField         'プログラムコード
    Dim objPgmName              As OraField         '業務名称
    Dim objPgmFileName          As OraField         'プログラム名称
    Dim objPgmGrant             As OraField         'プログラム操作権限
    Dim objGrantName            As OraField         'プログラム操作権限
    Dim objDispSeq              As OraField         '画面標示順序
    Dim objDelFlg               As OraField
    Dim objMenuName             As OraField
    
    Dim vntArrUsrGrpCd()        As Variant          'ユーザーグループの配列
    Dim vntArrPgmCd()           As Variant          'プログラムコードの配列
    Dim vntArrPgmName()         As Variant          '業務名称の配列
    Dim vntArrPgmFileName()     As Variant          'プログラムコ名称の配列
    Dim vntArrPgmGrant()        As Variant          'プログラム操作権限の配列
    Dim vntArrGrantName()       As Variant          'プログラム操作権限の配列
    Dim vntArrDispSeq()         As Variant          '画面標示順序
    Dim vntArrDelFlg()          As Variant
    Dim vntArrMenuName()        As Variant

    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntUsrGrpCd = Empty
    vntPgmCd = Empty
    vntPgmGrant = Empty
    vntDispSeq = Empty
    vntDelFlg = Empty
    vntMenuName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    If intSelectMode = 1 Then
        objOraParam.Add "USRGRPCD", Trim(strSelectKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '検索条件を満たす依頼項目テーブルのレコードを取得
    strStmt = " SELECT  B.USRGRPCD,   B.PGMCD,       B.PGMGRANT,   B.DISPSEQ,      A.DELFLG,      " & vbLf & _
              "         A.PGMNAME,    A.PGMFILENAME, A.LINKIMAGE,   A.MENUGRPCD,    A.PGMDESC,    " & vbLf & _
              "         C.FREEFIELD1 MENUNAME ,                                                             " & vbLf & _
              "         DECODE(B.PGMGRANT,1,'参照のみ',2,'登録(変更)',3,'削除',4,'スーパーユーザ') GRANTNAME    " & vbLf & _
              " FROM    PGMINFO A   , GRP_PGMINFO B   , FREE C                                " & vbLf & _
              " WHERE   A.PGMCD         = B.PGMCD               " & vbLf & _
              "     AND C.FREECLASSCD   = 'PGM'                 " & vbLf & _
              "     AND A.MENUGRPCD     = C.FREECD              "
              

    If intSelectMode = 1 Then
        strStmt = strStmt & vbLf & _
                      "     AND B.USRGRPCD    = :USRGRPCD   "
    End If
          
    strStmt = strStmt & vbLf & _
              " ORDER BY B.USRGRPCD,  B.DISPSEQ    "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objUsrGrpCd = objFields("USRGRPCD")
        Set objPgmCd = objFields("PGMCD")
        Set objPgmName = objFields("PGMNAME")
        Set objPgmFileName = objFields("PGMFILENAME")
        Set objPgmGrant = objFields("PGMGRANT")
        Set objGrantName = objFields("GRANTNAME")
        Set objDispSeq = objFields("DISPSEQ")
        Set objDelFlg = objFields("DELFLG")
        Set objMenuName = objFields("MENUNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrUsrGrpCd(lngCount)
            ReDim Preserve vntArrPgmCd(lngCount)
            ReDim Preserve vntArrPgmName(lngCount)
            ReDim Preserve vntArrPgmFileName(lngCount)
            ReDim Preserve vntArrPgmGrant(lngCount)
            ReDim Preserve vntArrGrantName(lngCount)
            ReDim Preserve vntArrDispSeq(lngCount)
            ReDim Preserve vntArrDelFlg(lngCount)
            ReDim Preserve vntArrMenuName(lngCount)
            
            vntArrUsrGrpCd(lngCount) = objUsrGrpCd.Value & ""
            vntArrPgmCd(lngCount) = objPgmCd.Value & ""
            vntArrPgmName(lngCount) = objPgmName.Value & ""
            vntArrPgmFileName(lngCount) = objPgmFileName.Value & ""
            vntArrPgmGrant(lngCount) = objPgmGrant.Value & ""
            vntArrGrantName(lngCount) = objGrantName.Value & ""
            vntArrDispSeq(lngCount) = objDispSeq.Value & ""
            vntArrDelFlg(lngCount) = objDelFlg.Value & ""
            vntArrMenuName(lngCount) = objMenuName.Value & ""
                        
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntUsrGrpCd = vntArrUsrGrpCd
    vntPgmCd = vntArrPgmCd
    vntPgmName = vntArrPgmName
    vntPgmFileName = vntArrPgmFileName
    vntPgmGrant = vntArrPgmGrant
    vntGrantName = vntArrGrantName
    vntDispSeq = vntArrDispSeq
    vntDelFlg = vntArrDelFlg
    vntMenuName = vntArrMenuName
        
    SelectGrp_PgmInfoList = lngCount
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "PgmInfo.SelectGrp_PgmInfoList"
    
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

