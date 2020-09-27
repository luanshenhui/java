VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Person"
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

Private Const VID_PREFIX    As String = "@"         '仮ＩＤ用の接頭子
Private Const RID_PREFIX    As String = "1"         '実ＩＤ用の接頭子

'個人情報抽出条件
Private Const MODE_CSL      As String = "csl"       '指定期間の受診者指定
Private Const MODE_ZIP      As String = "zip"       '郵便番号指定

Private Const PREFIX_PERID  As String = "ID:"       '検索時の個人ＩＤ指定
Private Const PREFIX_BIRTH  As String = "BIRTH:"    '検索時の生年月日指定
Private Const PREFIX_GENDER As String = "GENDER:"   '検索時の性別指定

'## 2003.11.29 Add By T.Takagi@FSIT HOPEの患者ID桁数管理
Private Const LENGTH_HOPE_PERID As Long = 10
'## 2003.11.29 Add End

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Private Sub AppendColumn(ByVal strColumnName As String, ByRef strArrColumnName() As String, ByRef lngColumnCount As Long)

    If lngColumnCount = 0 Then
        ReDim strArrColumnName(lngColumnCount)
    Else
        ReDim Preserve strArrColumnName(lngColumnCount)
    End If
    strArrColumnName(lngColumnCount) = strColumnName
    lngColumnCount = lngColumnCount + 1

End Sub

'
' 機能　　 : 生年月日条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_Birth(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス
    Dim strStmt         As String           'SQLステートメント
    Dim strBirth        As String           '生年月日

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    '先頭６文字が"BIRTH:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_BIRTH))) = PREFIX_BIRTH Then
        strBirth = Right(strBuffer, Len(strBuffer) - Len(PREFIX_BIRTH))
    Else
        strBirth = strBuffer
    End If
    
    'すでに日付型である場合
    If IsDate(strBirth) Then
        
        'そのまま適用
        strBirth = Format(CDate(strBirth), "yyyy/m/d")
    
    '日付型でない(すなわち８桁の数字列である)場合
    Else
    
        '年がゼロの場合はシステム年を適用し、さもなくばそのまま日付型にして適用
        strBirth = Format(IIf(Left(strBirth, 4) = "0000", Year(Date) & Right(strBirth, 4), strBirth), "0000/00/00")
    
    End If
    
    'パラメータ追加
    strParamName = "BIRTH" & CStr(lngParamNo)
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, CDate(strBirth), ORAPARM_INPUT, ORATYPE_DATE
    
    '条件節の編集
    strStmt = "PERSON.BIRTH = :" & strParamName
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
End Sub

