VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Zip"
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
' 機能　　 : 住所マスタ検索用条件節作成
'
' 引数　　 : (In)     strPrefCd  都道府県コード
' 引数　　 : (In/Out) vntKey     検索キーの集合
'
' 戻り値　 : 住所マスタ検索用の条件節
'
' 備考　　 : 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
' 　　　　   検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Private Function CreateConditionForZipList(ByVal strPrefCd As String, ByRef vntKey As Variant) As String

    Dim objCommon       As Common   '共通クラス
    
    Dim strStmt         As String   'SQLステートメント
    
    Dim strZipCd1       As String   '郵便番号1
    Dim strZipCd2       As String   '郵便番号2
    
    Dim strCondition    As String   '検索キー
    Dim blnZip          As Boolean  '検索キーが郵便番号が存在すればTrue
    Dim blnNarrow       As Boolean  '検索キーが半角文字のみの場合にTrue
    Dim i               As Long     'インデックス
    
    Do
        If IsEmpty(vntKey) Then
            Exit Do
        End If
    
        '共通クラスのインスタンス作成
        Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
        '検索キー数分の条件節を追加
        For i = 0 To UBound(vntKey)
                  
            Do
                '検索キー中の半角カナを全角カナに変換する
                vntKey(i) = objCommon.StrConvKanaWide(vntKey(i))
                
                '検索キーが半角文字のみかチェック
                If LenB(StrConv(vntKey(i), vbFromUnicode)) = Len(vntKey(i)) Then
            
                    '郵便番号として認識できるかをチェックし、上3桁と下4桁に分割
                    If isZipCd(vntKey(i), strZipCd1, strZipCd2) = False Then
                        Exit Do
                    End If
                
                    '分割後の郵便番号で条件節を作成
                    strStmt = strStmt & IIf(strStmt = "", "WHERE", " AND") & " ("
                    strStmt = strStmt & "ZIPCD1 = '" & strZipCd1 & "'" & IIf(strZipCd2 <> "", " AND ZIPCD2 = '" & strZipCd2 & "'", "")
                    strStmt = strStmt & ")"
                        
                    '郵便番号存在フラグを立てる
                    blnZip = True
                    
                    Exit Do
                End If
            
                '検索キー値が全角文字を含む場合、市区町村・字で部分検索を行う
            
                'アプストロフィはOracleの単一引用符と重複するので予め置換
                strCondition = Replace(vntKey(i), "'", "''", , , vbBinaryCompare)
            
                '条件節を作成
                strStmt = strStmt & IIf(strStmt = "", "WHERE", " AND") & " ("
                strStmt = strStmt & "CITYNAME LIKE '%" & strCondition & "%' OR SECTION LIKE '%" & strCondition & "%'"
                strStmt = strStmt & ")"
                
                Exit Do
            Loop
            
        Next i

        Exit Do
    Loop

    '郵便番号が存在しない場合は都道府県コードを条件節に含める
    If blnZip = False And Trim(strPrefCd) <> "" Then
        strStmt = strStmt & IIf(strStmt = "", "WHERE", " AND") & " "
        strStmt = strStmt & "PREFCD = '" & Replace(Trim(strPrefCd), "'", "''", , , vbBinaryCompare) & "'"
    End If
    
    CreateConditionForZipList = strStmt
    
End Function

