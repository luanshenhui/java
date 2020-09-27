VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Truncate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession      As OraSession       'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase      'OraDatabaseオブジェクト

Private Const TRANSACTIONDIV_RSVDEL As String = "LOGRSVDEL"         '予約一括削除用のログ処理ＩＤ

'項目位置情報
Private Const INDEX_CSLDATE1        As Long = 0                     '受診希望日１
Private Const INDEX_CSLDATE2        As Long = 1                     '受診希望日２
Private Const INDEX_CSLDATE3        As Long = 2                     '受診希望日３
'## 2004.10.04 Mod By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加、予約群を第３受診希望日と漢字氏名の間に追加
'Private Const INDEX_NAME            As Long = 3                     '姓名
'Private Const INDEX_KNAME           As Long = 4                     'カナ姓名
'Private Const INDEX_BIRTH           As Long = 5                     '生年月日
'Private Const INDEX_GENDER          As Long = 6                     '性別
'Private Const INDEX_CSLDIVCD        As Long = 7                     '受診区分コード
'Private Const INDEX_PERID           As Long = 8                     '個人ＩＤ
'Private Const INDEX_ZIPCD           As Long = 9                     '郵便番号
'Private Const INDEX_TEL             As Long = 10                    '電話番号
'Private Const INDEX_ADDRESS         As Long = 11                    '住所
'Private Const INDEX_EMPNO           As Long = 12                    '従業員番号（または保険証番号）
'Private Const INDEX_SETCLASSCD      As Long = 13                    'セット分類コード
Private Const INDEX_RSVGRPCD        As Long = 3                     '予約群コード
Private Const INDEX_NAME            As Long = 4                     '姓名
Private Const INDEX_KNAME           As Long = 5                     'カナ姓名
Private Const INDEX_ROMENAME        As Long = 6                     'ローマ字名
Private Const INDEX_BIRTH           As Long = 7                     '生年月日
Private Const INDEX_GENDER          As Long = 8                     '性別
Private Const INDEX_CSLDIVCD        As Long = 9                     '受診区分コード
Private Const INDEX_PERID           As Long = 10                    '個人ＩＤ
Private Const INDEX_ZIPCD           As Long = 11                    '郵便番号
Private Const INDEX_TEL             As Long = 12                    '電話番号
Private Const INDEX_ADDRESS         As Long = 13                    '住所
Private Const INDEX_EMPNO           As Long = 14                    '従業員番号（または保険証番号）
Private Const INDEX_SETCLASSCD      As Long = 15                    'セット分類コード
'## 2004.10.04 Mod End

'項目長情報
Private Const LENGTH_CSLDATE1       As Long = 0                     '受診希望日１
Private Const LENGTH_CSLDATE2       As Long = 0                     '受診希望日２
Private Const LENGTH_CSLDATE3       As Long = 0                     '受診希望日３
'## 2004.10.04 Add By T.Takagi@FSIT 予約群を第３受診希望日と漢字氏名の間に追加
Private Const LENGTH_RSVGRPCD       As Long = 3                     '予約群コード
'## 2004.10.04 Add End
Private Const LENGTH_NAME           As Long = 50                    '姓名
Private Const LENGTH_KNAME          As Long = 50                    'カナ姓名
'## 2004.10.04 Add By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加
Private Const LENGTH_ROMENAME       As Long = 60                    'ローマ字名
'## 2004.10.04 Add End
Private Const LENGTH_BIRTH          As Long = 0                     '生年月日
Private Const LENGTH_GENDER         As Long = 0                     '性別
Private Const LENGTH_CSLDIVCD       As Long = 12                    '受診区分コード
Private Const LENGTH_PERID          As Long = 12                    '個人ＩＤ
Private Const LENGTH_ZIPCD          As Long = 7                     '郵便番号
Private Const LENGTH_TEL            As Long = 15                    '電話番号
Private Const LENGTH_ADDRESS        As Long = 60                    '住所
Private Const LENGTH_EMPNO          As Long = 12                    '従業員番号
Private Const LENGTH_ISRNO          As Long = 16                    '保険証番号
Private Const LENGTH_SETCLASSCD     As Long = 3                     'セット分類コード