'
' 機能　　 : 従業員番号条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_EmpNo(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス
    Dim strStmt         As String           'SQLステートメント
    Dim vntToken        As Variant          'トークン

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strOrgCd1       As String           'パラメータ名
    Dim strOrgCd2       As String           'パラメータ名
    Dim strEmpNo        As String           'パラメータ名

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    'ハイフンで分割(事前チェック済みなので要素は必ず３個)
    vntToken = Split(strBuffer, "-")

    Set objOraParam = mobjOraDb.Parameters
    strOrgCd1 = "ORGCD1_" & CStr(lngParamNo)
    strOrgCd2 = "ORGCD2_" & CStr(lngParamNo)
    strEmpNo = "EMPNO" & CStr(lngParamNo)
    objOraParam.Add strOrgCd1, CStr(vntToken(0)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add strOrgCd2, CStr(vntToken(1)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add strEmpNo, CStr(vntToken(2)), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '条件節の編集
    strStmt = "( PERSON.ORGCD1 = :" & strOrgCd1 & " AND PERSON.ORGCD2 = :" & strOrgCd2 & " AND PERSON.EMPNO = :" & strEmpNo & ")"
        
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
End Sub

'
' 機能　　 : 性別条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_Gender(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名
    
    Dim objCommon       As Common           '共通クラス
    Dim strStmt         As String           'SQLステートメント

    Dim strGender       As String           '性別

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    Set objOraParam = mobjOraDb.Parameters
    
    '先頭６文字が"GENDER:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_GENDER))) = PREFIX_GENDER Then
        strGender = Right(strBuffer, Len(strBuffer) - Len(PREFIX_GENDER))
    Else
        strGender = strBuffer
    End If
    
    '男性指定か女性指定か？
    Select Case UCase(strGender)
        
        Case "M", "F"
    
            'パラメータ追加
            strParamName = "GENDER" & CStr(lngParamNo)
            objOraParam.Add strParamName, IIf(UCase(strGender) = "M", GENDER_MALE, GENDER_FEMALE), ORAPARM_INPUT, ORATYPE_NUMBER
    
            strStmt = "PERSON.GENDER = :" & strParamName
    
        Case Else
            Exit Sub
            
    End Select
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
End Sub

'
' 機能　　 : 健保記号番号条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_Insured(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon   As Common           '共通クラス
    Dim strStmt     As String           'SQLステートメント
    Dim vntToken    As Variant          'トークン

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strIsrSign  As String           'パラメータ名
    Dim strIsrNo    As String           'パラメータ名

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    'ハイフンで分割(事前チェック済みなので要素は必ず２個)
    vntToken = Split(strBuffer, "-")

    Set objOraParam = mobjOraDb.Parameters
    strIsrSign = "ISRSIGN" & CStr(lngParamNo)
    strIsrNo = "ISRNO" & CStr(lngParamNo)
    objOraParam.Add strIsrSign, CStr(vntToken(0)), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add strIsrNo, CStr(vntToken(1)), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '条件節の編集
    strStmt = "( PERSON.ISRSIGN = :" & strIsrSign & " AND PERSON.ISRNO = :" & strIsrNo & ")"
        
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
End Sub

'
' 機能　　 : 個人ＩＤ条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_PerId(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス
    Dim strStmt         As String           'SQLステートメント
    Dim strPerId        As String           '個人ＩＤ

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名

    '先頭３文字が"ID:"である場合は先頭部を取り除いた部分を個人IDとして取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_PERID))) = PREFIX_PERID Then
        strPerId = Right(strBuffer, Len(strBuffer) - Len(PREFIX_PERID))
    Else
        strPerId = strBuffer
    End If

    'パラメータ追加
    strParamName = "PERID" & CStr(lngParamNo)
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    '文字列の末尾が"*"なら部分検索
    If Right(strPerId, 1) = "*" Then
    
        objOraParam(strParamName).Value = Trim(Left(strPerId, Len(strPerId) - 1)) & "%"
        strStmt = "PERSON.PERID LIKE :" & strParamName

    'さもなければ直接指定
    Else
    
        objOraParam(strParamName).Value = Trim(strPerId)
        strStmt = "PERSON.PERID = :" & strParamName
    
    End If

    '配列に追加
    Set objCommon = CreateObject("HainsCommon.Common")
    objCommon.AppendArray vntCondition, strStmt
    
    Set objCommon = Nothing
    Set objOraParam = Nothing
    
End Sub

'## 2003.11.21 Add Function by T.Takagi@FSIT
'
' 機能　　 : ローマ字条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 : 前方一致検索のみ対応
'
Private Sub AppendCondition_RomeName(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long, ByVal blnRomeNameMultiple As Boolean)

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名
    Dim strParamName2   As String           'パラメータ名

    Dim objCommon       As Common           '共通クラス
    Dim strStmt         As String           'SQLステートメント
    Dim strBuffer2      As String           '文字列バッファ
    Dim i               As Long             'インデックス
    
    Dim lngPos          As String
    
    Set objOraParam = mobjOraDb.Parameters
        
    strBuffer = UCase(strBuffer)
        
    Do
    
        '複合検索を行わない場合
        If Not blnRomeNameMultiple Then
            Exit Do
        End If
        
        '１つ目の空白を検索。見つからない場合は複合検索を行わない場合と同じ
        lngPos = InStr(1, strBuffer, " ", vbTextCompare)
        If lngPos <= 0 Then
            blnRomeNameMultiple = False
            Exit Do
        End If
        
        '１つ目の空白以降の部分文字列を取得。なければ複合検索を行わない場合と同じ
        strBuffer2 = Trim(Right(strBuffer, Len(strBuffer) - lngPos))
        If strBuffer2 = "" Then
            blnRomeNameMultiple = False
            Exit Do
        End If
        
        Exit Do
    Loop
    
    'パラメータ追加
    strParamName = "NAME" & CStr(lngParamNo)
'    objOraParam.Add strParamName, strBuffer, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add strParamName, strBuffer & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '複合検索を行う場合はさらにパラメータ追加
    If blnRomeNameMultiple Then
        strParamName2 = "PARTNAME" & CStr(lngParamNo)
'        objOraParam.Add strParamName2, strBuffer2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add strParamName2, strBuffer2 & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
        
    '複合検索を行わない場合
    If Not blnRomeNameMultiple Then
            
        'パラメータ値の完全一致検索のみ
'        strStmt = "PERSON.ROMENAME = :" & strParamName
        strStmt = "PERSON.ROMENAME LIKE :" & strParamName
            
    '複合検索を行う場合
    Else
    
        'パラメータ値の完全一致検索あるいは部分文字列検索
'        strStmt = "( PERSON.ROMENAME = :" & strParamName & " OR PERSON.SEARCHRNAME = :" & strParamName2 & " )"
        strStmt = "( PERSON.ROMENAME LIKE :" & strParamName & " OR PERSON.SEARCHRNAME LIKE :" & strParamName2 & " )"
    
    End If
    
    '配列に追加
    Set objCommon = CreateObject("HainsCommon.Common")
    objCommon.AppendArray vntCondition, strStmt
    
End Sub

'
' 機能　　 : 全角文字条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 : 前方一致検索のみ対応
'
Private Sub AppendCondition_Wide(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName1   As String           'パラメータ名
    Dim strParamName2   As String           'パラメータ名
    Dim strParamName3   As String           'パラメータ名
    Dim strParamName4   As String           'パラメータ名

    Dim objCommon       As Common           '共通クラス

    Dim strStmt         As String           'SQLステートメント
    Dim strNarrow       As String           '半角変換後の文字列
    Dim blnWideChar     As Boolean          'カナ漢字チェック用変数
    Dim strBuffer2      As String           '文字列バッファ
    
    Dim strLastName     As String           '姓
    Dim strFirstName    As String           '名
    Dim strCnvLastName  As String           '姓
    Dim strCnvFirstName As String           '名
    
    Dim lngPos          As Long             '空白検索位置
    Dim i               As Long             'インデックス
    
    'カナ以外の全角文字が存在するかをチェック(カナは半角変換でき、漢字・ひらがなは半角変換できない性質を利用)
    strNarrow = StrConv(strBuffer, vbNarrow)
    blnWideChar = False
    For i = 1 To Len(strNarrow)
        If Asc(Mid(strNarrow, i, 1)) < 0 Then
            blnWideChar = True
            Exit For
        End If
    Next i
        
    '姓名で検索するか姓のみで検索するかを判定
    Do
    
        '１つ目の空白を検索。見つからない場合は姓のみ。
        lngPos = InStr(1, strBuffer, " ", vbTextCompare)
        If lngPos <= 0 Then
            strLastName = Trim(strBuffer)
            strFirstName = ""
            Exit Do
        End If
        
        '１つ目の空白以降の部分文字列を取得。なければ複合検索を行わない場合と同じ
        strBuffer2 = Trim(Right(strBuffer, Len(strBuffer) - lngPos))
        If strBuffer2 = "" Then
            strLastName = Trim(strBuffer)
            strFirstName = ""
            Exit Do
        End If
        
        '姓名に分離
        strLastName = Trim(Left(strBuffer, lngPos - 1))
        strFirstName = strBuffer2
        
        Exit Do
    Loop
        
    Set objOraParam = mobjOraDb.Parameters
        
    '姓のみで検索する場合
    If strFirstName = "" Then
        
        'パラメータ追加
        strParamName1 = "LASTNAME" & CStr(lngParamNo)
        objOraParam.Add strParamName1, strLastName & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        Do
            
            'カナ以外の全角文字が含まれる場合
            If blnWideChar = True Then
                strStmt = "( PERSON.LASTNAME LIKE :" & strParamName1 & " )"
                Exit Do
            End If
                    
'## 2003.12.17 Del By T.Takagi@FSIT ハットリ仕様オミット
'            'カナ名しか存在しない場合、文字列置換を行う
'            strCnvLastName = ReplaceKanaString(strLastName)
'
'            '置換前後で文字列値が異なる場合、双方の値で検索を行う
'            If strCnvLastName <> strLastName Then
'
'                'パラメータ追加
'                strParamName2 = "CNVLASTNAME" & CStr(lngParamNo)
'                objOraParam.Add strParamName2, strCnvLastName & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
'
'                strStmt = "( PERSON.LASTKNAME LIKE :" & strParamName1 & " OR PERSON.LASTKNAME LIKE :" & strParamName2 & " )"
'
'                Exit Do
'            End If
'## 2003.12.17 Del End
    
            '置換前後で文字列値が同一ならば通常の検索を行う
            strStmt = "( PERSON.LASTKNAME LIKE :" & strParamName1 & " ) "
    
            Exit Do
        Loop
    
    '姓名で検索する場合
    Else
    
        'パラメータ追加
        strParamName1 = "LASTNAME" & CStr(lngParamNo)
        strParamName2 = "FIRSTNAME" & CStr(lngParamNo)
        objOraParam.Add strParamName1, strLastName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add strParamName2, strFirstName & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        Do
            
            'カナ以外の全角文字が含まれる場合
            If blnWideChar = True Then
                strStmt = "( PERSON.LASTNAME = :" & strParamName1 & " AND PERSON.FIRSTNAME LIKE :" & strParamName2 & " )"
                Exit Do
            End If
                    
'## 2003.12.17 Del By T.Takagi@FSIT ハットリ仕様オミット
'            'カナ名しか存在しない場合、文字列置換を行う
'            strCnvLastName = ReplaceKanaString(strLastName)
'            strCnvFirstName = ReplaceKanaString(strFirstName)
'
'            '置換前後で文字列値が異なる場合、双方の値で検索を行う
'            If strCnvLastName <> strLastName Or strCnvFirstName <> strFirstName Then
'
'                'パラメータ追加
'                strParamName3 = "CNVLASTNAME" & CStr(lngParamNo)
'                strParamName4 = "CNVFIRSTNAME" & CStr(lngParamNo)
'                objOraParam.Add strParamName3, strCnvLastName, ORAPARM_INPUT, ORATYPE_VARCHAR2
'                objOraParam.Add strParamName4, strCnvFirstName & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
'
'                strStmt = "( ( PERSON.LASTKNAME = :" & strParamName1 & " AND PERSON.FIRSTKNAME LIKE :" & strParamName2 & " ) OR " & _
'                          "  ( PERSON.LASTKNAME = :" & strParamName3 & " AND PERSON.FIRSTKNAME LIKE :" & strParamName4 & " ) )"
'
'                Exit Do
'            End If
'## 2003.12.17 Del End
    
            '置換前後で文字列値が同一ならば通常の検索を行う
            strStmt = "( PERSON.LASTKNAME = :" & strParamName1 & " AND PERSON.FIRSTKNAME LIKE :" & strParamName2 & " )"
    
            Exit Do
        Loop
    
    End If
    
    '配列に追加
    Set objCommon = CreateObject("HainsCommon.Common")
    objCommon.AppendArray vntCondition, strStmt
    
    Set objCommon = Nothing
    Set objOraParam = Nothing
    
End Sub

'
' 機能　　 : 個人ＩＤつけかえ
'
' 引数　　 : (In)     strFromPerID      変更される個人ID
' 　　　　 : (In)     strToPerID        変更する個人ID
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function ChangePerID(ByVal strFromPerID As String, ByVal strToPerID As String) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim lngColumnCount  As Long             '列数
    Dim strColumnName() As String           '列名
    Dim blnStatus       As Boolean
    
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    blnStatus = False
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "FROMPERID", Trim(strFromPerID), ORAPARM_INPUT
    objOraParam.Add "TOPERID", Trim(strToPerID), ORAPARM_INPUT
    
    Do
        
        '予約情報テーブルの更新
        strStmt = "UPDATE CONSULT    SET PERID = :TOPERID WHERE PERID = :FROMPERID"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        'WEBユーザIDテーブルの更新
        strStmt = "UPDATE WEB_USERID SET PERID = :TOPERID WHERE PERID = :FROMPERID"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        '個人検査結果テーブルの更新
        strStmt = "UPDATE PERRESULT  SET PERID = :TOPERID WHERE PERID = :FROMPERID"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        '団体名簿明細テーブルの更新
        strStmt = "UPDATE ORGRSV_D   SET PERID = :TOPERID WHERE PERID = :FROMPERID"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        'アフターケアテーブルの更新
        strStmt = "UPDATE AFTERCARE   SET PERID = :TOPERID WHERE PERID = :FROMPERID"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
        'アフターケア管理項目テーブルの更新
        strStmt = "UPDATE AFTERCARE_M SET PERID = :TOPERID WHERE PERID = :FROMPERID"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
        'アフターケア面接文章テーブルの更新
        strStmt = "UPDATE AFTERCARE_C SET PERID = :TOPERID WHERE PERID = :FROMPERID"
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        'アフターケア締め管理テーブルの更新
        '請求年度が重複しないものだけをセットする。
        strStmt = _
                "INSERT INTO AFTERCARE_CLOSE                             " & vbLf & _
                "       ( PERID, CONTACTYEAR, BILLNO )                   " & vbLf & _
                "SELECT :TOPERID PERID,                                  " & vbLf & _
                "       AFTERCARE_CLOSE.CONTACTYEAR,                     " & vbLf & _
                "       AFTERCARE_CLOSE.BILLNO                           " & vbLf & _
                "  FROM AFTERCARE_CLOSE                                  " & vbLf & _
                " WHERE AFTERCARE_CLOSE.PERID = :FROMPERID               " & vbLf & _
                "   AND AFTERCARE_CLOSE.CONTACTYEAR NOT IN               " & vbLf & _
                "       (SELECT AFTERCARE_CLOSE.CONTACTYEAR              " & vbLf & _
                "           FROM AFTERCARE_CLOSE                         " & vbLf & _
                "          WHERE AFTERCARE_CLOSE.PERID = :TOPERID)       "
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        'アフターケア締め管理テーブルの更新
        strStmt = _
                "DELETE AFTERCARE_CLOSE WHERE AFTERCARE_CLOSE.PERID = :FROMPERID " & vbLf
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
        blnStatus = True
    
        Exit Do
    Loop

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    ChangePerID = True
    
    If blnStatus Then
        'トランザクションをコミット
        mobjContext.SetComplete
    Else
        'エラー発生時はトランザクションをアボートに設定
        mobjContext.SetAbort
    End If
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.ChangePerID"
    
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

'## 2004.02.10 Add By T.Takagi@FSIT 未来の受診情報所持者に対する性別変更は不可
'
' 機能　　 : 指定個人情報の性別および未来受診情報のチェック
'
' 引数　　 : (In)     strPerId   個人ＩＤ
' 　　　　   (In)     lngGender  性別
'
' 戻り値　 : 1   正常終了
' 　　　　   0   個人情報が存在しない
' 　　　　   -1  性別が引数値と異なり、かつ未来受診情報が存在
' 　　　　   -2  その他のエラー
'
' 備考　　 : 引数指定された性別と現個人情報とのそれを比較し、異なる場合は未来受診情報の有無をチェック。存在時はエラー。
' 　　　　   (本処理により、性別ごとの予約人数管理における件数不整合を抑制する)
'
Private Function CheckGenderAndConsult(ByVal strPerId As String, ByVal lngGender As Long) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim lngCurGender    As Long             '現在の性別
    
    Dim Ret             As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '現在の性別を取得
    strStmt = "SELECT GENDER FROM PERSON WHERE PERID = :PERID FOR UPDATE"
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    Do
    
        '初期処理
        Ret = 1
        
        'レコードが存在しない場合は終了
        If objOraDyna.EOF Then
            Ret = 0
            Exit Do
        End If

        '現在の性別を取得
        lngCurGender = objOraDyna.Fields("GENDER").Value

        Set objOraDyna = Nothing
        
        '性別に変更がなければチェック不要
        If lngGender = lngCurGender Then
            Exit Do
        End If

        'システム日付以降において本個人情報の受診情報が存在するかをチェック
        strStmt = "SELECT CSLDATE FROM CONSULT WHERE PERID = :PERID AND CSLDATE >= TRUNC(SYSDATE)"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

        '存在する場合はエラー
        If Not objOraDyna.EOF Then
            Ret = -1
        End If
        
        Exit Do
    Loop
    
    Set objOraDyna = Nothing
    
    '戻り値の設定
    CheckGenderAndConsult = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    CheckGenderAndConsult = -2

    'イベントログ書き込み
    WriteErrorLog "Contract.CheckGenderAndConsult"
    
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
' 機能　　 : 個人情報抽出時指定条件の妥当性チェックおよび日付、年齢の編集を行う
'
' 引数　　 : (In)     strCase           抽出条件
' 　　　　 : (In)     lngStrYear        受診年(自)
' 　　　　 : (In)     lngStrMonth       受診月(自)
' 　　　　 : (In)     lngStrDay         受診日(自)
' 　　　　 : (In)     lngEndYear        受診年(至)
' 　　　　 : (In)     lngEndMonth       受診月(至)
' 　　　　 : (In)     lngEndDay         受診日(至)
' 　　　　 : (In)     strStrAgeY        受診時(自)年齢(年)
' 　　　　 : (In)     strStrAgeM        受診時(自)年齢(月)
' 　　　　 : (In)     strEndAgeY        受診時(至)年齢(年)
' 　　　　 : (In)     strEndAgeM        受診時(至)年齢(月)
' 　　　　 : (In)     strZipCd1         郵便番号１
' 　　　　 : (Out)    vntStrDate        受診年月日(自)
' 　　　　 : (Out)    vntEndDate        受診年月日(至)
' 　　　　 : (Out)    vntStrAge         受診時(自)年齢
' 　　　　 : (Out)    vntEndAge         受診時(至)年齢
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueDatPerson(ByVal strCase As String, _
                                    ByVal lngStrYear As Long, ByVal lngStrMonth As Long, ByVal lngStrDay As Long, _
                                    ByVal lngEndYear As Long, ByVal lngEndMonth As Long, ByVal lngEndDay As Long, _
                                    ByVal strStrAgeY As String, ByVal strStrAgeM As String, _
                                    ByVal strEndAgeY As String, ByVal strEndAgeM As String, _
                                    ByVal strZipCd1 As String, _
                                    ByRef vntStrDate As Variant, ByRef vntEndDate As Variant, _
                                    ByRef vntStrAge As Variant, ByRef vntEndAge As Variant _
                                   ) As Variant
    
    Const MSG_NOCONDITION   As String = "抽出条件のいずれかを選択してください。(必須項目)"
    Const MSG_ERRDATE       As String = "受診日の指定に誤りがあります。"
    Const MSG_ERRPERIOD     As String = "期間の指定が誤っています。"
    Const MSG_ERRAGE        As String = "年齢の範囲指定が誤っています。"
    Const MSG_NOZIPCODE     As String = "郵便番号を指定してください。(必須項目)"
    
    Const STRDATE           As String = "受診年月日(自)"
    Const ENDDATE           As String = "受診年月日(至)"
    
    Const HTML_BR           As String = "<BR>"
    
    Dim objCommon           As Common   '共通クラス
    
    Dim vntArrMessage       As Variant  'エラーメッセージの集合
    Dim strMessage          As String   'エラーメッセージ
    Dim blnErrDate          As Boolean  '受診年月日エラーステータス
    Dim strErrMsg           As String   '編集用エラーメッセージ
    Dim strSubMsg           As String   'エラー補足メッセージ
    Dim i                   As Long     'インデックス
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    '各指定値チェック処理
    '抽出条件チェック
    If strCase = "" Then
        'エラーメッセージ追加
        strMessage = MSG_NOCONDITION
        objCommon.AppendArray vntArrMessage, strMessage
    End If
    
    Select Case strCase
        Case MODE_CSL            '指定期間の受診者指定時の条件チェック

            '日付の妥当性チェック
            blnErrDate = False
            'メッセージ本文
            strErrMsg = MSG_ERRDATE
            '年月日(自)のチェック
            strSubMsg = objCommon.CheckDate(STRDATE, lngStrYear, lngStrMonth, lngStrDay, vntStrDate, CHECK_NECESSARY)
            If strSubMsg <> "" Then
                '詳細メッセージの追加
                strErrMsg = strErrMsg & HTML_BR & _
                            "(" & strSubMsg & ")"
                blnErrDate = True
            End If
            '年月日(至)のチェック
            strSubMsg = objCommon.CheckDate(ENDDATE, lngEndYear, lngEndMonth, lngEndDay, vntEndDate, CHECK_NECESSARY)
            If strSubMsg <> "" Then
                '詳細メッセージの追加
                strErrMsg = strErrMsg & HTML_BR & _
                            "(" & strSubMsg & ")"
                blnErrDate = True
            End If
        
            '受診年月日のチェック
            If blnErrDate Then
                '受診年月日のいずれかひとつでもエラーのときエラーメッセージ追加
                strMessage = strErrMsg
                objCommon.AppendArray vntArrMessage, strMessage
            Else
                '指定期間の範囲チェック
                If vntStrDate > vntEndDate Then
                    'エラーメッセージ追加
                    strMessage = MSG_ERRPERIOD
                    objCommon.AppendArray vntArrMessage, strMessage
                End If
            End If
        
            '受診年齢の編集
            '受診時年齢(自)
            If strStrAgeM = "" Then
                strStrAgeM = "0"  '年齢(月)未選択時は"0"扱い
            End If
            If strStrAgeY <> "" Then
                '受診時年齢(自)の編集
                vntStrAge = strStrAgeY & "." & IIf(CLng(strStrAgeM) < 10, "0", "") & strStrAgeM
            Else
                vntStrAge = ""    '受診時年齢(自)未選択扱い
            End If
            '受診時年齢(至)
            If strEndAgeM = "" Then
                strEndAgeM = "0"  '年齢(月)未選択時は"0"扱い
            End If
            If strEndAgeY <> "" Then
                '受診時年齢(至)の編集
                vntEndAge = strEndAgeY & "." & IIf(CLng(strEndAgeM) < 10, "0", "") & strEndAgeM
            Else
                vntEndAge = ""    '受診時年齢(至)未選択扱い
            End If
        
            '受診時年齢の範囲チェック
            If (vntStrAge <> "") And (vntEndAge <> "") Then
                If CSng(vntStrAge) > CSng(vntEndAge) Then
                    'エラーメッセージ追加
                    strMessage = MSG_ERRAGE
                    objCommon.AppendArray vntArrMessage, strMessage
                End If
            End If
        
        Case MODE_ZIP            '郵便番号指定時の条件チェック

            '郵便番号1欄
            If strZipCd1 = "" Then
                'エラーメッセージ追加
                strMessage = MSG_NOZIPCODE
                objCommon.AppendArray vntArrMessage, strMessage
            End If
    
    End Select
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueDatPerson = vntArrMessage
    End If
    
    Set objCommon = Nothing
    
End Function

'
' 機能　　 : 個人テーブル検索用条件節作成
'
' 引数　　 : (In/Out) vntKey            検索キーの集合
' 　　　　   (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (In)     blnDelFlgUseOnly  True指定時は削除フラグが"0"(使用中)のレコードのみ検索
'
' 戻り値　 : 個人テーブル検索用の条件節
'
' 備考　　 : 一覧取得用と件数取得用のSQL間で条件が共通化できるため関数を作成
' 　　　　   検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
'## 2003.11.21 Mod by T.Takagi@FSIT ローマ字検索機能
'Private Function CreateConditionForPersonList(
'    ByVal vntKey As Variant,
'    ByVal dtmBirth As Date,
'    ByVal lngGender As Long,
'    ByVal blnDelFlgUseOnly As Boolean
') As String
Private Function CreateConditionForPersonList( _
    ByVal vntKey As Variant, _
    ByVal dtmBirth As Date, _
    ByVal lngGender As Long, _
    ByVal blnRomeNameMultiple As Boolean, _
    ByVal blnDelFlgUseOnly As Boolean _
) As String
'## 2003.11.21 Mod End

    Dim objCommon       As Common   '共通クラス
    
    Dim lngKeyCount     As Long     '検索キー数
    
    Dim vntCondition    As Variant  '条件節の集合
    Dim strBuffer       As String   '文字列バッファ
    Dim i               As Long     'インデックス
    
'## 2003.11.21 Add by T.Takagi@FSIT 複合検索はやめる
    Dim vntArrKey()     As Variant  '条件節の集合
'## 2003.11.21 Add End
    
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
    '使用中レコードのみ検索する場合は条件を追加
    If blnDelFlgUseOnly Then
        objCommon.AppendArray vntCondition, "PERSON.DELFLG = " & DELFLG_USED
    End If
    
'## 2003.11.21 Del by T.Takagi@FSIT 複合検索はやめる
'    '検索キー数の取得
'    If Not IsEmpty(vntKey) Then
'        lngKeyCount = UBound(vntKey) + 1
'    End If
'## 2003.11.21 Del End
    
'## 2003.11.21 Add by T.Takagi@FSIT 複合検索はやめる
    '検索キー指定時は検索キー集合に追加
    If vntKey <> "" Then
        ReDim Preserve vntArrKey(lngKeyCount)
        vntArrKey(lngKeyCount) = vntKey
        lngKeyCount = lngKeyCount + 1
    End If
'## 2003.11.21 Add End
    
    '生年月日指定時は検索キー集合に追加
    If dtmBirth > 0 Then
    
'## 2003.11.21 Mod by T.Takagi@FSIT 複合検索はやめる
'        'キーが存在しなければ空の配列を作成
'        If IsEmpty(vntKey) Then
'            vntKey = Array()
'        End If
'
'        '後のIsBirth関数にてマッチするよう、配列に追加
'        ReDim Preserve vntKey(lngKeyCount)
'        vntKey(lngKeyCount) = PREFIX_BIRTH & Format(dtmBirth, "yyyy/mm/dd")
        ReDim Preserve vntArrKey(lngKeyCount)
        vntArrKey(lngKeyCount) = PREFIX_BIRTH & Format(dtmBirth, "yyyy/mm/dd")
'## 2003.11.21 Mod End
        lngKeyCount = lngKeyCount + 1
        
    End If
    
    '性別指定時は検索キー集合に追加
    If lngGender > 0 Then
    
'## 2003.11.21 Mod by T.Takagi@FSIT 複合検索はやめる
'        'キーが存在しなければ空の配列を作成
'        If IsEmpty(vntKey) Then
'            vntKey = Array()
'        End If
'
'        '後のIsGender関数にてマッチするよう、配列に追加
'        ReDim Preserve vntKey(lngKeyCount)
'        vntKey(lngKeyCount) = PREFIX_GENDER & IIf(lngGender = GENDER_MALE, "M", "F")
        ReDim Preserve vntArrKey(lngKeyCount)
        vntArrKey(lngKeyCount) = PREFIX_GENDER & IIf(lngGender = GENDER_MALE, "M", "F")
'## 2003.11.21 Mod End
        lngKeyCount = lngKeyCount + 1
        
    End If
    
'## 2003.11.21 Mod by T.Takagi@FSIT 複合検索はやめる
'    '引数指定時
'    If Not IsEmpty(vntKey) Then
'
'        '検索キー数分の条件節を追加
'        For i = 0 To UBound(vntKey)
'
'            strBuffer = vntKey(i)
'
'            '検索キーのタイプを判別し、条件節に変換して追加
'            Select Case True
'
'                Case IsWide(strBuffer)      '全角文字が含まれる(半角カナもここに含まれる)
'                    Call AppendCondition_Wide(vntCondition, strBuffer, i)
'
'                Case IsGender(strBuffer)    '性別
'                    Call AppendCondition_Gender(vntCondition, strBuffer, i)
'
'                Case IsPerId(strBuffer)     '個人ID
'                    Call AppendCondition_PerId(vntCondition, strBuffer, i)
'
'                Case IsBirth(strBuffer)     '生年月日
'                    Call AppendCondition_Birth(vntCondition, strBuffer, i)
'
'                Case Else                   '上記以外は個人IDとして検索
'                    Call AppendCondition_PerId(vntCondition, strBuffer, i)
'
'            End Select
'
'        Next i
'
'    End If

    '検索キー数分の条件節を追加
    For i = 0 To UBound(vntArrKey)

        strBuffer = vntArrKey(i)

        '検索キーのタイプを判別し、条件節に変換して追加
        Select Case True
        
            Case IsWide(strBuffer)      '全角文字が含まれる(半角カナもここに含まれる)
                Call AppendCondition_Wide(vntCondition, strBuffer, i)
        
            Case IsGender(strBuffer)    '性別
                Call AppendCondition_Gender(vntCondition, strBuffer, i)

            Case IsPerId(strBuffer)     '個人ID
                Call AppendCondition_PerId(vntCondition, strBuffer, i)

            Case IsBirth(strBuffer)     '生年月日
                Call AppendCondition_Birth(vntCondition, strBuffer, i)

            Case Else                   '上記以外はローマ字として検索
                Call AppendCondition_RomeName(vntCondition, strBuffer, i, blnRomeNameMultiple)
            
        End Select
        
    Next i
'## 2003.11.21 Mod End
    
    'すべての条件節をANDで連結
    If Not IsEmpty(vntCondition) Then
        CreateConditionForPersonList = "WHERE " & Join(vntCondition, " AND ")
    End If
    
End Function

'
' 機能　　 : 個人テーブルレコードを削除する
'
' 引数　　 : (In)     strPerID   個人ＩＤ
'
' 戻り値　 : 0   正常終了
' 　　　　   -1  アフターケア情報が存在
' 　　　　   -2  受診情報が存在
' 　　　　   -3  傷病休業情報が存在
' 　　　　   -4  個人就労情報が存在
'
' 備考　　 :
'
Public Function DeletePerson(ByVal strPerId As String) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    Dim Ret             As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strPerId) = "" Then
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '個人テーブルレコードの削除(削除フラグを立てる)
    strStmt = "DELETE PERSON WHERE PERID = :PERID"
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    DeletePerson = Ret
    
    Exit Function
    
ErrorHandle:

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    Do
    
        If mobjOraDb.LastServerErr = 2292 Then
            Select Case True
                Case InStr(mobjOraDb.LastServerErrText, "AFTERCARE") > 0
                    Ret = -1
                Case InStr(mobjOraDb.LastServerErrText, "CONSULT") > 0
                    Ret = -2
                Case InStr(mobjOraDb.LastServerErrText, "PERDISEASE") > 0
                    Ret = -3
                Case InStr(mobjOraDb.LastServerErrText, "PERWORKINFO") > 0
                    Ret = -4
                Case Else
                    Exit Do
            End Select
        End If
    
        DeletePerson = Ret
        Exit Function
    Loop
    
    'イベントログ書き込み
    WriteErrorLog "Person.DeletePerson"
    
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
' 機能　　 : 続柄テーブルレコードを削除する
'
' 引数　　 : (In)    strRelationCd    続柄コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteRelation(ByVal strRelationCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RelationCD", Trim(strRelationCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '続柄テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE Relation WHERE RELATIONCD = :RelationCD"
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteRelation = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    DeleteRelation = False

    'イベントログ書き込み
    WriteErrorLog "Person.DeleteRelation"
    
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
' 機能　　 : 指定の条件に該当する個人テーブル・個人詳細テーブルを読み込みCSVファイルを編集する
'
' 引数　　 : (In)   strFileName         CSVファイル名(物理パス)
' 　　　　 : (In)   strCase             抽出条件(指定期間の受診者:"csl"、郵便番号:"zip")
' 　　　　 : (In)   dtmStrDate          受診年月日(自)
' 　　　　 : (In)   strEndDate          受診年月日(至)
' 　　　　 : (In)   strCsCd             コースコード
' 　　　　 : (In)   strOrgCd1           団体コード1
' 　　　　 : (In)   strOrgCd2           団体コード2
' 　　　　 : (In)   strStrAge           受診時(自)年齢
' 　　　　 : (In)   strEndAge           受診時(至)年齢
' 　　　　 : (In)   lngGender           性別
' 　　　　 : (In)   strZipCd1           郵便番号1
' 　　　　 : (In)   strZipCd2           郵便番号2
'
' 戻り値　 : 編集したレコード件数
'
' 備考　　 : 性別、本人扶養区分、婚姻区分、保険区分は漢字名称に変換する
'
Public Function EditCSVDatPerson( _
    ByVal strFileName As String, _
    ByVal strCase As String, _
    ByVal dtmStrDate As Date, _
    ByVal dtmEndDate As Date, _
    ByVal strCsCd As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strStrAge As String, _
    ByVal strEndAge As String, _
    ByVal lngGender As Long, _
    ByVal strZipCd1 As String, _
    ByVal strZipCd2 As String _
) As Long

    Dim objCreateCsv    As Object           'CSVファイル作成用コンポーネント

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim Ret             As String           '戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    With objOraParam
        .Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
        .Add "ENDDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE
        .Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "STRAGE", strStrAge, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "ENDAGE", strEndAge, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "CANCELFLG", CONSULT_USED, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "GENDER", lngGender, ORAPARM_INPUT, ORATYPE_NUMBER
        .Add "ZIPCD1", strZipCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "ZIPCD2", strZipCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        .Add "DELFLG", DELFLG_USED, ORAPARM_INPUT, ORATYPE_NUMBER
    End With
    
    'SELECT句の編集
    strStmt = "SELECT DISTINCT                        " & vbLf & _
              "       PERSON.PERID      個人ＩＤ,     " & vbLf & _
              "       PERSON.VIDFLG     仮ＩＤフラグ, " & vbLf & _
              "       PERSON.LASTNAME   姓,           " & vbLf & _
              "       PERSON.FIRSTNAME  名,           " & vbLf & _
              "       PERSON.LASTKNAME  カナ姓,       " & vbLf & _
              "       PERSON.FIRSTKNAME カナ名,       " & vbLf & _
              "       PERSON.BIRTH      生年月日,     "

    strStmt = strStmt & vbLf & _
              "       DECODE(GENDER, '1', '男性', '2', '女性', NULL) 性別, "

    strStmt = strStmt & vbLf & _
              "       PERSON.ORGCD1     所属団体コード１, " & vbLf & _
              "       PERSON.ORGCD2     所属団体コード２, " & vbLf & _
              "       PERSON.ORGPOSTCD  所属部署コード,   " & vbLf & _
              "       PERSON.SUPPORTFLG 本人扶養区分,     " & vbLf & _
              "       PERSON.ISRNO      保険者番号,       " & vbLf & _
              "       PERSON.SPARE1     予備１,           " & vbLf & _
              "       PERSON.SPARE2     予備２,           " & vbLf & _
              "       PERSON.REPLICAFLG 複製フラグ,       " & vbLf & _
              "       PERSON.UPDDATE    更新日時,         " & vbLf & _
              "       PERSON.UPDUSER    更新者,           "

    strStmt = strStmt & vbLf & _
              "       PERSONDETAIL.TEL1       電話番号１市外局番, " & vbLf & _
              "       PERSONDETAIL.TEL2       電話番号１局番,     " & vbLf & _
              "       PERSONDETAIL.TEL3       電話番号１番号,     " & vbLf & _
              "       PERSONDETAIL.EXTENSION  内線１,             " & vbLf & _
              "       PERSONDETAIL.SUBTEL1    電話番号２市外局番, " & vbLf & _
              "       PERSONDETAIL.SUBTEL2    電話番号２局番,     " & vbLf & _
              "       PERSONDETAIL.SUBTEL3    電話番号２番号,     " & vbLf & _
              "       PERSONDETAIL.FAX1       ＦＡＸ市外局番,     " & vbLf & _
              "       PERSONDETAIL.FAX2       ＦＡＸ局番,         " & vbLf & _
              "       PERSONDETAIL.FAX3       ＦＡＸ番号,         " & vbLf & _
              "       PERSONDETAIL.PHONE1     携帯市外局番,       " & vbLf & _
              "       PERSONDETAIL.PHONE2     携帯局番,           " & vbLf & _
              "       PERSONDETAIL.PHONE3     携帯番号,           " & vbLf & _
              "       PERSONDETAIL.EMAIL      eMail,              "

    strStmt = strStmt & vbLf & _
              "       PERSONDETAIL.ZIPCD1     郵便番号１,       " & vbLf & _
              "       PERSONDETAIL.ZIPCD2     郵便番号２,       " & vbLf & _
              "       PERSONDETAIL.PREFCD     都道府県コード,   " & vbLf & _
              "       PERSONDETAIL.CITYNAME   市区町村名,       " & vbLf & _
              "       PERSONDETAIL.ADDRESS1   住所１,           " & vbLf & _
              "       PERSONDETAIL.ADDRESS2   住所２,           " & vbLf & _
              "       PERSONDETAIL.MARRIAGE   婚姻区分,         " & vbLf & _
              "       PERSONDETAIL.ISRSIGN    健保記号記号,     " & vbLf & _
              "       PERSONDETAIL.ISRMARK    健保記号符号,     " & vbLf & _
              "       PERSONDETAIL.HEISRNO    健保番号,         " & vbLf & _
              "       PERSONDETAIL.ISRDIV     保険区分,         " & vbLf & _
              "       PERSONDETAIL.RESIDENTNO 住民番号,         " & vbLf & _
              "       PERSONDETAIL.UNIONNO    組合番号,         " & vbLf & _
              "       PERSONDETAIL.KARTE      カルテ番号,       " & vbLf & _
              "       PERSONDETAIL.EMPNO      従業員番号,       " & vbLf & _
              "       PERSONDETAIL.NOTES      特記事項,         " & vbLf & _
              "       PERSONDETAIL.SPARE1     予備１,           " & vbLf & _
              "       PERSONDETAIL.SPARE2     予備２,           " & vbLf & _
              "       PERSONDETAIL.SPARE3     予備３,           " & vbLf & _
              "       PERSONDETAIL.SPARE4     予備４,           " & vbLf & _
              "       PERSONDETAIL.SPARE5     予備５            "
    
    '抽出条件区分毎のSQL文の編集
    Select Case Trim(strCase)
    
        '指定期間の受診者抽出
        Case MODE_CSL
        
            'FROM句の編集
            strStmt = strStmt & vbLf & _
                        "  FROM CONSULT, PERSON, PERSONDETAIL "
            
            'WHERE句の編集
            
            '受診日（期間）
            strStmt = strStmt & vbLf & _
                        " WHERE CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE "
                  
            'コースコード指定時
            If Trim(strCsCd) <> "" Then
                strStmt = strStmt & vbLf & _
                        "   AND CONSULT.CSCD = :CSCD "
            End If
            
            '団体コード指定時
            If Trim(strOrgCd1) <> "" Or Trim(strOrgCd2) <> "" Then
                strStmt = strStmt & vbLf & _
                        "   AND CONSULT.ORGCD1 = :ORGCD1 " & vbLf & _
                        "   AND CONSULT.ORGCD2 = :ORGCD2 "
            End If
        
            '受診時年齢（範囲）指定時
            If Trim(strStrAge) <> "" Or Trim(strEndAge) <> "" Then
                '年齢(自)省略時　受診時年齢(至)以下
                If Trim(strStrAge) = "" Then
                    strStmt = strStmt & vbLf & _
                        "   AND CONSULT.AGE <= :ENDAGE "
                '年齢(至)省略時　受診時年齢(自)以上
                ElseIf Trim(strEndAge) = "" Then
                    strStmt = strStmt & vbLf & _
                        "   AND CONSULT.AGE >= :STRAGE "
                '年齢指定時　受診時年齢(自)以上、受診時年齢(至)以下
                Else
                    strStmt = strStmt & vbLf & _
                        "   AND CONSULT.AGE BETWEEN :STRAGE AND :ENDAGE "
                End If
            End If
            
            'キャンセルフラグ(「使用中」)
            strStmt = strStmt & vbLf & _
                        "   AND CONSULT.CANCELFLG = :CANCELFLG "
        
            '性別指定時
            If lngGender = GENDER_MALE Or lngGender = GENDER_FEMALE Then
                strStmt = strStmt & vbLf & _
                        "   AND PERSON.GENDER  = :GENDER "
            End If
        
            strStmt = strStmt & vbLf & _
                        "   AND PERSON.DELFLG = :DELFLG               " & vbLf & _
                        "   AND CONSULT.PERID = PERSON.PERID          " & vbLf & _
                        "   AND PERSON.PERID  = PERSONDETAIL.PERID(+) " & vbLf & _
                        " ORDER BY PERSON.PERID                       "
        
        '指定郵便番号による抽出
        Case MODE_ZIP
        
            'FROM句の編集
            strStmt = strStmt & vbLf & _
                        "  FROM PERSON, PERSONDETAIL "
        
            'WHERE句の編集
            '郵便番号1欄(必須)
            strStmt = strStmt & vbLf & _
                        " WHERE PERSONDETAIL.ZIPCD1 = :ZIPCD1 "
        
            '郵便番号2欄指定時
            If Trim(strZipCd2) <> "" Then
                strStmt = strStmt & vbLf & _
                        "   AND PERSONDETAIL.ZIPCD2 = :ZIPCD2 "
            End If
        
            strStmt = strStmt & vbLf & _
                        "   AND PERSON.DELFLG = :DELFLG            " & vbLf & _
                        "   AND PERSON.PERID  = PERSONDETAIL.PERID " & vbLf & _
                        " ORDER BY PERSON.PERID                    "
    
    End Select
    
    '検索条件を満たす個人および個人属性テーブルのレコードを取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'ダイナセットからCSVファイルを作成
    Set objCreateCsv = CreateObject("HainsCreateCsv.CreateCsv")
    Ret = objCreateCsv.CreateCsvFileFromDynaset(objOraDyna, strFileName)

    '戻り値の設定
    If Ret <> "" Then
        EditCSVDatPerson = 1
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
    WriteErrorLog "Person.EditCSVDatPerson"
    
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
' 機能　　 : 発番すべき個人ＩＤ値の取得
'
' 引数　　 : (In)   lngVidFlg  仮ＩＤフラグ
'
' 戻り値　 : 個人ＩＤ
'
' 備考　　 :
'
Private Function GetPerId(ByVal lngVidFlg As Long) As String

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim strPrefix               As String           '接頭辞
    
    Dim strPerId                As String           '個人ＩＤ
    Dim strCurrentMaxPerId      As String           '現個人ＩＤの最大値
    Dim strCurrentMaxPerIdNum   As String           '現個人ＩＤの最大値における数字部
    
    Dim blnSuccess              As Boolean          '処理成功フラグ
    Dim i                       As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Do
        
        '個人ＩＤの最大値を取得するSQLステートメントの編集
        Select Case lngVidFlg
        
            Case 0  '実ＩＤ発番時
                
                '実ＩＤで先頭１桁目が"1"以上の個人ＩＤを最大順に取得(先頭１桁目が"0"はシステム導入時の移行データであるため、干渉を防ぐ)
                strStmt = "SELECT /*+ INDEX_DESC(PERSON PERSON_PKEY) */ PERID " & vbLf & _
                          "  FROM PERSON                                      " & vbLf & _
                          " WHERE PERID >= '" & RID_PREFIX & "'               " & vbLf & _
                          "   AND VIDFLG = 0                                  " & vbLf & _
                          "   AND ROWNUM = 1                                  " & vbLf & _
                          "   FOR UPDATE NOWAIT                               "
        
            Case 1  '仮ＩＤ発番時
        
                strStmt = "SELECT /*+ INDEX_DESC(PERSON PERSON_PKEY) */ PERID " & vbLf & _
                          "  FROM PERSON                                      " & vbLf & _
                          " WHERE PERID LIKE '" & VID_PREFIX & "%'            " & vbLf & _
                          "   AND VIDFLG = 1                                  " & vbLf & _
                          "   AND ROWNUM = 1                                  " & vbLf & _
                          "   FOR UPDATE NOWAIT                               "
        
            Case Else
                Err.Raise 1000, , "仮ＩＤフラグの値が無効です。"
            
        End Select
        
        '現仮IDの最大値を取得する(他で処理中の場合は最大10回までリトライ)
        For i = 1 To 10
        
            blnSuccess = True
            
            '現仮IDの最大値を取得する
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
            If blnSuccess Then
                Exit For
            End If
            
            'ちょっとだけ待つ
            Sleep 1000
            
        Next i

        '10回リトライしてもだめな場合は終了(発生しないとは思うが)
        If Not blnSuccess Then
            mobjOraDb.LastServerErrReset
            Err.Raise 1000, , "現在他業務にて個人情報を使用中のため、個人ＩＤ発番処理は行えませんでした。"
        End If
        
        '接頭辞の編集
        strPrefix = IIf(lngVidFlg = 0, RID_PREFIX, VID_PREFIX)
        
        'レコードが存在しない場合は初期値を発番
        If objOraDyna.EOF Then
            strPerId = strPrefix & String(LENGTH_PERSON_PERID - Len(strPrefix), "0")
            Exit Do
        End If
        
        '先頭レコードの個人ＩＤ（すなわち現在の最大値）を取得
        strCurrentMaxPerId = objOraDyna.Fields("PERID").Value

        '(発生しないと思うが)桁数フル使用されていない場合は桁埋め
        If Len(strCurrentMaxPerId) < LENGTH_PERSON_PERID Then
            strCurrentMaxPerId = Left(strCurrentMaxPerId & String(LENGTH_PERSON_PERID, "0"), LENGTH_PERSON_PERID)
        End If
        
        '数字部分を取得
        strCurrentMaxPerIdNum = IIf(lngVidFlg = 0, strCurrentMaxPerId, Right(strCurrentMaxPerId, LENGTH_PERSON_PERID - Len(VID_PREFIX)))
        
        '(発生しないと思うが)
        If strCurrentMaxPerIdNum = String(LENGTH_PERSON_PERID - IIf(lngVidFlg = 0, 0, Len(VID_PREFIX)), "9") Then
            Err.Raise 1000, , "これ以上個人ＩＤは発番できません。"
        End If

        '(発生しないと思うが)
        If Not IsNumeric(strCurrentMaxPerIdNum) Then
            Err.Raise 1000, , "個人ＩＤは発番できません。"
        End If

        '数字部分をインクリメントしつつ新仮ＩＤを求める
        Select Case lngVidFlg
            Case 0
                strPerId = Format(CDbl(strCurrentMaxPerIdNum) + 1, String(LENGTH_PERSON_PERID, "0"))
            Case 1
                strPerId = VID_PREFIX & Format(CDbl(strCurrentMaxPerIdNum) + 1, String(LENGTH_PERSON_PERID - Len(VID_PREFIX), "0"))
        End Select
        
        Exit Do
    Loop
    
    '戻り値の設定
    GetPerId = strPerId
    
    Exit Function
    
ErrorHandle:

    'リソースビジーの場合は成功フラグをリセットして復帰
    If mobjOraDb.LastServerErr = 54 Then
        blnSuccess = False
        Resume Next
    End If

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'イベントログ書き込み
    WriteErrorLog "Person.GetPerId"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人テーブルにレコードを挿入する
'
' 引数　　 : (In/Out) vntPerId           個人ＩＤ
' 　　　　   (In)     lngVidFlg          仮ＩＤフラグ
' 　　　　   (In)     lngDelFlg          削除フラグ
' 　　　　   (In)     lngTransferDiv     出向区分
' 　　　　   (In)     lngReplicaFlg      複製フラグ
' 　　　　   (In)     strLastName        更新者
' 　　　　   (In)     strFirstName       姓
' 　　　　   (In)     strLastKName       名
' 　　　　   (In)     strFirstKName      カナ姓
' 　　　　   (In)     dtmBirth           カナ名
' 　　　　   (In)     lngGender          生年月日
' 　　　　   (In)     strUpdUser         性別
' 　　　　   (In)     strOrgCd1          所属団体コード１
' 　　　　   (In)     strOrgCd2          所属団体コード２
' 　　　　   (In)     strOrgBsdCd        事業部コード
' 　　　　   (In)     strOrgRoomCd       室部コード
' 　　　　   (In)     strOrgPostCd       所属部署コード
' 　　　　   (In)     strJobCd           職名コード
' 　　　　   (In)     strDutyCd          職責コード
' 　　　　   (In)     strQualifyCd       資格コード
' 　　　　   (In)     strIsrSign         健保記号
' 　　　　   (In)     strIsrNo           健保番号
' 　　　　   (In)     strRelationCd      続柄コード
' 　　　　   (In)     strBranchNo        枝番
' 　　　　   (In)     strEmpNo           従業員番号
' 　　　　   (In)     strPrimPerId       親個人ＩＤ
' 　　　　   (In)     dtmLostDate        資格喪失日
' 　　　　   (In)     dtmHireDate        入社年月日
' 　　　　   (In)     strEmpDiv          従業員区分
' 　　　　   (In)     strHongenDiv       本現区分
' 　　　　   (In)     strWorkMeasureDiv  就業措置区分
' 　　　　   (In)     lngOverTimeDiv     超過勤務区分
' 　　　　   (In)     strNightDutyFlg    夜勤者健診対象
' 　　　　   (In)     strSpare1          予備１
' 　　　　   (In)     strSpare2          予備２
'
' 戻り値　 : 1    正常終了
' 　　　　   0    同一個人ＩＤのレコードが存在
' 　　　　   -1   同一団体・従業員番号のレコードが存在
' 　　　　   -2   同一健保・続柄・枝番のレコードが存在
'            -3   ユーザ情報が存在しない
'            -4   所属情報が存在しない
'            -5   続柄が存在しない
'            -6   親個人ＩＤが存在しない
'            -7   職名情報が存在しない
'            -8   職責情報が存在しない
'            -9   資格情報が存在しない
'            -10  就業措置区分が存在しない
'
' 備考　　 :
'
Public Function InsertPerson( _
    ByRef vntPerId As Variant, _
    ByVal lngVidFlg As Long, ByVal lngDelFlg As Long, _
    ByVal lngTransferDiv As Long, ByVal lngReplicaFlg As Long, _
    ByVal strLastName As String, ByVal strFirstName As String, _
    ByVal strLastKName As String, ByVal strFirstKName As String, _
    ByVal dtmBirth As Date, ByVal lngGender As Long, _
    Optional ByVal strUpdUser As String = "", _
    Optional ByVal strOrgCd1 As String = "", Optional ByVal strOrgCd2 As String = "", _
    Optional ByVal strOrgBsdCd As String = "", Optional ByVal strOrgRoomCd As String = "", _
    Optional ByVal strOrgPostCd As String = "", Optional ByVal strJobCd As String = "", _
    Optional ByVal strDutyCd As String = "", Optional ByVal strQualifyCd As String = "", _
    Optional ByVal strIsrSign As String = "", Optional ByVal strIsrNo As String = "", _
    Optional ByVal strRelationCd As String = "", Optional ByVal strBranchNo As String = "", _
    Optional ByVal strEmpNo As String = "", Optional ByVal strPrimPerId As String = "", _
    Optional ByVal dtmLostDate As Date = 0, Optional ByVal dtmHireDate As Date = 0, _
    Optional ByVal strEmpDiv As String = "", Optional ByVal strHongenDiv As String = "", _
    Optional ByVal strWorkMeasureDiv As String = "", Optional ByVal lngOverTimeDiv As Long = 0, _
    Optional ByVal strNightDutyFlg As String = "", _
    Optional ByVal strSpare1 As String = "", Optional ByVal strSpare2 As String = "" _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim strPerId    As String           '個人ＩＤ
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '個人ID未指定時は発番処理を行う
    If vntPerId = "" Then
        strPerId = GetPerId(lngVidFlg)
    Else
        strPerId = vntPerId
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "VIDFLG", lngVidFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DELFLG", lngDelFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TRANSFERDIV", lngTransferDiv, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPLICAFLG", lngReplicaFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LASTNAME", strLastName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FIRSTNAME", strFirstName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LASTKNAME", strLastKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FIRSTKNAME", strFirstKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BIRTH", dtmBirth, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "GENDER", lngGender, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGBSDCD", strOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGROOMCD", strOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGPOSTCD", strOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "JOBCD", strJobCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DUTYCD", strDutyCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "QUALIFYCD", strQualifyCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRSIGN", strIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRNO", strIsrNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RELATIONCD", strRelationCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BRANCHNO", strBranchNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMPNO", strEmpNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PRIMPERID", strPrimPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LOSTDATE", IIf(dtmLostDate > 0, dtmLostDate, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "HIREDATE", IIf(dtmHireDate > 0, dtmHireDate, Null), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "EMPDIV", strEmpDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "HONGENDIV", strHongenDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "WORKMEASUREDIV", strWorkMeasureDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "OVERTIMEDIV", lngOverTimeDiv, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "NIGHTDUTYFLG", strNightDutyFlg, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SPARE1", strSpare1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SPARE2", strSpare2, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '個人テーブルレコードの挿入
    strStmt = "INSERT INTO PERSON (         " & vbLf & _
              "                PERID,       " & vbLf & _
              "                VIDFLG,      " & vbLf & _
              "                DELFLG,      " & vbLf & _
              "                TRANSFERDIV, " & vbLf & _
              "                REPLICAFLG,  " & vbLf & _
              "                LASTNAME,    " & vbLf & _
              "                FIRSTNAME,   " & vbLf & _
              "                LASTKNAME,   " & vbLf & _
              "                FIRSTKNAME,  " & vbLf & _
              "                BIRTH,       " & vbLf & _
              "                GENDER,      " & vbLf & _
              "                UPDUSER,     " & vbLf & _
              "                ORGCD1,      " & vbLf & _
              "                ORGCD2,      " & vbLf & _
              "                ORGBSDCD,    " & vbLf & _
              "                ORGROOMCD,   " & vbLf & _
              "                ORGPOSTCD,   "

    strStmt = strStmt & vbLf & _
              "                JOBCD,          " & vbLf & _
              "                DUTYCD,         " & vbLf & _
              "                QUALIFYCD,      " & vbLf & _
              "                ISRSIGN,        " & vbLf & _
              "                ISRNO,          " & vbLf & _
              "                RELATIONCD,     " & vbLf & _
              "                BRANCHNO,       " & vbLf & _
              "                EMPNO,          " & vbLf & _
              "                PRIMPERID,      " & vbLf & _
              "                LOSTDATE,       " & vbLf & _
              "                HIREDATE,       " & vbLf & _
              "                EMPDIV,         " & vbLf & _
              "                HONGENDIV,      " & vbLf & _
              "                WORKMEASUREDIV, " & vbLf & _
              "                OVERTIMEDIV,    " & vbLf & _
              "                NIGHTDUTYFLG,   " & vbLf & _
              "                SPARE1,         " & vbLf & _
              "                SPARE2          "

    strStmt = strStmt & vbLf & _
              "            ) VALUES (        " & vbLf & _
              "                :PERID,       " & vbLf & _
              "                :VIDFLG,      " & vbLf & _
              "                :DELFLG,      " & vbLf & _
              "                :TRANSFERDIV, " & vbLf & _
              "                :REPLICAFLG,  " & vbLf & _
              "                TO_EDIT_ZENKAKU(:LASTNAME),   " & vbLf & _
              "                TO_EDIT_ZENKAKU(:FIRSTNAME),  " & vbLf & _
              "                TO_EDIT_ZENKAKU(:LASTKNAME),  " & vbLf & _
              "                TO_EDIT_ZENKAKU(:FIRSTKNAME), " & vbLf & _
              "                :BIRTH,       " & vbLf & _
              "                :GENDER,      " & vbLf & _
              "                :UPDUSER,     " & vbLf & _
              "                :ORGCD1,      " & vbLf & _
              "                :ORGCD2,      " & vbLf & _
              "                :ORGBSDCD,    " & vbLf & _
              "                :ORGROOMCD,   " & vbLf & _
              "                :ORGPOSTCD,   "

    strStmt = strStmt & vbLf & _
              "                :JOBCD,          " & vbLf & _
              "                :DUTYCD,         " & vbLf & _
              "                :QUALIFYCD,      " & vbLf & _
              "                :ISRSIGN,        " & vbLf & _
              "                :ISRNO,          " & vbLf & _
              "                :RELATIONCD,     " & vbLf & _
              "                :BRANCHNO,       " & vbLf & _
              "                :EMPNO,          " & vbLf & _
              "                :PRIMPERID,      " & vbLf & _
              "                :LOSTDATE,       " & vbLf & _
              "                :HIREDATE,       " & vbLf & _
              "                :EMPDIV,         " & vbLf & _
              "                :HONGENDIV,      " & vbLf & _
              "                :WORKMEASUREDIV, " & vbLf & _
              "                :OVERTIMEDIV,    " & vbLf & _
              "                :NIGHTDUTYFLG,   " & vbLf & _
              "                :SPARE1,         " & vbLf & _
              "                :SPARE2          " & vbLf & _
              "            )                    "
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の設定
    vntPerId = strPerId
    
    InsertPerson = 1

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
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
    
    Do
    
        Select Case mobjOraDb.LastServerErr
            
            'キー重複時
            Case 1
        
                Select Case True
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_PKEY") > 0
                        Ret = 0
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_INDEX1") > 0
                        Ret = -1
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_INDEX2") > 0
                        Ret = -2
                    Case Else
                        Exit Do
                End Select
    
            '外部キーエラー時
            Case 2291
        
                Select Case True
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY1") > 0
                        Ret = -3
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY2") > 0
                        Ret = -4
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY3") > 0
                        Ret = -5
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY4") > 0
                        Ret = -6
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY5") > 0
                        Ret = -7
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY6") > 0
                        Ret = -8
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY7") > 0
                        Ret = -9
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY8") > 0
                        Ret = -10
                    Case Else
                        Exit Do
                End Select
    
            Case Else
                Exit Do
        
        End Select

        InsertPerson = Ret
        Exit Function
    Loop

    InsertPerson = -99

    'イベントログ書き込み
    WriteErrorLog "Person.InsertPerson"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人テーブルにレコードを挿入する  ## 聖路加バージョン ##
'
' 引数　　 : (In/Out) vntPerId           個人ＩＤ
' 　　　　   (In)     lngVidFlg          仮ＩＤフラグ
' 　　　　   (In)     lngDelFlg          削除フラグ
' 　　　　   (In)     lngTransferDiv     出向区分
' 　　　　   (In)     lngReplicaFlg      複製フラグ
' 　　　　   (In)     strLastName        姓
' 　　　　   (In)     strFirstName       名
' 　　　　   (In)     strLastKName       カナ姓
' 　　　　   (In)     strFirstKName      カナ名
' 　　　　   (In)     strRomeName        ローマ字名
' 　　　　   (In)     dtmBirth           生年月日
' 　　　　   (In)     lngGender          性別
' 　　　　   (In)     strUpdUser         更新者
' 　　　　   (In)     strOrgCd1          所属団体コード１
' 　　　　   (In)     strOrgCd2          所属団体コード２
' 　　　　   (In)     strOrgBsdCd        事業部コード
' 　　　　   (In)     strOrgRoomCd       室部コード
' 　　　　   (In)     strOrgPostCd       所属部署コード
' 　　　　   (In)     strJobCd           職名コード
' 　　　　   (In)     strDutyCd          職責コード
' 　　　　   (In)     strQualifyCd       資格コード
' 　　　　   (In)     strIsrSign         健保記号
' 　　　　   (In)     strIsrNo           健保番号
' 　　　　   (In)     strRelationCd      続柄コード
' 　　　　   (In)     strBranchNo        枝番
' 　　　　   (In)     strEmpNo           従業員番号
' 　　　　   (In)     strPrimPerId       親個人ＩＤ
' 　　　　   (In)     dtmLostDate        資格喪失日
' 　　　　   (In)     dtmHireDate        入社年月日
' 　　　　   (In)     strEmpDiv          従業員区分
' 　　　　   (In)     strHongenDiv       本現区分
' 　　　　   (In)     strWorkMeasureDiv  就業措置区分
' 　　　　   (In)     lngOverTimeDiv     超過勤務区分
' 　　　　   (In)     strNightDutyFlg    夜勤者健診対象
' 　　　　   (In)     strSpare1          予備１
' 　　　　   (In)     strSpare2          予備２
' 　　　　   (In)     strPostCardAddr    １年目はがき宛先
' 　　　　   (In)     strMaidenName      旧姓
' 　　　　   (In)     strNationCd        国籍コード
' 　　　　   (In)     strCompPerId       同伴者ＩＤ
'
' 戻り値　 : 1    正常終了
' 　　　　   0    同一個人ＩＤのレコードが存在
'            -3   ユーザ情報が存在しない
'            -4   国籍情報が存在しない
'            -5   同伴者個人情報が存在しない
'
' 備考　　 :
'
'### 2004/1/30 Modified by Ishihara@FSIT １年目はがきあて先にはNULLがあるんですけど。しかもCHECK制約があるのに引数で0セット。もう嫌っす。
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
Public Function InsertPerson_lukes( _
    ByRef vntPerId As Variant, _
    ByVal lngVidFlg As Long, ByVal lngDelFlg As Long, _
    ByVal lngTransferDiv As Long, ByVal lngReplicaFlg As Long, _
    ByVal strLastName As String, ByVal strFirstName As String, _
    ByVal strLastKName As String, ByVal strFirstKName As String, _
    ByVal strRomeName As String, _
    ByVal dtmBirth As Date, ByVal lngGender As Long, _
    Optional ByVal strUpdUser As String = "", _
    Optional ByVal strOrgCd1 As String = "", Optional ByVal strOrgCd2 As String = "", _
    Optional ByVal strOrgBsdCd As String = "", Optional ByVal strOrgRoomCd As String = "", _
    Optional ByVal strOrgPostCd As String = "", Optional ByVal strJobCd As String = "", _
    Optional ByVal strDutyCd As String = "", Optional ByVal strQualifyCd As String = "", _
    Optional ByVal strIsrSign As String = "", Optional ByVal strIsrNo As String = "", _
    Optional ByVal strRelationCd As String = "", Optional ByVal strBranchNo As String = "", _
    Optional ByVal strEmpNo As String = "", Optional ByVal strPrimPerId As String = "", _
    Optional ByVal dtmLostDate As Date = 0, Optional ByVal dtmHireDate As Date = 0, _
    Optional ByVal strEmpDiv As String = "", Optional ByVal strHongenDiv As String = "", _
    Optional ByVal strWorkMeasureDiv As String = "", Optional ByVal lngOverTimeDiv As Long = 0, _
    Optional ByVal strNightDutyFlg As String = "", _
    Optional ByVal strSpare1 As String = "", Optional ByVal strSpare2 As String = "", _
    Optional ByVal strPostCardAddr As String = "", Optional ByVal strMaidenName As String = "", _
    Optional ByVal strNationCd As String = "", Optional ByVal strCompPerId As String = "", _
    Optional ByVal strCslCount As String = "" _
) As Long
'Public Function InsertPerson_lukes( _
'    ByRef vntPerId As Variant, _
'    ByVal lngVidFlg As Long, ByVal lngDelFlg As Long, _
'    ByVal lngTransferDiv As Long, ByVal lngReplicaFlg As Long, _
'    ByVal strLastName As String, ByVal strFirstName As String, _
'    ByVal strLastKName As String, ByVal strFirstKName As String, _
'    ByVal strRomeName As String, _
'    ByVal dtmBirth As Date, ByVal lngGender As Long, _
'    Optional ByVal strUpdUser As String = "", _
'    Optional ByVal strOrgCd1 As String = "", Optional ByVal strOrgCd2 As String = "", _
'    Optional ByVal strOrgBsdCd As String = "", Optional ByVal strOrgRoomCd As String = "", _
'    Optional ByVal strOrgPostCd As String = "", Optional ByVal strJobCd As String = "", _
'    Optional ByVal strDutyCd As String = "", Optional ByVal strQualifyCd As String = "", _
'    Optional ByVal strIsrSign As String = "", Optional ByVal strIsrNo As String = "", _
'    Optional ByVal strRelationCd As String = "", Optional ByVal strBranchNo As String = "", _
'    Optional ByVal strEmpNo As String = "", Optional ByVal strPrimPerId As String = "", _
'    Optional ByVal dtmLostDate As Date = 0, Optional ByVal dtmHireDate As Date = 0, _
'    Optional ByVal strEmpDiv As String = "", Optional ByVal strHongenDiv As String = "", _
'    Optional ByVal strWorkMeasureDiv As String = "", Optional ByVal lngOverTimeDiv As Long = 0, _
'    Optional ByVal strNightDutyFlg As String = "", _
'    Optional ByVal strSpare1 As String = "", Optional ByVal strSpare2 As String = "", _
'    Optional ByVal strPostCardAddr As String = "", Optional ByVal strMaidenName As String = "", _
'    Optional ByVal strNationCd As String = "", Optional ByVal strCompPerId As String = "" _
) As Long
'## 2004.02.10 Mod End
'Public Function InsertPerson_lukes( _
    ByRef vntPerId As Variant, _
    ByVal lngVidFlg As Long, ByVal lngDelFlg As Long, _
    ByVal lngTransferDiv As Long, ByVal lngReplicaFlg As Long, _
    ByVal strLastName As String, ByVal strFirstName As String, _
    ByVal strLastKName As String, ByVal strFirstKName As String, _
    ByVal strRomeName As String, _
    ByVal dtmBirth As Date, ByVal lngGender As Long, _
    Optional ByVal strUpdUser As String = "", _
    Optional ByVal strOrgCd1 As String = "", Optional ByVal strOrgCd2 As String = "", _
    Optional ByVal strOrgBsdCd As String = "", Optional ByVal strOrgRoomCd As String = "", _
    Optional ByVal strOrgPostCd As String = "", Optional ByVal strJobCd As String = "", _
    Optional ByVal strDutyCd As String = "", Optional ByVal strQualifyCd As String = "", _
    Optional ByVal strIsrSign As String = "", Optional ByVal strIsrNo As String = "", _
    Optional ByVal strRelationCd As String = "", Optional ByVal strBranchNo As String = "", _
    Optional ByVal strEmpNo As String = "", Optional ByVal strPrimPerId As String = "", _
    Optional ByVal dtmLostDate As Date = 0, Optional ByVal dtmHireDate As Date = 0, _
    Optional ByVal strEmpDiv As String = "", Optional ByVal strHongenDiv As String = "", _
    Optional ByVal strWorkMeasureDiv As String = "", Optional ByVal lngOverTimeDiv As Long = 0, _
    Optional ByVal strNightDutyFlg As String = "", _
    Optional ByVal strSpare1 As String = "", Optional ByVal strSpare2 As String = "", _
    Optional ByVal strPostCardAddr As Long = 0, Optional ByVal strMaidenName As String = "", _
    Optional ByVal strNationCd As String = "", Optional ByVal strCompPerId As String = "" _
) As Long
'### 2004/1/30 Modified End

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    

    Dim strPerId                As String           '個人ＩＤ
    Dim Ret                     As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '個人ID未指定時は発番処理を行う
    If vntPerId = "" Then
        strPerId = GetPerId(lngVidFlg)
    Else
        strPerId = vntPerId
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "VIDFLG", lngVidFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DELFLG", lngDelFlg, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    objOraParam.Add "TRANSFERDIV", lngTransferDiv, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "REPLICAFLG", lngReplicaFlg, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.11.18 Del End
'## 2003.12.17 Mod by T.Takagi@FSIT 変換方法を変更
'    objOraParam.Add "LASTNAME", strLastName, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "FIRSTNAME", strFirstName, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "LASTKNAME", strLastKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "FIRSTKNAME", strFirstKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LASTNAME", StrConv(strLastName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FIRSTNAME", StrConv(strFirstName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "LASTKNAME", StrConv(strLastKName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FIRSTKNAME", StrConv(strFirstKName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
    objOraParam.Add "ROMENAME", UCase(strRomeName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BIRTH", dtmBirth, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "GENDER", lngGender, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "ORGBSDCD", strOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "ORGROOMCD", strOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "ORGPOSTCD", strOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "JOBCD", strJobCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "DUTYCD", strDutyCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "QUALIFYCD", strQualifyCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "ISRSIGN", strIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "ISRNO", strIsrNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "RELATIONCD", strRelationCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "BRANCHNO", strBranchNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "EMPNO", strEmpNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "PRIMPERID", strPrimPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "LOSTDATE", IIf(dtmLostDate > 0, dtmLostDate, Null), ORAPARM_INPUT, ORATYPE_DATE
'    objOraParam.Add "HIREDATE", IIf(dtmHireDate > 0, dtmHireDate, Null), ORAPARM_INPUT, ORATYPE_DATE
'    objOraParam.Add "EMPDIV", strEmpDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "HONGENDIV", strHongenDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "WORKMEASUREDIV", strWorkMeasureDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "OVERTIMEDIV", lngOverTimeDiv, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "NIGHTDUTYFLG", strNightDutyFlg, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.11.18 Del End
    objOraParam.Add "SPARE1", strSpare1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SPARE2", strSpare2, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004/1/30 Modified by Ishihara@FSIT １年目はがきあて先にはNULLがあるんですけど。しかもCHECK制約があるのに引数で0セット。もう嫌っす。
'    objOraParam.Add "POSTCARDADDR", strPostCardAddr, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "POSTCARDADDR", Trim(strPostCardAddr), ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004/1/30 Modified End
    objOraParam.Add "MAIDENNAME", strMaidenName, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "NATIONCD", strNationCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "COMPPERID", strCompPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
    objOraParam.Add "CSLCOUNT", IIf(strCslCount <> "", CLng("0" & strCslCount), Null), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2004.02.10 Add End

    '個人テーブルレコードの挿入
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strStmt = "INSERT INTO PERSON (         " & vbLf & _
'              "                PERID,       " & vbLf & _
'              "                VIDFLG,      " & vbLf & _
'              "                DELFLG,      " & vbLf & _
'              "                TRANSFERDIV, " & vbLf & _
'              "                REPLICAFLG,  " & vbLf & _
'              "                LASTNAME,    " & vbLf & _
'              "                FIRSTNAME,   " & vbLf & _
'              "                LASTKNAME,   " & vbLf & _
'              "                FIRSTKNAME,  " & vbLf & _
'              "                ROMENAME,    " & vbLf & _
'              "                BIRTH,       " & vbLf & _
'              "                GENDER,      " & vbLf & _
'              "                UPDUSER,     " & vbLf & _
'              "                ORGCD1,      " & vbLf & _
'              "                ORGCD2,      " & vbLf & _
'              "                ORGBSDCD,    " & vbLf & _
'              "                ORGROOMCD,   " & vbLf & _
'              "                ORGPOSTCD,   "
'
'    strStmt = strStmt & vbLf & _
'              "                JOBCD,          " & vbLf & _
'              "                DUTYCD,         " & vbLf & _
'              "                QUALIFYCD,      " & vbLf & _
'              "                ISRSIGN,        " & vbLf & _
'              "                ISRNO,          " & vbLf & _
'              "                RELATIONCD,     " & vbLf & _
'              "                BRANCHNO,       " & vbLf & _
'              "                EMPNO,          " & vbLf & _
'              "                PRIMPERID,      " & vbLf & _
'              "                LOSTDATE,       " & vbLf & _
'              "                HIREDATE,       " & vbLf & _
'              "                EMPDIV,         " & vbLf & _
'              "                HONGENDIV,      " & vbLf & _
'              "                WORKMEASUREDIV, " & vbLf & _
'              "                OVERTIMEDIV,    " & vbLf & _
'              "                NIGHTDUTYFLG,   " & vbLf & _
'              "                SPARE1,         " & vbLf & _
'              "                SPARE2,         " & vbLf & _
'              "                POSTCARDADDR,   " & vbLf & _
'              "                MAIDENNAME,     " & vbLf & _
'              "                NATIONCD,       " & vbLf & _
'              "                COMPPERID       "
'    strStmt = strStmt & vbLf & _
'              "            ) VALUES (        " & vbLf & _
'              "                :PERID,       " & vbLf & _
'              "                :VIDFLG,      " & vbLf & _
'              "                :DELFLG,      " & vbLf & _
'              "                :TRANSFERDIV, " & vbLf & _
'              "                :REPLICAFLG,  " & vbLf & _
'              "                TO_EDIT_ZENKAKU(:LASTNAME),   " & vbLf & _
'              "                TO_EDIT_ZENKAKU(:FIRSTNAME),  " & vbLf & _
'              "                TO_EDIT_ZENKAKU(:LASTKNAME),  " & vbLf & _
'              "                TO_EDIT_ZENKAKU(:FIRSTKNAME), " & vbLf & _
'              "                :ROMENAME,    " & vbLf & _
'              "                :BIRTH,       " & vbLf & _
'              "                :GENDER,      " & vbLf & _
'              "                :UPDUSER,     " & vbLf & _
'              "                :ORGCD1,      " & vbLf & _
'              "                :ORGCD2,      " & vbLf & _
'              "                :ORGBSDCD,    " & vbLf & _
'              "                :ORGROOMCD,   " & vbLf & _
'              "                :ORGPOSTCD,   "
'
'    strStmt = strStmt & vbLf & _
'              "                :JOBCD,          " & vbLf & _
'              "                :DUTYCD,         " & vbLf & _
'              "                :QUALIFYCD,      " & vbLf & _
'              "                :ISRSIGN,        " & vbLf & _
'              "                :ISRNO,          " & vbLf & _
'              "                :RELATIONCD,     " & vbLf & _
'              "                :BRANCHNO,       " & vbLf & _
'              "                :EMPNO,          " & vbLf & _
'              "                :PRIMPERID,      " & vbLf & _
'              "                :LOSTDATE,       " & vbLf & _
'              "                :HIREDATE,       " & vbLf & _
'              "                :EMPDIV,         " & vbLf & _
'              "                :HONGENDIV,      " & vbLf & _
'              "                :WORKMEASUREDIV, " & vbLf & _
'              "                :OVERTIMEDIV,    " & vbLf & _
'              "                :NIGHTDUTYFLG,   " & vbLf & _
'              "                :SPARE1,         " & vbLf & _
'              "                :SPARE2,         " & vbLf & _
'              "                :POSTCARDADDR,   " & vbLf & _
'              "                :MAIDENNAME,     " & vbLf & _
'              "                :NATIONCD,       " & vbLf & _
'              "                :COMPPERID       " & vbLf & _
'              "            )                    "
    strStmt = "INSERT INTO PERSON (          " & vbLf & _
              "                PERID,        " & vbLf & _
              "                VIDFLG,       " & vbLf & _
              "                DELFLG,       " & vbLf & _
              "                LASTNAME,     " & vbLf & _
              "                FIRSTNAME,    " & vbLf & _
              "                LASTKNAME,    " & vbLf & _
              "                FIRSTKNAME,   " & vbLf & _
              "                ROMENAME,     " & vbLf & _
              "                BIRTH,        " & vbLf & _
              "                GENDER,       " & vbLf & _
              "                UPDUSER,      " & vbLf & _
              "                SPARE1,       " & vbLf & _
              "                SPARE2,       " & vbLf & _
              "                POSTCARDADDR, " & vbLf & _
              "                MAIDENNAME,   " & vbLf & _
              "                NATIONCD,     " & vbLf & _
              "                COMPPERID     "
'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "                CSLCOUNT      "
'## 2004.02.10 Add End
'## 2003.12.17 Mod by T.Takagi@FSIT 変換方法を変更
'    strStmt = strStmt & vbLf & _
'              "            ) VALUES (                        " & vbLf & _
'              "                :PERID,                       " & vbLf & _
'              "                :VIDFLG,                      " & vbLf & _
'              "                :DELFLG,                      " & vbLf & _
'              "                TO_EDIT_ZENKAKU(:LASTNAME),   " & vbLf & _
'              "                TO_EDIT_ZENKAKU(:FIRSTNAME),  " & vbLf & _
'              "                TO_EDIT_ZENKAKU(:LASTKNAME),  " & vbLf & _
'              "                TO_EDIT_ZENKAKU(:FIRSTKNAME), " & vbLf & _
'              "                :ROMENAME,                    " & vbLf & _
'              "                :BIRTH,                       " & vbLf & _
'              "                :GENDER,                      " & vbLf & _
'              "                :UPDUSER,                     " & vbLf & _
'              "                :SPARE1,                      " & vbLf & _
'              "                :SPARE2,                      " & vbLf & _
'              "                :POSTCARDADDR,                " & vbLf & _
'              "                :MAIDENNAME,                  " & vbLf & _
'              "                :NATIONCD,                    " & vbLf & _
'              "                :COMPPERID                    " & vbLf & _
'              "            )                                 "
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
'    strStmt = strStmt & vbLf & _
'              "            ) VALUES (         " & vbLf & _
'              "                :PERID,        " & vbLf & _
'              "                :VIDFLG,       " & vbLf & _
'              "                :DELFLG,       " & vbLf & _
'              "                :LASTNAME,     " & vbLf & _
'              "                :FIRSTNAME,    " & vbLf & _
'              "                :LASTKNAME,    " & vbLf & _
'              "                :FIRSTKNAME,   " & vbLf & _
'              "                :ROMENAME,     " & vbLf & _
'              "                :BIRTH,        " & vbLf & _
'              "                :GENDER,       " & vbLf & _
'              "                :UPDUSER,      " & vbLf & _
'              "                :SPARE1,       " & vbLf & _
'              "                :SPARE2,       " & vbLf & _
'              "                :POSTCARDADDR, " & vbLf & _
'              "                :MAIDENNAME,   " & vbLf & _
'              "                :NATIONCD,     " & vbLf & _
'              "                :COMPPERID     " & vbLf & _
'              "            )                  "
    strStmt = strStmt & vbLf & _
              "            ) VALUES (         " & vbLf & _
              "                :PERID,        " & vbLf & _
              "                :VIDFLG,       " & vbLf & _
              "                :DELFLG,       " & vbLf & _
              "                :LASTNAME,     " & vbLf & _
              "                :FIRSTNAME,    " & vbLf & _
              "                :LASTKNAME,    " & vbLf & _
              "                :FIRSTKNAME,   " & vbLf & _
              "                :ROMENAME,     " & vbLf & _
              "                :BIRTH,        " & vbLf & _
              "                :GENDER,       " & vbLf & _
              "                :UPDUSER,      " & vbLf & _
              "                :SPARE1,       " & vbLf & _
              "                :SPARE2,       " & vbLf & _
              "                :POSTCARDADDR, " & vbLf & _
              "                :MAIDENNAME,   " & vbLf & _
              "                :NATIONCD,     " & vbLf & _
              "                :COMPPERID,    " & vbLf & _
              "                :CSLCOUNT      " & vbLf & _
              "            )                  "
'## 2004.02.10 Mod End
'## 2003.12.17 Mod End
'## 2003.11.18 Mod End
              
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の設定
    vntPerId = strPerId
    
    InsertPerson_lukes = 1

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
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
    
    Do
    
        Select Case mobjOraDb.LastServerErr
            
            'キー重複時
            Case 1
        
                Select Case True
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_PKEY") > 0
                        Ret = 0
'## 2003.12.16 Del By T.Takagi@FSIT
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_INDEX1") > 0
'                        Ret = -1
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_INDEX2") > 0
'                        Ret = -2
'## 2003.12.16 Del End
                    Case Else
                        Exit Do
                End Select
    
            '外部キーエラー時
            Case 2291
        
                Select Case True
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY1") > 0
                        Ret = -3
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY2") > 0
                        Ret = -4
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY3") > 0
                        Ret = -5
'## 2003.12.16 Del By T.Takagi@FSIT
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY4") > 0
'                        Ret = -6
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY5") > 0
'                        Ret = -7
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY6") > 0
'                        Ret = -8
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY7") > 0
'                        Ret = -9
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY8") > 0
'                        Ret = -10
'## 2003.12.16 Del End
                    Case Else
                        Exit Do
                End Select
    
            Case Else
                Exit Do
        
        End Select

        InsertPerson_lukes = Ret
        Exit Function
    Loop

    InsertPerson_lukes = -99

    'イベントログ書き込み
    WriteErrorLog "Person.InsertPerson_lukes"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 検索キーが生年月日指定かをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Public Function IsBirth(ByVal strBuffer As String) As Boolean

    Dim strBirth    As String   '生年月日
    Dim Ret         As Boolean  '関数戻り値
    Dim i           As Long     'インデックス
    
    Ret = False
    
    '先頭６文字が"BIRTH:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_BIRTH))) = PREFIX_BIRTH Then
        strBirth = Right(strBuffer, Len(strBuffer) - Len(PREFIX_BIRTH))
    Else
        strBirth = strBuffer
    End If
    
    Do
        'すでに日付認識可能ならチェック終了
        If IsDate(strBirth) Then
            Ret = True
            Exit Do
        End If

        'そのままでは日付認識不能な場合

        '8桁でなければ何もしない
        If Len(strBirth) <> 8 Then
            Exit Do
        End If

        '半角数字チェック
        For i = 1 To Len(strBirth)
            Select Case Asc(Mid(strBirth, i, 1))
                Case Asc("0") To Asc("9")
                Case Else
                    Exit Do
            End Select
        Next i

        '以上条件を満たせば日付チェックを行い、正常なら生年月日とみなす
        Ret = IsDate(Format(strBirth, "0000/00/00"))

        Exit Do
    Loop

    IsBirth = Ret
    
End Function

'
' 機能　　 : 検索キーが従業員番号指定かをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Public Function IsEmpNo(ByVal strBuffer As String) As Boolean

    Dim vntToken    As Variant  'トークン
    
    'ハイフンで分割
    vntToken = Split(strBuffer, "-")
    
    '分割後の要素が３個であれば従業員番号指定とみなす
    IsEmpNo = (UBound(vntToken) = 2)
    
End Function

'## 2004.10.13 Add By T.Takagi@FSIT 医事個人情報との照合チェック
'
' 機能　　 : 個人情報と医事個人情報との一致チェック
'
' 引数　　 : (In)     strPerId  個人ＩＤ
'
' 戻り値　 : True   一致する
' 　　　     False  一致しない
'
' 備考　　 :
'
Private Function IsEqualToMed(ByVal strPerId As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キーおよび戻り値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RET", Null, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    '個人情報用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN :RET := PersonPackage.IsEqualToMed(:PERID); END;"
    
    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL strStmt
        
    '戻り値の設定
    IsEqualToMed = (CLng(objOraParam("RET").Value) = 1)
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    'mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    IsEqualToMed = False

    'イベントログ書き込み
    WriteErrorLog "Person.IsEqualToMed"
    
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
' 機能　　 : 検索キーが性別指定かをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Public Function IsGender(ByVal strBuffer As String) As Boolean

    Dim strGender   As String   '性別
    
    '先頭６文字が"GENDER:"である場合は先頭部を取り除いた部分を生年月日として取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_GENDER))) = PREFIX_GENDER Then
        strGender = Right(strBuffer, Len(strBuffer) - Len(PREFIX_GENDER))
    Else
        strGender = strBuffer
    End If
    
    '取得した値をチェック
    Select Case UCase(strGender)
        Case "M", "F"
            IsGender = True
    End Select
    
End Function

'
' 機能　　 : 検索キーが健保記号番号指定かをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Public Function IsInsured(ByVal strBuffer As String) As Boolean

    Dim vntToken    As Variant  'トークン
    
    'ハイフンで分割
    vntToken = Split(strBuffer, "-")
    
    '分割後の要素が２個であれば健保記号番号指定とみなす
    IsInsured = (UBound(vntToken) = 1)
    
End Function

'
' 機能　　 : 検索キーが個人ＩＤ指定かをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Public Function IsPerId(ByVal strBuffer As String) As Boolean

    Dim strBuffer2  As String   '文字列バッファ
    Dim Ret         As Boolean  '関数戻り値
    Dim i           As Long     'インデックス
    
    Ret = True
    
    Do
    
        '先頭３文字が"ID:"であれば個人ID指定とみなす
        If UCase(Left(strBuffer, Len(PREFIX_PERID))) = PREFIX_PERID Then
            Exit Do
        End If
        
        '数字チェックを行う部分文字列の取得
        
        '先頭が＠の場合
        If Left(strBuffer, 1) = VID_PREFIX Then
            strBuffer2 = Right(strBuffer, Len(strBuffer) - 1)
        Else
            strBuffer2 = strBuffer
        End If
        
        '最後尾が"*"の場合
        If Right(strBuffer2, 1) = "*" Then
            strBuffer2 = Left(strBuffer2, Len(strBuffer2) - 1)
        End If
        
'## 2003.11.29 Add By T.Takagi@FSIT HOPEの患者ID桁数管理
'        '部分文字列＝最初の文字列の場合、１２桁以外の場合は個人IDとみなさない
'        If strBuffer2 = strBuffer And Len(strBuffer) <> LENGTH_PERSON_PERID Then
        '部分文字列＝最初の文字列の場合、10桁(HOPEでの桁数)以外の場合は個人IDとみなさない
        If strBuffer2 = strBuffer And Len(strBuffer) <> LENGTH_HOPE_PERID Then
'## 2003.11.29 Add End
            Ret = False
        End If
        
        'すべての文字列が数字であるかをチェック
        If strBuffer2 <> "" Then
            For i = 1 To Len(strBuffer2)
                If InStr("0123456789", Mid(strBuffer2, i, 1)) <= 0 Then
                    Ret = False
                    Exit Do
                End If
            Next i
        End If
        
        Exit Do
    Loop
        
    IsPerId = Ret
        
End Function

'
' 機能　　 : 指定個人が仮IDであるかを判定
'
' 引数　　 : (In)     strPerID              個人ＩＤ
'
' 戻り値　 : True   仮IDである
' 　　　　   False  仮IDでない、あるいはレコードが存在しない
'
' 備考　　 :
'
Public Function IsVirtualId(ByVal strPerId As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objVidFlg   As OraField         '仮IDフラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす個人テーブルのレコードを取得
    strStmt = "SELECT VIDFLG          " & vbLf & _
              "  FROM PERSON          " & vbLf & _
              " WHERE PERID  = :PERID "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objVidFlg = objFields("VIDFLG")
        
        '戻り値の設定
        IsVirtualId = (CLng(objVidFlg.Value) = 1)
    
    End If

    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.IsVirtualId"
    
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
' 機能　　 : 検索キーに全角文字が含まれるかをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Public Function IsWide(ByVal strBuffer As String) As Boolean

    Dim objCommon   As Common   '共通クラス
    Dim strBuffer2  As String   '文字列バッファ
        
    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
        
    '検索キー中の半角カナを全角カナに変換する
    strBuffer2 = objCommon.StrConvKanaWide(strBuffer)
        
    '検索キーが半角文字のみかチェックし、その結果で戻り値を決定する
    IsWide = Not (LenB(StrConv(strBuffer2, vbFromUnicode)) = Len(strBuffer2))
        
End Function

'
' 機能　　 : 続柄テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strRelationCd     続柄コード
' 　　　　   (In)    vntRelationName   続柄名
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistRelation(ByVal strMode As String, _
                               ByVal strRelationCd As String, _
                               ByVal strRelationName As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RELATIONCD", Trim(strRelationCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RELATIONNAME", Trim(strRelationName), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        '続柄テーブルレコードの更新
        If strMode = "UPD" Then
            Ret = mobjOraDb.ExecuteSQL("UPDATE RELATION SET RELATIONNAME = :RELATIONNAME WHERE RELATIONCD = :RELATIONCD")
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす続柄テーブルのレコードを取得
        strStmt = "SELECT RELATIONCD FROM RELATION WHERE RELATIONCD = :RELATIONCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO RELATION (RELATIONCD, RELATIONNAME) VALUES (:RELATIONCD, :RELATIONNAME)"
    
        Ret = INSERT_NORMAL
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'これはRootトランザクションなのでCommit
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistRelation = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistRelation = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Person.tem.RegistRelation"
    
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
' 機能　　 : 指定個人ＩＤの個人情報を取得する
'
' 引数　　 : (In)     strPerId            個人ＩＤ
' 　　　　   (Out)    vntLastName         姓
' 　　　　   (Out)    vntFirstName        名
' 　　　　   (Out)    vntLastKName        カナ姓
' 　　　　   (Out)    vntFirstKName       カナ名
' 　　　　   (Out)    vntBirth            生年月日
' 　　　　   (Out)    vntGender           性別
' 　　　　   (Out)    vntOrgCd1           所属団体コード１
' 　　　　   (Out)    vntOrgCd2           所属団体コード２
' 　　　　   (Out)    vntOrgKName         団体カナ名称
' 　　　　   (Out)    vntOrgName          団体漢字名称
' 　　　　   (Out)    vntOrgSName         団体略称
' 　　　　   (Out)    vntOrgBsdCd         事業部コード
' 　　　　   (Out)    vntOrgBsdKName      事業部カナ名称
' 　　　　   (Out)    vntOrgBsdName       事業部名称
' 　　　　   (Out)    vntOrgRoomCd        室部コード
' 　　　　   (Out)    vntOrgRoomName      室部名称
' 　　　　   (Out)    vntOrgRoomKName     室部カナ名称
' 　　　　   (Out)    vntOrgPostCd        所属部署コード
' 　　　　   (Out)    vntOrgPostName      所属名称
' 　　　　   (Out)    vntOrgPostKName     所属カナ名称
' 　　　　   (Out)    vntJobCd            職名コード
' 　　　　   (Out)    vntJobName          職名
' 　　　　   (Out)    vntDutyCd           職責コード
' 　　　　   (Out)    vntDutyName         職責
' 　　　　   (Out)    vntQualifyCd        資格コード
' 　　　　   (Out)    vntQualifyName      資格
' 　　　　   (Out)    vntEmpNo            従業員番号
' 　　　　   (Out)    vntIsrSign          健保記号
' 　　　　   (Out)    vntIsrNo            健保番号
' 　　　　   (Out)    vntRelationCd       続柄コード
' 　　　　   (Out)    vntRelationName     続柄
' 　　　　   (Out)    vntBranchNo         枝番
' 　　　　   (Out)    vntTransferDiv      出向区分
' 　　　　   (Out)    vntPrimPerId        親個人ＩＤ
' 　　　　   (Out)    vntLostDate         資格喪失日
' 　　　　   (Out)    vntHireDate         入社年月日
' 　　　　   (Out)    vntEmpDiv           従業員区分
' 　　　　   (Out)    vntHongenDiv        本現区分
' 　　　　   (Out)    vntWorkMeasureDiv   就業措置区分
' 　　　　   (Out)    vntWorkMeasureName  就業措置区分名
' 　　　　   (Out)    vntOverTimeDiv      超過勤務区分
' 　　　　   (Out)    vntNightDutyFlg     夜勤者健診対象
' 　　　　   (Out)    vntVidflg           仮ＩＤフラグ
' 　　　　   (Out)    vntSupportFlg       本人扶養区分
' 　　　　   (Out)    vntReplicaFlg       複製フラグ
' 　　　　   (Out)    vntUpdDate          更新日時
' 　　　　   (Out)    vntUpdUser          更新者
' 　　　　   (Out)    vntUserName         更新者漢字氏名
' 　　　　   (Out)    vntSpare1           予備１
' 　　　　   (Out)    vntSpare2           予備２
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPerson( _
    ByVal strPerId As String, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant, _
    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntOrgKName As Variant, Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntOrgBsdCd As Variant, Optional ByRef vntOrgBsdKName As Variant, Optional ByRef vntOrgBsdName As Variant, _
    Optional ByRef vntOrgRoomCd As Variant, Optional ByRef vntOrgRoomName As Variant, Optional ByRef vntOrgRoomKName As Variant, _
    Optional ByRef vntOrgPostCd As Variant, Optional ByRef vntOrgPostName As Variant, Optional ByRef vntOrgPostKName As Variant, _
    Optional ByRef vntJobCd As Variant, Optional ByRef vntJobName As Variant, _
    Optional ByRef vntDutyCd As Variant, Optional ByRef vntDutyName As Variant, _
    Optional ByRef vntQualifyCd As Variant, Optional ByRef vntQualifyName As Variant, _
    Optional ByRef vntEmpNo As Variant, Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant, _
    Optional ByRef vntRelationCd As Variant, Optional ByRef vntRelationName As Variant, Optional ByRef vntBranchNo As Variant, _
    Optional ByRef vntTransferDiv As Variant, _
    Optional ByRef vntPrimPerId As Variant, _
    Optional ByRef vntLostDate As Variant, Optional ByRef vntHireDate As Variant, _
    Optional ByRef vntEmpDiv As Variant, Optional ByRef vntHongenDiv As Variant, _
    Optional ByRef vntWorkMeasureDiv As Variant, Optional ByRef vntWorkMeasureName As Variant, _
    Optional ByRef vntOverTimeDiv As Variant, Optional ByRef vntNightDutyFlg As Variant, _
    Optional ByRef vntVidFlg As Variant, Optional ByRef vntDelFlg As Variant, Optional ByRef vntReplicaFlg As Variant, _
    Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant, _
    Optional ByRef vntSpare1 As Variant, Optional ByRef vntSpare2 As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    Dim objLastKName        As OraField         'カナ姓
    Dim objFirstKName       As OraField         'カナ名
    Dim objBirth            As OraField         '生年月日
    Dim objGender           As OraField         '性別
    Dim objOrgCd1           As OraField         '所属団体コード１
    Dim objOrgCd2           As OraField         '所属団体コード２
    Dim objOrgKName         As OraField         '団体カナ名称
    Dim objOrgName          As OraField         '団体漢字名称
    Dim objOrgSName         As OraField         '団体略称
    Dim objOrgBsdCd         As OraField         '事業部コード
    Dim objOrgBsdKName      As OraField         '事業部カナ名称
    Dim objOrgBsdName       As OraField         '事業部名称
    Dim objOrgRoomCd        As OraField         '室部コード
    Dim objOrgRoomName      As OraField         '室部名称
    Dim objOrgRoomKName     As OraField         '室部カナ名称
    Dim objOrgPostCd        As OraField         '所属部署コード
    Dim objOrgPostName      As OraField         '所属名称
    Dim objOrgPostKName     As OraField         '所属カナ名称
    Dim objJobCd            As OraField         '職名コード
    Dim objJobName          As OraField         '職名
    Dim objDutyCd           As OraField         '職責コード
    Dim objDutyName         As OraField         '職責
    Dim objQualifyCd        As OraField         '資格コード
    Dim objQualifyName      As OraField         '資格
    Dim objEmpNo            As OraField         '従業員番号
    Dim objIsrSign          As OraField         '健保記号
    Dim objIsrNo            As OraField         '健保番号
    Dim objRelationCd       As OraField         '続柄コード
    Dim objRelationName     As OraField         '続柄
    Dim objBranchNo         As OraField         '枝番
    Dim objTransferDiv      As OraField         '出向区分
    Dim objPrimPerId        As OraField         '親個人ＩＤ
    Dim objLostDate         As OraField         '資格喪失日
    Dim objHireDate         As OraField         '入社年月日
    Dim objEmpDiv           As OraField         '従業員区分
    Dim objHongenDiv        As OraField         '本現区分
    Dim objWorkMeasureDiv   As OraField         '就業措置区分
    Dim objWorkMeasureName  As OraField         '就業措置区分名
    Dim objOverTimeDiv      As OraField         '超過勤務区分
    Dim objNightDutyFlg     As OraField         '夜勤者健診対象
    Dim objVidFlg           As OraField         '仮ＩＤフラグ
    Dim objDelFlg           As OraField         '削除フラグ
    Dim objReplicaFlg       As OraField         '複製フラグ
    Dim objUpdDate          As OraField         '更新日時
    Dim objUpdUser          As OraField         '更新者
    Dim objUserName         As OraField         '更新者漢字氏名
    Dim objSpare1           As OraField         '予備１
    Dim objSpare2           As OraField         '予備２

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntLastName) Then
        vntLastName = Empty
    End If

    If Not IsMissing(vntFirstName) Then
        vntFirstName = Empty
    End If

    If Not IsMissing(vntLastKName) Then
        vntLastKName = Empty
    End If

    If Not IsMissing(vntFirstKName) Then
        vntFirstKName = Empty
    End If

    If Not IsMissing(vntBirth) Then
        vntBirth = Empty
    End If

    If Not IsMissing(vntGender) Then
        vntGender = Empty
    End If

    If Not IsMissing(vntOrgCd1) Then
        vntOrgCd1 = Empty
    End If

    If Not IsMissing(vntOrgCd2) Then
        vntOrgCd2 = Empty
    End If

    If Not IsMissing(vntOrgKName) Then
        vntOrgKName = Empty
    End If

    If Not IsMissing(vntOrgName) Then
        vntOrgName = Empty
    End If

    If Not IsMissing(vntOrgSName) Then
        vntOrgSName = Empty
    End If

    If Not IsMissing(vntOrgBsdCd) Then
        vntOrgBsdCd = Empty
    End If

    If Not IsMissing(vntOrgBsdKName) Then
        vntOrgBsdKName = Empty
    End If

    If Not IsMissing(vntOrgBsdName) Then
        vntOrgBsdName = Empty
    End If

    If Not IsMissing(vntOrgRoomCd) Then
        vntOrgRoomCd = Empty
    End If

    If Not IsMissing(vntOrgRoomName) Then
        vntOrgRoomName = Empty
    End If

    If Not IsMissing(vntOrgRoomKName) Then
        vntOrgRoomKName = Empty
    End If

    If Not IsMissing(vntOrgPostCd) Then
        vntOrgPostCd = Empty
    End If

    If Not IsMissing(vntOrgPostName) Then
        vntOrgPostName = Empty
    End If

    If Not IsMissing(vntOrgPostKName) Then
        vntOrgPostKName = Empty
    End If

    If Not IsMissing(vntJobCd) Then
        vntJobCd = Empty
    End If

    If Not IsMissing(vntJobName) Then
        vntJobName = Empty
    End If

    If Not IsMissing(vntDutyCd) Then
        vntDutyCd = Empty
    End If

    If Not IsMissing(vntDutyName) Then
        vntDutyName = Empty
    End If

    If Not IsMissing(vntQualifyCd) Then
        vntQualifyCd = Empty
    End If

    If Not IsMissing(vntQualifyName) Then
        vntQualifyName = Empty
    End If

    If Not IsMissing(vntEmpNo) Then
        vntEmpNo = Empty
    End If

    If Not IsMissing(vntIsrSign) Then
        vntIsrSign = Empty
    End If

    If Not IsMissing(vntIsrNo) Then
        vntIsrNo = Empty
    End If

    If Not IsMissing(vntRelationCd) Then
        vntRelationCd = Empty
    End If

    If Not IsMissing(vntRelationName) Then
        vntRelationName = Empty
    End If

    If Not IsMissing(vntBranchNo) Then
        vntBranchNo = Empty
    End If

    If Not IsMissing(vntTransferDiv) Then
        vntTransferDiv = Empty
    End If

    If Not IsMissing(vntPrimPerId) Then
        vntPrimPerId = Empty
    End If

    If Not IsMissing(vntLostDate) Then
        vntLostDate = Empty
    End If

    If Not IsMissing(vntHireDate) Then
        vntHireDate = Empty
    End If

    If Not IsMissing(vntEmpDiv) Then
        vntEmpDiv = Empty
    End If

    If Not IsMissing(vntHongenDiv) Then
        vntHongenDiv = Empty
    End If

    If Not IsMissing(vntWorkMeasureDiv) Then
        vntWorkMeasureDiv = Empty
    End If

    If Not IsMissing(vntWorkMeasureName) Then
        vntWorkMeasureName = Empty
    End If

    If Not IsMissing(vntOverTimeDiv) Then
        vntOverTimeDiv = Empty
    End If

    If Not IsMissing(vntNightDutyFlg) Then
        vntNightDutyFlg = Empty
    End If

    If Not IsMissing(vntVidFlg) Then
        vntVidFlg = Empty
    End If

    If Not IsMissing(vntDelFlg) Then
        vntDelFlg = Empty
    End If

    If Not IsMissing(vntReplicaFlg) Then
        vntReplicaFlg = Empty
    End If

    If Not IsMissing(vntUpdDate) Then
        vntUpdDate = Empty
    End If

    If Not IsMissing(vntUpdUser) Then
        vntUpdUser = Empty
    End If

    If Not IsMissing(vntUserName) Then
        vntUserName = Empty
    End If

    If Not IsMissing(vntSpare1) Then
        vntSpare1 = Empty
    End If

    If Not IsMissing(vntSpare2) Then
        vntSpare2 = Empty
    End If


    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす個人属性テーブルのレコードを取得
    strStmt = "SELECT PERSON.PERID,       PERSON.VIDFLG,        PERSON.DELFLG,         " & vbLf & _
              "       PERSON.REPLICAFLG,    PERSON.UPDDATE,                            " & vbLf & _
              "       PERSON.UPDUSER,     PERSON.LASTNAME,      PERSON.FIRSTNAME,      " & vbLf & _
              "       PERSON.LASTKNAME,   PERSON.FIRSTKNAME,    PERSON.BIRTH,          " & vbLf & _
              "       PERSON.GENDER,      PERSON.ORGCD1,        PERSON.ORGCD2,         " & vbLf & _
              "       PERSON.ORGPOSTCD,   PERSON.ISRNO,         PERSON.SPARE1,         " & vbLf & _
              "       PERSON.SPARE2,      PERSON.TRANSFERDIV,   PERSON.ORGBSDCD,       " & vbLf & _
              "       PERSON.ORGROOMCD,   PERSON.JOBCD,         PERSON.DUTYCD,         " & vbLf & _
              "       PERSON.QUALIFYCD,   PERSON.ISRSIGN,       PERSON.RELATIONCD,     " & vbLf & _
              "       PERSON.BRANCHNO,    PERSON.EMPNO,         PERSON.PRIMPERID,      " & vbLf & _
              "       PERSON.EMPDIV,      PERSON.HONGENDIV,     PERSON.WORKMEASUREDIV, " & vbLf & _
              "       PERSON.OVERTIMEDIV, PERSON.NIGHTDUTYFLG,  PERSON.LOSTDATE,       " & vbLf & _
              "       PERSON.HIREDATE,                                                 " & vbLf & _
              "       HAINSUSER.USERNAME,                                              " & vbLf & _
              "       ORG.ORGKNAME, ORG.ORGNAME, ORG.ORGSNAME,                         " & vbLf & _
              "       ORGBSD.ORGBSDKNAME, ORGBSD.ORGBSDNAME,                           " & vbLf & _
              "       ORGROOM.ORGROOMNAME, ORGROOM.ORGROOMKNAME,                       " & vbLf & _
              "       ORGPOST.ORGPOSTNAME, ORGPOST.ORGPOSTKNAME,                       " & vbLf & _
              "       RELATION.RELATIONNAME,                                           " & vbLf & _
              "       JOB.JOBNAME,                                                     " & vbLf & _
              "       DUTY.DUTYNAME,                                                   " & vbLf & _
              "       QUALIFY.QUALIFYNAME,                                             " & vbLf & _
              "       WORKMEASURE.WORKMEASURENAME                                      "

    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT FREECD JOBCD, FREEFIELD1 JOBNAME                  " & vbLf & _
              "           FROM FREE                                              " & vbLf & _
              "       ) JOB,                                                     " & vbLf & _
              "       ( SELECT FREECD DUTYCD, FREEFIELD1 DUTYNAME                " & vbLf & _
              "           FROM FREE                                              " & vbLf & _
              "       ) DUTY,                                                    " & vbLf & _
              "       ( SELECT FREECD QUALIFYCD, FREEFIELD1 QUALIFYNAME          " & vbLf & _
              "           FROM FREE                                              " & vbLf & _
              "       ) QUALIFY,                                                 " & vbLf & _
              "       ( SELECT FREECD WORKMEASUREDIV, FREEFIELD1 WORKMEASURENAME " & vbLf & _
              "           FROM FREE                                              " & vbLf & _
              "       ) WORKMEASURE,                                             " & vbLf & _
              "       RELATION, ORG, ORGBSD, ORGROOM, ORGPOST, HAINSUSER, PERSON "

    strStmt = strStmt & vbLf & _
              " WHERE PERSON.PERID          = :PERID                        " & vbLf & _
              "   AND PERSON.UPDUSER        = HAINSUSER.USERID(+)           " & vbLf & _
              "   AND PERSON.ORGCD1         = ORG.ORGCD1(+)                 " & vbLf & _
              "   AND PERSON.ORGCD2         = ORG.ORGCD2(+)                 " & vbLf & _
              "   AND PERSON.ORGCD1         = ORGBSD.ORGCD1(+)              " & vbLf & _
              "   AND PERSON.ORGCD2         = ORGBSD.ORGCD2(+)              " & vbLf & _
              "   AND PERSON.ORGBSDCD       = ORGBSD.ORGBSDCD(+)            " & vbLf & _
              "   AND PERSON.ORGCD1         = ORGROOM.ORGCD1(+)             " & vbLf & _
              "   AND PERSON.ORGCD2         = ORGROOM.ORGCD2(+)             " & vbLf & _
              "   AND PERSON.ORGBSDCD       = ORGROOM.ORGBSDCD(+)           " & vbLf & _
              "   AND PERSON.ORGROOMCD      = ORGROOM.ORGROOMCD(+)          " & vbLf & _
              "   AND PERSON.ORGCD1         = ORGPOST.ORGCD1(+)             " & vbLf & _
              "   AND PERSON.ORGCD2         = ORGPOST.ORGCD2(+)             " & vbLf & _
              "   AND PERSON.ORGBSDCD       = ORGPOST.ORGBSDCD(+)           " & vbLf & _
              "   AND PERSON.ORGROOMCD      = ORGPOST.ORGROOMCD(+)          " & vbLf & _
              "   AND PERSON.ORGPOSTCD      = ORGPOST.ORGPOSTCD(+)          " & vbLf & _
              "   AND PERSON.RELATIONCD     = RELATION.RELATIONCD(+)        " & vbLf & _
              "   AND PERSON.JOBCD          = JOB.JOBCD(+)                  " & vbLf & _
              "   AND PERSON.DUTYCD         = DUTY.DUTYCD(+)                " & vbLf & _
              "   AND PERSON.QUALIFYCD      = QUALIFY.QUALIFYCD(+)          " & vbLf & _
              "   AND PERSON.WORKMEASUREDIV = WORKMEASURE.WORKMEASUREDIV(+) "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgKName = objFields("ORGKNAME")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgSName = objFields("ORGSNAME")
        Set objOrgBsdCd = objFields("ORGBSDCD")
        Set objOrgBsdKName = objFields("ORGBSDKNAME")
        Set objOrgBsdName = objFields("ORGBSDNAME")
        Set objOrgRoomCd = objFields("ORGROOMCD")
        Set objOrgRoomName = objFields("ORGROOMNAME")
        Set objOrgRoomKName = objFields("ORGROOMKNAME")
        Set objOrgPostCd = objFields("ORGPOSTCD")
        Set objOrgPostName = objFields("ORGPOSTNAME")
        Set objOrgPostKName = objFields("ORGPOSTKNAME")
        Set objJobCd = objFields("JOBCD")
        Set objJobName = objFields("JOBNAME")
        Set objDutyCd = objFields("DUTYCD")
        Set objDutyName = objFields("DUTYNAME")
        Set objQualifyCd = objFields("QUALIFYCD")
        Set objQualifyName = objFields("QUALIFYNAME")
        Set objEmpNo = objFields("EMPNO")
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrNo = objFields("ISRNO")
        Set objRelationCd = objFields("RELATIONCD")
        Set objRelationName = objFields("RELATIONNAME")
        Set objBranchNo = objFields("BRANCHNO")
        Set objTransferDiv = objFields("TRANSFERDIV")
        Set objPrimPerId = objFields("PRIMPERID")
        Set objLostDate = objFields("LOSTDATE")
        Set objHireDate = objFields("HIREDATE")
        Set objEmpDiv = objFields("EMPDIV")
        Set objHongenDiv = objFields("HONGENDIV")
        Set objWorkMeasureDiv = objFields("WORKMEASUREDIV")
        Set objWorkMeasureName = objFields("WORKMEASURENAME")
        Set objOverTimeDiv = objFields("OVERTIMEDIV")
        Set objNightDutyFlg = objFields("NIGHTDUTYFLG")
        Set objVidFlg = objFields("VIDFLG")
        Set objDelFlg = objFields("DELFLG")
        Set objReplicaFlg = objFields("REPLICAFLG")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objSpare1 = objFields("SPARE1")
        Set objSpare2 = objFields("SPARE2")

        '戻り値の設定
        If Not IsMissing(vntLastName) Then
            vntLastName = objLastName.Value & ""
        End If

        If Not IsMissing(vntFirstName) Then
            vntFirstName = objFirstName.Value & ""
        End If

        If Not IsMissing(vntLastKName) Then
            vntLastKName = objLastKName.Value & ""
        End If

        If Not IsMissing(vntFirstKName) Then
            vntFirstKName = objFirstKName.Value & ""
        End If

        If Not IsMissing(vntBirth) Then
            vntBirth = objBirth.Value & ""
        End If

        If Not IsMissing(vntGender) Then
            vntGender = objGender.Value & ""
        End If

        If Not IsMissing(vntOrgCd1) Then
            vntOrgCd1 = objOrgCd1.Value & ""
        End If

        If Not IsMissing(vntOrgCd2) Then
            vntOrgCd2 = objOrgCd2.Value & ""
        End If

        If Not IsMissing(vntOrgKName) Then
            vntOrgKName = objOrgKName.Value & ""
        End If

        If Not IsMissing(vntOrgName) Then
            vntOrgName = objOrgName.Value & ""
        End If

        If Not IsMissing(vntOrgSName) Then
            vntOrgSName = objOrgSName.Value & ""
        End If

        If Not IsMissing(vntOrgBsdCd) Then
            vntOrgBsdCd = objOrgBsdCd.Value & ""
        End If

        If Not IsMissing(vntOrgBsdKName) Then
            vntOrgBsdKName = objOrgBsdKName.Value & ""
        End If

        If Not IsMissing(vntOrgBsdName) Then
            vntOrgBsdName = objOrgBsdName.Value & ""
        End If

        If Not IsMissing(vntOrgRoomCd) Then
            vntOrgRoomCd = objOrgRoomCd.Value & ""
        End If

        If Not IsMissing(vntOrgRoomName) Then
            vntOrgRoomName = objOrgRoomName.Value & ""
        End If

        If Not IsMissing(vntOrgRoomKName) Then
            vntOrgRoomKName = objOrgRoomKName.Value & ""
        End If

        If Not IsMissing(vntOrgPostCd) Then
            vntOrgPostCd = objOrgPostCd.Value & ""
        End If

        If Not IsMissing(vntOrgPostName) Then
            vntOrgPostName = objOrgPostName.Value & ""
        End If

        If Not IsMissing(vntOrgPostKName) Then
            vntOrgPostKName = objOrgPostKName.Value & ""
        End If

        If Not IsMissing(vntJobCd) Then
            vntJobCd = objJobCd.Value & ""
        End If

        If Not IsMissing(vntJobName) Then
            vntJobName = objJobName.Value & ""
        End If

        If Not IsMissing(vntDutyCd) Then
            vntDutyCd = objDutyCd.Value & ""
        End If

        If Not IsMissing(vntDutyName) Then
            vntDutyName = objDutyName.Value & ""
        End If

        If Not IsMissing(vntQualifyCd) Then
            vntQualifyCd = objQualifyCd.Value & ""
        End If

        If Not IsMissing(vntQualifyName) Then
            vntQualifyName = objQualifyName.Value & ""
        End If

        If Not IsMissing(vntEmpNo) Then
            vntEmpNo = objEmpNo.Value & ""
        End If

        If Not IsMissing(vntIsrSign) Then
            vntIsrSign = objIsrSign.Value & ""
        End If

        If Not IsMissing(vntIsrNo) Then
            vntIsrNo = objIsrNo.Value & ""
        End If

        If Not IsMissing(vntRelationCd) Then
            vntRelationCd = objRelationCd.Value & ""
        End If

        If Not IsMissing(vntRelationName) Then
            vntRelationName = objRelationName.Value & ""
        End If

        If Not IsMissing(vntBranchNo) Then
            vntBranchNo = objBranchNo.Value & ""
        End If

        If Not IsMissing(vntTransferDiv) Then
            vntTransferDiv = objTransferDiv.Value & ""
        End If

        If Not IsMissing(vntPrimPerId) Then
            vntPrimPerId = objPrimPerId.Value & ""
        End If

        If Not IsMissing(vntLostDate) Then
            vntLostDate = objLostDate.Value & ""
        End If

        If Not IsMissing(vntHireDate) Then
            vntHireDate = objHireDate.Value & ""
        End If

        If Not IsMissing(vntEmpDiv) Then
            vntEmpDiv = objEmpDiv.Value & ""
        End If

        If Not IsMissing(vntHongenDiv) Then
            vntHongenDiv = objHongenDiv.Value & ""
        End If

        If Not IsMissing(vntWorkMeasureDiv) Then
            vntWorkMeasureDiv = objWorkMeasureDiv.Value & ""
        End If

        If Not IsMissing(vntWorkMeasureName) Then
            vntWorkMeasureName = objWorkMeasureName.Value & ""
        End If

        If Not IsMissing(vntOverTimeDiv) Then
            vntOverTimeDiv = objOverTimeDiv.Value & ""
        End If

        If Not IsMissing(vntNightDutyFlg) Then
            vntNightDutyFlg = objNightDutyFlg.Value & ""
        End If

        If Not IsMissing(vntVidFlg) Then
            vntVidFlg = objVidFlg.Value & ""
        End If

        If Not IsMissing(vntDelFlg) Then
            vntDelFlg = objDelFlg.Value & ""
        End If

        If Not IsMissing(vntReplicaFlg) Then
            vntReplicaFlg = objReplicaFlg.Value & ""
        End If

        If Not IsMissing(vntUpdDate) Then
            vntUpdDate = objUpdDate.Value & ""
        End If

        If Not IsMissing(vntUpdUser) Then
            vntUpdUser = objUpdUser.Value & ""
        End If

        If Not IsMissing(vntUserName) Then
            vntUserName = objUserName.Value & ""
        End If

        If Not IsMissing(vntSpare1) Then
            vntSpare1 = objSpare1.Value & ""
        End If

        If Not IsMissing(vntSpare2) Then
            vntSpare2 = objSpare2.Value & ""
        End If

        SelectPerson = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerson = False

    'イベントログ書き込み
'## 2004.02.10 Add By T.Takagi@FSIT おいおい
'    WriteErrorLog "Contract.SelectPerson"
    WriteErrorLog "Person.SelectPerson"
'## 2004.02.10 Add End
    
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
' 機能　　 : 指定個人ＩＤの個人情報を取得する ## 聖路加バージョン ##
'
' 引数　　 : (In)     strPerId          個人ＩＤ
' 　　　　   (Out)    vntLastName       姓
' 　　　　   (Out)    vntFirstName      名
' 　　　　   (Out)    vntLastKName      カナ姓
' 　　　　   (Out)    vntFirstKName     カナ名
' 　　　　   (Out)    vntRomeName       ローマ字名
' 　　　　   (Out)    vntBirth          生年月日
' 　　　　   (Out)    vntGender         性別
' 　　　　   (Out)    vntPostCardAddr   １年目はがき宛先
' 　　　　   (Out)    vntMaidenName     旧姓
' 　　　　   (Out)    vntNationCd       国籍コード
' 　　　　   (Out)    vntCompPerId      同伴者ＩＤ
' 　　　　   (Out)    vntCompLastName   同伴者姓
' 　　　　   (Out)    vntCompFirstName  同伴者名
' 　　　　   (Out)    vntVidflg         仮ＩＤフラグ
' 　　　　   (Out)    vntDelFlg         削除フラグ
' 　　　　   (Out)    vntUpdDate        更新日時
' 　　　　   (Out)    vntUpdUser        更新者
' 　　　　   (Out)    vntUserName       更新者漢字氏名
' 　　　　   (Out)    vntSpare1         予備１
' 　　　　   (Out)    vntSpare2         予備２
' 　　　　   (Out)    vntMedRName       医事連携ローマ字名
' 　　　　   (Out)    vntMedName        医事連携漢字氏名
' 　　　　   (Out)    vntMedBirth       医事連携生年月日
' 　　　　   (Out)    vntMedGender      医事連携性別
' 　　　　   (Out)    vntCslCount       受診回数
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
'## 2003.12.16 Mod By T.Takagi@FSIT 医事情報取得
'Public Function SelectPerson_lukes(
'    ByVal strPerId As String,
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntRomeName As Variant,
'    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant,
'    Optional ByRef vntPostCardAddr As Variant, Optional ByRef vntMaidenName As Variant,
'    Optional ByRef vntNationCd As Variant, Optional ByRef vntCompPerId As Variant,
'    Optional ByRef vntCompLastName As Variant, Optional ByRef vntCompFirstName As Variant,
'    Optional ByRef vntVidFlg As Variant, Optional ByRef vntDelFlg As Variant,
'    Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant,
'    Optional ByRef vntSpare1 As Variant, Optional ByRef vntSpare2 As Variant,
'    Optional ByRef vntMedRName As Variant, Optional ByRef vntMedName As Variant,
'    Optional ByRef vntMedBirth As Variant, Optional ByRef vntMedGender As Variant
') As Boolean
'## 2004.01.03 Mod By T.Takagi@FSIT 医事連携更新日時追加
'Public Function SelectPerson_lukes(
'    ByVal strPerId As String,
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntRomeName As Variant,
'    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant,
'    Optional ByRef vntPostCardAddr As Variant, Optional ByRef vntMaidenName As Variant,
'    Optional ByRef vntNationCd As Variant, Optional ByRef vntCompPerId As Variant,
'    Optional ByRef vntCompLastName As Variant, Optional ByRef vntCompFirstName As Variant,
'    Optional ByRef vntVidFlg As Variant, Optional ByRef vntDelFlg As Variant,
'    Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant,
'    Optional ByRef vntSpare1 As Variant, Optional ByRef vntSpare2 As Variant,
'    Optional ByRef vntMedRName As Variant, Optional ByRef vntMedName As Variant,
'    Optional ByRef vntMedBirth As Variant, Optional ByRef vntMedGender As Variant
') As Boolean
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
'Public Function SelectPerson_lukes(
'    ByVal strPerId As String,
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntRomeName As Variant,
'    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant,
'    Optional ByRef vntPostCardAddr As Variant, Optional ByRef vntMaidenName As Variant,
'    Optional ByRef vntNationCd As Variant, Optional ByRef vntCompPerId As Variant,
'    Optional ByRef vntCompLastName As Variant, Optional ByRef vntCompFirstName As Variant,
'    Optional ByRef vntVidFlg As Variant, Optional ByRef vntDelFlg As Variant,
'    Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant,
'    Optional ByRef vntSpare1 As Variant, Optional ByRef vntSpare2 As Variant,
'    Optional ByRef vntMedRName As Variant, Optional ByRef vntMedName As Variant,
'    Optional ByRef vntMedBirth As Variant, Optional ByRef vntMedGender As Variant, Optional ByRef vntMedUpdDate As Variant
') As Boolean
Public Function SelectPerson_lukes( _
    ByVal strPerId As String, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntRomeName As Variant, _
    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant, _
    Optional ByRef vntPostCardAddr As Variant, Optional ByRef vntMaidenName As Variant, _
    Optional ByRef vntNationCd As Variant, Optional ByRef vntCompPerId As Variant, _
    Optional ByRef vntCompLastName As Variant, Optional ByRef vntCompFirstName As Variant, _
    Optional ByRef vntVidFlg As Variant, Optional ByRef vntDelFlg As Variant, _
    Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant, _
    Optional ByRef vntSpare1 As Variant, Optional ByRef vntSpare2 As Variant, _
    Optional ByRef vntMedRName As Variant, Optional ByRef vntMedName As Variant, _
    Optional ByRef vntMedBirth As Variant, Optional ByRef vntMedGender As Variant, Optional ByRef vntMedUpdDate As Variant, _
    Optional ByRef vntCslCount As Variant _
) As Boolean
'## 2004.02.10 Mod End
'## 2004.01.03 Mod End
'## 2003.12.16 Mod End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    Dim objLastKName        As OraField         'カナ姓
    Dim objFirstKName       As OraField         'カナ名
    Dim objRomeName         As OraField         'ローマ字名
    Dim objBirth            As OraField         '生年月日
    Dim objGender           As OraField         '性別
    Dim objPostCardAddr     As OraField         '１年目はがき宛先
    Dim objMaidenName       As OraField         '旧姓
    Dim objNationCd         As OraField         '国籍コード
    Dim objCompPerId        As OraField         '同伴者ＩＤ
    Dim objCompLastName     As OraField         '同伴者名　姓
    Dim objCompFirstName    As OraField         '同伴者名　名
    Dim objVidFlg           As OraField         '仮ＩＤフラグ
    Dim objDelFlg           As OraField         '削除フラグ
    Dim objUpdDate          As OraField         '更新日時
    Dim objUpdUser          As OraField         '更新者
    Dim objUserName         As OraField         '更新者漢字氏名
    Dim objSpare1           As OraField         '予備１
    Dim objSpare2           As OraField         '予備２
    Dim objMedRName         As OraField         '医事連携ローマ字名
    Dim objMedName          As OraField         '医事連携漢字氏名
'## 2003.12.16 Add By T.Takagi@FSIT 医事情報取得
    Dim objMedBirth         As OraField         '医事連携生年月日
    Dim objMedGender        As OraField         '医事連携性別
'## 2003.12.16 Add End
'## 2004.01.03 Add By T.Takagi@FSIT 医事連携更新日時追加
    Dim objMedUpdDate       As OraField         '医事連携更新日時
'## 2004.01.03 Add End
'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
    Dim objCslCount         As OraField         '受診回数
'## 2004.02.10 Add End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntRomeName) Then vntRomeName = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntPostCardAddr) Then vntPostCardAddr = Empty
    If Not IsMissing(vntMaidenName) Then vntMaidenName = Empty
    If Not IsMissing(vntNationCd) Then vntNationCd = Empty
    If Not IsMissing(vntCompPerId) Then vntCompPerId = Empty
    If Not IsMissing(vntCompLastName) Then vntCompLastName = Empty
    If Not IsMissing(vntCompFirstName) Then vntCompFirstName = Empty
    If Not IsMissing(vntVidFlg) Then vntVidFlg = Empty
    If Not IsMissing(vntDelFlg) Then vntDelFlg = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUserName) Then vntUserName = Empty
    If Not IsMissing(vntSpare1) Then vntSpare1 = Empty
    If Not IsMissing(vntSpare2) Then vntSpare2 = Empty
    If Not IsMissing(vntMedRName) Then vntMedRName = Empty
    If Not IsMissing(vntMedName) Then vntMedName = Empty
'## 2003.12.16 Add By T.Takagi@FSIT 医事情報取得
    If Not IsMissing(vntMedBirth) Then vntMedBirth = Empty
    If Not IsMissing(vntMedGender) Then vntMedGender = Empty
'## 2003.12.16 Add End
'## 2004.01.03 Add By T.Takagi@FSIT 医事連携更新日時追加
    If Not IsMissing(vntMedUpdDate) Then vntMedUpdDate = Empty
'## 2004.01.03 Add End
'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
    If Not IsMissing(vntCslCount) Then vntCslCount = Empty
'## 2004.02.10 Add End

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす個人属性テーブルのレコードを取得
'## 2003.12.16 Mod By T.Takagi@FSIT 医事情報取得
'    strStmt = "SELECT PERSON.PERID,       PERSON.VIDFLG,        PERSON.DELFLG,     " & vbLf & _
'              "       PERSON.UPDDATE,                                              " & vbLf & _
'              "       PERSON.UPDUSER,     PERSON.LASTNAME,      PERSON.FIRSTNAME,  " & vbLf & _
'              "       PERSON.LASTKNAME,   PERSON.FIRSTKNAME,    PERSON.BIRTH,      " & vbLf & _
'              "       PERSON.ROMENAME,                                             " & vbLf & _
'              "       PERSON.GENDER,      PERSON.POSTCARDADDR,  PERSON.MAIDENNAME, " & vbLf & _
'              "       PERSON.NATIONCD,    PERSON.COMPPERID,                        " & vbLf & _
'              "       PERSON.SPARE1,      PERSON.SPARE2,                           " & vbLf & _
'              "       PERSON.MEDRNAME,    PERSON.MEDNAME,                          " & vbLf & _
'              "       COMPPERSON.LASTNAME  COMPLASTNAME,                           " & vbLf & _
'              "       COMPPERSON.FIRSTNAME COMPFIRSTNAME,                          " & vbLf & _
'              "       HAINSUSER.USERNAME                                           " & vbLf & _
'              "  FROM HAINSUSER, PERSON COMPPERSON, PERSON                         " & vbLf & _
'              " WHERE PERSON.PERID     = :PERID                                    " & vbLf & _
'              "   AND PERSON.COMPPERID = COMPPERSON.PERID(+)                       " & vbLf & _
'              "   AND PERSON.UPDUSER   = HAINSUSER.USERID(+)                         "
'## 2004.01.03 Mod By T.Takagi@FSIT 医事連携更新日時追加
'    strStmt = "SELECT PERSON.PERID,       PERSON.VIDFLG,        PERSON.DELFLG,     " & vbLf & _
'              "       PERSON.UPDDATE,                                              " & vbLf & _
'              "       PERSON.UPDUSER,     PERSON.LASTNAME,      PERSON.FIRSTNAME,  " & vbLf & _
'              "       PERSON.LASTKNAME,   PERSON.FIRSTKNAME,    PERSON.BIRTH,      " & vbLf & _
'              "       PERSON.ROMENAME,                                             " & vbLf & _
'              "       PERSON.GENDER,      PERSON.POSTCARDADDR,  PERSON.MAIDENNAME, " & vbLf & _
'              "       PERSON.NATIONCD,    PERSON.COMPPERID,                        " & vbLf & _
'              "       PERSON.SPARE1,      PERSON.SPARE2,                           " & vbLf & _
'              "       PERSON.MEDRNAME,    PERSON.MEDNAME,                          " & vbLf & _
'              "       PERSON.MEDBIRTH,    PERSON.MEDGENDER,                        " & vbLf & _
'              "       COMPPERSON.LASTNAME  COMPLASTNAME,                           " & vbLf & _
'              "       COMPPERSON.FIRSTNAME COMPFIRSTNAME,                          " & vbLf & _
'              "       HAINSUSER.USERNAME                                           " & vbLf & _
'              "  FROM HAINSUSER, PERSON COMPPERSON, PERSON                         " & vbLf & _
'              " WHERE PERSON.PERID     = :PERID                                    " & vbLf & _
'              "   AND PERSON.COMPPERID = COMPPERSON.PERID(+)                       " & vbLf & _
'              "   AND PERSON.UPDUSER   = HAINSUSER.USERID(+)                         "
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
'    strStmt = "SELECT PERSON.PERID,       PERSON.VIDFLG,        PERSON.DELFLG,     " & vbLf & _
'              "       PERSON.UPDDATE,                                              " & vbLf & _
'              "       PERSON.UPDUSER,     PERSON.LASTNAME,      PERSON.FIRSTNAME,  " & vbLf & _
'              "       PERSON.LASTKNAME,   PERSON.FIRSTKNAME,    PERSON.BIRTH,      " & vbLf & _
'              "       PERSON.ROMENAME,                                             " & vbLf & _
'              "       PERSON.GENDER,      PERSON.POSTCARDADDR,  PERSON.MAIDENNAME, " & vbLf & _
'              "       PERSON.NATIONCD,    PERSON.COMPPERID,                        " & vbLf & _
'              "       PERSON.SPARE1,      PERSON.SPARE2,                           " & vbLf & _
'              "       PERSON.MEDRNAME,    PERSON.MEDNAME,                          " & vbLf & _
'              "       PERSON.MEDBIRTH,    PERSON.MEDGENDER,     PERSON.MEDUPDDATE, " & vbLf & _
'              "       COMPPERSON.LASTNAME  COMPLASTNAME,                           " & vbLf & _
'              "       COMPPERSON.FIRSTNAME COMPFIRSTNAME,                          " & vbLf & _
'              "       HAINSUSER.USERNAME                                           " & vbLf & _
'              "  FROM HAINSUSER, PERSON COMPPERSON, PERSON                         " & vbLf & _
'              " WHERE PERSON.PERID     = :PERID                                    " & vbLf & _
'              "   AND PERSON.COMPPERID = COMPPERSON.PERID(+)                       " & vbLf & _
'              "   AND PERSON.UPDUSER   = HAINSUSER.USERID(+)                         "
    strStmt = "SELECT PERSON.PERID,       PERSON.VIDFLG,        PERSON.DELFLG,     " & vbLf & _
              "       PERSON.UPDDATE,                                              " & vbLf & _
              "       PERSON.UPDUSER,     PERSON.LASTNAME,      PERSON.FIRSTNAME,  " & vbLf & _
              "       PERSON.LASTKNAME,   PERSON.FIRSTKNAME,    PERSON.BIRTH,      " & vbLf & _
              "       PERSON.ROMENAME,                                             " & vbLf & _
              "       PERSON.GENDER,      PERSON.POSTCARDADDR,  PERSON.MAIDENNAME, " & vbLf & _
              "       PERSON.NATIONCD,    PERSON.COMPPERID,     PERSON.CSLCOUNT,   " & vbLf & _
              "       PERSON.SPARE1,      PERSON.SPARE2,                           " & vbLf & _
              "       PERSON.MEDRNAME,    PERSON.MEDNAME,                          " & vbLf & _
              "       PERSON.MEDBIRTH,    PERSON.MEDGENDER,     PERSON.MEDUPDDATE, " & vbLf & _
              "       COMPPERSON.LASTNAME  COMPLASTNAME,                           " & vbLf & _
              "       COMPPERSON.FIRSTNAME COMPFIRSTNAME,                          " & vbLf & _
              "       HAINSUSER.USERNAME                                           " & vbLf & _
              "  FROM HAINSUSER, PERSON COMPPERSON, PERSON                         " & vbLf & _
              " WHERE PERSON.PERID     = :PERID                                    " & vbLf & _
              "   AND PERSON.COMPPERID = COMPPERSON.PERID(+)                       " & vbLf & _
              "   AND PERSON.UPDUSER   = HAINSUSER.USERID(+)                         "
'## 2004.02.10 Mod End
'## 2004.01.03 Mod End
'## 2003.12.16 Mod End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objRomeName = objFields("ROMENAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")
        Set objPostCardAddr = objFields("POSTCARDADDR")
        Set objMaidenName = objFields("MAIDENNAME")
        Set objNationCd = objFields("NATIONCD")
        Set objCompPerId = objFields("COMPPERID")
        Set objCompLastName = objFields("COMPLASTNAME")
        Set objCompFirstName = objFields("COMPFIRSTNAME")
        Set objVidFlg = objFields("VIDFLG")
        Set objDelFlg = objFields("DELFLG")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objSpare1 = objFields("SPARE1")
        Set objSpare2 = objFields("SPARE2")
        Set objMedRName = objFields("MEDRNAME")
        Set objMedName = objFields("MEDNAME")
'## 2003.12.16 Add By T.Takagi@FSIT 医事情報取得
        Set objMedBirth = objFields("MEDBIRTH")
        Set objMedGender = objFields("MEDGENDER")
'## 2003.12.16 Add End
'## 2004.01.03 Add By T.Takagi@FSIT 医事連携更新日時追加
        Set objMedUpdDate = objFields("MEDUPDDATE")
'## 2004.01.03 Add End
'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
        Set objCslCount = objFields("CSLCOUNT")
'## 2004.02.10 Add End

        '戻り値の設定
        If Not IsMissing(vntLastName) Then vntLastName = objLastName.Value & ""
        If Not IsMissing(vntFirstName) Then vntFirstName = objFirstName.Value & ""
        If Not IsMissing(vntLastKName) Then vntLastKName = objLastKName.Value & ""
        If Not IsMissing(vntFirstKName) Then vntFirstKName = objFirstKName.Value & ""
        If Not IsMissing(vntRomeName) Then vntRomeName = objRomeName.Value & ""
        If Not IsMissing(vntBirth) Then vntBirth = objBirth.Value & ""
        If Not IsMissing(vntGender) Then vntGender = objGender.Value & ""
        If Not IsMissing(vntPostCardAddr) Then vntPostCardAddr = objPostCardAddr.Value & ""
        If Not IsMissing(vntMaidenName) Then vntMaidenName = objMaidenName.Value & ""
        If Not IsMissing(vntNationCd) Then vntNationCd = objNationCd.Value & ""
        If Not IsMissing(vntCompPerId) Then vntCompPerId = objCompPerId.Value & ""
        If Not IsMissing(vntCompLastName) Then vntCompLastName = objCompLastName.Value & ""
        If Not IsMissing(vntCompFirstName) Then vntCompFirstName = objCompFirstName.Value & ""
        If Not IsMissing(vntVidFlg) Then vntVidFlg = objVidFlg.Value & ""
        If Not IsMissing(vntDelFlg) Then vntDelFlg = objDelFlg.Value & ""
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntUpdUser) Then vntUpdUser = objUpdUser.Value & ""
        If Not IsMissing(vntUserName) Then vntUserName = objUserName.Value & ""
        If Not IsMissing(vntSpare1) Then vntSpare1 = objSpare1.Value & ""
        If Not IsMissing(vntSpare2) Then vntSpare2 = objSpare2.Value & ""
        If Not IsMissing(vntMedRName) Then vntMedRName = objMedRName.Value & ""
        If Not IsMissing(vntMedName) Then vntMedName = objMedName.Value & ""
'## 2003.12.16 Add By T.Takagi@FSIT 医事情報取得
        If Not IsMissing(vntMedBirth) Then vntMedBirth = objMedBirth.Value & ""
        If Not IsMissing(vntMedGender) Then vntMedGender = objMedGender.Value & ""
'## 2003.12.16 Add End
'## 2004.01.03 Add By T.Takagi@FSIT 医事連携更新日時追加
        If Not IsMissing(vntMedUpdDate) Then vntMedUpdDate = objMedUpdDate.Value & ""
'## 2004.01.03 Add End
'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
        If Not IsMissing(vntCslCount) Then vntCslCount = objCslCount.Value & ""
'## 2004.02.10 Add End

'## 2003.12.16 Add By T.Takagi@FSIT 医事情報取得
        Set objLastName = Nothing
        Set objFirstName = Nothing
        Set objLastKName = Nothing
        Set objFirstKName = Nothing
        Set objRomeName = Nothing
        Set objBirth = Nothing
        Set objGender = Nothing
        Set objPostCardAddr = Nothing
        Set objMaidenName = Nothing
        Set objNationCd = Nothing
        Set objCompPerId = Nothing
        Set objCompLastName = Nothing
        Set objCompFirstName = Nothing
        Set objVidFlg = Nothing
        Set objDelFlg = Nothing
        Set objUpdDate = Nothing
        Set objUpdUser = Nothing
        Set objUserName = Nothing
        Set objSpare1 = Nothing
        Set objSpare2 = Nothing
        Set objMedRName = Nothing
        Set objMedName = Nothing
        Set objMedBirth = Nothing
        Set objMedGender = Nothing
'## 2004.01.03 Add By T.Takagi@FSIT 医事連携更新日時追加
        Set objMedUpdDate = Nothing
'## 2004.01.03 Add End
'## 2004.02.10 Add By T.Takagi@FSIT 受診回数が存在しない
        Set objCslCount = Nothing
'## 2004.02.10 Add End
        Set objFields = Nothing
'## 2003.12.16 Add End

        SelectPerson_lukes = True
        
    End If

'## 2003.12.16 Add By T.Takagi@FSIT 医事情報取得
    Set objOraDyna = Nothing
'## 2003.12.16 Add End

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
'## 2003.12.16 Add By T.Takagi@FSIT 医事情報取得
    Set objOraParam = Nothing
'## 2003.12.16 Add End
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerson_lukes = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPerson_lukes"
    
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
' 2008,04,18 受診情報取得のため追加
'
' 機能　　 : 指定個人ＩＤの受診情報を取得する ## 聖路加バージョン ##
'
' 引数　　 : (In)     strPerId          個人ＩＤ
' 　　　　   (Out)    lngRsvNo          最後受診予約番号
' 　　　　   (Out)    strPerCmt         個人・受診コメント有無
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectPerson_note( _
    ByVal strPerId As String, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntPerCmt As Variant _
) As Long


    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '最後受診予約番号
    Dim objPerCmt           As OraField         '個人・受診コメント有無
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理

    SelectPerson_note = 0
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntPerCmt) Then vntPerCmt = Empty

    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2

    strStmt = "SELECT MAX(RSVNO)          RSVNO,                                     " & vbLf & _
              "       DECODE(SUM(PERPUB),0,0,1) + DECODE(SUM(CSLPUB),0,0,1) PERCMT   " & vbLf & _
              " FROM (                                                               " & vbLf & _
              "       SELECT CNTALL.PERID    PERID,                                  " & vbLf & _
              "              CNTALL.RSVNO    RSVNO,                                  " & vbLf & _
              "              CNTALL.CSLDATE  CSLDATE,                                " & vbLf & _
              "              ( SELECT COUNT(PERPUBNOTE.PUBNOTE)                      " & vbLf & _
              "                  FROM PERPUBNOTE                                     " & vbLf & _
              "                 WHERE CNTALL.PERID = PERPUBNOTE.PERID                " & vbLf & _
              "                   AND PERPUBNOTE.DELFLG IS NULL                      " & vbLf & _
              "              ) PERPUB,                                               " & vbLf & _
              "              ( SELECT COUNT(CSLPUBNOTE.PUBNOTE)                      " & vbLf & _
              "                  FROM CSLPUBNOTE                                     " & vbLf & _
              "                 WHERE CNTALL.RSVNO = CSLPUBNOTE.RSVNO                " & vbLf & _
              "                   AND CSLPUBNOTE.DELFLG IS NULL                      " & vbLf & _
              "              ) CSLPUB                                                "
    strStmt = strStmt & vbLf & _
              "         FROM ( SELECT PERID,                                         " & vbLf & _
              "                       RSVNO,                                         " & vbLf & _
              "                       CSLDATE                                        " & vbLf & _
              "                  FROM CONSULT                                        " & vbLf & _
              "                 WHERE CONSULT.PERID = :PERID                         " & vbLf & _
              "                   AND CONSULT.CANCELFLG = 0                          " & vbLf & _
              "              ) CNTALL                                                " & vbLf & _
              "      ) RESUM                                                         "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objPerCmt = objFields("PERCMT")

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = objRsvNo.Value & ""
        If Not IsMissing(vntPerCmt) Then vntPerCmt = objPerCmt.Value & ""
        
        SelectPerson_note = 1
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
     Set objOraDyna = Nothing

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPerson_note = 0
    
    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPerson_note"
    
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
' 機能　　 : 個人ＩＤをキーに個人テーブルを読み込む
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (Out)    vntVidFlg             仮IDフラグ
' 　　　　 : (Out)    vntLastName           姓
' 　　　　 : (Out)    vntFirstName          名
' 　　　　 : (Out)    vntLastKName          カナ姓
' 　　　　 : (Out)    vntFirstKName         カナ名
' 　　　　 : (Out)    vntBirth              生年月日
' 　　　　 : (Out)    vntGender             性別
' 　　　　 : (Out)    vntSupportFlg         本人扶養区分
' 　　　　 : (Out)    vntSpare1             予備１
' 　　　　 : (Out)    vntSpare2             予備２
' 　　　　 : (Out)    vntUpdDate            更新日付
' 　　　　 : (Out)    vntUpdUser            更新者
' 　　　　 : (Out)    vntOrgCd1             所属団体コード１
' 　　　　 : (Out)    vntOrgCd2             所属団体コード２
' 　　　　 : (Out)    vntOrgPostCd          所属部署コード
' 　　　　 : (Out)    vntTel1               電話番号１-市外局番
' 　　　　 : (Out)    vntTel2               電話番号１-局番
' 　　　　 : (Out)    vntTel3               電話番号１-番号
' 　　　　 : (Out)    vntExtension          内線
' 　　　　 : (Out)    vntSubTel1            電話番号２-市外局番
' 　　　　 : (Out)    vntSubTel2            電話番号２-局番
' 　　　　 : (Out)    vntSubTel3            電話番号２-番号
' 　　　　 : (Out)    vntFax1               ＦＡＸ番号-市外局番
' 　　　　 : (Out)    vntFax2               ＦＡＸ番号-局番
' 　　　　 : (Out)    vntFax3               ＦＡＸ番号-番号
' 　　　　 : (Out)    vntPhone1             携帯-市外局番
' 　　　　 : (Out)    vntPhone2             携帯-局番
' 　　　　 : (Out)    vntPhone3             携帯-番号
' 　　　　 : (Out)    vntEMail              e-Mail
' 　　　　 : (Out)    vntZipCd1             郵便番号１
' 　　　　 : (Out)    vntZipCd2             郵便番号２
' 　　　　 : (Out)    vntPrefCD             都道府県コード
' 　　　　 : (Out)    vntCityName           市区町村名
' 　　　　 : (Out)    vntAddress1           住所１
' 　　　　 : (Out)    vntAddress2           住所２
' 　　　　 : (Out)    vntMarriage           婚姻区分
' 　　　　 : (Out)    vntIsrNo              保険者番号
' 　　　　 : (Out)    vntIsrSign            健保記号（記号）
' 　　　　 : (Out)    vntIsrMark            健保記号（符号）
' 　　　　 : (Out)    vntHeIsrNo            健保番号
' 　　　　 : (Out)    vntIsrDiv             保険区分
' 　　　　 : (Out)    vntResidentNo         住民番号
' 　　　　 : (Out)    vntUnionNo            組合番号
' 　　　　 : (Out)    vntKarte              カルテ番号
' 　　　　 : (Out)    vntEmpNo              従業員番号
' 　　　　 : (Out)    vntNotes              特記事項
' 　　　　 : (Out)    vntSpare3             予備１（個人属性）
' 　　　　 : (Out)    vntSpare4             予備２（個人属性）
' 　　　　 : (Out)    vntSpare5             予備３（個人属性）
' 　　　　 : (Out)    vntSpare6             予備４（個人属性）
' 　　　　 : (Out)    vntSpare7             予備５（個人属性）
' 　　　　 : (Out)    vntGenderName         Optional-性別（名称）
' 　　　　 : (Out)    vntBirthYear          Optional-生年月日（年）
' 　　　　 : (Out)    vntBirthMonth         Optional-生年月日（月）
' 　　　　 : (Out)    vntBirthDay           Optional-生年月日（日）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 : Optional 生年月日は年、月、日すべての引数が渡された場合、結果を返す
'
Public Function SelectPerson_old(ByVal strPerId As String, _
                             ByRef vntVidFlg As Variant, ByRef vntLastName As Variant, ByRef vntFirstName As Variant, _
                             ByRef vntLastKName As Variant, ByRef vntFirstKName As Variant, ByRef vntBirth As Variant, _
                             ByRef vntGender As Variant, ByRef vntSupportFlg As Variant, ByRef vntSpare1 As Variant, _
                             ByRef vntSpare2 As Variant, ByRef vntUpdDate As Variant, ByRef vntUpdUser As Variant, _
                             ByRef vntOrgCd1 As Variant, ByRef vntOrgCd2 As Variant, ByRef vntOrgPostCd As Variant, _
                             ByRef vntTel1 As Variant, ByRef vntTel2 As Variant, ByRef vntTel3 As Variant, _
                             ByRef vntExtension As Variant, ByRef vntSubTel1 As Variant, ByRef vntSubTel2 As Variant, _
                             ByRef vntSubTel3 As Variant, ByRef vntFax1 As Variant, ByRef vntFax2 As Variant, _
                             ByRef vntFax3 As Variant, ByRef vntPhone1 As Variant, ByRef vntPhone2 As Variant, _
                             ByRef vntPhone3 As Variant, ByRef vntEMail As Variant, ByRef vntZipCd1 As Variant, _
                             ByRef vntZipCd2 As Variant, ByRef vntPrefCd As Variant, ByRef vntCityName As Variant, _
                             ByRef vntAddress1 As Variant, ByRef vntAddress2 As Variant, ByRef vntMarriage As Variant, _
                             ByRef vntIsrNo As Variant, ByRef vntIsrSign As Variant, ByRef vntIsrMark As Variant, _
                             ByRef vntHeIsrNo As Variant, ByRef vntIsrDiv As Variant, ByRef vntResidentNo As Variant, _
                             ByRef vntUnionNo As Variant, ByRef vntKarte As Variant, ByRef vntEmpNo As Variant, _
                             ByRef vntNotes As Variant, ByRef vntSpare3 As Variant, ByRef vntSpare4 As Variant, _
                             ByRef vntSpare5 As Variant, ByRef vntSpare6 As Variant, ByRef vntSpare7 As Variant, _
                             Optional ByRef vntBirthYear As Variant, Optional ByRef vntBirthMonth As Variant, Optional ByRef vntBirthDay As Variant, _
                             Optional ByRef vntGenderName As Variant, Optional ByRef vntPrefName As Variant _
                            ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objVidFlg               As OraField         '仮IDフラグ
    Dim objLastName             As OraField         '姓
    Dim objFirstName            As OraField         '名
    Dim objLastKName            As OraField         'カナ姓
    Dim objFirstKName           As OraField         'カナ名
    Dim objBirth                As OraField         '生年月日
    Dim objGender               As OraField         '性別
    Dim objSupportFlg           As OraField         '本人扶養区分
    Dim objSpare1               As OraField         '予備１（個人）
    Dim objSpare2               As OraField         '予備２（個人）
    Dim objUpdDate              As OraField         '更新日付
    Dim objUpdUser              As OraField         '更新者
    Dim objOrgCd1               As OraField         '所属団体コード１
    Dim objOrgCd2               As OraField         '所属団体コード２
    Dim objOrgPostCd            As OraField         '所属部署コード
    Dim objTel1                 As OraField         '電話番号１-市外局番
    Dim objTel2                 As OraField         '電話番号１-局番
    Dim objTel3                 As OraField         '電話番号１-番号
    Dim objExtension            As OraField         '内線
    Dim objSubTel1              As OraField         '電話番号２-市外局番
    Dim objSubTel2              As OraField         '電話番号２-局番
    Dim objSubTel3              As OraField         '電話番号２-番号
    Dim objFax1                 As OraField         'ＦＡＸ番号-市外局番
    Dim objFax2                 As OraField         'ＦＡＸ番号-局番
    Dim objFax3                 As OraField         'ＦＡＸ番号-番号
    Dim objPhone1               As OraField         '携帯-市外局番
    Dim objPhone2               As OraField         '携帯-局番
    Dim objPhone3               As OraField         '携帯-番号
    Dim objEMail                As OraField         'e-Mail
    Dim objZipCd1               As OraField         '郵便番号１
    Dim objZipCd2               As OraField         '郵便番号２
    Dim objPrefCd               As OraField         '都道府県コード
    Dim objCityName             As OraField         '市区町村名
    Dim objAddress1             As OraField         '住所１
    Dim objAddress2             As OraField         '住所２
    Dim objMarriage             As OraField         '婚姻区分
    Dim objIsrNo                As OraField         '保険者番号
    Dim objIsrSign              As OraField         '健保記号（記号）
    Dim objIsrMark              As OraField         '健保記号（符号）
    Dim objHeIsrNo              As OraField         '健保番号
    Dim objIsrDiv               As OraField         '保険区分
    Dim objResidentNo           As OraField         '住民番号
    Dim objUnionNo              As OraField         '組合番号
    Dim objKarte                As OraField         'カルテ番号
    Dim objEmpNo                As OraField         '従業員番号
    Dim objNotes                As OraField         '特記事項
    Dim objSpare3               As OraField         '予備１（個人属性）
    Dim objSpare4               As OraField         '予備２（個人属性）
    Dim objSpare5               As OraField         '予備３（個人属性）
    Dim objSpare6               As OraField         '予備４（個人属性）
    Dim objSpare7               As OraField         '予備５（個人属性）
    Dim objGenderName           As OraField         '性別（名称）
    Dim objPrefName             As OraField         '都道府県名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strPerId) = "" Then
        Exit Function
    End If
        
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT
    objOraParam.Add "DELFLG", DELFLG_USED, ORAPARM_INPUT
    
    '検索条件を満たす個人テーブルのレコードを取得
    strStmt = "SELECT p.VIDFLG,     p.LASTNAME,     p.FIRSTNAME,    " & vbLf & _
              "       p.LASTKNAME,  p.FIRSTKNAME,   p.BIRTH,        " & vbLf & _
              "       p.GENDER,     p.SUPPORTFLG,   p.SPARE1,       " & vbLf & _
              "       p.SPARE2,     p.UPDDATE,      p.UPDUSER,      " & vbLf & _
              "       p.ORGCD1,     p.ORGCD2,       p.ORGPOSTCD,   " & vbLf & _
              "       pd.TEL1,      pd.TEL2,        pd.TEL3,        " & vbLf & _
              "       pd.EXTENSION, pd.SUBTEL1,     pd.SUBTEL2,     " & vbLf & _
              "       pd.SUBTEL3,   pd.FAX1,        pd.FAX2,        " & vbLf & _
              "       pd.FAX3,      pd.PHONE1,      pd.PHONE2,      " & vbLf & _
              "       pd.PHONE3,    pd.EMAIL,       pd.ZIPCD1,      " & vbLf & _
              "       pd.ZIPCD2,    pd.PREFCD,      pd.CITYNAME,    " & vbLf & _
              "       pd.ADDRESS1,  pd.ADDRESS2,    pd.MARRIAGE,    " & vbLf & _
              "       p.ISRNO,      pd.ISRSIGN,     pd.ISRMARK,     " & vbLf & _
              "       pd.HEISRNO,   pd.ISRDIV,      pd.RESIDENTNO,  " & vbLf & _
              "       pd.UNIONNO,   pd.KARTE,       pd.EMPNO,       " & vbLf & _
              "       pd.NOTES,     pd.SPARE1 D_SPARE1,             " & vbLf & _
              "       pd.SPARE2 D_SPARE2,   pd.SPARE3 D_SPARE3,     " & vbLf & _
              "       pd.SPARE4 D_SPARE4,   pd.SPARE5 D_SPARE5,     " & vbLf & _
              "       DECODE(GENDER,'1','男性','2','女性',NULL) GENDERNAME, " & vbLf & _
              "       pf.PREFNAME                                   " & vbLf & _
              "  FROM PERSON p,     PERSONDETAIL pd,    PREF pf     "

    strStmt = strStmt & vbLf & _
              " WHERE p.PERID   = :PERID                            " & vbLf & _
              "   AND p.DELFLG  = :DELFLG                           " & vbLf & _
              "   AND p.PERID   = pd.PERID(+)                       " & vbLf & _
              "   AND pd.PREFCD = pf.PREFCD(+)                      "
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objVidFlg = objFields("VIDFLG")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")
        Set objSupportFlg = objFields("SUPPORTFLG")
        Set objSpare1 = objFields("SPARE1")
        Set objSpare2 = objFields("SPARE2")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgPostCd = objFields("ORGPOSTCD")
        Set objTel1 = objFields("TEL1")
        Set objTel2 = objFields("TEL2")
        Set objTel3 = objFields("TEL3")
        Set objExtension = objFields("EXTENSION")
        Set objSubTel1 = objFields("SUBTEL1")
        Set objSubTel2 = objFields("SUBTEL2")
        Set objSubTel3 = objFields("SUBTEL3")
        Set objFax1 = objFields("FAX1")
        Set objFax2 = objFields("FAX2")
        Set objFax3 = objFields("FAX3")
        Set objPhone1 = objFields("PHONE1")
        Set objPhone2 = objFields("PHONE2")
        Set objPhone3 = objFields("PHONE3")
        Set objEMail = objFields("EMAIL")
        Set objZipCd1 = objFields("ZIPCD1")
        Set objZipCd2 = objFields("ZIPCD2")
        Set objPrefCd = objFields("PREFCD")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
        Set objMarriage = objFields("MARRIAGE")
        Set objIsrNo = objFields("ISRNO")
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrMark = objFields("ISRMARK")
        Set objHeIsrNo = objFields("HEISRNO")
        Set objIsrDiv = objFields("ISRDIV")
        Set objResidentNo = objFields("RESIDENTNO")
        Set objUnionNo = objFields("UNIONNO")
        Set objKarte = objFields("KARTE")
        Set objEmpNo = objFields("EMPNO")
        Set objNotes = objFields("NOTES")
        Set objSpare3 = objFields("D_SPARE1")
        Set objSpare4 = objFields("D_SPARE2")
        Set objSpare5 = objFields("D_SPARE3")
        Set objSpare6 = objFields("D_SPARE4")
        Set objSpare7 = objFields("D_SPARE5")
        Set objGenderName = objFields("GENDERNAME")
        Set objPrefName = objFields("PREFNAME")
        
        '戻り値の設定
        vntVidFlg = objVidFlg.Value & ""
        vntLastName = objLastName.Value & ""
        vntFirstName = objFirstName.Value & ""
        vntLastKName = objLastKName.Value & ""
        vntFirstKName = objFirstKName.Value & ""
        vntBirth = objBirth.Value & ""
        vntGender = objGender.Value & ""
        vntSupportFlg = objSupportFlg.Value & ""
        vntSpare1 = objSpare1.Value & ""
        vntSpare2 = objSpare2.Value & ""
        vntUpdDate = objUpdDate.Value & ""
        vntUpdUser = objUpdUser.Value & ""
        vntOrgCd1 = objOrgCd1.Value & ""
        vntOrgCd2 = objOrgCd2.Value & ""
        vntOrgPostCd = objOrgPostCd.Value & ""
        vntTel1 = objTel1.Value & ""
        vntTel2 = objTel2.Value & ""
        vntTel3 = objTel3.Value & ""
        vntExtension = objExtension.Value & ""
        vntSubTel1 = objSubTel1.Value & ""
        vntSubTel2 = objSubTel2.Value & ""
        vntSubTel3 = objSubTel3.Value & ""
        vntFax1 = objFax1.Value & ""
        vntFax2 = objFax2.Value & ""
        vntFax3 = objFax3.Value & ""
        vntPhone1 = objPhone1.Value & ""
        vntPhone2 = objPhone2.Value & ""
        vntPhone3 = objPhone3.Value & ""
        vntEMail = objEMail.Value & ""
        vntZipCd1 = objZipCd1.Value & ""
        vntZipCd2 = objZipCd2.Value & ""
        vntPrefCd = objPrefCd.Value & ""
        vntCityName = objCityName.Value & ""
        vntAddress1 = objAddress1.Value & ""
        vntAddress2 = objAddress2.Value & ""
        vntMarriage = objMarriage.Value & ""
        vntIsrNo = objIsrNo.Value & ""
        vntIsrSign = objIsrSign.Value & ""
        vntIsrMark = objIsrMark.Value & ""
        vntHeIsrNo = objHeIsrNo.Value & ""
        vntIsrDiv = objIsrDiv.Value & ""
        vntResidentNo = objResidentNo.Value & ""
        vntUnionNo = objUnionNo.Value & ""
        vntKarte = objKarte.Value & ""
        vntEmpNo = objEmpNo.Value & ""
        vntNotes = objNotes.Value & ""
        vntSpare3 = objSpare3.Value & ""
        vntSpare4 = objSpare4.Value & ""
        vntSpare5 = objSpare5.Value & ""
        vntSpare6 = objSpare6.Value & ""
        vntSpare7 = objSpare7.Value & ""
        If Not IsMissing(vntGenderName) Then
            vntGenderName = objGenderName.Value & ""
        End If
        If IsDate(vntBirth) Then
            If Not IsMissing(vntBirthYear) And Not IsMissing(vntBirthMonth) And Not IsMissing(vntBirthDay) Then
                vntBirthYear = Year(vntBirth)
                vntBirthMonth = Month(vntBirth)
                vntBirthDay = Day(vntBirth)
            End If
        End If
        If Not IsMissing(vntPrefName) Then
            vntPrefName = objPrefName.Value & ""
        End If
        
        SelectPerson_old = True
        
    End If

    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.SelectPerson_old"
    
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
' 機能　　 : 指定個人ＩＤの個人属性情報を取得する　## 聖路加バージョン ##
'
' 引数　　 : (In)     strPerId       個人ＩＤ
' 　　　　   (Out)    vntMarriage    婚姻区分
' 　　　　   (Out)    vntResidentNo  住民番号
' 　　　　   (Out)    vntUnionNo     組合番号
' 　　　　   (Out)    vntKarte       カルテ番号
' 　　　　   (Out)    vntNotes       特記事項
' 　　　　   (Out)    vntSpare1      予備１
' 　　　　   (Out)    vntSpare2      予備２
' 　　　　   (Out)    vntSpare3      予備３
' 　　　　   (Out)    vntSpare4      予備４
' 　　　　   (Out)    vntSpare5      予備５
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPersonDetail_lukes( _
    ByVal strPerId As String, _
    Optional ByRef vntMarriage As Variant, _
    Optional ByRef vntResidentNo As Variant, _
    Optional ByRef vntUnionNo As Variant, _
    Optional ByRef vntKarte As Variant, _
    Optional ByRef vntNotes As Variant, _
    Optional ByRef vntSpare1 As Variant, _
    Optional ByRef vntSpare2 As Variant, _
    Optional ByRef vntSpare3 As Variant, _
    Optional ByRef vntSpare4 As Variant, _
    Optional ByRef vntSpare5 As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objMarriage     As OraField         '婚姻区分
    Dim objResidentNo   As OraField         '住民番号
    Dim objUnionNo      As OraField         '組合番号
    Dim objKarte        As OraField         'カルテ番号
    Dim objNotes        As OraField         '特記事項
    Dim objSpare1       As OraField         '予備１
    Dim objSpare2       As OraField         '予備２
    Dim objSpare3       As OraField         '予備３
    Dim objSpare4       As OraField         '予備４
    Dim objSpare5       As OraField         '予備５

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntMarriage) Then
        vntMarriage = Empty
    End If

    If Not IsMissing(vntResidentNo) Then
        vntResidentNo = Empty
    End If

    If Not IsMissing(vntUnionNo) Then
        vntUnionNo = Empty
    End If

    If Not IsMissing(vntKarte) Then
        vntKarte = Empty
    End If

    If Not IsMissing(vntNotes) Then
        vntNotes = Empty
    End If

    If Not IsMissing(vntSpare1) Then
        vntSpare1 = Empty
    End If

    If Not IsMissing(vntSpare2) Then
        vntSpare2 = Empty
    End If

    If Not IsMissing(vntSpare3) Then
        vntSpare3 = Empty
    End If

    If Not IsMissing(vntSpare4) Then
        vntSpare4 = Empty
    End If

    If Not IsMissing(vntSpare5) Then
        vntSpare5 = Empty
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす個人属性テーブルのレコードを取得
    strStmt = "SELECT PERSONDETAIL.MARRIAGE,                                                  " & vbLf & _
              "       PERSONDETAIL.RESIDENTNO, PERSONDETAIL.UNIONNO,                          " & vbLf & _
              "       PERSONDETAIL.KARTE,     PERSONDETAIL.NOTES,      PERSONDETAIL.SPARE1,   " & vbLf & _
              "       PERSONDETAIL.SPARE2,    PERSONDETAIL.SPARE3,     PERSONDETAIL.SPARE4,   " & vbLf & _
              "       PERSONDETAIL.SPARE5,    PREF.PREFNAME                                   " & vbLf & _
              "  FROM PREF, PERSONDETAIL                                                      " & vbLf & _
              " WHERE PERSONDETAIL.PERID  = :PERID                                            "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objMarriage = objFields("MARRIAGE")
        Set objResidentNo = objFields("RESIDENTNO")
        Set objUnionNo = objFields("UNIONNO")
        Set objKarte = objFields("KARTE")
        Set objNotes = objFields("NOTES")
        Set objSpare1 = objFields("SPARE1")
        Set objSpare2 = objFields("SPARE2")
        Set objSpare3 = objFields("SPARE3")
        Set objSpare4 = objFields("SPARE4")
        Set objSpare5 = objFields("SPARE5")

        '戻り値の設定
        If Not IsMissing(vntMarriage) Then
            vntMarriage = objMarriage.Value & ""
        End If

        If Not IsMissing(vntResidentNo) Then
            vntResidentNo = objResidentNo.Value & ""
        End If

        If Not IsMissing(vntUnionNo) Then
            vntUnionNo = objUnionNo.Value & ""
        End If

        If Not IsMissing(vntKarte) Then
            vntKarte = objKarte.Value & ""
        End If

        If Not IsMissing(vntNotes) Then
            vntNotes = objNotes.Value & ""
        End If


        If Not IsMissing(vntSpare1) Then
            vntSpare1 = objSpare1.Value & ""
        End If

        If Not IsMissing(vntSpare2) Then
            vntSpare2 = objSpare2.Value & ""
        End If

        If Not IsMissing(vntSpare3) Then
            vntSpare3 = objSpare3.Value & ""
        End If

        If Not IsMissing(vntSpare4) Then
            vntSpare4 = objSpare4.Value & ""
        End If

        If Not IsMissing(vntSpare5) Then
            vntSpare5 = objSpare5.Value & ""
        End If

        SelectPersonDetail_lukes = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPersonDetail_lukes = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPersonDetail_lukes"
    
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
' 機能　　 : 指定個人ＩＤの個人属性情報を取得する
'
' 引数　　 : (In)     strPerId       個人ＩＤ
' 　　　　   (Out)    vntZipCd1      郵便番号１
' 　　　　   (Out)    vntZipCd2      郵便番号２
' 　　　　   (Out)    vntPrefCd      都道府県コード
' 　　　　   (Out)    vntPrefName    都道府県名
' 　　　　   (Out)    vntCityName    市区町村名
' 　　　　   (Out)    vntAddress1    住所１
' 　　　　   (Out)    vntAddress2    住所２
' 　　　　   (Out)    vntTel1        電話番号１－市外局番
' 　　　　   (Out)    vntTel2        電話番号１－局番
' 　　　　   (Out)    vntTel3        電話番号１－番号
' 　　　　   (Out)    vntExtension   内線１
' 　　　　   (Out)    vntSubTel1     電話番号２－市外局番
' 　　　　   (Out)    vntSubTel2     電話番号２－局番
' 　　　　   (Out)    vntSubTel3     電話番号２－番号
' 　　　　   (Out)    vntFax1        ＦＡＸ－市外局番
' 　　　　   (Out)    vntFax2        ＦＡＸ－局番
' 　　　　   (Out)    vntFax3        ＦＡＸ－番号
' 　　　　   (Out)    vntPhone1      携帯－市外局番
' 　　　　   (Out)    vntPhone2      携帯－局番
' 　　　　   (Out)    vntPhone3      携帯－番号
' 　　　　   (Out)    vntEMail       e-Mail
' 　　　　   (Out)    vntMarriage    婚姻区分
' 　　　　   (Out)    vntIsrDiv      保険区分
' 　　　　   (Out)    vntResidentNo  住民番号
' 　　　　   (Out)    vntUnionNo     組合番号
' 　　　　   (Out)    vntKarte       カルテ番号
' 　　　　   (Out)    vntNotes       特記事項
' 　　　　   (Out)    vntSpare1      予備１
' 　　　　   (Out)    vntSpare2      予備２
' 　　　　   (Out)    vntSpare3      予備３
' 　　　　   (Out)    vntSpare4      予備４
' 　　　　   (Out)    vntSpare5      予備５
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPersonDetail( _
    ByVal strPerId As String, _
    Optional ByRef vntZipCd1 As Variant, Optional ByRef vntZipCd2 As Variant, _
    Optional ByRef vntPrefCd As Variant, Optional ByRef vntPrefName As Variant, _
    Optional ByRef vntCityName As Variant, _
    Optional ByRef vntAddress1 As Variant, _
    Optional ByRef vntAddress2 As Variant, _
    Optional ByRef vntTel1 As Variant, Optional ByRef vntTel2 As Variant, Optional ByRef vntTel3 As Variant, _
    Optional ByRef vntExtension As Variant, _
    Optional ByRef vntSubTel1 As Variant, Optional ByRef vntSubTel2 As Variant, Optional ByRef vntSubTel3 As Variant, _
    Optional ByRef vntFax1 As Variant, Optional ByRef vntFax2 As Variant, Optional ByRef vntFax3 As Variant, _
    Optional ByRef vntPhone1 As Variant, Optional ByRef vntPhone2 As Variant, Optional ByRef vntPhone3 As Variant, _
    Optional ByRef vntEMail As Variant, _
    Optional ByRef vntMarriage As Variant, _
    Optional ByRef vntIsrDiv As Variant, _
    Optional ByRef vntResidentNo As Variant, _
    Optional ByRef vntUnionNo As Variant, _
    Optional ByRef vntKarte As Variant, _
    Optional ByRef vntNotes As Variant, _
    Optional ByRef vntSpare1 As Variant, _
    Optional ByRef vntSpare2 As Variant, _
    Optional ByRef vntSpare3 As Variant, _
    Optional ByRef vntSpare4 As Variant, _
    Optional ByRef vntSpare5 As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objZipCd1       As OraField         '郵便番号１
    Dim objZipCd2       As OraField         '郵便番号２
    Dim objPrefCd       As OraField         '都道府県コード
    Dim objPrefName     As OraField         '都道府県名
    Dim objCityName     As OraField         '市区町村名
    Dim objAddress1     As OraField         '住所１
    Dim objAddress2     As OraField         '住所２
    Dim objTel1         As OraField         '電話番号１－市外局番
    Dim objTel2         As OraField         '電話番号１－局番
    Dim objTel3         As OraField         '電話番号１－番号
    Dim objExtension    As OraField         '内線１
    Dim objSubTel1      As OraField         '電話番号２－市外局番
    Dim objSubTel2      As OraField         '電話番号２－局番
    Dim objSubTel3      As OraField         '電話番号２－番号
    Dim objFax1         As OraField         'ＦＡＸ－市外局番
    Dim objFax2         As OraField         'ＦＡＸ－局番
    Dim objFax3         As OraField         'ＦＡＸ－番号
    Dim objPhone1       As OraField         '携帯－市外局番
    Dim objPhone2       As OraField         '携帯－局番
    Dim objPhone3       As OraField         '携帯－番号
    Dim objEMail        As OraField         'e-Mail
    Dim objMarriage     As OraField         '婚姻区分
    Dim objIsrDiv       As OraField         '保険区分
    Dim objResidentNo   As OraField         '住民番号
    Dim objUnionNo      As OraField         '組合番号
    Dim objKarte        As OraField         'カルテ番号
    Dim objNotes        As OraField         '特記事項
    Dim objSpare1       As OraField         '予備１
    Dim objSpare2       As OraField         '予備２
    Dim objSpare3       As OraField         '予備３
    Dim objSpare4       As OraField         '予備４
    Dim objSpare5       As OraField         '予備５

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntZipCd1) Then
        vntZipCd1 = Empty
    End If

    If Not IsMissing(vntZipCd2) Then
        vntZipCd2 = Empty
    End If

    If Not IsMissing(vntPrefCd) Then
        vntPrefCd = Empty
    End If

    If Not IsMissing(vntPrefName) Then
        vntPrefName = Empty
    End If

    If Not IsMissing(vntCityName) Then
        vntCityName = Empty
    End If

    If Not IsMissing(vntAddress1) Then
        vntAddress1 = Empty
    End If

    If Not IsMissing(vntAddress2) Then
        vntAddress2 = Empty
    End If

    If Not IsMissing(vntTel1) Then
        vntTel1 = Empty
    End If

    If Not IsMissing(vntTel2) Then
        vntTel2 = Empty
    End If

    If Not IsMissing(vntTel3) Then
        vntTel3 = Empty
    End If

    If Not IsMissing(vntExtension) Then
        vntExtension = Empty
    End If

    If Not IsMissing(vntSubTel1) Then
        vntSubTel1 = Empty
    End If

    If Not IsMissing(vntSubTel2) Then
        vntSubTel2 = Empty
    End If

    If Not IsMissing(vntSubTel3) Then
        vntSubTel3 = Empty
    End If

    If Not IsMissing(vntFax1) Then
        vntFax1 = Empty
    End If

    If Not IsMissing(vntFax2) Then
        vntFax2 = Empty
    End If

    If Not IsMissing(vntFax3) Then
        vntFax3 = Empty
    End If

    If Not IsMissing(vntPhone1) Then
        vntPhone1 = Empty
    End If

    If Not IsMissing(vntPhone2) Then
        vntPhone2 = Empty
    End If

    If Not IsMissing(vntPhone3) Then
        vntPhone3 = Empty
    End If

    If Not IsMissing(vntEMail) Then
        vntEMail = Empty
    End If

    If Not IsMissing(vntMarriage) Then
        vntMarriage = Empty
    End If

    If Not IsMissing(vntIsrDiv) Then
        vntIsrDiv = Empty
    End If

    If Not IsMissing(vntResidentNo) Then
        vntResidentNo = Empty
    End If

    If Not IsMissing(vntUnionNo) Then
        vntUnionNo = Empty
    End If

    If Not IsMissing(vntKarte) Then
        vntKarte = Empty
    End If

    If Not IsMissing(vntNotes) Then
        vntNotes = Empty
    End If

    If Not IsMissing(vntSpare1) Then
        vntSpare1 = Empty
    End If

    If Not IsMissing(vntSpare2) Then
        vntSpare2 = Empty
    End If

    If Not IsMissing(vntSpare3) Then
        vntSpare3 = Empty
    End If

    If Not IsMissing(vntSpare4) Then
        vntSpare4 = Empty
    End If

    If Not IsMissing(vntSpare5) Then
        vntSpare5 = Empty
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす個人属性テーブルのレコードを取得
    strStmt = "SELECT PERSONDETAIL.TEL1,      PERSONDETAIL.TEL2,       PERSONDETAIL.TEL3,     " & vbLf & _
              "       PERSONDETAIL.EXTENSION, PERSONDETAIL.SUBTEL1,    PERSONDETAIL.SUBTEL2,  " & vbLf & _
              "       PERSONDETAIL.SUBTEL3,   PERSONDETAIL.FAX1,       PERSONDETAIL.FAX2,     " & vbLf & _
              "       PERSONDETAIL.FAX3,      PERSONDETAIL.PHONE1,     PERSONDETAIL.PHONE2,   " & vbLf & _
              "       PERSONDETAIL.PHONE3,    PERSONDETAIL.EMAIL,      PERSONDETAIL.ZIPCD1,   " & vbLf & _
              "       PERSONDETAIL.ZIPCD2,    PERSONDETAIL.PREFCD,     PERSONDETAIL.CITYNAME, " & vbLf & _
              "       PERSONDETAIL.ADDRESS1,  PERSONDETAIL.ADDRESS2,   PERSONDETAIL.MARRIAGE, " & vbLf & _
              "       PERSONDETAIL.ISRDIV,    PERSONDETAIL.RESIDENTNO, PERSONDETAIL.UNIONNO,  " & vbLf & _
              "       PERSONDETAIL.KARTE,     PERSONDETAIL.NOTES,      PERSONDETAIL.SPARE1,   " & vbLf & _
              "       PERSONDETAIL.SPARE2,    PERSONDETAIL.SPARE3,     PERSONDETAIL.SPARE4,   " & vbLf & _
              "       PERSONDETAIL.SPARE5,    PREF.PREFNAME                                   " & vbLf & _
              "  FROM PREF, PERSONDETAIL                                                      " & vbLf & _
              " WHERE PERSONDETAIL.PERID  = :PERID                                            " & vbLf & _
              "   AND PERSONDETAIL.PREFCD = PREF.PREFCD(+)                                    "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
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
        Set objExtension = objFields("EXTENSION")
        Set objSubTel1 = objFields("SUBTEL1")
        Set objSubTel2 = objFields("SUBTEL2")
        Set objSubTel3 = objFields("SUBTEL3")
        Set objFax1 = objFields("FAX1")
        Set objFax2 = objFields("FAX2")
        Set objFax3 = objFields("FAX3")
        Set objPhone1 = objFields("PHONE1")
        Set objPhone2 = objFields("PHONE2")
        Set objPhone3 = objFields("PHONE3")
        Set objEMail = objFields("EMAIL")
        Set objMarriage = objFields("MARRIAGE")
        Set objIsrDiv = objFields("ISRDIV")
        Set objResidentNo = objFields("RESIDENTNO")
        Set objUnionNo = objFields("UNIONNO")
        Set objKarte = objFields("KARTE")
        Set objNotes = objFields("NOTES")
        Set objSpare1 = objFields("SPARE1")
        Set objSpare2 = objFields("SPARE2")
        Set objSpare3 = objFields("SPARE3")
        Set objSpare4 = objFields("SPARE4")
        Set objSpare5 = objFields("SPARE5")

        '戻り値の設定
        If Not IsMissing(vntZipCd1) Then
            vntZipCd1 = objZipCd1.Value & ""
        End If

        If Not IsMissing(vntZipCd2) Then
            vntZipCd2 = objZipCd2.Value & ""
        End If

        If Not IsMissing(vntPrefCd) Then
            vntPrefCd = objPrefCd.Value & ""
        End If

        If Not IsMissing(vntPrefName) Then
            vntPrefName = objPrefName.Value & ""
        End If

        If Not IsMissing(vntCityName) Then
            vntCityName = objCityName.Value & ""
        End If

        If Not IsMissing(vntAddress1) Then
            vntAddress1 = objAddress1.Value & ""
        End If

        If Not IsMissing(vntAddress2) Then
            vntAddress2 = objAddress2.Value & ""
        End If

        If Not IsMissing(vntTel1) Then
            vntTel1 = objTel1.Value & ""
        End If

        If Not IsMissing(vntTel2) Then
            vntTel2 = objTel2.Value & ""
        End If

        If Not IsMissing(vntTel3) Then
            vntTel3 = objTel3.Value & ""
        End If

        If Not IsMissing(vntExtension) Then
            vntExtension = objExtension.Value & ""
        End If

        If Not IsMissing(vntSubTel1) Then
            vntSubTel1 = objSubTel1.Value & ""
        End If

        If Not IsMissing(vntSubTel2) Then
            vntSubTel2 = objSubTel2.Value & ""
        End If

        If Not IsMissing(vntSubTel3) Then
            vntSubTel3 = objSubTel3.Value & ""
        End If

        If Not IsMissing(vntFax1) Then
            vntFax1 = objFax1.Value & ""
        End If

        If Not IsMissing(vntFax2) Then
            vntFax2 = objFax2.Value & ""
        End If

        If Not IsMissing(vntFax3) Then
            vntFax3 = objFax3.Value & ""
        End If

        If Not IsMissing(vntPhone1) Then
            vntPhone1 = objPhone1.Value & ""
        End If

        If Not IsMissing(vntPhone2) Then
            vntPhone2 = objPhone2.Value & ""
        End If

        If Not IsMissing(vntPhone3) Then
            vntPhone3 = objPhone3.Value & ""
        End If

        If Not IsMissing(vntEMail) Then
            vntEMail = objEMail.Value & ""
        End If

        If Not IsMissing(vntMarriage) Then
            vntMarriage = objMarriage.Value & ""
        End If

        If Not IsMissing(vntIsrDiv) Then
            vntIsrDiv = objIsrDiv.Value & ""
        End If

        If Not IsMissing(vntResidentNo) Then
            vntResidentNo = objResidentNo.Value & ""
        End If

        If Not IsMissing(vntUnionNo) Then
            vntUnionNo = objUnionNo.Value & ""
        End If

        If Not IsMissing(vntKarte) Then
            vntKarte = objKarte.Value & ""
        End If

        If Not IsMissing(vntNotes) Then
            vntNotes = objNotes.Value & ""
        End If

        If Not IsMissing(vntSpare1) Then
            vntSpare1 = objSpare1.Value & ""
        End If

        If Not IsMissing(vntSpare2) Then
            vntSpare2 = objSpare2.Value & ""
        End If

        If Not IsMissing(vntSpare3) Then
            vntSpare3 = objSpare3.Value & ""
        End If

        If Not IsMissing(vntSpare4) Then
            vntSpare4 = objSpare4.Value & ""
        End If

        If Not IsMissing(vntSpare5) Then
            vntSpare5 = objSpare5.Value & ""
        End If

        SelectPersonDetail = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPersonDetail = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPersonDetail"
    
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
' 機能　　 : 指定個人ＩＤの個人住所情報を取得する
'
' 引数　　 : (In)     strPerId       個人ＩＤ
' 　　　　   (Out)    vntAddrDiv     住所区分
' 　　　　   (Out)    vntZipCd       郵便番号
' 　　　　   (Out)    vntPrefCd      都道府県コード
' 　　　　   (Out)    vntPrefName    都道府県名
' 　　　　   (Out)    vntCityName    市区町村名
' 　　　　   (Out)    vntAddress1    住所１
' 　　　　   (Out)    vntAddress2    住所２
' 　　　　   (Out)    vntTel1        電話番号１
' 　　　　   (Out)    vntPhone       携帯
' 　　　　   (Out)    vntTel2        電話番号２
' 　　　　   (Out)    vntExtension   内線１
' 　　　　   (Out)    vntFax         ＦＡＸ
' 　　　　   (Out)    vntEMail       e-Mail
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPersonAddr( _
    ByVal strPerId As String, _
    Optional ByRef vntAddrDiv As Variant, _
    Optional ByRef vntZipCd As Variant, _
    Optional ByRef vntPrefCd As Variant, _
    Optional ByRef vntPrefName As Variant, _
    Optional ByRef vntCityName As Variant, _
    Optional ByRef vntAddress1 As Variant, _
    Optional ByRef vntAddress2 As Variant, _
    Optional ByRef vntTel1 As Variant, _
    Optional ByRef vntPhone As Variant, _
    Optional ByRef vntTel2 As Variant, _
    Optional ByRef vntExtension As Variant, _
    Optional ByRef vntFax As Variant, _
    Optional ByRef vntEMail As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objAddrDiv          As OraField         '住所区分
    Dim objZipCd            As OraField         '郵便番号
    Dim objPrefCd           As OraField         '都道府県コード
    Dim objPrefName         As OraField         '都道府県名
    Dim objCityName         As OraField         '市区町村名
    Dim objAddress1         As OraField         '住所１
    Dim objAddress2         As OraField         '住所２
    Dim objTel1             As OraField         '電話番号１
    Dim objPhone            As OraField         '携帯
    Dim objTel2             As OraField         '電話番号２
    Dim objExtension        As OraField         '内線１
    Dim objFax              As OraField         'ＦＡＸ
    Dim objEMail            As OraField         'e-Mail
    
    Dim vntArrAddrDiv()     As Variant          '住所区分の配列
    Dim vntArrZipCd()       As Variant          '郵便番号の配列
    Dim vntArrPrefCd()      As Variant          '都道府県コードの配列
    Dim vntArrPrefName()    As Variant          '都道府県名の配列
    Dim vntArrCityName()    As Variant          '市区町村名の配列
    Dim vntArrAddress1()    As Variant          '住所１の配列
    Dim vntArrAddress2()    As Variant          '住所２の配列
    Dim vntArrTel1()        As Variant          '電話番号１の配列
    Dim vntArrPhone()       As Variant          '携帯の配列
    Dim vntArrTel2()        As Variant          '電話番号２の配列
    Dim vntArrExtension()   As Variant          '内線１の配列
    Dim vntArrFax()         As Variant          'ＦＡＸの配列
    Dim vntArrEMail()       As Variant          'e-Mailの配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntAddrDiv) Then vntAddrDiv = Empty
    If Not IsMissing(vntZipCd) Then vntZipCd = Empty
    If Not IsMissing(vntPrefCd) Then vntPrefCd = Empty
    If Not IsMissing(vntPrefName) Then vntPrefName = Empty
    If Not IsMissing(vntCityName) Then vntCityName = Empty
    If Not IsMissing(vntAddress1) Then vntAddress1 = Empty
    If Not IsMissing(vntAddress2) Then vntAddress2 = Empty
    If Not IsMissing(vntTel1) Then vntTel1 = Empty
    If Not IsMissing(vntPhone) Then vntPhone = Empty
    If Not IsMissing(vntTel2) Then vntTel2 = Empty
    If Not IsMissing(vntExtension) Then vntExtension = Empty
    If Not IsMissing(vntFax) Then vntFax = Empty
    If Not IsMissing(vntEMail) Then vntEMail = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす個人住所情報テーブルのレコードを取得
    strStmt = "SELECT PERADDR.ADDRDIV,   PERADDR.ZIPCD,     " & vbLf & _
              "       PERADDR.PREFCD,    PERADDR.CITYNAME,  " & vbLf & _
              "       PERADDR.ADDRESS1,  PERADDR.ADDRESS2,　" & vbLf & _
              "       PERADDR.TEL1,      PERADDR.PHONE,     " & vbLf & _
              "       PERADDR.TEL2,      PERADDR.EXTENSION, " & vbLf & _
              "       PERADDR.FAX,       PERADDR.EMAIL,     " & vbLf & _
              "       PREF.PREFNAME                         " & vbLf & _
              "  FROM PREF, PERADDR                         " & vbLf & _
              " WHERE PERADDR.PERID  = :PERID               " & vbLf & _
              "   AND PERADDR.PREFCD = PREF.PREFCD(+)       "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objAddrDiv = objFields("ADDRDIV")
        Set objZipCd = objFields("ZIPCD")
        Set objPrefCd = objFields("PREFCD")
        Set objPrefName = objFields("PREFNAME")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
        Set objTel1 = objFields("TEL1")
        Set objPhone = objFields("PHONE")
        Set objTel2 = objFields("TEL2")
        Set objExtension = objFields("EXTENSION")
        Set objFax = objFields("FAX")
        Set objEMail = objFields("EMAIL")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrAddrDiv(lngCount)
            ReDim Preserve vntArrZipCd(lngCount)
            ReDim Preserve vntArrPrefCd(lngCount)
            ReDim Preserve vntArrPrefName(lngCount)
            ReDim Preserve vntArrCityName(lngCount)
            ReDim Preserve vntArrAddress1(lngCount)
            ReDim Preserve vntArrAddress2(lngCount)
            ReDim Preserve vntArrTel1(lngCount)
            ReDim Preserve vntArrPhone(lngCount)
            ReDim Preserve vntArrTel2(lngCount)
            ReDim Preserve vntArrExtension(lngCount)
            ReDim Preserve vntArrFax(lngCount)
            ReDim Preserve vntArrEMail(lngCount)
            vntArrAddrDiv(lngCount) = objAddrDiv.Value & ""
            vntArrZipCd(lngCount) = objZipCd.Value & ""
            vntArrPrefCd(lngCount) = objPrefCd.Value & ""
            vntArrPrefName(lngCount) = objPrefName.Value & ""
            vntArrCityName(lngCount) = objCityName.Value & ""
            vntArrAddress1(lngCount) = objAddress1.Value & ""
            vntArrAddress2(lngCount) = objAddress2.Value & ""
            vntArrTel1(lngCount) = objTel1.Value & ""
            vntArrPhone(lngCount) = objPhone.Value & ""
            vntArrTel2(lngCount) = objTel2.Value & ""
            vntArrExtension(lngCount) = objExtension.Value & ""
            vntArrFax(lngCount) = objFax.Value & ""
            vntArrEMail(lngCount) = objEMail.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        Set objAddrDiv = Nothing
        Set objZipCd = Nothing
        Set objPrefCd = Nothing
        Set objPrefName = Nothing
        Set objCityName = Nothing
        Set objAddress1 = Nothing
        Set objAddress2 = Nothing
        Set objTel1 = Nothing
        Set objPhone = Nothing
        Set objTel2 = Nothing
        Set objExtension = Nothing
        Set objFax = Nothing
        Set objEMail = Nothing
        Set objFields = Nothing

        '戻り値の設定
        If Not IsMissing(vntAddrDiv) Then vntAddrDiv = vntArrAddrDiv
        If Not IsMissing(vntZipCd) Then vntZipCd = vntArrZipCd
        If Not IsMissing(vntPrefCd) Then vntPrefCd = vntArrPrefCd
        If Not IsMissing(vntPrefName) Then vntPrefName = vntArrPrefName
        If Not IsMissing(vntCityName) Then vntCityName = vntArrCityName
        If Not IsMissing(vntAddress1) Then vntAddress1 = vntArrAddress1
        If Not IsMissing(vntAddress2) Then vntAddress2 = vntArrAddress2
        If Not IsMissing(vntTel1) Then vntTel1 = vntArrTel1
        If Not IsMissing(vntTel2) Then vntTel2 = vntArrTel2
        If Not IsMissing(vntExtension) Then vntExtension = vntArrExtension
        If Not IsMissing(vntFax) Then vntFax = vntArrFax
        If Not IsMissing(vntPhone) Then vntPhone = vntArrPhone
        If Not IsMissing(vntEMail) Then vntEMail = vntArrEMail
        
    End If

    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    '戻り値の設定
    SelectPersonAddr = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPersonAddr = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPersonAddr"
    
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
' 機能　　 : 指定団体・従業員番号の個人情報を取得する
'
' 引数　　 : (In)     strOrgCd1      団体コード１
' 　　　　   (In)     strOrgCd2      団体コード２
' 　　　　   (In)     strEmpNo       従業員番号
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntLastName    姓
' 　　　　   (Out)    vntFirstName   名
' 　　　　   (Out)    vntLastKName   カナ姓
' 　　　　   (Out)    vntFirstKName  カナ名
' 　　　　   (Out)    vntBirth       生年月日
' 　　　　   (Out)    vntGender      性別
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPersonFromOrg( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strEmpNo As String, _
    ByRef vntPerId As Variant, _
    ByRef vntLastName As Variant, _
    ByRef vntFirstName As Variant, _
    ByRef vntLastKName As Variant, _
    ByRef vntFirstKName As Variant, _
    ByRef vntBirth As Variant, _
    ByRef vntGender As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objPerId        As Object           '個人ＩＤ
    Dim objLastName     As Object           '姓
    Dim objFirstName    As Object           '名
    Dim objLastKName    As Object           'カナ姓
    Dim objFirstKName   As Object           'カナ名
    Dim objBirth        As Object           '生年月日
    Dim objGender       As Object           '性別

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntPerId = Empty
    vntLastName = Empty
    vntFirstName = Empty
    vntLastKName = Empty
    vntFirstKName = Empty
    vntBirth = Empty
    vntGender = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMPNO", strEmpNo, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす個人属性テーブルのレコードを取得
    strStmt = "SELECT PERID,      LASTNAME,  " & vbLf & _
              "       FIRSTNAME,  LASTKNAME, " & vbLf & _
              "       FIRSTKNAME, BIRTH,     " & vbLf & _
              "       GENDER                 " & vbLf & _
              "  FROM PERSON                 " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1       " & vbLf & _
              "   AND ORGCD2 = :ORGCD2       " & vbLf & _
              "   AND EMPNO  = :EMPNO        "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")

        '戻り値の設定
        vntPerId = objPerId.Value & ""
        vntLastName = objLastName.Value & ""
        vntFirstName = objFirstName.Value & ""
        vntLastKName = objLastKName.Value & ""
        vntFirstKName = objFirstKName.Value & ""
        vntBirth = objBirth.Value & ""
        vntGender = objGender.Value & ""

        SelectPersonFromOrg = True
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    SelectPersonFromOrg = False

    'イベントログ書き込み
    WriteErrorLog "Contract.SelectPersonFromOrg"
    
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
' 機能　　 : 個人ＩＤをキーに個人テーブルを読み込む
'
' 引数　　 : (In)     strPerID       個人ＩＤ
' 　　　　 : (Out)    vntLastName    姓
' 　　　　 : (Out)    vntFirstName   名
' 　　　　 : (Out)    vntLastKName   カナ姓
' 　　　　 : (Out)    vntFirstKName  カナ名
' 　　　　 : (Out)    vntBirth       生年月日
' 　　　　 : (Out)    vntGender      性別
' 　　　　 : (Out)    vntGenderName  性別名称
' 　　　　 : (Out)    vntAge         年齢
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPersonInf( _
    ByVal strPerId As String, _
    ByRef vntLastName As Variant, _
    ByRef vntFirstName As Variant, _
    ByRef vntLastKName As Variant, _
    ByRef vntFirstKName As Variant, _
    ByRef vntBirth As Variant, _
    ByRef vntGender As Variant, _
    ByRef vntGenderName As Variant, _
    Optional ByRef vntAge As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    Dim objBirth        As OraField         '生年月日
    Dim objAge          As OraField         '年齢
    Dim objGender       As OraField         '性別
    Dim objGenderName   As OraField         '性別名称
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntLastName = Empty
    vntFirstName = Empty
    vntLastKName = Empty
    vntFirstKName = Empty
    vntBirth = Empty
    vntGender = Empty
    vntGenderName = Empty
    If Not IsMissing(vntAge) Then
        vntAge = Empty
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす個人テーブルのレコードを取得
    strStmt = "SELECT LASTNAME, FIRSTNAME, LASTKNAME, FIRSTKNAME, BIRTH,       " & vbLf & _
              "       GetCslAge(BIRTH) AGE,                                    " & vbLf & _
              "       GENDER, DECODE(GENDER,'1','男性','2','女性') GENDERNAME  " & vbLf & _
              "  FROM PERSON                                                   " & vbLf & _
              " WHERE PERID = :PERID                                           "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objAge = objFields("AGE")
        Set objGender = objFields("GENDER")
        Set objGenderName = objFields("GENDERNAME")
        
        '戻り値の設定
        vntLastName = objLastName.Value
        vntFirstName = objFirstName.Value & ""
        vntLastKName = objLastKName.Value
        vntFirstKName = objFirstKName.Value & ""
        vntBirth = objBirth.Value
        vntGender = objGender.Value
        vntGenderName = objGenderName.Value & ""
        If Not IsMissing(vntAge) Then
            vntAge = objAge.Value & ""
        End If
        
        SelectPersonInf = True
        
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.SelectPersonInf"
    
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
' 機能　　 : 検索条件を満たす個人の一覧を取得する
'
' 引数　　 : (In/Out) vntKey            検索キーの集合
' 　　　　   (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (In)     lngStartPos       開始位置
' 　　　　   (In)     lngGetCount       取得件数
' 　　　　   (Out)    vntPerId          個人ＩＤ
' 　　　　   (Out)    vntDelFlg         削除フラグ
' 　　　　   (Out)    vntLastName       姓
' 　　　　   (Out)    vntFirstName      名
' 　　　　   (Out)    vntLastKName      カナ姓
' 　　　　   (Out)    vntFirstKName     カナ名
' 　　　　   (Out)    vntBirth          生年月日
' 　　　　   (Out)    vntAge            年齢
' 　　　　   (Out)    vntGender         性別
' 　　　　   (In)     blnDelFlgUseOnly  True指定時は削除フラグが"0"(使用中)のレコードのみ検索
' 　　　　   (In)     blnSelectNoOrg    True指定時は団体未設定のレコードも検索
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
'## 2003.11.21 Mod by T.Takagi@FSIT ローマ字検索機能
'Public Function SelectPersonList(
'    ByVal vntKey As Variant,
'    ByVal lngAddrDiv As Long,
'    ByVal lngStartPos As Long,
'    ByVal lngGetCount As Long,
'    Optional ByVal dtmBirth As Date = 0,
'    Optional ByVal lngGender As Long = 0,
'    Optional ByVal blnDelFlgUseOnly As Boolean = False,
'    Optional ByRef vntPerId As Variant,
'    Optional ByRef vntDelFlg As Variant,
'    Optional ByRef vntLastName As Variant,
'    Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant,
'    Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntRomeName As Variant,
'    Optional ByRef vntBirth As Variant,
'    Optional ByRef vntAge As Variant,
'    Optional ByRef vntGender As Variant,
'    Optional ByRef vntZipCd As Variant,
'    Optional ByRef vntPrefName As Variant,
'    Optional ByRef vntCityName As Variant,
'    Optional ByRef vntAddress1 As Variant,
'    Optional ByRef vntAddress2 As Variant,
'    Optional ByRef vntTel1 As Variant
') As Long
Public Function SelectPersonList( _
    ByVal vntKey As Variant, _
    ByVal lngAddrDiv As Long, _
    ByVal lngStartPos As Long, _
    ByVal lngGetCount As Long, _
    Optional ByVal dtmBirth As Date = 0, _
    Optional ByVal lngGender As Long = 0, _
    Optional ByVal blnRomeNameMultiple As Boolean = False, _
    Optional ByVal blnDelFlgUseOnly As Boolean = False, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntDelFlg As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntRomeName As Variant, _
    Optional ByRef vntBirth As Variant, _
    Optional ByRef vntAge As Variant, _
    Optional ByRef vntGender As Variant, _
    Optional ByRef vntZipCd As Variant, _
    Optional ByRef vntPrefName As Variant, _
    Optional ByRef vntCityName As Variant, _
    Optional ByRef vntAddress1 As Variant, Optional ByRef vntAddress2 As Variant, _
    Optional ByRef vntTel1 As Variant _
) As Long
'## 2003.11.21 Mod End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    Dim objLastKName        As OraField         'カナ姓
    Dim objFirstKName       As OraField         'カナ名
    Dim objRomeName         As OraField         'ローマ字名
    Dim objBirth            As OraField         '生年月日
    Dim objAge              As OraField         '年齢
    Dim objGender           As OraField         '性別
    Dim objDelFlg           As OraField         '削除フラグ
    Dim objZipCd            As OraField         '郵便番号
    Dim objPrefName         As OraField         '都道府県名
    Dim objCityName         As OraField         '市区町村名
    Dim objAddress1         As OraField         '住所１
    Dim objAddress2         As OraField         '住所２
    Dim objTel1             As OraField         '電話番号１
    
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrLastName()    As Variant          '姓の配列の配列
    Dim vntArrFirstName()   As Variant          '名の配列の配列
    Dim vntArrLastKName()   As Variant          'カナ姓の配列
    Dim vntArrFirstKName()  As Variant          'カナ名の配列
    Dim vntArrRomeName()    As Variant          'ローマ字名の配列
    Dim vntArrBirth()       As Variant          '生年月日の配列
    Dim vntArrAge()         As Variant          '年齢の配列
    Dim vntArrGender()      As Variant          '性別の配列
    Dim vntArrDelFlg()      As Variant          '削除フラグの配列
    Dim vntArrZipCd()       As Variant          '郵便番号の配列
    Dim vntArrPrefName()    As Variant          '都道府県名の配列
    Dim vntArrCityName()    As Variant          '市区町村名の配列
    Dim vntArrAddress1()    As Variant          '住所１の配列
    Dim vntArrAddress2()    As Variant          '住所２の配列
    Dim vntArrTel1()        As Variant          '電話番号１の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntRomeName) Then vntRomeName = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntDelFlg) Then vntDelFlg = Empty
    If Not IsMissing(vntZipCd) Then vntZipCd = Empty
    If Not IsMissing(vntPrefName) Then vntPrefName = Empty
    If Not IsMissing(vntCityName) Then vntCityName = Empty
    If Not IsMissing(vntAddress1) Then vntAddress1 = Empty
    If Not IsMissing(vntAddress2) Then vntAddress2 = Empty
    If Not IsMissing(vntTel1) Then vntTel1 = Empty
    lngCount = 0

    '検索条件が設定されていない場合は処理を終了する
    If IsEmpty(vntKey) And dtmBirth = 0 And lngGender = 0 Then
        Exit Function
    End If
              
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDPOS", (lngStartPos + lngGetCount - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ADDRDIV", lngAddrDiv, ORAPARM_INPUT, ORATYPE_NUMBER
              
    strStmt = "SELECT BASEDPERSON.PERID,     BASEDPERSON.DELFLG,     " & vbLf & _
              "       BASEDPERSON.LASTNAME,  BASEDPERSON.FIRSTNAME,  " & vbLf & _
              "       BASEDPERSON.LASTKNAME, BASEDPERSON.FIRSTKNAME, " & vbLf & _
              "       BASEDPERSON.ROMENAME,                          " & vbLf & _
              "       BASEDPERSON.BIRTH,     BASEDPERSON.GENDER,     " & vbLf & _
              "       GetCslAge(BASEDPERSON.BIRTH) AGE,              "
    
    strStmt = strStmt & vbLf & _
              "       PERADDR.ZIPCD,    PERADDR.CITYNAME, " & vbLf & _
              "       PERADDR.ADDRESS1, PERADDR.ADDRESS2, " & vbLf & _
              "       PERADDR.TEL1,     PREF.PREFNAME     "
              
    strStmt = strStmt & vbLf & _
              "  FROM PREF, PERADDR, " & vbLf & _
              "       ( SELECT ROWNUM SEQ,                       " & vbLf & _
              "                PERID,      DELFLG,               " & vbLf & _
              "                LASTNAME,   FIRSTNAME, LASTKNAME, " & vbLf & _
              "                FIRSTKNAME, ROMENAME, BIRTH,     GENDER     "

    strStmt = strStmt & vbLf & _
              "           FROM ( SELECT PERID,      DELFLG,               " & vbLf & _
              "                         LASTNAME,   FIRSTNAME, LASTKNAME, " & vbLf & _
              "                         FIRSTKNAME, ROMENAME, BIRTH, GENDER     " & vbLf & _
              "                    FROM PERSON                            "
          
'## 2003.11.21 Mod by T.Takagi@FSIT ローマ字検索機能
'    strStmt = strStmt & vbLf & _
'              "                   " & CreateConditionForPersonList(vntKey, dtmBirth, lngGender, blnDelFlgUseOnly)
    strStmt = strStmt & vbLf & _
              "                   " & CreateConditionForPersonList(vntKey, dtmBirth, lngGender, blnRomeNameMultiple, blnDelFlgUseOnly)
'## 2003.11.21 Mod End
          
'### 2004.9.30 Update by FSIT)Gouda ローマ字氏名、生年月日順に並べ替え
'    strStmt = strStmt & vbLf & _
'              "                   ORDER BY LASTKNAME, FIRSTKNAME, LASTNAME, FIRSTNAME, PERID ) " & vbLf & _
'              "       ) BASEDPERSON                                                            " & vbLf & _
'              " WHERE BASEDPERSON.SEQ BETWEEN :STARTPOS AND :ENDPOS                            " & vbLf & _
'              "   AND BASEDPERSON.PERID = PERADDR.PERID(+)                                     " & vbLf & _
'              "   AND :ADDRDIV          = PERADDR.ADDRDIV(+)                                   " & vbLf & _
'              "   AND PERADDR.PREFCD    = PREF.PREFCD(+)                                       " & vbLf & _
'              " ORDER BY BASEDPERSON.SEQ                                                       "
    strStmt = strStmt & vbLf & _
              "                 ORDER BY ROMENAME, BIRTH, LASTNAME, FIRSTNAME, PERID ) " & vbLf & _
              "       ) BASEDPERSON                                                            " & vbLf & _
              " WHERE BASEDPERSON.SEQ BETWEEN :STARTPOS AND :ENDPOS                            " & vbLf & _
              "   AND BASEDPERSON.PERID = PERADDR.PERID(+)                                     " & vbLf & _
              "   AND :ADDRDIV          = PERADDR.ADDRDIV(+)                                   " & vbLf & _
              "   AND PERADDR.PREFCD    = PREF.PREFCD(+)                                       " & vbLf & _
              " ORDER BY BASEDPERSON.SEQ                                                       "
'### 2004.9.30 Update End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objRomeName = objFields("ROMENAME")
        Set objBirth = objFields("BIRTH")
        Set objAge = objFields("AGE")
        Set objGender = objFields("GENDER")
        Set objDelFlg = objFields("DELFLG")
        Set objZipCd = objFields("ZIPCD")
        Set objPrefName = objFields("PREFNAME")
        Set objCityName = objFields("CITYNAME")
        Set objAddress1 = objFields("ADDRESS1")
        Set objAddress2 = objFields("ADDRESS2")
        Set objTel1 = objFields("TEL1")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrRomeName(lngCount)
            ReDim Preserve vntArrBirth(lngCount)
            ReDim Preserve vntArrAge(lngCount)
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrDelFlg(lngCount)
            ReDim Preserve vntArrZipCd(lngCount)
            ReDim Preserve vntArrPrefName(lngCount)
            ReDim Preserve vntArrCityName(lngCount)
            ReDim Preserve vntArrAddress1(lngCount)
            ReDim Preserve vntArrAddress2(lngCount)
            ReDim Preserve vntArrTel1(lngCount)
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrRomeName(lngCount) = objRomeName.Value & ""
            vntArrBirth(lngCount) = objBirth.Value & ""
            vntArrAge(lngCount) = objAge.Value & ""
            vntArrGender(lngCount) = objGender.Value & ""
            vntArrDelFlg(lngCount) = objDelFlg.Value & ""
            vntArrZipCd(lngCount) = objZipCd.Value & ""
            vntArrPrefName(lngCount) = objPrefName.Value & ""
            vntArrCityName(lngCount) = objCityName.Value & ""
            vntArrAddress1(lngCount) = objAddress1.Value & ""
            vntArrAddress2(lngCount) = objAddress2.Value & ""
            vntArrTel1(lngCount) = objTel1.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
        If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
        If Not IsMissing(vntRomeName) Then vntRomeName = vntArrRomeName
        If Not IsMissing(vntBirth) Then vntBirth = vntArrBirth
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntDelFlg) Then vntDelFlg = vntArrDelFlg
        If Not IsMissing(vntZipCd) Then vntZipCd = vntArrZipCd
        If Not IsMissing(vntPrefName) Then vntPrefName = vntArrPrefName
        If Not IsMissing(vntCityName) Then vntCityName = vntArrCityName
        If Not IsMissing(vntAddress1) Then vntAddress1 = vntArrAddress1
        If Not IsMissing(vntAddress2) Then vntAddress2 = vntArrAddress2
        If Not IsMissing(vntTel1) Then vntTel1 = vntArrTel1
        
    End If
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectPersonList = lngCount
        
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.SelectPersonList"
    
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
' 機能　　 : 検索条件を満たす個人の件数を取得する
'
' 引数　　 : (In/Out) vntKey            検索キーの集合
' 　　　　   (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (In)     blnDelFlgUseOnly  True指定時は削除フラグが"0"(使用中)のレコードのみ検索
' 　　　　   (In)     blnSelectNoOrg    True指定時は団体未設定のレコードも検索
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 検索キーに半角カナ文字が存在する場合は全角変換が行われる
'
'## 2003.11.21 Mod by T.Takagi@FSIT ローマ字検索機能
'Public Function SelectPersonListCount(
'    ByRef vntKey As Variant,
'    Optional ByVal dtmBirth As Date = 0,
'    Optional ByVal lngGender As Long = 0,
'    Optional ByVal blnDelFlgUseOnly As Boolean = False
') As Long
Public Function SelectPersonListCount( _
    ByRef vntKey As Variant, _
    Optional ByVal dtmBirth As Date = 0, _
    Optional ByVal lngGender As Long = 0, _
    Optional ByVal blnRomeNameMultiple As Boolean = False, _
    Optional ByVal blnDelFlgUseOnly As Boolean = False _
) As Long
'## 2003.11.21 Mod End

    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If IsEmpty(vntKey) And dtmBirth = 0 And lngGender = 0 Then
        Exit Function
    End If

    '検索条件を満たす個人テーブルのレコード件数を取得
'## 2003.11.21 Mod by T.Takagi@FSIT ローマ字検索機能
'    strStmt = "SELECT COUNT(PERID) FROM PERSON " & CreateConditionForPersonList(vntKey, dtmBirth, lngGender, blnDelFlgUseOnly)
    strStmt = "SELECT COUNT(PERID) FROM PERSON " & CreateConditionForPersonList(vntKey, dtmBirth, lngGender, blnRomeNameMultiple, blnDelFlgUseOnly)
'## 2003.11.21 Mod End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合は件数を戻り値として設定
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
        SelectPersonListCount = objOraDyna.Fields(0).Value
    End If
    
'#### 2010.08.30 SL-HS-Y0101-002 ADD START ####
    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Set objOraParam = mobjOraDb.Parameters
    
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
    WriteErrorLog "Person.SelectPersonListCount"
    
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
' 機能　　 : 指定団体・事業部・室部・所属条件を満たす個人の一覧を取得する
'
' 引数　　 : (In)     strOrgCd1        団体コード１
' 　　　　   (In)     strOrgCd2        団体コード２
' 　　　　   (In)     strOrgBsdCd      事業部コード
' 　　　　   (In)     strOrgRoomCd 　  室部コード
' 　　　　   (In)     strStrOrgPostCd  開始所属コード
' 　　　　   (In)     strEndOrgPostCd  終了所属コード
' 　　　　   (Out)    vntPerId         個人ＩＤ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectPersonListFromOrg( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strOrgBsdCd As String, _
    ByVal strOrgRoomCd As String, _
    ByVal strStrOrgPostCd As String, _
    ByVal strEndOrgPostCd As String, _
    ByRef vntPerId As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント
    
    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objPerId        As OraField         '個人ＩＤ
    
    Dim vntArrPerId()   As Variant          '個人ＩＤの配列
    Dim lngCount        As Long             'レコード数
    
    Dim strOrgPostCd    As String           '所属コード
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntPerId = Empty
    lngCount = 0

    '開始所属コード値が終了所属コードより大きい場合は値を交換する
    If strStrOrgPostCd > strEndOrgPostCd Then
        strOrgPostCd = strStrOrgPostCd
        strStrOrgPostCd = strEndOrgPostCd
        strEndOrgPostCd = strOrgPostCd
    End If
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGBSDCD", strOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGROOMCD", strOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRORGPOSTCD", strStrOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENDORGPOSTCD", strEndOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '指定条件を満たす個人テーブルレコードを検索
    strStmt = "SELECT PERID            " & vbLf & _
              "  FROM PERSON           " & vbLf & _
              " WHERE ORGCD1 = :ORGCD1 " & vbLf & _
              "   AND ORGCD2 = :ORGCD2 "
              
    '事業部指定時は条件節に加える
    If strOrgBsdCd <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND ORGBSDCD = :ORGBSDCD "
    End If
    
    '室部指定時は条件節に加える
    If strOrgRoomCd <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND ORGROOMCD = :ORGROOMCD "
    End If
    
    '開始所属指定時は条件節に加える
    If strStrOrgPostCd <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND ORGROOMCD >= :STRORGROOMCD "
    End If
    
    '終了所属指定時は条件節に加える
    If strEndOrgPostCd <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND ORGROOMCD <= :ENDORGROOMCD "
    End If
    
    '退職・休職者・出向者は除く
    strStmt = strStmt & vbLf & _
              "   AND DELFLG      = 0          " & vbLf & _
              "   AND TRANSFERDIV = 0          " & vbLf & _
              " ORDER BY ORGCD1, ORGCD2, EMPNO "
              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPerId(lngCount)
            vntArrPerId(lngCount) = objPerId.Value
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
        '戻り値の設定
        vntPerId = vntArrPerId
        
    End If
    
'#### 2010.08.30 SL-HS-Y0101-002 ADD START ####
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'#### 2010.08.30 SL-HS-Y0101-002 ADD END ####
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    SelectPersonListFromOrg = lngCount
        
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.SelectPersonListFromOrg"
    
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
' 機能　　 : 個人ＩＤをキーに個人テーブルを読み込む（名前のみ取得）
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (Out)    vntLastName           姓
' 　　　　 : (Out)    vntFirstName          名
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 : Optional 生年月日は年、月、日すべての引数が渡された場合、結果を返す
'
Public Function SelectPersonName(ByVal strPerId As String, _
                             ByRef vntLastName As Variant, ByRef vntFirstName As Variant _
                            ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objLastName             As OraField         '姓
    Dim objFirstName            As OraField         '名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strPerId) = "" Then
        Exit Function
    End If
        
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT
    
    '検索条件を満たす個人テーブルのレコードを取得
    strStmt = "SELECT p.LASTNAME,     p.FIRSTNAME    " & vbLf & _
              "  FROM PERSON p"

    strStmt = strStmt & vbLf & _
              " WHERE p.PERID   = :PERID                            " & vbLf
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        
        '戻り値の設定
        vntLastName = objLastName.Value & ""
        vntFirstName = objFirstName.Value & ""
        
        SelectPersonName = True
        
    End If
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.SelectPersonName"
    
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
' 機能　　 : 続柄データを取得する
'
' 引数　　 : (In)     strRelationCd    続柄コード
' 　　　　   (Out)    vntRelationName  続柄名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectRelation(ByVal strRelationCd As String, ByRef vntRelationName As Variant) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    
    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objRelationName As OraField         '続柄名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RELATIONCD", Trim(strRelationCd), ORAPARM_INPUT
    
    '検索条件を満たす続柄テーブルのレコードを取得
    strStmt = "SELECT RELATIONNAME FROM RELATION WHERE RELATIONCD = :RELATIONCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRelationName = objFields("RELATIONNAME")
    
        '戻り値の設定
        vntRelationName = objRelationName.Value
        
        SelectRelation = True
        
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
    WriteErrorLog "Person.tem.SelectRelation"
    
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
' 機能　　 : 続柄名称の一覧を取得する
'
' 引数　　 : (Out)    vntRelationCd   続柄コード
' 　　　　 : (Out)    vntRelationName 続柄名称
'
' 戻り値　 : 続柄テーブルに登録されているレコード件数
'
' 備考　　 :
'
Public Function SelectRelationList(ByRef vntRelationCd As Variant, ByRef vntRelationName As Variant) As Long
                                   
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRelationCd          As OraField         '続柄コード
    Dim objRelationName        As OraField         '続柄名称
    
    Dim vntArrRelationCd()     As Variant          '続柄コードの配列
    Dim vntArrRelationName()   As Variant          '続柄名称の配列
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntRelationCd = Empty
    vntRelationName = Empty
          
    '続柄テーブルのレコードを取得
    strStmt = "SELECT RELATIONCD, RELATIONNAME " & vbLf & _
              "  FROM RELATION          " & vbLf & _
              " ORDER BY RELATIONCD         "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRelationCd = objFields("RELATIONCD")
        Set objRelationName = objFields("RELATIONNAME")
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRelationCd(lngCount)
            ReDim Preserve vntArrRelationName(lngCount)
            vntArrRelationCd(lngCount) = objRelationCd.Value & ""
            vntArrRelationName(lngCount) = objRelationName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    vntRelationCd = vntArrRelationCd
    vntRelationName = vntArrRelationName
    SelectRelationList = lngCount
        
    Set objOraDyna = Nothing
        
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.tem.SelectRelationList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
Public Function UpdateAllPersonInfo(ByVal strMode As String, _
                                    ByRef vntPerId As Variant, ByVal strVidflg As String, ByVal strLastName As String, _
                                    ByVal strFirstName As String, ByVal strLastKName As String, ByVal strFirstKName As String, _
                                    ByVal strBirth As String, ByVal strGender As String, _
                                    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
                                    ByVal strOrgPostCd As String, _
                                    ByVal strSpare1 As String, ByVal strSpare2 As String, ByVal strUpdUser As String, _
                                    ByVal strTel As String, _
                                    ByVal strExtension As String, _
                                    ByVal strSubTel As String, ByVal strFax As String, _
                                    ByVal strPhone As String, _
                                    ByVal strEMail As String, ByVal strZipCd1 As String, _
                                    ByVal strZipCd2 As String, ByVal strPrefCd As String, ByVal strCityName As String, _
                                    ByVal strAddress1 As String, ByVal strAddress2 As String, ByVal strMarriage As String, _
                                    ByVal strIsrNo As String, ByVal strIsrSign As String, ByVal strIsrMark As String, _
                                    ByVal strHeIsrNo As String, ByVal strIsrDiv As String, ByVal strResidentNo As String, _
                                    ByVal strUnionNo As String, ByVal strKarte As String, ByVal strEmpNo As String, _
                                    ByVal strNotes As String, ByVal strSpare3 As String, ByVal strSpare4 As String, _
                                    ByVal strSpare5 As String, ByVal strSpare6 As String, ByVal strSpare7 As String, _
                                    ByVal strOrgBsdCd As String, ByVal strOrgRoomCd As String, _
                                    ByVal strDelFlg As String, ByVal strTransferDiv As String, ByVal strJobCd As String, ByVal strDutyCd As String, ByVal strQualifyCd As String, _
                                    ByVal strWorkMeasureDiv As String, ByVal strEmpDiv As String, ByVal strRelationCd As String, ByVal strBranchNo As String, _
                                    ByVal strHireDate As Variant, ByVal strLostDate As Variant, ByVal strOverTimeDiv As String, ByVal strNightDutyFlg As String, ByVal strHongenDiv As String _
                                   ) As Variant

    Dim lngRet              As Long         '関数戻り値
    
'*****  2003/01/15  ADD  START  E.Yamamoto
    Dim strArrTel       As Variant
    Dim strArrSubTel    As Variant
    Dim strArrFax       As Variant
    Dim strArrPhone     As Variant
    
    If (strTel <> "") Then
        strArrTel = Split(strTel, "-")
    Else
        ReDim strArrTel(2)
    End If
    
    If (strSubTel <> "") Then
        strArrSubTel = Split(strSubTel, "-")
    Else
        ReDim strArrSubTel(2)
    End If
    
    If (strFax <> "") Then
        strArrFax = Split(strFax, "-")
    Else
        ReDim strArrFax(2)
    End If

    If (strPhone <> "") Then
        strArrPhone = Split(strPhone, "-")
    Else
        ReDim strArrPhone(2)
    End If

    '初期化処理
    UpdateAllPersonInfo = Empty
    
    'モードにより処理判断
    Select Case strMode
        
        Case "insert"
            
            '新規時、個人テーブル挿入処理
            lngRet = InsertPerson(vntPerId, strVidflg, strDelFlg, strTransferDiv, "0", _
                                  strLastName, strFirstName, _
                                  strLastKName, strFirstKName, _
                                  strBirth, strGender, _
                                  strUpdUser, _
                                  strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, _
                                  strJobCd, strDutyCd, strQualifyCd, _
                                  strIsrSign, strIsrNo, strRelationCd, strBranchNo, strEmpNo, , _
                                  strLostDate, strHireDate, strEmpDiv, strHongenDiv, _
                                  strWorkMeasureDiv, strOverTimeDiv, strNightDutyFlg, _
                                  strSpare1, strSpare2)

        Case "update"
            
            '修正時、個人テーブル更新処理
            lngRet = UpdatePerson(vntPerId, strVidflg, strDelFlg, strTransferDiv, , _
                                  strUpdUser, strLastName, strFirstName, strLastKName, strFirstKName, _
                                  strBirth, strGender, _
                                  strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, _
                                  strJobCd, strDutyCd, strQualifyCd, _
                                  strIsrSign, strIsrNo, strRelationCd, strBranchNo, strEmpNo, , _
                                  strLostDate, strHireDate, strEmpDiv, strHongenDiv, _
                                  strWorkMeasureDiv, strOverTimeDiv, strNightDutyFlg, _
                                  strSpare1, strSpare2)

        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    
    End Select
    
    Select Case lngRet
        Case Is > 0
        Case 0
            UpdateAllPersonInfo = Array(IIf(strMode = "insert", "同一個人ＩＤの個人情報がすでに存在します。", "この個人情報はすでに削除されています。更新できません。"))
        Case -1
            UpdateAllPersonInfo = Array("同一団体、従業員番号の個人情報がすでに存在します。")
        Case -2
            UpdateAllPersonInfo = Array("同一健保、続柄、枝番の個人情報がすでに存在します。")
        Case -3
            UpdateAllPersonInfo = Array("ユーザ情報が存在しません。")
        Case -4
            UpdateAllPersonInfo = Array("所属情報が存在しません。")
        Case -5
            UpdateAllPersonInfo = Array("続柄情報が存在しません。")
        Case -6
            UpdateAllPersonInfo = Array("親となる個人情報が存在しません。")
        Case -7
            UpdateAllPersonInfo = Array("職名情報が存在しません。")
        Case -8
            UpdateAllPersonInfo = Array("職責情報が存在しません。")
        Case -9
            UpdateAllPersonInfo = Array("資格情報が存在しません。")
        Case -10
            UpdateAllPersonInfo = Array("就業措置区分が存在しません。")
        Case Else
    End Select

    If lngRet <= 0 Then
        Exit Function
    End If
            
    '個人属性テーブル更新処理
    If Not UpdatePerDetail(vntPerId, _
                           strArrTel(0), strArrTel(1), strArrTel(2), strExtension, _
                           strArrSubTel(0), strArrSubTel(1), strArrSubTel(2), _
                           strArrFax(0), strArrFax(1), strArrFax(2), _
                           strArrPhone(0), strArrPhone(1), strArrPhone(2), _
                           strEMail, _
                           strZipCd1, strZipCd2, strPrefCd, _
                           strCityName, strAddress1, strAddress2, _
                           strMarriage, "", strIsrMark, _
                           strHeIsrNo, strIsrDiv, strResidentNo, _
                           strUnionNo, strKarte, "", _
                           strNotes, strSpare3, strSpare4, _
                           strSpare5, strSpare6, strSpare7) Then
        Exit Function
    End If
    
End Function

'
' 機能　　 : 個人情報を登録する  ## 聖路加バージョン ##
'
' 引数　　 : (In)     strMode          登録モード
' 　　　　   (In/Out) vntPerId         個人ＩＤ
' 　　　　   (In/Out) strVidflg        仮ＩＤフラグ
' 　　　　   (In)     strLastName      姓
' 　　　　   (In)     strFirstName     名
' 　　　　   (In)     strLastKName     カナ姓
' 　　　　   (In)     strFirstKName    カナ名
' 　　　　   (In)     strRomeName      ローマ字名
' 　　　　   (In)     strBirth         生年月日
' 　　　　   (In)     strGender        性別
' 　　　　   (In)     strSpare1        予備１
' 　　　　   (In)     strSpare2        予備２
' 　　　　   (In)     strUpdUser       更新者
' 　　　　   (In)     strPostCardAddr  １年目はがき宛先
' 　　　　   (In)     strMaidenName    旧姓
' 　　　　   (In)     strNationCd      国籍コード
' 　　　　   (In)     strCompPerId     同伴者ＩＤ
' 　　　　   (In)     vntAddrDiv       住所区分
' 　　　　   (In)     vntTel           電話番号１
' 　　　　   (In)     vntExtension     内線
' 　　　　   (In)     vntSubTel        電話番号２
' 　　　　   (In)     vntFax1          ＦＡＸ
' 　　　　   (In)     vntPhone         携帯番号
' 　　　　   (In)     vntEMail         e-Mail
' 　　　　   (In)     vntZipCd         郵便番号
' 　　　　   (In)     vntPrefCD        都道府県コード
' 　　　　   (In)     vntCityName      市区町村名
' 　　　　   (In)     vntAddress1      住所１
' 　　　　   (In)     vntAddress2      住所２
' 　　　　   (In)     strMarriage      婚姻区分
' 　　　　   (In)     strResidentNo    住民番号
' 　　　　   (In)     strUnionNo       組合番号
' 　　　　   (In)     strKarte         カルテ番号
' 　　　　   (In)     strNotes         特記事項
' 　　　　   (In)     strSpare3        個人属性情報の予備１
' 　　　　   (In)     strSpare4        個人属性情報の予備２
' 　　　　   (In)     strSpare5        個人属性情報の予備３
' 　　　　   (In)     strSpare6        個人属性情報の予備４
' 　　　　   (In)     strSpare7        個人属性情報の予備５
' 　　　　   (In)     strDelFlg        削除フラグ
' 　　　　   (In)     strCslCount      受診回数
'
' 戻り値　 : メッセージ
'
' 備考　　 :
'
'## 2003.12.16 Mod By T.Takagi@FSIT 医事からの住所保持(プリフックスがおかしいのでわけわからない)
'Public Function UpdateAllPersonInfo_lukes(
'    ByVal strMode As String,
'    ByRef vntPerId As Variant, ByVal strVidflg As String,
'    ByVal strLastName As String, ByVal strFirstName As String,
'    ByVal strLastKName As String, ByVal strFirstKName As String,
'    ByVal strRomeName As String,
'    ByVal strBirth As String, ByVal strGender As String,
'    ByVal strSpare1 As String, ByVal strSpare2 As String, ByVal strUpdUser As String,
'    ByVal strPostCardAddr As String, ByVal strMaidenName As String,
'    ByVal strNationCd As String, ByVal strCompPerId As String,
'    ByVal strTel As Variant,
'    ByVal strExtension As Variant,
'    ByVal strSubTel As Variant, ByVal strFax As Variant,
'    ByVal strPhone As Variant,
'    ByVal strEMail As Variant, ByVal strZipCd As Variant,
'    ByVal strPrefCd As Variant, ByVal strCityName As Variant,
'    ByVal strAddress1 As Variant, ByVal strAddress2 As Variant, ByVal strMarriage As String,
'    ByVal strResidentNo As String,
'    ByVal strUnionNo As String, ByVal strKarte As String,
'    ByVal strNotes As String, ByVal strSpare3 As String, ByVal strSpare4 As String,
'    ByVal strSpare5 As String, ByVal strSpare6 As String, ByVal strSpare7 As String,
'    ByVal strDelFlg As String
') As Variant
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
'Public Function UpdateAllPersonInfo_lukes(
'    ByVal strMode As String,
'    ByRef vntPerId As Variant, ByVal strVidflg As String,
'    ByVal strLastName As String, ByVal strFirstName As String,
'    ByVal strLastKName As String, ByVal strFirstKName As String,
'    ByVal strRomeName As String,
'    ByVal strBirth As String, ByVal strGender As String,
'    ByVal strSpare1 As String, ByVal strSpare2 As String, ByVal strUpdUser As String,
'    ByVal strPostCardAddr As String, ByVal strMaidenName As String,
'    ByVal strNationCd As String, ByVal strCompPerId As String,
'    ByRef vntAddrDiv As Variant,
'    ByRef vntTel As Variant, ByRef vntExtension As Variant,
'    ByRef vntSubTel As Variant, ByRef vntFax As Variant,
'    ByRef vntPhone As Variant,
'    ByRef vntEMail As Variant, ByRef vntZipCd As Variant,
'    ByRef vntPrefCd As Variant, ByRef vntCityName As Variant,
'    ByRef vntAddress1 As Variant, ByRef vntAddress2 As Variant,
'    ByVal strMarriage As String, ByVal strResidentNo As String,
'    ByVal strUnionNo As String, ByVal strKarte As String,
'    ByVal strNotes As String, ByVal strSpare3 As String, ByVal strSpare4 As String,
'    ByVal strSpare5 As String, ByVal strSpare6 As String, ByVal strSpare7 As String,
'    ByVal strDelFlg As String
') As Variant
Public Function UpdateAllPersonInfo_lukes( _
    ByVal strMode As String, _
    ByRef vntPerId As Variant, ByVal strVidflg As String, _
    ByVal strLastName As String, ByVal strFirstName As String, _
    ByVal strLastKName As String, ByVal strFirstKName As String, _
    ByVal strRomeName As String, _
    ByVal strBirth As String, ByVal strGender As String, _
    ByVal strSpare1 As String, ByVal strSpare2 As String, ByVal strUpdUser As String, _
    ByVal strPostCardAddr As String, ByVal strMaidenName As String, _
    ByVal strNationCd As String, ByVal strCompPerId As String, _
    ByRef vntAddrDiv As Variant, _
    ByRef vntTel As Variant, ByRef vntExtension As Variant, _
    ByRef vntSubTel As Variant, ByRef vntFax As Variant, _
    ByRef vntPhone As Variant, _
    ByRef vntEMail As Variant, ByRef vntZipCd As Variant, _
    ByRef vntPrefCd As Variant, ByRef vntCityName As Variant, _
    ByRef vntAddress1 As Variant, ByRef vntAddress2 As Variant, _
    ByVal strMarriage As String, ByVal strResidentNo As String, _
    ByVal strUnionNo As String, ByVal strKarte As String, _
    ByVal strNotes As String, ByVal strSpare3 As String, ByVal strSpare4 As String, _
    ByVal strSpare5 As String, ByVal strSpare6 As String, ByVal strSpare7 As String, _
    ByVal strDelFlg As String, ByVal strCslCount As String _
) As Variant
'## 2004.02.10 Mod End
'## 2003.12.16 Mod End

    Dim vntMessage  As Variant  'メッセージ
    Dim Ret         As Long     '関数戻り値
    
    On Error GoTo ErrorHandle

    Do
    
        'モードにより処理判断
        Select Case strMode
            
            Case "insert"
                
                '新規時、個人テーブル挿入処理
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
'                Ret = InsertPerson_lukes( _
'                             vntPerId, strVidflg, strDelFlg, "0", "0", _
'                             strLastName, strFirstName, strLastKName, strFirstKName, _
'                             strRomeName, strBirth, strGender, strUpdUser, , , , , , , , , , , , , , , , , , , , , , _
'                             strSpare1, strSpare2, strPostCardAddr, _
'                             strMaidenName, strNationCd, strCompPerId _
'                         )
                Ret = InsertPerson_lukes( _
                             vntPerId, strVidflg, strDelFlg, "0", "0", _
                             strLastName, strFirstName, strLastKName, strFirstKName, _
                             strRomeName, strBirth, strGender, strUpdUser, , , , , , , , , , , , , , , , , , , , , , _
                             strSpare1, strSpare2, strPostCardAddr, _
                             strMaidenName, strNationCd, strCompPerId, strCslCount _
                         )
'## 2004.02.10 Mod End
    
            Case "update"
                
'## 2004.02.10 Add By T.Takagi@FSIT 未来の受診情報所持者に対する性別変更は不可
                '性別と未来受診情報チェック
                Ret = CheckGenderAndConsult(vntPerId, strGender)
                Select Case Ret
                    Case Is > 0
                    Case 0
                        vntMessage = Array("この個人情報はすでに削除されています。更新できません。")
                    Case -1
                        vntMessage = Array("本日以降（本日含む）にこの個人の受診情報が存在するため、性別の変更はできません。")
                    Case Else
                        vntMessage = Array("個人情報更新時にその他のエラーが発生しました（" & Ret & "）。")
                End Select
        
                If Ret <= 0 Then
                    Exit Do
                End If
'## 2004.02.10 Add End
                
                '修正時、個人テーブル更新処理
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
'                Ret = UpdatePerson_lukes(vntPerId, strVidflg, strDelFlg, _
'                                      strUpdUser, strLastName, strFirstName, strLastKName, strFirstKName, _
'                                      strRomeName, _
'                                      strBirth, strGender, _
'                                      strSpare1, strSpare2, _
'                                      strPostCardAddr, strMaidenName, strNationCd, strCompPerId)
                Ret = UpdatePerson_lukes(vntPerId, strVidflg, strDelFlg, _
                                      strUpdUser, strLastName, strFirstName, strLastKName, strFirstKName, _
                                      strRomeName, _
                                      strBirth, strGender, _
                                      strSpare1, strSpare2, _
                                      strPostCardAddr, strMaidenName, strNationCd, strCompPerId, strCslCount)
'## 2004.02.10 Mod End
            Case Else
                Exit Do
        
        End Select
    
        Select Case Ret
            Case Is > 0
            Case 0
                vntMessage = Array(IIf(strMode = "insert", "同一個人ＩＤの個人情報がすでに存在します。", "この個人情報はすでに削除されています。更新できません。"))
'## 2003.12.16 Del By T.Takagi@FSIT
'            Case -1
'                vntMessage = Array("同一団体、従業員番号の個人情報がすでに存在します。")
'            Case -2
'                vntMessage = Array("同一健保、続柄、枝番の個人情報がすでに存在します。")
'## 2003.12.16 Del End
            Case -3
                vntMessage = Array("ユーザ情報が存在しません。")
'## 2003.12.16 Mod By T.Takagi@FSIT
'            Case -4
'                vntMessage = Array("所属情報が存在しません。")
'            Case -5
'                vntMessage = Array("続柄情報が存在しません。")
'            Case -6
'                vntMessage = Array("親となる個人情報が存在しません。")
'            Case -7
'                vntMessage = Array("職名情報が存在しません。")
'            Case -8
'                vntMessage = Array("職責情報が存在しません。")
'            Case -9
'                vntMessage = Array("資格情報が存在しません。")
'            Case -10
'                vntMessage = Array("就業措置区分が存在しません。")
            Case -4
                vntMessage = Array("国籍情報が存在しません。")
            Case -5
                vntMessage = Array("同伴者個人情報が存在しません。")
'## 2003.12.16 Mod End
            Case Else
        End Select

        If Ret <= 0 Then
            Exit Do
        End If
            
'## 2004.10.13 Add By T.Takagi@FSIT 医事個人情報との照合チェック
        '個人テーブルが更新され、コミットされる前の状態で照合を行う
        If Not IsEqualToMed(vntPerId) Then
'## 2010.12.01 Mod By C.Ochiai@FJTH 連携項目変更によりチェック項目変更
''## 2004.10.18 Mod By T.Takagi@FSIT 漢字氏名はチェック非対象とする
''            vntMessage = Array("医事情報と氏名、ローマ字名、性別、生年月日のいずれかが一致しません。")
'            vntMessage = Array("医事情報とローマ字名、性別、生年月日のいずれかが一致しません。")
            vntMessage = Array("医事情報とカナ氏名、性別、生年月日のいずれかが一致しません。")
''## 2004.10.18 Mod End
'## 2010.12.01 Mod End
            mobjContext.SetAbort
            Exit Do
        End If
'## 2004.10.13 Add End
            
'## 2004.02.17 Add By H.Ishihara@FSIT 同伴者個人ＩＤ強制更新を追加
        'お連れ様情報（相手先）を更新する
        If UpdateCompPerId2(vntPerId, 1) < 0 Then GoTo ErrorHandle
'## 2004.02.17 Add End
            
        '個人属性テーブル更新処理
        If Not UpdatePerDetail(vntPerId, _
                               "", "", "", "", _
                               "", "", "", _
                               "", "", "", _
                               "", "", "", _
                               "", _
                               "", "", "", _
                               "", "", "", _
                               strMarriage, "", "", _
                               "", "", strResidentNo, _
                               strUnionNo, strKarte, "", _
                               strNotes, strSpare3, strSpare4, _
                               strSpare5, strSpare6, strSpare7) Then
            Exit Do
        End If
    
    '個人住所テーブル更新処理
'## 2003.12.16 Mod By T.Takagi@FSIT 医事からの住所保持
'        If Not UpdatePerAddr(vntPerId, _
'                               strTel, strPhone, strSubTel, strExtension, _
'                               strFax, _
'                               strEMail, _
'                               strZipCd, strPrefCd, _
'                               strCityName, strAddress1, strAddress2 _
'                            ) Then
'            Exit Function
'        End If
        UpdatePerAddr vntPerId, vntAddrDiv, vntTel, vntPhone, vntSubTel, vntExtension, vntFax, vntEMail, vntZipCd, vntPrefCd, vntCityName, vntAddress1, vntAddress2
'## 2003.12.16 Mod End
    
        Exit Do
    Loop
    
    '戻り値の設定
    UpdateAllPersonInfo_lukes = vntMessage
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.UpdateAllPersonInfo_lukes"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'
' 機能　　 : 個人ＩＤをキーに個人属性テーブルを更新する
'
' 引数　　 : (In)     strPerID              個人ＩＤ
' 　　　　 : (In)     vntTel1               電話番号１-市外局番（省略可）
' 　　　　 : (In)     vntTel2               電話番号１-局番（省略可）
' 　　　　 : (In)     vntTel3               電話番号１-番号（省略可）
' 　　　　 : (In)     strExtension          内線（省略可）
' 　　　　 : (In)     vntSubTel1            電話番号２-市外局番（省略可）
' 　　　　 : (In)     vntSubTel2            電話番号２-局番（省略可）
' 　　　　 : (In)     vntSubTel3            電話番号２-番号（省略可）
' 　　　　 : (In)     vntFax1               ＦＡＸ番号-市外局番（省略可）
' 　　　　 : (In)     vntFax2               ＦＡＸ番号-局番（省略可）
' 　　　　 : (In)     vntFax3               ＦＡＸ番号-番号（省略可）
' 　　　　 : (In)     vntPhone1             携帯-市外局番（省略可）
' 　　　　 : (In)     vntPhone2             携帯-局番（省略可）
' 　　　　 : (In)     vntPhone3             携帯-番号（省略可）
' 　　　　 : (In)     vntEMail              e-Mail（省略可）
' 　　　　 : (In)     vntZipCd1             郵便番号１（省略可）
' 　　　　 : (In)     vntZipCd2             郵便番号２（省略可）
' 　　　　 : (In)     strPrefCD             都道府県コード（省略可）
' 　　　　 : (In)     vntCityName           市区町村名（省略可）
' 　　　　 : (In)     vntAddress1           住所１（省略可）
' 　　　　 : (In)     vntAddress2           住所２（省略可）
' 　　　　 : (In)     vntMarriage           婚姻区分（省略可）
' 　　　　 : (In)     vntIsrSign            健保記号(記号)（省略可）
' 　　　　 : (In)     vntIsrMark            健保記号(符号)（省略可）
' 　　　　 : (In)     vntHeIsrNo            健保番号（省略可）
' 　　　　 : (In)     vntIsrDiv             保険区分（省略可）
' 　　　　 : (In)     vntResidentNo         住民番号（省略可）
' 　　　　 : (In)     vntUnionNo            組合番号（省略可）
' 　　　　 : (In)     vntKarte              カルテ番号（省略可）
' 　　　　 : (In)     vntEmpNo              従業員番号（省略可）
' 　　　　 : (In)     vntNotes              特記事項（省略可）
' 　　　　 : (In)     vntSpare1             予備１（省略可）
' 　　　　 : (In)     vntSpare2             予備２（省略可）
' 　　　　 : (In)     vntSpare3             予備３（省略可）
' 　　　　 : (In)     vntSpare4             予備４（省略可）
' 　　　　 : (In)     vntSpare5             予備５（省略可）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdatePerDetail(ByVal strPerId As String, _
                                Optional ByVal vntTel1 As Variant, Optional ByVal vntTel2 As Variant, _
                                Optional ByVal vntTel3 As Variant, Optional ByVal strExtension As Variant, _
                                Optional ByVal vntSubTel1 As Variant, Optional ByVal vntSubTel2 As Variant, _
                                Optional ByVal vntSubTel3 As Variant, Optional ByVal vntFax1 As Variant, _
                                Optional ByVal vntFax2 As Variant, Optional ByVal vntFax3 As Variant, _
                                Optional ByVal vntPhone1 As Variant, Optional ByVal vntPhone2 As Variant, _
                                Optional ByVal vntPhone3 As Variant, Optional ByVal vntEMail As Variant, _
                                Optional ByVal vntZipCd1 As Variant, Optional ByVal vntZipCd2 As Variant, _
                                Optional ByVal vntPrefCd As Variant, Optional ByVal vntCityName As Variant, _
                                Optional ByVal vntAddress1 As Variant, Optional ByVal vntAddress2 As Variant, _
                                Optional ByVal vntMarriage As Variant, Optional ByVal vntIsrSign As Variant, _
                                Optional ByVal vntIsrMark As Variant, Optional ByVal vntHeIsrNo As Variant, _
                                Optional ByVal vntIsrDiv As Variant, Optional ByVal vntResidentNo As Variant, _
                                Optional ByVal vntUnionNo As Variant, Optional ByVal vntKarte As Variant, _
                                Optional ByVal vntEmpNo As Variant, Optional ByVal vntNotes As Variant, _
                                Optional ByVal vntSpare1 As Variant, Optional ByVal vntSpare2 As Variant, _
                                Optional ByVal vntSpare3 As Variant, Optional ByVal vntSpare4 As Variant, _
                                Optional ByVal vntSpare5 As Variant _
                               ) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim lngColumnCount          As Long             '列数
    Dim strColumnName()         As String           '列名
    
    Dim i                       As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT
    
    '検索条件を満たす個人属性テーブルのレコードを先に削除
    strStmt = "DELETE FROM PERSONDETAIL " & vbLf & _
              " WHERE PERID = :PERID    "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    lngColumnCount = 0
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    If Not IsMissing(vntTel1) Then
'        objOraParam.Add "TEL1", Trim(vntTel1), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("TEL1", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntTel2) Then
'        objOraParam.Add "TEL2", Trim(vntTel2), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("TEL2", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntTel3) Then
'        objOraParam.Add "TEL3", Trim(vntTel3), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("TEL3", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(strExtension) Then
'        objOraParam.Add "EXTENSION", Trim(strExtension), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("EXTENSION", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntSubTel1) Then
'        objOraParam.Add "SUBTEL1", Trim(vntSubTel1), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("SUBTEL1", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntSubTel2) Then
'        objOraParam.Add "SUBTEL2", Trim(vntSubTel2), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("SUBTEL2", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntSubTel3) Then
'        objOraParam.Add "SUBTEL3", Trim(vntSubTel3), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("SUBTEL3", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntFax1) Then
'        objOraParam.Add "FAX1", Trim(vntFax1), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("FAX1", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntFax2) Then
'        objOraParam.Add "FAX2", Trim(vntFax2), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("FAX2", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntFax3) Then
'        objOraParam.Add "FAX3", Trim(vntFax3), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("FAX3", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntPhone1) Then
'        objOraParam.Add "PHONE1", Trim(vntPhone1), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("PHONE1", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntPhone2) Then
'        objOraParam.Add "PHONE2", Trim(vntPhone2), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("PHONE2", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntPhone3) Then
'        objOraParam.Add "PHONE3", Trim(vntPhone3), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("PHONE3", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntEMail) Then
'        objOraParam.Add "EMAIL", Trim(vntEMail), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("EMAIL", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntZipCd1) Or Not IsMissing(vntZipCd2) Then
'        objOraParam.Add "ZIPCD1", Trim(vntZipCd1), ORAPARM_INPUT
'        objOraParam.Add "ZIPCD2", Trim(vntZipCd2), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("ZIPCD1", strColumnName, lngColumnCount)
'        Call AppendColumn("ZIPCD2", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntPrefCd) Then
'        objOraParam.Add "PREFCD", Trim(vntPrefCd), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("PREFCD", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntCityName) Then
'        objOraParam.Add "CITYNAME", StrConv(Trim(vntCityName), vbWide), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("CITYNAME", strColumnName, lngColumnCount)
'    End If
'    If Not IsEmpty(vntAddress1) Then
'        objOraParam.Add "ADDRESS1", StrConv(Trim(vntAddress1), vbWide), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("ADDRESS1", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntAddress2) Then
'        objOraParam.Add "ADDRESS2", StrConv(Trim(vntAddress2), vbWide), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("ADDRESS2", strColumnName, lngColumnCount)
'    End If
'## 2003.11.18 Del End
    If Not IsMissing(vntMarriage) Then
        objOraParam.Add "MARRIAGE", Trim(vntMarriage), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("MARRIAGE", strColumnName, lngColumnCount)
    End If
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    If Not IsMissing(vntIsrSign) Then
'        objOraParam.Add "ISRSIGN", Trim(vntIsrSign), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("ISRSIGN", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntIsrMark) Then
'        objOraParam.Add "ISRMARK", Trim(vntIsrMark), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("ISRMARK", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntHeIsrNo) Then
'        objOraParam.Add "HEISRNO", Trim(vntHeIsrNo), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("HEISRNO", strColumnName, lngColumnCount)
'    End If
'    If Not IsMissing(vntIsrDiv) Then
'        objOraParam.Add "ISRDIV", Trim(vntIsrDiv), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("ISRDIV", strColumnName, lngColumnCount)
'    End If
'## 2003.11.18 Del End
    If Not IsMissing(vntResidentNo) Then
        objOraParam.Add "RESIDENTNO", Trim(vntResidentNo), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("RESIDENTNO", strColumnName, lngColumnCount)
    End If
    If Not IsMissing(vntUnionNo) Then
        objOraParam.Add "UNIONNO", Trim(vntUnionNo), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("UNIONNO", strColumnName, lngColumnCount)
    End If
    If Not IsMissing(vntKarte) Then
        objOraParam.Add "KARTE", Trim(vntKarte), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("KARTE", strColumnName, lngColumnCount)
    End If
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    If Not IsMissing(vntEmpNo) Then
'        objOraParam.Add "EMPNO", Trim(vntEmpNo), ORAPARM_INPUT
'        '列名を配列に格納
'        Call AppendColumn("EMPNO", strColumnName, lngColumnCount)
'    End If
'## 2003.11.18 Del End
    If Not IsMissing(vntNotes) Then
        objOraParam.Add "NOTES", Trim(vntNotes), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("NOTES", strColumnName, lngColumnCount)
    End If
    If Not IsMissing(vntSpare1) Then
        objOraParam.Add "SPARE1", Trim(vntSpare1), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("SPARE1", strColumnName, lngColumnCount)
    End If
    If Not IsMissing(vntSpare2) Then
        objOraParam.Add "SPARE2", Trim(vntSpare2), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("SPARE2", strColumnName, lngColumnCount)
    End If
    If Not IsMissing(vntSpare3) Then
        objOraParam.Add "SPARE3", Trim(vntSpare3), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("SPARE3", strColumnName, lngColumnCount)
    End If
    If Not IsMissing(vntSpare4) Then
        objOraParam.Add "SPARE4", Trim(vntSpare4), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("SPARE4", strColumnName, lngColumnCount)
    End If
    If Not IsMissing(vntSpare5) Then
        objOraParam.Add "SPARE5", Trim(vntSpare5), ORAPARM_INPUT
        '列名を配列に格納
        Call AppendColumn("SPARE5", strColumnName, lngColumnCount)
    End If
    
    '個人属性レコードの挿入
    strStmt = "INSERT INTO PERSONDETAIL (   "
    If lngColumnCount = 0 Then
        strStmt = strStmt & vbLf & _
              "       PERID                 "
    Else
        strStmt = strStmt & vbLf & _
              "       PERID,                "
    End If
    For i = 0 To lngColumnCount - 1
        If i <> lngColumnCount - 1 Then
            strStmt = strStmt & vbLf & _
              "       " & Left(strColumnName(i) & "," & Space(22), 22)
        Else
            strStmt = strStmt & vbLf & _
              "       " & Left(strColumnName(i) & Space(22), 22)
        End If
    Next i

    strStmt = strStmt & vbLf & _
              "       ) VALUES (            "
    If lngColumnCount = 0 Then
        strStmt = strStmt & vbLf & _
              "       :PERID                "
    Else
        strStmt = strStmt & vbLf & _
              "       :PERID,               "
    End If
    For i = 0 To lngColumnCount - 1
        If i <> lngColumnCount - 1 Then
            strStmt = strStmt & vbLf & _
              "       " & Left(":" & strColumnName(i) & "," & Space(22), 22)
        Else
            strStmt = strStmt & vbLf & _
              "       " & Left(":" & strColumnName(i) & Space(22), 22)
        End If
    Next i
    strStmt = strStmt & vbLf & _
              "       )                     "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の設定
    UpdatePerDetail = True

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.UpdatePerDetail"
    
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

'## 2003.11.28 Add By T.Takagi@FSIT 同伴者個人ＩＤを追加
'
' 機能　　 : 同伴者個人ＩＤの相互更新
'
' 引数　　 : (In)     strPerId      個人ＩＤ
' 　　　　   (In)     strCompPerId  同伴者個人ＩＤ
'
' 戻り値　 : 1   正常終了
' 　　　　   0   個人情報が存在しない
' 　　　　   -1  異なる同伴者がすでに登録されている
' 　　　　   -2  異常終了
'
' 備考　　 :
'
Public Function UpdateCompPerId(ByVal strPerId As String, ByVal strCompPerId) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objPerId        As OraParameter     '個人ＩＤ
    
    Dim objCompPerId    As OraField         '同伴者個人ＩＤ

    Dim strCurCompPerId As String           '現在の同伴者個人ＩＤ

    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    'OraParameterオブジェクトの参照設定
    Set objPerId = objOraParam("PERID")
    
    '現在の同伴者個人ＩＤを取得するSQLステートメント作成
    strStmt = "SELECT PERSON.COMPPERID FROM PERSON WHERE PERID = :PERID"

    Do
    
        For i = 0 To 1
            
            'キー値の設定
            objPerId.Value = IIf(i = 0, strPerId, strCompPerId)
            
            '同伴者個人ＩＤの取得
            Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_NOCACHE)
        
            'レコードが存在しなければ終了
            If objOraDyna.EOF Then
                Exit Do
            End If
            
            '現在の同伴者個人ＩＤを取得
            Set objCompPerId = objOraDyna.Fields("COMPPERID")
            strCurCompPerId = objCompPerId.Value & ""
            
            'すでに指定された同伴者以外のＩＤが存在する場合は終了
            If strCurCompPerId <> "" And strCurCompPerId <> IIf(i = 0, strCompPerId, strPerId) Then
                Ret = -1
                Exit Do
            End If
            
            '同伴者個人ＩＤの更新
            objOraDyna.Edit
            objCompPerId.Value = IIf(i = 0, strCompPerId, strPerId)
            objOraDyna.Update
            
        Next i
            
        Ret = 1
        Exit Do
    Loop
        
    Set objCompPerId = Nothing
    Set objOraDyna = Nothing
    Set objPerId = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    UpdateCompPerId = Ret
    
    Exit Function
    
ErrorHandle:

    UpdateCompPerId = -2

    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCompPerId"
    
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

'## 2004.02.17 Add By H.Ishihara@FSIT 同伴者個人ＩＤ強制更新を追加
'
' 機能　　 : 同伴者個人ＩＤの相互更新２
'
' 引数　　 : (In)     strPerId      個人ＩＤ
' 　　　　   (In)     lngMode       0:NULLクリアする、1:個人IDで更新
'
' 戻り値　 : 1   正常終了
' 　　　　   -2  異常終了
'
' 備考　　 : 引数で指定された個人IDに指定されている同伴者IDの同伴者ID（ややこしい）
' 　　　　 : を更新する。
'
Private Function UpdateCompPerId2(ByVal strPerId As String, ByVal lngMode As Long) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    If lngMode = 0 Then
        objOraParam.Add "SET_COMPPERID", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    Else
        objOraParam.Add "SET_COMPPERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If

    '同伴者情報の更新
    strStmt = "UPDATE PERSON SET COMPPERID = :SET_COMPPERID WHERE PERID = (SELECT COMPPERID FROM PERSON WHERE PERID = :PERID)"
    
    'クリアの場合は、クリアする同伴者の同伴者IDが自分と同じ場合のみ
    If lngMode = 0 Then
        strStmt = strStmt & " AND COMPPERID = :PERID"
    End If
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    mobjContext.SetComplete
    
    '戻り値の設定
    UpdateCompPerId2 = 1
    
    Exit Function
    
ErrorHandle:

    UpdateCompPerId2 = -2

    'イベントログ書き込み
    WriteErrorLog "Contract.UpdateCompPerId2"
    
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
' 機能　　 : 個人ＩＤをキーに個人住所情報を更新する
'
' 引数　　 : (In)     strPerId      個人ＩＤ
' 　　　　   (In)     vntAddrDiv    住所区分
' 　　　　   (In)     vntTel        電話番号１
' 　　　　   (In)     vntPhone      携帯
' 　　　　   (In)     vntSubTel     電話番号２
' 　　　　   (In)     strExtension  内線
' 　　　　   (In)     vntFax        ＦＡＸ番号
' 　　　　   (In)     vntEMail      e-Mail
' 　　　　   (In)     vntZipCd      郵便番号
' 　　　　   (In)     strPrefCD     都道府県コード
' 　　　　   (In)     vntCityName   市区町村名
' 　　　　   (In)     vntAddress1   住所１
' 　　　　   (In)     vntAddress2   住所２
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
'## 2003.12.16 Mod By T.Takagi@FSIT 医事からの住所保持
'Public Function UpdatePerAddr(ByVal strPerId As String,
'                                Optional ByVal vntTel As Variant,
'                                Optional ByVal vntPhone As Variant,
'                                Optional ByVal vntSubTel As Variant,
'                                Optional ByVal vntExtension As Variant,
'                                Optional ByVal vntFax As Variant,
'                                Optional ByVal vntEMail As Variant,
'                                Optional ByVal vntZipCd As Variant,
'                                Optional ByVal vntPrefCd As Variant, Optional ByVal vntCityName As Variant,
'                                Optional ByVal vntAddress1 As Variant, Optional ByVal vntAddress2 As Variant
'                               ) As Boolean
Public Function UpdatePerAddr( _
    ByVal strPerId As String, _
    ByRef vntAddrDiv As Variant, _
    ByRef vntTel As Variant, _
    ByRef vntPhone As Variant, _
    ByRef vntSubTel As Variant, _
    ByRef vntExtension As Variant, _
    ByRef vntFax As Variant, _
    ByRef vntEMail As Variant, _
    ByRef vntZipCd As Variant, _
    ByRef vntPrefCd As Variant, _
    ByRef vntCityName As Variant, _
    ByRef vntAddress1 As Variant, _
    ByRef vntAddress2 As Variant _
) As Boolean
'## 2003.12.16 Mod End

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraSQLStmt   As OraSqlStmt       'OraSQLStmtオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim i               As Long             'インデックス
    
    Dim objAddrDiv      As OraParameter     '住所区分
    Dim objTel          As OraParameter     '電話番号１
    Dim objPhone        As OraParameter     '携帯
    Dim objSubTel       As OraParameter     '電話番号２
    Dim objExtension    As OraParameter     '内線
    Dim objFax          As OraParameter     'ＦＡＸ番号
    Dim objEMail        As OraParameter     'e-Mail
    Dim objZipCd        As OraParameter     '郵便番号
    Dim objPrefCd       As OraParameter     '都道府県コード
    Dim objCityName     As OraParameter     '市区町村名
    Dim objAddress1     As OraParameter     '住所１
    Dim objAddress2     As OraParameter     '住所２
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件を満たす個人住所情報テーブルのレコードを先に削除
'## 2003.12.16 Del By T.Takagi@FSIT 医事からの住所保持
'    strStmt = "DELETE FROM PERADDR " & vbLf & _
'              " WHERE PERID = :PERID    "
'
'    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'## 2003.12.16 Del End
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ADDRDIV", Null, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TEL1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PHONE", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "TEL2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EXTENSION", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FAX", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMAIL", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ZIPCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PREFCD", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CITYNAME", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDRESS1", "", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ADDRESS2", "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    'パラメータの参照設定
    Set objAddrDiv = objOraParam("ADDRDIV")
    Set objTel = objOraParam("TEL1")
    Set objPhone = objOraParam("PHONE")
    Set objSubTel = objOraParam("TEL2")
    Set objExtension = objOraParam("EXTENSION")
    Set objFax = objOraParam("FAX")
    Set objEMail = objOraParam("EMAIL")
    Set objZipCd = objOraParam("ZIPCD")
    Set objPrefCd = objOraParam("PREFCD")
    Set objCityName = objOraParam("CITYNAME")
    Set objAddress1 = objOraParam("ADDRESS1")
    Set objAddress2 = objOraParam("ADDRESS2")
            
    '個人住所情報テーブルレコードの挿入
'## 2003.12.16 Mod By T.Takagi@FSIT 医事からの住所保持
'    strStmt = "INSERT INTO PERADDR (               " & vbLf & _
'              "            PERID,                  " & vbLf & _
'              "            ADDRDIV,    TEL1,       " & vbLf & _
'              "            PHONE,      TEL2,       " & vbLf & _
'              "            EXTENSION,  FAX,        " & vbLf & _
'              "            EMAIL,                  " & vbLf & _
'              "            ZIPCD,                  " & vbLf & _
'              "            PREFCD,     CITYNAME,   " & vbLf & _
'              "            ADDRESS1,               " & vbLf & _
'              "            ADDRESS2                " & vbLf & _
'              "       ) VALUES (                   " & vbLf & _
'              "            :PERID,                 " & vbLf & _
'              "            :ADDRDIV,   :TEL1,      " & vbLf & _
'              "            :PHONE,     :TEL2,      " & vbLf & _
'              "            :EXTENSION, :FAX,       " & vbLf & _
'              "            :EMAIL,                 " & vbLf & _
'              "            :ZIPCD,                 " & vbLf & _
'              "            :PREFCD,    :CITYNAME,  " & vbLf & _
'              "            :ADDRESS1,              " & vbLf & _
'              "            :ADDRESS2               " & vbLf & _
'              "       )                            "
    strStmt = " MERGE INTO PERADDR                                     " & vbLf & _
              "       USING ( SELECT :PERID     PERID,                 " & vbLf & _
              "                      :ADDRDIV   ADDRDIV,               " & vbLf & _
              "                      :ZIPCD     ZIPCD,                 " & vbLf & _
              "                      :PREFCD    PREFCD,                " & vbLf & _
              "                      :CITYNAME  CITYNAME,              " & vbLf & _
              "                      :ADDRESS1  ADDRESS1,              " & vbLf & _
              "                      :ADDRESS2  ADDRESS2,              " & vbLf & _
              "                      :TEL1      TEL1,                  " & vbLf & _
              "                      :PHONE     PHONE,                 " & vbLf & _
              "                      :TEL2      TEL2,                  " & vbLf & _
              "                      :EXTENSION EXTENSION,             " & vbLf & _
              "                      :FAX       FAX,                   " & vbLf & _
              "                      :EMAIL     EMAIL                  " & vbLf & _
              "                 FROM DUAL                              " & vbLf & _
              "             ) BASEDPERADDR                             " & vbLf & _
              "          ON ( PERADDR.PERID   = BASEDPERADDR.PERID AND " & vbLf & _
              "               PERADDR.ADDRDIV = BASEDPERADDR.ADDRDIV ) "

    strStmt = strStmt & vbLf & _
              "        WHEN MATCHED THEN                                           " & vbLf & _
              "             UPDATE SET PERADDR.ZIPCD     = BASEDPERADDR.ZIPCD,     " & vbLf & _
              "                        PERADDR.PREFCD    = BASEDPERADDR.PREFCD,    " & vbLf & _
              "                        PERADDR.CITYNAME  = BASEDPERADDR.CITYNAME,  " & vbLf & _
              "                        PERADDR.ADDRESS1  = BASEDPERADDR.ADDRESS1,  " & vbLf & _
              "                        PERADDR.ADDRESS2  = BASEDPERADDR.ADDRESS2,  " & vbLf & _
              "                        PERADDR.TEL1      = BASEDPERADDR.TEL1,      " & vbLf & _
              "                        PERADDR.PHONE     = BASEDPERADDR.PHONE,     " & vbLf & _
              "                        PERADDR.TEL2      = BASEDPERADDR.TEL2,      " & vbLf & _
              "                        PERADDR.EXTENSION = BASEDPERADDR.EXTENSION, " & vbLf & _
              "                        PERADDR.FAX       = BASEDPERADDR.FAX,       " & vbLf & _
              "                        PERADDR.EMAIL     = BASEDPERADDR.EMAIL      "

    strStmt = strStmt & vbLf & _
              "        WHEN NOT MATCHED THEN            " & vbLf & _
              "             INSERT ( PERADDR.PERID,     " & vbLf & _
              "                      PERADDR.ADDRDIV,   " & vbLf & _
              "                      PERADDR.ZIPCD,     " & vbLf & _
              "                      PERADDR.PREFCD,    " & vbLf & _
              "                      PERADDR.CITYNAME,  " & vbLf & _
              "                      PERADDR.ADDRESS1,  " & vbLf & _
              "                      PERADDR.ADDRESS2,  " & vbLf & _
              "                      PERADDR.TEL1,      " & vbLf & _
              "                      PERADDR.PHONE,     " & vbLf & _
              "                      PERADDR.TEL2,      " & vbLf & _
              "                      PERADDR.EXTENSION, " & vbLf & _
              "                      PERADDR.FAX,       " & vbLf & _
              "                      PERADDR.EMAIL )    "

    strStmt = strStmt & vbLf & _
              "             VALUES ( BASEDPERADDR.PERID,     " & vbLf & _
              "                      BASEDPERADDR.ADDRDIV,   " & vbLf & _
              "                      BASEDPERADDR.ZIPCD,     " & vbLf & _
              "                      BASEDPERADDR.PREFCD,    " & vbLf & _
              "                      BASEDPERADDR.CITYNAME,  " & vbLf & _
              "                      BASEDPERADDR.ADDRESS1,  " & vbLf & _
              "                      BASEDPERADDR.ADDRESS2,  " & vbLf & _
              "                      BASEDPERADDR.TEL1,      " & vbLf & _
              "                      BASEDPERADDR.PHONE,     " & vbLf & _
              "                      BASEDPERADDR.TEL2,      " & vbLf & _
              "                      BASEDPERADDR.EXTENSION, " & vbLf & _
              "                      BASEDPERADDR.FAX,       " & vbLf & _
              "                      BASEDPERADDR.EMAIL )    "
'## 2003.12.16 Mod End
    
'## 2003.12.16 Mod By T.Takagi@FSIT 医事からの住所保持
'     '各配列値の挿入処理
'    For i = 0 To 2
'        '配列値の編集
'        objAddrDiv.Value = i + 1
    For i = 0 To UBound(vntAddrDiv)
        
        objAddrDiv.Value = CLng(vntAddrDiv(i))
'## 2003.12.16 Mod End
        objTel.Value = Trim(vntTel(i))
        objPhone.Value = Trim(vntPhone(i))
        objSubTel.Value = Trim(vntSubTel(i))
        objExtension.Value = Trim(vntExtension(i))
        objFax.Value = Trim(vntFax(i))
        objEMail.Value = Trim(vntEMail(i))
        objZipCd.Value = Trim(vntZipCd(i))
        objPrefCd.Value = Trim(vntPrefCd(i))
        objCityName.Value = Trim(vntCityName(i))
        objAddress1.Value = Trim(vntAddress1(i))
        objAddress2.Value = Trim(vntAddress2(i))
    
        'SQL文の実行
        If objOraSQLStmt Is Nothing Then
            Set objOraSQLStmt = mobjOraDb.CreateSql(OmitCharSpc(strStmt), ORASQL_FAILEXEC)
        Else
            objOraSQLStmt.Refresh
        End If
        
    Next i
    
'## 2003.12.16 Add By T.Takagi@FSIT 医事からの住所保持
    Set objOraSQLStmt = Nothing
    Set objAddrDiv = Nothing
    Set objTel = Nothing
    Set objPhone = Nothing
    Set objSubTel = Nothing
    Set objExtension = Nothing
    Set objFax = Nothing
    Set objEMail = Nothing
    Set objZipCd = Nothing
    Set objPrefCd = Nothing
    Set objCityName = Nothing
    Set objAddress1 = Nothing
    Set objAddress2 = Nothing
'## 2003.12.16 Add End
    
    '戻り値の設定
    UpdatePerAddr = True

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
'## 2003.12.16 Add By T.Takagi@FSIT 医事からの住所保持
    Set objOraParam = Nothing
'## 2003.12.16 Add End
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Person.UpdatePerAddr"
    
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
' 機能　　 : 個人ＩＤをキーに個人テーブルを更新する  ## 聖路加バージョン ##
'
' 引数　　 : (In)     strPerId         個人ＩＤ
' 　　　　   (In)     vntVidFlg        仮ＩＤフラグ
' 　　　　   (In)     vntDelFlg        削除フラグ
' 　　　　   (In)     vntUpdUser       更新者
' 　　　　   (In)     vntLastName      姓
' 　　　　   (In)     vntFirstName     名
' 　　　　   (In)     vntLastKName     カナ姓
' 　　　　   (In)     vntFirstKName    カナ名
' 　　　　   (In)     vntRomeName      ローマ字名
' 　　　　   (In)     vntBirth         生年月日
' 　　　　   (In)     vntGender        性別
' 　　　　   (In)     vntSpare1        予備１
' 　　　　   (In)     vntSpare2        予備２
' 　　　　   (In)     vntPostCardAddr  １年目はがき宛先
' 　　　　   (In)     vntMaidenName    旧姓
' 　　　　   (In)     vntNationCd      国籍コード
' 　　　　   (In)     vntCompPerId     同伴者ＩＤ
' 　　　　   (In)     vntCslCount      受診回数
'
' 戻り値　 : 1    正常終了
' 　　　　   0    レコードなし
' 　　　　   -1   同一団体・従業員番号のレコードが存在
' 　　　　   -2   同一健保・続柄・枝番のレコードが存在
'            -3   ユーザ情報が存在しない
'            -4   所属情報が存在しない
'            -5   続柄が存在しない
'            -6   親個人ＩＤが存在しない
'            -7   職名情報が存在しない
'            -8   職責情報が存在しない
'            -9   資格情報が存在しない
'            -10  就業措置区分が存在しない
'
' 備考
'
'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
'Public Function UpdatePerson_lukes(
'    ByVal strPerId As String,
'    Optional ByVal vntVidFlg As Variant, Optional ByVal vntDelFlg As Variant,
'    Optional ByVal vntUpdUser As Variant,
'    Optional ByVal vntLastName As Variant, Optional ByVal vntFirstName As Variant,
'    Optional ByVal vntLastKName As Variant, Optional ByVal vntFirstKName As Variant,
'    Optional ByVal vntRomeName As Variant,
'    Optional ByVal vntBirth As Variant, Optional ByVal vntGender As Variant,
'    Optional ByVal vntSpare1 As Variant, Optional ByVal vntSpare2 As Variant,
'    Optional ByVal vntPostCardAddr As Variant, Optional ByVal vntMaidenName As Variant,
'    Optional ByVal vntNationCd As Variant, Optional ByVal vntCompPerId As Variant
') As Long
Public Function UpdatePerson_lukes( _
    ByVal strPerId As String, _
    Optional ByVal vntVidFlg As Variant, Optional ByVal vntDelFlg As Variant, _
    Optional ByVal vntUpdUser As Variant, _
    Optional ByVal vntLastName As Variant, Optional ByVal vntFirstName As Variant, _
    Optional ByVal vntLastKName As Variant, Optional ByVal vntFirstKName As Variant, _
    Optional ByVal vntRomeName As Variant, _
    Optional ByVal vntBirth As Variant, Optional ByVal vntGender As Variant, _
    Optional ByVal vntSpare1 As Variant, Optional ByVal vntSpare2 As Variant, _
    Optional ByVal vntPostCardAddr As Variant, Optional ByVal vntMaidenName As Variant, _
    Optional ByVal vntNationCd As Variant, Optional ByVal vntCompPerId As Variant, _
    Optional ByVal vntCslCount As Variant _
) As Long
'## 2004.02.10 Mod End

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objCommon       As Common           '共通クラス
    Dim vntColumns      As Variant          '更新対象列の配列
    Dim Ret             As Long             '関数戻り値
    
    Dim i               As Long             'インデックス
   
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
'## 2004.02.17 Add By H.Ishihara@FSIT 同伴者個人ＩＤ強制更新を追加
    'まずはお連れ様情報をクリアする
    If UpdateCompPerId2(strPerId, 0) < 0 Then GoTo ErrorHandle
'## 2004.02.17 Add End
    
    'オブジェクトのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    If Not IsMissing(vntVidFlg) Then
        objOraParam.Add "VIDFLG", vntVidFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "VIDFLG"
    End If
    
    If Not IsMissing(vntDelFlg) Then
        objOraParam.Add "DELFLG", vntDelFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "DELFLG"
    End If
    
    If Not IsMissing(vntUpdUser) Then
        objOraParam.Add "UPDUSER", vntUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "UPDUSER"
    End If
    
    If Not IsMissing(vntLastName) Then
'## 2003.12.17 Mod by T.Takagi@FSIT 変換方法を変更
'        objOraParam.Add "LASTNAME", vntLastName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "LASTNAME", StrConv(vntLastName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
        objCommon.AppendArray vntColumns, "LASTNAME"
    End If
    
    If Not IsMissing(vntFirstName) Then
'## 2003.12.17 Mod by T.Takagi@FSIT 変換方法を変更
'        objOraParam.Add "FIRSTNAME", vntFirstName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "FIRSTNAME", StrConv(vntFirstName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
        objCommon.AppendArray vntColumns, "FIRSTNAME"
    End If
    
    If Not IsMissing(vntLastKName) Then
'## 2003.12.17 Mod by T.Takagi@FSIT 変換方法を変更
'        objOraParam.Add "LASTKNAME", vntLastKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "LASTKNAME", StrConv(vntLastKName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
        objCommon.AppendArray vntColumns, "LASTKNAME"
    End If
    
    If Not IsMissing(vntFirstKName) Then
'## 2003.12.17 Mod by T.Takagi@FSIT 変換方法を変更
'        objOraParam.Add "FIRSTKNAME", vntFirstKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "FIRSTKNAME", StrConv(vntFirstKName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.12.17 Mod End
        objCommon.AppendArray vntColumns, "FIRSTKNAME"
    End If
    
    If Not IsMissing(vntRomeName) Then
        objOraParam.Add "ROMENAME", UCase(vntRomeName), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "ROMENAME"
    End If
    
    If Not IsMissing(vntBirth) Then
        objOraParam.Add "BIRTH", vntBirth, ORAPARM_INPUT, ORATYPE_DATE
        objCommon.AppendArray vntColumns, "BIRTH"
    End If
    
    If Not IsMissing(vntGender) Then
        objOraParam.Add "GENDER", vntGender, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "GENDER"
    End If
    
    If Not IsMissing(vntSpare1) Then
        objOraParam.Add "SPARE1", vntSpare1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "SPARE1"
    End If
    
    If Not IsMissing(vntSpare2) Then
        objOraParam.Add "SPARE2", vntSpare2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "SPARE2"
    End If

    If Not IsMissing(vntPostCardAddr) Then
        objOraParam.Add "POSTCARDADDR", vntPostCardAddr, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "POSTCARDADDR"
    End If
    
    If Not IsMissing(vntMaidenName) Then
        objOraParam.Add "MAIDENNAME", vntMaidenName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "MAIDENNAME"
    End If
    
    If Not IsMissing(vntNationCd) Then
        objOraParam.Add "NATIONCD", vntNationCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "NATIONCD"
    End If
    
    If Not IsMissing(vntCompPerId) Then
        objOraParam.Add "COMPPERID", vntCompPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "COMPPERID"
    End If

'## 2004.02.10 Mod By T.Takagi@FSIT 受診回数が存在しない
    If Not IsMissing(vntCslCount) Then
        objOraParam.Add "CSLCOUNT", IIf(Not IsEmpty(vntCslCount), CLng("0" & vntCslCount), Null), ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "CSLCOUNT"
    End If
'## 2004.02.10 Mod End
    
    strStmt = "UPDATE PERSON           " & vbLf & _
              "   SET UPDDATE = SYSDATE"

    '更新項目の追加
    If Not IsEmpty(vntColumns) Then
        For i = 0 To UBound(vntColumns)
'## 2003.12.17 Del by T.Takagi@FSIT 変換方法を変更
'            If vntColumns(i) = "LASTKNAME" Or vntColumns(i) = "FIRSTKNAME" Or vntColumns(i) = "LASTNAME" Or vntColumns(i) = "FIRSTNAME" Then
'                strStmt = strStmt & ", " & vbLf & vntColumns(i) & " = TO_EDIT_ZENKAKU(:" & vntColumns(i) & ")"
'            Else
'## 2003.12.17 Del End
                strStmt = strStmt & ", " & vbLf & vntColumns(i) & " = :" & vntColumns(i)
'## 2003.12.17 Del by T.Takagi@FSIT 変換しない
'            End If
'## 2003.12.17 Del End
        Next i
    End If

    strStmt = strStmt & vbLf & _
              " WHERE PERID = :PERID"
              
    Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
    If Ret <= 0 Then
        mobjContext.SetAbort
    End If

    '戻り値の設定
    UpdatePerson_lukes = Ret

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
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
    
    Do
    
        Select Case mobjOraDb.LastServerErr
            
            'キー重複時
            Case 1
        
                Select Case True
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_INDEX1") > 0
                        Ret = -1
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_INDEX2") > 0
                        Ret = -2
                    Case Else
                        Exit Do
                End Select
    
            '外部キーエラー時
            Case 2291
        
                Select Case True
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY1") > 0
                        Ret = -3
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY2") > 0
                        Ret = -4
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY3") > 0
                        Ret = -5
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY4") > 0
                        Ret = -6
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY5") > 0
                        Ret = -7
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY6") > 0
                        Ret = -8
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY7") > 0
                        Ret = -9
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY8") > 0
                        Ret = -10
                    Case Else
                        Exit Do
                End Select
    
            Case Else
                Exit Do
        
        End Select

        UpdatePerson_lukes = Ret
        Exit Function
    Loop

    UpdatePerson_lukes = -99
    
    'イベントログ書き込み
    WriteErrorLog "Person.UpdatePerson_lukes"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 個人ＩＤをキーに個人テーブルを更新する
'
' 引数　　 : (In)     strPerId           個人ＩＤ
' 　　　　   (In)     vntVidFlg          仮ＩＤフラグ
' 　　　　   (In)     vntDelFlg          削除フラグ
' 　　　　   (In)     vntTransferDiv     出向区分
' 　　　　   (In)     vntReplicaFlg      複製フラグ
' 　　　　   (In)     vntUpdUser         更新者
' 　　　　   (In)     vntLastName        姓
' 　　　　   (In)     vntFirstName       名
' 　　　　   (In)     vntLastKName       カナ姓
' 　　　　   (In)     vntFirstKName      カナ名
' 　　　　   (In)     vntBirth           生年月日
' 　　　　   (In)     vntGender          性別
' 　　　　   (In)     vntOrgCd1          所属団体コード１
' 　　　　   (In)     vntOrgCd2          所属団体コード２
' 　　　　   (In)     vntOrgBsdCd        事業部コード
' 　　　　   (In)     vntOrgRoomCd       室部コード
' 　　　　   (In)     vntOrgPostCd       所属部署コード
' 　　　　   (In)     vntJobCd           職名コード
' 　　　　   (In)     vntDutyCd          職責コード
' 　　　　   (In)     vntQualifyCd       資格コード
' 　　　　   (In)     vntIsrSign         健保記号
' 　　　　   (In)     vntIsrNo           健保番号
' 　　　　   (In)     vntRelationCd      続柄コード
' 　　　　   (In)     vntBranchNo        枝番
' 　　　　   (In)     vntEmpNo           従業員番号
' 　　　　   (In)     vntPrimPerId       親個人ＩＤ
' 　　　　   (In)     vntLostDate        資格喪失日
' 　　　　   (In)     vntHireDate        入社年月日
' 　　　　   (In)     vntEmpDiv          従業員区分
' 　　　　   (In)     vntHongenDiv       本現区分
' 　　　　   (In)     vntWorkMeasureDiv  就業措置区分
' 　　　　   (In)     vntOverTimeDiv     超過勤務区分
' 　　　　   (In)     vntNightDutyFlg    夜勤者健診対象
' 　　　　   (In)     vntSpare1          予備１
' 　　　　   (In)     vntSpare2          予備２
'
' 戻り値　 : 1    正常終了
' 　　　　   0    レコードなし
' 　　　　   -1   同一団体・従業員番号のレコードが存在
' 　　　　   -2   同一健保・続柄・枝番のレコードが存在
'            -3   ユーザ情報が存在しない
'            -4   所属情報が存在しない
'            -5   続柄が存在しない
'            -6   親個人ＩＤが存在しない
'            -7   職名情報が存在しない
'            -8   職責情報が存在しない
'            -9   資格情報が存在しない
'            -10  就業措置区分が存在しない
'
' 備考
'
Public Function UpdatePerson( _
    ByVal strPerId As String, _
    Optional ByVal vntVidFlg As Variant, Optional ByVal vntDelFlg As Variant, _
    Optional ByVal vntTransferDiv As Variant, Optional ByVal vntReplicaFlg As Variant, _
    Optional ByVal vntUpdUser As Variant, _
    Optional ByVal vntLastName As Variant, Optional ByVal vntFirstName As Variant, _
    Optional ByVal vntLastKName As Variant, Optional ByVal vntFirstKName As Variant, _
    Optional ByVal vntBirth As Variant, Optional ByVal vntGender As Variant, _
    Optional ByVal vntOrgCd1 As Variant, Optional ByVal vntOrgCd2 As Variant, _
    Optional ByVal vntOrgBsdCd As Variant, Optional ByVal vntOrgRoomCd As Variant, _
    Optional ByVal vntOrgPostCd As Variant, Optional ByVal vntJobCd As Variant, _
    Optional ByVal vntDutyCd As Variant, Optional ByVal vntQualifyCd As Variant, _
    Optional ByVal vntIsrSign As Variant, Optional ByVal vntIsrNo As Variant, _
    Optional ByVal vntRelationCd As Variant, Optional ByVal vntBranchNo As Variant, _
    Optional ByVal vntEmpNo As Variant, Optional ByVal vntPrimPerId As Variant, _
    Optional ByVal vntLostDate As Variant, Optional ByVal vntHireDate As Variant, _
    Optional ByVal vntEmpDiv As Variant, Optional ByVal vntHongenDiv As Variant, _
    Optional ByVal vntWorkMeasureDiv As Variant, Optional ByVal vntOverTimeDiv As Variant, _
    Optional ByVal vntNightDutyFlg As Variant, _
    Optional ByVal vntSpare1 As Variant, Optional ByVal vntSpare2 As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    
    Dim objCommon       As Common           '共通クラス
    Dim vntColumns      As Variant          '更新対象列の配列
    Dim Ret             As Long             '関数戻り値
    
    Dim i               As Long             'インデックス
   
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    '日付型のデータについて、データ無しの場合は「NULL」に置き換える
    If Not IsMissing(vntHireDate) Then
        If (vntHireDate = "") Then
            vntHireDate = Null
        End If
    End If
    
    If Not IsMissing(vntLostDate) Then
        If (vntLostDate = "") Then
            vntLostDate = Null
        End If
    End If

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    If Not IsMissing(vntVidFlg) Then
        objOraParam.Add "VIDFLG", vntVidFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "VIDFLG"
    End If
    
    If Not IsMissing(vntDelFlg) Then
        objOraParam.Add "DELFLG", vntDelFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "DELFLG"
    End If
    
    If Not IsMissing(vntTransferDiv) Then
        objOraParam.Add "TRANSFERDIV", vntTransferDiv, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "TRANSFERDIV"
    End If
    
    If Not IsMissing(vntReplicaFlg) Then
        objOraParam.Add "REPLICAFLG", vntReplicaFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "REPLICAFLG"
    End If
    
    If Not IsMissing(vntUpdUser) Then
        objOraParam.Add "UPDUSER", vntUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "UPDUSER"
    End If
    
    If Not IsMissing(vntLastName) Then
        objOraParam.Add "LASTNAME", vntLastName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "LASTNAME"
    End If
    
    If Not IsMissing(vntFirstName) Then
        objOraParam.Add "FIRSTNAME", vntFirstName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "FIRSTNAME"
    End If
    
    If Not IsMissing(vntLastKName) Then
        objOraParam.Add "LASTKNAME", vntLastKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "LASTKNAME"
    End If
    
    If Not IsMissing(vntFirstKName) Then
        objOraParam.Add "FIRSTKNAME", vntFirstKName, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "FIRSTKNAME"
    End If
    
    If Not IsMissing(vntBirth) Then
        objOraParam.Add "BIRTH", vntBirth, ORAPARM_INPUT, ORATYPE_DATE
        objCommon.AppendArray vntColumns, "BIRTH"
    End If
    
    If Not IsMissing(vntGender) Then
        objOraParam.Add "GENDER", vntGender, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "GENDER"
    End If
    
    If Not IsMissing(vntOrgCd1) Then
        objOraParam.Add "ORGCD1", vntOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "ORGCD1"
    End If
    
    If Not IsMissing(vntOrgCd2) Then
        objOraParam.Add "ORGCD2", vntOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "ORGCD2"
    End If
    
    If Not IsMissing(vntOrgBsdCd) Then
        objOraParam.Add "ORGBSDCD", vntOrgBsdCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "ORGBSDCD"
    End If
    
    If Not IsMissing(vntOrgRoomCd) Then
        objOraParam.Add "ORGROOMCD", vntOrgRoomCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "ORGROOMCD"
    End If
    
    If Not IsMissing(vntOrgPostCd) Then
        objOraParam.Add "ORGPOSTCD", vntOrgPostCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "ORGPOSTCD"
    End If
    
    If Not IsMissing(vntJobCd) Then
        objOraParam.Add "JOBCD", vntJobCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "JOBCD"
    End If
    
    If Not IsMissing(vntDutyCd) Then
        objOraParam.Add "DUTYCD", vntDutyCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "DUTYCD"
    End If
    
    If Not IsMissing(vntQualifyCd) Then
        objOraParam.Add "QUALIFYCD", vntQualifyCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "QUALIFYCD"
    End If
    
    If Not IsMissing(vntIsrSign) Then
        objOraParam.Add "ISRSIGN", vntIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "ISRSIGN"
    End If
    
    If Not IsMissing(vntIsrNo) Then
        objOraParam.Add "ISRNO", vntIsrNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "ISRNO"
    End If
    
    If Not IsMissing(vntRelationCd) Then
        objOraParam.Add "RELATIONCD", vntRelationCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "RELATIONCD"
    End If
    
    If Not IsMissing(vntBranchNo) Then
        objOraParam.Add "BRANCHNO", vntBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "BRANCHNO"
    End If
    
    If Not IsMissing(vntEmpNo) Then
        objOraParam.Add "EMPNO", vntEmpNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "EMPNO"
    End If
    
    If Not IsMissing(vntPrimPerId) Then
        objOraParam.Add "PRIMPERID", vntPrimPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "PRIMPERID"
    End If
    
    If Not IsMissing(vntLostDate) Then
        objOraParam.Add "LOSTDATE", vntLostDate, ORAPARM_INPUT, ORATYPE_DATE
        objCommon.AppendArray vntColumns, "LOSTDATE"
    End If
    
    If Not IsMissing(vntHireDate) Then
        objOraParam.Add "HIREDATE", vntHireDate, ORAPARM_INPUT, ORATYPE_DATE
        objCommon.AppendArray vntColumns, "HIREDATE"
    End If
    
    If Not IsMissing(vntEmpDiv) Then
        objOraParam.Add "EMPDIV", vntEmpDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "EMPDIV"
    End If
    
    If Not IsMissing(vntHongenDiv) Then
        objOraParam.Add "HONGENDIV", vntHongenDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "HONGENDIV"
    End If
    
    If Not IsMissing(vntWorkMeasureDiv) Then
        objOraParam.Add "WORKMEASUREDIV", vntWorkMeasureDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "WORKMEASUREDIV"
    End If
    
    If Not IsMissing(vntOverTimeDiv) Then
        objOraParam.Add "OVERTIMEDIV", vntOverTimeDiv, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "OVERTIMEDIV"
    End If
    
    If Not IsMissing(vntNightDutyFlg) Then
        objOraParam.Add "NIGHTDUTYFLG", vntNightDutyFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        objCommon.AppendArray vntColumns, "NIGHTDUTYFLG"
    End If
    
    If Not IsMissing(vntSpare1) Then
        objOraParam.Add "SPARE1", vntSpare1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "SPARE1"
    End If
    
    If Not IsMissing(vntSpare2) Then
        objOraParam.Add "SPARE2", vntSpare2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objCommon.AppendArray vntColumns, "SPARE2"
    End If
    
    '個人テーブルレコードの更新
    strStmt = "UPDATE PERSON           " & vbLf & _
              "   SET UPDDATE = SYSDATE"

    '更新項目の追加
    If Not IsEmpty(vntColumns) Then
        For i = 0 To UBound(vntColumns)
            If vntColumns(i) = "LASTKNAME" Or vntColumns(i) = "FIRSTKNAME" Or vntColumns(i) = "LASTNAME" Or vntColumns(i) = "FIRSTNAME" Then
                strStmt = strStmt & ", " & vbLf & vntColumns(i) & " = TO_EDIT_ZENKAKU(:" & vntColumns(i) & ")"
            Else
                strStmt = strStmt & ", " & vbLf & vntColumns(i) & " = :" & vntColumns(i)
            End If
        Next i
    End If

    strStmt = strStmt & vbLf & _
              " WHERE PERID = :PERID"
              
    Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))
    If Ret <= 0 Then
        mobjContext.SetAbort
    End If

    '戻り値の設定
    UpdatePerson = Ret

    'キー及び更新値の設定
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
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
    
    Do
    
        Select Case mobjOraDb.LastServerErr
            
'## 2003.12.16 Del By T.Takagi@FSIT
'            'キー重複時
'            Case 1
'
'                Select Case True
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_INDEX1") > 0
'                        Ret = -1
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_INDEX2") > 0
'                        Ret = -2
'                    Case Else
'                        Exit Do
'                End Select
'## 2003.12.16 Del End
    
            '外部キーエラー時
            Case 2291
        
                Select Case True
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY1") > 0
                        Ret = -3
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY2") > 0
                        Ret = -4
                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY3") > 0
                        Ret = -5
'## 2003.12.16 Del By T.Takagi@FSIT
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY4") > 0
'                        Ret = -6
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY5") > 0
'                        Ret = -7
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY6") > 0
'                        Ret = -8
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY7") > 0
'                        Ret = -9
'                    Case InStr(mobjOraDb.LastServerErrText, "PERSON_FKEY8") > 0
'                        Ret = -10
'## 2003.12.16 Del End
                    Case Else
                        Exit Do
                End Select
    
            Case Else
                Exit Do
        
        End Select

        UpdatePerson = Ret
        Exit Function
    Loop

    UpdatePerson = -99
    
    'イベントログ書き込み
    WriteErrorLog "Person.UpdatePerson"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
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