'
' 機能　　 : 郵便番号から都道府県コードを取得する
'
' 引数　　 : (In)     strZipCd1  郵便番号１
'
' 戻り値　 : 都道府県コード
'
' 備考　　 :
'
Public Function GetPrefCdFromZip(ByRef strZipCd1 As String) As String

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objPrefCd   As OraField         '都道府県コード

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ZIPCD1", strZipCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす郵便番号テーブルのレコードを取得
    strStmt = "SELECT PREFCD FROM ZIP WHERE ZIPCD1=:ZIPCD1 AND ROWNUM=1"

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPrefCd = objFields("PREFCD")

        '戻り値の設定
        GetPrefCdFromZip = objPrefCd.Value

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Zip.GetPrefCdFromZip"
    
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
' 機能　　 : 条件式が郵便番号として認識できるかをチェックし、必要時は上3桁と下4桁に分割
'
' 引数　　 : (In/Out) strExpresstion  条件式
' 　　　　 : (Out)    strZipCd1       郵便番号1
' 　　　　 : (Out)    strZipCd2       郵便番号2
'
' 戻り値　 : True   認識可能
' 　　　　   False  認識終了
'
' 備考　　 : 認識できる形式は 999, 9999999, 999-9999 の3種
'
Public Function isZipCd(ByVal strExpression As String, Optional ByRef strZipCd1 As String, Optional ByRef strZipCd2 As String) As Boolean

    Dim i           As Long     'インデックス
    Dim Ret         As Boolean  '関数戻り値
    
    '初期処理
    strExpression = Trim(strExpression)
    strZipCd1 = ""
    strZipCd2 = ""
    
    Do
        '半角文字列でなければ認識不能
        If LenB(StrConv(strExpression, vbFromUnicode)) <> Len(strExpression) Then
            Exit Do
        End If

        '文字列長をチェック
        Select Case Len(strExpression)
        
            '3桁の場合
            Case 3
            
                '3桁とも数字でなければ認識不能
                For i = 1 To 3
                    Select Case Mid(strExpression, i, 1)
                        Case "0" To "9"
                        Case Else
                            Exit Do
                    End Select
                Next i
                
                '郵便番号1のみを編集して処理終了
                strZipCd1 = strExpression
                Ret = True
                Exit Do
                
            '7桁の場合
            Case 7
            
                '7桁とも数字でなければ認識不能
                For i = 1 To 7
                    Select Case Mid(strExpression, i, 1)
                        Case "0" To "9"
                        Case Else
                            Exit Do
                    End Select
                Next i
                
                '郵便番号1,2を分割編集して処理終了
                strZipCd1 = Mid(strExpression, 1, 3)
                strZipCd2 = Mid(strExpression, 4, 4)
                Ret = True
                Exit Do
                
            '8桁の場合
            Case 8
            
                '4桁目がハイフンでそれ以外が数字、でなければ認識不能
                For i = 1 To 8
                    If i = 4 Then
                        If Mid(strExpression, i, 1) <> "-" Then
                            Exit Do
                        End If
                    Else
                        Select Case Mid(strExpression, i, 1)
                            Case "0" To "9"
                            Case Else
                                Exit Do
                        End Select
                    End If
                Next i
                
                '郵便番号1,2を分割編集して処理終了
                strZipCd1 = Mid(strExpression, 1, 3)
                strZipCd2 = Mid(strExpression, 5, 4)
                Ret = True
                Exit Do
            
            'それ以外は桁数不一致として認識不能
            Case Else
                Exit Do
        
        End Select
            
        Exit Do
    Loop
    
    isZipCd = Ret
    
End Function

'
' 機能　　 : 検索条件を満たす住所の一覧を取得する
'
' 引数　　 : (In)     strPrefCd         都道府県コード
' 　　　　 : (In/Out) vntKey            検索キーの集合
' 　　　　 : (In)     lngStartPos       開始位置
' 　　　　 : (In)     lngGetCount       取得件数
' 　　　　 : (Out)    vntZipCd1         郵便番号1
' 　　　　 : (Out)    vntZipCd2         郵便番号2
' 　　　　 : (Out)    vntPrefCd         都道府県コード
' 　　　　 : (Out)    vntPrefName       都道府県名
' 　　　　 : (Out)    vntCityName       市区町村名
' 　　　　 : (Out)    vntSection        字
'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加
' 　　　　 : (Out)    vntCityKName      市区町村カナ名
' 　　　　 : (Out)    vntSectionKName   カナ字
'### 2004/3/18 Added End
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Public Function SelectZipList(ByVal strPrefCd As String, _
                              ByRef vntKey As Variant, _
                              ByVal lngStartPos As Long, _
                              ByVal lngGetCount As Long, _
                              ByRef vntZipCd1 As Variant, _
                              ByRef vntZipCd2 As Variant, _
                              ByRef vntPrefCd As Variant, _
                              ByRef vntPrefName As Variant, _
                              ByRef vntCityName As Variant, _
                              ByRef vntSection As Variant, _
                              Optional ByRef vntCityKName As Variant, _
                              Optional ByRef vntSectionKName As Variant _
                             ) As Long

    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    Dim strCondition    As String           '条件節
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objZipCd1       As OraField         '郵便番号1
    Dim objZipCd2       As OraField         '郵便番号2
    Dim objPrefCd       As OraField         '都道府県コード
    Dim objPrefName     As OraField         '都道府県名
    Dim objCityName     As OraField         '市区町村名
    Dim objSection      As OraField         '字
