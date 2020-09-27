VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "JudCmtStc"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'----------------------------
'修正履歴
'----------------------------
'管理番号: SL-UI-Y0101-105
'修正日  ：2010.06.15
'担当者  ：TCS)田村
'修正内容: 出力順区分を追加

Option Explicit

Implements ObjectControl

Private mobjContext      As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession   As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb        As OraDatabase      'OraDatabaseオブジェクト

'
' 機能　　 : 判定コメントテーブル検索用条件節作成
'
' 引数　　 : (In/Out) vntKey         検索キーの集合
'
' 戻り値　 : 判定コメントテーブル検索用の条件節
'
' 備考　　 : 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
' 　　　　   検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Private Function CreateConditionForJudCmtStcList(ByRef vntKey As Variant) As String

    Dim objCommon       As Common   '共通クラス
    
    Dim strStmt         As String   'SQLステートメント
    
    Dim i               As Long     'インデックス
    
    '引数未設定時は何もしない
    If IsEmpty(vntKey) Then
        Exit Function
    End If
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    '最初はWHERE句から開始
    strStmt = "WHERE "
    
    '検索キー数分の条件節を追加
    For i = 0 To UBound(vntKey)
              
        '2番目以降の条件節はANDで連結
        If i >= 1 Then
            strStmt = strStmt & "AND "
        End If
        
        '検索キー中の半角カナを全角カナに変換する
        vntKey(i) = objCommon.StrConvKanaWide(vntKey(i))
        
'### 2003.01.30 Updated by Ishihara@FSIT ８文字以内なら、コードも検索する。（コードは前方一致で上等）
'        strStmt = strStmt & "JS.JUDCMTSTC LIKE '%" & vntKey(i) & "%'"
        If LenB(Trim(vntKey(i))) <= 8 Then
            strStmt = strStmt & "  ( JS.JUDCMTSTC LIKE '%" & vntKey(i) & "%'" & _
                                " OR JS.JUDCMTCD  LIKE '" & vntKey(i) & "%' )"
        Else
            strStmt = strStmt & "JS.JUDCMTSTC LIKE '%" & vntKey(i) & "%'"
        End If

    Next
    
    CreateConditionForJudCmtStcList = strStmt
    
End Function

'
' 機能　　 : 検索条件を満たす判定コメントの一覧を取得する
'
' 引数　　 : (In)     strJudClassCd     検索判定分類
' 　　　　 : (In/Out) vntKey            検索キーの集合
' 　　　　 : (In)     lngStartPos       開始位置
' 　　　　 : (In)     lngGetCount       取得件数
' 　　　　 : (Out)    vntJudCmtCd       判定コメントコード
' 　　　　 : (Out)    vntJudCmtStc      判定コメント文章
' 　　　　 : (Out)    vntJudClassCd     判定分類コード
' 　　　　 : (Out)    vntJudClassName   判定分類名称
' 　　　　 : (In)     vntSearchCode     検索用コード（省略可）
' 　　　　 : (In)     vntSearchString   検索用文字列（省略可）
' 　　　　 : (In)     vntSearchModeFlg  検索条件（省略可）　0=判定分類の無いコメントも取得
' 　　　　                                  　             1=判定分類の一致するコメントのみ
' 　　　　 : (Out)    vntJudCd          判定コード
' 　　　　 : (Out)    vntWeight         判定重み

'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
'          : (In)     vntRecogLevel     認識レベル
'          : (Out)    vntGetHihyouji    非表示(0:非表示は取得しない　1:すべて取得)
'### 2004/11/17 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
'          : (Out)    vntOutPriority    出力順区分
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'

'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'　出力順区分の追加
Public Function SelectJudCmtStcList(ByVal strJudClassCd As String _
                                  , ByVal vntKey As Variant _
                                  , ByVal lngStartPos As Long _
                                  , ByVal strGetCount As String _
                                  , ByRef vntJudCmtCd As Variant _
                                  , ByRef vntJudCmtStc As Variant _
                                  , ByRef vntJudClassCd As Variant _
                                  , ByRef vntJudClassName As Variant _
                                  , Optional ByVal vntSearchCode As Variant _
                                  , Optional ByVal vntSearchString As Variant _
                                  , Optional ByVal vntSearchModeFlg As Variant = 0 _
                                  , Optional ByRef vntJudCd As Variant _
                                  , Optional ByRef vntWeight As Variant _
                                  , Optional ByVal vntRecogLevel As Variant _
                                  , Optional ByVal vntGetHihyouji As Variant = 0 _
                                  , Optional ByRef vntOutPriority As Variant _
                                    ) As Long
