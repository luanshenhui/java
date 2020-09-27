VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Organization"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'########################################
'管理番号：SL-HS-Y0101-002
'修正日  ：2010.08.30
'担当者  ：FJTH)KOMURO
'作成内容：オラクルセッション対応
'########################################
Option Explicit

Implements ObjectControl

Private mobjContext         As ObjectContext        'オブジェクトコンテキスト

Private mobjOraSession      As OraSessionClass      'OraSessionオブジェクト
Private mobjOraDb           As OraDatabase          'OraDatabaseオブジェクト

'### 団体名称ハイライト表示有無チェックの為、追加 2003/12/26 Start ###
Private Const CON_FREECD    As String = "HLORG01"   '汎用コード(団体名称ハイライト表示条件)
'### 団体名称ハイライト表示有無チェックの為、追加 2003/12/26 End   ###

'
' 機能　　 : 団体テーブル検索用条件節作成
'
' 引数　　 : (In/Out) vntKey     検索キーの集合
' 　　　　   (In)     strCsCd    コースコード
' 　　　　   (In)     lngMode    取得モード(0:指定なし、1:団体のみ、2:健保のみ)
' 　　　　   (In)     vntDelFlg  削除フラグ
'
' 戻り値　 : 団体テーブル検索用の条件節
'
' 備考　　 : 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
' 　　　　   検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Private Function CreateConditionForOrgList(ByRef vntKey As Variant, ByRef strCsCd As String, ByRef lngMode As Long, ByRef vntDelFlg As Variant) As String

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objCommon       As Common           '共通クラス
    Dim vntCondition    As Variant          '条件節の集合
    Dim strParamName    As String           'パラメータ名
    Dim strParamName2   As String           'パラメータ名
    Dim strColumns()    As String           '列値の集合
    Dim blnNarrow       As Boolean          '検索キーが半角文字のみの場合にTrue
    Dim strCnvName      As String           '変換後の文字列
    Dim strBuffer       As String           '文字列バッファ
    Dim i               As Long             'インデックス
    
    Set objOraParam = mobjOraDb.Parameters
    
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
    '検索キー数分の条件節を追加
    If IsArray(vntKey) Then
    
        For i = 0 To UBound(vntKey)
                  
            '検索キー中の半角カナを全角カナに変換する
            strBuffer = objCommon.StrConvKanaWide(vntKey(i))
            
            '検索キーが半角文字のみかチェック
            blnNarrow = (LenB(StrConv(strBuffer, vbFromUnicode)) = Len(strBuffer))
            
            'パラメータ追加
            strParamName = "NAME" & CStr(i)
            
            If blnNarrow Then
            
                'パラメータ追加
                objOraParam.Add strParamName, strBuffer & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
            
                '(1)検索キー値が半角文字のみの場合、団体コードで部分検索を行う
                objCommon.AppendArray vntCondition, "(ORG.ORGCD1 LIKE :" & strParamName & " OR ORG.ORGCD2 LIKE :" & strParamName & ") "
            
            Else
            
                'パラメータ追加
                objOraParam.Add strParamName, "%" & strBuffer & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
                
'## 2003.12.17 Del By T.Takagi@FSIT ハットリ仕様オミット
'                '文字列置換を行う
'                strCnvName = ReplaceKanaString(strBuffer)
'
'                '(2)検索キー値が全角文字を含む場合、漢字名称およびカナ名称で部分検索を行う
'
'                '置換前後で文字列値が異なる場合、双方の値で検索を行う
'                If strCnvName <> strBuffer Then
'
'                    'パラメータ追加
'                    strParamName2 = "CNVNAME" & CStr(i)
'                    objOraParam.Add strParamName2, "%" & strCnvName & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
'
'                    objCommon.AppendArray vntCondition, "(ORG.ORGNAME LIKE :" & strParamName & " OR ORG.ORGKNAME LIKE :" & strParamName & " OR ORG.ORGNAME LIKE :" & strParamName2 & " OR ORG.ORGKNAME LIKE :" & strParamName2 & ") "
'
'                '置換前後で文字列値が同一ならば通常の検索を行う
'                Else
'## 2003.12.17 Del End
                
                    objCommon.AppendArray vntCondition, "(ORG.ORGNAME LIKE :" & strParamName & " OR ORG.ORGKNAME LIKE :" & strParamName & ") "
                
'## 2003.12.17 Del By T.Takagi@FSIT ハットリ仕様オミット
'                End If
'## 2003.12.17 Del End
                
            End If
            
        Next i

    End If
    
    'コースコード指定時は、そのコースの契約情報を持つ団体のみを検索対象とする
    If strCsCd <> "" Then
        objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntCondition, " EXISTS (SELECT ORGCD1 FROM CTRMNG WHERE ORGCD1 = ORG.ORGCD1 AND ORGCD2 = ORG.ORGCD2 AND CSCD = :CSCD) "
    End If

    '削除フラグの指定
    If IsArray(vntDelFlg) Then
    
        'パラメータ追加
        For i = 0 To UBound(vntDelFlg)
            strParamName = "DELFLG" & CStr(i)
            objOraParam.Add strParamName, IIf(vntDelFlg(i) <> "", CLng("0" & vntDelFlg(i)), Null), ORAPARM_INPUT, ORATYPE_NUMBER
            ReDim Preserve strColumns(i)
            strColumns(i) = ":" & strParamName
        Next i
        
        objCommon.AppendArray vntCondition, " ORG.DELFLG IN (" & Join(strColumns, ",") & ") "
    
    End If
    
    'すべての条件節をANDで連結
    If Not IsEmpty(vntCondition) Then
        CreateConditionForOrgList = Join(vntCondition, " AND ")
    End If
    
    Set objCommon = Nothing
    Set objOraParam = Nothing
    
End Function

'
' 機能　　 : 団体テーブルレコードを削除する
'
' 引数　　 : (In)     strOrgCd1  団体コード1
' 　　　　 : (In)     strOrgCd2  団体コード2
'
' 戻り値　 : 1   正常終了
' 　　　　   0   参照整合性制約のために削除不可
' 　　　　   -1  異常終了
'
' 備考　　 :
'
Public Function DeleteOrg(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String) As Long
        
    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    strOrgCd1 = Trim(strOrgCd1)
    strOrgCd2 = Trim(strOrgCd2)
    
    '検索条件が設定されていない場合はエラー
    If strOrgCd1 = "" Or strOrgCd2 = "" Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2

'    '団体テーブルレコードの削除(削除フラグを立てる)
'    strStmt = "UPDATE ORG                                     " & vbLf & _
'              "   SET DELFLG  = " & CStr(DELFLG_DELETED) & ", " & vbLf & _
'              "       UPDDATE = SYSDATE                       " & vbLf & _
'              " WHERE ORGCD1  = :ORGCD1                       " & vbLf & _
'              "   AND ORGCD2  = :ORGCD2"
              
'### 2003.01.28 Added *Lines by Ishihara@FSIT テストで作った団体が消せないのは辛いので。
    '所属テーブルレコードの削除
    strStmt = "DELETE ORGPOST          " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1 " & vbLf & _
              "   AND ORGCD2 = :ORGCD2 "
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
              
    '室部テーブルレコードの削除
    strStmt = "DELETE ORGROOM          " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1 " & vbLf & _
              "   AND ORGCD2 = :ORGCD2 "
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
              
    '事業部テーブルレコードの削除
    strStmt = "DELETE ORGBSD           " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1 " & vbLf & _
              "   AND ORGCD2 = :ORGCD2 "
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'### 2003.01.28 Added End
              
    '団体テーブルレコードの削除
    strStmt = "DELETE ORG              " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1 " & vbLf & _
              "   AND ORGCD2 = :ORGCD2 "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
              
    'バインド変数の削除
    objOraParam.Remove "ORGCD1"
    objOraParam.Remove "ORGCD2"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteOrg = 1
    
    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    '子レコード存在時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 2292 Then
        DeleteOrg = 0
        Exit Function
    End If
    
    DeleteOrg = -1
    
    'イベントログ書き込み
    WriteErrorLog "Organization.DeleteOrg"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'