'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加
    Dim objCityKName    As OraField         '市区町村カナ名
    Dim objSectionKName As OraField         'カナ字
'### 2004/3/18 Added End
    
'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加及び無駄な処理の変更
'    Dim objCommon       As Common           '共通クラス
'### 2004/3/18 Added End
    
'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加及び無駄な処理の変更
'    Dim vntArrZipCd1    As Variant          '郵便番号1の配列
'    Dim vntArrZipCd2    As Variant          '郵便番号2の配列
'    Dim vntArrPrefCd    As Variant          '都道府県コードの配列
'    Dim vntArrPrefName  As Variant          '都道府県名の配列
'    Dim vntArrCityName  As Variant          '市区町村の配列
'    Dim vntArrSection   As Variant          '字の配列
    Dim vntArrZipCd1()          As Variant          '郵便番号1の配列
    Dim vntArrZipCd2()          As Variant          '郵便番号2の配列
    Dim vntArrPrefCd()          As Variant          '都道府県コードの配列
    Dim vntArrPrefName()        As Variant          '都道府県名の配列
    Dim vntArrCityName()        As Variant          '市区町村の配列
    Dim vntArrSection()         As Variant          '字の配列
    Dim vntArrCityKName()       As Variant      '市区町村カナ名
    Dim vntArrSectionKName()    As Variant      'カナ字
'### 2004/3/18 Added End
    Dim lngCount        As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件より条件節を作成する
    strCondition = CreateConditionForZipList(strPrefCd, vntKey)
    
    '検索条件を満たす住所マスタのレコードを取得
'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加
'    strStmt = "SELECT ZIPWORK.ZIPCD1,   ZIPWORK.ZIPCD2, " & vbLf & _
              "       ZIPWORK.PREFCD,   PREF.PREFNAME,  " & vbLf & _
              "       ZIPWORK.CITYNAME, ZIPWORK.SECTION "
    strStmt = "SELECT ZIPWORK.ZIPCD1,   ZIPWORK.ZIPCD2,  " & vbLf & _
              "       ZIPWORK.PREFCD,   PREF.PREFNAME,   " & vbLf & _
              "       ZIPWORK.CITYNAME, ZIPWORK.SECTION, " & vbLf & _
              "       ZIPWORK.CITYKNAME, ZIPWORK.SECTIONKNAME  "
'### 2004/3/18 Added End

    'SEQNo順に取得した表に対し行番号を付加するための副問い合わせ
'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加
'    strStmt = strStmt & vbLf & _
              "  FROM PREF,                                                            " & vbLf & _
              "       ( SELECT ROWNUM RECNO, ZIPCD1, ZIPCD2, PREFCD, CITYNAME, SECTION " & vbLf & _
              "           FROM ( SELECT ZIPCD1, ZIPCD2, PREFCD, CITYNAME, SECTION      " & vbLf & _
              "                    FROM ZIP " & CreateConditionForZipList(strPrefCd, vntKey)
    strStmt = strStmt & vbLf & _
              "  FROM PREF,                                                             " & vbLf & _
              "       ( SELECT ROWNUM RECNO, ZIPCD1, ZIPCD2, PREFCD, CITYNAME, SECTION, " & vbLf & _
              "                CITYKNAME, SECTIONKNAME                                  " & vbLf & _
              "           FROM ( SELECT ZIPCD1, ZIPCD2, PREFCD, CITYNAME, SECTION,      " & vbLf & _
              "                         CITYKNAME, SECTIONKNAME                         " & vbLf & _
              "                    FROM ZIP " & CreateConditionForZipList(strPrefCd, vntKey)