'項目名情報
Private Const NAME_CSLDATE          As String = "受診希望日"        '受診希望日
Private Const NAME_CSLDATE1         As String = "第１受診希望日"    '受診希望日１
Private Const NAME_CSLDATE2         As String = "第２受診希望日"    '受診希望日２
Private Const NAME_CSLDATE3         As String = "第３受診希望日"    '受診希望日３
'## 2004.10.04 Add By T.Takagi@FSIT 予約群を第３受診希望日と漢字氏名の間に追加
Private Const NAME_RSVGRPCD         As String = "予約群"            '予約群コード
'## 2004.10.04 Add End
Private Const NAME_NAME             As String = "漢字名"            '姓名
Private Const NAME_KNAME            As String = "カナ名"            'カナ姓名
'## 2004.10.04 Add By T.Takagi@FSIT ローマ字名をカナ名と生年月日の間に追加
Private Const NAME_ROMENAME         As String = "ローマ字氏名"      'ローマ字名
'## 2004.10.04 Add End
Private Const NAME_BIRTH            As String = "生年月日"          '生年月日
Private Const NAME_GENDER           As String = "性別"              '性別
Private Const NAME_CSLDIVCD         As String = "受診区分"          '受診区分コード
Private Const NAME_PERID            As String = "患者ＩＤ"          '個人ＩＤ
Private Const NAME_ZIPCD            As String = "郵便番号"          '郵便番号
Private Const NAME_TEL              As String = "電話番号"          '電話番号
Private Const NAME_ADDRESS          As String = "住所"              '住所
Private Const NAME_EMPNO            As String = "従業員番号"        '従業員番号
Private Const NAME_ISRNO            As String = "保険証番号"        '保険証番号
Private Const NAME_SETCLASSCD       As String = "セット分類コード"  'セット分類コード

Private Const CSLDATE_MAXCOUNT      As Long = 3                     '指定可能な受診希望日の最大数
'Private Const SETCLASSCD_MAXCOUNT   As Long = 20                    '指定可能なセット分類コードの最大数