' 機能　　 : 指定団体の団体テーブルレコードにレコードロックを適用する
'
' 引数　　 : (In)     strOrgCd1  団体コード1
' 　　　　 : (In)     strOrgCd2  団体コード2
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function LockOrgRecord(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objOrgName  As OraField         '漢字名称
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす団体テーブルのレコードを取得
    strStmt = "SELECT ORGCD1                         " & vbLf & _
              "  FROM ORG                            " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1               " & vbLf & _
              "   AND ORGCD2 = :ORGCD2               " & vbLf & _
              "   FOR UPDATE"
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '戻り値の設定
    LockOrgRecord = Not objOraDyna.EOF
    
    'バインド変数の削除
    objOraParam.Remove "ORGCD1"
    objOraParam.Remove "ORGCD2"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    LockOrgRecord = False

    'イベントログ書き込み
    WriteErrorLog "Organization.LockOrgRecord"
    
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
' 機能　　 : 団体コード、住所区分をキーに団体住所情報テーブルを読み込む
'
' 引数　　 : (In)     strOrgCd1       団体コード１
' 　　　　   (In)     strOrgCd2       団体コード２
' 　　　　   (In)     lngAddrDiv      住所区分
' 　　　　   (Out)    vntZipCd        郵便番号
' 　　　　   (Out)    vntPrefCd       都道府県コード
' 　　　　   (Out)    vntCityName     市区町村名
' 　　　　   (Out)    vntAddress1     住所１
' 　　　　   (Out)    vntAddress2     住所２
' 　　　　   (Out)    vntDirectTel    電話番号１
' 　　　　   (Out)    vntTel          電話番号２
' 　　　　   (Out)    vntExtension    内線１
' 　　　　   (Out)    vntFax          ＦＡＸ
' 　　　　   (Out)    vntEMail        e-Mail
' 　　　　   (Out)    vntUrl          URL
'
' 戻り値　 : True   正常終了
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectOrgAddr( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngAddrDiv As Long, _
    Optional ByRef vntZipCd As Variant, _
    Optional ByRef vntPrefCd As Variant, _
    Optional ByRef vntCityName As Variant, _
    Optional ByRef vntAddress1 As Variant, _
    Optional ByRef vntAddress2 As Variant, _
    Optional ByRef vntDirectTel As Variant, _
    Optional ByRef vntTel As Variant, _
    Optional ByRef vntExtension As Variant, _
    Optional ByRef vntFax As Variant, _
    Optional ByRef vntEMail As Variant, _
    Optional ByRef vntUrl As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objZipCd            As OraField         '郵便番号
    Dim objPrefCd           As OraField         '都道府県コード
    Dim objPrefName         As OraField         '都道府県名
    Dim objCityName         As OraField         '市区町村名
    Dim objAddress1         As OraField         '住所１
    Dim objAddress2         As OraField         '住所２
    Dim objDirectTel        As OraField         '電話番号１
    Dim objTel              As OraField         '電話番号２
    Dim objExtension        As OraField         '内線１
    Dim objFax              As OraField         'ＦＡＸ
    Dim objEMail            As OraField         'e-Mail
    Dim objUrl              As OraField         'URL
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntZipCd) Then vntZipCd = Empty
    If Not IsMissing(vntPrefCd) Then vntPrefCd = Empty
    If Not IsMissing(vntCityName) Then vntCityName = Empty
    If Not IsMissing(vntAddress1) Then vntAddress1 = Empty
    If Not IsMissing(vntAddress2) Then vntAddress2 = Empty
    If Not IsMissing(vntDirectTel) Then vntDirectTel = Empty
    If Not IsMissing(vntTel) Then vntTel = Empty
    If Not IsMissing(vntExtension) Then vntExtension = Empty
    If Not IsMissing(vntFax) Then vntFax = Empty
    If Not IsMissing(vntEMail) Then vntEMail = Empty
    If Not IsMissing(vntUrl) Then vntUrl = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDRDIV", lngAddrDiv, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす個人住所情報テーブルのレコードを取得
    strStmt = "SELECT ZIPCD,     PREFCD,    CITYNAME,  " & vbLf & _
              "       ADDRESS1,  ADDRESS2,  DIRECTTEL, " & vbLf & _
              "       TEL,       EXTENSION, FAX,       " & vbLf & _
              "       EMAIL,     URL                   " & vbLf & _
              "  FROM ORGADDR                          " & vbLf & _
              " WHERE ORGCD1  = :ORGCD1                " & vbLf & _
              "   AND ORGCD2  = :ORGCD2                " & vbLf & _
              "   AND ADDRDIV = :ADDRDIV               "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objZipCd = objFields("ZIPCD")
        Set objPrefCd = objFields("PREFCD")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
        Set objDirectTel = objFields("DIRECTTEL")
        Set objTel = objFields("TEL")
        Set objExtension = objFields("EXTENSION")
        Set objFax = objFields("FAX")
        Set objEMail = objFields("EMAIL")
        Set objUrl = objFields("URL")

        '戻り値の設定
        If Not IsMissing(vntZipCd) Then vntZipCd = objZipCd.Value & ""
        If Not IsMissing(vntPrefCd) Then vntPrefCd = objPrefCd.Value & ""
        If Not IsMissing(vntCityName) Then vntCityName = objCityName.Value & ""
        If Not IsMissing(vntAddress1) Then vntAddress1 = objAddress1.Value & ""
        If Not IsMissing(vntAddress2) Then vntAddress2 = objAddress2.Value & ""
        If Not IsMissing(vntDirectTel) Then vntDirectTel = objDirectTel.Value & ""
        If Not IsMissing(vntTel) Then vntTel = objTel.Value & ""
        If Not IsMissing(vntExtension) Then vntExtension = objExtension.Value & ""
        If Not IsMissing(vntFax) Then vntFax = objFax.Value & ""
        If Not IsMissing(vntEMail) Then vntEMail = objEMail.Value & ""
        If Not IsMissing(vntUrl) Then vntUrl = objUrl.Value & ""

        SelectOrgAddr = True
        
    End If

    '戻り値の設定

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectOrgAddr = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectOegAddr"
    
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
' #### 2003.11.14 担当者情報を追加 聖路加対応
'
' 機能　　 : 団体コードをキーに団体住所情報テーブルを読み込む
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　 : (In)     strOrgCd2       団体コード2
' 　　　　 : (Out)    vntZipCd        郵便番号
' 　　　　 : (Out)    vntPrefCd       都道府県コード
' 　　　　 : (Out)    vntCityName     市区町村名
' 　　　　 : (Out)    vntAddress1     住所１
' 　　　　 : (Out)    vntAddress2     住所２
' 　　　　 : (Out)    vntDirectTel    電話番号１
' 　　　　 : (Out)    vntTel          電話番号２
' 　　　　 : (Out)    vntExtension    内線１
' 　　　　 : (Out)    vntFax          ＦＡＸ
' 　　　　 : (Out)    vntEMail        e-Mail
' 　　　　 : (Out)    vntUrl          URL
' 　　　　 : (Out)    vntChargeName   担当者
' 　　　　 : (Out)    vntChargeKName  担当者カナ名
' 　　　　 : (Out)    vntChargeEMail  担当者e-Mail
' 　　　　 : (Out)    vntChargePost   担当部署
' 　　　　 : (Out)    vntOrgName      漢字名称
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectOrgAddrList( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    Optional ByRef vntAddrDiv As Variant, _
    Optional ByRef vntZipCd As Variant, _
    Optional ByRef vntPrefCd As Variant, _
    Optional ByRef vntCityName As Variant, _
    Optional ByRef vntAddress1 As Variant, _
    Optional ByRef vntAddress2 As Variant, _
    Optional ByRef vntDirectTel As Variant, _
    Optional ByRef vntTel As Variant, _
    Optional ByRef vntExtension As Variant, _
    Optional ByRef vntFax As Variant, _
    Optional ByRef vntEMail As Variant, _
    Optional ByRef vntUrl As Variant, _
    Optional ByRef vntChargeName As Variant, _
    Optional ByRef vntChargeKName As Variant, _
    Optional ByRef vntChargeEMail As Variant, _
    Optional ByRef vntChargePost As Variant, _
    Optional ByRef vntOrgName As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objAddrDiv      As OraField         '住所区分
    Dim objZipCd        As OraField         '郵便番号
    Dim objPrefCd       As OraField         '都道府県コード
    Dim objPrefName     As OraField         '都道府県名
    Dim objCityName     As OraField         '市区町村名
    Dim objAddress1     As OraField         '住所１
    Dim objAddress2     As OraField         '住所２
    Dim objDirectTel    As OraField         '電話番号１
    Dim objTel          As OraField         '電話番号２
    Dim objExtension    As OraField         '内線１
    Dim objFax          As OraField         'ＦＡＸ
    Dim objEMail        As OraField         'e-Mail
    Dim objUrl          As OraField         'URL
    Dim objChargeName   As OraField         '担当者
    Dim objChargeKName  As OraField         '担当者カナ名
    Dim objChargeEMail  As OraField         '担当者e-Mail
    Dim objChargePost   As OraField         '担当部署
    Dim objOrgName      As OraField         '漢字名称
    
    Dim vntArrAddrDIv(2)      As Variant         '住所区分の配列
    Dim vntArrZipCd(2)        As Variant         '郵便番号の配列
    Dim vntArrPrefCd(2)       As Variant         '都道府県コードの配列
    Dim vntArrPrefName(2)     As Variant         '都道府県名の配列
    Dim vntArrCityName(2)     As Variant         '市区町村名の配列
    Dim vntArrAddress1(2)     As Variant         '住所１の配列
    Dim vntArrAddress2(2)     As Variant         '住所２の配列
    Dim vntArrDirectTel(2)    As Variant         '電話番号１の配列
    Dim vntArrTel(2)          As Variant         '電話番号２の配列
    Dim vntArrExtension(2)    As Variant         '内線１の配列
    Dim vntArrFax(2)          As Variant         'ＦＡＸの配列
    Dim vntArrEMail(2)        As Variant         'e-Mailの配列
    Dim vntArrUrl(2)          As Variant         '担当者の配列
    Dim vntArrChargeName(2)   As Variant         'URLの配列
    Dim vntArrChargeKName(2)  As Variant         '担当者カナ名の配列
    Dim vntArrChargeEMail(2)  As Variant         '担当者e-Mailの配列
    Dim vntArrChargePost(2)   As Variant         '担当部署の配列
    Dim vntArrOrgName(2)      As Variant         '漢字名称の配列
    
    Dim lngAddrDiv      As Long             '住所区分

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntAddrDiv) Then vntAddrDiv = Empty
    If Not IsMissing(vntZipCd) Then vntZipCd = Empty
    If Not IsMissing(vntPrefCd) Then vntPrefCd = Empty
    If Not IsMissing(vntCityName) Then vntCityName = Empty
    If Not IsMissing(vntAddress1) Then vntAddress1 = Empty
    If Not IsMissing(vntAddress2) Then vntAddress2 = Empty
    If Not IsMissing(vntDirectTel) Then vntDirectTel = Empty
    If Not IsMissing(vntTel) Then vntTel = Empty
    If Not IsMissing(vntExtension) Then vntExtension = Empty
    If Not IsMissing(vntFax) Then vntFax = Empty
    If Not IsMissing(vntEMail) Then vntEMail = Empty
    If Not IsMissing(vntUrl) Then vntUrl = Empty
    If Not IsMissing(vntChargeName) Then vntChargeName = Empty
    If Not IsMissing(vntChargeKName) Then vntChargeKName = Empty
    If Not IsMissing(vntChargeEMail) Then vntChargeEMail = Empty
    If Not IsMissing(vntChargePost) Then vntChargePost = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす団体住所情報テーブルのレコードを取得
    strStmt = "SELECT ADDRDIV,     ZIPCD,       " & vbLf & _
              "       PREFCD,      CITYNAME,    " & vbLf & _
              "       ADDRESS1,    ADDRESS2,    " & vbLf & _
              "       DIRECTTEL,   TEL,         " & vbLf & _
              "       EXTENSION,   FAX,         " & vbLf & _
              "       EMAIL,       URL,         " & vbLf & _
              "       CHARGENAME,  CHARGEKNAME, " & vbLf & _
              "       CHARGEEMAIL, CHARGEPOST,  " & vbLf & _
              "       ORGNAME                   " & vbLf & _
              "  FROM ORGADDR                   " & vbLf & _
              " WHERE ORGCD1  = :ORGCD1         " & vbLf & _
              "   AND ORGCD2  = :ORGCD2         "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objAddrDiv = objFields("ADDRDIV")
        Set objZipCd = objFields("ZIPCD")
        Set objPrefCd = objFields("PREFCD")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
        Set objDirectTel = objFields("DIRECTTEL")
        Set objTel = objFields("TEL")
        Set objExtension = objFields("EXTENSION")
        Set objFax = objFields("FAX")
        Set objEMail = objFields("EMAIL")
        Set objUrl = objFields("URL")
        Set objChargeName = objFields("CHARGENAME")
        Set objChargeKName = objFields("CHARGEKNAME")
        Set objChargeEMail = objFields("CHARGEEMAIL")
        Set objChargePost = objFields("CHARGEPOST")
        Set objOrgName = objFields("ORGNAME")
        
        Do Until objOraDyna.EOF
            lngAddrDiv = objAddrDiv.Value - 1
            
            If lngAddrDiv >= 0 And lngAddrDiv <= 2 Then
                vntArrAddrDIv(lngAddrDiv) = objAddrDiv.Value & ""
                vntArrZipCd(lngAddrDiv) = objZipCd.Value & ""
                vntArrPrefCd(lngAddrDiv) = objPrefCd.Value & ""
                vntArrCityName(lngAddrDiv) = objCityName.Value & ""
                vntArrAddress1(lngAddrDiv) = objAddress1.Value & ""
                vntArrAddress2(lngAddrDiv) = objAddress2.Value & ""
                vntArrDirectTel(lngAddrDiv) = objDirectTel.Value & ""
                vntArrTel(lngAddrDiv) = objTel.Value & ""
                vntArrExtension(lngAddrDiv) = objExtension.Value & ""
                vntArrFax(lngAddrDiv) = objFax.Value & ""
                vntArrEMail(lngAddrDiv) = objEMail.Value & ""
                vntArrUrl(lngAddrDiv) = objUrl.Value & ""
                vntArrChargeName(lngAddrDiv) = objChargeName.Value & ""
                vntArrChargeKName(lngAddrDiv) = objChargeKName.Value & ""
                vntArrChargeEMail(lngAddrDiv) = objChargeEMail.Value & ""
                vntArrChargePost(lngAddrDiv) = objChargePost.Value & ""
                vntArrOrgName(lngAddrDiv) = objOrgName.Value & ""

            End If
                        
            objOraDyna.MoveNext
        Loop

        SelectOrgAddrList = True
        
    End If

    '戻り値の設定
    If Not IsMissing(vntAddrDiv) Then vntAddrDiv = vntArrAddrDIv
    If Not IsMissing(vntZipCd) Then vntZipCd = vntArrZipCd
    If Not IsMissing(vntPrefCd) Then vntPrefCd = vntArrPrefCd
    If Not IsMissing(vntCityName) Then vntCityName = vntArrCityName
    If Not IsMissing(vntAddress1) Then vntAddress1 = vntArrAddress1
    If Not IsMissing(vntAddress2) Then vntAddress2 = vntArrAddress2
    If Not IsMissing(vntDirectTel) Then vntDirectTel = vntArrDirectTel
    If Not IsMissing(vntTel) Then vntTel = vntArrTel
    If Not IsMissing(vntExtension) Then vntExtension = vntArrExtension
    If Not IsMissing(vntFax) Then vntFax = vntArrFax
    If Not IsMissing(vntEMail) Then vntEMail = vntArrEMail
    If Not IsMissing(vntUrl) Then vntUrl = vntArrUrl
    If Not IsMissing(vntChargeName) Then vntChargeName = vntArrChargeName
    If Not IsMissing(vntChargeKName) Then vntChargeKName = vntArrChargeKName
    If Not IsMissing(vntChargeEMail) Then vntChargeEMail = vntArrChargeEMail
    If Not IsMissing(vntChargePost) Then vntChargePost = vntArrChargePost
    If Not IsMissing(vntOrgName) Then vntOrgName = vntArrOrgName

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectOrgAddrList = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectOegAddr"
    
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
' 機能　　 : 健保記号からの団体検索
'
' 引数　　 : (In)   strIsrSign   健保記号
' 　　　　   (In)   strOrgCd1    団体コード1(本引数に設定された団体は検索対象としない)
' 　　　　   (In)   strOrgCd2    団体コード2(本引数に設定された団体は検索対象としない)
' 　　　　   (Out)  vntOrgCd1    団体コード1
' 　　　　   (Out)  vntOrgCd2    団体コード2
' 　　　　   (Out)  vntOrgSName  団体略称
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectOrgFromIsr( _
    ByVal strIsrSign As String, _
    Optional ByVal strOrgCd1 As String, _
    Optional ByVal strOrgCd2 As String, _
    Optional ByRef vntOrgCd1 As Variant, _
    Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntOrgSName As Variant _
) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objOrgCd1   As OraField         '団体コード1
    Dim objOrgCd2   As OraField         '団体コード2
    Dim objOrgSName As OraField         '団体略称
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ISRSIGN", strIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
    If strOrgCd1 <> "" And strOrgCd2 <> "" Then
        objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    '検索条件を満たす団体テーブルのレコードを取得
    strStmt = "SELECT ORGCD1, ORGCD2, ORGSNAME " & vbLf & _
              "  FROM ORG                      " & vbLf & _
              " WHERE ISRSIGN = :ISRSIGN       " & vbLf & _
              "   AND ISRGETNAME IS NOT NULL   "
              
    '指定された団体は除く
    If strOrgCd1 <> "" And strOrgCd2 <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND (ORGCD1 != :ORGCD1 OR ORGCD2 != :ORGCD2)"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgSName = objFields("ORGSNAME")
        
        '戻り値の設定
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = objOrgCd1.Value & ""
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = objOrgCd2.Value & ""
        If Not IsMissing(vntOrgSName) Then vntOrgSName = objOrgSName.Value & ""
        
        SelectOrgFromIsr = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectOrgFromIsr = False

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectOrgFromIsr"
    
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
' 機能　　 : 団体コードをキーに団体テーブルを読み込む
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　   (In)     strOrgCd2       団体コード2
' 　　　　   (Out)    vntOrgKName     カナ名称
' 　　　　   (Out)    vntOrgName      漢字名称
' 　　　　   (Out)    vntZipCd        郵便番号1
' 　　　　   (Out)    vntPrefName     都道府県名
' 　　　　   (Out)    vntCityName     市区町村名
' 　　　　   (Out)    vntAddress1     住所1
' 　　　　   (Out)    vntAddress2     住所2
' 　　　　   (Out)    vntTel          電話番号代表－市外局番
' 　　　　   (Out)    vntChargeName   担当者氏名
' 　　　　   (Out)    vntChargePost   担当者部署名
'## 2012.12.24 張 項目追加 Start
' 　　　　 : (Out)    vntHighLight    団体名称ハイライト表示区分
'## 2012.12.24 張 項目追加 End
'
' 戻り値　 : True   正常終了
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 : ヘッダ情報として、上記引数の内容のみを取得する
'
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'Public Function SelectOrgHeader(
'    ByVal strOrgCd1 As String,
'    ByVal strOrgCd2 As String,
'    ByRef vntOrgKName As Variant,
'    ByRef vntOrgName As Variant,
'    ByRef vntZipCd1 As Variant,
'    ByRef vntZipCd2 As Variant,
'    ByRef vntPrefName As Variant,
'    ByRef vntCityName As Variant,
'    ByRef vntAddress1 As Variant,
'    ByRef vntAddress2 As Variant,
'    ByRef vntTel1 As Variant,
'    ByRef vntTel2 As Variant,
'    ByRef vntTel3 As Variant,
'    ByRef vntChargeName As Variant,
'    ByRef vntChargePost As Variant
') As Boolean
'## 団体名称ハイライト表示区分(vntHighLight)追加 2013.12.24 張
Public Function SelectOrgHeader( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByRef vntOrgKName As Variant, _
    ByRef vntOrgName As Variant, _
    ByRef vntZipCd As Variant, _
    ByRef vntPrefName As Variant, _
    ByRef vntCityName As Variant, _
    ByRef vntAddress1 As Variant, _
    ByRef vntAddress2 As Variant, _
    ByRef vntTel As Variant, _
    ByRef vntChargeName As Variant, _
    ByRef vntChargePost As Variant, _
    Optional ByRef vntHighLight As Variant _
) As Boolean
'## 2003.11.18 Mod End

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objOrgKName     As OraField         'カナ名称
    Dim objOrgName      As OraField         '漢字名称
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    Dim objZipCd1       As OraField         '郵便番号1
'    Dim objZipCd2       As OraField         '郵便番号2
    Dim objZipCd        As OraField         '郵便番号
'## 2003.11.18 Mod End
    Dim objPrefName     As OraField         '都道府県名
    Dim objCityName     As OraField         '市区町村名
    Dim objAddress1     As OraField         '住所1
    Dim objAddress2     As OraField         '住所2
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    Dim objTel1         As OraField         '電話番号代表－市外局番
'    Dim objTel2         As OraField         '電話番号代表－局番
'    Dim objTel3         As OraField         '電話番号代表－番号
    Dim objTel          As OraField         '電話番号代表
'## 2003.11.18 Mod End
    Dim objChargeName   As OraField         '担当者氏名
    Dim objChargePost   As OraField         '担当者部署名
    
'## 団体名称ハイライト表示区分(vntHighLight)追加 2013.12.24 張
    Dim objSpare3       As OraField         '予備3
    
'### 団体名称ハイライト表示有無チェックの為、追加 2003/12/26 Start ###
    Dim strFreeField1       As String           '汎用フィールド１
    Dim strFreeField2       As String           '汎用フィールド２
    Dim strFreeField3       As String           '汎用フィールド３
'### 団体名称ハイライト表示有無チェックの為、追加 2003/12/26 End   ###
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntOrgKName = Empty
    vntOrgName = Empty
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    vntZipCd1 = Empty
'    vntZipCd2 = Empty
    vntZipCd = Empty
'## 2003.11.18 Mod End
    vntPrefName = Empty
    vntCityName = Empty
    vntAddress1 = Empty
    vntAddress2 = Empty
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    vntTel1 = Empty
'    vntTel2 = Empty
'    vntTel3 = Empty
    vntTel = Empty
'## 2003.11.18 Mod End
    vntChargeName = Empty
    vntChargePost = Empty
    
'## 団体名称ハイライト表示区分(vntHighLight)追加 2013.12.24 張
    vntHighLight = Empty
    
    
    '検索条件が設定されていない場合はエラー
    If Trim(strOrgCd1) = "" Or Trim(strOrgCd2) = "" Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす団体テーブルのレコードを取得
'### 2003/11/15 Updated by Ishihara@FSIT 担当者はテーブルが移動
'    strStmt = "SELECT ORG.ORGKNAME,   ORG.ORGNAME,   " & vbLf & _
              "       ORG.ZIPCD1,     ORG.ZIPCD2,    " & vbLf & _
              "       PREF.PREFNAME,  ORG.CITYNAME,  " & vbLf & _
              "       ORG.ADDRESS1,   ORG.ADDRESS2,  " & vbLf & _
              "       ORG.TEL1,       ORG.TEL2,      " & vbLf & _
              "       ORG.TEL3,                      " & vbLf & _
              "       ORG.CHARGENAME, ORG.CHARGEPOST " & vbLf & _
              "  FROM PREF, ORG                      " & vbLf & _
              " WHERE ORG.ORGCD1 = :ORGCD1           " & vbLf & _
              "   AND ORG.ORGCD2 = :ORGCD2           " & vbLf & _
              "   AND ORG.PREFCD = PREF.PREFCD(+)    "
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strStmt = "SELECT ORG.ORGKNAME,   ORG.ORGNAME,   " & vbLf & _
'              "       ORG.ZIPCD1,     ORG.ZIPCD2,    " & vbLf & _
'              "       PREF.PREFNAME,  ORG.CITYNAME,  " & vbLf & _
'              "       ORG.ADDRESS1,   ORG.ADDRESS2,  " & vbLf & _
'              "       ORG.TEL1,       ORG.TEL2,      " & vbLf & _
'              "       ORG.TEL3                      " & vbLf & _
'              "  FROM PREF, ORG                      " & vbLf & _
'              " WHERE ORG.ORGCD1 = :ORGCD1           " & vbLf & _
'              "   AND ORG.ORGCD2 = :ORGCD2           " & vbLf & _
'              "   AND ORG.PREFCD = PREF.PREFCD(+)    "

'## 団体名称ハイライト表示区分(vntHighLight)追加 2013.12.24 張 Start ##
'    strStmt = "SELECT ORG.ORGKNAME,   ORG.ORGNAME,        " & vbLf & _
'              "       ORGADDR.ZIPCD,                      " & vbLf & _
'              "       PREF.PREFNAME,    ORGADDR.CITYNAME, " & vbLf & _
'              "       ORGADDR.ADDRESS1, ORGADDR.ADDRESS2, " & vbLf & _
'              "       ORGADDR.TEL,                        " & vbLf & _
'              "       ORGADDR.CHARGENAME,                 " & vbLf & _
'              "       ORGADDR.CHARGEPOST                  " & vbLf & _
'              "  FROM PREF, ORGADDR, ORG                  " & vbLf & _
'              " WHERE ORG.ORGCD1     = :ORGCD1            " & vbLf & _
'              "   AND ORG.ORGCD2     = :ORGCD2            " & vbLf & _
'              "   AND ORG.ORGCD1     = ORGADDR.ORGCD1(+)  " & vbLf & _
'              "   AND ORG.ORGCD2     = ORGADDR.ORGCD2(+)  " & vbLf & _
'              "   AND 1              = ORGADDR.ADDRDIV(+) " & vbLf & _
'              "   AND ORGADDR.PREFCD = PREF.PREFCD(+)     "

    strStmt = "SELECT ORG.ORGKNAME,   ORG.ORGNAME,        " & vbLf & _
              "       ORG.SPARE3,                         " & vbLf & _
              "       ORGADDR.ZIPCD,                      " & vbLf & _
              "       PREF.PREFNAME,    ORGADDR.CITYNAME, " & vbLf & _
              "       ORGADDR.ADDRESS1, ORGADDR.ADDRESS2, " & vbLf & _
              "       ORGADDR.TEL,                        " & vbLf & _
              "       ORGADDR.CHARGENAME,                 " & vbLf & _
              "       ORGADDR.CHARGEPOST                  " & vbLf & _
              "  FROM PREF, ORGADDR, ORG                  " & vbLf & _
              " WHERE ORG.ORGCD1     = :ORGCD1            " & vbLf & _
              "   AND ORG.ORGCD2     = :ORGCD2            " & vbLf & _
              "   AND ORG.ORGCD1     = ORGADDR.ORGCD1(+)  " & vbLf & _
              "   AND ORG.ORGCD2     = ORGADDR.ORGCD2(+)  " & vbLf & _
              "   AND 1              = ORGADDR.ADDRDIV(+) " & vbLf & _
              "   AND ORGADDR.PREFCD = PREF.PREFCD(+)     "

'## 団体名称ハイライト表示区分(vntHighLight)追加 2013.12.24 張 End   ##

'## 2003.11.18 Mod End
'### 2003/11/15 Updated End
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgKName = objFields("ORGKNAME")
        Set objOrgName = objFields("ORGNAME")


'## 団体名称ハイライト表示区分(vntHighLight)追加 2013.12.24 張 Start ##
        Set objSpare3 = objFields("SPARE3")
'## 団体名称ハイライト表示区分(vntHighLight)追加 2013.12.24 張 End   ##


'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'        Set objZipCd1 = objFields("ZIPCD1")
'        Set objZipCd2 = objFields("ZIPCD2")
        Set objZipCd = objFields("ZIPCD")
'## 2003.11.18 Mod End
        Set objPrefName = objFields("PREFNAME")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'        Set objTel1 = objFields("TEL1")
'        Set objTel2 = objFields("TEL2")
'        Set objTel3 = objFields("TEL3")
        Set objTel = objFields("TEL")
        Set objChargeName = objFields("CHARGENAME")
        Set objChargePost = objFields("CHARGEPOST")
'## 2003.11.18 Mod End
'### 2003/11/15 Deleted by Ishihara@FSIT 担当者はテーブルが移動
'        Set objChargeName = objFields("CHARGENAME")
'        Set objChargePost = objFields("CHARGEPOST")
'### 2003/11/15 Deleted End
        
        '戻り値の設定
        vntOrgKName = objOrgKName.Value & ""
        vntOrgName = objOrgName.Value & ""
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'        vntZipCd1 = objZipCd1.Value & ""
'        vntZipCd2 = objZipCd2.Value & ""
        vntZipCd = objZipCd.Value & ""
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
        vntPrefName = objPrefName.Value & ""
        vntCityName = objCityName.Value & ""
        vntAddress1 = objAddress1.Value & ""
        vntAddress2 = objAddress2.Value & ""
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'        vntTel1 = objTel1.Value & ""
'        vntTel2 = objTel2.Value & ""
'        vntTel3 = objTel3.Value & ""
        vntTel = objTel.Value & ""
        vntChargeName = objChargeName.Value & ""
        vntChargePost = objChargePost.Value & ""
'## 2003.11.18 Mod End
'### 2003/11/15 Deleted by Ishihara@FSIT 担当者はテーブルが移動
'        vntChargeName = objChargeName.Value & ""
'        vntChargePost = objChargePost.Value & ""
'### 2003/11/15 Deleted End
        
        
'## 汎用項目３(SPARE3)に登録されているデータが「10桁」で日付タイプの場合団体名称ハイライト表示 2013.12.24 張 Start
        vntHighLight = "0"
        
        If (SelectFree(CON_FREECD, strFreeField1, strFreeField2, strFreeField3)) Then
            
            Select Case strFreeField2
                '日付形式
                Case "DATE"
                    If IsNumeric(Trim(strFreeField1)) Then
                        If Len(Trim(objSpare3.Value & "")) = CLng(Trim(strFreeField1)) And IsDate(Trim(objSpare3.Value & "")) Then
                            vntHighLight = "1"
                        End If
                    Else
                        If IsDate(Trim(objSpare3.Value & "")) Then
                            vntHighLight = "1"
                        End If
                    End If
        
                Case "FIX"
                    If Trim(strFreeField3) <> "" And Trim(objSpare3.Value & "") = Trim(strFreeField3) Then
                        vntHighLight = "1"
                    End If
                
                'それ以外の場合
                Case Else
                    vntHighLight = "0"
            End Select
        
        End If
        
'        If Len(Trim(objSpare3.Value & "")) = 10 And IsDate(Trim(objSpare3.Value & "")) Then
'            vntHighLight = "1"
'        End If
'## 汎用項目３(SPARE3)に登録されているデータが「10桁」で日付タイプの場合団体名称ハイライト表示 2013.12.24 張 End
        
        SelectOrgHeader = True
        
        
    End If

    'バインド変数の削除
    objOraParam.Remove "ORGCD1"
    objOraParam.Remove "ORGCD2"
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectOrgHeader = False

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectOrgHeader"
    
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
' 機能　　 : 団体コードをキーに団体テーブルを読み、名称を取得
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　 : (In)     strOrgCd2       団体コード2
' 　　　　 : (Out)    vntOrgName      漢字名称
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectOrgName(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByRef vntOrgName As Variant) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objOrgName  As OraField         '漢字名称
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntOrgName = Empty
    
    '検索条件が設定されていない場合はエラー
    If Trim(strOrgCd1) = "" Or Trim(strOrgCd2) = "" Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす団体テーブルのレコードを取得
    strStmt = "SELECT ORGNAME                        " & vbLf & _
              "  FROM ORG                            " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1               " & vbLf & _
              "   AND ORGCD2 = :ORGCD2               "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgName = objFields("ORGNAME")
        
        '戻り値の設定
        vntOrgName = objOrgName.Value & ""
        
        SelectOrgName = True
        
    End If

    'バインド変数の削除
    objOraParam.Remove "ORGCD1"
    objOraParam.Remove "ORGCD2"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectOrgName = False

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectOrgName"
    
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
' 機能　　 : 団体コードをキーに団体テーブルを読み、略称を取得
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　 : (In)     strOrgCd2       団体コード2
' 　　　　 : (Out)    vntOrgSName     略称
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectOrgSName(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByRef vntOrgSName As Variant) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objOrgSName As OraField         '略称
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntOrgSName = Empty
    
    '検索条件が設定されていない場合はエラー
    If Trim(strOrgCd1) = "" Or Trim(strOrgCd2) = "" Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす団体テーブルのレコードを取得
    strStmt = "SELECT ORGSNAME                       " & vbLf & _
              "  FROM ORG                            " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1               " & vbLf & _
              "   AND ORGCD2 = :ORGCD2               "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgSName = objFields("ORGSNAME")
        
        '戻り値の設定
        vntOrgSName = objOrgSName.Value & ""
        
        SelectOrgSName = True
        
    End If

    'バインド変数の削除
    objOraParam.Remove "ORGCD1"
    objOraParam.Remove "ORGCD2"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectOrgSName = False

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectOrgSName"
    
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
' 機能　　 : 検索条件を満たす団体の一覧を取得する
'
' 引数　　 : (In/Out) vntKey       検索キーの集合
' 　　　　   (In)     lngStartPos  開始位置
' 　　　　   (In)     lngGetCount  取得件数
' 　　　　   (Out)    vntOrgCd1    団体コード1
' 　　　　   (Out)    vntOrgCd2    団体コード2
' 　　　　   (Out)    vntOrgName   漢字名称
' 　　　　   (Out)    vntOrgSName  略称
' 　　　　   (Out)    vntOrgKName  カナ名称
' 　　　　   (In)     strCsCd      コースコード
' 　　　　   (In)     lngMode      取得モード(0:指定なし、1:団体のみ、2:健保のみ)
' 　　　　   (Out)    vntOrgDiv    団体種別
' 　　　　   (Out)    vntIsrSign   健保記号
' 　　　　   (In)     vntDelFlg    削除フラグ
' 　　　　   (In)     lngAddrDiv   住所区分
' 　　　　   (Out)    vntNotes     特記事項
' 　　　　   (Out)    vntPrefName  都道府県名
' 　　　　   (Out)    vntCityName  市区町村名
' 　　　　   (Out)    vntAddress1  住所１
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : ①検索キーに半角カナ文字が存在する場合は全角変換が行われる
' 　　　　   ②コースコード指定時は、そのコースの契約情報を持つ団体のみを検索対象とする
'
Public Function SelectOrgList( _
    ByVal vntKey As Variant, _
    ByVal lngStartPos As Long, _
    ByVal lngGetCount As Long, _
    Optional ByRef vntOrgCd1 As Variant, _
    Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntOrgKName As Variant, _
    Optional ByVal strCsCd As String, _
    Optional ByVal lngMode As Long = 0, _
    Optional ByRef vntOrgDiv As Variant, _
    Optional ByRef vntIsrSign As Variant, _
    Optional ByVal vntDelFlg As Variant, _
    Optional ByVal lngAddrDiv As Long = 1, _
    Optional ByRef vntNotes As Variant, _
    Optional ByRef vntPrefName As Variant, _
    Optional ByRef vntCityName As Variant, _
    Optional ByRef vntAddress1 As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objOrgCd1           As OraField         '団体コード1
    Dim objOrgCd2           As OraField         '団体コード2
    Dim objOrgName          As OraField         '漢字名称
    Dim objOrgSName         As OraField         '略称
    Dim objOrgKName         As OraField         'カナ名称
    Dim objNotes            As OraField         '特記事項
    Dim objPrefName         As OraField         '都道府県名
    Dim objCityName         As OraField         '市区町村名
    Dim objAddress1         As OraField         '住所１
    
    Dim vntArrOrgCd1()      As Variant          '団体コード1の配列
    Dim vntArrOrgCd2()      As Variant          '団体コード2の配列
    Dim vntArrOrgName()     As Variant          '漢字名称の配列
    Dim vntArrOrgSName()    As Variant          '略称の配列
    Dim vntArrOrgKName()    As Variant          'カナ名称の配列
    Dim vntArrNotes()       As Variant          '特記事項の配列
    Dim vntArrPrefName()    As Variant          '都道府県名の配列
    Dim vntArrCityName()    As Variant          '市区町村名の配列
    Dim vntArrAddress1()    As Variant          '住所１の配列
    Dim lngCount            As Long             'レコード数
    
    Dim vntArrDelFlg        As Variant          '削除フラグ
    Dim strCondition        As String           '条件節
    Dim lngPhase            As Long             '取得フェイズ(0:件数のみ、1:実データ)
    Dim i                   As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntOrgKName) Then vntOrgKName = Empty
    If Not IsMissing(vntOrgDiv) Then vntOrgDiv = Empty
    If Not IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If Not IsMissing(vntNotes) Then vntNotes = Empty
    If Not IsMissing(vntPrefName) Then vntPrefName = Empty
    If Not IsMissing(vntCityName) Then vntCityName = Empty
    If Not IsMissing(vntAddress1) Then vntAddress1 = Empty
    lngCount = 0
    
    If Not IsMissing(vntDelFlg) Then
        If IsArray(vntDelFlg) Then
            vntArrDelFlg = vntDelFlg
        End If
    End If
    
    Set objOraParam = mobjOraDb.Parameters
        
    '条件節の作成
    strCondition = CreateConditionForOrgList(vntKey, strCsCd, lngMode, vntArrDelFlg)
    
    '件数取得と実データ取得という２回分のSQL発行
    For lngPhase = 0 To 1
        
        Select Case lngPhase
        
            Case 0  '件数取得の場合
            
                strStmt = "SELECT COUNT(*) FROM ORG " & IIf(strCondition <> "", "WHERE " & strCondition, "")
                
            Case 1  '実データ取得の場合
        
                'パラメータ追加
                objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
                objOraParam.Add "ENDPOS", (lngStartPos + lngGetCount - 1), ORAPARM_INPUT, ORATYPE_NUMBER
                objOraParam.Add "ADDRDIV", lngAddrDiv, ORAPARM_INPUT, ORATYPE_NUMBER

                '団体テーブル読み込み
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'                strStmt = "SELECT ORGCD1,   ORGCD2,             " & vbLf & _
'                          "       ORGNAME,  ORGSNAME, ORGKNAME, " & vbLf & _
'                          "       ORGDIV,   ISRSIGN,  NOTES,    " & vbLf & _
'                          "       PREFNAME, CITYNAME, ADDRESS1  "
'
'                strStmt = strStmt & vbLf & _
'                          "  FROM ( SELECT ROWNUM SEQ, ORGCD1,   ORGCD2,   " & vbLf & _
'                          "                ORGNAME,    ORGSNAME, ORGKNAME, " & vbLf & _
'                          "                ORGDIV,     ISRSIGN,  NOTES,    " & vbLf & _
'                          "                PREFNAME,   CITYNAME, ADDRESS1  "
'
'                strStmt = strStmt & vbLf & _
'                          "           FROM ( SELECT ORG.ORGCD1,    ORG.ORGCD2,                        " & vbLf & _
'                          "                         ORG.ORGNAME,   ORG.ORGSNAME,     ORG.ORGKNAME,    " & vbLf & _
'                          "                         ORG.ORGDIV,    ORG.ISRSIGN,      ORG.NOTES,       " & vbLf & _
'                          "                         PREF.PREFNAME, ORGADDR.CITYNAME, ORGADDR.ADDRESS1 " & vbLf & _
'                          "                    FROM PREF, ORGADDR, ORG                                "
                strStmt = "SELECT ORGCD1,   ORGCD2,             " & vbLf & _
                          "       ORGNAME,  ORGSNAME, ORGKNAME, " & vbLf & _
                          "       NOTES,                        " & vbLf & _
                          "       PREFNAME, CITYNAME, ADDRESS1  "
                
                strStmt = strStmt & vbLf & _
                          "  FROM ( SELECT ROWNUM SEQ, ORGCD1,   ORGCD2,   " & vbLf & _
                          "                ORGNAME,    ORGSNAME, ORGKNAME, " & vbLf & _
                          "                NOTES,                          " & vbLf & _
                          "                PREFNAME,   CITYNAME, ADDRESS1  "
    
                strStmt = strStmt & vbLf & _
                          "           FROM ( SELECT ORG.ORGCD1,    ORG.ORGCD2,                        " & vbLf & _
                          "                         ORG.ORGNAME,   ORG.ORGSNAME,     ORG.ORGKNAME,    " & vbLf & _
                          "                         ORG.NOTES,                                        " & vbLf & _
                          "                         PREF.PREFNAME, ORGADDR.CITYNAME, ORGADDR.ADDRESS1 " & vbLf & _
                          "                    FROM PREF, ORGADDR, ORG                                "
'## 2003.11.18 Mod End
                  
                '検索条件を編集
                strStmt = strStmt & vbLf & "  WHERE " & strCondition & IIf(strCondition <> "", " AND", "")
                          
                'その他結合条件を編集
'## 2003.12.16 Mod By T.Takagi@FSIT 検索キーがなければ団体コード昇順にソート
'                strStmt = strStmt & vbLf & _
'                          "                         ORG.ORGCD1     = ORGADDR.ORGCD1(+)      " & vbLf & _
'                          "                     AND ORG.ORGCD2     = ORGADDR.ORGCD2(+)      " & vbLf & _
'                          "                     AND :ADDRDIV       = ORGADDR.ADDRDIV(+)     " & vbLf & _
'                          "                     AND ORGADDR.PREFCD = PREF.PREFCD(+)         " & vbLf & _
'                          "                   ORDER BY ORG.ORGKNAME, ORG.ORGCD1, ORG.ORGCD2 " & vbLf & _
'                          "                )                                                "
                strStmt = strStmt & vbLf & _
                          "                         ORG.ORGCD1     = ORGADDR.ORGCD1(+)  " & vbLf & _
                          "                     AND ORG.ORGCD2     = ORGADDR.ORGCD2(+)  " & vbLf & _
                          "                     AND :ADDRDIV       = ORGADDR.ADDRDIV(+) " & vbLf & _
                          "                     AND ORGADDR.PREFCD = PREF.PREFCD(+)     "
                
                If Not IsEmpty(vntKey) Then
                    strStmt = strStmt & vbLf & _
                          "                   ORDER BY ORG.ORGKNAME, ORG.ORGCD1, ORG.ORGCD2 "
                Else
                    strStmt = strStmt & vbLf & _
                          "                   ORDER BY ORG.ORGCD1, ORG.ORGCD2 "
                End If
                
                strStmt = strStmt & vbLf & _
                          "                ) "
'## 2003.12.16 Mod End
                  
                '検索結果にROWNUM、即ちSEQ番号を付加し、この値と開始位置、取得件数による絞り込みを行う
                strStmt = strStmt & vbLf & _
                          "       )                                 " & vbLf & _
                          " WHERE SEQ BETWEEN :STARTPOS AND :ENDPOS "
    
        End Select
        
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
        'ダイナセット情報の取得処理
        Do
            
            '件数の取得処理
            If lngPhase = 0 Then
                lngCount = objOraDyna.Fields(0).Value
                Exit Do
            End If
        
            '検索レコードが存在しない場合は処理を抜ける
            If objOraDyna.EOF Then
                Exit Do
            End If
        
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objOrgCd1 = objFields("ORGCD1")
            Set objOrgCd2 = objFields("ORGCD2")
            Set objOrgName = objFields("ORGNAME")
            Set objOrgSName = objFields("ORGSNAME")
            Set objOrgKName = objFields("ORGKNAME")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'            Set objOrgDiv = objFields("ORGDIV")
'            Set objIsrSign = objFields("ISRSIGN")
'## 2003.11.18 Del End
            Set objNotes = objFields("NOTES")
            Set objPrefName = objFields("PREFNAME")
            Set objCityName = objFields("CITYNAME")
            Set objAddress1 = objFields("ADDRESS1")
        
            '配列形式で格納する
            i = 0
            Do Until objOraDyna.EOF
                ReDim Preserve vntArrOrgCd1(i)
                ReDim Preserve vntArrOrgCd2(i)
                ReDim Preserve vntArrOrgName(i)
                ReDim Preserve vntArrOrgSName(i)
                ReDim Preserve vntArrOrgKName(i)
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'                ReDim Preserve vntArrOrgDiv(i)
'                ReDim Preserve vntArrIsrSign(i)
'## 2003.11.18 Del End
                ReDim Preserve vntArrNotes(i)
                ReDim Preserve vntArrPrefName(i)
                ReDim Preserve vntArrCityName(i)
                ReDim Preserve vntArrAddress1(i)
                vntArrOrgCd1(i) = objOrgCd1.Value
                vntArrOrgCd2(i) = objOrgCd2.Value
                vntArrOrgName(i) = objOrgName.Value
                vntArrOrgSName(i) = objOrgSName.Value
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'                vntArrOrgDiv(i) = objOrgDiv.Value
'                vntArrIsrSign(i) = objIsrSign.Value & ""
'## 2003.11.18 Del End
                vntArrOrgKName(i) = objOrgKName.Value & ""
                vntArrNotes(i) = objNotes.Value & ""
                vntArrPrefName(i) = objPrefName.Value & ""
                vntArrCityName(i) = objCityName.Value & ""
                vntArrAddress1(i) = objAddress1.Value & ""
                i = i + 1
                objOraDyna.MoveNext
            Loop
        
            '戻り値の設定
            If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
            If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
            If Not IsMissing(vntOrgName) Then vntOrgName = vntArrOrgName
            If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
            If Not IsMissing(vntOrgKName) Then vntOrgKName = vntArrOrgKName
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'            If Not IsMissing(vntOrgDiv) Then vntOrgDiv = vntArrOrgDiv
'            If Not IsMissing(vntIsrSign) Then vntIsrSign = vntArrIsrSign
'## 2003.11.18 Del End
            If Not IsMissing(vntNotes) Then vntNotes = vntArrNotes
            If Not IsMissing(vntPrefName) Then vntPrefName = vntArrPrefName
            If Not IsMissing(vntCityName) Then vntCityName = vntArrCityName
            If Not IsMissing(vntAddress1) Then vntAddress1 = vntArrAddress1
    
            Exit Do
        Loop
        
        '件数取得にて０件の場合は処理を終了する
        If lngPhase = 0 And lngCount = 0 Then
            Exit For
        End If
        
    Next lngPhase
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Set objOrgCd1 = Nothing
    Set objOrgCd2 = Nothing
    Set objOrgName = Nothing
    Set objOrgSName = Nothing
    Set objOrgKName = Nothing
    Set objNotes = Nothing
    Set objPrefName = Nothing
    Set objCityName = Nothing
    Set objAddress1 = Nothing
    Set objFields = Nothing
    Set objOraDyna = Nothing
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
        
    Set objOraParam = Nothing
        
    '戻り値の設定
    SelectOrgList = lngCount
    
    Exit Function
    
ErrorHandle:

    SelectOrgList = -1

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectOrgList"
    
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
' 機能　　 : 団体一覧の読み込み
'
' 引数　　 : (In)      strOrgCd1      団体コード1
' 　　　　   (In)      strOrgCd2      団体コード2
' 　　　　   (In)      strZipCd1      郵便番号1
' 　　　　   (In)      strZipCd2      郵便番号2
' 　　　　   (Out)     vntOrgCd1      団体コード1
' 　　　　   (Out)     vntOrgCd2      団体コード2
' 　　　　   (Out)     vntOrgName     団体漢字名称
' 　　　　   (Out)     vntOrgKName    団体カナ名称
' 　　　　   (Out)     vntZipCd1      郵便番号1
' 　　　　   (Out)     vntZipCd2      郵便番号2
' 　　　　   (Out)     vntCityName    市区町村名
' 　　　　   (Out)     vntAddress1    住所1
' 　　　　   (Out)     vntAddress2    住所2
' 　　　　   (Out)     vntTel1        電話番号－市外局番
' 　　　　   (Out)     vntTel2        電話番号－局番
' 　　　　   (Out)     vntTel3        電話番号－番号
' 　　　　   (Out)     vntChargeName  担当者
' 　　　　   (Out)     vntChargePost  担当部署
' 　　　　   (Out)     vntPrefName    都道府県名
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectOrgListForPrint( _
    Optional ByVal strOrgCd1 As String, _
    Optional ByVal strOrgCd2 As String, _
    Optional ByVal strZipCd1 As String, _
    Optional ByVal strZipCd2 As String, _
    Optional ByRef vntOrgCd1 As Variant, _
    Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntOrgKName As Variant, _
    Optional ByRef vntZipCd1 As Variant, _
    Optional ByRef vntZipCd2 As Variant, _
    Optional ByRef vntCityName As Variant, _
    Optional ByRef vntAddress1 As Variant, _
    Optional ByRef vntAddress2 As Variant, _
    Optional ByRef vntTel1 As Variant, _
    Optional ByRef vntTel2 As Variant, _
    Optional ByRef vntTel3 As Variant, _
    Optional ByRef vntChargeName As Variant, _
    Optional ByRef vntChargePost As Variant, _
    Optional ByRef vntPrefName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objOrgCd1           As OraField         '団体コード1
    Dim objOrgCd2           As OraField         '団体コード2
    Dim objOrgName          As OraField         '団体名称
    Dim objOrgKName         As OraField         '団体カナ名称
    Dim objZipCd1           As OraField         '郵便番号1
    Dim objZipCd2           As OraField         '郵便番号2
    Dim objCityName         As OraField         '市区町村名
    Dim objAddress1         As OraField         '住所1
    Dim objAddress2         As OraField         '住所2
    Dim objTel1             As OraField         '電話番号－市外局番
    Dim objTel2             As OraField         '電話番号－局番
    Dim objTel3             As OraField         '電話番号－番号
    Dim objChargeName       As OraField         '担当者
    Dim objChargePost       As OraField         '担当部署
    Dim objPrefName         As OraField         '都道府県名
    
    Dim vntArrOrgCd1()      As Variant          '団体コード1の配列
    Dim vntArrOrgCd2()      As Variant          '団体コード2の配列
    Dim vntArrOrgName()     As Variant          '団体名称の配列
    Dim vntArrOrgKName()    As Variant          '団体カナ名称の配列
    Dim vntArrZipCd1()      As Variant          '郵便番号1の配列
    Dim vntArrZipCd2()      As Variant          '郵便番号2の配列
    Dim vntArrCityName()    As Variant          '市区町村名の配列
    Dim vntArrAddress1()    As Variant          '住所1の配列
    Dim vntArrAddress2()    As Variant          '住所2の配列
    Dim vntArrTel1()        As Variant          '電話番号－市外局番の配列
    Dim vntArrTel2()        As Variant          '電話番号－局番の配列
    Dim vntArrTel3()        As Variant          '電話番号－番号の配列
    Dim vntArrChargeName()  As Variant          '担当者の配列
    Dim vntArrChargePost()  As Variant          '担当部署の配列
    Dim vntArrPrefName()    As Variant          '都道府県名の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntOrgKName) Then vntOrgKName = Empty
    If Not IsMissing(vntZipCd1) Then vntZipCd1 = Empty
    If Not IsMissing(vntZipCd2) Then vntZipCd2 = Empty
    If Not IsMissing(vntCityName) Then vntCityName = Empty
    If Not IsMissing(vntAddress1) Then vntAddress1 = Empty
    If Not IsMissing(vntAddress2) Then vntAddress2 = Empty
    If Not IsMissing(vntTel1) Then vntTel1 = Empty
    If Not IsMissing(vntTel2) Then vntTel2 = Empty
    If Not IsMissing(vntTel3) Then vntTel3 = Empty
    If Not IsMissing(vntChargeName) Then vntChargeName = Empty
    If Not IsMissing(vntChargePost) Then vntChargePost = Empty
    If Not IsMissing(vntPrefName) Then vntPrefName = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ZIPCD1", strZipCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ZIPCD2", strZipCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定条件を満たす団体テーブルレコードを取得
'### 2003/11/15 Updated by Ishihara@FSIT 担当者はテーブルが移動
'    strStmt = "SELECT ORG.ORGCD1,     ORG.ORGCD2,     ORG.ORGNAME,  " & vbLf & _
              "       ORG.ORGKNAME,   ORG.ZIPCD1,     ORG.ZIPCD2,   " & vbLf & _
              "       ORG.CITYNAME,   ORG.ADDRESS1,   ORG.ADDRESS2, " & vbLf & _
              "       ORG.TEL1,       ORG.TEL2,       ORG.TEL3,     " & vbLf & _
              "       ORG.CHARGENAME, ORG.CHARGEPOST, PREF.PREFNAME " & vbLf & _
              "  FROM ORG, PREF                                     "
    strStmt = "SELECT ORG.ORGCD1,     ORG.ORGCD2,     ORG.ORGNAME,  " & vbLf & _
              "       ORG.ORGKNAME,   ORG.ZIPCD1,     ORG.ZIPCD2,   " & vbLf & _
              "       ORG.CITYNAME,   ORG.ADDRESS1,   ORG.ADDRESS2, " & vbLf & _
              "       ORG.TEL1,       ORG.TEL2,       ORG.TEL3,     " & vbLf & _
              "       PREF.PREFNAME " & vbLf & _
              "  FROM ORG, PREF                                     "
              
    If strOrgCd1 <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND ORG.ORGCD1 = :ORGCD1 "
    End If
              
    If strOrgCd2 <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND ORG.ORGCD2 = :ORGCD2 "
    End If
              
    If strZipCd1 <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND ORG.ZIPCD1 = :ZIPCD1 "
    End If
              
    If strZipCd2 <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND ORG.ZIPCD2 = :ZIPCD2 "
    End If
        
    strStmt = strStmt & vbLf & _
              "   AND ORG.PREFCD = PREF.PREFCD(+) " & vbLf & _
              " ORDER BY ORG.ORGCD1, ORG.ORGCD2   "

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgKName = objFields("ORGKNAME")
        Set objZipCd1 = objFields("ZIPCD1")
        Set objZipCd2 = objFields("ZIPCD2")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
        Set objTel1 = objFields("TEL1")
        Set objTel2 = objFields("TEL2")
        Set objTel3 = objFields("TEL3")
'### 2003/11/15 Updated by Ishihara@FSIT 担当者はテーブルが移動
'        Set objChargeName = objFields("CHARGENAME")
'        Set objChargePost = objFields("CHARGEPOST")
        Set objPrefName = objFields("PREFNAME")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgKName(lngCount)
            ReDim Preserve vntArrZipCd1(lngCount)
            ReDim Preserve vntArrZipCd2(lngCount)
            ReDim Preserve vntArrCityName(lngCount)
            ReDim Preserve vntArrAddress1(lngCount)
            ReDim Preserve vntArrAddress2(lngCount)
            ReDim Preserve vntArrTel1(lngCount)
            ReDim Preserve vntArrTel2(lngCount)
            ReDim Preserve vntArrTel3(lngCount)
            ReDim Preserve vntArrChargeName(lngCount)
            ReDim Preserve vntArrChargePost(lngCount)
            ReDim Preserve vntArrPrefName(lngCount)
            vntArrOrgCd1(lngCount) = objOrgCd1.Value
            vntArrOrgCd2(lngCount) = objOrgCd2.Value
            vntArrOrgName(lngCount) = objOrgName.Value
            vntArrOrgKName(lngCount) = objOrgKName.Value
            vntArrZipCd1(lngCount) = objZipCd1.Value & ""
            vntArrZipCd2(lngCount) = objZipCd2.Value & ""
            vntArrCityName(lngCount) = objCityName.Value & ""
            vntArrAddress1(lngCount) = objAddress1.Value & ""
            vntArrAddress2(lngCount) = objAddress2.Value & ""
            vntArrTel1(lngCount) = objTel1.Value & ""
            vntArrTel2(lngCount) = objTel2.Value & ""
            vntArrTel3(lngCount) = objTel3.Value & ""
'### 2003/11/15 Updated by Ishihara@FSIT 担当者はテーブルが移動
'            vntArrChargeName(lngCount) = objChargeName.Value & ""
'            vntArrChargePost(lngCount) = objChargePost.Value & ""
            vntArrChargeName(lngCount) = ""
            vntArrChargePost(lngCount) = ""
            
            vntArrPrefName(lngCount) = objPrefName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
        If Not IsMissing(vntOrgName) Then vntOrgName = vntArrOrgName
        If Not IsMissing(vntOrgKName) Then vntOrgKName = vntArrOrgKName
        If Not IsMissing(vntZipCd1) Then vntZipCd1 = vntArrZipCd1
        If Not IsMissing(vntZipCd2) Then vntZipCd2 = vntArrZipCd2
        If Not IsMissing(vntCityName) Then vntCityName = vntArrCityName
        If Not IsMissing(vntAddress1) Then vntAddress1 = vntArrAddress1
        If Not IsMissing(vntAddress2) Then vntAddress2 = vntArrAddress2
        If Not IsMissing(vntTel1) Then vntTel1 = vntArrTel1
        If Not IsMissing(vntTel2) Then vntTel2 = vntArrTel2
        If Not IsMissing(vntTel3) Then vntTel3 = vntArrTel3
        If Not IsMissing(vntChargeName) Then vntChargeName = vntArrChargeName
        If Not IsMissing(vntChargePost) Then vntChargePost = vntArrChargePost
        If Not IsMissing(vntPrefName) Then vntPrefName = vntArrPrefName

    End If

    '戻り値の設定
    SelectOrgListForPrint = lngCount
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectOrgListForPrint = -1

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectOrgListForPrint"
    
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
' 機能　　 : 受診者数取得（団体別）
'
' 引数　　 : (In)     strDate               対象日付
' 　　　　 : (Out)    vntOrgCode1           団体コード１
' 　　　　 : (Out)    vntOrgCode2           団体コード２
' 　　　　 : (Out)    vntOrgName            団体名
' 　　　　 : (Out)    vntOrgSu              人数
'
' 戻り値　 :レコード数
'
' 備考　　 :
'
Public Function SelectSelDateOrg( _
                                ByVal strDate As String, _
                                ByRef vntOrgCode1 As Variant, _
                                ByRef vntOrgCode2 As Variant, _
                                ByRef vntOrgName As Variant, _
                                ByRef vntOrgSu As Variant _
                            ) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    
    Dim objDate         As OraField         '指定日付
    Dim objOrgCode1     As OraField         '団体コード１
    Dim objOrgCode2     As OraField         '団体コード２
    Dim objOrgName      As OraField         '団体名
    Dim objOrgSu        As OraField         '団体人数
    
'    Dim objCommon       As Common           '共通クラス
    
    Dim vntArrDate()      As Variant          '指定日付
    Dim vntArrOrgCode1()  As Variant          '団体コード１
    Dim vntArrOrgCode2()  As Variant          '団体コード２
    Dim vntArrOrgName()   As Variant          '団体名
    Dim vntArrOrgSu()     As Variant          '団体人数
    
    Dim lngCount        As Long             'レコード数
    
    '初期値
    vntOrgCode1 = Empty
    vntOrgCode2 = Empty
    vntOrgName = Empty
    vntOrgSu = Empty
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SELDATE", strDate, ORAPARM_INPUT, ORATYPE_DATE
    
    'BBSテーブルから取得
    strStmt = "SELECT CONSULT.ORGCD1,CONSULT.ORGCD2,ORG.ORGNAME,COUNT(CONSULT.PERID) AS ORGSU" & vbLf & _
              "  FROM ORG, CONSULT" & vbLf & _
              "WHERE ORG.ORGCD1 = CONSULT.ORGCD1" & vbLf & _
              "  AND ORG.ORGCD2 = CONSULT.ORGCD2" & vbLf & _
              "  AND CONSULT.CANCELFLG = '0'" & vbLf & _
              "  AND CONSULT.CSLDATE = :SELDATE" & vbLf & _
              "GROUP BY CONSULT.ORGCD1,CONSULT.ORGCD2,ORG.ORGNAME"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        '共通クラスのインスタンス作成
'        Set objCommon = mobjcontext.createinstance("HainsCommon.Common")
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCode1 = objFields("ORGCD1")
        Set objOrgCode2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgSu = objFields("ORGSU")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
'            objCommon.AppendArray vntArrOrgCode1, objOrgCode1.Value
'            objCommon.AppendArray vntArrOrgCode2, objOrgCode2.Value
'            objCommon.AppendArray vntArrOrgName, objOrgName.Value
'            objCommon.AppendArray vntArrOrgSu, objOrgSu.Value
            
            ReDim Preserve vntArrOrgCode1(lngCount)
            ReDim Preserve vntArrOrgCode2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgSu(lngCount)
            
            vntArrOrgCode1(lngCount) = objOrgCode1.Value & ""
            vntArrOrgCode2(lngCount) = objOrgCode2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgSu(lngCount) = objOrgSu.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntOrgCode1 = vntArrOrgCode1
    vntOrgCode2 = vntArrOrgCode2
    vntOrgName = vntArrOrgName
    vntOrgSu = vntArrOrgSu
    
    SelectSelDateOrg = lngCount
        
'#### 2010.08.30 SL-HS-Y0101-002 ADD START ####
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'#### 2010.08.30 SL-HS-Y0101-002 ADD END ####
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectSelDateOrg"
    
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

Private Function ReplaceKanaString(ByRef strStream As String) As String

    Dim strBuffer   As String   '文字列バッファ
    
    strBuffer = strStream
    strBuffer = Replace(strBuffer, "ァ", "ア")
    strBuffer = Replace(strBuffer, "ィ", "イ")
    strBuffer = Replace(strBuffer, "ゥ", "ウ")
    strBuffer = Replace(strBuffer, "ェ", "エ")
    strBuffer = Replace(strBuffer, "ォ", "オ")
    strBuffer = Replace(strBuffer, "ッ", "ツ")
    strBuffer = Replace(strBuffer, "ャ", "ヤ")
    strBuffer = Replace(strBuffer, "ュ", "ユ")
    strBuffer = Replace(strBuffer, "ョ", "ヨ")

    ReplaceKanaString = strBuffer
    
End Function

'
' 機能　　 : 団体コードをキーに団体テーブルを読み込む
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　 : (In)     strOrgCd2       団体コード2
' 　　　　 : (Out)    vntOrgKName     カナ名称
' 　　　　 : (Out)    vntOrgName      漢字名称
' 　　　　 : (Out)    vntOrgBILLNAME  請求書用名称
' 　　　　 : (Out)    vntOrgSName     略称
' 　　　　 : (Out)    vntOrgDiv       団体種別
' 　　　　 : (Out)    vntZipCd1       郵便番号1
' 　　　　 : (Out)    vntZipCd2       郵便番号2
' 　　　　 : (Out)    vntPrefCd       都道府県コード
' 　　　　 : (Out)    vntPrefName     都道府県名
' 　　　　 : (Out)    vntCityName     市区町村名
' 　　　　 : (Out)    vntAddress1     住所1
' 　　　　 : (Out)    vntAddress2     住所2
' 　　　　 : (Out)    vntTel1         電話番号代表－市外局番
' 　　　　 : (Out)    vntTel2         電話番号代表－局番
' 　　　　 : (Out)    vntTel3         電話番号代表－番号
' 　　　　 : (Out)    vntDirectTel1   電話番号直通－市外局番
' 　　　　 : (Out)    vntDirectTel2   電話番号直通－局番
' 　　　　 : (Out)    vntDirectTel3   電話番号直通－番号
' 　　　　 : (Out)    vntExtension    内線
' 　　　　 : (Out)    vntFax1         ＦＡＸ－市外局番
' 　　　　 : (Out)    vntFax2         ＦＡＸ－局番
' 　　　　 : (Out)    vntFax3         ＦＡＸ－番号
' 　　　　 : (Out)    vntChargeName   担当者氏名
' 　　　　 : (Out)    vntChargeKName  担当者カナ名
' 　　　　 : (Out)    vntChargeEmail  担当者E-Mailアドレス
' 　　　　 : (Out)    vntChargePost   担当者部署名
' 　　　　 : (Out)    vntIsrNo        保険者番号
' 　　　　 : (Out)    vntIsrSign      健保記号(記号)
' 　　　　 : (Out)    vntIsrMark      健保記号(符号)
' 　　　　 : (Out)    vntHeIsrNo      健保番号
' 　　　　 : (Out)    vntIsrDiv       保険区分
' 　　　　 : (Out)    vntBank         銀行名
' 　　　　 : (Out)    vntBranch       支店名
' 　　　　 : (Out)    vntAccountKind  口座種別
' 　　　　 : (Out)    vntAccountNo    口座番号
' 　　　　 : (Out)    vntNotes        特記事項
' 　　　　 : (Out)    vntSpare1       予備1
' 　　　　 : (Out)    vntSpare2       予備2
' 　　　　 : (Out)    vntSpare3       予備3
' 　　　　 : (Out)    vntUpdDate      更新日時
' 　　　　 : (Out)    vntUpdUser      更新者
' 　　　　 : (Out)    vntUserName     更新者名
' 　　　　 : (Out)    vntRoundNoTaxFlg  まるめ金消費税非計算フラグ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 : 旧版（東急版）。互換性保持のために残してある。
'
Public Function SelectOrg( _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    Optional ByRef vntOrgKName As Variant, Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgBillName As Variant, _
    Optional ByRef vntOrgSName As Variant, Optional ByRef vntOrgDiv As Variant, _
    Optional ByRef vntZipCd1 As Variant, Optional ByRef vntZipCd2 As Variant, _
    Optional ByRef vntPrefCd As Variant, Optional ByRef vntPrefName As Variant, _
    Optional ByRef vntCityName As Variant, Optional ByRef vntAddress1 As Variant, Optional ByRef vntAddress2 As Variant, _
    Optional ByRef vntTel1 As Variant, Optional ByRef vntTel2 As Variant, Optional ByRef vntTel3 As Variant, _
    Optional ByRef vntDirectTel1 As Variant, Optional ByRef vntDirectTel2 As Variant, Optional ByRef vntDirectTel3 As Variant, _
    Optional ByRef vntExtension As Variant, _
    Optional ByRef vntFax1 As Variant, Optional ByRef vntFax2 As Variant, Optional ByRef vntFax3 As Variant, _
    Optional ByRef vntChargeName As Variant, Optional ByRef vntChargeKName As Variant, _
    Optional ByRef vntChargeEMail As Variant, Optional ByRef vntChargePost As Variant, _
    Optional ByRef vntGovMngCd As Variant, _
    Optional ByRef vntIsrNo As Variant, Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrMark As Variant, _
    Optional ByRef vntHeIsrNo As Variant, Optional ByRef vntIsrDiv As Variant, _
    Optional ByRef vntBank As Variant, Optional ByRef vntBranch As Variant, _
    Optional ByRef vntAccountKind As Variant, Optional ByRef vntAccountNo As Variant, _
    Optional ByRef vntNotes As Variant, _
    Optional ByRef vntSpare1 As Variant, Optional ByRef vntSpare2 As Variant, Optional ByRef vntSpare3 As Variant, _
    Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName, _
    Optional ByRef vntRoundNoTaxFlg As Variant, Optional ByRef vntIsrGetName As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objOrgKName     As OraField         'カナ名称
    Dim objOrgName      As OraField         '漢字名称
    Dim objOrgSName     As OraField         '略称
    Dim objOrgBillName  As OraField         '請求書用名称
    Dim objOrgDiv       As OraField         '団体種別
    Dim objZipCd1       As OraField         '郵便番号1
    Dim objZipCd2       As OraField         '郵便番号2
    Dim objPrefCd       As OraField         '都道府県コード
    Dim objPrefName     As OraField         '都道府県名
    Dim objCityName     As OraField         '市区町村名
    Dim objAddress1     As OraField         '住所1
    Dim objAddress2     As OraField         '住所2
    Dim objTel1         As OraField         '電話番号代表－市外局番
    Dim objTel2         As OraField         '電話番号代表－局番
    Dim objTel3         As OraField         '電話番号代表－番号
    Dim objDirectTel1   As OraField         '電話番号直通－市外局番
    Dim objDirectTel2   As OraField         '電話番号直通－局番
    Dim objDirectTel3   As OraField         '電話番号直通－番号
    Dim objExtension    As OraField         '内線
    Dim objFax1         As OraField         'ＦＡＸ－市外局番
    Dim objFax2         As OraField         'ＦＡＸ－局番
    Dim objFax3         As OraField         'ＦＡＸ－番号
    Dim objChargeName   As OraField         '担当者氏名
    Dim objChargeKName  As OraField         '担当者カナ名
    Dim objChargeEMail  As OraField         '担当者E-Mailアドレス
    Dim objChargePost   As OraField         '担当者部署名
    Dim objGovMngCd     As OraField         '政府管掌コード
    Dim objIsrNo        As OraField         '保険者番号
    Dim objIsrSign      As OraField         '健保記号(記号)
    Dim objIsrMark      As OraField         '健保記号(符号)
    Dim objHeIsrNo      As OraField         '健保番号
    Dim objIsrDiv       As OraField         '保険区分
    Dim objBank         As OraField         '銀行名
    Dim objBranch       As OraField         '支店名
    Dim objAccountKind  As OraField         '口座種別
    Dim objAccountNo    As OraField         '口座番号
    Dim objNotes        As OraField         '特記事項
    Dim objSpare1       As OraField         '予備1
    Dim objSpare2       As OraField         '予備2
    Dim objSpare3       As OraField         '予備3
    Dim objUpdDate      As OraField         '更新日時
    Dim objUpdUser      As OraField         '更新者
    Dim objUserName     As OraField         '更新者名
    Dim objRoundNoTaxFlg    As OraField     'まるめ金消費税非計算フラグ
    Dim objIsrGetName       As OraField     '健保名称索引対象
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntOrgKName) Then vntOrgKName = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntOrgBillName) Then vntOrgBillName = Empty
    If Not IsMissing(vntOrgDiv) Then vntOrgDiv = Empty
    If Not IsMissing(vntZipCd1) Then vntZipCd1 = Empty
    If Not IsMissing(vntZipCd2) Then vntZipCd2 = Empty
    If Not IsMissing(vntPrefCd) Then vntPrefCd = Empty
    If Not IsMissing(vntPrefName) Then vntPrefName = Empty
    If Not IsMissing(vntCityName) Then vntCityName = Empty
    If Not IsMissing(vntAddress1) Then vntAddress1 = Empty
    If Not IsMissing(vntAddress2) Then vntAddress2 = Empty
    If Not IsMissing(vntTel1) Then vntTel1 = Empty
    If Not IsMissing(vntTel2) Then vntTel2 = Empty
    If Not IsMissing(vntTel3) Then vntTel3 = Empty
    If Not IsMissing(vntDirectTel1) Then vntDirectTel1 = Empty
    If Not IsMissing(vntDirectTel2) Then vntDirectTel2 = Empty
    If Not IsMissing(vntDirectTel3) Then vntDirectTel3 = Empty
    If Not IsMissing(vntExtension) Then vntExtension = Empty
    If Not IsMissing(vntFax1) Then vntFax1 = Empty
    If Not IsMissing(vntFax2) Then vntFax2 = Empty
    If Not IsMissing(vntFax3) Then vntFax3 = Empty
    If Not IsMissing(vntChargeName) Then vntChargeName = Empty
    If Not IsMissing(vntChargeKName) Then vntChargeKName = Empty
    If Not IsMissing(vntChargeEMail) Then vntChargeEMail = Empty
    If Not IsMissing(vntChargePost) Then vntChargePost = Empty
    If Not IsMissing(vntGovMngCd) Then vntGovMngCd = Empty
    If Not IsMissing(vntIsrNo) Then vntIsrNo = Empty
    If Not IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If Not IsMissing(vntIsrMark) Then vntIsrMark = Empty
    If Not IsMissing(vntHeIsrNo) Then vntHeIsrNo = Empty
    If Not IsMissing(vntIsrDiv) Then vntIsrDiv = Empty
    If Not IsMissing(vntBank) Then vntBank = Empty
    If Not IsMissing(vntBranch) Then vntBranch = Empty
    If Not IsMissing(vntAccountKind) Then vntAccountKind = Empty
    If Not IsMissing(vntAccountNo) Then vntAccountNo = Empty
    If Not IsMissing(vntNotes) Then vntNotes = Empty
    If Not IsMissing(vntSpare1) Then vntSpare1 = Empty
    If Not IsMissing(vntSpare2) Then vntSpare2 = Empty
    If Not IsMissing(vntSpare3) Then vntSpare3 = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUserName) Then vntUserName = Empty
    If Not IsMissing(vntRoundNoTaxFlg) Then vntRoundNoTaxFlg = Empty
    If Not IsMissing(vntIsrGetName) Then vntIsrGetName = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす団体テーブルのレコードを取得