'### 2004/3/18 Added End
    
    'SEQNo順に取得
    strStmt = strStmt & vbLf & _
              "                   ORDER BY PREFCD, SEQ " & vbLf & _
              "                )                       " & vbLf & _
              "       ) ZIPWORK                        "

    '開始位置から表示件数分のみ取得
    strStmt = strStmt & vbLf & _
              " WHERE ZIPWORK.RECNO BETWEEN " & CStr(lngStartPos) & vbLf & _
              "                         AND " & CStr(lngStartPos + lngGetCount - 1) & vbLf & _
              "   AND ZIPWORK.PREFCD      = PREF.PREFCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
'### 2004/3/18 Deleted by Ishihara@FSIT カナ文字追加及び無駄な処理の変更
'        '共通クラスのインスタンス作成
'        Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
'### 2004/3/18 Deleted End

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objZipCd1 = objFields("ZIPCD1")
        Set objZipCd2 = objFields("ZIPCD2")
        Set objPrefCd = objFields("PREFCD")
        Set objPrefName = objFields("PREFNAME")
        Set objCityName = objFields("CITYNAME")
        Set objSection = objFields("SECTION")
'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加
        Set objCityKName = objFields("CITYKNAME")
        Set objSectionKName = objFields("SECTIONKNAME")
'### 2004/3/18 Added End

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
                        
'### 2004/3/18 Modifed by Ishihara@FSIT カナ文字追加及び無駄な処理の変更
'            objCommon.AppendArray vntArrZipCd1, objZipCd1.Value & ""
'            objCommon.AppendArray vntArrZipCd2, objZipCd2.Value & ""
'            objCommon.AppendArray vntArrPrefCd, objPrefCd.Value & ""
'            objCommon.AppendArray vntArrPrefName, objPrefName.Value & ""
'            objCommon.AppendArray vntArrCityName, objCityName.Value & ""
'            objCommon.AppendArray vntArrSection, objSection.Value & ""

            ReDim Preserve vntArrZipCd1(lngCount)
            ReDim Preserve vntArrZipCd2(lngCount)
            ReDim Preserve vntArrPrefCd(lngCount)
            ReDim Preserve vntArrPrefName(lngCount)
            ReDim Preserve vntArrCityName(lngCount)
            ReDim Preserve vntArrSection(lngCount)
            ReDim Preserve vntArrCityKName(lngCount)
            ReDim Preserve vntArrSectionKName(lngCount)

            vntArrZipCd1(lngCount) = objZipCd1.Value & ""
            vntArrZipCd2(lngCount) = objZipCd2.Value & ""
            vntArrPrefCd(lngCount) = objPrefCd.Value & ""
            vntArrPrefName(lngCount) = objPrefName.Value & ""
            vntArrCityName(lngCount) = objCityName.Value & ""
            vntArrSection(lngCount) = objSection.Value & ""
            vntArrCityKName(lngCount) = objCityKName.Value & ""
            vntArrSectionKName(lngCount) = objSectionKName.Value & ""
'### 2004/3/18 Modifed End
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
    End If
    
    '戻り値の設定
    vntZipCd1 = vntArrZipCd1
    vntZipCd2 = vntArrZipCd2
    vntPrefCd = vntArrPrefCd
    vntPrefName = vntArrPrefName
    vntCityName = vntArrCityName
    vntSection = vntArrSection
    SelectZipList = lngCount
'### 2004/3/18 Added by Ishihara@FSIT カナ文字追加
    If IsMissing(vntCityKName) = False Then vntCityKName = vntArrCityKName
    If IsMissing(vntSectionKName) = False Then vntSectionKName = vntArrSectionKName
'### 2004/3/18 Added End
        
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
        
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Zip.SelectZipList"

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 検索条件を満たす住所の件数を取得する
'
' 引数　　 : (In)     strPrefCd  都道府県コード
' 　　　　 : (In/Out) vntKey     検索キーの集合
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Public Function SelectZipListCount(ByVal strPrefCd As String, ByRef vntKey As Variant) As Long

    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件を満たす住所マスタのレコードを取得
    strStmt = "SELECT COUNT(*) FROM ZIP " & CreateConditionForZipList(strPrefCd, vntKey)

    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合は件数を戻り値として設定
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        SelectZipListCount = objOraDyna.Fields(0).Value
    End If
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
        
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Zip.SelectZipListCount"

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

End Sub