'
' 機能　　 : 受診情報の削除を行う
'
' 引数　　 : (In)     lngTransId  トランザクションＩＤ
' 　　　　   (In)     strUserId   ユーザＩＤ
' 　　　　   (In)     strOrgCd1   団体コード１
' 　　　　   (In)     strOrgCd2   団体コード２
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     lngLineNo   行番号
' 　　　　   (In)     strCslDate  受診日
' 　　　　   (In)     strRsvNo    予約番号
' 　　　　   (In)     strPerId    個人ＩＤ
'
' 戻り値　 : ※ストアドが完璧になってから記述する
'
' 備考　　 :
'
Private Function DeleteConsult( _
    ByRef lngTransId As Long, _
    ByRef strUserId As String, _
    ByRef strOrgCd1 As String, _
    ByRef strOrgCd2 As String, _
    ByRef lngCtrPtCd As Long, _
    ByRef lngLineNo As Long, _
    ByRef strCslDate As String, _
    ByRef strRsvNo As String, _
    ByRef strPerId As String _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'パラメータ設定
    Set objOraParam = mobjOraDb.Parameters
    With objOraParam
        .Add "TRANSID", lngTransId, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "TRANSDIV", TRANSACTIONDIV_RSVDEL, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "UPDUSER", strUserId, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "LINENO", lngLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "CSLDATE", CnvDate(strCslDate), ORAPARM_INPUT, ORATYPE_DATE
        .Add "RSVNO", CLng(strRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    End With
    
    '受診情報削除用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN                                        " & vbLf & _
              "    :RET := ConsultAllPackage.DeleteConsult( " & vbLf & _
              "                :TRANSID,                    " & vbLf & _
              "                :TRANSDIV,                   " & vbLf & _
              "                :UPDUSER,                    " & vbLf & _
              "                :ORGCD1,                     " & vbLf & _
              "                :ORGCD2,                     " & vbLf & _
              "                :CTRPTCD,                    " & vbLf & _
              "                :LINENO,                     " & vbLf & _
              "                :CSLDATE,                    " & vbLf & _
              "                :RSVNO,                      " & vbLf & _
              "                :PERID                       " & vbLf & _
              "    );                                       " & vbLf & _
              "END;                                         "

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objOraParam("RET").Value

    '戻り値の設定
    DeleteConsult = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Truncate.DeleteConsult"

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
' 機能　　 : ＣＳＶファイルから受診情報の削除を行う
'
' 引数　　 : (In)     strFileName   ＣＳＶファイル名
' 　　　　   (In)     strOrgCd1     団体コード１
' 　　　　   (In)     strOrgCd2     団体コード２
' 　　　　   (In)     strUserId     ユーザＩＤ
' 　　　　   (In)     lngCtrPtCd    契約パターンコード
' 　　　　   (In)     lngStartPos   読み込み開始位置
' 　　　　   (Out)    vntReadCount  読み込みレコード数
' 　　　　   (Out)    vntDelCount   削除受診情報数
'
' 戻り値　 :
'
' 備考　　 :
'
Public Sub DeleteFromCsvFile( _
    ByVal strFileName As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strUserId As String, _
    ByVal lngCtrPtCd As Long, _
    ByVal lngStartPos As Long, _
    Optional ByRef vntReadCount As Variant, _
    Optional ByRef vntDelCount As Variant _
)
    
    Dim objFso          As Object   'ファイルシステムオブジェクト
    Dim objContract     As Object   '契約情報アクセス用
    Dim objFree         As Object   '汎用情報アクセス用
    Dim objHainsLog     As Object   'ログ情報アクセス用
    Dim objOrganization As Object   '団体情報アクセス用

    Dim vntColumns      As Variant  '項目値の配列
    
    Dim lngTransId      As Long     'トランザクションＩＤ

    Dim vntTitle        As Variant  '表題
    Dim vntOrgSName     As Variant  '団体略称

    Dim vntCsCd         As Variant  'コースコード
    Dim vntCsName       As Variant  'コース名
    Dim vntStrDate      As Variant  '契約開始日
    Dim vntEndDate      As Variant  '契約終了日

    Dim intInFileNo     As Integer  'ファイル番号
    Dim strBuffer       As String   '文字列バッファ

    Dim lngLineNo       As Long     '行番号

    Dim lngLastIndex    As Long     '配列の最終インデックス
    Dim blnError        As Boolean  'エラーフラグ

    Dim strCslDate      As String   '受診日
    Dim strRsvNo        As String   '予約番号
    Dim strPerId        As String   '個人ＩＤ

    Dim lngReadCount    As Long     '読み込みレコード数
    Dim lngDelCount     As Long     '削除受診情報数

    Dim strMessage      As String   'メッセージ
    Dim Ret             As Boolean  '関数戻り値
    Dim Ret2            As Long     '関数戻り値
    Dim i               As Long     'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    
    'トランザクションＩＤの取得
    lngTransId = objHainsLog.IncreaseTransactionId()
    
    Set objHainsLog = Nothing

    Set objFree = CreateObject("HainsFree.Free")

    '汎用テーブルから表題を取得
    objFree.SelectFree 0, TRANSACTIONDIV_RSVDEL, , vntTitle

    Set objFree = Nothing

    '開始ログの発行
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "I", "", vntTitle & "処理を開始します。", ""

    '指定されたパラメータ情報を編集する
    Do

        Set objOrganization = CreateObject("HainsOrganization.Organization")

        '団体略称の取得
        Ret = objOrganization.SelectOrg_Lukes(strOrgCd1, strOrgCd2, , , , , vntOrgSName)
        
        Set objOrganization = Nothing
        
        '団体情報が存在しない場合は処理終了
        If Ret = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "E", "", "団体情報が存在しません。", "団体コード=" & strOrgCd1 & "-" & strOrgCd2
            Exit Do
        End If

        'ログ発行
        PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "I", "", "■次の団体が指定されました。", "団体=" & vntOrgSName & "（" & strOrgCd1 & "-" & strOrgCd2 & "）"

        Set objContract = CreateObject("HainsContract.Contract")

        '契約管理情報の読み込み
        Ret = objContract.SelectCtrMng(strOrgCd1, strOrgCd2, lngCtrPtCd, , vntCsCd, vntCsName, vntStrDate, vntEndDate)
        
        Set objContract = Nothing
        
        If Ret = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "E", "", "契約情報が存在しません。", "契約パターンコード=" & lngCtrPtCd
            Exit Do
        End If

        'ログ発行
        strMessage = ""
        strMessage = strMessage & "契約パターンコード=" & lngCtrPtCd
        strMessage = strMessage & "、"
        strMessage = strMessage & "コース=" & vntCsName & "（" & vntCsCd & "）"
        strMessage = strMessage & "、"
        strMessage = strMessage & "契約期間=" & vntStrDate & "～" & vntEndDate
        PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "I", "", "■次の契約情報が指定されました。", strMessage

        Set objFso = CreateObject("Scripting.FileSystemObject")
        
        'ファイルの存在をチェック
        Ret = objFso.FileExists(strFileName)
        
        Set objFso = Nothing
        
        'ファイルが存在しない場合は処理を終了する
        If Ret = False Then
            PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "E", "", "ファイルが存在しません。", "ファイル名=" & strFileName
            Exit Do
        End If

        'CSVファイルオープン
        intInFileNo = FreeFile()
        Open strFileName For Input Lock Read Write As #intInFileNo

        'ファイル読み込み
        Do Until EOF(intInFileNo)

            Do

                '１行読み込み
                Line Input #intInFileNo, strBuffer

                '行番号をインクリメント
                lngLineNo = lngLineNo + 1
                
                '行番号が読み込み開始位置に達していない場合はスキップ
                If lngLineNo < lngStartPos Then
                    Exit Do
                End If

                '行データが存在しない場合はスキップ
                If Trim(strBuffer) = "" Then
                    Exit Do
                End If

                '読み込みレコード数のインクリメント
                lngReadCount = lngReadCount + 1

                'CSV一括予約の結果レコードはセット分類数が特定できないため、削除に必要な情報はレコードの最終列から逆検索して取得する
                
                'カンマ分離
                vntColumns = Split(strBuffer, ",")

                'カラム値の検索
                For i = LBound(vntColumns) To UBound(vntColumns)
                
                    '先端のダブルクォーテーションを除外
                    If Left(vntColumns(i), 1) = """" Then
                        vntColumns(i) = Right(vntColumns(i), Len(vntColumns(i)) - 1)
                    End If
                    
                    '終端のダブルクォーテーションを除外
                    If Right(vntColumns(i), 1) = """" Then
                        vntColumns(i) = Left(vntColumns(i), Len(vntColumns(i)) - 1)
                    End If
                    
                    '値のトリミング
                    vntColumns(i) = Trim(vntColumns(i))
                
                Next i
                
                '後ろから順に
                '・受診希望日毎の検索結果
                '・予約群名称
                '・個人ＩＤ
                '・予約番号
                '・受診日
                'と格納されている前提で処理を実施
                
                lngLastIndex = UBound(vntColumns)
                
                '要素数がこれらに満たない場合はスキップ(ログも書かない)
                If lngLastIndex < (CSLDATE_MAXCOUNT + 4) - 1 Then
                    Exit Do
                End If
                
                '受診日、予約番号、個人ＩＤを取得する
                strCslDate = vntColumns(lngLastIndex - (CSLDATE_MAXCOUNT + 3))
                strRsvNo = vntColumns(lngLastIndex - (CSLDATE_MAXCOUNT + 2))
                strPerId = vntColumns(lngLastIndex - (CSLDATE_MAXCOUNT + 1))

                '１項目でも値が格納されていないレコードの場合、即ちそれは予約されたレコード情報ではないのでスキップする (ログも書かない)
                If strCslDate = "" Or strRsvNo = "" Or strPerId = "" Then
                    Exit Do
                End If

                blnError = False

                '(一応)項目値チェックを行う
                
                '受診日(日付チェック)
                If CnvDate(strCslDate) = "" Then
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "E", lngLineNo, "受診日が日付として認識できません。", "受診日=" & strCslDate
                    blnError = True
                End If

                '予約番号(数値チェック)
                If Not CheckNumber(strRsvNo) Then
                    
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "E", lngLineNo, "予約番号が無効です。", "予約番号=" & strRsvNo
                    blnError = True
                
                '予約番号(項目長チェック)
                ElseIf Len(CStr(CLng(strRsvNo))) > 9 Then
                    
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "E", lngLineNo, "予約番号の値が長すぎます。", "予約番号=" & strRsvNo
                    blnError = True
                    
                End If

                '個人ＩＤ(項目長チェック)
                If LenB(StrConv(strPerId, vbFromUnicode)) > LENGTH_PERID Then
                    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "E", lngLineNo, "個人ＩＤの値が長すぎます。", "個人ＩＤ=" & strPerId
                    blnError = True
                End If

                '項目値チェックエラー時は次レコードへ
                If blnError Then Exit Do

                '受診情報の削除を行う
                Ret2 = DeleteConsult(lngTransId, strUserId, strOrgCd1, strOrgCd2, lngCtrPtCd, lngLineNo, strCslDate, strRsvNo, strPerId)
                If Ret2 = 0 Then
                    lngDelCount = lngDelCount + 1
                End If
                
                Exit Do
            Loop

        Loop

        'ファイルクローズ
        Close #intInFileNo

        Exit Do
    Loop

    '他戻り値の設定
    If Not IsMissing(vntReadCount) Then vntReadCount = lngReadCount
    If Not IsMissing(vntDelCount) Then vntDelCount = lngDelCount
    
    '終了ログの発行
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "I", "", lngReadCount & "件のレコードが読み込まれました。", ""
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "I", "", lngDelCount & "件の受診情報が削除されました。", ""
    PutHainsLog mobjOraDb, lngTransId, TRANSACTIONDIV_RSVDEL, "I", "", vntTitle & "処理を終了します。", ""

    Exit Sub

ErrorHandle:

    'ファイルクローズ
    Close #intInFileNo

    'イベントログ書き込み
    WriteErrorLog "Truncate.DeleteFromCsvFile"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

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