'### 2003/11/15 Updated by Ishihara@FSIT 担当者はテーブルが移動
'    strStmt = "SELECT ORG.ORGKNAME,    ORG.ORGNAME,     ORG.ORGBILLNAME,   " & vbLf & _
              "       ORG.ORGSNAME,    ORG.ORGDIV,                         " & vbLf & _
              "       ORG.ZIPCD1,      ORG.ZIPCD2,                         " & vbLf & _
              "       ORG.PREFCD,      PREF.PREFNAME,   ORG.CITYNAME,      " & vbLf & _
              "       ORG.ADDRESS1,    ORG.ADDRESS2,                       " & vbLf & _
              "       ORG.TEL1,        ORG.TEL2,        ORG.TEL3,          " & vbLf & _
              "       ORG.DIRECTTEL1,  ORG.DIRECTTEL2,  ORG.DIRECTTEL3,    " & vbLf & _
              "       ORG.EXTENSION,                                       " & vbLf & _
              "       ORG.FAX1,        ORG.FAX2,        ORG.FAX3,          " & vbLf & _
              "       ORG.CHARGENAME,  ORG.CHARGEKNAME,                    " & vbLf & _
              "       ORG.CHARGEEMAIL, ORG.CHARGEPOST,                     " & vbLf & _
              "       ORG.GOVMNGCD,                                        " & vbLf & _
              "       ORG.ISRNO,       ORG.ISRSIGN,     ORG.ISRMARK,       " & vbLf & _
              "       ORG.HEISRNO,     ORG.ISRDIV,                         " & vbLf & _
              "       ORG.BANK,        ORG.BRANCH,                         " & vbLf & _
              "       ORG.ACCOUNTKIND, ORG.ACCOUNTNO,                      " & vbLf & _
              "       ORG.NOTES,                                           " & vbLf & _
              "       ORG.SPARE1,      ORG.SPARE2,      ORG.SPARE3,        " & vbLf & _
              "       ORG.UPDDATE,     ORG.UPDUSER,    HAINSUSER.USERNAME, " & vbLf & _
              "       ORG.ROUNDNOTAXFLG, ORG.ISRGETNAME                    " & vbLf & _
              "  FROM HAINSUSER, PREF, ORG                                 "
    strStmt = "SELECT ORG.ORGKNAME,    ORG.ORGNAME,     ORG.ORGBILLNAME,   " & vbLf & _
              "       ORG.ORGSNAME,    ORG.ORGDIV,                         " & vbLf & _
              "       ORG.ZIPCD1,      ORG.ZIPCD2,                         " & vbLf & _
              "       ORG.PREFCD,      PREF.PREFNAME,   ORG.CITYNAME,      " & vbLf & _
              "       ORG.ADDRESS1,    ORG.ADDRESS2,                       " & vbLf & _
              "       ORG.TEL1,        ORG.TEL2,        ORG.TEL3,          " & vbLf & _
              "       ORG.DIRECTTEL1,  ORG.DIRECTTEL2,  ORG.DIRECTTEL3,    " & vbLf & _
              "       ORG.EXTENSION,                                       " & vbLf & _
              "       ORG.FAX1,        ORG.FAX2,        ORG.FAX3,          " & vbLf & _
              "       ORG.GOVMNGCD,                                        " & vbLf & _
              "       ORG.ISRNO,       ORG.ISRSIGN,     ORG.ISRMARK,       " & vbLf & _
              "       ORG.HEISRNO,     ORG.ISRDIV,                         " & vbLf & _
              "       ORG.BANK,        ORG.BRANCH,                         " & vbLf & _
              "       ORG.ACCOUNTKIND, ORG.ACCOUNTNO,                      " & vbLf & _
              "       ORG.NOTES,                                           " & vbLf & _
              "       ORG.SPARE1,      ORG.SPARE2,      ORG.SPARE3,        " & vbLf & _
              "       ORG.UPDDATE,     ORG.UPDUSER,    HAINSUSER.USERNAME, " & vbLf & _
              "       ORG.ROUNDNOTAXFLG, ORG.ISRGETNAME                    " & vbLf & _
              "  FROM HAINSUSER, PREF, ORG                                 "

    strStmt = strStmt & vbLf & _
              " WHERE ORG.ORGCD1  = :ORGCD1             " & vbLf & _
              "   AND ORG.ORGCD2  = :ORGCD2             " & vbLf & _
              "   AND ORG.PREFCD  = PREF.PREFCD(+)      " & vbLf & _
              "   AND ORG.UPDUSER = HAINSUSER.USERID(+) " & vbLf & _
              "   AND ORG.DELFLG  = " & CStr(DELFLG_USED)
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgKName = objFields("ORGKNAME")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgSName = objFields("ORGSNAME")
        Set objOrgBillName = objFields("ORGBILLNAME")
        Set objOrgDiv = objFields("ORGDIV")
        Set objZipCd1 = objFields("ZIPCD1")
        Set objZipCd2 = objFields("ZIPCD2")
        Set objPrefCd = objFields("PREFCD")
        Set objPrefName = objFields("PREFNAME")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
        Set objTel1 = objFields("TEL1")
        Set objTel2 = objFields("TEL2")
        Set objTel3 = objFields("TEL3")
        Set objDirectTel1 = objFields("DIRECTTEL1")
        Set objDirectTel2 = objFields("DIRECTTEL2")
        Set objDirectTel3 = objFields("DIRECTTEL3")
        Set objExtension = objFields("EXTENSION")
        Set objFax1 = objFields("FAX1")
        Set objFax2 = objFields("FAX2")
        Set objFax3 = objFields("FAX3")