'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
'''Public Function SelectJudCmtStcList(ByVal strJudClassCd As String,
'''                                    ByVal vntKey As Variant,
'''                                    ByVal lngStartPos As Long,
'''                                    ByVal strGetCount As String,
'''                                    ByRef vntJudCmtCd As Variant,
'''                                    ByRef vntJudCmtStc As Variant,
'''                                    ByRef vntJudClassCd As Variant,
'''                                    ByRef vntJudClassName As Variant,
'''                                    Optional ByVal vntSearchCode As Variant,
'''                                    Optional ByVal vntSearchString As Variant,
'''                                    Optional ByVal vntSearchModeFlg As Variant = 0,
'''                                    Optional ByRef vntJudCd As Variant,
'''                                    Optional ByRef vntWeight As Variant
'''                                    ) As Long
''
''Public Function SelectJudCmtStcList(ByVal strJudClassCd As String, _
''                                    ByVal vntKey As Variant, _
''                                    ByVal lngStartPos As Long, _
''                                    ByVal strGetCount As String, _
''                                    ByRef vntJudCmtCd As Variant, _
''                                    ByRef vntJudCmtStc As Variant, _
''                                    ByRef vntJudClassCd As Variant, _
''                                    ByRef vntJudClassName As Variant, _
''                                    Optional ByVal vntSearchCode As Variant, _
''                                    Optional ByVal vntSearchString As Variant, _
''                                    Optional ByVal vntSearchModeFlg As Variant = 0, _
''                                    Optional ByRef vntJudCd As Variant, _
''                                    Optional ByRef vntWeight As Variant, _
''                                    Optional ByVal vntRecogLevel As Variant, _
''                                    Optional ByVal vntGetHihyouji As Variant = 0 _
''                                    ) As Long
''
'''### 2004/11/17 Add End
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'


    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudCmtCd             As OraField         '判定コメントコード
    Dim objJudCmtStc            As OraField         '判定コメント文章
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objJudClassName         As OraField         '判定分類名称
    Dim objJudCd                As OraField         '判定コード
    Dim objWeight               As OraField         '判定重み
'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
    Dim objHihyouji             As OraField         '非表示
'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
    Dim objOutPriority          As OraField         '出力順区分
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
    
    Dim vntArrJudCmtCd()        As Variant          '判定コメントコードの配列
    Dim vntArrJudCmtStc()       As Variant          '判定コメント文章の配列
    Dim vntArrJudClassCd()      As Variant          '判定分類コードの配列
    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim vntArrJudCd()           As Variant          '判定コードの配列
    Dim vntArrWeight()          As Variant          '判定重みの配列
'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
    Dim vntArrHihyouji()        As Variant         '非表示
    
    Const JUDCLASS_RECOGLEVEL = 50                  '生活指導コメント
    
    Dim i                       As Long             'カウント
'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
    Dim vntArrOutPriority()     As Variant          '出力順区分の配列
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'

    Dim lngCount                As Long             'レコード数
    Dim blnWhereFlg             As Boolean
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    blnWhereFlg = False
    
    If Not IsMissing(vntJudCd) Then vntJudCd = Empty
    If Not IsMissing(vntWeight) Then vntWeight = Empty
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
    If Not IsMissing(vntOutPriority) Then vntOutPriority = Empty
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    If strJudClassCd <> "" Then
        objOraParam.Add "JUDCLASSCD", CStr(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    If IsNumeric(strGetCount) Then
        objOraParam.Add "SEQ_F", CStr(lngStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_T", CStr(lngStartPos + CLng(strGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'
''''### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
'''    '検索条件を満たす判定コメントテーブルのレコードを取得
''''    strStmt = "SELECT JUDCMTCD, JUDCMTSTC, JUDCLASSCD, JUDCLASSNAME                                 " & vbLf & _
''''              "       , JUDCD, WEIGHT                                                               " & vbLf & _
''''              "  FROM ( SELECT ROWNUM SEQ, JUDCMTCD, JUDCMTSTC, JUDCLASSCD, JUDCLASSNAME            " & vbLf & _
''''              "                , JUDCD, WEIGHT                                                      " & vbLf & _
''''              "           FROM ( SELECT JS.JUDCMTCD, JS.JUDCMTSTC, JS.JUDCLASSCD, JC.JUDCLASSNAME   " & vbLf & _
''''              "                         , JS.JUDCD, JUD.WEIGHT                                      " & vbLf & _
''''              "                    FROM JUDCMTSTC JS, JUDCLASS JC                                   " & vbLf & _
''''              "                         , JUD                                                       "
'''
'''    strStmt = "SELECT JUDCMTCD, JUDCMTSTC, JUDCLASSCD, JUDCLASSNAME                                 " & vbLf & _
'''              "       , JUDCD, WEIGHT, RECOGHIHYOUJI                                                " & vbLf & _
'''              "  FROM ( SELECT ROWNUM SEQ, JUDCMTCD, JUDCMTSTC, JUDCLASSCD, JUDCLASSNAME            " & vbLf & _
'''              "                , JUDCD, WEIGHT, RECOGHIHYOUJI                                       " & vbLf & _
'''              "           FROM ( SELECT JS.JUDCMTCD, JS.JUDCMTSTC, JS.JUDCLASSCD, JC.JUDCLASSNAME   " & vbLf & _
'''              "                         , JS.JUDCD, JUD.WEIGHT, JS.RECOGHIHYOUJI                    " & vbLf & _
'''              "                    FROM JUDCMTSTC JS, JUDCLASS JC                                   " & vbLf & _
'''              "                         , JUD                                                       "
''''### 2004/11/17 Add End
    strStmt = ""
    strStmt = strStmt & "SELECT JUDCMTCD, JUDCMTSTC, JUDCLASSCD, JUDCLASSNAME                                 " & vbLf
    strStmt = strStmt & "       , JUDCD, WEIGHT, RECOGHIHYOUJI                                                " & vbLf
    strStmt = strStmt & "       , OUTPRIORITY                                                                 " & vbLf
    strStmt = strStmt & "  FROM ( SELECT ROWNUM SEQ, JUDCMTCD, JUDCMTSTC, JUDCLASSCD, JUDCLASSNAME            " & vbLf
    strStmt = strStmt & "                , JUDCD, WEIGHT, RECOGHIHYOUJI                                       " & vbLf
    strStmt = strStmt & "                , OUTPRIORITY                                                        " & vbLf
    strStmt = strStmt & "           FROM ( SELECT JS.JUDCMTCD, JS.JUDCMTSTC, JS.JUDCLASSCD, JC.JUDCLASSNAME   " & vbLf
    strStmt = strStmt & "                         , JS.JUDCD, JUD.WEIGHT, JS.RECOGHIHYOUJI                    " & vbLf
    strStmt = strStmt & "                         , JS.OUTPRIORITY                                            " & vbLf
    strStmt = strStmt & "                    FROM JUDCMTSTC JS, JUDCLASS JC                                   " & vbLf
    strStmt = strStmt & "                         , JUD                                                       " & vbLf
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'
    
             
    If Not IsEmpty(vntKey) Then
        strStmt = strStmt & vbLf & _
              "                   " & CreateConditionForJudCmtStcList(vntKey)
        If strJudClassCd <> "" Then
'## 2003.02.13 Mod 4Lines By T.Takagi@FSIT 判定分類指定時、判定分類のないコメントも表示
'            strStmt = strStmt & vbLf & _
'              "                     AND JS.JUDCLASSCD = :JUDCLASSCD"
''### 2003.10.28 判定分類の無いコメントを表示する場合としない場合を区別する
            If vntSearchModeFlg = 0 Then
                strStmt = strStmt & vbLf & _
                    "               AND (JS.JUDCLASSCD = :JUDCLASSCD OR JS.JUDCLASSCD IS NULL) "
            Else
                strStmt = strStmt & vbLf & _
                    "               AND JS.JUDCLASSCD = :JUDCLASSCD"
            End If
'## 2003.02.13 Mod End
        End If
        
'### 2003.01.17 Updated by Ishihara@FSIT 判定分類はNULLあり
'        strStmt = strStmt & vbLf & _
              "                     AND JS.JUDCLASSCD = JC.JUDCLASSCD                               "
        strStmt = strStmt & vbLf & _
              "                     AND JS.JUDCLASSCD = JC.JUDCLASSCD (+)                           "
'### 2003.01.17 Updated End
    
    Else
        If strJudClassCd <> "" Then
'## 2003.02.13 Mod 5Lines By T.Takagi@FSIT 判定分類指定時、判定分類のないコメントも表示
'            strStmt = strStmt & vbLf & _
'              "                   WHERE JS.JUDCLASSCD = :JUDCLASSCD                                 " & vbLf & _
'              "                     AND JS.JUDCLASSCD = JC.JUDCLASSCD                               "
''### 2003.10.28 判定分類の無いコメントを表示する場合としない場合を区別する
            If vntSearchModeFlg = 0 Then
                strStmt = strStmt & vbLf & _
                    "              WHERE (JS.JUDCLASSCD = :JUDCLASSCD OR JS.JUDCLASSCD IS NULL) " & vbLf & _
                    "                AND JS.JUDCLASSCD = JC.JUDCLASSCD(+)                       "
            Else
                strStmt = strStmt & vbLf & _
                    "              WHERE JS.JUDCLASSCD = :JUDCLASSCD                                 " & vbLf & _
                    "                AND JS.JUDCLASSCD = JC.JUDCLASSCD                               "
            End If
'## 2003.02.13 Mod End
        Else
'### 2003.01.17 Updated by Ishihara@FSIT 判定分類はNULLあり
'            strStmt = strStmt & vbLf & _
              "                   WHERE JS.JUDCLASSCD = JC.JUDCLASSCD                               "
            strStmt = strStmt & vbLf & _
              "                   WHERE JS.JUDCLASSCD = JC.JUDCLASSCD (+)                           "
'### 2003.01.17 Updated End
        End If
    End If
            
    strStmt = strStmt & vbLf & _
              "                     AND JS.JUDCD = JUD.JUDCD (+)                                    "
    
'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
    If IsMissing(vntRecogLevel) = False Then
        If IsNumeric(Trim(vntRecogLevel)) Then
            If strJudClassCd = JUDCLASS_RECOGLEVEL Then
            
                If vntRecogLevel = 1 Then
                    strStmt = strStmt & vbLf & _
                        "                   AND JS.RECOGLEVEL1 = 1                                  "
                ElseIf vntRecogLevel = 2 Then
                    strStmt = strStmt & vbLf & _
                        "                   AND JS.RECOGLEVEL2 = 1                                  "
                ElseIf vntRecogLevel = 3 Then
                    strStmt = strStmt & vbLf & _
                        "                   AND JS.RECOGLEVEL3 = 1                                  "
                ElseIf vntRecogLevel = 4 Then
                    strStmt = strStmt & vbLf & _
                        "                   AND JS.RECOGLEVEL4 = 1                                  "
                ElseIf vntRecogLevel = 5 Then
                    strStmt = strStmt & vbLf & _
                        "                   AND JS.RECOGLEVEL5 = 1                                  "
                End If
                
            End If
        End If
    End If
'### 2004/11/17 Add End

    strStmt = strStmt & vbLf & _
              "                   ORDER BY JS.JUDCMTCD                                              " & vbLf & _
              "                )                                                                    " & vbLf & _
              "       )                                                                             "
  
    If IsNumeric(strGetCount) Then
        strStmt = strStmt & vbLf & _
              " WHERE SEQ BETWEEN :SEQ_F AND :SEQ_T                                                 "
        blnWhereFlg = True
    End If
    
    '検索用文字列の設定（マスタメンテ用？）
    If IsMissing(vntSearchCode) = False Then
        If Trim(vntSearchCode) <> "" Then
            If blnWhereFlg = True Then
                strStmt = strStmt & "   AND JUDCMTCD LIKE '%" & vntSearchCode & "%'" & vbLf
            Else
                strStmt = strStmt & " WHERE JUDCMTCD LIKE '%" & vntSearchCode & "%'" & vbLf
                blnWhereFlg = True
            End If
        End If
    End If
                                 
    If IsMissing(vntSearchString) = False Then
        If Trim(vntSearchString) <> "" Then
            If blnWhereFlg = True Then
                strStmt = strStmt & "   AND JUDCMTSTC LIKE '%" & vntSearchString & "%'" & vbLf
            Else
                strStmt = strStmt & " WHERE JUDCMTSTC LIKE '%" & vntSearchString & "%'" & vbLf
            End If
        End If
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudCmtCd = objFields("JUDCMTCD")
        Set objJudCmtStc = objFields("JUDCMTSTC")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objJudCd = objFields("JUDCD")
        Set objWeight = objFields("WEIGHT")
'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
        Set objHihyouji = objFields("RECOGHIHYOUJI")
'### 2004/11/17 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
        Set objOutPriority = objFields("OUTPRIORITY")
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
        
        '配列形式で格納する
        lngCount = 0
        
'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
        i = 0
        
        '非表示は表示しない
        If vntGetHihyouji = 0 Then
        
            Do Until objOraDyna.EOF
                
                Do
                    ReDim Preserve vntArrHihyouji(i)
                    vntArrHihyouji(i) = objHihyouji.Value & ""
                
                    If vntArrHihyouji(i) = 1 Then
                        Exit Do
                    End If
                        
                    ReDim Preserve vntArrJudCmtCd(lngCount)
                    ReDim Preserve vntArrJudCmtStc(lngCount)
                    ReDim Preserve vntArrJudClassCd(lngCount)
                    ReDim Preserve vntArrJudClassName(lngCount)
                    ReDim Preserve vntArrJudCd(lngCount)
                    ReDim Preserve vntArrWeight(lngCount)
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
                    ReDim Preserve vntArrOutPriority(lngCount)
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
        
                    vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
                    vntArrJudCmtStc(lngCount) = objJudCmtStc.Value & ""
                    vntArrJudClassCd(lngCount) = objJudClassCd.Value & ""
                    vntArrJudClassName(lngCount) = objJudClassName.Value & ""
                    vntArrJudCd(lngCount) = objJudCd.Value & ""
                    vntArrWeight(lngCount) = objWeight.Value & ""
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
                    vntArrOutPriority(lngCount) = objOutPriority.Value & ""
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
                    lngCount = lngCount + 1
                    
                    Exit Do
                Loop
                
                i = i + 1
                objOraDyna.MoveNext
                
            Loop
        
        'すべて取得する
        Else
'### 2004/11/17 Add End

            Do Until objOraDyna.EOF
            
                ReDim Preserve vntArrJudCmtCd(lngCount)
                ReDim Preserve vntArrJudCmtStc(lngCount)
                ReDim Preserve vntArrJudClassCd(lngCount)
                ReDim Preserve vntArrJudClassName(lngCount)
                ReDim Preserve vntArrJudCd(lngCount)
                ReDim Preserve vntArrWeight(lngCount)
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
                ReDim Preserve vntArrOutPriority(lngCount)
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
    
                vntArrJudCmtCd(lngCount) = objJudCmtCd.Value & ""
                vntArrJudCmtStc(lngCount) = objJudCmtStc.Value & ""
                vntArrJudClassCd(lngCount) = objJudClassCd.Value & ""
                vntArrJudClassName(lngCount) = objJudClassName.Value & ""
                vntArrJudCd(lngCount) = objJudCd.Value & ""
                vntArrWeight(lngCount) = objWeight.Value & ""
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
                vntArrOutPriority(lngCount) = objOutPriority.Value & ""
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
                lngCount = lngCount + 1
                objOraDyna.MoveNext
            
            Loop
'### 2004/11/17 Add by Gouda@FSIT 生活指導コメントの表示分類
        End If
'### 2004/11/17 End If
    End If
    
    '戻り値の設定
    vntJudCmtCd = vntArrJudCmtCd
    vntJudCmtStc = vntArrJudCmtStc
    vntJudClassCd = vntArrJudClassCd
    vntJudClassName = vntArrJudClassName
    If Not IsMissing(vntJudCd) Then vntJudCd = vntArrJudCd
    If Not IsMissing(vntWeight) Then vntWeight = vntArrWeight
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
   If Not IsMissing(vntOutPriority) Then vntOutPriority = vntArrOutPriority
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
    
    SelectJudCmtStcList = lngCount
    
    'バインド変数の削除
'### 2011.01.17 SL-HS-Y0101-002 MOD STR ###
'    Do Until objOraParam.Count - 1
    Do Until objOraParam.Count <= 0
'### 2011.01.17 SL-HS-Y0101-002 MOD END ###
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudCmtStc.SelectJudCmtStcList"
    
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
' 機能　　 : 検索条件を満たす判定コメントの件数を取得する
'
' 引数　　 : (In/Out) vntKey  検索キーの集合
' 　　　　 : (In)     vntSearchModeFlg  検索条件（省略可）　0=判定分類の無いコメントも取得
' 　　　　                                  　             1=判定分類の一致するコメントのみ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
Public Function SelectJudCmtStcListCount(ByVal strJudClassCd As String, _
                                         ByRef vntKey As Variant, _
                                         Optional ByVal vntSearchModeFlg As Variant = 0 _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCount        As OraField         '検索件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    If strJudClassCd <> "" Then
        objOraParam.Add "JUDCLASSCD", CStr(strJudClassCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '検索条件を満たす判定コメントテーブルのレコードを取得
    strStmt = "SELECT COUNT(*)                      " & vbLf & _
              "  FROM JUDCMTSTC JS                  "

    '条件節を追加
    If Not IsEmpty(vntKey) Then
        strStmt = strStmt & vbLf & _
                  CreateConditionForJudCmtStcList(vntKey)
        If strJudClassCd <> "" Then
'## 2003.02.13 Mod 4Lines By T.Takagi@FSIT 判定分類指定時、判定分類のないコメントも表示
'            strStmt = strStmt & vbLf & _
'                  "   AND JS.JUDCLASSCD = :JUDCLASSCD   "
''### 2003.10.28 判定分類の無いコメントを表示する場合としない場合を区別する
            If vntSearchModeFlg = 0 Then
                strStmt = strStmt & vbLf & _
                    "   AND (JS.JUDCLASSCD = :JUDCLASSCD OR JS.JUDCLASSCD IS NULL) "
            Else
                strStmt = strStmt & vbLf & _
                    "   AND JS.JUDCLASSCD = :JUDCLASSCD   "
            End If
'## 2003.02.13 Mod End
        End If
    Else
        If strJudClassCd <> "" Then
'## 2003.02.13 Mod 4Lines By T.Takagi@FSIT 判定分類指定時、判定分類のないコメントも表示
'            strStmt = strStmt & vbLf & _
'                  " WHERE JS.JUDCLASSCD = :JUDCLASSCD   "
''### 2003.10.28 判定分類の無いコメントを表示する場合としない場合を区別する
            If vntSearchModeFlg = 0 Then
                strStmt = strStmt & vbLf & _
                    " WHERE JS.JUDCLASSCD = :JUDCLASSCD OR JS.JUDCLASSCD IS NULL "
            Else
                strStmt = strStmt & vbLf & _
                    " WHERE JS.JUDCLASSCD = :JUDCLASSCD   "
            End If
'## 2003.02.13 Mod End
        End If
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合は件数を戻り値として設定
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        SelectJudCmtStcListCount = objOraDyna.Fields(0).Value
    End If
    
    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "JudCmtStc.SelectJudCmtStcListCount"
    
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
' 機能　　 : 判定コメントデータを取得する
'
' 引数　　 : (In)     strJudCmtCd     判定コメントコード
' 　　　　   (Out)    vntJudCmtStc    判定コメント文章
' 　　　　   (Out)    vntJudClassCd   判定分類コード
' 　　　　   (Out)    vntGuidanceCd   指導内容コード
' 　　　　   (Out)    vntGuidanceStc  指導内容
' 　　　　   (Out)    vntJudCd        判定コード
' 　　　　   (Out)    vntJudSName     判定略称
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
'## 2003.02.14 Mod 12Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
'Public Function SelectJudCmtStc(ByVal strJudCmtCd As String,
'                                ByRef vntJudCmtStc As Variant,
'                                ByRef vntJudClassCd As Variant) As Long
Public Function SelectJudCmtStc( _
    ByVal strJudCmtCd As String, _
    ByRef vntJudCmtStc As Variant, _
    ByRef vntJudClassCd As Variant, _
    Optional ByRef vntGuidanceCd As Variant, _
    Optional ByRef vntGuidanceStc As Variant, _
    Optional ByRef vntJudCd As Variant, _
    Optional ByRef vntJudSName As Variant _
) As Long
'## 2003.02.14 Mod End

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objJudCmtStc    As OraField         '判定コメント文章
    Dim objJudClassCd   As OraField         '判定分類コード
'## 2003.02.14 Add 6Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
    Dim objGuidanceCd   As OraField         '指導内容コード
    Dim objGuidanceStc  As OraField         '指導内容
    Dim objJudCd        As OraField         '判定コード
    Dim objJudSName     As OraField         '判定略称

    Dim blnGetGuidance  As Boolean          'Trueならば指導内容、判定も取得
'## 2003.02.14 Add End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
'## 2003.02.14 Add 23Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
    '初期処理
    vntJudCmtStc = Empty
    vntJudClassCd = Empty
    
    If Not IsMissing(vntGuidanceCd) Then
        vntGuidanceCd = Empty
        blnGetGuidance = True
    End If
    
    If Not IsMissing(vntGuidanceStc) Then
        vntGuidanceStc = Empty
        blnGetGuidance = True
    End If
    
    If Not IsMissing(vntJudCd) Then
        vntJudCd = Empty
        blnGetGuidance = True
    End If
    
    If Not IsMissing(vntJudSName) Then
        vntJudSName = Empty
        blnGetGuidance = True
    End If
'## 2003.02.14 Add End
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCMTCD", Trim(strJudCmtCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす判定コメントテーブルのレコードを取得
    strStmt = "SELECT JUDCMTSTC, JUDCLASSCD FROM JUDCMTSTC WHERE JUDCMTCD = :JUDCMTCD"
    
'## 2003.02.14 Add 18Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
    '指導内容、判定も検索する場合のSQLステートメント
    '(設定如何によっては複数レコード検索されるが、設定が正しいとの前提で１件のみ取得する)
    If blnGetGuidance Then
        strStmt = "SELECT JUDCMTSTC.JUDCMTSTC, JUDCMTSTC.JUDCLASSCD,    " & vbLf & _
                  "       GUIDANCE.GUIDANCECD, GUIDANCE.GUIDANCESTC,    " & vbLf & _
                  "       JUD.JUDCD,           JUD.JUDRNAME             " & vbLf & _
                  "  FROM JUD, GUIDANCE,                                " & vbLf & _
                  "       ( SELECT FREEFIELD1 JUDCMTCD,                 " & vbLf & _
                  "                FREEFIELD2 GUIDANCECD,               " & vbLf & _
                  "                FREEFIELD3 JUDCD                     " & vbLf & _
                  "           FROM FREE                                 " & vbLf & _
                  "          WHERE FREECD LIKE 'SCRJUDPTN%'             " & vbLf & _
                  "       ) JUDCMTPTN,                                  " & vbLf & _
                  "       JUDCMTSTC                                     " & vbLf & _
                  " WHERE JUDCMTSTC.JUDCMTCD   = :JUDCMTCD              " & vbLf & _
                  "   AND JUDCMTSTC.JUDCMTCD   = JUDCMTPTN.JUDCMTCD(+)  " & vbLf & _
                  "   AND JUDCMTPTN.GUIDANCECD = GUIDANCE.GUIDANCECD(+) " & vbLf & _
                  "   AND JUDCMTPTN.JUDCD      = JUD.JUDCD(+)           "
    End If
'## 2003.02.14 Add End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudCmtStc = objFields("JUDCMTSTC")
        Set objJudClassCd = objFields("JUDCLASSCD")
    
'## 2003.02.14 Add 6Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
        If blnGetGuidance Then
            Set objGuidanceCd = objFields("GUIDANCECD")
            Set objGuidanceStc = objFields("GUIDANCESTC")
            Set objJudCd = objFields("JUDCD")
            Set objJudSName = objFields("JUDRNAME")
        End If
'## 2003.02.14 Add End
        
        '戻り値の設定
        vntJudCmtStc = objJudCmtStc.Value & ""
        vntJudClassCd = objJudClassCd.Value & ""
        
'## 2003.02.14 Add 19Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
        If blnGetGuidance Then
            
            If Not IsMissing(vntGuidanceCd) Then
                vntGuidanceCd = objGuidanceCd.Value & ""
            End If
            
            If Not IsMissing(vntGuidanceStc) Then
                vntGuidanceStc = objGuidanceStc.Value & ""
            End If
            
            If Not IsMissing(vntJudCd) Then
                vntJudCd = objJudCd.Value & ""
            End If
            
            If Not IsMissing(vntJudSName) Then
                vntJudSName = objJudSName.Value & ""
            End If
            
        End If
'## 2003.02.14 Add End
        
        SelectJudCmtStc = True
        
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
    WriteErrorLog "JudCmtStc.SelectJudCmtStc"
    
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
' 機能　　 : 判定コメントテーブルレコードを登録する
'
' 引数　　 : (In)    strMode        登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strJudCmtCd    判定コメントコード
' 　　　　   (In)    vntJudCmtStc   判定コメント名
' 　　　　   (In)    vntJudClassCd  判定分類コード
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistJudCmtStc(ByVal strMode As String, _
                                ByVal strJudCmtCd As String, _
                                ByVal strJudCmtStc As String, _
                                ByVal strJudClassCd As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JudCmtCd", Trim(strJudCmtCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JudCmtStc", Trim(strJudCmtStc), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JudClassCd", Trim(strJudClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '判定コメントテーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE JudCmtStc " & _
                      "   SET JudCmtStc = :JudCmtStc," & _
                      "       JudClassCd = :JudClassCd" & _
                      " WHERE JudCmtCd   = :JudCmtCd"
            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす判定コメントテーブルのレコードを取得
        strStmt = "SELECT JudCmtCd FROM JudCmtStc WHERE JudCmtCd = :JudCmtCd"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO JudCmtStc (JudCmtCd, JudCmtStc, JudClassCd) VALUES (:JudCmtCd, :JudCmtStc, :JudClassCd)"
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    objOraParam.Remove "JudCmtCd"
    objOraParam.Remove "JudCmtStc"
    objOraParam.Remove "JudClassCd"
    
    '戻り値の設定
    RegistJudCmtStc = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistJudCmtStc = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "JudCmtStc.RegistJudCmtStc"
    
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
' 機能　　 : 判定コメントテーブルレコードを削除する
'
' 引数　　 : (In)    strJudCmtCd    検査実施日分類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteJudCmtStc(ByVal strJudCmtCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCMTCD", Trim(strJudCmtCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検査実施日分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE JUDCMTSTC WHERE JUDCMTCD = :JUDCMTCD"
    
    'バインド変数の削除
    objOraParam.Remove "JUDCMTCD"
    
    '戻り値の設定
    DeleteJudCmtStc = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteJudCmtStc = False

    'イベントログ書き込み
    WriteErrorLog "JudCmtStc.DeleteJudCmtStc"
    
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

End Sub

'
' 機能　　 : 判定コメントデータを取得する
'
' 引数　　 : (In)     strJudCmtCd       判定コメントコード
' 　　　　   (Out)    vntJudCmtStc      判定コメント文章
' 　　　　   (Out)    vntJudClassCd     判定分類コード
' 　　　　   (Out)    vntGuidanceCd     指導内容コード
' 　　　　   (Out)    vntGuidanceStc    指導内容
' 　　　　   (Out)    vntJudCd          判定コード
' 　　　　   (Out)    vntJudSName       判定略称
'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
'            (Out)    vntHihyouji       非表示
'            (Out)    vntRecogLevel1    認識レベル１
'            (Out)    vntRecogLevel2  　認識レベル２
'            (Out)    vntRecogLevel3  　認識レベル３
'            (Out)    vntRecogLevel4  　認識レベル４
'            (Out)    vntRecogLevel5  　認識レベル５
'### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
'          : (Out)    vntOutPriority    出力順区分
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'　出力順区分を追加
Public Function SelectJudCmtStcnew( _
    ByVal strJudCmtCd As String _
  , ByRef vntJudCmtStc As Variant _
  , ByRef vntJudCmtStc_e As Variant _
  , ByRef vntJudClassCd As Variant _
  , Optional ByRef vntGuidanceCd As Variant _
  , Optional ByRef vntGuidanceStc As Variant _
  , Optional ByRef vntJudCd As Variant _
  , Optional ByRef vntJudSName As Variant _
  , Optional ByRef vntHihyouji As Variant _
  , Optional ByRef vntRecogLevel1 As Variant _
  , Optional ByRef vntRecogLevel2 As Variant _
  , Optional ByRef vntRecogLevel3 As Variant _
  , Optional ByRef vntRecogLevel4 As Variant _
  , Optional ByRef vntRecogLevel5 As Variant _
  , Optional ByRef vntOutPriority As Variant _
) As Long
''''### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
''''## 2003.02.14 Mod 12Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
''''Public Function SelectJudCmtStc(ByVal strJudCmtCd As String,
''''                                ByRef vntJudCmtStc As Variant,
''''                                ByRef vntJudClassCd As Variant) As Long
''''Public Function SelectJudCmtStcnew(
''''    ByVal strJudCmtCd As String,
''''    ByRef vntJudCmtStc As Variant,
''''    ByRef vntJudCmtStc_e As Variant,
''''    ByRef vntJudClassCd As Variant,
''''    Optional ByRef vntGuidanceCd As Variant,
''''    Optional ByRef vntGuidanceStc As Variant,
''''    Optional ByRef vntJudCd As Variant,
''''    Optional ByRef vntJudSName As Variant
'''') As Long
''''## 2003.02.14 Mod End
'''Public Function SelectJudCmtStcnew( _
'''    ByVal strJudCmtCd As String, _
'''    ByRef vntJudCmtStc As Variant, _
'''    ByRef vntJudCmtStc_e As Variant, _
'''    ByRef vntJudClassCd As Variant, _
'''    Optional ByRef vntGuidanceCd As Variant, _
'''    Optional ByRef vntGuidanceStc As Variant, _
'''    Optional ByRef vntJudCd As Variant, _
'''    Optional ByRef vntJudSName As Variant, _
'''    Optional ByRef vntHihyouji As Variant, _
'''    Optional ByRef vntRecogLevel1 As Variant, _
'''    Optional ByRef vntRecogLevel2 As Variant, _
'''    Optional ByRef vntRecogLevel3 As Variant, _
'''    Optional ByRef vntRecogLevel4 As Variant, _
'''    Optional ByRef vntRecogLevel5 As Variant _
''') As Long
''''### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objJudCmtStc    As OraField         '判定コメント文章
    Dim objJudCmtStc_e  As OraField         '判定コメント文章
    
    Dim objJudClassCd   As OraField         '判定分類コード
'## 2003.02.14 Add 6Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
    Dim objGuidanceCd   As OraField         '指導内容コード
    Dim objGuidanceStc  As OraField         '指導内容
    Dim objJudCd        As OraField         '判定コード
    Dim objJudSName     As OraField         '判定略称

    Dim blnGetGuidance  As Boolean          'Trueならば指導内容、判定も取得
'## 2003.02.14 Add End

'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
    Dim objHihyouji     As OraField         '非表示
    Dim objRecogLevel1  As OraField         '認識レベル１
    Dim objRecogLevel2  As OraField         '認識レベル２
    Dim objRecogLevel3  As OraField         '認識レベル３
    Dim objRecogLevel4  As OraField         '認識レベル４
    Dim objRecogLevel5  As OraField         '認識レベル５
    
    Dim blnGetRecogLevel    As Boolean      'Trueならば認識レベルも取得
'### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
    Dim objOutPriority  As OraField         '出力順区分
    
    Dim blnOutPriority  As Boolean
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
'## 2003.02.14 Add 23Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
    '初期処理
    vntJudCmtStc = Empty
    vntJudClassCd = Empty
    
    If Not IsMissing(vntGuidanceCd) Then
        vntGuidanceCd = Empty
        blnGetGuidance = True
    End If
    
    If Not IsMissing(vntGuidanceStc) Then
        vntGuidanceStc = Empty
        blnGetGuidance = True
    End If
    
    If Not IsMissing(vntJudCd) Then
        vntJudCd = Empty
        blnGetGuidance = True
    End If
    
    If Not IsMissing(vntJudSName) Then
        vntJudSName = Empty
        blnGetGuidance = True
    End If
'## 2003.02.14 Add End

'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
    If Not IsMissing(vntHihyouji) Then
        vntHihyouji = Empty
        blnGetRecogLevel = True
    End If
    
    If Not IsMissing(vntRecogLevel1) Then
        vntRecogLevel1 = Empty
        blnGetRecogLevel = True
    End If
        
    If Not IsMissing(vntRecogLevel2) Then
        vntRecogLevel2 = Empty
        blnGetRecogLevel = True
    End If
    
    If Not IsMissing(vntRecogLevel3) Then
        vntRecogLevel3 = Empty
        blnGetRecogLevel = True
    End If
    
    If Not IsMissing(vntRecogLevel4) Then
        vntRecogLevel4 = Empty
        blnGetRecogLevel = True
    End If
    
    If Not IsMissing(vntRecogLevel5) Then
        vntRecogLevel5 = Empty
        blnGetRecogLevel = True
    End If
'### 2004/11/15 Add End
    
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
    If Not IsMissing(vntOutPriority) Then
        vntOutPriority = Empty
        blnOutPriority = True
    End If
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JUDCMTCD", Trim(strJudCmtCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'　出力順区分追加
''''### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
'''    '検索条件を満たす判定コメントテーブルのレコードを取得
''''    strStmt = "SELECT JUDCMTSTC, JUDCMTSTC_E, JUDCLASSCD FROM JUDCMTSTC WHERE JUDCMTCD = :JUDCMTCD"
'''    strStmt = "SELECT JUDCMTSTC,   JUDCMTSTC_E, JUDCLASSCD,  RECOGHIHYOUJI,              " & vbLf & _
'''              "       RECOGLEVEL1, RECOGLEVEL2, RECOGLEVEL3, RECOGLEVEL4, RECOGLEVEL5    " & vbLf & _
'''              "  FROM JUDCMTSTC                                                          " & vbLf & _
'''              " WHERE JUDCMTCD = :JUDCMTCD                                               "
    strStmt = ""
    strStmt = strStmt & "SELECT JUDCMTSTC,   JUDCMTSTC_E, JUDCLASSCD,  RECOGHIHYOUJI               " & vbLf
    strStmt = strStmt & "     , RECOGLEVEL1, RECOGLEVEL2, RECOGLEVEL3, RECOGLEVEL4, RECOGLEVEL5    " & vbLf
    strStmt = strStmt & "     , OUTPRIORITY                                                        " & vbLf
    strStmt = strStmt & "  FROM JUDCMTSTC                                                          " & vbLf
    strStmt = strStmt & " WHERE JUDCMTCD = :JUDCMTCD                                               " & vbLf
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'
  
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'　出力順区分追加
''''## 2003.02.14 Add 18Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
'''    '指導内容、判定も検索する場合のSQLステートメント
'''    '(設定如何によっては複数レコード検索されるが、設定が正しいとの前提で１件のみ取得する)
''''    If blnGetGuidance Then
''''        strStmt = "SELECT JUDCMTSTC.JUDCMTSTC, JUDCMTSTC.JUDCLASSCD,    " & vbLf & _
''''                  "       GUIDANCE.GUIDANCECD, GUIDANCE.GUIDANCESTC,    " & vbLf & _
''''                  "       JUD.JUDCD,           JUD.JUDRNAME             " & vbLf & _
''''                  "  FROM JUD, GUIDANCE,                                " & vbLf & _
''''                  "       ( SELECT FREEFIELD1 JUDCMTCD,                 " & vbLf & _
''''                  "                FREEFIELD2 GUIDANCECD,               " & vbLf & _
''''                  "                FREEFIELD3 JUDCD                     " & vbLf & _
''''                  "           FROM FREE                                 " & vbLf & _
''''                  "          WHERE FREECD LIKE 'SCRJUDPTN%'             " & vbLf & _
''''                  "       ) JUDCMTPTN,                                  " & vbLf & _
''''                  "       JUDCMTSTC                                     " & vbLf & _
''''                  " WHERE JUDCMTSTC.JUDCMTCD   = :JUDCMTCD              " & vbLf & _
''''                  "   AND JUDCMTSTC.JUDCMTCD   = JUDCMTPTN.JUDCMTCD(+)  " & vbLf & _
''''                  "   AND JUDCMTPTN.GUIDANCECD = GUIDANCE.GUIDANCECD(+) " & vbLf & _
''''                  "   AND JUDCMTPTN.JUDCD      = JUD.JUDCD(+)           "
''''    End If
'''
'''    If blnGetGuidance Then
'''        strStmt = "SELECT JUDCMTSTC.JUDCMTSTC,    JUDCMTSTC.JUDCMTSTC_E,    " & vbLf & _
'''                  "       JUDCMTSTC.JUDCLASSCD,   JUDCMTSTC.RECOGHIHYOUJI,  " & vbLf & _
'''                  "       JUDCMTSTC.RECOGLEVEL1,  JUDCMTSTC.RECOGLEVEL2,    " & vbLf & _
'''                  "       JUDCMTSTC.RECOGLEVEL3,  JUDCMTSTC.RECOGLEVEL4,    " & vbLf & _
'''                  "       JUDCMTSTC.RECOGLEVEL5,                            " & vbLf & _
'''                  "       GUIDANCE.GUIDANCECD,    GUIDANCE.GUIDANCESTC,     " & vbLf & _
'''                  "       JUD.JUDCD,              JUD.JUDRNAME              " & vbLf & _
'''                  "  FROM JUD, GUIDANCE,                                    " & vbLf & _
'''                  "       ( SELECT FREEFIELD1 JUDCMTCD,                     " & vbLf & _
'''                  "                FREEFIELD2 GUIDANCECD,                   " & vbLf & _
'''                  "                FREEFIELD3 JUDCD                         " & vbLf & _
'''                  "           FROM FREE                                     " & vbLf & _
'''                  "          WHERE FREECD LIKE 'SCRJUDPTN%'                 " & vbLf & _
'''                  "       ) JUDCMTPTN,                                      " & vbLf & _
'''                  "       JUDCMTSTC                                         " & vbLf & _
'''                  " WHERE JUDCMTSTC.JUDCMTCD   = :JUDCMTCD                  " & vbLf & _
'''                  "   AND JUDCMTSTC.JUDCMTCD   = JUDCMTPTN.JUDCMTCD(+)      " & vbLf & _
'''                  "   AND JUDCMTPTN.GUIDANCECD = GUIDANCE.GUIDANCECD(+)     " & vbLf & _
'''                  "   AND JUDCMTPTN.JUDCD      = JUD.JUDCD(+)               "
'''    End If
''''## 2003.02.14 Add End
    If blnGetGuidance Then
        strStmt = ""
        strStmt = strStmt & "SELECT JUDCMTSTC.JUDCMTSTC,    JUDCMTSTC.JUDCMTSTC_E     " & vbLf
        strStmt = strStmt & "     , JUDCMTSTC.JUDCLASSCD,   JUDCMTSTC.RECOGHIHYOUJI   " & vbLf
        strStmt = strStmt & "     , JUDCMTSTC.RECOGLEVEL1,  JUDCMTSTC.RECOGLEVEL2     " & vbLf
        strStmt = strStmt & "     , JUDCMTSTC.RECOGLEVEL3,  JUDCMTSTC.RECOGLEVEL4     " & vbLf
        strStmt = strStmt & "     , JUDCMTSTC.RECOGLEVEL5                             " & vbLf
        strStmt = strStmt & "     , GUIDANCE.GUIDANCECD,    GUIDANCE.GUIDANCESTC      " & vbLf
        strStmt = strStmt & "     , JUD.JUDCD,              JUD.JUDRNAME              " & vbLf
        strStmt = strStmt & "     , JUDCMTSTC.OUTPRIORITY                             " & vbLf
        strStmt = strStmt & "  FROM JUD, GUIDANCE,                                    " & vbLf
        strStmt = strStmt & "       ( SELECT FREEFIELD1 JUDCMTCD,                     " & vbLf
        strStmt = strStmt & "                FREEFIELD2 GUIDANCECD,                   " & vbLf
        strStmt = strStmt & "                FREEFIELD3 JUDCD                         " & vbLf
        strStmt = strStmt & "           FROM FREE                                     " & vbLf
        strStmt = strStmt & "          WHERE FREECD LIKE 'SCRJUDPTN%'                 " & vbLf
        strStmt = strStmt & "       ) JUDCMTPTN,                                      " & vbLf
        strStmt = strStmt & "       JUDCMTSTC                                         " & vbLf
        strStmt = strStmt & " WHERE JUDCMTSTC.JUDCMTCD   = :JUDCMTCD                  " & vbLf
        strStmt = strStmt & "   AND JUDCMTSTC.JUDCMTCD   = JUDCMTPTN.JUDCMTCD(+)      " & vbLf
        strStmt = strStmt & "   AND JUDCMTPTN.GUIDANCECD = GUIDANCE.GUIDANCECD(+)     " & vbLf
        strStmt = strStmt & "   AND JUDCMTPTN.JUDCD      = JUD.JUDCD(+)               " & vbLf
    End If

'### 2004/11/15 Add End


'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudCmtStc = objFields("JUDCMTSTC")
        Set objJudCmtStc_e = objFields("JUDCMTSTC_E")
        Set objJudClassCd = objFields("JUDCLASSCD")
    
'## 2003.02.14 Add 6Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
        If blnGetGuidance Then
            Set objGuidanceCd = objFields("GUIDANCECD")
            Set objGuidanceStc = objFields("GUIDANCESTC")
            Set objJudCd = objFields("JUDCD")
            Set objJudSName = objFields("JUDRNAME")
        End If
'## 2003.02.14 Add End

'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
        If blnGetRecogLevel = True Then
            Set objHihyouji = objFields("RECOGHIHYOUJI")
            Set objRecogLevel1 = objFields("RECOGLEVEL1")
            Set objRecogLevel2 = objFields("RECOGLEVEL2")
            Set objRecogLevel3 = objFields("RECOGLEVEL3")
            Set objRecogLevel4 = objFields("RECOGLEVEL4")
            Set objRecogLevel5 = objFields("RECOGLEVEL5")
        End If
'### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####' 出力順区分の追加
        If blnOutPriority = True Then
            Set objOutPriority = objFields("OUTPRIORITY")
        End If
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
        
        '戻り値の設定
        vntJudCmtStc = objJudCmtStc.Value & ""
        vntJudCmtStc_e = objJudCmtStc_e.Value & ""
        vntJudClassCd = objJudClassCd.Value & ""
               
'## 2003.02.14 Add 19Lines By T.Takagi@FSIT 判定コメントにて一意で決定される指導内容、判定を取得
        If blnGetGuidance Then
            
            If Not IsMissing(vntGuidanceCd) Then
                vntGuidanceCd = objGuidanceCd.Value & ""
            End If
            
            If Not IsMissing(vntGuidanceStc) Then
                vntGuidanceStc = objGuidanceStc.Value & ""
            End If
            
            If Not IsMissing(vntJudCd) Then
                vntJudCd = objJudCd.Value & ""
            End If
            
            If Not IsMissing(vntJudSName) Then
                vntJudSName = objJudSName.Value & ""
            End If
            
        End If
'## 2003.02.14 Add End

'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
        If blnGetRecogLevel = True Then
        
            If Not IsMissing(vntHihyouji) Then
                vntHihyouji = objHihyouji.Value & ""
            End If
            
            If Not IsMissing(vntRecogLevel1) Then
                vntRecogLevel1 = objRecogLevel1.Value & ""
            End If
            
            If Not IsMissing(vntRecogLevel2) Then
                vntRecogLevel2 = objRecogLevel2.Value & ""
            End If
            
            If Not IsMissing(vntRecogLevel3) Then
                vntRecogLevel3 = objRecogLevel3.Value & ""
            End If
            
            If Not IsMissing(vntRecogLevel4) Then
                vntRecogLevel4 = objRecogLevel4.Value & ""
            End If
            
            If Not IsMissing(vntRecogLevel5) Then
                vntRecogLevel5 = objRecogLevel5.Value & ""
            End If
                        
        End If
'### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####' 出力順区分の追加
        If blnOutPriority = True Then
            vntOutPriority = objOutPriority.Value & ""
        End If
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
        
        SelectJudCmtStcnew = True
        
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
    WriteErrorLog "JudCmtStc.SelectJudCmtStc"
    
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
' 機能　　 : 判定コメントテーブルレコードを登録する
'
' 引数　　 : (In)    strMode           登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strJudCmtCd       判定コメントコード
' 　　　　   (In)    vntJudCmtStc      判定コメント名
' 　　　　   (In)    vntJudClassCd     判定分類コード
'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
'            (In)    strHihyouji       非表示
'            (In)    strRecogLevel1    認識レベル１
'            (In)    strRecogLevel2  　認識レベル２
'            (In)    strRecogLevel3  　認識レベル３
'            (In)    strRecogLevel4  　認識レベル４
'            (In)    strRecogLevel5  　認識レベル５
'### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
'            (In)    strOutPriority    出力順区分
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'　出力順区分
Public Function RegistJudCmtStc1(ByVal strMode As String _
                              , ByVal strJudCmtCd As String _
                              , ByVal strJudCmtStc As String _
                              , ByVal strJudCmtStc_e As String _
                              , ByVal strJudClassCd As String _
                              , Optional ByVal strHihyouji As String _
                              , Optional ByVal strRecogLevel1 As String _
                              , Optional ByVal strRecogLevel2 As String _
                              , Optional ByVal strRecogLevel3 As String _
                              , Optional ByVal strRecogLevel4 As String _
                              , Optional ByVal strRecogLevel5 As String _
                              , Optional ByVal strOutPriority As String _
                              ) As Long
''''### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
''''Public Function RegistJudCmtStc1(ByVal strMode As String,
''''                                ByVal strJudCmtCd As String,
''''                                ByVal strJudCmtStc As String,
''''                                ByVal strJudCmtStc_e As String,
''''                                ByVal strJudClassCd As String) As Long
'''
'''Public Function RegistJudCmtStc1(ByVal strMode As String, _
'''                                ByVal strJudCmtCd As String, _
'''                                ByVal strJudCmtStc As String, _
'''                                ByVal strJudCmtStc_e As String, _
'''                                ByVal strJudClassCd As String, _
'''                                Optional ByVal strHihyouji As String, _
'''                                Optional ByVal strRecogLevel1 As String, _
'''                                Optional ByVal strRecogLevel2 As String, _
'''                                Optional ByVal strRecogLevel3 As String, _
'''                                Optional ByVal strRecogLevel4 As String, _
'''                                Optional ByVal strRecogLevel5 As String) As Long
''''### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "JudCmtCd", Trim(strJudCmtCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JudCmtStc", Trim(strJudCmtStc), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JudCmtStc_e", Trim(strJudCmtStc_e), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JudClassCd", Trim(strJudClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
    objOraParam.Add "RECOGHIHYOUJI", Trim(strHihyouji), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RECOGLEVEL1", Trim(strRecogLevel1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RECOGLEVEL2", Trim(strRecogLevel2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RECOGLEVEL3", Trim(strRecogLevel3), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RECOGLEVEL4", Trim(strRecogLevel4), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RECOGLEVEL5", Trim(strRecogLevel5), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
    objOraParam.Add "OUTPRIORITY", Trim(strOutPriority), ORAPARM_INPUT, ORATYPE_VARCHAR2
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'

    Do
        '判定コメントテーブルレコードの更新
        If strMode = "UPD" Then
        
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'　出力順の追加
''''### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
''''            strStmt = "UPDATE JudCmtStc " & _
''''                      "   SET JudCmtStc = :JudCmtStc," & _
''''                      "       JudCmtStc_e = :JudCmtStc_e," & _
''''                      "       JudClassCd = :JudClassCd" & _
''''                      " WHERE JudCmtCd   = :JudCmtCd"
'''
'''            strStmt = "UPDATE JudCmtStc                             " & vbLf & _
'''                      "   SET JudCmtStc     = :JudCmtStc,           " & vbLf & _
'''                      "       JudCmtStc_e   = :JudCmtStc_e,         " & vbLf & _
'''                      "       JudClassCd    = :JudClassCd,          " & vbLf & _
'''                      "       RECOGHIHYOUJI = :RECOGHIHYOUJI,       " & vbLf & _
'''                      "       RECOGLEVEL1   = :RECOGLEVEL1,         " & vbLf & _
'''                      "       RECOGLEVEL2   = :RECOGLEVEL2,         " & vbLf & _
'''                      "       RECOGLEVEL3   = :RECOGLEVEL3,         " & vbLf & _
'''                      "       RECOGLEVEL4   = :RECOGLEVEL4,         " & vbLf & _
'''                      "       RECOGLEVEL5   = :RECOGLEVEL5          " & vbLf & _
'''                      " WHERE JudCmtCd      = :JudCmtCd             "
''''### 2004/11/15 Add End
            strStmt = ""
            strStmt = strStmt & "UPDATE JudCmtStc                             " & vbLf
            strStmt = strStmt & "   SET JudCmtStc     = :JudCmtStc            " & vbLf
            strStmt = strStmt & "     , JudCmtStc_e   = :JudCmtStc_e          " & vbLf
            strStmt = strStmt & "     , JudClassCd    = :JudClassCd           " & vbLf
            strStmt = strStmt & "     , RECOGHIHYOUJI = :RECOGHIHYOUJI        " & vbLf
            strStmt = strStmt & "     , RECOGLEVEL1   = :RECOGLEVEL1          " & vbLf
            strStmt = strStmt & "     , RECOGLEVEL2   = :RECOGLEVEL2          " & vbLf
            strStmt = strStmt & "     , RECOGLEVEL3   = :RECOGLEVEL3          " & vbLf
            strStmt = strStmt & "     , RECOGLEVEL4   = :RECOGLEVEL4          " & vbLf
            strStmt = strStmt & "     , RECOGLEVEL5   = :RECOGLEVEL5          " & vbLf
            strStmt = strStmt & "     , OUTPRIORITY   = :OUTPRIORITY          " & vbLf
            strStmt = strStmt & " WHERE JudCmtCd      = :JudCmtCd             " & vbLf
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'

            Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす判定コメントテーブルのレコードを取得
        strStmt = "SELECT JudCmtCd FROM JudCmtStc WHERE JudCmtCd = :JudCmtCd"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'#### 2010.06.15 SL-UI-Y0101-105 MOD START ####'　出力順の追加
''''### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
''''        mobjOraDb.ExecuteSQL "INSERT INTO JudCmtStc (JudCmtCd, JudCmtStc,JudCmtStc_e, JudClassCd) VALUES (:JudCmtCd, :JudCmtStc, :JudCmtStc_e, :JudClassCd)"
'''        mobjOraDb.ExecuteSQL "INSERT INTO JudCmtStc         " & vbLf & _
'''                             "          ( JudCmtCd,         " & vbLf & _
'''                             "            JudCmtStc,        " & vbLf & _
'''                             "            JudCmtStc_e,      " & vbLf & _
'''                             "            JudClassCd,       " & vbLf & _
'''                             "            RECOGHIHYOUJI,    " & vbLf & _
'''                             "            RECOGLEVEL1,      " & vbLf & _
'''                             "            RECOGLEVEL2,      " & vbLf & _
'''                             "            RECOGLEVEL3,      " & vbLf & _
'''                             "            RECOGLEVEL4,      " & vbLf & _
'''                             "            RECOGLEVEL5       " & vbLf & _
'''                             "          )                   " & vbLf & _
'''                             "   VALUES ( :JudCmtCd,        " & vbLf & _
'''                             "            :JudCmtStc,       " & vbLf & _
'''                             "            :JudCmtStc_e,     " & vbLf & _
'''                             "            :JudClassCd,      " & vbLf & _
'''                             "            :RECOGHIHYOUJI,   " & vbLf & _
'''                             "            :RECOGLEVEL1,     " & vbLf & _
'''                             "            :RECOGLEVEL2,     " & vbLf & _
'''                             "            :RECOGLEVEL3,     " & vbLf & _
'''                             "            :RECOGLEVEL4,     " & vbLf & _
'''                             "            :RECOGLEVEL5      " & vbLf & _
'''                             "          )                   "
''''### 2004/11/15 Add End
        mobjOraDb.ExecuteSQL "INSERT INTO JudCmtStc         " & vbLf & _
                             "          ( JudCmtCd          " & vbLf & _
                             "          , JudCmtStc         " & vbLf & _
                             "          , JudCmtStc_e       " & vbLf & _
                             "          , JudClassCd        " & vbLf & _
                             "          , RECOGHIHYOUJI     " & vbLf & _
                             "          , RECOGLEVEL1       " & vbLf & _
                             "          , RECOGLEVEL2       " & vbLf & _
                             "          , RECOGLEVEL3       " & vbLf & _
                             "          , RECOGLEVEL4       " & vbLf & _
                             "          , RECOGLEVEL5       " & vbLf & _
                             "          , OUTPRIORITY       " & vbLf & _
                             "          )                   " & vbLf & _
                             "   VALUES ( :JudCmtCd         " & vbLf & _
                             "          , :JudCmtStc        " & vbLf & _
                             "          , :JudCmtStc_e      " & vbLf & _
                             "          , :JudClassCd       " & vbLf & _
                             "          , :RECOGHIHYOUJI    " & vbLf & _
                             "          , :RECOGLEVEL1      " & vbLf & _
                             "          , :RECOGLEVEL2      " & vbLf & _
                             "          , :RECOGLEVEL3      " & vbLf & _
                             "          , :RECOGLEVEL4      " & vbLf & _
                             "          , :RECOGLEVEL5      " & vbLf & _
                             "          , :OUTPRIORITY      " & vbLf & _
                             "          )                   "
'#### 2010.06.15 SL-UI-Y0101-105 MOD END ####'

        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    objOraParam.Remove "JudCmtCd"
    objOraParam.Remove "JudCmtStc"
    objOraParam.Remove "JudCmtStc_e"
    objOraParam.Remove "JudClassCd"
'### 2004/11/15 Add by Gouda@FSIT 生活指導コメントの表示分類
    objOraParam.Remove "RECOGHIHYOUJI"
    objOraParam.Remove "RECOGLEVEL1"
    objOraParam.Remove "RECOGLEVEL2"
    objOraParam.Remove "RECOGLEVEL3"
    objOraParam.Remove "RECOGLEVEL4"
    objOraParam.Remove "RECOGLEVEL5"
'### 2004/11/15 Add End
'#### 2010.06.15 SL-UI-Y0101-105 ADD START ####'
    objOraParam.Remove "OUTPRIORITY"
'#### 2010.06.15 SL-UI-Y0101-105 ADD END ####'
    
    '戻り値の設定
    RegistJudCmtStc1 = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistJudCmtStc1 = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "JudCmtStc.RegistJudCmtStc"
    
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