'### 2003/11/15 Updated by Ishihara@FSIT 担当者はテーブルが移動
'        Set objChargeName = objFields("CHARGENAME")
'        Set objChargeKName = objFields("CHARGEKNAME")
'        Set objChargeEMail = objFields("CHARGEEMAIL")
'        Set objChargePost = objFields("CHARGEPOST")
        Set objGovMngCd = objFields("GOVMNGCD")
        Set objIsrNo = objFields("ISRNO")
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrMark = objFields("ISRMARK")
        Set objHeIsrNo = objFields("HEISRNO")
        Set objIsrDiv = objFields("ISRDIV")
        Set objBank = objFields("BANK")
        Set objBranch = objFields("BRANCH")
        Set objAccountKind = objFields("ACCOUNTKIND")
        Set objAccountNo = objFields("ACCOUNTNO")
        Set objNotes = objFields("NOTES")
        Set objSpare1 = objFields("SPARE1")
        Set objSpare2 = objFields("SPARE2")
        Set objSpare3 = objFields("SPARE3")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objRoundNoTaxFlg = objFields("ROUNDNOTAXFLG")
        Set objIsrGetName = objFields("ISRGETNAME")
        
        '戻り値の設定
        If Not IsMissing(vntOrgKName) Then vntOrgKName = objOrgKName.Value & ""
        If Not IsMissing(vntOrgName) Then vntOrgName = objOrgName.Value & ""
        If Not IsMissing(vntOrgSName) Then vntOrgSName = objOrgSName.Value & ""
        If Not IsMissing(vntOrgBillName) Then vntOrgBillName = objOrgBillName.Value & ""
        If Not IsMissing(vntOrgDiv) Then vntOrgDiv = objOrgDiv.Value & ""
        If Not IsMissing(vntZipCd1) Then vntZipCd1 = objZipCd1.Value & ""
        If Not IsMissing(vntZipCd2) Then vntZipCd2 = objZipCd2.Value & ""
        If Not IsMissing(vntPrefCd) Then vntPrefCd = objPrefCd.Value & ""
        If Not IsMissing(vntPrefName) Then vntPrefName = objPrefName.Value & ""
        If Not IsMissing(vntCityName) Then vntCityName = objCityName.Value & ""
        If Not IsMissing(vntAddress1) Then vntAddress1 = objAddress1.Value & ""
        If Not IsMissing(vntAddress2) Then vntAddress2 = objAddress2.Value & ""
        If Not IsMissing(vntTel1) Then vntTel1 = objTel1.Value & ""
        If Not IsMissing(vntTel2) Then vntTel2 = objTel2.Value & ""
        If Not IsMissing(vntTel3) Then vntTel3 = objTel3.Value & ""
        If Not IsMissing(vntDirectTel1) Then vntDirectTel1 = objDirectTel1.Value & ""
        If Not IsMissing(vntDirectTel2) Then vntDirectTel2 = objDirectTel2.Value & ""
        If Not IsMissing(vntDirectTel3) Then vntDirectTel3 = objDirectTel3.Value & ""
        If Not IsMissing(vntExtension) Then vntExtension = objExtension.Value & ""
        If Not IsMissing(vntFax1) Then vntFax1 = objFax1.Value & ""
        If Not IsMissing(vntFax2) Then vntFax2 = objFax2.Value & ""
        If Not IsMissing(vntFax3) Then vntFax3 = objFax3.Value & ""
'### 2003/11/15 Updated by Ishihara@FSIT 担当者はテーブルが移動
'        If Not IsMissing(vntChargeName) Then vntChargeName = objChargeName.Value & ""
'        If Not IsMissing(vntChargeKName) Then vntChargeKName = objChargeKName.Value & ""
'        If Not IsMissing(vntChargeEMail) Then vntChargeEMail = objChargeEMail.Value & ""
'        If Not IsMissing(vntChargePost) Then vntChargePost = objChargePost.Value & ""
        
        If Not IsMissing(vntChargeName) Then vntChargeName = ""
        If Not IsMissing(vntChargeKName) Then vntChargeKName = ""
        If Not IsMissing(vntChargeEMail) Then vntChargeEMail = ""
        If Not IsMissing(vntChargePost) Then vntChargePost = ""
        
        If Not IsMissing(vntGovMngCd) Then vntGovMngCd = objGovMngCd.Value & ""
        If Not IsMissing(vntIsrNo) Then vntIsrNo = objIsrNo.Value & ""
        If Not IsMissing(vntIsrSign) Then vntIsrSign = objIsrSign.Value & ""
        If Not IsMissing(vntIsrMark) Then vntIsrMark = objIsrMark.Value & ""
        If Not IsMissing(vntHeIsrNo) Then vntHeIsrNo = objHeIsrNo.Value & ""
        If Not IsMissing(vntIsrDiv) Then vntIsrDiv = objIsrDiv.Value & ""
        If Not IsMissing(vntBank) Then vntBank = objBank.Value & ""
        If Not IsMissing(vntBranch) Then vntBranch = objBranch.Value & ""
        If Not IsMissing(vntAccountKind) Then vntAccountKind = objAccountKind.Value & ""
        If Not IsMissing(vntAccountNo) Then vntAccountNo = objAccountNo.Value & ""
        If Not IsMissing(vntNotes) Then vntNotes = objNotes.Value & ""
        If Not IsMissing(vntSpare1) Then vntSpare1 = objSpare1.Value & ""
        If Not IsMissing(vntSpare2) Then vntSpare2 = objSpare2.Value & ""
        If Not IsMissing(vntSpare3) Then vntSpare3 = objSpare3.Value & ""
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntUpdUser) Then vntUpdUser = objUpdUser.Value & ""
        If Not IsMissing(vntUserName) Then vntUserName = objUserName.Value & ""
        If Not IsMissing(vntRoundNoTaxFlg) Then vntRoundNoTaxFlg = objRoundNoTaxFlg.Value & ""
        If Not IsMissing(vntIsrGetName) Then vntIsrGetName = objIsrGetName.Value & ""
        
        SelectOrg = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectOrg = False

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectOrg"
    
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
'### 「１年目はがき非出力フラグ」追加 2003.11.14
'### 「利用券区分」,「利用券請求書添付」,「利用券センターより連絡」,「利用券本人より連絡」,
'    「契約日付」追加 2003.12.01  by FFC
'
' 機能　　 : 団体コードをキーに団体テーブルを読み込む（聖路加バージョン）
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　 : (In)     strOrgCd2       団体コード2
' 　　　　 : (Out)    vntDelFlg       使用状態
' 　　　　 : (Out)    vntOrgKName     カナ名称
' 　　　　 : (Out)    vntOrgName      漢字名称
' 　　　　 : (Out)    vntOrgEName     漢字名称（英語）
' 　　　　 : (Out)    vntOrgSName     略称
' 　　　　 : (Out)    vntOrgDivCd     団体種別
' 　　　　 : (Out)    vntOrgBILLNAME  請求書用名称
' 　　　　 : (Out)    vntChargeName   担当者氏名
' 　　　　 : (Out)    vntChargeKName  担当者カナ名
' 　　　　 : (Out)    vntChargeEmail  担当者E-Mailアドレス
' 　　　　 : (Out)    vntChargePost   担当者部署名
' 　　　　 : (Out)    vntBank         銀行名
' 　　　　 : (Out)    vntBranch       支店名
' 　　　　 : (Out)    vntAccountKind  口座種別
' 　　　　 : (Out)    vntAccountNo    口座番号
' 　　　　 : (Out)    vntNumEmp       社員数
' 　　　　 : (Out)    vntAvgAge       平均年齢
' 　　　　 : (Out)    vntDM           ＤＭ
' 　　　　 : (Out)    vntSendMethod   送付方法
' 　　　　 : (Out)    vntPostCard     確認はがき
' 　　　　 : (Out)    vntPackageSend  一括送付案内
' 　　　　 : (Out)    vntTicket       利用券
' 　　　　 : (Out)    vntInsCheck     保険証予約時確認
' 　　　　 : (Out)    vntInsBring     保険証当日持参
' 　　　　 : (Out)    vntInsReport    保険証成績所出力
' 　　　　 : (Out)    vntBillAddress   請求書適用住所
' 　　　　 : (Out)    vntBillCslDiv   請求書本人家族区分
' 　　　　 : (Out)    vntBillIns      請求書保険証情報出力
' 　　　　 : (Out)    vntBillEmpNo    請求書社員番号出力
' 　　　　 : (Out)    vntBillReport   請求書成績書添付
' 　　　　 : (Out)    vntSendComment  送付案内コメント
' 　　　　 : (Out)    vntSendEComment 英語送付案内コメント
' 　　　　 : (Out)    vntSpare1       予備1
' 　　　　 : (Out)    vntSpare2       予備2
' 　　　　 : (Out)    vntSpare3       予備3
' 　　　　 : (Out)    vntNotes        特記事項
' 　　　　 : (Out)    vntDmdComment   請求関連コメント
' 　　　　 : (Out)    vntUpdDate      更新日時
' 　　　　 : (Out)    vntUpdUser      更新者
' 　　　　 : (Out)    vntUserName     更新者名
' 　　　　 : (Out)    vntNoPrintLetter１年目はがき非出力フラグ
' 　　　　 : (Out)    vntVisitDate    定期訪問予定日
' 　　　　 : (Out)    vntPresents     年始・中元・歳暮
' 　　　　 : (Out)    vntTicketDiv           利用券区分
' 　　　　 : (Out)    vntTicketAddBill       利用券請求書添付
' 　　　　 : (Out)    vntTicketCenterCall    利用券センターより連絡
' 　　　　 : (Out)    vntTicketperCall       利用券本人より連絡
' 　　　　 : (Out)    vntCtrptDate           契約日付
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
' 　　　　 : (Out)    vntReptCslDiv   成績書本人家族区分出力
'## 2004.01.29 Add End
' 　　　　 : (Out)    vntBillSpecial  請求書特定健診レポート出力
' 　　　　 : (Out)    vntBillAge      請求書年齢出力
'
'## 2012.12.24 張 項目追加 Start
' 　　　　 : (Out)    vntHighLight    団体名称ハイライト表示区分
'## 2012.12.24 張 項目追加 End
'
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'Public Function SelectOrg_Lukes(
'    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String,
'    Optional ByRef vntDelFlg As Variant, Optional ByRef vntOrgKName As Variant, Optional ByRef vntOrgName As Variant,
'    Optional ByRef vntOrgEName As Variant, Optional ByRef vntOrgSName As Variant, Optional ByRef vntOrgDivCd As Variant,
'    Optional ByRef vntOrgBillName As Variant, Optional ByRef vntChargeName As Variant,
'    Optional ByRef vntChargeKName As Variant, Optional ByRef vntChargeEMail As Variant,
'    Optional ByRef vntChargePost As Variant, Optional ByRef vntBank As Variant, Optional ByRef vntBranch As Variant,
'    Optional ByRef vntAccountKind As Variant, Optional ByRef vntAccountNo As Variant, Optional ByRef vntNumEmp As Variant,
'    Optional ByRef vntAvgAge As Variant,
'    Optional ByRef vntDM As Variant, Optional ByRef vntSendMethod As Variant, Optional ByRef vntPostCard As Variant,
'    Optional ByRef vntPackageSend As Variant, Optional ByRef vntTicket As Variant, Optional ByRef vntInsCheck As Variant,
'    Optional ByRef vntInsBring As Variant, Optional ByRef vntInsReport As Variant, Optional ByRef vntBillAddress As Variant,
'    Optional ByRef vntBillCslDiv As Variant, Optional ByRef vntBillIns As Variant, Optional ByRef vntBillEmpNo As Variant,
'    Optional ByRef vntBillReport As Variant, Optional ByRef vntSendComment As Variant, Optional ByRef vntSendEComment As Variant,
'    Optional ByRef vntSpare1 As Variant, Optional ByRef vntSpare2 As Variant, Optional ByRef vntSpare3 As Variant,
'    Optional ByRef vntNotes As Variant, Optional ByRef vntDmdComment As Variant,
'    Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant,
'    Optional ByRef vntNoPrintLetter As Variant, Optional ByRef vntVisitDate As Variant, Optional ByRef vntPresents As Variant,
'    Optional ByRef vntTicketDiv As Variant, Optional ByRef vntTicketAddBill As Variant,
'    Optional ByRef vntTicketCenterCall As Variant, Optional ByRef vntTicketperCall As Variant,
'    Optional ByRef vntCtrptDate As Variant
') As Boolean

'## FD発送(BILLFD)項目追加 2005.05.05 張
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張
'## 請求書年齢(BILLAGE)項目追加 2009.05.20 張
'## 団体名称ハイライト表示区分(vntHighLight)追加 2013.12.24 張
Public Function SelectOrg_Lukes( _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    Optional ByRef vntDelFlg As Variant, Optional ByRef vntOrgKName As Variant, Optional ByRef vntOrgName As Variant, _
    Optional ByRef vntOrgEName As Variant, Optional ByRef vntOrgSName As Variant, Optional ByRef vntOrgDivCd As Variant, _
    Optional ByRef vntOrgBillName As Variant, Optional ByRef vntChargeName As Variant, _
    Optional ByRef vntChargeKName As Variant, Optional ByRef vntChargeEMail As Variant, _
    Optional ByRef vntChargePost As Variant, Optional ByRef vntBank As Variant, Optional ByRef vntBranch As Variant, _
    Optional ByRef vntAccountKind As Variant, Optional ByRef vntAccountNo As Variant, Optional ByRef vntNumEmp As Variant, _
    Optional ByRef vntAvgAge As Variant, _
    Optional ByRef vntDM As Variant, Optional ByRef vntSendMethod As Variant, Optional ByRef vntPostCard As Variant, _
    Optional ByRef vntPackageSend As Variant, Optional ByRef vntTicket As Variant, Optional ByRef vntInsCheck As Variant, _
    Optional ByRef vntInsBring As Variant, Optional ByRef vntInsReport As Variant, Optional ByRef vntBillAddress As Variant, _
    Optional ByRef vntBillCslDiv As Variant, Optional ByRef vntBillIns As Variant, Optional ByRef vntBillEmpNo As Variant, _
    Optional ByRef vntBillReport As Variant, Optional ByRef vntBillFD As Variant, Optional ByRef vntSendComment As Variant, Optional ByRef vntSendEComment As Variant, _
    Optional ByRef vntSpare1 As Variant, Optional ByRef vntSpare2 As Variant, Optional ByRef vntSpare3 As Variant, _
    Optional ByRef vntNotes As Variant, Optional ByRef vntDmdComment As Variant, _
    Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant, _
    Optional ByRef vntNoPrintLetter As Variant, Optional ByRef vntVisitDate As Variant, Optional ByRef vntPresents As Variant, _
    Optional ByRef vntTicketDiv As Variant, Optional ByRef vntTicketAddBill As Variant, _
    Optional ByRef vntTicketCenterCall As Variant, Optional ByRef vntTicketperCall As Variant, _
    Optional ByRef vntCtrptDate As Variant, Optional ByRef vntReptCslDiv As Variant, Optional ByRef vntBillSpecial As Variant, Optional ByRef vntBillAge As Variant, _
    Optional ByRef vntHighLight As Variant _
) As Boolean
'## 2004.01.29 Mod End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト

    Dim objDelFlg           As OraField         '使用状態
    Dim objOrgKName         As OraField         'カナ名称
    Dim objOrgName          As OraField         '漢字名称
    Dim objOrgEName         As OraField         '漢字名称（英語）
    Dim objOrgSName         As OraField         '略称
    Dim objOrgDivCd         As OraField         '団体種別
    Dim objOrgBillName      As OraField         '請求書用名称
    Dim objChargeName       As OraField         '担当者氏名
    Dim objChargeKName      As OraField         '担当者カナ名
    Dim objChargeEMail      As OraField         '担当者E-Mailアドレス
    Dim objChargePost       As OraField         '担当者部署名
    Dim objBank             As OraField         '銀行名
    Dim objBranch           As OraField         '支店名
    Dim objAccountKind      As OraField         '口座種別
    Dim objAccountNo        As OraField         '口座番号
    Dim objNumEmp           As OraField         '社員数
    Dim objAvgAge           As OraField         '平均年齢
    Dim objDM               As OraField         'ＤＭ
    Dim objSendMethod       As OraField         '送付方法
    Dim objPostCard         As OraField         '確認はがき
    Dim objPackageSend      As OraField         '一括送付案内
    Dim objTicket           As OraField         '利用券
    Dim objInsCheck         As OraField         '保険証予約時確認
    Dim objInsBring         As OraField         '保険証当日持参
    Dim objInsReport        As OraField         '保険証成績所出力
    Dim objBillAddress      As OraField         '請求書適用住所
    Dim objBillCslDiv       As OraField         '請求書本人家族区分
    Dim objBillIns          As OraField         '請求書保険証情報出力
    Dim objBillEmpNo        As OraField         '請求書社員番号出力
    Dim objBillReport       As OraField         '請求書成績書添付
'## FD発送(BILLFD)項目追加 2005.05.05 張
    Dim objBillFD           As OraField         'FD発送区分
'## 請求書年齢(BILLAGE)項目追加 2009.05.20 張
    Dim objBillAge          As OraField         '請求書年齢出力
    
    Dim objSendComment      As OraField         '送付案内コメント
    Dim objSendEComment     As OraField         '英語送付案内コメント
    Dim objSpare1           As OraField         '予備1
    Dim objSpare2           As OraField         '予備2
    Dim objSpare3           As OraField         '予備3
    Dim objNotes            As OraField         '特記事項
    Dim objDmdComment       As OraField         '請求関連コメント
    Dim objUpdDate          As OraField         '更新日時
    Dim objUpdUser          As OraField         '更新者
    Dim objUserName         As OraField         '更新者名
    Dim objNoPrintLetter    As OraField         '1年目はがき非出力フラグ
    Dim objVisitDate        As OraField         '定期訪問予定日
    Dim objPresents         As OraField         '年始・中元・歳暮
    Dim objTicketDiv        As OraField         '利用券区分
    Dim objTicketAddBill    As OraField         '利用券請求書添付
    Dim objTicketCenterCall As OraField         '利用券センターより連絡
    Dim objTicketperCall    As OraField         '利用券本人より連絡
    Dim objCtrptDate        As OraField         '契約日付
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
    Dim objReptCslDiv       As OraField         '成績書本人家族区分出力
'## 2004.01.29 Add End

'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張
    Dim objBillSpecial      As OraField         '請求書特定健診レポート
    
'### 団体名称ハイライト表示有無チェックの為、追加 2003/12/26 Start ###
    Dim strFreeField1       As String           '汎用フィールド１
    Dim strFreeField2       As String           '汎用フィールド２
    Dim strFreeField3       As String           '汎用フィールド３
'### 団体名称ハイライト表示有無チェックの為、追加 2003/12/26 End   ###
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntDelFlg) Then vntDelFlg = Empty
    If Not IsMissing(vntOrgKName) Then vntOrgKName = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntOrgEName) Then vntOrgEName = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntOrgDivCd) Then vntOrgDivCd = Empty
    If Not IsMissing(vntOrgBillName) Then vntOrgBillName = Empty
    If Not IsMissing(vntChargeName) Then vntChargeName = Empty
    If Not IsMissing(vntChargeKName) Then vntChargeKName = Empty
    If Not IsMissing(vntChargeEMail) Then vntChargeEMail = Empty
    If Not IsMissing(vntChargePost) Then vntChargePost = Empty
    If Not IsMissing(vntBank) Then vntBank = Empty
    If Not IsMissing(vntBranch) Then vntBranch = Empty
    If Not IsMissing(vntAccountKind) Then vntAccountKind = Empty
    If Not IsMissing(vntAccountNo) Then vntAccountNo = Empty
    If Not IsMissing(vntNumEmp) Then vntNumEmp = Empty
    If Not IsMissing(vntAvgAge) Then vntAvgAge = Empty
    If Not IsMissing(vntDM) Then vntDM = Empty
    If Not IsMissing(vntSendMethod) Then vntSendMethod = Empty
    If Not IsMissing(vntPostCard) Then vntPostCard = Empty
    If Not IsMissing(vntPackageSend) Then vntPackageSend = Empty
    If Not IsMissing(vntTicket) Then vntTicket = Empty
    If Not IsMissing(vntInsCheck) Then vntInsCheck = Empty
    If Not IsMissing(vntInsBring) Then vntInsBring = Empty
    If Not IsMissing(vntInsReport) Then vntInsReport = Empty
    If Not IsMissing(vntBillAddress) Then vntBillAddress = Empty
    If Not IsMissing(vntBillCslDiv) Then vntBillCslDiv = Empty
    If Not IsMissing(vntBillIns) Then vntBillIns = Empty
    If Not IsMissing(vntBillEmpNo) Then vntBillEmpNo = Empty
    If Not IsMissing(vntBillReport) Then vntBillReport = Empty
'## FD発送(BILLFD)項目追加 2005.05.05 張
    If Not IsMissing(vntBillFD) Then vntBillFD = Empty
    If Not IsMissing(vntSendComment) Then vntSendComment = Empty
    If Not IsMissing(vntSendEComment) Then vntSendEComment = Empty
    If Not IsMissing(vntSpare1) Then vntSpare1 = Empty
    If Not IsMissing(vntSpare2) Then vntSpare2 = Empty
    If Not IsMissing(vntSpare3) Then vntSpare3 = Empty
    If Not IsMissing(vntNotes) Then vntNotes = Empty
    If Not IsMissing(vntDmdComment) Then vntDmdComment = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUserName) Then vntUserName = Empty
    If Not IsMissing(vntNoPrintLetter) Then vntNoPrintLetter = Empty
    If Not IsMissing(vntVisitDate) Then vntVisitDate = Empty
    If Not IsMissing(vntPresents) Then vntPresents = Empty
    If Not IsMissing(vntTicketDiv) Then vntTicketDiv = Empty
    If Not IsMissing(vntTicketAddBill) Then vntTicketAddBill = Empty
    If Not IsMissing(vntTicketCenterCall) Then vntTicketCenterCall = Empty
    If Not IsMissing(vntTicketperCall) Then vntTicketperCall = Empty
    If Not IsMissing(vntCtrptDate) Then vntCtrptDate = Empty
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
    If Not IsMissing(vntReptCslDiv) Then vntReptCslDiv = Empty
'## 2004.01.29 Add End

'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張
    If Not IsMissing(vntBillSpecial) Then vntBillSpecial = Empty

'## 請求書年齢(BILLAGE)項目追加 2009.05.20 張
    If Not IsMissing(vntBillAge) Then vntBillAge = Empty

'## 団体名称ハイライト表示区分(vntHighLight)追加 2013.12.24 張
'    If Not IsMissing(vntHighLight) Then vntHighLight = Empty


    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす団体テーブルのレコードを取得
'    strStmt = "SELECT ORG.DELFLG,      ORG.ORGKNAME,     ORG.ORGNAME,      " & vbLf & _
              "       ORG.ORGENAME,    ORG.ORGSNAME,     ORG.ORGDIVCD,     " & vbLf & _
              "       ORG.ORGBILLNAME, ORG.CHARGENAME,   ORG.CHARGEKNAME,  " & vbLf & _
              "       ORG.CHARGEEMAIL, ORG.CHARGEPOST,                     " & vbLf & _
              "       ORG.BANK,        ORG.BRANCH,                         " & vbLf & _
              "       ORG.ACCOUNTKIND, ORG.ACCOUNTNO,                      " & vbLf & _
              "       ORG.NUMEMP,      ORG.AVGAGE,                         " & vbLf & _
              "       ORG.DIRECTMAIL,                                      " & vbLf & _
              "       ORG.SENDMETHOD,  ORG.POSTCARD,     ORG.PACKAGESEND,  " & vbLf & _
              "       ORG.TICKET,      ORG.INSCHECK,     ORG.INSBRING,     " & vbLf & _
              "       ORG.INSREPORT,                                       " & vbLf & _
              "       ORG.BILLADDRESS, ORG.BILLCSLDIV,   ORG.BILLINS,      " & vbLf & _
              "       ORG.BILLEMPNO,   ORG.BILLREPORT,                     " & vbLf & _
              "       ORG.SENDCOMMENT, ORG.SENDECOMMENT,                   " & vbLf & _
              "       ORG.SPARE1,      ORG.SPARE2,       ORG.SPARE3,       " & vbLf & _
              "       ORG.NOTES,       ORG.DMDCOMMENT,                     " & vbLf & _
              "       ORG.UPDDATE,     ORG.UPDUSER,    HAINSUSER.USERNAME, " & vbLf & _
              "       ORG.NOPRINTLETTER,                                   " & vbLf & _
              "       ORG.VISITDATE,   ORG.PRESENTS                        " & vbLf & _
              "  FROM HAINSUSER, ORG                                       "
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'    strStmt = "SELECT ORG.DELFLG,      ORG.ORGKNAME,     ORG.ORGNAME,      " & vbLf & _
'              "       ORG.ORGENAME,    ORG.ORGSNAME,     ORG.ORGDIVCD,     " & vbLf & _
'              "       ORG.ORGBILLNAME,   " & vbLf & _
'              "       ORG.BANK,        ORG.BRANCH,                         " & vbLf & _
'              "       ORG.ACCOUNTKIND, ORG.ACCOUNTNO,                      " & vbLf & _
'              "       ORG.NUMEMP,      ORG.AVGAGE,                         " & vbLf & _
'              "       ORG.DIRECTMAIL,                                      " & vbLf & _
'              "       ORG.SENDMETHOD,  ORG.POSTCARD,     ORG.PACKAGESEND,  " & vbLf & _
'              "       ORG.TICKET,      ORG.INSCHECK,     ORG.INSBRING,     " & vbLf & _
'              "       ORG.INSREPORT,                                       " & vbLf & _
'              "       ORG.BILLADDRESS, ORG.BILLCSLDIV,   ORG.BILLINS,      " & vbLf & _
'              "       ORG.BILLEMPNO,   ORG.BILLREPORT,                     " & vbLf & _
'              "       ORG.SENDCOMMENT, ORG.SENDECOMMENT,                   " & vbLf & _
'              "       ORG.SPARE1,      ORG.SPARE2,       ORG.SPARE3,       " & vbLf & _
'              "       ORG.NOTES,       ORG.DMDCOMMENT,                     " & vbLf & _
'              "       ORG.UPDDATE,     ORG.UPDUSER,    HAINSUSER.USERNAME, " & vbLf & _
'              "       ORG.NOPRINTLETTER,                                   " & vbLf & _
'              "       ORG.VISITDATE,   ORG.PRESENTS,                       " & vbLf & _
'              "       ORG.TICKETDIV,        ORG.TICKETADDBILL,             " & vbLf & _
'              "       ORG.TICKETCENTERCALL, ORG.TICKETPERCALL,             " & vbLf & _
'              "       ORG.CTRPTDATE                                        " & vbLf & _
'              "  FROM HAINSUSER, ORG                                       "
'## FD発送(BILLFD)項目追加 2005.05.05 張
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張
    strStmt = "SELECT ORG.DELFLG,      ORG.ORGKNAME,     ORG.ORGNAME,      " & vbLf & _
              "       ORG.ORGENAME,    ORG.ORGSNAME,     ORG.ORGDIVCD,     " & vbLf & _
              "       ORG.ORGBILLNAME,   " & vbLf & _
              "       ORG.BANK,        ORG.BRANCH,                         " & vbLf & _
              "       ORG.ACCOUNTKIND, ORG.ACCOUNTNO,                      " & vbLf & _
              "       ORG.NUMEMP,      ORG.AVGAGE,                         " & vbLf & _
              "       ORG.DIRECTMAIL,                                      " & vbLf & _
              "       ORG.SENDMETHOD,  ORG.POSTCARD,     ORG.PACKAGESEND,  " & vbLf & _
              "       ORG.TICKET,      ORG.INSCHECK,     ORG.INSBRING,     " & vbLf & _
              "       ORG.INSREPORT,                                       " & vbLf & _
              "       ORG.BILLADDRESS, ORG.BILLCSLDIV,   ORG.BILLINS,      " & vbLf & _
              "       ORG.BILLEMPNO,   ORG.BILLREPORT,   ORG.BILLFD,       " & vbLf & _
              "       ORG.SENDCOMMENT, ORG.SENDECOMMENT,                   " & vbLf & _
              "       ORG.SPARE1,      ORG.SPARE2,       ORG.SPARE3,       " & vbLf & _
              "       ORG.NOTES,       ORG.DMDCOMMENT,                     " & vbLf & _
              "       ORG.UPDDATE,     ORG.UPDUSER,    HAINSUSER.USERNAME, " & vbLf & _
              "       ORG.NOPRINTLETTER,                                   " & vbLf & _
              "       ORG.VISITDATE,   ORG.PRESENTS,                       " & vbLf & _
              "       ORG.TICKETDIV,        ORG.TICKETADDBILL,             " & vbLf & _
              "       ORG.TICKETCENTERCALL, ORG.TICKETPERCALL,             " & vbLf & _
              "       ORG.CTRPTDATE,   ORG.REPTCSLDIV,   ORG.BILLSPECIAL,   ORG.BILLAGE   " & vbLf & _
              "  FROM HAINSUSER, ORG                                       "
'## 2004.01.29 Mod End

    strStmt = strStmt & vbLf & _
              " WHERE ORG.ORGCD1  = :ORGCD1             " & vbLf & _
              "   AND ORG.ORGCD2  = :ORGCD2             " & vbLf & _
              "   AND ORG.UPDUSER = HAINSUSER.USERID(+) "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objDelFlg = objFields("DELFLG")
        Set objOrgKName = objFields("ORGKNAME")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgEName = objFields("ORGENAME")
        Set objOrgSName = objFields("ORGSNAME")
        Set objOrgDivCd = objFields("ORGDIVCD")
        Set objOrgBillName = objFields("ORGBILLNAME")
'        Set objChargeName = objFields("CHARGENAME")
'        Set objChargeKName = objFields("CHARGEKNAME")
'        Set objChargeEMail = objFields("CHARGEEMAIL")
'        Set objChargePost = objFields("CHARGEPOST")
        Set objBank = objFields("BANK")
        Set objBranch = objFields("BRANCH")
        Set objAccountKind = objFields("ACCOUNTKIND")
        Set objAccountNo = objFields("ACCOUNTNO")
        Set objNumEmp = objFields("NUMEMP")
        Set objAvgAge = objFields("AVGAGE")
        Set objDM = objFields("DIRECTMAIL")
        Set objSendMethod = objFields("SENDMETHOD")
        Set objPostCard = objFields("POSTCARD")
        Set objPackageSend = objFields("PACKAGESEND")
        Set objTicket = objFields("TICKET")
        Set objInsCheck = objFields("INSCHECK")
        Set objInsBring = objFields("INSBRING")
        Set objInsReport = objFields("INSREPORT")
        Set objBillAddress = objFields("BILLADDRESS")
        Set objBillCslDiv = objFields("BILLCSLDIV")
        Set objBillIns = objFields("BILLINS")
        Set objBillEmpNo = objFields("BILLEMPNO")
        Set objBillReport = objFields("BILLREPORT")
'## FD発送(BILLFD)項目追加 2005.05.05 張
        Set objBillFD = objFields("BILLFD")
        Set objSendComment = objFields("SENDCOMMENT")
        Set objSendEComment = objFields("SENDECOMMENT")
        Set objSpare1 = objFields("SPARE1")
        Set objSpare2 = objFields("SPARE2")
        Set objSpare3 = objFields("SPARE3")
        Set objNotes = objFields("NOTES")
        Set objDmdComment = objFields("DMDCOMMENT")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objNoPrintLetter = objFields("NOPRINTLETTER")
        Set objVisitDate = objFields("VISITDATE")
        Set objPresents = objFields("PRESENTS")
        Set objTicketDiv = objFields("TICKETDIV")
        Set objTicketAddBill = objFields("TICKETADDBILL")
        Set objTicketCenterCall = objFields("TICKETCENTERCALL")
        Set objTicketperCall = objFields("TICKETPERCALL")
        Set objCtrptDate = objFields("CTRPTDATE")
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
        Set objReptCslDiv = objFields("REPTCSLDIV")
'## 2004.01.29 Add End

'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.02.07 張 Start
        Set objBillSpecial = objFields("BILLSPECIAL")
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.02.07 張 End

'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張
        Set objBillAge = objFields("BILLAGE")

        '戻り値の設定
        If Not IsMissing(vntDelFlg) Then vntDelFlg = objDelFlg.Value & ""
        If Not IsMissing(vntOrgKName) Then vntOrgKName = objOrgKName.Value & ""
        If Not IsMissing(vntOrgName) Then vntOrgName = objOrgName.Value & ""
        If Not IsMissing(vntOrgEName) Then vntOrgEName = objOrgEName.Value & ""
        If Not IsMissing(vntOrgSName) Then vntOrgSName = objOrgSName.Value & ""
        If Not IsMissing(vntOrgDivCd) Then vntOrgDivCd = objOrgDivCd.Value & ""
        If Not IsMissing(vntOrgBillName) Then vntOrgBillName = objOrgBillName.Value & ""
        
'        If Not IsMissing(vntChargeName) Then vntChargeName = objChargeName.Value & ""
'        If Not IsMissing(vntChargeKName) Then vntChargeKName = objChargeKName.Value & ""
'        If Not IsMissing(vntChargeEMail) Then vntChargeEMail = objChargeEMail.Value & ""
'        If Not IsMissing(vntChargePost) Then vntChargePost = objChargePost.Value & ""
        
        If Not IsMissing(vntBank) Then vntBank = objBank.Value & ""
        If Not IsMissing(vntBranch) Then vntBranch = objBranch.Value & ""
        If Not IsMissing(vntAccountKind) Then vntAccountKind = objAccountKind.Value & ""
        If Not IsMissing(vntAccountNo) Then vntAccountNo = objAccountNo.Value & ""
        If Not IsMissing(vntNumEmp) Then vntNumEmp = objNumEmp.Value & ""
        If Not IsMissing(vntAvgAge) Then vntAvgAge = objAvgAge.Value & ""
        If Not IsMissing(vntDM) Then vntDM = objDM.Value & ""
        If Not IsMissing(vntSendMethod) Then vntSendMethod = objSendMethod.Value & ""
        If Not IsMissing(vntPostCard) Then vntPostCard = objPostCard.Value & ""
        If Not IsMissing(vntPackageSend) Then vntPackageSend = objPackageSend.Value & ""
        If Not IsMissing(vntTicket) Then vntTicket = objTicket.Value & ""
        If Not IsMissing(vntInsCheck) Then vntInsCheck = objInsCheck.Value & ""
        If Not IsMissing(vntInsBring) Then vntInsBring = objInsBring.Value & ""
        If Not IsMissing(vntInsReport) Then vntInsReport = objInsReport.Value & ""
        If Not IsMissing(vntBillAddress) Then vntBillAddress = objBillAddress.Value & ""
        If Not IsMissing(vntBillCslDiv) Then vntBillCslDiv = objBillCslDiv.Value & ""
        If Not IsMissing(vntBillIns) Then vntBillIns = objBillIns.Value & ""
        If Not IsMissing(vntBillEmpNo) Then vntBillEmpNo = objBillEmpNo.Value & ""
        If Not IsMissing(vntBillReport) Then vntBillFD = objBillFD.Value & ""
'## FD発送(BILLFD)項目追加 2005.05.05 張
        If Not IsMissing(vntBillFD) Then vntBillReport = objBillReport.Value & ""
        If Not IsMissing(vntSendComment) Then vntSendComment = objSendComment.Value & ""
        If Not IsMissing(vntSendEComment) Then vntSendEComment = objSendEComment.Value & ""
        If Not IsMissing(vntSpare1) Then vntSpare1 = objSpare1.Value & ""
        If Not IsMissing(vntSpare2) Then vntSpare2 = objSpare2.Value & ""
        If Not IsMissing(vntSpare3) Then vntSpare3 = objSpare3.Value & ""
        If Not IsMissing(vntNotes) Then vntNotes = objNotes.Value & ""
        If Not IsMissing(vntDmdComment) Then vntDmdComment = objDmdComment.Value & ""
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntUpdUser) Then vntUpdUser = objUpdUser.Value & ""
        If Not IsMissing(vntUserName) Then vntUserName = objUserName.Value & ""
        If Not IsMissing(vntNoPrintLetter) Then vntNoPrintLetter = objNoPrintLetter.Value & ""
        If Not IsMissing(vntVisitDate) Then vntVisitDate = objVisitDate.Value & ""
        If Not IsMissing(vntPresents) Then vntPresents = objPresents.Value & ""
        If Not IsMissing(vntTicketDiv) Then vntTicketDiv = objTicketDiv.Value & ""
        If Not IsMissing(vntTicketAddBill) Then vntTicketAddBill = objTicketAddBill.Value & ""
        If Not IsMissing(vntTicketCenterCall) Then vntTicketCenterCall = objTicketCenterCall.Value & ""
        If Not IsMissing(vntTicketperCall) Then vntTicketperCall = objTicketperCall.Value & ""
        If Not IsMissing(vntCtrptDate) Then vntCtrptDate = objCtrptDate.Value & ""
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
        If Not IsMissing(vntReptCslDiv) Then vntReptCslDiv = objReptCslDiv.Value & ""
'## 2004.01.29 Add End

'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.02.07 張 Start
        If Not IsMissing(vntBillSpecial) Then vntBillSpecial = objBillSpecial.Value & ""
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.02.07 張 End
        
'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張
        If Not IsMissing(vntBillAge) Then vntBillAge = objBillAge.Value & ""
        
        
'## 汎用項目３(SPARE3)に登録されているデータが「10桁」で日付タイプの場合団体名称ハイライト表示 2013.12.24 張 Start
        vntHighLight = "0"
        If (SelectFree(CON_FREECD, strFreeField1, strFreeField2, strFreeField3)) Then
            
            Select Case strFreeField2
                '日付形式
                Case "DATE"
                    If IsNumeric(Trim(strFreeField1)) Then
                        If Len(Trim(objSpare3.Value & "")) = CLng(Trim(strFreeField1)) And IsDate(Trim(objSpare3.Value & "")) Then
                            vntHighLight = "1"
                        End If
                    Else
                        If IsDate(Trim(objSpare3.Value & "")) Then
                            vntHighLight = "1"
                        End If
                    End If
        
                Case "FIX"
                    If Trim(strFreeField3) <> "" And Trim(objSpare3.Value & "") = Trim(strFreeField3) Then
                        vntHighLight = "1"
                    End If
                
                'それ以外の場合
                Case Else
                    vntHighLight = "0"
            End Select
        
        End If
        
'        If Len(Trim(objSpare3.Value & "")) = 10 And IsDate(Trim(objSpare3.Value & "")) Then
'            vntHighLight = "1"
'        End If
'## 汎用項目３(SPARE3)に登録されているデータが「10桁」で日付タイプの場合団体名称ハイライト表示 2013.12.24 張 End
        
        SelectOrg_Lukes = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectOrg_Lukes = False

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectOrg_Lukes"
    
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

'###############################################################################
'
'### 団体名称ハイライト表示有無チェックの為、追加 2003/12/26
'
' 機能　　 : 汎用コードで汎用テーブルを読み込む
'
' 引数　　 : (In)     strFreeCd1      汎用コード
' 　　　　 : (Out)    strFreeField1   汎用フィールド１
' 　　　　 : (Out)    strFreeField2   汎用フィールド２
' 　　　　 : (Out)    strFreeField3   汎用フィールド３
'
' 戻り値　 : True   レコードあり
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 : 2013/12/16 張
'
'###############################################################################

Private Function SelectFree(ByVal strFreeCd As String, _
                            Optional ByRef strFreeField1 As String, _
                            Optional ByRef strFreeField2 As String, _
                            Optional ByRef strFreeField3 As String) As Boolean

    Dim objOraParam         As OraParameters        'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset           'ダイナセット
    Dim objFields           As OraFields            'フィールドコレクション
    
    Dim strStmt             As String               'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "FREECD", strFreeCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定オプション検査項目を取得
    strStmt = "SELECT FREEFIELD1 ,FREEFIELD2, FREEFIELD3        " & vbLf & _
              "  FROM FREE                                      " & vbLf & _
              " WHERE FREECD = :FREECD                          "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        Set objFields = objOraDyna.Fields

        strFreeField1 = Format(objFields("FREEFIELD1"))
        strFreeField2 = Format(objFields("FREEFIELD2"))
        strFreeField3 = Format(objFields("FREEFIELD3"))

        '戻り値の設定
        SelectFree = True
    Else

        SelectFree = False
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:
    
    SelectFree = False

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectFree"
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'
' #### 聖路加対応で未使用になった項目は削除しました。2003.11.14
'### 「利用券区分」,「利用券請求書添付」,「利用券センターより連絡」,「利用券本人より連絡」,
'    「契約日付」追加 2003.12.01  by FFC
'### 「定期訪問予定日」DATE型　→ NUMBER(2)　変更 2003.12.01  by FFC
'
' 機能　　 : 団体テーブルレコードを挿入する
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　 : (In)     strOrgCd2       団体コード2
' 　　　　 : (In)     strDelFlg       使用状態
' 　　　　 : (In)     strOrgKName     カナ名称
' 　　　　 : (In)     strOrgName      漢字名称
' 　　　　 : (In)     strOrgEName     漢字名称（英語）
' 　　　　 : (In)     strOrgSName     略称
' 　　　　 : (In)     strOrgDivCd     団体種別
' 　　　　 : (In)     strOrgBILLNAME  請求書用名称
' 　　　　 : (In)     strBank         銀行名
' 　　　　 : (In)     strBranch       支店名
' 　　　　 : (In)     strAccountKind  口座種別
' 　　　　 : (In)     strAccountNo    口座番号
' 　　　　 : (In)     strNumEmp       社員数
' 　　　　 : (In)     strAvgAge       平均年齢
' 　　　　 : (In)     strDM           ＤＭ
' 　　　　 : (In)     strSendMethod   送付方法
' 　　　　 : (In)     strPostCard     確認はがき
' 　　　　 : (In)     strPackageSend  一括送付案内
' 　　　　 : (In)     strTicket       利用券
' 　　　　 : (In)     strInsCheck     保険証予約時確認
' 　　　　 : (In)     strInsBring     保険証当日持参
' 　　　　 : (In)     strInsReport    保険証成績所出力
' 　　　　 : (In)     strBillAddress   請求書適用住所
' 　　　　 : (In)     strBillCslDiv   請求書本人家族区分
' 　　　　 : (In)     strBillIns      請求書保険証情報出力
' 　　　　 : (In)     strBillEmpNo    請求書社員番号出力
' 　　　　 : (In)     strBillReport   請求書成績書添付
' 　　　　 : (In)     strSendComment  送付案内コメント
' 　　　　 : (In)     strSendEComment 英語送付案内コメント
' 　　　　 : (In)     strSpare1       予備1
' 　　　　 : (In)     strSpare2       予備2
' 　　　　 : (In)     strSpare3       予備3
' 　　　　 : (In)     strNotes        特記事項
' 　　　　 : (In)     strDmdComment   請求関連コメント
' 　　　　 : (In)     strUpdUser      更新者
' 　　　　 : (In)     strNoPrintLetter1年目はがき非出力フラグ
' 　　　　 : (In)     strVisitDate    定期訪問予定日
' 　　　　 : (In)     strPresents     年始・中元・歳暮
' 　　　　 : (In)     strTicketDiv           利用券区分
' 　　　　 : (In)     strTicketAddBill       利用券請求書添付
' 　　　　 : (In)     strTicketCenterCall    利用券センターより連絡
' 　　　　 : (In)     strTicketperCall       利用券本人より連絡
' 　　　　 : (In)     strCtrptDate           契約日付
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
' 　　　　 : (In)     strReptCslDiv  成績書本人家族区分出力
'## 2004.01.29 Add End
'
' 戻り値　 : 1   正常終了
' 　　　　 : 0   同一キーのレコード存在
' 　　　　 : -1  異常終了
'
' 備考　　 :
'
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'Public Function InsertOrg(
'    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String,
'    ByVal strDelFlg As String, ByVal strOrgKName As String, ByVal strOrgName As String,
'    ByVal strOrgEName As String, ByVal strOrgSName As String, ByVal strOrgDivCd As String,
'    ByVal strOrgBillName As String,
'    ByVal strBank As String, ByVal strBranch As String,
'    ByVal strAccountKind As String, ByVal strAccountNo As String, ByVal strNumEmp As String,
'    ByVal strAvgAge As String,
'    ByVal strDM As String, ByVal strSendMethod As String, ByVal strPostCard As String,
'    ByVal strPackageSend As String, ByVal strTicket As String, ByVal strInsCheck As String,
'    ByVal strInsBring As String, ByVal strInsReport As String, ByVal strBillAddress As String,
'    ByVal strBillCslDiv As String, ByVal strBillIns As String, ByVal strBillEmpNo As String,
'    ByVal strBillReport As String, ByVal strSendComment As String, ByVal strSendEComment As String,
'    ByVal strSpare1 As String, ByVal strSpare2 As String, ByVal strSpare3 As String,
'    ByVal strNotes As String, ByVal strDmdComment As String,
'    ByVal strUpdUser As String, ByVal strNoPrintLetter As String,
'    ByVal strVisitDate As String, ByVal strPresents As String,
'    ByVal strTicketDiv As String, ByVal strTicketAddBill As String,
'    ByVal strTicketCenterCall As String, ByVal strTicketperCall As String,
'    ByVal strCtrptDate As String
') As Boolean

'## FD発送(BILLFD)項目追加 2005.05.05 張
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張
'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張

Public Function InsertOrg( _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    ByVal strDelFlg As String, ByVal strOrgKName As String, ByVal strOrgName As String, _
    ByVal strOrgEName As String, ByVal strOrgSName As String, ByVal strOrgDivCd As String, _
    ByVal strOrgBillName As String, _
    ByVal strBank As String, ByVal strBranch As String, _
    ByVal strAccountKind As String, ByVal strAccountNo As String, ByVal strNumEmp As String, _
    ByVal strAvgAge As String, _
    ByVal strDM As String, ByVal strSendMethod As String, ByVal strPostCard As String, _
    ByVal strPackageSend As String, ByVal strTicket As String, ByVal strInsCheck As String, _
    ByVal strInsBring As String, ByVal strInsReport As String, ByVal strBillAddress As String, _
    ByVal strBillCslDiv As String, ByVal strBillIns As String, ByVal strBillEmpNo As String, _
    ByVal strBillReport As String, ByVal strBillFD As String, ByVal strSendComment As String, ByVal strSendEComment As String, _
    ByVal strSpare1 As String, ByVal strSpare2 As String, ByVal strSpare3 As String, _
    ByVal strNotes As String, ByVal strDmdComment As String, _
    ByVal strUpdUser As String, ByVal strNoPrintLetter As String, _
    ByVal strVisitDate As String, ByVal strPresents As String, _
    ByVal strTicketDiv As String, ByVal strTicketAddBill As String, _
    ByVal strTicketCenterCall As String, ByVal strTicketperCall As String, _
    ByVal strCtrptDate As String, ByVal strReptCslDiv As String, ByVal strBillSpecial As String, ByVal strBillAge As String _
) As Boolean
'## 2004.01.29 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DELFLG", Trim(strDelFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "ORGKNAME", StrConv(Trim(strOrgKName), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod By T.Takagi@FSIT 変換方法を変更
'    objOraParam.Add "ORGNAME", StrConv(Trim(strOrgName), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGNAME", Trim(strOrgName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
    objOraParam.Add "ORGENAME", Trim(strOrgEName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod By T.Takagi@FSIT 変換方法を変更
'    objOraParam.Add "ORGSNAME", StrConv(Trim(strOrgSName), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGSNAME", Trim(strOrgSName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
    
    objOraParam.Add "ORGDIVCD", Trim(strOrgDivCd), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.12.17 Mod By T.Takagi@FSIT 変換方法を変更
'    objOraParam.Add "ORGBILLNAME", StrConv(Trim(strOrgBillName), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGBILLNAME", Trim(strOrgBillName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
    
    objOraParam.Add "BANK", StrConv(Trim(strBank), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BRANCH", StrConv(Trim(strBranch), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ACCOUNTKIND", Trim(strAccountKind), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ACCOUNTNO", Trim(strAccountNo), ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "NUMEMP", Trim(strNumEmp), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AVGAGE", Trim(strAvgAge), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DIRECTMAIL", Trim(strDM), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SENDMETHOD", Trim(strSendMethod), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POSTCARD", Trim(strPostCard), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PACKAGESEND", Trim(strPackageSend), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TICKET", Trim(strTicket), ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "INSCHECK", Trim(strInsCheck), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "INSBRING", Trim(strInsBring), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "INSREPORT", Trim(strInsReport), ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "BILLADDRESS", Trim(strBillAddress), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLCSLDIV", Trim(strBillCslDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLINS", Trim(strBillIns), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLEMPNO", Trim(strBillEmpNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLREPORT", Trim(strBillReport), ORAPARM_INPUT, ORATYPE_NUMBER
'## FD発送(BILLFD)項目追加 2005.05.05 張
    objOraParam.Add "BILLFD", Trim(strBillFD), ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "SENDCOMMENT", StrConv(Trim(strSendComment), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SENDECOMMENT", StrConv(Trim(strSendEComment), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    objOraParam.Add "SPARE1", Trim(strSpare1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SPARE2", Trim(strSpare2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SPARE3", Trim(strSpare3), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NOTES", StrConv(Trim(strNotes), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DMDCOMMENT", StrConv(Trim(strDmdComment), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2

    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2

    objOraParam.Add "NOPRINTLETTER", Trim(strNoPrintLetter), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.12.01 Mod 2Line By K.Fujii@FFC
'    objOraParam.Add "VISITDATE", Trim(strVisitDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "VISITDATE", Trim(strVisitDate), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.12.01 Mod End
    objOraParam.Add "PRESENTS", Trim(strPresents), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.12.01 Add 9Line By K.Fujii@FFC
    objOraParam.Add "TICKETDIV", Trim(strTicketDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TICKETADDBILL", Trim(strTicketAddBill), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TICKETCENTERCALL", Trim(strTicketCenterCall), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TICKETPERCALL", Trim(strTicketperCall), ORAPARM_INPUT, ORATYPE_NUMBER
    If strCtrptDate <> "" Then
        objOraParam.Add "CTRPTDATE", Trim(strCtrptDate), ORAPARM_INPUT, ORATYPE_DATE
    Else
        objOraParam.Add "CTRPTDATE", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
'## 2003.12.01 Add End
    
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
    objOraParam.Add "REPTCSLDIV", Trim(strReptCslDiv), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2004.01.29 Add End
    
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張 Start
    objOraParam.Add "BILLSPECIAL", Trim(strBillSpecial), ORAPARM_INPUT, ORATYPE_NUMBER
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張 End

'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張
    objOraParam.Add "BILLAGE", Trim(strBillAge), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '団体レコードの挿入
    strStmt = "INSERT INTO ORG (         " & vbLf & _
              "            ORGCD1,       " & vbLf & _
              "            ORGCD2,       " & vbLf & _
              "            DELFLG,       " & vbLf & _
              "            ORGKNAME,     " & vbLf & _
              "            ORGNAME,      " & vbLf & _
              "            ORGENAME,     " & vbLf & _
              "            ORGSNAME,     " & vbLf & _
              "            ORGDIVCD,     " & vbLf & _
              "            ORGBILLNAME,  " & vbLf & _
              "            BANK,         " & vbLf & _
              "            BRANCH,       " & vbLf & _
              "            ACCOUNTKIND,  " & vbLf & _
              "            ACCOUNTNO,    " & vbLf & _
              "            NUMEMP,       " & vbLf & _
              "            AVGAGE,       " & vbLf & _
              "            VISITDATE,    " & vbLf & _
              "            PRESENTS,     " & vbLf & _
              "            DIRECTMAIL,   " & vbLf & _
              "            SENDMETHOD,   "

'## FD発送(BILLFD)項目追加 2005.05.05 張
    strStmt = strStmt & vbLf & _
              "            POSTCARD,     " & vbLf & _
              "            PACKAGESEND,  " & vbLf & _
              "            TICKET,       " & vbLf & _
              "            NOPRINTLETTER," & vbLf & _
              "            INSCHECK,     " & vbLf & _
              "            INSBRING,     " & vbLf & _
              "            INSREPORT,    " & vbLf & _
              "            BILLADDRESS,  " & vbLf & _
              "            BILLCSLDIV,   " & vbLf & _
              "            BILLINS,      " & vbLf & _
              "            BILLEMPNO,    " & vbLf & _
              "            BILLREPORT,   " & vbLf & _
              "            BILLFD,       " & vbLf & _
              "            SENDCOMMENT,  " & vbLf & _
              "            SENDECOMMENT, " & vbLf & _
              "            SPARE1,       " & vbLf & _
              "            SPARE2,       " & vbLf & _
              "            SPARE3,       " & vbLf & _
              "            NOTES,        " & vbLf & _
              "            DMDCOMMENT,   " & vbLf & _
              "            UPDUSER,      "
    
    strStmt = strStmt & vbLf & _
              "            TICKETDIV,        " & vbLf & _
              "            TICKETADDBILL,    " & vbLf & _
              "            TICKETCENTERCALL, " & vbLf & _
              "            TICKETPERCALL,    " & vbLf & _
              "            CTRPTDATE         "

'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "            REPTCSLDIV        "
'## 2004.01.29 Add End

'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張 Start
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "            BILLSPECIAL       "
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張 End

'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張 Start
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "            BILLAGE       "
'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張 End

    strStmt = strStmt & vbLf & _
              "       ) VALUES (         " & vbLf & _
              "            :ORGCD1,      " & vbLf & _
              "            :ORGCD2,      " & vbLf & _
              "            :DELFLG,      " & vbLf & _
              "            :ORGKNAME,    " & vbLf & _
              "            :ORGNAME,     " & vbLf & _
              "            :ORGENAME,    " & vbLf & _
              "            :ORGSNAME,    " & vbLf & _
              "            :ORGDIVCD,    " & vbLf & _
              "            :ORGBILLNAME, " & vbLf & _
              "            :BANK,        " & vbLf & _
              "            :BRANCH,      " & vbLf & _
              "            :ACCOUNTKIND, " & vbLf & _
              "            :ACCOUNTNO,   " & vbLf & _
              "            :NUMEMP,      " & vbLf & _
              "            :AVGAGE,      " & vbLf & _
              "            :VISITDATE,   " & vbLf & _
              "            :PRESENTS,    " & vbLf & _
              "            :DIRECTMAIL,  " & vbLf & _
              "            :SENDMETHOD,  "

'## FD発送(BILLFD)項目追加 2005.05.05 張
    strStmt = strStmt & vbLf & _
              "            :POSTCARD,      " & vbLf & _
              "            :PACKAGESEND,   " & vbLf & _
              "            :TICKET,        " & vbLf & _
              "            :NOPRINTLETTER, " & vbLf & _
              "            :INSCHECK,      " & vbLf & _
              "            :INSBRING,      " & vbLf & _
              "            :INSREPORT,     " & vbLf & _
              "            :BILLADDRESS,   " & vbLf & _
              "            :BILLCSLDIV,    " & vbLf & _
              "            :BILLINS,       " & vbLf & _
              "            :BILLEMPNO,     " & vbLf & _
              "            :BILLREPORT,    " & vbLf & _
              "            :BILLFD,        " & vbLf & _
              "            :SENDCOMMENT,   " & vbLf & _
              "            :SENDECOMMENT,  " & vbLf & _
              "            :SPARE1,        " & vbLf & _
              "            :SPARE2,        " & vbLf & _
              "            :SPARE3,        " & vbLf & _
              "            :NOTES,         " & vbLf & _
              "            :DMDCOMMENT,    " & vbLf & _
              "            :UPDUSER,       "
    
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'    strStmt = strStmt & vbLf & _
'              "            :TICKETDIV,        " & vbLf & _
'              "            :TICKETADDBILL,    " & vbLf & _
'              "            :TICKETCENTERCALL, " & vbLf & _
'              "            :TICKETPERCALL,    " & vbLf & _
'              "            :CTRPTDATE         " & vbLf & _
'              "       )"

'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張
'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張
    strStmt = strStmt & vbLf & _
              "            :TICKETDIV,        " & vbLf & _
              "            :TICKETADDBILL,    " & vbLf & _
              "            :TICKETCENTERCALL, " & vbLf & _
              "            :TICKETPERCALL,    " & vbLf & _
              "            :CTRPTDATE,        " & vbLf & _
              "            :REPTCSLDIV,       " & vbLf & _
              "            :BILLSPECIAL,      " & vbLf & _
              "            :BILLAGE           " & vbLf & _
              "       )"
'## 2004.01.29 Mod End
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    InsertOrg = INSERT_NORMAL

    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        InsertOrg = INSERT_DUPLICATE
        Exit Function
    End If
        
    InsertOrg = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Organization.InsertOrg"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'
' 機能　　 : 団体コードをキーに団体住所情報テーブルを挿入する
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　 : (In)     strOrgCd2       団体コード2
' 　　　　 : (In)     strZipCd        郵便番号
' 　　　　 : (In)     strPrefCd       都道府県コード
' 　　　　 : (In)     strCityName     市区町村名
' 　　　　 : (In)     strAddress1     住所１
' 　　　　 : (In)     strAddress2     住所２
' 　　　　 : (In)     strDirectTel    電話番号１
' 　　　　 : (In)     strTel          電話番号２
' 　　　　 : (In)     strExtension    内線１
' 　　　　 : (In)     strFax          ＦＡＸ
' 　　　　 : (In)     strEMail        e-Mail
' 　　　　 : (In)     strUrl          URL
' 　　　　 : (In)     strChargeName   担当者
' 　　　　 : (In)     strChargeKName  担当者カナ名
' 　　　　 : (In)     strChargeEMail  担当者e-Mail
' 　　　　 : (In)     strChargePost   担当部署
' 　　　　 : (In)     strOrgName      漢字名称
'
' 戻り値　 : 1   正常終了
' 　　　　 : 0   同一キーのレコード存在
' 　　　　 : -1  異常終了
'
' 備考　　 :
'
Public Function InsertOrgAddr( _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    Optional ByVal vntZipCd As Variant, _
    Optional ByVal vntPrefCd As Variant, _
    Optional ByVal vntCityName As Variant, _
    Optional ByVal vntAddress1 As Variant, _
    Optional ByVal vntAddress2 As Variant, _
    Optional ByVal vntDirectTel As Variant, _
    Optional ByVal vntTel As Variant, _
    Optional ByVal vntExtension As Variant, _
    Optional ByVal vntFax As Variant, _
    Optional ByVal vntEMail As Variant, _
    Optional ByVal vntUrl As Variant, _
    Optional ByRef vntChargeName As Variant, _
    Optional ByRef vntChargeKName As Variant, _
    Optional ByRef vntChargeEMail As Variant, _
    Optional ByRef vntChargePost As Variant, _
    Optional ByRef vntOrgName As Variant _
) As Boolean

    Dim objOraParam    As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt  As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt        As String           'SQLステートメント

    Dim i                       As Long             'インデックス

    Dim objAddrDiv              As OraParameter     '住所区分
    Dim objZipCd                As OraParameter     '郵便番号
    Dim objPrefCd               As OraParameter     '都道府県コード
    Dim objCityName             As OraParameter     '市区町村名
    Dim objAddress1             As OraParameter     '住所１
    Dim objAddress2             As OraParameter     '住所２
    Dim objDirectTel            As OraParameter     '直通番号
    Dim objTel                  As OraParameter     '代表電話
    Dim objExtension            As OraParameter     '内線
    Dim objFax                  As OraParameter     'ＦＡＸ番号
    Dim objEMail                As OraParameter     'e-Mail
    Dim objUrl                  As OraParameter     'URL
    Dim objChargeName           As OraParameter     '担当者
    Dim objChargeKName          As OraParameter     '担当者カナ名
    Dim objChargeEMail          As OraParameter     '担当者e-Mail
    Dim objChargePost           As OraParameter     '担当部署
    Dim objOrgName              As OraParameter     '漢字名称

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    objOraParam.Add "ADDRDIV", "", ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "ZIPCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PREFCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CITYNAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDRESS1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDRESS2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DIRECTTEL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EXTENSION", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TEL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FAX", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMAIL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "URL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHARGENAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHARGEKNAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHARGEEMAIL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHARGEPOST", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGNAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    'パラメータの参照設定
    Set objAddrDiv = objOraParam("ADDRDIV")
    Set objZipCd = objOraParam("ZIPCD")
    Set objPrefCd = objOraParam("PREFCD")
    Set objCityName = objOraParam("CITYNAME")
    Set objAddress1 = objOraParam("ADDRESS1")
    Set objAddress2 = objOraParam("ADDRESS2")
    Set objDirectTel = objOraParam("DIRECTTEL")
    Set objTel = objOraParam("TEL")
    Set objExtension = objOraParam("EXTENSION")
    Set objFax = objOraParam("FAX")
    Set objEMail = objOraParam("EMAIL")
    Set objUrl = objOraParam("URL")
    Set objChargeName = objOraParam("CHARGENAME")
    Set objChargeKName = objOraParam("CHARGEKNAME")
    Set objChargeEMail = objOraParam("CHARGEEMAIL")
    Set objChargePost = objOraParam("CHARGEPOST")
    Set objOrgName = objOraParam("ORGNAME")

    '団体住所情報テーブルレコードの挿入
    strStmt = "INSERT INTO ORGADDR(   " & vbLf & _
              "       ORGCD1,     " & vbLf & _
              "       ORGCD2,     " & vbLf & _
              "       ADDRDIV,    " & vbLf & _
              "       ZIPCD,      " & vbLf & _
              "       PREFCD,     " & vbLf & _
              "       CITYNAME,   " & vbLf & _
              "       ADDRESS1,   " & vbLf & _
              "       ADDRESS2,   " & vbLf & _
              "       DIRECTTEL,  " & vbLf & _
              "       TEL,        " & vbLf & _
              "       EXTENSION,  " & vbLf & _
              "       FAX,        " & vbLf & _
              "       EMAIL,      " & vbLf & _
              "       URL,        " & vbLf & _
              "       CHARGENAME, " & vbLf & _
              "       CHARGEKNAME," & vbLf & _
              "       CHARGEEMAIL," & vbLf & _
              "       CHARGEPOST, " & vbLf & _
              "       ORGNAME     "

    strStmt = strStmt & vbLf & _
              "       ) VALUES (  " & vbLf & _
              "       :ORGCD1,    " & vbLf & _
              "       :ORGCD2,    " & vbLf & _
              "       :ADDRDIV,   " & vbLf & _
              "       :ZIPCD,     " & vbLf & _
              "       :PREFCD,    " & vbLf & _
              "       :CITYNAME,  " & vbLf & _
              "       :ADDRESS1,  " & vbLf & _
              "       :ADDRESS2,  " & vbLf & _
              "       :DIRECTTEL, " & vbLf & _
              "       :TEL,       " & vbLf & _
              "       :EXTENSION, " & vbLf & _
              "       :FAX,       " & vbLf & _
              "       :EMAIL,     " & vbLf & _
              "       :URL,        " & vbLf & _
              "       :CHARGENAME, " & vbLf & _
              "       :CHARGEKNAME," & vbLf & _
              "       :CHARGEEMAIL," & vbLf & _
              "       :CHARGEPOST, " & vbLf & _
              "       :ORGNAME     " & vbLf & _
              "       )"

     '各配列値の挿入処理
    For i = 0 To 2
        '配列値の編集
        objAddrDiv.Value = i + 1
        objZipCd.Value = Trim(vntZipCd(i))
        objPrefCd.Value = Trim(vntPrefCd(i))
        objCityName.Value = Trim(vntCityName(i))
        objAddress1.Value = Trim(vntAddress1(i))
        objAddress2.Value = Trim(vntAddress2(i))
        objDirectTel.Value = Trim(vntDirectTel(i))
        objTel.Value = Trim(vntTel(i))
        objExtension.Value = Trim(vntExtension(i))
        objFax.Value = Trim(vntFax(i))
        objEMail.Value = Trim(vntEMail(i))
        objUrl.Value = Trim(vntUrl(i))
        objChargeName.Value = Trim(vntChargeName(i))
        objChargeKName.Value = Trim(vntChargeKName(i))
        objChargeEMail.Value = Trim(vntChargeEMail(i))
        objChargePost.Value = Trim(vntChargePost(i))
        objOrgName.Value = Trim(vntOrgName(i))
    
        'SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
        
    Next i


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    InsertOrgAddr = True

    Exit Function
    
ErrorHandle:

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        InsertOrgAddr = INSERT_DUPLICATE
        Exit Function
    End If
        
    InsertOrgAddr = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Organization.InsertOrgAddr"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' #### 聖路加対応で未使用になった項目は削除しました。2003.11.14
'### 「利用券区分」,「利用券請求書添付」,「利用券センターより連絡」,「利用券本人より連絡」,
'    「契約日付」追加 2003.12.01  by FFC
'### 「定期訪問予定日」DATE型　→ NUMBER(2)　変更 2003.12.01  by FFC
'
' 機能　　 : 団体コードをキーに団体テーブルを更新する ### 聖路加用 ###
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　 : (In)     strOrgCd2       団体コード2
' 　　　　 : (In)     strDelFlg       使用状態
' 　　　　 : (In)     strOrgKName     カナ名称
' 　　　　 : (In)     strOrgName      漢字名称
' 　　　　 : (In)     strOrgEName     漢字名称（英語）
' 　　　　 : (In)     strOrgSName     略称
' 　　　　 : (In)     strOrgDivCd     団体種別
' 　　　　 : (In)     strOrgBILLNAME  請求書用名称
' 　　　　 : (In)     strBank         銀行名
' 　　　　 : (In)     strBranch       支店名
' 　　　　 : (In)     strAccountKind  口座種別
' 　　　　 : (In)     strAccountNo    口座番号
' 　　　　 : (In)     strNumEmp       社員数
' 　　　　 : (In)     strAvgAge       平均年齢
' 　　　　 : (In)     strDM           ＤＭ
' 　　　　 : (In)     strSendMethod   送付方法
' 　　　　 : (In)     strPostCard     確認はがき
' 　　　　 : (In)     strPackageSend  一括送付案内
' 　　　　 : (In)     strTicket       利用券
' 　　　　 : (In)     strInsCheck     保険証予約時確認
' 　　　　 : (In)     strInsBring     保険証当日持参
' 　　　　 : (In)     strInsReport    保険証成績所出力
' 　　　　 : (In)     strBillAddress   請求書適用住所
' 　　　　 : (In)     strBillCslDiv   請求書本人家族区分
' 　　　　 : (In)     strBillIns      請求書保険証情報出力
' 　　　　 : (In)     strBillEmpNo    請求書社員番号出力
' 　　　　 : (In)     strBillReport   請求書成績書添付
' 　　　　 : (In)     strSendComment  送付案内コメント
' 　　　　 : (In)     strSendEComment 英語送付案内コメント
' 　　　　 : (In)     strSpare1       予備1
' 　　　　 : (In)     strSpare2       予備2
' 　　　　 : (In)     strSpare3       予備3
' 　　　　 : (In)     strNotes        特記事項
' 　　　　 : (In)     strDmdComment   請求関連コメント
' 　　　　 : (In)     strUpdUser      更新者
' 　　　　 : (In)     strNoPrintLetter1年目はがき非出力フラグ
' 　　　　 : (In)     strVisitDate    定期訪問予定日
' 　　　　 : (In)     strPresents     年始・中元・歳暮
' 　　　　 : (In)     strTicketDiv           利用券区分
' 　　　　 : (In)     strTicketAddBill       利用券請求書添付
' 　　　　 : (In)     strTicketCenterCall    利用券センターより連絡
' 　　　　 : (In)     strTicketperCall       利用券本人より連絡
' 　　　　 : (In)     strCtrptDate           契約日付
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
' 　　　　 : (In)     strReptCslDiv  成績書本人家族区分出力
'## 2004.01.29 Add End
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'Public Function UpdateOrg(
'    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String,
'    ByVal strDelFlg As String, ByVal strOrgKName As String, ByVal strOrgName As String,
'    ByVal strOrgEName As String, ByVal strOrgSName As String, ByVal strOrgDivCd As String,
'    ByVal strOrgBillName As String,
'    ByVal strBank As String, ByVal strBranch As String,
'    ByVal strAccountKind As String, ByVal strAccountNo As String, ByVal strNumEmp As String,
'    ByVal strAvgAge As String,
'    ByVal strDM As String, ByVal strSendMethod As String, ByVal strPostCard As String,
'    ByVal strPackageSend As String, ByVal strTicket As String, ByVal strInsCheck As String,
'    ByVal strInsBring As String, ByVal strInsReport As String, ByVal strBillAddress As String,
'    ByVal strBillCslDiv As String, ByVal strBillIns As String, ByVal strBillEmpNo As String,
'    ByVal strBillReport As String, ByVal strSendComment As String, ByVal strSendEComment As String,
'    ByVal strSpare1 As String, ByVal strSpare2 As String, ByVal strSpare3 As String,
'    ByVal strNotes As String, ByVal strDmdComment As String,
'    ByVal strUpdUser As String, ByVal strNoPrintLetter As String,
'    ByVal strVisitDate As String, ByVal strPresents As String,
'    ByVal strTicketDiv As String, ByVal strTicketAddBill As String,
'    ByVal strTicketCenterCall As String, ByVal strTicketperCall As String,
'    ByVal strCtrptDate As String
') As Boolean

'## FD発送(BILLFD)項目追加 2005.05.05 張
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張
'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張
Public Function UpdateOrg( _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    ByVal strDelFlg As String, ByVal strOrgKName As String, ByVal strOrgName As String, _
    ByVal strOrgEName As String, ByVal strOrgSName As String, ByVal strOrgDivCd As String, _
    ByVal strOrgBillName As String, _
    ByVal strBank As String, ByVal strBranch As String, _
    ByVal strAccountKind As String, ByVal strAccountNo As String, ByVal strNumEmp As String, _
    ByVal strAvgAge As String, _
    ByVal strDM As String, ByVal strSendMethod As String, ByVal strPostCard As String, _
    ByVal strPackageSend As String, ByVal strTicket As String, ByVal strInsCheck As String, _
    ByVal strInsBring As String, ByVal strInsReport As String, ByVal strBillAddress As String, _
    ByVal strBillCslDiv As String, ByVal strBillIns As String, ByVal strBillEmpNo As String, _
    ByVal strBillReport As String, ByVal strBillFD As String, ByVal strSendComment As String, ByVal strSendEComment As String, _
    ByVal strSpare1 As String, ByVal strSpare2 As String, ByVal strSpare3 As String, _
    ByVal strNotes As String, ByVal strDmdComment As String, _
    ByVal strUpdUser As String, ByVal strNoPrintLetter As String, _
    ByVal strVisitDate As String, ByVal strPresents As String, _
    ByVal strTicketDiv As String, ByVal strTicketAddBill As String, _
    ByVal strTicketCenterCall As String, ByVal strTicketperCall As String, _
    ByVal strCtrptDate As String, ByVal strReptCslDiv As String, ByVal strBillSpecial As String, ByVal strBillAge As String _
) As Boolean
'## 2004.01.29 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DELFLG", Trim(strDelFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "ORGKNAME", StrConv(Trim(strOrgKName), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod By T.Takagi@FSIT 変換方法を変更
'    objOraParam.Add "ORGNAME", StrConv(Trim(strOrgName), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGNAME", Trim(strOrgName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
    objOraParam.Add "ORGENAME", Trim(strOrgEName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod By T.Takagi@FSIT 変換方法を変更
'    objOraParam.Add "ORGSNAME", StrConv(Trim(strOrgSName), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGSNAME", Trim(strOrgSName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
    
    objOraParam.Add "ORGDIVCD", Trim(strOrgDivCd), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.12.17 Mod By T.Takagi@FSIT 変換方法を変更
'    objOraParam.Add "ORGBILLNAME", StrConv(Trim(strOrgBillName), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGBILLNAME", Trim(strOrgBillName), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
    
    objOraParam.Add "BANK", StrConv(Trim(strBank), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BRANCH", StrConv(Trim(strBranch), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ACCOUNTKIND", Trim(strAccountKind), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ACCOUNTNO", Trim(strAccountNo), ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "NUMEMP", Trim(strNumEmp), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AVGAGE", Trim(strAvgAge), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DIRECTMAIL", Trim(strDM), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SENDMETHOD", Trim(strSendMethod), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POSTCARD", Trim(strPostCard), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PACKAGESEND", Trim(strPackageSend), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TICKET", Trim(strTicket), ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "INSCHECK", Trim(strInsCheck), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "INSBRING", Trim(strInsBring), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "INSREPORT", Trim(strInsReport), ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "BILLADDRESS", Trim(strBillAddress), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLCSLDIV", Trim(strBillCslDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLINS", Trim(strBillIns), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLEMPNO", Trim(strBillEmpNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLREPORT", Trim(strBillReport), ORAPARM_INPUT, ORATYPE_NUMBER
'## FD発送(BILLFD)項目追加 2005.05.05 張
    objOraParam.Add "BILLFD", Trim(strBillFD), ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "SENDCOMMENT", StrConv(Trim(strSendComment), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SENDECOMMENT", Trim(strSendEComment), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    objOraParam.Add "SPARE1", Trim(strSpare1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SPARE2", Trim(strSpare2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SPARE3", Trim(strSpare3), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NOTES", StrConv(Trim(strNotes), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DMDCOMMENT", StrConv(Trim(strDmdComment), vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2

    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2

    objOraParam.Add "NOPRINTLETTER", Trim(strNoPrintLetter), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.12.01 Mod 2Line By K.Fujii@FFC
'    objOraParam.Add "VISITDATE", Trim(strVisitDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "VISITDATE", Trim(strVisitDate), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.12.01 Mod End
    objOraParam.Add "PRESENTS", Trim(strPresents), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.12.01 Add 9Line By K.Fujii@FFC
    objOraParam.Add "TICKETDIV", Trim(strTicketDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TICKETADDBILL", Trim(strTicketAddBill), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TICKETCENTERCALL", Trim(strTicketCenterCall), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TICKETPERCALL", Trim(strTicketperCall), ORAPARM_INPUT, ORATYPE_NUMBER
    If strCtrptDate <> "" Then
        objOraParam.Add "CTRPTDATE", Trim(strCtrptDate), ORAPARM_INPUT, ORATYPE_DATE
    Else
        objOraParam.Add "CTRPTDATE", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
'## 2003.12.01 Add End

'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
    objOraParam.Add "REPTCSLDIV", Trim(strReptCslDiv), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2004.01.29 Add End
    
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張
    objOraParam.Add "BILLSPECIAL", Trim(strBillSpecial), ORAPARM_INPUT, ORATYPE_NUMBER
    
'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張
    objOraParam.Add "BILLAGE", Trim(strBillAge), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '団体テーブルレコードの更新
    strStmt = "UPDATE ORG                          " & vbLf & _
              "   SET DELFLG       = :DELFLG,      " & vbLf & _
              "       ORGKNAME     = :ORGKNAME,    " & vbLf & _
              "       ORGNAME      = :ORGNAME,     " & vbLf & _
              "       ORGENAME     = :ORGENAME,    " & vbLf & _
              "       ORGSNAME     = :ORGSNAME,    " & vbLf & _
              "       ORGDIVCD     = :ORGDIVCD,    " & vbLf & _
              "       ORGBILLNAME  = :ORGBILLNAME, " & vbLf & _
              "       BANK         = :BANK,        " & vbLf & _
              "       BRANCH       = :BRANCH,      " & vbLf & _
              "       ACCOUNTKIND  = :ACCOUNTKIND, " & vbLf & _
              "       ACCOUNTNO    = :ACCOUNTNO,   " & vbLf & _
              "       NUMEMP       = :NUMEMP,      " & vbLf & _
              "       AVGAGE       = :AVGAGE,      " & vbLf & _
              "       VISITDATE    = :VISITDATE,   " & vbLf & _
              "       PRESENTS     = :PRESENTS,    " & vbLf & _
              "       DIRECTMAIL   = :DIRECTMAIL,  " & vbLf & _
              "       SENDMETHOD   = :SENDMETHOD,  " & vbLf & _
              "       POSTCARD     = :POSTCARD,    " & vbLf & _
              "       PACKAGESEND  = :PACKAGESEND, " & vbLf & _
              "       TICKET       = :TICKET,      " & vbLf & _
              "       NOPRINTLETTER= :NOPRINTLETTER, "
    
'## FD発送(BILLFD)項目追加 2005.05.05 張
    strStmt = strStmt & vbLf & _
              "       INSCHECK     = :INSCHECK,    " & vbLf & _
              "       INSBRING     = :INSBRING,    " & vbLf & _
              "       INSREPORT    = :INSREPORT,   " & vbLf & _
              "       BILLADDRESS  = :BILLADDRESS, " & vbLf & _
              "       BILLCSLDIV   = :BILLCSLDIV,  " & vbLf & _
              "       BILLINS      = :BILLINS,     " & vbLf & _
              "       BILLEMPNO    = :BILLEMPNO,   " & vbLf & _
              "       BILLREPORT   = :BILLREPORT,  " & vbLf & _
              "       BILLFD       = :BILLFD,      " & vbLf & _
              "       SENDCOMMENT  = :SENDCOMMENT, " & vbLf & _
              "       SENDECOMMENT = :SENDECOMMENT," & vbLf & _
              "       SPARE1       = :SPARE1,      " & vbLf & _
              "       SPARE2       = :SPARE2,      " & vbLf & _
              "       SPARE3       = :SPARE3,      " & vbLf & _
              "       NOTES        = :NOTES,       " & vbLf & _
              "       DMDCOMMENT   = :DMDCOMMENT,  " & vbLf & _
              "       UPDDATE      = SYSDATE,      " & vbLf & _
              "       UPDUSER      = :UPDUSER,     "
    
    strStmt = strStmt & vbLf & _
              "       TICKETDIV        = :TICKETDIV,        " & vbLf & _
              "       TICKETADDBILL    = :TICKETADDBILL,    " & vbLf & _
              "       TICKETCENTERCALL = :TICKETCENTERCALL, " & vbLf & _
              "       TICKETPERCALL    = :TICKETPERCALL,    " & vbLf & _
              "       CTRPTDATE        = :CTRPTDATE         "
    
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       REPTCSLDIV       = :REPTCSLDIV "
'## 2004.01.29 Add End
    
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張 Start
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       BILLSPECIAL      = :BILLSPECIAL "
'## 請求書特定健診レポート(BILLSPECIAL)項目追加 2008.03.19 張 End
    
'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張 Start
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       BILLAGE          = :BILLAGE "
'## 請求書年齢出力(BILLAGE)項目追加 2009.05.20 張 End
    
    strStmt = strStmt & vbLf & _
              " WHERE ORGCD1      = :ORGCD1 " & vbLf & _
              "   AND ORGCD2      = :ORGCD2 "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    UpdateOrg = True

    Exit Function
    
ErrorHandle:

    UpdateOrg = False

    'イベントログ書き込み
    WriteErrorLog "Organization.UpdateOrg"
    
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
' 機能　　 : 団体コードをキーに団体住所情報テーブルを更新する
'
' 引数　　 : (In)     strOrgCd1       団体コード1
' 　　　　 : (In)     strOrgCd2       団体コード2
' 　　　　 : (In)     strZipCd        郵便番号
' 　　　　 : (In)     strPrefCd       都道府県コード
' 　　　　 : (In)     strCityName     市区町村名
' 　　　　 : (In)     strAddress1     住所１
' 　　　　 : (In)     strAddress2     住所２
' 　　　　 : (In)     strDirectTel    電話番号１
' 　　　　 : (In)     strTel          電話番号２
' 　　　　 : (In)     strExtension    内線１
' 　　　　 : (In)     strFax          ＦＡＸ
' 　　　　 : (In)     strEMail        e-Mail
' 　　　　 : (In)     strUrl          URL
' 　　　　 : (In)     strChargeName   担当者
' 　　　　 : (In)     strChargeKName  担当者カナ名
' 　　　　 : (In)     strChargeEMail  担当者e-Mail
' 　　　　 : (In)     strChargePost   担当部署
' 　　　　 : (In)     strOrgName      漢字名称
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateOrgAddr( _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
    Optional ByRef vntZipCd As Variant, _
    Optional ByRef vntPrefCd As Variant, _
    Optional ByRef vntCityName As Variant, _
    Optional ByRef vntAddress1 As Variant, _
    Optional ByRef vntAddress2 As Variant, _
    Optional ByRef vntDirectTel As Variant, _
    Optional ByRef vntTel As Variant, _
    Optional ByRef vntExtension As Variant, _
    Optional ByRef vntFax As Variant, _
    Optional ByRef vntEMail As Variant, _
    Optional ByRef vntUrl As Variant, _
    Optional ByRef vntChargeName As Variant, _
    Optional ByRef vntChargeKName As Variant, _
    Optional ByRef vntChargeEMail As Variant, _
    Optional ByRef vntChargePost As Variant, _
    Optional ByRef vntOrgName As Variant _
) As Boolean

    Dim objOraParam    As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt  As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt        As String           'SQLステートメント

    Dim i                       As Long             'インデックス

    Dim objAddrDiv              As OraParameter     '住所区分
    Dim objZipCd                As OraParameter     '郵便番号
    Dim objPrefCd               As OraParameter     '都道府県コード
    Dim objCityName             As OraParameter     '市区町村名
    Dim objAddress1             As OraParameter     '住所１
    Dim objAddress2             As OraParameter     '住所２
    Dim objDirectTel            As OraParameter     '直通番号
    Dim objTel                  As OraParameter     '代表電話
    Dim objExtension            As OraParameter     '内線
    Dim objFax                  As OraParameter     'ＦＡＸ番号
    Dim objEMail                As OraParameter     'e-Mail
    Dim objUrl                  As OraParameter     'URL
    Dim objChargeName           As OraParameter     '担当者
    Dim objChargeKName          As OraParameter     '担当者カナ名
    Dim objChargeEMail          As OraParameter     '担当者e-Mail
    Dim objChargePost           As OraParameter     '担当部署
    Dim objOrgName              As OraParameter     '漢字名称

    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす団体住所情報テーブルのレコードを先に削除
    strStmt = "DELETE FROM ORGADDR         " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1     " & vbLf & _
              "   AND ORGCD2 = :ORGCD2     "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ADDRDIV", "", ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ZIPCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PREFCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CITYNAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDRESS1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDRESS2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DIRECTTEL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EXTENSION", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TEL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FAX", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMAIL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "URL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHARGENAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHARGEKNAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHARGEEMAIL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CHARGEPOST", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGNAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    'パラメータの参照設定
    Set objAddrDiv = objOraParam("ADDRDIV")
    Set objZipCd = objOraParam("ZIPCD")
    Set objPrefCd = objOraParam("PREFCD")
    Set objCityName = objOraParam("CITYNAME")
    Set objAddress1 = objOraParam("ADDRESS1")
    Set objAddress2 = objOraParam("ADDRESS2")
    Set objDirectTel = objOraParam("DIRECTTEL")
    Set objTel = objOraParam("TEL")
    Set objExtension = objOraParam("EXTENSION")
    Set objFax = objOraParam("FAX")
    Set objEMail = objOraParam("EMAIL")
    Set objUrl = objOraParam("URL")
    Set objChargeName = objOraParam("CHARGENAME")
    Set objChargeKName = objOraParam("CHARGEKNAME")
    Set objChargeEMail = objOraParam("CHARGEEMAIL")
    Set objChargePost = objOraParam("CHARGEPOST")
    Set objOrgName = objOraParam("ORGNAME")


    '団体住所情報テーブルレコードの更新
     '各配列値の挿入処理

    strStmt = "INSERT INTO ORGADDR(   " & vbLf & _
              "       ORGCD1,     " & vbLf & _
              "       ORGCD2,     " & vbLf & _
              "       ADDRDIV,    " & vbLf & _
              "       ZIPCD,      " & vbLf & _
              "       PREFCD,     " & vbLf & _
              "       CITYNAME,   " & vbLf & _
              "       ADDRESS1,   " & vbLf & _
              "       ADDRESS2,   " & vbLf & _
              "       DIRECTTEL,  " & vbLf & _
              "       TEL,        " & vbLf & _
              "       EXTENSION,  " & vbLf & _
              "       FAX,        " & vbLf & _
              "       EMAIL,      " & vbLf & _
              "       URL,        " & vbLf & _
              "       CHARGENAME, " & vbLf & _
              "       CHARGEKNAME," & vbLf & _
              "       CHARGEEMAIL," & vbLf & _
              "       CHARGEPOST, " & vbLf & _
              "       ORGNAME     "

    strStmt = strStmt & vbLf & _
              "       ) VALUES (   " & vbLf & _
              "       :ORGCD1,     " & vbLf & _
              "       :ORGCD2,     " & vbLf & _
              "       :ADDRDIV,    " & vbLf & _
              "       :ZIPCD,      " & vbLf & _
              "       :PREFCD,     " & vbLf & _
              "       :CITYNAME,   " & vbLf & _
              "       :ADDRESS1,   " & vbLf & _
              "       :ADDRESS2,   " & vbLf & _
              "       :DIRECTTEL,  " & vbLf & _
              "       :TEL,        " & vbLf & _
              "       :EXTENSION,  " & vbLf & _
              "       :FAX,        " & vbLf & _
              "       :EMAIL,      " & vbLf & _
              "       :URL,        " & vbLf & _
              "       :CHARGENAME, " & vbLf & _
              "       :CHARGEKNAME," & vbLf & _
              "       :CHARGEEMAIL," & vbLf & _
              "       :CHARGEPOST, " & vbLf & _
              "       :ORGNAME     " & vbLf & _
              "       )"
 
    For i = 0 To 2
        '配列値の編集
        objAddrDiv.Value = i + 1
        objZipCd.Value = Trim(vntZipCd(i))
        objPrefCd.Value = Trim(vntPrefCd(i))
        objCityName.Value = Trim(vntCityName(i))
        objAddress1.Value = Trim(vntAddress1(i))
        objAddress2.Value = Trim(vntAddress2(i))
        objDirectTel.Value = Trim(vntDirectTel(i))
        objTel.Value = Trim(vntTel(i))
        objExtension.Value = Trim(vntExtension(i))
        objFax.Value = Trim(vntFax(i))
        objEMail.Value = Trim(vntEMail(i))
        objUrl.Value = Trim(vntUrl(i))
        objChargeName.Value = Trim(vntChargeName(i))
        objChargeKName.Value = Trim(vntChargeKName(i))
        objChargeEMail.Value = Trim(vntChargeEMail(i))
        objChargePost.Value = Trim(vntChargePost(i))
        objOrgName.Value = Trim(vntOrgName(i))
    
        'SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
        
    Next i


    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    UpdateOrgAddr = True

    Exit Function
    
ErrorHandle:

    UpdateOrgAddr = False

    'イベントログ書き込み
    WriteErrorLog "Organization.UpdateOrgAddr"
    
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
' 機能　　 : 指定団体に対し、成績書オプション管理状況を取得
'
' 引数　　 : (In)     strOrgCd1       団体コード１
' 　　　　   (In)     strOrgCd2       団体コード２
' 　　　　   (Out)    vntRptOptCd     オプション管理コード
' 　　　　   (Out)    vntRptOptName   オプション管理名称
' 　　　　   (Out)    vntValues       選択状態("1":選択、"0":未選択)
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectRptOpt( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strFreeCd As String, _
    ByRef vntRptOptCd As Variant, _
    ByRef vntRptOptName As Variant, _
    ByRef vntValues As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRptOptCd         As OraField         'オプション管理コード
    Dim objRptOptName       As OraField         'オプション管理名
    Dim objValues           As OraField         '選択状態
    
    Dim vntArrRptOptCd()    As Variant          'オプション管理コードの配列
    Dim vntArrRptOptName()  As Variant          'オプション管理名称の配列
    Dim vntArrValues()      As Variant          '選択状態の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRptOptCd = Empty
    vntRptOptName = Empty
    vntValues = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FREECD", strFreeCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FREECLASSCD", "REP", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たすレコードを取得
    strStmt = "SELECT FREEOPT.RPTOPTCD             AS RPTOPTCD      " & vbLf & _
              "      ,FREEOPT.RPTOPTNAME           AS RPTOPTNAME    " & vbLf & _
              "      ,NVL2(RPTOPT.RPTOPTCD, '1', '0')  AS VALUE_S       "

    '団体別成績書オプション管理テーブルからオプション管理情報取得
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT RPTOPTCD             " & vbLf & _
              "           FROM ORGRPTOPT            " & vbLf & _
              "          WHERE ORGCD1   = :ORGCD1   " & vbLf & _
              "            AND ORGCD2   = :ORGCD2   " & vbLf & _
              "       ) RPTOPT,                     "
              
    '汎用テーブルからオプション管理コードを取得
    strStmt = strStmt & vbLf & _
              "       ( SELECT FREECD     AS RPTOPTCD           " & vbLf & _
              "               ,FREEFIELD1 AS RPTOPTNAME         " & vbLf & _
              "           FROM FREE                             " & vbLf & _
              "          WHERE FREECD          LIKE :FREECD     " & vbLf & _
              "            AND FREECLASSCD     = :FREECLASSCD   " & vbLf & _
              "       ) FREEOPT                                 "
    
    'オプション管理情報と結合し、受診状態を判別
    strStmt = strStmt & vbLf & _
              " WHERE FREEOPT.RPTOPTCD = RPTOPT.RPTOPTCD(+) "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRptOptCd = objFields("RPTOPTCD")
        Set objRptOptName = objFields("RPTOPTNAME")
        Set objValues = objFields("VALUE_S")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRptOptCd(lngCount)
            ReDim Preserve vntArrRptOptName(lngCount)
            ReDim Preserve vntArrValues(lngCount)
            
            vntArrRptOptCd(lngCount) = objRptOptCd.Value & ""
            vntArrRptOptName(lngCount) = objRptOptName.Value & ""
            vntArrValues(lngCount) = objValues.Value & ""
            lngCount = lngCount + 1
            
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntRptOptCd = vntArrRptOptCd
        vntRptOptName = vntArrRptOptName
        vntValues = vntArrValues
        
    End If
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SelectRptOpt = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectRptOpt = -1

    'イベントログ書き込み
    WriteErrorLog "Organization.SelectRptOpt"
    
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
' 機能　　 : 指定団体に対し、成績書オプション管理状況更新
'
' 引数　　 : (In)     strOrgCd1       団体コード１
' 　　　　   (In)     strOrgCd2       団体コード２
' 　　　　   (In)     vntRptOptCd     オプション管理コード
' 　　　　   (In)     vntValues       選択状態("1":選択、"0":未選択)
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function UpdateRptOpt(ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal strUpdUser As String, ByVal vntRptOptCd As Variant, ByVal vntValues As Variant) As Boolean
    
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objRptOptCd     As OraParameter     '成績書オプション管理コード
    Dim strStmt         As String           'SQLステートメント
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RPTOPTCD", " ", ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'パラメータの参照設定
'    Set objRptOptCd = objOraParam("RPTOPTCD")
    
    '指定期間、時間枠の予約枠レコードを削除
    mobjOraDb.ExecuteSQL "DELETE ORGRPTOPT WHERE ORGCD1=:ORGCD1 AND ORGCD2=:ORGCD2"
    
    '該当日・該当時間枠・該当予約枠の予約スケジューリングを挿入するSQLステートメント編集
    strStmt = "INSERT INTO ORGRPTOPT (      " & vbLf & _
              "                ORGCD1,      " & vbLf & _
              "                ORGCD2,      " & vbLf & _
              "                RPTOPTCD,    " & vbLf & _
              "                DELFLG,      " & vbLf & _
              "                JUDCLASSCD,  " & vbLf & _
              "                UPDUSER      " & vbLf & _
              "            ) VALUES (       " & vbLf & _
              "                :ORGCD1,     " & vbLf & _
              "                :ORGCD2,     " & vbLf & _
              "                :RPTOPTCD,   "

    strStmt = strStmt & vbLf & _
              "                ( SELECT FREEFIELD2             " & vbLf & _
              "                    FROM FREE                   " & vbLf & _
              "                   WHERE FREECD    = :RPTOPTCD  " & vbLf & _
              "                     AND FREECLASSCD = 'REP'    " & vbLf & _
              "                ),                              " & vbLf & _
              "                ( SELECT FREEFIELD3             " & vbLf & _
              "                    FROM FREE                   " & vbLf & _
              "                   WHERE FREECD    = :RPTOPTCD  " & vbLf & _
              "                     AND FREECLASSCD = 'REP'    " & vbLf & _
              "                ),                              " & vbLf & _
              "                :UPDUSER                        "
          
    strStmt = strStmt & vbLf & _
              "            ) "
    
    For i = 0 To UBound(vntRptOptCd)
'
        If vntValues(i) = "1" Then

            'objRptOptCd.Value = vntRptOptCd(i)
            objOraParam("RPTOPTCD").Value = vntRptOptCd(i)

            '挿入SQL文の実行
            If objOraSQLStmt Is Nothing Then
                Set objOraSQLStmt = mobjOraDb.CreateSql(strStmt, ORASQL_FAILEXEC)
            Else
                objOraSQLStmt.Refresh
            End If

        End If

    Next i
    
    
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateRptOpt = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    UpdateRptOpt = False
    
    'イベントログ書き込み
    WriteErrorLog "Organization.UpdateRptOpt"
    
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
' 機能　　 : 団体テーブルを全件読み込みCSVファイルを編集する
'
' 引数　　 : (In)   strFileName         CSVファイル名(物理パス)
'
' 戻り値　 : 編集したレコード件数
'
' 備考　　 : 都道府県名、保険区分、口座種別は漢字名称に変換する
'
Public Function EditCSVDatOrg(ByVal strFileName As String) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
'## 2003.03.09 Add 2Lines By T.Takagi@FSIT 東急対応
    Dim objCreateCsv        As Object           'CSVファイル作成用コンポーネント
    Dim Ret                 As String           '戻り値
'## 2003.03.09 Add End
    
'## 2003.03.09 Del ??Lines By T.Takagi@FSIT 東急対応
'    Dim objFields           As OraFields        'フィールドオブジェクト
'    Dim objOrgCd1           As OraField         '団体コード1
'    Dim objOrgCd2           As OraField         '団体コード2
'    Dim objOrgKName         As OraField         'カナ名称
'    Dim objOrgName          As OraField         '漢字名称
'    Dim objOrgSName         As OraField         '略称
'    Dim objZipCd1           As OraField         '郵便番号1
'    Dim objZipCd2           As OraField         '郵便番号2
'    Dim objPrefName         As OraField         '都道府県名
'    Dim objCityName         As OraField         '市区町村名
'    Dim objAddress1         As OraField         '住所1
'    Dim objAddress2         As OraField         '住所2
'    Dim objTel1             As OraField         '電話番号代表－市外局番
'    Dim objTel2             As OraField         '電話番号代表－局番
'    Dim objTel3             As OraField         '電話番号代表－番号
'    Dim objDirectTel1       As OraField         '電話番号直通－市外局番
'    Dim objDirectTel2       As OraField         '電話番号直通－局番
'    Dim objDirectTel3       As OraField         '電話番号直通－番号
'    Dim objExtension        As OraField         '内線
'    Dim objFax1             As OraField         'ＦＡＸ－市外局番
'    Dim objFax2             As OraField         'ＦＡＸ－局番
'    Dim objFax3             As OraField         'ＦＡＸ－番号
'    Dim objChargeName       As OraField         '担当者氏名
'    Dim objChargeKName      As OraField         '担当者カナ名
'    Dim objChargeEmail      As OraField         '担当者E-Mailアドレス
'    Dim objChargePost       As OraField         '担当者部署名
'    Dim objGovMngCd         As OraField         '政府管掌コード
'    Dim objIsrNo            As OraField         '保険者番号
'    Dim objIsrSign          As OraField         '健保記号(記号)
'    Dim objIsrMark          As OraField         '健保記号(符号)
'    Dim objHeIsrNo          As OraField         '健保番号
'    Dim objIsrDiv           As OraField         '保険区分
'    Dim objBank             As OraField         '銀行名
'    Dim objBranch           As OraField         '支店名
'    Dim objAccountKindName  As OraField         '口座種別(名称)
'    Dim objAccountNo        As OraField         '口座番号
'    Dim objNotes            As OraField         '特記事項
'    Dim objSpare1           As OraField         '予備1
'    Dim objSpare2           As OraField         '予備2
'    Dim objSpare3           As OraField         '予備3
'    Dim objUpdDate          As OraField         '更新日時
'    Dim objUpdUser          As OraField         '更新者
'
'    Dim objCommon           As Common           '共通クラス
'
'    Dim vntArrIsrDiv        As Variant          '保険区分リスト
'    Dim vntArrIsrDivName    As Variant          '保険区分名称リスト
'    Dim lngIsrCount         As Long             '保険区分リスト数
'    Dim strIsrDivName       As String           '保険区分名称
'
'    Dim strLine             As String           '出力文字列(1行)
'    Dim lngFileNumber       As Long             'ファイル番号
'    Dim lngCount            As Long             'レコード数
'    Dim i                   As Long             'インデックス
'## 2003.03.09 Del End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
'## 2003.03.09 Mod ??Lines By T.Takagi@FSIT 東急対応
'    '初期処理
'    lngCount = 0
'
'    '共通クラスのインスタンス作成
'    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
'
'    '保険区分テーブルを取得
'    lngIsrCount = objCommon.SelectIsrDivList(vntArrIsrDiv, vntArrIsrDivName)
'
'    'キー値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "DELFLG", DELFLG_USED, ORAPARM_INPUT, ORATYPE_NUMBER
'
'    '検索条件を満たす団体テーブルのレコードを取得
'    strStmt = "SELECT ORG.ORGCD1,      ORG.ORGCD2,                                   " & vbLf & _
'              "       ORG.ORGKNAME,    ORG.ORGNAME,     ORG.ORGSNAME,                " & vbLf & _
'              "       ORG.ZIPCD1,      ORG.ZIPCD2,                                   " & vbLf & _
'              "       PREF.PREFNAME,   ORG.CITYNAME,                                 " & vbLf & _
'              "       ORG.ADDRESS1,    ORG.ADDRESS2,                                 " & vbLf & _
'              "       ORG.TEL1,        ORG.TEL2,        ORG.TEL3,                    " & vbLf & _
'              "       ORG.DIRECTTEL1,  ORG.DIRECTTEL2,  ORG.DIRECTTEL3,              " & vbLf & _
'              "       ORG.EXTENSION,                                                 " & vbLf & _
'              "       ORG.FAX1,        ORG.FAX2,        ORG.FAX3,                    " & vbLf & _
'              "       ORG.CHARGENAME,  ORG.CHARGEKNAME,                              " & vbLf & _
'              "       ORG.CHARGEEMAIL, ORG.CHARGEPOST,  ORG.GOVMNGCD,                " & vbLf & _
'              "       ORG.ISRNO,       ORG.ISRSIGN,     ORG.ISRMARK,                 " & vbLf & _
'              "       ORG.HEISRNO,     ORG.ISRDIV,                                   " & vbLf & _
'              "       ORG.BANK,        ORG.BRANCH,                                   " & vbLf & _
'              "       DECODE(ACCOUNTKIND,'1','普通','2','当座',NULL) ACCOUNTKINDNAME, " & vbLf & _
'              "       ORG.ACCOUNTNO,   ORG.NOTES,                                    " & vbLf & _
'              "       ORG.SPARE1,      ORG.SPARE2,      ORG.SPARE3,                  " & vbLf & _
'              "       ORG.UPDDATE,     ORG.UPDUSER                                   " & vbLf & _
'              "  FROM PREF, ORG                                                      " & vbLf & _
'              " WHERE ORG.PREFCD = PREF.PREFCD(+)                                    " & vbLf & _
'              "   AND DELFLG = :DELFLG                                               " & vbLf & _
'              " ORDER BY ORGCD1, ORGCD2                                              "
    strStmt = "SELECT ORGCD1      団体コード１, " & vbLf & _
              "       ORGCD2      団体コード２, " & vbLf & _
              "       DELFLG      削除フラグ,   " & vbLf & _
              "       UPDDATE     更新日,       " & vbLf & _
              "       UPDUSER     更新者,       " & vbLf & _
              "       ORGKNAME    カナ名称,     " & vbLf & _
              "       ORGNAME     漢字名称,     " & vbLf & _
              "       ORGBILLNAME 請求書用名称, " & vbLf & _
              "       ORGSNAME    略称,         " & vbLf & _
              "       ORGDIV      団体種別,     "
    
    strStmt = strStmt & vbLf & _
              "       ZIPCD1      郵便番号１,       " & vbLf & _
              "       ZIPCD2      郵便番号２,       " & vbLf & _
              "       PREFCD      都道府県コード,   " & vbLf & _
              "       CITYNAME    市区町村名,       " & vbLf & _
              "       ADDRESS1    住所１,           " & vbLf & _
              "       ADDRESS2    住所２,           " & vbLf & _
              "       TEL1        電話番号市外局番, " & vbLf & _
              "       TEL2        電話番号局番,     " & vbLf & _
              "       TEL3        電話番号番号,     " & vbLf & _
              "       DIRECTTEL1  直通電話市外局番, " & vbLf & _
              "       DIRECTTEL2  直通電話局番,     " & vbLf & _
              "       DIRECTTEL3  直通電話番号,     " & vbLf & _
              "       EXTENSION   内線,             " & vbLf & _
              "       FAX1        ＦＡＸ市外局番,   " & vbLf & _
              "       FAX2        ＦＡＸ局番,       " & vbLf & _
              "       FAX3        ＦＡＸ番号,       "
    
'### 2003/11/15 Updated by Ishihara@FSIT 担当者はテーブルが移動
'    strStmt = strStmt & vbLf & _
              "       CHARGENAME  担当者,           " & vbLf & _
              "       CHARGEKNAME 担当者カナ名,     " & vbLf & _
              "       CHARGEEMAIL 担当者EMAIL,      " & vbLf & _
              "       CHARGEPOST  担当部署,         " & vbLf & _
              "       GOVMNGCD    政府管掌コード,   " & vbLf & _
              "       ISRSIGN     健保記号,         " & vbLf & _
              "       ISRGETNAME  健保名称索引対象, " & vbLf & _
              "       ISRDIV      保険区分,         " & vbLf & _
              "       BANK        銀行名,           " & vbLf & _
              "       BRANCH      支店名,           " & vbLf & _
              "       ACCOUNTKIND 口座種別,         " & vbLf & _
              "       ACCOUNTNO   口座番号,         "
    strStmt = strStmt & vbLf & _
              "       GOVMNGCD    政府管掌コード,   " & vbLf & _
              "       ISRSIGN     健保記号,         " & vbLf & _
              "       ISRGETNAME  健保名称索引対象, " & vbLf & _
              "       ISRDIV      保険区分,         " & vbLf & _
              "       BANK        銀行名,           " & vbLf & _
              "       BRANCH      支店名,           " & vbLf & _
              "       ACCOUNTKIND 口座種別,         " & vbLf & _
              "       ACCOUNTNO   口座番号,         "
    
    strStmt = strStmt & vbLf & _
              "       REPLACE(REPLACE(REPLACE(NOTES, ',', '，'), CHR(13)||CHR(10), ''), CHR(13), '') 特記事項, "
    
    strStmt = strStmt & vbLf & _
              "       SPARE1        予備１,                    " & vbLf & _
              "       SPARE2        予備２,                    " & vbLf & _
              "       SPARE3        予備３,                    " & vbLf & _
              "       ROUNDNOTAXFLG まるめ金消費税非計算フラグ " & vbLf & _
              "  FROM ORG                                      " & vbLf & _
              " ORDER BY ORGCD1, ORGCD2                        "
'## 2003.03.09 Mod End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
'## 2003.03.09 Mod ??Lines By T.Takagi@FSIT 東急対応
'    'レコードが存在する場合
'    If Not objOraDyna.EOF Then
'
'        'オブジェクトの参照設定
'        Set objFields = objOraDyna.Fields
'        Set objOrgCd1 = objFields("ORGCD1")
'        Set objOrgCd2 = objFields("ORGCD2")
'        Set objOrgKName = objFields("ORGKNAME")
'        Set objOrgName = objFields("ORGNAME")
'        Set objOrgSName = objFields("ORGSNAME")
'        Set objZipCd1 = objFields("ZIPCD1")
'        Set objZipCd2 = objFields("ZIPCD2")
'        Set objPrefName = objFields("PREFNAME")
'        Set objCityName = objFields("CITYNAME")
'        Set objAddress1 = objFields("ADDRESS1")
'        Set objAddress2 = objFields("ADDRESS2")
'        Set objTel1 = objFields("TEL1")
'        Set objTel2 = objFields("TEL2")
'        Set objTel3 = objFields("TEL3")
'        Set objDirectTel1 = objFields("DIRECTTEL1")
'        Set objDirectTel2 = objFields("DIRECTTEL2")
'        Set objDirectTel3 = objFields("DIRECTTEL3")
'        Set objExtension = objFields("EXTENSION")
'        Set objFax1 = objFields("FAX1")
'        Set objFax2 = objFields("FAX2")
'        Set objFax3 = objFields("FAX3")
'        Set objChargeName = objFields("CHARGENAME")
'        Set objChargeKName = objFields("CHARGEKNAME")
'        Set objChargeEmail = objFields("CHARGEEMAIL")
'        Set objChargePost = objFields("CHARGEPOST")
'        Set objGovMngCd = objFields("GOVMNGCD")
'        Set objIsrNo = objFields("ISRNO")
'        Set objIsrSign = objFields("ISRSIGN")
'        Set objIsrMark = objFields("ISRMARK")
'        Set objHeIsrNo = objFields("HEISRNO")
'        Set objIsrDiv = objFields("ISRDIV")
'        Set objBank = objFields("BANK")
'        Set objBranch = objFields("BRANCH")
'        Set objAccountKindName = objFields("ACCOUNTKINDNAME")
'        Set objAccountNo = objFields("ACCOUNTNO")
'        Set objNotes = objFields("NOTES")
'        Set objSpare1 = objFields("SPARE1")
'        Set objSpare2 = objFields("SPARE2")
'        Set objSpare3 = objFields("SPARE3")
'        Set objUpdDate = objFields("UPDDATE")
'        Set objUpdUser = objFields("UPDUSER")
'
'        'ファイルオープン
'        lngFileNumber = FreeFile
'        Open strFileName For Output As #lngFileNumber
'
'        'ヘッダー行出力
'        strLine = "団体コード1,団体コード2,カナ名称,漢字名称,略称,郵便番号1,郵便番号2," & _
'                  "都道府県名,市区町村名,住所1,住所2,電話番号－市外局番,電話番号－局番," & _
'                  "電話番号－番号,直通電話－市外局番,直通電話－局番,直通電話－番号,内線," & _
'                  "ＦＡＸ－市外局番,ＦＡＸ－局番,ＦＡＸ－番号,担当者,担当者カナ名,担当者E-Mail," & _
'                  "担当部署,政府管掌コード,保険者番号,健保記号(記号),健保記号(符号),健保番号," & _
'                  "保険区分,銀行名,支店名,口座種別,口座番号,特記事項,予備1,予備2,予備3,更新日,更新者"
'        Print #lngFileNumber, strLine
'
'        Do Until objOraDyna.EOF
'            '保険区分名称のサーチ
'            strIsrDivName = ""
'            If lngIsrCount > 0 Then
'                i = 0
'                Do While i < lngIsrCount
'                    If (objIsrDiv.Value & "") = vntArrIsrDiv(i) Then
'                        strIsrDivName = vntArrIsrDivName(i)
'                        Exit Do
'                    End If
'                    i = i + 1
'                Loop
'            End If
'            'データ行出力
''            strLine = ""
''            strLine = strLine & _
''                      objOrgCd1.Value & "," & _
''                      objOrgCd2.Value & "," & _
''                      objOrgKName.Value & "," & _
''                      objOrgName.Value & "," & _
''                      objOrgSName.Value & "," & _
''                      objZipCd1.Value & "," & _
''                      objZipCd2.Value & "," & _
''                      objPrefName.Value & "," & _
''                      objCityName.Value & "," & _
''                      objAddress1.Value & "," & _
''                      objAddress2.Value & "," & _
''                      objTel1.Value & "," & _
''                      objTel2.Value & "," & _
''                      objTel3.Value & "," & _
''                      objDirectTel1.Value & "," & _
''                      objDirectTel2.Value & "," & _
''                      objDirectTel3.Value & "," & _
''                      objExtension.Value & "," & _
''                      objFax1.Value & "," & _
''                      objFax2.Value & "," & _
''                      objFax3.Value & ","
''            strLine = strLine & _
''                      objChargeName.Value & "," & _
''                      objChargeKName.Value & "," & _
''                      objChargeEmail.Value & "," & _
''                      objChargePost.Value & "," & _
''                      objGovMngCd.Value & "," & _
''                      objIsrNo.Value & "," & _
''                      objIsrSign.Value & "," & _
''                      objIsrMark.Value & "," & _
''                      objHeIsrNo.Value & "," & _
''                      strIsrDivName & "," & _
''                      objBank.Value & "," & _
''                      objBranch.Value & "," & _
''                      objAccountKindName.Value & "," & _
''                      CStr(objAccountNo.Value & "") & "," & _
''                      Replace(objNotes.Value & "", vbCrLf, vbLf) & "," & _
''                      objSpare1.Value & "," & _
''                      objSpare2.Value & "," & _
''                      objSpare3.Value & "," & _
''                      objUpdDate.Value & "," & _
''                      objUpdUser.Value & ""
''            Print #lngFileNumber, strLine
'            Write #lngFileNumber, _
'                  objOrgCd1.Value & "", objOrgCd2.Value & "", objOrgKName.Value & "", objOrgName.Value & "", _
'                  objOrgSName.Value & "", objZipCd1.Value & "", objZipCd2.Value & "", objPrefName.Value & "", _
'                  objCityName.Value & "", objAddress1.Value & "", objAddress2.Value & "", _
'                  objTel1.Value & "", objTel2.Value & "", objTel3.Value & "", _
'                  objDirectTel1.Value & "", objDirectTel2.Value & "", objDirectTel3.Value & "", objExtension.Value & "", _
'                  objFax1.Value & "", objFax2.Value & "", objFax3.Value & "", _
'                  objChargeName.Value & "", objChargeKName.Value & "", _
'                  objChargeEmail.Value & "", objChargePost.Value & "", _
'                  objGovMngCd.Value & "", _
'                  objIsrNo.Value & "", objIsrSign.Value & "", objIsrMark.Value & "", objHeIsrNo.Value & "", _
'                  strIsrDivName, _
'                  objBank.Value & "", objBranch.Value & "", _
'                  objAccountKindName.Value & "", objAccountNo.Value & "", _
'                  Replace(objNotes.Value & "", vbCrLf, vbLf) & "", _
'                  objSpare1.Value & "", objSpare2.Value & "", objSpare3.Value & "", _
'                  objUpdDate.Value & "", objUpdUser.Value & ""
'
'            lngCount = lngCount + 1
'            objOraDyna.MoveNext
'        Loop
'
'        'ファイルクローズ
'        Close #lngFileNumber
'    End If
'
'    '戻り値の設定
'    EditCSVDatOrg = lngCount
'
'    Set objOraDyna = Nothing
'    Set objCommon = Nothing
'
'    'バインド変数の削除
'    objOraParam.Remove "DELFLG"
    'ダイナセットからCSVファイルを作成
    Set objCreateCsv = CreateObject("HainsCreateCsv.CreateCsv")
    Ret = objCreateCsv.CreateCsvFileFromDynaset(objOraDyna, strFileName)

    '戻り値の設定
    If Ret <> "" Then
        EditCSVDatOrg = 1
    End If
'## 2003.03.09 Mod End
      
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Organization.EditCSVDatOrg"
    
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
